# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: almi190.4gl
# Descriptions...: 經營小類維護作業 
# Date & Author..: NO.FUN-960058 09/06/12 By  destiny  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-D30033 13/04/12 By minpp 單身新增時按下放棄鍵未執行AFTER INSERT的問題 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-960058--begin 
DEFINE 
     g_lmk           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        lmk01       LIKE lmk_file.lmk01,   #
        lmk02       LIKE lmk_file.lmk02,   #
        lmk03       LIKE lmk_file.lmk03,   #
        lmj02       LIKE lmj_file.lmj02,
        lmk04       LIKE lmk_file.lmk04,
        lmi02       LIKE lmi_file.lmi02, 
        lmk05       LIKE lmk_file.lmk05   
                    END RECORD,
     g_lmk_t         RECORD                #程式變數 (舊值)
        lmk01       LIKE lmk_file.lmk01,   #
        lmk02       LIKE lmk_file.lmk02,   #
        lmk03       LIKE lmk_file.lmk03,   #
        lmj02       LIKE lmj_file.lmj02,
        lmk04       LIKE lmk_file.lmk04,
        lmi02       LIKE lmi_file.lmi02, 
        lmk05       LIKE lmk_file.lmk05 
                    END RECORD,
    g_wc2,g_sql     LIKE type_file.chr1000,         
    g_rec_b         LIKE type_file.num5,                #單身筆數     
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL       
DEFINE g_cnt        LIKE type_file.num10    
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose        
DEFINE g_before_input_done   LIKE type_file.num5        
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time    
 
    OPEN WINDOW i190_w WITH FORM "alm/42f/almi190"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i190_b_fill(g_wc2)
    CALL i190_menu()
    CLOSE WINDOW i190_w                    #結束畫面
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION i190_menu()
 DEFINE l_cmd   LIKE type_file.chr1000                                   
   WHILE TRUE
      CALL i190_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i190_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i190_b()
            ELSE
               LET g_action_choice = NULL
            END IF
#         WHEN "output"
#            IF cl_chk_act_auth() THEN
#               CALL i190_out()                                        
#            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_lmk[l_ac].lmk01 IS NOT NULL THEN
                  LET g_doc.column1 = "lmk01"
                  LET g_doc.value1 = g_lmk[l_ac].lmk01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lmk),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i190_q()
   CALL i190_b_askkey()
END FUNCTION
 
