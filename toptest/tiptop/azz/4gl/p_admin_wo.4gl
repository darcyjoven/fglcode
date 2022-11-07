# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: p_admin_wo.4gl
# Descriptions...: 管理员工单处理工具
# Date & Author..: 22/11/02 By darcy

database ds
globals "../../config/top.global"
# ---
type sfb record
    checksfb like type_file.chr1,
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
    checksfa like type_file.chr1,
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
    checksgm like type_file.chr1,
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
    checktc_shb  like type_file.chr1,
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
    ima021tc_shb like ima_file.ima021, #     规格
    tc_shb09     like tc_shb_file.tc_shb09, # 工作站
    tc_shb10     like tc_shb_file.tc_shb10, # 委外否
    tc_shb11     like tc_shb_file.tc_shb11, # 报工人员
    gen02tc_shb  like gen_file.gen02, #    姓名
    tc_shb12     like tc_shb_file.tc_shb12, # 数量
    tc_shbud09   like tc_shb_file.tc_shbud09 , #   PNL数量
    tc_shb121    like tc_shb_file.tc_shb121, #    报废数量
    tc_shb122    like tc_shb_file.tc_shb122, #    反工数量
    tc_shb13     like tc_shb_file.tc_shb13, # 线班别
    tc_shb17     like tc_shb_file.tc_shb17 # 转移单号
end record
type tc_shb_2 record
    checktc_shb_2  like type_file.chr1,
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
    ima021tc_shb_2 like ima_file.ima021, #     规格
    tc_shb09_2     like tc_shb_file.tc_shb09, # 工作站
    tc_shb10_2     like tc_shb_file.tc_shb10, # 委外否
    tc_shb11_2     like tc_shb_file.tc_shb11, # 报工人员
    gen02tc_shb_2  like gen_file.gen02, #    姓名
    tc_shb12_2     like tc_shb_file.tc_shb12, # 数量
    tc_shbud09_2   like tc_shb_file.tc_shbud09 , #   PNL数量
    tc_shb121_2    like tc_shb_file.tc_shb121, #    报废数量
    tc_shb122_2    like tc_shb_file.tc_shb122, #    反共数量
    tc_shb13_2     like tc_shb_file.tc_shb13, # 线班别
    tc_shb17_2     like tc_shb_file.tc_shb17 # 转移单号
end record
# ---
# ---
define   w    ui.Window
define   f    ui.Form
define   page om.DomNode
# ---

# ---
# 主资料
define g_sfb,g_sfb_excel dynamic array of sfb
define g_sfa,g_sfa_excel dynamic array of sfa
define g_sgm,g_sgm_excel dynamic array of sgm
define g_tc_shb,g_tc_shb_excel dynamic array of tc_shb
define g_tc_shb_2,g_tc_shb_2_excel dynamic array of tc_shb_2
# ---

# ---
define g_b_flag integer
define g_rec_b integer # 单身总比数
define g_cnt integer #总笔数
define l_ac,l_ac_t integer #单身当前笔数
# ---

# ---
# 工单条件和lot条件
define g_wc1,g_wc2 string
# ---

# ---
define flag_sfb         like type_file.chr1
define flag_sfa         like type_file.chr1
define flag_sgm         like type_file.chr1
define flag_tc_shb      like type_file.chr1
define flag_tc_shb_2    like type_file.chr1
# ---

main
    define   p_row,p_col   like type_file.num5          #no.fun-680121 smallint
    options                               #改變一些系統預設值
        input no wrap
    defer interrupt
 
    if (not cl_user()) then
        exit program
    end if
 
    whenever error call cl_err_msg_log
 
    if (not cl_setup("AZZ")) then
        exit program
    end if
    
    call cl_used(g_prog,g_time,1) returning g_time #no.fun-b30211 
    open window p_admin_wo at p_row,p_col with form "azz/42f/p_admin_wo"
            attribute (style = g_win_style clipped) #no.fun-580092 hcn
        
    call cl_ui_init()

    call p_admin_wo()

    close window p_admin_wo                 #結束畫面
    call  cl_used(g_prog,g_time,2) returning g_time 
