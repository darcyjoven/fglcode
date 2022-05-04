# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: amri501.4gl
# Descriptions...: 元件舊料資料維護
# Date & Author..: 96/05/31 By Roger
# Modify.........: No.MOD-490371 04/09/22 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0013 04/11/08 By ching add '轉Excel檔' action
# Modify.........: No.FUN-510046 05/01/25 By pengu 報表轉XML
# Modify.........: NO.FUN-590002 05/12/27By Monster radio type 應都要給預設值
# Modify.........: NO.FUN-590118 06/01/11 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-630106 06/03/10 By Claire DISPLAY ARRAY無控制單身筆數
# Modify.........: No.FUN-660107 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-690022 06/09/18 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/13 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-6B0041 06/11/16 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6A0080 06/11/22 By xumin 報表表頭居中修改
# Modify.........: No.TQC-6C0204 07/01/08 By rainy 單身預設上筆後按確定沒將資料寫入
# Modify.........: NO.TQC-720058 07/03/02 BY Ray  單身生效日大于失效日沒報錯
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-750041 07/05/17 By mike 報表格式修改
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0043 07/12/27 By Cockroach 報表改為p_query實現
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-960273 10/06/13 By Carrier 笔数统计方式错误
# Modify.........: No.FUN-AA0059 10/10/28 By vealxu 全系統料號開窗及判斷控卡原則修改 
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80023 11/08/03 By fengrui  程式撰寫規範修正
# Modify.........: No.TQC-C20131 12/02/13 By zhuhao 賦值bmd11
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_bmd01         LIKE bmd_file.bmd01,   #
    g_bmd08         LIKE bmd_file.bmd08,   #
    g_bmd02         LIKE bmd_file.bmd02,   #
    g_bmd01_t       LIKE bmd_file.bmd01,   #
    g_bmd08_t       LIKE bmd_file.bmd08,   #
    g_bmd02_t       LIKE bmd_file.bmd02,   #
    g_bmd           DYNAMIC ARRAY OF RECORD#程式變數(Program Variables)
        bmd03       LIKE bmd_file.bmd03,   #行序
        bmd04       LIKE bmd_file.bmd04,   #舊料料號
      # ima02_b     VARCHAR(30),
        ima02_b     LIKE ima_file.ima02,   #No.FUN-680082 VARCHAR(30)
      # ima021_b    VARCHAR(30),
        ima021_b    LIKE ima_file.ima021,  #No.FUN-680082 VARCHAR(30)
        bmd05       LIKE bmd_file.bmd05,   #Date
        bmd06       LIKE bmd_file.bmd06,   #Date
        bmd07       LIKE bmd_file.bmd07    #QPA
                    END RECORD,
    g_bmd_t         RECORD                 #程式變數 (舊值)
        bmd03       LIKE bmd_file.bmd03,   #行序
        bmd04       LIKE bmd_file.bmd04,   #舊料料號
      # ima02_b     VARCHAR(30),
        ima02_b     LIKE ima_file.ima02,   #No.FUN-680082 VARCHAR(30)
      # ima021_b    VARCHAR(30),
        ima021_b    LIKE ima_file.ima021,  #No.FUN-680082 VARCHAR(30)   
        bmd05       LIKE bmd_file.bmd05,   #Date
        bmd06       LIKE bmd_file.bmd06,   #Date
        bmd07       LIKE bmd_file.bmd07    #QPA
                    END RECORD,
    g_bmd04_o       LIKE bmd_file.bmd04,
    g_wc,g_wc2,g_sql STRING,              #TQC-630166      
  # g_delete        VARCHAR(01)              #若刪除資料,則要重新顯示筆數
    g_delete        LIKE type_file.chr1,         #No.FUN-680082 VARCHAR(01)      
    g_rec_b         LIKE type_file.num5,         #單身筆數     #No.FUN-680082 SMALLINT
  # g_ss            VARCHAR(01),
    g_ss            LIKE type_file.chr1,         #No.FUN-680082 VARCHAR(01)
  # g_succ          VARCHAR(01),
    g_succ          LIKE type_file.chr1,         #No.FUN-680082 VARCHAR(01)
    g_argv1         LIKE bmd_file.bmd01,
    g_argv2         LIKE bmd_file.bmd08,
  # g_argv3         VARCHAR(1),
    g_argv3         LIKE type_file.chr1,         #No.FUN-680082 VARCHAR(01)
    l_ac            LIKE type_file.num5          #目前處理的ARRAY CNT #No.FUN-680082 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql           STRING                  #SELECT ... FOR UPDATE SQL  
DEFINE   g_before_input_done  LIKE type_file.num5     #No.FUN-680082 SMALLINT
DEFINE   g_cnt                LIKE type_file.num10    #No.FUN-680082 INTEGER
DEFINE   g_i                  LIKE type_file.num5     #count/index for any purpose  #No.FUN-680082 SMALLINT
DEFINE   g_msg                LIKE type_file.chr1000  #No.FUN-680082 VARCHAR(72)
DEFINE   g_row_count          LIKE type_file.num10    #No.FUN-680082 INTEGER
DEFINE   g_curs_index         LIKE type_file.num10    #No.FUN-680082 INTEGER
DEFINE   g_jump               LIKE type_file.num10    #No.FUN-680082 INTEGER
DEFINE   mi_no_ask            LIKE type_file.num5     #No.FUN-680082 SMALLINT
DEFINE g_sql_tmp              STRING                  #No.TQC-960273
 
