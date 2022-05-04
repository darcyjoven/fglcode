# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: anmg920.4gl
# Descriptions...: 集團資金調撥單列表
# Date & Author..: No.FUN-640144 06/04/19 By Nicola
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
#
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-690090 06/11/16 By Rayven 增加內部帳戶部分,選資料應該跨庫去選
# Modify.........: No.TQC-6B0114 06/11/27 By Rayven 打印內容編號和后面帶出的欄位沒有用空格隔開
# Modify.........: No.FUN-710085 07/02/02 By wujie 使用水晶報表打印
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.FUN-740049 07/04/12 By arman  會計科目加帳套
# Modify.........: No.FUN-850062 08/05/13 By baofei EXECUTE 時和臨時表字段不對應
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/02 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.TQC-9C0099 09/12/15 By jan mark處'#'號漏寫
# Modify.........: No.FUN-A50102 10/07/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-B50018 11/05/19 By xumm CR轉GRW
# Modify.........: No.FUN-B50018 11/08/11 By xumm 程式規範修改
# Modify.........: No.FUN-C40020 12/04/10 By qirl  GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50007 12/05/07 By minpp GR程序优化 
# Modify.........: No.FUN-C10024  12/05/15 By jinjj 帳套取歷年主會計帳別檔tna_file

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm      RECORD
                  wc      STRING,
                  more    LIKE type_file.chr1     #FUN-680107 VARCHAR(1)
               END RECORD
DEFINE g_cnt   LIKE type_file.num5     #FUN-680107 SMALLINT
DEFINE g_i     LIKE type_file.num5     #No.FUN-680107 SMALLINT
DEFINE l_table       STRING                   #FUN-710085 add 
DEFINE g_sql         STRING                   #FUN-710085 add
DEFINE g_str         STRING                   #FUN-710085 add
DEFINE g_bookno1     LIKE  aza_file.aza81   #NO.FUN-740049
DEFINE g_bookno2     LIKE  aza_file.aza82   #NO.FUN-740049
DEFINE g_flag        LIKE  type_file.chr1   #NO.FUN-740049
###GENGRE###START
TYPE sr1_t RECORD
    nnv01 LIKE nnv_file.nnv01,
    nnv02 LIKE nnv_file.nnv02,
    nnv03 LIKE nnv_file.nnv03,
    nnv04 LIKE nnv_file.nnv04,
    nnv05 LIKE nnv_file.nnv05,
    nnv06 LIKE nnv_file.nnv06,
    nnv07 LIKE nnv_file.nnv07,
    nnv08 LIKE nnv_file.nnv08,
    nnv09 LIKE nnv_file.nnv09,
    nnv10 LIKE nnv_file.nnv10,
    nnv11 LIKE nnv_file.nnv11,
    nnv12 LIKE nnv_file.nnv12,
    nnv13 LIKE nnv_file.nnv13,
    nnv14 LIKE nnv_file.nnv14,
    nnv15 LIKE nnv_file.nnv15,
    nnv16 LIKE nnv_file.nnv16,
    nnv17 LIKE nnv_file.nnv17,
    nnv18 LIKE nnv_file.nnv18,
    nnv19 LIKE nnv_file.nnv19,
    nnv20 LIKE nnv_file.nnv20,
    nnv21 LIKE nnv_file.nnv21,
    nnv22 LIKE nnv_file.nnv22,
    nnv23 LIKE nnv_file.nnv23,
    nnv24 LIKE nnv_file.nnv24,
    nnv25 LIKE nnv_file.nnv25,
    nnv26 LIKE nnv_file.nnv26,
    nnv27 LIKE nnv_file.nnv27,
    nnv28 LIKE nnv_file.nnv28,
    nnv29 LIKE nnv_file.nnv29,
    nnv30 LIKE nnv_file.nnv30,
    nnv31 LIKE nnv_file.nnv31,
    nnv32 LIKE nnv_file.nnv32,
    nnv33 LIKE nnv_file.nnv33,
    nnv34 LIKE nnv_file.nnv34,
    nnv35 LIKE nnv_file.nnv35,
    nnv36 LIKE nnv_file.nnv36,
    nnv37 LIKE nnv_file.nnv37,
    nnv38 LIKE nnv_file.nnv38,
    nnv39 LIKE nnv_file.nnv39,
    nnv40 LIKE nnv_file.nnv40,
    nnvcon LIKE nnv_file.nnvconf,
    nnvact LIKE nnv_file.nnvacti,
    nnvuse LIKE nnv_file.nnvuser,
    nnvgru LIKE nnv_file.nnvgrup,
    nnvmod LIKE nnv_file.nnvmodu,
    nnvdat LIKE nnv_file.nnvdate,
    nnv121 LIKE nnv_file.nnv121,
    nnv191 LIKE nnv_file.nnv191,
    nnv271 LIKE nnv_file.nnv271,
    nnv41 LIKE nnv_file.nnv41,
    nnv42 LIKE nnv_file.nnv42,
    nmydesc LIKE nmy_file.nmydesc,
    gem02 LIKE gem_file.gem02,
    nml02 LIKE nml_file.nml02,
    azp02_1 LIKE azp_file.azp02,
    nma02_1 LIKE nma_file.nma02,
    nmc02_1 LIKE nmc_file.nmc02,
    aag02_1 LIKE aag_file.aag02,
    azi04_1 LIKE azi_file.azi04,
    azi07_1 LIKE azi_file.azi07,
    azp02_2 LIKE azp_file.azp02,
    nma02_2 LIKE nma_file.nma02,
    nmc02_2 LIKE nmc_file.nmc02,
    aag02_2 LIKE aag_file.aag02,
    azi04_2 LIKE azi_file.azi04,
    azi07_2 LIKE azi_file.azi07,
    nma02_3 LIKE nma_file.nma02,
    nmc02_3 LIKE nmc_file.nmc02,
    aag02_3 LIKE aag_file.aag02,
    azi04_3 LIKE azi_file.azi04,
    azi07_3 LIKE azi_file.azi07,
    nma02_4 LIKE nma_file.nma02,
    nma02_5 LIKE nma_file.nma02,
    sign_type LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_img  LIKE type_file.blob,   # No.FUN-C40020 add
    sign_show LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_str  LIKE type_file.chr1000 # No.FUN-C40020 add
