# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aimr101.4gl
# Desc/riptions...: 料件庫存資料列印表
# Input parameter:
# Return code....:
# Date & Author..: 92/03/19 By Jones
# Modify ........: 92/05/25 By David
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-5A0047 05/10/14 By Sarah 品名規格(ima02)放大到60碼
# Modify.........: No.TQC-5B0059 05/11/08 By Sarah 調整報表出表欄位的位置,對齊
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610072 06/03/07 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-770006 07/07/31 By zhoufeng 報表產出改為Crystal Report
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/24 By vealxu ima26x 調整
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
		wc  	STRING,    		# Where condition  #TQC-630166
   		s    	LIKE type_file.chr3,  	# Order by sequence  #No.FUN-690026 VARCHAR(3)
   		y    	LIKE type_file.chr1,  	# group code choice  #No.FUN-690026 VARCHAR(1)
   		more	LIKE type_file.chr1   	# Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
              END RECORD,
         g_aza17        LIKE aza_file.aza17     # 本國幣別
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE   g_str          STRING                  #No.FUN-770006
DEFINE   g_sql          STRING                  #No.FUN-A20044 
DEFINE   l_table        STRING                  #No.FUN-A20044
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
#No.FUN-A20044 --start---
   LET g_sql = "order1.ima_file.ima01,",
               "order2.ima_file.ima01,",
               "order3.ima_file.ima01,",
               "l_sta.type_file.chr20,",
               "ima01.ima_file.ima01,",
               "ima05.ima_file.ima05,",
               "ima06.ima_file.ima06,",
               "ima09.ima_file.ima09,",
               "ima10.ima_file.ima10,",
               "ima11.ima_file.ima11,",
               "ima12.ima_file.ima12,",
               "ima08.ima_file.ima08,",
               "ima02.ima_file.ima02,",
               "ima03.ima_file.ima03,",
               "ima07.ima_file.ima07,",
               "ima15.ima_file.ima15,",
               "ima70.ima_file.ima70,",
               "ima25.ima_file.ima25,",
               "ima71.ima_file.ima71,",
               "avl_stk_mpsmrp.type_file.num15_3,",   
               "ima271.ima_file.ima271,",
               "avl_stk.type_file.num15_3,",       
               "ima27.ima_file.ima27,",
               "ima28.ima_file.ima28,",
               "unavl_stk.type_file.num15_3,",      
               "ima29.ima_file.ima29,",
               "ima23.ima_file.ima23,",
               "gen02.gen_file.gen02,",
               "ima30.ima_file.ima30,",
               "ima35.ima_file.ima35,",
               "ima73.ima_file.ima73,",
               "ima36.ima_file.ima36,",
               "ima74.ima_file.ima74,",
               "ima63.ima_file.ima63,",
               "ima64.ima_file.ima64,",
               "ima63_fac.ima_file.ima63_fac,",
               "ima641.ima_file.ima641 "
   LET l_table  = cl_prt_temptable('aimr101',g_sql) CLIPPED
   LET g_sql = " INSERT INTO ",g_cr_db_str CLIPPED, l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                       "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,? )"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM
   END IF
#No.FUN-A20044 ---end ---                
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.y  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r111_tm(0,0)		# Input print condition
      ELSE CALL aimr101()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r111_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,   #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 14 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 2 LET p_col = 17
   ELSE
       LET p_row = 3 LET p_col = 14
   END IF
 
   OPEN WINDOW r111_w AT p_row,p_col
        WITH FORM "aim/42f/aimr101"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s    = '123'
   LET tm.y    = '0'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm2.s1  = '1'
   LET tm2.s2  = '2'
   LET tm2.s3  = '3'
