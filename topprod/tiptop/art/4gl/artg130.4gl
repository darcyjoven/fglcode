# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: artg130.4gl
# Descriptions...: 產品資料表
# Date & Author..: #FUN-A60075 10/06/25 By sunchenxu
# Modify.........: No.FUN-B80085 11/08/09 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-BA0062 11/10/17 By wangning 明細CR報表轉GR
# Modify.........: No.FUN-BC0058 11/12/26 By yangxf 原會員分類碼別以不同檔案區分存放,改以同一檔案不同類別區分.

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                # Print condition RECORD
              wc      STRING,    
              s       LIKE type_file.chr3, # Order by sequence
              more    LIKE type_file.chr1       # Input more condition(Y/N)
              END RECORD 
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose        
DEFINE   g_head1         STRING
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING 

###GENGRE###START
TYPE sr1_t RECORD
    order1 LIKE type_file.chr20,
    order2 LIKE type_file.chr20,
    order3 LIKE type_file.chr20,
    lpk01 LIKE lpk_file.lpk01,
    lpk02 LIKE lpk_file.lpk02,
    lpk03 LIKE lpk_file.lpk03,
    lpk04 LIKE lpk_file.lpk04,
    lpk05 LIKE lpk_file.lpk05,
    lpk06 LIKE lpk_file.lpk06,
    lpk07 LIKE lpk_file.lpk07,
    lpk08 LIKE lpk_file.lpk08,
#   lpa02 LIKE lpa_file.lpa02,       #FUN-BC0058 mark
    lpa02 LIKE lpc_file.lpc02,       #FUN-BC0058 
    lpk09 LIKE lpk_file.lpk09,
#   lpe02 LIKE lpe_file.lpe02,       #FUN-BC0058 mark
    lpe02 LIKE lpc_file.lpc02,       #FUN-BC0058
    lpk10 LIKE lpk_file.lpk10,
#   lpf02 LIKE lpf_file.lpf02,       #FUN-BC0058 mark
    lpf02 LIKE lpc_file.lpc02,       #FUN-BC0058
    lpk11 LIKE lpk_file.lpk11,
#   lpc02 LIKE lpc_file.lpc02,       #FUN-BC0058 mark
#   lpc03 LIKE lpc_file.lpc03,       #FUN-BC0058 mark
    lpc02 LIKE lpc_file.lpc03,       #FUN-BC0058
    lpc03 LIKE lpc_file.lpc04,       #FUN-BC0058
    lpk12 LIKE lpk_file.lpk12,
#   lpd02 LIKE lpd_file.lpd02,       #FUN-BC0058 mark
    lpd02 LIKE lpc_file.lpc02,       #FUN-BC0058
    lpk13 LIKE lpk_file.lpk13,
#   lpg02 LIKE lpg_file.lpg02,       #FUN-BC0058 mark
    lpg02 LIKE lpc_file.lpc02,       #FUN-BC0058 
    lpk14 LIKE lpk_file.lpk14,
#   lpb02 LIKE lpb_file.lpb02,       #FUN-BC0058 mark
    lpb02 LIKE lpc_file.lpc02,       #FUN-BC0058 
    lpk15 LIKE lpk_file.lpk15,
    lpk16 LIKE lpk_file.lpk16,
    lpk17 LIKE lpk_file.lpk17,
    lpk18 LIKE lpk_file.lpk18,
    lpk19 LIKE lpk_file.lpk19
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

   LET g_sql =  "order1.type_file.chr20,",        
                "order2.type_file.chr20,",       
                "order3.type_file.chr20,",
                "lpk01.lpk_file.lpk01,",
                "lpk02.lpk_file.lpk02,",
                "lpk03.lpk_file.lpk03,",
                "lpk04.lpk_file.lpk04,",
                "lpk05.lpk_file.lpk05,",
                "lpk06.lpk_file.lpk06,",
                "lpk07.lpk_file.lpk07,",
                "lpk08.lpk_file.lpk08,",
#               "lpa02.lpa_file.lpa02,",     #FUN-BC0058  mark
                "lpa02.lpc_file.lpc02,",     #FUN-BC0058  
                "lpk09.lpk_file.lpk09,",
#               "lpe02.lpe_file.lpe02,",     #FUN-BC0058  mark
                "lpe02.lpc_file.lpc02,",     #FUN-BC0058 
                "lpk10.lpk_file.lpk10,",
#               "lpf02.lpf_file.lpf02,",     #FUN-BC0058  mark
                "lpf02.lpc_file.lpc02,",     #FUN-BC0058 
                "lpk11.lpk_file.lpk11,",
