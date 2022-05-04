# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Descriptions...: 固定資產調整明細表
# Date & Author..: 98/07/23 By Kammy
# Modify.........: No.FUN-510035 05/01/31 By Smapmin 報表轉XML格式
# Modify.........: NO.FUN-590118 06/01/03 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0009 06/12/08 By Rayven 表頭制表日期等位置調整
# Modify.........: No.FUN-780046 07/08/09 By destiny 報表改為使用crystal report
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-920036 09/05/06 By sabrina 財簽、稅簽依畫面選項分開列印
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0447 09/12/30 By Sarah 將畫面上的小計選項拿掉
# Modify.........: No:TQC-A40084 10/04/20 By Carrier table join条件漏了
# Modify.........: No.FUN-B50140 11/05/30 By lixiang 增加財簽二選項
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD                                  # Print condition RECORD
             wc      STRING,                      # Where condition
             s       LIKE type_file.chr3,         # Order by sequence            #No.FUN-680070 VARCHAR(3)
             t       LIKE type_file.chr3,         # Eject sw                     #No.FUN-680070 VARCHAR(3)
            #c       LIKE type_file.chr3,         # print gkf_file detail(Y/N)   #No.FUN-680070 CHAR(3)  #MOD-9C0447 mark
            #u       LIKE type_file.chr1,         #No.FUN-680070 CHAR(1)  #MOD-9C0447 mark
             a       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
             b       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
             d       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
             more    LIKE type_file.chr1          # Input more condition(Y/N)    #No.FUN-680070 VARCHAR(1)
          END RECORD,
       g_dates       LIKE type_file.chr6,         #No.FUN-680070 VARCHAR(6)
       g_datee       LIKE type_file.chr6,         #No.FUN-680070 VARCHAR(6)
       l_bdates      LIKE type_file.dat,          #No.FUN-680070 DATE
       l_bdatee      LIKE type_file.dat,          #No.FUN-680070 DATE
       g_fbc01       LIKE fbc_file.fbc01,         #No.FUN-680070 VARCHAR(10)
       g_total       LIKE type_file.num5,         #No.FUN-680070 DECIMAL(13,3)
       swth          LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       g_str1        LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(15)
       g_str2        LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(15)
       g_str3        LIKE type_file.chr20         #No.FUN-680070 VARCHAR(15)
DEFINE g_i           LIKE type_file.num5          #count/index for any purpose   #No.FUN-680070 SMALLINT
DEFINE g_str         STRING                       #No.FUN-780046
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
 
   LET g_pdate = ARG_VAL(1)             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
  #LET tm.c  = ARG_VAL(10)   #TQC-610055  #MOD-9C0447 mark
   LET tm.a  = ARG_VAL(10)
   LET tm.b  = ARG_VAL(11)
   LET tm.d  = ARG_VAL(12)   
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N' # If background job sw is off
      THEN CALL r210_tm(0,0)            # Input print condition
      ELSE CALL afar210()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
 
