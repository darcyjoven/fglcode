# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmi910.4gl
# Descriptions...: 海運基本資料維護作業
# Date & Author..: 04/05/13 BY Mandy
# Modify.........: No.FUN-4B0038 04/11/15 By pengu ARRAY轉為EXCEL檔
# Modify.........: NO.FUN-4C0096 05/01/11 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-570109 05/07/15 By jackie 修正建檔程式key值是否可更改
# Modify.........: No.FUN-660167 06/06/26 By day cl_err --> cl_err3
# Modify.........: No.TQC-660147 06/07/04 By Pengu 報表列印有pzz寬度不合問題
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     g_ozb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ozb01       LIKE ozb_file.ozb01,   #
        ozb02       LIKE ozb_file.ozb02,   #
        ozbacti     LIKE type_file.chr1    #資料有效碼  #No.FUN-680137 VARCHAR(1)
                    END RECORD,
    g_ozb_t         RECORD                 #程式變數 (舊值)
        ozb01       LIKE ozb_file.ozb01,   #
        ozb02       LIKE ozb_file.ozb02,   #
        ozbacti     LIKE type_file.chr1    #資料有效碼  #No.FUN-680137 VARCHAR(01)
                    END RECORD,
   #g_wc,g_sql      LIKE type_file.chr1000,#No.FUN-680137 VARCHAR(300)
    g_wc,g_sql      STRING, #TQC-630166    
    g_rec_b         LIKE type_file.num5,   #單身筆數      #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT #No.FUN-680137 SMALLINT
    p_row,p_col     LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
DEFINE g_before_input_done     STRING
DEFINE g_forupd_sql            STRING
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0094
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
 
    LET p_row = 3 LET p_col = 16
    OPEN WINDOW i910_w AT p_row,p_col WITH FORM "axm/42f/axmi910"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET g_wc = '1=1'
    CALL i910_b_fill(g_wc)
    CALL i910_menu()
    CLOSE WINDOW i910_w                    #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
FUNCTION i910_menu()
 
   WHILE TRUE
      CALL i910_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i910_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i910_b()
             ELSE
                LET g_action_choice = NULL
             END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i910_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ozb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i910_q()
   CALL i910_b_askkey()
END FUNCTION
 
FUNCTION i910_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態        #No.FUN-680137 VARCHAR(1)
    ozb08_t         LIKE aab_file.aab01,                #No.FUN-680137  VARCHAR(24)
 l_allow_insert     LIKE type_file.chr1,                #可新增否  #No.FUN-680137  VARCHAR(1)                                                      
    l_allow_delete  LIKE type_file.chr1                 #可刪除否  #No.FUN-680137  VARCHAR(1)                                                 
DEFINE li_flag      LIKE type_file.num5                 #No.FUN-680137  SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT ozb01,ozb02,ozbacti FROM ozb_file ",
                       "WHERE ozb01= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i910_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    INPUT ARRAY g_ozb WITHOUT DEFAULTS FROM s_ozb.*
          ATTRIBUTE (COUNT      =g_rec_b,
                     MAXCOUNT   =g_max_rec,
                     UNBUFFERED,
                     INSERT ROW = l_allow_insert,
                     DELETE ROW =l_allow_delete,APPEND ROW=l_allow_insert)
 
 
          BEFORE INPUT
              LET g_action_choice = ""
              IF g_rec_b!=0 THEN
                 CALL fgl_set_arr_curr(l_ac)
              END IF
 
          BEFORE ROW
              LET p_cmd=''
              LET l_ac = ARR_CURR()
              LET l_lock_sw = 'N'            #DEFAULT
              LET l_n  = ARR_COUNT()
 
              IF g_rec_b >= l_ac THEN
                  BEGIN WORK
                  LET p_cmd='u'
                  LET g_ozb_t.* = g_ozb[l_ac].*  #BACKUP
#No.FUN-570109 --start--
                  LET g_before_input_done = FALSE
                  CALL i910_set_entry_b(p_cmd)
                  CALL i910_set_no_entry_b(p_cmd)
                  LET g_before_input_done = TRUE