END RECORD
###GENGRE###END

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
#No.FUN-710085--begin 
   LET g_sql = "nnv01.nnv_file.nnv01,",        
               "nnv02.nnv_file.nnv02,",        
               "nnv03.nnv_file.nnv03,",        
               "nnv04.nnv_file.nnv04,",        
               "nnv05.nnv_file.nnv05,",        
               "nnv06.nnv_file.nnv06,",        
               "nnv07.nnv_file.nnv07,",        
               "nnv08.nnv_file.nnv08,",        
               "nnv09.nnv_file.nnv09,",        
               "nnv10.nnv_file.nnv10,",        
               "nnv11.nnv_file.nnv11,",        
               "nnv12.nnv_file.nnv12,",        
               "nnv13.nnv_file.nnv13,",        
               "nnv14.nnv_file.nnv14,",        
               "nnv15.nnv_file.nnv15,",        
               "nnv16.nnv_file.nnv16,",        
               "nnv17.nnv_file.nnv17,",        
               "nnv18.nnv_file.nnv18,",        
               "nnv19.nnv_file.nnv19,",        
               "nnv20.nnv_file.nnv20,",        
               "nnv21.nnv_file.nnv21,",        
               "nnv22.nnv_file.nnv22,",        
               "nnv23.nnv_file.nnv23,",        
               "nnv24.nnv_file.nnv24,",        
               "nnv25.nnv_file.nnv25,",        
               "nnv26.nnv_file.nnv26,",        
               "nnv27.nnv_file.nnv27,",        
               "nnv28.nnv_file.nnv28,",        
               "nnv29.nnv_file.nnv29,",        
               "nnv30.nnv_file.nnv30,",        
               "nnv31.nnv_file.nnv31,",        
               "nnv32.nnv_file.nnv32,",        
               "nnv33.nnv_file.nnv33,",        
               "nnv34.nnv_file.nnv34,",        
               "nnv35.nnv_file.nnv35,",        
               "nnv36.nnv_file.nnv36,",        
               "nnv37.nnv_file.nnv37,",        
               "nnv38.nnv_file.nnv38,",        
               "nnv39.nnv_file.nnv39,",        
               "nnv40.nnv_file.nnv40,",        
               "nnvcon.nnv_file.nnvconf,",      
               "nnvact.nnv_file.nnvacti,",      
               "nnvuse.nnv_file.nnvuser,",      
               "nnvgru.nnv_file.nnvgrup,",      
               "nnvmod.nnv_file.nnvmodu,",      
               "nnvdat.nnv_file.nnvdate,",      
               "nnv121.nnv_file.nnv121,",      
               "nnv191.nnv_file.nnv191,",      
               "nnv271.nnv_file.nnv271,",      
               "nnv41.nnv_file.nnv41,",        
               "nnv42.nnv_file.nnv42,",        
               "nmydesc.nmy_file.nmydesc,",    
               "gem02.gem_file.gem02,",        
               "nml02.nml_file.nml02,",        
               "azp02_1.azp_file.azp02,",      
               "nma02_1.nma_file.nma02,",      
               "nmc02_1.nmc_file.nmc02,",      
               "aag02_1.aag_file.aag02,",      
               "azi04_1.azi_file.azi04,",      
               "azi07_1.azi_file.azi07,",      
               "azp02_2.azp_file.azp02,",      
               "nma02_2.nma_file.nma02,",      
               "nmc02_2.nmc_file.nmc02,",      
               "aag02_2.aag_file.aag02,",      
               "azi04_2.azi_file.azi04,",      
               "azi07_2.azi_file.azi07,",      
               "nma02_3.nma_file.nma02,",                 
               "nmc02_3.nmc_file.nmc02,",      
               "aag02_3.aag_file.aag02,",      
               "azi04_3.azi_file.azi04,",      
               "azi07_3.azi_file.azi07,",           
               "nma02_4.nma_file.nma02,",      
               "nma02_5.nma_file.nma02,",
               "sign_type.type_file.chr1,sign_img.type_file.blob,",  # No.FUN-C40020 add
               "sign_show.type_file.chr1,sign_str.type_file.chr1000" # No.FUN-C40020 add        
                                               
   LET l_table = cl_prt_temptable('anmg920',g_sql) CLIPPED 
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add 
      CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
      EXIT PROGRAM 
   END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, 
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"  
   PREPARE insert_prep FROM g_sql    
   IF STATUS THEN  
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add
      CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
      EXIT PROGRAM    
   END IF                           
