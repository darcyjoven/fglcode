# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aglg801.4gl
# Descriptions...: 異動明細表
# Input parameter:
# Return code....:
# Date & Author..: 92/03/13 By DAVID WANG
# Modify.........: No.FUN-510007 05/01/11 By Nicola 報表架構修改
# Modify.........: No: FUN-5C0015 06/01/05 By kevin
#                  畫面QBE加aec052異動碼類型代號，^p q_ahe。
#                  (p_zaa)序號31放寬至30
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6B0093 06/11/23 By wujie   調整“接下頁/結束”位置 
# Modify.........: No.FUN-6C0012 06/12/27 By Judy 新增打印額外名稱功能
# Modify.........: No.FUN-740020 07/04/09 By johnray 會計科目加帳套-財務
# Modify.........: No.TQC-760105 07/06/13 By dxfwo   agli802(科目異動碼預算)
               #   帳別 per應設 notnull,required打印出現 -284 error
               #   (子查詢....不只一列..)帳別未印出! 
# Modify.........: NO.FUN-7C0038 zhaijie報表輸出改為Crystal Report
# Modify.........: No.TQC-980252 09/08/25 By Carrier aec01/aec051/aec05 加開窗
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B20054 11/02/24 By lixiang 先錄入帳套,科目根據帳套過濾;結構改為DIALOG 
# Modify.........: No.FUN-B80158 11/09/07 By yangtt 明細類CR轉換成GRW
# Modify.........: NO.FUN-CB0058 12/11/26 By yangtt 4rp中的visibility condition在4gl中實現，達到單身無定位點
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
              wc        STRING,
              t         LIKE type_file.chr2,     #No.FUN-680098 VARCHAR(1)
              u         LIKE type_file.chr1,     #No.FUN-680098 VARCHAR(1)
              e         LIKE type_file.chr1,     #FUN-6C0012
              more      LIKE type_file.chr1,     #No.FUN-680098 VARCHAR(1)
              bookno    LIKE aaa_file.aaa01      #No.FUN-740020
           END RECORD,
       l_sub_bal,l_tot_bal      LIKE abb_file.abb07,
       s_sub_bal                LIKE abb_file.abb07,
       l_s_d,l_s_c,l_t_d,l_t_c  LIKE abb_file.abb07
#       g_bookno                 LIKE aaa_file.aaa01   #No.FUN-740020
DEFINE g_i                      LIKE type_file.num5     #count/index for any purpose   #No.FUN-680098 SMALLINT
DEFINE g_sql                    STRING                  #NO.FUN-7C0038
DEFINE g_str                    STRING                  #NO.FUN-7C0038
DEFINE l_table                  STRING                  #NO.FUN-7C0038
 
###GENGRE###START
TYPE sr1_t RECORD
    aec00 LIKE aec_file.aec00,
    aec01 LIKE aec_file.aec01,
    aec02 LIKE aec_file.aec02,
    aec03 LIKE aec_file.aec03,
    aec051 LIKE aec_file.aec051,
    aec05 LIKE aec_file.aec05,
    abb06 LIKE abb_file.abb06,
    abb07 LIKE abb_file.abb07,
    azi04 LIKE azi_file.azi04,
    aag02 LIKE aag_file.aag02,
    aag13 LIKE aag_file.aag13,
    #FUN-B80158----add---str--
    l_aec05 LIKE aec_file.aec05,
    l_abb07_c LIKE abb_file.abb07,
    l_abb07_d LIKE abb_file.abb07
    #FUN-B80158----add---end--
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
#NO.FUN-7C0038-------------start----------
   LET g_sql = "aec00.aec_file.aec00,",
               "aec01.aec_file.aec01,",
               "aec02.aec_file.aec02,",
               "aec03.aec_file.aec03,",
               "aec051.aec_file.aec051,",
               "aec05.aec_file.aec05,",
               "abb06.abb_file.abb06,",
               "abb07.abb_file.abb07,",
               "azi04.azi_file.azi04,",
               "aag02.aag_file.aag02,",
               "aag13.aag_file.aag13,",
               #FUN-B80158----add---str--
               "l_aec05.aec_file.aec05,",
               "l_abb07_c.abb_file.abb07,",
               "l_abb07_d.abb_file.abb07"
               #FUN-B80158----add---end--
   LET l_table = cl_prt_temptable('aglg801',g_sql) CLIPPED
   IF  l_table = -1 THEN 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80158 add
       CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
       EXIT PROGRAM END IF
   LET g_sql = " INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"   #FUN-B80158 add 3?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80158 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM
   END IF
