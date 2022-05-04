# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: afag114.4gl
# Descriptions...: 資產類別異動單
# Date & Author..: 12/01/12 FUN-BC0035 By Sakura
# Modify.........: No.FUN-C60048 12/06/15 By nanbing 憑證類CR報表轉成GR
DATABASE ds

GLOBALS "../../config/top.global"

    DEFINE tm  RECORD				# Print condition RECORD
       	    	wc     	STRING,
                a       LIKE type_file.chr1,
    	        b    	LIKE type_file.chr1,
                more    LIKE type_file.chr1
                END RECORD,
                g_zo    RECORD LIKE zo_file.*
DEFINE  g_i        LIKE type_file.num5
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  g_str      STRING
###GENGRE###START
TYPE sr1_t RECORD
    fbx01 LIKE fbx_file.fbx01,
    fbx02 LIKE fbx_file.fbx02,
    fbx03 LIKE fbx_file.fbx03,
    fbx04 LIKE fbx_file.fbx04,
    fbx05 LIKE fbx_file.fbx05,
    fby02 LIKE fby_file.fby02,
    fby03 LIKE fby_file.fby03,
    fby031 LIKE fby_file.fby031,
    faj06 LIKE faj_file.faj06,
    fby04 LIKE fby_file.fby04,
    fby05 LIKE fby_file.fby05,
    fby052 LIKE fby_file.fby052,
    fby06 LIKE fby_file.fby06,
    fby062 LIKE fby_file.fby062,
    fby07 LIKE fby_file.fby07,
    fby072 LIKE fby_file.fby072,
    fby08 LIKE fby_file.fby08,
    fby09 LIKE fby_file.fby09,
    fby092 LIKE fby_file.fby092,
    fby10 LIKE fby_file.fby10,
    fby102 LIKE fby_file.fby102,
    fby11 LIKE fby_file.fby11,
    fby112 LIKE fby_file.fby112,
    l_gen02 LIKE gen_file.gen02,
    l_gem02 LIKE gem_file.gem02,
    l_faa31 LIKE faa_file.faa31
     #FUN-C60048------add------str----
    ,sign_type LIKE type_file.chr1,
    sign_img LIKE type_file.blob,
    sign_show LIKE type_file.chr1,
    sign_str LIKE type_file.chr1000
    #FUN-C60048------add------end----
END RECORD
###GENGRE###END

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


   LET g_pdate = ARG_VAL(1)
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

   LET g_sql ="fbx01.fbx_file.fbx01,",
              "fbx02.fbx_file.fbx02,",
              "fbx03.fbx_file.fbx03,",
              "fbx04.fbx_file.fbx04,",
              "fbx05.fbx_file.fbx05,",
              "fby02.fby_file.fby02,",
              "fby03.fby_file.fby03,",
              "fby031.fby_file.fby031,",
              "faj06.faj_file.faj06,",
              "fby04.fby_file.fby04,",
              "fby05.fby_file.fby05,",
              "fby052.fby_file.fby052,",
              "fby06.fby_file.fby06,",
              "fby062.fby_file.fby062,",
              "fby07.fby_file.fby07,",
              "fby072.fby_file.fby072,",
              "fby08.fby_file.fby08,",
              "fby09.fby_file.fby09,",
              "fby092.fby_file.fby092,",
              "fby10.fby_file.fby10,",
              "fby102.fby_file.fby102,",
              "fby11.fby_file.fby11,",
              "fby112.fby_file.fby112,",
              "l_gen02.gen_file.gen02,",
              "l_gem02.gem_file.gem02,",
              "l_faa31.faa_file.faa31"
             #FUN-C60048------add------str----
             ,",sign_type.type_file.chr1,   sign_img.type_file.blob,",   #簽核方式, 簽核圖檔
              "sign_show.type_file.chr1,  sign_str.type_file.chr1000" 
               #FUN-C60048------add------end----
   LET l_table = cl_prt_temptable('afag114',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?,   ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?, ?,   ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?, ?,   ?, ?, ?, ?, ?)" #FUN-C60048 add 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r114_tm(0,0)		    # Input print condition
      ELSE CALL afag114()		        # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)  #FUN-C60048 add
END MAIN

FUNCTION r114_tm(p_row,p_col)
   DEFINE   lc_qbe_sn     LIKE gbm_file.gbm01
   DEFINE   p_row,p_col   LIKE type_file.num5,
            l_cmd         LIKE type_file.chr1000

   LET p_row = 4 LET p_col = 16

   OPEN WINDOW r114_w AT p_row,p_col WITH FORM "afa/42f/afag114"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Defaslt condition
   LET tm.a    = '3'
   LET tm.b    = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fbx01,fbx02,fbx03,fbx04,fbx05
         BEFORE CONSTRUCT
             CALL cl_qbe_init()

      ON ACTION controlp
            CASE
               WHEN INFIELD(fbx01)    #異動單號
                    CALL cl_init_qry_var()
                    LET g_qryparam.state= "c"
                    LET g_qryparam.form = "q_fbx"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fbx01
                    NEXT FIELD fbx01
               WHEN INFIELD(fbx03)    #申請人員
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.where = "genacti='Y'"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fbx03
                    NEXT FIELD fbx03
               WHEN INFIELD(fbx04)    #申請部門
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.where = "gemacti='Y'"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fbx04
                    NEXT FIELD fbx04
               OTHERWISE EXIT CASE
            END CASE             

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

      ON ACTION EXIT
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
         LET INT_FLAG = 0 CLOSE WINDOW r114_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)  #FUN-C60048 add
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
         LET INT_FLAG = 0 CLOSE WINDOW r114_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         CALL cl_gre_drop_temptable(l_table)  #FUN-C60048 add
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='afag114'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afag114','9031',1)
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
            CALL cl_cmdat('afag114',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r114_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)  #FUN-C60048 add
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afag114()
      ERROR ""
   END WHILE

   CLOSE WINDOW r114_w
