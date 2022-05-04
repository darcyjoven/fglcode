# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: afar222.4gl
# Descriptions...: 資產分佈清冊
# Date & Author..: 96/06/10 By Charis
# Modify.........: No.CHI-480001 04/08/11 By Danny  增加資產停用選項
# Modify.........: No.FUN-510035 05/01/19 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-610033 06/01/09 By Smapmin 增加營運中心開窗功能
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-B10021 11/01/20 By Summer 改為CR報表
# Modify.........: NO:FUN-B80081 11/11/01 By Sakura faj105相關程式段Mark
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,       # Where condition       #No.FUN-680070 VARCHAR(1000)
              s       LIKE type_file.chr3,          # Order by sequence       #No.FUN-680070 VARCHAR(3)
              t       LIKE type_file.chr3,          # Eject sw       #No.FUN-680070 VARCHAR(3)
              c       LIKE type_file.chr1,          # No.CHI-480001       #No.FUN-680070 VARCHAR(1)
              more    LIKE type_file.chr1           # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              END RECORD,
          g_k     LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
#CHI-B10021 add --start--
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE l_table      STRING
#CHI-B10021 add --end--
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
 
   #CHI-B10021 add --start--
   LET g_sql = "faj04.faj_file.faj04,",          # 財產類別
               "faj02.faj_file.faj02,",          # 財產編號
               "faj022.faj_file.faj022,",        # 財產附號
               "faj06.faj_file.faj06,",          # 中文名稱
               "faj08.faj_file.faj08,",          # 規格型號
               "faj14.faj_file.faj14,",          # 本幣成本
               "faj20.faj_file.faj20,",          # 保管部門
               "gem02.gem_file.gem02,",          # 部門名稱
               "faj19.faj_file.faj19,",          # 保管人
               "gen02.gen_file.gen02,",          # 名稱
               "faj21.faj_file.faj21,",          # 存放位置
               "faf02.faf_file.faf02,",          # 名稱
               "faj22.faj_file.faj22,",          # 存放工廠
               "faj17.faj_file.faj17,",          # 數量
               "faj18.faj_file.faj18,",          # 單位
               "faj26.faj_file.faj26,",
               "faj43.faj_file.faj43"

   LET l_table = cl_prt_temptable('afar222',g_sql) CLIPPED
   IF l_table= -1 THEN EXIT PROGRAM END IF

   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep',status,1) EXIT PROGRAM
   END IF
   #CHI-B10021 add --end--
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)                     #No.CHI-480001
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afar222_tm(0,0)        # Input print condition
      ELSE CALL afar222()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar222_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW afar222_w AT p_row,p_col WITH FORM "afa/42f/afar222"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '123'
   LET tm.t    = 'Y  '
   LET tm.c    = '0'                         #No.CHI-480001
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON faj04,faj02,faj20,faj19,faj26,faj21,faj22,faj14
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
 
     #-----MOD-610033---------
     ON ACTION CONTROLP
        CASE
              WHEN INFIELD(faj22)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_azp"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO faj22
                   NEXT FIELD faj22
        END CASE
     #-----END MOD-610033-----
 
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
         LET INT_FLAG = 0 CLOSE WINDOW afar222_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
      INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
                    tm.c,tm.more WITHOUT DEFAULTS       #No.CHI-480001
 
         #No.CHI-480001
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD c
            IF cl_null(tm.c) OR tm.c NOT MATCHES "[012]" THEN
               NEXT FIELD FORMONLY.c
            END IF
         #end
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" THEN
               NEXT FIELD FORMONLY.more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
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
         LET INT_FLAG = 0 CLOSE WINDOW afar222_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar222'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar222','9031',1)
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
                            " '",tm.c CLIPPED,"'",     #No.CHI-480001
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('afar222',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afar222_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar222()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW afar222_w
END FUNCTION
 
FUNCTION afar222()
   DEFINE l_name    LIKE type_file.chr20,                      # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,                    # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,                       #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,                    #No.FUN-680070 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE type_file.chr21,          #No.FUN-680070 VARCHAR(10)
          sr        RECORD order1 LIKE type_file.chr21,        #No.FUN-680070 VARCHAR(10)
                           order2 LIKE type_file.chr21,        #No.FUN-680070 VARCHAR(10)
                           order3 LIKE type_file.chr21,        #No.FUN-680070 VARCHAR(10)
                           faj04 LIKE faj_file.faj04,          # 財產類別
                           faj02 LIKE faj_file.faj02,          # 財產編號
                           faj022 LIKE faj_file.faj022,        # 財產附號
                           faj06 LIKE faj_file.faj06,          # 中文名稱
                           faj08 LIKE faj_file.faj08,          # 規格型號
                           faj14 LIKE faj_file.faj14,          # 本幣成本
                           faj20 LIKE faj_file.faj20,          # 保管部門
                           gem02 LIKE gem_file.gem02,          # 部門名稱
                           faj19 LIKE faj_file.faj19,          # 保管人
                           gen02 LIKE gen_file.gen02,          # 名稱
                           faj21 LIKE faj_file.faj21,          # 存放位置
                           faf02 LIKE faf_file.faf02,          # 名稱
                           faj22 LIKE faj_file.faj22,          # 存放工廠
                           faj17 LIKE faj_file.faj17,          # 數量
                           faj18 LIKE faj_file.faj18,          # 單位
                           faj26 LIKE faj_file.faj26,
                           faj43 LIKE faj_file.faj43
                    END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #CHI-B10021 add
     CALL cl_del_data(l_table)                                  #CHI-B10021 add
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fajuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fajgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fajgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','',",
                 " faj04, faj02,",
                 " faj022,faj06,faj08,faj14,faj20,gem02,faj19,gen02,",
                 " faj21, faf02,faj22,faj17, faj18, faj26, faj43",
                 "  FROM faj_file,OUTER gem_file,",
                 "   OUTER gen_file,OUTER faf_file",
                 " WHERE fajconf='Y' AND ",tm.wc CLIPPED,
                 #" AND faj43 not IN ('0','5','6','X') ", #No.FUN-B80081 mark
		 " AND faj_file.faj19=gen_file.gen01 AND faj_file.faj20=gem_file.gem01 ",
		 " AND faj_file.faj21=faf_file.faf01 "
 
     #No.CHI-480001
     IF tm.c = '1' THEN    #停用
        #LET l_sql = l_sql CLIPPED," AND faj105 = 'Y' " #No.FUN-B80081 mark
         LET l_sql = l_sql CLIPPED," AND faj43 = 'Z' "  #No.FUN-B80081 add 
     END IF
     IF tm.c = '0' THEN    #正常使用
        LET l_sql = l_sql CLIPPED,
                    #" AND (faj105 = 'N' OR faj105 IS NULL OR faj105 = ' ') " #No.FUN-B80081 mark
                     " AND faj43 NOT IN ('0','5','6','X','Z')" #No.FUN-B80081 add
     END IF
     #end
 
     PREPARE afar222_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar222_curs1 CURSOR FOR afar222_prepare1
 
    #CHI-B10021 mark --start--
    #CALL cl_outnam('afar222') RETURNING l_name
    # 
    #START REPORT afar222_rep TO l_name
    #LET g_pageno = 0
    #CHI-B10021 mark --end--
 
     FOREACH afar222_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
      #CHI-B10021 mark --start--
      #FOR g_i = 1 TO 3
      #   CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj04
      #        WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj02
      #        WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.faj20
      #        WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.faj19
      #        WHEN tm.s[g_i,g_i] = '5'
      #             LET l_order[g_i] = sr.faj26 USING 'yyyymmdd'
      #        WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.faj21
      #        WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.faj22
      #        WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.faj14
      #        OTHERWISE LET l_order[g_i] = '-'
      #   END CASE
      #END FOR
      #LET sr.order1 = l_order[1]
      #LET sr.order2 = l_order[2]
      #LET sr.order3 = l_order[3]
      #OUTPUT TO REPORT afar222_rep(sr.*)
      #CHI-B10021 mark --end--

      #CHI-B10021 add --start--
      EXECUTE insert_prep USING
              sr.faj04,sr.faj02,sr.faj022,sr.faj06,sr.faj08,
              sr.faj14,sr.faj20,sr.gem02,sr.faj19,sr.gen02,
              sr.faj21,sr.faf02,sr.faj22,sr.faj17,sr.faj18,
              sr.faj26,sr.faj43
      #CHI-B10021 add --end--

     END FOREACH
 
    #CHI-B10021 mark --start--
    #FINISH REPORT afar222_rep
    # 
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    #CHI-B10021 mark --end--
    #CHI-B10021 add --start--
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'faj04,faj02,faj20,faj19,faj26,faj21,faj22,faj14')
       RETURNING tm.wc
       LET g_str = tm.wc
    END IF
    LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1],";",
                tm.t[2,2],";",tm.t[3,3]
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('afar222','afar222',g_sql,g_str)

    #CHI-B10021 add --end--
