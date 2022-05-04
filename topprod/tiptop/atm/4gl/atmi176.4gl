# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmi176.4gl
# Descriptions...: 車輛型號維護作業
# Date & Author..: 03/12/02 By Leagh
# Modify.........: No.MOD-4B0067 04/11/08 By Elva 將變數用Like方式定義,調整報表
# Modify.........: No.FUN-520024 05/02/24 By Day 報表轉XML
# Modify.........: No.MOD-540145 05/05/10 By vivien 刪除HELP FILE   
# Modify.........: No.FUN-650065 06/05/31 By Tracy axd模塊轉atm模塊   
# Modify.........: No.TQC-660029 06/06/07 By Mandy Informix r.c2 不過 因為TQC-630166 用{}mark 改用#
# Modify.........: NO.FUN-660104 06/06/15 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: Mo.FUN-6A0072 06/10/24 By xumin g_no_ask改g_no_ask    
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/10 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0043 06/11/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-780056 07/07/17 By mike 報表格式修改為p_query
# Modify.........: No.TQC-8C0076 09/01/09 By clover mark #ATTRIBUTE(YELLOW),ATTRIBUTE(GREEN)
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30033 13/04/09 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
        g_obt01         LIKE obt_file.obt01,   #車輛廠牌
        g_obt01_t       LIKE obt_file.obt01,   #車輛廠牌舊值
        g_obt           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                        obt02       LIKE obt_file.obt02,   #車輛型號
                        obt03       LIKE obt_file.obt03   #說明
                        END RECORD,
        g_obt_t         RECORD                 #程式變數 (舊值)
                        obt02       LIKE obt_file.obt02,   #車輛型號
                        obt03       LIKE obt_file.obt03   #說明
                        END RECORD,
        g_obs02         LIKE obs_file.obs02,
        l_flag          LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
        g_delete        LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
        g_wc,g_sql      STRING,#TQC-630166
        g_rec_b         LIKE type_file.num5,          #單身筆數                 #No.FUN-680120 SMALLINT
        l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT      #No.FUN-680120 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5       #No.FUN-680120 SMALLINT
DEFINE g_cnt            LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_i              LIKE type_file.num5     #count/index for any purpose    #No.FUN-680120 SMALLINT
DEFINE g_msg            LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE g_row_count      LIKE type_file.num10                                     #No.FUN-680120 INTEGER
DEFINE g_curs_index     LIKE type_file.num10          #No.FUN-680120 INTEGER
DEFINE g_jump           LIKE type_file.num10                                     #No.FUN-680120 INTEGER
DEFINE g_no_ask         LIKE type_file.num5           #No.FUN-680120 SMALLINT    #No.FUN-6A0072
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("ATM")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
    INITIALIZE g_obt_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM obt_file WHERE obt01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i176_crl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    OPEN WINDOW i176_w WITH FORM "atm/42f/atmi176"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL g_x.clear()
    CALL i176_menu()    #中文
    CLOSE WINDOW i176_w
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
 
#QBE 查詢資料
FUNCTION i176_cs()
    CLEAR FORM                             #清除畫面
    CALL g_obt.clear()                            #清除畫面
    
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031 
   INITIALIZE g_obt01 TO NULL    #No.FUN-750051
   CONSTRUCT g_wc ON obt01,obt02,obt03  #螢幕上取條件
                 FROM obt01,s_obt[1].obt02,s_obt[1].obt03
 
    #No.FUN-580031 --start--     HCN
    BEFORE CONSTRUCT
       CALL cl_qbe_init()
    #No.FUN-580031 --end--       HCN
 
    ON ACTION controlp
       CASE
         WHEN INFIELD(obt01)
          CALL cl_init_qry_var()       
          LET g_qryparam.state ="c"
          LET g_qryparam.form ="q_obs"
          CALL cl_create_qry() RETURNING g_qryparam.multiret
          DISPLAY g_qryparam.multiret TO obt01
          NEXT FIELD obt01
       END CASE
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
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    IF INT_FLAG THEN  RETURN END IF
LET g_sql= "SELECT DISTINCT obt01 FROM obt_file ",                          
               " WHERE ", g_wc CLIPPED,                                         
               " ORDER BY obt01"
    PREPARE i176_prepare FROM g_sql      #預備一下
    DECLARE i176_b_cs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i176_prepare
 
