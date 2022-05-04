# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: abmr800.4gl
# Descriptions...: 單階材料用量明細表
# Input parameter:
# Return code....:
# Date & Author..: 91/08/02 By Lee
# Modify.........: 92/03/27 By Nora
#                  Add 主件料號數量
# Modify.........: 92/10/24 By Apple
# Modify.........: 93/04/27 BY Apple 虛擬料件是否展開
# Modify.........: 94/08/15 By Danny 改由bmt_file取插件位置
#	.........: 組成用量以不除以底數呈現
# Modify.........: No.FUN-4A0036 04/10/08 By Smapmin新增開窗功能
# Modify.........: No.MOD-4A0358 04/11/01 By Mandy 列印頁次
# Modify.........: No.FUN-510033 05/02/15 By Mandy 報表轉XML
# Modify.........: No.MOD-530298 05/03/28 By kim 取替代料件前,請加上'替代'('SUB')或'取代'('UTE')字樣提示
# Modify.........: No.FUN-550093 05/05/27 By kim 配方BOM
# Modify.........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.FUN-560227 05/06/27 By kim 將組成用量/底數/QPA全部alter成 DEC(16,8)
# Modify.........: No.TQC-5B0030 05/11/07 By Pengu 1.051103點測修改報表格式
# Modify.........: No.TQC-5B0107 05/11/12 By Pengu 報表料件、品名、規格之格式調整
# Modify.........: NO.FUN-590118 06/01/03 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-670041 06/07/27 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-6C0014 07/01/04 By Jackho 報表頭尾修改 
# Modify.........: No.CHI-6A0034 07/01/30 By jamie abmq600->abmr800 
# Modify.........: No.MOD-810028 08/01/11 By Pengu 未按照標準的PRINTX寫法
# Modify.........: NO.FUN-850045 08/05/13 By zhaijie老報表修改為CR
# Modify.........: NO.FUN-870060 08/07/13 By zhaijie修改BUG
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: NO.MOD-8A0093 08/10/13 By claire 取替代料號列印勾選時,會將單頭主件的品名規格給取代
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-980006 09/10/14 By baofei 修改CR打印錯誤 
# Modify.........: No:MOD-A30033 10/03/05 By Sarah 選擇展開虛擬料件下階,但結果未展出
# Modify.........: No:FUN-A40058 10/04/27 By lilingyu bmb16增加規格替代內容
# Modify.........: No:MOD-A40183 10/04/30 By Sarah 將l_bmc05變數放大LIKE bmc_file.bmc05
# Modify.........: No:MOD-A60182 10/06/29 By Sarah l_table3增加記錄主件料號
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No:MOD-D10140 13/01/28 By bart "主件料件數量"同sfb08可入小數位數

DATABASE ds
 
#CHI-6A0034 add
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD			      # Print condition RECORD
            wc        LIKE type_file.chr500,  # Where condition
            class     LIKE type_file.chr4,    # 分群碼
            revision  LIKE type_file.chr2,    # 版本
            effective LIKE type_file.dat,     # 有效日期
            engine    LIKE type_file.chr1,    # 是否列印工程資料
            #a         INTEGER,                # Assembly Part QTY #MOD-D10140
            a         LIKE sfb_file.sfb08,    #MOD-D10140
            s         LIKE type_file.chr1,    # Sort Sequence
            blow      LIKE type_file.chr1,
            b         LIKE type_file.chr1,    # 是否列印說明資料
            c         LIKE type_file.chr1,
            d         LIKE type_file.chr1,
   	    more      LIKE type_file.chr1     # Input more condition(Y/N)
           END RECORD,
       sr  RECORD
            order1    LIKE type_file.chr20,
            bma01     LIKE bma_file.bma01,    #主件料件
            bmb02     LIKE bmb_file.bmb02,    #項次
            bmb03     LIKE bmb_file.bmb03,    #元件料號
            bmb04     LIKE bmb_file.bmb04,    #有效日期
            bmb05     LIKE bmb_file.bmb05,    #失效日期
            bmb06     LIKE bmb_file.bmb06,    #QPA
            bmb07     LIKE bmb_file.bmb07,    #底數
            bmb08     LIKE bmb_file.bmb08,    #損耗率%
            bmb10     LIKE bmb_file.bmb10,    #發料單位
            bmb13     LIKE bmb_file.bmb13,    #插件位置
            bmb16     LIKE bmb_file.bmb16,    #替代特性
            ima02     LIKE ima_file.ima02,    #品名規格
            ima021    LIKE ima_file.ima02,    #品名規格
            ima05     LIKE ima_file.ima05,    #版本
            ima08     LIKE ima_file.ima08,    #來源
            ima15     LIKE ima_file.ima15,    #來源
            phatom    LIKE ima_file.ima01,   #虛擬料件
            bma06     LIKE bma_file.bma06     #FUN-550093
           END RECORD,
       g_bma01 LIKE bma_file.bma01
