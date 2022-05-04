# Prog. Version..: '5.10.05-08.12.18(00000)'     #
# Pattern name...: apsi212.4gl
# Descriptions...: APS 途程製程維護
# Date & Author..: No:FUN-720043 07/03/07 By Mandy
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_aps_ecb           RECORD LIKE aps_ecb.*, #FUN-720043
    g_aps_ecb_t         RECORD LIKE aps_ecb.*, 
    g_aps_route_id      LIKE aps_ecb.route_id,   #途程編號
    g_aps_ecb_rowid     LIKE type_file.chr18, 	 #ROWID  
    g_flag              LIKE type_file.chr1,    
    g_wc,g_sql          string  

DEFINE   g_forupd_sql   STRING                   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE   g_cnt          LIKE type_file.num10   
DEFINE   g_msg          LIKE ze_file.ze03  
DEFINE   g_row_count    LIKE type_file.num10   
DEFINE   g_curs_index   LIKE type_file.num10   
MAIN
    DEFINE l_time       LIKE type_file.chr8   	#計算被使用時間  
    DEFINE p_row,p_col  LIKE type_file.num5    

    OPTIONS					#改變一些系統預設值
        FORM LINE     FIRST + 2,		#畫面開始的位置
        MESSAGE LINE  LAST,			#訊息顯示的位置
        PROMPT LINE   LAST,			#提示訊息的位置
        INPUT NO WRAP				#輸入的方式: 不打轉
						
    DEFER INTERRUPT				#擷取中斷鍵,由程式處理

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("APS")) THEN
       EXIT PROGRAM
    END IF

    CALL cl_used(g_prog,l_time,1) RETURNING l_time  #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818
    INITIALIZE g_aps_ecb.* TO NULL
    INITIALIZE g_aps_ecb_t.* TO NULL

    LET g_forupd_sql = "SELECT * FROM aps_ecb WHERE ROWID = ? FOR UPDATE NOWAIT"
    DECLARE i212_cl CURSOR FROM g_forupd_sql                  # LOCK CURSOR

    LET p_row = 2 LET p_col = 3
    OPEN WINDOW i212_w AT p_row,p_col
      WITH FORM "aps/42f/apsi212"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()

    LET g_aps_ecb.route_id  = ARG_VAL(1)
    LET g_aps_ecb.sequ_num  = ARG_VAL(2)
    LET g_aps_ecb.op_id     = ARG_VAL(3)
    IF NOT cl_null(g_aps_ecb.route_id) AND
       NOT cl_null(g_aps_ecb.sequ_num) AND
       NOT cl_null(g_aps_ecb.op_id) 
       THEN LET g_flag = 'Y'
            CALL i212_q()
       ELSE LET g_flag = 'N'
    END IF

    WHILE TRUE
      LET g_action_choice=""
      CALL i212_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE

    CLOSE WINDOW i212_w
      CALL cl_used(g_prog,l_time,2) RETURNING l_time #No:MOD-580088  HCN 20050818
END MAIN

