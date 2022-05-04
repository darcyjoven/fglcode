# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aimr850.4gl
# Descriptions...: 初�複盤差異分析表－現有庫存
# Date & Author..: 93/06/04 By Apple
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Midify.........: NO.MOD-580222 05/08/25 By Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.FUN-590110 05/09/23 By vivien 報表轉XML
# Modify.........: No.FUN-5A0059 05/11/02 By Sarah 補印ima021
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/07 By baogui 無列印順序
# Modify.........: No.TQC-6C0222 06/12/29 By Ray 第一頁跳頁錯誤
# Modify.........: No.FUN-840055 08/04/30 By lutingting報表轉為使用CR
# Modify.........: No.FUN-930122 09/04/09 By xiaofeizhu 新增欄位底稿類別
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A40023 10/04/12 By vealxu ima26x調整
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD			# Print condition RECORD
           wc   STRING,                 # Where Condition  #TQC-630166
           c    LIKE type_file.chr1,    # 資料選擇  #No.FUN-690026 VARCHAR(1)
           b    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           d    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           s    LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(03)
           t    LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(03)
           more LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
           END RECORD
DEFINE g_i LIKE type_file.num5,        #count/index for any purpose  #No.FUN-690026 SMALLINT
       l_orderA      ARRAY[3] OF LIKE imm_file.imm13   #No.TQC-6A0088 
DEFINE    g_sql       STRING            #No.FUN-840055
DEFINE    g_str       STRING            #No.FUN-840055
DEFINE    l_table     STRING            #No.FUN-840055
MAIN
#     DEFINE    l_time   LIKE type_file.chr8       #No.FUN-6A0074
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
 
  #No.FUN-840055------start--
#FUN-A40023 ---mark----start
#   LET g_sql = "pia04.pia_file.pia04,",
#               "pia01.pia_file.pia01,",
#               "pia02.pia_file.pia02,",
#               "ima05.ima_file.ima05,",
#               "ima08.ima_file.ima08,",
#               "ima07.ima_file.ima07,",
#               "ima06.ima_file.ima06,",
#               "pia09.pia_file.pia09,",
#               "pia08.pia_file.pia08,",
#               "stk1.pia_file.pia08,",
#               "stk2.pia_file.pia08,",
#               "l_diff1.ima_file.ima262,",
#               "l_diff2.ima_file.ima262,",
#               "pia05.pia_file.pia05,",
#               "ima02.ima_file.ima02,",
#               "ima021.ima_file.ima021,", 
#               "pia03.pia_file.pia03" 
#FUN-A40023 ---mark--end
   LET g_sql = "pia04.pia_file.pia04,",
               "pia01.pia_file.pia01,",
               "pia02.pia_file.pia02,",
               "ima05.ima_file.ima05,",
               "ima08.ima_file.ima08,",
               "ima07.ima_file.ima07,",
               "ima06.ima_file.ima06,",
               "pia09.pia_file.pia09,",
               "pia08.pia_file.pia08,",
               "stk1.pia_file.pia08,",
               "stk2.pia_file.pia08,",
               "l_diff1.type_file.num15_3,",
               "l_diff2.type_file.num15_3,",
               "pia05.pia_file.pia05,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "pia03.pia_file.pia03"
   LET l_table = cl_prt_temptable('aimr850',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM 
   END IF                         
   #No.FUN-840055------end
 
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.c     = ARG_VAL(8)
   LET tm.b     = ARG_VAL(9)
   LET tm.d     = ARG_VAL(10)
   LET tm.s     = ARG_VAL(11)
   LET tm.t     = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
   THEN CALL r850_tm(0,0)    	       	# Input print condition
   ELSE
#No.FUN-590110 --start
#     IF g_sma.sma12 = 'N' THEN         # 單倉處理
         CALL r850_1()		
#     ELSE
#        CALL r850_2()                  # 多倉處理
#     END IF
#No.FUN-590110 --end
   END IF
 
 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r850_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_cmd		LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(1000)
	  l_direct      LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 10 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 18
   ELSE
       LET p_row = 3 LET p_col = 10
   END IF
 
   OPEN WINDOW r850_w AT p_row,p_col
        WITH FORM "aim/42f/aimr850"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.c      = '1'
   LET tm.b      = 'N'
   LET tm.d      = 'N'
   IF g_sma.sma12 = 'Y' THEN
        LET tm.s      = '123'
   ELSE LET tm.s      = '126'
   END IF
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
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
   IF g_sma.sma12 = 'N' THEN
      CONSTRUCT BY NAME tm.wc ON pia01,pia02,ima08,pia931               #FUN-930122 Add pia931
 
#No.FUN-570240 --start
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
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   ELSE
      CONSTRUCT BY NAME tm.wc ON pia01,pia02,pia03,pia04,pia05,ima08,pia931         #FUN-930122 Add pia931
 
#No.FUN-570240 --start
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
 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   END IF
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r850_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM 
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
 
#UI
   INPUT BY NAME tm.c,tm.b,tm.d,
                 #UI
                 tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,
                 tm.more
                 WITHOUT DEFAULTS
 
     AFTER FIELD c
         IF tm.c IS NULL OR tm.c = ' ' OR tm.c NOT MATCHES'[12]'
			THEN NEXT FIELD c
		 END IF
 
     AFTER FIELD b
         IF tm.b IS NULL OR tm.b NOT MATCHES'[YN]'
         THEN NEXT FIELD b
         END IF
 
     AFTER FIELD d
         IF tm.d IS NULL OR tm.d NOT MATCHES'[YN]'
         THEN NEXT FIELD d
         END IF
 
      AFTER FIELD more
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
      #UI
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
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r850_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr850'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr850','9031',1)
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
                         " '",tm.c CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aimr850',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r850_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
