# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: axmg701.4gl
# Descriptions...: 潛在客戶名條列印
# Input parameter:
# Return code....:
# Date & Author..: 02/12/02 By Maggie
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
#
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710090 07/02/01 By chenl  報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B40097 11/06/20 By chenying 憑證類CR轉GR
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改	
# Modify.........: No.FUN-B40097 11/08/18 By chenying 程式規範修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
       		wc     LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(500)    # Where condition
                a      LIKE type_file.num5,        # No.FUN-680137 SMALLINT     #
                c      LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)      #
       	        d      LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)      # print gkf_file detail(Y/N)
    	        e      LIKE faj_file.faj02,        # No.FUN-680137 VARCHAR(10)     # print gkf_file detail(Y/N)
           	more   LIKE type_file.chr1         # No.FUN-680137 VARCHAR(1)       # Input more condition(Y/N)
              END RECORD,
          l_rec        LIKE type_file.num5,        # No.FUN-680137 SMALLINT
          b            LIKE type_file.num5,        # No.FUN-680137 SMALLINT
          a            LIKE type_file.num5,        # No.FUN-680137 SMALLINT
          l_string     LIKE oea_file.oea01,        # No.FUN-680137 VARCHAR(13)
          g_count      LIKE type_file.num5         # No.FUN-680137 SMALLINT
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   i               LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   j               LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_str         STRING                      #No.FUN-710090
DEFINE   g_sql         STRING         
DEFINE l_table         STRING
TYPE sr1_t  RECORD
            ofd01 LIKE ofd_file.ofd01,    
            ofd04 LIKE ofd_file.ofd04,    
            ofd05 LIKE ofd_file.ofd05,   
            ofd32 LIKE ofd_file.ofd32,  
            ofd18 LIKE ofd_file.ofd18,  
            ofd19 LIKE ofd_file.ofd19, 
            ofd20 LIKE ofd_file.ofd20, 
            ofd21 LIKE ofd_file.ofd21, 
            ofd17 LIKE ofd_file.ofd17, 
            ofd171 LIKE ofd_file.ofd171,
            ofd31 LIKE ofd_file.ofd31  
            END RECORD
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
 
   LET g_pdate  = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
  #LET tm.a     = ARG_VAL(8)     #No.FUN-710090
   LET tm.c     = ARG_VAL(9)
   LET tm.d     = ARG_VAL(10)
   LET tm.e     = ARG_VAL(11)
#--------------No.TQC-610089 modify
  #LET tm.more  = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#--------------No.TQC-610089 end
#FUN-B40097----add----str----------
   LET g_sql = "ofd01.ofd_file.ofd01,",
               "ofd04.ofd_file.ofd04,",
               "ofd05.ofd_file.ofd05,",
               "ofd32.ofd_file.ofd32,",
               "ofd18.ofd_file.ofd18,",
               "ofd19.ofd_file.ofd19,",
               "ofd20.ofd_file.ofd20,",
               "ofd21.ofd_file.ofd21,",
               "ofd17.ofd_file.ofd17,",
               "ofd171.ofd_file.ofd171,",
               "ofd31.ofd_file.ofd31"
   LET l_table= cl_prt_temptable('axmg701',g_sql) CLIPPED
   IF l_table= -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40097
      CALL cl_gre_drop_temptable(l_table)    #FUN-B40097
      EXIT PROGRAM 
   END IF