DEFINE g_cnt          INTEGER
DEFINE g_i            SMALLINT   #count/index for any purpose
#NO.FUN-850045--start---
DEFINE g_sql          STRING
DEFINE g_str          STRING
DEFINE l_table        STRING
DEFINE l_table1       STRING
DEFINE l_table2       STRING
DEFINE l_table3       STRING      
#NO.FUN-850045---end---
DEFINE g_level        LIKE type_file.num5     #MOD-A30033 add  #階數

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
#NO.FUN-850045--start---
   LET g_sql = "bma01.bma_file.bma01,bmb02.bmb_file.bmb02,",
               "bmb03.bmb_file.bmb03,bmb04.bmb_file.bmb04,",
               "bmb05.bmb_file.bmb05,bmb06.bmb_file.bmb06,",
               "bmb07.bmb_file.bmb07,bmb08.bmb_file.bmb08,",
               "bmb10.bmb_file.bmb10,bmb13.bmb_file.bmb13,",
               "bmb16.bmb_file.bmb16,ima02.ima_file.ima02,",
               "ima021.ima_file.ima02,ima05.ima_file.ima05,",
               "ima08.ima_file.ima08,ima15.ima_file.ima15,",
               "phatom.ima_file.ima01,bma06.bma_file.bma06,",
               "l_ver.ima_file.ima05,l_ima02.ima_file.ima02,",
               "l_ima021.ima_file.ima02,l_ima05.ima_file.ima05,",
               "l_ima08.ima_file.ima08,l_ima63.ima_file.ima63,",
               "l_ima55.ima_file.ima55,bmb01.bmb_file.bmb01,",  #MOD-A30033 add bmb01
               "l_level.type_file.num5"                         #MOD-A30033 add
   LET l_table = cl_prt_temptable('abmr800',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF   
 
   LET g_sql = "l_bmt06.bmt_file.bmt08,bmb01.bmb_file.bmb01,",  #MOD-A30033 add bmb01
               "bmb02.bmb_file.bmb02,bmb03.bmb_file.bmb03,",
               "bmb04.bmb_file.bmb04,bma06.bma_file.bma06"
   LET l_table1 = cl_prt_temptable('abmr8001',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "bmb03.bmb_file.bmb03,bma01.bma_file.bma01,",   #NO.FUN-870060
               "bmb16.bmb_file.bmb16,bmd04.bmd_file.bmd04,",
               "bmd07.bmd_file.bmd07,bmd05.bmd_file.bmd05,",
               "l_ima02_s.ima_file.ima02,",  #MOD-8A0093 modify l_ima02 ->l_ima02_s
               "bmd06.bmd_file.bmd06,",      
               "l_ima021_s.ima_file.ima02"   #MOD-8A0093 modify l_ima021->l_ima021_s
   LET l_table2 = cl_prt_temptable('abmr8002',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "bmc05.bmc_file.bmc05,bmc05_1.bmc_file.bmc05,",
               "bmb01.bmb_file.bmb01,bmb02.bmb_file.bmb02,",  #MOD-A60182 add bmb01
               "bmb03.bmb_file.bmb03,bmb04.bmb_file.bmb04,",
               "bma06.bma_file.bma06"
   LET l_table3 = cl_prt_temptable('abmr8003',g_sql) CLIPPED
   IF l_table3 = -1 THEN EXIT PROGRAM END IF  
#NO.FUN-850045---end---
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.effective  = ARG_VAL(8)
   LET tm.engine  = ARG_VAL(9)
   LET tm.a    = ARG_VAL(10)
   LET tm.s    = ARG_VAL(11)
   LET tm.blow = ARG_VAL(12)
   LET tm.c    = ARG_VAL(13)
   LET tm.b    = ARG_VAL(14)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   #No.FUN-570264 ---end---

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80100--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r800_tm(0,0)			# Input print condition
      ELSE CALL r800()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
END MAIN
 
FUNCTION r800_tm(p_row,p_col)
   DEFINE   p_row,p_col	  SMALLINT,
            l_one         LIKE type_file.chr1,  #資料筆數
            l_date        DATE,              	#工程變異之生效日期
            l_bmb01       LIKE bmb_file.bmb01,	#
            l_cmd	  LIKE type_file.chr1000
 
   LET p_row = 3
   LET p_col = 11
 
   OPEN WINDOW r800_w AT p_row,p_col WITH FORM "abm/42f/abmr800"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #FUN-560021................begin
    CALL cl_set_comp_visible("bmb29",g_sma.sma118='Y')
    #FUN-560021................end
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.engine ='N'           #不列印工程技術資料
   LET tm.effective = g_today	#有效日期
  #---------No.FUN-670041 modify
  #LET tm.blow = g_sma.sma29
   LET tm.blow = 'Y'
  #---------No.FUN-670041 modify
   LET tm.a    = 1
   LET tm.s    = g_sma.sma65
   LET tm.b    = 'N'
   LET tm.c    = 'N'
   LET tm.d    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_prtway = NULL
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT tm.wc ON bmb01,bmb03,bmb13,bmb29 FROM item,com_part,balloon,bmb29  #FUN-550093
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
#FUN-4A0036新增開窗功能
   ON ACTION CONTROLP
         CASE
            WHEN INFIELD(item)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_bmb204"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO item
            WHEN INFIELD(com_part)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_bmb203"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO com_part
         END CASE
 
   ON ACTION locale
         CALL cl_dynamic_locale()
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
END CONSTRUCT
 
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r800_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      LET l_one='N'
      IF tm.wc != ' 1=1' THEN
         LET l_cmd="SELECT bmb01 FROM bmb_file",
                   " WHERE ",tm.wc CLIPPED
         PREPARE r800_precnt FROM l_cmd
         IF SQLCA.sqlcode THEN
            CALL cl_err('Prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
            EXIT PROGRAM
         END IF
         DECLARE r800_cnt
         CURSOR FOR r800_precnt
         MESSAGE " SEARCHING ! "
         FOREACH r800_cnt INTO l_bmb01
            IF SQLCA.sqlcode  THEN
               CALL cl_err(SQLCA.sqlcode,'mfg2601',0)
               CONTINUE WHILE
            ELSE
               LET l_one = 'Y'
               EXIT FOREACH
            END IF
         END FOREACH
         MESSAGE " "
         IF l_bmb01 IS NULL OR l_bmb01 = ' ' THEN
            CALL cl_err(SQLCA.sqlcode,'mfg2601',0)
            CONTINUE WHILE
         END IF
      END IF
 
      INPUT BY NAME tm.effective,tm.a,tm.s,tm.blow,tm.c,tm.b,tm.d,tm.more
         WITHOUT DEFAULTS
 
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a < 0 THEN
               LET tm.a = 1
               DISPLAY BY NAME tm.a
            END IF
 
         AFTER FIELD s
            IF cl_null(tm.s) OR tm.s NOT MATCHES '[1-3]' THEN
               NEXT FIELD s
            END IF
 
         AFTER FIELD blow
            IF cl_null(tm.blow) OR tm.blow NOT MATCHES'[yYnN]' THEN
               NEXT FIELD blow
            END IF
 
         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES'[yYnN]' THEN
               NEXT FIELD b
            END IF
 
         AFTER FIELD c
            IF cl_null(tm.c) OR tm.c NOT MATCHES'[yYnN]' THEN
               NEXT FIELD c
            END IF
 
         #No.B066 010321 by linda add
         AFTER FIELD d
            IF cl_null(tm.d) OR tm.d NOT MATCHES'[yYnN]' THEN
               NEXT FIELD d
            END IF
 
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
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
 
         ON ACTION CONTROLP CALL r800_wc()   # Input detail Where Condition
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r800_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='abmr800'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('abmr800','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.effective CLIPPED,"'",
                            " '",tm.engine CLIPPED,"'",
                            " '",tm.a CLIPPED,"'",
                            " '",tm.s CLIPPED,"'",
                            " '",tm.blow CLIPPED,"'",
                            " '",tm.c    CLIPPED,"'",
                            " '",tm.b    CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('abmr800',g_time,l_cmd)	# Execute cmd at later time
         END IF
         CLOSE WINDOW r800_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r800()
      ERROR ""
   END WHILE
   CLOSE WINDOW r800_w
END FUNCTION
 
 
 FUNCTION r800_wc()
    DEFINE  l_wc  STRING     #NO.FUN-910082 
    OPEN WINDOW r800_w2 AT 2,2
         WITH FORM "abm/42f/abmi600"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("abmi600")
 
    CALL cl_opmsg('q')
    CONSTRUCT l_wc ON                               # 螢幕上取條件
         bma01,bma04,bmauser,bmagrup,bmamodu,bmadate,bmaacti,
         bmb02,bmb03,bmb04,bmb05,bmb10,bmb13,bmb06,bmb07,bmb08
         FROM
         bma01,bma04,bmauser,bmagrup,bmamodu,bmadate,bmaacti,
         s_bmb[1].bmb02,s_bmb[1].bmb03,s_bmb[1].bmb04,s_bmb[1].bmb05,
         s_bmb[1].bmb10,s_bmb[1].bmb13,s_bmb[1].bmb06,s_bmb[1].bmb07,
         s_bmb[1].bmb08
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    CLOSE WINDOW r800_w2
    LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
 END FUNCTION
 
FUNCTION r800_cur()
DEFINE l_sql       STRING,      #NO.FUN-910082
       l_cmd       LIKE type_file.chr1000
 
#---->產品結構說明資料
     LET l_cmd  = " SELECT bmc04,bmc05 FROM bmc_file ",
                  " WHERE bmc01=?  AND bmc02= ? AND ",
                  " bmc021=? AND ",
                  " (bmc03 IS NULL OR bmc03 >= ?) ",
                  " AND bmc06=? ",  #FUN-550093
                  " ORDER BY 1"
     PREPARE r800_prebmc    FROM l_cmd
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
     DECLARE r800_bmc CURSOR FOR r800_prebmc
 
#---->產品結構插件位置
     LET l_cmd  = " SELECT bmt05,bmt06 FROM bmt_file ",
                  " WHERE bmt01=?  AND bmt02= ? AND ",
                  " bmt03=? AND ",
                  " (bmt04 IS NULL OR bmt04 >= ?) ",
                  " AND bmt08=? ",  #FUN-550093
                  " ORDER BY 1"
     PREPARE r800_prebmt     FROM l_cmd
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
     DECLARE r800_bmt  CURSOR WITH  HOLD FOR r800_prebmt
 
     LET l_sql = "SELECT '',",
                 " bma01,",		#95/12/21 Modify By Lynn
                 " bmb02,bmb03,bmb04,bmb05,bmb06,",
                 " bmb07,bmb08,bmb10,bmb13,bmb16,",
                 " ima02,ima021,ima05,ima08,ima15,'',bma06", #FUN-550093
                 " FROM bma_file,bmb_file,ima_file",
                 " WHERE bma01 = bmb01 AND bma01 = ? ",
                 "   AND bmb03 = ima01",
                 "   AND bma06=bmb29"  #FUN-550093
     #生效日及失效日的判斷
     IF tm.effective IS NOT NULL THEN
        LET l_sql=l_sql CLIPPED,
          " AND (bmb04 <='",tm.effective CLIPPED,"' OR bmb04 IS NULL)",
          " AND (bmb05 > '",tm.effective CLIPPED,"' OR bmb05 IS NULL)"
     END IF
 
     PREPARE r800_prepare2 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
     DECLARE r800_cs2 CURSOR FOR r800_prepare2
END FUNCTION
 
FUNCTION r800_phatom(p_phatom,p_qpa,p_level)  #MOD-A30033 add p_level
   DEFINE p_phatom   LIKE bmb_file.bmb01,
          p_qpa      LIKE bmb_file.bmb06,
          p_level    LIKE type_file.num5,  #MOD-A30033 add
          l_ac,l_i   SMALLINT,
          l_tot      SMALLINT,
          l_times    SMALLINT,
          arrno	     SMALLINT,	#BUFFER SIZE (可存筆數)
          b_seq	     SMALLINT,	#當BUFFER滿時,重新讀單身之起始序號
          l_chr	     LIKE type_file.chr1,
          l_ute_flag LIKE type_file.chr3,     #FUN-A40058 chr2->chr3
          sr   DYNAMIC ARRAY OF RECORD          #每階存放資料
                order1  LIKE type_file.chr20,
                bma01   LIKE bma_file.bma01,    #主件料件
                bmb02   LIKE bmb_file.bmb02,    #項次
                bmb03   LIKE bmb_file.bmb03,    #元件料號
                bmb04   LIKE bmb_file.bmb04,    #有效日期
                bmb05   LIKE bmb_file.bmb05,    #失效日期
                bmb06   LIKE bmb_file.bmb06,    #QPA
                bmb07   LIKE bmb_file.bmb07,    #底數
                bmb08   LIKE bmb_file.bmb08,    #損耗率%
                bmb10   LIKE bmb_file.bmb10,    #發料單位
                bmb13   LIKE bmb_file.bmb13,    #插件位置
                bmb16   LIKE bmb_file.bmb16,    #替代特性
                ima02   LIKE ima_file.ima02,    #品名規格
                ima021  LIKE ima_file.ima02,    #品名規格
                ima05   LIKE ima_file.ima05,    #版本
                ima08   LIKE ima_file.ima08,    #來源
                ima15   LIKE ima_file.ima15,    #來源
                phatom  LIKE ima_file.ima01,    #虛擬料件
                bma06   LIKE bma_file.bma06     #FUN-550093
               END RECORD
   DEFINE l_bma01    LIKE bma_file.bma01
#NO.FUN-850045----START---          
   DEFINE l_ver      LIKE ima_file.ima05
   DEFINE l_ima02    LIKE ima_file.ima02     #品名規格
   DEFINE l_ima021   LIKE ima_file.ima02     #品名規格
   DEFINE l_ima02_s  LIKE ima_file.ima02     #品名規格  #MOD-8A0093
   DEFINE l_ima021_s LIKE ima_file.ima02     #品名規格  #MOD-8A0093
   DEFINE l_ima05    LIKE ima_file.ima05     #版本
   DEFINE l_ima08    LIKE ima_file.ima08     #來源
   DEFINE l_ima63    LIKE ima_file.ima63     #發料單位
   DEFINE l_ima55    LIKE ima_file.ima55     #生產單位
   DEFINE l_bmt01    LIKE bmt_file.bmt01
   DEFINE l_bmt05    LIKE bmt_file.bmt05
   DEFINE l_bmt06    ARRAY[200] OF LIKE type_file.chr20  #插件位置
   DEFINE l_byte     SMALLINT
   DEFINE l_len      SMALLINT
   DEFINE l_bmt06_s  LIKE type_file.chr20
   DEFINE l_bmtstr   LIKE type_file.chr20
   DEFINE l_tmpstr   STRING         #替代(SUB)或'取代(UTE)
   DEFINE l_now      SMALLINT
   DEFINE l_now2     SMALLINT
   DEFINE l_bmd      RECORD LIKE bmd_file.*
   DEFINE l_bmc05    ARRAY[200] OF LIKE bmc_file.bmc05   #MOD-A40183 mod  #CHAR(10)
   DEFINE l_bmc01    LIKE bmc_file.bmc01
   DEFINE l_bmc04    LIKE bmc_file.bmc04
   DEFINE l_sql      STRING
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?)"   #MOD-A30033 add 2?
   PREPARE insert_prep00 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep00:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM
   END IF
      
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?)"   #MOD-A30033 add ?
   PREPARE insert_prep01 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep01:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM
   END IF 
     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep02 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep02:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM
   END IF   
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?)"  #MOD-A60182 add ?
   PREPARE insert_prep03 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep03:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM
   END IF 
#TQC-980006---begin  
#  CALL cl_del_data(l_table)
#  CALL cl_del_data(l_table1)
#  CALL cl_del_data(l_table2)
#  CALL cl_del_data(l_table3) 
#  SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'abmr800'
##NO.FUN-850045----END----   
#TQC-980006---end 
   LET l_ac = 1
   LET arrno = 600
   LET l_ute_flag='USZ'            #FUN-A40058 add 'Z'
   LET p_level = p_level + 1   #MOD-A30033 add
   FOREACH r800_cs2 USING p_phatom INTO sr[l_ac].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET sr[l_ac].phatom = p_phatom
      LET sr[l_ac].bmb06= sr[l_ac].bmb06 * p_qpa
      LET l_ac = l_ac + 1			# 但BUFFER不宜太大
#      IF l_ac > arrno THEN CALL cl_err('',9035,0) EXIT FOREACH END IF
   END FOREACH
   LET l_tot=l_ac-1
   FOR l_i = 1 TO l_tot		# 讀BUFFER傳給REPORT
      IF sr[l_i].ima08 = 'X' AND tm.blow = 'Y' THEN
         CALL r800_phatom(sr[l_i].bmb03,sr[l_i].bmb06,p_level)   #MOD-A30033 add p_level
         CONTINUE FOR
      END IF
#NO.FUN-850045----MARK--START---       
#        CASE tm.s
#          WHEN '1' LET sr[l_i].order1=sr[l_i].bmb02 using'#####'
#          WHEN '2' LET sr[l_i].order1=sr[l_i].bmb03
#          WHEN '3' LET sr[l_i].order1=sr[l_i].bmb13
#          OTHERWISE LET sr[l_i].order1 = ' '
#        END CASE
#NO.FUN-850045---END----MARK---
        #改變替代特性的表示方式
        IF sr[l_i].bmb16 MATCHES '[127]' THEN         #FUN-A40058 ADD '7'
           LET g_cnt=sr[l_i].bmb16 USING '&'
           LET sr[l_i].bmb16=l_ute_flag[g_cnt,g_cnt]
        ELSE
           LET sr[l_i].bmb16=' '
        END IF
        LET sr[l_i].bma01= g_bma01
#        OUTPUT TO REPORT r800_rep(sr[l_i].*)               #NO.FUN-850045
#NO.FUN-850045----START----
     CALL s_effver(sr[l_i].bma01,tm.effective) RETURNING l_ver
      SELECT ima02,ima021,ima05,ima08,ima63,ima55
        INTO l_ima02,l_ima021,l_ima05,l_ima08,l_ima63,l_ima55
        FROM ima_file
       WHERE ima01 = sr[l_i].bma01
      IF SQLCA.sqlcode THEN
         LET l_ima02='' LET l_ima05='' LET l_ima08=''
         LET l_ima63='' LET l_ima55=''
      END IF
      IF sr[l_i].phatom IS NOT NULL AND sr[l_i].phatom !=' '
      THEN LET l_bmt01 = sr[l_i].phatom
      ELSE LET l_bmt01 = sr[l_i].bma01
      END IF
  #-->列印插件位置
      IF tm.c ='Y' THEN
         FOR g_cnt=1 TO 200
             LET l_bmt06[g_cnt]=NULL
         END FOR
         LET l_now2=1
         LET l_len =20
         LET l_bmtstr = ''
         FOREACH r800_bmt
         USING l_bmt01,sr[l_i].bmb02,sr[l_i].bmb03,sr[l_i].bmb04,sr[l_i].bma06
         INTO l_bmt05,l_bmt06_s
            IF SQLCA.sqlcode THEN
               CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
            END IF
            IF l_now2 > 200 THEN
               CALL cl_err('','9036',1)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
               EXIT PROGRAM
            END IF
            LET l_byte = length(l_bmt06_s) + 1
            IF l_len >= l_byte THEN
               LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','
               LET l_len = l_len - l_byte
            ELSE
               LET l_bmt06[l_now2] = l_bmtstr
               LET l_len = 20
               LET l_now2 = l_now2 + 1
               LET l_len = l_len - l_byte
               LET l_bmtstr = ''
               LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','
            END IF
         END FOREACH
         LET l_bmt06[l_now2] = l_bmtstr
         FOR g_cnt = 1 TO l_now2
            IF l_bmt06[g_cnt] IS NULL OR l_bmt06[g_cnt] = ' ' THEN
               EXIT FOR
            END IF
           #PRINTX name=D1 COLUMN g_c[32],g_x[29] CLIPPED,l_bmt06[g_cnt] 
           #str MOD-A30033 mod sr[g_cnt]->sr[l_i]
            EXECUTE insert_prep01 USING
               l_bmt06[g_cnt],sr[l_i].bma01,sr[l_i].bmb02,  #MOD-A30033 add bma01
               sr[l_i].bmb03,sr[l_i].bmb04,sr[l_i].bma06
           #end MOD-A30033 mod
         END FOR
      END IF
  #-->列印取替代料
      IF tm.d ='Y' AND sr[l_i].bmb16 MATCHES '[12SU7Z]' THEN                     #FUN-A40058 add '7Z'
         LET l_sql="SELECT bmd_file.*, ima02,ima021 FROM bmd_file,ima_file",
                   " WHERE bmd01='",sr[l_i].bmb03,"' AND bmd04=ima01",
                   "  AND (bmd08='",sr[l_i].bma01,"' OR bmd08='ALL')",
                   "  AND bmdacti = 'Y'"                                           #CHI-910021
         IF tm.effective IS NOT NULL THEN
            LET l_sql=l_sql CLIPPED,
                " AND (bmd05 <='",tm.effective CLIPPED,"' OR bmd05 IS NULL)",
                " AND (bmd06 > '",tm.effective CLIPPED,"' OR bmd06 IS NULL)"
         END IF
         PREPARE r800_sub_p0 FROM l_sql
         DECLARE r800_sub_c0 CURSOR FOR r800_sub_p0
         FOREACH r800_sub_c0 INTO l_bmd.*, l_ima02_s, l_ima021_s #MOD-8A0093 modify 
            #LET l_tmpstr=''
            #IF sr[l_i].bmb16='S' THEN
            #   LET l_tmpstr='(SUB) '
            #END IF
            #IF sr[l_i].bmb16='U' THEN
            #   LET l_tmpstr='(UTE) '
            #END IF
            EXECUTE insert_prep02 USING
              sr[l_i].bmb03,sr[l_i].bma01,sr[l_i].bmb16,l_bmd.bmd04,#FUN-870060
              l_bmd.bmd07,l_bmd.bmd05,l_ima02_s,l_bmd.bmd06,l_ima021_s  #MOD-8A0093 modify
         END FOREACH
      END IF
      IF tm.b ='Y' THEN
      #--->處理說明的部份, 本程式在此假設其最大的內容不會超過100筆
         FOR g_cnt=1 TO 100
             LET l_bmc05[g_cnt]=NULL
         END FOR
         LET l_now=1
         IF sr[l_i].phatom IS NOT NULL AND sr[l_i].phatom !=' '
         THEN LET l_bmc01 = sr[l_i].phatom
         ELSE LET l_bmc01 = sr[l_i].bma01
         END IF
         FOREACH r800_bmc
         USING l_bmc01,sr[l_i].bmb02,sr[l_i].bmb03,sr[l_i].bmb04,sr[l_i].bma06
         INTO l_bmc04,l_bmc05[l_now]
             IF SQLCA.sqlcode THEN
                CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
             END IF
             IF l_now > 200 THEN
                 CALL cl_err('','9036',1)
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
                 EXIT PROGRAM
             END IF
             LET l_now=l_now+1
         END FOREACH
         LET l_now=l_now-1
 
         #--->列印剩下說明
         IF l_now >= 1 THEN
            FOR g_cnt = 1 TO l_now STEP 2
                EXECUTE insert_prep03 USING
                  l_bmc05[g_cnt],l_bmc05[g_cnt+1],sr[g_cnt].bma01,sr[g_cnt].bmb02,  #MOD-A60182 add bma01
                  sr[g_cnt].bmb03,sr[g_cnt].bmb04,sr[g_cnt].bma06
            END FOR
         END IF
      END IF
     #str MOD-A30033 mod   #sr[l_ac]->sr[l_i]
      EXECUTE insert_prep00 USING
         sr[l_i].bma01 ,sr[l_i].bmb02,sr[l_i].bmb03,sr[l_i].bmb04,
         sr[l_i].bmb05 ,sr[l_i].bmb06,sr[l_i].bmb07,sr[l_i].bmb08,
         sr[l_i].bmb10 ,sr[l_i].bmb13,sr[l_i].bmb16,sr[l_i].ima02,
         sr[l_i].ima021,sr[l_i].ima05,sr[l_i].ima08,sr[l_i].ima15,
         sr[l_i].phatom,sr[l_i].bma06,l_ver,l_ima02,l_ima021,
         l_ima05,l_ima08,l_ima63,l_ima55,sr[l_i].bma01,p_level   #MOD-A30033 mod
     #end MOD-A30033 mod
#NO.FUN-850045---END---
    END FOR
END FUNCTION
 
FUNCTION r800()
   DEFINE l_name     LIKE type_file.chr20,		# External(Disk) file name
          l_time     LIKE type_file.chr8,		# Used time for running the job
          l_ute_flag LIKE type_file.chr3,               #FUN-A40058 chr2->chr3
          l_sql      LIKE type_file.chr1000,		# RDSQL STATEMENT
          l_za05     LIKE type_file.chr50,
          l_bma01    LIKE bma_file.bma01
#NO.FUN-850045----START---          
   DEFINE l_ver      LIKE ima_file.ima05
   DEFINE l_ima02    LIKE ima_file.ima02     #品名規格
   DEFINE l_ima021   LIKE ima_file.ima02     #品名規格
   DEFINE l_ima02_s  LIKE ima_file.ima02     #品名規格   #MOD-8A0093 
   DEFINE l_ima021_s LIKE ima_file.ima02     #品名規格   #MOD-8A0093
   DEFINE l_ima05    LIKE ima_file.ima05     #版本
   DEFINE l_ima08    LIKE ima_file.ima08     #來源
   DEFINE l_ima63    LIKE ima_file.ima63     #發料單位
   DEFINE l_ima55    LIKE ima_file.ima55     #生產單位
   DEFINE l_bmt01    LIKE bmt_file.bmt01
   DEFINE l_bmt05    LIKE bmt_file.bmt05
   DEFINE l_bmt06    ARRAY[200] OF LIKE type_file.chr20  #插件位置
   DEFINE l_byte     SMALLINT
   DEFINE l_len      SMALLINT
   DEFINE l_bmt06_s  LIKE type_file.chr20
   DEFINE l_bmtstr   LIKE type_file.chr20
   DEFINE l_tmpstr   STRING          #替代(SUB)或'取代(UTE)
   DEFINE l_now      SMALLINT
   DEFINE l_now2     SMALLINT
   DEFINE l_bmd	     RECORD LIKE bmd_file.*
   DEFINE l_bmc05    ARRAY[200] OF LIKE bmc_file.bmc05   #MOD-A40183 mod  #CHAR(10)
   DEFINE l_bmc01    LIKE bmc_file.bmc01
   DEFINE l_bmc04    LIKE bmc_file.bmc04
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?)"   #MOD-A30033 add 2?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM
   END IF
      
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?)"   #MOD-A30033 add ?
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM
   END IF 
     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep2:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM
   END IF   
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?)"   #MOD-A60182 add ?
   PREPARE insert_prep3 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep3:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM
   END IF 
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
   CALL cl_del_data(l_table3) 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'abmr800'
