# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmr516.4gl
# Descriptions...: 料件供應商資料表列印作業
# Date & Author..: 96-05-28  By  Kitty
# Modify.........: No.FUN-4B0043 04/11/15 By Nicola 加入開窗功能
# Modify.........: No.FUN-4C0095 04/12/27 By Mandy 報表轉XML
# Modify.........: No.TQC-5B0037 05/11/07 By Rosayu 修改報表結束定位點
# Modify.........: No.FUN-610018 06/01/10 By ice 採購含稅單價功能調整
# Modify.........: No.FUN-610092 06/05/23 By Joe 增加單位欄位顯示
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改   
# Modify.........: No.TQC-6A0079 06/10/31 By king 改正被誤定義為apm08類型的
# Modify.........: No.MOD-710004 07/01/26 By claire 料號變數值修改
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷 
# Modify.........: No.CHI-8C0017 08/12/17 By xiaofeizhu 一般及委外問題處理
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
             #wc      VARCHAR(500),   #TQC-630166 mark
              wc      STRING,      #TQC-630166
              s       LIKE type_file.chr3,     #No.FUN-680136 VARCHAR(3)
              t       LIKE type_file.chr3,     #No.FUN-680136 VARCHAR(3)
              u       LIKE type_file.chr3,     #No.FUN-680136 VARCHAR(3)
              type    LIKE type_file.chr2,     #No.CHI-8C0017
              more    LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)
              END RECORD
 
   DEFINE g_i         LIKE type_file.num5     #count/index for any purpose  #No.FUN-680136 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
   LET tm.type = ARG_VAL(11)     #No.CHI-8C0017
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r516_tm(0,0)
      ELSE CALL r516()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r516_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 16
 
   OPEN WINDOW r516_w AT p_row,p_col WITH FORM "apm/42f/apmr516"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
