# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_area_data.4gl
# Descriptions...: 提供取得 ERP 區域別資料服務
# Date & Author..: 2008/06/10 by kevin
# Memo...........:
# Modify.........: 新建立 #FUN-860037
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
#FUN-860037
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
DEFINE g_table     STRING
 
#[
# Description....: 提供取得 ERP 區域別資料服務(入口 function)
# Date & Author..: 2007/04/12 by Joe  #FUN-860037
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_area_data()
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 區域別編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_area_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序  
 
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 區域別編號
# Date & Author..: 2007/04/12 by Joe
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_area_data_process()
    DEFINE l_gea       RECORD LIKE gea_file.*
    DEFINE l_wc        STRING
    DEFINE l_node      om.DomNode
    DEFINE l_sql       STRING
 
 
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
   
    IF cl_null(l_wc) THEN
       LET l_wc = " 1=1" 
    END IF
    
    LET l_sql = "SELECT * FROM gea_file WHERE geaacti = 'Y' AND ",
                 l_wc," ORDER BY gea01 "
                 
    DECLARE gea_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    FOREACH gea_curs INTO l_gea.*
      
        LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_gea), "gea_file")   #加入此筆單檔資料至 Response 中
    END FOREACH
 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF    
END FUNCTION