end main
# declear
function p_admin_wo_curs()
    # ---
    define l_sql   string
    # ---

    # ---
    # page1工单清单查询
    
    # ---

end function
# 查询条件
function p_admin_wo_cs()
    clear form
    let g_action_choice=" "

    dialog
        construct g_wc1 on sfb01,sfb05,sfb06 from sfb01_q,sfb05_q,sfb06_q
            before construct
        end construct
        construct g_wc2 on sgm01,sgm03,sgm04 from sgm01_q,sgm03_q,sgm04_q
            before construct
        end construct

        on action controlp
            # 开窗
        on action allotment
            let g_b_flag = "1"
 
        on action routing
            let g_b_flag = "2"
 
        on action sub_po
            let g_b_flag = "3"
 
        on action issue
            let g_b_flag = "4"
 
        on action fqc
            let g_b_flag = "5"
        
        on action accept
            let g_action_choice="accept"
            exit dialog

        on action cancel
            let g_action_choice="exit"
            exit dialog

        on action exit
            let g_action_choice="exit"
            exit dialog

        on action qbe_select
            call cl_qbe_select()

        on action qbe_save
            call cl_qbe_save()
        
        on idle g_idle_seconds
            call cl_on_idle()
            continue dialog
        
        on action about
            call cl_about()
        
        on action controlg
            call cl_cmdask()
        
        on action help
            call cl_show_help()

    end dialog

    if int_flag or g_action_choice = "exit" then    #mod-4b0238 add 'exit'
        return
    end if
end function
# main
function p_admin_wo()
    call p_admin_wo_ctr_temp()
    call p_admin_wo_menu()
end function
# 菜单
function p_admin_wo_menu()
    while true
        case g_b_flag
            when '1'
                call p_admin_wo_bp1("G")
            when '2'
                call p_admin_wo_bp2("G")
            when '3'
                call p_admin_wo_bp3("G")
            when '4'
                call p_admin_wo_bp4("G")
            when '5'
                call p_admin_wo_bp5("G")
            otherwise
                call p_admin_wo_bp1("G")
        end case

        case g_action_choice
            when "help"
            call cl_show_help()
 
            when "exit"
                exit while
            when "close"
                exit while
    
            when "controlg"
                call cl_cmdask()

            when "query"
                if cl_chk_act_auth() then
                    call p_admin_wo_q()
                end if
            
            when "exporttoexcel"
                # 导出excel
                if cl_chk_act_auth() then
                    let w = ui.window.getcurrent()
                    let f = w.getform()
                    case g_b_flag
                        when '1'
                            let page = f.FindNode("Page","page01")
                            call cl_export_to_excel(page,base.TypeInfo.create(g_sfb_excel),'','')
                        when '2'
                            let page = f.FindNode("Page","page02")
                            call cl_export_to_excel(page,base.TypeInfo.create(g_sfa_excel),'','')
                        when '3'
                            let page = f.FindNode("Page","page03")
                            call cl_export_to_excel(page,base.TypeInfo.create(g_sgm_excel),'','')
                        when '4'
                            let page = f.FindNode("Page","page04")
                            call cl_export_to_excel(page,base.TypeInfo.create(g_tc_shb_excel),'','')
                        when '5'
                            let page = f.FindNode("Page","page05")
                            call cl_export_to_excel(page,base.TypeInfo.create(g_tc_shb_2_excel),'','')
                    end case
                end if
            # TODO:功能按钮 s---

            # TODO:功能按钮 e---
        end case
    end while