FUNCTION i212_cs()
    CLEAR FORM
    IF g_flag = 'Y' THEN
       LET g_wc = "     route_id='",g_aps_ecb.route_id,"'",
                  " AND sequ_num='",g_aps_ecb.sequ_num,"'",
                  " AND op_id   ='",g_aps_ecb.op_id,"'"
    ELSE
   INITIALIZE g_aps_ecb.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                        # 螢幕上取條件
                 route_id ,
                 sequ_num ,
                 op_id    ,
                 eqg_id   ,
                 is_batch ,
                 pre_ps_t ,
                 lotpos_t ,
                 eqpos_t  ,
                 trans_qty,
                 base_qty ,
                 max_eqnm ,
                 min_emq  ,
                 altop_p  ,
                 max_bsiz ,
                 min_bsiz  

          BEFORE CONSTRUCT
             CALL cl_qbe_init()
          
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
    END IF
    IF INT_FLAG THEN RETURN END IF
   ##資料權限的檢查
   #IF g_priv2='4' THEN                                 #只能使用自己的資料
   #    LET g_wc = g_wc clipped," AND oeauser = '",g_user,"'"
   #END IF
   #IF g_priv3='4' THEN                                 #只能使用相同群的資料
   #    LET g_wc = g_wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
   #END IF

   #IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #    LET g_wc = g_wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
   #END IF

    LET g_sql = "SELECT ROWID,route_id,sequ_num,op_id FROM aps_ecb ",   # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY route_id,sequ_num,op_id"
    PREPARE i212_prepare FROM g_sql                     # RUNTIME 編譯
    DECLARE i212_cs                                     # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i212_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM aps_ecb WHERE ",g_wc CLIPPED
    PREPARE i212_precount FROM g_sql
    DECLARE i212_count CURSOR FOR i212_precount
END FUNCTION

FUNCTION i212_menu()
    MENU ""

        BEFORE MENU
           CALL cl_navigator_setting( g_curs_index, g_row_count )

        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
                CALL i212_q()
           END IF
        ON ACTION next
           CALL i212_fetch('N')
        ON ACTION previous
           CALL i212_fetch('P')
        ON ACTION modify
           CALL i212_u()
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        COMMAND KEY(CONTROL-G)
            CALL cl_cmdask()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION controlg      
           CALL cl_cmdask()     

        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_aps_ecb.route_id) AND
                  NOT cl_null(g_aps_ecb.sequ_num) AND
                  NOT cl_null(g_aps_ecb.op_id) THEN
                   LET g_doc.column1 = "route_id"
                   LET g_doc.column2 = "sequ_num"
                   LET g_doc.column3 = "op_id"
                   LET g_doc.value1 = g_aps_ecb.route_id
                   LET g_doc.value2 = g_aps_ecb.sequ_num
                   LET g_doc.value3 = g_aps_ecb.op_id
                   CALL cl_doc()
               END IF
           END IF
           LET g_action_choice = "exit"
           CONTINUE MENU

        -- for Windows close event trapped
        COMMAND KEY(INTERRUPT)
            LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
            EXIT MENU

    END MENU
    CLOSE i212_cs
END FUNCTION


