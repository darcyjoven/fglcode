# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: cws_create_finish_work.4gl
# Descriptions...: 创建开工数据
# Date & Author..: 16/06/06 By guanyao
#  Modify  ......: 新增报工精简  完工扫描后自动报工   tianry  161128


DATABASE ds
 
#No.FUN-B10004
 
GLOBALS "../../../tiptop/config/top.global"
 
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
DEFINE g_cnt    LIKE type_file.num5
    DEFINE g_tc_shb      RECORD LIKE tc_shb_file.*
    DEFINE l_return   RECORD 
           code       LIKE type_file.chr10,
           msg        LIKE type_file.chr100
    END RECORD
    DEFINE g_sql                 LIKE type_file.chr1000
    DEFINE g_i       LIKE type_file.chr1  #add by guanyao160907
    DEFINE g_tc_shb03  LIKE tc_shb_file.tc_shb03,
           g_tc_shb08  LIKE tc_shb_file.tc_shb08,
           g_tc_shb02  LIKE tc_shb_file.tc_shb02,
           g_tc_shb12  LIKE tc_shb_file.tc_shb12
    DEFINE g_sum           LIKE type_file.num10
    DEFINE  g_tot_success   LIKE type_file.chr1
    DEFINE g_rec_b               LIKE type_file.num5
    DEFINE g_wc                  LIKE type_file.chr1000
    DEFINE g_shb32                 LIKE shb_file.shb32
    DEFINE   g_shb2        DYNAMIC ARRAY OF RECORD
         check1        LIKE type_file.chr1,
         shb01         LIKE shb_file.shb01,
         shb16         LIKE shb_file.shb16,
         shb05         LIKE shb_file.shb05,
         shb04         LIKE shb_file.shb04,
         gen02         LIKE gen_file.gen02,
         shb02         LIKE shb_file.shb02,
         shb03         LIKE shb_file.shb03,
         shb081        LIKE shb_file.shb081,
         shb082        LIKE shb_file.shb082,
         shb06         LIKE shb_file.shb06,
         shb10         LIKE shb_file.shb10,
         ima02         LIKE ima_file.ima02,
         ima021        LIKE ima_file.ima021,
         shb111        LIKE shb_file.shb111
                       END RECORD 
#[
# Description....: 提供建立开工資料的服務(入口 function)
# Date & Author..: No.FUN-B10004 16/06/06 By guanyao
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION cws_create_finish_work()
 
   WHENEVER ERROR CONTINUE
 
   CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
 
   #--------------------------------------------------------------------------#
   # 新增订單資料                                                       #
   #--------------------------------------------------------------------------#
   IF g_status.code = "0" THEN
      CALL cws_create_finish_work_process()
   END IF
 
   CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
 
END FUNCTION
 
