# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: axmg830.4gl
# Descriptions...: 三角貿易訂單明細表(axmg830)
# Input parameter:
# Return code....:
# Date & Author..: 98/12/31  By Billy
# Date & Author..: 03/09/30  By ching No.7946
# Modify.........: No.FUN-4C0096 05/03/03 By Echo 調整單價、金額、匯率欄位大小
# Modify.........: No.FUN-550127 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-580013 05/08/15 By vivien 報表轉XML格式
# Modify.........: No.TQC-5C0087 06/03/21 By Ray AR月底重評價
# Modify.........: NO.FUN-630086 06/04/04 By Niocla 多工廠客戶信用查詢
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.TQC-660087 06/06/20 By Pengu Saxmt810 多角貿易拋單時會產生axmg830,可是過程中無資料產生,lib-216
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE 
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-710194 07/01/31 By claire addr1 LIKE occ241
# Modify.........: No.TQC-750237 07/05/30 By kim s_addrm少傳參數
# Modify.........: No.FUN-750013 07/07/25 By jamie 轉為CR
# Modify.........: NO.TQC-7C0028 07/12/05 by fangyan 崝增加開窗查詢脤戙
# Modify.........: NO.MOD-830174 08/03/21 by claire 取位應參考原幣,追加顯示幣別於報表
# Modify.........: No.TQC-950032 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()   
# Modify.........: No.MOD-950195 09/05/21 By Dido 應逐筆取位參考訂單維護方式取位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0103 09/10/15 By mike 多角订单列印无报表资料,原因为捞取资料的条件卡oea906='Y',应将此条件mark,才可产出报>
# Modify.........: NO.FUN-A10056 10/01/13 By lutingting 跨DB寫法修改
# Modify.........: No.TQC-A50044 10/05/18 By Carrier MAIN中结构调整
# Modify.........: No.FUN-B40092 11/06/07 By xujing \t特殊字元導致轉GR的時候p_gengre出錯
# Modify.........: No.FUN-B40092 11/06/07 By xujing 憑證類報表轉GRW
# Modify.........: No.FUN-B40092 11/08/17 By xujing 程式規範修改
# Modify.........: No:CHI-B70039 11/08/30 By johung 金額 = 計價數量 x 單價
# Modify.........: No.FUN-C40020 12/04/10 By qirl  GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50008 12/05/07 By wangrr GR程式優化
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc     LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(500)     # Where condition
              more   LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)      # Input more condition(Y/N)
              END RECORD
   #-----No.FUN-630086 Mark END-----
   #      g_ocg
   #                  RECORD
   #           ocg48  LIKE ocg_file.ocg48 ,
   #           ocg49  LIKE ocg_file.ocg49 ,
   #           ocg50  LIKE ocg_file.ocg50 ,
   #           ocg51  LIKE ocg_file.ocg51 ,
   #           ocg52  LIKE ocg_file.ocg52 ,
   #           ocg53  LIKE ocg_file.ocg53 ,
   #           ocg54  LIKE ocg_file.ocg54 ,
   #           ocg55  LIKE ocg_file.ocg55
   #                  END RECORD
   #-----No.FUN-630086 Mark END-----
 
DEFINE   g_i         LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   i           LIKE type_file.num5     #No.FUN-680137 SMALLINT
DEFINE   l_j         LIKE type_file.num5,    #No.FUN-630086     #No.FUN-680137 SMALLINT
         l_plant     DYNAMIC ARRAY OF LIKE faj_file.faj02        # No.FUN-680137 VARCHAR(10)  #No.FUN-630086
 
#FUN-750013---add---str---
DEFINE   l_table      STRING
DEFINE   g_str        STRING
DEFINE   g_sql        STRING
#FUN-750013---add---end---
 
DEFINE   t_azi        RECORD LIKE azi_file.*                    #MOD-830174
 
###GENGRE###START
TYPE sr1_t RECORD
    company LIKE cob_file.cob01,
    oea01 LIKE oea_file.oea01,
    oea03 LIKE oea_file.oea03,
    oea04 LIKE oea_file.oea04,
    oea044 LIKE oea_file.oea044,
    oea06 LIKE oea_file.oea06,
    oea19 LIKE oea_file.oea19,
    oea31 LIKE oea_file.oea31,
    oea32 LIKE oea_file.oea32,
    oea38 LIKE oea_file.oea38,
    oea43 LIKE oea_file.oea43,
    oeb03 LIKE oeb_file.oeb03,
    oeb04 LIKE oeb_file.oeb04,
    oeb12 LIKE oeb_file.oeb12,
    oeb13 LIKE oeb_file.oeb13,
    oeb15 LIKE oeb_file.oeb15,
    oap041 LIKE oap_file.oap041,
    oap042 LIKE oap_file.oap042,
    oap043 LIKE oap_file.oap043,
    occ01 LIKE occ_file.occ01,
    occ02 LIKE occ_file.occ02,
    occ18 LIKE occ_file.occ18,
    occ61 LIKE occ_file.occ61,
    occg03 LIKE occ_file.occ63,
    occg04 LIKE occ_file.occ64,
    oao06 LIKE oao_file.oao06,
    oag02 LIKE oag_file.oag02,
    oah02 LIKE oah_file.oah02,
    amn LIKE pmn_file.pmn20,
    cred LIKE occ_file.occ63,
    t62 LIKE type_file.num10,
    dbs LIKE faj_file.faj02,
    oea904 LIKE oea_file.oea904,
    oea904_no LIKE type_file.num5,
    addr1 LIKE occ_file.occ241,
    addr2 LIKE occ_file.occ241,
    addr3 LIKE occ_file.occ241,
    addr4 LIKE occ_file.occ241,
    addr5 LIKE occ_file.occ241,
    occ02_2 LIKE occ_file.occ02,
    occ18_2 LIKE occ_file.occ18,
    addr1_2 LIKE occ_file.occ241,
    addr2_2 LIKE occ_file.occ241,
    addr3_2 LIKE occ_file.occ241,
    addr4_2 LIKE occ_file.occ241,
    addr5_2 LIKE occ_file.occ241,
    oed021 LIKE oed_file.oed021,
    oed022 LIKE oed_file.oed022,
    oed023 LIKE oed_file.oed023,
    oed031 LIKE oed_file.oed031,
    oed032 LIKE oed_file.oed032,
    oed033 LIKE oed_file.oed033,
    oed034 LIKE oed_file.oed034,
    oed041 LIKE oed_file.oed041,
    oed042 LIKE oed_file.oed042,
    oed043 LIKE oed_file.oed043,
    oed044 LIKE oed_file.oed044,
    oed051 LIKE oed_file.oed051,
    oed052 LIKE oed_file.oed052,
    oed053 LIKE oed_file.oed053,
    oed054 LIKE oed_file.oed054,
    oed055 LIKE oed_file.oed055,
    oed056 LIKE oed_file.oed056,
    oed057 LIKE oed_file.oed057,
    oed058 LIKE oed_file.oed058,
    oed061 LIKE oed_file.oed061,
    oed062 LIKE oed_file.oed062,
    oed063 LIKE oed_file.oed063,
    oed064 LIKE oed_file.oed064,
    oed065 LIKE oed_file.oed065,
    oed066 LIKE oed_file.oed066,
    oed067 LIKE oed_file.oed067,
    oed068 LIKE oed_file.oed068,
    occ02_t LIKE occ_file.occ02,
    occ18_t LIKE occ_file.occ18,
    azi03 LIKE azi_file.azi03,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    oea23 LIKE oea_file.oea23,
    sign_type LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_img  LIKE type_file.blob,   # No.FUN-C40020 add
    sign_show LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_str  LIKE type_file.chr1000 # No.FUN-C40020 add
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
#No.TQC-A50044  --Begin
   #-----------------No.TQC-610089 modify
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #-----------------No.TQC-610089 modify

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF

  #No.FUN-750013--begin--
   LET g_sql= "company.cob_file.cob01,",
    "oea01.oea_file.oea01,oea03.oea_file.oea03,oea04.oea_file.oea04,",
    "oea044.oea_file.oea044,oea06.oea_file.oea06,oea19.oea_file.oea19,",
    "oea31.oea_file.oea31,oea32.oea_file.oea32,oea38.oea_file.oea38,",
    "oea43.oea_file.oea43,oeb03.oeb_file.oeb03,oeb04.oeb_file.oeb04,",
    "oeb12.oeb_file.oeb12,oeb13.oeb_file.oeb13,oeb15.oeb_file.oeb15,",
    "oap041.oap_file.oap041,oap042.oap_file.oap042,oap043.oap_file.oap043,",
    "occ01.occ_file.occ01,occ02.occ_file.occ02,occ18.occ_file.occ18,",
    "occ61.occ_file.occ61,occg03.occ_file.occ63,occg04.occ_file.occ64,",
    "oao06.oao_file.oao06,oag02.oag_file.oag02,oah02.oah_file.oah02,",
    "amn.pmn_file.pmn20,cred.occ_file.occ63,t62.type_file.num10,",
    "dbs.faj_file.faj02,oea904.oea_file.oea904,oea904_no.type_file.num5,",
    "addr1.occ_file.occ241,addr2.occ_file.occ241,addr3.occ_file.occ241,",
    "addr4.occ_file.occ241,addr5.occ_file.occ241,occ02_2.occ_file.occ02,",
    "occ18_2.occ_file.occ18,addr1_2.occ_file.occ241,addr2_2.occ_file.occ241,",
    "addr3_2.occ_file.occ241,addr4_2.occ_file.occ241,addr5_2.occ_file.occ241,",
    "oed021.oed_file.oed021,oed022.oed_file.oed022,oed023.oed_file.oed023,",
    "oed031.oed_file.oed031,oed032.oed_file.oed032,oed033.oed_file.oed033,",
    "oed034.oed_file.oed034,",
    "oed041.oed_file.oed041,oed042.oed_file.oed042,oed043.oed_file.oed043,",
    "oed044.oed_file.oed044,",
    "oed051.oed_file.oed051,oed052.oed_file.oed052,oed053.oed_file.oed053,",
    "oed054.oed_file.oed054,oed055.oed_file.oed055,oed056.oed_file.oed056,",
    "oed057.oed_file.oed057,oed058.oed_file.oed058,",
    "oed061.oed_file.oed061,oed062.oed_file.oed062,oed063.oed_file.oed063,",
    "oed064.oed_file.oed064,oed065.oed_file.oed065,oed066.oed_file.oed066,",
    "oed067.oed_file.oed067,oed068.oed_file.oed068,",
    "occ02_t.occ_file.occ02,occ18_t.occ_file.occ18,azi03.azi_file.azi03,", #MOD-830174 modify        
    "azi04.azi_file.azi04,azi05.azi_file.azi05,oea23.oea_file.oea23, ",      #MOD-830174 add   
    "sign_type.type_file.chr1,sign_img.type_file.blob,",  # No.FUN-C40020 add
    "sign_show.type_file.chr1,sign_str.type_file.chr1000" # No.FUN-C40020 add
 
   LET  l_table = cl_prt_temptable('axmg830',g_sql) CLIPPED
   IF l_table=-1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40092
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?, ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?)"     # No.FUN-C40020 add4?   #MOD-830174 modify
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40092
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM
   END IF                                                                                                              
  #No.FUN-750013--end--                                                                                                                              
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
  
