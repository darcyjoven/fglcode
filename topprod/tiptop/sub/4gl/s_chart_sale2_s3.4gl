# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_chart_sale2_s3.4gl
# Descriptions...: 多營運中心中查詢某一年度(月份)內各城區業績
# Date & Author..: No.FUN-BA0095 2011/11/10 By qiaozy
# Input Parameter: p_year     年度
#                  p_month    月份
#                  p_itemclass     產品分類
#                  p_loc      圖表位置
# Usage..........: CALL s_chart_sale2_s3(p_year,p_month,p_itemclass,p_loc)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_sale2_s3(p_year,p_month,p_itemclass,p_loc)
DEFINE p_year       LIKE type_file.num5
DEFINE p_month      LIKE type_file.num5
DEFINE p_itemclass  LIKE ima_file.ima131
DEFINE p_loc        LIKE type_file.chr10
DEFINE l_sql        STRING
DEFINE l_sql1       STRING
DEFINE l_sql3       STRING
DEFINE l_substr     STRING
DEFINE l_sale       RECORD
             rtz10  LIKE rtz_file.rtz10,
             azw01  LIKE azw_file.azw01,
             sale   LIKE ogb_file.ogb14t
                    END RECORD
DEFINE l_sale1       RECORD
             rtz10  LIKE rtz_file.rtz10,
             azw01  LIKE azw_file.azw01,
             sale   LIKE ogb_file.ogb14t
                    END RECORD
DEFINE l_rtz        RECORD
             rtz10  LIKE rtz_file.rtz10,
             azw01  LIKE azw_file.azw01
                    END RECORD
                    
DEFINE l_ryf02      LIKE ryf_file.ryf02  #城區名稱
DEFINE l_ryf03      LIKE ryf_file.ryf03
DEFINE l_oba02      LIKE oba_file.oba02  #產品分類名稱
DEFINE l_oba_str    STRING               #存放產品分類信息
DEFINE l_oba021     LIKE oba_file.oba02  #去年產品分類名稱
DEFINE l_sql2       STRING
DEFINE l_rtz01      LIKE rtz_file.rtz01  #營運中心
DEFINE l_sql4       STRING
DEFINE l_sql5       STRING
DEFINE l_rtz10      LIKE rtz_file.rtz10
DEFINE l_return       RECORD          #銷退額
             rtz10  LIKE rtz_file.rtz10,
             azw01  LIKE azw_file.azw01,
             sale   LIKE ogb_file.ogb14t
                    END RECORD
DEFINE l_return1       RECORD      #去年銷退額
             rtz10  LIKE rtz_file.rtz10,
             azw01  LIKE azw_file.azw01,
             sale   LIKE ogb_file.ogb14t
                    END RECORD 
