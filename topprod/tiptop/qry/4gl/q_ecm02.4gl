# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Program name  : q_ecm02.4gl
# Program ver.  : 7.0
# Description   : 作業序類資料查詢+PQC量
# Date & Author : 2005/09/09 by yiting 
# Memo          : 
# Modify        :
# Modify........: No.FUN-660161 06/07/07 By cl  增加匯出Excel功能
# Modify........: No.FUN-680131 06/08/31 By Carrier 欄位型態用LIKE定義
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.FUN-880082 08/08/29 By tsai_yen 開窗全選功能
# Modify.........: No.TQC-970309 09/07/28 By lilingyu 點擊"重新查詢"按鈕,無法下精確查詢條件
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-990069 09/10/09 By baofei 修改GP5.2的相關設定 
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No:TQC-AC0366 10/12/27 By zhangll 取消ecm59逻辑
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         ecm03    LIKE ecm_file.ecm03,
         ecm04    LIKE ecm_file.ecm04, 
         ecm45    LIKE ecm_file.ecm45, 
         wipqty   LIKE ecm_file.ecm315,
         ecm53    LIKE ecm_file.ecm53,
         pqty     LIKE qcm_file.qcm091,   
         ecm54    LIKE ecm_file.ecm54,
         ecm55    LIKE ecm_file.ecm55,
         ecm56    LIKE ecm_file.ecm56
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         ecm03    LIKE ecm_file.ecm03,
         ecm04    LIKE ecm_file.ecm04, 
         ecm45    LIKE ecm_file.ecm45, 
         wipqty   LIKE ecm_file.ecm315,
         ecm53    LIKE ecm_file.ecm53, 
         pqty     LIKE qcm_file.qcm091,   
         ecm54    LIKE ecm_file.ecm54,
         ecm55    LIKE ecm_file.ecm55,
         ecm56    LIKE ecm_file.ecm56
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_default1      STRING     
DEFINE   ms_ret1          STRING     #回傳欄位的變數
DEFINE   ms_ret2          STRING     #回傳欄位的變數
DEFINE   g_key1           LIKE ecm_file.ecm01  
DEFINE   g_key2           LIKE ecm_file.ecm04  
DEFINE
          #l_ecm54          LIKE ecm_file.ecm54,     #-No.MOD-530442-------
         l_ecm59          LIKE ecm_file.ecm59,
         l_ecm291         LIKE ecm_file.ecm291,
         l_ecm301         LIKE ecm_file.ecm301,
         l_ecm302         LIKE ecm_file.ecm302,
         l_ecm303         LIKE ecm_file.ecm303,
         l_ecm311         LIKE ecm_file.ecm311,
         l_ecm312         LIKE ecm_file.ecm312,
         l_ecm313         LIKE ecm_file.ecm313,
         l_ecm314         LIKE ecm_file.ecm314,
         l_ecm316         LIKE ecm_file.ecm316,
         l_ecm321         LIKE ecm_file.ecm321,
         l_ecm322         LIKE ecm_file.ecm322
DEFINE   l_chr            LIKE type_file.chr1          #TQC-970309
   
FUNCTION q_ecm02(pi_multi_sel,pi_need_cons,ps_default1,ps_default2)
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    STRING  ,#預設回傳值(在取消時會回傳此類預設值).
            ps_default2    STRING   #預設回傳值(在取消時會回傳此類預設值).
 
   LET ms_default1 = ps_default2
   LET g_key1 = ps_default1
   LET g_key2 = ps_default2
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_ecm02" ATTRIBUTE(STYLE="create_qry") #No.FUN-660161
 
   CALL cl_ui_locale("q_ecm02")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko : 
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("ecm04", "red")
   END IF
 
   CALL ecm02_qry_sel()
 
   CLOSE WINDOW w_qry
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 #複選資料只能回傳一個欄位的組合字串.   
   ELSE
      RETURN ms_ret1,ms_ret2 #回傳值(也許有多個).
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2003/09/22 by Winny
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION ecm02_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	#No.FUN-680131 SMALLINT
            li_continue      LIKE type_file.num5      #是否繼續.	#No.FUN-680131 SMALLINT
   DEFINE   li_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
 
 
   LET mi_page_count = 100 #每頁顯現最大資料筆數.
   LET li_reconstruct = TRUE
   LET l_chr = 'N'                                   #TQC-970309
    
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      IF (li_reconstruct) THEN
         MESSAGE ""
         LET ms_cons_where = "1=1"
         
#TQC-970309 --begin--
      IF (li_continue) AND (li_reconstruct) AND (l_chr = 'Y') THEN 
         CALL ecm02_construct()   
      END IF  
#TQC-970309 --end-- 
     
         CALL ecm02_qry_prep_result_set() 
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
     
      CALL ecm02_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL ecm02_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL ecm02_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
#TQC-970309 --begin--
FUNCTION ecm02_construct()
  CLEAR FORM
  CALL ma_qry_tmp.clear()
  CONSTRUCT ms_cons_where ON ecm03,ecm04,ecm45,ecm53,ecm54,ecm55,ecm56
       FROM s_ecm[1].ecm03,s_ecm[1].ecm04,s_ecm[1].ecm45,s_ecm[1].ecm53,
            s_ecm[1].ecm54,s_ecm[1].ecm55,s_ecm[1].ecm56
      
     ON ACTION about         
        CALL cl_about()        
     
     ON ACTION help          
        CALL cl_show_help()  
     
     ON ACTION controlg      
        CALL cl_cmdask()      
     
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT 
  END CONSTRUCT
