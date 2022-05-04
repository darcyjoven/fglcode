# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aglg107.4gl
# Descriptions...: 科目餘額表
# Modify.........: No.8734 03/11/19 By Kitty GROUP BY 不可用1,2,3,4,5 ora會錯
# Modify.........: No.FUN-510007 05/01/07 By Nicola 報表架構修改
# Modify.........: No.FUN-560211 05/06/23 By ching 借貸處理
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/28 By Rainy 表頭期間置於中間
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/08/30 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/26 By Judy 新增打印額外名稱欄位
# Modify.........: No.CHI-710005 07/01/18 By Elva 去掉aza26的判斷
# Modify ........: No.FUN-740020 07/04/06 By mike  會計科目加帳套
# Modify.........: No.MOD-740249 07/04/22 By Sarah 重新過單
# Modify.........: No.TQC-760105 07/06/12 By dxfwo aglg107(科目余額表) 無法印出
# Modify.........: No.FUN-760083 07/07/27 By mike 報表格式修改為crystal reports
# Modify.........: No.MOD-770122 07/08/13 By Smapmin 修改小計/合計/百分比
# Modify.........: No.MOD-930187 09/03/19 By Sarah 將小計/合計/百分比改為在4gl裡計算好再傳到CR報表顯示
# Modify.........: No.TQC-930135 09/03/23 By Sarah 計算g_tot,t_tot1時,若為Null應給予預設值0
# Modify.........: No.FUN-940013 09/04/21 By jan aag01 欄位增加開窗功能
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B20054 11/02/22 By lixiang 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.FUN-B80158 11/08/24 By yangtt  明細類CR轉換成GRW
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
              wc     LIKE type_file.chr1000,    #No.FUN-680098     VARCHAR(300) 
              yy,m1,m2  LIKE type_file.num10,   #No.FUN-680098     integer
              y      LIKE type_file.num5,       #No.FUN-680098     smallint
              e      LIKE type_file.chr1,       #FUN-6C0012
              f      LIKE type_file.num5,       #No.FUN-680098     smallint
              g      LIKE type_file.chr1        #No.FUN-680098     VARCHAR(1)
           END RECORD,
       b           LIKE aag_file.aag00,#No.FUN-740020
#       g_bookno    LIKE aba_file.aba00, #帳別編號#No.FUN-740020
       g_tot       LIKE aah_file.aah04,
       g_tot1      LIKE aah_file.aah04   #MOD-770122
DEFINE g_aaa03     LIKE aaa_file.aaa03
DEFINE g_cnt       LIKE type_file.num10    #No.FUN-680098    integer
DEFINE g_i         LIKE type_file.num5     #count/index for any purpose    #No.FUN-680098 smallint
DEFINE g_sql       STRING                  #No.FUN-760083
DEFINE g_str       STRING                  #No.FUN-760083
DEFINE l_table     STRING                  #No.FUN-760083
###GENGRE###START
TYPE sr1_t RECORD
    order1 LIKE type_file.chr4,
    aag01 LIKE aag_file.aag01,
    aag02 LIKE aag_file.aag02,
    aag13 LIKE aag_file.aag13,
    aag06 LIKE aag_file.aag06,
    aag07 LIKE aag_file.aag07,
    aag08 LIKE aag_file.aag08,
    aag24 LIKE aag_file.aag24,
    dc LIKE type_file.chr2,
    aah04 LIKE aah_file.aah04,
    aah04_1 LIKE aah_file.aah04,
    aah04_s LIKE aah_file.aah04
    ,l_aah04_1 LIKE aah_file.aah04    #FUN-B80158 add
END RECORD
###GENGRE###END

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
#No.FUN-760083  --BEGIN--
   LET g_sql = "order1.type_file.chr4,aag01.aag_file.aag01,",
               "aag02.aag_file.aag02,aag13.aag_file.aag13,",
               "aag06.aag_file.aag06,aag07.aag_file.aag07,",
               "aag08.aag_file.aag08,aag24.aag_file.aag24,",    #MOD-930187 add aag08
               "dc.type_file.chr2,aah04.aah_file.aah04,",
               "aah04_1.aah_file.aah04,aah04_s.aah_file.aah04,"  #MOD-930187 add
               ,"l_aah04_1.aah_file.aah04"   #FUN-B80158
   LET l_table=cl_prt_temptable("aglg107",g_sql) CLIPPED
   IF l_table=-1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-80158 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?)"   #MOD-930187 add 3?  #FUN-B80158 add 1?
   PREPARE insert_prep FROM g_sql 
   IF STATUS THEN 
      CALL cl_err("insert_prep:",status,1)
   END IF
  #str MOD-930187 add
   LET g_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
               "   SET aah04_1=aah04",
               " WHERE aag07  ='1' AND aag01=?" 
   PREPARE update_prep FROM g_sql 
   IF STATUS THEN 
      CALL cl_err("update_prep:",status,1)
   END IF
  #end MOD-930187 add
