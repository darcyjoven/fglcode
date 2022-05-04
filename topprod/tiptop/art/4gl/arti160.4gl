# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: arti160.4gl
# Descriptions...:  
# Date & Author..: 08/08/29 By destiny 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-870007 09/12/09 By Cockroach PASS NO.
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-D30033 13/04/10 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_rvi           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        rvi01       LIKE rvi_file.rvi01,   
        rvi02       LIKE rvi_file.rvi02,   
        rviacti     LIKE rvi_file.rviacti  
                    END RECORD,
     g_rvi_t         RECORD                #程式變數 (舊值)
        rvi01       LIKE rvi_file.rvi01,   
        rvi02       LIKE rvi_file.rvi02,   
        rviacti       LIKE rvi_file.rviacti
                    END RECORD,
    g_wc2,g_sql     LIKE type_file.chr1000,         
    g_rec_b         LIKE type_file.num5,                #單身筆數     
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL       
DEFINE g_cnt        LIKE type_file.num10    
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose        
DEFINE g_before_input_done   LIKE type_file.num5        
MAIN
 
DEFINE p_row,p_col   LIKE type_file.num5    
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("art")) THEN
      EXIT PROGRAM
   END IF
 
 
    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
       RETURNING g_time    
    LET p_row = 4 LET p_col = 15
    OPEN WINDOW i160_w AT p_row,p_col WITH FORM "art/42f/arti160"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i160_b_fill(g_wc2)
    CALL i160_menu()
    CLOSE WINDOW i160_w                    #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
         RETURNING g_time    
END MAIN
 
FUNCTION i160_menu()
 DEFINE l_cmd   LIKE type_file.chr1000                                   
   WHILE TRUE
      CALL i160_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i160_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i160_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i160_out()                                        
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_rvi[l_ac].rvi01 IS NOT NULL THEN
                  LET g_doc.column1 = "rvi01"
                  LET g_doc.value1 = g_rvi[l_ac].rvi01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvi),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i160_q()
   CALL i160_b_askkey()
END FUNCTION
 