FUNCTION i212_a()
    IF s_shut(0) THEN RETURN END IF              #檢查權限
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_aps_ecb.* LIKE aps_ecb.*
    LET g_aps_ecb.route_id  = NULL
    LET g_aps_ecb.sequ_num  = 0
    LET g_aps_ecb.op_id     = NULL
    LET g_aps_ecb.eqg_id    = NULl
    LET g_aps_ecb.is_batch  = 0
    LET g_aps_ecb.pre_ps_t  = 0 
    LET g_aps_ecb.lotpos_t  = 0 
    LET g_aps_ecb.eqpos_t   = 0 
    LET g_aps_ecb.trans_qty = 0
    LET g_aps_ecb.base_qty  = 1
    LET g_aps_ecb.max_eqnm  = 0 
    LET g_aps_ecb.min_emq   = 0
    LET g_aps_ecb.altop_p   = 0
    LET g_aps_ecb.max_bsiz  = 9999
    LET g_aps_ecb.min_bsiz  = 1

    LET g_aps_ecb_t.*=g_aps_ecb.*
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i212_i("a")                         #各欄位輸入
        IF INT_FLAG THEN                         #若按了DEL鍵
            INITIALIZE g_aps_ecb.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF cl_null(g_aps_ecb.route_id) AND  # KEY 不可空白
           cl_null(g_aps_ecb.sequ_num) AND
           cl_null(g_aps_ecb.op_id) THEN
            CONTINUE WHILE
        END IF
        INSERT INTO aps_ecb VALUES(g_aps_ecb.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","aps_ecb",g_aps_ecb.route_id,"",SQLCA.sqlcode,"","",1) # FUN-660095
            CONTINUE WHILE
        ELSE
            LET g_aps_ecb_t.* = g_aps_ecb.*                # 保存上筆資料
            SELECT ROWID INTO g_aps_ecb_rowid FROM aps_ecb
                WHERE route_id = g_aps_ecb.route_id
                  AND sequ_num = g_aps_ecb.sequ_num
                  AND op_id    = g_aps_ecb.op_id
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i212_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
        l_flag          LIKE type_file.chr1,  		 #是否必要欄位有輸入  #No.FUN-690010 VARCHAR(1)
        l_n             LIKE type_file.num5    #No.FUN-690010 SMALLINT

    DISPLAY BY NAME 
        g_aps_ecb.route_id  ,
        g_aps_ecb.sequ_num  ,
        g_aps_ecb.op_id     ,
        g_aps_ecb.eqg_id    ,
        g_aps_ecb.is_batch  ,
        g_aps_ecb.pre_ps_t  ,
        g_aps_ecb.lotpos_t  ,
        g_aps_ecb.eqpos_t   ,
        g_aps_ecb.trans_qty ,
        g_aps_ecb.base_qty  ,
        g_aps_ecb.max_eqnm  ,
        g_aps_ecb.min_emq   ,
        g_aps_ecb.altop_p   ,
        g_aps_ecb.max_bsiz  ,
        g_aps_ecb.min_bsiz  
    INPUT BY NAME   
        g_aps_ecb.route_id  ,
        g_aps_ecb.sequ_num  ,
        g_aps_ecb.op_id     ,
        g_aps_ecb.eqg_id    ,
        g_aps_ecb.is_batch  ,
        g_aps_ecb.pre_ps_t  ,
        g_aps_ecb.lotpos_t  ,
        g_aps_ecb.eqpos_t   ,
        g_aps_ecb.trans_qty ,
        g_aps_ecb.base_qty  ,
        g_aps_ecb.max_eqnm  ,
        g_aps_ecb.min_emq   ,
        g_aps_ecb.altop_p   ,
        g_aps_ecb.max_bsiz  ,
        g_aps_ecb.min_bsiz  
        WITHOUT DEFAULTS

        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET l_flag='N'
           IF INT_FLAG THEN EXIT INPUT  END IF
           IF l_flag='Y' THEN
              CALL cl_err('','9033',0)
              NEXT FIELD route_id
           END IF

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  
    END INPUT
END FUNCTION
 
FUNCTION i212_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i212_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        INITIALIZE g_aps_ecb.* TO NULL
        RETURN
    END IF
    OPEN i212_count
    FETCH i212_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i212_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aps_ecb.route_id,SQLCA.sqlcode,0)
        INITIALIZE g_aps_ecb.* TO NULL
    ELSE
        CALL i212_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION i212_fetch(p_flag)
    DEFINE
        p_flag          LIKE type_file.chr1,  
        l_abso          LIKE type_file.num10   

    CASE p_flag
        WHEN 'N' FETCH NEXT     i212_cs INTO g_aps_ecb_rowid,g_aps_ecb.route_id,g_aps_ecb.sequ_num,g_aps_ecb.op_id
        WHEN 'P' FETCH PREVIOUS i212_cs INTO g_aps_ecb_rowid,g_aps_ecb.route_id,g_aps_ecb.sequ_num,g_aps_ecb.op_id
        WHEN 'F' FETCH FIRST    i212_cs INTO g_aps_ecb_rowid,g_aps_ecb.route_id,g_aps_ecb.sequ_num,g_aps_ecb.op_id
        WHEN 'L' FETCH LAST     i212_cs INTO g_aps_ecb_rowid,g_aps_ecb.route_id,g_aps_ecb.sequ_num,g_aps_ecb.op_id
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
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
            FETCH ABSOLUTE l_abso i212_cs INTO g_aps_ecb_rowid,g_aps_ecb.route_id,g_aps_ecb.sequ_num,g_aps_ecb.op_id
    END CASE

    IF SQLCA.sqlcode THEN
        LET g_msg = g_aps_ecb.route_id CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_aps_ecb.* TO NULL          
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

    SELECT * INTO g_aps_ecb.* FROM aps_ecb            # 重讀DB,因TEMP有不被更新特性
       WHERE ROWID = g_aps_ecb_rowid
    IF SQLCA.sqlcode THEN
        LET g_msg = g_aps_ecb.route_id CLIPPED
         CALL cl_err3("sel","aps_ecb",g_aps_ecb.route_id,"",SQLCA.sqlcode,"","",1) # FUN-660095
         INITIALIZE g_aps_ecb.* TO NULL       #No.FUN-6A0163
    ELSE
        CALL i212_show()                      # 重新顯示
    END IF
