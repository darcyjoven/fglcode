# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
#Pattern name...: acsp201.4gl
# Descriptions...: all-part-cost roll up-proposed cost
# Date & Author..: 92/01/18 By pin
# Modify.........: 92/02/22 By pin
# Modify.........: 92/07/30 By pin
#                  a.'NULL' INITIALIZE TO ZERO
#                   - 將數值欄位如果為 NULL, 則清為 0.
#                  b.FREE STOCK 處理
#                  c.ADD VALUE 處理
#                   -若不將人工/製費清空, 則直接將料件成本要素及成本項目
#                    結構複製過來, 因此, 毋需再產生附加成本部份.
#                  d.成本項目處理
#                   - 若使用成本中心計算其成本,且亦使用成本項目結構時,將
#                     廠外加工成本/廠外加工固定/變動製造費用之成本相加,
#                     彙集至成本項目編號 "UNKNOW"==>為了成本要素與成本
#                     項目值能BALANCE.
#                   - 若使用成本項目結構, 該成本項目為 "NULL" 時,
#                     彙集至成本項目編號 "NULL"==>為了成本要素與成本
#                     項目值能BALANCE.
#                  e.是否考慮損耗率[Y/N]
#                   -算成本時檢查是否需考慮損耗率
# modify(93/04/01):改善執行之速度  by pin
#                  1.LLC CODE 2.DEFINE CURSOR 3.ERROR MESSAGE(array 方式)
# modify(93/04/21):系統shutdown 處理
#                  加二欄位(1.目前版本是否正使用中) (2.執行環境)
 # modify..........: NO.MOD-490217 04/09/10 by yiting 料件欄位放大
# Modify.........: No.FUN-550100 05/05/25 By ching 特性BOM功能修改
# Modify..........:No.FUN-570142 06/03/02 By yiting 批次背景執行
# Modify.........: No.FUN-660089 06/06/16 By cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680071 06/09/08 By chen 類型轉換
# Modify.........: No.FUN-6A0064 06/10/27 By king l_time轉g_time
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910
# Modify.........: No.FUN-980002 09/08/20 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-B80022 11/08/03 By fanbj   未加離開前得cl_used(2)

IMPORT os   #No.FUN-9C0009 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD			     	# Print condition RECORD
              version    LIKE type_file.chr1,      # Prog. Version..: '5.30.06-13.03.12(01)      # simulation version.
              x          LIKE type_file.chr1,      # Prog. Version..: '5.30.06-13.03.12(01)      # system execute environment
              effectiv   LIKE type_file.dat,       #No.FUN-680071 DATE          # effective date.
			  free_stock LIKE type_file.chr1,      # Prog. Version..: '5.30.06-13.03.12(01)      # cost roll up including free
										# stock and 'miscellaneous' part.
										# of purchasing cost  (Y/N)
			  lab_bud    LIKE type_file.chr1,      # Prog. Version..: '5.30.06-13.03.12(01)      # zero the labor and burden cost
										# of the purchase part and
										# miscellaneous part  (Y/N)
              e          LIKE type_file.chr1,      # Prog. Version..: '5.30.06-13.03.12(01)      # including scrap rate [Y/N)
			  i          LIKE type_file.chr1000,   #No.FUN-680071 VARCHAR(50)      # simulation version description
			  f          LIKE type_file.chr1       # Prog. Version..: '5.30.06-13.03.12(01)       # variable report print flag
										
              END RECORD,
          l_ima08   LIKE ima_file.ima08,# part's source code.
          p_time    LIKE type_file.chr8,    #No.FUN-680071 VARCHAR(08)
          l_chr     LIKE type_file.chr1,    #No.FUN-680071 VARCHAR(1)
          l_msg     LIKE type_file.chr1000, #No.FUN-680071 VARCHAR(70)
          l_name          LIKE type_file.chr20,      # External(Disk) file name  #No.FUN-680071 VARCHAR(20)
          l_n             LIKE type_file.num10,   #No.FUN-680071 INTEGER
          l_za05          LIKE type_file.chr1000,    #  #No.FUN-680071 VARCHAR(40)
          l_cmd           LIKE type_file.chr1000, #No.FUN-680071 VARCHAR(70)
          l_lock    LIKE type_file.num5,      #No.FUN-680071 smallint
          m_err ARRAY[15] OF LIKE ze_file.ze03,    #No.FUN-680071 VARCHAR(60)
          g_err     LIKE type_file.num5       #No.FUN-680071 SMALLINT            # message no.
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680071 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(72)
DEFINE   g_change_lang   LIKE type_file.chr1      #No.FUN-680071 VARCHAR(1)    #No.FUN-570142

MAIN
   DEFINE   l_flag        LIKE type_file.chr1     #No.FUN-570142  #No.FUN-680071 VARCHAR(1)
   DEFINE   ls_date       STRING    #No.FUN-570142
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    #No.FUN-570142--start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.version     = ARG_VAL(1)
   LET tm.x           = ARG_VAL(2)
   LET ls_date        = ARG_VAL(3)
   LET tm.effectiv = cl_batch_bg_date_convert(ls_date)
   LET tm.free_stock  = ARG_VAL(4)
   LET tm.lab_bud     = ARG_VAL(5)
   LET tm.e           = ARG_VAL(6)
   LET tm.i           = ARG_VAL(7)
   LET tm.f           = ARG_VAL(8)
   LET g_bgjob= ARG_VAL(9)
   IF cl_null(g_bgjob)THEN
       LET g_bgjob="N"
   END IF
  #No.FUN-570142--end--
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACS")) THEN
      EXIT PROGRAM
   END IF
 
   IF s_shut(0) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
 
   WHILE TRUE                           # use while loop ,can execute
    IF g_bgjob="N" THEN
       CALL p201_tm()
       IF cl_sure(21,21) THEN
          CALL cl_wait()
          LET g_success='Y'
          BEGIN WORK
          CALL p201_cur()
          IF g_success='Y' THEN
             COMMIT WORK
             CALL cl_end2(1) RETURNING l_flag
          ELSE
             ROLLBACK WORK
             CALL cl_end2(2) RETURNING l_flag
          END IF
          IF l_flag THEN
             CONTINUE WHILE
          ELSE
             CLOSE WINDOW p201_w
             EXIT WHILE
          END IF
      ELSE
         CONTINUE WHILE
      END IF
    ELSE
      LET g_success='Y'
      BEGIN WORK
      CALL p201_cur()
      IF g_success = 'Y' THEN
         COMMIT WORK
      ELSE
        ROLLBACK WORK
      END IF
      CALL cl_batch_bg_javamail(g_success)
      EXIT WHILE
   END IF
  END WHILE

  CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#NO.FUN-570142 START-----------
FUNCTION p201_tm()
  DEFINE lc_cmd        LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(500) #No.FUN-570142
 
   OPEN WINDOW acsp201_w WITH FORM "acs/42f/acsp201"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
   WHILE TRUE                           # use while loop ,can execute
                                       # one more time
     LET tm.effectiv    = TODAY          # default effective date system date
     LET tm.x           = '2'            # default execute environment '2'
     LET tm.version     = '0'            # default simulation version "0"
     LET tm.free_stock  = 'Y'            # default including free_stock "Yes"
     LET tm.lab_bud     = 'Y'            # default zero labor/burder "Yes"
     LET tm.e           = 'Y'            # default including srcap rate "Yes"
     LET tm.f           = 'N'            # default print variable report "No"
     LET g_bgjob = "N"                  #No.FUN-570142  
   
     #INPUT BY NAME tm.* WITHOUT DEFAULTS  #input condition
     INPUT BY NAME tm.*,g_bgjob WITHOUT DEFAULTS  #input condition  #NO.FUN-570142
       ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET g_change_lang=TRUE                    #No.FUN-570142
          EXIT INPUT                                #No.FUN-570142
 
         AFTER FIELD version             #simulation version
            IF tm.version IS NULL OR tm.version = ' ' THEN
               NEXT FIELD version
            ELSE
               IF tm.version NOT MATCHES '[0-9]' THEN
                  CALL cl_err(tm.version,'mfg6005',0)
                  NEXT FIELD version
               END IF
            END IF
           #**************************************************************#
           #---> The version is running ?
            SELECT csc01 FROM csc_file WHERE csc01 =tm.version AND csc14 IN ('Y','y')
            IF SQLCA.SQLCODE=0 THEN
#              CALL cl_err(tm.version,'mfg9181',0)   #No.FUN-660089
               CALL cl_err3("sel","csc_file",tm.version,"","mfg9181","","",0)     #No.FUN-660089
               NEXT FIELD version
            END IF
           #---> The  execute environment setup ?
            SELECT COUNT(*) INTO l_n FROM csc_file WHERE csc14 IN ('y','Y') AND csc15 ='2'
            IF l_n >0 THEN
               CALL cl_getmsg('mfg9182',g_lang) RETURNING g_msg
               CALL cl_msgany(0,0,g_msg)
               CALL cl_batch_bg_javamail("N")   #NO.FUN-570142
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
            END IF
 
         AFTER FIELD x                   #execute environment
            IF cl_null(tm.x) OR tm.x NOT MATCHES '[12]' THEN
                NEXT FIELD x
            END IF
 
         AFTER FIELD effectiv            #effective date
            IF tm.effectiv IS NULL OR tm.effectiv = ' ' THEN
               NEXT FIELD effectiv
            END IF
 
         AFTER FIELD free_stock          #including free stock part
            IF tm.free_stock IS NULL OR tm.free_stock = ' ' THEN
               NEXT FIELD free_stock
            ELSE
               IF tm.free_stock NOT MATCHES '[YyNn]' THEN
       	          NEXT FIELD free_stock
       	       END IF
            END IF
       		
         AFTER FIELD lab_bud          #zero labor/burden
            IF tm.lab_bud IS NULL OR tm.lab_bud = ' ' THEN
               NEXT FIELD lab_bud
            ELSE
               IF tm.lab_bud NOT MATCHES '[YyNn]' THEN
       	          NEXT FIELD lab_bud
       	       END IF
            END IF
 
         AFTER FIELD e               #including scrap rate
            IF tm.e IS NULL OR tm.e = ' ' THEN
               NEXT FIELD e
            ELSE
               IF tm.e NOT MATCHES '[YyNn]' THEN
       	          NEXT FIELD e
       	       END IF
            END IF
 
         AFTER FIELD f               #variable report list
            IF tm.f IS NULL OR tm.f = ' ' THEN
               NEXT FIELD f
            ELSE
               IF tm.f NOT MATCHES '[YyNn]' THEN
       	          NEXT FIELD f
       	       END IF
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
  #No.FUN-570142--start--
      IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        IF INT_FLAG THEN               #when user press interrupt key
          LET INT_FLAG=0               #int_flat recover and exit
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM                 # program
        END IF
        CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
        LET INT_FLAG=0
        CLOSE WINDOW p201_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
      END IF
 
#      IF INT_FLAG THEN                          #when user press interrupt key
#         LET INT_FLAG=0               #int_flat recover and exit
#         EXIT PROGRAM                 # program
#      END IF
 
    #No.FUN-570142--start--
       IF g_bgjob = "Y" THEN
          SELECT zz08 INTO lc_cmd FROM zz_file
           WHERE zz01 = "acsp201"
          IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('acsp201','9031',1)   
          ELSE
           LET lc_cmd = lc_cmd CLIPPED,
                     " '",tm.version CLIPPED,"'",
                     " '",tm.x CLIPPED,"'",
                     " '",tm.effectiv CLIPPED,"'",
                     " '",tm.free_stock CLIPPED,"'",
                     " '",tm.lab_bud CLIPPED,"'",
                     " '",tm.e CLIPPED,"'",
                     " '",tm.i CLIPPED,"'",
                     " '",tm.f CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('acsp201',g_time,lc_cmd CLIPPED)
         END IF
           CLOSE WINDOW p201_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM
       END IF
     EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p201_cur()
 
  WHILE TRUE
 
      #IF NOT cl_sure(17,23) THEN                # if not execute then continue
      #   CONTINUE WHILE               # input next part to execute
      #END IF
 
      CALL cl_wait()
 
#報表設定
      LET g_len=79
	 LET g_rlang=g_lang
	 SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
	    CALL cl_outnam('acsp201') RETURNING l_name
	 FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
      START REPORT p201_log TO l_name
      BEGIN WORK  #94/04/12 modify by pin
      DELETE FROM csa_file WHERE csa02=tm.version
      DELETE FROM csb_file WHERE csb02=tm.version
      DELETE FROM csc_file WHERE csc01=tm.version
      COMMIT WORK
      IF tm.x='2' THEN #不允許別人使用時,將系統 shutdown,且lock 相關檔案
         CALL p201_lock2() returning l_lock  #將系統shutdown
            IF l_lock THEN
               call cl_err(' ','mfg6027',0)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time   # FUN-B80022
               exit program
            END IF
            IF  p201_waitlock() THEN
                CALL p201_unlock2()
                EXIT WHILE
            END IF
      END IF
      CALL insert_csc()
      #CALL cl_wait()   #NO.FUN-570142