MAIN
DEFINE
#       l_time    LIKE type_file.chr8              #No.FUN-6A0076
    p_row,p_col     LIKE type_file.num5      #No.FUN-680082 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
    LET g_bmd01 = NULL                     #清除鍵值
    LET g_bmd08 = NULL                     #清除鍵值
    LET g_bmd02 = NULL                     #清除鍵值
    LET g_bmd01_t = NULL
    LET g_bmd08_t = NULL
    LET g_bmd02_t = NULL
 
    #取得參數
    LET g_argv1=ARG_VAL(1)	#元件
    IF cl_null(g_argv1) THEN LET g_argv1='' ELSE LET g_bmd01=g_argv1 END IF
    LET g_argv2=ARG_VAL(2)	#主件
    IF g_argv2=' ' THEN LET g_argv2='' ELSE LET g_bmd08=g_argv2 END IF
    LET g_argv3=ARG_VAL(3)	#UTE
    IF g_argv3=' ' THEN LET g_argv3='' ELSE LET g_bmd02=g_argv3 END IF
 
    LET p_row = 2 LET p_col = 3
    OPEN WINDOW i501_w AT p_row,p_col     #顯示畫面
        WITH FORM "amr/42f/amri501"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN CALL i501_q() END IF
 
    LET g_delete='N'
    CALL i501_menu()
    CLOSE WINDOW i501_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
END MAIN
 
#QBE 查詢資料
FUNCTION i501_cs()
 
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
    IF cl_null(g_argv1) THEN
    	CLEAR FORM                             #清除畫面
        CALL g_bmd.clear()
        CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_bmd01 TO NULL    #No.FUN-750051
   INITIALIZE g_bmd08 TO NULL    #No.FUN-750051
   INITIALIZE g_bmd02 TO NULL    #No.FUN-750051
    	CONSTRUCT g_wc ON bmd01,bmd08,bmd02,bmd03,bmd04    #螢幕上取條件
                  FROM bmd01,bmd08,bmd02,s_bmd[1].bmd03,s_bmd[1].bmd04 
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
 
           ON ACTION controlp
               CASE
                   WHEN INFIELD(bmd01)
#FUN-AA0059 --Begin--
                   #   CALL cl_init_qry_var()
                   #   LET g_qryparam.form  = "q_ima"
                   #   LET g_qryparam.state = "c" 
                   #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                      CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                      DISPLAY g_qryparam.multiret TO bmd01
                      NEXT FIELD bmd01
                   WHEN INFIELD(bmd08)
#FUN-AA0059 --Begin--
                  #    CALL cl_init_qry_var()
                  #    LET g_qryparam.form  = "q_ima"
                  #    LET g_qryparam.state = "c" 
                  #    CALL cl_create_qry() RETURNING g_qryparam.multiret
                      CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                      DISPLAY g_qryparam.multiret TO bmd08
                      NEXT FIELD bmd08
                   OTHERWISE
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
                   CALL cl_qbe_list() RETURNING lc_qbe_sn
                   CALL cl_qbe_display_condition(lc_qbe_sn)
                ON ACTION qbe_save
                   CALL cl_qbe_save()
                #No.FUN-580031 --end--       HCN
        
        END CONSTRUCT
    	IF INT_FLAG THEN RETURN END IF
	ELSE
		LET g_wc=" bmd01='",g_argv1,"' AND ",
		         "(bmd08='",g_argv2,"' OR bmd08='ALL') AND ",
		         " bmd02='",g_argv3 ,"'"
    END IF
 
    LET g_sql="SELECT UNIQUE bmd01,bmd08,bmd02 FROM bmd_file ",
               " WHERE ", g_wc CLIPPED,
               "   AND bmdacti = 'Y'",                                           #CHI-910021
               " ORDER BY bmd01,bmd08,bmd02"
    PREPARE i501_prepare FROM g_sql      #預備一下
    DECLARE i501_bcs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i501_prepare
#   DROP TABLE x
#   LET g_sql="SELECT DISTINCT bmd01,bmd08 FROM bmd_file WHERE",g_wc CLIPPED,
#             " INTO TEMP x; SELECT COUNT(*) FROM x"
    #No.TQC-960273  --Begin
    LET g_sql_tmp = "SELECT UNIQUE bmd01,bmd08,bmd02 FROM bmd_file ",
                    " WHERE ", g_wc CLIPPED,
                    "   AND bmdacti = 'Y'",                                           #CHI-910021
                    "  INTO TEMP x "
    DROP TABLE x
    PREPARE i501_pre_x FROM g_sql_tmp
    EXECUTE i501_pre_x

    LET g_sql = "SELECT COUNT(*) FROM x"
    PREPARE i501_precnt FROM g_sql
    DECLARE i501_count CURSOR FOR i501_precnt
    #No.TQC-960273  --End  
END FUNCTION
 