FUNCTION i160_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        
   l_n             LIKE type_file.num5,                #檢查重複用       
   l_n1            LIKE type_file.num5,
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否       
   p_cmd           LIKE type_file.chr1,                #處理狀態        
   l_allow_insert  LIKE type_file.chr1,                #可新增否
   l_allow_delete  LIKE type_file.chr1                 #可刪除否
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT rvi01,rvi02,rviacti",  
                      "  FROM rvi_file WHERE rvi01= ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i160_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_rvi WITHOUT DEFAULTS FROM s_rvi.*
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
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
             LET g_before_input_done = FALSE                                    
             CALL i160_set_entry(p_cmd)                                         
             CALL i160_set_no_entry(p_cmd)                                      
             LET g_before_input_done = TRUE                                             
             LET g_rvi_t.* = g_rvi[l_ac].*  #BACKUP
             OPEN i160_bcl USING g_rvi_t.rvi01
             IF STATUS THEN
                CALL cl_err("OPEN i160_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i160_bcl INTO g_rvi[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_rvi_t.rvi01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                              
          LET g_before_input_done = FALSE                                       
          CALL i160_set_entry(p_cmd)                                            
          CALL i160_set_no_entry(p_cmd)                                         
          LET g_before_input_done = TRUE                                        
          INITIALIZE g_rvi[l_ac].* TO NULL   
          LET g_rvi[l_ac].rviacti = 'Y'       
          LET g_rvi_t.* = g_rvi[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()    
          NEXT FIELD rvi01
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i160_bcl
             CANCEL INSERT
          END IF
          INSERT INTO rvi_file(rvi01,rvi02,rviacti,rvioriu,rviorig)   
          VALUES(g_rvi[l_ac].rvi01,g_rvi[l_ac].rvi02,g_rvi[l_ac].rviacti, g_user, g_grup)        #No.FUN-980030 10/01/04  insert columns oriu, orig
          IF SQLCA.sqlcode THEN   
             CALL cl_err3("ins","rvi_file",g_rvi[l_ac].rvi01,"",SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       AFTER FIELD rvi01                        #check 編號是否重複
          IF NOT cl_null(g_rvi[l_ac].rvi01) THEN 
             IF g_rvi[l_ac].rvi01 != g_rvi_t.rvi01 OR
                g_rvi_t.rvi01 IS NULL THEN
                SELECT count(*) INTO l_n FROM rvi_file
                 WHERE rvi01 = g_rvi[l_ac].rvi01
                IF l_n> 0 THEN
                   CALL cl_err('','-239',0)
                   LET g_rvi[l_ac].rvi01 = g_rvi_t.rvi01
                   NEXT FIELD rvi01
                END IF
              END IF
           END IF
          
       AFTER FIELD rviacti
          IF NOT cl_null(g_rvi[l_ac].rviacti) THEN
             IF g_rvi[l_ac].rviacti NOT MATCHES '[YN]' THEN 
                LET g_rvi[l_ac].rviacti = g_rvi_t.rviacti
                NEXT FIELD rviacti
             END IF
          END IF
 
       		
       BEFORE DELETE                            #是否取消單身
          IF g_rvi_t.rvi01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "rvi01"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_rvi[l_ac].rvi01      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF        
             DELETE FROM rvi_file WHERE rvi01 = g_rvi_t.rvi01 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","rvi_file",g_rvi_t.rvi01,"",SQLCA.sqlcode,"","",1)  
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_rvi[l_ac].* = g_rvi_t.*
             CLOSE i160_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_rvi[l_ac].rvi01,-263,0)
             LET g_rvi[l_ac].* = g_rvi_t.*
          ELSE
             UPDATE rvi_file SET rvi02=g_rvi[l_ac].rvi02,
                                 rviacti=g_rvi[l_ac].rviacti
              WHERE rvi01 = g_rvi_t.rvi01 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","rvi_file",g_rvi_t.rvi01,"",SQLCA.sqlcode,"","",1) 
                LET g_rvi[l_ac].* = g_rvi_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
       #  LET l_ac_t = l_ac                # 新增  #FUN-D30033 mark
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_rvi[l_ac].* = g_rvi_t.*
            #FUN-D30033--add--str--
              ELSE
                 CALL g_rvi.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30033--add--end--
             END IF
             CLOSE i160_bcl            # 新增
             ROLLBACK WORK             # 新增
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac            #FUN-D30033 
 
          CLOSE i160_bcl               # 新增
          COMMIT WORK
           
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(rvi01) AND l_ac > 1 THEN
             LET g_rvi[l_ac].* = g_rvi[l_ac-1].*
             NEXT FIELD rvi01
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
          
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
       
   END INPUT
 
   CLOSE i160_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i160_b_askkey()
 
   CLEAR FORM
   CALL g_rvi.clear()
   LET l_ac =1
   CONSTRUCT g_wc2 ON rvi01,rvi02,rviacti
        FROM s_rvi[1].rvi01,s_rvi[1].rvi02,s_rvi[1].rviacti
 
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
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('rviuser', 'rvigrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      LET g_rec_b =0 
      RETURN
   END IF
 
   CALL i160_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i160_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      
 
    LET g_sql =
        "SELECT rvi01,rvi02,rviacti",   
        " FROM rvi_file ",
        " WHERE ", g_wc2 CLIPPED,        #單身
        " ORDER BY rvi01"
    PREPARE i160_pb FROM g_sql
    DECLARE rvi_curs CURSOR FOR i160_pb
 
    CALL g_rvi.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH rvi_curs INTO g_rvi[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rvi.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i160_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvi TO s_rvi.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
          CALL cl_show_fld_cont()                   
 
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
 
FUNCTION i160_out()
DEFINE l_cmd LIKE type_file.chr1000
 
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
       RETURN
    END IF
    LET l_cmd = 'p_query "arti160" "',g_wc2 CLIPPED,'"'                                                                               
    CALL cl_cmdrun(l_cmd) 
    RETURN
END FUNCTION 
                                                
FUNCTION i160_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                             
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("rvi01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i160_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1
                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("rvi01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION     
#FUN-870007 PASS NO.                                                                  
