# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: axcq906.4gl
# Descriptions...: 工单发料分录底稿整批生成作业
# Date & Author..: 10/06/25 By wujie   #No.FUN-AA0025
# Modify.........:
# Modify.........: No:FUN-B40056 11/05/13 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:TQC-BB0046 11/11/04 By yinhy 分錄底稿根據幣種取位
# Modify.........: No:MOD-C70140 12/07/11 By yinhy 原幣取位時使用t_azi04
# Modify.........: No:MOD-CA0116 12/10/17 By wujie 原幣取位依然没写对
# Modify.........: No:FUN-D20040 13/02/20 By wujie 增加ccc13，部门厂商的group，核算项1取ccc13
# Modify.........: No:MOD-D40073 13/04/11 By wujie 增加考虑科目是否做核算项管理
# Modify.........: No:MOD-D50164 13/05/20 By bart g_success預設為Y
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: No.FUN-D60025 13/06/05 by yuhuabao 根據系統設置自動帶摘要已經核算項

DATABASE ds   
#No.FUN-AA0025
GLOBALS "../../config/top.global"



FUNCTION p9061_gl(g_wc,b)
DEFINE l_npp       RECORD LIKE npp_file.*
DEFINE l_npq       RECORD LIKE npq_file.*
DEFINE l_ccc       RECORD LIKE ccc_file.*
DEFINE l_date      LIKE type_file.dat
DEFINE l_sql       STRING
DEFINE l_ccz12     LIKE ccz_file.ccz12 
DEFINE l_ccz21     LIKE ccz_file.ccz21
DEFINE l_wc        STRING
DEFINE l_npq02     LIKE npq_file.npq02
DEFINE l_ccc01     LIKE ccc_file.ccc01
DEFINE l_ccc02     LIKE ccc_file.ccc02
DEFINE l_ccc03     LIKE ccc_file.ccc03
DEFINE l_ccc04     LIKE ccc_file.ccc04
DEFINE l_ccc09     LIKE npq_file.npq03
DEFINE l_ccc10     LIKE npq_file.npq07
DEFINE l_ccc11     LIKE ccc_file.ccc11
DEFINE l_cdf01     LIKE cdf_file.cdf01
DEFINE l_cdf02     LIKE cdf_file.cdf02
DEFINE l_cdf03     LIKE cdf_file.cdf03
DEFINE l_cdf04     LIKE cdf_file.cdf04
DEFINE l_cdf08     LIKE cdf_file.cdf08
DEFINE l_cdf09     LIKE cdf_file.cdf09
DEFINE l_cdf10     LIKE cdf_file.cdf10
DEFINE g_wc        STRING 
DEFINE b           LIKE aaa_file.aaa01
DEFINE l_n         LIKE type_file.num5
DEFINE l_sumc      LIKE npq_file.npq07
DEFINE l_sumd      LIKE npq_file.npq07
DEFINE l_npq04      LIKE npq_file.npq04
DEFINE l_npq06,l_npq061      LIKE npq_file.npq06
DEFINE l_sumfc     LIKE npq_file.npq07f
DEFINE l_sumfd     LIKE npq_file.npq07f
DEFINE l_aag05     LIKE aag_file.aag05
#DEFINE l_ccc13     LIKE ccc_file.ccc13   #No.FUN-D20040
DEFINE l_aag15     LIKE aag_file.aag15   #No.MOD-D40073
DEFINE l_flag      LIKE type_file.chr1   #FUN-D40118 add
DEFINE g_aag44     LIKE aag_file.aag44   #FUN-D40118 add
DEFINE l_bookno1   LIKE aza_file.aza81   #FUN-D60025
DEFINE l_bookno2   LIKE aza_file.aza82   #FUN-D60025
DEFINE l_bookno3   LIKE aza_file.aza81   #FUN-D60025


   WHENEVER ERROR CALL cl_err_msg_log
   INITIALIZE l_ccc.* TO NULL

   #LET g_success = 'N'  #MOD-D50164
   LET g_success = 'Y'  #MOD-D50164
  LET l_wc = cl_replace_str(g_wc,"ta_ccc02","ta_ccc02")
   LET l_wc = cl_replace_str(l_wc,"ta_ccc03","ta_ccc03")
