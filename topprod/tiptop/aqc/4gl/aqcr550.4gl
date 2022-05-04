# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aqcr550.4gl
# Descriptions...: PQC不良原因分析(By 作業編號)
# Date & Author..: 99/05/17 By Sophia
# Modify.........: No.MOD-530620 05/03/26 By Yuna 請將其他特殊列印條件default 'N'
# Modify.........: NO.FUN-550063 05/05/19 By jackie 單據編號加大
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-570243 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-580013 05/08/16 By yoyo 憑証類報表原則修改
# Modify.........: No.TQC-610086 06/04/18 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-690121 06/10/16 By Jackho cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-740013 070419 by TSD.pinky CR modify
# Modify.........: NO.CHI-910058 09/02/13 by shiwuying CR段調整
#                                09/07/02 by Cockroach 5.1-->5.2
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0179 09/12/29 By tsai_yen EXECUTE裡不可有擷取字串的中括號[]
# Modify.........: No.TQC-950136 10/03/04 By vealxu 去掉SELECT語句後的 INTO cnt
# Modify.........: No.FUN-A50053 10/05/25 By liuxqa 修改g_str的":"的符號，由全形改成半形 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(600)
              bdate   LIKE type_file.dat,          #No.FUN-680104 DATE
              edate   LIKE type_file.dat,          #No.FUN-680104 DATE 
              more    LIKE type_file.chr1          #No.FUN-680104 VARCHAR(01)
              END RECORD,
          g_head1  DYNAMIC ARRAY OF RECORD               #No.FUn-580013
              qcu04    LIKE qcu_file.qcu04,
              qcu05    LIKE qcu_file.qcu05
              END RECORD,
          g_tot1       LIKE qcu_file.qcu05,       #No.FUN-680104 DEC(12,3)
          g_tot2       LIKE qcu_file.qcu05,       #No.FUN-680104 DEC(12,3)
          g_tot3       LIKE qcu_file.qcu05,       #No.FUN-680104 DEC(12,3)
          g_tot4       LIKE qcu_file.qcu05,       #No.FUN-680104 DEC(12,3)
          g_tot5       LIKE qcu_file.qcu05,       #No.FUN-680104 DEC(12,3)
          g_tot6       LIKE qcu_file.qcu05,       #No.FUN-680104 DEC(12,3)
          g_tot7       LIKE qcu_file.qcu05,       #No.FUN-680104 DEC(12,3)
          g_tot8       LIKE qcu_file.qcu05,       #No.FUN-680104 DEC(12,3)
          g_tot9       LIKE qcu_file.qcu05,       #No.FUN-680104 DEC(12,3)
          g_tot10      LIKE qcu_file.qcu05        #No.FUN-680104 DEC(12,3) 
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680104 SMALLINT
DEFINE   l_table    STRING
DEFINE   g_sql      STRING
DEFINE g_str VARCHAR(500)
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690121
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-740013 *** ##
 LET g_sql =
  "sgm04.sgm_file.sgm04,",
  "qcu04.qcu_file.qcu04,",
  "sgm45.sgm_file.sgm45,",
  "amt.qcu_file.qcu05, ",
  "cnt.type_file.num5, ",
  "qcu051.qcu_file.qcu05,",
  "qcu052.qcu_file.qcu05,",
  "qcu053.qcu_file.qcu05,",
  "qcu054.qcu_file.qcu05,",
  "qcu055.qcu_file.qcu05,",
  "qcu056.qcu_file.qcu05,",
  "qcu057.qcu_file.qcu05,",
  "qcu058.qcu_file.qcu05,",
  "qcu059.qcu_file.qcu05,",
  "qcu050.qcu_file.qcu05"
  LET l_table = cl_prt_temptable('aqcr550',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
   " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"
PREPARE insert_prep FROM g_sql
IF STATUS THEN
   CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
END IF
#------------------------------------ CR (1) ------------------------------#
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
#------------No.TQC-610086 modify
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#------------No.TQC-610086 end
   CALL r550_cre_tmp()
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r550_tm(0,0)
      ELSE CALL r550()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
END MAIN
 
FUNCTION r550_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680104 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
 
   OPEN WINDOW r550_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcr550"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.bdate= g_today
   LET tm.edate= g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'
WHILE TRUE
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON sgm04,qcm021,qcu04
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
#No.FUN-570243 --start
     ON ACTION CONTROLP
        IF INFIELD(qcm021) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_ima"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO qcm021
           NEXT FIELD qcm021
        END IF
#No.FUN-570243 --end
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
         CLOSE WINDOW r550_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
         EXIT PROGRAM
      END IF
      IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
      CALL cl_err('',9046,0)
   END WHILE
    INPUT BY NAME tm.bdate,tm.edate,tm.more WITHOUT DEFAULTS    #MOD-530620
 
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
          IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
 
      AFTER FIELD edate
          IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
          IF tm.edate < tm.bdate THEN NEXT FIELD edate END IF
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()
 
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
      CLOSE WINDOW r550_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aqcr550'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aqcr550','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aqcr550',g_time,l_cmd)
      END IF
      CLOSE WINDOW r550_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r550()
   ERROR ""
