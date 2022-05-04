# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apmi051.4gl
# Descriptions...: 調撥流程維護
# Date & Author..: 06/03/14 By Nicola
# Modify.........: No.MOD-640042 06/04/08 By Nicola 預設採購單別需存在在需求工廠
#                                                   輸入流程代號時,需判斷流程代號的來源工廠= 需求工廠
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.FUN-6A0162 06/11/07 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: NO.FUN-670007 06/11/28 by Yiting poz05功能己移到poy04設定 
# Modify.........: NO.TQC-6C0212 06/12/29 By xufeng 錄入時，缺省采購單別欄位開窗即彈出程序 
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760086 07/06/15 By rainy 單身輸入相同的撥出/撥入工廠,但是卻在整筆單身資料全部Key好後,求說明-239重覆,應改在輸入好單身撥入工廠時就判斷是否Key值重覆,並show訊息
# Modify.........: No.TQC-760088 07/06/15 By rainy 輸入預設調撥流程後會出現tri-006
# Modify.........: No.TQC-760089 07/06/15 By rainy 先查詢不下任何條件,查出資料,按單身,再離開單身,按下一筆,卻出現-400
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-820002 08/02/25 By lutingting 報表由p_query 輸出 
# Modify.........: No.MOD-930232 09/03/27 By Smapmin 輸入調撥流程代碼時,針對撥出/撥入工廠的判斷顛倒
# Modify.........: No.MOD-950188 09/07/07 By Smapmin 預設採購單別要抓取撥入資料庫的採購單別
# Modify.........: No.TQC-970353 09/07/29 By dxfwo  1. 397行的 DISPLAY BY NAME g                                                    
#2. 函式 FUNCTION i051_lock()中的sql，在單身打完采購單別會進來，但此時的g_wc可能                                                    
#3. 這支的架構很奇怪，進單身做新增/修改/刪除的問題很多                                                                              
#    3.1 先查詢原本存在的數據，新增單身數據后按取消，再進單身，open i051_bcs就會有問題 (declare i051_bcs的位置很怪)                                                    
#    3.2 因為單身有直接去轉換數據庫，所以假設我新增單身打完需求工廠跟采購單別后按取消，數據庫就停在我單身打的那個營運中心，之后再下查詢出來的資料也都是單身的那                                                    
#    3.3 單身字段不為空白不要直接用程序去判斷，設4fd的not null,required就好了，否則我新增了好幾筆，最后一筆一定要按取消才能離開" 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.TQC-D40055 13/-4/22 By SunLM 調整傳入參數

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_pnw01      LIKE pnw_file.pnw01,
       g_pnw01_t    LIKE pnw_file.pnw01,
       g_geu02      LIKE geu_file.geu02,
       g_pnw        DYNAMIC ARRAY OF RECORD
                       pnw02   LIKE pnw_file.pnw02,
                       azp02_1 LIKE azp_file.azp02,
                       pnw03   LIKE pnw_file.pnw03,
                       azp02_2 LIKE azp_file.azp02,
                       pnw04   LIKE pnw_file.pnw04,
                       pnw05   LIKE pnw_file.pnw05,
                       pnw06   LIKE pnw_file.pnw06
                    END RECORD,
       g_pnw_t      RECORD
                       pnw02   LIKE pnw_file.pnw02,
                       azp02_1 LIKE azp_file.azp02,
                       pnw03   LIKE pnw_file.pnw03,
                       azp02_2 LIKE azp_file.azp02,
                       pnw04   LIKE pnw_file.pnw04,
                       pnw05   LIKE pnw_file.pnw05,
                       pnw06   LIKE pnw_file.pnw06
                    END RECORD,
       g_wc,g_sql   STRING,
       g_rec_b      LIKE type_file.num5,         #No.FUN-680136 SMALLINT
       l_ac         LIKE type_file.num5          #No.FUN-680136 SMALLINT
