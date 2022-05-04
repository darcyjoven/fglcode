# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aapr741.4gl
# Descriptions...: 預購修改付款憑証列印作業
# Date & Author..: No.FUN-860090 08/06/26  By sherry 
# Modify.........: No.FUN-980017 09/08/27 By destiny 把alaplant該為ala97 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No.TQC-C10034 12/01/18 By zhuhao 報表簽核處理 
# Modify.........: No.TQC-BC0013 12/02/10 By Elise 加入外幣、本幣支付銀行說明
# Modify.........: No.CHI-C80041 12/12/19 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   
              wc      STRING,                            # Where condition   
              more    LIKE type_file.chr1                # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i         LIKE type_file.num5   
DEFINE   g_sma116    LIKE sma_file.sma116     
DEFINE   g_sma115    LIKE sma_file.sma115      
DEFINE   g_sql       STRING                                                                                                        
DEFINE   l_table     STRING                                                                                                        
DEFINE   g_str       STRING                                                                                                        
DEFINE   l_title1    STRING                                                                                                        
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 mark 
   
 # LET g_sql= "alaplant.ala_file.alaplant,",                   #No.FUN-980017
   LET g_sql= "ala97.ala_file.ala97,",                         #No.FUN-980017
              "alc01.alc_file.alc01,",
              "ala04.ala_file.ala04,",
              "gem02.gem_file.gem02,", 
              "ala930.ala_file.ala930,",
              "gem02b.gem_file.gem02,",
              "alc24.alc_file.alc24,",
              "alc80.alc_file.alc80,",
              "alc08.alc_file.alc08,",
              "ala20.ala_file.ala20,",
              "alc51.alc_file.alc51,",
              "alc79.alc_file.alc79,",
              "alc02.alc_file.alc02,",
              "alcfirm.alc_file.alcfirm,",
              "alc78.alc_file.alc78,",
              "alc74.alc_file.alc74,",
              "ala21.ala_file.ala21,",
              "alc81.alc_file.alc81,",
              "alc82.alc_file.alc82,",
              "alc84.alc_file.alc84,",
              "alc34.alc_file.alc34,",
              "alc85.alc_file.alc85,",
              "alc91.alc_file.alc91,",
              "alc92.alc_file.alc92,",
              "alc94.alc_file.alc94,",
              "alc951.alc_file.alc951,",
              "alc952.alc_file.alc952,",
              "alc953.alc_file.alc953,",
              "alc95.alc_file.alc95,",
              "alc96.alc_file.alc96,",
              "nmc02.nmc_file.nmc02,",
              "alc83.alc_file.alc83,",
              "alc931.alc_file.alc931,",
              "alc76.alc_file.alc76,",
              "alc932.alc_file.alc932,",
              "alc93.alc_file.alc93,",
              "t_azi04.azi_file.azi04,",
              "t_azi07.azi_file.azi07,",
              #TQC-C10034---add---begin
              "sign_type.type_file.chr1,", 
              "sign_img.type_file.blob,",      
              "sign_show.type_file.chr1,",
              "sign_str.type_file.chr1000,",
              #TQC-C10034---add---end
              "l_alc81.nma_file.nma02,",      #TQC-BC0013 add
              "l_alc91.nma_file.nma02"        #TQC-BC0013 add              
   LET l_table = cl_prt_temptable('aapr741',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",                                                                                     
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?)"     #TQC-C10034 add 4?   #TQC-BC0013 add ?,?                                                                                         
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
                                                                                                                                    
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add 
   LET g_pdate = ARG_VAL(1)           
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r741_tm(0,0)              # Input print condition
      ELSE CALL r741()                    # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
END MAIN
 
FUNCTION r741_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col    LIKE type_file.num5,   
          l_cmd        LIKE type_file.chr1000 
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW r741_w AT p_row,p_col
        WITH FORM "aap/42f/aapr741"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition                                                        
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON alc01,alc80,alc79,ala04
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
      LET INT_FLAG = 0 CLOSE WINDOW r741_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
 
   INPUT BY NAME 
                 tm.more
                 WITHOUT DEFAULTS
 
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
 
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r741_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file   
             WHERE zz01='aapr741'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aapr741','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,       
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", 
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",         
                         " '",g_rep_clas CLIPPED,"'",          
                         " '",g_template CLIPPED,"'",         
                         " '",g_rpt_name CLIPPED,"'"          
         CALL cl_cmdat('aapr741',g_time,l_cmd)    
      END IF
      CLOSE WINDOW r741_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r741()
   ERROR ""
END WHILE
   CLOSE WINDOW r741_w
END FUNCTION
 
FUNCTION r741()
   DEFINE l_name    LIKE type_file.chr20,      
          l_sql     STRING,                