#No.TQC-A50044  --End  

   #No.TQC-5C0087 --Begin                                                                                                           
   SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00='0'                                                                              
   #No.TQC-5C0087 --End 
 # IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
   IF cl_null(tm.wc)
      THEN CALL axmg830_tm(0,0)        # Input print condition
      ELSE
           LET tm.more = 'N'
           LET g_pdate = g_today
           LET g_rlang = g_lang
           LET g_bgjob = 'N'
           LET g_copies = '1'
          #LET tm.wc=" oea01='",tm.wc CLIPPED,"' "     #No.TQC-660087 mark
           CALL axmg830()            # Read data and create out-file
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION axmg830_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01       #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,      #No.FUN-680137 SMALLINT
       l_cmd          LIKE type_file.chr1000    #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 6 LET p_col = 17
 
   OPEN WINDOW axmg830_w AT p_row,p_col WITH FORM "axm/42f/axmg830"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oea01, oea02, oea03, oea04, oea14, oea904
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
   #...NO.TQC-7C0028....BEGIN....
      ON ACTION controlp
         CASE 
           WHEN INFIELD(oea01)
             CALL cl_init_qry_var()
             LET g_qryparam.state ='c'
            #LET g_qryparam.form ="q_oea01"  #MOD-9A0103                                                                          
             LET g_qryparam.form ="q_oea02"  #MOD-9A0103 
              CALL cl_create_qry() RETURNING g_qryparam.multiret 
             DISPLAY g_qryparam.multiret TO oea01
             NEXT FIELD oea01
         END CASE
    #..:NO.TQC-7C0028....END....
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
      LET INT_FLAG = 0 CLOSE WINDOW axmg830_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axmg830_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmg830'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmg830','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                        #" '",tm.more CLIPPED,"'",              #No.TQC-610089 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmg830',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmg830_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmg830()
   ERROR ""
END WHILE
   CLOSE WINDOW axmg830_w
END FUNCTION
 
