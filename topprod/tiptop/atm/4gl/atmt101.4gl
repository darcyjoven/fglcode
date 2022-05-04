# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: atmt101.4gl
# Descriptions...: 撥出單文件資料維護作業
# Date & Author..: 04/11/11 By Carrier
# Modify.........: No.MOD-4B0067 04/11/18 BY DAY  將變數用Like方式定義
# Modify.........: No.FUN-650065 06/05/31 By Tracy axd模塊轉atm模塊   
# Modify.........: No.FUN-660104 06/06/19 By cl Error Message 調整
# Modify.........: No.FUN-680120 06/08/31 By chen 類型轉換
# Modify.........: No.TQC-680107 06/09/08 By elva 無資料時按下按鈕會當出
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/16 By Carrier 新增單頭折疊功能
# Modify.........: No.FUN-980009 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
         g_adg      DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
                    adg09b    LIKE adg_file.adg09,    #撥入工廠
                    adg01b    LIKE adg_file.adg01,    #撥出單號
                    adg02     LIKE adg_file.adg02,    #項次
                    adg05     LIKE adg_file.adg05     #產品編號
                    END RECORD,
         g_wc       string,  #No.FUN-580092 HCN
         g_sql      string,  #No.FUN-580092 HCN
         g_rec_b    LIKE type_file.num5,                #單身筆數        #No.FUN-680120 SMALLINT
         l_ac       LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680120 SMALLINT
DEFINE   g_forupd_sql   STRING   #SELECT ... FOR UPDATE  SQL
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680120 INTEGER
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8           #No.FUN-6B0014
DEFINE   p_row,p_col  LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ATM")) THEN
       EXIT PROGRAM
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW t101_w AT p_row,p_col WITH FORM "atm/42f/atmt101"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
    CALL t101_menu()
    CLOSE WINDOW t101_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION t101_cs()
    CLEAR FORM                             #清除畫面
    CALL g_adg.clear()
    CALL cl_set_head_visible("","YES")  #No.FUN-6B0031
    CONSTRUCT BY NAME g_wc ON adg01,adg09  # 螢幕上取單頭條件
 
        #No.FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(adg01)          #查詢撥出單
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_adg1"    #審核碼為'Y'即可
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO adg01
                   NEXT FIELD adg01
              WHEN INFIELD(adg09)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_azp"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO adg09
                   NEXT FIELD adg09
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
 
       #No.FUN-580031 --start--     HCN
       ON ACTION qbe_select
          CALL cl_qbe_select()
       ON ACTION qbe_save
          CALL cl_qbe_save()
       #No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    LET g_wc = g_wc CLIPPED, " AND adfconf = 'Y'" CLIPPED
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND adfuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND adfgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND adfgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('adfuser', 'adfgrup')
    #End:FUN-980030
 
END FUNCTION
 
FUNCTION t101_menu()
 
   WHILE TRUE
      CALL t101_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t101_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t101_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL t101_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE " SEARCHING ! "
    CALL t101_b_fill(g_wc) #單身
    MESSAGE ""
END FUNCTION
 
FUNCTION t101_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
 
    LET g_sql =
        "SELECT adg09,adg01,adg02,adg05 ",
        "  FROM adf_file,adg_file ",
        " WHERE adf01 = adg01 ",
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY adg09,adg01,adg02 "
 
    PREPARE t101_pb FROM g_sql
    DECLARE adg_curs CURSOR FOR t101_pb
 
    CALL g_adg.clear()
    LET g_cnt = 1
    FOREACH adg_curs INTO g_adg[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_adg.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION t101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_adg TO s_adg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
#No.FUN-6B0031--Begin                                                           
      ON ACTION CONTROLS                                                      
         CALL cl_set_head_visible("","AUTO")                                  
#No.FUN-6B0031--End
 
        #文件維護
        ON ACTION maintain_text
           IF l_ac <> 0 THEN  #TQC-680107 
                  LET g_msg="atmt102 '",g_adg[l_ac].adg01b,"' ",g_adg[l_ac].adg02
                  CALL cl_cmdrun_wait(g_msg)
           END IF
        #復制上筆明細
        ON ACTION copy_previous
           IF l_ac <> 0 THEN  #TQC-680107  
            IF l_ac = 1 THEN
                #上筆無明細資料可供復制!
                CALL cl_err('','axm-911',1)
            ELSE
                CALL t101_copy()
            END IF
           END IF  
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
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
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#復制上筆明細
FUNCTION t101_copy()
  DEFINE l_n   LIKE type_file.num5,          #No.FUN-680120 SMALLINT
         l_oze RECORD LIKE oze_file.*
 
    SELECT COUNT(*) INTO l_n FROM oze_file
     WHERE oze01 = g_adg[l_ac].adg01b
       AND oze02 = g_adg[l_ac].adg02
    IF l_n >= 1 THEN
        #本筆已有明細資料,不可再做復制!
        CALL cl_err('','axm-910',1)
        RETURN
    END IF
    SELECT COUNT(*) INTO l_n FROM oze_file
     WHERE oze01 = g_adg[l_ac-1].adg01b
       AND oze02 = g_adg[l_ac-1].adg02
    IF l_n <= 0 THEN
        #上筆無明細資料可供復制!
        CALL cl_err('','axm-911',1)
        RETURN
    END IF
 
    LET g_sql =
        "SELECT oze03,oze04,oze05,oze06,oze07,oze08,oze09,oze10,oze11 ",
        " FROM oze_file ",
        " WHERE oze01 = '",g_adg[l_ac-1].adg01b,"'",
        "   AND oze02 =  ",g_adg[l_ac-1].adg02,
        " ORDER BY oze03 "
 
    PREPARE t101_p_ins_oze FROM g_sql
    DECLARE t101_ins_oze CURSOR FOR t101_p_ins_oze
 
    INITIALIZE l_oze.* TO NULL
    LET l_oze.oze01 = g_adg[l_ac].adg01b
    LET l_oze.oze02 = g_adg[l_ac].adg02
    LET g_success = 'Y'
    BEGIN WORK
    FOREACH t101_ins_oze INTO l_oze.oze03,l_oze.oze04,l_oze.oze05,l_oze.oze06,
                              l_oze.oze07,l_oze.oze08,l_oze.oze09,l_oze.oze10,
                              l_oze.oze11
        IF STATUS THEN CALL cl_err('foreach t101_ins_oze',STATUS,1) EXIT FOREACH END IF
        LET l_oze.ozeplant = g_plant #FUN-980009 
        LET l_oze.ozelegal = g_legal #FUN-980009
        INSERT INTO oze_file VALUES(l_oze.*)
        IF SQLCA.sqlcode THEN
        #   CALL cl_err("INSERT oze_file",SQLCA.sqlcode,1)    #FUN-660104
            CALL cl_err3("ins","oze_file",l_oze.oze03,"",SQLCA.sqlcode,"","INSERT oze_file",1)  #No.FUN-660104
            LET g_success = 'N'
            EXIT FOREACH
        END IF
    END FOREACH
    IF g_success = 'Y' THEN
        COMMIT WORK
        MESSAGE "INSERT oze_file O.K."
    ELSE
        ROLLBACK WORK
        MESSAGE "INSERT oze_file ERROR"
    END IF
 
END FUNCTION
#Patch....NO.TQC-610037 <001,002> #