#[
# Description....: 开工数据
# Date & Author..: 16/06/06 By guanyao
# Parameter......: 
# Return.........: 
# Memo...........:
# Modify.........:
#
#]
FUNCTION cws_create_finish_work_process()
    DEFINE l_cnt      LIKE type_file.num10
    DEFINE l_node1    om.DomNode
    DEFINE l_tc_shb01   LIKE tc_shb_file.tc_shb01
    DEFINE l_tc_shb03   LIKE tc_shb_file.tc_shb03
    DEFINE l_y       LIKE type_file.chr20 
    DEFINE l_m       LIKE type_file.chr20
    DEFINE l_d       LIKE type_file.chr20
    DEFINE l_str       LIKE type_file.chr20
    DEFINE l_tmp       LIKE type_file.chr20
    DEFINE l_tc_shb12_2    LIKE tc_shb_file.tc_shb12
    DEFINE l_tc_shb12_1    LIKE tc_shb_file.tc_shb12
    DEFINE l_tc_shb06      LIKE tc_shb_file.tc_shb06
    DEFINE l_tc_shb11      LIKE tc_shb_file.tc_shb11
    DEFINE l_tc_shb12      LIKE tc_shb_file.tc_shb12
    DEFINE lst_token base.StringTokenizer     
    DEFINE p_tok1    LIKE type_file.chr1000
    DEFINE l_x        LIKE type_file.num5
    DEFINE l_n        LIKE type_file.num5
    DEFINE l_err      LIKE type_file.chr1
    #str---add by guanyao160831 
    DEFINE l_tc_shc12_x  LIKE tc_shc_file.tc_shc12
    DEFINE l_tc_shc12_y  LIKE tc_shc_file.tc_shc12
    DEFINE l_tc_shb02    LIKE tc_shb_file.tc_shb02
    DEFINE l_sql         STRING 
    #end---add by guanyao160831
    #str---add by guanyao160904
    DEFINE l_tc_shb12_a  LIKE tc_shc_file.tc_shc12
    DEFINE l_tc_shb12_b  LIKE tc_shc_file.tc_shc12
    DEFINE l_tc_shb12_c  LIKE tc_shc_file.tc_shc12
    #end---add by guanyao160904
    DEFINE l_sfbud05     LIKE sfb_file.sfbud05
    DEFINE l_cmd       STRING
    DEFINE  l_sfbud11   LIKE sfb_file.sfbud11 
    DEFINE  l_ta_sgm06     LIKE sgm_file.ta_sgm06    #tianry add 161219
    DEFINE p_tc_shc    RECORD LIKE tc_shc_file.*
    DEFINE l_tttt       LIKE oga_file.oga01
    DEFINE l_sgm03    LIKE sgm_file.sgm03,
           l_sgm04    LIKE sgm_file.sgm04,
           l_ta_ecd06  LIKE ecd_file.ta_ecd06
    DEFINE l_sfbud12   LIKE sfb_file.sfbud12
    DEFINE  l_success   LIKE type_file.chr1,
            l_ecd07     LIKE ecd_file.ecd07
    DEFINE  p_tc_shb    RECORD LIKE tc_shb_file.*
    DEFINE l_ta_ecd04   LIKE ecd_file.ta_ecd04
    DEFINE g_ta_ecd04   LIKE ecd_file.ta_ecd04

    DEFINE l_tc_shc    RECORD LIKE tc_shc_file.*,
           l_tc_shc1    RECORD LIKE tc_shc_file.*,
           l_tc_shb     RECORD LIKE tc_shb_file.*,
           l_tc_shb1    RECORD LIKE tc_shb_file.*

    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的订單資料                                    #
    #--------------------------------------------------------------------------#

    LET l_tc_shb01 = aws_ttsrv_getParameter("tc_shb01")
    IF cl_null(l_tc_shb01) THEN 
       LET g_status.code = '-1'
       LET g_status.description = '没有资料性质'
       LET l_return.code="-1"
       LET l_return.msg = "完工信息录入失败"
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       RETURN 
    ELSE 
       IF l_tc_shb01<>'2' THEN 
          LET g_status.code = '-1'
          LET g_status.description = '资料类比不是完工类别'
          LET l_return.code="-1"
          LET l_return.msg = "完工信息录入失败"
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          RETURN
       END IF 
    END IF 
    LET l_tc_shb03 = aws_ttsrv_getParameter("tc_shb03")
    IF cl_null(l_tc_shb03) THEN
       LET g_status.code = '-1'
       LET g_status.description = '没有报工信息'
       LET l_return.code="-1"
       LET l_return.msg = "完工信息录入失败"
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       RETURN 
    END IF
    LET l_tc_shb06 = aws_ttsrv_getParameter("tc_shb06")  #mark by guanyao160620
    IF cl_null(l_tc_shb06) THEN  #mark by guanyao160620
    #LET g_tc_shb.tc_shb08 = aws_ttsrv_getParameter("tc_shb06")  #add by guanyao160620
    #IF cl_null(g_tc_shb.tc_shb08) THEN   #add by guanyao160620
       LET g_status.code = '-1'
       LET g_status.description = '没有作业序号'
       LET l_return.code="-1"
       LET l_return.msg = "完工信息录入失败"
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       RETURN
    ELSE 
       #str----add by guanyao160620
       #SELECT sgm03 INTO l_tc_shb06 FROM sgm_file WHERE sgm01 = l_tc_shb03 AND sgm04 = g_tc_shb.tc_shb08
       #IF cl_null(l_tc_shb06) THEN 
       #   LET g_status.code = '-1'
       #  LET g_status.description = '没有工艺序号'
       #   LET l_return.code="-1"
       #   LET l_return.msg = "扫描信息录入失败"
       #   CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       #   RETURN
       #END IF 
       #end----add by guanyao160620
    END IF 
    LET l_tc_shb11 = aws_ttsrv_getParameter("tc_shb11")
    IF cl_null(l_tc_shb11) THEN 
       LET g_status.code = '-1'
       LET g_status.description = '没有员工编号'
       LET l_return.code="-1"
       LET l_return.msg = "完工信息录入失败"
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       RETURN 
    END IF 
    SELECT SUM(tc_shb12) INTO l_tc_shb12 
      FROM tc_shb_file 
     WHERE tc_shb03 = l_tc_shb03 
       AND tc_shb06 = l_tc_shb06
       AND tc_shb11 = l_tc_shb11
       AND tc_shb01 = '1'
    IF cl_null(l_tc_shb12) OR l_tc_shb12 = 0 THEN 
       LET g_status.code = '-1'
       LET g_status.description = '没有开工资料'
       LET l_return.code="-1"
       LET l_return.msg = "完工信息录入失败"
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       RETURN
    END IF 

    INITIALIZE g_tc_shb.* TO NULL

       LET g_tc_shb.tc_shb01 = l_tc_shb01
       LET g_tc_shb.tc_shb03 = l_tc_shb03
       LET g_tc_shb.tc_shb06 = l_tc_shb06
       LET g_tc_shb.tc_shb11 = l_tc_shb11
       LET g_tc_shb.tc_shb12 = aws_ttsrv_getParameter("tc_shb12")
       LET g_tc_shb.tc_shb121 = aws_ttsrv_getParameter("tc_shb121")
       LET g_tc_shb.tc_shb122 = aws_ttsrv_getParameter("tc_shb122")
       LET g_tc_shb.tc_shb13 = aws_ttsrv_getParameter("tc_shb13")
       LET g_tc_shb.tc_shbud01 = aws_ttsrv_getParameter("tc_shbud01")
       #str----add by guanyao160617
       LET g_tc_shb.tc_shbud07 = aws_ttsrv_getParameter("tc_shbud07")
       LET g_tc_shb.tc_shbud08 = aws_ttsrv_getParameter("tc_shbud08")
       LET g_tc_shb.tc_shbud09 = aws_ttsrv_getParameter("pnl")   #add by guanyao160728
       IF cl_null(g_tc_shb.tc_shbud07)  THEN 
          LET g_status.code = '-1'
          LET g_status.description = '机器数不能为空'
          LET l_return.code="-1"
          LET l_return.msg = "完工信息录入失败"
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          RETURN
       END IF 
       IF cl_null(g_tc_shb.tc_shbud08)  THEN 
          LET g_status.code = '-1'
          LET g_status.description = '人数不能为空'
          LET l_return.code="-1"
          LET l_return.msg = "完工信息录入失败"
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          RETURN
       END IF 
       IF cl_null(g_tc_shb.tc_shbud09)  THEN 
          LET g_status.code = '-1'
          LET g_status.description = 'pnl量不能为空'
          LET l_return.code="-1"
          LET l_return.msg = "完工信息录入失败"
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          RETURN
       END IF
       #str----add by guanyao160727#机器或者人工可以一个为空
       IF (g_tc_shb.tc_shbud07+g_tc_shb.tc_shbud08) <= 0 THEN 
          LET g_status.code = '-1'
          LET g_status.description = '机器和人工总数不能为空'
          LET l_return.code="-1"
          LET l_return.msg = "完工信息录入失败"
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          RETURN
       END IF 
       #end----add by guanyao160727
       #end----add by guanyao160617

       #单据编号
       LET l_y =YEAR(g_today)
       LET l_y = l_y[3,4] USING '&&' 
       LET l_m =MONTH(g_today)
       LET l_m = l_m USING '&&' 
       #str---add by guanyao160806
       LET l_d = DAY(g_today)
       LET l_d = l_d USING '&&'
       #end---add by guanyao160806
       #tianry add 170111  单别随即抓取
       
       LET l_sql="select bg02  from bg_file  sample(1) where  rownum=1 and bg01=3 "
       PREPARE ss_ee_pre FROM l_sql
       DECLARE ss_ee_cur cursor for ss_ee_pre
       OPEN ss_ee_cur 
       FETCH ss_ee_cur  INTO l_str
       CLOSE ss_ee_cur
       
      
       
       LET l_str=l_str CLIPPED,l_y clipped,l_m CLIPPED,l_d CLIPPED
       SELECT max(substr(tc_shb02,12,20)) INTO l_tmp FROM tc_shb_file
        WHERE substr(tc_shb02,1,11)=l_str
       IF cl_null(l_tmp) THEN 
          LET l_tmp = '000000001' 
       ELSE 
          LET l_tmp = l_tmp + 1
          LET l_tmp = l_tmp USING '&&&&&&&&&'     
       END IF 
       LET g_tc_shb.tc_shb02 = l_str clipped,l_tmp
       IF cl_null(g_tc_shb.tc_shb02) THEN 
           LET g_status.code = '-1'
           LET g_status.description = '没有单据编号'
           LET l_return.code="-1"
           LET l_return.msg = "完工信息录入失败"
           CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
           RETURN 
       END IF 

       #数量的判断，同一个人，同一个工艺，同一个lot单必须先完工才能继续生成一笔数据
       IF g_tc_shb.tc_shb01 = '2' THEN 
          SELECT SUM(tc_shb12+tc_shb121+tc_shb122) INTO l_tc_shb12_2 FROM tc_shb_file 
           WHERE tc_shb03= g_tc_shb.tc_shb03 
             AND tc_shb06= g_tc_shb.tc_shb06
             AND tc_shb11= g_tc_shb.tc_shb11
             AND tc_shb01 = '2'
          IF cl_null(l_tc_shb12_2) THEN 
             LET l_tc_shb12_2 = 0
          END IF
          #IF g_tc_shb.tc_shb12-g_tc_shb.tc_shb121-g_tc_shb.tc_shb122 < = 0 THEN 
          #   LET g_status.code = '-1'
          #   LET g_status.description = '完工数量不能小于等于0'
          #   LET l_return.code="-1"
          #   LET l_return.msg = "完工信息录入失败"
          #   CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          #   RETURN 
          #END IF  
          IF (l_tc_shb12_2+g_tc_shb.tc_shb12+g_tc_shb.tc_shb121+g_tc_shb.tc_shb122)>l_tc_shb12 THEN
             LET g_status.code = '-1'
             LET g_status.description = '完工数量不能大于开工数量'
             LET l_return.code="-1"
             LET l_return.msg = "完工信息录入失败"
             CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
             RETURN 
          END IF 
          IF g_tc_shb.tc_shb12 > l_tc_shb12 OR g_tc_shb.tc_shb121 > l_tc_shb12 OR g_tc_shb.tc_shb122> l_tc_shb12 THEN 
             LET g_status.code = '-1'
             LET g_status.description = '完工数量大于开工数量'
             LET l_return.code="-1"
             LET l_return.msg = "完工信息录入失败"
             CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
             RETURN
          END IF 
       END IF 

        #人员检核
       SELECT COUNT(*) INTO l_cnt FROM gen_file
        WHERE gen01=g_tc_shb.tc_shb11
          AND genacti = 'Y'
       IF l_cnt = 0 THEN
          LET g_status.code = '-1'
          LET g_status.description = '人员资料错误'
          LET l_return.code="-1"
          LET l_return.msg = "完工信息录入失败"
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          RETURN 
       END IF

       #班别检核
       SELECT COUNT(*) INTO l_cnt FROM ecg_file 
        WHERE ecg01 = g_tc_shb.tc_shb13
          AND ecgacti = 'Y'
       IF l_cnt = 0 THEN
          LET g_status.code = '-1'
          LET g_status.description = '班别有错误'
          LET l_return.code="-1"
          LET l_return.msg = "完工信息录入失败"
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          RETURN 
       END IF

       #检查备注
       IF NOT cl_null(g_tc_shb.tc_shbud01) THEN 
          SELECT instr(g_tc_shb.tc_shbud01,'|') INTO l_n FROM dual
          IF l_n > 0 THEN 
             LET lst_token = base.StringTokenizer.create(g_tc_shb.tc_shbud01,"|")
             LET l_n  = 1
             WHILE lst_token.hasMoreTokens()
                LET p_tok1 = lst_token.nextToken()
                SELECT COUNT(*) INTO l_x FROM qce_file WHERE qce01 = p_tok1 
                IF l_x = 0 OR cl_null(l_x) THEN 
                   LET l_err = 'N'
                   EXIT WHILE 
                END IF 
             END WHILE 
             IF l_err = 'N' THEN 
                LET g_status.code = '-1'
                LET g_status.description = '备注信息有错误'
                LET l_return.code="-1"
                LET l_return.msg = "完工信息录入失败"
                CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                RETURN
             END IF 
          ELSE 
            #SELECT COUNT(*) INTO l_n FROM qce_file WHERE qce01 = l_barcode 
             SELECT COUNT(*) INTO l_n FROM qce_file WHERE qce01 = g_tc_shb.tc_shbud01
             IF l_n = 0 OR cl_null(l_n) THEN 
                LET g_status.code = '-1'
                LET g_status.description = '备注信息有错误'
                LET l_return.code="-1"
                LET l_return.msg = "完工信息录入失败"
                CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                RETURN
             END IF 
          END IF 
       END IF 

      # SELECT shm012,shm05,shm06,ecu03 
      #   INTO g_tc_shb.tc_shb04,g_tc_shb.tc_shb05,g_tc_shb.tc_shb07,g_tc_shb.tc_shb08
      #   FROM shm_file LEFT JOIN ecu_file ON ecu01= shm05 AND ecu02 = shm06
      #  WHERE shm01 = g_tc_shb.tc_shb03 
       #str----mark by guanyao160617 
       #SELECT sgm52,sgm58 
       #  INTO g_tc_shb.tc_shb10,g_tc_shb.tc_shb16 
       #  FROM sgm_file WHERE sgm01 = g_tc_shb.tc_shb03 AND sgm03 = g_tc_shb.tc_shb06
       #SELECT tc_shc09 INTO g_tc_shb.tc_shb09 FROM tc_shc_file 
       #end----mark by guanyao160617
       #str----add by guanyao160831
       LET l_sql = "SELECT tc_shb12,tc_shb02 FROM tc_shb_file WHERE tc_shb03 = '",g_tc_shb.tc_shb03,"'",
                   "   AND tc_shb06 = '",g_tc_shb.tc_shb06,"'",
                   "   AND tc_shb11 = '",g_tc_shb.tc_shb11,"'", 
                   "   AND tc_shb01 = '1'"
       PREPARE l_pre221 FROM l_sql
       DECLARE l_cur221 CURSOR FOR l_pre221
       FOREACH l_cur221 INTO l_tc_shc12_x,l_tc_shb02
          SELECT SUM(tc_shb12+tc_shb121+tc_shb122) INTO l_tc_shc12_y FROM tc_shb_file WHERE tc_shbud02 = l_tc_shb02
          #str---add by guanyao160901
          IF cl_null(l_tc_shc12_y) THEN 
             LET l_tc_shc12_y= 0 
          END IF 
          #end---add by guanyao160901
          IF l_tc_shc12_y<l_tc_shc12_x THEN 
             LET g_tc_shb.tc_shbud02 = l_tc_shb02
          END IF 
       END FOREACH 
       #end----add by guanyao160831
       SELECT tc_shb04,tc_shb05,tc_shb07,tc_shb08,tc_shb09,tc_shb10,tc_shb16 
         INTO g_tc_shb.tc_shb04,g_tc_shb.tc_shb05,g_tc_shb.tc_shb07,g_tc_shb.tc_shb08,  #add by guanyao160617
              g_tc_shb.tc_shb09,g_tc_shb.tc_shb10,g_tc_shb.tc_shb16 FROM tc_shb_file  #add by guanyao160617
        WHERE tc_shb03 = g_tc_shb.tc_shb03
          AND tc_shb06 = g_tc_shb.tc_shb06 
          AND tc_shb01 = '1'

    
       LET g_tc_shb.tc_shb14 = g_today
       LET g_tc_shb.tc_shb15 = TIME 
       #CALL aws_ttsrv_setRecordField_record(l_node1,base.Typeinfo.create(g_tc_shb))

       #str------add by guanyao160903
       SELECT sfbud05 INTO l_sfbud05 FROM sfb_file WHERE sfb01 = g_tc_shb.tc_shb04
       IF cl_null(l_sfbud05) THEN LET l_sfbud05 = 'N' END IF
       #add by donghy 考虑一刀切的工单 160907
       IF g_sma.smaud02 = 'Y' AND l_sfbud05 = 'N' THEN 
          SELECT SUM(tc_shb12+tc_shb121+tc_shb122) INTO l_tc_shb12_a 
            FROM tc_shb_file 
           WHERE tc_shb03 = g_tc_shb.tc_shb03
             AND tc_shb06 = g_tc_shb.tc_shb06
             AND tc_shb01 = '2'
          SELECT SUM(tc_shc12) INTO l_tc_shb12_b 
            FROM tc_shc_file
           WHERE tc_shc03 = g_tc_shb.tc_shb03
             AND tc_shc06 = g_tc_shb.tc_shb06
             AND tc_shc01 = '1'
          IF cl_null(l_tc_shb12_a) THEN 
             LET l_tc_shb12_a = 0
          END IF 
          IF cl_null(l_tc_shb12_b) THEN 
             LET l_tc_shb12_b = 0
          END IF 
          LET l_tc_shb12_c = l_tc_shb12_b - l_tc_shb12_a
          IF l_tc_shb12_c >0 THEN 
             IF  l_tc_shb12_c >(g_tc_shb.tc_shb12+g_tc_shb.tc_shb121+g_tc_shb.tc_shb122) THEN 
                LET l_tc_shb12_c = g_tc_shb.tc_shb12+g_tc_shb.tc_shb121+g_tc_shb.tc_shb122
             END IF 
             SELECT COUNT(*) INTO l_x FROM sfa_file,sfb_file 
              WHERE sfb01 = g_tc_shb.tc_shb04 
                AND sfb01 = sfa01 
                AND sfa11 = 'E' 
                AND sfa08 = g_tc_shb.tc_shb08
             IF l_x >0 THEN 
                CALL cws_create_finish_work_ins_sfp(g_tc_shb.tc_shb02,g_tc_shb.tc_shb04,g_tc_shb.tc_shb08,g_tc_shb.tc_shb09,l_tc_shb12_c)
             END IF 
          END IF 
          IF g_success = 'N' THEN 
             RETURN 
          END IF 
       END IF 
       #end------add by guanyao160903
 
       #----------------------------------------------------------------------#
       # 執行單頭 INSERT SQL                                                  #
       #----------------------------------------------------------------------#
       INSERT INTO tc_shb_file VALUES(g_tc_shb.*)
       IF SQLCA.SQLCODE THEN
          LET g_status.code = SQLCA.SQLCODE
          LET g_status.sqlcode = SQLCA.SQLCODE
          LET l_return.code="-1"
          LET l_return.msg = "完工信息录入失败"
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          RETURN 
       ELSE 
                    


            #产生当站报工
          LET g_tc_shb03=g_tc_shb.tc_shb03   #g_argv1
          LET g_tc_shb08=g_tc_shb.tc_shb08    #g_argv2
          LET g_tc_shb02=g_tc_shb.tc_shb02     #g_argv3
          LET g_tc_shb12=g_tc_shb.tc_shb12      #g_argv4  
          CALL p740_try()

      INITIALIZE l_tc_shc.* TO NULL
      INITIALIZE l_tc_shc1.* TO NULL
      INITIALIZE l_tc_shb.* TO NULL
      INITIALIZE l_tc_shb1.* TO NULL
      SELECT sfbud11 INTO l_sfbud11 FROM sfb_file WHERE sfb01=g_tc_shb.tc_shb04
      IF cl_null(l_sfbud11) THEN  #属于精简报工的工单 
         SELECT ta_ecd04 INTO g_ta_ecd04 FROM ecd_file WHERE ecd01=g_tc_shb.tc_shb08  #记录本站 是否只有开工完工 
         DECLARE sel_tc_shc_cc_cur CURSOR FOR   #完工产生
         SELECT  sgm03,sgm04,ta_sgm06,ecd07 from sgm_file,ecd_file WHERE sgm01=g_tc_shb.tc_shb03 AND sgm03>g_tc_shb.tc_shb06
         AND ecd01=sgm04  ORDER BY sgm03
         FOREACH sel_tc_shc_cc_cur  INTO l_sgm03,l_sgm04,l_ta_sgm06,l_ecd07
           IF l_ta_sgm06='Y' THEN
              EXIT FOREACH
           END IF 
           SELECT ta_ecd04 INTO l_ta_ecd04 FROM ta_ecd_file WHERE ecd01=l_sgm04  #判断下一站是否只有开工完工
           IF g_ta_ecd04='Y' THEN  #没有扫入扫出的 情况  此站的完工产生下一站的 扫入 开工 扫出 完工信息
              SELECT COUNT(*) INTO l_cnt FROM tc_shc_file WHERE tc_shc03=g_tc_shb.tc_shb03 AND tc_shc06=l_sgm03
              AND tc_shc01='1'    #下一站是否存在 扫入数据
              IF l_cnt=0 THEN
                # SELECT ta_ecd04 INTO l_ta_ecd04 FROM ta_ecd_file WHERE ecd01=l_sgm04  #判断下一站是否只有开工完工
                 IF l_ta_ecd04='N' OR cl_null(l_ta_ecd04) THEN  #下一站不存在开工完工的 情况
                    SELECT * INTO l_tc_shc.* FROM tc_shc_file WHERE tc_shc03=g_tc_shb.tc_shb03 AND tc_shc06=g_tc_shb.tc_shb06
                    AND tc_shc01='1'   AND ROWNUM=1   #用上一站的扫入资料赋初始值
                    IF cl_null(l_tc_shc.tc_shc02) THEN
                       LET g_status.code = SQLCA.SQLCODE
                       LET g_status.sqlcode = SQLCA.SQLCODE
                       LET l_return.code="-1"
                       LET l_return.msg = "下一站扫入信息抓取失败"
                       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                       EXIT FOREACH 
                    END IF
                    #下一站扫入资料  #没有的时候新增
                    LET l_sql=" select bg02  from bg_file  sample(1) where  rownum=1 and bg01=1 "
                    PREPARE  cre_saoru_pre FROM l_sql
                    DECLARE  cre_saoru_cur CURSOR FOR cre_saoru_pre
                    OPEN cre_saoru_cur
                    FETCH cre_saoru_cur INTO l_str
                    CLOSE cre_saoru_cur
                          
                    LET l_str=l_str CLIPPED,l_y clipped,l_m CLIPPED,l_d CLIPPED
                    SELECT max(substr(tc_shc02,12,20)) INTO l_tmp FROM tc_shc_file
                    WHERE substr(tc_shc02,1,11)=l_str
                    IF cl_null(l_tmp) THEN
                    LET l_tmp = '000000001'
                 ELSE
                    LET l_tmp = l_tmp + 1
                    LET l_tmp = l_tmp USING '&&&&&&&&&'
                 END IF
                 LET l_tc_shc.tc_shc02 = l_str clipped,l_tmp
                 LET l_tc_shc.tc_shc12=g_tc_shb.tc_shb12  #数量替换
                 LET l_tc_shc.tc_shc06=l_sgm03   #工艺序号
                 LET l_tc_shc.tc_shc08=l_sgm04   #作业编号
                 LET l_tc_shc.tc_shc09=l_ecd07   #工作站
                 LET l_tc_shc.tc_shc01='1'
                 INSERT INTO tc_shc_file VALUES (l_tc_shc.*) 
                 IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
                    LET g_status.code = SQLCA.SQLCODE
                    LET g_status.sqlcode = SQLCA.SQLCODE
                    LET l_return.code="-1"
                    LET l_return.msg = "下一站扫入信息抓取失败"
                    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                    EXIT FOREACH
                 END IF
                 LET l_tc_shc1.*=l_tc_shc.*
                #直接产生扫出资料
                 LET l_tc_shc1.tc_shc01='2'
                 LET l_sql=" select bg02  from bg_file  sample(1) where  rownum=1 and bg01=4 "
                 PREPARE  cre_saochu_pre FROM l_sql
                 DECLARE  cre_saochu_cur CURSOR FOR cre_saochu_pre
                 OPEN cre_saochu_cur
                 FETCH cre_saochu_cur INTO l_str
                 CLOSE cre_saochu_cur

                 LET l_str=l_str CLIPPED,l_y clipped,l_m CLIPPED,l_d CLIPPED
                 SELECT max(substr(tc_shc02,12,20)) INTO l_tmp FROM tc_shc_file
                 WHERE substr(tc_shc02,1,11)=l_str
                 IF cl_null(l_tmp) THEN
                    LET l_tmp = '000000001'
                 ELSE
                    LET l_tmp = l_tmp + 1
                    LET l_tmp = l_tmp USING '&&&&&&&&&'
                 END IF
                 LET l_tc_shc1.tc_shc02 = l_str clipped,l_tmp
                 INSERT INTO tc_shc_file VALUES (l_tc_shc1.*)
                 IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                    LET g_status.code = SQLCA.SQLCODE
                    LET g_status.sqlcode = SQLCA.SQLCODE
                    LET l_return.code="-1"
                    LET l_return.msg = "下一站扫出信息抓取失败"
                    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                    EXIT FOREACH
                 END IF
               END IF   #有扫入扫出结束    

                  #开工完工数据新增
                 #
                 LET l_tc_shb.*=g_tc_shb.*
                 LET l_tc_shb.tc_shb01='1'  #开工数据新增
                 LET l_sql=" select bg02  from bg_file  sample(1) where  rownum=1 and bg01=2 "
                 PREPARE  cre_kaigong_pre FROM l_sql
                 DECLARE  cre_kaigong_cur CURSOR FOR cre_kaigong_pre
                 OPEN cre_kaigong_cur
                 FETCH cre_kaigong_cur INTO l_str
                 CLOSE cre_kaigong_cur

                 LET l_str=l_str CLIPPED,l_y clipped,l_m CLIPPED,l_d CLIPPED
                 SELECT max(substr(tc_shb02,12,20)) INTO l_tmp FROM tc_shb_file
                 WHERE substr(tc_shb02,1,11)=l_str
                 IF cl_null(l_tmp) THEN
                    LET l_tmp = '000000001'
                 ELSE
                    LET l_tmp = l_tmp + 1
                    LET l_tmp = l_tmp USING '&&&&&&&&&'
                 END IF
                 LET l_tc_shb.tc_shb02 = l_str clipped,l_tmp
                 LET l_tc_shb.tc_shb12=g_tc_shb.tc_shb12  #数量替换
                 LET l_tc_shb.tc_shb06=l_sgm03   #工艺序号
                 LET l_tc_shb.tc_shb08=l_sgm04   #作业编号
                 LET l_tc_shb.tc_shb09=l_ecd07   #工作站
                 LET l_tc_shb.tc_shb01='1'
                 INSERT INTO tc_shb_file VALUES (l_tc_shb.*)
                 IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                    LET g_status.code = SQLCA.SQLCODE
                    LET g_status.sqlcode = SQLCA.SQLCODE
                    LET l_return.code="-1"
                    LET l_return.msg = "下一站开工信息产生失败"
                    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                    EXIT FOREACH
                 END IF 
                 LET l_tc_shb1.*=l_tc_shb.*  #完工资料产生
                 LET l_tc_shb1.tc_shb01='2'
                 LET l_sql=" select bg02  from bg_file  sample(1) where  rownum=1 and bg01=2 "
                 PREPARE  cre_wangong_pre FROM l_sql
                 DECLARE  cre_wangong_cur CURSOR FOR cre_wangong_pre
                 OPEN cre_wangong_cur
                 FETCH cre_wangong_cur INTO l_str
                 CLOSE cre_wangong_cur

                 LET l_str=l_str CLIPPED,l_y clipped,l_m CLIPPED,l_d CLIPPED
                 SELECT max(substr(tc_shb02,12,20)) INTO l_tmp FROM tc_shb_file
                 WHERE substr(tc_shb02,1,11)=l_str
                 IF cl_null(l_tmp) THEN 
                    LET l_tmp = '000000001'
                 ELSE 
                    LET l_tmp = l_tmp + 1
                    LET l_tmp = l_tmp USING '&&&&&&&&&'
                 END IF
                 LET l_tc_shb1.tc_shb02 = l_str clipped,l_tmp
                 INSERT INTO tc_shb_file VALUES (l_tc_shb1.*)
                 IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
                    LET g_status.code = SQLCA.SQLCODE
                    LET g_status.sqlcode = SQLCA.SQLCODE
                    LET l_return.code="-1"
                    LET l_return.msg = "下一站完工信息产生失败"
                    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                    EXIT FOREACH
                 END IF
              ELSE  #拆单的情况新增 累加更新
               IF l_ta_ecd04='N' OR cl_null(l_ta_ecd04) THEN  #下一站不存在开工完工的 情况
                 UPDATE tc_shc_file SET tc_shc12=tc_shc12+g_tc_shb.tc_shb12,tc_shcud09=tc_shcud09+g_tc_shb.tc_shbud09
                 WHERE tc_shc03=g_tc_shb.tc_shb03
                 AND tc_shb06=l_sgm03 AND ROWNUM=1  AND tc_shc01='1'  #扫入数量的增加
                 IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                    LET g_status.code = SQLCA.SQLCODE
                    LET g_status.sqlcode = SQLCA.SQLCODE
                    LET l_return.code="-1"
                    LET l_return.msg = "下一站扫入信息产生失败"
                    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                    EXIT FOREACH
                 END IF          
                 UPDATE tc_shc_file SET tc_shc12=tc_shc12+g_tc_shb.tc_shb12,tc_shcud09=tc_shcud09+g_tc_shb.tc_shbud09    
                 WHERE tc_shc03=g_tc_shb.tc_shb03
                 AND tc_shb06=l_sgm03 AND ROWNUM=1  AND tc_shc01='2'  #扫入数量的增加
                 IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                    LET g_status.code = SQLCA.SQLCODE
                    LET g_status.sqlcode = SQLCA.SQLCODE
                    LET l_return.code="-1"
                    LET l_return.msg = "下一站扫入信息产生失败"
                    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                    EXIT FOREACH
                 END IF
               END IF 
                 UPDATE tc_shb_file SET tc_shb12=tc_shb12+g_tc_shb.tc_shb12,tc_shbud09=tc_shbud09+g_tc_shb.tc_shbud09 
                 WHERE tc_shb03=g_tc_shb.tc_shb03
                 AND tc_shb06=l_sgm03 AND ROWNUM=1  AND tc_shb01='1'  #开工数量的增加
                 IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                    LET g_status.code = SQLCA.SQLCODE
                    LET g_status.sqlcode = SQLCA.SQLCODE
                    LET l_return.code="-1"
                    LET l_return.msg = "下一站扫入信息产生失败"
                    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                    EXIT FOREACH
                 END IF
                 UPDATE tc_shb_file SET tc_shb12=tc_shb12+g_tc_shb.tc_shb12,tc_shbud09=tc_shbud09+g_tc_shb.tc_shbud09
                 WHERE tc_shb03=g_tc_shb.tc_shb03
                 AND tc_shb06=l_sgm03 AND ROWNUM=1  AND tc_shb01='1'  #开工数量的增加
                 IF STATUS OR SQLCA.SQLERRD[3]=0 THEN                    LET g_status.code = SQLCA.SQLCODE
                    LET g_status.sqlcode = SQLCA.SQLCODE
                    LET l_return.code="-1"
                    LET l_return.msg = "下一站扫入信息产生失败"
                    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                    EXIT FOREACH
                 END IF
              END IF 

           END IF  
           #下一站报工资料产生
           LET g_tc_shb03=l_tc_shb1.tc_shb03   #g_argv1
           LET g_tc_shb08=l_tc_shb1.tc_shb08    #g_argv2
           LET g_tc_shb02=l_tc_shb1.tc_shb02     #g_argv3
           LET g_tc_shb12=l_tc_shb1.tc_shb12      #g_argv4
           CALL p740_try()
        END FOREACH 
      END IF 
  {      #tianry add 161222   #本站的完工产生相关信息 如果下一站有扫入扫出 生成下一站的扫入 +扫出+完工
                             #如果下一站没有扫入扫出 则生成完工即可
        SELECT sfbud11 INTO l_sfbud11 FROM sfb_file WHERE sfb01=g_tc_shb.tc_shb04
    IF cl_null(l_sfbud11) THEN
       LET p_tc_shb.* =g_tc_shb.*
       DECLARE sel_tc_shc_cc_cur CURSOR FOR   #完工产生
       SELECT  sgm03,sgm04,ta_sgm06 from sgm_file WHERE sgm01=g_tc_shb.tc_shb03 AND sgm03>g_tc_shb.tc_shb06
       ORDER BY sgm03
       LET l_success='Y'
       FOREACH sel_tc_shc_cc_cur  INTO l_sgm03,l_sgm04,l_ta_sgm06

         IF l_ta_sgm06='Y' THEN
            EXIT FOREACH
         END IF
          #下一站的完工资料必须产生
         SELECT ecd07 INTO l_ecd07  FROM ecd_file WHERE ecd01=l_sgm04   #工作站 
    #     LET l_tttt=g_tc_shb.tc_shb02[1,10]   #'WGB'
    #     SELECT max(tc_shb02) INTO l_tmp FROM tc_shb_file
    #     WHERE substr(tc_shb02,1,10)=l_tttt
    #     LET  l_tmp=l_tmp[11,20]
    #     IF cl_null(l_tmp) THEN
    #        LET l_tmp = '0000000001'
    #     ELSE
    #        LET l_tmp = l_tmp + 1
    #        LET l_tmp = l_tmp USING '&&&&&&&&&&'
    #     END IF
          LET l_sql="select bg02  from bg_file  sample(1) where  rownum=1 and bg01=3 "
       PREPARE ss_aaee_pre FROM l_sql
       DECLARE ss_aaee_cur cursor for ss_aaee_pre
       OPEN ss_aaee_cur 
       FETCH ss_aaee_cur  INTO l_str
       CLOSE ss_aaee_cur
     
     
     
       LET l_str=l_str CLIPPED,l_y clipped,l_m CLIPPED,l_d CLIPPED
       SELECT max(substr(tc_shb02,12,20)) INTO l_tmp FROM tc_shb_file
        WHERE substr(tc_shb02,1,11)=l_str
       IF cl_null(l_tmp) THEN 
          LET l_tmp = '000000001' 
       ELSE 
          LET l_tmp = l_tmp + 1
          LET l_tmp = l_tmp USING '&&&&&&&&&'
       END IF
       LET p_tc_shb.tc_shb02 = l_str clipped,l_tmp
       


         LET p_tc_shb.tc_shb02=p_tc_shb.tc_shb02[1,11] CLIPPED,l_tmp  #单据号码重新命名
         LET p_tc_shb.tc_shb06=l_sgm03                                # 工序
         LET p_tc_shb.tc_shb08=l_sgm04                                #作业编号
         LET p_tc_shb.tc_shb121=0                                     #报废数量
         LET p_tc_shb.tc_shb122=0                                     #返工数量
         LET p_tc_shb.tc_shb09=l_ecd07                                #工作站
         LET p_tc_shb.tc_shbud02=''
         LET p_tc_shb.tc_shb12=g_tc_shb.tc_shb12   ##-g_tc_shb.tc_shb121
         #完工记录开工单号        
         LET l_sql = "SELECT tc_shb12,tc_shb02 FROM tc_shb_file WHERE tc_shb03 = '",p_tc_shb.tc_shb03,"'",
                   "   AND tc_shb06 = '",p_tc_shb.tc_shb06,"'",
                   "   AND tc_shb11 = '",p_tc_shb.tc_shb11,"'",
                   "   AND tc_shb01 = '1'"
         PREPARE l_pre221_t FROM l_sql
         DECLARE l_cur221_t CURSOR FOR l_pre221_t
         FOREACH l_cur221_t INTO l_tc_shc12_x,l_tc_shb02
            SELECT SUM(tc_shb12+tc_shb121+tc_shb122) INTO l_tc_shc12_y FROM tc_shb_file WHERE tc_shbud02 = l_tc_shb02
          #str---add by guanyao160901
            IF cl_null(l_tc_shc12_y) THEN
               LET l_tc_shc12_y= 0
            END IF
          #end---add by guanyao160901
            IF l_tc_shc12_y<l_tc_shc12_x THEN
               LET g_tc_shb.tc_shbud02 = l_tc_shb02
            END IF
            
         END FOREACH  
         INSERT INTO tc_shb_file VALUES (p_tc_shb.*)   #下一站完工资料 
         SELECT COUNT(*) INTO l_cnt FROM tc_shb_file WHERE tc_shbud02=g_tc_shb.tc_shbud02
         AND tc_shb03=p_tc_shb.tc_shb03
         IF l_cnt>0 OR   cl_null(p_tc_shb.tc_shbud02) THEN   #表明此开工单号在其他工序中已经被使用并且记录了
            DECLARE sel_tc_shb02_cur CURSOR FOR
            SELECT tc_shb02 FROM tc_shb_file WHERE tc_shb01='1' AND tc_shb03=p_tc_shb.tc_shb03
            AND tc_shb06=p_tc_shb.tc_shb06 AND tc_shb02 NOT IN (SELECT tc_shbud02 FROM tc_shb_file
            WHERE tc_shb01='2' AND tc_shb03=p_tc_shb.tc_shb03)  AND tc_shb12=p_tc_shb.tc_shb12
            OPEN sel_tc_shb02_cur
            FETCH sel_tc_shb02_cur INTO l_tc_shb02
            CLOSE sel_tc_shb02_cur

            UPDATE tc_shb_file SET tc_shbud02=l_tc_shb02 WHERE tc_shb02=p_tc_shb.tc_shb02
            AND p_tc_shb.tc_shb01='2'

         END IF
         IF g_tc_shb.tc_shb121>0 THEN   #表示 上一站有报废 下一站产生的开工数量减少
            UPDATE tc_shb_file SET tc_shb12=tc_shb12-g_tc_shb.tc_shb121 WHERE tc_shb03=p_tc_shb.tc_shb03
            AND p_tc_shb.tc_shb01='1'  AND tc_shb06=p_tc_shb.tc_shb06
            AND tc_shb02=l_tc_shb02
            
         END IF 
         LET g_tc_shb03=p_tc_shb.tc_shb03   #g_argv1
         LET g_tc_shb08=p_tc_shb.tc_shb08    #g_argv2
         LET g_tc_shb02=p_tc_shb.tc_shb02     #g_argv3
         LET g_tc_shb12=p_tc_shb.tc_shb12      #g_argv4  
   #      CALL p740_try()
    
         IF SQLCA.SQLCODE THEN
            LET g_status.code = SQLCA.SQLCODE
            LET g_status.sqlcode = SQLCA.SQLCODE
            LET l_return.code="-1"
            LET l_return.msg = "下一站完工信息录入失败"
            CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
            RETURN  
         ELSE
         END IF 
 
      SELECT sfbud11 INTO l_sfbud11 FROM sfb_file WHERE sfb01=g_tc_shb.tc_shb04
      IF cl_null(l_sfbud11) THEN
         SELECT ecd07 INTO l_ecd07 FROM ecd_file WHERE ecd01=l_sgm04
         SELECT ta_ecd04 INTO l_ta_ecd04 FROM ecd_file WHERE ecd01=l_sgm04    #产生下一站的扫入扫出
         IF l_ta_ecd04='N' THEN
            # 扫入计算上一站扫出总量    #判断下一站是否已经存在扫入资料 存在的话更新数量
            SELECT COUNT(*) INTO l_cnt FROM tc_shc_file WHERE tc_shc01='1' AND tc_shc03=g_tc_shb.tc_shb03 AND
            tc_shc06=l_sgm03
            IF l_cnt=0 THEN
               LET p_tc_shc.tc_shc01='1'
           #    LET l_tttt='SMB'
           #    SELECT max(tc_shc02) INTO l_tmp FROM tc_shc_file
           #    WHERE substr(tc_shc02,1,3)=l_tttt
           #    LET  l_tmp=l_tmp[11,20]
           #    IF cl_null(l_tmp) THEN
           #       LET l_tmp = '0000000001'
           #    ELSE
           #       LET l_tmp = l_tmp + 1
           #       LET l_tmp = l_tmp USING '&&&&&&&&&&'
           #    END IF
           #    LET  p_tc_shc.tc_shc02=l_tttt CLIPPED,'-',p_tc_shb.tc_shb02[5,10] 
           #    LET p_tc_shc.tc_shc02=p_tc_shc.tc_shc02[1,10] CLIPPED,l_tmp  #单据号码重新命名  
 
               LET l_y =YEAR(g_today)
               LET l_y = l_y[3,4] USING '&&'
               LET l_m =MONTH(g_today)
               LET l_m = l_m USING '&&'
       #str---add by guanyao160806
               LET l_d = DAY(g_today)
               LET l_d = l_d USING '&&'
                  
              #tianry add 170111
              LET l_sql="select bg02  from bg_file  sample(1) where  rownum=1 and bg01=1 "
              PREPARE ss_ee_pre1 FROM l_sql
              DECLARE ss_ee_cur1 cursor for ss_ee_pre1
              OPEN ss_ee_cur1
              FETCH ss_ee_cur1  INTO l_str
              CLOSE ss_ee_cur1

               LET l_str=l_str CLIPPED,l_y clipped,l_m CLIPPED,l_d CLIPPED
               SELECT max(substr(tc_shc02,12,20)) INTO l_tmp FROM tc_shc_file
               WHERE substr(tc_shc02,1,11)=l_str
               IF cl_null(l_tmp) THEN
                  LET l_tmp = '000000001'
               ELSE
                  LET l_tmp = l_tmp + 1
                  LET l_tmp = l_tmp USING '&&&&&&&&&'
               END IF
               LET p_tc_shc.tc_shc02 = l_str clipped,l_tmp

               LET p_tc_shc.tc_shc03=p_tc_shb.tc_shb03
               LET p_tc_shc.tc_shc04=p_tc_shb.tc_shb04
               LET p_tc_shc.tc_shc05=p_tc_shb.tc_shb05
               LET p_tc_shc.tc_shc06=p_tc_shb.tc_shb06
               LET p_tc_shc.tc_shc07=p_tc_shb.tc_shb07
               LET p_tc_shc.tc_shc10=p_tc_shb.tc_shb10
               LET p_tc_shc.tc_shc11=p_tc_shb.tc_shb11
               LET p_tc_shc.tc_shc12=p_tc_shb.tc_shb12
               LET p_tc_shc.tc_shc13=p_tc_shb.tc_shb13
               LET p_tc_shc.tc_shc14=p_tc_shb.tc_shb14
               LET p_tc_shc.tc_shc15=p_tc_shb.tc_shb15
               LET p_tc_shc.tc_shc16=p_tc_shb.tc_shb16
               LET p_tc_shc.tc_shcud09=p_tc_shb.tc_shbud09
               LET p_tc_shc.tc_shc08=l_sgm04
               LET p_tc_shc.tc_shc09=l_ecd07
               INSERT INTO tc_shc_file VALUES (p_tc_shc.*)
               IF SQLCA.SQLCODE THEN
                  LET g_status.code = SQLCA.SQLCODE
                  LET g_status.sqlcode = SQLCA.SQLCODE
                  LET l_return.code="-1"
                  LET l_return.msg = "下一站扫入产生失败"
                  LET l_success='N'
                  EXIT FOREACH
               END IF
            ELSE                #扫入数量和PNL数量累加   扫入
               UPDATE tc_shc_file SET tc_shc12=tc_shc12+g_tc_shb.tc_shb12,tc_shcud09=tc_shcud09+g_tc_shb.tc_shbud09
               WHERE tc_shc01='1' AND tc_shc03=g_tc_shb.tc_shb03 
               AND tc_shc06=l_sgm03
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]!=1 THEN
                  LET g_status.code = SQLCA.SQLCODE
                  LET g_status.sqlcode = SQLCA.SQLCODE
                  LET l_return.code="-1"
                  LET l_return.msg ="下一站扫入产生失败"
                  LET l_success='N'
                  EXIT FOREACH
               END IF
            END IF
            #  扫出资料  当本站只有开工完工 并且下一站有扫入扫出的时候才产生下一站的扫出资料
            IF g_ta_ecd04='Y' AND l_ta_ecd04='N' THEN 
             #  LET l_tttt='OCB'
              LET l_sql="select bg02  from bg_file  sample(1) where  rownum=1 and bg01=4 "
              PREPARE ss_ee_pre2 FROM l_sql
              DECLARE ss_ee_cur2 cursor for ss_ee_pre2
              OPEN ss_ee_cur2
              FETCH ss_ee_cur2  INTO l_tttt
              CLOSE ss_ee_cur2
               #  select bg02  INTO l_tttt from bg_file  sample(1) where  rownum=1 and bg01=4
               LET p_tc_shc.tc_shc06=l_sgm03
               LET p_tc_shc.tc_shc08=l_sgm04
               SELECT max(tc_shc02) INTO l_tmp FROM tc_shc_file
               WHERE substr(tc_shc02,1,5)=l_tttt
               LET  l_tmp=l_tmp[12,20]
               IF cl_null(l_tmp) THEN
                  LET l_tmp = '000000001'
               ELSE
                  LET l_tmp = l_tmp + 1
                  LET l_tmp = l_tmp USING '&&&&&&&&&'
               END IF
               LET p_tc_shc.tc_shc01='2'  
               LET p_tc_shc.tc_shc02=l_tttt,p_tc_shb.tc_shb02[6,11]
               LET p_tc_shc.tc_shc02=p_tc_shc.tc_shc02[1,11] CLIPPED,l_tmp
               LET p_tc_shc.tc_shc03=p_tc_shb.tc_shb03
               LET p_tc_shc.tc_shc04=p_tc_shb.tc_shb04
               LET p_tc_shc.tc_shc05=p_tc_shb.tc_shb05
               LET p_tc_shc.tc_shc06=p_tc_shb.tc_shb06
               LET p_tc_shc.tc_shc07=p_tc_shb.tc_shb07
               LET p_tc_shc.tc_shc10=p_tc_shb.tc_shb10
               LET p_tc_shc.tc_shc11=p_tc_shb.tc_shb11
               LET p_tc_shc.tc_shc12=p_tc_shb.tc_shb12
               LET p_tc_shc.tc_shc13=p_tc_shb.tc_shb13
               LET p_tc_shc.tc_shc14=p_tc_shb.tc_shb14
               LET p_tc_shc.tc_shc15=p_tc_shb.tc_shb15
               LET p_tc_shc.tc_shc16=p_tc_shb.tc_shb16
               LET p_tc_shc.tc_shcud09=p_tc_shb.tc_shbud09
               INSERT INTO tc_shc_file VALUES (p_tc_shc.*)
               IF STATUS THEN
                  LET g_status.code = SQLCA.SQLCODE
                  LET g_status.sqlcode = SQLCA.SQLCODE
                  LET l_return.code="-1"
                  LET l_return.msg ="下一站扫入产生失败"
                  LET l_success='N'
                  EXIT FOREACH
               END IF
            END IF 
          END IF
       END IF 
       END FOREACH             

    END IF 
 }   
       #tianry add 161222
         LET l_return.code="0"
          LET l_return.msg = "完工信息录入成功"
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       END IF 

        #  tianry add 161129
       SELECT sfbud11  INTO l_sfbud11 FROM sfb_file WHERE sfb01=g_tc_shb.tc_shb04   #自动报工否 空为自动报工
       IF cl_null(l_sfbud11) THEN
          IF g_success='Y' THEN
         # BEGIN WORK 
          CALL p003_try()
          END IF
       END IF 

    IF g_success = 'Y' THEN 
       COMMIT WORK 
    ELSE 
       ROLLBACK WORK 
    END IF 
       #tianry add end 
