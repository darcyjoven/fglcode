# Prog. Version..:
#
# Pattern name...: csfr004.4gl
# Descriptions...: 产品入库单打印
# Date & Author..: 16/03/03 By yaolf
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
 
   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
  
   LET g_sql="sfq02.sfq_file.sfq02,",
             "ima02_a.ima_file.ima02,",
             "ima021_a.ima_file.ima021,",
             "obk03.obk_file.obk03,",
             "sfb22.sfb_file.sfb22,",
             
             "sfq03.sfq_file.sfq03,",
             "sfp01.sfp_file.sfp01,",
             "sfs02.sfs_file.sfs02,",
             "sfs04.sfs_file.sfs04,",
             "ima02.ima_file.ima02,",
             
             "ima021.ima_file.ima021,",
             "sfa05.sfa_file.sfa05,",
             "sfa06.sfa_file.sfa06,",
             "sfs06.sfs_file.sfs06,",
             "sfs07.sfs_file.sfs07,",
    
             "sfb05.sfb_file.sfb05"
             

   LET  l_table = cl_prt_temptable('csfr004',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"                     
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
   
   IF cl_null(tm.wc)
      THEN CALL csfr004_tm(0,0)          
      ELSE
           CALL csfr004()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION csfr004_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000      
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW csfr004_w AT p_row,p_col WITH FORM "csf/42f/csfr004"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON sfp01,sfp02
                              
     
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
              WHEN INFIELD(sfp01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_sfp01"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfp01
                 NEXT FIELD sfp01
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
      LET INT_FLAG = 0 CLOSE WINDOW csfr004_w 
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
      LET INT_FLAG = 0 CLOSE WINDOW csfr004_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='csfr004'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('csfr004','9031',1)
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
         CALL cl_cmdat('csfr004',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW csfr004_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL csfr004()
   ERROR ""
END WHILE
   CLOSE WINDOW csfr004_w
END FUNCTION


FUNCTION csfr004()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_oea03   LIKE oea_file.oea03, 
          l_sfb05   LIKE sfb_file.sfb05,
          sr        RECORD
                    sfq02    LIKE sfq_file.sfq02,     #生产/委外订单号
                    ima02_a  LIKE ima_file.ima02,     #产品名称
                    ima021_a LIKE ima_file.ima021,    #产品规格
                    obk03    LIKE obk_file.obk03,     #客户编号
                    sfb22    LIKE sfb_file.sfb22,     #销售订单号

                    sfq03    LIKE sfq_file.sfq03,     #生产数量
                    sfp01    LIKE sfp_file.sfp01,     #单据编号
                    sfs02    LIKE sfs_file.sfs02,     #项次
                    sfs04    LIKE sfs_file.sfs04,     #物料料号
                    ima02    LIKE ima_file.ima02,     #物料名称

                    ima021   LIKE ima_file.ima021,    #规格型号
                    sfa05    LIKE sfa_file.sfa05,     #投料数量
                    sfa06    LIKE sfa_file.sfa06,     #已投数量
                    sfs06    LIKE sfs_file.sfs06,     #单位
                    sfs07    LIKE sfs_file.sfs07,     #发料仓库

                    sfb05    LIKE sfb_file.sfb05      #成品编号
                    END RECORD
   DEFINE l_cnt     LIKE type_file.num5            

   DEFINE l_price LIKE ogb_file.ogb13

   DEFINE l_img_blob     LIKE type_file.blob
   LOCATE l_img_blob IN MEMORY             
 

     CALL cl_del_data(l_table) 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='csfr004' 
 
     LET tm.wc = tm.wc CLIPPED 
     
LET l_sql="select sfq02,'','','',sfb22,sfq03,sfp01,sfs02,sfs04,'','',sfa05,sfa06,sfs06,sfs07,sfb05",
           " from sfp_file,sfq_file,sfs_file,sfb_file,sfa_file ",
           " where ",tm.wc ,
           "   AND sfq01=sfp01 ",
           "   AND sfs01=sfq01 ",
           "   AND sfq02=sfb01",
           "   AND sfa01=sfb01",
           "  UNION ",
           "select sfq02,'','','',sfb22,sfq03,sfp01,sfe28,sfe07,'','',sfa05,sfa06,sfe17,sfe08,sfb05",
           " from sfp_file,sfq_file,sfe_file,sfb_file,sfa_file ",
           " where ",tm.wc ,
           "   AND sfq01=sfp01 ",
           "   AND sfe02=sfp01 ",
           "   AND sfq02=sfb01",
           "   AND sfa01=sfb01"
 
     PREPARE csfr004_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE csfr004_curs1 CURSOR FOR csfr004_prepare1
 
     FOREACH csfr004_curs1 INTO sr.*
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     SELECT oea03 INTO l_oea03 FROM oea_file WHERE oea01 = sr.sfb22
     SELECT obk03 INTO sr.obk03 FROM obk_file WHERE obk01 = l_oea03 AND obk02 = l_oea03
     SELECT ima02_a,ima021_a INTO sr.ima02_a,sr.ima021_a FROM ima_file WHERE ima01 = sr.sfs04
     SELECT ima02,ima021 INTO sr.ima02,sr.ima021 FROM ima_file WHERE ima01 = sr.sfb05
     EXECUTE insert_prep USING sr.*
     END FOREACH
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,',sfp01,sfp02')
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc

     CALL cl_prt_cs3('csfr004','csfr004',g_sql,g_str)

END FUNCTION
