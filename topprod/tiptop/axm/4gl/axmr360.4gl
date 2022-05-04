# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmr360.4gl
# Descriptions...: QUOTATION 列印
# Input parameter:
# Return code....:
# Date & Author..: 00/03/04 By Gina
# Modify.........: No.MOD-480369 03/08/23 Wiky 數量未對齊,za未有中文
# Modify.........: No.MOD-4A0079 04/10/07 By Mandy 列印要能印未確認的資料
# Modify.........: No.MOD-4A0256 04/10/20 By Mandy 單身沒資料,列印時會出現錯誤錯誤視窗,造成程式當掉
# Modify.........: No.FUN-4C0096 05/03/04 By Echo 調整單價、金額、匯率欄位大小
# Modify.........: No.MOD-530340 05/03/30 By Mandy 列印出來的表單內多列印了一行幣別及重量.
# Modify.........: No.MOD-530870 05/03/30 By Smapmin 將VARCHAR轉為CHAR
# Modify.........: No.FUN-550114 05/06/01 By echo 新增報表備註
# Modify.........: No.MOD-560215 05/07/19 By kim l_sql12 SQL語法,在IFX會有問題
# Modify.........: No.FUN-590110 05/10/08 By yoyo 報表修改，轉xml
# Modify.........: No.FUN-5A0031 05/10/18 By Sarah 將tm.a欄位放大到20碼(因為imc02從4->20碼)
# Modify.........: No.FUN-5A0143 05/10/21 By Rosayu 報表格式修改
# Modify.........: No.MOD-5C0062 05/12/12 By Nicola SQL條件修改
# Modify.........: No.MOD-610074 06/01/16 By Nicola 欄位名稱錯誤
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-5A0069 06/06/02 By kim 調整報表格式
# Modify.........: No.FUN-680137 06/09/05 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-690032 06/10/17 By rainy 勾選是否列印客戶料號
# Modify.........: No.FUN-6A0094 06/11/01 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.FUN-710090 07/02/01 By chenl 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.FUN-720024 07/05/14 By rainy 依客戶的慣用語言別列印
# Modify.........: No.TQC-750114 07/05/23 By rainy 列印條件語言別要和當頁的語言別相同
# Modify.........: No.MOD-750116 07/05/24 By claire occ_file 需OUTER因有可能不輸入客戶代碼
# Modify.........: No.MOD-790032 07/11/08 By claire 使用品名規格時,無法印出報表
# Modify.........: No.MOD-7B0056 07/11/08 By claire 使用分量計價無法印出報表
# Modify.........: No.MOD-7C0136 07/12/19 By claire l_table4應使用三個變數接收
# Modify.........: No.MOD-7C0137 07/12/19 By claire oqu06因有使用using故要以字元型態定義
# Modify.........: No.FUN-7C0073 07/12/25 By jamie 列印備註時有問題
# Modify.........: No.FUN-7C0036 08/01/14 By jamie 列印時，不參考慣用語言別的設定
# Modify.........: No.FUN-810029 08/02/22 By Sarah 對外的憑證，皆需在頁首公司名稱下，增加顯示"公司地址zo041、公司電話zo05、公司傳真zo09"
# Modify.........: No.MOD-820057 08/02/26 By claire(1)分量計價無法印出數量及金額
#                                                  (2)數量的小數位被截位
# Modify.........: No.MOD-970263 09/07/31 By Dido 費用資料幣別抓取調整
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定

# Modify.........: No:MOD-9C0367 10/02/03 By Smapmin oqu06的型態改為數字
# Modify.........: No:TQC-A50014 10/05/14 By Carrier 追单CHI-980054
# Modify.........: No.TQC-A50044 10/05/14 By Carrier MOD-A40044/FUN-9A0041追单
# Modify.........: No:FUN-A80056 10/08/14 By destiny 增加列印币别等资料   
# Modify.........: No:MOD-A90107 10/10/22 By Smapmin 客戶料號直接抓oqu04
# Modify.........: No:MOD-B70129 11/07/15 By JoHung 修正: p_zz未勾選列印選擇條件仍印出列印條件
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
# Modify.........: No:TQC-B90225 11/09/28 By destiny 组条件时没考虑产品编号
# Modify.........: No:FUN-940043 11/11/04 By minpp  CR报表列印TIPTOP与EASYFLOW签核图片
# Modify.........: No.TQC-C10039 12/01/17 By wangrr 整合單據列印EF簽核
# Modify.........: No:MOD-C20110 12/02/29 By jt_chen 1.還原TQC-B90225造成單身有兩筆時,重複印出的問題 2.修正axmr360,若勾選列印客戶料號 無資料顯示的問題 
# Modify.........: No:MOD-C50006 12/05/04 By Elise 還原MOD-C20110、TQC-B90225的調整
# Modify.........: No:TQC-C60054 12/06/05 By yangtt 修正axmr360,若勾選列印客戶料號 無資料顯示的問題 
# Modify.........: No:CHI-C30024 12/06/07 By bart 增加第五行地址欄位
# Modify.........: No:TQC-C80174 12/08/30 By dongsz 報價單號、客戶編號、產品編號、部門編號、業務員號欄位增加開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm        RECORD			               # Print condition RECORD
                    wc   LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(500)                   # Where Condition     
                    b    LIKE type_file.chr1,          # Prog. Version..: '5.30.06-13.03.12(01)                    # 報價方式:Y.數量報價 N.一般
                   # Prog. Version..: '5.30.06-13.03.12(04),                     # 品名規格額外說明類別   #FUN-5A0031 mark
                    a    LIKE type_file.chr20,         #No.FUN-680137 VARCHAR(20)                    # 品名規格額外說明類別   #FUN-5A0031
                    c    LIKE type_file.chr1,          # Prog. Version..: '5.30.06-13.03.12(01)                    # 資料狀態(1.確認 2.未確認 3.作廢 4.全部(不包含作廢)) #MOD-4A0079
                    d    LIKE type_file.chr1,          #No.FUN-690032 add 列印客戶料號
                    more LIKE type_file.chr1           # Prog. Version..: '5.30.06-13.03.12(01)                     # 特殊列印條件
                 END RECORD,
       l_n       LIKE type_file.num5,                  #No.FUN-680137 SMALLINT
       g_start   LIKE type_file.chr1,                  #No.FUN-680137  VARCHAR(01)
       l_oqt01_t LIKE oqt_file.oqt01
DEFINE g_cnt     LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE g_type    LIKE type_file.chr1          #No.FUN-680137  VARCHAR(1)     #No.FUN-590110
#DEFINE g_dash3  LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(400)   #Dash line #FUN-5A0069 mark
DEFINE g_i       LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE l_table   STRING   #FUN-7C0073 add
#No.FUN-710090--begin--
DEFINE l_table1  STRING
DEFINE l_table2  STRING
DEFINE l_table3  STRING
DEFINE l_table4  STRING
DEFINE l_table5  STRING   #MOD-790032 
DEFINE g_sql     STRING
DEFINE g_str     STRING
#No.FUN-710090--end--
DEFINE g_wc      STRING      #TQC-C60054 add
 