#  LET tm.choice = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.type = '1'       #CHI-8C0017
WHILE TRUE
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON pmh02, pmh01, pmh13, pmh05
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION CONTROLP    #FUN-4B0043
           IF INFIELD(pmh01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmh01
              NEXT FIELD pmh01
           END IF
           IF INFIELD(pmh02) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_qcs3"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmh02
              NEXT FIELD pmh02
           END IF
 
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
         LET INT_FLAG = 0
         CLOSE WINDOW r516_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
         EXIT PROGRAM
      END IF
      IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
      CALL cl_err('',9046,0)
   END WHILE
   INPUT BY NAME tm.type,tm.more WITHOUT DEFAULTS                            #CHI-8C0017 Add tm.type
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
         
      #CHI-8C0017--Begin--#   
      AFTER FIELD type
         IF cl_null(tm.type) OR tm.type NOT MATCHES '[12]' THEN
            NEXT FIELD type
         END IF
      #CHI-8C0017--End--#         
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
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
      CLOSE WINDOW r516_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='apmr516'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr516','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                      #  " '",tm.u CLIPPED,"'"
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",tm.type CLIPPED,"'"               #No.CHI-8C0017
         CALL cl_cmdat('apmr516',g_time,l_cmd)
      END IF
      CLOSE WINDOW r516_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r516()
   ERROR ""
END WHILE
   CLOSE WINDOW r516_w
END FUNCTION
 
FUNCTION r516()
   DEFINE l_name    LIKE type_file.chr20,       # External(Disk) file name            #No.FUN-680136 VARCHAR(20)
          l_time    LIKE type_file.chr8,        # Used time for running the job       #No.FUN-680136 VARCHAR(8)
         #l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT   #TQC-630166 mark  #No.FUN-680136 VARCHAR(1000)
          l_sql     STRING,          # RDSQL STATEMENT   #TQC-630166
          l_chr     LIKE type_file.chr1,              #No.FUN-680136 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,           #No.FUN-680136 VARCHAR(40)
      #   l_order   ARRAY[5] OF LIKE apm_file.apm08,  #No.FUN-680136 VARCHAR(10)#No.TQC-6A0079
          sr               RECORD
                                  pmh02 LIKE pmh_file.pmh02, #廠商編號
                                  pmc03 LIKE pmc_file.pmc03, #廠商簡稱
                                  pmh03 LIKE pmh_file.pmh03, #是否為主要供應廠商
                                  pmh01 LIKE pmh_file.pmh01, #料號
                                  ima02 LIKE ima_file.ima02, #品名
                                  ima06 LIKE ima_file.ima06, #分群碼
                                  pmh04 LIKE pmh_file.pmh04, #廠商料號
                                  pmh08 LIKE pmh_file.pmh08, #檢驗否
                                  pmh09 LIKE pmh_file.pmh09, #檢驗碼
                                  pmh13 LIKE pmh_file.pmh13, #幣別
                                  pmh12 LIKE pmh_file.pmh12, #最近採購單價
                                  #No.FUN-610018
                                  pmh17 LIKE pmh_file.pmh17, #稅別
                                  pmh18 LIKE pmh_file.pmh18, #稅率
                                  pmh19 LIKE pmh_file.pmh19, #最近采購含稅單價
                                  pmh11 LIKE pmh_file.pmh11, #分配比率
                                  pmh05 LIKE pmh_file.pmh05, #核准狀況碼
                                  ima44 LIKE ima_file.ima44, #單位  #No.FUN-610092
                                  pmh21 LIKE pmh_file.pmh21  #CHI-8C0017
                        END RECORD
                        
     CALL cl_outnam('apmr516') RETURNING l_name                                    #CHI-8C0017                   
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmhuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmhgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmhgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmhuser', 'pmhgrup')
     #End:FUN-980030
     
     #CHI-8C0017--Begin--#
     IF tm.type = '1' THEN
        LET g_zaa[49].zaa06 = 'Y'
     ELSE 
        LET g_zaa[49].zaa06 = 'N'
     END IF
     #CHI-8C0017--End--#     
 
     LET l_sql = "SELECT pmh02,pmc03,pmh03,",
                 " pmh01,ima02,ima06,pmh04,pmh08,pmh09,pmh13,pmh12, ",
              ## " pmh17,pmh18,pmh19,pmh11,pmh05",  #No.FUN-610018 #No.FUN-610092
                 " pmh17,pmh18,pmh19,pmh11,pmh05,ima44,pmh21 ",    #No.FUN-610092     #CHI-8C0017 Add pmh21
                 " FROM pmh_file,",
                 " OUTER ima_file, OUTER pmc_file ",
                 " WHERE pmh_file.pmh01 = ima_file.ima01 ",
                 " AND pmc_file.pmc01 = pmh_file.pmh02 ",
                 " AND pmhacti = 'Y'",                                            #CHI-910021
#                " AND pmh21 = ' ' ",                                             #CHI-860042    #CHI-8C0017 Mark
#                " AND pmh22 = '1' ",                                             #CHI-860042    #CHI-8C0017 Mark                 
                 " AND ", tm.wc CLIPPED
#    LET l_sql = l_sql CLIPPED," ORDER BY pmm01"
     #CHI-8C0017--Begin--#
     IF tm.type = '1' THEN
        LET l_sql =l_sql  CLIPPED,
             "   AND pmh22 = '1' "
            ,"   AND pmh23 = ' '"                        #No.CHI-960033
     ELSE
        LET l_sql =l_sql  CLIPPED,
             "   AND pmh22 = '2' "                  
            ,"   AND pmh23 = ' '"                        #No.CHI-960033
     END IF      
     #CHI-8C0017--End--#
     PREPARE r516_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
     END IF
     DECLARE r516_curs1 CURSOR FOR r516_prepare1
#    LET l_name = 'apmr516.out'
#    CALL cl_outnam('apmr516') RETURNING l_name                                    #CHI-8C0017 Mark     
     START REPORT r516_rep TO l_name
     FOREACH r516_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          OUTPUT TO REPORT r516_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r516_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r516_rep(sr)
   DEFINE l_ima021     LIKE ima_file.ima021     #FUN-4C0095
   DEFINE l_last_sw    LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
          t_azi03      LIKE azi_file.azi03,     #No.CHI-6A0004
          sr               RECORD
                                  pmh02 LIKE pmh_file.pmh02, #廠商編號
                                  pmc03 LIKE pmc_file.pmc03, #廠商簡稱
                                  pmh03 LIKE pmh_file.pmh03, #是否為主要供應廠商
                                  pmh01 LIKE pmh_file.pmh01, #料號
                                  ima02 LIKE ima_file.ima02, #品名
                                  ima06 LIKE ima_file.ima06, #分群碼
                                  pmh04 LIKE pmh_file.pmh04, #廠商料號
                                  pmh08 LIKE pmh_file.pmh08, #檢驗碼
                                  pmh09 LIKE pmh_file.pmh09, #檢驗碼
                                  pmh13 LIKE pmh_file.pmh13, #幣別
                                  pmh12 LIKE pmh_file.pmh12, #最近採購單價
                                  #No.FUN-610018
                                  pmh17 LIKE pmh_file.pmh17, #稅別
                                  pmh18 LIKE pmh_file.pmh18, #稅率
                                  pmh19 LIKE pmh_file.pmh19, #最近采購含稅單價
                                  pmh11 LIKE pmh_file.pmh11, #分配比率
                                  pmh05 LIKE pmh_file.pmh05, #核准狀況碼
                                  ima44 LIKE ima_file.ima44, #單位  #No.FUN-610092
                                  pmh21 LIKE pmh_file.pmh21  #CHI-8C0017
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.pmh02,sr.pmh01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38], #FUN-4C0095 印表頭
          ##g_x[39],g_x[40],g_x[41],g_x[45],g_x[46],g_x[42],g_x[47],g_x[43],g_x[44]     #No.FUN-610018
            g_x[39],g_x[40],g_x[49],g_x[41],g_x[45],g_x[46],g_x[48],g_x[42],g_x[47],g_x[43],g_x[44]     #No.FUN-610092 #CHI-8C0017 Add g_x[49]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.pmh02
      PRINT COLUMN g_c[31],sr.pmh02,
            COLUMN g_c[32],sr.pmc03;
 
