# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: afar109.4gl
# Desc/riptions..: 固定資產銷帳申請單
# Date & Author..: 96/06/11 By Kitty
# Modify.........: No.CHI-480001 04/08/16 By Danny   新增大陸版報表段(減值準備)
# Modify.........: No.FUN-510035 05/01/31 By Smapmin 調整單價,匯率,金額位數
# Modify.........: No.FUN-550102 05/05/25 By echo 新增報表備註
# Modify.........: No.FUN-580010 05/08/02 By vivien 憑証類報表轉XML
# Modify.........: No.FUN-5A0180 05/10/25 By Claire 報表調整可印Font 10
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710083 07/01/31 By Judy Crystal Report修改
# Modify.........: No.TQC-730088 07/03/22 By Nicole 增加 CR參數
# Modify.........: No.FUN-920036 09/05/06 By sabrina 財簽、稅簽依畫面選項分開列印
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50140 11/05/30 By lixiang 增加財簽二選項
# Modify.........: No.TQC-C10034 12/01/19 By zhuhao CR報表簽核 
# Modify.........: No.TQC-BC0033 12/03/02 By Elise 加入財產編號說明
# Modify.........: No.CHI-C60010 12/06/14 By wangrr 財簽二欄位需依財簽二幣別做取位

DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580010 --start
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-560079
  DEFINE g_seq_item    LIKE type_file.num5         #No.FUN-680070 SMALLINT
END GLOBALS
 
#No.FUN-580010 --end
 
    DEFINE tm  RECORD				# Print condition RECORD
       	    	wc     	LIKE type_file.chr1000,		# Where condition       #No.FUN-680070 VARCHAR(1000)
                a       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    	        b    	LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    	        d    	LIKE type_file.chr1,         #No.FUN-920036 VARCHAR(1)
                more    LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
              END RECORD,
          g_zo          RECORD LIKE zo_file.*
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
#FUN-710083....begin
DEFINE   g_sql      STRING
DEFINE   l_table    STRING
DEFINE   g_str      STRING
#FUN-710083....end
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
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   LET tm.d = ARG_VAL(14)      #FUN-920036 add
 