#NO.FUN-850045----END----   
       #No.FUN-B80100--mark--Begin---
       #CALL cl_used(g_prog,l_time,1) RETURNING l_time #No.MOD-580088  HCN 20050818
       #No.FUN-B80100--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND bmauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同部門的資料
     #         LET tm.wc = tm.wc clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND bmagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '',",
                 " bma01,",		    #95/12/21 Modify By Lynn
                 " bmb02,bmb03,bmb04,bmb05,bmb06,",
                 " bmb07,bmb08,bmb10,bmb13,bmb16,",
                 " ima02,ima021,ima05,ima08,ima15,'',bma06", #FUN-550093
                 " FROM bma_file, bmb_file,ima_file",
                 " WHERE bma01 = bmb01",
                 "   AND bma06=bmb29", #FUN-550093
                 "   AND bmb03 = ima01",
                 "   AND ",tm.wc
 
     #---->生效日及失效日的判斷
     IF tm.effective IS NOT NULL THEN
        LET l_sql=l_sql CLIPPED,
          " AND (bmb04 <='",tm.effective CLIPPED,"' OR bmb04 IS NULL)",
          " AND (bmb05 > '",tm.effective CLIPPED,"' OR bmb05 IS NULL)"
     END IF
 
     PREPARE r800_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
     DECLARE r800_c1 CURSOR FOR r800_prepare1
 
