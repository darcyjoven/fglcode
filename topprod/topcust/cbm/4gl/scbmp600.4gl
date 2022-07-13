# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: scbmp600.4gl
# Descriptions...: BOM，MI工单批量审核功能
# Date & Author..: 22/03/22 By darcy

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"
GLOBALS "../../../tiptop/aec/4gl/aecp110.global"
GLOBALS "../../../tiptop/sub/4gl/s_data_center.global"

DEFINE g_success_bom  DYNAMIC ARRAY OF RECORD
            bma01   LIKE bma_file.bma01,
            ima02   LIKE ima_file.ima02,
            ima021  LIKE ima_file.ima021,
            bma06   LIKE bma_file.bma06,
            bmauser LIKE bma_file.bmauser,
            tim     DATETIME YEAR TO SECOND 
        END RECORD,
        g_success_aeci100   DYNAMIC ARRAY OF RECORD
            ecu01   LIKE ecu_file.ecu01,
            ima02   LIKe ima_file.ima02,
            ima021  LIKe ima_file.ima021,
            ecu02   LIKE ecu_file.ecu02,
            ecuuser LIKE ecu_file.ecuuser,
            tim     DATETIME YEAR TO SECOND 
        END RECORD 
DEFINE g_flag       LIKE type_file.chr1
DEFINE g_first_bma01 LIKE bma_file.bma01  #add:darcy:2022/04/15

FUNCTION s_cbmp600(p_wc)
    DEFINE p_wc         STRING 
    DEFINE l_sql        STRING
    DEFINE l_bma01      LIKE bma_file.bma01
    DEFINE l_bma06      LIKE bma_file.bma06
    DEFINE l_bmauser      LIKE bma_file.bmauser
    DEFINE l_success_cnt    LIKe type_file.num5
    DEFINE l_idx        LIKE type_file.num5

     IF NOT cl_confirm('cbm-006') THEN 
        RETURN
    END IF
    
    LET g_success = 'Y'
    CALL s_showmsg_init() 
    CALL s_cbmp600_cusor()
    CALL s_cbmp600_crt_temp()
    CALL g_success_bom.clear()
    CALL g_success_aeci100.clear()
    BEGIN WORK
    
    LET l_sql = "SELECT bma01,bma06,bmauser FROM bma_file WHERE bmaacti='Y' AND ",p_wc
    
    PREPARE abmi600_pre FROM l_sql
    DECLARE abmi600_dcl CURSOR FOR abmi600_pre

    LET l_success_cnt = 0
    LET g_first_bma01 ="" #add:darcy:2022/04/15
    FOREACH abmi600_dcl INTO l_bma01,l_bma06,l_bmauser
        IF STATUS THEN  
            CALL s_errmsg("bma01,bma06",l_bma01||","||l_bma06,"abmi600_dcl",'!',1)
            LET g_success = 'N'
            RETURN
        END IF
        #add:darcy:2022/04/15 s---
        IF cl_null(g_first_bma01) THEN
            LET g_first_bma01 = l_bma01
        END IF
        #add:darcy:2022/04/15 e---
        LET g_flag = 'Y'
        CALL s_cbmp600_b(l_bma01,l_bma06)
        IF g_success ='N' THEN 
            LET g_totsuccess ='N'
            CONTINUE FOREACH
        END iF
        IF g_flag = 'Y' THEN 
            CALL g_success_bom.appendElement()
            LET g_success_bom[g_success_bom.getLength()].bma01 = l_bma01
            LET g_success_bom[g_success_bom.getLength()].bma06 = l_bma06
            IF cl_null(g_success_bom[g_success_bom.getLength()].bma06) THEN LET g_success_bom[g_success_bom.getLength()].bma06 =' ' END IF
            SELECT ima02,ima021 INTO g_success_bom[g_success_bom.getLength()].ima02,g_success_bom[g_success_bom.getLength()].ima021 FROM ima_file WHERE ima01 = l_bma01
            IF cl_null(g_success_bom[g_success_bom.getLength()].ima02) THEN LET g_success_bom[g_success_bom.getLength()].ima02 =' ' END IF
            IF cl_null(g_success_bom[g_success_bom.getLength()].ima021) THEN LET g_success_bom[g_success_bom.getLength()].ima021 =' ' END IF
            LET g_success_bom[g_success_bom.getLength()].bmauser= l_bmauser

            LET g_success_bom[g_success_bom.getLength()].tim = CURRENT YEAR TO SECOND
        ELSE 
            LET g_flag = 'Y'
        END IF 
        CALL s_cbmp600_e(l_bma01)
        IF g_success ='N' THEN 
            LET g_totsuccess ='N'
            CONTINUE FOREACH
        END IF
        CALL s_cbmp600_bom(l_bma01,l_bma06)
        IF g_success ='N' THEN 
            LET g_totsuccess ='N'
            CONTINUE FOREACH
        END IF
    END FOREACH

    IF g_success ='Y' THEN
        COMMIT WORK
        # ROLLBACK WORK #TODO:方便测试，每次都不提交
        CALL s_cbmp600_mail() #暂时不发放邮件提示
        #TODO:去掉之前已审核结果，优化信息显示。
        # FOR l_idx = 1 TO g_success_bom.getLength() 
        #     CALL s_errmsg("bma01,bma06",g_success_bom[l_idx].bma01||","||g_success_bom[l_idx].bma06,"BOM审核发放成功",'!',1)
        # END FOR
        # FOR l_idx = 1 TO g_success_aeci100.getLength() 
        #     CALL s_errmsg("ecu01,ecu02",g_success_aeci100[l_idx].ecu01||","||g_success_aeci100[l_idx].ecu02,"工艺资料审核发放成功",'!',1)
        # END FOR
        CALL cl_err_msg("操作成功","cbm-007",g_success_bom.getLength(),1)
        MESSAGE "审核完成，成功"||g_success_bom.getLength()||"笔！"
    ELSE
        ROLLBACK WORK  
    END IF
    CALl s_showmsg()
END FUNCTION

FUNCTION s_cbmp600_cusor()
    DEFINE l_sql        STRING

    #查下阶级料
    LET l_sql = " SELECT bmb03,bmb29,bmauser FROM bmb_file,bma_file 
                 WHERE bmb01 = bma01 AND bma01 = ? AND bma06 = ? AND bmaacti='Y' 
                   AND bmb03 IN (SELECT bmb01 FROM bmb_file) "
    PREPARE cbmp600_bmb03_pre FROM l_sql
    DECLARE cbmp600_bmb03_dlc CURSOR FOR cbmp600_bmb03_pre

    LET l_sql = "SELECT * FROM bma_file WHERE bma01 = ? AND bma06 = ? FOR UPDATE " 
    LET l_sql = cl_forupd_sql(l_sql)                                        
    DECLARE i600sub_cl_scbmp600 CURSOR FROM l_sql

    LET l_sql ="SELECT a.gen06 ,b.gen06
                 FROM ima_file, gen_file a,gen_file b 
                 WHERE ima01 = ?
                 AND a.gen01 = TO_CHAR(imaud11)
                 AND b.gen01 = to_char(imaud12) "
    PREPARE cbmp600_imaud12 FROM l_sql 
END FUNCTION 

