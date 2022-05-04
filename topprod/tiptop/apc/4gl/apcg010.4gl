# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: apcg010.4gl
# Descriptions...: POS 中間庫銷售/訂單未上傳資料表 
# Input parameter:
# Return code....:
# Date & Author..: No.FUN-BB0132 11/11/24 by pauline
# Modify.........: No.CHI-C20037 12/02/17 By pauline 補上tm.more的處理
# Modify.........: No.TQC-C30145 12/03/09 By pauline 修改where 條件 避免相同資料重複印出
# Modify.........: No.TQC-C30200 12/03/12 By pauline 不用判斷是否為流通環境
# Modify.........: No.FUN-C70007 12/07/26 By yangxf  添加數據源資料
# Modify.........: No.FUN-C70007 12/07/30 By yangxf  CR转GR
# Modify.........: No.FUN-CA0103 12/10/19 By xumeimei 更改日期相应逻辑
# Modify.........: No:FUN-D40055 13/04/16 By dongsz 增加日期區間

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD                # Print condition RECORD
              azw01   STRING,
              #date    LIKE type_file.dat,  #FUN-CA0103 mark
              date    STRING,               #FUN-CA0103 add
              bdate         LIKE type_file.dat,   #FUN-D40055 add
              edate         LIKE type_file.dat,   #FUN-D40055 add
              source  LIKE type_file.chr1,
              more    LIKE type_file.chr1
              END RECORD
DEFINE   g_sql           STRING
DEFINE   l_table         STRING
DEFINE g_str             STRING
DEFINE g_chk_auth        STRING
DEFINE g_chk_azw01       LIKE type_file.chr1
DEFINE g_azw01_str       STRING
DEFINE g_azw01           LIKE azw_file.azw01
DEFINE g_posdb           LIKE ryg_file.ryg00     #FUN-C70007 add
DEFINE g_posdb_link      LIKE ryg_file.ryg02     #FUN-C70007 add
DEFINE   g_ary DYNAMIC ARRAY OF RECORD
           plant      LIKE azw_file.azw01           #plant
           END RECORD
