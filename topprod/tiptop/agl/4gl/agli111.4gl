# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: agli111.4gl
# Descriptions...: 科目分類資料維護作業
# Date & Author..: 92/03/10 BY DAVID
#       .........: by grace <^F> 失效
# Modify.........: 04/05/04 By Mandy Genero版本時改為單檔多欄型式
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510007 05/01/25 By Nicola 報表架構修改
# Modify.........: No.MOD-560148 05/06/29 By Nicola 程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: NO.FUN-570108 05/07/13 By Trisy key值可更改
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-750186 07/05/25 By Rayven 若"科目分類編號"取五位,且為無效時,報表此欄位顯示不全
# Modify.........: No.FUN-820002 07/12/20 By lala   報表轉為使用p_query
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-C80146 10/08/23 By lujh aae01欄位檢查加一個舊值為null的判斷
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     g_aae           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        aae01       LIKE aae_file.aae01,   #科目分類編號
        aae02       LIKE aae_file.aae02,   #科目分類名稱
        aae03       LIKE aae_file.aae03,   #備註
        aaeacti     LIKE type_file.chr1    #資料有效碼  #No.FUN-680098   VARCHAR(1)
                    END RECORD,
    g_aae_t         RECORD                 #程式變數 (舊值)
        aae01       LIKE aae_file.aae01,   #科目分類編號
        aae02       LIKE aae_file.aae02,   #科目分類名稱
        aae03       LIKE aae_file.aae03,   #備註
        aaeacti     LIKE type_file.chr1    #資料有效碼  #No.FUN-680098  VARCHAR(1)  
                    END RECORD,
#   g_wc,g_sql      VARCHAR(300),
    g_wc,g_sql      STRING,                #TQC-630166    
    g_rec_b         LIKE type_file.num5,                #單身筆數                #No.FUN-680098 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT     #No.FUN-680098 SMALLINT
    p_row,p_col     LIKE type_file.num5                 #No.FUN-680098 SMALLINT
 
DEFINE g_before_input_done   STRING
DEFINE g_forupd_sql          STRING 
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680098  INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680098   VARCHAR(72)
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0073
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
 
 
   LET p_row = 3 LET p_col = 16
   OPEN WINDOW i111_w AT p_row,p_col
     WITH FORM "agl/42f/agli111"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   LET g_wc = '1=1'
 
   CALL i111_b_fill(g_wc)
 
   CALL i111_menu()
 
   CLOSE WINDOW i111_w                    #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION i111_menu()
DEFINE l_cmd  LIKE type_file.chr1000
   WHILE TRUE
      CALL i111_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i111_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i111_b()
             ELSE
                LET g_action_choice = NULL
             END IF
         WHEN "output"
            IF cl_chk_act_auth()                                                   
               THEN CALL i111_out()                                            
            END IF                                                                 
 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
             IF cl_chk_act_auth() AND l_ac != 0 THEN   #No.MOD-560148
               IF g_aae[l_ac].aae01 IS NOT NULL THEN
                  LET g_doc.column1 = "aae01"
                  LET g_doc.value1 = g_aae[l_ac].aae01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aae),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i111_q()
 
   CALL i111_b_askkey()
 
END FUNCTION
 
FUNCTION i111_b()
DEFINE l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT #No.FUN-680098 SMALLINT
       l_n             LIKE type_file.num5,   #檢查重複用        #No.FUN-680098 SMALLINT
       l_lock_sw       LIKE type_file.chr1,   #單身鎖住          #No.FUN-680098 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,   #處理狀態          #No.FUN-680098 VARCHAR(1)
       aae08_t         LIKE aab_file.aab01,   #                  #No.FUN-680098 VARCHAR(24)   
       l_allow_insert  LIKE type_file.chr1,   #可新增否          #No.FUN-680098 VARCHAR(1)   
       l_allow_delete  LIKE type_file.chr1    #可刪除否          #No.FUN-680098 VARCHAR(1)  
DEFINE li_flag         LIKE type_file.num5    #No.FUN-680098    SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT aae01,aae02,aae03,aaeacti FROM aae_file ",
                      "WHERE aae01= ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i111_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   INPUT ARRAY g_aae WITHOUT DEFAULTS FROM s_aae.*
      ATTRIBUTE (COUNT = g_rec_b,MAXCOUNT = g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW =l_allow_delete,APPEND ROW=l_allow_insert)
 
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
#No.FUN-570108 --start--
            LET p_cmd='u'
            LET  g_before_input_done = FALSE
            CALL i111_set_entry(p_cmd)
            CALL i111_set_no_entry(p_cmd)
            LET  g_before_input_done = TRUE