#FUN-B40097----add----end----------
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL axmg701_tm(0,0)		# Input print condition
      ELSE CALL axmg701()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION axmg701_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_direct     LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01)
          l_cmd		LIKE type_file.chr1000     #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 3 LET p_col = 16
 
   OPEN WINDOW axmg701_w AT p_row,p_col WITH FORM "axm/42f/axmg701"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
  #LET tm.a    = 11      #No.FUN-710090
   LET tm.c    = '1'
   LET tm.d    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ofd01,ofd04,ofd05,ofd22,ofd10
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
           #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axmg701_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
  #INPUT BY NAME tm.a,tm.c,tm.d,tm.e,tm.more WITHOUT DEFAULTS  #No.FUN-710090   mark
   INPUT BY NAME tm.c,tm.d,tm.e,tm.more WITHOUT DEFAULTS       #No.FUN-710090   
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
     #No.FUN-710090--begin-- mark
     #AFTER FIELD a
     #   IF tm.a <11 OR  tm.a > 66  OR cl_null(tm.a) THEN
     #      CALL cl_err('','mfg4054',0) NEXT FIELD a
     #   END IF
     #No.FUN-710090--end-- mark
 
      AFTER FIELD c
         IF tm.c NOT MATCHES "[123]" OR cl_null(tm.c) THEN
            NEXT FIELD c
         END IF
 
      AFTER FIELD d
         IF tm.d NOT MATCHES "[1234]" OR cl_null(tm.d) THEN
            NEXT FIELD d
         END IF
         IF tm.d != '4' THEN
            LET tm.e = ' '
            DISPLAY BY NAME tm.e
         END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES '[YN]' OR tm.more IS NULL THEN
             NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
         LET l_direct = 'U'
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW axmg701_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='axmg701'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmg701','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang   CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                        #" '",tm.a     CLIPPED,"'",      #No.FUN-710090
                         " '",tm.c     CLIPPED,"'",
                         " '",tm.d     CLIPPED,"'",
                         " '",tm.e     CLIPPED,"'",
                        #" '",tm.more  CLIPPED,"'"  ,           #No.TQC-610089 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmg701',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW axmg701_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmg701()
   ERROR ""
END WHILE
   CLOSE WINDOW axmg701_w
END FUNCTION
 
FUNCTION axmg701()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0094
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT                 #No.FUN-680137 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_rec         LIKE type_file.num5,         # No.FUN-680137 SMALLINT
          sr            RECORD
                        ofd01  LIKE ofd_file.ofd01,	# 潛在客戶編號
                        ofd04  LIKE ofd_file.ofd04, 	# 客戶分類
                        ofd05  LIKE ofd_file.ofd05, 	# 區域代碼
                        ofd32  LIKE ofd_file.ofd32,	# 聯絡人類別
                        ofd18  LIKE ofd_file.ofd18,   # 地址1
                        ofd19  LIKE ofd_file.ofd19,   # 地址2
                        ofd20  LIKE ofd_file.ofd20,   # 地址3
                        ofd21  LIKE ofd_file.ofd21,   # 地址4
                        ofd17  LIKE ofd_file.ofd17,   # 全名1
                        ofd171 LIKE ofd_file.ofd171,  # 全名2
                        ofd31  LIKE ofd_file.ofd31    # 聯絡人姓名
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    #SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axmg701'    #No.FUN-710090 mark
    #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF      #No.FUN-710090 mark 
    #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR         #No.FUN-710090 mark  
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc CLIPPED," AND ofduser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc CLIPPED," AND ofdgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc CLIPPED," AND ofdgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ofduser', 'ofdgrup')
     #End:FUN-980030

     #FUN-B40097----add----str-------
     CALL cl_del_data(l_table )

     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ? )"
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
        CALL cl_gre_drop_temptable(l_table)    #FUN-B40097
        EXIT PROGRAM
     END IF
     #FUN-B40097----add----end-------
 
     LET l_sql = "SELECT ofd01,ofd05,ofd05,ofd32,ofd18,ofd19,",
                 "       ofd20,ofd21,ofd17,ofd171,ofd31 ",
                 "  FROM ofd_file",
                 " WHERE ",tm.wc CLIPPED
    #LET l_rec = 0                                                        #No.FUN-710090 mark  
    #LET i     = 0                                                        #No.FUN-710090 mark  
    #LET j     = 0                                                        #No.FUN-710090 mark 
     PREPARE axmg701_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        CALL cl_gre_drop_temptable(l_table)
        EXIT PROGRAM
     END IF
     #FUN-B40097--- add-- str-----
     DECLARE axmg701_cur1 CURSOR FOR axmg701_prepare1
     FOREACH axmg701_cur1 INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        EXECUTE insert_prep USING sr.*
     END FOREACH
     #FUN-B40097--- add-- str-----
 
   #No.FUN-710090--begin-- 
     LET g_str=''
     LET g_str=tm.d CLIPPED
     IF tm.d='4' THEN
        LET g_str=g_str,';',tm.e CLIPPED
     END IF
     CASE
       WHEN tm.c = '1' 
       # CALL cl_prt_cs1('axmg701_1',l_sql,g_str)   #TQC-73088
       # CALL cl_prt_cs1('axmg701','axmg701_1',l_sql,g_str) 
         LET g_template = 'axmg701'        #FUN-B40097 
         CALL axmg701_grdata()
       WHEN tm.c = '2'
       # CALL cl_prt_cs1('axmg701_2',l_sql,g_str)   #TQC-730088
       # CALL cl_prt_cs1('axmg701','axmg701_2',l_sql,g_str) 
         LET g_template = 'axmg701_1'        #FUN-B40097 
         CALL axmg701_grdata()
       WHEN tm.c = '3'
       # CALL cl_prt_cs1('axmg701_3',l_sql,g_str)   #TQC-730088
       # CALL cl_prt_cs1('axmg701','axmg701_3',l_sql,g_str) 
         LET g_template = 'axmg701_2'        #FUN-B40097 
         CALL axmg701_grdata()
     END CASE
   #No.FUN-710090--end-- 
