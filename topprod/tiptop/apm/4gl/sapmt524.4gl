# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: sapmt524.4gl
# Descriptions...: 採購單細項－其他資料維護
# Date & Author..: 92/11/22 By Apple
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/06 By Jackho 欄位類型修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pmn           RECORD LIKE pmn_file.*,
    g_pmm02         LIKE pmm_file.pmm02,
    g_pmm45         LIKE pmm_file.pmm45,
    g_wc,g_sql      string,                      #No.FUN-580092 HCN
    g_cmd           LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(100)
 
DEFINE 
    g_msg           LIKE ze_file.ze03            #No.FUN-680136 VARCHAR(72)

FUNCTION t524(p_pmn01)

DEFINE 
    p_pmn01         LIKE pmn_file.pmn01, 
    l_chr           LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)

    WHENEVER ERROR CONTINUE
 
    INITIALIZE g_pmn.* TO NULL

    OPEN WINDOW t524_w WITH FORM "apm/42f/apmt524" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("apmt524")
 
    SELECT * INTO  g_pmn.* FROM pmn_file WHERE pmn01 = p_pmn01
    IF SQLCA.sqlcode THEN  
#      CALL cl_err(g_pmn.pmn01,SQLCA.sqlcode,0)   #No.FUN-660129
       CALL cl_err3("sel","pmn_file",g_pmn.pmn01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
       RETURN 
    END IF
    CALL t524_show()
    CALL cl_getmsg('mfg6012',g_lang) RETURNING g_msg
    WHILE TRUE
            LET INT_FLAG = 0  ######add for prompt bug
      PROMPT g_msg CLIPPED FOR l_chr   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
#            CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      
      END PROMPT
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      EXIT WHILE 
    END WHILE
    CLOSE WINDOW t524_w
END FUNCTION
 
FUNCTION t524_show()
    SELECT pmm02,pmm45 INTO g_pmm02,g_pmm45 FROM pmm_file
                      WHERE pmm01 = g_pmn.pmn01
    DISPLAY BY NAME g_pmn.pmn40,g_pmn.pmn38,g_pmn.pmn11,g_pmn.pmn10,
                    g_pmn.pmn59,g_pmn.pmn60,g_pmn.pmn58,g_pmn.pmn45
        
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