end function
# 查询
function p_admin_wo_q()
    let g_b_flag = "1"
    let g_rec_b = 0

    clear form
    let flag_sfb = 'N'
    let flag_sfa = 'N'
    let flag_sgm = 'N'
    let flag_tc_shb = 'N'
    let flag_sfb = 'N'

    display g_rec_b to cn2
    call cl_opmsg('q')

    MESSAGE ""
    display '   ' to formonly.cnt

    call p_admin_wo_cs()
    if int_flag or g_action_choice="exit" then
        let int_flag = 0
        return
    end if
    message " searching ! "

    if sqlca.sqlcode then
        call cl_err('',sqlca.sqlcode,0)
    else
        call p_admin_wo_show()
    end if
    message ""
end function

# 查询
function p_admin_wo_show()
    let g_b_flag = '1'
    # call p_admin_wo_fill_sfb(g_wc1,g_wc2)
end function
function p_admin_wo_fill_sfb(p_wc1,p_wc2)
    # ---
    define p_wc1 string
    define p_wc2 string
    define l_sql string
    # ---

    # ---
    if flag_sfb = 'Y' then
        return
    end if
    let flag_sfb = 'Y'
    # ---

    # ---
    if p_wc2 = ' 1=1' then
        let l_sql = " SELECT 'Y',sfb01,sfb02,sfb81,sfb87,sfb28,sfb38,sfb44, ",
                    "        gen02,sfb98,sfb05,sfb06,sfb071,ima02,ima021,sfbud08, ",
                    "        sfbud09,sfb08,sfbud07,sfb081,sfb09,sfb12,sfbud12, ",
                    "        sfb22,sfb221,sfb86,sfb89,sfb99 ",
                    " from sfb_file,gen_file,ima_file ",
                    " WHERE  gen01 = sfb44 and ima01 = sfb05",
                    " and ",p_wc1 clipped
    else
        let l_sql = "select unique 'Y',sfb01,sfb02,sfb81,sfb87,sfb28,sfb38,sfb44, ",
                    "       gen02,sfb98,sfb05,sfb06,sfb071,ima02,ima021,sfbud08, ",
                    "       sfbud09,sfb08,sfbud07,sfb081,sfb09,sfb12,sfbud12, ",
                    "       sfb22,sfb221,sfb86,sfb89,sfb99 ",
                    " from sfb_file,sgm_file,gen_file,ima_file ",
                    " where sfb01 = sgm02 and gen01 = sfb44 and ima01 = sfb05 ",
                    " and ",p_wc1 clipped," and ",p_wc2 clipped
    end if
    prepare p_admin_wo_fill_sfb_p from l_sql
    declare p_admin_wo_fill_sfb cursor for p_admin_wo_fill_sfb_p

    let g_cnt = 1
    call g_sfb_excel.clear()
    call g_sfb.clear()
    
    foreach p_admin_wo_fill_sfb into g_sfb_excel[g_cnt].*
        if status then
            call cl_err("p_admin_wo_fill_sfb",status,1)
            exit foreach
        end if
        if g_cnt > g_max_rec then
            call cl_err( '', 9035, 0 )
            exit foreach
        else
            let g_sfb[g_cnt].* = g_sfb_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_sfb_excel.deleteElement(g_cnt)
    let g_cnt = g_cnt - 1
    # ---
end function
function p_admin_wo_fill_sfa(p_wc)
    define p_wc string
    define l_sql string

    # ---
    if flag_sfa = 'Y' then
        return
    end if
    let flag_sfa = 'Y'
    # ---

    # ---
    let l_sql = " select 'Y',sfa01,sfa03,ima02,ima021,sfa27,sfa26,",
                "         sfa28,sfa08,ima08,sfa12,sfa11,sfa16,",
                "         sfa161,sfa05,sfa06,sfa065,sfa062,sfa063,",
                "         sfa064,sfa100,sfaud08",
                " from sfa_file,sfb_file,ima_file",
                " where sfa01=sfb01 and ima01 =sfa03",
                " and ",p_wc,
                " order by sfa01,sfa03,sfa27,sfa08"
    prepare p_admin_wo_fill_sfa_p from l_sql
    declare p_admin_wo_fill_sfa cursor for p_admin_wo_fill_sfa_p

    # delete from sfa_temp
    let g_cnt = 1
    call g_sfa_excel.clear()
    call g_sfa.clear()
    
    foreach p_admin_wo_fill_sfa into g_sfa_excel[g_cnt].*
        if status then
            call cl_err("p_admin_wo_fill_sfa",status,1)
            exit foreach
        end if
        if status then
            call cl_err("ins sfa_temp",status,1)
            return
        end if
        if g_cnt > g_max_rec then
            call cl_err( '', 9035, 0 )
            exit foreach
        else
            let g_sfa[g_cnt].* = g_sfa_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_sfa_excel.deleteElement(g_cnt)
    let g_cnt = g_cnt - 1
    # ---

