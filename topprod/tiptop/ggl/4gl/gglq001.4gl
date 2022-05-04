# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: gglq001.4gl
# Descriptions...: 合並報表調整前底稿查詢
# Date & Author..: No.FUN-B60159 11/06/28 By lutingting
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-B90026 11/09/04 By lutingting axb07>20改为axb06 = 'Y'
# Modify.........: No.MOD-C20002 12/02/01 By wujie  没有用到合计加减项，调整处理借余贷余的时机
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No.CHI-C80041 12/12/22 By bart 排除作廢

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE  tm         RECORD
                     rtype   LIKE type_file.chr1,  #報表Type  
                     a       LIKE mai_file.mai01,  #報表結構編號
                     b       LIKE aaa_file.aaa01,  #帳別編號     
                     axa01   LIKE axa_file.axa01,  #列印族群
                     axa02   LIKE axa_file.axa02,  #列印族群
                     axa03   LIKE axa_file.axa03,  #列印族群
                     yy      LIKE axi_file.axi03,  #輸入年度   
                     bm      LIKE axi_file.axi04,  #Begin 期別 
                     em      LIKE axi_file.axi04,  # End  期別 
                     c       LIKE type_file.chr1,                #異動額及餘額為0者是否列印 
                     d       LIKE type_file.chr1,                #金額單位    
                     e       LIKE type_file.chr1,                #打印額外名稱
                     f       LIKE type_file.num5,                #列印最小階數
                     more    LIKE type_file.chr1,                #Input more condition(Y/N)  
                     ver     LIKE axg_file.axg17                
                   END RECORD,
         i,j,k,g_mm  LIKE type_file.num5,    
         g_unit      LIKE type_file.num10,          #金額單位基數    
         g_buf       LIKE type_file.chr1000,  
         g_cn        LIKE type_file.num5,      
         g_flag      LIKE type_file.chr1,       
         g_bookno    LIKE aah_file.aah00,           #帳別
         g_gem05     LIKE gem_file.gem05,
         m_dept      LIKE type_file.chr1000,     
         g_mai02     LIKE mai_file.mai02,
         g_mai03     LIKE mai_file.mai03,
         g_abd01     LIKE abd_file.abd01,
         g_axa01     LIKE axa_file.axa01,
         g_total     DYNAMIC ARRAY OF RECORD
                     maj02   LIKE maj_file.maj02,
                     amt     LIKE type_file.num20_6,
                     amt1    LIKE type_file.num20_6,
                     amt2    LIKE type_file.num20_6        
                     END RECORD,
         g_no        LIKE type_file.num5,  
         g_group     LIKE type_file.num5,  
         g_tot1      ARRAY[101] OF LIKE type_file.num20_6,
         g_tot2      ARRAY[101] OF LIKE type_file.num20_6,
         g_tot3      ARRAY[101] OF LIKE type_file.num20_6,
         g_tot4      ARRAY[101] OF LIKE type_file.num20_6,
         g_tot5      ARRAY[101] OF LIKE type_file.num20_6,
         g_tot2_t      ARRAY[101] OF LIKE type_file.num20_6,
         g_tot3_t      ARRAY[101] OF LIKE type_file.num20_6,
         g_dept      DYNAMIC ARRAY OF RECORD
		     axa01  LIKE axa_file.axa01,
		     axa02  LIKE axa_file.axa02,
		     axa03  LIKE axa_file.axa03,
		     axb04  LIKE axb_file.axb04,
		     axb05  LIKE axb_file.axb05
		     END RECORD
DEFINE   g_aag       DYNAMIC ARRAY OF RECORD
                     aag01      LIKE maj_file.maj20,
                     sum1       LIKE aah_file.aah04,
                     sum2       LIKE aah_file.aah04,
                     sum3       LIKE aah_file.aah04,
                     sum4       LIKE aah_file.aah04,
                     sum5       LIKE aah_file.aah04,
                     sum6       LIKE aah_file.aah04,
                     sum7       LIKE aah_file.aah04,
                     sum8       LIKE aah_file.aah04,
                     sum9       LIKE aah_file.aah04,
                     sum10      LIKE aah_file.aah04,
                     sum11      LIKE aah_file.aah04,
                     sum12      LIKE aah_file.aah04,
                     sum13      LIKE aah_file.aah04,
                     sum14      LIKE aah_file.aah04,
                     sum15      LIKE aah_file.aah04,
                     sum16      LIKE aah_file.aah04,
                     sum17      LIKE aah_file.aah04,
                     sum18      LIKE aah_file.aah04,
                     sum19      LIKE aah_file.aah04,
                     sum20      LIKE aah_file.aah04,
                     sum21      LIKE aah_file.aah04,
                     sum22      LIKE aah_file.aah04,
                     sum23      LIKE aah_file.aah04,
                     sum24      LIKE aah_file.aah04,
                     sum25      LIKE aah_file.aah04,
                     sum26      LIKE aah_file.aah04,
                     sum27      LIKE aah_file.aah04,
                     sum28      LIKE aah_file.aah04,
                     sum29      LIKE aah_file.aah04,
                     sum30      LIKE aah_file.aah04,
                     sum31      LIKE aah_file.aah04,
                     sum32      LIKE aah_file.aah04,
                     sum33      LIKE aah_file.aah04,
                     sum34      LIKE aah_file.aah04,
                     sum35      LIKE aah_file.aah04,
                     sum36      LIKE aah_file.aah04,
                     sum37      LIKE aah_file.aah04,
                     sum38      LIKE aah_file.aah04,
                     sum39      LIKE aah_file.aah04,
                     sum40      LIKE aah_file.aah04,
                     sum41      LIKE aah_file.aah04,
                     sum42      LIKE aah_file.aah04,
                     sum43      LIKE aah_file.aah04,
                     sum44      LIKE aah_file.aah04,
                     sum45      LIKE aah_file.aah04,
                     sum46      LIKE aah_file.aah04,
                     sum47      LIKE aah_file.aah04,
                     sum48      LIKE aah_file.aah04,
                     sum49      LIKE aah_file.aah04,
                     sum50      LIKE aah_file.aah04,
                     bal2_t     LIKE aah_file.aah04,
                     bal3_t     LIKE aah_file.aah04,
                     bal2       LIKE aah_file.aah04,
                     bal3       LIKE aah_file.aah04,
                     bal4       LIKE aah_file.aah04,
                     bal5       LIKE aah_file.aah04,
                     bal6       LIKE aah_file.aah04,   #调整前合计
                     bal7       LIKE aah_file.aah04,   #调整后合计
                     bal1       LIKE aah_file.aah04    #调整冲销后合计
                     END RECORD
