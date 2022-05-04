# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_axm_document.4gl
# Descriptions...: 提供取得 ERP 銷售系統單別服務
# Date & Author..: 2007/02/09 by Brendan
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
 
#------------------------------------------------------------------------------#
# 將 $QRY/4gl/q_oay.4gl 中關於最後輸出結果的 ARRAY 包含進來, 再額外封裝為此服  #
# 務所需的輸出值                                                               #
#------------------------------------------------------------------------------#
GLOBALS
    DEFINE ma_qry   DYNAMIC ARRAY OF RECORD
              check     LIKE type_file.chr1,
              oayslip   LIKE oay_file.oayslip,
              oaydesc   LIKE oay_file.oaydesc,
              oayauno   LIKE oay_file.oayauno,
              oaytype   LIKE oay_file.oaytype,
              oay11     LIKE oay_file.oay11
           END RECORD
END GLOBALS
 
#[
# Description....: 提供取得 ERP 銷售系統單別服務(入口 function)
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_getAXMDocument_g()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_initial()   # 服務初始化動作
    
    #--------------------------------------------------------------------------#
    # 檢查登入資訊                                                             #
    #--------------------------------------------------------------------------#
    IF NOT aws_ttsrv_checkSignIn(g_getAXMDocument_in.signIn) THEN    
       LET g_status.code = "aws-100"   #登入檢查錯誤
    END IF
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 銷售系統單別                                                    #
    #--------------------------------------------------------------------------#
    CALL g_getAXMDocument_out.oay.clear()   #清空回覆參數的 ARRAY
    IF g_status.code = "0" THEN
       CALL aws_getAXMDocument_get()
    END IF
    
    LET g_getAXMDocument_out.status = aws_ttsrv_getStatus()
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 銷售系統單別
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_getAXMDocument_get()
    DEFINE l_i   LIKE type_file.num10
    
    #--------------------------------------------------------------------------#
    # 呼叫 $QRY/4gl/q_oay.4gl 單別查詢 function                                #
    # 原 q_oay.4gl 應需做調整以能被正確以服務型態存取                          #
    #--------------------------------------------------------------------------#
 
    #最大動態開窗查詢筆數 
    SELECT aza38 INTO g_aza.aza38 FROM aza_file WHERE aza01='0'
 
    CALL q_oay(FALSE, FALSE, '', g_getAXMDocument_in.oaytype, g_getAXMDocument_in.oaysys)
 
    #--------------------------------------------------------------------------#
    # 重新封裝查詢陣列結果為最後輸出陣列形式                                   #
    #--------------------------------------------------------------------------#
    FOR l_i = 1 TO ma_qry.getLength()
        LET g_getAXMDocument_out.oay[l_i].oayslip = ma_qry[l_i].oayslip CLIPPED
        LET g_getAXMDocument_out.oay[l_i].oaydesc = ma_qry[l_i].oaydesc CLIPPED
    END FOR
END FUNCTION