#No.FUN-590110 --start
#  IF g_sma.sma12 = 'N' THEN         # Read data and create out-file
      CALL r850_1()		        # 單倉儲管理	
#  ELSE
#     CALL r850_2()                      # 多倉儲管理
#  END IF
#No.FUN-590110 --end
   ERROR ""
END WHILE
CLOSE WINDOW r850_w
END FUNCTION
 
 
FUNCTION r850_1()
   DEFINE l_name     LIKE type_file.chr20,            # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0074
          l_sql      STRING,                          # RDSQL STATEMENT     #TQC-630166
          l_za05     LIKE za_file.za05,               #No.FUN-690026 VARCHAR(40)
          l_order    ARRAY[3] OF LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
          sr         RECORD
                     order1   LIKE  ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     order2   LIKE  ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     order3   LIKE  ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     pia01    LIKE  pia_file.pia01, #標籤號碼
                     pia02    LIKE  pia_file.pia02, #料件編號
                     pia03    LIKE  pia_file.pia03, #倉庫別
                     pia04    LIKE  pia_file.pia04, #存放位置
                     pia05    LIKE  pia_file.pia05, #批號
                     pia09    LIKE  pia_file.pia09, #庫存單位
                     pia16    LIKE  pia_file.pia16, #空白標籤否
                     pia30    LIKE  pia_file.pia30, #初盤數量(一)
                     pia40    LIKE  pia_file.pia40, #初盤數量(二)
                     pia50    LIKE  pia_file.pia50, #複盤數量(一)
                     pia60    LIKE  pia_file.pia60, #複盤數量(二)
                     pia08    LIKE  pia_file.pia08, #應盤數量
                     stk1     LIKE  pia_file.pia08,
                     stk2     LIKE  pia_file.pia08,
                     ima02    LIKE  ima_file.ima02, #品名
                     ima021   LIKE  ima_file.ima021,#規格   #FUN-5A0059
                     ima05    LIKE  ima_file.ima05, #版本
                     ima06    LIKE  ima_file.ima06, #分群碼
                     ima07    LIKE  ima_file.ima07, #ABC 碼
                     ima08    LIKE  ima_file.ima08  #來源
                     END RECORD
     #No.FUN-840055-----start--
