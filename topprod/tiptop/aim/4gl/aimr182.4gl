# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimr182.4gl
# Descriptions...: 料件其他分群碼查詢
# Input parameter:
# Return code....:
# Date & Author..: 91/11/05 By Wu
# Modify.........: No.FUN-510017 05/02/17 By Mandy 報表轉XML
# Modify.........: No.FUN-570240 05/07/27 By jackie 料件編號欄位加開窗查詢
# Modify.........: No.MOD-640097 06/04/09 By Carol 修改欄位說明:其他分群碼四改為成本分群碼
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.CHI-710051 07/06/07 By jamie 將ima21欄位放大至11
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#CHI-710051
 
DEFINE tm     RECORD                      # Print condition RECORD
              wc   STRING,                # Where Condition  #TQC-630166
              a    LIKE type_file.chr1,   # 依WHAT 跳頁  #No.FUN-690026 VARCHAR(1)
              more LIKE type_file.chr1    # 特殊列印條件 #No.FUN-690026 VARCHAR(1)
              END RECORD
 
DEFINE g_i    LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.a     = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL q105_tm(0,0)		# Input print condition
      ELSE CALL aimr182()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION q105_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,   #No.FUN-690026 SMALLINT
          l_cmd		LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 19
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW q105_w AT p_row,p_col
        WITH FORM "aim/42f/aimr182"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more   = 'N'
   LET tm.a      = '1'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
#  LET g_prtway  = 'Q'
   LET g_copies  = '1'
WHILE TRUE
   CONSTRUCT BY NAME  tm.wc ON ima09,ima10,ima11,ima12,ima01,ima08
        ON ACTION locale
            #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