#FUN-710083.....begin
   LET g_sql = "fbg01.fbg_file.fbg01,",
               "fbg02.fbg_file.fbg02,",
               "fbg03.fbg_file.fbg03,",
               "fbg04.fbg_file.fbg04,",
               "fbh03.fbh_file.fbh03,",
               "fbh031.fbh_file.fbh031,",
               "fbh04.fbh_file.fbh04,",
               "fbh05.fbh_file.fbh05,",
               "faj06.faj_file.faj06,",
               "faj061.faj_file.faj061,",
               "faj07.faj_file.faj07,",
               "faj071.faj_file.faj071,",
               "faj08.faj_file.faj08,",
               "faj19.faj_file.faj19,",
               "faj20.faj_file.faj20,",
               "faj26.faj_file.faj26,",
               "faj38.faj_file.faj38,",
               "faj89.faj_file.faj89,",
               "cost.faj_file.faj60,",
               "tot_dep.faj_file.faj60,",
               "faj17.faj_file.faj17,",
               "faj85.faj_file.faj85,",
               "faj81.faj_file.faj81,",
               "faj84.faj_file.faj84,",
               "fbh12.fbh_file.fbh12,",
               "cost2.faj_file.faj60,",
               "l_gen02.gen_file.gen02,",
               "m_faj20.gem_file.gem02,",
               "m_fbh05.fag_file.fag03,",
               "l_gem02a.gem_file.gem02,",
               "l_gen02a.gen_file.gen02,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
              #TQC-C10034---add---begin
               "sign_type.type_file.chr1,",
               "sign_img.type_file.blob,",      
               "sign_show.type_file.chr1,",
               "sign_str.type_file.chr1000,",
              #TQC-C10034---add---end
               "l_faj06.faj_file.faj06" #TQC-BC0033
   LET l_table = cl_prt_temptable('afar109',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?, ? )"  #TQC-C10034 add 4?   #TQC-BC0033 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#FUN-710083.....end   
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r109_tm(0,0)		# Input print condition
      ELSE CALL afar109()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION r109_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000       #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r109_w AT p_row,p_col WITH FORM "afa/42f/afar109"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a    = '3'
  #LET tm.b    = '3'      #FUN-920036 mark
   LET tm.b    = '1'      #FUN-920036 add
   LET tm.d    = '3'      #FUN-920036 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fbg01,fbg02,fbg03,fbg04,fbg05
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
         LET INT_FLAG = 0 CLOSE WINDOW r109_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.a,tm.b,tm.d,tm.more WITHOUT DEFAULTS     #FUN-920036 add tm.d
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES "[123]" THEN
               NEXT FIELD a
            END IF
 
         AFTER FIELD b
           #IF cl_null(tm.b) OR tm.b NOT MATCHES "[123]" THEN    #FUN-920036 mark
           #IF cl_null(tm.b) OR tm.b NOT MATCHES "[12]" THEN     #FUN-920036 add   #FUN-B50140 mark
           #FUN-B50140--add-start--
            IF g_faa.faa31='N' AND tm.b='3' THEN
               CALL cl_err('','afar108',0)
               NEXT FIELD b
            END IF
           #FUN-B50140--add-end--
            IF cl_null(tm.b) OR tm.b NOT MATCHES "[123]" THEN    #FUN-B50140 add
               NEXT FIELD b
            END IF
 
        #FUN-920036---add---start---
         AFTER FIELD d
            IF tm.d NOT MATCHES "[123]" OR tm.d IS NULL THEN
               NEXT FIELD d
            END IF
        #FUN-920036---add---end---
 
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
         LET INT_FLAG = 0 CLOSE WINDOW r109_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='afar109'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar109','9031',1)
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
                            " '",tm.a CLIPPED,"'",
                            " '",tm.b CLIPPED,"'" ,
                            " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                            " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                            " '",g_template CLIPPED,"'",           #No.FUN-570264
                            " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                            " '",tm.d CLIPPED,"'"                  #No.FUN-920036 add
            CALL cl_cmdat('afar109',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r109_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar109()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r109_w
END FUNCTION
 
FUNCTION afar109()
    DEFINE
        l_i             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        l_name          LIKE type_file.chr20,        # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
        l_za05          LIKE za_file.za05,           #No.FUN-680070 VARCHAR(40)
#       l_time        LIKE type_file.chr8	            #No.FUN-6A0069
        l_sql 	        LIKE type_file.chr1000,	     # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
        m_faj20         LIKE gem_file.gem02,         #FUN-710083
        l_gem02a        LIKE gem_file.gem02,         #FUN-710083
        m_fbh05         LIKE fag_file.fag03,         #FUN-710083
        l_gen02         LIKE gen_file.gen02,         #FUN-710083
        l_gen02a        LIKE gen_file.gen02,         #FUN-710083
        l_chr		LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        sr              RECORD
                           fbg01    LIKE fbg_file.fbg01,   #出售單號
                           fbg02    LIKE fbg_file.fbg02,   #出售日期
                           fbg03    LIKE fbg_file.fbg03,   #銷售客戶
                           fbg04    LIKE fbg_file.fbg04,
                           fbh03    LIKE fbh_file.fbh03,   #財產編號
                           fbh031   LIKE fbh_file.fbh031,  #附號
                           fbh04    LIKE fbh_file.fbh04,   #數量
                           fbh05    LIKE fbh_file.fbh05,   #原因
                           faj06    LIKE faj_file.faj06,   #中文名稱
                           faj061   LIKE faj_file.faj061,  #中文名稱-2
                           faj07    LIKE faj_file.faj07,   #英文名稱-1
                           faj071   LIKE faj_file.faj071,  #英文名稱-2
                           faj08    LIKE faj_file.faj08,   #規格型號
                           faj19    LIKE faj_file.faj19,   #保管人
                           faj20    LIKE faj_file.faj20,   #保管部門
                           faj26    LIKE faj_file.faj26,   #入帳日期
                           faj38    LIKE faj_file.faj38,   #保稅否
                           faj89    LIKE faj_file.faj89,   #抵押文號
                           cost     LIKE faj_file.faj60,   #No.CHI-480001
                           tot_dep  LIKE faj_file.faj60,   #No.CHI-480001
                           faj17    LIKE faj_file.faj17,   #數量
                           faj85    LIKE faj_file.faj85,   #投抵文號
                           faj81    LIKE faj_file.faj81,   #抵減金額
                           faj84    LIKE faj_file.faj84,   #抵減日期
                           fbh12    LIKE fbh_file.fbh12,   #減值準備 #No.CHI-480001
                           cost2    LIKE faj_file.faj60    #資產淨額 #No.CHI-480001
                        END RECORD
     DEFINE l_cnt,i            LIKE type_file.num5         #No.FUN-680070 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02
    define faj record like faj_file.*
    define yyyymm LIKE type_file.chr6         #No.FUN-680070 VARCHAR(6)
    DEFINE l_faj06 LIKE faj_file.faj06        #TQC-BC0033
    DEFINE l_azi04  LIKE azi_file.azi04   #CHI-C60010 add
    DEFINE l_azi05  LIKE azi_file.azi05   #CHI-C60010 add
   #TQC-C10034--add--begin
    DEFINE l_img_blob     LIKE type_file.blob
    LOCATE l_img_blob IN MEMORY
   #TQC-C10034--add--end
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    CALL cl_del_data(l_table)     #FUN-710083
 
    #====>資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET tm.wc = tm.wc CLIPPED," AND fbguser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET tm.wc = tm.wc CLIPPED," AND fbggrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET tm.wc = tm.wc CLIPPED," AND fbggrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fbguser', 'fbggrup')
    #End:FUN-980030
    
   #FUN-920036---add---start---
    IF tm.a='1' THEN LET tm.wc=tm.wc CLIPPED," AND fbgconf='Y' " END IF
    IF tm.a='2' THEN LET tm.wc=tm.wc CLIPPED," AND fbgconf='N' " END IF
    IF tm.d='1' THEN     #posted
       IF tm.b='1' THEN
          LET tm.wc=tm.wc CLIPPED," AND fbgpost='Y' "   #財簽
       END IF    #FUN-B50140 add
     # ELSE      #FUN-B50140 mark
       IF tm.b='2' THEN   #FUN-B50140 add
          LET tm.wc=tm.wc CLIPPED," AND fbgpost2='Y' "  #稅簽
       END IF
     #FUN-B50140--add--start--
       IF tm.b='3' THEN
          LET tm.wc=tm.wc CLIPPED," AND fbgpost='Y' "   #財簽二
       END IF
     #FUN-B50140--add--end--  
    END IF
    IF tm.d='2' THEN     #unposted
       IF tm.b='1' THEN
          LET tm.wc=tm.wc CLIPPED," AND fbgpost='N' "   #財簽
       END IF    #FUN-B50140 add
    #  ELSE      #FUN-B50140 mark
       IF tm.b='2' THEN   #FUN-B50140 add    
          LET tm.wc=tm.wc CLIPPED," AND fbgpost2='N' "  #稅簽
       END IF
     #FUN-B50140--add--start--
       IF tm.b='3' THEN
          LET tm.wc=tm.wc CLIPPED," AND fbgpost='N' "   #財簽二
       END IF
     #FUN-B50140--add--end--
    END IF
   #FUN-920036---add---end---
 
    IF tm.b = '1' THEN    #財簽    #FUN-920036 add
       LET l_sql="SELECT fbg01,fbg02,fbg03,fbg04,fbh03,fbh031,fbh04,",
                 " fbh05,faj06,faj061,faj07,faj071,faj08,faj19,",
                 " faj20,faj26,faj38,faj89,fbh06,fbh07,",
                 " faj17,faj85,faj81,faj84,fbh12,0 ",      #No.CHI-480001 #FUN-710083
                 "  FROM fbg_file,fbh_file,faj_file ",
                 " WHERE fbg01=fbh01 AND fbh03=faj02 AND fbh031=faj022 ",
                 "   AND fbgconf <> 'X' ",
                 "   AND fbg00 = '2' ",     #FUN-920036
                 "   AND ", tm.wc CLIPPED
    END IF    #FUN-B50140 add
   #FUN-920036---add---start---
  # ELSE           #稅簽   #FUN-B50140 mark
    IF tm.b='2' THEN     #稅簽     #FUN-B50140 add 
       LET l_sql="SELECT fbg01,fbg02,fbg03,fbg04,fbh03,fbh031,fbh04,",
                 " fbh05,faj06,faj061,faj07,faj071,faj08,faj19,",
                 " faj20,faj26,faj38,faj89,fbh09,fbh10,",
                 " faj17,faj85,faj81,faj84,fbh12,0 ",      #No.CHI-480001 #FUN-710083
                 "  FROM fbg_file,fbh_file,faj_file ",
                 " WHERE fbg01=fbh01 AND fbh03=faj02 AND fbh031=faj022 ",
                 "   AND fbgconf <> 'X' ",
                 "   AND fbg00='2' ",
                 "   AND ", tm.wc CLIPPED
    END IF
   #FUN-920036---add---end---
   #FUN-B50140--add--start--
    IF tm.b='3' THEN
       LET l_sql="SELECT fbg01,fbg02,fbg03,fbg04,fbh03,fbh031,fbh04,",
                 " fbh05,faj06,faj061,faj07,faj071,faj08,faj19,",
                 " faj20,faj26,faj38,faj89,fbh062,fbh072,",
                 " faj17,faj85,faj81,faj84,fbh12,0 ", 
                 "  FROM fbg_file,fbh_file,faj_file ",
                 " WHERE fbg01=fbh01 AND fbh03=faj02 AND fbh031=faj022 ",
                 "   AND fbgconf <> 'X' ",
                 "   AND fbg00 = '2' ",     
                 "   AND ", tm.wc CLIPPED
    END IF
   #FUN-B50140--add--end--         
   #FUN-920036---mark---start---
   #IF tm.a='1' THEN LET l_sql=l_sql CLIPPED," AND fbgconf='Y' " END IF
   #IF tm.a='2' THEN LET l_sql=l_sql CLIPPED," AND fbgconf='N' " END IF
   #IF tm.b='1' THEN LET l_sql=l_sql CLIPPED," AND fbgpost='Y' " END IF
   #IF tm.b='2' THEN LET l_sql=l_sql CLIPPED," AND fbgpost='N' " END IF
   #FUN-920036---mark---end---
 
    PREPARE r109_p1 FROM l_sql                # RUNTIME 編譯
        IF STATUS THEN CALL cl_err('prepare:',STATUS,0) RETURN END IF
     DECLARE r109_co  CURSOR FOR r109_p1
#FUN-710083.....begin mark
#     SELECT * INTO g_zo.* FROM zo_file WHERE zo01=g_rlang
#     CALL cl_outnam('afar109') RETURNING l_name
#No.FUN-580010 --start
           #FUN-5A0180-begin
           #IF g_aza.aza26 = '2' THEN
           # LET g_zaa[44].zaa06 = "Y"
	   # LET g_zaa[45].zaa06 = "Y"
	   # LET g_zaa[46].zaa06 = "Y"
	   # LET g_zaa[47].zaa06 = "Y"
           # LET g_zaa[55].zaa06 = "N"
           # LET g_zaa[56].zaa06 = "N"
           # LET g_zaa[57].zaa06 = "N"
           # LET g_zaa[58].zaa06 = "N"
           # LET g_zaa[59].zaa06 = "N"
           #ELSE
           # LET g_zaa[44].zaa06 = "N"
	   # LET g_zaa[45].zaa06 = "N"
	   # LET g_zaa[46].zaa06 = "N"
	   # LET g_zaa[47].zaa06 = "N"
           # LET g_zaa[55].zaa06 = "Y"
           # LET g_zaa[56].zaa06 = "Y"
           # LET g_zaa[57].zaa06 = "Y"
           # LET g_zaa[58].zaa06 = "Y"
           # LET g_zaa[59].zaa06 = "Y"
#           IF g_aza.aza26 = '2' THEN
#	    LET g_zaa[45].zaa06 = "Y"
#            LET g_zaa[55].zaa06 = "N"
#           ELSE
#	    LET g_zaa[45].zaa06 = "N"
#            LET g_zaa[55].zaa06 = "Y"
#           END IF
#      CALL cl_prt_pos_len()
#No.FUN-580010 --end
 
#     START REPORT r109_rep TO l_name
#     LET g_pageno = 0
#FUN-710083.....end mark
#CHI-C60010--add--str--#財簽二帳套對應的幣別小數位數
   IF g_faa.faa31='Y' THEN
      SELECT azi04,azi05 INTO l_azi04,l_azi05 FROM azi_file,aaa_file
       WHERE azi01=aaa03 AND aaa01=g_faa.faa02c
   END IF
#CHI-C60010--add--end

    FOREACH r109_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET yyyymm=g_faa.faa07 using "&&&&",g_faa.faa08 using "&&"
        #No.CHI-480001
        IF cl_null(sr.fbh12) THEN LET sr.fbh12 = 0 END IF
        LET sr.cost2 = sr.cost - sr.tot_dep - sr.fbh12
        #end
#FUN-710083.....begin
        SELECT gem02 INTO m_faj20 FROM gem_file WHERE gem01=sr.faj20         
        IF STATUS=100 THEN LET m_faj20=' ' END IF
        SELECT fag03 INTO m_fbh05 FROM fag_file WHERE fag01=sr.fbh05         
        IF STATUS=100 THEN LET m_fbh05=' ' END IF
        SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.faj19         
        IF SQLCA.sqlcode THEN LET l_gen02 = ' ' END IF
        SELECT gen02 INTO l_gen02a FROM gen_file WHERE gen01=sr.fbg03
        IF SQLCA.sqlcode THEN LET l_gen02a = ' ' END IF
        SELECT gem02 INTO l_gem02a FROM gem_file WHERE gem01=sr.fbg04         
        IF STATUS=100 THEN LET l_gem02a=' ' END IF

       #TQC-BC0033 --start--
        LET l_faj06=''
        SELECT faj06 INTO l_faj06 FROM faj_file
         WHERE faj02 = sr.fbh03

       #TQC-BC0033 --end--
     #CHI-C60010--add--str--#財簽二
        IF tm.b='3' THEN
           EXECUTE insert_prep USING sr.*,l_gen02,m_faj20,m_fbh05,l_gem02a,l_gen02a,l_azi04,l_azi05,
                                     "",  l_img_blob,   "N","",l_faj06
        ELSE
     #CHI-C60010--add--end
        EXECUTE insert_prep USING sr.*,l_gen02,m_faj20,m_fbh05,l_gem02a,l_gen02a,g_azi04,g_azi05,
                                  "",  l_img_blob,   "N","",   #TQC-C10034  add
                                  l_faj06                      #TQC-BC0033 add l_faj06
        END IF   #CHI-C60010 add
#        OUTPUT TO REPORT r109_rep(sr.*,sr.tot_dep,yyyymm)
    END FOREACH
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    CALL cl_wcchp(tm.wc,'fbg01,fbg02,fbg03,fbg04,fbg05')
         RETURNING tm.wc
   #LET g_str = tm.wc,";",yyyymm,";",g_zz05              #FUN-920036 mark
    LET g_str = tm.wc,";",yyyymm,";",g_zz05,";",tm.b     #FUN-920036 add
  # LET l_sql = "SELECT * FROM ",l_table CLIPPED    #TQC-730088
  # CALL cl_prt_cs3('afar109',l_sql,g_str)
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    #TQC-C10034--add--begin
    LET g_cr_table = l_table
    LET g_cr_apr_key_f = "fbg01" 
    #TQC-C10034--add--end
    CALL cl_prt_cs3('afar109','afar109',l_sql,g_str)
 
#    FINISH REPORT r109_rep
 
#    CALL cl_prt(l_name,' ','1',g_len)
#FUN-710083.....end
END FUNCTION
#FUN-710083.....begin mark
#REPORT r109_rep(sr,p_faj32,p_yyyymm)
#    DEFINE
#        m_faj20         LIKE gem_file.gem02,
#        m_fbh05         LIKE fag_file.fag03,
#        m_faj38         LIKE faj_file.faj38,            #No.FUN-680070 VARCHAR(06)
#        sr              RECORD
#                        fbg01    LIKE fbg_file.fbg01,   #出售單號
#                        fbg02    LIKE fbg_file.fbg02,   #出售日期
#                        fbg03    LIKE fbg_file.fbg03,   #銷售客戶
#                        fbh03    LIKE fbh_file.fbh03,   #財產編號
#                        fbh031   LIKE fbh_file.fbh031,  #附號
#                        fbh04    LIKE fbh_file.fbh04,   #數量
#                        fbh05    LIKE fbh_file.fbh05,   #原因
#                        faj06    LIKE faj_file.faj06,   #中文名稱
#                        faj061   LIKE faj_file.faj061,  #中文名稱-2
#                        faj07    LIKE faj_file.faj07,   #英文名稱-1
#                        faj071   LIKE faj_file.faj071,  #英文名稱-2
#                        faj08    LIKE faj_file.faj08,   #規格型號
#                        faj19    LIKE faj_file.faj19,   #保管人
#                        faj20    LIKE faj_file.faj20,   #保管部門
#                        faj26    LIKE faj_file.faj26,   #入帳日期
#                        faj38    LIKE faj_file.faj38,   #保稅否
#                        faj89    LIKE faj_file.faj89,   #抵押文號
#                        cost     LIKE faj_file.faj60,   #No.CHI-480001
#                        tot_dep  LIKE faj_file.faj60,   #No.CHI-480001
#                        faj17    LIKE faj_file.faj17,   #數量
#                        faj85    LIKE faj_file.faj85,   #投抵文號
#                        faj81    LIKE faj_file.faj81,   #抵減金額
#                        faj84    LIKE faj_file.faj84,   #抵減日期
#                        fbh12    LIKE fbh_file.fbh12,   #減值準備 #No.CHI-480001
#                        cost2    LIKE faj_file.faj60    #資產淨額 #No.CHI-480001
#                        END RECORD
#   define p_faj32 like faj_file.faj32
#   define p_yyyymm LIKE type_file.chr6         #No.FUN-680070 VARCHAR(6)
#   define i LIKE type_file.num5         #No.FUN-680070 smallint
#   define l_gen02 like gen_file.gen02
#   DEFINE l_last_sw LIKE type_file.chr1                #FUN-550102       #No.FUN-680070 VARCHAR(1)
#
#   OUTPUT
#       TOP MARGIN 2
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN 10
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.fbg01,sr.fbh03,sr.fbh031
#
#    FORMAT
#        PAGE HEADER
##No.FUN-580010 --start
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
##No.FUN-580010 --end
#                                           ## 銷帳申請單
#           #---- 以 下 49 列 是從on every row 移來的 ----#
#           SELECT gem02 INTO m_faj20 FROM gem_file WHERE gem01=sr.faj20
#           IF STATUS=100 THEN LET m_faj20=' ' END IF  ##------ 部門名稱
#           SELECT fag03 INTO m_fbh05 FROM fag_file WHERE fag01=sr.fbh05
#           IF STATUS=100 THEN LET m_fbh05=' ' END IF  ##------ 異動原因
#           IF sr.faj38='0' THEN
#              LET m_faj38=g_x[50] CLIPPED
#           ELSE
#              LET m_faj38=g_x[51] CLIPPED
#           END IF
#
#           PRINT COLUMN 1,g_x[11] CLIPPED,sr.fbg01  #FUN-5A0180 60->1
#           PRINT ' '
#           PRINT COLUMN 01,g_x[12] CLIPPED,
#                 COLUMN 30,g_x[13] CLIPPED,
#                 COLUMN 60,g_x[14] CLIPPED,sr.fbg02
#           SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.faj19
#           IF SQLCA.sqlcode THEN LET l_gen02 = ' ' END IF
#           PRINT COLUMN 01,g_x[15] CLIPPED,sr.faj19,l_gen02,
#                 COLUMN 30,g_x[16] CLIPPED,sr.faj20 CLIPPED,' ',m_faj20 CLIPPED
#           PRINT ' '
#           PRINT COLUMN 01,g_x[17] CLIPPED,COLUMN 40,g_x[18] CLIPPED
#           PRINT ' '
#           PRINT COLUMN 01,g_x[21] CLIPPED,sr.faj06,sr.faj061
#           PRINT COLUMN 01,g_x[22] CLIPPED,sr.faj07,sr.faj071
#
#           PRINT COLUMN 01,g_x[23] CLIPPED,sr.faj08,
#                 COLUMN 46,g_x[29] CLIPPED,cl_numfor(sr.faj17,15,0)
#           PRINT COLUMN 01,g_x[25] CLIPPED,sr.fbh03,
#                 COLUMN 46,g_x[26] CLIPPED
#           PRINT COLUMN 01,g_x[24] CLIPPED,sr.faj85,
#                 COLUMN 46,g_x[27] CLIPPED,cl_numfor(sr.faj81,18,g_azi04)
#           PRINT COLUMN 01,g_x[53] CLIPPED,sr.faj84,
#                 COLUMN 46,g_x[28] CLIPPED,' ',sr.faj89
#           PRINT COLUMN 01,g_x[30] CLIPPED
#           skip 2 line
#           PRINT COLUMN 01,g_x[31] CLIPPED,
#                 COLUMN 46,g_x[32] CLIPPED
#           skip 1 line
#           PRINT COLUMN 01,g_x[33] CLIPPED,
#                 COLUMN 46,g_x[34] CLIPPED
#           skip 1 line
#           PRINT COLUMN 11,g_x[35] CLIPPED,
#                 COLUMN 46,g_x[36] CLIPPED
#           skip 1 line
#           PRINT COLUMN 11,g_x[37] CLIPPED
#           skip 1 line
#           PRINT COLUMN 01,g_x[38] CLIPPED
#           #No.CHI-480001
##No.FUN-580010 --start
#           PRINT g_dash[1,g_len]
#           #FUN-5A0180-begin
#           #PRINT g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
#           #      g_x[46],g_x[47],
#           #      g_x[59],g_x[55],g_x[56],
#           #      g_x[57],g_x[58]
#           PRINTX name=H1
#                 g_x[41],g_x[47],g_x[44],g_x[46]
#           PRINTX name=H2
#                 g_x[56],g_x[42],g_x[43],g_x[55],g_x[45]
#           #FUN-5A0180-end
#           PRINT g_dash1
##No.FUN-580010 --end
#           #end
#           LET l_last_sw='n'       #FUN-550102
#
#        BEFORE GROUP OF sr.fbh03
#           SKIP TO TOP OF PAGE
#
#        ON EVERY ROW
##No.FUN-580010 --start
#                 #FUN-5A0180-begin
#           PRINTX name=D1
#                  COLUMN g_c[41],sr.faj26 CLIPPED,
#                  COLUMN g_c[47],sr.fbh03 clipped,'-',sr.fbh031,
#                  COLUMN g_c[44],cl_numfor(sr.cost-p_faj32,18,g_azi04),
#                  COLUMN g_c[46],sr.faj07
#           PRINTX name=D2
#                  COLUMN g_c[42],cl_numfor(sr.cost,18,g_azi04),
#                  COLUMN g_c[43],cl_numfor(p_faj32,18,g_azi04),
#                  COLUMN g_c[55],cl_numfor(sr.cost2,18,g_azi04),
#                  COLUMN g_c[45],p_yyyymm
#                 #PRINT COLUMN g_c[41],sr.faj26 CLIPPED,
#                 #COLUMN g_c[42],cl_numfor(sr.cost,18,g_azi04),
#                 #COLUMN g_c[43],cl_numfor(p_faj32,18,g_azi04);
#                 #No.CHI-480001
#                 #IF g_aza.aza26 = '2' THEN
#                 #   PRINT COLUMN g_c[59],cl_numfor(sr.cost-p_faj32,18,g_azi04),
#                 #         COLUMN g_c[55],cl_numfor(sr.cost2,18,g_azi04),
#                 #         COLUMN g_c[56],p_yyyymm,
#                 #         COLUMN g_c[57],sr.faj07[1,20],
#                 #         COLUMN g_c[58],sr.fbh03 clipped,'-',sr.fbh031
#                 #ELSE
#                 #   PRINT COLUMN g_c[44],cl_numfor(sr.cost-p_faj32,18,g_azi04),
#                 #         COLUMN g_c[45],p_yyyymm,
#                 #         COLUMN g_c[46],sr.faj07[1,20],
#                 #         COLUMN g_c[47],sr.fbh03 clipped,'-',sr.fbh031
#                 #END IF
#                 #FUN-5A00180-end
#                 #end
##No.FUN-580010 --end
#
#    AFTER GROUP OF sr.fbh03
##No.FUN-580010 --start
#         PRINT
#           PRINTX name=S2
#                 COLUMN g_c[56],g_x[54] CLIPPED,
#                 COLUMN g_c[42],cl_numfor(group sum(sr.cost),18,g_azi05),
#                 COLUMN g_c[43],cl_numfor(group sum(sr.tot_dep),18,g_azi05),
#                 COLUMN g_c[44],cl_numfor(group sum(sr.cost-p_faj32),18,g_azi05),
#                 COLUMN g_c[55],cl_numfor(GROUP SUM(sr.cost2),18,g_azi05)
#                 #No.CHI-480001
#                 #FUN-5A0180-begin
#                 #IF g_aza.aza26 = '2' THEN
#                 #   PRINT COLUMN g_c[59],cl_numfor(group sum(sr.cost-p_faj32),18,g_azi05);
#                 #   PRINT COLUMN g_c[55],cl_numfor(GROUP SUM(sr.cost2),18,g_azi05)
#                 #ELSE
#                 #   PRINT COLUMN g_c[44],cl_numfor(group sum(sr.cost-p_faj32),18,g_azi05);
#                 #   PRINT ''
#                 #END IF
#                 #FUN-5A0180-end
#                 #end
#           PRINT g_dash[1,g_len]
#           PRINT ' '
#
### FUN-550102
#ON LAST ROW
# LET l_last_sw = 'y'
#
#PAGE TRAILER
# IF l_last_sw = 'n' THEN
# IF g_memo_pagetrailer THEN
# PRINT g_x[48]
# PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[48]
#             PRINT g_memo
#      END IF
#      skip 5 line
### END FUN-550102
#
#END REPORT
#FUN-710083.....end mark
