# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aqcq456.4gl
# Descriptions...: Run Card FQC料件品質履歷明細查詢
# Date & Author..: 01/05/21 By Mandy
# Modify.........: No.MOD-4A0012 04/11/01 By Yuna 語言button沒亮
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0099 05/01/13 By kim 報表轉XML功能
# Modify.........: No.FUN-530065 05/03/29 By Will 增加料件的開窗
# Modify.........: No.FUN-530065 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.MOD-590003 05/09/05 By Nigel 報表格式沒對齊
# Modify.........: NO.MOD-5A0169 05/10/14 By Rosayu 上、下筆時，單身資料會錯誤
# Modify.........: No.TQC-5B0034 05/11/08 By Rosayu 單頭料件品名規格調整
# Modify.........: No.TQC-5B0109 05/11/11 By Echo &051112修改報表料件、品名、規格格式
# Modify.........: No.TQC-610007 06/01/06 By Nicola 接收ze值的欄位型能改為LIKE
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-850033 08/05/08 By sherry 報表改由CR輸出
# Modify.........: No.FUN-870144 08/07/29 By chenmoyan 追單到31區 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-B50107 11/05/19 By zhangll 修正-201錯誤，wc長度調整
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     tm  RECORD
       #wc			LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(600)
       	wc			STRING,                      #TQC-B50107 mod
	bdate                   LIKE type_file.dat,          #No.FUN-680104 DATE
	edate                   LIKE type_file.dat           #No.FUN-680104 DATE
        END RECORD,
    g_qcf  RECORD
            qcf021	        LIKE qcf_file.qcf021,
            ima02               LIKE ima_file.ima02,
            bdate               LIKE type_file.dat,          #No.FUN-680104 DATE
            edate               LIKE type_file.dat           #No.FUN-680104 DATE
        END RECORD,
    g_qcg DYNAMIC ARRAY OF RECORD
            qcf01		LIKE qcf_file.qcf01,
            qcf04		LIKE qcf_file.qcf04,
            qcf03 	        LIKE qcf_file.qcf03,
            qcf02 	        LIKE qcf_file.qcf02,
            qcg04		LIKE qcg_file.qcg04,
            azf03		LIKE azf_file.azf03,
            qcg11		LIKE qcg_file.qcg11,
            qcg07		LIKE qcg_file.qcg07,
            rate                LIKE ima_file.ima18,       #No.FUN-680104 DECIMAL(9,3)
           #qcg08		LIKE qcf_file.qcf062       #No.FUN-680104 VARCHAR(04)
            qcg08               LIKE ze_file.ze03    #No.TQC-610007
        END RECORD,
    g_argv1         LIKE qcf_file.qcf02,      # INPUT ARGUMENT - 1
    g_query_flag    LIKE type_file.num5,      #No.FUN-680104 SMALLINT #第一次進入程式時即進入Query之後進入next
    g_curr	    LIKE type_file.chr1,      #No.FUN-680104 VARCHAR(1)
    m_cnt           LIKE type_file.num5,      #No.FUN-680104 SMALLINT
    g_sql           STRING,                   #WHERE CONDITION  #No.FUN-580092 HCN        #No.FUN-680104
    g_rec_b         LIKE type_file.num5,      #單身筆數,        #No.FUN-680104 SMALLINT
    m_qcf01         LIKE qcf_file.qcf01,
    m_qcf02         LIKE qcf_file.qcf02,
    m_qcf05         LIKE qcf_file.qcf05
 
 
 
 
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680104 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680104 SMALLINT
#No.FUN-850033---Begin                                                          
DEFINE   g_str           STRING                                                 
DEFINE   l_table         STRING                                                 
#No.FUN-850033---End  
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0085
      DEFINE   l_sl,p_row,p_col   LIKE type_file.num5  #No.FUN-680104 SMALLINT  #No.FUN-6A0085 
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
 
    #No.FUN-850033---Begin                                                      
    LET g_sql = "qcf021.qcf_file.qcf021,",                                      
                "ima02.ima_file.ima02,",  
                "ima021.ima_file.ima021,",
                "qcf01.qcf_file.qcf01,",
                "qcf04.qcf_file.qcf04,",
                "qcf03.qcf_file.qcf03,",
                "qcf02.qcf_file.qcf02,",
                "qcg04.qcg_file.qcg04,",
                "azf03.azf_file.azf03,",
                "qcg11.qcg_file.qcg11,",
                "qcg07.qcg_file.qcg07,",
                "rate.ima_file.ima18,",
                "qcg08.ze_file.ze03 "
 
    LET l_table = cl_prt_temptable('aqcq456',g_sql) CLIPPED                     
    IF l_table = -1 THEN EXIT PROGRAM END IF                                    
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,             
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,? )"                     
    PREPARE insert_prep FROM g_sql                                              
    IF STATUS THEN                                                              
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                        
    END IF                                                                      
    #NO.FUN-850033---End         
    LET g_curr = '1'
    LET g_query_flag=1
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
      LET p_row = 3 LET p_col =6
    OPEN WINDOW q456_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcq456"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