end function
function p_admin_wo_fill_sgm(p_wc)
    define p_wc string
    define l_sql string

    # ---
    if flag_sgm = 'Y' then
        return
    end if
    let flag_sgm = 'Y'
    # ---

    # ---
    let l_sql = " select 'Y',sgm01,sgm02,sgm11,sgm03_par,ima02,ima021,sgm03,",
                "     sgm04,sgm45,sgm05,sgm06,sgm14,sgm15,sgm16,sgm65,sgm301,",
                "     sgm302,sgm303,sgm304,sgm311,sgm312,sgm313,sgm314,sgm315,",
                "     sgm316,sgm317,sgm321,sgm322,sgm52,sgm53,sgm54,ta_sgm01,",
                "     ta_sgm02,ta_sgm03,ta_sgm06 ",
                " from sgm_file,ima_file,sfb_temp",
                " where sgm03_par = ima01 AND sgm03_par = sfb05 AND sgm02 = sfb01",
                " and ",p_wc clipped,
                " order by  sgm03,sgm01"
    prepare p_admin_wo_fill_sgm_p from l_sql
    declare p_admin_wo_fill_sgm cursor for p_admin_wo_fill_sgm_p
 
    let g_cnt = 1
    call g_sgm_excel.clear()
    call g_sgm.clear()
    
    foreach p_admin_wo_fill_sgm into g_sgm_excel[g_cnt].*
        if status then
            call cl_err("p_admin_wo_fill_sgm",status,1)
            exit foreach
        end if
        if status then
            call cl_err("ins sgm_temp",status,1)
            return
        end if
        if g_cnt > g_max_rec then
            call cl_err( '', 9035, 0 )
            exit foreach
        else
            let g_sgm[g_cnt].* = g_sgm_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_sgm_excel.deleteElement(g_cnt)
    let g_cnt = g_cnt - 1
    # ---

end function
function p_admin_wo_fill_tc_shb()
    define l_sql string

    # ---
    if flag_tc_shb = 'Y' then
        return
    end if
    let flag_tc_shb = 'Y'
    # ---

    # ---
    let l_sql = "select 'Y',tc_shb03,tc_shb06,tc_shb08,tc_shb01,tc_shb02,tc_shb14,",
                " tc_shb15,tc_shb04,tc_shb07,tc_shb05,tc_shb16,ima02,ima021,tc_shb09,tc_shb10,",
                " tc_shb11,gen02,tc_shb12,tc_shbud09,tc_shb121,tc_shb122,tc_shb13,tc_shb17",
                " from tc_shb_file,ima_file,gen_file,sgm_temp",
                " where ima01 = tc_shb05 and gen01 = tc_shb11 ",
                " and tc_shb03 = sgm01 and tc_shb06 = sgm03",
                " order by tc_shb01,tc_shb06,tc_shb03"

    prepare p_admin_wo_fill_tc_shb_p from l_sql
    declare p_admin_wo_fill_tc_shb cursor for p_admin_wo_fill_tc_shb_p
 
    let g_cnt = 1
    call g_tc_shb_excel.clear()
    call g_tc_shb.clear()
    
    foreach p_admin_wo_fill_tc_shb into g_tc_shb_excel[g_cnt].*
        if status then
            call cl_err("p_admin_wo_fill_tc_shb",status,1)
            exit foreach
        end if
        if status then
            call cl_err("ins tc_shb_temp",status,1)
            return
        end if
        if g_cnt > g_max_rec then
            call cl_err( '', 9035, 0 )
            exit foreach
        else
            let g_tc_shb[g_cnt].* = g_tc_shb_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_tc_shb_excel.deleteElement(g_cnt)
    let g_cnt = g_cnt - 1
    # ---
