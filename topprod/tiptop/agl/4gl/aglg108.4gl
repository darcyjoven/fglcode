# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aglg108.4gl
# Descriptions...: 科目部門日記表
# Modify.........: No.FUN-510007 05/01/07 By Nicola 報表架構修改
#                                                   增加列印部門名稱gem02
# Modify.........: No.TQC-5B0045 05/11/07 By Smapmin 資料列印位置調整
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/26 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-680098 06/08/30 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6A0093 06/11/10 By Carrier 報表格式調整
# Modify.........; NO.TQC-6B0093 06/11/22 BY wujie  “接下頁/結束”位置調整 
# Modify.........: No.FUN-6C0012 06/12/26 By Judy 新增打印額外名稱欄位
# Modify.........: No.FUN-740020 07/04/06 By mike 會計科目加帳套
# Modify.........: No.TQC-6C0098 07/04/22 By Sarah QBE加一選項"是否列印內部管理科目"(aag38)
# Modify.........: No.MOD-740214 07/04/22 By Nicola 重新過單
# Modify.........: No.TQC-770047 07/07/11 Judy 加帳套時sql語句缺少條件
# Modify.........: No.FUN-760083 07/07/27 By mike   報表格式修改為crystal reports
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B20054 11/02/22 By lixiang 先錄入帳套,科目根據帳套過濾;結構改為DIALOG 
# Modify.........: No.FUN-B80158 11/08/25 By yangtt  明細類CR轉換成GRW
# Modify.........: No.FUN-B80158 12/01/16 By xuxz 修改cl_used
# Modify.........: No.FUN-C50004 12/05/10 By nanbing GR 優化
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
              wc              LIKE type_file.chr1000,      #No.FUN-680098  VARCHAR(300)  
              b_date,e_date   LIKE type_file.dat,          #No.FUN-680098  date
              d               LIKE type_file.chr1,         #No.FUN-680098  VARCHAR(1)
              e               LIKE type_file.chr1,         #No.FUN-680098  VARCHAR(1) 
              f               LIKE type_file.chr1,#額外名稱#FUN-6C0012  
              g               LIKE type_file.chr1,         #No.FUN-680098  VARCHAR(1)
              aag38           LIKE aag_file.aag38          #TQC-6C0098 add
           END RECORD,
         b               LIKE aba_file.aba00 #帳別編號  #No.FUN-740020 
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_cnt           LIKE type_file.num10     #No.FUN-680098    integer
DEFINE   g_i             LIKE type_file.num5      #count/index for any purpose   #No.FUN-680098 smallint
DEFINE   g_sql           STRING                   #No.FUN-760083
DEFINE   g_str           STRING                   #No.FUN-760083 
DEFINE   l_table         STRING                   #No.FUN-760083 
###GENGRE###START
TYPE sr1_t RECORD
    aag08 LIKE abb_file.abb03,
    aag021 LIKE aag_file.aag02,
    aag131 LIKE aag_file.aag13,
    abb03 LIKE abb_file.abb03,
    aag022 LIKE aag_file.aag02,
    aag132 LIKE aag_file.aag13,
    abb05 LIKE abb_file.abb05,
    gem02 LIKE gem_file.gem02,
    abb06 LIKE abb_file.abb06,
    abb07 LIKE abb_file.abb07,
    abb07_1 LIKE abb_file.abb07,    #FUN-B80158 add
    abb07_2 LIKE abb_file.abb07     #FUN-B80158 add
END RECORD
###GENGRE###END

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
  # CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114#FUN-B80158 mark
