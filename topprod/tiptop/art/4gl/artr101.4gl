# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: artr101.4gl
# Descriptions...: 條碼列印作業
# Date & Author..: FUN-A30113 10/03/29 By chenmoyan
# Modify.........: No.FUN-A50012 24/06/23 By shenyang 在服飾行業中隱藏"普通查詢"中的廠商編號，
# Modify.........: No.TQC-AC0022 10/12/07 By houlia 過單
# Modify.........: No.FUN-B80085 11/08/09 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-BC0026 12/01/30 By pauline 列印前是否有參考p_zz中的設定列印條件選項

DATABASE ds   #TQC-AC0022過單
GLOBALS "../../config/top.global"

DEFINE
   tm     RECORD
           wc1            STRING,                   
           wc            STRING, 
           s             LIKE type_file.chr3,
           s1             LIKE type_file.chr3,
           s2             LIKE type_file.chr3,
           rte04         LIKE rte_file.rte04,
           rte05         LIKE rte_file.rte05,
           rte06         LIKE rte_file.rte06,
           rte07         LIKE rte_file.rte07,
           more          LIKE type_file.chr1 
          END RECORD,
    g_rte  DYNAMIC ARRAY OF RECORD
          azw02       LIKE ima_file.ima01,
          rte03       LIKE rte_file.rte03,
          rtd01       LIKE rtd_file.rtd01,
          ima02       LIKE ima_file.ima02
        END RECORD
DEFINE   g_i             LIKE type_file.num5
DEFINE   g_cnt           LIKE type_file.num10 
DEFINE   g_head1         STRING
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING 
DEFINE   g_chk_azp01     LIKE type_file.chr1
DEFINE   g_chk_auth      STRING  
DEFINE   g_azp01         LIKE azp_file.azp01 
DEFINE   g_azp01_str     STRING

 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT  
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   LET g_sql =  "order1.type_file.chr20,",        
                "order2.type_file.chr20,",
                "azw01.azw_file.azw01,",   
                "azp02.azp_file.azp02,",
                "rtd01.rtd_file.rtd01,",
                "rte03.rte_file.rte03,",
                "ima02.ima_file.ima02,", 
                "rte04.rte_file.rte04,",  
                "rte05.rte_file.rte05,", 
                "rte06.rte_file.rte06,",
                "rte07.rte_file.rte07,",
                "ima131.ima_file.ima131"
                
   LET l_table = cl_prt_temptable('artr101',g_sql) CLIPPED                                                                         
   IF  l_table = -1 THEN EXIT PROGRAM END IF  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time                  

   LET g_pdate = ARG_VAL(1)		      # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.rte04  = ARG_VAL(8)
   LET tm.rte05  = ARG_VAL(9)
   LET tm.rte06  = ARG_VAL(10)
   LET tm.rte07  = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)

   IF cl_null(g_bgjob) OR g_bgjob = 'N'        
      THEN CALL r101_tm(0,0)        
      ELSE CALL r101() 				
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION r101_tm(p_row,p_col)
   DEFINE l_num          LIKE type_file.num10
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000 
   DEFINE tok            base.StringTokenizer 
   DEFINE l_zxy03        LIKE zxy_file.zxy03 
        
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW r101_w AT p_row,p_col WITH FORM "art/42f/artr101" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s = ''
   LET tm.rte04 = '1'
   LET tm.rte05 = '1'
   LET tm.rte06 = '1'
   LET tm.rte07 = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'
   LET tm2.s1 = tm.s[1,1]
   LET tm2.s2 = tm.s[2,2]
 
   IF cl_null(tm2.s1) THEN LET tm2.s1 = " "  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = " "  END IF
   
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
               DECLARE r101_zxy_cs1 CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
               FOREACH r101_zxy_cs1 INTO l_zxy03 
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
         LET INT_FLAG = 0 CLOSE WINDOW r101_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

      LET l_num = tm.wc1.getIndexOf('azp01',1)
      IF l_num = 0 THEN
         CALL cl_err('','art-926',0) CONTINUE WHILE
      END IF
      