FUNCTION i501_menu()
  DEFINE  l_cmd    LIKE type_file.chr1000  #NO.FUN-7C0043
   WHILE TRUE
      CALL i501_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i501_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i501_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i501_r()
            END IF
         WHEN "reproduce" 
            IF cl_chk_act_auth() THEN
               CALL i501_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i501_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               #NO.FUN-7C0043 --BEGIN--
               #CALL i501_out()
               IF cl_null(g_wc) THEN
                  LET g_wc =" bmd01='", g_bmd01,"' AND"," bmd08='",g_bmd08,"'" 
               END IF
               LET l_cmd = 'p_query "amri501" "',g_wc CLIPPED,'"'
               CALL cl_cmdrun(l_cmd)
               #NO.FUN-7C0043  --END--
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0013
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_bmd),'','')
             END IF
         #--
         #No.FUN-6B0041-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_bmd01 IS NOT NULL THEN
                LET g_doc.column1 = "bmd01"
                LET g_doc.column2 = "bmd08"
                LET g_doc.column3 = "bmd02"
                LET g_doc.value1 = g_bmd01
                LET g_doc.value2 = g_bmd08
                LET g_doc.value3 = g_bmd02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6B0041-------add--------end----
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i501_a()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM
    CALL g_bmd.clear()
    INITIALIZE g_bmd01 LIKE bmd_file.bmd01
    INITIALIZE g_bmd08 LIKE bmd_file.bmd08
    INITIALIZE g_bmd02 LIKE bmd_file.bmd02
    IF NOT cl_null(g_argv1) THEN LET g_bmd01=g_argv1
    DISPLAY g_bmd01 TO bmd01 END IF
    IF NOT cl_null(g_argv2) THEN LET g_bmd08=g_argv2
    DISPLAY g_bmd08 TO bmd08 END IF
    IF NOT cl_null(g_argv3) THEN LET g_bmd02=g_argv3
    DISPLAY g_bmd02 TO bmd02 END IF
    LET g_bmd01_t = NULL
    LET g_bmd08_t = NULL
    LET g_bmd02_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        #NO.590002 START----------
       LET g_bmd02 = '1'
        #NO.590002 END------------
        CALL i501_i("a")                   #輸入單頭
	IF INT_FLAG THEN 
           LET g_bmd01=NULL
           LET INT_FLAG=0 CALL cl_err('',9001,0)EXIT WHILE 
        END IF
	LET g_rec_b = 0
        DISPLAY g_rec_b TO FORMONLY.cn2  
        CALL i501_b()                   #輸入單身
        LET g_bmd01_t = g_bmd01            #保留舊值
        LET g_bmd08_t = g_bmd08            #保留舊值
        LET g_bmd02_t = g_bmd02            #保留舊值
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i501_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bmd01 IS NULL OR g_bmd08 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bmd01_t = g_bmd01
    LET g_bmd08_t = g_bmd08
    LET g_bmd02_t = g_bmd02
    WHILE TRUE
        CALL i501_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_bmd01=g_bmd01_t
            LET g_bmd08=g_bmd08_t
            LET g_bmd02=g_bmd02_t
            DISPLAY g_bmd01 TO bmd01  
            DISPLAY g_bmd08 TO bmd08 
            DISPLAY g_bmd02 TO bmd02
 
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_bmd01 != g_bmd01_t OR g_bmd08 != g_bmd08_t OR
           g_bmd02 != g_bmd02_t                         THEN #更改單頭值
            UPDATE bmd_file SET bmd01 = g_bmd01,  #更新DB
		                bmd08 = g_bmd08,
		                bmd02 = g_bmd02
                WHERE bmd01 = g_bmd01_t          #COLAUTH?
	          AND bmd08 = g_bmd08_t
	          AND bmd02 = g_bmd02_t
            IF SQLCA.sqlcode THEN
	        LET g_msg = g_bmd01 CLIPPED,' + ', g_bmd08 CLIPPED