#No.FUN-760083  --BEGIN--
   LET g_sql = "aag08.abb_file.abb03,",   #統制科目                                                                  
               "aag021.aag_file.aag02,",  #統制科目名稱                                                              
               "aag131.aag_file.aag13,",  #額外名稱                                                  
               "abb03.abb_file.abb03,",   #科目                                                                      
               "aag022.aag_file.aag02,",  #科目名稱                                                                  
               "aag132.aag_file.aag13,",  #額外名稱                                                   
               "abb05.abb_file.abb05,",                                                                              
               "gem02.gem_file.gem02,",                                                                           
               "abb06.abb_file.abb06,",                                                                           
               "abb07.abb_file.abb07,",  
               "abb07_1.abb_file.abb07,",   #FUN-B80158  add
               "abb07_2.abb_file.abb07"     #FUN-B80158  add
   LET l_table=cl_prt_temptable("aglg108",g_sql)  CLIPPED
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-B80158 add
   IF l_table=-1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-80158 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add 
      EXIT PROGRAM 
   END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?,?,?,?,?)"     #FUN-B80158  add
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err("insert_prep:",status,1)
   END IF
#No.FUN-760083  --END--
 
   LET b = ARG_VAL(1)                        #No.FUN-740020 
   LET g_pdate  = ARG_VAL(2)             # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc    = ARG_VAL(8)
   LET tm.b_date= ARG_VAL(9)
   LET tm.e_date= ARG_VAL(10)
   LET tm.d     = ARG_VAL(11)
   LET tm.e     = ARG_VAL(12)
   LET tm.g     = ARG_VAL(13)
   LET tm.aag38 = ARG_VAL(14)   #TQC-6C0098 add
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   #No.FUN-570264 ---end---
   LET tm.f  = ARG_VAL(18)   #FUN-6C0012
   LET g_rpt_name = ARG_VAL(19)  #No.FUN-7C0078
 
   IF b = ' ' OR b IS NULL THEN   #No.FUN-740020 
      LET b = g_aza.aza81   #帳別若為空白則使用預帳別 #No.FUN-740020 
   END IF
 
   #->使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = b   #No.FUN-740020 
   IF SQLCA.sqlcode THEN
      LET g_aaa03 = g_aza.aza17
   END IF
 
   #-->使用本國幣別
   SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01 = g_aaa03   #No.CHI-6A0004 g_azi-->t_azi
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_aaa03,SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)   #No.FUN-660123
   END IF
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aglg108_tm()
   ELSE
      CALL aglg108()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
END MAIN
 
FUNCTION aglg108_tm()
 DEFINE lc_qbe_sn     LIKE gbm_file.gbm01      #No.FUN-580031
 DEFINE p_row,p_col   LIKE type_file.num5,     #No.FUN-680098  smallint
        l_cmd         LIKE type_file.chr1000   #No.FUN-680098   VARCHAR(400)
 DEFINE li_chk_bookno LIKE type_file.num5      #FUN-B20054
   CALL s_dsmark(b)   #No.FUN-740020 
   LET p_row = 2 LET p_col = 18
   OPEN WINDOW aglg108_w AT p_row,p_col
     WITH FORM "agl/42f/aglg108"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,b)   #No.FUN-740020 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.d = '1'
   LET tm.e = 'N'
   LET tm.f = 'N'   #FUN-6C0012
   LET tm.g = 'N'
   LET tm.aag38 = 'N'   #TQC-6C0098 add
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
      CONSTRUCT BY NAME tm.wc ON abb03,abb05
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
#FUN-B20054--mark--str--
#         ON ACTION locale
#            LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
#         CLOSE WINDOW aglg108_w
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#         EXIT PROGRAM
#      END IF
#FUN-B20054--mark--end 

    #  INPUT BY NAME b,tm.b_date,tm.e_date,tm.d,tm.e,tm.f,tm.g,tm.aag38 WITHOUT DEFAULTS #No.FUN-B20054  #FUN-6C0012   #TQC-6C0098 add tm.aag38
      INPUT BY NAME tm.b_date,tm.e_date,tm.d,tm.e,tm.f,tm.g,tm.aag38
                    ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---

  #FUN-B20054--mark--str--   
  #       #No.FUN-740020 --begin--
  #       AFTER FIELD  b
  #        IF b  IS NULL THEN
  #            NEXT FIELD b
  #        END IF
  #       #No.FUN-740020  --END--
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
 
         #No.FUN-740020 --begin--
         #str TQC-6C0098 add
         AFTER FIELD aag38
            IF tm.aag38 NOT MATCHES "[YN]" THEN
               NEXT FIELD aag38
            END IF

