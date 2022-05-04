# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_currency_list.4gl
# Descriptions...: 提供取得 ERP 幣別代碼服務
# Date & Author..: 2007/02/14 by Echo
# Memo...........:
# Modify.........: 新建立 FUN-720021
# Modify.........: No.FUN-840004 08/06/17 By Echo 新架構的 Services 與舊架構必須進行區別，
#                                                 因此需調整舊 Services 的程式名稱
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-720021
#FUN-840004
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
#[
# Description....: 提供取得 ERP 幣別代碼服務(入口 function)
# Date & Author..: 2007/02/12 by Echo
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_getCurrencyList_g()
    DEFINE l_str  STRING,
           l_i    LIKE type_file.num10
 
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_initial()   # 服務初始化動作
    
    #--------------------------------------------------------------------------#
    # 檢查登入資訊                                                             #
    #--------------------------------------------------------------------------#
    IF NOT aws_ttsrv_checkSignIn(g_getCurrencyList_in.signIn) THEN    
       LET g_status.code = "aws-100"   #登入檢查錯誤
    END IF
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 幣別代碼                                                        #
    #--------------------------------------------------------------------------#
    CALL g_getCurrencyList_out.azi.clear()   #清空回覆參數的 ARRAY
    IF g_status.code = "0" THEN
       CALL aws_getCurrencyList_get()
    END IF
    
    LET g_getCurrencyList_out.status = aws_ttsrv_getStatus()
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 幣別代碼
# Date & Author..: 2007/02/06 by Echo
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_getCurrencyList_get()
    DEFINE l_i     LIKE type_file.num10,
           l_azi   RECORD 
                      azi01   LIKE azi_file.azi01,
                      azi02   LIKE azi_file.azi02
                   END RECORD
 
    
    DECLARE azi_cur CURSOR FOR SELECT azi01, azi02 FROM azi_file WHERE aziacti='Y' ORDER BY azi01
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    LET l_i = 1
    FOREACH azi_cur INTO l_azi.*
        LET g_getCurrencyList_out.azi[l_i].azi01 = l_azi.azi01 CLIPPED
        LET g_getCurrencyList_out.azi[l_i].azi02 = l_azi.azi02 CLIPPED
        LET l_i = l_i + 1
    END FOREACH
END FUNCTION
