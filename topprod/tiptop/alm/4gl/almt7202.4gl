# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: almt7202.4gl
# Descriptions...: 維護折扣規則維護作業
# Date & Author..: NO.FUN-870010 08/09/01 By lilingyu 
# Modify.........: No.FUN-960134 09/07/20 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-D30033 13/04/10 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_lqi           DYNAMIC ARRAY OF RECORD    
         lqi03       LIKE lqi_file.lqi03,
         lqi04       LIKE lqi_file.lqi04,
         lqi05       LIKE lqi_file.lqi05,
         lqi06       LIKE lqi_file.lqi06
                    END RECORD,
     g_lqi_t        RECORD    
         lqi03       LIKE lqi_file.lqi03,
         lqi04       LIKE lqi_file.lqi04,
         lqi05       LIKE lqi_file.lqi05,
         lqi06       LIKE lqi_file.lqi06
                    END RECORD,               
   
    g_wc2,g_sql              LIKE type_file.chr1000,    
    g_rec_b                  LIKE type_file.num5,       
    l_ac                     LIKE type_file.num5        
 
DEFINE g_forupd_sql          STRING         
DEFINE   g_cnt               LIKE type_file.num10           
DEFINE   g_i                 LIKE type_file.num5     
DEFINE g_before_input_done   LIKE type_file.num5 
    
DEFINE g_argv1               LIKE lqi_file.lqi01
DEFINE g_argv2               LIKE lqi_file.lqi02
DEFINE g_argv3               LIKE lqg_file.lqg12
 
MAIN
    OPTIONS                              
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
    DEFER INTERRUPT                       
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
   
    OPEN WINDOW t7202_w WITH FORM "alm/42f/almt7202" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()     
   
    LET g_argv1 = ARG_VAL(1) 
    LET g_argv2 = ARG_VAL(2) 
    LET g_argv3 = ARG_VAL(3)
 
    IF NOT cl_null(g_argv1) THEN
       LET g_wc2 = " lqi01 = '",g_argv1,"'  and lqi02 = '",g_argv2,"'"     
    ELSE
    	 LET g_wc2 = " 1=1"
    END IF  
     
    CALL t7202_b_fill(g_wc2)
    
    CALL t7202_menu()
    CLOSE WINDOW t7202_w    
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION t7202_menu()
 DEFINE l_cmd   LIKE type_file.chr1000            
 
   WHILE TRUE
      CALL t7202_bp("G")
      CASE g_action_choice
      
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL t7202_q()
            END IF
            
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t7202_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         
         WHEN "help"
            CALL cl_show_help()
            
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"
            CALL cl_cmdask()
            
          WHEN "related_document" 
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_lqi[l_ac].lqi03 IS NOT NULL THEN
                  LET g_doc.column1 = "lqi03"
                  LET g_doc.value1 = g_lqi[l_ac].lqi03
                  CALL cl_doc()
               END IF
            END IF
            
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lqi),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t7202_q()
   CALL t7202_askkey()
END FUNCTION
 
FUNCTION t7202_b()
DEFINE
       l_ac_t          LIKE type_file.num5,           
       l_n             LIKE type_file.num5, 
       l_lock_sw       LIKE type_file.chr1,          
       p_cmd           LIKE type_file.chr1,         
       l_allow_insert  LIKE type_file.chr1,         
       l_allow_delete  LIKE type_file.chr1           