#FUN-B20054--mark--str--
#         #end TQC-6C0098 add
#         ON ACTION CONTROLP
#           CASE
#             WHEN INFIELD(b)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form="q_aaa"
#               LET g_qryparam.default1=b
#               CALL cl_create_qry() RETURNING b
#               DISPLAY BY NAME b
#               NEXT FIELD b
#           END CASE
#         #No.FUN-740020 --END --
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
#            CALL cl_about()      #MOD-4C0121
#          ON ACTION help          #MOD-4C0121
#             CALL cl_show_help()  #MOD-4C0121
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT INPUT
# 
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#        #No.FUN-580031 ---end---
#FUN-B20054--mark--end 
      END INPUT

      #FUN-B20054--add--str--
      ON ACTION CONTROLP
           CASE
             WHEN INFIELD(b)
                CALL cl_init_qry_var()
                LET g_qryparam.form="q_aaa"
                LET g_qryparam.default1=b
                CALL cl_create_qry() RETURNING b
                DISPLAY BY NAME b
                NEXT FIELD b
             WHEN INFIELD(abb03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag02"
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " aag00 = '",b CLIPPED,"'"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO abb03
                NEXT FIELD abb03
           END CASE
         #No.FUN-740020 --END --
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
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
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT DIALOG
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
         ON ACTION accept
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG=1
            EXIT DIALOG
      END DIALOG
    #FUN-B20054--add--end

    #FUN-B20054--add--str
    IF g_action_choice = "locale" THEN
       LET g_action_choice = ""
       CALL cl_dynamic_locale()
       CONTINUE WHILE
    END IF
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW aglg108_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add 
       EXIT PROGRAM
    END IF
    #FUN-B20054--add--end
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
          WHERE zz01='aglg108'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglg108','9031',1)   
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                        " '",b CLIPPED,"'" ,   #No.FUN-740020 
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.b_date CLIPPED,"'",
                        " '",tm.e_date CLIPPED,"'",
                        " '",tm.d      CLIPPED,"'",
                        " '",tm.e      CLIPPED,"'",
                        " '",tm.f CLIPPED,"'",                 #FUN-6C0012
                        " '",tm.g CLIPPED,"'",
                        " '",tm.aag38 CLIPPED,"'",             #TQC-6C0098 ada
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglg108',g_time,l_cmd)  # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aglg108_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add 
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aglg108()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aglg108_w
 
END FUNCTION
 
FUNCTION aglg108()
   DEFINE l_name        LIKE type_file.chr20,  # External(Disk) file name        #No.FUN-680098   VARCHAR(20)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0073
          l_sql         LIKE type_file.chr1000,# RDSQL STATEMENT                 #No.FUN-680098   VARCHAR(1000)
          l_chr         LIKE type_file.chr1,   #No.FUN-680098   VARCHAR(1)
          l_order       ARRAY[5] OF LIKE type_file.chr20,    #排列順序           #No.FUN-680098   VARCHAR(10) 
          l_i           LIKE type_file.num5,                 #No.FUN-680098 smallint
          sr            RECORD
                           aag08     LIKE abb_file.abb03,#統制科目
                           aag021    LIKE aag_file.aag02,#統制科目名稱
                           aag131    LIKE aag_file.aag13,#額外名稱  #FUN-6C0012
                           abb03     LIKE abb_file.abb03,#科目
                           aag022    LIKE aag_file.aag02,#科目名稱
                           aag132    LIKE aag_file.aag13,#額外名稱  #FUN-6C0012
                           abb05     LIKE abb_file.abb05,
                           gem02     LIKE gem_file.gem02,
                           abb06     LIKE abb_file.abb06,
                           abb07     LIKE abb_file.abb07,
                           abb07_1   LIKE abb_file.abb07,     #FUN-B80158 add
                           abb07_2   LIKE abb_file.abb07      #FUN-B80158 add
                        END RECORD
 
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = b   #No.FUN-740020 
      AND aaf02 = g_rlang
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND abauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND abagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND abagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT aag1.aag08,aag2.aag02,aag2.aag13,aag1.aag01,aag1.aag02,aag1.aag13,",   #FUN-6C0012
               #"       abb05,'',abb06,abb07,0,0", #FUN-C50004 mark
               "        abb05,gem02,abb06,abb07,0,0", #FUN-C50004 add
               #" FROM aba_file, abb_file, aag_file aag1, aag_file aag2",  #FUN-C50004 mark
               " FROM aba_file, abb_file LEFT OUTER JOIN gem_file ON gem01=abb05, ", #FUN-C50004 add
               " aag_file aag1, aag_file aag2", #FUN-C50004 add
               " WHERE aba00 = '",b,"'",  #No.FUN-740020 
               "   AND aag1.aag00 = '",b,"'",  #No.FUN-740020  #No.FUN-740020 
               "   AND aag1.aag00 = aag2.aag00 ",   #TQC-770047                      
               "   AND aba00 = abb00",
               "   AND aba01 = abb01",
               "   AND abb03 = aag1.aag01",
               "   AND aag1.aag08 = aag2.aag01",
               "   AND abapost = 'Y'",
               "   AND abaacti = 'Y'",
               "   AND aba02 BETWEEN '",tm.b_date,"' AND '",tm.e_date,"'",
               "   AND ",tm.wc
#  LET l_sql = l_sql CLIPPED," AND aag38 = '",tm.aag38,"'"   #TQC-6C0098 add  #TQC-770047 mark
   LET l_sql = l_sql CLIPPED," AND aag1.aag38 = '",tm.aag38,"'"   #TQC-770047    
   PREPARE aglg108_prepare1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add 
      EXIT PROGRAM
   END IF
   DECLARE aglg108_curs1 CURSOR FOR aglg108_prepare1
#No.FUN-760083 --BEGIN--
  {
   CALL cl_outnam('aglg108') RETURNING l_name     
 
   #No.FUN-6C0012 --start--                                                     
   IF tm.f = 'Y' THEN                                                           
      LET g_zaa[32].zaa06 = 'Y'                                                 
   ELSE                                                                         
      LET g_zaa[38].zaa06 = 'Y'                                                 
   END IF                                                                       
                                                                                
   CALL cl_prt_pos_len()                                                        
   #No.FUN-6C0012 --end--
 
   START REPORT aglg108_rep TO l_name
  }
   IF tm.f = 'Y' THEN
#     LET l_name = 'aglg108_1'   #FUN-B80158 mark
      LET g_template = 'aglg108_1'   #FUN-B80158 mark
   ELSE
#     LET l_name = 'aglg108'     #FUN-B80158 mark
      LET g_template = 'aglg108'     #FUN-B80158 mark
   END IF
   LET g_str=''
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
#No.FUN-760083  --end--
   LET g_pageno = 0
   LET g_cnt    = 1
 
   FOREACH aglg108_curs1 INTO sr.*
      IF STATUS != 0 THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      #SELECT gem02 INTO sr.gem02 FROM gem_file #FUN-C50004 mark
      # WHERE gem01 = sr.abb05 #FUN-C50004 mark
 
      IF tm.d='2' THEN
         LET sr.aag08 = sr.abb03
         LET sr.aag021 = sr.aag022
         LET sr.aag131 = sr.aag132  #FUN-6C0012
      END IF
 
      #FUN-B80158--------add----str-----
      IF sr.abb06 = '1' THEN
         LET sr.abb07_1 = sr.abb07
      END IF
      IF sr.abb06 = '2' THEN
         LET sr.abb07_2 = sr.abb07
      END IF
      #FUN-B80158--------end----str-----

      #OUTPUT TO REPORT aglg108_rep(sr.*)   #No.FUN-760083
      EXECUTE insert_prep USING sr.aag08,sr.aag021,sr.aag131,sr.abb03,sr.aag022,   #No.FUN-760083
                                sr.aag132,sr.abb05,sr.gem02,sr.abb06,sr.abb07,     #No.FUN-760083
                                sr.abb07_1,sr.abb07_2                              #FUN-B80158 add
   END FOREACH
 
   #FINISH REPORT aglg108_rep  #No.FUN-760083
 
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #No.FUN-760083
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  #No.FUN-760083
   IF g_zz05='Y' THEN                                  #No.FUN-760083
      CALL cl_wcchp(tm.wc,'abb03,abb05')               #No.FUN-760083
      RETURNING  tm.wc                                 #No.FUN-760083
   END IF                                              #No.FUN-760083
###GENGRE###   LET g_str = tm.wc,';',tm.b_date,';',tm.e_date,';',t_azi04,';',tm.e,';',t_azi05  #No.FUN-760083
###GENGRE###   CALL cl_prt_cs3("aglg108",l_name,g_sql,g_str)    #No.FUN-760083
    CALL aglg108_grdata()    ###GENGRE###
END FUNCTION
 
#No.FUN-760083  --begin--
{
REPORT aglg108_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,     #No.FUN-680098    VARCHAR(1)
          amt1,amt2     LIKE abb_file.abb07,                        
          sr            RECORD
                           aag08     LIKE abb_file.abb03,#統制科目
                           aag021    LIKE aag_file.aag02,#統制科目名稱
                           aag131    LIKE aag_file.aag13,#額外名稱  #FUN-6C0012
                           abb03     LIKE abb_file.abb03,#科目
                           aag022    LIKE aag_file.aag02,#科目名稱
                           aag132    LIKE aag_file.aag13,#額外名稱  #FUN-6C0012
                           abb05     LIKE abb_file.abb05,
                           gem02     LIKE gem_file.gem02,
                           abb06     LIKE abb_file.abb06,
                           abb07     LIKE abb_file.abb07
                        END RECORD
   DEFINE g_head1   STRING
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.aag08,sr.abb05
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)-1,g_x[1] CLIPPED  #No.TQC-6A0093
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         #LET g_pageno = g_pageno + 1  #No.TQC-6A0093
         LET g_head1 = g_x[9] CLIPPED,tm.b_date,'-',tm.e_date
         #PRINT g_head1                         #FUN-660060 remark
         PRINT COLUMN (g_len-25)/2+1, g_head1 CLIPPED   #FUN-660060 #No.TQC-6A0093
         PRINT g_dash[1,g_len]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]        #FUN-6C0012
         PRINT g_x[31],g_x[32],g_x[38],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37] #FUN-6C0012
         PRINT g_dash1 CLIPPED  #No.TQC-6A0093
         LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.aag08
         PRINT COLUMN g_c[31],sr.aag08,
               COLUMN g_c[32],sr.aag021,
               COLUMN g_c[38],sr.aag131;   #FUN-6C0012
 
      AFTER GROUP OF sr.abb05   #部門編號
         LET amt1 = GROUP SUM(sr.abb07) WHERE sr.abb06 = '1'
         LET amt2 = GROUP SUM(sr.abb07) WHERE sr.abb06 = '2'
         IF amt1 IS NULL THEN
            LET amt1 = 0
         END IF
         IF amt2 IS NULL THEN
            LET amt2 = 0
         END IF
         PRINT COLUMN g_c[33],sr.abb05,
               COLUMN g_c[34],sr.gem02,
               COLUMN g_c[35],cl_numfor(amt1,35,t_azi04),        #No.CHI-6A0004 g_azi-->t_azi
               COLUMN g_c[36],cl_numfor(amt2,36,t_azi04),        #No.CHI-6A0004 g_azi-->t_azi
               COLUMN g_c[37],cl_numfor(amt1-amt2,37,t_azi04)    #No.CHI-6A0004 g_azi-->t_azi
 
      AFTER GROUP OF sr.aag08
         IF tm.e='Y' THEN
            LET amt1 = GROUP SUM(sr.abb07) WHERE sr.abb06='1'
            LET amt2 = GROUP SUM(sr.abb07) WHERE sr.abb06='2'
            IF amt1 IS NULL THEN
               LET amt1 = 0
            END IF
            IF amt2 IS NULL THEN
               LET amt2 = 0
            END IF
            PRINT COLUMN g_c[34],g_dash2[1,g_w[34]+g_w[35]+g_w[36]+g_w[37]+3]
            PRINT COLUMN g_c[34],g_x[11] CLIPPED,
                  COLUMN g_c[35],cl_numfor(amt1,35,t_azi04),     #No.CHI-6A0004 g_azi-->t_azi
                  COLUMN g_c[36],cl_numfor(amt2,36,t_azi04),     #No.CHI-6A0004 g_azi-->t_azi
                  COLUMN g_c[37],cl_numfor(amt1-amt2,37,t_azi04)  #No.CHI-6A0004 g_azi-->t_azi
         END IF
         PRINT
 
      ON LAST ROW
         LET amt1 = SUM(sr.abb07) WHERE sr.abb06 = '1'
         LET amt2 = SUM(sr.abb07) WHERE sr.abb06 = '2'
         IF amt1 IS NULL THEN
            LET amt1 = 0
         END IF
         IF amt2 IS NULL THEN
            LET amt2 = 0
         END IF