#No.FUN-570240  --start-
     ON ACTION controlp
           IF INFIELD(ima01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ima01
              NEXT FIELD ima01
           END IF
#No.FUN-570240 --end--
   END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW q105_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM 
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more
   INPUT BY NAME tm.a,tm.more
                 WITHOUT DEFAULTS
      AFTER FIELD a
         IF tm.a IS NULL OR tm.a NOT MATCHES'[1234]'
            THEN NEXT FIELD a
         END IF
      AFTER FIELD more
         IF tm.more IS NULL OR tm.more NOT MATCHES'[yYnN]'
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      ON ACTION CONTROLP CALL q105_wc()       # Detail condition
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
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW q105_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr182'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr182','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a  CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aimr182',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW q105_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr182()
   ERROR ""
END WHILE
   CLOSE WINDOW q105_w
END FUNCTION
 
FUNCTION q105_wc()
   DEFINE l_wc LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
   OPEN WINDOW q105_w2 AT 2,2
        WITH FORM "aim/42f/aimi100"
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aimi100")
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('q')
   CONSTRUCT BY NAME l_wc ON                    # 螢幕上取條件
        ima05, ima02, ima03,
        ima13, ima14, ima15, ima70, ima06,
        ima07,
        ima16, ima37, ima38, ima51, ima52,
        ima04, ima18, ima19, ima20,
        ima21, ima22, ima34, ima42,
        ima29, imauser, imagrup,
        imamodu, imadate, imaacti
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0
   END IF
   CLOSE WINDOW q105_w2
END FUNCTION
 
FUNCTION aimr182()
   DEFINE l_name     LIKE type_file.chr20, 	# External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0074
          l_sql      STRING,    		# RDSQL STATEMENT  #TQC-630166
          l_za05     LIKE za_file.za05,         #No.FUN-690026 VARCHAR(40)
          sr         RECORD
                     order1        LIKE  ima_file.ima12, #No.FUN-690026 VARCHAR(04)
                     ima01         LIKE  ima_file.ima01, #料件編號
                     ima02         LIKE  ima_file.ima02, #品名規格
                     ima021        LIKE  ima_file.ima021,#FUN-510017
                     ima05         LIKE  ima_file.ima05, #版本
                     ima07         LIKE  ima_file.ima07, #ABC
                     ima08         LIKE  ima_file.ima08, #來源碼
                     ima09         LIKE  ima_file.ima09, #其他分群碼
                     ima10         LIKE  ima_file.ima10, #其他分群碼
                     ima11         LIKE  ima_file.ima11, #其他分群碼
                     ima12         LIKE  ima_file.ima12, #其他分群碼
                     ima37         LIKE  ima_file.ima37  #OPC
                     END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
     LET l_sql = " SELECT ' ',ima01,ima02,ima021,ima05,ima07,ima08, ", #FUN-510017
                 " ima09,ima10,ima11,ima12,ima37 ",
                 " FROM ima_file ",
                 " WHERE imaacti IN ('Y','y') ",
                 " AND ",tm.wc CLIPPED,
                 " ORDER BY 6,7,8,9 "
 
     PREPARE q105_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE q105_cs1 CURSOR FOR q105_prepare1
 
     CALL cl_outnam('aimr182') RETURNING l_name
     START REPORT q105_rep TO l_name
 
     LET g_pageno = 0
     FOREACH q105_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF sr.ima09 IS NULL THEN LET sr.ima09 = ' ' END IF
       IF sr.ima10 IS NULL THEN LET sr.ima10 = ' ' END IF
       IF sr.ima11 IS NULL THEN LET sr.ima11 = ' ' END IF
       IF sr.ima12 IS NULL THEN LET sr.ima12 = ' ' END IF
          CASE WHEN tm.a= '1' LET sr.order1 = sr.ima09
               WHEN tm.a= '2' LET sr.order1 = sr.ima10
               WHEN tm.a= '3' LET sr.order1 = sr.ima11
               WHEN tm.a= '4' LET sr.order1 = sr.ima12
               OTHERWISE LET sr.order1 = sr.ima09
          END CASE
       OUTPUT TO REPORT q105_rep(sr.*)
     END FOREACH
 
     FINISH REPORT q105_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT q105_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_azf03_1     LIKE azf_file.azf03,
          l_azf03_2     LIKE azf_file.azf03,
          l_azf03_3     LIKE azf_file.azf03,
          l_azf03_4     LIKE azf_file.azf03,
          sr         RECORD
                     order1        LIKE  ima_file.ima12, #No.FUN-690026 VARCHAR(04)
                     ima01         LIKE  ima_file.ima01, #料件編號
                     ima02         LIKE  ima_file.ima02, #品名規格
                     ima021        LIKE  ima_file.ima021,#FUN-510017
                     ima05         LIKE  ima_file.ima05, #版本
                     ima07         LIKE  ima_file.ima07, #ABC
                     ima08         LIKE  ima_file.ima08, #來源碼
                     ima09         LIKE  ima_file.ima09, #其他分群碼
                     ima10         LIKE  ima_file.ima10, #其他分群碼
                     ima11         LIKE  ima_file.ima11, #其他分群碼
                     ima12         LIKE  ima_file.ima12, #其他分群碼
                     ima37         LIKE  ima_file.ima37  #OPC
                     END RECORD
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
      ORDER BY sr.order1,sr.ima09,sr.ima10,sr.ima11,sr.ima12,sr.ima01
  FORMAT
   PAGE HEADER
      CALL q105_azf(sr.ima09,'D') RETURNING l_azf03_1  #6818
      CALL q105_azf(sr.ima10,'E') RETURNING l_azf03_2  #6818
      CALL q105_azf(sr.ima11,'F') RETURNING l_azf03_3  #6818
      CALL q105_azf(sr.ima12,'G') RETURNING l_azf03_4  #6818
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINT g_x[11] clipped,sr.ima09,column 35,g_x[12] clipped,l_azf03_1
      PRINT g_x[13] clipped,sr.ima10,column 35,g_x[12] clipped,l_azf03_2
      PRINT g_x[14] clipped,sr.ima11,column 35,g_x[12] clipped,l_azf03_3
      PRINT g_x[15] clipped,sr.ima12,column 35,g_x[12] clipped,l_azf03_4
      PRINT
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF (PAGENO > 1 OR LINENO > 8) THEN
          SKIP TO TOP OF PAGE
      END IF
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.ima02,
            COLUMN g_c[32],sr.ima021,
            COLUMN g_c[33],sr.ima01,
            COLUMN g_c[34],sr.ima05,
            COLUMN g_c[35],sr.ima08,
            COLUMN g_c[36],sr.ima07,
            COLUMN g_c[37],sr.ima37
 
   AFTER GROUP OF sr.order1
#     LET g_pageno = 0
 
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash
        #TQC-630166
        #      IF tm.wc[001,070] > ' ' THEN			# for 80
        # 	 PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
        #      IF tm.wc[071,140] > ' ' THEN
  	#         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
        #      IF tm.wc[141,210] > ' ' THEN
        #	 PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
        #      IF tm.wc[211,280] > ' ' THEN
        # 	 PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
        CALL cl_prt_pos_wc(tm.wc)
        #END TQC-630166
 
      END IF
      PRINT g_dash
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
FUNCTION q105_azf(p_key,p_type)   #6818,增p_type
   DEFINE p_key    LIKE azf_file.azf01,
          p_type   LIKE azf_file.azf02,
          p_azf03  LIKE azf_file.azf03
 
    SELECT azf03 INTO  p_azf03
           FROM azf_file WHERE azf01 = p_key AND azf02 = p_type
    RETURN p_azf03
END FUNCTION
