# Prog. Version..: '5.30.06-13.03.18(00001)'     #
#
# Pattern name...: gnmg150.4gl
# Descriptions...: 應付票據異動憑証列印
# Date & Author..: 97/04/24 By Charis
# Modify.........: No.FUN-4C0098 05/03/02 By pengu 修改單價、金額欄位寬度
# Modify.........: NO.FUN-550057 05/05/23 By jackie 單據編號加大
# Modify.........: No.FUN-550114 05/05/26 By echo 新增報表備註
# Modify.........: No.FUN-570177 05/07/19 By Trisy 項次位數加大
# Modify.........: No.FUN-580010 05/08/02 By will 報表轉XML格式
# Modify.........: No.MOD-590486 05/10/03 By Dido 報表調整
# Modify.........: No.FUN-5B0109 05/11/23 By kim 報表加列印簡稱和合計
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改	
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-710085 07/01/31 By Rayven 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加 CR 參數
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
# Modify.........: No.MOD-860313 08/07/08 By Sarah 廠商簡稱由pmc03改抓nmd24
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B40097 11/05/18 By chenying 憑證類CR報表轉成GR
# Modify.........: No.FUN-C40019 12/04/09 By yangtt GR報表列印TIPTOP與EasyFlow簽核圖片 
# Modify.........: No.FUN-C50007 12/05/02 By minpp GR程序優化 
# Modify.........: No.FUN-CC0093 12/12/20 By wangrr GR程式修改
# Modify.........: No.FUN-D10098 13/02/01 By lujh 新增gnmg150

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              #wc     LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(600) # Where condition   #FUN-CC0093 mark
              wc      STRING,                #FUN-CC0093 add
              n       LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1) # 列印單價
              more    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1) # Input more condition(Y/N)
              END RECORD,
          g_nmd    RECORD LIKE nmd_file.*
#No.FUN-580010  --begin
#DEFINE   g_dash         LIKE type_file.chr1000#No.FUN-680107 VARCHAR(400)  #Dash line
#DEFINE   g_len          SMALLINT              #Report width(79/132/136)
#DEFINE   g_pageno       SMALLINT              #Report page no
#DEFINE   g_zz05         VARCHAR(1)               #Print tm.wc ?(Y/N)
#No.FUN-580010  --end
DEFINE   g_i             LIKE type_file.num5   #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000#No.FUN-680107 VARCHAR(72)
DEFINE   l_table         STRING                #No.FUN-710085 
DEFINE   g_sql           STRING                #No.FUN-710085 
DEFINE   g_str           STRING                #No.FUN-710085 
DEFINE g_bookno1     LIKE aza_file.aza81      #FUN-C50007
DEFINE g_bookno2     LIKE aza_file.aza82      #FUN-C50007
DEFINE g_flag        LIKE type_file.chr1      #FUN-C50007
 