#                CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660107
                 CALL cl_err3("upd","bmd_file",g_bmd01_t,g_bmd08_t,SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i501_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,     #a:輸入 u:更改  #No.FUN-680082 VARCHAR(1)
    l_bmd04         LIKE bmd_file.bmd04
 
    LET g_ss='Y'
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT g_bmd01, g_bmd08, g_bmd02
        WITHOUT DEFAULTS
        FROM bmd01,bmd08,bmd02
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i501_set_entry(p_cmd)
           CALL i501_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
       
        {
	BEFORE FIELD bmd01  # 是否可以修改 key
	    IF g_chkey = 'N' AND p_cmd = 'u' THEN RETURN END IF
        }
        AFTER FIELD bmd01            #
            IF NOT cl_null(g_bmd01) THEN
              #FUN-AA0059 -------------------add start---------------
               IF NOT s_chk_item_no(g_bmd01,'') THEN
                  CALL cl_err('',g_errno,1)
                  LET g_bmd01 = g_bmd01_t
                  DISPLAY g_bmd01 TO bmd01
                  NEXT FIELD bmd01  
               END IF
              #FUN-AA0059 ------------------add start---------------- 
               IF g_bmd01 != g_bmd01_t OR g_bmd01_t IS NULL THEN
                   CALL i501_bmd01('a')
                   IF NOT cl_null(g_errno) THEN
	              IF g_errno='mfg9116' THEN
	                 IF NOT cl_confirm(g_errno)
	                    THEN NEXT FIELD bmd01
	                 END IF
	              ELSE
                         CALL cl_err(g_bmd01,g_errno,0)
                         LET g_bmd01 = g_bmd01_t
                         DISPLAY g_bmd01 TO bmd01
                         NEXT FIELD bmd01
	              END IF
                   END IF
               END IF
            END IF
 
        AFTER FIELD bmd08            #
            IF g_bmd08 IS NOT NULL THEN
               #FUN-AA0059 -------------------add start------------
                IF NOT s_chk_item_no(g_bmd08,'') THEN
                   CALL cl_err('',g_errno,1)
                   LET g_bmd08 = g_bmd08_t
                   DISPLAY g_bmd08 TO bmd08
                   NEXT FIELD bmd08
                END IF
               #FUN-AA0059 ------------------add end------------
                CALL i501_bmd08('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_bmd08,g_errno,0)
                   LET g_bmd08 = g_bmd08_t
                   DISPLAY g_bmd08 TO bmd08
                   NEXT FIELD bmd08
		END IF
            END IF
        AFTER FIELD bmd02            
	    IF NOT cl_null(g_bmd02) THEN 
	       IF g_bmd02 NOT MATCHES '[12]' THEN NEXT FIELD bmd02 END IF
                   SELECT count(*) INTO g_cnt FROM bmd_file
                       WHERE bmd01 = g_bmd01
                         AND bmd08 = g_bmd08
                         AND bmd02 = g_bmd02
                         AND bmdacti = 'Y'                                           #CHI-910021
                   IF g_cnt > 0 THEN   #資料重複
	               LET g_msg = g_bmd01 CLIPPED,' + ', g_bmd08 CLIPPED
                       CALL cl_err(g_msg,-239,0)
                       LET g_bmd01 = g_bmd01_t
                       LET g_bmd08 = g_bmd08_t
                       DISPLAY  g_bmd01 TO bmd01 
                       DISPLAY  g_bmd08 TO bmd08 
                       NEXT FIELD bmd01
                   END IF
            END IF
 
        ON ACTION controlp
            CASE
                WHEN INFIELD(bmd01)
#FUN-AA0059 --Begin--
                #   CALL cl_init_qry_var()
                #   LET g_qryparam.form     = "q_ima"
                #   LET g_qryparam.default1 = g_bmd01
                #   CALL cl_create_qry() RETURNING g_bmd01
                   CALL q_sel_ima(FALSE, "q_ima", "",g_bmd01, "", "", "", "" ,"",'' )  RETURNING g_bmd01
#FUN-AA0059 --End--
                   DISPLAY BY NAME g_bmd01
                   CALL i501_bmd01('d')
                   NEXT FIELD bmd01
                WHEN INFIELD(bmd08)
#FUN-AA0059 --Begin--
                 #  CALL cl_init_qry_var()
                 #  LET g_qryparam.form     = "q_ima"
                 #  LET g_qryparam.default1 = g_bmd08
                 #  CALL cl_create_qry() RETURNING g_bmd08
                  CALL q_sel_ima(FALSE, "q_ima", "", g_bmd08, "", "", "", "" ,"",'' )  RETURNING g_bmd08
#FUN-AA0059 --End--
                  DISPLAY BY NAME g_bmd08
                  CALL i501_bmd08('d')
                  NEXT FIELD bmd08
                OTHERWISE
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #TQC-860019-add
        ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
        #TQC-860019-add
          
    END INPUT
END FUNCTION
FUNCTION i501_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680082 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("bmd01",TRUE)
    END IF
 
END FUNCTION
FUNCTION i501_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680082 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("bmd01",FALSE)
    END IF
END FUNCTION
 
FUNCTION i501_bmd01(p_cmd)  #
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680082 VARCHAR(1)
           l_ima02   LIKE ima_file.ima02,
           l_ima021   LIKE ima_file.ima021,
           l_ima25   LIKE ima_file.ima25,
           l_ima08   LIKE ima_file.ima08,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima25,ima08,imaacti
           INTO l_ima02,l_ima021,l_ima25,l_ima08,l_imaacti
           FROM ima_file WHERE ima01 = g_bmd01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                            LET l_ima02 = NULL  LET l_ima25 = NULL
                            LET l_ima021= NULL 
                            LET l_ima08 = NULL  LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
    #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690022------mod-------         
         WHEN l_ima08 NOT MATCHES '[PVZS]' LET g_errno = 'mfg9116'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
      THEN DISPLAY l_ima02 TO FORMONLY.ima02_h 
           DISPLAY l_ima021 TO FORMONLY.ima021_h 
           DISPLAY l_ima25 TO FORMONLY.ima25_h 
           DISPLAY l_ima08 TO FORMONLY.ima08_h 
    END IF
END FUNCTION
   
FUNCTION i501_bmd08(p_cmd) 
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680082 VARCHAR(1)
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima25   LIKE ima_file.ima25,
           l_ima08   LIKE ima_file.ima08,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
	IF g_bmd08=g_bmd01 THEN LET g_errno='mfg2633' RETURN END IF
	IF g_bmd08='all' THEN
		LET g_bmd08='ALL'
		DISPLAY g_bmd08 TO bmd08
	END IF
	IF g_bmd08='ALL' THEN 
      DISPLAY '' TO FORMONLY.ima02_h2 
      DISPLAY '' TO FORMONLY.ima021_h2 
      DISPLAY '' TO FORMONLY.ima25_h2 
      DISPLAY '' TO FORMONLY.ima08_h2 
		RETURN END IF
    SELECT ima02,ima021,ima25,ima08,imaacti
           INTO l_ima02,l_ima021,l_ima25,l_ima08,l_imaacti
           FROM ima_file WHERE ima01 = g_bmd08
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                            LET l_ima02 = NULL  LET l_ima25 = NULL
                            LET l_ima021= NULL 
                            LET l_ima08 = NULL  LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
    #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690022------mod-------         
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
      THEN DISPLAY l_ima02 TO FORMONLY.ima02_h2 
           DISPLAY l_ima021 TO FORMONLY.ima021_h2 
           DISPLAY l_ima25 TO FORMONLY.ima25_h2 
           DISPLAY l_ima08 TO FORMONLY.ima08_h2
    END IF
	IF NOT cl_null(g_errno) THEN
      DISPLAY '' TO FORMONLY.ima02_h2 
      DISPLAY '' TO FORMONLY.ima021_h2 
      DISPLAY '' TO FORMONLY.ima25_h2 
      DISPLAY '' TO FORMONLY.ima08_h2
	END IF
END FUNCTION
#Query 查詢
FUNCTION i501_q()
  DEFINE l_bmd01  LIKE bmd_file.bmd01,
         l_bmd08  LIKE bmd_file.bmd08,
         l_bmd02  LIKE bmd_file.bmd02,
       # l_cnt    INTEGER
         l_cnt    LIKE type_file.num10    #No.FUN-680082 INTEGER
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bmd01 TO NULL              #No.FUN-6B0041
    INITIALIZE g_bmd08 TO NULL              #No.FUN-6B0041
    INITIALIZE g_bmd02 TO NULL              #No.FUN-6B0041
 
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL i501_cs()                          #取得查詢條件
    IF INT_FLAG THEN                        #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_bmd01 TO NULL
        INITIALIZE g_bmd08 TO NULL
        INITIALIZE g_bmd02 TO NULL
        RETURN
    END IF
    OPEN i501_bcs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bmd01 TO NULL
        INITIALIZE g_bmd08 TO NULL
        INITIALIZE g_bmd02 TO NULL
    ELSE
        CALL i501_fetch('F')            #讀出TEMP第一筆並顯示
        OPEN i501_count
        FETCH i501_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i501_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-680082 VARCHAR(1) 
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-680082 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i501_bcs INTO g_bmd01,g_bmd08,g_bmd02
        WHEN 'P' FETCH PREVIOUS i501_bcs INTO g_bmd01,g_bmd08,g_bmd02
        WHEN 'F' FETCH FIRST    i501_bcs INTO g_bmd01,g_bmd08,g_bmd02
        WHEN 'L' FETCH LAST     i501_bcs INTO g_bmd01,g_bmd08,g_bmd02
        WHEN '/' 
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
               
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i501_bcs INTO g_bmd01,g_bmd08,g_bmd02
            LET mi_no_ask = FALSE
    END CASE
 
    LET g_succ='Y'
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_bmd01,SQLCA.sqlcode,0)
        INITIALIZE g_bmd01 TO NULL  #TQC-6B0105
        INITIALIZE g_bmd08 TO NULL  #TQC-6B0105
        INITIALIZE g_bmd02 TO NULL  #TQC-6B0105
	LET g_succ='N'
    ELSE
        OPEN i501_count
        FETCH i501_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
        CALL i501_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i501_show()
    DISPLAY g_bmd01 TO bmd01  
    DISPLAY g_bmd08 TO bmd08  
    DISPLAY g_bmd02 TO bmd02  
    CALL i501_bmd01('d')
    CALL i501_bmd08('d')
    CALL i501_bf(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i501_r()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bmd01 IS NULL THEN
       CALL cl_err("",-400,0)                 #No.FUN-6B0041
       RETURN
    END IF
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bmd01"      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "bmd08"      #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "bmd02"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bmd01       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_bmd08       #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_bmd02       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM bmd_file
         WHERE bmd01=g_bmd01 AND bmd08=g_bmd08 AND bmd02=g_bmd02
        IF SQLCA.sqlcode THEN
#            CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0) #No.FUN-660107
             CALL cl_err3("del","bmd_file",g_bmd01,g_bmd08,SQLCA.SQLCODE,"","BODY DELETE:",1)       #NO.FUN-660107
        ELSE
            CLEAR FORM
            CALL g_bmd.clear()
            LET g_delete='Y'
            LET g_bmd01 = NULL
            LET g_bmd08 = NULL
            LET g_bmd02 = NULL
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            #No.TQC-960273  --Begin
            DROP TABLE x
            PREPARE i501_pre_x2 FROM g_sql_tmp    #TQC-710054 add
            EXECUTE i501_pre_x2                   #TQC-710054
            #No.TQC-960273  --End  
            OPEN i501_count
            #FUN-B50063-add-start--
             IF STATUS THEN
                CLOSE i501_bcs
                CLOSE i501_count
                COMMIT WORK
                RETURN
             END IF
             #FUN-B50063-add-end-- 
             FETCH i501_count INTO g_row_count
             #FUN-B50063-add-start--
             IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
                CLOSE i501_bcs
                CLOSE i501_count
                COMMIT WORK
                RETURN
             END IF
             #FUN-B50063-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i501_bcs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i501_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i501_fetch('/')
            END IF
 
        END IF
    END IF
END FUNCTION
 
#單身
FUNCTION i501_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680082 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680082 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680082 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680082 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,    #可新增否          #No.FUN-680082 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否          #No.FUN-680082 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bmd01 IS NULL THEN
        RETURN
    END IF
    CALL cl_opmsg('b')
    LET g_forupd_sql = "SELECT bmd03,bmd04,'','',bmd05,bmd06,bmd07 ",
                       " FROM bmd_file ",
                       " WHERE bmd01=? ",
                       "   AND bmd08=? ",
                       "   AND bmd02=? ",
                       "   AND bmd03=? ",
                       "   AND bmdacti = 'Y'",                                           #CHI-910021
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)   #No.FUN-B80023 刪除此行前空白行
    DECLARE i501_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_bmd WITHOUT DEFAULTS FROM s_bmd.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd = ''
            BEGIN WORK
            LET l_ac = ARR_CURR()
            #DISPLAY l_ac  TO FORMONLY.cn3  #TQC-6C0204
            DISPLAY l_ac  TO FORMONLY.cn2   #TQC-6C0204  
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
            #IF g_bmd_t.bmd03 IS NOT NULL THEN
                LET p_cmd='u'
                LET g_bmd_t.* = g_bmd[l_ac].*      #BACKUP
                LET g_bmd04_o = g_bmd[l_ac].bmd04  #BACKUP
                OPEN i501_bcl USING g_bmd01, g_bmd08, g_bmd02, g_bmd_t.bmd03
                IF STATUS THEN
                   CALL cl_err("OPEN i501_bcl:", STATUS, 1)
                   CLOSE i501_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i501_bcl INTO g_bmd[l_ac].* 
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_bmd_t.bmd03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   LET g_bmd[l_ac].ima02_b=g_bmd_t.ima02_b
                   LET g_bmd[l_ac].ima021_b=g_bmd_t.ima021_b
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
#              CALL g_bmd.deleteElement(l_ac)   #取消 Array Element
#              IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
#                 LET g_action_choice = "detail"
#                 LET l_ac = l_ac_t
#              END IF
#              EXIT INPUT
            END IF
            IF g_bmd[l_ac].bmd03 IS NULL OR 
               g_bmd[l_ac].bmd04 IS NULL THEN #重要欄位空白,無效
                INITIALIZE g_bmd[l_ac].* TO NULL
            END IF
            INSERT INTO bmd_file
                  (bmd01, bmd02, bmd03, bmd04,
                   bmd05, bmd06, bmd07, bmd08,bmd11,bmdoriu,bmdorig)    #TQC-C20131  add bmd11
            VALUES(g_bmd01,g_bmd02,
                   g_bmd[l_ac].bmd03,g_bmd[l_ac].bmd04,
                   g_bmd[l_ac].bmd05,NULL,g_bmd[l_ac].bmd07,g_bmd08,'N', g_user, g_grup)      #No.FUN-980030 insert columns oriu, orig  #TQC-C20131  add 'N'
            IF SQLCA.sqlcode THEN
#                CALL cl_err(g_bmd[l_ac].bmd03,SQLCA.sqlcode,0) #No.FUN-660107
                 CALL cl_err3("ins","bmd_file",g_bmd01,g_bmd[l_ac].bmd03,SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  
	        COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bmd[l_ac].* TO NULL      #900423
            LET g_bmd[l_ac].bmd05=TODAY
            LET g_bmd[l_ac].bmd07=1
            LET g_bmd_t.* = g_bmd[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bmd03
 
        BEFORE FIELD bmd03                        #default 序號
            IF p_cmd='a' THEN
                SELECT max(bmd03)+1
                   INTO g_bmd[l_ac].bmd03
                   FROM bmd_file
                   WHERE bmd01=g_bmd01 AND bmd08=g_bmd08 AND bmd02=g_bmd02
                     AND bmdacti = 'Y'                                           #CHI-910021
                IF g_bmd[l_ac].bmd03 IS NULL THEN
                    LET g_bmd[l_ac].bmd03 = 1
                END IF
            END IF
 
        AFTER FIELD bmd03                        #check 序號是否重複
            IF NOT cl_null(g_bmd[l_ac].bmd03) THEN
               IF g_bmd[l_ac].bmd03 != g_bmd_t.bmd03 OR
                  g_bmd_t.bmd03 IS NULL THEN
                   SELECT count(*) INTO l_n FROM bmd_file
                       WHERE bmd01 = g_bmd01
                         AND bmd08 = g_bmd08 
                         AND bmd02 = g_bmd02
                         AND bmd03 = g_bmd[l_ac].bmd03
                         AND bmdacti = 'Y'                                           #CHI-910021
                   IF l_n > 0 THEN
                       CALL cl_err(g_bmd[l_ac].bmd03,-239,0)
                       LET g_bmd[l_ac].bmd03 = g_bmd_t.bmd03
                       NEXT FIELD bmd03
                   END IF
               END IF
            END IF
            #DISPLAY l_ac  TO FORMONLY.cn3   #TQC-6C0204
            DISPLAY l_ac  TO FORMONLY.cn2    #TQC-6C0204  
 
         AFTER FIELD bmd04
             IF NOT cl_null(g_bmd[l_ac].bmd03) THEN
               #FUN-AA0059 ---------------add start----------------
                IF NOT s_chk_item_no(g_bmd[l_ac].bmd03,'') THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD bmd04
                END IF
               #FUN-AA0059 --------------add end--------------- 
                SELECT ima02,ima021 INTO g_bmd[l_ac].ima02_b,g_bmd[l_ac].ima021_b
                  FROM ima_file
                 WHERE ima01=g_bmd[l_ac].bmd04
                IF STATUS THEN
#                   CALL cl_err('sel ima:',STATUS,0)  #No.FUN-660107
                    CALL cl_err3("sel","ima_file",g_bmd[l_ac].bmd04,"",STATUS,"","sel ima:",1)       #NO.FUN-660107
                    NEXT FIELD bmd04
                END IF
             END IF
             DISPLAY g_bmd[l_ac].ima02_b TO ima02_b
             DISPLAY g_bmd[l_ac].ima021_b TO ima021_b
 
#No.TQC-720058 --begin
        AFTER FIELD bmd05
	    IF NOT cl_null(g_bmd[l_ac].bmd05) AND NOT cl_null(g_bmd[l_ac].bmd06) THEN
               IF g_bmd[l_ac].bmd05 > g_bmd[l_ac].bmd06 THEN
                  CALL cl_err(g_bmd[l_ac].bmd05,'ams-012',0)
                  NEXT FIELD bmd05
               END IF
            END IF
             
        AFTER FIELD bmd06
	    IF NOT cl_null(g_bmd[l_ac].bmd05) AND NOT cl_null(g_bmd[l_ac].bmd06) THEN
               IF g_bmd[l_ac].bmd05 > g_bmd[l_ac].bmd06 THEN
                  CALL cl_err(g_bmd[l_ac].bmd06,'mfg2604',0)
                  NEXT FIELD bmd06
               END IF
            END IF
        #No.TQC-750041  --BEGIN--
        AFTER FIELD bmd07
            IF NOT cl_null(g_bmd[l_ac].bmd07) THEN
                IF g_bmd[l_ac].bmd07<0 THEN
                   CALL cl_err(g_bmd[l_ac].bmd07,'aim-223',0)
                   NEXT FIELD bmd07
                END IF
            END IF
        #No.TQC-750041  --END--
#No.TQC-720058 --end
 
        BEFORE DELETE                            #是否取消單身
            IF g_bmd_t.bmd03 > 0 AND
               g_bmd_t.bmd03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM bmd_file
                    WHERE bmd01 = g_bmd01 AND
                          bmd08 = g_bmd08 AND
                          bmd02 = g_bmd02 AND
                          bmd03 = g_bmd_t.bmd03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_bmd_t.bmd03,SQLCA.sqlcode,0) #No.FUN-660107
                    CALL cl_err3("del","bmd_file",g_bmd01,g_bmd08,SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
		COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bmd[l_ac].* = g_bmd_t.*
               CLOSE i501_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_bmd[l_ac].bmd03,-263,1)
               LET g_bmd[l_ac].* = g_bmd_t.*
            ELSE
               IF g_bmd[l_ac].bmd03 IS NULL OR 
                  g_bmd[l_ac].bmd04 IS NULL THEN #重要欄位空白,無效
                   INITIALIZE g_bmd[l_ac].* TO NULL
               END IF
               UPDATE bmd_file SET
                      bmd03=g_bmd[l_ac].bmd03,
                      bmd04=g_bmd[l_ac].bmd04,
                      bmd05=g_bmd[l_ac].bmd05,
                      bmd06=g_bmd[l_ac].bmd06,
                      bmd07=g_bmd[l_ac].bmd07
                WHERE bmd01=g_bmd01
                  AND bmd08=g_bmd08
                  AND bmd02=g_bmd02
                  AND bmd03=g_bmd_t.bmd03
               IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_bmd[l_ac].bmd03,SQLCA.sqlcode,0) #No.FUN-660107
                    CALL cl_err3("upd","bmd_file",g_bmd01,g_bmd_t.bmd03,SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
               ELSE
                   MESSAGE 'UPDATE O.K'
	           COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac       #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_bmd[l_ac].* = g_bmd_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bmd.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end-- 
               END IF
               CLOSE i501_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac       #FUN-D40030 Add
            CLOSE i501_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(bmd03) AND l_ac > 1 THEN
                LET g_bmd[l_ac].* = g_bmd[l_ac-1].*
                DISPLAY BY NAME g_bmd[l_ac].*     #TQC-6C0204
                NEXT FIELD bmd03
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(bmd04)
#FUN-AA0059 --Begin--
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.form     = "q_ima"
                #  LET g_qryparam.default1 = g_bmd[l_ac].bmd04
                #  CALL cl_create_qry() RETURNING g_bmd[l_ac].bmd04
                   CALL q_sel_ima(FALSE, "q_ima", "", g_bmd[l_ac].bmd04, "", "", "", "" ,"",'' )  RETURNING g_bmd[l_ac].bmd04
#FUN-AA0059 --End--
#                  CALL FGL_DIALOG_SETBUFFER( g_bmd[l_ac].bmd04 )
                  DISPLAY g_bmd[l_ac].bmd04 TO bmd04           #No.MOD-490371
                 NEXT FIELD bmd04
            END CASE
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------  
        
        END INPUT
 
       CLOSE i501_bcl
       COMMIT WORK
END FUNCTION
   
FUNCTION i501_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000       #No.FUN-680082 VARCHAR(300)
 
    CONSTRUCT l_wc ON bmd03, bmd04                     #螢幕上取條件
       FROM s_bmd[1].bmd03,s_bmd[1].bmd04
 
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
    LET l_wc = l_wc CLIPPED,cl_get_extra_cond('bmduser', 'bmdgrup') #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = FALSE RETURN END IF
    CALL i501_bf(l_wc)
END FUNCTION
 
FUNCTION i501_bf(p_wc)              #BODY FILL UP
DEFINE
    p_wc      	    LIKE type_file.chr1000    #No.FUN-680082 VARCHAR(300)
 
    LET g_sql =
       " SELECT bmd03,bmd04,ima02,ima021,bmd05,bmd06,bmd07 ",
       "   FROM bmd_file LEFT OUTER JOIN ima_file ON bmd_file.bmd04=ima_file.ima01",
       "  WHERE bmd01 = '",g_bmd01,"' AND bmd08 = '",g_bmd08,"'",
       "    AND bmd02 = '",g_bmd02,"'",
       "    AND ",p_wc CLIPPED ,
       "    AND bmdacti = 'Y'",                                           #CHI-910021
       " ORDER BY 1"
    PREPARE i501_prepare2 FROM g_sql      #預備一下
    DECLARE bmd_cs CURSOR FOR i501_prepare2
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH bmd_cs INTO g_bmd[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        #TQC-630106-begin 
         IF g_cnt > g_max_rec THEN   #MOD-4B0274
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF
        #TQC-630106-end 
    END FOREACH
    IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) END IF
    CALL g_bmd.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i501_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680082 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmd TO s_bmd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first 
         CALL i501_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL i501_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL i501_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL i501_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL i501_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
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
 
      #FUN-4B0013
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------  
   
     ON ACTION related_document                #No.FUN-6B0041  相關文件
        LET g_action_choice="related_document"          
        EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i501_copy()
DEFINE
    l_oldno1         LIKE bmd_file.bmd01,
    l_oldno2         LIKE bmd_file.bmd08,
    l_oldno3         LIKE bmd_file.bmd02,
    l_newno1         LIKE bmd_file.bmd01,
    l_newno2         LIKE bmd_file.bmd08,
    l_newno3         LIKE bmd_file.bmd02
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bmd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    DISPLAY "" AT 1,1
    CALL cl_getmsg('copy',g_lang) RETURNING g_msg
    DISPLAY g_msg AT 2,1 
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT l_newno2  FROM bmd08
 
        AFTER FIELD bmd08
            IF NOT cl_null(l_newno2) THEN
              #FUN-AA0059 -------------add start--------------
               IF NOT s_chk_item_no(l_newno2,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD bmd08
               END IF
              #FUN-AA0059 ------------add end----------------
               SELECT * FROM ima_file
                WHERE ima01 = l_newno2
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(l_newno2,'mfg2729',0) #No.FUN-660107
                   CALL cl_err3("sel","ima_file",l_newno2,"","mfg2729","","",1)       #NO.FUN-660107
                  NEXT FIELD bmd08
               END IF
               SELECT count(*) INTO g_cnt FROM bmd_file
                WHERE bmd01 = g_bmd01
                  AND bmd08 = l_newno2
                  AND bmd02 = g_bmd02
                  AND bmdacti = 'Y'                                           #CHI-910021
               IF g_cnt > 0 THEN
	           LET g_msg = g_bmd01 CLIPPED,'+',l_newno2 CLIPPED
                   CALL cl_err(g_msg,-239,0)
                   NEXT FIELD bmd08
               END IF
            END IF
        ON ACTION controlp
            CASE
                WHEN INFIELD(bmd08)
#FUN-AA0059 --Begin--
                 #  CALL cl_init_qry_var()
                 #  LET g_qryparam.form     = "q_ima"
                 #  LET g_qryparam.default1 = l_newno2
                 #  CALL cl_create_qry() RETURNING l_newno2
                    CALL q_sel_ima(FALSE, "q_ima", "",l_newno2, "", "", "", "" ,"",'' )  RETURNING l_newno2
#FUN-AA0059 --End--
#                   CALL FGL_DIALOG_SETBUFFER( l_newno2 )
                  DISPLAY BY NAME l_newno2
                  CALL i501_bmd08('d')
                  NEXT FIELD bmd08
                OTHERWISE
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
 
    
    END INPUT
    IF INT_FLAG OR l_newno2 IS NULL THEN
        LET INT_FLAG = 0
    	CALL i501_show()
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM bmd_file
        WHERE bmd01=g_bmd01
          AND bmd08=g_bmd08
          AND bmd02=g_bmd02
          AND bmdacti = 'Y'                                           #CHI-910021
        INTO TEMP x
    UPDATE x
        SET bmd08=l_newno2
    INSERT INTO bmd_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#        CALL cl_err(g_bmd01,SQLCA.sqlcode,0) #No.FUN-660107
         CALL cl_err3("ins","bmd_file",g_bmd01,g_bmd08,SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
    ELSE
	LET g_msg = g_bmd01 CLIPPED, ' + ', l_newno2 CLIPPED
        MESSAGE 'ROW(',g_msg,') O.K' 
        LET l_oldno2 = g_bmd08
        LET g_bmd08 = l_newno2
	IF g_chkey = 'Y' THEN CALL i501_u() END IF
        CALL i501_b()
        #LET g_bmd08 = l_oldno2  #FUN-C80046
        #CALL i501_show()        #FUN-C80046
    END IF
END FUNCTION
 
#NO.FUN-7C0043 --BEGIN--   
#FUNCTION i501_out()
#DEFINE
#   l_i             LIKE type_file.num5,   #No.FUN-680082 SMALLINT
#   sr              RECORD
#       bmd01       LIKE bmd_file.bmd01,   #
#       bmd08       LIKE bmd_file.bmd08,   #
#       bmd02       LIKE bmd_file.bmd02,   #
#       bmd03       LIKE bmd_file.bmd03,   #行序
#       bmd04       LIKE bmd_file.bmd04,   #舊料料號
#       bmd05       LIKE bmd_file.bmd05,
#       bmd07       LIKE bmd_file.bmd07
#                   END RECORD,
# # l_name          VARCHAR(20),              #External(Disk) file name
#   l_name          LIKE type_file.chr20,  #No.FUN-680082 VARCHAR(20)
# # l_za05          VARCHAR(40)               #
#   l_za05          LIKE type_file.chr1000 #No.FUN-680082 VARCHAR(40)
#    
#   IF cl_null(g_wc) THEN
#      LET g_wc=" bmd01='", g_bmd01,"' AND"," bmd08='",g_bmd08,"'"
#   END IF
 
#   IF g_wc IS NULL THEN
##       CALL cl_err('',-400,0)
#       CALL cl_err('','9057',0) RETURN END IF
#   CALL cl_wait()
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT bmd01,bmd08,bmd02,bmd03,bmd04,bmd06,bmd07",
#             " FROM bmd_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc CLIPPED
#   PREPARE i501_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i501_co                         # SCROLL CURSOR
#       CURSOR FOR i501_p1
 
#   CALL cl_outnam('amri501') RETURNING l_name
#   START REPORT i501_rep TO l_name
 
#   FOREACH i501_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i501_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i501_rep
 
#   CLOSE i501_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
#END FUNCTION
#
#REPORT i501_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,          #NO.FUN-680082 VARCHAR(1)
#   l_ima02_1         LIKE ima_file.ima02,
#   l_ima02_2         LIKE ima_file.ima02,
#   l_ima02_3         LIKE ima_file.ima02,
#   sr              RECORD
#       bmd01       LIKE bmd_file.bmd01,   #
#       bmd08       LIKE bmd_file.bmd08,   #
#       bmd02       LIKE bmd_file.bmd02,   #
#       bmd03       LIKE bmd_file.bmd03,   #行序
#       bmd04       LIKE bmd_file.bmd04,   #舊料料號
#       bmd06       LIKE bmd_file.bmd06,
#       bmd07       LIKE bmd_file.bmd07
#                   END RECORD
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.bmd01,sr.bmd08,sr.bmd02,sr.bmd03
 
#   FORMAT
#       PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company   #No.TQC-6A0080
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1]   #No.TQC-6A0080
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     PRINT g_dash[1,g_len] CLIPPED
#     PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#           g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#           g_x[39] CLIPPED
 
#     PRINT g_dash1
#           LET l_trailer_sw = 'y'
#       BEFORE GROUP OF sr.bmd01
#           SELECT ima02 INTO l_ima02_1 FROM ima_file WHERE ima01=sr.bmd01
#           PRINT COLUMN g_c[31],sr.bmd01,
#                 COLUMN g_c[32],l_ima02_1;
 
#       BEFORE GROUP OF sr.bmd08
#           SELECT ima02 INTO l_ima02_2 FROM ima_file WHERE ima01=sr.bmd08
#           PRINT COLUMN g_c[33],sr.bmd08,
#                 COLUMN g_c[34],l_ima02_2;
 
#       BEFORE GROUP OF sr.bmd02
#           PRINT COLUMN g_c[35],sr.bmd02;
 
#       ON EVERY ROW
#           SELECT ima02 INTO l_ima02_3 FROM ima_file WHERE ima01=sr.bmd04
#           PRINT COLUMN g_c[36],sr.bmd03 USING '###&', #FUN-590118
#                 COLUMN g_c[37],sr.bmd04,
#                 COLUMN g_c[38],l_ima02_3,
#                 COLUMN g_c[39],cl_numfor(sr.bmd07,39,2) 
 
#       AFTER GROUP OF sr.bmd08
#           PRINT
 
#       ON LAST ROW
#              PRINT g_dash[1,g_len]
#           IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#              THEN #PRINT g_dash[1,g_len]
#                   CALL cl_prt_pos_wc(g_wc) #TQC-630166
#           END IF
#           #PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#              # PRINT '(amri501)'
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#NO.FUN-7C0043 --END--
