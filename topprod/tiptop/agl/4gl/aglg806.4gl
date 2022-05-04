# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aglg806.4gl
# Descriptions...: 科目異動碼異動期報表
# Input parameter:
# Return code....:
# Date & Author..: 92/09/25 By yen
#                  By Melody    aee00 改為 no-use
# Modify.........: No.MOD-4C0156 04/12/24 By Kitty 帳別無法開窗,per配合調整
# Modify.........: No.MOD-4C0171 05/01/06 By Nicola 修改參數第一個保留給帳別
# Modify.........: No.FUN-580010 05/08/11 By trisy 2.0憑証類報表修改,轉XML格式
# Modify.........: No.FUN-5C0015 06/01/06 By kevin 畫面QBE加aed012異動碼類型代號，
#                  ^p q_ahe，(p_zaa)序號32放寬至60
#                  原列印aag15~18，改抓ahe02 ( ahe01=aag15~18，aag31~36)
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/29 By Rainy 表頭期間置於中間
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670005 06/07/07 By Hellen 帳別權限修改
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6B0093 06/11/23 By wujie  增加總頁數 
# Modify.........: No.FUN-6C0012 06/12/27 By Judy 新增打印科目額外名稱功能
# Modify.........: No.FUN-740020 07/04/09 By Lynn 會計科目加帳套-財務
# Modify.........: No.TQC-760105 07/06/15 By arman 在select中增加aed00字段
# Modify.........: No.FUN-780059 07/08/29 By xiaofeizhu 報表改寫由Crystal Report產出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-950059 10/03/05 By huangrh 類型無法在MSV中列印
# Modify.........: No.MOD-A60138 10/06/22 By Dido 語法調整,空白改在 FOREACH 處理�
# Modify.........: No.MOD-A70200 10/07/28 By Dido 增加 aed011 與 aed02 條件 
# Modify.........: No.FUN-B20054 11/02/22 By xianghui 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.MOD-B60204 11/06/24 By Polly 帳別的預設值改為agls103的預設帳別aaz64
# Modify.........: No.FUN-B90028 11/09/14 By qirl 明細CR報表轉GR
# Modify.........: No.FUN-C20080 12/02/20 By lujh 去掉異動金額前面的空格
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000,# Where condition   #No.FUN-680098 VARCHAR(300)
              aed03   LIKE type_file.num10,  # 年度   #No.FUN-680098   integer
              aed04_b LIKE aed_file.aed04,   # 截止期別
              aed04_e LIKE aed_file.aed04,   # 截止期別
              aed00   LIKE aed_file.aed00,   # 帳別
              t       LIKE type_file.chr2,   #每一科目列印完是否跳頁(Y/N)  #No.FUN-680098   VARCHAR(1) 
              e       LIKE type_file.chr1,   #列印額外名稱 #FUN-6C0012
              more    LIKE type_file.chr1    # Input more condition(Y/N)   #No.FUN-680098 VARCHAR(1)   
              END RECORD 
#         g_bookno   LIKE aed_file.aed00 #帳別
    
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose   #No.FUN-680098  smallint
#--str FUN-780059 add--#                                                                                                            
DEFINE   l_table      STRING                                                                                                        
DEFINE   g_sql        STRING                                                                                                        
DEFINE   g_str        STRING                                                                                                        
#--end FUN-780059 add--#
 
###GENGRE###START
TYPE sr1_t RECORD
    aed01 LIKE aed_file.aed01,
    aag02 LIKE aag_file.aag02,
    aag13 LIKE aag_file.aag13,
    aed02 LIKE aed_file.aed02,
    aee04 LIKE aee_file.aee04,
    d_c LIKE aed_file.aed05,
    l_buff LIKE type_file.chr1000
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 #--str FUN-780059 add--#                                                                                                           
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##                                                          
   LET g_sql = "aed01.aed_file.aed01,",                                                                                             
               "aag02.aag_file.aag02,",                                                                                             
               "aag13.aag_file.aag13,",                                                                                             
               "aed02.aed_file.aed02,",                                                                                           
               "aee04.aee_file.aee04,",                                                                                           
               "d_c.aed_file.aed05,",                                                                                           
               "l_buff.type_file.chr1000"                                                                                               
                                                                                                                                    
   LET l_table = cl_prt_temptable('aglg806',g_sql) CLIPPED   # 產生Temp Table                                                       
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                       
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?, ?, ?, ?, ?, ?, ?)"                                                                     
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF                                                                                                                           
   #------------------------------ CR (1) ------------------------------#
 
 
   #-->金額小數位數
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_aaz.aaz64
   SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01 = g_aaa03           #No.CHI-6A0004 g_azi-->t_azi
    #-----No.MOD-4C0171-----