#NO.FUN-7C0038-----------------end---------
#   LET g_bookno=ARG_VAL(1)            #No.FUN-740020
   LET tm.bookno=ARG_VAL(1)            #No.FUN-740020
   LET g_pdate = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   LET tm.e       = ARG_VAL(14)   #FUN-6C0012
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
#No.FUN-740020 -- begin --
#   IF g_bookno IS NULL OR g_bookno = ' ' THEN
#      LET g_bookno = g_aaz.aaz64
#   END IF
   IF cl_null(tm.bookno) THEN LET tm.bookno = g_aza.aza81 END IF
#No.FUN-740020 -- end --
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aglg801_tm(0,0)
   ELSE
      CALL aglg801()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
END MAIN
 
FUNCTION aglg801_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01       #No.FUN-580031
DEFINE p_row,p_col      LIKE type_file.num5,      #No.FUN-680098 smallint
          l_cmd         LIKE type_file.chr1000    #No.FUN-680098 VARCHAR(400)
DEFINE li_chk_bookno    LIKE type_file.num5       #FUN-B20054 

#   CALL s_dsmark(g_bookno)   #No.FUN-740020
   CALL s_dsmark(tm.bookno)   #No.FUN-740020
   LET p_row = 3 LET p_col = 16
   OPEN WINDOW aglg801_w AT p_row,p_col
     WITH FORM "agl/42f/aglg801"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