END FUNCTION
#str-----add by guanyao160903
FUNCTION cws_create_finish_work_ins_sfp(p_tc_shb02,p_tc_shb04,p_tc_shb08,p_tc_shb09,p_tc_shb12)
DEFINE l_sfp           RECORD LIKE sfp_file.*
DEFINE l_sfs           RECORD LIKE sfs_file.*
DEFINE l_sfa           RECORD LIKE sfa_file.*
DEFINE li_result       LIKE type_file.num5
DEFINE l_t             LIKE sfp_file.sfp01
DEFINE p_tc_shb02      LIKE tc_shb_file.tc_shb02
DEFINE p_tc_shb04      LIKE tc_shb_file.tc_shb04
DEFINE p_tc_shb08      LIKE tc_shb_file.tc_shb08
DEFINE p_tc_shb09      LIKE tc_shb_file.tc_shb09
DEFINE p_tc_shb12      LIKE tc_shb_file.tc_shb12
DEFINE p_nn            LIKE type_file.num10
DEFINE p_nn1           LIKE type_file.num10
DEFINE p_sfs09         LIKE sfs_file.sfs09
DEFINE p_img10         LIKE img_file.img10
DEFINE p_gg            LIKE type_file.chr1
DEFINE l_qty           LIKE sfa_file.sfa05 
DEFINE l_qty1          LIKE sfa_file.sfa05
DEFINE l_qty2          LIKE sfa_file.sfa05 
DEFINE l_qty_sum       LIKE sfa_file.sfa05
DEFINE p_sum3          LIKE img_file.img10
DEFINE p_sql           STRING
DEFINE l_cnt           LIKE type_file.num5
DEFINE l_x             LIKE type_file.num5
DEFINE l_yy,l_mm       LIKE type_file.num10
DEFINE l_fac           LIKE img_file.img34 
DEFINE l_i             LIKE type_file.num5
DEFINE l_ima25         LIKE ima_file.ima25
DEFINE l_in_old        LIKE tc_shb_file.tc_shb12
DEFINE l_in_new        LIKE tc_shb_file.tc_shb12
DEFINE l_need          LIKE sfa_file.sfa06


    DROP TABLE tmp_700                                                                                                             
   CREATE TEMP TABLE tmp_700(                                                                                                                 
    a         LIKE oea_file.oea01,                                                                                                
    b         LIKE type_file.chr1000,                                                                                                 
    c         LIKE type_file.num15_3);
    LET g_success = 'Y'
    LET g_i = 'Y'
    BEGIN WORK 
    INITIALIZE l_sfp.* TO NULL
    LET l_sfp.sfp02  =g_today
    LET l_sfp.sfp03  =g_today
    CALL s_yp(l_sfp.sfp03) RETURNING l_yy,l_mm

    IF l_yy > g_sma.sma51 THEN      # 與目前會計年度,期間比較
       LET g_status.code = '-1'
       LET g_status.description = '日期年度大于当前使用会计年度!!!'
       LET g_success = 'N'
       RETURN 
    ELSE
       IF l_yy=g_sma.sma51 AND l_mm > g_sma.sma52 THEN
          LET g_status.code = '-1'
          LET g_status.description = '日期月份大於当前使用会计期间!!!!!!'
          LET g_success = 'N'
          RETURN 
       END IF
    END IF
    LET l_sfp.sfp04  ='N'
    LET l_sfp.sfpconf='N'
    LET l_sfp.sfp05  ='N'
    LET l_sfp.sfp06  ='4'
    LET l_sfp.sfp09  ='N'
    LET l_sfp.sfpuser=g_user  
    LET l_sfp.sfporiu = g_user 
    LET l_sfp.sfporig = g_grup 
    LET l_sfp.sfpgrup=g_grup  
    LET l_sfp.sfpdate=g_today 
    LET l_sfp.sfp07  =g_grup  
    LET l_sfp.sfp15 = '0'     
    LET l_sfp.sfpmksg = "N"
    LET l_sfp.sfp16 = g_user
    LET l_sfp.sfpud04 = p_tc_shb02
    LET l_sfp.sfpplant = g_plant 
    LET l_sfp.sfplegal = g_legal
    SELECT smyslip INTO l_t FROM (SELECT 'N',smyslip,smydesc,smyauno,smydmy5  FROM smy_file WHERE 1=1 AND smyslip NOT IN (SELECT rye04 FROM rye_file WHERE ryeacti = 'Y'
       AND upper(rye01) = 'ASF' AND rye04 IS NOT NULL) AND smyacti='Y' AND upper(smysys) ='ASF' AND smykind ='3' AND  (smy73 <> 'Y' OR smy73 is null) 
             AND smy72='4'  order by dbms_random.value) where rownum=1;
    IF l_t IS NOT NULL THEN
       LET l_sfp.sfp01 = l_t
    ELSE
       #CALL cl_err('',109,0)
       LET g_status.code = '-1'
       LET g_status.description = '没有欠料单单别'
       LET g_success = 'N'
       RETURN
    END IF
    CALL s_auto_assign_no("asf",l_sfp.sfp01,l_sfp.sfp02,"","sfp_file","sfp01","","","")
       RETURNING li_result,l_sfp.sfp01
    IF (NOT li_result) THEN
       #CALL s_errmsg('sfs04',l_sfs.sfs04,'',130,1)
       LET g_status.code = '-1'
       LET g_status.description = '没有欠料单单别'
       LET g_success = 'N'
       RETURN
    END IF
    INSERT INTO sfp_file VALUES(l_sfp.*)
    IF SQLCA.sqlcode THEN                    
       #CALL cl_err3("ins","sfp_file",l_sfp.sfp01,"",SQLCA.sqlcode,"","",1)
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       LET g_success = 'N'
       RETURN 
    END IF

    DECLARE p700sub_sfs_cur CURSOR WITH HOLD FOR                                                                                  
     SELECT sfa_file.* FROM sfb_file,sfa_file                                                                             
      WHERE sfb01 = p_tc_shb04                                                                              
        AND sfb01 = sfa01                                                                                                       
        AND sfa11 = 'E'
        AND sfa08 = p_tc_shb08
      ORDER BY sfa26 
    FOREACH p700sub_sfs_cur INTO l_sfa.*    
       IF l_sfa.sfa05 IS NULL THEN LET l_sfa.sfa05 = 0 END IF
       IF l_sfa.sfa06 IS NULL THEN LET l_sfa.sfa06 = 0 END IF
       LET l_qty1=l_qty2:=l_qty_sum:=0  #by liupeng 141101 add
       LET l_qty2 = l_sfa.sfa05 - l_sfa.sfa06   #料号未发料量
       IF l_qty2 < = 0 THEN                     #不欠料，就不产生领料单
          CONTINUE FOREACH
       ELSE
          SELECT SUM(sfs05) INTO l_qty_sum     #未过账领料单的发料量
           FROM sfs_file,sfp_file
           WHERE sfs01 = sfp01
             AND (sfpconf = 'N' OR (sfpconf = 'Y' AND sfp04 <> 'Y'))
             AND sfs03 = l_sfa.sfa01
             AND sfs04 = l_sfa.sfa03
             AND sfs10 = l_sfa.sfa08
          IF cl_null(l_qty_sum) THEN LET l_qty_sum = 0 END IF #by liupeng 141101 add
          LET l_qty1 = l_qty2 - l_qty_sum       #未产生领料单的数量
          IF l_qty1 < = 0 THEN
             LET g_success = 'N'
             LET g_showmsg = l_sfa.sfa01,'/',l_sfa.sfa03
             #CALL s_errmsg('sfa01,sfa03',g_showmsg,'','csf-010',1)
             LET g_status.code = '-1'
             LET g_status.description = "有未过账的欠料单"
             CONTINUE FOREACH
          END IF
       END IF
       #add by donghy 160905--start
       #部分材料可能通过欠料补料已发，因此需要计算 (工单该作业编号已完工量+工单作业编号本次完工量)/QPA < 该料号已发量
       #l_in_old 当站已完工量;l_in_new当站本次完工量;l_need总入库量应发料件总量; l_sfa06 工单备料已发数量
       SELECT SUM(tc_shb12) INTO l_in_old FROM tc_shb_file 
         WHERE tc_shb04=l_sfa.sfa01 AND tc_shb08=l_sfa.sfa08 AND tc_shb01='2'
       IF cl_null(l_in_old) THEN LET l_in_old = 0 END IF
       IF cl_null(p_tc_shb12) OR p_tc_shb12 = 0 THEN CONTINUE FOREACH END IF
       LET l_in_new = p_tc_shb12
       
       LET l_need = (l_in_old  + l_in_new ) * l_sfa.sfa161
       #当总需求量小于已发数量，则该笔单身不需要产生
       IF l_need < l_sfa.sfa06 THEN
          CONTINUE FOREACH
       END IF
       #add by donghy 160905--end

       INITIALIZE l_sfs.* TO NULL 
       LET l_sfs.sfs01 = l_sfp.sfp01 
       LET l_sfs.sfs03 = l_sfa.sfa01
       LET l_sfs.sfs04 = l_sfa.sfa03
       IF l_sfa.sfa161 IS NULL THEN LET l_sfa.sfa161 = 0 END IF
       LET l_sfs.sfs06 = l_sfa.sfa12  #發料單位 
       LET p_nn = 0  #by liupeng 141101 add 
       SELECT COUNT(*) INTO p_nn FROM img_file    #没有库存
        WHERE img01 = l_sfs.sfs04
          AND img02 = 'XBC'
          AND img03 = p_tc_shb09
          AND img10 > 0
       LET p_sum3 = 0  #by liupeng 141101 add
       SELECT NVL(SUM(img10),0) INTO p_sum3     #库存库存不足
         FROM img_file
        WHERE img01 = l_sfs.sfs04
          AND img02 = 'XBC'
          AND img03 = p_tc_shb09
          AND img18 >= g_today   #add by guanyao160920
       SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = l_sfs.sfs04
       CALL s_umfchk(l_sfs.sfs04,l_ima25,l_sfa.sfa12) 
            RETURNING l_i,l_fac
       #str------add by guanyao160912
       #IF l_i = 1 THEN LET l_fac = 1 END IF
       IF l_i = 1 THEN 
          LET g_status.code = '-1'
          LET g_status.description = "库存单位和发料单位之间没有单位转换'",l_sfs.sfs04,"'"
          LET g_success = 'N'
          CONTINUE FOREACH
       END IF
       #end------add by guanyao160912 
       LET p_sum3 = p_sum3*l_fac
       LET p_tc_shb12 = p_tc_shb12*l_sfa.sfa161
       LET p_tc_shb12=s_digqty(p_tc_shb12,l_sfa.sfa12)
       IF p_nn = 0 OR (p_sum3 < p_tc_shb12) THEN 
          #CALL s_errmsg('sfs04',l_sfs.sfs04,'',129,1)
          LET g_status.code = '-1'
          LET g_status.description = "没有库存'",l_sfs.sfs04,"'"
          LET g_success = 'N'
          CONTINUE FOREACH
       END IF
       LET p_sql = " SELECT img04,img10 from img_file ",
                   " WHERE img01 = '",l_sfs.sfs04,"' ",
                   "   AND img02 = 'XBC' ",
                   "   AND img03 = '",p_tc_shb09,"' ",
                   "   AND img10 > 0",
                   "   AND img18 >= '",g_today,"' ",       #add by guanyao160920
                   " ORDER BY img22 DESC,img22 ASC,img15 ASC"
       PREPARE p700_img5 FROM p_sql
       DECLARE img5_curs CURSOR FOR p700_img5
       FOREACH img5_curs INTO p_sfs09,p_img10
          LET l_sfs.sfs07 = 'XBC'
          LET l_sfs.sfs08 = p_tc_shb09
          LET l_sfs.sfs09 = p_sfs09
          #数量处理例如两个批号个1000的量 工单2张按比例分配为1400,600
          SELECT MAX(sfs02) INTO l_cnt FROM sfs_file                                                                                
           WHERE sfs01 = l_sfp.sfp01
          IF l_cnt IS NULL THEN    #項次                                                                                            
             LET l_cnt = 1                                                                                                          
          ELSE  
             LET l_cnt = l_cnt + 1                                                                                               
          END IF
          LET l_sfs.sfs02 = l_cnt
          IF p_img10 > 0 AND p_img10 >= p_tc_shb12 THEN
             LET p_gg = 'Y'
             LET l_sfs.sfs32= p_tc_shb12
             LET l_sfs.sfs05= p_tc_shb12
          ELSE
             LET p_gg = 'N'
             LET l_sfs.sfs32 = p_img10
             LET l_sfs.sfs05 = p_img10
             LET p_tc_shb12 = p_tc_shb12 - p_img10
          END IF
                                                                                
          LET l_sfs.sfs10 = l_sfa.sfa08  #作業序號                                                                                  
          LET l_sfs.sfs26 = NULL         #替代碼                                                                                    
          LET l_sfs.sfs27 = NULL         #被替代料號                                                                                
          LET l_sfs.sfs28 = NULL         #替代率   
          LET l_sfs.sfsplant = g_plant
          LET l_sfs.sfslegal = g_legal
          LET l_sfs.sfs014 = ' '
          LET l_sfs.sfs012 = l_sfa.sfa012  #FUN-A60076
          LET l_sfs.sfs013 = l_sfa.sfa013  #FUN-A60076
          IF l_sfa.sfa26 MATCHES '[SUTZ]' THEN      #FUN-A20037 
             LET l_sfs.sfs26 = l_sfa.sfa26
             LET l_sfs.sfs27 = l_sfa.sfa27
             LET l_sfs.sfs28 = l_sfa.sfa28
             LET l_sfs.sfs05 = p_tc_shb12*l_sfa.sfa161   #MOD-A70228
             SELECT SUM(c) INTO l_qty FROM tmp_700 WHERE a = l_sfa.sfa01                                                                
                AND b = l_sfa.sfa27                                                                                                 
             IF l_sfs.sfs05 < l_qty THEN                                                                                            
                LET l_sfs.sfs05 = 0 
             ELSE                                                                                                                   
                LET l_sfs.sfs05 = l_sfs.sfs05 - l_qty                                                                               
             END IF                                                                                                                 
          ELSE                                                                                                                      
             LET l_sfs.sfs27 = l_sfa.sfa27                                                                                          
          END IF                                                                                                                    
          CALL p700_chk_ima64(l_sfs.sfs04, l_sfs.sfs05) RETURNING l_sfs.sfs05                                                                                                                         
          IF cl_null(l_sfs.sfs07) AND cl_null(l_sfs.sfs08) THEN                                                                     
             SELECT ima35,ima36 INTO  l_sfs.sfs07,l_sfs.sfs08                                                                       
               FROM ima_file                                                                                                        
              WHERE ima01 = l_sfs.sfs04    
          END IF                                                                                                                    
          #tianry add  161213
          IF l_sfs.sfs05=0 THEN
             LET g_status.code = '-1'
             LET g_status.description = '发料数量不能为0'
             LET g_success = 'N'
          END IF 
          #tianry add end 
          IF l_sfs.sfs07 IS NULL THEN LET l_sfs.sfs07 = ' ' END IF                                                                  
          IF l_sfs.sfs08 IS NULL THEN LET l_sfs.sfs08 = ' ' END IF                                                                  
          IF l_sfs.sfs09 IS NULL THEN LET l_sfs.sfs09 = ' ' END IF                                                                  
          INSERT INTO tmp_700 
            VALUES(l_sfa.sfa01,l_sfa.sfa27,l_sfs.sfs05)                                             
            INSERT INTO sfs_file VALUES (l_sfs.*)
            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
              #CALL cl_err('ins sfs',STATUS,0)
              LET g_status.code = '-1'
              LET g_status.description = '没有欠料单单别'
              LET g_success = 'N'
            END IF
         IF p_gg = 'Y' THEN
            EXIT FOREACH
         END IF
         END FOREACH
    END FOREACH     
    LET l_x = 0
    SELECT COUNT(*) INTO l_x FROM sfs_file WHERE sfs01 = l_sfs.sfs01
    IF cl_null(l_x) OR l_x =0 THEN
      #str---add by guanyao160907
      IF g_success = 'Y' THEN 
         LET g_i = 'N'
         DELETE FROM sfp_file WHERE sfp01 = l_sfp.sfp01
      END IF  
      #end---add by guanyao160907
       #LET g_success = 'N'
    END IF 
    LET g_prog = 'asfi514'
    IF g_success = 'Y' AND g_i = 'Y' THEN 
       #CALL i501sub_y_chk(l_sfp.sfp01,"confirm")
       #IF g_success = 'Y' THEN 
          CALL i501sub_y_upd(l_sfp.sfp01,'confirm',TRUE) 
              RETURNING l_sfp.*      
          IF g_success = 'Y' THEN 
             CALL i501sub_s('1',l_sfp.sfp01,TRUE,'N')
          END IF 
       #END IF 
    END IF 

    IF g_success = 'Y' THEN 
       COMMIT WORK 
    ELSE 
       ROLLBACK WORK 
    END IF 