FUNCTION s_cbmp600_b(p_bma01,p_bmb06)
    DEFINE p_bma01      LIKE bma_file.bma01
    DEFINE p_bmb06      LIKE bma_file.bma06

    CALL s_cbmp600_cnf_chk(p_bma01,p_bmb06)
    IF g_success ='N' THEN  
        LET g_totsuccess ='N'
        RETURN 
    END IF
    CALL s_cbmp600_cnf_upd(p_bma01,p_bmb06) 
    IF g_success ='N' THEN  
        LET g_totsuccess ='N'
        RETURN 
    END IF 
    CALL s_cbmp600_release_chk(p_bma01,p_bmb06) 
    IF g_success ='N' THEN  
        LET g_totsuccess ='N'
        RETURN 
    END IF
    CALL s_cbmp600_release_upd(p_bma01,p_bmb06,g_today) 
    IF g_success ='N' THEN  
        LET g_totsuccess ='N'
        RETURN 
    END IF 
    RETURN 
END FUNCTION

FUNCTION s_cbmp600_e(p_ecu01)
    DEFINE p_ecu01        LIKE ecu_file.ecu01
    DEFINE l_ecu02        LIKE ecu_file.ecu02
    DEFINE l_ecuuser      LIKE ecu_file.ecuuser
    # DEFINE p_ima01      LIKE ima_file.ima01 

    RETURN

    DECLARE scbmp600_ecu02 CURSOR FOR 
        SELECT ecu02,ecuuser FROM ecu_file WHERE ecu01 =  p_ecu01
           AND ecuacti='Y' 

    FOREACH scbmp600_ecu02 INTO l_ecu02,l_ecuuser
        IF STATUS THEN
            CALL cl_err("scbmp600_ecu02",SQLCA.sqlcode,1) 
            LET g_success ='N'
            RETURN
        END IF 
        CALL s_ceci100_cnf_upd(p_ecu01,l_ecu02) 
        IF g_success ='N' THEN  
            LET g_totsuccess ='N'
            CONTINUE FOREACH 
        END IF 
        CALL s_ceci100_release(p_ecu01,l_ecu02) 
        IF g_success ='N' THEN  
            LET g_totsuccess ='N'
            CONTINUE FOREACH 
        END IF  
        CALL g_success_aeci100.appendElement()
        LET g_success_aeci100[g_success_aeci100.getLength()].ecu01 = p_ecu01
        LET g_success_aeci100[g_success_aeci100.getLength()].ecu02 = l_ecu02
        IF cl_null(g_success_aeci100[g_success_aeci100.getLength()].ecu02) THEN LET g_success_aeci100[g_success_aeci100.getLength()].ecu02 = ' ' END IF
        SELECT ima02,ima021 INTO g_success_aeci100[g_success_aeci100.getLength()].ima02,g_success_aeci100[g_success_aeci100.getLength()].ima021 FROM ima_file WHERE ima01=p_ecu01
        LET g_success_aeci100[g_success_aeci100.getLength()].ecuuser = l_ecuuser
        
        IF cl_null(g_success_aeci100[g_success_aeci100.getLength()].ima02) THEN LET g_success_aeci100[g_success_aeci100.getLength()].ima02 = ' ' END IF 
        IF cl_null(g_success_aeci100[g_success_aeci100.getLength()].ima021) THEN LET g_success_aeci100[g_success_aeci100.getLength()].ima021 = ' ' END IF 

        LET g_success_aeci100[g_success_aeci100.getLength()].tim = CURRENT YEAR TO SECOND 
    END FOREACH  
END FUNCTION

#BOM 审核检查
FUNCTION s_cbmp600_cnf_chk(p_bma01,p_bma06) 
    DEFINE l_imaud10    LIKE ima_file.imaud10
    DEFINE l_imaud07    LIKE ima_file.imaud07
    DEFINE l_cnt   LIKE type_file.num5  
    DEFINE p_bma01 LIKE bma_file.bma01
    DEFINE p_bma06 LIKE bma_file.bma06
    DEFINE l_bma RECORD LIKE bma_file.*
    DEFINE l_ima01   LIKE ima_file.ima01
    DEFINE l_imaacti LIKE ima_file.imaacti
    DEFINE l_bmb09   LIKE bmb_file.bmb09 
    DEFINE l_bmb     RECORD
                   bmb02    LIKE bmb_file.bmb02,
                   bmb03    LIKE bmb_file.bmb03, 
                   bmb19    LIKE bmb_file.bmb19,
                   bmb10    LIKE bmb_file.bmb10,
                   bmb10_fac      LIKE bmb_file.bmb10_fac,
                   bmb10_fac2     LIKE bmb_file.bmb10_fac2,
                   ima25    LIKE ima_file.ima25,
                   ima86    LIKE ima_file.ima86,
                   bmb04    LIKE bmb_file.bmb04,
                   bmb09    LIKE bmb_file.bmb09,
                   bmb15    LIKE bmb_file.bmb15
                END RECORD 
    DEFINE l_sw             LIKE type_file.chr1,
           l_bmb10_fac      LIKE bmb_file.bmb10_fac,
           l_bmb10_fac2     LIKE bmb_file.bmb10_fac2
    DEFINE l_ima70          LIKE ima_file.ima70

    select imaud10,imaud07 into l_imaud10,l_imaud07 from ima_file where ima01=p_bma01
    IF cl_null(l_imaud10) OR ( l_imaud10=0 ) THEN 
        CALL s_errmsg("ima01",p_bma01,"排版数不可为0",'cbm-004',1)
        LET  g_success = 'N'
        RETURN
    END IF 
    IF  cl_null(l_imaud07) THEN 
        CALL s_errmsg("ima01",p_bma01,"PNL尺寸不可为空",'cbm-005',1)
        LET  g_success = 'N'
        RETURN
    END IF

    IF s_shut(0) THEN RETURN END IF

    IF cl_null(p_bma01)THEN
        CALL s_errmsg("","","",-400,1) 
        LET g_errno = '-400'
        LET g_success = 'N'
        RETURN
    END IF

    SELECT * INTO l_bma.* FROM bma_file
    WHERE bma01=p_bma01
      AND bma06=p_bma06
 #NOTE: 已审核，跳过此笔，当做成功处理   
    IF l_bma.bma10='1' THEN 
        # CALL s_errmsg("bma01",p_bma01,"",'9023',1) 
        # LET g_errno = '9023'
        # LET g_success = 'N'
        RETURN
    END IF

    IF l_bma.bma10 = '2' THEN
        # CALL s_errmsg("bma01",p_bma01,"",'abm-123',1) 
        # LET g_errno = 'abm-123'
        # LET g_success = 'N'
        RETURN
    END IF

    # IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
    #     IF  NOT cl_confirm('axm-108') THEN 
    #         LET g_success = 'N' 
    #         RETURN 
    #     END IF  
    # END IF 

    IF cl_null(p_bma06) THEN
        LET p_bma06 = ' '
    END IF
    
    SELECT ima01,imaacti,ima70
     INTO l_ima01,l_imaacti,l_ima70
     FROM ima_file
    WHERE ima01 = l_bma.bma01

    IF l_imaacti MATCHES '[PH]' THEN
        CALL s_errmsg("ima01,imaacti",l_ima01||","||l_imaacti,"",'abm-038',1)    
        LET g_errno = 'abm-038'      
        LET g_success = 'N'
        RETURN
    END IF

    DECLARE i600_checkbmb19_cbmp600 CURSOR FOR 
    SELECT bmb02,bmb03,bmb19,bmb10,bmb10_fac,bmb10_fac,ima25,ima86,bmb04,bmb09,bmb15 
      FROM bmb_file ,ima_file   
      WHERE bmb01 =p_bma01 AND bmb29=p_bma06 
        AND ima01 = bmb03 
    
    FOREACH i600_checkbmb19_cbmp600 INTO l_bmb.*
        IF STATUS THEN
            CALL cl_err("i600_checkbmb19_cbmp600",STATUS,1)
            LET g_success = 'N' 
            RETURN
        END IF 

        SELECT ima01,imaacti,ima70
            INTO l_ima01,l_imaacti,l_ima70
            FROM ima_file
        WHERE ima01 = l_bmb.bmb03

        IF cl_null(l_bmb.bmb09) THEN
            CALL s_errmsg('bmb01,bmb03,bmb09',p_bma01||","||l_bmb.bmb03||","||l_bmb.bmb09,'i600:','cbm-001',1)
            LET g_success = 'N'
            CONTINUE FOREACH
        END IF 

        IF l_ima70 <> l_bmb.bmb15 THEN
            CALL s_errmsg('bmb01,bmb03,bmb15',p_bma01||","||l_bmb.bmb03||","||l_bmb.bmb15,'i600:','cbm-002',1)
            LET g_success = 'N'
            CONTINUE FOREACH
        END IF

        IF l_bmb.bmb03 MATCHES '*-*' AND l_bmb.bmb19 <>'2' THEN
            CALL s_errmsg("bm01,bmb02,bmb03",p_bma01||","||l_bmb.bmb02||","||l_bmb.bmb03," ",'cbm-003',1)
            LET g_success = 'N'
            CONTINUE FOREACH
        END IF

        IF l_bmb.bmb03 NOT MATCHES '*-*' AND l_bmb.bmb19 <>'1' THEN
            CALL s_errmsg("bm01,bmb02,bmb03",p_bma01||","||l_bmb.bmb02||","||l_bmb.bmb03," ",'cbm-003',1)
            LET g_success = 'N'
            CONTINUE FOREACH
        END IF 

        CALL s_umfchk(l_bmb.bmb03,l_bmb.bmb10,l_bmb.ima25)
            RETURNING l_sw,l_bmb10_fac
        IF l_sw THEN LET l_bmb10_fac = 1 END IF
        CALL s_umfchk(l_bmb.bmb03,l_bmb.bmb10,l_bmb.ima86)
                RETURNING l_sw,l_bmb10_fac2
        IF l_sw THEN LET l_bmb10_fac2 = 1 END IF

        UPDATE bmb_file 
            SET bmb10_fac = l_bmb10_fac,
                bmb10_fac2 =  l_bmb10_fac2
        WHERE bmb01 = p_bma01 AND bmb02 = l_bmb.bmb02 
            AND bmb03 = l_bmb.bmb03 AND bmb04= l_bmb.bmb04 AND bmb09= l_bmb.bmb09

    END FOREACH

    IF g_success = 'N' THEN 
        RETURN
    END IF

    SELECT * INTO l_bma.* FROM bma_file
     WHERE bma01=p_bma01
       AND bma06=p_bma06

    IF NOT s_dc_ud_flag('2',l_bma.bma08,g_plant,'u') THEN
        CALL s_errmsg("bma01,bma08",l_bma.bma01||","||l_bma.bma08,"",'aoo-045',1)  
        LET g_errno = 'aoo-045'
        LET g_success = 'N'
        RETURN
    END IF

    IF l_bma.bma10='1' THEN 
    #    CALL s_errmsg("bma01,bma10",l_bma.bma01||","||l_bma.bma10,"",'9023',1)   
    #    LET g_errno = '9023'
    #    LET g_success = 'N'
       RETURN 
    END IF
    

    LET l_cnt=0
    SELECT COUNT(*) INTO l_cnt
      FROM bmb_file
     WHERE bmb01=p_bma01
       AND bmb29=p_bma06
    IF l_cnt=0 OR l_cnt IS NULL THEN
        CALL s_errmsg("bma01,bmb29",p_bma01||","||p_bma06,"",'mfg-009',1) 
        LET g_errno = 'mfg-009'
        LET g_success = 'N'
        RETURN
    END IF  

