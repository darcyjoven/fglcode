# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aglr120.4gl
# Descriptions...: 部門實際預算比較報表列印
# Date & Author..: 97/08/22 By Melody
# Modify.........: No.MOD-4C0156 04/12/24 By Kitty 帳別無法開窗 
# Modify.........: No.FUN-510007 05/02/01 By Nicola 報表架構修改
# Modify.........: No.MOD-550140 05/05/27 By Smapmin 部門實際預算比較表如果超過100%出現* 
# Modify.........: No.MOD-5A0261 05/10/21 By Smapmin 若為負數百分比多乘 -1 表現為負值狀態
# Modify.........: No.MOD-610106 06/01/19 By Smapmin 當部門預算為有效時才帶出資料
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/28 By Rainy 表頭期間置於中間
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670005 06/07/07 By xumin  帳別權限修改 
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6A0093 06/11/08 By Carrier 報表格式調整
# Modify.........: No.MOD-6B0126 06/12/05 By Smapmin 預算需為正值
# Modify.........: No.FUN-6C0068 07/01/16 By rainy 報表結構加檢查使用者及部門設限 
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/09 By sherry  會計科目加帳套 
# Modify.........: No.FUN-780060 07/08/22 By destiny 報表格式改為CR輸出
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0100 09/12/24 By sabrina 無法顯示出預算金額
# Modify.........: No.TQC-B30100 11/03/11 BY zhangweib 將程序中的MATCHES修改成ORACLE能識別的IN
# Modify.........: No:CHI-B60055 11/06/15 By Sarah 預算金額應含追加和挪用部份
# Modify.........: No:CHI-CC0023 13/01/29 By Lori tm.c欄位未依據aglr110的條件做設定;
#                                                 判斷式條件IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[012]"改MATCHES "[0125]"
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                 rtype   LIKE type_file.chr1,  #報表結構編號  #No.FUN-680098   VARCHAR(1)
                 a       LIKE mai_file.mai01,  #報表結構編號  #No.FUN-680098   VARCHAR(6) 
                 b       LIKE aaa_file.aaa01,  #帳別編號      #No.FUN-670039 
                 dept    LIKE gem_file.gem01,  #No.FUN-680098    VARCHAR(6)
                 title1  LIKE type_file.chr8,  #輸入期別名稱  #No.FUN-680098    VARCHAR(8)
                 yy1     LIKE type_file.num5,  #輸入年度      #No.FUN-680098    SMALLINT
                 bm1     LIKE type_file.num5,     #Begin 期別  #No.FUN-680098   SMALLINT
                 em1     LIKE type_file.num5,     # End  期別 #No.FUN-680098    SMALLINT
                 budget  LIKE afc_file.afc01,     #預算編號   #No.FUN-680098    VARCHAR(4)
                 e       LIKE type_file.num5,     #小數位數   #No.FUN-680098    SMALLINT
                 f       LIKE type_file.num5,     #列印最小階數 #No.FUN-680098  SMALLINT 
                 d       LIKE type_file.chr1,     #金額單位   #No.FUN-680098    VARCHAR(1)
                 c       LIKE type_file.chr1,     #異動額及餘額為0者是否列印 #No.FUN-680098   VARCHAR(1)
                 h       LIKE type_file.chr4,     #額外說明類別  #No.FUN-680098   VARCHAR(4)
                 o       LIKE type_file.chr1,     #轉換幣別否   #No.FUN-680098   VARCHAR(1)
                 r       LIKE azi_file.azi01,     #幣別
                 p       LIKE azi_file.azi01,     #幣別
                 q       LIKE azj_file.azj03,     #匯率
                 more    LIKE type_file.chr1     #Input more condition(Y/N) #No.FUN-680098    VARCHAR(1)
              END RECORD,
          bdate,edate   LIKE type_file.dat,            #No.FUN-680098  DATE
          i,j,k         LIKE type_file.num5,           #No.FUN-680098  SMALLINT
          g_unit        LIKE type_file.num10,          #金額單位基數   #No.FUN-680098  INTEGER
          g_bookno      LIKE aah_file.aah00,           #帳別 
          g_mai02       LIKE mai_file.mai02,
          g_mai03       LIKE mai_file.mai03,
          g_tot1        ARRAY[100] OF LIKE type_file.num20_6,     #No.FUN-680098  DEC(20,6)
          g_tot1_1      ARRAY[100] OF LIKE type_file.num20_6,     #No.FUN-680098  DEC(20,6)
          m_gem02       LIKE gem_file.gem02
   DEFINE g_aaa03       LIKE aaa_file.aaa03   
   DEFINE g_i           LIKE type_file.num5          #count/index for any purpose        #No.FUN-680098 SMALLINT
   DEFINE g_msg         LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(72)