#No.FUN-710085--end 
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.more = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
      CALL anmg920_tm()
   ELSE
      CALL anmg920()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION anmg920_tm()
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01
   DEFINE p_row,p_col   LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_cmd         LIKE type_file.chr1000        #No.FUN-680107 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW anmg920_w AT p_row,p_col
     WITH FORM "anm/42f/anmg920"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
 
      CONSTRUCT BY NAME tm.wc ON nnv01,nnv02
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
        
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
        
         ON ACTION about
            CALL cl_about()
        
         ON ACTION help
            CALL cl_show_help()
        
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nnvuser', 'nnvgrup') #FUN-980030
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW anmg920_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE 
      END IF
 
      INPUT BY NAME tm.more WITHOUT DEFAULTS
 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR cl_null(tm.more) THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         
         ON ACTION about
            CALL cl_about()
         
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW anmr910_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='anmg920'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('anmg920','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc,"'","\"")
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.more CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",
                        " '",g_rep_clas CLIPPED,"'",
                        " '",g_template CLIPPED,"'"
            CALL cl_cmdat('anmg920',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW anmg920_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL anmg920()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW anmg920_w
 
END FUNCTION
 
FUNCTION anmg920()
   DEFINE l_name      LIKE type_file.chr20,         #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8          #No.FUN-6A0082
          l_buf       LIKE nmy_file.nmyslip,        #No.FUN-680107 VARCHAR(6)
          l_sql       STRING,        
          sr          RECORD
                         nnv      RECORD LIKE nnv_file.*,
                         nmydesc  LIKE nmy_file.nmydesc,
                         gem02    LIKE gem_file.gem02,
                         nml02    LIKE nml_file.nml02,
                         azp02_1  LIKE azp_file.azp02,
                         nma02_1  LIKE nma_file.nma02,
                         nmc02_1  LIKE nmc_file.nmc02,
                         aag02_1  LIKE aag_file.aag02,
                         azi04_1  LIKE azi_file.azi04,
                         azi07_1  LIKE azi_file.azi07,
                         azp02_2  LIKE azp_file.azp02,
                         nma02_2  LIKE nma_file.nma02,
                         nmc02_2  LIKE nmc_file.nmc02,
                         aag02_2  LIKE aag_file.aag02,
                         azi04_2  LIKE azi_file.azi04,
                         azi07_2  LIKE azi_file.azi07,
                         nma02_3  LIKE nma_file.nma02,
                         nmc02_3  LIKE nmc_file.nmc02,
                         aag02_3  LIKE aag_file.aag02,
                         azi04_3  LIKE azi_file.azi04,
                         azi07_3  LIKE azi_file.azi07,
                         nma02_4  LIKE nma_file.nma02,  #No.FUN-690090 
                         nma02_5  LIKE nma_file.nma02   #No.FUN-690090 
                      END RECORD
   DEFINE l_dbs1      LIKE type_file.chr21              #No.FUN-690090
   DEFINE l_plant1    LIKE type_file.chr10              #No.FUN-980020
   DEFINE l_img_blob        LIKE type_file.blob  # No.FUN-C40020 add
  # LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add
   DEFINE l_dbs2      LIKE type_file.chr21              #No.FUN-690090
#No.FUN-710085--begin
    DEFINE l_alg021     LIKE alg_file.alg02
#No.FUN-710085--end
   LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add 
#No.FUN-710085--begin                                                                                                               
     CALL cl_del_data(l_table)                                                                                                      
#No.FUN-710085--end 
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'anmg920'
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
  #FUN-C50007--MOD--STR 
  # LET l_sql = "SELECT nnv_file.*,'','','','','','','','','','','','','','','','',''",
  #             "  FROM nnv_file",
    LET l_sql = "SELECT nnv_file.*,'',gem02,nml02,'','','','','','','','','','','','','',''",
                "  FROM nnv_file LEFT OUTER JOIN gem_file ON nnv03=gem01 ",
                "  LEFT OUTER JOIN nml_file ON nml01=nnv04 ",
  #FUN-C50007--MOD--END
               " WHERE ",tm.wc CLIPPED,
               " ORDER BY nnv01"
 
   PREPARE anmg920_prepare FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
 
   DECLARE anmg920_curs CURSOR FOR anmg920_prepare
 
#No.FUN-710085--begin
#  CALL cl_outnam('anmg920') RETURNING l_name
#  START REPORT anmg920_rep TO l_name
#  LET g_pageno = 0
#
#No.FUN-710085--end

   FOREACH anmg920_curs INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      #No.FUN-690090 --start--
      LET l_plant1 = sr.nnv.nnv05        #FUN-980020
      LET g_plant_new = sr.nnv.nnv05
      CALL s_getdbs()
      LET l_dbs1 = g_dbs_new
      LET g_plant_new = sr.nnv.nnv20
      CALL s_getdbs()
      LET l_dbs2 = g_dbs_new
      #No.FUN-690090 --end--
#NO.FUN-740049     ---Begin
#CALL s_get_bookno1(NULL,l_dbs1)     RETURNING  g_flag,g_bookno1,g_bookno2     #FUN-980020 mark#TQC-9C0099
# CALL s_get_bookno1(NULL,l_plant1)     RETURNING  g_flag,g_bookno1,g_bookno2   #FUN-980020    #TQC-9C0099  #FUN-C10024 mark
#FUN-C10024--add--str--
CALL s_get_bookno1(YEAR(sr.nnv.nnv02),l_plant1)     RETURNING  g_flag,g_bookno1,g_bookno2  
   IF g_flag = '1' THEN
      CALL  cl_err(g_aza.aza01,'aoo-081',1)
   END IF
#FUN-C10024--add--end--

#NO.FUN-740049    ---END     

    LET l_buf = s_get_doc_no(sr.nnv.nnv01)
     SELECT nmydesc INTO sr.nmydesc FROM nmy_file
      WHERE nmyslip = l_buf
   
#FUN-C50007--MARK-STR 
   #  SELECT gem02 INTO sr.gem02 FROM gem_file
   #   WHERE gem01 = sr.nnv.nnv03
 
   #  SELECT nml02 INTO sr.nml02 FROM nml_file
   #   WHERE nml01 = sr.nnv.nnv04
#FUN-C50007--MARK--END
      #No.FUN-690090 --start--
#     SELECT azp02 INTO sr.azp02_1  FROM azp_file
#      WHERE azp01 = sr.nnv.nnv05
 
#     SELECT nma02 INTO sr.nma02_1  FROM nma_file
#      WHERE nma01 = sr.nnv.nnv06
 
#     SELECT nmc02 INTO sr.nmc02_1  FROM nmc_file
#      WHERE nmc01 = sr.nnv.nnv07
 
#     SELECT aag02 INTO sr.aag02_1  FROM aag_file
#      WHERE aag01 = sr.nnv.nnv12
 
#     SELECT azi04,azi07 INTO sr.azi04_1,sr.azi07_1  FROM azi_file
#      WHERE azi01 = sr.nnv.nnv08
 
#     SELECT azp02 INTO sr.azp02_2  FROM azp_file
#     SELECT azp02 INTO sr.azp02_2  FROM azp_file
#      WHERE azp01 = sr.nnv.nnv20
 
#     SELECT nma02 INTO sr.nma02_2  FROM nma_file
#      WHERE nma01 = sr.nnv.nnv21
 
#     SELECT nmc02 INTO sr.nmc02_2  FROM nmc_file
#      WHERE nmc01 = sr.nnv.nnv22
 
#     SELECT aag02 INTO sr.aag02_2  FROM aag_file
#      WHERE aag01 = sr.nnv.nnv27
 
#     SELECT azi04,azi07 INTO sr.azi04_2,sr.azi07_2  FROM azi_file
#      WHERE azi01 = sr.nnv.nnv23
 
#     SELECT nma02 INTO sr.nma02_3  FROM nma_file
#      WHERE nma01 = sr.nnv.nnv13
 
#     SELECT nmc02 INTO sr.nmc02_3  FROM nmc_file
#      WHERE nmc01 = sr.nnv.nnv14
 
#     SELECT aag02 INTO sr.aag02_3  FROM aag_file
#      WHERE aag01 = sr.nnv.nnv19
 
#     SELECT azi04,azi07 INTO sr.azi04_3,sr.azi07_3  FROM azi_file
#      WHERE azi01 = sr.nnv.nnv15

      #LET l_sql = "SELECT azp02 FROM ",l_dbs1,"azp_file",
      LET l_sql = "SELECT azp02 FROM ",cl_get_target_table(sr.nnv.nnv05,'azp_file'), #FUN-A50102
                  " WHERE azp01 = '",sr.nnv.nnv05,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnv.nnv05) RETURNING l_sql #FUN-A50102
      PREPARE azp02_p1 FROM l_sql
      DECLARE azp02_c1 CURSOR FOR azp02_p1
      OPEN azp02_c1
      FETCH azp02_c1 INTO sr.azp02_1
 
      #LET l_sql = "SELECT nma02 FROM ",l_dbs1,"nma_file",
      LET l_sql = "SELECT nma02 FROM ",cl_get_target_table(sr.nnv.nnv05,'nma_file'), #FUN-A50102
                  " WHERE nma01 = '",sr.nnv.nnv06,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnv.nnv05) RETURNING l_sql #FUN-A50102
      PREPARE nma02_p1 FROM l_sql
      DECLARE nma02_c1 CURSOR FOR nma02_p1
      OPEN nma02_c1
      FETCH nma02_c1 INTO sr.nma02_1

      #LET l_sql = "SELECT nmc02 FROM ",l_dbs1,"nmc_file",
      LET l_sql = "SELECT nmc02 FROM ",cl_get_target_table(sr.nnv.nnv05,'nmc_file'), #FUN-A50102
                  " WHERE nmc01 = '",sr.nnv.nnv07,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnv.nnv05) RETURNING l_sql #FUN-A50102
      PREPARE nmc02_p1 FROM l_sql
      DECLARE nmc02_c1 CURSOR FOR nmc02_p1
      OPEN nmc02_c1
      FETCH nmc02_c1 INTO sr.nmc02_1
 
      #LET l_sql = "SELECT aag02 FROM ",l_dbs1,"aag_file",
      LET l_sql = "SELECT aag02 FROM ",cl_get_target_table(sr.nnv.nnv05,'aag_file'), #FUN-A50102
                  " WHERE aag01 = '",sr.nnv.nnv12,"'",
                  "   AND aag00 = '",g_bookno1,"'"    #NO.FUN-740049
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnv.nnv05) RETURNING l_sql #FUN-A50102
      PREPARE aag02_p1 FROM l_sql
      DECLARE aag02_c1 CURSOR FOR aag02_p1
      OPEN aag02_c1
      FETCH aag02_c1 INTO sr.aag02_1
 
      #LET l_sql = "SELECT azi04,azi07 FROM ",l_dbs1,"azi_file",
      LET l_sql = "SELECT azi04,azi07 FROM ",cl_get_target_table(sr.nnv.nnv05,'azi_file'), #FUN-A50102
                  " WHERE azi01 = '",sr.nnv.nnv08,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnv.nnv05) RETURNING l_sql #FUN-A50102
      PREPARE azi04_p1 FROM l_sql
      DECLARE azi04_c1 CURSOR FOR azi04_p1
      OPEN azi04_c1
      FETCH azi04_c1 INTO sr.azi04_1,sr.azi07_1
 
      #LET l_sql = "SELECT nma02 FROM ",l_dbs1,"nma_file",
      LET l_sql = "SELECT nma02 FROM ",cl_get_target_table(sr.nnv.nnv05,'nma_file'), #FUN-A50102
                  " WHERE nma01 = '",sr.nnv.nnv41,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnv.nnv05) RETURNING l_sql #FUN-A50102
      PREPARE nma02_p2 FROM l_sql
      DECLARE nma02_c2 CURSOR FOR nma02_p2
      OPEN nma02_c2
      FETCH nma02_c2 INTO sr.nma02_4
 
      #LET l_sql = "SELECT azp02 FROM ",l_dbs2,"azp_file",
      LET l_sql = "SELECT azp02 FROM ",cl_get_target_table(sr.nnv.nnv20,'azp_file'), #FUN-A50102
                  " WHERE azp01 = '",sr.nnv.nnv20,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnv.nnv20) RETURNING l_sql #FUN-A50102
      PREPARE azp02_p2 FROM l_sql
      DECLARE azp02_c2 CURSOR FOR azp02_p2
      OPEN azp02_c2
      FETCH azp02_c2 INTO sr.azp02_2
 
      #LET l_sql = "SELECT nma02 FROM ",l_dbs2,"nma_file",
      LET l_sql = "SELECT nma02 FROM ",cl_get_target_table(sr.nnv.nnv20,'nma_file'), #FUN-A50102
                  " WHERE nma01 = '",sr.nnv.nnv21,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnv.nnv20) RETURNING l_sql #FUN-A50102
      PREPARE nma02_p3 FROM l_sql
      DECLARE nma02_c3 CURSOR FOR nma02_p3
      OPEN nma02_c3
      FETCH nma02_c3 INTO sr.nma02_2
 
      #LET l_sql = "SELECT nmc02 FROM ",l_dbs2,"nmc_file",
      LET l_sql = "SELECT nmc02 FROM ",cl_get_target_table(sr.nnv.nnv20,'nmc_file'), #FUN-A50102
                  " WHERE nmc01 = '",sr.nnv.nnv22,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnv.nnv20) RETURNING l_sql #FUN-A50102
      PREPARE nmc02_p2 FROM l_sql
      DECLARE nmc02_c2 CURSOR FOR nmc02_p2
      OPEN nmc02_c2
      FETCH nmc02_c2 INTO sr.nmc02_2
 
      #LET l_sql = "SELECT aag02 FROM ",l_dbs2,"aag_file",
      LET l_sql = "SELECT aag02 FROM ",cl_get_target_table(sr.nnv.nnv20,'aag_file'), #FUN-A50102
                  " WHERE aag01 = '",sr.nnv.nnv27,"'",
                  "   AND aag00 = '",g_bookno1,"'"     #NO.FUN-740049
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnv.nnv20) RETURNING l_sql #FUN-A50102
      PREPARE aag02_p2 FROM l_sql
      DECLARE aag02_c2 CURSOR FOR aag02_p2
      OPEN aag02_c2
      FETCH aag02_c2 INTO sr.aag02_2
 
      #LET l_sql = "SELECT azi04,azi07 FROM ",l_dbs2,"azi_file",
      LET l_sql = "SELECT azi04,azi07 FROM ",cl_get_target_table(sr.nnv.nnv20,'azi_file'), #FUN-A50102
                  " WHERE azi01 = '",sr.nnv.nnv23,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnv.nnv20) RETURNING l_sql #FUN-A50102
      PREPARE azi04_p2 FROM l_sql
      DECLARE azi04_c2 CURSOR FOR azi04_p2
      OPEN azi04_c2
      FETCH azi04_c2 INTO sr.azi04_2,sr.azi07_2
 
      #LET l_sql = "SELECT nma02 FROM ",l_dbs2,"nma_file",
      LET l_sql = "SELECT nma02 FROM ",cl_get_target_table(sr.nnv.nnv20,'nma_file'), #FUN-A50102
                  " WHERE nma01 = '",sr.nnv.nnv42,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnv.nnv20) RETURNING l_sql #FUN-A50102
      PREPARE nma02_p4 FROM l_sql
      DECLARE nma02_c4 CURSOR FOR nma02_p4
      OPEN nma02_c4
      FETCH nma02_c4 INTO sr.nma02_5
 
      #LET l_sql = "SELECT nma02 FROM ",l_dbs1,"nma_file",
      LET l_sql = "SELECT nma02 FROM ",cl_get_target_table(sr.nnv.nnv05,'nma_file'), #FUN-A50102
                  " WHERE nma01 = '",sr.nnv.nnv13,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnv.nnv05) RETURNING l_sql #FUN-A50102
      PREPARE nma02_p5 FROM l_sql
      DECLARE nma02_c5 CURSOR FOR nma02_p5
      OPEN nma02_c5
      FETCH nma02_c5 INTO sr.nma02_3
 
      #LET l_sql = "SELECT nmc02 FROM ",l_dbs1,"nmc_file",
      LET l_sql = "SELECT nmc02 FROM ",cl_get_target_table(sr.nnv.nnv05,'nmc_file'), #FUN-A50102
                  " WHERE nmc01 = '",sr.nnv.nnv14,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnv.nnv05) RETURNING l_sql #FUN-A50102
      PREPARE nmc02_p3 FROM l_sql
      DECLARE nmc02_c3 CURSOR FOR nmc02_p3
      OPEN nmc02_c3
      FETCH nmc02_c3 INTO sr.nmc02_3
 
      #LET l_sql = "SELECT aag02 FROM ",l_dbs1,"aag_file",
      LET l_sql = "SELECT aag02 FROM ",cl_get_target_table(sr.nnv.nnv05,'aag_file'), #FUN-A50102
                  " WHERE aag01 = '",sr.nnv.nnv19,"'",
                  "   AND aag00 = '",g_bookno1,"'"    #NO.FUN-740049
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnv.nnv05) RETURNING l_sql #FUN-A50102
      PREPARE aag02_p3 FROM l_sql
      DECLARE aag02_c3 CURSOR FOR aag02_p3
      OPEN aag02_c3
      FETCH aag02_c3 INTO sr.aag02_3
 
      #LET l_sql = "SELECT azi04,azi07 FROM ",l_dbs1,"azi_file",
      LET l_sql = "SELECT azi04,azi07 FROM ",cl_get_target_table(sr.nnv.nnv05,'azi_file'), #FUN-A50102
                  " WHERE azi01 = '",sr.nnv.nnv15,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnv.nnv05) RETURNING l_sql #FUN-A50102
      PREPARE azi04_p3 FROM l_sql
      DECLARE azi04_c3 CURSOR FOR azi04_p3
      OPEN azi04_c3
      FETCH azi04_c3 INTO sr.azi04_3,sr.azi07_3
      #No.FUN-690090 --end--
 