FUNCTION axmg830()
   DEFINE l_img_blob        LIKE type_file.blob  # No.FUN-C40020 add
  # LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add
   DEFINE l_name     LIKE type_file.chr20,               # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
         #l_time     LIKE type_file.chr8                 #No.FUN-6A0094
          l_sql      LIKE type_file.chr1000,             # RDSQL STATEMENT        #No.FUN-680137  VARCHAR(1000)
          l_chr      LIKE type_file.chr1,                #No.FUN-680137 VARCHAR(1)
          l_za05     LIKE type_file.chr1000,             #No.FUN-680137 VARCHAR(40)
          l_azp      ARRAY[7] OF LIKE type_file.chr20,   # No.FUN-680137 VARCHAR(20)
          l_dbs      ARRAY[7] OF LIKE type_file.chr20,   # No.FUN-680137 VARCHAR(20)
          l_plant2   ARRAY[7] OF LIKE type_file.chr20,   #FUN-A10056
          l_t62      LIKE type_file.num10,               # No.FUN-680137 INT 
          l_last     LIKE type_file.num5,                # No.FUN-680137 SMALLINT
         #l_company  LIKE oed_file.oed031,               #FUN-750013 mark# No.FUN-680137 VARCHAR(36)	# Company name
          l_oea      RECORD LIKE oea_file.*,
          l_oed      RECORD LIKE oed_file.*,
          l_ocf      RECORD LIKE ocf_file.*,
          l_occ02    LIKE occ_file.occ02,
          l_occ18    LIKE occ_file.occ18,
          l_oah02    LIKE oah_file.oah02,
          l_oag02    LIKE oag_file.oag02,
          l_gaz03    LIKE gaz_file.gaz03,        #FUN-750013 add
          sr               RECORD
                    oea01  LIKE  oea_file.oea01 ,  #採購單號
                    oea03  LIKE  oea_file.oea03 ,  #帳款客戶
                    oea04  LIKE  oea_file.oea04 ,  #送貨客戶
                    oea044 LIKE  oea_file.oea044 ,  #送貨客戶
                    oea904 LIKE  oea_file.oea904 , #流程代碼
                    poy03_1 LIKE poy_file.poy03 ,  #下游廠商
                    poy03_2 LIKE poy_file.poy03 ,  #下游廠商
                    poy03_3 LIKE poy_file.poy03 ,  #下游廠商
                    poy03_4 LIKE poy_file.poy03 ,  #下游廠商
                    poy03_5 LIKE poy_file.poy03 ,  #下游廠商
                    poy03_6 LIKE poy_file.poy03 ,  #下游廠商
                    poy04_1 LIKE poy_file.poy04 ,  #下游工廠
                    poy04_2 LIKE poy_file.poy04 ,  #下游工廠
                    poy04_3 LIKE poy_file.poy04 ,  #下游工廠
                    poy04_4 LIKE poy_file.poy04 ,  #下游工廠
                    poy04_5 LIKE poy_file.poy04 ,  #下游工廠
                    poy04_6 LIKE poy_file.poy04    #下游工廠
                           END RECORD ,
 
          sr1              RECORD
                   company  LIKE  cob_file.cob01 ,  #FUN-750013 add
                    oea01   LIKE  oea_file.oea01 ,  #
                    oea03   LIKE  oea_file.oea03 ,  #
                    oea04   LIKE  oea_file.oea04 ,  #
                    oea044  LIKE  oea_file.oea044,  #
                    oea06   LIKE  oea_file.oea06 ,  #
                    oea19   LIKE  oea_file.oea19 ,  #
                    oea31   LIKE  oea_file.oea31 ,
                    oea32   LIKE  oea_file.oea32 ,
                    oea38   LIKE  oea_file.oea38 ,  #
                    oea43   LIKE  oea_file.oea43 ,  #
                    oeb03   LIKE  oeb_file.oeb03 ,  #
                    oeb04   LIKE  oeb_file.oeb04 ,  #
                    oeb12   LIKE  oeb_file.oeb12 ,  #
                    oeb13   LIKE  oeb_file.oeb13 ,  #
                    oeb15   LIKE  oeb_file.oeb15 ,  #
                    oeb917  LIKE  oeb_file.oeb917,  #CHI-B70039 add
                    oap041  LIKE  oap_file.oap041 ,  #
                    oap042  LIKE  oap_file.oap042 ,  #
                    oap043  LIKE  oap_file.oap043 ,  #
                    occ01   LIKE  occ_file.occ01 ,
                    occ02   LIKE  occ_file.occ02 ,
                    occ18   LIKE  occ_file.occ18 ,
                    occ61   LIKE  occ_file.occ61 ,
                    occg03  LIKE  occ_file.occ63 ,
                    occg04  LIKE  occ_file.occ64 ,
                    oao06   LIKE  oao_file.oao06 ,
                    oag02   LIKE  oag_file.oag02 ,
                    oah02   LIKE  oah_file.oah02 ,
                    amn     LIKE  pmn_file.pmn20 ,   #金額
                    cred    LIKE  occ_file.occ63 ,   #信用
                    l_t62   LIKE  type_file.num10,   # No.FUN-680137  INT
                    l_dbs   LIKE  faj_file.faj02,    # No.FUN-680137  VARCHAR(10)
                    oea904  LIKE  oea_file.oea904 ,  #流程代碼
                    oea904_no  LIKE type_file.num5,  # No.FUN-680137 SMALLINT
                   #MOD-710194-begin
                    addr1   LIKE  occ_file.occ241,  
                    addr2   LIKE  occ_file.occ241,  
                    addr3   LIKE  occ_file.occ241,  
                 #TQC-750237 begin
                    addr4   LIKE  occ_file.occ241,
                    addr5   LIKE  occ_file.occ241,
                 #TQC-750237 end
                    occ02_2 LIKE  occ_file.occ02,
                    occ18_2 LIKE  occ_file.occ18,
                    addr1_2 LIKE  occ_file.occ241,  
                    addr2_2 LIKE  occ_file.occ241,  
                    addr3_2 LIKE  occ_file.occ241,   
                 #TQC-750237 begin
                    addr4_2 LIKE  occ_file.occ241,
                    addr5_2 LIKE  occ_file.occ241
                 #TQC-750237 end
                   #MOD-710194-end
          END RECORD
 
   LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add
     CALL cl_del_data(l_table)                                    #No.FUN-750013 add
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='axmg830'    #No.FUN-750013 add 
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND oeauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
     #End:FUN-980030
 
     LET l_sql = " SELECT " ,
                 " oea01, oea03,oea04,oea044,oea904, " ,
                 " ''   , ''   , ''   , ''   , ''   , ''   , " ,
                 " ''   , ''   , ''   , ''   , ''   , ''   , " ,
                 " oea_file.* ",
                 " FROM  oea_file " ,
                 " WHERE oea901 = 'Y' ",
                #"   AND oea906 = 'Y' " , #MOD-9A0103     
                 "   AND ", tm.wc  CLIPPED,
                 "   AND oeaconf = 'Y' " #01/08/16 mandy
 
     PREPARE axmg830_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        CALL cl_gre_drop_temptable(l_table)  
      EXIT PROGRAM
     END IF
 
    #CALL cl_outnam('axmg830') RETURNING l_name  #FUN-750013 mark
    #START REPORT axmg830_rep TO l_name          #FUN-750013 mark
     DECLARE axmg830_curs1 CURSOR FOR axmg830_prepare1
    
   #FUN-C50008--add--str
     LET l_sql = "SELECT och03 FROM och_file",
                 " WHERE och01 =? ",
                 "   AND och02 = 6"
     PREPARE t62_poch FROM l_sql
     DECLARE t62_och CURSOR FOR t62_poch
   #FUN-C50008--add--end

     FOREACH axmg830_curs1 INTO sr.*,l_oea.*        
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        #NO.7946
       #MOD-830174-begin-add
        SELECT *  INTO t_azi.*  FROM azi_file  
         WHERE azi01 = l_oea.oea23
       #MOD-830174-end-add
        SELECT  poy03 , poy04 INTO sr.poy03_1 , sr.poy04_1
          FROM poy_file WHERE poy01 = l_oea.oea904 AND poy02 = 1
        SELECT  poy03 , poy04 INTO sr.poy03_2 , sr.poy04_2
          FROM poy_file WHERE poy01 = l_oea.oea904 AND poy02 = 2
        SELECT  poy03 , poy04 INTO sr.poy03_3 , sr.poy04_3
          FROM poy_file WHERE poy01 = l_oea.oea904 AND poy02 = 3
        SELECT  poy03 , poy04 INTO sr.poy03_4 , sr.poy04_4
          FROM poy_file WHERE poy01 = l_oea.oea904 AND poy02 = 4
        SELECT  poy03 , poy04 INTO sr.poy03_5 , sr.poy04_5
          FROM poy_file WHERE poy01 = l_oea.oea904 AND poy02 = 5
        SELECT  poy03 , poy04 INTO sr.poy03_6 , sr.poy04_6
          FROM poy_file WHERE poy01 = l_oea.oea904 AND poy02 = 6
 
        #讀取該訂單之Consignee/Notify/Remark/Shipping Mark
        INITIALIZE l_oed.* TO NULL
        SELECT * INTO l_oed.*
          FROM oed_file
         WHERE oed01=l_oea.oea01
        #讀取來源廠之客戶簡稱/全名
        SELECT occ02,occ18 INTO l_occ02,l_occ18
          FROM occ_file
         WHERE occ01=l_oea.oea04
        IF cl_null(l_occ02) THEN LET l_occ02=' ' END IF  #FUN-750013 add
        IF cl_null(l_occ18) THEN LET l_occ18=' ' END IF  #FUN-750013 add
 
        #讀取來源廠之價格條件名稱
        SELECT oah02 INTO l_oah02
          FROM oah_file
         WHERE oah01=l_oea.oea31
        IF cl_null(l_oah02) THEN LET l_oah02=' ' END IF  #FUN-750013 add
 
        #讀取來源廠之價格條件名稱
        SELECT oag02 INTO l_oag02
          FROM oag_file
         WHERE oag01=l_oea.oea32
        IF cl_null(l_oag02) THEN LET l_oag02=' ' END IF  #FUN-750013 add
 
        #判斷 shipping mark 的資料
        IF cl_null(l_oed.oed061) AND cl_null(l_oed.oed062)
           AND cl_null(l_oed.oed063) AND cl_null(l_oed.oed064)
           AND cl_null(l_oed.oed065) AND cl_null(l_oed.oed066)
           AND cl_null(l_oed.oed067) AND cl_null(l_oed.oed068) THEN
           #三角貿易的其他資料若沒有設定
           SELECT * INTO l_ocf.* FROM ocf_file
            WHERE ocf01=l_oea.oea04 AND ocf02=l_oea.oea44
           LET l_oed.oed061=l_ocf.ocf101  LET l_oed.oed062=l_ocf.ocf102
           LET l_oed.oed063=l_ocf.ocf103  LET l_oed.oed064=l_ocf.ocf104
           LET l_oed.oed065=l_ocf.ocf105  LET l_oed.oed066=l_ocf.ocf106
           LET l_oed.oed067=l_ocf.ocf107  LET l_oed.oed068=l_ocf.ocf108
        END IF
 
       #FUN-750013---add---str---   
        IF cl_null(l_oed.oed021) THEN LET l_oed.oed021 = ' '  END IF
        IF cl_null(l_oed.oed022) THEN LET l_oed.oed022 = ' '  END IF
        IF cl_null(l_oed.oed023) THEN LET l_oed.oed023 = ' '  END IF
 
        IF cl_null(l_oed.oed031) THEN LET l_oed.oed031 = ' '  END IF
        IF cl_null(l_oed.oed032) THEN LET l_oed.oed032 = ' '  END IF
        IF cl_null(l_oed.oed033) THEN LET l_oed.oed033 = ' '  END IF
        IF cl_null(l_oed.oed034) THEN LET l_oed.oed034 = ' '  END IF
 
        IF cl_null(l_oed.oed041) THEN LET l_oed.oed041 = ' '  END IF
        IF cl_null(l_oed.oed042) THEN LET l_oed.oed042 = ' '  END IF
        IF cl_null(l_oed.oed043) THEN LET l_oed.oed043 = ' '  END IF
        IF cl_null(l_oed.oed044) THEN LET l_oed.oed044 = ' '  END IF
 
        IF cl_null(l_oed.oed051) THEN LET l_oed.oed051 = ' '  END IF
        IF cl_null(l_oed.oed052) THEN LET l_oed.oed052 = ' '  END IF
        IF cl_null(l_oed.oed053) THEN LET l_oed.oed053 = ' '  END IF
        IF cl_null(l_oed.oed054) THEN LET l_oed.oed054 = ' '  END IF
        IF cl_null(l_oed.oed055) THEN LET l_oed.oed055 = ' '  END IF
        IF cl_null(l_oed.oed056) THEN LET l_oed.oed056 = ' '  END IF
        IF cl_null(l_oed.oed057) THEN LET l_oed.oed057 = ' '  END IF
        IF cl_null(l_oed.oed058) THEN LET l_oed.oed058 = ' '  END IF
 
        IF cl_null(l_oed.oed061) THEN LET l_oed.oed061 = ' '  END IF
        IF cl_null(l_oed.oed062) THEN LET l_oed.oed062 = ' '  END IF
        IF cl_null(l_oed.oed063) THEN LET l_oed.oed063 = ' '  END IF
        IF cl_null(l_oed.oed064) THEN LET l_oed.oed064 = ' '  END IF
        IF cl_null(l_oed.oed065) THEN LET l_oed.oed065 = ' '  END IF
        IF cl_null(l_oed.oed066) THEN LET l_oed.oed066 = ' '  END IF
        IF cl_null(l_oed.oed067) THEN LET l_oed.oed067 = ' '  END IF
        IF cl_null(l_oed.oed068) THEN LET l_oed.oed068 = ' '  END IF
      #FUN-750013---add---end---   
 
        #抓另外六個工廠的DATABASE
         FOR i = 1 TO 7
            IF i = 7 THEN LET l_azp[i] = ' LOCAL ' END IF
            #抓取本地的資料庫
         
            IF i = 1 AND sr.poy03_1 IS NOT NULL THEN
               SELECT azp03 INTO l_azp[i] FROM azp_file WHERE azp01 = sr.poy04_1
               LET l_plant2[i] = sr.poy04_1    #FUN-A10056
            END IF
            IF i = 2 AND sr.poy03_2 IS NOT NULL THEN
               SELECT azp03 INTO l_azp[i] FROM azp_file WHERE azp01 = sr.poy04_2
               LET l_plant2[i] = sr.poy04_2    #FUN-A10056
            END IF
            IF i = 3 AND sr.poy03_3 IS NOT NULL THEN
               SELECT azp03 INTO l_azp[i] FROM azp_file WHERE azp01 = sr.poy04_3
               LET l_plant2[i] = sr.poy04_3    #FUN-A10056
            END IF
            IF i = 4 AND sr.poy03_4 IS NOT NULL THEN
               SELECT azp03 INTO l_azp[i] FROM azp_file WHERE azp01 = sr.poy04_4
               LET l_plant2[i] = sr.poy04_4    #FUN-A10056
            END IF
            IF i = 5 AND sr.poy03_5 IS NOT NULL THEN
               SELECT azp03 INTO l_azp[i] FROM azp_file WHERE azp01 = sr.poy04_5
               LET l_plant2[i] = sr.poy04_5    #FUN-A10056
            END IF
            IF i = 6 AND sr.poy03_6 IS NOT NULL THEN
               SELECT azp03 INTO l_azp[i] FROM azp_file WHERE azp01 = sr.poy04_6
               LET l_plant2[i] = sr.poy04_6    #FUN-A10056
            END IF
         
            #99.03.01 S/O只印第一張
            IF i <> 7 THEN
               CONTINUE FOR
            END IF
         
            IF cl_null(l_azp[i]) THEN CONTINUE FOR END IF
            LET l_dbs[i] = s_dbstring(l_azp[i] CLIPPED)
            IF i = 7 THEN 
               LET l_dbs[i] = '' 
               LET l_plant2[i]=g_plant    #FUN-A10056
            END IF
            LET sr1.l_dbs=l_dbs[i]
            IF cl_null(sr1.l_dbs) THEN LET sr1.l_dbs=' ' END IF  #FUN-750013 add
         
           #LET l_sql = " SELECT oea01, oea03, oea04,oea044, oea06, ",        #FUN-750013 mark
            LET l_sql = " SELECT '',    oea01, oea03, oea04,oea044, oea06, ", #FUN-750013 mod
                               " oea19, oea31, oea32, oea38, oea43, ",
                               " oeb03, oeb04, oeb12, oeb13, oeb15, ",
                               " oeb917,",                                    #CHI-B70039 add
                               " '' ,'' ,'' ,'' ,'' ,'' ,'','', ",
                               " '' ,'' ,'' ,'' ,'' ,'' ,'', '',oea904,0, ",
                               " '','','','','','','','' ",
                        #FUN-A10056--mod--str--
                        #" FROM ", l_dbs[i] CLIPPED, "oea_file , " ,
                        #          l_dbs[i] CLIPPED, "oeb_file  " ,
                         " FROM ",cl_get_target_table(l_plant2[i],'oea_file'),",",
                                  cl_get_target_table(l_plant2[i],'oeb_file'),
                        #FUN-A10056--mod--end
                        " WHERE oea01 = oeb01 " ,
                          " AND oea01 = '", sr.oea01 , "'",
                          " AND oeaconf = 'Y' " #01/08/16 mandy
         
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,l_plant2[i]) RETURNING l_sql    #FUN-A10056
            PREPARE axmg830_prepare2 FROM l_sql
            IF STATUS THEN CALL cl_err('axmg830_prepare2',STATUS,1) END IF
            DECLARE axmg830_curs2 CURSOR FOR axmg830_prepare2
            FOREACH axmg830_curs2 INTO sr1.*
               IF STATUS THEN CALL cl_err('foreach',STATUS,1) END IF
                
              #FUN-750013---add--str---
               IF cl_null(sr1.oea01)  THEN LET sr1.oea01  = '' END IF 
               IF cl_null(sr1.oea03)  THEN LET sr1.oea03  = '' END IF 
               IF cl_null(sr1.oea04)  THEN LET sr1.oea04  = '' END IF 
               IF cl_null(sr1.oea044) THEN LET sr1.oea044 = '' END IF 
               IF cl_null(sr1.oea06)  THEN LET sr1.oea06  = 0  END IF 
               IF cl_null(sr1.oea19)  THEN LET sr1.oea19  = '' END IF 
               IF cl_null(sr1.oea31)  THEN LET sr1.oea31  = '' END IF 
               IF cl_null(sr1.oea32)  THEN LET sr1.oea32  = '' END IF 
               IF cl_null(sr1.oea38)  THEN LET sr1.oea38  = '' END IF 
               IF cl_null(sr1.oea43)  THEN LET sr1.oea43  = '' END IF 
               IF cl_null(sr1.oeb03)  THEN LET sr1.oeb03  = 0  END IF 
               IF cl_null(sr1.oeb04)  THEN LET sr1.oeb04  = '' END IF 
               IF cl_null(sr1.oeb15)  THEN LET sr1.oeb15  = '' END IF 
               IF cl_null(sr1.oeb917)  THEN LET sr1.oeb917  = '' END IF   #CHI-B70039 add
              #FUN-750013---add--end---
 
               LET l_sql = "SELECT oap041, oap042, oap043 ",
                          #" FROM ", l_dbs[i] CLIPPED, " oap_file " ,   #FUN-A10056
                           "  FROM ",cl_get_target_table(l_plant2[i],'oap_file'),
                           " WHERE oap01 = '",sr1.oea01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant2[i]) RETURNING l_sql    #FUN-A10056
               PREPARE axmg830_prepare3 FROM l_sql
               IF STATUS THEN CALL cl_err('axmg830_prepare3',STATUS,1) END IF
               DECLARE axmg830_curs3 CURSOR FOR axmg830_prepare3
               OPEN axmg830_curs3
               FETCH axmg830_curs3 INTO sr1.oap041, sr1.oap042, sr1.oap043
              #IF STATUS THEN CALL cl_err('fetch',STATUS,1) END IF
               IF sr1.oap041 IS NULL THEN  LET sr1.oap041=' ' END IF
               IF sr1.oap042 IS NULL THEN  LET sr1.oap042=' ' END IF
               IF sr1.oap043 IS NULL THEN  LET sr1.oap043=' ' END IF
               
               LET l_sql = " SELECT occ01, occ02, occ18, occ61 ",
                          #" FROM ", l_dbs[i] CLIPPED , " occ_file " ,   #FUN-A10056
                           "  FROM ",cl_get_target_table(l_plant2[i],'occ_file'),  #FUN-A10056
                           " WHERE  occ01 = '", sr1.oea03 ,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant2[i]) RETURNING l_sql    #FUN-A10056
               PREPARE axmg830_prepare4 FROM l_sql
               IF STATUS THEN CALL cl_err('axmg830_prepare4',STATUS,1) END IF
               DECLARE axmg830_curs4 CURSOR FOR axmg830_prepare4
               OPEN axmg830_curs4
               FETCH axmg830_curs4 INTO sr1.occ01, sr1.occ02, sr1.occ18, sr1.occ61
              #IF STATUS THEN CALL cl_err('fetch',STATUS,1) END IF
               IF sr1.occ01 IS NULL THEN LET sr1.occ01 = '' END IF
               IF sr1.occ02 IS NULL THEN LET sr1.occ02 = '' END IF
               IF sr1.occ18 IS NULL THEN LET sr1.occ18 = '' END IF
               IF sr1.occ61 IS NULL THEN LET sr1.occ61 = '' END IF  #FUN-710013 add
               
              #送貨客戶
               LET l_sql = " SELECT occ02, occ18 ",
                          #" FROM ", l_dbs[i] CLIPPED , " occ_file " ,   #FUN-A10056
                           "  FROM ",cl_get_target_table(l_plant2[i],'occ_file'),  #FUN-A10056
                           " WHERE  occ01 = '", sr1.oea04 ,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant2[i]) RETURNING l_sql    #FUN-A10056
               PREPARE axmg830_pre14 FROM l_sql
               IF STATUS THEN CALL cl_err('axmg830_prepare4',STATUS,1) END IF
               DECLARE axmg830_curs14 CURSOR FOR axmg830_pre14
               OPEN axmg830_curs14
               FETCH axmg830_curs14 INTO sr1.occ02_2, sr1.occ18_2
              #IF STATUS THEN CALL cl_err('fetch',STATUS,1) END IF
               IF sr1.occ02_2 IS NULL THEN LET sr1.occ02_2 = '' END IF
               IF sr1.occ18_2 IS NULL THEN LET sr1.occ18_2 = '' END IF
               
              #No.9072
              #LET l_sql = "SELECT occg03, occg04 ",
               LET l_sql = "SELECT occ63, occ64 ",
                          #" FROM ", l_dbs[i] CLIPPED , " occ_file ",  #FUN-A10056
                           "  FROM ",cl_get_target_table(l_plant2[i],'occ_file'),  #FUN-A10056	
                           " WHERE occ01 = '",sr1.oea03 ,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant2[i]) RETURNING l_sql    #FUN-A10056
               PREPARE axmg830_prepare5 FROM l_sql
               IF STATUS THEN CALL cl_err('axmg830_prepare5',STATUS,1) END IF
               DECLARE axmg830_curs5 CURSOR FOR axmg830_prepare5
               OPEN axmg830_curs5
               FETCH axmg830_curs5 INTO sr1.occg03, sr1.occg04
              # IF STATUS THEN CALL cl_err('fetch',STATUS,1) END IF
               IF sr1.occg03 IS NULL THEN LET sr1.occg03 = 0 END IF
               IF sr1.occg04 IS NULL THEN LET sr1.occg04 = 0 END IF
               LET sr1.cred = sr1.occg03*(1+sr1.occg04/100)
               IF sr1.cred IS NULL THEN LET sr1.cred = 0 END IF   #FUN-750013 add
 
               LET l_sql = "SELECT zo02 ",
                          #" FROM ", l_dbs[i] CLIPPED , " zo_file ",   #FUN-A10056
                           "  FROM ",cl_get_target_table(l_plant2[i],'zo_file'),  #FUN-A10056
                           " WHERE zo01 = '1'"             #FUN-710053 mod
                          #"WHERE zo01 = '",g_lang ,"'"   #FUN-710053 mark
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant2[i]) RETURNING l_sql    #FUN-A10056
               PREPARE axmg830_zo6 FROM l_sql
               IF STATUS THEN CALL cl_err('axmg830_zo6',STATUS,1) END IF
               
               DECLARE axmg830_czo6 CURSOR FOR axmg830_zo6
               OPEN axmg830_czo6
              #FETCH axmg830_czo6 INTO l_company        #FUN-750013 mark
               FETCH axmg830_czo6 INTO sr1.company      #FUN-750013 mod
              #IF STATUS THEN CALL cl_err('fetch',STATUS,1) END IF
               IF sr1.company IS NULL THEN LET sr1.company = '' END IF    #FUN-750013 add
               
               LET l_sql = " SELECT oah02 ",
                          #" FROM ", l_dbs[i] CLIPPED , " oah_file ",   #FUN-A10056
                           "  FROM ",cl_get_target_table(l_plant2[i],'oah_file'),  #FUN-A10056
                           " WHERE oah01 = '", sr1.oea31 , "'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant2[i]) RETURNING l_sql    #FUN-A10056
               PREPARE axmg830_prepare7 FROM l_sql
               IF STATUS THEN CALL cl_err('axmg830_prepare7',STATUS,1) END IF
               DECLARE axmg830_curs7 CURSOR FOR axmg830_prepare7
               OPEN axmg830_curs7
               FETCH axmg830_curs7 INTO sr1.oah02
              #IF STATUS THEN CALL cl_err('fetch',STATUS,1) END IF
               IF sr1.oah02 IS NULL THEN LET sr1.oah02 = ' ' END IF
               
               LET l_sql = " SELECT oao06 ",
                          #" FROM ", l_dbs[i] , " oao_file ",   #FUN-A10056
                           "  FROM ",cl_get_target_table(l_plant2[i],'oao_file'),  #FUN-A10056
                           " WHERE oao01 = '", sr1.oea01 ,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant2[i]) RETURNING l_sql    #FUN-A10056
               PREPARE axmg830_prepare9 FROM l_sql
               IF STATUS THEN CALL cl_err('axmg830_prepare9',STATUS,1) END IF
               DECLARE axmg830_curs9 CURSOR FOR axmg830_prepare9
               OPEN axmg830_curs9
               FETCH axmg830_curs9 INTO sr1.oao06
              #IF STATUS THEN CALL cl_err('fetch',STATUS,1) END IF
               IF sr1.oao06 IS NULL THEN LET sr1.oao06 = ' '  END IF
               
              #-----No.FUN-630086-----
              #LET l_sql = " SELECT ocg48, ocg49, ocg50, ocg51, ocg52 ",
              #            " ocg53, ocg54, ocg55 " ,
              #            " FROM ", l_dbs[i] , " ocg_file ",
              #            " WHERE ocg01 = '", sr1.occ61 ,"'"
              #PREPARE axmg830_prepare11 FROM l_sql
              #IF STATUS THEN CALL cl_err('axmg830_prepare11',STATUS,1) END IF
              #DECLARE axmg830_curs11 CURSOR FOR axmg830_prepare11
              #OPEN axmg830_curs11
              #FETCH axmg830_curs11 INTO g_ocg.ocg48, g_ocg.ocg49,
              #      g_ocg.ocg50, g_ocg.ocg51, g_ocg.ocg52, g_ocg.ocg53,
              #      g_ocg.ocg54, g_ocg.ocg55
              #FUN-C50008--mark--str 
              #  LET l_sql = "SELECT och03 FROM och_file",
              #              " WHERE och01 ='",sr1.occ61,"'",
              #              "   AND och02 = 6"
              #  PREPARE t62_poch FROM l_sql
              #  DECLARE t62_och CURSOR FOR t62_poch
              #FUN-C50008--mark--end  
                   LET l_j = 1
               
                  #FOREACH t62_och INTO l_plant[l_j] #FUN-C50008 mark--
                   FOREACH t62_och USING sr1.occ61 INTO l_plant[l_j] #FUN-C50008 add
                      IF SQLCA.sqlcode THEN
                         CALL cl_err('foreach t62_och:',SQLCA.sqlcode,1)
                         EXIT FOREACH
                      END IF
                  
                      LET l_j = l_j +1
                  
                   END FOREACH
                   IF l_j > 1 THEN       #FUN-750013 add              
                      LET l_j = l_j - 1
                   END IF                #FUN-750013 add
 
               #-----No.FUN-630086 END-----
               
               IF sr1.oeb12 IS NULL THEN LET sr1.oeb12 = 0 END IF
               IF sr1.oeb13 IS NULL THEN LET sr1.oeb13 = 0 END IF