DEFINE g_forupd_sql STRING
DEFINE g_sql_tmp    STRING #No.TQC-720019
DEFINE g_before_input_done LIKE type_file.num5   #No.FUN-680136 SMALLINT
DEFINE g_cnt        LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_msg        LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_curs_index LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_jump       LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5          #No.FUN-680136 SMALLINT
DEFINE li_result    LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW i051_w WITH FORM "apm/42f/apmi051"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL i051_menu()
 
   CLOSE WINDOW i051_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i051_cs()
 
   CLEAR FORM
   CALL g_pnw.clear()
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032 
   INITIALIZE g_pnw01 TO NULL    #No.FUN-750051
   CONSTRUCT g_wc ON pnw01,pnw02,pnw03,pnw04,pnw05,pnw06
        FROM pnw01,s_pnw[1].pnw02,s_pnw[1].pnw03,s_pnw[1].pnw04,
             s_pnw[1].pnw05,s_pnw[1].pnw06
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pnw01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_geu"
               LET g_qryparam.arg1 = "4"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pnw01
               NEXT FIELD pnw01
            WHEN INFIELD(pnw02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pnw02
               NEXT FIELD pnw02
            WHEN INFIELD(pnw03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pnw03
               NEXT FIELD pnw03
            WHEN INFIELD(pnw05)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_poz1"
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1 = "2"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pnw05
               NEXT FIELD pnw05
            OTHERWISE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
    
      ON ACTION help
         CALL cl_show_help()
    
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
  
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pnwuser', 'pnwgrup') #FUN-980030
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   CALL i051_lock()
 
  #LET g_sql = "SELECT UNIQUE pnw01 FROM pnw_file ",
  #            " WHERE ", g_wc CLIPPED,
  #            " ORDER BY pnw01"
 
  #PREPARE i051_prepare FROM g_sql
  #DECLARE i051_bcs SCROLL CURSOR WITH HOLD FOR i051_prepare
 
#  LET g_sql = "SELECT UNIQUE pnw01 FROM pnw_file ",      #No.TQC-720019
   LET g_sql_tmp = "SELECT UNIQUE pnw01 FROM pnw_file ",  #No.TQC-720019
               " WHERE ", g_wc CLIPPED,
               " INTO TEMP x "
   DROP TABLE x
#  PREPARE i051_precount_x FROM g_sql      #No.TQC-720019
   PREPARE i051_precount_x FROM g_sql_tmp  #No.TQC-720019
   EXECUTE i051_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE i051_precount FROM g_sql
   DECLARE i051_count CURSOR FOR i051_precount
 
END FUNCTION
 
#-----No.MOD-640042-----
FUNCTION i051_lock()
   IF cl_null(g_wc) THEN    #No.TQC-970353  dxfwo  add                                                                              
    LET g_wc = '1=1'        #No.TQC-970353  dxfwo  add                                                                              
   END IF                   #No.TQC-970353  dxfwo  add
 
   LET g_sql = "SELECT UNIQUE pnw01 FROM pnw_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY pnw01"
 
   PREPARE i051_prepare FROM g_sql
   DECLARE i051_bcs SCROLL CURSOR WITH HOLD FOR i051_prepare
 
   LET g_forupd_sql = "SELECT pnw02,'',pnw03,'',pnw04,pnw05,pnw06",
                      "  FROM pnw_file",
                      "  WHERE pnw01=? ",
                      "   AND pnw02=? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i051_bcl CURSOR FROM g_forupd_sql
 
END FUNCTION 
#-----No.MOD-640042-----
 
FUNCTION i051_menu()
 
 
   WHILE TRUE
      CALL i051_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i051_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i051_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i051_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i051_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i051_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i051_out()    
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pnw),'','')
            END IF
         #No.FUN-6A0162-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_pnw01 IS NOT NULL THEN
                 LET g_doc.column1 = "pnw01"
                 LET g_doc.value1 = g_pnw01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0162-------add--------end----
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i051_a()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   MESSAGE ""
   CLEAR FORM
   CALL g_pnw.clear()
   LET g_pnw01_t = NULL
   LET g_pnw01   = NULL   #No.TQC-970353  dxfwo  add  
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i051_i("a")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      LET g_rec_b = 0
      DISPLAY g_rec_b TO FORMONLY.cn2
 
      CALL i051_b()
 
      LET g_pnw01_t = g_pnw01
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i051_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pnw01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_pnw01_t = g_pnw01
 
   WHILE TRUE
      CALL i051_i("u") 
 
      IF INT_FLAG THEN
         LET g_pnw01 = g_pnw01_t
         DISPLAY g_pnw01 TO pnw01
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_pnw01 != g_pnw01_t THEN
         UPDATE pnw_file SET pnw01 = g_pnw01 
          WHERE pnw01 = g_pnw01_t
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_pnw01,SQLCA.sqlcode,0)   #No.FUN-660129
            CALL cl_err3("upd","pnw_file",g_pnw01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i051_i(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680136 VARCHAR(1)
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INPUT g_pnw01 WITHOUT DEFAULTS FROM pnw01
 
      AFTER FIELD pnw01
         IF NOT cl_null(g_pnw01) THEN
            IF g_pnw01 != g_pnw01_t OR g_pnw01_t IS NULL THEN
               SELECT geu02 INTO g_geu02 FROM geu_file
                WHERE geu01 = g_pnw01
                  AND geu00 = "4"
               IF STATUS THEN
#                 CALL cl_err(g_pnw01,"anm-027",0)   #No.FUN-660129
                  CALL cl_err3("sel","geu_file",g_pnw01,"","anm-027","","",1)  #No.FUN-660129
                  NEXT FIELD pnw01
               ELSE
                  DISPLAY g_geu02 TO azp02
               END IF
               SELECT COUNT(*) INTO g_cnt FROM pnw_file
                WHERE pnw01 = g_pnw01
               IF g_cnt > 0 THEN
                  CALL cl_err("","axm-298",0)
                  NEXT FIELD pnw01
               END IF
            END IF
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pnw01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_geu"
               LET g_qryparam.arg1 = "4"
               LET g_qryparam.default1 = g_pnw01
               CALL cl_create_qry() RETURNING g_pnw01
#              DISPLAY BY NAME g_pnw01        #No.TQC-970353                                                                        
               DISPLAY g_pnw01 to  pnw01      #No.TQC-970353 
               NEXT FIELD pnw01
            OTHERWISE
         END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
   END INPUT
 
END FUNCTION
 
FUNCTION i051_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   INITIALIZE g_pnw01 TO NULL             #No.FUN-6A0162
 
   MESSAGE ""
   CALL cl_opmsg('q')
 
   CALL i051_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_pnw01 TO NULL
      RETURN
   END IF
 
   OPEN i051_bcs
   IF SQLCA.sqlcode THEN
      CALL cl_err("",SQLCA.sqlcode,0)
      INITIALIZE g_pnw01 TO NULL
   ELSE
      CALL i051_fetch('F')
      OPEN i051_count
      FETCH i051_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF
 
END FUNCTION
 
FUNCTION i051_fetch(p_flag)
DEFINE p_flag   LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
       l_abso   LIKE type_file.num10         #No.FUN-680136 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i051_bcs INTO g_pnw01
      WHEN 'P' FETCH PREVIOUS i051_bcs INTO g_pnw01
      WHEN 'F' FETCH FIRST    i051_bcs INTO g_pnw01
      WHEN 'L' FETCH LAST     i051_bcs INTO g_pnw01
      WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
 
            PROMPT g_msg CLIPPED,': ' FOR g_jump
 
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about
                  CALL cl_about()
              
               ON ACTION help
                  CALL cl_show_help()
              
               ON ACTION controlg
                  CALL cl_cmdask()
 
               END PROMPT
 
               IF INT_FLAG THEN
                  LET INT_FLAG = 0
                  EXIT CASE
               END IF
            END IF
 
            FETCH ABSOLUTE g_jump i051_bcs INTO g_pnw01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_pnw01,SQLCA.sqlcode,0)
      INITIALIZE g_pnw01 TO NULL  #TQC-6B0105
   ELSE
      CALL i051_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index,g_row_count)
   END IF
 