#---->先將<CURSOR>加以宣告,以結省時間 (93/04/01 by pin)
      CALL p201_defcur()
      CALL cost_roll_up()
      IF tm.x='2' THEN #不允許別人使用時,將系統 還原
         CALL p201_unlock2()                 #UNLOCK
      END IF
      UPDATE csc_file SET csc14='N' WHERE csc01=tm.version
 
 
      FINISH REPORT p201_log
      IF g_err THEN
         CALL cl_prt(l_name,g_prtway,g_copies,g_len)
      #No.+366 010705 plum
      ELSE
#        LET l_cmd = "chmod 777 ", l_name                   #No.FUN-9C0009
#        RUN l_cmd                                          #No.FUN-9C0009
         IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009
      #No.+366..end
      END IF
      IF tm.f MATCHES '[Yy]' THEN
         CALL p201_prt()
      END IF
      ERROR ''
      IF NOT cl_cont(17,23) THEN
         EXIT WHILE
      END IF
  END WHILE
END FUNCTION
#NO.FUN-570142 END-----------
 
 
#--->不允許別人使用時,除了將系統shutdown外,
#    還需檢查是否有人在執行中....
#============================================================
#   執行環境為不允許其它使用者同時使用時，將相關檔案皆鎖住
#============================================================
 
FUNCTION p201_waitlock()
   DEFINE l_no,p_no  LIKE type_file.num10     #No.FUN-680071 integer
 
   LET p_no=0
   LET l_no=0
#---->#參數檔
  IF s_locktab('sma_file','系統參數檔(sma_file)') THEN RETURN 1 END IF
 
#---->#料件主檔
  IF s_locktab('ima_file','料件主檔(ima_file)')  THEN RETURN 1 END IF
 
#---->#BOM 單頭檔
  IF s_locktab('bma_file','BOM 單頭檔(bma_file)') THEN RETURN 1 END IF
 
#---->#BOM 單身檔
  IF s_locktab('bmb_file','BOM 單身檔(bmb_file)') THEN RETURN 1 END IF
 
#---->#料件成本要素模擬檔
  IF s_locktab('csa_file','料件成本要素模擬檔(csa_file)') THEN RETURN 1 END IF
 
#---->#料件成本項目模擬檔
  IF s_locktab('csb_file','料件成本項目模擬檔(csb_file)') THEN RETURN 1 END IF
 
#---->#成本模代號主檔
  IF s_locktab('csc_file','料件成本項目模擬檔(csb_file)') THEN RETURN 1 END IF
 
IF g_sma.sma23 MATCHES '[13]' THEN
#---->#工作站主檔
  IF s_locktab('eca_file','工作站主檔(eca_file)') THEN RETURN 1 END IF
#---->#製程主檔
  IF s_locktab('ecb_file','製程主檔(ecb_file)') THEN  RETURN 1 END IF
END IF
 
#---->#成本中心主檔
IF g_sma.sma23 !='2' THEN
  IF  s_locktab('smh_file','成本中心檔(smh_file)') THEN RETURN 1 END IF
END IF
 
IF g_sma.sma58 MATCHES '[yY]' THEN
  IF s_locktab('csd_file','料件附加成本檔(csd_file)') THEN RETURN 1 END IF
  IF s_locktab('cse_file','料件附加成本項目檔(cse_file)') THEN RETURN 1
  END IF
#---->#料件成本項目檔
  IF s_locktab('iml_file','料件成本項目檔(iml_file)') THEN RETURN 1 END IF
END IF
#---->#料件成本要素檔
  IF s_locktab('imb_file','料件成本要素檔(imb_file)') THEN RETURN 1 END IF
 
RETURN 0
 
END FUNCTION
 
#============================================================
#  成 本 捲 算 作 業 結 束 ，則 鎖 住 的 檔 案 釋 放 回 去
#============================================================
FUNCTION p201_unwaitlock()
 
  UNLOCK TABLE sma_file
  UNLOCK TABLE ima_file
  UNLOCK TABLE bma_file
  UNLOCK TABLE bmb_file
  UNLOCK TABLE csa_file
  UNLOCK TABLE csb_file
  UNLOCK TABLE csc_file
  UNLOCK TABLE imb_file
  IF g_sma.sma23 MATCHES '[13]'
     THEN UNLOCK TABLE eca_file
          UNLOCK TABLE ecb_file
  END IF
  IF g_sma.sma23 ='2'
     THEN UNLOCK TABLE smh_file
  END IF
  IF g_sma.sma58 MATCHES '[yY]'
     THEN UNLOCK TABLE csd_file
          UNLOCK TABLE cse_file
          UNLOCK TABLE iml_file
  END IF
END FUNCTION
 
FUNCTION p201_defcur()
DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(600)
 
#--------------->cursor-1
  LET l_sql=" select * from iml_file WHERE iml01=? " #part no.
  PREPARE curs1 FROM l_sql
  IF SQLCA.SQLCODE THEN CALL cl_err('curs1',SQLCA.SQLCODE,1) END IF
  DECLARE pvwz_cursor CURSOR FOR curs1
 
#--------------->cursor-2
  LET l_sql=" select bmb03,bmb06,bmb07,bmb08,bmb10_fac2 from bmb_file",
            " where bmb01 = ?   ",               #part no.
            " and (bmb04 <=? or bmb04 is null)", #生效日控制
            " and (bmb05 > ? or bmb05 is null)"
  PREPARE curs2 FROM l_sql
  IF SQLCA.SQLCODE THEN CALL cl_err('curs2',SQLCA.SQLCODE,1) END IF
  DECLARE insert_cote2 CURSOR FOR curs2   #將此料件下階的元件抓取出來
 
#--------------->cursor-3
  LET l_sql=" SELECT csb04,csb05 FROM  csb_file",
		    "		  WHERE csb01=?    ",      #元件編號
		    "	       AND  csb02=?    ",      #模擬版本
		    "		   AND  csb03=?    "       #1.standard 2.current 3.pro
  PREPARE curs3 FROM l_sql
  IF SQLCA.SQLCODE THEN CALL cl_err('curs3',SQLCA.SQLCODE,1) END IF
  DECLARE insert_cote_c CURSOR FOR curs3       #將元件的成本項目抓出
 
#--------------->cursor-4
   LET l_sql=
        " SELECT eca04,eca06,eca14,eca15,eca26,eca27,eca28,eca29,",
              " eca30,eca31,eca301,eca311,eca32,eca33,eca34,eca35,",
              " eca43,eca44,eca45,eca46,eca47, ",
              " ecb03,ecb30,ecb31,ecb32,ecb33,ecb34,ecb35,ecb24,ecb25,ecb15,",
              " ecb16,ima561 ",
              " FROM ecb_file,eca_file,ima_file ",
              "  WHERE eca01=ecb08 ",  #工作站編號
	          "	 AND  ima01=ecb01  ",  #part no.
              "  AND  ecb01=? ",       #part no.
              "  AND  ecb02=1 ",       #主製程編號
              "  AND (ecb04 <=? OR ecb04 IS NULL)", #生效日控制
              "  AND (ecb05 > ? OR ecb05 IS NULL)",
              "  AND ecbacti IN ('y','Y') ",
              " ORDER BY ecb03 "
  PREPARE curs4 FROM l_sql
  IF SQLCA.SQLCODE THEN CALL cl_err('curs4',SQLCA.SQLCODE,1) END IF
  DECLARE wc_rout_cur CURSOR FOR   curs4
END FUNCTION
#--->列印差異報表
 
FUNCTION p201_prt()
 
    OPEN WINDOW p201_prt AT 17,09 WITH 4 ROWS, 50 COLUMNS
                    					
    WHILE TRUE
     CALL cl_getmsg('mfg6022',g_lang) RETURNING l_msg
    #DISPLAY l_msg at 1,1     #CHI-A70049 mark
     CALL cl_getmsg('mfg6023',g_lang) RETURNING l_msg
    #DISPLAY l_msg at 2,1     #CHI-A70049 mark
     CALL cl_getmsg('mfg6024',g_lang) RETURNING l_msg
    #DISPLAY l_msg at 3,1     #CHI-A70049 mark
     CALL cl_getmsg('mfg6025',g_lang) RETURNING l_msg
            LET INT_FLAG = 0  ######add for prompt bug
     IF g_bgjob="N" THEN     # No.FUN-570142
         PROMPT l_msg  clipped  FOR l_chr
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
#                CONTINUE PROMPT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
          ON ACTION controlg      #MOD-4C0121
             CALL cl_cmdask()     #MOD-4C0121
 
 
         END PROMPT
     END IF
     IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE
     END IF
     CASE l_chr
          WHEN '1'
               LET l_cmd="acsr302", " '",g_today clipped,"' ",
                                    " '",g_user  clipped,"' ",
                                    " '",g_lang  clipped,"' "," 'Y' ",
                                        " ' ' "," '1'",
                                        " '1=1' ",
                                    " '",tm.version clipped,"'"
               CALL cl_cmdrun(l_cmd)
          WHEN '2'
               LET l_cmd="acsr303", " '",g_today clipped,"' ",
                                    " '",g_user  clipped,"' ",
                                    " '",g_lang  clipped,"' "," 'Y' ",
                                        " ' ' "," '1'",
                                        " '1=1' ",
                                    " '",tm.version clipped,"'"
               CALL cl_cmdrun(l_cmd)
          OTHERWISE EXIT CASE
     END CASE
    END WHILE
     CLOSE WINDOW p201_prt
 END FUNCTION
 
FUNCTION p201_lock2()
  DEFINE   l_st   LIKE type_file.chr1      #No.FUN-680071 VARCHAR(01)
{
	UPDATE sma_file
		SET sma01='N'
		WHERE sma00='0'
	IF SQLCA.SQLERRD[3]=0 THEN CALL cl_err('','mfg6026',0) RETURN 1 END IF
#	LOCK TABLE sma_file IN SHARE MODE
#	IF SQLCA.sqlcode THEN CALL cl_err('','mfg6026',0) RETURN 1 END IF
}
    CALL s_psdm('acsp201',tm.version) RETURNING l_st
    IF l_st = 'Y' THEN
    	RETURN 0
    ELSE
    	RETURN 1
    END IF
END FUNCTION
 
#============================================================#
#  在執行後, 不允許其他人同時更新資料庫時, 將資料庫重新開放  #
#============================================================#
FUNCTION p201_unlock2()
 DEFINE  l_st  LIKE type_file.chr1      #No.FUN-680071 VARCHAR(01)
    CALL p201_unwaitlock()
{
	UPDATE sma_file
		SET sma01='Y'
		WHERE sma00='0'
}
   CALL s_prsm()
END FUNCTION
 
#-----●●●● 程式處理邏輯●●●● -------(1992/01/22 by pin)
#     2.為全部料件成本逆算
#     2.開始以此料件做ｂｏｍ展開
#     3.ｂｏｍ展開過程中,計算各料件的上/下階各成本要素
#     4.產生每料件成本要素模擬資料檔, 料件成本項目檔, 料件成本項目結構檔
 
 FUNCTION cost_roll_up()
   DEFINE g_material     LIKE imb_file.imb311,    #No.FUN-680071 decimal(20,6)
          g_labor_cost   LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)      #labor cost
          g_ind_labor    LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)      #indirect labor cost
		  g_fix_bud      LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)      #fixed burden cost
		  g_var_bud      LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)      #variable burden cost
		  g_outside_cost LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)      #outside process cost
		  g_out_fix_bud  LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)      #outside process fixed burden cost
		  g_out_var_bud  LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)      #outside process varia.burden cost
		  g_mac_cost     LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)     #machine cost
		  g_add_val      LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)     #add values
          g_ind_m            LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)     #indirect material cost
		  l_ima871   LIKE ima_file.ima871,
       s_aa RECORD
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb07 LIKE bmb_file.bmb07,    #底數
              bmb08 LIKE bmb_file.bmb08,    #scrap rate
              bmb10_fac2 LIKE bmb_file.bmb10_fac2, #發料/成本換算率
               bma01 LIKE bma_file.bma01,    #assembly part NO.MOD-490217
              ima08 LIKE ima_file.ima08,    #來源
              ima53 LIKE ima_file.ima53,    #最近採購單價(本幣)
              ima87 LIKE ima_file.ima87,    #材料成本項目
              ima871 LIKE ima_file.ima871,  #材料製造費用分攤率
              ima872 LIKE ima_file.ima872,  #材料製造費用成本項目
              ima44 LIKE ima_file.ima44,    #採購單位
              ima86 LIKE ima_file.ima86,    #成本單位
              ima34 LIKE ima_file.ima34,    #成本中心
              ima58 LIKE ima_file.ima58,    #最後人工工時
              ima873 LIKE ima_file.ima873,  #人工製/費用分攤率
              ima874 LIKE ima_file.ima874,  #人工製/費用成本項目
              imb311 LIKE imb_file.imb311,  #本階材料成本
              imb318 LIKE imb_file.imb318,  #採購成本
              imb316 LIKE imb_file.imb316,  #廠外加工成本
              imb3171 LIKE imb_file.imb3171,  #廠外加工固定製費
              imb3172 LIKE imb_file.imb3172   #廠外加工變動製費
          END RECORD,
          l_name LIKE type_file.chr20,   #No.FUN-680071 VARCHAR(20)
          w_csa  RECORD LIKE csa_file.*,
          d1,d2,d3,d4,d5,d6,d7,d8,d9,d10  LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
          l_ind_m      LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
          l_n  LIKE type_file.num5,    #No.FUN-680071 SMALLINT
	      pur_cost, l_add_val     LIKE oeb_file.oeb13   #No.FUN-680071 DECIMAL(20,6)
   DEFINE l_ima910   LIKE ima_file.ima910   #FUN-550100
 
