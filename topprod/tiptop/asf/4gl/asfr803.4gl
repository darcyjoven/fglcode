# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: asfr803.4gl
# Desc/riptions..: 工單變更列印 (copy from asfr801)
# Date & Author..: 06/11/16 By kim
# Modify.........: No.FUN-710082 07/01/30 By day 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.FUN-840084 08/04/18 By mike 子報表SQL語句更改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A60106 10/06/17 By Sarah 應依畫面上的"列印資料範圍"來過濾抓取的資料
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.TQC-C10039 12/01/16 By wangrr 整合單據列印EF簽核
# Modify.........: No.TQC-C70081 12/07/12 By fengrui 修正群組與使用者權限
# Modify.........: No.TQC-C80188 12/08/30 By qiull 工單號碼欄位增加開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm RECORD                        # Print condition RECORD
               wc     STRING,                       #Where condition
               a      LIKE type_file.chr1,          
               b      LIKE type_file.chr1,          
               more   LIKE type_file.chr1           
             END RECORD
 
 
DEFINE   g_i             LIKE type_file.num5   #count/index for any purpose
DEFINE   g_snb01         LIKE snb_file.snb01   
DEFINE   g_snb02         LIKE snb_file.snb02   
#No.FUN-710082--begin
DEFINE  g_sql      STRING                                                       
DEFINE  l_table    STRING                                                       
DEFINE  l_table1   STRING                                                       
DEFINE  l_str      STRING   
#No.FUN-710082--end  
MAIN
   OPTIONS
     INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 mark
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.b     = ARG_VAL(8)
   LET tm.a     = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
 
   #No.FUN-710082--begin
   LET g_sql ="snb01.snb_file.snb01,",
              "snb02.snb_file.snb02,",
              "snb022.snb_file.snb022,",
              "snb04.snb_file.snb04,",
              "snb08b.snb_file.snb08b,",
              "snb13b.snb_file.snb13b,",
              "snb15b.snb_file.snb15b,",
              "snb82b.snb_file.snb82b,",
              "snb98b.snb_file.snb98b,",
              "snb08a.snb_file.snb08a,",
              "snb13a.snb_file.snb13a,",
              "snb15a.snb_file.snb15a,",
              "snb82a.snb_file.snb82a,",
              "snb98a.snb_file.snb98a,",
              "sna04.sna_file.sna04,",
              "sna10.sna_file.sna10,",
              "sna50.sna_file.sna50,",
              "sna03b.sna_file.sna03b,",
              "sna08b.sna_file.sna08b,",
              "sna12b.sna_file.sna12b,",
              "sna26b.sna_file.sna26b,",
              "sna28b.sna_file.sna28b,",
              "sna05b.sna_file.sna05b,",
              "sna06b.sna_file.sna06b,",
              "sna27b.sna_file.sna27b,",
              "sna11b.sna_file.sna11b,",
              "sna100b.sna_file.sna100b,",
              "sna161b.sna_file.sna161b,",
              "sna062b.sna_file.sna062b,",
              "sna07b.sna_file.sna07b,",
              "sna03a.sna_file.sna03a,",
              "sna08a.sna_file.sna08a,",
              "sna12a.sna_file.sna12a,",
              "sna26a.sna_file.sna26a,",
              "sna28a.sna_file.sna28a,",
              "sna05a.sna_file.sna05a,",
              "sna06a.sna_file.sna06a,",
              "sna27a.sna_file.sna27a,",
              "sna11a.sna_file.sna11a,",
              "sna100a.sna_file.sna100a,",
              "sna161a.sna_file.sna161a,",
              "sna062a.sna_file.sna062a,",
              "sna07a.sna_file.sna07a,",
              "sfb02.sfb_file.sfb02,",
              "sfb04.sfb_file.sfb04,",
              "sfb05.sfb_file.sfb05,",
              "ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,",
              "ima02_03b.ima_file.ima02,",
              "ima021_03b.ima_file.ima021,",
              "ima02_03a.ima_file.ima02,",
              "ima021_03a.ima_file.ima021,",
              "sign_type.type_file.chr1,",  #TQC-C10039 簽核方式
              "sign_img.type_file.blob,",   #TQC-C10039 簽核圖檔
              "sign_show.type_file.chr1,",  #TQC-C10039 是否顯示簽核資料(Y/N)
              "sign_str.type_file.chr1000"  #TQC-C10039 sign_str
 
   LET l_table = cl_prt_temptable('asfr803',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql= "snc01.snc_file.snc01,",
              "snc02.snc_file.snc02,",
              "snc05.snc_file.snc05,",
              "snc06.snc_file.snc06"
   LET l_table1 = cl_prt_temptable('asfr8031',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
   #No.FUN-710082--end  
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r803_tm(0,0)              # Input print condition
      ELSE CALL asfr803()                 # Read data and create out-file
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
# Description: 讀入批次執行條件
FUNCTION r803_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
 
    DEFINE p_row,p_col	LIKE type_file.num5
    DEFINE l_cmd        LIKE type_file.chr1000
 
    LET p_row = 4 LET p_col = 20
 
    OPEN WINDOW r803_w AT p_row,p_col WITH FORM "asf/42f/asfr803"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
    CALL cl_opmsg('p')
 
#   INITIALIZE tm.* TO NULL			# Default condition
    LET g_pdate   = g_today
    LET g_rlang   = g_lang
    LET g_bgjob   = 'N'
    LET g_copies  = '1'
    LET tm.a      = '1'
    LET tm.b      = 'N'
    LET tm.more   = 'N'
 
    WHILE TRUE
        CONSTRUCT BY NAME tm.wc ON snb01,snb022,snb02
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

          #TQC-C80188---begin------
          ON ACTION controlp
             CASE
                WHEN INFIELD(snb01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form  = "q_snb01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO snb01
                  NEXT FIELD snb01
                OTHERWISE EXIT CASE
             END CASE
          #TQC-C80188---end---------
             
          ON ACTION locale
              #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
              LET g_action_choice = "locale"
              EXIT CONSTRUCT
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
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
           LET INT_FLAG = 0
           CLOSE WINDOW r803_w
           CALL cl_used(g_prog,g_time,2) RETURNING g_time
           EXIT PROGRAM
        END IF
 
        IF tm.wc=" 1=1 " THEN
           CALL cl_err(' ','9046',0)
           CONTINUE WHILE
        END IF
 
        # Condition
        DISPLAY BY NAME tm.a,tm.b,tm.more
 
        INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
           AFTER FIELD a
              IF tm.a NOT MATCHES "[123]" OR tm.a IS NULL
                 THEN NEXT FIELD a
              END IF
 
           AFTER FIELD b
              IF tm.b NOT MATCHES "[YN]" OR tm.b IS NULL
                 THEN NEXT FIELD b
              END IF
 
           AFTER FIELD more
              IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
                 THEN NEXT FIELD more
              END IF
              IF tm.more = 'Y' THEN
                 CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
              END IF
 
           ON ACTION CONTROLR
              CALL cl_show_req_fields()
 
           ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
           ON ACTION exit
              LET INT_FLAG = 1
              EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
        END INPUT
 
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            CLOSE WINDOW r803_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
 
        IF g_bgjob = 'Y' THEN
 
            #get exec cmd (fglgo xxxx)
            SELECT zz08 INTO l_cmd FROM zz_file	
             WHERE zz01='asfr803'
 
            IF SQLCA.sqlcode OR l_cmd IS NULL THEN
                CALL cl_err('asfr803','9031',1)
            ELSE
                # time fglgo xxxx p1 p2 p3
                LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
 
                LET l_cmd = l_cmd CLIPPED
                           ," '",g_pdate  CLIPPED,"'"
                           ," '",g_towhom CLIPPED,"'"
                           ," '",g_lang   CLIPPED,"'"
                           ," '",g_bgjob  CLIPPED,"'"
                           ," '",g_prtway CLIPPED,"'"
                           ," '",g_copies CLIPPED,"'"
                           ," '",tm.wc    CLIPPED,"'"
                           ," '",tm.b     CLIPPED,"'"
                           ," '",tm.a     CLIPPED,"'"
                          ," '",g_rep_user CLIPPED,"'",
                           " '",g_rep_clas CLIPPED,"'",
                           " '",g_template CLIPPED,"'" 
 
                # Execute cmd at later time
                CALL cl_cmdat('asfr803',g_time,l_cmd)
            END IF
 
            CLOSE WINDOW r803_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
 
        CALL cl_wait()
        CALL asfr803()
        ERROR ""
 
    END WHILE
    CLOSE WINDOW r803_w
 
END FUNCTION
 
FUNCTION asfr803()
   DEFINE l_name	LIKE type_file.chr20   #External(Disk) file name
   DEFINE l_sql 	STRING
   DEFINE l_chr		LIKE type_file.chr1    
   DEFINE sr1   RECORD  LIKE snb_file.*,
          sr2   RECORD  LIKE sna_file.*,
          sr3   RECORD
                   sfb02      LIKE sfb_file.sfb02,    # 工單型態
                   sfb04      LIKE sfb_file.sfb04,    # 工單狀態
                   sfb05      LIKE sfb_file.sfb05,    # 料件編號
                   ima02      LIKE ima_file.ima02,    # 品名規格
                   ima021     LIKE ima_file.ima021    #No.FUN-710082
                END RECORD
   #No.FUN-710082--begin
   DEFINE sr4   RECORD
                   snc01      LIKE snc_file.snc01,    
                   snc02      LIKE snc_file.snc02,    
                   snc05      LIKE snc_file.snc05,    
                   snc06      LIKE snc_file.snc06    
                END RECORD
   DEFINE        l_ima02_03b  LIKE ima_file.ima02,    # 變更前料號品名規格
                 l_ima021_03b LIKE ima_file.ima021,
                 l_ima02_03a  LIKE ima_file.ima02,    # 變更後料號品名規格
                 l_ima021_03a LIKE ima_file.ima021
   #No.FUN-710082--end  
#TQC-C10039--add--start---
   DEFINE l_img_blob     LIKE type_file.blob  
   LOCATE l_img_blob IN MEMORY               
#TQC-C10039--add--end---
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #No.FUN-710082--begin
#  SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asfr803'
#  IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
#  FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
   #No.FUN-710082--end  
 
   #只能使用自己的資料
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN
   #       LET tm.wc = tm.wc clipped," AND pnauser = '",g_user,"'"
   #   END IF
 
   #只能使用相同群的資料
   #   IF g_priv3='4' THEN
   #       LET tm.wc = tm.wc clipped," AND pnagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #       LET tm.wc = tm.wc clipped," AND pnagrup IN ",cl_chk_tgrup_list()
   #   END IF
   #LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pnauser', 'pnagrup')  #TQC-C70081 mark
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('snbuser', 'snbgrup')   #TQC-C70081 add 
   #End:FUN-980030
 
   #No.FUN-710082--begin
   LET l_sql = " SELECT snc01,snc02,snc05,snc06 FROM snc_file ",
               "  WHERE snc01 = ? AND snc02 = ? ",
               "  ORDER BY snc05 "
   PREPARE r803_pr2 FROM l_sql
   DECLARE r803_cs2 CURSOR FOR r803_pr2
   IF SQLCA.SQLCODE THEN
      CALL cl_err('prepare:#2',sqlca.sqlcode,1)
   END IF
 
   LET l_sql = " SELECT snb_file.*,sna_file.*,sfb02,sfb04,sfb05,ima02,ima021 ",
#  LET l_sql = " SELECT snb_file.*,sna_file.*,sfb02,sfb04,sfb05,ima02 ",
                "   FROM snb_file,OUTER sna_file,sfb_file,OUTER ima_file ",
               "  WHERE snb_file.snb01=sna_file.sna01 AND snb_file.snb02=sna_file.sna02 ",
               "    AND snb01=sfb01 AND sfb_file.sfb05=ima_file.ima01 ",
               "    AND ",tm.wc CLIPPED
  #str MOD-A60106 add
   IF tm.a='1' THEN LET l_sql=l_sql CLIPPED,"   AND snb99 = '2'" END IF
   IF tm.a='2' THEN LET l_sql=l_sql CLIPPED,"   AND snb99!= '2'" END IF
  #end MOD-A60106 add 
   LET l_sql=l_sql CLIPPED," ORDER BY snb01,snb02,sna04"   #No.FUN-710082
 
   PREPARE r803_pr1 FROM l_sql
 
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      RETURN
   END IF
 
   DECLARE r803_cs1 CURSOR FOR r803_pr1
 
#  LET l_name = 'asfr803.out'
 
#  CALL cl_outnam('asfr803') RETURNING l_name
 
#  START REPORT r803_rep TO l_name
 
#  LET g_pageno = 0
 
   CALL cl_del_data(l_table) 
   CALL cl_del_data(l_table1) 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ? ) "         #TQC-C10039 add 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?) "
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep1:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
      EXIT PROGRAM
   END IF
 
   FOREACH r803_cs1 INTO sr1.*,sr2.*,sr3.*
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
     END IF
     SELECT ima02,ima021 INTO l_ima02_03b,l_ima021_03b FROM ima_file
      WHERE sr2.sna03b=ima01
     SELECT ima02,ima021 INTO l_ima02_03a,l_ima021_03a FROM ima_file
      WHERE sr2.sna03a=ima01
 
      FOREACH r803_cs2 USING sr1.snb01,sr1.snb02 INTO sr4.*
        EXECUTE insert_prep1 USING sr4.*
      END FOREACH
#    OUTPUT TO REPORT r803_rep(sr1.*,sr2.*,sr3.*)
 
       EXECUTE insert_prep USING sr1.snb01,sr1.snb02,sr1.snb022,sr1.snb04,sr1.snb08b,
                                 sr1.snb13b,sr1.snb15b,sr1.snb82b,sr1.snb98b,sr1.snb08a,
                                 sr1.snb13a,sr1.snb15a,sr1.snb82a,sr1.snb98a,sr2.sna04,
                                 sr2.sna10,sr2.sna50,sr2.sna03b,sr2.sna08b,sr2.sna12b,
                                 sr2.sna26b,sr2.sna28b,sr2.sna05b,sr2.sna06b,sr2.sna27b,
                                 sr2.sna11b,sr2.sna100b,sr2.sna161b,sr2.sna062b,sr2.sna07b,
                                 sr2.sna03a,sr2.sna08a,sr2.sna12a,sr2.sna26a,sr2.sna28a,
                                 sr2.sna05a,sr2.sna06a,sr2.sna27a,sr2.sna11a,sr2.sna100a,
                                 sr2.sna161a,sr2.sna062a,sr2.sna07a,sr3.sfb02,sr3.sfb04,  
                                 sr3.sfb05,sr3.ima02,sr3.ima021,
                                 l_ima02_03b,l_ima021_03b,  
                                 l_ima02_03a,l_ima021_03a,
                                 "",l_img_blob,"N",""              #TQC-C10039 ADD "",l_img_blob,"N",""
 
       LET l_ima02_03b=''
       LET l_ima021_03b=''
       LET l_ima02_03a=''
       LET l_ima021_03a=''
   END FOREACH
 
#  FINISH REPORT r803_rep
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-840084  --BEGIN
  #   LET l_sql = " SELECT ",l_table CLIPPED,".*,",l_table1 CLIPPED,".*",
  ##TQC-730088# "   FROM ",l_table CLIPPED,",OUTER ",l_table1 CLIPPED,
  #             "   FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,",",g_cr_db_str CLIPPED,l_table1 CLIPPED,
  #             " WHERE snb01 =",l_table1 CLIPPED,".snc01(+) ",
  #             "   AND snb02 =",l_table1 CLIPPED,".snc02(+) ",
  #             " ORDER BY snb01,snb02,sna04,snc05 " 
    LET l_sql = " SELECT A.*,B.*",                                                           
                "   FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A ",
     "   LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table1 CLIPPED," B ",
                "     ON A.snb01=B.snc01 AND A.snb02=B.snc02 ",
                " ORDER BY snb01,snb02,sna04,snc05 "   
#No.FUN-840084  --END 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN                                                         
      CALL cl_wcchp(tm.wc,'snb01,snb022,snb02')                                        
      RETURNING tm.wc                                                           
   END IF                      
   LET l_str = tm.wc CLIPPED,";",g_zz05 CLIPPED,";",tm.b CLIPPED
#TQC-C10039--add--start---
     LET g_cr_table = l_table      #主報表的temp table名稱
     LET g_cr_apr_key_f = "snb01|snb02"  #報表主鍵欄位名稱，用"|"隔開
#TQC-C10039--add--end---
 # CALL cl_prt_cs3('asfr803',l_sql,l_str)  #TQC-730088
   CALL cl_prt_cs3('asfr803','asfr803',l_sql,l_str) 
   #No.FUN-710082--end  
 
END FUNCTION
 
#No.FUN-710082--begin
#REPORT r803_rep(sr1,sr2,sr3)
#  DEFINE sr1   RECORD  LIKE snb_file.*,
#         sr2   RECORD  LIKE sna_file.*,
#         sr3   RECORD
#                  sfb02         LIKE sfb_file.sfb02,    # 工單型態
#                  sfb04         LIKE sfb_file.sfb04,    # 工單狀態
#                  sfb05         LIKE sfb_file.sfb05,    # 料件編號
#                  ima02         LIKE ima_file.ima02,    # 品名規格
#                  ima02_03b     LIKE ima_file.ima02,    # 變更前料號品名規格
#                  ima02_03a     LIKE ima_file.ima02     # 變更後料號品名規格
#               END RECORD
#  DEFINE l_snc05   LIKE snc_file.snc05,
#         l_snc06   LIKE snc_file.snc06,
#         l_swich   LIKE type_file.num5, 
#         l_str     LIKE ima_file.ima34, 
#         l_last_sw LIKE type_file.chr1 
 
# OUTPUT TOP MARGIN 0
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN 7
#        PAGE LENGTH g_page_line
# ORDER BY sr1.snb01,sr1.snb02,sr2.sna04
 
# FORMAT
#  PAGE HEADER
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     #對外單據不需列印FROM
#     PRINT ' '
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
 
#     LET g_pageno = g_pageno + 1
 
#     PRINT g_x[11] CLIPPED,sr1.snb04,1 SPACES;
#      CASE sr1.snb04
#           WHEN '1' LET l_str=g_x[12] CLIPPED
#           WHEN '2' LET l_str=g_x[13] CLIPPED
#      END CASE
#     PRINT l_str CLIPPED,
#           COLUMN 35,g_x[14] CLIPPED,sr1.snb022,
#           COLUMN 56,g_x[15] CLIPPED,sr1.snb02 USING '##',
#           COLUMN 88,g_x[3] CLIPPED,g_pageno USING '<<<'
#     PRINT g_dash[1,g_len]
#     PRINT g_x[16] CLIPPED,sr1.snb01
#           #COLUMN 35,g_x[17] CLIPPED,sr3.sfb05 CLIPPED,1 SPACES,sr3.ima02
#     PRINT g_x[17] CLIPPED,sr3.sfb05 CLIPPED
#     PRINT g_x[62] CLIPPED,sr3.ima02
#     PRINT g_x[18] CLIPPED,sr3.sfb02 USING '##',1 SPACES;
#      CASE sr3.sfb02
#           WHEN '1' LET l_str=g_x[20] CLIPPED
#           WHEN '5' LET l_str=g_x[21] CLIPPED
#           WHEN '7' LET l_str=g_x[22] CLIPPED
#           WHEN '8' LET l_str=g_x[23] CLIPPED
#           WHEN '11' LET l_str=g_x[24] CLIPPED
#           WHEN '13' LET l_str=g_x[25] CLIPPED
#           WHEN '15' LET l_str=g_x[26] CLIPPED
#      END CASE
#     PRINT l_str CLIPPED,
#           COLUMN 35,g_x[19] CLIPPED,sr3.sfb04,1 SPACES;
#      CASE sr3.sfb04
#           WHEN '1' LET l_str=g_x[27] CLIPPED
#           WHEN '2' LET l_str=g_x[28] CLIPPED
#           WHEN '3' LET l_str=g_x[29] CLIPPED
#           WHEN '4' LET l_str=g_x[30] CLIPPED
#           WHEN '5' LET l_str=g_x[31] CLIPPED
#           WHEN '6' LET l_str=g_x[32] CLIPPED
#           WHEN '7' LET l_str=g_x[33] CLIPPED
#           WHEN '8' LET l_str=g_x[34] CLIPPED
#      END CASE
#     PRINT l_str CLIPPED
#     PRINT ' '
#     #IF sr1.snb04='2' THEN #舊的寫法
#     IF  (cl_null(sr1.snb08a)) AND
#         (cl_null(sr1.snb13a)) AND
#         (cl_null(sr1.snb15a)) AND
#         (cl_null(sr1.snb82a)) THEN
#        SKIP 5 LINES
#     ELSE
#        PRINT g_x[35] CLIPPED,cl_numfor(sr1.snb08b,14,3),
#              COLUMN 35,g_x[36] CLIPPED,sr1.snb13b,
#              COLUMN 56,g_x[37] CLIPPED,sr1.snb15b
#        PRINT g_x[38] CLIPPED,
#              COLUMN 17,cl_numfor(sr1.snb08a,14,3) CLIPPED,
#              COLUMN 44,sr1.snb13a,
#              COLUMN 65,sr1.snb15a
#        PRINT ' '
#        PRINT g_x[39] CLIPPED,
#              COLUMN 22,sr1.snb82b,
#              COLUMN 35,g_x[40] CLIPPED,sr1.snb98b
#        PRINT g_x[38] CLIPPED,
#              COLUMN 22,sr1.snb82a,
#              COLUMN 44,sr1.snb98a
#     END IF
#     PRINT g_x[53] CLIPPED,g_x[53] CLIPPED,g_x[61] CLIPPED
#     
#     IF sr1.snb04='1' AND (sr2.sna10!='4' OR (sr2.sna10='4' AND tm.b='N'))  THEN
#        SKIP 2LINE
#     ELSE
#        PRINT g_x[41],g_x[42],g_x[58] CLIPPED
#        PRINT g_x[43],g_x[44],g_x[59] CLIPPED
#     END IF
#     LET l_last_sw = 'n'
#
#  BEFORE GROUP OF sr1.snb01
#     IF PAGENO > 1 OR LINENO > 9 THEN
#        SKIP TO TOP OF PAGE
#     END IF
#  BEFORE GROUP OF sr1.snb02
#     IF PAGENO > 1 OR LINENO > 9 THEN
#        SKIP TO TOP OF PAGE
#     END IF
#  ON EVERY ROW
#     IF sr1.snb04='1' AND (sr2.sna10!='4' OR (sr2.sna10='4' AND tm.b='N'))  THEN
#        SKIP 9 LINE
#     ELSE
#        PRINT g_x[45],g_x[46],g_x[60] CLIPPED
#        PRINT COLUMN 03,sr2.sna04 USING '###',
#              COLUMN 10,g_x[47] CLIPPED,sr2.sna10,1 SPACES;
#         CASE sr2.sna10
#              WHEN '1' LET l_str=g_x[54] CLIPPED
#              WHEN '2' LET l_str=g_x[55] CLIPPED
#              WHEN '3' LET l_str=g_x[56] CLIPPED
#              WHEN '4' LET l_str=g_x[57] CLIPPED
#         END CASE
#        PRINT l_str CLIPPED,
#              COLUMN 47,g_x[48] CLIPPED,sr2.sna50
#        PRINT COLUMN 03,g_x[49] CLIPPED,sr2.sna03b,
#              COLUMN 31,sr2.sna08b,
#              COLUMN 44,sr2.sna12b,
#              COLUMN 49,sr2.sna26b,
#              COLUMN 58,cl_numfor(sr2.sna28b,5,3),
#              COLUMN 65,cl_numfor(sr2.sna05b,14,3),
#              COLUMN 81,cl_numfor(sr2.sna06b,14,3)
#        PRINT COLUMN 10,sr2.sna27b,
#              COLUMN 39,sr2.sna11b,
#              COLUMN 41,cl_numfor(sr2.sna100b,5,3),
#              COLUMN 49,cl_numfor(sr2.sna161b,14,3),
#              COLUMN 65,cl_numfor(sr2.sna062b,14,3),
#              COLUMN 81,cl_numfor(sr2.sna07b,14,3)
#        PRINT COLUMN 10,sr3.ima02_03b
#        PRINT COLUMN 03,g_x[50] CLIPPED,sr2.sna03a,
#              COLUMN 31,sr2.sna08a,
#              COLUMN 44,sr2.sna12a,
#              COLUMN 49,sr2.sna26a,
#              COLUMN 58,cl_numfor(sr2.sna28a,5,3),
#              COLUMN 65,cl_numfor(sr2.sna05a,14,3),
#              COLUMN 81,cl_numfor(sr2.sna06a,14,3)
#        PRINT COLUMN 10,sr2.sna27a,
#              COLUMN 39,sr2.sna11a,
#              COLUMN 41,cl_numfor(sr2.sna100a,5,3),
#              COLUMN 49,cl_numfor(sr2.sna161a,14,3),
#              COLUMN 65,cl_numfor(sr2.sna062a,14,3),
#              COLUMN 81,cl_numfor(sr2.sna07a,14,3)
#        PRINT COLUMN 10,sr3.ima02_03a
#     END IF
   
#  AFTER GROUP OF sr1.snb02
#     LET l_swich=1
#     LET l_snc05=0
#     LET l_snc06=' '
#     SKIP 1 LINE
#     FOREACH r803_cs2 USING sr1.snb01,sr1.snb02
#       INTO l_snc05,l_snc06
#       IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
#       IF l_swich=1 THEN
#          PRINT COLUMN 03,g_x[22] CLIPPED;
#       END IF
#       PRINT COLUMN 08,l_snc06
#       LET l_swich=l_swich+1
#     END FOREACH
    
#  ON LAST ROW
#        LET l_last_sw = 'y'
   
#  PAGE TRAILER
#        PRINT g_dash[1,g_len]
#        PRINT
#        IF l_last_sw = 'n' THEN
#           IF g_memo_pagetrailer THEN
#               PRINT g_x[51]
#               PRINT g_memo
#           ELSE
#               PRINT
#               PRINT
#           END IF
#        ELSE
#               PRINT g_x[51]
#               PRINT g_memo
#        END IF
#END REPORT
##Patch....NO.TQC-610037 <001> #
#No.FUN-710082--end  
