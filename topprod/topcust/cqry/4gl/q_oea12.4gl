# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#{
# Program name  : q_oea12.4gl
# Program ver.  : 7.0
# Description   : 訂單資料查詢
# Date & Author : 2003/09/22 by jack
# Memo          : 
# Modify........: No.MOD-530311 05/04/11 By Mandy copy from q_oea,和q_oea不同的是所顯示的資料排除已經完全出貨的訂單
# Modify........: No.FUN-660161 06/07/07 By Rayven 增加匯出Excel功能
# Modify........: No.FUN-680131 06/08/31 By Carrier 欄位型態用LIKE定義
#}
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify........: No.TQC-7C0123 07/12/08 By Unicorn 修改訂單產品一、訂單產品二的實現方式
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.FUN-880082 08/09/01 By tsai_yen 開窗全選功能
# Modify.........: No.MOD-8B0108 08/11/15 By Smapmin 輸入狀態時,訂單開窗需過濾訂單性質是否與出通單性質一致
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-990069 09/10/09 By baofei 修改GP5.2的相關設定 
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No:TQC-AB0025 10/12/17 By chenying Sybase調整
# Modify.........: No:MOD-C20054 12/03/16 By jt_chen 訂單開窗需過濾訂單出貨別是否與出通單性質一致
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         oea10  LIKE oea_file.oea10,
         oea01  LIKE oea_file.oea01,                     
         oea00  LIKE oea_file.oea00,                     
         oea02  LIKE oea_file.oea02,                     
         oea032 LIKE oea_file.oea032,                    
         oea14  LIKE oea_file.oea14,                     
         oeb04_1 LIKE type_file.chr1000,  #No.FUN-680131  VARCHAR(27)
         oeb04_2 LIKE type_file.chr1000   #No.FUN-680131  VARCHAR(70)
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         oea10  LIKE oea_file.oea10,
         oea01  LIKE oea_file.oea01,
         oea00  LIKE oea_file.oea00,
         oea02  LIKE oea_file.oea02,
         oea032 LIKE oea_file.oea032,
         oea14  LIKE oea_file.oea14,
         oeb04_1 LIKE type_file.chr1000,  #No.FUN-680131  VARCHAR(27)
         oeb04_2 LIKE type_file.chr1000   #No.FUN-680131  VARCHAR(70)
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_default1      STRING     
DEFINE   ms_ret1          STRING,    
         g_cus_no         LIKE oea_file.oea03,     #No.FUN-680131 VARCHAR(20)
         g_type           LIKE type_file.chr1,     #No.FUN-680131 VARCHAR(1)
         g_oga08          LIKE oga_file.oga08,     #MOD-8B0108
         g_oga00          LIKE oga_file.oga00      #MOD-C20054
 