#---------------------------------------------------------------------+
#                 program begin                                       |
#----------------------------------------------------------------------
#---->先將錯誤訊息存入陣列,以結省時間 (93/04/01 by pin)
      CALL p201_mess()
 
#---->抓取料件主檔資料
  DECLARE p201_cur CURSOR FOR
       SELECT  ima01,' ',1,1,0,0,' ',ima08,ima53,ima87,ima871,
               ima872,ima44,ima86,ima34,ima58,ima873,ima874,
               imb311,imb318,imb316,imb3171,imb3172
                  FROM ima_file, OUTER imb_file
                  WHERE ima08 NOT IN ('A')
                    AND imaacti NOT IN ('N','n')
                    AND ima01=imb_file.imb01        #主件編號
                    AND ima16=0            #從最高階抓 93/04/01 pin
#                   AND ima01 MATCHES 'A*'
 
    OPEN WINDOW p201_wsg AT 9,09 WITH 4 ROWS, 66 COLUMNS
                    					
      LET g_err=0
 
#----->讀取資料
 FOREACH p201_cur INTO s_aa.*
 IF SQLCA.sqlcode !=0
      THEN CALL cl_err('foreach',SQLCA.sqlcode,1) EXIT FOREACH   
 
 END IF
{------>a."NULL" INITIALIZE TO ZERO}
    IF s_aa.bmb06 IS NULL THEN LET s_aa.bmb06=0 END IF
    IF s_aa.bmb07 IS NULL THEN LET s_aa.bmb07=1 END IF
    IF s_aa.bmb08 IS NULL THEN LET s_aa.bmb08=0 END IF
    IF s_aa.bmb10_fac2 IS NULL THEN LET s_aa.bmb10_fac2=1 END IF
{------>e.是否考慮損耗率}
     IF tm.e MATCHES '[Nn]' THEN LET s_aa.bmb08=0 END IF
 IF s_aa.bmb03 IS NULL THEN LET s_aa.bmb03=' ' END IF
#----->檢查此料件是否之前被捲算過
 SELECT * INTO w_csa.* FROM csa_file WHERE csa01=s_aa.bmb03  #part no.
                                     AND csa02=tm.version   #模擬版本
                                     AND csa03='3'          #成本方式
 IF SQLCA.sqlcode =0  #表被捲算過,讀下一筆
  THEN initialize w_csa.* to null
       continue foreach
 ELSE
  #FUN-550100
  LET l_ima910=''
  SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=s_aa.bmb03
  IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
  #--
  IF s_aa.ima08 NOT MATCHES '[PpVvWwZz]'   #檢查其是否有產品結構
     THEN SELECT count(*) into l_n FROM bmb_file
                        WHERE bmb01 = s_aa.bmb03    #part no.
                          AND bmb29 = l_ima910      #FUN-550100
                          and (bmb04 <=tm.effectiv or bmb04 is null) #生效日控制
                          and (bmb05 > tm.effectiv or bmb05 is null)
		IF l_n=0 THEN
		   CALL p201_err(5,s_aa.bmb03)
		   CALL p201_pvwz('P',s_aa.ima44,s_aa.ima86, #以最下階計算
                           s_aa.bmb03,s_aa.ima53,s_aa.imb318,s_aa.imb311,
                           s_aa.ima872,s_aa.ima871,s_aa.ima87)
     					    returning pur_cost, l_add_val,l_ind_m
#CHI-A70049---mark---start---
                #DISPLAY  'part no.:','                    ' AT 2,1
                #DISPLAY  'part no.:',s_aa.bmb03 clipped,' ' AT 2,1
#CHI-A70049---mark---end---
        ELSE    #------為一般自製料-------#
           CALL acsp201_bom(0,s_aa.bmb03,l_ima910)                    #level,item no.
                         RETURNING g_material,               #下階材料成本
                     g_labor_cost,  g_ind_labor,             #及下階人工/製費
                     g_fix_bud   ,  g_var_bud,
                     g_outside_cost,g_out_fix_bud,
                     g_out_var_bud, g_mac_cost,
                     g_add_val    , g_ind_m
           CALL s_in_csa(s_aa.bmb03,     #part no.
						   s_aa.ima871,    #indirect material factor
						   g_material,     #下階material cost
						   '3',            #proposed cost
						    0,             #採購成本(P/V)
							0,             #本階材料成本(W/Z)
							s_aa.ima872,   #間接材料成本項目
							0,             #本階間接材料成本
                            0,tm.version      )       #附加成本
 
           IF g_sma.sma58 MATCHES '[Yy]'
           THEN CALL insert_cote2(s_aa.bmb03,'3')   #複製下階成本項目資料
           END IF
           CALL lab_burden(s_aa.*,g_material)
                RETURNING  d1,             #本階labor cost
						   d2,             #本階indirect labor cost
						   d3,             #本階fixed burder cost
						   d4,             #本階variable burder cost
                           d5,             #本階outside process cost
						   d6,             #本階outside fixed burden
						   d7,             #    outside variable burden
						   d8,             #    machine cost
                           d9,             #    add values
						   d10             #    indirect material cost
#--->更新料件上/下階成本要素
           CALL lb_bd_update(s_aa.bmb03,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,
                          g_labor_cost,g_ind_labor,g_fix_bud,g_var_bud,
                          g_outside_cost,g_out_fix_bud,g_out_var_bud,
                          g_mac_cost,g_add_val,g_ind_m)
 
	END IF
                 #DISPLAY  'part no.:',s_aa.bmb03  AT 2,1   #CHI-A70049 mark
  ELSE #---->處理來源碼為 P/V/W/Z
    IF s_aa.ima08 MATCHES '[PVWZ]'     #當為最下階料件時
       THEN CALL p201_pvwz('P',s_aa.ima44,s_aa.ima86, #以最下階計算
                           s_aa.bmb03,s_aa.ima53,s_aa.imb318,s_aa.imb311,
                           s_aa.ima872,s_aa.ima871,s_aa.ima87)
     					    returning pur_cost, l_add_val,l_ind_m
     END IF
                 #DISPLAY  'part no.:',s_aa.bmb03  AT 2,1   #CHI-A70049 mark
  END IF
END IF
 END FOREACH
 CLOSE WINDOW p201_wsg
END FUNCTION
 
FUNCTION acsp201_bom(p_level,p_key,p_key2)   #FUN-550100
   DEFINE p_level	LIKE type_file.num5,      #No.FUN-680071 SMALLINT
          p_key		LIKE bma_file.bma01,  #主件part no.
          p_key2	LIKE ima_file.ima910,   #FUN-550100
          l_ac,i	LIKE type_file.num5,    #No.FUN-680071 SMALLINT
          arrno		LIKE type_file.num5,      #No.FUN-680071 SMALLINT	          #BUFFER SIZE (可存筆數)
          b_seq		LIKE type_file.num5,      #No.FUN-680071 SMALLINT             #當BUFFER滿時,重新讀單身之起始序號
          pur_cost  LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)        #採購成本
          g_cost    LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
          g_labor_cost   LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)      #labor cost
          g_ind_labor    LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)      #indirect labor cost
		  g_fix_bud      LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)      #fixed burden cost
		  g_var_bud      LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)      #variable burden cost
		  g_outside_cost LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)      #outside process cost
		  g_out_fix_bud  LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)      #outside process fixed burden cost
		  g_out_var_bud  LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)      #outside process varia.burden cost
		  g_mac_cost     LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)     #machine cost
		  g_add_val      LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)     #add values
                  g_ind_m        LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)     #indirect material cost
                  t_cost         LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
          sr DYNAMIC ARRAY OF RECORD         #每階存放資料
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb07 LIKE bmb_file.bmb07,    #底數
              bmb08 LIKE bmb_file.bmb08,    #scrap rate
              bmb10_fac2 LIKE bmb_file.bmb10_fac2, #發料/成本換算率
               bma01 LIKE bma_file.bma01,    #assembly part NO.MOD-490217
              ima08 LIKE ima_file.ima08,    #來源
              ima53 LIKE ima_file.ima53,    #最近採購單價(本幣)
              ima87 LIKE ima_file.ima87,    #材料成本項目
              ima871 LIKE ima_file.ima871,  #材料製造費用分攤率
              ima872 LIKE ima_file.ima872,  #材料製造費用成本項目
              ima44 LIKE ima_file.ima44,    #採購單位
              ima86 LIKE ima_file.ima86,    #成本單位
              ima34 LIKE ima_file.ima34,    #成本中心
              ima58 LIKE ima_file.ima58,    #最後人工工時
              ima873 LIKE ima_file.ima873,  #人工製/費用分攤率
              ima874 LIKE ima_file.ima874,  #人工製/費用成本項目
              imb311 LIKE imb_file.imb311,  #本階材料成本
              imb318 LIKE imb_file.imb318,  #採購成本
              imb316 LIKE imb_file.imb316,  #廠外加工成本
              imb3171 LIKE imb_file.imb3171,  #廠外加工固定製費
              imb3172 LIKE imb_file.imb3172   #廠外加工變動製費
          END RECORD,
          l_material    LIKE imb_file.imb311,  #材料成本
          l_material_t  LIKE imb_file.imb311,  #材料成本
#-->labor/burden
          labor_cost    LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,5)       #labor cost
          ind_labor     LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,5)       #indirect labor cost
		  fix_bud       LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)       #fixed burden cost
		  var_bud       LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)       #variable burden cost
		  outside_cost  LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)       #outside process cost
		  out_fix_bud   LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)       #outside process fixed burden cost
		  out_var_bud   LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)       #outside process varia.burden cost
		  mac_cost      LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)       #machine cost
		  add_val       LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)       #add values
          l_labor_cost_t   LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)     #labor cost
          l_ind_labor_t    LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)     #indirect labor cost
		  l_fix_bud_t      LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)     #fixed burden cost
		  l_var_bud_t      LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)     #variable burden cost
		  l_outside_cost_t LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)     #outside process cost
		  l_out_fix_bud_t  LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)     #outside process fixed burden cost
		  l_out_var_bud_t  LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)     #outside process varia.burden cost
		  l_mac_cost_t     LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)     #machine cost
		  l_add_val_t      LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)        #add values
		  l_ind_m_t        LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)        #add values
                  a1,b1         LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)       #labor cost
                  a2,b2         LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)       #indirect labor cost
		  a3,b3         LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)       #fixed burden cost
		  a4,b4         LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)       #variable burden cost
		  a5,b5         LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)       #outside process cost
		  a6,b6         LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)       #outside process fixed burden cost
		  a7,b7         LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)       #outside process varia.burden cost
		  a8,b8         LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)       #machine cost
		  a9,b9         LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)       #add values
		  a10,b10       LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)       #indirect material cost
		  l_add_val     LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
		  l_ind_m       LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
		  ind_m         LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)       #indirect material cost
          l_csa     RECORD LIKE csa_file.*,
          l_status  LIKE type_file.chr1,      #No.FUN-680071 VARCHAR(01)
          l_cmd		LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(600)
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
    LET p_level = p_level + 1
    IF p_level > 20 THEN
        CALL cl_err(p_level,'mfg2644',2)
        CALL p201_unlock2()                 #UNLOCK
        CALL cl_batch_bg_javamail("N")      #NO.FUN-570142
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
    END IF
    LET arrno = 600
#------------>為了縮短執行時間,將cursor 搬離while外--->93/04/01
        LET l_cmd=
            "SELECT bmb03,bmb02,bmb06,bmb07,bmb08,bmb10_fac2,bma01,",
            "       ima08,ima53,ima87,ima871,ima872,ima44,ima86,ima34,",
            "       ima58,ima873,ima874,",
            "       imb311,imb318,imb316,imb3171,imb3172 " ,
            " FROM bmb_file, OUTER imb_file, OUTER ima_file, OUTER bma_file",
            " WHERE bmb01='", p_key,"' AND bmb02 >",b_seq,
               "   AND bmb29 ='",p_key2,"' ",  #FUN-550100
            " AND bmb03 = imb_file.imb01",
            " AND bmb03 = ima_file.ima01",
            " AND bmb03 = bma_file.bma01"
#生效日及失效日的判斷
        IF tm.effectiv IS NOT NULL THEN
            LET l_cmd=l_cmd CLIPPED, " AND (bmb04 <='",tm.effectiv,
            "' OR bmb04 IS NULL) AND (bmb05 >'",tm.effectiv,
            "' OR bmb05 IS NULL)"
        END IF
 
