# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: axmg706.4gl
# Descriptions...: 潛在客戶等級分析表
# Date & Author..: 02/12/11 By Maggie
# Modify.........: NO.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.MOD-590003 05/09/06 By jackie 修正報表不齊
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-660167 06/06/23 By Douzh cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
#
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-CB0073 12/12/06 By chenjing 報表轉GR
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      STRING,    # Where condition
              yy      LIKE type_file.num5,        # No.FUN-680137 SMALLINT
              mm      LIKE type_file.num5,        # No.FUN-680137 SMALLINT
              more    LIKE type_file.chr1         # No.FUN-680137 VARCHAR(1)   # Input more condition(Y/N)
              END RECORD,
          b_date,e_date     LIKE type_file.dat,          #No.FUN-680137 DATE
          b_date2,e_date2   LIKE type_file.dat           #No.FUN-680137 DATE
DEFINE    g_i               LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
#FUN-CB0073--add--str--
   DEFINE  g_sql   STRING
   DEFINE  l_table STRING
   DEFINE  g_str   STRING
   TYPE sr1_t RECORD
              ofd01     LIKE ofd_file.ofd01,
              ofd02     LIKE ofd_file.ofd02,
              ofd10     LIKE ofd_file.ofd10,
              ofd11     LIKE ofd_file.ofd11,
              ofd23     LIKE ofd_file.ofd23,
              ofd25     LIKE ofd_file.ofd25,
              gem01     LIKE gem_file.gem01,
              gem02     LIKE gem_file.gem02,
              gen02     LIKE gen_file.gen02,
              class     LIKE ofd_file.ofd10,
              type      LIKE type_file.chr1
   END RECORD