END FUNCTION

FUNCTION i212_show()
    LET g_aps_ecb_t.* = g_aps_ecb.*
    DISPLAY BY NAME 
        g_aps_ecb.route_id  ,
        g_aps_ecb.sequ_num  ,
        g_aps_ecb.op_id     ,
        g_aps_ecb.eqg_id    ,
        g_aps_ecb.is_batch  ,
        g_aps_ecb.pre_ps_t  ,
        g_aps_ecb.lotpos_t  ,
        g_aps_ecb.eqpos_t   ,
        g_aps_ecb.trans_qty ,
        g_aps_ecb.base_qty  ,
        g_aps_ecb.max_eqnm  ,
        g_aps_ecb.min_emq   ,
        g_aps_ecb.altop_p   ,
        g_aps_ecb.max_bsiz  ,
        g_aps_ecb.min_bsiz  
    CALL cl_show_fld_cont()                   
END FUNCTION

FUNCTION i212_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_aps_ecb.route_id IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_aps_route_id = g_aps_ecb.route_id
    BEGIN WORK

    OPEN i212_cl USING g_aps_ecb_rowid
    IF STATUS THEN
       CALL cl_err("OPEN i212_cl:", STATUS, 1)
       CLOSE i212_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i212_cl INTO g_aps_ecb.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aps_ecb.route_id,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i212_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i212_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_aps_ecb.* = g_aps_ecb_t.*
            CALL i212_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE aps_ecb SET aps_ecb.* = g_aps_ecb.*    # 更新DB
            WHERE ROWID = g_aps_ecb_rowid               # COLAUTH?
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
            LET g_msg = g_aps_ecb.route_id CLIPPED
            CALL cl_err3("upd","aps_ecb",g_aps_route_id,"",SQLCA.sqlcode,"","",1) # FUN-660095
            CONTINUE WHILE
        ELSE
            LET g_aps_ecb_t.* = g_aps_ecb.*# 保存上筆資料
            SELECT ROWID INTO g_aps_ecb_rowid FROM aps_ecb
             WHERE route_id = g_aps_ecb.route_id
               AND sequ_num = g_aps_ecb.sequ_num
               AND op_id    = g_aps_ecb.op_id
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i212_cl
    COMMIT WORK
END FUNCTION

FUNCTION i212_r()
    DEFINE
        l_chr LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)

    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_aps_ecb.route_id IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK

    OPEN i212_cl USING g_aps_ecb_rowid
    IF STATUS THEN
       CALL cl_err("OPEN i212_cl:", STATUS, 1)
       CLOSE i212_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i212_cl INTO g_aps_ecb.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aps_ecb.route_id,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i212_show()
    IF cl_delete() THEN
            DELETE FROM aps_ecb WHERE ROWID = g_aps_ecb_rowid
            CLEAR FORM
    END IF
    CLOSE i212_cl
    INITIALIZE g_aps_ecb.* TO NULL
    COMMIT WORK
END FUNCTION
