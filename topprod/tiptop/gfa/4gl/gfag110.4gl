# Prog. Version..: '5.30.06-13.03.18(00001)'     #
#
# Pattern name...: gfag110.4gl
# Desc/riptions..: 固定資產出售申請單
# Date & Author..: 96/06/11 By Kitty
# Modify.........: No.CHI-480001 04/08/16 By Danny   新增大陸版報表段(減值準備)
# Modify.........: No.FUN-510035 05/01/31 By Smapmin 調整單價,匯率,金額位數
# Modify.........: No.FUN-550102 05/05/25 By echo 新增報表備註
# Modify.........: No.FUN-580010 05/08/02 By vivien 憑証類報表轉XML
# Modify.........: No.MOD-4A0114 05/08/25 By Smapmin 列印申請人與申請部門
# Modify.........: No.FUN-5A0180 05/10/25 By Claire 報表調整可印Font 10
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710083 07/02/01 By Ray Crystal Report修改
# Modify.........: No.TQC-730088 07/03/22 By Nicole 增加 CR參數
# Modify.........: No.TQC-780054 07/08/15 By xiaofeizhu 修改INSERT INTO temptable語法(不用ora轉換)
# Modify.........: No.MOD-870088 08/07/10 By Sarah 報表單頭申請原因取消,單身增加fbf05原因碼+原因說明顯示,放在最右邊欄位
# Modify.........: No.FUN-920036 09/05/06 By sabrina 財簽、稅簽依畫面選項分開列印
# Modify.........: No.MOD-970248 09/07/28 By sabrina EXECUTE insert_prep後面傳入的順序錯了
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A40084 10/04/19 By Carrier  GP5.2报表追单
# Modify.........: No:FUN-B40097 11/06/07 By chenying 憑證CR轉GR
# Modify.........: No.FUN-B40097 11/08/17 By chenying 程式規範修改
# Modify.........: No.FUN-C40020 12/04/10 By qirl  GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-CC0093 12/12/20 By wangrr GR程式修改
# Modify.........: No.FUN-D10098 13/02/01 By lujh 新增gfag110
 
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
 
    DEFINE tm  RECORD				# Print condition RECORD
       	    	#wc     LIKE type_file.chr1000,		# Where condition       #No.FUN-680070 VARCHAR(1000)   #FUN-CC0093 add
                wc      STRING,                      #FUN-CC0093
                a       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    	        b    	LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    	        d    	LIKE type_file.chr1,         #No.FUN-920036 VARCHAR(1)
                more    LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
              END RECORD,
          g_zo          RECORD LIKE zo_file.*
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
#No.FUN-580010 --end
#No.FUN-710083 --begin
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  g_str      STRING
#No.FUN-710083 --end
###GENGRE###START
TYPE sr1_t RECORD
    l_order LIKE type_file.chr1000,
    fbe01 LIKE fbe_file.fbe01,
    fbe02 LIKE fbe_file.fbe02,
    fbe03 LIKE fbe_file.fbe03,
    fbe09t LIKE fbe_file.fbe09t,
    fbe16 LIKE fbe_file.fbe16,
    fbe17 LIKE fbe_file.fbe17,
    fbf03 LIKE fbf_file.fbf03,
    fbf031 LIKE fbf_file.fbf031,
    fbf04 LIKE fbf_file.fbf04,
    fbf05 LIKE fbf_file.fbf05,
    fag03 LIKE fag_file.fag03,
    fbf07 LIKE fbf_file.fbf07,
    faj06 LIKE faj_file.faj06,
    faj061 LIKE faj_file.faj061,
    faj07 LIKE faj_file.faj07,
    faj071 LIKE faj_file.faj071,
    faj08 LIKE faj_file.faj08,
    faj19 LIKE faj_file.faj19,
    faj20 LIKE faj_file.faj20,
    faj26 LIKE faj_file.faj26,
    faj38 LIKE faj_file.faj38,
    faj89 LIKE faj_file.faj89,
    faj14 LIKE faj_file.faj14,
    faj141 LIKE faj_file.faj141,
    faj58 LIKE faj_file.faj58,
    faj59 LIKE faj_file.faj59,
    faj32 LIKE faj_file.faj32,
    faj60 LIKE faj_file.faj60,
    faj17 LIKE faj_file.faj17,
    faj85 LIKE faj_file.faj85,
    faj81 LIKE faj_file.faj81,
    faj84 LIKE faj_file.faj84,
    fbf11 LIKE fbf_file.fbf11,
    #FUN-B40097---add----str---------------
    cost           LIKE faj_file.faj14,
    cost2          LIKE faj_file.faj32,
    tot_dep        LIKE faj_file.faj32,
    cost_tot_dep   LIKE faj_file.faj32,
    #FUN-B40097---add----end----------------
    gen02_1 LIKE gen_file.gen02,
    gen02_2 LIKE gen_file.gen02,
    gem02_1 LIKE gem_file.gem02,
    gem02_2 LIKE gem_file.gem02,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    sign_type LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_img  LIKE type_file.blob,   # No.FUN-C40020 add
    sign_show LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_str  LIKE type_file.chr1000 # No.FUN-C40020 add
END RECORD
###GENGRE###END