#No.FUN-570108 --end--
            BEGIN WORK
            LET p_cmd='u'
            LET g_aae_t.* = g_aae[l_ac].*  #BACKUP
            OPEN i111_bcl USING g_aae_t.aae01
            IF STATUS THEN
               CALL cl_err("OPEN i111_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH i111_bcl INTO g_aae[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_aae_t.aae01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570108 --start--
         LET  g_before_input_done = FALSE
         CALL i111_set_entry(p_cmd)
         CALL i111_set_no_entry(p_cmd)
         LET  g_before_input_done = TRUE
#No.FUN-570108 --end--
         INITIALIZE g_aae[l_ac].* TO NULL
         LET g_aae[l_ac].aaeacti = 'Y'         #Body default
         LET g_aae_t.* = g_aae[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD aae01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            CLOSE i111_bcl
         END IF
         INSERT INTO aae_file(aae01,aae02,aae03,
                              aaeacti,aaeuser,aaegrup,aaedate,aaeoriu,aaeorig)
         VALUES(g_aae[l_ac].aae01,g_aae[l_ac].aae02,g_aae[l_ac].aae03,
                g_aae[l_ac].aaeacti,g_user,g_grup,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_aae[l_ac].aae01,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("ins","aae_file",g_aae[l_ac].aae01,g_aae[l_ac].aae02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD aae01
         IF NOT cl_null(g_aae[l_ac].aae01) THEN
            IF g_aae[l_ac].aae01 != g_aae_t.aae01 OR g_aae_t.aae01 IS NULL THEN    #TQC-C80146  add   OR g_aae_t.aae01 IS NULL
               SELECT count(*) INTO l_n FROM aae_file
                WHERE aae01 = g_aae[l_ac].aae01
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_aae[l_ac].aae01,-239,0)
                  LET g_aae[l_ac].aae01 = g_aae_t.aae01
                  NEXT FIELD aae01
               END IF
            END IF
         END IF
 
      AFTER FIELD aaeacti
         IF NOT cl_null(g_aae[l_ac].aaeacti) THEN
            IF g_aae[l_ac].aaeacti NOT MATCHES '[YN]' THEN
               LET g_aae[l_ac].aaeacti = g_aae_t.aaeacti
               NEXT FIELD aaeacti
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_aae_t.aae01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
            LET g_doc.column1 = "aae01"               #No.FUN-9B0098 10/02/24
            LET g_doc.value1 = g_aae[l_ac].aae01      #No.FUN-9B0098 10/02/24
            CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
 
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
 
            DELETE FROM aae_file WHERE aae01 = g_aae_t.aae01
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_aae_t.aae01,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("del","aae_file",g_aae_t.aae01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
               EXIT INPUT
            END IF
 
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_aae[l_ac].* = g_aae_t.*
            CLOSE i111_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_aae[l_ac].aae01,-263,0)
            LET g_aae[l_ac].* = g_aae_t.*
         ELSE
            UPDATE aae_file SET aae01 = g_aae[l_ac].aae01,
                                aae02 = g_aae[l_ac].aae02,
                                aae03 = g_aae[l_ac].aae03,
                                aaeacti=g_aae[l_ac].aaeacti,
                                aaemodu=g_user,
                                aaedate=g_today
             WHERE aae01 = g_aae_t.aae01
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_aae[l_ac].aae01,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("upd","aae_file",g_aae_t.aae01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
               LET g_aae[l_ac].* = g_aae_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()         # 新增
        #LET l_ac_t = l_ac  #FUN-D30032 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_aae[l_ac].* = g_aae_t.*
            #FUN-D30032--add--begin--
            ELSE
               CALL g_aae.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end----
            END IF
            CLOSE i111_bcl            # 新增
            ROLLBACK WORK         # 新增
            EXIT INPUT
         END IF
         LET l_ac_t =l_ac
         CLOSE i111_bcl
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
             LET g_aae[l_ac].* = g_aae[l_ac-1].*
         END IF
 
      ON ACTION controlf
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
   END INPUT
 
   CLOSE i111_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i111_b_askkey()
 
   CLEAR FORM
   CALL g_aae.clear()
   CALL cl_opmsg('q')
 
   CONSTRUCT g_wc ON aae01,aae02,aae03,aaeacti
        FROM s_aae[1].aae01,s_aae[1].aae02,s_aae[1].aae03,s_aae[1].aaeacti
 
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
 
#No.TQC-710076 -- begin --
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0
#      RETURN
#   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND aaeuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND aaegrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND aaegrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('aaeuser', 'aaegrup')
   #End:FUN-980030
 
 
   CALL cl_opmsg('b')
 
   CALL i111_b_fill(g_wc)
 
END FUNCTION
 
FUNCTION i111_b_fill(p_wc2)       #BODY FILL UP
#DEFINE p_wc2      VARCHAR(200) 
DEFINE p_wc2       STRING        #TQC-630166    
 
   LET g_sql = "SELECT aae01,aae02,aae03,aaeacti ",
               " FROM aae_file",
               " WHERE ", p_wc2 CLIPPED,            #單身
               " ORDER BY aae01"
 
   PREPARE i111_pb FROM g_sql
   DECLARE aae_curs CURSOR FOR i111_pb
 
   CALL g_aae.clear()
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH aae_curs INTO g_aae[g_cnt].*   #單身 ARRAY 填充
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   LET l_ac = 1
   CALL g_aae.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i111_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aae TO s_aae.* ATTRIBUTE(COUNT=g_rec_b)
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
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
#No.FUN-820002--start--
FUNCTION i111_out()
#  DEFINE l_i             LIKE type_file.num5,          #No.FUN-680098  SMALLINT
#         l_name          LIKE type_file.chr20,         # External(Disk) file name    #No.FUN-680098 VARCHAR(20)
#         l_aae   RECORD LIKE aae_file.*,
#         l_chr           LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
   DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-820002 
   IF g_wc IS NULL THEN                                                                                                      
      CALL cl_err('','9057',0)                                                                                               
      RETURN                                                                                                                 
   END IF                                                                                                                    
   LET l_cmd = 'p_query "agli111" "',g_wc CLIPPED,'"'                                                                        
   CALL cl_cmdrun(l_cmd)                                                                                                     
   RETURN 
#  IF g_wc IS NULL THEN
#     CALL cl_err('','9057',0)
#     RETURN
#  END IF
 
#  CALL cl_wait()
#  CALL cl_outnam('agli111') RETURNING l_name
#  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#
#  LET g_sql="SELECT * FROM aae_file ",          # 組合出 SQL 指令
#            " WHERE ",g_wc CLIPPED
#  PREPARE i111_p1 FROM g_sql                # RUNTIME 編譯
#  DECLARE i111_co CURSOR FOR i111_p1
 
#  START REPORT i111_rep TO l_name
 
#  FOREACH i111_co INTO l_aae.*
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('Foreach:',SQLCA.sqlcode,1)  
#        EXIT FOREACH
#     END IF
 
#     OUTPUT TO REPORT i111_rep(l_aae.*)
 
#  END FOREACH
 
#  FINISH REPORT i111_rep
 
#  CLOSE i111_co
#  CALL cl_prt(l_name,' ','1',g_len)
#  MESSAGE ""
 
END FUNCTION
 
#REPORT i111_rep(sr)
#  DEFINE l_trailer_sw     LIKE type_file.chr1,         #No.FUN-680098    VARCHAR(1)
#          sr RECORD LIKE aae_file.*,
#          l_chr           LIKE type_file.chr1          #No.FUN-680098   VARCHAR(1)
#  DEFINE l_aae01          LIKE type_file.chr6          #No.TQC-750186
 
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
#  ORDER BY sr.aae01
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<',"/pageno"
#        PRINT g_head CLIPPED,pageno_total
#        PRINT
#        PRINT g_dash[1,g_len]
#        PRINT g_x[31],g_x[32],g_x[33]
#        PRINT g_dash1
#        LET l_trailer_sw = 'y'
 
#     ON EVERY ROW
#        IF sr.aaeacti = 'N' THEN
#No.TQC-750186 --start--
#           LET sr.aae01 = '*',sr.aae01
#        END IF
#           LET l_aae01 = '*',sr.aae01
#           PRINT COLUMN g_c[31],l_aae01,
#                 COLUMN g_c[32],sr.aae02,
#                 COLUMN g_c[33],sr.aae03
#        ELSE
#No.TQC-750186 --end--
#           PRINT COLUMN g_c[31],sr.aae01,
#                 COLUMN g_c[32],sr.aae02,
#                 COLUMN g_c[33],sr.aae03
#        END IF   #No.TQC-750186
 
#     ON LAST ROW
#        IF g_zz05 = 'Y' THEN          # 80:70,140,210      132:120,240
#           PRINT g_dash[1,g_len]
#           #TQC-630166
#           #IF g_wc[001,080] > ' ' THEN
#           #   PRINT COLUMN g_c[31],g_x[8] CLIPPED,
#           #         COLUMN g_c[32],g_wc[001,070] CLIPPED
#           #END IF
#           #IF g_wc[071,140] > ' ' THEN
#           #   PRINT COLUMN g_c[32],g_wc[071,140] CLIPPED
#           #END IF
#           #IF g_wc[141,210] > ' ' THEN
#           #   PRINT COLUMN g_c[32],g_wc[141,210] CLIPPED
#           #END IF
#           CALL cl_prt_pos_wc(g_wc)
#        END IF
#        PRINT g_dash[1,g_len]
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#        LET l_trailer_sw = 'n'
 
#     PAGE TRAILER
#        IF l_trailer_sw = 'y' THEN
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#        ELSE
#           SKIP 2 LINE
#        END IF
 
#END REPORT
#No.FUN-820002--end--
 
#No.FUN-570108 --start--
 
FUNCTION i111_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("aae01",TRUE)
   END IF
END FUNCTION
 
 
FUNCTION i111_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
      CALL cl_set_comp_entry("aae01",FALSE)
   END IF
END FUNCTION
 
#No.FUN-570108 --end--
 
