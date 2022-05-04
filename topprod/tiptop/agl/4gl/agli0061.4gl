# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: agli0061.4gl 
# Descriptions...: 股東權益期初導入/餘額查詢維護(總帳)作業
# Date & Author..: 11/06/29 By lixiang (FUN-B60144)
 
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE p_row,p_col    LIKE type_file.num5    

MAIN
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   CALL i006('2')      
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#FUN-B60144--
