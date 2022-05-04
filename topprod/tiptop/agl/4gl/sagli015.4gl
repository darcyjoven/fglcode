# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: sagli015.4gl 
# Descriptions...: 股東權益分類設定作業
# Date & Author..: 11/06/28 By lixiang(FUN-B60144)
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE 
    g_aya           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        aya01       LIKE aya_file.aya01,
        aya02       LIKE aya_file.aya02,
        aya06       LIKE aya_file.aya06,
        aya07       LIKE aya_file.aya07
                    END RECORD,
    g_aya_t         RECORD                 #程式變數 (舊值)
        aya01       LIKE aya_file.aya01,
        aya02       LIKE aya_file.aya02,
        aya06       LIKE aya_file.aya06,
        aya07       LIKE aya_file.aya07
                    END RECORD,
    g_wc2,g_sql    string,
    g_rec_b         LIKE type_file.num5,                #單身筆數
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose
DEFINE g_argv1         LIKE type_file.chr1

FUNCTION i015(p_argv1)
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680102 SMALLINT
   DEFINE p_argv1       LIKE type_file.chr1

    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   LET g_argv1 = p_argv1
   CASE
      WHEN g_argv1 = '1'
         LET g_prog = 'agli015'
      WHEN g_argv1 = '2'
         LET g_prog = 'agli0151'
   END CASE

   LET p_row = 4 LET p_col = 20
   OPEN WINDOW i015_w AT p_row,p_col WITH FORM "agl/42f/agli015"  
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
   CALL cl_set_comp_visible("aya07",FALSE)
 
   LET g_wc2 = '1=1' CALL i015_b_fill(g_wc2)
 
   CALL i015_menu()
   CLOSE WINDOW i015_w                 #結束畫面
END FUNCTION
 
FUNCTION i015_menu()
   DEFINE l_cmd STRING
   WHILE TRUE
      CALL i015_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i015_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i015_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i015_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF g_aya[l_ac].aya01 IS NOT NULL THEN
                  LET g_doc.column1 = "aya01"
                  LET g_doc.value1 = g_aya[l_ac].aya01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                       base.TypeInfo.create(g_aya),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i015_q()
   CALL i015_b_askkey()
END FUNCTION
 
FUNCTION i015_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,                #檢查重複用
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否
    p_cmd           LIKE type_file.chr1,                #處理狀態
    l_allow_insert  LIKE type_file.chr1,                #可新增否
    l_allow_delete  LIKE type_file.chr1,                #可刪除否
    l_cnt           LIKE type_file.num10
