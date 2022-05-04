# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: artg330.4gl
# Descriptions...: 营运中心补货汇总表
# Date & Author..: FUN-A60077 10/07/04 By shenyang
# Modify.........: No.FUN-B80085 11/08/09 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: NO.FUN-BA0061 11/10/17 By qirl 明細CR報表轉GR
# Modify.........: NO.FUN-BA0061 12/01/06 By yangtt #TQC-BB0036單
# Modify.........: NO.FUN-CB0058 12/11/20 By yangtt 4rp中的visibility condition在4gl中實現，達到單身無定位點

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE tm  RECORD                # Print condition RECORD
              wc      STRING, 
              wc1      STRING,    
              a       LIKE type_file.chr1,
              b       LIKE type_file.chr1,
              w       LIKE type_file.chr1,      #NO.FUN-BA0061  add
              x       LIKE type_file.chr1,      #NO.FUN-BA0061  add
              more    LIKE type_file.chr1       # Input more condition(Y/N)
              END RECORD 
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose        
DEFINE   g_head1         STRING
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING 
DEFINE   g_chk_azp01     LIKE type_file.chr1
DEFINE   g_chk_auth      STRING  
DEFINE   g_azp01         LIKE azp_file.azp01 
DEFINE   g_azp01_str     STRING

###GENGRE###START
TYPE sr1_t RECORD
    azw01 LIKE azw_file.azw01,
    azp02 LIKE azp_file.azp02,
    ruc04 LIKE ruc_file.ruc04,
    ima02 LIKE ima_file.ima02,
    ruc13 LIKE ruc_file.ruc13,    #NO.FUN-BA0061  add
    ruc07 LIKE ruc_file.ruc07,
    ruc18 LIKE ruc_file.ruc18,
    ruc19 LIKE ruc_file.ruc19,
    ruc20 LIKE ruc_file.ruc20,
    ruc21 LIKE ruc_file.ruc21,
    ruc27 LIKE ruc_file.ruc27     #NO.FUN-BA0061  add
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF

   LET g_sql =  "azw01.azw_file.azw01,",
                "azp02.azp_file.azp02,",
                "ruc04.ruc_file.ruc04,",
                "ima02.ima_file.ima02,",
                "ruc13.ruc_file.ruc13,",  #NO.FUN-BA0061
                "ruc07.ruc_file.ruc07,",
                "ruc18.ruc_file.ruc18,",
                "ruc19.ruc_file.ruc19,",
                "ruc20.ruc_file.ruc20,",
                "ruc21.ruc_file.ruc21,",
                "ruc27.ruc_file.ruc27"    #NO.FUN-BA0061

   LET l_table = cl_prt_temptable('artg330',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a = ARG_VAL(8)
   LET tm.b = ARG_VAL(9)
   LET tm.w = ARG_VAL(10)  #NO.FUN-BA0061
   LET tm.x = ARG_VAL(11)  #NO.FUN-BA0061
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15) 

   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL artg330_tm(0,0)        # Input print condition
      ELSE CALL artg330()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   CALL cl_gre_drop_temptable(l_table)  #FUN-BA0061
END MAIN 
FUNCTION artg330_tm(p_row,p_col)
   DEFINE l_num          LIKE type_file.num10
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
   DEFINE tok            base.StringTokenizer 
   DEFINE l_zxy03        LIKE zxy_file.zxy03        
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW artg330_w AT p_row,p_col WITH FORM "art/42f/artg330" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'
   LET tm.a = '1' 
   LET tm.b = 'Y' 
   LET tm.w = 'Y'      #NO.FUN-BA0061 add
   LET tm.x = 'Y'      #NO.FUN-BA0061 add
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
               DECLARE g330_zxy_cs1 CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
               FOREACH g330_zxy_cs1 INTO l_zxy03 
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
         LET INT_FLAG = 0 CLOSE WINDOW artg330_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)  #FUN-BA0061
         EXIT PROGRAM
      END IF

      LET l_num = tm.wc1.getIndexOf('azp01',1)
      IF l_num = 0 THEN
         CALL cl_err('','art-926',0) CONTINUE WHILE
      END IF
      CONSTRUCT BY NAME tm.wc ON ima131,ruc04,ruc07,ruc27
                                  
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT                                   
         ON ACTION controlp
            CASE
               
               WHEN INFIELD(ima131)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima131"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima131
                  NEXT FIELD ima131
               WHEN INFIELD(ruc04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ruc04"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruc04
                  NEXT FIELD ruc04
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
         LET INT_FLAG = 0 CLOSE WINDOW artg330_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)  #FUN-BA0061
         EXIT PROGRAM
      END IF

     #DISPLAY BY NAME tm.a,tm.b,tm.more
      DISPLAY BY NAME tm.a,tm.b,tm.w,tm.x,tm.more   #NO.FUN-BA0061 add tm.w,tm.x 
      
     #INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS
      INPUT BY NAME tm.a,tm.b,tm.w,tm.x,tm.more WITHOUT DEFAULTS  #NO.FUN-BA0061 add tm.w,tm.x

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)  
    AFTER FIELD b
         IF tm.b    NOT MATCHES "[YN]"  OR tm.b IS NULL THEN
                NEXT FIELD b
         END IF
        AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
            END IF
            
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
            
         ON ACTION CONTROLG 
            CALL cl_cmdask()    # Command execution
            
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
         LET INT_FLAG = 0 CLOSE WINDOW artg330_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)  #FUN-BA0061
         EXIT PROGRAM
      END IF      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='artg330'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('artg330','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.wc CLIPPED,"'" ,
                       " '",tm.a CLIPPED,"'" ,
                       " '",tm.b CLIPPED,"'" ,
                       " '",tm.w CLIPPED,"'" ,      #NO.FUN-BA0061 add
                       " '",tm.x CLIPPED,"'" ,      #NO.FUN-BA0061 add
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('artg330',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artg330_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)  #FUN-BA0061
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artg330()
      ERROR ""
   END WHILE
   CLOSE WINDOW artg330_w
END FUNCTION 

FUNCTION artg330()
   DEFINE l_plant   LIKE  azp_file.azp01
   DEFINE l_azp02   LIKE  azp_file.azp02
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 
          l_chr     LIKE type_file.chr1,       
          l_za05    LIKE type_file.chr1000,          
          sr        RECORD 
                    azw01    LIKE azw_file.azw01,
                    azp02    LIKE azp_file.azp02,
                    ruc04    LIKE ruc_file.ruc04,
                    ima02    LIKE ima_file.ima02,
                    ruc13    LIKE ruc_file.ruc13,   #NO.FUN-BA0061
                    ruc07    LIKE ruc_file.ruc07,
                    ruc18    LIKE ruc_file.ruc18,
                    ruc19    LIKE ruc_file.ruc19,
                    ruc20    LIKE ruc_file.ruc20,
                    ruc21    LIKE ruc_file.ruc21,
                    ruc27    LIKE ruc_file.ruc27    #NO.FUN-BA0061
                    END RECORD
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')

    CALL cl_del_data(l_table)
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?) "                   #NO.FUN-BA0061 add ?,?                                                                                        
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1)                                   
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-BA0061--add--                                                     
       CALL cl_gre_drop_temptable(l_table)  #FUN-BA0061
       EXIT PROGRAM                                                                                                                 
    END IF
    LET l_sql = "SELECT DISTINCT azp01,azp02 FROM azp_file,azw_file ",
                " WHERE azw01 = azp01  ",
                " AND azp01 IN ",g_chk_auth ,
               " ORDER BY azp01 "

   PREPARE sel_azp01_pre FROM l_sql
   DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre
   FOREACH sel_azp01_cs INTO l_plant,l_azp02  
       IF STATUS THEN
         CALL cl_err('PLANT:',SQLCA.sqlcode,1)
         RETURN
      END IF
