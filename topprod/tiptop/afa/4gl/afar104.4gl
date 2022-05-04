# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: afar104.4gl
# Descriptions...: 固定資產移轉申請表
# Date & Author..: 97/02/17 By Jeffery
# Modify.........: No.MOD-4A0112 04/10/13 By Smapmin列印出單頭資料
# Modify.........: No.FUN-510035 05/01/18 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-550114 05/05/31 By echo 新增報表備註
# Modify.........: No.TQC-5B0008 05/11/02 By Sarah 將[1,xx]清除後加CLIPPED
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0009 06/12/07 By Rayven 語言按紐在鼠標點擊下無效，要按鍵盤上‘ENTER’鍵，才會有效
# Modify.........: No.FUN-710083 07/01/31 By Ray Crystal Report修改
# Modify.........: No.TQC-730088 07/03/22 By Nicole 增加 CR參數
# Modify.........: No.TQC-780054 07/08/15 By xiaofeizhu 修改INSERT INTO temptable語法(不用ora轉換)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0007 09/12/02 By Sarah CRTemptable增加faj06
# Modify.........: No:TQC-A40084 10/04/19 By Carrier 漏了AFTER INPUT
# Modify.........: No:TQC-B20075 11/02/17 By yinhy 報表增加了3個欄位:fat04,fat05,fat06
# Modify.........: No:TQC-B20103 11/02/18 By yinhy sql增加"財產附號"faj022條件
# Modify.........: No.TQC-C10034 12/01/19 By zhuhao CR報表簽核 
# Modify.........: No:TQC-BC0033 12/03/02 By Elise 加入新、原處所，保管部門、保管人說明欄位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD                    # Print condition RECORD
             wc   LIKE type_file.chr1000,      # Where condition       #No.FUN-680070 VARCHAR(1000)
             s    LIKE type_file.chr4,            # Order by sequence       #No.FUN-680070 VARCHAR(4)
             t    LIKE type_file.chr4,            # Eject sw       #No.FUN-680070 VARCHAR(1)  #No.TQC-6C0009 chr1->chr4
             more LIKE type_file.chr1             # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
          END RECORD
DEFINE g_i LIKE type_file.num5                   #count/index for any purpose        #No.FUN-680070 SMALLINT
DEFINE t4  LIKE type_file.num5         #No.FUN-680070 SMALLINT
#No.FUN-710083 --begin
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  g_str      STRING
#No.FUN-710083 --end
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
 
 
 
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)   
   LET tm.t  = ARG_VAL(9)   
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#No.FUN-710083 --begin
   LET g_sql ="fas03.fas_file.fas03,fas04.fas_file.fas04,",
              "fas05.fas_file.fas05,fas01.fas_file.fas01,",
              "faj02.faj_file.faj02,faj022.faj_file.faj022,",
              "faj06.faj_file.faj06,faj07.faj_file.faj07,",  #MOD-9C0007 add faj06
              "faj08.faj_file.faj08,faj17.faj_file.faj17,",
              "faj21.faj_file.faj21,fat06.fat_file.fat06,",  #TQC-B20075 add fat06
              "fat04.fat_file.fat04,fat05.fat_file.fat05,",  #TQC-B20075
              "faj26.faj_file.faj26,",
              "faj33.faj_file.faj33,faj20.faj_file.faj20,",
              "faj19.faj_file.faj19,gen02.gen_file.gen02,",
              "gem02.gem_file.gem02,azi04.azi_file.azi04,",
              #TQC-C10034---add---begin
              "sign_type.type_file.chr1,sign_img.type_file.blob,",      
              "sign_show.type_file.chr1,sign_str.type_file.chr1000,",
              #TQC-C10034---add---end
             #TQC-BC0033---add---str 
              "l_faj21.faf_file.faf02,l_fat06.faf_file.faf02,", 
              "l_faj20.gem_file.gem02,l_fat05.gem_file.gem02,",
              "l_fat04.gen_file.gen02"
             #TQC-BC0033---add---end

   LET l_table = cl_prt_temptable('afar104',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-780054
             " VALUES(?,?,?,?,?, ?,?,?,?,?,",
             "        ?,?,?,?,?, ?,?,?,?,?,",
             "        ?,?,?,?,?, ?,?,?,?,? )"  #MOD-9C0007 add ?   #TQC-B20075 add 3? #TQC-C10034 add 3? #TQC-BC0033 add 5?

   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-710083 --end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r104_tm(0,0)		# Input print condition
      ELSE CALL afar104()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION r104_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       l_cmd          LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r104_w AT p_row,p_col WITH FORM "afa/42f/afar104"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Defaslt condition
   LET tm.s    = '123'
   LET tm.t    = ' Y '
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.s4   = tm.s[4,4]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.t4   = tm.t[4,4]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.s4) THEN LET tm2.s4 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.t4) THEN LET tm2.t4 = "N" END IF
 
   WHILE TRUE