#              LET sr1.amn = sr1.oeb12 * sr1.oeb13   #CHI-B70039 mark
               LET sr1.amn = sr1.oeb917 * sr1.oeb13  #CHI-B70039
               CALL cl_digcut(sr1.amn,t_azi.azi04) RETURNING sr1.amn   #MOD-950195
               CALL cal_t62(sr1.occ01) RETURNING l_t62
               IF cl_null(l_t62) THEN LET l_t62 = 0 END IF   #FUN-750013 add 
               LET sr1.l_t62 = l_t62
               IF sr1.amn IS NULL THEN LET sr1.amn = 0 END IF   #FUN-750013 add
 
               IF i=7 THEN LET sr1.oea904_no=0 ELSE LET sr1.oea904_no=i END IF
               #讀取地址資料
                LET sr1.addr1=''
                LET sr1.addr1_2=''   
                #TQC-750237................begin
                LET sr1.addr2=''
                LET sr1.addr3=''
                LET sr1.addr4=''
                LET sr1.addr5=''
                LET sr1.addr1_2=''
                LET sr1.addr2_2=''
                LET sr1.addr3_2=''
                LET sr1.addr4_2=''
                LET sr1.addr5_2=''
                #TQC-750237................end
                CALL s_addrm(sr.oea01,l_oea.oea04,sr.oea044,'')
                     RETURNING sr1.addr1,sr1.addr2,sr1.addr3,
                               sr1.addr4,sr1.addr5 #TQC-750237
                CALL s_addrm(sr.oea01,sr.oea04,'','')
                     RETURNING sr1.addr1_2,sr1.addr2_2,sr1.addr3_2,
                               sr1.addr4_2,sr1.addr5_2 #TQC-750237
                #指定價格條件/付款條件為來源工廠
                LET sr1.oag02 = l_oag02
                LET sr1.oah02 = l_oah02
               
              #OUTPUT TO REPORT axmg830_rep(l_company,sr1.*,  #FUN-750013 mark
              #     l_oea.*,l_oed.*,l_occ02,l_occ18)          #FUN-750013 mark
 
              #FUN-750013---add---str---
              EXECUTE insert_prep USING 
                sr1.company,
                sr1.oea01,     sr1.oea03,     sr1.oea04,
                sr1.oea044,    sr1.oea06,     sr1.oea19,
                sr1.oea31,     sr1.oea32,     sr1.oea38,
                sr1.oea43,     sr1.oeb03,     sr1.oeb04,
                sr1.oeb12,     sr1.oeb13,     sr1.oeb15,
                sr1.oap041,    sr1.oap042,    sr1.oap043,
                sr1.occ01,     sr1.occ02,     sr1.occ18,
                sr1.occ61,     sr1.occg03,    sr1.occg04,
                sr1.oao06,     sr1.oag02,     sr1.oah02,
                sr1.amn,       sr1.cred,      sr1.l_t62,
                sr1.l_dbs,     sr1.oea904,    sr1.oea904_no,
                sr1.addr1,     sr1.addr2,     sr1.addr3,
                sr1.addr4,     sr1.addr5,     sr1.occ02_2,
                sr1.occ18_2,   sr1.addr1_2,   sr1.addr2_2,
                sr1.addr3_2,   sr1.addr4_2,   sr1.addr5_2,
                l_oed.oed021,  l_oed.oed022,  l_oed.oed023,  
                l_oed.oed031,  l_oed.oed032,  l_oed.oed033,  l_oed.oed034, 
                l_oed.oed041,  l_oed.oed042,  l_oed.oed043,  l_oed.oed044,
                l_oed.oed051,  l_oed.oed052,  l_oed.oed053,  l_oed.oed054,
                l_oed.oed055,  l_oed.oed056,  l_oed.oed057,  l_oed.oed058,
                l_oed.oed061,  l_oed.oed062,  l_oed.oed063,  l_oed.oed064,
                l_oed.oed065,  l_oed.oed066,  l_oed.oed067,  l_oed.oed068,
                l_occ02,       l_occ18     ,  t_azi.azi03 ,  t_azi.azi04 ,  #MOD-830174
                t_azi.azi05 ,  l_oea.oea23   ,"",  l_img_blob,"N",""  # No.FUN-C40020 add                               #MOD-830174  
                #FUN-750013---add---end---
            END FOREACH
         END FOR
     END FOREACH
 
    #No.FUN-750013--add---str---
