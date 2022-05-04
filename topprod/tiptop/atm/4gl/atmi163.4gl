# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: atmi163.4gl
# Descriptions...: 集團銷售預測目標調整作業 
# Date & Author..: 06/03/17 By Sarah
# Modify.........: No.FUN-620032 06/03/17 By Sarah 新增"集團銷售預測目標調整作業 "
# Modify.........: No.FUN-630092 06/03/30 By Sarah 修改i163_bc1的SQL寫法
# Modify.........: No.MOD-640439 06/04/12 By Sarah 總計金額沒Show
# Modify.........: No.FUN-640192 06/04/17 By Sarah 當是最上層組織,而且單頭目標金額為0時,單頭的目標金額應default=單身加總
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-640268 06/06/05 By Sarah 增加ACTION"目標自動展開"
# Modify.........: No.FUN-660104 06/06/21 By day   cl_err --> cl_err3
# Modify.........: No.TQC-670087 06/07/25 By Sarah 圖形顯示CALL cl_set_field_pic(g_odc.odc22,"","","","","")->CALL cl_set_field_pic(g_odc.odc13,"","","","","")
# Modify.........: No.FUN-680047 06/08/16 By Sarah 確認訊息加強(告知是何原因導致無法做確認、取消確認)
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: Mo.FUN-6A0072 06/10/24 By xumin g_no_ask改mi_no_ask    
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0043 06/11/14 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0031 06/11/16 By Carrier 新增單頭折疊功能
# Modify.........: Mo.TQC-6C0217 06/12/30 By Rayven 無單身時點“目標金額調整”action時程序當出
# Modify.........: Mo.TQC-740338 07/04/27 By sherry 查詢時狀態欄位不能錄入查詢條件。
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE   g_odc1         DYNAMIC ARRAY OF RECORD
                         odc02_1  LIKE odc_file.odc02,
                         tqb02_1  LIKE tqb_file.tqb02,
                         ode05a_s LIKE ode_file.ode05,
                         ode14_s  LIKE ode_file.ode14,
                         odc11_1  LIKE odc_file.odc11
                        END RECORD
DEFINE   g_odc1_t       RECORD
                         odc02_1  LIKE odc_file.odc02,
                         tqb02_1  LIKE tqb_file.tqb02,
                         ode05a_s LIKE ode_file.ode05,
                         ode14_s  LIKE ode_file.ode14,
                         odc11_1  LIKE odc_file.odc11
                        END RECORD
DEFINE   g_odc          RECORD LIKE odc_file.*,
         g_odc_t        RECORD LIKE odc_file.*,
         g_odc01_t      LIKE odc_file.odc01,
         g_odc02_t      LIKE odc_file.odc02,
         g_odc02        LIKE odc_file.odc02,
         g_wc,g_wc2     STRING,  #No.FUN-580092 HCN
         g_sql          STRING,  #No.FUN-580092 HCN
         g_rec_b        LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   p_row,p_col    LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   g_b_flag       LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_i            LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   g_before_input_done  LIKE type_file.num5    #No.FUN-680120 SMALLINT
DEFINE   g_forupd_sql   STRING
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE   l_ac           LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   g_cnt          LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680120 SMALLINT   #No.FUN-6A0072
 
MAIN
#     DEFINE   l_time   LIKE type_file.chr8          #No.FUN-6B0014
 
   OPTIONS                               #改變一些系統預設值
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
 
 
   LET g_forupd_sql= " SELECT * FROM odc_file WHERE odc01 = ? AND odc02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i163_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 2  LET p_col = 9 
   OPEN WINDOW i163_w AT p_row,p_col WITH FORM "atm/42f/atmi163"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL i163_menu()
 
   CLOSE WINDOW i163_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION i163_cs()
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM                             #清除畫面
   LET g_action_choice=" "
   CALL cl_set_head_visible("","YES")  #No.FUN-6B0031
   INITIALIZE g_odc.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON              # 螢幕上取單頭條件
             odc01,odc02,odc04,odc05,odc06,odc07,odc08,odc09,
             odc10,odc11,odc12,odc121,odc13,odc131,
             odcuser,odcgrup,odcmodu,odcdate      #No.TQC-740338   
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION controlp
         CASE WHEN INFIELD(odc01)   #預測版本
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form     = "q_odb"
                   LET g_qryparam.default1 = g_odc.odc01
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO odc01
                   NEXT FIELD odc01
              WHEN INFIELD(odc02)   #組織代號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form     = "q_tqd03"
                   LET g_qryparam.default1 = g_odc.odc02
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO odc02
                   NEXT FIELD odc02
              WHEN INFIELD(odc07)   #業務員
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form     = "q_gen"
                   LET g_qryparam.default1 = g_odc.odc07
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO odc07
                   NEXT FIELD odc07
              WHEN INFIELD(odc08)   #部門
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form     = "q_gem"
                   LET g_qryparam.default1 = g_odc.odc08
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO odc08
                   NEXT FIELD odc08
              WHEN INFIELD(odc09)   #幣別
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form     = "q_azi"
                   LET g_qryparam.default1 = g_odc.odc09
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO odc09
                   NEXT FIELD odc09
              OTHERWISE EXIT CASE
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
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT CONSTRUCT
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT CONSTRUCT
 
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
   END CONSTRUCT
 
   IF INT_FLAG OR g_action_choice = "exit" THEN    #MOD-4B0238 add 'exit'
      RETURN
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND odcuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND odcgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND odcgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('odcuser', 'odcgrup')
   #End:FUN-980030
 
   LET g_sql = "SELECT odc01,odc02 FROM odc_file",
               " WHERE odc12='Y' AND odc121='Y'  AND ", g_wc CLIPPED,
               " ORDER BY odc01,odc02"
   PREPARE i163_prepare FROM g_sql
   DECLARE i163_cs SCROLL CURSOR WITH HOLD FOR i163_prepare
 
   LET g_sql = "SELECT COUNT(*) FROM odc_file",
               " WHERE odc12='Y' AND odc121='Y' AND ", g_wc CLIPPED
   PREPARE i163_precount FROM g_sql
   DECLARE i163_count CURSOR FOR i163_precount