# Prog. Version..: '5.30.06-13.03.12(0,0,g_bookno)  #No.FUN-740020
   CALL s_shwact(0,0,tm.bookno)  #No.FUN-740020
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   LET tm.t    = 'Y'
   LET tm.u    = '1'
   LET tm.bookno = g_aza.aza81 #No.FUN-740020
   LET tm.e    = 'N'  #FUN-6C0012
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   
   DISPLAY BY NAME tm.t,tm.e,tm.bookno,tm.u,tm.more   #FUN-B20054
   WHILE TRUE
      LET l_sub_bal = 0
      LET l_s_d     = 0
      LET l_s_c     = 0
      LET l_t_d     = 0
      LET l_t_c     = 0
      LET s_sub_bal = 0

    #FUN-B20054--add--str--
    DIALOG ATTRIBUTE(unbuffered)
       INPUT BY NAME tm.bookno ATTRIBUTE(WITHOUT DEFAULTS)
          AFTER FIELD bookno
            IF NOT cl_null(tm.bookno) THEN
                   CALL s_check_bookno(tm.bookno,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD bookno
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.bookno
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",tm.bookno,"","agl-043","","",0)
                   NEXT FIELD bookno
                END IF
            END IF
       END INPUT
     #FUN-B20054--add--end
      #  FUN-5C0015 mod (s)
      #  add aec052
      #CONSTRUCT BY NAME tm.wc ON aec01,aec051,aec05,aec02
      CONSTRUCT BY NAME tm.wc ON aec01,aec051,aec052,aec05,aec02
      #  FUN-5C0015 mod (e)
 
         # FUN-5C0015 (s)
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
         
#FUN-B20054--mark--str-- 
#         ON ACTION controlp
#            CASE
#              #No.TQC-980252  --Begin
#              WHEN INFIELD(aec01)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form     = "q_aag"
#                LET g_qryparam.state    = "c"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO aec01
#                NEXT FIELD aec01
#              WHEN INFIELD(aec051)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form     = "q_aec051"
#                LET g_qryparam.state    = "c"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO aec051
#                NEXT FIELD aec051
#              WHEN INFIELD(aec05)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form     = "q_aec05"
#                LET g_qryparam.state    = "c"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO aec05
#                NEXT FIELD aec05
#              #No.TQC-980252  --End
#              WHEN INFIELD(aec052) #異動碼類型代號
#                CALL cl_init_qry_var()
#                LET g_qryparam.form     = "q_ahe"
#                LET g_qryparam.state    = "c"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO aec052
#                NEXT FIELD aec052
#              OTHERWISE EXIT CASE
#            END CASE
#         # FUN-5C0015 (e)
# 
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
#         CLOSE WINDOW aglg801_w
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#         EXIT PROGRAM
#      END IF
# 
#      IF tm.wc = ' 1=1' THEN
#         CALL cl_err('','9046',0)
#         CONTINUE WHILE
#      END IF
#FUN-B20054--mark--end
 
#No.FUN-740020 -- begin --
#      DISPLAY BY NAME tm.t,tm.u,tm.e,tm.more   #FUN-6C0012
#      INPUT BY NAME tm.t,tm.u,tm.e,tm.more WITHOUT DEFAULTS   #FUN-6C0012
#      DISPLAY BY NAME tm.t,tm.e,tm.bookno,tm.u,tm.more  #FUN-20054
#      INPUT BY NAME tm.bookno,tm.t,tm.e,tm.u,tm.more WITHOUT DEFAULTS  #FUN-B20054
       INPUT BY NAME tm.t,tm.e,tm.u,tm.more
                     ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
                     
#No.FUN-740020 -- end --

         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD t
            IF tm.t NOT MATCHES "[YN]" THEN
               NEXT FIELD t
            END IF
 
         AFTER FIELD u
            IF tm.u NOT MATCHES "[12]" THEN
               NEXT FIELD u
            END IF
  #FUN-B20054--mark-str--
  #  #No.FUN-740020 -- begin --
  #       AFTER FIELD bookno
  #          IF tm.bookno = '*' THEN
  #             NEXT FIELD bookno
  #          END IF
  #  #No.FUN-740020 -- end --
  #FUN-B20054--mark--end
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
#FUN-B20054--mark-str-- 
#    #No.FUN-740020 -- begin --                                                                                                          
#         ON ACTION CONTROLP
#            CASE
#              WHEN INFIELD(bookno)                                                                                                   
#                CALL cl_init_qry_var()                                                                                              
#                LET g_qryparam.form     = "q_aaa"                                                                                   
#                LET g_qryparam.default1 = tm.bookno
#                CALL cl_create_qry() RETURNING tm.bookno                                                          
#                DISPLAY tm.bookno TO bookno                                                                            
#                NEXT FIELD bookno
#              OTHERWISE EXIT CASE
#            END CASE
#    #No.FUN-740020 -- end --
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
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 ---end---
#FUN-B20054--mark--end
 
      END INPUT
      
     #FUN-B20054--add--str--
      ON ACTION controlp
            CASE
              WHEN INFIELD(bookno)                                                                                                   
                CALL cl_init_qry_var()                                                                                              
                LET g_qryparam.form     = "q_aaa"                                                                                   
                LET g_qryparam.default1 = tm.bookno
                CALL cl_create_qry() RETURNING tm.bookno                                                          
                DISPLAY tm.bookno TO bookno                                                                            
                NEXT FIELD bookno
              #No.TQC-980252  --Begin
              WHEN INFIELD(aec01)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_aag"
                LET g_qryparam.state    = "c"
                LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aec01
                NEXT FIELD aec01
              WHEN INFIELD(aec051)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_aec051"
                LET g_qryparam.state    = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aec051
                NEXT FIELD aec051
              WHEN INFIELD(aec05)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_aec05"
                LET g_qryparam.state    = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aec05
                NEXT FIELD aec05
              #No.TQC-980252  --End
              WHEN INFIELD(aec052) #異動碼類型代號
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_ahe"
                LET g_qryparam.state    = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aec052
                NEXT FIELD aec052
              OTHERWISE EXIT CASE
            END CASE
         # FUN-5C0015 (e)
 
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
  
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglg801_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
         EXIT PROGRAM
      END IF

      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
#FUN-B20054--add--end   
  
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
          WHERE zz01='aglg801'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglg801','9031',1)  
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
#                        " '",g_bookno CLIPPED,"'", #No.FUN-740020
                        " '",tm.bookno CLIPPED,"'", #No.FUN-740020
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",   #TQC-610056
                        " '",tm.u CLIPPED,"'",   #TQC-610056
                        " '",tm.e CLIPPED,"'",   #FUN-6C0012
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglg801',g_time,l_cmd)      # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aglg801_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aglg801()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aglg801_w
 
END FUNCTION
 
FUNCTION aglg801()
   DEFINE l_name      LIKE type_file.chr20,         #No.FUN-680098 VARCHAR(20)
#       l_time          LIKE type_file.chr8          #No.FUN-6A0073
          l_sql       LIKE type_file.chr1000,       #No.FUN-680098 VARCHAR(1000)
          l_chr       LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
          l_order     ARRAY[5] OF LIKE type_file.chr20,   #No.FUN-680098  VARCHAR(10)
          l_aec05     STRING,                #FUN-B80158 add
          sr          RECORD
                         aec00 LIKE aec_file.aec00,       #No.FUN-740020
                         aec01 LIKE aec_file.aec01,
                         aec02 LIKE aec_file.aec02,
                         aec03 LIKE aec_file.aec03,
                         aec051 LIKE aec_file.aec051,
                         aec05 LIKE aec_file.aec05,
                         abb06 LIKE abb_file.abb06,
                         abb07 LIKE abb_file.abb07,
                         azi04 LIKE azi_file.azi04,
                         aag02 LIKE aag_file.aag02,
                         aag13 LIKE aag_file.aag13,         #FUN-6C0012
                         #FUN-B80158-----add----str---
                         l_aec05 LIKE aec_file.aec05,
                         l_abb07_c LIKE abb_file.abb07,
                         l_abb07_d LIKE abb_file.abb07
                         #FUN-B80158-----add----end---
                      END RECORD
   CALL cl_del_data(l_table)                                #NO.FUN-7C0038
 
   SELECT aaf03 INTO g_company FROM aaf_file
#    WHERE aaf01 = g_bookno       #No.FUN-740020
    WHERE aaf01 = tm.bookno       #No.FUN-740020
      AND aaf02 = g_rlang
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aglg801' #NO.FUN-7C0038 
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
   #End:FUN-980030
 
#No.FUN-740020 -- begin --
    LET l_sql = "SELECT aec00,aec01,aec02,aec03,aec051,aec05,abb06,abb07,azi04,'','',0,0 ",   #FUN-B80158 add aec05 2 0
                "  FROM aec_file,abb_file,aaa_file,azi_file,aag_file " ,
 #               " WHERE aec00 = '",g_bookno,"'",
                " WHERE aec00 = '",tm.bookno,"'",
 #No.FUN-740020 -- end --
                "   AND aec00 = abb00 AND aec01 = abb03 ",   #TQC-760105 
 #              "   AND aec00 = abb00  ",                    #TQC-760105  無效的關聯，加上去會限制資料。
                "   AND abb01 = aec03 AND abb02 = aec04 ",
 #              "   AND abb02 = aec04 ",                     #TQC-760105
                "   AND aec00 = aaa01 AND aaa03 = azi01 "
   
   IF tm.u ='1' THEN
#      LET l_sql =l_sql CLIPPED," AND aag01 =aec01 AND aag07 IN ('1','3') "   #No.FUN-740020
#     LET l_sql =l_sql CLIPPED," AND aag01 =aec01 AND aag00 =aec00 AND aag07 MATCHES '[13]' "   #No.FUN-740020
      LET l_sql =l_sql CLIPPED," AND aag01 =aec01 AND aag00 =aec00 AND aag07 IN ('1','3') "   #No.TQC-760105
   ELSE
#      LET l_sql =l_sql CLIPPED," AND aag01 =aec01 AND aag07 = '2' "   #No.FUN-740020
#     LET l_sql =l_sql CLIPPED," AND aag01 =aec01 aag00 =aec00 AND aag07 MATCHES '[2]' "   #No.FUN-740020
      LET l_sql =l_sql CLIPPED," AND aag01 =aec01 and aag00 =aec00 AND aag07 IN ('2') "   #No.TQC-760105 MATCHES不是ORACLE寫法，導致數據不能轉換，進而打印不出報表
 
   END IF
 
   LET l_sql =l_sql CLIPPED, "   AND ",tm.wc
 
   LET l_sql = l_sql CLIPPED," ORDER BY aec01,aec05,aec02,aec03 "   #NO:2761
 
   PREPARE aglg801_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM
   END IF
   DECLARE aglg801_curs1 CURSOR FOR aglg801_prepare1
 
#   CALL cl_outnam('aglg801') RETURNING l_name             #NO.FUN-7C0038
#   START REPORT aglg801_rep TO l_name                     #NO.FUN-7C0038
 
#   LET g_pageno = 0                                       #NO.FUN-7C0038
 
   FOREACH aglg801_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT aag02,aag13 INTO sr.aag02,sr.aag13 FROM aag_file   #FUN-6C0012
       WHERE aag01 = sr.aec01
       AND aag00 = tm.bookno    #No.FUN-740020
#      OUTPUT TO REPORT aglg801_rep(sr.*)                  #NO.FUN-7C0038
 
          #FUN-B80158----add----str---
            LET l_aec05 = sr.aec05
            LET sr.l_aec05 = l_aec05.touppercase()
            IF sr.abb06 = '2' THEN
               IF sr.abb07 >= 0 THEN
                  LET sr.l_abb07_c = sr.abb07
               ELSE
                  LET sr.l_abb07_c = sr.abb07 * (-1)
               END IF
            ELSE
               LET sr.l_abb07_c = 0
            END IF

            IF sr.abb06 = '1' THEN
               LET sr.l_abb07_d = sr.abb07
            ELSE
               LET sr.l_abb07_d = 0
            END IF
            #FUN-B80158-----add-----end------
#NO.FUN-7C0038-------------start---------
      EXECUTE insert_prep USING
        sr.aec00,sr.aec01,sr.aec02,sr.aec03,sr.aec051,sr.aec05,sr.abb06,
        sr.abb07,sr.azi04,sr.aag02,sr.aag13
        ,sr.l_aec05,sr.l_abb07_c,sr.l_abb07_d         #FUN-B80158
#NO.FUN-7C0038--------------end-------------
 
   END FOREACH
 
#   FINISH REPORT aglg801_rep                              #NO.FUN-7C0038
 
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)            #NO.FUN-7C0038 
#NO.FUN-7C0038------------start---------
###GENGRE###    LET g_sql = " SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'aec01,aec051,aec052,aec05,aec02')
          RETURNING tm.wc
    END IF