END FUNCTION 

#BOM 审核更新
FUNCTION s_cbmp600_cnf_upd(p_bma01,p_bma06)
    DEFINE p_bma01   LIKE bma_file.bma01
    DEFINE p_bma06   LIKE bma_file.bma06
    DEFINE l_bma     RECORD LIKE bma_file.*
 
    WHENEVER ERROR CONTINUE  
 
    IF cl_null(p_bma06) THEN
        LET p_bma06 = ' '
    END IF
 
    OPEN i600sub_cl_scbmp600 USING p_bma01,p_bma06
    IF STATUS THEN
        CALL s_errmsg("bma01,bma06",p_bma01||","||p_bma06,"OPEN i600sub_cl_scbmp600:",STATUS,1) 
        CLOSE i600sub_cl_scbmp600
        LET g_errno = 'aws-191'  
        LET g_success = 'N'
        RETURN
    END IF
 
    FETCH i600sub_cl_scbmp600 INTO l_bma.*                # 鎖住將被更改或取消的資料
    
    IF SQLCA.sqlcode THEN
        CALL s_errmsg("bma01",p_bma01,"",SQLCA.sqlcode,1)  
        CLOSE i600sub_cl_scbmp600 
        LET g_errno = '-243'                     #資料已經被鎖住, 無法讀取 !
        LET g_success = 'N'
        RETURN
    END IF 
    IF l_bma.bma10 <>'0' THEN 
        CLOSE i600sub_cl_scbmp600
        RETURN
        # 非审核状态跳过更新
    END IF  
    CLOSE i600sub_cl_scbmp600
 
    UPDATE bma_file
       SET bma10 = '1',#審核
           bmadate=g_today     #FUN-C40006 add
     WHERE bma01 = p_bma01
       AND bma06 = p_bma06
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
        CALL s_errmsg("bma01,bma06",p_bma01||","||p_bma06,"",SQLCA.sqlcode,1)  
        LET g_errno = 'aws-193'
        LET g_success = 'N'    
        RETURN
    END IF      