END FUNCTION 
#TQC-970309 --end--
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2003/09/22 by Winny
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION ecm02_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
            ecm03    LIKE ecm_file.ecm03,
            ecm04    LIKE ecm_file.ecm04, 
            ecm45    LIKE ecm_file.ecm45, 
            wipqty   LIKE ecm_file.ecm315,
            ecm53    LIKE ecm_file.ecm53, 
            pqty     LIKE qcm_file.qcm091,   
            ecm54    LIKE ecm_file.ecm54,  
            ecm55    LIKE ecm_file.ecm55,
            ecm56    LIKE ecm_file.ecm56
   END RECORD
 
 
    #Begin:FUN-980030
    LET l_filter_cond = cl_get_extra_cond_for_qry('q_ecm02', 'ecm_file')
    IF NOT cl_null(l_filter_cond) THEN
       LET ms_cons_where = ms_cons_where,l_filter_cond
    END IF
    #End:FUN-980030
    LET ls_sql =  "SELECT 'N',ecm03,ecm04,ecm45,' ',ecm53,'',ecm54,ecm55,ecm56,",  #-No.MOD-530442
                 "        ecm291,ecm301,ecm302,ecm311,ecm312,ecm313,", 
                 "        ecm314,ecm321,ecm322,ecm303,ecm316,ecm59 ",
                 "  FROM ecm_file",
                 " WHERE ",ms_cons_where
   IF NOT mi_multi_sel THEN
      LET ls_where = " AND ecm01='",g_key1,"'"
      IF NOT cl_null(g_key2) THEN
           LET ls_where = ls_where CLIPPED," AND ecm04='",g_key2,"'"
      END IF
   END IF
   LET ls_sql=ls_sql CLIPPED,ls_where CLIPPED," ORDER BY ecm03"
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
 
    FOREACH lcurs_qry INTO lr_qry.*,l_ecm291,l_ecm301,l_ecm302,  #--No.MOD-530442-
                          l_ecm311,l_ecm312,l_ecm313,l_ecm314,l_ecm321,
                          l_ecm322,l_ecm303,l_ecm316,l_ecm59
      #----------No.MOD-530442-------
     #IF l_ecm54='Y' THEN          # Check in='Y'
     IF lr_qry.ecm54='Y' THEN          # Check in='Y'
      #----------No.MOD-530442-------
        LET lr_qry.wipqty 
                          =  l_ecm291             #check in
                          - l_ecm311    #*l_ecm59     #良品轉出  #Mark No:TQC-AC0366
                          - l_ecm312    #*l_ecm59     #重工轉出  #Mark No:TQC-AC0366
                          - l_ecm313    #*l_ecm59     #當站報廢  #Mark No:TQC-AC0366
                          - l_ecm314    #*l_ecm59     #當站下線  #Mark No:TQC-AC0366
                          - l_ecm316    #*l_ecm59                #Mark No:TQC-AC0366
     ELSE
       LET lr_qry.wipqty 
                         =  l_ecm301             #良品轉入量
                         + l_ecm302             #重工轉入量
                         + l_ecm303 
                         - l_ecm311   #*l_ecm59     #良品轉出  #Mark No:TQC-AC0366
                         - l_ecm312   #*l_ecm59     #重工轉出  #Mark No:TQC-AC0366
                         - l_ecm313   #*l_ecm59     #當站報廢  #Mark No:TQC-AC0366
                         - l_ecm314   #*l_ecm59     #當站下線  #Mark No:TQC-AC0366
                         - l_ecm316   #*l_ecm59                #Mark No:TQC-AC0366
     END IF
     #以用工單+製程序抓取PQC合格數
      LET lr_qry.pqty = 0 
      SELECT SUM(qcm091) INTO lr_qry.pqty
        FROM qcm_file
       WHERE qcm02 = g_key1 
         AND qcm05 = lr_qry.ecm03
     
      #FUN-4C0001 判斷是否已達選取上限  add by hongmf 20041201 
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
 
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2003/09/22 by Winny
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION ecm02_qry_set_display_data(pi_start_index, pi_end_index)
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
# Date & Author : 2003/09/22 by Winny
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION ecm02_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_ecm.* 
   ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
   #ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_ecm.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL ecm02_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_ecm.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL ecm02_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL ecm02_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
         LET l_chr = 'Y'          #TQC-970309
              
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_ecm.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL ecm02_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL ecm02_qry_accept(pi_start_index+ARR_CURR()-1)
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
 
      #No.FUN-660161--begin
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161--end
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
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
# Date & Author : 2003/09/22 by Winny
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION ecm02_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Date & Author : 2003/09/22 by Winny
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION ecm02_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_ecm.*
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
         CALL ecm02_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
 
         LET li_continue = FALSE
      
         EXIT DISPLAY
 
      #No.FUN-660161--begin
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161--end
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
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
# Date & Author : 2003/09/22 by Winny
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION ecm02_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2003/09/22 by Winny
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION ecm02_qry_accept(pi_sel_index)
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
               CALL lsb_multi_sel.append(ma_qry[li_i].ecm04 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].ecm04 CLIPPED)
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].ecm04 CLIPPED
      LET ms_ret2 = ma_qry[pi_sel_index].ecm03 CLIPPED
   END IF
END FUNCTION