#No.FUN-710085--begin
#      EXECUTE insert_prep USING sr.*        #No.FUN-850062
      EXECUTE insert_prep USING sr.nnv.nnv01,sr.nnv.nnv02,sr.nnv.nnv03,sr.nnv.nnv04,sr.nnv.nnv05,
                                sr.nnv.nnv06,sr.nnv.nnv07,sr.nnv.nnv08,sr.nnv.nnv09,sr.nnv.nnv10,
                                sr.nnv.nnv11,sr.nnv.nnv12,sr.nnv.nnv13,sr.nnv.nnv14,sr.nnv.nnv15,
                                sr.nnv.nnv16,sr.nnv.nnv17,sr.nnv.nnv18,sr.nnv.nnv19,sr.nnv.nnv20,
                                sr.nnv.nnv21,sr.nnv.nnv22,sr.nnv.nnv23,sr.nnv.nnv24,sr.nnv.nnv25,
                                sr.nnv.nnv26,sr.nnv.nnv27,sr.nnv.nnv28,sr.nnv.nnv29,sr.nnv.nnv30,
                                sr.nnv.nnv31,sr.nnv.nnv32,sr.nnv.nnv33,sr.nnv.nnv34,sr.nnv.nnv35,
                                sr.nnv.nnv36,sr.nnv.nnv37,sr.nnv.nnv38,sr.nnv.nnv39,sr.nnv.nnv40,
                                sr.nnv.nnvconf,sr.nnv.nnvacti,sr.nnv.nnvuser,sr.nnv.nnvgrup,sr.nnv.nnvmodu,
                                sr.nnv.nnvdate,sr.nnv.nnv121,sr.nnv.nnv191,sr.nnv.nnv271,sr.nnv.nnv41,
                                sr.nnv.nnv42,sr.nmydesc,sr.gem02,sr.nml02,sr.azp02_1,sr.nma02_1,
                                sr.nmc02_1,sr.aag02_1,sr.azi04_1,sr.azi07_1,sr.azp02_2,sr.nma02_2,
                                sr.nmc02_2,sr.aag02_2,sr.azi04_2,sr.azi07_2,sr.nma02_3,sr.nmc02_3,
                                sr.aag02_3,sr.azi04_3,sr.azi07_3,sr.nma02_4,sr.nma02_5,"",  l_img_blob,"N",""  # No.FUN-C40020 add             
 
