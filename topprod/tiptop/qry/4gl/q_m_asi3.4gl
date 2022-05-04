# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Program name  : q_m_asi3.4gl
# Description   : 多工廠會計科目編號查詢(顯示帳別)
# Date & Author : FUN-920111 2009/05/11 BY ve007
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-990069 09/09/24 By baofei GP集團架構修改,sub相關參數
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No.FUN-A50102 10/06/23 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-B20004 11/02/09 By destiny 增加科目自動過濾功能 
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
 
DATABASE ds
 
 
GLOBALS "../../config/top.global"
#FUN-920033              #FUN-BB0036
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	
         asi05    LIKE asi_file.asi05,
         asi051   LIKE asi_file.asi051
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	
         asi05    LIKE asi_file.asi05,
         asi051   LIKE asi_file.asi051
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).
DEFINE   ms_cons_where    STRING                  #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10    #每頁顯現資料筆數.	
DEFINE   ms_default1      STRING  
DEFINE   ms_default2      STRING    
DEFINE   ms_ret1          STRING                  #回傳欄位的變數 
DEFINE   ms_ret2          STRING                  
DEFINE   ms_asi04         LIKE asi_file.asi04
DEFINE   ms_asi041        LIKE asi_file.asi041
DEFINE   ms_asi01         LIKE asi_file.asi01
     
 
#FUNCTION q_m_asi3(pi_multi_sel,pi_need_cons,p_dbs,ps_default1,ps_default2,ps_asi04,ps_asi01,ps_asi041)  #FUN-990069
FUNCTION q_m_asi3(pi_multi_sel,pi_need_cons,p_plant,ps_default1,ps_default2,ps_asi04,ps_asi01,ps_asi041) #FUN-990069                
   DEFINE   pi_multi_sel   LIKE type_file.num5,  
            pi_need_cons   LIKE type_file.num5,  	
            ps_default1    STRING  ,                    #預設回傳值(在取消時會回傳此類預設值). 
            ps_default2    STRING  ,      
            p_plant        LIKE type_file.chr10,  #FUN-990069
            p_dbs          LIKE type_file.chr21, 	
            ps_asi04       LIKE asi_file.asi04,
            ps_asi01       LIKE asi_file.asi01,
            ps_asi041      LIKE asi_file.asi041        
 
#FUN-990069--beatk            
    #IF cl_null(p_plant) THEN  #FUN-A50102 
    #   LET p_dbs = NULL       #FUN-A50102 
    #ELSE                      #FUN-A50102
       LET g_plant_new = p_plant 
    #   CALL s_getdbs()        #FUN-A50102
    #   LET p_dbs = g_dbs_new  #FUN-A50102
    #END IF                     #FUN-A50102
#FUN-990069--end 
   LET ms_asi04 = ps_asi04
   LET ms_asi01 = ps_asi01
   LET ms_asi041 = ps_asi041
   LET ms_default1 = ps_default1 
   LET ms_default2 = ps_default2
   LET g_dbs = p_dbs
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_m_asi3" ATTRIBUTE(STYLE="create_qry") 
 
   CALL cl_ui_locale("q_m_asi3")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("asi05", "red")
   END IF
 
   CALL m_asi3_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1,ms_ret2 
      
   ELSE
      RETURN ms_ret1,ms_ret2 
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2003/09/23 by Winny
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION m_asi3_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	
            li_continue      LIKE type_file.num5      #是否繼續.	
   DEFINE   li_start_index   LIKE type_file.num10, 
            li_end_index     LIKE type_file.num10 	
   DEFINE   li_curr_page     LIKE type_file.num5  	
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
 
 
   LET mi_page_count = 100 
   LET li_reconstruct = TRUE
   LET ms_cons_where=NULL #FUN-B20004
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      IF (li_reconstruct) THEN
         MESSAGE ""
     
         IF (mi_need_cons) THEN
            CONSTRUCT ms_cons_where ON asi05,asi051
                                  FROM s_aag[1].asi05,s_aag[1].asi051
                                  
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            
            END CONSTRUCT
     
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
     
         CALL m_asi3_qry_prep_result_set() 
        
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
        
         IF (mi_page_count >= ma_qry.getLength()) THEN
            LET ls_hide_act = "prevpage,nextpage"
         END IF
     
         IF (NOT mi_need_cons) THEN
            IF (ls_hide_act IS NULL) THEN
               LET ls_hide_act = "reconstruct"
            ELSE
               LET ls_hide_act = "prevpage,nextpage,reconstruct"
            END IF 
         END IF
     
         LET li_start_index = 1
     
         LET li_reconstruct = FALSE
      END IF
     
      LET li_end_index = li_start_index + mi_page_count - 1
     
      IF (li_end_index > ma_qry.getLength()) THEN
         LET li_end_index = ma_qry.getLength()
      END IF
     
      CALL m_asi3_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL m_asi3_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL m_asi3_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2003/09/23 by Winny
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION m_asi3_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,   #如果不需要複選資料,則不要設定此欄位	
            asi05    LIKE asi_file.asi05,
            asi051   LIKE asi_file.asi051
   END RECORD
 
   #FUN-B20004--beatk
   IF cl_null(ms_cons_where) AND mi_need_cons=0 THEN 
      LET ms_cons_where=" asi05 LIKE '",ms_default1,"%' "
   END IF  
   #FUN-B20004--end     
   #Beatk:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_m_asi3', 'asi_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   
   LET ls_sql = "SELECT 'N',asi05,asi051 ",  
                #" FROM ",g_dbs CLIPPED,"asi_file",
                " FROM ",cl_get_target_table(g_plant_new,'asi_file'), #FUN-A50102
                " WHERE ",ms_cons_where
                
   IF NOT mi_multi_sel THEN
      LET ls_where = " AND asi04 = '",ms_asi04,"'",
                     " AND asi01 = '",ms_asi01,"'",
                     " AND asi041 = '",ms_asi041,"'"
   END IF
   
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED
   
   DISPLAY "ls_sql=",ls_sql
   
   CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql
   CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   FOR li_i = ma_qry.getLength() TO 1 STEP -1
      CALL ma_qry.deleteElement(li_i)
   END FOR
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_qry.*
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
 
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
 
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2003/09/23 by Winny
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION m_asi3_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	
            pi_end_index     LIKE type_file.num10 	
   DEFINE   li_i             LIKE type_file.num10, 
            li_j             LIKE type_file.num10 	
 
 
   FOR li_i = ma_qry_tmp.getLength() TO 1 STEP -1
      CALL ma_qry_tmp.deleteElement(li_i)
   END FOR
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry_tmp[li_j+1].* = ma_qry[li_i].*
      LET li_j = li_j + 1
   END FOR
 
   CALL SET_COUNT(ma_qry_tmp.getLength())