#No.FUN-780060--start--
   DEFINE g_sql         STRING
   DEFINE l_table       STRING
   DEFINE g_str         STRING 
#No.FUN-780060--end--
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
#No.FUN-780060--start--
   LET g_sql="maj20.maj_file.maj20,",
             "maj20e.maj_file.maj20e,",
             "maj02.maj_file.maj02,",
             "maj03.maj_file.maj03,",
             "bal1.aah_file.aah04,",
             "bal1_1.aah_file.aah04,",
             "l_amt1.aah_file.aah04,",
             "l_per1.fid_file.fid04,",
             "line.type_file.num5"
   LET l_table = cl_prt_temptable('aglr120',g_sql) CLIPPED                                                  
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                  
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?, ?,?,?,?)"                                                                                     
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF 
#No.FUN-780060--end--  
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.rtype  = ARG_VAL(8)
   LET tm.a  = ARG_VAL(9)
   LET tm.b  = ARG_VAL(10)   #TQC-610056
   LET tm.dept = ARG_VAL(11)
   LET tm.title1 = ARG_VAL(12)   #TQC-610056
   LET tm.yy1 = ARG_VAL(13)
   LET tm.bm1 = ARG_VAL(14)
   LET tm.em1 = ARG_VAL(15)
   LET tm.budget = ARG_VAL(16)
   LET tm.c  = ARG_VAL(17)
   LET tm.d  = ARG_VAL(18)
   LET tm.e  = ARG_VAL(19)
   LET tm.f  = ARG_VAL(20)
   LET tm.h  = ARG_VAL(21)
   LET tm.o  = ARG_VAL(22)
   LET tm.r  = ARG_VAL(23)   #TQC-610056
   LET tm.p  = ARG_VAL(24)
   LET tm.q  = ARG_VAL(25)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(26)
   LET g_rep_clas = ARG_VAL(27)
   LET g_template = ARG_VAL(28)
   LET g_rpt_name = ARG_VAL(29)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF   #No.FUN-740020
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r120_tm()
   ELSE
      CALL r120()  
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION r120_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680098  SMALLINT
          l_sw           LIKE type_file.chr1,     #重要欄位是否空白 #No.FUN-680098   VARCHAR(1)
          l_cmd          LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(400)
   DEFINE li_chk_bookno  LIKE type_file.num5    #No.FUN-670005   #No.FUN-680098  smallint 
   DEFINE li_result      LIKE type_file.num5    #No.FUN-6C0068
 
   CALL s_dsmark(g_bookno)
   LET p_row = 1 LET p_col = 18
 
   OPEN WINDOW r120_w AT p_row,p_col
     WITH FORM "agl/42f/aglr120"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
 
   CALL  s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
 
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN
#     CALL cl_err('sel aaa:',SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)   #No.FUN-660123
   END IF
 
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN
#     CALL cl_err('sel azi:',SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)   #No.FUN-660123
   END IF
 
   LET tm.title1 = 'M.T.D.'
#  LET tm.b = g_bookno      #No.FUN-740020
   LET tm.b = g_aza.aza81   #No.FUN-740020
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.o = 'N'
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.r = g_aaa03
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
 
      LET l_sw = 1
 
#     INPUT BY NAME tm.rtype,tm.a,tm.b,tm.dept,tm.title1,tm.yy1,    #No.FUN-740020
      INPUT BY NAME tm.rtype,tm.b,tm.a,tm.dept,tm.title1,tm.yy1,
                    tm.bm1,tm.em1,tm.budget,tm.e,tm.f,tm.d,tm.c,
                    tm.h,tm.o,tm.r,tm.p,tm.q,tm.more WITHOUT DEFAULTS  
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            LET g_action_choice = "locale"
      
         AFTER FIELD a
            IF tm.a IS NULL THEN 
               NEXT FIELD a 
            END IF
          #FUN-6C0068--begin
            CALL s_chkmai(tm.a,'RGL') RETURNING li_result
            IF NOT li_result THEN
              CALL cl_err(tm.a,g_errno,1)
              NEXT FIELD a
            END IF
          #FUN-6C0068--end
            SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
             WHERE mai01 = tm.a
               AND mai00 = tm.b   #No.FUN-740020