END FUNCTION
 
FUNCTION i051_show()
 
   SELECT geu02 INTO g_geu02 FROM geu_file
    WHERE geu01 = g_pnw01
 
   DISPLAY g_pnw01,g_geu02 TO pnw01,geu02
 
   CALL i051_b_fill(g_wc)
 
   CALL cl_show_fld_cont()
 
END FUNCTION
 
FUNCTION i051_r()
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_pnw01 IS NULL THEN
      CALL cl_err("",-400,0)                 #No.FUN-6A0162
      RETURN
   END IF
 
   IF cl_delh(0,0) THEN
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "pnw01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_pnw01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                      #No.FUN-9B0098 10/02/24
      DELETE FROM pnw_file
       WHERE pnw01 = g_pnw01
      IF SQLCA.sqlcode THEN
#        CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660129
         CALL cl_err3("del","pnw_file",g_pnw01,"",SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660129
      ELSE
         CLEAR FORM
         CALL g_pnw.clear()
         LET g_pnw01 = NULL
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
 
         DROP TABLE x                             #No.TQC-720019
         PREPARE i051_precount_x2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE i051_precount_x2                 #No.TQC-72019
         OPEN i051_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE i051_bcs
            CLOSE i051_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH i051_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i051_bcs
            CLOSE i051_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
 
         OPEN i051_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i051_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i051_fetch('/')
         END IF
      END IF
   END IF
 
END FUNCTION
 
FUNCTION i051_b()
   DEFINE l_ac_t          LIKE type_file.num5,      #No.FUN-680136 SMALLINT
          l_n             LIKE type_file.num5,      #No.FUN-680136 SMALLINT
          l_lock_sw       LIKE type_file.chr1,      #No.FUN-680136 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,      #No.FUN-680136 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,      #No.FUN-680136 SMALLINT
          l_allow_delete  LIKE type_file.num5       #No.FUN-680136 SMALLINT
   DEFINE l_pnw04         LIKE pnw_file.pnw04
   DEFINE l_azp03         LIKE azp_file.azp03       #No.MOD-640042
   DEFINE l_poy04         LIKE poy_file.poy04       #No.MOD-640042
   DEFINE l_cnt           LIKE type_file.num5       #TQC-760086
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_pnw01 IS NULL THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   #CALL i051_lock()   #No.MOD-640042  #TQC-760089   
 
  #LET g_forupd_sql = "SELECT pnw02,'',pnw03,'',pnw04,pnw05,pnw06",
  #                   "  FROM pnw_file",
  #                   "  WHERE pnw01=? ",
  #                   "   AND pnw02=? FOR UPDATE"
 
  #DECLARE i051_bcl CURSOR FROM g_forupd_sql
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_pnw WITHOUT DEFAULTS FROM s_pnw.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_pnw_t.* = g_pnw[l_ac].*
            BEGIN WORK
            CALL i051_lock()   #No.TQC-970353 
            OPEN i051_bcl USING g_pnw01,g_pnw_t.pnw02
            IF STATUS THEN
               CALL cl_err("OPEN i051_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i051_bcl INTO g_pnw[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_pnw_t.pnw02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  SELECT azp02 INTO g_pnw[l_ac].azp02_1
                    FROM azp_file
                   WHERE azp01 = g_pnw[l_ac].pnw02 
                  SELECT azp02,azp03 INTO g_pnw[l_ac].azp02_2,l_azp03   #No.MOD-640042
                    FROM azp_file
                   WHERE azp01 = g_pnw[l_ac].pnw03
                  DISPLAY BY NAME g_pnw[l_ac].azp02_1,g_pnw[l_ac].azp02_2
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_pnw[l_ac].* TO NULL
         LET g_pnw_t.* = g_pnw[l_ac].*
         LET g_pnw[l_ac].pnw06 = 0
         CALL cl_show_fld_cont()
         NEXT FIELD pnw02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO pnw_file(pnw01,pnw02,pnw03,pnw04,pnw05,pnw06,pnworiu,pnworig)
              VALUES(g_pnw01,g_pnw[l_ac].pnw02,g_pnw[l_ac].pnw03,
                     g_pnw[l_ac].pnw04,g_pnw[l_ac].pnw05,
                     g_pnw[l_ac].pnw06, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_pnw[l_ac].pnw02,SQLCA.sqlcode,0)   #No.FUN-660129
            CALL cl_err3("ins","pnw_file",g_pnw[l_ac].pnw02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      AFTER FIELD pnw02
         IF NOT cl_null(g_pnw[l_ac].pnw02) THEN
            IF g_pnw[l_ac].pnw02 != g_pnw_t.pnw02 OR cl_null(g_pnw_t.pnw02) THEN
               IF g_pnw[l_ac].pnw02 = g_pnw[l_ac].pnw03 THEN
                  CALL cl_err(g_pnw[l_ac].pnw02,"apm-101",0)
                  NEXT FIELD pnw02
               END IF
             #TQC-760086 begin
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt 
                 FROM pnw_file
                WHERE pnw01 = g_pnw01
                  AND pnw02 = g_pnw[l_ac].pnw02
                  AND pnw03 = g_pnw[l_ac].pnw03
               IF l_cnt>0 THEN
                 CALL cl_err(g_pnw[l_ac].pnw02,'-239',0)
                 NEXT FIELD pnw02
               END IF
             #TQC-760086 end
               SELECT azp02 INTO g_pnw[l_ac].azp02_1 FROM azp_file
                WHERE azp01 = g_pnw[l_ac].pnw02
               IF STATUS THEN
#                 CALL cl_err(g_pnw[l_ac].pnw02,"aap-025",0)   #No.FUN-660129
                  CALL cl_err3("sel","azp_file",g_pnw[l_ac].pnw02,"",
                               "aap-025","","",1)  #No.FUN-660129
                  NEXT FIELD pnw02
               ELSE
                  DISPLAY BY NAME g_pnw[l_ac].azp02_1
               END IF
            END IF
         END IF
 
      AFTER FIELD pnw03
         IF NOT cl_null(g_pnw[l_ac].pnw03) THEN
            IF g_pnw[l_ac].pnw03 != g_pnw_t.pnw03 OR cl_null(g_pnw_t.pnw03) THEN
               IF g_pnw[l_ac].pnw02 = g_pnw[l_ac].pnw03 THEN
                  CALL cl_err(g_pnw[l_ac].pnw03,"apm-101",0)
                  NEXT FIELD pnw03
               END IF
             #TQC-760086 begin
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt 
                 FROM pnw_file
                WHERE pnw01 = g_pnw01
                  AND pnw02 = g_pnw[l_ac].pnw02
                  AND pnw03 = g_pnw[l_ac].pnw03
               IF l_cnt>0 THEN
                 CALL cl_err(g_pnw[l_ac].pnw03,'-239',0)
                 NEXT FIELD pnw03
               END IF
             #TQC-760086 end
               #SELECT azp02 INTO g_pnw[l_ac].azp02_2 FROM azp_file   #MOD-950188
               SELECT azp02,azp03 INTO g_pnw[l_ac].azp02_2,l_azp03 FROM azp_file   #MOD-950188
                WHERE azp01 = g_pnw[l_ac].pnw03
               IF STATUS THEN
#                 CALL cl_err(g_pnw[l_ac].pnw03,"aap-025",0)   #No.FUN-660129
                  CALL cl_err3("sel","azp_file",g_pnw[l_ac].pnw03,"",
                               "aap-025","","",1)  #No.FUN-660129
                  NEXT FIELD pnw02
               ELSE
                  DISPLAY BY NAME g_pnw[l_ac].azp02_2
               END IF
            END IF
         END IF
 
      AFTER FIELD pnw04
         IF NOT cl_null(g_pnw[l_ac].pnw04) THEN
            IF g_pnw[l_ac].pnw04 != g_pnw_t.pnw04 OR cl_null(g_pnw_t.pnw04) THEN
              #DATABASE l_azp03   #No.MOD-640042  TQC-6C0212 mark
               #-----MOD-950188---------
               ##No.TQC-6C0212  -begin 
               #IF NOT cl_null(l_azp03) THEN
               #   CLOSE DATABASE   #TQC-760088
               #   DATABASE l_azp03
               #END IF
               ##No.TQC-6C0212  --end
           #    CALL cl_ins_del_sid(2) #FUN-980030    #FUN-990069
               CALL cl_ins_del_sid(2,'') #FUN-980030    #FUN-990069
               CLOSE DATABASE
               DATABASE l_azp03
           #    CALL cl_ins_del_sid(1) #FUN-980030    #FUN-990069
               CALL cl_ins_del_sid(1,g_pnw[l_ac].pnw03) #FUN-980030    #FUN-990069
               #-----END MOD-950188-----
               #TQC-D40055 add begin-------
               #CALL s_check_no("apm",g_pnw[l_ac].pnw04,"g_pnw_t.pnw04","2",
               #                "pnw_file","pnw04","")
               #      RETURNING li_result,l_pnw04
               CALL s_check_no("apm",g_pnw[l_ac].pnw04,g_pnw_t.pnw04,"2",
                               "pnw_file","pnw04",g_pnw[l_ac].pnw03)
                     RETURNING li_result,l_pnw04   
               #TQC-D40055 add end--------- 
               IF NOT li_result THEN
                  CALL cl_err("","mfg3046",0)
                  LET g_pnw[l_ac].pnw04 = g_pnw_t.pnw04
                  NEXT FIELD pnw04
               END IF
              #DATABASE g_dbs   #No.MOD-640042   #No.TQC-6C0212 mark
               #-----MOD-950188---------
               ##No.TQC-6C0212  -begin 
               #IF NOT cl_null(l_azp03) THEN
               #   CLOSE DATABASE   #TQC-760088
               #   DATABASE l_azp03
               #END IF
               ##No.TQC-6C0212  --end
          #     CALL cl_ins_del_sid(2) #FUN-980030   #FUN-990069
               CALL cl_ins_del_sid(2,'') #FUN-980030   #FUN-990069
               CLOSE DATABASE
               DATABASE g_dbs
          #     CALL cl_ins_del_sid(1) #FUN-980030   #FUN-990069
               CALL cl_ins_del_sid(1,g_plant) #FUN-980030   #FUN-990069
               #-----END MOD-950188-----
               CALL i051_lock()   #No.MOD-640042
               OPEN i051_bcs   #No.MOD-640042
               FETCH ABSOLUTE g_curs_index i051_bcs INTO g_pnw01   #No.MOD-640042
            END IF
         END IF
 
      AFTER FIELD pnw05
         IF NOT cl_null(g_pnw[l_ac].pnw05) THEN
            #IF g_pnw[l_ac].pnw05 != g_pnw_t.pnw05 OR cl_null(g_pnw_t.pnw05) THEN   #FUN-670007 mark
#NO.FUN-670007 start--
               SELECT COUNT(*) INTO g_cnt
                 FROM poz_file,poy_file
                WHERE poz00 = "2"
                  AND poz01 = g_pnw[l_ac].pnw05   #No.MOD-640042
                  AND poz01 = poy01 
                  #AND poy04 = g_pnw[l_ac].pnw02   #MOD-930232
                  AND poy04 = g_pnw[l_ac].pnw03    #MOD-930232
                  AND poy02 = '0'
#               SELECT COUNT(*) INTO g_cnt
#                 FROM poz_file
#                WHERE poz00 = "2"
#                  AND poz01 = g_pnw[l_ac].pnw05   #No.MOD-640042
#                  AND poz05 = g_pnw[l_ac].pnw02
#               IF STATUS THEN
                IF g_cnt = 0 THEN
#NO.FUN-670007 end-----
                  CALL cl_err("","tri-006",0)  
                  LET g_pnw[l_ac].pnw05 = g_pnw_t.pnw05
                  NEXT FIELD pnw05
               END IF
               #-----No.MOD-640042-----
               SELECT poy04 INTO l_poy04 FROM poy_file
                WHERE poy02 = (SELECT MAX(poy02) FROM poy_file
                                WHERE poy01 = g_pnw[l_ac].pnw05
                                GROUP BY poy01)
                  AND poy01 = g_pnw[l_ac].pnw05
               #IF l_poy04 <> g_pnw[l_ac].pnw03 THEN   #MOD-930232
               IF l_poy04 <> g_pnw[l_ac].pnw02 THEN   #MOD-930232
                  CALL cl_err("","apm-993",0)
                  NEXT FIELD pnw05
               END IF
               #-----No.MOD-640042 END-----
            #END IF    #FUN-670007 mark
         END IF
 
      AFTER FIELD pnw06
#        IF cl_null(g_pnw[l_ac].pnw06) OR g_pnw[l_ac].pnw06 < 0 THEN  #No.TQC-970353 
#           CALL cl_err("","asf-745",0)                               #No.TQC-970353             
#           LET g_pnw[l_ac].pnw06 = g_pnw_t.pnw06                     #No.TQC-970353 
#           NEXT FIELD pnw06                                          #No.TQC-970353 
#        END IF                                                       #No.TQC-970353       
 
      BEFORE DELETE
         IF NOT cl_null(g_pnw_t.pnw02) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM pnw_file
             WHERE pnw01 = g_pnw01
               AND pnw02 = g_pnw_t.pnw02
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_pnw_t.pnw02,SQLCA.sqlcode,0)   #No.FUN-660129
               CALL cl_err3("del","pnw_file",g_pnw_t.pnw02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            COMMIT WORK
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      ON ROW CHANGE
#No.TQC-970353--begin--                                                                                                             
         SELECT azp03 INTO l_azp03  FROM azp_file                                                                                   
          WHERE azp01 = g_plant                                                                                                     
      #    CALL cl_ins_del_sid(2) #FUN-980030    #FUN-990069
          CALL cl_ins_del_sid(2,'') #FUN-980030    #FUN-990069
          CLOSE DATABASE                                                                                                            
          DATABASE l_azp03                                                                                                          
      #    CALL cl_ins_del_sid(1) #FUN-980030     #FUN-990069
          CALL cl_ins_del_sid(1,g_plant) #FUN-980030     #FUN-990069
#No.TQC-970353 --end-- 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_pnw[l_ac].* = g_pnw_t.*
            CLOSE i051_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_pnw[l_ac].pnw02,-263,1)
            LET g_pnw[l_ac].* = g_pnw_t.*
         ELSE
            UPDATE pnw_file SET pnw02 = g_pnw[l_ac].pnw02,
                                pnw03 = g_pnw[l_ac].pnw03,
                                pnw04 = g_pnw[l_ac].pnw04,
                                pnw05 = g_pnw[l_ac].pnw05,
                                pnw06 = g_pnw[l_ac].pnw06
             WHERE pnw01 = g_pnw01
               AND pnw02 = g_pnw_t.pnw02
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_pnw[l_ac].pnw02,SQLCA.sqlcode,0)   #No.FUN-660129
               CALL cl_err3("upd","pnw_file",g_pnw[l_ac].pnw02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
               LET g_pnw[l_ac].* = g_pnw_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
#No.TQC-970353--begin--                                                                                                             
         SELECT azp03 INTO l_azp03  FROM azp_file                                                                                   
          WHERE azp01 = g_plant                                                                                                     
         # CALL cl_ins_del_sid(2) #FUN-980030  #FUN-990069
          CALL cl_ins_del_sid(2,'') #FUN-980030  #FUN-990069
          CLOSE DATABASE                                                                                                            
          DATABASE l_azp03                                                                                                          
      #    CALL cl_ins_del_sid(1) #FUN-980030   #FUN-990069
          CALL cl_ins_del_sid(1,g_plant) #FUN-980030   #FUN-990069
#No.TQC-970353 --end-- 
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac                #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_pnw[l_ac].* = g_pnw_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_pnw.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE i051_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac                #FUN-D30034 add
         CLOSE i051_bcl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pnw02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azp"
               LET g_qryparam.default1 = g_pnw[l_ac].pnw02
               CALL cl_create_qry() RETURNING g_pnw[l_ac].pnw02
               DISPLAY BY NAME g_pnw[l_ac].pnw02
               NEXT FIELD pnw02
            WHEN INFIELD(pnw03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azp"
               LET g_qryparam.default1 = g_pnw[l_ac].pnw03
               CALL cl_create_qry() RETURNING g_pnw[l_ac].pnw03
               DISPLAY BY NAME g_pnw[l_ac].pnw03
               NEXT FIELD pnw03
            WHEN INFIELD(pnw04)
              #DATABASE l_azp03   #No.MOD-640042  #No.TQC-6C0212 mark
               #-----MOD-950188---------
               ##No.TQC-6C0212  -begin 
               #IF NOT cl_null(l_azp03) THEN
               #   CLOSE DATABASE   #TQC-760088
               #   DATABASE l_azp03
               #END IF
               ##No.TQC-6C0212  --end
          #     CALL cl_ins_del_sid(2) #FUN-980030   #FUN-990069
               CALL cl_ins_del_sid(2,'') #FUN-980030   #FUN-990069
               CLOSE DATABASE  
               DATABASE l_azp03
          #     CALL cl_ins_del_sid(1) #FUN-980030   #FUN-990069
               CALL cl_ins_del_sid(1,g_pnw[l_ac].pnw03) #FUN-980030   #FUN-990069
               #-----END MOD-950188-----
               CALL q_smy(FALSE,FALSE,g_pnw[l_ac].pnw04,"APM","2") #TQC-670008
                RETURNING g_pnw[l_ac].pnw04
               DISPLAY BY NAME g_pnw[l_ac].pnw04
               NEXT FIELD pnw04
          #     CALL cl_ins_del_sid(2) #FUN-980030  #FUN-990069
               CALL cl_ins_del_sid(2,'') #FUN-980030  #FUN-990069
               CLOSE DATABASE   #TQC-760088
               DATABASE g_dbs   #No.MOD-640042
          #     CALL cl_ins_del_sid(1) #FUN-980030   #FUN-990069
               CALL cl_ins_del_sid(1,g_plant) #FUN-980030   #FUN-990069
               CALL i051_lock()   #No.MOD-640042  
               OPEN i051_bcs   #No.MOD-640042
               FETCH ABSOLUTE g_curs_index i051_bcs INTO g_pnw01   #No.MOD-640042
            WHEN INFIELD(pnw05)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_poz1"
               LET g_qryparam.arg1 = "2"
               LET g_qryparam.default1 = g_pnw[l_ac].pnw05
               CALL cl_create_qry() RETURNING g_pnw[l_ac].pnw05
               DISPLAY BY NAME g_pnw[l_ac].pnw05
               NEXT FIELD pnw05
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
   END INPUT
 
   CLOSE i051_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i051_b_fill(p_wc)
   DEFINE p_wc   LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
   LET g_sql = "SELECT pnw02,'',pnw03,'',pnw04,pnw05,pnw06",
               "  FROM pnw_file ",
               " WHERE pnw01 = '",g_pnw01,"'",
               "   AND ",p_wc CLIPPED ,
               " ORDER BY pnw02"
 
   PREPARE i051_prepare2 FROM g_sql
   DECLARE pnw_cs CURSOR FOR i051_prepare2
 
   CALL g_pnw.clear()
   LET g_cnt = 1
   LET g_rec_b=0
 
   FOREACH pnw_cs INTO g_pnw[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT azp02 INTO g_pnw[g_cnt].azp02_1 FROM azp_file
       WHERE azp01 = g_pnw[g_cnt].pnw02
 
      SELECT azp02 INTO g_pnw[g_cnt].azp02_2 FROM azp_file
       WHERE azp01 = g_pnw[g_cnt].pnw03
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_pnw.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i051_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pnw TO s_pnw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
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
         CALL i051_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL i051_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL i051_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL i051_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL i051_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
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
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i051_copy()
   DEFINE l_oldno   LIKE pnw_file.pnw01,
          l_newno   LIKE pnw_file.pnw01
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_pnw01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INPUT l_newno FROM pnw01
 
      AFTER FIELD pnw01
         IF cl_null(l_newno) THEN
            NEXT FIELD pnw01
         ELSE
            IF g_pnw01 != g_pnw01_t OR g_pnw01_t IS NULL THEN
               SELECT geu02 INTO g_geu02 FROM geu_file
                WHERE geu01 = g_pnw01
                  AND geu00 = "4"
               IF STATUS THEN
#                 CALL cl_err(g_pnw01,"anm-027",0)   #No.FUN-660129
                  CALL cl_err3("sel","geu_file",g_pnw01,"","anm-027","","",1)  #No.FUN-660129
                  NEXT FIELD pnw01
               ELSE
                  DISPLAY g_geu02 TO geu02
               END IF
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pnw01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_geu"
               LET g_qryparam.arg1 = "4"
               LET g_qryparam.default1 = l_newno
               CALL cl_create_qry() RETURNING l_newno
               DISPLAY l_newno TO pnw01
               NEXT FIELD pnw01
            OTHERWISE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
     
      ON ACTION help
         CALL cl_show_help()
     
      ON ACTION controlg
         CALL cl_cmdask()
 
   END INPUT
 
   IF INT_FLAG OR l_newno IS NULL THEN
      LET INT_FLAG = 0
      CALL i051_show()
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM pnw_file WHERE pnw01=g_pnw01 INTO TEMP x
 
   UPDATE x SET pnw01=l_newno
 
   INSERT INTO pnw_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_pnw01,SQLCA.sqlcode,0)   #No.FUN-660129
      CALL cl_err3("ins","pnw_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
   ELSE
      MESSAGE 'ROW(',l_newno,') O.K'
      LET l_oldno = g_pnw01
      LET g_pnw01 = l_newno
      CALL i051_b()
      #LET g_pnw01 = l_oldno  #FUN-C80046
      #CALL i051_show()       #FUN-C80046
   END IF
 
END FUNCTION
 
FUNCTION i051_out()
  DEFINE l_name   LIKE type_file.chr20,         #No.FUN-680136 VARCHAR(20)
         sr       RECORD     
                     pnw01    LIKE pnw_file.pnw01,
                     geu02    LIKE geu_file.geu02,
                     pnw02    LIKE pnw_file.pnw02,
                     azp02_1  LIKE azp_file.azp02,
                     pnw03    LIKE pnw_file.pnw03,
                     azp02_2  LIKE azp_file.azp02,
                     pnw04    LIKE pnw_file.pnw04,
                     pnw05    LIKE pnw_file.pnw05,
                     pnw06    LIKE pnw_file.pnw06
                  END RECORD 
#No.FUN-820002--start--
   DEFINE l_cmd           LIKE type_file.chr1000                                                                                       
                                                                                                                                    
   IF cl_null(g_wc) AND NOT cl_null(g_pnw01) THEN                                                                                   
      LET g_wc = " pnw01 = '",g_pnw01,"' "                                                                                          
   END IF                                                                                                                           
   IF g_wc IS NULL THEN                                                                                                             
      CALL cl_err('','9057',0) RETURN                                                                                               
   END IF                                                                                                                           
   LET l_cmd = 'p_query "apmi051" "',g_wc CLIPPED,'"'                                                                               
   CALL cl_cmdrun(l_cmd)                                                                                                            
   RETURN
#  CALL cl_wait()
#  CALL cl_outnam('apmi051') RETURNING l_name
#  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
#  LET g_sql = "SELECT pnw01,'',pnw02,'',pnw03,'',pnw04,pnw05,pnw06",
#              "  FROM pnw_file ",
#              " WHERE ",g_wc CLIPPED
 
#  PREPARE i051_p1 FROM g_sql
#  DECLARE i051_curo CURSOR FOR i051_p1
 
#  START REPORT i051_rep TO l_name
 
#  FOREACH i051_curo INTO sr.*   
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('foreach:',SQLCA.sqlcode,1)   
#        EXIT FOREACH
#     END IF
 
#     SELECT geu02 INTO sr.geu02 FROM geu_file
#      WHERE geu01 = sr.pnw01
 
#     SELECT azp02 INTO sr.azp02_1 FROM azp_file
#      WHERE azp01 = sr.pnw02
 
#     SELECT azp02 INTO sr.azp02_2 FROM azp_file
#      WHERE azp01 = sr.pnw03
 
#     OUTPUT TO REPORT i051_rep(sr.*)
 
#  END FOREACH
 
#  FINISH REPORT i051_rep
 
#  CLOSE i051_curo
#  ERROR ""
 
#  CALL cl_prt(l_name,' ','1',g_len)
 
END FUNCTION
 
#REPORT i051_rep(sr)
#  DEFINE l_trailer_sw   LIKE type_file.chr1,                #No.FUN-680136 VARCHAR(1)
#         sr             RECORD     
#                           pnw01    LIKE pnw_file.pnw01,
#                           geu02    LIKE geu_file.geu02,
#                           pnw02    LIKE pnw_file.pnw02,
#                           azp02_1  LIKE azp_file.azp02,
#                           pnw03    LIKE pnw_file.pnw03,
#                           azp02_2  LIKE azp_file.azp02,
#                           pnw04    LIKE pnw_file.pnw04,
#                           pnw05    LIKE pnw_file.pnw05,
#                           pnw06    LIKE pnw_file.pnw06
#                        END RECORD 
 
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
#  ORDER BY sr.pnw01,sr.pnw02,sr.pnw03
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<',"/pageno" 
#        PRINT g_head CLIPPED,pageno_total     
#        PRINT 
#        PRINT g_dash
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
#              g_x[37],g_x[38],g_x[39]
#        PRINT g_dash1 
#        LET l_trailer_sw = "Y"
 
#     BEFORE GROUP OF sr.pnw01
#        PRINT COLUMN g_c[31],sr.pnw01 CLIPPED,
#              COLUMN g_c[32],sr.geu02 CLIPPED;
 
#     ON EVERY ROW
#        PRINT COLUMN g_c[33],sr.pnw02 CLIPPED,
#              COLUMN g_c[34],sr.azp02_1 CLIPPED,
#              COLUMN g_c[35],sr.pnw03 CLIPPED,
#              COLUMN g_c[36],sr.azp02_2 CLIPPED,
#              COLUMN g_c[37],sr.pnw04 CLIPPED,
#              COLUMN g_c[38],sr.pnw05 CLIPPED,
#              COLUMN g_c[39],sr.pnw06 USING "#####"
 
#     ON LAST ROW
#        PRINT g_dash
#        PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#        LET l_trailer_sw = "N"
 
#     PAGE TRAILER
#        IF l_trailer_sw = "Y" THEN
#           PRINT g_dash
#           PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#        ELSE
#           SKIP 2 LINE
#        END IF
 
# END REPORT
#No.FUN-820002--end
 