#因主鍵值有兩個故所抓出資料筆數有誤
    LET g_sql="SELECT COUNT(UNIQUE obt01) ",
              " FROM obt_file WHERE ", g_wc CLIPPED
    PREPARE i176_pre_count FROM g_sql
    DECLARE i176_count CURSOR FOR i176_pre_count
    OPEN i176_count                                                            
    FETCH i176_count INTO g_row_count                                          
    CLOSE i176_count
 
END FUNCTION
 
#中文的MENU
FUNCTION i176_menu()
 DEFINE   l_cmd   STRING    #No.FUN-780056
   WHILE TRUE
      CALL i176_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i176_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i176_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i176_r()
            END IF
         WHEN "reproduce"
          IF cl_chk_act_auth() THEN
               CALL i176_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i176_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               #CALL i176_out()                                     #No.FUN-780056
               IF cl_null(g_wc) THEN LET g_wc='1=1' END IF        #No.FUN-780056
               LET l_cmd='p_query "atmi176" "',g_wc CLIPPED,'"'    #No.FUN-780056
               CALL cl_cmdrun(l_cmd)                                #No.FUN-780056
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #No.FUN-6B0043-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_obt01 IS NOT NULL THEN
                 LET g_doc.column1 = "obt01"
                 LET g_doc.value1 = g_obt01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0043-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i176_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_obt.clear()
    INITIALIZE g_obt01 LIKE  obt_file.obt01
    LET g_obt01_t  = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i176_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET g_obt01=NULL
            DISPLAY g_obt01 TO obt01
            CLEAR FORM
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_rec_b=0
        CALL i176_b()                   #輸入單身
        LET g_obt01_t = g_obt01
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i176_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #a:輸入 u:更改        #No.FUN-680120 VARCHAR(1)
    l_n             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
    l_str           LIKE ima_file.ima01,          #No.FUN-680120 VARCHAR(40)
    l_obs01         LIKE obs_file.obs01
 
     CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
     INPUT g_obt01 WITHOUT DEFAULTS FROM obt01 HELP 1
 
        AFTER FIELD obt01    
            IF NOT cl_null(g_obt01) THEN 
               SELECT obs01 INTO l_obs01 FROM obs_file WHERE obs01=g_obt01
               IF SQLCA.sqlcode THEN           
#                 CALL cl_err('',SQLCA.sqlcode,0)  #No.FUN-660104
                  CALL cl_err3("sel","obs_file",g_obt01,"",SQLCA.sqlcode,
                               "","",1)  #No.FUN-660104
                  NEXT FIELD obt01
               ELSE 
                   SELECT COUNT(*) INTO l_n FROM obt_file WHERE obt01 = g_obt01
                   IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      NEXT FIELD obt01 
                   END IF
               END IF
               SELECT obs02 INTO g_obs02 FROM obs_file WHERE obs01 = g_obt01
               IF SQLCA.sqlcode THEN           
#                 CALL cl_err('',SQLCA.sqlcode,0)  #No.FUN-660104
                  CALL cl_err3("sel","obs_file",g_obt01,"",SQLCA.sqlcode,
                               "","",1)  #No.FUN-660104
 
                  NEXT FIELD obt01
               ELSE 
                  DISPLAY g_obs02 TO obs02 
               END IF
            END IF
 
        ON ACTION CONTROLP
            CASE
            WHEN INFIELD(obt01) 
                  CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_obs"
                   LET g_qryparam.default1 = g_obt01
                   CALL cl_create_qry() RETURNING g_obt01 
                   DISPLAY g_obt01 TO obt01
                   NEXT FIELD obt01        
            END CASE
 
        ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
       ON IDLE g_idle_seconds                                                   
          CALL cl_on_idle()                                                     
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    END INPUT
END FUNCTION
 
 
#Query 查詢
FUNCTION i176_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_obt01 TO NULL               #No.FUN-6B0043
 
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_obt.clear()
    DISPLAY '   ' TO FORMONLY.cnt
 
    CALL i176_cs()                    #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_obt01 TO NULL
        RETURN
    END IF
    OPEN i176_count
    FETCH i176_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i176_b_cs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_obt01 TO NULL
    ELSE
        CALL i176_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i176_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680120 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i176_b_cs INTO g_obt01
        WHEN 'P' FETCH PREVIOUS i176_b_cs INTO g_obt01
        WHEN 'F' FETCH FIRST    i176_b_cs INTO g_obt01
        WHEN 'L' FETCH LAST     i176_b_cs INTO g_obt01
        WHEN '/' 
         IF (NOT g_no_ask) THEN   #No.FUN-6A0072
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
             END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF 
         FETCH ABSOLUTE g_jump i176_b_cs INTO g_obt01
         LET g_no_ask = FALSE   #No.FUN-6A0072
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_obt01,SQLCA.sqlcode,0)
        INITIALIZE g_obt01 TO NULL  #TQC-6B0105
    ELSE
        CASE p_flag                                                              
         WHEN 'F' LET g_curs_index = 1                                        
         WHEN 'P' LET g_curs_index = g_curs_index - 1                        
         WHEN 'N' LET g_curs_index = g_curs_index + 1                        
         WHEN 'L' LET g_curs_index = g_row_count                             
         WHEN '/' LET g_curs_index = g_jump                                   
       END CASE                                                                 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    CALL i176_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i176_show()
    DISPLAY g_obt01 TO obt01               #單頭
    SELECT obs02 INTO g_obs02 FROM obs_file WHERE obs01 = g_obt01
    IF SQLCA.sqlcode THEN LET g_obs02 = NULL END IF
    DISPLAY g_obs02 TO obs02
    CALL i176_b_fill(g_wc)              #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i176_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_obt01 IS NULL THEN 
       CALL cl_err("",-400,0)                 #No.FUN-6B0043
       RETURN END IF
    BEGIN WORK
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "obt01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_obt01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM obt_file WHERE obt01 = g_obt01 
        IF SQLCA.sqlcode THEN