#              AND maiacti MATCHES'[Yy]'      #No.TQC-B30100 Mark
               AND maiacti IN ('Y','y')       #No.TQC-B30100 add
            IF STATUS THEN 
#              CALL cl_err('sel mai:',STATUS,0)   #No.FUN-660123
               CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0)   #No.FUN-660123
               NEXT FIELD a 
            END IF
      
         AFTER FIELD b
            IF tm.b IS NULL THEN 
               NEXT FIELD b 
            END IF
            #No.FUN-670005--begin
             CALL s_check_bookno(tm.b,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD b
             END IF 
             #No.FUN-670005--end
            SELECT aaa02 FROM aaa_file
             WHERE aaa01 = tm.b
#              AND aaaacti MATCHES'[Yy]'      #No.TQC-B30100 Mark
               AND aaaacti IN ('Y','y')       #No.TQC-B30100 add
            IF STATUS THEN 
#              CALL cl_err('sel aaa:',STATUS,0)   #No.FUN-660123
               CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)   #No.FUN-660123
               NEXT FIELD b 
            END IF
      
         AFTER FIELD dept
            IF tm.dept IS NOT NULL OR tm.dept <> ' ' THEN 
               SELECT gem02 INTO m_gem02 FROM gem_file
                WHERE gem01 = tm.dept
                  AND gem05 = 'Y' 
                  AND gemacti = 'Y'
               IF STATUS = 100 THEN
                  NEXT FIELD dept
               END IF
            END IF
      
         AFTER FIELD budget
            SELECT * FROM afa_file 
             WHERE afa01 = tm.budget
               AND afa00 = tm.b              #No.FUN-740020 
#              AND afaacti MATCHES '[Yy]'      #No.TQC-B30100 Mark
               AND afaacti IN ('Y','y')       #No.TQC-B30100 add
            IF STATUS THEN 
#              CALL cl_err('sel afa:',STATUS,0)    #No.FUN-660123
               CALL cl_err3("sel","afa_file",tm.budget,"",STATUS,"","sel afa:",0)   #No.FUN-660123
               NEXT FIELD budget
            END IF
            
         AFTER FIELD c
            IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN 
               NEXT FIELD c
            END IF
      
         AFTER FIELD yy1
            IF tm.yy1 IS NULL OR tm.yy1 = 0 THEN
               NEXT FIELD yy1
            END IF
      
         BEFORE FIELD bm1
            IF tm.rtype='1' THEN
               LET tm.bm1 = 0 DISPLAY '' TO bm1
            END IF
      
         AFTER FIELD bm1
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.bm1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy1
            IF g_azm.azm02 = 1 THEN
               IF tm.bm1 > 12 OR tm.bm1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm1
               END IF
            ELSE
               IF tm.bm1 > 13 OR tm.bm1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm1
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
            IF tm.bm1 IS NULL THEN
               NEXT FIELD bm1 
            END IF
#No.TQC-720032 -- begin --
#            IF tm.bm1 <1 OR tm.bm1 > 13 THEN
#               CALL cl_err('','agl-013',0)
#               NEXT FIELD bm1
#            END IF
#No.TQC-720032 -- end --
     
         AFTER FIELD em1
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.em1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy1
            IF g_azm.azm02 = 1 THEN
               IF tm.em1 > 12 OR tm.em1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em1
               END IF
            ELSE
               IF tm.em1 > 13 OR tm.em1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em1
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
            IF tm.em1 IS NULL THEN 
               NEXT FIELD em1
            END IF