#         PRINT COLUMN g_c[34],g_dash2[55,g_len]   #TQC-5B0045
#        PRINT COLUMN g_c[34],g_dash2[66,g_len]   #TQC-5B0045 #No.TQC-6A0093
         #FUN-6C0012.....begin
#         PRINT COLUMN g_c[34],g_dash2[1,g_w[34]+g_w[35]+g_w[36]+g_w[37]+3]  #No.TQC-6A0093
         IF tm.f = 'Y' THEN
            PRINT COLUMN g_c[34],g_dash2[96,g_w[34]+g_w[35]+g_w[36]+g_w[37]+3]
         ELSE
            PRINT COLUMN g_c[34],g_dash2[86,g_w[34]+g_w[35]+g_w[36]+g_w[37]+3]
         END IF
         #FUN-6C0012.....end 
         PRINT COLUMN g_c[34],g_x[10] CLIPPED,
               COLUMN g_c[35],cl_numfor(amt1,35,t_azi05),   #No.CHI-6A0004 g_azi-->t_azi
               COLUMN g_c[36],cl_numfor(amt2,36,t_azi05),    #No.CHI-6A0004 g_azi-->t_azi
               COLUMN g_c[37],cl_numfor(amt1-amt2,37,t_azi05)   #No.CHI-6A0004 g_azi-->t_azi
         LET l_last_sw = 'y'
 
      PAGE TRAILER
         PRINT g_dash[1,g_len]
         IF l_last_sw = 'n' THEN
            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED  #No.TQC-6A0093  TQC-6B0093
         ELSE
            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED  #No.TQC-6A0093  TQC-6B0093
         END IF
 