#No.FUN-760083  -END--
 
#  LET g_bookno=ARG_VAL(1)  #No.FUN-740020
   LET b=ARG_VAL(1)     #No.FUN-740020 
   LET g_pdate = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc  = ARG_VAL(8)
   #-----TQC-610056---------
   LET tm.yy = ARG_VAL(9)
   LET tm.m1 = ARG_VAL(10)
   LET tm.m2 = ARG_VAL(11)
   LET tm.y = ARG_VAL(12)
   LET tm.f = ARG_VAL(13)
   #-----END TQC-610056-----
   LET tm.g  = ARG_VAL(14)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   #No.FUN-570264 ---end---
   LET tm.e = ARG_VAL(18)   #FUN-6C0012
   LET g_rpt_name = ARG_VAL(19)  #No.FUN-7C0078
 
   IF b = ' ' OR b IS NULL THEN   #No.FUN-740020 
      LET b = g_aza.aza81   #帳別若為空白則使用預設帳別#No.FUN-740020 
   END IF
 
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = b   #No.FUN-740020  
   IF SQLCA.sqlcode THEN
      LET g_aaa03 = g_aza.aza17
   END IF     #使用本國幣別
 
   SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01 = g_aaa03      #No.CHI-6A0004 g_azi-->t_azi 
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_aaa03,SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)   #No.FUN-660123
   END IF
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aglg107_tm()
   ELSE
      CALL aglg107()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
END MAIN
 
FUNCTION aglg107_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01           #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680098  smallint
       l_cmd          LIKE type_file.chr1000        #No.FUN-680098  VARCHAR(400)