END WHILE
   CLOSE WINDOW r550_w
END FUNCTION
 
FUNCTION r550()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680104 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680104 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
          l_za05    LIKE cob_file.cob01,          #No.FUN-680104 VARCHAR(40)
          l_i       LIKE type_file.num5,          #No.FUN-680104 SMALLINT
          sr1       RECORD
                    sgm04     LIKE sgm_file.sgm04,
                    sgm45     LIKE sgm_file.sgm45,
                    qcu04     LIKE qcu_file.qcu04,
                    qcu05     LIKE qcu_file.qcu05,
                    qcm01     LIKE qcm_file.qcm01,
                    qcm02     LIKE qcm_file.qcm02,
                    qcm021    LIKE qcm_file.qcm021,
                    qcm22    LIKE qcm_file.qcm22
                    END RECORD,
          sr        RECORD
                    sgm04     LIKE sgm_file.sgm04,
                    sgm45     LIKE sgm_file.sgm45,
                    qcu04     LIKE qcu_file.qcu04,
                    qcu05     LIKE qcu_file.qcu05,
                    qcm01     LIKE qcm_file.qcm01,
                    qcm02     LIKE qcm_file.qcm02,
                    qcm021    LIKE qcm_file.qcm021,
                    qcm22    LIKE qcm_file.qcm22
                    END RECORD
#NO.CHI-910058 start -----------------------------------------------
   DEFINE l_qcu05      ARRAY[10] of LIKE qcu_file.qcu05,
          l_amt        LIKE qcu_file.qcu05,
          amt          LIKE qcm_file.qcm22,
          l_n          LIKE type_file.num5,
          l_str1       LIKE adj_file.adj02,
          l_str2       LIKE adj_file.adj02,
          l_str3       LIKE adj_file.adj02,
          l_str4       LIKE adj_file.adj02,
          l_str5       LIKE adj_file.adj02,
          l_str6       LIKE adj_file.adj02,
          l_str7       LIKE adj_file.adj02,
          l_str8       LIKE adj_file.adj02,
          l_str9       LIKE adj_file.adj02,
          l_str10      LIKE adj_file.adj02,
          cnt          LIKE type_file.num5
#NO.CHI-910058 END--------------------------------------------------
   ###TQC-9C0179 START ###
   DEFINE l_sgm04    LIKE sgm_file.sgm04
   DEFINE l_sgm45    LIKE sgm_file.sgm45
   ###TQC-9C0179 END ### 
 
      ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-740013 *** ##
  CALL cl_del_data(l_table)
  SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
  #------------------------------ CR (2) ----------------------------------#
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND qcmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND qcmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND qcmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qcmuser', 'qcmgrup')
     #End:FUN-980030
 
 
     LET l_sql = "SELECT sgm04,sgm45,qcu04,qcu05,qcm01,qcm02,qcm021,qcm22",
                 "  FROM qcm_file,qcu_file, sgm_file, sfb_file ",
                 " WHERE qcm01=qcu01 ",
                 "   AND qcm02 = sfb01",     #工單編號
                 "   AND qcm14 = 'Y' AND qcm18='2' ",
                 "   AND qcm03 = sgm01",
                 "   AND sgm03 = qcm05",
                 "   AND qcm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "   AND ", tm.wc CLIPPED
 
 
     PREPARE r550_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
        EXIT PROGRAM
     END IF
     DECLARE r550_curs1 CURSOR FOR r550_prepare1