#   LET l_wc = cl_replace_str(l_wc,"ccg03","ccc03")
   
   SELECT ccz12,ccz21 INTO l_ccz12,l_ccz21 FROM ccz_file 
   
  # LET l_sql = "SELECT DISTINCT ta_ccc01,ta_ccc02,ta_ccc03 ",
    LET l_sql = "SELECT DISTINCT '',ta_ccc02,ta_ccc03 ",
               "  FROM cxcq906_file ",
               " WHERE ",l_wc CLIPPED 

   PREPARE p9061_p3 FROM l_sql

   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      LET g_success ='N'
      RETURN
   END IF
   DECLARE p9061_c3 CURSOR FOR p9061_p3
 # l_npq04,l_ccc02,l_npq06,l_ccc09,l_ccc10  
 
  # LET l_sql = "SELECT '工单发料','','1',ima39,SUM(sclyc) ",
    LET l_sql = "SELECT '工单发料','','1','500101',SUM(sclyc),'1' ",   
               " FROM cxcq906_file ",
              # " WHERE ta_ccc01 =? ",
               "   WHERE ta_ccc02 =? ",
               "   AND ta_ccc03 =? ", 
             #  "   AND ima39='500101'  ",
             #  "GROUP BY ima39 ",            #No.FUN-D20040 add ccc13
               " UNION ",
               "SELECT '工单发料结转','','1','500101',SUM(ta_ccc32),'1' ", 
               " FROM cxcq901_file ",  
             #  "  FROM ta_ccc_file",
            #   " ,ima_file ",
              # " WHERE ta_ccc01 =? ",
               "   WHERE ta_ccc02 =? ",
               "   AND ta_ccc03 =? ",
             #  "   AND ima01=ta_ccc01 ", 
             #  "   AND ima39='500101'  ",
             #  "GROUP BY ima39 ",                 #No.FUN-D20040 add ccc13
               " UNION ",
               "SELECT '工单发料','','1','500102',SUM(sclyr),'1' ",   
               "  FROM cxcq906_file ",
             # " WHERE ta_ccc01 =? ",
               "   WHERE ta_ccc02 =? ",
               "   AND ta_ccc03 =? ", 
             #  "   AND ima39='500102'  ",
             #  "GROUP BY ima39 ",
               " UNION ",
               "SELECT '工单发料','','1','500103',SUM(sclyz),'1' ",   
               "  FROM cxcq906_file ",
             #  " WHERE ta_ccc01 =? ",
               "   WHERE ta_ccc02 =? ",
               "   AND ta_ccc03 =? ", 
            #   "   AND ima39='500103'  ",
            #   "GROUP BY ima39 ",                  #No.FUN-D20040 add ccc13 
               " UNION ",
               "SELECT '工单发料','','1','500104',SUM(sclyj),'1' ",   
               "  FROM cxcq906_file ",
             #  " WHERE ta_ccc01 =? ",
               "   WHERE ta_ccc02 =? ",
               "   AND ta_ccc03 =? ", 
             #  "   AND ima39='500104'  ",
             #  "GROUP BY ima39 ",                 #No.FUN-D20040 add ccc13
               " UNION ",
               "SELECT '工单发料' ,'','2' ,ima39,SUM(sclyh),'2' ",   
               "  FROM cxcq906_file ",
             #  " WHERE ta_ccc01 =? ",
               "   WHERE ta_ccc02 =? ",
               "   AND ta_ccc03 =? ", 
               "   AND ima39='140201'  ",
               "GROUP BY ima39 ", 
               " UNION ",
               "SELECT '工单发料','','2',ima39,SUM(ta_ccc32),'2' ",   
                "  FROM cxcq901_file ", 
             #  "  FROM ta_ccc_file,ima_file ",
             #  " WHERE ta_ccc01 =? ",
               "   WHERE ta_ccc02 =? ",
               "   AND ta_ccc03 =? ",
             #  "   AND ima01=ta_ccc01 ",
               "   AND ima39='140301'  ",
                "GROUP BY ima39 ",            #No.FUN-D20040 add ccc13
               " UNION ",
               "SELECT '工单发料','','2',ima39,SUM(ta_ccc32),'2' ", 
               "  FROM cxcq901_file ",   
              # "  FROM ta_ccc_file,ima_file ",
            #   " WHERE ta_ccc01 =? ",
               "   WHERE ta_ccc02 =? ",
               "   AND ta_ccc03 =? ",
             #  "   AND ima01=ta_ccc01 ",
               "   AND ima39='140302'  ",
               "GROUP BY ima39 ",                 #No.FUN-D20040 add ccc13
               " UNION ",
              #"SELECT '工单发料' ,'','2',ima39,-1*SUM(sclyh),'2' ",   #mark by pane 210218 
               "SELECT '工单发料' ,'','2',ima39,SUM(sclyh),'2' ",   #mod by pane 210218
               "  FROM cxcq906_file ",
            #  " WHERE ta_ccc01 =? ",
               "   WHERE ta_ccc02 =? ",
               "   AND ta_ccc03 =? ", 
               "   AND ima39='1405'  ",
               "GROUP BY ima39 ",
                " UNION ",
               "SELECT '工单发料','','2',ima39,SUM(ta_ccc32) ,'2'", 
               "  FROM cxcq901_file ",  
            #    "  FROM ta_ccc_file,ima_file ",
           #    " WHERE ta_ccc01 =? ",
               "   WHERE ta_ccc02 =? ",
               "   AND ta_ccc03 =? ",
             #  "   AND ima01=ta_ccc01 ",
               "   AND ima39='1407'  ",
               "GROUP BY ima39 "  
              

   PREPARE p9061_p4 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      LET g_success ='N'
      RETURN
   END IF
   DECLARE p9061_c4 CURSOR FOR p9061_p4

   LET l_sql = "SELECT cdf01,cdf02,cdf03,cdf04,cdf08,cdf10,SUM(cdf09) ",
               "  FROM cdf_file,aag_file ",
               " WHERE cdf01 =? ",
               "   AND cdf02 =? ",
               "   AND cdf03 =? ",
               "   AND cdf04 =? ",
               "   AND cdf01 = aag00 ",   
               "   AND cdf08 = aag01 ",
               "   AND aag05 ='Y' ", 
               "   AND cdf08 IS NOT NULL ",
               "GROUP BY cdf01,cdf02,cdf03,cdf04,cdf08,cdf10 ", 
               " UNION ",
               "SELECT cdf01,cdf02,cdf03,cdf04,cdf08,'',SUM(cdf09) ",
               "  FROM cdf_file,aag_file ",
               " WHERE cdf01 =? ",
               "   AND cdf02 =? ",
               "   AND cdf03 =? ",
               "   AND cdf04 =? ",  
               "   AND cdf01 = aag00 ",   
               "   AND cdf08 = aag01 ",
               "   AND aag05 ='N' ",
               "   AND cdf08 IS NOT NULL ",
               "GROUP BY cdf01,cdf02,cdf03,cdf04,cdf08 ",
               " UNION ",
               "SELECT cdf01,cdf02,cdf03,cdf04,cdf08,cdf10,cdf09 ",
               "  FROM cdf_file ",
               " WHERE cdf01 =? ",
               "   AND cdf02 =? ",
               "   AND cdf03 =? ",
               "   AND cdf04 =? ", 
               "   AND cdf08 IS NULL ",
               "ORDER BY cdf01,cdf02,cdf03,cdf04,cdf08 "

   PREPARE p9061_p5 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1) 
      LET g_success ='N'
      RETURN
   END IF
   DECLARE p9061_c5 CURSOR FOR p9061_p5
   #11911good
   FOREACH p9061_c3 INTO l_ccc.ccc01,l_ccc.ccc02,l_ccc.ccc03
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         LET g_success ='N'
         RETURN 
      END IF 
      INITIALIZE l_npp.* TO NULL
      
      LET l_npp.npptype =0
        
      LET l_date = MDY(l_ccc.ccc03,1,l_ccc.ccc02)
      LET l_npp.nppsys   = 'CA'
      LET l_npp.npp00    = 2  #工单发料
     # LET l_npp.npp01    = 'A',l_ccc.ccc01 CLIPPED,l_ccc.ccc01 CLIPPED,'-',l_ccc.ccc02 USING '&&&&',l_ccc.ccc03 CLIPPED USING '&&','0001'
      LET l_npp.npp01    = 'A','601','-',l_ccc.ccc02 USING '&&&&',l_ccc.ccc03 CLIPPED USING '&&','9061'
      LET l_npp.npp011   = 1
      LET l_npp.npp02    = s_last(l_date)
      LET l_npp.npp03    = NULL
      LET l_npp.npp03    = ''
      LET l_npp.npplegal =g_legal