#     CALL cl_outnam('abmr800') RETURNING l_name           #NO.FUN-850045
#     START REPORT r800_rep TO l_name                      #NO.FUN-850045
 
     CALL r800_cur()
     LET g_pageno = 0 #MOD-4A0358
     LET l_ute_flag='USZ'         #FUN-A40058 add 'Z'
     LET g_level = 1   #MOD-A30033 add
     FOREACH r800_c1 INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF sr.ima08 = 'X' AND tm.blow = 'Y' THEN
          LET g_bma01 = sr.bma01
          CALL r800_phatom(sr.bmb03,sr.bmb06,g_level)  #MOD-A30033 add g_level
          CONTINUE FOREACH
       END IF
#NO.FUN-850045----MARK--START---       
#       CASE tm.s
#           WHEN '1' LET sr.order1=sr.bmb02  USING'#####'
#           WHEN '2' LET sr.order1=sr.bmb03
#           WHEN '3' LET sr.order1=sr.bmb13
#           OTHERWISE LET sr.order1 = ' '
#       END CASE
#NO.FUN-850045---END----MARK---
       #---->改變替代特性的表示方式
       IF sr.bmb16 MATCHES '[127]' THEN   #FUN-A40058 add '7'
           LET g_cnt=sr.bmb16 USING '&'
           LET sr.bmb16=l_ute_flag[g_cnt,g_cnt]
       ELSE
           LET sr.bmb16=' '
       END IF