END FUNCTION 

FUNCTION p700_chk_ima64(p_part, p_qty)
  DEFINE p_part		LIKE ima_file.ima01
  DEFINE p_qty		LIKE ima_file.ima641   #No.FUN-680121 DEC(15,3)
  DEFINE l_ima108	LIKE ima_file.ima108
  DEFINE l_ima64	LIKE ima_file.ima64
  DEFINE l_ima641	LIKE ima_file.ima641
  DEFINE i		LIKE type_file.num10   #No.FUN-680121 INTEGER
 
  SELECT ima108,ima64,ima641 INTO l_ima108,l_ima64,l_ima641 FROM ima_file
   WHERE ima01=p_part
  IF STATUS THEN RETURN p_qty END IF
 
  IF l_ima108='Y' THEN RETURN p_qty END IF
 
  IF l_ima641 != 0 AND p_qty<l_ima641 THEN
     LET p_qty=l_ima641
  END IF
 
  IF l_ima64<>0 THEN
     LET i=p_qty / l_ima64 + 0.999999
     LET p_qty= i * l_ima64
  END IF
  RETURN p_qty
 
END FUNCTION
#end-----add by guanyao160903
FUNCTION p740_try()
DEFINE l_sfbud11  LIKE sfb_file.sfbud11,
       l_sql      STRING
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680136 SMALLINT
   DEFINE l_no          LIKE type_file.num5          #No.FUN-680136 SMALLINT
   DEFINE
          #l_wc          LIKE type_file.chr1000,      # RDSQL STATEMENT  #No.FUN-680136 VARCHAR(200)
          l_wc          STRING,      # RDSQL STATEMENT  #No.FUN-680136 VARCHAR(200)
          #l_sql         LIKE type_file.chr1000,      # RDSQL STATEMENT  #No.FUN-680136 VARCHAR(600)
          l_cnt         LIKE type_file.num5         #No.FUN-680136 SMALLINT
   DEFINE l_msg         LIKE type_file.chr100   #CHI-B30030
   DEFINE l_qty         LIKE pmn_file.pmn50
   DEFINE l_shb         RECORD LIKE shb_file.*
   DEFINE l_tc_shb      RECORD 
          tc_shb03      LIKE tc_shb_file.tc_shb03,
          tc_shb04      LIKE tc_shb_file.tc_shb04,
          tc_shb05      LIKE tc_shb_file.tc_shb05,
          tc_shb06      LIKE tc_shb_file.tc_shb06,
          tc_shb07      LIKE tc_shb_file.tc_shb07,
          tc_shb09      LIKE tc_shb_file.tc_shb09,
          tc_shb10      LIKE tc_shb_file.tc_shb10,
          tc_shb11      LIKE tc_shb_file.tc_shb11,
          tc_shb12      LIKE tc_shb_file.tc_shb12,
          tc_shb13      LIKE tc_shb_file.tc_shb13,
          tc_shb14      LIKE tc_shb_file.tc_shb14
          #,tc_shbud04   LIKE tc_shb_file.tc_shbud04  #add by guanyao160831
            END RECORD
    DEFINE l_tc_shbud07    LIKE tc_shb_file.tc_shbud07,
           l_tc_shbud08    LIKE tc_shb_file.tc_shbud08,
           l_tc_shb121     LIKE tc_shb_file.tc_shb121,
           l_tc_shb12      LIKE tc_shb_file.tc_shb12,
           l_tc_shb122     LIKE tc_shb_file.tc_shb122
    DEFINE li_result    LIKE type_file.num5
    DEFINE l_x,l_y,l_z  LIKE type_file.chr10
    DEFINE l_i,i        LIKE type_file.num5
    #str----add by guanyao160811
    DEFINE l_year      LIKE type_file.chr20 
    DEFINE l_month     LIKE type_file.chr20
    DEFINE l_day       LIKE type_file.chr20
    DEFINE l_str       LIKE type_file.chr20
    DEFINE l_tmp       LIKE type_file.chr20
    #end----add by guanyao160811
    DEFINE l_b         LIKE type_file.chr10
    DEFINE l_sgm03     LIKE sgm_file.sgm03,
           l_sgm04     LIKE sgm_file.sgm04,
           l_ta_sgm06  LIKE sgm_file.ta_sgm06
    DEFINE l_shb1      RECORD LIKE shb_file.*
    DEFINE p_tc_shb    RECORD LIKE tc_shb_file.*     #tianry add 161220 
    DEFINE p_tc_shc    RECORD LIKE tc_shc_file.*     #tianry add 161220
    DEFINE l_ta_ecd04   LIKE ecd_file.ta_ecd04 
    DEFINE l_tttt       LIKE oga_file.oga01               
    DEFINE ll_tc_shb02  LIKE tc_shb_file.tc_shb02



    LET l_sfbud11=''
    SELECT DISTINCT sfbud11 INTO l_sfbud11 FROM sfb_file,shm_file WHERE sfb01=shm012 
    AND shm01=g_tc_shb03
    IF cl_null(l_sfbud11) THEN

    ELSE
      RETURN 
    END IF  
 {   LET l_sql = "SELECT tc_shb03,tc_shb04,tc_shb05,tc_shb06,tc_shb07,tc_shb09,",
                     "       tc_shb10,tc_shb11,SUM(tc_shb12),tc_shb13,tc_shb14", 
                     "  FROM tc_shb_file",
                     " WHERE tc_shb01 = '1'",  #tianry mark 161212
                   #  " WHERE tc_shb01='2' ",    # tianry add 
                     "   AND tc_shb03='",g_tc_shb03,"'  AND tc_shb08='",g_tc_shb08,"'",
                     "   AND tc_shb17 IS NULL "
    LET l_sql = l_sql CLIPPED," GROUP BY tc_shb03,tc_shb04,tc_shb05,tc_shb06,tc_shb07,tc_shb09,",
                                   "          tc_shb10,tc_shb11,tc_shb13,tc_shb14",
                                   " ORDER BY tc_shb03,tc_shb06" 
    PREPARE p730_prepare FROM l_sql
            IF SQLCA.sqlcode != 0 THEN
               #CALL cl_err('foreach:',SQLCA.sqlcode,1)
          #     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
               EXIT PROGRAM
            END IF
         DECLARE p730_curs2 CURSOR FOR p730_prepare   }
        
     #    DECLARE p730_curs2 CURSOR FOR
     #    SELECT tc_shb03,tc_shb04,tc_shb05,tc_shb06,tc_shb07,tc_shb09,tc_shb10,tc_shb11,SUM(tc_shb12),tc_shb13,tc_shb14
     #    FROM tc_shb_file WHERE tc_shb01 = '1'  AND tc_shb03=g_tc_shb03 AND  tc_shb08=g_tc_shb08 AND  tc_shb17 IS NULL
     #    GROUP BY tc_shb03,tc_shb04,tc_shb05,tc_shb06,tc_shb07,tc_shb09,tc_shb10,tc_shb11,tc_shb13,tc_shb14
         INITIALIZE l_tc_shb.* TO NULL
         SELECT tc_shb03,tc_shb04,tc_shb05,tc_shb06,tc_shb07,tc_shb09,tc_shb10,tc_shb11,tc_shb12,tc_shb13,tc_shb14
         INTO l_tc_shb.*
         FROM tc_shb_file WHERE  tc_shb02=g_tc_shb02
         
       #  INITIALIZE l_tc_shb.* TO NULL
         INITIALIZE l_shb.* TO NULL  
   #      FOREACH p730_curs2 INTO l_tc_shb.*
            CALL p730_shb_try(l_tc_shb.tc_shb03,l_tc_shb.tc_shb06,l_tc_shb.tc_shb11,l_tc_shb.tc_shb12,l_tc_shb.tc_shb13,l_tc_shb.tc_shb14) 
         #   IF g_tot_success = 'N' THEN 
         #      CONTINUE FOREACH  
         #   END IF 
            #str----add by guanyao160811
            INITIALIZE l_shb.* TO NULL  
            LET l_year =YEAR(g_today)
            LET l_year = l_year[3,4] USING '&&' 
            LET l_month =MONTH(g_today)
            LET l_month = l_month USING '&&' 
            LET l_day = DAY(g_today)
            LET l_day = l_day USING '&&' 
            #tianry add 170111  
            LET l_sql=" select smyslip  from smy_file  sample(1) where smysys='asf' AND smykind='9' ",
                      " and   rownum=1 "
            PREPARE  ss_ee_pre4 FROM l_sql
            DECLARE ss_ee_cur4 CURSOR for ss_ee_pre4 
            OPEN ss_ee_cur4 
            FETCH ss_ee_cur4 INTO l_str
            CLOSE ss_ee_cur4
  
            LET l_str=l_str CLIPPED,'-'
            LET l_str=l_str CLIPPED,l_year CLIPPED,l_month CLIPPED,l_day CLIPPED 
            SELECT max(substr(shb01,11,6)) INTO l_tmp FROM shb_file
            WHERE substr(shb01,1,10)=l_str
            IF cl_null(l_tmp) THEN 
               LET l_tmp = '000001' 
            ELSE 
               LET l_tmp = l_tmp + 1
               LET l_tmp = l_tmp USING '&&&&&'     
            END IF 
            LET l_shb.shb01 = l_str clipped,l_tmp
            LET l_shb.shb02   = l_tc_shb.tc_shb14
            LET l_shb.shb021 = "08:00"
            LET l_x = ''
            LET l_y = ''
            LET l_z = ''
            LET l_b = ''   #add by guanyao160831
            IF (g_sum/60) >16 THEN  
               SELECT TRUNC((g_sum/60-16)/24) INTO l_x FROM dual
               #SELECT ceil((((g_sum/60-16)/24)-TRUNC((g_sum/60-16)/24))*24-TRUNC((((g_sum/60-16)/24)-TRUNC((g_sum/60-16)/24))*24)) INTO l_y FROM dual
               #str----add by guanyao160831
               SELECT ((g_sum/60-16)/24 -TRUNC(((g_sum/60-16)/24)))*24 INTO l_b FROM dual  
               SELECT TRUNC(l_b) INTO l_y FROM dual 
               SELECT (l_b-TRUNC(l_b))*60 INTO l_z FROM dual 
               #end----add by guanyao160831
               #SELECT to_date(g_today,'yy/mm/dd')+l_x+1 INTO l_shb.shb03 FROM dual   #mark by guanyao160831
               SELECT to_date(l_shb.shb02,'yy/mm/dd')+l_x+1 INTO l_shb.shb03 FROM dual  #add by guanyao160831
               LET l_y = l_y USING '&&'
               LET l_z = l_z USING '&&'
               LET l_shb.shb031= l_y CLIPPED,':',l_z CLIPPED
            ELSE 
               #LET l_shb.shb03   = g_today   #mark by guanyao160831 
               LET l_shb.shb03 = l_shb.shb02  #add by guanyao160831
               SELECT ceil(((g_sum/60)-TRUNC(g_sum/60))*60) INTO l_z FROM dual
               SELECT TRUNC(g_sum/60) INTO l_y FROM dual
               LET l_y = l_y+8
               LET l_y = l_y USING '&&'
               LET l_z = l_z USING '&&'
               LET l_shb.shb031= l_y CLIPPED,':',l_z CLIPPED 
            END IF 
            LET l_tc_shbud07 = 0
            LET l_tc_shbud08 = 0
            LET l_tc_shb121 = 0
            LET l_tc_shb122 = 0
            LET l_tc_shb12 = 0
            SELECT SUM(tc_shbud07),SUM(tc_shbud08),SUM(tc_shb121),SUM(tc_shb122),SUM(tc_shb12) 
              INTO l_tc_shbud07,l_tc_shbud08,l_tc_shb121,l_tc_shb122,l_tc_shb12
              FROM tc_shb_file 
             WHERE tc_shbud02 IN ( SELECT tc_shb02 FROM tc_shb_file 
                                                  WHERE tc_shb03 = l_tc_shb.tc_shb03
                                                    AND tc_shb06 = l_tc_shb.tc_shb06
                                                    AND tc_shb11 = l_tc_shb.tc_shb11
                                                    AND tc_shb13 = l_tc_shb.tc_shb13
                                                    AND tc_shb14 = l_tc_shb.tc_shb14
                                                    AND tc_shb01 = '1')
              AND tc_shb17 IS NULL #add by guanyao160908
            LET l_shb.shb032 = g_sum*l_tc_shbud08
            LET l_shb.shb033 = g_sum*l_tc_shbud07
            LET l_shb.shb04  =l_tc_shb.tc_shb11
            LET l_shb.shb05  =l_tc_shb.tc_shb04
            LET l_shb.shb16  =l_tc_shb.tc_shb03
            LET l_shb.shb08 = l_tc_shb.tc_shb13
            LET l_shb.shb06 = l_tc_shb.tc_shb06
            SELECT sgm04,sgm45,sgm05 INTO l_shb.shb081,l_shb.shb082,l_shb.shb09 
              FROM sgm_file
             WHERE sgm01 = l_tc_shb.tc_shb03 AND sgm03 = l_tc_shb.tc_shb06
            LET l_shb.shb10 = l_tc_shb.tc_shb05
            LET l_shb.shb07 = l_tc_shb.tc_shb09
          #  LET l_shb.shb111  = l_tc_shb12
            LET l_shb.shb111=g_tc_shb12
            LET l_shb.shb113  = l_tc_shb122
            LET l_shb.shb115  = 0
           SELECT ta_sgm06 INTO l_ta_sgm06 FROM sgm_file WHERE sgm01=l_tc_shb.tc_shb03 AND sgm03 = l_tc_shb.tc_shb06
           IF l_ta_sgm06='N' THEN
              LET l_shb.shb112=0
           ELSE
            LET l_shb.shb112  = l_tc_shb121
           END IF 
            LET l_shb.shb114  = 0
            LET l_shb.shb17   = 0
            LET l_shb.shbinp  = g_today
            LET l_shb.shbacti = 'Y'  
            LET l_shb.shbuser = g_user 
            LET l_shb.shboriu = g_user #FUN-980030
            LET l_shb.shborig = g_grup #FUN-980030
            LET l_shb.shbgrup = g_grup 
            LET l_shb.shbmodu = '' 
            LET l_shb.shbdate = ''  
            IF g_sma.sma541 = 'N' THEN  #FUN-A60095
               LET l_shb.shb012 = ' '   #FUN-A60095
            END IF                      #FUN-A60095 
 
            LET l_shb.shbplant = g_plant #FUN-980008 add
            LET l_shb.shblegal = g_legal #FUN-980008 add
            LET l_shb.shbconf = 'N'      #FUN-A70095
            LET l_shb.shb32 = ''  
            LET l_shb.shb30 ='N'
            #tianry 161225
            LET l_shb.shbud03=ll_tc_shb02
            # 
            LET l_shb.shb31 = l_tc_shb.tc_shb10
            IF cl_null(l_shb.shb31) THEN 
               LET l_shb.shb31 = 'N'
            END IF 
            LET l_shb.shb26 ='N'

            IF l_tc_shb122 > 0 THEN 
               LET l_shb.shb12 = l_shb.shb06
               LET l_shb.shb121 = l_shb.shb012
            END IF 
            IF cl_null(l_shb.shb112) THEN LET l_shb.shb112=0  END IF
            IF cl_null(l_shb.shb113) THEN LET l_shb.shb113=0  END IF  

            INSERT INTO shb_file VALUES (l_shb.*)
            IF STATUS THEN 

               LET g_status.code = '-1'
               LET g_status.description = 'INS shb err'
               LET g_success = 'N'
            END IF
            UPDATE tc_shb_file SET tc_shb17 = l_shb.shb01
                             WHERE tc_shb02=g_tc_shb02
                               AND tc_shb01 = '2'
                               AND tc_shb17 IS NULL #add by guanyao160908
     {   LET l_shb1.* =l_shb.*       
        DECLARE sel_sgm_cur CURSOR FOR
      SELECT  sgm03,sgm04,ta_sgm06 from sgm_file WHERE sgm01=l_shb.shb16 AND sgm03>l_shb.shb06 
      ORDER BY sgm03 
      FOREACH sel_sgm_cur  INTO l_sgm03,l_sgm04,l_ta_sgm06 
        IF l_ta_sgm06='Y' THEN #表明下一站是报工的 不能自动生成报工单
           EXIT FOREACH 
        END IF
        
        

        
        LET l_sql=" select smyslip from smy_file  sample(1) where smysys='asf' AND smykind='9' ",
                  "  and   rownum=1 "
        PREPARE dd_pp_pre FROM l_sql
        declare dd_pp_cur CURSOR  FOR dd_pp_pre
        OPEN dd_pp_cur
        FETCH dd_pp_cur INTO l_str
        CLOSE dd_pp_cur 
        LET l_str=l_str CLIPPED,'-'

        LET l_str=l_str CLIPPED,l_year CLIPPED,l_month CLIPPED,l_day CLIPPED
        SELECT max(substr(shb01,12,6)) INTO l_tmp FROM shb_file
        WHERE substr(shb01,1,10)=l_str
        IF cl_null(l_tmp) THEN
           LET l_tmp = '000001'
        ELSE
           LET l_tmp = l_tmp + 1
           LET l_tmp = l_tmp USING '&&&&&'
        END IF
        LET l_shb1.shb01 = l_str clipped,l_tmp
        LET l_shb1.shb06=l_sgm03
        LET l_shb1.shb081=l_sgm04
        LET l_shb1.shb03=l_shb1.shb02
        LET l_shb1.shb031=l_shb1.shb021
        LET l_shb.shb032 =0
        LET l_shb.shb033 = 0
        SELECT ecd07 INTO l_shb1.shb07 FROM ecd_file WHERE ecd01=l_shb1.shb081
        #tianry add 161225
        SELECT tc_shb02 INTO l_shb1.shbud03 FROM tc_shb_file WHERE tc_shb03=l_shb.shb16
        AND tc_shb06=l_sgm03  AND tc_shb01='2' 
        LET  l_shb1.shb112=0
        #tianry add end    
        INSERT INTO shb_file VALUES (l_shb1.*)
        IF STATUS THEN
           LET g_status.code = '-1'
           LET g_status.description = 'ins shb err'
           LET g_success = 'N'
        END IF    
        #tianry add 161220       

      END FOREACH 
  }
