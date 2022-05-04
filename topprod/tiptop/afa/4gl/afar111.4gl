# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: afar111.4gl
# Desc/riptions..: 固定產移轉申請表
# Date & Author..: 10/08/26  No.FUN-9A0059 By vealxu 
# Modify.........: No:MOD-B30149 11/03/11 By Sarah 重過程式

DATABASE ds

GLOBALS "../../config/top.global"

    DEFINE tm  RECORD				# Print condition RECORD
       	    	wc     	LIKE type_file.chr1000,		# Where condition       
              a       LIKE type_file.chr1,        
    	        b      	LIKE type_file.chr1,         
              more    LIKE type_file.chr1         
              END RECORD,
          g_zo          RECORD LIKE zo_file.*
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  g_str      STRING

MAIN
   OPTIONS
          INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 


   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  

   LET g_sql ="fbl01.fbl_file.fbl01,",
              "fbl02.fbl_file.fbl02,",
              "fbl03.fbl_file.fbl03,",
              "fbl04.fbl_file.fbl04,",
              "fbl05.fbl_file.fbl05,",
              "fbm02.fbm_file.fbm02,",
              "fbm03.fbm_file.fbm03,",
              "fbm031.fbm_file.fbm031,",
              "faj06.faj_file.faj06,",
              "faj07.faj_file.faj07,",
              "faj08.faj_file.faj08,",
              "faj17.faj_file.faj17,",
              "faj58.faj_file.faj58,",
              "faj18.faj_file.faj18,",
              "faj26.faj_file.faj26,",
              "fap19.fap_file.fap19,",
              "fap65.fap_file.fap65,",
              "faj14.faj_file.faj14,",
              "faj141.faj_file.faj141,",
              "faj59.faj_file.faj59,",
              "faj32.faj_file.faj32,",
              "faj60.faj_file.faj60,",
              "fap17.fap_file.fap17,",
              "fap18.fap_file.fap18,",
              "fap63.fap_file.fap63,",
              "fap64.fap_file.fap64,",
              "gen02.gen_file.gen02,",
              "gem02.gem_file.gem02,",
              "azi03.azi_file.azi03"
   LET l_table = cl_prt_temptable('afar111',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF


   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r111_tm(0,0)		# Input print condition
      ELSE CALL afar111()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION r111_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE   p_row,p_col   LIKE type_file.num5,         
            l_cmd         LIKE type_file.chr1000      

   LET p_row = 4 LET p_col = 16

   OPEN WINDOW r111_w AT p_row,p_col WITH FORM "afa/42f/afar111"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()


   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Defbllt condition
   LET tm.a    = '2'
   LET tm.b    = '2'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fbl01,fbl02,fbl03,fbl04,fbl05

         BEFORE CONSTRUCT
             CALL cl_qbe_init()

      ON ACTION locale
          CALL cl_show_fld_cont()                  
         LET g_action_choice = "locale"
         EXIT CONSTRUCT

    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()    
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT

         ON ACTION qbe_select
            CALL cl_qbe_select()


 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r111_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
            
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF

      INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS
 

         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)


         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES "[123]" THEN
               NEXT FIELD a
            END IF
 
         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES "[123]" THEN
               NEXT FIELD b
            END IF
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT

      ON ACTION qbe_save
         CALL cl_qbe_save()


      END INPUT

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r111_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='afar111'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar111','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_rlang CLIPPED,"'", 
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.a CLIPPED,"'",
                            " '",tm.b CLIPPED,"'" ,
                            " '",g_rep_user CLIPPED,"'",           
                            " '",g_rep_clas CLIPPED,"'",           
                            " '",g_template CLIPPED,"'",           
                            " '",g_rpt_name CLIPPED,"'"          
            CALL cl_cmdat('afar111',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r111_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar111()
      ERROR ""
   END WHILE

   CLOSE WINDOW r111_w
END FUNCTION
 
FUNCTION afar111()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name      
          l_gem02       LIKE gem_file.gem02,           #部門名稱     
          l_gen02       LIKE gen_file.gen02,           #申請人名稱    
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT       
          l_chr		LIKE type_file.chr1,         
          l_za05	LIKE type_file.chr1000,      
          l_fblpost     LIKE fbl_file.fblpost,
          sr   RECORD
                     fbl01     LIKE fbl_file.fbl01,    #請修單號
                     fbl02     LIKE fbl_file.fbl02,    #日期
                     fbl03     LIKE fbl_file.fbl03,    #申請人
                     fbl04     LIKE fbl_file.fbl04,    #申請部門
                     fbl05     LIKE fbl_file.fbl05,    #申請日期
                     fbm02     LIKE fbm_file.fbm02,    #項次
                     fbm03     LIKE fbm_file.fbm03,    #財產編號
                     fbm031    LIKE fbm_file.fbm031,   #附號
                     faj06     LIKE faj_file.faj06,    #品名
                     faj07     LIKE faj_file.faj07,    #英文名稱
                     faj08     LIKE faj_file.faj08,    #規格
                     faj17     LIKE faj_file.faj17,    #數量
                     faj58     LIKE faj_file.faj58,    #銷帳數量
                     faj18     LIKE faj_file.faj18,    #單位
                     faj26     LIKE faj_file.faj26,    #取得日期
                     fap19     LIKE fap_file.fap19,    #原置處所
                     fap65     LIKE fap_file.fap65,    #新置處所Q
                     faj14     LIKE faj_file.faj14,    
                     faj141    LIKE faj_file.faj141,    
                     faj59     LIKE faj_file.faj59,    
                     faj32     LIKE faj_file.faj32,    
                     faj60     LIKE faj_file.faj60,    
                     fap17     LIKE fap_file.fap17,    #移出部門
                     fap18     LIKE fap_file.fap18,    #移出保管人
                     fap63     LIKE fap_file.fap63,    #移入部門
                     fap64     LIKE fap_file.fap64     #移入保管人
        END RECORD

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CALL cl_del_data(l_table)     #No.FUN-710083

   # #====>資料權限的檢查
   # IF g_priv2='4' THEN                           #只能使用自己的資料
   #     LET tm.wc = tm.wc clipped," AND fbluser = '",g_user,"'"
   # END IF
   # IF g_priv3='4' THEN                           #只能使用相同群的資料
   #     LET tm.wc = tm.wc clipped," AND fblgrup MATCHES '",g_grup CLIPPED,"*'"
   # END IF

   # IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET tm.wc = tm.wc clipped," AND fblgrup IN ",cl_chk_tgrup_list()
   # END IF

     LET l_sql = "SELECT fbl01,fbl02,fbl03,fbl04,fbl05,",
                 "       fbm02,fbm03,fbm031,",
                 "       faj06,faj07,faj08,faj17,faj58,faj18,faj26,",
                 "       '','',faj14,faj141,faj59,faj32,faj60, ",   
                 "       '','','','' ",
                 "  FROM fbl_file,fbm_file LEFT OUTER JOIN faj_file  ",
                 "    ON fbm03=faj02 AND fbm031=faj022 ",
                 " WHERE fbl01 = fbm01 ",
                 "   AND fblconf !='X' ",        
                 "   AND ",tm.wc CLIPPED

     IF tm.a='1' THEN LET l_sql=l_sql CLIPPED," AND fblconf='Y' " END IF
     IF tm.a='2' THEN LET l_sql=l_sql CLIPPED," AND fblconf='N' " END IF
     IF tm.b='1' THEN LET l_sql=l_sql CLIPPED," AND fblpost='Y' " END IF
     IF tm.b='2' THEN LET l_sql=l_sql CLIPPED," AND fblpost='N' " END IF
     PREPARE r111_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r111_cs1 CURSOR FOR r111_prepare1

     FOREACH r111_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

       LET l_fblpost = ''
       SELECT fblpost INTO l_fblpost FROM fbl_file WHERE fbl01=sr.fbl01  
       IF l_fblpost = 'Y' THEN

          SELECT fap19,fap65,fap17,fap18,fap63,fap64
            INTO sr.fap19,sr.fap65,sr.fap17,sr.fap18,sr.fap63,sr.fap64
            FROM fap_file   
           WHERE fap02=sr.fbm03 AND fap021=sr.fbm031
             AND fap03='D'      AND fap04=sr.fbl02   
       ELSE
          SELECT faj19,faj20,faj21 
            INTO sr.fap18,sr.fap17,sr.fap19
            FROM faj_file
           WHERE faj02 = sr.fbm03 AND faj022 = sr.fbm031
          SELECT fbm04,fbm05,fbm06
            INTO sr.fap64,sr.fap63,sr.fap65
            FROM fbm_file
           WHERE fbm01 = sr.fbl01 AND fbm02 = sr.fbm02
       END IF

      LET l_gen02=' '
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.fbl03
      LET l_gem02=' '
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.fbl04
      EXECUTE insert_prep USING sr.*,l_gen02,l_gem02,g_azi03

     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'fbl01,fbl02,fbl03,fbl04,fbl05')
          RETURNING tm.wc
     LET g_str = tm.wc,";",g_zz05

     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED

     CALL cl_prt_cs3('afar111','afar111',l_sql,g_str)

END FUNCTION
#NO.FUN-9A0059   #MOD-B30149