END FUNCTION
 
#CHI-B10021 mark --start--
#REPORT afar222_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,                 #No.FUN-680070 VARCHAR(1)
#          sr           RECORD order1 LIKE type_file.chr21,  #No.FUN-680070 VARCHAR(10)
#                              order2 LIKE type_file.chr21,  #No.FUN-680070 VARCHAR(10)
#                              order3 LIKE type_file.chr21,  #No.FUN-680070 VARCHAR(10)
#                              faj04 LIKE faj_file.faj04,    # 財產類別
#                              faj02 LIKE faj_file.faj02,    # 財產編號
#                              faj022 LIKE faj_file.faj022,  # 財產附號
#                              faj06 LIKE faj_file.faj06,    # 中文名稱
#                              faj08 LIKE faj_file.faj08,    # 規格型號
#                              faj14 LIKE faj_file.faj14,    # 本幣成本
#                              faj20 LIKE faj_file.faj20,    # 保管部門
#                              gem02 LIKE gem_file.gem02,    # 部門名稱
#                              faj19 LIKE faj_file.faj19,    # 保管人
#                              gen02 LIKE gen_file.gen02,    #     名稱
#                              faj21 LIKE faj_file.faj21,    # 存放位置
#                              faf02 LIKE faf_file.faf02,    #     名稱
#                              faj22 LIKE faj_file.faj22,    # 存放工廠
#                              faj17 LIKE faj_file.faj17,    # 數量
#                              faj18 LIKE faj_file.faj18,    # 單位
#                              faj26 LIKE faj_file.faj26,    # 入帳日期
#                              faj43 LIKE faj_file.faj43
#                       END RECORD,
#      l_sts        LIKE type_file.chr8                      #No.FUN-680070 VARCHAR(8)
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2,sr.order3,sr.faj20
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#            g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
# 
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
# 
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
# 
#   BEFORE GROUP OF sr.order3
#      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
# 
#   ON EVERY ROW
#      CASE
#        WHEN sr.faj43 = '1' LET l_sts = g_x[9] clipped
#        WHEN sr.faj43 = '2' LET l_sts = g_x[10] clipped
#        WHEN sr.faj43 = '4' LET l_sts = g_x[11] clipped
#        WHEN sr.faj43 = '7' LET l_sts = g_x[12] clipped
#        OTHERWISE EXIT CASE
#      END CASE
#      PRINT COLUMN g_c[31],sr.faj04,
#            COLUMN g_c[32],sr.faj02,
#            COLUMN g_c[33],sr.faj022,
#            COLUMN g_c[34],sr.faj06,
#            COLUMN g_c[35], sr.faj08,
#            COLUMN g_c[36],sr.gem02,
#            COLUMN g_c[37],sr.gen02,
#            COLUMN g_c[38],sr.faf02[1,10],
#            COLUMN g_c[39],sr.faj22,
#            COLUMN g_c[40],cl_numfor(sr.faj17,40,0),
#            COLUMN g_c[41],sr.faj18,
#            COLUMN g_c[42],sr.faj26,
#            COLUMN g_c[43],l_sts
# 
#   ON LAST ROW
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
# 
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#CHI-B10021 mark --end--