###GENGRE###    LET g_str = tm.wc,";",tm.t,";",tm.e
###GENGRE###    CALL cl_prt_cs3('aglg801','aglg801',g_sql,g_str)
    CALL aglg801_grdata()    ###GENGRE###
#NO.FUN-7C0038---------------end-------
END FUNCTION
#NO.FUN-7C0038---------------start-----mark---------
#REPORT aglg801_rep(sr)
#DEFINE l_last_sw     LIKE type_file.chr1,       #No.FUN-680098 VARCHAR(1)
#       sr            RECORD
#                        aec00 LIKE aec_file.aec00,   #No.FUN-740020
#                        aec01 LIKE aec_file.aec01,
#                        aec02 LIKE aec_file.aec02,
#                        aec03 LIKE aec_file.aec03,
#                        aec051 LIKE aec_file.aec051,
#                        aec05 LIKE aec_file.aec05,
#                        abb06 LIKE abb_file.abb06,
#                        abb07 LIKE abb_file.abb07,
#                        azi04 LIKE azi_file.azi04,
#                        aag02 LIKE aag_file.aag02,
#                        aag13 LIKE aag_file.aag13   #FUN-6C0012
#                     END RECORD,
#       l_chr         LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.aec01,sr.aec051,sr.aec05,sr.aec02
 
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED,pageno_total
#         PRINT
#         PRINT g_dash[1,g_len]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#         PRINT g_dash1
#         LET l_last_sw = 'n'
 