#    DEFINE          l_diff1    LIKE ima_file.ima262   #FUN-A40023
#    DEFINE          l_diff2    LIKE ima_file.ima262   #FUN-A40023
     DEFINE          l_diff1    LIKE type_file.num15_3 #FUN-A40023  
     DEFINE          l_diff2    LIKE type_file.num15_3 #FUN-A40023
     
     CALL cl_del_data(l_table)
     
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aimr850'
     #No.FUN-840055-----end
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = " SELECT  '','','',",
                 " pia01,pia02,pia03,pia04,pia05,",
                 " pia09,pia16,pia30,pia40,pia50,",
                 " pia60,pia08,'','',",
                #" ima02,ima05,ima06,ima07,ima08",          #FUN-5A0059 mark
                 " ima02,ima021,ima05,ima06,ima07,ima08",   #FUN-5A0059
                 " FROM pia_file,ima_file",
                 " WHERE pia02 = ima01 AND ",
                 " pia02 IS NOT NULL AND ",tm.wc CLIPPED
 
     #--->不包含初/複相同者
     IF tm.d = 'N'
     THEN  IF tm.c = '1'
           THEN LET l_sql = l_sql clipped,
                            " AND ((pia30 != pia50 )",
                            "  OR pia30 IS NULL OR pia50 IS NULL)"
           ELSE LET l_sql = l_sql clipped,
                            " AND ((pia40 != pia60 )",
                            "  OR pia40 IS NULL OR pia60 IS NULL)"
           END IF
     END IF
 
     #--->不包含未做盤點者
     IF tm.b = 'N'
     THEN  IF tm.c = '1'
           THEN LET l_sql = l_sql clipped,
                            " AND (pia30 IS NOT NULL OR pia50 IS NOT NULL) "
           ELSE LET l_sql = l_sql clipped,
                            " AND (pia40 IS NOT NULL OR pia60 IS NOT NULL) "
           END IF
     END IF
     PREPARE r850_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r850_c1 CURSOR FOR r850_prepare1 
     #CALL cl_outnam('aimr850') RETURNING l_name   #No.FUN-840055
 
#No.FUN-590110 --start
      IF g_sma.sma12 = 'N' THEN         # 單倉處理
         #No.FUN-840055----start--
         #LET g_zaa[31].zaa06 = "Y"
         #LET g_zaa[32].zaa06 = "Y"
         #LET g_zaa[45].zaa06 = "Y"
         #LET g_zaa[46].zaa06 = "Y"
         LET l_name = 'aimr850'
      ELSE
         #LET g_zaa[31].zaa06 = "N"
         #LET g_zaa[32].zaa06 = "N"
         #LET g_zaa[45].zaa06 = "N"
         #LET g_zaa[46].zaa06 = "N"
         LET l_name = 'aimr850_1'
         #No.FUN-840055----end         
      END IF
      CALL cl_prt_pos_len()
#No.FUN-590110 --end
     #START REPORT r850_rep1 TO l_name   #No.FUN-840055
 
     LET g_pageno = 0
     FOREACH r850_c1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
	   IF sr.pia01 IS NULL THEN LET sr.pia01 = ' ' END IF
	   IF sr.pia02 IS NULL THEN LET sr.pia02 = ' ' END IF
	   IF sr.pia03 IS NULL THEN LET sr.pia03 = ' ' END IF
	   IF sr.pia04 IS NULL THEN LET sr.pia04 = ' ' END IF
	   IF sr.pia05 IS NULL THEN LET sr.pia05 = ' ' END IF
    #No.FUN-840055----start--
    #   FOR g_i = 1 TO 3
		#CASE
		#	WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.pia01 
    #                                             LET l_orderA[g_i] =g_x[51]    #TQC-6A0088 
		#	WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.pia02
    #                                             LET l_orderA[g_i] =g_x[52]    #TQC-6A0088 
		#	WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.pia03
    #                                             LET l_orderA[g_i] =g_x[53]    #TQC-6A0088 
		#	WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.pia04
    #                                             LET l_orderA[g_i] =g_x[54]    #TQC-6A0088 
		#	WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.pia05
    #                                             LET l_orderA[g_i] =g_x[55]    #TQC-6A0088 
		#	WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.ima08
    #                                             LET l_orderA[g_i] =g_x[56]    #TQC-6A0088 
		#    OTHERWISE LET l_order[g_i] = '-'
    #                                             LET l_orderA[g_i] =''    #TQC-6A0088 
    #  	END CASE
    #   END FOR
    #   LET sr.order1 = l_order[1]
    #   LET sr.order2 = l_order[2]
    #   LET sr.order3 = l_order[3]
    #No.FUN-840055----end    
       IF tm.c = '1' THEN
            LET sr.stk1 = sr.pia30
            LET sr.stk2 = sr.pia50
       ELSE LET sr.stk1 = sr.pia40
            LET sr.stk2 = sr.pia60
       END IF
       #No.FUN-840055------start--
        #---->初/複盤差異量
        LET l_diff1 = sr.stk1  - sr.stk2
       
        #---->盤盈虧量
        IF sr.stk2  IS NOT NULL AND sr.stk2 !=' ' THEN
             LET l_diff2 = sr.stk2  - sr.pia08
        ELSE LET l_diff2 = sr.stk1  - sr.pia08
        END IF       
        #OUTPUT TO REPORT r850_rep1(sr.*)
        EXECUTE insert_prep USING
            sr.pia04,sr.pia01,sr.pia02,sr.ima05,sr.ima08,sr.ima07,sr.ima06,
            sr.pia09,sr.pia08,sr.stk1,sr.stk2,l_diff1,l_diff2,sr.pia05,sr.ima02,
            sr.ima021,sr.pia03
      #No.FUN-840055------end       
     END FOREACH
 
     #No.FUN-840055-----start--
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'pia01,pia02,pia03,pia04,pia05,ima08,pia931')             #FUN-930122 Add pia931
        RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                 tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.c,";",tm.b,";",tm.d
                 
     CALL cl_prt_cs3('aimr850',l_name,g_sql,g_str)            
     #FINISH REPORT r850_rep1
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #No.FUN-840055-----end
END FUNCTION
 