#FUNCTION q_oea12(pi_multi_sel,pi_need_cons,ps_default1,p_cus_no,p_type)                  #MOD-8B0108
#FUNCTION q_oea12(pi_multi_sel,pi_need_cons,ps_default1,p_cus_no,p_type,p_oga08)          #MOD-8B0108 add   #MOD-C20054 mark  
FUNCTION q_oea12(pi_multi_sel,pi_need_cons,ps_default1,p_cus_no,p_type,p_oga08,p_oga00)   #MOD-C20054 add
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    STRING  , 
            p_cus_no       LIKE oea_file.oea03,     #No.FUN-680131 VARCHAR(20)
            p_type         LIKE type_file.chr1,     #No.FUN-680131 VARCHAR(1)
            p_oga08        LIKE oga_file.oga08,     #MOD-8B0108
            p_oga00        LIKE oga_file.oga00       #MOD-C20054

 
 
   LET ms_default1 = ps_default1
   LET g_cus_no= p_cus_no
   LET g_type  = p_type
   LET g_oga08 = p_oga08   #MOD-8B0108
   LET g_oga00 = p_oga00   #MOD-C20054

   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "cqry/42f/q_oea12" ATTRIBUTE(STYLE="create_qry") #No.FUN-660161
 
   CALL cl_ui_locale("q_oea12")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko : 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("oea01", "red")
   END IF
 
   CALL oea12_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 
   ELSE
      RETURN ms_ret1 
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2003/09/22 by jack
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION oea12_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	#No.FUN-680131 SMALLINT
            li_continue      LIKE type_file.num5      #是否繼續.	#No.FUN-680131 SMALLINT
   DEFINE   li_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5  	#No.FUN-680131 SMALLINT
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
          IF NOT cl_null(g_cus_no) THEN
            CONSTRUCT ms_cons_where ON oea10,oea01, oea00, oea02, oea032, oea14
                                  FROM s_oea[1].oea10,s_oea[1].oea01,s_oea[1].oea00,s_oea[1].oea02,s_oea[1].oea032,s_oea[1].oea14 
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            
            END CONSTRUCT
            LET ms_cons_where = ms_cons_where CLIPPED ,
                                " AND oea03='",g_cus_no,"'",
                                " AND oeaconf = 'Y'"
            IF g_type = '1' THEN     #非三角貿易                               
               LET ms_cons_where = ms_cons_where CLIPPED," AND (oea901 = 'N' OR oea901 IS NULL)" 
            END IF                                                             
            IF g_type = '2' THEN     #三角貿易                                 
               LET ms_cons_where = ms_cons_where CLIPPED," AND oea901 = 'Y' " 
            END IF                          
          ELSE  CALL cl_opmsg('q')  
             CONSTRUCT ms_cons_where ON oea10, oea01, oea00, oea02, oea032, oea14
                                  FROM s_oea[1].oea10,s_oea[1].oea01,s_oea[1].oea00,s_oea[1].oea02,s_oea[1].oea032,s_oea[1].oea14
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
                   CONTINUE CONSTRUCT
             
             END CONSTRUCT
             LET ms_cons_where = ms_cons_where CLIPPED ," AND oeaconf = 'Y'"  # modify 95/12/12     
             #---modi in 01/03/12                                               
             IF g_type = '1' THEN     #非三角貿易                               
                LET ms_cons_where = ms_cons_where CLIPPED," AND (oea901 = 'N' OR oea901 IS NULL)" 
             END IF                                                             
             IF g_type = '2' THEN     #三角貿易                                 
                LET ms_cons_where = ms_cons_where CLIPPED," AND oea901 = 'Y' "
             END IF 
          END IF
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
     
         CALL oea12_qry_prep_result_set() 
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
     
      CALL oea12_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL oea12_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL oea12_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2003/09/22 by jack
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION oea12_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   l_oeb04  LIKE oeb_file.oeb04
   DEFINE   l_sql,l_buf LIKE type_file.chr1000	#No.FUN-680131 VARCHAR(500)
   DEFINE   l_oeb12  LIKE oeb_file.oeb12
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,   	#No.FUN-680131 VARCHAR(1)
         oea10  LIKE oea_file.oea10,
         oea01  LIKE oea_file.oea01,
         oea00  LIKE oea_file.oea00,
         oea02  LIKE oea_file.oea02,
         oea032 LIKE oea_file.oea032,
         oea14  LIKE oea_file.oea14,
         oeb04_1 LIKE type_file.chr1000,  #No.FUN-680131 VARCHAR(27)
         oeb04_2 LIKE type_file.chr1000   #No.FUN-680131 VARCHAR(70)
   END RECORD
   DEFINE   lr_str    STRING #TQC-7C0123
   DEFINE   l_i  LIKE type_file.num5 
   DEFINE   l_j  LIKE type_file.num5 
   DEFINE   l_k  LIKE type_file.num5 
 
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_oea12', 'oea_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = "SELECT 'N',oea10,oea01,oea00,oea02,oea032,oea14,'',''", 
                " FROM oea_file",
                " WHERE ",ms_cons_where,
                 #MOD-530311
#TQC-AB0025--------------mod------------------str--------------------------
#               "  AND oea01 IN (SELECT oeb01 FROM oeb_file ",
#               "                 WHERE oeb01 = oea01 ", 
#               "                   AND oeb12>(oeb24-oeb25)) ",
                "  AND oea01 IN (SELECT oeb01 FROM oeb_file LEFT OUTER JOIN oea_file ON oeb01 = oea01 ",
                "                 WHERE oeb12>(oeb24-oeb25)) ",
#TQC-AB0025--------------mod------------------end----------------------------
                "  AND oea08 = '",g_oga08,"' ",  #MOD-8B0108
                "  AND oea00 = '",g_oga00,"' "   #MOD-C20054
                 #MOD-530311(end)
   IF NOT mi_multi_sel THEN
      LET ls_where = "   AND oeaconf = 'Y' AND oea00!='0' "
   END IF
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY oea01"
 
