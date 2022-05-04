# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aimr899.4gl
# Descriptions...: 盤盈虧明細表
# Date & Author..: 95/06/07 by Roger
# Modify..........dbo.No:7597 03/07/14 By mandy pia03 /pia04 宣告時是用char(4).., 應用 like pia_file.pia03
# Modify.........:No.B012 04/01/12 Kammy 1.盤點量要跟 pia08比較，而非img10/imk09
#                                        2.畫面上"庫存結存年月"拿掉
# Modify.........:No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-510017 05/01/12 By Mandy 報表轉XML
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-610050 06/01/11 By Claire construct 順序變動
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/07 By baogui  g_x[]后加CLIPPED
# Modify.........: No.FUN-7C0007 07/12/12 By baofei  報表輸出至 Crystal Reports 功能 
# Modify.........: No.FUN-930121 09/04/13 By zhaijie新增查詢字段pia931-底稿類型 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-C40001 12/04/01 By SunLM chr1000--->STRING
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD            
           #wc      LIKE type_file.chr1000,        #No.FUN-690026 VARCHAR(500)
           wc      STRING,                        #TQC-C40001 add
           yy,mm   LIKE type_file.num5,           #No.FUN-690026 SMALLINT
           a,b,c,d,e,f,g,h LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
           more    LIKE type_file.chr1            #No.FUN-690026 VARCHAR(1)
           END RECORD 
DEFINE g_i LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
#No.FUN-7C0007---Begin                                                          
DEFINE l_table        STRING,
       l_table1       STRING,
       g_str          STRING,                                                   
       g_sql          STRING                                                  
                                                       
#No.FUN-7C0007---End 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT   
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
#No.FUN-7C0007---Begin                                                          
   LET g_sql = "pia01.pia_file.pia01,",                                         
               "pia02.pia_file.pia02,",                                         
               "pia03.pia_file.pia03,",                                         
               "pia04.pia_file.pia04,",                                         
               "pia05.pia_file.pia05,",                                         
               "pia09.pia_file.pia09,",    
               "pia30.pia_file.pia30,", 
               "ima02.ima_file.ima02,",                                         
               "ima021.ima_file.ima021,",                                         
               "img10.img_file.img10,",
               "ima131.ima_file.ima131,",
               "diff1.pia_file.pia30,",   
               "diff2.pia_file.pia30" 
                                                        
   LET l_table = cl_prt_temptable('aimr834',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?) "      
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF  
#No.FUN-7C0007---End
 
   #TQC-610072-begin
   LET g_pdate = ARG_VAL(1)      
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
  #LET g_bgjob = 'N'
   LET g_bgjob =  ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
  #LET g_copies = 1
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
  #LET tm.d  = ARG_VAL(13)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)
   LET tm.d  = ARG_VAL(11)
   LET tm.e  = ARG_VAL(12)
   LET tm.f  = ARG_VAL(13)
   LET tm.g  = ARG_VAL(14)
   LET tm.h  = ARG_VAL(15)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   LET g_rpt_name = ARG_VAL(19)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #TQC-610072-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N' 
      THEN CALL r899_tm(0,0)        
      ELSE CALL r899()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r899_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5     #No.FUN-690026 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 11 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 3 LET p_col = 18
   ELSE
       LET p_row = 2 LET p_col = 11
   END IF
   OPEN WINDOW r899_w AT p_row,p_col
        WITH FORM "aim/42f/aimr899" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL        
   LET tm.a    = 'Y'
   LET tm.b    = 'Y'
   LET tm.c    = 'Y'
   LET tm.d    = 'N'
   LET tm.e    = '0'
   LET tm.f    = 'Y'
   LET tm.g    = 'N'
   LET tm.h    = '5'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
  #FUN-610050-begin
  #CONSTRUCT BY NAME tm.wc ON ima131,pia05,pia04,pia02,pia03,pia01
   CONSTRUCT BY NAME tm.wc ON ima131,pia02,pia01,pia03,pia05,pia04,pia931   #FUN-930121 add pia931
  #FUN-610050-end
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp                                                                                                 
            IF INFIELD(pia02) THEN                                                                                                  
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_ima"                                                                                       
               LET g_qryparam.state = "c"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO pia02                                                                                 
               NEXT FIELD pia02                                                                                                     
            END IF                                                            