#       OUTPUT TO REPORT r800_rep(sr.*)                     #NO.FUN-850045
#NO.FUN-850045----START----
     CALL s_effver(sr.bma01,tm.effective) RETURNING l_ver
      SELECT ima02,ima021,ima05,ima08,ima63,ima55
        INTO l_ima02,l_ima021,l_ima05,l_ima08,l_ima63,l_ima55
        FROM ima_file
       WHERE ima01 = sr.bma01
      IF SQLCA.sqlcode THEN
         LET l_ima02='' LET l_ima05='' LET l_ima08=''
         LET l_ima63='' LET l_ima55=''
      END IF
      IF sr.phatom IS NOT NULL AND sr.phatom !=' '
      THEN LET l_bmt01 = sr.phatom
      ELSE LET l_bmt01 = sr.bma01
      END IF
  #-->列印插件位置
      IF tm.c ='Y' THEN
         FOR g_cnt=1 TO 200
             LET l_bmt06[g_cnt]=NULL
         END FOR
         LET l_now2=1
         LET l_len =20
         LET l_bmtstr = ''
         FOREACH r800_bmt
         USING l_bmt01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bma06
         INTO l_bmt05,l_bmt06_s
            IF SQLCA.sqlcode THEN
               CALL cl_err('Foreach:',SQLCA.sqlcode,0)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
               EXIT FOREACH
            END IF
            IF l_now2 > 200 THEN
               CALL cl_err('','9036',1)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
               EXIT PROGRAM
            END IF
            LET l_byte = length(l_bmt06_s) + 1
            IF l_len >= l_byte THEN
               LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','
               LET l_len = l_len - l_byte
            ELSE
               LET l_bmt06[l_now2] = l_bmtstr
               LET l_len = 20
               LET l_now2 = l_now2 + 1
               LET l_len = l_len - l_byte
               LET l_bmtstr = ''
               LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','
            END IF
         END FOREACH
         LET l_bmt06[l_now2] = l_bmtstr
         FOR g_cnt = 1 TO l_now2
             IF l_bmt06[g_cnt] IS NULL OR l_bmt06[g_cnt] = ' ' THEN
                EXIT FOR
             END IF
             #PRINTX name=D1 COLUMN g_c[32],g_x[29] CLIPPED,l_bmt06[g_cnt] 
             EXECUTE insert_prep1 USING
               l_bmt06[g_cnt],sr.bma01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bma06   #MOD-A30033 add bma01
         END FOR
      END IF
  #-->列印取替代料
      IF tm.d ='Y' AND sr.bmb16 MATCHES '[12SU7Z]' THEN               #FUN-A40058 add '7Z'
         LET l_sql="SELECT bmd_file.*, ima02,ima021 FROM bmd_file,ima_file",
                   " WHERE bmd01='",sr.bmb03,"' AND bmd04=ima01",
                   "  AND (bmd08='",sr.bma01,"' OR bmd08='ALL')",
                   "  AND bmdacti = 'Y'"                                           #CHI-910021
         IF tm.effective IS NOT NULL THEN
            LET l_sql=l_sql CLIPPED,
                " AND (bmd05 <='",tm.effective CLIPPED,"' OR bmd05 IS NULL)",
                " AND (bmd06 > '",tm.effective CLIPPED,"' OR bmd06 IS NULL)"
         END IF
         PREPARE r800_sub_p FROM l_sql
         DECLARE r800_sub_c CURSOR FOR r800_sub_p
         FOREACH r800_sub_c INTO l_bmd.*, l_ima02_s, l_ima021_s  #MOD-8A0093 modify
            #LET l_tmpstr=''
            #IF sr.bmb16='S' THEN
            #   LET l_tmpstr='(SUB) '
            #END IF
            #IF sr.bmb16='U' THEN
            #   LET l_tmpstr='(UTE) '
            #END IF
            EXECUTE insert_prep2 USING
              sr.bmb03,sr.bma01,sr.bmb16,l_bmd.bmd04,l_bmd.bmd07,l_bmd.bmd05,l_ima02_s,  #MOD-8A0093 modify
              l_bmd.bmd06,l_ima021_s                                                     #MOD-8A0093 modify     
         END FOREACH
      END IF
      IF tm.b ='Y' THEN
      #--->處理說明的部份, 本程式在此假設其最大的內容不會超過100筆
         FOR g_cnt=1 TO 100
             LET l_bmc05[g_cnt]=NULL
         END FOR
         LET l_now=1
         IF sr.phatom IS NOT NULL AND sr.phatom !=' '
         THEN LET l_bmc01 = sr.phatom
         ELSE LET l_bmc01 = sr.bma01
         END IF
         FOREACH r800_bmc
         USING l_bmc01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bma06
         INTO l_bmc04,l_bmc05[l_now]
             IF SQLCA.sqlcode THEN
                CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
             END IF
             IF l_now > 200 THEN
                 CALL cl_err('','9036',1)
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
                 EXIT PROGRAM
             END IF
             LET l_now=l_now+1
         END FOREACH
         LET l_now=l_now-1
 
         #--->列印剩下說明
         IF l_now >= 1 THEN
            FOR g_cnt = 1 TO l_now STEP 2
               EXECUTE insert_prep3 USING
                 l_bmc05[g_cnt],l_bmc05[g_cnt+1],sr.bma01,sr.bmb02,  #MOD-A60182 add sr.bma01
                 sr.bmb03,sr.bmb04,sr.bma06
            END FOR
         END IF
      END IF
      EXECUTE insert_prep USING
        sr.bma01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmb05,sr.bmb06,sr.bmb07,
        sr.bmb08,sr.bmb10,sr.bmb13,sr.bmb16,sr.ima02,sr.ima021,sr.ima05,
        sr.ima08,sr.ima15,sr.phatom,sr.bma06,l_ver,l_ima02,l_ima021,
        l_ima05,l_ima08,l_ima63,l_ima55,sr.bma01,g_level   #MOD-A30033 mod