WHILE TRUE
   DISPLAY BY NAME tm.s,tm.y,tm.more # Condition
   CONSTRUCT BY NAME tm.wc ON ima01,ima05,ima06,ima09,ima10,
							  ima11,ima12,ima08
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp
            IF INFIELD(ima01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r111_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.s,tm.y,tm.more # Condition
#UI
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm.y,tm.more
                WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD y
         IF tm.y NOT MATCHES "[0-4]" OR tm.y IS NULL
            THEN NEXT FIELD y
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
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
  #   ON ACTION CONTROLP CALL r111_wc()       # Input detail Where Condition
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
      LET INT_FLAG = 0 CLOSE WINDOW r111_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr101'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr101','9031',1)
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
                         " '",tm.s CLIPPED,"'",
                         " '",tm.y CLIPPED,"'",                 #TQC-610072
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr101',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r111_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr101()
   ERROR ""
END WHILE
   CLOSE WINDOW r111_w
END FUNCTION
FUNCTION aimr101()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0074
          l_sql 	STRING,                		# RDSQL STATEMENT  #TQC-630166
          l_za05	LIKE za_file.za05,              #No.FUN-690026 VARCHAR(40)
          l_sta         LIKE type_file.chr20,           #No.FUN-690026 VARCHAR(20)
          l_order	ARRAY[3] OF LIKE ima_file.ima01,#FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
          sr            RECORD
                         order1 LIKE ima_file.ima01,  #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                         order2 LIKE ima_file.ima01,  #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                         order3 LIKE ima_file.ima01,  #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                         l_sta  LIKE type_file.chr20, #No.FUN-690026 VARCHAR(20)
                         ima01  LIKE ima_file.ima01,
                         ima05  LIKE ima_file.ima05,
			 ima06  LIKE ima_file.ima06,
			 ima09  LIKE ima_file.ima09,
			 ima10  LIKE ima_file.ima10,
			 ima11  LIKE ima_file.ima11,
			 ima12  LIKE ima_file.ima12,
                         ima08  LIKE ima_file.ima08,
                         ima02  LIKE ima_file.ima02,
                         ima03  LIKE ima_file.ima03,
			 ima07  LIKE ima_file.ima07,
                         ima15  LIKE ima_file.ima15,
			 ima70  LIKE ima_file.ima70,
			 ima25  LIKE ima_file.ima25,
			 ima71  LIKE ima_file.ima71,
#         		 ima26  LIKE ima_file.ima26,              #FUN-A20044
                         avl_stk_mpsmrp LIKE type_file.num15_3,   #FUN-A20044
			 ima271 LIKE ima_file.ima271,
#        		 ima262 LIKE ima_file.ima262,             #FUN-A20044
                         avl_stk  LIKE type_file.num15_3,         #FUN-A20044
			 ima27  LIKE ima_file.ima27,
			 ima28  LIKE ima_file.ima28,
#        		 ima261 LIKE ima_file.ima261,             #FUN-A20044
                         unavl_stk  LIKE type_file.num15_3,       #FUN-A20044
			 ima29  LIKE ima_file.ima29,
			 ima23  LIKE ima_file.ima23,
			 gen02  LIKE gen_file.gen02,
			 ima30  LIKE ima_file.ima30,
			 ima35  LIKE ima_file.ima35,
			 ima73  LIKE ima_file.ima73,
			 ima36  LIKE ima_file.ima36,
			 ima74  LIKE ima_file.ima74,
			 ima63  LIKE ima_file.ima63,
			 ima64  LIKE ima_file.ima64,
			 ima63_fac LIKE ima_file.ima63_fac,
			 ima641 LIKE ima_file.ima641
                        END RECORD
   DEFINE l_chr LIKE type_file.chr1000                      #No.FUN-770006
   DEFINE l_avl_stk_mpsmrp  LIKE type_file.num15_3,         #No.FUN-A20044
          l_unavl_stk       LIKE type_file.num15_3,         #No.FUN-A20044
          l_avl_stk         LIKE type_file.num15_3          #No.FUN-A20044    
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aimr101'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND imagrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
#     LET l_sql = "SELECT  ' ',' ',' ',' ',",                 #No.FUN-770006
      LET l_sql ="SELECT  ' ',' ',' ',' ', ",                                  #No.FUN-770006   #FUN-A20044 
                 " ima01,ima05,ima06,ima09,ima10,ima11, ",
                 " ima12, ima08,ima02,ima03,ima07, ",