DEFINE l_lqg07         LIKE lqg_file.lqg07
DEFINE l_lqgacti       LIKE lqg_file.lqgacti
DEFINE l_lqi03         LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   
    SELECT lqg07,lqgacti INTO l_lqg07,l_lqgacti FROM lqg_file
     WHERE lqg01 = g_argv1
       AND lqg02 = g_argv2
   IF (l_lqg07 = 'Y' OR l_lqg07 = 'X' OR l_lqg07 = 'S') THEN 
      CALL cl_err('','alm-256',1)
      LET g_action_choice = NULL
      RETURN       
   END IF   
   IF l_lqgacti = 'N' THEN       
      CALL cl_err('','alm-150',0)
      LET g_action_choice = NULL
      RETURN        
   END IF 
    
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT lqi03,lqi04,lqi05,lqi06", 
                      "  FROM lqi_file WHERE  " ,
                      "   lqi01= '",g_argv1,"' " ,
                      "   and lqi02 = '",g_argv2,"'",
                      "   and lqi03 = ? " ,
                      "   FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t7202_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_lqi WITHOUT DEFAULTS FROM s_lqi.*
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'           
          LET l_n  = ARR_COUNT()
           
          IF g_rec_b>=l_ac THEN 
             BEGIN WORK
             LET p_cmd='u'
             LET g_before_input_done = FALSE                                    
             CALL t7202_set_entry(p_cmd)                                         
             CALL t7202_set_no_entry(p_cmd) 
             LET g_before_input_done = TRUE   
             LET g_lqi_t.* = g_lqi[l_ac].*  
             OPEN t7202_bcl USING g_lqi_t.lqi03
             IF STATUS THEN
                CALL cl_err("OPEN t7202_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t7202_bcl INTO g_lqi[l_ac].*              
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lqi_t.lqi03,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                                       
          LET g_before_input_done = FALSE                                       
          CALL t7202_set_entry(p_cmd)                                            
          CALL t7202_set_no_entry(p_cmd) 
          LET g_before_input_done = TRUE                                     
          INITIALIZE g_lqi[l_ac].* TO NULL    
          LET g_lqi_t.* = g_lqi[l_ac].*        
          CALL cl_show_fld_cont()    
          NEXT FIELD lqi03
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE t7202_bcl
             CANCEL INSERT
          END IF
          INSERT INTO lqi_file(lqi01,lqi02,lqi03,lqi04,lqi05,lqi06)
          VALUES(g_argv1,g_argv2,g_lqi[l_ac].lqi03,g_lqi[l_ac].lqi04,
                 g_lqi[l_ac].lqi05,g_lqi[l_ac].lqi06)
       
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lqi_file",g_lqi[l_ac].lqi03,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cnt  
             COMMIT WORK
          END IF
 
       BEFORE FIELD lqi03 
        IF cl_null(g_lqi[l_ac].lqi03) OR cl_null(g_lqi_t.lqi03) THEN     
           SELECT max(lqi03)+1 INTO l_lqi03 FROM lqi_file      
            WHERE lqi01= g_argv1   
            LET g_lqi[l_ac].lqi03 = l_lqi03
           IF cl_null(g_lqi[l_ac].lqi03) OR g_lqi[l_ac].lqi03 <= 0 THEN 
              LET g_lqi[l_ac].lqi03 = 1 
           END IF      
        END IF   
        
        AFTER FIELD lqi03         
           IF NOT cl_null(g_lqi[l_ac].lqi03) THEN
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lqi[l_ac].lqi03 != g_lqi_t.lqi03) THEN
                 LET l_n = 0 
                 SELECT COUNT(*) INTO l_n FROM lqi_file
                  WHERE lqi03=g_lqi[l_ac].lqi03 
                    AND lqi01=g_argv1 
                  IF l_n>0 THEN 
                     CALL cl_err('','-239',1)
                     LET g_lqi[l_ac].lqi03=g_lqi_t.lqi03
                    NEXT FIELD lqi03
                  END IF 
              END IF   
           END IF                  
  
      AFTER FIELD lqi04
          IF NOT cl_null(g_lqi[l_ac].lqi04) THEN
             IF g_lqi[l_ac].lqi04 < 0 THEN 
                CALL cl_err('','alm-258',1)
                NEXT FIELD lqi04 
             END IF 
             IF g_lqi[l_ac].lqi04 > g_lqi[l_ac].lqi05 THEN 
                CALL cl_err('','alm-259',1)
                NEXT FIELD lqi04 
             END IF 
          END IF
             LET l_n = 0 
             SELECT COUNT(*) INTO l_n FROM lqi_file
              WHERE lqi01 = g_argv1
                AND lqi02 = g_argv2
                AND lqi03 != g_lqi[l_ac].lqi03
                AND ((g_lqi[l_ac].lqi04 >= lqi04 AND g_lqi[l_ac].lqi04 <= lqi05)
                    OR (g_lqi[l_ac].lqi04 <= lqi04 AND g_lqi[l_ac].lqi05 >= lqi05)
                    OR (g_lqi[l_ac].lqi04 <= lqi04 AND g_lqi[l_ac].lqi05 >= lqi04))
               IF l_n > 0 THEN
                  CALL cl_err('','alm-401',1)
                  NEXT FIELD lqi04 
               ELSE
               	  IF g_argv3 = '2' OR g_argv3 = '3' THEN 
               	     IF g_lqi[l_ac].lqi04 != g_lqi[l_ac].lqi05 THEN 
               	        CALL cl_err('','alm-443',1)
               	        NEXT FIELD lqi04 
               	     END IF 
               	  END IF    
               END IF   
            
              
        AFTER FIELD lqi05
          IF NOT cl_null(g_lqi[l_ac].lqi05) THEN
             IF g_lqi[l_ac].lqi05 < 0 THEN 
                CALL cl_err('','alm-258',1)
                NEXT FIELD lqi05 
             END IF 
             IF g_lqi[l_ac].lqi05 < g_lqi[l_ac].lqi04 THEN 
                CALL cl_err('','alm-400',1)
                NEXT FIELD lqi05 
             END IF 
          END IF      
             LET l_n = 0 
             SELECT COUNT(*) INTO l_n FROM lqi_file
              WHERE lqi01 = g_argv1
                AND lqi02 = g_argv2
                AND lqi03 != g_lqi[l_ac].lqi03
                AND ((g_lqi[l_ac].lqi05 >= lqi04 AND g_lqi[l_ac].lqi05 <=  lqi05)
                     OR (g_lqi[l_ac].lqi04 <= lqi04 AND g_lqi[l_ac].lqi05 >= lqi05)
                     OR (g_lqi[l_ac].lqi04 <= lqi04 AND g_lqi[l_ac].lqi05 >= lqi04))
              IF l_n > 0 THEN
                 CALL cl_err('','alm-401',1)
                 NEXT FIELD lqi05 
              ELSE
              	 IF g_argv3 = '2' OR g_argv3 = '3' THEN 
               	     IF g_lqi[l_ac].lqi04 != g_lqi[l_ac].lqi05 THEN 
               	        CALL cl_err('','alm-443',1)
               	        NEXT FIELD lqi05
               	     END IF 
               	  END IF      
              END IF   
     
     AFTER FIELD lqi06
       IF NOT cl_null(g_lqi[l_ac].lqi06) THEN 
          IF g_argv3 != '3' THEN 
            IF g_lqi[l_ac].lqi06 <= 0 THEN 
               CALL cl_err('','alm-507',1)
               NEXT FIELD lqi06
            END IF 
            IF g_lqi[l_ac].lqi06 >= 100 THEN 
             CALL cl_err('','alm-507',1)
             NEXT FIELD lqi06
           END IF        
          ELSE
          	 IF g_lqi[l_ac].lqi06 < 0 THEN 
          	    CALL cl_err('','alm-440',1)
          	    NEXT FIELD lqi06
          	 END IF 
          END IF  	  
       END IF 
     
       BEFORE DELETE                           
          IF g_lqi_t.lqi03 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "lqi03"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_lqi[l_ac].lqi03      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM lqi_file WHERE lqi01      = g_argv1
                                    AND lqi02      = g_argv2
                                    AND lqi03      = g_lqi_t.lqi03
                                                                                                         
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lqi_file",g_lqi_t.lqi03,"",SQLCA.sqlcode,"","",1)  
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cnt
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_lqi[l_ac].* = g_lqi_t.*
             CLOSE t7202_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lqi[l_ac].lqi03,-263,0)
             LET g_lqi[l_ac].* = g_lqi_t.*
          ELSE
             UPDATE lqi_file SET lqi04 = g_lqi[l_ac].lqi04,
                                 lqi05 = g_lqi[l_ac].lqi05,
                                 lqi06 = g_lqi[l_ac].lqi06
              WHERE lqi03 = g_lqi_t.lqi03
                AND lqi01 = g_argv1
                AND lqi02 = g_argv2
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lqi_file",g_lqi_t.lqi03,"",SQLCA.sqlcode,"","",1)  
                LET g_lqi[l_ac].* = g_lqi_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
         #LET l_ac_t = l_ac                # 新增   #FUN-D30033 Mark
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_lqi[l_ac].* = g_lqi_t.*
             #FUN-D30033--add--str--
             ELSE
                CALL g_lqi.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30033--add--end--
             END IF
             CLOSE t7202_bcl            # 新增
             ROLLBACK WORK         # 新增
             EXIT INPUT
          END IF
 
          LET l_ac_t = l_ac          #FUN-D30033 Add    
          CLOSE t7202_bcl            # 新增
          COMMIT WORK
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(lqi03) AND l_ac > 1 THEN
             LET g_lqi[l_ac].* = g_lqi[l_ac-1].*
             NEXT FIELD lqi03
          END IF  
   
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
        
   END INPUT
 
   CLOSE t7202_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t7202_askkey()
 
   CLEAR FORM
   CALL g_lqi.clear()
       CONSTRUCT g_wc2 ON lqi03,lqi04,lqi05,lqi06 FROM s_lqi[1].lqi03,s_lqi[1].lqi04,
                           s_lqi[1].lqi05,s_lqi[1].lqi06
 
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
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_rec_b = 0
      LET g_wc2 = NULL
      RETURN 
   END IF
 
   CALL t7202_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION t7202_b_fill(p_wc2)              
 DEFINE   p_wc2           LIKE type_file.chr1000     
  
    LET g_sql ="SELECT lqi03,lqi04,lqi05,lqi06 ",   
               " FROM lqi_file ",
               " WHERE ", p_wc2 CLIPPED,                   
               " and lqi01 = '",g_argv1,"'",
               " and lqi02 = '",g_argv2,"'",
               " ORDER BY lqi03"
    PREPARE t7202_pb FROM g_sql
    DECLARE lqi_curs CURSOR FOR t7202_pb
 
    CALL g_lqi.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lqi_curs INTO g_lqi[g_cnt].*   
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF       
        
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lqi.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t7202_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lqi TO s_lqi.* ATTRIBUTE(COUNT=g_rec_b)
 
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
                                            
FUNCTION t7202_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                         
                                                                                  
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("lqi03",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION t7202_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                               
                                                                                  
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("lqi03",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
#No.FUN-960134      
 
 
 