DEFINE  g_aaa03      LIKE aaa_file.aaa03
DEFINE  g_i          LIKE type_file.num5          #count/index for any purpose    
DEFINE  g_rec_b      LIKE type_file.num5
DEFINE  g_rec_b1     LIKE type_file.num5
DEFINE  g_msg        LIKE type_file.chr1000   
DEFINE  g_cnt        LIKE type_file.num5       
DEFINE  g_sql        STRING
DEFINE  l_table      LIKE type_file.chr20
DEFINE  g_str        STRING
DEFINE  g_row_count  LIKE type_file.num10
DEFINE  g_curs_index LIKE type_file.num10
DEFINE  g_jump       LIKE type_file.num10
DEFINE  mi_no_ask    LIKE type_file.num5
DEFINE  l_ac         LIKE type_file.num5
DEFINE  g_msg1       LIKE type_file.chr1000   
DEFINE  g_msg2       LIKE type_file.chr1000   
DEFINE  g_aaw        RECORD LIKE aaw_file.*
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_bookno= ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)                 #Get arguments from command line
   LET g_towhom= ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway= ARG_VAL(6)
   LET g_copies= ARG_VAL(7)
   LET tm.rtype= ARG_VAL(8) 
   LET tm.a    = ARG_VAL(9)
   LET tm.b    = ARG_VAL(10)
   LET tm.axa01= ARG_VAL(11)
   LET tm.axa02= ARG_VAL(12)
   LET tm.axa03= ARG_VAL(13)
   LET tm.yy   = ARG_VAL(14)
   LET tm.bm   = ARG_VAL(15)
   LET tm.em   = ARG_VAL(16)
   LET tm.c    = ARG_VAL(17)
   LET tm.d    = ARG_VAL(18)
   LET tm.f    = ARG_VAL(19)
   LET g_rep_user = ARG_VAL(20)
   LET g_rep_clas = ARG_VAL(21)
   LET g_template = ARG_VAL(22)
   LET tm.e    = ARG_VAL(23)
   LET tm.ver  = ARG_VAL(24)

   SELECT * INTO g_aaw.* FROM aaw_file WHERE aaw00 = '0'

   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      LET g_bookno = g_aza.aza81
   END IF

   OPEN WINDOW q001_w AT 5,10
        WITH FORM "ggl/42f/gglq001" ATTRIBUTE(STYLE = g_win_style)

   CALL cl_ui_init()

    CALL cl_set_comp_entry('b',FALSE)
   CALL gglq001_table()    

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL gglq001_tm()                    
   ELSE 
      CALL gglq001()                  
   END IF

   CALL q001_menu()
   DROP TABLE gglq001_tmp;
   CLOSE WINDOW q001_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q001_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000

   WHILE TRUE
      CALL q001_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL gglq001_tm()
            END IF
     
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_aag),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION gglq001_tm()
   DEFINE p_row,p_col      LIKE type_file.num5,
          l_i              LIKE type_file.num5,
          l_sw             LIKE type_file.chr1,       #重要欄位是否空白  
          l_cmd            LIKE type_file.chr1000
   DEFINE li_chk_bookno  LIKE type_file.num5         
   DEFINE li_result      LIKE type_file.num5        
   DEFINE l_mai03        LIKE mai_file.mai03
   CALL s_dsmark(g_bookno)
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW gglq001_w1 AT p_row,p_col
        WITH FORM "ggl/42f/gglq001_1"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("gglq001_1")

   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN
     CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)  
   END IF
   LET tm.yy= YEAR(g_today)
   LET tm.bm= MONTH(g_today)
   LET tm.em= MONTH(g_today)
   LET tm.a = ' '
   LET tm.b = g_aaw.aaw01
   LET tm.ver = '00'    #寫死抓版本00的資料
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.e = 'N' 
   LET tm.f = 0
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   WHILE TRUE
      LET l_sw = 1

      INPUT BY NAME tm.rtype,tm.a,tm.b,tm.ver,tm.axa01,tm.axa02,tm.axa03, 
                    tm.yy,tm.bm,tm.em,tm.f,tm.d,tm.c,tm.e,tm.more  
          	  WITHOUT DEFAULTS

         BEFORE INPUT
             CALL cl_qbe_init()

         ON ACTION locale
            CALL cl_dynamic_locale()  
            CALL cl_show_fld_cont()    
            LET g_action_choice = "locale"

         ON CHANGE rtype
            IF tm.rtype = '1' THEN
              LET l_mai03 = '2'
           ELSE
              LET l_mai03 = '3'
           END IF
           SELECT mai01 INTO tm.a FROM mai_file WHERE mai00 = g_aaw.aaw01 AND mai03 = l_mai03
           DISPLAY BY NAME tm.a

         AFTER FIELD rtype
           IF tm.rtype = '1' THEN
              LET l_mai03 = '2'
           ELSE
              LET l_mai03 = '3'
           END IF 
           SELECT mai01 INTO tm.a FROM mai_file WHERE mai00 = g_aaw.aaw01 AND mai03 = l_mai03

         AFTER FIELD a
            IF cl_null(tm.a) THEN NEXT FIELD a END IF
            CALL s_chkmai(tm.a,'RGL') RETURNING li_result
            IF NOT li_result THEN
              CALL cl_err(tm.a,g_errno,1)
              NEXT FIELD a
            END IF
            SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
             WHERE mai01 = tm.a AND maiacti IN ('Y','y')
            IF STATUS THEN 
               CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0) 
               NEXT FIELD a
           #No.TQC-C50042   ---start---   Add
            ELSE
               IF g_mai03 = '5' OR g_mai03 = '6' THEN
                  CALL cl_err('','agl-268',0)
                  NEXT FIELD a
               END IF
           #No.TQC-C50042   ---end---     Add
            END IF

         AFTER FIELD b
            IF cl_null(tm.b) THEN 
             NEXT FIELD b END IF
            CALL s_check_bookno(tm.b,g_user,g_plant)
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD b
            END IF

         SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
            IF STATUS THEN
               CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0) 
               NEXT FIELD b 
            END IF

         AFTER FIELD ver
            IF cl_null(tm.ver) THEN NEXT FIELD ver END IF 
       
         AFTER FIELD axa01
            IF NOT cl_null(tm.axa01) THEN
               SELECT DISTINCT axa01 FROM axa_file WHERE axa01=tm.axa01
               IF STATUS THEN
                  CALL cl_err3("sel"," axa_file",tm.axa01,"","agl-117","","",0) 
                  NEXT FIELD axa01 
               END IF
            END IF

         AFTER FIELD axa02
            IF cl_null(tm.axa02) THEN NEXT FIELD axa02 END IF
            SELECT axa02 FROM axa_file WHERE axa01=tm.axa01 AND axa02=tm.axa02
            IF STATUS THEN 
               CALL cl_err3("sel"," axa_file",tm.axa01,tm.axa02,STATUS,"","sel axa:",0)
               NEXT FIELD axa02
            END IF

         AFTER FIELD axa03
            IF cl_null(tm.axa03) THEN NEXT FIELD axa03 END IF
            SELECT axa03 INTO tm.axa03 FROM axa_file
                   WHERE axa01=tm.axa01 AND axa02=tm.axa02 AND axa03=tm.axa03
            IF STATUS THEN
               CALL cl_err3("sel"," axa_file",tm.axa01,tm.axa02,STATUS,"","sel axa:",0)
               NEXT FIELD axa03 
            END IF
            DISPLAY BY NAME tm.axa03

         AFTER FIELD c
            IF cl_null(tm.c) OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF

         AFTER FIELD yy
            IF cl_null(tm.yy) OR tm.yy = 0 THEN NEXT FIELD yy END IF

         AFTER FIELD bm
         IF NOT cl_null(tm.bm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.bm > 12 OR tm.bm < 0 THEN  #需可包含期初  #tm.em<1-->0
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            ELSE
               IF tm.bm > 13 OR tm.bm < 0 THEN  #需可包含期初  #tm.em<1-->0
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            END IF
         END IF

         AFTER FIELD em
         IF NOT cl_null(tm.em) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.em > 12 OR tm.em < 0 THEN   #需可包含期初  #tm.em<1-->0
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            ELSE
               IF tm.em > 13 OR tm.em < 0 THEN   #需可包含期初  #tm.em<1-->0
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            END IF
         END IF
            IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF

         AFTER FIELD d
            IF cl_null(tm.d) OR tm.d NOT MATCHES'[123]' THEN NEXT FIELD d END IF

         AFTER FIELD f
            IF cl_null(tm.f) OR tm.f < 0  THEN
               LET tm.f = 0 DISPLAY BY NAME tm.f NEXT FIELD f
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
            IF cl_null(tm.yy) THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.yy
               CALL cl_err('',9033,0)
            END IF
            IF cl_null(tm.bm) THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.bm
            END IF
            IF cl_null(tm.em) THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.em
           END IF

           IF tm.rtype = '1' THEN LET tm.bm = 0 END IF

           IF tm.d = '1' THEN LET g_unit = 1       END IF
           IF tm.d = '2' THEN LET g_unit = 1000    END IF
           IF tm.d = '3' THEN LET g_unit = 1000000 END IF
           IF l_sw = 0 THEN
               LET l_sw = 1
               NEXT FIELD a
               CALL cl_err('',9033,0)
           END IF

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(a)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_mai'
                  LET g_qryparam.default1 = tm.a
                  LET g_qryparam.where = "mai03='",l_mai03,"'" 
                  CALL cl_create_qry() RETURNING tm.a
                  DISPLAY BY NAME tm.a
                  NEXT FIELD a

               WHEN INFIELD(b)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aaa'
                  LET g_qryparam.default1 = tm.b
                  CALL cl_create_qry() RETURNING tm.b
                  DISPLAY BY NAME tm.b
                  NEXT FIELD b

               WHEN INFIELD(axa01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_axa"
                  LET g_qryparam.default1 = tm.axa01
                  CALL cl_create_qry() RETURNING tm.axa01,tm.axa02,tm.axa03
                  DISPLAY BY NAME tm.axa01,tm.axa02,tm.axa03
                  NEXT FIELD axa01
          END CASE
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

          ON ACTION qbe_select
             CALL cl_qbe_select()

          ON ACTION qbe_save
             CALL cl_qbe_save()

      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW q001_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      
          WHERE zz01='gglq001'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('gglq001','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_bookno CLIPPED,"'" ,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.rtype CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'", 
                        " '",tm.axa01 CLIPPED,"'",
                        " '",tm.axa02 CLIPPED,"'",  
                        " '",tm.axa03 CLIPPED,"'", 
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.bm CLIPPED,"'",
                        " '",tm.em CLIPPED,"'",
                        " '",tm.c CLIPPED,"'",
                        " '",tm.d CLIPPED,"'",
                        " '",tm.e CLIPPED,"'",  
                        " '",tm.f CLIPPED,"'" ,
                        " '",g_rep_user CLIPPED,"'",
                        " '",g_rep_clas CLIPPED,"'",
                        " '",g_template CLIPPED,"'",
                        " '",tm.ver CLIPPED,"'"     
            CALL cl_cmdat('gglq001',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW gglq001_w1
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL gglq001()
      ERROR ""
      EXIT WHILE
   END WHILE
   CLOSE WINDOW gglq001_w1
 
   CALL g_aag.clear() 
   CALL gglq001_cs()
END FUNCTION

FUNCTION gglq001()
   DEFINE l_sql          LIKE type_file.chr1000       # RDSQL STATEMENT       
   DEFINE l_chr          LIKE type_file.chr1
   DEFINE l_leng,l_leng2 LIKE type_file.num5
   DEFINE l_abe03        LIKE abe_file.abe03
   DEFINE l_abd02        LIKE abd_file.abd02
   DEFINE l_gem02        LIKE gem_file.gem02
   DEFINE l_dept         LIKE gem_file.gem01
   DEFINE l_maj20        LIKE maj_file.maj20, 
          l_bal          LIKE type_file.num20_6     
   DEFINE sr             RECORD
                         no        LIKE type_file.num5,    
                         maj02     LIKE maj_file.maj02,  
                         maj03     LIKE type_file.chr1,   
                         maj04     LIKE type_file.num5,  
                         maj05     LIKE type_file.num5, 
                         maj07     LIKE type_file.chr1,
                         maj09     LIKE type_file.chr1,
                         maj20     LIKE maj_file.maj20,
                         maj20e    LIKE maj_file.maj20e,
                         maj21     LIKE maj_file.maj21,
                         maj22     LIKE maj_file.maj22,
                         bal1      LIKE type_file.num20_6,   #實際 
                         bal2      LIKE type_file.num20_6,   #銷除D 
                         bal3      LIKE type_file.num20_6,   #銷除C 
                         bal4      LIKE type_file.num20_6,   #會計師調整D 
                         bal5      LIKE type_file.num20_6,   #會計師調整C 
                         bal2_t    LIKE type_file.num20_6,   #调整D
                         bal3_t    LIKE type_file.num20_6    #调整C
                         END RECORD
   DEFINE l_str1,l_str2,l_str3,l_str4,l_str5     LIKE type_file.chr20    
   DEFINE l_str6,l_str7,l_str8,l_str9,l_str10    LIKE type_file.chr20   
   DEFINE l_str,l_totstr  LIKE type_file.chr1000    
   DEFINE m_abd02        LIKE abd_file.abd02
   DEFINE l_no,l_cn,l_cnt,l_i,l_j LIKE type_file.num5      
   DEFINE l_cmd,l_cmd1   LIKE type_file.chr1000 
   DEFINE l_cmd2         LIKE type_file.chr1000 
   DEFINE l_amt          LIKE type_file.num20_6 
   DEFINE l_gem02_o      LIKE gem_file.gem02
   DEFINE l_count        LIKE type_file.num5,  
          l_modi         LIKE type_file.chr1000,
          l_d_amt,l_c_amt,l_dc_amt  LIKE type_file.num20_6

   DEFINE l_modi1,l_modi2,l_modi3,l_modi4 LIKE type_file.num20_6

   DEFINE sr2 RECORD  #新版寫法，部門要拆開，不要一次把六個部門寫入一個字串裡
              l_dept1   LIKE gem_file.gem02,
              l_dept2   LIKE gem_file.gem02,
              l_dept3   LIKE gem_file.gem02,
              l_dept4   LIKE gem_file.gem02,
              l_dept5   LIKE gem_file.gem02,
              l_dept6   LIKE gem_file.gem02,
              l_dept7   LIKE gem_file.gem02,
              l_dept8   LIKE gem_file.gem02,
              l_dept9   LIKE gem_file.gem02,
              l_dept10  LIKE gem_file.gem02,
              l_dept11  LIKE gem_file.gem02,
              l_dept12  LIKE gem_file.gem02,
              l_dept13  LIKE gem_file.gem02,
              l_dept14  LIKE gem_file.gem02,
              l_dept15  LIKE gem_file.gem02,
              l_dept16  LIKE gem_file.gem02,
              l_dept17  LIKE gem_file.gem02,
              l_dept18  LIKE gem_file.gem02,
              l_dept19  LIKE gem_file.gem02,
              l_dept20  LIKE gem_file.gem02,
              l_dept21  LIKE gem_file.gem02,
              l_dept22  LIKE gem_file.gem02,
              l_dept23  LIKE gem_file.gem02,
              l_dept24  LIKE gem_file.gem02,
              l_dept25  LIKE gem_file.gem02, 
              l_dept26  LIKE gem_file.gem02,
              l_dept27  LIKE gem_file.gem02,
              l_dept28  LIKE gem_file.gem02,
              l_dept29  LIKE gem_file.gem02,
              l_dept30  LIKE gem_file.gem02,
              l_dept31  LIKE gem_file.gem02,
              l_dept32  LIKE gem_file.gem02,
              l_dept33  LIKE gem_file.gem02,
              l_dept34  LIKE gem_file.gem02,
              l_dept35  LIKE gem_file.gem02,
              l_dept36  LIKE gem_file.gem02,
              l_dept37  LIKE gem_file.gem02,
              l_dept38  LIKE gem_file.gem02,
              l_dept39  LIKE gem_file.gem02,
              l_dept40  LIKE gem_file.gem02,
              l_dept41  LIKE gem_file.gem02,
              l_dept42  LIKE gem_file.gem02,
              l_dept43  LIKE gem_file.gem02,
              l_dept44  LIKE gem_file.gem02,
              l_dept45  LIKE gem_file.gem02,
              l_dept46  LIKE gem_file.gem02,
              l_dept47  LIKE gem_file.gem02,
              l_dept48  LIKE gem_file.gem02,
              l_dept49  LIKE gem_file.gem02,
              l_dept50  LIKE gem_file.gem02,
              l_dept51  LIKE gem_file.gem02,
              l_dept52  LIKE gem_file.gem02,
              l_dept53  LIKE gem_file.gem02,
              l_dept54  LIKE gem_file.gem02,
              l_dept55  LIKE gem_file.gem02,
              l_dept56  LIKE gem_file.gem02,
              l_dept57  LIKE gem_file.gem02,
              l_dept58  LIKE gem_file.gem02,
              l_dept59  LIKE gem_file.gem02
              END RECORD
   DEFINE sr3 RECORD  #新版寫法，所有金額、百分比要拆開，不要把所有的數值寫入一>
              l_amount1   LIKE aah_file.aah04,      #金    額
              l_amount2   LIKE aah_file.aah04,      #金    額
              l_amount3   LIKE aah_file.aah04,      #金    額
              l_amount4   LIKE aah_file.aah04,      #金    額
              l_amount5   LIKE aah_file.aah04,      #金    額
              l_amount6   LIKE aah_file.aah04,      #金    額
              l_amount7   LIKE aah_file.aah04,      #金    額
              l_amount8   LIKE aah_file.aah04,      #金    額
              l_amount9   LIKE aah_file.aah04,      #金    額
              l_amount10  LIKE aah_file.aah04,      #金    額
              l_amount11  LIKE aah_file.aah04,      #金    額
              l_amount12  LIKE aah_file.aah04,      #金    額
              l_amount13  LIKE aah_file.aah04,      #金    額
              l_amount14  LIKE aah_file.aah04,      #金    額
              l_amount15  LIKE aah_file.aah04,      #金    額
              l_amount16  LIKE aah_file.aah04,      #金    額
              l_amount17  LIKE aah_file.aah04,      #金    額
              l_amount18  LIKE aah_file.aah04,      #金    額
              l_amount19  LIKE aah_file.aah04,      #金    額
              l_amount20  LIKE aah_file.aah04,      #金    額
              l_amount21  LIKE aah_file.aah04,      #金    額
              l_amount22  LIKE aah_file.aah04,      #金    額
              l_amount23  LIKE aah_file.aah04,      #金    額
              l_amount24  LIKE aah_file.aah04,      #金    額
              l_amount25  LIKE aah_file.aah04,      #金    額
              l_amount26  LIKE aah_file.aah04,      #金    額
              l_amount27  LIKE aah_file.aah04,      #金    額
              l_amount28  LIKE aah_file.aah04,      #金    額
              l_amount29  LIKE aah_file.aah04,      #金    額
              l_amount30  LIKE aah_file.aah04,      #金    額
              l_amount31  LIKE aah_file.aah04,      #金    額
              l_amount32  LIKE aah_file.aah04,      #金    額
              l_amount33  LIKE aah_file.aah04,      #金    額
              l_amount34  LIKE aah_file.aah04,      #金    額
              l_amount35  LIKE aah_file.aah04,      #金    額
              l_amount36  LIKE aah_file.aah04,      #金    額
              l_amount37  LIKE aah_file.aah04,      #金    額
              l_amount38  LIKE aah_file.aah04,      #金    額
              l_amount39  LIKE aah_file.aah04,      #金    額
              l_amount40  LIKE aah_file.aah04,      #金    額
              l_amount41  LIKE aah_file.aah04,      #金    額
              l_amount42  LIKE aah_file.aah04,      #金    額
              l_amount43  LIKE aah_file.aah04,      #金    額
              l_amount44  LIKE aah_file.aah04,      #金    額
              l_amount45  LIKE aah_file.aah04,      #金    額
              l_amount46  LIKE aah_file.aah04,      #金    額
              l_amount47  LIKE aah_file.aah04,      #金    額
              l_amount48  LIKE aah_file.aah04,      #金    額
              l_amount49  LIKE aah_file.aah04,      #金    額
              l_amount50  LIKE aah_file.aah04,      #金    額
              l_amount51  LIKE aah_file.aah04,      #金    額
              l_amount52  LIKE aah_file.aah04,      #金    額
              l_amount53  LIKE aah_file.aah04,      #金    額
              l_amount54  LIKE aah_file.aah04,      #金    額
              l_amount55  LIKE aah_file.aah04,
              l_amount56  LIKE aah_file.aah04,
              l_amount57  LIKE aah_file.aah04,
              l_amount58  LIKE aah_file.aah04,
              l_amount59  LIKE aah_file.aah04
              END RECORD


   DELETE FROM gglq001_tmp2   #luttb
   DELETE FROM gglq001_tmp    #luttb

   LET g_sql = "INSERT INTO gglq001_tmp2",
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,",
               "        ?,?,?,?,?, ?)"

   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep2:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF

   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.b AND aaf02 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF tm.e = 'Y' THEN
      LET g_len = 210 
   ELSE
      LET g_len = 250
   END IF
   FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '=' END FOR

   CASE WHEN tm.rtype='1' LET g_msg=" SUBSTR(maj23,1,1)='1'"   #oracle不接受此種寫法
        WHEN tm.rtype='2' LET g_msg=" SUBSTR(maj23,1,1)='2'"   #
        OTHERWISE LET g_msg = " 1=1"
   END CASE
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"

   PREPARE q001_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM 
   END IF
   DECLARE q001_c CURSOR FOR q001_p

   #計算筆數
   LET l_sql = "SELECT COUNT(*) FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"

   PREPARE r003_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF
   DECLARE r003_count CURSOR FOR r003_p
  
   LET g_cnt = 0
   OPEN r003_count
   FETCH r003_count INTO g_cnt
   IF cl_null(g_cnt) THEN LET g_cnt = 1  END IF  

   LET g_mm = tm.em
   LET l_i = 1
   FOR l_i = 1 TO g_cnt       
       LET g_total[l_i].maj02 = NULL
       LET g_total[l_i].amt = 0
       LET g_total[l_i].amt1= 0
       LET g_total[l_i].amt2= 0
   END FOR
   LET g_i = 1
   FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
   FOR g_i = 1 TO 100 LET g_tot2[g_i] = 0 END FOR
   FOR g_i = 1 TO 100 LET g_tot3[g_i] = 0 END FOR 
   FOR g_i = 1 TO 100 LET g_tot4[g_i] = 0 END FOR  
   FOR g_i = 1 TO 100 LET g_tot5[g_i] = 0 END FOR
   FOR g_i = 1 TO 100 LET g_tot2_t[g_i] = 0 END FOR
   FOR g_i = 1 TO 100 LET g_tot3_t[g_i] = 0 END FOR
   LET g_no = 1
   FOR g_no = 1 TO g_cnt       #300-> g_cnt
       INITIALIZE g_dept[g_no].* TO NULL
   END FOR

  #將族群填入array------------------------------------------------------
   LET l_sql = " SELECT axa01,axa02,axa03,axa02,axa03",
               "   FROM axa_file ",
               "  WHERE axa01='",tm.axa01,"'",
               "    AND axa04 = 'Y' ",       
               "  UNION ",
               " SELECT axa01,axa02,axa03,axb04,axb05",
               "   FROM axb_file,axa_file ",
               "  WHERE axa01=axb01 AND axa02=axb02 AND axa03=axb03 ",
               "    AND axa01='",tm.axa01,"'",
               #"    AND axb07 > 20 ",    #FUN-B90026     
               "    AND axb06 = 'Y'",     #FUN-B90026
               "  ORDER BY 1,2,3,4 "
   PREPARE q001_axa_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF
   DECLARE q001_axa_c CURSOR FOR q001_axa_p
   LET g_no = 1
   FOREACH q001_axa_c INTO g_dept[g_no].*
       IF SQLCA.SQLCODE THEN
          CALL cl_err('for_axa_c:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time
          EXIT PROGRAM
       END IF
       LET g_no=g_no+1
   END FOREACH
   LET g_no=g_no-1

  #---------------------------------------------------
   LET l_cnt=(50-(g_no MOD 50))+g_no     ###一行 50個
   LET l_i = 0
   LET g_group = 0
   FOR l_i = 50 TO l_cnt STEP 50 
       LET g_flag = 'n'

       INITIALIZE sr2.* TO NULL
       INITIALIZE sr3.* TO NULL
       LET g_cn = 1 
       DELETE FROM gglq001_tmp
       LET m_dept = ''
       IF l_i <= g_no THEN
          LET l_no = l_i - 50
          FOR l_cn = 1 TO 50
              LET g_i = 1
              FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
              FOR g_i = 1 TO 100 LET g_tot2[g_i] = 0 END FOR
              FOR g_i = 1 TO 100 LET g_tot3[g_i] = 0 END FOR
              FOR g_i = 1 TO 100 LET g_tot4[g_i] = 0 END FOR
              FOR g_i = 1 TO 100 LET g_tot5[g_i] = 0 END FOR 
              LET g_buf = ''
              IF l_cn>1 THEN 
                 LET l_leng2 = LENGTH(g_dept[l_cn+g_group-1].axb04) 
              END IF
              LET l_leng2 = 14 - l_leng2
              IF l_leng2<0 THEN LET l_leng2=0 END IF
              IF l_cn+g_group > g_no THEN EXIT FOR END IF
              IF l_cn = 1 THEN
                 LET m_dept = g_dept[l_cn+g_group].axb04
              ELSE
                 LET m_dept = m_dept CLIPPED,l_leng2 SPACES,
                              ' ',g_dept[l_cn+g_group].axb04
              END IF


             #START 新版部門要拆開,不一次把5個部門寫入一個字串裡
              CASE l_cn
                   WHEN 1  LET sr2.l_dept1  = g_dept[l_cn+g_group].axb04
                   WHEN 2  LET sr2.l_dept2  = g_dept[l_cn+g_group].axb04
                   WHEN 3  LET sr2.l_dept3  = g_dept[l_cn+g_group].axb04
                   WHEN 4  LET sr2.l_dept4  = g_dept[l_cn+g_group].axb04
                   WHEN 5  LET sr2.l_dept5  = g_dept[l_cn+g_group].axb04
                   WHEN 6  LET sr2.l_dept1  = g_dept[l_cn+g_group].axb04
                   WHEN 7  LET sr2.l_dept2  = g_dept[l_cn+g_group].axb04
                   WHEN 8  LET sr2.l_dept3  = g_dept[l_cn+g_group].axb04
                   WHEN 9  LET sr2.l_dept4  = g_dept[l_cn+g_group].axb04
                   WHEN 10 LET sr2.l_dept11 = g_dept[l_cn+g_group].axb04
                   WHEN 11 LET sr2.l_dept12 = g_dept[l_cn+g_group].axb04
                   WHEN 12 LET sr2.l_dept12 = g_dept[l_cn+g_group].axb04
                   WHEN 13 LET sr2.l_dept13 = g_dept[l_cn+g_group].axb04
                   WHEN 14 LET sr2.l_dept14 = g_dept[l_cn+g_group].axb04
                   WHEN 15 LET sr2.l_dept15 = g_dept[l_cn+g_group].axb04
                   WHEN 16 LET sr2.l_dept16 = g_dept[l_cn+g_group].axb04
                   WHEN 17 LET sr2.l_dept17 = g_dept[l_cn+g_group].axb04
                   WHEN 18 LET sr2.l_dept18 = g_dept[l_cn+g_group].axb04
                   WHEN 19 LET sr2.l_dept19 = g_dept[l_cn+g_group].axb04
                   WHEN 20 LET sr2.l_dept20 = g_dept[l_cn+g_group].axb04
                   WHEN 21 LET sr2.l_dept21 = g_dept[l_cn+g_group].axb04
                   WHEN 22 LET sr2.l_dept22 = g_dept[l_cn+g_group].axb04
                   WHEN 23 LET sr2.l_dept23 = g_dept[l_cn+g_group].axb04
                   WHEN 24 LET sr2.l_dept24 = g_dept[l_cn+g_group].axb04
                   WHEN 25 LET sr2.l_dept25 = g_dept[l_cn+g_group].axb04
                   WHEN 26 LET sr2.l_dept26 = g_dept[l_cn+g_group].axb04
                   WHEN 27 LET sr2.l_dept27 = g_dept[l_cn+g_group].axb04
                   WHEN 28 LET sr2.l_dept28 = g_dept[l_cn+g_group].axb04
                   WHEN 29 LET sr2.l_dept29 = g_dept[l_cn+g_group].axb04
                   WHEN 30 LET sr2.l_dept30 = g_dept[l_cn+g_group].axb04
                   WHEN 31 LET sr2.l_dept31 = g_dept[l_cn+g_group].axb04
                   WHEN 32 LET sr2.l_dept32 = g_dept[l_cn+g_group].axb04
                   WHEN 33 LET sr2.l_dept33 = g_dept[l_cn+g_group].axb04
                   WHEN 34 LET sr2.l_dept34 = g_dept[l_cn+g_group].axb04
                   WHEN 35 LET sr2.l_dept35 = g_dept[l_cn+g_group].axb04
                   WHEN 36 LET sr2.l_dept36 = g_dept[l_cn+g_group].axb04
                   WHEN 37 LET sr2.l_dept37 = g_dept[l_cn+g_group].axb04
                   WHEN 38 LET sr2.l_dept38 = g_dept[l_cn+g_group].axb04
                   WHEN 39 LET sr2.l_dept39 = g_dept[l_cn+g_group].axb04
                   WHEN 40 LET sr2.l_dept40 = g_dept[l_cn+g_group].axb04
                   WHEN 41 LET sr2.l_dept41 = g_dept[l_cn+g_group].axb04
                   WHEN 42 LET sr2.l_dept42 = g_dept[l_cn+g_group].axb04
                   WHEN 43 LET sr2.l_dept43 = g_dept[l_cn+g_group].axb04
                   WHEN 44 LET sr2.l_dept44 = g_dept[l_cn+g_group].axb04
                   WHEN 45 LET sr2.l_dept45 = g_dept[l_cn+g_group].axb04
                   WHEN 46 LET sr2.l_dept46 = g_dept[l_cn+g_group].axb04
                   WHEN 47 LET sr2.l_dept47 = g_dept[l_cn+g_group].axb04
                   WHEN 48 LET sr2.l_dept48 = g_dept[l_cn+g_group].axb04
                   WHEN 49 LET sr2.l_dept49 = g_dept[l_cn+g_group].axb04
                   WHEN 50 LET sr2.l_dept50 = g_dept[l_cn+g_group].axb04
                   WHEN 51 LET sr2.l_dept51 = g_dept[l_cn+g_group].axb04
                   WHEN 52 LET sr2.l_dept52 = g_dept[l_cn+g_group].axb04
                   WHEN 53 LET sr2.l_dept53 = g_dept[l_cn+g_group].axb04
                   WHEN 54 LET sr2.l_dept54 = g_dept[l_cn+g_group].axb04
                   WHEN 55 LET sr2.l_dept55 = g_dept[l_cn+g_group].axb04
                   WHEN 56 LET sr2.l_dept52 = g_dept[l_cn+g_group].axb04
                   WHEN 57 LET sr2.l_dept53 = g_dept[l_cn+g_group].axb04
                   WHEN 58 LET sr2.l_dept54 = g_dept[l_cn+g_group].axb04
                   WHEN 59 LET sr2.l_dept55 = g_dept[l_cn+g_group].axb04
               
              END CASE
             #END 新版部門要拆開,不一次把5個部門寫入一個字串裡
              
              
              CALL q001_process(l_cn+g_group)  
              LET g_cn = l_cn+g_group         
          END FOR
       ELSE
          LET l_no = (l_i - 50)
          FOR l_cn = 1 TO (g_no - (l_i - 50))
              LET g_i = 1
              FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
              FOR g_i = 1 TO 100 LET g_tot2[g_i] = 0 END FOR
              FOR g_i = 1 TO 100 LET g_tot3[g_i] = 0 END FOR 
              FOR g_i = 1 TO 100 LET g_tot4[g_i] = 0 END FOR 
              FOR g_i = 1 TO 100 LET g_tot5[g_i] = 0 END FOR 
              LET g_buf = ''
              IF l_cn>1 THEN 
                 LET l_leng2 = LENGTH(g_dept[l_cn+g_group-1].axb04) 
              END IF
              LET l_leng2 = 14 - l_leng2
              IF l_leng2<0 THEN LET l_leng2=0 END IF
              IF l_cn+g_group > g_no THEN EXIT FOR END IF
              IF l_cn = 1 THEN
                 LET m_dept = g_dept[l_cn+g_group].axb04
              ELSE
                 LET m_dept = m_dept CLIPPED,l_leng2 SPACES,
                              ' ',g_dept[l_cn+g_group].axb04
              END IF

             #START 新版部門要拆開,不要一次把5個部門寫入一個字串裡
              CASE l_cn
                   WHEN 1 LET sr2.l_dept1  = g_dept[l_cn+g_group].axb04
                   WHEN 2 LET sr2.l_dept2  = g_dept[l_cn+g_group].axb04
                   WHEN 3 LET sr2.l_dept3  = g_dept[l_cn+g_group].axb04
                   WHEN 4 LET sr2.l_dept4  = g_dept[l_cn+g_group].axb04
                   WHEN 5 LET sr2.l_dept5  = g_dept[l_cn+g_group].axb04
                   WHEN 6  LET sr2.l_dept1  = g_dept[l_cn+g_group].axb04
                   WHEN 7  LET sr2.l_dept2  = g_dept[l_cn+g_group].axb04
                   WHEN 8  LET sr2.l_dept3  = g_dept[l_cn+g_group].axb04
                   WHEN 9  LET sr2.l_dept4  = g_dept[l_cn+g_group].axb04
                   WHEN 10 LET sr2.l_dept11 = g_dept[l_cn+g_group].axb04
                   WHEN 11 LET sr2.l_dept12 = g_dept[l_cn+g_group].axb04
                   WHEN 12 LET sr2.l_dept12 = g_dept[l_cn+g_group].axb04
                   WHEN 13 LET sr2.l_dept13 = g_dept[l_cn+g_group].axb04
                   WHEN 14 LET sr2.l_dept14 = g_dept[l_cn+g_group].axb04
                   WHEN 15 LET sr2.l_dept15 = g_dept[l_cn+g_group].axb04
                   WHEN 16 LET sr2.l_dept16 = g_dept[l_cn+g_group].axb04
                   WHEN 17 LET sr2.l_dept17 = g_dept[l_cn+g_group].axb04
                   WHEN 18 LET sr2.l_dept18 = g_dept[l_cn+g_group].axb04
                   WHEN 19 LET sr2.l_dept19 = g_dept[l_cn+g_group].axb04
                   WHEN 20 LET sr2.l_dept20 = g_dept[l_cn+g_group].axb04
                   WHEN 21 LET sr2.l_dept21 = g_dept[l_cn+g_group].axb04
                   WHEN 22 LET sr2.l_dept22 = g_dept[l_cn+g_group].axb04
                   WHEN 23 LET sr2.l_dept23 = g_dept[l_cn+g_group].axb04
                   WHEN 24 LET sr2.l_dept24 = g_dept[l_cn+g_group].axb04
                   WHEN 25 LET sr2.l_dept25 = g_dept[l_cn+g_group].axb04
                   WHEN 26 LET sr2.l_dept26 = g_dept[l_cn+g_group].axb04
                   WHEN 27 LET sr2.l_dept27 = g_dept[l_cn+g_group].axb04
                   WHEN 28 LET sr2.l_dept28 = g_dept[l_cn+g_group].axb04
                   WHEN 29 LET sr2.l_dept29 = g_dept[l_cn+g_group].axb04
                   WHEN 30 LET sr2.l_dept30 = g_dept[l_cn+g_group].axb04
                   WHEN 31 LET sr2.l_dept31 = g_dept[l_cn+g_group].axb04
                   WHEN 32 LET sr2.l_dept32 = g_dept[l_cn+g_group].axb04
                   WHEN 33 LET sr2.l_dept33 = g_dept[l_cn+g_group].axb04
                   WHEN 34 LET sr2.l_dept34 = g_dept[l_cn+g_group].axb04
                   WHEN 35 LET sr2.l_dept35 = g_dept[l_cn+g_group].axb04
                   WHEN 36 LET sr2.l_dept36 = g_dept[l_cn+g_group].axb04
                   WHEN 37 LET sr2.l_dept37 = g_dept[l_cn+g_group].axb04
                   WHEN 38 LET sr2.l_dept38 = g_dept[l_cn+g_group].axb04
                   WHEN 39 LET sr2.l_dept39 = g_dept[l_cn+g_group].axb04
                   WHEN 40 LET sr2.l_dept40 = g_dept[l_cn+g_group].axb04
                   WHEN 41 LET sr2.l_dept41 = g_dept[l_cn+g_group].axb04
                   WHEN 42 LET sr2.l_dept42 = g_dept[l_cn+g_group].axb04
                   WHEN 43 LET sr2.l_dept43 = g_dept[l_cn+g_group].axb04
                   WHEN 44 LET sr2.l_dept44 = g_dept[l_cn+g_group].axb04
                   WHEN 45 LET sr2.l_dept45 = g_dept[l_cn+g_group].axb04
                   WHEN 46 LET sr2.l_dept46 = g_dept[l_cn+g_group].axb04
                   WHEN 47 LET sr2.l_dept47 = g_dept[l_cn+g_group].axb04
                   WHEN 48 LET sr2.l_dept48 = g_dept[l_cn+g_group].axb04
                   WHEN 49 LET sr2.l_dept49 = g_dept[l_cn+g_group].axb04
                   WHEN 50 LET sr2.l_dept50 = g_dept[l_cn+g_group].axb04
                   WHEN 51 LET sr2.l_dept51 = g_dept[l_cn+g_group].axb04
                   WHEN 52 LET sr2.l_dept52 = g_dept[l_cn+g_group].axb04
                   WHEN 53 LET sr2.l_dept53 = g_dept[l_cn+g_group].axb04
                   WHEN 54 LET sr2.l_dept54 = g_dept[l_cn+g_group].axb04
                   WHEN 55 LET sr2.l_dept55 = g_dept[l_cn+g_group].axb04
                   WHEN 56 LET sr2.l_dept52 = g_dept[l_cn+g_group].axb04
                   WHEN 57 LET sr2.l_dept53 = g_dept[l_cn+g_group].axb04
                   WHEN 58 LET sr2.l_dept54 = g_dept[l_cn+g_group].axb04
                   WHEN 59 LET sr2.l_dept55 = g_dept[l_cn+g_group].axb04
              END CASE
             #END 新版部門要拆開,不一次把5個部門寫入一個字串裡


              CALL q001_process(l_cn+g_group)
              LET g_cn = l_cn+g_group
          END FOR
          LET l_leng2 = LENGTH(g_dept[g_cn].axb04)
          LET l_leng2 = 14 - l_leng2
          IF l_leng2<0 THEN LET l_leng2=0 END IF

         #START 部門後面加上9個調整資料
         #gglq001@1 = 調整(D)     gglq001@2 = 調整(C)
         #gglq001@3 = 销除(D)     gglq001@4 = 销除(C)
         #gglq001@5 = 會計師調整(D)     gglq001@6 = 會計師調整(C)
         #gglq001@7 = SUM2(调整前合计)  gglq001@8 = SUM3(原始+调整+消除)
         #gglq001@9 = 合併後     
         #-----------------------------------------------------
          CASE g_cn MOD 50
            WHEN 1  LET sr2.l_dept2 = "gglq001@1"  LET sr2.l_dept3 = "gglq001@2"
                    LET sr2.l_dept4 = "gglq001@3"  LET sr2.l_dept5 = "gglq001@4"
                    LET sr2.l_dept6 = "gglq001@5"  LET sr2.l_dept7 = "gglq001@6"
                    LET sr2.l_dept8 = "gglq001@7"  LET sr2.l_dept9 = "gglq001@8"
                    LET sr2.l_dept10= "gglq001@9"
            WHEN 2  LET sr2.l_dept3 = "gglq001@1"  LET sr2.l_dept4 = "gglq001@2"
                    LET sr2.l_dept5 = "gglq001@3"  LET sr2.l_dept6 = "gglq001@4"
                    LET sr2.l_dept7 = "gglq001@5"  LET sr2.l_dept8 = "gglq001@6"
                    LET sr2.l_dept9 = "gglq001@7"  LET sr2.l_dept10= "gglq001@8"
                    LET sr2.l_dept11 = "gglq001@9"
            WHEN 3  LET sr2.l_dept4 = "gglq001@1"  LET sr2.l_dept5 = "gglq001@2"
                    LET sr2.l_dept6 = "gglq001@3"  LET sr2.l_dept7 = "gglq001@4"
                    LET sr2.l_dept8 = "gglq001@5"  LET sr2.l_dept9 = "gglq001@6"
                    LET sr2.l_dept10= "gglq001@7"  LET sr2.l_dept11= "gglq001@8"
                    LET sr2.l_dept12 = "gglq001@9"
            WHEN 4  LET sr2.l_dept5 = "gglq001@1"  LET sr2.l_dept6 = "gglq001@2"
                    LET sr2.l_dept7 = "gglq001@3"  LET sr2.l_dept8 = "gglq001@4"
                    LET sr2.l_dept9 = "gglq001@5"  LET sr2.l_dept10= "gglq001@6"
                    LET sr2.l_dept11= "gglq001@7"  LET sr2.l_dept12= "gglq001@8"
                    LET sr2.l_dept13 = "gglq001@9"
            WHEN 5  LET sr2.l_dept6 = "gglq001@1"  LET sr2.l_dept7 = "gglq001@2"
                    LET sr2.l_dept8 = "gglq001@3"  LET sr2.l_dept9 = "gglq001@4"
                    LET sr2.l_dept10= "gglq001@5"  LET sr2.l_dept11= "gglq001@6"
                    LET sr2.l_dept12= "gglq001@7"  LET sr2.l_dept13= "gglq001@8"
                    LET sr2.l_dept14 = "gglq001@9"
            WHEN 6  LET sr2.l_dept7 = "gglq001@1"  LET sr2.l_dept8 = "gglq001@2"
                    LET sr2.l_dept9 = "gglq001@3"  LET sr2.l_dept10= "gglq001@4"
                    LET sr2.l_dept11= "gglq001@5"  LET sr2.l_dept12= "gglq001@6"
                    LET sr2.l_dept13= "gglq001@7"  LET sr2.l_dept14= "gglq001@8"
                    LET sr2.l_dept15 = "gglq001@9"
            WHEN 7  LET sr2.l_dept8 = "gglq001@1"  LET sr2.l_dept9 = "gglq001@2"
                    LET sr2.l_dept10= "gglq001@3"  LET sr2.l_dept11= "gglq001@4"
                    LET sr2.l_dept12= "gglq001@5"  LET sr2.l_dept13= "gglq001@6"
                    LET sr2.l_dept14= "gglq001@7"  LET sr2.l_dept15= "gglq001@8"
                    LET sr2.l_dept16 = "gglq001@9"
            WHEN 8  LET sr2.l_dept9 = "gglq001@1"  LET sr2.l_dept10= "gglq001@2"
                    LET sr2.l_dept11= "gglq001@3"  LET sr2.l_dept12= "gglq001@4"
                    LET sr2.l_dept13= "gglq001@5"  LET sr2.l_dept14= "gglq001@6"
                    LET sr2.l_dept15= "gglq001@7"  LET sr2.l_dept16= "gglq001@8"
                    LET sr2.l_dept17 = "gglq001@9"
            WHEN 9  LET sr2.l_dept10= "gglq001@1"  LET sr2.l_dept11= "gglq001@2"
                    LET sr2.l_dept12= "gglq001@3"  LET sr2.l_dept13= "gglq001@4"
                    LET sr2.l_dept14= "gglq001@5"  LET sr2.l_dept15= "gglq001@6"
                    LET sr2.l_dept16= "gglq001@7"  LET sr2.l_dept17= "gglq001@8"
                    LET sr2.l_dept18 = "gglq001@9"
            WHEN 10 LET sr2.l_dept11= "gglq001@1"  LET sr2.l_dept12= "gglq001@2"
                    LET sr2.l_dept13= "gglq001@3"  LET sr2.l_dept14= "gglq001@4"
                    LET sr2.l_dept15= "gglq001@5"  LET sr2.l_dept16= "gglq001@6"
                    LET sr2.l_dept17= "gglq001@7"  LET sr2.l_dept18= "gglq001@8"
                    LET sr2.l_dept19 = "gglq001@9"
            WHEN 11 LET sr2.l_dept12= "gglq001@1"  LET sr2.l_dept13= "gglq001@2"
                    LET sr2.l_dept14= "gglq001@3"  LET sr2.l_dept15= "gglq001@4"
                    LET sr2.l_dept16= "gglq001@5"  LET sr2.l_dept17= "gglq001@6"
                    LET sr2.l_dept18= "gglq001@7"  LET sr2.l_dept19= "gglq001@8"
                    LET sr2.l_dept20 = "gglq001@9"
            WHEN 12 LET sr2.l_dept13= "gglq001@1"  LET sr2.l_dept14= "gglq001@2"
                    LET sr2.l_dept15= "gglq001@3"  LET sr2.l_dept16= "gglq001@4"
                    LET sr2.l_dept17= "gglq001@5"  LET sr2.l_dept18= "gglq001@6"
                    LET sr2.l_dept19= "gglq001@7"  LET sr2.l_dept20= "gglq001@8"
                    LET sr2.l_dept21 = "gglq001@9"
            WHEN 13 LET sr2.l_dept14= "gglq001@1"  LET sr2.l_dept15= "gglq001@2"
                    LET sr2.l_dept16= "gglq001@3"  LET sr2.l_dept17= "gglq001@4"
                    LET sr2.l_dept18= "gglq001@5"  LET sr2.l_dept19= "gglq001@6"
                    LET sr2.l_dept20= "gglq001@7"  LET sr2.l_dept21= "gglq001@8"
                    LET sr2.l_dept22 = "gglq001@9"
            WHEN 14 LET sr2.l_dept15= "gglq001@1"  LET sr2.l_dept16= "gglq001@2"
                    LET sr2.l_dept17= "gglq001@3"  LET sr2.l_dept18= "gglq001@4"
                    LET sr2.l_dept19= "gglq001@5"  LET sr2.l_dept20= "gglq001@6"
                    LET sr2.l_dept21= "gglq001@7"  LET sr2.l_dept22= "gglq001@8"
                    LET sr2.l_dept23 = "gglq001@9"
            WHEN 15 LET sr2.l_dept16= "gglq001@1"  LET sr2.l_dept17= "gglq001@2"
                    LET sr2.l_dept18= "gglq001@3"  LET sr2.l_dept19= "gglq001@4"
                    LET sr2.l_dept20= "gglq001@5"  LET sr2.l_dept21= "gglq001@6"
                    LET sr2.l_dept22= "gglq001@7"  LET sr2.l_dept23= "gglq001@8"
                    LET sr2.l_dept24 = "gglq001@9"
            WHEN 16 LET sr2.l_dept17= "gglq001@1"  LET sr2.l_dept18= "gglq001@2"
                    LET sr2.l_dept19= "gglq001@3"  LET sr2.l_dept20= "gglq001@4"
                    LET sr2.l_dept21= "gglq001@5"  LET sr2.l_dept22= "gglq001@6"
                    LET sr2.l_dept23= "gglq001@7"  LET sr2.l_dept24= "gglq001@8"
                    LET sr2.l_dept25 = "gglq001@9"
            WHEN 17 LET sr2.l_dept18= "gglq001@1"  LET sr2.l_dept19= "gglq001@2"
                    LET sr2.l_dept20= "gglq001@3"  LET sr2.l_dept21= "gglq001@4"
                    LET sr2.l_dept22= "gglq001@5"  LET sr2.l_dept23= "gglq001@6"
                    LET sr2.l_dept24= "gglq001@7"  LET sr2.l_dept25= "gglq001@8"
                    LET sr2.l_dept26 = "gglq001@9"
            WHEN 18 LET sr2.l_dept19= "gglq001@1"  LET sr2.l_dept20= "gglq001@2"
                    LET sr2.l_dept21= "gglq001@3"  LET sr2.l_dept22= "gglq001@4"
                    LET sr2.l_dept23= "gglq001@5"  LET sr2.l_dept24= "gglq001@6"
                    LET sr2.l_dept25= "gglq001@7"  LET sr2.l_dept26= "gglq001@8"
                    LET sr2.l_dept27 = "gglq001@9"
            WHEN 19 LET sr2.l_dept20= "gglq001@1"  LET sr2.l_dept21= "gglq001@2"
                    LET sr2.l_dept22= "gglq001@3"  LET sr2.l_dept23= "gglq001@4"
                    LET sr2.l_dept24= "gglq001@5"  LET sr2.l_dept25= "gglq001@6"
                    LET sr2.l_dept26= "gglq001@7"  LET sr2.l_dept27= "gglq001@8"
                    LET sr2.l_dept28 = "gglq001@9"
            WHEN 20 LET sr2.l_dept21= "gglq001@1"  LET sr2.l_dept22= "gglq001@2"
                    LET sr2.l_dept23= "gglq001@3"  LET sr2.l_dept24= "gglq001@4"
                    LET sr2.l_dept25= "gglq001@5"  LET sr2.l_dept26= "gglq001@6"
                    LET sr2.l_dept27= "gglq001@7"  LET sr2.l_dept28= "gglq001@8"
                    LET sr2.l_dept29 = "gglq001@9"
            WHEN 21 LET sr2.l_dept22= "gglq001@1"  LET sr2.l_dept23= "gglq001@2"
                    LET sr2.l_dept24= "gglq001@3"  LET sr2.l_dept25= "gglq001@4"
                    LET sr2.l_dept26= "gglq001@5"  LET sr2.l_dept27= "gglq001@6"
                    LET sr2.l_dept28= "gglq001@7"  LET sr2.l_dept29= "gglq001@8"
                    LET sr2.l_dept30= "gglq001@9"
            WHEN 22 LET sr2.l_dept23= "gglq001@1"  LET sr2.l_dept24= "gglq001@2"
                    LET sr2.l_dept25= "gglq001@3"  LET sr2.l_dept26= "gglq001@4"
                    LET sr2.l_dept27= "gglq001@5"  LET sr2.l_dept28= "gglq001@6"
                    LET sr2.l_dept29= "gglq001@7"  LET sr2.l_dept30= "gglq001@8"
                    LET sr2.l_dept31= "gglq001@9"
            WHEN 23 LET sr2.l_dept24= "gglq001@1"  LET sr2.l_dept25= "gglq001@2"
                    LET sr2.l_dept26= "gglq001@3"  LET sr2.l_dept27= "gglq001@4"
                    LET sr2.l_dept28= "gglq001@5"  LET sr2.l_dept29= "gglq001@6"
                    LET sr2.l_dept30= "gglq001@7"  LET sr2.l_dept31= "gglq001@8"
                    LET sr2.l_dept32= "gglq001@9"
            WHEN 24 LET sr2.l_dept25= "gglq001@1"  LET sr2.l_dept26= "gglq001@2"
                    LET sr2.l_dept27= "gglq001@3"  LET sr2.l_dept28= "gglq001@4"
                    LET sr2.l_dept29= "gglq001@5"  LET sr2.l_dept30= "gglq001@6"
                    LET sr2.l_dept31= "gglq001@7"  LET sr2.l_dept32= "gglq001@8"
                    LET sr2.l_dept33= "gglq001@9"
            WHEN 25 LET sr2.l_dept26= "gglq001@1"  LET sr2.l_dept27= "gglq001@2"
                    LET sr2.l_dept28= "gglq001@3"  LET sr2.l_dept29= "gglq001@4"
                    LET sr2.l_dept30= "gglq001@5"  LET sr2.l_dept31= "gglq001@6"
                    LET sr2.l_dept32= "gglq001@7"  LET sr2.l_dept33= "gglq001@8"
                    LET sr2.l_dept34= "gglq001@9"
            WHEN 26 LET sr2.l_dept27= "gglq001@1"  LET sr2.l_dept28= "gglq001@2"
                    LET sr2.l_dept29= "gglq001@3"  LET sr2.l_dept30= "gglq001@4"
                    LET sr2.l_dept31= "gglq001@5"  LET sr2.l_dept32= "gglq001@6"
                    LET sr2.l_dept33= "gglq001@7"  LET sr2.l_dept34= "gglq001@8"
                    LET sr2.l_dept35= "gglq001@9"
            WHEN 27 LET sr2.l_dept28= "gglq001@1"  LET sr2.l_dept29= "gglq001@2"
                    LET sr2.l_dept30= "gglq001@3"  LET sr2.l_dept31= "gglq001@4"
                    LET sr2.l_dept32= "gglq001@5"  LET sr2.l_dept33= "gglq001@6"
                    LET sr2.l_dept34= "gglq001@7"  LET sr2.l_dept35= "gglq001@8"
                    LET sr2.l_dept36= "gglq001@9"
            WHEN 28 LET sr2.l_dept29= "gglq001@1"  LET sr2.l_dept30= "gglq001@2"
                    LET sr2.l_dept31= "gglq001@3"  LET sr2.l_dept32= "gglq001@4"
                    LET sr2.l_dept33= "gglq001@5"  LET sr2.l_dept34= "gglq001@6"
                    LET sr2.l_dept35= "gglq001@7"  LET sr2.l_dept36= "gglq001@8"
                    LET sr2.l_dept37= "gglq001@9"
            WHEN 29 LET sr2.l_dept30= "gglq001@1"  LET sr2.l_dept31= "gglq001@2"
                    LET sr2.l_dept32= "gglq001@3"  LET sr2.l_dept33= "gglq001@4"
                    LET sr2.l_dept34= "gglq001@5"  LET sr2.l_dept35= "gglq001@6"
                    LET sr2.l_dept36= "gglq001@7"  LET sr2.l_dept37= "gglq001@8"
                    LET sr2.l_dept38= "gglq001@9"
            WHEN 30 LET sr2.l_dept31= "gglq001@1"  LET sr2.l_dept32= "gglq001@2"
                    LET sr2.l_dept33= "gglq001@3"  LET sr2.l_dept34= "gglq001@4"
                    LET sr2.l_dept35= "gglq001@5"  LET sr2.l_dept36= "gglq001@6"
                    LET sr2.l_dept37= "gglq001@7"  LET sr2.l_dept38= "gglq001@8"
                    LET sr2.l_dept39= "gglq001@9"
            WHEN 31 LET sr2.l_dept32= "gglq001@1"  LET sr2.l_dept33= "gglq001@2"
                    LET sr2.l_dept34= "gglq001@3"  LET sr2.l_dept35= "gglq001@4"
                    LET sr2.l_dept36= "gglq001@5"  LET sr2.l_dept37= "gglq001@6"
                    LET sr2.l_dept38= "gglq001@7"  LET sr2.l_dept39= "gglq001@8"
                    LET sr2.l_dept40= "gglq001@9"
            WHEN 32 LET sr2.l_dept33= "gglq001@1"  LET sr2.l_dept34= "gglq001@2"
                    LET sr2.l_dept35= "gglq001@3"  LET sr2.l_dept36= "gglq001@4"
                    LET sr2.l_dept37= "gglq001@5"  LET sr2.l_dept38= "gglq001@6"
                    LET sr2.l_dept39= "gglq001@7"  LET sr2.l_dept40= "gglq001@8"
                    LET sr2.l_dept41= "gglq001@9"
            WHEN 33 LET sr2.l_dept34= "gglq001@1"  LET sr2.l_dept35= "gglq001@2"
                    LET sr2.l_dept36= "gglq001@3"  LET sr2.l_dept37= "gglq001@4"
                    LET sr2.l_dept38= "gglq001@5"  LET sr2.l_dept39= "gglq001@6"
                    LET sr2.l_dept40= "gglq001@7"  LET sr2.l_dept41= "gglq001@8"
                    LET sr2.l_dept42= "gglq001@9"
            WHEN 34 LET sr2.l_dept35= "gglq001@1"  LET sr2.l_dept36= "gglq001@2"
                    LET sr2.l_dept37= "gglq001@3"  LET sr2.l_dept38= "gglq001@4"
                    LET sr2.l_dept39= "gglq001@5"  LET sr2.l_dept40= "gglq001@6"
                    LET sr2.l_dept41= "gglq001@7"  LET sr2.l_dept42= "gglq001@8"
                    LET sr2.l_dept43= "gglq001@9"
            WHEN 35 LET sr2.l_dept36= "gglq001@1"  LET sr2.l_dept37= "gglq001@2"
                    LET sr2.l_dept38= "gglq001@3"  LET sr2.l_dept39= "gglq001@4"
                    LET sr2.l_dept40= "gglq001@5"  LET sr2.l_dept41= "gglq001@6"
                    LET sr2.l_dept42= "gglq001@7"  LET sr2.l_dept43= "gglq001@8"
                    LET sr2.l_dept44= "gglq001@9"
            WHEN 36 LET sr2.l_dept37= "gglq001@1"  LET sr2.l_dept38= "gglq001@2"
                    LET sr2.l_dept39= "gglq001@3"  LET sr2.l_dept40= "gglq001@4"
                    LET sr2.l_dept41= "gglq001@5"  LET sr2.l_dept42= "gglq001@6"
                    LET sr2.l_dept43= "gglq001@7"  LET sr2.l_dept44= "gglq001@8"
                    LET sr2.l_dept45= "gglq001@9"
            WHEN 37 LET sr2.l_dept38= "gglq001@1"  LET sr2.l_dept39= "gglq001@2"
                    LET sr2.l_dept40= "gglq001@3"  LET sr2.l_dept41= "gglq001@4"
                    LET sr2.l_dept42= "gglq001@5"  LET sr2.l_dept43= "gglq001@6"
                    LET sr2.l_dept44= "gglq001@7"  LET sr2.l_dept45= "gglq001@8"
                    LET sr2.l_dept46= "gglq001@9"
            WHEN 38 LET sr2.l_dept39= "gglq001@1"  LET sr2.l_dept40= "gglq001@2"
                    LET sr2.l_dept41= "gglq001@3"  LET sr2.l_dept42= "gglq001@4"
                    LET sr2.l_dept43= "gglq001@5"  LET sr2.l_dept44= "gglq001@6"
                    LET sr2.l_dept45= "gglq001@7"  LET sr2.l_dept46= "gglq001@8"
                    LET sr2.l_dept47= "gglq001@9"
            WHEN 39 LET sr2.l_dept40= "gglq001@1"  LET sr2.l_dept41= "gglq001@2"
                    LET sr2.l_dept42= "gglq001@3"  LET sr2.l_dept43= "gglq001@4"
                    LET sr2.l_dept44= "gglq001@5"  LET sr2.l_dept45= "gglq001@6"
                    LET sr2.l_dept46= "gglq001@7"  LET sr2.l_dept47= "gglq001@8"
                    LET sr2.l_dept48= "gglq001@9"
            WHEN 40 LET sr2.l_dept41= "gglq001@1"  LET sr2.l_dept42= "gglq001@2"
                    LET sr2.l_dept43= "gglq001@3"  LET sr2.l_dept44= "gglq001@4"
                    LET sr2.l_dept45= "gglq001@5"  LET sr2.l_dept46= "gglq001@6"
                    LET sr2.l_dept47= "gglq001@7"  LET sr2.l_dept48= "gglq001@8"
                    LET sr2.l_dept49= "gglq001@9"
            WHEN 41 LET sr2.l_dept42= "gglq001@1"  LET sr2.l_dept43= "gglq001@2"
                    LET sr2.l_dept44= "gglq001@3"  LET sr2.l_dept45= "gglq001@4"
                    LET sr2.l_dept46= "gglq001@5"  LET sr2.l_dept47= "gglq001@6"
                    LET sr2.l_dept48= "gglq001@7"  LET sr2.l_dept49= "gglq001@8"
                    LET sr2.l_dept50= "gglq001@9"
            WHEN 42 LET sr2.l_dept43= "gglq001@1"  LET sr2.l_dept44= "gglq001@2"
                    LET sr2.l_dept45= "gglq001@3"  LET sr2.l_dept46= "gglq001@4"
                    LET sr2.l_dept47= "gglq001@5"  LET sr2.l_dept48= "gglq001@6"
                    LET sr2.l_dept49= "gglq001@7"  LET sr2.l_dept50= "gglq001@8"
                    LET sr2.l_dept51= "gglq001@9"
            WHEN 43 LET sr2.l_dept44= "gglq001@1"  LET sr2.l_dept45= "gglq001@2"
                    LET sr2.l_dept46= "gglq001@3"  LET sr2.l_dept47= "gglq001@4"
                    LET sr2.l_dept48= "gglq001@5"  LET sr2.l_dept49= "gglq001@6"
                    LET sr2.l_dept50= "gglq001@7"  LET sr2.l_dept51= "gglq001@8"
                    LET sr2.l_dept52= "gglq001@9"
            WHEN 44 LET sr2.l_dept45= "gglq001@1"  LET sr2.l_dept46= "gglq001@2"
                    LET sr2.l_dept47= "gglq001@3"  LET sr2.l_dept48= "gglq001@4"
                    LET sr2.l_dept49= "gglq001@5"  LET sr2.l_dept50= "gglq001@6"
                    LET sr2.l_dept51= "gglq001@7"  LET sr2.l_dept52= "gglq001@8"
                    LET sr2.l_dept53= "gglq001@9"
            WHEN 45 LET sr2.l_dept46= "gglq001@1"  LET sr2.l_dept47= "gglq001@2"
                    LET sr2.l_dept48= "gglq001@3"  LET sr2.l_dept49= "gglq001@4"
                    LET sr2.l_dept50= "gglq001@5"  LET sr2.l_dept51= "gglq001@6"
                    LET sr2.l_dept52= "gglq001@7"  LET sr2.l_dept53= "gglq001@8"
                    LET sr2.l_dept54= "gglq001@9"
            WHEN 46 LET sr2.l_dept47= "gglq001@1"  LET sr2.l_dept48= "gglq001@2"
                    LET sr2.l_dept49= "gglq001@3"  LET sr2.l_dept50= "gglq001@4"
                    LET sr2.l_dept51= "gglq001@5"  LET sr2.l_dept52= "gglq001@6"
                    LET sr2.l_dept53= "gglq001@7"  LET sr2.l_dept54= "gglq001@8"
                    LET sr2.l_dept55= "gglq001@9"
            WHEN 47 LET sr2.l_dept48= "gglq001@1"  LET sr2.l_dept49= "gglq001@2"
                    LET sr2.l_dept50= "gglq001@3"  LET sr2.l_dept51= "gglq001@4"
                    LET sr2.l_dept52= "gglq001@5"  LET sr2.l_dept53= "gglq001@6"
                    LET sr2.l_dept54= "gglq001@7"  LET sr2.l_dept55= "gglq001@8"
                    LET sr2.l_dept56= "gglq001@9"
            WHEN 48 LET sr2.l_dept49= "gglq001@1"  LET sr2.l_dept50= "gglq001@2"
                    LET sr2.l_dept51= "gglq001@3"  LET sr2.l_dept52= "gglq001@4"
                    LET sr2.l_dept53= "gglq001@5"  LET sr2.l_dept54= "gglq001@6"
                    LET sr2.l_dept55= "gglq001@7"  LET sr2.l_dept56= "gglq001@8"
                    LET sr2.l_dept57= "gglq001@9"
            WHEN 49 LET sr2.l_dept50= "gglq001@1"  LET sr2.l_dept51= "gglq001@2"
                    LET sr2.l_dept52= "gglq001@3"  LET sr2.l_dept53= "gglq001@4"
                    LET sr2.l_dept54= "gglq001@5"  LET sr2.l_dept55= "gglq001@6"
                    LET sr2.l_dept56= "gglq001@7"  LET sr2.l_dept57= "gglq001@8"
                    LET sr2.l_dept58= "gglq001@9"
            WHEN 0 LET sr2.l_dept51= "gglq001@1"  LET sr2.l_dept52= "gglq001@2"
                   LET sr2.l_dept53= "gglq001@3"  LET sr2.l_dept54= "gglq001@4"
                   LET sr2.l_dept55= "gglq001@5"  LET sr2.l_dept56= "gglq001@6"
                   LET sr2.l_dept57= "gglq001@7"  LET sr2.l_dept58= "gglq001@8"
                   LET sr2.l_dept59= "gglq001@9"
          END CASE
         #END 部門後面加上5個調整資料
          
          
          LET m_dept = m_dept CLIPPED,l_leng2 SPACES,1 SPACES,g_x[22] clipped
          LET g_flag = 'y'
       END IF

       CALL q001_total()

       DECLARE tmp_curs CURSOR FOR
          SELECT * FROM gglq001_tmp ORDER BY maj02,no
       IF STATUS THEN CALL cl_err('tmp_curs',STATUS,1) EXIT FOR END IF
       LET l_j = 1
       FOREACH tmp_curs INTO sr.*
         IF STATUS THEN CALL cl_err('tmp_curs',STATUS,1) EXIT FOREACH END IF
         IF cl_null(sr.bal1) THEN LET sr.bal1 = 0 END IF
         IF tm.d MATCHES '[23]' THEN             #換算金額單位
            IF g_unit!=0 THEN
               LET sr.bal1 = sr.bal1 / g_unit    #實際
            ELSE
               LET sr.bal1 = 0
            END IF
         END IF
       #借貸方處理應該在處理合計階前就轉換好-------(S)
       #借貸方處理應該在處理合計階前就轉換好-------(E)
#No.MOD-C20002 --begin 搬到合计前转换借余贷余
#        IF sr.maj07 = '2' THEN
#           LET sr.bal1 = sr.bal1 * -1
#        END IF
#No.MOD-C20002 --end
         CASE sr.no
              WHEN 1+g_group  LET sr3.l_amount1 = sr.bal1 
              WHEN 2+g_group  LET sr3.l_amount2 = sr.bal1
              WHEN 3+g_group  LET sr3.l_amount3 = sr.bal1
              WHEN 4+g_group  LET sr3.l_amount4 = sr.bal1
              WHEN 5+g_group  LET sr3.l_amount5 = sr.bal1
              WHEN 6+g_group  LET sr3.l_amount6 = sr.bal1
              WHEN 7+g_group  LET sr3.l_amount7 = sr.bal1
              WHEN 8+g_group  LET sr3.l_amount8 = sr.bal1
              WHEN 9+g_group  LET sr3.l_amount9 = sr.bal1
              WHEN 10+g_group  LET sr3.l_amount10 = sr.bal1
              WHEN 11+g_group  LET sr3.l_amount11= sr.bal1
              WHEN 12+g_group  LET sr3.l_amount12= sr.bal1
              WHEN 13+g_group  LET sr3.l_amount13= sr.bal1
              WHEN 14+g_group  LET sr3.l_amount14= sr.bal1
              WHEN 15+g_group  LET sr3.l_amount15= sr.bal1
              WHEN 16+g_group  LET sr3.l_amount16= sr.bal1
              WHEN 17+g_group  LET sr3.l_amount17= sr.bal1
              WHEN 18+g_group  LET sr3.l_amount18= sr.bal1
              WHEN 19+g_group  LET sr3.l_amount19= sr.bal1
              WHEN 20+g_group  LET sr3.l_amount20= sr.bal1
              WHEN 21+g_group  LET sr3.l_amount21 = sr.bal1
              WHEN 22+g_group  LET sr3.l_amount22 = sr.bal1
              WHEN 23+g_group  LET sr3.l_amount23 = sr.bal1
              WHEN 24+g_group  LET sr3.l_amount24 = sr.bal1
              WHEN 25+g_group  LET sr3.l_amount25 = sr.bal1
              WHEN 26+g_group  LET sr3.l_amount26 = sr.bal1
              WHEN 27+g_group  LET sr3.l_amount27 = sr.bal1
              WHEN 28+g_group  LET sr3.l_amount28 = sr.bal1
              WHEN 29+g_group  LET sr3.l_amount29 = sr.bal1
              WHEN 30+g_group  LET sr3.l_amount30 = sr.bal1
              WHEN 31+g_group  LET sr3.l_amount31= sr.bal1
              WHEN 32+g_group  LET sr3.l_amount32= sr.bal1
              WHEN 33+g_group  LET sr3.l_amount33= sr.bal1
              WHEN 34+g_group  LET sr3.l_amount34= sr.bal1
              WHEN 35+g_group  LET sr3.l_amount35= sr.bal1
              WHEN 36+g_group  LET sr3.l_amount36= sr.bal1
              WHEN 37+g_group  LET sr3.l_amount37= sr.bal1
              WHEN 38+g_group  LET sr3.l_amount38= sr.bal1
              WHEN 39+g_group  LET sr3.l_amount39= sr.bal1
              WHEN 40+g_group  LET sr3.l_amount40= sr.bal1
              WHEN 41+g_group  LET sr3.l_amount41 = sr.bal1 
              WHEN 42+g_group  LET sr3.l_amount42 = sr.bal1
              WHEN 43+g_group  LET sr3.l_amount43 = sr.bal1
              WHEN 44+g_group  LET sr3.l_amount44 = sr.bal1
              WHEN 45+g_group  LET sr3.l_amount45 = sr.bal1
              WHEN 46+g_group  LET sr3.l_amount46 = sr.bal1
              WHEN 47+g_group  LET sr3.l_amount47 = sr.bal1
              WHEN 48+g_group  LET sr3.l_amount48 = sr.bal1
              WHEN 49+g_group  LET sr3.l_amount49 = sr.bal1
              WHEN 50+g_group  LET sr3.l_amount50 = sr.bal1
              WHEN 51+g_group  LET sr3.l_amount1= sr.bal1 
         END CASE    
         
         IF sr.no = g_cn THEN
            #調整資料位置
            IF NOT(l_i < g_no) THEN
               CASE g_cn MOD 50
                   WHEN 1 LET sr3.l_amount2 = sr.bal2_t / g_unit
                          LET sr3.l_amount3 = sr.bal3_t *-1/ g_unit
                          LET sr3.l_amount4 = sr.bal2 / g_unit
                          LET sr3.l_amount5 = sr.bal3 * -1 / g_unit
                          LET sr3.l_amount6 = sr.bal4 / g_unit
                          LET sr3.l_amount7 = sr.bal5 * -1 / g_unit
                          LET sr3.l_amount8 = g_total[l_j].amt1
                          LET sr3.l_amount9 = g_total[l_j].amt2
                          LET sr3.l_amount10= g_total[l_j].amt
                   WHEN 2 LET sr3.l_amount3 = sr.bal2_t / g_unit
                          LET sr3.l_amount4 = sr.bal3_t *-1/ g_unit
                          LET sr3.l_amount5 = sr.bal2 / g_unit
                          LET sr3.l_amount6 = sr.bal3 * -1 / g_unit
                          LET sr3.l_amount7 = sr.bal4 / g_unit
                          LET sr3.l_amount8 = sr.bal5 * -1 / g_unit
                          LET sr3.l_amount9 = g_total[l_j].amt1
                          LET sr3.l_amount10= g_total[l_j].amt2
                          LET sr3.l_amount11= g_total[l_j].amt
                   WHEN 3 LET sr3.l_amount4 = sr.bal2_t / g_unit
                          LET sr3.l_amount5 = sr.bal3_t *-1/ g_unit
                          LET sr3.l_amount6 = sr.bal2 / g_unit
                          LET sr3.l_amount7 = sr.bal3 * -1 / g_unit
                          LET sr3.l_amount8 = sr.bal4 / g_unit
                          LET sr3.l_amount9 = sr.bal5 * -1 / g_unit
                          LET sr3.l_amount10= g_total[l_j].amt1
                          LET sr3.l_amount11= g_total[l_j].amt2
                          LET sr3.l_amount12= g_total[l_j].amt
                   WHEN 4 LET sr3.l_amount5 = sr.bal2_t / g_unit
                          LET sr3.l_amount6 = sr.bal3_t *-1/ g_unit
                          LET sr3.l_amount7 = sr.bal2 / g_unit
                          LET sr3.l_amount8 = sr.bal3 * -1 / g_unit
                          LET sr3.l_amount9 = sr.bal4 / g_unit
                          LET sr3.l_amount10= sr.bal5 * -1 / g_unit
                          LET sr3.l_amount11= g_total[l_j].amt1
                          LET sr3.l_amount12= g_total[l_j].amt2
                          LET sr3.l_amount13= g_total[l_j].amt
                   WHEN 5 LET sr3.l_amount6 = sr.bal2_t / g_unit
                          LET sr3.l_amount7 = sr.bal3_t *-1/ g_unit
                          LET sr3.l_amount8 = sr.bal2 / g_unit
                          LET sr3.l_amount9 = sr.bal3 * -1 / g_unit
                          LET sr3.l_amount10= sr.bal4 / g_unit
                          LET sr3.l_amount11= sr.bal5 * -1 / g_unit
                          LET sr3.l_amount12= g_total[l_j].amt1
                          LET sr3.l_amount13= g_total[l_j].amt2
                          LET sr3.l_amount14= g_total[l_j].amt
                   WHEN 6 LET sr3.l_amount7 = sr.bal2_t / g_unit
                          LET sr3.l_amount8 = sr.bal3_t *-1/ g_unit
                          LET sr3.l_amount9 = sr.bal2 / g_unit
                          LET sr3.l_amount10 = sr.bal3 * -1 / g_unit
                          LET sr3.l_amount11= sr.bal4 / g_unit
                          LET sr3.l_amount12= sr.bal5 * -1 / g_unit
                          LET sr3.l_amount13= g_total[l_j].amt1
                          LET sr3.l_amount14= g_total[l_j].amt2
                          LET sr3.l_amount15= g_total[l_j].amt
                   WHEN 7 LET sr3.l_amount8 = sr.bal2_t / g_unit
                          LET sr3.l_amount9 = sr.bal3_t *-1/ g_unit
                          LET sr3.l_amount10 = sr.bal2 / g_unit
                          LET sr3.l_amount11 = sr.bal3 * -1 / g_unit
                          LET sr3.l_amount12= sr.bal4 / g_unit
                          LET sr3.l_amount13= sr.bal5 * -1 / g_unit
                          LET sr3.l_amount14= g_total[l_j].amt1
                          LET sr3.l_amount15= g_total[l_j].amt2
                          LET sr3.l_amount16= g_total[l_j].amt
                   WHEN 8 LET sr3.l_amount9 = sr.bal2_t / g_unit
                          LET sr3.l_amount10= sr.bal3_t *-1/ g_unit
                          LET sr3.l_amount11 = sr.bal2 / g_unit
                          LET sr3.l_amount12 = sr.bal3 * -1 / g_unit
                          LET sr3.l_amount13= sr.bal4 / g_unit
                          LET sr3.l_amount14= sr.bal5 * -1 / g_unit
                          LET sr3.l_amount15= g_total[l_j].amt1
                          LET sr3.l_amount16= g_total[l_j].amt2
                          LET sr3.l_amount17= g_total[l_j].amt
                   WHEN 9 LET sr3.l_amount10= sr.bal2_t / g_unit
                          LET sr3.l_amount11= sr.bal3_t *-1/ g_unit
                          LET sr3.l_amount12 = sr.bal2 / g_unit
                          LET sr3.l_amount13 = sr.bal3 * -1 / g_unit
                          LET sr3.l_amount14= sr.bal4 / g_unit
                          LET sr3.l_amount15= sr.bal5 * -1 / g_unit
                          LET sr3.l_amount16= g_total[l_j].amt1
                          LET sr3.l_amount17= g_total[l_j].amt2
                          LET sr3.l_amount18= g_total[l_j].amt
                   WHEN 10 LET sr3.l_amount11= sr.bal2_t / g_unit
                           LET sr3.l_amount12= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount13 = sr.bal2 / g_unit
                           LET sr3.l_amount14 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount15= sr.bal4 / g_unit
                           LET sr3.l_amount16= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount17=g_total[l_j].amt1
                           LET sr3.l_amount18=g_total[l_j].amt2
                           LET sr3.l_amount19= g_total[l_j].amt
                   WHEN 11 LET sr3.l_amount12= sr.bal2_t / g_unit
                           LET sr3.l_amount13= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount14 = sr.bal2 / g_unit
                           LET sr3.l_amount15 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount16= sr.bal4 / g_unit
                           LET sr3.l_amount17= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount18= g_total[l_j].amt1
                           LET sr3.l_amount19= g_total[l_j].amt2
                           LET sr3.l_amount20= g_total[l_j].amt
                   WHEN 12 LET sr3.l_amount13= sr.bal2_t / g_unit
                           LET sr3.l_amount14= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount15 = sr.bal2 / g_unit
                           LET sr3.l_amount16 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount17= sr.bal4 / g_unit
                           LET sr3.l_amount18= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount19= g_total[l_j].amt1
                           LET sr3.l_amount20= g_total[l_j].amt2
                           LET sr3.l_amount21= g_total[l_j].amt
                   WHEN 13 LET sr3.l_amount14= sr.bal2_t / g_unit
                           LET sr3.l_amount15= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount16 = sr.bal2 / g_unit
                           LET sr3.l_amount17 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount18= sr.bal4 / g_unit
                           LET sr3.l_amount19= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount20= g_total[l_j].amt1
                           LET sr3.l_amount21= g_total[l_j].amt2
                           LET sr3.l_amount22= g_total[l_j].amt
                   WHEN 14 LET sr3.l_amount15= sr.bal2_t / g_unit
                           LET sr3.l_amount16= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount17 = sr.bal2 / g_unit
                           LET sr3.l_amount18 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount19= sr.bal4 / g_unit
                           LET sr3.l_amount20= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount21= g_total[l_j].amt1
                           LET sr3.l_amount22= g_total[l_j].amt2
                           LET sr3.l_amount23= g_total[l_j].amt
                   WHEN 15 LET sr3.l_amount16= sr.bal2_t / g_unit
                           LET sr3.l_amount17= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount18 = sr.bal2 / g_unit
                           LET sr3.l_amount19 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount20= sr.bal4 / g_unit
                           LET sr3.l_amount21= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount22= g_total[l_j].amt1
                           LET sr3.l_amount23= g_total[l_j].amt2
                           LET sr3.l_amount24= g_total[l_j].amt
                   WHEN 16 LET sr3.l_amount17= sr.bal2_t / g_unit
                           LET sr3.l_amount18= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount19 = sr.bal2 / g_unit
                           LET sr3.l_amount20 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount21= sr.bal4 / g_unit
                           LET sr3.l_amount22= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount23= g_total[l_j].amt1
                           LET sr3.l_amount24= g_total[l_j].amt2
                           LET sr3.l_amount25= g_total[l_j].amt
                   WHEN 17 LET sr3.l_amount18= sr.bal2_t / g_unit
                           LET sr3.l_amount19= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount20 = sr.bal2 / g_unit
                           LET sr3.l_amount21 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount22= sr.bal4 / g_unit
                           LET sr3.l_amount23= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount24= g_total[l_j].amt1
                           LET sr3.l_amount25= g_total[l_j].amt2
                           LET sr3.l_amount26= g_total[l_j].amt
                   WHEN 18 LET sr3.l_amount19= sr.bal2_t / g_unit
                           LET sr3.l_amount20= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount21 = sr.bal2 / g_unit
                           LET sr3.l_amount22 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount23= sr.bal4 / g_unit
                           LET sr3.l_amount24= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount25= g_total[l_j].amt1
                           LET sr3.l_amount26= g_total[l_j].amt2
                           LET sr3.l_amount27= g_total[l_j].amt
                   WHEN 19 LET sr3.l_amount20= sr.bal2_t / g_unit
                           LET sr3.l_amount21= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount22 = sr.bal2 / g_unit
                           LET sr3.l_amount23 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount24= sr.bal4 / g_unit
                           LET sr3.l_amount25= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount26= g_total[l_j].amt1
                           LET sr3.l_amount27= g_total[l_j].amt2
                           LET sr3.l_amount28= g_total[l_j].amt
                   WHEN 20 LET sr3.l_amount21= sr.bal2_t / g_unit
                           LET sr3.l_amount22= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount23 = sr.bal2 / g_unit
                           LET sr3.l_amount24 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount25= sr.bal4 / g_unit
                           LET sr3.l_amount26= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount27= g_total[l_j].amt1
                           LET sr3.l_amount28= g_total[l_j].amt2
                           LET sr3.l_amount29= g_total[l_j].amt
                   WHEN 21 LET sr3.l_amount22= sr.bal2_t / g_unit
                           LET sr3.l_amount23= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount24 = sr.bal2 / g_unit
                           LET sr3.l_amount25 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount26= sr.bal4 / g_unit
                           LET sr3.l_amount27= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount28= g_total[l_j].amt1
                           LET sr3.l_amount29= g_total[l_j].amt2
                           LET sr3.l_amount30= g_total[l_j].amt
                   WHEN 22 LET sr3.l_amount23= sr.bal2_t / g_unit
                           LET sr3.l_amount24= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount25 = sr.bal2 / g_unit
                           LET sr3.l_amount26 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount27= sr.bal4 / g_unit
                           LET sr3.l_amount28= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount29= g_total[l_j].amt1
                           LET sr3.l_amount30= g_total[l_j].amt2
                           LET sr3.l_amount31= g_total[l_j].amt
                   WHEN 23 LET sr3.l_amount24= sr.bal2_t / g_unit
                           LET sr3.l_amount25= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount26 = sr.bal2 / g_unit
                           LET sr3.l_amount27 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount28= sr.bal4 / g_unit
                           LET sr3.l_amount29= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount30= g_total[l_j].amt1
                           LET sr3.l_amount31= g_total[l_j].amt2
                           LET sr3.l_amount32= g_total[l_j].amt
                   WHEN 24 LET sr3.l_amount25= sr.bal2_t / g_unit
                           LET sr3.l_amount26= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount27 = sr.bal2 / g_unit
                           LET sr3.l_amount28 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount29= sr.bal4 / g_unit
                           LET sr3.l_amount30= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount31= g_total[l_j].amt1
                           LET sr3.l_amount32= g_total[l_j].amt2
                           LET sr3.l_amount33= g_total[l_j].amt
                   WHEN 25 LET sr3.l_amount26= sr.bal2_t / g_unit
                           LET sr3.l_amount27= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount28 = sr.bal2 / g_unit
                           LET sr3.l_amount29 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount30= sr.bal4 / g_unit
                           LET sr3.l_amount31= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount32= g_total[l_j].amt1
                           LET sr3.l_amount33= g_total[l_j].amt2
                           LET sr3.l_amount34= g_total[l_j].amt
                   WHEN 26 LET sr3.l_amount27= sr.bal2_t / g_unit
                           LET sr3.l_amount28= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount29 = sr.bal2 / g_unit
                           LET sr3.l_amount30 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount31= sr.bal4 / g_unit
                           LET sr3.l_amount32= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount33= g_total[l_j].amt1
                           LET sr3.l_amount34= g_total[l_j].amt2
                           LET sr3.l_amount35= g_total[l_j].amt
                   WHEN 27 LET sr3.l_amount28= sr.bal2_t / g_unit
                           LET sr3.l_amount29= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount30 = sr.bal2 / g_unit
                           LET sr3.l_amount31 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount32= sr.bal4 / g_unit
                           LET sr3.l_amount33= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount34= g_total[l_j].amt1
                           LET sr3.l_amount35= g_total[l_j].amt2
                           LET sr3.l_amount36= g_total[l_j].amt
                   WHEN 28 LET sr3.l_amount29= sr.bal2_t / g_unit
                           LET sr3.l_amount30= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount31 = sr.bal2 / g_unit
                           LET sr3.l_amount32 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount33= sr.bal4 / g_unit
                           LET sr3.l_amount34= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount35= g_total[l_j].amt1
                           LET sr3.l_amount36= g_total[l_j].amt2
                           LET sr3.l_amount37= g_total[l_j].amt
                   WHEN 29 LET sr3.l_amount30= sr.bal2_t / g_unit
                           LET sr3.l_amount31= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount32 = sr.bal2 / g_unit
                           LET sr3.l_amount33 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount34= sr.bal4 / g_unit
                           LET sr3.l_amount35= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount36= g_total[l_j].amt1
                           LET sr3.l_amount37= g_total[l_j].amt2
                           LET sr3.l_amount38= g_total[l_j].amt
                   WHEN 30 LET sr3.l_amount31= sr.bal2_t / g_unit
                           LET sr3.l_amount32= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount33 = sr.bal2 / g_unit
                           LET sr3.l_amount34 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount35= sr.bal4 / g_unit
                           LET sr3.l_amount36= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount37= g_total[l_j].amt1
                           LET sr3.l_amount38= g_total[l_j].amt2
                           LET sr3.l_amount39= g_total[l_j].amt
                   WHEN 31 LET sr3.l_amount32= sr.bal2_t / g_unit
                           LET sr3.l_amount33= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount34 = sr.bal2 / g_unit
                           LET sr3.l_amount35 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount36= sr.bal4 / g_unit
                           LET sr3.l_amount37= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount38= g_total[l_j].amt1
                           LET sr3.l_amount39= g_total[l_j].amt2
                           LET sr3.l_amount40= g_total[l_j].amt
                   WHEN 32 LET sr3.l_amount33= sr.bal2_t / g_unit
                           LET sr3.l_amount34= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount35 = sr.bal2 / g_unit
                           LET sr3.l_amount36 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount37= sr.bal4 / g_unit
                           LET sr3.l_amount38= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount39= g_total[l_j].amt1
                           LET sr3.l_amount40= g_total[l_j].amt2
                           LET sr3.l_amount41= g_total[l_j].amt
                   WHEN 33 LET sr3.l_amount34= sr.bal2_t / g_unit
                           LET sr3.l_amount35= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount36 = sr.bal2 / g_unit
                           LET sr3.l_amount37 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount38= sr.bal4 / g_unit
                           LET sr3.l_amount39= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount40= g_total[l_j].amt1
                           LET sr3.l_amount41= g_total[l_j].amt2
                           LET sr3.l_amount42= g_total[l_j].amt
                   WHEN 34 LET sr3.l_amount35= sr.bal2_t / g_unit
                           LET sr3.l_amount36= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount37 = sr.bal2 / g_unit
                           LET sr3.l_amount38 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount39= sr.bal4 / g_unit
                           LET sr3.l_amount40= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount41= g_total[l_j].amt1
                           LET sr3.l_amount42= g_total[l_j].amt2
                           LET sr3.l_amount43= g_total[l_j].amt
                   WHEN 35 LET sr3.l_amount36= sr.bal2_t / g_unit
                           LET sr3.l_amount37= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount38 = sr.bal2 / g_unit
                           LET sr3.l_amount39 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount40= sr.bal4 / g_unit
                           LET sr3.l_amount41= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount42= g_total[l_j].amt1
                           LET sr3.l_amount43= g_total[l_j].amt2
                           LET sr3.l_amount44= g_total[l_j].amt
                   WHEN 36 LET sr3.l_amount37= sr.bal2_t / g_unit
                           LET sr3.l_amount38= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount39 = sr.bal2 / g_unit
                           LET sr3.l_amount40 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount41= sr.bal4 / g_unit
                           LET sr3.l_amount42= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount43= g_total[l_j].amt1
                           LET sr3.l_amount44= g_total[l_j].amt2
                           LET sr3.l_amount45= g_total[l_j].amt
                   WHEN 37 LET sr3.l_amount38= sr.bal2_t / g_unit
                           LET sr3.l_amount39= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount40 = sr.bal2 / g_unit
                           LET sr3.l_amount41 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount42= sr.bal4 / g_unit
                           LET sr3.l_amount43= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount44= g_total[l_j].amt1
                           LET sr3.l_amount45= g_total[l_j].amt2
                           LET sr3.l_amount46= g_total[l_j].amt
                   WHEN 38 LET sr3.l_amount39= sr.bal2_t / g_unit
                           LET sr3.l_amount40= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount41 = sr.bal2 / g_unit
                           LET sr3.l_amount42 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount43= sr.bal4 / g_unit
                           LET sr3.l_amount44= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount45= g_total[l_j].amt1
                           LET sr3.l_amount46= g_total[l_j].amt2
                           LET sr3.l_amount47= g_total[l_j].amt
                   WHEN 39 LET sr3.l_amount40= sr.bal2_t / g_unit
                           LET sr3.l_amount41= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount42 = sr.bal2 / g_unit
                           LET sr3.l_amount43 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount44= sr.bal4 / g_unit
                           LET sr3.l_amount45= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount46= g_total[l_j].amt1
                           LET sr3.l_amount47= g_total[l_j].amt2
                           LET sr3.l_amount48= g_total[l_j].amt
                   WHEN 40 LET sr3.l_amount41= sr.bal2_t / g_unit
                           LET sr3.l_amount42= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount43 = sr.bal2 / g_unit
                           LET sr3.l_amount44 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount45= sr.bal4 / g_unit
                           LET sr3.l_amount46= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount47= g_total[l_j].amt1
                           LET sr3.l_amount48= g_total[l_j].amt2
                           LET sr3.l_amount49= g_total[l_j].amt 
                   WHEN 41 LET sr3.l_amount42= sr.bal2_t / g_unit
                           LET sr3.l_amount43= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount44 = sr.bal2 / g_unit
                           LET sr3.l_amount45 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount46= sr.bal4 / g_unit
                           LET sr3.l_amount47= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount48= g_total[l_j].amt1
                           LET sr3.l_amount49= g_total[l_j].amt2
                           LET sr3.l_amount50= g_total[l_j].amt
                   WHEN 42 LET sr3.l_amount43= sr.bal2_t / g_unit
                           LET sr3.l_amount44= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount45 = sr.bal2 / g_unit
                           LET sr3.l_amount46 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount47= sr.bal4 / g_unit
                           LET sr3.l_amount48= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount49= g_total[l_j].amt1
                           LET sr3.l_amount50= g_total[l_j].amt2
                           LET sr3.l_amount51= g_total[l_j].amt
                   WHEN 43 LET sr3.l_amount44= sr.bal2_t / g_unit
                           LET sr3.l_amount45= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount46 = sr.bal2 / g_unit
                           LET sr3.l_amount47 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount48= sr.bal4 / g_unit
                           LET sr3.l_amount49= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount50= g_total[l_j].amt1
                           LET sr3.l_amount51= g_total[l_j].amt2
                           LET sr3.l_amount52= g_total[l_j].amt
                   WHEN 44 LET sr3.l_amount45= sr.bal2_t / g_unit
                           LET sr3.l_amount46= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount47 = sr.bal2 / g_unit
                           LET sr3.l_amount48 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount49= sr.bal4 / g_unit
                           LET sr3.l_amount50= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount51= g_total[l_j].amt1
                           LET sr3.l_amount52= g_total[l_j].amt2
                           LET sr3.l_amount53= g_total[l_j].amt
                   WHEN 45 LET sr3.l_amount46= sr.bal2_t / g_unit
                           LET sr3.l_amount47= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount48 = sr.bal2 / g_unit
                           LET sr3.l_amount49 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount50= sr.bal4 / g_unit
                           LET sr3.l_amount51= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount52= g_total[l_j].amt1
                           LET sr3.l_amount53= g_total[l_j].amt2
                           LET sr3.l_amount54= g_total[l_j].amt
                   WHEN 46 LET sr3.l_amount47= sr.bal2_t / g_unit
                           LET sr3.l_amount48= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount49 = sr.bal2 / g_unit
                           LET sr3.l_amount50 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount51= sr.bal4 / g_unit
                           LET sr3.l_amount52= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount53= g_total[l_j].amt1
                           LET sr3.l_amount54= g_total[l_j].amt2
                           LET sr3.l_amount55= g_total[l_j].amt
                   WHEN 47 LET sr3.l_amount48= sr.bal2_t / g_unit
                           LET sr3.l_amount49= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount50 = sr.bal2 / g_unit
                           LET sr3.l_amount51 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount52= sr.bal4 / g_unit
                           LET sr3.l_amount53= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount54= g_total[l_j].amt1
                           LET sr3.l_amount55= g_total[l_j].amt2
                           LET sr3.l_amount56= g_total[l_j].amt
                   WHEN 48 LET sr3.l_amount49= sr.bal2_t / g_unit
                           LET sr3.l_amount50= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount51 = sr.bal2 / g_unit
                           LET sr3.l_amount52 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount53= sr.bal4 / g_unit
                           LET sr3.l_amount54= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount55= g_total[l_j].amt1
                           LET sr3.l_amount56= g_total[l_j].amt2
                           LET sr3.l_amount57= g_total[l_j].amt
                   WHEN 49 LET sr3.l_amount50= sr.bal2_t / g_unit
                           LET sr3.l_amount51= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount52 = sr.bal2 / g_unit
                           LET sr3.l_amount53 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount54= sr.bal4 / g_unit
                           LET sr3.l_amount55= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount56= g_total[l_j].amt1
                           LET sr3.l_amount57= g_total[l_j].amt2
                           LET sr3.l_amount58= g_total[l_j].amt
                   WHEN 0  LET sr3.l_amount51= sr.bal2_t / g_unit
                           LET sr3.l_amount52= sr.bal3_t *-1/ g_unit
                           LET sr3.l_amount53 = sr.bal2 / g_unit
                           LET sr3.l_amount54 = sr.bal3 * -1 / g_unit
                           LET sr3.l_amount55= sr.bal4 / g_unit
                           LET sr3.l_amount56= sr.bal5 * -1 / g_unit
                           LET sr3.l_amount57= g_total[l_j].amt1
                           LET sr3.l_amount58= g_total[l_j].amt2
                           LET sr3.l_amount59= g_total[l_j].amt
               END CASE
               LET sr3.l_amount51= sr.bal2_t / g_unit
               LET sr3.l_amount52= sr.bal3_t *-1/ g_unit
               LET sr3.l_amount53 = sr.bal2 / g_unit
               LET sr3.l_amount54 = sr.bal3 * -1 / g_unit
               LET sr3.l_amount55= sr.bal4 / g_unit
               LET sr3.l_amount56= sr.bal5 * -1 / g_unit
               LET sr3.l_amount57= g_total[l_j].amt1
               LET sr3.l_amount58= g_total[l_j].amt2
               LET sr3.l_amount59= g_total[l_j].amt
            END IF
            IF g_flag = 'y' THEN
#借貸方處理應該在處理合計階前就轉換好-------(S)
#借貸方處理應該在處理合計階前就轉換好-------(E)
               IF l_j > g_cnt THEN  
                  CALL cl_err('l_j > g_cnt',STATUS,1) EXIT FOREACH
               END IF
               LET l_j = l_j + 1  
            END IF
           #"列印餘額為零者"不勾
            IF (tm.c='N' OR sr.maj03='2') AND sr.maj03 MATCHES "[012]" THEN
               IF (sr3.l_amount1 = 0 OR cl_null(sr3.l_amount1)) AND
                  (sr3.l_amount2 = 0 OR cl_null(sr3.l_amount2)) AND
                  (sr3.l_amount3 = 0 OR cl_null(sr3.l_amount3)) AND
                  (sr3.l_amount4 = 0 OR cl_null(sr3.l_amount4)) AND
                  (sr3.l_amount5 = 0 OR cl_null(sr3.l_amount5)) AND
                  (sr3.l_amount6 = 0 OR cl_null(sr3.l_amount6)) AND
                  (sr3.l_amount7 = 0 OR cl_null(sr3.l_amount7)) AND
                  (sr3.l_amount8 = 0 OR cl_null(sr3.l_amount8)) AND
                  (sr3.l_amount9 = 0 OR cl_null(sr3.l_amount9)) AND
                  (sr3.l_amount10= 0 OR cl_null(sr3.l_amount10)) AND
                  (sr3.l_amount11= 0 OR cl_null(sr3.l_amount11)) AND
                  (sr3.l_amount12= 0 OR cl_null(sr3.l_amount12)) AND
                  (sr3.l_amount13= 0 OR cl_null(sr3.l_amount13)) AND
                  (sr3.l_amount14= 0 OR cl_null(sr3.l_amount14)) AND
                  (sr3.l_amount15= 0 OR cl_null(sr3.l_amount15)) AND
                  (sr3.l_amount16= 0 OR cl_null(sr3.l_amount16)) AND
                  (sr3.l_amount17= 0 OR cl_null(sr3.l_amount17)) AND
                  (sr3.l_amount18= 0 OR cl_null(sr3.l_amount18)) AND
                  (sr3.l_amount19= 0 OR cl_null(sr3.l_amount19)) AND
                  (sr3.l_amount20= 0 OR cl_null(sr3.l_amount20)) AND
                  (sr3.l_amount21= 0 OR cl_null(sr3.l_amount21)) AND
                  (sr3.l_amount22= 0 OR cl_null(sr3.l_amount22)) AND
                  (sr3.l_amount23= 0 OR cl_null(sr3.l_amount23)) AND
                  (sr3.l_amount24= 0 OR cl_null(sr3.l_amount24)) AND
                  (sr3.l_amount25= 0 OR cl_null(sr3.l_amount25)) AND
                  (sr3.l_amount26= 0 OR cl_null(sr3.l_amount26)) AND
                  (sr3.l_amount27= 0 OR cl_null(sr3.l_amount27)) AND
                  (sr3.l_amount28= 0 OR cl_null(sr3.l_amount28)) AND
                  (sr3.l_amount29= 0 OR cl_null(sr3.l_amount29)) AND
                  (sr3.l_amount30= 0 OR cl_null(sr3.l_amount30)) AND
                  (sr3.l_amount31= 0 OR cl_null(sr3.l_amount31)) AND
                  (sr3.l_amount32= 0 OR cl_null(sr3.l_amount32)) AND
                  (sr3.l_amount33= 0 OR cl_null(sr3.l_amount33)) AND
                  (sr3.l_amount34= 0 OR cl_null(sr3.l_amount34)) AND
                  (sr3.l_amount35= 0 OR cl_null(sr3.l_amount35)) AND
                  (sr3.l_amount36= 0 OR cl_null(sr3.l_amount36)) AND
                  (sr3.l_amount37= 0 OR cl_null(sr3.l_amount37)) AND
                  (sr3.l_amount38= 0 OR cl_null(sr3.l_amount38)) AND
                  (sr3.l_amount39= 0 OR cl_null(sr3.l_amount39)) AND
                  (sr3.l_amount40= 0 OR cl_null(sr3.l_amount40)) AND
                  (sr3.l_amount41= 0 OR cl_null(sr3.l_amount41)) AND
                  (sr3.l_amount42= 0 OR cl_null(sr3.l_amount42)) AND
                  (sr3.l_amount43= 0 OR cl_null(sr3.l_amount43)) AND
                  (sr3.l_amount44= 0 OR cl_null(sr3.l_amount44)) AND
                  (sr3.l_amount45= 0 OR cl_null(sr3.l_amount45)) AND
                  (sr3.l_amount46= 0 OR cl_null(sr3.l_amount46)) AND
                  (sr3.l_amount47= 0 OR cl_null(sr3.l_amount47)) AND
                  (sr3.l_amount48= 0 OR cl_null(sr3.l_amount48)) AND
                  (sr3.l_amount49= 0 OR cl_null(sr3.l_amount49)) AND
                  (sr3.l_amount50= 0 OR cl_null(sr3.l_amount50)) AND
                  (sr3.l_amount51= 0 OR cl_null(sr3.l_amount51)) AND
                  (sr3.l_amount52= 0 OR cl_null(sr3.l_amount52)) AND
                  (sr3.l_amount53= 0 OR cl_null(sr3.l_amount53)) AND
                  (sr3.l_amount54= 0 OR cl_null(sr3.l_amount54)) AND
                  (sr3.l_amount55= 0 OR cl_null(sr3.l_amount55)) AND
                  (sr3.l_amount56= 0 OR cl_null(sr3.l_amount57)) AND
                  (sr3.l_amount58= 0 OR cl_null(sr3.l_amount59)) THEN    
                  CONTINUE FOREACH                      #餘額為 0 者不列印
               END IF
            END IF

           IF sr.maj03 = 'H' THEN  #抬頭不要給數值
              LET sr3.l_amount1 = NULL    LET sr3.l_amount2 = NULL
              LET sr3.l_amount3 = NULL    LET sr3.l_amount4 = NULL
              LET sr3.l_amount5 = NULL    LET sr3.l_amount6 = NULL
              LET sr3.l_amount7 = NULL    LET sr3.l_amount8 = NULL
              LET sr3.l_amount9 = NULL    LET sr3.l_amount10= NULL
              LET sr3.l_amount11= NULL    LET sr3.l_amount12= NULL
              LET sr3.l_amount13= NULL    LET sr3.l_amount14= NULL
              LET sr3.l_amount15= NULL    LET sr3.l_amount16= NULL
              LET sr3.l_amount17= NULL    LET sr3.l_amount18= NULL
              LET sr3.l_amount19= NULL    LET sr3.l_amount20= NULL
              LET sr3.l_amount21= NULL    LET sr3.l_amount22= NULL
              LET sr3.l_amount23= NULL    LET sr3.l_amount24= NULL
              LET sr3.l_amount25= NULL
              LET sr3.l_amount26= NULL
              LET sr3.l_amount27= NULL    LET sr3.l_amount28= NULL
              LET sr3.l_amount29= NULL    LET sr3.l_amount30= NULL
              LET sr3.l_amount31= NULL    LET sr3.l_amount32= NULL
              LET sr3.l_amount33= NULL    LET sr3.l_amount34= NULL
              LET sr3.l_amount35= NULL    LET sr3.l_amount36= NULL
              LET sr3.l_amount37= NULL    LET sr3.l_amount38= NULL
              LET sr3.l_amount39= NULL    LET sr3.l_amount40= NULL
              LET sr3.l_amount41= NULL    LET sr3.l_amount42= NULL
              LET sr3.l_amount43= NULL    LET sr3.l_amount44= NULL
              LET sr3.l_amount45= NULL    LET sr3.l_amount46= NULL
              LET sr3.l_amount47= NULL    LET sr3.l_amount48= NULL
              LET sr3.l_amount49= NULL    LET sr3.l_amount50= NULL
              LET sr3.l_amount51= NULL    LET sr3.l_amount52= NULL
              LET sr3.l_amount53= NULL    LET sr3.l_amount54= NULL
              LET sr3.l_amount55= NULL    LET sr3.l_amount56= NULL
              LET sr3.l_amount57= NULL    LET sr3.l_amount58= NULL
              LET sr3.l_amount59= NULL
           END IF

           #l_dept內的值若為NULL替換字元,保留至cr能印出底線
           IF cl_null(sr2.l_dept1) THEN LET sr2.l_dept1 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept2) THEN LET sr2.l_dept2 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept3) THEN LET sr2.l_dept3 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept4) THEN LET sr2.l_dept4 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept5) THEN LET sr2.l_dept5 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept6) THEN LET sr2.l_dept6 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept7) THEN LET sr2.l_dept7 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept8) THEN LET sr2.l_dept8 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept9) THEN LET sr2.l_dept9 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept10) THEN LET sr2.l_dept10 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept11) THEN LET sr2.l_dept11 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept12) THEN LET sr2.l_dept12 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept13) THEN LET sr2.l_dept13 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept14) THEN LET sr2.l_dept14 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept15) THEN LET sr2.l_dept15 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept16) THEN LET sr2.l_dept16 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept17) THEN LET sr2.l_dept17 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept18) THEN LET sr2.l_dept18 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept19) THEN LET sr2.l_dept19 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept20) THEN LET sr2.l_dept20 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept21) THEN LET sr2.l_dept21 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept22) THEN LET sr2.l_dept22 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept23) THEN LET sr2.l_dept23 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept24) THEN LET sr2.l_dept24 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept25) THEN LET sr2.l_dept25 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept26) THEN LET sr2.l_dept26 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept27) THEN LET sr2.l_dept27 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept28) THEN LET sr2.l_dept28 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept29) THEN LET sr2.l_dept29 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept30) THEN LET sr2.l_dept30 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept31) THEN LET sr2.l_dept31 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept32) THEN LET sr2.l_dept32 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept33) THEN LET sr2.l_dept33 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept34) THEN LET sr2.l_dept34 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept35) THEN LET sr2.l_dept35 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept36) THEN LET sr2.l_dept36 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept37) THEN LET sr2.l_dept37 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept38) THEN LET sr2.l_dept38 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept39) THEN LET sr2.l_dept39 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept40) THEN LET sr2.l_dept40 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept41) THEN LET sr2.l_dept41 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept42) THEN LET sr2.l_dept42 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept43) THEN LET sr2.l_dept43 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept44) THEN LET sr2.l_dept44 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept45) THEN LET sr2.l_dept45 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept46) THEN LET sr2.l_dept46 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept47) THEN LET sr2.l_dept47 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept48) THEN LET sr2.l_dept48 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept49) THEN LET sr2.l_dept49 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept50) THEN LET sr2.l_dept50 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept51) THEN LET sr2.l_dept51 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept52) THEN LET sr2.l_dept52 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept53) THEN LET sr2.l_dept53 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept54) THEN LET sr2.l_dept54 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept55) THEN LET sr2.l_dept55 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept56) THEN LET sr2.l_dept56 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept57) THEN LET sr2.l_dept57 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept58) THEN LET sr2.l_dept58 = 'gglq001@0' END IF
           IF cl_null(sr2.l_dept59) THEN LET sr2.l_dept59 = 'gglq001@0' END IF
           EXECUTE insert_prep2 USING sr.maj20,sr3.* 
           IF STATUS THEN
              CALL cl_err("execute insert_prep2:",STATUS,1)
              EXIT FOR
           END IF
        END IF 
      END FOREACH

      CLOSE tmp_curs
      LET g_group = g_group + 5
   END FOR