#      SELECT DISTINCT ccclegal INTO l_npp.npplegal 
#        FROM ccc_file 
#       WHERE ccc01 = l_ccc.ccc01
#         AND ccc02 = l_ccc.ccc02
#         AND ccc03 = l_ccc.ccc03
         
         
      LET l_npp.nppglno  = NULL
      LET l_npp.npp07 = ''
      SELECT COUNT(*) INTO l_n FROM npp_file
       WHERE nppsys  = 'CA'
         AND npp00   = 2   ##工单发料
         AND npp01   = l_npp.npp01
         AND npp011  = 1
         AND npptype = l_npp.npptype
         AND nppglno IS NOT NULL 
         
      IF l_n >0 THEN  
         CALL cl_err(l_npp.npp01,'axm-275',1)
         LET g_success ='N' 
         RETURN 
      END IF 
                
      DELETE FROM npp_file
       WHERE nppsys  = 'CA'
         AND npp00   = 2
         AND npp01   = l_npp.npp01
         AND npp011  = 1
         AND npptype = l_npp.npptype
      
      INSERT INTO npp_file VALUES(l_npp.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL s_errmsg('nppsys','CA','insert npp_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF

#抓取帐套
#FUN-D60025 ------------ begin by yuhuabao 13/06/05
       CALL s_get_bookno(YEAR(l_npp.npp02)) RETURNING l_flag,l_bookno1,l_bookno2
       IF l_flag =  '1' THEN  #抓不到帳別
         CALL cl_err(l_npp.npp02,'aoo-081',1)
         LET g_success = 'N'
         RETURN
       END IF
       IF l_npp.npptype = '0' THEN
         LET l_bookno3 = l_bookno1
       ELSE
         LET l_bookno3 = l_bookno2
       END IF
#FUN-D60025 ------------ end by yuhuabao 13/06/05


   #insert npq_file 單身
      DELETE FROM npq_file
       WHERE npqsys  = 'CA'
         AND npq00   = 2
         AND npq01   = l_npp.npp01
         AND npq011  = 1
         AND npqtype = l_npp.npptype
         
   #FUN-B40056 --begin
      DELETE FROM tic_file
       WHERE tic04 = l_npp.npp01
   #FUN-B40056 --end

      LET l_npq02 = 1
      INITIALIZE l_npq.* TO NULL
    #  FOREACH p9061_c4 USING  l_ccc.ccc01,l_ccc.ccc02,l_ccc.ccc03,l_ccc.ccc01,l_ccc.ccc02,l_ccc.ccc03,l_ccc.ccc01,l_ccc.ccc02,l_ccc.ccc03,l_ccc.ccc01,l_ccc.ccc02,l_ccc.ccc03,l_ccc.ccc01,l_ccc.ccc02,l_ccc.ccc03,l_ccc.ccc01,l_ccc.ccc02,l_ccc.ccc03,l_ccc.ccc01,l_ccc.ccc02,l_ccc.ccc03,l_ccc.ccc01,l_ccc.ccc02,l_ccc.ccc03,l_ccc.ccc01,l_ccc.ccc02,l_ccc.ccc03,l_ccc.ccc01,l_ccc.ccc02,l_ccc.ccc03 
        FOREACH p9061_c4 USING  l_ccc.ccc02,l_ccc.ccc03,l_ccc.ccc02,l_ccc.ccc03,l_ccc.ccc02,l_ccc.ccc03,l_ccc.ccc02,l_ccc.ccc03,l_ccc.ccc02,l_ccc.ccc03,l_ccc.ccc02,l_ccc.ccc03,l_ccc.ccc02,l_ccc.ccc03,l_ccc.ccc02,l_ccc.ccc03,l_ccc.ccc02,l_ccc.ccc03,l_ccc.ccc02,l_ccc.ccc03 
                       INTO l_npq04,l_ccc02,l_npq06,l_ccc09,l_ccc10 ,l_npq061      #No.FUN-D20040 add ccc13                     
         IF STATUS THEN LET g_success = 'N' RETURN END IF
         IF l_ccc10  = 0 THEN CONTINUE FOREACH END IF 
         INITIALIZE l_npq.* TO NULL
         LET l_npq.npqsys ='CA'
         LET l_npq.npq00  = 2
         LET l_npq.npq01  =l_npp.npp01
         LET l_npq.npq011 = 1
         LET l_npq.npq02 = l_npq02
         LET l_npq.npq03 = l_ccc09
         LET l_npq.npq04 = l_npq04
       #  LET l_npq.npq05 = l_ccc11 
         IF l_npq.npq03  = '500102' THEN 
            LET l_npq.npq05 = 'B12'
         ELSE 
          	LET l_npq.npq05 = ''
         END IF 
         LET l_npq.npq06 = l_npq06
         IF cl_null(l_ccc10) THEN LET l_ccc10  =0 END IF
         IF l_ccc10  =0 THEN  CONTINUE FOREACH END IF 
         LET l_npq.npq07f = l_ccc10  
         LET l_npq.npq07  = l_ccc10  
         LET l_npq.npq24 = g_aza.aza17      #No.MOD-CA0116
         SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = l_npq.npq24 #No.MOD-CA0116
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)    #MOD-C70140
         LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)  #MOD-C70140
       # LET l_npq.npq07f = cl_digcut(l_npq.npq07f,2) 
       # LET l_npq.npq07  = cl_digcut(l_npq.npq07,2)
         LET l_npq.npq08 = NULL
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno3)       #FUN-D60025 add by yuhuabao130605
           RETURNING l_npq.*                                                   #FUN-D60025 add by yuhuabao130605