#                " ima15,ima70,ima25,ima71,ima26,ima271, ",        #FUN-A20044
#                " ima262,ima27,ima28,ima261,ima29,ima23, ",       #FUN-A20044
                 " ima15,ima70,ima25,ima71,' ',ima271, ",          #FUN-A20044
                 " ' ',ima27,ima28,' ',ima29,ima23, ",             #FUN-A20044
                 " gen02,ima30,ima35,ima73,ima36,ima74,ima63, ",
                 " ima64,ima63_fac,ima641 ",
                 " FROM ima_file LEFT OUTER JOIN gen_file ", 
                 "   ON ima23 = gen01",
                 " WHERE ",
                    tm.wc CLIPPED   ,
                 " ORDER BY ima01 "

#No.FUN-A20044 ---start---
    PREPARE r101_prepare1 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1)  END IF 
    DECLARE r101_cs1 CURSOR FOR r101_prepare1
    FOREACH r101_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF 
       CALL s_getstock(sr.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk
       LET sr.avl_stk_mpsmrp = l_avl_stk_mpsmrp
       LET sr.unavl_stk = l_unavl_stk
       LET sr.avl_stk = l_avl_stk  
       EXECUTE insert_prep USING sr.*
    END FOREACH
#No.FUN-A20044 ---end----

#No.FUN-770006 --start-- mark
#     PREPARE r111_prepare1 FROM l_sql
#     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
#        EXIT PROGRAM 
#     END IF
#     DECLARE r111_cs1 CURSOR FOR r111_prepare1
#     CALL cl_outnam('aimr101') RETURNING l_name
#     START REPORT r111_rep TO l_name
#
#     LET g_pageno = 0
#     FOREACH r111_cs1 INTO sr.*
#       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
#	#  CALL s_opc(sr.ima37) RETURNING l_sta
#       IF sr.ima01 IS NULL THEN LET sr.ima01 = ' ' END IF
#       IF sr.ima05 IS NULL THEN LET sr.ima05 = ' ' END IF
#       IF sr.ima06 IS NULL THEN LET sr.ima06 = ' ' END IF
#       IF sr.ima08 IS NULL THEN LET sr.ima08 = ' ' END IF
#       IF sr.ima23 IS NULL THEN LET sr.ima23 = ' ' END IF
#       FOR g_i = 1 TO 3
#          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima01
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima05
#               WHEN tm.s[g_i,g_i] = '3'
#                   CASE
#					 WHEN tm.y ='0' LET l_order[g_i] = sr.ima06
#					 WHEN tm.y ='1' LET l_order[g_i] = sr.ima09
#					 WHEN tm.y ='2' LET l_order[g_i] = sr.ima10
#					 WHEN tm.y ='3' LET l_order[g_i] = sr.ima11
#					 WHEN tm.y ='4' LET l_order[g_i] = sr.ima12
#                   END CASE
#               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.ima08
#               OTHERWISE LET l_order[g_i] = '-'
#          END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#   #   LET sr.l_sta  = l_sta
#       OUTPUT TO REPORT r111_rep(sr.*)
#     END FOREACH
 
#     FINISH REPORT r111_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-770006 --end--

      LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  #No.FUN-A20044

#No.FUN-770006 --start--
      SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
      IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'ima01,ima05,ima06,ima09,ima10,ima11,ima12,ima08')
              RETURNING tm.wc
         LET g_str = tm.wc
      END IF
      IF g_towhom IS NULL OR g_towhom = ' ' THEN                  
         LET l_chr = ' '                                                         
      ELSE LET l_chr = 'TO:',g_towhom         
      END IF
      LET g_str = g_str,";",l_chr,";",tm.s[1,1],";",tm.s[2,2],";",
                  tm.s[3,3],";",tm.y
#     CALL cl_prt_cs1('aimr101','aimr101',l_sql,g_str)   #FUN-A20044
      CALL cl_prt_cs3('aimr101','aimr101',g_sql,g_str)   #FUN-A20044