#組完後的句子, 將準備成可以用的查詢命令
        PREPARE acsp201_ppp FROM l_cmd
        IF SQLCA.sqlcode THEN
          CALL cl_err('Prepare:',SQLCA.sqlcode,1) 
          CALL cl_batch_bg_javamail("N")      #NO.FUN-570142
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM
        END IF
        DECLARE acsp201_cur CURSOR FOR acsp201_ppp
    WHILE TRUE
 
        LET l_material_t=0
        LET l_labor_cost_t =0
        LET l_ind_labor_t=0
    	LET l_fix_bud_t =0
    	LET l_var_bud_t=0
		LET l_outside_cost_t=0
		LET l_out_fix_bud_t =0
		LET l_out_var_bud_t =0
		LET l_mac_cost_t   =0
		LET l_add_val_t  =0
		LET l_ind_m_t  =0
        LET l_ac = 1
        FOREACH acsp201_cur INTO sr[l_ac].*           #將資料丟入陣列中
{------>a. "NULL" INITIALIZE TO ZERO }
        IF sr[l_ac].bmb10_fac2 IS NULL THEN LET sr[l_ac].bmb10_fac2=1 END IF
        IF sr[l_ac].ima871     IS NULL THEN LET sr[l_ac].ima871=0 END IF
        IF sr[l_ac].ima873     IS NULL THEN LET sr[l_ac].ima873=0 END IF
        IF sr[l_ac].imb311     IS NULL THEN LET sr[l_ac].imb311=0 END IF
        IF sr[l_ac].imb318     IS NULL THEN LET sr[l_ac].imb318=0 END IF
        IF sr[l_ac].imb316     IS NULL THEN LET sr[l_ac].imb316=0 END IF
        IF sr[l_ac].imb3171    IS NULL THEN LET sr[l_ac].imb3171=0 END IF
        IF sr[l_ac].imb3172    IS NULL THEN LET sr[l_ac].imb3172=0 END IF
        IF sr[l_ac].bmb06      IS NULL THEN LET sr[l_ac].bmb07=0 END IF
        IF sr[l_ac].bmb07      IS NULL THEN LET sr[l_ac].bmb07=1 END IF
        IF sr[l_ac].bmb08      IS NULL THEN LET sr[l_ac].bmb08=0 END IF
{------>e. '是否考慮損耗率'}
        IF tm.e MATCHES '[Nn]' THEN LET sr[l_ac].bmb08=0 END IF
            #FUN-8B0035--BEGIN--
            LET l_ima910[l_ac]=''
            SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
            IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
            #FUN-8B0035--END--
            LET l_ac = l_ac + 1
            IF l_ac >= arrno THEN EXIT FOREACH END IF
         END FOREACH
 
  FOR i = 1 TO l_ac-1
      IF sr[i].bma01 IS NOT NULL  AND
         sr[i].ima08 NOT MATCHES '[pPVvWwzZ]'
		  THEN           #表非最下階元件
#----->檢查此料件是否被捲算過
              IF sr[i].bmb03 IS NULL THEN LET sr[i].bmb03=' ' END IF
              SELECT * INTO l_csa.*
                   FROM csa_file WHERE csa01=sr[i].bmb03  #part no.
                                 AND csa02=tm.version   #模擬版本
                                 AND csa03='3'          #成本方式
				IF SQLCA.sqlcode =0    #表此料件之前已做過, 不再做一次
				   THEN LET l_material= l_csa.csa0321  #直接抓取下階各成本
                        LET labor_cost= l_csa.csa0323
                        LET ind_labor = l_csa.csa0324
                        LET fix_bud   = l_csa.csa0325
                        LET var_bud   = l_csa.csa0326
                        LET outside_cost = l_csa.csa0327
                        LET out_fix_bud  = l_csa.csa0328
                        LET out_var_bud  = l_csa.csa0329
                        LET mac_cost     = l_csa.csa0330
                        LET add_val      = l_csa.csa0331
                        LET ind_m        = l_csa.csa0322
                        LET a1=l_csa.csa0303           #直接抓取本階各成本
                        LET a2=l_csa.csa0304
                        LET a3=l_csa.csa0305
                        LET a4=l_csa.csa0306
                        LET a5=l_csa.csa0307
                        LET a6=l_csa.csa0308
                        LET a7=l_csa.csa0309
                        LET a8=l_csa.csa0310
                        LET a9=l_csa.csa0301
                        LET a10=l_csa.csa0302
                        LET l_status ='N'
				  #ELSE CALL acsp201_bom(p_level,sr[i].bmb03,' ') #再往下展   #FUN-550100#FUN-8B0035
				   ELSE CALL acsp201_bom(p_level,sr[i].bmb03,l_ima910[i]) #再往下展   #FUN-8B0035
                        RETURNING l_material,            #由下階所累計之材料成本
                                  labor_cost, ind_labor, #及下階人工/製費
                                  fix_bud   , var_bud,
                                  outside_cost,out_fix_bud,
                                  out_var_bud, mac_cost,
                                  add_val    , ind_m
                         LET l_status ='Y'
	   		   END IF
                IF l_material IS NULL THEN LET l_material = 0 END IF
                IF labor_cost IS NULL THEN LET labor_cost = 0 END IF
				IF ind_labor  IS NULL THEN LET ind_labor  = 0 END IF
				IF fix_bud    IS NULL THEN LET fix_bud    = 0 END IF
				IF var_bud    IS NULL THEN LET var_bud    = 0 END IF
				IF outside_cost IS NULL THEN LET outside_cost=0 END IF
				IF out_fix_bud  IS NULL THEN LET out_fix_bud =0  END IF
				IF out_var_bud  IS NULL THEN LET out_var_bud =0  END IF
				IF mac_cost     IS NULL THEN LET mac_cost    =0  END IF
				IF add_val      IS NULL THEN LET add_val     =0  END IF
				IF ind_m        IS NULL THEN LET ind_m       =0  END IF
				
				
#----->計算下階材料成本(QPA,SCRAP RATE%,FACTOR)
			    LET g_cost=l_material*sr[i].bmb06/sr[i].bmb07*
                           (1+sr[i].bmb08/100)*sr[i].bmb10_fac2
#------>累計下階材料成本
                LET l_material_t=l_material_t+g_cost  #累計材料成本
                IF l_status ='Y'
                 THEN CALL s_in_csa (sr[i].bmb03,sr[i].ima871,l_material,
                                     '3',0,0,sr[i].ima872,0,0,tm.version)
#------->計算本階各成本
                      IF g_sma.sma58 MATCHES '[Yy]'    #有使用成本項目結構
			               THEN CALL insert_cote2(sr[i].bmb03,'3')
                       END IF
                      CALL lab_burden(sr[i].*,l_material) RETURNING
                                       a1,    a2,    a3,     a4,
                                       a5,    a6,    a7,     a8,
                                       a9,    a10             #本階人工/製費
#--->更新料件上/下階成本要素
                CALL lb_bd_update(sr[i].bmb03,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,
                                   labor_cost,ind_labor,fix_bud,var_bud,
                                   outside_cost,out_fix_bud,out_var_bud,
                                   mac_cost,add_val,ind_m)
                END IF
                LET a1=a1+labor_cost
                LET a2=a2+ind_labor
                LET a3=a3+fix_bud
                LET a4=a4+var_bud
                LET a5=a5+outside_cost
                LET a6=a6+out_fix_bud
                LET a7=a7+out_var_bud
                LET a8=a8+mac_cost
                LET a9=a9+add_val
                LET a10=a10+ind_m
#---->毛需求量=發料單位, 需轉成成本單位
                LET a1=a1*sr[i].bmb06/sr[i].bmb07*sr[i].bmb10_fac2
                      *(1+sr[i].bmb08/100)
                LET a2=a2*sr[i].bmb06/sr[i].bmb07*sr[i].bmb10_fac2
                      *(1+sr[i].bmb08/100)
                LET a3=a3*sr[i].bmb06/sr[i].bmb07*sr[i].bmb10_fac2
                      *(1+sr[i].bmb08/100)
                LET a4=a4*sr[i].bmb06/sr[i].bmb07*sr[i].bmb10_fac2
                      *(1+sr[i].bmb08/100)
                LET a5=a5*sr[i].bmb06/sr[i].bmb07*sr[i].bmb10_fac2
                      *(1+sr[i].bmb08/100)
                LET a6=a6*sr[i].bmb06/sr[i].bmb07*sr[i].bmb10_fac2
                      *(1+sr[i].bmb08/100)
                LET a7=a7*sr[i].bmb06/sr[i].bmb07*sr[i].bmb10_fac2
                      *(1+sr[i].bmb08/100)
                LET a8=a8*sr[i].bmb06/sr[i].bmb07*sr[i].bmb10_fac2
                      *(1+sr[i].bmb08/100)
                LET a9=a9*sr[i].bmb06/sr[i].bmb07*sr[i].bmb10_fac2
                      *(1+sr[i].bmb08/100)
                LET a10=a10*sr[i].bmb06/sr[i].bmb07*sr[i].bmb10_fac2 #間接材料
                      *(1+sr[i].bmb08/100)
 
                LET l_labor_cost_t= l_labor_cost_t+a1 #累計人工成本
                LET l_ind_labor_t = l_ind_labor_t+a2 #累計間接人工
                LET l_fix_bud_t   = l_fix_bud_t+a3 #累計固製費
                LET l_var_bud_t   = l_var_bud_t+a4 #累計變製費
                LET l_outside_cost_t=l_outside_cost_t+a5#廠外
                LET l_out_fix_bud_t =l_out_fix_bud_t+a6#廠外固製費
                LET l_out_var_bud_t =l_out_var_bud_t+a7#廠外變製費
                LET l_mac_cost_t    =l_mac_cost_t+a8 #機器成本
                LET l_add_val_t     =l_add_val_t+a9 #附加成本
                LET l_ind_m_t       =l_ind_m_t+a10 #間接材料
 
                #DISPLAY  'part no.:',sr[i].bmb03  AT 2,1   #CHI-A70049 mark
 
         ELSE #無下階之元件
              IF sr[i].bmb03 IS NULL THEN LET sr[i].bmb03=' ' END IF
              SELECT * INTO l_csa.*    #檢查此料件是否已計算過
                   FROM csa_file WHERE csa01=sr[i].bmb03  #part no.
                                 AND csa02=tm.version   #模擬版本
                                 AND csa03='3'          #成本方式
            IF SQLCA.sqlcode =0
               THEN IF sr[i].ima08 MATCHES '[pP]'
                       THEN  LET pur_cost = l_csa.csa0311
                             LET l_add_val= l_csa.csa0312+l_csa.csa0331
                             LET l_ind_m  = l_csa.csa0302+l_csa.csa0322
                       ELSE  LET pur_cost = l_csa.csa0301
                             LET l_add_val= l_csa.csa0312+l_csa.csa0331
                             LET l_ind_m  = l_csa.csa0302+l_csa.csa0322
                             LET l_status ='N'
                     END IF
                ELSE CALL p201_pvwz(sr[i].ima08,sr[i].ima44,sr[i].ima86,
                       sr[i].bmb03,sr[i].ima53,sr[i].imb318,
                       sr[i].imb311,sr[i].ima872,sr[i].ima871,sr[i].ima87)
					    returning pur_cost, l_add_val,l_ind_m
                        LET l_status ='Y'
              END IF
				 LET t_cost=pur_cost*sr[i].bmb06/sr[i].bmb07*sr[i].bmb10_fac2
						   *(1+sr[i].bmb08/100)#單價*QPA/底數*(1+SCRAP RATE)
				 IF sr[i].bmb08 IS NULL THEN LET sr[i].bmb08 = 0 END IF
                 LET l_material_t= l_material_t+ t_cost  #累計同階材料成本
	             LET l_add_val_t=l_add_val_t+(l_add_val*sr[i].bmb06/sr[i].bmb07
											*sr[i].bmb10_fac2)
											*(1+sr[i].bmb08/100)
	             LET l_ind_m_t=l_ind_m_t+(l_ind_m*sr[i].bmb06/sr[i].bmb07
											*sr[i].bmb10_fac2)
											*(1+sr[i].bmb08/100)
                #DISPLAY 'part no.:',sr[i].bmb03  AT 2,1    #CHI-A70049 mark
 
        END IF
        END FOR
        IF l_ac < arrno OR l_ac=1 THEN         # BOM單身已讀完
            EXIT WHILE
        ELSE
            LET b_seq = sr[arrno].bmb02
        END IF
    END WHILE
    RETURN l_material_t, l_labor_cost_t, l_ind_labor_t   ,l_fix_bud_t,
                         l_var_bud_t   , l_outside_cost_t,l_out_fix_bud_t,
                         l_out_var_bud_t,l_mac_cost_t    ,l_add_val_t ,
                         l_ind_m_t
END FUNCTION
 