#         sr        RECORD alaplant LIKE ala_file.alaplant,              #No.FUN-980017
          sr        RECORD ala97    LIKE ala_file.ala97,                 #No.FUN-980017
                           alc01 LIKE alc_file.alc01,
                           ala04 LIKE ala_file.ala04,
                           gem02 LIKE gem_file.gem02, 
                           ala930 LIKE ala_file.ala930,
                           gem02b LIKE gem_file.gem02,
                           alc24 LIKE alc_file.alc24,
                           alc80 LIKE alc_file.alc80,
                           alc08 LIKE alc_file.alc08,
                           ala20 LIKE ala_file.ala20,
                           alc51 LIKE alc_file.alc51,
                           alc79 LIKE alc_file.alc79,
                           alc02 LIKE alc_file.alc02,
                           alcfirm LIKE alc_file.alcfirm,
                           alc78 LIKE alc_file.alc78,
                           alc74 LIKE alc_file.alc74,
                           ala21 LIKE ala_file.ala21,
                           alc81 LIKE alc_file.alc81,
                           alc82 LIKE alc_file.alc82,
                           alc84 LIKE alc_file.alc84,
                           alc34 LIKE alc_file.alc34,
                           alc85 LIKE alc_file.alc85,
                           alc91 LIKE alc_file.alc91,
                           alc92 LIKE alc_file.alc92,
                           alc94 LIKE alc_file.alc94,
                           alc951 LIKE alc_file.alc951,
                           alc952 LIKE alc_file.alc952,
                           alc953 LIKE alc_file.alc953,
                           alc95 LIKE alc_file.alc95,
                           alc96 LIKE alc_file.alc96,
                           nmc02 LIKE nmc_file.nmc02,
                           alc83 LIKE alc_file.alc83,
                           alc931 LIKE alc_file.alc931,
                           alc76 LIKE alc_file.alc76,
                           alc932 LIKE alc_file.alc932,
                           alc93 LIKE alc_file.alc93,
                           t_azi04 LIKE azi_file.azi04,
                           t_azi07 LIKE azi_file.azi07  
                      END RECORD
     DEFINE l_alc81 LIKE nma_file.nma02   #TQC-BC0013
     DEFINE l_alc91 LIKE nma_file.nma02   #TQC-BC0013  
     #TQC-C10034--add--begin
     DEFINE l_img_blob     LIKE type_file.blob
     LOCATE l_img_blob IN MEMORY
     #TQC-C10034--add--end

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aapr741'
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                          
     CALL cl_del_data(l_table)
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND alauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND alagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    
     #         LET tm.wc = tm.wc clipped," AND alagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('alauser', 'alagrup')
     #End:FUN-980030
 
#    LET l_sql = "SELECT alaplant,alc01,ala04,'',ala930,'',alc24,alc80,alc08,",         #No.FUN-980017
     LET l_sql = "SELECT ala97,alc01,ala04,'',ala930,'',alc24,alc80,alc08,",            #No.FUN-980017
                 " ala20,alc51,alc79,alc02,alcfirm,alc78,alc74,ala21,",
                 " alc81,alc82,alc84,alc34,alc85,alc91,alc92,alc94,alc951,",
                 " alc952,alc953,alc95,alc96,'',alc83,alc931,",
                 " alc76, alc932,alc93,'',''",                
                 " FROM ala_file, alc_file",
                 " WHERE alc01 = ala01 ",      # 開狀單號
                 "   AND alcfirm <> 'X' ",  #CHI-C80041
                 "   AND ", tm.wc CLIPPED
 
     PREPARE r741_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
        EXIT PROGRAM
     END IF
     DECLARE r741_curs1 CURSOR FOR r741_prepare1
                                          
     FOREACH r741_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
 
          SELECT azi04,azi07 INTO sr.t_azi04,sr.t_azi07 
            FROM azi_file
           WHERE azi01 = sr.ala20
           
          SELECT gem02 INTO sr.gem02
            FROM gem_file
           WHERE gem01 = sr.ala04
           
          SELECT gem02 INTO sr.gem02b
            FROM gem_file
           WHERE gem01 = sr.ala930
           
          SELECT nmc02 INTO sr.nmc02
            FROM nmc_file
           WHERE nmc01 = sr.alc96
             AND nmc03 = '2'
          #TQC-BC0013---add---str---
          LET l_alc81 = ''
          SELECT nma02 INTO l_alc81 FROM nma_file
           WHERE nma01 = sr.alc81

          LET l_alc91 = ''
          SELECT nma02 INTO l_alc91 FROM nma_file
           WHERE nma01 = sr.alc91
          #TQC-BC0013---add---end---
     
      EXECUTE insert_prep USING
#                         sr.alaplant,sr.alc01,sr.ala04,sr.gem02,sr.ala930,          #No.FUN-980017
                          sr.ala97,sr.alc01,sr.ala04,sr.gem02,sr.ala930,             #No.FUN-980017
                          sr.gem02b,sr.alc24,sr.alc80,sr.alc08,sr.ala20,
                          sr.alc51,sr.alc79,sr.alc02,sr.alcfirm,sr.alc78,
                          sr.alc74,sr.ala21,sr.alc81,sr.alc82,sr.alc84,
                          sr.alc34,sr.alc85,sr.alc91,sr.alc92,sr.alc94,
                          sr.alc951,sr.alc952,sr.alc953,sr.alc95,sr.alc96,
                          sr.nmc02,sr.alc83,sr.alc931,sr.alc76,sr.alc932,
                          sr.alc93,sr.t_azi04,sr.t_azi07,
                          "",  l_img_blob,   "N","",              #TQC-C10034  add
                          l_alc81,l_alc91                         #TQC-BC0013 add l_alc81,l_alc91
     END FOREACH
 
     IF g_zz05 = 'Y' THEN                                                                                                           
       CALL cl_wcchp(tm.wc,'alc01,alc80,alc79,ala04,alc02')                                     
        RETURNING g_str                                                                                                             
     END IF                                                                                                                         
     LET g_str =g_str,";",g_azi04                                             
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED         
     #TQC-C10034--add--begin
     LET g_cr_table = l_table
     LET g_cr_apr_key_f = "alc01" 
     #TQC-C10034--add--end                                                      
     CALL cl_prt_cs3('aapr741','aapr741',g_sql,g_str)
 
       #CALL  cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B80105 MARK
END FUNCTION
 
#No.FUN-860090 
