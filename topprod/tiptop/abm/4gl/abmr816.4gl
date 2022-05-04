# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: abmr816.4gl
# Descriptions...: 單階材料供應商明細表
# Input parameter:
# Return code....:
# Date & Author..: 92/03/20 By David
# Modify.........: 92/10/28 By Apple
# Modify.........: 93/09/10 By Apple(DEBUG)
# Modify.........: No.FUN-510033 05/02/15 By Mandy 報表轉XML
# Modify.........: No.FUN-550093 05/05/26 By kim 配方BOM
# Modify.........: No.FUN-560074 05/06/16 By pengu  CREATE TEMP TABLE 欄位放大
# Modify.........: No.TQC-5B0030 05/11/07 By Pengu 1.051103點測修改報表格式
# Modify.........: No.TQC-5B0107 05/11/12 By Pengu 報表料件、品名、規格之格式調整
# Modify.........: No.FUN-6A0081 06/11/22 By baogui 報表抬頭欄位虛線by欄位區分開
# Modify.........: No.FUN-6C0014 07/01/04 By Jackho 報表頭尾修改
# Modify.........: No.CHI-6A0034 07/01/30 By jamie abmq616->abmr816 
# Modify.........: No.FUN-780018 07/07/20 By xiaofeizhu 制作水晶報表
# Modify.........: No.FUN-7A0070 08/05/13 By jamie 1. QBE "主件料號"與"元件料號" 請增加開窗查詢功能。
#                                                  2. 特性代碼欄位，請統一移至主件料號下方顯示。
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-960403 09/06/26 By sherry 組成用量應用bmb06/bmb07得到
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.FUN-9C0077 10/01/05 By baofei 程式精簡
# Modify.........: NO.TQC-A40116 10/04/26 BY liuxqa modify sql
# Modify.........: No.FUN-B80100 11/08/11 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD				# Print condition RECORD
	       	wc  	  VARCHAR(500),	# Where condition
   		    edate DATE,   		    # 有效日期
            s         VARCHAR(3),      # Sort Sequence
   		    more	  VARCHAR(1) 		# Input more condition(Y/N)
        END RECORD
 
DEFINE   g_cnt           INTEGER
DEFINE   g_i             SMALLINT   #count/index for any purpose
DEFINE   l_table         STRING               ### FUN-780018 ###                                                                    
DEFINE   l_table1        STRING,              ### FUN-780018 ###                                                                    
         g_str           STRING,              ### FUN-780018 ###                                                                    
         g_sql           STRING               ### FUN-780018 ### 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.edate  = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80100--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r816_tm(0,0)			# Input print condition
      ELSE CALL r816()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
END MAIN
 