#           CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660104
            CALL cl_err3("del","obt_file",g_obt01,"",SQLCA.sqlcode,
                          "","BODY DELETE",1)  #No.FUN-660104
        ELSE
            CLEAR FORM
            LET g_obt01 = NULL
            CALL g_obt.clear()
            LET g_cnt=STATUS
            LET g_delete = 'Y'
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i176_count                                   
            #FUN-B50064-add-start--
            IF STATUS THEN
               CLOSE I176_b_cs
               CLOSE i176_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50064-add-end--
            FETCH i176_count INTO g_row_count                       
            #FUN-B50064-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i176_b_cs
               CLOSE i176_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50064-add-end-- 
            DISPLAY g_row_count TO FORMONLY.cnt                     
            OPEN i176_b_cs                                            
            IF g_curs_index = g_row_count + 1 THEN                  
               LET g_jump = g_row_count                             
               CALL i176_fetch('L')                                 
            ELSE                                                    
               LET g_jump = g_curs_index                            
               LET g_no_ask = TRUE     #No.FUN-6A0072                             
               CALL i176_fetch('/')                                 
            END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i176_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
    l_no            LIKE type_file.num5,                #No.FUN-680120 SMALLINT             #檢查重複用
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否      #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680120 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                 #可新增否        #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5,                 #可刪除否        #No.FUN-680120 SMALLINT
    l_str           LIKE bnb_file.bnb06                  #No.FUN-680120 VARCHAR(20)              #
    LET g_action_choice = ""
 
    CALL cl_opmsg('b')
    LET g_forupd_sql = "SELECT obt02,obt03 FROM obt_file ",
                       " WHERE obt01 =? AND obt02 =? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i176_b_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
   
        INPUT ARRAY g_obt WITHOUT DEFAULTS
            FROM s_obt.* ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
    BEFORE INPUT
            IF g_rec_b != 0  THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
    BEFORE ROW
            LET p_cmd=' '
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            IF g_rec_b >=l_ac THEN
               BEGIN WORK       
               LET p_cmd='u'
               LET g_obt_t.* = g_obt[l_ac].*  #BACKUP
               OPEN i176_b_cl USING g_obt01,g_obt_t.obt02             #表示更改狀態
               IF STATUS THEN
                  CALL cl_err("OPEN i176_b_cl:",STATUS,1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i176_b_cl INTO g_obt[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_obt_t.obt02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     LET g_obt_t.*=g_obt[l_ac].*
                  END IF
               END IF       
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
    BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_obt[l_ac].* TO NULL      #900423
            LET g_obt_t.* = g_obt[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD obt02
 
        AFTER FIELD obt02                 
            IF NOT cl_null(g_obt[l_ac].obt02) AND
               (g_obt[l_ac].obt02 != g_obt_t.obt02 OR
                g_obt_t.obt02 IS NULL) THEN
                LET l_no=0
                SELECT count(*) INTO l_no FROM obt_file
                 WHERE obt01 = g_obt01
                   AND obt02 = g_obt[l_ac].obt02
                IF l_no > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_obt[l_ac].obt02 = g_obt_t.obt02
                    NEXT FIELD obt02
                END IF
            END IF
    AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO obt_file(obt01,obt02,obt03)
                          VALUES(g_obt01,
                                 g_obt[l_ac].obt02,g_obt[l_ac].obt03)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_obt[l_ac].obt02,SQLCA.sqlcode,0)  #No.FUN-660104
               CALL cl_err3("ins","obt_file",g_obt[l_ac].obt02,"",
                             SQLCA.sqlcode,"","",1)  #No.FUN-660104
               CANCEL INSERT 
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b = g_rec_b + 1
            END IF
 
  
        BEFORE DELETE                            #是否取消單身
            IF g_obt_t.obt02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM obt_file
                 WHERE obt01 = g_obt01 AND obt02 = g_obt_t.obt02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_obt_t.obt02,SQLCA.sqlcode,0)  #No.FUN-660104
                    CALL cl_err3("del","obt_file",g_obt_t.obt02,"",
                                  SQLCA.sqlcode,"","",1)  #No.FUN-660104
                    ROLLBACK WORK
                    CANCEL DELETE 
                END IF
                LET g_rec_b=g_rec_b-1
                MESSAGE "Delete Ok"
            END IF 
            COMMIT WORK  
 
 
    ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_obt[l_ac].* = g_obt_t.*
               CLOSE i176_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_obt[l_ac].obt02,-263,1)
               LET g_obt[l_ac].* = g_obt_t.*
            ELSE
               UPDATE obt_file SET obt01=g_obt01,
                                   obt02=g_obt[l_ac].obt02,
                                   obt03=g_obt[l_ac].obt03
                  WHERE obt01 = g_obt01 
                  AND obt02 = g_obt_t.obt02
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_obt[l_ac].obt02,SQLCA.sqlcode,0)  #No.FUN-660104
                 CALL cl_err3("upd","obt_file",g_obt[l_ac].obt02,"",
                               SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 LET g_obt[l_ac].* = g_obt_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF
 
         AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30033 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_obt[l_ac].* = g_obt_t.*
               #FUN-D30033--add--begin--
               ELSE
                  CALL g_obt.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30033--add--end----
               END IF
               CLOSE i176_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30033 add
            CLOSE i176_b_cl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(obt02) AND l_ac > 1 THEN
               LET g_obt[l_ac].* = g_obt[l_ac-1].*
               NEXT FIELD obp02
            END IF
 
        ON ACTION CONTROLN
            CALL i176_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
        ON IDLE g_idle_seconds                                                  
          CALL cl_on_idle()                                                     
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 #NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END  
    END INPUT
 
    CLOSE i176_b_cl
    COMMIT WORK
END FUNCTION
   
FUNCTION i176_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    CONSTRUCT l_wc ON obt02,obt03    #螢幕上取條件
                 FROM s_obt[1].obt02,s_obt[1].obt03
 
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
    IF INT_FLAG THEN RETURN END IF
    CALL i176_b_fill(l_wc)
END FUNCTION
 
FUNCTION i176_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
    
LET g_sql = "SELECT obt02,obt03,''",                                        
                "  FROM obt_file ",                                             
                " WHERE obt01 = '",g_obt01,"' AND ", p_wc CLIPPED,              
                " ORDER BY obt02"
    PREPARE i176_prepare2 FROM g_sql      #預備一下
    DECLARE obt_cs CURSOR FOR i176_prepare2
    CALL g_obt.clear()
    LET g_cnt = 1
    LET g_rec_b=0
 
    FOREACH obt_cs INTO g_obt[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        LET g_cnt=g_cnt+1
    END FOREACH
    CALL g_obt.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i176_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_obt TO s_obt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END        
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first 
         CALL i176_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i176_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION jump 
         CALL i176_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION next
         CALL i176_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION last 
         CALL i176_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
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
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6B0043  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i176_copy()
DEFINE l_newno1,l_oldno1  LIKE obt_file.obt01,
       l_obs02            LIKE obs_file.obs02,
       l_n                LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_obt01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    DISPLAY ' ' TO obs02 #ATTRIBUTE(GREEN)    #TQC-8C0076
 
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
 
    INPUT l_newno1 FROM obt01
        AFTER FIELD obt01 
            IF cl_null(l_newno1) THEN NEXT FIELD obt01 END IF
            SELECT COUNT(*) INTO l_n FROM obt_file WHERE obt01=l_newno1 
            IF l_n > 0 THEN 
               CALL cl_err(l_newno1,-239,0) NEXT FIELD obt01
            END IF
            SELECT obs02 INTO l_obs02 FROM obs_file WHERE obs01=l_newno1 
            IF SQLCA.sqlcode THEN 
#              CALL cl_err(l_obs02,STATUS,0) NEXT FIELD obt01  #No.FUN-660104
               CALL cl_err3("sel","obs_file",l_newno1,"",STATUS,"","",1)  NEXT FIELD obt01   #No.FUN-660104
            END IF
            DISPLAY l_obs02 TO obs02 
  
        ON ACTION CONTROLP
            CASE
            WHEN INFIELD(obt01) 
                  CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_obs"
              #    LET g_qryparam.default1 = g_obt01
                   CALL cl_create_qry() RETURNING l_newno1 
                   DISPLAY BY NAME l_newno1 
                   NEXT FIELD obt01        
            END CASE
          ON IDLE g_idle_seconds                              
             CALL cl_on_idle()           
             CONTINUE INPUT 
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    END INPUT
    IF INT_FLAG THEN 
        LET INT_FLAG = 0 DISPLAY  g_obt01 TO obt01  #ATTRIBUTE(YELLOW) #TQC-8C0076
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM obt_file         #單身複製
        WHERE g_obt01=obt01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
       LET g_msg = g_obt01 CLIPPED
#      CALL cl_err(g_msg,SQLCA.sqlcode,0)  #No.FUN-660104
       CALL cl_err3("ins","x",g_msg,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       RETURN
    END IF
    UPDATE x SET obt01 = l_newno1 
    INSERT INTO obt_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
       LET g_msg = l_newno1 CLIPPED
#      CALL cl_err(g_msg,SQLCA.sqlcode,0)  #No.FUN-660104
       CALL cl_err3("ins","obt_file",g_msg,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       RETURN
    END IF
    LET l_oldno1= g_obt01
    LET g_obt01=l_newno1
    CALL i176_b()
    #LET g_obt01=l_oldno1  #FUN-C80046
    #CALL i176_show()      #FUN-C80046
END FUNCTION
 
#No.FUN-780056 -str
{
FUNCTION i176_out()
DEFINE
    l_i             LIKE type_file.num5,            #No.FUN-680120 SMALLINT
    sr              RECORD LIKE obt_file.*,
    l_name          LIKE type_file.chr20,           #No.FUN-680120 VARCHAR(20)            #External(Disk) file name
     l_za05          LIKE za_file.za05      #MOD-4B0067
 
   
    IF cl_null(g_wc) AND NOT cl_null(g_obt01)AND NOT cl_null(g_obt[l_ac].obt02) THEN                          
       LET g_wc = " obt01 = '",g_obt01,"' AND obt02 = '",g_obt[l_ac].obt02,"'"                                  
    END IF  
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('atmi176') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * ",
              "  FROM obt_file ",  # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED,
              " ORDER BY 1 "
    PREPARE i176_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i176_co                         # CURSOR
        CURSOR FOR i176_p1
 
    START REPORT i176_rep TO l_name
 
    FOREACH i176_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT i176_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i176_rep
 
    CLOSE i176_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
}
#No.FUN-780056 -end
 
#No.FUN-780056 -str
#REPORT i176_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
#    sr              RECORD LIKE obt_file.*
#
#    OUTPUT
#       TOP MARGIN g_top_margin 
#       LEFT MARGIN g_left_margin 
#       BOTTOM MARGIN g_bottom_margin 
#       PAGE LENGTH g_page_line
#    ORDER BY sr.obt01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#
#            LET g_pageno = g_pageno + 1
#            LET pageno_total = PAGENO USING '<<<',"/pageno" 
#            PRINT g_head CLIPPED,pageno_total     
#
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#            PRINT
#            PRINT g_dash[1,g_len]
#
#            PRINT g_x[31],g_x[32],g_x[33]
#            PRINT g_dash1 
#            LET l_trailer_sw = 'y'
#
#        ON EVERY ROW
#            PRINT COLUMN g_c[31],sr.obt01,
#                  COLUMN g_c[32],sr.obt02,
#                  COLUMN g_c[33],sr.obt03
#
#        ON LAST ROW
#            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
#               PRINT g_dash[1,g_len]
#            #TQC-630166
#           #TQC-660029 
#           #{
#        #   IF g_sql[001,080] > ' ' THEN
#	   #           PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
#           #   IF g_sql[071,140] > ' ' THEN
#	   #           PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
#           #   IF g_sql[141,210] > ' ' THEN
#	   #           PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
#           #}
#              CALL cl_prt_pos_wc(g_sql)
#            #END TQC-630166
#            END IF
#            PRINT g_dash[1,g_len]
#            LET l_trailer_sw = 'n'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-780056 -end