#     DISPLAY BY NAME tm.s,tm.t,tm.more       #No.FUN-710083
      DISPLAY BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.s4,tm2.t1,tm2.t2,tm2.t3,tm2.t4,tm.more      #No.FUN-710083
      CONSTRUCT BY NAME tm.wc ON faj20,faj19,faj02,faj022
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
         LET INT_FLAG = 0 CLOSE WINDOW r104_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
#     DISPLAY BY NAME tm.s,tm.t,tm.more # Condition #No.FUN-710083
      DISPLAY BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.s4,tm2.t1,tm2.t2,tm2.t3,tm2.t4,tm.more     #No.FUN-710083
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.s4,
                 tm2.t1,tm2.t2,tm2.t3,tm2.t4,
                 tm.more
                 WITHOUT DEFAULTS HELP 1
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION controlg CALL cl_cmdask()        # Command execution

      AFTER INPUT              #No.TQC-A40084
      LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1],tm2.s4[1,1]
      LET tm.t = tm2.t1,tm2.t2,tm2.t3,tm2.t4
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
 
 
      LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1],tm2.s4[1,1]   #No.FUN-710083
      LET tm.t = tm2.t1,tm2.t2,tm2.t3,tm2.t4                       #No.FUN-710083
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r104_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='afar104'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar104','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.s CLIPPED,"'",
                            " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar104',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r104_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar104()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r104_w
END FUNCTION
 
FUNCTION afar104()
 
DEFINE l_name   LIKE type_file.chr20,             # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#      l_time   LIKE type_file.chr8               #No.FUN-6A0069
       l_sql    LIKE type_file.chr1000,           # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
       l_gem02  LIKE gem_file.gem02,              #部門名稱     #No.FUN-710083
       l_gen02  LIKE gen_file.gen02,              #申請人名稱     #No.FUN-710083
       l_chr    LIKE type_file.chr1,              #No.FUN-680070 VARCHAR(1)
       l_za05	LIKE type_file.chr4,              #No.FUN-680070 VARCHAR(4)
       l_order	ARRAY[6] OF LIKE faj_file.faj02,  #No.FUN-680070 VARCHAR(10)
       sr       RECORD
                #order1 LIKE faj_file.faj02,      #No.FUN-680070 VARCHAR(10)
                #order2 LIKE faj_file.faj02,      #No.FUN-680070 VARCHAR(10)
                #order3 LIKE faj_file.faj02,      #No.FUN-680070 VARCHAR(10)
                 #MOD-4A0112
                 fas03  LIKE fas_file.fas03,
                 fas04  LIKE fas_file.fas04,
                 fas05  LIKE fas_file.fas05,
                 fas01  LIKE fas_file.fas01,
                 #MOD-4A0112
                 faj02  LIKE faj_file.faj02,   #財編
                 faj022 LIKE faj_file.faj022,  #附號
                 faj06  LIKE faj_file.faj06,   #中文名稱  #MOD-9C0007 add
                 faj07  LIKE faj_file.faj07,   #英文名稱
                 faj08  LIKE faj_file.faj08,   #規格型號
                 faj17  LIKE faj_file.faj17,   #數量
                 faj21  LIKE faj_file.faj21,   #存放位置
                 fat06  LIKE fat_file.fat06,   #新存放位置  #TQC-B20076 
                 fat04  LIKE fat_file.fat04,   #新保管人    #TQC-B20076
                 fat05  LIKE fat_file.fat05,   #新保管部門  #TQC-B20076                 
		 faj26  LIKE faj_file.faj26,   #入帳日期
                 faj33  LIKE faj_file.faj33,   #未折減額
                 faj20  LIKE faj_file.faj20,   #保管部門
                 faj19  LIKE faj_file.faj19    #保管人員
                END RECORD
    #TQC-BC0033 --start--
     DEFINE l_faj21 LIKE faf_file.faf02
     DEFINE l_fat06 LIKE faf_file.faf02
     DEFINE l_faj20 LIKE gem_file.gem02
     DEFINE l_fat05 LIKE gem_file.gem02
     DEFINE l_fat04 LIKE gen_file.gen02
    #TQC-BC0033 --end--

     #TQC-C10034--add--begin
     DEFINE l_img_blob     LIKE type_file.blob
     LOCATE l_img_blob IN MEMORY
     #TQC-C10034--add--end
     CALL cl_del_data(l_table)     #No.FUN-710083
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc CLIPPED," AND fajuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc CLIPPED," AND fajgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc CLIPPED," AND fajgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
     #End:FUN-980030
 
