# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: apmt920.4gl
# Descriptions...: 供應商自定義項目評分作業
# Date & Author..: FUN-720041 07/03/02 by Yiting
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-740366 07/04/26 By Nicola 廠商評價項目產生QBE修改
# Modify.........: No.TQC-750068 07/05/14 By Sarah 程式並沒有copy()段，但是bp()卻有定義reproduce,導致按下複雜後沒反應
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790095 07/09/14 By lumxa 打印功能無效，如無需打印功能請把該按鈕灰掉
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-B30279 11/03/14 by Summer 依產生資料顯示產生成功或失敗 
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D30034 13/04/17 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_ppd01         LIKE ppd_file.ppd01,      #流程代碼 (假單頭)  #FUN-720041
    g_ppd01_t       LIKE ppd_file.ppd01,      #流程代碼   (舊值)
    g_ppd02         LIKE ppd_file.ppd02,      #流程代碼 (假單頭)
    g_ppd02_t       LIKE ppd_file.ppd02,      #流程代碼   (舊值)
    g_pmc03         LIKE pmc_file.pmc03, 
    g_cnt1          LIKE type_file.num5,      #No.FUN-680136 SMALLINT
    l_cmd           LIKE type_file.chr1000,   #No.FUN-680136 VARCHAR(100)
    g_ppd           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                    ppd03   LIKE ppd_file.ppd03,
                    ppa03   LIKE ppa_file.ppa03,
                    ppd04   LIKE ppd_file.ppd04                   
                    END RECORD,
    g_ppd_t         RECORD                    #程式變數 (舊值)
                    ppd03   LIKE ppd_file.ppd03,
                    ppa03   LIKE ppa_file.ppa03,
                    ppd04   LIKE ppd_file.ppd04                   
                    END RECORD,
    g_wc,g_sql    string,  #No.FUN-580092 HCN
    g_delete        LIKE type_file.chr1,   #若刪除資料,則要重新顯示筆數  #No.FUN-680136
    g_rec_b         LIKE type_file.num5,   #單身筆數        #No.FUN-680136 SMALLINT
    l_za05          LIKE type_file.chr1000,#No.FUN-680136 VARCHAR(40)
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_sl            LIKE type_file.num5    #No.FUN-680136 SMALLINT #目前處理的ARRAY CNT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp    STRING   #No.TQC-720019
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680136 SMALLINT
DEFINE   g_cnt            LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_i              LIKE type_file.num5          #count/index for any purpose    #No.FUN-680136 SMALLINT
DEFINE   g_msg            LIKE ze_file.ze03            #No.FUN-680136 VARCHAR(72)
DEFINE   g_row_count      LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_curs_index     LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_jump           LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_no_ask        LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
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

   LET g_ppd01   = NULL                   #清除鍵值
   LET g_ppd01_t = NULL

   OPEN WINDOW t920_w WITH FORM "apm/42f/apmt920"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()

   CALL t920_menu()
   CLOSE WINDOW t920_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t920_cs()
 
   CLEAR FORM                             #清除畫面
   CALL g_ppd.clear()
   INITIALIZE g_ppd01 TO NULL    #No.FUN-750051
   INITIALIZE g_ppd02 TO NULL    #No.FUN-750051
   CONSTRUCT g_wc ON ppd01,ppd02,ppd03,ppd04 #螢幕上取條件
           FROM ppd01,ppd02,
                s_ppd[1].ppd03,s_ppd[1].ppd04
       #--No.MOD-4A0248--------
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
 
      ON ACTION CONTROLP
         CASE 
             WHEN INFIELD(ppd02)  
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form = "q_pmc"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ppd02
                   NEXT FIELD ppd02
             WHEN INFIELD(ppd03)  
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form = "q_ppa"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ppd03
                   NEXT FIELD ppd03
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
 
   
      #No.FUN-580031 --start--     HCN
       ON ACTION qbe_select
         CALL cl_qbe_select() 
       ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 --end--       HCN
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN RETURN END IF
 
   LET g_sql="SELECT UNIQUE ppd01,ppd02 ",
              " FROM ppd_file ", # 組合出 SQL 指令
              " WHERE ", g_wc CLIPPED,
              " ORDER BY ppd01"
   PREPARE t920_prepare FROM g_sql      #預備一下
   DECLARE t920_bcs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR t920_prepare
 
   LET g_sql_tmp="SELECT UNIQUE ppd01,ppd02",  #No.TQC-720019
             "  FROM ppd_file WHERE ", g_wc CLIPPED,
             " GROUP BY ppd01,ppd02",
             " INTO TEMP x"
   DROP TABLE x
   PREPARE t920_precount_x FROM g_sql_tmp  #No.TQC-720019
   EXECUTE t920_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE t920_precount FROM g_sql
   DECLARE t920_count CURSOR FOR t920_precount
 