END FUNCTION
 
FUNCTION afag114()
   DEFINE l_name	LIKE type_file.chr20,
          l_gem02   LIKE gem_file.gem02,           #部門名稱
          l_gen02   LIKE gen_file.gen02,           #申請人名稱
          l_sql 	STRING,
          l_chr		LIKE type_file.chr1,
          l_za05	LIKE type_file.chr1000,
          l_faa31   LIKE faa_file.faa031,
          sr   RECORD
                     fbx01     LIKE fbx_file.fbx01,    #請修單號
                     fbx02     LIKE fbx_file.fbx02,    #日期
                     fbx03     LIKE fbx_file.fbx03,    #申請人
                     fbx04     LIKE fbx_file.fbx04,    #申請部門
                     fbx05     LIKE fbx_file.fbx05,    #申請日期
                     fby02     LIKE fby_file.fby02,    #項次
                     fby03     LIKE fby_file.fby03,    #財產編號
                     fby031    LIKE fby_file.fby031,   #附號
                     faj06     LIKE faj_file.faj06,    #品名
                     fby04     LIKE fby_file.fby04,    #異動前資產類別
                     fby05     LIKE fby_file.fby05,    #異動前資產科目
                     fby052    LIKE fby_file.fby052,   #異動前資產科目(財簽二)
                     fby06     LIKE fby_file.fby06,    #異動前累折科目
                     fby062    LIKE fby_file.fby062,   #異動前累折科目(財簽二)
                     fby07     LIKE fby_file.fby07,    #異動前折舊科目
                     fby072    LIKE fby_file.fby072,   #異動前折舊科目(財簽二)
                     fby08     LIKE fby_file.fby08,    #異動後資產類別
                     fby09     LIKE fby_file.fby09,    #異動後資產科目
                     fby092    LIKE fby_file.fby092,   #異動後資產科目(財簽二)
                     fby10     LIKE fby_file.fby10,    #異動後累折科目
                     fby102    LIKE fby_file.fby102,   #異動後累折科目(財簽二)
                     fby11     LIKE fby_file.fby11,    #異動後折舊科目
                     fby112    LIKE fby_file.fby112    #異動後折舊科目(財簽二)
        END RECORD
     DEFINE l_img_blob     LIKE type_file.blob    #FUN-C60048 add		

     LOCATE l_img_blob    IN MEMORY               #FUN-C60048 add
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CALL cl_del_data(l_table)

     #====>資料權限的檢查
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fbxuser', 'fbxgrup')
     
  LET l_sql = "SELECT fbx01,fbx02,fbx03,fbx04,fbx05,",
                 "    fby02,fby03,fby031,faj06,",
                 "    fby04,fby05,fby052,fby06,fby062,fby07,fby072,",
                 "    fby08,fby09,fby092,fby10,fby102,fby11,fby112",
                 "  FROM fbx_file,fby_file ", 
                 "  LEFT OUTER JOIN faj_file ON fby03=faj02 AND fby031=faj022 ",
                 " WHERE fbx01 = fby01 ",
                 "   AND ",tm.wc CLIPPED

     IF tm.a='1' THEN LET l_sql=l_sql CLIPPED," AND fbxconf='Y' " END IF
     IF tm.a='2' THEN LET l_sql=l_sql CLIPPED," AND fbxconf='N' " END IF
     IF tm.b='1' THEN LET l_sql=l_sql CLIPPED," AND fbxpost='Y' " END IF
     IF tm.b='2' THEN LET l_sql=l_sql CLIPPED," AND fbxpost='N' " END IF
     PREPARE r114_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table)  #FUN-C60048 add
        EXIT PROGRAM
           
     END IF
     DECLARE r114_cs1 CURSOR FOR r114_prepare1
     FOREACH r114_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       
      LET l_gen02 = ' '
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.fbx03
      LET l_gem02 = ' '
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.fbx04
      LET l_faa31 = ' '
      SELECT faa31 INTO l_faa31 FROM faa_file
      
      EXECUTE insert_prep USING sr.*,l_gen02,l_gem02,l_faa31
                                ,"",l_img_blob,"N",""   #FUN-C60048 add
     END FOREACH
     
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'fbx01,fbx02,fbx03,fbx04,fbx05')
          RETURNING tm.wc
###GENGRE###     LET g_str = tm.wc,";",g_zz05
     
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###     CALL cl_prt_cs3('afag114','afag114',l_sql,g_str)
    LET g_cr_table = l_table                   #主報表的temp table名稱        #FUN-C60048 add
    LET g_cr_apr_key_f = "fbx01"         #報表主鍵欄位名稱，用"|"隔開   #FUN-C60048 add
    CALL afag114_grdata()    ###GENGRE###
END FUNCTION
#FUN-BC0035



###GENGRE###START
FUNCTION afag114_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    LOCATE sr1.sign_img IN MEMORY   #FUN-C60048
    CALL cl_gre_init_apr()          #FUN-C60048  
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("afag114")
        IF handler IS NOT NULL THEN
            START REPORT afag114_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY fbx01,fby02 " #FUN-C60048 add        
            DECLARE afag114_datacur1 CURSOR FROM l_sql
            FOREACH afag114_datacur1 INTO sr1.*
                OUTPUT TO REPORT afag114_rep(sr1.*)
            END FOREACH
            FINISH REPORT afag114_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT afag114_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5

    
    ORDER EXTERNAL BY sr1.fbx01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.fbx01
            LET l_lineno = 0

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.fbx01

        
        ON LAST ROW

END REPORT
###GENGRE###END
