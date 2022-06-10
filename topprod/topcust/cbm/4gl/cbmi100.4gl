# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: cbmi100.4gl
# Descriptions...: 测试程序
# Date & Author..: 22/06/09 By darcy


DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

DEFINE g_argv1,g_argv2,g_argv3 STRING

MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730075
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("CBM")) THEN
       EXIT PROGRAM
    END IF
    
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)   

    CALL cws_json()

END MAIN