END FUNCTION
 
FUNCTION t920_menu()
   WHILE TRUE
      CALL t920_bp("G")
      CASE g_action_choice
#           WHEN "insert" 
#            IF cl_chk_act_auth() THEN 
#                CALL t920_a()
#            END IF
           WHEN "query" 
            IF cl_chk_act_auth() THEN
                CALL t920_q()
            END IF
#           WHEN "modify" 
#            IF cl_chk_act_auth() THEN
#                 CALL t920_u()
#            END IF
           WHEN "detail" 
            IF cl_chk_act_auth() THEN 
                CALL t920_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
           WHEN "supplier_evaluation" 
            IF cl_chk_act_auth() THEN 
                CALL t920_result()
            ELSE
               LET g_action_choice = NULL
            END IF
 
           WHEN "next" 
            CALL t920_fetch('N')
           WHEN "previous" 
            CALL t920_fetch('P')
           WHEN "delete" 
            IF cl_chk_act_auth() THEN
                CALL t920_r()
            END IF
           WHEN "help" 
            CALL cl_show_help()
           WHEN "exit"
            EXIT WHILE
           WHEN "jump"
            CALL t920_fetch('/')
           WHEN "controlg"     
            CALL cl_cmdask()
            WHEN "related_document"  #No.MOD-470518
            IF cl_chk_act_auth() THEN
               IF g_ppd01 IS NOT NULL THEN
                  LET g_doc.column1 = "ppd01"
                  LET g_doc.value1 = g_ppd01
                  CALL cl_doc()
               END IF
            END IF
           WHEN "exporttoexcel"   #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ppd),'','') 
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t920_a()
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   MESSAGE ""
   CLEAR FORM
   CALL g_ppd.clear()
   LET g_wc=NULL
   LET g_ppd01_t = NULL
   LET g_ppd02_t = NULL
   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL t920_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
      CALL t920_b()                      #輸入單身
      LET g_ppd01_t = g_ppd01            #保留舊值
      LET g_ppd02_t = g_ppd02            #保留舊值
      EXIT WHILE
   END WHILE
 
END FUNCTION
   