CASE
   when tm.b = 'Y'
       CASE
       WHEN tm.a='1'
         LET l_sql =  " SELECT azw01,'','','','','', ",   #FUN-A60077
                #"ruc18,ruc19,ruc20,ruc21",
                "ruc18,ruc19,ruc20,ruc21,ruc27",   #NO.FUN-BA0061
                "  FROM ",cl_get_target_table(l_plant,'ruc_file'),
                ",",cl_get_target_table(l_plant,'azw_file'),
                ",",cl_get_target_table(l_plant,'ima_file'),
                " WHERE ruc01=azw01 ",
                " AND azw01 ='",l_plant,"'", 
                " AND ruc04=ima01 AND ",tm.wc CLIPPED
       WHEN tm.a='2'
          #LET l_sql =  " SELECT azw01,'',ruc04,ima02,ruc07,",
          LET l_sql =  " SELECT azw01,'',ruc04,ima02,ruc13,'',",  #NO.FUN-BA0061
               #"ruc18,ruc19,ruc20,ruc21",
                "ruc18,ruc19,ruc20,ruc21,ruc27",   #NO.FUN-BA0061
                "  FROM ",cl_get_target_table(l_plant,'ruc_file'),
                ",",cl_get_target_table(l_plant,'azw_file'),
                ",",cl_get_target_table(l_plant,'ima_file'),
                " WHERE ruc01=azw01 ",
                 " AND azw01 ='",l_plant,"'", 
                " AND ruc04=ima01 AND ",tm.wc CLIPPED
       WHEN tm.a='3'
          LET l_sql =  " SELECT azw01,'','','','',ruc07,",
                #"ruc18,ruc19,ruc20,ruc21",
                "ruc18,ruc19,ruc20,ruc21,ruc27",   #NO.FUN-BA0061
                "  FROM ",cl_get_target_table(l_plant,'ruc_file'),
                ",",cl_get_target_table(l_plant,'azw_file'),
                ",",cl_get_target_table(l_plant,'ima_file'),
                " WHERE ruc01=azw01 ",
                 " AND azw01 ='",l_plant,"'", 
                " AND ruc04=ima01 AND ",tm.wc CLIPPED
       #NO.FUN-BA0061 add begin------------------------------------------
       WHEN tm.a='4'
          LET l_sql =  " SELECT azw01,'',ruc04,ima02,ruc13,ruc07,",
                "ruc18,ruc19,ruc20,ruc21,ruc27",
                "  FROM ",cl_get_target_table(l_plant,'ruc_file'),
                ",",cl_get_target_table(l_plant,'azw_file'),
                ",",cl_get_target_table(l_plant,'ima_file'),
                " WHERE ruc01=azw01 ",
                 " AND azw01 ='",l_plant,"'",
                " AND ruc04=ima01 AND ",tm.wc CLIPPED
       #NO.FUN-BA0061 add end--------------------------------------------
    END CASE
   
   when  tm.b = 'N' 
        CASE
       WHEN tm.a='1'
          #LET l_sql =  " SELECT azw01,'','','','',",
          LET l_sql =  " SELECT azw01,'','','','','',", #NO.FUN-BA0061
               #"SUM(ruc18),SUM(ruc19),SUM(ruc20),SUM(ruc21)",
                "SUM(ruc18),SUM(ruc19),SUM(ruc20),SUM(ruc21),''",  #NO.FUN-BA0061
                "  FROM ",cl_get_target_table(l_plant,'ruc_file'),
                ",",cl_get_target_table(l_plant,'azw_file'),
                ",",cl_get_target_table(l_plant,'ima_file'),
                " WHERE ruc01=azw01 ",
                 " AND azw01 ='",l_plant,"'", 
                " AND ruc04=ima01 AND ",tm.wc CLIPPED,
                " GROUP BY azw01 "  
       WHEN tm.a='2'
          #LET l_sql =  " SELECT azw01,'',ruc04,ima02,ruc07,",
          LET l_sql =  " SELECT azw01,'',ruc04,ima02,ruc13,'',",  #NO.FUN-BA0061
               #"SUM(ruc18),SUM(ruc19),SUM(ruc20),SUM(ruc21)",
                "SUM(ruc18),SUM(ruc19),SUM(ruc20),SUM(ruc21),''",  #NO.FUN-BA0061
               "  FROM ",cl_get_target_table(l_plant,'ruc_file'),
                ",",cl_get_target_table(l_plant,'azw_file'),
                ",",cl_get_target_table(l_plant,'ima_file'),
                " WHERE ruc01=azw01 ",
                 " AND azw01 ='",l_plant,"'", 
                " AND ruc04=ima01 AND ",tm.wc CLIPPED,
                #" GROUP BY azw01,ruc04,ima02 "
                " GROUP BY azw01,ruc04,ima02,ruc13"   #NO.FUN-BA0061
       WHEN tm.a='3'
          #LET l_sql =  " SELECT azw01,'','','',ruc07,",
          LET l_sql =  " SELECT azw01,'','','','',ruc07,",  #NO.FUN-BA0061
               #"SUM(ruc18),SUM(ruc19),SUM(ruc20),SUM(ruc21)",
                "SUM(ruc18),SUM(ruc19),SUM(ruc20),SUM(ruc21),''",  #NO.FUN-BA0061
                "  FROM ",cl_get_target_table(l_plant,'ruc_file'),
                ",",cl_get_target_table(l_plant,'azw_file'),
                ",",cl_get_target_table(l_plant,'ima_file'),
                " WHERE ruc01=azw01 ",
                 " AND azw01 ='",l_plant,"'", 
                " AND ruc04=ima01 AND ",tm.wc CLIPPED,
                " GROUP BY azw01,ruc07"  
       #NO.FUN-BA0061 add begin------------------------------------------
       WHEN tm.a='4'
          LET l_sql =  " SELECT azw01,'',ruc04,ima02,ruc13,ruc07,",
                "SUM(ruc18),SUM(ruc19),SUM(ruc20),SUM(ruc21),''",
                "  FROM ",cl_get_target_table(l_plant,'ruc_file'),
                ",",cl_get_target_table(l_plant,'azw_file'),
                ",",cl_get_target_table(l_plant,'ima_file'),
                " WHERE ruc01=azw01 ",
                 " AND azw01 ='",l_plant,"'",
                " AND ruc04=ima01 AND ",tm.wc CLIPPED,
                " GROUP BY azw01,ruc04,ima02,ruc07,ruc13"
       #NO.FUN-BA0061 add end--------------------------------------------
    END CASE   
 CALL cl_replace_sqldb(l_sql) RETURNING l_sql          
       CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql     
 END CASE               
    PREPARE artg330_prepare1 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       CALL cl_gre_drop_temptable(l_table)  #FUN-BA0061
       EXIT PROGRAM
    END IF
    DECLARE artg330_curs1 CURSOR FOR artg330_prepare1

      FOREACH artg330_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF            
      EXECUTE  insert_prep  USING  
      #sr.azw01,l_azp02,sr.ruc04,sr.ima02,
      sr.azw01,l_azp02,sr.ruc04,sr.ima02,sr.ruc13, #NO.FUN-BA0061
      sr.ruc07,sr.ruc18,sr.ruc19,sr.ruc20,sr.ruc21,sr.ruc27   #FUN-BA0061  add sr.ruc27  
   END FOREACH   
   END FOREACH
