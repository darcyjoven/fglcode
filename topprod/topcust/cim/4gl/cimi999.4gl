import xml
import com

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
define arg1 string 
define success like type_file.chr1
define bpm_no  varchar(1000)
main
    options                                #改變一些系統預設值
        input no wrap
    defer interrupt                        #擷取中斷鍵, 由程式處理
    
    if (not cl_user()) then
       exit program
    end if
   
    whenever error call cl_err_msg_log
   
    if (not cl_setup("CIM")) then
       exit program
    end if

    let arg1 =ARG_VAL(1)
    # call cimi999_demo()
    # call cimi999_xml()
    # call cimi999_dur()
    # call cimi999_xml()
    # call cs_darcy_efficiency("begin")
    # call cimi999_get_data()
    # call cimi999_insdb()
    # call cimi999_fastexcel() #darcy:2022/08/26
    # call cimi999_bpm() #darcy:2022/08/26 #markdarcy:2022/09/01
    call cws_bpm_apmt420(arg1) returning success,bpm_no #markdarcy:2022/09/02
    let success = cws_bpm_unsign(arg1,bpm_no)
    
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

function cimi999_bpm()
    define l_status     like type_file.num10
    define l_response   string
    define l_request    string
    define l_detail     string
    define l_cnt        like type_file.num5

    define l_pmk01      like pmk_file.pmk01

    define qgdh         like pmk_file.pmk01
    define qgrq         like pmk_file.pmk04
    define qgdxz        like pmk_file.pmk02
    define qgy          varchar(100)
    define qgbm         varchar(100)
    define records  dynamic array of record
                serialNo    like pml_file.pml02,
                ljbh        like pml_file.pml04,
                pm          like ima_file.ima02,
                gg          like ima_file.ima021,
                qgdw        like pml_file.pml07,
                qgl         like pml_file.pml20,
                zcgl        like pml_file.pml21,
                dkrq_txt    like pml_file.pml35,
                dcrq_txt    like pml_file.pml34,
                jhrq_txt    like pml_file.pml33,
                bz          like pml_file.pml06,
                sfjl        like pml_file.pml91
        end record
    define cnts             integer
    

    #  请购单测试 s---
    # 检查是否是合法单据
    if cl_null(arg1) then
        return
    end if
    let l_pmk01 = arg1
    let l_cnt = 0
    select count(1) into l_cnt from pmk_file,pml_file where pmk01 =l_pmk01 and pmk18='N' and pml01 = pmk01
    --and pmk25='0' and pmkmksg='Y' #mark 暂时不再增加此条件
    if l_cnt = 0 then
        return
    end if

    select pmk01,pmk04,pmk02 into qgdh,qgrq,qgdxz from pmk_file  where pmk01 = l_pmk01
    let qgy = g_user
    let qgbm = g_grup

    let l_request = '<![CDATA[<qgd>
                        <qgdh id="qgdh" dataType="java.lang.String" perDataProId="">',qgdh,'</qgdh>
                        <qgrq id="qgrq" dataType="java.util.Date">',qgrq,'</qgrq>
                        <qgdxz id="qgdxz" dataType="java.lang.String" perDataProId="">',qgdxz,'</qgdxz>
                        <qgy id="qgy" dataType="java.lang.String" hidden="">',qgy,'</qgy>
                        <qgbm id="qgbm" dataType="java.lang.String" hidden="">',qgbm,'</qgbm>
                        <ljbh id="ljbh" dataType="java.lang.String" perDataProId=""></ljbh>
                        <pm id="pm" dataType="java.lang.String" perDataProId=""></pm>
                        <gg id="gg" dataType="java.lang.String" perDataProId=""></gg>
                        <qgdw id="qgdw" dataType="java.lang.String" perDataProId=""></qgdw>
                        <qgl id="qgl" dataType="java.lang.String" perDataProId=""></qgl>
                        <zcgl id="zcgl" dataType="java.lang.String" perDataProId=""></zcgl>
                        <dkrq id="dkrq" dataType="java.util.Date">2022/08/30</dkrq>
                        <dcrq id="dcrq" dataType="java.util.Date">2022/08/30</dcrq>
                        <jhrq id="jhrq" dataType="java.util.Date">2022/08/30</jhrq>
                        <bz id="bz" dataType="java.lang.String" perDataProId=""></bz>
                        <sfjl id="sfjl" dataType="java.lang.String"></sfjl>
                        <bg1 id="bg1">
                            <records>'
    
    declare apmt420_d cursor for 
     select pml02,pml04,ima02,ima021,pml07,pml20,pml21,pml35,pml34,pml33,pml06,pml91 from pml_file,ima_file
      where pml01 = l_pmk01 and ima01= pml04
    
    
    let cnts = 1
    foreach apmt420_d into records[cnts].*
        if sqlca.sqlcode then
            call cl_err("apmt420_d","!",10)
        end if
        let l_request = l_request, '<record id="',cnts,'">
                            <item id="serialNo" dataType="java.lang.String" perDataProId="">',records[cnts].serialNo,'</item>
                            <item id="ljbh" dataType="java.lang.String" perDataProId="">',records[cnts].ljbh,'</item>
                            <item id="pm" dataType="java.lang.String" perDataProId="">',records[cnts].pm,'</item>
                            <item id="gg" dataType="java.lang.String" perDataProId="">',records[cnts].gg,'</item>
                            <item id="qgdw" dataType="java.lang.String" perDataProId="">',records[cnts].qgdw,'</item>
                            <item id="qgl" dataType="java.lang.String" perDataProId="">',records[cnts].qgl,'</item>
                            <item id="zcgl" dataType="java.lang.String" perDataProId="">',records[cnts].zcgl,'</item>
                            <item id="dkrq_txt" dataType="java.lang.String" perDataProId="">',records[cnts].dkrq_txt,'</item>
                            <item id="dcrq_txt" dataType="java.lang.String" perDataProId="">',records[cnts].dcrq_txt,'</item>
                            <item id="jhrq_txt" dataType="java.lang.String" perDataProId="">',records[cnts].jhrq_txt,'</item>
                            <item id="bz" dataType="java.lang.String" perDataProId="">',records[cnts].bz,'</item>
                            <item id="sfjl" dataType="java.lang.String" perDataProId="">',records[cnts].sfjl,'</item>
                        </record>'
        let cnts = cnts + 1
    end foreach
    let l_request = l_request, "
                            </records>
                        </bg1>
                    </qgd>]]>"
    #pProcessPackageId PKG16582113889266
    #pRequesterId 52948 
    #pOrgUnitId B0302
    #pFormDefOID f120adb4ee4810048fb0ff9dfcd5eb1b
    #pFormFieldValue 
    {
        <![CDATA[<qgd>
        <qgdh id="qgdh" dataType="java.lang.String" perDataProId=""> </qgdh>
        <qgrq id="qgrq" dataType="java.util.Date">2022/08/30</qgrq>
        <qgdxz id="qgdxz" dataType="java.lang.String" perDataProId=""> </qgdxz>
        <qgy id="qgy" dataType="java.lang.String" hidden=""> </qgy>
        <qgbm id="qgbm" dataType="java.lang.String" hidden=""> </qgbm>
        <ljbh id="ljbh" dataType="java.lang.String" perDataProId=""> </ljbh>
        <pm id="pm" dataType="java.lang.String" perDataProId=""> </pm>
        <gg id="gg" dataType="java.lang.String" perDataProId=""> </gg>
        <qgdw id="qgdw" dataType="java.lang.String" perDataProId=""> </qgdw>
        <qgl id="qgl" dataType="java.lang.String" perDataProId=""> </qgl>
        <zcgl id="zcgl" dataType="java.lang.String" perDataProId=""> </zcgl>
        <dkrq id="dkrq" dataType="java.util.Date">2022/08/30</dkrq>
        <dcrq id="dcrq" dataType="java.util.Date">2022/08/30</dcrq>
        <jhrq id="jhrq" dataType="java.util.Date">2022/08/30</jhrq>
        <bz id="bz" dataType="java.lang.String" perDataProId=""> </bz>
        <sfjl id="sfjl" dataType="java.lang.String"></sfjl>
        <bg1 id="bg1">
        <records>
        <record id="">
        <item id="serialNo" dataType="java.lang.String" perDataProId=""> </item>
        <item id="ljbh" dataType="java.lang.String" perDataProId=""> </item>
        <item id="pm" dataType="java.lang.String" perDataProId=""> </item>
        <item id="gg" dataType="java.lang.String" perDataProId=""> </item>
        <item id="qgdw" dataType="java.lang.String" perDataProId=""> </item>
        <item id="qgl" dataType="java.lang.String" perDataProId=""> </item>
        <item id="zcgl" dataType="java.lang.String" perDataProId=""> </item>
        <item id="dkrq_txt" dataType="java.lang.String" perDataProId=""> </item>
        <item id="dcrq_txt" dataType="java.lang.String" perDataProId=""> </item>
        <item id="jhrq_txt" dataType="java.lang.String" perDataProId=""> </item>
        <item id="bz" dataType="java.lang.String" perDataProId=""> </item>
        <item id="sfjl" dataType="java.lang.String" perDataProId=""> </item>
        </record>
        </records>
        </bg1>
        </qgd>]]>
    }
    #pSubject 
    call cimi999_invokProcess(
        "PKG16582113889266",
        l_pmk01,
        l_request
    ) returning l_response
    #  请购单测试 e---


