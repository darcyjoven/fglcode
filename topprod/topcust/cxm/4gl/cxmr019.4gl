# Prog. Version..:
#
# Pattern name...: cxmr019.4gl
# Descriptions...: 送货单打印
# Date & Author..: 16/03/03 By huanglf
#HFBG-16030001
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE tm  RECORD                               
              wc      LIKE type_file.chr1000,      
              more    LIKE type_file.chr1          
              END RECORD  
 
DEFINE   g_cnt           LIKE type_file.num10      
DEFINE   g_i             LIKE type_file.num5       
DEFINE   g_msg           LIKE type_file.chr1000  
DEFINE   g_oga01         LIKE oga_file.oga01 
 
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
 
   IF (NOT cl_setup("CXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
  
   LET g_sql="oga01.oga_file.oga01,",
             "oga02.oga_file.oga02,",
             "oga03.oga_file.oga03,",
             "ima02.ima_file.ima02,",
             "ogb03.ogb_file.ogb03,",
             
             "ogbud02.ogb_file.ogbud02,",
             "ogb04.ogb_file.ogb04,",
             "ogb12.ogb_file.ogb12,",
             "ogb092.ogb_file.ogb092,",
             "tc_obe04.tc_obe_file.tc_obe04,",

             "oga032.oga_file.oga032"


             

   LET  l_table = cl_prt_temptable('cxmr019',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"    #add ? by guanyao161101                  
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   INITIALIZE tm.* TO NULL         
   LET g_pdate = ARG_VAL(1)       
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
   
   IF cl_null(tm.wc) THEN 
      CALL cxmr019_tm(0,0)          
   ELSE
      CALL cxmr019()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION cxmr019_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000      
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW cxmr019_w AT p_row,p_col WITH FORM "cxm/42f/cxmr019"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oga01,ogb03,oga02
                              
     
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
              WHEN INFIELD(oga01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oga7"  #No.TQC-5B0095
                 LET g_qryparam.arg1 = "2','3','4','6','7','8','A"   #No.TQC-5B0095 #No.FUN-610020   #TQC-BB0013 add "A"
              #   LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oga01   
                 NEXT FIELD oga01
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
      LET INT_FLAG = 0 CLOSE WINDOW cxmr019_w 
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
      LET INT_FLAG = 0 CLOSE WINDOW cxmr019_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='cxmr019'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cxmr019','9031',1)
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
                        #" '",tm.more CLIPPED,"'"  ,            #MOD-650024 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('cxmr019',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW cxmr019_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cxmr019()
   ERROR ""
END WHILE
   CLOSE WINDOW cxmr019_w
END FUNCTION


FUNCTION cxmr019()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_zo041   LIKE zo_file.zo041,   #FUN-810029 add
          l_zo042   LIKE zo_file.zo042,
          l_zo05    LIKE zo_file.zo05,     #FUN-810029 add
          l_zo09    LIKE zo_file.zo09,     #FUN-810029 add
          l_ogb03   LIKE ogb_file.ogb03,
          sr        RECORD
                    
                    oga01    LIKE oga_file.oga01,
                    oga02    LIKE oga_file.oga02,  
                    oga03    LIKE oga_file.oga03, 
                    ima02    LIKE ima_file.ima02, 
                    ogb03    LIKE ogb_file.ogb03,
                    
                    ogbud02  LIKE ogb_file.ogbud02,  
                    ogb04    LIKE ogb_file.ogb04, 
                    ogb12    LIKE ogb_file.ogb12, 
                    ogb092   LIKE ogb_file.ogb092, 
                    tc_obe04 LIKE tc_obe_file.tc_obe04,

                    oga032   LIKE oga_file.oga032
                    END RECORD
                    
   DEFINE l_cnt     LIKE type_file.num5   
   DEFINE l_tc_obe04    LIKE tc_obe_file.tc_obe04
   DEFINE l_ogb12       LIKE ogb_file.ogb12
   DEFINE l_num1        LIKE type_file.num5
   DEFINE i             LIKE type_file.num5

   DEFINE l_price LIKE ogb_file.ogb13

   DEFINE l_img_blob     LIKE type_file.blob
   LOCATE l_img_blob IN MEMORY             
 

     CALL cl_del_data(l_table) 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='cxmr019' 
 
     LET tm.wc = tm.wc CLIPPED 
     
   #公司全名zo02、公司地址zo041、公司電話zo05、公司傳真zo09
   LET l_zo041 = NULL  LET l_zo05 = NULL  LET l_zo09 = NULL

 
LET l_sql= " select oga01,'','','','',ogbud02,ogb04,sum(ogb12),ogb092,'',''",
           " from ogb_file,oga_file ",
           " WHERE oga01 = ogb01 ", 
           "   AND ",tm.wc CLIPPED,
           "   AND ogaconf != 'X' ", 
           "   GROUP BY oga01,ogb04,ogbud02,ogb092"
    
     PREPARE cxmr019_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF 
    
     DECLARE cxmr019_curs1 CURSOR FOR cxmr019_prepare1
     FOREACH cxmr019_curs1 INTO sr.* 
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     LET l_ogb03 = 1
     SELECT oga02,oga03,oga032
     INTO sr.oga02,sr.oga03,sr.oga032
     FROM oga_file
     WHERE oga01 = sr.oga01 AND ogaconf!='X'

     SELECT ima02 INTO sr.ima02 FROM ima_file WHERE ima01 = sr.ogb04 
     SELECT tc_obe04 INTO l_tc_obe04 FROM tc_obe_file WHERE tc_obe01 = sr.ogb04
     IF cl_null(l_tc_obe04) THEN 
        CALL cl_err('','cxm-030',1)
        EXIT FOREACH
     END IF 
     LET l_num1 = 0
     LET l_ogb12 = sr.ogb12
     IF (sr.ogb12 MOD l_tc_obe04) = 0 THEN
        LET l_num1 = sr.ogb12/l_tc_obe04
     ELSE
        LET l_num1 = (sr.ogb12/l_tc_obe04) + 1 
     END IF 
     IF l_num1 >50 THEN
       EXIT FOREACH
     END IF
     LET i = 1
     FOR i=1 TO l_num1
       LET sr.ogb12 = l_tc_obe04
       LET sr.ogb03 = l_ogb03
       IF (i = l_num1) AND (l_ogb12 MOD l_tc_obe04 != 0) THEN
           LET sr.ogb12 = l_ogb12 MOD l_tc_obe04    
       END IF 
       EXECUTE insert_prep USING sr.*
       LET l_ogb03 = l_ogb03 + 1
     END FOR 
     
     END FOREACH
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'oga01,oga02')
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc

     CALL cl_prt_cs3('cxmr019','cxmr019',g_sql,g_str)

END FUNCTION