#     OUTPUT TO REPORT anmg920_rep(sr.*)
#No.FUN-710085--end
   END FOREACH
 
 
#No.FUN-710085--begin
#    FINISH REPORT anmg920_rep
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     CALL cl_wcchp(tm.wc,'nnv01,nnv02')
          RETURNING tm.wc 
   # LET g_sql = "SELECT * FROM ",l_table CLIPPED    #TQC-730088
###GENGRE###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 
###GENGRE###     LET g_str = tm.wc         
   # CALL cl_prt_cs3('anmg920',g_sql,g_str)          #TQC-730088 
###GENGRE###     CALL cl_prt_cs3('anmg920','anmg920',g_sql,g_str)  
    LET g_cr_table = l_table                    # No.FUN-C40020 add
    LET g_cr_apr_key_f = "nnv01"                    # No.FUN-C40020 add
    CALL anmg920_grdata()    ###GENGRE###
#No.FUN-710085--end
 
END FUNCTION
 
#No.FUN-710085--begin
#REPORT anmg920_rep(sr)
#   DEFINE l_last_sw   LIKE type_file.chr1,     #FUN-680107 VARCHAR(1)
#          sr          RECORD
#                         nnv      RECORD LIKE nnv_file.*,
#                         nmydesc  LIKE nmy_file.nmydesc,
#                         gem02    LIKE gem_file.gem02,
#                         nml02    LIKE nml_file.nml02,
#                         azp02_1  LIKE azp_file.azp02,
#                         nma02_1  LIKE nma_file.nma02,
#                         nmc02_1  LIKE nmc_file.nmc02,
#                         aag02_1  LIKE aag_file.aag02,
#                         azi04_1  LIKE azi_file.azi04,
#                         azi07_1  LIKE azi_file.azi07,
#                         azp02_2  LIKE azp_file.azp02,
#                         nma02_2  LIKE nma_file.nma02,
#                         nmc02_2  LIKE nmc_file.nmc02,
#                         aag02_2  LIKE aag_file.aag02,
#                         azi04_2  LIKE azi_file.azi04,
#                         azi07_2  LIKE azi_file.azi07,
#                         nma02_3  LIKE nma_file.nma02,
#                         nmc02_3  LIKE nmc_file.nmc02,
#                         aag02_3  LIKE aag_file.aag02,
#                         azi04_3  LIKE azi_file.azi04,
#                         azi07_3  LIKE azi_file.azi07,
#                         nma02_4  LIKE nma_file.nma02,  #No.FUN-690090 
#                         nma02_5  LIKE nma_file.nma02   #No.FUN-690090 
#                      END RECORD
#
#   OUTPUT
#      TOP MARGIN 0
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN 5
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.nnv.nnv01
#
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#         PRINT g_dash[1,g_len]
#         LET l_last_sw = 'n'
#     
#      BEFORE GROUP OF sr.nnv.nnv01
#         SKIP TO TOP OF PAGE
#     
#      ON EVERY ROW
#         #No.TQC-6B0114 --start--  打印內容連在一起的用空格隔開
#         PRINT COLUMN  1,g_x[9],sr.nnv.nnv01,' ',sr.nmydesc,
#               COLUMN 45,g_x[11],sr.nnv.nnv03,' ',sr.gem02,
#               COLUMN 83,g_x[13],sr.nnv.nnv34
#         PRINT COLUMN  1,g_x[10],sr.nnv.nnv02,
#               COLUMN 45,g_x[12],sr.nnv.nnv04,' ',sr.nml02,
#               COLUMN 83,g_x[14],sr.nnv.nnv35
#         PRINT COLUMN 83,g_x[15],sr.nnv.nnvconf
#         PRINT
#         PRINT COLUMN  1,g_x[16],sr.nnv.nnv05,' ',sr.azp02_1,
#               COLUMN 55,g_x[29],sr.nnv.nnv20,' ',sr.azp02_2
#         PRINT COLUMN  1,g_x[17],sr.nnv.nnv06,' ',sr.nma02_1,
#               COLUMN 55,g_x[30],sr.nnv.nnv21,' ',sr.nma02_2
#         PRINT COLUMN  1,g_x[18],sr.nnv.nnv07,' ',sr.nmc02_1,
#               COLUMN 55,g_x[31],sr.nnv.nnv22,' ',sr.nmc02_2
#         PRINT COLUMN  1,g_x[19],sr.nnv.nnv08 CLIPPED,' ',cl_numfor(sr.nnv.nnv09,10,sr.azi07_1),
#               COLUMN 55,g_x[32],sr.nnv.nnv23 CLIPPED,' ',cl_numfor(sr.nnv.nnv24,10,sr.azi07_1)
#         PRINT COLUMN  1,g_x[20],cl_numfor(sr.nnv.nnv10,18,sr.azi04_1),
#               COLUMN 55,g_x[33],cl_numfor(sr.nnv.nnv25,18,sr.azi04_2)
#         PRINT COLUMN  1,g_x[21],cl_numfor(sr.nnv.nnv11,18,sr.azi04_1),
#               COLUMN 55,g_x[34],cl_numfor(sr.nnv.nnv26,18,sr.azi04_2)
#         PRINT COLUMN  1,g_x[22],sr.nnv.nnv12,' ',sr.aag02_1,
#               COLUMN 55,g_x[35],sr.nnv.nnv27,' ',sr.aag02_2
#         PRINT COLUMN  1,g_x[42],sr.nnv.nnv41,' ',sr.nma02_4, #No.FUN-690090
#               COLUMN 55,g_x[43],sr.nnv.nnv42,' ',sr.nma02_5  #No.FUN-690090
#         PRINT
#         PRINT COLUMN  1,g_x[23],sr.nnv.nnv13,' ',sr.nma02_3,
#               COLUMN 55,g_x[36],sr.nnv.nnv28
#         PRINT COLUMN  1,g_x[24],sr.nnv.nnv14,' ',sr.nmc02_3
#         PRINT COLUMN  1,g_x[25],sr.nnv.nnv15 CLIPPED,' ',cl_numfor(sr.nnv.nnv16,10,sr.azi07_3),
#               COLUMN 55,g_x[37],cl_numfor(sr.nnv.nnv29,18,sr.azi04_2)
#         PRINT COLUMN  1,g_x[26],cl_numfor(sr.nnv.nnv17,18,sr.azi04_3),
#               COLUMN 55,g_x[38],cl_numfor(sr.nnv.nnv30,18,sr.azi04_2)
#         PRINT COLUMN  1,g_x[27],cl_numfor(sr.nnv.nnv18,18,sr.azi04_3),
#               COLUMN 55,g_x[39],cl_numfor(sr.nnv.nnv31,18,sr.azi04_2)
#         PRINT COLUMN  1,g_x[28],sr.nnv.nnv19,' ',sr.aag02_3,
#               COLUMN 55,g_x[40],cl_numfor(sr.nnv.nnv32,18,sr.azi04_2)
#         PRINT COLUMN 55,g_x[41],sr.nnv.nnv33
#         #No.TQC-6B0114 --end--
#
#      AFTER GROUP OF sr.nnv.nnv01
#         PRINT g_dash[1,g_len]
#            
#     #ON LAST ROW
#     #   PRINT g_dash[1,g_len]
#     #   LET l_last_sw = 'y'
#     #   PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#     
#     #PAGE TRAILER
#     #   IF l_last_sw = 'n' THEN 
#     #      PRINT g_dash[1,g_len]
#     #      PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#     #   ELSE
#     #      SKIP 2 LINE
#     #   END IF
#
#END REPORT
#No.FUN-710085--end