###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###   LET g_str = tm.wc1,";",tm.wc,";",tm.w,";",tm.b,";",tm.x   #NO.FUN-BA0061 add tm.w,tm.b,tm.x
   CASE
      WHEN tm.a='1'
###GENGRE###         CALL cl_prt_cs3('artg330','artg330',l_sql,g_str)  
         LET g_template = 'artg330'
         CALL artg330_1_grdata()    ###GENGRE###
      WHEN tm.a='2'
###GENGRE###         CALL cl_prt_cs3('artg330','artg330_1',l_sql,g_str) 
          LET g_template = 'artg330_1'
          CALL artg330_2_grdata()    ###GENGRE###
       WHEN tm.a='3'
###GENGRE###         CALL cl_prt_cs3('artg330','artg330_2',l_sql,g_str) 
          LET g_template = 'artg330_2'
          CALL artg330_3_grdata()    ###GENGRE###
       WHEN tm.a='4'    #NO.FUN-BA0061
#         CALL cl_prt_cs3('artr330','artr330_4',l_sql,g_str)    #NO.FUN-BA0061
          LET g_template = 'artg330_3'       #NO.FUN-BA0061
          CALL artg330_4_grdata()       #NO.FUN-BA0061 add
   END CASE
END FUNCTION



      

###GENGRE###START
FUNCTION artg330_1_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("artg330")
        IF handler IS NOT NULL THEN
            START REPORT artg330_1_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        "  ORDER BY azw01,ruc27"
          
            DECLARE artg330_datacur1 CURSOR FROM l_sql
            FOREACH artg330_datacur1 INTO sr1.*
                OUTPUT TO REPORT artg330_1_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg330_1_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg330_1_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