#FUN-CB0073--add--end--
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
# No.FUN-680137 --start--
#FUN-CB0073--
#  CREATE TEMP TABLE r706_tmp(
#     tmp1     LIKE faj_file.faj02,       
#     tmp2     LIKE type_file.chr1,         
#     tmp3     LIKE type_file.chr1,  
#     tmp4     LIKE faj_file.faj02)       
# No.FUN-680137 ---end---
#  IF STATUS THEN CALL cl_err('create tmp',STATUS,0) 
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
#     CALL cl_gre_drop_temptable(l_table)            #FUN-CB0073
#     EXIT PROGRAM 
#  END IF
#FUN-CB0073--
#FUN-CB0073--add--str--
   LET g_sql = "ofd01.ofd_file.ofd01,",
               "ofd02.ofd_file.ofd02,",
               "ofd10.ofd_file.ofd10,",
               "ofd11.ofd_file.ofd11,",
               "ofd23.ofd_file.ofd23,",
               "ofd25.ofd_file.ofd25,",
               "gem01.gem_file.gem01,",
               "gem02.gem_file.gem02,",
               "gen02.gen_file.gen02,",
               "class.ofd_file.ofd10,",
               "type.type_file.chr1"
   LET l_table = cl_prt_temptable('axmg706',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
#FUN-CB0073--add--end--
   INITIALIZE tm.* TO NULL                # Default condition
 #--------------No.TQC-610089 modify
  #LET tm.more = 'N'
  #LET g_pdate = g_today
  #LET g_rlang = g_lang
  #LET g_bgjob = 'N'
  #LET g_copies = '1'
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.yy    = ARG_VAL(8)
   LET tm.mm    = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
 #--------------No.TQC-610089 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL axmg706_tm(0,0)             # Input print condition
      ELSE CALL axmg706()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
   CALL cl_gre_drop_temptable(l_table)            #FUN-CB0073
END MAIN
 
FUNCTION axmg706_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680137 SMALLINT
          l_cmd          LIKE type_file.chr1000,     #No.FUN-680137 VARCHAR(1000)
          l_yy           LIKE type_file.num5,        # No.FUN-680137 SMALLINT
          l_yy1          LIKE type_file.num5,        # No.FUN-680137 SMALLINT
          l_mm           LIKE type_file.num5,        # No.FUN-680137 SMALLINT
          l_mm1          LIKE type_file.num5         # No.FUN-680137 SMALLINT   
 
   LET p_row = 5 LET p_col = 13
 
   OPEN WINDOW axmg706_w AT p_row,p_col WITH FORM "axm/42f/axmg706"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 #--------------No.TQC-610089 modify
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 #--------------No.TQC-610089 end
 
   CALL cl_opmsg('p')
   LET tm.yy = YEAR(g_today)
   LET tm.mm = MONTH(g_today)
WHILE TRUE
#  DELETE FROM r706_tmp   #FUN-CB0073
   CONSTRUCT BY NAME tm.wc ON ofd01,gem01,ofd23,ofd10
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 #FUN-CB0073--add--
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD (ofd01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ofd"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " ofdacti = 'Y' "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ofd01
               NEXT FIELD ofd01
           WHEN INFIELD (ofd23)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ofd23"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ofd23
               NEXT FIELD ofd23
           WHEN INFIELD (ofd10)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ofd10"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ofd10
               NEXT FIELD ofd10
           WHEN INFIELD (gem01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gem3" 
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO gem01
               NEXT FIELD gem01
         END CASE
  #FUN-CB0073--add--
       ON ACTION locale
           #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
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
      LET INT_FLAG = 0 CLOSE WINDOW axmg706_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table)            #FUN-CB0073
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.yy,tm.mm,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
      AFTER FIELD mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.mm > 12 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF tm.mm > 13 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF cl_null(tm.mm) OR tm.mm < 0 OR tm.mm > 13 THEN NEXT FIELD mm END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      LET INT_FLAG = 0 CLOSE WINDOW axmg706_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table)            #FUN-CB0073
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmg706'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axmg706','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang   CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'" ,
                         " '",tm.yy    CLIPPED,"'" ,
                         " '",tm.mm    CLIPPED,"'" ,
                        #" '",tm.more  CLIPPED,"'"  ,           #No.TQC-610089 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axmg706',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmg706_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table)            #FUN-CB0073
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmg706()
   ERROR ""
END WHILE
   CLOSE WINDOW axmg706_w
END FUNCTION
 
FUNCTION axmg706()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
 #        l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(600) #FUN-CB0073
          l_sql     STRING,                       #FUN-CB0073
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_date    LIKE type_file.dat,          # No.FUN-680137 DATE
          l_ofe04   LIKE ofe_file.ofe04,
          l_ofe05   LIKE ofe_file.ofe05,
          l_yy,l_mm LIKE type_file.num5,         # No.FUN-680137 SMALLINT
          sr        RECORD
                    ofd01     LIKE ofd_file.ofd01,
                    ofd02     LIKE ofd_file.ofd02,
                    ofd10     LIKE ofd_file.ofd10,
                    ofd11     LIKE ofd_file.ofd11,
                    ofd23     LIKE ofd_file.ofd23,
                    ofd25     LIKE ofd_file.ofd25,
                    gem01     LIKE gem_file.gem01,
                    gem02     LIKE gem_file.gem02,
                    gen02     LIKE gen_file.gen02,
                    level     LIKE ofd_file.ofd10,
                    type     LIKE type_file.chr1        # No.FUN-680137  VARCHAR(01)
                    END RECORD
 
     CALL cl_del_data(l_table)    #FUN-CB0073
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     IF SQLCA.sqlcode THEN 
#       CALL cl_err('',SQLCA.sqlcode,0) #No.FUN-660167
        CALL cl_err3("sel","zo_file",g_rlang,"",SQLCA.sqlcode,"","",0)  #No.FUN-660167 
        END IF
#FUN-CB0073--add--str--
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table)
        EXIT PROGRAM
     END IF 