MAIN
   OPTIONS
          INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GFA")) THEN
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
   LET tm.d = ARG_VAL(14)        #FUN-920036 add
 
#No.FUN-710083 --begin
   LET g_sql ="l_order.type_file.chr1000,",
              "fbe01.fbe_file.fbe01,",
              "fbe02.fbe_file.fbe02,",
              "fbe03.fbe_file.fbe03,",
              "fbe09t.fbe_file.fbe09t,",
              "fbe16.fbe_file.fbe16,",
              "fbe17.fbe_file.fbe17,",
              "fbf03.fbf_file.fbf03,",
              "fbf031.fbf_file.fbf031,",
              "fbf04.fbf_file.fbf04,",
              "fbf05.fbf_file.fbf05,",
              "fag03.fag_file.fag03,",   #MOD-870088 add
              "fbf07.fbf_file.fbf07,",
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
              "faj14.faj_file.faj14,",
              "faj141.faj_file.faj141,",
              "faj58.faj_file.faj58,",    #No.TQC-A40084
              "faj59.faj_file.faj59,",
              "faj32.faj_file.faj32,",
              "faj60.faj_file.faj60,",
              "faj17.faj_file.faj17,",
              "faj85.faj_file.faj85,",
              "faj81.faj_file.faj81,",
              "faj84.faj_file.faj84,",
              "fbf11.fbf_file.fbf11,",
              #FUN-B40097---add----str-----------
              "cost.faj_file.faj14,",
              "cost2.faj_file.faj32,",
              "tot_dep.faj_file.faj32,",
              "cost_tot_dep.faj_file.faj32,",  
              #FUN-B40097---add----end-----------
              "gen02_1.gen_file.gen02,",
              "gen02_2.gen_file.gen02,",
              "gem02_1.gem_file.gem02,",
              "gem02_2.gem_file.gem02,",
              "azi04.azi_file.azi04,",
              "azi05.azi_file.azi05,",
              "sign_type.type_file.chr1,sign_img.type_file.blob,",  # No.FUN-C40020 add
              "sign_show.type_file.chr1,sign_str.type_file.chr1000" # No.FUN-C40020 add
   LET l_table = cl_prt_temptable('gfag110',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40097
      CALL cl_gre_drop_temptable(l_table)    #FUN-B40097
      EXIT PROGRAM 
   END IF
#  LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,            # TQC-780054
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,    # TQC-780054
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,?,?,? )"     # No.FUN-C40020 add 4?                  #No.TQC-A40084   #FUN-B40097 add 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40097
      CALL cl_gre_drop_temptable(l_table)    #FUN-B40097
      EXIT PROGRAM
   END IF
