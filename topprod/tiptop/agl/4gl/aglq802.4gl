# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aglq802.4gl
# Descriptions...: 異動碼別異動查詢
# Date & Author..: 92/03/16 By DAVID WANG
# Modify.........: No.MOD-4A0057 04/10/05 By kitty代改 資料有二筆,但是查詢只有一筆資料
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0009 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.MOD-560034 05/06/16 By ching fix筆數
# Moidfy.........: No.FUN-5C0015 06/01/02 By kevin
#                  單頭增加欄位「異動碼類型代號aec052」,FORMONLY.ahe02
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740020 07/04/09 By mike    會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-7B0152 07/11/16 By Carrier 增加aec00和aag00的join 條件
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50051 11/05/12 By xjll 增加科目编号查询功能 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
       	wc     LIKE type_file.chr1000# Head Where condition    #No.FUN-680098 VARCHAR(600)
        END RECORD,
    l_aec  RECORD
            aec00   LIKE aec_file.aec00,   # No.FUN-740020  
            aec051  LIKE aec_file.aec051,
            aec052  LIKE aec_file.aec052,  # No.FUN-5C0015 add
            aec05   LIKE aec_file.aec05
        END RECORD,
    g_aec DYNAMIC ARRAY OF RECORD
            aec02   LIKE aec_file.aec02,
            aec01   LIKE aec_file.aec01,
            aec03   LIKE aec_file.aec03,
            abb07_1 LIKE abb_file.abb07,#借
            abb07_2 LIKE abb_file.abb07,#貸
            abb99   LIKE type_file.num20_6  #餘額  #No.FUN-4C0009   #No.FUN-680098 decimal(20,6)
        END RECORD,
    g_aec01         LIKE type_file.chr20,         #No.FUN-680098  VARCHAR(20) 
     g_wc,g_wc2,g_sql,g_sql1 STRING, #WHERE CONDITION  #No.FUN-580092 HCN       
    g_rec_b LIKE type_file.num5,  		  #單身筆數        #No.FUN-680098 smallint
    l_bal    LIKE type_file.num20_6  #No.FUN-4C0009   #No.FUN-680098  decimal(20,6)
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_msg           LIKE ze_file.ze03            #No.FUN-680098 VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680098 smallint
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0073
      DEFINE    l_sl	        LIKE type_file.num5          #No.FUN-680098  smallint
   DEFINE p_row,p_col	LIKE type_file.num5          #No.FUN-680098 smallint
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
    LET p_row = 1 LET p_col = 1
    OPEN WINDOW aglq802_w AT p_row,p_col
         WITH FORM "agl/42f/aglq802"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    FOR l_sl = 8  TO 20 STEP 1 DISPLAY "" AT l_sl,1 END FOR
 
 
    #No.MOD-7B0152  --Begin
    #CALL s_shwact(0,0,l_aec.aec00)
    ##    IF cl_chk_act_auth() THEN
    ##       CALL q802_q()
    ##    END IF
    #IF NOT cl_null(l_aec.aec00) THEN CALL q802_q() END IF
    #IF cl_null(l_aec.aec00)  THEN LET l_aec.aec00 = g_aaz.aaz64 END IF
    #No.MOD-7B0152  --Begin
 
    CALL q802_menu()
    CLOSE WINDOW aglq802_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION q802_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680098 smallint
 
    CLEAR FORM #清除畫面
   CALL g_aec.clear()
    CALL cl_opmsg('q')
    INITIALIZE tm.* TO NULL			# Default condition
    IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       DISPLAY ''
    ELSE
       DISPLAY "[        ]" AT 8,1
    END IF
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
   INITIALIZE l_aec.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME tm.wc ON  # 螢幕上取單頭條件
              aec00,aec051,aec052,aec05,aec02,aec01       # No.FUN-5C0015 add aec052  # No.FUN-740020 add aec00 #No.FUN-B50051 add aec01 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
      # FUN-5C0015 (s)
      ON ACTION controlp
         CASE
           #No.FUN-740020 --BEGIN--
           WHEN INFIELD(aec00)  #帳套
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_aaa"
              LET g_qryparam.state="c"
              CALL cl_create_qry() RETURNING  g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aec00
              NEXT FIELD aec00
           #No.FUN-740020 --END--
           WHEN INFIELD(aec052) #異動碼類型代號
              CALL cl_init_qry_var()
              LET g_qryparam.form     = "q_ahe"
              LET g_qryparam.state    = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aec052
              NEXT FIELD aec052
           #No.FUN-B50051--str--
            WHEN INFIELD(aec01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_aag"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO aec01
                   NEXT FIELD aec01
           #No.FUN-B50051--end--
           OTHERWISE EXIT CASE
         END CASE
      # FUN-5C0015 (e)
 
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
    DISPLAY "" AT  8,1
    IF INT_FLAG THEN RETURN END IF
 
    #====>資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
    #End:FUN-980030
 
   #FUN-5C0015(S)---
   #LET g_sql=" SELECT UNIQUE aec051,aec05  FROM aec_file,aag_file  ",
    LET g_sql=" SELECT UNIQUE aec00,aec051,aec052,aec05  FROM aec_file,aag_file  ",  # No.FUN-740020 
   #FUN-5C0015(E)---
              " WHERE ",tm.wc CLIPPED,
    #         " AND aec00 = '",l_aec.aec00,"'",     # No.FUN-740020   #No.MO-7B0152
              " AND aec01 = aag01 ",
              " AND aec00 = aag00 ",                #No.MOD-7B0152
              " ORDER BY aec00,aec051,aec052,aec05 " #FUN-5C0015 Add aec052   # No.FUN-740020 add aec00
    PREPARE q802_prepare FROM g_sql
    DECLARE q802_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q802_prepare
 {No.MOD-4A0057
    LET g_sql=" SELECT UNIQUE aec051,aec05  FROM aec_file,aag_file ",
              " WHERE ",tm.wc CLIPPED,
              " AND aec00 = '",l_aec.aec00,"'",
              " AND aec01 = aag01 ",
              " ORDER BY aec051,aec05 ",
              "  INTO TEMP x "
    DROP TABLE x
    PREPARE q802_precount_x FROM g_sql
    EXECUTE q802_precount_x
 
        LET g_sql="SELECT COUNT(*) FROM x "
}
 
{
    #MOD-4A0057 add
    LET g_sql="SELECT COUNT(DISTINCT aec01) FROM aec_file ",
             " WHERE ",tm.wc CLIPPED,
             "   AND aec00 = '",l_aec.aec00,"'"
 
    PREPARE q802_precount FROM g_sql
    DECLARE q802_count CURSOR FOR q802_precount
}
 
     #MOD-560034
    DROP TABLE count_tmp
    LET g_sql="SELECT aec00,aec051,aec052,aec05 ",     #FUN-5C0015 Add aec052   # No.FUN-740020 add aec00
              "  FROM aec_file,aag_file ",
              " WHERE ",tm.wc CLIPPED,
            # "   AND aec00 = '",l_aec.aec00,"'",       # No.FUN-740020   #No.MO-7B0152
              "   AND aec01 = aag01 ",
              "   AND aec00 = aag00 ",                  #No.MOD-7B0152
              " GROUP BY aec00,aec051,aec052,aec05 ",  #FUN-5C0015 Add aec052      # No.FUN-740020 
              " INTO TEMP count_tmp"
    PREPARE q802_cnt_tmp  FROM g_sql
    EXECUTE q802_cnt_tmp
    DECLARE q802_count CURSOR FOR SELECT COUNT(*) FROM count_tmp
    #--
 
 
END FUNCTION
 
FUNCTION q802_b_askkey()
   LET l_bal =0
    IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       DISPLAY ''
    ELSE
       DISPLAY "[        ]" AT 8,1
    END IF
END FUNCTION
 
FUNCTION q802_menu()
 
   WHILE TRUE
      CALL q802_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q802_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aec),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q802_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q802_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q802_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q802_count
       FETCH q802_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q802_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q802_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098  VARCHAR(1) 
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680098 integer
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q802_cs INTO l_aec.aec00,    #No.FUN-740020 
                                             l_aec.aec051,
                                             l_aec.aec052,   #FUN-5C0015
                                             l_aec.aec05
        WHEN 'P' FETCH PREVIOUS q802_cs INTO l_aec.aec00,    # No.FUN-740020 
                                             l_aec.aec051,
                                             l_aec.aec052,   #FUN-5C0015
                                             l_aec.aec05
        WHEN 'F' FETCH FIRST    q802_cs INTO l_aec.aec00,    # No.FUN-740020 
                                             l_aec.aec051,
                                             l_aec.aec052,   #FUN-5C0015
                                             l_aec.aec05
        WHEN 'L' FETCH LAST     q802_cs INTO l_aec.aec00,    # No.FUN-740020
                                             l_aec.aec051,
                                             l_aec.aec052,   #FUN-5C0015
                                             l_aec.aec05
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
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
            FETCH ABSOLUTE g_jump q802_cs INTO l_aec.aec00,   # No.FUN-740020
                                               l_aec.aec051,
                                               l_aec.aec052,  #FUN-5C0015
                                               l_aec.aec05
 
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(l_aec.aec05,SQLCA.sqlcode,0)
        INITIALIZE l_aec.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    CALL q802_show()
