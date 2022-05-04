# Prog. Version..: '5.30.06-13.03.29(00007)'     #
#
# Pattern name...: artr491.4gl
# Descriptions...: 收銀員收銀收款統計表
# Date & Author..: #FUN-A60075 10/07/13 By sunchenxu
# Modify.........: No:TQC-B50083 11/05/17 By wangxin 收款收銀報表改善
# Modify.........: No:TQC-B60017 11/06/22 By huangtao 画面与SQL调整
# Modify.........: No.FUN-B80085 11/08/09 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-C70007 12/07/04 By yangxf 画面与SQL调整
# Modify.........: No.FUN-C80072 12/08/28 By xumm ryd03->ryd10
# Modify.........: No.FUN-D30098 13/03/28 By xumm 逻辑调整

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                # Print condition RECORD
              wc           STRING,
              wc1     STRING,        #TQC-B60017
              bdate   LIKE type_file.dat, 
              edate   LIKE type_file.dat,
              more    LIKE type_file.chr1       # Input more condition(Y/N)
              END RECORD 
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose        
DEFINE   g_head1         STRING
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING 
DEFINE g_posdb           LIKE ryg_file.ryg00
DEFINE g_posdb_link      LIKE ryg_file.ryg02

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

#TQC-B60017 -----------------STA
#   LET g_sql = "gen01.gen_file.gen01,",
#               "gen02.gen_file.gen02,",
#               "lpt05.lpt_file.lpt05,",    # 現金
#               "lpt06.lpt_file.lpt06,",    # 銀聯卡
#               "lpt07.lpt_file.lpt07,",    # 支票
#               "lpt08.lpt_file.lpt08,",    # 券
#               "lpt09.lpt_file.lpt09,",    # 聯盟卡
#               "lpt10.lpt_file.lpt10,",    # 儲值卡
#               "lpt12.lpt_file.lpt12,",    # 沖預收
#               "lpt13.lpt_file.lpt13"      # 人工轉帳
    LET g_sql = "gen01.gen_file.gen01,",
                "gen02.gen_file.gen02,",
                "ryd01.ryd_file.ryd01,",    #款別類型 
                "ryd02.ryd_file.ryd02,",
                "rxx04.rxx_file.rxx04"      #金額  