#No.FUN-710083 --end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL g110_tm(0,0)		# Input print condition
      ELSE CALL gfag110()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION g110_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW g110_w AT p_row,p_col WITH FORM "gfa/42f/gfag110"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a    = '3'
  #LET tm.b    = '3'     #FUN-920036 mark
   LET tm.b    = '1'     #FUN-920036 add
   LET tm.d    = '3'     #FUN-920036 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fbe01,fbe02,fbe03,fbe04
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
    #FUN-CC0093--add--str--
    ON ACTION CONTROLP
       CASE
          WHEN INFIELD(fbe01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_fbe"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO fbe01
             NEXT FIELD fbe01
          WHEN INFIELD(fbe03)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_fbe03"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO fbe03
             NEXT FIELD fbe03
          WHEN INFIELD(fbe04)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_fbe04"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO fbe04
             NEXT FIELD fbe04  
       END CASE
    #FUN-CC0093--add--end
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
         LET INT_FLAG = 0 CLOSE WINDOW g110_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         CALL cl_gre_drop_temptable(l_table)
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
            IF cl_null(tm.b) OR tm.b NOT MATCHES "[12]" THEN     #FUN-920036 add
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
         LET INT_FLAG = 0 CLOSE WINDOW g110_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='gfag110'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('gfag110','9031',1)
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
                            " '",tm.d CLIPPED,"'"               #FUN-920036 add
            CALL cl_cmdat('gfag110',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW g110_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL gfag110()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW g110_w
END FUNCTION
 
FUNCTION gfag110()
    DEFINE
        l_i             LIKE type_file.num5,            #No.FUN-680070 SMALLINT
        l_name          LIKE type_file.chr20,           # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
        l_gen02         LIKE gen_file.gen02,            #No.FUN-710083
        l_gen02_2       LIKE gen_file.gen02,            #No.FUN-710083
        l_gem02         LIKE gem_file.gem02,            #No.FUN-710083
        l_gem02_2       LIKE gem_file.gem02,            #No.FUN-710083
        l_za05          LIKE za_file.za05,              #No.FUN-680070 VARCHAR(40)
#       l_time        LIKE type_file.chr8	            #No.FUN-6A0069
        #l_sql    	LIKE type_file.chr1000,         # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)  #FUN-CC0093 mark
        l_sql       STRING,                         #FUN-CC0093  add
        l_chr		LIKE type_file.chr1,            #No.FUN-680070 VARCHAR(1)
        sr              RECORD
                           l_order  LIKE type_file.chr1000,
                           fbe01    LIKE fbe_file.fbe01,   #出售單號
                           fbe02    LIKE fbe_file.fbe02,   #出售日期
                           fbe03    LIKE fbe_file.fbe03,   #銷售客戶
                           fbe09t   LIKE fbe_file.fbe09t,  #出售價格(本幣含稅)
 #MOD-4A0114
                           fbe16    LIKE fbe_file.fbe16,   #申請人
                           fbe17    LIKE fbe_file.fbe17,   #申請部門
 #END MOD-4A0114
                           fbf03    LIKE fbf_file.fbf03,   #財產編號
                           fbf031   LIKE fbf_file.fbf031,  #附號
                           fbf04    LIKE fbf_file.fbf04,   #數量
                           fbf05    LIKE fbf_file.fbf05,   #原因
                           fag03    LIKE fag_file.fag03,   #原因說明   #MOD-870088 add
                           fbf07    LIKE fbf_file.fbf07,   #本幣出售金額    #MOD-4A0114
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
                           faj14    LIKE faj_file.faj14,
                           faj141    LIKE faj_file.faj141,
                           faj58    LIKE faj_file.faj58,   #No.TQC-A40084
                           faj59    LIKE faj_file.faj59,
                           faj32    LIKE faj_file.faj32,
                           faj60    LIKE faj_file.faj60,
#                          cost     LIKE faj_file.faj60,   #No.CHI-480001     #No.FUN-710083
#                          tot_dep  LIKE faj_file.faj60,   #No.CHI-480001     #No.FUN-710083
                           faj17    LIKE faj_file.faj17,   #數量
                           faj85    LIKE faj_file.faj85,   #投抵文號
                           faj81    LIKE faj_file.faj81,   #抵減金額
                           faj84    LIKE faj_file.faj84,   #抵減日期
                           fbf11    LIKE fbf_file.fbf11,    #減值準備 #No.CHI-480001
#                          cost2    LIKE faj_file.faj60    #資產淨額 #No.CHI-480001     #No.FUN-710083
                           #FUN-B40097---add------str----------------
                           cost           LIKE faj_file.faj14,
                           cost2          LIKE faj_file.faj32,
                           tot_dep        LIKE faj_file.faj32,
                           cost_tot_dep   LIKE faj_file.faj32  
                           #FUN-B40097---add------end----------------
                        END RECORD
     DEFINE l_cnt                   LIKE type_file.num5    #No.FUN-680070 SMALLINT
     DEFINE l_zaa02                 LIKE zaa_file.zaa02
     DEFINE l_img_blob        LIKE type_file.blob  # No.FUN-C40020 add
    # LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add
    define yyyymm LIKE type_file.chr6                      #No.FUN-680070 VARCHAR(6)
   LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add 
    CALL cl_del_data(l_table)     #No.FUN-710083
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    #====>資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET tm.wc = tm.wc clipped," AND fbeuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET tm.wc = tm.wc clipped," AND fbegrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET tm.wc = tm.wc clipped," AND fbegrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fbeuser', 'fbegrup')
    #End:FUN-980030
 
   #FUN-920036---add---start---
    IF tm.a='1' THEN LET tm.wc=tm.wc CLIPPED," AND fbeconf='Y' " END IF
    IF tm.a='2' THEN LET tm.wc=tm.wc CLIPPED," AND fbeconf='N' " END IF
    IF tm.d='1' THEN     #posted
       IF tm.b='1' THEN
          LET tm.wc=tm.wc CLIPPED," AND fbepost='Y' "   #財簽
       ELSE
          LET tm.wc=tm.wc CLIPPED," AND fbepost2='Y' "  #稅簽
       END IF
    END IF
    IF tm.d='2' THEN     #unposted
       IF tm.b='1' THEN
          LET tm.wc=tm.wc CLIPPED," AND fbepost='N' "   #財簽
       ELSE
          LET tm.wc=tm.wc CLIPPED," AND fbepost2='N' "  #稅簽
       END IF
    END IF
    #FUN-920036---mod---end---
 
 #    LET l_sql="SELECT fbe01,fbe02,fbe03,fbe09t,fbf03,fbf031,fbf04,",  #MOD-4A0114
    IF tm.b = '1' THEN   #財簽    #FUN-920036 add
       LET l_sql="SELECT '',fbe01,fbe02,fbe03,fbe09t,fbe16,fbe17,fbf03,fbf031,fbf04,",   #MOD-4A0114
 #               "       fbf05,faj06,faj061,faj07,faj071,faj08,faj19,",   #MOD-4A0114
                 "       fbf05,'',fbf07,faj06,faj061,faj07,faj071,faj08,faj19,",   #MOD-4A0114   #MOD-870088 add ''
                 "       faj20,faj26,faj38,faj89, ",
                 "       faj14,faj141,faj58,faj59,faj32,faj60,",                   #No.TQC-A40084
                 "       faj17,faj85,faj81,faj84,fbf11,'','','','' ",        #FUN-B40097 add 4''
                 "  FROM fbe_file,fbf_file,faj_file ",
                 " WHERE fbe01=fbf01 AND fbf03=faj02 AND fbf031=faj022 ",
                 "   AND fbeconf <> 'X' ",
                 "   AND ", tm.wc CLIPPED
   #FUN-920036---add---start---
    ELSE         #稅簽
       LET l_sql="SELECT '',fbe01,fbe02,fbe03,fbe09t,fbe16,fbe17,fbf03,fbf031,fbf04,",   #MOD-4A0114
                 "       fbf05,'',fbf07,faj06,faj061,faj07,faj071,faj08,faj19,",   #MOD-4A0114   #MOD-870088 add ''
                 "       faj20,faj26,faj38,faj89, ",
                 "       faj62,faj63,faj58,faj69,faj67,faj60,",                   #No.TQC-A40084
                 "       faj17,faj85,faj81,faj84,fbf11,'','','','' ",    #FUN-B40097 add 4''
                 "  FROM fbe_file,fbf_file,faj_file ",
                 " WHERE fbe01=fbf01 AND fbf03=faj02 AND fbf031=faj022 ",
                 "   AND fbeconf <> 'X' ",
                 "   AND ", tm.wc CLIPPED
    END IF
   #FUN-920036---add---end---
 
   #FUN-920036---mark---start---
   #IF tm.a='1' THEN LET l_sql=l_sql CLIPPED," AND fbeconf='Y' " END IF
   #IF tm.a='2' THEN LET l_sql=l_sql CLIPPED," AND fbeconf='N' " END IF
   #IF tm.b='1' THEN LET l_sql=l_sql CLIPPED," AND fbepost='Y' " END IF
   #IF tm.b='2' THEN LET l_sql=l_sql CLIPPED," AND fbepost='N' " END IF
   #FUN-920036---mark---end---
 
    PREPARE g110_p1 FROM l_sql                # RUNTIME 編譯
        IF STATUS THEN CALL cl_err('prepare:',STATUS,0) RETURN END IF
     DECLARE g110_co  CURSOR FOR g110_p1
#No.FUN-710083 --begin
#    SELECT * INTO g_zo.* FROM zo_file WHERE zo01=g_rlang
#    CALL cl_outnam('gfag110') RETURNING l_name
 
#No.FUN-580010 --start
#          IF g_aza.aza26 = '2' THEN
#           #FUN-5A0180-begin
#             LET g_zaa[45].zaa06 = "Y"
#             LET g_zaa[55].zaa06 = "N"
#             LET g_zaa[56].zaa06 = "N"
#            ELSE
#             LET g_zaa[45].zaa06 = "N"
#             LET g_zaa[55].zaa06 = "Y"
#             LET g_zaa[56].zaa06 = "Y"
 
            # LET g_zaa[44].zaa06 = "Y"
	    # LET g_zaa[45].zaa06 = "Y"
	    # LET g_zaa[46].zaa06 = "Y"
	    # LET g_zaa[47].zaa06 = "Y"
            # LET g_zaa[59].zaa06 = "N"
            # LET g_zaa[55].zaa06 = "N"
            # LET g_zaa[56].zaa06 = "N"
            # LET g_zaa[57].zaa06 = "N"
            # LET g_zaa[58].zaa06 = "N"
            #ELSE
            # LET g_zaa[44].zaa06 = "N"
	    # LET g_zaa[45].zaa06 = "N"
	    # LET g_zaa[46].zaa06 = "N"
	    # LET g_zaa[47].zaa06 = "N"
            # LET g_zaa[59].zaa06 = "Y"
            # LET g_zaa[55].zaa06 = "Y"
            # LET g_zaa[56].zaa06 = "Y"
            # LET g_zaa[57].zaa06 = "Y"
            # LET g_zaa[58].zaa06 = "Y"
            #FUN-5A0180-end
#          END IF
#     CALL cl_prt_pos_len()
#No.FUN-580010 --end
 
#    START REPORT g110_rep TO l_name
#    LET g_pageno = 0
#No.FUN-710083 --end
    FOREACH g110_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
#No.FUN-710083 --begin
            LET sr.l_order = sr.fbe01,'-',sr.fbf03,'-',sr.fbf031
            SELECT gem02 INTO l_gem02_2 FROM gem_file WHERE gem01=sr.faj20
            IF STATUS=100 THEN LET l_gem02_2 =' ' END IF  ##------ 部門名稱
            SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.fbe16
            IF SQLCA.sqlcode THEN LET l_gen02 = ' ' END IF
            SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.fbe17
            IF SQLCA.sqlcode THEN LET l_gem02 = ' ' END IF
            SELECT gen02 INTO l_gen02_2 FROM gen_file WHERE gen01=sr.faj19
            IF SQLCA.sqlcode THEN LET l_gen02_2 = ' ' END IF
            SELECT fag03 INTO sr.fag03 FROM fag_file WHERE fag01=sr.fbf05   #MOD-870088 add
            IF STATUS=100 THEN LET sr.fag03=' ' END IF  ##------ 異動原因   #MOD-870088 add

            #FUN-B40097----add----str-------------
            IF sr.faj17 > 0 THEN
               IF sr.faj17 > 1 THEN
                  LET sr.cost = ((sr.faj14 + sr.faj141 - sr.faj59)/(sr.faj17-sr.faj58))*sr.fbf04
               ELSE
                  LET sr.cost = ((sr.faj14 + sr.faj141)/sr.faj17)*sr.fbf04
               END IF
            ELSE   
                LET sr.cost = sr.faj14 + sr.faj141
            END IF

            IF sr.faj17 > 0 THEN
               IF sr.faj17 > 1 THEN
                  LET sr.tot_dep=((sr.faj32-sr.faj60)/(sr.faj17-sr.faj58))*sr.fbf04
               ELSE
                  LET sr.tot_dep=(sr.faj32/sr.faj17)*sr.fbf04
               END IF
            ELSE  
               LET sr.tot_dep=sr.faj32
            END IF

            LET sr.cost_tot_dep=sr.cost-sr.tot_dep

            LET sr.cost2= sr.cost - sr.tot_dep - sr.fbf11
            #FUN-B40097----add----end-----------------  

              
           #EXECUTE insert_prep USING sr.*,l_gen02,l_gem02,l_gen02_2,l_gem02_2,g_azi04,g_azi05     #MOD-970248 mark
            EXECUTE insert_prep USING sr.*,l_gen02,l_gen02_2,l_gem02,l_gem02_2,g_azi04,g_azi05,"",  l_img_blob,"N",""  # No.FUN-C40020 add     #MOD-970248 add
#        IF sr.faj17 >0 THEN
#             LET sr.cost = ((sr.faj14+sr.faj141-sr.faj59)/sr.faj17)*sr.fbf04
#             LET sr.tot_dep = ((sr.faj32-sr.faj60)/sr.faj17)*sr.fbf04
#        ELSE LET sr.cost = sr.faj14 + sr.faj141
#             LET sr.tot_dep = sr.faj32
#        END IF
#        LET  yyyymm=g_faa.faa07 using "&&&&",g_faa.faa08 using "&&"
#No.FUN-710083 --end
         #No.CHI-480001
         IF cl_null(sr.fbf11) THEN LET sr.fbf11 = 0 END IF
#        LET sr.cost2 = sr.cost - sr.tot_dep - sr.fbf11     #No.FUN-710083
         #end
#        OUTPUT TO REPORT g110_rep(sr.*,sr.tot_dep,yyyymm)     #No.FUN-710083
    END FOREACH
 
#No.FUN-710083 --begin
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'fbe01,fbe02,fbe03,fbe04')
          RETURNING tm.wc
###GENGRE###     LET g_str = tm.wc,";",g_zz05,";",g_faa.faa07 USING "&&&&",";",g_faa.faa08 USING "&&"
###GENGRE###                      ,";",g_azi04,";",g_azi05,";",tm.b      #FUN-920036 add
    #LET g_str = g_str,";",g_azi04,";",g_azi05               #FUN-920036 mark
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED  #TQC-730088
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_cr_table = l_table                    # No.FUN-C40020 add
     LET g_cr_apr_key_f = "fbe01"         # No.FUN-C40020 add
     IF g_aza.aza26 = '2' THEN
      # CALL cl_prt_cs3('gfag110',l_sql,g_str)   #TQC-730088
      # CALL cl_prt_cs3('gfag110','gfag110',l_sql,g_str)      #FUN-920036 mark
###GENGRE###        CALL cl_prt_cs3('gfag110','gfag110_1',l_sql,g_str)    #FUN-920036 add
        LET g_template = "gfag110_1"
        CALL gfag110_grdata()    ###GENGRE###
     ELSE
      # CALL cl_prt_cs3('gfag110_2',l_sql,g_str) #TQC-730088
      # CALL cl_prt_cs3('gfag110','gfag110_2',l_sql,g_str)    #FUN-920036 mark
###GENGRE###        CALL cl_prt_cs3('gfag110','gfag110',l_sql,g_str)      #FUN-920036 add
        LET g_template = "gfag110"
        CALL gfag110_grdata()    ###GENGRE###
     END IF
#No.FUN-710083 --end
#   FINISH REPORT g110_rep     #No.FUN-710083
 
#   CALL cl_prt(l_name,' ','1',g_len)     #No.FUN-710083
END FUNCTION
 
#No.FUN-710083 --begin
#REPORT g110_rep(sr,p_faj32,p_yyyymm)
#    DEFINE
#        m_faj20         LIKE gem_file.gem02,
#        m_fbf05         LIKE fag_file.fag03,
#        m_faj38         LIKE faj_file.faj38,       #No.FUN-680070 VARCHAR(06)
#        sr              RECORD
#                        fbe01    LIKE fbe_file.fbe01,   #出售單號
#                        fbe02    LIKE fbe_file.fbe02,   #出售日期
#                        fbe03    LIKE fbe_file.fbe03,   #銷售客戶
#                        fbe09t   LIKE fbe_file.fbe09t,  #出售價格(本幣含稅)
# #MOD-4A0114
#                        fbe16    LIKE fbe_file.fbe16,   #申請人
#                        fbe17    LIKE fbe_file.fbe17,   #申請部門
# #END MOD-4A0114
#                        fbf03    LIKE fbf_file.fbf03,   #財產編號
#                        fbf031   LIKE fbf_file.fbf031,  #附號
#                        fbf04    LIKE fbf_file.fbf04,   #數量
#                        fbf05    LIKE fbf_file.fbf05,   #原因
#                         fbf07    LIKE fbf_file.fbf07,   #本幣出售金額   #MOD-4A0114
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
#                        faj14    LIKE faj_file.faj14,
#                        faj141   LIKE faj_file.faj141,
#                        faj59    LIKE faj_file.faj59,
#                        faj32    LIKE faj_file.faj32,
#                        faj60    LIKE faj_file.faj60,
#                        cost     LIKE faj_file.faj60,   #No.CHI-480001
#                        tot_dep  LIKE faj_file.faj60,   #No.CHI-480001
#                        faj17    LIKE faj_file.faj17,   #數量
#                        faj85    LIKE faj_file.faj85,   #投抵文號
#                        faj81    LIKE faj_file.faj81,   #抵減金額
#                        faj84    LIKE faj_file.faj84,   #抵減日期
#                        fbf11    LIKE fbf_file.fbf11,   #減值準備 #No.CHI-480001
#                        cost2    LIKE faj_file.faj60    #資產淨額 #No.CHI-480001
#                        END RECORD
#   define p_faj32 like faj_file.faj32
#   define p_yyyymm LIKE type_file.chr6         #No.FUN-680070 VARCHAR(6)
#   define i LIKE type_file.num5         #No.FUN-680070 smallint
#   define l_gen02 like gen_file.gen02
#    DEFINE l_gem02 LIKE gem_file.gem02   #MOD-4A0114
#   DEFINE l_last_sw     LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
#   OUTPUT
#       TOP MARGIN 2
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN 10
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.fbe01,sr.fbf03,sr.fbf031
#
#    FORMAT
#        PAGE HEADER
##No.FUN-580010 --start
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
##No.FUN-580010 --end
#           #---- 以 下 49 列 是從on every row 移來的 ----#
#           SELECT gem02 INTO m_faj20 FROM gem_file WHERE gem01=sr.faj20
#           IF STATUS=100 THEN LET m_faj20=' ' END IF  ##------ 部門名稱
#           SELECT fag03 INTO m_fbf05 FROM fag_file WHERE fag01=sr.fbf05
#           IF STATUS=100 THEN LET m_fbf05=' ' END IF  ##------ 異動原因
##No.FUN-580010 --start
#           IF sr.faj38='0' THEN
#              LET m_faj38=g_x[50] CLIPPED
#           ELSE
#              LET m_faj38=g_x[51] CLIPPED
#           END IF
##No.FUN-580010 --end
#
#           PRINT COLUMN 01,g_x[11] CLIPPED,sr.fbe01  #FUN-5A0180 60->1
#           PRINT ' '
# #MOD-4A0114
#           SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.fbe16
#           IF SQLCA.sqlcode THEN LET l_gen02 = ' ' END IF
#           SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.fbe17
#           IF SQLCA.sqlcode THEN LET l_gem02 = ' ' END IF
#           PRINT COLUMN 01,g_x[12] CLIPPED,sr.fbe16,' ',l_gen02,
#                 COLUMN 30,g_x[13] CLIPPED,sr.fbe17,' ',l_gem02,
# #END MOD-4A0114
#                 COLUMN 60,g_x[14] CLIPPED,sr.fbe02
#           SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.faj19
#           IF SQLCA.sqlcode THEN LET l_gen02 = ' ' END IF
#           PRINT COLUMN 01,g_x[15] CLIPPED,sr.faj19,l_gen02,
#                 COLUMN 30,g_x[16] CLIPPED,sr.faj20 CLIPPED,' ',m_faj20 CLIPPED
#           PRINT ' '
# #           PRINT COLUMN 01,g_x[17] CLIPPED,sr.fbe03,COLUMN 40,g_x[18] CLIPPED   #MOD-4A0114
#            PRINT COLUMN 01,g_x[17] CLIPPED,sr.fbe03,COLUMN 40,g_x[18] CLIPPED,cl_numfor(sr.fbf07,18,g_azi04)   #MOD-4A0114
#           PRINT ' '
#           PRINT COLUMN 01,g_x[21] CLIPPED,sr.faj06,sr.faj061
#           PRINT COLUMN 01,g_x[22] CLIPPED,sr.faj07,sr.faj071
#
#           PRINT COLUMN 01,g_x[23] CLIPPED,sr.faj08,
#                 COLUMN 46,g_x[29] CLIPPED,cl_numfor(sr.fbf04,15,0)
#           PRINT COLUMN 01,g_x[25] CLIPPED,sr.fbf03,
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
#                  g_x[41],g_x[47],g_x[46],g_x[45]
#           PRINTX name=H2
#                  g_x[57],g_x[42],g_x[43],g_x[44],g_x[55],g_x[56]
#           #FUN-5A0180-end
#           PRINT g_dash1
##No.FUN-580010 --end
#           LET l_last_sw = 'n'       #FUN-550102
#
#        BEFORE GROUP OF sr.fbf03
#           SKIP TO TOP OF PAGE
#
#        ON EVERY ROW
##No.FUN-580010 --start
#           #FUN-5A0180-begin
#           #PRINT column g_c[41],sr.faj26 clipped,
#           #      column g_c[42],cl_numfor(sr.cost,42,g_azi04),
#           #      column g_c[43],cl_numfor(p_faj32,43,g_azi04);
#           #      #No.CHI-480001
#           #      IF g_aza.aza26 = '2' THEN
#           #         PRINT COLUMN g_c[59],cl_numfor(sr.cost-p_faj32,59,g_azi04),
#           #               COLUMN g_c[55],cl_numfor(sr.cost2,55,g_azi04),
#           #               COLUMN g_c[56],p_yyyymm,
#           #               COLUMN g_c[57],sr.faj07[1,20],
#           #               COLUMN g_c[58],sr.fbf03 clipped,'-',sr.fbf031
#           #      ELSE
#           #         PRINT COLUMN g_c[44],cl_numfor((sr.cost - p_faj32),44,g_azi04),
#           #               COLUMN g_c[45],p_yyyymm,
#           #               COLUMN g_c[46],sr.faj07[1,20],
#           #               COLUMN g_c[47],sr.fbf03 clipped,'-',sr.fbf031
#           #      END IF
#           PRINTX name=D1
#                  column g_c[41],sr.faj26 clipped,
#                  COLUMN g_c[47],sr.fbf03 clipped,'-',sr.fbf031,
#                  COLUMN g_c[46],sr.faj07,
#                  COLUMN g_c[45],p_yyyymm
#           PRINTX name=D2
#                  column g_c[42],cl_numfor(sr.cost,42,g_azi04),
#                  column g_c[43],cl_numfor(p_faj32,43,g_azi04),
#                  COLUMN g_c[44],cl_numfor((sr.cost - p_faj32),44,g_azi04),
#                  COLUMN g_c[55],cl_numfor(sr.cost2,55,g_azi04),
#                  COLUMN g_c[56],p_yyyymm
#           #FUN-5A0180-end
##No.FUN-580010 --end
#                 #end
#
#    AFTER GROUP OF sr.fbf03
##No.FUN-580010 --start
#        PRINT
#           #FUN-5A0180-begin
#           #PRINTX name=S1
#           #       COLUMN g_c[41],g_x[54] CLIPPED,
#           #       COLUMN g_c[42],cl_numfor(group sum(sr.cost),42,g_azi05),
#           #       COLUMN g_c[43],cl_numfor(group sum(sr.tot_dep),43,g_azi05);
#           #       IF g_aza.aza26 = '2' THEN
#           #          PRINT COLUMN g_c[59],cl_numfor(group sum(sr.cost-p_faj32),59,g_azi05),
#           #                COLUMN g_c[55],cl_numfor(GROUP SUM(sr.cost2),55,g_azi05)
#           #       ELSE
#           #          PRINT COLUMN g_c[44],cl_numfor(group sum(sr.cost-p_faj32),44,g_azi05)
#           #          PRINT ''
#           #       END IF
#           PRINTX name=S2
#                  COLUMN g_c[57],g_x[54] CLIPPED,
#                  COLUMN g_c[42],cl_numfor(group sum(sr.cost),42,g_azi05),
#                  COLUMN g_c[43],cl_numfor(group sum(sr.tot_dep),43,g_azi05),
#                  COLUMN g_c[44],cl_numfor(group sum(sr.cost-p_faj32),44,g_azi05),
#                  COLUMN g_c[55],cl_numfor(GROUP SUM(sr.cost2),55,g_azi05)
#           #FUN-5A0180-end
#                 #end
#           PRINT g_dash[1,g_len]
##No.FUN-580010 --end
#           PRINT ' '
### FUN-550102
#ON LAST ROW
#      LET l_last_sw = 'y'
#
#PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[48]
#             PRINT g_memo
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
#No.FUN-710083 --end

###GENGRE###START
FUNCTION gfag110_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0  THEN RETURN END IF
    LOCATE sr1.sign_img IN MEMORY      # No.FUN-C40020 add
    CALL cl_gre_init_apr()             # No.FUN-C40020 add
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("gfag110")
        IF handler IS NOT NULL THEN
            START REPORT gfag110_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY fbf03,fbf031"          
            DECLARE gfag110_datacur1 CURSOR FROM l_sql
            FOREACH gfag110_datacur1 INTO sr1.*
                OUTPUT TO REPORT gfag110_rep(sr1.*)
            END FOREACH
            FINISH REPORT gfag110_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT gfag110_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B40097----add----str-------------
    DEFINE l_sql             STRING             
    DEFINE l_fbe17_gem02_1   STRING   
    DEFINE l_faj20_gem02_2   STRING   
    DEFINE l_fbe03           STRING 
    DEFINE l_fbe03_1         STRING
    DEFINE l_faj06_faj061    STRING              
    DEFINE l_faj07_faj071    STRING              
    DEFINE l_fbe16_gen02_1   STRING             
    DEFINE l_faj19_gen02_2   STRING            
    DEFINE l_fbf03_fbf031    STRING              
    DEFINE l_cost_tot_dep    LIKE faj_file.faj32 
    DEFINE l_yyyymm          STRING              
    DEFINE l_fbf05            LIKE fbf_file.fbf05 
    DEFINE l_fag03            LIKE fag_file.fag03 
    DEFINE l_sum_cost         LIKE faj_file.faj14 
    DEFINE l_sum_cost2        LIKE faj_file.faj32 
    DEFINE l_sum_tot_dep      LIKE faj_file.faj32   
    DEFINE l_sum_cost_tot_dep LIKE faj_file.faj32
    DEFINE l_fbf07_fmt        STRING
    DEFINE l_faj81_fmt        STRING
    DEFINE l_cost_fmt         STRING
    DEFINE l_cost2_fmt        STRING
    DEFINE l_tot_dep_fmt      STRING
    DEFINE l_cost_tot_dep_fmt STRING
    DEFINE l_sum_cost_fmt     STRING
    DEFINE l_sum_cost2_fmt    STRING
    DEFINE l_sum_tot_dep_fmt  STRING
    DEFINE l_sum_cost_tot_dep_fmt   STRING
    #FUN-B40097----add----end-----------
    
    ORDER EXTERNAL BY sr1.fbf03
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
            PRINTX g_aza.aza26   #FUN-B40097
              
        BEFORE GROUP OF sr1.fbf03
            LET l_lineno = 0
              
            #FUN-B40097----add----str--------------
            LET l_fbe17_gem02_1=sr1.fbe17,' ',sr1.gem02_1
            LET l_faj20_gem02_2=sr1.faj20,' ',sr1.gem02_2
            LET l_fbe03= cl_gr_getmsg("gre-084",g_lang,'0')
            LET l_fbe03_1= cl_gr_getmsg("gre-084",g_lang,'1')
            LET l_fbe03= '[V]',l_fbe03,' ',l_fbe03_1,'[',sr1.fbe03,']'  
            LET l_faj06_faj061= sr1.faj06,' ',sr1.faj061
            LET l_faj07_faj071 =sr1.faj07,' ',sr1.faj071
            LET l_faj19_gen02_2=sr1.faj19,' ',sr1.gen02_2
            LET l_fbe16_gen02_1=sr1.fbe16,' ',sr1.gen02_1
            PRINTX l_fbe17_gem02_1
            PRINTX l_faj20_gem02_2
            PRINTX l_fbe03
            PRINTX l_faj06_faj061
            PRINTX l_faj06_faj061
            PRINTX l_faj07_faj071
            PRINTX l_faj19_gen02_2
            PRINTX l_fbe16_gen02_1
   
            LET l_fbf07_fmt = cl_gr_numfmt('fbf_file','fbf07',g_azi04)
            PRINTX l_fbf07_fmt
   
            LET l_faj81_fmt = cl_gr_numfmt('faj81_file','faj81',g_azi04)
            LET l_faj81_fmt = cl_replace_str(l_faj81_fmt,"#.","&.")
            IF cl_null(l_faj81_fmt) THEN
               LET l_faj81_fmt = '0'
            END IF

            PRINTX l_faj81_fmt
            #FUN-B40097----add----end-------------



        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
          
            #FUN-B40097---add----str--------------
            LET l_fbf03_fbf031=sr1.fbf03,'-',sr1.fbf031
            PRINTX l_fbf03_fbf031 
            LET l_yyyymm=g_faa.faa07,g_faa.faa08 using "&&"  
            PRINTX l_yyyymm   

            LET l_cost_fmt = cl_gr_numfmt('faj_file','faj14',g_azi04)
            PRINTX l_cost_fmt

            LET l_cost2_fmt = cl_gr_numfmt('faj_file','faj32',g_azi04)
            PRINTX l_cost2_fmt
           
            LET l_tot_dep_fmt = cl_gr_numfmt('faj_file','faj32',g_azi04)
            PRINTX l_tot_dep_fmt

            LET l_cost_tot_dep_fmt = cl_gr_numfmt('faj_file','faj32',g_azi04)
            PRINTX l_cost_tot_dep_fmt                   
            #FUN-B40097---add----end-------------- 

            PRINTX sr1.*

        AFTER GROUP OF sr1.fbf03
            #FUN-B40097---add----str--------------
            LET l_sum_cost = GROUP SUM(sr1.cost)
            PRINTX l_sum_cost
            LET l_sum_tot_dep = GROUP SUM(sr1.tot_dep)
            PRINTX l_sum_tot_dep
            LET l_sum_cost_tot_dep = GROUP SUM(sr1.cost_tot_dep)
            PRINTX l_sum_cost_tot_dep
            LET l_sum_cost2 = GROUP SUM(sr1.cost2) 
            PRINTX l_sum_cost2     

            LET l_sum_cost_fmt = cl_gr_numfmt('faj_file','faj14',g_azi05)
            PRINTX l_sum_cost_fmt

            LET l_sum_cost2_fmt = cl_gr_numfmt('faj_file','faj32',g_azi05)
            PRINTX l_sum_cost2_fmt

            LET l_sum_tot_dep_fmt = cl_gr_numfmt('faj_file','faj32',g_azi05)
            PRINTX l_sum_tot_dep_fmt

            LET l_sum_cost_tot_dep_fmt = cl_gr_numfmt('faj_file','faj32',g_azi05)
            PRINTX l_sum_cost_tot_dep_fmt
            #FUN-B40097---add----end-------------              


        
        ON LAST ROW

END REPORT
###GENGRE###END
#FUN-D10098