#FUN-BA0061----------STAR---------
    DEFINE l_display  STRING
    DEFINE l_display1 STRING
    DEFINE l_display2 STRING
    DEFINE l_display3 STRING
    DEFINE sr1_o sr1_t
    DEFINE l_ruc18_sum   LIKE ruc_file.ruc18
    DEFINE l_ruc19_sum   LIKE ruc_file.ruc19
    DEFINE l_ruc20_sum   LIKE ruc_file.ruc20
    DEFINE l_ruc21_sum   LIKE ruc_file.ruc21
    DEFINE l_ruc18_sum1  LIKE ruc_file.ruc18
    DEFINE l_ruc19_sum1  LIKE ruc_file.ruc19
    DEFINE l_ruc20_sum1  LIKE ruc_file.ruc20
    DEFINE l_ruc21_sum1  LIKE ruc_file.ruc21
#FUN-BA0061--------END--------
    DEFINE l_azw01      LIKE azw_file.azw01     #FUN-CB0058
    DEFINE l_azp02      LIKE azp_file.azp02     #FUN-CB0058
    DEFINE l_ruc04      LIKE ruc_file.ruc04     #FUN-CB0058
    DEFINE l_ima02      LIKE ima_file.ima02     #FUN-CB0058
    DEFINE l_ruc27      LIKE ruc_file.ruc27     #FUN-CB0058

    ORDER EXTERNAL BY sr1.azw01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name #FUN-BA0061 add g_ptime,g_user_name
            PRINTX tm.*
            LET sr1_o.azw01 = NULL #FUN-BA0061           
            LET sr1_o.azp02 = NULL #FUN-BA0061           
            LET sr1_o.ruc04 = NULL #FUN-BA0061           
            LET sr1_o.ima02 = NULL #FUN-BA0061           

   
        BEFORE GROUP OF sr1.azw01

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
#FUN-BA0061	---add----str--------
            IF NOT cl_null(sr1_o.azw01) THEN
               IF sr1_o.azw01 != sr1.azw01 OR tm.w !='N' THEN
            #     LET l_display = 'Y'
                  LET l_azw01 = sr1.azw01    #FUN-CB0058
               ELSE
            #     LET l_display = 'N'
                  LET l_azw01 = "  "         #FUN-CB0058
               END IF
            ELSE
            #  LET l_display = 'Y'
               LET l_azw01 = sr1.azw01    #FUN-CB0058
            END IF
            PRINTX l_display
            IF NOT cl_null(sr1_o.azp02) THEN
               IF sr1_o.azp02 != sr1.azp02  OR tm.w !='N' THEN
            #     LET l_display3 = 'Y'
                  LET l_azp02 = sr1.azp02    #FUN-CB0058
               ELSE
            #     LET l_display3 = 'N'
                  LET l_azp02 = "  "         #FUN-CB0058
               END IF
            ELSE
            #  LET l_display3 = 'Y'
               LET l_azp02 = sr1.azp02    #FUN-CB0058
            END IF
            PRINTX l_display3
            IF NOT cl_null(sr1_o.ruc04) THEN
               IF sr1_o.ruc04 != sr1.ruc04  OR tm.w !='N' THEN
            #     LET l_display1 = 'Y'
                  LET l_ruc04 = sr1.ruc04    #FUN-CB0058
               ELSE
            #     LET l_display1 = 'N'
                  LET l_ruc04 = "  "         #FUN-CB0058
               END IF
            ELSE  
            #  LET l_display1 = 'Y'
               LET l_ruc04 = sr1.ruc04    #FUN-CB0058
            END IF
            PRINTX l_display1

            IF NOT cl_null(sr1_o.ima02) THEN
               IF sr1_o.ima02 = sr1.ima02  OR tm.w !='N' THEN
            #     LET l_display2 = 'N'
                  LET l_ima02 = sr1.ima02    #FUN-CB0058
               ELSE
            #     LET l_display2 = 'Y'
                  LET l_ima02 = "   "        #FUN-CB0058
               END IF
            ELSE
            #  LET l_display2 = 'Y'
               LET l_ima02 = sr1.ima02    #FUN-CB0058
            END IF

            IF tm.b != 'N' THEN         #FUN-CB0058 add
               LET l_ruc27 = sr1.ruc27  #FUN-CB0058 add
            ELSE                        #FUN-CB0058 add
               LET l_ruc27 = "  "       #FUN-CB0058 add 
            END IF                      #FUN-CB0058 add

            PRINTX l_display2
            PRINTX l_azw01  #FUN-CB0058
            PRINTX l_azp02  #FUN-CB0058
            PRINTX l_ruc04  #FUN-CB0058
            PRINTX l_ima02  #FUN-CB0058
            PRINTX l_ruc27  #FUN-CB0058
            LET sr1_o.* = sr1.*