#NO.FUN-850045---END---
     END FOREACH
 
#     FINISH REPORT r800_rep                               #NO.FUN-850045
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)          #NO.FUN-850045
#NO.FUN-850045--start-----
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'bmb01,bmb03,bmb13,bmb29 FROM item,com_part,balloon,bmb29')
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.s,";",tm.effective,";",tm.a,";",
                 g_sma.sma888[1,1],";",tm.c,";",tm.d,";",tm.b
     CALL cl_prt_cs3('abmr800','abmr800',g_sql,g_str) 
#NO.FUN-850045----end----
       #No.FUN-B80100--mark--Begin---
       #CALL cl_used(g_prog,l_time,2) RETURNING l_time #No.MOD-580088  HCN 20050818
       #No.FUN-B80100--mark--End-----
END FUNCTION
#No.FUN-870144
#NO.FUN-850009---start--mark---
#REPORT r800_rep(sr)
#   DEFINE l_last_sw VARCHAR(1),
#          sr  RECORD
#              order1  VARCHAR(20),
#              bma01 LIKE bma_file.bma01,    #主件料件
#              bmb02 LIKE bmb_file.bmb02,    #項次
#              bmb03 LIKE bmb_file.bmb03,    #元件料號
#              bmb04 LIKE bmb_file.bmb04,    #有效日期
#              bmb05 LIKE bmb_file.bmb05,    #失效日期
#              bmb06 LIKE bmb_file.bmb06,    #QPA
#              bmb07 LIKE bmb_file.bmb07,    #底數
#              bmb08 LIKE bmb_file.bmb08,    #損耗率%
#              bmb10 LIKE bmb_file.bmb10,    #發料單位
#              bmb13 LIKE bmb_file.bmb13,    #插件位置
#              bmb16 LIKE bmb_file.bmb16,    #替代特性
#              ima02 LIKE ima_file.ima02,    #品名規格
#              ima021 LIKE ima_file.ima02,   #品名規格
#              ima05 LIKE ima_file.ima05,    #版本
#              ima08 LIKE ima_file.ima08,    #來源
#              ima15 LIKE ima_file.ima15,    #來源
#              phatom LIKE ima_file.ima01,   #虛擬料件
#              bma06 LIKE bma_file.bma06     #FUN-550093
#          END RECORD,
#          l_bmd	RECORD LIKE bmd_file.*,
#         #l_bmb06 DECIMAL(12,5),          #組成用量
#          l_bmb06 LIKE bmb_file.bmb06,    #組成用量 #FUN-560227
#          l_ima02 LIKE ima_file.ima02,    #品名規格
#          l_ima021 LIKE ima_file.ima02,    #品名規格
#          l_ima05 LIKE ima_file.ima05,    #版本
#          l_ima08 LIKE ima_file.ima08,    #來源
#          l_ima63 LIKE ima_file.ima63,    #發料單位
#          l_ima55 LIKE ima_file.ima55,    #生產單位
#          l_ver   LIKE ima_file.ima05,
#          l_bmt01 LIKE bmt_file.bmt01,
#          l_bmt05 LIKE bmt_file.bmt05,
#          l_bmt06 ARRAY[200] OF VARCHAR(20),  #插件位置
#          l_bmc01 LIKE bmc_file.bmc01,
#          l_bmc04 LIKE bmc_file.bmc04,
#          l_bmc05 ARRAY[200] OF VARCHAR(10),  #說明
#          l_no           SMALLINT,
#          l_sql  VARCHAR(1000),		# RDSQL STATEMENT
#          l_byte,l_len   SMALLINT,
#          l_bmt06_s      VARCHAR(20),
#          l_bmtstr       VARCHAR(20),
#           l_tmpstr       STRING, #MOD-530298 替代(SUB)或'取代(UTE)
#          l_now,l_now2   SMALLINT
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.bma01,sr.bma06,sr.order1 #FUN-550093
#  FORMAT
#   PAGE HEADER
#      CALL s_effver(sr.bma01,tm.effective) RETURNING l_ver
#      #有效日期
 