END  FUNCTION


FUNCTION p730_shb_try(p_tc_shb03,p_tc_shb06,p_tc_shb11,p_tc_shb12,p_tc_shb13,p_tc_shb14) 
DEFINE p_tc_shb03        LIKE tc_shb_file.tc_shb03
DEFINE p_tc_shb06        LIKE tc_shb_file.tc_shb06
DEFINE p_tc_shb11        LIKE tc_shb_file.tc_shb11
DEFINE p_tc_shb12        LIKE tc_shb_file.tc_shb12 
DEFINE p_tc_shb13        LIKE tc_shb_file.tc_shb13
DEFINE p_tc_shb14        LIKE tc_shb_file.tc_shb14
DEFINE l_sql STRING 
DEFINE l_tc_shb02        LIKE tc_shb_file.tc_shb02
DEFINE l_tc_shb14        LIKE tc_shb_file.tc_shb14
DEFINE l_tc_shb15        LIKE tc_shb_file.tc_shb15
DEFINE l_tc_shb02_max    LIKE tc_shb_file.tc_shb02
DEFINE l_tc_shb14_max    LIKE tc_shb_file.tc_shb14
DEFINE l_tc_shb15_max    LIKE tc_shb_file.tc_shb15
DEFINE l_a               LIKE type_file.num10
DEFINE l_tc_shb12        LIKE tc_shb_file.tc_shb12
DEFINE l_tc_shb12_sum    LIKE tc_shb_file.tc_shb12
      LET g_tot_success = 'Y'
      LET g_sum = 0
      LET l_sql =" SELECT tc_shb02,tc_shb12,tc_shb14,tc_shb15 FROM tc_shb_file ",
                 "  WHERE tc_shb01 = '1' ",   #tianry mark
               #  " WHERE tc_shb01='2' ",       #tianry add 161212
                 "    AND tc_shb17 is null",   #add by guanyao160904
                 "    AND tc_shb03 = '",p_tc_shb03,"'",
                 "    AND tc_shb06 = '",p_tc_shb06,"'",
                 "    AND tc_shb11 = '",p_tc_shb11,"'",
                 "    AND tc_shb13 = '",p_tc_shb13,"'",
                 "    AND tc_shb14 = '",p_tc_shb14,"'",
                 "  ORDER BY tc_shb02"
      PREPARE p730_prepare1 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
      #   CALL cl_err('foreach:',SQLCA.sqlcode,1)