#      BEFORE GROUP OF sr.aec01
#         IF tm.t='Y' THEN
#            SKIP TO TOP OF PAGE
#         END IF
#         PRINT COLUMN g_c[31],g_x[9] CLIPPED,
#               COLUMN g_c[32],sr.aec01;
##               COLUMN g_c[33],sr.aag02     #FUN-6C0012
         #FUN-6C0012.....begin
#         IF tm.e = 'N' THEN
#            PRINT COLUMN g_c[33],sr.aag02
#         ELSE
#            PRINT COLUMN g_c[33],sr.aag13
#         END IF
#         #FUN-6C0012.....end  
#         PRINT ' '
 
#      BEFORE GROUP OF sr.aec05
#         LET l_chr ='0'
 
#      ON EVERY ROW
#         IF l_chr = '0' THEN
#            LET l_chr ='1'
#            PRINT COLUMN g_c[31],sr.aec05 CLIPPED,
#                  COLUMN g_c[32],sr.aec02,
#                  COLUMN g_c[33],sr.aec03;
#         ELSE
#            PRINT COLUMN g_c[32],sr.aec02,
#                  COLUMN g_c[33],sr.aec03;
#         END IF
 
#         IF sr.abb06 = '1' THEN
#            LET l_sub_bal = l_sub_bal + sr.abb07
#            PRINT COLUMN g_c[34],cl_numfor(sr.abb07,34,sr.azi04);
#            LET l_s_d = l_s_d + sr.abb07
#            LET l_t_d = l_t_d + sr.abb07
#         ELSE
#            LET l_sub_bal = l_sub_bal - sr.abb07
#            PRINT COLUMN g_c[35],cl_numfor(sr.abb07,35,sr.azi04);
#            LET l_s_c = l_s_c + sr.abb07
#            LET l_t_c = l_t_c + sr.abb07
#         END IF
 