END FUNCTION 
#BOM 发放检查
FUNCTION s_cbmp600_release_chk(p_bma01,p_bma06)
    DEFINE p_bma01   LIKE bma_file.bma01
    DEFINE p_bma06   LIKE bma_file.bma06
    DEFINE l_bma RECORD LIKE bma_file.*
    DEFINE l_cnt   LIKE type_file.num10
    DEFINE l_ima01   LIKE ima_file.ima01   
    DEFINE l_imaacti LIKE ima_file.imaacti 
    DEFINE l_bmb01   LIKE bmb_file.bmb01   
    DEFINE l_bmb02   LIKE bmb_file.bmb02   
    DEFINE l_bmb03   LIKE bmb_file.bmb03   
    DEFINE l_bmb04   LIKE bmb_file.bmb04   
    DEFINE l_ima910  LIKE ima_file.ima910  
    DEFINE l_n       LIKE type_file.num5   
    DEFINE l_bma05   LIKE bma_file.bma05 

    IF s_shut(0) THEN RETURN END IF

    LET g_success = 'Y'
    IF p_bma01 IS NULL THEN 
        CALL s_errmsg("","","",-400,1)   
        LET g_errno = '-400'
        LET g_success = 'N'
        RETURN 
    END IF
    IF cl_null(p_bma06) THEN
        LET p_bma06 = ' '
    END IF
  
    SELECT * INTO l_bma.* FROM bma_file
     WHERE bma01=p_bma01
       AND bma06=p_bma06
    IF NOT s_dc_ud_flag('2',l_bma.bma08,g_plant,'u') THEN
       CALL s_errmsg("bma01,bma06,bma08",p_bma01||","||p_bma06||","||l_bma.bma08,"","aoo-045",1)
       LET g_errno = 'aoo-045'
       LET g_success = 'N'
       RETURN
    END IF
    SELECT ima01,imaacti 
      INTO l_ima01,l_imaacti 
      FROM ima_file 
     WHERE ima01 = l_bma.bma01
    IF l_imaacti = 'N' THEN 
        CALL s_errmsg("ima01,imaacti",l_ima01||","||l_imaacti ,"",'9028',1)   
        LET g_errno = '9028'
        LET g_success = 'N'
        RETURN 
    END IF
    IF l_imaacti MATCHES '[PH]' THEN
        CALL s_errmsg("ima01,imaacti",l_ima01||","||l_imaacti ,"",'abm-038',1)    
        LET g_errno = 'abm-038'      
        LET g_success = 'N'
        RETURN
    END IF  
    IF l_bma.bma10 = 0 THEN 
        CALL s_errmsg("bma01,bma10",l_ima01||","||l_bma.bma10 ,"",'aco-174',1)
        LET g_errno = 'aco-174'
        LET g_success = 'N'
        RETURN 
    END IF   
    IF l_bma.bma10 = 2 THEN 
        # CALL s_errmsg("bma01",l_bma.bma01,"",'abm-003',1) 
        # LET g_errno = 'abm-003'
        # LET g_success = 'N'
        RETURN 
    END IF   
    IF l_bma.bmaacti='N' THEN
        CALL s_errmsg("bma01",l_bma.bma01,"",'abm-003',1) 
        CALL cl_err(l_bma.bmaacti,'aap-127',0) 
        LET g_errno = 'aap-127'
        LET g_success = 'N'
        RETURN
    END IF
    IF NOT cl_null(l_bma.bma05) THEN
        # CALL s_errmsg("bma01,bma05",l_bma.bma01||","||l_bma.bma05,"",'abm-003',1) 
        # CALL cl_err(l_bma.bma05,'abm-003',0) 
        # LET g_errno = 'abm-003'
        # LET g_success = 'N'
        RETURN
    END IF
    SELECT COUNT(*) 
      INTO l_cnt
      FROM bmb_file 
     WHERE bmb01 = l_bma.bma01
       AND bmb29 = l_bma.bma06  
    IF l_cnt=0 THEN
        CALL s_errmsg("bma01,bma05",l_bma.bma01||","||l_bma.bma05,"",'arm-034',1)
        # CALL cl_err(l_bma.bma01,'arm-034',0) 
        LET g_errno = 'arm-034'
        LET g_success = 'N'
        RETURN
    END IF

    #TQC-C50031--add--str--
    IF NOT s_cbmp600_chk_bmb03(p_bma01,p_bma06) THEN
       LET g_success = 'N'
       RETURN
    END IF
    #TQC-C50031--add--end--

    #==>BOM在進行發放時，檢核下階半成品的BOM是否發放
    DECLARE i600_up_cs_scbmp600 CURSOR FOR
     SELECT bmb01,bmb02,bmb03,bmb04
       FROM bmb_file
      WHERE bmb01 = l_bma.bma01
        AND bmb29 = l_bma.bma06  
        AND (bmb05 > l_bma.bma05 OR bmb05 IS NULL ) 

    FOREACH i600_up_cs_scbmp600 INTO l_bmb01,l_bmb02,l_bmb03,l_bmb04
        SELECT ima910 
          INTO l_ima910 
          FROM ima_file 
         WHERE ima01 = l_bmb03
        IF cl_null(l_ima910) THEN 
            LET l_ima910 = ' ' 
        END IF
        SELECT COUNT(*) INTO l_n
          FROM bma_file
         WHERE bma01 = l_bmb03
           AND bma06 = l_ima910
           AND bmaacti = 'Y'
        IF l_n > 0 THEN
        #NOTE: 不需要看下阶级报错
            # SELECT bma05 INTO l_bma05
            #   FROM bma_file
            #  WHERE bma01 = l_bmb03
            #    AND bma06 = l_ima910
            #    AND bmaacti = 'Y'
            # IF cl_null(l_bma05) OR l_bma05 = ' ' THEN
            #     # CALL s_errmsg('bmb01,bmb03',l_bmb01||","||l_bmb03,'i600:','amr-001',1)
            #    #LET g_errno = 'amr-001'                                #FUN-AA0035 mark
            #   #-------------No:MOD-AC0292 mark
            #    #LET g_errno = 'aws-452' #此BOM或下階半成品的BOM未發放! #FUN-AA0035 add
            #    #LET g_success = 'N'
            #   #-------------No:MOD-AC0292 end
            # END IF
        END IF
    END FOREACH 

END FUNCTION
#BOM 发放
FUNCTION s_cbmp600_release_upd(p_bma01,p_bma06,p_bma05)
    DEFINE p_bma01   LIKE bma_file.bma01
    DEFINE p_bma06   LIKE bma_file.bma06
    DEFINE p_bma05   LIKE bma_file.bma05
    DEFINE l_bma     RECORD LIKE bma_file.*
 
    WHENEVER ERROR CONTINUE
 
    LET g_success = 'Y'
 
    IF cl_null(p_bma06) THEN
        LET p_bma06 = ' '
    END IF
 
    OPEN i600sub_cl_scbmp600 USING p_bma01,p_bma06
    IF STATUS THEN
        CALL s_errmsg("","",'OPEN i600sub_cl_scbmp600:',STATUS,1)
        # CALL cl_err("OPEN i600sub_cl_scbmp600:", STATUS, 1)
        CLOSE i600sub_cl_scbmp600
        LET g_errno = 'aws-191' #OPEN LOCK CURSOR失敗!
        LET g_success = 'N'
        RETURN
    END IF
 
    FETCH i600sub_cl_scbmp600 INTO l_bma.*                # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL s_errmsg("bma01",p_bma01,"",SQLCA.sqlcode,1)
        # CALL cl_err(p_bma01,SQLCA.sqlcode,1)     # 資料被他人LOCK
        CLOSE i600sub_cl_scbmp600 
        LET g_errno = '-243'                     #資料已經被鎖住, 無法讀取 !
        LET g_success = 'N'
        RETURN
    END IF
    IF l_bma.bma10 <> '1' THEN 
        CLOSE i600sub_cl_scbmp600
        LET g_flag = 'N'
        RETURN
        #非审核状态返回不更新
    END IF 
    CLOSE i600sub_cl_scbmp600
    IF cl_null(p_bma05) THEN
        LET p_bma05 = g_today
    END IF
    UPDATE bma_file 
       SET bma05 = p_bma05, 
           bma10 = '2', 
           bmadate=g_today     #FUN-C40006 add        
     WHERE bma01 = l_bma.bma01
       AND bma06 = l_bma.bma06 
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
        CALL s_errmsg("bma01,bma06",l_bma.bma01||","||l_bma.bma06,"up bma05",SQLCA.sqlcode,1)
        # CALL cl_err3("upd","bma_file",l_bma.bma01,l_bma.bma06,SQLCA.sqlcode,"","up bma05",1) 
        LET g_errno = 'aws-340' 
        LET g_success = 'N'    
        RETURN
    END IF

END FUNCTION