end function
function p_admin_wo_fill_tc_shb_2()
    define l_sql string

    # ---
    if flag_tc_shb_2 = 'Y' then
        return
    end if
    let flag_tc_shb_2 = 'Y'
    # ---

    # ---
    let l_sql = "select 'Y',tc_shb03,tc_shb06,tc_shb08,tc_shb01,tc_shb02,tc_shb14,",
                " tc_shb15,tc_shb04,tc_shb07,tc_shb05,tc_shb16,ima02,ima021,tc_shb09,tc_shb10,",
                " tc_shb11,gen02,tc_shb12,tc_shbud09,tc_shb121,tc_shb122,tc_shb13,tc_shb17",
                " from tc_shb_file,ima_file,gen_file,sgm_temp",
                " where ima01 = tc_shb05 and gen01 = tc_shb11 ",
                " and tc_shb03 = sgm01 and tc_shb06 = sgm03 and tc_shb121 >0 and tc_shb01 =2",
                " order by tc_shb01,tc_shb06,tc_shb03"

    prepare p_admin_wo_fill_tc_shb_2_p from l_sql
    declare p_admin_wo_fill_tc_shb_2 cursor for p_admin_wo_fill_tc_shb_2_p
 
    let g_cnt = 1
    call g_tc_shb_2_excel.clear()
    call g_tc_shb_2.clear()
    
    foreach p_admin_wo_fill_tc_shb_2 into g_tc_shb_2_excel[g_cnt].*
        if status then
            call cl_err("p_admin_wo_fill_tc_shb_2",status,1)
            exit foreach
        end if
        if g_cnt > g_max_rec then
            call cl_err( '', 9035, 0 )
            exit foreach
        else
            let g_tc_shb_2[g_cnt].* = g_tc_shb_2_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_tc_shb_2_excel.deleteElement(g_cnt)
    let g_cnt = g_cnt - 1
end function

function p_admin_wo_ctr_temp()
    whenever any error continue
        drop table sfb_temp
        drop table sgm_temp
    whenever any error stop
    create temp table sfb_temp(
        sfb01   varchar(20),
        sfb05   varchar(40)
    )
    create temp table sgm_temp(
        sgm01   varchar(23),
        sgm03   integer
    )
end function