END FUNCTION
 
##################################################
# Description  	: 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2003/09/23 by Winny
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION m_asi3_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 
            pi_end_index     LIKE type_file.num10 	
   DEFINE   li_continue      LIKE type_file.num5,  	
            li_reconstruct   LIKE type_file.num5  	
   DEFINE   li_i             LIKE type_file.num5       
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_aag.* 
   ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) 
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_aag.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL m_asi3_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_aag.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL m_asi3_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL m_asi3_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_aag.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL m_asi3_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL m_asi3_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                        #CHI-9C0048
            LET ms_ret1 = NULL       #CHI-9C0048
            LET ms_ret2 = NULL       #CHI-9C0048
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
            LET ms_ret2 = ms_default2
         END IF
 
         LET li_continue = FALSE
     
         EXIT INPUT
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION selectall
         FOR li_i = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[li_i].check = "Y"
         END FOR
 
      ON ACTION select_none
         FOR li_i = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[li_i].check = "N"
         END FOR
   
   END INPUT
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description  	: 重設查詢資料關於'check'欄位的值.
# Date & Author : 2003/09/23 by Winny
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	    : void
# Memo        	:
# Modify   	:
##################################################
FUNCTION m_asi3_qry_reset_multi_sel(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 
            pi_end_index     LIKE type_file.num10 	
   DEFINE   li_i             LIKE type_file.num10, 	
            li_j             LIKE type_file.num10 	
 
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry[li_i].check = ma_qry_tmp[li_j+1].check
      LET li_j = li_j + 1
   END FOR
END FUNCTION
 
##################################################
# Description  	: 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2003/09/23 by Winny
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	    : SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	    :
##################################################
FUNCTION m_asi3_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	
            pi_end_index     LIKE type_file.num10 	
   DEFINE   li_continue      LIKE type_file.num5,  
            li_reconstruct   LIKE type_file.num5  
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_aag.*
      BEFORE DISPLAY
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
      
         LET li_continue = TRUE
      
         EXIT DISPLAY
      ON ACTION nextpage
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
      
         LET li_continue = TRUE
      
         EXIT DISPLAY
      ON ACTION refresh
         LET pi_start_index = 1
         LET li_continue = TRUE
      
         EXIT DISPLAY
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
      
         EXIT DISPLAY
      ON ACTION accept
         CALL m_asi3_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
            LET ms_ret2 = ms_default2
         END IF
 
         LET li_continue = FALSE
      
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description   : 重設查詢資料.
# Date & Author : 2003/09/23 by Winny
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION m_asi3_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2003/09/23 by Winny
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION m_asi3_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 	
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10  
 
 
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].asi05 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].asi05 CLIPPED)
            END IF
         END IF    
      END FOR
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].asi05 CLIPPED
      LET ms_ret2 = ma_qry[pi_sel_index].asi051 CLIPPED
   END IF
END FUNCTION
#No.FUN-920111
