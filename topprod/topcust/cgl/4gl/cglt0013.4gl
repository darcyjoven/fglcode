# Prog. Version..: '5.25.04-11.09.15(00001)'     #
#
# Pattern name...: aglt0013.4gl
# Descriptions...: 沖銷作業-內部往來交易
# Date & Author..: #FUN-B50001 11/05/03 By zhangweib 

DATABASE ds

#GLOBALS "../../config/top.global"     #yangtt 130819
GLOBALS "../../../tiptop/config/top.global"  #yangtt 130819

DEFINE g_argv1  LIKE axi_file.axi00,  #帳套 
       g_argv2  LIKE axi_file.axi01   #单号
MAIN
    DEFINE p_row,p_col  LIKE type_file.num5   

   IF FGL_GETENV("FGLGUI") <> "0" THEN   
      OPTIONS                                #改變一些系統預設值
          INPUT NO WRAP   ,                  #輸入的方式: 不打轉
          FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序) 
   END IF
    DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CGL")) THEN
      EXIT PROGRAM
   END IF

   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818 

   LET p_row = 2 LET p_col = 3
   
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
      OPEN WINDOW t0013_w AT p_row,p_col WITH FORM "cgl/42f/cglt0013"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
      
      CALL cl_ui_init()
   END IF
   CALL t001('2','7',g_argv1,g_argv2) 

   IF g_bgjob='N' OR cl_null(g_bgjob) THEN #FUN-840012
      CLOSE WINDOW t0013_w                 #結束畫面
   END IF
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time

END MAIN
#FUN-B50001