FUNCTION r816_tm(p_row,p_col)
   DEFINE   p_row,p_col	  SMALLINT,
            l_one         VARCHAR(01),          	#資料筆數
            l_date        DATE,              	#effective date
            l_bmb01       LIKE bmb_file.bmb01,	#
            l_bmb29       LIKE bmb_file.bmb29,  #FUN-550093
            l_cmd	  VARCHAR(1000),
            l_sql         STRING #FUN-550093
 
 
   LET p_row = 4
   LET p_col = 9
 
   OPEN WINDOW r816_w AT p_row,p_col WITH FORM "abm/42f/abmr816"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("bmb29",g_sma.sma118='Y')
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET tm.edate = g_today
   LET tm.s    = g_sma.sma65
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON bmb01,bmb03,bmb13,bmb29 #FUN-550093
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
    
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
    
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
 
         ON ACTION controlp
            CASE
              WHEN INFIELD(bmb01) #主件料件編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_bmb204"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO bmb01
                 NEXT FIELD bmb01
              
              WHEN INFIELD(bmb03) #元件料件編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_bmb203"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO bmb03
                 NEXT FIELD bmb03
            END CASE 
 
      END CONSTRUCT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r816_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      LET l_one='N'
      IF tm.wc != ' 1=1' THEN
         LET l_cmd="SELECT DISTINCT bmb01,bmb29 FROM bmb_file",
                   "  WHERE ",tm.wc CLIPPED," GROUP BY bmb01,bmb29 "
         PREPARE r816_precnt FROM l_cmd
         IF SQLCA.sqlcode THEN
            CALL cl_err('Prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
            EXIT PROGRAM
         END IF
         DECLARE r816_cnt CURSOR FOR r816_precnt
         OPEN r816_cnt
         FETCH r816_cnt INTO l_bmb01,l_bmb29
         DROP TABLE r816_cnttemp
         CREATE TEMP TABLE r816_cnttemp (
                    bmb01 LIKE bmb_file.bmb01,      
                    bmb29 LIKE bmb_file.bmb29)
         LET l_sql="INSERT INTO r816_cnttemp ",l_cmd
         PREPARE r816_cnttemp_sql FROM l_sql
         EXECUTE r816_cnttemp_sql
         SELECT COUNT(*) INTO g_cnt FROM r816_cnttemp
         IF SQLCA.sqlcode OR g_cnt IS NULL OR g_cnt = 0 THEN
            CALL cl_err(g_cnt,'mfg2601',0)   
            CONTINUE WHILE
         ELSE
            IF g_cnt=1 THEN
               LET l_one='Y'
            END IF
         END IF
      END IF
      INPUT BY NAME tm.s,tm.edate,tm.more WITHOUT DEFAULTS
 
         AFTER FIELD s
            IF tm.s IS NULL OR tm.s NOT MATCHES '[123]' THEN
               NEXT FIELD s
            END IF
 
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
            CALL cl_cmdask()	# Command execution
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r816_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='abmr816'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('abmr816','9031',1)                
         ELSE
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.s CLIPPED,"'",
                            " '",tm.edate CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('abmr816',g_time,l_cmd)	# Execute cmd at later time
         END IF
         CLOSE WINDOW r816_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r816()
      ERROR ""
   END WHILE
   CLOSE WINDOW r816_w
END FUNCTION
 

 
FUNCTION r816()
   DEFINE l_name VARCHAR(20),		# External(Disk) file name
          l_time VARCHAR(8),		# Used time for running the job
          l_use_flag    VARCHAR(2),
          l_ute_flag    VARCHAR(2),
          l_sql         STRING,    #NO.FUN-910082
          l_sql1         STRING,    #NO.FUN-910082
          l_za05 VARCHAR(40),
          l_cnt     SMALLINT,
          sr  RECORD
              order1  VARCHAR(20),
              bma01 LIKE bma_file.bma01,    # assembly part no
              bmb01 LIKE bmb_file.bmb01,    # assembly part no
              bmb02 LIKE bmb_file.bmb02,    # 項次
              bmb03 LIKE bmb_file.bmb03,    # item no
              bmb06 LIKE bmb_file.bmb06,    # QPA
              bmb13 LIKE bmb_file.bmb13,    #balloon
              ima02 LIKE ima_file.ima02,    # p name & regular
              ima05 LIKE ima_file.ima05,    # version
              ima06 LIKE ima_file.ima06,    # group code
              ima08 LIKE ima_file.ima08,    # source code
              ima55 LIKE ima_file.ima55,    # production unit
              ima63 LIKE ima_file.ima63,    # issued unit
              bma06 LIKE bma_file.bma06     #FUN-550093
          END RECORD,
          l_order	ARRAY[3] OF VARCHAR(20)
 DEFINE   l_bmb29  LIKE bmb_file.bmb29,
          l_pmh01  LIKE pmh_file.pmh01,                                                                                             
          l_pmh02  LIKE pmh_file.pmh02,                                                                                             
          l_pmh03  LIKE pmh_file.pmh03,                                                                                             
          l_pmh04  LIKE pmh_file.pmh04,                                                                                             
          l_pmh05  LIKE pmh_file.pmh05,                                                                                             
          l_pmh06  LIKE pmh_file.pmh06,                                                                                             
          l_pmh08  LIKE pmh_file.pmh08,                                                                                             
          l_pmh09  LIKE pmh_file.pmh09,                                                                                             
          l_ima02  LIKE ima_file.ima02,                                                                                             
          l_ima021 LIKE ima_file.ima021,                                                                              
          l_ima06  LIKE ima_file.ima06,                                                                                             
          l_pmc03  LIKE pmc_file.pmc03,                                                                                             
          l_pmh13  LIKE pmh_file.pmh13,                                                                                             
          l_ver    LIKE ima_file.ima05  
 
       #No.FUN-B80100--mark--Begin---
       #CALL cl_used(g_prog,l_time,1) RETURNING l_time #No.MOD-580088  HCN 20050818
       #No.FUN-B80100--mark--End-----
    LET g_sql = "bma01.bma_file.bma01,",                                                                                            
                "ima05.ima_file.ima05,",                                                                                            
                "ima08.ima_file.ima08,",                                                                                            
                "ima63.ima_file.ima63,",                                                                                            
                "bma06.bma_file.bma06,",                                                                                            
                "ima02.ima_file.ima02,",                                                                                            
                "ima55.ima_file.ima55,",                                                                                            
                "bmb02.bmb_file.bmb02,",                                                                                            
                "bmb03.bmb_file.bmb03,",                                                                                            
                "ima02a.ima_file.ima02,",                                                                                           
                "ima021a.ima_file.ima021,",                                                                                         
                "bmb06.bmb_file.bmb06,",                                                                                            
                "bmb13.bmb_file.bmb13,",                                                                                            
                "pmh02.pmh_file.pmh02,",                                                                                            
                "pmc03.pmc_file.pmc03,",                                                                                            
                "pmh04.pmh_file.pmh04,",                                                                                            
                "pmh13.pmh_file.pmh13,",                                                                                            
                "pmh03.pmh_file.pmh03,",                                                                                            
                "pmh05.pmh_file.pmh05,",
                "pmh06.pmh_file.pmh06,",                                                                                            
                "pmh08.pmh_file.pmh08,",                                                                                            
                "pmh09.pmh_file.pmh09"                                                                                            
    LET l_table = cl_prt_temptable('abmr816',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
       EXIT PROGRAM
    END IF                  # Temp Table產生                                                      
 
    LET g_sql = " bmb03.bmb_file.bmb03,",                                                                                            
                " pmh02.pmh_file.pmh02,",                                                                                            
                " pmc03.pmc_file.pmc03,",                                                                                            
                " pmh04.pmh_file.pmh04,",                                                                                            
                " pmh13.pmh_file.pmh13,",                                                                                            
                " pmh03.pmh_file.pmh03,",                                                                                            
                " pmh05.pmh_file.pmh05,",                                                                                            
                " pmh06.pmh_file.pmh06,",                                                                                            
                " pmh08.pmh_file.pmh08,",                                                                                            
                " pmh09.pmh_file.pmh09 "                                                                                             
    LET l_table1 = cl_prt_temptable('abmr8161',g_sql) CLIPPED  # 產生Temp Table                                                      
    IF l_table1 = -1 THEN
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
       EXIT PROGRAM
    END IF                  # Temp Table產生                                                      
 
 
    #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,                                                                           
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,     #TQC-A40116 mod                                                                      
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,                                                                        
                         ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                          
   PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
       EXIT PROGRAM                                                                            
    END IF 
 
     #LET g_sql = "INSERT INTO ds_report.",l_table1 CLIPPED,                                                                         
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,  #TQC-A40116 mod                                                                         
                 " VALUES(?, ?, ?, ?, ?, ?, ",                                                                          
                 "        ?, ?, ?, ?  ) "                                                                                   
     PREPARE insert_prep1 FROM g_sql                                                                                                 
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM                                                                           
     END IF                                                
 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')
 
     LET l_sql = "SELECT '',",
                 " bma01,bmb01,bmb02,bmb03,",
                 " bmb06/bmb07,bmb13,",  #TQC-960403 add 
                 " ima02,ima05,ima06,ima08,ima55,ima63,bma06", #FUN-550093
                 " FROM bma_file, ima_file, bmb_file  " ,
                 " WHERE bmb01 = bma01 AND bmb01 = ima01   ",
                 " AND bmb29=bma06 ", #FUN-550093
                 "   AND ",tm.wc
 
     #---->生效日及失效日的判斷
     IF tm.edate IS NOT NULL THEN
        LET l_sql=l_sql CLIPPED,
          " AND (bmb04 <='",tm.edate CLIPPED,"' OR bmb04 IS NULL)",
          " AND (bmb05 > '",tm.edate CLIPPED,"' OR bmb05 IS NULL)" #FUN-550093
     END IF
 
     PREPARE r816_prepare1 FROM l_sql
     DECLARE r816_c1 CURSOR FOR r816_prepare1
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-780018 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     CALL cl_del_data(l_table1)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-780018 add ###                                              
 
     LET l_cnt    = 0
     FOREACH r816_c1 INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF tm.s = '1' THEN LET sr.order1 = sr.bmb02 END IF
       IF tm.s = '2' THEN LET sr.order1 = sr.bmb03 END IF
       IF tm.s = '3' THEN LET sr.order1 = sr.bmb13 END IF
      SELECT ima02,ima021,ima06 INTO l_ima02,l_ima021,l_ima06 FROM ima_file                                                         
                  WHERE sr.bmb03 = ima01                                                                                            
      IF SQLCA.sqlcode THEN                                                                                                         
             LET l_ima02 = ' '  LET l_ima06 = ' '                                                                                   
             LET l_ima021 = ' '
      END IF
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-780018 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
                   sr.bma01,sr.ima05,sr.ima08,sr.ima63,sr.bma06,sr.ima02,sr.ima55,
                   sr.bmb02,sr.bmb03,l_ima02,l_ima021,sr.bmb06,sr.bmb13,l_pmh02,
                   l_pmc03,l_pmh04,l_pmh13,l_pmh03,l_pmh05,l_pmh06,l_pmh08,l_pmh09
 
      LET l_sql1= "SELECT ",                                                                                                        
                  " pmh01,pmh02,pmc03,pmh04,pmh03,pmh05,pmh06, ",                                                                   
                  " pmh08,pmh09,pmh13  ",                                                                                           
                  " FROM pmh_file LEFT OUTER JOIN pmc_file ON pmh02 = pmc01 " ,                                                                                
                   " WHERE pmh01 = ? ",
                  "   AND pmh21 = ' ' ",                                           #CHI-860042                                      
                  "   AND pmh23 = ' ' ",                                           #CHI-960033
                  "   AND pmh22 = '1' ",                                           #CHI-860042
                  "   AND pmhacti = 'Y'"                                           #CHI-910021                                                                             
      PREPARE r816_prepare2 FROM l_sql1                                                                                             
      IF SQLCA.sqlcode THEN                                                                                                         
         CALL cl_err('Prepare2:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
         EXIT PROGRAM                                                                      
      END IF                                                                                                                        
      DECLARE r816_c2 CURSOR FOR r816_prepare2 
      FOREACH r816_c2                                                                                                               
      USING sr.bmb03                                                                                                                
                      INTO l_pmh01,l_pmh02,l_pmc03,l_pmh04,                                                                         
                           l_pmh03,l_pmh05,l_pmh06,l_pmh08,l_pmh09,l_pmh13                                                          
            EXECUTE insert_prep1 USING sr.bmb03, l_pmh02,                                                                                       
                   l_pmc03,l_pmh04,l_pmh13,l_pmh03,l_pmh05,l_pmh06,l_pmh08,l_pmh09  
        IF SQLCA.sqlcode THEN                                                                                                       
                   EXIT FOREACH                                                                                                     
        END IF 
      END FOREACH 
     END FOREACH
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'bmb01,bmb03,bmb13,bmb29')                                                                             
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-780018 **** ##                                                        
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",                                                         
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = tm.edate,";",l_ver,";",tm.wc,";",tm.s                                                    
    CALL cl_prt_cs3('abmr816','abmr816',l_sql,g_str)                                                                                
       #No.FUN-B80100--mark--Begin---
       #CALL cl_used(g_prog,l_time,2) RETURNING l_time #No.MOD-580088  HCN 20050818
       #No.FUN-B80100--mark--End-----
END FUNCTION
 
#No.FUN-9C0077 程式精簡