#No.TQC-720032 -- begin --
#            IF tm.em1 <1 OR tm.em1 > 13 THEN
#               CALL cl_err('','agl-013',0)
#               NEXT FIELD em1
#            END IF
#No.TQC-720032 -- end --
            IF tm.bm1 > tm.em1 THEN
               CALL cl_err('','9011',0)
               NEXT FIELD bm1 
            END IF
      
         AFTER FIELD d
            IF tm.d IS NULL OR tm.d NOT MATCHES'[123]' THEN
               NEXT FIELD d
            END IF
            IF tm.d = '1' THEN
               LET g_unit = 1
            END IF              
            IF tm.d = '2' THEN 
               LET g_unit = 1000 
            END IF              
            IF tm.d = '3' THEN 
               LET g_unit = 1000000
            END IF
      
         AFTER FIELD e
            IF tm.e < 0 THEN
               LET tm.e = 0
               DISPLAY BY NAME tm.e
            END IF
      
         AFTER FIELD f
            IF tm.f IS NULL OR tm.f < 0  THEN
               LET tm.f = 0
               DISPLAY BY NAME tm.f
               NEXT FIELD f
            END IF
      
         AFTER FIELD h
            IF tm.h NOT MATCHES "[YN]" THEN
               NEXT FIELD h
            END IF
      
         AFTER FIELD o
            IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN
               NEXT FIELD o
            END IF
            IF tm.o = 'N' THEN 
               LET tm.p = g_aaa03 
               LET tm.q = 1
               DISPLAY g_aaa03 TO p
               DISPLAY BY NAME tm.q
            END IF
      
         BEFORE FIELD p
            IF tm.o = 'N' THEN
               NEXT FIELD more
            END IF
      
         AFTER FIELD p
            SELECT azi01 FROM azi_file WHERE azi01 = tm.p
            IF SQLCA.sqlcode THEN 
#              CALL cl_err(tm.p,'agl-109',0)   #No.FUN-660123
               CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0)   #No.FUN-660123
               NEXT FIELD p
            END IF
      
         BEFORE FIELD q
            IF tm.o = 'N' THEN
               NEXT FIELD o 
            END IF
      
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
      
         AFTER INPUT 
            IF INT_FLAG THEN
               EXIT INPUT 
            END IF
            IF tm.yy1 IS NULL THEN 
               LET l_sw = 0 
               DISPLAY BY NAME tm.yy1 
               CALL cl_err('',9033,0)
            END IF
            IF tm.bm1 IS NULL THEN 
               LET l_sw = 0 
               DISPLAY BY NAME tm.bm1 
            END IF
            IF tm.em1 IS NULL THEN 
               LET l_sw = 0 
               DISPLAY BY NAME tm.em1 
            END IF
            IF l_sw = 0 THEN 
               LET l_sw = 1 
               NEXT FIELD a
               CALL cl_err('',9033,0)
            END IF
            IF tm.d = '1' THEN 
               LET g_unit = 1
            END IF              
            IF tm.d = '2' THEN
               LET g_unit = 1000
            END IF              
            IF tm.d = '3' THEN 
               LET g_unit = 1000000 
            END IF
      
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
      
         ON ACTION CONTROLG
            CALL cl_cmdask()
      
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(a)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_mai'
                  LET g_qryparam.default1 = tm.a
                  LET g_qryparam.where = " mai00 = '",tm.b,"'"  #No.FUN-740020
                  CALL cl_create_qry() RETURNING tm.a 
                  DISPLAY BY NAME tm.a
                  NEXT FIELD a
               
                #No.MOD-4C0156 add
               WHEN INFIELD(b) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aaa'
                  LET g_qryparam.default1 = tm.b
                  CALL cl_create_qry() RETURNING tm.b 
                  DISPLAY BY NAME tm.b
                  NEXT FIELD b
                #No.MOD-4C0156 end
 
               WHEN INFIELD(p)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_azi'
                  LET g_qryparam.default1 = tm.p
                  CALL cl_create_qry() RETURNING tm.p 
                  DISPLAY BY NAME tm.p
                  NEXT FIELD p
               
               WHEN INFIELD(budget)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_afa'
                  LET g_qryparam.default1 = tm.budget
                  CALL cl_create_qry() RETURNING tm.budget
                  DISPLAY BY NAME tm.budget
                  NEXT FIELD budget
            END CASE
 
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r120_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglr120'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglr120','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_bookno CLIPPED,"'" ,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.rtype CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",   #TQC-610056
                        " '",tm.dept CLIPPED,"'",
                        " '",tm.title1 CLIPPED,"'",   #TQC-610056
                        " '",tm.yy1 CLIPPED,"'",
                        " '",tm.bm1 CLIPPED,"'",
                        " '",tm.em1 CLIPPED,"'",
                        " '",tm.budget CLIPPED,"'",
                        " '",tm.c CLIPPED,"'",
                        " '",tm.d CLIPPED,"'",
                        " '",tm.e CLIPPED,"'",
                        " '",tm.f CLIPPED,"'",
                        " '",tm.h CLIPPED,"'",
                        " '",tm.o CLIPPED,"'",
                        " '",tm.r CLIPPED,"'",   #TQC-610056
                        " '",tm.p CLIPPED,"'",
                        " '",tm.q CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglr120',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r120_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r120()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r120_w
 