#No.FUN-840055-----start--
#REPORT r850_rep1(sr)
#   DEFINE l_last_sw  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#	  l_diff1    LIKE ima_file.ima262,
#	  l_diff2    LIKE ima_file.ima262,
#          l_tmp      LIKE type_file.chr20,   #FUN-5A0059 #No.FUN-690026 VARCHAR(11)
#          sr         RECORD
#                     order1   LIKE  ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                     order2   LIKE  ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                     order3   LIKE  ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                     pia01    LIKE  pia_file.pia01, #標籤號碼
#                     pia02    LIKE  pia_file.pia02, #料件編號
#                     pia03    LIKE  pia_file.pia03, #倉庫別
#                     pia04    LIKE  pia_file.pia04, #存放位置
#                     pia05    LIKE  pia_file.pia05, #批號
#                     pia09    LIKE  pia_file.pia09, #庫存單位
#                     pia16    LIKE  pia_file.pia16, #空白標籤否
#                     pia30    LIKE  pia_file.pia30, #初盤數量(一)
#                     pia40    LIKE  pia_file.pia40, #初盤數量(二)
#                     pia50    LIKE  pia_file.pia50, #複盤數量(一)
#                     pia60    LIKE  pia_file.pia60, #複盤數量(二)
#                     pia08    LIKE  pia_file.pia08, #應盤數量
#                     stk1     LIKE  pia_file.pia08,
#                     stk2     LIKE  pia_file.pia08,
#                     ima02    LIKE  ima_file.ima02, #品名
#                     ima021   LIKE  ima_file.ima021,#規格   #FUN-5A0059
#                     ima05    LIKE  ima_file.ima05, #版本
#                     ima06    LIKE  ima_file.ima06, #分群碼
#                     ima07    LIKE  ima_file.ima07, #ABC 碼
#                     ima08    LIKE  ima_file.ima08  #來源
#                     END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#      ORDER BY sr.order1,sr.order2,sr.order3,sr.pia01
#  FORMAT
#   PAGE HEADER
##No.FUN-590110 --start
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#     #PRINT                          #TQC-6A0088
#      PRINT g_x[9] CLIPPED,l_orderA[1] CLIPPED,                      #TQC-6A0088                                                    
#                       '-',l_orderA[2] CLIPPED,'-',l_orderA[3] CLIPPED
#      PRINT g_dash[1,g_len]
#      PRINTX name=H1
#        #   g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],    #TQC-6A0088
#            g_x[32],g_x[33],g_x[34],g_x[57],g_x[35],    #TQC-6A0088 
#            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#            g_x[41],g_x[42],g_x[43],g_x[44]
#      PRINTX name=H2
#           #g_x[45],g_x[46],g_x[47],g_x[48]           #FUN-5A0059 mark
#            g_x[46],g_x[47],g_x[48],g_x[49]   #FUN-5A0059
#      PRINT g_dash1
#      LET l_last_sw = 'n'
##No.FUN-590110 --end
#
#   BEFORE GROUP OF sr.order1
##     IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 10)     #No.TQC-6C0222
#      IF tm.t[1,1] = 'Y' AND (PAGENO > 0 OR LINENO > 10)     #No.TQC-6C0222
#         THEN SKIP TO TOP OF PAGE
#      END IF
# 
#   BEFORE GROUP OF sr.order2
##     IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 10)     #No.TQC-6C0222
#      IF tm.t[2,2] = 'Y' AND (PAGENO > 0 OR LINENO > 10)     #No.TQC-6C0222
#         THEN SKIP TO TOP OF PAGE
#      END IF
# 
#   BEFORE GROUP OF sr.order3
##     IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 10)     #No.TQC-6C0222
#      IF tm.t[3,3] = 'Y' AND (PAGENO > 0 OR LINENO > 10)     #No.TQC-6C0222
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
##No.FUN-590110 --start
#   ON EVERY ROW
#      #---->初/複盤差異量
#      LET l_diff1 = sr.stk1  - sr.stk2
#
#      #---->盤盈虧量
#      IF sr.stk2  IS NOT NULL AND sr.stk2 !=' ' THEN
#           LET l_diff2 = sr.stk2  - sr.pia08
#      ELSE LET l_diff2 = sr.stk1  - sr.pia08
#      END IF
#     #start FUN-5A0059
#     #IF sr.pia16 ='Y' THEN PRINT '*';  END IF
#      IF sr.pia16 ='Y' THEN
#         LET l_tmp = '*',sr.pia03
#      ELSE
#         LET l_tmp = sr.pia03
#      END IF
#     #end FUN-5A0059
#      PRINTX name=D1
#           #COLUMN g_c[31],sr.pia03 CLIPPED,   #FUN-5A0059 mark
#           #COLUMN g_c[31],l_tmp CLIPPED,      #FUN-5A0059    #TQC-6A0088 mark
#            COLUMN g_c[32],sr.pia04 CLIPPED,
#            COLUMN g_c[33],sr.pia01 CLIPPED,
#            COLUMN g_c[34],sr.pia02 CLIPPED,
#            COLUMN g_c[35],sr.ima05 CLIPPED,
#	    COLUMN g_c[36],sr.ima08 CLIPPED,
#            COLUMN g_c[37],sr.ima07 CLIPPED,
#            COLUMN g_c[38],sr.ima06 CLIPPED,
#            COLUMN g_c[39],sr.pia09 CLIPPED,
#            COLUMN g_c[40],sr.pia08 using '----------&.&&&',
#            COLUMN g_c[41],sr.stk1  using '----------&.&&&',
#            COLUMN g_c[42],sr.stk2  using '----------&.&&&',
#            COLUMN g_c[43],l_diff1  using '----------&.&&&',
#            COLUMN g_c[44],l_diff2  using '----------&.&&&'
#      PRINTX name=D2
#            COLUMN g_c[46],sr.pia05 CLIPPED,
#            COLUMN g_c[48],sr.ima02 CLIPPED
##No.FUN-590110 --end
#           ,COLUMN g_c[49],sr.ima021 CLIPPED   #FUN-5A0059
#
#   ON LAST ROW
#      PRINT g_x[22] clipped
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#        CALL cl_wcchp(tm.wc,'pia01,pia02,pia03,pia04,pia05')
#             RETURNING tm.wc
#        PRINT g_dash[1,g_len]
##TQC-630166
##       IF tm.wc[001,080] > ' ' THEN
##       	       PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
##       IF tm.wc[071,140] > ' ' THEN
##       	       PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
##       IF tm.wc[141,210] > ' ' THEN
##       	       PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#         CALL cl_prt_pos_wc(tm.wc)
#      END IF
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_x[22] clipped
#              PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 3 LINE
#      END IF
#END REPORT
#No.FUN-840055-----end
#Patch....NO.TQC-610036 <> #
