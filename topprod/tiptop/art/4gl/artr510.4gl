# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: artr510.4gl
# Descriptions...: 門店排行榜明細表
# Input parameter:
# Return code....:
# Date & Author..: 10/07/21 by huangtao
# Modify.........: NO.TQC-A70003 10/09/01 by huangtao
# Modify.........: #FUN-AA0024 10/10/21 By wangxin 報表改善
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No:TQC-B70204 11/07/28 By yangxf UNION 改成UNION ALL
# Modify.........: No.TQC-BC0018 12/01/16 By pauline 當select ccc23時,sataus = 100時,讓ccc23 = 0
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                          #Print condition RECORD
           wc1       LIKE type_file.chr1000, #Where condition 
           wc2       LIKE type_file.chr1000, 
           s         LIKE type_file.chr2,    #排序 
           yy1,yy2   LIKE type_file.dat,
           lim1,lim2 LIKE type_file.num5,
           type      LIKE type_file.chr1,  
           more      LIKE type_file.chr1     #Input more condition(Y/N)
           END RECORD
DEFINE l_num         LIKE type_file.num10  #判斷欄位是否為空，為空則值為0
DEFINE g_str         STRING                 
DEFINE g_sql         STRING                
DEFINE l_table       STRING
DEFINE l_wc          LIKE type_file.chr1000 
DEFINE g_chk_azp01   LIKE type_file.chr1
DEFINE g_chk_auth    STRING  
DEFINE g_azp01       LIKE azp_file.azp01 
DEFINE g_azp01_str   STRING   

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT    
   
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc2 = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8) 
   LET tm.yy1  = ARG_VAL(9)
   LET tm.yy2  = ARG_VAL(10)
   LET tm.lim1  = ARG_VAL(11)
   LET tm.lim2  = ARG_VAL(12)
   LET tm.type = ARG_VAL(13)
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF


    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 
    LET g_sql=  "rvvplant.rvv_file.rvvplant,",      #營運中心
                "azp02.azp_file.azp02,",            #門店名稱 
                "rvv17.rvv_file.rvv17,",            #進貨凈量
                "income.type_file.num15_3,",        #進貨凈額           
                "ogb12.ogb_file.ogb12,",            #銷售凈量
                "sales.type_file.num15_3,",         #銷售凈額
                "maori.type_file.num15_3,",         #毛利
                "gross.type_file.num15_3"           #毛利率
                
    LET l_table = cl_prt_temptable('artr510',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?,?,?,?)"  
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
 
                 

    
    LET tm2.s1   = tm.s[1,1]
    LET tm2.s2   = tm.s[2,2]
    IF cl_null(tm2.s1) THEN LET tm2.s1 = "5"  END IF
    IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF

    IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL artr510_tm()        # Input print condition
      ELSE CALL artr510() 
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION artr510_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     
DEFINE p_row,p_col    LIKE type_file.num5,   
       l_cmd          LIKE type_file.chr1000
