# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmr552.4gl
# Descriptions...: Packing List
# Date & Author..: 96/08/13 by Rofer
# Modify.........: No.MOD-480366 04/09/17 Melody 品名列印未對齊
# Modify.........: No.FUN-4A0019 04/10/04 By Echo invoice單號要開窗
# Modify.........: No.FUN-4A0338 04/11/02 By Smapmin 以za_file取代PRINT中文字的部份
# Modify.........: No.FUN-530031 05/03/22 By Carol 單價/金額欄位所用的變數型態應為 dec(20,6),匯率 dec(20,10)
# Modify.........: No.FUN-550070 05/05/26 By day  單據編號加大
# Modify.........: No.FUN-550127 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-580013 05/08/15 By will 報表轉XML格式
# Modify.........: NO.MOD-590199 05/10/05 BY yiting 嘜頭報表列印程式，均無法正常列印出
# Modify.........: NO.FUN-5B0015 05/11/02 by Yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: NO.FUN-610072 06/01/20 By Sarah 加印公司TITLE
# Modify.........: NO.FUN-640135 06/04/11 By Sarah 增加列印的排序順序，可以依據料號或箱號來由小到大排序列印
# Modify.........: NO.MOD-640449 06/04/13 By Mandy 可列印CCCCCC ~ DDDDDD
# Modify.........: No.FUN-640177 06/04/20 By Sarah 若字軌輸入"X",則PACKING LIST印出來後不要把字軌印出
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-5A0087 06/05/26 By Sarah 增加條件"列印品名規格額外說明類別","列印客戶料號" 
# Modify.........: No.FUN-680137 06/09/05 By flowld 欄位型態定義,改為LIKE 
# Modify.........: No.TQC-690078 06/09/19 By kim 改SQL的寫法,FUN-640135不使用OUTER,因為會照成有重複的資料
# Modify.........: No.FUN-690126 06/10/18 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-690032 06/10/18 By 是否列印客戶料號（放在品名規格後面
# Modify.........: No.FUN-6A0094 06/11/06 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0041 06/12/11 By Ray 報表寬度不符,匯出excel沒分欄
# Modify.........: No.FUN-710080 07/03/06 By Sarah 報表改寫由Crystal Report產出
# Modify.........: No.FUN-740057 07/04/14 By Sarah 增加選項,列印公司對內(外)公司全名
# Modify.........: No.TQC-750123 07/05/24 By Sarah 嘜頭資料的起始箱號,截止箱號的內容無印出
# Modify.........: No.MOD-7A0045 07/10/17 By jamie 單身資料的筆數與印出時不符合，子報表改用新寫法
# Modify.........: No.MOD-7A0121 07/10/21 By jamie EXECUTE 塞入ogd_file資料時，資料型態不對 造成印不出
# Modify.........: No.FUN-810029 08/02/25 By Sarah 對外的憑證，皆需在頁首公司名稱下，增加顯示"公司地址zo041、公司電話zo05、公司傳真zo09"
# Modify.........: No.MOD-840388 08/04/28 By douzh 額外品名規格在tm.imc02為空時不列印
# Modify.........: No.FUN-840230 08/04/29 By douzh 調整列印多行額外品名規格邏輯
# Modify.........: No.FUN-7A0051 08/10/01 By jamie 列印品名規格額外說明類別 會有多筆 採用子報表寫法
# Modify.........: No.MOD-940004 09/04/02 By Dido 數量未取位
# Modify.........: No.MOD-970251 09/07/29 By mike 目前ogd_file的OUTER已被拿掉,判斷排序順序時應拿掉ogd_file的欄位ogd12b              
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0071 10/01/11 By huangrh 精簡程式
# Modify.........: No:TQC-A50044 10/05/17 By Carrier MOD-9B0033追单
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
# Modify.........: No:FUN-940044 11/11/06 By minpp 整合單據列印EF簽核 
# Modify.........: No.TQC-C10039 12/01/18 By wangrr 整合單據列印EF簽核
# Modify.........: No.TQC-C20051 12/02/14 By yuhuabao 套表無需簽核
# Modify.........: No.TQC-C20228 12/02/16 By yuhuabao 整合單據列印EF簽核(非套表)
# Modify.........: No:MOD-C50175 12/05/24 By Vampire 包裝單列印時起迄箱號改抓包裝單最小最大值

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm           RECORD                         # Print condition RECORD
                     wc      STRING,      # Where condition
                     imc02   LIKE imc_file.imc02,  # 品名規格額外說明類別   #FUN-5A0087 add
                     a       LIKE type_file.chr1,        # Prog. Version..: '5.30.06-13.03.12(01)     # 列印客戶料號           #FUN-5A0087 add
                     s       LIKE type_file.chr1,        # Prog. Version..: '5.30.06-13.03.12(01)     # 列印順序   #FUN-640135 add
                     b       LIKE type_file.chr1,        # 列印公司對內全名           #FUN-740057 add
                     c       LIKE type_file.chr1,        # 列印公司對外全名           #FUN-740057 add
                     more    LIKE type_file.chr1         # Prog. Version..: '5.30.06-13.03.12(01)     # Input more condition(Y/N)
                    END RECORD,
       l_oao06      LIKE oao_file.oao06,
       x            LIKE aba_file.aba00,     # No.FUN-680137 VARCHAR(5)
       y,z          LIKE type_file.chr1,     # No.FUN-680137 VARCHAR(1)
       tot_ctn	    LIKE type_file.num10,    # No.FUN-680137 INTEGER
       wk_i         LIKE type_file.num5,     # No.FUN-680137 SMALLINT
       wk_array     DYNAMIC ARRAY OF RECORD
                     ogd11      LIKE ogd_file.ogd11,
                     ogd12b     LIKE ogd_file.ogd12b,
                     ogd12e     LIKE ogd_file.ogd12e
          	    END        RECORD,
       g_po_no,g_ctn_no1,g_ctn_no2     LIKE type_file.chr20,       # No.FUN-680137 VARCHAR(20)
       g_azi02	    LIKE type_file.chr20,      # No.FUN-680137 VARCHAR(20)
       g_zo12	    LIKE type_file.chr1000,    # No.FUN-680137 VARCHAR(60)
       g_zo041      LIKE zo_file.zo041,        #FUN-810029 add
       g_zo05       LIKE zo_file.zo05,         #FUN-810029 add
       g_zo09       LIKE zo_file.zo09          #FUN-810029 add
 