END FUNCTION

FUNCTION gglq001_cs()

     LET g_sql = "SELECT UNIQUE * FROM gglq001_tmp2 " 
     PREPARE gglq001_ps FROM g_sql
     DECLARE gglq001_curs SCROLL CURSOR WITH HOLD FOR gglq001_ps

     LET g_sql = "SELECT UNIQUE * FROM gglq001_tmp2 ",
                 "  INTO TEMP x "
     DROP TABLE x
     PREPARE gglq001_ps1 FROM g_sql
     EXECUTE gglq001_ps1

     LET g_sql = "SELECT COUNT(*) FROM x"
     PREPARE gglq001_ps2 FROM g_sql
     DECLARE gglq001_cnt CURSOR FOR gglq001_ps2

     OPEN gglq001_curs
     IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN gglq001_curs',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
     ELSE
        OPEN gglq001_cnt
        FETCH gglq001_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
     END IF
     CALL gglq001_show()
END FUNCTION

FUNCTION gglq001_show()
DEFINE   l_azp02    LIKE azp_file.azp02

   DISPLAY tm.a TO FORMONLY.maj01
   DISPLAY g_mai02 TO FORMONLY.mai02
   DISPLAY tm.yy TO FORMONLY.yy
   DISPLAY tm.em TO FORMONLY.mm
   DISPLAY tm.d  TO FORMONLY.unit
   DISPLAY tm.axa02 TO axa02
   SELECT axz02 INTO l_azp02
     FROM axz_file
    WHERE axz01 = tm.axa02
   IF SQLCA.SQLCODE=100 THEN
      LET l_azp02 = NULL
   END IF
   DISPLAY l_azp02 TO FORMONLY.azp02
  
   DISPLAY tm.axa01 TO axa01

   CALL gglq001_b_fill()

   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION gglq001_b_fill()
  DEFINE  l_abb06    LIKE abb_file.abb06
  DEFINE  l_type     LIKE type_file.chr1
  DEFINE  l_i2,l_j2  LIKE type_file.num5      
  DEFINE  l_azp01    LIKE azp_file.azp01
  DEFINE  l_azp02    LIKE azp_file.azp02
  DEFINE  l_dbs      LIKE azp_file.azp03
   LET g_sql = "SELECT *",
               " FROM gglq001_tmp2" 
   PREPARE gglq001_pb FROM g_sql
   DECLARE abb_curs  CURSOR FOR gglq001_pb

   CALL g_aag.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH abb_curs INTO g_aag[g_cnt].* 
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach abb_curs:',SQLCA.sqlcode,1) 
         EXIT FOREACH
      END IF

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF

   END FOREACH

   FOR l_i2 = 1 TO g_no
       SELECT axz02,axz03 INTO l_azp02,l_azp01
         FROM axz_file
        WHERE axz01 = g_dept[l_i2].axb04
       
       SELECT azp03 INTO l_dbs
         FROM azp_file
        WHERE azp01 = l_azp01
       IF SQLCA.SQLCODE=100 THEN
          LET g_msg1= g_dept[l_i2].axb04
       ELSE
          LET g_msg1= l_azp02 CLIPPED 
       END IF
       LET g_msg2= "sum",l_i2 USING "<<<<<"
       CALL cl_set_comp_visible(g_msg2,TRUE)
       CALL cl_set_comp_att_text(g_msg2,g_msg1 CLIPPED)
   END FOR

   FOR l_j2 = l_i2 TO 50
       LET g_msg2= "sum",l_j2 USING "<<<<<"
       CALL cl_set_comp_visible(g_msg2,FALSE)
   END FOR

   CALL g_aag.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1

