# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_salereturn2_s1.4gl
# Descriptions...: 查詢某一年度內各月銷退金額
# Date & Author..: No.FUN-BA0095 2012/01/11 By baogc
# Input Parameter: p_year  年度
#                  p_loc   圖表位置
# Usage..........: CALL s_chart_salereturn2_s1(p_year,p_loc)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_salereturn2_s1(p_year,p_loc)
DEFINE p_year           LIKE type_file.num5
DEFINE p_loc            LIKE type_file.chr10
DEFINE l_chk_auth        STRING

   WHENEVER ERROR CONTINUE

   IF NOT s_chart_auth("s_chart_salereturn2_s1",g_user) THEN
      LET l_chk_auth=cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)
      RETURN 
   END IF

   #聯動至各月銷退金額4gl程式(s_chart_salereturn_s1)并傳參當前部門編號g_grup
   CALL s_chart_salereturn_s1(p_year,p_loc,g_grup)
END FUNCTION

#FUN-BA0095