#FUN-Cb0073--add--end--
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     CALL s_azn01(tm.yy,tm.mm) RETURNING b_date,e_date
     CALL s_lsperiod(tm.yy,tm.mm) RETURNING l_yy,l_mm
     CALL s_azn01(l_yy,l_mm) RETURNING b_date2,e_date2
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN
     #         LET tm.wc = tm.wc CLIPPED," AND ofduser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN
     #         LET tm.wc = tm.wc CLIPPED," AND ofdgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc CLIPPED," AND ofdgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ofduser', 'ofdgrup')
     #End:FUN-980030
 
 
     LET l_sql="SELECT MAX(ofe02),ofe04,ofe05 ",
               "  FROM ofe_file ",
               " WHERE ofe01 = ? ",
               "   AND ofe02 BETWEEN '",b_date,"' AND '",e_date,"'",
               " GROUP BY ofe04,ofe05 ",
               " ORDER BY 1 desc"
     PREPARE axmg706_pre2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare #2:',SQLCA.sqlcode,1) EXIT PROGRAM
     END IF
     DECLARE axmg706_curs2 CURSOR FOR axmg706_pre2
 
     LET l_sql="SELECT MAX(ofe02),ofe04,ofe05 ",
               "  FROM ofe_file ",
               " WHERE ofe01 = ? AND ofe02 < '",b_date,"'",
               " GROUP BY ofe04,ofe05 ",
               " ORDER BY 1 desc"
     PREPARE axmg706_pre3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare #3:',SQLCA.sqlcode,1) EXIT PROGRAM
     END IF
     DECLARE axmg706_curs3 CURSOR FOR axmg706_pre3
 
     LET l_sql="SELECT ofd01,ofd02,ofd10,ofd11,ofd23,ofd25,",
               "       gem01,gem02,gen02,'','' ",
               "  FROM ofd_file,gen_file,gem_file",
               " WHERE ofd22 IN ('0','1','2') ",
               "   AND ofd23 = gen01 AND gen03 = gem01 ",
               "   AND ",tm.wc CLIPPED
     PREPARE axmg706_prepare FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        CALL cl_gre_drop_temptable(l_table)            #FUN-CB0073
        EXIT PROGRAM
     END IF
     DECLARE axmg706_curs CURSOR FOR axmg706_prepare
 
#    CALL cl_outnam('axmg706') RETURNING l_name     #FUN-CB0073
#    START REPORT axmg706_rep TO l_name             #FUN-CB0073
 
#    LET g_pageno = 0                               #FUN-CB0073
     FOREACH axmg706_curs INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET l_ofe04 = ''
       LET l_ofe05 = ''
       #取得當期最後異動等級
       OPEN axmg706_curs2 USING sr.ofd01
       FETCH axmg706_curs2 INTO l_date,l_ofe04,l_ofe05
       LET sr.level = l_ofe05
 
       #僅判斷目前無等級, 不回溯當期
       IF cl_null(sr.ofd10) THEN        #無等級
          LET sr.type = '0'
       END IF
       IF NOT cl_null(l_ofe05) THEN     #本月新增
          LET sr.type = '2'
       END IF
       IF cl_null(sr.level) THEN
          #取得上期最後異動等級
          OPEN axmg706_curs3 USING sr.ofd01
          FETCH axmg706_curs3 INTO l_date,l_ofe04,l_ofe05
          LET sr.level = l_ofe05
          IF cl_null(sr.type) THEN
             LET sr.type = '1'             #上月結存
          END IF
       END IF
#FUN-CB0073--mark--
#       INSERT INTO r706_tmp VALUES(sr.gem01,sr.level,sr.type,sr.ofd01)
#       IF STATUS THEN 
##         CALL cl_err('ins tmp',STATUS,0) #NO FUN-660167 
#          CALL cl_err3("ins","r706_tmp","","",STATUS,"","ins tmp",0) #No.FUN-660167
#          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
#          CALL cl_gre_drop_temptable(l_table)            #FUN-CB0073
#          EXIT PROGRAM 
#       END IF
#      OUTPUT TO REPORT axmg706_rep(sr.*)   #FUN-CB0073
#FUN-CB0073
       EXECUTE insert_prep USING sr.*        #FUN-CB0073
     END FOREACH
 #FUN-CB0073--add--str--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'ofd23,ofd01,ofd02,ofd10,ofd27,ofd28')
              RETURNING tm.wc
     ELSE
        LET tm.wc=""
     END IF
     CALL axmg706_grdata()                 
 #FUN-CB0073--add--end--