FUNCTION r210_tm(p_row,p_col)
DEFINE lc_qbe_sn          LIKE gbm_file.gbm01        #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,       #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000     #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW r210_w AT p_row,p_col WITH FORM "afa/42f/afar210"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                    # Defbclt condition
   LET tm.s    = '3'
  #LET tm.c    = 'Y  '  #MOD-9C0447 mark
   LET tm.t    = 'Y  '
   LET tm.a    = '3'
  #LET tm.b    = '3'    #FUN-920036 mark
   LET tm.b    = '1'    #FUN-920036 add
   LET tm.d    = '3'
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
  #LET tm2.u1   = tm.c[1,1]   #MOD-9C0447 mark
  #LET tm2.u2   = tm.c[2,2]   #MOD-9C0447 mark
  #LET tm2.u3   = tm.c[3,3]   #MOD-9C0447 mark
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
  #IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF   #MOD-9C0447 mark
  #IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF   #MOD-9C0447 mark
  #IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF   #MOD-9C0447 mark
 
   WHILE TRUE
     #DISPLAY BY NAME tm.s,tm.c,tm.t,tm.more,tm.a,tm.b,tm.d   #MOD-9C0447 mark
      DISPLAY BY NAME tm.s,tm.t,tm.more,tm.a,tm.b,tm.d        #MOD-9C0447
      # Condition
      CONSTRUCT BY NAME tm.wc ON faj04,fbd03,fbc01,fbc02
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
         LET INT_FLAG = 0 CLOSE WINDOW r210_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF

     #DISPLAY BY NAME tm.a,tm.b,tm.d,tm.s,tm.c,tm.t,tm.more   #MOD-9C0447 mark
      DISPLAY BY NAME tm.a,tm.b,tm.d,tm.s,tm.t,tm.more        #MOD-9C0447
      # Condition
      INPUT BY NAME
         tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
        #tm2.u1,tm2.u2,tm2.u3,tm.a,tm.b,tm.d,tm.more   #MOD-9C0447 mark
         tm.a,tm.b,tm.d,tm.more                        #MOD-9C0447
         WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
         AFTER FIELD a
            IF tm.a NOT MATCHES "[123]" OR tm.a IS NULL THEN
               NEXT FIELD a
            END IF
         AFTER FIELD b
           #IF tm.b NOT MATCHES "[123]" OR tm.b IS NULL THEN   #FUN-920036 mark
           #IF tm.b NOT MATCHES "[12]" OR tm.b IS NULL THEN    #FUN-920036 add   #FUN-B50140 mark
           #FUN-B50140--add--start
            IF g_faa.faa31='N' AND tm.b='3' THEN
               CALL cl_err('','afar108',0)
               NEXT FIELD b
            END IF
           #FUN-B50140--add--end--
            IF tm.b NOT MATCHES "[123]" OR tm.b IS NULL THEN   #FUN-B50140 add   
               NEXT FIELD b
            END IF
         AFTER FIELD d
            IF tm.d NOT MATCHES "[123]" OR tm.d IS NULL THEN
               NEXT FIELD d
            END IF
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
           #LET tm.c = tm2.u1,tm2.u2,tm2.u3   #MOD-9C0447 mark
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
         LET INT_FLAG = 0 CLOSE WINDOW r210_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='afar210'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar210','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                       #" '",g_lang CLIPPED,"'",  #No.FUN-7C0078
                        " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                       #" '",tm.c CLIPPED,"'",    #MOD-9C0447 mark
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",
                        " '",tm.d CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                        " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar210',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r210_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar210()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r210_w
END FUNCTION
 
