# Prog. Version..: '5.30.06-13.03.18(00001)'     #
#
# Pattern name...: gnmg250.4gl
# Descriptions...: 應收票據異動憑証列印
# Date & Author..: 97/04/24 By Charis
# Modify.........: NO.FUN-550057 05/05/23 By jackie 單據編號加大
# Modify.........: No.FUN-550114 05/05/26 By echo 新增報表備註
# Modify.........: No.FUN-570177 05/07/19 By Trisy 項次位數加大
# Modify.........: No.FUN-580010 05/08/02 By will 報表轉XML格式
# Modify.........: NO.FUN-590118 06/01/04 By Rosayu 將項次改成'###&'
# Modify.........: NO.MOD-640031 06/04/08 By Echo 客戶請顯示簡稱
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6B0155 06/12/13 By chenl 增加每頁上的程序名稱和接下頁或結束的標注。
# Modify.........: No.FUN-710085 07/02/01 By wujie 使用水晶報表打印
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.FUN-750140 07/05/30 By Nicole 變數定義間漏了一個逗號
# Modify.........: No.TQC-830031 08/03/27 By Carol l_cmd 型態改為type_file.chr1000
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B40087 11/06/08 By yangtt  憑證報表轉GRW
# Modify.........: No.FUN-C40020 12/04/10 By qirl  GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50007 12/05/02 By minpp GR程序优化
# Modify.........: No.FUN-CC0093 12/12/20 By wangrr GR程式修改
# Modify.........: No.FUN-D10098 13/02/01 By lujh 新增gnmg250

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              #wc     LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(600) # Where condition   #FUN-CC0093 mark
              wc      STRING,                #FUN-CC0093 add
              n       LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)   # 列印單價
              more    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)   # Input more condition(Y/N)
              END RECORD,
          g_nmh    RECORD LIKE nmh_file.*
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(72)
#No.FUN-580010  --begin
#DEFINE   g_dash          LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(400) #Dash line
#DEFINE   g_len           LIKE type_file.num5    #No.FUN-680107 SMALLINT  #Report width(79/132/136)
#DEFINE   g_pageno        LIKE type_file.num5    #No.FUN-680107 SMALLINT  #Report page no
#DEFINE   g_zz05          LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)   #Print tm.wc ?(Y/N)
#No.FUN-580010   --end
DEFINE l_table       STRING                   #FUN-710085 add
DEFINE g_sql         STRING                   #FUN-710085 add
DEFINE g_str         STRING                   #FUN-710085 add
DEFINE g_bookno1     LIKE aza_file.aza81      #FUN-C50007
DEFINE g_bookno2     LIKE aza_file.aza82      #FUN-C50007
DEFINE g_flag        LIKE type_file.chr1      #FUN-C50007


