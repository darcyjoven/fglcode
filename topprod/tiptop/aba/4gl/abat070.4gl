# Prog. Version..: '5.30.06-13.04.22(00001)'     #
# PROG. VERSION..: '5.25.04-11.09.14(00000)'     #
#
# PATTERN NAME...: abat070
# DESCRIPTIONS...: ERP收貨條碼掃描作業
# DATE & AUTHOR..: No:DEV-D20003 2013/02/19 By Mandy
# Modify.........: No.DEV-D30025 2013/03/12 By Nina---GP5.3 追版:以上為GP5.25 的單號---

 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/barcode.global"

DEFINE p_row,p_col     LIKE type_file.num5    

MAIN
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
   WHENEVER ERROR CONTINUE
  
   IF (NOT cl_setup("ABA")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
       RETURNING g_time    

    LET p_row = 3 LET p_col = 14
    OPEN WINDOW t070_w AT p_row,p_col WITH FORM "aba/42f/sabat070"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_set_locale_frm_name("sabat070")    
    CALL cl_ui_init()
    CALL sabat070('abat070')
    CLOSE WINDOW t070_w                  #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
       RETURNING g_time    
END MAIN
#DEV-D20003--add
#DEV-D30025--add