#    FINISH REPORT axmg706_rep              #FUN-CB0073
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #FUN-CB0073
END FUNCTION
 
#FUN-CB0073--mark--str--
#REPORT axmg706_rep(sr)
#   DEFINE l_last_sw LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
#          l_msg     LIKE type_file.chr8,        # No.FUN-680137 VARCHAR(08)
#          l_cnt     LIKE type_file.num5,        #No.FUN-680137 SMALLINT
#          l_level   LIKE ofd_file.ofd10,
#          sr        RECORD
#                    ofd01     LIKE ofd_file.ofd01,
#                    ofd02     LIKE ofd_file.ofd02,
#                    ofd10     LIKE ofd_file.ofd10,
#                    ofd11     LIKE ofd_file.ofd11,
#                    ofd23     LIKE ofd_file.ofd23,
#                    ofd25     LIKE ofd_file.ofd25,
#                    gem01     LIKE gem_file.gem01,
#                    gem02     LIKE gem_file.gem02,
#                    gen02     LIKE gen_file.gen02,
#                    level     LIKE ofd_file.ofd10,
#                    type      LIKE type_file.chr1        # No.FUN-680137  VARCHAR(01)
#                    END RECORD
# 
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.gem01,sr.level,sr.type,sr.ofd23,sr.ofd01
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED, pageno_total
#      PRINT ''
# 
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],
#            g_x[32],
#            g_x[33],
#            g_x[34],
#            g_x[35],
#            g_x[36],
#            g_x[37]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
# 
#   BEFORE GROUP OF sr.gem01
#      SKIP TO TOP OF PAGE
# 
#   BEFORE GROUP OF sr.level
#      PRINT COLUMN g_c[31],sr.level;
# 
#   BEFORE GROUP OF sr.type
#      CASE sr.type
#        WHEN '0' LET l_msg = g_x[11]
#        WHEN '1' LET l_msg = g_x[09]
#        WHEN '2' LET l_msg = g_x[10]
#      END CASE
#      IF cl_null(sr.level) THEN
#         SELECT COUNT(*) INTO l_cnt FROM r706_tmp
#          WHERE tmp1 = sr.gem01 AND tmp2 IS NULL AND tmp3 = sr.type
#      ELSE
#         SELECT COUNT(*) INTO l_cnt FROM r706_tmp
#          WHERE tmp1 = sr.gem01 AND tmp2 = sr.level AND tmp3 = sr.type
#      END IF
#      PRINT COLUMN g_c[32],l_msg,
#            COLUMN g_c[33],l_cnt USING '#########&';  #No.MOD-590003
# 
#   BEFORE GROUP OF sr.ofd23
#      PRINT COLUMN g_c[34],sr.ofd23,
#            COLUMN g_c[35],sr.gen02;
# 
#   ON EVERY ROW
#      PRINT COLUMN g_c[36],sr.ofd01,
#            COLUMN g_c[37],sr.ofd02
# 
#   AFTER GROUP OF sr.level
#      IF cl_null(sr.level) THEN
#         SELECT COUNT(*) INTO l_cnt FROM r706_tmp
#          WHERE tmp1 = sr.gem01 AND tmp2 IS NULL
#      ELSE
#         SELECT COUNT(*) INTO l_cnt FROM r706_tmp
#          WHERE tmp1 = sr.gem01 AND tmp2 = sr.level
#      END IF
#      PRINT ''
#      PRINT COLUMN g_c[31],g_x[12] CLIPPED,
#            COLUMN g_c[33],l_cnt USING '#########&'  #No.MOD-590003
#      PRINT g_dash2
# 
#   AFTER GROUP OF sr.gem01
#      DECLARE tot_curs CURSOR FOR
#       SELECT tmp2,COUNT(*) FROM r706_tmp WHERE tmp1 = sr.gem01
#        GROUP BY tmp2 ORDER BY tmp2
# 
#      PRINT COLUMN g_c[31],g_x[13] CLIPPED;
#      FOREACH tot_curs INTO l_level,l_cnt
#         PRINT COLUMN g_c[32],l_level,
#               COLUMN g_c[33],l_cnt USING '#########&'  #No.MOD-590003
#      END FOREACH
# 
#   ON LAST ROW
#      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#      THEN
#         CALL cl_wcchp(tm.wc,'ofd23,ofd01,ofd02,ofd10,ofd27,ofd28')
#              RETURNING tm.wc
#         PRINT g_dash[1,g_len]
#         #TQC-630166
#         #     IF tm.wc[001,070] > ' ' THEN            # for 80
#         #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#         #     IF tm.wc[071,140] > ' ' THEN
#         #PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#         #     IF tm.wc[141,210] > ' ' THEN
#         #PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#         #     IF tm.wc[211,280] > ' ' THEN
#         # PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#         CALL cl_prt_pos_wc(tm.wc)
#         #END TQC-630166
# 
#      END IF
#      LET l_last_sw = 'y'
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED     #No.MOD-590003
# 
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED    #No.MOD-590003
#      ELSE SKIP 2 LINE
#      END IF
#END REPORT
#FUN-CB0073--mark--end--
FUNCTION axmg706_grdata()
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE sr1      sr1_t
   DEFINE l_cnt    LIKE type_file.num10

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN RETURN END IF
   WHILE TRUE
       CALL cl_gre_init_pageheader()
       LET handler = cl_gre_outnam("axmg706")
       IF handler IS NOT NULL THEN
           START REPORT axmg706_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                      ," ORDER BY gem01,class,type,ofd23,ofd01"
                      

           DECLARE axmg706_datacur1 CURSOR FROM l_sql
           FOREACH axmg706_datacur1 INTO sr1.*
               OUTPUT TO REPORT axmg706_rep(sr1.*)
           END FOREACH
           FINISH REPORT axmg706_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION
