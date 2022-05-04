# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#{
# Program name  : q_nsc.sql
# Program ver.  : 7.0
# Description   : 日期格式選擇 
# Date & Author : FUN-880073 2008/08/27 by sabrina
# Memo          : 
# Modify.........: No.FUN-880082 08/09/01 By tsai_yen 開窗全選功能
#}
# Modify........: NO.FUN-870037 08/10/02 by yiting add YYYMMDD格式 
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         chtype   STRING,
         nsc04    STRING
END RECORD
 
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         chtype   STRING,
         nsc04    STRING
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.
DEFINE   ms_default1      STRING,
         ms_ret1          STRING                   #回傳欄位的變數
 
FUNCTION q_nsc(pi_multi_sel,pi_need_cons,ps_default1)
   DEFINE   pi_multi_sel   LIKE type_file.num5, 
            pi_need_cons   LIKE type_file.num5, 
            ps_default1    STRING  
 
 
   WHENEVER ERROR CONTINUE
 
   LET ms_default1 = ps_default1 
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_nsc" ATTRIBUTE(STYLE="create_qry") 
 
   CALL cl_ui_locale("q_nsc")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko : 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("nsc04", "red")
   END IF
 
   CALL nsc_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
       RETURN ms_ret1
   ELSE
       RETURN ms_ret1 
   END IF
 
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇
# Date & Author : 2008/08/27 by sabrina
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION nsc_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE.
            li_continue      LIKE type_file.num5      #是否繼續.
   DEFINE   li_start_index   LIKE type_file.num10,
            li_end_index     LIKE type_file.num10
   DEFINE   li_curr_page     LIKE type_file.num5
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
 
 
   LET mi_page_count = 100 
   LET li_reconstruct = FALSE
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
     
     IF (INT_FLAG) THEN
        LET INT_FLAG = FALSE
        EXIT WHILE
     END IF
     
     CALL nsc_qry_prep_result_set() 
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
     
     LET li_start_index = 1  #設定起始指標=1
     
     LET li_reconstruct = FALSE
     
     LET li_end_index = li_start_index + mi_page_count - 1
     
     IF (li_end_index > ma_qry.getLength()) THEN
         LET li_end_index = ma_qry.getLength()
     END IF
     
     CALL nsc_qry_set_display_data(li_start_index, li_end_index)
     
     LET li_curr_page = li_end_index / mi_page_count  #頁數
     
     # 2004/02/25 by saki : 若最後一頁不到整除的數目, 避免頁次不會再往上加
     IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
     END IF
 
     SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
     SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
     MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     IF (mi_multi_sel) THEN
         CALL nsc_qry_input_array(ls_hide_act, li_start_index, li_end_index) 
         RETURNING li_continue,li_reconstruct,li_start_index
     ELSE 
         CALL nsc_qry_display_array(ls_hide_act, li_start_index, li_end_index) 
         RETURNING li_continue,li_reconstruct,li_start_index
     END IF
     
     IF (NOT li_continue) THEN
         EXIT WHILE
     END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集
# Date & Author : 2008/08/27 by sabrina
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION nsc_qry_prep_result_set()
   DEFINE   li_i       LIKE type_file.num10
   DEFINE   chtype1    LIKE ze_file.ze03
   DEFINE   chtype3    LIKE ze_file.ze03
 
 
   CALL ma_qry.clear()
 
   FOR li_i =1 TO 3
       LET ma_qry[li_i].check = 'N'
   END FOR
 
   SELECT ze03 INTO chtype1 FROM ze_file WHERE ze01 = 'q_nsc01' AND ze02 = g_lang
   SELECT ze03 INTO chtype3 FROM ze_file WHERE ze01 = 'q_nsc02' AND ze02 = g_lang
 
   LET ma_qry[1].chtype = chtype1
   LET ma_qry[2].chtype = chtype1
   LET ma_qry[3].chtype = chtype3
   LET ma_qry[4].chtype = chtype3
   LET ma_qry[1].nsc04 = 'YYYYMMDD'  #FUN-870037
   LET ma_qry[2].nsc04 = 'YYYY/MM/DD'
   LET ma_qry[3].nsc04 = 'YYMMDD'
   LET ma_qry[4].nsc04 = 'YYYMMDD'   #FUN-870037
 
 
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2008/08/27 by sabrina
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION nsc_qry_set_display_data(pi_start_index, pi_end_index)
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
# Date & Author : 2008/08/27 by sabrina
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION nsc_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 
            pi_end_index     LIKE type_file.num10 
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_nsc.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_nsc.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
 
      ON ACTION prevpage
         CALL nsc_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
 
      ON ACTION nextpage
         CALL nsc_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
 
      ON ACTION refresh
         CALL nsc_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
 
      ON ACTION reconstruct
         LET li_reconstruct = FALSE
         LET li_continue = TRUE
     
         EXIT INPUT
 
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(nsc_.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL nsc_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL nsc_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                        #CHI-9C0048
            LET ms_ret1 = NULL       #CHI-9C0048
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
     
         EXIT INPUT
 
      ON ACTION cancel
         LET INT_FLAG = 0
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
 
         LET li_continue = FALSE
     
         EXIT INPUT
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
      ON ACTION qry_string
         CALL cl_qry_string("detail")
 
      ### FUN-880082 START ###
      ON ACTION selectall
         FOR li_i = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[li_i].check = "Y"
         END FOR
 
      ON ACTION select_none
         FOR li_i = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[li_i].check = "N"
         END FOR
      ### FUN-880082 END ###
 
   END INPUT
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description  	: 重設查詢資料關於'check'欄位的值. 
# Date & Author : 2008/08/27 by sabrina
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION nsc_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Date & Author : 2008/08/27 by sabrina
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION nsc_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10 
   DEFINE   li_continue      LIKE type_file.num5, 
            li_reconstruct   LIKE type_file.num5 
   DEFINE   lj_j             LIKE type_file.num10 
 
   DISPLAY ARRAY ma_qry_tmp TO s_nsc.* 
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
         LET li_reconstruct = FALSE
         LET li_continue = TRUE
      
         EXIT DISPLAY
      ON ACTION accept
         CALL nsc_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 
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
 
      ON ACTION qry_string
         CALL cl_qry_string("detail")
 
   END DISPLAY
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description   : 重設查詢資料. (不用改)
# Date & Author : 2008/08/27 by sabrina
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION nsc_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2008/08/27 by sabrina
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION nsc_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10
 
 
   # 2004/06/03 by saki : GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN
       LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
          IF (ma_qry[li_i].check = 'Y') THEN
             IF (lsb_multi_sel.getLength() = 0) THEN
                CALL lsb_multi_sel.append(ma_qry[li_i].nsc04 CLIPPED)
             ELSE
                CALL lsb_multi_sel.append("|" || ma_qry[li_i].nsc04 CLIPPED)
             END IF
          END IF
      END FOR
          # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值.
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].nsc04 CLIPPED
   END IF
END FUNCTION
#FUN-880073---end---