end function

function cimi999_invokProcess(
    pProcessPackageId ,
    pSubject ,
    pFormFieldValue 
)
    define invokeProcessReturn string
    define l_FormDefOID string

    define pProcessPackageId string
    define pSubject string
    define pFormFieldValue string

    define l_status     like type_file.num10
    define l_response   string
    define l_request   string

    define OID string
    define id string
    define name string
    define orgUnitType string
    define orgName string
    define isMain varchar(10)
 

    # 获取表单OID
    #findFormOIDsOfProcess(p_pProcessPackageId)
    call findFormOIDsOfProcess(pProcessPackageId) 
        returning l_status,l_response
    
    if status !=0 then
        return
    else
        let l_FormDefOID = l_response
    end if

    # 获取组织信息
    #fetchOrgUnitOfUserId(p_pUserId)
    call cimi999_getOrg(g_user)
        returning OID,id,name,orgUnitType,orgName,isMain

    # 送签
    call invokeProcess(
          pProcessPackageId,
          g_user,
          id,
          l_FormDefOID,
          pFormFieldValue,
          pSubject
      )
    returning l_status,l_response
    let l_request =
       '<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://webservice.nana.dsc.com/">
           <soapenv:Header/>
           <soapenv:Body>
               <web:invokeProcess soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
                   <pProcessPackageId xsi:type="xsd:string">',pProcessPackageId,'</pProcessPackageId>
                   <pRequesterId xsi:type="xsd:string">',g_user,'</pRequesterId>
                   <pOrgUnitId xsi:type="xsd:string">',id,'</pOrgUnitId>
                   <pFormDefOID xsi:type="xsd:string">',l_FormDefOID,'</pFormDefOID>
                   <pFormFieldValue xsi:type="xsd:string">',pFormFieldValue,'</pFormFieldValue>
                   <pSubject xsi:type="xsd:string">',pSubject,'</pSubject>
               </web:invokeProcess>
           </soapenv:Body>
       </soapenv:Envelope>'
    let l_response = cimi999_invok_by_golang(l_request) 
    
    return l_response