END FUNCTION
 
FUNCTION r120()
   DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name        #No.FUN-680098  VARCHAR(20)
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0073
   DEFINE l_sql     LIKE type_file.chr1000        # RDSQL STATEMENT        #No.FUN-680098   VARCHAR(1000)
   DEFINE l_chr     LIKE type_file.chr1           #No.FUN-680098    VARCHAR(1)
   DEFINE amt1      LIKE aah_file.aah04
   DEFINE amt1_1    LIKE aah_file.aah04
   DEFINE l_tmp     LIKE aah_file.aah04
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE sr        RECORD
                       bal1,bal1_1      LIKE aah_file.aah04
                    END RECORD
#No.FUN-780060--start--
   DEFINE l_amt1       LIKE aah_file.aah04                                                                                          
   DEFINE l_per1       LIKE fid_file.fid03
#No.FUN-780060--end--
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.b
      AND aaf02 = g_rlang
 
   CASE
      WHEN tm.rtype='1'
         LET g_msg=" maj23[1,1]='1'"
      WHEN tm.rtype='2'
         LET g_msg=" maj23[1,1]='2'"
      OTHERWISE
         LET g_msg=" 1=1"
   END CASE
   CALL cl_del_data(l_table)               #No.FUN-780060
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   PREPARE r120_p FROM l_sql
   IF STATUS THEN 
      CALL cl_err('prepare:',STATUS,1)   
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF
   DECLARE r120_c CURSOR FOR r120_p
 
   FOR g_i = 1 TO 100
      LET g_tot1[g_i] = 0 
      LET g_tot1_1[g_i] = 0 
   END FOR
#No.FUN-780060--start--
#  CALL cl_outnam('aglr120') RETURNING l_name
#  START REPORT r120_rep TO l_name
 
#  LET g_pageno = 0
 
   FOREACH r120_c INTO maj.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF
 
      LET amt1 = 0
      LET amt1_1 = 0 
     
      IF tm.dept IS NULL OR tm.dept=' ' THEN
         IF NOT cl_null(maj.maj21) THEN
            IF maj.maj24 IS NULL THEN
               SELECT SUM(aah04-aah05) INTO amt1
                 FROM aah_file,aag_file
                WHERE aah00 = tm.b
                  AND aah00 = aag00        #No.FUN-740020  
                  AND aah01 BETWEEN maj.maj21 AND maj.maj22
                  AND aah02 = tm.yy1
                  AND aah03 BETWEEN tm.bm1 AND tm.em1
                  AND aah01 = aag01
#                 AND aag07 MATCHES '[23]'   #No.TQC-B30100 Mark
                  AND aag07 IN ('2','3')     #No..TQC-B30100 add
            ELSE 
               SELECT SUM(aao05-aao06) INTO amt1
                 FROM aao_file,aag_file
                WHERE aao00 = tm.b
                  AND aao00 = aag00        #No.FUN-740020  
                  AND aao01 BETWEEN maj.maj21 AND maj.maj22
                  AND aao02 BETWEEN maj.maj24 AND maj.maj25
                  AND aao03 = tm.yy1
                  AND aao04 BETWEEN tm.bm1 AND tm.em1
                  AND aao01 = aag01
#                 AND aag07 MATCHES '[23]'   #No.TQC-B30100 Mark
                  AND aag07 IN ('2','3')     #No..TQC-B30100 add
            END IF
            IF STATUS THEN
