# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aapr801.4gl
# Descriptions...: 提單費用明細表
# Date & Author..: 96/01/05  By  Roger
# Modify.........: No.FUN-4C0097 05/01/04 By Nicola 報表架構修改
#                                                   增加列印部門名稱gem02、廠商編號als06
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6B0128 06/11/27 By Rayven "接下頁" "結束"位置有誤
# Modify.........: No.FUN-830103 08/03/25 By destiny 報表改為CR輸出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.CHI-C80041 12/12/19 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                      # Print condition RECORD
              wc      LIKE type_file.chr1000,      # Where condition  #No.FUN-690028 VARCHAR(600)
              yymm    LIKE type_file.chr8,           # No.FUN-690028 VARCHAR(6),         #
              more    LIKE type_file.chr1          # No.FUN-690028 VARCHAR(1)          # Input more condition(Y/N)
           END RECORD
DEFINE g_i LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#     DEFINEl_time LIKE type_file.chr8         #No.FUN-6A0055
#No.FUN-830103--begin--                                                                                                             
   DEFINE g_sql       STRING                                                                                                        
   DEFINE l_table     STRING                                                                                                        
   DEFINE g_str       STRING                                                                                                        
   DEFINE l_title1    STRING                                                                                                        
#No.FUN-830103--end-- 
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
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055 #FUN-BB0047 mark
#No.FUN-830103--begin--                                                                                                             
   LET g_sql= "als04.als_file.als04,",                                                                                              
              "l_gem02.gem_file.gem02,",                                                                                            
              "als01.als_file.als01,",                                                                                              
              "als06.als_file.als06,",                                                                                              
              "l_pmc03.pmc_file.pmc03,",                                                                                            
              "als41.als_file.als41,",                                                                                              
              "als42.als_file.als42,",                                                                                              
              "als43.als_file.als43,",                                                                                              
              "als44.als_file.als44,",                                                                                              
              "als45.als_file.als45,",                                                                                              
              "als46.als_file.als46"                                                                                                
                                                                                                                                    
   LET l_table = cl_prt_temptable('aapr801',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?,?)"                                                                                    
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
#No.FUN-830103--end-- 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yymm = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r801_tm(0,0)
   ELSE
      CALL r801()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION r801_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 20
   OPEN WINDOW r801_w AT p_row,p_col
     WITH FORM "aap/42f/aapr801"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.yymm = TODAY USING 'yyyymm'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
 
      CONSTRUCT BY NAME tm.wc ON als01,als02,als04
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
          ON ACTION controlg      #MOD-4C0121
             CALL cl_cmdask()     #MOD-4C0121
 
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
         CLOSE WINDOW r801_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      INPUT BY NAME tm.yymm,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
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
         CLOSE WINDOW r801_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr801'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr801','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.yymm CLIPPED,"'",   #TQC-610053
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('aapr801',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r801_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r801()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r801_w
 
END FUNCTION
 
FUNCTION r801()
   DEFINE l_name    LIKE type_file.chr20,           # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,            # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          l_sql     LIKE type_file.chr1000,         # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1200)
          l_order   ARRAY[5] OF LIKE zaa_file.zaa08,    # No.FUN-690028 VARCHAR(10),
          als       RECORD LIKE als_file.*
   DEFINE l_pmc03   LIKE pmc_file.pmc03,
          l_gem02   LIKE gem_file.gem02
 
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                        #No.FUN-830103                                   
   CALL cl_del_data(l_table)                                                       #No.FUN-830103 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND alsuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND alsgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND alsgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('alsuser', 'alsgrup')
   #End:FUN-980030
 
 
   LET l_sql = "SELECT * FROM als_file",
               " WHERE ", tm.wc CLIPPED,
               "   AND alsfirm <> 'X' "  #CHI-C80041
 
   DISPLAY l_sql
 
   PREPARE r801_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE r801_curs1 CURSOR FOR r801_prepare1
 
#   CALL cl_outnam('aapr801') RETURNING l_name                   #No.FUN-830103
#   START REPORT r801_rep TO l_name                              #No.FUN-830103
 
#  LET g_pageno = 0                                              #No.FUN-830103 
 
   FOREACH r801_curs1 INTO als.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET l_pmc03 = NULL
      SELECT pmc03 INTO l_pmc03 FROM pmc_file
       WHERE pmc01=als.als06
 
      LET l_gem02 = NULL
      SELECT gem02 INTO l_gem02 FROM gem_file
       WHERE gem01=als.als04
 
      IF als.als41 IS NULL THEN
         LET als.als41 = 0
      END IF
 
      IF als.als42 IS NULL THEN
         LET als.als42 = 0
      END IF
 
      IF als.als43 IS NULL THEN
         LET als.als43 = 0
      END IF
 
      IF als.als44 IS NULL THEN
         LET als.als44 = 0
      END IF
 
      IF als.als45 IS NULL THEN
         LET als.als45 = 0
      END IF
 
      IF als.als46 IS NULL THEN
         LET als.als46 = 0
      END IF
 
      IF als.als41m != tm.yymm OR als.als41m IS NULL THEN
         LET als.als41 = 0
      END IF
 
      IF als.als42m != tm.yymm OR als.als42m IS NULL THEN
         LET als.als42 = 0
      END IF
 
      IF als.als43m != tm.yymm OR als.als43m IS NULL THEN
         LET als.als43 = 0
      END IF
 
      IF als.als44m != tm.yymm OR als.als44m IS NULL THEN
         LET als.als44 = 0
      END IF
 
      IF als.als45m != tm.yymm OR als.als45m IS NULL THEN
         LET als.als45 = 0
      END IF
 
      IF als.als46m != tm.yymm OR als.als46m IS NULL THEN
         LET als.als46 = 0
      END IF
 
      IF als.als41=0 AND als.als42=0 AND als.als43=0 AND
         als.als44=0 AND als.als45=0 AND als.als46=0 THEN
         CONTINUE FOREACH
      END IF
#No.FUN-830103--begin-- 
#     OUTPUT TO REPORT r801_rep(als.*,l_pmc03,l_gem02)
      EXECUTE insert_prep USING                                                                                                     
              als.als04,l_gem02,als.als01,als.als06,l_pmc03,als.als41,                                                              
              als.als42,als.als43,als.als44,als.als45,als.als46                                                                     
   END FOREACH
 
#   FINISH REPORT r801_rep
 
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
     #No.FUN-BB0047--mark--End-----
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'als01,als02,als04')                                                                                    
        RETURNING tm.wc                                                                                                             
        LET g_str = tm.wc                                                                                                           
     END IF                                                                                                                         
     LET l_title1 =tm.yymm[1,4],"/",tm.yymm[5,6]                                                                                    
     LET g_str = g_str,";",g_azi04,";",g_azi05,";",l_title1                                                                         
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
     CALL cl_prt_cs3('aapr801','aapr801',g_sql,g_str)                                                                               