DEFINE g_cnt        LIKE type_file.num10       #No.FUN-680137 INTEGER
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE i            LIKE type_file.num5        #No.FUN-680137 SMALLINT
DEFINE j            LIKE type_file.num5        #No.FUN-680137 SMALLINT
DEFINE l_table      STRING
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE l_table1     STRING
DEFINE l_table2     STRING
DEFINE l_table3     STRING
DEFINE l_table4     STRING      #No.FUN-840230
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.imc02= ARG_VAL(8)   #FUN-5A0087 add
   LET tm.a    = ARG_VAL(9)   #FUN-5A0087 add
   LET tm.s    = ARG_VAL(10)
   LET tm.b    = ARG_VAL(11)  #FUN-740057 add
   LET tm.c    = ARG_VAL(12)  #FUN-740057 add
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = 
       "ofa01.ofa_file.ofa01,    ofa02.ofa_file.ofa02,",
       "ofa03.ofa_file.ofa03,    ofa011.ofa_file.ofa011,",
       "ofa0351.ofa_file.ofa0351,ofa0352.ofa_file.ofa0352,",
       "ofa0353.ofa_file.ofa0353,ofa0354.ofa_file.ofa0354,",
       "ofa0355.ofa_file.ofa0355,ofa0451.ofa_file.ofa0451,",
       "ofa0452.ofa_file.ofa0452,ofa0453.ofa_file.ofa0453,",
       "ofa0454.ofa_file.ofa0454,ofa0455.ofa_file.ofa0455,",
       "ofa43.ofa_file.ofa43,    ofa47.ofa_file.ofa47,",
       "ofa48.ofa_file.ofa48,    ofa49.ofa_file.ofa49,",
       "ofa75.ofa_file.ofa75,    ofa76.ofa_file.ofa76,",
       "ofa77.ofa_file.ofa77,    oac02.oac_file.oac02,",
       "oac02_2.oac_file.oac02,  ofb04.ofb_file.ofb04,",                       
       "ofb06.ofb_file.ofb06,    ofb11.ofb_file.ofb11,",                       
       "ofb05.ofb_file.ofb05,    ofb33.ofb_file.ofb33,",                       
       "zo12.zo_file.zo12,       imc04.imc_file.imc04,",    #FUN-7A0051 取消mark   #No.FUN-840230
       "ocf101.ocf_file.ocf101,ocf102.ocf_file.ocf102,ocf103.ocf_file.ocf103,",
       "ocf104.ocf_file.ocf104,ocf105.ocf_file.ocf105,ocf106.ocf_file.ocf106,",
       "ocf107.ocf_file.ocf107,ocf108.ocf_file.ocf108,ocf109.ocf_file.ocf109,",
       "ocf110.ocf_file.ocf110,ocf111.ocf_file.ocf111,ocf112.ocf_file.ocf112,",
       "ocf201.ocf_file.ocf201,ocf202.ocf_file.ocf202,ocf203.ocf_file.ocf203,",
       "ocf204.ocf_file.ocf204,ocf205.ocf_file.ocf205,ocf206.ocf_file.ocf206,",
       "ocf207.ocf_file.ocf207,ocf208.ocf_file.ocf208,ocf209.ocf_file.ocf209,",
       "ocf210.ocf_file.ocf210,ocf211.ocf_file.ocf211,ocf212.ocf_file.ocf212,",
       "ofb03.ofb_file.ofb03,",   #MOD-7A0045 add
       "ogd11.ogd_file.ogd11,    ogd12b.ogd_file.ogd12b,",
       "ogd12e.ogd_file.ogd12e,  ogd10.ogd_file.ogd10,",
       "ogd09.ogd_file.ogd09,    ogd13.ogd_file.ogd13,",
       "ogd14.ogd_file.ogd14,    ogd14t.ogd_file.ogd14t,",
       "ogd15.ogd_file.ogd15,    ogd15t.ogd_file.ogd15t,",
       "ogd16.ogd_file.ogd16,    ogd16t.ogd_file.ogd16t,",
       "zo041.zo_file.zo041,zo05.zo_file.zo05,zo09.zo_file.zo09,",   #FUN-810029 add
       "gfe03.gfe_file.gfe03,",      #MOD-940004