###GENGRE###START
TYPE sr1_t RECORD
    npn01 LIKE npn_file.npn01,
    npn02 LIKE npn_file.npn02,
    npn03 LIKE npn_file.npn03,
    npn04 LIKE npn_file.npn04,
    npn05 LIKE npn_file.npn05,
    npn06 LIKE npn_file.npn06,
    npn07 LIKE npn_file.npn07,
    npn08 LIKE npn_file.npn08,
    npn09 LIKE npn_file.npn09,
    npn10 LIKE npn_file.npn10,
    npn11 LIKE npn_file.npn11,
    npn12 LIKE npn_file.npn12,
    npn13 LIKE npn_file.npn13,
    npn14 LIKE npn_file.npn14,
    npo02 LIKE npo_file.npo02,
    npo03 LIKE npo_file.npo03,
    npo04 LIKE npo_file.npo04,
    npo05 LIKE npo_file.npo05,
    npo06 LIKE npo_file.npo06,
    npo07 LIKE npo_file.npo07,
    npo08 LIKE npo_file.npo08,
    nmh05 LIKE nmh_file.nmh05,
    nmh09 LIKE nmh_file.nmh09,
    nmh11 LIKE nmh_file.nmh11,
    nmh21 LIKE nmh_file.nmh21,
    nmh28 LIKE nmh_file.nmh28,
    nmh31 LIKE nmh_file.nmh31,
    nma02 LIKE nma_file.nma02,
    pmc03 LIKE pmc_file.pmc03,
    aag02 LIKE aag_file.aag02,  #FUN-C50007
    aag02_1 LIKE aag_file.aag02,#FUN-C50007
    occ02 LIKE occ_file.occ02,
    nmydesc LIKE nmy_file.nmydesc,
    nma02_1 LIKE nma_file.nma02,
    azi04_t LIKE azi_file.azi04,
    azi05_t LIKE azi_file.azi05,
    azi07_t LIKE azi_file.azi07,
    azi04_g LIKE azi_file.azi04,
    azi05_g LIKE azi_file.azi05,
    sign_type LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_img  LIKE type_file.blob,   # No.FUN-C40020 add
    sign_show LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_str  LIKE type_file.chr1000 # No.FUN-C40020 add
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GNM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
#No.FUN-710085--begin
   LET g_sql = "npn01.npn_file.npn01,",     
               "npn02.npn_file.npn02,",     
               "npn03.npn_file.npn03,",     
               "npn04.npn_file.npn04,",     
               "npn05.npn_file.npn05,",     
               "npn06.npn_file.npn06,",     
               "npn07.npn_file.npn07,",     
               "npn08.npn_file.npn08,",     
               "npn09.npn_file.npn09,",     
               "npn10.npn_file.npn10,",     
               "npn11.npn_file.npn11,",     
               "npn12.npn_file.npn12,",     
               "npn13.npn_file.npn13,",     
               "npn14.npn_file.npn14,",     
               "npo02.npo_file.npo02,",     
               "npo03.npo_file.npo03,",     
               "npo04.npo_file.npo04,",     
               "npo05.npo_file.npo05,",     
               "npo06.npo_file.npo06,",     
               "npo07.npo_file.npo07,",     
               "npo08.npo_file.npo08,",     
               "nmh05.nmh_file.nmh05,",     
               "nmh09.nmh_file.nmh09,",     
               "nmh11.nmh_file.nmh11,",     
               "nmh21.nmh_file.nmh21,",     
               "nmh28.nmh_file.nmh28,",     
               "nmh31.nmh_file.nmh31,",     
               "nma02.nma_file.nma02,",     
               "pmc03.pmc_file.pmc03,",    
               "aag02.aag_file.aag02,",   #FUN-C50007
               "aag02_1.aag_file.aag02,", #FUN-C50007
               "occ02.occ_file.occ02,",     
               "nmydesc.nmy_file.nmydesc,", 
               "nma02_1.nma_file.nma02,",
               "azi04_t.azi_file.azi04,",
               "azi05_t.azi_file.azi05,",
               "azi07_t.azi_file.azi07,",
               "azi04_g.azi_file.azi04,",
               "azi05_g.azi_file.azi05,",
               "sign_type.type_file.chr1,sign_img.type_file.blob,",  # No.FUN-C40020 add
               "sign_show.type_file.chr1,sign_str.type_file.chr1000" # No.FUN-C40020 add
 
   LET l_table = cl_prt_temptable('gnmg250',g_sql) CLIPPED  
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM 
   END IF                
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" #FUN-750140#FUN-C40020-----ADD-#FUN-C50007 ADD 2?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM
   END IF
#No.FUN-710085--end
   #-----TQC-610058---------
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.n = ARG_VAL(8)
   #-----END TQC-610058-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(tm.wc)
      THEN CALL gnmg250_tm(0,0)             # Input print condition
      ELSE 
           CALL gnmg250()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION gnmg250_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01      #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,     #No.FUN-680107 SMALLINT
       l_cmd          LIKE type_file.chr1000   #TQC-830031-modify  #No.FUN-680107 VARCHAR(400)