#  LET g_bookno = ARG_VAL(1)   #TQC-610056      #No.FUN-740020
   LET g_pdate   = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom  = ARG_VAL(3)
   LET g_rlang   = ARG_VAL(4)
   LET g_bgjob   = ARG_VAL(5)
   LET g_prtway  = ARG_VAL(6)
   LET g_copies  = ARG_VAL(7)
   LET tm.wc     = ARG_VAL(8)
   LET tm.aed03  = ARG_VAL(9)
   LET tm.aed04_b= ARG_VAL(10)
   LET tm.aed04_e= ARG_VAL(11)
   LET tm.aed00  = ARG_VAL(12)
   LET tm.t      = ARG_VAL(13)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   #No.FUN-570264 ---end---
   LET tm.e      = ARG_VAL(17)  #FUN-6C0012
   LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
 
    #-----No.MOD-4C0171 END-----
#No.FUN-740020 ---begin
#  IF cl_null(g_bookno) THEN
#     LET g_bookno = g_aaz.aaz64
#  END IF
#No.FUN-740020 ---end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'  # If background job sw is off
      THEN CALL aglg806_tm(0,0)          # Input print condition
      ELSE CALL aglg806()                # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)   #FUN-B90028 add
END MAIN
 
FUNCTION aglg806_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01           #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680098 SMALLINT
          l_cmd       LIKE type_file.chr1000        #No.FUN-680098 VARCHAR(400)
   DEFINE li_chk_bookno  LIKE type_file.num5        #No.FUN-670005   #No.FUN-680098 smallint 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 10 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 16
   ELSE LET p_row = 4 LET p_col = 10
   END IF
   OPEN WINDOW aglg806_w AT p_row,p_col
        WITH FORM "agl/42f/aglg806"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.aed03 = YEAR(TODAY)