END FUNCTION

FUNCTION q001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aag TO s_aag.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY



      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION gglq001_table()
     DROP TABLE gglq001_tmp;
     CREATE TEMP TABLE gglq001_tmp(
                    no       LIKE type_file.num5,
                    maj02    LIKE cot_file.cot12,     #no
                    maj03    LIKE maj_file.maj03,     #項次
                    maj04    LIKE maj_file.maj04,     #空行數
                    maj05    LIKE maj_file.maj05,     #空格數
                    maj07    LIKE maj_file.maj07,     #正常余額型態(1.借余/2.貸余)
                    maj09    LIKE maj_file.maj09,     #+:合計加項 -:合計減項
                    maj20    LIKE maj_file.maj20,     #科目列印名稱
                    maj20e   LIKE maj_file.maj20,     #額外列印名稱
                    maj21    LIKE maj_file.maj21,     #起始科目編號
                    maj22    LIKE maj_file.maj22,     #截止科目編號
                    bal1     LIKE type_file.num20_6,
                    bal2     LIKE type_file.num20_6,
                    bal3     LIKE type_file.num20_6,   
                    bal4     LIKE type_file.num20_6,
                    bal5     LIKE type_file.num20_6,
                    bal2_t   LIKE type_file.num20_6,
                    bal3_t   LIKE type_file.num20_6);

     DROP TABLE gglq001_tmp2;
     CREATE TEMP TABLE gglq001_tmp2(
                     aag01       LIKE maj_file.maj20,
                     sum1        LIKE type_file.num20_6,
                     sum2        LIKE type_file.num20_6,
                     sum3        LIKE type_file.num20_6, 
                     sum4        LIKE type_file.num20_6,
                     sum5        LIKE type_file.num20_6,
                     sum6        LIKE type_file.num20_6,
                     sum7        LIKE type_file.num20_6,
                     sum8        LIKE type_file.num20_6,
                     sum9        LIKE type_file.num20_6,
                     sum10       LIKE type_file.num20_6,
                     sum11       LIKE type_file.num20_6,
                     sum12       LIKE type_file.num20_6,
                     sum13       LIKE type_file.num20_6,
                     sum14       LIKE type_file.num20_6,
                     sum15       LIKE type_file.num20_6,
                     sum16       LIKE type_file.num20_6, 
                     sum17       LIKE type_file.num20_6,
                     sum18       LIKE type_file.num20_6,
                     sum19       LIKE type_file.num20_6,
                     sum20       LIKE type_file.num20_6,
                     sum21       LIKE type_file.num20_6,
                     sum22       LIKE type_file.num20_6,
                     sum23       LIKE type_file.num20_6,
                     sum24       LIKE type_file.num20_6,
                     sum25       LIKE type_file.num20_6,
                     sum26       LIKE type_file.num20_6,
                     sum27       LIKE type_file.num20_6,
                     sum28       LIKE type_file.num20_6,
                     sum29       LIKE type_file.num20_6, 
                     sum30       LIKE type_file.num20_6,
                     sum31       LIKE type_file.num20_6,
                     sum32       LIKE type_file.num20_6,
                     sum33       LIKE type_file.num20_6,
                     sum34       LIKE type_file.num20_6,
                     sum35       LIKE type_file.num20_6,
                     sum36       LIKE type_file.num20_6,
                     sum37       LIKE type_file.num20_6,
                     sum38       LIKE type_file.num20_6,
                     sum39       LIKE type_file.num20_6,
                     sum40       LIKE type_file.num20_6,
                     sum41       LIKE type_file.num20_6,
                     sum42       LIKE type_file.num20_6,
                     sum43       LIKE type_file.num20_6,
                     sum44       LIKE type_file.num20_6,
                     sum45       LIKE type_file.num20_6,
                     sum46       LIKE type_file.num20_6,
                     sum47       LIKE type_file.num20_6,
                     sum48       LIKE type_file.num20_6,
                     sum49       LIKE type_file.num20_6,
                     sum50       LIKE type_file.num20_6,
                     bal2_t      LIKE type_file.num20_6,
                     bal3_t      LIKE type_file.num20_6,
                     bal2        LIKE type_file.num20_6,
                     bal3        LIKE type_file.num20_6,
                     bal4        LIKE type_file.num20_6,
                     bal5        LIKE type_file.num20_6,
                     bal6        LIKE type_file.num20_6,
                     bal7        LIKE type_file.num20_6,
                     bal1        LIKE type_file.num20_6);