DEFINE
    l_aya07     LIKE aya_file.aya07

    IF g_argv1 = '1' THEN
       LET l_aya07 = 'Y'
    ELSE
       LET l_aya07 = 'N'
    END IF
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT aya01,aya02,aya06,aya07",
                       "  FROM aya_file WHERE aya01=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i015_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_aya WITHOUT DEFAULTS FROM s_aya.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,
                     DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
 
    BEFORE ROW
       LET p_cmd=''
       LET l_ac = ARR_CURR()
       LET l_lock_sw = 'N'            #DEFAULT
       LET l_n  = ARR_COUNT()
       IF g_rec_b>=l_ac THEN
          BEGIN WORK
          LET p_cmd='u'
          LET g_aya_t.* = g_aya[l_ac].*  #BACKUP
 
          LET g_before_input_done = FALSE                                      
          CALL i015_set_entry(p_cmd)                                           
          CALL i015_set_no_entry(p_cmd)                                        
          LET g_before_input_done = TRUE                                       
 
          OPEN i015_bcl USING g_aya_t.aya01
          IF STATUS THEN
             CALL cl_err("OPEN i015_bcl:", STATUS, 1)
             LET l_lock_sw = "Y"
          ELSE 
             FETCH i015_bcl INTO g_aya[l_ac].* 
             IF SQLCA.sqlcode THEN
                 CALL cl_err(g_aya_t.aya01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
             END IF
          END IF
          CALL cl_show_fld_cont()     #FUN-550037(smin)
       END IF
 
    BEFORE INSERT
       LET l_n = ARR_COUNT()
       LET p_cmd='a'
       LET g_before_input_done = FALSE                                        
       CALL i015_set_entry(p_cmd)                                             
       CALL i015_set_no_entry(p_cmd)                                          
       LET g_before_input_done = TRUE                                         
       INITIALIZE g_aya[l_ac].* TO NULL
       IF g_argv1 = '1' THEN
          LET g_aya[l_ac].aya07 = 'Y'
       ELSE
          LET g_aya[l_ac].aya07 = 'N'
       END IF
       LET g_aya_t.* = g_aya[l_ac].*         #新輸入資料
       CALL cl_show_fld_cont()     #FUN-550037(smin)
       NEXT FIELD aya01
 
     AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i015_bcl
           CANCEL INSERT
        END IF
  
        BEGIN WORK                    #FUN-680011
 
        INSERT INTO aya_file(aya01,aya02,aya06,aya07)
        VALUES(g_aya[l_ac].aya01,g_aya[l_ac].aya02,g_aya[l_ac].aya06,g_aya[l_ac].aya07)
        IF SQLCA.sqlcode THEN 
           CALL cl_err3("ins","aya_file",g_aya[l_ac].aya01,"",
                         SQLCA.sqlcode,"","",1)
           CANCEL INSERT
        ELSE
           LET g_rec_b=g_rec_b+1             #FUN-B60144
           COMMIT WORK
        END IF
        DISPLAY g_rec_b TO FORMONLY.cn2
 
    AFTER FIELD aya01                        #check 編號是否重複
        IF NOT cl_null(g_aya[l_ac].aya01) THEN
           IF (g_aya[l_ac].aya01 != g_aya_t.aya01 OR g_aya_t.aya01 IS NULL) THEN 
              SELECT count(*) INTO g_cnt FROM aya_file
               WHERE aya01 = g_aya[l_ac].aya01 AND aya07 = l_aya07
              IF g_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_aya[l_ac].aya01 = g_aya_t.aya01
                 NEXT FIELD aya01
              END IF
           END IF
        END IF

    AFTER FIELD aya06
        IF NOT cl_null(g_aya[l_ac].aya06) THEN
           IF (g_aya[l_ac].aya06 != g_aya_t.aya06 OR g_aya_t.aya06 IS NULL) THEN 
              SELECT count(*) INTO g_cnt FROM aya_file
               WHERE aya06 = g_aya[l_ac].aya06 AND aya07 = l_aya07
              IF g_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_aya[l_ac].aya06 = g_aya_t.aya06
                 NEXT FIELD aya06
              END IF
           END IF
        END IF
 
    BEFORE DELETE                            #是否取消單身
        IF g_rec_b>=l_ac THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL         
            LET g_doc.column1 = "aya01"           
            LET g_doc.value1 = g_aya[l_ac].aya01 
            CALL cl_del_doc()                   
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM aya_file WHERE aya01 = g_aya_t.aya01 AND aya06 = g_aya_t.aya06 AND aya07 = l_aya07
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","aya_file",g_aya_t.aya01,"",SQLCA.sqlcode,
                            "","",0)
               EXIT INPUT
            END IF
            LET g_rec_b=g_rec_b-1             #FUN-B60144
            DISPLAY g_rec_b TO FORMONLY.cn2   #FUN-B60144 
         END IF
 
     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           LET g_aya[l_ac].* = g_aya_t.*
           CLOSE i015_bcl
           ROLLBACK WORK
           EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_aya[l_ac].aya01,-263,0)
           LET g_aya[l_ac].* = g_aya_t.*
        ELSE
           UPDATE aya_file 
               SET aya01=g_aya[l_ac].aya01,aya02=g_aya[l_ac].aya02,
                   aya06=g_aya[l_ac].aya06,aya07=g_aya[l_ac].aya07
            WHERE aya01 = g_aya_t.aya01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","aya_file",g_aya[l_ac].aya01,"",
                           SQLCA.sqlcode,"","",1)
              LET g_aya[l_ac].* = g_aya_t.*
           END IF
        END IF
 
     AFTER ROW
        LET l_ac = ARR_CURR()         # 新增
       #LET l_ac_t = l_ac            #FUN-D30032 mark 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_aya[l_ac].* = g_aya_t.*
            #FUN-D30032--add--begin--
            ELSE
               CALL g_aya.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end----
           END IF
           CLOSE i015_bcl            # 新增
           ROLLBACK WORK         # 新增
           EXIT INPUT
        END IF
        LET l_ac_t = l_ac   #FUN-D30032 add 
        CLOSE i015_bcl            # 新增
        COMMIT WORK
 
     ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(aya01) AND l_ac > 1 THEN
             LET g_aya[l_ac].* = g_aya[l_ac-1].*
             NEXT FIELD aya01
         END IF
 
     ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
         CALL cl_cmdask()
 
     ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
          RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
     
     END INPUT
 
 
    CLOSE i015_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i015_b_askkey()
 
   CLEAR FORM
   CALL g_aya.clear()
 
    CONSTRUCT g_wc2 ON aya01,aya02,aya06
         FROM s_aya[1].aya01,s_aya[1].aya02,s_aya[1].aya06
 
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
    CALL i015_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i015_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2            STRING       
DEFINE
    l_aya07     LIKE aya_file.aya07

    IF g_argv1 = '1' THEN
       LET l_aya07 = 'Y'
    ELSE
       LET l_aya07 = 'N'
    END IF 
 
    LET g_sql =
        "SELECT aya01,aya02,aya06,aya07",
        " FROM aya_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " AND aya07 = '",l_aya07,"'",
        " ORDER BY 1"
    PREPARE i015_pb FROM g_sql
    DECLARE aya_curs CURSOR FOR i015_pb
 
    CALL g_aya.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH aya_curs INTO g_aya[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_aya.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i015_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aya TO s_aya.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
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
 
#@    ON ACTION 相關文件  
       ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i015_out()
DEFINE l_cmd  LIKE type_file.chr1000

   IF g_wc2 IS NULL THEN CALL cl_err('','9057',0) RETURN END IF

   IF g_argv1 = '1' THEN
      LET g_wc2 = g_wc2," AND aya07 = 'Y'"
   ELSE
      LET g_wc2 = g_wc2," AND aya07 = 'N'"
   END IF
   
   IF g_argv1 = '1' THEN
      LET l_cmd = 'p_query "agli015" "',g_wc2 CLIPPED,'"'
   ELSE
      LET l_cmd = 'p_query "agli0151" "',g_wc2 CLIPPED,'"'
   END IF
   CALL cl_cmdrun(l_cmd)
   RETURN 

END FUNCTION
 
FUNCTION i015_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("aya01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i015_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("aya01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION
#FUN-B60144--