###GENGRE###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea04,oea14,oea904')
             RETURNING tm.wc
     ELSE 
        LET tm.wc = ''
     END IF
     SELECT gaz03 INTO l_gaz03 FROM gaz_file WHERE gaz01 = g_prog AND gaz02='1'
###GENGRE###     LET g_str = tm.wc,";",g_azi03,";",g_azi04,";",g_azi05,";",l_gaz03   
###GENGRE###     CALL cl_prt_cs3('axmg830','axmg830',g_sql,g_str)
    LET g_cr_table = l_table                    # No.FUN-C40020 add
    LET g_cr_apr_key_f = "oea01"                    # No.FUN-C40020 add
    CALL axmg830_grdata()    ###GENGRE###
    #No.FUN-750013--add---end---
 
    #FINISH REPORT axmg830_rep                   #FUN-750013 mark
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len) #FUN-750013 mark
 
END FUNCTION
 
#FUN-750013---mark---str---
#REPORT axmg830_rep(sr1,l_oea,l_oed,l_occ02,l_occ18)
#   DEFINE  p_mode    LIKE type_file.chr1         # No.FUN-680137 VARCHAR(1)
#   DEFINE l_last_sw  LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
#          l_cnt      LIKE type_file.num10,       # No.FUN-680137 INT
#          l_amt01    LIKE pmn_file.pmn20 ,
#          l_amt02    LIKE pmn_file.pmn31 ,
#          l_sql      LIKE type_file.chr1000,       #No.FUN-680137  VARCHAR(1000)
#          l_oao06    LIKE oao_file.oao06 ,
#          l_i        LIKE type_file.num5,          #No.FUN-680137 SMALLINT
#          l_i2       LIKE type_file.num5,          #No.FUN-680137 SMALLINT
#          l_oea     RECORD LIKE oea_file.*,
#          l_oed     RECORD LIKE oed_file.*,
#          l_occ02   LIKE occ_file.occ02,
#          l_occ18   LIKE occ_file.occ18,
#          sr1              RECORD
#                    company   LIKE cob_file.cob01,   # No.FUN-680137  VARCHAR(36)
#                    oea01  LIKE  oea_file.oea01 ,  #
#                    oea03  LIKE  oea_file.oea03 ,  #
#                    oea04  LIKE  oea_file.oea04 ,  #
#                    oea044 LIKE  oea_file.oea044 , #
#                    oea06  LIKE  oea_file.oea06 ,  #
#                    oea19  LIKE  oea_file.oea19 ,  #
#                    oea31  LIKE  oea_file.oea31 ,
#                    oea32  LIKE  oea_file.oea32 ,
#                    oea38  LIKE  oea_file.oea38 ,  #
#                    oea43  LIKE  oea_file.oea43 ,  #
#                    oeb03  LIKE  oeb_file.oeb03 ,  #
#                    oeb04  LIKE  oeb_file.oeb04 ,  #
#                    oeb12  LIKE  oeb_file.oeb12 ,  #
#                    oeb13  LIKE  oeb_file.oeb13 ,  #
#                    oeb15  LIKE  oeb_file.oeb15 ,  #
#                    oap041 LIKE  oap_file.oap041 , #
#                    oap042 LIKE  oap_file.oap042 , #
#                    oap043 LIKE  oap_file.oap043 , #
#                    occ01  LIKE  occ_file.occ01 ,
#                    occ02  LIKE  occ_file.occ02 ,
#                    occ18  LIKE  occ_file.occ18 ,
#                    occ61  LIKE  occ_file.occ61 ,
#                    occg03  LIKE  occ_file.occ63 ,
#                    occg04  LIKE  occ_file.occ64 ,
#                    oao06  LIKE  oao_file.oao06 ,
#                    oag02  LIKE  oag_file.oag02 ,
#                    oah02  LIKE  oah_file.oah02 ,
#                    amn    LIKE  pmn_file.pmn20 ,   #金額
#                    cred   LIKE  occ_file.occ63 ,   #信用
#                    l_t62  LIKE type_file.num10,    # No.FUN-680137 INT
#                    l_dbs  LIKE faj_file.faj02,     # No.FUN-680137 VARCHAR(10)
#                    oea904 LIKE  oea_file.oea904 ,  #流程代碼 
#                    oea904_no  LIKE type_file.num5, # No.FUN-680137 SMALLINT
#                   #MOD-710194-begin
#                    addr1   LIKE occ_file.occ241,  
#                    addr2   LIKE occ_file.occ241,  
#                    addr3   LIKE occ_file.occ241,  
#                   #TQC-750237 begin
#                    addr4   LIKE occ_file.occ241,
#                    addr5   LIKE occ_file.occ241,
#                   #TQC-750237 end
#                    occ02_2 LIKE  occ_file.occ02,
#                    occ18_2  LIKE  occ_file.occ18,
#                    addr1_2 LIKE occ_file.occ241,  
#                    addr2_2 LIKE occ_file.occ241,  
#                    addr3_2 LIKE occ_file.occ241,  
#                   #TQC-750237 begin
#                    addr4_2 LIKE occ_file.occ241,
#                    addr5_2 LIKE occ_file.occ241
#                   #TQC-750237 end
#                   #MOD-710194-end
#          END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr1.oea01,sr1.oea904,sr1.oea904_no, sr1.oeb03
#  FORMAT
#   PAGE HEADER
#
#      PRINT ''
#      PRINT COLUMN 19 , sr1.company CLIPPED ,
#            COLUMN 55 , g_x[12] CLIPPED ,    #SO NUM
#            COLUMN 63 , sr1.oea01
#      PRINT g_x[13] CLIPPED
#      PRINT COLUMN 23 , g_x[14] CLIPPED ,     #SALES ORDER
#            COLUMN 55 , g_x[15] CLIPPED ,     #DATE
#            COLUMN 64,g_pdate USING "yyyymmdd" CLIPPED
#      PRINT g_x[16] CLIPPED ,
#            COLUMN 11 , sr1.oea03 CLIPPED ,  #P/O TO
#            COLUMN 22 , sr1.occ18 CLIPPED
#
#      PRINT g_dash2[1,g_len]
#      PRINT g_x[18] CLIPPED ,                 #SHIP TO
#            COLUMN 14 , sr1.oea04 CLIPPED ,   #送貨客戶
#            COLUMN 38 , g_x[19] CLIPPED ,     #CEC NUMBER
#            COLUMN 50 , sr1.oea01 CLIPPED ,   #訂單單號
#            COLUMN 62 , '-' ,
#            COLUMN 64 , sr1.oea06 CLIPPED
#      PRINT g_dash2[1,g_len]
#
#      PRINT "(",sr1.oea04 CLIPPED," ",sr1.occ02 CLIPPED,")",
#            COLUMN 38,"SHIPPING INFORMATION"
#      PRINT l_occ18 CLIPPED ,
#            COLUMN 38 , "TYPE      :",l_oea.oea43    #交運方式
#      PRINT sr1.addr1 CLIPPED ,
#            COLUMN 38 , "FORWARDER :",l_oed.oed021 CLIPPED
#      PRINT sr1.addr2 CLIPPED ,
#            COLUMN 49 , l_oed.oed022 CLIPPED
#      PRINT sr1.addr3 CLIPPED ,
#            COLUMN 49 , l_oed.oed023 CLIPPED
#    #TQC-750237 begin
#      PRINT sr1.addr4 CLIPPED
#      PRINT sr1.addr5 CLIPPED
#    #TQC-750237 end
#      PRINT " "
#      PRINT "CREDIT  :",
#            COLUMN 11 , sr1.cred ,
#            COLUMN 38 , "PRICE TERM:",sr1.oah02  CLIPPED
#      PRINT g_x[28] CLIPPED  ,
#            COLUMN 11 , sr1.l_t62,             #計算信用
#            COLUMN 38 , "PAYMENT TO:",sr1.oag02  CLIPPED
#      PRINT g_dash2[1,g_len]
#      PRINT g_x[29] CLIPPED ,    #Consignee
#            COLUMN 38,'NOTIFY PARTY:'
#      PRINT l_oed.oed031[1,36], COLUMN 38,l_oed.oed041[1,36]
#      PRINT l_oed.oed032[1,36], COLUMN 38,l_oed.oed042[1,36]
#      PRINT l_oed.oed033[1,36], COLUMN 38,l_oed.oed043[1,36]
#      PRINT l_oed.oed034[1,36], COLUMN 38,l_oed.oed044[1,36]
#
##No.FUN-580013  --begin
#      PRINT g_dash[1,g_len]
#      PRINT g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],g_x[56]
#      PRINT g_dash1
#      LET l_last_sw = 'n'                #FUN-550127
##No.FUN-580013  --end
#
#   BEFORE GROUP OF sr1.oea904_no
#
#      SKIP TO TOP OF PAGE
#
#   ON EVERY ROW
##No.FUN-580013  --begin
#     PRINT COLUMN g_c[51] , sr1.oeb03 CLIPPED,
#           COLUMN g_c[52] , sr1.oeb04 CLIPPED ,
#           COLUMN g_c[53] , cl_numfor(sr1.oeb12,53,g_azi04),
#           COLUMN g_c[54] , cl_numfor(sr1.oeb13,54,g_azi03),
#           COLUMN g_c[55] , cl_numfor(sr1.amn,55,g_azi04),
#           COLUMN g_c[56] , sr1.oeb15 USING'yyyymmdd' CLIPPED
##No.FUN-580013  --end
#
#  #AFTER GROUP OF sr1.oea03
#   AFTER GROUP OF sr1.oea904_no
#      LET l_amt01 = GROUP SUM(sr1.oeb12)
#      LET l_amt02 = GROUP SUM(sr1.amn)
#
#      PRINT ''
#      PRINT ''
#      PRINT ''
#      PRINT g_x[39] CLIPPED
#      PRINT g_dash2[1,g_len]
#      PRINT g_x[40] CLIPPED ,
##No.FUN-580013  --begin
#            COLUMN g_c[53] , cl_numfor(l_amt01,53,g_azi05),
#            COLUMN g_c[55] , cl_numfor(l_amt02,55,g_azi05)
##No.FUN-580013  --end
#      PRINT g_dash2[1,g_len]
#      PRINT g_x[41] CLIPPED ,
#            COLUMN 67 , g_x[45] CLIPPED
#      PRINT g_dash2[1,g_len]
# 
#      #REMARK /SHIPPING MARK
#      PRINT COLUMN 1,"1.",l_oed.oed051 CLIPPED,COLUMN 64,l_oed.oed061[1,20]
#      PRINT COLUMN 1,"2.",l_oed.oed052 CLIPPED,COLUMN 64,l_oed.oed062[1,20]
#      PRINT COLUMN 1,"3.",l_oed.oed053 CLIPPED,COLUMN 64,l_oed.oed063[1,20]
#      PRINT COLUMN 1,"4.",l_oed.oed054 CLIPPED,COLUMN 64,l_oed.oed064[1,20]
#      PRINT COLUMN 1,"5.",l_oed.oed055 CLIPPED,COLUMN 64,l_oed.oed065[1,20]
#      PRINT COLUMN 1,"6.",l_oed.oed056 CLIPPED,COLUMN 64,l_oed.oed066[1,20]
#      PRINT COLUMN 1,"7.",l_oed.oed057 CLIPPED,COLUMN 64,l_oed.oed067[1,20]
#      PRINT COLUMN 1,"8.",l_oed.oed058 CLIPPED,COLUMN 64,l_oed.oed068[1,20]
# 
#      PRINT ''
#      PRINT ''
#      PRINT ''
#      PRINT g_x[42] CLIPPED ,
#            COLUMN 45 , g_x[43] CLIPPED
#      PRINT ''
#      PRINT g_x[44] CLIPPED
#
### FUN-550127
#ON LAST ROW
#      LET l_last_sw = 'y'
#
#PAGE TRAILER
#      PRINT ''
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
### END FUN-550127
#
#END REPORT
#FUN-750013---mark---end---
 