#No.FUN-570240 --end  
 
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
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW r899_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
#  IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME #tm.yy,tm.mm, #No:B012
                 tm.a,tm.b,tm.c,tm.d,tm.f,tm.g,tm.e,tm.h,tm.more  
		WITHOUT DEFAULTS   
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()  
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
      LET INT_FLAG = 0 
      CLOSE WINDOW r899_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file   
             WHERE zz01='aimr899'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr899','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,     
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                        #TQC-610072-begin
                         " '",tm.e CLIPPED,"'",
                         " '",tm.f CLIPPED,"'",
                         " '",tm.g CLIPPED,"'",
                         " '",tm.h CLIPPED,"'",
                        #TQC-610072-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr899',g_time,l_cmd) 
      END IF
      CLOSE WINDOW r899_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r899()
   ERROR ""
END WHILE
   CLOSE WINDOW r899_w
END FUNCTION
 
FUNCTION r899()
DEFINE l_name    LIKE type_file.chr20    # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0074
#DEFINE l_sql     LIKE type_file.chr1000  # RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1000)
DEFINE l_sql     STRING                  #TQC-C40001
DEFINE l_za05    LIKE za_file.za05       #No.FUN-690026 VARCHAR(40)
DEFINE l_pia40   LIKE pia_file.pia40   #No.B480 add
DEFINE l_pia50   LIKE pia_file.pia50   #No.B480 add
DEFINE l_pia60   LIKE pia_file.pia60   #No.B480 add
DEFINE sr        RECORD ima131 LIKE ima_file.ima131,#No:7597
                        pia02  LIKE pia_file.pia02, #No:7597
                        ima02  LIKE ima_file.ima02, #No:7597
                        ima021 LIKE ima_file.ima021, #FUN-510017
                        pia09  LIKE pia_file.pia09, #No:7597
                        pia05  LIKE pia_file.pia05, #No:7597
                        pia03  LIKE pia_file.pia03, #No:7597
                        pia04  LIKE pia_file.pia04, #No:7597
                        pia01  LIKE pia_file.pia01, #No:7597
                        img10  LIKE img_file.img10, #No:7597  
                        pia30  LIKE pia_file.pia30, #No:7597
                        pia60  LIKE pia_file.pia60, #No:7597
                        diff1  LIKE pia_file.pia30, #MOD-530179
                        diff2  LIKE pia_file.pia30, #MOD-530179
                        ima06  LIKE ima_file.ima06, #No:7597
                        ima09  LIKE ima_file.ima09, #No:7597
                        ima10  LIKE ima_file.ima10, #No:7597
                        ima11  LIKE ima_file.ima11, #No:7597
                        ima12  LIKE ima_file.ima12  #No:7597
                        END RECORD
     CALL cl_del_data(l_table)                                  #No.FUN-7C0007
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog      #No.FUN-7C0007	
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT ima131, pia02, ima02,ima021, pia09, pia05, pia03,", #FUN-510017 add ima021
                #"       pia04, pia01, img10, pia30, pia60,0,0,", #No:B012
                 "       pia04, pia01, pia08, pia30, pia60,0,0,", #No.B012
              #  "       ima06,ima09,ima10,ima11,ima12",   #No.B480 mod
                 "       ima06,ima09,ima10,ima11,ima12,pia40,pia50",
                 "  FROM pia_file, ima_file, OUTER img_file",
                 " WHERE pia02=ima01",
                 "   AND pia_file.pia02=img_file.img01 AND pia_file.pia03=img_file.img02",
                 "   AND pia_file.pia04=img_file.img03 AND pia_file.pia05=img_file.img04",
                 "   AND ", tm.wc CLIPPED
     PREPARE r899_prepare1 FROM l_sql
     IF STATUS != 0 THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE r899_curs1 CURSOR FOR r899_prepare1