#    LET l_sql = " SELECT '','','',",
     LET l_sql = " SELECT ",
                 "fas03,fas04,fas05,fas01,",  #MOD-4A0112
                 "faj02,faj022,faj06,faj07,faj08,faj17,faj21,",  #MOD-9C0007 add faj06
                 "fat06,fat04,fat05,",        #TQC-B20076 add
                 "faj26, ",
                 "faj33,faj20,faj19",
                 " FROM faj_file,fas_file,fat_file",  #MOD-4A0112
                 " WHERE faj43 not IN ('0','5','6','X') ",
                 " AND fas01=fat01 AND fat03=faj02 ", #MOD-4A0112
                 " AND fat031 = faj022 AND fasconf !='X' AND ",tm.wc    #TQC-B20103 
     PREPARE r104_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
     END IF
     DECLARE r104_cs1 CURSOR FOR r104_prepare1
#No.FUN-710083 --begin
#    CALL cl_outnam('afar104') RETURNING l_name
 
#    START REPORT r104_rep TO l_name
#    LET g_pageno = 0
#No.FUN-710083 --end
 
     DISPLAY l_table
     FOREACH r104_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
#No.FUN-710083 --begin
       LET l_gen02=' '
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.fas03
       LET l_gem02=' '
       SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.fas04
      #TQC-BC0033 --start--
       LET l_faj21=''
       SELECT faf02 INTO l_faj21 FROM faf_file
        WHERE faf01 = sr.faj21

       LET l_fat06=''
       SELECT faf02 INTO l_fat06 FROM faf_file
        WHERE faf01 = sr.fat06

       LET l_faj20=''
       SELECT gem02 INTO l_faj20 FROM gem_file
        WHERE gem01 = sr.faj20

       LET l_fat05=''
       SELECT gem02 INTO l_fat05 FROM gem_file
        WHERE gem01 = sr.fat05

       LET l_fat04=''
       SELECT gen02 INTO l_fat04 FROM gen_file
        WHERE gen01 = sr.fat04

      #TQC-BC0033 --end--

       EXECUTE insert_prep USING sr.*,l_gen02,l_gem02,g_azi04,
                                 "",  l_img_blob,   "N","",           #TQC-C10034  add
                                 l_faj21,l_fat06,l_faj20,l_fat05,l_fat04   #TQC-BC0033 add 這行全部
#      FOR g_i = 1 TO 3
#         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj20
#              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj19
#              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.faj02
#              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.faj022
#              OTHERWISE LET l_order[g_i] = '-'
#         END CASE
#      END FOR
#      LET sr.order1 = l_order[1]
#      LET sr.order2 = l_order[2]
#      LET sr.order3 = l_order[3]
#      OUTPUT TO REPORT r104_rep(sr.*)
#No.FUN-710083 --end
     END FOREACH
#No.FUN-710083 --begin
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'faj20,faj19,faj02,faj022')
          RETURNING tm.wc
     LET g_str = tm.wc,";",g_zz05,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3]
     LET g_str = g_str,";",tm.s[4,4],";",tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.t[4,4]
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED    #TQC-730088
   # CALL cl_prt_cs3('afar104',l_sql,g_str)
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    #TQC-C10034--add--begin
     LET g_cr_table = l_table
     LET g_cr_apr_key_f = "faj02" 
    #TQC-C10034--add--end
     CALL cl_prt_cs3('afar104','afar104',l_sql,g_str)
 
#    FINISH REPORT r104_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-710083 --end
END FUNCTION
 