MAIN
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.b     = ARG_VAL(8)
   LET tm.a     = ARG_VAL(9)
   LET tm.c     = ARG_VAL(10) #MOD-4A0079
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
  #No.FUN-710090--begin-- 
   LET g_sql="oqt12.oqt_file.oqt12,  oqt01.oqt_file.oqt01,",
             "oqt03.oqt_file.oqt03,  oqt04.oqt_file.oqt04,",
             "oqt041.oqt_file.oqt041,oqt051.oqt_file.oqt051,",
             "oqt052.oqt_file.oqt052,oqt053.oqt_file.oqt053,",
             "oqt054.oqt_file.oqt054,oqt13.oqt_file.oqt13,",
             "oqt141.oqt_file.oqt141,oqt142.oqt_file.oqt142,",
             "oqt143.oqt_file.oqt143,oqt151.oqt_file.oqt151,",
             "oqt152.oqt_file.oqt152,oqt161.oqt_file.oqt161,",
             "oqt162.oqt_file.oqt162,oqt171.oqt_file.oqt171,",
             "oqt172.oqt_file.oqt172,oqt173.oqt_file.oqt173,",
             "oqt181.oqt_file.oqt181,oqt182.oqt_file.oqt182,",
             "oqt191.oqt_file.oqt191,oqt192.oqt_file.oqt192,",
             "oqt10.oqt_file.oqt10,  oqt08.oqt_file.oqt08,",
             "oqt11.oqt_file.oqt11,  oqt09.oqt_file.oqt09,",
             "oqt20.oqt_file.oqt20,  oqt02.oqt_file.oqt02,",
            #"azi04.azi_file.azi04,  occ55.occ_file.occ55 ,",  #FUN-7C0036 mark  
             "azi04.azi_file.azi04,  ",   #FUN-7C0036 mod  
             "oqu01.oqu_file.oqu01,  ",   #FUN-7C0073 add
             "oqu02.oqu_file.oqu02,  oqu03.oqu_file.oqu03,",
             "oqu031.oqu_file.oqu031,oqu032.oqu_file.oqu032,",
             "oqu06.oqu_file.oqu06,",   #MOD-7B0056 modify oqu06->oqu03  #MOD-7C0137 modify   #MOD-9C0367
             "oqu05.oqu_file.oqu05,  oqu07.oqu_file.oqu07,",
             "oqu09.oqu_file.oqu09,  oqu10.oqu_file.oqu10,",
             "oqu11.oqu_file.oqu11,  oqu13.oqu_file.oqu13,",
             "obk03.obk_file.obk03,  zo041.zo_file.zo041,",   #FUN-810029 add zo041
             "zo05.zo_file.zo05,     zo09.zo_file.zo09,",      #FUN-810029 add zo05,zo09
             "sign_type.type_file.chr1, sign_img.type_file.blob,",    #簽核方式, 簽核圖檔 #FUN-940043 ADD
             "sign_show.type_file.chr1,sign_str.type_file.chr1000,",  #是否顯示簽核資料(Y/N) #FUN-940043 #TQC-C10039 sign_str 
             "oah02.oah_file.oah02, ged02.ged_file.ged02,",     #TQC-A50044
             "oqt24.oqt_file.oqt24, gec04.gec_file.gec04,",    #NO.FUN-A80056
             "gec07.gec_file.gec07, oqt25.oqt_file.oqt25,",    #NO.FUN-A80056
             "oag02.oag_file.oag02, oqt26.oqt_file.oqt26,",    #NO.FUN-A80056
             "oac02.oac_file.oac02, oqt27.oqt_file.oqt27,",    #NO.FUN-A80056
             "oac02_1.oac_file.oac02,",                        #NO.FUN-A80056
             "oqt055.oqt_file.oqt055 "                         #CHI-C30024
   LET l_table = cl_prt_temptable('axmr360',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
  #l_table2   額外品名規格類別
   LET g_sql="imc01.imc_file.imc01,",
             "imc02.imc_file.imc02,",
             "imc03.imc_file.imc03,",
             "imc04.imc_file.imc04"
   LET l_table1 = cl_prt_temptable('axmr3601',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
  #l_table2  費用資料
   LET g_sql="oqx01.oqx_file.oqx01,",
             "oqx03.oqx_file.oqx03,",
             "oqx04.oqx_file.oqx04,",
             "oaj02.oaj_file.oaj02,",
             "oqx041.oqx_file.oqx041,",
             "oqx05.oqx_file.oqx05,",
             "oqx06.oqx_file.oqx06,",
             "azi04.azi_file.azi04"
   LET l_table2 = cl_prt_temptable('axmr3602',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
 
  #l_table3  備註
   LET g_sql="oao01.oao_file.oao01,",
             "oao03.oao_file.oao03,",
             "oao04.oao_file.oao04,",
             "oao05.oao_file.oao05,",
             "oao06.oao_file.oao06"
   LET l_table3 = cl_prt_temptable('axmr3603',g_sql) CLIPPED   # 產生Temp Table
   IF l_table3 = -1 THEN EXIT PROGRAM END IF                   # Temp Table產生
 
  #MOD-820057-begin-add
  #l_table4  分量計價
   LET g_sql="oqv01.oqv_file.oqv01,",
             "oqv02.oqv_file.oqv02,",
             "oqv03.oqv_file.oqv03,",
             "oqv04.oqv_file.oqv04,",
             "oqv05.oqv_file.oqv05,"
   LET l_table4 = cl_prt_temptable('axmr3604',g_sql) CLIPPED   # 產生Temp Table
   IF l_table4 = -1 THEN EXIT PROGRAM END IF                   # Temp Table產生
  #MOD-820057-end-add
 
   IF cl_null(g_rlang) THEN
      LET g_rlang=g_lang
   END IF
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r360_tm(0,0)                        # Input print condition
   ELSE
      CALL r360()                              # Read data and create out-file
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION r360_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01          #No.FUN-580031
DEFINE p_row,p_col       LIKE type_file.num5,         #No.FUN-680137 SMALLINT
       l_cmd             LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 17
 
   OPEN WINDOW r360_w AT p_row,p_col WITH FORM "axm/42f/axmr360"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.b      = 'N'
   LET tm.c      = '1' #MOD-4A0079
   LET tm.a      = ' '
   LET tm.d      = 'N' #FUN-690032
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME  tm.wc ON oqt01,oqt02,oqt04,oqu03,oqt06,oqt07
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
      #TQC-C80174 add ---start---  
         ON ACTION CONTROLP
            IF INFIELD(oqt01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oqt"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oqt01
               NEXT FIELD oqt01
            END IF
            IF INFIELD(oqt04) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oqt04"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oqt04
               NEXT FIELD oqt04
            END IF
            IF INFIELD(oqu03) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oqu03"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oqu03
               NEXT FIELD oqu03
            END IF
            IF INFIELD(oqt06) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oqt06"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oqt06
               NEXT FIELD oqt06
            END IF
            IF INFIELD(oqt07) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oqt07"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oqt07
               NEXT FIELD oqt07
            END IF
         #TQC-C80174 add ---end---
         ON ACTION locale
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
         CLOSE WINDOW r360_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
 
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
 
      DISPLAY BY NAME tm.b,tm.a,tm.more,tm.d  #FUN-690032 add tm.d
 
      INPUT BY NAME tm.b,tm.a,tm.c,tm.d,tm.more WITHOUT DEFAULTS  #MOD-4A0079   #FUN-690032 add tm.d
 
         AFTER FIELD b
            IF cl_null(tm.b) THEN
               NEXT FIELD b
            END IF
            IF tm.b NOT MATCHES '[YN]' THEN
               NEXT FIELD b
            END IF
 
         AFTER FIELD a
            IF NOT cl_null(tm.a)THEN
               SELECT COUNT(*) INTO l_n FROM imc_file
                WHERE imc02 = tm.a
               IF l_n < 1 THEN
                  CALL cl_err('','axm-141',0)
                  NEXT FIELD a
               END IF
            END IF
 
       #FUN-690032 add--begin
        AFTER FIELD d
            IF tm.d NOT MATCHES'[YN]' THEN
               NEXT FIELD d
            END IF
       #FUN-690032 add--end
 
         AFTER FIELD more
            IF tm.more NOT MATCHES'[YN]' THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
     
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
         CLOSE WINDOW r360_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='axmr360'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axmr360','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'" ,
                      #-----------No.TQC-610089 add
                        " '",tm.b CLIPPED,"'" ,
                        " '",tm.a CLIPPED,"'" ,
                        " '",tm.c CLIPPED,"'" ,
                        " '",tm.d CLIPPED,"'" ,     #FUN-690032
                      #-----------No.TQC-610089 end
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('axmr360',g_time,l_cmd)	# Execute cmd at later time
         END IF
 
         CLOSE WINDOW r360_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL r360()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r360_w
 
END FUNCTION
 
#FUN-7C0073---mod---str---
FUNCTION r360()
   DEFINE l_name     LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#         l_time     LIKE type_file.chr8,  		# Used time for running the job   #No.FUN-680137 VARCHAR(8)  #NO.FUN-6A0094
          l_n        LIKE type_file.num5,               # No.FUN-710090
          l_i        LIKE type_file.num5,  		#        #No.FUN-680137 SMALLINT
          l_sql1     LIKE type_file.chr1000,		#        #No.FUN-680137 VARCHAR(1000)
          l_sql2     LIKE type_file.chr1000,		#        #No.FUN-680137 VARCHAR(1000)
          l_sql3     LIKE type_file.chr1000,		#        #No.FUN-680137 VARCHAR(1000)
          l_sql4     LIKE type_file.chr1000,		#        #No.FUN-680137 VARCHAR(1000)
          l_sql5     LIKE type_file.chr1000,		#        #No.FUN-680137 VARCHAR(1000)
          l_sql6     LIKE type_file.chr1000,		#        #No.FUN-680137 VARCHAR(1000)
          l_sql7     LIKE type_file.chr1000,		#        #No.FUN-680137 VARCHAR(1000)
          l_za05     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_oqt12    LIKE oqt_file.oqt12,
          l_zo041    LIKE zo_file.zo041,           #FUN-810029 add
          l_zo05     LIKE zo_file.zo05,            #FUN-810029 add
          l_zo09     LIKE zo_file.zo09,            #FUN-810029 add
          sr1        RECORD
                        oqt12     LIKE    oqt_file.oqt12,  #
                        oqt01     LIKE    oqt_file.oqt01,   #Quote.No
                        oqt03     LIKE    oqt_file.oqt03,   #Your Ref
                        oqt04     LIKE    oqt_file.oqt04,   #FUN-690032 add
                        oqt041    LIKE    oqt_file.oqt041,  #
                        oqt051    LIKE    oqt_file.oqt051,  #
                        oqt052    LIKE    oqt_file.oqt052,  #
                        oqt053    LIKE    oqt_file.oqt053,  #
                        oqt054    LIKE    oqt_file.oqt054,  #
                        oqt055    LIKE    oqt_file.oqt055,  #CHI-C30024
                        oqt13     LIKE    oqt_file.oqt13,   #
                        oqt141    LIKE    oqt_file.oqt141,  #
                        oqt142    LIKE    oqt_file.oqt142,  #
                        oqt143    LIKE    oqt_file.oqt143,  #
                        oqt151    LIKE    oqt_file.oqt151,  #PAYMENT
                        oqt152    LIKE    oqt_file.oqt152,  #
                        oqt161    LIKE    oqt_file.oqt161,  #SHIPMENT
                        oqt162    LIKE    oqt_file.oqt162,  #
                        oqt171    LIKE    oqt_file.oqt171,  #PACKING
                        oqt172    LIKE    oqt_file.oqt172,  #
                        oqt173    LIKE    oqt_file.oqt173,  #
                        oqt181    LIKE    oqt_file.oqt181,  #INSURANCE
                        oqt182    LIKE    oqt_file.oqt182,  #
                        oqt191    LIKE    oqt_file.oqt191,  #VALIDITY
                        oqt192    LIKE    oqt_file.oqt192,  #
                        oqt10     LIKE    oqt_file.oqt10,   #
                        oqt08     LIKE    oqt_file.oqt08,   #
                        oqt11     LIKE    oqt_file.oqt11,   #
                        oqt09     LIKE    oqt_file.oqt09,   #
                        oqt20     LIKE    oqt_file.oqt20,   #
                        oqt02     LIKE    oqt_file.oqt02,   #
                        oqt24     LIKE    oqt_file.oqt24,   #NO.FUN-A80056
                        oqt25     LIKE    oqt_file.oqt25,   #NO.FUN-A80056
                        oqt26     LIKE    oqt_file.oqt26,   #NO.FUN-A80056
                        oqt27     LIKE    oqt_file.oqt27    #NO.FUN-A80056
                     END RECORD,
          sr2        RECORD
                        oqu01     LIKE    oqu_file.oqu01,   #No.FUN-710090
                        oqu02     LIKE    oqu_file.oqu02,   #
                        oqu03     LIKE    oqu_file.oqu03,   #
                        oqu04     LIKE    oqu_file.oqu04,   #MOD-A90107
                        oqu031    LIKE    oqu_file.oqu031,  #
                        oqu032    LIKE    oqu_file.oqu032,  #
                        oqu06     LIKE    oqu_file.oqu06,   #
                        oqu05     LIKE    oqu_file.oqu05,   #
                        oqu07     LIKE    oqu_file.oqu07,   #
                        oqu09     LIKE    oqu_file.oqu09,   #
                        oqu10     LIKE    oqu_file.oqu10,   #
                        oqu11     LIKE    oqu_file.oqu11,   #
                        oqu13     LIKE    oqu_file.oqu13    #
                     END RECORD
 
  DEFINE  sr3        RECORD
                        oqx01     LIKE    oqx_file.oqx01,   #No.FUN-710090
                        oqx03     LIKE    oqx_file.oqx03,   
                        oqx04     LIKE    oqx_file.oqx04,   
                        oaj02     LIKE    oaj_file.oaj02,
                        oqx041    LIKE    oqx_file.oqx041,  
                        oqx05     LIKE    oqx_file.oqx05,   
                        oqx06     LIKE    oqx_file.oqx06    
                     END RECORD
   DEFINE oao        RECORD LIKE oao_file.*     #FUN-7C0073 add
 
#FUN-7C0073---mark---str---
  DEFINE  l_oqv      DYNAMIC ARRAY OF RECORD
                        oqv01     LIKE    oqv_file.oqv01, #MOD-820057 
                        oqv02     LIKE    oqv_file.oqv02, #MOD-820057  
                        oqv03     LIKE    oqv_file.oqv03,  
                        oqv04     LIKE    oqv_file.oqv04,  
                        oqv05     LIKE    oqv_file.oqv05   
                     END RECORD
DEFINE    l_oao03    LIKE    oao_file.oao03,             #
          l_oao05    LIKE    oao_file.oao05,             #
          l_oao04    LIKE    oao_file.oao04,             #
          l_oao06    LIKE    oao_file.oao06,
          l_oao06_1  LIKE    oao_file.oao06,
          l_oao06_2  LIKE    oao_file.oao06,
          l_oao06_3  LIKE    oao_file.oao06,
          l_obk03    LIKE    obk_file.obk03,
          l_oqx03_1  LIKE    oqx_file.oqx03,             #
          l_oqx03_2  LIKE    oqx_file.oqx03,             #
          l_oqt01_t  LIKE    oqt_file.oqt01
DEFINE    i          LIKE    type_file.num5,
          l_oqu06    LIKE    type_file.chr1000,
          l_imc03    LIKE    imc_file.imc03,           #MOD-790032 add
          l_imc04    ARRAY[30] OF LIKE cob_file.cob08
DEFINE    l_azi04    LIKE    azi_file.azi04
#DEFINE   l_occ55    LIKE    occ_file.occ55            #FUN-7C0036 mark #FUN-720024 add
DEFINE    l_zo02     LIKE    zo_file.zo02              #FUN-720024 add
 #No.FUN-710090--end--
DEFINE    l_lang_t   LIKE type_file.chr1               #TQC-750114
DEFINE    l_oah02    LIKE    oah_file.oah02            #TQC-A50044              
DEFINE    l_ged02    LIKE    ged_file.ged02            #TQC-A50044
DEFINE    l_gec04    LIKE    gec_file.gec04            #NO.FUN-A80056  
DEFINE    l_gec07    LIKE    gec_file.gec07            #NO.FUN-A80056  
DEFINE    l_oac02    LIKE    oac_file.oac02            #NO.FUN-A80056  
DEFINE    l_oac02_1  LIKE    oac_file.oac02            #NO.FUN-A80056
DEFINE    l_oag02    LIKE    oag_file.oag02            #TQC-A50044  
DEFINE    l_oqu03    LIKE    oqu_file.oqu03            #MOD-C20110 add  #MOD-C50006 mark   #TQC-C60054 remark

#FUN-940043--START ###
   DEFINE l_img_blob     LIKE type_file.blob
#TQC-C10039--start--mark---
   #DEFINE l_ii           INTEGER
   #DEFINE l_sql_1       LIKE type_file.chr1000
   #DEFINE l_key          RECORD                  #主鍵
   #          v1          LIKE oqt_file.oqt01
   #                      END RECORD
#TQC-C10039--end--mark---
#FUN-940043--END ###

 #No.FUN-710090--begin--
  LOCATE l_img_blob IN MEMORY #blob初始化 #FUN-940043
  #FUN-7C0073---mod---str---
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?)"  #FUN-7C0036 mark 1個? #FUN-7C0073 35->45個  #FUN-810029 44?->47?  #No.TQC-A50044 #NO.FUN-A80056 #FUN-940043 ADD 3 ? #TQC-C10039 add 1? #CHI-C30024
   PREPARE insert1 FROM g_sql  
   IF STATUS THEN   
      CALL cl_err("insert1:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM 
   END IF
 
  #品名規格額外說明類別
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?)"
   PREPARE insert2 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert2:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
  
  #費用資料
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?)"
   PREPARE insert3 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert3:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
 
  #備註
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,             
               " VALUES(?,?,?,?,?)"
   PREPARE insert4 FROM g_sql                                              
   IF STATUS THEN                                                               
      CALL cl_err("insert4:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM                        
   END IF
  #FUN-7C0073---mod---end---
 
  #MOD-820057-begin-add
  #分量計價
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,             
               " VALUES(?,?,?,?,?)"
   PREPARE insert5 FROM g_sql                                              
   IF STATUS THEN                                                               
      CALL cl_err("insert5:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM                        
   END IF
  #MOD-820057-end-add
 
  #str FUN-810029 add
  #公司地址zo041、公司電話zo05、公司傳真zo09
   LET l_zo041 = NULL  LET l_zo05 = NULL  LET l_zo09 = NULL
   SELECT zo041,zo05,zo09 INTO l_zo041,l_zo05,l_zo09
     FROM zo_file WHERE zo01=g_lang
  #end FUN-810029 add
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='axmr360'
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang   #FUN-7C0073 add
 
 #No.FUN-710090--end--
  #FOR  l_i = 1 TO g_len LET g_dash3[l_i,l_i] = '-' END FOR               #No.FUN-590110 #FUN-5A0069 mark
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                   #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND oqtuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                   #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND oqtgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND oqtgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oqtuser', 'oqtgrup')
   #End:FUN-980030
   
   CALL cl_del_data(l_table)  #FUN-7C0073   add
   CALL cl_del_data(l_table1) #No.FUN-710090
   CALL cl_del_data(l_table2) #No.FUN-710090
   CALL cl_del_data(l_table3) #No.FUN-710090
   CALL cl_del_data(l_table4) #No.MOD-820057 add
  #FUN-7C0073 mark
  #CALL cl_del_data(l_table4) #No.FUN-710090
  #CALL cl_del_data(l_table5) #No.MOD-790032
  #FUN-7C0073 mark

#TQC-C60054------add-----str----
   LET g_wc = tm.wc
   IF g_wc.getIndexOf("oqu03",1) THEN
      LET l_sql1 = " SELECT oqt12,",
                   " oqt01 ,oqt03 ,oqt04,oqt041,oqt051,oqt052,oqt053,oqt054,oqt055,oqt13,",   #CHI-C30024 add oqt055
                   " oqt141,oqt142,oqt143,oqt151,oqt152,oqt161,oqt162,oqt171,",
                   " oqt172,oqt173,oqt181,oqt182,oqt191,oqt192,oqt10,oqt08,",
                   " oqt11,oqt09,oqt20,oqt02,",
                   " oqt24,oqt25,oqt26,oqt27,oqu03 ", 
                   " FROM oqt_file,oqu_file ", 
                   " WHERE oqt01 = oqu01 AND oqt12 = ? ",
                   "   AND ",tm.wc CLIPPED     

     LET l_sql2  = " SELECT oqu01,oqu02,oqu03,oqu04,oqu031,oqu032,oqu06,oqu05,",
                   "        oqu07,oqu09 ,oqu10 ,oqu11,oqu13 ",
                   " FROM  oqt_file LEFT OUTER JOIN oqu_file ON oqt01 = oqu01",
                   " WHERE oqt_file.oqt01 = ? ",     
                   "   AND oqu_file.oqu03 = ? ",             
                   " ORDER BY oqu02"
   ELSE
      LET l_sql1 = " SELECT oqt12,",
                   " oqt01 ,oqt03 ,oqt04,oqt041,oqt051,oqt052,oqt053,oqt054,oqt055,oqt13,",   #CHI-C30024 add oqt055
                   " oqt141,oqt142,oqt143,oqt151,oqt152,oqt161,oqt162,oqt171,",
                   " oqt172,oqt173,oqt181,oqt182,oqt191,oqt192,oqt10,oqt08,",
                   " oqt11,oqt09,oqt20,oqt02,",
                   " oqt24,oqt25,oqt26,oqt27 ",   
                   " FROM oqt_file ",       
                   " WHERE oqt12 = ? ",
                   "   AND ",tm.wc CLIPPED   

     LET l_sql2  = " SELECT oqu01,oqu02,oqu03,oqu04,oqu031,oqu032,oqu06,oqu05,",
                   "        oqu07,oqu09 ,oqu10 ,oqu11,oqu13 ",
                   " FROM  oqt_file LEFT OUTER JOIN oqu_file ON oqt01 = oqu01", 
                   " WHERE oqt_file.oqt01 = ? ",    
                   " ORDER BY oqu02"
   END IF
   CASE tm.c
       WHEN '1'     #1.確認
           LET l_sql1 = l_sql1 CLIPPED," AND oqtconf = 'Y' "
       WHEN '2'     #2.未確認
           LET l_sql1 = l_sql1 CLIPPED," AND oqtconf = 'N' "
       WHEN '3'     #3.作廢
           LET l_sql1 = l_sql1 CLIPPED," AND oqtconf = 'X' "
       WHEN '4'     #4.全部
           LET l_sql1 = l_sql1 CLIPPED," AND oqtconf <> 'X' "
   END CASE

   LET l_sql1 = l_sql1 CLIPPED ," ORDER BY oqt01 "
#TQC-C60054------add-----end----

#TQC-C60054------mark----str---- 
#
# #FUN-7C0073--mod---str---
#  LET l_sql1 = " SELECT oqt12,",
#               " oqt01 ,oqt03 ,oqt04,oqt041,oqt051,oqt052,oqt053,oqt054,oqt13,",  #FUN-690032 add oqt04
#               " oqt141,oqt142,oqt143,oqt151,oqt152,oqt161,oqt162,oqt171,",
#               " oqt172,oqt173,oqt181,oqt182,oqt191,oqt192,oqt10,oqt08,",
#               " oqt11,oqt09,oqt20,oqt02,",
#              #" oqt24,oqt25,oqt26,oqt27,oqu03 ", #NO.FUN-A80056   #MOD-C20110 add oqu03  #MOD-C50006 mark
#               " oqt24,oqt25,oqt26,oqt27 ",       #MOD-C50006
#               " FROM oqt_file ",                 #MOD-C50006 remark 
#              #" FROM oqt_file LEFT OUTER JOIN oqu_file ON oqt01=oqu01 ", #TQC-B90225  #MOD-C50006 mark
#               " WHERE oqt12 = ? ",
#               "   AND ",tm.wc CLIPPED       #MOD-4A0079
#  CASE tm.c
#      WHEN '1'     #1.確認
#          LET l_sql1 = l_sql1 CLIPPED," AND oqtconf = 'Y' "
#      WHEN '2'     #2.未確認
#          LET l_sql1 = l_sql1 CLIPPED," AND oqtconf = 'N' "
#      WHEN '3'     #3.作廢
#          LET l_sql1 = l_sql1 CLIPPED," AND oqtconf = 'X' "
#      WHEN '4'     #4.全部
#          LET l_sql1 = l_sql1 CLIPPED," AND oqtconf <> 'X' "
#  END CASE
#
#  LET l_sql1 = l_sql1 CLIPPED ," ORDER BY oqt01 "
#  #MOD-4A0079(end)
#
#  LET l_sql2  = " SELECT oqu01,oqu02,oqu03,oqu04,oqu031,oqu032,oqu06,oqu05,",   #MOD-A90107 add oqu04
#                "        oqu07,oqu09 ,oqu10 ,oqu11,oqu13 ",
#                " FROM  oqt_file,OUTER oqu_file",   #MOD-4A0256
#                " WHERE oqt_file.oqt01 = ? ",       #MOD-560215
#                "   AND oqt_file.oqt01 = oqu_file.oqu01 ",   #MOD-4A0256
#               #"   AND oqu_file.oqu03 = ? ",                #MOD-C20110 add  #MOD-C50006 mark
#                " ORDER BY oqu02"
#TQC-C60054------mark----end---- 

   PREPARE r360_p1 FROM l_sql1
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   DECLARE r360_c1 CURSOR FOR r360_p1
 
   PREPARE r360_p2 FROM l_sql2
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare2:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   DECLARE r360_c2 CURSOR FOR r360_p2
 
  #品名規格額外說明類別
   LET l_sql3  = " SELECT imc03,imc04 FROM imc_file",  #MOD-790032 modify
                 " WHERE imc01 = ? AND imc02 = ?",
                 " ORDER BY imc03"                     #MOD-790032 modify
 
   PREPARE r360_p3 FROM l_sql3
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare3:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   DECLARE r360_c3 CURSOR FOR r360_p3

  #TQC-C60054-----add-----str--
   LET l_sql5  = " SELECT oqv01,oqv02,oqv03,oqv04,oqv05 FROM oqv_file",
                 " WHERE oqv01 = ? AND oqv02= ? ",
                 " ORDER BY 1"
   PREPARE r360_p7 FROM l_sql5
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   DECLARE r360_c7 CURSOR FOR r360_p7

   #抓取單身費用資料 --> oqx_file
   DECLARE r360_c4 CURSOR FOR
      SELECT oqx01,oqx03,oqx04,oaj02,oqx041,oqx05,oqx06
        FROM oqx_file LEFT OUTER JOIN oaj_file ON oqx04 = oaj01
       WHERE oqx01 = ? 
         AND oqx03 <> '0'
       ORDER BY 1

   #列印單身備註
    DECLARE oao_c1 CURSOR FOR
       SELECT * FROM oao_file
        WHERE oao01=?
          AND oao03=?
          AND (oao05='1' OR oao05='2')
         ORDER BY oao04
  #TQC-C60054-----add-----end--

 
  ## Modify Bug No.:7252
  #CALL cl_outnam('axmr360') RETURNING l_name  #No.FUN-710090 mark
 
   OPEN r360_c1 USING tm.b
  #FOREACH r360_c1 USING tm.b INTO sr1.*,l_oqu03    #MOD-C20110 add l_oqu03  #MOD-C50006 mark
  #FOREACH r360_c1 USING tm.b INTO sr1.*            #MOD-C50006  
   IF g_wc.getIndexOf("oqu03",1) THEN                    #TQC-C60054 add
      FOREACH r360_c1 USING tm.b INTO sr1.*,l_oqu03
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
    
        #FUN-7C0036---mark---str---
        ## Modify for Bug No.:7252
        #IF tm.more = "N" AND cl_null(ARG_VAL(3)) THEN
        #   #SELECT occ55 INTO g_rlang   #No.MOD-610074     #FUN-720024
        #   SELECT occ55 INTO l_occ55                       #FUN-720024
        #     FROM oqt_file,OUTER occ_file  #MOD-750116 add OUTER
        #    WHERE oqt01 = sr1.oqt01
        #     AND occ_file.occ01 = oqt04 
        #END IF
        ##FUN-720024 begin
        # IF cl_null(l_occ55) THEN
        #   LET l_occ55 = g_rlang
        # END IF
        ##FUN-720024 end 
        #FUN-7C0036---mark---end---"
        #NO.FUN-A80056--begin
        SELECT gec04,gec07 INTO l_gec04,l_gec07 FROM gec_file WHERE gec01=sr1.oqt24
        SELECT oag02 INTO l_oag02 FROM oag_file WHERE oag01=sr1.oqt25
        SELECT oac02 INTO l_oac02 FROM oac_file WHERE oac01=sr1.oqt26
        SELECT oac02 INTO l_oac02_1 FROM oac_file WHERE oac01=sr1.oqt27
        #NO.FUN-A80056--end
         SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang 
        #SELECT zo02 INTO l_zo02 FROM zo_file WHERE zo01 = l_occ55   #FUN_7C0036 mark #FUN-720024
         SELECT zo02 INTO l_zo02 FROM zo_file WHERE zo01 = g_rlang   #FUN-7C0036 mod  #FUN-720024
         ##
   
        #-TQC-A50044-add-                                                          
         SELECT oah02 INTO l_oah02 FROM oah_file                                   
          WHERE oah01 = sr1.oqt10                                                  
                                                                                   
         SELECT ged02 INTO l_ged02 FROM ged_file                                   
          WHERE ged01 = sr1.oqt11                                                  
        #-TQC-A50044-add-
    
        #TQC-C60054-----mark----str---
        ##抓取單身費用資料 --> oqx_file
        #DECLARE r360_c4 CURSOR FOR
        #   SELECT oqx01,oqx03,oqx04,oaj02,oqx041,oqx05,oqx06 
        #     FROM oqx_file,OUTER oaj_file
        #    WHERE oqx01 = sr1.oqt01
        #      AND oqx03 <> '0' 
        #      AND oqx_file.oqx04=oaj_file.oaj01 
        #    ORDER BY 1
        #TQC-C60054-----mark----end---
         
         #-MOD-970263-add- 
         #SELECT azi04 INTO t_azi04
         #  FROM azi_file
         # WHERE azi01 = sr1.oqt09   
         #-MOD-970263-add- 
    
         FOREACH r360_c4 USING sr1.oqt01 INTO sr3.*    #TQC-C60054 add USING sr1.oqt01        
           IF SQLCA.sqlcode THEN
              EXIT FOREACH
           END IF
          #-MOD-970263-add- 
           SELECT azi04 INTO t_azi04
             FROM azi_file
            WHERE azi01 = sr3.oqx041   
          #-MOD-970263-add- 
           EXECUTE insert3 USING sr3.*,t_azi04  
         END FOREACH
    
        #抓單頭與單身資料
        #FOREACH r360_c2 USING sr1.oqt01,l_oqu03 INTO sr2.*   #MOD-C20110 add l_oqu03  #MOD-C50006 mark
        #FOREACH r360_c2 USING sr1.oqt01 INTO sr2.*           #MOD-C50006 #TQC-C60054 mark 
         FOREACH r360_c2 USING sr1.oqt01,l_oqu03 INTO sr2.* #TQC-C60054 add
            IF SQLCA.sqlcode THEN
               INITIALIZE sr2.* TO NULL
               EXIT FOREACH
            END IF
           #MOD-7B0056-begin
            IF cl_null(sr2.oqu07) THEN LET sr2.oqu07=0 END IF
            IF cl_null(sr2.oqu09) THEN LET sr2.oqu09=0 END IF
            IF cl_null(sr2.oqu11) THEN LET sr2.oqu11=0 END IF
            IF cl_null(sr2.oqu13) THEN LET sr2.oqu13=0 END IF
           #MOD-7B0056-end
 
           #額外品名規格 
            FOR i = 1 TO 30 INITIALIZE l_imc04[i] TO NULL END FOR  #
   
            IF NOT cl_null(tm.a) AND sr2.oqu03[1,4] !='MISC'  THEN  #讀取額外品名規格
               LET i=1
            
               FOREACH r360_c3 USING sr2.oqu03,tm.a INTO l_imc03,l_imc04[i]   #MOD-790032 modify
                 IF SQLCA.sqlcode THEN EXIT FOREACH END IF
                 EXECUTE insert2 USING  sr2.oqu03,tm.a,l_imc03,l_imc04[i]     #MOD-790032
                 LET i = i +1
               END FOREACH
            END IF
 
          #TQC-C60054----mark----str---
          ##列印單身備註
          # DECLARE oao_c1 CURSOR FOR                                                 
          #  SELECT * FROM oao_file                                               
          #   WHERE oao01=sr1.oqt01 
          #     AND oao03=sr2.oqu02 
          #     AND (oao05='1' OR oao05='2')
          #   ORDER BY oao04                                                          
          #TQC-C60054----mark----end---
            FOREACH oao_c1 USING sr1.oqt01,sr2.oqu02 INTO oao.*     #TQC-C60054 add USING sr1.oqt01,sr2.oqu02                                          
               IF NOT cl_null(oao.oao06) THEN
                  EXECUTE insert4 USING 
                     sr1.oqt01,sr2.oqu02,oao.oao04,oao.oao05,oao.oao06                
               END IF                                                                 
            END FOREACH                                                               
 
            IF sr1.oqt12 = 'N' AND tm.b ='N' THEN    #N：一般
               #-----MOD-A90107---------
               LET l_obk03 = sr2.oqu04
               #LET l_obk03 = ''
               #SELECT obk03 INTO l_obk03 FROM obk_file
               # WHERE obk01 = sr2.oqu03
               #   AND obk02 = sr1.oqt04
               #   AND obk05 = sr1.oqt09  #MOD-7B0056 add
               #IF SQLCA.sqlcode THEN
               #  LET l_obk03 = ''
               #END IF 
               #-----END MOD-A90107-----
               #LET l_oqu06 = sr2.oqu06 USING '##########',''  #MOD-7B0056   #MOD-820057 mark
               SELECT azi04 INTO l_azi04 FROM azi_file
                WHERE azi01=sr1.oqt09
        
               EXECUTE insert1 USING sr1.oqt12 ,sr1.oqt01 ,sr1.oqt03 ,sr1.oqt04 ,sr1.oqt041,sr1.oqt051,
                                     sr1.oqt052,sr1.oqt053,sr1.oqt054,sr1.oqt13 ,sr1.oqt141,
                                     sr1.oqt142,sr1.oqt143,sr1.oqt151,sr1.oqt152,sr1.oqt161,
                                     sr1.oqt162,sr1.oqt171,sr1.oqt172,sr1.oqt173,sr1.oqt181,
                                     sr1.oqt182,sr1.oqt191,sr1.oqt192,sr1.oqt10 ,sr1.oqt08 ,sr1.oqt11,
                                     sr1.oqt09 ,sr1.oqt20 ,sr1.oqt02 ,l_azi04   ,                       #FUN-7C0036 將l_occ55,拿掉  #FUN-720024 add occ55/zo02
                                     sr2.oqu01 ,sr2.oqu02 ,sr2.oqu03 ,sr2.oqu031,sr2.oqu032,
                                     sr2.oqu06 ,sr2.oqu05 ,sr2.oqu07 ,sr2.oqu09 ,sr2.oqu10 ,         #MOD-7B0056 modify sr2.oqu06, #MOD-820057 modify l_oqu06->sr.oqu06
                                     sr2.oqu11 ,sr2.oqu13 ,l_obk03   ,l_zo041   ,l_zo05    ,l_zo09,  #FUN-810029 add l_zo041,l_zo05,l_zo09
                                     "",l_img_blob,"N","",             #FUN-B940043 add "",l_img_blob,"N" #TQC-C10039 add ""
                                     l_oah02   ,l_ged02,                                              #No.TQC-A50044
                                     sr1.oqt24,l_gec04,l_gec07,sr1.oqt25,l_oag02,sr1.oqt26,l_oac02,  #NO.FUN-A80056
                                     sr1.oqt27,l_oac02_1,                                             #NO.FUN-A80056
                                     sr1.oqt055  #CHI-C30024
            END IF
 
            IF sr1.oqt12 = 'Y' AND tm.b ='Y' THEN    #Y:分量計價
               #-----MOD-A90107---------
               LET l_obk03 = sr2.oqu04
               #LET l_obk03 = ''
               #SELECT obk03 INTO l_obk03 FROM obk_file
               # WHERE obk01 = sr2.oqu03
               #   AND obk02 = sr1.oqt04
               #   AND obk05 = sr1.oqt09  #MOD-7B0056 add
               #IF SQLCA.sqlcode THEN
               #  LET l_obk03 = ''
               #END IF
               #-----END MOD-A90107-----
               SELECT azi04 INTO l_azi04 FROM azi_file
                WHERE azi01=sr1.oqt09
              #MOD-820057-begin-modify
               #LET l_oqu06=l_oqv[i].oqv03 USING '#####','-',
               #            l_oqv[i].oqv04 USING '#####'  CLIPPED
               #LET sr2.oqu07=l_oqv[i].oqv05
               #IF cl_null(sr2.oqu07) THEN LET sr2.oqu07=0 END IF  #MOD-7B0056 add
              #TQC-C60054-----mark----str--
              #LET l_sql5  = " SELECT oqv01,oqv02,oqv03,oqv04,oqv05 FROM oqv_file",
              #              " WHERE oqv01 = ? AND oqv02= ? ",
              #              " ORDER BY 1"
              #PREPARE r360_p7 FROM l_sql5
              #IF SQLCA.sqlcode THEN
              #   CALL cl_err('prepare:',SQLCA.sqlcode,1)
              #   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
              #EXIT PROGRAM
              #END IF
              #DECLARE r360_c7 CURSOR FOR r360_p7
              #TQC-C60054-----mark----end--
               LET i = 1
               FOREACH r360_c7 USING sr1.oqt01,sr2.oqu02 INTO l_oqv[i].*
                  EXECUTE insert5 USING 
                     l_oqv[i].oqv01,l_oqv[i].oqv02,l_oqv[i].oqv03,l_oqv[i].oqv04,l_oqv[i].oqv05                
                   LET i= i + 1
               END FOREACH
              #MOD-820057-end-modify
          
               EXECUTE insert1 USING sr1.oqt12,sr1.oqt01,sr1.oqt03,sr1.oqt04,sr1.oqt041,sr1.oqt051,
                                     sr1.oqt052,sr1.oqt053,sr1.oqt054,sr1.oqt13,sr1.oqt141,
                                     sr1.oqt142,sr1.oqt143,sr1.oqt151,sr1.oqt152,sr1.oqt161,
                                     sr1.oqt162,sr1.oqt171,sr1.oqt172,sr1.oqt173,sr1.oqt181,
                                     sr1.oqt182,sr1.oqt191,sr1.oqt192,sr1.oqt10,sr1.oqt08,sr1.oqt11,
                                     sr1.oqt09,sr1.oqt20,sr1.oqt02,l_azi04,                 #FUN-7C0036 將l_occ55,拿掉  #FUN-720024 add occ55/zo02
                                     sr2.oqu01,sr2.oqu02,sr2.oqu03,sr2.oqu031,sr2.oqu032,
                                     sr2.oqu06,sr2.oqu05,sr2.oqu07,sr2.oqu09, sr2.oqu10, #MOD-820056 modify l_oqu06->sr2.oqu06
                                     sr2.oqu11,sr2.oqu13,l_obk03,l_zo041,l_zo05,l_zo09,  #FUN-810029 add l_zo041,l_zo05,l_zo09 
                                     "",l_img_blob,"N","",             #FUN-B940043 add "",l_img_blob,"N" #TQC-C10039 add ""
                                     l_oah02   ,l_ged02,                                              #No.TQC-A50044
                                     sr1.oqt24,l_gec04,l_gec07,sr1.oqt25,l_oag02,sr1.oqt26,l_oac02,  #NO.FUN-A80056
                                     sr1.oqt27,l_oac02_1,                                             #NO.FUN-A80056  
                                     sr1.oqt055  #CHI-C30024    
            END IF
            IF cl_null(sr2.oqu02) THEN  #MOD-4A0256
               EXIT FOREACH
            END IF
         END FOREACH
         LET l_oqt01_t = sr1.oqt01
      END FOREACH
   #TQC-C60054-----add---str---
   ELSE
      FOREACH r360_c1 USING tm.b INTO sr1.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF

        SELECT gec04,gec07 INTO l_gec04,l_gec07 FROM gec_file WHERE gec01=sr1.oqt24
        SELECT oag02 INTO l_oag02 FROM oag_file WHERE oag01=sr1.oqt25
        SELECT oac02 INTO l_oac02 FROM oac_file WHERE oac01=sr1.oqt26
        SELECT oac02 INTO l_oac02_1 FROM oac_file WHERE oac01=sr1.oqt27
        SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
        SELECT zo02 INTO l_zo02 FROM zo_file WHERE zo01 = g_rlang  

         SELECT oah02 INTO l_oah02 FROM oah_file
          WHERE oah01 = sr1.oqt10

         SELECT ged02 INTO l_ged02 FROM ged_file
          WHERE ged01 = sr1.oqt11

         FOREACH r360_c4 USING sr1.oqt01 INTO sr3.*  
           IF SQLCA.sqlcode THEN
              EXIT FOREACH
           END IF
           SELECT azi04 INTO t_azi04
             FROM azi_file
            WHERE azi01 = sr3.oqx041
           EXECUTE insert3 USING sr3.*,t_azi04
         END FOREACH
    
         FOREACH r360_c2 USING sr1.oqt01 INTO sr2.* 
            IF SQLCA.sqlcode THEN
               INITIALIZE sr2.* TO NULL
               EXIT FOREACH
            END IF
            IF cl_null(sr2.oqu07) THEN LET sr2.oqu07=0 END IF
            IF cl_null(sr2.oqu09) THEN LET sr2.oqu09=0 END IF
            IF cl_null(sr2.oqu11) THEN LET sr2.oqu11=0 END IF
            IF cl_null(sr2.oqu13) THEN LET sr2.oqu13=0 END IF

           #額外品名規格
            FOR i = 1 TO 30 INITIALIZE l_imc04[i] TO NULL END FOR  #

            IF NOT cl_null(tm.a) AND sr2.oqu03[1,4] !='MISC'  THEN  #讀取額外品名規格
               LET i=1

               FOREACH r360_c3 USING sr2.oqu03,tm.a INTO l_imc03,l_imc04[i] 
                 IF SQLCA.sqlcode THEN EXIT FOREACH END IF
                 EXECUTE insert2 USING  sr2.oqu03,tm.a,l_imc03,l_imc04[i]    
                 LET i = i +1
               END FOREACH
            END IF

           #列印單身備註
            FOREACH oao_c1 USING sr1.oqt01,sr2.oqu02 INTO oao.*    
               IF NOT cl_null(oao.oao06) THEN
                  EXECUTE insert4 USING
                     sr1.oqt01,sr2.oqu02,oao.oao04,oao.oao05,oao.oao06
               END IF
            END FOREACH

            IF sr1.oqt12 = 'N' AND tm.b ='N' THEN    #N：一般
               LET l_obk03 = sr2.oqu04
               SELECT azi04 INTO l_azi04 FROM azi_file
                WHERE azi01=sr1.oqt09

               EXECUTE insert1 USING sr1.oqt12 ,sr1.oqt01 ,sr1.oqt03 ,sr1.oqt04 ,sr1.oqt041,sr1.oqt051,
                                     sr1.oqt052,sr1.oqt053,sr1.oqt054,sr1.oqt13 ,sr1.oqt141,
                                     sr1.oqt142,sr1.oqt143,sr1.oqt151,sr1.oqt152,sr1.oqt161,
                                     sr1.oqt162,sr1.oqt171,sr1.oqt172,sr1.oqt173,sr1.oqt181,
                                     sr1.oqt182,sr1.oqt191,sr1.oqt192,sr1.oqt10 ,sr1.oqt08 ,sr1.oqt11,
                                     sr1.oqt09 ,sr1.oqt20 ,sr1.oqt02 ,l_azi04   ,                 
                                     sr2.oqu01 ,sr2.oqu02 ,sr2.oqu03 ,sr2.oqu031,sr2.oqu032,
                                     sr2.oqu06 ,sr2.oqu05 ,sr2.oqu07 ,sr2.oqu09 ,sr2.oqu10 ,       
                                     sr2.oqu11 ,sr2.oqu13 ,l_obk03   ,l_zo041   ,l_zo05    ,l_zo09, 
                                     "",l_img_blob,"N","",             
                                     l_oah02   ,l_ged02,                                          
                                     sr1.oqt24,l_gec04,l_gec07,sr1.oqt25,l_oag02,sr1.oqt26,l_oac02,
                                     sr1.oqt27,l_oac02_1,
                                     sr1.oqt055  #CHI-C30024                                     
            END IF

            IF sr1.oqt12 = 'Y' AND tm.b ='Y' THEN    #Y:分量計價
               LET l_obk03 = sr2.oqu04
               SELECT azi04 INTO l_azi04 FROM azi_file
                WHERE azi01=sr1.oqt09
               IF SQLCA.sqlcode THEN
                  CALL cl_err('prepare:',SQLCA.sqlcode,1)
                  CALL cl_used(g_prog,g_time,2) RETURNING g_time
               EXIT PROGRAM
               END IF
               LET i = 1
               FOREACH r360_c7 USING sr1.oqt01,sr2.oqu02 INTO l_oqv[i].*
                  EXECUTE insert5 USING
                     l_oqv[i].oqv01,l_oqv[i].oqv02,l_oqv[i].oqv03,l_oqv[i].oqv04,l_oqv[i].oqv05
                   LET i= i + 1
               END FOREACH

               EXECUTE insert1 USING sr1.oqt12,sr1.oqt01,sr1.oqt03,sr1.oqt04,sr1.oqt041,sr1.oqt051,
                                     sr1.oqt052,sr1.oqt053,sr1.oqt054,sr1.oqt13,sr1.oqt141,
                                     sr1.oqt142,sr1.oqt143,sr1.oqt151,sr1.oqt152,sr1.oqt161,
                                     sr1.oqt162,sr1.oqt171,sr1.oqt172,sr1.oqt173,sr1.oqt181,
                                     sr1.oqt182,sr1.oqt191,sr1.oqt192,sr1.oqt10,sr1.oqt08,sr1.oqt11,
                                     sr1.oqt09,sr1.oqt20,sr1.oqt02,l_azi04,            
                                     sr2.oqu01,sr2.oqu02,sr2.oqu03,sr2.oqu031,sr2.oqu032,
                                     sr2.oqu06,sr2.oqu05,sr2.oqu07,sr2.oqu09, sr2.oqu10,
                                     sr2.oqu11,sr2.oqu13,l_obk03,l_zo041,l_zo05,l_zo09, 
                                     "",l_img_blob,"N","",         
                                     l_oah02   ,l_ged02,                                          
                                     sr1.oqt24,l_gec04,l_gec07,sr1.oqt25,l_oag02,sr1.oqt26,l_oac02, 
                                     sr1.oqt27,l_oac02_1,   
                                     sr1.oqt055  #CHI-C30024                                     
            END IF
            IF cl_null(sr2.oqu02) THEN
               EXIT FOREACH
            END IF
         END FOREACH
 
         LET l_oqt01_t = sr1.oqt01
  
      END FOREACH
   END IF 
     #TQC-C60054-----add---end---
 
    LET l_sql4 = "SELECT oqt01 FROM oqt_file ",
                 " WHERE ",tm.wc CLIPPED,
                 "   ORDER BY oqt01"
    PREPARE r360_p5 FROM l_sql4
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare5:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
    END IF
    DECLARE r360_c5 CURSOR FOR r360_p5
 
    FOREACH r360_c5 INTO sr1.oqt01
      #單頭費用資料
       DECLARE r360_c6 CURSOR FOR
          SELECT oqx01,oqx03,oqx04,oaj02,oqx041,oqx05,oqx06 
            FROM oqx_file,OUTER oaj_file
           WHERE oqx01 = sr1.oqt01
             AND oqx03 = '0'
             AND oqx_file.oqx04=oaj_file.oaj01 
           ORDER BY 1
       
       FOREACH r360_c6 INTO sr3.*          
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
       #-MOD-970263-add- 
        SELECT azi04 INTO t_azi04
          FROM azi_file
         WHERE azi01 = sr3.oqx041   
       #-MOD-970263-add- 
         EXECUTE insert3 USING sr3.*,t_azi04  
       END FOREACH
 
      #單頭備註
       DECLARE oao_c2 CURSOR FOR                                                 
        SELECT * FROM oao_file                                               
         WHERE oao01=sr1.oqt01 
           AND oao03='0' 
           AND (oao05='1' OR oao05='2')
         ORDER BY oao04                                                          
       FOREACH oao_c2 INTO oao.*                                               
          IF NOT cl_null(oao.oao06) THEN
             EXECUTE insert4 USING 
                sr1.oqt01,'0',oao.oao04,oao.oao05,oao.oao06                
          END IF                                                                 
       END FOREACH                                                               
    END FOREACH
 
  #FUN-7C0073---add---str--- 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,      #單身費用明細
               " WHERE oqx03 != 0 ","|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",  #費用總計
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,      #單頭費用明細
               " WHERE oqx03 = 0 ","|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " WHERE oao03 =0 AND oao05='1'","|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " WHERE oao03!=0 AND oao05='1'","|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " WHERE oao03!=0 AND oao05='2'","|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " WHERE oao03 =0 AND oao05='2'","|",                         #MOD-820057 modify add "|"
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,"|",   #MOD-820057 add #分量計價明細
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED        #MOD-820057 add #分量計價明細
                         
             # "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,"|",
             # "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED
  #FUN-7C0073---add---end--- 
 
    IF g_zz05='Y' THEN
       LET l_lang_t = g_lang  #TQC-750114
      #LET g_lang = l_occ55   #FUN-7C0036 mark  #TQC-750114
       CALL cl_wcchp(tm.wc,'oqt01,oqt02,oqt03,oqt04,oqt06,oqt07')
        RETURNING tm.wc
       LET g_lang = l_lang_t  #TQC-750114
#MOD-B70129 -- begin --
    ELSE
       LET tm.wc = ' '
#MOD-B70129 -- end --
    END IF
 
   #LET g_str = tm.wc                                  #FUN-7C0073 mark 
    LET g_str = tm.wc,';',tm.a,';',tm.b,';',tm.c       #FUN-7C0073 mod 
    IF NOT cl_null(tm.d) THEN
       LET g_str = g_str,';',tm.d  
    END IF
###No.FUN-940043 START###
     LET g_cr_table = l_table                 #主報表的temp table名稱
     #LET g_cr_gcx01 = "axmi010"               #單別維護程式#TQC-C10039 mark---
     LET g_cr_apr_key_f = "oqt01"             #報表主鍵欄位名稱，用"|"隔開
#TQC-C10039--start--mark---
     #LET l_sql_1="SELECT DISTINCT oqt01 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     #PREPARE key_pr FROM l_sql_1
     #DECLARE key_cs CURSOR FOR key_pr
     #LET l_ii = 1
     ##報表主鍵值
     #CALL g_cr_apr_key.clear()                #清空
     #FOREACH key_cs INTO l_key.*
     #   LET g_cr_apr_key[l_ii].v1 = l_key.v1
     #   LET l_ii = l_ii + 1
     #END FOREACH
#TQC-C10039--end--mark---
###No.FUN-940043 END### 
  # CALL cl_prt_cs3('axmr360',g_sql,g_str)
    CALL cl_prt_cs3('axmr360','axmr360',g_sql,g_str)
  #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
  #No.FUN-710090--end--
 
END FUNCTION
#FUN-7C0073---mod---end---
 
#FUN-7C0073---mark---str---
#{
#FUNCTION r360()
#   DEFINE l_name     LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680137 VARCHAR(20)
##         l_time     LIKE type_file.chr8,  		# Used time for running the job   #No.FUN-680137 VARCHAR(8)  #NO.FUN-6A0094
#          l_n        LIKE type_file.num5,               # No.FUN-710090
#          l_i        LIKE type_file.num5,  		#        #No.FUN-680137 SMALLINT
#          l_sql1     LIKE type_file.chr1000,		#        #No.FUN-680137 VARCHAR(1000)
#          l_sql2     LIKE type_file.chr1000,		#        #No.FUN-680137 VARCHAR(1000)
#          l_sql3     LIKE type_file.chr1000,		#        #No.FUN-680137 VARCHAR(1000)
#          l_sql4     LIKE type_file.chr1000,		#        #No.FUN-680137 VARCHAR(1000)
#          l_sql5     LIKE type_file.chr1000,		#        #No.FUN-680137 VARCHAR(1000)
#          l_sql6     LIKE type_file.chr1000,		#        #No.FUN-680137 VARCHAR(1000)
#          l_sql7     LIKE type_file.chr1000,		#        #No.FUN-680137 VARCHAR(1000)
#          l_za05     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
#          l_oqt12    LIKE oqt_file.oqt12,
#          sr1        RECORD
#                        oqt12     LIKE    oqt_file.oqt12,  #
#                        oqt01     LIKE    oqt_file.oqt01,   #Quote.No
#                        oqt03     LIKE    oqt_file.oqt03,   #Your Ref
#                        oqt04     LIKE    oqt_file.oqt04,   #FUN-690032 add
#                        oqt041    LIKE    oqt_file.oqt041,  #
#                        oqt051    LIKE    oqt_file.oqt051,  #
#                        oqt052    LIKE    oqt_file.oqt052,  #
#                        oqt053    LIKE    oqt_file.oqt053,  #
#                        oqt054    LIKE    oqt_file.oqt054,  #
#                        oqt13     LIKE    oqt_file.oqt13,   #
#                        oqt141    LIKE    oqt_file.oqt141,  #
#                        oqt142    LIKE    oqt_file.oqt142,  #
#                        oqt143    LIKE    oqt_file.oqt143,  #
#                        oqt151    LIKE    oqt_file.oqt151,  #PAYMENT
#                        oqt152    LIKE    oqt_file.oqt152,  #
#                        oqt161    LIKE    oqt_file.oqt161,  #SHIPMENT
#                        oqt162    LIKE    oqt_file.oqt162,  #
#                        oqt171    LIKE    oqt_file.oqt171,  #PACKING
#                        oqt172    LIKE    oqt_file.oqt172,  #
#                        oqt173    LIKE    oqt_file.oqt173,  #
#                        oqt181    LIKE    oqt_file.oqt181,  #INSURANCE
#                        oqt182    LIKE    oqt_file.oqt182,  #
#                        oqt191    LIKE    oqt_file.oqt191,  #VALIDITY
#                        oqt192    LIKE    oqt_file.oqt192,  #
#                        oqt10     LIKE    oqt_file.oqt10,   #
#                        oqt08     LIKE    oqt_file.oqt08,   #
#                        oqt11     LIKE    oqt_file.oqt11,   #
#                        oqt09     LIKE    oqt_file.oqt09,   #
#                        oqt20     LIKE    oqt_file.oqt20,   #
#                        oqt02     LIKE    oqt_file.oqt02    #
#                     END RECORD,
#          sr2        RECORD
#                        oqu01     LIKE    oqu_file.oqu01,   #No.FUN-710090
#                        oqu02     LIKE    oqu_file.oqu02,   #
#                        oqu03     LIKE    oqu_file.oqu03,   #
#                        oqu031    LIKE    oqu_file.oqu031,  #
#                        oqu032    LIKE    oqu_file.oqu032,  #
#                        oqu06     LIKE    oqu_file.oqu06,   #
#                        oqu05     LIKE    oqu_file.oqu05,   #
#                        oqu07     LIKE    oqu_file.oqu07,   #
#                        oqu09     LIKE    oqu_file.oqu09,   #
#                        oqu10     LIKE    oqu_file.oqu10,   #
#                        oqu11     LIKE    oqu_file.oqu11,   #
#                        oqu13     LIKE    oqu_file.oqu13    #
#                     END RECORD
# #No.FUN-710090--begin-- 
#  DEFINE  sr3        RECORD
#                        oqx01     LIKE    oqx_file.oqx01,   #No.FUN-710090
#                        oqx03     LIKE    oqx_file.oqx03,   
#                        oqx04     LIKE    oqx_file.oqx04,   
#                        oaj02     LIKE    oaj_file.oaj02,   
#                        oqx041_1  LIKE    oqx_file.oqx041,  
#                        oqx05_1   LIKE    oqx_file.oqx05,   
#                        oqx06     LIKE    oqx_file.oqx06    
#                     END RECORD,
#          sr4        RECORD
#                        oqx01     LIKE    oqx_file.oqx01,
#                        oqx041_2  LIKE    oqx_file.oqx041,  
#                        oqx05_2   LIKE    oqx_file.oqx05    
#                     END RECORD,
#          l_oqv      DYNAMIC ARRAY OF RECORD
#                        oqv03     LIKE    oqv_file.oqv03,  
#                        oqv04     LIKE    oqv_file.oqv04,  
#                        oqv05     LIKE    oqv_file.oqv05   
#                     END RECORD
#DEFINE    l_oao03    LIKE    oao_file.oao03,             #
#          l_oao05    LIKE    oao_file.oao05,             #
#          l_oao04    LIKE    oao_file.oao04,             #
#          l_oao06    LIKE    oao_file.oao06,
#          l_oao06_1  LIKE    oao_file.oao06,
#          l_oao06_2  LIKE    oao_file.oao06,
#          l_oao06_3  LIKE    oao_file.oao06,
#          l_obk03    LIKE    obk_file.obk03,
#          l_oqx03_1  LIKE    oqx_file.oqx03,             #
#          l_oqx03_2  LIKE    oqx_file.oqx03,             #
#          l_oqt01_t  LIKE    oqt_file.oqt01
#DEFINE    i          LIKE    type_file.num5,
#          l_oqu06    LIKE    type_file.chr1000,
#          l_imc03    LIKE    imc_file.imc03,           #MOD-790032 add
#          l_imc04    ARRAY[30] OF LIKE cob_file.cob08
#DEFINE    l_azi04    LIKE    azi_file.azi04
#DEFINE    l_occ55    LIKE    occ_file.occ55            #FUN-720024 add
#DEFINE    l_zo02     LIKE    zo_file.zo02              #FUN-720024 add
# #No.FUN-710090--end--
#DEFINE    l_lang_t   LIKE type_file.chr1               #TQC-750114
#
# #No.FUN-710090--begin--
#   LET g_sql = "INSERT INTO ds_report.",
#               l_table1 CLIPPED," VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
#                                "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
#                                "        ?,?,?,?,? )"
#   PREPARE insert1 FROM g_sql  
#   IF STATUS THEN   
#      CALL cl_err("insert1:",STATUS,1) EXIT PROGRAM 
#   END IF
#
#   LET g_sql = "INSERT INTO ds_report.",
#                l_table2 CLIPPED," VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
#   PREPARE insert2 FROM g_sql                                                                                                   
#   IF STATUS THEN                                                                                                                   
#      CALL cl_err("insert2:",STATUS,1) EXIT PROGRAM                                                                             
#   END IF                         
#
#   LET g_sql = "INSERT INTO ds_report.",
#                l_table3 CLIPPED," VALUES(?,?,?,?,?, ?,?)"
#   PREPARE insert3 FROM g_sql
#   IF STATUS THEN
#      CALL cl_err("insert3:",STATUS,1) EXIT PROGRAM
#   END IF
#
#   LET g_sql = "INSERT INTO ds_report.",
#                l_table4 CLIPPED," VALUES(?,?,?)"  #MOD-7C0136
#   PREPARE insert4 FROM g_sql
#   IF STATUS THEN
#      CALL cl_err("insert4:",STATUS,1) EXIT PROGRAM
#   END IF
#  #MOD-790032-begin-add
#   LET g_sql = "INSERT INTO ds_report.",
#                l_table5 CLIPPED," VALUES(?,?,?,?)"
#   PREPARE insert5 FROM g_sql
#   IF STATUS THEN
#      CALL cl_err("insert5:",STATUS,1) EXIT PROGRAM
#   END IF
#  #MOD-790032-end-add
#   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='axmr360'
# #No.FUN-710090--end--
#  #FOR  l_i = 1 TO g_len LET g_dash3[l_i,l_i] = '-' END FOR               #No.FUN-590110 #FUN-5A0069 mark
#
#   IF g_priv2='4' THEN                   #只能使用自己的資料
#      LET tm.wc = tm.wc clipped," AND oqtuser = '",g_user,"'"
#   END IF
#
#   IF g_priv3='4' THEN                   #只能使用相同群的資料
#      LET tm.wc = tm.wc clipped," AND oqtgrup MATCHES '",g_grup CLIPPED,"*'"
#   END IF
#
#   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
#      LET tm.wc = tm.wc clipped," AND oqtgrup IN ",cl_chk_tgrup_list()
#   END IF
#
#   CALL cl_del_data(l_table1) #No.FUN-710090
#   CALL cl_del_data(l_table2) #No.FUN-710090
#   CALL cl_del_data(l_table3) #No.FUN-710090
#   CALL cl_del_data(l_table4) #No.FUN-710090
#   CALL cl_del_data(l_table5) #No.MOD-790032
#
#   LET l_sql1 = " SELECT oqt12,",
#                " oqt01 ,oqt03 ,oqt04,oqt041,oqt051,oqt052,oqt053,oqt054,oqt13,",  #FUN-690032 add oqt04
#                " oqt141,oqt142,oqt143,oqt151,oqt152,oqt161,oqt162,oqt171,",
#                " oqt172,oqt173,oqt181,oqt182,oqt191,oqt192,oqt10,oqt08,",
#                " oqt11,oqt09,oqt20,oqt02",   
#                " FROM oqt_file ",        
#                " WHERE oqt12 = ? ",
#                "   AND ",tm.wc CLIPPED #MOD-4A0079
#                #MOD-4A0079 MARK掉,改寫如下段
#               #"   AND oqtconf ='Y'", #01/08/06 mandy已確認的資料
#               #"   AND ",tm.wc CLIPPED,
#               #" ORDER BY oqt01 "
#
#   CASE tm.c
#       WHEN '1' #1.確認
#           LET l_sql1 = l_sql1 CLIPPED," AND oqtconf = 'Y' "
#       WHEN '2' #2.未確認
#           LET l_sql1 = l_sql1 CLIPPED," AND oqtconf = 'N' "
#       WHEN '3' #3.作廢
#           LET l_sql1 = l_sql1 CLIPPED," AND oqtconf = 'X' "
#       WHEN '4' #3.全部
#           LET l_sql1 = l_sql1 CLIPPED," AND oqtconf <> 'X' "
#   END CASE
#
#   LET l_sql1 = l_sql1 CLIPPED ," ORDER BY oqt01 "
#   #MOD-4A0079(end)
#
#   LET l_sql2  = " SELECT oqu01,oqu02,oqu03,oqu031,oqu032,oqu06,oqu05,",
#                 "        oqu07,oqu09 ,oqu10 ,oqu11,oqu13 ",
# #               " FROM  oqu_file",                  #MOD-4A0256
# #               " WHERE oqu01 = ? ",                #MOD-4A0256
#                 " FROM  oqt_file,OUTER oqu_file",   #MOD-4A0256
#                #" WHERE oqu_file.oqu01 = ? ",       #MOD-4A0256
#                 " WHERE oqt_file.oqt01 = ? ",       #MOD-560215
#                 "   AND oqt_file.oqt01 = oqu_file.oqu01 ",   #MOD-4A0256
#                 " ORDER BY oqu02"
#
#   LET l_sql3  = " SELECT oao04,oao06 FROM oao_file",
#                 " WHERE oao01 = ? AND oao03= ? AND oao05= ? ",
#                 " ORDER BY 1"
#
#   LET l_sql4  = " SELECT imc04,imc03 FROM imc_file",  #MOD-790032 modify
#                 " WHERE imc01 = ? AND imc02 = ?",
#                 " ORDER BY imc03"   #MOD-790032 modify
#
#   LET l_sql5  = " SELECT oqv03,oqv04,oqv05 FROM oqv_file",
#                 " WHERE oqv01 = ? AND oqv02= ? ",
#                 " ORDER BY 1"
#
#   LET l_sql6  = " SELECT oqx01,oqx03,oqx04,oaj02,oqx041,oqx05,oqx06 ",
#                 " FROM oqx_file,OUTER oaj_file ",
#                 " WHERE oqx01 = ? AND oqx03 BETWEEN ? AND ? ",
#                 " AND oqx_file.oqx04=oaj_file.oaj01  ORDER BY 1"
#
#   LET l_sql7  = " SELECT oqx01,oqx041,SUM(oqx05)  FROM oqx_file ",
#                 " WHERE oqx01 = ? AND oqx03 BETWEEN ? AND ? ",
#                 " GROUP BY oqx01,oqx041"    #No.FUN-710090  
#               # " GROUP BY 1"               #No.FUN-710090  mark
#
#   PREPARE r360_p1 FROM l_sql1
#   IF SQLCA.sqlcode THEN
#      CALL cl_err('prepare:',SQLCA.sqlcode,1)
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
#      EXIT PROGRAM
#   END IF
#   DECLARE r360_c1 CURSOR FOR r360_p1
#
#   PREPARE r360_p2 FROM l_sql2
#   IF SQLCA.sqlcode THEN
#      CALL cl_err('prepare:',SQLCA.sqlcode,1)
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
#      EXIT PROGRAM
#   END IF
#   DECLARE r360_c2 CURSOR FOR r360_p2
#
#   PREPARE r360_p3 FROM l_sql3
#   IF SQLCA.sqlcode THEN
#      CALL cl_err('prepare:',SQLCA.sqlcode,1)
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
#      EXIT PROGRAM
#   END IF
#   DECLARE r360_c3 CURSOR FOR r360_p3
#
#   PREPARE r360_p4 FROM l_sql4
#   IF SQLCA.sqlcode THEN
#      CALL cl_err('prepare:',SQLCA.sqlcode,1)
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
#      EXIT PROGRAM
#   END IF
#   DECLARE r360_c4 CURSOR FOR r360_p4
#
#   PREPARE r360_p5 FROM l_sql5
#   IF SQLCA.sqlcode THEN
#      CALL cl_err('prepare:',SQLCA.sqlcode,1)
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
#      EXIT PROGRAM
#   END IF
#   DECLARE r360_c5 CURSOR FOR r360_p5
#
#   PREPARE r360_p6 FROM l_sql6
#   IF SQLCA.sqlcode THEN
#      CALL cl_err('prepare:',SQLCA.sqlcode,1)
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
#      EXIT PROGRAM
#   END IF
#   DECLARE r360_c6 CURSOR FOR r360_p6
#
#   PREPARE r360_p7 FROM l_sql7
#   IF SQLCA.sqlcode THEN
#      CALL cl_err('prepare:',SQLCA.sqlcode,1)
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
#      EXIT PROGRAM
#   END IF
#   DECLARE r360_c7 CURSOR FOR r360_p7
#
#   ## Modify Bug No.:7252
#
#  #CALL cl_outnam('axmr360') RETURNING l_name  #No.FUN-710090 mark
#   OPEN r360_c1 USING tm.b
# ###No.FUN-710090--begin-- mark 
# #  LET g_cnt = 1
# #  LET g_pageno = 0
#
# #  #No.FUN-590110--start
# #  IF tm.b = 'N' THEN
# #     LET g_zaa[38].zaa06='N'
# #     #START REPORT r360_rep TO l_name  #FUN-690132
# #  ELSE
# #     LET g_zaa[38].zaa06='Y'
# #     #START REPORT r360_rep TO l_name   #FUN-690032
# #  END IF
# # #FUN-690032 add--begin  #列印客戶料號
# #  IF tm.d = 'N' THEN
# #     LET g_zaa[39].zaa06 = 'Y'
# #  ELSE
# #     LET g_zaa[39].zaa06 = 'N'
# #  END IF
# # #FUN-690032 add--end
# #  START REPORT r360_rep TO l_name   #FUN-690032
# #  CALL cl_prt_pos_len()
# #  #NO.FUN-590110--end
#
# #  LET l_oqt01_t= 'N'
# #  LET g_start='Y'
# ###No.FUN-710090--end-- mark
#  
#   FOREACH r360_c1 USING tm.b INTO sr1.*
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
#
#      ## Modify for Bug No.:7252
#      IF tm.more = "N" AND cl_null(ARG_VAL(3)) THEN
#         #SELECT occ55 INTO g_rlang   #No.MOD-610074     #FUN-720024
#         SELECT occ55 INTO l_occ55                       #FUN-720024
#           FROM oqt_file,OUTER occ_file  #MOD-750116 add OUTER
#          WHERE oqt01 = sr1.oqt01
#           AND occ_file.occ01 = oqt04 
#      END IF
#     #FUN-720024 begin
#      IF cl_null(l_occ55) THEN
#        LET l_occ55 = g_rlang
#      END IF
#     #FUN-720024 end 
#
#      SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang 
#      SELECT zo02 INTO l_zo02 FROM zo_file WHERE zo01 = l_occ55    #FUN-720024
#      ##
#
#      #check備注是否列印--> oao_file
#      SELECT COUNT(*) INTO l_n FROM oao_file
#       WHERE oao01 = sr1.oqt01
#         AND oao03 = 0
#         AND oao05 = '1'
#      IF l_n > 0  THEN
#         LET l_oao06_1=''
#         LET l_oao03 = 0
#         LET l_oao05 = '1'
#         FOREACH r360_c3 USING sr1.oqt01,l_oao03,l_oao05
#                          INTO l_oao04,l_oao06
#            IF SQLCA.sqlcode THEN
#               EXIT FOREACH
#            END IF
#            IF cl_null(l_oao06) THEN
#               CONTINUE FOREACH
#            ELSE
#               LET l_oao06_1 = l_oao06,' '
#            END IF
#         END FOREACH
#      END IF
# 
#      #check費用是否列印 --> oqx_file
#      SELECT COUNT(*) INTO l_n FROM oqx_file
#       WHERE oqx01 = sr1.oqt01
#         AND oqx03 = 0
#      IF l_n > 0 THEN
#         LET l_oqx03_1=0
#         FOREACH r360_c6 USING sr1.oqt01,l_oqx03_1,l_oqx03_1 INTO sr3.*
#            IF SQLCA.sqlcode THEN
#               EXIT FOREACH
#            END IF
#            IF cl_null(sr3.oqx05_1) OR sr3.oqx05_1 = 0 THEN
#               CONTINUE FOREACH
#            ELSE
#               EXECUTE insert3 USING sr3.oqx01,sr3.oqx03,sr3.oqx04,sr3.oaj02,sr3.oqx041_1,
#                                     sr3.oqx05_1,sr3.oqx06
#            END IF
#         END FOREACH
#      END IF
#
#      FOREACH r360_c2 USING sr1.oqt01 INTO sr2.*
#         IF SQLCA.sqlcode THEN
#            INITIALIZE sr2.* TO NULL
#            EXIT FOREACH
#         END IF
#        #MOD-7B0056-begin
#         IF cl_null(sr2.oqu07) THEN LET sr2.oqu07=0 END IF
#         IF cl_null(sr2.oqu09) THEN LET sr2.oqu09=0 END IF
#         IF cl_null(sr2.oqu11) THEN LET sr2.oqu11=0 END IF
#         IF cl_null(sr2.oqu13) THEN LET sr2.oqu13=0 END IF
#        #MOD-7B0056-end
#
#        #No.FUN-710090--begin-- 
#        ##No.FUN-590110--start
#        #IF sr1.oqt12 = 'N' AND tm.b = 'N' THEN
#        #   OUTPUT TO REPORT r360_rep(sr1.*,sr2.*,l_oqt01_t)
#        #   LET g_type= 'N'
#        #END IF
#
#        #IF sr1.oqt12 = 'Y' AND tm.b = 'Y' THEN
#        #   OUTPUT TO REPORT r360_rep(sr1.*,sr2.*,l_oqt01_t)
#        #   LET g_type='Y'
#        #END IF
#
#        # check備注是否列印--> oao_file
#         SELECT COUNT(*) INTO l_n FROM oao_file
#          WHERE oao01 = sr1.oqt01
#            AND oao03 = sr2.oqu02
#            AND oao05 = '1'
#         IF l_n > 0  THEN
#            LET l_oao03=sr2.oqu02
#            LET l_oao05='1'
#            LET l_oao06_2=''
#            FOREACH r360_c3 USING sr1.oqt01,l_oao03,l_oao05 INTO l_oao04,l_oao06
#               IF SQLCA.sqlcode THEN
#                  EXIT FOREACH
#               END IF
#               IF cl_null(l_oao06) THEN
#                  CONTINUE FOREACH
#               ELSE
#                  LET l_oao06_2 = l_oao06,' '
#               END IF
#            END FOREACH
#         END IF
#         FOR i = 1 TO 30 INITIALIZE l_imc04[i] TO NULL END FOR  #
#         FOR i = 1 TO 100 INITIALIZE l_oqv[i].* TO NULL END FOR  #
#
#         IF NOT cl_null(tm.a) AND sr2.oqu03[1,4] !='MISC'  THEN  #讀取額外品名規格
#            LET i=1
#            
#            FOREACH r360_c4 USING sr2.oqu03,tm.a INTO l_imc04[i],l_imc03   #MOD-790032 modify
#              IF SQLCA.sqlcode THEN EXIT FOREACH END IF
#              EXECUTE insert5 USING  sr2.oqu03,tm.a,l_imc03,l_imc04[i]     #MOD-790032
#              LET i = i +1
#            END FOREACH
#         END IF
#         LET i = 1
#         FOREACH r360_c5 USING sr1.oqt01,sr2.oqu02 INTO l_oqv[i].*
#            IF SQLCA.sqlcode THEN
#               EXIT FOREACH
#            END IF
#            LET i = i +1
#         END FOREACH
#
#         IF sr1.oqt12 = 'N' AND tm.b ='N' THEN
#            #MOD-790032-begin
#            #FOR i = 1 TO 100
#            #   IF i <=30 THEN
#            #      IF l_imc04[i] IS NULL THEN
#            #         EXIT FOR
#            #      END IF
#            #   END IF
# 
#            #   IF i <= 30 AND cl_null(l_imc04[i]) THEN
#            #      CASE i
#            #           WHEN 1    LET l_imc04[i]=sr2.oqu031
#            #           WHEN 2    LET l_imc04[i]=sr2.oqu032
#            #           OTHERWISE LET l_imc04[i]=''
#            #      END CASE
#            #   END IF
#            #   IF i <=30 THEN
#            #      LET sr2.oqu032 = l_imc04[i]
#            #   END IF
#            #END FOR   
#            #MOD-790032-end
#            LET l_obk03 = ''
#            SELECT obk03 INTO l_obk03 FROM obk_file
#             WHERE obk01 = sr2.oqu03
#               AND obk02 = sr1.oqt04
#               AND obk05 = sr1.oqt09  #MOD-7B0056 add
#            IF SQLCA.sqlcode THEN
#              LET l_obk03 = ''
#            END IF 
#            LET l_oqu06 = sr2.oqu06 USING '##########',''  #MOD-7B0056  
#            EXECUTE insert2 USING sr2.oqu01,sr2.oqu02,sr2.oqu03,sr2.oqu031,sr2.oqu032,l_oqu06,  #MOD-7B0056 modify sr2.oqu06,
#                                  sr2.oqu05,sr2.oqu07,sr2.oqu09,sr2.oqu10,sr2.oqu11,sr2.oqu13,
#                                  l_obk03,l_oao06_2      
#         END IF
#         IF sr1.oqt12 = 'Y' AND tm.b ='Y' THEN
#           #MOD-790032-begin-modify
#            #FOR i = 1 TO 100
#             #  IF i <=30 THEN
#             #     IF l_imc04[i] IS NULL AND l_oqv[i].oqv03 IS NULL THEN
#             #        EXIT FOR
#             #     END IF
#             #  ELSE
#             #     IF l_oqv[i].oqv03 IS NULL THEN
#             #        EXIT FOR
#             #     END IF
#             #  END IF
# 
#             #  IF i <= 30 AND cl_null(l_imc04[i]) THEN
#             #     CASE i
#             #          WHEN 1    LET l_imc04[i]=sr2.oqu031
#             #          WHEN 2    LET l_imc04[i]=sr2.oqu032
#             #          OTHERWISE LET l_imc04[i]=''
#             #     END CASE
#             #  END IF
#             #  IF i <=30 THEN
#             #     LET sr2.oqu032 = l_imc04[i]
#             #  END IF
#             #END FOR   #MOD-790032 
#           #MOD-790032-end-modify
#                  LET l_obk03 = ''
#                  SELECT obk03 INTO l_obk03 FROM obk_file
#                   WHERE obk01 = sr2.oqu03
#                     AND obk02 = sr1.oqt04
#                     AND obk05 = sr1.oqt09  #MOD-7B0056 add
#                  IF SQLCA.sqlcode THEN
#                    LET l_obk03 = ''
#                  END IF
#                  LET l_oqu06=l_oqv[i].oqv03 USING '#####','-',
#                              l_oqv[i].oqv04 USING '#####'  CLIPPED
#                  LET sr2.oqu07=l_oqv[i].oqv05
#                  IF cl_null(sr2.oqu07) THEN LET sr2.oqu07=0 END IF  #MOD-7B0056 add
#                  EXECUTE insert2 USING sr2.oqu01,sr2.oqu02,sr2.oqu03,sr2.oqu031,sr2.oqu032,
#                                        l_oqu06,  sr2.oqu05,sr2.oqu07,sr2.oqu09, sr2.oqu10,
#                                        sr2.oqu11,sr2.oqu13,l_obk03,  l_oao06_2 
#            #END FOR   #MOD-790032 mark
#         END IF
#        #No.FUN-710090--end--
#         IF cl_null(sr2.oqu02) THEN  #MOD-4A0256
#            EXIT FOREACH
#         END IF
#      END FOREACH
#      LET l_oqt01_t = sr1.oqt01
#
#      LET l_oqx03_1=1
#      LET l_oqx03_2=100
#      LET l_n=0
#      FOREACH r360_c6 USING sr1.oqt01,l_oqx03_1,l_oqx03_2 INTO sr3.*
#         IF SQLCA.sqlcode THEN
#            EXIT FOREACH
#         END IF
#         IF cl_null(sr3.oqx05_1) OR sr3.oqx05_1 = 0 THEN
#            CONTINUE FOREACH
#         ELSE
#            EXECUTE insert3 USING sr3.oqx03,sr3.oqx03,sr3.oqx04,sr3.oaj02,sr3.oqx041_1,
#                                  sr3.oqx05_1,sr3.oqx06
#         END IF
#      END FOREACH
#
#      LET l_oqx03_1=1
#      LET l_oqx03_2=100
#      LET l_n=0
#      FOREACH r360_c7 USING sr1.oqt01,l_oqx03_1,l_oqx03_2 INTO sr4.*
#         IF SQLCA.sqlcode THEN
#            EXIT FOREACH
#         END IF
#         IF cl_null(sr4.oqx05_2) OR sr4.oqx05_2 = 0 THEN
#            CONTINUE FOREACH
#         ELSE
#            EXECUTE insert4 USING sr4.oqx01,sr4.oqx041_2,sr4.oqx05_2
#         END IF
#      END FOREACH
#
#      # check備注是否列印
#        LET l_oao03=0
#        LET l_oao05='2'
#        LET l_n=0
#        FOREACH r360_c3 USING sr1.oqt01,l_oao03,l_oao05 INTO l_oao04,l_oao06
#           IF SQLCA.sqlcode THEN
#              EXIT FOREACH
#           END IF
#           IF cl_null(l_oao06) THEN
#              EXIT FOREACH
#           ELSE
#              LET l_oao06_3 = l_oao06,' '
#           END IF
#        END FOREACH
#
#     SELECT azi04 INTO l_azi04 FROM azi_file
#      WHERE azi01=sr1.oqt09
#
#     EXECUTE insert1 USING sr1.oqt12,sr1.oqt01,sr1.oqt03,sr1.oqt04,sr1.oqt041,sr1.oqt051,
#                           sr1.oqt052,sr1.oqt053,sr1.oqt054,sr1.oqt13,sr1.oqt141,
#                           sr1.oqt142,sr1.oqt143,sr1.oqt151,sr1.oqt152,sr1.oqt161,
#                           sr1.oqt162,sr1.oqt171,sr1.oqt172,sr1.oqt173,sr1.oqt181,
#                           sr1.oqt182,sr1.oqt191,sr1.oqt192,sr1.oqt10,sr1.oqt08,sr1.oqt11,
#                           sr1.oqt09,sr1.oqt20,sr1.oqt02,l_oao06_1,l_oao06_3,l_azi04,l_occ55,l_zo02   #FUN-720024 add occ55/zo02
#   END FOREACH
#
#  #No.FUN-710090--begin--
#  #FINISH REPORT r360_rep
#  ##No.FUN-590110--end
#
#   LET g_sql="SELECT A.*,B.obk03,B.oqu02,B.oqu03,B.oqu031,B.oqu032,B.oqu06,B.oqu05,",
#             "       B.oqu07,B.oqu09,B.oqu10,B.oqu11,B.oqu13,B.oao06_2,",
#             "       C.oqx01,C.oqx03,C.oqx04,C.oaj02,C.oqx041_1,C.oqx05_1,C.oqx06,",
#             "       D.oqx041_2,D.oqx05_2",  
# #TQC-730088#"  FROM ",l_table1 CLIPPED," A, ",l_table2 CLIPPED," B, ",
#            #          l_table3 CLIPPED," C, ",l_table4 CLIPPED," D",
#             "  FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED," A, ",g_cr_db_str CLIPPED,l_table2 CLIPPED," B, ",
#                       g_cr_db_str CLIPPED,l_table3 CLIPPED," C, ",g_cr_db_str CLIPPED,l_table4 CLIPPED," D", 
#             " WHERE A.oqt01=B.oqu01 ",
#             "   AND A.oqt01=C.oqx01(+) ",
#             "   AND A.oqt01=D.oqx01(+) "
#    LET g_sql = g_sql,"|","SELECT * from ",g_cr_db_str CLIPPED,l_table5 CLIPPED  #MOD-790032
#
#    IF g_zz05='Y' THEN
#       LET l_lang_t = g_lang  #TQC-750114
#       LET g_lang = l_occ55   #TQC-750114
#       CALL cl_wcchp(tm.wc,'oqt01,oqt02,oqt03,oqt04,oqt06,oqt07')
#        RETURNING tm.wc
#       LET g_lang = l_lang_t  #TQC-750114
#    END IF
#
#    LET g_str = tm.wc
#    IF NOT cl_null(tm.d) THEN
#       LET g_str = g_str,';',tm.d
#    END IF 
#  # CALL cl_prt_cs3('axmr360',g_sql,g_str)
#    CALL cl_prt_cs3('axmr360','axmr360',g_sql,g_str)
#  #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#  #No.FUN-710090--end--
#
#END FUNCTION
#}
##FUN-7C0073---mark---end---
 
##No.FUN-710090--begin--
#REPORT r360_rep(sr1,sr2,l_oqt01_t)
#   DEFINE l_obk03    LIKE obk_file.obk03     #FUN-690032
#   DEFINE l_last_sw  LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
#          l_sw       LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
#          l_sr       LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
#          l_ss       LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)                            #
#          l_n,i      LIKE type_file.num5,          #No.FUN-680137 SMALLINT
#          l_imc04    ARRAY[30] OF LIKE cob_file.cob08,        #No.FUN-680137 VARCHAR(30)
#          sr1        RECORD
#                        oqt12     LIKE    oqt_file.oqt12,   #
#                        oqt01     LIKE    oqt_file.oqt01,   #Quote.No
#                        oqt03     LIKE    oqt_file.oqt03,   #Your Ref
#                        oqt04    LIKE     oqt_file.oqt04,   # #FUN-690032 add
#                        oqt041    LIKE    oqt_file.oqt041,  #
#                        oqt051    LIKE    oqt_file.oqt051,  #
#                        oqt052    LIKE    oqt_file.oqt052,  #
#                        oqt053    LIKE    oqt_file.oqt053,  #
#                        oqt054    LIKE    oqt_file.oqt054,  #
#                        oqt13     LIKE    oqt_file.oqt13,   #
#                        oqt141    LIKE    oqt_file.oqt141,  #
#                        oqt142    LIKE    oqt_file.oqt142,  #
#                        oqt143    LIKE    oqt_file.oqt143,  #
#                        oqt151    LIKE    oqt_file.oqt151,  #PAYMENT
#                        oqt152    LIKE    oqt_file.oqt152,  #
#                        oqt161    LIKE    oqt_file.oqt161,  #SHIPMENT
#                        oqt162    LIKE    oqt_file.oqt162,  #
#                        oqt171    LIKE    oqt_file.oqt171,  #PACKING
#                        oqt172    LIKE    oqt_file.oqt172,  #
#                        oqt173    LIKE    oqt_file.oqt173,  #
#                        oqt181    LIKE    oqt_file.oqt181,  #INSURANCE
#                        oqt182    LIKE    oqt_file.oqt182,  #
#                        oqt191    LIKE    oqt_file.oqt191,  #VALIDITY
#                        oqt192    LIKE    oqt_file.oqt192,  #
#                        oqt10     LIKE    oqt_file.oqt10,   #
#                        oqt08     LIKE    oqt_file.oqt08,   #
#                        oqt11     LIKE    oqt_file.oqt11,   #
#                        oqt09     LIKE    oqt_file.oqt09,   #
#                        oqt20     LIKE    oqt_file.oqt20    #
#                     END RECORD,
#          sr2        RECORD
#                        oqu02     LIKE    oqu_file.oqu02,   #
#                        oqu03     LIKE    oqu_file.oqu03,   #
#                        oqu031    LIKE    oqu_file.oqu031,  #
#                        oqu032    LIKE    oqu_file.oqu032,  #
#                        oqu06     LIKE    oqu_file.oqu06,   #
#                        oqu05     LIKE    oqu_file.oqu05,   #
#                        oqu07     LIKE    oqu_file.oqu07,   #
#                        oqu09     LIKE    oqu_file.oqu09,   #
#                        oqu10     LIKE    oqu_file.oqu10,   #
#                        oqu11     LIKE    oqu_file.oqu11,   #
#                        oqu13     LIKE    oqu_file.oqu13    #
#                     END RECORD,
#          sr3        RECORD
#                        oqx03     LIKE    oqx_file.oqx03,   #
#                        oqx04     LIKE    oqx_file.oqx04,   #
#                        oaj02     LIKE    oaj_file.oaj02,   #
#                        oqx041    LIKE    oqx_file.oqx041,  #
#                        oqx05     LIKE    oqx_file.oqx05,   #
#                        oqx06     LIKE    oqx_file.oqx06    #
#                     END RECORD,
#          sr4        RECORD
#                        oqx041    LIKE    oqx_file.oqx041,  #
#                        oqx05     LIKE    oqx_file.oqx05    #
#                     END RECORD,
#          l_oao03    LIKE    oao_file.oao03,             #
#          l_oao05    LIKE    oao_file.oao05,             #
#          l_oao04    LIKE    oao_file.oao04,             #
#          l_oao06    LIKE    oao_file.oao06,             #
#          l_oqx03_1  LIKE    oqx_file.oqx03,             #
#          l_oqx03_2  LIKE    oqx_file.oqx03,             #
#          l_oqt01_t  LIKE    oqt_file.oqt01,
#          #No.FUN-590110--start
#          l_oqv      DYNAMIC ARRAY OF RECORD
#                        oqv03     LIKE    oqv_file.oqv03,   #
#                        oqv04     LIKE    oqv_file.oqv04,   #
#                        oqv05     LIKE    oqv_file.oqv05    #
#                     END RECORD
#          #No.FUN-590110--end
#
#   OUTPUT
#      TOP MARGIN 0
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN 3
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr1.oqt01,sr2.oqu02
#
#   FORMAT
#      PAGE HEADER
#         SELECT azi04 INTO t_azi04
#           FROM azi_file
#          WHERE azi01 = sr1.oqt09   #No.MOD-5C0062
#
#         IF g_start='Y' THEN
#            LET g_pageno = g_pageno + 1
#            SKIP 2 LINE
#            #No.FUN-590110--start
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1 ,g_x[1] CLIPPED   #No.TQC-6A0091
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]) CLIPPED)/2)+1 ,g_x[16] CLIPPED   #No.TQC-6A0091
#            PRINT ''
#            PRINT '' #FUN-690032 add
#            PRINT ''
#         ELSE
#            LET g_pageno = g_pageno + 1
#            PRINT g_x[3] CLIPPED,sr1.oqt01 CLIPPED,
#                  COLUMN (g_len-FGL_WIDTH(g_x[2])-12),
#                          g_x[2] CLIPPED,g_today USING 'MM/DD/YYYY'
#           #PRINT g_dash3[1,g_len] #FUN-5A0069 mark
#            PRINT g_dash2[1,g_len] #FUN-5A0069
##           PRINT g_x[11],COLUMN 56,g_x[12] CLIPPED,
##                         COLUMN 69,g_x[19] CLIPPED,
##                         COLUMN 85,g_x[13] CLIPPED
#           #FUN-5A0181 mark
#           #PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38] #FUN-5A0143 mark
#           #FUN-5A0181 add
#            PRINTX name=H1 g_x[30]
#            PRINTX name=H2 g_x[31]
#           #FUN-690032--begin
#             PRINTX name=H3 g_x[39]  #FUN-690032
#            #PRINTX name=H3 g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38] #FUN-5A0143 mark
#             PRINTX name=H4 g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38] #FUN-5A0143 mark
#           #FUN-690032--end 
#           #FUN-5A0181 end
#            PRINT g_dash1
#            #No.FUN-590110--end
#         END IF
#         LET l_last_sw = 'n'         ## FUN-550114
#
#      BEFORE GROUP OF sr1.oqt01
#         SKIP TO TOP OF PAGE               ##FUN-550114
#         IF g_start='Y' THEN
#            PRINT g_x[5] CLIPPED,sr1.oqt041 CLIPPED,
#                  COLUMN (g_len-FGL_WIDTH(g_x[2])-20),
#                          g_x[2] CLIPPED,g_today USING 'MM/DD/YYYY'
#            PRINT COLUMN 4,sr1.oqt051 CLIPPED,
#                  COLUMN (g_len-FGL_WIDTH(g_x[3])-20),g_x[3] CLIPPED,sr1.oqt01
#            PRINT COLUMN 4,sr1.oqt052
#            PRINT COLUMN 4,sr1.oqt053 CLIPPED,
#                  COLUMN (g_len-FGL_WIDTH(g_x[4])-20),g_x[4] CLIPPED,sr1.oqt03
#            PRINT COLUMN 4,sr1.oqt054
#            PRINT
#            PRINT sr1.oqt13
#            PRINT
#            IF NOT cl_null(sr1.oqt141) THEN PRINT sr1.oqt141 END IF
#            IF NOT cl_null(sr1.oqt142) THEN PRINT sr1.oqt142 END IF
#            IF NOT cl_null(sr1.oqt143) THEN PRINT sr1.oqt143 END IF
#
#            IF NOT cl_null(sr1.oqt141) OR  NOT cl_null(sr1.oqt142) OR
#               NOT cl_null(sr1.oqt143) THEN
#               PRINT
#            END IF
# 
#            IF NOT cl_null(sr1.oqt151) THEN
#               PRINT g_x[6] CLIPPED,sr1.oqt151
#               PRINT COLUMN 11,sr1.oqt152
#            END IF
#
#            IF NOT cl_null(sr1.oqt161) THEN
#               PRINT g_x[7] CLIPPED,sr1.oqt161
#               PRINT COLUMN 11,sr1.oqt162
#            END IF
#
#            IF NOT cl_null(sr1.oqt171) THEN
#               PRINT g_x[8] CLIPPED,sr1.oqt171
#               PRINT COLUMN 11,sr1.oqt172
#               PRINT COLUMN 11,sr1.oqt173
#            END IF
#
#            IF NOT cl_null(sr1.oqt181) THEN
#               PRINT g_x[9] CLIPPED,sr1.oqt181
#               PRINT COLUMN 11,sr1.oqt182
#            END IF
#
#            IF NOT cl_null(sr1.oqt191) THEN
#               PRINT g_x[10] CLIPPED,sr1.oqt191
#               PRINT COLUMN 11,sr1.oqt192
#            END IF
# 
#            #check備註是否列印--> oao_file
#            SELECT COUNT(*) INTO l_n FROM oao_file
#             WHERE oao01 = sr1.oqt01
#               AND oao03 = 0
#               AND oao05 = '1'
#            IF l_n > 0  THEN
#               LET l_oao03 = 0
#               LET l_oao05 = '1'
#               FOREACH r360_c3 USING sr1.oqt01,l_oao03,l_oao05
#                                INTO l_oao04,l_oao06
#                  IF SQLCA.sqlcode THEN
#                     EXIT FOREACH
#                  END IF
#                  IF cl_null(l_oao06) THEN
#                     CONTINUE FOREACH
#                  ELSE
#                     PRINT l_oao06
#                  END IF
#               END FOREACH
#            END IF
# 
#            #check費用是否列印--> oqx_file
#            SELECT COUNT(*) INTO l_n FROM oqx_file
#             WHERE oqx01 = sr1.oqt01
#               AND oqx03 = 0
#            IF l_n > 0 THEN
#               LET l_oqx03_1=0
#               FOREACH r360_c6 USING sr1.oqt01,l_oqx03_1,l_oqx03_1 INTO sr3.*
#                  IF SQLCA.sqlcode THEN
#                     EXIT FOREACH
#                  END IF
#                  IF cl_null(sr3.oqx05) OR sr3.oqx05 = 0 THEN
#                     CONTINUE FOREACH
#                  ELSE
#                     PRINT sr3.oaj02,':',sr3.oqx041,' ',
#                           cl_numfor(sr3.oqx05,18,t_azi04),' ',
#                           sr3.oqx06
#                  END IF
#               END FOREACH
#            END IF
#         END IF
#
#        #表頭列印
#         NEED 3 LINES
#         #NO.FUN-590110--start
#        #PRINT g_dash3[1,g_len] #FUN-5A0143 mark
#         PRINT g_dash2[1,g_len]  #FUN-5A0143 add
##        PRINT g_x[11],COLUMN 56,g_x[12] CLIPPED,
##                      COLUMN 75,g_x[19] CLIPPED,
##                      COLUMN 95,g_x[13] CLIPPED
#        #PRINTX name=H1 g_x[30],g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38] #FUN-5A0143 mark
#         #FUN-5A0143 add
#         PRINTX name=H1 g_x[30]
#         PRINTX name=H2 g_x[31]
#       #FUN-660032 --begin
#         PRINTX name=H3 g_x[39]
#        #PRINTX name=H3 g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
#         PRINTX name=H4 g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
#       #FUN-660032 --end
#         #FUN-5A0143 end
# 
#         PRINT g_dash1
# 
#         PRINT COLUMN ((g_len-FGL_WIDTH(sr1.oqt10)-
#               length(sr1.oqt08)-FGL_WIDTH(sr1.oqt11)-6)+1) ,
#               sr1.oqt10 CLIPPED,'  ',sr1.oqt08 CLIPPED,'  (',sr1.oqt11 CLIPPED,')'
#         LET l_n=g_len-FGL_WIDTH(sr1.oqt10)-FGL_WIDTH(sr1.oqt08)-FGL_WIDTH(sr1.oqt11)-6
#         PRINT COLUMN (l_n+1),g_dash2[l_n+1,g_len]
#         #No.FUN-590110--end
#
#      ON EVERY ROW
#         # check備註是否列印--> oao_file
#         SELECT COUNT(*) INTO l_n FROM oao_file
#          WHERE oao01 = sr1.oqt01
#            AND oao03 = sr2.oqu02
#            AND oao05 = '1'
#         IF l_n > 0  THEN
#            LET l_oao03=sr2.oqu02
#            LET l_oao05='1'
#            FOREACH r360_c3 USING sr1.oqt01,l_oao03,l_oao05 INTO l_oao04,l_oao06
#               IF SQLCA.sqlcode THEN
#                  EXIT FOREACH
#               END IF
#               IF cl_null(l_oao06) THEN
#                  CONTINUE FOREACH
#               ELSE
#                  PRINT l_oao06
#               END IF
#            END FOREACH
#         END IF
#         #No.FUN-590110--start
#         FOR i = 1 TO 30 INITIALIZE l_imc04[i] TO NULL END FOR  #清空
#         FOR i = 1 TO 100 INITIALIZE l_oqv[i].* TO NULL END FOR  #清空
#         #No.FUN-590110--end
#
#         IF NOT cl_null(tm.a) AND sr2.oqu03[1,4] !='MISC'  THEN  #讀取額外品名規格
#            LET i=1
#            FOREACH r360_c4
#            USING sr2.oqu03,tm.a
#            INTO l_imc04[i]
#              IF SQLCA.sqlcode THEN EXIT FOREACH END IF
#              LET i = i +1
#            END FOREACH
#         END IF
#         #No.FUN-590110--start
#         LET i = 1
#         FOREACH r360_c5 USING sr1.oqt01,sr2.oqu02 INTO l_oqv[i].*
#            IF SQLCA.sqlcode THEN
#               EXIT FOREACH
#            END IF
#            LET i = i +1
#         END FOREACH
#        #PRINTX name=D1 COLUMN g_c[30],sr2.oqu03; #FUN-5A0143 mark
#         PRINTX name=D1 COLUMN g_c[30],sr2.oqu03   #FUN-5A0143 add
#       
#
#         IF g_type='N' THEN
#           #FUN-5A0069...............mark begin 將這一整段,改成下面那段
#           #FOR i = 1 TO 30
#           #   IF i > 3 AND l_imc04[i] IS NULL THEN
#           #      EXIT FOR
#           #   END IF
#           #   IF cl_null(sr2.oqu03) THEN  #MOD-530340
#           #      EXIT FOR
#           #   END IF
#           #   IF cl_null(l_imc04[i]) THEN
#           #      CASE i
#           #           WHEN 1    LET l_imc04[i]=sr2.oqu031
#           #           WHEN 2    LET l_imc04[i]=sr2.oqu032
#           #           OTHERWISE LET l_imc04[i]=''
#           #      END CASE
#           #   END IF
# 
#           #   CASE i
#           #      WHEN 1
#           #         #PRINTX name=D1 COLUMN g_c[31],l_imc04[i], #FUN-5A0143 mark
#           #         PRINTX name=D2 COLUMN g_c[31],l_imc04[i]   #FUN-5A0143 add
#           #              # COLUMN g_c[32],cl_numfor(sr2.oqu06,32,t_azi04),   #No.MOD-480369 #FUN-5A0143 mark
#           #         PRINTX name=D3 COLUMN g_c[32],cl_numfor(sr2.oqu06,32,t_azi04),   #No.MOD-480369 #FUN-5A0143 add
#           #                        COLUMN g_c[33],sr2.oqu05,
#           #                        COLUMN g_c[34],sr1.oqt09,
#           #                        COLUMN g_c[35],cl_numfor(sr2.oqu07,35,t_azi04),
#           #                        COLUMN g_c[36],cl_numfor(sr2.oqu09,36,t_azi04),
#           #                        COLUMN g_c[37],sr2.oqu10
#           #      WHEN 2
#           #         #FUN-5A0143 mark
#           #         #PRINTX name=D1 COLUMN g_c[31],l_imc04[i],           #No.MOD-480369
#           #         #     COLUMN g_c[38],sr2.oqu11 USING '###.###',"'/",
#           #         #                    sr2.oqu13 USING '####.###','KG'
#           #         #FUN-5A0143 add
#           #         PRINTX name=D2 COLUMN g_c[31],l_imc04[i]
#           #         PRINTX name=D3 COLUMN g_c[38],sr2.oqu11 USING '###.###',"'/",
#           #                                       sr2.oqu13 USING '####.###','KG'
#           #         #FUN-5A0143 end
#           #      OTHERWISE
#           #         #PRINTX name=D1 COLUMN g_c[31],l_imc04[i] #FUN-5A0143 mark
#           #         PRINTX name=D2 COLUMN g_c[31],l_imc04[i]  #FUN-5A0143 add
#           #   END CASE
#           #END FOR
#           #FUN-5A0069...............mark end
#
#           #FUN-5A0069...............begin #將上面的程式碼濃縮改寫
#           IF NOT cl_null(sr2.oqu03) THEN
#              IF NOT cl_null(sr2.oqu031) THEN
#                 PRINTX name=D2 COLUMN g_c[31],sr2.oqu031
#              END IF
#              IF NOT cl_null(sr2.oqu032) THEN
#                 PRINTX name=D2 COLUMN g_c[31],sr2.oqu032
#              END IF
#
#             #FUN-690032 add--begin
#               LET l_obk03 = ''
#               SELECT obk03 INTO l_obk03 FROM obk_file
#                WHERE obk01 = sr2.oqu03
#                  AND obk02 = sr1.oqt04
#               IF SQLCA.sqlcode THEN
#                 LET l_obk03 = ''
#               END IF
#               PRINTX name=D3 COLUMN g_c[39],l_obk03
#             #FUN-690032 add--end
#
#             #FUN-690032 name=D3->name=D4
#              #PRINTX name=D3 COLUMN g_c[32],cl_numfor(sr2.oqu06,32,t_azi04),
#              PRINTX name=D4 COLUMN g_c[32],cl_numfor(sr2.oqu06,32,t_azi04),
#                             COLUMN g_c[33],sr2.oqu05,
#                             COLUMN g_c[34],sr1.oqt09,
#                             COLUMN g_c[35],cl_numfor(sr2.oqu07,35,t_azi04),
#                             COLUMN g_c[36],cl_numfor(sr2.oqu09,36,t_azi04),
#                             COLUMN g_c[37],sr2.oqu10,
#                             COLUMN g_c[38],sr2.oqu11 USING '###.###',"'/",
#                                            sr2.oqu13 USING '####.###','KG'
#           END IF
#           #FUN-5A0069...............end
#         END IF
#         IF g_type='Y' THEN
#            FOR i = 1 TO 100
#               IF i <=30 THEN
#                  IF l_imc04[i] IS NULL AND l_oqv[i].oqv03 IS NULL THEN
#                     EXIT FOR
#                  END IF
#               ELSE
#                  IF l_oqv[i].oqv03 IS NULL THEN
#                     EXIT FOR
#                  END IF
#               END IF
# 
#               IF i <= 30 AND cl_null(l_imc04[i]) THEN
#                  CASE i
#                       WHEN 1    LET l_imc04[i]=sr2.oqu031
#                       WHEN 2    LET l_imc04[i]=sr2.oqu032
#                       OTHERWISE LET l_imc04[i]=''
#                  END CASE
#               END IF
#
#              #FUN-5A0143 mark
#              #IF i <=30 THEN PRINTX name=D1 COLUMN g_c[31],l_imc04[i]; END IF
#              #IF l_oqv[i].oqv03 IS NOT NULL THEN
#              #   PRINTX name=D1 COLUMN g_c[32],l_oqv[i].oqv03 USING '#####','-',
#              #                        l_oqv[i].oqv04 USING '#####';
#              #   IF i = 1 THEN PRINTX name=D1 COLUMN g_c[33],sr2.oqu05,
#              #                       COLUMN g_c[34],sr1.oqt09;  END IF
#              #   PRINTX name=D1 COLUMN g_c[35],cl_numfor(l_oqv[i].oqv05,35,t_azi04)
#              #ELSE
#              #   PRINT ''
#              #END IF}
#              #FUN-5A0143 add
#               IF i <=30 THEN PRINTX name=D2 COLUMN g_c[31],l_imc04[i] END IF
#               IF l_oqv[i].oqv03 IS NOT NULL THEN
#                 #FUN-690032 add--begin
#                   LET l_obk03 = ''
#                   SELECT obk03 INTO l_obk03 FROM obk_file
#                    WHERE obk01 = sr2.oqu03
#                      AND obk02 = sr1.oqt04
#                   IF SQLCA.sqlcode THEN
#                     LET l_obk03 = ''
#                   END IF
#                   PRINTX name=D3 COLUMN g_c[39],l_obk03
#                 #FUN-690032 add--end
#                  #FUN-690032 name=D3->name=D4
#                  #PRINTX name=D3 COLUMN g_c[32],l_oqv[i].oqv03 USING '#####','-',
#                  PRINTX name=D4 COLUMN g_c[32],l_oqv[i].oqv03 USING '#####','-',
#                                        l_oqv[i].oqv04 USING '#####';
#                  IF i = 1 THEN
#                     #FUN-690032 name=D3->name=D4
#                     #PRINTX name=D3 COLUMN g_c[33],sr2.oqu05,
#                     PRINTX name=D4 COLUMN g_c[33],sr2.oqu05,
#                                    COLUMN g_c[34],sr1.oqt09;
#                  END IF
#                  #FUN-690032 name=D3->name=D4
#                  #PRINTX name=D3 COLUMN g_c[35],cl_numfor(l_oqv[i].oqv05,35,t_azi04)
#                  PRINTX name=D4 COLUMN g_c[35],cl_numfor(l_oqv[i].oqv05,35,t_azi04)
#               ELSE
#                  PRINT ''
#               END IF
#               #FUN-5A0143 end
#           END FOR
#         END IF
#         #No.FUN-590110--end
#
#
#         # check備註是否列印--> oao_file
#         SELECT COUNT(*) INTO l_n FROM oao_file
#          WHERE oao01 = sr1.oqt01
#            AND oao03 = sr2.oqu02
#            AND oao05 = '2'
#         IF l_n > 0 THEN
#            LET l_oao03=sr2.oqu02
#            LET l_oao05='2'
#            FOREACH r360_c3 USING sr1.oqt01,l_oao03,l_oao05 INTO l_oao04,l_oao06
#               IF SQLCA.sqlcode THEN
#                  EXIT FOREACH
#               END IF
#               IF cl_null(l_oao06) THEN
#                  CONTINUE FOREACH
#               ELSE
#                  PRINT l_oao06
#               END IF
#            END FOREACH
#         END IF
#         LET g_start = 'N'
#
#      AFTER GROUP OF sr2.oqu02
#         PRINT
# 
#      AFTER GROUP OF sr1.oqt01
#         NEED 9 LINES
#         #PRINT g_dash3[1,g_len]                    #No.FUN-590110
#         PRINT g_dash2[1,g_len]                    #No.FUN-590110
#         PRINT g_x[15] CLIPPED;
#       # check備註是否列印
#         LET l_oao03=0
#         LET l_oao05='2'
#         LET l_n=0
#         FOREACH r360_c3 USING sr1.oqt01,l_oao03,l_oao05 INTO l_oao04,l_oao06
#            IF SQLCA.sqlcode THEN
#               EXIT FOREACH
#            END IF
#            IF cl_null(l_oao06) THEN
#               EXIT FOREACH
#            ELSE
#               PRINT COLUMN 9,l_oao06
#               LET l_n=l_n + 1
#            END IF
#         END FOREACH
#         IF l_n = 0 THEN
#            PRINT ''
#            PRINT
#         ELSE
#            PRINT
#         END IF
#       # check費用是否列印--> oqx_file
#         LET l_oqx03_1=1
#         LET l_oqx03_2=100
#         LET l_n=0
#         FOREACH r360_c6 USING sr1.oqt01,l_oqx03_1,l_oqx03_2 INTO sr3.*
#            IF SQLCA.sqlcode THEN
#               EXIT FOREACH
#            END IF
#            IF cl_null(sr3.oqx05) OR sr3.oqx05 = 0 THEN
#               CONTINUE FOREACH
#            ELSE
#               PRINT sr3.oaj02,COLUMN 11,':',sr3.oqx041,' ',
#                     COLUMN 16,cl_numfor(sr3.oqx05,18,t_azi04),' ',
#                     sr3.oqx06
#               LET l_n=l_n + 1
#            END IF
#         END FOREACH
# 
#       # check費用合計是否列印--> oqx_file
#         IF l_n > 0 THEN
#            PRINT "----------------------------------"
#            PRINT 'TOTAL     ';
#         END IF
#         LET l_oqx03_1=1
#         LET l_oqx03_2=100
#         LET l_n=0
#         FOREACH r360_c7 USING sr1.oqt01,l_oqx03_1,l_oqx03_2 INTO sr4.*
#            IF SQLCA.sqlcode THEN
#               EXIT FOREACH
#            END IF
#            IF cl_null(sr4.oqx05) OR sr4.oqx05 = 0 THEN
#               CONTINUE FOREACH
#            ELSE
#               PRINT COLUMN 11,':',sr4.oqx041,' ',cl_numfor(sr4.oqx05,18,t_azi04)
#            END IF
#         END FOREACH
# 
#         SKIP 5 LINES
#         PRINT (g_len-FGL_WIDTH(g_x[14])) SPACES,g_x[14]
#         PRINT (g_len-FGL_WIDTH(g_x[14])) SPACES,sr1.oqt20
#         LET g_start = 'Y'
#         ## FUN-550114
#         # SKIP TO TOP OF PAGE
#
#      ON LAST ROW
#         LET l_last_sw = 'y'
# 
#      PAGE TRAILER
#         PRINT
#         IF l_last_sw = 'n' THEN
#            IF g_memo_pagetrailer THEN
#               PRINT g_x[20]
#               PRINT g_memo
#            ELSE
#               PRINT
#               PRINT
#            END IF
#         ELSE
#            PRINT g_x[20]
#            PRINT g_memo
#         END IF
#      ## END FUN-550114
# 
#END REPORT
##Patch....NO.TQC-610037 <> #
##No.FUN-710090--end--