#     CALL cl_outnam('aimr899') RETURNING l_name    #No.FUN-7C0007
 
#     START REPORT r899_rep TO l_name               #No.FUN-7C0007
   # FOREACH r899_curs1 INTO sr.*    #No.B480 mod
     FOREACH r899_curs1 INTO sr.*,l_pia40,l_pia50
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#No:B012盤點量要跟 pia08(重計當時庫存)比較，而非img10 or imk09
#      IF tm.yy IS NOT NULL AND tm.mm IS NOT NULL THEN
#         SELECT imk09 INTO sr.img10 FROM imk_file
#                WHERE imk01=sr.pia02
#                  AND imk02=sr.pia03
#                  AND imk03=sr.pia04
#                  AND imk04=sr.pia05
#                  AND imk05=tm.yy
#                  AND imk06=tm.mm
#      END IF
#No:B012(end)
       IF sr.img10 IS NULL THEN LET sr.img10=0 END IF
       IF sr.pia30 IS NULL THEN LET sr.pia30=0 END IF
       #-->複盤有值先以複盤為主
       #No.B480 010510 by linda mod 順序應為複盤二,複盤一,初盤二,初盤一
      #IF not cl_null(sr.pia60) AND sr.pia60 > 0 THEN 
      #   LET sr.pia30 = sr.pia60 
      #END IF
       IF not cl_null(sr.pia60)  THEN 
          LET sr.pia30 = sr.pia60 
       ELSE
          IF NOT cl_null(l_pia50) THEN
             LET sr.pia30=l_pia50
          ELSE
             IF NOT cl_null(l_pia40) THEN
                LET sr.pia30 = l_pia40
             END IF
          END IF
       END IF
       #No.B480 end---
       CASE WHEN tm.h='0' LET sr.ima131=sr.ima06
            WHEN tm.h='1' LET sr.ima131=sr.ima09
            WHEN tm.h='2' LET sr.ima131=sr.ima10
            WHEN tm.h='3' LET sr.ima131=sr.ima11
            WHEN tm.h='4' LET sr.ima131=sr.ima12
            OTHERWISE     LET sr.ima131=sr.ima131
       END CASE
       IF tm.a='N' THEN LET sr.pia05=' ' END IF
       IF tm.b='N' THEN LET sr.pia03=' ' END IF
       IF tm.c='N' THEN LET sr.pia04=' ' END IF
       IF tm.a='N' OR tm.b='N' OR tm.c='N' THEN LET sr.pia01=' ' END IF
       IF tm.d='N' AND sr.img10=sr.pia30 THEN CONTINUE FOREACH END IF
       IF sr.img10 > sr.pia30
          THEN LET sr.diff2=sr.img10-sr.pia30 LET sr.diff1=0
          ELSE LET sr.diff1=sr.pia30-sr.img10 LET sr.diff2=0
       END IF
        EXECUTE insert_prep USING sr.pia01,sr.pia02,sr.pia03,sr.pia04,sr.pia05,
                                 sr.pia09,sr.pia30,sr.ima02,sr.ima021,sr.img10,
                                 sr.ima131,sr.diff1,sr.diff2
                            
#       OUTPUT TO REPORT r899_rep(sr.*)        #No.FUN-7C0007
     END FOREACH
#No.FUN-7C0007---Begin
#     FINISH REPORT r899_rep                   
      IF g_zz05 = 'Y' THEN                                                      
         CALL cl_wcchp(tm.wc,'ima131,pia02,pia01,pia03,pia05,pia04,pia931')   #FUN-930121 add pia931                         
              RETURNING tm.wc                                                   
      END IF                                                                    
      LET g_str=tm.wc,";",tm.e,";",tm.f,";",tm.g
                                                                          
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
   CALL cl_prt_cs3('aimr899','aimr899',l_sql,g_str) 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-7C0007---End
