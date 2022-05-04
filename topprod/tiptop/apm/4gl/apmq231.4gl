# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: apmq231.4gl
# Descriptions...: 廠商最近收貨查詢
# Date & Author..: 97/08/28 By Kitty
# Modify.........: No.FUN-4B0022 04/11/03 By Yuna 新增廠商編號開窗
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-660129 06/06/19 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-C70113 12/07/18 By yangtt 新增品名、規格兩個欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    tm  RECORD
       	wc  	LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(500) 
       	wc2  	LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(500) 
        END RECORD,
    g_pmc   RECORD
        pmc01	LIKE pmc_file.pmc01,
        pmc03	LIKE pmc_file.pmc03
        END RECORD,
    g_rvb DYNAMIC ARRAY OF RECORD
            rva06   LIKE rva_file.rva06,
            rva01   LIKE rva_file.rva01,
            rvb04   LIKE rvb_file.rvb04,
            rvb05   LIKE rvb_file.rvb05,
            ima02   LIKE ima_file.ima02,   #TQC-C70113 add
            ima021  LIKE ima_file.ima021,  #TQC-C70113 add
            rvb07   LIKE rvb_file.rvb07,
            rvb35   LIKE rvb_file.rvb35
    END RECORD,
    g_argv1         LIKE pmc_file.pmc01,
    g_query_flag    LIKE type_file.num5,      #No.FUN-680136 SMALLINT #第一次進入程式時即進入Query之後進入next
    g_sql           string,                   #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num10      #No.FUN-680136 INTEGER  #單身筆數
DEFINE p_row,p_col  LIKE type_file.num5       #No.FUN-680136 SMALLINT 
DEFINE g_cnt        LIKE type_file.num10      #No.FUN-680136 INTEGER
DEFINE g_msg        LIKE ze_file.ze03,        #No.FUN-680136 VARCHAR(72) 
       l_ac         LIKE type_file.num5       #目前處理的ARRAY CNT    #No.FUN-680136 SMALLINT
 
DEFINE g_row_count  LIKE type_file.num10      #No.FUN-680136 INTEGER
DEFINE g_curs_index LIKE type_file.num10      #No.FUN-680136 INTEGER
DEFINE lc_qbe_sn    LIKE gbm_file.gbm01       #No.FUN-580031  HCN

MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET g_query_flag =1
 
    OPEN WINDOW q231_w WITH FORM "apm/42f/apmq231"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN CALL q231_q() END IF
    CALL q231_menu()
    CLOSE WINDOW q231_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION q231_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "pmc01 = '",g_argv1,"'"
		   LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_rvb.clear()
         CALL cl_opmsg('q')
         INITIALIZE tm.* TO NULL			# Default condition
         CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_pmc.* TO NULL    #No.FUN-750051
         CONSTRUCT BY NAME tm.wc ON pmc01,pmc03
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
            #--No.FUN-4B0022-------
            ON ACTION CONTROLP
              CASE WHEN INFIELD(pmc01)      #廠商編號
                        CALL cl_init_qry_var()
                        LET g_qryparam.state= "c"
                        LET g_qryparam.form = "q_pmc"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO pmc01
                        NEXT FIELD pmc01
              OTHERWISE EXIT CASE
              END CASE
            #--END---------------
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
         END CONSTRUCT
         #資料權限的檢查
         #Begin:FUN-980030
         #         IF g_priv2='4' THEN                           #只能使用自己的資料
         #            LET tm.wc = tm.wc clipped," AND pmcuser = '",g_user,"'"
         #         END IF
         #         IF g_priv3='4' THEN                           #只能使用相同群的資料
         #            LET tm.wc = tm.wc clipped," AND pmcgrup MATCHES '",g_grup CLIPPED,"*'"
         #         END IF
 
         #         IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
         #            LET tm.wc = tm.wc clipped," AND pmcgrup IN ",cl_chk_tgrup_list()
         #         END IF
         LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmcuser', 'pmcgrup')
         #End:FUN-980030
 
           IF INT_FLAG THEN RETURN END IF
           CALL q231_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   IF INT_FLAG THEN RETURN END IF
   MESSAGE ' WAIT '
   LET g_sql=" SELECT pmc01 FROM pmc_file ",
             " WHERE ",tm.wc CLIPPED,
             " ORDER BY pmc01"
   PREPARE q231_prepare FROM g_sql
   DECLARE q231_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q231_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   LET g_sql=" SELECT COUNT(*) FROM pmc_file ",
              " WHERE ",tm.wc CLIPPED
   PREPARE q231_pp  FROM g_sql
   DECLARE q231_cnt   CURSOR FOR q231_pp