END FUNCTION
 
FUNCTION i163_menu()
 
   WHILE TRUE
      IF g_action_choice = "exit"  THEN
         EXIT WHILE
      END IF
 
      CALL i163_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i163_q()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i163_u()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         #@WHEN "目標金額調整"
         WHEN "adjust_target_amt"
            IF cl_chk_act_auth() THEN
               CALL i163_adjust_target_amt()
            END IF
 
         #@WHEN "目標自動展開"
         WHEN "auto_expand_target"
            IF cl_chk_act_auth() THEN
               CALL i163_auto_expand_target()
            END IF
 
         #@WHEN "目標金額調整確認"
         WHEN "confirm_target_amt_adjust"
            IF cl_chk_act_auth() THEN
               CALL i163_y()
            END IF
 
         #@WHEN "目標金額調整取消確認"
         WHEN "undo_confirm_target_amt_adjust"
            IF cl_chk_act_auth() THEN
               CALL i163_z()
            END IF
         #No.FUN-6B0043-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_odc.odc01 IS NOT NULL THEN
                LET g_doc.column1 = "odc01"
                LET g_doc.column2 = "odc02"
                LET g_doc.value1 = g_odc.odc01
                LET g_doc.value2 = g_odc.odc02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6B0043-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i163_u()
   DEFINE l_odb07  LIKE odb_file.odb07
 
   IF s_shut(0) THEN RETURN END IF
   IF g_odc.odc01 IS NULL OR g_odc.odc02 IS NULL THEN 
      CALL cl_err('',-400,2) RETURN 
   END IF
   SELECT * INTO g_odc.* FROM odc_file WHERE odc01 = g_odc.odc01 AND odc02 = g_odc.odc02
   IF g_odc.odc13='Y' THEN CALL cl_err('','9022',0) RETURN END IF
   #如果不是最上層組織,不得維護單頭目標金額
   SELECT odb07 INTO l_odb07 FROM odb_file WHERE odb01 = g_odc.odc01
   IF g_odc.odc02 != l_odb07 THEN RETURN END IF
 
   LET g_success = 'Y'
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_odc01_t = g_odc.odc01
   LET g_odc02_t = g_odc.odc02
   LET g_odc_t.* = g_odc.*
   BEGIN WORK
   OPEN i163_cl USING g_odc.odc01,g_odc.odc02
   FETCH i163_cl INTO g_odc.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i163_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   CALL i163_show()
   WHILE TRUE
      LET g_odc01_t = g_odc.odc01
      LET g_odc02_t = g_odc.odc02
      LET g_odc.odcmodu=g_user
      LET g_odc.odcdate=g_today
      CALL i161_i("u")                      #欄位更改
      IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_odc.*=g_odc_t.*
          CALL i163_show()
          CALL cl_err('','9001',0)
          EXIT WHILE
      END IF
      UPDATE odc_file SET odc_file.* = g_odc.* WHERE odc01 = g_odc01_t AND odc02 = g_odc02_t
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)  #No.FUN-660104
         CALL cl_err3("upd","odc_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i163_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i161_i(p_cmd)
   DEFINE  p_cmd      LIKE type_file.chr1                 #處理狀態        #No.FUN-680120 VARCHAR(1)
 
   DISPLAY BY NAME
      g_odc.odc01,g_odc.odc02, g_odc.odc04,g_odc.odc05, g_odc.odc06,
      g_odc.odc07,g_odc.odc08, g_odc.odc09,g_odc.odc10, g_odc.odc11,
      g_odc.odc12,g_odc.odc121,g_odc.odc13,g_odc.odc131,
      g_odc.odcuser,g_odc.odcgrup,g_odc.odcmodu,g_odc.odcdate
 
   CALL cl_set_head_visible("","YES")  #No.FUN-6B0031
   INPUT BY NAME g_odc.odc11 WITHOUT DEFAULTS
 
       AFTER FIELD odc11   #目標金額
           IF cl_null(g_odc.odc11) OR g_odc.odc11 < 0 THEN
              CALL cl_err('','mfg5034',1)
              NEXT FIELD odc11
           END IF
 
       #MOD-650015 --start
       #ON ACTION CONTROLO                        # 沿用所有欄位
       #    IF INFIELD(odc01) THEN
       #       LET g_odc.* = g_odc_t.*
       #       CALL i163_show()
       #       NEXT FIELD odc01
       #    END IF
       #MOD-650015 --end
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF                        # 欄位說明
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
END FUNCTION
 
FUNCTION i163_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_odc.* TO NULL               #No.FUN-6B0043 
   LET g_rec_b = 0
   DISPLAY g_rec_b TO cn2
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL i163_cs()
   IF INT_FLAG OR g_action_choice="exit" THEN
      LET INT_FLAG = 0
      INITIALIZE g_odc.* TO NULL
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! "
   OPEN i163_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_odc.* TO NULL
   ELSE
      OPEN i163_count
      FETCH i163_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      SELECT odc01 INTO g_odc.odc01 FROM odc_file 
       WHERE odc01 = g_odc.odc01 AND odc02 = g_odc.odc02
      CALL i163_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION i163_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,                 #處理方式        #No.FUN-680120 VARCHAR(1)
            l_abso   LIKE type_file.num10                 #絕對的筆數      #No.FUN-680120 INTEGER
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i163_cs INTO g_odc.odc01,g_odc.odc02
      WHEN 'P' FETCH PREVIOUS i163_cs INTO g_odc.odc01,g_odc.odc02
      WHEN 'F' FETCH FIRST    i163_cs INTO g_odc.odc01,g_odc.odc02
      WHEN 'L' FETCH LAST     i163_cs INTO g_odc.odc01,g_odc.odc02
      WHEN '/'
         IF (NOT mi_no_ask) THEN   #No.FUN-6A0072
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
         FETCH ABSOLUTE g_jump i163_cs INTO g_odc.odc01,g_odc.odc02
         LET mi_no_ask = FALSE   #No.FUN-6A0072
   END CASE
 
   IF SQLCA.sqlcode THEN
      INITIALIZE g_odc.* TO NULL
      CALL g_odc1.clear()
      CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)
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
   SELECT * INTO g_odc.* FROM odc_file WHERE odc01 = g_odc.odc01 AND odc02 = g_odc.odc02
   IF SQLCA.sqlcode THEN
      INITIALIZE g_odc.* TO NULL
      CALL g_odc1.clear()