function p_admin_wo_bp1(p_ud)
    define   p_ud   like type_file.chr1
    define   l_index    integer

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " "

    call p_admin_wo_fill_sfb(g_wc1,g_wc2)

    call cl_set_act_visible("accept,cancel", false)
    display g_sfb.getLength() to cn2

    input array g_sfb without defaults from s_sfb.*
        attribute(count=g_rec_b,maxcount=g_max_rec,unbuffered,
        insert row=false,delete row=false,append row=false)

        before input
            let l_ac = arr_curr()
            display l_ac to formonly.cnt
        on action help
            let g_action_choice="help"
            exit input
        on action exit
            let g_action_choice="exit"
            exit input
        on action controlg
            let g_action_choice="controlg"
            exit input
        on action query
            let g_action_choice="query"
            exit input 
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit input
        on idle g_idle_seconds
            call cl_on_idle()
            continue input
        on action close
            let g_action_choice = 'close'
            exit input

        on row change

        on action checkall
            for l_index = 1 to g_sfb.getLength()
                let g_sfb[l_index].checksfb = 'Y'
            end for
        on action inverse
            for l_index = 1 to g_sfb.getLength()
                if g_sfb[l_index].checksfb = 'Y' then
                    let g_sfb[l_index].checksfb = 'N'
                else
                    let g_sfb[l_index].checksfb = 'Y'
                end if
            end for

        on action routing
            let g_action_choice = 'fill'
            let g_b_flag = '2'
            call p_admin_wo_page1_check()
            exit input
        on action sub_po
            let g_action_choice = 'fill'
            let g_b_flag = '3'
            call p_admin_wo_page1_check()
            exit input
        on action issue
            let g_action_choice = 'fill'
            let g_b_flag = '4'
            call p_admin_wo_page1_check()
            call p_admin_wo_fill_sgm(g_wc2)
            call p_admin_wo_page3_check()
            exit input
        on action fqc
            let g_action_choice = 'fill'
            let g_b_flag = '5'
            call p_admin_wo_page1_check()
            call p_admin_wo_fill_sgm(g_wc2)
            call p_admin_wo_page3_check()
            exit input

        # TODO: 功能按钮 s---
        
        on action updsfb12
            # 更新作废数量
            call p_admin_wo_updsfb12()

        # TODO: 功能按钮 e---
    end input
    call cl_set_act_visible("accept,cancel", true)
end function
function p_admin_wo_bp2(p_ud)
    define   p_ud   like type_file.chr1
    define   l_wc   string
    define   l_index    integer

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " "

    let l_wc = " (sfb01,sfb05) in (select sfb01,sfb05 from sfb_temp) "
    call p_admin_wo_fill_sfa(l_wc)

    display g_sfa.getLength() to cn2
    call cl_set_act_visible("accept,cancel", false)

    input array g_sfa without defaults from s_sfa.*
        attribute(count=g_rec_b,maxcount=g_max_rec,unbuffered,
        insert row=false,delete row=false,append row=false)

        before input
            let l_ac = arr_curr()
            display l_ac to formonly.cnt

        on action help
            let g_action_choice="help"
            exit input
        on action exit
            let g_action_choice="exit"
            exit input
        on action controlg
            let g_action_choice="controlg"
            exit input
        on action query
            let g_action_choice="query"
            exit input 
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit input
        on idle g_idle_seconds
            call cl_on_idle()
            continue input
        on action close
            let g_action_choice = 'close'
            exit input
            
        on action allotment
            let g_action_choice = 'fill'
            let g_b_flag = '1'
            exit input
        on action sub_po
            let g_action_choice = 'fill'
            let g_b_flag = '3'
            exit input
        on action issue
            let g_action_choice = 'fill'
            let g_b_flag = '4'
            exit input
        on action fqc
            let g_action_choice = 'fill'
            let g_b_flag = '5'
            exit input
        
        on action checkall
            for l_index = 1 to g_sfa.getLength()
                let g_sfa[l_index].checksfa = 'Y'
            end for
        on action inverse
            for l_index = 1 to g_sfa.getLength()
                if g_sfa[l_index].checksfa = 'Y' then
                    let g_sfa[l_index].checksfa = 'N'
                else
                    let g_sfa[l_index].checksfa = 'Y'
                end if
            end for

        # TODO: 功能按钮 s---
        # TODO: 功能按钮 e---
    end input
    call cl_set_act_visible("accept,cancel", true)