#         IF l_sub_bal >= 0 THEN
#            PRINT COLUMN g_c[36],cl_numfor(l_sub_bal,36,sr.azi04),
#                  COLUMN g_c[37],'D'
#         ELSE
#            LET l_sub_bal = l_sub_bal *(-1)
#            PRINT COLUMN g_c[36],cl_numfor(l_sub_bal,36,sr.azi04),
#                  COLUMN g_c[37],'C'
#            LET l_sub_bal = l_sub_bal *(-1)
#         END IF
#         LET s_sub_bal = s_sub_bal + l_sub_bal
 
#      AFTER GROUP OF sr.aec05
#         PRINT '  '
#         PRINT COLUMN g_c[33],g_x[10] CLIPPED,
#               COLUMN g_c[34],cl_numfor(l_s_d,34,sr.azi04),
#               COLUMN g_c[35],cl_numfor(l_s_c,35,sr.azi04)
#         PRINT '  '
#         LET l_sub_bal=0
#         LET l_s_d=0
#         LET l_s_c=0
# 
#      AFTER GROUP OF sr.aec01
#         PRINT '  '
#         PRINT COLUMN g_c[33],g_x[11] CLIPPED,
#               COLUMN g_c[34],cl_numfor(l_t_d,34,sr.azi04),
#               COLUMN g_c[35],cl_numfor(l_t_c,35,sr.azi04);
#         IF s_sub_bal >=0 THEN
#            PRINT COLUMN g_c[36],cl_numfor(s_sub_bal,36,sr.azi04),
#                  COLUMN g_c[37],'D'
#         ELSE
#            LET s_sub_bal=s_sub_bal*(-1)
#            PRINT COLUMN g_c[36],cl_numfor(s_sub_bal,36,sr.azi04),
#                  COLUMN g_c[37],'C'
#            LET s_sub_bal=s_sub_bal*(-1)
#         END IF
#         PRINT '  '
#         LET l_t_d=0
#         LET l_t_c=0
#         LET s_sub_bal=0
# 
#      ON LAST ROW
#         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#            CALL cl_wcchp(tm.wc,'aec01,aec02,aec03,aec051,aec05') RETURNING tm.wc
#            PRINT g_dash[1,g_len]
#          #-- TQC-630166 begin
#            #IF tm.wc[001,070] > ' ' THEN                  # for 80
#            #   PRINT COLUMN g_c[31],g_x[8] CLIPPED,
#            #         COLUMN g_c[32],tm.wc[001,070] CLIPPED
#            #END IF
#            #IF tm.wc[071,140] > ' ' THEN
#            #   PRINT COLUMN g_c[32],tm.wc[071,140] CLIPPED
#            #END IF
#            #IF tm.wc[141,210] > ' ' THEN
#            #   PRINT COLUMN g_c[32],tm.wc[141,210] CLIPPED
#            #END IF
#            #IF tm.wc[211,280] > ' ' THEN
#            #   PRINT COLUMN g_c[32],tm.wc[211,280] CLIPPED
#            #END IF
#            CALL cl_prt_pos_wc(tm.wc)
#          #-- TQC-630166 end
#         END IF
#
#         PRINT g_dash[1,g_len]
#         LET l_last_sw = 'y'
#         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED              #No.TQC-6B0093
# 
#      PAGE TRAILER
#         IF l_last_sw = 'n' THEN
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED              #No.TQC-6B0093
#         ELSE
#            SKIP 2 LINE
#         END IF
#
#END REPORT
#NO.FUN-7C0038---------------end-------mark------------

