# Prog. Version..:
#
# Pattern name...: csfr009.4gl
# Descriptions...: 工单调拨单打印
# Date & Author..: 20160904 by gujq

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE tm  RECORD                               
              wc      LIKE type_file.chr1000,      
              more    LIKE type_file.chr1          
              END RECORD  
 
DEFINE   g_cnt           LIKE type_file.num10      
DEFINE   g_i             LIKE type_file.num5       
DEFINE   g_msg           LIKE type_file.chr1000   
 
DEFINE   l_table         STRING
DEFINE   g_str           STRING
DEFINE   g_sql           STRING

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("csf")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
  
   LET g_sql="tc_imm01.tc_imm_file.tc_imm01,",
             "tc_imm02.tc_imm_file.tc_imm02,",
             "tc_imm08.tc_imm_file.tc_imm08,",
             "tc_imm10.tc_imm_file.tc_imm10,",
             "eca02.eca_file.eca02,",
             "tc_imm14.tc_imm_file.tc_imm14,",
             "tc_imm16.tc_imm_file.tc_imm16,",
             "tc_imp02.tc_imp_file.tc_imp02,",
             "tc_imp03.tc_imp_file.tc_imp03,",
             "tc_imp04.tc_imp_file.tc_imp04,",
             "ecd02.ecd_file.ecd02,",
             "tc_imp05.tc_imp_file.tc_imp05,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "tc_imp06.tc_imp_file.tc_imp06,",
             "imd02.imd_file.imd02,",
             "tc_imp07.tc_imp_file.tc_imp07,",
             "gen02.gen_file.gen02,",
             "tc_imp08.tc_imp_file.tc_imp08"
             

   LET  l_table = cl_prt_temptable('csfr009',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"         
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   INITIALIZE tm.* TO NULL         
   LET tm.wc = ARG_VAL(1)
   
   IF cl_null(tm.wc)
      THEN CALL csfr009_tm(0,0)          
      ELSE
           CALL csfr009()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION csfr009_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000      
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW csfr009_w AT p_row,p_col WITH FORM "csf/42f/csfr009"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON tc_imm01,tc_imm02
                              
     
      BEFORE CONSTRUCT
         CALL cl_qbe_init() 
 
      ON ACTION locale 
         CALL cl_show_fld_cont()                    
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION controlp
         CASE
              WHEN INFIELD(tc_imm01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_tc_imm"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_imm01
                OTHERWISE
                 EXIT CASE
           END CASE
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW csfr009_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
  #UI
   INPUT BY NAME tm.more  WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW csfr009_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='csfr009'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('csfr009','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc,'\\\"', "'")
         LET l_cmd = l_cmd CLIPPED,        
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.more CLIPPED,"'"  ,            #MOD-650024 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('csfr009',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW csfr009_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL csfr009()
   ERROR ""
END WHILE
   CLOSE WINDOW csfr009_w
END FUNCTION


FUNCTION csfr009()
   DEFINE l_name    LIKE type_file.chr20,         
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(3000)
          l_sfa161  LIKE sfa_file.sfa161,
          sr        RECORD
                    tc_imm01      LIKE tc_imm_file.tc_imm01,
                    tc_imm02      LIKE tc_imm_file.tc_imm02,
                    tc_imm08      LIKE tc_imm_file.tc_imm08,
                    tc_imm10      LIKE tc_imm_file.tc_imm10,
                    eca02         LIKE eca_file.eca02,
                    tc_imm14      LIKE tc_imm_file.tc_imm14,
                    tc_imm16      LIKE tc_imm_file.tc_imm16,
                    tc_imp02      LIKE tc_imp_file.tc_imp02,
                    tc_imp03      LIKE tc_imp_file.tc_imp03,
                    tc_imp04      LIKE tc_imp_file.tc_imp04,
                    ecd02         LIKE ecd_file.ecd02,
                    tc_imp05      LIKE tc_imp_file.tc_imp05,
                    ima02         LIKE ima_file.ima02,
                    ima021        LIKE ima_file.ima021,
                    tc_imp06      LIKE tc_imp_file.tc_imp06,
                    imd02         LIKE imd_file.imd02,
                    tc_imp07      LIKE tc_imp_file.tc_imp07,
                    gen02         LIKE gen_file.gen02,
                    tc_imp08      LIKE tc_imp_file.tc_imp08
                    END RECORD
   DEFINE l_cnt     LIKE type_file.num5                       
 
     CALL cl_del_data(l_table) 

     LET tm.wc = tm.wc CLIPPED 
     LET l_sql=" SELECT tc_imm01,tc_imm02,tc_imm08,tc_imm10,eca02,tc_imm14,tc_imm16,tc_imp02,tc_imp03,tc_imp04,ecd02,tc_imp05,ima02,ima021,tc_imp06,imd02,tc_imp07,gen02,tc_imp08 ",
               "   FROM tc_imm_file LEFT JOIN eca_file ON tc_imm10 = eca01,tc_imp_file ",
               "   LEFT JOIN ecd_file ON tc_imp04 = ecd01 ",
               "   LEFT JOIN ima_file ON tc_imp05 = ima01 ",
               "   LEFT JOIN gen_file ON tc_imp07 = gen01 ",
               "   LEFT JOIN imd_file ON tc_imp06 = imd01 ",
               " WHERE tc_imp01 = tc_imm01 AND ",tm.wc
 
     PREPARE csfr009_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE csfr009_curs1 CURSOR FOR csfr009_prepare1
 
     FOREACH csfr009_curs1 INTO sr.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF

        EXECUTE insert_prep USING sr.*
     END FOREACH
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'shm01')
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc

     CALL cl_prt_cs3('csfr009','csfr009',g_sql,g_str)

END FUNCTION



