# Prog. Version..: '5.30.03-12.09.18(00009)'     
#
# Pattern name...: ghrr018.4gl
# Descriptions...: 员工考勤日报表打印
# Date & Author..: 13/08/22   by ye'anping

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                # Print condition RECORD         #TQC-BA0010
            wc     STRING,                 #No.TQC-630166 VARCHAR(600) #Where condition
            more   LIKE type_file.chr1     #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
           END RECORD
DEFINE g_count     LIKE type_file.num5     #No.FUN-680121 SMALLINT
DEFINE g_i         LIKE type_file.num5     #No.FUN-680121 SMALLINT #count/index for any purpose
DEFINE g_msg       LIKE type_file.chr1000  #No.FUN-680121 VARCHAR(72)
DEFINE g_po_no     LIKE oea_file.oea10     #No.MOD-530401
DEFINE g_ctn_no1,g_ctn_no2   LIKE type_file.chr20         #No.FUN-680121 VARCHAR(20) #MOD-530401
DEFINE g_sql       STRING                                                   
DEFINE l_table     STRING                                                 
DEFINE g_str       STRING
DEFINE g_hrag    RECORD LIKE hrag_file.*   
DEFINE g_hrcp03    LIKE hrcp_file.hrcp03  
DEFINE g_hrao00    LIKE hrao_file.hrao00
DEFINE g_hrao10    LIKE type_file.chr1000     #added by yeap NO.130929 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway =ARG_VAL(5)
   LET g_copies =ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
   display "g_pdate  =",g_pdate
   display "g_towhom =",g_towhom
   display "g_rlang  =",g_rlang
   display "g_bgjob  =",g_bgjob
   display "g_prtway =",g_prtway
   display "g_copies =",g_copies
   display "tm.wc    =",tm.wc
   
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
 
   LET g_sql ="l_num.type_file.num5,hrat03.type_file.chr100,",
              "hrcp03.hrcp_file.hrcp03,hrat01.hrat_file.hrat01,",
              "hrat02.hrat_file.hrat02,hrat04.type_file.chr100,",
              "hrcp04.type_file.chr100,hrcp09.type_file.num5,",
              "abnormal.type_file.num5,chidao.type_file.num5,",
              "zaotui.type_file.num5,kuanggong.type_file.num5,",
              "qingjia.type_file.num5,chuchai.type_file.num5,",
              "nianjia.type_file.num5,teshujia.type_file.num5,",
              "tiaoxiujia.type_file.num5"
              

   LET l_table = cl_prt_temptable('ghrr018',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   	
   	
   IF STATUS THEN CALL cl_err('create',STATUS,1) EXIT PROGRAM END IF  #yeap

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN        # If background job sw is off
      CALL ghrr018_tm(0,0)        # Input print condition
   ELSE
      CALL ghrr018()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION ghrr018_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680121 SMALLINT
       l_dir          LIKE type_file.chr1,        #No.FUN-680121 VARCHAR(1)#Direction Flag
       l_cmd          LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(400)
      ,l_hrat03       LIKE hrat_file.hrat03
      ,l_hrcp03       LIKE hrcp_file.hrcp03
      ,l_hraa12       LIKE hraa_file.hraa12 
  LET p_row = 6 LET p_col = 20
  OPEN WINDOW ghrr018_w AT p_row,p_col WITH FORM "ghr/42f/ghrr018"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
  CALL cl_ui_init()
  CALL cl_opmsg('p')
 
  INITIALIZE tm.* TO NULL            # Default condition

  LET tm.more = 'N'
  LET g_pdate = g_today
  LET g_rlang = g_lang
  LET g_bgjob = 'N'
  LET g_copies = '1'
  
  WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON hrat03,hrat04,hrcp03

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       DISPLAY g_today TO FORMONLY.hrcp03
          
       AFTER FIELD hrat03
          LET l_hrat03 = GET_FLDBUF(hrat03)
          IF cl_null(l_hrat03) THEN 
          	 NEXT FIELD hrat03
          ELSE
          	 LET g_hrao00 = l_hrat03
          	 LET l_hrcp03 = GET_FLDBUF(hrcp03)
              IF cl_null(l_hrcp03) THEN 
          	     NEXT FIELD hrcp03
          	  ELSE 
          	     LET g_hrcp03 = l_hrcp03
              END IF
          END IF 
       
       AFTER FIELD hrcp03
          LET l_hrcp03 = GET_FLDBUF(hrcp03)
          IF cl_null(l_hrcp03) THEN 
          	 NEXT FIELD hrcp03
          ELSE 
          	 LET g_hrcp03 = l_hrcp03
          END IF
       
       AFTER FIELD hrat04
         LET g_hrao10 = GET_FLDBUF(hrat04) 
         LET l_hrcp03 = GET_FLDBUF(hrcp03)   
          IF cl_null(l_hrcp03) THEN 
          	 NEXT FIELD hrcp03
          ELSE 
          	 LET g_hrcp03 = l_hrcp03
          END IF
          	 	
       ON ACTION controlp
          CASE 
              WHEN INFIELD(hrat03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat03
                 NEXT FIELD hrat03
                 
             WHEN INFIELD(hrat04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hrao01"
               LET g_qryparam.arg1 = l_hrat03  
               LET g_qryparam.state = "c"  #added by yeap NO.130929 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrat04
               NEXT FIELD hrat04
              OTHERWISE
                 EXIT CASE
           END CASE
 
       ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          EXIT CONSTRUCT
  
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
  
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT CONSTRUCT
 
       #No.FUN-580031 --start--
       ON ACTION qbe_select
          CALL cl_qbe_select()
       #No.FUN-580031 ---end---
 
    END CONSTRUCT
 
    IF g_action_choice = "locale" THEN
       LET g_action_choice = ""
       CALL cl_dynamic_locale()
       CONTINUE WHILE
    END IF
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       EXIT WHILE
    END IF
 
    IF tm.wc=" 1=1 " THEN
       CALL cl_err(' ','9046',0)
       CONTINUE WHILE
    END IF
    DISPLAY BY NAME tm.more                  
    INPUT BY NAME tm.more WITHOUT DEFAULTS  
       
       BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
       AFTER FIELD more
          IF tm.more = 'Y' THEN
             CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG 
          CALL cl_cmdask()    # Command execution
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
 
       #No.FUN-580031 --start--
       ON ACTION qbe_save
          CALL cl_qbe_save()
       #No.FUN-580031 ---end---
 
    END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       EXIT WHILE
    END IF
 
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
              WHERE zz01='ghrr018'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('ghrr018','9031',1)  
       ELSE
          LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
          LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                          " '",g_pdate CLIPPED,"'",
                          " '",g_towhom CLIPPED,"'",
                          #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                          " '",g_bgjob CLIPPED,"'",
                          " '",g_prtway CLIPPED,"'",
                          " '",g_copies CLIPPED,"'",
                          " '",tm.wc CLIPPED,"'",               #FUN-750047 add
                       #   " '",g_argv1 CLIPPED,"'",
                       #   " '",g_argv2 CLIPPED,"'"
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
          CALL cl_cmdat('ghrr018',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW ghrr018_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
    END IF
 
    CALL cl_wait()
    CALL ghrr018()
    ERROR ""
  END WHILE
 
  CLOSE WINDOW ghrr018_w
END FUNCTION
 
FUNCTION ghrr018()
   DEFINE l_name    LIKE type_file.chr20,             #No.FUN-680121 VARCHAR(20)# External(Disk) file name
          l_sql     STRING,                           # RDSQL STATEMENT   TQC-630166
          l_chr     LIKE type_file.chr1,              #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,           #No.FUN-680121 VARCHAR(40)
          l_sfb02doc LIKE type_file.chr30,            #No:TQC-A60097 add
          sr        RECORD
                     hrat01      LIKE hrat_file.hrat01,
                     hrat02      LIKE hrat_file.hrat02,
                     hrat03      LIKE type_file.chr100,
                     hrat04      LIKE type_file.chr100,
                     hrat05      LIKE hrat_file.hrat05,
                     hrcp01      LIKE hrcp_file.hrcp01,
                     hrcp03      LIKE hrcp_file.hrcp03,
                     hrcp04      LIKE type_file.chr100,
                     hrcp09      LIKE type_file.chr100,
                     hrcp10      LIKE hrcp_file.hrcp10,
                     hrcp11      LIKE hrcp_file.hrcp11,
                     hrcp12      LIKE hrcp_file.hrcp12,
                     hrcp13      LIKE hrcp_file.hrcp13,
                     hrcp14      LIKE hrcp_file.hrcp14,
                     hrcp15      LIKE hrcp_file.hrcp15,
                     hrcp16      LIKE hrcp_file.hrcp16,
                     hrcp17      LIKE hrcp_file.hrcp17,
                     hrcp18      LIKE hrcp_file.hrcp18,
                     hrcp19      LIKE hrcp_file.hrcp19
                    END RECORD,
       sr1           RECORD
                     hrao00      LIKE hrao_file.hrao00, 
                     hrao01      LIKE hrao_file.hrao01
                    END RECORD


   DEFINE l_hraa12  LIKE hraa_file.hraa12,
          l_hrao02  LIKE hrao_file.hrao02,
          l_hrbb00  LIKE hrbb_file.hrbb00
   DEFINE l_fdm,l_fdf,l_fim,l_fif LIKE type_file.num5  #foreign,direct/indirect,male/female
   DEFINE l_ldfm,l_ldff,l_ldpm,l_ldpf,l_lifm,l_liff,l_lipm,l_lipf LIKE type_file.num5  #local,direct/indirect,formal/probation,male/female
   DEFINE l_n   LIKE type_file.num5

   DEFINE  l_img_blob    LIKE type_file.blob
   DEFINE  l_abnormal    LIKE type_file.num5
   DEFINE  l_chidao      LIKE type_file.num5
   DEFINE  l_zaotui      LIKE type_file.num5  	
   DEFINE  l_kuanggong   LIKE type_file.num5
   DEFINE  l_qingjia     LIKE type_file.num5
   DEFINE  l_chuchai     LIKE type_file.num5
   DEFINE  l_nianjia     LIKE type_file.num5
   DEFINE  l_teshujia    LIKE type_file.num5
   DEFINE  l_tiaoxiujia  LIKE type_file.num5



   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

   CALL cl_del_data(l_table) 
   
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?) "
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
   
   
   LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-940042
   #------------------------------ CR (2) ------------------------------#

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup')


   IF tm.wc.getIndexOf("hrat04",1) THEN 
      LET g_hrao10 = cl_replace_str(g_hrao10,'|',"','")   #added by yeap NO.130929
      LET l_sql = " SELECT DISTINCT hrao00,hrao01 FROM hrao_file ",
                  "  WHERE   hraoacti='Y' AND hrao05 = 'N' AND hrao10 is NULL AND hrao00 = '",g_hrao00,"' AND hrao01 IN ('",g_hrao10,"') "
      PREPARE r011_p FROM l_sql 
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('ghrr011_p:',SQLCA.sqlcode,1)
              CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
              EXIT PROGRAM
           END IF
      DECLARE r011_curs CURSOR FOR r011_p 
      LET l_n = 0
      FOREACH r011_curs INTO sr1.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
          	 
           LET l_sql = " SELECT DISTINCT hrat01,hrat02,hrat03,hrat04,hrat05,hrcp01,hrcp03,hrbo03,hrcp09, ",
       	                               " hrcp10,hrcp11,hrcp12,hrcp13,hrcp14,hrcp15,hrcp16,hrcp17,hrcp18,hrcp19 ", 
       	               "   FROM hrat_file,hrcp_file,hrbo_file ", 
       	               "  WHERE hratid = hrcp02 AND hratacti = 'Y' ",
       	               "    AND hratconf = 'Y' AND hrcpacti = 'Y' ",
   	                   "    AND hrcpconf = 'Y' AND hrbo06 = 'N' ", 
       	               "    AND hrbo02 = hrcp04 AND hrat03 = '",g_hrao00,"' AND hrat04 = '",sr1.hrao01,"' AND hrcp03 ='",g_hrcp03,"'"
       	              
       	   LET l_sql = l_sql,"  ORDER BY hrat01 "
       	   PREPARE r018_p1 FROM l_sql 
                IF SQLCA.sqlcode != 0 THEN
                   CALL cl_err('ghrr018_p1:',SQLCA.sqlcode,1)
                   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
                   EXIT PROGRAM
                END IF
           DECLARE r018_curs1 CURSOR FOR r018_p1
           FOREACH r018_curs1 INTO sr.*
                IF SQLCA.sqlcode != 0 THEN
                   CALL cl_err('foreach:',SQLCA.sqlcode,1)
                   EXIT FOREACH
                END IF
     
            SELECT hraa12 INTO sr.hrat03 FROM hraa_file WHERE hraa01 = sr.hrat03
            SELECT hrap02 INTO sr.hrat04 FROM hrap_file WHERE hrap01 = sr.hrat04 AND hrap05 = sr.hrat05  #部门名称 
       
            LET l_abnormal = 0
     	      LET l_chidao = 0
     	      LET l_zaotui = 0   	
   	        LET l_kuanggong = 0
            LET l_qingjia = 0
            LET l_chuchai = 0
            LET l_nianjia = 0
            LET l_teshujia = 0
            LET l_tiaoxiujia = 0
         
          
            CASE sr.hrcp10
     	    WHEN '015'   LET l_abnormal = sr.hrcp11 + l_abnormal
     	    WHEN '016'   LET l_abnormal = sr.hrcp11 + l_abnormal
     	    WHEN '017'   LET l_abnormal = sr.hrcp11 + l_abnormal
     	    WHEN '001'   LET l_chidao = sr.hrcp11 + l_chidao
     	    WHEN '022'   LET l_chidao = sr.hrcp11 + l_chidao
     	    WHEN '002'   LET l_zaotui = sr.hrcp11 + l_zaotui  
     	    WHEN '024'   LET l_zaotui = sr.hrcp11 + l_zaotui 	
   	      WHEN '003'   LET l_kuanggong = sr.hrcp11 + l_kuanggong
   	      WHEN '004'   LET l_kuanggong = sr.hrcp11 + l_kuanggong
   	      WHEN '023'   LET l_kuanggong = sr.hrcp11 + l_kuanggong
          WHEN '005'   LET l_qingjia = sr.hrcp11 + l_qingjia
          WHEN '006'   LET l_qingjia = sr.hrcp11 + l_qingjia
          WHEN '007'   LET l_qingjia = sr.hrcp11 + l_qingjia
          WHEN '008'   LET l_chuchai = sr.hrcp11 + l_chuchai
          WHEN '009'   LET l_chuchai = sr.hrcp11 + l_chuchai
          WHEN '010'   LET l_nianjia = sr.hrcp11 + l_nianjia
          WHEN '011'   LET l_nianjia = sr.hrcp11 + l_nianjia
          WHEN '021'   LET l_nianjia = sr.hrcp11 + l_nianjia
          WHEN '020'   LET l_teshujia = sr.hrcp11 + l_teshujia
          WHEN '026'   LET l_teshujia = sr.hrcp11 + l_teshujia
          WHEN '025'   LET l_tiaoxiujia = sr.hrcp11 + l_tiaoxiujia
       END CASE 
     	
       CASE sr.hrcp12
     	    WHEN '015'   LET l_abnormal = sr.hrcp13 + l_abnormal
     	    WHEN '016'   LET l_abnormal = sr.hrcp13 + l_abnormal
     	    WHEN '017'   LET l_abnormal = sr.hrcp13 + l_abnormal
     	    WHEN '001'   LET l_chidao = sr.hrcp13 + l_chidao
     	    WHEN '022'   LET l_chidao = sr.hrcp13 + l_chidao
     	    WHEN '002'   LET l_zaotui = sr.hrcp13 + l_zaotui  
     	    WHEN '024'   LET l_zaotui = sr.hrcp13 + l_zaotui 	
   	      WHEN '003'   LET l_kuanggong = sr.hrcp13 + l_kuanggong
   	      WHEN '004'   LET l_kuanggong = sr.hrcp13 + l_kuanggong
   	      WHEN '023'   LET l_kuanggong = sr.hrcp13 + l_kuanggong
          WHEN '005'   LET l_qingjia = sr.hrcp13 + l_qingjia
          WHEN '006'   LET l_qingjia = sr.hrcp13 + l_qingjia
          WHEN '007'   LET l_qingjia = sr.hrcp13 + l_qingjia
          WHEN '008'   LET l_chuchai = sr.hrcp13 + l_chuchai
          WHEN '009'   LET l_chuchai = sr.hrcp13 + l_chuchai
          WHEN '010'   LET l_nianjia = sr.hrcp13 + l_nianjia
          WHEN '011'   LET l_nianjia = sr.hrcp13 + l_nianjia
          WHEN '021'   LET l_nianjia = sr.hrcp13 + l_nianjia
          WHEN '020'   LET l_teshujia = sr.hrcp13 + l_teshujia
          WHEN '026'   LET l_teshujia = sr.hrcp13 + l_teshujia
          WHEN '025'   LET l_tiaoxiujia = sr.hrcp13 + l_tiaoxiujia
       END CASE 
     
       CASE sr.hrcp14
       	  WHEN '015'   LET l_abnormal = sr.hrcp15 + l_abnormal
     	    WHEN '016'   LET l_abnormal = sr.hrcp15 + l_abnormal
     	    WHEN '017'   LET l_abnormal = sr.hrcp15 + l_abnormal
     	    WHEN '001'   LET l_chidao = sr.hrcp15 + l_chidao
     	    WHEN '022'   LET l_chidao = sr.hrcp15 + l_chidao
     	    WHEN '002'   LET l_zaotui = sr.hrcp15 + l_zaotui  
     	    WHEN '024'   LET l_zaotui = sr.hrcp15 + l_zaotui 	
   	      WHEN '003'   LET l_kuanggong = sr.hrcp15 + l_kuanggong
   	      WHEN '004'   LET l_kuanggong = sr.hrcp15 + l_kuanggong
   	      WHEN '023'   LET l_kuanggong = sr.hrcp15 + l_kuanggong
          WHEN '005'   LET l_qingjia = sr.hrcp15 + l_qingjia
          WHEN '006'   LET l_qingjia = sr.hrcp15 + l_qingjia
          WHEN '007'   LET l_qingjia = sr.hrcp15 + l_qingjia
          WHEN '008'   LET l_chuchai = sr.hrcp15 + l_chuchai
          WHEN '009'   LET l_chuchai = sr.hrcp15 + l_chuchai
          WHEN '010'   LET l_nianjia = sr.hrcp15 + l_nianjia
          WHEN '011'   LET l_nianjia = sr.hrcp15 + l_nianjia
          WHEN '021'   LET l_nianjia = sr.hrcp15 + l_nianjia
          WHEN '020'   LET l_teshujia = sr.hrcp15 + l_teshujia
          WHEN '026'   LET l_teshujia = sr.hrcp15 + l_teshujia
          WHEN '025'   LET l_tiaoxiujia = sr.hrcp15 + l_tiaoxiujia
       END CASE
     
       CASE sr.hrcp16
       	  WHEN '015'   LET l_abnormal = sr.hrcp17 + l_abnormal
     	    WHEN '016'   LET l_abnormal = sr.hrcp17 + l_abnormal
     	    WHEN '017'   LET l_abnormal = sr.hrcp17 + l_abnormal
     	    WHEN '001'   LET l_chidao = sr.hrcp17 + l_chidao
     	    WHEN '022'   LET l_chidao = sr.hrcp17 + l_chidao
     	    WHEN '002'   LET l_zaotui = sr.hrcp17 + l_zaotui  
     	    WHEN '024'   LET l_zaotui = sr.hrcp17 + l_zaotui 	
   	      WHEN '003'   LET l_kuanggong = sr.hrcp17 + l_kuanggong
   	      WHEN '004'   LET l_kuanggong = sr.hrcp17 + l_kuanggong
   	      WHEN '023'   LET l_kuanggong = sr.hrcp17 + l_kuanggong
          WHEN '005'   LET l_qingjia = sr.hrcp17 + l_qingjia
          WHEN '006'   LET l_qingjia = sr.hrcp17 + l_qingjia
          WHEN '007'   LET l_qingjia = sr.hrcp17 + l_qingjia
          WHEN '008'   LET l_chuchai = sr.hrcp17 + l_chuchai
          WHEN '009'   LET l_chuchai = sr.hrcp17 + l_chuchai
          WHEN '010'   LET l_nianjia = sr.hrcp17 + l_nianjia
          WHEN '011'   LET l_nianjia = sr.hrcp17 + l_nianjia
          WHEN '021'   LET l_nianjia = sr.hrcp17 + l_nianjia
          WHEN '020'   LET l_teshujia = sr.hrcp17 + l_teshujia
          WHEN '026'   LET l_teshujia = sr.hrcp17 + l_teshujia
          WHEN '025'   LET l_tiaoxiujia = sr.hrcp17 + l_tiaoxiujia
       END CASE 
     	
       CASE sr.hrcp18
       	  WHEN '015'   LET l_abnormal = sr.hrcp19 + l_abnormal
     	    WHEN '016'   LET l_abnormal = sr.hrcp19 + l_abnormal
     	    WHEN '017'   LET l_abnormal = sr.hrcp19 + l_abnormal
     	    WHEN '001'   LET l_chidao = sr.hrcp19 + l_chidao
     	    WHEN '022'   LET l_chidao = sr.hrcp19 + l_chidao
     	    WHEN '002'   LET l_zaotui = sr.hrcp19 + l_zaotui  
     	    WHEN '024'   LET l_zaotui = sr.hrcp19 + l_zaotui 	
   	      WHEN '003'   LET l_kuanggong = sr.hrcp19 + l_kuanggong
   	      WHEN '004'   LET l_kuanggong = sr.hrcp19 + l_kuanggong
   	      WHEN '023'   LET l_kuanggong = sr.hrcp19 + l_kuanggong
          WHEN '005'   LET l_qingjia = sr.hrcp19 + l_qingjia
          WHEN '006'   LET l_qingjia = sr.hrcp19 + l_qingjia
          WHEN '007'   LET l_qingjia = sr.hrcp19 + l_qingjia
          WHEN '008'   LET l_chuchai = sr.hrcp19 + l_chuchai
          WHEN '009'   LET l_chuchai = sr.hrcp19 + l_chuchai
          WHEN '010'   LET l_nianjia = sr.hrcp19 + l_nianjia
          WHEN '011'   LET l_nianjia = sr.hrcp19 + l_nianjia
          WHEN '021'   LET l_nianjia = sr.hrcp19 + l_nianjia
          WHEN '020'   LET l_teshujia = sr.hrcp19 + l_teshujia
          WHEN '026'   LET l_teshujia = sr.hrcp19 + l_teshujia
          WHEN '025'   LET l_tiaoxiujia = sr.hrcp19 + l_tiaoxiujia
       END CASE
          
         	
            LET l_n = l_n + 1	
            EXECUTE insert_prep USING 
                   l_n,sr.hrat03,sr.hrcp03,sr.hrat01,sr.hrat02,sr.hrat04,sr.hrcp04,sr.hrcp09,
                   l_abnormal,l_chidao,l_zaotui,l_kuanggong,l_qingjia,l_chuchai,l_nianjia,
                   l_teshujia,l_tiaoxiujia
                 
           END FOREACH 
      END FOREACH     
     
     LET l_sql = " SELECT DISTINCT hrat01,hrat02,hrat03,hrat04,hrat05,hrcp01,hrcp03,hrbo03,hrcp09, ",
   	                              " hrcp10,hrcp11,hrcp12,hrcp13,hrcp14,hrcp15,hrcp16,hrcp17,hrcp18,hrcp19 ", 
   	              "   FROM hrat_file,hrcp_file,hrbo_file ", 
   	              "  WHERE hratid = hrcp02 AND hratacti = 'Y' ",
   	              "    AND hratconf = 'Y' AND hrcpacti = 'Y' ",
   	              "    AND hrcpconf = 'Y' AND hrbo06 = 'N' ",   
   	              "    AND hrbo02 = hrcp04 AND ",tm.wc CLIPPED 
   	              
   	 LET l_sql = l_sql,"  ORDER BY hrat01 "
   	 PREPARE r018_p2 FROM l_sql 
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('ghrr018_p2:',SQLCA.sqlcode,1)
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
             EXIT PROGRAM
          END IF
     DECLARE r018_curs2 CURSOR FOR r018_p2
      
     FOREACH r018_curs2 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
     
       SELECT hraa12 INTO sr.hrat03 FROM hraa_file WHERE hraa01 = sr.hrat03
       SELECT hrap02 INTO sr.hrat04 FROM hrap_file WHERE hrap01 = sr.hrat04 AND hrap05 = sr.hrat05  #部门名称 
     
       
       LET l_abnormal = 0
     	 LET l_chidao = 0
     	 LET l_zaotui = 0   	
   	   LET l_kuanggong = 0
       LET l_qingjia = 0
       LET l_chuchai = 0
       LET l_nianjia = 0
       LET l_teshujia = 0
       LET l_tiaoxiujia = 0
       
       CASE sr.hrcp10
     	    WHEN '015'   LET l_abnormal = sr.hrcp11 + l_abnormal
     	    WHEN '016'   LET l_abnormal = sr.hrcp11 + l_abnormal
     	    WHEN '017'   LET l_abnormal = sr.hrcp11 + l_abnormal
     	    WHEN '001'   LET l_chidao = sr.hrcp11 + l_chidao
     	    WHEN '022'   LET l_chidao = sr.hrcp11 + l_chidao
     	    WHEN '002'   LET l_zaotui = sr.hrcp11 + l_zaotui  
     	    WHEN '024'   LET l_zaotui = sr.hrcp11 + l_zaotui 	
   	      WHEN '003'   LET l_kuanggong = sr.hrcp11 + l_kuanggong
   	      WHEN '004'   LET l_kuanggong = sr.hrcp11 + l_kuanggong
   	      WHEN '023'   LET l_kuanggong = sr.hrcp11 + l_kuanggong
          WHEN '005'   LET l_qingjia = sr.hrcp11 + l_qingjia
          WHEN '006'   LET l_qingjia = sr.hrcp11 + l_qingjia
          WHEN '007'   LET l_qingjia = sr.hrcp11 + l_qingjia
          WHEN '008'   LET l_chuchai = sr.hrcp11 + l_chuchai
          WHEN '009'   LET l_chuchai = sr.hrcp11 + l_chuchai
          WHEN '010'   LET l_nianjia = sr.hrcp11 + l_nianjia
          WHEN '011'   LET l_nianjia = sr.hrcp11 + l_nianjia
          WHEN '021'   LET l_nianjia = sr.hrcp11 + l_nianjia
          WHEN '020'   LET l_teshujia = sr.hrcp11 + l_teshujia
          WHEN '026'   LET l_teshujia = sr.hrcp11 + l_teshujia
          WHEN '025'   LET l_tiaoxiujia = sr.hrcp11 + l_tiaoxiujia
       END CASE 
     	
       CASE sr.hrcp12
     	    WHEN '015'   LET l_abnormal = sr.hrcp13 + l_abnormal
     	    WHEN '016'   LET l_abnormal = sr.hrcp13 + l_abnormal
     	    WHEN '017'   LET l_abnormal = sr.hrcp13 + l_abnormal
     	    WHEN '001'   LET l_chidao = sr.hrcp13 + l_chidao
     	    WHEN '022'   LET l_chidao = sr.hrcp13 + l_chidao
     	    WHEN '002'   LET l_zaotui = sr.hrcp13 + l_zaotui  
     	    WHEN '024'   LET l_zaotui = sr.hrcp13 + l_zaotui 	
   	      WHEN '003'   LET l_kuanggong = sr.hrcp13 + l_kuanggong
   	      WHEN '004'   LET l_kuanggong = sr.hrcp13 + l_kuanggong
   	      WHEN '023'   LET l_kuanggong = sr.hrcp13 + l_kuanggong
          WHEN '005'   LET l_qingjia = sr.hrcp13 + l_qingjia
          WHEN '006'   LET l_qingjia = sr.hrcp13 + l_qingjia
          WHEN '007'   LET l_qingjia = sr.hrcp13 + l_qingjia
          WHEN '008'   LET l_chuchai = sr.hrcp13 + l_chuchai
          WHEN '009'   LET l_chuchai = sr.hrcp13 + l_chuchai
          WHEN '010'   LET l_nianjia = sr.hrcp13 + l_nianjia
          WHEN '011'   LET l_nianjia = sr.hrcp13 + l_nianjia
          WHEN '021'   LET l_nianjia = sr.hrcp13 + l_nianjia
          WHEN '020'   LET l_teshujia = sr.hrcp13 + l_teshujia
          WHEN '026'   LET l_teshujia = sr.hrcp13 + l_teshujia
          WHEN '025'   LET l_tiaoxiujia = sr.hrcp13 + l_tiaoxiujia
       END CASE 
     
       CASE sr.hrcp14
       	  WHEN '015'   LET l_abnormal = sr.hrcp15 + l_abnormal
     	    WHEN '016'   LET l_abnormal = sr.hrcp15 + l_abnormal
     	    WHEN '017'   LET l_abnormal = sr.hrcp15 + l_abnormal
     	    WHEN '001'   LET l_chidao = sr.hrcp15 + l_chidao
     	    WHEN '022'   LET l_chidao = sr.hrcp15 + l_chidao
     	    WHEN '002'   LET l_zaotui = sr.hrcp15 + l_zaotui  
     	    WHEN '024'   LET l_zaotui = sr.hrcp15 + l_zaotui 	
   	      WHEN '003'   LET l_kuanggong = sr.hrcp15 + l_kuanggong
   	      WHEN '004'   LET l_kuanggong = sr.hrcp15 + l_kuanggong
   	      WHEN '023'   LET l_kuanggong = sr.hrcp15 + l_kuanggong
          WHEN '005'   LET l_qingjia = sr.hrcp15 + l_qingjia
          WHEN '006'   LET l_qingjia = sr.hrcp15 + l_qingjia
          WHEN '007'   LET l_qingjia = sr.hrcp15 + l_qingjia
          WHEN '008'   LET l_chuchai = sr.hrcp15 + l_chuchai
          WHEN '009'   LET l_chuchai = sr.hrcp15 + l_chuchai
          WHEN '010'   LET l_nianjia = sr.hrcp15 + l_nianjia
          WHEN '011'   LET l_nianjia = sr.hrcp15 + l_nianjia
          WHEN '021'   LET l_nianjia = sr.hrcp15 + l_nianjia
          WHEN '020'   LET l_teshujia = sr.hrcp15 + l_teshujia
          WHEN '026'   LET l_teshujia = sr.hrcp15 + l_teshujia
          WHEN '025'   LET l_tiaoxiujia = sr.hrcp15 + l_tiaoxiujia
       END CASE
     
       CASE sr.hrcp16
       	  WHEN '015'   LET l_abnormal = sr.hrcp17 + l_abnormal
     	    WHEN '016'   LET l_abnormal = sr.hrcp17 + l_abnormal
     	    WHEN '017'   LET l_abnormal = sr.hrcp17 + l_abnormal
     	    WHEN '001'   LET l_chidao = sr.hrcp17 + l_chidao
     	    WHEN '022'   LET l_chidao = sr.hrcp17 + l_chidao
     	    WHEN '002'   LET l_zaotui = sr.hrcp17 + l_zaotui  
     	    WHEN '024'   LET l_zaotui = sr.hrcp17 + l_zaotui 	
   	      WHEN '003'   LET l_kuanggong = sr.hrcp17 + l_kuanggong
   	      WHEN '004'   LET l_kuanggong = sr.hrcp17 + l_kuanggong
   	      WHEN '023'   LET l_kuanggong = sr.hrcp17 + l_kuanggong
          WHEN '005'   LET l_qingjia = sr.hrcp17 + l_qingjia
          WHEN '006'   LET l_qingjia = sr.hrcp17 + l_qingjia
          WHEN '007'   LET l_qingjia = sr.hrcp17 + l_qingjia
          WHEN '008'   LET l_chuchai = sr.hrcp17 + l_chuchai
          WHEN '009'   LET l_chuchai = sr.hrcp17 + l_chuchai
          WHEN '010'   LET l_nianjia = sr.hrcp17 + l_nianjia
          WHEN '011'   LET l_nianjia = sr.hrcp17 + l_nianjia
          WHEN '021'   LET l_nianjia = sr.hrcp17 + l_nianjia
          WHEN '020'   LET l_teshujia = sr.hrcp17 + l_teshujia
          WHEN '026'   LET l_teshujia = sr.hrcp17 + l_teshujia
          WHEN '025'   LET l_tiaoxiujia = sr.hrcp17 + l_tiaoxiujia
       END CASE 
     	
       CASE sr.hrcp18
       	  WHEN '015'   LET l_abnormal = sr.hrcp19 + l_abnormal
     	    WHEN '016'   LET l_abnormal = sr.hrcp19 + l_abnormal
     	    WHEN '017'   LET l_abnormal = sr.hrcp19 + l_abnormal
     	    WHEN '001'   LET l_chidao = sr.hrcp19 + l_chidao
     	    WHEN '022'   LET l_chidao = sr.hrcp19 + l_chidao
     	    WHEN '002'   LET l_zaotui = sr.hrcp19 + l_zaotui  
     	    WHEN '024'   LET l_zaotui = sr.hrcp19 + l_zaotui 	
   	      WHEN '003'   LET l_kuanggong = sr.hrcp19 + l_kuanggong
   	      WHEN '004'   LET l_kuanggong = sr.hrcp19 + l_kuanggong
   	      WHEN '023'   LET l_kuanggong = sr.hrcp19 + l_kuanggong
          WHEN '005'   LET l_qingjia = sr.hrcp19 + l_qingjia
          WHEN '006'   LET l_qingjia = sr.hrcp19 + l_qingjia
          WHEN '007'   LET l_qingjia = sr.hrcp19 + l_qingjia
          WHEN '008'   LET l_chuchai = sr.hrcp19 + l_chuchai
          WHEN '009'   LET l_chuchai = sr.hrcp19 + l_chuchai
          WHEN '010'   LET l_nianjia = sr.hrcp19 + l_nianjia
          WHEN '011'   LET l_nianjia = sr.hrcp19 + l_nianjia
          WHEN '021'   LET l_nianjia = sr.hrcp19 + l_nianjia
          WHEN '020'   LET l_teshujia = sr.hrcp19 + l_teshujia
          WHEN '026'   LET l_teshujia = sr.hrcp19 + l_teshujia
          WHEN '025'   LET l_tiaoxiujia = sr.hrcp19 + l_tiaoxiujia
       END CASE
      
     	
       LET l_n = l_n + 1	
       EXECUTE insert_prep USING 
               l_n,sr.hrat03,sr.hrcp03,sr.hrat01,sr.hrat02,sr.hrat04,sr.hrcp04,sr.hrcp09,
               l_abnormal,l_chidao,l_zaotui,l_kuanggong,l_qingjia,l_chuchai,l_nianjia,
               l_teshujia,l_tiaoxiujia
             
     END FOREACH

  ELSE
  	 LET l_sql = " SELECT DISTINCT hrat01,hrat02,hrat03,hrat04,hrat05,hrcp01,hrcp03,hrbo03,hrcp09, ",
   	                              " hrcp10,hrcp11,hrcp12,hrcp13,hrcp14,hrcp15,hrcp16,hrcp17,hrcp18,hrcp19 ", 
   	              "   FROM hrat_file,hrcp_file,hrbo_file ", 
   	              "  WHERE hratid = hrcp02 AND hratacti = 'Y' ",
   	              "    AND hratconf = 'Y' AND hrcpacti = 'Y' ",
   	              "    AND hrcpconf = 'Y' AND hrbo06 = 'N' ", 
   	              "    AND hrbo02 = hrcp04 AND ",tm.wc CLIPPED 
   	              
   	 LET l_sql = l_sql,"  ORDER BY hrat01 "
   	 PREPARE r018_p FROM l_sql 
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('ghrr018_p:',SQLCA.sqlcode,1)
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
             EXIT PROGRAM
          END IF
     DECLARE r018_curs CURSOR FOR r018_p
     LET l_n = 0
     FOREACH r018_curs INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
     
       SELECT hraa12 INTO sr.hrat03 FROM hraa_file WHERE hraa01 = sr.hrat03
       SELECT hrap02 INTO sr.hrat04 FROM hrap_file WHERE hrap01 = sr.hrat04 AND hrap05 = sr.hrat05  #部门名称 
       
       LET l_abnormal = 0
     	 LET l_chidao = 0
     	 LET l_zaotui = 0   	
   	   LET l_kuanggong = 0
       LET l_qingjia = 0
       LET l_chuchai = 0
       LET l_nianjia = 0
       LET l_teshujia = 0
       LET l_tiaoxiujia = 0
       
      
       CASE sr.hrcp10
     	    WHEN '015'   LET l_abnormal = sr.hrcp11 + l_abnormal
     	    WHEN '016'   LET l_abnormal = sr.hrcp11 + l_abnormal
     	    WHEN '017'   LET l_abnormal = sr.hrcp11 + l_abnormal
     	    WHEN '001'   LET l_chidao = sr.hrcp11 + l_chidao
     	    WHEN '022'   LET l_chidao = sr.hrcp11 + l_chidao
     	    WHEN '002'   LET l_zaotui = sr.hrcp11 + l_zaotui  
     	    WHEN '024'   LET l_zaotui = sr.hrcp11 + l_zaotui 	
   	      WHEN '003'   LET l_kuanggong = sr.hrcp11 + l_kuanggong
   	      WHEN '004'   LET l_kuanggong = sr.hrcp11 + l_kuanggong
   	      WHEN '023'   LET l_kuanggong = sr.hrcp11 + l_kuanggong
          WHEN '005'   LET l_qingjia = sr.hrcp11 + l_qingjia
          WHEN '006'   LET l_qingjia = sr.hrcp11 + l_qingjia
          WHEN '007'   LET l_qingjia = sr.hrcp11 + l_qingjia
          WHEN '008'   LET l_chuchai = sr.hrcp11 + l_chuchai
          WHEN '009'   LET l_chuchai = sr.hrcp11 + l_chuchai
          WHEN '010'   LET l_nianjia = sr.hrcp11 + l_nianjia
          WHEN '011'   LET l_nianjia = sr.hrcp11 + l_nianjia
          WHEN '021'   LET l_nianjia = sr.hrcp11 + l_nianjia
          WHEN '020'   LET l_teshujia = sr.hrcp11 + l_teshujia
          WHEN '026'   LET l_teshujia = sr.hrcp11 + l_teshujia
          WHEN '025'   LET l_tiaoxiujia = sr.hrcp11 + l_tiaoxiujia
       END CASE 
     	
       CASE sr.hrcp12
     	    WHEN '015'   LET l_abnormal = sr.hrcp13 + l_abnormal
     	    WHEN '016'   LET l_abnormal = sr.hrcp13 + l_abnormal
     	    WHEN '017'   LET l_abnormal = sr.hrcp13 + l_abnormal
     	    WHEN '001'   LET l_chidao = sr.hrcp13 + l_chidao
     	    WHEN '022'   LET l_chidao = sr.hrcp13 + l_chidao
     	    WHEN '002'   LET l_zaotui = sr.hrcp13 + l_zaotui  
     	    WHEN '024'   LET l_zaotui = sr.hrcp13 + l_zaotui 	
   	      WHEN '003'   LET l_kuanggong = sr.hrcp13 + l_kuanggong
   	      WHEN '004'   LET l_kuanggong = sr.hrcp13 + l_kuanggong
   	      WHEN '023'   LET l_kuanggong = sr.hrcp13 + l_kuanggong
          WHEN '005'   LET l_qingjia = sr.hrcp13 + l_qingjia
          WHEN '006'   LET l_qingjia = sr.hrcp13 + l_qingjia
          WHEN '007'   LET l_qingjia = sr.hrcp13 + l_qingjia
          WHEN '008'   LET l_chuchai = sr.hrcp13 + l_chuchai
          WHEN '009'   LET l_chuchai = sr.hrcp13 + l_chuchai
          WHEN '010'   LET l_nianjia = sr.hrcp13 + l_nianjia
          WHEN '011'   LET l_nianjia = sr.hrcp13 + l_nianjia
          WHEN '021'   LET l_nianjia = sr.hrcp13 + l_nianjia
          WHEN '020'   LET l_teshujia = sr.hrcp13 + l_teshujia
          WHEN '026'   LET l_teshujia = sr.hrcp13 + l_teshujia
          WHEN '025'   LET l_tiaoxiujia = sr.hrcp13 + l_tiaoxiujia
       END CASE 
     
       CASE sr.hrcp14
       	  WHEN '015'   LET l_abnormal = sr.hrcp15 + l_abnormal
     	    WHEN '016'   LET l_abnormal = sr.hrcp15 + l_abnormal
     	    WHEN '017'   LET l_abnormal = sr.hrcp15 + l_abnormal
     	    WHEN '001'   LET l_chidao = sr.hrcp15 + l_chidao
     	    WHEN '022'   LET l_chidao = sr.hrcp15 + l_chidao
     	    WHEN '002'   LET l_zaotui = sr.hrcp15 + l_zaotui  
     	    WHEN '024'   LET l_zaotui = sr.hrcp15 + l_zaotui 	
   	      WHEN '003'   LET l_kuanggong = sr.hrcp15 + l_kuanggong
   	      WHEN '004'   LET l_kuanggong = sr.hrcp15 + l_kuanggong
   	      WHEN '023'   LET l_kuanggong = sr.hrcp15 + l_kuanggong
          WHEN '005'   LET l_qingjia = sr.hrcp15 + l_qingjia
          WHEN '006'   LET l_qingjia = sr.hrcp15 + l_qingjia
          WHEN '007'   LET l_qingjia = sr.hrcp15 + l_qingjia
          WHEN '008'   LET l_chuchai = sr.hrcp15 + l_chuchai
          WHEN '009'   LET l_chuchai = sr.hrcp15 + l_chuchai
          WHEN '010'   LET l_nianjia = sr.hrcp15 + l_nianjia
          WHEN '011'   LET l_nianjia = sr.hrcp15 + l_nianjia
          WHEN '021'   LET l_nianjia = sr.hrcp15 + l_nianjia
          WHEN '020'   LET l_teshujia = sr.hrcp15 + l_teshujia
          WHEN '026'   LET l_teshujia = sr.hrcp15 + l_teshujia
          WHEN '025'   LET l_tiaoxiujia = sr.hrcp15 + l_tiaoxiujia
       END CASE
     
       CASE sr.hrcp16
       	  WHEN '015'   LET l_abnormal = sr.hrcp17 + l_abnormal
     	    WHEN '016'   LET l_abnormal = sr.hrcp17 + l_abnormal
     	    WHEN '017'   LET l_abnormal = sr.hrcp17 + l_abnormal
     	    WHEN '001'   LET l_chidao = sr.hrcp17 + l_chidao
     	    WHEN '022'   LET l_chidao = sr.hrcp17 + l_chidao
     	    WHEN '002'   LET l_zaotui = sr.hrcp17 + l_zaotui  
     	    WHEN '024'   LET l_zaotui = sr.hrcp17 + l_zaotui 	
   	      WHEN '003'   LET l_kuanggong = sr.hrcp17 + l_kuanggong
   	      WHEN '004'   LET l_kuanggong = sr.hrcp17 + l_kuanggong
   	      WHEN '023'   LET l_kuanggong = sr.hrcp17 + l_kuanggong
          WHEN '005'   LET l_qingjia = sr.hrcp17 + l_qingjia
          WHEN '006'   LET l_qingjia = sr.hrcp17 + l_qingjia
          WHEN '007'   LET l_qingjia = sr.hrcp17 + l_qingjia
          WHEN '008'   LET l_chuchai = sr.hrcp17 + l_chuchai
          WHEN '009'   LET l_chuchai = sr.hrcp17 + l_chuchai
          WHEN '010'   LET l_nianjia = sr.hrcp17 + l_nianjia
          WHEN '011'   LET l_nianjia = sr.hrcp17 + l_nianjia
          WHEN '021'   LET l_nianjia = sr.hrcp17 + l_nianjia
          WHEN '020'   LET l_teshujia = sr.hrcp17 + l_teshujia
          WHEN '026'   LET l_teshujia = sr.hrcp17 + l_teshujia
          WHEN '025'   LET l_tiaoxiujia = sr.hrcp17 + l_tiaoxiujia
       END CASE 
     	
       CASE sr.hrcp18
       	  WHEN '015'   LET l_abnormal = sr.hrcp19 + l_abnormal
     	    WHEN '016'   LET l_abnormal = sr.hrcp19 + l_abnormal
     	    WHEN '017'   LET l_abnormal = sr.hrcp19 + l_abnormal
     	    WHEN '001'   LET l_chidao = sr.hrcp19 + l_chidao
     	    WHEN '022'   LET l_chidao = sr.hrcp19 + l_chidao
     	    WHEN '002'   LET l_zaotui = sr.hrcp19 + l_zaotui  
     	    WHEN '024'   LET l_zaotui = sr.hrcp19 + l_zaotui 	
   	      WHEN '003'   LET l_kuanggong = sr.hrcp19 + l_kuanggong
   	      WHEN '004'   LET l_kuanggong = sr.hrcp19 + l_kuanggong
   	      WHEN '023'   LET l_kuanggong = sr.hrcp19 + l_kuanggong
          WHEN '005'   LET l_qingjia = sr.hrcp19 + l_qingjia
          WHEN '006'   LET l_qingjia = sr.hrcp19 + l_qingjia
          WHEN '007'   LET l_qingjia = sr.hrcp19 + l_qingjia
          WHEN '008'   LET l_chuchai = sr.hrcp19 + l_chuchai
          WHEN '009'   LET l_chuchai = sr.hrcp19 + l_chuchai
          WHEN '010'   LET l_nianjia = sr.hrcp19 + l_nianjia
          WHEN '011'   LET l_nianjia = sr.hrcp19 + l_nianjia
          WHEN '021'   LET l_nianjia = sr.hrcp19 + l_nianjia
          WHEN '020'   LET l_teshujia = sr.hrcp19 + l_teshujia
          WHEN '026'   LET l_teshujia = sr.hrcp19 + l_teshujia
          WHEN '025'   LET l_tiaoxiujia = sr.hrcp19 + l_tiaoxiujia
       END CASE
      
     	
       LET l_n = l_n + 1	
       EXECUTE insert_prep USING 
               l_n,sr.hrat03,sr.hrcp03,sr.hrat01,sr.hrat02,sr.hrat04,sr.hrcp04,sr.hrcp09,
               l_abnormal,l_chidao,l_zaotui,l_kuanggong,l_qingjia,l_chuchai,l_nianjia,
               l_teshujia,l_tiaoxiujia
             
     END FOREACH
    END IF 

   
      

 
    LET g_str=''
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('ghrr018','ghrr018',l_sql,g_str)
   
END FUNCTiON      