#      SELECT ima02,ima021,ima05,ima08,ima63,ima55
#        INTO l_ima02,l_ima021,l_ima05,l_ima08,l_ima63,l_ima55
#        FROM ima_file
#       WHERE ima01 = sr.bma01
#      IF SQLCA.sqlcode THEN
#         LET l_ima02='' LET l_ima05='' LET l_ima08=''
#         LET l_ima63='' LET l_ima55=''
#      END IF
#
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 , g_company
#      PRINT                                          #No.FUN-6C0014
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      PRINT g_x[19] CLIPPED,tm.effective,COLUMN 20,g_x[28] CLIPPED,l_ver
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT g_dash[1,g_len]
#
##-------No.TQC-5B0107 modify #&051112
#   #----No.TQC-5B0030 modify
#     PRINT COLUMN  1,g_x[15] CLIPPED,sr.bma01,
#           COLUMN 40,g_x[21] CLIPPED,l_ima05,
#           COLUMN 56,g_x[22] CLIPPED,l_ima08,
#           COLUMN 63,g_x[16] CLIPPED,l_ima63,
#           COLUMN 77,g_x[18] CLIPPED,l_ima55
#   #-----end
#      PRINT COLUMN 1,g_x[21] CLIPPED,l_ima05,
#            COLUMN 17,g_x[22] CLIPPED,l_ima08,
#            COLUMN 25,g_x[16] CLIPPED,l_ima63,
#            COLUMN 40,g_x[18] CLIPPED,l_ima55,
#            COLUMN 57,g_x[20] CLIPPED,tm.a USING '<<<<<',
#            COLUMN 71,g_x[49] CLIPPED,sr.bma06 #FUN-550093
#      PRINT COLUMN  1,g_x[15] CLIPPED,sr.bma01
 
#      PRINT COLUMN  1,g_x[17] CLIPPED,l_ima02
##           COLUMN 50,g_x[20] CLIPPED,tm.a USING '<<<<<',
##           COLUMN 64,g_x[49] CLIPPED,sr.bma06 #FUN-550093
#      PRINT COLUMN  1,g_x[30] CLIPPED,l_ima021
#      PRINT ' '
      #----
#------------No.TQC-5B0030 end
 
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39]
#      PRINTX name=H2 g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]
#      PRINTX name=H3 g_x[47],g_x[48]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.bma06 #FUN-550093
#      IF (PAGENO > 1 OR LINENO > 13)
#         THEN SKIP TO TOP OF PAGE
#      END IF
 
#   ON EVERY ROW
#      IF sr.phatom IS NOT NULL AND sr.phatom != ' ' THEN
        #-------No.MOD-810028 modify
        #PRINT column 5,g_x[23] clipped,' ',sr.phatom
#         PRINTX name=D1 COLUMN g_c[32],g_x[23] clipped,' ',sr.phatom
        #-------No.MOD-810028 end