end function
function p_admin_wo_bp3(p_ud)
    define   p_ud   like type_file.chr1
    define   l_index    integer

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " "

    call p_admin_wo_fill_sgm(g_wc2)

    display g_sgm.getLength() to cn2
    call cl_set_act_visible("accept,cancel", false)

    input array g_sgm without defaults from s_sgm.*
        attribute(count=g_rec_b,maxcount=g_max_rec,unbuffered,
        insert row=false,delete row=false,append row=false)

        before input
            let l_ac = arr_curr()
            display l_ac to formonly.cnt

        on action help
            let g_action_choice="help"
            exit input
        on action exit
            let g_action_choice="exit"
            exit input
        on action controlg
            let g_action_choice="controlg"
            exit input
        on action query
            let g_action_choice="query"
            exit input 
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit input
        on idle g_idle_seconds
            call cl_on_idle()
            continue input
        on action close
            let g_action_choice = 'close'
            exit input
            
        on action allotment
            let g_action_choice = 'fill'
            let g_b_flag = '1'
            call p_admin_wo_page3_check()
            exit input
        on action routing
            let g_action_choice = 'fill'
            let g_b_flag = '2'
            call p_admin_wo_page3_check()
            exit input
        on action issue
            let g_action_choice = 'fill'
            let g_b_flag = '4'
            call p_admin_wo_page3_check()
            exit input
        on action fqc
            let g_action_choice = 'fill'
            let g_b_flag = '5'
            call p_admin_wo_page3_check()
            exit input
        
        on action checkall
            for l_index = 1 to g_sgm.getLength()
                let g_sgm[l_index].checksgm = 'Y'
            end for
        on action inverse
            for l_index = 1 to g_sgm.getLength()
                if g_sgm[l_index].checksgm = 'Y' then
                    let g_sgm[l_index].checksgm = 'N'
                else
                    let g_sgm[l_index].checksgm = 'Y'
                end if
            end for

        # TODO: 功能按钮 s---
        # TODO: 功能按钮 e---
    end input
    call cl_set_act_visible("accept,cancel", true)
end function
function p_admin_wo_bp4(p_ud)
    define   p_ud   like type_file.chr1
    define   l_index    integer

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " "

    call p_admin_wo_fill_tc_shb()

    display g_tc_shb.getLength() to cn2
    call cl_set_act_visible("accept,cancel", false)

    input array g_tc_shb without defaults from s_tc_shb.*
        attribute(count=g_rec_b,maxcount=g_max_rec,unbuffered,
        insert row=false,delete row=false,append row=false)

        before input
            let l_ac = arr_curr()
            display l_ac to formonly.cnt

        on action help
            let g_action_choice="help"
            exit input
        on action exit
            let g_action_choice="exit"
            exit input
        on action controlg
            let g_action_choice="controlg"
            exit input
        on action query
            let g_action_choice="query"
            exit input 
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit input
        on idle g_idle_seconds
            call cl_on_idle()
            continue input
        on action close
            let g_action_choice = 'close'
            exit input
            
        on action allotment
            let g_action_choice = 'fill'
            let g_b_flag = '1'
            exit input
        on action routing
            let g_action_choice = 'fill'
            let g_b_flag = '2'
            exit input
        on action sub_po
            let g_action_choice = 'fill'
            let g_b_flag = '3'
            exit input
        on action fqc
            let g_action_choice = 'fill'
            let g_b_flag = '5'
            exit input
        
        on action checkall
            for l_index = 1 to g_tc_shb.getLength()
                let g_tc_shb[l_index].checktc_shb = 'Y'
            end for
        on action inverse
            for l_index = 1 to g_tc_shb.getLength()
                if g_tc_shb[l_index].checktc_shb = 'Y' then
                    let g_tc_shb[l_index].checktc_shb = 'N'
                else
                    let g_tc_shb[l_index].checktc_shb = 'Y'
                end if
            end for

        # TODO: 功能按钮 s---
        # TODO: 功能按钮 e---
    end input
    call cl_set_act_visible("accept,cancel", true)
