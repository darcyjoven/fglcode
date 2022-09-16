# DATABASE ds
 
GLOBALS "../../config/top.global"

function cs_ima02(imz01)
    define imz01    like imz_file.imz01

    define ima021   like ima_file.ima021

    define l_tc_cmb dynamic array of record
        tc_cmb03    like tc_cmb_file.tc_cmb03,
        tc_cmb04    like tc_cmb_file.tc_cmb04,
        tc_cmb06    like tc_cmb_file.tc_cmb06
        end record
    define l_tc_cmb_t dynamic array of record
        tc_cmb03    like tc_cmb_file.tc_cmb03,
        tc_cmb04    like tc_cmb_file.tc_cmb04,
        tc_cmb06    like tc_cmb_file.tc_cmb06
        end record
    define cnt,index    like type_file.num5
    define  tok base.StringTokenizer

    define l_ac,l_n,count     like type_file.num5

    open window cs_ima02 with form "csub/42f/cs_ima02"
      attribute (style = g_win_style clipped) 

    # 资料查询

    declare cs_ima02 cursor for 
        select tc_cmb03,tc_cmb04,tc_cmb06 from tc_cmb_file,tc_cma_file
         where tc_cmb01 = imz01 and tc_cmb01=tc_cma01 and tc_cma03 ='Y'
    let cnt = 1
    foreach cs_ima02 into l_tc_cmb[cnt].*
        if sqlca.sqlcode then
            call cl_err("cs_ima02",sqlca.sqlcode,1)
            exit foreach
        end if
        
        let l_tc_cmb_t[cnt].* = l_tc_cmb[cnt].*
         
        let l_tc_cmb[cnt].tc_cmb06 = ""
        let cnt = cnt + 1
    end foreach
    call l_tc_cmb.deleteElement(cnt)
    let count = cnt - 1

    ## 
    input array l_tc_cmb from cs_ima02.*
        attribute (insert row =false ,append row = false,maxcount=count)

        before row
            let l_ac = arr_curr()
            let l_n = arr_count()
            call cl_set_combo_items("tc_cmb06",l_tc_cmb_t[l_ac].tc_cmb06,l_tc_cmb_t[l_ac].tc_cmb06)
        after row

        on row change
        
    end input

    close window cs_ima02
    return ima021
end function