#              CALL cl_err('sel aah1',STATUS,1) #No.FUN-660123
               CALL cl_err3("sel","aao_file,aag_file",tm.yy1,"",STATUS,"","sel aah1",1)   #No.FUN-660123
               EXIT FOREACH 
            END IF
            IF amt1 IS NULL THEN 
               LET amt1 = 0
            END IF
     
            IF maj.maj24 IS NOT NULL AND maj.maj24 != ' ' THEN     
              #SELECT SUM(afc06) INTO amt1_1                                                  #CHI-B60055 mark
               SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0)) INTO amt1_1  #CHI-B60055
                 FROM afc_file,afb_file
                WHERE afc00 = afb00
                  AND afc01 = afb01
                  AND afc02 = afb02 
                  AND afc03 = afb03
                  AND afc04 = afb04 
                  AND afc00 = tm.b
                  AND afb00 = tm.b      #No.FUN-740020 
                  AND afc01 = tm.budget
                  AND afc02 BETWEEN maj.maj21 AND maj.maj22
                  AND afc03 = tm.yy1
                  AND afc041 BETWEEN maj.maj24 AND maj.maj25      #MOD-9C0100 afc04 modify afc041
                  AND afc05 BETWEEN tm.bm1 AND tm.em1
                 #AND afb15 = '2'     #---- 部門預算              #MOD-9C0100 mark
                  AND afbacti = 'Y'   #MOD-610106
            ELSE
              #SELECT SUM(afc06) INTO amt1_1                                                  #CHI-B60055 mark
               SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0)) INTO amt1_1  #CHI-B60055
                 FROM afc_file,afb_file
                WHERE afc00 = afb00
                  AND afc01 = afb01
                  AND afc02 = afb02 
                  AND afc03 = afb03
                  AND afc04 = afb04 
                  AND afc00 = tm.b 
                  AND afb00 = tm.b      #No.FUN-740020 
                  AND afc01 = tm.budget
                  AND afc02 BETWEEN maj.maj21 AND maj.maj22
                  AND afc03 = tm.yy1
                  AND afc05 BETWEEN tm.bm1 AND tm.em1
                  AND afb15 = '1'     #---- 整體預算
                  AND afbacti = 'Y'   #MOD-610106
            END IF
            IF STATUS THEN
#              CALL cl_err('sel afc:',STATUS,1)  #No.FUN-660123
               CALL cl_err3("sel","afc_file,afb_file","","",STATUS,"","sel afc:",1)   #No.FUN-660123              
               EXIT FOREACH
            END IF
            IF amt1_1 IS NULL THEN 
               LET amt1_1 = 0 
            END IF
         END IF      
      ELSE
         IF NOT cl_null(maj.maj21) THEN
            SELECT SUM(aao05-aao06) INTO amt1
              FROM aao_file,aag_file
             WHERE aao00 = tm.b
               AND aao00 = aag00        #No.FUN-740020  
               AND aao01 BETWEEN maj.maj21 AND maj.maj22
               AND aao02 = tm.dept
               AND aao03 = tm.yy1
               AND aao04 BETWEEN tm.bm1 AND tm.em1
               AND aao01 = aag01
#              AND aag07 MATCHES '[23]'   #No.TQC-B30100 Mark
               AND aag07 IN ('2','3')     #No..TQC-B30100 add
            IF STATUS THEN
#              CALL cl_err('sel aah1',STATUS,1)   #No.FUN-660123
               CALL cl_err3("sel","aao_file,aag_file",tm.dept,"",SQLCA.sqlcode,"","sel aah1",1)   #No.FUN-660123
               EXIT FOREACH 
            END IF
            IF amt1 IS NULL THEN
               LET amt1 = 0
            END IF
     
           #SELECT SUM(afc06) INTO amt1_1                                                  #CHI-B60055 mark
            SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0)) INTO amt1_1  #CHI-B60055
              FROM afc_file,afb_file
             WHERE afc00 = afb00
               AND afc01 = afb01
               AND afc02 = afb02 
               AND afc03 = afb03
               AND afc04 = afb04 
               AND afc00 = tm.b
               AND afb00 = tm.b      #No.FUN-740020 
               AND afc01 = tm.budget
               AND afc02 BETWEEN maj.maj21 AND maj.maj22
               AND afc03 = tm.yy1
               AND afc041 = tm.dept                #MOD-9C0100 afc04 modify afc041
               AND afc05 BETWEEN tm.bm1 AND tm.em1
              #AND afb15 = '2'     #---- 部門預算  #MOD-9C0100 mark
               AND afbacti = 'Y'   #MOD-610106
            IF STATUS THEN