END FUNCTION
 
FUNCTION q231_b_askkey()
   CONSTRUCT tm.wc2 ON rva06,rva01,rvb04,rvb05,ima02,ima021,rvb07,rvb35  #TQC-C70113 add ima02,ima021
                  FROM s_rvb[1].rva06,s_rvb[1].rva01,s_rvb[1].rvb04,
                       s_rvb[1].rvb05,s_rvb[1].ima02,s_rvb[1].ima021,    #TQC-C70113 add s_rvb[1],ima02,s_rvb[1].ima021
                       s_rvb[1].rvb07,s_rvb[1].rvb35
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
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
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
END FUNCTION
 
FUNCTION q231_menu()
 
   WHILE TRUE
      CALL q231_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q231_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvb),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q231_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q231_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q231_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q231_cnt
       FETCH q231_cnt INTO g_row_count
       DISPLAY g_row_count TO cnt
       CALL q231_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q231_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式        #No.FUN-680136 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數      #No.FUN-680136 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q231_cs INTO g_pmc.pmc01
        WHEN 'P' FETCH PREVIOUS q231_cs INTO g_pmc.pmc01
        WHEN 'F' FETCH FIRST    q231_cs INTO g_pmc.pmc01
        WHEN 'L' FETCH LAST     q231_cs INTO g_pmc.pmc01
        WHEN '/'
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR l_abso
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
#                   CONTINUE PROMPT
 
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
            FETCH ABSOLUTE l_abso q231_cs INTO g_pmc.pmc01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)
        INITIALIZE g_pmc.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
	SELECT pmc01,pmc03
	  INTO g_pmc.pmc01,g_pmc.pmc03
	  FROM pmc_file
	 WHERE pmc01 = g_pmc.pmc01
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)   #No.FUN-660129
        CALL cl_err3("sel","pmc_file",g_pmc.pmc01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660129
        RETURN
    END IF
 
    CALL q231_show()
END FUNCTION
 
FUNCTION q231_show()
   DISPLAY BY NAME g_pmc.*   # 顯示單頭值
   CALL q231_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q231_b_fill()                        #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000    #No.FUN-680136 VARCHAR(1000) 
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
        "SELECT rva06,rva01,rvb04,rvb05,ima02,ima021,rvb07,rvb35 ",   #TQC-C70113 add ima02,ima021
        "  FROM rva_file,rvb_file,ima_file ",      #TQC-C70113 add ima_file
        " WHERE rva01=rvb01 AND rvaconf='Y' AND ",
        "       rvb05 = ima01 AND ",   #TQC-C70113 add
        "       rva05= '",g_pmc.pmc01,"' AND  ",tm.wc2 CLIPPED,
        " ORDER BY rva06 DESC"
    PREPARE q231_pb FROM l_sql
    DECLARE q231_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q231_pb
 
    CALL g_rvb.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH q231_bcs INTO g_rvb[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_rvb[g_cnt].rvb07   IS NULL THEN
           LET g_rvb[g_cnt].rvb07   = 0
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    LET g_rec_b=g_cnt-1
END FUNCTION
 
FUNCTION q231_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvb TO s_rvb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         CALL cl_show_fld_cont()                      #No.FUN-560228
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q231_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q231_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q231_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q231_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q231_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
   ON ACTION accept
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
   ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