DEFINE l_str        STRING
DEFINE l_year_sale  LIKE ogb_file.ogb14t
DEFINE l_year_sale1 LIKE ogb_file.ogb14t
DEFINE l_chk_auth   STRING


   WHENEVER ERROR CONTINUE
   CALL cl_chart_init(p_loc) #

   IF NOT s_chart_auth("s_chart_sale2_s3",g_user) THEN
      LET l_chk_auth=cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc,l_chk_auth)
      RETURN
   END IF

   DROP TABLE sale_per_s3_temp
   CREATE TEMP TABLE sale_per_s3_temp(
   rtz10  LIKE rtz_file.rtz10,
   azw01  LIKE azw_file.azw01,
   sale   LIKE ogb_file.ogb14t)
   DROP TABLE sale_per_s3_temp1
   CREATE TEMP TABLE sale_per_s3_temp1(
   rtz10  LIKE rtz_file.rtz10,
   azw01  LIKE azw_file.azw01,
   sale   LIKE ogb_file.ogb14t)
   DROP TABLE sale_per_s3_temp2
   CREATE TEMP TABLE sale_per_s3_temp2(
   rtz10 LIKE rtz_file.rtz10,
   azw01 LIKE azw_file.azw01)
   
   IF cl_null(p_year) THEN LET p_year=YEAR(TODAY) END IF
   LET l_sql3 = "SELECT rtz10,azw01 FROM rtz_file,azw_file WHERE rtz01=azw01 AND azw01 IN ",g_auth
   PREPARE s_chart_sale2_s FROM l_sql3
   DECLARE s_chart_sale2_s3 CURSOR FOR s_chart_sale2_s   #查找營運中心    
   FOREACH s_chart_sale2_s3 INTO l_rtz.* 
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      INSERT INTO sale_per_s3_temp2 VALUES (l_rtz.rtz10,l_rtz.azw01)
      INITIALIZE l_rtz.* TO NULL
   END FOREACH
   LET l_sql4 = "SELECT UNIQUE rtz10 FROM sale_per_s3_temp2"
   LET l_sql5 = "SELECT azw01 FROM sale_per_s3_temp2 WHERE rtz10= ?"
   PREPARE s_chart_sale2_s1 FROM l_sql4
   DECLARE s_chart_sale2_s31 CURSOR FOR s_chart_sale2_s1
   PREPARE s_chart_sale2_s2 FROM l_sql5
   DECLARE s_chart_sale2_s32 CURSOR FOR s_chart_sale2_s2
   INITIALIZE l_rtz.* TO NULL
   FOREACH s_chart_sale2_s31 INTO l_rtz.rtz10
      LET l_sale.sale=0
      LET l_sale1.sale=0
      LET l_year_sale=0
      LET l_year_sale1=0
      FOREACH s_chart_sale2_s32 USING l_rtz.rtz10 INTO l_rtz.azw01 
   #抓取銷售金額
         INITIALIZE l_sale.rtz10,l_sale.azw01 TO NULL
         INITIALIZE l_sale1.rtz10,l_sale1.azw01 TO NULL
         LET l_sale.sale=0
         LET l_sale1.sale=0
         LET l_sql = "SELECT SUM(a.ogb14t*oga24) FROM ",cl_get_target_table(l_rtz.azw01,'ogb_file')," a ",
                     " JOIN ",cl_get_target_table(l_rtz.azw01,'oga_file')," b  ON a.ogb01 = b.oga01 ",
                     "                                 AND b.oga09 IN ('2','3','4','6') ",
                     "                                 AND b.ogapost = 'Y' ",
                     "       LEFT OUTER JOIN ",cl_get_target_table(l_rtz.azw01,'ima_file'),"  c ON c.ima01 = a.ogb04 "
         LET l_sql1=l_sql CLIPPED," WHERE YEAR(b.oga02) = '",p_year,"' "
         LET l_sql2=l_sql CLIPPED," WHERE YEAR(b.oga02) = '",p_year-1,"' "
         IF NOT cl_null(p_month) THEN 
            LET l_sql1 = l_sql1 CLIPPED," AND MONTH(b.oga02) = '",p_month,"' "
            LET l_sql2 = l_sql2 CLIPPED," AND MONTH(b.oga02) = '",p_month,"' "
         END IF
         IF NOT cl_null(p_itemclass) THEN 
            LET l_sql1 = l_sql1 CLIPPED," AND c.ima131 = '",p_itemclass,"' "
            LET l_sql2 = l_sql2 CLIPPED," AND c.ima131 = '",p_itemclass,"' "
         END IF 
   
         CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        
         CALL cl_parse_qry_sql(l_sql1,l_rtz.azw01) RETURNING l_sql1
         CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
         CALL cl_parse_qry_sql(l_sql2,l_rtz.azw01) RETURNING l_sql2
         PREPARE sel_sale_pre FROM l_sql1
         EXECUTE sel_sale_pre INTO l_sale.sale
         PREPARE sel_sale_pre1 FROM l_sql2
         EXECUTE sel_sale_pre1 INTO l_sale1.sale
         IF cl_null(l_sale.sale) THEN LET l_sale.sale=0 END IF
         IF cl_null(l_sale1.sale) THEN LET l_sale1.sale=0 END IF
   

   #抓取销退金额
         INITIALIZE l_sale.rtz10,l_sale.azw01 TO NULL
         INITIALIZE l_sale1.rtz10,l_sale1.azw01 TO NULL
         LET l_return.sale=0
         LET l_return1.sale=0 
         LET l_sql = "SELECT SUM(a.ohb14t*oha24)*(-1) FROM ",cl_get_target_table(l_rtz.azw01,'ohb_file')," a ",
                     " JOIN ",cl_get_target_table(l_rtz.azw01,'oha_file')," b ON a.ohb01 = b.oha01 ",
                     "                                 AND b.oha05 IN ('1','2') ",
                     "                                 AND b.ohapost = 'Y' ",
                     "       LEFT OUTER JOIN ",cl_get_target_table(l_rtz.azw01,'ima_file'),"  c ON c.ima01 = a.ohb04 "
         LET l_sql1 = l_sql CLIPPED," WHERE YEAR(b.oha02) = '",p_year,"' "
         LET l_sql2 = l_sql CLIPPED," WHERE YEAR(b.oha02) = '",p_year-1,"' "
         IF NOT cl_null(p_month) THEN 
            LET l_sql1 = l_sql1 CLIPPED," AND MONTH(b.oha02) = '",p_month,"' "
            LET l_sql2 = l_sql2 CLIPPED," AND MONTH(b.oha02) = '",p_month,"' "
         END IF
         IF NOT cl_null(p_itemclass) THEN 
            LET l_sql1 = l_sql1 CLIPPED," AND c.ima131 = '",p_itemclass,"' "
            LET l_sql2 = l_sql2 CLIPPED," AND c.ima131 = '",p_itemclass,"' "
         END IF 
   
         CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        
         CALL cl_parse_qry_sql(l_sql1,l_rtz.azw01) RETURNING l_sql1
         CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
         CALL cl_parse_qry_sql(l_sql2,l_rtz.azw01) RETURNING l_sql2
         PREPARE sel_return_pre FROM l_sql1
         EXECUTE sel_return_pre INTO l_return.sale
         PREPARE sel_return_pre1 FROM l_sql2
         EXECUTE sel_return_pre1 INTO l_return1.sale
         IF cl_null(l_return.sale) THEN LET l_return.sale=0 END IF
         IF cl_null(l_return1.sale) THEN LET l_return1.sale=0 END IF
         LET l_year_sale=l_sale.sale+l_return.sale #營業額
         LET l_year_sale1=l_sale1.sale+l_return1.sale  #營業額
         INSERT INTO sale_per_s3_temp VALUES(l_rtz.rtz10,l_rtz.azw01,l_year_sale)
         INSERT INTO sale_per_s3_temp1 VALUES(l_rtz.rtz10,l_rtz.azw01,l_year_sale1)
      END FOREACH
      LET l_sale.sale=0
      LET l_sale1.sale=0
      INITIALIZE l_ryf02 TO NULL
      SELECT SUM(sale) INTO l_sale.sale FROM sale_per_s3_temp WHERE rtz10=l_rtz.rtz10 AND rtz10 IS NOT NULL 
      SELECT SUM(sale) INTO l_sale1.sale FROM sale_per_s3_temp1 WHERE rtz10=l_rtz.rtz10 AND rtz10 IS NOT NULL
      SELECT ryf02 INTO l_ryf02 FROM ryf_file WHERE ryf01=l_rtz.rtz10
      IF cl_null(l_ryf02) THEN
          LET l_str=l_rtz.rtz10 CLIPPED
      ELSE
         LET l_str=l_rtz.rtz10 CLIPPED,"(",l_ryf02,")"
      END IF
      CALL cl_chart_array_data(p_loc,"categories","",l_str)
      CALL cl_chart_array_data(p_loc,"dataset",p_year,l_sale.sale)
      CALL cl_chart_array_data(p_loc,"dataset",p_year-1,l_sale1.sale)
   END FOREACH
   INITIALIZE l_substr TO NULL
   LET l_substr = cl_getmsg('agl-172',g_lang),":",p_year  #年度
   IF NOT cl_null(p_month) THEN
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz-159',g_lang),":",p_month CLIPPED  #月份
   END IF
   
   IF NOT cl_null( p_itemclass ) THEN 
      INITIALIZE l_oba02,l_oba_str TO NULL
      SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = p_itemclass
      IF NOT cl_null(l_oba02) THEN
         LET l_oba_str = l_oba02
      END IF 
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz1101',g_lang),":",p_itemclass CLIPPED,"(",l_oba_str,")"   #產品分類
   END IF

   IF NOT cl_null(l_substr) THEN
      CALL cl_chart_attr(p_loc,"subcaption",l_substr)    #設定子標題
   END IF
   CALL cl_chart_create(p_loc,"s_chart_sale2_s3")  
   CALL cl_chart_clear(p_loc)   


END FUNCTION

#FUN-BA0095