END REPORT
}
#No.FUN-760083  --end--
#Patch....NO.TQC-610035 <001> #
#No.MOD-740214

###GENGRE###START
FUNCTION aglg108_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg108")
        IF handler IS NOT NULL THEN
            START REPORT aglg108_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                         ," ORDER BY aag08,abb05"             #FUN-B80158 add
          
            DECLARE aglg108_datacur1 CURSOR FROM l_sql
            FOREACH aglg108_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg108_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg108_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg108_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B80158--------add----str-----
    DEFINE g_x9_date     STRING
    DEFINE l_amt1          LIKE abb_file.abb07
    DEFINE l_amt11         LIKE abb_file.abb07
    DEFINE l_amt2          LIKE abb_file.abb07
    DEFINE l_amt12         LIKE abb_file.abb07
    DEFINE l_amt11_amt12   LIKE abb_file.abb07
    DEFINE l_amt1_amt2     LIKE abb_file.abb07
    DEFINE l_amt21         LIKE abb_file.abb07
    DEFINE l_amt22         LIKE abb_file.abb07
    DEFINE l_amt21_amt22   LIKE abb_file.abb07
    DEFINE l_amt1_fmt      STRING
    DEFINE l_amt2_fmt      STRING
    DEFINE l_amt11_fmt     STRING
    DEFINE l_amt1_amt2_fmt STRING
    DEFINE l_amt12_fmt     STRING
    DEFINE l_amt11_amt12_fmt STRING
    DEFINE l_amt21_fmt     STRING
    DEFINE l_amt22_fmt     STRING
    DEFINE l_amt21_amt22_fmt STRING
    #FUN-B80158--------end----str-----

    
    ORDER EXTERNAL BY sr1.aag08,sr1.abb05
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name #FUN-B80158 add g_ptime,g_user_name
            PRINTX tm.*
            #FUN-B80158--------add----str-----
            LET g_x9_date = cl_gr_getmsg("gre-116",g_lang,1),':',tm.b_date,'-',tm.e_date
            PRINTX g_x9_date
            #FUN-B80158--------end----str-----
              
        BEFORE GROUP OF sr1.aag08
        BEFORE GROUP OF sr1.abb05

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.abb05
            #FUN-B80158--------add----str-----
            LET l_amt1 = GROUP SUM(sr1.abb07_1)
            LET l_amt2 = GROUP SUM(sr1.abb07_2)

            IF cl_null(l_amt1) THEN
               LET l_amt1 = 0
            ELSE
               LET l_amt1 = l_amt1
            END IF

            IF cl_null(l_amt2) THEN
               LET l_amt2 = 0
            ELSE
               LET l_amt2 = l_amt2
            END IF

            LET l_amt1_amt2 = l_amt1 - l_amt2

            PRINTX l_amt1
            PRINTX l_amt2
            PRINTX l_amt1_amt2

            LET l_amt1_fmt = cl_gr_numfmt("abb_file","abb07",t_azi04)
            LET l_amt2_fmt = cl_gr_numfmt("abb_file","abb07",t_azi04)
            LET l_amt1_amt2_fmt = cl_gr_numfmt("abb_file","abb07",t_azi04)
            PRINTX l_amt1_fmt
            PRINTX l_amt2_fmt
            PRINTX l_amt1_amt2_fmt
            #FUN-B80158--------end----str-----
        AFTER GROUP OF sr1.aag08
            #FUN-B80158--------add----str-----
            LET l_amt11 = GROUP SUM(sr1.abb07_1)
            LET l_amt12 = GROUP SUM(sr1.abb07_2)
            IF cl_null(l_amt11) THEN
               LET l_amt11 = 0
            ELSE
               LET l_amt11 = l_amt11
            END IF
            IF cl_null(l_amt12) THEN
               LET l_amt12 = 0
            ELSE
               LET l_amt12 = l_amt12
            END IF
            LET l_amt11_amt12 = l_amt11 - l_amt12
            PRINTX l_amt11
            PRINTX l_amt12
            PRINTX l_amt11_amt12

            LET l_amt11_fmt = cl_gr_numfmt("abb_file","abb07",t_azi04)
            LET l_amt12_fmt = cl_gr_numfmt("abb_file","abb07",t_azi04)
            LET l_amt11_amt12_fmt = cl_gr_numfmt("abb_file","abb07",t_azi04)
            PRINTX l_amt11_fmt
            PRINTX l_amt12_fmt
            PRINTX l_amt11_amt12_fmt
            #FUN-B80158--------end----str-----

        
        ON LAST ROW
            #FUN-B80158--------add----str-----
            LET l_amt21 = SUM(sr1.abb07_1)
            LET l_amt22 = SUM(sr1.abb07_2)
            IF cl_null(l_amt11) THEN
               LET l_amt21 = 0
            ELSE
               LET l_amt21 = l_amt21
            END IF
            IF cl_null(l_amt22) THEN
               LET l_amt22 = 0
            ELSE
               LET l_amt22 = l_amt22
            END IF
            LET l_amt21_amt22 = l_amt21 - l_amt22
            PRINTX l_amt21
            PRINTX l_amt22
            PRINTX l_amt21_amt22

            LET l_amt21_fmt = cl_gr_numfmt("abb_file","abb07",t_azi05)
            LET l_amt22_fmt = cl_gr_numfmt("abb_file","abb07",t_azi05)
            LET l_amt21_amt22_fmt = cl_gr_numfmt("abb_file","abb07",t_azi05)
            PRINTX l_amt21_fmt
            PRINTX l_amt22_fmt
            PRINTX l_amt21_amt22_fmt
            #FUN-B80158--------end----str-----

END REPORT
###GENGRE###END
