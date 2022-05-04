# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: atmg242.4gl
# Descriptions...: 出貨明細表
# Date & Author..: 06/03/20 By jackie
# Modify.........: No.FUN-630056 06/04/18 By wujie   客戶欄位調整
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By bnlent l_time轉g_time
# Modify.........: No.TQC-740129 07/04/24 By sherry 打印結果最后顯示“接下頁”字樣。
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-850152 08/06/12 By ChenMoyan 老報表轉CR
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-A10003 10/04/15 By Summer 將l_table的變數定義成STRING
# Modify.........: No.FUN-CB0074 12/11/16 By lujh  CR轉GR
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      STRING,         # Where condition
              s       LIKE type_file.chr3,            #No.FUN-680120 VARCHAR(3)       # Order by sequence
              t       LIKE type_file.chr3,            #No.FUN-680120 VARCHAR(3)       # Eject sw
              u       LIKE type_file.chr3,            #No.FUN-680120 VARCHAR(3)       # Group total sw
              y       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)       # Input more condition(Y/N)
              c       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)       # PRINT sub Item #No.FUN-5C0075
              more    LIKE type_file.chr1              #No.FUN-680120 VARCHAR(1)       # Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE   g_sma115        LIKE sma_file.sma115   #No.FUN-580004
DEFINE   g_sma116        LIKE sma_file.sma116   #No.FUN-580004
#No.FUN-850152 --Begin
DEFINE   g_str           LIKE type_file.chr1000
DEFINE   #g_sql           LIKE type_file.chr1000
         g_sql,g_sql1    STRING     #NO.FUN-910082
#DEFINE   g_sql1          LIKE type_file.chr1000
DEFINE   l_table         STRING     #No.CHI-A10003 mod LIKE type_file.chr1000-->STRING
DEFINE   l_table1        STRING     #No.CHI-A10003 mod LIKE type_file.chr1000-->STRING
DEFINE   g_sql2     STRING       #FUN-CB0074  add                                                         
DEFINE   g_sql3     STRING       #FUN-CB0074  add
DEFINE   g_sql4     STRING       #FUN-CB0074  add
#No.FUN-850152 --End
###GENGRE###START
TYPE sr1_t RECORD
    order1 LIKE type_file.chr1000,    #FUN-CB0074  add
    order2 LIKE type_file.chr1000,    #FUN-CB0074  add
    order3 LIKE type_file.chr1000,    #FUN-CB0074  add
    oga00 LIKE oga_file.oga00,
    oga01 LIKE oga_file.oga01,
    oga02 LIKE oga_file.oga02,
    oga03 LIKE oga_file.oga03,
    oga04 LIKE oga_file.oga04,
    oga1004 LIKE oga_file.oga1004,
    oga1016 LIKE oga_file.oga1016,
    oga14 LIKE oga_file.oga14,
    oga15 LIKE oga_file.oga15,
    ogb03 LIKE ogb_file.ogb03,
    ogb1005 LIKE ogb_file.ogb1005,
    ogb31 LIKE ogb_file.ogb31,
    ogb04 LIKE ogb_file.ogb04,
    ogb1012 LIKE ogb_file.ogb1012,
    ogb06 LIKE ogb_file.ogb06,
    ogb05 LIKE ogb_file.ogb05,
    ogb13 LIKE ogb_file.ogb13,
    ogb12 LIKE ogb_file.ogb12,
    ogb14 LIKE ogb_file.ogb14,
    oga10 LIKE oga_file.oga10,
    oga23 LIKE oga_file.oga23,
    ogb916 LIKE ogb_file.ogb916,
    ogb917 LIKE ogb_file.ogb917,
    occ02a LIKE occ_file.occ02,
    occ02b LIKE occ_file.occ02,
    occ02c LIKE occ_file.occ02,
    pmc02 LIKE pmc_file.pmc02,
    gen02 LIKE gen_file.gen02,
    gem02 LIKE gem_file.gem02,
    ima021 LIKE ima_file.ima021,
    str2 LIKE type_file.chr1000,
    ogb14_sum_1 LIKE ogb_file.ogb14,   #FUN-CB0074  add
    ogb14_sum_2 LIKE ogb_file.ogb14    #FUN-CB0074  add
          
END RECORD

TYPE sr2_t RECORD
    ogc17 LIKE ogc_file.ogc17,
    ima02 LIKE ima_file.ima02,
    ima021 LIKE ima_file.ima021,
    ogc12 LIKE ogc_file.ogc12,
    oga01 LIKE oga_file.oga01
END RECORD

#FUN-CB0074--add--str--
TYPE sr3_t RECORD
    oga23   LIKE oga_file.oga23,
    ogb1005 LIKE ogb_file.ogb1005,
    ogb14   LIKE ogb_file.ogb14,
    oga01   LIKE oga_file.oga01,
    oga02   LIKE oga_file.oga02,
    oga03   LIKE oga_file.oga03,
    oga04   LIKE oga_file.oga04,
    oga14   LIKE oga_file.oga14,
    oga15   LIKE oga_file.oga15,
    ogb14_sum_1 LIKE ogb_file.ogb14,  
    ogb14_sum_2 LIKE ogb_file.ogb14    
END RECORD 
#FUN-CB0074--add--end--
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
#No.FUN-850152 --Begin
   LET g_sql="order1.type_file.chr1000,",    #FUN-CB0074  add
             "order2.type_file.chr1000,",    #FUN-CB0074  add
             "order3.type_file.chr1000,",    #FUN-CB0074  add
             "oga00.oga_file.oga00,",
             "oga01.oga_file.oga01,",
             "oga02.oga_file.oga02,",
             "oga03.oga_file.oga03,",
             "oga04.oga_file.oga04,",
             "oga1004.oga_file.oga1004,",
             "oga1016.oga_file.oga1016,",
             "oga14.oga_file.oga14,",
             "oga15.oga_file.oga15,",
             "ogb03.ogb_file.ogb03,",
             "ogb1005.ogb_file.ogb1005,",
             "ogb31.ogb_file.ogb31,",
             "ogb04.ogb_file.ogb04,",
             "ogb1012.ogb_file.ogb1012,",
             "ogb06.ogb_file.ogb06,",
             "ogb05.ogb_file.ogb05,",
             "ogb13.ogb_file.ogb13,",
             "ogb12.ogb_file.ogb12,",
             "ogb14.ogb_file.ogb14,",
             "oga10.oga_file.oga10,",
             "oga23.oga_file.oga23,",
             "ogb916.ogb_file.ogb916,",
             "ogb917.ogb_file.ogb917,",
             "occ02a.occ_file.occ02,",
             "occ02b.occ_file.occ02,",
             "occ02c.occ_file.occ02,",
             "pmc02.pmc_file.pmc02,",
             "gen02.gen_file.gen02,",
             "gem02.gem_file.gem02,",
             "ima021.ima_file.ima021,",
             "str2.type_file.chr1000,",
             "ogb14_sum_1.ogb_file.ogb14,",   #FUN-CB0074  add
             "ogb14_sum_2.ogb_file.ogb14"     #FUN-CB0074  add
   LET l_table=cl_prt_temptable('atmg242',g_sql)
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql1="ogc17.ogc_file.ogc17,",
              "ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,",
              "ogc12.ogc_file.ogc12,",
              "oga01.oga_file.oga01"
   LET l_table1=cl_prt_temptable('atmg242_sub',g_sql1)
   IF l_table=-1 THEN EXIT PROGRAM END IF
#No.FUN-850152 --End
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   #No.FUN-570264 --start--
   DROP TABLE curr_tmp
 # No.FUN-680120-BEGIN
   CREATE TEMP TABLE curr_tmp(
     curr  LIKE oga_file.oga23,        #TQC-840066
     amt   LIKE type_file.num20_6,
     type  LIKE type_file.chr1,  
     order1  LIKE bnb_file.bnb06,
     order2  LIKE bnb_file.bnb06,
     order3  LIKE bnb_file.bnb06);
 # No.FUN-680120-END   
 
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL atmg242_tm(0,0)        # Input print condition
      ELSE CALL atmg242()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1)   #FUN-CB0074 add
END MAIN
 