###GENGRE###START
TYPE sr1_t RECORD
    npl01 LIKE npl_file.npl01,
    npl02 LIKE npl_file.npl02,
    npl03 LIKE npl_file.npl03,
    npl08 LIKE npl_file.npl08,
    nmydesc LIKE nmy_file.nmydesc,
    npl06 LIKE npl_file.npl06,
    npl04 LIKE npl_file.npl04,
    npl09 LIKE npl_file.npl09,
    npl11 LIKE npl_file.npl11,
    npl05 LIKE npl_file.npl05,
    npl10 LIKE npl_file.npl10,
    npl07 LIKE npl_file.npl07,
    npl12 LIKE npl_file.npl12,
    npm02 LIKE npm_file.npm02,
    npm03 LIKE npm_file.npm03,
    nmd02 LIKE nmd_file.nmd02,
    nmd05 LIKE nmd_file.nmd05,
    npm04 LIKE npm_file.npm04,
    npm06 LIKE npm_file.npm06,
    nmd08 LIKE nmd_file.nmd08,
    pmc03 LIKE pmc_file.pmc03,
    nmd03 LIKE nmd_file.nmd03,
    nma02 LIKE nma_file.nma02,
    nmd19 LIKE nmd_file.nmd19,
    npm05 LIKE npm_file.npm05,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    azi07 LIKE azi_file.azi07,
    azi04_1 LIKE azi_file.azi04,
    azi05_1 LIKE azi_file.azi05,
    aag02   LIKE aag_file.aag02,#FUN-C50007
    aag02_1 LIKE aag_file.aag02,#FUN-C50007
    #FUN-C40019------add------str----
    sign_type LIKE type_file.chr1,
    sign_img LIKE type_file.blob,
    sign_show LIKE type_file.chr1,
    sign_str LIKE type_file.chr1000
    #FUN-C40019------add------end----
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
 
   #No.FUN-710085 --start--
   LET g_sql = "npl01.npl_file.npl01,npl02.npl_file.npl02,npl03.npl_file.npl03,",
               "npl08.npl_file.npl08,nmydesc.nmy_file.nmydesc,npl06.npl_file.npl06,",
               "npl04.npl_file.npl04,npl09.npl_file.npl09,npl11.npl_file.npl11,",
               "npl05.npl_file.npl05,npl10.npl_file.npl10,npl07.npl_file.npl07,",
               "npl12.npl_file.npl12,npm02.npm_file.npm02,npm03.npm_file.npm03,",
               "nmd02.nmd_file.nmd02,nmd05.nmd_file.nmd05,npm04.npm_file.npm04,",
               "npm06.npm_file.npm06,nmd08.nmd_file.nmd08,pmc03.pmc_file.pmc03,",
               "nmd03.nmd_file.nmd03,nma02.nma_file.nma02,nmd19.nmd_file.nmd19,",
               "npm05.npm_file.npm05,azi04.azi_file.azi04,azi05.azi_file.azi05,",
               "azi07.azi_file.azi07,azi04_1.azi_file.azi04,azi05_1.azi_file.azi05,",
               "aag02.aag_file.aag02,aag02_1.aag_file.aag02,", #FUN-C50007
               #FUN-C40019------add------str----
               "sign_type.type_file.chr1,   sign_img.type_file.blob,",   #簽核方式, 簽核圖檔
               "sign_show.type_file.chr1,  sign_str.type_file.chr1000" 
               #FUN-C40019------add------end----
 
   LET l_table = cl_prt_temptable('gnmg150',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40097
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40097
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"    #FUN-C40019 add 4?#FUN-C50007 add 2?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40097
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40097
      EXIT PROGRAM
   END IF
   #No.FUN-710085 --end--
 
   #-----TQC-610058---------
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.n = ARG_VAL(8)
   #-----END TQC-610058-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(tm.wc) THEN
      CALL gnmg150_tm(0,0)             # Input print condition
   ELSE 
      CALL gnmg150()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION gnmg150_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01           #No.FUN-580031
   DEFINE p_row,p_col LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_cmd       LIKE type_file.chr1000        #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
 
   LET p_row = 5 LET p_col = 15
   OPEN WINDOW gnmg150_w AT p_row,p_col
        WITH FORM "gnm/42f/gnmg150"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.n ='3'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON npl01,npl02,npl03,npl04
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
          WHEN INFIELD(npl01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_npl"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO npl01
             NEXT FIELD npl01
          WHEN INFIELD(npl04)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_azi"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO npl04
             NEXT FIELD npl04
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
      LET INT_FLAG = 0 CLOSE WINDOW gnmg150_w 
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
      LET INT_FLAG = 0 CLOSE WINDOW gnmg150_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='gnmg150'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gnmg150','9031',1)
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
         CALL cl_cmdat('gnmg150',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW gnmg150_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gnmg150()
   ERROR ""
END WHILE
   CLOSE WINDOW gnmg150_w
END FUNCTION
 
FUNCTION gnmg150()
   #No.FUN-710085 --start--
   DEFINE l_t1      LIKE nmy_file.nmyslip
   DEFINE l_nmydesc LIKE nmy_file.nmydesc
   DEFINE l_pmc03   LIKE pmc_file.pmc03
   DEFINE l_nma02   LIKE nma_file.nma02
   #No.FUN-710085 --end--
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0082
          #l_sql    LIKE type_file.chr1000,		    # RDSQL STATEMENT #No.FUN-680107 VARCHAR(3000)   #FUN-CC0093 mark
          l_sql     STRING,                       #FUN-CC0093 add
          l_za05    LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(40)
          sr        RECORD
                    npl01     LIKE npl_file.npl01,
                    npl02     LIKE npl_file.npl02,
                    npl03     LIKE npl_file.npl03,
                    npl04     LIKE npl_file.npl04,
                    npl05     LIKE npl_file.npl05,
                    npl06     LIKE npl_file.npl06,
                    npl07     LIKE npl_file.npl07,
                    npl08     LIKE npl_file.npl08,
                    npl09     LIKE npl_file.npl09,
                    npl10     LIKE npl_file.npl10,
                    npl11     LIKE npl_file.npl11,
                    npl12     LIKE npl_file.npl12,
                    npm02     LIKE npm_file.npm02,
                    npm03     LIKE npm_file.npm03,
                    npm04     LIKE npm_file.npm04,
                    npm05     LIKE npm_file.npm05,
                    npm06     LIKE npm_file.npm06,
                    npm07     LIKE npm_file.npm07,
                    npm08     LIKE npm_file.npm08
                    END RECORD
     DEFINE l_aag02        LIKE aag_file.aag02    #FUN-C50007
     DEFINE l_aag02_1      LIKE aag_file.aag02    #FUN-C50007  
     DEFINE l_img_blob     LIKE type_file.blob    #FUN-C40019 add		

     LOCATE l_img_blob    IN MEMORY               #FUN-C40019 add
 
     CALL cl_del_data(l_table)  #No.FUN-710085
    
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-580010  --begin
##    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gnmg150'
##    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 95 END IF   #No.FUN-550057
#     LET g_len = 95   #No.FUN-550057
#     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-580010  --end
#NO.CHI-6A0004--BEGIN
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#NO.CHI-6A0004--END
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND npluser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nplgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nplgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('npluser', 'nplgrup')
     #End:FUN-980030
     
     
     LET l_sql="SELECT npl01,npl02,npl03,npl04,npl05,",  
               "       npl06,npl07,npl08,npl09,npl10,npl11,", 
               "       npl12,npm02,npm03,npm04,npm05,npm06,npm07,npm08,azi04,azi05,azi07",   #FUN-C50007 add aag02,azi04,azi05,azi07
              #"  FROM npl_file,npm_file ", #FUN-C50007--mark
               "  FROM npl_file LEFT OUTER JOIN azi_file  ON azi01=npl04 ,npm_file ",      #FUN-C50007
               " WHERE npl01=npm01 ",
               "   AND nplconf <> 'X' ",
               "   AND ",tm.wc CLIPPED
     IF tm.n='1' THEN
        LET l_sql=l_sql CLIPPED," AND nplconf='Y' "
     END IF
     IF tm.n='2' THEN
        LET l_sql=l_sql CLIPPED," AND nplconf='N' "
     END IF
     LET l_sql=l_sql CLIPPED," ORDER BY npl01,npm02 "
     PREPARE gnmg150_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        CALL cl_gre_drop_temptable(l_table)
        EXIT PROGRAM 
     END IF
     DECLARE gnmg150_curs1 CURSOR FOR gnmg150_prepare1
 
#    CALL cl_outnam('gnmg150') RETURNING l_name  #No.FUN-710085 mark
#    START REPORT gnmg150_rep TO l_name          #No.FUN-710085 mark

     LET g_pageno = 0
#    FOREACH gnmg150_curs1 INTO sr.*     #FUN-C50007  mark
     FOREACH gnmg150_curs1 INTO sr.* ,t_azi04,t_azi05,t_azi07  #FUN-C50007
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
       #No.FUN-710085 --start--
       LET l_t1=sr.npl01[1,g_doc_len]  
       SELECT nmydesc INTO l_nmydesc FROM nmy_file WHERE nmyslip=l_t1     
       SELECT * INTO g_nmd.* FROM nmd_file WHERE nmd01=sr.npm03 AND nmd30 <> 'X'
       SELECT pmc03 INTO l_pmc03 from pmc_file where pmc01=g_nmd.nmd08
       SELECT nma02 INTO l_nma02 from nma_file where nma01=g_nmd.nmd03
       LET sr.npl06 = sr.npl06[1,10]
       LET sr.npl07 = sr.npl07[1,10]
      
       CALL s_get_bookno(YEAR(sr.npl02))   RETURNING g_flag,g_bookno1,g_bookno2               #FUN-C50007 add
       SELECT aag02 INTO l_aag02 FROM aag_file where aag01=sr.npl06 and aag00=g_bookno1       #FUN-C50007 add
       IF STATUS=100 THEN LET l_aag02=' '  END IF                                             #FUN-C50007 add
       SELECT aag02 INTO l_aag02_1 FROM aag_file where aag01=sr.npl07 and aag00=g_bookno1     #FUN-C50007 add
       IF STATUS=100 THEN LET l_aag02_1=' ' END IF                                            #FUN-C50007 add
       #SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file                   #FUN-C50007  mark
       # WHERE azi01=sr.npl04                                                                 #FUN-C50007  mark
 
       EXECUTE insert_prep USING sr.npl01,sr.npl02,sr.npl03,sr.npl08,
                                 l_nmydesc,sr.npl06,sr.npl04,sr.npl09,  
                                 sr.npl11,sr.npl05,sr.npl10,sr.npl07,
                                 sr.npl12,sr.npm02,sr.npm03,g_nmd.nmd02,
                                 g_nmd.nmd05,sr.npm04,sr.npm06,g_nmd.nmd08,
                                #l_pmc03,g_nmd.nmd03,l_nma02,g_nmd.nmd19,      #MOD-860313 mark
                                 g_nmd.nmd24,g_nmd.nmd03,l_nma02,g_nmd.nmd19,  #MOD-860313
                                 sr.npm05,t_azi04,t_azi05,t_azi07,g_azi04,
                                 g_azi05,l_aag02,l_aag02_1,                    #FUN-C50007 add aag02,aag02_1
                                 "",        l_img_blob,    "N",           ""   #FUN-C40019 add
       #No.FUN-710085 --end--
 
#      OUTPUT TO REPORT gnmg150_rep(sr.*)  #No.FUN-710085 mark
     END FOREACH
 
#    FINISH REPORT gnmg150_rep                    #No.FUN-710085 mark
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #No.FUN-710085 mark
 
     #No.FUN-710085 --start--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'npl01,npl02,npl03,npl04')
          RETURNING tm.wc
###GENGRE###     LET g_str = tm.wc,";",g_zz05
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED  #TQC-730088
   # CALL cl_prt_cs3('gnmg150',l_sql,g_str)
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###     CALL cl_prt_cs3('gnmg150','gnmg150',l_sql,g_str)
    LET g_cr_table = l_table                   #主報表的temp table名稱        #FUN-C40019 add
    LET g_cr_apr_key_f = "npl01"         #報表主鍵欄位名稱，用"|"隔開   #FUN-C40019 add

    CALL gnmg150_grdata()    ###GENGRE###
     #No.FUN-710085 --end--
 
END FUNCTION
 
#No.FUN-710085 --start-- mark
{REPORT gnmg150_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
          sr        RECORD
                    npl01     LIKE npl_file.npl01,
                    npl02     LIKE npl_file.npl02,
                    npl03     LIKE npl_file.npl03,
                    npl04     LIKE npl_file.npl04,
                    npl05     LIKE npl_file.npl05,
                    npl06     LIKE npl_file.npl06,
                    npl07     LIKE npl_file.npl07,
                    npl08     LIKE npl_file.npl08,
                    npl09     LIKE npl_file.npl09,
                    npl10     LIKE npl_file.npl10,
                    npl11     LIKE npl_file.npl11,
                    npl12     LIKE npl_file.npl12,
                    npm02     LIKE npm_file.npm02,
                    npm03     LIKE npm_file.npm03,
                    npm04     LIKE npm_file.npm04,
                    npm05     LIKE npm_file.npm05,
                    npm06     LIKE npm_file.npm06,
                    npm07     LIKE npm_file.npm07,
                    npm08     LIKE npm_file.npm08
                    END RECORD,
 #       l_azi04   LIKE azi_file.azi04,   #NO.CHI-6A0004 
 #       l_azi05   LIKE azi_file.azi05,   #NO.CHI-6A0004 
         l_t1      LIKE nmy_file.nmyslip, #No.FUN-680107 VARCHAR(5) #FUN-5B0109 3->5
         l_nmydesc LIKE nmy_file.nmydesc,
         l_pmc03   LIKE pmc_file.pmc03,   #FUN-5B0109
         l_nma02   LIKE nma_file.nma02,   #FUN-5B0109
         l_flag    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
  OUTPUT TOP MARGIN 0
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN 5
         PAGE LENGTH g_page_line
  ORDER BY sr.npl01,sr.npm02
  FORMAT
   PAGE HEADER
#No.FUN-580010  --begin
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<'
#MOD-590486
#     PRINT ' '
      PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT g_head CLIPPED,pageno_total
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#MOD-590486 End
      PRINT g_dash
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT ' '
#     PRINT (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2 SPACES,g_x[1];
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT ' '
#     LET g_pageno= g_pageno+1
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,' ',g_msg CLIPPED,
#           COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#     PRINT g_dash[1,g_len]
#        SKIP 1 LINE
#        PRINT COLUMN 01,g_x[23] CLIPPED,COLUMN 55,g_x[24] CLIPPED
#        PRINT COLUMN 01,g_x[25] CLIPPED,COLUMN 55,g_x[26] CLIPPED
#        PRINT '-------------------------------------------------',
#                        '-----------------------------------------'
#No.FUN-580010  -end
      LET l_last_sw = 'n'
 
 
   BEFORE GROUP OF sr.npl01
      SKIP TO TOP OF PAGE
      LET g_msg=NULL
      CASE WHEN sr.npl03='1' LET g_msg=g_x[28]
           WHEN sr.npl03='6' LET g_msg=g_x[29]
           WHEN sr.npl03='7' LET g_msg=g_x[30]
           WHEN sr.npl03='8' LET g_msg=g_x[23]
           WHEN sr.npl03='9' LET g_msg=g_x[24]
      END CASE
      SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file #NO.CHI-6A0004
            WHERE azi01=sr.npl04  #原幣金額的小數位數依本張單據之幣別
#       LET l_t1=sr.npl01[1,3]
        LET l_t1=sr.npl01[1,g_doc_len]                    #No.FUN-550057
        SELECT nmydesc INTO l_nmydesc FROM nmy_file WHERE nmyslip=l_t1
#No.FUN-550057 --start--
        PRINT g_x[11] CLIPPED,sr.npl01 CLIPPED,
              COLUMN 27,l_nmydesc CLIPPED,
              COLUMN 63,g_x[16] CLIPPED,sr.npl09 CLIPPED,  #No.FUN-550057
              COLUMN 115,g_x[19] CLIPPED,cl_numfor(sr.npl10,18,t_azi05)   #NO.CHI-6A0004 
        PRINT g_x[12] CLIPPED,sr.npl02 CLIPPED,
              COLUMN 63,g_x[17] CLIPPED,sr.npl06[1,10] CLIPPED,
              COLUMN 115,g_x[20] CLIPPED,cl_numfor(sr.npl11,18,g_azi05)
        PRINT g_x[13] CLIPPED,sr.npl03,' ',g_msg CLIPPED,
              COLUMN 16,g_x[15] CLIPPED,sr.npl04 CLIPPED,
              cl_numfor(sr.npl05,10,t_azi07),COLUMN 63,g_x[18] CLIPPED,sr.npl07[1,10],
              COLUMN 115,g_x[21] CLIPPED,cl_numfor(sr.npl12,18,g_azi05)
        PRINT g_x[14] CLIPPED,sr.npl08,
              COLUMN 115,g_x[22] CLIPPED,cl_numfor(sr.npl11-sr.npl12,18,g_azi05)
        PRINT g_dash
#No.FUN-580010  -begin
        PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
              g_x[36],g_x[37],g_x[42],g_x[38],g_x[43],g_x[39],g_x[40],g_x[41] #FUN-5B0109
        PRINT g_dash1
        LET l_flag = 'N'
#       PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#             g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]
#       PRINT g_dash1
#       PRINT COLUMN 01,g_x[23] CLIPPED,COLUMN 55,g_x[24] CLIPPED
#       PRINT COLUMN 01,g_x[25] CLIPPED,COLUMN 55,g_x[26] CLIPPED
#       PRINT '-------------------------------------------------',
#                        '-----------------------------------------'
#No.FUN-580010  -end
 
   ON EVERY ROW
      SELECT * INTO g_nmd.* FROM nmd_file WHERE nmd01=sr.npm03 AND nmd30 <> 'X'
      SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01=g_nmd.nmd21 
#No.FUN-580010  -begin
      #FUN-5B0109...............begin
      LET l_pmc03=''
      SELECT pmc03 INTO l_pmc03 from pmc_file where pmc01=g_nmd.nmd08
      LET l_nma02=''
      SELECT nma02 INTO l_nma02 from nma_file where nma01=g_nmd.nmd03
      #FUN-5B0109...............end
      PRINT COLUMN g_c[31],sr.npm02 USING '###&',
      COLUMN g_c[32],sr.npm03 CLIPPED,
      COLUMN g_c[33],g_nmd.nmd02 CLIPPED,
      COLUMN g_c[34],g_nmd.nmd05 CLIPPED,
      COLUMN g_c[35],cl_numfor(sr.npm04,35,t_azi04),   #NO.CHI-6A0004 
      COLUMN g_c[36],cl_numfor(sr.npm06,36,g_azi04),
      COLUMN g_c[37],g_nmd.nmd08 CLIPPED,
      COLUMN g_c[42],l_pmc03 CLIPPED, #FUN-5B0109
      COLUMN g_c[38],g_nmd.nmd03 CLIPPED,
      COLUMN g_c[43],l_nma02 CLIPPED, #FUN-5B0109
      COLUMN g_c[39],cl_numfor(g_nmd.nmd19,39,t_azi07),
      COLUMN g_c[40],cl_numfor(sr.npm05,40,g_azi04),
      COLUMN g_c[41],cl_numfor(sr.npm05-sr.npm06,41,g_azi04)
#     PRINT COLUMN 01,sr.npm02 USING '###&',          #No.FUN-570177
#           COLUMN 07,sr.npm03 CLIPPED,
#           COLUMN 24,g_nmd.nmd02 CLIPPED,
#           COLUMN 37,g_nmd.nmd05 CLIPPED,
#           COLUMN 50,cl_numfor(sr.npm04,18,t_azi04),   #NO.CHI-6A0004 
#           COLUMN 72,cl_numfor(sr.npm06,18,g_azi04)
#     PRINT COLUMN 07,g_nmd.nmd08 CLIPPED,
#           COLUMN 24,g_nmd.nmd03 CLIPPED,
#           COLUMN 37,cl_numfor(g_nmd.nmd19,10,t_azi07),
#           COLUMN 50,cl_numfor(sr.npm05,18,g_azi04),'  ',
#           COLUMN 72,cl_numfor(sr.npm05-sr.npm06,18,g_azi04)
#No.FUN-580010  -end
 
   AFTER GROUP OF sr.npl01
#     PRINT g_dash[1,g_len]
      #FUN-5B0109...............begin
      PRINT COLUMN g_c[34],g_x[44] CLIPPED,
            COLUMN g_c[35],cl_numfor(GROUP SUM(sr.npm04),35,t_azi05),   #NO.CHI-6A0004 
            COLUMN g_c[40],cl_numfor(GROUP SUM(sr.npm05),40,t_azi05)   #NO.CHI-6A0004 
      #FUN-5B0109...............end
      PRINT g_dash               #No.FUN-580010
      LET g_pageno=0
      LET l_flag='Y'
 
## FUN-550114
   ON LAST ROW
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      #IF l_flag ='Y' THEN
      #   PRINT COLUMN 01,g_x[04] CLIPPED,COLUMN 41,g_x[05] CLIPPED
      #ELSE
      #   PRINT g_dash[1,g_len]
      #END IF
#No.TQC-6A0110 -- begin --
        PRINT g_dash[1,g_len]
      IF l_last_sw = 'n' THEN
#        PRINT g_dash[1,g_len]                                           
         PRINT g_x[4] CLIPPED,COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
         PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      END IF
      PRINT
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
            PRINT g_x[5]
            PRINT g_memo
         ELSE
            PRINT
            PRINT
         END IF
      ELSE
         PRINT g_x[5]
         PRINT g_memo
      END IF
 
## END FUN-550114
 
END REPORT}
#No.FUN-710085 --end--
#Patch....NO.TQC-610036 <> #

###GENGRE###START
FUNCTION gnmg150_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
   
    LOCATE sr1.sign_img IN MEMORY   #FUN-C40019
    CALL cl_gre_init_apr()          #FUN-C40019  
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("gnmg150")
        IF handler IS NOT NULL THEN
            START REPORT gnmg150_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY npl01,npm02"
            DECLARE gnmg150_datacur1 CURSOR FROM l_sql
            FOREACH gnmg150_datacur1 INTO sr1.*
                OUTPUT TO REPORT gnmg150_rep(sr1.*)
            END FOREACH
            FINISH REPORT gnmg150_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT gnmg150_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B40097------add-----str--------------------
    DEFINE l_npl03        STRING 
    DEFINE l_npl11_npl12  LIKE npl_file.npl11   
    DEFINE l_npm05_npm06  LIKE npm_file.npm05   
    DEFINE l_sum_npm04    LIKE npm_file.npm04    
    DEFINE l_sum_npm05    LIKE npm_file.npm05       
    DEFINE l_sum_npm04_fmt   STRING   
    DEFINE l_sum_npm05_fmt   STRING   
    DEFINE l_npm05_fmt   STRING   
    DEFINE l_npm04_fmt   STRING   
    DEFINE l_npm06_fmt   STRING   
    DEFINE l_npl12_fmt   STRING   
    DEFINE l_npl11_fmt   STRING   
    DEFINE l_npl10_fmt   STRING   
    DEFINE l_nmd19_fmt   STRING   
    DEFINE l_npl11_npl12_fmt  STRING 
    DEFINE l_npm05_npm06_fmt  STRING
    DEFINE l_npl05_fmt        STRING
    #FUN-B40097------add-----end--------------------
    DEFINE l_npl06_aag02   STRING   #FUN-C50007
    DEFINE l_npl07_aag02   STRING   #FUN-C50007
    ORDER EXTERNAL BY sr1.npl01,sr1.npm02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.npl01
            LET l_lineno = 0

            #FUN-B40097------add-----str--------------------
            LET l_npl03 = cl_gr_getmsg("gre-031",g_lang,sr1.npl03)
            LET l_npl03 = sr1.npl03,' ',l_npl03   
            PRINTX l_npl03

            LET l_npl05_fmt = cl_gr_numfmt('npl_file','npl05',sr1.azi07)
            PRINTX  l_npl05_fmt
            #FUN-B40097------add-----end--------------------


        BEFORE GROUP OF sr1.npm02

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-B40097------add-----str--------------------
            LET l_npl11_npl12 = sr1.npl11 - sr1.npl12
            PRINTX l_npl11_npl12

            LET l_npm05_npm06 = sr1.npm05 - sr1.npm06
            PRINTX l_npm05_npm06

            LET l_npm04_fmt = cl_gr_numfmt('npm_file','npm04',sr1.azi04)
            LET l_npm05_fmt = cl_gr_numfmt('npm_file','npm05',g_azi04)
            PRINTX l_npm04_fmt
            PRINTX l_npm05_fmt

            LET l_npm06_fmt = cl_gr_numfmt('npm_file','npm06',g_azi04)
            PRINTX l_npm06_fmt
            LET l_npm05_npm06_fmt = cl_gr_numfmt('npm_file','npm05',g_azi04)
            PRINTX l_npm05_npm06_fmt
            LET l_nmd19_fmt = cl_gr_numfmt('nmd_file','nmd19',sr1.azi07)
            PRINTX l_nmd19_fmt
            LET l_npl11_npl12_fmt = cl_gr_numfmt('npl_file','npl11',g_azi05) 
            PRINTX l_npl11_npl12_fmt
            LET l_npl12_fmt = cl_gr_numfmt('npl_file','npl12',g_azi05) 
            PRINTX l_npl12_fmt
            LET l_npl11_fmt = cl_gr_numfmt('npl_file','npl11',g_azi05) 
            PRINTX l_npl11_fmt
            LET l_npl10_fmt = cl_gr_numfmt('npl_file','npl10',sr1.azi05) 
            PRINTX l_npl10_fmt
            #FUN-B40097------add-----end--------------------
            
            #FUN-C50007--ADD---STR
            LET l_npl06_aag02=sr1.npl06,' ',sr1.aag02
            PRINTX l_npl06_aag02
            LET l_npl07_aag02=sr1.npl07,' ',sr1.aag02_1
            PRINTX l_npl07_aag02
            #FUN-C50007--ADD---END
            PRINTX sr1.*

        AFTER GROUP OF sr1.npl01
            #FUN-B40097------add-----str--------------------
            LET l_sum_npm04 = GROUP SUM( sr1.npm04 )
            PRINTX l_sum_npm04
            LET l_sum_npm05 = GROUP SUM( sr1.npm05 )
            PRINTX l_sum_npm05
            LET l_sum_npm04_fmt = cl_gr_numfmt('npm_file','npm04',sr1.azi05)
            LET l_sum_npm05_fmt = cl_gr_numfmt('npm_file','npm05',sr1.azi05)
            PRINTX l_sum_npm04_fmt
            PRINTX l_sum_npm05_fmt
            #FUN-B40097------add-----end--------------------

        AFTER GROUP OF sr1.npm02

        
        ON LAST ROW

END REPORT
###GENGRE###END
#FUN-D10098