#               "lpc02.lpc_file.lpc02,",     #FUN-BC0058  mark
#               "lpc03.lpc_file.lpc03,",     #FUN-BC0058  mark
                "lpc02.lpc_file.lpc03,",     #FUN-BC0058
                "lpc03.lpc_file.lpc04,",     #FUN-BC0058  
                "lpk12.lpk_file.lpk12,",
#               "lpd02.lpd_file.lpd02,",     #FUN-BC0058  mark
                "lpd02.lpc_file.lpc02,",     #FUN-BC0058                      
                "lpk13.lpk_file.lpk13,", 
#               "lpg02.lpg_file.lpg02,",     #FUN-BC0058  mark
                "lpg02.lpc_file.lpc02,",     #FUN-BC0058
                "lpk14.lpk_file.lpk14,",
#               "lpb02.lpb_file.lpb02,",     #FUN-BC0058  mark
                "lpb02.lpc_file.lpc02,",     #FUN-BC0058 
                "lpk15.lpk_file.lpk15,",
                "lpk16.lpk_file.lpk16,",
                "lpk17.lpk_file.lpk17,",
                "lpk18.lpk_file.lpk18,",
                "lpk19.lpk_file.lpk19 "
 
   LET l_table = cl_prt_temptable('artg130',g_sql) CLIPPED
   IF  l_table = -1 THEN
      #CALL cl_gre_drop_temptable(l_table)     #FUN-BA0062 mark
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)
    

   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL artg130_tm(0,0)        # Input print condition
      ELSE CALL artg130()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   CALL cl_gre_drop_temptable(l_table)     #FUN-BA0062
END MAIN