#-----處理沒有下階的元件(P/V/W/Z)
FUNCTION p201_pvwz
(l_ima08,l_ima44,l_ima86,l_bmb03,l_ima53,l_imb318,l_imb311,yy,l_ima871,l_ima87)
 
 DEFINE unit_price    LIKE imb_file.imb311,  #材料成本
        l_ima08       LIKE ima_file.ima08,   #SOURCE CODE
        l_ima44       LIKE ima_file.ima44,   #採購單位
        l_ima86       LIKE ima_file.ima86,   #成本單位
        l_bmb03       LIKE bmb_file.bmb03,   #元件編號
        l_ima53       LIKE ima_file.ima53,   #最近採購單價
        l_imb318      LIKE imb_file.imb318,  #purchase cost
        l_imb311      LIKE imb_file.imb311,  #本階材料成本
		yy            LIKE ima_file.ima872,  #間接材料成本項目
        l_flag        LIKE type_file.chr1,                # flag  #No.FUN-680071 VARCHAR(1)
        l_factor      LIKE ima_file.ima86_fac,#factor
        l_imb         record like imb_file.*,
        l_iml         record like iml_file.*,
		l_ima871      LIKE ima_file.ima871,
		l_ima87       LIKE ima_file.ima87 ,
		ind_m         LIKE imb_file.imb318,    #No.FUN-680071 DECIMAL(20,6)
		add_val       LIKE csa_file.csa0312,    #No.FUN-680071 DECIMAL(20,6)
        l_return      LIKE type_file.chr1      # Prog. Version..: '5.30.06-13.03.12(01)               # SQLCA.sqlcode
 
 
#----->ZERO FLAG=FLAUSE,COPY RECORD FROM iml_file,imb_fie to csb_file,csa_file
 
 SELECT * INTO l_imb.* FROM imb_file WHERE imb01=l_bmb03 #料件
 IF SQLCA.sqlcode !=0
    THEN
         CALL p201_err(6,l_bmb03)
#        EXIT PROGRAM
 END IF
 IF cl_null(l_imb.imb311) THEN LET l_imb.imb311=0 END IF
 IF cl_null(l_imb.imb312) THEN LET l_imb.imb312=0 END IF
 IF cl_null(l_imb.imb3131) THEN LET l_imb.imb3131=0 END IF
 IF cl_null(l_imb.imb3132) THEN LET l_imb.imb3132=0 END IF
 IF cl_null(l_imb.imb314) THEN LET l_imb.imb314=0 END IF
 IF cl_null(l_imb.imb315) THEN LET l_imb.imb315=0 END IF
 IF cl_null(l_imb.imb316) THEN LET l_imb.imb316=0 END IF
 IF cl_null(l_imb.imb3171) THEN LET l_imb.imb3171=0 END IF
 IF cl_null(l_imb.imb3172) THEN LET l_imb.imb3172=0 END IF
 IF cl_null(l_imb.imb319) THEN LET l_imb.imb319=0 END IF
 IF cl_null(l_imb.imb318) THEN LET l_imb.imb318=0 END IF
 IF cl_null(l_imb.imb320) THEN LET l_imb.imb320=0 END IF
 IF cl_null(l_imb.imb321) THEN LET l_imb.imb321=0 END IF
 IF cl_null(l_imb.imb322) THEN LET l_imb.imb322=0 END IF
 IF cl_null(l_imb.imb3231) THEN LET l_imb.imb3231=0 END IF
 IF cl_null(l_imb.imb3232) THEN LET l_imb.imb3232=0 END IF
 IF cl_null(l_imb.imb324) THEN LET l_imb.imb324=0 END IF
 IF cl_null(l_imb.imb325) THEN LET l_imb.imb325=0 END IF
 IF cl_null(l_imb.imb326) THEN LET l_imb.imb326=0 END IF
 IF cl_null(l_imb.imb3271) THEN LET l_imb.imb3271=0 END IF
 IF cl_null(l_imb.imb3272) THEN LET l_imb.imb3272=0 END IF
 IF cl_null(l_imb.imb329) THEN LET l_imb.imb329=0 END IF
 IF cl_null(l_imb.imb330) THEN LET l_imb.imb330=0 END IF
 IF tm.lab_bud MATCHES '[Nn]'   #是否將非材料成本要素欄位全部清為零
    THEN
         INSERT INTO  csa_file(csa01         ,csa02  ,    csa03 ,
                               csa0301       ,csa0302,
							   csa0303       ,csa0304,
							   csa0305       ,csa0306,
							   csa0307       ,csa0308,
							   csa0309       ,csa0310,
							   csa0311       ,csa0312,
							   csa0321       ,csa0322,
							   csa0323       ,csa0324,
							   csa0325       ,csa0326,
							   csa0327       ,csa0328,
							   csa0329       ,csa0330,
							   csa0331       ,csaacti,
							   csauser       ,csagrup,
							   csamodu       ,csadate,
                               csaplant,csalegal,csaoriu,csaorig) #FUN-980002
                       VALUES (l_bmb03       ,tm.version,'3',
                                l_imb.imb311  , l_imb.imb312,
						    	l_imb.imb3131, l_imb.imb3132,
							    l_imb.imb314 , l_imb.imb315 ,
								l_imb.imb316 , l_imb.imb3171 ,
								l_imb.imb3172, l_imb.imb319 ,
								l_imb.imb318 , l_imb.imb320 ,
								l_imb.imb321 , l_imb.imb322,
								l_imb.imb3231, l_imb.imb3232,
								l_imb.imb324,  l_imb.imb325,
								l_imb.imb326,  l_imb.imb3271,
								l_imb.imb3272, l_imb.imb329,
								l_imb.imb330 ,   'Y'       ,
								g_user       ,g_grup       ,
								g_user       ,g_today,
                               g_plant,g_legal, g_user, g_grup) #FUN-980002      #No.FUN-980030 10/01/04  insert columns oriu, orig
             IF  g_sma.sma58 MATCHES '[Yy]' THEN
                 FOREACH pvwz_cursor USING l_bmb03 INTO l_iml.*
		             IF SQLCA.sqlcode !=0 THEN
                        ERROR 'iml_file' EXIT FOREACH END IF
		             CALL   insert_cote(l_bmb03,l_iml.iml02,l_iml.iml031,'3')
	                 END FOREACH
             END IF
			 LET unit_price=l_imb.imb318              #material cost
			 LET ind_m     =l_imb.imb318*l_ima871     #indirect material cost
#---> c.ADD VALUE 處理
#       -若不將人工/製費清空, 則直接將料件成本要素及成本項目
#        結構複製過來, 因此, 毋需再產生附加成本部份.
#            CALL s_add_val(l_bmb03,'1',tm.version) returning add_val
  ELSE
      IF l_ima08 MATCHES '[pP]'         #採購料件
		 THEN
			  LET unit_price=l_imb.imb318           #material cost
			  LET ind_m     =l_imb.imb318*l_ima871  #indirect material cost
		      CALL s_in_csa                               #放入採購成本
			       (l_bmb03,0,0,'3',unit_price,0,yy,ind_m,add_val,tm.version)
	          IF g_sma.sma58 MATCHES '[Yy]'  #有使用成本項目結構
	             THEN CALL insert_cote(l_bmb03,l_ima87,unit_price,'3') #本階材料
                      CALL insert_cote(l_bmb03,l_ima87,ind_m,'3')  #附加成本
	          END IF
              CALL s_add_val(l_bmb03,'3',tm.version)  RETURNING add_val
 
         ELSE  #SOURCE CODE =V,W,Z
			  LET unit_price=l_imb.imb311          #material cost
			  LET ind_m     =l_imb.imb311*l_ima871 #indirect material cost
              CALL s_in_csa                                #本階材料成本
				  (l_bmb03,0,0,'3',0,unit_price,yy,ind_m,add_val,tm.version)
              IF tm.free_stock MATCHES '[Nn]'      #大宗料件及雜項料件包含
				 THEN  LET unit_price = 0          #不包含時,不累算至上一階
					   LET ind_m=0
              END IF
	          IF g_sma.sma58 MATCHES '[Yy]'  #有使用成本項目結構
	             THEN CALL insert_cote(l_bmb03,l_ima87,unit_price,'3')
                      CALL insert_cote(l_bmb03,l_ima87,ind_m,'3')
	          END IF
              CALL s_add_val(l_bmb03,'3',tm.version)  RETURNING add_val
 
        END IF
 END IF
 
	 RETURN unit_price,add_val,ind_m
END FUNCTION
 
#---->1.新增最下階成本項目資料(成本=算出之單位成本)
FUNCTION insert_cote(part_no,cost_cote,s_material,l_status)
    DEFINE part_no LIKE ima_file.ima01,      #料件 NO.MOD-490217
		  cost_cote  LIKE csb_file.csb04,    # Prog. Version..: '5.30.06-13.03.12(06)       #成本項目
		  s_material LIKE csb_file.csb05,    #No.FUN-680071 DECIMAL(20,6) #成本
		  l_status   LIKE type_file.chr1,      # Prog. Version..: '5.30.06-13.03.12(01)      #1.proposed 2.current 3.propose
		  l_n       LIKE type_file.num5    #No.FUN-680071 SMALLINT
 
						
  IF part_no IS NULL THEN LET part_no=' ' END IF
#92/07/31 by pin
  IF cost_cote IS NULL OR cost_cote=' '
	 THEN LET cost_cote='NULL'
  END IF
  IF s_material IS NULL
	  THEN LET s_material=0
		   RETURN
   END IF
  SELECT count(*) INTO l_n FROM csb_file   WHERE csb01=part_no
									    	 AND csb02=tm.version
											 AND csb03=l_status
											 AND csb04=cost_cote
 IF l_n = 0
	THEN INSERT INTO csb_file (csb01 , csb02  ,   csb03,   csb04 ,   csb05,
                                   csbplant,csblegal) #FUN-980002
		      VALUES   (part_no, tm.version,l_status  ,cost_cote,s_material,
                                g_plant,g_legal) #FUN-980002
		 IF SQLCA.sqlcode !=0
            THEN ERROR 'insert part fail!!!' sleep 2
		 END IF
	ELSE UPDATE csb_file set csb05=csb05+s_material
									   WHERE csb01=part_no
										 AND csb02=tm.version
										 AND csb03=l_status
										 AND csb04=cost_cote
END IF
END FUNCTION
 
#---複製下階成本項目至本階(需考慮下階QPA,底數,損耗率)
FUNCTION insert_cote2(part_no,l_status)
    DEFINE part_no   LIKE ima_file.ima01,          #item no. NO.MOD-490217
           l_item    LIKE ima_file.ima01,          #item no. NO.MOD-490217
		  t_cost    LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)        #此料件的材料成本(含損耗率,需求量)
		  l_bmb06   LIKE bmb_file.bmb06,  #QPA
		  l_bmb07   LIKE bmb_file.bmb07,  #底數
		  l_bmb08   LIKE bmb_file.bmb08,  #scrap rate%
          l_bmb10_fac2 LIKE bmb_file.bmb10_fac2, #發料/成本轉換率
          l_csb04   LIKE csb_file.csb04,  #成本項目
          l_csb05   LIKE csb_file.csb05,  #成本
          l_n       LIKE type_file.num5,    #No.FUN-680071 SMALLINT
		  l_status  LIKE type_file.chr1      # Prog. Version..: '5.30.06-13.03.12(01)              #1.proposed 2.current 3.propose
 
 
    FOREACH insert_cote2 USING part_no,tm.effectiv,tm.effectiv
                 INTO l_item,l_bmb06,l_bmb07,l_bmb08,l_bmb10_fac2
    IF SQLCA.sqlcode !=0 THEN EXIT FOREACH END IF
{------>a."NULL" INITIALIZE TO ZERO}
    IF l_bmb06 IS NULL THEN LET l_bmb06=0 END IF
    IF l_bmb07 IS NULL THEN LET l_bmb07=1 END IF
    IF l_bmb08 IS NULL THEN LET l_bmb08=0 END IF
    IF l_bmb10_fac2 IS NULL THEN LET l_bmb10_fac2=1 END IF
{------>e.是否考慮損耗率}
     IF tm.e MATCHES '[Nn]' THEN LET l_bmb08=0 END IF
 
        FOREACH insert_cote_c USING l_item,tm.version,l_status
                 INTO l_csb04,l_csb05 #成本項目,成本
		IF SQLCA.sqlcode !=0 THEN EXIT FOREACH END IF
        #92/07/31 by pin
        IF l_csb04 IS NULL OR l_csb04=' '
	       THEN LET l_csb04='NULL'
        END IF
		IF l_csb05 IS NULL THEN LET l_csb05=0 END IF