#No.FUN-D20040 --begin
#         LET l_npq.npq11 = ' '
         LET l_npq.npq11 = ''
#No.FUN-D20040 --end
#No.MOD-D40073 --begin
         LET l_aag15 = ''
         SELECT aag15 INTO l_aag15 FROM aag_file 
          WHERE aag00 = l_ccc01
            AND aag01 = l_npq.npq03
         IF cl_null(l_aag15) THEN 
            LET l_npq.npq11 = ' '
         END IF
#No.MOD-D40073 --end
          #固定借贷方向
          IF l_npq.npq06 <>l_npq061 THEN 
             IF l_npq.npq06 ='1' THEN 
                LET l_npq.npq06 ='2' 
             ELSE 
              	LET l_npq.npq06 ='1'
             END IF 
             LET l_npq.npq07 =l_npq.npq07 * -1
             LET l_npq.npq07f =l_npq.npq07f * -1
          END IF    
         #固定借贷方向
         LET l_npq.npq12 = ' '
         LET l_npq.npq13 = ' '
         LET l_npq.npq14 = ' '
         LET l_npq.npq15 = NULL
         LET l_npq.npq21 = NULL
         LET l_npq.npq22 = NULL
#        LET l_npq.npq24 = g_aza.aza17      #No.MOD-CA0116
         LET l_npq.npq25 = 1
         LET l_npq.npq30 = l_npp.npp06
         LET l_npq.npq31 = ' '
         LET l_npq.npq32 = ' '
         LET l_npq.npq33 = ' '
         LET l_npq.npq34 = ' '
         LET l_npq.npq35 = ' '
         LET l_npq.npq36 = ' '
         LET l_npq.npq37 = ' '
         LET l_npq.npqtype = l_npp.npptype
         LET l_npq.npqlegal =l_npp.npplegal
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = b
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,b) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         INSERT INTO npq_file VALUES(l_npq.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL s_errmsg('npq03',l_npq.npq03,'insert npq_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
         LET l_npq02 = l_npq02 + 1 
         LET g_success ='Y'
      END FOREACH 
END FOREACH

#   IF NOT cl_null(l_npp.npp01) THEN
#     LET l_ccc.ccc05 = l_npp.npp01
#     UPDATE ccc_file SET ccc05 = l_ccc.ccc05 
#       WHERE ccc01 = l_ccc.ccc01
#         AND ccc02 = l_ccc.ccc02
#         AND ccc03 = l_ccc.ccc03
#         AND ccc04 = l_ccc.ccc04

#   END IF   
    SELECT SUM(npq07) INTO l_sumc FROM npq_file 
       WHERE npqsys  = 'CA'
         AND npq00   = 2
         AND npq01   = l_npp.npp01
         AND npq011  = 1
         AND npqtype = l_npp.npptype 
         AND npq06   = '1'

    SELECT SUM(npq07) INTO l_sumd FROM npq_file 
      	WHERE npqsys  = 'CA'
         AND npq00   = 2
         AND npq01   = l_npp.npp01
         AND npq011  = 1
         AND npqtype = l_npp.npptype 
         AND npq06   = '2'

    SELECT SUM(npq07f) INTO l_sumfc FROM npq_file 
       WHERE npqsys  = 'CA'
         AND npq00   = 2
         AND npq01   = l_npp.npp01
         AND npq011  = 1
         AND npqtype = l_npp.npptype 
         AND npq06   = '1'

    SELECT SUM(npq07f) INTO l_sumfd FROM npq_file 
       WHERE npqsys  = 'CA'
         AND npq00   = 2
         AND npq01   = l_npp.npp01
         AND npq011  = 1
         AND npqtype = l_npp.npptype 
         AND npq06   = '2'

   IF cl_null(l_sumc) THEN LET l_sumc =0 END IF 
   IF cl_null(l_sumd) THEN LET l_sumd =0 END IF 
   IF cl_null(l_sumfc) THEN LET l_sumfc =0 END IF 
   IF cl_null(l_sumfd) THEN LET l_sumfd =0 END IF 
   
     IF g_success ='Y' AND l_sumc <> l_sumd  THEN 
      IF l_sumc <> l_sumd AND l_sumc  - l_sumd  >0 AND l_sumc  - l_sumd  < 1 THEN 
         LET l_npq02=''
         SELECT npq02 INTO l_npq02 FROM npq_file 
          WHERE NPQ01=l_npp.npp01 AND npqsys  = 'CA'  AND npq00   = 2 
             AND npq011  = 1 AND npqtype = l_npp.npptype AND npq06   = '2'
             AND NPQ07= ( SELECT MAX(npq07) FROM npq_file 
          WHERE NPQ01=l_npp.npp01 AND npqsys  = 'CA'  AND npq00   = 2 
             AND npq011  = 1 AND npqtype = l_npp.npptype AND npq06   = '2'  )
          IF NOT cl_null(l_npq02) THEN 
             UPDATE npq_file SET npq07= npq07+(l_sumc  - l_sumd),
                                 npq07f= npq07f+(l_sumc  - l_sumd)
              WHERE npqsys  = 'CA'
                AND npq00   = 2
                AND npq01   = l_npp.npp01
                AND npq011  = 1
                AND npqtype = l_npp.npptype 
                AND npq06   = '2' 
                AND npq02 = l_npq02 
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                CALL s_errmsg('npq02',l_npq02,'upd npq_file',SQLCA.sqlcode,1)
                LET g_success = 'N'
                RETURN
             END IF
          END IF
       END IF 
       IF l_sumc <> l_sumd AND l_sumd  - l_sumc  >0 AND l_sumd  - l_sumc  < 1 THEN 
         LET l_npq02=''
         SELECT npq02 INTO l_npq02 FROM npq_file 
          WHERE NPQ01=l_npp.npp01 AND npqsys  = 'CA'  AND npq00   = 2 
             AND npq011  = 1 AND npqtype = l_npp.npptype AND npq06   = '1'
             AND NPQ07= ( SELECT MAX(npq07) FROM npq_file 
          WHERE NPQ01=l_npp.npp01 AND npqsys  = 'CA'  AND npq00   = 2 
             AND npq011  = 1 AND npqtype = l_npp.npptype AND npq06   = '1'  )
          IF NOT cl_null(l_npq02) THEN 
             UPDATE npq_file SET npq07= npq07+(l_sumd  - l_sumc),
                                 npq07f= npq07f+(l_sumd  - l_sumc)
              WHERE npqsys  = 'CA'
                AND npq00   = 2
                AND npq01   = l_npp.npp01
                AND npq011  = 1
                AND npqtype = l_npp.npptype 
                AND npq06   = '1' 
                AND npq02 = l_npq02 
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                CALL s_errmsg('npq02',l_npq02,'upd npq_file',SQLCA.sqlcode,1)
                LET g_success = 'N'
                RETURN
             END IF
          END IF
       END IF  
    END IF  
    
   {IF g_success ='Y' AND l_sumc <> l_sumd THEN 
         INITIALIZE l_npq.* TO NULL
         LET l_npq.npqsys ='CA'
         LET l_npq.npq00  = 2
         LET l_npq.npq01  =l_npp.npp01
         LET l_npq.npq011 = 1
         LET l_npq.npq02 = l_npq02
         LET l_npq.npq03 = l_ccz21         
         LET l_npq.npq04 = ''
         LET l_npq.npq05 = NULL  
         IF l_sumc - l_sumd >0 THEN
            LET l_npq.npq06 = '2'
            LET l_npq.npq07f = l_sumfc - l_sumfd 
            LET l_npq.npq07  = l_sumc  - l_sumd         
         ELSE 
            LET l_npq.npq06 = '1'         
            LET l_npq.npq07f = l_sumfd - l_sumfc 
            LET l_npq.npq07  = l_sumd  - l_sumc
         END IF 
         LET l_npq.npq08 = NULL
         LET l_npq.npq11 = ' '
         LET l_npq.npq12 = ' '
         LET l_npq.npq13 = ' '
         LET l_npq.npq14 = ' '
         LET l_npq.npq15 = NULL
         LET l_npq.npq21 = NULL
         LET l_npq.npq22 = NULL
         LET l_npq.npq24 = g_aza.aza17
#No.MOD-CA0116 --begin
         SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = l_npq.npq24 #No.MOD-CA0116
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)    #MOD-C70140
         LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)  #MOD-C70140
#No.MOD-CA0116 --end  
         LET l_npq.npq25 = 1
         LET l_npq.npq30 = l_npp.npp06
         LET l_npq.npq31 = ' '
         LET l_npq.npq32 = ' '
         LET l_npq.npq33 = ' '
         LET l_npq.npq34 = ' '
         LET l_npq.npq35 = ' '
         LET l_npq.npq36 = ' '
         LET l_npq.npq37 = ' '
         LET l_npq.npqtype = l_npp.npptype
         LET l_npq.npqlegal =l_npp.npplegal
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = b
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,b) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno3)       #FUN-D60025 add by yuhuabao130605
           RETURNING l_npq.*                                                   #FUN-D60025 add by yuhuabao130605
         INSERT INTO npq_file VALUES(l_npq.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL s_errmsg('npq03',l_npq.npq03,'insert npq_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
         LET l_npq02 = l_npq02 + 1   
   END IF }
   CALL s_flows('3','',l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021  
   IF g_success ='Y' THEN CALL cl_err('','abm-019',0) END IF 
   IF g_success ='N'  THEN CALL cl_err('','aap-129',0) END IF 
     RETURN l_npp.npp01
END FUNCTION