#No.FUN-570109 --end--
                  OPEN i910_bcl USING g_ozb_t.ozb01
                  IF STATUS THEN
                     CALL cl_err("OPEN i910_bcl:", STATUS, 1)
                     LET l_lock_sw = 'Y'
                  ELSE
                     FETCH i910_bcl INTO g_ozb[l_ac].*
                     IF SQLCA.sqlcode THEN
                        CALL cl_err(g_ozb_t.ozb01,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                     END IF
                  END IF
                  CALL cl_show_fld_cont()     #FUN-550037(smin)
              END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start--
            LET g_before_input_done = FALSE
            CALL i910_set_entry_b(p_cmd)
            CALL i910_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570109 --end--
            INITIALIZE g_ozb[l_ac].* TO NULL
            LET g_ozb[l_ac].ozbacti = 'Y'         #Body default
            LET g_ozb_t.* = g_ozb[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ozb01
 
          AFTER INSERT
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 CANCEL INSERT
                 CLOSE i910_bcl
              END IF
              INSERT INTO ozb_file(ozb01,ozb02,
                                   ozbacti,ozbuser,ozbgrup,ozbdate,ozboriu,ozborig)
              VALUES(g_ozb[l_ac].ozb01,g_ozb[l_ac].ozb02,
                     g_ozb[l_ac].ozbacti,g_user,g_grup,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_ozb[l_ac].ozb01,SQLCA.sqlcode,0)   #No.FUN-660167
                 CALL cl_err3("ins","ozb_file",g_ozb[l_ac].ozb01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                 CANCEL INSERT
              ELSE
                 MESSAGE 'INSERT O.K'
                 LET g_rec_b=g_rec_b+1
                 DISPLAY g_rec_b TO FORMONLY.cn2
              END IF
 
          AFTER FIELD ozb01
              IF NOT cl_null(g_ozb[l_ac].ozb01) THEN
                 IF p_cmd = 'a' OR g_ozb[l_ac].ozb01 != g_ozb_t.ozb01 THEN
                    SELECT count(*) INTO l_n FROM ozb_file
                        WHERE ozb01 = g_ozb[l_ac].ozb01
                    IF l_n > 0 THEN                  # Duplicated
                        CALL cl_err(g_ozb[l_ac].ozb01,-239,0)
                        LET g_ozb[l_ac].ozb01 = g_ozb_t.ozb01
                        NEXT FIELD ozb01
                    END IF
                 END IF
              END IF
 
          AFTER FIELD ozbacti
              IF NOT cl_null(g_ozb[l_ac].ozbacti) THEN
                 IF g_ozb[l_ac].ozbacti NOT MATCHES '[YN]' THEN
                    LET g_ozb[l_ac].ozbacti = g_ozb_t.ozbacti
                    NEXT FIELD ozbacti
                 END IF
              END IF
 
          BEFORE DELETE                            #是否取消單身
              IF g_ozb_t.ozb01 IS NOT NULL THEN
                  IF NOT cl_delete() THEN
                       CANCEL DELETE
                  END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                  DELETE FROM ozb_file WHERE ozb01 = g_ozb_t.ozb01
                  IF SQLCA.sqlcode THEN
#                     CALL cl_err(g_ozb_t.ozb01,SQLCA.sqlcode,0)   #No.FUN-660167
                      CALL cl_err3("del","ozb_file",g_ozb_t.ozb01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                      EXIT INPUT
                  END IF
                  DISPLAY g_rec_b TO FORMONLY.cn2
                  COMMIT WORK
              END IF
 
          ON ROW CHANGE
             IF INT_FLAG THEN                 #新增程式段
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                LET g_ozb[l_ac].* = g_ozb_t.*
                CLOSE i910_bcl
                ROLLBACK WORK
                EXIT INPUT
             END IF
             IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_ozb[l_ac].ozb01,-263,0)
                LET g_ozb[l_ac].* = g_ozb_t.*
             ELSE
                UPDATE ozb_file SET ozb01 = g_ozb[l_ac].ozb01,
                                    ozb02 = g_ozb[l_ac].ozb02,
                                    ozbacti=g_ozb[l_ac].ozbacti,
                                    ozbmodu=g_user,
                                    ozbdate=g_today
                 WHERE ozb01 = g_ozb_t.ozb01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_ozb[l_ac].ozb01,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("upd","ozb_file",g_ozb_t.ozb01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   LET g_ozb[l_ac].* = g_ozb_t.*
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
             END IF
 
          AFTER ROW
             LET l_ac = ARR_CURR()         # 新增
             LET l_ac_t = l_ac
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                IF p_cmd='u' THEN
                   LET g_ozb[l_ac].* = g_ozb_t.*
                END IF
                CLOSE i910_bcl            # 新增
                ROLLBACK WORK         # 新增
                EXIT INPUT
             END IF
             LET l_ac_t =l_ac
             CLOSE i910_bcl
             COMMIT WORK
 
 
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
       ON ACTION controlo
          IF (l_ac > 1) THEN
              LET g_ozb[l_ac].* = g_ozb[l_ac-1].*
          END IF
 
       ON ACTION controlf
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
 
 
    END INPUT
 
    CLOSE i910_bcl
    COMMIT WORK
 
 
END FUNCTION
 
 
 
FUNCTION i910_b_askkey()
    CLEAR FORM
    CALL g_ozb.clear()
    CALL cl_opmsg('q')
    CONSTRUCT g_wc ON ozb01,ozb02,ozbacti
            FROM s_ozb[1].ozb01,s_ozb[1].ozb02,s_ozb[1].ozbacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND ozbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND ozbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND ozbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ozbuser', 'ozbgrup')
    #End:FUN-980030
 
    CALL cl_opmsg('b')
    CALL i910_b_fill(g_wc)
END FUNCTION
 
FUNCTION i910_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    LET g_sql =
        "SELECT ozb01,ozb02,ozbacti ",
        " FROM ozb_file",
        " WHERE ", p_wc2 CLIPPED,            #單身
        " ORDER BY ozb01"
 
    PREPARE i910_pb FROM g_sql
    DECLARE ozb_curs CURSOR FOR i910_pb
 
    CALL g_ozb.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH ozb_curs INTO g_ozb[g_cnt].*   #單身 ARRAY 填充
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    LET l_ac = 1
    CALL g_ozb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i910_bp(p_ud)
 
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ozb TO s_ozb.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i910_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
        l_ozb   RECORD LIKE ozb_file.*
 
    IF g_wc IS NULL THEN
     #  CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT * FROM ozb_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE i910_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i910_co CURSOR FOR i910_p1
 
    LET g_rlang = g_lang                               #FUN-4C0096 add
    CALL cl_outnam('axmi910') RETURNING l_name
    START REPORT i910_rep TO l_name
 
    FOREACH i910_co INTO l_ozb.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i910_rep(l_ozb.*)
    END FOREACH
 
    FINISH REPORT i910_rep
 
    CLOSE i910_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i910_rep(sr)
    DEFINE
        l_trailer_sw   LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
        sr RECORD LIKE ozb_file.*,
        l_str           LIKE type_file.chr20         #No.FUN-680137 VARCHAR(20)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.ozb01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED  #No.TQC-6A0091
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<','/pageno'
            PRINT g_head CLIPPED, pageno_total
            #PRINT ''  #No.TQC-6A0091
 
            PRINT g_dash
            PRINT g_x[31],
                  g_x[32]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            IF sr.ozbacti = 'N' THEN
               LET l_str = '* ',sr.ozb01 CLIPPED
            ELSE
               LET l_str = '  ',sr.ozb01 CLIPPED
            END IF
            PRINT COLUMN g_c[31],l_str CLIPPED,
                  COLUMN g_c[32],sr.ozb02
        ON LAST ROW
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN PRINT g_dash
                  #TQC-630166
                  # IF g_wc[001,080] > ' ' THEN
		  #    PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
                  # IF g_wc[071,140] > ' ' THEN
		  #    PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
                  # IF g_wc[141,210] > ' ' THEN
		  #    PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                    CALL cl_prt_pos_wc(g_wc)
                  #END TQC-630166
            END IF
            PRINT g_dash
            PRINT g_x[4] CLIPPED, COLUMN (g_len -9), g_x[7] CLIPPED    #No.TQC-660147 modify
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash
                PRINT g_x[4] CLIPPED, COLUMN (g_len -9), g_x[6] CLIPPED    #No.TQC-660147 modify
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
#No.FUN-570109 --start--
FUNCTION i910_set_entry_b(p_cmd)
 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("ozb01",TRUE)
  END IF
 
END FUNCTION
 
 
FUNCTION i910_set_no_entry_b(p_cmd)
 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("ozb01",FALSE)
   END IF
 
END FUNCTION
#No.FUN-570109 --end--