#      CALL cl_outnam('aqcr550') RETURNING l_name           #NO.CHI-910058 mark  
#      START REPORT r550_rep TO l_name                      #NO.CHI-910058 mark          
     LET g_pageno = 0
     LET g_tot1 = 0       LET g_tot2 = 0
     LET g_tot3 = 0       LET g_tot4 = 0
     LET g_tot5 = 0       LET g_tot6 = 0
     LET g_tot7 = 0       LET g_tot8 = 0
     LET g_tot9 = 0       LET g_tot10= 0
     DELETE FROM aqcr550_tmp
 
     FOREACH r550_curs1 INTO sr1.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
 
         INSERT INTO aqcr550_tmp VALUES (sr1.*)
     END FOREACH
     #------表頭前十名不良原因資料----------
     FOR l_i = 1 TO 10
         INITIALIZE g_head1[l_i].* TO NULL         #No.FUN-580013
     END FOR
 
     LET l_i = 1
     DECLARE r550_head1 CURSOR FOR             #No.FUN-580013
      SELECT qcu04,SUM(qcu05) qcu05 FROM aqcr550_tmp
       GROUP BY qcu04
       ORDER BY qcu05 DESC
     FOREACH r550_head1 INTO g_head1[l_i].*             #No.FUN-580013
       IF STATUS THEN CALL cl_err('foreach head',STATUS,0) EXIT FOREACH END IF
       IF l_i >= 10 THEN  EXIT FOREACH END IF
       LET l_i = l_i + 1
     END FOREACH
     #------單身資料-----------------
#NO.CHI-910058 start -----------------------------------------------
     DECLARE r550_body CURSOR FOR
#      SELECT * FROM aqcr550_tmp                        #NO.CHI-910058 mark
#     FOREACH r550_body INTO sr.*                       #NO.CHI-910058 mark 
      SELECT DISTINCT sgm04 FROM aqcr550_tmp
     FOREACH r550_body INTO sr.sgm04
       IF STATUS THEN CALL cl_err('foreach body',STATUS,0) EXIT FOREACH END IF
 
#       OUTPUT TO REPORT r550_rep(sr.*)                 #NO.CHI-910058 mark  
        FOR l_n = 1 TO 10
           LET l_qcu05[l_n] = 0
        END FOR
 
        LET l_i = 1
        DECLARE r550_head2 CURSOR FOR             #No.FUN-580013
         SELECT qcu04,SUM(qcu05) qcu05 FROM aqcr550_tmp
          GROUP BY qcu04
          ORDER BY qcu05 DESC
        FOREACH r550_head2 INTO sr.qcu04,sr.qcu05
           IF STATUS THEN CALL cl_err('foreach head2',STATUS,0) EXIT FOREACH END IF
           SELECT SUM(qcu05) INTO l_amt FROM aqcr550_tmp
            WHERE sgm04 = sr.sgm04
              AND qcu04 = sr.qcu04
           IF STATUS OR cl_null(l_amt) THEN LET l_amt = 0 END IF
           FOR l_n = 1 TO 10
              IF g_head1[l_n].qcu04 = sr.qcu04 THEN                #No.FUn-580013
                 LET l_qcu05[l_n] = l_qcu05[l_n] + l_amt
              END IF
           END FOR
           IF l_i >= 10 THEN  EXIT FOREACH END IF
           LET l_i = l_i + 1
        END FOREACH
   
  #     LET amt = GROUP SUM(sr.qcm22)  #總送驗量
        SELECT SUM(qcm22) INTO amt
          FROM aqcr550_tmp 
         WHERE sgm04 = sr.sgm04
 
        DROP TABLE x