#No.FUN-710083 --begin
#REPORT r104_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#          g_head1       STRING,
#          str           STRING,
#          sr            RECORD order1 LIKE faj_file.faj02,       #No.FUN-680070 VARCHAR(10)
#                               order2 LIKE faj_file.faj02,       #No.FUN-680070 VARCHAR(10)
#                               order3 LIKE faj_file.faj02,       #No.FUN-680070 VARCHAR(10)
#                               #MOD-4A0112
#                               fas03 LIKE fas_file.fas03,
#                               fas04 LIKE fas_file.fas04,
#                               fas05 LIKE fas_file.fas05,
#                               fas01 LIKE fas_file.fas01,
#                               #MOD-4A0112
#                               faj02 LIKE faj_file.faj02,   #財編
#                               faj022 LIKE faj_file.faj022, #附號
#                               faj07 LIKE faj_file.faj07,   #英文名稱
#                               faj08 LIKE faj_file.faj08,   #規格型號
#                               faj17 LIKE faj_file.faj17,   #數量
#                               faj21 LIKE faj_file.faj21,   #存放位置
#                               faj26 LIKE faj_file.faj26,   #入帳日期
#                               faj33 LIKE faj_file.faj33,   #未折減額
#                               faj20 LIKE faj_file.faj20,   #保管部門
#                               faj19 LIKE faj_file.faj19    #保管人員
#                        END RECORD,
#          l_faj19  LIKE faj_file.faj19,
#          l_faj20  LIKE faj_file.faj20,
#          l_gen02  LIKE gen_file.gen02,
#          l_gem02  LIKE gem_file.gem02
# 
#  OUTPUT TOP MARGIN 0
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN 6
#         PAGE LENGTH g_page_line
#  ORDER BY sr.faj20,sr.faj19,sr.order1,sr.order2,sr.order3
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
##     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6C0009 mark
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6C0009
#      LET g_head1 = g_x[9] CLIPPED,sr.fas03,'   ',
#                 g_x[10] CLIPPED,sr.fas01 #MOD-4A0112
#      PRINT g_head1
#      LET g_head1 = g_x[11] CLIPPED,sr.fas04,'   ',
#                     g_x[12] CLIPPED,g_today  #MOD-4A0112
#      PRINT g_head1
#      LET g_head1 = g_x[13] CLIPPED,sr.fas05
#      PRINT g_head1
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#            g_x[39]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 13)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 13)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#   BEFORE GROUP OF sr.order3
#      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 13)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#   BEFORE GROUP OF sr.faj19
## genero  script marked       LET g_pageno = 0
#      SKIP TO TOP OF PAGE
#
#   ON EVERY ROW
#      PRINT COLUMN g_c[31],sr.faj02,
#            COLUMN g_c[32],sr.faj022,
#           #COLUMN g_c[33],sr.faj07[1,30],     #TQC-5B0008 mark
#            COLUMN g_c[33],sr.faj07 CLIPPED,   #TQC-5B0008
#            COLUMN g_c[34],sr.faj08[1,23],
#            COLUMN g_c[35],cl_numfor(sr.faj17,35,0),
#            COLUMN g_c[36],sr.faj21,
#            COLUMN g_c[38],sr.faj26,
#            COLUMN g_c[39],cl_numfor(sr.faj33,39,g_azi04)
#      LET l_faj20 = sr.faj20     LET l_faj19 = sr.faj19
# 
### FUN-550114
#   ON LAST ROW
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER
#     #select gem02 into l_gem02 from gem_file where gem01 = l_faj20
#     #if sqlca.sqlcode then let l_gem02 = ' ' end if
#     #select gen02 into l_gen02 from gen_file where gen01 = l_faj19
#     #if sqlca.sqlcode then let l_gen02 = ' ' end if
#     #PRINT g_dash[1,g_len]
#     #LET str = l_faj20,'/',l_gem02
#     #PRINT COLUMN g_c[31],g_x[14] CLIPPED,
#     #      COLUMN g_c[32],str,
#     #      COLUMN g_c[33],g_x[15] CLIPPED;
#     #LET str = l_faj19,'/',l_gen02
#     #PRINT COLUMN g_c[34],g_x[16] CLIPPED,
#     #      COLUMN g_c[35],str,
#     #      COLUMN g_c[36],g_x[17] CLIPPED
#     #SKIP 1 LINE
#     #PRINT COLUMN g_c[31],g_x[18] CLIPPED,
#     #      COLUMN g_c[33],g_x[15] CLIPPED,
#     #      COLUMN g_c[34],g_x[16] CLIPPED,
#     #      COLUMN g_c[36],g_x[17] CLIPPED
#     PRINT g_dash[1,g_len]
#      #No.TQC-6C0009 --start--
#      PRINT g_x[4] CLIPPED;
#      IF l_last_sw = 'y' THEN
#         PRINT COLUMN (g_len-9), g_x[7] CLIPPED
#      ELSE
#         PRINT COLUMN (g_len-9), g_x[6] CLIPPED
#      END IF
#      PRINT
#      #No.TQC-6C0009 --end--
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[14]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[14]
#             PRINT g_memo
#      END IF
### END FUN-550114
#
#END REPORT
#No.FUN-710083 --end