FUNCTION t920_u()
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   IF g_ppd01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_ppd01_t = g_ppd01
   WHILE TRUE
      CALL t920_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET g_ppd01=g_ppd01_t
         LET g_ppd02=g_ppd02_t
         DISPLAY g_ppd01 TO ppd01 #單頭
         DISPLAY g_ppd02 TO ppd02 #單頭
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_ppd01 != g_ppd01_t OR g_ppd02 != g_ppd02_t THEN
         UPDATE ppd_file SET ppd01 = g_ppd01  #更新DB
          WHERE ppd01 = g_ppd01_t          #COLAUTH?
         IF SQLCA.sqlcode THEN
            LET g_msg = g_ppd01 CLIPPED CLIPPED
            CALL cl_err3("upd","ppd_file",g_ppd01_t,'',
                          SQLCA.sqlcode,"","",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION t920_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改        #No.FUN-680136 VARCHAR(1)
    l_cnt    LIKE type_file.num10           #No.FUN-680136 INTEGER
 
    INPUT g_ppd01,g_ppd02 WITHOUT DEFAULTS 
           FROM ppd01,ppd02
 
        AFTER FIELD ppd02
          SELECT COUNT(*) INTO l_cnt
            FROM pmc_file
           WHERE pmc01 = g_ppd02
           IF l_cnt = 0 THEN NEXT FIELD ppd02 END IF
          SELECT pmc03 INTO g_pmc03 
            FROM pmc_file
           WHERE pmc01 = g_ppd02
          DISPLAY g_pmc03 TO FORMONLY.pmc03
             
        ON ACTION CONTROLP                  
           CASE
              WHEN INFIELD(ppd02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmc" 
                 LET g_qryparam.default1 = g_ppd02
                 CALL cl_create_qry() RETURNING g_ppd02
                 DISPLAY BY NAME g_ppd02
                 NEXT FIELD ppd02
              OTHERWISE         
           END CASE
        #TQC-860019-add
        ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
        #TQC-860019-add
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
    END INPUT
END FUNCTION
 
FUNCTION t920_q()
 
  DEFINE l_ppd01  LIKE ppd_file.ppd01,
         l_cnt    LIKE type_file.num10           #No.FUN-680136 INTEGER
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_ppd01 TO NULL               #No.FUN-6A0162  
   INITIALIZE g_ppd02 TO NULL               #No.FUN-6A0162  
   CALL cl_opmsg('q')
   MESSAGE ""
   CALL t920_cs()                            #取得查詢條件
   IF INT_FLAG THEN                          #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_ppd01 TO NULL
      RETURN
   END IF
   OPEN t920_bcs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                         #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ppd01 TO NULL
   ELSE
      OPEN t920_count
      FETCH t920_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t920_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
FUNCTION t920_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680136 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     t920_bcs INTO g_ppd01,g_ppd02
        WHEN 'P' FETCH PREVIOUS t920_bcs INTO g_ppd01,g_ppd02
        WHEN 'F' FETCH FIRST    t920_bcs INTO g_ppd01,g_ppd02
        WHEN 'L' FETCH LAST     t920_bcs INTO g_ppd01,g_ppd02
        WHEN '/' 
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                
                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump t920_bcs INTO g_ppd01,g_ppd02
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_ppd01,SQLCA.sqlcode,0)
       INITIALIZE g_ppd01 TO NULL  #TQC-6B0105
       INITIALIZE g_ppd02 TO NULL  #TQC-6B0105
    ELSE
       OPEN t920_count
       FETCH t920_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL t920_show()
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
 
FUNCTION t920_show()
    DISPLAY g_ppd01 TO FORMONLY.ppd01  
    DISPLAY g_ppd02 TO FORMONLY.ppd02  
    SELECT pmc03 INTO g_pmc03 
      FROM pmc_file
     WHERE pmc01 = g_ppd02
    DISPLAY g_pmc03 TO FORMONLY.pmc03
    CALL t920_b_fill(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t920_r()
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   IF g_ppd01 IS NULL THEN
      CALL cl_err("",-400,0)                 #No.FUN-6A0162
      RETURN
   END IF
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "ppd01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_ppd01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM ppd_file
       WHERE ppd01 = g_ppd01
         AND ppd02 = g_ppd02
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","ppd_file",g_ppd01,g_ppd02,SQLCA.sqlcode,
                      "","BODY DELETE",1)  #No.FUN-660129
      ELSE
         CLEAR FORM
         CALL g_ppd.clear()
         LET g_delete='Y'
         LET g_ppd01 = NULL
         LET g_ppd02 = NULL
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         DROP TABLE x
         PREPARE t920_precount_x2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE t920_precount_x2                 #No.TQC-720019
         OPEN t920_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE t920_bcs
            CLOSE t920_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH t920_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t920_bcs
            CLOSE t920_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t920_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t920_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL t920_fetch('/')
         END IF
      END IF
   END IF
END FUNCTION
 
#單身
FUNCTION t920_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680136 SMALLINT
    l_str           LIKE type_file.chr20,               #No.FUN-680136 VARCHAR(20)  
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5,                 #可刪除否          #No.FUN-680136 SMALLINT
    l_cnt           LIKE type_file.num10           #No.FUN-680136 INTEGER
 
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_ppd01 IS NULL THEN
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ppd03,'',ppd04",
                       "  FROM ppd_file",
                       "  WHERE ppd01=? AND ppd02=? ",
                       "   AND ppd03=? ",
                       "   FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t920_bcl CURSOR FROM g_forupd_sql
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ppd WITHOUT DEFAULTS FROM s_ppd.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=FALSE)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           IF g_rec_b >= l_ac THEN
              BEGIN WORK
              LET p_cmd='u'
              LET g_ppd_t.* = g_ppd[l_ac].*      #BACKUP
              OPEN t920_bcl USING g_ppd01,g_ppd02,g_ppd_t.ppd03
              FETCH t920_bcl INTO g_ppd[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_ppd_t.ppd03,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              ELSE
                 SELECT ppa03 INTO g_ppd[l_ac].ppa03 
                   FROM ppa_file
                  WHERE ppa02 = g_ppd[l_ac].ppd03
                 DISPLAY BY NAME g_ppd[l_ac].ppa03
              END IF
              LET g_ppd_t.* = g_ppd[l_ac].*      #BACKUP
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        AFTER FIELD ppd03
            IF NOT cl_null(g_ppd[l_ac].ppd03) THEN
               SELECT ppa03 INTO g_ppd[l_ac].ppa03
                 FROM ppa_file
                WHERE ppa02 = g_ppd[l_ac].ppd03
               DISPLAY BY NAME g_ppd[l_ac].ppa03
            END IF
 
        AFTER FIELD ppd04
           IF g_ppd[l_ac].ppd04 < 0 OR g_ppd[l_ac].ppd04 > 100 THEN
               NEXT FIELD ppd04
           END IF
  
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_ppd[l_ac].* TO NULL      #900423
           LET g_ppd_t.* = g_ppd[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD ppd03
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
 
           INSERT INTO ppd_file(ppd01,ppd02,ppd03,ppd04)
           VALUES(g_ppd01,g_ppd02,g_ppd[l_ac].ppd03,
                  g_ppd[l_ac].ppd04)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","ppd_file",g_ppd[l_ac].ppd03,"",
                            SQLCA.sqlcode,"","",1)  #No.FUN-660129
              LET g_ppd[l_ac].* = g_ppd_t.*
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              COMMIT WORK
           END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_ppd[l_ac].ppd03 IS NOT NULL AND g_ppd_t.ppd03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              DELETE FROM ppd_file
               WHERE ppd01 = g_ppd01
                 AND ppd02 = g_ppd02
                 AND ppd03 = g_ppd_t.ppd03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","ppd_file",g_ppd_t.ppd03,"",
                               SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 ROLLBACK WORK
                 CANCEL DELETE 
              END IF
              COMMIT WORK
              LET g_rec_b=g_rec_b-1
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ppd[l_ac].* = g_ppd_t.*
              CLOSE t920_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ppd[l_ac].ppd03,-263,1)
              LET g_ppd[l_ac].* = g_ppd_t.*
           ELSE
              UPDATE ppd_file SET ppd03=g_ppd[l_ac].ppd03,
                                  ppd04=g_ppd[l_ac].ppd04
               WHERE ppd01=g_ppd01
                 AND ppd02=g_ppd02
                 AND ppd03=g_ppd_t.ppd03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","ppd_file",g_ppd[l_ac].ppd03,"",
                               SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_ppd[l_ac].* = g_ppd_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
        #  LET l_ac_t = l_ac   #FUN-D30034
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN 
                 LET g_ppd[l_ac].* = g_ppd_t.*
            #FUN-D30034--add--str--
              ELSE
                 CALL g_ppd.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30034--add--end--
              END IF 
              CLOSE t920_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30034
           CLOSE t920_bcl
           COMMIT WORK
 
        ON ACTION CONTROLP                  
           CASE
              WHEN INFIELD(ppd03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ppa" 
                 LET g_qryparam.default1 = g_ppd[l_ac].ppd03
                 CALL cl_create_qry() RETURNING g_ppd[l_ac].ppd03
                 DISPLAY BY NAME g_ppd[l_ac].ppd03 
                 NEXT FIELD ppd03
              OTHERWISE         
           END CASE
         
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(ppd03) AND l_ac > 1 THEN
              LET g_ppd[l_ac].* = g_ppd[l_ac-1].*
              NEXT FIELD ppd03
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    
    END INPUT
 
    CLOSE t920_bcl
        COMMIT WORK
 
END FUNCTION
 
FUNCTION t920_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
    LET g_sql = "SELECT ppd03,'',ppd04",
                "  FROM ppd_file ",
                " WHERE ppd01 = '",g_ppd01,"'", 
                "   AND ppd02 = '",g_ppd02,"'",
                "   AND ",p_wc CLIPPED ,
                " ORDER BY 1"
    PREPARE t920_prepare2 FROM g_sql      #預備一下
    DECLARE ppd_cs CURSOR FOR t920_prepare2
 
    CALL g_ppd.clear()   #FUN-5A0157
    LET g_cnt = 1
    LET g_rec_b=0
 
    FOREACH ppd_cs INTO g_ppd[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF 
       SELECT ppa03 INTO g_ppd[g_cnt].ppa03
         FROM ppa_file
        WHERE ppa02 = g_ppd[g_cnt].ppd03
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ppd.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1               #no.6277
    LET g_cnt = 0
   
END FUNCTION
 
FUNCTION t920_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_ppd TO s_ppd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_sl = SCR_LINE()
 
#      ON ACTION insert
#         LET g_action_choice="insert"
#         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
      ON ACTION first 
         CALL t920_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION previous
         CALL t920_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION jump 
         CALL t920_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION next
         CALL t920_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION last 
         CALL t920_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
     #str TQC-750068 mark
     #ON ACTION reproduce
     #   LET g_action_choice="reproduce"
     #   EXIT DISPLAY
     #end TQC-750068 mark
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION supplier_evaluation
         LET g_action_choice="supplier_evaluation"
         EXIT DISPLAY
 
#     ON ACTION output             #TQC-790095
#        LET g_action_choice="output"  #TQC-790095
#        EXIT DISPLAY                  #TQC-790095   
 
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
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
   
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
       ON ACTION related_document  #No.MOD-470518
         LET g_action_choice="related_document"
         EXIT DISPLAY
    
      ON ACTION exporttoexcel    #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY   #TQC-5B0076
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      #TQC-860019-add
       ON IDLE g_idle_seconds
       CALL cl_on_idle  ()
       CONTINUE DISPLAY
      #TQC-860019-add
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t920_result()
  DEFINE tm RECORD
         wc       LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(1500)
         pmc02    LIKE pmc_file.pmc02,  #廠商分類  #No.MOD-740366
         pmc01    LIKE pmc_file.pmc01,
         dat      LIKE ppd_file.ppd01
         END RECORD 
  DEFINE g_ppd    RECORD LIKE ppd_file.*
  DEFINE l_cnt    LIKE type_file.num10
  DEFINE l_cnt1   LIKE type_file.num10
  DEFINE l_cnt2   LIKE type_file.num10
  DEFINE #l_sql    LIKE type_file.chr1000
         l_sql        STRING       #NO.FUN-910082  
  DEFINE l_pmc01  LIKE pmc_file.pmc01
  DEFINE l_ppc02  LIKE ppc_file.ppc02
  DEFINE l_yy     LIKE type_file.chr4
  DEFINE l_mm     LIKE type_file.chr2
 
   OPEN WINDOW t9201_w WITH FORM "apm/42f/apmt9201"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_locale("apmt9201")
 
   LET g_success = 'Y'
 
   BEGIN WORK
 
   CONSTRUCT tm.wc ON pmc02,pmc01 #螢幕上取條件
           FROM pmc02,pmc01
 
           #No.FUN-580031 --start--     HCN
           BEFORE CONSTRUCT
              CALL cl_qbe_init()
          #No.FUN-580031 --end--       HCN
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(pmc02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_pmy" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmc02  #No.MOD-740366
                 NEXT FIELD pmc02  #No.MOD-740366
            WHEN INFIELD(pmc01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_pmc" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmc01
                 NEXT FIELD pmc01
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
 
   END CONSTRUCT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_success = 'N'
      ROLLBACK WORK       #No:7829
      CLOSE WINDOW t9201_w
      CALL t920_show()
      RETURN
   END IF
 
   LET l_yy = year(g_today)
   LET l_mm = month(g_today)
   IF l_mm < 10 THEN LET l_mm = '0',l_mm END IF
   LET tm.dat = l_yy CLIPPED,l_mm
   DISPLAY tm.dat TO FORMONLY.dat
   
   INPUT tm.dat WITHOUT DEFAULTS 
           FROM dat
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_success = 'N'
      ROLLBACK WORK       #No:7829
      CLOSE WINDOW t9201_w
      CALL t920_show()
      RETURN
   END IF
 
   BEGIN WORK
 
   LET l_sql = "SELECT pmc01,ppc02",
               "  FROM pmc_file,ppc_file ",
               " WHERE pmc02 = ppc01",
               "   AND ",tm.wc ,
               " ORDER BY pmc01,ppc02"
  
     PREPARE t9201_pre FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('t9201_pre',STATUS,1) END IF
     DECLARE t9201_c CURSOR FOR t9201_pre
     IF SQLCA.sqlcode THEN CALL cl_err('t9201_exp_c',STATUS,1) END IF
     CALL s_showmsg_init()                 #No.FUN-710046
     LET l_cnt = 0 #MOD-B30279 add
     FOREACH t9201_c INTO l_pmc01,l_ppc02
         IF SQLCA.SQLCODE THEN LET g_success = 'N' EXIT FOREACH END IF
         SELECT COUNT(*) INTO l_cnt1
           FROM sma_file
          WHERE ((sma910=l_ppc02) OR (sma911=l_ppc02) OR (sma912=l_ppc02) OR (sma913=l_ppc02))
         IF l_cnt1 > 0 THEN CONTINUE FOREACH END IF
 
         LET g_ppd.ppd01 = tm.dat
         LET g_ppd.ppd02 = l_pmc01
         LET g_ppd.ppd03 = l_ppc02
         SELECT COUNT(*) INTO l_cnt2
           FROM ppd_file
          WHERE ppd01 = g_ppd.ppd01
            AND ppd02 = g_ppd.ppd02
            AND ppd03 = g_ppd.ppd03
         IF l_cnt2 = 0 THEN
             INSERT INTO ppd_file(ppd01,ppd02,ppd03,ppd04)
                           VALUES(g_ppd.ppd01,g_ppd.ppd02,g_ppd.ppd03,NULL)
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","ppd_file",g_ppd.ppd01,g_ppd.ppd02,
                              SQLCA.sqlcode,"","",1)  
                LET g_success = 'N'
             ELSE
                LET l_cnt = l_cnt + 1 #MOD-B30279 add
                LET g_success = 'Y'
             END IF
         END IF
     END FOREACH
     #MOD-B30279 mod --start--
    #IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF 
     IF g_success = 'Y' THEN 
        IF l_cnt > 0 THEN
           CALL cl_err('','apm-144',0)
        ELSE
           CALL cl_err('','apm-145',0)
        END IF
        COMMIT WORK 
     ELSE 
        CALL cl_err('','apm-146',0)
        ROLLBACK WORK 
     END IF
     #MOD-B30279 mod --end--
     LET g_wc = '1=1'
     CLOSE WINDOW t9201_w
 
END FUNCTION
 