#       SELECT DISTINCT qcm01 INTO cnt FROM aqcr550_tmp    #No.TQC-950136
        SELECT DISTINCT qcm01 FROM aqcr550_tmp             #No.TQC-950136
         WHERE sgm04 = sr.sgm04
         GROUP BY qcm01
          INTO TEMP x
        SELECT COUNT(*) INTO cnt FROM x
        IF cl_null(amt) THEN LET amt = 0 END IF
        IF cl_null(cnt) THEN LET cnt = 0 END IF
        ###TQC-9C0179 START ###
        LET l_sgm04 = sr.sgm04[1,6]
        LET l_sgm45 = sr.sgm45[1,16]
        ###TQC-9C0179 END ### 
        #EXECUTE insert_prep USING sr.sgm04[1,6],sr.qcu04,sr.sgm45[1,16],amt,cnt, #TQC-9C0179 mark
        EXECUTE insert_prep USING l_sgm04,sr.qcu04,l_sgm45,amt,cnt,               #TQC-9C0179
                 l_qcu05[1], l_qcu05[2] , l_qcu05[3] , l_qcu05[4] , l_qcu05[5] ,
                 l_qcu05[6] , l_qcu05[7] , l_qcu05[8] , l_qcu05[9] , l_qcu05[10]
     END FOREACH
 
     CALL r550_qce(g_head1[1].qcu04) RETURNING l_str1
     CALL r550_qce(g_head1[2].qcu04) RETURNING l_str2
     CALL r550_qce(g_head1[3].qcu04) RETURNING l_str3
     CALL r550_qce(g_head1[4].qcu04) RETURNING l_str4
     CALL r550_qce(g_head1[5].qcu04) RETURNING l_str5
     CALL r550_qce(g_head1[6].qcu04) RETURNING l_str6
     CALL r550_qce(g_head1[7].qcu04) RETURNING l_str7
     CALL r550_qce(g_head1[8].qcu04) RETURNING l_str8
     CALL r550_qce(g_head1[9].qcu04) RETURNING l_str9
     CALL r550_qce(g_head1[10].qcu04) RETURNING l_str10
#NO.CHI-910058 END--------------------------------------------------
     #FINISH REPORT r550_rep
 
    # CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
 LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 LET g_str = ''
 #是否列印選擇條件
 IF g_zz05 = 'Y' THEN
    CALL cl_wcchp(tm.wc,'sgm04,qcm021,qcu04')
         RETURNING tm.wc
    LET g_str = tm.wc
 END IF
  LET g_str = g_str,";",tm.bdate,";",tm.edate
#NO.CHI-910058 start -----------------------------------------------
 
  LET g_str=g_str CLIPPED,";",
       g_head1[1].qcu04,':',l_str1,";",  #FUN-A50053 mod
       g_head1[2].qcu04,':',l_str2,";",  #FUN-A50053 mod
       g_head1[3].qcu04,':',l_str3,";",  #FUN-A50053 mod
       g_head1[4].qcu04,':',l_str4,";",  #FUN-A50053 mod
       g_head1[5].qcu04,':',l_str5,";",  #FUN-A50053 mod
       g_head1[6].qcu04,':',l_str6,";",  #FUN-A50053 mod
       g_head1[7].qcu04,':',l_str7,";",  #FUN-A50053 mod
       g_head1[8].qcu04,':',l_str8,";",  #FUN-A50053 mod
       g_head1[9].qcu04,':',l_str9,";",  #FUN-A50053 mod
       g_head1[10].qcu04,':',l_str10     #FUN-A50053 mod
 
#  FINISH REPORT r550_rep                         #NO.CHI-910058 mark
#NO.CHI-910058 END--------------------------------------------------
 CALL cl_prt_cs3('aqcr550','aqcr550',l_sql,g_str)
 #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
 