#      END IF
#      LET l_bmb06 = sr.bmb06 * tm.a
#      IF sr.bmb08=0 THEN LET sr.bmb08=NULL END IF
#      PRINTX name=D1 COLUMN g_c[31],sr.bmb02 USING '###&', #FUN-590118
#                     COLUMN g_c[32],sr.bmb03,
#                     COLUMN g_c[33],sr.ima08,
#                     COLUMN g_c[34],sr.bmb10,
#                     COLUMN g_c[35],cl_numfor(l_bmb06,35,4),
#                     COLUMN g_c[36],sr.bmb04,
#                     COLUMN g_c[37],cl_numfor(sr.bmb08,37,3),
#                     COLUMN g_c[38],sr.bmb16,' ';
#      IF g_sma.sma888[1,1] = 'Y' THEN
#          PRINTX name=D1 COLUMN g_c[39],sr.ima15 CLIPPED
#      ELSE
#          PRINTX name=D1 COLUMN g_c[39],' '
#      END IF
#      IF sr.phatom IS NOT NULL AND sr.phatom !=' '
#      THEN LET l_bmt01 = sr.phatom
#      ELSE LET l_bmt01 = sr.bma01
#      END IF
#      IF sr.bmb07=1 THEN LET sr.bmb07=NULL END IF
#      PRINTX name=D2 COLUMN g_c[40],' ',
#                     COLUMN g_c[41],sr.ima02,
#                     COLUMN g_c[42],' ',
#                     COLUMN g_c[43],' ',
#                     COLUMN g_c[44],sr.bmb07 USING '#####&.&&&&',
#                     COLUMN g_c[45],sr.bmb05,
#                     COLUMN g_c[46],' '
#      PRINTX name=D3 COLUMN g_c[47],' ',
#                     COLUMN g_c[48],sr.ima021
#      #-->列印插件位置
#      IF tm.c ='Y' THEN
#         FOR g_cnt=1 TO 200
#             LET l_bmt06[g_cnt]=NULL
#         END FOR
#         LET l_now2=1
#         LET l_len =20
#         LET l_bmtstr = ''
#         FOREACH r800_bmt
#         USING l_bmt01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bma06 #FUN-550093
#         INTO l_bmt05,l_bmt06_s
#            IF SQLCA.sqlcode THEN
#               CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
#            END IF
#            IF l_now2 > 200 THEN
#               CALL cl_err('','9036',1)
#               EXIT PROGRAM
#            END IF
#            LET l_byte = length(l_bmt06_s) + 1
#            IF l_len >= l_byte THEN
#               LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','
#               LET l_len = l_len - l_byte
#            ELSE
#               LET l_bmt06[l_now2] = l_bmtstr
#               LET l_len = 20
#               LET l_now2 = l_now2 + 1
#               LET l_len = l_len - l_byte
#               LET l_bmtstr = ''
#               LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','
#            END IF
#         END FOREACH
#         LET l_bmt06[l_now2] = l_bmtstr
#         FOR g_cnt = 1 TO l_now2
#            #--------No.MOD-810028 modify
            #IF l_bmt06[g_cnt] IS NULL OR l_bmt06[g_cnt] = ' '
            #THEN IF l_now2 = 1 THEN PRINT ' ' END IF
            #     EXIT FOR
            #END IF
            #PRINT COLUMN 48,g_x[29] CLIPPED,l_bmt06[g_cnt] #FUN-510033
 
#             IF l_bmt06[g_cnt] IS NULL OR l_bmt06[g_cnt] = ' ' THEN
#                IF l_now2 = 1 THEN PRINTX name=D1 ''  END IF
#                EXIT FOR
#             END IF
#             PRINTX name=D1 COLUMN g_c[32],g_x[29] CLIPPED,l_bmt06[g_cnt] #FUN-510033
#            #--------No.MOD-810028 end
#         END FOR
#      ELSE
#         PRINTX name=D1 ''   #No.MOD-810028 modify
#      END IF
#      #-->列印取替代料
#      IF tm.d ='Y' AND sr.bmb16 MATCHES '[12SU]' THEN
#         LET l_sql="SELECT bmd_file.*, ima02,ima021 FROM bmd_file,ima_file",
#                   " WHERE bmd01='",sr.bmb03,"' AND bmd04=ima01",
#                   "  AND (bmd08='",sr.bma01,"' OR bmd08='ALL')"
#         IF tm.effective IS NOT NULL THEN
#            LET l_sql=l_sql CLIPPED,
#                " AND (bmd05 <='",tm.effective CLIPPED,"' OR bmd05 IS NULL)",
#                " AND (bmd06 > '",tm.effective CLIPPED,"' OR bmd06 IS NULL)"
#         END IF
#         PREPARE r800_sub_p FROM l_sql
#         DECLARE r800_sub_c CURSOR FOR r800_sub_p
#         FOREACH r800_sub_c INTO l_bmd.*, l_ima02, l_ima021
#           #PRINT '   (',l_bmd.bmd04,')',
#           #          COLUMN 38,l_bmd.bmd07 USING '####&.&&&&',
           #          COLUMN 49,l_bmd.bmd05
           #PRINT '    ',l_ima02,COLUMN 49,l_bmd.bmd06
           #PRINT '    ',l_ima021
             #MOD-530298
#            LET l_tmpstr=''
#            IF sr.bmb16='S' THEN
#               LET l_tmpstr='(SUB) '
#            END IF
#            IF sr.bmb16='U' THEN
#               LET l_tmpstr='(UTE) '
#            END IF
#            PRINTX name=D1 COLUMN g_c[32],l_tmpstr,'(',l_bmd.bmd04,')',
#                           COLUMN g_c[35],cl_numfor(l_bmd.bmd07,35,4),
#                           COLUMN g_c[36],l_bmd.bmd05
#            PRINTX name=D2 COLUMN g_c[41],l_ima02,
#                           COLUMN g_c[45],l_bmd.bmd06
#            PRINTX name=D3 COLUMN g_c[48],l_ima021
#
#         END FOREACH
#      END IF
#      IF tm.b ='Y' THEN
#         #--->處理說明的部份, 本程式在此假設其最大的內容不會超過100筆
#         FOR g_cnt=1 TO 100
#             LET l_bmc05[g_cnt]=NULL
#         END FOR
#         LET l_now=1
#         IF sr.phatom IS NOT NULL AND sr.phatom !=' '
#         THEN LET l_bmc01 = sr.phatom
#         ELSE LET l_bmc01 = sr.bma01
#         END IF
#         FOREACH r800_bmc
#         USING l_bmc01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bma06 #FUN-550093
#         INTO l_bmc04,l_bmc05[l_now]
#             IF SQLCA.sqlcode THEN
#                CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
#             END IF
#             IF l_now > 200 THEN
#                 CALL cl_err('','9036',1)
#                 EXIT PROGRAM
#             END IF
#             LET l_now=l_now+1
#         END FOREACH
#         LET l_now=l_now-1
#
         #--->列印剩下說明
#         IF l_now >= 1 THEN
#           #--------No.MOD-810028 modify
           #FOR g_cnt = 1 TO l_now STEP 2
           #    IF g_cnt =1 THEN PRINT COLUMN 52,g_x[27] clipped; END IF
           #    PRINT COLUMN 58,l_bmc05[g_cnt],l_bmc05[g_cnt+1] CLIPPED
           #END FOR
 
#            FOR g_cnt = 1 TO l_now STEP 2
#                IF g_cnt =1 THEN PRINTX name=D1 COLUMN g_c[31],g_x[27] clipped; END IF
#                PRINTX name=D1 COLUMN g_c[32],l_bmc05[g_cnt],l_bmc05[g_cnt+1] CLIPPED
#            END FOR
#           #--------No.MOD-810028 end
#         END IF
#      END IF
 
  #AFTER GROUP OF sr.bma01
  #   LET g_pageno = 0
 
#   ON LAST ROW
#No.FUN-6C0014--begin
#      NEED 4 LINES
#      IF g_zz05 = 'Y' THEN
#         CALL cl_wcchp(tm.wc,'bmb01,bmb03,bmb13')                   
#              RETURNING tm.wc                                                   
#         PRINT g_dash[1,g_len]
#         CALL cl_prt_pos_wc(tm.wc)