END FUNCTION
 
FUNCTION q802_show()
 DEFINE l_ahe02 LIKE ahe_file.ahe02  #FUN-5C0015
  #FUN-5C0015(S)---------
   SELECT ahe02 INTO l_ahe02 FROM ahe_file
     WHERE ahe01 = l_aec.aec052
   IF SQLCA.sqlcode THEN LET l_ahe02 = '' END IF
  #FUN-5C0015(E)---------
   DISPLAY l_aec.aec00  TO aec00     # No.FUN-740020 
   DISPLAY l_aec.aec051 TO aec051   # 顯示單頭值
   DISPLAY l_aec.aec05  TO aec05     # 顯示單頭值
   DISPLAY l_aec.aec052 TO aec052   # No.FUN-5C0015 add
   DISPLAY l_ahe02 TO ahe02         # No.FUN-5C0015 add
   CALL q802_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q802_b_fill()              #BODY FILL UP
   DEFINE
   l_sql     LIKE type_file.chr1000,#No.FUN-680098  VARCHAR(400) 
   l_abb06   LIKE abb_file.abb06,
   l_abb07   LIKE abb_file.abb07
 
   LET l_sql =
        "SELECT aec02, aec01, aec03, 0,0,0,abb06,abb07",
        " FROM  aec_file , abb_file ",
        " WHERE aec00 = '",l_aec.aec00,"'",       # No.FUN-740020 
		" AND aec00 = abb00 ",
		" AND aec051= '",l_aec.aec051,"'",
		" AND aec05 = '",l_aec.aec05,"'",
		" AND abb00 = aec00 AND abb01 = aec03 AND abb02 = aec04 ",
		" AND ",tm.wc CLIPPED,
         " ORDER BY 1 "
    PREPARE q802_pb FROM l_sql
    DECLARE q802_bcs                       #BODY CURSOR
        CURSOR FOR q802_pb
    CALL g_aec.clear()
    LET l_bal = 0
    LET g_rec_b=0
    LET g_cnt = 1
    LET l_abb06 = NULL
    LET l_abb07 = NULL
    FOREACH q802_bcs INTO g_aec[g_cnt].*,l_abb06,l_abb07
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF l_abb06 = '1' THEN
            LET g_aec[g_cnt].abb07_1 = l_abb07  #借
            LET g_aec[g_cnt].abb07_2 = NULL
            LET l_bal = l_bal + l_abb07
        ELSE
            LET g_aec[g_cnt].abb07_1 = NULL
            LET g_aec[g_cnt].abb07_2 = l_abb07  #貸
            LET l_bal = l_bal - l_abb07
        END IF
        LET g_aec[g_cnt].abb99 = l_bal
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_aec.deleteElement(g_cnt)
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q802_bp(p_ud)
   DEFINE   p_ud   LIKE    type_file.chr1            #No.FUN-680098  VARCHAR(1) 
   DEFINE   l_i,l_j,l_ds   LIKE type_file.num5       #No.FUN-680098  smallint
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aec TO s_aec.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
     #BEFORE ROW
         #LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q802_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q802_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q802_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q802_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q802_fetch('L')
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
     #LET l_ac = ARR_CURR()
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
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