#FUN-BA0061-------END-----------
            PRINTX sr1.*

        AFTER GROUP OF sr1.azw01
            LET l_ruc18_sum1 = GROUP SUM(sr1.ruc18)
            LET l_ruc19_sum1 = GROUP SUM(sr1.ruc19)
            LET l_ruc20_sum1 = GROUP SUM(sr1.ruc20)
            LET l_ruc21_sum1 = GROUP SUM(sr1.ruc21)
            PRINTX l_ruc18_sum1
            PRINTX l_ruc19_sum1
            PRINTX l_ruc20_sum1
            PRINTX l_ruc21_sum1

        
        ON LAST ROW
            LET l_ruc18_sum = SUM(sr1.ruc18)
            LET l_ruc19_sum = SUM(sr1.ruc19)
            LET l_ruc20_sum = SUM(sr1.ruc20)
            LET l_ruc21_sum = SUM(sr1.ruc21)
            PRINTX l_ruc18_sum
            PRINTX l_ruc19_sum
            PRINTX l_ruc20_sum
            PRINTX l_ruc21_sum

END REPORT

#NO.FUN-BA0061----------STAR---------
FUNCTION artg330_2_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("artg330")
        IF handler IS NOT NULL THEN
            START REPORT artg330_2_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY azw01,ruc04,ruc27"

            DECLARE artg330_datacur2 CURSOR FROM l_sql
            FOREACH artg330_datacur2 INTO sr1.*
                OUTPUT TO REPORT artg330_2_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg330_2_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg330_2_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_display  STRING
    DEFINE l_display1 STRING
    DEFINE l_display2 STRING
    DEFINE l_display3 STRING
    DEFINE sr1_o sr1_t
    DEFINE l_ruc18_sum   LIKE ruc_file.ruc18
    DEFINE l_ruc19_sum   LIKE ruc_file.ruc19
    DEFINE l_ruc20_sum   LIKE ruc_file.ruc20
    DEFINE l_ruc21_sum   LIKE ruc_file.ruc21
    DEFINE l_ruc18_sum1  LIKE ruc_file.ruc18
    DEFINE l_ruc19_sum1  LIKE ruc_file.ruc19
    DEFINE l_ruc20_sum1  LIKE ruc_file.ruc20
    DEFINE l_ruc21_sum1  LIKE ruc_file.ruc21
    DEFINE l_ruc18_sum2  LIKE ruc_file.ruc18
    DEFINE l_ruc19_sum2  LIKE ruc_file.ruc19
    DEFINE l_ruc20_sum2  LIKE ruc_file.ruc20
    DEFINE l_ruc21_sum2  LIKE ruc_file.ruc21
    DEFINE l_ruc07       STRING
    DEFINE l_azw01      LIKE azw_file.azw01     #FUN-CB0058
    DEFINE l_azp02      LIKE azp_file.azp02     #FUN-CB0058
    DEFINE l_ruc04      LIKE ruc_file.ruc04     #FUN-CB0058
    DEFINE l_ima02      LIKE ima_file.ima02     #FUN-CB0058
    DEFINE l_ruc27      LIKE ruc_file.ruc27     #FUN-CB0058

    ORDER EXTERNAL BY sr1.azw01,sr1.ruc04

    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name #FUN-BA0061 add g_ptime,g_user_name
            PRINTX tm.*
            LET sr1_o.azw01 = NULL
            LET sr1_o.azp02 = NULL
            LET sr1_o.ruc04 = NULL
            LET sr1_o.ima02 = NULL 


        BEFORE GROUP OF sr1.azw01
        BEFORE GROUP OF sr1.ruc04


        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_ruc07 = sr1.ruc07,':',cl_gr_getmsg("gre-252",g_lang,sr1.ruc07)
            PRINTX l_ruc07
            IF NOT cl_null(sr1_o.azw01) THEN
               IF sr1_o.azw01 != sr1.azw01  OR tm.w !='N' THEN
            #     LET l_display = 'Y'
                  LET l_azw01 = sr1.azw01    #FUN-CB0058
               ELSE
            #     LET l_display = 'N'
                  LET l_azw01 = "   "        #FUN-CB0058
               END IF
            ELSE
            #  LET l_display = 'Y'
               LET l_azw01 = sr1.azw01    #FUN-CB0058
            END IF
            PRINTX l_display
            IF NOT cl_null(sr1_o.azp02) THEN
               IF sr1_o.azp02 != sr1.azp02  OR tm.w !='N' THEN
            #     LET l_display3 = 'Y'
                  LET l_azp02 = sr1.azp02    #FUN-CB0058
               ELSE
            #     LET l_display3 = 'N'
                  LET l_azp02 = "  "         #FUN-CB0058
               END IF
            ELSE
            #  LET l_display3 = 'Y'
               LET l_azp02 = sr1.azp02    #FUN-CB0058
            END IF
            PRINTX l_display3
            IF NOT cl_null(sr1_o.ruc04)  OR tm.w !='N' THEN
               IF sr1_o.ruc04 != sr1.ruc04 THEN
            #     LET l_display1 = 'Y'
                  LET l_ruc04 = sr1.ruc04    #FUN-CB0058
               ELSE
            #     LET l_display1 = 'N'
                  LET l_ruc04 = "  "         #FUN-CB0058
               END IF
            ELSE
            #  LET l_display1 = 'Y'
               LET l_ruc04 = sr1.ruc04    #FUN-CB0058
            END IF
            PRINTX l_display1

            IF NOT cl_null(sr1_o.ima02) THEN
               IF sr1_o.ima02 = sr1.ima02  OR tm.w !='N' THEN
            #     LET l_display2 = 'N'
                  LET l_ima02 = sr1.ima02    #FUN-CB0058
               ELSE
            #     LET l_display2 = 'Y'
                  LET l_ima02 = "  "         #FUN-CB0058
               END IF
            ELSE
            #  LET l_display2 = 'Y'
               LET l_ima02 = sr1.ima02    #FUN-CB0058
            END IF
            PRINTX l_display2
            LET sr1_o.* = sr1.*
            IF tm.b != 'N' THEN         #FUN-CB0058 add
               LET l_ruc27 = sr1.ruc27  #FUN-CB0058 add
            ELSE                        #FUN-CB0058 add
               LET l_ruc27 = "  "       #FUN-CB0058 add 
            END IF                      #FUN-CB0058 add

            PRINTX l_display2
            PRINTX l_azw01  #FUN-CB0058
            PRINTX l_azp02  #FUN-CB0058
            PRINTX l_ruc04  #FUN-CB0058
            PRINTX l_ima02  #FUN-CB0058
            PRINTX l_ruc27  #FUN-CB0058
            PRINTX sr1.*

        AFTER GROUP OF sr1.azw01
            LET l_ruc18_sum1 = GROUP SUM(sr1.ruc18)
            LET l_ruc19_sum1 = GROUP SUM(sr1.ruc19)
            LET l_ruc20_sum1 = GROUP SUM(sr1.ruc20)
            LET l_ruc21_sum1 = GROUP SUM(sr1.ruc21)
            PRINTX l_ruc18_sum1
            PRINTX l_ruc19_sum1
            PRINTX l_ruc20_sum1
            PRINTX l_ruc21_sum1
        AFTER GROUP OF sr1.ruc04
            LET l_ruc18_sum2 = GROUP SUM(sr1.ruc18)
            LET l_ruc19_sum2 = GROUP SUM(sr1.ruc19)
            LET l_ruc20_sum2 = GROUP SUM(sr1.ruc20)
            LET l_ruc21_sum2 = GROUP SUM(sr1.ruc21)
            PRINTX l_ruc18_sum2
            PRINTX l_ruc19_sum2
            PRINTX l_ruc20_sum2
            PRINTX l_ruc21_sum2


        ON LAST ROW
            LET l_ruc18_sum = SUM(sr1.ruc18)
            LET l_ruc19_sum = SUM(sr1.ruc19)
            LET l_ruc20_sum = SUM(sr1.ruc20)
            LET l_ruc21_sum = SUM(sr1.ruc21)
            PRINTX l_ruc18_sum
            PRINTX l_ruc19_sum
            PRINTX l_ruc20_sum
            PRINTX l_ruc21_sum