#              CALL cl_err('sel afc:',STATUS,1)    #No.FUN-660123
               CALL cl_err3("sel","afc_file,afb_file",tm.yy1,tm.dept,SQLCA.sqlcode,"","sel afc:",1)   #No.FUN-660123
               EXIT FOREACH
            END IF
            IF amt1_1 IS NULL THEN
               LET amt1_1 = 0
            END IF
         END IF      
      END IF
    
      #-----MOD-6B0126--------- 
      ##No.+331 010702 add 
      #IF maj.maj07 = '1' THEN
      #   LET amt1_1 = amt1_1 * -1
      #END IF
      ##No.+331 end---
      #-----END MOD-6B0126-----
     
      IF tm.o = 'Y' THEN
         LET amt1 = amt1 * tm.q   #匯率的轉換
         LET amt1_1 = amt1_1 * tm.q 
      END IF
 
      IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0  THEN      #合計階數處理
         FOR i = 1 TO 100
            LET g_tot1[i] = g_tot1[i] + amt1
            LET g_tot1_1[i] = g_tot1_1[i] + amt1_1 
         END FOR
 
         LET k = maj.maj08 
         LET sr.bal1 = g_tot1[k] 
         LET sr.bal1_1 = g_tot1_1[k]
         FOR i = 1 TO maj.maj08 
            LET g_tot1[i] = 0
            LET g_tot1_1[i] = 0 
         END FOR
      ELSE 
         IF maj.maj03 = '5' THEN
            LET sr.bal1 = amt1
            LET sr.bal1_1 = amt1_1
         ELSE
            LET sr.bal1 = NULL 
            LET sr.bal1_1 = NULL 
         END IF
      END IF
 
      IF maj.maj03 = '0' THEN
         CONTINUE FOREACH
      END IF #本行不印出
 
      IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[0125]"              #CHI-CC0023 add maj03 match 5 
         AND sr.bal1 = 0 AND sr.bal1_1 = 0 THEN
         CONTINUE FOREACH                        #餘額為 0 者不列印
      END IF
 
      IF tm.f>0 AND maj.maj08 < tm.f THEN
         CONTINUE FOREACH                        #最小階數起列印
      END IF
 
      IF maj.maj07 = '2' THEN                                                                                                    
         LET sr.bal1 = sr.bal1 * -1                                                                                              
      END IF
      IF tm.h = 'Y' THEN                                                                                                         
         LET maj.maj20 = maj.maj20e                                                                                              
      END IF
      LET l_amt1 = sr.bal1 - sr.bal1_1                                                                                     
                                                                                                                                    
      IF sr.bal1_1 = 0 THEN                                                                                                
         LET l_per1 = 0                                                                                                    
      ELSE                                                                                                                 
         LET l_per1 = l_amt1 / sr.bal1_1 * 100                                                                             
      END IF                                                                                                               
                                                                                                                                  
      IF tm.d MATCHES '[23]' THEN                                                                                          
          LET sr.bal1 = sr.bal1 / g_unit                                                                                    
          LET sr.bal1_1 = sr.bal1_1 / g_unit                                                                                
          LET l_amt1 = l_amt1 / g_unit
      END IF                                                                                                               
                                                                                                                                    
      LET maj.maj20 = maj.maj05 SPACES,maj.maj20   
      IF maj.maj04=0 THEN
         EXECUTE insert_prep USING 
                 maj.maj20,maj.maj20e,maj.maj02,maj.maj03,
                 sr.bal1,sr.bal1_1,l_amt1,l_per1,
                 '2'       
      ELSE 
         EXECUTE insert_prep USING
                 maj.maj20,maj.maj20e,maj.maj02,maj.maj03,
                 sr.bal1,sr.bal1_1,l_amt1,l_per1,
                 '2'
         FOR i=1 TO maj.maj04
         EXECUTE insert_prep USING
                 maj.maj20,maj.maj20e,maj.maj02,maj.maj03,
                 '0','0','0','0',
                 '1'
         END FOR
      END IF
 
#     OUTPUT TO REPORT r120_rep(maj.*, sr.*)
 
   END FOREACH
 
#  FINISH REPORT r120_rep
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str= g_mai02,";",tm.d,";",tm.a,";",tm.p,";",tm.budget,";",tm.yy1,";",tm.bm1,";",
              tm.em1,";",tm.title1,";",tm.e,";",m_gem02
   CALL cl_prt_cs3('aglr120','aglr120',g_sql,g_str)