#         EXIT PROGRAM
      END IF
      DECLARE p730_curs3 CURSOR FOR p730_prepare1
      FOREACH p730_curs3 INTO l_tc_shb02,l_tc_shb12,l_tc_shb14,l_tc_shb15
         SELECT MAX(tc_shb02) INTO l_tc_shb02_max FROM tc_shb_file 
          WHERE tc_shb01= '2'    # tianry mark
      #      WHERE tc_shb01='1'   #tianry add 161212
            AND tc_shbud02 = l_tc_shb02
            AND tc_shb17 IS NULL  #add by guanyao160831
         IF cl_null(l_tc_shb02) THEN 
            LET g_tot_success = 'N'
            RETURN 
         END IF 
         SELECT tc_shb14,tc_shb15 INTO l_tc_shb14_max,l_tc_shb15_max FROM tc_shb_file WHERE tc_shb02 = l_tc_shb02_max
         IF cl_null(l_tc_shb14_max) OR cl_null(l_tc_shb15_max) THEN 
            LET g_tot_success = 'N'
            RETURN
         END IF 
         SELECT SUM(tc_shb12+tc_shb121+tc_shb122) INTO l_tc_shb12_sum FROM tc_shb_file WHERE tc_shbud02 = l_tc_shb02
         #str----add by guanyao160831
         IF cl_null(l_tc_shb12_sum) OR l_tc_shb12_sum = 0 THEN 
            LET g_tot_success = 'N'
            RETURN
         END IF 
         #end----add by guanyao160831
         IF l_tc_shb12_sum<> l_tc_shb12 THEN
            LET g_i= '1'
         ELSE 
            LET g_i= '2'
         END IF 
         SELECT ceil((to_date(l_tc_shb14_max||' '||l_tc_shb15_max,'yy/mm/dd hh24-mi-ss') -
                     to_date(l_tc_shb14||' '||l_tc_shb15,'yy/mm/dd hh24-mi-ss'))*24*60) INTO l_a FROM dual
         IF cl_null(l_a)  THEN LET l_a = 0 END IF  
         LET g_sum = g_sum +l_a 
      END FOREACH 
      #str----add by guanyao160906
      IF g_sum = 0 OR cl_null(g_sum) THEN 
         IF cl_null(l_tc_shb02) THEN 
            LET g_tot_success = 'N'
            RETURN
         END IF 
      END IF 
      #end----add by guanyao160906