END FUNCTION

#FUN-B40097----add----str----------
FUNCTION axmg701_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("axmg701")
        IF handler IS NOT NULL THEN
            START REPORT axmg701_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED

            DECLARE axmg701_datacur1 CURSOR FROM l_sql
            FOREACH axmg701_datacur1 INTO sr1.*
                OUTPUT TO REPORT axmg701_rep(sr1.*)
            END FOREACH
            FINISH REPORT axmg701_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axmg701_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_greet  STRING

    ORDER EXTERNAL BY sr1.ofd01

    FORMAT
      BEFORE GROUP OF sr1.ofd01
          LET l_lineno = 0

      ON EVERY ROW

          IF tm.d = '1' OR tm.d = '2' OR tm.d = '3' THEN
             LET l_greet = cl_gr_getmsg("gre-106",g_lang,tm.d)
          ELSE
             IF tm.d = '4' THEN
                LET l_greet = tm.e
             ELSE
                LET l_greet = NULL
             END IF
          END IF 
          PRINTX l_greet
          PRINTX sr1.*
END REPORT 
####No.FUN-710090--begin-- mark
#     DECLARE axmg701_curs1 CURSOR FOR axmg701_prepare1
#
#     CALL cl_outnam('axmg701') RETURNING l_name
#     START REPORT axmg701_rep TO l_name
#
#     FOREACH axmg701_curs1 INTO sr.*
#       IF SQLCA.sqlcode != 0 THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
#       END IF
#       OUTPUT TO REPORT axmg701_rep(sr.*)
#     END FOREACH
#
#     FINISH REPORT axmg701_rep
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#END FUNCTION
#
#REPORT axmg701_rep(sr)
#   DEFINE l_no          LIKE type_file.num5,        # No.FUN-680137 SMALLINT
#          sr            RECORD
#                        ofd01  LIKE ofd_file.ofd01,   # 潛在客戶編號
#                        ofd04  LIKE ofd_file.ofd04,   # 客戶分類
#                        ofd05  LIKE ofd_file.ofd05,   # 區域代碼
#                        ofd32  LIKE ofd_file.ofd32,   # 聯絡人類別
#                        ofd18  LIKE ofd_file.ofd18,   # 地址1
#                        ofd19  LIKE ofd_file.ofd19,   # 地址2
#                        ofd20  LIKE ofd_file.ofd20,   # 地址3
#                        ofd21  LIKE ofd_file.ofd21,   # 地址4
#                        ofd17  LIKE ofd_file.ofd17,   # 全名1
#                        ofd171 LIKE ofd_file.ofd171,  # 全名2
#                        ofd31  LIKE ofd_file.ofd31    # 聯絡人姓名
#                        END RECORD,
#          tmp           ARRAY[66,3] OF LIKE aaf_file.aaf03      # No.FUN-680137 VARCHAR(40)
# 
#  OUTPUT TOP MARGIN 0 LEFT MARGIN g_left_margin BOTTOM MARGIN 0 PAGE LENGTH g_page_line
#  ORDER BY sr.ofd01
#  FORMAT
#    ON EVERY ROW
#       # 所輸入每個LABEL的長度
#       IF j = 0 THEN
#          FOR a = 1 TO tm.a
#             LET tmp[a,1]=NULL LET tmp[a,2]=NULL LET tmp[a,3]=NULL
#          END FOR
#       END IF
#       LET i = 1 LET j = j + 1
#       #Addr
#       #判斷若地址有任何一行為NULL時,則不列印
#       IF sr.ofd18 IS NOT NULL THEN
#          LET tmp[i,j]= sr.ofd18
#          LET i = i+1
#       END IF
#       IF sr.ofd19 IS NOT NULL THEN
#          LET tmp[i,j]= sr.ofd19
#          LET i = i+1
#       END IF
#       IF sr.ofd20 IS NOT NULL THEN
#          LET tmp[i,j]= sr.ofd20
#          LET i = i+1
#       END IF
#       IF sr.ofd21 IS NOT NULL THEN
#          LET tmp[i,j]= sr.ofd21
#          LET i = i+1
#       END IF
#       #判斷若全名有任何一行為NULL時,則不列印
#       IF sr.ofd17 IS NOT NULL THEN
#          LET tmp[i,j]= sr.ofd17
#          LET i = i + 1
#       END IF
#       IF sr.ofd171 IS NOT NULL THEN
#          LET tmp[i,j]= sr.ofd17
#          LET i = i + 1
#       END IF
#       LET tmp[i,j] = ' '
#       LET i = i + 1
#       #判斷所選擇敬啟語並附加入陣列
#       IF tm.d = 1 THEN
#          LET l_string = g_x[1] CLIPPED
#       END IF
#       IF tm.d = 2 THEN
#          LET l_string = g_x[2] CLIPPED
#       END IF
#       IF tm.d = 3  THEN
#          LET l_string = g_x[3] CLIPPED
#       END IF
#       IF tm.d = 4  THEN
#          LET l_string = tm.e CLIPPED
#       END IF
#       LET tmp[i,j] =sr.ofd31 ,COLUMN 37,l_string
#
#       #當所選擇所需綜列列數為1
#       IF tm.c= 1 THEN
#          FOR a = 1 TO tm.a PRINT tmp[a,j] END FOR
#          LET j = 0
#       END IF
#       #當所選擇所需綜列列數為2
#       IF tm.c= '2' AND j = 2 THEN
#          FOR a = 1 TO tm.a PRINT tmp[a,1] ,tmp[a,2] END FOR
#          LET j = 0
#       END IF
#       #當所選擇所需綜列列數為3
#       IF tm.c= '3' AND j = 3 THEN
#          FOR a = 1 TO tm.a PRINT tmp[a,1] ,tmp[a,2],tmp[a,3] END FOR
#          LET j = 0
#       END IF
#
#    ON LAST ROW
#       #當陣列中還有尚未列印的資料時
#       #若綜列列數是貳時，所可能剩餘的只能一筆
#       IF tm.c = '2' AND j < 2 AND j != 0 THEN
#          FOR a = 1 TO tm.a PRINT tmp[a,1] END FOR
#       END IF
#       #若綜列列數是三時，所可能剩餘的只能一筆或兩筆
#       IF tm.c = '3' AND j < 3 AND j != 0 THEN
#          FOR a = 1 TO tm.a PRINT tmp[a,1],tmp[a,2] END FOR
#       END IF
#END REPORT
##Patch....NO.TQC-610037 <001> #
####No.FUN-710090--end-- mark