DEFINE li_chk_bookno  LIKE type_file.num5         #FUN-B20054

   CALL s_dsmark(b)  #No.FUN-740020 
   LET p_row = 2 LET p_col = 20
   OPEN WINDOW aglg107_w AT p_row,p_col
     WITH FORM "agl/42f/aglg107"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,b)  #No.FUN-740020 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   LET tm.yy = YEAR(TODAY)
   LET tm.m1 = 0
   LET tm.m2 = MONTH(TODAY)
   LET tm.f = 0
   LET tm.e = 'N'   #FUN-6C0012
   LET tm.g = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
    #FUN-B20054--add--str--
    DIALOG ATTRIBUTE(unbuffered)
       INPUT BY NAME b ATTRIBUTE(WITHOUT DEFAULTS)
          AFTER FIELD b
            IF NOT cl_null(b) THEN
                   CALL s_check_bookno(b,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD b
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = b
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",b,"","agl-043","","",0)
                   NEXT FIELD b
                END IF
            END IF
       END INPUT
     #FUN-B20054--add--end
      CONSTRUCT BY NAME tm.wc ON aag01,aag07
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

#FUN-B20054--mark--str--
#      #FUN-940013--begin--add
#       ON ACTION controlp 
#           CASE 
#              WHEN INFIELD(aag01)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state    = "c" 
#                   LET g_qryparam.form = "q_aag" 
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret 
#                   DISPLAY g_qryparam.multiret TO aag01
#                   NEXT FIELD aag01
#              OTHERWISE EXIT CASE
#           END CASE
#       #FUN-940013--end--add 
# 
#         ON ACTION locale
#            LET g_action_choice = "locale"
#            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#            EXIT CONSTRUCT
# 
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE CONSTRUCT
# 
#          ON ACTION about         #MOD-4C0121
#             CALL cl_about()      #MOD-4C0121
# 
#          ON ACTION help          #MOD-4C0121
#             CALL cl_show_help()  #MOD-4C0121
# 
#          ON ACTION controlg      #MOD-4C0121
#             CALL cl_cmdask()     #MOD-4C0121
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT CONSTRUCT
# 
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
#FUN-B20054--mark--end
 
      END CONSTRUCT
#FUN-B20054--mark--str--
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
# 
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         CLOSE WINDOW aglg107_w
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#         EXIT PROGRAM
#      END IF
#FUN-B20054--mark--end

    #  INPUT BY NAME b,tm.yy,tm.m1,tm.m2,tm.y,tm.f,tm.e,tm.g WITHOUT DEFAULTS   #FUN-6C0012#No.FUN-740020#No.FUN-B20054 
      INPUT BY NAME tm.yy,tm.m1,tm.m2,tm.y,tm.f,tm.e,tm.g ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---

      #FUN-B20054--mark-str--
      #   #No.FUN-740020 --BEGIN--
      #   AFTER FIELD  b
      #     IF b IS NULL THEN
      #        NEXT FIELD b
      #     END IF
      #   #No.FUN-740020  --END--
      #FUN-B20054--mark--end
         AFTER FIELD g
            IF tm.g NOT MATCHES "[YN]" THEN
               NEXT FIELD g
            END IF
 
            IF tm.g = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
#FUN-B20054--mark-str--
#        #No.FUN-740020  --BEGIN--
#         ON ACTION CONTROLP
#         CASE 
#           WHEN INFIELD(b)
#             CALL cl_init_qry_var()
#             LET g_qryparam.form='q_aaa'
#             LET g_qryparam.default1=b
#             CALL cl_create_qry() RETURNING b
#             DISPLAY BY NAME b
#             NEXT FIELD b
#         END CASE
#         #No.FUN-740020  --END--
# 
#         ON ACTION CONTROLR
#            CALL cl_show_req_fields()
# 
#         ON ACTION CONTROLG
#            CALL cl_cmdask()
# 
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE INPUT
# 
#          ON ACTION about         #MOD-4C0121
#             CALL cl_about()      #MOD-4C0121
#
#          ON ACTION help          #MOD-4C0121
#             CALL cl_show_help()  #MOD-4C0121
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT INPUT
# 
#         #No.FUN-580031 --start--
#        ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 ---end---
#FUN-B20054--mark--end 
      END INPUT

    #FUN-B20054--add--str--
      #FUN-940013--begin--add
       ON ACTION controlp 
          CASE 
              WHEN INFIELD(b)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form='q_aaa'
                   LET g_qryparam.default1=b
                   CALL cl_create_qry() RETURNING b
                   DISPLAY BY NAME b
                   NEXT FIELD b
              WHEN INFIELD(aag01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c" 
                   LET g_qryparam.form = "q_aag" 
                   LET g_qryparam.where = " aag00 = '",b CLIPPED,"'"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret 
                   DISPLAY g_qryparam.multiret TO aag01
                   NEXT FIELD aag01
              OTHERWISE EXIT CASE
           END CASE
       #FUN-940013--end--add 
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT DIALOG
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121

         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT DIALOG

         ON ACTION accept
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG=1
            EXIT DIALOG

         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
       END  DIALOG
    #FUN-B20054--add--end

 #FUN-B20054--add--str--
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglg107_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
         EXIT PROGRAM
      END IF
 #FUN-B20054--add--end
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
          WHERE zz01='aglg107'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglg107','9031',1)   
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
                        " '",b CLIPPED,"'" ,  #No.FUN-740020  
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        #-----TQC-610056---------
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.m1 CLIPPED,"'",
                        " '",tm.m2 CLIPPED,"'",
                        " '",tm.y CLIPPED,"'",
                        " '",tm.f CLIPPED,"'",
                        #-----END TQC-610056-----
                        " '",tm.g CLIPPED,"'",
                        " '",tm.e CLIPPED,"'",          #FUN-6C0012
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglg107',g_time,l_cmd)      # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aglg107_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aglg107()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aglg107_w
 
END FUNCTION
 
FUNCTION aglg107()
   DEFINE l_name    LIKE type_file.chr20,     #External(Disk) file name             #No.FUN-680098  VARCHAR(20)
#         l_time    LIKE type_file.chr8       #No.FUN-6A0073
          l_sql     LIKE type_file.chr1000,   #RDSQL STATEMENT                      #No.FUN-680098  VARCHAR(1000)
          l_chr     LIKE type_file.chr1,      #No.FUN-680098   VARCHAR(1)
          l_abb06   LIKE abb_file.abb06, 
          l_abb07   LIKE abb_file.abb07,
          l_order   ARRAY[5] OF LIKE type_file.chr20,   #排列順序   #No.FUN-680098 VARCHAR(10)
          l_i       LIKE type_file.num5,                #No.FUN-680098  smallint   #MOD-740249
          l_aag01   LIKE aag_file.aag01,                #MOD-930187 add 
          l_cnt     LIKE type_file.num5,                #MOD-930187 add 
          l_order1  LIKE aag_file.aag01,                #MOD-930187 add 
          l_dc      LIKE type_file.chr2,                #MOD-930187 add 
          s_aah04   LIKE aah_file.aah04,                #MOD-930187 add 
          s_aah04_1 LIKE aah_file.aah04,                #MOD-930187 add 
          sr        RECORD
                       order1       LIKE type_file.chr4,   #No.FUN-680098 VARCHAR(4)
                       aag01        LIKE aag_file.aag01,   #科目
                       aag02        LIKE aag_file.aag02,   #科目名稱
                       aag13        LIKE aag_file.aag13,   #額外名稱 #FUN-6C0012
                       aag06        LIKE aag_file.aag06,   #FUN-560211
                       aag07        LIKE aag_file.aag07,
                       aag08        LIKE aag_file.aag08,   #MOD-930187 add
                       aag24        LIKE aag_file.aag24,
                       dc           LIKE type_file.chr2,   #No.FUN-680098     VARCHAR(2) 
                       aah04        LIKE aah_file.aah04,
                       aah04_1      LIKE aah_file.aah04,   #MOD-930187 add
                       aah04_s      LIKE aah_file.aah04    #MOD-930187 add
                       ,l_aah04_1   LIKE aah_file.aah04   #FUN-B80158 add
                    END RECORD
 
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = b   #No.FUN-740020  
      AND aaf02 = g_rlang
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT '',aag01,aag02,aag13,aag06,aag07,aag08,aag24,'',",   #MOD-930187 add aag08
               "       SUM(aah04-aah05),0,0,0", #FUN-560211  #FUN-6C0012   #MOD-930187 add 0,0  #FUN-B80158 add 0
               "  FROM aag_file, aah_file",
               " WHERE aag03='2' AND ",tm.wc CLIPPED,
               "   AND aag01 = aah01",
               "   AND aag00 = aah00", #TQC-760105
 #             "   AND aag00 = b", #No.FUN-740020   #No.TQC-760105 
               "   AND aah00 = '",b,"'", #若為空白使用預設帳別 #No.FUN-740020  
               "   AND aah02 = ",tm.yy,
               "   AND aah03 BETWEEN ",tm.m1," AND ",tm.m2,
               " GROUP BY aag01,aag02,aag13,aag06,aag07,aag08,aag24"    #A030 #No:8734 #FUN-560211   #FUN-6C0012  #MOD-930187 add aag08
 
   PREPARE aglg107_prepare1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
      EXIT PROGRAM
   END IF
   DECLARE aglg107_curs1 CURSOR FOR aglg107_prepare1
#No.FUN-760083  --begin--
{
   CALL cl_outnam('aglg107') RETURNING l_name     
 
   #No.FUN-6C0012 --start--                                                     
   IF tm.e = 'Y' THEN                                                           
      LET g_zaa[33].zaa06 = 'Y'                                                 
   ELSE                                                                         
      LET g_zaa[37].zaa06 = 'Y'                                                 
   END IF                                                                       
                                                                                
   CALL cl_prt_pos_len()                                                        
   #No.FUN-6C0012 --end--
 
   START REPORT aglg107_rep TO l_name
}
   LET g_str=''
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file  WHERE zz01 = g_prog
#No.FUN-760083  -END--
 
   LET g_pageno = 0
   LET g_cnt    = 1
   LET g_tot    = 0
   LET g_tot1   = 0   #MOD-770122
 
   FOREACH aglg107_curs1 INTO sr.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      #add 020815  NO.A030
     #IF g_aza.aza26 = '2' AND NOT cl_null(tm.y) THEN #CHI-710005
      IF NOT cl_null(tm.y) THEN  #CHI-710005 
         IF sr.aag07 = '1' AND sr.aag24 != tm.y THEN
            CONTINUE FOREACH
         END IF
      END IF
 
      IF sr.aah04 IS NULL OR sr.aah04 = 0 THEN
         CONTINUE FOREACH
      END IF
 
     #IF sr.aah04 >= 0 THEN
      IF sr.aag06 = '1' THEN  #FUN-560211
         LET sr.dc = "D"
      ELSE
         LET sr.dc = "C"
      END IF
 
      LET l_i = tm.f
      IF l_i >= 1 AND l_i <= 4 THEN
         LET sr.order1 = sr.aag01[1,l_i]
      END IF
 
      #FUN-560211
      IF sr.aag06='1' THEN
         LET sr.aah04=sr.aah04 * 1
      ELSE
         LET sr.aah04=sr.aah04 * -1
      END IF
      #--
     #str MOD-930187 add
      IF sr.aag07!='1' THEN
         LET sr.aah04_1 = sr.aah04
      END IF
     #end MOD-930187 add
 
     #str MOD-930187 mark
     ##-----MOD-770122---------
     ##LET g_tot = g_tot + sr.aah04
     #IF sr.aag07 = '1' THEN 
     #   LET g_tot1 = g_tot1 + sr.aah04
     #ELSE
     #   LET g_tot = g_tot + sr.aah04
     #END IF
     ##-----END MOD-770122-----
     #end MOD-930187 mark

 
      #OUTPUT TO REPORT aglg107_rep(sr.*)    #No.FUN-760083
      EXECUTE insert_prep USING
         sr.order1,sr.aag01,sr.aag02,sr.aag13,sr.aag06,   #No.FUN-760083
         sr.aag07, sr.aag08,sr.aag24,sr.dc,   sr.aah04,   #No.FUN-760083  #MOD-930187 add sr.aag08
         sr.aah04_1,sr.aah04_s                                            #MOD-930187 add
         ,sr.l_aah04_1                                     #FUN-B80158
   END FOREACH
 
  #str MOD-930187 add
   LET g_sql="SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " WHERE aag08=? AND aag07!='1'"
   PREPARE aglg107_pre_0 FROM g_sql
   IF STATUS THEN CALL cl_err('aglg107_pre_0',STATUS,1) END IF
   DECLARE aglg107_cs_0 CURSOR FOR aglg107_pre_0
   LET g_sql="SELECT DISTINCT aag01 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " WHERE aag07='1'",
             " ORDER BY aag01"
   PREPARE aglg107_pre_1 FROM g_sql
   DECLARE aglg107_cs_1 CURSOR FOR aglg107_pre_1
   FOREACH aglg107_cs_1 INTO l_aag01
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
  
      #當為統制科目時,找看看Temptable裡有沒有其下的明細科目,
      #若沒有的話,LET sr.aah04_1=sr.aah04
      LET l_cnt = 0
      OPEN  aglg107_cs_0 USING l_aag01
      FETCH aglg107_cs_0 INTO l_cnt
      IF l_cnt = 0 THEN
         EXECUTE update_prep USING l_aag01
      END IF
      CLOSE aglg107_cs_0
   END FOREACH
 


   LET g_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
               "   SET aah04_s=?" 
   IF tm.f != 0 THEN
      LET g_sql = g_sql CLIPPED," WHERE order1=?"
   ELSE
      LET g_sql = g_sql CLIPPED," WHERE aag01=?"
   END IF
   PREPARE update_prep1 FROM g_sql 
   IF STATUS THEN 
      CALL cl_err("update_prep1:",status,1)
   END IF
   IF tm.f != 0 THEN
      LET g_sql="SELECT order1,SUM(aah04),SUM(aah04_1)",
                "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " GROUP BY order1"
   ELSE
      LET g_sql="SELECT aag01,SUM(aah04),SUM(aah04_1)",
                "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " GROUP BY aag01"
   END IF
   PREPARE aglg107_pre_2 FROM g_sql
   DECLARE aglg107_cs_2 CURSOR FOR aglg107_pre_2
   FOREACH aglg107_cs_2 INTO l_order1,s_aah04,s_aah04_1
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      IF (tm.f=4 AND s_aah04_1=0) OR tm.f=0 THEN
         LET s_aah04_1 = s_aah04
      END IF
      EXECUTE update_prep1 USING s_aah04_1,l_order1
   END FOREACH
 
   LET g_sql="SELECT SUM(aah04_1) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " WHERE dc=?"
   PREPARE aglg107_pre_sum FROM g_sql
   IF STATUS THEN CALL cl_err('aglg107_pre_sum',STATUS,1) END IF
   DECLARE aglg107_cs_sum CURSOR FOR aglg107_pre_sum
   LET l_dc ='D'
   OPEN  aglg107_cs_sum USING l_dc
   FETCH aglg107_cs_sum INTO g_tot
   IF cl_null(g_tot) THEN LET g_tot = 0 END IF   #TQC-930135 add
   LET l_dc ='C'
   OPEN  aglg107_cs_sum USING l_dc
   FETCH aglg107_cs_sum INTO g_tot1
   IF cl_null(g_tot1) THEN LET g_tot1 = 0 END IF   #TQC-930135 add
   LET g_tot = g_tot - g_tot1
   LET g_tot1 = g_tot 
  #end MOD-930187 add
 
   #-----MOD-770122--------- 
   #IF g_tot = 0 THEN
   #   LET g_tot = NULL
   #END IF
   IF cl_null(g_tot1) THEN
      LET g_tot1 = 0 
   END IF
   IF cl_null(g_tot) THEN
      LET g_tot = 0 
   END IF
   #-----END MOD-770122-----
 
#No.FUN-760083  --begin--
   #FINISH REPORT aglg107_rep                  
 
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len) 
   IF g_zz05 = 'Y' THEN 
     CALL cl_wcchp(tm.wc,'aag01,aag07')                                         
     RETURNING tm.wc
   END IF
   #LET g_str=tm.wc,';',t_azi05,';',g_tot,';',t_azi04,';',tm.yy,';',tm.m1,';',tm.m2,';',tm.f,';',tm.e   #MOD-770122
###GENGRE###   LET g_str=tm.wc,';',t_azi05,';',g_tot,';',t_azi04,';',tm.yy,';',tm.m1,';',tm.m2,';',tm.f,';',tm.e,';',g_tot1   #MOD-770122
###GENGRE###   LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###   CALL cl_prt_cs3("aglg107","aglg107",g_sql,g_str)
    CALL aglg107_grdata()    ###GENGRE###
#No.FUN-760083  --end--
END FUNCTION
 
#No.FUN-760083  --begin--
{
REPORT aglg107_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,                    #No.FUN-680098 VARCHAR(1)  
          l_amt1,l_amt_tot LIKE aah_file.aah04,
          l_per,l_peramt1,l_pertot   LIKE ima_file.ima18,       #No.FUN-680098 dec(9,3)
          sr            RECORD
                           order1    LIKE type_file.chr4,       #No.FUN-680098 VARCHAR(4)
                           aag01     LIKE aag_file.aag01,       #科目
                           aag02     LIKE aag_file.aag02,       #科目名稱
                           aag13     LIKE aag_file.aag13,       #額外名稱  #FUN-6C0012
                           aag06     LIKE aag_file.aag06,       #FUN-560211
                           aag07     LIKE aag_file.aag07,
                           aag24     LIKE aag_file.aag24,
                           dc        LIKE type_file.chr2,       #No.FUN-680098  VARCHAR(2)
                           aah04     LIKE aah_file.aah04
                        END RECORD
   DEFINE g_head1    STRING    
   DEFINE l_dc       LIKE type_file.chr2                         #No.FUN-680098  VARCHAR(2) 
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.order1,sr.aag01
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         LET g_head1 = g_x[9] CLIPPED,tm.yy USING '&&&&',' ',
                       g_x[10] CLIPPED,tm.m1 USING '&&','-',tm.m2 USING '&&'
         #PRINT g_head1      #FUN-660060 remark
         PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1, g_head1  #FUN-660060
         PRINT g_dash[1,g_len]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]        #FUN-6C0012
         PRINT g_x[31],g_x[32],g_x[33],g_x[37],g_x[34],g_x[35],g_x[36] #FUN-6C0012   
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.order1
         PRINT COLUMN g_c[31],sr.order1;
 
      ON EVERY ROW
         LET l_per = (sr.aah04 / g_tot) * 100
         PRINT COLUMN g_c[32],sr.aag01,
               COLUMN g_c[33],sr.aag02,
               COLUMN g_c[37],sr.aag13,     #FUN-6C0012
               COLUMN g_c[34],cl_numfor(sr.aah04,34,t_azi04),   #No.CHI-6A0004 g_azi-->t_azi 
               COLUMN g_c[35],sr.dc,
               COLUMN g_c[36],l_per USING '###&.&&'
 
      AFTER GROUP OF sr.order1
         LET g_cnt = GROUP COUNT(*)
         IF tm.f > 0 AND g_cnt>1 THEN
            LET l_amt1 = GROUP SUM(sr.aah04)
            LET l_peramt1 = (l_amt1 / g_tot) * 100
 
           #FUN-560211
            LET l_dc = " "
           #IF l_amt1 >= 0 THEN
           #   LET l_dc = "D"
           #ELSE
           #   LET l_dc = "C"
           #END IF
           #--
 
            PRINT ' '
            PRINT COLUMN g_c[33],g_x[11] CLIPPED,
                  COLUMN g_c[34],cl_numfor(l_amt1,34,t_azi04),   #No.CHI-6A0004 g_azi-->t_azi 
                  COLUMN g_c[35],l_dc,
                  COLUMN g_c[36],l_peramt1 USING '###&.&&'
         END IF
         PRINT ' '
 
      ON LAST ROW
         LET l_amt_tot = 0
         LET l_pertot = 0
         LET l_amt_tot = SUM(sr.aah04)
         LET l_pertot = (l_amt_tot / g_tot) * 100
 
         #FUN-560211
          LET l_dc = " "
         #IF l_amt_tot >= 0 THEN
         #   LET l_dc = "D"
         #ELSE
         #   LET l_dc = "C"
         #END IF
 
         PRINT ' '
         PRINT COLUMN g_c[33],g_x[12] CLIPPED,
               COLUMN g_c[34],cl_numfor(l_amt_tot,34,t_azi05),   #No.CHI-6A0004 g_azi-->t_azi 
               COLUMN g_c[35],l_dc,
               COLUMN g_c[36],l_pertot USING '###&.&&'
         LET l_last_sw = 'y'
 
      PAGE TRAILER
         PRINT g_dash[1,g_len]
         IF l_last_sw = 'n' THEN
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[36],g_x[6] CLIPPED   #FUN-6C0012
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED #FUN-6C0012
         ELSE
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[36],g_x[7] CLIPPED   #FUN-6C0012
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED #FUN-6C0012
         END IF
 
END REPORT
}
#No.FUN-760083  --end--
#Patch....NO.TQC-610035 <001> #