#工艺审核更新
FUNCTION s_ceci100_cnf_upd(p_ecu01,p_ecu02)
    DEFINE p_ecu01      LIKE ecu_file.ecu01 
    DEFINE p_ecu02      LIKE ecu_file.ecu02
    DEFINE l_cn1,l_cn2,l_cn3,l_num  LIKE type_file.num5
    DEFINE l_ecu        RECORD LIKE ecu_file.* 
    DEFINE l_ecb06      LIKE ecb_file.ecb06
    DEFINE l_ecu01      LIKE type_file.chr1000


    SELECT * INTO l_ecu.* FROM ecu_file WHERE ecu01=p_ecu01 AND ecu02=p_ecu02

    #检查是否维护受镀面积
    #是否有需要维护受镀面积作业编码
    SELECT count(*) INTO l_cn2 FROM  ecb_file WHERE  ecb01=p_ecu01 AND ecb02=p_ecu02
    AND ecb06  IN (SELECT tc_ecn02 FROM tc_ecn_base  )
    
    SELECT  count(*) INTO l_cn3
    FROM ecb_file ,tc_ecn_file 
    WHERE ecb01=p_ecu01 AND ecb02=p_ecu02
    AND ecb01=tc_ecn01 AND   ecb06=tc_ecn02 AND tc_ecn04>0 
  

    IF l_cn2<l_cn3 THEN  
        CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"","csf-046",1)
        LET g_success = 'N'
        RETURN
        # CALL cl_err('','csf-046',0)
    END IF
     
    IF cl_null(p_ecu01) OR p_ecu02 IS NULL OR l_ecu.ecu012 IS NULL THEN    #FUN-A50081 add ecu012
        CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"",-400,1)
        LET g_success = 'N'
        # CALL cl_err('',-400,0)
         RETURN
    END IF

         # 检查作业编码是否重复
    SELECT count(*) INTO l_cn1
    FROM 
    ( SELECT  ecb01,ecb02
        FROM ecb_file 
        WHERE  ecb01=p_ecu01 AND ecb02=p_ecu02
        GROUP BY  ecb01,ecb02,ecb06
        HAVING count(*)>1 )

    IF cl_null(l_cn1) THEN  LET l_cn1=0 END IF 
    IF l_cn1>1 THEN
        CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"",'csf-033',1)
        # CALL cl_err('','csf-033',0)
        LET g_success = 'N'
         RETURN
    END IF
            
    UPDATE ECB_FILE
    SET ecbud06='Y'  WHERE ecb01=p_ecu01 AND ecb02=p_ecu02 AND ecbud06<>'Y' AND  ecbud04 IS NOT NULL
              
    UPDATE ECB_FILE
    SET ecbud06='N'  WHERE ecb01=p_ecu01 AND ecb02=p_ecu02  AND  ecbud08='G1018'
     
    IF g_success = 'Y' THEN
        IF l_ecu.ecuud02="Y" THEN
            # CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"",9023,1)
            # CALL cl_err("",9023,1)
            RETURN
        END IF
    END IF 
#str----add by huanglf161027
    LET l_num = 0
    LET g_success = 'Y'
     #tianry add 161212

    DECLARE sel_ttrryy_cbmp600_cur CURSOR FOR 
    SELECT ecb06,COUNT(ecb06)  FROM ecb_file  WHERE ecb01 = p_ecu01  AND ecb02 = p_ecu02
        GROUP BY ecb06  HAVING COUNT(ecb06)>1 
    OPEN sel_ttrryy_cbmp600_cur 
    FETCH sel_ttrryy_cbmp600_cur INTO l_ecb06,l_num
    CLOSE sel_ttrryy_cbmp600_cur 
    IF l_num>0 THEN 
        CALL s_errmsg("ecu01,ecu02,ecb06",p_ecu01||","||p_ecu02||","||l_ecb06,"",9023,1)
        # CALL cl_err(l_ecb06,'cec-034',1)
        LET g_success = 'N'
        RETURN
    END IF 
#str----end by huanglf161027 
    IF g_success = 'Y' THEN 
        IF l_ecu.ecuacti="N"  THEN
            CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"",'aim-153',1)
            LET g_success = 'N'
            # CALL cl_err("",'aim-153',1)
            # LET g_success = 'N'   #add by huanglf161027
            RETURN                        #No.FUN-840036 
        END IF
        IF l_ecu.ecuud02="Y" THEN
            # CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"",9023,1)
            # CALL cl_err("",9023,1)
            # LET g_success = 'N' #add by huanglf161027 
            RETURN 
        END IF
    END IF 

#str---add by huanglf170313
    CALL scbmp600_i100_ecbud04(p_ecu01,p_ecu02,'')
    IF g_success = 'N' THEN
        CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"",'cec-100',1)
        # CALL cl_err('','cec-100',1)
    END IF 
#str---end by huanglf170313 
    IF g_success = 'Y' THEN  #add by huanglf161027
        IF l_ecu.ecuacti="N" THEN
            CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"",'aim-153',1)
            # CALL cl_err("",'aim-153',1)
            LET g_success = 'N'
            RETURN  
        ELSE 
                 
            UPDATE ecu_file
            SET ecuud02="Y",ecudate = g_today     #FUN-D10063 add ecudate = g_today
            WHERE ecu01=p_ecu01
                AND ecu02=p_ecu02
                AND ecu012 = l_ecu.ecu012   #FUN-A50081
            IF SQLCA.sqlcode THEN
                CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"upd ecu_file",SQLCA.sqlcode,1)
                # CALL cl_err3("upd","ecu_file",g_ecu.ecu01,g_ecu.ecu02,SQLCA.sqlcode,"","ecuud02",1)
                ROLLBACK WORK
                LET g_success = 'N'
                RETURN
            ELSE 
                CALL scbmp600_i100_e_work(p_ecu01,p_ecu02)  #add by wangxt170209
                # LET l_ecu.ecuud02="Y"
                # DISPLAY l_ecu.ecuud02 TO FORMONLY.ecuud02
                #add by zhangzs 201208   记录审核状态到中间表 ect_file   ----s------
                LET l_ecu01 = p_ecu01,p_ecu02
                # SELECT TO_CHAR(SYSDATE, 'YY-MM-DD,HH24:MM:SS') INTO l_date FROM DUAL  #日期+时间
                CALL cl_ect('aeci100',l_ecu01,g_user,'1',g_today,TIME)
                #add by zhangzs 201208   记录审核状态到中间表 ect_file   ----e------
            END IF
        END IF
    END IF 
            
     
END FUNCTION 

#工艺发放
FUNCTION s_ceci100_release(p_ecu01,p_ecu02)
    DEFINE l_msg              STRING #FUN-A50100
    DEFINE p_ecu01            LIKE ecu_file.ecu01,
           p_ecu02            LIKE ecu_file.ecu02 
    DEFINE l_ecu              RECORD LIKE ecu_file.*

    SELECT *  INTO l_ecu.* FROM ecu_file
     WHERE ecu01 = p_ecu01 AND ecu02 = p_ecu02

  
    IF cl_null(p_ecu01) OR l_ecu.ecu02 IS NULL OR l_ecu.ecu012 IS NULL THEN    #FUN-A50081 add ecu012
       CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"",-400,1)
    #    CALL cl_err('',-400,0)
        LET g_success = 'N'
       RETURN
    END IF
#CHI-C30107 --------- add --------- begin
    IF l_ecu.ecu10="Y" THEN
        # CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"",'cec-030',1)
        # CALL cl_err("",'cec-030',1) #modify by huanglf160928
        LET g_success = 'N'
        RETURN
    END IF
    IF l_ecu.ecuacti="N" THEN
        CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"",'aim-153',1)
        LET g_success = 'N'
        # CALL cl_err("",'aim-153',1)
        RETURN     
    END IF
#CHI-C30107 --------- add --------- end
    IF l_ecu.ecu10="Y" THEN
        # CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"",'cec-030',1)
        LET g_success = 'N'
        # CALL cl_err("",'cec-030',1)  #modify by huanglf160928
        RETURN
    END IF