FUNCTION afar210()
   DEFINE l_name	LIKE type_file.chr20,           # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0069
          l_sql 	LIKE type_file.chr1000,         # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr		LIKE type_file.chr1,            #No.FUN-680070 VARCHAR(1)
          l_za05	LIKE type_file.chr1000,         #No.FUN-680070 VARCHAR(40)
          l_order	ARRAY[6] OF LIKE fbc_file.fbc01,        #No.FUN-680070 VARCHAR(10)
          sr            RECORD order1 LIKE fbc_file.fbc01,      #No.FUN-680070 VARCHAR(10)
                               order2 LIKE fbc_file.fbc01,      #No.FUN-680070 VARCHAR(10)
                               order3 LIKE fbc_file.fbc01,      #No.FUN-680070 VARCHAR(10)
                               faj04 LIKE faj_file.faj04,	#
                               fbc01 LIKE fbc_file.fbc01,	#
                               fbc02 LIKE fbc_file.fbc02,	#
                               fbc03 LIKE fbc_file.fbc03,	#
                               fbd02 LIKE fbd_file.fbd02,	#
                               fbd03 LIKE fbd_file.fbd03,	#
                               fbd031 LIKE fbd_file.fbd031,     #
                               faj06 LIKE faj_file.faj06,	#
                               fbd04 LIKE fbd_file.fbd04,	#
                               fbd05 LIKE fbd_file.fbd05,	#
                               fbd06 LIKE fbd_file.fbd06,	#
                               fbd07 LIKE fbd_file.fbd07,	#
                               fbd09 LIKE fbd_file.fbd09,	#
                               fbd10 LIKE fbd_file.fbd10,	#
                               fbd11 LIKE fbd_file.fbd11,	#
                               fbd12 LIKE fbd_file.fbd12,	#
                               fag03 LIKE fag_file.fag03	#
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                                        #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fbcuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                                        #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fbcgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN                           #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fbcgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fbcuser', 'fbcgrup')
     #End:FUN-980030
 
 
     IF tm.a='1' THEN LET tm.wc=tm.wc CLIPPED," AND fbcconf='Y' " END IF
     IF tm.a='2' THEN LET tm.wc=tm.wc CLIPPED," AND fbcconf='N' " END IF
  #FUN-920036---add---start---
    #IF tm.b='1' THEN LET tm.wc=tm.wc CLIPPED," AND fbcpost='Y' " END IF
    #IF tm.b='2' THEN LET tm.wc=tm.wc CLIPPED," AND fbcpost='N' " END IF
    #IF tm.d='1' THEN LET tm.wc=tm.wc CLIPPED," AND fbcpost2='Y' " END IF
    #IF tm.d='2' THEN LET tm.wc=tm.wc CLIPPED," AND fbcpost2='N' " END IF
     IF tm.d='1' THEN     #posted
        IF tm.b='1' THEN
           LET tm.wc=tm.wc CLIPPED," AND fbcpost='Y' "   #財簽
        END IF     #FUN-B50140 ADD
     #  ELSE       #FUN-B50140 MARK
        IF tm.b='2' THEN   #FUN-B50140 ADD 
           LET tm.wc=tm.wc CLIPPED," AND fbcpost2='Y' "  #稅簽
        END IF
     #FUN-B50140--ADD--START--
        IF tm.b='3' THEN
           LET tm.wc=tm.wc CLIPPED," AND fbcpost='Y' "   #財簽二
        END IF
     #FUN-B50140--ADD--END--
     END IF
     IF tm.d='2' THEN     #unposted
        IF tm.b='1' THEN
           LET tm.wc=tm.wc CLIPPED," AND fbcpost='N' "   #財簽
        END IF      #FUN-B50140 ADD
      # ELSE        #FUN-B50140 MARK
        IF tm.b='2' THEN   #FUN-B50140 ADD 
           LET tm.wc=tm.wc CLIPPED," AND fbcpost2='N' "  #稅簽
        END IF
     #FUN-B50140--ADD--START--
        IF tm.b='3' THEN
           LET tm.wc=tm.wc CLIPPED," AND fbcpost='N' "   #財簽二
        END IF
     #FUN-B50140--ADD--END--
     END IF
  #FUN-920036---add---end---
 
    #LET l_sql = "SELECT '','','',",     #FUN-920036 mark
    #            "   faj04,fbc01,fbc02,fbc03,fbd02,fbd03,fbd031,",  #FUN-920036 mark
     IF tm.b='1' THEN             #財簽 #FUN-920036 add
        LET l_sql = "SELECT faj04,fbc01,fbc02,fbc03,fbd02,fbd03,fbd031,",  #FUN-920036 add
                    "       faj06,fbd04,fbd05,fbd06,fbd07,fbd09,fbd10,",
                    "       fbd11,fbd12,fag03",
                    #No.TQC-A40084  --Begin
                    "  FROM fbc_file,fbd_file LEFT OUTER JOIN faj_file ",
                    "                         ON fbd03 = faj02 AND fbd031 = faj022 " ,                                   
                    "                         LEFT OUTER JOIN fag_file ",   
                    "                         ON fag01 = fbd24  " ,                                     
                    #No.TQC-A40084  --End  
                    " WHERE fbc01 = fbd01 " ,                                     
                    "   AND fbcconf <> 'X' ",                                     
                    "   AND  ", tm.wc       
     END IF     #FUN-B50140 add
    #FUN-920036---add---start---
    #ELSE      #稅簽     #FUN-B50140 mark
     IF tm.b='2' THEN    #FUN-B50140 ADD 
        LET l_sql = "SELECT faj04,fbc01,fbc02,fbc03,fbd02,fbd03,fbd031,",
                    "       faj06,fbd14,fbd15,fbd16,fbd17,fbd19,fbd20,",
                    "       fbd21,fbd22,fag03",
                    #No.TQC-A40084  --Begin
                    "  FROM fbc_file,fbd_file LEFT OUTER JOIN faj_file ",
                    "                         ON fbd03 = faj02 AND fbd031 = faj022 " ,                                   
                    "                         LEFT OUTER JOIN fag_file ",   
                    "                         ON fag01 = fbd24  " ,                                     
                    #No.TQC-A40084  --End  
                    " WHERE fbc01 = fbd01 " ,
                    "   AND fbcconf <> 'X' ",
                    "   AND  ", tm.wc
     END IF
     #FUN-920036---add---end---
     #FUN-B50140---add-start---
     IF tm.b='3' THEN
        LET l_sql = "SELECT faj04,fbc01,fbc02,fbc03,fbd02,fbd03,fbd031,",
                    "       faj06,fbd042,fbd052,fbd062,fbd072,fbd092,fbd102,",
                    "       fbd112,fbd122,fag03",
                    "  FROM fbc_file,fbd_file LEFT OUTER JOIN faj_file ",
                    "                         ON fbd03 = faj02 AND fbd031 = faj022 " ,
                    "                         LEFT OUTER JOIN fag_file ",
                    "                         ON fag01 = fbd24  " ,
                    " WHERE fbc01 = fbd01 " ,
                    "   AND fbcconf <> 'X' ",
                    "   AND  ", tm.wc
     END IF
     #FUN-B50140---add--END--