FUNCTION artg130_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000 
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW artg130_w AT p_row,p_col WITH FORM "art/42f/artg130" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF

   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON lpk01,lpk13,lpk10,lpk09,
                                 lpk11,lpk14,lpk12,lpk05,
                                 lpk06,lpk08

         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT      
            
         ON ACTION controlp
            CASE
               WHEN INFIELD(lpk01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lpk"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk01
                  NEXT FIELD lpk01
               WHEN INFIELD(lpk13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lpk13"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk13
                  NEXT FIELD lpk13
               WHEN INFIELD(lpk10)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lpk10"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk10
                  NEXT FIELD lpk10
               WHEN INFIELD(lpk09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lpk09"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk09
                  NEXT FIELD lpk09
               WHEN INFIELD(lpk11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lpk11"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk11
                  NEXT FIELD lpk11
               WHEN INFIELD(lpk14)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lpk14"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk14
                  NEXT FIELD lpk14
               WHEN INFIELD(lpk12)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lpk12"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk12
                  NEXT FIELD lpk12
               WHEN INFIELD(lpk08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lpk08"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk08
                  NEXT FIELD lpk08
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
         LET INT_FLAG = 0 CLOSE WINDOW artg130_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)     #FUN-BA0062
         EXIT PROGRAM
      END IF
      
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
      DISPLAY BY NAME tm2.s1,tm2.s2,tm2.s3,tm.more 
      
      INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm.more WITHOUT DEFAULTS

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)

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
            
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            
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
         LET INT_FLAG = 0 CLOSE WINDOW artg130_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)     #FUN-BA0062
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='artg130'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('artg130','9031',1)
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
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('artg130',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artg130_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)     #FUN-BA0062
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artg130()
      ERROR ""
   END WHILE
   CLOSE WINDOW artg130_w
END FUNCTION

FUNCTION artg130()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 
          l_chr     LIKE type_file.chr1,       
          l_za05    LIKE type_file.chr1000,      
          l_order   ARRAY[5] OF LIKE type_file.chr20,       
          sr        RECORD 
                    order1   LIKE type_file.chr20,        
                    order2   LIKE type_file.chr20,       
                    order3   LIKE type_file.chr20,  
                    lpk01    LIKE lpk_file.lpk01,
                    lpk02    LIKE lpk_file.lpk02,
                    lpk03    LIKE lpk_file.lpk03,
                    lpk04    LIKE lpk_file.lpk04,
                    lpk05    LIKE lpk_file.lpk05,
                    lpk06    LIKE lpk_file.lpk06,
                    lpk07    LIKE lpk_file.lpk07,
                    lpk08    LIKE lpk_file.lpk08,
                    lpk09    LIKE lpk_file.lpk09,
                    lpk10    LIKE lpk_file.lpk10,
                    lpk11    LIKE lpk_file.lpk11,
                    lpk12    LIKE lpk_file.lpk12,
                    lpk13    LIKE lpk_file.lpk13,
                    lpk14    LIKE lpk_file.lpk14,
                    lpk15    LIKE lpk_file.lpk15,
                    lpk16    LIKE lpk_file.lpk16,
                    lpk17    LIKE lpk_file.lpk17,
                    lpk18    LIKE lpk_file.lpk18,
                    lpk19    LIKE lpk_file.lpk19
                    END RECORD
#FUN-BC0058 ---begin---mark                    
#    DEFINE l_lpa02  LIKE lpa_file.lpa02,
#           l_lpb02  LIKE lpb_file.lpb02,
#           l_lpc02  LIKE lpc_file.lpc02,
#           l_lpc03  LIKE lpc_file.lpc03,
#           l_lpd02  LIKE lpd_file.lpd02,
#           l_lpe02  LIKE lpe_file.lpe02,
#           l_lpf02  LIKE lpf_file.lpf02,
#           l_lpg02  LIKE lpg_file.lpg02
#FUN-BC0058 ---end---mark
#FUN-BC0058 ---begin---
    DEFINE l_lpa02  LIKE lpc_file.lpc02,
           l_lpb02  LIKE lpc_file.lpc02,
           l_lpc02  LIKE lpc_file.lpc03,
           l_lpc03  LIKE lpc_file.lpc04,
           l_lpd02  LIKE lpc_file.lpc02,
           l_lpe02  LIKE lpc_file.lpc02,
           l_lpf02  LIKE lpc_file.lpc02,
           l_lpg02  LIKE lpc_file.lpc02           
#FUN-BC0058 ---end---
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')

    CALL cl_del_data(l_table)
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                                                         
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1)                                                                                        
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-BA0062--add--
       CALL cl_gre_drop_temptable(l_table)     #FUN-BA0062
       EXIT PROGRAM                                                                                                                 
    END IF

    LET l_sql = "SELECT '','','',",
                " lpk01,lpk02,lpk03,lpk04,lpk05,lpk06,lpk07,lpk08,",
                " lpk09,lpk10,lpk11,lpk12,lpk13,",
                " lpk14,lpk15,lpk16,lpk17,lpk18,lpk19",
                " FROM lpk_file",
                " WHERE ",tm.wc CLIPPED
    PREPARE artg130_prepare1 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       CALL cl_gre_drop_temptable(l_table)     #FUN-BA0062
       EXIT PROGRAM
    END IF
    DECLARE artg130_curs1 CURSOR FOR artg130_prepare1

    FOREACH artg130_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
      FOR g_i = 1 TO 3
         CASE WHEN tm.s[g_i,g_i] = '1'  LET l_order[g_i] = sr.lpk01
              WHEN tm.s[g_i,g_i] = '2'  LET l_order[g_i] = sr.lpk13
              WHEN tm.s[g_i,g_i] = '3'  LET l_order[g_i] = sr.lpk10
              WHEN tm.s[g_i,g_i] = '4'  LET l_order[g_i] = sr.lpk09
              WHEN tm.s[g_i,g_i] = '5'  LET l_order[g_i] = sr.lpk11
              WHEN tm.s[g_i,g_i] = '6'  LET l_order[g_i] = sr.lpk14
              WHEN tm.s[g_i,g_i] = '7'  LET l_order[g_i] = sr.lpk12
              WHEN tm.s[g_i,g_i] = '8'  LET l_order[g_i] = sr.lpk05
              WHEN tm.s[g_i,g_i] = '9'  LET l_order[g_i] = sr.lpk06
              WHEN tm.s[g_i,g_i] = '10' LET l_order[g_i] = sr.lpk08
              OTHERWISE LET l_order[g_i] = '-'
         END CASE
      END FOR

      LET sr.order1 = l_order[1]
      LET sr.order2 = l_order[2]
      LET sr.order3 = l_order[3]
#     SELECT lpa02 INTO l_lpa02 FROM lpa_file WHERE lpa01 = sr.lpk08  #FUN-BC0058 mark
      SELECT lpc02 INTO l_lpa02 FROM lpc_file WHERE lpc01 = sr.lpk08 AND lpc00 = '1'  #FUN-BC0058
#     SELECT lpb02 INTO l_lpb02 FROM lpb_file WHERE lpb01 = sr.lpk14  #FUN-BC0058 mark 
      SELECT lpc02 INTO l_lpb02 FROM lpc_file WHERE lpc01 = sr.lpk14 AND lpc00 = '2'  #FUN-BC0058
#     SELECT lpc02,lpc03 INTO l_lpc02,l_lpc03 FROM lpc_file WHERE lpc01 = sr.lpk11  #FUN-BC0058 mark
      SELECT lpc03,lpc04 INTO l_lpc02,l_lpc03 FROM lpc_file WHERE lpc01 = sr.lpk11 AND lpc00 = '3'  #FUN-BC0058
#     SELECT lpd02 INTO l_lpd02 FROM lpd_file WHERE lpd01 = sr.lpk12  #FUN-BC0058 mark
      SELECT lpc02 INTO l_lpd02 FROM lpc_file WHERE lpc01 = sr.lpk12 AND lpc00 = '4'  #FUN-BC0058
#     SELECT lpe02 INTO l_lpe02 FROM lpe_file WHERE lpe01 = sr.lpk09  #FUN-BC0058 mark
      SELECT lpc02 INTO l_lpe02 FROM lpc_file WHERE lpc01 = sr.lpk09 AND lpc00 = '5' #FUN-BC0058
#     SELECT lpf02 INTO l_lpf02 FROM lpf_file WHERE lpf01 = sr.lpk10  #FUN-BC0058 mark
      SELECT lpc02 INTO l_lpf02 FROM lpc_file WHERE lpc01 = sr.lpk10 AND lpc00 = '6' #FUN-BC0058 
#     SELECT lpg02 INTO l_lpg02 FROM lpg_file WHERE lpg01 = sr.lpk13  #FUN-BC0058 mark
      SELECT lpc02 INTO l_lpg02 FROM lpc_file WHERE lpc01 = sr.lpk13 AND lpc00 = '7' #FUN-BC0058
      IF SQLCA.sqlcode THEN
          LET l_lpa02 = NULL
      END IF
      EXECUTE  insert_prep  USING  
      sr.order1,sr.order2,sr.order3,sr.lpk01,sr.lpk02,sr.lpk03,
      sr.lpk04,sr.lpk05,sr.lpk06,sr.lpk07,sr.lpk08,l_lpa02,sr.lpk09,
      l_lpe02,sr.lpk10,l_lpf02,sr.lpk11,l_lpc02,l_lpc03,sr.lpk12,
      l_lpd02,sr.lpk13,l_lpg02,sr.lpk14,l_lpb02,sr.lpk15,
      sr.lpk16,sr.lpk17,sr.lpk18,sr.lpk19
   END FOREACH
###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###   LET g_str = tm.wc
###GENGRE###   CALL cl_prt_cs3('artg130','artg130',l_sql,g_str) 
    CALL artg130_grdata()    ###GENGRE###
END FUNCTION
#FUN-A60075

###GENGRE###START
FUNCTION artg130_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("artg130")
        IF handler IS NOT NULL THEN
            START REPORT artg130_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY order1,order2,order3"
          
            DECLARE artg130_datacur1 CURSOR FROM l_sql
            FOREACH artg130_datacur1 INTO sr1.*
                OUTPUT TO REPORT artg130_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg130_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg130_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-BA0062----add----str--------
    DEFINE l_lpk02    STRING
    DEFINE l_lpk06    STRING
    DEFINE l_lpk07    STRING
    #FUN-BA0062----add----end--------

    
    ORDER EXTERNAL BY sr1.order1,sr1.order2,sr1.order3
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name     #FUN-BA0062  add g_ptime,g_user_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.order1
        BEFORE GROUP OF sr1.order2
        BEFORE GROUP OF sr1.order3

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-BA0062----add----str--------

            CASE sr1.lpk02
               WHEN "0"
                  LET l_lpk02 = cl_gr_getmsg("gre-248",g_lang,1)
               WHEN "1"
                  LET l_lpk02 = cl_gr_getmsg("gre-248",g_lang,2)
               WHEN "2"
                  LET l_lpk02 = cl_gr_getmsg("gre-248",g_lang,3)
            END CASE
            PRINTX l_lpk02

            CASE sr1.lpk06
               WHEN "0"
                  LET l_lpk06 = cl_gr_getmsg("gre-249",g_lang,1)
               WHEN "1"
                  LET l_lpk06 = cl_gr_getmsg("gre-249",g_lang,2)
            END CASE
            PRINTX l_lpk06

            CASE sr1.lpk07
               WHEN "0"
                  LET l_lpk07 = cl_gr_getmsg("gre-250",g_lang,1)
               WHEN "1"
                  LET l_lpk07 = cl_gr_getmsg("gre-250",g_lang,2)
               WHEN "2"
                  LET l_lpk07 = cl_gr_getmsg("gre-250",g_lang,3)
            END CASE
            PRINTX l_lpk07
                  
            #FUN-BA0062----add----end--------

            PRINTX sr1.*

        AFTER GROUP OF sr1.order1
        AFTER GROUP OF sr1.order2
        AFTER GROUP OF sr1.order3

        
        ON LAST ROW

END REPORT
###GENGRE###END