###GENGRE###START
FUNCTION anmg920_grdata()
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
        LET handler = cl_gre_outnam("anmg920")
        IF handler IS NOT NULL THEN
            START REPORT anmg920_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY nnv01" 
            DECLARE anmg920_datacur1 CURSOR FROM l_sql
            FOREACH anmg920_datacur1 INTO sr1.*
                OUTPUT TO REPORT anmg920_rep(sr1.*)
            END FOREACH
            FINISH REPORT anmg920_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT anmg920_rep(sr1)
DEFINE sr1 sr1_t
DEFINE l_lineno LIKE type_file.num5
#FUN-B50018----add-----str--------
DEFINE l_nnv01_nmydesc    STRING
DEFINE l_nnv03_gem02      STRING
DEFINE l_nnv04_nml02      STRING
DEFINE l_nnv05_azp02_1    STRING
DEFINE l_nnv06_nma02_1    STRING
DEFINE l_nnv07_nmc02_1    STRING
DEFINE l_nnv09            STRING
DEFINE l_nnv08_nnv09      STRING
DEFINE l_nnv12_aag02_1    STRING
DEFINE l_nnv13_nma02_3    STRING
DEFINE l_nnv14_nmc02_3    STRING
DEFINE l_nnv16            STRING
DEFINE l_nnv15_nnv16      STRING
DEFINE l_nnv19_aag02_3    STRING
DEFINE l_nnv20_azp02_2    STRING
DEFINE l_nnv21_nma02_2    STRING
DEFINE l_nnv22_nmc02_2    STRING
DEFINE l_nnv24            STRING
DEFINE l_nnv23_nnv24      STRING
DEFINE l_nnv27_aag02_2    STRING 
DEFINE l_nnv41_nma02_4    STRING
DEFINE l_nnv42_nma02_5    STRING
DEFINE l_nnv09_fmt        STRING
DEFINE l_nnv10_fmt        STRING
DEFINE l_nnv11_fmt        STRING
DEFINE l_nnv24_fmt        STRING
DEFINE l_nnv25_fmt        STRING
DEFINE l_nnv26_fmt        STRING
DEFINE l_nnv16_fmt        STRING
DEFINE l_nnv29_fmt        STRING
DEFINE l_nnv17_fmt        STRING
DEFINE l_nnv30_fmt        STRING
DEFINE l_nnv18_fmt        STRING
DEFINE l_nnv31_fmt        STRING
DEFINE l_nnv32_fmt        STRING
#FUN-B50018----add-----end--------  
    
    ORDER EXTERNAL BY sr1.nnv01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.nnv01
            LET l_lineno = 0

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-B50018----add-----str--------
            LET l_nnv09_fmt = cl_gr_numfmt('nnv_file','nnv09',sr1.azi07_1)
            PRINTX l_nnv09_fmt
            LET l_nnv24_fmt = cl_gr_numfmt('nnv_file','nnv24',sr1.azi07_1)
            PRINTX l_nnv24_fmt
            LET l_nnv10_fmt = cl_gr_numfmt('nnv_file','nnv10',sr1.azi04_1)
            PRINTX l_nnv10_fmt
            LET l_nnv25_fmt = cl_gr_numfmt('nnv_file','nnv25',sr1.azi04_2)
            PRINTX l_nnv25_fmt
            LET l_nnv11_fmt = cl_gr_numfmt('nnv_file','nnv11',sr1.azi04_1)
            PRINTX l_nnv11_fmt
            LET l_nnv26_fmt = cl_gr_numfmt('nnv_file','nnv26',sr1.azi04_2)
            PRINTX l_nnv26_fmt
            LET l_nnv16_fmt = cl_gr_numfmt('nnv_file','nnv16',sr1.azi07_3)
            PRINTX l_nnv16_fmt
            LET l_nnv29_fmt = cl_gr_numfmt('nnv_file','nnv29',sr1.azi04_2)
            PRINTX l_nnv29_fmt
            LET l_nnv17_fmt = cl_gr_numfmt('nnv_file','nnv17',sr1.azi07_3)
            PRINTX l_nnv17_fmt
            LET l_nnv30_fmt = cl_gr_numfmt('nnv_file','nnv30',sr1.azi04_2)
            PRINTX l_nnv30_fmt
            LET l_nnv18_fmt = cl_gr_numfmt('nnv_file','nnv18',sr1.azi07_3)
            PRINTX l_nnv18_fmt
            LET l_nnv31_fmt = cl_gr_numfmt('nnv_file','nnv31',sr1.azi04_2)
            PRINTX l_nnv31_fmt
            LET l_nnv32_fmt = cl_gr_numfmt('nnv_file','nnv32',sr1.azi04_2)
            PRINTX l_nnv32_fmt
            LET l_nnv01_nmydesc = sr1.nnv01,' ',sr1.nmydesc
           #LET l_nnv03_gem02 = sr1.nnv03,' ',sr1.nml02  #FUN-C50007  MARK
            LET l_nnv03_gem02 = sr1.nnv03,' ',sr1.gem02  #FUN-C50007   add
            LET l_nnv04_nml02 = sr1.nnv04,' ',sr1.nml02
            LET l_nnv05_azp02_1 = sr1.nnv05,' ',sr1.azp02_1
            LET l_nnv06_nma02_1 = sr1.nnv06,' ',sr1.nma02_1
            LET l_nnv07_nmc02_1 = sr1.nnv07,' ',sr1.nmc02_1
            LET l_nnv09 = sr1.nnv09 USING '##,###,##&.&&'
            LET l_nnv08_nnv09 = sr1.nnv08,' ',l_nnv09 
            LET l_nnv12_aag02_1 = sr1.nnv12,' ',sr1.aag02_1
            LET l_nnv13_nma02_3 = sr1.nnv13,' ',sr1.nma02_3
            LET l_nnv14_nmc02_3 = sr1.nnv14,' ',sr1.nmc02_3
            LET l_nnv16 = sr1.nnv16 USING '##,###,##&.&&'
            LET l_nnv15_nnv16 = sr1.nnv15,' ',l_nnv16
            LET l_nnv19_aag02_3 = sr1.nnv19,' ',sr1.aag02_3
            LET l_nnv20_azp02_2 = sr1.nnv20,' ',sr1.azp02_2
            LET l_nnv21_nma02_2 = sr1.nnv21,' ',sr1.nma02_2
            LET l_nnv22_nmc02_2 = sr1.nnv22,' ',sr1.nmc02_2
            LET l_nnv24 = sr1.nnv24 USING '##,###,##&.&&'
            LET l_nnv23_nnv24 = sr1.nnv23,' ',l_nnv24
            LET l_nnv27_aag02_2 = sr1.nnv27,' ',sr1.aag02_2
            LET l_nnv41_nma02_4 = sr1.nnv41,' ',sr1.nma02_4
            LET l_nnv42_nma02_5 = sr1.nnv42,' ',sr1.nma02_5
            PRINTX  l_nnv01_nmydesc
            PRINTX  l_nnv03_gem02
            PRINTX  l_nnv04_nml02 
            PRINTX  l_nnv05_azp02_1
            PRINTX  l_nnv06_nma02_1
            PRINTX  l_nnv07_nmc02_1
            PRINTX  l_nnv08_nnv09
            PRINTX  l_nnv12_aag02_1
            PRINTX  l_nnv13_nma02_3
            PRINTX  l_nnv14_nmc02_3
            PRINTX  l_nnv15_nnv16
            PRINTX  l_nnv19_aag02_3 
            PRINTX  l_nnv20_azp02_2 
            PRINTX  l_nnv21_nma02_2
            PRINTX  l_nnv22_nmc02_2 
            PRINTX  l_nnv23_nnv24
            PRINTX  l_nnv27_aag02_2
            PRINTX  l_nnv41_nma02_4        
            PRINTX  l_nnv42_nma02_5        
            #FUN-B50018----add-----end--------

            PRINTX sr1.*

        AFTER GROUP OF sr1.nnv01

        
        ON LAST ROW

END REPORT
###GENGRE###END