END REPORT

FUNCTION artg330_3_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING


    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("artg330")
        IF handler IS NOT NULL THEN
            START REPORT artg330_3_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY azw01,ruc07,ruc27"

            DECLARE artg330_datacur3 CURSOR FROM l_sql
            FOREACH artg330_datacur3 INTO sr1.*
                OUTPUT TO REPORT artg330_3_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg330_3_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg330_3_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_display  STRING
    DEFINE l_display1 STRING
    DEFINE l_display2 STRING
    DEFINE l_display3 STRING
    DEFINE sr1_o sr1_t
    DEFINE l_ruc18_sum   LIKE ruc_file.ruc18
    DEFINE l_ruc19_sum   LIKE ruc_file.ruc19
    DEFINE l_ruc20_sum   LIKE ruc_file.ruc20
    DEFINE l_ruc21_sum   LIKE ruc_file.ruc21
    DEFINE l_ruc18_sum1  LIKE ruc_file.ruc18
    DEFINE l_ruc19_sum1  LIKE ruc_file.ruc19
    DEFINE l_ruc20_sum1  LIKE ruc_file.ruc20
    DEFINE l_ruc21_sum1  LIKE ruc_file.ruc21
    DEFINE l_ruc18_sum2  LIKE ruc_file.ruc18
    DEFINE l_ruc19_sum2  LIKE ruc_file.ruc19
    DEFINE l_ruc20_sum2  LIKE ruc_file.ruc20
    DEFINE l_ruc21_sum2  LIKE ruc_file.ruc21
    DEFINE l_ruc07       STRING
    DEFINE l_azw01      LIKE azw_file.azw01     #FUN-CB0058
    DEFINE l_azp02      LIKE azp_file.azp02     #FUN-CB0058
    DEFINE l_ruc04      LIKE ruc_file.ruc04     #FUN-CB0058
    DEFINE l_ima02      LIKE ima_file.ima02     #FUN-CB0058
    DEFINE l_ruc27      LIKE ruc_file.ruc27     #FUN-CB0058

    ORDER EXTERNAL BY sr1.azw01,sr1.ruc07

    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name #FUN-BA0061 add g_ptime,g_user_name
            PRINTX tm.*
            LET sr1_o.azw01 = NULL
            LET sr1_o.azp02 = NULL
            LET sr1_o.ruc04 = NULL 
            LET sr1_o.ima02 = NULL 


        BEFORE GROUP OF sr1.azw01
        BEFORE GROUP OF sr1.ruc07


        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            LET l_ruc07 = sr1.ruc07,':',cl_gr_getmsg("gre-252",g_lang,sr1.ruc07)
            PRINTX l_ruc07

            IF NOT cl_null(sr1_o.azw01) THEN
               IF sr1_o.azw01 != sr1.azw01  OR tm.w !='N' THEN
            #     LET l_display = 'Y'
                  LET l_azw01 = sr1.azw01    #FUN-CB0058
               ELSE
            #     LET l_display = 'N'
                  LET l_azw01 = "  "         #FUN-CB0058
               END IF
            ELSE
            #  LET l_display = 'Y'
               LET l_azw01 = sr1.azw01    #FUN-CB0058
            END IF
            PRINTX l_display
            IF NOT cl_null(sr1_o.azp02) THEN
               IF sr1_o.azp02 != sr1.azp02  OR tm.w !='N' THEN
            #     LET l_display3 = 'Y'
                  LET l_azp02 = sr1.azp02    #FUN-CB0058
               ELSE
            #     LET l_display3 = 'N'
                  LET l_azp02 = "   "        #FUN-CB0058
               END IF
            ELSE
            #  LET l_display3 = 'Y'
               LET l_azp02 = sr1.azp02    #FUN-CB0058
            END IF
            PRINTX l_display3
            IF NOT cl_null(sr1_o.ruc04) THEN
               IF sr1_o.ruc04 != sr1.ruc04  OR tm.w !='N' THEN
            #     LET l_display1 = 'Y'
                  LET l_ruc04 = sr1.ruc04    #FUN-CB0058
               ELSE
            #     LET l_display1 = 'N'
                  LET l_ruc04 = "   "        #FUN-CB0058
               END IF
            ELSE
            #  LET l_display1 = 'Y'
               LET l_ruc04 = sr1.ruc04    #FUN-CB0058
            END IF
            PRINTX l_display1

            IF NOT cl_null(sr1_o.ima02) THEN
               IF sr1_o.ima02 = sr1.ima02  OR tm.w !='N' THEN
            #     LET l_display2 = 'N'
                  LET l_ima02 = sr1.ima02    #FUN-CB0058
               ELSE
            #     LET l_display2 = 'Y'
                  LET l_ima02 = "   "        #FUN-CB0058
               END IF
            ELSE
            #  LET l_display2 = 'Y'
               LET l_ima02 = sr1.ima02    #FUN-CB0058
            END IF
            PRINTX l_display2
            LET sr1_o.* = sr1.*
            IF tm.b != 'N' THEN         #FUN-CB0058 add
               LET l_ruc27 = sr1.ruc27  #FUN-CB0058 add
            ELSE                        #FUN-CB0058 add
               LET l_ruc27 = "  "       #FUN-CB0058 add 
            END IF                      #FUN-CB0058 add

            PRINTX l_display2
            PRINTX l_azw01  #FUN-CB0058
            PRINTX l_azp02  #FUN-CB0058
            PRINTX l_ruc04  #FUN-CB0058
            PRINTX l_ima02  #FUN-CB0058
            PRINTX l_ruc27  #FUN-CB0058
            PRINTX sr1.*

        AFTER GROUP OF sr1.azw01
            LET l_ruc18_sum1 = GROUP SUM(sr1.ruc18)
            LET l_ruc19_sum1 = GROUP SUM(sr1.ruc19)
            LET l_ruc20_sum1 = GROUP SUM(sr1.ruc20)
            LET l_ruc21_sum1 = GROUP SUM(sr1.ruc21)
            PRINTX l_ruc18_sum1
            PRINTX l_ruc19_sum1
            PRINTX l_ruc20_sum1
            PRINTX l_ruc21_sum1
        AFTER GROUP OF sr1.ruc07
            LET l_ruc18_sum2 = GROUP SUM(sr1.ruc18)
            LET l_ruc19_sum2 = GROUP SUM(sr1.ruc19)
            LET l_ruc20_sum2 = GROUP SUM(sr1.ruc20)
            LET l_ruc21_sum2 = GROUP SUM(sr1.ruc21)
            PRINTX l_ruc18_sum2
            PRINTX l_ruc19_sum2
            PRINTX l_ruc20_sum2
            PRINTX l_ruc21_sum2

        ON LAST ROW
            LET l_ruc18_sum = SUM(sr1.ruc18)
            LET l_ruc19_sum = SUM(sr1.ruc19)
            LET l_ruc20_sum = SUM(sr1.ruc20)
            LET l_ruc21_sum = SUM(sr1.ruc21)
            PRINTX l_ruc18_sum
            PRINTX l_ruc19_sum
            PRINTX l_ruc20_sum
            PRINTX l_ruc21_sum


