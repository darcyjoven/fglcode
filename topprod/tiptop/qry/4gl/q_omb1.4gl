# Prog. Version..: '5.30.06-13.04.02(00001)'     #
#
# Program name  : q_omb1.4gl
# Program ver.  : 7.0
# Description   :
# Date & Author : 2013/01/24 #FUN-D10101 by lujh

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         oma01    LIKE oma_file.oma01,
         omb03    LIKE omb_file.omb03,
         omb04    LIKE omb_file.omb04,
         omb48    LIKE omb_file.omb48
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,
         oma01    LIKE oma_file.oma01,
         omb03    LIKE omb_file.omb03,
         omb04    LIKE omb_file.omb04,
         omb48    LIKE omb_file.omb48
END RECORD
DEFINE   ms_cus       LIKE oma_file.oma03,
         ms_omg04     LIKE omg_file.omg04,
         ms_omg05     LIKE omg_file.omg05,
         ms_omg06     LIKE omg_file.omg06
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.
DEFINE   ms_ret1          STRING    
DEFINE   ms_ret2          STRING
DEFINE   ms_plant         LIKE type_file.chr10        
DEFINE   ms_omg00         LIKE omg_file.omg00
FUNCTION q_omb1(pi_multi_sel,pi_need_cons,ps_cus,ps_omg04,ps_omg05,ps_omg06,ps_plant,ps_omg00)  
   DEFINE   pi_multi_sel   LIKE type_file.num5,
            pi_need_cons   LIKE type_file.num5,
            ps_cus         LIKE oma_file.oma03,
            ps_omg04       LIKE omg_file.omg04,
            ps_omg05       LIKE omg_file.omg05,
            ps_omg06       LIKE omg_file.omg06,
            ps_plant       LIKE type_file.chr10,
            ps_omg00       LIKE omg_file.omg00   
 
   WHENEVER ERROR CONTINUE

   LET g_plant_new = ps_plant

   LET ms_cus    = ps_cus
   LET ms_omg04  = ps_omg04
   LET ms_omg05  = ps_omg05
   LET ms_omg06  = ps_omg06
   LET ms_plant  = ps_plant     
   LET ms_omg00  = ps_omg00
   LET ms_ret1 = ''
   LET ms_ret2 = ''
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_omb1" ATTRIBUTE(STYLE="create_qry")
 
   CALL cl_ui_locale("q_omb1")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
      CALL cl_set_comp_visible("oma03",FALSE)
   END IF
   CALL cl_set_comp_visible("oma03",FALSE)
   CALL omb1_qry_sel()
   
   CLOSE WINDOW w_qry
   IF (mi_multi_sel) THEN
      RETURN ms_ret1,'' #複選資料只能回傳一個欄位的組合字串.
   ELSE
      RETURN ms_ret1,ms_ret2 #回傳值(也許有多個).
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION omb1_qry_sel()
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
 
   WHILE TRUE
      CLEAR FORM
 
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      IF (li_reconstruct) THEN
         MESSAGE ""
 
         IF (mi_need_cons) THEN
            CONSTRUCT BY NAME ms_cons_where ON oma01,omb03,omb04,omb48
 
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
 
         CALL omb1_qry_prep_result_set()
         # 如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
         # 如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則要隱藏'上下頁'的按鈕.
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
 
      CALL omb1_qry_set_display_data(li_start_index, li_end_index)
 
      LET li_curr_page = li_end_index / mi_page_count
 
      # 若最後一頁不到整除的數目, 避免頁次不會再往上加
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL omb1_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL omb1_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
 
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION omb1_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql     STRING,
            ls_where   STRING
   DEFINE   li_i       LIKE type_file.num10 	
   DEFINE   ls_n       LIKE type_file.num10
   DEFINE   lr_qry     RECORD
            check      LIKE type_file.chr1,   
            oma01      LIKE oma_file.oma01,
            omb03      LIKE omb_file.omb03,
            omb04      LIKE omb_file.omb04,
            omb48      LIKE omb_file.omb48
   END RECORD
   DEFINE   l_buf           LIKE oay_file.oayslip
   DEFINE   l_oay11         LIKE oay_file.oay11

   LET l_filter_cond = cl_get_extra_cond_for_qry('q_omb1', 'omb_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   LET ls_sql = "SELECT 'N',oma01,omb03,omb04,omb48",  
                "  FROM oma_file,omb_file ",   
                " WHERE ",ms_cons_where CLIPPED,
                "   AND oma01 = omb01",
                "   AND omaconf = 'Y'",
                "   AND omb48 < omb12",
                "   AND oma03 = '",ms_omg04 CLIPPED, "'",
                "   AND oma21 = '",ms_omg05 CLIPPED, "'",
                "   AND oma23 = '",ms_omg06 CLIPPED, "'",
	            "  ORDER BY oma01,omb03 "
 
 
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   CALL ma_qry.clear()
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_qry.*
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
      LET ls_n = 0 
     IF mi_multi_sel THEN 
      SELECT COUNT(*) INTO ls_n FROM omg_file
       WHERE omg00 = ms_omg00 AND omg11 = lr_qry.oma01
         AND omg23 = lr_qry.omb03
      IF ls_n >0 THEN CONTINUE FOREACH END IF 
     END IF 

      IF cl_null(lr_qry.oma01) AND g_ooz.ooz19='N' THEN CONTINUE FOREACH
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
# Parameter   	. pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               . pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION omb1_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 
            pi_end_index     LIKE type_file.num10 	
   DEFINE   li_i             LIKE type_file.num10, 	
            li_j             LIKE type_file.num10 
 
 
   CALL ma_qry_tmp.clear()
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry_tmp[li_j+1].* = ma_qry[li_i].*
      LET li_j = li_j + 1
   END FOR
 
   CALL SET_COUNT(ma_qry_tmp.getLength())
END FUNCTION
 
##################################################
# Description  	: 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               . pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               . pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION omb1_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 
            pi_end_index     LIKE type_file.num10 
   DEFINE   li_continue      LIKE type_file.num5, 
            li_reconstruct   LIKE type_file.num5  
   DEFINE   li_i     LIKE type_file.num10
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_omb.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE,UNBUFFERED)
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_omb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL omb1_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_omb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL omb1_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION refresh
         CALL omb1_qry_refresh()
 
         LET pi_start_index = 1
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        
            CALL GET_FLDBUF(s_omb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL omb1_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL omb1_qry_accept(pi_start_index+ARR_CURR()-1)
         END IF                      
         LET li_continue = FALSE
 
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 
         LET li_continue = FALSE
         LET ms_ret1 = ''
         LET ms_ret2 = ''
 
         EXIT INPUT
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
 
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
# Parameter   	. pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	
#               . pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION omb1_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               . pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               . pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION omb1_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 
            pi_end_index     LIKE type_file.num10 	
   DEFINE   li_continue      LIKE type_file.num5,  	
            li_reconstruct   LIKE type_file.num5  
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_omb.*
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
         CALL omb1_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
 
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 
         LET li_continue = FALSE
 
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
 
      ON ACTION qry_string
         CALL cl_qry_string("detail")
 
   END DISPLAY
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description   : 重設查詢資料.
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION omb1_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Parameter   	. pi_sel_index   LIKE type_file.num10    所選擇的資料索引	
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION omb1_qry_accept(pi_sel_index)
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
               CALL lsb_multi_sel.append(ma_qry[li_i].oma01 CLIPPED || "," || ma_qry[li_i].omb03)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].oma01 CLIPPED || "," || ma_qry[li_i].omb03)
            END IF
         END IF
      END FOR
      LET ms_ret1 = lsb_multi_sel.toString()
      
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].oma01 CLIPPED
      LET ms_ret2 = ma_qry[pi_sel_index].omb03 CLIPPED
   END IF
END FUNCTION
#FUN-C60036
#FUN-D10101--add