DEFINE   g_ary_i        LIKE type_file.num5
DEFINE g_wc             STRING                   #FUN-C70007 add
DEFINE g_flag           LIKE type_file.chr1      #FUN-C70007 add
DEFINE g_argv1          STRING                   #FUN-CA0103 add
DEFINE g_argv2          STRING                   #FUN-CA0103 add
###GENGRE###START
TYPE sr1_t RECORD
    azw01 LIKE azw_file.azw01,
    azw08 LIKE azw_file.azw08,
    bdate LIKE ryz_file.ryzdate,    #FUN-CA0103 add
    no LIKE oga_file.oga01,
    price LIKE ogb_file.ogb14t,
    pos LIKE ryz_file.ryz02
   ,type LIKE type_file.chr1    #FUN-C70007 add
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT

  #CHI-C20037 add START
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
  #LET tm.azw01 = ARG_VAL(7)  #FUN-CA0103
  #LET tm.date = ARG_VAL(8)   #FUN-CA0103
   LET g_argv1 = ARG_VAL(7)   #FUN-CA0103
   LET g_argv2 = ARG_VAL(8)   #FUN-CA0103
   LET tm.azw01 = "azw01 in( '",cl_replace_str(g_argv1,",","','"),"')"  #FUN-CA0103
   LET tm.date = "bdate in ( '",cl_replace_str(g_argv2,",","','"),"')"  #FUN-CA0103
   LET tm.source = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)
  #CHI-C20037 add END
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("APC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_sql = " azw01.azw_file.azw01,",
               " azw08.azw_file.azw08,",
               " bdate.ryz_file.ryzdate,",   #FUN-CA0103 add
               " no.oga_file.oga01,",
               " price.ogb_file.ogb14t,",
              #" pos.ryz_file.ryz02 "          #FUN-C70007 mark
               " pos.ryz_file.ryz02,",         #FUN-C70007 add
               " TYPE.type_file.chr1"          #FUN-C70007 add
   LET l_table = cl_prt_temptable('apcg010',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?)"          #FUN-C70007 add ?  #FUN-CA0103 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL apcg010_tm()        # Input print condition
   ELSE
      LET tm.bdate = ''        #FUN-D40055 add 
      LET tm.edate = ''        #FUN-D40055 add 
      CALL apcg010()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION apcg010_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
DEFINE p_row,p_col    LIKE type_file.num5,
      #l_cmd          STRING,  #CHI-C20037 mark
       l_cmd1         LIKE type_file.chr1000
DEFINE tok            base.StringTokenizer
DEFINE l_azw01        LIKE azw_file.azw01
DEFINE l_n            LIKE type_file.num5
DEFINE l_n1           LIKE type_file.num5
DEFINE l_sql          STRING
DEFINE l_ryg01        LIKE ryg_file.ryg01
DEFINE l_plant        LIKE azw_file.azw01
DEFINE l_string       STRING
DEFINE l_cmd          LIKE type_file.chr1000 #CHI-C20037 add
DEFINE l_rcj10        LIKE rcj_file.rcj10    #FUN-D40055 add
   LET p_row = 6 LET p_col = 16
   OPEN WINDOW apcg010_w AT p_row,p_col WITH FORM "apc/42f/apcg010"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
  #FUN-D40055--add--str---
   LET tm.edate = g_today                 
   SELECT rcj10 INTO l_rcj10 FROM rcj_file 
   LET tm.bdate = g_today - l_rcj10     
   DISPLAY tm.bdate TO bdate
   DISPLAY tm.edate TO edate
  #FUN-D40055--add--end---
   DISPLAY BY NAME tm.more

   WHILE TRUE
      LET tm.azw01 = ''
     #LET tm.date = ''                  #FUN-D40055 mark
      LET tm.source = '' 
      #FUN-C70007 add begin ----
      DIALOG ATTRIBUTES(UNBUFFERED)
         CONSTRUCT BY NAME tm.azw01 ON azw01

            BEFORE CONSTRUCT
               CALL cl_qbe_init()


            ON ACTION controlp
               CASE
                  WHEN INFIELD(azw01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_zxy01"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.where = " azp01 IN ",g_auth
                     LET g_qryparam.arg1 = g_user
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     LET tm.azw01 = g_qryparam.multiret
                     DISPLAY tm.azw01 TO azw01
                     NEXT FIELD azw01
               END CASE

            ON ACTION locale
               CALL cl_show_fld_cont()
               LET g_action_choice = "locale"
               EXIT DIALOG

         END CONSTRUCT
         #FUN-CA0103-----add----str
        #FUN-D40055--mark--str---
        #CONSTRUCT BY NAME tm.date ON bdate      
        #   BEFORE CONSTRUCT
        #      CALL cl_qbe_init()

        #END CONSTRUCT
        #FUN-D40055--mark--end---
         #FUN-CA0103-----add----end
        #INPUT BY NAME  tm.azw01,tm.date,tm.source,tm.more WITHOUT DEFAULTS    #FUN-C70007 mark
        #INPUT BY NAME  tm.date,tm.source,tm.more                              #FUN-C70007 add  #FUN-CA0103 mark
        #INPUT BY NAME  tm.source,tm.more                                      #FUN-CA0103 add  #FUN-D40055 mark
         INPUT BY NAME  tm.bdate,tm.edate,tm.source,tm.more ATTRIBUTE(WITHOUT DEFAULTS=TRUE)    #FUN-D40055 add 
            BEFORE INPUT
              CALL cl_qbe_display_condition(lc_qbe_sn)
           #CHI-C20037 mark START #搬移到r010_plant2 內處理
           #AFTER FIELD azw01
           #   LET g_chk_azw01 = TRUE
           #   LET g_azw01_str = tm.azw01
           #   LET g_chk_auth = ''
           #   IF NOT cl_null(g_azw01_str) AND g_azw01_str <> "*" THEN
           #      CALL r010_plant2(g_azw01_str)
           #      LET g_chk_azw01 = FALSE
           #      LET tok = base.StringTokenizer.create(g_azw01_str,"|")
           #      LET g_azw01 = ""
           #      WHILE tok.hasMoreTokens()
           #          LET g_azw01 = tok.nextToken()
           #          LET l_sql = " SELECT COUNT(*) FROM azw_file",
           #                      " WHERE azw01 ='",g_azw01,"'",
           #                      " AND azw01 IN ",g_auth,
           #                      " AND azwacti = 'Y'"
           #          PREPARE sel_num_pre FROM l_sql
           #          EXECUTE sel_num_pre INTO l_n
           #          SELECT COUNT(*) INTO l_n1 FROM zxy_file
           #           WHERE zxy01 = g_user
           #             AND zxy03 = g_azw01
           #             IF l_n > 0 AND l_n1 > 0 THEN
           #                 CALL r010_plant(g_azw01) RETURNING l_plant
           #                 IF NOT cl_null(l_plant) THEN
           #                    IF cl_null(l_string) THEN
           #                       LET l_string = "'",l_plant,"'"
           #                    ELSE
           #                       LET l_string = l_string, ",'", l_plant,"'"
           #                    END IF
           #                 END IF
           #                 IF g_chk_auth IS NULL THEN
           #                    LET g_chk_auth = "'",g_azw01,"'"
           #                 ELSE
           #                    LET g_chk_auth = g_chk_auth,",'",g_azw01,"'"
           #                 END IF
           #             ELSE
           #                CONTINUE WHILE
           #             END IF
           #      END WHILE
           #      IF g_chk_auth IS NOT NULL THEN
           #         LET g_chk_auth = "(",g_chk_auth,")"
           #      END IF
           #   END IF

           #   IF g_chk_azw01 THEN
           #      LET g_chk_auth = g_auth
           #   END IF
           #CHI-C20037 mark END
            #FUN-D40055--add--str---
             AFTER FIELD bdate
                IF NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN
                   IF tm.bdate > tm.edate THEN
                      CALL cl_err('',"alm1038",0)
                      NEXT FIELD bdate
                   END IF
                END IF

             AFTER FIELD edate
                IF NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN
                   IF tm.bdate > tm.edate THEN
                      CALL cl_err('',"alm1038",0)
                      NEXT FIELD edate
                   END IF
                END IF

            #FUN-D40055--add--end---

            #CHI-C20037 add START
             AFTER FIELD more
               IF tm.more = 'Y'
                  THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
               END IF
            #CHI-C20037 add END

           #FUN-C70007 MARK BEGIN ---
           # ON ACTION controlp
           #    CASE
           #       WHEN INFIELD(azw01)
           #          CALL cl_init_qry_var()
           #          LET g_qryparam.form = "q_zxy01"
           #          LET g_qryparam.state = "c"
           #          LET g_qryparam.where = " azp01 IN ",g_auth
           #          LET g_qryparam.arg1 = g_user
           #          CALL cl_create_qry() RETURNING g_qryparam.multiret
           #          LET tm.azw01 = g_qryparam.multiret
           #          DISPLAY tm.azw01 TO azw01
           #          NEXT FIELD azw01
           #    END CASE

           # ON ACTION CONTROLR
           #     CALL cl_show_req_fields()
           # ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
           #
           # ON IDLE g_idle_seconds
           #    CALL cl_on_idle()
           #    CONTINUE INPUT
           #FUN-C70007 MARK end ----

            ON ACTION locale
               CALL cl_show_fld_cont()
               LET g_action_choice = "locale"
              #EXIT INPUT           #FUN-C70007 mark
               EXIT DIALOG          #FUN-C70007 add

           #FUN-C70007 MARK BEGIN ---
           #ON ACTION about
           #   CALL cl_about()
           #
           #ON ACTION help
           #   CALL cl_show_help()
           #
           #ON ACTION EXIT
           #   LET INT_FLAG = 1
           #   EXIT INPUT
           #
           #ON ACTION qbe_save
           #  CALL cl_qbe_save()
           #FUN-C70007 MARK end ----
         END INPUT
      #FUN-C70007 add begin ---
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION exit
            LET INT_FLAG = 1
            CLOSE WINDOW apcr010_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION close
            LET INT_FLAG=1
            CLOSE WINDOW apcr010_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM

         ON ACTION accept
           #FUN-D40055--mark--str---
           #IF tm.azw01 = " 1=1" THEN
           #   CALL cl_err('','apc-198',0)
           #   NEXT FIELD azw01
           #END IF
           #FUN-D40055--mark--end---
            IF cl_null(tm.source) THEN
               CALL cl_err('','apc-202',0)
               NEXT FIELD source
            END IF
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG=1
            CLOSE WINDOW apcr010_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
       END DIALOG
      #FUN-C70007 add end -----
      IF INT_FLAG THEN
        #LET INT_FLAG = 0 CLOSE WINDOW artr143_w      #FUN-C70007 mark
         LET INT_FLAG = 0 CLOSE WINDOW apcr010        #FUN-C70007 add
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
#FUN-C70007 add begin ---
     #FUN-D40055--mark--str---
     #IF tm.azw01 = " 1=1" THEN
     #   CALL cl_err('','apc-198',0)
     #   CONTINUE WHILE
     #END IF
     #FUN-D40055--mark--end---
      IF cl_null(tm.source) THEN
         CALL cl_err('','apc-202',0)
         CONTINUE WHILE
      END IF
#FUN-C70007 add end -----
     #CHI-C20037 add START
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01= g_prog
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('apcg010','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.azw01 CLIPPED,"'" ,
                       " '",tm.date CLIPPED,"'" ,
                       " '",tm.source CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",
                       " '",g_rep_clas CLIPPED,"'",
                       " '",g_template CLIPPED,"'",
                       " '",g_rpt_name CLIPPED,"'"
            CALL cl_cmdat('apcg010',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW apcg010_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
     #CHI-C20037 add END
      CALL cl_wait()
      CALL apcg010()
      ERROR ""
   END WHILE
   CLOSE WINDOW apcg010_w
END FUNCTION

FUNCTION apcg010()
DEFINE l_tablename                    STRING
DEFINE l_sql                          STRING
DEFINE l_ryg00                        LIKE ryg_file.ryg00
DEFINE l_fdate                        STRING
DEFINE l_azw08                        LIKE azw_file.azw08
DEFINE l_azw01                        LIKE azw_file.azw01    #FUN-C70007 add
DEFINE l_azi04                        LIKE azi_file.azi04
DEFINE l_tm                           STRING
DEFINE l_pos                          LIKE ryz_file.ryz02 #上傳方式(匯總/明細) 
DEFINE l_sql2                         STRING
DEFINE l_i                            LIKE type_file.num5
DEFINE sr          RECORD
            bdate                     LIKE type_file.dat,
            azw01                     LIKE azw_file.azw01,
            no                        LIKE oga_file.oga01,
            price                     LIKE ogb_file.ogb14t
           ,type                      LIKE type_file.chr1   #FUN-C70007 add
                   END RECORD
DEFINE l_str                          STRING  #CHI-C20037 add
DEFINE l_posdb                        LIKE ryg_file.ryg00   #FUN-C70007 add
DEFINE l_posdb_link                   LIKE ryg_file.ryg02   #FUN-C70007 add
DEFINE l_sql3                         STRING                #FUN-CA0103 add
DEFINE l_bdate       STRING                 #FUN-D40055 add
DEFINE l_edate       STRING                 #FUN-D40055 add
#FUN-C70007 MARK BEGIN ---
#   #CHI-C20037 add START
#   LET g_chk_azw01 = TRUE
#   LET g_azw01_str = tm.azw01
#   LET g_chk_auth = ''
#   IF NOT cl_null(g_azw01_str) AND g_azw01_str <> "*" THEN
#     CALL r010_plant2(g_azw01_str)
#   END IF
#   IF g_chk_azw01 THEN
#      LET g_chk_auth = g_auth
##      LET l_str = g_auth.subString(2,g_auth.getLength()-1)        #FUN-C70007 MARK
##      CALL r010_legal_db(l_str)                                   #FUN-C70007 MARK
#   END IF
#   #CHI-C20037 add START
#FUN-C70007 MARK end ----
   CALL cl_del_data(l_table)
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang        #FUN-C70007 add
#FUN-C70007 MARK BEGIN----
#   LET l_i = 1
#   FOR l_i = 1 TO g_ary_i
#      IF cl_null(g_ary[l_i].plant) THEN CONTINUE FOR END IF
#      LET l_sql2 = " SELECT ryz02  FROM ", cl_get_target_table(g_ary[l_i].plant, 'ryz_file')
#      PREPARE r010_pre1 FROM l_sql2
#      EXECUTE r010_pre1 INTO l_pos 
#      SELECT DISTINCT ryg00 INTO l_ryg00 FROM ryg_file
#      SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
#      IF tm.source = '1' THEN   #資料來源為銷退單時
#         IF l_pos = '1' THEN   #POS上傳方式為匯總
#            LET l_tablename = "posdl"
#         ELSE                   #POS上傳方式為明細
#            LET l_tablename = "posda"
#         END IF
#      
#         LET l_sql = " SELECT fdate, shop, fno , tot_amt",
#                     " FROM ",l_ryg00,".",l_tablename,
#                    #" WHERE shop IN ",g_chk_auth,"", #TQC-C30145 mark
#                     " WHERE shop = '",g_ary[l_i].plant,"'", #TQC-C30145 add 
#                     "   AND trans_flg = 'N'"
#      ELSE    #資料來源為客戶訂單
#         LET l_tablename = "posdg"
#       
#         LET l_sql = " SELECT fdate, shop, fno , tot_amt",
#                     " FROM ",l_ryg00,".",l_tablename,
#                    #" WHERE shop IN ",g_chk_auth,"",  #TQC-C30145 mark
#                     " WHERE shop = '",g_ary[l_i].plant,"'", #TQC-C30145 add 
#                     "   AND trans_flg = 'N'"
#      END IF
#      IF NOT cl_null(tm.date) THEN
#         LET l_fdate = DATE(tm.date) USING "yyyymmdd"
#         LET l_sql = l_sql ," AND fdate = '",l_fdate,"'" 
#      END IF
#      LET l_sql = l_sql ," ORDER BY fno, shop ,fdate "
#      PREPARE r010_pre FROM l_sql
#      DECLARE r010_cl CURSOR FOR r010_pre 
#      FOREACH r010_cl INTO sr.*  
#         IF STATUS THEN
#            CALL cl_err('PLANT:',SQLCA.sqlcode,1)
#            RETURN
#         END IF
#         SELECT azw08 INTO l_azw08 FROM azw_file WHERE azw01 = sr.azw01
#         EXECUTE insert_prep USING sr.azw01, l_azw08, sr.no, sr.price, l_pos      
#      END FOREACH
#   END FOR 
#FUN-C70007 MARK END ---
#FUN-C70007 add begin---
#FUN-CA0103---------mark---------str
#  LET l_ryg00= 'ds_pos1'
#  SELECT DISTINCT ryg00,ryg02 INTO l_posdb,l_posdb_link FROM ryg_file WHERE ryg00=l_ryg00
#  LET g_posdb=s_dbstring(l_posdb)
#  LET g_posdb_link=r010_dblinks(l_posdb_link)
#  LET l_sql = "SELECT DISTINCT azw01 FROM azw_file ",
#              "  WHERE ",tm.azw01 CLIPPED,
#              "    AND azw01 IN ",g_auth
#  PREPARE r010_azw01_pre FROM l_sql
#  DECLARE r010_azw01_cs CURSOR FOR r010_azw01_pre
#  FOREACH r010_azw01_cs INTO l_azw01
#     LET l_sql2 = " SELECT ryz02  FROM ", cl_get_target_table(l_azw01, 'ryz_file')
#     PREPARE r010_pre1 FROM l_sql2
#     EXECUTE r010_pre1 INTO l_pos 
#     SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
#     CASE 
#         #全部       
#         WHEN tm.source = '0'
#            LET l_sql = " SELECT BDATE,SHOP,SaleNO,TOT_AMT,TYPE", 
#                        "   FROM ",g_posdb,"td_Sale",g_posdb_link,
#                        "  WHERE SHOP = '",l_azw01,"'",
#                        "    AND CONDITION2 <> 'Y'",
#                        "    AND TYPE IN ('0','1','2','3','4') ",
#                        " UNION ALL SELECT BDATE,SHOP,SaleNO,INVAMT,5 ",
#                        " FROM ",g_posdb,"td_InvoiceDetail",g_posdb_link,
#                        " WHERE SHOP = '",l_azw01,"'", 
#                        "   AND CONDITION2 <> 'Y'"
#         #資料來源為客戶訂單
#         WHEN tm.source = '1'
#            LET l_sql = " SELECT BDATE,SHOP,SaleNO,TOT_AMT,TYPE",
#                        "   FROM ",g_posdb,"td_Sale",g_posdb_link,
#                        "  WHERE SHOP = '",l_azw01,"'", 
#                        "    AND CONDITION2 <> 'Y'",
#                        "    AND TYPE = '3' "
#         #資料來源為訂金退回單
#         WHEN tm.source = '2' 
#            LET l_sql = " SELECT BDATE,SHOP,SaleNO,TOT_AMT,TYPE",
#                        " FROM ",g_posdb,"td_Sale",g_posdb_link,
#                        " WHERE SHOP = '",l_azw01,"'",
#                        "   AND CONDITION2 <> 'Y'",
#                        "   AND TYPE = '4'"
#         #資料來源為銷售銷退單
#         WHEN tm.source = '3'
#            LET l_sql = " SELECT BDATE,SHOP,SaleNO,TOT_AMT,TYPE",
#                        " FROM ",g_posdb,"td_Sale",g_posdb_link,
#                        " WHERE SHOP = '",l_azw01,"'", 
#                        "   AND CONDITION2 <> 'Y'",
#                        "   AND TYPE IN('0','1','2')"
#         #資料來源為發票
#         WHEN tm.source = '4' 
#            LET l_sql = " SELECT BDATE,SHOP,SaleNO,INVAMT,5",
#                        " FROM ",g_posdb,"td_InvoiceDetail",g_posdb_link,
#                        " WHERE SHOP = '",l_azw01,"'",
#                        "   AND CONDITION2 <> 'Y'"
#     END CASE    
#     IF NOT cl_null(tm.date) THEN
#        #LET l_fdate = DATE(tm.date) USING "yyyymmdd"     #FUN-CA0103 mark
#        #LET l_sql = l_sql ," AND BDATE = '",l_fdate,"'"  #FUN-CA0103 mark
#        LET l_sql = l_sql ,"AND ", tm.date CLIPPED
#     END IF
#     LET l_sql = l_sql ," ORDER BY SHOP,BDATE,TYPE,SaleNO "
#     PREPARE r010_pre FROM l_sql
#     DECLARE r010_cl CURSOR FOR r010_pre
#     FOREACH r010_cl INTO sr.*
#        IF STATUS THEN
#           CALL cl_err('PLANT:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#        END IF
#        SELECT azw08 INTO l_azw08 FROM azw_file WHERE azw01 = sr.azw01
#        EXECUTE insert_prep USING sr.azw01, l_azw08, sr.bdate, sr.no, sr.price, l_pos,sr.type
#     END FOREACH
#  END FOREACH
#FUN-C70007 add end -----
#FUN-CA0103---------mark---------end
#FUN-CA0103---------add----------str
SELECT DISTINCT ryg00,ryg02 INTO l_posdb,l_posdb_link FROM ryg_file WHERE ryg00='ds_pos1'
    LET l_posdb=s_dbstring(l_posdb)
    LET l_posdb_link=r010_dblinks(l_posdb_link)
   #FUN-D40055--add--str---
    IF cl_null(tm.azw01) THEN
       LET tm.azw01 = " 1=1" 
    END IF
    LET tm.azw01 = tm.azw01," AND azw01 IN (SELECT ryg01 FROM ryg_file WHERE rygacti = 'Y') "
    IF cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN
       LET l_edate = DATE(tm.edate) USING "yyyymmdd"
       LET tm.date = " BDATE <= '",l_edate,"' "
    END IF
    IF NOT cl_null(tm.bdate) THEN
       IF cl_null(tm.edate) THEN
          LET tm.edate = g_today
          LET l_edate = DATE(tm.edate) USING "yyyymmdd"
       END IF
       LET l_bdate = DATE(tm.bdate) USING "yyyymmdd"
       LET l_edate = DATE(tm.edate) USING "yyyymmdd"
       LET tm.date = " BDATE BETWEEN '",l_bdate,"' AND '",l_edate,"' "
    END IF
   #FUN-D40055--add--end---
    IF cl_null(tm.date) THEN
       LET tm.date = " 1=1"                                     
    END IF
    LET l_sql3 = " SELECT ryz02 FROM ryz_file,azw_file",
                 "  WHERE azw01 IN ",g_auth
    PREPARE r010_ryz_pre1 FROM l_sql3
    EXECUTE r010_ryz_pre1 INTO l_pos
    CASE
        #全部
        WHEN tm.Source = '0'
           LET l_sql = " SELECT BDATE,SHOP,SaleNO,TOT_AMT,TYPE",
                       "   FROM ",l_posdb,"td_Sale",l_posdb_link,",",
                       "         azw_file",
                       "  WHERE SHOP = azw01",
                       "    AND azw01 IN ",g_auth,
                       "    AND CONDITION2 <> 'Y'",
                       "    AND TYPE IN ('0','1','2','3','4') ",
                       "    AND ",tm.azw01 CLIPPED,
                       "    AND ",tm.date CLIPPED,
                       " UNION ALL SELECT BDATE,SHOP,SaleNO,INVAMT,5",
                       "             FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,",",
                       "                   azw_file",
                       "            WHERE SHOP = azw01",
                       "              AND azw01 IN ",g_auth,
                       "              AND CONDITION2 <> 'Y'",
                       "    AND ",tm.azw01 CLIPPED,
                       "    AND ",tm.date CLIPPED
        #資料來源為客戶訂單
        WHEN tm.Source = '1'
           LET l_sql = " SELECT BDATE,SHOP,SaleNO,TOT_AMT,TYPE",
                       "   FROM ",l_posdb,"td_Sale",l_posdb_link,",",
                       "         azw_file",
                       "  WHERE SHOP = azw01",
                       "    AND azw01 IN ",g_auth,
                       "    AND ",tm.azw01 CLIPPED,
                       "    AND ",tm.date CLIPPED,
                       "    AND CONDITION2 <> 'Y'",
                       "    AND TYPE = '3' "
        #資料來源為訂金退回單
        WHEN tm.Source = '2'
           LET l_sql = " SELECT BDATE,SHOP,SaleNO,TOT_AMT,TYPE",
                       "   FROM ",l_posdb,"td_Sale",l_posdb_link,",",
                       "         azw_file",
                       "  WHERE SHOP = azw01",
                       "    AND azw01 IN ",g_auth,
                       "    AND ",tm.azw01 CLIPPED,
                       "    AND ",tm.date CLIPPED,
                       "    AND CONDITION2 <> 'Y'",
                       "    AND TYPE = '4'"
        #資料來源為銷售銷退單
        WHEN tm.Source = '3'
           LET l_sql = " SELECT BDATE,SHOP,SaleNO,TOT_AMT,TYPE",
                       "   FROM ",l_posdb,"td_Sale",l_posdb_link,",",
                       "         azw_file",
                       "  WHERE SHOP = azw01",
                       "    AND azw01 IN ",g_auth,
                       "    AND ",tm.azw01 CLIPPED,
                       "    AND ",tm.date CLIPPED,
                       "    AND CONDITION2 <> 'Y'",
                       "    AND TYPE IN('0','1','2')"
        #資料來源為發票
        WHEN tm.Source = '4'
           LET l_sql = " SELECT BDATE,SHOP,SaleNO,TOT_AMT,TYPE",
                       "   FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,",",
                       "         azw_file",
                       "  WHERE SHOP = azw01",
                       "    AND azw01 IN ",g_auth,
                       "    AND ",tm.azw01 CLIPPED,
                       "    AND ",tm.date CLIPPED,
                       "    AND CONDITION2 <> 'Y'"
    END CASE
   #LET l_sql = l_sql ," ORDER BY SHOP,BDATE,TYPE,SALENO"           #FUN-D40055 mark
    LET l_sql = l_sql ," ORDER BY SHOP,BDATE DESC "                      #FUN-D40055 add
    PREPARE q002_pre FROM l_sql
    DECLARE q002_cl CURSOR FOR q002_pre
    FOREACH q002_cl INTO sr.*
       IF STATUS THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT azw08 INTO l_azw08 FROM azw_file WHERE azw01 = sr.azw01
       EXECUTE insert_prep USING sr.azw01, l_azw08, sr.bdate, sr.no, sr.price, l_pos,sr.type
    END FOREACH
#FUN-CA0103---------add----------end
###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET l_tm = ' '
#  IF NOT cl_null(g_chk_auth) THEN      #FUN-C70007 MARK
#  LET l_tm = " shop IN ",g_chk_auth    #FUN-C70007 MARK
   CALL cl_replace_str(tm.azw01,"azw01","SHOP") RETURNING g_wc      ##FUN-C70007 add
#  END IF    
###GENGRE###   LET g_str = l_tm,";",tm.date,";",tm.source,";",l_azi04 
###GENGRE###   CALL cl_prt_cs3('apcg010','apcg010',l_sql,g_str)
    CALL apcg010_grdata()    ###GENGRE###
END FUNCTION
#判斷營運中心法人
#TQC-C30200 mark START
#FUNCTION r010_plant(p_plant)
#DEFINE p_plant         LIKE azw_file.azw01
#DEFINE p_string        STRING
#DEFINE l_azw01         LIKE azw_file.azw01
#DEFINE l_cnt           LIKE type_file.num5
#DEFINE l_sql           STRING
#  LET l_azw01 = ' '
#  SELECT COUNT(*) INTO l_cnt FROM azw_file
#     WHERE azw09 = azw05 AND azw02 IN (SELECT azw02 FROM azw_file WHERE azw01 = p_plant)
#  IF l_cnt > 1 THEN #流通
#     SELECT azw01 INTO l_azw01 FROM azw_file  #選擇總部(登入DB=實體DB)為plant
#        WHERE azw09 = azw05 AND azw02 IN (SELECT azw02 FROM azw_file WHERE azw01 = p_plant)
#          AND azw05 = azw06
#     IF cl_null(l_azw01) THEN #沒設定總部(登入DB=實體DB),則第一筆plant為主
#        LET l_sql = "SELECT azw01 FROM azw_file ",
#                    " WHERE azw09 = azw05 AND azw02 IN (SELECT azw02 FROM azw_file WHERE azw01 = '",p_plant,"') ",
#                    " ORDER BY azw01 "
#        PREPARE plant_pre FROM l_sql
#        DECLARE plant_cur CURSOR FOR plant_pre
#        FOREACH plant_cur INTO l_azw01
#          IF NOT cl_null(l_azw01) THEN
#             EXIT FOREACH
#          END IF
#        END FOREACH
#     END IF
#  ELSE
#     SELECT azw01 INTO l_azw01 FROM azw_file
#        WHERE azw09 = azw05 AND azw02 IN (SELECT azw02 FROM azw_file WHERE azw01 = p_plant)
#  END IF
#  RETURN l_azw01
#END FUNCTION
#TQC-C30200 mark END
#FUN-C70007 MARK begin ---
##將plant放入array
#FUNCTION r010_legal_db(p_string)
#DEFINE p_string  STRING
#DEFINE l_cnt     LIKE type_file.num5
#DEFINE l_azw09   LIKE azw_file.azw09
#DEFINE l_azw05   LIKE azw_file.azw05
#DEFINE l_sql     STRING
#   IF cl_null(p_string) THEN
#      LET p_string = g_plant
#   END IF
#   LET g_ary_i = 1
#   LET g_errno = ' '
#
#   LET l_sql = "SELECT DISTINCT azw01 FROM azw_file ",
#               "  WHERE azw01 IN ( ",p_string," ) "
#   PREPARE r010_azw01_pre FROM l_sql
#   DECLARE r010_azw01_cs CURSOR FOR r010_azw01_pre
#   FOREACH r010_azw01_cs INTO g_ary[g_ary_i].plant
#      LET g_ary_i = g_ary_i + 1
#   END FOREACH
#   LET g_ary_i = g_ary_i - 1
#
#END FUNCTION
#FUN-C70007 MARK END ----
#FUN-BB0132
#CHI-C20037 add START
FUNCTION r010_plant2(p_string)
DEFINE p_string  STRING
DEFINE tok            base.StringTokenizer
DEFINE l_azw01        LIKE azw_file.azw01
DEFINE l_n            LIKE type_file.num5
DEFINE l_n1           LIKE type_file.num5
DEFINE l_sql          STRING
DEFINE l_plant        LIKE azw_file.azw01
DEFINE l_string       STRING
    LET g_chk_azw01 = FALSE
    LET tok = base.StringTokenizer.create(p_string,"|")
    LET g_azw01 = ""
    WHILE tok.hasMoreTokens()
        LET g_azw01 = tok.nextToken()
        LET l_sql = " SELECT COUNT(*) FROM azw_file",
                    " WHERE azw01 ='",g_azw01,"'",
                    " AND azw01 IN ",g_auth,
                    " AND azwacti = 'Y'"
        PREPARE sel_num_pre1 FROM l_sql
        EXECUTE sel_num_pre1 INTO l_n
        SELECT COUNT(*) INTO l_n1 FROM zxy_file
         WHERE zxy01 = g_user
           AND zxy03 = g_azw01
           IF l_n > 0 AND l_n1 > 0 THEN
              #CALL r010_plant(g_azw01) RETURNING l_plant   #TQC-C30200 mark
              #IF NOT cl_null(l_plant) THEN   #TQC-C30200 mark
               IF NOT cl_null(g_azw01) THEN   #TQC-C30200 add
                  IF cl_null(l_string) THEN
                    #LET l_string = "'",l_plant,"'"   #TQC-C30200 mark
                     LET l_string = "'",g_azw01,"'"   #TQC-C30200 add
                  ELSE
                    #LET l_string = l_string, ",'", l_plant,"'"   #TQC-C30200 mark
                     LET l_string = l_string, ",'", g_azw01,"'"   #TQC-C30200 add
                  END IF
               END IF
               IF g_chk_auth IS NULL THEN
                  LET g_chk_auth = "'",g_azw01,"'"
               ELSE
                  LET g_chk_auth = g_chk_auth,",'",g_azw01,"'"
               END IF
           ELSE
              CONTINUE WHILE
           END IF
    END WHILE
    IF g_chk_auth IS NOT NULL THEN
       LET g_chk_auth = "(",g_chk_auth,")"
    END IF
#   CALL r010_legal_db(l_string)      #FUN-C70007 MARK
END FUNCTION
#CHI-C20037 add END

#FUN-C70007 add begin---
FUNCTION r010_dblinks(l_db_links)
DEFINE l_db_links LIKE ryg_file.ryg02

  IF l_db_links IS NULL OR l_db_links = ' ' THEN
     RETURN ' '
  ELSE
     LET l_db_links = '@',l_db_links CLIPPED
     RETURN l_db_links
  END IF

END FUNCTION
#FUN-C70007 add end ----


###GENGRE###START
FUNCTION apcg010_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING
    DEFINE l_azw01  LIKE azw_file.azw01    #FUN-C70007 add

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("apcg010")
        IF handler IS NOT NULL THEN
            START REPORT apcg010_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        #," ORDER BY azw01 "              #FUN-C70007 add    #FUN-CA0103 mark
                       #," ORDER BY azw01,bdate,TYPE,no " #FUN-CA0103 add    #FUN-D40055 mark
                        ," ORDER BY azw01,bdate DESC "          #FUN-D40055 add 
            DECLARE apcg010_datacur1 CURSOR FROM l_sql
            FOREACH apcg010_datacur1 INTO sr1.*
                #FUN-C70007 add begin----
                IF l_azw01 <> sr1.azw01 THEN
                   LET g_flag = 'N'
                ELSE
                   LET g_flag = 'Y'
                END IF 
                #FUN-C70007 add end -----
                OUTPUT TO REPORT apcg010_rep(sr1.*)
                LET l_azw01 = sr1.azw01    #FUN-C70007 add 
            END FOREACH
            FINISH REPORT apcg010_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT apcg010_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_price_fmt   STRING                       #FUN-C70007 add
    DEFINE l_price_sum   LIKE ogb_file.ogb14t         #FUN-C70007 add    
    DEFINE l_pos         STRING                       #FUN-C70007 add
    DEFINE l_source      STRING                       #FUN-C70007 add
    ORDER EXTERNAL BY sr1.azw01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            LET g_pdate = g_today             #FUN-C70007 add
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            LET l_source = cl_gr_getmsg('gre-298',g_lang,sr1.type)    #FUN-C70007 add
            PRINTX tm.*
       #FUN-C70007 add begin ---
            PRINTX g_wc 
            PRINTX l_source
            PRINTX g_flag
       #FUN-C70007 add end ----
              
        BEFORE GROUP OF sr1.azw01

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_pos = cl_gr_getmsg('gre-297',g_lang,sr1.pos)    #FUN-C70007 add
            PRINTX l_pos                                          #FUN-C70007 add
            PRINTX sr1.*

        AFTER GROUP OF sr1.azw01
#FUN-C70007 add begin ---
           LET l_price_sum = GROUP SUM(sr1.price)
           LET l_price_fmt = cl_gr_numfmt('ogb_file','ogb14t',g_azi04)
           PRINTX l_price_sum
           PRINTX l_price_fmt
#FUNC-70007 add end -----
        ON LAST ROW

END REPORT
###GENGRE###END
