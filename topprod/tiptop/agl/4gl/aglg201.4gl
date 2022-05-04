# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aglg201.4gl
# Descriptions...: 帳款分類帳列印作業
# Input parameter: 
# Return code....: 
# Date & Author..: NO.FUN-5C0015 By TSD.miki 05/12/16
# Modify.........: No.FUN-640255 06/04/27 By Sarah 損益科目也要有餘額,格式同"資產類"
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/29 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-670005 06/07/07 By Hellen 帳別權限修改
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-740020 07/04/10 By Lynn 會計科目加帳套
# Modify.........: No.TQC-760154 07/08/03 By Rayven 新增原幣幣種欄位，新增打印原幣余額
# Modify.........: No.FUN-830092 08/03/27 By sherry 報表改由CR輸出
# Modify.........: No.MOD-860331 08/07/08 By Sarah FOR i = 1 TO 300->300改為l_wc的總長度
# Modify.........: No.MOD-8A0069 08/10/09 By Sarah 本幣餘額,原幣餘額計算錯誤,沒有累加
# Modify.........: No.MOD-8B0115 08/11/12 By Sarah 原幣餘額沒有顯示
# Modify.........: No.MOD-8B0139 08/11/14 By Sarah 原幣餘額沒有做取位
# Modify.........: No.MOD-8C0087 08/12/12 By Sarah 將aglg201_cur()裡l_sql過濾前期年月條件改寫為npr04*12+npr05<tm.yy*12+tm.m1
# Modify.........: No.MOD-930120 09/03/11 By lilingyu 改正期初值捉不進來的錯誤
# Modify.........: No.MOD-930326 09/04/01 By Sarah 對象簡稱未帶出
# Modify.........: No.MOD-950035 09/05/06 By lilingyu 增加以sr.npq03串到aag_file抓取sr.aag02
# Modify.........: No.MOD-950215 09/05/21 By lilingyu SQL里原先只抓npr08=g_plant,改抓(npr08=g_plant OR npr08 = ' ')
# Modify.........: No.MOD-950225 09/05/21 By lilingyu 修改替換字符的寫法 避免程序down出
# Modify.........: No.MOD-960027 09/06/06 By Sarah 若該科目有前期餘額但無本期異動也應顯示出前期餘額資料
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No.FUN-B80158 11/09/22 By yangtt 明細類CR轉換成GRW
# Modify.........: No.FUN-C20073 12/03/05 By qirl
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                            # Print condition RECORD
           wc       LIKE type_file.chr1000,  # Where condition     #No.FUN-680098  VARCHAR(600)
           yy,m1,m2 LIKE type_file.num10,    #No.FUN-680098    integer
           o        LIKE aaa_file.aaa01,     #帳別             #No.FUN-670039
           a        LIKE type_file.chr1,     #是否列印原幣     #No.FUN-680098 VARCHAR(1) 
           b        LIKE type_file.chr1,     #科目類別(1:資料類  2:損益類)  #No.FUN-680098  VARCHAR(1)   
           d        LIKE type_file.chr4,     #No.TQC-760154
           s        LIKE type_file.chr2,     #No.FUN-680098    VARCHAR(2)
           t        LIKE type_file.chr2,     #No.FUN-680098    VARCHAR(2)
           u        LIKE type_file.chr2,     #No.FUN-680098    VARCHAR(2) 
           more     LIKE type_file.chr1      # Input more condition(Y/N)   #No.FUN-680098  VARCHAR(1)
           END RECORD
DEFINE g_bdate,g_edate   LIKE type_file.dat                     #No.FUN-680098  date
DEFINE g_orderA          ARRAY[2] OF LIKE type_file.chr20       #No.FUN-680098  VARCHAR(20) 
DEFINE g_wcA             ARRAY[2] OF LIKE type_file.chr1000     #No.FUN-680098  VARCHAR(30)
DEFINE g_chr             LIKE type_file.chr1                    #No.FUN-680098  VARCHAR(1)
DEFINE g_i               LIKE type_file.num5       #count/index for any purpose  #No.FUN-680098 SMALLINT
DEFINE g_sum             LIKE npq_file.npq07       #前期餘額                     #No.FUN-680098 decimal(20,6)
DEFINE g_sum2            LIKE npq_file.npq07f      #原幣前期餘額 #No.TQC-760154
DEFINE   g_str           STRING                                                 
DEFINE   g_sql           STRING                                                 
DEFINE   g_sql2          STRING                    #FUN-B80158 add              
DEFINE   g_sql1          STRING                    #FUN-B80158 add              
DEFINE   l_table         STRING                                                 
DEFINE buf               base.StringBuffer     #MOD-950225 
 