DEFINE comb_value     STRING                 #FUN-CC0093 add
DEFINE comb_item      LIKE type_file.chr1000 #FUN-CC0093 add 

   LET p_row = 5 LET p_col = 15
   OPEN WINDOW gnmg250_w AT p_row,p_col
        WITH FORM "gnm/42f/gnmg250"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
   #FUN-CC0093--add--str--
   IF g_aza.aza26 = '2' THEN
       LET comb_value = '3,4,5,6,7,8,9' 
       SELECT ze03 INTO comb_item FROM ze_file
        WHERE ze01='anm-662' AND ze02=g_lang
       CALL cl_set_combo_items('npn03',comb_value,comb_item)
     END IF
   #FUN-CC0093--add--end
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.n ='3'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON npn01,npn02,npn03,npn04,npn13
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
          WHEN INFIELD(npn01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_npn"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO npn01
             NEXT FIELD npn01
          WHEN INFIELD(npn04)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_azi"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO npn04
             NEXT FIELD npn04
          WHEN INFIELD(npn13)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_npn13"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO npn13
             NEXT FIELD npn13  
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
      LET INT_FLAG = 0 CLOSE WINDOW gnmg250_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.n,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD n
         IF cl_null(tm.n) OR tm.n NOT MATCHES '[123]' THEN
            NEXT FIELD n
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
        IF INT_FLAG THEN EXIT INPUT END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW gnmg250_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='gnmg250'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gnmg250','9031',1)
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
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.n CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('gnmg250',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW gnmg250_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gnmg250()
   ERROR ""
END WHILE
   CLOSE WINDOW gnmg250_w
END FUNCTION
 
FUNCTION gnmg250()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8       #No.FUN-6A0082
          #l_sql    LIKE type_file.chr1000,		  #No.FUN-680107 VARCHAR(3000)      #FUN-CC0093  mark
          l_sql     STRING,                       #FUN-CC0093 add
          l_za05    LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(40)
          sr        RECORD
                    npn01     LIKE npn_file.npn01,
                    npn02     LIKE npn_file.npn02,
                    npn03     LIKE npn_file.npn03,
                    npn04     LIKE npn_file.npn04,
                    npn05     LIKE npn_file.npn05,
                    npn06     LIKE npn_file.npn06,
                    npn07     LIKE npn_file.npn07,
                    npn08     LIKE npn_file.npn08,
                    npn09     LIKE npn_file.npn09,
                    npn10     LIKE npn_file.npn10,
                    npn11     LIKE npn_file.npn11,
                    npn12     LIKE npn_file.npn12,
                    npn13     LIKE npn_file.npn13,
                    npn14     LIKE npn_file.npn14,
                    npo02     LIKE npo_file.npo02,
                    npo03     LIKE npo_file.npo03,
                    npo04     LIKE npo_file.npo04,
                    npo05     LIKE npo_file.npo05,
                    npo06     LIKE npo_file.npo06,
                    npo07     LIKE npo_file.npo07,
                    npo08     LIKE npo_file.npo08
                    END RECORD
#No.FUN-710085--begin
   DEFINE l_nma02,l_nma02_1 LIKE nma_file.nma02
   DEFINE l_occ02           LIKE occ_file.occ02
   DEFINE l_pmc03           LIKE pmc_file.pmc03
   DEFINE l_nmydesc         LIKE nmy_file.nmydesc
   DEFINE l_t1              LIKE nmy_file.nmyslip
   DEFINE t_azi04           LIKE azi_file.azi04   
   DEFINE t_azi05           LIKE azi_file.azi05   
   DEFINE t_azi07           LIKE azi_file.azi07   
   DEFINE l_img_blob        LIKE type_file.blob
   DEFINE l_aag02           LIKE aag_file.aag02   #FUN-C50007
   DEFINE l_aag02_1         LIKE aag_file.aag02   #FUN-C50007

     CALL cl_del_data(l_table)
     LOCATE l_img_blob        IN MEMORY 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'gnmg250'
#No.FUN-710085--end
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-580010  --begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gnmg250'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 101 END IF     #No.FUN-550057
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-580010  --end
#NO.CHI-6A0004--BEGIN
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#NO.CHI-6A0004--END
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND npnuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND npngrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND npngrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('npnuser', 'npngrup')
     #End:FUN-980030
 
     LET l_sql="SELECT npn01,npn02,npn03,npn04,npn05,",
               "  npn06,npn07,npn08,npn09,npn10,npn11,",
               "  npn12,npn13,npn14,npo02,npo03,npo04,npo05,npo06,npo07,npo08,",
               "  nma02,pmc03,azi04,azi05,azi07", #FUN-C50007 ADD  
              #FUN-C50007--MOD--str 
              #"  FROM npn_file,npo_file",
               "  FROM npn_file LEFT OUTER JOIN nma_file ON npn13=nma01 LEFT OUTER JOIN pmc_file ON npn14=pmc01 ",
               "  LEFT OUTER JOIN azi_file  ON npn04=azi01 ",
               "  ,npo_file ",
              #FUN-C50007--MOD--END 
               " WHERE npn01=npo01 ",
               "   AND npnconf <> 'X' ",
               "   AND ",tm.wc CLIPPED
     IF tm.n='1' THEN
        LET l_sql=l_sql CLIPPED," AND npnconf='Y' "
     END IF
     IF tm.n='2' THEN
        LET l_sql=l_sql CLIPPED," AND npnconf='N' "
     END IF
     LET l_sql=l_sql CLIPPED," ORDER BY npn01,npo02 "
     PREPARE gnmg250_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        CALL cl_gre_drop_temptable(l_table)
        EXIT PROGRAM 
     END IF
     DECLARE gnmg250_curs1 CURSOR FOR gnmg250_prepare1
 
#No.FUN-710085--begin
#    CALL cl_outnam('gnmg250') RETURNING l_name
#    START REPORT gnmg250_rep TO l_name
 
#    LET g_pageno = 0
#No.FUN-710085--end
     FOREACH gnmg250_curs1 INTO sr.*,
                                l_nma02,l_pmc03,t_azi04,t_azi05,t_azi07  #FUN-C50007 ADD 
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#No.FUN-710085--begin
    #   SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file  #NO.CHI-6A0004 #FUN-C50007 MARK
    #         WHERE azi01=sr.npn04  #原幣金額的小數位數依本張單據之幣別                     #FUN-C50007 MARK
       SELECT * INTO g_nmh.* FROM nmh_file WHERE nmh01=sr.npo03 AND nmh38 <> 'X'
     # SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.npn13    #FUN-C50007--MARK
       SELECT nma02 INTO l_nma02_1 FROM nma_file WHERE nma01=g_nmh.nmh21 
     # SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=sr.npn14    #FUN-C50007--MARK
       SELECT occ02 INTO l_occ02 FROM occ_file where occ01=g_nmh.nmh11
      
       CALL s_get_bookno(YEAR(sr.npn02)) RETURNING g_flag,g_bookno1,g_bookno2               #FUN-C50007 add
       SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=sr.npn06 and aag00=g_bookno1       #FUN-C50007 add
       IF STATUS=100 THEN LET l_aag02=' ' END IF                                            #FUN-C50007 add
       SELECT aag02 INTO l_aag02_1 FROM aag_file where aag01=sr.npn07 and aag00=g_bookno1     #FUN-C50007 add
       IF STATUS=100 THEN LET l_aag02_1=' ' END IF                                          #FUN-C50007 add
       LET l_t1 = s_get_doc_no(sr.npn01)                               
       SELECT nmydesc INTO l_nmydesc FROM nmy_file WHERE nmyslip=l_t1  
       EXECUTE insert_prep USING  sr.npn01,sr.npn02,sr.npn03,sr.npn04,sr.npn05,sr.npn06,
                                  sr.npn07,sr.npn08,sr.npn09,sr.npn10,sr.npn11,sr.npn12,
                                  sr.npn13,sr.npn14,sr.npo02,sr.npo03,sr.npo04,sr.npo05,
                                  sr.npo06,sr.npo07,sr.npo08,g_nmh.nmh05,g_nmh.nmh09,
                                  g_nmh.nmh11,g_nmh.nmh21,g_nmh.nmh28,g_nmh.nmh31,l_nma02,  
                                  l_pmc03,l_aag02,l_aag02_1,l_occ02,l_nmydesc,l_nma02_1,t_azi04,t_azi05,t_azi07,g_azi04,g_azi05,"",  l_img_blob,"N",""   # No.FUN-C40020 add #FUN-C50007 ADD aag02
#      OUTPUT TO REPORT gnmg250_rep(sr.*)
#No.FUN-710085--end  
     END FOREACH
 
#No.FUN-710085--begin
#    FINISH REPORT gnmg250_rep
     CALL cl_wcchp(tm.wc,'npn01,npn02,npn03,npn13') 
          RETURNING tm.wc 
   # LET g_sql = "SELECT * FROM ",l_table CLIPPED  #TQC-730088
###GENGRE###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###     LET g_str = tm.wc
   # CALL cl_prt_cs3('gnmg250',g_sql,g_str)        #TQC-730088
###GENGRE###     CALL cl_prt_cs3('gnmg250','gnmg250',g_sql,g_str)
    LET g_cr_table = l_table                    # No.FUN-C40020 add
    LET g_cr_apr_key_f = "npn01"                    # No.FUN-C40020 add
    CALL gnmg250_grdata()    ###GENGRE###
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-710085--end
END FUNCTION
 
 
#No.FUN-710085--begin
#REPORT gnmg250_rep(sr)
#   DEFINE l_last_sw LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#          l_nma02   LIKE nma_file.nma02,
#          l_pmc03   LIKE pmc_file.pmc03,
#          t_azi04   LIKE azi_file.azi04,   #NO.CHI-6A0004
#          t_azi05   LIKE azi_file.azi05,   #NO.CHI-6A0004
#          t_azi07   LIKE azi_file.azi07,   #NO.CHI-6A0004
#          l_occ02   LIKE occ_file.occ02,   #MOD-640031
#          sr        RECORD
#                    npn01     LIKE npn_file.npn01,
#                    npn02     LIKE npn_file.npn02,
#                    npn03     LIKE npn_file.npn03,
#                    npn04     LIKE npn_file.npn04,
#                    npn05     LIKE npn_file.npn05,
#                    npn06     LIKE npn_file.npn06,
#                    npn07     LIKE npn_file.npn07,
#                    npn08     LIKE npn_file.npn08,
#                    npn09     LIKE npn_file.npn09,
#                    npn10     LIKE npn_file.npn10,
#                    npn11     LIKE npn_file.npn11,
#                    npn12     LIKE npn_file.npn12,
#                    npn13     LIKE npn_file.npn13,
#                    npn14     LIKE npn_file.npn14,
#                    npo02     LIKE npo_file.npo02,
#                    npo03     LIKE npo_file.npo03,
#                    npo04     LIKE npo_file.npo04,
#                    npo05     LIKE npo_file.npo05,
#                    npo06     LIKE npo_file.npo06,
#                    npo07     LIKE npo_file.npo07,
#                    npo08     LIKE npo_file.npo08
#                    END RECORD, 
#         l_t1       LIKE nmy_file.nmyslip, #No.FUN-680107 VARCHAR(3)
#         l_nmydesc  LIKE nmy_file.nmydesc,
#         l_flag     LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
#
#  OUTPUT TOP MARGIN 0
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN 5
#         PAGE LENGTH g_page_line
#  ORDER BY sr.npn01,sr.npo02
#  FORMAT
#   PAGE HEADER
##No.FUN-580010  -begin
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<'
#        PRINT g_head CLIPPED,pageno_total
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#        PRINT g_dash
#        LET l_last_sw = 'n'
##No.FUN-580010  -end
#
#   BEFORE GROUP OF sr.npn01
#      SKIP TO TOP OF PAGE
#      LET l_flag = 'N'
##No.FUN-580010  -begin
#      LET g_msg=NULL
#      CASE WHEN sr.npn03='1' LET g_msg=g_x[28]
#           WHEN sr.npn03='2' LET g_msg=g_x[45]
#           WHEN sr.npn03='3' LET g_msg=g_x[46]
#           WHEN sr.npn03='4' LET g_msg=g_x[47]
#           WHEN sr.npn03='5' LET g_msg=g_x[48]
#           WHEN sr.npn03='6' LET g_msg=g_x[29]
#           WHEN sr.npn03='7' LET g_msg=g_x[30]
#           WHEN sr.npn03='8' LET g_msg=g_x[23]
#           WHEN sr.npn03='9' LET g_msg=g_x[24]
#      END CASE
#      SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file  #NO.CHI-6A0004
#            WHERE azi01=sr.npn04  #原幣金額的小數位數依本張單據之幣別
#      LET l_t1 = s_get_doc_no(sr.npn01)       #No.FUN-550057
#      SELECT nmydesc INTO l_nmydesc FROM nmy_file WHERE nmyslip=l_t1
##No.FUN-550057 --start--
#      PRINT g_x[11] CLIPPED,sr.npn01 CLIPPED,
#              COLUMN 27,l_nmydesc CLIPPED,
#              COLUMN 39,g_x[16] CLIPPED,sr.npn09 CLIPPED,
#              COLUMN 64,g_x[19] CLIPPED,cl_numfor(sr.npn10,18,t_azi05) #FUN-590118  #NO.CHI-6A0004
#      PRINT g_x[12] CLIPPED,sr.npn02,COLUMN 39,g_x[17] CLIPPED,sr.npn06[1,10],
#               COLUMN 64,g_x[20] CLIPPED,cl_numfor(sr.npn11,18,g_azi05) #FUN-590118
#      PRINT g_x[13] CLIPPED,sr.npn03,' ',g_msg CLIPPED,
#              COLUMN 16,g_x[15] CLIPPED,sr.npn04 CLIPPED,
#              cl_numfor(sr.npn05,10,t_azi07) ,COLUMN 39,g_x[18] CLIPPED,sr.npn07[1,10],  #NO.CHI-6A0004
#              COLUMN 64,g_x[21] CLIPPED,cl_numfor(sr.npn12,18,g_azi05)#FUN-590118
#      SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.npn13
#      IF STATUS THEN LET l_nma02=NULL END IF
#      SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=sr.npn14
#      IF STATUS THEN LET l_pmc03=NULL END IF
#
#      PRINT g_x[25] CLIPPED,sr.npn13,' ',l_nma02,
#            COLUMN 64,g_x[22] CLIPPED,cl_numfor(sr.npn11-sr.npn12,18,g_azi05)
#      PRINT g_x[26] CLIPPED,sr.npn14,' ',l_pmc03,'   ',
#            g_x[14] CLIPPED,sr.npn08
#      PRINT g_dash
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[49],g_x[34],g_x[35],g_x[36],g_x[37] #MOD-640031
#      PRINTX name=H2 g_x[38],g_x[39],g_x[40],g_x[50],g_x[41],g_x[42],g_x[43],g_x[44] #MOD-640031
#      PRINT g_dash1
##No.FUN-580010  -end
#
#   ON EVERY ROW
#      SELECT * INTO g_nmh.* FROM nmh_file WHERE nmh01=sr.npo03 AND nmh38 <> 'X'
#      SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01=g_nmh.nmh03
#      SELECT occ02 INTO l_occ02 FROM occ_file where occ01=g_nmh.nmh11 #MOD-640031
##No.FUN-580010  -begin
#      PRINTX name=D1
#            COLUMN g_c[31],sr.npo02 USING '###&',  #No.FUN-570177
#            COLUMN g_c[32],sr.npo03,
#            COLUMN g_c[33],g_nmh.nmh11,
#            COLUMN g_c[49],l_occ02 CLIPPED,          #MOD-640031 
#            COLUMN g_c[34],g_nmh.nmh05,
#            COLUMN g_c[35],' ',
#            COLUMN g_c[36],cl_numfor(sr.npo04,36,t_azi04), #NO.CHI-6A0004
#            COLUMN g_c[37],cl_numfor(sr.npo06,37,g_azi04)
#      PRINTX name=D2
#            COLUMN g_c[38],' ',
#            COLUMN g_c[39],g_nmh.nmh31,
#            COLUMN g_c[40],g_nmh.nmh21,
#            COLUMN g_c[50],' ',                      #MOD-640031
#            COLUMN g_c[41],g_nmh.nmh09,
#            COLUMN g_c[42],cl_numfor(g_nmh.nmh28,42,t_azi07),
#            COLUMN g_c[43],cl_numfor(sr.npo05,43,g_azi04),
#            COLUMN g_c[44],cl_numfor(sr.npo05-sr.npo06,44,g_azi04)
##No.FUN-580010  -end
# 
#   AFTER GROUP OF sr.npn01
#      PRINT g_dash
#      LET g_pageno=0
#      LET l_flag='Y'
# 
### FUN-550114
#   ON LAST ROW
#     LET l_last_sw = 'y'
#
#   PAGE TRAILER
##    IF l_flag ='Y' THEN
##       PRINT COLUMN 01,g_x[04] CLIPPED,COLUMN 41,g_x[05] CLIPPED
##    ELSE
##       PRINT g_dash
##    END IF
#     IF l_last_sw = 'n' THEN
#        PRINT g_dash                                            #No.TQC-6B0155                                                      
#        PRINT g_x[09] CLIPPED,COLUMN(g_len-9),g_x[06] CLIPPED   #No.TQC-6B0155
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[4]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#        PRINT g_dash                                            #No.TQC-6B0155                                                      
#        PRINT g_x[09] CLIPPED,COLUMN(g_len-9),g_x[07] CLIPPED   #No.TQC-6B0155
#            PRINT g_x[4]
#            PRINT g_memo
#     END IF
### END FUN-550114
#
#END REPORT
#No.FUN-710085--end
 
#Patch....NO.TQC-610036 <> #

###GENGRE###START
FUNCTION gnmg250_grdata()
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
        LET handler = cl_gre_outnam("gnmg250")
        IF handler IS NOT NULL THEN
            START REPORT gnmg250_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY npn01,npo02"
          
            DECLARE gnmg250_datacur1 CURSOR FROM l_sql
            FOREACH gnmg250_datacur1 INTO sr1.*
                OUTPUT TO REPORT gnmg250_rep(sr1.*)
            END FOREACH
            FINISH REPORT gnmg250_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT gnmg250_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B40087----------add------str-------
    DEFINE l_npn01_nmydesc          STRING
    DEFINE l_npn03                  STRING
    DEFINE l_npn04_npn05            STRING
    DEFINE l_npn05                  STRING 
    DEFINE l_npn11_npn12            LIKE npn_file.npn11
    DEFINE l_npn13_nma02            STRING
    DEFINE l_npn14_pmc03            STRING
    DEFINE l_npo05_npo06            LIKE npo_file.npo05
    DEFINE l_npn10_fmt              STRING
    DEFINE l_npn11_fmt              STRING
    DEFINE l_npn05_fmt              STRING
    DEFINE l_npn12_fmt              STRING
    DEFINE l_npn11_npn12_fmt        STRING
    DEFINE l_npo04_fmt              STRING
    DEFINE l_npo06_fmt              STRING
    DEFINE l_nmh28_fmt              STRING
    DEFINE l_npo05_fmt              STRING
    DEFINE l_npo05_npo06_fmt        STRING
    #FUN-B40087----------add------end-------
    DEFINE l_npn06_aag02            STRING   #FUN-C50007
    DEFINE l_npn07_aag02            STRING    #FUN-C50007
    ORDER EXTERNAL BY sr1.npn01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.npn01
            LET l_lineno = 0
            #FUN-B40087----------add------str-------
            LET l_npn10_fmt = cl_gr_numfmt('npn_file','npn10',sr1.azi05_t)
            PRINTX l_npn10_fmt
            LET l_npn11_fmt = cl_gr_numfmt('npn_file','npn11',g_azi05)
            PRINTX l_npn11_fmt 
            LET l_npn05_fmt = cl_gr_numfmt('npn_file','npn05',sr1.azi07_t)
            PRINTX l_npn05_fmt
            LET l_npn12_fmt = cl_gr_numfmt('npn_file','npn12',g_azi05)
            PRINTX l_npn12_fmt
            LET l_npn11_npn12_fmt = cl_gr_numfmt('npn_file','npn11',g_azi05)
            PRINTX l_npn11_npn12_fmt
            LET l_npo04_fmt = cl_gr_numfmt('npo_file','npo04',sr1.azi04_t)
            PRINTX l_npo04_fmt
            LET l_npo06_fmt = cl_gr_numfmt('npo_file','npo06',g_azi04)
            PRINTX l_npo06_fmt
            LET l_nmh28_fmt = cl_gr_numfmt('nmh_file','nmh28',sr1.azi07_t)
            PRINTX l_nmh28_fmt
            LET l_npo05_fmt = cl_gr_numfmt('npo_file','npo05',g_azi04)
            PRINTX l_npo05_fmt
            LET l_npo05_npo06_fmt = cl_gr_numfmt('npo_file','npo05',g_azi04)
            PRINTX l_npo05_npo06_fmt
            LET l_npn01_nmydesc = sr1.npn01,' ',sr1.nmydesc
            PRINTX l_npn01_nmydesc
            LET l_npn05 = sr1.npn05 
            LET l_npn04_npn05 = sr1.npn04,' ',l_npn05
            PRINTX l_npn04_npn05
            LET l_npn11_npn12 = sr1.npn11 - sr1.npn12
            PRINTX l_npn11_npn12
            LET l_npn13_nma02 = sr1.npn13,' ',sr1.nma02
            PRINTX l_npn13_nma02
            LET l_npn14_pmc03 = sr1.npn14,' ',sr1.pmc03
            PRINTX l_npn14_pmc03
            LET l_npn03 = sr1.npn03,' ', cl_gr_getmsg("gre-085",g_lang,sr1.npn03)
            PRINTX l_npn03
            #FUN-B40087----------add------end-------

            #FUN-C50007----------add------str-------
            LET l_npn06_aag02 = sr1.npn06,' ',sr1.aag02
            PRINTX l_npn06_aag02
            LET l_npn07_aag02 = sr1.npn07,' ',sr1.aag02_1
            PRINTX l_npn07_aag02
            #FUN-C50007----------add------end-------
 
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
           
            #FUN-B40087----------add------str-------
            LET l_npo05_npo06 = sr1.npo05 - sr1.npo06
            PRINTX l_npo05_npo06
            #FUN-B40087----------add------end-------
           
            PRINTX sr1.*

        AFTER GROUP OF sr1.npn01

        
        ON LAST ROW

END REPORT
###GENGRE###END
#FUN-D10098
