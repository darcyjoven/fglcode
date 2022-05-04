# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_upsw
# Descriptions...: 詢問 "是否確認此張異動單據 (Y/N)? "
#                       "是否取消確認此張異動單據 (Y/N)? "
# Input parameter: p_row,p_col
#                  p_upsw	N:確認
#                        	Y:取消確認
# RETURN code....: 1 FOR TRUE  : 是
#                  0 FOR FALSE : 否
# Usage .........: if cl_upsw(p_row,p_col,p_upsw)
# Date & Author..: 90/10/07 By LYS
#        Modify..: 04/02/17 By saki
# Revise record..:
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_upsw(p_row,p_col,p_upsw)
   DEFINE   p_upsw           LIKE type_file.chr1,         #No.FUN-690005 VARCHAR(1),
            p_row,p_col      LIKE type_file.num5          #No.FUN-690005 SMALLINT
   DEFINE   ls_msg           LIKE ze_file.ze03            #No.FUN-690005 VARCHAR(100)
   DEFINE   li_result        LIKE type_file.num5          #No.FUN-690005 SMALLINT
   DEFINE   lc_title         LIKE ze_file.ze03            #No.FUN-690005 VARCHAR(50)
 
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF p_upsw = 'N' THEN
      SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'lib-014' AND ze02 = g_lang
   ELSE
      SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'lib-015' AND ze02 = g_lang
   END IF
   SELECT ze03 INTO lc_title FROM ze_file WHERE ze01 = 'lib-041' AND ze02 = g_lang
 
   MENU lc_title ATTRIBUTE (STYLE="dialog", COMMENT=ls_msg CLIPPED, IMAGE="question")
      ON ACTION yes
         LET li_result = TRUE
         EXIT MENU
      ON ACTION no
         EXIT MENU
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
   
   END MENU
 
   IF (INT_FLAG) THEN
      LET INT_FLAG = FALSE
      LET li_result = FALSE
   END IF
 
   RETURN li_result
 
END FUNCTION