#No.FUN-780046-start--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    
     IF g_zz05 = 'Y' THEN  
        CALL cl_wcchp(tm.wc,'faj04,fbd03,fbc01,fbc02') 
        RETURNING tm.wc   
        LET g_str = tm.wc  
     END IF
     LET g_str =g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1],";",                                                  
                tm.t[2,2],";",tm.t[3,3],";",g_azi04                                                                                 
    #CALL cl_prt_cs1('afar210','afar210',l_sql,g_str)    #FUN-920036 mark
    #FUN-920036---add---start---
     IF tm.b='1' THEN    #財簽
        CALL cl_prt_cs1('afar210','afar210',l_sql,g_str)
     END IF      #FUN-B50140 ADD
    #ELSE                #稅簽     #FUN-B50140 MARK
     IF tm.b='2' THEN     #FUN-B50140 ADD
        CALL cl_prt_cs1('afar210','afar210_1',l_sql,g_str)
     END IF
     #FUN-B50140--ADD--START--
     IF tm.b='3' THEN
         CALL cl_prt_cs1('afar210','afar210_2',l_sql,g_str)
     END IF
     #FUN-B50140--ADD--END--- 
    #FUN-920036---add---end---
 
    {LET  g_total = 0
 
     PREPARE r210_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r210_cs1 CURSOR FOR r210_prepare1
     CALL cl_outnam('afar210') RETURNING l_name
 
     START REPORT r210_rep TO l_name
     LET g_pageno = 0
 
     IF NOT cl_null(tm.s[1,1]) THEN
        LET g_i=tm.s[1,1] LET g_str1=g_x[17+g_i]
     END IF
     IF NOT cl_null(tm.s[2,2]) THEN
        LET g_i=tm.s[2,2] LET g_str2=g_x[17+g_i]
     END IF
     IF NOT cl_null(tm.s[3,3]) THEN
        LET g_i=tm.s[3,3] LET g_str3=g_x[17+g_i]
     END IF
 
     FOREACH r210_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj04
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.fbd03
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.fbc01
               WHEN tm.s[g_i,g_i] = '4'
                    LET l_order[g_i] = sr.fbc02 USING 'yyyymmdd'
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
  #    INITIALIZE g_fbc01 TO NULL
       OUTPUT TO REPORT r210_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r210_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)}