END FUNCTION

FUNCTION q001_process(l_cn)
   DEFINE l_sql,l_sql1         LIKE type_file.chr1000
   DEFINE l_cn                 LIKE type_file.num5   
   DEFINE l_temp               LIKE type_file.num20_6 
   DEFINE l_sun                LIKE type_file.num20_6 
   DEFINE l_mon                LIKE type_file.num20_6
   DEFINE maj                  RECORD LIKE maj_file.*
   DEFINE l_amt1,l_amt2,l_amt  LIKE type_file.num20_6 
   DEFINE l_amt3,l_amt4        LIKE type_file.num20_6 
   DEFINE amt1,amt2,amt        LIKE type_file.num20_6 
   DEFINE m_bal1,m_bal2        LIKE type_file.num20_6
   DEFINE m_bal3,m_bal4,m_bal5 LIKE type_file.num20_6
   DEFINE m_bal2_t,m_bal3_t    LIKE type_file.num20_6
   DEFINE l_d_amt              LIKE type_file.num20_6
   DEFINE l_c_amt              LIKE type_file.num20_6
   DEFINE l_d_amt_t              LIKE type_file.num20_6
   DEFINE l_c_amt_t              LIKE type_file.num20_6
   DEFINE l_dc_amt_t             LIKE type_file.num20_6
   DEFINE l_d_amt2             LIKE type_file.num20_6
   DEFINE l_c_amt2             LIKE type_file.num20_6
   DEFINE l_dc_amt             LIKE type_file.num20_6
   DEFINE l_dc_amt1            LIKE type_file.num20_6
   DEFINE l_axz04              LIKE axz_file.axz04
   DEFINE l_count              LIKE type_file.num5
   DEFINE l_n                  LIKE type_file.num5   #No.MOD-C20002
   
    #合併前會計科目各期餘額檔,SUM(借方金額-貸方金額)
    #----------- sql for sum(aej07-aej08)-----------------------------------
    LET l_sql = "SELECT SUM(aej07-aej08) FROM aej_file,aag_file",
                " WHERE aej00= ? AND aej04 BETWEEN ? AND ? ",
                "   AND aej05 = ? ",
                "   AND aej00 = '",tm.b,"'", 
                "   AND aej06 BETWEEN ? AND ? ",
                "   AND aej04 = aag01 AND aag07 IN ('2','3')",
                "   AND aej00 = aag00 ",
                "   AND aej01 ='",g_dept[l_cn].axa01,"' ",
                "   AND aej02 ='",g_dept[l_cn].axb04,"' ",
                "   AND aej03 ='",g_dept[l_cn].axb05,"' "

    PREPARE q001_sum FROM l_sql
    DECLARE q001_sumc CURSOR FOR q001_sum
    IF STATUS THEN CALL cl_err('sum prepare',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM 
    END IF
    SELECT axz04 INTO l_axz04 FROM axz_file WHERE axz01 = g_dept[l_cn].axb04
    FOREACH q001_c INTO maj.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET amt1 = 0  LET amt2 = 0  LET amt = 0
       LET m_bal2 = 0
       LET m_bal3 = 0   LET m_bal4 = 0   LET m_bal5 = 0   
       LET l_d_amt= 0   LET l_c_amt= 0
       LET l_d_amt2= 0  LET l_c_amt2= 0
       LET l_dc_amt= 0  LET l_dc_amt1= 0 
       LET l_d_amt_t= 0   LET l_c_amt_t= 0 LET l_dc_amt_t = 0 
       IF NOT cl_null(maj.maj21) THEN
          #amt1:合併前會計科目各期餘額檔,SUM(借方金額-貸方金額)
          IF l_axz04 = 'Y' THEN
             OPEN q001_sumc USING tm.b,maj.maj21,maj.maj22,tm.yy,'0',g_mm
          ELSE
             OPEN q001_sumc USING tm.b,maj.maj21,maj.maj22,tm.yy,tm.em,g_mm
          END IF 
          FETCH q001_sumc INTO amt1
          IF STATUS THEN CALL cl_err('fetch #1',STATUS,1) EXIT FOREACH END IF
          IF cl_null(amt1) THEN LET amt1 = 0 END IF

          ##调整
          LET l_d_amt_t = 0
          LET l_c_amt_t = 0
          LET l_dc_amt_t = 0
          IF tm.rtype = '1' THEN
             SELECT COUNT(*) INTO l_count
               FROM axi_file,axj_file
              WHERE axi01 = axj01
                AND axi03 = tm.yy
                AND axi04 BETWEEN tm.em AND tm.em
                AND axj03 BETWEEN maj.maj21  AND maj.maj22
                AND axi05 = tm.axa01
                AND axi06 = tm.axa02
                AND axi07 = tm.axa03
                AND axi08 = '1'       #調整
                AND axi00 = tm.b 
                AND axi00 = axj00
                AND axi21 = tm.ver
                AND axiconf <> 'X'  #CHI-C80041
             IF STATUS OR l_count=0 THEN
                LET l_d_amt_t=0
                LET l_c_amt_t=0
                LET l_dc_amt_t = 0
             ELSE
                #借方金額合計
                SELECT SUM(axj07) INTO l_d_amt_t FROM axi_file,axj_file
                 WHERE axi01=axj01 AND axi03=tm.yy
                   AND axi04 BETWEEN tm.em AND tm.em
                   AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='1'
                   AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03
                   AND axi00=tm.b 
                   AND axi00=axj00
                   AND axi08 = '1'       #調整
                   AND axi21=tm.ver
                   AND axiconf <> 'X'  #CHI-C80041
                IF cl_null(l_d_amt_t) THEN LET l_d_amt_t=0 END IF
                #貸方金額合計
                SELECT SUM(axj07) INTO l_c_amt_t FROM axi_file,axj_file
                 WHERE axi01=axj01 AND axi03=tm.yy
                   AND axi04 BETWEEN tm.em AND tm.em
                   AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='2'
                   AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03
                   AND axi00=tm.b  
                   AND axi00=axj00
                   AND axi08 = '1'      #調整
                   AND axi21=tm.ver
                   AND axiconf <> 'X'  #CHI-C80041
                IF cl_null(l_c_amt_t) THEN LET l_c_amt_t=0 END IF
                LET l_dc_amt_t = l_d_amt_t-l_c_amt_t
             END IF 
           ELSE
             SELECT COUNT(*) INTO l_count
               FROM axi_file,axj_file
              WHERE axi01 = axj01
                AND axi03 = tm.yy
                AND axi04 BETWEEN tm.em AND tm.em
                AND axj03 BETWEEN maj.maj21  AND maj.maj22
                AND axi05 = tm.axa01
                AND axi06 = tm.axa02
                AND axi07 = tm.axa03
                AND axi08 = '1'       #調整
                AND axi081<>'W'
                AND axi00 = tm.b
                AND axi00 = axj00
                AND axi21 = tm.ver
                AND axiconf <> 'X'  #CHI-C80041
             IF STATUS OR l_count=0 THEN
                LET l_d_amt_t=0
                LET l_c_amt_t=0
                LET l_dc_amt_t = 0
             ELSE
                #借方金額合計
                SELECT SUM(axj07) INTO l_d_amt_t FROM axi_file,axj_file
                 WHERE axi01=axj01 AND axi03=tm.yy
                   AND axi04 BETWEEN tm.em AND tm.em
                   AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='1'
                   AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03
                   AND axi00=tm.b
                   AND axi00=axj00
                   AND axi08 = '1'       #調整
                   AND axi081<>'W'
                   AND axi21=tm.ver
                   AND axiconf <> 'X'  #CHI-C80041
                IF cl_null(l_d_amt_t) THEN LET l_d_amt_t=0 END IF
                #貸方金額合計
                SELECT SUM(axj07) INTO l_c_amt_t FROM axi_file,axj_file
                 WHERE axi01=axj01 AND axi03=tm.yy
                   AND axi04 BETWEEN tm.em AND tm.em
                   AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='2'
                   AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03
                   AND axi00=tm.b
                   AND axi00=axj00
                   AND axi08 = '1'      #調整
                   AND axi081<>'W'
                   AND axi21=tm.ver
                   AND axiconf <> 'X'  #CHI-C80041
                IF cl_null(l_c_amt_t) THEN LET l_c_amt_t=0 END IF
                LET l_dc_amt_t = l_d_amt_t-l_c_amt_t
             END IF
           END IF 
           ##-->銷除
           #下面計算加總的部份是連會計師調整都算進去了(因為沒有判斷axi08分開抓值)
           LET l_d_amt = 0
           LET l_c_amt = 0
           LET l_dc_amt= 0
           IF tm.rtype = '1' THEN  
             SELECT COUNT(*) INTO l_count
               FROM axi_file,axj_file
              WHERE axi01 = axj01
                AND axi03 = tm.yy
                AND axi04 BETWEEN tm.em AND tm.em
                AND axj03 BETWEEN maj.maj21  AND maj.maj22
                AND axi05 = tm.axa01
                AND axi06 = tm.axa02
                AND axi07 = tm.axa03
                AND (axi08 = '2' OR axi08 = '4')       #調整與銷除
                AND axi00 = tm.b    
                AND axi00 = axj00    
                AND axi21 = tm.ver 
                AND axiconf <> 'X'  #CHI-C80041
             IF STATUS OR l_count=0 THEN
                LET l_dc_amt=0
             ELSE
                #借方金額合計
                SELECT SUM(axj07) INTO l_d_amt FROM axi_file,axj_file
                 WHERE axi01=axj01 AND axi03=tm.yy
                   AND axi04 BETWEEN tm.em AND tm.em
                   AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='1'
                   AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03
                   AND axi00=tm.b   
                   AND axi00=axj00     
                   AND axi08 = '2'       #調整與銷除
                   AND axi21=tm.ver   
                   AND axiconf <> 'X'  #CHI-C80041 
                IF cl_null(l_d_amt) THEN LET l_d_amt=0 END IF
                #借方金額合計
                IF tm.rtype = '1' THEN 
                   SELECT SUM(axj07) INTO l_d_amt2 FROM axi_file,axj_file
                    WHERE axi01=axj01 AND axi03=tm.yy
                     AND axi04 BETWEEN tm.em AND tm.em
                     AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='1'
                     AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03
                     AND axi00=tm.b   
                     AND axi00=axj00     
                     AND axi08 = '4'       #調整與銷除
                     AND axi21=tm.ver    
                     AND axiconf <> 'X'  #CHI-C80041
                  IF cl_null(l_d_amt2) THEN LET l_d_amt2=0 END IF
                END IF
                #貸方金額合計
                SELECT SUM(axj07) INTO l_c_amt FROM axi_file,axj_file
                 WHERE axi01=axj01 AND axi03=tm.yy
                   AND axi04 BETWEEN tm.em AND tm.em
                   AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='2'
                   AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03
                   AND axi00=tm.b      
                   AND axi00=axj00   
                   AND axi08 = '2'      #調整與銷除
                   AND axi21=tm.ver 
                   AND axiconf <> 'X'  #CHI-C80041   
                IF cl_null(l_c_amt) THEN LET l_c_amt=0 END IF

                  #貸方金額合計
                IF tm.rtype = '1' THEN
                  SELECT SUM(axj07) INTO l_c_amt2 FROM axi_file,axj_file
                   WHERE axi01=axj01 AND axi03=tm.yy
                   AND axi04 BETWEEN tm.em AND tm.em
                   AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='2'
                   AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03
                   AND axi00=tm.b  
                   AND axi00=axj00   
                   AND axi08 = '4'      #調整與銷除
                   AND axi21=tm.ver   
                   AND axiconf <> 'X'  #CHI-C80041 
                   IF cl_null(l_c_amt2) THEN LET l_c_amt2=0 END IF
                 END IF 
                 LET l_dc_amt=l_d_amt+l_d_amt2-l_c_amt-l_c_amt2

             END IF
           ELSE
              SELECT COUNT(*) INTO l_count
               FROM axi_file,axj_file
              WHERE axi01 = axj01
                AND axi03 = tm.yy
                AND axi04 BETWEEN tm.em AND tm.em
                AND axj03 BETWEEN maj.maj21  AND maj.maj22
                AND axi05 = tm.axa01
                AND axi06 = tm.axa02
                AND axi07 = tm.axa03
                AND axi08 = '2'      #調整與銷除
                AND axi00 = tm.b    
                AND axi00 = axj00
                AND axi21 = tm.ver
                AND axiconf <> 'X'  #CHI-C80041
             IF STATUS OR l_count=0 THEN
                LET l_dc_amt=0
             ELSE
                #借方金額合計
                SELECT SUM(axj07) INTO l_d_amt FROM axi_file,axj_file
                 WHERE axi01=axj01 AND axi03=tm.yy
                   AND axi04 BETWEEN tm.em AND tm.em
                   AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='1'
                   AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03
                   AND axi00=tm.b 
                   AND axi00=axj00
                   AND axi08 = '2'       #調整與銷除
                   AND axi21=tm.ver
                   AND axiconf <> 'X'  #CHI-C80041
                IF cl_null(l_d_amt) THEN LET l_d_amt=0 END IF
                #貸方金額合計
                SELECT SUM(axj07) INTO l_c_amt FROM axi_file,axj_file
                 WHERE axi01=axj01 AND axi03=tm.yy
                   AND axi04 BETWEEN tm.em AND tm.em
                   AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='2'
                   AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03
                   AND axi00=tm.b  
                   AND axi00=axj00
                   AND axi08 = '2'      #調整與銷除
                   AND axi21=tm.ver
                   AND axiconf <> 'X'  #CHI-C80041
                IF cl_null(l_c_amt) THEN LET l_c_amt=0 END IF

                 LET l_dc_amt=l_d_amt-l_c_amt

             END IF
           END IF 
             ##-->會計師調整
             LET l_d_amt = 0  LET l_c_amt = 0
             LET l_dc_amt1=0
             SELECT COUNT(*) INTO l_count
               FROM axi_file,axj_file
              WHERE axi01 = axj01
                AND axi03 = tm.yy
                AND axi04 BETWEEN tm.em AND tm.em
                AND axj03 BETWEEN maj.maj21  AND maj.maj22
                AND axi05 = tm.axa01
                AND axi06 = tm.axa02
                AND axi07 = tm.axa03
                AND axi08 = '3'       #會計師調整
                AND axi00 = tm.b      
                AND axi00 = axj00    
                AND axi21 = tm.ver  
                AND axiconf <> 'X'  #CHI-C80041 
             IF STATUS OR l_count=0 THEN
                LET l_dc_amt1=0
             ELSE
                #借方金額合計
                SELECT SUM(axj07) INTO l_d_amt FROM axi_file,axj_file
                 WHERE axi01=axj01 AND axi03=tm.yy
                   AND axi04 BETWEEN tm.em AND tm.em
                   AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='1'
                   AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03
                   AND axi00=tm.b   
                   AND axi00=axj00  
                   AND axi08='3'        #會計師調整
                   AND axi21=tm.ver 
                   AND axiconf <> 'X'  #CHI-C80041   
                IF cl_null(l_d_amt) THEN LET l_d_amt=0 END IF
                #貸方金額合計
                SELECT SUM(axj07) INTO l_c_amt FROM axi_file,axj_file
                 WHERE axi01=axj01 AND axi03=tm.yy
                   AND axi04 BETWEEN tm.em AND tm.em
                   AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='2'
                   AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='2'
                   AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03
                   AND axi00=tm.b
                   AND axi00=axj00    
                   AND axi08='3'        #會計師調整
                   AND axi21=tm.ver 
                   AND axiconf <> 'X'  #CHI-C80041     
                IF cl_null(l_c_amt) THEN LET l_c_amt=0 END IF

                LET l_dc_amt1=l_d_amt-l_c_amt
             END IF
             ##<--
          END IF 
       IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN   #合計階數處理
          DISPLAY l_cn,' ',maj.maj21,' ',maj.maj20,' ', l_dc_amt
          DISPLAY g_tot2[1],g_tot2[2],g_tot2[3],g_tot2[4]
#No.MOD-C20002 --begin 搬到合计前转换借余贷余
          IF maj.maj07 = '2' THEN
             LET amt1       = amt1 * -1
             LET l_dc_amt_t = l_dc_amt_t * -1
             LET l_dc_amt   = l_dc_amt * -1
             LET l_dc_amt1  = l_dc_amt1 * -1
          END IF
          #增加合计加减项处理
          IF maj.maj09='+' THEN 
          	 LET l_n = 1
          ELSE 
             LET l_n = -1
          END IF 
#No.MOD-C20002 --end
          FOR i = 1 TO 100
              LET l_amt1 = amt1                  #各公司餘額
              LET g_tot1[i]=g_tot1[i]+l_amt1*l_n   #No.MOD-C20002 add l_n     #科目餘額
              #LET g_tot2_t[i]=g_tot2_t[i]+l_d_amt_t  #调整借方
              #LET g_tot3_t[i]=g_tot3_t[i]+l_c_amt_t  #调整贷方
             #將調整或消除D/C、會計師調整D/C分開計算
#No.MOD-C20002 add maj07 --begin
              IF maj.maj07 ='1' THEN #No.MOD-C20002 add maj07 
                 IF l_dc_amt_t>0 THEN    
                    LET g_tot2_t[i]=g_tot2_t[i]+l_dc_amt_t*l_n   #No.MOD-C20002 add l_n     #调整D
                 ELSE
                    LET g_tot3_t[i]=g_tot3_t[i]+l_dc_amt_t*l_n   #No.MOD-C20002 add l_n     #调整C
                 END IF
                 IF l_dc_amt>0 THEN
                    LET g_tot2[i]=g_tot2[i]+l_dc_amt*l_n   #No.MOD-C20002 add l_n     #消除D
                 ELSE
                    LET g_tot3[i]=g_tot3[i]+l_dc_amt*l_n   #No.MOD-C20002 add l_n     #消除C
                 END IF
                 IF l_dc_amt1>0 THEN
                    LET g_tot4[i]=g_tot4[i]+l_dc_amt1*l_n   #No.MOD-C20002 add l_n    #會計師調整D
                 ELSE
                    LET g_tot5[i]=g_tot5[i]+l_dc_amt1*l_n   #No.MOD-C20002 add l_n    #會計師調整C
                 END IF 
              ELSE 
                 IF l_dc_amt_t<0 THEN    
                    LET g_tot2_t[i]=g_tot2_t[i]+l_dc_amt_t*l_n   #No.MOD-C20002 add l_n     #调整D
                 ELSE
                    LET g_tot3_t[i]=g_tot3_t[i]+l_dc_amt_t*l_n   #No.MOD-C20002 add l_n     #调整C
                 END IF
                 IF l_dc_amt<0 THEN
                    LET g_tot2[i]=g_tot2[i]+l_dc_amt*l_n   #No.MOD-C20002 add l_n     #消除D
                 ELSE
                    LET g_tot3[i]=g_tot3[i]+l_dc_amt*l_n   #No.MOD-C20002 add l_n     #消除C
                 END IF
                 IF l_dc_amt1<0 THEN
                    LET g_tot4[i]=g_tot4[i]+l_dc_amt1*l_n   #No.MOD-C20002 add l_n    #會計師調整D
                 ELSE
                    LET g_tot5[i]=g_tot5[i]+l_dc_amt1*l_n   #No.MOD-C20002 add l_n    #會計師調整C
                 END IF 
              END IF 
#No.MOD-C20002 add maj07 --end
          END FOR
          DISPLAY g_tot2[1],g_tot2[2],g_tot2[3],g_tot2[4]
             LET k=maj.maj08               #合計階數
             LET m_bal1=g_tot1[k]          #科目餘額
             LET m_bal2=g_tot2[k]          #消除餘額D
             LET m_bal3=g_tot3[k]          #消除餘額C  
             LET m_bal4=g_tot4[k]          #會計師調整餘額D 
             LET m_bal5=g_tot5[k]          #會計師調整餘額C
             LET m_bal2_t=g_tot2_t[k]          #調整餘額D
             LET m_bal3_t=g_tot3_t[k]          #調整餘額C
             DISPLAY l_cn,' ',maj.maj21,' ',maj.maj20,' ', m_bal2
             FOR i = 1 TO k LET g_tot1[i]=0 END FOR
             FOR i = 1 TO k LET g_tot2[i]=0 END FOR
             FOR i = 1 TO k LET g_tot3[i]=0 END FOR
             FOR i = 1 TO k LET g_tot4[i]=0 END FOR
             FOR i = 1 TO k LET g_tot5[i]=0 END FOR
             FOR i = 1 TO k LET g_tot2_t[i]=0 END FOR
             FOR i = 1 TO k LET g_tot3_t[i]=0 END FOR
       ELSE
          #%:本行印出起始科目所輸入之序號/截止科目所輸入之序號*100之值
	  IF maj.maj03 = '%' THEN
	     LET l_temp = maj.maj21
	     SELECT bal1 INTO l_sun FROM gglq001_tmp WHERE no=l_cn
	            AND maj02=l_temp
	     LET l_temp = maj.maj22
	     SELECT bal1 INTO l_mon FROM gglq001_tmp WHERE no=l_cn
	            AND maj02=l_temp
	     IF cl_null(l_sun) OR cl_null(l_mon) OR l_mon = 0 THEN
	     ELSE
                LET m_bal1 = l_sun / l_mon * 100
             END IF
             LET m_bal2=0
             LET m_bal3=0
             LET m_bal4=0
             LET m_bal5=0
             LET m_bal2_t=0
             LET m_bal3_t=0
          ELSE
             IF maj.maj03='5' THEN   #5:金額,本行要印出,但金額不作加總
                LET m_bal1=amt1
                IF l_dc_amt>0 THEN
                 LET m_bal2=l_dc_amt     #消除D
                ELSE
                 LET m_bal3=l_dc_amt     #消除C
                END IF
                IF l_dc_amt1>0 THEN
                 LET m_bal4=l_dc_amt1    #會計師調整D
                ELSE
                 LET m_bal5=l_dc_amt1    #會計師調整C
                END IF
                IF l_dc_amt_t>0 THEN
                 LET m_bal2_t=l_dc_amt_t     #調整D
                ELSE
                 LET m_bal3_t=l_dc_amt_t     #調整C
                END IF
             ELSE
                LET m_bal1=0
                LET m_bal2=0
                LET m_bal3=0
                LET m_bal4=0
                LET m_bal5=0
                LET m_bal2_t=0
                LET m_bal3_t=0
             END IF
          END IF
       END IF
       IF maj.maj03='0' THEN CONTINUE FOREACH END IF    #本行不印出  
       IF tm.f > 0 AND maj.maj08 < tm.f THEN
          CONTINUE FOREACH                              #最小階數起列印
       END IF
       INSERT INTO gglq001_tmp VALUES
          (l_cn,maj.maj02,maj.maj03,maj.maj04,
           maj.maj05,maj.maj07,maj.maj09,   
           maj.maj20,maj.maj20e,
           maj.maj21,maj.maj22,m_bal1,m_bal2,m_bal3,m_bal4,m_bal5,m_bal2_t,m_bal3_t) 
       IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err3("ins","gglq001_tmp",l_cn,maj.maj02,STATUS,"","ins gglq001_tmp",1) 
          EXIT FOREACH 
       END IF
    END FOREACH
END FUNCTION

FUNCTION q001_total()
    DEFINE  l_i,l_y   LIKE type_file.num5,        
	    l_maj02   LIKE maj_file.maj02,
	    l_maj03   LIKE maj_file.maj03,
	    l_maj07   LIKE maj_file.maj07,
	    l_maj21   LIKE maj_file.maj21,
	    l_maj22   LIKE maj_file.maj22,
	    l_t1,l_t2 LIKE type_file.num5,
	    l_bal     LIKE type_file.num20_6,
	    l_bal2    LIKE type_file.num20_6,
            l_bal3    LIKE type_file.num20_6,
            l_bal4    LIKE type_file.num20_6,
            l_bal5    LIKE type_file.num20_6,
            l_bal2_t  LIKE type_file.num20_6,
            l_bal3_t  LIKE type_file.num20_6

    DECLARE tot_curs CURSOR FOR
      SELECT maj02,maj03,maj07,maj21,maj22,SUM(bal1),SUM(bal2)
                                    ,SUM(bal3),SUM(bal4),SUM(bal5),
                                     SUM(bal2_t),SUM(bal3_t) 
        FROM gglq001_tmp
       GROUP BY maj02,maj03,maj07,maj21,maj22 ORDER BY maj02
    IF STATUS THEN CALL cl_err('tot_curs',STATUS,1) END IF
    LET l_i = 1
    LET l_maj02 = ' '
    LET l_bal = 0
    LET l_bal2= 0  LET l_bal3= 0  LET l_bal4= 0  LET l_bal5= 0   
    FOREACH tot_curs INTO l_maj02,l_maj03,l_maj07,l_maj21,l_maj22,l_bal,l_bal2
                                                         ,l_bal3,l_bal4,l_bal5,  
                                                          l_bal2_t,l_bal3_t
       IF STATUS THEN CALL cl_err('tot_curs',STATUS,1) EXIT FOREACH END IF
       IF cl_null(l_bal)  THEN LET l_bal  = 0 END IF
       IF cl_null(l_bal2) THEN LET l_bal2 = 0 END IF
       IF cl_null(l_bal3) THEN LET l_bal3 = 0 END IF  
       IF cl_null(l_bal4) THEN LET l_bal4 = 0 END IF 
       IF cl_null(l_bal5) THEN LET l_bal5 = 0 END IF
       IF cl_null(l_bal2_t) THEN LET l_bal2_t = 0 END IF
       IF cl_null(l_bal3_t) THEN LET l_bal3_t = 0 END IF
       LET l_bal2 = l_bal2 / g_cn  
       LET l_bal3 = l_bal3 / g_cn 
       LET l_bal4 = l_bal4 / g_cn 
       LET l_bal5 = l_bal5 / g_cn 
       LET l_bal2_t = l_bal2_t / g_cn
       LET l_bal3_t = l_bal3_t / g_cn
       
       IF tm.d MATCHES '[23]' THEN             #換算金額單位
          IF g_unit!=0 THEN
             LET l_bal = l_bal / g_unit    #實際
             LET l_bal2= l_bal2/ g_unit    #實際
             LET l_bal3= l_bal3/ g_unit    #實際
             LET l_bal4= l_bal4/ g_unit    #實際
             LET l_bal5= l_bal5/ g_unit    #實際
             LET l_bal2_t= l_bal2_t/ g_unit    #實際
             LET l_bal3_t= l_bal3_t/ g_unit    #實際
          ELSE
             LET l_bal = 0
             LET l_bal2= 0                 #實際
             LET l_bal3= 0                 #實際
             LET l_bal4= 0                 #實際
             LET l_bal5= 0                 #實際
             LET l_bal2_t=0 
             LET l_bal3_t=0
          END IF
       END IF
       IF l_maj03 = '%' THEN
          LET l_t1 = l_maj21
          LET l_t2 = l_maj22
          FOR l_y = 1 TO g_cnt          
              IF g_total[l_y].maj02 = l_t1 THEN LET l_t1 = l_y END IF
              IF g_total[l_y].maj02 = l_t2 THEN LET l_t2 = l_y END IF
          END FOR
          IF g_total[l_t2].amt != 0 THEN
             LET g_total[l_i].amt = g_total[l_t1].amt / g_total[l_t2].amt * 100
          ELSE
             LET g_total[l_i].amt = 0
          END IF
          IF g_total[l_t2].amt2 != 0 THEN   #调整后合计
             LET g_total[l_i].amt2 = g_total[l_t1].amt2 / g_total[l_t2].amt2 * 100
          ELSE
             LET g_total[l_i].amt2 = 0
          END IF 
       ELSE
          LET g_total[l_i].amt = g_total[l_i].amt + l_bal + l_bal2
                                         + l_bal3 + l_bal4+ l_bal5 
                                         + l_bal2_t+l_bal3_t
          LET g_total[l_i].amt2 = g_total[l_i].amt2 + l_bal + l_bal2_t+l_bal3_t
       END IF
#No.MOD-C20002 --begin
#       IF l_maj07 = '2' THEN
#          LET g_total[l_i].amt = g_total[l_i].amt * -1
#          LET g_total[l_i].amt2 = g_total[l_i].amt2 * -1
#       END IF
#No.MOD-C20002 --end 
       LET g_total[l_i].amt1 = l_bal
#No.MOD-C20002 --begin
#       IF l_maj07 = '2' THEN
#          LET g_total[l_i].amt1  = g_total[l_i].amt1 *-1
#       END IF 
#No.MOD-C20002 --end
       LET g_total[l_i].maj02 = l_maj02
       LET l_i = l_i + 1
       IF l_i > g_cnt THEN
          CALL cl_err('l_i > g_cnt',STATUS,1) EXIT FOREACH
       END IF
    END FOREACH
END FUNCTION
#FUN-B60159