###GENGRE###START
FUNCTION aglg107_grdata()
    DEFINE l_sql    STRING
    DEFINE l_sql1   STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

   #FUN-B80158---add----str--
    LET g_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
                "   SET l_aah04_1 = aah04_1 * (-1)",
                " WHERE dc  ='C' AND aag01 = ?"
    PREPARE update_prep1_gr FROM g_sql
    IF STATUS THEN
       CALL cl_err("update_prep1_gr:",status,1)
    END IF
    
    LET g_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
                "   SET l_aah04_1 = aah04_1 ",
                " WHERE dc  = 'D' AND aag01 = ?"
    PREPARE update_prep2_gr FROM g_sql
    IF STATUS THEN
       CALL cl_err("update_prep2_gr:",status,1)
    END IF

    LET l_sql1 = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                ," ORDER BY order1,aag01"     #FUN-B80158 add
    DECLARE aglg107_datacur2 CURSOR FROM l_sql1
    OPEN aglg107_datacur2
    FOREACH aglg107_datacur2 INTO sr1.*
        IF sr1.dc = 'C' THEN
           EXECUTE update_prep1_gr USING sr1.aag01
        ELSE
           EXECUTE update_prep2_gr USING sr1.aag01
        END IF
    END FOREACH
    CLOSE aglg107_datacur2  
   #FUN-B80158---add----str--
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg107")
        IF handler IS NOT NULL THEN
            START REPORT aglg107_rep TO XML HANDLER handler

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY order1,aag01"     #FUN-B80158 add
            DECLARE aglg107_datacur1 CURSOR FROM l_sql
            FOREACH aglg107_datacur1 INTO sr1.*
                
                OUTPUT TO REPORT aglg107_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg107_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg107_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_aah04_1_subtot LIKE aah_file.aah04
    #FUN-B80158--------add-------str----------
    DEFINE g_cnt       LIKE type_file.num5
    DEFINE l_amt_tot   LIKE aah_file.aah04
    DEFINE l_amt1      LIKE aah_file.aah04
    DEFINE g_head1     STRING
    DEFINE l_dc        STRING
    DEFINE l_dc1       STRING
    DEFINE l_per       LIKE type_file.num20_6
    DEFINE l_peramt1   LIKE type_file.num20_6
    DEFINE l_pertot    LIKE type_file.num20_6
    DEFINE l_mingcheng1 STRING
    DEFINE l_aah04_fmt STRING
    DEFINE l_amt1_fmt  STRING
    #FUN-B80158--------add-------end----------

    
    ORDER EXTERNAL BY sr1.order1
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name #FUN-B80158 add g_ptime,g_user_name 
            PRINTX tm.*
            #FUN-B80158--------add-------str----------
            LET g_head1 = cl_gr_getmsg("gre-113",g_lang,1),':',tm.yy,' ',cl_gr_getmsg("gre-113",g_lang,2),':',tm.m1,'-',tm.m2
            PRINTX g_head1
            #FUN-B80158--------add-------end----------
              
        BEFORE GROUP OF sr1.order1

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B80158--------add-------str----------

            IF tm.f = 0 THEN
               IF g_tot = 0 THEN
                  LET l_per = 0
               ELSE
                  LET l_per = (sr1.aah04/g_tot) * 100
               END IF
            ELSE
               IF sr1.aah04_s = 0 THEN
                  LET l_per = 0
               ELSE
                  LET l_per = (sr1.aah04/sr1.aah04_s) * 100
               END IF
            END IF
            PRINTX l_per
 

            IF tm.e = 'Y' THEN
               LET l_mingcheng1 = sr1.aag13
            ELSE 
               LET l_mingcheng1 = sr1.aag02
            END IF
            PRINTX l_mingcheng1

            LET l_aah04_fmt = cl_gr_numfmt('aah_file','aah04',t_azi04)
            PRINTX l_aah04_fmt
            LET l_amt1_fmt = cl_gr_numfmt('aah_file','aah04',t_azi04)
            PRINTX l_amt1_fmt
            #FUN-B80158--------add-------end----------

            PRINTX sr1.*

        AFTER GROUP OF sr1.order1
            #FUN-B80158--------add-------str----------
            LET g_cnt = GROUP COUNT(*) 
            LET l_amt1 = GROUP SUM(sr1.l_aah04_1)
         #  IF tm.f > 0 AND g_cnt>1 THEN
         #     LET l_amt1 = GROUP SUM(sr1.aah04_1)
         #  END IF
            IF l_amt1 >= 0 THEN
               LET l_dc = 'D'
            ELSE
               LET l_dc = 'C'
            END IF
            PRINTX l_dc
    
            IF l_amt1 = 0 OR g_tot = 0 THEN 
               LET l_peramt1 = 0
            ELSE
               LET l_peramt1 = (l_amt1/g_tot) * 100
            END IF
            PRINTX l_peramt1
            PRINTX g_cnt
            IF l_amt1 < 0 THEN LET l_amt1 = l_amt1 * (-1)  END IF
            PRINTX l_amt1
            #FUN-B80158--------add-------end----------

        
        ON LAST ROW
            #FUN-B80158--------add-------str----------
            LET l_amt_tot = SUM(sr1.l_aah04_1)

            IF l_amt_tot >= 0 THEN
               LET l_dc1 = 'D'
            ELSE
               LET l_dc1 = 'C'
            END IF
            PRINTX l_dc1         
  
            IF l_amt_tot = 0 OR g_tot = 0 THEN
               LET l_pertot = 0
            ELSE
               LET l_pertot = (l_amt_tot/g_tot) * 100
            END IF
            PRINTX l_pertot

            IF l_amt_tot < 0 THEN LET l_amt_tot = l_amt_tot * (-1) END IF
            PRINTX l_amt_tot

            #FUN-B80158--------add-------end----------

END REPORT
###GENGRE###END