#FUN-CB0073--add--str--
REPORT axmg706_rep(sr1)
   DEFINE sr1 sr1_t
   DEFINE sr1_o sr1_t
   DEFINE l_msg       STRING,       
          l_cnt       LIKE type_file.num5,
          l_cnt1      LIKE type_file.num5,
          l_cnt2      LIKE type_file.num5,
          l_level     LIKE ofd_file.ofd10
   DEFINE l_class     LIKE ofd_file.ofd10,
          l_type      LIKE type_file.chr1,
          l_ofd23     LIKE ofd_file.ofd23,
          l_gen02     LIKE gen_file.gen02 
   ORDER EXTERNAL BY sr1.gem01,sr1.class,sr1.type,sr1.ofd23,sr1.ofd01
   FORMAT
      FIRST PAGE HEADER
         PRINTX g_grPageHeader.*
         PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
         PRINTX tm.*

      BEFORE GROUP OF sr1.class
         INITIALIZE sr1_o.* TO NULL
      BEFORE GROUP OF sr1.type 
         CASE sr1.type 
            WHEN '0' LET l_msg = cl_gr_getmsg('gre-333',g_lang,0)
            WHEN '1' LET l_msg = cl_gr_getmsg('gre-333',g_lang,1)
            WHEN '2' LET l_msg = cl_gr_getmsg('gre-333',g_lang,2)
            WHEN ' ' LET l_msg = ' '
         END CASE
         PRINTX l_msg
         IF cl_null(sr1.class) THEN
            LET g_sql=" SELECT COUNT(*) FROM ", g_cr_db_str CLIPPED,l_table CLIPPED,
                      "  WHERE gem01 = '",sr1.gem01,"' AND class IS NULL AND type = '",sr1.type,"'" 
         ELSE
            LET g_sql=" SELECT COUNT(*) FROM ", g_cr_db_str CLIPPED,l_table CLIPPED,
                      "  WHERE gem01 ='", sr1.gem01,"' AND class = '",sr1.class,"' AND type = '",sr1.type,"'" 
         END IF
         PREPARE g706_class FROM g_sql
         EXECUTE g706_class INTO l_cnt
         PRINTX l_cnt USING '#########&' 

      BEFORE GROUP OF sr1.ofd23  
    
      ON EVERY ROW
 
         IF NOT cl_null(sr1_o.class) THEN 
            IF sr1_o.class = sr1.class THEN
               LET l_class = ' '
            ELSE
               LET l_class = sr1.class
            END IF
         ELSE
            LET l_class = sr1.class
         END IF
         PRINTX l_class
        
         IF NOT cl_null(sr1_o.type) THEN
            IF sr1_o.type = sr1.type THEN
               LET l_type = ' '
            ELSE
               LET l_type = sr1.type
            END IF
         ELSE
            LET l_type = sr1.type
         END IF
         PRINTX l_type

         IF NOT cl_null(sr1_o.ofd23) THEN
            IF sr1_o.ofd23 = sr1.ofd23 THEN
               LET l_ofd23 = ' ' 
            ELSE
               LET l_ofd23 = sr1.ofd23
            END IF
         ELSE
            LET l_ofd23 = sr1.ofd23
         END IF
         PRINTX l_ofd23
     
         IF NOT cl_null(sr1_o.gen02) THEN
            IF sr1_o.gen02 = sr1.gen02 THEN
               LET l_gen02 = ' '
            ELSE
               LET l_gen02 = sr1.gen02
            END IF
         ELSE
            LET l_gen02 = sr1.gen02
         END IF      
         PRINTX l_gen02

         PRINTX sr1.*

         LET sr1_o.* = sr1.*
      AFTER GROUP OF sr1.class
         IF cl_null(sr1.class) THEN
            LET g_sql = "SELECT COUNT(*) FROM ", g_cr_db_str CLIPPED,l_table CLIPPED,
                        " WHERE gem01 = '",sr1.gem01,"' AND class IS NULL"
         ELSE
            LET g_sql = "SELECT COUNT(*) FROM ", g_cr_db_str CLIPPED,l_table CLIPPED,
                        " WHERE gem01 =  '",sr1.gem01,"' AND class = '",sr1.class,"'"
         END IF
         PREPARE g706_class1 FROM g_sql
         EXECUTE g706_class1 INTO l_cnt1
         PRINTX l_cnt1 USING '#########&'

      AFTER GROUP OF sr1.gem01
         LET g_sql = " SELECT * FROM ", g_cr_db_str CLIPPED,l_table CLIPPED,
                     "  WHERE gem01 = '",sr1.gem01,"'",
                     " ORDER BY class "
         START REPORT axmg706_subrep01
         DECLARE axmg706_repcur1 CURSOR FROM g_sql 
         FOREACH axmg706_repcur1 INTO sr1.* 
            OUTPUT TO REPORT axmg706_subrep01(sr1.*)
         END FOREACH
         FINISH REPORT axmg706_subrep01

      ON LAST ROW 
END REPORT
REPORT axmg706_subrep01(sr1)      
   DEFINE sr1 sr1_t
   DEFINE l_cnt2      LIKE type_file.num5
   DEFINE l_level     LIKE ofd_file.ofd10

   ORDER EXTERNAL BY sr1.class
    FORMAT
       BEFORE GROUP OF sr1.class
       ON EVERY ROW 
       PRINTX sr1.*   
       AFTER GROUP OF sr1.class
          LET l_level = sr1.class
          PRINTX l_level
         IF cl_null(sr1.class) THEN
            LET g_sql = "SELECT COUNT(*) FROM ", g_cr_db_str CLIPPED,l_table CLIPPED,
                        " WHERE gem01 = '",sr1.gem01,"' AND class IS NULL"
         ELSE
            LET g_sql = "SELECT COUNT(*) FROM ", g_cr_db_str CLIPPED,l_table CLIPPED,
                        " WHERE gem01 =  '",sr1.gem01,"' AND class = '",sr1.class,"'"
         END IF
          PREPARE g706_class2 FROM g_sql
          EXECUTE g706_class2 INTO l_cnt2
          PRINTX l_level,l_cnt2 USING '#########&'

          ON LAST ROW
END REPORT
#FUN-CB0073--add--end--