#--->下階成本項目成本*下階QPA/底數*(1+SCRAP RATE)
        LET t_cost=l_csb05*l_bmb06/l_bmb07*(1+(l_bmb08/100))*l_bmb10_fac2
		IF t_cost IS NULL
		   THEN LET t_cost=0
			     CONTINUE FOREACH
		END IF
        SELECT count(*) INTO l_n FROM csb_file
										where csb01 = part_no
										  and csb02 = tm.version
										  and csb03 = l_status
										  and csb04 = l_csb04
        IF l_n=0
           THEN
              INSERT INTO csb_file (csb01, csb02  ,  csb03,   csb04 ,csb05 ,
                                    csbplant,csblegal) #FUN-980002
	     	         VALUES  (part_no, tm.version,l_status  ,  l_csb04,t_cost,
                                  g_plant,g_legal)     #FUN-980002
		
		      IF SQLCA.sqlcode !=0
		           THEN ERROR 'insert part fail!!!' sleep 2
              END IF
           ELSE UPDATE csb_file set csb05=csb05+t_cost
										where csb01 = part_no
										  and csb02 = tm.version
										  and csb03 = l_status
										  and csb04 = l_csb04
		END IF
		END FOREACH
	END FOREACH
   END FUNCTION
 
#----->計算除材料成本外之成本要素
 
FUNCTION lab_burden(l_aa,m_material)
 DEFINE l_aa RECORD
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb07 LIKE bmb_file.bmb07,    #底數
              bmb08 LIKE bmb_file.bmb08,    #scrap rate
              bmb10_fac2 LIKE bmb_file.bmb10_fac2, #發料/成本換算率
               bma01 LIKE bma_file.bma01,    #assembly part NO.MOD-490217
              ima08 LIKE ima_file.ima08,    #來源
              ima53 LIKE ima_file.ima53,    #最近採購單價(本幣)
              ima87 LIKE ima_file.ima87,    #材料成本項目
              ima871 LIKE ima_file.ima871,  #材料製造費用分攤率
              ima872 LIKE ima_file.ima872,  #材料製造費用成本項目
              ima44 LIKE ima_file.ima44,    #採購單位
              ima86 LIKE ima_file.ima86,    #成本單位
              ima34 LIKE ima_file.ima34,    #成本中心
              ima58 LIKE ima_file.ima58,    #最後人工工時
              ima873 LIKE ima_file.ima873,  #人工製/費用分攤率
              ima874 LIKE ima_file.ima874,  #人工製/費用成本項目
              imb311 LIKE imb_file.imb311,  #本階材料成本
              imb318 LIKE imb_file.imb318,  #採購成本
              imb316 LIKE imb_file.imb316,  #廠外加工成本
              imb3171 LIKE imb_file.imb3171,  #廠外加工固定製費
              imb3172 LIKE imb_file.imb3172   #廠外加工變動製費
          END RECORD,
         m_material LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
         m_ima873   LIKE ima_file.ima873,
         c1         LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
         c2  LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
         c3  LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
         c4  LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
         c5  LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
         c6  LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
         c7  LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
         c8  LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
         c9  LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
         c10 LIKE oeb_file.oeb13     #No.FUN-680071 DECIMAL(20,6)
 
 IF g_sma.sma23 IS NULL OR g_sma.sma23= ' '  #成本取得方式
						OR g_sma.sma23 NOT MATCHES '[123]'
	THEN #CALL cl_err(g_sma.sma23,'mfg6007',1)
		 LET g_sma.sma23='1'
		 CALL p201_err(3,l_aa.bmb03)
#        CALL p201_restore()
#        EXIT PROGRAM
 END IF
 
 CASE g_sma.sma23
	  WHEN '1'  CALL use_cost_center(l_aa.*,m_material,l_aa.ima873)
											         #成本取得方式,使用成本中心
                         returning c1,c2,c3,c4,c5,c6,c7,c8,c9,c10
 	  WHEN '2'  CALL use_rout_wc        #使用製程/工作站
                     (l_aa.bmb03,m_material,l_aa.ima873,l_aa.ima874,'r' )
                         returning c1,c2,c3,c4,c5,c6,c7,c8,c9,c10
      WHEN '3'                                  #成本取得方式,使用 '1' 或 '2'
	          IF l_aa.ima34 IS NOT NULL  AND l_aa.ima34 !=' '
				 THEN   CALL use_cost_center(l_aa.*,m_material,l_aa.ima873)
                         returning c1,c2,c3,c4,c5,c6,c7,c8,c9,c10
				 ELSE   CALL use_rout_wc
                        (l_aa.bmb03,m_material,l_aa.ima873,l_aa.ima874,'r')
                         returning c1,c2,c3,c4,c5,c6,c7,c8,c9,c10
			  END IF
      OTHERWISE    let c1=0    let c2=0
                   let c3=0    let c4=0
                   let c5=0    let c6=0
                   let c7=0    let c8=0
                   let c9=0    let c10=0
 END CASE
 IF c1 IS NULL THEN LET c1=0 END IF
 IF c2 IS NULL THEN LET c2=0 END IF
 IF c3 IS NULL THEN LET c3=0 END IF
 IF c4 IS NULL THEN LET c4=0 END IF
 IF c5 IS NULL THEN LET c5=0 END IF
 IF c6 IS NULL THEN LET c6=0 END IF
 IF c7 IS NULL THEN LET c7=0 END IF
 IF c8 IS NULL THEN LET c8=0 END IF
 IF c9 IS NULL THEN LET c9=0 END IF
 IF c10 IS NULL THEN LET c10=0 END IF
 RETURN c1,c2,c3,c4,c5,c6,c7,c8,c9,c10
END FUNCTION
 
FUNCTION use_cost_center(p_aa,p_material,l_ima873 )
DEFINE p_aa  RECORD
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb07 LIKE bmb_file.bmb07,    #底數
              bmb08 LIKE bmb_file.bmb08,    #scrap rate
              bmb10_fac2 LIKE bmb_file.bmb10_fac2, #發料/成本換算率
               bma01 LIKE bma_file.bma01,    #assembly part NO.MOD-490217
              ima08 LIKE ima_file.ima08,    #來源
              ima53 LIKE ima_file.ima53,    #最近採購單價(本幣)
              ima87 LIKE ima_file.ima87,    #材料成本項目
              ima871 LIKE ima_file.ima871,  #材料製造費用分攤率
              ima872 LIKE ima_file.ima872,  #材料製造費用成本項目
              ima44 LIKE ima_file.ima44,    #採購單位
              ima86 LIKE ima_file.ima86,    #成本單位
              ima34 LIKE ima_file.ima34,    #成本中心
              ima58 LIKE ima_file.ima58,    #最後人工工時
              ima873 LIKE ima_file.ima873,  #人工製/費用分攤率
              ima874 LIKE ima_file.ima874,  #人工製/費用成本項目
              imb311 LIKE imb_file.imb311,  #本階材料成本
              imb318 LIKE imb_file.imb318,  #採購成本
              imb316 LIKE imb_file.imb316,  #廠外加工成本
              imb3171 LIKE imb_file.imb3171,  #廠外加工固定製費
              imb3172 LIKE imb_file.imb3172   #廠外加工變動製費
          END RECORD,
    l_smh  RECORD LIKE smh_file.*,
    l_csa0301     LIKE csa_file.csa0301,
    l_csa0303     LIKE csa_file.csa0303,    #direct labor cost
    l_csa0304     LIKE csa_file.csa0304,    #indirect labor cost
    l_csa0305     LIKE csa_file.csa0305,    #fixed burden
    l_csa0306     LIKE csa_file.csa0306,    #variable burden
    l_csa0307     LIKE csa_file.csa0307,    #outside process cost
    l_csa0308     LIKE csa_file.csa0308,    #outside process fixed burden
    l_csa0309     LIKE csa_file.csa0308,    #outside process varia.burden
    l_csa0310     LIKE csa_file.csa0310,    #machine cost
    l_csa0312     LIKE csa_file.csa0312,    #add values
    x1,x2,x3,x4,x5,x6,x7,x8,x9 LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
	p_material    LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
    l_csa789      LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
	l_ima873      LIKE ima_file.ima873
 
    IF p_aa.ima08 MATCHES '[xX]' THEN RETURN 0,0,0,0,0,0,0,0,0,0 END IF
    IF p_aa.ima34 IS NULL  AND p_aa.ima08 NOT MATCHES '[xX]'
	   THEN # CALL cl_err(p_aa.ima34,'mfg6010',1)
			 CALL p201_err(4,p_aa.bmb03)
			LET  l_smh.smh303=0
			LET  l_smh.smh304=' '
			LET  l_smh.smh305=' '
			LET  l_smh.smh306=0
			LET  l_smh.smh307=' '
			LET  l_smh.smh308=0
			LET  l_smh.smh308=' '
 
#            CALL p201_restore()
#            EXIT PROGRAM
 END IF
 
 SELECT * INTO l_smh.*  FROM smh_file WHERE smh01=p_aa.ima34  #cost center no.
   IF SQLCA.sqlcode !=0 	  THEN  
               #CALL cl_err(p_aa.ima34,'mfg6010',1)   #No.FUN-660089
                CALL cl_err3("sel","smh_file",p_aa.ima34,"","mfg6010","","",1)     #No.FUN-660089
#           CALL p201_restore()
			CALL p201_err(1,p_aa.bmb03)
			LET  l_smh.smh303=0
			LET  l_smh.smh304=' '
			LET  l_smh.smh305=' '
			LET  l_smh.smh306=0
			LET  l_smh.smh307=' '
			LET  l_smh.smh308=0
			LET  l_smh.smh308=' '
   END IF
 
#---->本階 direct labor cost
   LET l_csa0303=p_aa.ima58*l_smh.smh303 #本階人工成本=最後人工工時*工資率
 
#---->本階 indirect labor cost
   LET l_csa0304=l_csa0303*p_aa.ima873   #間接人工費用=人工成本*分攤率
 
#---->本階 fixed/variable burden cost
   CASE l_smh.smh305
        WHEN '1' #製/費用分攤基準,為直接人工成本
        LET l_csa0305= l_csa0303  * l_smh.smh306 #人工成本*製費分攤率
        LET l_csa0306= l_csa0303  * l_smh.smh308 #人工成本*製費分攤率
        WHEN '2' #製/費用分攤基準,為直接人工小時
        LET l_csa0305= p_aa.ima58 * l_smh.smh306 #最後人工小時*製費成本率
        LET l_csa0306= p_aa.ima58 * l_smh.smh308 #最後人工小時*製費成本率
        WHEN '3' #製/費用分攤基準,為直接材料成本
#       SELECT csa0301 INTO l_csa0301 FROM csa_file WHERE csa01=p_aa.bmb03
#                                                     AND csa02=tm.version
#       IF SQLCA.sqlcode !=0 THEN LET l_csa0301=0 END IF
        LET l_csa0305= p_material * l_smh.smh306 #本階材料成本*製費分攤率
        LET l_csa0306= p_material * l_smh.smh308 #本階材料成本*製費分攤率
        WHEN '4' #製/費用分攤基準,為生產數量
        LET l_csa0305= l_smh.smh306             #製費分攤率(固定金額)
        LET l_csa0306= l_smh.smh308             #製費分攤率(固定金額)
        OTHERWISE LET l_csa0305=0
  END CASE
#----->本階廠外加工成本/outside process fix/variable burden cost/matchine cost
  CASE g_sma.sma61   #廠外加工成本取得方式,為僅使用料件主檔內的廠外加工成本
       WHEN '1' LET l_csa0307 = p_aa.imb316  #廠外加工成本
                LET l_csa0308 = p_aa.imb3171 #outside process fixed burden cost
                LET l_csa0309 = p_aa.imb3172 #outside process varia.burden cost
                LET l_csa0310 = 0            #不考慮機器成本machine cost
  #92/01/27 modify 若使用成本中心時,只能使用 '1' 方式
  #    WHEN '2' CALL use_rout_wc
  #                  (p_aa.bmb03,p_material,p_aa.ima873,p_aa.ima874,'c')
  #                  RETURNING x1,x2,x3,x4,x5,x6,x7,x8,x9
  #              LET l_csa0307=x5
  #              LET l_csa0308=x6
  #              LET l_csa0309=x7
  #              LET l_csa0310=x8
 
       OTHERWISE LET l_csa0307=0
                 LET l_csa0308=0
                 LET l_csa0309=0
				 LET l_csa0310=0
   END CASE
  IF g_sma.sma58 MATCHES '[Yy]'   #有使用成本項目結構
	 THEN
#---->增加各成本要素的成本項目
#---->人工成本項目
   IF l_smh.smh304 IS NULL THEN LET l_smh.smh304=' ' END IF
   CALL insert_cote (p_aa.bmb03,l_smh.smh304,l_csa0303,'3')
#---->間接人工成本項目
   IF p_aa.ima874 IS NULL then LET p_aa.ima874=' ' END IF
   CALL insert_cote (p_aa.bmb03,p_aa.ima874,l_csa0304,'3')
#---->固定製造費用成本項目
   IF l_smh.smh307 IS NULL THEN LET l_smh.smh307=' ' END IF
   CALL insert_cote (p_aa.bmb03,l_smh.smh307,l_csa0305,'3')
#---->變動製造費用成本項目
   IF l_smh.smh309 IS NULL THEN LET l_smh.smh309=' ' END IF
   CALL insert_cote (p_aa.bmb03,l_smh.smh309,l_csa0306,'3')