#NOTE:不使用平行工艺
#  IF g_sma.sma541 = 'Y' THEN       #FUN-A60028
# #FUN-A50081 --begin--
#     LET g_confirm_p110 = 'Y'
#     CALL p110_sub()
#     LET g_confirm_p110 = 'N'
#     IF g_success = 'N' THEN
#        RETURN
# #    ELSE                               #FUN-A50100
# #    	 CALL cl_err('','aec-046',1)    #FUN-A50100
#     END IF
# #FUN-A50081 --end--
#  END IF                           #FUN-A60028


#NOTE: 审核已判断过
 #str---add by huanglf170313
    # CALL i100_ecbud04('')
    # IF g_success = 'N' THEN
    #    CALL cl_err('','cec-100',1)
    #    RETURN 
    # END IF 
#str---end by huanglf170313 

    IF NOT (l_ecu.ecuacti="N") THEN  
        
        #str-----add by guanyao160727
        UPDATE ima_file SET ima571 = p_ecu01,
                            ima94  = p_ecu02
                        WHERE ima01 = p_ecu01  and ima08='M'
        IF SQLCA.sqlcode THEN
            CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"upd ima_file",SQLCA.sqlcode,1)
            # CALL cl_err3("upd","ima_file",l_ecu.ecu01,l_ecu.ecu02,SQLCA.sqlcode,"","ima571",1)
            LET g_success = 'N'
            ROLLBACK WORK
            RETURN 
        END IF 
        #end-----add by guanyao160727
        UPDATE ecu_file
        SET ecu10="Y",ecudate = g_today     #FUN-D10063 add ecudate = g_today
        WHERE ecu01=p_ecu01
            AND ecu02=p_ecu02
            AND ecu012 = l_ecu.ecu012   #FUN-A50081
        IF SQLCA.sqlcode THEN
            CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"upd ecu_file",SQLCA.sqlcode,1)
            # CALL cl_err3("upd","ecu_file",l_ecu.ecu01,l_ecu.ecu02,SQLCA.sqlcode,"","ecu10",1)
            ROLLBACK WORK
            LET g_success = 'N' 
            RETURN
        END IF
#       END IF  #CHI-C30107 mark
    END IF
END FUNCTION