END FUNCTION
#No.FUN-7C0007---Begin
#REPORT r899_rep(sr)
#DEFINE l_last_sw           LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
#DEFINE tot1,tot2,tot3,tot4 LIKE img_file.img10   #MOD-530179
#DEFINE l_pia02_ima02       LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(100)
#DEFINE sr               RECORD ima131 LIKE ima_file.ima131,#No:7597
#                              pia02  LIKE pia_file.pia02, #No:7597
#                              ima02  LIKE ima_file.ima02, #No:7597
#                              ima021 LIKE ima_file.ima021,#FUN-510017
#                              pia09  LIKE pia_file.pia09, #No:7597
#                              pia05  LIKE pia_file.pia05, #No:7597
#                              pia03  LIKE pia_file.pia03, #No:7597
#                              pia04  LIKE pia_file.pia04, #No:7597
#                              pia01  LIKE pia_file.pia01, #No:7597
#                              img10  LIKE img_file.img10, #No:7597  
#                              pia30  LIKE pia_file.pia30, #No:7597
#                              pia60  LIKE pia_file.pia60, #No:7597
#                              diff1  LIKE pia_file.pia30, #MOD-530179
#                              diff2  LIKE pia_file.pia30, #MOD-530179
#                              ima06  LIKE ima_file.ima06, #No:7597
#                              ima09  LIKE ima_file.ima09, #No:7597
#                              ima10  LIKE ima_file.ima10, #No:7597
#                              ima11  LIKE ima_file.ima11, #No:7597
#                              ima12  LIKE ima_file.ima12  #No:7597
#                       END RECORD
 
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# #FUN-610050-begin
# #ORDER BY sr.ima131,sr.pia02,sr.pia05,sr.pia03,sr.pia04,sr.pia01
#  ORDER BY sr.ima131,sr.pia02,sr.pia01,sr.pia03,sr.pia05,sr.pia04
# #FUN-610050-end
 
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED 
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1] CLIPPED   #TQC-6A0088 加CLIPPED
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno" 
#     PRINT g_head CLIPPED,pageno_total     
#     PRINT 
#     PRINT g_dash
#     PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,g_x[35] CLIPPED,  #TQC-6A0088 加CLIPPED
#           g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,g_x[39] CLIPPED,g_x[40] CLIPPED,  #TQC-6A0088 加CLIPPED
#           g_x[41] CLIPPED,g_x[42] CLIPPED,g_x[43] CLIPPED                                   #TQC-6A0088 加CLIPPED
#     PRINT g_dash1 
#     LET l_last_sw = 'n'
 