FUNCTION i190_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        
   l_n             LIKE type_file.num5,                #檢查重複用       
   l_n1            LIKE type_file.num5,
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否       
   p_cmd           LIKE type_file.chr1,                #處理狀態        
   l_allow_insert  LIKE type_file.chr1,                #可新增否
   l_allow_delete  LIKE type_file.chr1,                #可刪除否
   l_lmi03         LIKE lmi_file.lmi03,
   l_lmj01         LIKE lmj_file.lmj01,
   l_lmj04         LIKE lmj_file.lmj04
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT lmk01,lmk02,lmk03,'',lmk04,'',lmk05",  
                      "  FROM lmk_file WHERE lmk01= ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i190_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_lmk WITHOUT DEFAULTS FROM s_lmk.*
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
             CALL i190_set_entry(p_cmd)                                         
             CALL i190_set_no_entry(p_cmd)                                      
             LET g_before_input_done = TRUE                                             
             LET g_lmk_t.* = g_lmk[l_ac].*  #BACKUP
             OPEN i190_bcl USING g_lmk_t.lmk01
             IF STATUS THEN
                CALL cl_err("OPEN i190_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i190_bcl INTO g_lmk[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lmk_t.lmk01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                ELSE
                   CALL i190_lmj02('d',l_ac)
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                              
          LET g_before_input_done = FALSE                                       
          CALL i190_set_entry(p_cmd)                                            
          CALL i190_set_no_entry(p_cmd)                                         
          LET g_before_input_done = TRUE                                        
          INITIALIZE g_lmk[l_ac].* TO NULL   
          LET g_lmk[l_ac].lmk05 = 'Y'       
          LET g_lmk_t.* = g_lmk[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()    
          NEXT FIELD lmk01
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i190_bcl
             CANCEL INSERT
          END IF
          INSERT INTO lmk_file(lmk01,lmk02,lmk03,lmk04,lmk05)   
          VALUES(g_lmk[l_ac].lmk01,g_lmk[l_ac].lmk02,g_lmk[l_ac].lmk03,g_lmk[l_ac].lmk04,g_lmk[l_ac].lmk05)  
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lmk_file",g_lmk[l_ac].lmk01,"",SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       AFTER FIELD lmk01                        #check 編號是否重複
          IF NOT cl_null(g_lmk[l_ac].lmk01) THEN
             IF g_lmk[l_ac].lmk01 != g_lmk_t.lmk01 OR
                g_lmk_t.lmk01 IS NULL THEN
                SELECT count(*) INTO l_n FROM lmk_file
                 WHERE lmk01 = g_lmk[l_ac].lmk01
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_lmk[l_ac].lmk01 = g_lmk_t.lmk01
                   NEXT FIELD lmk01
                END IF
             END IF
          END IF  
 
       AFTER FIELD lmk03
          IF NOT cl_null(g_lmk[l_ac].lmk03) THEN
             IF g_lmk[l_ac].lmk03 != g_lmk_t.lmk03 OR
                g_lmk_t.lmk03 IS NULL THEN
                CALL i190_lmj02('d',l_ac)
                SELECT count(*) INTO l_n FROM lmj_file
                 WHERE lmj01 = g_lmk[l_ac].lmk03
                SELECT lmj04 INTO l_lmj04 FROM lmj_file                                                                             
                 WHERE lmj01 = g_lmk[l_ac].lmk03       
                IF l_n = 0 THEN
                   CALL cl_err('','alm-009',0)
                   LET g_lmk[l_ac].lmk03 = g_lmk_t.lmk03
                   NEXT FIELD lmk03
                ELSE
                  IF l_lmj04='N' THEN 
                     CALL cl_err('','alm-004',0)
                     LET g_lmk[l_ac].lmk03 = g_lmk_t.lmk03
                     NEXT FIELD lmk03
                  END IF
                END IF
             END IF
          ELSE 
             LET g_lmk[l_ac].lmi02=''
             DISPLAY BY NAME g_lmk[l_ac].lmi02 
             LET g_lmk[l_ac].lmj02=''
             DISPLAY BY NAME g_lmk[l_ac].lmj02 
             LET g_lmk[l_ac].lmk04=''
             DISPLAY BY NAME g_lmk[l_ac].lmk04 
          END IF   
          
       AFTER FIELD lmk05
          IF NOT cl_null(g_lmk[l_ac].lmk05) THEN
             IF g_lmk[l_ac].lmk05 NOT MATCHES '[YN]' THEN 
                LET g_lmk[l_ac].lmk05 = g_lmk_t.lmk05
                NEXT FIELD lmk05
             END IF
          END IF
          IF NOT cl_null(g_lmk[l_ac].lmk05) THEN                                                                                    
             IF g_lmk[l_ac].lmk05 != g_lmk_t.lmk05 THEN                                                                             
                SELECT count(*) INTO l_n1 FROM lml_file                                                                             
                  WHERE lml02= g_lmk[l_ac].lmk01
                                                                                  
                IF l_n1 > 0 THEN                                                                                                    
                   CALL cl_err('','alm-036',1)                                                                                      
                   LET g_lmk[l_ac].lmk05 = g_lmk_t.lmk05                                                                            
                   NEXT FIELD lmk04                                                                                                 
                END IF                                                                                                              
              END IF                                                                                                                
          END IF  
                      		
       BEFORE DELETE                            #是否取消單身
          IF g_lmk_t.lmk01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "lmk01"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_lmk[l_ac].lmk01      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             SELECT COUNT(*) INTO l_n FROM lml_file 
               WHERE lml02=g_lmk_t.lmk01
 
             IF l_n >0 THEN 
                CALL cl_err('','alm-035',1)
                CANCEL DELETE
             END IF 
             DELETE FROM lmk_file WHERE lmk01 = g_lmk_t.lmk01 
 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lmk_file",g_lmk_t.lmk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
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
             LET g_lmk[l_ac].* = g_lmk_t.*
             CLOSE i190_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lmk[l_ac].lmk01,-263,0)
             LET g_lmk[l_ac].* = g_lmk_t.*
          ELSE
             UPDATE lmk_file SET lmk02=g_lmk[l_ac].lmk02,
                                 lmk03=g_lmk[l_ac].lmk03,
                                 lmk04=g_lmk[l_ac].lmk04,
                                 lmk05=g_lmk[l_ac].lmk05
              WHERE lmk01 = g_lmk_t.lmk01 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lmk_file",g_lmk_t.lmk01,"",SQLCA.sqlcode,"","",1) 
                LET g_lmk[l_ac].* = g_lmk_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
         #LET l_ac_t = l_ac                # 新增   #FUN-D30033
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_lmk[l_ac].* = g_lmk_t.*
             #FUN-D30033----add--str
            ELSE
               CALL g_lmk.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30033---add--end
             END IF
             CLOSE i190_bcl            # 新增
             ROLLBACK WORK             # 新增
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac            # 新增   #FUN-D30033 
          CLOSE i190_bcl               # 新增
          COMMIT WORK
          
       ON ACTION CONTROLP
           CASE          
              WHEN INFIELD(lmk03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lmj"
                 LET g_qryparam.default1 = g_lmk[l_ac].lmk03
                 CALL cl_create_qry() RETURNING g_lmk[l_ac].lmk03
                 DISPLAY BY NAME g_lmk[l_ac].lmk03
                 CALL i190_lmj02('d',l_ac)
           END CASE
           
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(lmk01) AND l_ac > 1 THEN
             LET g_lmk[l_ac].* = g_lmk[l_ac-1].*
             NEXT FIELD lmk01
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
 
   CLOSE i190_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i190_b_askkey()
 
   CLEAR FORM
   CALL g_lmk.clear()
   LET l_ac =1
   CONSTRUCT g_wc2 ON lmk01,lmk02,lmk03,lmk04,lmk05
        FROM s_lmk[1].lmk01,s_lmk[1].lmk02,s_lmk[1].lmk03,
             s_lmk[1].lmk04,s_lmk[1].lmk05
 
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
         
      ON ACTION CONTROLP
          CASE
            WHEN INFIELD(lmk01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lmk01"
                 LET g_qryparam.state='c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lmk01
                 NEXT FIELD lmk01
                 
            WHEN INFIELD(lmk03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lmk03"
                 LET g_qryparam.state='c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lmk03
                 NEXT FIELD lmk03
                 
            WHEN INFIELD(lmk04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lmk04"
                 LET g_qryparam.state='c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lmk04
                 NEXT FIELD lmk04 
          END CASE
   
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      LET g_rec_b =0 
      RETURN
   END IF
 
   CALL i190_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i190_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      
 
    LET g_sql =
        "SELECT lmk01,lmk02,lmk03,'',lmk04,'',lmk05",   
        " FROM lmk_file ",
        " WHERE ", g_wc2 CLIPPED,        #單身
        " ORDER BY lmk01"
    PREPARE i190_pb FROM g_sql
    DECLARE lmk_curs CURSOR FOR i190_pb
 
    CALL g_lmk.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lmk_curs INTO g_lmk[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT lmj02,lmj03 INTO g_lmk[g_cnt].lmj02,g_lmk[g_cnt].lmk04 FROM lmj_file
           WHERE lmj01 =g_lmk[g_cnt].lmk03 
        SELECT lmi02 INTO g_lmk[g_cnt].lmi02 FROM lmi_file
           WHERE lmi01 =g_lmk[g_cnt].lmk04 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lmk.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i190_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lmk TO s_lmk.* ATTRIBUTE(COUNT=g_rec_b)
 
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
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
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
 
FUNCTION i190_out()
DEFINE l_cmd LIKE type_file.chr1000
 
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
       RETURN
    END IF
    LET l_cmd = 'p_query "almk190" "',g_wc2 CLIPPED,'"'                                                                               
    CALL cl_cmdrun(l_cmd) 
    RETURN
END FUNCTION 
 
FUNCTION i190_lmj02(p_cmd,l_cnt)
    DEFINE   p_cmd     LIKE type_file.chr1                                                                                          
    DEFINE   l_cnt     LIKE type_file.num10 
    DEFINE   l_lmj02   LIKE lmj_file.lmj02 
    DEFINE   l_lmj03   LIKE lmj_file.lmj03
    DEFINE   l_lmi02   LIKE lmi_file.lmi02
    DEFINE   l_lmj04   LIKE lmj_file.lmj04
 
 
    LET g_errno = " "    
    SELECT lmj02,lmj03,lmj04 INTO l_lmj02,l_lmj03,l_lmj04 FROM lmj_file 
      WHERE lmj01=g_lmk[l_ac].lmk03 
      
    CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='alm-009'
                                LET l_lmj02=NULL
                                LET l_lmj03=NULL
       WHEN l_lmj04='N'         LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
    END CASE
    
    SELECT lmi02 INTO l_lmi02 FROM lmi_file 
       WHERE lmi01=l_lmj03
 
    IF cl_null(g_errno) OR p_cmd ='d' THEN 
       LET g_lmk[l_cnt].lmi02=l_lmi02
       DISPLAY g_lmk[l_cnt].lmi02 TO lmi02
       LET g_lmk[l_cnt].lmj02=l_lmj02
       DISPLAY g_lmk[l_cnt].lmj02 TO lmj02
       LET g_lmk[l_cnt].lmk04=l_lmj03
       DISPLAY g_lmk[l_cnt].lmk04 TO lmk04
    END IF
           
END FUNCTION 
 
                                                
FUNCTION i190_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                             
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("lmk01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i190_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                                                
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("lmk01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION 