#No.FUN-830103--end--
END FUNCTION
#No.FUN-830103--begin--
#REPORT r801_rep(als,l_pmc03,l_gem02)
#  DEFINE l_last_sw	LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
#  DEFINE l_pmc03       LIKE pmc_file.pmc03,
#         l_gem02       LIKE gem_file.gem02,
#         als		RECORD LIKE als_file.*
#  DEFINE g_head1       STRING
 
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
#  ORDER BY als.als01
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<',"/pageno"
#        PRINT g_head CLIPPED,pageno_total
#        LET g_head1 = g_x[9] CLIPPED,tm.yymm[1,4],"/",tm.yymm[5,6]
#        PRINT g_head1
#        PRINT g_dash[1,g_len]
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#              g_x[39],g_x[40],g_x[41],g_x[42]
#        PRINT g_dash1
#        LET l_last_sw = 'n'
 
#     ON EVERY ROW
#        PRINT COLUMN g_c[31],als.als04,
#              COLUMN g_c[32],l_gem02,
#              COLUMN g_c[33],als.als01,
#              COLUMN g_c[34],als.als06,
#              COLUMN g_c[35],l_pmc03,
#              COLUMN g_c[36],cl_numfor(als.als41,36,g_azi04),
#              COLUMN g_c[37],cl_numfor(als.als42,37,g_azi04),
#              COLUMN g_c[38],cl_numfor(als.als43,38,g_azi04),
#              COLUMN g_c[39],cl_numfor(als.als44,39,g_azi04),
#              COLUMN g_c[40],cl_numfor(als.als45,40,g_azi04),
#              COLUMN g_c[41],cl_numfor(als.als46,41,g_azi04),
#              COLUMN g_c[42],cl_numfor(als.als41+als.als42+als.als43+als.als44+als.als45+als.als46,42,g_azi04)
#
#     ON LAST ROW
#        PRINT g_dash2[1,g_len]
#        PRINT COLUMN g_c[35],g_x[10] CLIPPED,
#              COLUMN g_c[36],cl_numfor(SUM(als.als41),36,g_azi05),
#              COLUMN g_c[37],cl_numfor(SUM(als.als42),37,g_azi05),
#              COLUMN g_c[38],cl_numfor(SUM(als.als43),38,g_azi05),
#              COLUMN g_c[39],cl_numfor(SUM(als.als44),39,g_azi05),
#              COLUMN g_c[40],cl_numfor(SUM(als.als45),40,g_azi05),
#              COLUMN g_c[41],cl_numfor(SUM(als.als46),41,g_azi05),
#              COLUMN g_c[42],cl_numfor(SUM(als.als41+als.als42+als.als43+als.als44+als.als45+als.als46),42,g_azi05)
#        PRINT g_dash[1,g_len]
#        LET l_last_sw = 'y'
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[42],g_x[7] CLIPPED   #No.TQC-6B0128 mark
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED #No.TQC-6B0128
#        PRINT
#        PRINT COLUMN g_c[31],g_x[11] CLIPPED,
#              COLUMN g_c[33],g_x[12] CLIPPED,
#              COLUMN g_c[35],g_x[13] CLIPPED
 
#     PAGE TRAILER
#        IF l_last_sw = 'n' THEN
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[42],g_x[6] CLIPPED   #No.TQC-6B0128 mark
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED #No.TQC-6B0128
#           PRINT g_dash[1,g_len]
#           PRINT
#           PRINT COLUMN g_c[31],g_x[11] CLIPPED,
#                 COLUMN g_c[33],g_x[12] CLIPPED,
#                 COLUMN g_c[35],g_x[13] CLIPPED
#        ELSE
#           SKIP 4 LINE
#        END IF
 
#END REPORT
#No.FUN-830103--end-- 
