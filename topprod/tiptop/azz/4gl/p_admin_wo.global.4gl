# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: p_admin_wo.global.4gl
# Date & Author..: 22/11/02 By darcy
database ds
globals
type sfb record
    sfb01    like sfb_file.sfb01,     #工单单号
    sfb02    like sfb_file.sfb02,     #工单类型
    sfb81    like sfb_file.sfb81,     #开单日期
    sfb87    like sfb_file.sfb87,     #确认码
    sfb28    like sfb_file.sfb28,     #结案状态
    sfb38    like sfb_file.sfb38,     #结案日期
    sfb44    like sfb_file.sfb44,     #申请人
    gen02sfb like gen_file.gen02,  #
    sfb98    like sfb_file.sfb98,     #成本中心
    sfb05    like sfb_file.sfb05,     #产品编号
    sfb06    like sfb_file.sfb06,     #工艺编号
    sfb071   like sfb_file.sfb071,    # 有效日期
    ima02sfb like ima_file.ima02,     #品名
    ima021sfb like ima_file.ima021,    # 规格
    sfbud08  like sfb_file.sfbud08,   #  原工单量
    sfbud09  like sfb_file.sfbud09,   #  生产良率
    sfb08    like sfb_file.sfb08,     #生产数量
    sfbud07  like sfb_file.sfbud07,   #  PNL数量
    sfb081   like sfb_file.sfb081,    # 已发数量
    sfb09    like sfb_file.sfb09,     #完工数量
    sfb12    like sfb_file.sfb12,     #报废数量
    sfbud12  like sfb_file.sfbud12,   #  下版数量
    sfb22    like sfb_file.sfb22,     #订单单号
    sfb221   like sfb_file.sfb221,    # 订单项次
    sfb86    like sfb_file.sfb86,     #母工单号
    sfb89    like sfb_file.sfb89,     #上阶工单单号
    sfb99    like sfb_file.sfb99     #反工否
end record

type sfa record
    sfa01     like sfa_file.sfa01,     #工单单号
    sfa03     like sfa_file.sfa03,     #发料料号
    ima02sfa  like ima_file.ima02,  #   品名
    ima021sfa like ima_file.ima021, #    规格
    sfa27     like sfa_file.sfa27,     #替代前料号
    sfa26     like sfa_file.sfa26,     #替代码
    sfa28     like sfa_file.sfa28,     #替代率
    sfa08     like sfa_file.sfa08,     #作业编号
    ima08sfa  like ima_file.ima08,  #   来源码
    sfa12     like sfa_file.sfa12,     #单位
    sfa11     like sfa_file.sfa11,     #来源特性
    sfa16     like sfa_file.sfa16,     #标准QPA
    sfa161    like sfa_file.sfa161,    # 实际QPA
    sfa05     like sfa_file.sfa05,     #应发数量
    sfa06     like sfa_file.sfa06,     #已发数量
    sfa065    like sfa_file.sfa065,    # 委外代买数量
    sfa062    like sfa_file.sfa062,    # 超领数量
    sfa063    like sfa_file.sfa063,    # 报废数量
    sfa064    like sfa_file.sfa064,    # 盘盈亏数量
    sfa100    like sfa_file.sfa100,    # 误差率
    sfaud08   like sfa_file.sfaud08    #  良率
end record

type sgm record
    sgm01     like sgm_file.sgm01     , #Run     Card
    sgm02     like sgm_file.sgm02     , #工单编号
    sgm11     like sgm_file.sgm11     , #工序序号
    sgm03_par like sgm_file.sgm03_par , #    料件编号
    ima02sgm  like ima_file.ima02  , #
    ima021sgm like ima_file.ima021 , #
    sgm03     like sgm_file.sgm03     , #作业序号
    sgm04     like sgm_file.sgm04     , #作业编号
    sgm45     like sgm_file.sgm45     , #作业名称
    sgm05     like sgm_file.sgm05     , #机器编号
    sgm06     like sgm_file.sgm06     , #工作站
    sgm14     like sgm_file.sgm14     , #标准人工生产时间
    sgm15     like sgm_file.sgm15     , #标准机器设置时间
    sgm16     like sgm_file.sgm16     , #标准机器生产时间
    sgm65     like sgm_file.sgm65     , #标准转出量
    sgm301    like sgm_file.sgm301    , # 良品转入量
    sgm302    like sgm_file.sgm302    , # 重工转入量
    sgm303    like sgm_file.sgm303    , # 分割转入量
    sgm304    like sgm_file.sgm304    , # 合併转入量
    sgm311    like sgm_file.sgm311    , # 良品转出量
    sgm312    like sgm_file.sgm312    , # 重工转出
    sgm313    like sgm_file.sgm313    , # 当站报废量
    sgm314    like sgm_file.sgm314    , # 当站下线量（入库）
    sgm315    like sgm_file.sgm315    , # Bonus     Qty
    sgm316    like sgm_file.sgm316    , # 分割转出量
    sgm317    like sgm_file.sgm317    , # 合并转出量
    sgm321    like sgm_file.sgm321    , # 委外加工量
    sgm322    like sgm_file.sgm322    , # 委外完工量
    sgm52     like sgm_file.sgm52     , #委外否
    sgm53     like sgm_file.sgm53     , #PQC     否
    sgm54     like sgm_file.sgm54     , #Check     in     否
    ta_sgm01  like sgm_file.ta_sgm01, #   生产说明
    ta_sgm02  like sgm_file.ta_sgm02, #   使用工具
    ta_sgm03  like sgm_file.ta_sgm03, #   使用程序
    ta_sgm06  like sgm_file.ta_sgm06 #   报工否