#FUN-990069---begin 
   IF (NOT mi_multi_sel ) THEN
      CALL cl_parse_qry_sql( ls_sql, g_plant ) RETURNING ls_sql
   END IF     
#FUN-990069---end  
 
   DISPLAY "ls_sql=",ls_sql
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
 
      #FUN-4C0001 判斷是否已達選取上限  add by hongmf 20041201 
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
      #----
       LET l_sql = "SELECT oeb04,oeb12-oeb24+oeb25 FROM oeb_file",
                    " WHERE oeb01 = '",lr_qry.oea01,"'",
                    "  AND oeb12>(oeb24-oeb25) "
        PREPARE q_oeb_prepare FROM l_sql
        DECLARE oeb_curs CURSOR FOR q_oeb_prepare
        LET l_buf=''
        FOREACH oeb_curs INTO l_oeb04,l_oeb12
            #MOD-530311
           IF NOT cl_null(l_buf) THEN 
               LET l_buf= l_buf CLIPPED,','
           END IF
            #MOD-530311(end)
           LET l_buf = l_buf CLIPPED," ",l_oeb04 CLIPPED,
                       '(',l_oeb12 USING '<<<<<<',')'
        END FOREACH
 #----TQC-7C0123--------------begin--------------
        #LET lr_qry.oeb04_1=l_buf[1,27]
        #LET lr_qry.oeb04_2=l_buf[28,100]
        LET lr_str = l_buf                                                      
        LET l_k =lr_str.getlength()                                             
        LET l_i =lr_str.getIndexof(')',1)                                       
        LET l_j =lr_str.getIndexof(')',l_i+1)                                   
        LET l_j =lr_str.getIndexof(')',l_j+1)                                   
        LET l_j =lr_str.getIndexof(')',l_j+1)                                   
        LET l_j =lr_str.getIndexof(')',l_j+1)                                   
        IF  cl_null(l_j) or l_j=0 THEN LET l_j=l_k END IF                       
        IF  cl_null(l_i) or l_i=0 THEN                                          
            LET lr_qry.oeb04_1=''                                               
        ELSE                                                                    
            LET lr_qry.oeb04_1=l_buf[1,l_i]                                     
        END IF                                                                  
        IF l_i+2>=l_j THEN                                                      
           LET lr_qry.oeb04_2=''                                                
        ELSE                                                                    
           LET lr_qry.oeb04_2=l_buf[l_i+2,l_j]                                  
        END IF                                                                  
 #----TQC-7C0123--------------begin--------------
 
      #----
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2003/09/22 by jack
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION oea12_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_i             LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_j             LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
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
# Date & Author : 2003/09/22 by jack
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION oea12_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_oea.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_oea.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_oea.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL oea12_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_oea.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL oea12_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL oea12_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_oea.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL oea12_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL oea12_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                        #CHI-9C0048
            LET ms_ret1 = NULL       #CHI-9C0048
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
 
         LET li_continue = FALSE
     
         EXIT INPUT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      #No.FUN-660161 --begin--
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161 --end--
   
      #No.FUN-840023 --start--
      ON ACTION qry_string
         CALL cl_qry_string("detail")
      #No.FUN-840023 ---end---
 
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
# Date & Author : 2003/09/22 by jack
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION oea12_qry_reset_multi_sel(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_i             LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_j             LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry[li_i].check = ma_qry_tmp[li_j+1].check
      LET li_j = li_j + 1
   END FOR
END FUNCTION
 
##################################################
# Description  	: 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2003/09/22 by jack
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION oea12_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_oea.*
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
         CALL oea12_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
 
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      #No.FUN-660161 --begin--
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161 --end--
   
      #No.FUN-840023 --start--
      ON ACTION qry_string
         CALL cl_qry_string("detail")
      #No.FUN-840023 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description   : 重設查詢資料.
# Date & Author : 2003/09/22 by jack
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION oea12_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2003/09/22 by jack
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION oea12_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10  	#No.FUN-680131 INTEGER
 
 
   # 2004/06/03 by saki : GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].oea01 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].oea01 CLIPPED)
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].oea01 CLIPPED
   END IF
END FUNCTION