#  AFTER GROUP OF sr.pia01
#     LET tot1 = GROUP SUM(sr.img10) USING '---------------&.&&&' #No.FUN-690026
#     LET tot2 = GROUP SUM(sr.pia30) USING '---------------&.&&&' #No.FUN-690026
#     LET tot3 = GROUP SUM(sr.diff1) USING '---------------&.&&&' #No.FUN-690026
#     LET tot4 = GROUP SUM(sr.diff2) USING '---------------&.&&&' #No.FUN-690026
#     IF tot3 > tot4
#        THEN LET tot3 = tot3 - tot4 LET tot4=0
#        ELSE LET tot4 = tot4 - tot3 LET tot3=0
#     END IF
####TQC-6A0088--begin 加CLIPPED
#     PRINT COLUMN g_c[31],sr.ima131 CLIPPED,  
#           COLUMN g_c[32],sr.pia02 CLIPPED,   
#           COLUMN g_c[33],sr.ima02 CLIPPED,   
#           COLUMN g_c[34],sr.ima021 CLIPPED,  
#           COLUMN g_c[35],sr.pia09 CLIPPED,   
#           COLUMN g_c[36],sr.pia05 CLIPPED,   
#           COLUMN g_c[37],sr.pia03 CLIPPED,   
#           COLUMN g_c[38],sr.pia04 CLIPPED,
#           COLUMN g_c[39],sr.pia01 CLIPPED,
#           COLUMN g_c[40],xx(tot1) CLIPPED,
#           COLUMN g_c[41],xx(tot2) CLIPPED,
#           COLUMN g_c[42],xx(tot3) CLIPPED,
#           COLUMN g_c[43],xx(tot4) CLIPPED
#     PRINT COLUMN g_c[31],sr.ima131 CLIPPED  
#     ##
####TQC-6A0088--end 加CLIPPED
#  AFTER GROUP OF sr.pia02
#     IF tm.f='Y' THEN
#     LET tot1 = GROUP SUM(sr.img10) USING '---------------&.&&&' #No.FUN-690026
#     LET tot2 = GROUP SUM(sr.pia30) USING '---------------&.&&&' #No.FUN-690026
#     LET tot3 = GROUP SUM(sr.diff1) USING '---------------&.&&&' #No.FUN-690026
#     LET tot4 = GROUP SUM(sr.diff2) USING '---------------&.&&&' #No.FUN-690026
#     IF tot3 > tot4
#        THEN LET tot3 = tot3 - tot4 LET tot4=0
#        ELSE LET tot4 = tot4 - tot3 LET tot3=0
#     END IF
#     PRINT
####TQC-6A0088--begin 加CLIPPED
#     PRINT COLUMN g_c[38],g_x[16] CLIPPED,
#           COLUMN g_c[40],xx(tot1) CLIPPED, #No:7597
#           COLUMN g_c[41],xx(tot2) CLIPPED, #No:7597
#           COLUMN g_c[42],xx(tot3) CLIPPED, #No:7597
#           COLUMN g_c[43],xx(tot4) CLIPPED #No:7597
####TQC-6A0088--end加CLIPPED
#     PRINT g_dash
#     END IF
#  AFTER GROUP OF sr.ima131
#     IF tm.g='Y' THEN
#     LET tot1 = GROUP SUM(sr.img10) USING '---------------&.&&&' #No.FUN-690026
#     LET tot2 = GROUP SUM(sr.pia30) USING '---------------&.&&&' #No.FUN-690026
#     LET tot3 = GROUP SUM(sr.diff1) USING '---------------&.&&&' #No.FUN-690026
#     LET tot4 = GROUP SUM(sr.diff2) USING '---------------&.&&&' #No.FUN-690026
#     IF tot3 > tot4
#        THEN LET tot3 = tot3 - tot4 LET tot4=0
#        ELSE LET tot4 = tot4 - tot3 LET tot3=0
#     END IF
#     IF tm.f='N' THEN PRINT END IF
####TQC-6A0088--begin 加CLIPPED
#     PRINT COLUMN g_c[38],g_x[17] CLIPPED,
#           COLUMN g_c[40],xx(tot1) CLIPPED, #No:7597
#           COLUMN g_c[41],xx(tot2) CLIPPED, #No:7597
#           COLUMN g_c[42],xx(tot3) CLIPPED, #No:7597
#           COLUMN g_c[43],xx(tot4) CLIPPED #No:7597
####TQC-6A0088--end加CLIPPED
#     PRINT g_dash
#     END IF
 
#  ON LAST ROW
#     LET l_last_sw = 'y'
#     PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash
#             PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
 
#FUNCTION xx(t)
# DEFINE t LIKE img_file.img10    #MOD-530179
# DEFINE s LIKE type_file.chr20   #No.FUN-690026 VARCHAR(17)
# CASE WHEN tm.e=3 LET s=t USING '---------------&.&&&' #No.FUN-690026
#      WHEN tm.e=2 LET s=t USING '----------------&.&&' #No.FUN-690026
#      WHEN tm.e=1 LET s=t USING '-----------------&.&' #No.FUN-690026
#      OTHERWISE   LET s=t USING '--------------------' #No.FUN-690026
# END CASE
# RETURN s
#END FUNCTION
#No.FUN-7C0007---End