#BOM遍历
FUNCTION s_cbmp600_bom(p_bma01,p_bma06)
    DEFINE p_bma01  LIKE    bma_file.bma01
    DEFINE p_bma06  LIKE    bma_file.bma06
    DEFINE l_bmb03  LIKE    bmb_file.bmb03
    DEFINE l_bmb29  LIKE    bmb_file.bmb29
    DEFINE l_success_cnt LIKE type_file.num5
    DEFINE l_bmb    DYNAMIC ARRAY OF RECORD
                    bmb03   LIKE bmb_file.bmb03,
                    bmb29   LIKE bmb_file.bmb29,
                    bmauser LIKE bma_file.bmauser
                END RECORD
    DEFINE l_cnt,l_idx    LIKE type_file.num5

    LET l_success_cnt = 0 
    LET l_cnt = 1 
    FOREACH cbmp600_bmb03_dlc USING p_bma01,p_bma06 INTO l_bmb[l_cnt].*
        IF STATUS THEN  
            CALL cl_err("cbmp600_bmb03_dlc",SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
        END IF
        LET l_cnt = l_cnt +1
    END FOREACH

    FOR l_idx = 1 TO l_bmb.getLength()-1
        
        LET g_flag = 'Y' 
        CALL s_cbmp600_b(l_bmb[l_idx].bmb03,l_bmb[l_idx].bmb29) 
        IF g_success = 'N' THEN 
            LET g_totsuccess ='N'
            CONTINUE FOR 
        END IF 

        IF g_flag = 'Y' THEN

            CALL g_success_bom.appendElement()
            LET g_success_bom[g_success_bom.getLength()].bma01 = l_bmb[l_idx].bmb03
            LET g_success_bom[g_success_bom.getLength()].bma06 = l_bmb[l_idx].bmb29
            IF cl_null(g_success_bom[g_success_bom.getLength()].bma06) THEN LET g_success_bom[g_success_bom.getLength()].bma06 = ' ' END IF 
            LET g_success_bom[g_success_bom.getLength()].tim = CURRENT YEAR TO SECOND
            SELECT ima02,ima021 INTO g_success_bom[g_success_bom.getLength()].ima02,g_success_bom[g_success_bom.getLength()].ima021 FROM ima_file where ima01 = l_bmb[l_idx].bmb03
            IF cl_null(g_success_bom[g_success_bom.getLength()].ima02) THEN LET g_success_bom[g_success_bom.getLength()].ima02 = ' ' END IF 
            IF cl_null(g_success_bom[g_success_bom.getLength()].ima021) THEN LET g_success_bom[g_success_bom.getLength()].ima021 = ' ' END IF 
            
            LET g_success_bom[g_success_bom.getLength()].bmauser = l_bmb[l_idx].bmauser
        ELSE 
            LET g_flag = 'Y'
        END IF
        CALL s_cbmp600_e(l_bmb[l_idx].bmb03) 
        IF g_success = 'N' THEN 
            LET g_totsuccess ='N'
            CONTINUE FOR 
        END IF

        CALL s_cbmp600_bom(l_bmb[l_idx].bmb03,l_bmb[l_idx].bmb29)
        IF g_success = 'N' THEN 
            LET g_totsuccess ='N'
            CONTINUE FOR 
        END IF

    END FOR   
END FUNCTION
#---單身元件未審核不可確認與發放
FUNCTION s_cbmp600_chk_bmb03(p_bma01,p_bma06)
    DEFINE p_bma01 LIKE bma_file.bma01
    DEFINE p_bma06 LIKE bma_file.bma06
    DEFINE l_ima01   LIKE ima_file.ima01
    DEFINE l_imaacti LIKE ima_file.imaacti
    DEFINE l_bmb03   LIKE bmb_file.bmb03  
    DEFINE l_ima70   LIKE ima_file.ima70
    DEFINE l_bmb15   LIKE bmb_file.bmb15
 
    LET l_ima01 = NULL
    LET l_imaacti = NULL
 
    DECLARE i600_bmb03_cs CURSOR FOR
      SELECT bmb03,bmb15
        FROM bmb_file
       WHERE bmb01 = p_bma01
         AND bmb29 = p_bma06
  
    FOREACH i600_bmb03_cs INTO l_bmb03,l_bmb15
       SELECT ima01,imaacti,ima70
         INTO l_ima01,l_imaacti,l_ima70
         FROM ima_file
        WHERE ima01 = l_bmb03
 
       IF l_imaacti MATCHES '[PH]' THEN
          CALL s_errmsg('bmb01,bmb03',p_bma01||","||l_bmb03,'i600:','abm-084',1)
          LET g_success = 'N'
          CONTINUE FOREACH
       END IF
       IF l_ima70 <> l_bmb15 THEN
          CALL s_errmsg('bmb01,bmb03',p_bma01||","||l_bmb03,'i600:','cbm-002',1)
          LET g_success = 'N'
          CONTINUE FOREACH
       END IF
    END FOREACH 
    IF g_success = 'N' THEN
       RETURN
    END IF
    RETURN TRUE 
END FUNCTION


FUNCTION scbmp600_i100_e_work(p_ecu01,p_ecu02)
DEFINE p_ecu01      LIKE ecu_file.ecu01
DEFINE p_ecu02      LIKE ecu_file.ecu02
DEFINE l_sql,l_sql1      STRING 
DEFINE l_ecb06     LIKE ecb_file.ecb06
DEFINE l_bmb_e     RECORD 
       ecb06       LIKE ecb_file.ecb06,
       ecbud04     LIKE ecb_file.ecbud04
      END RECORD  
DEFINE lst_token base.StringTokenizer
DEFINE l_bmb02     LIKE bmb_file.bmb02
DEFINE l_bmbud02   LIKE bmb_file.bmbud02
DEFINE l_x         LIKE type_file.num5
DEFINE l_bmb09     LIKE bmb_file.bmb09

    IF p_ecu01 IS NULL THEN 
        CALL s_errmsg('ecu01,ecu02',p_ecu01||","||p_ecu02,'',-400,1)
        # CALL cl_err('',-400,0) 
        LET g_success = 'N'
        RETURN 
    END IF 
    
    LET g_success = 'Y'
    UPDATE bmb_file SET bmb09 = ' ' 
                  WHERE bmb01 = p_ecu01 AND (bmb05>g_today OR bmb05 IS NULL)
    IF SQLCA.sqlcode THEN      
        CALL s_errmsg('ecu01,ecu02',p_ecu01||","||p_ecu02,'upd:bmb_file',SQLCA.sqlcode,1)
        # CALL cl_err3("upd","bmb_file",l_ecu.ecu01,'',SQLCA.sqlcode,"","",1) 
        LET g_success = 'N' 
        RETURN
    END IF
    LET l_x = 0
    SELECT COUNT(*) INTO l_x FROM ecb_file WHERE ecb01 =p_ecu01 AND ecbud04 IS NOT NULL 
    IF l_x >0 THEN 
       LET l_sql = "SELECT ecb06,ecbud04 FROM ecb_file",
                   " WHERE ecb01 ='",p_ecu01,"' ",
                   "   AND ecbud04 is not null",
                   " ORDER BY ecb03"
       PREPARE i600_e_scbmp600_pb FROM l_sql
       DECLARE bmb_e_cbmp600_curs CURSOR FOR i600_e_scbmp600_pb

       INITIALIZE l_bmb_e.* TO NULL
       FOREACH bmb_e_cbmp600_curs INTO l_bmb_e.*   
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             LET g_success = 'N'
             RETURN
          END IF
       
          LET lst_token = base.StringTokenizer.create(l_bmb_e.ecbud04, "|")
          WHILE lst_token.hasMoreTokens()
             LET l_bmb02 = ''
             LET l_bmbud02 = lst_token.nextToken()
             LET l_x = 0
             SELECT COUNT(*) INTO l_x FROM bmb_file WHERE bmbud02= l_bmbud02 AND bmb01 = p_ecu01
             IF l_x >0 THEN 
                LET l_sql = "SELECT bmb02 FROM bmb_file",
                            " WHERE bmb01 ='",p_ecu01,"' ",
                            "   AND bmbud02= '",l_bmbud02,"'",
                            "  AND (bmb05 >to_date('",g_today,"','YY/MM/DD') OR bmb05 IS NULL)",
                            " ORDER BY bmb02"
                PREPARE i600_bmb_cbmp600_pb FROM l_sql
                DECLARE bmb_bmb_cbmp600_curs CURSOR FOR i600_bmb_cbmp600_pb
                LET l_bmb02 = ''
                FOREACH bmb_bmb_cbmp600_curs INTO l_bmb02
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('foreach:',SQLCA.sqlcode,1)
                      LET g_success = 'N'
                      RETURN
                   END IF
                   LET l_bmb09 = ''
                   SELECT bmb09 INTO l_bmb09 FROM bmb_file WHERE bmbud02= l_bmbud02 AND bmb01 = p_ecu01 AND bmb02 = l_bmb02
                   IF NOT cl_null(l_bmb09) THEN
                      CONTINUE WHILE  
                   ELSE 
                      UPDATE bmb_file SET bmb09 = l_bmb_e.ecb06 
                                    WHERE bmb01 = p_ecu01
                                      AND bmb02 = l_bmb02
                      IF SQLCA.sqlcode THEN      
                        CALL s_errmsg('ecu01,bmb02',p_ecu01||","||l_bmb02,'upd:bmb_file',SQLCA.sqlcode,1)
                        #  CALL cl_err3("upd","bmb_file",g_ecu.ecu01,l_bmb02,SQLCA.sqlcode,"","",1) 
                         LET g_success = 'N' 
                         EXIT FOREACH 
                      END IF
                   END IF 
                END FOREACH 
             END IF 
          END WHILE
       END FOREACH
    ELSE 
       LET g_success = 'N'
    END IF 

END FUNCTION 

FUNCTION scbmp600_i100_ecbud04(p_ecu01,p_ecu02,p_ecbud04)
DEFINE l_sql,l_sql1      STRING 
DEFINE l_ecb06     LIKE ecb_file.ecb06
DEFINE l_ecbud04   LIKE ecb_file.ecbud04
DEFINE l_ecbud04_1 LIKE ecb_file.ecbud04
DEFINE l_ecbud04_2 LIKE ecb_file.ecbud04
DEFINE lst_token base.StringTokenizer
DEFINE lst_token1 base.StringTokenizer
DEFINE l_bmb02     LIKE bmb_file.bmb02
DEFINE l_bmbud02   LIKE bmb_file.bmbud02
DEFINE l_x         LIKE type_file.num5
DEFINE l_bmb09     LIKE bmb_file.bmb09
DEFINE l_num       LIKE type_file.num5
DEFINE p_ecbud04   LIKE ecb_file.ecbud04   
DEFINE p_ecu01     LIKE ecu_file.ecu01,
       p_ecu02     LIKE ecu_file.ecu02
    IF p_ecu01 IS NULL THEN 
       CALL cl_err('',-400,0) 
       RETURN 
    END IF 

    DELETE FROM aeci100_tmp

    LET g_success = 'Y' 
    
    LET l_sql = "SELECT ecbud04 FROM ecb_file",
                " WHERE ecb01 ='",p_ecu01,"' ",
                "   AND ecb02 = '",p_ecu02,"' ",
                "   AND ecbud04 is not null",
                " ORDER BY ecb03"
    PREPARE i600_e_scbmp600_pb1 FROM l_sql
    DECLARE bmb_e_scbmp600_curs1 CURSOR FOR i600_e_scbmp600_pb1

    LET l_ecbud04 = ''
    FOREACH bmb_e_scbmp600_curs1 INTO l_ecbud04   
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
        END IF
    
        LET lst_token = base.StringTokenizer.create(l_ecbud04, "|")
        WHILE lst_token.hasMoreTokens()
            LET l_ecbud04_1 = lst_token.nextToken()
            SELECT COUNT(*) INTO l_num FROM aeci100_tmp WHERE ecbud04 = l_ecbud04_1
            IF l_num =0 OR cl_null(l_num) THEN
                INSERT INTO aeci100_tmp VALUES(l_ecbud04_1)
            ELSE 
                LET g_success = 'N'
            END IF 
        END WHILE
    END FOREACH

    IF NOT cl_null(p_ecbud04) THEN
        LET lst_token1 = base.StringTokenizer.create(p_ecbud04, "|")
        WHILE lst_token1.hasMoreTokens()
            LET l_ecbud04_2 = lst_token1.nextToken()
            SELECT COUNT(*) INTO l_num FROM aeci100_tmp WHERE ecbud04 = l_ecbud04_2
            IF l_num = 0 OR cl_null(l_num) THEN
                INSERT INTO aeci100_tmp VALUES(l_ecbud04_2)
            ELSE 
                LET g_success = 'N'
            END IF 
        END WHILE
    END IF 
END FUNCTION
FUNCTION s_cbmp600_crt_temp()
    DROP TABLE aeci100_tmp
    CREATE TEMP TABLE aeci100_tmp(    
            ecbud04   LIKE ecb_file.ecbud04) 
END FUNCTION
FUNCTION s_cbmp600_mail() 
    DEFINE l_cmd,l_mail     STRING
    DEFINE l_recipient,l_title STRING
    DEFINE l_filename,l_xmlname STRING
    
    LET l_filename = s_cbmp600_get_content()
    LET l_recipient = s_cbmp600_get_recipient()
    LET l_title = g_first_bma01," BOM、MI 工单审核发放通知--系统自动发送" #mod:darcy:2022/04/15

    LET l_xmlname = s_cbmp600_get_mail(l_filename,l_recipient,l_title," ")

    LET l_cmd = "sh /u1/topprod/tiptop/ds4gl2/bin/javamail/UnixMailSender.bat ",l_xmlname," TRUE"
    RUN l_cmd 
    LET l_cmd = "mv ",l_filename," /u1/out/mail/posted/"
    RUN l_cmd 
    LET l_cmd = "rm ",l_xmlname
    RUN l_cmd 

    
END FUNCTION


FUNCTION s_cbmp600_get_content()
    DEFINE l_idx    LIKE type_file.num5
    DEFINE l_filename   STRING 
    DEFINE l_cmd        STRING
    DEFINE l_gen02      LIKE gen_file.gen02

    LET l_filename = CURRENT YEAR TO FRACTION(3)
    
    LET l_filename = "/u1/out/mail/",cl_replace_str(l_filename," ",""),".html" 
    LET l_cmd = "rm ",l_filename
    RUN l_cmd
    LET l_cmd = "cd /u1/out/mail && cat /u1/out/mail/head >> ",l_filename
    RUN l_cmd

    FOR l_idx = 1 TO g_success_bom.getLength() 
        RUN "cd /u1/out/mail && echo '<tr>' >> '"||l_filename||"'" 
        RUN "cd /u1/out/mail && echo '<td>"||g_success_bom[l_idx].bma01||"</td>' >> '"||l_filename||"'"
        RUN "cd /u1/out/mail && echo '<td>"||g_success_bom[l_idx].ima02||"</td>' >> '"||l_filename||"'"
        RUN "cd /u1/out/mail && echo '<td>"||g_success_bom[l_idx].ima021||"</td>' >> '"||l_filename||"'"
        RUN "cd /u1/out/mail && echo '<td>"||g_success_bom[l_idx].bma06||"</td>' >> '"||l_filename||"'"
        RUN "cd /u1/out/mail && echo '<td>"||g_success_bom[l_idx].tim||"</td>' >> '"||l_filename||"'"
        RUN "cd /u1/out/mail && echo '</tr>' >> '"||l_filename||"'"
    END FOR 
    RUN "echo '</table>' >> "||l_filename
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_user
    RUN "echo '<p> 上述资料审核发放人员"||g_user||"-"||l_gen02||" </p>' >> "||l_filename
    RUN "echo '<p> 邮件生成时间:"||CURRENT YEAR TO SECOND||"</p>' >> "||l_filename
    RUN "echo '</body>' >> "||l_filename
    RUN "echo '</html>' >> "||l_filename 
    RUN "echo '\n\n 通知收件人：这封电子邮件和与其一起传送的任何文件都是机密的，仅供被发送邮件的个人或实体使用。如果您不是预定的收件人，并且错误地收到了这份信息，我们要求您删除并销毁您所拥有的所有副本和附件，并通知您，严格禁止根据本信息的内容披露、复制、分发或采取任何行动。 Notice to Recipients: This email and any files transmitted with it are confidential and intended solely for the use of the individual or entity to whom they are addressed. If you are not the intended recipient and received this transmittal in error we request that you please delete and destroy all copies and attachments in your possession, you are notified that disclosing, copying, distributing or taking any action in reliance on the contents of this information is strictly prohibited. ' >> "||l_filename

    RETURN l_filename
END FUNCTION

FUNCTION s_cbmp600_get_mail(p_filename,p_recipient,p_title,p_attach)
    DEFINE l_xmlname,p_filename,p_recipient,p_title,p_attach,l_cmd    STRING

    LET l_xmlname = CURRENT YEAR TO FRACTION(3)
    LET l_xmlname = "/u1/out/mail/",cl_replace_str(l_xmlname," ",""),".xml"
    
    RUN "echo '<Mail>' >> "||l_xmlname  
    RUN "echo '<Protocol>smtp</Protocol>' >> "||l_xmlname
    RUN "echo '<CheckAuth>Y</CheckAuth>' >> "||l_xmlname
    RUN "echo '<MailServer>59.82.44.168</MailServer>' >> "||l_xmlname
    RUN "echo '<MailServerPort>25</MailServerPort>' >> "||l_xmlname
    RUN "echo '<MailServerUser>bi@forewin-sz.com.cn</MailServerUser>' >> "||l_xmlname
    RUN "echo '<MailServerUserPassword>Fly12345678</MailServerUserPassword>' >> "||l_xmlname
    RUN "echo '<Subject>"||p_title||"</Subject>' >> "||l_xmlname
    RUN "echo '<MessageBody>"||p_filename||"</MessageBody>' >> "||l_xmlname
    RUN "echo '<Attach> </Attach>' >> "||l_xmlname
    RUN "echo '<Recipient>"||p_recipient||"</Recipient>' >> "||l_xmlname
    RUN "echo '<From>bi@forewin-sz.com.cn</From>' >> "||l_xmlname
    RUN "echo '</Mail>' >> "||l_xmlname  

    RETURN l_xmlname

END FUNCTION
FUNCTION s_cbmp600_get_recipient()
    DEFINE l_recipient  STRING 
    DEFINE l_reciplist  STRING 
    DEFINE l_idx    LIKE type_file.num5
    DEFINE l_gen06  LIKE gen_file.gen06
    DEFINE l_gen061  LIKE gen_file.gen06
    DEFINE l_gen062  LIKE gen_file.gen06    

    #增加aimi100的邮件通知

    LET l_recipient = "gongcheng1@forewin-sz.com.cn;", #工程
                      "bruce.han@forewin-sz.com.cn;",  #韩志伟
                      "yukun.zhang@forewin-sz.com.cn;",
                      "w.wang@forewin-sz.com.cn;",     #王委
                      "weixing.li@forewin-sz.com.cn;", #李卫星
                      "lusi.cheng@forewin-sz.com.cn;", #程露思
                      "mc23@forewin-sz.com.cn;", #孙俊英  darcy:2022/07/12
                      "darcy.li@forewin-sz.com.cn;"
    LET l_reciplist=  "liao.xia@forewin-sz.com.cn;"    #下料
    
    FOR l_idx = 1 TO g_success_bom.getLength() 
        SELECT gen06 INTO l_gen06 FROM gen_file 
         WHERE gen01 = g_success_bom[l_idx].bmauser
        IF NOT cl_null(l_gen06) AND l_reciplist NOT MATCHES "*"||l_gen06||"*" THEN 
             LET l_reciplist = l_reciplist,l_gen06,";"
        END IF
        
        EXECUTE cbmp600_imaud12 USING g_success_bom[l_idx].bma01 
           INTO l_gen061,l_gen062 

        IF NOT cl_null(l_gen061) AND l_reciplist NOT MATCHES "*"||l_gen061||"*" THEN 
             LET l_reciplist = l_reciplist,l_gen061,";"
        END IF
        IF NOT cl_null(l_gen062) AND l_reciplist NOT MATCHES "*"||l_gen062||"*" THEN 
             LET l_reciplist = l_reciplist,l_gen062,";"
        END IF
    END FOR

    LET l_recipient = l_recipient,l_reciplist
    RETURN l_recipient 
    # RETURN "darcy.li@forewin-sz.com.cn"
END FUNCTION  