#No.FUN-780046--end--
END FUNCTION
#No.FUN-780046--start--
{REPORT r210_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_str         LIKE type_file.chr50,        #列印排列順序說明         #No.FUN-680070 VARCHAR(50)
          l_str1        LIKE type_file.chr20,        #列印合計的前置說明       #No.FUN-680070 VARCHAR(10)
          l_str2        LIKE type_file.chr20,        #列印合計的前置說明       #No.FUN-680070 VARCHAR(10)
          l_str3        LIKE type_file.chr20,        #列印合計的前置說明       #No.FUN-680070 VARCHAR(10)
          l_total       LIKE type_file.num20_6,      #No.FUN-680070 DECIMAL(12,3),
          sq1           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          sq2           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          sq3           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          sr               RECORD order1 LIKE fbc_file.fbc01,   #No.FUN-680070 VARCHAR(10)
                                  order2 LIKE fbc_file.fbc01,   #No.FUN-680070 VARCHAR(10)
                                  order3 LIKE fbc_file.fbc01,   #No.FUN-680070 VARCHAR(10)
                                  faj04 LIKE faj_file.faj04,	#
                                  fbc01 LIKE fbc_file.fbc01,	#
                                  fbc02 LIKE fbc_file.fbc02,	#
                                  fbc03 LIKE fbc_file.fbc03,	#
                                  fbd02 LIKE fbd_file.fbd02,	#
                                  fbd03 LIKE fbd_file.fbd03,	#
                                  fbd031 LIKE fbd_file.fbd031,  #
                                  faj06 LIKE faj_file.faj06,	#
                                  fbd04 LIKE fbd_file.fbd04,	#
                                  fbd05 LIKE fbd_file.fbd05,	#
                                  fbd06 LIKE fbd_file.fbd06,	#
                                  fbd07 LIKE fbd_file.fbd07,	#
                                  fbd09 LIKE fbd_file.fbd09,	#
                                  fbd10 LIKE fbd_file.fbd10,	#
                                  fbd11 LIKE fbd_file.fbd11,	#
                                  fbd12 LIKE fbd_file.fbd12,	#
                                  fag03 LIKE fag_file.fag03	#
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3 ,sr.fbc01 #,sr.fbd02
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6C0009 mark
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6C0009
      PRINT g_dash[1,g_len]
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
                     g_x[38],g_x[39],g_x[40],g_x[41]
      PRINTX name=H2 g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],
                     g_x[49],g_x[50],g_x[51],g_x[52]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
 
     BEFORE GROUP OF sr.fbc01
        PRINTX name=D1 COLUMN g_c[31],sr.fbc01 CLIPPED,
              COLUMN g_c[32],sr.fbc02 ;
 
   ON EVERY ROW
         PRINTX name=D1 COLUMN g_c[33],sr.fbc03 CLIPPED,
               COLUMN g_c[34],sr.fbd02 USING '###&', #FUN-590118
               COLUMN g_c[35],sr.fbd03 CLIPPED,
               COLUMN g_c[36],sr.fbd031 CLIPPED,
               COLUMN g_c[37],sr.faj06[1,20] CLIPPED,
               COLUMN g_c[38],cl_numfor(sr.fbd04,38,g_azi04) CLIPPED,
               COLUMN g_c[39],cl_numfor(sr.fbd05,39,g_azi04) CLIPPED,
               COLUMN g_c[40],sr.fbd06 USING '########' CLIPPED,
               COLUMN g_c[41],cl_numfor(sr.fbd07,41,g_azi04) CLIPPED
        PRINTX name=D2  COLUMN g_c[44],sr.fag03 CLIPPED,
               COLUMN g_c[49],cl_numfor(sr.fbd09,49,g_azi04) CLIPPED ,
               COLUMN g_c[50],cl_numfor(sr.fbd10,50,g_azi04) CLIPPED,
               COLUMN g_c[51],sr.fbd11 USING '########' CLIPPED,
               COLUMN g_c[52],cl_numfor(sr.fbd12,52,g_azi04)
#  AFTER GROUP OF sr.order1
#     IF tm.c[1,1] = 'Y'  AND tm.c[1,1] = 'Y' THEN
#        NEED  2 LINES
#        PRINT
#        PRINT g_str1 CLIPPED
#      END IF
 
#  AFTER GROUP OF sr.order2
#     IF tm.c[2,2] = 'Y'  AND tm.c[2,2] = 'Y' THEN
#        NEED 2 LINES
#        PRINT
#        PRINT g_str2 CLIPPED
      #        73 SPACES,
      #        GROUP SUM(sr.fbc06) USING '#######&',' ',
      #        GROUP SUM(sr.fbc07) USING '#######&'
      #  PRINT COLUMN 89,"-------- --------"
#     END IF
 
#  AFTER GROUP OF sr.order3
#     IF tm.c[3,3] = 'Y' AND tm.c[3,3] = 'Y' THEN
##       NEED 2 LINES
#        PRINT
#        PRINT g_str3 CLIPPED
     #         73 SPACES,
     #         GROUP SUM(sr.fbc06) USING '#######&',' ',
     #         GROUP SUM(sr.fbc07) USING '#######&'
     #   PRINT COLUMN 89,"-------- --------"
#     END IF
 
ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN
              PRINT g_dash[1,g_len]
            #-- TQC-630166 begin
#             IF tm.wc[001,070] > ' ' THEN			# for 80
#	         PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#             IF tm.wc[071,140] > ' ' THEN
# 	         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#             IF tm.wc[141,210] > ' ' THEN
# 	         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#             IF tm.wc[211,280] > ' ' THEN
# 	         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
              #IF tm.wc[001,120] > ' ' THEN			# for 132
 	      #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
              #IF tm.wc[121,240] > ' ' THEN
              #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
              #IF tm.wc[241,300] > ' ' THEN
 	      #   PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
              CALL cl_prt_pos_wc(tm.wc)
            #-- TQC-630166 end
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
    IF l_last_sw = 'n'
        THEN PRINT g_dash[1,g_len]
             PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
        ELSE SKIP 2 LINES
     END IF
END REPORT}
#No.FUN-780046--end--