#------>92/07/31 BY pin
# d - 若使用成本中心計算其成本,且亦使用成本項目結構時,將
#   廠外加工成本/廠外加工固定/變動製造費用之成本相加,
#   彙集至成本項目編號 "UNKNOW"==>為了成本要素與成本
#   項目值能BALANCE.
    LET l_csa789=l_csa0307+l_csa0308+l_csa0309
   CALL insert_cote (p_aa.bmb03,'UNKNOW',l_csa789,'1')
#----->附加成本(add values)
   CALL s_add_val(p_aa.bmb03,'3',tm.version)  RETURNING l_csa0312
   END IF
 
 RETURN l_csa0303,l_csa0304,l_csa0305,l_csa0306,
        l_csa0307,l_csa0308,l_csa0309,l_csa0310,l_csa0312,0
 END FUNCTION
 
#----->更新料件各上/下階成本要素
 
FUNCTION lb_bd_update(x_item,u_a1,u_a2,u_a3,u_a4,u_a5,u_a6,u_a7,u_a8,u_a9,u_a10
		                    ,d_a1,d_a2,d_a3,d_a4,d_a5,d_a6,d_a7,d_a8,d_a9,d_a10)
 
DEFINE u_a1,u_a2,u_a3,u_a4,u_a5,u_a6,u_a7,u_a8,u_a9  LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6) #上階成本要素
       d_a1,d_a2,d_a3,d_a4,d_a5,d_a6,d_a7,d_a8,d_a9  LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6) #下階成本要素
       u_a10 LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)   #本階間接材料成本
       d_a10 LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)   #下階間接材料成本
       p_ln  LIKE type_file.num5,    #No.FUN-680071 smallint
        x_item LIKE csa_file.csa01  #NO.MOD-490217
						
 
	  SELECT COUNT(*) INTO p_ln FROM csa_file
								WHERE csa01=x_item     #item no.
								  AND csa02=tm.version #simulation version
      IF cl_null(u_a1) THEN LET u_a1=0 END IF
      IF cl_null(u_a2) THEN LET u_a2=0 END IF
      IF cl_null(u_a3) THEN LET u_a3=0 END IF
      IF cl_null(u_a4) THEN LET u_a4=0 END IF
      IF cl_null(u_a5) THEN LET u_a5=0 END IF
      IF cl_null(u_a6) THEN LET u_a6=0 END IF
      IF cl_null(u_a7) THEN LET u_a7=0 END IF
      IF cl_null(u_a8) THEN LET u_a8=0 END IF
      IF cl_null(u_a9) THEN LET u_a9=0 END IF
      IF cl_null(u_a10) THEN LET u_a10=0 END IF
      IF cl_null(d_a1) THEN LET d_a1=0 END IF
      IF cl_null(d_a2) THEN LET d_a2=0 END IF
      IF cl_null(d_a3) THEN LET d_a3=0 END IF
      IF cl_null(d_a4) THEN LET d_a4=0 END IF
      IF cl_null(d_a5) THEN LET d_a5=0 END IF
      IF cl_null(d_a6) THEN LET d_a6=0 END IF
      IF cl_null(d_a7) THEN LET d_a7=0 END IF
      IF cl_null(d_a8) THEN LET d_a8=0 END IF
      IF cl_null(d_a9) THEN LET d_a9=0 END IF
      IF cl_null(d_a10) THEN LET d_a10=0 END IF
	  IF p_ln!=0
		 THEN UPDATE csa_file
                     SET csa0302=u_a10,   #本階indirect material cost
					     csa0303=u_a1,    #本階direct labor cost
						 csa0304=u_a2,    #本階indirect labor cost
						 csa0305=u_a3,    #本階direct labor cost
						 csa0306=u_a4,    #本階fixed burden cost
						 csa0307=u_a5,    #本階variable burden cost
						 csa0308=u_a6,    #本階outside process cost
						 csa0309=u_a7,    #本階outside fixed burden cost
						 csa0310=u_a8,    #本階outside varia.burden cost
						 csa0312=u_a9,    #本階add value cost
 
                         csa0322=d_a10,    #下階indirect material cost
					     csa0323=d_a1,    #下階direct labor cost
						 csa0324=d_a2,    #下階indirect labor cost
						 csa0325=d_a3,    #下階direct labor cost
						 csa0326=d_a4,    #下階fixed burden cost
						 csa0327=d_a5,    #下階variable burden cost
						 csa0328=d_a6,    #下階outside process cost
						 csa0329=d_a7,    #下階outside fixed burden cost
						 csa0330=d_a8,    #下階outside varia.burden cost
						 csa0331=d_a9     #下階add value cost
					WHERE csa01=x_item     #item no.
					  AND csa02=tm.version #simulation version
         END IF
END FUNCTION
 
#--->人工成本取得方式為 -------製程與工作站--------------------
 
FUNCTION  use_rout_wc(w_item,w_material,w_ima873,w_ima874,l_flag)
   DEFINE w_item     LIKE ima_file.ima01,       #part no. NO.MOD-490217
         w_material LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)             #本階材料成本
         w_ima873   LIKE ima_file.ima873,      #間接材料製/費用分攤率
		 l_flag     LIKE type_file.chr1,                    #'c':cost center 'r':routing  #No.FUN-680071 VARCHAR(1)
         l_eca04 LIKE eca_file.eca04,
         l_eca06 LIKE eca_file.eca06,
		 l_eca14 LIKE eca_file.eca14,
		 l_eca15 LIKE eca_file.eca15,
		 l_eca26 LIKE eca_file.eca26,
		 l_eca27 LIKE eca_file.eca27,
		 l_eca28 LIKE eca_file.eca28,
		 l_eca29 LIKE eca_file.eca29,
		 l_eca30 LIKE eca_file.eca30,
		 l_eca31 LIKE eca_file.eca31,
		 l_eca301 LIKE eca_file.eca301,
		 l_eca311 LIKE eca_file.eca311,
		 l_eca32 LIKE eca_file.eca32,
		 l_eca33 LIKE eca_file.eca33,
		 l_eca34 LIKE eca_file.eca34,
		 l_eca35 LIKE eca_file.eca35,
		 l_eca43 LIKE eca_file.eca43,
		 l_eca44 LIKE eca_file.eca44,
		 l_eca45 LIKE eca_file.eca45,
		 l_eca46 LIKE eca_file.eca46,
		 l_eca47 LIKE eca_file.eca47,
         l_ecb03 LIKE ecb_file.ecb03,
		 l_ecb30 LIKE ecb_file.ecb30,
		 l_ecb31 LIKE ecb_file.ecb31,
		 l_ecb32 LIKE ecb_file.ecb32,
		 l_ecb33 LIKE ecb_file.ecb33,
		 l_ecb34 LIKE ecb_file.ecb34,
		 l_ecb35 LIKE ecb_file.ecb35,
		 l_ecb24 LIKE ecb_file.ecb24,
		 l_ecb25 LIKE ecb_file.ecb25,
         l_ecb15 LIKE ecb_file.ecb15,
         l_ecb16 LIKE ecb_file.ecb16,
		 l_ima561 LIKE ima_file.ima561,
		 l_csa0303 LIKE csa_file.csa0303,
		 l_csa0304 LIKE csa_file.csa0304,
		 l_csa0305 LIKE csa_file.csa0305,
		 l_csa0306 LIKE csa_file.csa0306,
		 l_csa0307 LIKE csa_file.csa0307,
		 l_csa0308 LIKE csa_file.csa0308,
		 l_csa0309 LIKE csa_file.csa0309,
		 l_csa0310 LIKE csa_file.csa0310,
		 l_csa0312 LIKE csa_file.csa0312,
         t_csa0304 LIKE csa_file.csa0304,
         t_csa0305 LIKE csa_file.csa0305,
         t_csa0306 LIKE csa_file.csa0306,
         t_csa0307 LIKE csa_file.csa0307,
         t_csa0308 LIKE csa_file.csa0308,
         t_csa0309 LIKE csa_file.csa0309,
         t_csa0310 LIKE csa_file.csa0310,
         x_csa0303 LIKE csa_file.csa0303,
         x_csa0310 LIKE csa_file.csa0310,
         x_lab_hour LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
         x_mat_hour LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
         l_ima571  LIKE ima_file.ima571,
         yn        LIKE type_file.chr1,      #No.FUN-680071 VARCHAR(01)
         l_ima55  LIKE ima_file.ima55,
         l_ima86  LIKE ima_file.ima86,
		 p_flag   LIKE type_file.num5,      #No.FUN-680071 SMALLINT
		 l_factor LIKE ima_file.ima86_fac,
         s_cmd   LIKE type_file.chr1000,   #No.FUN-680071 VARCHAR(500)
		 lab_hour,mat_hour LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
         setup_cost,run_cost LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
         mat_setup,mat_run   LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)
         w_ima874 LIKE ima_file.ima874
 
 
   		  LET l_csa0303=0 LET l_csa0304=0
		  LET l_csa0305=0 LET l_csa0306=0
		  LET l_csa0307=0 LET l_csa0308=0
		  LET l_csa0309=0 LET l_csa0310=0
		  LET l_csa0312=0
   SELECT ima571 INTO l_ima571 FROM ima_file WHERE ima01=w_item #料號
   IF SQLCA.sqlcode THEN LET l_ima571=' ' END IF
 
  IF l_ima571 IS NULL OR l_ima571=' '   #表有自己製程,並非與其他料件共用
     THEN OPEN wc_rout_cur USING w_item,tm.effectiv,tm.effectiv
  ELSE    OPEN wc_rout_cur USING l_ima571,tm.effectiv,tm.effectiv
  END IF
  LET yn=0
 
 WHILE TRUE
 
  FETCH  wc_rout_cur INTO l_eca04, l_eca06, l_eca14, l_eca15,
                          l_eca26, l_eca27, l_eca28,
                          l_eca29, l_eca30, l_eca31, l_eca301,
                          l_eca311,l_eca32, l_eca33, l_eca34,
						  l_eca35, l_eca43, l_eca44, l_eca45,
						  l_eca46, l_eca47, l_ecb03,l_ecb30, l_ecb31,
						  l_ecb32, l_ecb33, l_ecb34, l_ecb35,
						  l_ecb24, l_ecb25, l_ecb15, l_ecb16,l_ima561
  IF SQLCA.sqlcode = NOTFOUND THEN EXIT WHILE END IF
  LET yn=yn+1     #判斷是否有製程資料
 
  IF l_ecb16 IS NULL OR  l_ecb16=0 THEN LET l_ecb16=1 END IF
  IF l_ima561 IS NULL OR  l_ima561=0 THEN LET l_ima561=1 END IF
  IF l_ecb31  IS NULL OR  l_ecb31=0 THEN LET l_ecb31=1 END IF
     LET setup_cost=0   LET run_cost=0
     LET lab_hour  =0   LET mat_hour=0
     LET mat_setup =0   LET mat_run =0
  IF l_eca04 ='0'  #正常工作站
	 THEN
	   CASE l_eca06
	   WHEN '2'   #人工產能
		  IF l_eca14='2'   #unit/hour   #僅run time 考慮
			 THEN LET setup_cost=(l_ecb30/l_ima561/60*l_eca26)   #設置成本
			      LET   run_cost=(1/l_ecb31/60*l_eca28)          #生產成本
                 LET x_csa0303=setup_cost+run_cost
                 LET l_csa0303=l_csa0303 +      #直接人工成本
                               x_csa0303
                  LET x_lab_hour= (l_ecb30/l_ima561/60)
							    +(1/l_ecb31/60)
		          LET lab_hour =lab_hour +      #直接人工小時
                              x_lab_hour
			 ELSE LET setup_cost=(l_ecb30/l_ima561/60*l_eca26)    #設置成本
                  LET   run_cost=(l_ecb31/60*l_eca28)             #生產成本
                  LET x_csa0303=setup_cost+run_cost
                  LET l_csa0303=l_csa0303 +      #直接人工成本
                                x_csa0303
                  LET x_lab_hour= (l_ecb30/l_ima561/60)
							    +(l_ecb31/60)
		          LET lab_hour =lab_hour +       #直接人工小時
                              x_lab_hour
		   END IF
	   WHEN '1'  #機器產能
		  IF l_eca14='2'  #unit/hour
			 THEN  #--------直接人工成本-----#
				   LET setup_cost=(l_ecb32/l_ima561/60*l_ecb15/l_ecb16*l_eca26)
				   LET   run_cost=(1/l_ecb33/60*l_ecb15/l_ecb16*l_eca28)
                   LET x_csa0303=setup_cost+run_cost
				   LET l_csa0303=l_csa0303 +      #直接人工成本
                                 x_csa0303
				   #--------直接人工小時----#
                  LET x_lab_hour= (l_ecb32/l_ima561/60*l_ecb15/l_ecb16)
							    +(1/l_ecb33/60*l_ecb15/l_ecb16)
				  LET lab_hour =lab_hour +      #直接人工小時
                              x_lab_hour
                 #--------機器成本---------#
				  LET  mat_setup =(l_ecb32/l_ima561/60*l_eca30) #機器設置成本
				  LET  mat_run   =(1/l_ecb33/60*l_eca301)       #機器生產成本
                  LET x_csa0310= mat_setup+mat_run
				  LET l_csa0310= l_csa0310+       #機器成本
                                 x_csa0310
				  #------機器小時----------#
                  LET x_mat_hour= (l_ecb32/l_ima561/60)
							    +(1/l_ecb33/60)
				  LET mat_hour=mat_hour  +       #機器小時
                             x_mat_hour
			 ELSE  #--------直接人工成本-----#
				   LET setup_cost=(l_ecb32/l_ima561/60*l_ecb15/l_ecb16*l_eca26)
				   LET run_cost=(l_ecb33/60*l_ecb15/l_ecb16*l_eca28)
                  LET x_csa0303=setup_cost+run_cost
				  LET l_csa0303=l_csa0303 +     #直接人工成本
                                x_csa0303
				   #--------直接人工小時----#
                  LET x_lab_hour= (l_ecb32/l_ima561/60*l_ecb15/l_ecb16)
							    +(l_ecb33/60*l_ecb15/l_ecb16)
				  LET lab_hour =lab_hour +      #直接人工小時
                              x_lab_hour
                 #--------機器成本---------#
				  LET  mat_setup =(l_ecb32/l_ima561/60*l_eca30) #機器設置成本
				  LET  mat_run   =(l_ecb33/60*l_eca301)         #機器生產成本
                  LET x_csa0310= mat_setup+mat_run
				  LET l_csa0310= l_csa0310+       #機器成本
                                 x_csa0310
				  #------機器小時----------#
                  LET x_mat_hour= (l_ecb32/l_ima561/60)
							    + (l_ecb33/60)
				  LET mat_hour =mat_hour +       #機器小時
                              x_mat_hour
			END IF
	END CASE