###GENGRE###START
FUNCTION aglg801_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg801")
        IF handler IS NOT NULL THEN
            START REPORT aglg801_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY aec01,aec051,aec02"    #FUN-B80158 add
          
            DECLARE aglg801_datacur1 CURSOR FROM l_sql
            FOREACH aglg801_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg801_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg801_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg801_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr1_o sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B80158-----add---str----
    DEFINE b_gc33        LIKE aag_file.aag02
    DEFINE g_c36         LIKE abb_file.abb07
    DEFINE g_c37         LIKE type_file.chr1 
    DEFINE g_c37_hj      LIKE type_file.chr1 
    DEFINE l_sub_bal     LIKE abb_file.abb07
    DEFINE s_sub_bal     LIKE abb_file.abb07
    DEFINE l_abb07_fmt   STRING
    DEFINE l_sum_c       LIKE abb_file.abb07
    DEFINE l_sum_d       LIKE abb_file.abb07
    DEFINE l_sum_c_1     LIKE abb_file.abb07
    DEFINE l_sum_d_1     LIKE abb_file.abb07
    DEFINE l_sum_c_2     LIKE abb_file.abb07
    DEFINE l_sum_d_2     LIKE abb_file.abb07
    DEFINE l_display     LIKE type_file.chr1
    #FUN-B80158-----add---end----
    DEFINE l_aec05       LIKE aec_file.aec05     #FUN-CB0058

    
    ORDER EXTERNAL BY sr1.aec01,sr1.aec051,sr1.l_aec05
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B80158 add g_ptime,g_user_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.aec01
            #FUN-B80158-----add-----str------
            IF tm.e = 'N' THEN
               LET b_gc33 = sr1.aag02
            ELSE
               LET b_gc33 = sr1.aag13
            END IF
            PRINTX b_gc33            
            #FUN-B80158-----add-----end------
        BEFORE GROUP OF sr1.aec051
        BEFORE GROUP OF sr1.l_aec05

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B80158-----add-----str------
            LET l_abb07_fmt = cl_gr_numfmt("abb_file","abb07",sr1.azi04)
            PRINTX l_abb07_fmt

            IF NOT cl_null(sr1_o.l_aec05) THEN
               IF sr1.l_aec05 != sr1_o.l_aec05 THEN
                  LET l_display = 'Y'
                  LET l_aec05 = sr1.aec05   #FUN-CB0058
               ELSE
                  LET l_display = 'N'
                  LET l_aec05 = "   "       #FUN-CB0058
               END IF
            ELSE
               LET l_display = 'Y'
               LET l_aec05 = sr1.aec05   #FUN-CB0058
            END IF
            PRINTX l_display
            PRINTX l_aec05     #FUN-CB0058

            IF cl_null(sr1_o.aec01) AND cl_null(sr1_o.aec05) THEN
               IF sr1.abb06 = '2' AND sr1.abb07 > 0 THEN
                  LET l_sub_bal = sr1.abb07 * (-1)
               ELSE
                  LET l_sub_bal = sr1.abb07
               END IF
            ELSE
               IF sr1_o.aec05 = sr1.aec05 AND sr1_o.aec01 = sr1.aec01 THEN
                  IF sr1.abb06 = '1' THEN
                     LET l_sub_bal = l_sub_bal + sr1.abb07
                  ELSE
                     LET l_sub_bal = l_sub_bal - sr1.abb07
                  END IF
               ELSE
                  IF sr1.abb06 = '2' AND sr1.abb07 > 0 THEN
                     LET l_sub_bal= sr1.abb07 * (-1)
                  ELSE
                     LET l_sub_bal = sr1.abb07
                  END IF
               END IF
            END IF
            PRINTX l_sub_bal

            IF l_sub_bal >= 0 THEN
               LET g_c36 = l_sub_bal
               LET g_c37 = 'D'
            ELSE
               LET g_c36 = l_sub_bal * (-1)
               LET g_c37 = 'C'
            END IF
            PRINTX g_c36 
            PRINTX g_c37 

            LET sr1_o.* = sr1.*

            PRINTX sr1.*

        AFTER GROUP OF sr1.aec01
            #FUN-B80158-----add-----str------
            IF (GROUP SUM(sr1.l_abb07_d) -GROUP SUM(sr1.l_abb07_c)) > 0 THEN
               LET s_sub_bal = GROUP SUM(sr1.l_abb07_d) -GROUP SUM(sr1.l_abb07_c)
            ELSE
               LET s_sub_bal = GROUP SUM(sr1.l_abb07_c) -GROUP SUM(sr1.l_abb07_d)
            END IF
            PRINTX s_sub_bal

            IF (GROUP SUM(sr1.l_abb07_d) -GROUP SUM(sr1.l_abb07_c)) >= 0 THEN
                LET g_c37_hj = 'D'
            ELSE
                LET g_c37_hj = 'C'
            END IF
            PRINTX g_c37_hj
              
            LET l_sum_c = GROUP SUM (sr1.l_abb07_c)
            PRINTX l_sum_c
            LET l_sum_d = GROUP SUM (sr1.l_abb07_d)
            PRINTX l_sum_d
            #FUN-B80158-----add-----end------
        AFTER GROUP OF sr1.aec051
            #FUN-B80158-----add-----str------
            LET l_sum_c_1 = GROUP SUM (sr1.l_abb07_c)
            PRINTX l_sum_c_1
            LET l_sum_d_1 = GROUP SUM(sr1.l_abb07_d)
            PRINTX l_sum_d_1
            #FUN-B80158-----add-----end------
        AFTER GROUP OF sr1.l_aec05
            #FUN-B80158-----add-----str------
            LET l_sum_c_2 = GROUP SUM (sr1.l_abb07_c)
            PRINTX l_sum_c_2
            LET l_sum_d_2 = GROUP SUM(sr1.l_abb07_d)
            PRINTX l_sum_d_2
            #FUN-B80158-----add-----end------

        
        ON LAST ROW

END REPORT
###GENGRE###END