END FUNCTION 



FUNCTION p003_try()

CALL p002_create_temp_try()
    


   CALL p002_b_fill_try()
   CALL p002_b_auto_try()


   DROP TABLE shb1_temp
   DROP TABLE shb1_temp2

END FUNCTION


FUNCTION p002_b_auto_try()
DEFINE   l_i    LIKE type_file.num5,
         l_cnt   LIKE type_file.num5,
         l_sql   STRING 
DEFINE l_shb01   LIKE shb_file.shb01
DEFINE l_con     LIKE type_file.chr1
DEFINE l_shb     RECORD LIKE shb_file.*
DEFINE l_sgm311  LIKE sgm_file.sgm311
DEFINE l_shb16   LIKE shb_file.shb16
DEFINE l_count   LIKE type_file.num5
#str-----add by guanyao160901
DEFINE l_yy,l_mm LIKE type_file.num5,
       l_yy2,l_mm2 LIKE type_file.num5
DEFINE l_shb111    LIKE shb_file.shb111


    FOR l_i=1 TO g_shb2.getLength()
        INSERT INTO shb1_temp VALUES (g_shb2[l_i].shb01,g_shb2[l_i].shb16,g_shb2[l_i].shb05,g_shb2[l_i].shb04,
                                         g_shb2[l_i].gen02,g_shb2[l_i].shb02,g_shb2[l_i].shb03,g_shb2[l_i].shb081,
                                         g_shb2[l_i].shb082,g_shb2[l_i].shb06,g_shb2[l_i].shb10,g_shb2[l_i].ima02,
                                         g_shb2[l_i].ima021,g_shb2[l_i].shb111)
    END FOR
    LET g_shb32 = g_today
    IF NOT cl_null(g_shb32) THEN
       CALL s_yp(g_shb32) RETURNING l_yy,l_mm
       IF l_yy < g_ccz.ccz01 OR (l_yy = g_ccz.ccz01 AND l_mm < g_ccz.ccz02) THEN