end function
# 获取员工信息
function cimi999_getOrg(p_user)
    define p_user  string

    define l_status     like type_file.num10
    define l_response   string
    define responseXml  xml.DomDocument 
    define l1           xml.DomNodeList
    define n1,n2,n3     xml.DomNode
    define filename string
    define index        like type_file.num5

    define OID string
    define id string
    define name string
    define orgUnitType string
    define orgName string
    define isMain varchar(10)

    call fetchOrgUnitOfUserId(p_user)
        returning l_status,l_response
    
    if l_status!=0 then
        return "","","","","",""
    else
        #call cimi999_save(l_response,"fetchOrgUnitOfUserId")
        #    returning filename 
        let responseXml = xml.DomDocument.Create()
        call responseXml.loadFromString(l_response)
        
        if responseXml.getErrorsCount() > 0 then
            return
        end if

        let OID = cimi999_getRecordfield(responseXml,"OID")
        let id = cimi999_getRecordfield(responseXml,"id")
        let name = cimi999_getRecordfield(responseXml,"name")
        
        let orgUnitType = cimi999_selectByXPath(responseXml,"//orgUnitType/value","value")
        #cimi999_getRecordfield(responseXml,"orgUnitType")

        let orgName = cimi999_getRecordfield(responseXml,"orgName")
        let isMain = cimi999_getRecordfield(responseXml,"isMain")

        return OID,id,name,orgUnitType,orgName,isMain
    end if
    