#No.FUN-770006 --end--
END FUNCTION

#No.FUN-770006 --start-- mark
{REPORT r111_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_sw          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#         l_amt         LIKE ima_file.ima26,    #amount Of Q.O.H minus MPS/MRP Available  #FUN-A20044
                                                # Iventory.
          l_amt         LIKE type_file.num15_3,    #FUN-A20044
          sr            RECORD
                         order1 LIKE ima_file.ima01,  #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                         order2 LIKE ima_file.ima01,  #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                         order3 LIKE ima_file.ima01,  #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                         l_sta  LIKE type_file.chr20, #No.FUN-690026 VARCHAR(20)
                         ima01  LIKE ima_file.ima01,
                         ima05  LIKE ima_file.ima05,
			 ima06  LIKE ima_file.ima06,
			 ima09  LIKE ima_file.ima09,
			 ima10  LIKE ima_file.ima10,
			 ima11  LIKE ima_file.ima11,
			 ima12  LIKE ima_file.ima12,
                         ima08  LIKE ima_file.ima08,
                         ima02  LIKE ima_file.ima02,
                         ima03  LIKE ima_file.ima03,
			 ima07  LIKE ima_file.ima07,
                         ima15  LIKE ima_file.ima15,
			 ima70  LIKE ima_file.ima70,
			 ima25  LIKE ima_file.ima25,
			 ima71  LIKE ima_file.ima71,
#			 ima26  LIKE ima_file.ima26,            #FUN-A20044
                         avl_stk_mpsmrp LIKE type_file.num15_3, #FUN-A20044
			 ima271 LIKE ima_file.ima271,
#			 ima262 LIKE ima_file.ima262,           #FUN-A20044
                         avl_stk  LIKE type_file.num15_3,       #FUN-A20044
			 ima27  LIKE ima_file.ima27,
			 ima28  LIKE ima_file.ima28,
#			 ima261 LIKE ima_file.ima261,           #FUN-A20044
                         unavl_stk LIKE type_file.num15_3,      #FUN-A20044
			 ima29  LIKE ima_file.ima29,
			 ima23  LIKE ima_file.ima23,
                         gen02  LIKE gen_file.gen02,
			 ima30  LIKE ima_file.ima30,
			 ima35  LIKE ima_file.ima35,
			 ima73  LIKE ima_file.ima73,
			 ima36  LIKE ima_file.ima36,
			 ima74  LIKE ima_file.ima74,
			 ima63  LIKE ima_file.ima63,
			 ima64  LIKE ima_file.ima64,
			 ima63_fac LIKE ima_file.ima63_fac,
			 ima641 LIKE ima_file.ima641
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.ima01,sr.order1,sr.order2,sr.order3
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      PRINT ' '
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_today,'  ',TIME,' ',
            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT g_dash[1,g_len]
 
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.order2
      IF (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.order3
      IF (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.ima01
      IF (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
#	  LET l_amt = sr.ima262 - sr.ima26             #FUN-A20044
          LET l_amt = sr.avl_stk - sr.avl_stk_mpsmrp   #FUN-A20044
 
   ON EVERY ROW
      PRINT COLUMN  2,g_x[11] CLIPPED,sr.ima01,
            COLUMN 45,g_x[13] CLIPPED,sr.ima05,
            COLUMN 64,g_x[14] CLIPPED,sr.ima08 CLIPPED
      PRINT COLUMN  2,g_x[15] CLIPPED,sr.ima02,
           #COLUMN 45,g_x[16] CLIPPED,sr.ima03 CLIPPED   #FUN-5A0047 mark
            COLUMN 64,g_x[16] CLIPPED,sr.ima03 CLIPPED   #FUN-5A0047
      PRINT '----------------------------------------------------------',
           #'------------------'                         #FUN-5A0047 mark
            '----------------------------------'         #FUN-5A0047
      PRINT COLUMN  2,g_x[27] CLIPPED,sr.ima07,
            COLUMN 24,g_x[25] CLIPPED,sr.ima15,
            COLUMN 45,g_x[21] CLIPPED,sr.ima70 CLIPPED
      PRINT '----------------------------------------------------------',
           #'------------------'                         #FUN-5A0047 mark
            '----------------------------------'         #FUN-5A0047
      PRINT COLUMN  2,g_x[45] CLIPPED,sr.ima25,
           #COLUMN 45,g_x[60] CLIPPED,sr.ima71 CLIPPED             #TQC-5B0059 mark
            COLUMN 45,g_x[60] CLIPPED,COLUMN 69,sr.ima71 CLIPPED   #TQC-5B0059
#     PRINT COLUMN  2,g_x[53] CLIPPED,sr.ima26,                    #FUN-A20044
      PRINT COLUMN  2,g_x[53] CLIPPED,sr.avl_stk_mpsmrp,           #FUN-A20044 
            COLUMN 45,g_x[61] CLIPPED,sr.ima271 CLIPPED
#     PRINT COLUMN  2,g_x[54] CLIPPED,sr.ima262,                   #FUN-A20044
      PRINT COLUMN  2,g_x[54] CLIPPED,sr.avl_stk,                  #FUN-A20044   
            COLUMN 45,g_x[62] CLIPPED,sr.ima27 CLIPPED
      PRINT COLUMN  2,g_x[55] CLIPPED,l_amt,
            COLUMN 45,g_x[63] CLIPPED,sr.ima28 CLIPPED
#     PRINT COLUMN  2,g_x[56] CLIPPED,sr.ima261,                   #FUN-A20044
      PRINT COLUMN  2,g_x[56] CLIPPED,sr.unavl_stk,                #FUN-A20044
            COLUMN 45,g_x[65] CLIPPED,sr.ima29 CLIPPED
      PRINT COLUMN  2,g_x[57] CLIPPED,sr.ima23,
            COLUMN 23,sr.gen02 CLIPPED,
            COLUMN 45,g_x[64] CLIPPED,sr.ima30 CLIPPED
      PRINT COLUMN  2,g_x[58] CLIPPED,sr.ima35,
	    COLUMN 45,g_x[66] CLIPPED,sr.ima73 CLIPPED
      PRINT COLUMN  2,g_x[59] CLIPPED,sr.ima36,
	    COLUMN 45,g_x[67] CLIPPED,sr.ima74 CLIPPED
      PRINT '----------------------------------------------------------',
           #'------------------'                         #FUN-5A0047 mark
            '----------------------------------'         #FUN-5A0047
      PRINT COLUMN  2,g_x[68] CLIPPED,sr.ima63,
	    COLUMN 45,g_x[69] CLIPPED,sr.ima64 CLIPPED
      PRINT COLUMN  2,g_x[70] CLIPPED,cl_facfor(sr.ima63_fac),
	    COLUMN 45,g_x[71] CLIPPED,sr.ima641 CLIPPED
 
ON LAST ROW
      IF g_zz05 = 'Y' # (80)-70,140,210,280  /  (132)-120,240,300
         THEN
              PRINT g_dash[1,g_len]
        #TQC-630166
        #      IF tm.wc[001,070] > ' ' THEN			# for 80
 	#         PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
        #      IF tm.wc[071,140] > ' ' THEN
  	#         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
        #      IF tm.wc[141,210] > ' ' THEN
  	#         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
        #      IF tm.wc[211,280] > ' ' THEN
  	#         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#       #      IF tm.wc[001,120] > ' ' THEN			# for 132
#	#	 PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#       #      IF tm.wc[121,240] > ' ' THEN
#	#	 PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#       #      IF tm.wc[241,300] > ' ' THEN
#	#	 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
         CALL cl_prt_pos_wc(tm.wc)
        #END TQC-630166
 
      END IF
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
    IF l_last_sw = 'n'
        THEN PRINT g_dash[1,g_len]
             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
        ELSE SKIP 2 LINES
     END IF
END REPORT}
#No.FUN-770006 --end--
#Patch....NO.TQC-610036 <001> #