#---------------------------------------#
# 多工廠發票應收帳計算 by WUPN 96-05-23 #
#---------------------------------------#
 
FUNCTION cal_t62(l_occ01)
   DEFINE l_occ01      LIKE occ_file.occ01,
          l_t62,l_tmp  LIKE type_file.num10,         # No.FUN-680137 INTEGER
          l_i          LIKE type_file.num10,         # No.FUN-680137 INTEGER
          l_sql        LIKE type_file.chr1000,       #No.FUN-680137  VARCHAR(1000)
          l_azp01      LIKE azp_file.azp01,
          l_azp03      LIKE azp_file.azp03
   #      l_plant      ARRAY[8] OF VARCHAR(10)          # 工廠編號
 
   #-----No.FUN-630086 Mark-----
   #LET l_plant[1]=g_ocg.ocg48    LET l_plant[2]=g_ocg.ocg49
   #LET l_plant[3]=g_ocg.ocg50    LET l_plant[4]=g_ocg.ocg51
   #LET l_plant[5]=g_ocg.ocg52    LET l_plant[6]=g_ocg.ocg53
   #LET l_plant[7]=g_ocg.ocg54    LET l_plant[8]=g_ocg.ocg55
   #-----No.FUN-630086 Mark END-----
 
    LET l_t62=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF   #No.TQC-A50044
       SELECT azp03 INTO l_azp03           # DATABASE ID
        FROM azp_file WHERE azp01=l_plant[l_i]
     # LET l_sql=" SELECT SUM(oma56t-oma57) FROM ",l_azp03 CLIPPED,".dbo.oma_file",
       #No.TQC-5C0087  --Begin                                                                                                      
       IF g_ooz.ooz07 = 'N' THEN                                                                                                    
         #LET l_sql=" SELECT SUM(oma56t-oma57) FROM ",l_azp03 CLIPPED,".dbo.oma_file",             #TQC-950032 MARK                     
         #LET l_sql=" SELECT SUM(oma56t-oma57) FROM ",s_dbstring(l_azp03 CLIPPED),"oma_file",  #TQC-950032 ADD  #FUN-A10056 
          LET l_sql=" SELECT SUM(oma56t-oma57) ",    #FUN-A10056
                    "   FROM ",cl_get_target_table(l_plant[l_i],'oma_file'),   #FUN-A10056
                    " WHERE oma03='",l_occ01,"'",                                                                                   
                    " AND omaconf='Y' AND oma00 LIKE '1%'"                                                                          
       ELSE                                                                                                                         
         #LET l_sql=" SELECT SUM(oma61) FROM ",l_azp03 CLIPPED,".dbo.oma_file",               #TQC-950032 MARK                          
         #LET l_sql=" SELECT SUM(oma61) FROM ",s_dbstring(l_azp03 CLIPPED),"oma_file",    #TQC-950032 ADD  
          LET l_sql=" SELECT SUM(oma61) ",     #FUN-A10056
                    "   FROM ",cl_get_target_table(l_plant[l_i],'oma_file'),   #FUN-A10056
                    " WHERE oma03='",l_occ01,"'",                                                                                   
                    " AND omaconf='Y' AND oma00 LIKE '1%'"                                                                          
       END IF                                                                                                                       
       #No.TQC-5C0087  --End 
       CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql    #FUN-A10056
       PREPARE t62_pre FROM l_sql
       DECLARE t62_curs CURSOR FOR t62_pre
       OPEN t62_curs LET l_tmp=0
       FETCH t62_curs INTO l_tmp IF cl_null(l_tmp) THEN LET l_tmp=0 END IF
       LET l_t62=l_t62+l_tmp
       CLOSE t62_curs
    END FOR
    RETURN l_t62