#          CALL cl_err('','axm-773',0)
       END IF
       CALL s_yp(g_shb32) RETURNING l_yy2,l_mm2
       IF l_yy != l_yy2 OR l_mm != l_mm2 THEN
#          CALL cl_err('','axm-774',0)
       END IF
    END IF 
    DELETE FROM shb1_temp2
      LET l_sql=" SELECT distinct shb01,shb05,shb16,shb081,shb06 FROM shb1_temp ORDER BY shb05,shb16,shb06 ASC "
      PREPARE l_pre22_try FROM l_sql
      DECLARE l_cursor22_try CURSOR WITH HOLD FOR l_pre22_try
      FOREACH l_cursor22_try INTO l_shb01
       #  BEGIN WORK  
         LET g_success='Y' 
         IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF

         SELECT * INTO l_shb.* FROM shb_file WHERE shb01=l_shb01
         SELECT  shb111 INTO l_shb111 FROM shb_file WHERE shb01=l_shb01  #tianry add 161225
        # UPDATE tc_shb_file SET tc_shb17=l_shb01 WHERE tc_shb02=g_tc_shb02
        # AND tc_shb01='2' AND  tc_shb12=l_shb111 AND tc_shb17 IS  NULL
  
         BEGIN WORK 
         CALL t730sub_y_chk(l_shb01,TRUE)

             LET l_sql=" SELECT substr('",l_shb.shb16,"',1,3) FROM dual"
             PREPARE l_pre2212_try FROM l_sql
             EXECUTE l_pre2212_try INTO l_shb16

             LET l_count=0
             SELECT COUNT(*) INTO l_count FROM shb_file WHERE shb16=l_shb16 AND shb06<l_shb.shb06       
             IF l_shb16='WRK' AND l_count=0 THEN
             ELSE
                IF p002_accept_qty('c',l_shb01) THEN
                   LET g_success = 'N'
           
                END IF
             END IF
              IF g_success = 'Y' THEN
                COMMIT WORK
             ELSE
                ROLLBACK WORK
             END IF

             IF g_success='Y' THEN
                BEGIN WORK
                IF NOT cl_null(g_shb32) THEN
                   CALL t730sub_confirm(l_shb01,g_shb32)
               
                END IF
              
             END IF

             IF g_success = 'Y' THEN
                COMMIT WORK
             ELSE
                ROLLBACK WORK
             END IF

  
      END FOREACH 

END FUNCTION 
FUNCTION p002_b_fill_try()
   

    LET g_wc= " shb16='",g_tc_shb03,"' "   # AND shb081='",g_tc_shb06,"' " 

   #tianry add end 
   LET g_sql = "SELECT distinct 'Y',shb01,shb16,shb05,shb04,gen02,shb02,shb03,shb081,shb082,shb06,shb10,ima02,ima021,shb111 ",
               " FROM shb_file LEFT JOIN gen_file ON gen01=shb04 ",
               " LEFT JOIN ima_file ON ima01=shb10 ",
               " WHERE shbconf='N' ",
               " AND ",g_wc,
               " ORDER BY shb05,shb16,shb06 ASC "
   PREPARE p002_pb FROM g_sql
   DECLARE tc_workt_cs CURSOR FOR p002_pb

   CALL g_shb2.clear()
   LET g_cnt = 1
   FOREACH tc_workt_cs INTO g_shb2[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
  #        CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       LET g_cnt = g_cnt + 1
     #  IF g_cnt > g_max_rec THEN
  #        CALL cl_err( '', 9035, 0 )
      #    EXIT FOREACH
      # END IF
   END FOREACH
   CALL g_shb2.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   LET g_cnt = 0
   IF g_shb2.getLength()=0 THEN   
  #    CALL cl_err('','p002-11',0)
      RETURN 
   END IF
END FUNCTION

FUNCTION p002_create_temp_try()
DROP TABLE shb1_temp;
#DELETE FROM shb1_temp WHERE 1=1  #tianry add drop table 报错
CREATE TEMP TABLE shb1_temp(
         shb01         VARCHAR(1000),
         shb16         VARCHAR(1000),
         shb05         VARCHAR(1000),
         shb04         VARCHAR(1000),
         gen02         VARCHAR(1000),
         shb02         DATE,
         shb03         DATE,
         shb081        VARCHAR(1000),
         shb082        VARCHAR(1000),
         shb06         DECIMAL(5),
         shb10         VARCHAR(1000),
         ima02         VARCHAR(1000),
         ima021        VARCHAR(1000),
         shb111        DECIMAL(15,3) 
)
CREATE TEMP TABLE shb1_temp2(
         shb01         VARCHAR(1000),
         con           VARCHAR(1)
)
END FUNCTION 

FUNCTION p002_accept_qty(p_cmd,l_shb01)
DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)
       l_wip_qty  LIKE shb_file.shb111,
       l_pqc_qty  LIKE qcm_file.qcm091,   #良品數 
       l_sum_qty  LIKE qcm_file.qcm091    
DEFINE l_bn_ecm012 LIKE ecm_file.ecm012  #FUN-A80102
DEFINE l_bn_ecm03  LIKE ecm_file.ecm03   #FUN-A80102
DEFINE l_shb01    LIKE shb_file.shb01
DEFINE g_shb      RECORD LIKE shb_file.*
DEFINE g_sgm      RECORD LIKE sgm_file.*

    SELECT * INTO g_shb.* FROM shb_file WHERE shb01=l_shb01

#      WIP量=總投入量(a+b)-總轉出量(f+g)-報廢量(d)-入庫量(e)
#           -委外加工量(h)+委外完工量(i)
#      WIP量指目前在該站的在製量，
#      若系統參數定義要做Check-In時，WIP量尚可區
#      分為等待上線數量與上線處理數量。
#      上線處理數量=Check-In量(c)-總轉出量(f+g)-報廢量(d)-入庫量(e)
#                 -委外加工量(h)+委外完工量(i)
#      等待上線數量=線投入量(a+b)-Check-In量(c)
 
#      若該站允許做製程委外，則
#      可委外加工量=WIP量-委外加工量(h)
#      委外在外量=委外加工量(h)-委外完工量(i)
 
#      某站若要報工則其可報工數=WIP量(a+b-f-g-d-e-h+i)，
#      若要做Check-In則可報工數=c-f-g-d-e-h+i。
 
       IF cl_null(g_shb.shb012) THEN LET g_shb.shb012=' ' END IF #FUN-A60095
       SELECT * INTO g_sgm.* FROM sgm_file
        WHERE sgm01=g_shb.shb16 AND sgm03=g_shb.shb06
          AND sgm012=g_shb.shb012  #FUN-A60095
       IF STATUS THEN  #資料資料不存在

           LET g_success='N'   

           RETURN -1
       END IF

       #str-----add by guanyao160908
       IF g_shb.shb06 = g_shb.shb12 THEN   #返工当站的时候，更新下
          IF g_shb.shb113>0 THEN 
             LET g_sgm.sgm302 = g_sgm.sgm302+g_shb.shb113
          END IF 
       END IF 
       #end-----add by gaunyao160908
       IF g_sma.sma1431='N' OR cl_null(g_sma.sma1431) THEN   #FUN-A80102
          IF g_sgm.sgm54='Y' THEN   #check in 否
             LET l_wip_qty =  g_sgm.sgm291                #check in 
                            - g_sgm.sgm311 #*g_sgm.sgm59  #良品轉出     #FUN-A60095
                            - g_sgm.sgm312 #*g_sgm.sgm59  #重工轉出     #FUN-A60095
                            - g_sgm.sgm313 #*g_sgm.sgm59  #當站報廢     #FUN-A60095
                            - g_sgm.sgm314 #*g_sgm.sgm59  #當站下線     #FUN-A60095
                            - g_sgm.sgm316 #*g_sgm.sgm59                #FUN-A60095
                            - g_sgm.sgm317 #*g_sgm.sgm59                #FUN-A60095
          ELSE
             LET l_wip_qty =  g_sgm.sgm301                #良品轉入量
                            + g_sgm.sgm302                #重工轉入量
                            + g_sgm.sgm303 
                            + g_sgm.sgm304
                            - g_sgm.sgm311 #*g_sgm.sgm59    #良品轉出   #FUN-A60095
                            - g_sgm.sgm312 #*g_sgm.sgm59    #重工轉出   #FUN-A60095
                            - g_sgm.sgm313 #*g_sgm.sgm59    #當站報廢   #FUN-A60095
                            - g_sgm.sgm314 #*g_sgm.sgm59    #當站下線   #FUN-A60095
                            - g_sgm.sgm316 #*g_sgm.sgm59                #FUN-A60095
                            - g_sgm.sgm317 #*g_sgm.sgm59                #FUN-A60095
          END IF
       #FUN-A60102(S)
       ELSE
          CALL t730sub_check_auto_report(g_shb.shb05,g_shb.shb16,g_shb.shb012,g_shb.shb06) 
             RETURNING l_bn_ecm012,l_bn_ecm03,l_wip_qty 
       #FUN-A60102(E)
       END IF
       IF cl_null(l_wip_qty) THEN LET l_wip_qty=0 END IF
 
       LET l_sum_qty=(g_shb.shb111+g_shb.shb113+g_shb.shb112+g_shb.shb114) #*g_sgm.sgm59 #FUN-A60095
       IF l_sum_qty>l_wip_qty AND p_cmd<>'d' THEN

          LET g_success='N' 

          RETURN -1
       END IF

       RETURN 0
END FUNCTION