FUNCTION atmg242_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
   DEFINE l_oaz23     LIKE oaz_file.oaz23   
 
   LET p_row = 3 LET p_col = 15
 
   OPEN WINDOW atmg242_w AT p_row,p_col WITH FORM "atm/42f/atmg242"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
   SELECT oaz23 INTO l_oaz23 FROM oaz_file
   IF l_oaz23 = 'N' THEN
      CALL cl_set_comp_visible("c",FALSE)
   END IF
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm2.s1  = '3'
   LET tm2.s2  = '7'
   LET tm2.u1  = 'Y'
   LET tm2.u2  = 'N'
   LET tm2.u3  = 'N'
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
   LET tm.y    = 'N'
   LET tm.c    = 'N'     #No.FUN-5C0075
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oga01,oga02,oga03,oga04,oga14,oga15,oga23,ogb04       #No.FUN-630056
 
       BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
       ON ACTION locale
         LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                  
         EXIT CONSTRUCT
 
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(oga01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_oga8"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga01
                NEXT FIELD oga01
 
              WHEN INFIELD(oga03)       #No.FUN-630056
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_occ"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga03       #No.FUN-630056
                NEXT FIELD oga03       #No.FUN-630056
 
                            
              #FUN-CB0074--add--str--
              WHEN INFIELD(oga23)       
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azi"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga23    
                NEXT FIELD oga23     
              #FUN-CB0074--add--end--  

              WHEN INFIELD(oga04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_occ"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga04
                NEXT FIELD oga04
 
              WHEN INFIELD(oga14)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gen"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga14
                NEXT FIELD oga14
 
              WHEN INFIELD(oga15)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gem"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga15
                NEXT FIELD oga15
 
              WHEN INFIELD(ogb04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ogb04
                NEXT FIELD ogb04
 
           END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
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
      LET INT_FLAG = 0 CLOSE WINDOW atmg242_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)   #FUN-CB0074 add
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more         # Condition
 
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,
                 tm.y,tm.c,tm.more WITHOUT DEFAULTS   
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD y
        IF cl_null(tm.y) OR tm.y NOT MATCHES '[YN]' THEN
           NEXT FIELD y
        END IF
 
      AFTER FIELD c
        IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
           NEXT FIELD c
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
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
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
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW atmg242_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)   #FUN-CB0074 add
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='atmg242'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('atmg242','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.y CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('atmg242',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW atmg242_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)   #FUN-CB0074 add
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL atmg242()
   ERROR ""
END WHILE
   CLOSE WINDOW atmg242_w
END FUNCTION
 
FUNCTION atmg242()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6B0014
          #l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680120 VARCHAR(600)   #FUN-CB0074 mark
          l_sql     STRING,                        #FUN-CB0074 add
          l_chr     LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_za05    LIKE ima_file.ima01,          #No.FUN-680120 VARCHAR(40)
          #l_order   ARRAY[5] OF LIKE oea_file.oea01,    #No.FUN-680120 VARCHAR(16)              #No.FUN-550070     #FUN-CB0074 mark
          l_order   ARRAY[5] OF LIKE type_file.chr1000,    #No.FUN-680120 VARCHAR(16)              #No.FUN-550070   #FUN-CB0074 add
          sr               RECORD order1 LIKE type_file.chr1000,    #FUN-CB0074 add
                                  order2 LIKE type_file.chr1000,    #FUN-CB0074 add
                                  order3 LIKE type_file.chr1000,    #FUN-CB0074 add
                                  #order1 LIKE oea_file.oea01,    #No.FUN-680120 VARCHAR(16)   #FUN-CB0074 mark
                                  #order2 LIKE oea_file.oea01,    #No.FUN-680120 VARCHAR(16)   #FUN-CB0074 mark
                                  #order3 LIKE oea_file.oea01,    #No.FUN-680120 VARCHAR(16)   #FUN-CB0074 mark
                                  oga00 LIKE oga_file.oga00,    #
                                  oga01 LIKE oga_file.oga01,    #
                                  oga02 LIKE oga_file.oga02,
                                  oga03 LIKE oga_file.oga03,       #No.FUN-630056
                                  oga04 LIKE oga_file.oga04,
                                  oga1004 LIKE oga_file.oga1004,
                                  oga1016 LIKE oga_file.oga1016,
                                  oga14 LIKE oga_file.oga14,
                                  oga15 LIKE oga_file.oga15,
                                  ogb03 LIKE ogb_file.ogb03,   #單身項次
                                  ogb1005 LIKE ogb_file.ogb1005, 
                                  ogb31 LIKE ogb_file.ogb31,
                                  ogb04 LIKE ogb_file.ogb04,
                                  ogb1012 LIKE ogb_file.ogb1012,
                                  ogb06 LIKE ogb_file.ogb06,
                                  ogb05 LIKE ogb_file.ogb05,
                                  ogb13 LIKE ogb_file.ogb13,
                                  ogb12 LIKE ogb_file.ogb12,
                                  ogb14 LIKE ogb_file.ogb14,
				  oga10	LIKE oga_file.oga10,
				  azi03	LIKE azi_file.azi03,
				  azi04	LIKE azi_file.azi04,
				  azi05	LIKE azi_file.azi05,
				  oga23 LIKE oga_file.oga23,
				  oga24 LIKE oga_file.oga24,
                                  #No.FUN-580004-begin
				  ogb910 LIKE ogb_file.ogb910,
				  ogb912 LIKE ogb_file.ogb912,
				  ogb913 LIKE ogb_file.ogb913,
				  ogb915 LIKE ogb_file.ogb915,
				  ogb916 LIKE ogb_file.ogb916,
				  ogb917 LIKE ogb_file.ogb917
                                  #No.FUN-580004-end
                        END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5               #No.FUN-580004        #No.FUN-680120 SMALLINT
     DEFINE i                  LIKE type_file.num5               #No.FUN-580004        #No.FUN-680120 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02  #No.FUN-580004
#No.FUN-850152 --Begin
     DEFINE l_occ02a           LIKE occ_file.occ02
     DEFINE l_occ02b           LIKE occ_file.occ02
     DEFINE l_occ02c           LIKE occ_file.occ02
     DEFINE l_gen02            LIKE gen_file.gen02
     DEFINE l_gem02            LIKE gem_file.gem02
     DEFINE l_ima021           LIKE ima_file.ima021
     DEFINE l_str2             LIKE type_file.chr1000
     DEFINE l_ima021_1         LIKE ima_file.ima021
     DEFINE l_ima02_1          LIKE ima_file.ima02
     DEFINE l_pmc02            LIKE pmc_file.pmc02
     DEFINE l_ima906           LIKE ima_file.ima906
     DEFINE l_ogb915           LIKE ogb_file.ogb915
     DEFINE l_ogb912           LIKE ogb_file.ogb912
     DEFINE l_ogb12            LIKE ogb_file.ogb12
     DEFINE l_oaz23            LIKE oaz_file.oaz23
     DEFINE g_ogc              RECORD LIKE ogc_file.*
     DEFINE l_ogb14_1          LIKE ogb_file.ogb14     #FUN-CB0074  add 
     DEFINE l_ogb14_2          LIKE ogb_file.ogb14     #FUN-CB0074  add 
     LET g_sql=" INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"   #FUN-CB0074  add  ?,?,?,?,?
     PREPARE insert_prep FROM g_sql
     LET g_sql1=" INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?)"
     PREPARE insert_prep1 FROM g_sql1
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='atmg242'
#No.FUN-850152 --End
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #FUN-560229
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND ogauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND ogagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND ogagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
     #End:FUN-980030
 
#No.FUN-850152 --Begin
#     DELETE FROM curr_tmp;
 
#        LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 1 小計
#                  "  WHERE order1=? ",
#                  "    AND type='1' ",
#                  "  GROUP BY curr"
#        PREPARE tmp1_pre FROM l_sql
#        IF SQLCA.sqlcode THEN CALL cl_err('pre_1:',SQLCA.sqlcode,1) RETURN END IF
#        DECLARE tmp1_cs CURSOR WITH HOLD FOR tmp1_pre
 
#        LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 1 小計
#                  "  WHERE order1=? ",
#                  "    AND type='2' ",
#                  "  GROUP BY curr"
#        PREPARE tmp5_pre FROM l_sql
#        IF SQLCA.sqlcode THEN CALL cl_err('pre_5:',SQLCA.sqlcode,1) RETURN END IF
#        DECLARE tmp5_cs CURSOR WITH HOLD FOR tmp5_pre
 
#        LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 2 小計
#                  "  WHERE order1=? ",
#                  "  AND   order2=? ",
#                  "  AND type='1' ",
#                  "  GROUP BY curr"
#        PREPARE tmp2_pre FROM l_sql
#        IF SQLCA.sqlcode THEN CALL cl_err('pre_2:',SQLCA.sqlcode,1) RETURN END IF
#        DECLARE tmp2_cs CURSOR WITH HOLD FOR tmp2_pre
 
#        LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 2 小計
#                  "  WHERE order1=? ",
#                  "  AND   order2=? ",
#                  "  AND   type='2' ",
#                  "  GROUP BY curr"
#        PREPARE tmp6_pre FROM l_sql
#        IF SQLCA.sqlcode THEN CALL cl_err('pre_6:',SQLCA.sqlcode,1) RETURN END IF
#        DECLARE tmp6_cs CURSOR WITH HOLD FOR tmp6_pre
 
#        LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 3 小計
#                  "  WHERE order1=? ",
#                  "  AND   order2=? ",
#                  "  AND   order3=? ",
#                  "  AND type='1' ",
#                  "  GROUP BY curr"
#        PREPARE tmp3_pre FROM l_sql
#        IF SQLCA.sqlcode THEN CALL cl_err('pre_1:',SQLCA.sqlcode,1) RETURN END IF
#        DECLARE tmp3_cs CURSOR WITH HOLD FOR tmp3_pre
 
#        LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 3 小計
#                  "  WHERE order1=? ",
#                  "  AND   order2=? ",
#                  "  AND   order3=? ",
#                  "  AND type='2' ",
#                  "  GROUP BY curr"
#        PREPARE tmp7_pre FROM l_sql
#        IF SQLCA.sqlcode THEN CALL cl_err('pre_7:',SQLCA.sqlcode,1) RETURN END IF
#        DECLARE tmp7_cs CURSOR WITH HOLD FOR tmp7_pre
 
#        LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #on last row 總計
#                  " WHERE type='1'",
#              "  GROUP BY curr  "
#        PREPARE tmp4_pre FROM l_sql
#        IF SQLCA.sqlcode THEN CALL cl_err('pre_3:',SQLCA.sqlcode,1) RETURN END IF
#        DECLARE tmp4_cs CURSOR WITH HOLD FOR tmp4_pre
 
#        LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #on last row 總計
#                  " WHERE type='2'",
#              "  GROUP BY curr  "
#        PREPARE tmp8_pre FROM l_sql
#        IF SQLCA.sqlcode THEN CALL cl_err('pre_8:',SQLCA.sqlcode,1) RETURN END IF
#        DECLARE tmp8_cs CURSOR WITH HOLD FOR tmp8_pre
#No.FUN-850152 --End
     LET l_sql = "SELECT '','','',",
                 "       oga00,oga01,oga02,oga03,oga04,oga1004,oga1016,oga14, ",       #No.FUN-630056
		 "       oga15,ogb03,ogb1005,ogb31,ogb04,ogb1012,ogb06,ogb05, ",
		 "       ogb13,ogb12,ogb14,oga10, ",
                 "       azi03,azi04,azi05,oga23,oga24, ",
                 "       ogb910,ogb912,ogb913,ogb915,ogb916,ogb917  ", #No.FUN-580004
                 "  FROM oga_file,OUTER ogb_file,azi_file ",
                 " WHERE oga_file.oga01 = ogb_file.ogb01 ",
                 "   AND oga23 = azi01 ",
                 "   AND oga09 != '1' AND oga09 !='5'", #No.B312 010406
                 "   AND oga09 != '7' AND oga09 !='9'", #No.FUN-610020
                 "   AND ogaconf != 'X' ", #No.B312
                 "   AND ",tm.wc CLIPPED	
     PREPARE atmg242_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM
           
     END IF
     DECLARE atmg242_curs1 CURSOR FOR atmg242_prepare1
 
#No.FUN-850152 --Begin
#    CALL cl_outnam('atmg242') RETURNING l_name
#    IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
#           LET g_zaa[46].zaa06 = "Y"
#           LET g_zaa[49].zaa06 = "Y"
#           LET g_zaa[52].zaa06 = "N"
#           LET g_zaa[53].zaa06 = "N"
#    ELSE
#           LET g_zaa[52].zaa06 = "Y"
#           LET g_zaa[53].zaa06 = "Y"
#           LET g_zaa[46].zaa06 = "N"
#           LET g_zaa[49].zaa06 = "N"
#    END IF
#    IF g_sma115 = "Y" OR g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
#           LET g_zaa[54].zaa06 = "N"
#    ELSE
#           LET g_zaa[54].zaa06 = "Y"
#    END IF
#     CALL cl_prt_pos_len()
 
#    START REPORT atmg242_rep TO l_name
 
#    LET g_pageno = 0
#No.FUN-850152 --End
     FOREACH atmg242_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#FUN-CB0074--unmark--str--
#No.FUN-850152 --Begin
      FOR g_i = 1 TO 3
         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.oga01
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.oga02 USING 'yyyymmdd'
              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.oga03       #No.FUN-630056
              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.oga04
              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.oga14
              WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.oga15
              WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.oga23
              OTHERWISE LET l_order[g_i] = '-'
         END CASE
      END FOR
      LET sr.order1 = l_order[1]
      LET sr.order2 = l_order[2]
      LET sr.order3 = l_order[3]
#No.FUN-850152 --End
#FUN-CB0074--unmark--end--
       IF tm.y='Y' THEN    #將原幣金額轉成本幣金額
          LET sr.oga23=g_aza.aza17            #幣別
          LET sr.ogb14=sr.ogb14 * sr.oga24    #未稅金額*匯率
          LET sr.ogb13=sr.ogb13 * sr.oga24    #No.B512 add by linda 換成本幣
          SELECT azi03,azi04,azi05 INTO sr.azi03,sr.azi04,sr.azi05
           FROM azi_file WHERE azi01 = sr.oga23
       END IF
#No.FUN-850152 --Begin
#      OUTPUT TO REPORT atmg242_rep(sr.*)
      LET l_occ02a = ''                                                                                                             
      LET l_occ02b = ''                                                                                                             
      LET l_occ02c = ''                                                                                                             
      LET l_pmc02 = ''                                                                                                              
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oga14                                                                  
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oga15                                                                  
      SELECT occ02 INTO l_occ02a FROM occ_file WHERE occ01=sr.oga03      
      SELECT occ02 INTO l_occ02b FROM occ_file WHERE occ01=sr.oga04                                                                 
      SELECT occ02 INTO l_occ02c FROM occ_file WHERE occ01=sr.oga1004                                                               
      SELECT pmc02 INTO l_pmc02 FROM pmc_file WHERE pmc01=sr.oga1016
      IF sr.ogb04[1,4] !='MISC' THEN                                                                                                
         SELECT ima021 INTO l_ima021 FROM ima_file                                                                                  
          WHERE ima01 = sr.ogb04                                                                                                    
      ELSE                                                                                                                          
         LET l_ima021 = ''                                                                                                          
      END IF                                                                                                                        
      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file                                                                     
                         WHERE ima01=sr.ogb04                                                                                       
      LET l_str2 = ""                                                                                                               
      IF g_sma115 = "Y" THEN                                                                                                        
         CASE l_ima906                                                                                                              
            WHEN "2"                                                                                                                
                CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915                                                                   
                LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED                                                                           
                IF cl_null(sr.ogb915) OR sr.ogb915 = 0 THEN                                                                         
                    CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912                                                               
                    LET l_str2 = l_ogb912, sr.ogb910 CLIPPED                                                                        
                ELSE                                                                                                                
                   IF NOT cl_null(sr.ogb912) AND sr.ogb912 > 0 THEN                                                                 
                      CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912                                                             
                      LET l_str2 = l_str2 CLIPPED,',',l_ogb912, sr.ogb910 CLIPPED                                                   
                   END IF                                                                                                           
                END IF                                                                                                              
            WHEN "3"
                IF NOT cl_null(sr.ogb915) AND sr.ogb915 > 0 THEN                                                                    
                    CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915                                                               
                    LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED                                                                       
                END IF                                                                                                              
         END CASE                                                                                                                   
      ELSE                                                                                                                          
      END IF                                                                                                                        
      IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076                                                                         
            IF sr.ogb910 <> sr.ogb916 THEN                                                                                          
               CALL cl_remove_zero(sr.ogb12) RETURNING l_ogb12                                                                      
               LET l_str2 = l_str2 CLIPPED,"(",l_ogb12,sr.ogb05 CLIPPED,")"                                                         
            END IF                                                                                                                  
      END IF
      IF l_oaz23 = 'Y' AND tm.c='Y' THEN  
      LET g_sql = "SELECT ogc12,ogc17 ",                                                                                   
                           "  FROM ogc_file",                                                                                       
                           " WHERE ogc01 = '",sr.oga01,"'"                                                                          
            PREPARE ogc_prepare FROM g_sql                                                                                          
            DECLARE ogc_cs CURSOR FOR ogc_prepare                                                                                   
            FOREACH ogc_cs INTO g_ogc.*                                                                                             
               SELECT ima02,ima021 INTO l_ima02_1,l_ima021_1 FROM ima_file                                                              
                WHERE ima01 = g_ogc.ogc17                                                                                           
               EXECUTE insert_prep1 USING g_ogc.ogc17,l_ima02_1,l_ima021_1,g_ogc.ogc12,sr.oga01
            END FOREACH                 
     END IF
     #FUN-CB0074--add--str--
     IF sr.ogb1005 = 1 THEN 
        LET l_ogb14_1 = sr.ogb14
     ELSE
        LET l_ogb14_1 = NULL 
     END IF 
     IF sr.ogb1005 = 2 THEN 
        LET l_ogb14_2 = sr.ogb14
     ELSE
        LET l_ogb14_2 = NULL 
     END IF
    #FUN-CB0074--add--end-- 
     EXECUTE insert_prep USING sr.order1,sr.order2,sr.order3,     #FUN-CB0074  add
                               sr.oga00,sr.oga01,sr.oga02,sr.oga03,sr.oga04,
                               sr.oga1004,sr.oga1016,sr.oga14,sr.oga15,sr.ogb03,
                               sr.ogb1005,sr.ogb31,sr.ogb04,sr.ogb1012,sr.ogb06,
                               sr.ogb05,sr.ogb13,sr.ogb12,sr.ogb14,sr.oga10,
                               sr.oga23,sr.ogb916,sr.ogb917,l_occ02a,l_occ02b,
                               l_occ02c,l_pmc02,l_gen02,l_gem02,l_ima021,
                               l_str2,l_ogb14_1,l_ogb14_2    #FUN-CB0074  add  l_ogb14_1,l_ogb14_2  
#No.FUN-850152 --End
     
     END FOREACH
#No.FUN-850152 --Begin
#    FINISH REPORT atmg242_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'oga01,oga02,oga03,oga04,oga14,oga15,oga23,ogb04')
               RETURNING tm.wc
     ELSE
        LET tm.wc=""
     END IF
###GENGRE###     LET g_str=tm.wc,';',tm.s[1,1],';',tm.s[2,2],';',tm.s[3,3],';',tm.t[1,1],';',
###GENGRE###               tm.t[2,2],';',tm.t[3,3],';',tm.u[1,1],';',tm.u[2,2],';',tm.u[3,3],';',
###GENGRE###               tm.y,';',tm.c
###GENGRE###     LET g_sql=" SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,'|',
###GENGRE###               " SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,'|',
###GENGRE###               " SELECT oga23,ogb1005,ogb14,oga01,oga02,oga03,oga04,oga14,oga15,oga23 FROM ",
###GENGRE###               g_cr_db_str CLIPPED,l_table CLIPPED,'|',
###GENGRE###               " SELECT oga23,ogb1005,ogb14,oga01,oga02,oga03,oga04,oga14,oga15,oga23 FROM ",                                       
###GENGRE###               g_cr_db_str CLIPPED,l_table CLIPPED,'|', 
###GENGRE###               " SELECT oga23,ogb1005,ogb14,oga01,oga02,oga03,oga04,oga14,oga15,oga23 FROM ",                                       
###GENGRE###               g_cr_db_str CLIPPED,l_table CLIPPED,'|', 
###GENGRE###               " SELECT oga23,ogb1005,ogb14,oga01,oga02,oga03,oga04,oga14,oga15,oga23 FROM ",                                       
###GENGRE###               g_cr_db_str CLIPPED,l_table CLIPPED,'|',
###GENGRE###               " SELECT oga23,ogb1005,ogb14,oga01,oga02,oga03,oga04,oga14,oga15,oga23 FROM ",                                       
###GENGRE###               g_cr_db_str CLIPPED,l_table CLIPPED,'|',
###GENGRE###               " SELECT oga23,ogb1005,ogb14,oga01,oga02,oga03,oga04,oga14,oga15,oga23 FROM ",                                       
###GENGRE###               g_cr_db_str CLIPPED,l_table CLIPPED,'|',
###GENGRE###               " SELECT oga23,ogb1005,ogb14,oga01,oga02,oga03,oga04,oga14,oga15,oga23 FROM ",                                       
###GENGRE###               g_cr_db_str CLIPPED,l_table CLIPPED,'|',
###GENGRE###               " SELECT oga23,ogb1005,ogb14,oga01,oga02,oga03,oga04,oga14,oga15,oga23 FROM ",                                       
###GENGRE###               g_cr_db_str CLIPPED,l_table CLIPPED
    IF g_sma.sma116 MATCHES '[23]' THEN
###GENGRE###       CALL cl_prt_cs3('atmg242','atmg242',g_sql,g_str) 
       LET  g_template = 'atmg242'   #FUN-CB0074  add
    ELSE 
       IF g_sma.sma115='Y' THEN
###GENGRE###            CALL cl_prt_cs3('atmg242','atmg242_1',g_sql,g_str)
          LET  g_template = 'atmg242_1'   #FUN-CB0074  add
       ELSE
###GENGRE###            CALL cl_prt_cs3('atmg242','atmg242_2',g_sql,g_str)
          LET  g_template = 'atmg242_2'   #FUN-CB0074  add
       END IF
    END IF
    CALL atmg242_grdata()    ###GENGRE###
#No.FUN-850152 --End
END FUNCTION
 
#No.FUN-850152 --Begin
#REPORT atmg242_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
#         sr               RECORD order1 LIKE oea_file.oea01,      #No.FUN-680120 VARCHAR(16) 
#                                 order2 LIKE oea_file.oea01,      #No.FUN-680120 VARCHAR(16)
#                                 order3 LIKE oea_file.oea01,      #No.FUN-680120 VARCHAR(16)
#                                 oga00 LIKE oga_file.oga00,    #
#                                 oga01 LIKE oga_file.oga01,    #
#                                 oga02 LIKE oga_file.oga02,
#                                 oga03 LIKE oga_file.oga03,       #No.FUN-630056
#                                 oga04 LIKE oga_file.oga04,
#                                 oga1004 LIKE oga_file.oga1004,
#                                 oga1016 LIKE oga_file.oga1016,
#                                 oga14 LIKE oga_file.oga14,
#                                 oga15 LIKE oga_file.oga15,
#                                 ogb03 LIKE ogb_file.ogb03,   #單身項次
#                                 ogb1005 LIKE ogb_file.ogb1005, 
#                                 ogb31 LIKE ogb_file.ogb31,
#                                 ogb04 LIKE ogb_file.ogb04,
#                                 ogb1012 LIKE ogb_file.ogb1012,
#                                 ogb06 LIKE ogb_file.ogb06,
#                                 ogb05 LIKE ogb_file.ogb05,
#                                 ogb13 LIKE ogb_file.ogb13,
#                                 ogb12 LIKE ogb_file.ogb12,
#                                 ogb14 LIKE ogb_file.ogb14,
#       			  oga10	LIKE oga_file.oga10,
#       			  azi03	LIKE azi_file.azi03,
#       			  azi04	LIKE azi_file.azi04,
#       			  azi05	LIKE azi_file.azi05,
#       			  oga23 LIKE oga_file.oga23,
#       			  oga24 LIKE oga_file.oga24,
#                                 #No.FUN-580004-begin
#       			  ogb910 LIKE ogb_file.ogb910,
#       			  ogb912 LIKE ogb_file.ogb912,
#       			  ogb913 LIKE ogb_file.ogb913,
#       			  ogb915 LIKE ogb_file.ogb915,
#       			  ogb916 LIKE ogb_file.ogb916,
#       			  ogb917 LIKE ogb_file.ogb917
#                                 #No.FUN-580004-end
#                       END RECORD,
#     l_amt     LIKE ogb_file.ogb14,
#     l_amt1    LIKE ogb_file.ogb14,
#     l_ima021  LIKE ima_file.ima021,
#     l_occ02   LIKE occ_file.occ02,
#     l_curr    LIKE oga_file.oga23,      #MOD-550164
#     l_gen02   LIKE gen_file.gen02,
#     l_gem02   LIKE gem_file.gem02,
#     l_chr        LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
#     l_ima906     LIKE ima_file.ima906,
#     l_str2       LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(100)
#     l_ogb915     STRING,
#     l_ogb912     STRING,
#     l_ogb12      STRING
#DEFINE
#     g_ogc        RECORD
#                  ogc12 LIKE ogc_file.ogc12,
#                  ogc17 LIKE ogc_file.ogc17
#             END RECORD,
#     l_oaz23  LIKE oaz_file.oaz23,
#     l_ima02  LIKE ima_file.ima02,
#     g_sql    LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
#No.FUN-5C0075--end
#DEFINE   sr1 RECORD
#             curr      LIKE oga_file.oga23,             #No.FUN-680120 VARCHAR(4) #TQC-840066
#             amt       LIKE type_file.num20_6           #No.FUN-680120 DECIMAL(20,6)
#         END RECORD
#DEFINE l_occ02a,l_occ02b,l_occ02c   LIKE occ_file.occ02
#DEFINE l_pmc02   LIKE pmc_file.pmc02
#DEFINE l_stra             STRING
 
#No.FUN-580004-end
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.order1,sr.order2,sr.order3,sr.oga01,sr.ogb03
 
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<','/pageno'
#     PRINT g_head CLIPPED, pageno_total
#     PRINT ''
#
#     IF sr.oga00='6' THEN
#        LET g_zaa[55].zaa08=g_x[11]
#     ELSE
#        IF sr.oga00='7' THEN
#          LET g_zaa[55].zaa08=g_x[12]
#        END IF
#     END IF
#
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31],
#           g_x[32],
#           g_x[33],
#           g_x[34],
#           g_x[35],
#           g_x[36],
#           g_x[37],
#           g_x[38],
#           g_x[39],
#           g_x[40],
#           g_x[41],
#           g_x[42],
#           g_x[43],
#           g_x[44],
#           g_x[45],
#           g_x[46],
#           g_x[47],
#           g_x[48],
#           g_x[49],
#           g_x[50],
#           g_x[51],g_x[52],g_x[53],g_x[54],
#           g_x[55],g_x[56],g_x[57],g_x[58]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#  BEFORE GROUP OF sr.order2
#     IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#  BEFORE GROUP OF sr.order3
#     IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#  BEFORE GROUP OF sr.oga01
#     LET l_occ02a = ''
#     LET l_occ02b = ''
#     LET l_occ02c = ''
#     LET l_pmc02 = ''
#     SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oga14
#     SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oga15
#     SELECT occ02 INTO l_occ02a FROM occ_file WHERE occ01=sr.oga03       #No.FUN-630056
#     SELECT occ02 INTO l_occ02b FROM occ_file WHERE occ01=sr.oga04    
#     SELECT occ02 INTO l_occ02c FROM occ_file WHERE occ01=sr.oga1004
#     SELECT pmc02 INTO l_pmc02 FROM pmc_file WHERE pmc01=sr.oga1016
 
#     PRINT COLUMN  g_c[31],sr.oga01,
#           COLUMN  g_c[32],sr.oga02,
#           COLUMN  g_c[33],sr.oga03,       #No.FUN-630056
#           COLUMN  g_c[34],l_occ02a,
#           COLUMN  g_c[35],sr.oga04,
#           COLUMN  g_c[36],l_occ02b;
#     IF sr.oga00='6' THEN
#        PRINT COLUMN g_c[55],sr.oga1004,
#              COLUMN g_c[56],l_occ02c;
#     ELSE
#        IF sr.oga00='7' THEN
#           PRINT COLUMN g_c[55],sr.oga1016,
#                 COLUMN g_c[56],l_pmc02;
#        END IF
#     END IF
#     PRINT COLUMN  g_c[37],sr.oga14,
#           COLUMN  g_c[38],l_gen02,
#           COLUMN  g_c[39],sr.oga15,
#           COLUMN  g_c[40],l_gem02;
 
#  ON EVERY ROW
#     IF sr.ogb04[1,4] !='MISC' THEN
#        SELECT ima021 INTO l_ima021 FROM ima_file
#         WHERE ima01 = sr.ogb04
#     ELSE
#        LET l_ima021 = ''
#     END IF
#     SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
#                        WHERE ima01=sr.ogb04
#     LET l_str2 = ""
#     IF g_sma115 = "Y" THEN
#        CASE l_ima906
#           WHEN "2"
#               CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
#               LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
#               IF cl_null(sr.ogb915) OR sr.ogb915 = 0 THEN
#                   CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
#                   LET l_str2 = l_ogb912, sr.ogb910 CLIPPED
#               ELSE
#                  IF NOT cl_null(sr.ogb912) AND sr.ogb912 > 0 THEN
#                     CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
#                     LET l_str2 = l_str2 CLIPPED,',',l_ogb912, sr.ogb910 CLIPPED
#                  END IF
#               END IF
#           WHEN "3"
#               IF NOT cl_null(sr.ogb915) AND sr.ogb915 > 0 THEN
#                   CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
#                   LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
#               END IF
#        END CASE
#     ELSE
#     END IF
#     IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
#           IF sr.ogb910 <> sr.ogb916 THEN
#              CALL cl_remove_zero(sr.ogb12) RETURNING l_ogb12
#              LET l_str2 = l_str2 CLIPPED,"(",l_ogb12,sr.ogb05 CLIPPED,")"
#           END IF
#     END IF
 
#     IF sr.ogb1005='1' THEN 
#        LET l_stra=sr.ogb1005,':',g_x[15] CLIPPED
#     ELSE
#        LET l_stra=sr.ogb1005,':',g_x[16] CLIPPED
#     END IF
 
#     PRINT COLUMN  g_c[41],sr.ogb03 USING '###&',
#           COLUMN  g_c[58],l_stra,
#           COLUMN  g_c[42],sr.ogb31,
#	    COLUMN  g_c[43],sr.ogb04,
#           COLUMN  g_c[57],sr.ogb1012,
#	    COLUMN  g_c[44],sr.ogb06,
#	    COLUMN  g_c[45],l_ima021,
#           COLUMN  g_c[54],l_str2 CLIPPED,  #No.FUN-580004
#           COLUMN  g_c[46],sr.ogb05,
#           COLUMN  g_c[47],sr.oga23,
#           COLUMN  g_c[48],cl_numfor(sr.ogb13,48,sr.azi03),
#           COLUMN  g_c[49],sr.ogb12 USING '############.##',
#           COLUMN  g_c[52],sr.ogb916 CLIPPED,  #No.FUN-580004
#           COLUMN  g_c[53],cl_numfor(sr.ogb917,53,3),  #No.FUN-580004
#           COLUMN  g_c[50],cl_numfor(sr.ogb14,50,sr.azi04), #MOD-490092放大未稅金額寬度
#           COLUMN  g_c[51],sr.oga10
#           SELECT oaz23 INTO l_oaz23 FROM oaz_file
#           IF l_oaz23 = 'Y' AND tm.c='Y' THEN
#           IF tm.c='Y' THEN
#              LET g_sql = "SELECT ogc12,ogc17 ",
#                          "  FROM ogc_file",
#                          " WHERE ogc01 = '",sr.oga01,"'"
#           PREPARE ogc_prepare FROM g_sql
#           DECLARE ogc_cs CURSOR FOR ogc_prepare
#           FOREACH ogc_cs INTO g_ogc.*
#              SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
#               WHERE ima01 = g_ogc.ogc17
#              PRINT COLUMN g_c[43],g_ogc.ogc17,
#                    COLUMN g_c[44],l_ima02,
#                    COLUMN g_c[45],l_ima021,
#                    COLUMN g_c[53],g_ogc.ogc12 USING '##########&.###'
#           END FOREACH
#           END IF
 
#     INSERT INTO curr_tmp VALUES(sr.oga23,sr.ogb14,sr.ogb1005,sr.order1,
#                                 sr.order2,sr.order3)
#    #IF STATUS THEN CALL cl_err('ins tmp:',STATUS,1) END IF   #No.FUN-660104
#     IF STATUS THEN CALL cl_err3("ins","curr_tmp","","",STATUS,"","",1) END IF  #No.FUN-660104
 
#
#  AFTER GROUP OF sr.oga01
#      #LET g_pageno = 0 # MOD-580110 MARK
#     LET l_amt = GROUP SUM(sr.ogb14) WHERE sr.ogb1005='1'
#     LET l_amt1= GROUP SUM(sr.ogb14) WHERE sr.ogb1005='2'
#     PRINT COLUMN g_c[52],g_x[09] CLIPPED,
#           COLUMN g_c[50],cl_numfor(l_amt,50,sr.azi05) CLIPPED
#     PRINT COLUMN g_c[52],g_x[13] CLIPPED,
#           COLUMN g_c[50],cl_numfor(l_amt1,50,sr.azi05) CLIPPED
#     PRINT ''
#
#
#  AFTER GROUP OF sr.order1
#     IF tm.u[1,1] = 'Y' THEN
#        IF tm.y ='Y' THEN
#           LET l_amt = GROUP SUM(sr.ogb14) WHERE sr.ogb1005='1'
#           LET l_amt1= GROUP SUM(sr.ogb14) WHERE sr.ogb1005='2'
#           PRINT COLUMN g_c[52],g_x[09] CLIPPED,
#                 COLUMN g_c[46],g_x[09] CLIPPED,
#           COLUMN g_c[49],sr.oga23 CLIPPED,
#           COLUMN g_c[53],sr.oga23 CLIPPED,
#           COLUMN g_c[50],cl_numfor(l_amt,50,sr.azi05) CLIPPED
#           PRINT COLUMN g_c[52],g_x[13] CLIPPED,
#                 COLUMN g_c[46],g_x[13] CLIPPED,
#           COLUMN g_c[49],sr.oga23 CLIPPED,
#           COLUMN g_c[53],sr.oga23 CLIPPED,
#           COLUMN g_c[50],cl_numfor(l_amt1,50,sr.azi05) CLIPPED
#        ELSE
#           PRINT COLUMN g_c[52],g_x[09] CLIPPED;
#           PRINT COLUMN g_c[46],g_x[09] CLIPPED;
#           FOREACH tmp1_cs USING sr.order1 INTO sr1.*
#           LET l_curr = sr1.curr CLIPPED
#           PRINT  COLUMN g_c[53],l_curr CLIPPED,
#                  COLUMN g_c[49],l_curr CLIPPED,
#                  COLUMN g_c[50],cl_numfor(sr1.amt,50,sr.azi05) CLIPPED
#           END FOREACH
 
#           PRINT COLUMN g_c[52],g_x[13] CLIPPED;
#           PRINT COLUMN g_c[46],g_x[13] CLIPPED;
#           FOREACH tmp5_cs USING sr.order1 INTO sr1.*
#           LET l_curr = sr1.curr CLIPPED
#           PRINT  COLUMN g_c[53],l_curr CLIPPED,
#                  COLUMN g_c[49],l_curr CLIPPED,
#                  COLUMN g_c[50],cl_numfor(sr1.amt,50,sr.azi05) CLIPPED
#           END FOREACH
#        END IF
#        PRINT g_dash2[1,g_len]
#     END IF
 
#  AFTER GROUP OF sr.order2
#       IF tm.u[2,2] = 'Y' THEN
#          IF tm.y ='Y' THEN
#             LET l_amt = GROUP SUM(sr.ogb14) WHERE sr.ogb1005='1'
#             LET l_amt1= GROUP SUM(sr.ogb14) WHERE sr.ogb1005='2'
#             PRINT COLUMN g_c[52],g_x[09] CLIPPED,
#                   COLUMN g_c[46],g_x[09] CLIPPED,
#                   COLUMN g_c[49],sr.oga23 CLIPPED,
#                   COLUMN g_c[53],sr.oga23 CLIPPED,
#                   COLUMN g_c[50],cl_numfor(l_amt,50,sr.azi05) CLIPPED
#             PRINT COLUMN g_c[52],g_x[13] CLIPPED,
#                   COLUMN g_c[46],g_x[09] CLIPPED,
#                   COLUMN g_c[49],sr.oga23 CLIPPED,
#                   COLUMN g_c[53],sr.oga23 CLIPPED,
#                   COLUMN g_c[50],cl_numfor(l_amt1,50,sr.azi05) CLIPPED
#          ELSE
#             PRINT COLUMN g_c[52],g_x[09] CLIPPED;
#             PRINT COLUMN g_c[46],g_x[09] CLIPPED;
#             FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*
#                LET l_curr = sr1.curr CLIPPED
#                PRINT  COLUMN g_c[53],l_curr CLIPPED,
#                       COLUMN g_c[49],l_curr CLIPPED,
#                      COLUMN g_c[50],cl_numfor(sr1.amt,50,sr.azi05) CLIPPED
#             END FOREACH
 
#             PRINT COLUMN g_c[52],g_x[13] CLIPPED;
#             PRINT COLUMN g_c[46],g_x[13] CLIPPED;
#             FOREACH tmp6_cs USING sr.order1,sr.order2 INTO sr1.*
#                LET l_curr = sr1.curr CLIPPED
#                PRINT COLUMN g_c[53],l_curr CLIPPED,
#                      COLUMN g_c[49],l_curr CLIPPED,
#                      COLUMN g_c[50],cl_numfor(sr1.amt,50,sr.azi05) CLIPPED
#             END FOREACH
#          END IF
#          PRINT g_dash2[1,g_len]
#       END IF
 
#  AFTER GROUP OF sr.order3
#      IF tm.u[3,3] = 'Y' THEN
#         IF tm.y ='Y' THEN
#            LET l_amt = GROUP SUM(sr.ogb14) WHERE sr.ogb1005='1'
#            LET l_amt1= GROUP SUM(sr.ogb14) WHERE sr.ogb1005='2'
#            PRINT COLUMN g_c[52],g_x[09] CLIPPED,
#                  COLUMN g_c[46],g_x[09] CLIPPED,
#                  COLUMN g_c[49],sr.oga23 CLIPPED,
#                  COLUMN g_c[53],sr.oga23 CLIPPED,
#                  COLUMN g_c[50],cl_numfor(l_amt,50,sr.azi05) CLIPPED
#            PRINT COLUMN g_c[52],g_x[13] CLIPPED,
#                  COLUMN g_c[46],g_x[13] CLIPPED,
#                  COLUMN g_c[49],sr.oga23 CLIPPED,
#                  COLUMN g_c[53],sr.oga23 CLIPPED,
#                  COLUMN g_c[50],cl_numfor(l_amt1,50,sr.azi05) CLIPPED
#         ELSE
#            PRINT COLUMN g_c[52],g_x[09] CLIPPED;
#            PRINT COLUMN g_c[46],g_x[09] CLIPPED;
#            FOREACH tmp3_cs USING sr.order1,sr.order2,sr.order3 INTO sr1.*
#               LET l_curr = sr1.curr CLIPPED
#               PRINT  COLUMN g_c[53],l_curr CLIPPED,
#                      COLUMN g_c[49],l_curr CLIPPED,
#                     COLUMN g_c[50],cl_numfor(sr1.amt,50,sr.azi05) CLIPPED
#            END FOREACH
 
#            PRINT COLUMN g_c[52],g_x[13] CLIPPED;
#            PRINT COLUMN g_c[46],g_x[13] CLIPPED;
#            FOREACH tmp7_cs USING sr.order1,sr.order2,sr.order3 INTO sr1.*
#               LET l_curr = sr1.curr CLIPPED
#               PRINT  COLUMN g_c[53],l_curr CLIPPED,
#                      COLUMN g_c[49],l_curr CLIPPED,
#                     COLUMN g_c[50],cl_numfor(sr1.amt,50,sr.azi05) CLIPPED
#            END FOREACH
#         END IF
#         PRINT g_dash2[1,g_len]
#      END IF
 
#  ON LAST ROW
#     IF tm.y ='Y' THEN
#        LET l_amt = SUM(sr.ogb14) WHERE sr.ogb1005='1'
#        LET l_amt1= SUM(sr.ogb14) WHERE sr.ogb1005='2'
#        PRINT COLUMN g_c[52],g_x[10] CLIPPED,
#              COLUMN g_c[46],g_x[10] CLIPPED,
#              COLUMN g_c[49],sr.oga23 CLIPPED,
#              COLUMN g_c[53],sr.oga23 CLIPPED,
#              COLUMN g_c[50],cl_numfor(l_amt,50,sr.azi05) CLIPPED
#        PRINT COLUMN g_c[52],g_x[14] CLIPPED,
#              COLUMN g_c[46],g_x[14] CLIPPED,
#              COLUMN g_c[49],sr.oga23 CLIPPED,
#              COLUMN g_c[53],sr.oga23 CLIPPED,
#              COLUMN g_c[50],cl_numfor(l_amt1,50,sr.azi05) CLIPPED
#        ELSE
#           PRINT COLUMN g_c[52],g_x[10] CLIPPED;
#           PRINT COLUMN g_c[46],g_x[10] CLIPPED;
#           FOREACH tmp4_cs INTO sr1.*
#              LET l_curr = sr1.curr CLIPPED,':'
#              PRINT  COLUMN g_c[53],l_curr CLIPPED,
#                     COLUMN g_c[49],l_curr CLIPPED,
#                    COLUMN g_c[50],cl_numfor(sr1.amt,50,sr.azi05) CLIPPED
#           END FOREACH
 
#           PRINT COLUMN g_c[52],g_x[14] CLIPPED;
#           PRINT COLUMN g_c[46],g_x[14] CLIPPED;
#           FOREACH tmp8_cs INTO sr1.*
#              LET l_curr = sr1.curr CLIPPED,':'
#              PRINT  COLUMN g_c[53],l_curr CLIPPED,
#                     COLUMN g_c[49],l_curr CLIPPED,
#                    COLUMN g_c[50],cl_numfor(sr1.amt,50,sr.azi05) CLIPPED
#           END FOREACH
#        END IF
#     IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#        CALL cl_wcchp(tm.wc,'oga01,oga02,oga03,oga04,oga14,oga15')       #No.FUN-630056
#             RETURNING tm.wc
#        PRINT g_dash[1,g_len]
#        #TQC-630166
#        #     IF tm.wc[001,070] > ' ' THEN            # for 80
#        #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#        #     IF tm.wc[071,140] > ' ' THEN
#        #PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#        #     IF tm.wc[141,210] > ' ' THEN
#        #PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#        #     IF tm.wc[211,280] > ' ' THEN
#        #PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#        CALL cl_prt_pos_wc(tm.wc)
#        #END TQC-630166
 
#     END IF
#     PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.FUN-580004
#     LET l_last_sw = 'y'    #No.TQC-740129     
 
#  PAGE TRAILER
#     IF l_last_sw = 'n' THEN
#        PRINT g_dash[1,g_len]
#        PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#     ELSE
#        SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-850152 --End


###GENGRE###START
FUNCTION atmg242_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    #FUN-CB0074--add--str--
    LET g_sql2 = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " WHERE order1=?"
    DECLARE atmg242_repcur01 CURSOR FROM g_sql2
    LET g_sql3 = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " WHERE order1=? AND order2=?"
    DECLARE atmg242_repcur02 CURSOR FROM g_sql3
    LET g_sql4 = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " WHERE order1=? AND order2=? AND order3=?"
    DECLARE atmg242_repcur03 CURSOR FROM g_sql4
    #FUN-CB0074--add--end--

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("atmg242")
        IF handler IS NOT NULL THEN
            START REPORT atmg242_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY order1,order2,order3,oga01"   #FUN-CB0074  add
          
            DECLARE atmg242_datacur1 CURSOR FROM l_sql
            FOREACH atmg242_datacur1 INTO sr1.*
                OUTPUT TO REPORT atmg242_rep(sr1.*)
            END FOREACH
            FINISH REPORT atmg242_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT atmg242_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t       #FUN-CB0074  add
    DEFINE l_sql  STRING   #FUN-CB0074  add
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_ogb14_1_sum LIKE ogb_file.ogb14
    #FUN-CB0074--add--str--
    DEFINE l_x1   LIKE type_file.chr20   
    DEFINE l_x2   LIKE type_file.chr20  
    DEFINE l_x3   LIKE type_file.chr20
    DEFINE l_x4   LIKE type_file.chr20    
    DEFINE l_msg  LIKE type_file.chr100 
    DEFINE l_ogb14_sum_1 LIKE ogb_file.ogb14
    DEFINE l_ogb14_sum_2 LIKE ogb_file.ogb14
    DEFINE l_ogb14_sum_3 LIKE ogb_file.ogb14
    DEFINE l_ogb14_sum_4 LIKE ogb_file.ogb14
    DEFINE l_ogb14_sum_5 LIKE ogb_file.ogb14
    DEFINE l_ogb14_sum_6 LIKE ogb_file.ogb14
    DEFINE l_ogb14_sum_7 LIKE ogb_file.ogb14
    DEFINE l_ogb14_sum_8 LIKE ogb_file.ogb14
    DEFINE l_ogb14_tot_1 LIKE ogb_file.ogb14
    DEFINE l_ogb14_tot_2 LIKE ogb_file.ogb14
    DEFINE l_display_1   LIKE type_file.chr1
    DEFINE l_display_2   LIKE type_file.chr1
    DEFINE l_display_3   LIKE type_file.chr1
    DEFINE l_display_4   LIKE type_file.chr1
    DEFINE l_display_5   LIKE type_file.chr1
    DEFINE l_display_6   LIKE type_file.chr1
    DEFINE l_display_7   LIKE type_file.chr1
    DEFINE l_display_8   LIKE type_file.chr1
    DEFINE l_display_9   LIKE type_file.chr1
    DEFINE l_display_10  LIKE type_file.chr1
    DEFINE l_display_11  LIKE type_file.chr1
    DEFINE l_display_12  LIKE type_file.chr1
    DEFINE l_display_13  LIKE type_file.chr1
    DEFINE l_display_14  LIKE type_file.chr1
    DEFINE l_display_15  LIKE type_file.chr1
    DEFINE l_display_16  LIKE type_file.chr1
    DEFINE l_display_17  LIKE type_file.chr1
    DEFINE l_display_18  LIKE type_file.chr1
    DEFINE l_display_19  LIKE type_file.chr1
    DEFINE l_skip_ord1   LIKE type_file.chr1 
    DEFINE l_skip_ord2   LIKE type_file.chr1  
    DEFINE l_skip_ord3   LIKE type_file.chr1  
    DEFINE l_ord1_show   LIKE type_file.chr1
    DEFINE l_ord2_show   LIKE type_file.chr1
    DEFINE l_ord3_show   LIKE type_file.chr1
    DEFINE l_cnt1        LIKE type_file.num10
    DEFINE l_cnt2        LIKE type_file.num10
    DEFINE l_cnt3        LIKE type_file.num10
    DEFINE l_ord1_cnt    LIKE type_file.num10
    DEFINE l_ord2_cnt    LIKE type_file.num10
    DEFINE l_ord3_cnt    LIKE type_file.num10
    DEFINE l_ord1_skip     STRING
    DEFINE l_ord2_skip     STRING
    DEFINE l_ord3_skip     STRING
    DEFINE l_cnt         LIKE type_file.num10  
    DEFINE l_cnt_tot     LIKE type_file.num10  
    #FUN-CB0074--add--end--
    

    
    ORDER EXTERNAL BY sr1.order1,sr1.order2,sr1.order3,sr1.oga01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
              
            LET l_ord1_skip = tm.t[1]
            LET l_ord2_skip = tm.t[2]
            LET l_ord3_skip = tm.t[3]
            IF l_ord1_skip = 'N' THEN
               IF l_ord2_skip = 'Y' OR l_ord3_skip = 'Y' THEN
                  LET l_ord1_skip = 'Y'
               END IF
            END IF
            PRINTX l_ord1_skip,l_ord2_skip,l_ord3_skip
            LET l_ord1_show = tm.u[1]
            LET l_ord2_show = tm.u[2]
            LET l_ord3_show = tm.u[3]
            PRINTX l_ord1_show,l_ord2_show,l_ord3_show
            
            LET l_cnt_tot = 0
            LET l_cnt = 0
            LET l_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY order1,order2,order3,oga01"
            DECLARE atmg242_cur CURSOR FROM l_sql
            FOREACH atmg242_cur INTO l_cnt END FOREACH

        BEFORE GROUP OF sr1.order1
            LET l_lineno = 0
            FOREACH atmg242_repcur01 USING sr1.order1 INTO l_cnt1 END FOREACH
            LET l_ord1_cnt = 0

        BEFORE GROUP OF sr1.order2
            FOREACH atmg242_repcur02 USING sr1.order1,sr1.order2 INTO l_cnt2 END FOREACH
            LET l_ord2_cnt = 0

        BEFORE GROUP OF sr1.order3
            FOREACH atmg242_repcur03 USING sr1.order1,sr1.order2,sr1.order3 INTO l_cnt3 END FOREACH
            LET l_ord3_cnt = 0
        
        ON EVERY ROW
            LET l_ord3_cnt = l_ord3_cnt + 1
            LET l_ord2_cnt = l_ord2_cnt + 1
            LET l_ord1_cnt = l_ord1_cnt + 1
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-CB0074--add--str--
            LET l_cnt_tot = l_cnt_tot + 1
            IF sr1.oga00 = '6' THEN 
               LET l_x1 = sr1.oga1004
               LET l_x2 = sr1.occ02c
            END IF 
            IF sr1.oga00 = '7' THEN 
               LET l_x1 = sr1.oga1016
               LET l_x2 = sr1.pmc02
            END IF 
            PRINTX l_x1
            PRINTX l_x2

            LET l_msg = cl_gr_getmsg("gre-314",g_lang,sr1.ogb1005)
            LET l_x3 = sr1.ogb1005,l_msg
            PRINTX l_x3

            IF tm.y = 'Y' AND tm.c = 'Y' THEN 
               LET l_display_1 = 'Y'
            END IF 
            PRINTX l_display_1

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
            START REPORT atmg242_subrep01
            DECLARE atmg242_repcur1 CURSOR FROM l_sql
            FOREACH atmg242_repcur1 INTO sr2.*
                OUTPUT TO REPORT atmg242_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT atmg242_subrep01
            #FUN-CB0074--add--end--

            PRINTX sr1.*

        AFTER GROUP OF sr1.oga01
        #FUN-CB0074--add--str--    
            
            LET l_ogb14_sum_1 = GROUP SUM(sr1.ogb14_sum_1)
            IF NOT cl_null(l_ogb14_sum_1) THEN 
               LET l_display_10 = 'Y' 
            ELSE
               LET l_display_10 = 'N' 
            END IF 
            PRINTX l_ogb14_sum_1
            PRINTX l_display_10
            
            LET l_ogb14_sum_2 = GROUP SUM(sr1.ogb14_sum_2)
            IF NOT cl_null(l_ogb14_sum_2) THEN 
               LET l_display_11 = 'Y' 
            ELSE
               LET l_display_11 = 'N' 
            END IF 
            PRINTX l_ogb14_sum_2
            PRINTX l_display_11

        AFTER GROUP OF sr1.order3     
            IF l_ord2_cnt = l_cnt2 OR l_ord1_cnt = l_cnt1 THEN
               LET l_skip_ord3 = 'Y'
            ELSE
               LET l_skip_ord3 = 'N'
            END IF
            PRINTX l_skip_ord3
        
            LET l_ogb14_sum_3 = GROUP SUM(sr1.ogb14_sum_1)
            IF l_ord3_show = 'Y' AND tm.y = 'Y' AND NOT cl_null(l_ogb14_sum_3) THEN 
               LET l_display_12 = 'Y' 
            ELSE
               LET l_display_12 = 'N' 
            END IF 
            PRINTX l_ogb14_sum_3
            PRINTX l_display_12
            
            LET l_ogb14_sum_4 = GROUP SUM(sr1.ogb14_sum_2)
            IF l_ord3_show = 'Y' AND tm.y = 'Y' AND NOT cl_null(l_ogb14_sum_4) THEN 
               LET l_display_13 = 'Y' 
            ELSE
               LET l_display_13 = 'N'
            END IF
            PRINTX l_ogb14_sum_4
            PRINTX l_display_13

            IF l_ord3_show = 'Y' AND tm.y <> 'Y' THEN 
               LET l_display_2 = 'Y' 
            ELSE
               LET l_display_2 = 'N'    
            END IF 
            PRINTX l_display_2

            LET l_sql = "SELECT oga23,ogb1005,ogb14,oga01,oga02,ogb03,ogb04,ogb14,oga15, ",
                        " ogb14_sum_1,ogb14_sum_2 ",
                        " FROM ",g_cr_db_str CLIPPED,l_table, 
                        " WHERE order1 = '",sr1.order1,"'",
                        "   AND order2 = '",sr1.order2,"'",
                        "   AND order3 = '",sr1.order3,"'"
            START REPORT atmg242_subrep02
            DECLARE atmg242_repcur2 CURSOR FROM l_sql
            FOREACH atmg242_repcur2 INTO sr3.*
                OUTPUT TO REPORT atmg242_subrep02(sr3.*)
            END FOREACH
            FINISH REPORT atmg242_subrep02

            IF l_ord3_show = 'Y' AND tm.y <> 'Y' THEN 
               LET l_display_6 = 'Y'  
            ELSE
               LET l_display_6 = 'N'    
            END IF 
            PRINTX l_display_6
            
            START REPORT atmg242_subrep06
            DECLARE atmg242_repcur3 CURSOR FROM l_sql
            FOREACH atmg242_repcur3 INTO sr3.*
                OUTPUT TO REPORT atmg242_subrep06(sr3.*)
            END FOREACH
            FINISH REPORT atmg242_subrep06
            
        AFTER GROUP OF sr1.order2            
            IF l_ord1_cnt = l_cnt1 THEN 
               LET l_skip_ord2 = 'Y'
            ELSE
               LET l_skip_ord2 = 'N'
            END IF
            PRINTX l_skip_ord2
      
            LET l_ogb14_sum_5 = GROUP SUM(sr1.ogb14_sum_1)
            IF l_ord2_show = 'Y' AND tm.y = 'Y' AND NOT cl_null(l_ogb14_sum_5) THEN 
               LET l_display_14 = 'Y' 
            ELSE
               LET l_display_14 = 'N' 
            END IF
            PRINTX l_ogb14_sum_5
            PRINTX l_display_14

            LET l_ogb14_sum_6 = GROUP SUM(sr1.ogb14_sum_2)
            IF l_ord2_show = 'Y' AND tm.y = 'Y' AND NOT cl_null(l_ogb14_sum_6) THEN 
               LET l_display_15 = 'Y' 
            ELSE
               LET l_display_15 = 'N' 
            END IF
            PRINTX l_ogb14_sum_6
            PRINTX l_display_15

            IF l_ord2_show = 'Y' AND tm.y <> 'Y' THEN 
               LET l_display_3 = 'Y'  
            ELSE
               LET l_display_3 = 'N'     
            END IF 
            PRINTX l_display_3
            
            LET l_sql = "SELECT oga23,ogb1005,ogb14,oga01,oga02,ogb03,ogb04,ogb14,oga15, ",
                        " ogb14_sum_1,ogb14_sum_2 ",
                        " FROM ",g_cr_db_str CLIPPED,l_table, 
                        " WHERE order1 = '",sr1.order1,"'",
                        "   AND order2 = '",sr1.order2,"'",
                        "   AND order3 = '",sr1.order3,"'"
            START REPORT atmg242_subrep03
            DECLARE atmg242_repcur4 CURSOR FROM l_sql
            FOREACH atmg242_repcur4 INTO sr3.*
                OUTPUT TO REPORT atmg242_subrep03(sr3.*)
            END FOREACH
            FINISH REPORT atmg242_subrep03

            IF l_ord2_show = 'Y' AND tm.y <> 'Y' THEN 
               LET l_display_7 = 'Y'  
            ELSE
               LET l_display_7 = 'N'   
            END IF 
            PRINTX l_display_7
            
            START REPORT atmg242_subrep07
            DECLARE atmg242_repcur5 CURSOR FROM l_sql
            FOREACH atmg242_repcur5 INTO sr3.*
                OUTPUT TO REPORT atmg242_subrep07(sr3.*)
            END FOREACH
            FINISH REPORT atmg242_subrep07
            
        AFTER GROUP OF sr1.order1
            LET l_skip_ord1 = 'N'
            IF l_cnt = l_cnt_tot THEN LET l_skip_ord1 = 'Y' END IF
            PRINTX l_skip_ord1
            
            PRINTX l_x4

            LET l_ogb14_sum_7 = GROUP SUM(sr1.ogb14_sum_1)
            IF l_ord1_show = 'Y' AND tm.y = 'Y' AND NOT cl_null(l_ogb14_sum_7) THEN 
               LET l_display_16 = 'Y' 
            ELSE
               LET l_display_16 = 'N' 
            END IF
            PRINTX l_ogb14_sum_7
            PRINTX l_display_16

            LET l_ogb14_sum_8 = GROUP SUM(sr1.ogb14_sum_2)
            IF l_ord1_show = 'Y' AND tm.y = 'Y' AND NOT cl_null(l_ogb14_sum_8) THEN 
               LET l_display_17 = 'Y' 
            ELSE
               LET l_display_17 = 'N' 
            END IF
            PRINTX l_ogb14_sum_8
            PRINTX l_display_17

            IF l_ord1_show = 'Y' AND tm.y <> 'Y' THEN 
               LET l_display_4 = 'Y'  
            ELSE
               LET l_display_4 = 'N'   
            END IF 
            PRINTX l_display_4
            
            LET l_sql = "SELECT oga23,ogb1005,ogb14,oga01,oga02,ogb03,ogb04,ogb14,oga15, ",
                        " ogb14_sum_1,ogb14_sum_2 ",
                        " FROM ",g_cr_db_str CLIPPED,l_table, 
                        " WHERE order1 = '",sr1.order1,"'",
                        "   AND order2 = '",sr1.order2,"'",
                        "   AND order3 = '",sr1.order3,"'"
            START REPORT atmg242_subrep04
            DECLARE atmg242_repcur6 CURSOR FROM l_sql
            FOREACH atmg242_repcur6 INTO sr3.*
                OUTPUT TO REPORT atmg242_subrep04(sr3.*)
            END FOREACH
            FINISH REPORT atmg242_subrep04

            IF l_ord1_show = 'Y' AND tm.y <> 'Y' THEN 
               LET l_display_8 = 'Y'    
            ELSE
               LET l_display_8 = 'N'    
            END IF 
            PRINTX l_display_8
            
            START REPORT atmg242_subrep08
            DECLARE atmg242_repcur7 CURSOR FROM l_sql
            FOREACH atmg242_repcur7 INTO sr3.*
                OUTPUT TO REPORT atmg242_subrep08(sr3.*)
            END FOREACH
            FINISH REPORT atmg242_subrep08
        #FUN-CB0074--add--end--
            
        ON LAST ROW
        
            #FUN-CB0074--add--str--
            PRINTX l_x4

            IF tm.y = 'Y' THEN 
               LET l_display_18 = 'Y'
            ELSE
               LET l_display_18 = 'N'
            END IF 
            PRINTX l_display_18

            IF tm.y = 'Y' THEN 
               LET l_display_19 = 'Y'
            ELSE
               LET l_display_19 = 'N'
            END IF 
            PRINTX l_display_19
            
            LET l_ogb14_tot_1 = SUM(sr1.ogb14_sum_1)
            PRINTX l_ogb14_tot_1


            LET l_ogb14_tot_2 = SUM(sr1.ogb14_sum_2)
            PRINTX l_ogb14_tot_2

            IF tm.y <> 'Y' THEN 
               LET l_display_5 = 'Y'
            ELSE
               LET l_display_5 = 'N'
            END IF 
            PRINTX l_display_5
            
            LET l_sql = "SELECT oga23,ogb1005,ogb14,oga01,oga02,ogb03,ogb04,ogb14,oga15, ",
                        " ogb14_sum_1,ogb14_sum_2 ",
                        " FROM ",g_cr_db_str CLIPPED,l_table, 
                        " ORDER BY oga23"
            START REPORT atmg242_subrep05
            DECLARE atmg242_repcur8 CURSOR FROM l_sql
            FOREACH atmg242_repcur8 INTO sr3.*
                OUTPUT TO REPORT atmg242_subrep05(sr3.*)
            END FOREACH
            FINISH REPORT atmg242_subrep05

            IF tm.y <> 'Y' THEN 
               LET l_display_9 = 'Y'
            ELSE
               LET l_display_9 = 'N'
            END IF 
            PRINTX l_display_9
            
            START REPORT atmg242_subrep09
            DECLARE atmg242_repcur9 CURSOR FROM l_sql
            FOREACH atmg242_repcur9 INTO sr3.*
                OUTPUT TO REPORT atmg242_subrep09(sr3.*)
            END FOREACH
            
            FINISH REPORT atmg242_subrep09
            #FUN-CB0074--add--end--
END REPORT

#FUN-CB0074--add--str--
REPORT atmg242_subrep01(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT

REPORT atmg242_subrep02(sr3)
    DEFINE sr3 sr3_t
    DEFINE l_x4 LIKE type_file.chr20
    DEFINE l_ogb14_1_sum LIKE ogb_file.ogb14
    DEFINE l_display_20  LIKE type_file.chr1

    ORDER EXTERNAL BY sr3.oga23
    
    FORMAT
        ON EVERY ROW
            LET l_x4 = sr3.oga23
            PRINTX l_x4
   
            PRINTX sr3.*
            
        AFTER GROUP OF sr3.oga23
           LET l_ogb14_1_sum = GROUP SUM(sr3.ogb14_sum_1)
           PRINTX l_ogb14_1_sum
           IF NOT cl_null(l_ogb14_1_sum) THEN 
              LET l_display_20 = 'Y' 
           ELSE 
              LET l_display_20 = 'N' 
           END IF 
           PRINT l_display_20 
END REPORT

REPORT atmg242_subrep03(sr3)
    DEFINE sr3 sr3_t
    DEFINE l_x5 LIKE type_file.chr20
    DEFINE l_ogb14_2_sum LIKE ogb_file.ogb14
    DEFINE l_display_21  LIKE type_file.chr1
    
    ORDER EXTERNAL BY sr3.oga23
    
    FORMAT
        ON EVERY ROW
            LET l_x5 = sr3.oga23
            PRINTX l_x5

            PRINTX sr3.*
            
        AFTER GROUP OF sr3.oga23
            LET l_ogb14_2_sum = GROUP SUM(sr3.ogb14_sum_1)
            PRINTX l_ogb14_2_sum
            IF NOT cl_null(l_ogb14_2_sum) THEN 
               LET l_display_21 = 'Y' 
            ELSE 
               LET l_display_21 = 'N' 
            END IF 
            PRINT l_display_21
END REPORT

REPORT atmg242_subrep04(sr3)
    DEFINE sr3 sr3_t
    DEFINE l_x6 LIKE type_file.chr20
    DEFINE l_ogb14_3_sum LIKE ogb_file.ogb14
    DEFINE l_display_22  LIKE type_file.chr1

    ORDER EXTERNAL BY sr3.oga23

    FORMAT
        ON EVERY ROW
            LET l_x6 = sr3.oga23
            PRINTX l_x6

            PRINTX sr3.*
            
        AFTER GROUP OF sr3.oga23
           LET l_ogb14_3_sum = GROUP SUM(sr3.ogb14_sum_1)
           PRINTX l_ogb14_3_sum
           IF NOT cl_null(l_ogb14_3_sum) THEN 
              LET l_display_22 = 'Y' 
           ELSE 
              LET l_display_22 = 'N' 
           END IF 
           PRINT l_display_22
END REPORT

REPORT atmg242_subrep05(sr3)
    DEFINE sr3 sr3_t
    DEFINE l_x7 LIKE type_file.chr20
    DEFINE l_ogb14_4_sum LIKE ogb_file.ogb14
    DEFINE l_display_23  LIKE type_file.chr1

    ORDER EXTERNAL BY sr3.oga23

    FORMAT
        ON EVERY ROW
            LET l_x7 = sr3.oga23
            PRINTX l_x7

            PRINTX sr3.*

        AFTER GROUP OF sr3.oga23
           LET l_ogb14_4_sum = GROUP SUM(sr3.ogb14_sum_1)
           PRINTX l_ogb14_4_sum
           IF NOT cl_null(l_ogb14_4_sum) THEN 
              LET l_display_23 = 'Y' 
           ELSE 
              LET l_display_23 = 'N' 
           END IF 
           PRINT l_display_23
END REPORT

REPORT atmg242_subrep06(sr3)
    DEFINE sr3 sr3_t
    DEFINE l_x8 LIKE type_file.chr20
    DEFINE l_ogb14_5_sum LIKE ogb_file.ogb14
    DEFINE l_display_24  LIKE type_file.chr1

    ORDER EXTERNAL BY sr3.oga23

    FORMAT
        ON EVERY ROW
            LET l_x8 = sr3.oga23
            PRINTX l_x8

            PRINTX sr3.*

        AFTER GROUP OF sr3.oga23
           LET l_ogb14_5_sum = GROUP SUM(sr3.ogb14_sum_2)
           PRINTX l_ogb14_5_sum
           IF NOT cl_null(l_ogb14_5_sum) THEN 
              LET l_display_24 = 'Y' 
           ELSE 
              LET l_display_24 = 'N' 
           END IF 
           PRINT l_display_24
END REPORT

REPORT atmg242_subrep07(sr3)
    DEFINE sr3 sr3_t
    DEFINE l_x9 LIKE type_file.chr20
    DEFINE l_ogb14_6_sum LIKE ogb_file.ogb14
    DEFINE l_display_25  LIKE type_file.chr1

    ORDER EXTERNAL BY sr3.oga23

    FORMAT
        ON EVERY ROW
            LET l_x9 = sr3.oga23
            PRINTX l_x9

            PRINTX sr3.*

        AFTER GROUP OF sr3.oga23
           LET l_ogb14_6_sum = GROUP SUM(sr3.ogb14_sum_2)
           PRINTX l_ogb14_6_sum
           IF NOT cl_null(l_ogb14_6_sum) THEN 
              LET l_display_25 = 'Y' 
           ELSE 
              LET l_display_25 = 'N' 
           END IF 
           PRINT l_display_25
END REPORT

REPORT atmg242_subrep08(sr3)
    DEFINE sr3 sr3_t
    DEFINE l_x10 LIKE type_file.chr20
    DEFINE l_ogb14_7_sum LIKE ogb_file.ogb14
    DEFINE l_display_26  LIKE type_file.chr1

    ORDER EXTERNAL BY sr3.oga23

    FORMAT
        ON EVERY ROW
            LET l_x10 = sr3.oga23
            PRINTX l_x10

            PRINTX sr3.*

        AFTER GROUP OF sr3.oga23
           LET l_ogb14_7_sum = GROUP SUM(sr3.ogb14_sum_2)
           PRINTX l_ogb14_7_sum
           IF NOT cl_null(l_ogb14_7_sum) THEN 
              LET l_display_26 = 'Y' 
           ELSE 
              LET l_display_26 = 'N' 
           END IF 
           PRINT l_display_26
END REPORT

REPORT atmg242_subrep09(sr3)
    DEFINE sr3 sr3_t
    DEFINE l_x11 LIKE type_file.chr20
    DEFINE l_ogb14_8_sum LIKE ogb_file.ogb14
    DEFINE l_display_27  LIKE type_file.chr1

    ORDER EXTERNAL BY sr3.oga23

    FORMAT
        ON EVERY ROW
            LET l_x11 = sr3.oga23
            PRINTX l_x11

            PRINTX sr3.*

        AFTER GROUP OF sr3.oga23
           LET l_ogb14_8_sum = GROUP SUM(sr3.ogb14_sum_2)
           PRINTX l_ogb14_8_sum
           IF NOT cl_null(l_ogb14_8_sum) THEN 
              LET l_display_27 = 'Y' 
           ELSE 
              LET l_display_27 = 'N' 
           END IF 
           PRINT l_display_27
END REPORT
#FUN-CB0074--add--end--
###GENGRE###END