end function 

function cimi999_getRecordfield(content,fieldname)
    define content          xml.DomDocument
    define fieldname        string

    define values string

    define l        xml.DomNodeList
    define n1,n2    xml.domnode

    let l = content.getElementsByTagName(fieldname)
    if l.getCount() > 0 then
        let n1 = l.getItem(1)
        let values = n1.toString()
        let values = cl_replace_str(values,"<"||fieldname||">","")
        let values = cl_replace_str(values,"</"||fieldname||">","")
    else
        return ""
    end if

    return values
end function

# 获取子节点的值
#expr "//div/a"
function cimi999_selectByXPath(content,expr,fieldname)
    define content          xml.DomDocument
    define expr,fieldname   string

    define values string

    define l        xml.DomNodeList
    define n1,n2    xml.domnode

    let l = content.selectByXPath(expr,NULL)
    if l.getCount() > 0 then
        let n1 = l.getItem(1)
        let values = n1.toString()
        let values = cl_replace_str(values,"<"||fieldname||">","")
        let values = cl_replace_str(values,"</"||fieldname||">","")
    else
        return ""
    end if

    return values
end function

 

function cimi999_invok_by_golang(content)
    define content string
    
    define url  string
    define doc  xml.DomDocument
    define file base.Channel 

    define req,res string
    define response string
    define cmd string

    #  设置URL
    if cl_null(url) then
        let url = "http://192.168.1.45:8086/NaNaWeb/services/PLMIntegrationEFGP"
    end if

    # 获取xml文件名
    let req = current year to fraction(3)
    let req = cl_replace_str(req," ","")
    let req = cl_replace_str(req,":","")
    let req = cl_replace_str(req,".","")
    let res = "response_",req,".xml"
    let req = "request_",req,".xml"
    let res =  fgl_getenv("TEMPDIR"),"/",res
    let req =  fgl_getenv("TEMPDIR"),"/",req
    # 保存request文件
    try
        let doc = xml.DomDocument.create()
        call doc.loadFromString(content)
        call doc.save(req)
    catch
        return ""
    end try

    # 运行invokProcess
    try
        let cmd = "/u1/usr/tiptop/bpm/invokProcess '",url,"' ",req
        RUN cmd
    catch
        return ""
    end try
    # res
    try 
        let file = base.Channel.create()
        call file.openFile(res,"r")
        let response = file.readLine()
    catch
        return ""
    end try
    return response
end function

function cimi999_bpm_unsign(l_pmk01,bpm_no)
    define bpm_no string
    define l_pmk01 string

    define success like type_file.chr1

    define comment  string
    define l_gen02  like gen_file.gen02
    define l_status integer 
    select gen02 into l_gen02 from gen_file where gen01 = g_user

    let comment = g_user," ",l_gen02,"撤销了单据 by ERP",l_pmk01

    call abortProcessForSerialNo(bpm_no,comment)
        returning l_status
    
    if l_status ==0 then
        return true
    else
        return false
    end if
end function