#  LET tm.aed00 = '00'          #No.FUN-740020 #No.MOD-B60204 mark
   LET tm.aed00 = g_aaz.aaz64   #No.MOD-B60204 add
   LET tm.t     = 'N'
   LET tm.e     = 'N'  #FUN-6C0012
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   DISPLAY BY NAME tm.t,tm.e,tm.more       #No.FUN-B20054
WHILE TRUE
#NO.FUN-B20054--add--start--
      DIALOG ATTRIBUTE(unbuffered)
         INPUT BY NAME tm.aed00 ATTRIBUTE(WITHOUT DEFAULTS)
            AFTER FIELD aed00
              IF NOT cl_null(tm.aed00) THEN
                   CALL s_check_bookno(tm.aed00,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD aed00
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.aed00   AND aaaacti IN ('Y','y')
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",tm.aed00,"","agl-043","","",0)
                   NEXT FIELD aed00
                END IF
             END IF
         END INPUT

#NO.FUN-B20054--add--end--
   

  # FUN-5C0015 (s)
   #CONSTRUCT BY NAME tm.wc ON aed01,aed011,aed02
   CONSTRUCT BY NAME tm.wc ON aed01,aed011,aed012,aed02
   # FUN-5C0015 (e)
 
   # FUN-5C0015 (s)
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--start-- 
#         ON ACTION controlp
#            CASE
#              WHEN INFIELD(aed012) #異動碼類型代號
#                CALL cl_init_qry_var()
#                LET g_qryparam.form     = "q_ahe"
#                LET g_qryparam.state    = "c"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO aed012
#                NEXT FIELD aed012
#              OTHERWISE EXIT CASE
#            END CASE
#         # FUN-5C0015 (e)
# 
#       ON ACTION locale
#           #CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET g_action_choice = "locale"
#         EXIT CONSTRUCT
# 
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE CONSTRUCT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
# 
#           ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT CONSTRUCT
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--end-- 
  END CONSTRUCT

#No.FUN-B20054--mark--start--
#       IF g_action_choice = "locale" THEN
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
# 
# 
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW aglg806_w 
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#      EXIT PROGRAM
#         
#   END IF
#   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
#
#No.FUN-B20054--mark--end--
#   DISPLAY BY NAME tm.t,tm.e,tm.more         # Condition  #FUN-6C0012  #No.FUN-B20054
#   INPUT BY NAME tm.aed03,tm.aed04_b,tm.aed04_e,tm.aed00,tm.t,tm.e,tm.more  #FUN-6C0012  #No.FUN-B20054
#         WITHOUT DEFAULTS                                               #No.FUN-B20054
     INPUT BY NAME tm.aed03,tm.aed04_b,tm.aed04_e,tm.t,tm.e,tm.more ATTRIBUTE(WITHOUT DEFAULTS)     #No.FUN-B20054

     #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD aed03
         IF cl_null(tm.aed03)
            THEN NEXT FIELD aed03
         END IF
      BEFORE FIELD aed04_e
         IF cl_null(tm.aed04_b) OR tm.aed04_b > 13 THEN
            CALL cl_err('aed04','agl-013',0)
            NEXT FIELD aed04_b
         END IF
      #no.7277

#No.FUN-B20054--mark--start--
#      AFTER FIELD aed00
## genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
#         IF tm.aed00 IS NULL THEN NEXT FIELD aed00 END IF
#         #No.FUN-670005--begin
#             CALL s_check_bookno(tm.aed00,g_user,g_plant) 
#                  RETURNING li_chk_bookno
#             IF (NOT li_chk_bookno) THEN
#                  NEXT FIELD aed00 
#             END IF 
#         #No.FUN-670005--end  
#         SELECT aaa02 FROM aaa_file WHERE aaa01=tm.aed00
#                                      AND aaaacti IN ('Y','y')
#         IF STATUS THEN 
##            CALL cl_err('sel aaa:',STATUS,0) # NO.FUN-660123
#             CALL cl_err3("sel","aaa_file",tm.aed00,"",STATUS,"","sel aaa:",0)  # NO.FUN-660123
#            NEXT FIELD aed00 
#          END IF
#      #no.7277(end)
#No.FUN-B20054-mark--end--
      BEFORE FIELD t
         IF cl_null(tm.aed04_e) OR tm.aed04_e > 13 THEN
            CALL cl_err('aed04','agl-013',0)
            NEXT FIELD aed04_e
         END IF
         IF tm.aed04_b > tm.aed04_e THEN
            CALL cl_err('aed04','agl-157',0)
            NEXT FIELD aed04_b
         END IF
      AFTER FIELD t
         IF tm.t NOT MATCHES "[YN]"
            THEN NEXT FIELD t
         END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF

#No.FUN-B20054--mark--start--
#################################################################################
## START genero shell script ADD
#   ON ACTION CONTROLR
#      CALL cl_show_req_fields()
## END genero shell script ADD
#################################################################################
#      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
#      ON ACTION CONTROLP
#          #No.MOD-4C0156 add
#         IF  INFIELD(aed00) THEN
##           CALL q_aaa(0,0,tm.aed00) RETURNING tm.aed00
##           CALL FGL_DIALOG_SETBUFFER(tm.aed00 )
#            CALL cl_init_qry_var()
#            LET g_qryparam.form = 'q_aaa'
#            LET g_qryparam.default1 = tm.aed00
#            CALL cl_create_qry() RETURNING tm.aed00
##            CALL FGL_DIALOG_SETBUFFER(tm.aed00)
#            DISPLAY BY NAME tm.aed00
#            NEXT FIELD aed00
#         END IF
#          #No.MOD-4C0156 end
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
# 
#          ON ACTION exit
#          LET INT_FLAG = 1
#          EXIT INPUT
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 ---end---
#No.FUN-B20054-mark--end-- 
   END INPUT
#No.FUN-B20054--add--start--

       ON ACTION CONTROLP
          CASE
             WHEN  INFIELD(aed00) 
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_aaa'
                LET g_qryparam.default1 = tm.aed00
                CALL cl_create_qry() RETURNING tm.aed00
                DISPLAY BY NAME tm.aed00
                NEXT FIELD aed00
               WHEN INFIELD(aed01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag02"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.where = " aag00 = '",tm.aed00 CLIPPED,"'"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aed01
                  NEXT FIELD aed01
             WHEN INFIELD(aed012) #異動碼類型代號
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_ahe"
                LET g_qryparam.state    = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aed012
                NEXT FIELD aed012
             OTHERWISE EXIT CASE 
          END CASE


         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT DIALOG

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION exit
            LET INT_FLAG = 1
            EXIT DIALOG

         ON ACTION qbe_save
            CALL cl_qbe_save()

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
#No.FUN-B20054--add-end--

   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aglg806_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)   #FUN-B90028 add
      EXIT PROGRAM

#No.FUN-B20054--add--start--
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
#No.FUN-B20054--add-end--

         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aglg806'
      IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
         CALL cl_err('aglg806','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
#                        " '",g_bookno CLIPPED,"'",   #TQC-610056        #No.FUN-740020
                         " '",tm.aed00 CLIPPED,"'",
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.aed03 CLIPPED,"'",
                         " '",tm.aed04_b CLIPPED,"'",
                         " '",tm.aed04_e CLIPPED,"'",
                         " '",tm.aed00 CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",  #FUN-6C0012
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aglg806',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aglg806_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)   #FUN-B90028 add
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aglg806()
   ERROR ""
END WHILE
   CLOSE WINDOW aglg806_w
END FUNCTION
 
FUNCTION aglg806()
   DEFINE l_name    LIKE type_file.chr20,      # External(Disk) file name       #No.FUN-680098  VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0073
          l_sql     LIKE type_file.chr1000,    # RDSQL STATEMENT                #No.FUN-680098 VARCHAR(1000)
          l_za05    LIKE za_file.za05,         #No.FUN-680098 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE type_file.chr20,     #No.FUN-680098 VARCHAR(10)
          l_buff1   LIKE type_file.num20_6,    # TQC-950059  add
          l_buff    LIKE type_file.chr1000,    # FUN-780059  add 
          l_name1   STRING,                    # FUN-780059  add
          l_ahe02a  LIKE ahe_file.ahe02,       #MOD-A60138 
          l_ahe02b  LIKE ahe_file.ahe02,       #MOD-A60138  
          l_ahe02c  LIKE ahe_file.ahe02,       #MOD-A60138 
          l_ahe02d  LIKE ahe_file.ahe02,       #MOD-A60138
          l_ahe02e  LIKE ahe_file.ahe02,       #MOD-A60138 
          l_ahe02f  LIKE ahe_file.ahe02,       #MOD-A60138 
          l_ahe02g  LIKE ahe_file.ahe02,       #MOD-A60138 
          l_ahe02h  LIKE ahe_file.ahe02,       #MOD-A60138 
          l_ahe02i  LIKE ahe_file.ahe02,       #MOD-A60138 
          l_ahe02j  LIKE ahe_file.ahe02,       #MOD-A60138 
          sr            RECORD aed00 LIKE aed_file.aed00,
                               aed01 LIKE aed_file.aed01,  # 科目編號
                               aag02 LIKE aag_file.aag02,  # 科目名稱
                               aag13 LIKE aag_file.aag13,  #FUN-6C0012
                               aag15 LIKE aag_file.aag15,  # 異動碼-1 說明
                               aag16 LIKE aag_file.aag16,  # 異動碼-2 說明
                               aag17 LIKE aag_file.aag17,  # 異動碼-3 說明
                               aag18 LIKE aag_file.aag18,  # 異動碼-4 說明
                               # FUN-5C0015 add (s)
                               aag31 LIKE aag_file.aag31,  # 異動碼-5
                               aag32 LIKE aag_file.aag32,  # 異動碼-6
                               aag33 LIKE aag_file.aag33,  # 異動碼-7
                               aag34 LIKE aag_file.aag34,  # 異動碼-8
                               aag35 LIKE aag_file.aag35,  # 異動碼-9
                               aag36 LIKE aag_file.aag36,  # 異動碼-10
                              #ahe02a LIKE ahe_file.ahe02,                  #MOD-A60138 mark
                              #ahe02b LIKE ahe_file.ahe02,                  #MOD-A60138 mark 
                              #ahe02c LIKE ahe_file.ahe02,                  #MOD-A60138 mark
                              #ahe02d LIKE ahe_file.ahe02,                  #MOD-A60138 mark
                              #ahe02e LIKE ahe_file.ahe02,                  #MOD-A60138 mark
                              #ahe02f LIKE ahe_file.ahe02,                  #MOD-A60138 mark
                              #ahe02g LIKE ahe_file.ahe02,                  #MOD-A60138 mark
                              #ahe02h LIKE ahe_file.ahe02,                  #MOD-A60138 mark
                              #ahe02i LIKE ahe_file.ahe02,                  #MOD-A60138 mark
                              #ahe02j LIKE ahe_file.ahe02,                  #MOD-A60138 mark
                               # FUN-5C0015 add (e)
                               aed02 LIKE aed_file.aed02,  # 異動碼
                               aee04 LIKE aee_file.aee04,  # 異動碼說明
                             # aee06 LIKE aee_file.aee06,  # 日期
                               d_c   LIKE aed_file.aed05   # 金額
                        END RECORD
   #--str FUN-780059 add--#                                                                                                         
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##                                                            
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                                                        
   #------------------------------ CR (2) ------------------------------#                                                           
   #--end FUN-780059 add--#
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND aeeuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND aeegrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND aeegrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aeeuser', 'aeegrup')
     #End:FUN-980030
 
#    LET l_sql = "SELECT aed01, aag02, aag13, aag15, aag16, aag17, aag18,",  #FUN-6C0012
     LET l_sql = "SELECT aed00,aed01, aag02, aag13, aag15, aag16, aag17, aag18,",   #NO.TQC-760105
                 # FUN-5C0015 add (s)
                 "       aag31,aag32,aag33,aag34,aag35,aag36,",    
                #"       '','','','','','','','','','',",          #MOD-A60138 mark 
                 # FUN-5C0015 add (e)
                 "       aed02, aee04, SUM(aed05 - aed06)",
                #"  FROM aed_file LEFT OUTER JOIN aag_file ON aed01 = aag_file.aag01  LEFT OUTER JOIN aee_file ON aed01 = aee_file.aee01 ",                                                                                                                    #MOD-A70200 mark
		 "  FROM aed_file LEFT OUTER JOIN aag_file ON aed00 = aag_file.aag00 AND aed01 = aag_file.aag01  LEFT OUTER JOIN aee_file ON aed00 = aee_file.aee00 AND aed01 = aee_file.aee01 AND aed011 = aee_file.aee02 AND aed02 = aee_file.aee03 ",       #MOD-A70200
                 "  WHERE aed00 ='",tm.aed00,"'",  #no.7277
                 "   AND aed03 = '",tm.aed03,"'",
                 "   AND aed04 >= '",tm.aed04_b,"'",
                 "   AND aed04 <= '",tm.aed04_e,"'",
                #"   AND aag00 = aee00",                #MOD-A70200 mark
                 "   AND ",tm.wc CLIPPED,
                 # FUN-5C0015 add (s)
                 # GROUP BY 1,2,3,4,5,6,7,8
                 " GROUP BY aed00,aed01,aag02,aag13,aag15,aag16,aag17,aag18,",  #FUN-6C0012
                 "          aag31,aag32,aag33,aag34,aag35,aag36,",
                #"          '','','','','','','','','','',",        #MOD-A60138 mark 
                 "          aed02,aee04"
                 # FUN-5C0015 add (e)
     PREPARE aglg806_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        CALL cl_gre_drop_temptable(l_table)   #FUN-B90028 add
        EXIT PROGRAM
           
     END IF
     DECLARE aglg806_curs1 CURSOR FOR aglg806_prepare1
 
#    CALL cl_outnam('aglg806') RETURNING l_name                     #FUN-780059--mark
 
     #FUN-6C0012.....begin
     IF tm.e = 'Y' THEN
         LET g_zaa[35].zaa06 ='Y'                                               
         LET g_zaa[36].zaa06 ='N'
#        LET l_name1 = 'aglg806_1'         #FUN-B90028 mark                                         
         LET g_template = 'aglg806_1'      #FUN-B90028 add                                            
      ELSE                                                                      
         LET g_zaa[36].zaa06 ='Y'                                               
         LET g_zaa[35].zaa06 ='N'
#        LET l_name1 = 'aglg806'           #FUN-B90028 mark                                    
         LET g_template = 'aglg806'        #FUN-B90028 add                                         
      END IF                                                                    
      CALL cl_prt_pos_len()
     #FUN-6C0012.....end
#    START REPORT aglg806_rep TO l_name                             #FUN-780059--mark
 
     LET g_pageno = 0
     FOREACH aglg806_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        # FUN-5C0015 add(s)
        SELECT ahe02 INTO l_ahe02a FROM ahe_file     #MOD-A60138 sr.ahe02a -> l_ahe02a 
          WHERE ahe01 = sr.aag15
        SELECT ahe02 INTO l_ahe02b FROM ahe_file     #MOD-A60138 sr.ahe02b -> l_ahe02b
          WHERE ahe01 = sr.aag16
        SELECT ahe02 INTO l_ahe02c FROM ahe_file     #MOD-A60138 sr.ahe02c -> l_ahe02c
          WHERE ahe01 = sr.aag17
        SELECT ahe02 INTO l_ahe02d FROM ahe_file     #MOD-A60138 sr.ahe02d -> l_ahe02d
          WHERE ahe01 = sr.aag18
        SELECT ahe02 INTO l_ahe02e FROM ahe_file     #MOD-A60138 sr.ahe02e -> l_ahe02e
          WHERE ahe01 = sr.aag31
        SELECT ahe02 INTO l_ahe02f FROM ahe_file     #MOD-A60138 sr.ahe02f -> l_ahe02f
          WHERE ahe01 = sr.aag32
        SELECT ahe02 INTO l_ahe02g FROM ahe_file     #MOD-A60138 sr.ahe02g -> l_ahe02g
          WHERE ahe01 = sr.aag33
        SELECT ahe02 INTO l_ahe02h FROM ahe_file     #MOD-A60138 sr.ahe02h -> l_ahe02h 
          WHERE ahe01 = sr.aag34
        SELECT ahe02 INTO l_ahe02i FROM ahe_file     #MOD-A60138 sr.ahe02i -> l_ahe02i
          WHERE ahe01 = sr.aag35
        SELECT ahe02 INTO l_ahe02j FROM ahe_file     #MOD-A60138 sr.ahe02j -> l_ahe02j 
          WHERE ahe01 = sr.aag36
        # FUN-5C0015 add(s)
#--str-FUN-780059-add--#
      LET l_buff = NULL                                                                                                             
      IF NOT cl_null(l_ahe02a) THEN                  #MOD-A60138 sr.ahe02a -> l_ahe02a
         LET l_buff = l_ahe02a                       #MOD-A60138 sr.ahe02a -> l_ahe02a 
      END IF                                                                                                                        
      IF NOT cl_null(l_ahe02b) THEN                  #MOD-A60138 sr.ahe02b -> l_ahe02b 
         LET l_buff = l_buff CLIPPED,' ',l_ahe02b    #MOD-A60138 sr.ahe02b -> l_ahe02b                                                                                
      END IF                                                                                                                        
      IF NOT cl_null(l_ahe02c) THEN                  #MOD-A60138 sr.ahe02c -> l_ahe02c                                                                                        
         LET l_buff = l_buff CLIPPED,' ',l_ahe02c    #MOD-A60138 sr.ahe02c -> l_ahe02c                                                                              
      END IF                                                                                                                        
      IF NOT cl_null(l_ahe02d) THEN                  #MOD-A60138 sr.ahe02d -> l_ahe02d 
         LET l_buff = l_buff CLIPPED,' ',l_ahe02d    #MOD-A60138 sr.ahe02d -> l_ahe02d                                                                              
      END IF                                                                                                                        
      IF NOT cl_null(l_ahe02e) THEN                  #MOD-A60138 sr.ahe02e -> l_ahe02e                                                                              
         LET l_buff = l_buff CLIPPED,' ',l_ahe02e    #MOD-A60138 sr.ahe02e -> l_ahe02e                                                                              
      END IF                                                                                                                        
      IF NOT cl_null(l_ahe02f) THEN                  #MOD-A60138 sr.ahe02f -> l_ahe02f                                                                              
         LET l_buff = l_buff CLIPPED,' ',l_ahe02f    #MOD-A60138 sr.ahe02f -> l_ahe02f                                                                              
      END IF                                                                                                                        
      IF NOT cl_null(l_ahe02g) THEN                  #MOD-A60138 sr.ahe02g -> l_ahe02g                                                                               
         LET l_buff = l_buff CLIPPED,' ',l_ahe02g    #MOD-A60138 sr.ahe02g -> l_ahe02g                                                                              
      END IF                                                                                                                        
      IF NOT cl_null(l_ahe02h) THEN                  #MOD-A60138 sr.ahe02h -> l_ahe02h                                                                              
         LET l_buff = l_buff CLIPPED,' ',l_ahe02h    #MOD-A60138 sr.ahe02h -> l_ahe02h                                                                              
      END IF                                                                                                                        
      IF NOT cl_null(l_ahe02i) THEN                  #MOD-A60138 sr.ahe02i -> l_ahe02i                                                                               
         LET l_buff = l_buff CLIPPED,' ',l_ahe02i    #MOD-A60138 sr.ahe02i -> l_ahe02i                                                                              
      END IF                                                                                                                        
      IF NOT cl_null(l_ahe02j) THEN                  #MOD-A60138 sr.ahe02j -> l_ahe02j                                                                              
         LET l_buff = l_buff CLIPPED,' ',l_ahe02j    #MOD-A60138 sr.ahe02j -> l_ahe02j                                                                              
      END IF
      IF cl_null(l_buff) THEN LET l_buff1=0 END IF               #TQC-950059 add
      LET l_buff1=l_buff                                         #TQC-950059 add

#--end-FUN-780059-add--#
#       OUTPUT TO REPORT aglg806_rep(sr.*)                       #FUN-780059--mark
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
        #             sr.aed01,sr.aag02,sr.aag13,sr.aed02,sr.aee04,sr.d_c,l_buff  #No.TQC-950059
                      sr.aed01,sr.aag02,sr.aag13,sr.aed02,sr.aee04,sr.d_c,l_buff1 #No.TQC-950059
          #------------------------------ CR (3) ------------------------------#
     END FOREACH
 
#    FINISH REPORT aglg806_rep                                   #FUN-780059--mark
 
#-str-FUN-780059--add--#                                                                                                            
         IF g_zz05 = 'Y' THEN                                                                                                       
            CALL cl_wcchp(tm.wc,'aed01,aed011,aed012,aed02') RETURNING tm.wc                                                  
         END IF                                                                                                                     
#-end-FUN-780059--add--#                               
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                 #FUN-780059--mark
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-770052 **** ##                                                        
###GENGRE###    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
###GENGRE###    LET g_str = tm.wc,";",tm.aed03,";",tm.aed04_b,";",tm.aed04_e,";",          
###GENGRE###                tm.t,";",t_azi04,";",t_azi05                                                                               
###GENGRE###    CALL cl_prt_cs3('aglg806',l_name1,l_sql,g_str)                                                                                
    CALL aglg806_grdata()    ###GENGRE###
    #------------------------------ CR (4) ------------------------------# 
END FUNCTION
 
#--str-FUN-780059--mark--#
#REPORT aglg806_rep(sr)
#  DEFINE l_last_sw     LIKE type_file.chr1,               #No.FUN-680098 VARCHAR(1)
#         sr            RECORD aed00 LIKE aed_file.aed00,  #No.FUN-740020
#                              aed01 LIKE aed_file.aed01,  # 科目編號
#                              aag02 LIKE aag_file.aag02,  # 科目名稱
#                              aag13 LIKE aag_file.aag13,  #FUN-6C0012
#                              aag15 LIKE aag_file.aag15,  # 異動碼-1 說明
#                              aag16 LIKE aag_file.aag16,  # 異動碼-2 說明
#                              aag17 LIKE aag_file.aag17,  # 異動碼-3 說明
#                              aag18 LIKE aag_file.aag18,  # 異動碼-4 說明
#                              # FUN-5C0015 add (s)
#                              aag31 LIKE aag_file.aag31,  # 異動碼-5
#                              aag32 LIKE aag_file.aag32,  # 異動碼-6
#                              aag33 LIKE aag_file.aag33,  # 異動碼-7
#                              aag34 LIKE aag_file.aag34,  # 異動碼-8
#                              aag35 LIKE aag_file.aag35,  # 異動碼-9
#                              aag36 LIKE aag_file.aag36,  # 異動碼-10
#                              ahe02a LIKE ahe_file.ahe02,
#                              ahe02b LIKE ahe_file.ahe02,
#                              ahe02c LIKE ahe_file.ahe02,
#                              ahe02d LIKE ahe_file.ahe02,
#                              ahe02e LIKE ahe_file.ahe02,
#                              ahe02f LIKE ahe_file.ahe02,
#                              ahe02g LIKE ahe_file.ahe02,
#                              ahe02h LIKE ahe_file.ahe02,
#                              ahe02i LIKE ahe_file.ahe02,
#                              ahe02j LIKE ahe_file.ahe02,
#                              # FUN-5C0015 add (e)
#                              aed02 LIKE aed_file.aed02,  # 異動碼
#                              aee04 LIKE aee_file.aee04,  # 異動碼說明
#                            # aee06 LIKE aee_file.aee06,  # 日期
#                              d_c   LIKE aed_file.aed05   # 金額
#                       END RECORD,
#     l_sw         LIKE type_file.chr1,        #No.FUN-680098 VARCHAR(1)
#     l_amt        LIKE type_file.num20_6,     #No.FUN-680098 DEC(20,6)
#     l_amt2       LIKE type_file.num20_6,     #No.FUN-680098 DEC(20,6)
#     l_buff       LIKE type_file.chr1000      # FUN-5C0015  add   #No.FUN-680098 VARCHAR(60)
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.aed01
# FORMAT
#  PAGE HEADER
#No.FUN-580010 --start--
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#No.FUN-580010 --end--
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN 32,g_x[13] CLIPPED,tm.aed03 USING "####",
#          #COLUMN 43,g_x[14] CLIPPED,tm.aed04_b USING "##",'-',                                  #FUN-660060 remark
#           COLUMN ((g_len-FGL_WIDTH(g_x[14])-5)/2)+1,g_x[14] CLIPPED,tm.aed04_b USING "##",'-', #FUN-660060
#           tm.aed04_e USING "##",
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<','/pageno'    #No.TQC-6B0093
#     PRINT g_dash[1,g_len]
#No.FUN-580010 --start--
#     PRINT g_x[11],COLUMN 41,g_x[12]
#     PRINT ' ------------ --------------- ------------------------------ ',
#           '--------------------'
#     PRINT g_x[31],g_x[35],g_x[32],g_x[33],g_x[34]         #FUN-6C0012
#     PRINT g_x[31],g_x[35],g_x[36],g_x[32],g_x[33],g_x[34] #FUN-6C0012
#     PRINT g_dash1
#No.FUN-580010 --end--
#     LET l_last_sw = 'n'
#     LET l_sw = 'N'
 
#  BEFORE GROUP OF sr.aed01
#     IF tm.t = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#        THEN SKIP TO TOP OF PAGE
#     END IF
#     IF l_sw = 'Y' THEN
#        PRINT ' ------------ --------------- ------------------------------ ',
#              '--------------------'
#     PRINT g_dash1   #No.FUN-580010
#     ELSE
#        LET l_sw = 'Y'
#     END IF
#No.FUN-580010 --start--
#     PRINT ' ',sr.aed01 CLIPPED,
#           COLUMN 15,sr.aag02 CLIPPED,' ',sr.aag15 CLIPPED,' ',
#           sr.aag16 CLIPPED,' ',sr.aag17 CLIPPED,' ',sr.aag18 CLIPPED
#     # FUN-5C0015 (s)
#     LET l_buff = NULL
#     IF NOT cl_null(sr.ahe02a) THEN
#        LET l_buff = sr.ahe02a
#     END IF
#     IF NOT cl_null(sr.ahe02b) THEN
#        LET l_buff = l_buff CLIPPED,' ',sr.ahe02b
#     END IF
#     IF NOT cl_null(sr.ahe02c) THEN
#        LET l_buff = l_buff CLIPPED,' ',sr.ahe02c
#     END IF
#     IF NOT cl_null(sr.ahe02d) THEN
#        LET l_buff = l_buff CLIPPED,' ',sr.ahe02d
#     END IF
#     IF NOT cl_null(sr.ahe02e) THEN
#        LET l_buff = l_buff CLIPPED,' ',sr.ahe02e
#     END IF
#     IF NOT cl_null(sr.ahe02f) THEN
#        LET l_buff = l_buff CLIPPED,' ',sr.ahe02f
#     END IF
#     IF NOT cl_null(sr.ahe02g) THEN
#        LET l_buff = l_buff CLIPPED,' ',sr.ahe02g
#     END IF
#     IF NOT cl_null(sr.ahe02h) THEN
#        LET l_buff = l_buff CLIPPED,' ',sr.ahe02h
#     END IF
#     IF NOT cl_null(sr.ahe02i) THEN
#        LET l_buff = l_buff CLIPPED,' ',sr.ahe02i
#     END IF
#     IF NOT cl_null(sr.ahe02j) THEN
#        LET l_buff = l_buff CLIPPED,' ',sr.ahe02j
#     END IF
#     PRINT COLUMN g_c[31],sr.aed01 CLIPPED,
#           COLUMN g_c[35],sr.aag02 CLIPPED,
#           COLUMN g_c[36],sr.aag13 CLIPPED,   #FUN-6C0012
#           #COLUMN g_c[32],sr.aag15 CLIPPED,' ',sr.aag16 CLIPPED,' ',
#           #sr.aag17 CLIPPED,' ',sr.aag18 CLIPPED
#           COLUMN g_c[32],l_buff CLIPPED
#     # FUN-5C0015 (e)
#No.FUN-580010 --end--
 
#  ON EVERY ROW
#   # PRINT COLUMN 6,sr.aee06,COLUMN 15,sr.aed02,COLUMN 31,sr.aee04,
#No.FUN-580010 --start--
#     PRINT COLUMN 15,sr.aed02,COLUMN 31,sr.aee04,
#           COLUMN 61;
#     PRINT COLUMN g_c[32], sr.aed02,
#           COLUMN g_c[33], sr.aee04,
#           COLUMN g_c[34];
#No.FUN-580010 --end--
#           IF sr.d_c < 0 THEN
#               LET l_amt2 = sr.d_c * -1
#               PRINT cl_numfor(l_amt2,18,t_azi04) CLIPPED,' C'                #No.CHI-6A0004 g_azi-->t_azi
#           ELSE
#               PRINT cl_numfor(sr.d_c,18,t_azi04) CLIPPED,' D'                #No.CHI-6A0004 g_azi-->t_azi
#           END IF
 
#  AFTER GROUP OF sr.aed01
#     LET l_amt = GROUP SUM(sr.d_c)
#No.FUN-580010 --start--
#     PRINT COLUMN 54,g_x[15] CLIPPED,COLUMN 61;
#     PRINT COLUMN g_c[33],g_x[15] CLIPPED,
#           COLUMN g_c[34];
#No.FUN-580010 --end--
#     IF l_amt < 0 THEN
#         LET l_amt = l_amt * -1
#         PRINT cl_numfor(l_amt,18,t_azi05) CLIPPED,' C'                     #No.CHI-6A0004 g_azi-->t_azi
#     ELSE
#         PRINT cl_numfor(l_amt,18,t_azi05) CLIPPED,' D'                     #No.CHI-6A0004 g_azi-->t_azi
#     END IF
 
#  ON LAST ROW
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#     PRINT g_dash[1,g_len]
#     IF l_last_sw = 'n'
#        THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#     END IF
#END REPORT}
#--end-FUN-780059--mark--#
#Patch....NO.TQC-610035 <001> #

###GENGRE###START
FUNCTION aglg806_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg806")
        IF handler IS NOT NULL THEN
            START REPORT aglg806_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY aed01"      #FUN-B90028 
          
            DECLARE aglg806_datacur1 CURSOR FROM l_sql
            FOREACH aglg806_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg806_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg806_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg806_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
#FUN-B90028-------star------
    DEFINE l_tmaed04    STRING
    DEFINE l_qibie      STRING
    DEFINE l_g_c34      STRING
    DEFINE l_g_c34_1    STRING
    DEFINE l_amt        LIKE aed_file.aed05
    DEFINE l_amt2       LIKE aed_file.aed05
    DEFINE l_amt_tot    LIKE aed_file.aed05
    DEFINE sr1_o        sr1_t
    DEFINE l_display    LIKE type_file.chr1
#FUN-B90028------end--------
    
    ORDER EXTERNAL BY sr1.aed01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name    #FUN-B90028 add g_ptime,g_used_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.aed01

#FUN-B90028---------star------
            LET l_tmaed04 = tm.aed04_e
            LET l_tmaed04 = l_tmaed04.TrimLeft()
            LET l_qibie = tm.aed04_b,'-',l_tmaed04
            PRINTX l_qibie
#FUN-B90028------end--------
      
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

#FUN-B90028---------star------
            IF sr1.d_c < 0 THEN 
               LET l_amt2 = sr1.d_c * (-1)
            ELSE
               LET l_amt2 = sr1.d_c
            END IF 
 
            IF sr1.d_c < 0 THEN
                LET l_g_c34 = cl_numfor(l_amt2,18,t_azi04) CLIPPED,'C'          
                LET l_g_c34 = l_g_c34.trim()      #FUN-C20080  add
            ELSE
                LET l_g_c34 = cl_numfor(l_amt2,18,t_azi04) CLIPPED,'D'     
                LET l_g_c34 = l_g_c34.trim()      #FUN-C20080  add  
            END IF
            PRINTX l_g_c34

            IF NOT cl_null(sr1.aed01) THEN
               IF sr1_o.aed01 = sr1.aed01 THEN
                  LET l_display = 'N'
               ELSE
                  LET l_display = 'Y'
               END IF
            ELSE
               LET l_display = 'Y'
            END IF
            PRINTX l_display

            LET sr1_o.* = sr1.*
#FUN-B90028------end--------

            PRINTX sr1.*

        AFTER GROUP OF sr1.aed01
#FUN-B90028---------star------
            LET l_amt_tot =GROUP SUM(sr1.d_c)
            IF l_amt_tot < 0 THEN 
               LET l_amt = l_amt_tot * (-1)
            ELSE
              LET l_amt = l_amt_tot
            END IF 
            IF l_amt_tot < 0 THEN
               LET l_g_c34_1 = cl_numfor(l_amt,18,t_azi05) CLIPPED,'C'
               LET l_g_c34_1 = l_g_c34_1.trim()    #FUN-C20080  add
            ELSE
               LET l_g_c34_1 = cl_numfor(l_amt,18,t_azi05) CLIPPED,'D'
               LET l_g_c34_1 = l_g_c34_1.trim()    #FUN-C20080  add
            END IF
            PRINTX l_g_c34_1
#FUN-B90028------end--------        
        ON LAST ROW

END REPORT
###GENGRE###END