END REPORT

FUNCTION artg330_4_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("artg330")
        IF handler IS NOT NULL THEN
            START REPORT artg330_4_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY azw01,ruc04,ruc07,ruc27"

            DECLARE artg330_datacur4 CURSOR FROM l_sql
            FOREACH artg330_datacur4 INTO sr1.*
                OUTPUT TO REPORT artg330_4_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg330_4_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg330_4_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_display  STRING
    DEFINE l_display1 STRING
    DEFINE l_display2 STRING
    DEFINE l_display3 STRING
    DEFINE sr1_o sr1_t
    DEFINE l_ruc18_sum   LIKE ruc_file.ruc18
    DEFINE l_ruc19_sum   LIKE ruc_file.ruc19
    DEFINE l_ruc20_sum   LIKE ruc_file.ruc20
    DEFINE l_ruc21_sum   LIKE ruc_file.ruc21
    DEFINE l_ruc18_sum1  LIKE ruc_file.ruc18
    DEFINE l_ruc19_sum1  LIKE ruc_file.ruc19
    DEFINE l_ruc20_sum1  LIKE ruc_file.ruc20
    DEFINE l_ruc21_sum1  LIKE ruc_file.ruc21
    DEFINE l_ruc18_sum2  LIKE ruc_file.ruc18
    DEFINE l_ruc19_sum2  LIKE ruc_file.ruc19
    DEFINE l_ruc20_sum2  LIKE ruc_file.ruc20
    DEFINE l_ruc21_sum2  LIKE ruc_file.ruc21
    DEFINE l_ruc07       STRING
    DEFINE l_azw01      LIKE azw_file.azw01     #FUN-CB0058
    DEFINE l_azp02      LIKE azp_file.azp02     #FUN-CB0058
    DEFINE l_ruc04      LIKE ruc_file.ruc04     #FUN-CB0058
    DEFINE l_ima02      LIKE ima_file.ima02     #FUN-CB0058
    DEFINE l_ruc27      LIKE ruc_file.ruc27     #FUN-CB0058

    ORDER EXTERNAL BY sr1.azw01,sr1.ruc04

    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name #FUN-BA0061 add g_ptime,g_user_name
            PRINTX tm.*
            LET sr1_o.azw01 = NULL #FUN-BA0061
            LET sr1_o.azp02 = NULL #FUN-BA0061
            LET sr1_o.ruc04 = NULL #FUN-BA0061
            LET sr1_o.ima02 = NULL #FUN-BA0061


        BEFORE GROUP OF sr1.azw01
        BEFORE GROUP OF sr1.ruc04


        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            LET l_ruc07 = sr1.ruc07,':',cl_gr_getmsg("gre-252",g_lang,sr1.ruc07)
            PRINTX l_ruc07

            IF NOT cl_null(sr1_o.azw01) THEN
               IF sr1_o.azw01 != sr1.azw01  OR tm.w !='N' THEN
            #     LET l_display = 'Y'
                  LET l_azw01 = sr1.azw01    #FUN-CB0058
               ELSE
            #     LET l_display = 'N'
                  LET l_azw01 = "   "        #FUN-CB0058
               END IF
            ELSE
            #  LET l_display = 'Y'
               LET l_azw01 = sr1.azw01    #FUN-CB0058
            END IF
            PRINTX l_display
            IF NOT cl_null(sr1_o.azp02) THEN
               IF sr1_o.azp02 != sr1.azp02  OR tm.w !='N' THEN
            #     LET l_display3 = 'Y'
                  LET l_azp02 = sr1.azp02    #FUN-CB0058
               ELSE
            #     LET l_display3 = 'N'
                  LET l_azp02 = "   "        #FUN-CB0058
               END IF
            ELSE
            #  LET l_display3 = 'Y'
               LET l_azp02 = sr1.azp02    #FUN-CB0058
            END IF
            PRINTX l_display3
            IF NOT cl_null(sr1_o.ruc04) THEN
               IF sr1_o.ruc04 != sr1.ruc04  OR tm.w !='N' THEN
            #     LET l_display1 = 'Y'
                  LET l_ruc04 = sr1.ruc04    #FUN-CB0058
               ELSE
            #     LET l_display1 = 'N'
                  LET l_ruc04 = "  "         #FUN-CB0058
               END IF
            ELSE
            #  LET l_display1 = 'Y'
               LET l_ruc04 = sr1.ruc04    #FUN-CB0058
            END IF
            PRINTX l_display1

            IF NOT cl_null(sr1_o.ima02) THEN
               IF sr1_o.ima02 = sr1.ima02  OR tm.w !='N' THEN
            #     LET l_display2 = 'N'
                  LET l_ima02 = sr1.ima02    #FUN-CB0058
               ELSE
            #     LET l_display2 = 'Y'
                  LET l_ima02 = "  "         #FUN-CB0058
               END IF
            ELSE
            #  LET l_display2 = 'Y'
               LET l_ima02 = sr1.ima02    #FUN-CB0058
            END IF
            PRINTX l_display2
            LET sr1_o.* = sr1.*
            IF tm.b != 'N' THEN         #FUN-CB0058 add
               LET l_ruc27 = sr1.ruc27  #FUN-CB0058 add
            ELSE                        #FUN-CB0058 add
               LET l_ruc27 = "  "       #FUN-CB0058 add 
            END IF                      #FUN-CB0058 add

            PRINTX l_azw01  #FUN-CB0058
            PRINTX l_azp02  #FUN-CB0058
            PRINTX l_ruc04  #FUN-CB0058
            PRINTX l_ima02  #FUN-CB0058
            PRINTX l_ruc27  #FUN-CB0058
            PRINTX sr1.*

        AFTER GROUP OF sr1.azw01
            LET l_ruc18_sum1 = GROUP SUM(sr1.ruc18)
            LET l_ruc19_sum1 = GROUP SUM(sr1.ruc19)
            LET l_ruc20_sum1 = GROUP SUM(sr1.ruc20)
            LET l_ruc21_sum1 = GROUP SUM(sr1.ruc21)
            PRINTX l_ruc18_sum1
            PRINTX l_ruc19_sum1
            PRINTX l_ruc20_sum1
            PRINTX l_ruc21_sum1
        AFTER GROUP OF sr1.ruc04
            LET l_ruc18_sum2 = GROUP SUM(sr1.ruc18)
            LET l_ruc19_sum2 = GROUP SUM(sr1.ruc19)
            LET l_ruc20_sum2 = GROUP SUM(sr1.ruc20)
            LET l_ruc21_sum2 = GROUP SUM(sr1.ruc21)
            PRINTX l_ruc18_sum2
            PRINTX l_ruc19_sum2
            PRINTX l_ruc20_sum2
            PRINTX l_ruc21_sum2


        ON LAST ROW
            LET l_ruc18_sum = SUM(sr1.ruc18)
            LET l_ruc19_sum = SUM(sr1.ruc19)
            LET l_ruc20_sum = SUM(sr1.ruc20)
            LET l_ruc21_sum = SUM(sr1.ruc21)
            PRINTX l_ruc18_sum
            PRINTX l_ruc19_sum
            PRINTX l_ruc20_sum
            PRINTX l_ruc21_sum

END REPORT
#FUN-BA0061-------END-----------
###GENGRE###END