#    IF cl_chk_act_auth() THEN
#       CALL q456_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q456_q() END IF
    CALL q456_menu()
    CLOSE WINDOW q456_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION q456_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680104 SMALLINT
 
   CLEAR FORM #清除畫面
   CALL g_qcg.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_qcf.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON qcf021
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
     ON ACTION locale
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   #FUN-550037(smin)
 
     #FUN-530065
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(qcf021)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_qcf.qcf021
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO qcf021
            NEXT FIELD qcf021
         OTHERWISE
            EXIT CASE
       END CASE
     #--
 
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
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
 
   LET tm.bdate=g_today LET tm.edate=g_today
        DISPLAY BY NAME tm.bdate,tm.edate
	INPUT tm.bdate,tm.edate WITHOUT DEFAULTS FROM bdate,edate
		AFTER FIELD bdate
                   IF cl_null(tm.bdate) THEN
                      NEXT FIELD bdate
                   END IF
		AFTER FIELD edate
                   IF cl_null(tm.edate) THEN
                      NEXT FIELD edate
                   END IF
                   IF tm.edate<tm.bdate THEN
			NEXT FIELD edate
		   END IF
	   ON IDLE g_idle_seconds
	      CALL cl_on_idle()
	      CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
	
	END INPUT
        IF INT_FLAG THEN RETURN END IF
#bugno:6062modify...........................
       LET g_qcf.bdate=tm.bdate
       LET g_qcf.edate=tm.edate
#bugno:6062 end..............................
 
   MESSAGE ' WAIT '
 
   LET g_sql=" SELECT UNIQUE qcf021 FROM qcf_file ",
             " WHERE ",tm.wc CLIPPED,
             " AND qcf04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
             " AND qcf14='Y' "
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND qcfuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND qcfgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND qcfgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY qcf021"
 
   PREPARE q456_prepare FROM g_sql
   DECLARE q456_cs SCROLL CURSOR WITH HOLD FOR q456_prepare
   LET g_sql=" SELECT UNIQUE qcf021 FROM qcf_file ",
             " WHERE ",tm.wc CLIPPED,
             " AND qcf04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
             " AND qcf14='Y' "
   LET g_sql = g_sql CLIPPED," INTO TEMP x"
 
   DROP TABLE x
   PREPARE q456_precount_x FROM g_sql
   EXECUTE q456_precount_x
 
       LET g_sql="SELECT COUNT(*) FROM x "
 
   PREPARE q456_precount FROM g_sql
   DECLARE q456_count CURSOR FOR q456_precount
END FUNCTION
 