#No.FUN-780060--end--
END FUNCTION
#No.FUN-780060--start--
{REPORT r120_rep(maj, sr)
   DEFINE l_last_sw    LIKE type_file.chr1      #No.FUN-680098   VARCHAR(1)
   DEFINE l_unit       LIKE zaa_file.zaa08      #No.FUN-680098   VARCHAR(4)
   DEFINE maj          RECORD LIKE maj_file.*
   DEFINE sr           RECORD
                          bal1,bal1_1      LIKE aah_file.aah04
                       END RECORD
   DEFINE l_amt1       LIKE aah_file.aah04
   DEFINE l_per1       LIKE fid_file.fid03    #No.FUN-680098  dec(8,3)
   DEFINE g_head1      STRING
 
   OUTPUT
      TOP MARGIN g_top_margin 
      LEFT MARGIN g_left_margin 
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY maj.maj02
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         LET g_x[1] = g_mai02
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)-1,g_x[1] CLIPPED   #No.TQC-6A0093
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
     
         #金額單位之列印
         CASE tm.d
              WHEN '1'  LET l_unit = g_x[14]
              WHEN '2'  LET l_unit = g_x[15]
              WHEN '3'  LET l_unit = g_x[16]
              OTHERWISE LET l_unit = ' '
         END CASE
 
         LET g_head1 = g_x[11] CLIPPED,tm.a,'               ',
                       g_x[12] CLIPPED,tm.p,'     ',
                       g_x[13] CLIPPED,l_unit
         PRINT g_head1
         LET g_head1 = g_x[9] CLIPPED,tm.budget CLIPPED
         PRINT g_head1
         LET g_head1 = g_x[10] CLIPPED,tm.yy1 USING '<<<<','/',
                       tm.bm1 USING'&&','-',tm.em1 USING'&&',' ',m_gem02 
         #PRINT g_head1                                        #FUN-660060 remark
         PRINT COLUMN ((g_len-FGL_WIDTH(g_head1 CLIPPED))/2)+1,g_head1  CLIPPED #FUN-660060  #No.TQC-6A0093
         PRINT g_dash[1,g_len]
         LET g_head1 = tm.title1,"(",tm.yy1 USING '<<<<','/',
                       tm.bm1 USING'&&','-',tm.em1 USING'&&',")" 
         PRINT g_head1
         PRINT COLUMN g_c[31],g_dash2[1,g_w[31]],
               COLUMN g_c[32],g_dash2[1,(g_w[32]+g_w[33]+g_w[34]+g_w[35]+3)]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35] 
         PRINT g_dash1 
         LET l_last_sw = 'n'
     
      ON EVERY ROW
         IF maj.maj07 = '2' THEN
            LET sr.bal1 = sr.bal1 * -1 
         END IF
 
         #-----MOD-6B0126---------  
         #IF maj.maj07 = '1' THEN
         #   LET sr.bal1_1 = sr.bal1_1 * -1
         #END IF
         #-----END MOD-6B0126-----
 
         IF tm.h = 'Y' THEN
            LET maj.maj20 = maj.maj20e
         END IF
 
         CASE
            WHEN maj.maj03 = '9'
               SKIP TO TOP OF PAGE
            WHEN maj.maj03 = '3' 
               PRINT COLUMN g_c[32],g_dash2[1,g_w[32]],
                     COLUMN g_c[33],g_dash2[1,g_w[33]],
                     COLUMN g_c[34],g_dash2[1,g_w[34]],
                     COLUMN g_c[35],g_dash2[1,g_w[35]]
            WHEN maj.maj03 = '4'
               PRINT g_dash2 CLIPPED  #No.TQC-6A0093
            OTHERWISE
               FOR i = 1 TO maj.maj04
                  PRINT
               END FOR
 
               LET l_amt1 = sr.bal1 - sr.bal1_1
 
               IF sr.bal1_1 = 0 THEN
                  LET l_per1 = 0                       
               ELSE
                  LET l_per1 = l_amt1 / sr.bal1_1 * 100
               END IF
 
               IF tm.d MATCHES '[23]' THEN
                  LET sr.bal1 = sr.bal1 / g_unit
                  LET sr.bal1_1 = sr.bal1_1 / g_unit
                  LET l_amt1 = l_amt1 / g_unit
               END IF
 
               LET maj.maj20 = maj.maj05 SPACES,maj.maj20
               PRINT COLUMN g_c[31],maj.maj20,
                     COLUMN g_c[32],cl_numfor(sr.bal1,32,tm.e),
                     COLUMN g_c[33],cl_numfor(sr.bal1_1,33,tm.e),
                     COLUMN g_c[34],cl_numfor(l_amt1,34,tm.e),
                      #COLUMN g_c[35],l_per1 USING "--&.&&"     #MOD-550140    
                      #COLUMN g_c[35],l_per1 USING "###.&&"      #MOD-550140    #MOD-5A0261
                     COLUMN g_c[35],l_per1 USING "-###.&&"     #MOD-5A0261
         END CASE
     
      ON LAST ROW
         LET l_last_sw = 'y'
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
     
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT}
#No.FUN-780060--end--