#TQC-B60017 ------------------END                         
 
   LET l_table = cl_prt_temptable('artr491',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.wc1 = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  

   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL artr491_tm(0,0)        # Input print condition
      ELSE CALL artr491()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION artr491_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000 
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW artr491_w AT p_row,p_col WITH FORM "art/42f/artr491" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
   CALL cl_ui_init()

   CALL cl_set_comp_visible("w",FALSE)   #FUN-D30098 Add 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'

   WHILE TRUE
      #CONSTRUCT BY NAME tm.wc ON shop,opno,paykind   #TQC-B50083 mark
      #CONSTRUCT BY NAME tm.wc ON azp01,opno,paykind  #TQC-B50083 add  #TQC-B60017 mark
      DIALOG ATTRIBUTES(UNBUFFERED)   #FUN-C70007 add
         CONSTRUCT BY NAME tm.wc ON azp01                #TQC-B60017 add   

            BEFORE CONSTRUCT
               CALL cl_qbe_init()

            ON ACTION locale 
               CALL cl_show_fld_cont()                 
               LET g_action_choice = "locale"
#              EXIT CONSTRUCT               #FUN-C70007 mark
               EXIT DIALOG                  #FUN-C70007 add
               
            ON ACTION controlp
               #IF INFIELD(shop) THEN #TQC-B50083 mark
               IF INFIELD(azp01) THEN #TQC-B50083 add
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                      LET g_qryparam.state = 'c'
                      LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  #DISPLAY g_qryparam.multiret TO shop #TQC-B50083 mark
                  #NEXT FIELD shop                     #TQC-B50083 mark
                  DISPLAY g_qryparam.multiret TO azp01 #TQC-B50083 add
                  NEXT FIELD azp01                     #TQC-B50083 add
               END IF
               
#FUN-C70007 mark begin ---
#            ON IDLE g_idle_seconds
#               CALL cl_on_idle()
#               CONTINUE CONSTRUCT
# 
#            ON ACTION about          
#               CALL cl_about()       
# 
#            ON ACTION help           
#               CALL cl_show_help()   
# 
#            ON ACTION controlg       
#               CALL cl_cmdask()     
# 
#            ON ACTION exit
#               LET INT_FLAG = 1
#               EXIT CONSTRUCT
#               
#            ON ACTION qbe_select
#               CALL cl_qbe_select()
#FUN-C70007 mark end ----
#FUN-C70007 add begin ---
             AFTER CONSTRUCT
                IF INT_FLAG THEN
                   LET INT_FLAG = 0 CLOSE WINDOW artr490_w
                   CALL cl_used(g_prog,g_time,2) RETURNING g_time
                   EXIT PROGRAM
                END IF
#FUN-C70007 add end -----
         END CONSTRUCT
#FUN-C70007 mark begin ---
#         #TQC-B60017---
#         IF g_action_choice = "locale" THEN
#            LET g_action_choice = ""
#            CALL cl_dynamic_locale()
#            CONTINUE WHILE
#         END IF
#         IF INT_FLAG THEN
#            LET INT_FLAG = 0 CLOSE WINDOW artr490_w 
#            CALL cl_used(g_prog,g_time,2) RETURNING g_time 
#            EXIT PROGRAM
#         END IF
#         IF tm.wc = ' 1=1' THEN
#            CALL cl_err('','9046',0) CONTINUE WHILE
#         END IF
#FUN-C70007 mark end ---
         CONSTRUCT BY NAME tm.wc1 ON ryi01,ryd01

            BEFORE CONSTRUCT
               CALL cl_qbe_init()

            ON ACTION locale
               CALL cl_show_fld_cont()                 
               LET g_action_choice = "locale"
#              EXIT CONSTRUCT          #FUN-C70007 MARK
               EXIT DIALOG             #FUN-C70007 add
               
            ON ACTION controlp
               CASE 
                  WHEN INFIELD(ryi01) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ryi01"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ryi01
                     NEXT FIELD ryi01
                  WHEN INFIELD(ryd01) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ryd"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ryd01
                     NEXT FIELD ryd01
                  OTHERWISE EXIT CASE
               END CASE
               
#FUN-C70007 mark begin ---
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE CONSTRUCT
# 
#         ON ACTION about          
#            CALL cl_about()       
# 
#         ON ACTION help           
#            CALL cl_show_help()   
# 
#         ON ACTION controlg       
#            CALL cl_cmdask()     
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT CONSTRUCT
#            
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#FUN-C70007 mark end ----
         END CONSTRUCT
#FUN-C70007 add begin ---
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION exit
            LET INT_FLAG = 1
            CLOSE WINDOW artr490_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION close
            LET INT_FLAG=1
            CLOSE WINDOW artr490_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM

         ON ACTION accept
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG=1
            CLOSE WINDOW artr490_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
       END DIALOG
#FUN-C70007 add end ---
     #TQC-B60017---

      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW artr491_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF tm.wc = ' 1=1' THEN
#        CALL cl_err('','9046',0) CONTINUE WHILE          #FUN-C70007 MARK
         CALL cl_err('','art1073',0)    CONTINUE WHILE    #FUN-C70007 add
      END IF
      DISPLAY BY NAME tm.bdate,tm.edate,tm.more
      
      INPUT BY NAME tm.bdate,tm.edate,tm.more  WITHOUT DEFAULTS

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
         LET INT_FLAG = 0 CLOSE WINDOW artr491_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='artr491'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('artr491','9031',1)
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
                       " '",tm.wc1 CLIPPED,"'" ,       #TQC-B60017     
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('artr491',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artr491_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artr491()
      ERROR ""
   END WHILE
   CLOSE WINDOW artr491_w
END FUNCTION

FUNCTION artr491()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 
          l_chr     LIKE type_file.chr1,       
          l_za05    LIKE type_file.chr1000,
#TQC-B60017 ----------------------STA          
#          sr        RECORD 
#                    OPNO       LIKE gen_file.gen01,
#                    PAY01      LIKE lpt_file.lpt05,  # 現金
#                    PAY02      LIKE lpt_file.lpt06,  # 銀聯卡
#                    PAY03      LIKE lpt_file.lpt07,  # 支票
#                    PAY04      LIKE lpt_file.lpt08,  # 券
#                    PAY05      LIKE lpt_file.lpt09,  # 聯盟卡
#                    PAY06      LIKE lpt_file.lpt10,  # 儲值卡
#                    PAY07      LIKE lpt_file.lpt12,  # 沖預收
#                    PAY08      LIKE lpt_file.lpt13   # 手工轉帳
#                    END RECORD
            sr        RECORD 
                    OPNO       LIKE gen_file.gen01,
                    RYD01      LIKE ryd_file.ryd01,  #款別類型 
                    RYD02      LIKE ryd_file.ryd02,  #名稱
                    PAY        LIKE rxx_file.rxx04   #金額 
                    END RECORD
#TQC-B60017 -----------------------END
   DEFINE l_ryg00        LIKE ryg_file.ryg00
   DEFINE l_posdb        LIKE ryg_file.ryg00
   DEFINE l_posdb_link   LIKE ryg_file.ryg02
   DEFINE l_ryi02        LIKE ryi_file.ryi02  #TQC-B50083 add
   DEFINE l_plant        LIKE azp_file.azp01  #TQC-B50083 add
   DEFINE l_azp02        LIKE azp_file.azp02  #TQC-B50083 add
   DEFINE l_gen02        LIKE gen_file.gen02,
          l_bdate        LIKE type_file.chr8,
          l_edate        LIKE type_file.chr8
#TQC-B60017 -------------------STA          
#    LET l_ryg00= 'ds_pos1' 
#    SELECT ryg00,ryg02 INTO l_posdb,l_posdb_link FROM ryg_file WHERE ryg00=l_ryg00
     SELECT DISTINCT ryg00,ryg02 INTO l_posdb,l_posdb_link FROM ryg_file
#TQC-B60017 -------------------END    
    LET g_posdb=s_dbstring(l_posdb)
    LET g_posdb_link=r491_dblinks(l_posdb_link)
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')

    CALL cl_del_data(l_table)
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
#                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                #TQC-B60017 mark
                 " VALUES( ?, ?, ?, ?, ?)"                         #TQC-B60017                                                                                               
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1)   
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80085--add--                                                                                     
       EXIT PROGRAM                                                                                                                 
    END IF 
    LET l_bdate = tm.bdate USING "YYYYMMDD"
    LET l_edate = tm.edate USING "YYYYMMDD"
#FUN-C70007 add begin ---
    IF cl_null(tm.wc1) THEN
       LET tm.wc1 = " 1=1"
    END IF 
    IF tm.bdate IS NOT NULL AND tm.edate IS NOT NULL THEN
       LET tm.wc1  = tm.wc1 CLIPPED," AND Bdate >= '",l_bdate,"' AND Bdate <= '",l_edate,"'"
    ELSE            
       IF tm.bdate IS NOT NULL THEN 
          LET tm.wc1 = tm.wc1 CLIPPED," AND Bdate >= '",l_bdate,"'"
       END IF       
       IF tm.edate IS NOT NULL THEN 
          LET tm.wc1 = tm.wc1 CLIPPED," AND Bdate <= '",l_edate,"'"
       END IF        
    END IF          
#FUN-C70007 add end ----      
    #TQC-B50083 -----------------STA-----------------
#   LET l_sql = "SELECT DISTINCT azp01,azp02 FROM azp_file,azw_file, ",g_posdb,"POSDC",g_posdb_link,   #TQC-B60017 mark
     LET l_sql = "SELECT DISTINCT azp01,azp02 FROM azp_file,azw_file  ",                               #TQC-B60017  
                " WHERE ",tm.wc CLIPPED ,   
                "   AND azw01 = azp01  ",
                "   AND azwacti='Y'    ",                               #TQC-B60017 
                " ORDER BY azp01 "
    PREPARE sel_azp01_pre FROM l_sql
    DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre
    FOREACH sel_azp01_cs INTO l_plant,l_azp02          
       IF STATUS THEN
          CALL cl_err('PLANT:',SQLCA.sqlcode,1)
          RETURN
       END IF
    #TQC-B50083 -----------------END-----------------
#FUN-C70007 add begin ---
    LET l_sql = " SELECT OPNO,",
                " ryd01,ryd02,",
               #FUN-D30098 Mark&Add Str----------------
               #" CASE ryd01 WHEN '01' THEN SUM(pay-changed) ELSE SUM(pay) END AS  MONEY ",
                " CASE WHEN (ryd01='01' AND (IsOrderPay='N' OR IsOrderPay IS NULL)) THEN SUM(CASE Type WHEN 0 THEN pay-changed WHEN 3 THEN PAY-CHANGED ELSE (PAY-CHANGED)*(-1) END) ",
                "      WHEN IsOrderPay='Y' THEN 0 ELSE SUM(CASE Type WHEN 0 THEN PAY-CHANGED WHEN 3 THEN PAY-CHANGED ELSE (PAY-CHANGED)*(-1) END) END AS  MONEY ",
               #FUN-D30098 Mark&Add End----------------
                " FROM ",cl_get_target_table(l_plant,'ryd_file'),
                " ,",cl_get_target_table(l_plant,'ryi_file'),
                " ,",g_posdb,"td_Sale_Pay",g_posdb_link,
                " ,",g_posdb,"td_sale",g_posdb_link,
                #" WHERE ryd03 = PayCode AND td_Sale_Pay.CNFFLG='Y'",     #FUN-C80072 mark
                " WHERE ryd10 = PayCode AND td_Sale_Pay.CNFFLG='Y'",      #FUN-C80072 add
                " AND td_Sale_Pay.SHOP=td_sale.SHOP ",                      
                " AND td_Sale_Pay.SALENO=td_sale.SALENO ",                  
                " AND td_Sale_Pay.shop='",l_plant,"'",
                " AND td_sale.CNFFLG='Y'",
                " AND OPNO=ryi01 ",                  
                " AND ",tm.wc1 CLIPPED,
               #" GROUP BY OPNO,ryd01,ryd02",             #FUN-D30098 Mark
                " GROUP BY OPNO,ryd01,ryd02,IsOrderPay",  #FUN-D30098 Add 
                " ORDER BY OPNO"
#FUN-C70007 add end -----
#FUN-C70007 MARK begin ---
#    IF tm.bdate IS NOT NULL AND tm.edate IS NOT NULL THEN
#       LET l_sql = " SELECT OPNO,",
#                  #" SUM(CASE ryd03 WHEN 1 THEN PAY ELSE 0 END) AS PAY01,",  #TQC-B50083 mark
#                  #" SUM(CASE ryd03 WHEN 3 THEN PAY ELSE 0 END) AS PAY02,",  #TQC-B50083 mark
#                  #" SUM(CASE ryd03 WHEN 6 THEN PAY ELSE 0 END) AS PAY03,",  #TQC-B50083 mark
#                  #" SUM(CASE ryd03 WHEN 2 THEN PAY ELSE 0 END) AS PAY04,",  #TQC-B50083 mark
#                  #" SUM(CASE ryd03 WHEN 4 THEN PAY ELSE 0 END) AS PAY05,",  #TQC-B50083 mark
#                  #" SUM(CASE ryd03 WHEN 8 THEN PAY ELSE 0 END) AS PAY06,",  #TQC-B50083 mark
#                  #" SUM(CASE ryd03 WHEN 7 THEN PAY ELSE 0 END) AS PAY07,",  #TQC-B50083 mark
#                  #" SUM(CASE ryd03 WHEN 5 THEN PAY ELSE 0 END) AS PAY08",   #TQC-B50083 mark
#                  #TQC-B60017 -----------------STA
#                  #" SUM(CASE ryd01 WHEN '01' THEN PAY-CHANGED ELSE 0 END) AS PAY01,",  #TQC-B50083 add
#                  #" SUM(CASE ryd01 WHEN '02' THEN PAY ELSE 0 END) AS PAY02,",  #TQC-B50083 add
#                  #" SUM(CASE ryd01 WHEN '03' THEN PAY ELSE 0 END) AS PAY03,",  #TQC-B50083 add
#                  #" SUM(CASE ryd01 WHEN '04' THEN PAY ELSE 0 END) AS PAY04,",  #TQC-B50083 add
#                  #" SUM(CASE ryd01 WHEN '05' THEN PAY ELSE 0 END) AS PAY05,",  #TQC-B50083 add
#                  #" SUM(CASE ryd01 WHEN '06' THEN PAY ELSE 0 END) AS PAY06,",  #TQC-B50083 add
#                  #" SUM(CASE ryd01 WHEN '07' THEN PAY ELSE 0 END) AS PAY07,",  #TQC-B50083 add
#                  #" SUM(CASE ryd01 WHEN '08' THEN PAY ELSE 0 END) AS PAY08",	 #TQC-B50083 add
#                  #" FROM ryd_file,",g_posdb,"POSDC",g_posdb_link,
#                  #" LEFT JOIN azp_file ON azp01=SHOP ", #TQC-B50083 add
#                   " ryd01,ryd02,",
#                   " CASE ryd01 WHEN '01' THEN SUM(pay-changed) ELSE SUM(pay) END AS MONEY ",
#                   " FROM ",cl_get_target_table(l_plant,'ryd_file'),
#                   " ,",cl_get_target_table(l_plant,'ryi_file'),
#                   " ,",g_posdb,"POSDC",g_posdb_link,
#                  #TQC-B60017 -----------------END
#                   " WHERE ryd03 = PAYKIND AND CNFFLG='Y'",
#                   " AND shop='",l_plant,"'",
#                   " AND OPNO=ryi01 ",                  #TQC-B60017 add       
#                   " AND FDATE BETWEEN '",l_bdate,"' AND '",l_edate,"'",
#                   " AND ",tm.wc1 CLIPPED,
#                   " GROUP BY OPNO,ryd01,ryd02",
#                   " ORDER BY OPNO"                     #TQC-B60017 add 
#    ELSE 
#       LET l_sql = " SELECT OPNO,",
#                  #" SUM(CASE ryd03 WHEN 1 THEN PAY ELSE 0 END) AS PAY01,",  #TQC-B50083 mark
#                  #" SUM(CASE ryd03 WHEN 3 THEN PAY ELSE 0 END) AS PAY02,",  #TQC-B50083 mark
#                  #" SUM(CASE ryd03 WHEN 6 THEN PAY ELSE 0 END) AS PAY03,",  #TQC-B50083 mark
#                  #" SUM(CASE ryd03 WHEN 2 THEN PAY ELSE 0 END) AS PAY04,",  #TQC-B50083 mark
#                  #" SUM(CASE ryd03 WHEN 4 THEN PAY ELSE 0 END) AS PAY05,",  #TQC-B50083 mark
#                  #" SUM(CASE ryd03 WHEN 8 THEN PAY ELSE 0 END) AS PAY06,",  #TQC-B50083 mark
#                  #" SUM(CASE ryd03 WHEN 7 THEN PAY ELSE 0 END) AS PAY07,",  #TQC-B50083 mark
#                  #" SUM(CASE ryd03 WHEN 5 THEN PAY ELSE 0 END) AS PAY08",   #TQC-B50083 mark
#                  #TQC-B60017 -----------------STA
#                  #" SUM(CASE ryd01 WHEN '01' THEN PAY-CHANGED ELSE 0 END) AS PAY01,",  #TQC-B50083 add
#                  #" SUM(CASE ryd01 WHEN '02' THEN PAY ELSE 0 END) AS PAY02,",  #TQC-B50083 add
#                  #" SUM(CASE ryd01 WHEN '03' THEN PAY ELSE 0 END) AS PAY03,",  #TQC-B50083 add
#                  #" SUM(CASE ryd01 WHEN '04' THEN PAY ELSE 0 END) AS PAY04,",  #TQC-B50083 add
#                  #" SUM(CASE ryd01 WHEN '05' THEN PAY ELSE 0 END) AS PAY05,",  #TQC-B50083 add
#                  #" SUM(CASE ryd01 WHEN '06' THEN PAY ELSE 0 END) AS PAY06,",  #TQC-B50083 add
#                  #" SUM(CASE ryd01 WHEN '07' THEN PAY ELSE 0 END) AS PAY07,",  #TQC-B50083 add
#                  #" SUM(CASE ryd01 WHEN '08' THEN PAY ELSE 0 END) AS PAY08",	  #TQC-B50083 add
#                  #" FROM ryd_file,",g_posdb,"POSDC",g_posdb_link,
#                  #" LEFT JOIN azp_file ON azp01=SHOP ", #TQC-B50083 add
#                   " ryd01,ryd02,",
#                   " CASE ryd01 WHEN '01' THEN SUM(pay-changed) ELSE SUM(pay) END AS MONEY ",
#                   " FROM ",cl_get_target_table(l_plant,'ryd_file'),
#                   " ,",cl_get_target_table(l_plant,'ryi_file'),
#                   " ,",g_posdb,"POSDC",g_posdb_link,
#                  #TQC-B60017 -----------------END
#                   " WHERE ryd03 = PAYKIND AND CNFFLG='Y'",
#                   " AND shop='",l_plant,"'",
#                   " AND OPNO=ryi01 ",                  #TQC-B60017 add  
#                   " AND ",tm.wc1 CLIPPED,
#                   " GROUP BY OPNO,ryd01,ryd02",
#                   " ORDER BY OPNO"                     #TQC-B60017 add 
#    END IF
#FUN-C70007 MARK end ----
    PREPARE artr491_prepare1 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
    END IF
    DECLARE artr491_curs1 CURSOR FOR artr491_prepare1

    FOREACH artr491_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #TQC-B60017 -------------------------STA
      #TQC-B50083 --------------------STA-------------------- 
      #LET l_sql = " SELECT OPNAME FROM ",g_posdb,"POSCA",g_posdb_link,   
      #            " WHERE OPNO='",sr.OPNO,"'"  
      #LET l_sql = " SELECT ryi02 FROM ",cl_get_target_table(l_plant,'ryi_file'),   
      #            " WHERE ryi01='",sr.OPNO,"'"   
      #PREPARE sel_ryi02_pre FROM l_sql
      #EXECUTE sel_ryi02_pre INTO l_ryi02   
                                    
      #LET l_sql = " SELECT gen02 FROM ",cl_get_target_table(l_plant,'gen_file'),   
      #            " WHERE gen01='",l_ryi02,"'"
      #PREPARE sel_opname_pre FROM l_sql
      #EXECUTE sel_opname_pre INTO l_gen02     
      #TQC-B50083 --------------------END--------------------
      IF cl_null(sr.PAY) THEN
         LET sr.PAY = 0
      END IF
      LET l_sql = " SELECT gen02 FROM ",cl_get_target_table(l_plant,'gen_file'),
                  " ,",  cl_get_target_table(l_plant,'ryi_file'),
                  " WHERE ryi01='",sr.OPNO,"'",
                  "   AND gen01=ryi02 "
      PREPARE sel_opname_pre FROM l_sql
      EXECUTE sel_opname_pre INTO l_gen02 
      #TQC-B60017 ----------------------------END 

      EXECUTE  insert_prep  USING  
      sr.OPNO,l_gen02,
#TQC-B60017 ---------------------STA      
#      sr.PAY01,sr.PAY02,sr.PAY03,sr.PAY04,sr.PAY05,
#      sr.PAY06,sr.PAY07,sr.PAY08
      sr.RYD01,sr.RYD02,sr.PAY
#TQC-B60017 ---------------------END
      LET l_gen02 = ''
      LET l_ryi02 = '' #TQC-B50083 add
      END FOREACH      #TQC-B50083 add
   END FOREACH
#  LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED    #FUN-C70007 MARK
#FUN-C70007 MARK BEGIN ----
   LET l_sql = "SELECT gen01,gen02,ryd01,ryd02,sum(rxx04) AS rxx04",
               "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " GROUP BY gen01,gen02,ryd01,ryd02 ORDER BY gen01" 
#FUN-C70007 MARK END ------

    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN 
#       LET g_str = tm.wc CLIPPED," and ",tm.wc1      #FUN-C70007 mark
        LET g_str = tm.wc CLIPPED                     #FUN-C70007 add 
        CALL cl_wcchp(g_str,'azp01,ryi01,ryd01')
             RETURNING g_str
        IF g_str.getLength() > 1000 THEN
            LET g_str = g_str.subString(1,600)
            LET g_str = g_str,"..."
        END IF
    END IF
   CALL cl_prt_cs3('artr491','artr491',l_sql,g_str) 
END FUNCTION

FUNCTION r491_dblinks(l_db_links)
DEFINE l_db_links LIKE ryg_file.ryg02
   
  IF l_db_links IS NULL OR l_db_links = ' ' THEN
     RETURN ' '
  ELSE 
     LET l_db_links = '@',l_db_links CLIPPED
     RETURN l_db_links
  END IF
   
END FUNCTION
#FUN-A60075
