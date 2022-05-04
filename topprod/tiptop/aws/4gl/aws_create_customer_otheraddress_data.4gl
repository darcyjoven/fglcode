# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_customer_otheraddress_data.4gl
# Descriptions...: 提供建立客戶其他地址資料服務
# Date & Author..: 2009/04/10 by sabrina
# Memo...........:
# Modify.........: No:FUN-930139 10/08/13 By Lilan 追版(GP5.1==>GP5.2)
#
#}

DATABASE ds

#FUN-840004

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔


#[
# Description....: 提供建立客戶其他地址資料服務(入口 function)
# Date & Author..: 2009/04/10 by sabrina 
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_customer_otheraddress_data()
    
    
    WHENEVER ERROR CONTINUE
    
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 建立客戶其他地址資料                                                     #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_customer_otheraddress_data_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION


#[
# Description....: 依據傳入資訊新增一筆 ERP 客戶其他地址資料
# Date & Author..: 2009/04/10 by sabrina
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_customer_otheraddress_data_process()
    DEFINE l_i       LIKE type_file.num10
    DEFINE l_sql     STRING        
    DEFINE l_cnt1    LIKE type_file.num10,
           l_cnt2    LIKE type_file.num10,
           l_cnt3    LIKE type_file.num10
    DEFINE l_ocd01   LIKE ocd_file.ocd01
    DEFINE l_ocd02   LIKE ocd_file.ocd02
    DEFINE l_wc      STRING
    DEFINE l_node    om.DomNode
   
        
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的客戶其他地址                                      #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("ocd_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
    
    BEGIN WORK
    
    FOR l_i = 1 TO l_cnt1       
        LET l_node = aws_ttsrv_getMasterRecord(l_i, "ocd_file")         #目前處理單檔的 XML 節點
        
        LET l_ocd01 = aws_ttsrv_getRecordField(l_node, "ocd01")         #取得此筆單檔資料的欄位值
        LET l_ocd02 = aws_ttsrv_getRecordField(l_node, "ocd02")         #取得此筆單檔資料的欄位值

        IF cl_null(l_ocd01) OR cl_null(l_ocd02) THEN
           LET g_status.code = "-286"                                   #主鍵的欄位值不可為 NULL
           EXIT FOR
        END IF

        SELECT COUNT(*) INTO l_cnt2 FROM occ_file          #判斷此客戶是否存在客戶主檔中
         WHERE occ01 = l_ocd01

        IF l_cnt2 = '0' THEN
           LET g_status.code = "axm-183"                   #此客戶不存在客戶主檔
           EXIT FOR
        END IF

        #----------------------------------------------------------------------#
        # 判斷此資料是否已經建立, 若已建立則為 Update                          #
        #----------------------------------------------------------------------#
        SELECT COUNT(*) INTO l_cnt3 FROM ocd_file 
         WHERE ocd01 = l_ocd01
           AND ocd02 = l_ocd02

        IF l_cnt3 = 0 THEN
           LET l_sql = aws_ttsrv_getRecordSql(l_node, "ocd_file", "I", NULL)   #I 表示取得 INSERT SQL
        ELSE
           LET l_wc = " ocd01 = '", l_ocd01 CLIPPED, "' AND ocd02 = '", l_ocd02 CLIPPED, "'"         #UPDATE SQL 時的 WHERE condition
           LET l_sql = aws_ttsrv_getRecordSql(l_node, "ocd_file", "U", l_wc)   #U 表示取得 UPDATE SQL
        END IF
   
        #----------------------------------------------------------------------#
        # 執行 INSERT / UPDATE SQL                                             #
        #----------------------------------------------------------------------#
        display l_sql
        EXECUTE IMMEDIATE l_sql
        IF SQLCA.SQLCODE THEN
           LET g_status.code = "9052"      #回傳資料新增失敗的錯誤訊息
           LET g_status.sqlcode = SQLCA.SQLCODE
           EXIT FOR
        END IF
    END FOR
    
    #全部處理都成功才 COMMIT WORK
    IF g_status.code = "0" THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
END FUNCTION
#FUN-930139