CONSTRUCT BY NAME tm.wc ON ima131,rte03
             
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
    ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    EXIT CONSTRUCT
     ON ACTION controlp    #FUN-4B0024
         CASE
           
            WHEN INFIELD(ima131)
               CALL cl_init_qry_var()
               LET g_qryparam.state ="c"
               LET g_qryparam.form ="q_ima131"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima131
               NEXT FIELD ima131
            WHEN INFIELD(rte03)
               CALL cl_init_qry_var()
               LET g_qryparam.state ="c"
               LET g_qryparam.form ="q_ima01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rte03
               NEXT FIELD rte03
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
         LET INT_FLAG = 0 CLOSE WINDOW r101_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
  #  IF tm.wc=" 1=1 " THEN
  #    CALL cl_err(' ','9046',0)
  #    CONTINUE WHILE
  #  END IF

      DISPLAY BY NAME tm.rte04,tm.rte05,tm.rte06,tm.rte07,tm2.s1,tm2.s2,tm.more
      INPUT BY NAME tm.rte04,tm.rte05,tm.rte06,tm.rte07,tm2.s1,tm2.s2, tm.more 
                     WITHOUT DEFAULTS
        BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)

        AFTER FIELD rte04
         IF cl_null(tm.rte04) OR tm.rte04 NOT MATCHES '[123]' THEN
            NEXT FIELD rte04
         END IF
        AFTER FIELD rte05
         IF cl_null(tm.rte05) OR tm.rte05 NOT MATCHES '[123]' THEN
            NEXT FIELD rte05
         END IF
        AFTER FIELD rte06
         IF cl_null(tm.rte06) OR tm.rte06 NOT MATCHES '[123]' THEN
            NEXT FIELD rte06
         END IF
        AFTER FIELD rte07
         IF cl_null(tm.rte07) OR tm.rte07 NOT MATCHES '[123]' THEN
            NEXT FIELD rte07
         END IF

         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
    AFTER INPUT         
         LET tm.s = tm2.s1[1,1] , tm2.s2[1,1] 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
            
         ON ACTION CONTROLG 
            CALL cl_cmdask()   
      
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
         LET INT_FLAG = 0 CLOSE WINDOW r101_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='artr101'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('artr101','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.rte04 CLIPPED,"'",
                         " '",tm.rte05 CLIPPED,"'",
                         " '",tm.rte06 CLIPPED,"'",
                         " '",tm.rte07 CLIPPED,"'",
                         " '",tm.s1 CLIPPED,"'",
                         " '",tm.s2 CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'" 
         CALL cl_cmdat('artr101',g_time,l_cmd)    # Execute cmd at later time
         END IF
        CLOSE WINDOW r101_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF         
      CALL cl_wait()
      CALL r101()
      ERROR ""
   END WHILE
   CLOSE WINDOW r101_w
END FUNCTION

FUNCTION r101()
   DEFINE l_plant   LIKE  azp_file.azp01
   DEFINE l_azp02   LIKE  azp_file.azp02
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_chr     LIKE type_file.chr1, 
          l_sql 	STRING,	       
          l_order   ARRAY[5] OF LIKE type_file.chr20,       
          sr        RECORD 
                    order1      LIKE type_file.chr20,        
                    order2      LIKE type_file.chr20,
                    azw01       LIKE azw_file.azw01,
                    azp02       LIKE azp_file.azp02,
                    rtd01       LIKE rtd_file.rtd01,
                    rte03       LIKE rte_file.rte03,
                    ima02       LIKE ima_file.ima02,
                    rte04       LIKE rte_file.rte04,
                    rte05       LIKE rte_file.rte05,
                    rte06       LIKE rte_file.rte06,
                    rte07       LIKE rte_file.rte07,
                    ima131      LIKE ima_file.ima131
                    END RECORD  
      CALL cl_del_data(l_table)               
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')

    
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
             " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"  
             
   PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1)                
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80085--add--                                                                        
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
   LET l_sql = " SELECT '','',azw01,'',rtd01,rte03,ima02,",
              " rte04,rte05,rte06,rte07,'' ",
              "  FROM ",cl_get_target_table(l_plant,'azw_file'),
                ",",cl_get_target_table(l_plant,'rtd_file'),
                ",",cl_get_target_table(l_plant,'ima_file'),
                ",",cl_get_target_table(l_plant,'rte_file'),
                ",",cl_get_target_table(l_plant,'rtz_file'),
             " WHERE azw01 = rtz01 AND rtz04=rtd01 AND rtd01=rte01", 
             " AND ima01 = rte03", 
             " AND azw01 = '",l_plant,"' ", 
             " AND ",tm.wc CLIPPED

    CASE tm.rte04
        WHEN '1'  LET l_sql = l_sql CLIPPED
                         
        WHEN '2'  LET l_sql = l_sql CLIPPED,
                         " AND rte04 = 'Y'"
        WHEN '3'  LET l_sql = l_sql CLIPPED,
                         " AND rte04 = 'N'"
        OTHERWISE EXIT CASE
     END CASE             
      CASE tm.rte05
        WHEN '1'  LET l_sql = l_sql CLIPPED
                        
        WHEN '2'  LET l_sql = l_sql CLIPPED,
                       " AND rte05 = 'Y'"
        WHEN '3'  LET l_sql = l_sql CLIPPED,
                        " AND rte05 = 'N'"
        OTHERWISE EXIT CASE
     END CASE
     CASE tm.rte06
        WHEN '1'  LET l_sql = l_sql CLIPPED
                          
        WHEN '2'  LET l_sql = l_sql CLIPPED,
                        " AND rte06 = 'Y'"
        WHEN '3'  LET l_sql = l_sql CLIPPED,
                       " AND rte06 = 'N'"
        OTHERWISE EXIT CASE
     END CASE
     CASE tm.rte07
        WHEN '1'  LET l_sql = l_sql CLIPPED
                        
        WHEN '2'  LET l_sql = l_sql CLIPPED,
                         " AND rte07 = 'Y'"
        WHEN '3'  LET l_sql = l_sql CLIPPED,
                        " AND rte07 = 'N'"
     OTHERWISE EXIT CASE
     END CASE
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql          
       CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
       
    PREPARE r101_prepare  FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
    END IF
   DECLARE r101_curs1 CURSOR FOR r101_prepare
 
    FOREACH r101_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
    FOR g_i = 1 TO 2
         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.azw01
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima131
              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.rte03
              OTHERWISE LET l_order[g_i] = '-'
         END CASE
      END FOR
      LET sr.order1 = l_order[1]
      LET sr.order2 = l_order[2]

 
    EXECUTE  insert_prep  USING 
     sr.order1,sr.order2,sr.azw01,l_azp02,sr.rtd01,sr.rte03,sr.ima02,
     sr.rte04, sr.rte05, sr.rte06, sr.rte07,sr.ima131
    END FOREACH 
END FOREACH
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
  #LET g_str = tm.wc1,";",tm.wc   #FUN-BC0026 mark
  #FUN-BC0026 add START
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc1,'azp01')
      RETURNING tm.wc1
      CALL cl_wcchp(tm.wc,'ima131,rte03')
      RETURNING tm.wc
      LET g_str = tm.wc1,";",tm.wc
      IF g_str.getLength() > 1000 THEN
         LET g_str = g_str.subString(1,600)
         LET g_str = g_str,"..."
      END IF
   END IF
  #FUN-BC0026 add END
     CALL cl_prt_cs3('artr101','artr101',l_sql,g_str)   
END FUNCTION