#     CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)  #No.FUN-660104
      CALL cl_err3("sel","odc_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
      RETURN
   END IF
 
   CALL i163_show()
END FUNCTION
 
FUNCTION i163_show()
   DEFINE l_odb02    LIKE odb_file.odb02
   DEFINE l_tqb02    LIKE tqb_file.tqb02
   DEFINE l_gen02    LIKE gen_file.gen02
   DEFINE l_gem02    LIKE gem_file.gem02
   DEFINE l_ode14_1  LIKE ode_file.ode14
 
   DISPLAY BY NAME
      g_odc.odc01,g_odc.odc02, g_odc.odc04,g_odc.odc05, g_odc.odc06,
      g_odc.odc07,g_odc.odc08, g_odc.odc09,g_odc.odc10, g_odc.odc11,
      g_odc.odc12,g_odc.odc121,g_odc.odc13,g_odc.odc131,
      g_odc.odcuser,g_odc.odcgrup,g_odc.odcmodu,g_odc.odcdate
 
   #圖形顯示
   CALL cl_set_field_pic(g_odc.odc13,"","","","","")
 
   SELECT odb02 INTO l_odb02 FROM odb_file WHERE odb01=g_odc.odc01
   IF STATUS THEN LET l_odb02 = '' END IF
   DISPLAY l_odb02 TO FORMONLY.odb02
 
   SELECT tqb02 INTO l_tqb02 FROM tqb_file WHERE tqb01=g_odc.odc02
   IF STATUS THEN LET l_tqb02 = '' END IF
   DISPLAY l_tqb02 TO FORMONLY.tqb02
 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_odc.odc07
   IF STATUS THEN LET l_gen02 = '' END IF
   DISPLAY l_gen02 TO FORMONLY.gen02
 
   SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=g_odc.odc08
   IF STATUS THEN LET l_gem02 = '' END IF
   DISPLAY l_gem02 TO FORMONLY.gem02
 
   SELECT SUM(ode14) INTO l_ode14_1 FROM ode_file
    WHERE ode01=g_odc.odc01 AND ode02=g_odc.odc02
   IF STATUS THEN LET l_ode14_1 = 0 END IF
   DISPLAY l_ode14_1 TO FORMONLY.ode14_1
 
   CALL i163_b_fill()
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i163_b_fill()
   DEFINE l_tot1   LIKE type_file.num20_6,      #No.FUN-680120 DEC(20,6)   #歷史金額總計      #MOD-640439 add
          l_tot2   LIKE type_file.num20_6,      #No.FUN-680120 DEC(20,6)   #預測總金額總計    #MOD-640439 add
          l_tot3   LIKE type_file.num20_6       #No.FUN-680120 DEC(20,6)   #目標金額總計      #MOD-640439 add
 
   DECLARE i163_1_c1 CURSOR FOR
      SELECT odc02,tqb02,SUM(ode05*ode10),SUM(ode14),odc11
        FROM odc_file,tqb_file,ode_file
       WHERE odc01 = g_odc.odc01
         AND odc02 IN (SELECT tqd03 FROM odc_file,tqd_file
                        WHERE odc01 = g_odc.odc01 AND odc02 = g_odc.odc02
                          AND odc02 = tqd01)
         AND odc02 = tqb01
         AND odc01 = ode01 AND odc02 = ode02
       GROUP BY odc02,tqb02,odc11
       ORDER BY odc02
 
   CALL g_odc1.clear()
   LET l_tot1 = 0    #MOD-640439 add
   LET l_tot2 = 0    #MOD-640439 add
   LET l_tot3 = 0    #MOD-640439 add
 
   LET g_rec_b = 0
   LET g_cnt=1
   FOREACH i163_1_c1 INTO g_odc1[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(g_odc1[g_cnt].ode05a_s) THEN LET g_odc1[g_cnt].ode05a_s = 0 END IF
      IF cl_null(g_odc1[g_cnt].ode14_s) THEN LET g_odc1[g_cnt].ode14_s = 0 END IF
      IF cl_null(g_odc1[g_cnt].odc11_1) THEN LET g_odc1[g_cnt].odc11_1 = 0 END IF
      LET l_tot1 = l_tot1 + g_odc1[g_cnt].ode05a_s    #MOD-640439 add
      LET l_tot2 = l_tot2 + g_odc1[g_cnt].ode14_s     #MOD-640439 add
      LET l_tot3 = l_tot3 + g_odc1[g_cnt].odc11_1     #MOD-640439 add
      LET g_cnt = g_cnt + 1
      #TQC-630107---add---
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      #TQC-630107---end---
   END FOREACH
   CALL g_odc1.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   DISPLAY l_tot1,l_tot2,l_tot3 TO FORMONLY.tot1,FORMONLY.tot2,FORMONLY.tot3    #MOD-640439 add
 
END FUNCTION
 
FUNCTION i163_adjust_target_amt()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
   l_qty           LIKE type_file.num10,            #No.FUN-680120  INTEGER            #
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680120 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680120 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680120 SMALLINT
   l_allow_delete  LIKE type_file.num5,                #可刪除否          #No.FUN-680120 SMALLINT
   l_cnt           LIKE type_file.num5,                #MOD-5C0031        #No.FUN-680120 SMALLINT
   l_odc13         LIKE odc_file.odc13,
   l_odb07         LIKE odb_file.odb07    #FUN-640192 add
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_odc.odc01 IS NULL OR g_odc.odc02 IS NULL THEN RETURN END IF
   SELECT odc13 INTO l_odc13 FROM odc_file
#   WHERE odc01=g_odc.odc01 AND odc02=g_odc02      #No.TQC-6C0217 mark
    WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02  #No.TQC-6C0217
   IF l_odc13 ='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql =
      #start FUN-630092
      #"SELECT odc02,'',SUM(ode05*ode10),SUM(ode14),odc11 ",
      #"  FROM odc_file,ode_file ",
      #"  WHERE odc01 = ? AND odc02 = ? ",
      #"   AND odc01 = ode01 AND odc02 = ode02 ",
      #"   FOR UPDATE "
       "SELECT odc02,'','','',odc11 ",
       "  FROM odc_file ",
       "  WHERE odc01 = ? AND odc02 = ? ",
       "   FOR UPDATE "
      #end FUN-630092
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i163_bc1 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_odc1 WITHOUT DEFAULTS FROM s_odc1.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
       BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           BEGIN WORK
 
           OPEN i163_cl USING g_odc.odc01,g_odc.odc02
           IF STATUS THEN
              CALL cl_err("OPEN i163_cl:", STATUS, 1)
              CLOSE i163_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH i163_cl INTO g_odc.*               # 對DB鎖定
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b>=l_ac THEN
              LET g_odc1_t.* = g_odc1[l_ac].*  #BACKUP
              LET p_cmd='u'
 
              OPEN i163_bc1 USING g_odc.odc01,g_odc1_t.odc02_1
              IF STATUS THEN
                 CALL cl_err("OPEN i163_bc1:", STATUS, 1)
                 CLOSE i163_bc1
                 ROLLBACK WORK
                 RETURN
              END IF
              FETCH i163_bc1 INTO g_odc1[l_ac].*
              IF SQLCA.sqlcode THEN
                  CALL cl_err(g_odc1_t.odc02_1,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
              END IF
             #start FUN-630092 add
              SELECT SUM(ode05*ode10),SUM(ode14) 
                INTO g_odc1[l_ac].ode05a_s,g_odc1[l_ac].ode14_s
                FROM odc_file,ode_file
               WHERE odc01 = g_odc.odc01 AND odc02 = g_odc1[l_ac].odc02_1
                 AND odc01 = ode01 AND odc02 = ode02 
              DISPLAY BY NAME g_odc1[l_ac].ode05a_s,g_odc1[l_ac].ode14_s
              SELECT tqb02 INTO g_odc1[l_ac].tqb02_1 FROM tqb_file
               WHERE tqb01=g_odc1[l_ac].odc02_1
              DISPLAY BY NAME g_odc1[l_ac].odc02_1
             #end FUN-630092 add
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_odc1[l_ac].* = g_odc1_t.*
              CLOSE i163_bc1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_odc1[l_ac].odc02_1,-263,1)
              LET g_odc1[l_ac].* = g_odc1_t.*
           ELSE
              UPDATE odc_file SET odc11 = g_odc1[l_ac].odc11_1
               WHERE odc01=g_odc.odc01 AND odc02=g_odc1_t.odc02_1
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_odc1[l_ac].odc02_1,SQLCA.sqlcode,0) #No.FUN-660104
                 CALL cl_err3("upd","odc_file",g_odc.odc01,g_odc1_t.odc02_1,SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 LET g_odc1[l_ac].* = g_odc1_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
       AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           CALL g_odc1.deleteElement(g_rec_b+1) #MOD-490200
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_odc1[l_ac].* = g_odc1_t.*
              END IF
              CLOSE i163_bc1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i163_bc1
           COMMIT WORK
 
       AFTER FIELD odc11_1
           IF g_odc1[l_ac].odc11_1 < 0 THEN
              CALL cl_err(g_odc1[l_ac].odc11_1,'mfg5034',1)
              NEXT FIELD odc11
           END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
#NO.FUN-6B0031--BEGIN                                                                                                               
       ON ACTION CONTROLS                                                                                                          
          CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END   
   END INPUT
 
  #start FUN-640192 add
   #當是最上層組織,而且單頭目標金額為0時,單頭的目標金額應default=單身加總
   SELECT odb07 INTO l_odb07 FROM odb_file WHERE odb01 = g_odc.odc01
   IF g_odc.odc02 = l_odb07 AND g_odc.odc11 = 0 THEN
      SELECT SUM(odc11) INTO g_odc.odc11 FROM odc_file
       WHERE odc01 = g_odc.odc01
         AND odc02 IN (SELECT tqd03 FROM odc_file,tqd_file
                        WHERE odc01 = g_odc.odc01 AND odc02 = g_odc.odc02
                          AND odc02 = tqd01)
      UPDATE odc_file SET odc11=g_odc.odc11
       WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('upd odc_file',SQLCA.SQLCODE,0)  #No.FUN-660104
         CALL cl_err3("upd","odc_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","upd odc_file",1)  #No.FUN-660104
      END IF
      DISPLAY BY NAME g_odc.odc11
   END IF
  #end FUN-640192 add
 
   CLOSE i163_bc1
   COMMIT WORK
END FUNCTION
 
FUNCTION i163_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_odc1 TO s_odc1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
#No.FUN-6B0031--Begin                                                           
      ON ACTION CONTROLS                                                      
         CALL cl_set_head_visible("","AUTO")                                  
#No.FUN-6B0031--End
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i163_fetch('F')
         EXIT DISPLAY
 
      ON ACTION previous
         CALL i163_fetch('P')
         EXIT DISPLAY
 
      ON ACTION jump
         CALL i163_fetch('/')
         EXIT DISPLAY
 
      ON ACTION next
         CALL i163_fetch('N')
         EXIT DISPLAY
 
      ON ACTION last
         CALL i163_fetch('L')
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         #圖形顯示
         CALL cl_set_field_pic(g_odc.odc13,"","","","","")   #TQC-670087 modify
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      #@WHEN "目標金額調整"
      ON ACTION adjust_target_amt
         LET g_action_choice="adjust_target_amt"
#        LET g_odc02 = g_odc1[l_ac].odc02_1  #No.TQC-6C0217 mark
         LET g_odc02 = g_odc1[1].odc02_1     #No.TQC-6C0217
         EXIT DISPLAY
 
      #@WHEN "目標自動展開"
      ON ACTION auto_expand_target
         LET g_action_choice="auto_expand_target"
         EXIT DISPLAY
 
      #@WHEN "目標金額調整確認"
      ON ACTION confirm_target_amt_adjust
         LET g_action_choice="confirm_target_amt_adjust"
         EXIT DISPLAY
 
      #@WHEN "目標金額調整取消確認"
      ON ACTION undo_confirm_target_amt_adjust
         LET g_action_choice="undo_confirm_target_amt_adjust"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6B0043  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i163_y()
   DEFINE l_odc12   LIKE odc_file.odc12,
          l_odc121  LIKE odc_file.odc121,
          l_odc13   LIKE odc_file.odc13,
          l_tqd03   LIKE tqd_file.tqd03
 
   IF s_shut(0) THEN RETURN END IF
   IF g_odc.odc01 IS NULL OR g_odc.odc02 IS NULL THEN RETURN END IF
 
   #當下層的預測確認碼皆為Y、調整確認碼皆為Y時,才可做調整確認
   DECLARE i163_y_c1 CURSOR FOR
      SELECT odc12,odc121,odc13 FROM odc_file
       WHERE odc01 = g_odc.odc01
         AND odc02 IN
             (SELECT tqd03 FROM odc_file,tqd_file
               WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02 AND odc02=tqd01)
   LET g_success = 'Y'
   FOREACH i163_y_c1 INTO l_odc12,l_odc121,l_odc13
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #檢查預測確認碼odc12
      IF l_odc12  = 'N' THEN
         #尚有未執行預測確認之下層組織,請先執行下層組織之預測確認!
         CALL cl_err('','atm-552',1)   #FUN-680047 add
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      #檢查調整確認碼odc121
      IF l_odc121 = 'N' THEN
         #尚未執行過上層調整確認,請先執行atmi162的上層調整確認!
         CALL cl_err('','atm-554',1)   #FUN-680047 add
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      #檢查目標金額確認碼odc13
      IF l_odc13 = 'Y' THEN
         #此筆資料已確認
         CALL cl_err('','9023',1)   #FUN-680047 add
         LET g_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH
   IF g_success = 'N' THEN RETURN END IF
 
   IF cl_confirm('axm-108') THEN
      MESSAGE "WORKING !"
      BEGIN WORK
 
      OPEN i163_cl USING g_odc.odc01,g_odc.odc02
      FETCH i163_cl INTO g_odc.*            # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
         CLOSE i163_cl ROLLBACK WORK RETURN
      END IF
 
      IF g_success = 'Y' THEN
         DECLARE i163_y_c2 CURSOR FOR
            SELECT tqd03 FROM odc_file,tqd_file
             WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02 AND odc02=tqd01
         FOREACH i163_y_c2 INTO l_tqd03
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            UPDATE odc_file SET odc13='Y'
             WHERE odc01=g_odc.odc01 AND odc02=l_tqd03
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#              CALL cl_err('upd odc_file',SQLCA.SQLCODE,0) #No.FUN-660104
               CALL cl_err3("upd","odc_file",g_odc.odc01,l_tqd03,SQLCA.sqlcode,"","upd odc_file",1)  #No.FUN-660104
               LET g_success='N'
               EXIT FOREACH      #No.TQC-6C0217 
            END IF
         END FOREACH
      END IF                     #No.TQC-6C0217                                                                                     
      IF g_success = 'Y' THEN    #No.TQC-6C0217
         #如果是最上層,將本層的目標金額確認碼寫成Y
         SELECT COUNT(*) INTO g_cnt FROM odb_file
          WHERE odb01=g_odc.odc01 AND odb07=g_odc.odc02
         IF g_cnt != 0 THEN
            UPDATE odc_file SET odc13='Y'
             WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#              CALL cl_err('upd odc_file',SQLCA.SQLCODE,0) #No.FUN-660104
               CALL cl_err3("upd","odc_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","upd odc_file",1)  #No.FUN-660104
               LET g_success='N'
            END IF
         END IF
      END IF
 
      CLOSE i163_cl
      IF g_success='N' THEN
         ROLLBACK WORK RETURN
      ELSE
         COMMIT WORK
         CALL cl_cmmsg(1)
      END IF
 
      SELECT * INTO g_odc.* FROM odc_file
       WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02
      DISPLAY BY NAME g_odc.odc13
   END IF
   CALL cl_set_field_pic(g_odc.odc13,"","","","","")
END FUNCTION
 
FUNCTION i163_z()
   DEFINE l_odc13   LIKE odc_file.odc13,
          l_odc131  LIKE odc_file.odc131,
          l_tqd03   LIKE tqd_file.tqd03
 
   IF s_shut(0) THEN RETURN END IF
   IF g_odc.odc01 IS NULL OR g_odc.odc02 IS NULL THEN RETURN END IF
 
   #當下層的目標金額確認碼皆為Y時,才可做取消目標金額確認
   DECLARE i163_z_c1 CURSOR FOR
      SELECT odc13,odc131 FROM odc_file
       WHERE odc01 = g_odc.odc01
         AND odc02 IN
             (SELECT tqd03 FROM odc_file,tqd_file
               WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02 AND odc02=tqd01)
   LET g_success = 'Y'
   FOREACH i163_z_c1 INTO l_odc13,l_odc131
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #檢查目標金額確認碼odc13
      IF l_odc13 = 'N' THEN
         #尚未執行過目標金額調整確認,不可取消確認!
         CALL cl_err('','atm-555',1)   #FUN-680047 add
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      #檢查目標數量確認碼odc131
      IF l_odc131 = 'Y' THEN
         #已執行目標數量確認,不可執行目標金額調整取消確認!
         CALL cl_err('','atm-556',1)   #FUN-680047 add
         LET g_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH
   IF g_success = 'N' THEN RETURN END IF
 
   IF cl_confirm('aap-224') THEN
      MESSAGE "WORKING !"
      BEGIN WORK
 
      OPEN i163_cl USING g_odc.odc01,g_odc.odc02
      FETCH i163_cl INTO g_odc.*            # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
         CLOSE i163_cl ROLLBACK WORK RETURN
      END IF
 
      IF g_success = 'Y' THEN
         DECLARE i163_z_c2 CURSOR FOR
            SELECT tqd03 FROM odc_file,tqd_file
             WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02 AND odc02=tqd01
         FOREACH i163_z_c2 INTO l_tqd03
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            UPDATE odc_file SET odc13='N'
             WHERE odc01=g_odc.odc01 AND odc02=l_tqd03
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#              CALL cl_err('upd odc_file',SQLCA.SQLCODE,0) #No.FUN-660104
               CALL cl_err3("upd","odc_file",g_odc.odc01,l_tqd03,SQLCA.sqlcode,"","upd odc_file",1)  #No.FUN-660104
               LET g_success='N'
            END IF
         END FOREACH
         #如果是最上層,將本層的目標金額確認碼寫成N
         SELECT COUNT(*) INTO g_cnt FROM odb_file
          WHERE odb01=g_odc.odc01 AND odb07=g_odc.odc02
         IF g_cnt != 0 THEN
            UPDATE odc_file SET odc13='N'
             WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#              CALL cl_err('upd odc_file',SQLCA.SQLCODE,0) #No.FUN-660104
               CALL cl_err3("upd","odc_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","upd odc_file",1)  #No.FUN-660104
               LET g_success='N'
            END IF
         END IF
      END IF
 
      CLOSE i163_cl
      IF g_success='N' THEN
         ROLLBACK WORK RETURN
      ELSE
         COMMIT WORK
         CALL cl_cmmsg(1)
      END IF
 
      SELECT * INTO g_odc.* FROM odc_file
       WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02
      DISPLAY BY NAME g_odc.odc13
   END IF
   CALL cl_set_field_pic(g_odc.odc13,"","","","","")
END FUNCTION
 
#start FUN-640268 add
FUNCTION i163_auto_expand_target()
   DEFINE tm          RECORD
                       a      LIKE odb_file.odb01,
                       a_desc LIKE odb_file.odb02,
                       b      LIKE tqb_file.tqb01,
                       b_desc LIKE tqb_file.tqb02,
                       c      LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
                       g      LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
                       h      LIKE aao_file.aao05,             #No.FUN-680120 DEC(15,3)
                       i      LIKE aao_file.aao05,             #No.FUN-680120 DEC(15,3)
                       j      LIKE type_file.chr1              #No.FUN-680120 VARCHAR(1)
                      END RECORD,
          l_odc13     LIKE odc_file.odc13,
          l_ode05a_s  LIKE ode_file.ode14,
          l_ode14_s   LIKE ode_file.ode14,
          l_odc11     LIKE odc_file.odc11,
          l_flag      LIKE type_file.num5             #No.FUN-680120 SMALLINT
 
   OPEN WINDOW i163_e_w AT p_row,p_col WITH FORM "atm/42f/atmi163_e"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("atmi163_e")
 
   WHILE TRUE
      INPUT BY NAME tm.a,tm.b,tm.c,tm.g,tm.h,tm.i,tm.j WITHOUT DEFAULTS
         BEFORE INPUT
            LET tm.h = 0
            LET tm.i = 0
            LET tm.j = 'N'
            DISPLAY tm.h,tm.i,tm.j TO FORMONLY.h,FORMONLY.i,FORMONLY.j
            CALL cl_set_comp_entry("h,i",TRUE)
    
         AFTER FIELD a   #預測版本
            IF cl_null(tm.a) THEN
               CALL cl_err('','mfg5103',0)
               NEXT FIELD a
            ELSE
               SELECT odb02 INTO tm.a_desc FROM odb_file WHERE odb01=tm.a
               IF STATUS THEN
                  LET tm.a_desc = ''
#                 CALL cl_err(tm.a,'mfg-012',0) #No.FUN-660104
                  CALL cl_err3("sel","odb_file",tm.a,"","mfg-012","","",1)  #No.FUN-660104
                  NEXT FIELD a
               END IF
               DISPLAY tm.a_desc TO FORMONLY.a_desc
            END IF
    
         AFTER FIELD b   #預測組織
            IF cl_null(tm.b) THEN
               CALL cl_err('','mfg5103',0)
               NEXT FIELD b
            ELSE
               SELECT tqb02 INTO tm.b_desc FROM tqb_file WHERE tqb01=tm.b
               IF STATUS THEN
                  LET tm.b_desc = ''
#                 CALL cl_err(tm.b,'mfg-012',0) #No.FUN-660104
                  CALL cl_err3("sel","tqb_file",tm.b,"","mfg-012","","",1)  #No.FUN-660104
                  NEXT FIELD b
               END IF
               DISPLAY tm.b_desc TO FORMONLY.b_desc
            END IF
    
         AFTER FIELD c   #金額來源
            IF tm.c NOT MATCHES '[1-2]' THEN
               CALL cl_err('','-1152',0)
               NEXT FIELD c
            END IF
    
         BEFORE FIELD g   #加成方式
            CALL cl_set_comp_entry("h,i",TRUE)
    
         AFTER FIELD g   #加成方式
            IF tm.g NOT MATCHES '[1-2]' THEN
               CALL cl_err('','-1152',0)
               NEXT FIELD g
            ELSE
               IF tm.g = '1' THEN
                  CALL cl_set_comp_entry("i",FALSE)
               ELSE
                  CALL cl_set_comp_entry("h",FALSE)
               END IF
            END IF
    
         AFTER FIELD h   #百分比
            IF tm.g = "1" THEN   #1.固定百分比
               IF cl_null(tm.h) OR
                 (NOT cl_null(tm.h) AND (tm.h<0 OR tm.h>100)) THEN
                  CALL cl_err('','mfg0013',0)
                  NEXT FIELD h
               END IF
            END IF
    
         AFTER FIELD i   #金額
            IF tm.g = "2" THEN   #2.固定金額
               IF cl_null(tm.i) OR
                 (NOT cl_null(tm.i) AND tm.i<0 ) THEN
                  CALL cl_err('','mfg1322',0)
                  NEXT FIELD i
               END IF
            END IF
    
         ON ACTION controlp
            CASE
               WHEN INFIELD(a)  #預測版本
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_odb"
                  LET g_qryparam.default1 = tm.a
                  CALL cl_create_qry() RETURNING tm.a
                  DISPLAY tm.a TO FORMONLY.a
               WHEN INFIELD(b)  #下層組織
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_tqb"
                  LET g_qryparam.default1 = tm.b
                  CALL cl_create_qry() RETURNING tm.b
                  DISPLAY tm.b TO FORMONLY.b
            END CASE
    
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
    
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
    
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
    
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
    
         AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW i163_e_w
         RETURN
      END IF
 
      IF NOT cl_sure(0,0) THEN
         CLOSE WINDOW i163_e_w
         RETURN
      ELSE
         SELECT odc13 INTO l_odc13 FROM odc_file
          WHERE odc01 = tm.a AND odc02 = tm.b
         IF l_odc13 ='Y' THEN 
            CALL cl_err('','9023',0) 
            CLOSE WINDOW i163_e_w
            RETURN 
         END IF
    
         BEGIN WORK
         LET g_success='Y'
    
         #計算最上層目標金額
         SELECT SUM(ode05*ode10),SUM(ode14) INTO l_ode05a_s,l_ode14_s
           FROM ode_file
          WHERE ode01 = tm.a AND ode02 = tm.b
         IF cl_null(l_ode05a_s) THEN LET l_ode05a_s = 0 END IF
         IF cl_null(l_ode14_s)  THEN LET l_ode14_s = 0  END IF
         CASE tm.c        #金額來源
            WHEN '1'   #歷史金額
               IF tm.g = '1' THEN   #固定百分比
                  LET l_odc11 = l_ode05a_s + l_ode05a_s * (tm.h/100)
               END IF
               IF tm.g = '2' THEN   #固定金額
                  LET l_odc11 = l_ode05a_s + tm.i
               END IF
            WHEN '2'   #預測金額
               IF tm.g = '1' THEN   #固定百分比
                  LET l_odc11 = l_ode14_s + l_ode14_s * (tm.h/100)
               END IF
               IF tm.g = '2' THEN   #固定金額
                  LET l_odc11 = l_ode14_s + tm.i
               END IF
         END CASE
         IF cl_null(l_odc11) THEN LET l_odc11 = 0 END IF
         UPDATE odc_file SET odc11 = l_odc11
                       WHERE odc01 = tm.a AND odc02 = tm.b 
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('upd odc_file',SQLCA.SQLCODE,0) #No.FUN-660104
            CALL cl_err3("upd","odc_file",tm.a,tm.b,SQLCA.sqlcode,"","upd odc_file",1)  #No.FUN-660104
            LET g_success='N'
         END IF
         IF tm.j = 'Y' THEN   #展至最下層
            CALL i163_level(tm.a,tm.b,1,tm.c,tm.g,tm.h,tm.i)
         END IF
      END IF 
 
      IF g_success = 'Y' THEN
         COMMIT WORK
         CALL cl_end2(1) RETURNING l_flag
      ELSE
         ROLLBACK WORK
         CALL cl_end2(2) RETURNING l_flag
      END IF
      IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
   END WHILE
 
   CLOSE WINDOW i163_e_w
 
END FUNCTION
 
FUNCTION i163_level(p_odc01,p_tqd01,p_j,c,g,h,i)
   DEFINE p_odc01     LIKE odc_file.odc01,
          p_tqd01     LIKE tqd_file.tqd01,
          p_j         LIKE type_file.num5,             #No.FUN-680120 SMALLINT 
          c           LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
          g           LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
          h           LIKE aao_file.aao05,             #No.FUN-680120 DEC(15,3)   
          i           LIKE aao_file.aao05,             #No.FUN-680120 DEC(15,3)
          j           LIKE type_file.num5,             #No.FUN-680120 SMALLINT
          l_odc02     ARRAY[100] OF LIKE tqd_file.tqd01, #No.FUN-680120  VARCHAR(10)
          l_ode05a_s  LIKE ode_file.ode14,
          l_ode14_s   LIKE ode_file.ode14,
          l_odc11     LIKE odc_file.odc11
 
   DECLARE i163_level_c1 CURSOR FOR
      SELECT odc02 FROM odc_file
       WHERE odc01 = p_odc01
         AND odc02 IN (SELECT tqd03 FROM tqd_file WHERE tqd01 = p_tqd01)
       ORDER BY odc02
 
   FOREACH i163_level_c1 INTO l_odc02[p_j]
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         LET g_success='N'
         EXIT FOREACH
      END IF
 
      LET l_ode05a_s = 0
      SELECT SUM(ode05*ode10),SUM(ode14) INTO l_ode05a_s,l_ode14_s
        FROM ode_file
       WHERE ode01 = p_odc01 AND ode02 = l_odc02[p_j]
      IF cl_null(l_ode05a_s) THEN LET l_ode05a_s = 0 END IF
      IF cl_null(l_ode14_s)  THEN LET l_ode14_s = 0  END IF
      CASE c        #金額來源
         WHEN '1'   #歷史金額
            IF g = '1' THEN   #固定百分比
               LET l_odc11 = l_ode05a_s + l_ode05a_s * (h/100)
            END IF
            IF g = '2' THEN   #固定金額
               LET l_odc11 = l_ode05a_s + i
            END IF
         WHEN '2'   #預測金額
            IF g = '1' THEN   #固定百分比
               LET l_odc11 = l_ode14_s + l_ode14_s * (h/100)
            END IF
            IF g = '2' THEN   #固定金額
               LET l_odc11 = l_ode14_s + i
            END IF
      END CASE
      IF cl_null(l_odc11) THEN LET l_odc11 = 0 END IF
      UPDATE odc_file SET odc11 = l_odc11
                    WHERE odc01 = p_odc01 AND odc02 = l_odc02[p_j]
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('upd odc_file',SQLCA.SQLCODE,0) #No.FUN-660104
         CALL cl_err3("upd","odc_file",p_odc01,l_odc02[p_j],SQLCA.sqlcode,"","upd odc_file",1)  #No.FUN-660104
         LET g_success='N'
      END IF
 
      LET p_j = p_j + 1
   END FOREACH
   LET p_j = p_j - 1
 
   FOR j = 1 TO p_j
      #檢查是否已是最下層組織
      SELECT tqd01 FROM tqd_file WHERE tqd01 = l_odc02[j]
      IF STATUS != NOTFOUND THEN
         SELECT odc02 FROM odc_file
          WHERE odc01 = p_odc01
            AND odc02 IN (SELECT tqd03 FROM tqd_file WHERE tqd01 = l_odc02[j])
         IF STATUS != NOTFOUND THEN
            CALL i163_level(p_odc01,l_odc02[j],p_j,c,g,h,i)
         END IF
      END IF
   END FOR
 
END FUNCTION
#end FUN-640268 add