#No.TQC-C20228 ----- release ----- begin
#TQC-C20051 ----- mark ----- begin
      "sign_type.type_file.chr1,",#簽核方式   #No.FUN-940044
      "sign_img.type_file.blob,", #簽核圖檔   #No.FUN-940044
      "sign_show.type_file.chr1,",  #是否顯示簽核資料(Y/N) #No.FUN-940044
      "sign_str.type_file.chr1000"  #TQC-C10039 sign_str 
#TQC-C20051 ----- mark ----- end
#No.TQC-C20228 ----- release ----- end
   LET l_table = cl_prt_temptable('axmr552',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = 
       "ofa01.ofa_file.ofa01,", 
       "sfa30p.sfa_file.sfa30,   sfa03.sfa_file.sfa03,",
       "ima02.ima_file.ima02,    sfa12.sfa_file.sfa12,",
       "sfa06.sfa_file.sfa06"
   LET l_table1 = cl_prt_temptable('axmr5521',g_sql) CLIPPED   # 產生Temp Table
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                   # Temp Table產生
 
   LET g_sql = 
       "oao01.oao_file.oao01,",
       "oao03.oao_file.oao03,",
       "oao04.oao_file.oao04,",
       "oao05.oao_file.oao05,",
       "oao06.oao_file.oao06"
   LET l_table2 = cl_prt_temptable('axmr5522',g_sql) CLIPPED   # 產生Temp Table
   IF l_table2 = -1 THEN EXIT PROGRAM END IF                   # Temp Table產生
 
   LET g_sql = 
       "ofa01.ofa_file.ofa01,",  #FUN-7A0051 add
       "imc01.imc_file.imc01,",
       "imc02.imc_file.imc02,",
       "imc03.imc_file.imc03,",  #FUN-7A0051 add
       "imc04.imc_file.imc04"
   LET l_table4 = cl_prt_temptable('axmr5524',g_sql) CLIPPED   # 產生Temp Table
   IF l_table4 = -1 THEN EXIT PROGRAM END IF                   # Temp Table產生
   #------------------------------ CR (1) ------------------------------#
 
   LET g_zo12 = NULL
   LET g_zo041 = NULL  LET g_zo05 = NULL  LET g_zo09 = NULL   #FUN-810029 add
   SELECT zo12,zo041,zo05,zo09 INTO g_zo12,g_zo041,g_zo05,g_zo09    #FUN-810029 add zo041,zo05,zo09
     FROM zo_file WHERE zo01='1'
   IF cl_null(g_zo12) THEN
      SELECT zo12 INTO g_zo12 FROM zo_file WHERE zo01='0'
   END IF
   IF cl_null(g_zo041) THEN
      SELECT zo041 INTO g_zo041 FROM zo_file WHERE zo01='0'
   END IF
   IF cl_null(g_zo05) THEN
      SELECT zo05 INTO g_zo05 FROM zo_file WHERE zo01='0'
   END IF
   IF cl_null(g_zo09) THEN
      SELECT zo09 INTO g_zo09 FROM zo_file WHERE zo01='0'
   END IF
 
   IF cl_null(tm.wc) THEN
      CALL axmr552_tm(0,0)             # Input print condition
   ELSE 
      CALL axmr552()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr552_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680137 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 8 LET p_col = 17
 
   OPEN WINDOW axmr552_w AT p_row,p_col WITH FORM "axm/42f/axmr552"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = 'N'      #FUN-5A0087 add
   LET tm.s    = '1'      #FUN-640135 add
   LET tm.b    = 'Y'      #FUN-740057 add
   LET tm.c    = 'Y'      #FUN-740057 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   CALL cl_opmsg('p')
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON ofa01,ofa02
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT CONSTRUCT
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ofa01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ofa"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ofa01
                    NEXT FIELD ofa01
            END CASE
 
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
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW axmr552_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
            
      END IF
 
      IF tm.wc=" 1=1" THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.imc02,tm.a,tm.s,tm.b,tm.c,tm.more WITHOUT DEFAULTS   #FUN-5A0087   #FUN-740057 add tm.b,tm.c
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD b
             IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN NEXT FIELD b END IF
    
         AFTER FIELD c
             IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN NEXT FIELD c END IF
 
         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW axmr552_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
            
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
                WHERE zz01='axmr552'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axmr552','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'" ,
                            " '",tm.imc02 CLIPPED,"'" ,            #FUN-5A0087 add
                            " '",tm.a CLIPPED,"'" ,                #FUN-5A0087 add
                            " '",tm.s CLIPPED,"'" ,                #FUN-640135 add
                            " '",tm.b CLIPPED,"'" ,                #FUN-740057 add
                            " '",tm.c CLIPPED,"'" ,                #FUN-740057 add
                            " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                            " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                            " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('axmr552',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW axmr552_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL axmr552()
      ERROR ""
   END WHILE
   CLOSE WINDOW axmr552_w
END FUNCTION
 
FUNCTION axmr552()
   DEFINE l_name     LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
          l_sql      STRING,
          l_ogd01    LIKE ogd_file.ogd01,          #No.FUN-550070
          l_za05     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          ofa        RECORD LIKE ofa_file.*,
          ofb        RECORD LIKE ofb_file.*,
          ogd        RECORD LIKE ogd_file.*,
          ocf        RECORD LIKE ocf_file.*,
          sr         RECORD
                     oea10	LIKE oea_file.oea10,
                     oah02	LIKE oah_file.oah02,
                     oag02	LIKE oag_file.oag02,
                     oac02	LIKE oac_file.oac02,
                     oac02_2	LIKE oac_file.oac02,
                     ogd12b	LIKE ogd_file.ogd12b,  #FUN-640135 add
                     order2 LIKE ofb_file.ofb04        #TQC-690078
                     END RECORD
   DEFINE sfa        RECORD LIKE sfa_file.*,
          l_ima02    LIKE ima_file.ima02,
          sfa30t     LIKE sfa_file.sfa30,
          sfa30p     LIKE sfa_file.sfa30,
          l_imc04    LIKE imc_file.imc04
   DEFINE imc        RECORD LIKE imc_file.*,
          l_imc01    LIKE imc_file.imc01,
          l_imc02    LIKE imc_file.imc02 
   DEFINE oao        RECORD LIKE oao_file.*     #MOD-7A0045 add
   DEFINE l_cnt      LIKE type_file.num5        #MOD-7A0045 add
   DEFINE l_gfe03    LIKE gfe_file.gfe03        #MOD-940004 
   ###No.FUN-940044--START###
    DEFINE            l_img_blob     LIKE type_file.blob #TQC-C20051 mark #TQC-C20228 release
#TQC-C10039--start--mark---     
#    DEFINE            l_ii           INTEGER
#    DEFINE            l_sql_1        LIKE type_file.chr1000
#    DEFINE            l_key          RECORD                  #主鍵
#                         v1          LIKE ofa_file.ofa01
#                                     END RECORD
#TQC-C10039--end--mark---
   ###No.FUN-940044--END###
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
 
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
   CALL cl_del_data(l_table4)                   #No.FUN-840230
  LOCATE l_img_blob IN MEMORY        #blob初始化 #No.FUN-940044 add #TQC-C20051 mark #TQC-C20228 release
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,             
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ? ,?,?,?,?)"  #FUN-810029 67?->70? #MOD-940004 add ?  #No.FUN-940044 add 3?#TQC-C10039 add 1? #TQC-C20051 del 4? #No.TQC-C20228 add 4?
   PREPARE insert_prep FROM g_sql                                              
   IF STATUS THEN                                                               
      CALL cl_err("insert_prep:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM                        
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,             
               " VALUES(?,?,?,?,?, ?)"
   PREPARE insert_prep1 FROM g_sql                                              
   IF STATUS THEN                                                               
      CALL cl_err("insert_prep1:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM                        
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,             
               " VALUES(?,?,?,?,?)"
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN 
      CALL cl_err("insert_prep2:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM 
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,             
               " VALUES(?,?,?,?,?)"   #FUN-7A0051 add 2?
   PREPARE insert_prep4 FROM g_sql
   IF STATUS THEN 
      CALL cl_err("insert_prep4:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM 
   END IF
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-710080 add
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ofauser', 'ofagrup')
 
   LET l_sql="SELECT ofa_file.*,ofb_file.*, ",
             "       ocf_file.*,oea10,oah02,oag02,a.oac02,b.oac02,'' ", #TQC-690078 ogd12b->''
             "  FROM ofa_file,ofb_file, ",
             "       OUTER ocf_file,   OUTER oea_file,",
             "       OUTER oah_file,   OUTER oag_file,",
             "       OUTER oac_file a, OUTER oac_file b ", 
             " WHERE ofa01=ofb01 ",
             "   AND ",tm.wc CLIPPED,
             "   AND ofaconf !='X' ", #01/08/06 mandy 不可為作廢的資料
             "   AND ofa_file.ofa04=ocf_file.ocf01 AND ofa_file.ofa44=ocf_file.ocf02",
             "   AND ofb_file.ofb31=oea_file.oea01 AND ofa_file.ofa31=oah_file.oah01 AND ofa_file.ofa32=oag_file.oag01",
             "   AND ofa_file.ofa41=a.oac01 AND ofa_file.ofa42=b.oac01 "
   IF tm.s = '1' THEN
      LET l_sql = l_sql , " ORDER BY ofa01,ofb04"
   ELSE
      LET l_sql = l_sql , " ORDER BY ofa01" #MOD-970251       
   END IF
 
   PREPARE axmr552_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   DECLARE axmr552_curs1 CURSOR FOR axmr552_prepare1
#TQC-C10039--start--mark---
    #FUN-940044--ADD--STR--
#  #單據key值
#   LET l_sql="SELECT ofa01,",
#            "  FROM ofa_file,ofb_file, ",
#            "       OUTER ocf_file,   OUTER oea_file,",
#            "       OUTER oah_file,   OUTER oag_file,",
#            "       OUTER oac_file a, OUTER oac_file b ",
#            " WHERE ofa_file.ofa01=ofb_file.ofb01 ",
#            "   AND ",tm.wc CLIPPED,
#            "   AND ofaconf !='X' ",
#            "   AND ofa_file.ofa04=ocf_file.ocf01 AND ofa_file.ofa44=ocf_file.ocf02",
#            "   AND ofb_file.ofb31=oea_file.oea01 AND ofa_file.ofa31=oah_file.oah01 AND ofa_file.ofa32=oag_file.oag01",
#            "   AND ofa_file.ofa41=a.oac01 AND ofa_file.ofa42=b.oac01 "
#  IF tm.s = '1' THEN
#     LET l_sql = l_sql , " ORDER BY ofa01,ofb04"
#  ELSE
#     LET l_sql = l_sql , " ORDER BY ofa01"
#  END IF

#  PREPARE axmr552_p1 FROM l_sql
#  IF SQLCA.sqlcode != 0 THEN
#     CALL cl_err('prepare:',SQLCA.sqlcode,1)
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time
#     EXIT PROGRAM
#  END IF
#  DECLARE axmr552_cs1 CURSOR FOR axmr552_p1
#  #FUN-940044--ADD--END--
#TQC-C10039--end--mark---
   FOREACH axmr552_curs1 INTO ofa.*, ofb.*, ocf.*, sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF ofa.ofa0352 IS NULL THEN
         LET ofa.ofa0352 = ofa.ofa0353 LET ofa.ofa0353 = ofa.ofa0354
         LET ofa.ofa0354 = ofa.ofa0355 LET ofa.ofa0355 = NULL
      END IF
      IF ofa.ofa0452 IS NULL THEN
         LET ofa.ofa0452 = ofa.ofa0453 LET ofa.ofa0453 = ofa.ofa0454
         LET ofa.ofa0454 = ofa.ofa0455 LET ofa.ofa0455 = NULL
      END IF
      LET sr.ogd12b=NULL
      SELECT ogd12b INTO sr.ogd12b FROM ogd_file WHERE ofb.ofb34=ogd01
                                                   AND ofb.ofb35=ogd03
      IF tm.s = '1' THEN
         LET sr.order2=ofb.ofb04
      ELSE
         LET sr.order2=sr.ogd12b
      END IF
 
      #品名規格額外說明
      IF NOT cl_null(tm.imc02) THEN                            #MOD-840388 
         SELECT imc04 INTO l_imc04 FROM imc_file
         WHERE imc01=ofb.ofb04 AND imc02=tm.imc02 AND imc03='1'
         DECLARE imc_c CURSOR FOR
            SELECT imc01,imc02,imc03,imc04   #FUN-7A0051 add imc03
              FROM imc_file 
             WHERE imc01=ofb.ofb04 AND imc02=tm.imc02
         FOREACH imc_c INTO imc.*                    #FUN-7A0051 mod
            EXECUTE insert_prep4 USING 
               ofa.ofa01,imc.*            #FUN-7A0051 mod
         END FOREACH
      ELSE
         LET l_imc04=NULL
      END IF
 
      #客戶料號
      IF ofb.ofb11 IS NULL THEN
         SELECT obk03 INTO ofb.ofb11 FROM obk_file
          WHERE obk01=ofb.ofb04 AND obk02=ofa.ofa03
      END IF
      CASE WHEN ofa.ofa71='1' #LET ofb.ofb11=NULL  #No.TQC-A50044
           WHEN ofa.ofa71='2' LET ofb.ofb04=ofb.ofb11 #LET ofb.ofb11=NULL  #No.TQC-A50044
      END CASE
 
      #客戶嘜頭檔
      #LET g_po_no=ofa.ofa10 LET g_ctn_no1=ofa.ofa45 LET g_ctn_no2=ofa.ofa46   #TQC-750123 add #MOD-C50175 mark
      #MOD-C50175 add start  -----
      LET g_po_no = ofa.ofa10
      SELECT MIN(ogd12b),MAX(ogd12e) INTO g_ctn_no1,g_ctn_no2 FROM ogd_file WHERE ogd01 = ofa.ofa011
      #MOD-C50175 add end    -----
      LET ocf.ocf101=ocf_c(ocf.ocf101) LET ocf.ocf201=ocf_c(ocf.ocf201)
      LET ocf.ocf102=ocf_c(ocf.ocf102) LET ocf.ocf202=ocf_c(ocf.ocf202)
      LET ocf.ocf103=ocf_c(ocf.ocf103) LET ocf.ocf203=ocf_c(ocf.ocf203)
      LET ocf.ocf104=ocf_c(ocf.ocf104) LET ocf.ocf204=ocf_c(ocf.ocf204)
      LET ocf.ocf105=ocf_c(ocf.ocf105) LET ocf.ocf205=ocf_c(ocf.ocf205)
      LET ocf.ocf106=ocf_c(ocf.ocf106) LET ocf.ocf206=ocf_c(ocf.ocf206)
      LET ocf.ocf107=ocf_c(ocf.ocf107) LET ocf.ocf207=ocf_c(ocf.ocf207)
      LET ocf.ocf108=ocf_c(ocf.ocf108) LET ocf.ocf208=ocf_c(ocf.ocf208)
      LET ocf.ocf109=ocf_c(ocf.ocf109) LET ocf.ocf209=ocf_c(ocf.ocf209)
      LET ocf.ocf110=ocf_c(ocf.ocf110) LET ocf.ocf210=ocf_c(ocf.ocf210)
      LET ocf.ocf111=ocf_c(ocf.ocf111) LET ocf.ocf211=ocf_c(ocf.ocf211)
      LET ocf.ocf112=ocf_c(ocf.ocf112) LET ocf.ocf212=ocf_c(ocf.ocf212)
 
      #CKD工單發料資訊
      IF ofb.ofb33 IS NOT NULL THEN
         DECLARE sfa_c CURSOR FOR
            SELECT sfa_file.*,ima02
              FROM sfa_file, OUTER ima_file
             WHERE sfa01=ofb.ofb33 AND sfa_file.sfa03=ima_file.ima01
             ORDER BY sfa30,sfa03
         LET sfa30t=NULL
         FOREACH sfa_c INTO sfa.*, l_ima02
            IF sfa.sfa30 = sfa30t THEN
               LET sfa30p=NULL
            ELSE 
               LET sfa30p=sfa.sfa30 LET sfa30t=sfa.sfa30
            END IF
            EXECUTE insert_prep1 USING 
               ofa.ofa01,sfa30p,sfa.sfa03,l_ima02,sfa.sfa12,sfa.sfa06
         END FOREACH
      END IF
 
      LET l_gfe03=0
      SELECT gfe03 INTO l_gfe03 FROM gfe_file
       WHERE gfe01 = ofb.ofb05
 
       SELECT COUNT(*) INTO l_cnt FROM ogd_file WHERE ogd01 = ofa.ofa011 AND ogd03 = ofb.ofb03
       IF l_cnt <>0 THEN   
          #包裝資料檔
          DECLARE ogd_cur CURSOR FOR
             SELECT * FROM ogd_file WHERE ogd01 = ofa.ofa011 AND ogd03 = ofb.ofb03
          FOREACH ogd_cur INTO ogd.*
             IF ogd.ogd04 = 1 THEN
          
               #列印單身備註
               DECLARE oao_c1 CURSOR FOR                                                 
                SELECT * FROM oao_file                                               
                 WHERE oao01=ofa.ofa01 AND oao03=ofb.ofb03 AND (oao05='1' OR oao05='2')
                 ORDER BY oao04                                                          
               FOREACH oao_c1 INTO oao.*                                               
                  IF NOT cl_null(oao.oao06) THEN
                     EXECUTE insert_prep2 USING 
                        ofa.ofa01,ofb.ofb03,oao.oao04,oao.oao05,oao.oao06                
                  END IF                                                                 
               END FOREACH                                                               
             END IF
          
             IF cl_null(ogd.ogd14)  THEN LET ogd.ogd14 = 0 END IF
             IF cl_null(ogd.ogd14t) THEN LET ogd.ogd14t= 0 END IF
             IF cl_null(ogd.ogd15)  THEN LET ogd.ogd15 = 0 END IF
             IF cl_null(ogd.ogd15t) THEN LET ogd.ogd15t= 0 END IF
             IF cl_null(ogd.ogd16)  THEN LET ogd.ogd16 = 0 END IF
             IF cl_null(ogd.ogd16t) THEN LET ogd.ogd16t= 0 END IF
   
             EXECUTE insert_prep USING                                                           
                ofa.ofa01   ,ofa.ofa02   ,ofa.ofa03   ,ofa.ofa011  ,ofa.ofa0351 ,
                ofa.ofa0352 ,ofa.ofa0353 ,ofa.ofa0354 ,ofa.ofa0355 ,ofa.ofa0451 ,
                ofa.ofa0452 ,ofa.ofa0453 ,ofa.ofa0454 ,ofa.ofa0455 ,ofa.ofa43   ,
                ofa.ofa47   ,ofa.ofa48   ,ofa.ofa49   ,ofa.ofa75   ,ofa.ofa76   ,
                ofa.ofa77   ,sr.oac02    ,sr.oac02_2  ,ofb.ofb04   ,ofb.ofb06   ,
                ofb.ofb11   ,ofb.ofb05   ,ofb.ofb33   ,g_zo12      ,l_imc04     ,  #FUN-7A0051 取消mark #No.FUN-840230
                ocf.ocf101  ,ocf.ocf102  ,ocf.ocf103  ,ocf.ocf104  ,ocf.ocf105  ,
                ocf.ocf106  ,ocf.ocf107  ,ocf.ocf108  ,ocf.ocf109  ,ocf.ocf110  ,
                ocf.ocf111  ,ocf.ocf112  ,ocf.ocf201  ,ocf.ocf202  ,ocf.ocf203  ,
                ocf.ocf204  ,ocf.ocf205  ,ocf.ocf206  ,ocf.ocf207  ,ocf.ocf208  ,
                ocf.ocf209  ,ocf.ocf210  ,ocf.ocf211  ,ocf.ocf212  ,ofb.ofb03 ,
                ogd.ogd11   ,ogd.ogd12b  ,ogd.ogd12e  ,ogd.ogd10   ,
                ogd.ogd09   ,ogd.ogd13   ,ogd.ogd14   ,ogd.ogd14t  ,ogd.ogd15,
                ogd.ogd15t  ,ogd.ogd16   ,ogd.ogd16t  ,
                g_zo041     ,g_zo05      ,g_zo09      ,l_gfe03      #FUN-810029 add #MOD-940004 add #TQC-C20051 del ,
                ,"",l_img_blob,"N",""   #No.FUN-940044 add #TQC-C10039 add ""  #TQC-C20051 mark #TQC-C20228 release
         END FOREACH   
       ELSE 
             EXECUTE insert_prep USING                                                           
                ofa.ofa01   ,ofa.ofa02   ,ofa.ofa03   ,ofa.ofa011  ,ofa.ofa0351 ,
                ofa.ofa0352 ,ofa.ofa0353 ,ofa.ofa0354 ,ofa.ofa0355 ,ofa.ofa0451 ,
                ofa.ofa0452 ,ofa.ofa0453 ,ofa.ofa0454 ,ofa.ofa0455 ,ofa.ofa43   ,
                ofa.ofa47   ,ofa.ofa48   ,ofa.ofa49   ,ofa.ofa75   ,ofa.ofa76   ,
                ofa.ofa77   ,sr.oac02    ,sr.oac02_2  ,ofb.ofb04   ,ofb.ofb06   ,
                ofb.ofb11   ,ofb.ofb05   ,ofb.ofb33   ,g_zo12      ,l_imc04     , #FUN-7A0051 取消mark #No.FUN-840230
                ocf.ocf101  ,ocf.ocf102  ,ocf.ocf103  ,ocf.ocf104  ,ocf.ocf105  ,
                ocf.ocf106  ,ocf.ocf107  ,ocf.ocf108  ,ocf.ocf109  ,ocf.ocf110  ,
                ocf.ocf111  ,ocf.ocf112  ,ocf.ocf201  ,ocf.ocf202  ,ocf.ocf203  ,
                ocf.ocf204  ,ocf.ocf205  ,ocf.ocf206  ,ocf.ocf207  ,ocf.ocf208  ,
                ocf.ocf209  ,ocf.ocf210  ,ocf.ocf211  ,ocf.ocf212  ,ofb.ofb03 ,
                '','0','0','0','0','0','0','0','0','0','0','0'    #MOD-7A0121 mod  
                ,g_zo041,g_zo05,g_zo09,l_gfe03   #FUN-810029 add #MOD-940004 add #TQC-C20051 del ,
                ,"",l_img_blob,"N",""  #No.FUN-940044 add #TQC-C10039 add "" #TQC-C20051 mark #TQC-C20228 release
       END IF 
   END FOREACH   
 
     #列印整張備註                                                          
     LET l_sql = "SELECT ofa01 FROM ofa_file ",
                 " WHERE ",tm.wc CLIPPED,      
                 "   ORDER BY ofa01"           
     PREPARE r552_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN      
        CALL cl_err('prepare2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM  
     END IF           
     DECLARE r552_cs2 CURSOR FOR r552_prepare2
                                                                                
     FOREACH r552_cs2 INTO ofa.ofa01
        #整張前備註
        DECLARE oao_c2 CURSOR FOR  
         SELECT * FROM oao_file
          WHERE oao01=ofa.ofa01 AND oao03=0 AND (oao05='1' OR oao05='2')
          ORDER BY oao04                                
        FOREACH oao_c2 INTO oao.* 
           IF NOT cl_null(oao.oao06) THEN
              EXECUTE insert_prep2 USING
                 ofa.ofa01,oao.oao03,oao.oao04,oao.oao05,oao.oao06
           END IF                                         
        END FOREACH
     END FOREACH    
 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|", 
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|", 
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " WHERE oao03 =0 AND oao05='1'","|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " WHERE oao03!=0 AND oao05='1'","|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " WHERE oao03!=0 AND oao05='2'","|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " WHERE oao03 =0 AND oao05='2'","|",                           #No.FUN-840230
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED          #No.FUN-840230
 
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ofa01,ofa02')
           RETURNING tm.wc
   ELSE
      LET tm.wc = ''
   END IF
   LET g_str = tm.a,";",tm.s,";",tm.wc,";",
               tm.b,";",tm.c,";",tm.imc02           #FUN-740057 add tm.b,tm.c   #FUN-840230 add tm.imc02
    #FUN-940044--ADD--STR--
    LET g_cr_table = l_table                 #主報表的temp table名稱 #TQC-C20051 mark #TQC-C20228 release
#    LET g_cr_gcx01 = "axmi010"            #單別維護程式  #TQC-C10039 mark--
    LET g_cr_apr_key_f = "ofa01"             #報表主鍵欄位名稱，用"|"隔開 #TQC-C20051 mark #TQC-C20228 release
#TQC-C10039--start--mark---
#    LET l_sql_1= " SELECT DISTINCT ofa01 FROM ", g_cr_db_str CLIPPED,l_table CLIPPED
#    PREPARE key_pr FROM l_sql_1
#    DECLARE key_cs CURSOR FOR key_pr
#    LET l_ii = 1
#    #報表主鍵值
#    CALL g_cr_apr_key.clear()                #清空
#    FOREACH key_cs INTO l_key.*
#       LET g_cr_apr_key[l_ii].v1 = l_key.v1
#       LET l_ii = l_ii + 1
#    END FOREACH
#TQC-C10039--end--mark---
   #FUN-940044--ADD--END--
   CALL cl_prt_cs3('axmr552','axmr552',g_sql,g_str)
   #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
 
FUNCTION ocf_c(str)
  DEFINE str    LIKE occ_file.occ02      # No.FUN-680137 VARCHAR(30)
        
  # 把麥頭內'PPPPPP'字串改為 P/O NO (ofa.ofa10)
  # 把麥頭內'CCCCCC'字串改為 CTN NO (ofa.ofa45)
  # 把麥頭內'DDDDDD'字串改為 CTN NO (ofa.ofa46)
  LET g_ctn_no1=g_ctn_no1 USING "######"
  LET g_ctn_no2=g_ctn_no2 USING "######"
  FOR i=1 TO 25
     IF str[i,i+5]='PPPPPP' THEN LET str[i,30]=g_po_no    END IF
     IF str[i,i+5]='CCCCCC' THEN LET str[i,i+5]=g_ctn_no1 END IF
     IF str[i,i+5]='DDDDDD' THEN LET str[i,i+5]=g_ctn_no2 END IF
  END FOR
  RETURN str
END FUNCTION
 
FUNCTION cnt_ogd10(wk_ogd11,wk_ogd12b,wk_ogd12e,wk_ogd10)
  DEFINE wk_ogd11   LIKE ogd_file.ogd11,
         wk_ogd12b  LIKE ogd_file.ogd12b,
         wk_ogd12e  LIKE ogd_file.ogd12e,
         wk_ogd10   LIKE ogd_file.ogd10,
         wk_j       LIKE type_file.num5,       # No.FUN-680137 SMALLINT
         sw_esit    LIKE type_file.chr1,       # No.FUN-680137 VARCHAR(1)
         l_ogd12b   LIKE type_file.chr20,      #No.FUN-690126
         l_ogd12e   LIKE type_file.chr20       #No.FUN-690126  
 
  IF wk_ogd11 IS NULL THEN
     LET wk_ogd11 = ' '
  END    IF
  IF l_ogd12b[1] NOT MATCHES '[A-z]' AND
     l_ogd12b[2] NOT MATCHES '[A-z]' AND
     l_ogd12b[3] NOT MATCHES '[A-z]' THEN
     LET wk_ogd12b  = l_ogd12b USING '&&&'
  END IF
  IF l_ogd12e[1] NOT MATCHES '[A-z]' AND
     l_ogd12e[2] NOT MATCHES '[A-z]' AND
     l_ogd12e[3] NOT MATCHES '[A-z]' THEN
     LET wk_ogd12e  = l_ogd12e USING '&&&'
  END IF
  LET sw_esit    = 'N'
  IF wk_i = 0 THEN
     LET wk_i = wk_i + 1
     LET wk_array[wk_i].ogd11  = wk_ogd11
     LET wk_array[wk_i].ogd12b = wk_ogd12b USING '&&&'
     LET wk_array[wk_i].ogd12e = wk_ogd12e USING '&&&'
     LET tot_ctn = tot_ctn + wk_ogd10
  ELSE
     FOR wk_j = 1 TO wk_i
        IF wk_ogd11 = wk_array[wk_j].ogd11 THEN
           IF (wk_ogd12b  >= wk_array[wk_j].ogd12b  AND
               wk_ogd12b  <= wk_array[wk_j].ogd12e) AND
              (wk_ogd12e  >= wk_array[wk_j].ogd12b  AND
               wk_ogd12e  <= wk_array[wk_j].ogd12e) THEN
               LET sw_esit = 'Y'
               EXIT FOR
           ELSE
               LET sw_esit = 'N'
           END  IF
        END IF
     END FOR
     IF sw_esit = 'N' THEN
        LET wk_i = wk_i + 1
        LET wk_array[wk_i].ogd11  = wk_ogd11
        LET wk_array[wk_i].ogd12b = wk_ogd12b USING '&&&'
        LET wk_array[wk_i].ogd12e = wk_ogd12e USING '&&&'
        LET tot_ctn = tot_ctn + wk_ogd10
     END IF
     LET sw_esit    = 'N'
  END IF
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
