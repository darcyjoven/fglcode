database ds
 
globals "../../../tiptop/config/top.global"
globals "../../../tiptop/config/darcy.global"


type ima record
        ima01   like ima_file.ima01,
        ima02   like ima_file.ima02,
        ima021  like ima_file.ima021,
        ima25   like ima_file.ima25
        end record
define imas dynamic array of  ima
main
    # call cimi999_demo()
    # call cimi999_xml()
    # call cimi999_dur()
    # call cimi999_xml()
    # call cs_darcy_efficiency("begin")
    # call cimi999_get_data()
    # call cimi999_insdb()
    call cimi999_fastexcel()
end main

function cimi999_fastexcel()
    define s like type_file.chr1
    define f string
    database forewin

    whenever any error continue
        drop table darcy_ima1
        drop table darcy_sfb1
    whenever any error stop

    if not cs_darcy_crt_table("darcy_ima1","select ima01,ima02 from ima_file") then
        return
    end if
    if not cs_darcy_crt_table("darcy_sfb1","select sfb01,sfb02 from sfb_file") then
        return
    end if
    if not cs_darcy_set_title(
        "darcy_ima1",
        "料件编号,品名",
        "料件基础资料") then
        return
    end if
    if not cs_darcy_set_title(
        "darcy_sfb1",
        "工单号,类型",
        "工单资料") then
        return
    end if

    call cs_darcy_excel("darcy_ima1,darcy_sfb1","cimi999") returning f,s

    drop table darcy_ima1
    drop table darcy_sfb1

end function

function cimi999_xml()
    # data 4s
    # string 16s
    # xml 2m6s
    # file 1s
    call cimi999_get_data()
    call cimi999_crt_xml()
end function

function cimi999_get_data()
    define i integer
    #  开始
    declare ima_cur cursor for
        select ima01,ima02,ima021,ima25 from forewin.ima_file
    let i = 1
    foreach ima_cur into imas[i].*
        if sqlca.sqlcode then
            call cl_err("error",sqlca.sqlcode,1)
            return
        end if
        let i = i + 1
    end foreach
    call cs_darcy_efficiency("data")
    call imas.deleteElement(i)
    let i = i - 1 
end function
function cimi999_crt_xml()
    define type dynamic array of string
    define i,j integer
    define doc om.DomDocument
    define node om.DomNode
    define err varchar(1)
    define file string

    # 转为string二维数组
    for i = 1 to imas.getLength()
        let darcy_data[i,1] = imas[i].ima01
        let darcy_data[i,2] = imas[i].ima02
        let darcy_data[i,3] = imas[i].ima021
        let darcy_data[i,4] = imas[i].ima25
    end for
    call cs_darcy_efficiency("string")

    let doc = om.DomDocument.create('Excel')
    call cs_append_sheets(doc,"ima",type)
        returning doc,err
    call cs_darcy_efficiency("xml")
    if err then
        display ""
    end if 
    
    call cs_xmlout(doc,"/u1/topprod/topcust/cim/4gl","demo")
        returning file,err 
    call cs_darcy_efficiency("file")
    display file
end function

function cimi999_demo()
    DEFINE d om.DomDocument 
    DEFINE r, n, t, w om.DomNode
    DEFINE i INTEGER

    LET d = om.DomDocument.create("Vehicles")
    LET r = d.getDocumentElement()

    LET n = r.createChild("Car")
    CALL n.setAttribute("name","Corolla")
    CALL n.setAttribute("color","Blue")
    CALL n.setAttribute("weight","1546")
    LET t = d.createChars("Nice car!")

    CALL n.appendChild(t)
    LET t = d.createEntity("nbsp")
    CALL n.appendChild(t)
    LET t = d.createChars("Yes, very nice!")
    CALL n.appendChild(t)

    LET n = r.createChild("Bus")
    CALL n.setAttribute("name","Maxibus")
    CALL n.setAttribute("color","yellow")
    CALL n.setAttribute("weight","5278")
    FOR i=1 TO 4
        LET w = n.createChild("Wheel")
        CALL w.setAttribute("width","315")
        CALL w.setAttribute("diameter","925")
        END FOR
    CALL r.writeXml("/u1/topprod/topcust/cim/4gl/Vehicles.xml")
end function
function cimi999_dur()
    define i integer

    for i =  1 to 100
        CALL cs_darcy_efficiency(i)
    end for 
end function

function cimi999_insdb()
# 1. 
    define i integer
    define insertsql string
    #  41s   24s
    database forewin
    whenever any error continue
    drop table darcy_cimi999
    whenever any error stop

    create table darcy_cimi999 (
        ima01  varchar(40),
        ima02  varchar(120),
        ima021 varchar(120),
        ima25  varchar(4)
    ) 
    let i = 1
    # declare ic cursor with hold for
    #  insert into darcy_cimi999 values (imas[i].ima01,imas[i].ima02,imas[i].ima021,imas[i].ima25)

    declare ic cursor from "insert into darcy_cimi999 values (?,?,?,?)"
    begin work
    open ic 
    for i = 1 to imas.getlength()
        put ic from imas[i].*
    end for
    flush ic
    close ic
    free ic

    commit work

    call cs_darcy_efficiency("insdb")
end function