end record

type tc_shb record
    tc_shb03     like tc_shb_file.tc_shb03, # LOT单号
    tc_shb06     like tc_shb_file.tc_shb06, # 作业序号
    tc_shb08     like tc_shb_file.tc_shb08, # 作业编号
    tc_shb01     like tc_shb_file.tc_shb01, # 开工/完工
    tc_shb02     like tc_shb_file.tc_shb02, # 报工单号
    tc_shb14     like tc_shb_file.tc_shb14, # 报工日期
    tc_shb15     like tc_shb_file.tc_shb15, # 报工时间
    tc_shb04     like tc_shb_file.tc_shb04, # 工单单号
    tc_shb07     like tc_shb_file.tc_shb07, # 工序序号
    tc_shb05     like tc_shb_file.tc_shb05, # 生产料号
    tc_shb16     like tc_shb_file.tc_shb16, # 生产单位
    ima02tc_shb  like ima_file.ima02, #    品名
    ima021tc_shb like ima_file.ima021,, #     规格
    tc_shb09     like tc_shb_file.tc_shb09, # 工作站
    tc_shb10     like tc_shb_file.tc_shb10, # 委外否
    tc_shb11     like tc_shb_file.tc_shb11, # 报工人员
    gen02tc_shb  like gen_file.gen02, #    姓名
    tc_shb12     like tc_shb_file.tc_shb12, # 数量
    tc_shbud09   like tc_shb_file.tc_shbud09 , #   PNL数量
    tc_shbud121  like tc_shb_file.tc_shbud121, #    报废数量
    tc_shbud122  like tc_shb_file.tc_shbud122, #    反共数量
    tc_shb13     like tc_shb_file.tc_shb13, # 线班别
    tc_shb17     like tc_shb_file.tc_shb17 # 转移单号
end record

type tc_shb_2 record
    tc_shb03_2     like tc_shb_file.tc_shb03, # LOT单号
    tc_shb06_2     like tc_shb_file.tc_shb06, # 作业序号
    tc_shb08_2     like tc_shb_file.tc_shb08, # 作业编号
    tc_shb01_2     like tc_shb_file.tc_shb01, # 开工/完工
    tc_shb02_2     like tc_shb_file.tc_shb02, # 报工单号
    tc_shb14_2     like tc_shb_file.tc_shb14, # 报工日期
    tc_shb15_2     like tc_shb_file.tc_shb15, # 报工时间
    tc_shb04_2     like tc_shb_file.tc_shb04, # 工单单号
    tc_shb07_2     like tc_shb_file.tc_shb07, # 工序序号
    tc_shb05_2     like tc_shb_file.tc_shb05, # 生产料号
    tc_shb16_2     like tc_shb_file.tc_shb16, # 生产单位
    ima02tc_shb_2  like ima_file.ima02, #    品名
    ima021tc_shb_2 like ima_file.ima021,, #     规格
    tc_shb09_2     like tc_shb_file.tc_shb09, # 工作站
    tc_shb10_2     like tc_shb_file.tc_shb10, # 委外否
    tc_shb11_2     like tc_shb_file.tc_shb11, # 报工人员
    gen02tc_shb_2  like gen_file.gen02, #    姓名
    tc_shb12_2     like tc_shb_file.tc_shb12, # 数量
    tc_shbud09_2   like tc_shb_file.tc_shbud09 , #   PNL数量
    tc_shbud121_2  like tc_shb_file.tc_shbud121, #    报废数量
    tc_shbud122_2  like tc_shb_file.tc_shbud122, #    反共数量
    tc_shb13_2     like tc_shb_file.tc_shb13, # 线班别
    tc_shb17_2     like tc_shb_file.tc_shb17 # 转移单号
end record
end globals
