# Prog. Version..: '5.30.06-13.03.18(00003)'     #
#
# Program name   : q_ima_2.4gl
# Program ver.   : 
# Description    : 產品編號查詢(多工廠)
# Date & Author  : 2011/03/17 By Summer(MOD-B30277)
# Modify.........: No.MOD-C10041 12/01/05 By suncx axmt410開窗時應該排除來源碼為C：规格组件的料件
# Modify.........: No.MOD-D30056 13/03/07 By Vampire 調整 q_ima_2() 回傳的變數，在開窗前預設為NULL

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         ima01    LIKE ima_file.ima01,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         ima01    LIKE ima_file.ima01,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.
DEFINE   ms_default1      STRING    
DEFINE   ms_ret1          STRING     #回傳欄位的變數
DEFINE   ms_ret2          LIKE apc_file.apc02   #回傳欄位的變數  
#DEFINE   ms_dbs            LIKE type_file.chr21  
DEFINE   l_plant            LIKE type_file.chr10  

FUNCTION q_ima_2(pi_multi_sel,pi_need_cons,p_plant)
   DEFINE   pi_multi_sel   LIKE type_file.num5, 
            pi_need_cons   LIKE type_file.num5, 
            ps_default1    STRING  , #預設回傳值(在取消時會回傳此類預設值).
            p_plant        LIKE type_file.chr10
   DEFINE   l_win          ui.Window
   DEFINE   l_rtz04        LIKE rtz_file.rtz04
   DEFINE   l_ze01         LIKE type_file.chr300
   DEFINE   l_ze02         LIKE type_file.chr300    

   WHENEVER ERROR CALL cl_err_msg_log

    LET l_plant = p_plant 
   INITIALIZE ms_ret1 TO NULL #MOD-D30056 add
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_ima" ATTRIBUTE(STYLE="create_qry") 
 
   CALL cl_ui_locale("q_ima")
    LET l_ze01 = cl_getmsg("lib-606",g_lang)
    LET l_ze02 = cl_getmsg("lib-607",g_lang)
    LET l_win = ui.Window.getCurrent()
    IF cl_null(l_plant) THEN
       LET l_plant = g_plant
    END IF
    SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = l_plant
    IF NOT cl_null(l_rtz04) THEN
       CALL l_win.setText(l_ze01)
    ELSE
       CALL l_win.setText(l_ze02)
    END IF
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
   
   # 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   IF (mi_multi_sel) THEN #在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
      CALL cl_set_comp_font_color("ima01", "red")
   END IF
 
   CALL m_ima_2_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 #複選資料只能回傳一個欄位的組合字串.
   ELSE
      RETURN ms_ret1
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
FUNCTION m_ima_2_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 
            li_continue      LIKE type_file.num5      #是否繼續.
   DEFINE   li_start_index   LIKE type_file.num10,
            li_end_index     LIKE type_file.num10 
   DEFINE   li_curr_page     LIKE type_file.num5  
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
 
 
   LET mi_page_count = 100 #每頁顯現最大資料筆數.
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      IF (li_reconstruct) THEN
         MESSAGE ""
         
         IF (mi_need_cons) THEN
 
            CONSTRUCT ms_cons_where ON ima01,ima02,ima021
                                   FROM s_ima[1].ima01,s_ima[1].ima02,s_ima[1].ima021

  
            ON ACTION controlg      
               CALL cl_cmdask()     
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
            ON ACTION about         
               CALL cl_about()      
 
            ON ACTION help          
               CALL cl_show_help()  
 
            END CONSTRUCT
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
 
         CALL m_ima_2_qry_prep_result_set() 
         # 2003/07/14 by Hiko : 如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
         # 2003/07/14 by Hiko : 如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則要隱藏'上下頁'的按鈕.
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
     
      CALL m_ima_2_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL m_ima_2_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL m_ima_2_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
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
FUNCTION m_ima_2_qry_prep_result_set()
   DEFINE l_filter_cond STRING 
   DEFINE   l_db_type    LIKE type_file.chr3   
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10
   DEFINE  l_sql      STRING
   DEFINE   p_plant     LIKE type_file.chr10
   DEFINE   l_rtz04     LIKE rtz_file.rtz04 
   DEFINE   p_sys       LIKE zz_file.zz011 
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,   #如果不需要複選資料,則不要設定此欄位
            ima01    LIKE ima_file.ima01,
            ima02    LIKE ima_file.ima02,
            ima021   LIKE ima_file.ima021
   END RECORD
 
   LET l_db_type=cl_db_get_database_type()

   LET l_filter_cond = cl_get_extra_cond_for_qry('q_ima', 'ima_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF  
  LET l_sql = "SELECT rtz04 FROM  ",cl_get_target_table(l_plant,'rtz_file'),
               " WHERE rtz01 = '",l_plant,"' "
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql    
      PREPARE s_rtz_pb FROM l_sql
      EXECUTE s_rtz_pb INTO l_rtz04
     SELECT zz011 INTO p_sys FROM zz_file WHERE zz01 = g_prog  
    IF ( p_sys = "ALM" OR p_sys = "CLM" OR  p_sys = "ART" OR p_sys = "CRT" OR p_sys = "APM"
       OR p_sys = "CPM"  OR p_sys = "AXM" OR p_sys = "CXM"
       OR p_sys="AIM" OR p_sys = "CIM") AND NOT cl_null(l_rtz04) THEN  
       LET ls_sql = "SELECT 'N',ima01,ima02,ima021 ",
                "  FROM ",cl_get_target_table(l_plant,'ima_file'), 
                " WHERE imaacti = 'Y'  AND ima01 IN (SELECT rte03 FROM ", cl_get_target_table(l_plant,'rte_file'), 
                " WHERE rte01 = '",l_rtz04,"' )",
                " AND ima130 <> '0'",    
                " AND ",ms_cons_where    
     
       ELSE   
       LET ls_sql = "SELECT 'N',ima01,ima02,ima021 ",
                 "  FROM ",cl_get_target_table(l_plant,'ima_file'), 
                 " WHERE imaacti = 'Y'",  
                 "   AND ima130 <> '0'",    
                 "   AND ",ms_cons_where    
    END IF      
    #MOD-C10041 add begin-----------------------
    IF g_prog = "axmt410" THEN
       LET ls_sql = ls_sql CLIPPED," AND ima08 <> 'C' "
    END IF
    #MOD-C10041 add end-------------------------
     IF p_sys<> "ALM" OR p_sys <>"CLM" THEN
        IF NOT s_ima_except1(g_prog,l_plant) THEN    
          LET ls_sql = ls_sql CLIPPED," AND (ima120 IS NULL OR ima120 = ' ' OR ima120='1')"
       END IF
       IF NOT s_ima_except2(g_prog) THEN
           LET ls_sql = ls_sql CLIPPED,"AND ima01 NOT IN ( SELECT rty02 FROM rty_file WHERE rty01 = '", g_plant CLIPPED, "' AND rty06 = '4'  AND rtyacti = 'Y'  ) "
       END IF
       IF NOT cl_null(l_rtz04) THEN
           IF p_sys = "AXM" OR p_sys = "CXM" THEN
             IF g_prog = "axmt700" OR g_prog = "axmt840" THEN
                LET ls_sql = ls_sql CLIPPED," AND ima01 IN (SELECT rte03 FROM ",cl_get_target_table(l_plant,'rte_file'),
                                          " WHERE rte01 = '",l_rtz04,"' AND rte06 = 'Y' )"
             ELSE
                LET ls_sql = ls_sql CLIPPED," AND ima01 IN (SELECT rte03 FROM ",cl_get_target_table(l_plant,'rte_file'),
                                          " WHERE rte01 = '",l_rtz04,"' AND rte05 = 'Y' )"
             END IF
           END IF
           IF p_sys = "APM" OR p_sys = "CPM" THEN
              LET ls_sql = ls_sql CLIPPED," AND ima01 IN (SELECT rte03 FROM ",cl_get_target_table(l_plant,'rte_file'),
                                          " WHERE rte01 = '",l_rtz04,"' AND rte04 = 'Y' )"
           END IF 
        END IF
     END IF
     LET ls_sql = ls_sql CLIPPED,  " ORDER BY ima01 "
     DISPLAY "ls_sql=",ls_sql
 	 CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql     
         CALL cl_parse_qry_sql(ls_sql,l_plant) RETURNING ls_sql  
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
 
      #判斷是否已達選取上限
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
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION m_ima_2_qry_set_display_data(pi_start_index, pi_end_index)
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
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION m_ima_2_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 
            pi_end_index     LIKE type_file.num10 
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5 
   DEFINE   li_i             LIKE type_file.num5 
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_ima.* 
   ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED)
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_ima.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL m_ima_2_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_ima.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL m_ima_2_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL m_ima_2_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN      
            CALL GET_FLDBUF(s_ima.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL m_ima_2_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL m_ima_2_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                    
            LET ms_ret1 = NULL
         END IF        
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG=0 
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
 
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION controls                         
         CALL cl_set_head_visible("grid01,grid02","AUTO")  
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
      ON ACTION qry_string
         CALL cl_qry_string("detail")
 
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
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION m_ima_2_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION m_ima_2_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 
            pi_end_index     LIKE type_file.num10 
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5 
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_ima.*
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
         CALL m_ima_2_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG=0 
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
 
         LET li_continue = FALSE
      
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
    
      ON ACTION controls         
         CALL cl_set_head_visible("grid01,grid02","AUTO")
 
      ON ACTION qry_string
         CALL cl_qry_string("detail")
 
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
FUNCTION m_ima_2_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2003/09/23 by Winny
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION m_ima_2_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10
 
 
   # GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].ima01 CLIPPED) 
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].ima01 CLIPPED)  
            END IF
         END IF    
      END FOR
      # 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].ima01 CLIPPED
      LET ms_ret2 = ma_qry[pi_sel_index].ima02 CLIPPED
   END IF
END FUNCTION
#MOD-B30277