DEFINE tok            base.StringTokenizer 
DEFINE l_zxy03        LIKE zxy_file.zxy03       

   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 6 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW artr510_w AT p_row,p_col
        WITH FORM "art/42f/artr510" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'  #成本計算方式
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.s ='  '
   LET tm.lim1='1'
   LET tm.lim2=''
   LET tm.type = g_ccz.ccz28
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
  CONSTRUCT BY NAME tm.wc1 ON azp01
                                 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         AFTER FIELD azp01 
            LET g_chk_azp01 = TRUE 
            LET g_azp01_str = get_fldbuf(azp01)  
            LET g_chk_auth = '' 
            IF NOT cl_null(g_azp01_str) AND g_azp01_str <> "*" THEN
               LET g_chk_azp01 = FALSE 
               LET tok = base.StringTokenizer.create(g_azp01_str,"|") 
               LET g_azp01 = ""
               WHILE tok.hasMoreTokens() 
                  LET g_azp01 = tok.nextToken()
                  SELECT zxy03 INTO l_zxy03 FROM zxy_file WHERE zxy01 = g_user AND zxy03 = g_azp01
                  IF STATUS THEN 
                     CONTINUE WHILE  
                  ELSE
                     IF g_chk_auth IS NULL THEN
                        LET g_chk_auth = "'",l_zxy03,"'"
                     ELSE
                        LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
                     END IF 
                  END IF
               END WHILE
               IF g_chk_auth IS NOT NULL THEN
                  LET g_chk_auth = "(",g_chk_auth,")"
               END IF  
            END IF 
            IF g_chk_azp01 THEN
               DECLARE r510_zxy_cs1 CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
               FOREACH r510_zxy_cs1 INTO l_zxy03 
                 IF g_chk_auth IS NULL THEN
                    LET g_chk_auth = "'",l_zxy03,"'"
                 ELSE
                    LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
                 END IF
               END FOREACH
               IF g_chk_auth IS NOT NULL THEN
                  LET g_chk_auth = "(",g_chk_auth,")"
               END IF 
            END IF
            
         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT      
            
         ON ACTION controlp
            CASE
              WHEN INFIELD(azp01)   #來源營運中心
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azw01"     
                   LET g_qryparam.state = "c"
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO azp01
                   NEXT FIELD azp01
            END CASE
            
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about          
            CALL cl_about()       
 
         ON ACTION help           
            CALL cl_show_help()   
 
         ON ACTION controlg       
            CALL cl_cmdask()     
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
            
         ON ACTION qbe_select
            CALL cl_qbe_select()
            
      END CONSTRUCT
         IF g_action_choice = "locale" THEN
            LET g_action_choice = ""
            CALL cl_dynamic_locale()
            CONTINUE WHILE
         END IF
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW artr510_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

  #    IF cl_null(tm.wc1) THEN
  #       LET tm.wc1 = " azp01 = '",g_plant,"'" 
  #    END IF

   CONSTRUCT BY NAME tm.wc2 ON ima131,ogb04
       BEFORE CONSTRUCT
         CALL cl_qbe_init()

       ON ACTION locale
          CALL cl_show_fld_cont()               
          LET g_action_choice = "locale"
          EXIT CONSTRUCT
    
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT

       ON ACTION about        
          CALL cl_about()    
 
       ON ACTION help         
          CALL cl_show_help() 
 
       ON ACTION controlg     
          CALL cl_cmdask()    
       ON ACTION controlp

         IF INFIELD(ima131) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima131_1"                      
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima131
               NEXT FIELD ima131
            END IF
         IF INFIELD(ogb04) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima01"                     
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ogb04
               NEXT FIELD ogb04
            END IF
         
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT CONSTRUCT
         #No.FUN-580031 --start--
       ON ACTION qbe_select
          CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
       IF INT_FLAG THEN
           LET INT_FLAG = 0 CLOSE WINDOW artr510_w 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time 
          EXIT PROGRAM
          
       END IF 
       IF cl_null(tm.wc2) THEN
         LET tm.wc2 = " 1=1"
       END IF
       DISPLAY BY NAME tm.lim1,tm.type,tm.more

       INPUT BY NAME
                tm.yy1,tm.yy2,tm.lim1,tm.lim2 ,tm2.s1,tm2.s2,tm.type,tm.more WITHOUT DEFAULTS  
             BEFORE INPUT
                CALL cl_qbe_display_condition(lc_qbe_sn)
          AFTER FIELD yy1
                IF cl_null(tm.yy1) THEN NEXT FIELD yy1 END IF
          AFTER FIELD yy2
                IF cl_null(tm.yy2 )OR tm.yy1>tm.yy2 THEN NEXT FIELD yy2 END IF
          AFTER FIELD lim1
                IF cl_null(tm.lim1) THEN NEXT FIELD lim1 END IF      #TQC-A70003
          AFTER FIELD lim2
                IF tm.lim2<tm.lim1  THEN NEXT FIELD lim2 END IF
          AFTER FIELD type                                               
                IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF
   
          AFTER FIELD more
                IF tm.more = 'Y'
                THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
                END IF
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
          ON ACTION CONTROLG CALL cl_cmdask()    # Command execution

          AFTER INPUT
              LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
        
          ON ACTION about        
             CALL cl_about()     
 
          ON ACTION help         
             CALL cl_show_help()  
 
 
          ON ACTION exit
             LET INT_FLAG = 1
             EXIT INPUT

          ON ACTION qbe_save
             CALL cl_qbe_save()
      
 
   END INPUT
   IF INT_FLAG THEN
       LET INT_FLAG = 0 CLOSE WINDOW artr510_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='artr510'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('artr510','9031',1)
      ELSE
         LET tm.wc2=cl_replace_str(tm.wc2, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", 
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc2 CLIPPED,"'",
                         " '",tm.yy1 CLIPPED,"'",
                         " '",tm.yy2 CLIPPED,"'" ,
                         " '",tm.lim1 CLIPPED,"'" ,
                         " '",tm.lim2 CLIPPED,"'" ,
                         " '",tm.s CLIPPED,"'",
                         " '",tm.type CLIPPED,"'" ,           
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'",          
                         " '",g_rpt_name CLIPPED,"'"           
         CALL cl_cmdat('artr510',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW artr510_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL artr510()
   ERROR ""
END WHILE
   CLOSE WINDOW artr510_w
END FUNCTION
   
FUNCTION artr510()
   DEFINE l_plant   LIKE  azp_file.azp01
   DEFINE l_azp02   LIKE  azp_file.azp02
   DEFINE l_name    LIKE type_file.chr20,            #External(Disk) file name  
          l_sql     STRING,          #RDSQL STATEMENT 
          l_chr     LIKE type_file.chr1,             
          l_za05    LIKE za_file.za05,              
          l_yy      LIKE type_file.num5,
          l_yy1     LIKE type_file.chr20,
          l_mm      LIKE type_file.num5, 
          l_mm1     LIKE type_file.chr20,  
          l_ccc23   LIKE ccc_file.ccc23,
          l_img04   LIKE img_file.img04,
          l_cost    LIKE ccc_file.ccc08,
          l_rvv17   LIKE rvv_file.rvv17, 
          l_rvv39t   LIKE rvv_file.rvv39t,
          l_rvv09   LIKE rvv_file.rvv09,
          l_income  LIKE type_file.num15_3,
          l_sales   LIKE type_file.num15_3,
          l_host    LIKE type_file.num15_3,
          l_maori   LIKE type_file.num15_3,
          l_gross   LIKE type_file.num15_3,
          l_oba02   LIKE oba_file.oba02,
          l_rvvplant  LIKE ogb_file.ogbplant,
          l_ima131  LIKE ima_file.ima131,
          l_ima02   LIKE ima_file.ima02,
          l_ogb04   LIKE ogb_file.ogb04,
          l_ogb12   LIKE ogb_file.ogb12,
          l_oea24   LIKE oea_file.oea24,
          l_azi10   LIKE azi_file.azi10,
          
          sr        RECORD
                    oga02    LIKE oga_file.oga02,
                    oga23    LIKE oga_file.oga23, 
                    oga24    LIKE oga_file.oga24,
                    ogb01    LIKE ogb_file.ogb01,
                    ogb03    LIKE ogb_file.ogb03,
                    ogb04    LIKE ogb_file.ogb04,       #產品編號
                    ogb12    LIKE ogb_file.ogb12,       #銷售數量
                    ogb14t   LIKE ogb_file.ogb14t,     
                    ogb09    LIKE ogb_file.ogb09,        #倉庫
          #         ogb091   LIKE ogb_file.ogb091,       #储位
                    ogb092   LIKE ogb_file.ogb092,       #批号
                    ogb41    LIKE ogb_file.ogb41,
                    ogbplant LIKE ogb_file.ogbplant,     #門店
          #         rvv31    LIKE rvv_file.rvv31,        #產品編號
          #         rvv17    LIKE rvv_file.rvv17,        #數量
                    ima01    LIKE ima_file.ima01,
                    ima02    LIKE ima_file.ima02,
                    ima131   LIKE ima_file.ima131,      #產品分類
                    imd16    LIKE imd_file.imd16        #利润中心
                    
                    END RECORD,
          sr1       RECORD
                    rvv17       LIKE rvv_file.rvv17,
                    rvv39t      LIKE rvv_file.rvv39t,
                    pmm22       LIKE pmm_file.pmm22,
                    pmm42       LIKE pmm_file.pmm42,
                    rva113      LIKE rva_file.rva113,
                    rva114      LIKE rva_file.rva114,
                    rvvplant    LIKE rvv_file.rvvplant

                    END RECORD
                    
      DEFINE l_str   LIKE type_file.chr1000 
      DEFINE l_db_type  STRING       #FUN-B40029

        DROP TABLE artr510_tmp2
     CREATE TEMP TABLE artr510_tmp2(
           rvvplant LIKE ogb_file.ogbplant,
           azp02 LIKE azp_file.azp02,
           ima131 LIKE ima_file.ima131,
           oba02 LIKE oba_file.oba02,
           ima02 LIKE ima_file.ima02,
           rvv17 LIKE rvv_file.rvv17,
           income LIKE type_file.num15_3,
           ogb04 LIKE ogb_file.ogb04,
           ogb12 LIKE ogb_file.ogb12,
           sales LIKE type_file.num15_3,
           maori LIKE type_file.num15_3 ) 
        #   gross  LIKE type_file.num5

        DROP TABLE artr510_tmp3
     CREATE TEMP TABLE artr510_tmp3(
            rvv17       LIKE rvv_file.rvv17,
            rvv39t      LIKE rvv_file.rvv39t,
            pmm22       LIKE pmm_file.pmm22,
            pmm42       LIKE pmm_file.pmm42,
            rva113      LIKE rva_file.rva113,
            rva114      LIKE rva_file.rva114,
            rvvplant    LIKE rvv_file.rvvplant)
       DELETE FROM artr510_tmp3       
      CALL cl_del_data(l_table)   
    LET l_sql = "SELECT DISTINCT azp01,azp02 FROM azp_file,azw_file ",
                " WHERE azw01 = azp01  ",
                " AND azp01 IN ",g_chk_auth,
                " ORDER BY azp01 " 

   PREPARE sel_azp01_pre FROM l_sql
   DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre
 
   FOREACH sel_azp01_cs INTO l_plant,l_azp02  
      IF STATUS THEN
         CALL cl_err('PLANT:',SQLCA.sqlcode,1)
         RETURN
      END IF  

    
      SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET tm.wc2 = tm.wc2 CLIPPED,cl_get_extra_cond('imauser', 'imagrup')


     LET l_wc = cl_replace_str(tm.wc2,"ogb04","rvv31")
     #FUN-AA0024  ----------------------begin----------------------------
     #LET l_sql = " SELECT rvv17,rvv39t,pmm22,pmm42,rva113,rva114,rvvplant ",
     #               " FROM ",cl_get_target_table(l_plant,'rvu_file'),
     #               "  ,",cl_get_target_table(l_plant,'ima_file'),
     #               " , ",cl_get_target_table(l_plant,'rvv_file'),
     #               " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'pmm_file')," ON pmm01 = rvv36 ",
     #               " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'rva_file')," ON rva01 = rvv04 ",
     #               " WHERE rvv31 = ima01 ",
     #               " AND rvv01 = rvu01 ",
     #               " AND rvu00 = '1'",
     #               " AND rvuconf = 'Y'",
     #               " AND (rvu03 BETWEEN '",tm.yy1,"' AND '",tm.yy2,"')",
     #               " AND ",l_wc CLIPPED,
     #               " AND rvvplant = '",l_plant,"'"
     
     LET l_sql = " SELECT rvv17-(SELECT CASE WHEN SUM(rvv17) IS NULL THEN 0 ELSE SUM(rvv17) END ",
     	           " FROM ",cl_get_target_table(l_plant,'rvu_file'),
     	           "     ,",cl_get_target_table(l_plant,'ima_file'),
     	           "     ,",cl_get_target_table(l_plant,'rvv_file'),
                 " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'pmm_file')," ON pmm01 = rvv36 ", 
                 " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'rva_file')," ON rva01 = rvv04 ",
                 " WHERE rvv31 = ima01 AND rvv01 = rvu01 AND rvu00 = '3' AND rvuconf = 'Y' AND rvu02 = u.rvu02 AND rvv02 = v.rvv02 ",
                 " AND (rvu03 BETWEEN '",tm.yy1,"' AND '",tm.yy2,"') ",
                 " AND rvvplant = '",l_plant,"'),",
                 " rvv39t-(SELECT CASE WHEN SUM(rvv39t) IS NULL THEN 0 ELSE SUM(rvv39t) END ",
                 " FROM ",cl_get_target_table(l_plant,'rvu_file'),
     	           "     ,",cl_get_target_table(l_plant,'ima_file'),
     	           "     ,",cl_get_target_table(l_plant,'rvv_file'),
                 " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'pmm_file')," ON pmm01 = rvv36 ", 
                 " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'rva_file')," ON rva01 = rvv04 ",
                 " WHERE rvv31 = ima01 AND rvv01 = rvu01 AND rvu00 = '3' AND rvuconf = 'Y' AND rvu02 = u.rvu02 AND rvv02 = v.rvv02 ",
                 " AND (rvu03 BETWEEN '",tm.yy1,"' AND '",tm.yy2,"') ",
                 " AND rvvplant = '",l_plant,"'),",
                 " pmm22,pmm42,rva113,rva114,rvvplant ",
                 " FROM ",cl_get_target_table(l_plant,'rvu_file')," u ",
                 "     ,",cl_get_target_table(l_plant,'ima_file'),
                 "     ,",cl_get_target_table(l_plant,'rvv_file')," v ",
                 " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'pmm_file')," ON pmm01 = rvv36 ",
                 " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'rva_file')," ON rva01 = rvv04 ",
                 " WHERE rvv31 = ima01 ",
                 " AND rvv01 = rvu01 ",
                 " AND rvu00 = '1'",
                 " AND rvuconf = 'Y'",
                 " AND (rvu03 BETWEEN '",tm.yy1,"' AND '",tm.yy2,"')",
                 " AND ",l_wc CLIPPED,
                 " AND rvvplant = '",l_plant,"'"
     #FUN-AA0024  ----------------------end------------------------------            
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql  #FUN-AA0024  mark
      PREPARE artr510_p1 FROM l_sql
      DECLARE artr510_p1_curs CURSOR FOR artr510_p1
      FOREACH artr510_p1_curs INTO sr1.* 
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF  
         IF NOT cl_null(sr1.pmm22) THEN 
            IF NOT cl_null(sr1.pmm42) THEN
              LET l_sql = "SELECT azi10 FROM ",cl_get_target_table(l_plant,'azi_file'),
                          " WHERE azi01 = '",sr1.pmm22,"'"
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
              CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
              PREPARE sel_azi10_pre FROM l_sql
              EXECUTE sel_azi10_pre INTO l_azi10
            ELSE
              LET sr1.pmm42 = 1
            END IF
            CASE l_azi10
               WHEN '1'
                 LET sr1.rvv39t = sr1.rvv39t * sr1.pmm42
               WHEN '2'
                 LET sr1.rvv39t = sr1.rvv39t/sr1.pmm42  
            END CASE            
         ELSE     
            IF NOT cl_null(sr1.rva113) THEN
               IF NOT cl_null(sr1.rva114) THEN
                  LET l_sql = "SELECT azi10 FROM ",cl_get_target_table(l_plant,'azi_file'),
                             " WHERE azi01 = '",sr1.rva113,"'"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
                  PREPARE sel_azi10_pre1 FROM l_sql
                  EXECUTE sel_azi10_pre1 INTO l_azi10 
               ELSE 
                  LET sr1.rva114 = 1
               END IF
            END IF 
            CASE l_azi10
               WHEN '1'
                  LET sr1.rvv39t = sr1.rvv39t * sr1.rva114
               WHEN '2'
                  LET sr1.rvv39t = sr1.rvv39t/sr1.rva114  
            END CASE              
         END IF  
         INSERT INTO artr510_tmp3 VALUES (sr1.rvv17,sr1.rvv39t,sr1.pmm22,sr1.pmm42,sr1.rva113,sr1.rva114,sr1.rvvplant)
      END FOREACH
      
      
      LET l_sql = " SELECT  SUM(rvv17),SUM(rvv39t) FROM artr510_tmp3 GROUP BY rvvplant "
      PREPARE sel_sum_pre FROM l_sql
      EXECUTE sel_sum_pre INTO l_rvv17,l_rvv39t 
      DELETE FROM  artr510_tmp3

      LET l_sql =  " SELECT oga02,oga23,oga24,ogb01,ogb03,ogb04,ogb12,ogb14t,ogb09,ogb092,ogb41,ogbplant,ima01,ima02,ima131,imd16 ", 
                   " FROM  ",cl_get_target_table(l_plant,'imd_file'),
                   "      ,",cl_get_target_table(l_plant,'ogb_file'),
                   "  LEFT OUTER JOIN ", cl_get_target_table(l_plant,'ima_file'),
                   "  ON ogb04 = ima01 ",
                   "      ,",cl_get_target_table(l_plant,'oga_file'),
                   " WHERE ogb09 = imd01 AND ogb01 = oga01 ",
                   " AND (oga02 BETWEEN '",tm.yy1,"' AND '",tm.yy2,"') ",
                   " AND ogaconf = 'Y'",
                   " AND ",tm.wc2 CLIPPED,
                   " AND ogbplant ='",l_plant,"'",
#                  " UNION ",    #TQC-B70204 mark
                   " UNION ALL ",    #TQC-B70204
                   " SELECT oha02,oha23,oha24,ohb01,ohb03,ohb04,(CASE WHEN ohb12 IS NULL THEN 0 ELSE ohb12 END)*(-1),(CASE WHEN ohb14t IS NULL THEN 0 ELSE ohb14t END)*(-1),ohb09,ohb092,'',ohbplant,ima01,ima02,ima131,imd16 ", 
                   " FROM  ",cl_get_target_table(l_plant,'imd_file'),
                   "      ,",cl_get_target_table(l_plant,'ohb_file'),
                   "  LEFT OUTER JOIN ", cl_get_target_table(l_plant,'ima_file'),
                   "  ON ohb04 = ima01 ",
                   "      ,",cl_get_target_table(l_plant,'oha_file'),
                   " WHERE ohb09 = imd01 AND ohb01 = oha01 ",
                   " AND (oha02 BETWEEN '",tm.yy1,"' AND '",tm.yy2,"') ",
                   " AND ohaconf = 'Y'",
                   " AND ",tm.wc2 CLIPPED,
                   " AND ohbplant ='",l_plant,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql  #FUN-AA0024 mark
     PREPARE artr510_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
           
     END IF
     DECLARE artr510_curs1 CURSOR FOR artr510_prepare1
     FOREACH artr510_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       IF NOT cl_null(sr.oga24) THEN
              LET l_sql = "SELECT azi10 FROM ",cl_get_target_table(l_plant,'azi_file'),
                          " WHERE azi01 = '",sr.oga23,"'"
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
              CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
              PREPARE sel_azi10_pre2 FROM l_sql
              EXECUTE sel_azi10_pre2 INTO l_azi10
        ELSE
              LET sr.oga24 = 1
        END IF
        CASE l_azi10
            WHEN '1'
                 LET sr.ogb14t = sr.ogb14t * sr.oga24
            WHEN '2'
                 LET sr.ogb14t = sr.ogb14t / sr.oga24  
        END CASE  
        
        
        
        CALL s_yp(sr.oga02) RETURNING l_yy,l_mm
        LET l_yy1 = l_yy
        LET l_mm1 = l_mm     
       
     LET l_db_type=cl_db_get_database_type()    #FUN-B40029
     CASE tm.type
          WHEN '1'  LET l_cost = ' '
                    #FUN-B40029-add-start--
                    IF l_db_type='MSV' THEN #SQLSERVER的版本
                    LET l_sql = "SELECT ccc23 FROM ",cl_get_target_table(l_plant,'ccc_file'),
                                " WHERE ccc01 = '",sr.ima01,"' ",
                                "   AND ccc07 = '",tm.type,"'",
                                "   AND ccc08 = '",l_cost,"'",
                                "   AND ccc02||substring(100+ccc03,2) in(",
                                "SELECT max(ccc02||substring(100+ccc03,2)) ",
                                "  FROM ",cl_get_target_table(l_plant,'ccc_file') ,
                                " WHERE ccc02||substring(100+ccc03,2) < = '",l_yy1,"'||substring(100+'",l_mm1,"',2)",
                                "   AND ccc01 = '",sr.ima01,"'",
                                "   AND ccc07 = '",tm.type,"'",
                                "   AND ccc08 = '",l_cost,"')"
                    ELSE
                    #FUN-B40029-add-end--
                    LET l_sql = "SELECT ccc23 FROM ",cl_get_target_table(l_plant,'ccc_file'),
                                " WHERE ccc01 = '",sr.ima01,"' ",
                                "   AND ccc07 = '",tm.type,"'",
                                "   AND ccc08 = '",l_cost,"'",
                                "   AND ccc02||substr(100+ccc03,2) in(",
                                "SELECT max(ccc02||substr(100+ccc03,2)) ", 
                                "  FROM ",cl_get_target_table(l_plant,'ccc_file') ,
                                " WHERE ccc02||substr(100+ccc03,2) < = '",l_yy1,"'||substr(100+'",l_mm1,"',2)",
                                "   AND ccc01 = '",sr.ima01,"'",
                                "   AND ccc07 = '",tm.type,"'",
                                "   AND ccc08 = '",l_cost,"')"
                    END IF   #FUN-B40029
                    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                    CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
                    PREPARE pre1 FROM l_sql
                    EXECUTE pre1 INTO l_ccc23 
                   #IF cl_null(l_ccc23) THEN LET l_ccc23 = 0 END IF  #TQC-BC0018 mark
                    IF cl_null(l_ccc23) OR STATUS = 100 THEN LET l_ccc23 = 0 END IF    #TQC-BC0018 add 
                    LET l_sales= sr.ogb14t                                
                    LET l_maori= sr.ogb14t - sr.ogb12*l_ccc23             
                    #IF l_maori<0 THEN 
                    #    LET l_maori=0
                    #END IF

          WHEN '2'  
                  LET l_sql = " SELECT cxc09 FROM  ",cl_get_target_table(l_plant,'cxc_file'),
                              " WHERE cxc01 = '",sr.ima01,"'",
                              " AND  cxc04 = '",sr.ogb01,"'",
                              " AND  cxc05 = '",sr.ogb03,"'"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
                  PREPARE pre2 FROM l_sql
                  EXECUTE pre2 INTO l_host
                  IF cl_null(l_host) THEN LET l_host = 0 END IF 
                  LET l_sales= sr.ogb14t                                
                  LET l_maori= sr.ogb14t - l_host                       
                  #IF l_maori<0 THEN
                  #     LET l_maori=0
                  #END IF
         
          WHEN '3'  LET l_cost = sr.ogb092
                    #FUN-B40029-add-start--
                    IF l_db_type='MSV' THEN #SQLSERVER的版本
                    LET l_sql = "SELECT ccc23 FROM ",cl_get_target_table(l_plant,'ccc_file'),
                                " WHERE ccc01 = '",sr.ima01,"' ",
                                "   AND ccc07 = '",tm.type,"'",
                                "   AND ccc08 = '",l_cost,"'",
                                "   AND ccc02||substring(100+ccc03,2) in(",
                                "SELECT max(ccc02||substring(100+ccc03,2)) ",
                                "  FROM ",cl_get_target_table(l_plant,'ccc_file') ,
                                " WHERE ccc02||substring(100+ccc03,2) < = '",l_yy1,"'||substring(100+'",l_mm1,"',2)",
                                "   AND ccc01 = '",sr.ima01,"'",
                                "   AND ccc07 = '",tm.type,"'",
                                "   AND ccc08 = '",l_cost,"')"
                    ELSE
                    #FUN-B40029-add-end--
                    LET l_sql = "SELECT ccc23 FROM ",cl_get_target_table(l_plant,'ccc_file'),
                                " WHERE ccc01 = '",sr.ima01,"' ",
                                "   AND ccc07 = '",tm.type,"'",
                                "   AND ccc08 = '",l_cost,"'",
                                "   AND ccc02||substr(100+ccc03,2) in(",
                                "SELECT max(ccc02||substr(100+ccc03,2)) ", 
                                "  FROM ",cl_get_target_table(l_plant,'ccc_file') ,
                                " WHERE ccc02||substr(100+ccc03,2) < = '",l_yy1,"'||substr(100+'",l_mm1,"',2)",
                                "   AND ccc01 = '",sr.ima01,"'",
                                "   AND ccc07 = '",tm.type,"'",
                                "   AND ccc08 = '",l_cost,"')"
                    END IF   #FUN-B40029
                    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                    CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
                    PREPARE pre3 FROM l_sql
                    EXECUTE pre3 INTO l_ccc23           
                   #IF cl_null(l_ccc23) THEN LET l_ccc23 = 0 END IF   #TQC-BC0018 mark
                    IF cl_null(l_ccc23) OR STATUS = 100 THEN LET l_ccc23 = 0 END IF    #TQC-BC0018 add              
                    LET l_sales= sr.ogb14t                                
                    LET l_maori= sr.ogb14t - sr.ogb12*l_ccc23             
                    #IF l_maori<0 THEN
                    #    LET l_maori=0
                    #END IF
                    
          WHEN '4'  LET l_cost = sr.ogb41
                    #FUN-B40029-add-start--
                    IF l_db_type='MSV' THEN #SQLSERVER的版本
                    LET l_sql = "SELECT ccc23 FROM ",cl_get_target_table(l_plant,'ccc_file'),
                                " WHERE ccc01 = '",sr.ima01,"' ",
                                "   AND ccc07 = '",tm.type,"'",
                                "   AND ccc08 = '",l_cost,"'",
                                "   AND ccc02||substring(100+ccc03,2,) in(",
                                "SELECT max(ccc02||substring(100+ccc03,2)) ",
                                "  FROM ",cl_get_target_table(l_plant,'ccc_file') ,
                                " WHERE ccc02||substring(100+ccc03,2) < = '",l_yy1,"'||substring(100+'",l_mm1,"',2)",
                                "   AND ccc01 = '",sr.ima01,"'",
                                "   AND ccc07 = '",tm.type,"'",
                                "   AND ccc08 = '",l_cost,"')"
                    ELSE   
                    #FUN-B40029-add-end--
                    LET l_sql = "SELECT ccc23 FROM ",cl_get_target_table(l_plant,'ccc_file'),
                                " WHERE ccc01 = '",sr.ima01,"' ",
                                "   AND ccc07 = '",tm.type,"'",
                                "   AND ccc08 = '",l_cost,"'",
                                "   AND ccc02||substr(100+ccc03,2) in(",
                                "SELECT max(ccc02||substr(100+ccc03,2)) ", 
                                "  FROM ",cl_get_target_table(l_plant,'ccc_file') ,
                                " WHERE ccc02||substr(100+ccc03,2) < = '",l_yy1,"'||substr(100+'",l_mm1,"',2)",
                                "   AND ccc01 = '",sr.ima01,"'",
                                "   AND ccc07 = '",tm.type,"'",
                                "   AND ccc08 = '",l_cost,"')"
                    END IF   #FUN-B40029
                    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                    CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
                    PREPARE pre4 FROM l_sql
                    EXECUTE pre4 INTO l_ccc23                  
                   #IF cl_null(l_ccc23) THEN LET l_ccc23 = 0 END IF  #TQC-BC0018 mark
                    IF cl_null(l_ccc23) OR STATUS = 100 THEN LET l_ccc23 = 0 END IF    #TQC-BC0018 add 
                    LET l_sales= sr.ogb14t                                
                    LET l_maori= sr.ogb14t - sr.ogb12*l_ccc23             
                    #IF l_maori<0 THEN
                    #    LET l_maori=0
                    #END IF
                    
          WHEN '5'  LET l_cost = sr.imd16
                    #FUN-B40029-add-start--
                    IF l_db_type='MSV' THEN #SQLSERVER的版本
                    LET l_sql = "SELECT ccc23 FROM ",cl_get_target_table(l_plant,'ccc_file'),
                                " WHERE ccc01 = '",sr.ima01,"' ",
                                "   AND ccc07 = '",tm.type,"'",
                                "   AND ccc08 = '",l_cost,"'",
                                "   AND ccc02||substring(100+ccc03,2) in(",
                                "SELECT max(ccc02||substring(100+ccc03,2)) ",
                                "  FROM ",cl_get_target_table(l_plant,'ccc_file') ,
                                " WHERE ccc02||substring(100+ccc03,2) < = '",l_yy1,"'||substring(100+'",l_mm1,"',2)",
                                "   AND ccc01 = '",sr.ima01,"'",
                                "   AND ccc07 = '",tm.type,"'",
                                "   AND ccc08 = '",l_cost,"')"
                    ELSE        
                    #FUN-B40029-add-end--
                    LET l_sql = "SELECT ccc23 FROM ",cl_get_target_table(l_plant,'ccc_file'),
                                " WHERE ccc01 = '",sr.ima01,"' ",
                                "   AND ccc07 = '",tm.type,"'",
                                "   AND ccc08 = '",l_cost,"'",
                                "   AND ccc02||substr(100+ccc03,2) in(",
                                "SELECT max(ccc02||substr(100+ccc03,2)) ", 
                                "  FROM ",cl_get_target_table(l_plant,'ccc_file') ,
                                " WHERE ccc02||substr(100+ccc03,2) < = '",l_yy1,"'||substr(100+'",l_mm1,"',2)",
                                "   AND ccc01 = '",sr.ima01,"'",
                                "   AND ccc07 = '",tm.type,"'",
                                "   AND ccc08 = '",l_cost,"')"
                    END IF   #FUN-B40029
                    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                    CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
                    PREPARE pre5 FROM l_sql
                    EXECUTE pre5 INTO l_ccc23                    
                   #IF cl_null(l_ccc23) THEN LET l_ccc23 = 0 END IF  #TQC-BC0018 mark
                    IF cl_null(l_ccc23) OR STATUS = 100 THEN LET l_ccc23 = 0 END IF    #TQC-BC0018 add
                    LET l_sales= sr.ogb14t                                
                    LET l_maori= sr.ogb14t - sr.ogb12*l_ccc23             
                    #IF l_maori<0 THEN
                    #    LET l_maori=0
                    #END IF
     END CASE
             
       LET l_sql =" SELECT oba02 FROM ",cl_get_target_table(l_plant,'oba_file'),
                  " WHERE oba01= '",sr.ima131,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_oba02_pre FROM l_sql
         EXECUTE sel_oba02_pre INTO l_oba02 

        INSERT INTO artr510_tmp2 VALUES( sr.ogbplant, l_azp02,sr.ima131,l_oba02,sr.ima02,
                                        l_rvv17,l_rvv39t,sr.ogb04,sr.ogb12,l_sales,l_maori)
                 
       END FOREACH 
      END FOREACH


       DECLARE r510_curs3 CURSOR FOR 
        SELECT rvvplant,azp02,rvv17,income,SUM(ogb12),SUM(sales),SUM(maori) 
        FROM artr510_tmp2 GROUP BY rvvplant,azp02,rvv17,income

        
     FOREACH r510_curs3 INTO l_rvvplant,l_azp02,l_rvv17,l_income,l_ogb12,l_sales,l_maori
     IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
     END IF
      LET l_gross = l_maori*100/l_sales
      #FUN-AA0024 add --------begin--------
         IF l_gross < 0 THEN 
            LET l_gross = 0 
         END IF  
         IF cl_null(l_rvv17) THEN 
            LET l_rvv17 = 0
         END IF
         IF cl_null(l_income) THEN 
            LET l_income = 0
         END IF     
      #FUN-AA0024 add --------end--------
      EXECUTE insert_prep USING l_rvvplant,l_azp02,l_rvv17,l_income,l_ogb12,l_sales,l_maori,l_gross
      
     END FOREACH 
     
              
     
     LET g_str = ''  
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc2,'ima131,ogb04')
             RETURNING tm.wc2
        LET g_str = tm.wc2
     END IF
     IF cl_null(tm.s[1,1]) THEN LET tm.s[1,1] = '0' END IF                
     IF cl_null(tm.s[2,2]) THEN LET tm.s[2,2] = '0' END IF 
     LET g_str = g_str,";",tm.yy1,";",tm.yy2,';',tm.lim1,";",tm.lim2,";",
                 tm.type,";",tm.s[1,1],";",tm.s[2,2]                   
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
     CALL cl_prt_cs3('artr510','artr510',l_sql,g_str)

      
 END FUNCTION     

















   
                
        