end function
function p_admin_wo_bp5(p_ud)
    define   p_ud   like type_file.chr1
    define   l_index    integer

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " "

    call p_admin_wo_fill_tc_shb_2()

    display g_tc_shb_2.getLength() to cn2
    call cl_set_act_visible("accept,cancel", false)

    input array g_tc_shb_2 without defaults from s_tc_shb_2.*
        attribute(count=g_rec_b,maxcount=g_max_rec,unbuffered,
        insert row=false,delete row=false,append row=false)

        before input
            let l_ac = arr_curr()
            display l_ac to formonly.cnt

        on action help
            let g_action_choice="help"
            exit input
        on action exit
            let g_action_choice="exit"
            exit input
        on action controlg
            let g_action_choice="controlg"
            exit input
        on action query
            let g_action_choice="query"
            exit input 
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit input
        on idle g_idle_seconds
            call cl_on_idle()
            continue input
        on action close
            let g_action_choice = 'close'
            exit input
            
        on action allotment
            let g_action_choice = 'fill'
            let g_b_flag = '1'
            exit input
        on action routing
            let g_action_choice = 'fill'
            let g_b_flag = '2'
            exit input
        on action sub_po
            let g_action_choice = 'fill'
            let g_b_flag = '3'
            exit input
        on action issue
            let g_action_choice = 'fill'
            let g_b_flag = '4'
            exit input
        
        on action checkall
            for l_index = 1 to g_tc_shb_2.getLength()
                let g_tc_shb_2[l_index].checktc_shb_2 = 'Y'
            end for
        on action inverse
            for l_index = 1 to g_tc_shb_2.getLength()
                if g_tc_shb_2[l_index].checktc_shb_2 = 'Y' then
                    let g_tc_shb_2[l_index].checktc_shb_2 = 'N'
                else
                    let g_tc_shb_2[l_index].checktc_shb_2 = 'Y'
                end if
            end for

        # TODO: 功能按钮 s---
        # TODO: 功能按钮 e---
    end input
    call cl_set_act_visible("accept,cancel", true)
end function

function p_admin_wo_page1_check()
    define l_index  integer

    # ---
    let flag_sgm = 'N'
    let flag_sfa = 'N'
    let flag_tc_shb = 'N'
    let flag_tc_shb_2 = 'N'
    # ---

    delete from sfb_temp
    begin work
    for l_index = 1 to g_sfb.getLength()
        if g_sfb[l_index].checksfb = 'Y' then
            insert into sfb_temp values (g_sfb[l_index].sfb01,g_sfb[l_index].sfb05)
            if status then
                call cl_err("ins sfb_temp",status,1)
                rollback work
                return
            end if
        end if
    end for
    commit work
end function

function p_admin_wo_page3_check()
    define l_index  integer

    let flag_tc_shb = 'N'
    let flag_tc_shb_2 = 'N'
    
    delete from sgm_temp
    begin work
    for l_index = 1 to g_sgm.getLength()
        if g_sgm[l_index].checksgm = 'Y' then
            insert into sgm_temp values (g_sgm[l_index].sgm01,g_sgm[l_index].sgm03)
            if status then
                call cl_err("ins sgm_temp",status,1)
                rollback work
                return
            end if
        end if
    end for
    commit work
end function

#  更新报废数量
function p_admin_wo_updsfb12()
    define l_index integer
    define l_sfb12 decimal(15,3)
    define l_msg   string

    begin work
    call s_showmsg_init()

    for l_index = 1 to g_sfb.getlength()
        if g_sfb[l_index].checksfb ='Y' then
            let l_sfb12 = 0 
            select sum(sgm313) into l_sfb12 from sgm_file where sgm02 = g_sfb[l_index].sfb01
            if cl_null(l_sfb12) then let l_sfb12 = 0 end if
            if l_sfb12 != g_sfb[l_index].sfb12 then
                update sfb_file set sfb12 = l_sfb12 where sfb01 = g_sfb[l_index].sfb01
                if status then
                    call cl_err("upd sfb",status,1)
                    rollback work
                    return
                end if
                let l_msg = "工单:",g_sfb[l_index].sfb01,"报废数量:",l_sfb12
                call s_errmsg("sfb12",g_sfb[l_index].sfb12,l_msg,'czz-006',1)
            end if
        end if
    end for
    call s_showmsg()
    
    if cl_confirm('czz-008') then
        commit work
    else
        rollback work
    end if
end function