FUNCTION q456_menu()
   LET g_action_choice=" "
 
   WHILE TRUE
      CALL q456_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q456_q()
            END IF
         WHEN "first"
            CALL q456_fetch('F')
         WHEN "previous"
            CALL q456_fetch('P')
         WHEN "jump"
            CALL q456_fetch('/')
         WHEN "next"
            CALL q456_fetch('N')
         WHEN "last"
            CALL q456_fetch('L')
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q456_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qcg),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q456_q()
 
  DEFINE l_count      LIKE type_file.num10        #No.FUN-680104 INTEGER
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL g_qcg.clear() #MOD-5A0169  add
    CALL q456_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q456_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q456_count
       FETCH q456_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q456_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
 
FUNCTION q456_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680104 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680104 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q456_cs INTO g_qcf.qcf021
        WHEN 'P' FETCH PREVIOUS q456_cs INTO g_qcf.qcf021
        WHEN 'F' FETCH FIRST    q456_cs INTO g_qcf.qcf021
        WHEN 'L' FETCH LAST     q456_cs INTO g_qcf.qcf021
        WHEN '/'
          IF (NOT mi_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0  ######add for prompt bug
              PROMPT g_msg CLIPPED,': ' FOR g_jump
                 ON IDLE g_idle_seconds
                    CALL cl_on_idle()
#                    CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
              END PROMPT
              IF INT_FLAG THEN
                 LET INT_FLAG = 0
                 EXIT CASE
              END IF
          END IF
          FETCH ABSOLUTE g_jump q456_cs INTO g_qcf.qcf021
          LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN CALL cl_err(' ',SQLCA.sqlcode,0)RETURN ELSE
        CASE p_flag
           WHEN 'F' LET g_curs_index = 1
           WHEN 'P' LET g_curs_index = g_curs_index - 1
           WHEN 'N' LET g_curs_index = g_curs_index + 1
           WHEN 'L' LET g_curs_index = g_row_count
           WHEN '/' LET g_curs_index = g_jump
        END CASE
 
        CALL cl_navigator_setting( g_curs_index, g_row_count )
     END IF
 
    SELECT ima02 INTO g_qcf.ima02 FROM ima_file WHERE ima01=g_qcf.qcf021
    IF SQLCA.sqlcode THEN LET g_qcf.ima02=' ' END IF
 
 
    CALL q456_show()
END FUNCTION
 
FUNCTION q456_show()
   DISPLAY BY NAME g_qcf.*
   CALL q456_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q456_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(1100)
   #DEFINE l_ex      LIKE cqg_file.cqg08          #No.FUN-680104 DECIMAL(8,4)   #TQC-B90211
   DEFINE l_cho     LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   LET l_sql =
     "SELECT qcf01,qcf04,qcf03,qcf02,qcg04,azf03,qcg11,qcg07,0,qcg08 ",
     " FROM  qcf_file,qcg_file LEFT OUTER JOIN azf_file ON qcg04=azf01 AND azf02='6' ",
     " WHERE qcg01 = qcf01 ",
     "   AND qcf04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
     "   AND qcf021 = '",g_qcf.qcf021,"'",
     "   AND qcf14='Y' ",
     " ORDER BY 1,2,3,4,5"
    PREPARE q456_pb FROM l_sql
    DECLARE q456_bcs CURSOR FOR q456_pb
    CALL g_qcg.clear()
    LET g_rec_b=0 LET g_cnt = 1
    FOREACH q456_bcs INTO g_qcg[g_cnt].*,m_qcf01,m_qcf02,m_qcf05
       IF cl_null(g_qcg[g_cnt].qcg11) THEN LET g_qcg[g_cnt].qcg11 = 0 END IF
       IF cl_null(g_qcg[g_cnt].qcg07) THEN LET g_qcg[g_cnt].qcg07 = 0 END IF
       LET g_qcg[g_cnt].rate = (g_qcg[g_cnt].qcg07 / g_qcg[g_cnt].qcg11) * 100
       IF cl_null(g_qcg[g_cnt].rate) THEN LET g_qcg[g_cnt].rate = 0 END IF
       CASE g_qcg[g_cnt].qcg08
             WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING g_qcg[g_cnt].qcg08
             WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING g_qcg[g_cnt].qcg08
       END CASE
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         INITIALIZE g_qcf.* TO NULL  #TQC-6B0105
	 EXIT FOREACH
      END IF
    END FOREACH
    LET g_rec_b=(g_cnt-1)
    CALL g_qcg.deleteElement(g_cnt)   #No.MOD-5A0169 add
    LET g_cnt = 0                      #No.MOD-5A0169 add
 
END FUNCTION
 
FUNCTION q456_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
    IF p_ud <> "G" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_qcg TO s_qcg.* ATTRIBUTE(COUNT=g_rec_b)
 
       BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
#        BEFORE ROW
#            LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#            LET l_sl = SCR_LINE()
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         LET g_action_choice="first"
         EXIT DISPLAY
      ON ACTION previous
         LET g_action_choice="previous"
         EXIT DISPLAY
      ON ACTION jump
         LET g_action_choice="jump"
         EXIT DISPLAY
      ON ACTION next
         LET g_action_choice="next"
         EXIT DISPLAY
      ON ACTION last
         LET g_action_choice="last"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
       #No.MOD-4A0012
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
      #END
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      #No.FUN-530065  --begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      #No.FUN-530065  --end
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
FUNCTION q456_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680104 SMALLINT
    sr              RECORD
                        qcf021              LIKE qcf_file.qcf021,
                        ima02               LIKE ima_file.ima02,
                        ima021              LIKE ima_file.ima021,
                        qcf01               LIKE qcf_file.qcf01,
                        qcf04               LIKE qcf_file.qcf04,
                        qcf03               LIKE qcf_file.qcf03,
                        qcf02               LIKE qcf_file.qcf02,
                        qcg04               LIKE qcg_file.qcg04,
                        azf03               LIKE azf_file.azf03,
                        qcg11               LIKE qcg_file.qcg11,
                        qcg07               LIKE qcg_file.qcg07,
                        qcg08               LIKE ze_file.ze03,        #No.FUN-680104 VARCHAR(04)
                        rate                LIKE ima_file.ima18       #No.FUN-680104 DECIMAL(9,3)
                    END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name        #No.FUN-680104 VARCHAR(20)
    l_za05          LIKE cob_file.cob01                 #No.FUN-680104 VARCHAR(40)
 
    CALL cl_del_data(l_table) #No.FUN-850033
    IF tm.wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    #CALL cl_outnam('aqcq456') RETURNING l_name   #No.FUN-850033 
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aqcq456' #No.FUN-850033
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
     LET g_sql =
     "SELECT qcf021,ima02,ima021,qcf01,qcf04,qcf03,qcf02,qcg04,azf03,qcg11,qcg07,qcg08,0 ",
     " FROM  qcf_file LEFT OUTER JOIN ima_file ON qcf021=ima01 ,qcg_file LEFT OUTER JOIN azf_file ON qcg04=azf01 AND azf02 = '6'",
     " WHERE ",tm.wc CLIPPED,
     "   AND qcg01 = qcf01 ",
     "   AND qcf04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
     "   AND qcf14='Y' ",
     " ORDER BY 1,2,3,4,5,6,7"
 
 
    PREPARE q456_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE q456_co                         # SCROLL CURSOR
        CURSOR FOR q456_p1
 
    #START REPORT q456_rep TO l_name        #No.FUN-850033    
 
    FOREACH q456_co INTO sr.*,m_qcf01,m_qcf02,m_qcf05
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF cl_null(sr.qcg11) THEN LET sr.qcg11 = 0 END IF
        IF cl_null(sr.qcg07) THEN LET sr.qcg07 = 0 END IF
        LET sr.rate = (sr.qcg07 / sr.qcg11) * 100
        IF cl_null(sr.rate) THEN LET sr.rate = 0 END IF
 
        CASE sr.qcg08
              WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING sr.qcg08
              WHEN '2' CALL cl_getmsg('aqc-0333333',g_lang) RETURNING sr.qcg08
        END CASE
 
        #No.FUN-850033---Begin   
        #OUTPUT TO REPORT q456_rep(sr.*)
        EXECUTE insert_prep USING sr.qcf021,sr.ima02,sr.ima021,sr.qcf01,
                                  sr.qcf04,sr.qcf03,sr.qcf02,sr.qcg04,sr.azf03,
                                  sr.qcg11,sr.qcg07,sr.rate,sr.qcg08
        #No.FUN-850033---End  
 
    END FOREACH
 
    #No.FUN-850033---Begin
    #FINISH REPORT q456_rep
 
    #CLOSE q456_co
    #ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)
    #是否列印選擇條件                                                           
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(tm.wc,'qcf021')                                      
            RETURNING g_str                                                     
    END IF                                                                      
    LET g_str = g_str,";",tm.bdate,";",tm.edate                                 
    LET g_sql="SELECT * FROM ", g_cr_db_str CLIPPED,l_table CLIPPED             
    CALL cl_prt_cs3('aqcq456','aqcq456',g_sql,g_str) 
    #No.FUN-850033---End
END FUNCTION
 
#No.FUN-850033---Begin
#REPORT q456_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#   l_sw            LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#   l_i             LIKE type_file.num5,         #No.FUN-680104 SMALLINT
#   sr              RECORD
#                       qcf021              LIKE qcf_file.qcf021,
#                       ima02               LIKE ima_file.ima02,
#                       ima021              LIKE ima_file.ima021,
#                       qcf01               LIKE qcf_file.qcf01,
#                       qcf04               LIKE qcf_file.qcf04,
#                       qcf03               LIKE qcf_file.qcf03,
#                       qcf02               LIKE qcf_file.qcf02,
#                       qcg04               LIKE qcg_file.qcg04,
#                       azf03               LIKE azf_file.azf03,
#                       qcg11               LIKE qcg_file.qcg11,
#                       qcg07               LIKE qcg_file.qcg07,
#                       qcg08               LIKE ze_file.ze03,       #No.FUN-680104 VARCHAR(04)
#                       rate                LIKE ima_file.ima18      #No.FUN-680104 DECIMAL(9,3)
#                   END RECORD
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.qcf021,sr.qcf01,sr.qcf04,sr.qcf03,sr.qcf02,sr.qcg04
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED,pageno_total
#           PRINT g_x[9] CLIPPED,tm.bdate,'-',tm.edate
#           PRINT g_dash
#           PRINT g_x[11] CLIPPED,sr.qcf021 CLIPPED #TQC-5B0034
#           #TQC-5B0109&051112
#           PRINT g_x[12] CLIPPED,sr.ima02 CLIPPED
#           PRINT COLUMN 10,sr.ima021 #TQC-5B0034
#           #END TQC-5B0109&051112
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                 g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#           PRINT g_dash1
#           LET l_trailer_sw = 'n'
 
#       BEFORE GROUP OF sr.qcf021
#           SKIP TO TOP OF PAGE
#
#       BEFORE GROUP OF sr.qcf01
#           PRINT COLUMN g_c[31],sr.qcf01;
#       BEFORE GROUP OF sr.qcf04
#           PRINT COLUMN g_c[32],sr.qcf04;
#       BEFORE GROUP OF sr.qcf03
#           PRINT COLUMN g_c[33],sr.qcf03,
#                 COLUMN g_c[34],sr.qcf02;
#
#       ON EVERY ROW
#           PRINT COLUMN g_c[35],sr.qcg04,
#                 COLUMN g_c[36],sr.azf03,
#                 COLUMN g_c[37],cl_numfor(sr.qcg11,37,0),
#                 COLUMN g_c[38],cl_numfor(sr.qcg07,38,0),
#                 COLUMN g_c[39],cl_numfor(sr.rate,39,3),
#                 COLUMN g_c[40],sr.qcg08
 
#       ON LAST ROW
#           PRINT g_dash
#           LET l_trailer_sw = 'y'
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED    #MOD-590003
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'n' THEN
#               PRINT g_dash
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED     #MOD-590003
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-850033---End
#No.FUN-870144