###GENGRE###START
TYPE sr1_t RECORD
    #FUN-B80158-----add-----str---
    order1 LIKE npq_file.npq21,
    order2 LIKE npq_file.npq21,
    #FUN-B80158-----add-----end---
    npq03 LIKE npq_file.npq03,
    aag02 LIKE aag_file.aag02,
    aza17 LIKE aza_file.aza17,
    l_sum LIKE type_file.num20_6,
    l_sum2 LIKE type_file.num20_6,
    npq21 LIKE npq_file.npq21,
    npq22 LIKE npq_file.npq22,
    nppsys LIKE npp_file.nppsys,
    npp02 LIKE npp_file.npp02,
    nppglno LIKE npp_file.nppglno,
    npp01 LIKE npp_file.npp01,
    npq24 LIKE npq_file.npq24,
    npq07 LIKE npq_file.npq07,
    npq07f LIKE npq_file.npq07f,
    npq07_2 LIKE npq_file.npq07,
    npq07f_2 LIKE npq_file.npq07f,
    npq06 LIKE npq_file.npq06,
    npq05 LIKE npq_file.npq05,
    npr00 LIKE npr_file.npr00,
    npr01 LIKE npr_file.npr01,
    npr03 LIKE npr_file.npr03,
    npp00 LIKE npp_file.npp00,
    sum LIKE npq_file.npq07f,
    sum2 LIKE npq_file.npq07f,
    azi04 LIKE azi_file.azi04,
    line LIKE type_file.num5
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET g_sql = 
               #FUN-B80158-----add-----str---
               "order1.npq_file.npq21,",
               "order2.npq_file.npq21,",
               #FUN-B80158-----add-----end---
               "npq03.npq_file.npq03,    aag02.aag_file.aag02,",
               "aza17.aza_file.aza17,    l_sum.type_file.num20_6,",
               "l_sum2.type_file.num20_6,",   #MOD-8B0115 add
               "npq21.npq_file.npq21,    npq22.npq_file.npq22,",
               "nppsys.npp_file.nppsys,  npp02.npp_file.npp02,",
               "nppglno.npp_file.nppglno,npp01.npp_file.npp01,",
               "npq24.npq_file.npq24,    npq07.npq_file.npq07,",
               "npq07f.npq_file.npq07f,  npq07_2.npq_file.npq07,",
               "npq07f_2.npq_file.npq07f,npq06.npq_file.npq06,",
               "npq05.npq_file.npq05,    npr00.npr_file.npr00,",
               "npr01.npr_file.npr01,    npr03.npr_file.npr03,",
               "npp00.npp_file.npp00,    sum.npq_file.npq07f,",
               "sum2.npq_file.npq07f,    azi04.azi_file.azi04,",
               "line.type_file.num5"   #MOD-8A0069 add
 
   LET l_table = cl_prt_temptable('aglg201',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",          
               "        ?,?,?,?,?, ?,?,?)"    #MOD-8A0069 add ?  #MOD-8B0115 add ?    #FUN-B80158 add 2?
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
   LET g_pdate  = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.s     = ARG_VAL(8)
   LET tm.t     = ARG_VAL(9)
   LET tm.u     = ARG_VAL(10)
   LET tm.yy    = ARG_VAL(11)
   LET tm.m1    = ARG_VAL(12)
   LET tm.m2    = ARG_VAL(13)
   LET tm.o     = ARG_VAL(14)
   LET tm.a     = ARG_VAL(15)
   LET tm.b     = ARG_VAL(16)
   LET g_rep_user = ARG_VAL(17)
   LET g_rep_clas = ARG_VAL(18)
   LET g_template = ARG_VAL(19)
   LET tm.d     = ARG_VAL(20)    #No.TQC-760154
   LET g_rpt_name = ARG_VAL(21)  #No.FUN-7C0078
 
   IF cl_null(tm.o) THEN
      LET tm.o = g_aza.aza81
   END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N'  # If background job sw is off
      THEN CALL aglg201_tm(0,0)          # Input print condition
      ELSE CALL aglg201()                # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglg201_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01       #No.FUN-580031
   DEFINE l_aziacti      LIKE azi_file.aziacti     #No.TQC-760154
   DEFINE p_row,p_col    LIKE type_file.num5       #No.FUN-680098 smallint
   DEFINE l_cmd          LIKE type_file.chr1000    #No.FUN-680098 VARCHAR(400)
   DEFINE li_chk_bookno  LIKE type_file.num5       #No.FUN-670005    #No.FUN-680098  smallint
 
   LET p_row = 2 LET p_col = 18
   OPEN WINDOW aglg201_w AT p_row,p_col WITH FORM "agl/42f/aglg201" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   LET tm.yy    = YEAR(TODAY)
   LET tm.m1    = MONTH(TODAY)
   LET tm.m2    = MONTH(TODAY)
   LET tm.a     = 'N'
   LET tm.b     = '1'
   LET tm.s     = '12'
   LET tm.t     = ' '
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
 
WHILE TRUE
   DISPLAY BY NAME tm.yy,tm.m1,tm.m2,tm.o,tm.a,tm.b,tm.more
   CONSTRUCT BY NAME tm.wc ON npq03, npq21,npq22,npq05  
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
      ON ACTION locale
         CALL cl_show_fld_cont()
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aglg201_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
   INPUT BY NAME tm.yy,tm.m1,tm.m2,tm.o,tm.a,tm.d,tm.b,  #No.TQC-760154 add tm.d
                 tm2.s1,tm2.s2,
                 tm2.t1,tm2.t2,
                 tm2.u1,tm2.u2,
                 tm.more
         WITHOUT DEFAULTS 
 
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD yy
         IF cl_null(tm.yy) THEN
            CALL cl_err('','aap-099',0)
            NEXT FIELD yy
         END IF
 
      AFTER FIELD m1
         IF cl_null(tm.m1) THEN
            CALL cl_err('','aap-099',0) 
            NEXT FIELD m1
         END IF
 
      AFTER FIELD m2
         IF cl_null(tm.m2) THEN
            CALL cl_err('','aap-099',0)
            NEXT FIELD m2
         END IF
         IF tm.m2 < tm.m1 THEN
            CALL cl_err('','agl-157',0)
            NEXT FIELD m1
         END IF
 
      AFTER FIELD o
         IF cl_null(tm.o) THEN 
            CALL cl_err('','mfg3018',0)
            NEXT FIELD o 
         END IF
             CALL s_check_bookno(tm.o,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                  NEXT FIELD o 
             END IF 
         SELECT aaa01 FROM aaa_file WHERE aaa01 = tm.o
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","aaa_file",tm.o,"","aap-229","","",0)   #No.FUN-660123
            NEXT FIELD o
         END IF
  
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
            NEXT FIELD a
         END IF
         IF tm.a = 'N' THEN
            LET tm.d = NULL
            DISPLAY BY NAME tm.d
         END IF
         IF tm.a = 'Y' THEN
            CALL cl_set_comp_entry('d',TRUE)
         ELSE
            CALL cl_set_comp_entry('d',FALSE)
         END IF
 
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[12]' THEN
            NEXT FIELD b
         END IF
 
      BEFORE FIELD d
         IF tm.a = 'Y' THEN
            CALL cl_set_comp_entry('d',TRUE)
         ELSE
            CALL cl_set_comp_entry('d',FALSE)
         END IF
 
      AFTER FIELD d
         SELECT azi01 FROM azi_file WHERE azi01 = tm.d
         IF SQLCA.sqlcode THEN
            CALL cl_err(tm.d,'agl-109',0)
            NEXT FIELD d
         END IF
         SELECT aziacti INTO l_aziacti FROM azi_file
          WHERE zai01 = tm.d
         IF l_aziacti <> 'Y' THEN
            CALL cl_err(tm.d,'ggl-998',0)
            NEXT FIELD d
         END IF
         IF tm.a = 'N' THEN
            LET tm.d = NULL
            DISPLAY BY NAME tm.d
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT  
         IF INT_FLAG THEN EXIT INPUT END IF
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
         LET tm.t = tm2.t1,tm2.t2
         LET tm.u = tm2.u1,tm2.u2
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(d)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_azi'
               LET g_qryparam.default1 = tm.d
               CALL cl_create_qry() RETURNING tm.d
               DISPLAY tm.d TO FORMONLY.d
               NEXT FIELD d
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aglg201_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aglg201'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglg201','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                     " '",g_pdate  CLIPPED,"'",
                     " '",g_towhom CLIPPED,"'",
                     " '",g_rlang CLIPPED,"'",  #No.FUN-7C0078
                     " '",g_bgjob  CLIPPED,"'",
                     " '",g_prtway CLIPPED,"'",
                     " '",g_copies CLIPPED,"'",
                     " '",tm.wc CLIPPED,"'",
                     " '",tm.s  CLIPPED,"'",
                     " '",tm.t  CLIPPED,"'",
                     " '",tm.u  CLIPPED,"'",
                     " '",tm.yy CLIPPED,"'",
                     " '",tm.m1 CLIPPED,"'",
                     " '",tm.m2 CLIPPED,"'",
                     " '",tm.o  CLIPPED,"'",
                     " '",tm.a  CLIPPED,"'",
                     " '",tm.b  CLIPPED,"'",
                     " '",g_rep_user CLIPPED,"'",
                     " '",g_rep_clas CLIPPED,"'",
                     " '",g_template CLIPPED,"'",
                     " '",tm.d  CLIPPED,"'"       #No.TQC-760154
         CALL cl_cmdat('aglg201',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aglg201_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aglg201()
   ERROR ""
END WHILE
   CLOSE WINDOW aglg201_w
END FUNCTION
 
#依匯總項目來取得前期餘額(匯總項目除了科目編號是固定的，交易對象和部門是變動的)
FUNCTION aglg201_cur()
   DEFINE l_sql  LIKE type_file.chr1000   # RDSQL STATEMENT        #No.FUN-680098 VARCHAR(1200)
 
   LET l_sql = "SELECT npr00 "
   #1.交易對象
   IF tm.s[1,1] = '1' OR tm.s[2,2] = '1' THEN
      LET l_sql = l_sql CLIPPED,",npr01,npr02 "   #MOD-930326 add npr02
   ELSE
      LET l_sql = l_sql CLIPPED,",' ',' ' "       #MOD-930326 add ' '
   END IF
   #2.部門
   IF tm.s[2,2] = '2' OR tm.s[1,1] = '2' THEN
      LET l_sql = l_sql CLIPPED,",npr03 "
   ELSE
      LET l_sql = l_sql CLIPPED,",' ' "
   END IF
 
 IF tm.m1 = 0 THEN 
    LET l_sql = l_sql CLIPPED,",SUM(npr06-npr07),SUM(npr06f-npr07f) FROM npr_file ", 
                " WHERE npr00 = ? ",  
               "   AND npr04 = ",tm.yy,"  AND npr05 = 0  ",           
               "   AND (npr08 = '",g_plant,"' OR npr08 = ' ') AND npr09 = '",tm.o ,"'",  #MOD-950215 
               " GROUP BY npr00 " 
 ELSE
    LET l_sql = l_sql CLIPPED,",SUM(npr06-npr07),SUM(npr06f-npr07f) FROM npr_file ",  
               " WHERE npr00 = ? ",  
               "   AND npr04 = ",tm.yy,"  AND npr05 < ",tm.m1 , 
               "   AND (npr08 = '",g_plant,"' OR npr08 = ' ') AND npr09 = '",tm.o ,"'",  #MOD-950215
               " GROUP BY npr00 " 
 END IF                               
 
   IF tm.s[1,1] = '1' OR tm.s[2,2] = '1' THEN
      LET l_sql = l_sql CLIPPED,", npr01, npr02"   #MOD-930326 add npr02
   END IF
   IF (tm.s[1,1] = '2') OR (tm.s[2,2] = '2') THEN
      LET l_sql = l_sql CLIPPED,", npr03"
   END IF
 
   PREPARE npr_p2 FROM l_sql
   IF STATUS THEN CALL cl_err('npr_p2',STATUS,1) END IF
   DECLARE npr_c2 CURSOR FOR npr_p2
 
END FUNCTION 
 
FUNCTION aglg201()
   DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name         #No.FUN-680098 VARCHAR(20)
          l_sql     LIKE type_file.chr1000,        # RDSQL STATEMENT #No.FUN-680098   VARCHAR(1200)
          l_wc      LIKE type_file.chr1000,        #No.FUN-680098  VARCHAR(600)
          l_wc1     STRING,                        #MOD-860331 add
          l_cnt     LIKE type_file.num5,           #MOD-860331 add
          i         LIKE type_file.num5,           #No.FUN-680098  smallint
          l_bdate   LIKE type_file.dat,            #No.FUN-680098  date
          l_edate   LIKE type_file.dat,            #No.FUN-680098  date
          sr        RECORD 
                    order1,order2 LIKE npq_file.npq21, #No.FUN-680098  VARCHAR(20)
                    npq03    LIKE npq_file.npq03,   #科目編號
                    npq05    LIKE npq_file.npq05,   #部門
                    npq21    LIKE npq_file.npq21,   #對象編號
                    npq22    LIKE npq_file.npq22,   #對象簡稱
                    nppsys   LIKE npp_file.nppsys,  #系統別
                    npp00    LIKE npp_file.npp00,   #類別
                    name     LIKE zaa_file.zaa08,   #類別名稱     #No.FUN-680098  VARCHAR(30)
                    npp02    LIKE npp_file.npp02,   #日期
                    nppglno  LIKE npp_file.nppglno, #傳票編號
                    npp01    LIKE npp_file.npp01,   #單號
                    npq24    LIKE npq_file.npq24,   #原幣幣別
                    npq07    LIKE npq_file.npq07,   #本幣借方金額
                    npq07_2  LIKE npq_file.npq07,   #本幣貸方金額
                    npq07f   LIKE npq_file.npq07f,  #原幣借方金額
                    npq07f_2 LIKE npq_file.npq07f,  #原幣貸方金額
                    sum      LIKE npq_file.npq07f,  #本幣餘額
                    sum2     LIKE npq_file.npq07f,  #原幣餘額 #No.TQC-760154
                    npq06    LIKE npq_file.npq06,   #D/C(1.借 2.貸)
                    aag02    LIKE aag_file.aag02,   #科目名稱
                    sum_pre  LIKE npq_file.npq07f,  #前期餘額
                    sum_pre2 LIKE npq_file.npq07f,  #前期餘額 #No.TQC-760154
                    flag     LIKE type_file.chr1                 #0:前期  1:本期        #No.FUN-680098
                    END RECORD,
          sr1       RECORD 
                    order1,order2 LIKE npq_file.npq21, #No.FUN-B80158 ADD         
                    npr00    LIKE npr_file.npr00,   #科目編號
                    npr01    LIKE npr_file.npr01,   #交易對象
                    npr02    LIKE npr_file.npr02,   #對象簡稱   #MOD-960027 add
                    npr03    LIKE npr_file.npr03,   #部門
                    npr09    LIKE npr_file.npr09,   #No.FUN-740020
                    aag02    LIKE aag_file.aag02    #科目名稱
                    END RECORD
   DEFINE l_sum     LIKE type_file.num20_6   
   DEFINE l_sum2    LIKE type_file.num20_6   
   DEFINE l_npq05   LIKE npq_file.npq05  
   DEFINE l_azi04   LIKE azi_file.azi04        
   DEFINE l_flag    LIKE type_file.chr1      #MOD-8A0069 add
   DEFINE l_line    LIKE type_file.num5      #MOD-8A0069 add
 
   CALL cl_del_data(l_table)                   #No.FUN-830092   
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 ='aglg201'
 
   #CALL s_azm(tm.yy,tm.m1) RETURNING g_chr,l_bdate,l_edate #CHI-A70007 mark
   #CHI-A70007 add --start--
   IF g_aza.aza63 = 'Y' THEN
      CALL s_azmm(tm.yy,tm.m1,g_plant,tm.o) RETURNING g_chr,l_bdate,l_edate
   ELSE
      CALL s_azm(tm.yy,tm.m1) RETURNING g_chr,l_bdate,l_edate
   END IF
   #CHI-A70007 add --end--
   LET g_bdate = l_bdate
   #CALL s_azm(tm.yy,tm.m2) RETURNING g_chr,l_bdate,l_edate #CHI-A70007 mark
   #CHI-A70007 add --start--
   IF g_aza.aza63 = 'Y' THEN
      CALL s_azmm(tm.yy,tm.m2,g_plant,tm.o) RETURNING g_chr,l_bdate,l_edate
   ELSE
      CALL s_azm(tm.yy,tm.m2) RETURNING g_chr,l_bdate,l_edate
   END IF
   #CHI-A70007 add --end--
   LET g_edate = l_edate
     
    LET buf = base.StringBuffer.create()                                                                                            
    CALL buf.append(tm.wc)                                                                                                          
    CALL buf.replace("npq21","npr01",0)                                                                                             
    CALL buf.replace("npq22","npr02",0)                                                                                             
    CALL buf.replace("npq03","npr00",0)                                                                                             
    CALL buf.replace("npq05","npr03",0)                                                                                             
    LET l_wc = buf.toString()                                                                                                       
 
   #依畫面輸入條件，取得符合條件的統計更新檔(npr_file)
   IF tm.a = 'N' THEN  #No.TQC-760154
      LET l_sql = "SELECT '','',npr00,npr01,npr02,npr03,aag02 ",  #MOD-960027 add npr02   #FUN-B80158 add 2?
                  "  FROM npr_file,aag_file ",
                  " WHERE ",l_wc CLIPPED,
                  "   AND ((npr04=",tm.yy,
                  "   AND   npr05 >=",tm.m1," AND npr05 <= ",tm.m2,")",
                  "    OR  (npr04=",tm.yy,
                  "   AND   npr05 < ",tm.m1,"))",
                  "   AND npr09 = '",tm.o    CLIPPED,"'",
                  "   AND (npr08 = '",g_plant CLIPPED,"' OR npr08 = ' ' )",   #MOD-950215
                  "   AND npr00 = aag01 AND npr09 = aag00 AND aag04 = '",tm.b,"'",      #No.FUN-740020 #No.FUN-830092 
                  " GROUP BY npr00,npr01,npr02,npr03,aag02"  #MOD-960027 add npr02
   ELSE
      LET l_sql = "SELECT '','',npr00,npr01,npr02,npr03,aag02,aag13 ",  #MOD-960027 add npr02    #FUN-B80158 add 2?
                  "  FROM npr_file,aag_file ",
                  " WHERE ",l_wc CLIPPED,
                  "   AND ((npr04=",tm.yy,
                  "   AND   npr05 >=",tm.m1," AND npr05 <= ",tm.m2,")",
                  "    OR  (npr04=",tm.yy,
                  "   AND   npr05 < ",tm.m1,"))",
                  "   AND npr09 = '",tm.o    CLIPPED,"'",
                  "   AND (npr08 = '",g_plant CLIPPED,"' OR npr08 = ' ')",  #MOD-950215
                  "   AND npr00 = aag01 AND npr09 = aag00 AND aag04 = '",tm.b,"'",         #No.FUN-830092
                  "   AND npr11 = '",tm.d,"'",
                  " GROUP BY npr00,npr01,npr02,npr03,aag02,aag13"  #MOD-960027 add npr02
   END IF
   PREPARE aglg201_p1 FROM l_sql
   IF STATUS THEN CALL cl_err('aglg201_p1:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF
   DECLARE aglg201_c1 CURSOR FOR aglg201_p1
   INITIALIZE sr1.* TO NULL
 
   FOREACH aglg201_c1 INTO sr1.*
      IF STATUS THEN CALL cl_err('fore1:',STATUS,1) EXIT FOREACH END IF
 
      #取得科目的前期餘額
      INITIALIZE sr.*  TO NULL
      LET sr.npq03 = sr1.npr00   #科目編號
      CALL aglg201_cur()
      LET l_flag = 'Y'    #MOD-8A0069 add
      LET l_line = 1      #MOD-8A0069 add
      FOREACH npr_c2 USING sr1.npr00 INTO sr.npq03,sr.npq21,sr.npq22,sr.npq05,   #MOD-930326 add sr.npq22
                                          sr.sum_pre,sr.sum_pre2 #No.TQC-760154 add sr.sum_pre2
         LET sr.flag = '0' 
       
         IF sr1.npr01 = sr.npq21 AND    #交易對象
            sr1.npr02 = sr.npq22 AND    #對象簡稱   #MOD-960027 add
            sr1.npr03 = sr.npq05 THEN   #部門
            LET l_sum = sr.sum_pre                                                  
            IF l_sum IS NULL THEN LET l_sum = 0 END IF                              
            IF l_flag = 'Y' THEN   #MOD-8A0069 add
               LET g_sum = l_sum
            END IF                 #MOD-8A0069 add
            LET l_sum2 = sr.sum_pre2                                                
            IF l_sum2 IS NULL THEN LET l_sum2 = 0 END IF                            
            IF l_flag = 'Y' THEN   #MOD-8A0069 add
               LET g_sum2 = l_sum2
            END IF                 #MOD-8A0069 add
            SELECT azi04 INTO t_azi04 FROM azi_file                                 
             WHERE azi01 = tm.d                                                     
            IF tm.a = 'Y' THEN                                                      
               LET l_azi04 = 0                                                      
               SELECT azi04 INTO l_azi04 FROM azi_file                              
                WHERE azi01 = sr.npq24                                              
            END IF    #MOD-8A0069 add
            IF sr.npq06 = 'C' THEN                                                 
               LET g_sum = g_sum - sr.npq07_2                                      
               LET g_sum2= g_sum2- sr.npq07f_2 #No.TQC-760154                      
               IF g_sum < 0 THEN                                                   
                  LET sr.sum = g_sum * -1                                          
                  LET sr.sum2= g_sum2* -1      #No.TQC-760154                      
                  LET sr.npq06 = 'C'                                               
               ELSE                                                                
                  LET sr.sum = g_sum                                               
                  LET sr.sum2= g_sum2          #No.TQC-760154                      
                  LET sr.npq06 = 'D'          
               END IF                                                              
            ELSE                                                                   
               LET g_sum = g_sum + sr.npq07                                        
               LET g_sum2= g_sum2+ sr.npq07f   #No.TQC-760154                      
               IF g_sum < 0 THEN                                                   
                  LET sr.sum = g_sum * -1                                          
                  LET sr.sum2= g_sum2* -1      #No.TQC-760154                      
                  LET sr.npq06 = 'C'                                               
               ELSE                                                                
                  LET sr.sum = g_sum                                               
                  LET sr.sum2 = g_sum2         #No.TQC-760154                      
                  LET sr.npq06 = 'D'                                               
               END IF                                                              
            END IF                                                                 
            SELECT aag02 INTO sr.aag02 FROM aag_file 
             WHERE aag01 = sr.npq03 
               AND aag00 = tm.o        
          
            #FUN-B80158------add----str---
            CASE tm.s[1,1]
               WHEN '1'  LET sr.order1 = sr.npq21
               WHEN '2'  LET sr.order1 = sr.npq05
               OTHERWISE LET sr.order1 = '-'
            END CASE

            CASE tm.s[2,2]
               WHEN '1'  LET sr.order2 = sr.npq21
               WHEN '2'  LET sr.order2 = sr.npq05
               OTHERWISE LET sr.order2 = '-'
            END CASE
            #FUN-B80158------add----end--- 

            EXECUTE insert_prep USING
               sr.order1,sr.order2,sr.npq03,sr.aag02,g_aza.aza17,l_sum,l_sum2,   #MOD-8B0115 add l_sum2   #FUN-B80158 add sr.order1,sr.order2
               sr.npq21,sr.npq22,sr.nppsys,sr.npp02,        
               sr.nppglno,sr.npp01,sr.npq24,sr.npq07,       
               sr.npq07f,sr.npq07_2,sr.npq07f_2,sr.npq06,   
               sr.npq05,sr1.npr00,sr1.npr01,       
               sr1.npr03,sr.npp00,sr.sum,sr.sum2,l_azi04,
               l_line   #MOD-8A0069 add
            LET l_flag = 'N'          #MOD-8A0069 add
            LET l_line = l_line + 1   #MOD-8A0069 add
         END IF
      END FOREACH
 
     #抓取符合條件之分錄底稿資料
     LET l_sql = "SELECT '','',npq03,npq05,npq21,npq22,nppsys,npp00,'',npp02,",
                 "       nppglno,npp01,npq24,npq07,0,npq07f,0,0,0,npq06,", #No.TQC-760154 add 0
                 "       '", sr1.aag02,"',0,0,'1'", #No.TQC-760154 add 0
                 "  FROM npp_file, npq_file",
                 " WHERE nppsys = npqsys ",
                 "   AND npp00  = npq00 ",
                 "   AND npp01  = npq01 ",
                 "   AND npp011 = npq011",
                 "   AND npp02 >= '",g_bdate ,"'",
                 "   AND npp02 <= '",g_edate,"'",
                 "   AND npp06  = '",g_plant ,"'",
                 "   AND npp07  = '",tm.o,"'",
                 "   AND npp04  = '1'",              #更新碼
                 "   AND npq03  = '",sr1.npr00,"'",
                 "   AND ",tm.wc CLIPPED
 
     IF cl_null(sr1.npr01) THEN   #交易對象
        LET l_sql = l_sql, " AND (npq21 IS NULL OR npq21 = ' ')"
     ELSE
        LET l_sql = l_sql, " AND npq21  = '",sr1.npr01,"'"
     END IF
     IF cl_null(sr1.npr02) THEN   #對象簡稱
        LET l_sql = l_sql, " AND (npq22 IS NULL OR npq22 = ' ')"
     ELSE
        LET l_sql = l_sql, " AND npq22  = '",sr1.npr02,"'"
     END IF
     IF cl_null(sr1.npr03) THEN   #部門
        LET l_sql = l_sql, " AND (npq05 IS NULL OR npq05 = ' ')"
     ELSE
        LET l_sql = l_sql, " AND npq05  = '",sr1.npr03,"'"
     END IF
     IF tm.a = 'Y' THEN
        LET l_sql = l_sql, " AND npq24 = '",tm.d,"'"
     END IF
 
     PREPARE aglg201_p2 FROM l_sql
     IF STATUS THEN CALL cl_err('aglg201_p2:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM 
     END IF
     DECLARE aglg201_c2 CURSOR FOR aglg201_p2
 
     LET l_flag = 'Y'    #MOD-8A0069 add
     LET l_line = 1      #MOD-8A0069 add
     FOREACH aglg201_c2 INTO sr.*
        IF STATUS THEN CALL cl_err('fore2:',STATUS,1) EXIT FOREACH END IF
        IF sr.npq06 = '2' THEN   #貸方
           LET sr.npq07_2  = sr.npq07
           LET sr.npq07f_2 = sr.npq07f
           LET sr.npq07  = 0
           LET sr.npq07f = 0
           LET sr.npq06  = 'C'
        ELSE                     #借方
           LET sr.npq07_2  = 0
           LET sr.npq07f_2 = 0
           LET sr.npq06  = 'D'
        END IF
        LET l_sum = sr.sum_pre
        IF l_sum IS NULL THEN LET l_sum = 0 END IF
        IF l_flag = 'Y' THEN   #MOD-8A0069 add
           LET g_sum = l_sum
        END IF                 #MOD-8A0069 add
        LET l_sum2 = sr.sum_pre2
        IF l_sum2 IS NULL THEN LET l_sum2 = 0 END IF
        IF l_flag = 'Y' THEN   #MOD-8A0069 add
           LET g_sum2 = l_sum2
        END IF                 #MOD-8A0069 add
        SELECT azi04 INTO t_azi04 FROM azi_file
         WHERE azi01 = tm.d
        IF tm.a = 'Y' THEN
           LET l_azi04 = 0
           SELECT azi04 INTO l_azi04 FROM azi_file
            WHERE azi01 = sr.npq24
        END IF    #MOD-8A0069 add
        IF sr.npq06 = 'C' THEN  
           LET g_sum = g_sum - sr.npq07_2
           LET g_sum2= g_sum2- sr.npq07f_2 #No.TQC-760154
           IF g_sum < 0 THEN
              LET sr.sum = g_sum * -1
              LET sr.sum2= g_sum2* -1      #No.TQC-760154
              LET sr.npq06 = 'C'
           ELSE
              LET sr.sum = g_sum
              LET sr.sum2= g_sum2          #No.TQC-760154
              LET sr.npq06 = 'D'
           END IF
        ELSE                  
           LET g_sum = g_sum + sr.npq07
           LET g_sum2= g_sum2+ sr.npq07f   #No.TQC-760154
           IF g_sum < 0 THEN
              LET sr.sum = g_sum * -1
              LET sr.sum2= g_sum2* -1      #No.TQC-760154
              LET sr.npq06 = 'C'
           ELSE
              LET sr.sum = g_sum
              LET sr.sum2 = g_sum2         #No.TQC-760154
              LET sr.npq06 = 'D'
           END IF
        END IF
        SELECT aag02 INTO sr.aag02 FROM aag_file 
         WHERE aag01 = sr.npq03 
           AND aag00 = tm.o        

        #FUN-B80158------add----str---
        CASE tm.s[1,1]
           WHEN '1'  LET sr.order1 = sr.npq21,' ',sr.npq22
           WHEN '2'  LET sr.order1 = sr.npq05
           OTHERWISE LET sr.order1 = '-'
        END CASE

        CASE tm.s[2,2]
           WHEN '1'  LET sr.order2 = sr.npq21,' ',sr.npq22
           WHEN '2'  LET sr.order2 = sr.npq05
           OTHERWISE LET sr.order2 = '-'
        END CASE
        #FUN-B80158------add----end---

        EXECUTE insert_prep USING
           sr.order1,sr.order2,    #FUN-B80158  add 
           sr.npq03,sr.aag02,g_aza.aza17,l_sum,l_sum2,   #MOD-8B0115 add l_sum2
           sr.npq21,sr.npq22,sr.nppsys,sr.npp02,
           sr.nppglno,sr.npp01,sr.npq24,sr.npq07,
           sr.npq07f,sr.npq07_2,sr.npq07f_2,sr.npq06,
           sr.npq05,sr1.npr00,sr1.npr01,
           sr1.npr03,sr.npp00,sr.sum,sr.sum2,l_azi04,
           l_line   #MOD-8A0069 add
        LET l_flag = 'N'          #MOD-8A0069 add
        LET l_line = l_line + 1   #MOD-8A0069 add
     END FOREACH
   END FOREACH
   IF g_zz05 = 'Y' THEN                                                        
      CALL cl_wcchp(tm.wc,'npq03, npq21,npq22,npq05')     
           RETURNING g_str                                                     
   END IF                                                                      
   IF tm.a='N' THEN
#     LET l_name = 'aglg201'        #FUN-B80158 mark
      LET g_template = 'aglg201'    #FUN-B80158 add
      CALL aglg201_grdata()         #FUN-B80158 add
   ELSE
#     LET l_name = 'aglg201_1'      #FUN-B80158 mark
      LET g_template = 'aglg201_1'  #FUN-B80158 add
      CALL aglg201_grdata()         #FUN-B80158 add
   END IF
###GENGRE###   LET g_str = g_str,";",tm.a,";",tm.b,";",g_azi04,";",
###GENGRE###               g_bdate,";",g_edate,";",
###GENGRE###               tm.s[1,1],";",tm.s[2,2],";",
###GENGRE###               tm.t[1,1],";",tm.t[2,2],";",
###GENGRE###               tm.u[1,1],";",tm.u[2,2],";",
###GENGRE###               t_azi04   #MOD-8B0139 add
###GENGRE###   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED          
###GENGRE###   CALL cl_prt_cs3('aglg201',l_name,l_sql,g_str)                            
END FUNCTION
#No.FUN-9C0072 精簡程式碼

###GENGRE###START
FUNCTION aglg201_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    #FUN-B80158---add---str----
    LET g_sql1 = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " WHERE npq03 = ?"
    DECLARE aglg201_repcur01 CURSOR FROM g_sql1
    LET g_sql2 = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    IF tm.t[1,1] = 'Y' OR tm.u[1,1] = 'Y' THEN
       LET g_sql2 = g_sql2," WHERE (order1=? OR order1 IS NULL) AND npq03 = ?"            
    ELSE
       LET g_sql2 = g_sql2," WHERE npq03 = ?"
    END IF    
    DECLARE aglg201_repcur02 CURSOR FROM g_sql2
    #FUN-B80158---add---end----

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg201")
        IF handler IS NOT NULL THEN
            START REPORT aglg201_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY npq03,order1,order2,line"    #FUN-B80158 add
          
            DECLARE aglg201_datacur1 CURSOR FROM l_sql
            FOREACH aglg201_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg201_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg201_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg201_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B80158-----add----str----
    DEFINE l_cnt1          LIKE type_file.num10
    DEFINE l_cnt2          LIKE type_file.num10
    DEFINE l_cnt3          LIKE type_file.num10
    DEFINE l_ord1_cnt      LIKE type_file.num10
    DEFINE l_ord2_cnt      LIKE type_file.num10
    DEFINE l_ord3_cnt      LIKE type_file.num10
    DEFINE l_skip          LIKE type_file.chr1
    DEFINE l_skip_ord1     LIKE type_file.chr1
    DEFINE l_skip_ord2     LIKE type_file.chr1 
    DEFINE l_1     STRING
    DEFINE l_cd    LIKE type_file.chr1
    DEFINE l_cd2   LIKE type_file.chr1
    DEFINE l_name  STRING
    DEFINE l_ordera STRING
    DEFINE l_orderb STRING
    DEFINE l_sum   LIKE npq_file.npq07f
    DEFINE l_sum_sum LIKE npq_file.npq07f
    DEFINE l_sum_sum_2 LIKE npq_file.npq07f
    DEFINE l_RTotal_sum LIKE npq_file.npq07f
    DEFINE l_npq07_1_sum LIKE npq_file.npq07
    DEFINE l_npq07_2_1_sum LIKE npq_file.npq07
    DEFINE l_npq07_2_sum LIKE npq_file.npq07
    DEFINE l_npq07_2_2_sum LIKE npq_file.npq07
    DEFINE l_npq07_3_sum LIKE npq_file.npq07
    DEFINE l_npq07_2_3_sum LIKE npq_file.npq07
    DEFINE l_npq07_4_sum LIKE npq_file.npq07
    DEFINE l_npq07_2_4_sum LIKE npq_file.npq07
    DEFINE l_npq07f_1_sum LIKE npq_file.npq07
    DEFINE l_npq07f_2_1_sum LIKE npq_file.npq07
    DEFINE l_npq07f_2_sum LIKE npq_file.npq07
    DEFINE l_npq07f_2_2_sum LIKE npq_file.npq07
    DEFINE l_npq07f_3_sum LIKE npq_file.npq07
    DEFINE l_npq07f_2_3_sum LIKE npq_file.npq07
    DEFINE l_npq07f_4_sum LIKE npq_file.npq07
    DEFINE l_npq07f_2_4_sum LIKE npq_file.npq07
    DEFINE l_npq07_fmt  STRING
    DEFINE l_npq07_1_fmt  STRING
    DEFINE l_ord1_skip         STRING
    DEFINE l_ord2_skip         STRING
    DEFINE l_ord1_show         STRING
    DEFINE l_ord2_show         STRING
    #FUN-B80158-----add----end----

    
    ORDER EXTERNAL BY sr1.npq03,sr1.order1,sr1.order2
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B80158 add g_ptime,g_user_name
            PRINTX tm.*
            #FUN-B80158----------add----str---
            LET l_ord1_skip = tm.t[1]
            LET l_ord2_skip = tm.t[2]
            PRINTX l_ord1_skip,l_ord2_skip

            LET l_ord1_show = tm.u[1]
            LET l_ord2_show = tm.u[2]
            PRINTX l_ord1_show,l_ord2_show
           
            IF tm.b = '1' THEN
               LET l_1 = '(',cl_gr_getmsg("gre-244",g_lang,1),')'
            ELSE
               LET l_1 = '(',cl_gr_getmsg("gre-244",g_lang,2),')'
            END IF
            PRINTX l_1

            PRINTX g_bdate,g_edate

            LET l_ord1_cnt = 0
            LET l_ord2_cnt = 0
            LET l_ord3_cnt = 0
            #FUN-B80158-----add----end----
              
        BEFORE GROUP OF sr1.npq03 
            #FUN-B80158-------add-------str---
            LET g_sql2 = "SELECT COUNT(DISTINCT npq03) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
            DECLARE aglg201_repcur03 CURSOR FROM g_sql2
            FOREACH aglg201_repcur03 INTO l_cnt3 END FOREACH
            #FUN-B80158-----add----end----
        BEFORE GROUP OF sr1.order1         #FUN-B80158  add
            FOREACH aglg201_repcur01 USING sr1.npq03 INTO l_cnt1 END FOREACH      #FUN-B80158  add
        BEFORE GROUP OF sr1.order2         #FUN-B80158  add
            #FUN-B80158-------add-------str---
            IF l_ord1_skip = 'Y' OR l_ord1_show = 'Y' THEN
               FOREACH aglg201_repcur02 USING sr1.order1,sr1.npq03 INTO l_cnt2 END FOREACH 
            ELSE
               FOREACH aglg201_repcur02 USING sr1.npq03 INTO l_cnt2 END FOREACH 
            END IF 
            IF sr1.l_sum < 0 THEN
               LET l_sum = sr1.l_sum * (-1)
            ELSE
               LET l_sum = sr1.l_sum
            END IF
            PRINTX l_sum

            IF sr1.l_sum < 0 THEN
               LET l_cd = 'C'
            ELSE
               LET l_cd = 'D'
            END IF
            PRINTX l_cd
            #FUN-B80158-------add-------end---

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B80158-------add-------str---
            LET l_ord1_cnt = l_ord1_cnt + 1 
            LET l_ord2_cnt = l_ord2_cnt + 1

            LET l_npq07_fmt = cl_gr_numfmt("npq_file","npq07",g_azi04)
            PRINTX l_npq07_fmt
            LET l_npq07_1_fmt = cl_gr_numfmt("npq_file","npq07",sr1.azi04)
            PRINTX l_npq07_1_fmt
            IF sr1.npq06 = 'D' THEN
               IF (l_RTotal_sum + sr1.sum) >0 THEN 
                  LET l_sum_sum = l_RTotal_sum + sr1.sum
               ELSE
                  LET l_sum_sum = (l_RTotal_sum + sr1.sum) * (-1)
               END IF
            ELSE
               IF (l_RTotal_sum - sr1.sum) >0 THEN
                  LET l_sum_sum = l_RTotal_sum - sr1.sum
               ELSE
                  LET l_sum_sum = (l_RTotal_sum - sr1.sum) * (-1)
               END IF
            END IF
            PRINTX l_sum_sum

            IF sr1.npq06 = 'D' THEN
               LET l_sum_sum_2 = l_RTotal_sum + sr1.sum
            ELSE
               LET l_sum_sum_2 = l_RTotal_sum - sr1.sum 
            END IF
            PRINTX l_sum_sum_2

            IF l_sum_sum_2 < 0 THEN
               LET l_cd2 = 'C'
            ELSE
               LET l_cd2 = 'D'
            END IF
            PRINTX l_cd2

            CASE sr1.nppsys
               WHEN "AP"
                  CASE sr1.npp00
                     WHEN '1' LET l_name = "1.",cl_gr_getmsg("gre-238",g_lang,1)
                     WHEN '2' LET l_name = "1.",cl_gr_getmsg("gre-238",g_lang,2)
                     WHEN '3' LET l_name = "1.",cl_gr_getmsg("gre-238",g_lang,3)
                     WHEN '4' LET l_name = "1.",cl_gr_getmsg("gre-238",g_lang,4)
                     WHEN '5' LET l_name = "1.",cl_gr_getmsg("gre-238",g_lang,5)
                     OTHERWISE  LET l_name = sr1.npp00 
                  END CASE
               WHEN "LC"
                  CASE sr1.npp00
                     WHEN '4' LET l_name = "4.",cl_gr_getmsg("gre-239",g_lang,4)
                     WHEN '5' LET l_name = "5.",cl_gr_getmsg("gre-239",g_lang,5)
                     WHEN '6' LET l_name = "6.",cl_gr_getmsg("gre-239",g_lang,6)
                     WHEN '7' LET l_name = "7.",cl_gr_getmsg("gre-239",g_lang,7)
                     WHEN '9' LET l_name = "9.",cl_gr_getmsg("gre-239",g_lang,9)
                     OTHERWISE  LET l_name = sr1.npp00
                  END CASE
               WHEN "AR"
                  CASE sr1.npp00
                     WHEN '1' LET l_name = "1.",cl_gr_getmsg("gre-240",g_lang,1)
                     WHEN '2' LET l_name = "2.",cl_gr_getmsg("gre-240",g_lang,2)
                     WHEN '3' LET l_name = "3.",cl_gr_getmsg("gre-240",g_lang,3)
                     WHEN '4' LET l_name = "4.",cl_gr_getmsg("gre-240",g_lang,4)
                     WHEN '41' LET l_name = "41.",cl_gr_getmsg("gre-240",g_lang,41)
                     WHEN '42' LET l_name = "42.",cl_gr_getmsg("gre-240",g_lang,42)
                     WHEN '43' LET l_name = "43.",cl_gr_getmsg("gre-240",g_lang,43)
                     OTHERWISE  LET l_name = sr1.npp00
                  END CASE
               WHEN "FA"
                  CASE sr1.npp00
                     WHEN 'X' LET l_name = "X.",cl_gr_getmsg("gre-241",g_lang,'X')
                     WHEN '0' LET l_name = "0.",cl_gr_getmsg("gre-241",g_lang,0)
                     WHEN '1' LET l_name = "1.",cl_gr_getmsg("gre-241",g_lang,1)
                     WHEN '2' LET l_name = "2.",cl_gr_getmsg("gre-241",g_lang,2)
                     WHEN '4' LET l_name = "4.",cl_gr_getmsg("gre-241",g_lang,4)
                     WHEN '5' LET l_name = "5.",cl_gr_getmsg("gre-241",g_lang,5)
                     WHEN '6' LET l_name = "6.",cl_gr_getmsg("gre-241",g_lang,6)
                     WHEN '7' LET l_name = "7.",cl_gr_getmsg("gre-241",g_lang,7)
                     WHEN '8' LET l_name = "8.",cl_gr_getmsg("gre-241",g_lang,8)
                     WHEN '9' LET l_name = "9.",cl_gr_getmsg("gre-241",g_lang,9)
                     WHEN '10' LET l_name = "10.",cl_gr_getmsg("gre-241",g_lang,10)
                     WHEN '11' LET l_name = "11.",cl_gr_getmsg("gre-241",g_lang,11)
                     WHEN '12' LET l_name = "12.",cl_gr_getmsg("gre-241",g_lang,12)
                     WHEN '13' LET l_name = "13.",cl_gr_getmsg("gre-241",g_lang,13)
                     OTHERWISE  LET l_name = sr1.npp00
                  END CASE
              WHEN "NM"
                  CASE sr1.npp00
                     WHEN '1' LET l_name = "1.",cl_gr_getmsg("gre-242",g_lang,1)
                     WHEN '2' LET l_name = "2.",cl_gr_getmsg("gre-242",g_lang,2)
                     WHEN '3' LET l_name = "3.",cl_gr_getmsg("gre-242",g_lang,3)
                     WHEN '4' LET l_name = "4.",cl_gr_getmsg("gre-242",g_lang,4)
                     WHEN '5' LET l_name = "5.",cl_gr_getmsg("gre-242",g_lang,5)
                     WHEN '6' LET l_name = "6.",cl_gr_getmsg("gre-242",g_lang,6)
                     WHEN '7' LET l_name = "7.",cl_gr_getmsg("gre-242",g_lang,7)
                     WHEN '8' LET l_name = "8.",cl_gr_getmsg("gre-242",g_lang,8)
                     WHEN '9' LET l_name = "9.",cl_gr_getmsg("gre-242",g_lang,9)
                     WHEN '10' LET l_name = "10.",cl_gr_getmsg("gre-242",g_lang,10)
                     WHEN '11' LET l_name = "11.",cl_gr_getmsg("gre-242",g_lang,11)
                     WHEN '12' LET l_name = "12.",cl_gr_getmsg("gre-242",g_lang,12)
                     WHEN '13' LET l_name = "13.",cl_gr_getmsg("gre-242",g_lang,13)
                     WHEN '14' LET l_name = "14.",cl_gr_getmsg("gre-242",g_lang,14)
                     WHEN '15' LET l_name = "15.",cl_gr_getmsg("gre-242",g_lang,15)
                     WHEN '16' LET l_name = "16.",cl_gr_getmsg("gre-242",g_lang,16)
                     WHEN '17' LET l_name = "17.",cl_gr_getmsg("gre-242",g_lang,17)
                     WHEN '18' LET l_name = "17.",cl_gr_getmsg("gre-242",g_lang,18)
                     OTHERWISE  LET l_name = sr1.npp00
                  END CASE
              WHEN "PY"
                  CASE sr1.npp00
                     WHEN '1' LET l_name = "1.",cl_gr_getmsg("gre-243",g_lang,1)
                     WHEN '2' LET l_name = "2.",cl_gr_getmsg("gre-243",g_lang,2)
                     WHEN '3' LET l_name = "3.",cl_gr_getmsg("gre-243",g_lang,3)
                     OTHERWISE  LET l_name = sr1.npp00
                  END CASE
              OTHERWISE  LET l_name = sr1.npp00
              END CASE
              PRINTX l_name
            #FUN-B80158-------add-------end---

            PRINTX sr1.*

        AFTER GROUP OF sr1.npq03
            #FUN-B80158-------add-------str---
            LET l_ord3_cnt = l_ord3_cnt + 1
            IF l_ord3_cnt = l_cnt3 THEN
               LET l_skip = 'N'
            ELSE
               LET l_skip = 'Y'
            END IF
            PRINTX l_skip
            LET l_npq07_1_sum = GROUP SUM(sr1.npq07)         
            PRINTX l_npq07_1_sum
            LET l_npq07_2_1_sum = GROUP SUM(sr1.npq07_2)         
            PRINTX l_npq07_2_1_sum
            LET l_npq07f_1_sum = GROUP SUM(sr1.npq07f)         
            PRINTX l_npq07f_1_sum
            LET l_npq07f_2_1_sum = GROUP SUM(sr1.npq07f_2)         
            PRINTX l_npq07f_2_1_sum
            #FUN-B80158-------add-------end---
        AFTER GROUP OF sr1.order1            #FUN-B80158  add 
            #FUN-B80158-------add-------str---
            IF l_ord1_cnt = l_cnt1 THEN
               LET l_skip_ord1 = 'N'
               LET l_ord1_cnt = 0
            ELSE
               LET l_skip_ord1 = 'Y'
            END IF
            PRINTX l_skip_ord1

            CASE tm.s[1,1]
               WHEN '1' LET l_ordera = cl_gr_getmsg("gre-237",g_lang,1)
               WHEN '2' LET l_ordera = cl_gr_getmsg("gre-237",g_lang,2)
               OTHERWISE LET l_ordera = '-'
            END CASE
            PRINTX l_ordera 

            LET l_npq07_2_sum = GROUP SUM(sr1.npq07)         
            PRINTX l_npq07_2_sum
            LET l_npq07_2_2_sum = GROUP SUM(sr1.npq07_2)         
            PRINTX l_npq07_2_2_sum
            LET l_npq07f_2_sum = GROUP SUM(sr1.npq07f)         
            PRINTX l_npq07f_2_sum
            LET l_npq07f_2_2_sum = GROUP SUM(sr1.npq07f_2)         
            PRINTX l_npq07f_2_2_sum
            #FUN-B80158-------add-------end---
        AFTER GROUP OF sr1.order2            #FUN-B80158  add
            #FUN-B80158-------add-------str---
            IF l_ord2_cnt = l_cnt2 THEN
               LET l_skip_ord2 = 'N'
               LET l_ord2_cnt = 0
            ELSE
               LET l_skip_ord2 = 'Y'
            END IF
            PRINTX l_skip_ord2

            CASE tm.s[2,2]
               WHEN '1' LET l_orderb = cl_gr_getmsg("gre-237",g_lang,1)
               WHEN '2' LET l_orderb = cl_gr_getmsg("gre-237",g_lang,2)
               OTHERWISE LET l_orderb = '-'
            END CASE
            PRINTX l_orderb 
 
            LET l_RTotal_sum = GROUP SUM(sr1.l_sum)
            PRINTX l_RTotal_sum   
            LET l_npq07_3_sum = GROUP SUM(sr1.npq07)         
            PRINTX l_npq07_3_sum
            LET l_npq07_2_3_sum = GROUP SUM(sr1.npq07_2)         
            PRINTX l_npq07_2_3_sum
            LET l_npq07f_3_sum = GROUP SUM(sr1.npq07f)         
            PRINTX l_npq07f_3_sum
            LET l_npq07f_2_3_sum = GROUP SUM(sr1.npq07f_2)         
            PRINTX l_npq07f_2_3_sum
            #FUN-B80158-------add-------end---

        
        ON LAST ROW
            #FUN-B80158-------add-------str---
            LET l_npq07_4_sum = SUM(sr1.npq07)         
            PRINTX l_npq07_4_sum
            LET l_npq07_2_4_sum = SUM(sr1.npq07_2)         
            PRINTX l_npq07_2_4_sum
            LET l_npq07f_4_sum = SUM(sr1.npq07f)         
            PRINTX l_npq07f_4_sum
            LET l_npq07f_2_4_sum = SUM(sr1.npq07f_2)         
            PRINTX l_npq07f_2_4_sum
            #FUN-B80158-------add-------end---

END REPORT
###GENGRE###END
#FUN-C20073