#  BEFORE GROUP OF sr.pmh01
#     SELECT ima021
#       INTO l_ima021
#       FROM ima_file
#      WHERE ima01=sr.rvb05
#     IF SQLCA.sqlcode THEN
#         LET l_ima021 = NULL
#     END IF
#     PRINT COLUMN g_c[33],sr.pmh03,
#           COLUMN g_c[34],sr.pmh01,
#           COLUMN g_c[35],sr.ima02,
#           COLUMN g_c[36],l_ima021,
#           COLUMN g_c[37],sr.ima06
 
   ON EVERY ROW
      IF cl_null(sr.pmh11) THEN LET sr.pmh11 = 0 END IF
      SELECT azi03 INTO t_azi03 FROM azi_file WHERE azi01 = sr.pmh13   #No.CHI-6A0004
      SELECT ima021
        INTO l_ima021
        FROM ima_file
      #WHERE ima01=sr.rvb05  #MOD-710004 mark
       WHERE ima01=sr.pmh01  #MOD-710004 add
      IF SQLCA.sqlcode THEN
          LET l_ima021 = NULL
      END IF
      PRINT COLUMN g_c[33],sr.pmh03,
            COLUMN g_c[34],sr.pmh01,
            COLUMN g_c[35],sr.ima02,
            COLUMN g_c[36],l_ima021,
            COLUMN g_c[37],sr.ima06,
            COLUMN g_c[38],sr.pmh04,
            COLUMN g_c[39],sr.pmh08,
            COLUMN g_c[40],sr.pmh09,
            COLUMN g_c[49],sr.pmh21,                                #CHI-8C0017
            COLUMN g_c[41],sr.pmh13,
            #No.FUN-610018
            COLUMN g_c[45], sr.pmh17,
            COLUMN g_c[46], sr.pmh18 USING '-----',
            COLUMN g_c[48], sr.ima44, #No.FUN-61009
            COLUMN g_c[42],cl_numfor(sr.pmh12,42,t_azi03) CLIPPED,  #No.CHI-6A0004
            COLUMN g_c[47], cl_numfor(sr.pmh19,47,g_azi03) CLIPPED,
            COLUMN g_c[43],sr.pmh11 USING '###.##' CLIPPED,'%',
            COLUMN g_c[44],sr.pmh05
 
   AFTER GROUP OF sr.pmh02
         PRINT g_dash
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'apa01,apa02,apa03,apa04,apa05')
              RETURNING tm.wc
        #TQC-630166
        #PRINT g_dash
        #     IF tm.wc[001,070] > ' ' THEN            # for 80
        #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
        #     IF tm.wc[071,140] > ' ' THEN
        #PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
        #     IF tm.wc[141,210] > ' ' THEN
        #PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
        #     IF tm.wc[211,280] > ' ' THEN
        #PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
        CALL cl_prt_pos_wc(tm.wc)
        #END TQC-630166
      END IF
      PRINT g_dash
      LET l_last_sw = 'y'
      #PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[44], g_x[7] CLIPPED #TQC-5B0037 mark
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-8, g_x[7] CLIPPED #TQC-5B0037 add
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              #PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[44], g_x[6] CLIPPED #TQC-5B0037 mark
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED #TQC-5B0037 add
         ELSE SKIP 2 LINE
      END IF
END REPORT