END FUNCTION
 
#Patch....NO.TQC-610037 <> #

###GENGRE###START
FUNCTION axmg830_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    LOCATE sr1.sign_img IN MEMORY      # No.FUN-C40020 add
    CALL cl_gre_init_apr()             # No.FUN-C40020 add
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("axmg830")
        IF handler IS NOT NULL THEN
            START REPORT axmg830_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY oea01,oeb03"
          
            DECLARE axmg830_datacur1 CURSOR FROM l_sql
            FOREACH axmg830_datacur1 INTO sr1.*
                OUTPUT TO REPORT axmg830_rep(sr1.*)
            END FOREACH
            FINISH REPORT axmg830_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axmg830_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno         LIKE type_file.num5
    #FUN-B40092------add------str
    DEFINE l_oeb12_sum      LIKE oeb_file.oeb12
    DEFINE l_amn_sum        LIKE pmn_file.pmn20
    DEFINE l_p5             LIKE gaz_file.gaz03
    DEFINE l_oeb12_fmt      STRING
    DEFINE l_oeb13_fmt      STRING
    DEFINE l_amn_fmt        STRING
    DEFINE l_oeb12_sum_fmt  STRING
    DEFINE l_amn_sum_fmt    STRING
    #FUN-B40092------add------end
    
    ORDER EXTERNAL BY sr1.oea01,sr1.oea904
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.oea01
            #FUN-B40092------add------str
            SELECT gaz03 INTO l_p5 FROM gaz_file WHERE gaz01 = g_prog AND gaz02='1'
            PRINTX l_p5
            LET l_oeb12_fmt = cl_gr_numfmt('oeb_file','oeb12',g_azi04)
            LET l_oeb13_fmt = cl_gr_numfmt('oeb_file','oeb13',sr1.azi03)
            LET l_amn_fmt = cl_gr_numfmt('pmn_file','pmn20',sr1.azi04)
            PRINTX l_oeb12_fmt
            PRINTX l_oeb13_fmt 
            PRINTX l_amn_fmt 
            #FUN-B40092------add------end
            LET l_lineno = 0
        BEFORE GROUP OF sr1.oea904

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.oea01
        AFTER GROUP OF sr1.oea904
            #FUN-B40092------add------str
            LET l_oeb12_sum = GROUP SUM(sr1.oeb12)
            LET l_amn_sum   = GROUP SUM(sr1.amn)
            PRINTX l_oeb12_sum
            PRINTX l_amn_sum
            LET l_oeb12_sum_fmt = cl_gr_numfmt('oeb_file','oeb12',g_azi05)
            LET l_amn_sum_fmt = cl_gr_numfmt('pmn_file','pmn20',sr1.azi05)
            PRINTX l_oeb12_sum_fmt
            PRINTX l_amn_sum_fmt
            #FUN-B40092------add------end
        
        ON LAST ROW

END REPORT
###GENGRE###END