#---->計算indirect labor cost
#---->當為人工產能只能以[1256]計算其製/費用
#---->當為機器產能只能以[3456]計算其製/費用
#     直接人工成本*直接人工製/費用分攤率
           LET t_csa0304=x_csa0303*w_ima873
           LET l_csa0304=l_csa0304+t_csa0304
           CASE l_eca15
                   WHEN '1' #直接人工成本
                   IF l_eca06 = '2'    #人工產能
                     THEN LET t_csa0305=x_csa0303*l_eca32
                          LET t_csa0306=x_csa0303*l_eca34
                          LET l_csa0305=l_csa0305+t_csa0305
                          LET l_csa0306=l_csa0306+t_csa0306
                   END IF
                   WHEN '2' #直接人工小時
                   IF l_eca06 = '2'
                     THEN LET t_csa0305=x_lab_hour*l_eca32
                          LET t_csa0306=x_lab_hour*l_eca34
                          LET l_csa0305=l_csa0305+t_csa0305
                          LET l_csa0306=l_csa0306+t_csa0306
                   END IF
                   WHEN '3' #機器成本
                    IF l_eca06='1'      #機器產能
                      THEN LET t_csa0305=x_csa0310*l_eca32
                           LET t_csa0306=x_csa0310*l_eca34
                           LET l_csa0305=l_csa0305+t_csa0305
                           LET l_csa0306=l_csa0306+t_csa0306
                    END IF
                   WHEN '4' #機器小時
                    IF l_eca06='1'      #機器產能
                       THEN LET t_csa0305=x_mat_hour*l_eca32
                            LET t_csa0306=x_mat_hour*l_eca34
                            LET l_csa0305=l_csa0305+t_csa0305
                            LET l_csa0306=l_csa0306+t_csa0306
                    END IF
                   WHEN '5' #直接材料成本
                    LET t_csa0305=w_material*l_eca32
                    LET t_csa0306=w_material*l_eca34
                    LET l_csa0305=l_csa0305+t_csa0305
                    LET l_csa0306=l_csa0306+t_csa0306
                   WHEN '6' #生產數量
                    LET t_csa0305=l_eca32
                    LET t_csa0306=l_eca34
                    LET l_csa0305=l_csa0305+t_csa0305
                    LET l_csa0306=l_csa0306+t_csa0306
                   OTHERWISE
                    LET l_csa0305= l_csa0305+0
                    LET l_csa0306= l_csa0306+0
                  END CASE
#----------->增加各成本要素的成本項目
#---因此段在使用cost center算時, 被使用到(在廠外加工資料取得方式='2' 時)
        IF g_sma.sma58 MATCHES '[Yy]'
           THEN
#-----人工設置成本項目-----
               IF l_flag!='c'   #'c' 表在使用cost center方式時,已產生過了
                  THEN IF l_eca27 IS NULL THEN LET l_eca27=' ' END IF
                       CALL insert_cote (w_item,l_eca27,setup_cost,'3')
                            LET setup_cost=0
               END IF
#-----人工生產成本項目-----
              IF l_flag!='c'   #'c' 表在使用cost center方式時,已產生過了
                 THEN IF l_eca29 IS NULL THEN LET l_eca29=' ' END IF
                     CALL insert_cote (w_item,l_eca29,run_cost,'3')
                          LET run_cost=0
              END IF
#-----間接人工成本項目-----
              IF l_flag!='c'
                 THEN IF w_ima874 IS NULL THEN LET w_ima874=' ' END IF
                      CALL insert_cote
                           (w_item,w_ima874,t_csa0304,'3')
               END IF
#-----機器設置成本項目-----
              IF l_eca31 IS NULL THEN LET l_eca31=' ' END IF
              CALL insert_cote (w_item,l_eca31,mat_setup,'3')
#-----機器生產成本項目-----
              IF l_eca311 IS NULL THEN LET l_eca311=' ' END IF
              CALL insert_cote (w_item,l_eca311,mat_run,'3')
#-----固定製/費用成本項目
             IF l_flag!='c'   #'c' 表在使用cost center方式時,已產生過了
                THEN IF l_eca33 IS NULL THEN LET l_eca33=' ' END IF
                     CALL insert_cote (w_item,l_eca33,t_csa0305,'3')
             END IF
#-----變動製/費用成本項目
            IF l_flag!='c'   #'c' 表在使用cost center方式時,已產生過了
               THEN IF l_eca35 IS NULL THEN LET l_eca35=' ' END IF
                    CALL insert_cote (w_item,l_eca35,t_csa0306,'3')
            END IF
 ELSE   #廠外/廠內加工
     LET l_csa0307=l_csa0307+l_ecb35
     IF l_eca04 = '2'
        THEN LET t_csa0308=l_ecb35*l_eca44
             LET t_csa0309=l_ecb35*l_eca46
             LET l_csa0308=l_csa0308+t_csa0308
             LET l_csa0309=l_csa0309+t_csa0309
     END IF
#-----廠外加工成本項目
    IF g_sma.sma58 MATCHES '[Yy]'
       THEN IF l_eca43 IS NULL THEN LET l_eca43=' ' END IF
            CALL insert_cote (w_item,l_eca43,l_ecb35,'3')
#-----廠外加工固定製/費用成本項目
            IF l_eca45 IS NULL THEN LET l_eca45=' ' END IF
            CALL insert_cote (w_item,l_eca45,t_csa0308,'3')
#-----廠外加工變動製/費用成本項目
           IF l_eca47 IS NULL THEN LET l_eca47=' ' END IF
           CALL insert_cote (w_item,l_eca47,t_csa0309,'3')
        END IF
     END IF
END IF
 
END WHILE
CLOSE wc_rout_cur
IF yn=0
   THEN  CALL p201_err(8,w_item)
   END IF
 
#----->附加成本(add values)
 IF l_flag !='c'
    THEN CALL s_add_val(w_item,'3',tm.version)  RETURNING l_csa0312
 END IF
#--->算出結果為生產單位, 需轉成成本單位
   SELECT ima55,ima86 INTO l_ima55,l_ima86 FROM ima_file WHERE ima01=w_item
   IF SQLCA.sqlcode THEN LET l_ima55=' '   LET l_ima86=' ' END IF
   IF l_ima55 != l_ima86
      THEN CALL  s_umfchk(w_item,l_ima55,l_ima86) returning p_flag,l_factor
           IF p_flag THEN
              ##Modify:98/11/13 ----單位換算率抓不到時show error message--#
                         #LET l_factor=1
                         CALL cl_err(w_item,'mfg6043',1)
                          CALL p201_err(9,w_item)
           END IF
           LET l_csa0303=l_csa0303*l_factor
           LET l_csa0304=l_csa0304*l_factor
           LET l_csa0305=l_csa0305*l_factor
           LET l_csa0306=l_csa0306*l_factor
           LET l_csa0307=l_csa0307*l_factor
           LET l_csa0308=l_csa0308*l_factor
           LET l_csa0309=l_csa0309*l_factor
           LET l_csa0310=l_csa0310*l_factor
   END IF
# l_csa0312 為成本單位,故不需轉換
 
RETURN l_csa0303,l_csa0304,l_csa0305,l_csa0306,
       l_csa0307,l_csa0308,l_csa0309,l_csa0310,
       l_csa0312,0
END FUNCTION
 
FUNCTION insert_csc()
 
   INSERT INTO csc_file (csc01   ,   csc02    ,   csc03    ,
                         csc04   ,   csc05    ,   csc06    ,
                         csc07   ,   csc08    ,   csc09    ,
						 csc10   ,   csc11    ,   csc12    ,
						 csc13   ,   csc14    ,   csc15    ,
						 csc16 )
				VALUES(tm.version,   '3'      ,  g_today   ,
					   l_time    ,  p_time    ,  g_user    ,
					   ' '       ,tm.effectiv ,   1        ,
					   tm.free_stock,' '      ,'  '        ,
					   tm.lab_bud   ,'Y'      , tm.x       ,
					   tm.i)
#CHI-A70049---mark---start---
 #IF SQLCA.sqlcode !=0
	#THEN call p201_err(14,tm.version)
	#ELSE DISPLAY ' ' AT 2,1
 #END IF
#CHI-A70049---mark---end---
 
  DELETE from csb_file where csb05=0 or csb05 is null
 
END FUNCTION
 
 
FUNCTION p201_err(p_code,p_part)
DEFINE
	p_code LIKE type_file.num5,      #No.FUN-680071 SMALLINT
	p_part LIKE ima_file.ima01,
        g_msg  LIKE ze_file.ze03,      #No.FUN-680071 VARCHAR(60)
	l_which LIKE type_file.chr8    #No.FUN-680071 VARCHAR(08)
 
#CHI-A70049---mark---start---
	#IF g_err THEN
		#DISPLAY "" AT 4,1
		#DISPLAY ' [ERROR] ' AT 4,1
		#DISPLAY m_err[p_code] CLIPPED  AT 4,10
	#END IF
#CHI-A70049---mark---end---
 	OUTPUT TO REPORT p201_log(p_part,m_err[p_code])
	LET g_err=g_err+1
END FUNCTION
 
#-------------------------------------------------------------------#
#  Exception Report                                        			#
#-------------------------------------------------------------------#
 
REPORT p201_log(sr)
DEFINE
	l_trailer_sw LIKE type_file.chr1,      #No.FUN-680071 VARCHAR(1)
	sr RECORD
		part LIKE ima_file.ima01,
		msg  LIKE ze_file.ze03         #No.FUN-680071 VARCHAR(60)
	END RECORD
 
	OUTPUT
		TOP MARGIN g_top_margin
		LEFT MARGIN g_left_margin
		BOTTOM MARGIN g_bottom_margin
		PAGE LENGTH g_page_line
 
	ORDER BY sr.part
 
	FORMAT
		PAGE HEADER
			PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
			PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
			PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
			PRINT ' '
			PRINT g_x[2] CLIPPED,g_today,' ' ,TIME,
				COLUMN g_len-8,g_x[3] CLIPPED,PAGENO USING '<<<'
			PRINT g_dash[1,g_len]
			PRINT g_x[11]
			PRINT '-------------------- -------------------',
				'--------------------------------------'
			LET l_trailer_sw = 'y'
		BEFORE GROUP OF sr.part #part no.
			PRINT sr.part;
		ON EVERY ROW
			PRINT COLUMN 22,sr.msg
		ON LAST ROW
            CALL cl_getmsg('mfg6016',g_lang) RETURNING l_msg
            PRINT  l_msg
            CALL cl_getmsg('mfg6017',g_lang) RETURNING l_msg
            PRINT  l_msg
			PRINT g_dash[1,g_len]
			PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
			LET l_trailer_sw = 'n'
		PAGE TRAILER
			IF l_trailer_sw = 'y' THEN
				PRINT g_dash[1,g_len]
				PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
			ELSE
				SKIP 2 LINE
			END IF
END REPORT
 
FUNCTION p201_mess()
  DEFINE i LIKE type_file.num5,    #No.FUN-680071 SMALLINT
         l_which LIKE type_file.chr8      #No.FUN-680071 VARCHAR(08)
 
FOR i=1  TO 14
	LET g_msg=''
	LET l_which='mfg70',i USING '&&'
	CALL cl_getmsg(l_which,g_lang) RETURNING g_msg
    LET m_err[i]=g_msg
END FOR
 
END FUNCTION
#Patch....NO.TQC-610035 <001> #
#TQC-790177