#NO.CHI-910058 start -----------------------------------------------
#REPORT r550_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#          l_gem02      LIKE gem_file.gem02,
#          l_qcu05      ARRAY[10] of LIKE qcu_file.qcu05, #No.FUN-680104 DEC(12,3)
#          l_amt        LIKE qcu_file.qcu05,
#          amt          LIKE qcm_file.qcm22,       #No.FUN-680104 DEC(12,3)
#          l_n          LIKE type_file.num5,       #No.FUN-680104 SMALLINT
#          l_str1       LIKE adj_file.adj02,       #No.FUN-680104 VARCHAR(20)
#          l_str2       LIKE adj_file.adj02,       #No.FUN-680104 VARCHAR(20)
#          l_str3       LIKE adj_file.adj02,       #No.FUN-680104 VARCHAR(20)
#          l_str4       LIKE adj_file.adj02,       #No.FUN-680104 VARCHAR(20)
#          l_str5       LIKE adj_file.adj02,       #No.FUN-680104 VARCHAR(20)
#          l_str6       LIKE adj_file.adj02,       #No.FUN-680104 VARCHAR(20)
#          l_str7       LIKE adj_file.adj02,       #No.FUN-680104 VARCHAR(20)
#          l_str8       LIKE adj_file.adj02,       #No.FUN-680104 VARCHAR(20)
#          l_str9       LIKE adj_file.adj02,       #No.FUN-680104 VARCHAR(20)
#          l_str10      LIKE adj_file.adj02,       #No.FUN-680104 VARCHAR(20)
#          cnt          LIKE type_file.num5,       #No.FUN-680104 SMALLINT
#          sr        RECORD
#                    sgm04     LIKE sgm_file.sgm04,
#                    sgm45     LIKE sgm_file.sgm45,
#                    qcu04     LIKE qcu_file.qcu04,
#                    qcu05     LIKE qcu_file.qcu05,
#                    qcm01     LIKE qcm_file.qcm01,
#                    qcm02     LIKE qcm_file.qcm02,
#                    qcm021    LIKE qcm_file.qcm021,
#                    qcm22    LIKE qcm_file.qcm22
#                    END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.sgm04,sr.qcu04
#  FORMAT
#   PAGE HEADER
##No.FUN-580013--start
##     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##     IF cl_null(g_towhom)
##        THEN PRINT '';
##        ELSE PRINT 'TO:',g_towhom;
##     END IF
##     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
##     PRINT ' '
##     LET g_pageno = g_pageno + 1
##     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,'                          ',
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      PRINT COLUMN 74,g_x[15] CLIPPED,tm.bdate,'至 ',tm.edate
#      PRINT g_dash[1,g_len]
##     PRINT g_x[11] CLIPPED,COLUMN 13,g_x[12] CLIPPED,
##           COLUMN 26,g_x[13] CLIPPED,COLUMN 35,g_x[14] CLIPPED,
##           COLUMN 48,g_head[1].qcu04,COLUMN 57,g_head[2].qcu04,
##           COLUMN 66,g_head[3].qcu04,COLUMN 75,g_head[4].qcu04,
##           COLUMN 84,g_head[5].qcu04,COLUMN 93,g_head[6].qcu04,
##           COLUMN 102,g_head[7].qcu04,COLUMN 111,g_head[8].qcu04,
##           COLUMN 120,g_head[9].qcu04,COLUMN 129,g_head[10].qcu04
##     PRINT '------------------------ ---------- -------- -------- --------',
##           ' -------- -------- -------- -------- -------- -------- ',
##           '-------- --------'
#      LET g_zaa[35].zaa08=g_head1[1].qcu04
#      LET g_zaa[36].zaa08=g_head1[2].qcu04
#      LET g_zaa[37].zaa08=g_head1[3].qcu04
#      LET g_zaa[38].zaa08=g_head1[4].qcu04
#      LET g_zaa[39].zaa08=g_head1[5].qcu04
#      LET g_zaa[40].zaa08=g_head1[6].qcu04
#      LET g_zaa[41].zaa08=g_head1[7].qcu04
#      LET g_zaa[42].zaa08=g_head1[8].qcu04
#      LET g_zaa[43].zaa08=g_head1[9].qcu04
#      LET g_zaa[44].zaa08=g_head1[10].qcu04
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#             g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
#      PRINT g_dash1
##No.FUN-580013--end
#      LET l_last_sw = 'n'
#
#
#   BEFORE GROUP OF sr.sgm04
#      FOR l_n = 1 TO 10
#          LET l_qcu05[l_n] = 0
#      END FOR
#
#   AFTER GROUP OF sr.qcu04    #不良原因
#      SELECT SUM(qcu05) INTO l_amt FROM aqcr550_tmp
#       WHERE sgm04 = sr.sgm04
#         AND qcu04 = sr.qcu04
#      IF STATUS OR cl_null(l_amt) THEN LET l_amt = 0 END IF
#      FOR l_n = 1 TO 10
#          IF g_head1[l_n].qcu04 = sr.qcu04 THEN                #No.FUn-580013
#             LET l_qcu05[l_n] = l_qcu05[l_n] + l_amt
#          END IF
#      END FOR
#
#   AFTER GROUP OF sr.sgm04   #部門
#      LET amt = GROUP SUM(sr.qcm22)  #總送驗量
#      DROP TABLE x
#      SELECT DISTINCT qcm01 INTO cnt FROM aqcr550_tmp
#       WHERE sgm04 = sr.sgm04
#       GROUP BY qcm01
#       INTO TEMP x
#      SELECT COUNT(*) INTO cnt FROM x
#      IF cl_null(amt) THEN LET amt = 0 END IF
#      IF cl_null(cnt) THEN LET cnt = 0 END IF
##No.FUN-580013--start
##     PRINT COLUMN 01,sr.sgm04[1,6],
##           COLUMN 08,sr.sgm45[1,16],
##           COLUMN 25,amt USING '#########&',' ',
##           cnt USING '#######&',' ',l_qcu05[1] USING '########',' ',
##           l_qcu05[2] USING '########',' ',l_qcu05[3] USING '########',' ',
##           l_qcu05[4] USING '########',' ',l_qcu05[5] USING '########',' ',
##           l_qcu05[6] USING '########',' ',l_qcu05[7] USING '########',' ',
##           l_qcu05[8] USING '########',' ',l_qcu05[9] USING '########',' ',
##           l_qcu05[10] USING '########'
#      PRINTX name=D1
#            COLUMN g_c[31],sr.sgm04[1,6],
#            COLUMN g_c[32],sr.sgm45[1,16],
#            COLUMN g_c[33],amt USING '###########&',
#            COLUMN g_c[34],cnt USING '########&',
#            COLUMN g_c[35],l_qcu05[1] USING '############',
#            COLUMN g_c[36],l_qcu05[2] USING '############',
#            COLUMN g_c[37],l_qcu05[3] USING '############',
#            COLUMN g_c[38],l_qcu05[4] USING '############',
#            COLUMN g_c[39],l_qcu05[5] USING '############',
#            COLUMN g_c[40],l_qcu05[6] USING '############',
#            COLUMN g_c[41],l_qcu05[7] USING '############',
#            COLUMN g_c[42],l_qcu05[8] USING '############',
#            COLUMN g_c[43],l_qcu05[9] USING '############',
#            COLUMN g_c[44],l_qcu05[10] USING '############'
#        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>>
#       EXECUTE insert_prep USING sr.sgm04[1,6],sr.qcu04,sr.sgm45[1,16],amt,cnt,
#       l_qcu05[1], l_qcu05[2] , l_qcu05[3] , l_qcu05[4] , l_qcu05[5] ,
#       l_qcu05[6] , l_qcu05[7] , l_qcu05[8] , l_qcu05[9] , l_qcu05[10]
#
##No.FUN-580013--end
#      LET g_tot1 = g_tot1 + l_qcu05[1]
#      LET g_tot2 = g_tot2 + l_qcu05[2]
#      LET g_tot3 = g_tot3 + l_qcu05[3]
#      LET g_tot4 = g_tot4 + l_qcu05[4]
#      LET g_tot5 = g_tot5 + l_qcu05[5]
#      LET g_tot6 = g_tot6 + l_qcu05[6]
#      LET g_tot7 = g_tot7 + l_qcu05[7]
#      LET g_tot8 = g_tot8 + l_qcu05[8]
#      LET g_tot9 = g_tot9 + l_qcu05[9]
#      LET g_tot10= g_tot10+ l_qcu05[10]
# 
#   ON LAST ROW
##No.FUN-580013--start
##     PRINT COLUMN 35,g_x[16] CLIPPED,g_tot1 USING '#########',' ',
##           g_tot2 USING '########',' ',g_tot3 USING '########',' ',
##           g_tot4 USING '########',' ',g_tot5 USING '########',' ',
##           g_tot6 USING '########',' ',g_tot7 USING '########',' ',
##           g_tot8 USING '########',' ',g_tot9 USING '########',' ',
##           g_tot10 USING '########'
#      PRINTX name=S1
#            COLUMN g_c[34],g_x[16] CLIPPED,
#            COLUMN g_c[35],g_tot1 USING '############',
#            COLUMN g_c[36],g_tot2 USING '############',
#            COLUMN g_c[37],g_tot3 USING '############',
#            COLUMN g_c[38],g_tot4 USING '############',
#            COLUMN g_c[39],g_tot5 USING '############',
#            COLUMN g_c[40],g_tot6 USING '############',
#            COLUMN g_c[41],g_tot7 USING '############',
#            COLUMN g_c[42],g_tot8 USING '############',
#            COLUMN g_c[43],g_tot9 USING '############',
#            COLUMN g_c[44],g_tot10 USING '############'
##No.FUN-580013--end
#      PRINT
#      PRINT
##No.FUN-580013--start
#      CALL r550_qce(g_head1[1].qcu04) RETURNING l_str1
#      CALL r550_qce(g_head1[2].qcu04) RETURNING l_str2
#      CALL r550_qce(g_head1[3].qcu04) RETURNING l_str3
#      CALL r550_qce(g_head1[4].qcu04) RETURNING l_str4
#      CALL r550_qce(g_head1[5].qcu04) RETURNING l_str5
#      CALL r550_qce(g_head1[6].qcu04) RETURNING l_str6
#      CALL r550_qce(g_head1[7].qcu04) RETURNING l_str7
#      CALL r550_qce(g_head1[8].qcu04) RETURNING l_str8
#      CALL r550_qce(g_head1[9].qcu04) RETURNING l_str9
#      CALL r550_qce(g_head1[10].qcu04) RETURNING l_str10
#      PRINT COLUMN 01,g_head1[1].qcu04,':',l_str1,' ',
#            COLUMN 29,g_head1[2].qcu04,':',l_str2,' ',
#            COLUMN 57,g_head1[3].qcu04,':',l_str3,' ',
#            COLUMN 85,g_head1[4].qcu04,':',l_str4
#      PRINT COLUMN 01,g_head1[5].qcu04,':',l_str5,' ',
#            COLUMN 29,g_head1[6].qcu04,':',l_str6,' ',
#            COLUMN 57,g_head1[7].qcu04,':',l_str7,' ',
#            COLUMN 85,g_head1[8].qcu04,':',l_str8
#      PRINT COLUMN 01,g_head1[9].qcu04,':',l_str9,' ',
#            COLUMN 29,g_head1[10].qcu04,':',l_str10
##No.FUN-580013--end
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#        ##CR by TSD.pinky
#       LET g_str=g_str CLIPPED,";",
#       g_head1[1].qcu04,'：',l_str1,";",
#       g_head1[2].qcu04,'：',l_str2,";",
#       g_head1[3].qcu04,'：',l_str3,";",
#       g_head1[4].qcu04,'：',l_str4,";",
#       g_head1[5].qcu04,'：',l_str5,";",
#       g_head1[6].qcu04,'：',l_str6,";",
#       g_head1[7].qcu04,'：',l_str7,";",
#       g_head1[8].qcu04,'：',l_str8,";",
#       g_head1[9].qcu04,'：',l_str9,";",
#       g_head1[10].qcu04,'：',l_str10
#
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#NO.CHI-910058 END---------------------------
 
FUNCTION r550_qce(p_qcu04)
  DEFINE p_qcu04   LIKE qcu_file.qcu04,
         l_str     LIKE adj_file.adj02       #No.FUN-680104 VARCHAR(20)
 
   SELECT qce03[1,20] INTO l_str
     FROM qce_file
    WHERE qce01 = p_qcu04
 
   RETURN l_str
END FUNCTION
 
FUNCTION r550_cre_tmp()
#No.FUN-680104-begin
  CREATE TEMP TABLE aqcr550_tmp(
    sgm04     LIKE sgm_file.sgm04,
    sgm45     LIKE sgm_file.sgm45,
    qcu04     LIKE qcu_file.qcu04,
    qcu05     LIKE qcu_file.qcu05, 
    qcm01     LIKE qcm_file.qcm01,
    qcm02     LIKE qcm_file.qcm02,
    qcm021    LIKE qcm_file.qcm021,
    qcm22     LIKE qcm_file.qcm22)
#No.FUN-680104-end
END FUNCTION
#Patch....NO.TQC-610036 <> #
