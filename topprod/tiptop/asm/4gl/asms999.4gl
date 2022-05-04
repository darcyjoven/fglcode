# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: asms999.4gl
# Descriptions...: 製造管理系統關閉作業
# Date & Author..: 93/09/01 By David
#                :
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-980008 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.CHI-960043 09/08/24 By dxfwo  本作業沒有呼叫cl_used(),當啟動aoos010做記錄時,則無法記錄本支作業的異動情況到p_used中
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
     DEFINE
        g_smi           RECORD LIKE smi_file.*,
        g_smj           RECORD LIKE smj_file.*,
        p_msg           LIKE oea_file.oea01, #No.FUN-690010   VARCHAR(16),
	g_tty           LIKE smi_file.smi05  #No.FUN-690010  VARCHAR(16)
 
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
MAIN
    OPTIONS
          INPUT NO WRAP
    DEFER INTERRUPT
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
    CALL asms999()
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION asms999()
    DEFINE
        l_str1      LIKE smi_file.smi06,#No.FUN-690010  VARCHAR(30),
        l_str2      LIKE smi_file.smi07,#No.FUN-690010  VARCHAR(30),
        l_str3      LIKE smi_file.smi08,#No.FUN-690010  VARCHAR(30),
        l_str4      LIKE smi_file.smi06 #No.FUN-690010 VARCHAR(30),
#       l_time        LIKE type_file.chr8          #No.FUN-6A0089
    DEFINE p_row,p_col      LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
 
   IF (NOT cl_user()) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASM")) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.CHI-960043
 
    LET p_row = 6 LET p_col = 35
    OPEN WINDOW asms999_w AT p_row,p_col
    WITH FORM "asm/42f/asms999"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF g_sma.sma01 = 'N' THEN
       CALL cl_getmsg('mfg9990',g_lang) RETURNING l_str1
       CALL cl_getmsg('mfg9991',g_lang) RETURNING l_str2
       DISPLAY l_str1 TO smi06
       DISPLAY l_str2 TO smi07
       CALL cl_anykey(' ')
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF
    CALL fgl_getenv('LOGTTY') RETURNING g_tty
	IF g_tty IS NULL THEN LET g_tty=' ' END IF
    SELECT COUNT(*) INTO g_cnt FROM smi_file
    IF g_cnt > 0 THEN
       CALL cl_getmsg('mfg9992',g_lang) RETURNING l_str1
       CALL cl_getmsg('mfg9993',g_lang) RETURNING l_str2
       CALL cl_getmsg('mfg9994',g_lang) RETURNING l_str3
       DISPLAY l_str1 TO smi06
       DISPLAY l_str2 TO smi07
       DISPLAY l_str3 TO smi08
       CALL cl_anykey(' ')
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
          EXIT PROGRAM
       END IF
       BEGIN WORK
       LET g_success ='Y'
       DECLARE s999_cur CURSOR FOR
       SELECT * FROM smi_file
       FOREACH s999_cur INTO g_smi.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach :',SQLCA.sqlcode,1)             
            LET g_success ='N'
            EXIT FOREACH
         END IF
         LET g_smj.smj01 = g_smi.smi01
         LET g_smj.smj02 = g_smi.smi02
         LET g_smj.smj03 = g_smi.smi03
         LET g_smj.smj04 = g_smi.smi04
         LET g_smj.smj05 = g_smi.smi05
         LET g_smj.smj06 = g_smi.smi06
         LET g_smj.smj07 = g_smi.smi07
         LET g_smj.smj08 = g_smi.smi08
         LET g_smj.smj09 = g_user
         LET g_smj.smj10 = 'asms999'
         LET g_smj.smj11 = TODAY
         LET g_smj.smj12 = TIME
         LET g_smj.smj13 = g_tty
         LET g_smj.smj14 = "** 系統不正常 **"
         LET g_smj.smj15 = "TIPTOP/MFG asms999『自動產生』"
         LET g_smj.smj16 = "  『系統管理者』需注意此狀況  "
         LET g_smj.smjplant = g_plant #FUN-980008 add
         LET g_smj.smjlegal = g_legal #FUN-980008 add
         INSERT INTO smj_file VALUES (g_smj.*)
         IF SQLCA.sqlcode THEN
#           CALL cl_err('Insert smj_file',SQLCA.sqlcode,1)   #No.FUN-660138
            CALL cl_err3("ins","smj_file",g_smj.smj01,g_smj.smj09,SQLCA.sqlcode,"","Insert smj_file",1) #No.FUN-660138
            LET g_success ='N'
            EXIT FOREACH
         END IF
       END FOREACH
       DELETE FROM smi_file
        WHERE 1 = 1
       IF SQLCA.sqlcode THEN
#         CALL cl_err('Delete :',SQLCA.sqlcode,1)   #No.FUN-660138
          CALL cl_err3("del","smi_file","","",SQLCA.sqlcode,"","Delete:",1) #No.FUN-660138
          LET g_success ='N'
       END IF
       IF g_success = 'Y' THEN
          COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF
    CALL asms999_i()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF
    LET g_success ='Y'
    BEGIN WORK
    LET g_smi.smi01 = g_user
    LET g_smi.smi02 = 'asms999'
    LET g_smi.smi03 = TODAY
    LET g_smi.smi04 = TIME
    LET g_smi.smi05 = g_tty
    LET g_smi.smiplant = g_plant #FUN-980008 add
    LET g_smi.smilegal = g_legal #FUN-980008 add
    INSERT INTO smi_file VALUES(g_smi.*)
    IF SQLCA.sqlcode THEN
#      CALL cl_err('Insert smi_file',SQLCA.sqlcode,1)   #No.FUN-660138
       CALL cl_err3("ins","smi_file",g_smi.smi01,g_smi.smi02,SQLCA.sqlcode,"","Insert smi_file",1) #No.FUN-660138
       LET g_success ='N'
    END IF
    UPDATE sma_file SET sma01 ='N'
     WHERE sma00='0'
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] =0 THEN
#      CALL cl_err('Update sma_file',SQLCA.sqlcode,1)   #No.FUN-660138
       CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","Update sma_file",1) #No.FUN-660138
       LET g_success ='N'
    END IF
    IF g_success = 'Y' THEN
       CALL cl_cmmsg(1) COMMIT WORK
    ELSE
       CALL cl_rbmsg(1) ROLLBACK WORK
    END IF
    CLOSE WINDOW asms999_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.CHI-960043
END FUNCTION
 
FUNCTION asms999_i()
 
   INPUT BY NAME g_smi.smi06 WITHOUT DEFAULTS
 
      AFTER INPUT
          IF INT_FLAG THEN
             RETURN
          END IF
          IF cl_null(g_smi.smi06) THEN
             CALL cl_err('','mfg9995',1)
             NEXT FIELD smi06
          END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
  END INPUT
 
END FUNCTION
#Patch....NO.TQC-610037 <001> #
