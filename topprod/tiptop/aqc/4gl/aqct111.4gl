# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aqct111.4gl
# Descriptions...: 品管記錄不良原因維護
# Date & Author..: 00/04/08 By Melody
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0038 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-530865 05/03/30 By Smapmin 將VARCHAR轉為CHAR
# Modify.........: No.MOD-530688 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.MOD-5C0056 05/12/12 By Pengu 外部參數g_argv1放大為CHAR(16)
# Modify.........: No.FUN-660115 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-780042 07/08/15 By jamie 修改時出現-201的錯誤，將FOR UPDATE ->FOR UPDATE
# Modify.........: No.FUN-7B0027 08/01/21 By xiaofeizhu 單身新增qcuicd01,qcuicd02,icd03三個欄位
# Modify.........: No.FUN-830068 08/03/20 By xiaofeizhu 加入相關文件功能
# Modify.........: No.FUN-830131 08/04/01 By mike 新增ICD架構
# Modify.........: No.TQC-840007 08/04/02 By mike 單身欄位與for_upd_sql不對應
# Modify.........: No.TQC-8C0052 09/01/15 By kim icd欄位寫錯
# Modify.........: No.FUN-980007 09/08/13 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    #g_argv1        VARCHAR(10),                    #專案代號   # No.MOD-5C0056 mark
    g_argv1         LIKE qcu_file.qcu01,         #No.FUN-680104 VARCHAR(16) #專案代號    # No.MOD-5C0056 add
    g_argv2         LIKE type_file.num5,         #No.FUN-680104 SMALLINT #項次
    g_argv3         LIKE type_file.num5,         #No.FUN-680104 SMALLINT #項次
    g_argv4         LIKE type_file.num5,         #No.FUN-680104 SMALLINT #項次
    g_qcu01         LIKE qcu_file.qcu01,   #假單頭
    g_qcu02         LIKE qcu_file.qcu02,   #假單頭
    g_qcu021        LIKE qcu_file.qcu021,  #假單頭
    g_qcu01_t       LIKE qcu_file.qcu01,   #假單頭
    g_qcu02_t       LIKE qcu_file.qcu02,   #假單頭
    g_qcu021_t      LIKE qcu_file.qcu021,  #假單頭
    g_qcu           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        qcu03       LIKE qcu_file.qcu03,
        item        LIKE qct_file.qct04,       #No.FUN-680104 VARCHAR(10)
        azf03       LIKE azf_file.azf03,       #No.FUN-680104 VARCHAR(10)
        qcuicd01    LIKE qcu_file.qcuicd01,    #No.TQC-840007
        qcuicd02    LIKE qcu_file.qcuicd02,    #No.TQC-840007
        icd03       LIKE icd_file.icd03,       #No.TQC-840007
        qcu04       LIKE qcu_file.qcu04,
        qce03       LIKE qce_file.qce03,
        qcu05       LIKE qcu_file.qcu05
        #qcuicd01    LIKE qcu_file.qcuicd01,    #No.FUN-7B0027   #No.TQC-840007                                                                    
        #qcuicd02    LIKE qcu_file.qcuicd02,    #No.FUN-7B0027   #No.TQC-840007                                                                    
        #icd03       LIKE icd_file.icd03        #No.FUN-7B0027   #No.TQC-840007
                    END RECORD,
    g_qcu_t         RECORD                     #程式變數 (舊值)
        qcu03       LIKE qcu_file.qcu03,
        item        LIKE qct_file.qct04,       #No.FUN-680104 VARCHAR(10)
        azf03       LIKE azf_file.azf03,       #No.FUN-680104 VARCHAR(10)
        qcuicd01    LIKE qcu_file.qcuicd01,    #No.TQC-840007                                                                       
        qcuicd02    LIKE qcu_file.qcuicd02,    #No.TQC-840007                                                                       
        icd03       LIKE icd_file.icd03,       #No.TQC-840007 
        qcu04       LIKE qcu_file.qcu04,
        qce03       LIKE qce_file.qce03,
        qcu05       LIKE qcu_file.qcu05
        #qcuicd01    LIKE qcu_file.qcuicd01,    #No.FUN-7B0027   #No.TQC-840007                                                                     
        #qcuicd02    LIKE qcu_file.qcuicd02,    #No.FUN-7B0027   #No.TQC-840007                                                                    
        #icd03       LIKE icd_file.icd03        #No.FUN-7B0027   #No.TQC-840007
                    END RECORD,
     g_wc2,g_sql    STRING,                 #No.FUN-580092 HCN        #No.FUN-680104
     g_wc           STRING,                 #No.FUN-580092 HCN        #No.FUN-680104
    g_rec_b        LIKE type_file.num5,     #單身筆數                 #No.FUN-680104 SMALLINT
    l_ac           LIKE type_file.num5,     #前處理的ARRAY CNT        #No.FUN-680104 SMALLINT
    g_ss           LIKE type_file.chr1,     #No.FUN-680104 VARCHAR(1)
    l_flag         LIKE type_file.chr1      #No.FUN-680104 VARCHAR(1)
DEFINE p_row,p_col          LIKE type_file.num5          #No.FUN-680104 SMALLINT
DEFINE g_forupd_sql         STRING                       #SELECT ... FOR UPDATE  SQL   #No.FUN-680104
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680104 SMALLINT
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE g_curs_index    LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE g_jump          LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5          #No.FUN-680104 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0085
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
#No.FUN-830131  --BEGIN
#No.FUN-830131  --END
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AQC")) THEN
       EXIT PROGRAM
    END IF
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
    LET g_argv1 = ARG_VAL(1)               #傳遞的參數:專案代號
    LET g_argv2 = ARG_VAL(2)               #傳遞的參數:行序
    LET g_argv3 = ARG_VAL(3)               #傳遞的參數:行序
    LET g_argv4 = ARG_VAL(4)               #傳遞的參數:行序
    LET g_qcu01 = g_argv1
    LET g_qcu02 = g_argv2
    LET g_qcu021= g_argv3
 
    INITIALIZE g_qcu_t.* TO NULL
    LET p_row = 4 LET p_col = 21
 
    OPEN WINDOW t111_w AT p_row,p_col
         WITH FORM "aqc/42f/aqct111"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#    CALL t111_q()
IF NOT cl_null(g_argv1) THEN CALL t111_q() END IF
 
    CALL t111_menu()
 
    CLOSE WINDOW t111_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
 
END MAIN
 
 
#QBE 查詢資料
FUNCTION t111_cs()
 
   IF NOT cl_null(g_argv1) THEN
       LET g_wc =" qcu01= '",g_argv1,"' AND "," qcu02= ",g_argv2,
                 " AND qcu021= '",g_argv3,"' "
       LET g_sql=" SELECT qcu01,qcu02,qcu021 ",
                 " FROM qcu_file ",
                 " WHERE ",g_wc CLIPPED
   ELSE
       CLEAR FORM                             #清除畫面
       CALL g_qcu.clear()
 
       CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_qcu01 TO NULL    #No.FUN-750051
   INITIALIZE g_qcu02 TO NULL    #No.FUN-750051
   INITIALIZE g_qcu021 TO NULL    #No.FUN-750051
#No.FUN-830131  --BEGIN
       #CONSTRUCT g_wc ON qcu01, qcu02, qcu021, qcu03, qcu04, qcu05 
         #FROM qcu01,qcu02,qcu021,s_qcu[1].qcu03,s_qcu[1].qcu04,s_qcu[1].qcu05  
        CONSTRUCT g_wc ON qcu01, qcu02, qcu021, qcu03, qcu04, qcu05   
            FROM qcu01,qcu02,qcu021,s_qcu[1].qcu03,s_qcu[1].qcu04,s_qcu[1].qcu05  
#No.FUN-830131  --END
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
       LET g_sql= "SELECT  UNIQUE qcu01,qcu02,qcu021 FROM qcu_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY 1"
   END IF
 
    PREPARE t111_prepare FROM g_sql      #預備一下
    DECLARE t111_b_cs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR t111_prepare
 
    #因主鍵值有兩個故所抓出資料筆數有誤
    DROP TABLE x
    LET g_sql="SELECT DISTINCT qcu01,qcu02,qcu021 ",
              " FROM qcu_file WHERE ", g_wc CLIPPED," INTO TEMP x"
    PREPARE t111_precount_x  FROM g_sql
    EXECUTE t111_precount_x
    LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE t111_precount FROM g_sql
    DECLARE t111_count CURSOR FOR  t111_precount
 
END FUNCTION
 
FUNCTION t111_menu()
 
   WHILE TRUE
      CALL t111_bp("G")
      CASE g_action_choice
#        WHEN "query"
#           IF cl_chk_act_auth() THEN
#              CALL t111_q()
#           END IF
#        WHEN "detail"
#           IF cl_chk_act_auth() THEN
#              CALL t111_b()
#           ELSE
#              LET g_action_choice = NULL
#           END IF
#        WHEN "help"
#           CALL cl_show_help()
         #No.FUN-830068-------add--------str----                                                                                    
         WHEN "related_document"  #相關文件                                                                                         
            IF cl_chk_act_auth() THEN                                                                                               
               IF g_qcu01 IS NOT NULL THEN                                                                                          
                 LET g_doc.column1 = "qcu01"                                                                                        
                 LET g_doc.value1 = g_qcu01                                                                                         
                 CALL cl_doc()                                                                                                      
               END IF                                                                                                               
           END IF                                                                                                                   
        #No.FUN-830068-------add--------end----
 
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qcu),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t111_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,        #a:輸入 u:更改        #No.FUN-680104 VARCHAR(1)
    l_n             LIKE type_file.num5,        #No.FUN-680104 SMALLINT
    l_str           LIKE cob_file.cob01         #No.FUN-680104 VARCHAR(40)
 
    LET g_ss='Y'
    DISPLAY  g_qcu01 TO qcu01
    DISPLAY  g_qcu02 TO qcu02
    DISPLAY  g_qcu021 TO qcu021
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INPUT BY NAME g_qcu01,g_qcu02,g_qcu021 WITHOUT DEFAULTS
 
        AFTER FIELD qcu01
            IF g_qcu01 != g_qcu01_t OR      #輸入後更改不同時值
               g_qcu01_t IS NULL THEN
                SELECT UNIQUE qcu01 #INTO g_chr
                    FROM qcu_file
                    WHERE qcu01=g_qcu01
                IF SQLCA.sqlcode THEN             #不存在, 新來的
                    IF p_cmd='a' THEN
                        LET g_ss='N'
                    END IF
                ELSE
                    IF p_cmd='u' THEN
                        CALL cl_err(g_qcu01,-239,0)
                        LET g_qcu01=g_qcu01_t
                        NEXT FIELD qcu01
                    END IF
                END IF
             END IF   
 
        ON ACTION CONTROLF                  #欄位說明
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
 
#No.FUN-7B0027--ADD-BEGIN--#
FUNCTION i111_icd03(p_cmd)
   DEFINE     p_cmd        LIKE type_file.chr1,
              l_icd03      LIKE icd_file.icd03
 
      LET g_errno=' '
      SELECT icd03 INTO l_icd03 FROM icd_file
             #WHERE icd03 = qcuicd02     #No.TQC-840007
             WHERE icd01 = g_qcu[l_ac].qcuicd02   #No.TQC-840007
 
   CASE WHEN SQLCA.sqlcode =100   LET g_errno='mfg3008'                                                                             
        OTHERWISE                 LET g_errno= SQLCA.sqlcode USING '--------'                                                       
   END CASE                                                                                                                         
                                                                                                                                    
   IF cl_null(g_errno) OR p_cmd='d' THEN                                                                                            
      DISPLAY l_icd03 TO FORMONLY.icd03
   END IF
END FUNCTION    
#No.FUN-7B0027--ADD-END--#
 
#Query 查詢
FUNCTION t111_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_qcu.clear()
    CALL t111_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_qcu01 TO NULL
        FOR g_cnt = 1 TO g_qcu.getLength()
            LET g_qcu[g_cnt].qcu03 = ' '
        END FOR
        RETURN
    END IF
    OPEN t111_b_cs                         #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                  #有問題
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_qcu01 TO NULL
       INITIALIZE g_qcu02 TO NULL
    ELSE
       OPEN t111_count
       FETCH t111_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL t111_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t111_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,          #處理方式        #No.FUN-680104 VARCHAR(1)
    l_abso          LIKE type_file.num10          #絕對的筆數      #No.FUN-680104 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     t111_b_cs INTO g_qcu01,g_qcu02,g_qcu021
        WHEN 'P' FETCH PREVIOUS t111_b_cs INTO g_qcu01,g_qcu02,g_qcu021
        WHEN 'F' FETCH FIRST    t111_b_cs INTO g_qcu01,g_qcu02,g_qcu021
        WHEN 'L' FETCH LAST     t111_b_cs INTO g_qcu01,g_qcu02,g_qcu021
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            FETCH ABSOLUTE l_abso t111_b_cs INTO g_qcu01,g_qcu02,g_qcu021
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_qcu01,SQLCA.sqlcode,0)
       INITIALIZE g_qcu01  TO NULL  #TQC-6B0105
       INITIALIZE g_qcu02  TO NULL  #TQC-6B0105
       INITIALIZE g_qcu021 TO NULL  #TQC-6B0105
       FOR g_cnt = 1 TO g_qcu.getLength()
           LET g_qcu[g_cnt].qcu03 = ' '
       END FOR
       DISPLAY g_qcu01,g_qcu02,g_qcu021 TO qcu01,qcu02,qcu021        #單頭
    ELSE
       CALL t111_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t111_show()
    DISPLAY g_qcu01,g_qcu02,g_qcu021 TO qcu01,qcu02,qcu021        #單頭
 
    CALL t111_b_fill(' 1=1')                        #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t111_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680104 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用      #No.FUN-680104 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否      #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態        #No.FUN-680104 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680104 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680104 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_qcu01 IS NULL THEN RETURN END IF
    IF g_qcu02 IS NULL THEN RETURN END IF
    IF g_qcu021 IS NULL THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
 
#   LET g_forupd_sql = "SELECT qcu03,qcu04,'',qcu05,'' FROM qcu_file ",           #No.FUN-7B0027
#No.FUN-830131  --BEGIN
   #LET g_forupd_sql = "SELECT qcu03,qcu04,'',qcu05,'','','','' FROM qcu_file ",  #No.FUN-7B0027 
    LET g_forupd_sql = "SELECT qcu03,'','',qcuicd01,qcuicd02,'',qcu04,'',qcu05 FROM qcu_file ",
#No.FUN-830131  --END
                       "  WHERE qcu03= ?  AND qcu01= ? AND qcu02= ? ",
                       " AND qcu021= ?  FOR UPDATE "           #TQC-780042 mod
                      #" AND qcu021= ?  FOR UPDATE  "    #TQC-780042 mark
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t111_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_qcu WITHOUT DEFAULTS FROM s_qcu.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
 
               BEGIN WORK
               LET p_cmd='u'
               LET g_qcu_t.* = g_qcu[l_ac].*  #BACKUP
 
               OPEN t111_bcl USING g_qcu_t.qcu03,g_qcu01,g_qcu02,g_qcu021
               IF STATUS THEN
                  CALL cl_err("OPEN t111_bcl:", STATUS, 1)
                  LET l_lock_sw = 'Y'
               ELSE
                  FETCH t111_bcl INTO g_qcu[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_qcu_t.qcu03,SQLCA.sqlcode,1)
                     LET l_lock_sw = 'Y'
                  ELSE
                     SELECT qce03 INTO g_qcu[l_ac].qce03 FROM qce_file
                      WHERE qce01=g_qcu[l_ac].qcu04
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_qcu[l_ac].* TO NULL      #900423
            LET g_qcu_t.* = g_qcu[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
#              CALL g_qcu.deleteElement(l_ac)   #取消 Array Element
#              IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
#                 LET g_action_choice = "detail"
#                 LET l_ac = l_ac_t
#              END IF
#              EXIT INPUT
            END IF
#           INSERT INTO qcu_file(qcu01,qcu02,qcu021,qcu03,qcu04,qcu05)                         #No.FUN-7B0027
#                         VALUES(g_qcu01,g_qcu02,g_qcu021,g_qcu[l_ac].qcu03,                   #No.FUN-7B0027
#                                g_qcu[l_ac].qcu04,g_qcu[l_ac].qcu05)                          #No.FUN-7B0027
#            INSERT INTO qcu_file(qcu01,qcu02,qcu021,qcu03,qcu04,qcu05,qcuicd01,qcuicd02)       #No.FUN-7B0027 #FUN-980007
#                          VALUES(g_qcu01,g_qcu02,g_qcu021,g_qcu[l_ac].qcu03,g_qcu[l_ac].qcu04, #No.FUN-7B0027 #FUN-980007
#                                 g_qcu[l_ac].qcu05,g_qcu[l_ac].qcuicd01,g_qcu[l_ac].qcuicd02)  #No.FUN-7B0027 #FUN-980007
            INSERT INTO qcu_file(qcu01,qcu02,qcu021,qcu03,qcu04,qcu05,qcuicd01,qcuicd02,       #FUN-980007
                                 qcuplant,qculegal)                                            #FUN-980007       
                          VALUES(g_qcu01,g_qcu02,g_qcu021,g_qcu[l_ac].qcu03,g_qcu[l_ac].qcu04, #FUN-980007 
                                 g_qcu[l_ac].qcu05,g_qcu[l_ac].qcuicd01,g_qcu[l_ac].qcuicd02,  #FUN-980007
                                 g_plant,g_legal)                                              #FUN-980007
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_qcu[l_ac].qcu03,SQLCA.sqlcode,0)   #No.FUN-660115
               CALL cl_err3("ins","qcu_file",g_qcu01,g_qcu[l_ac].qcu03,SQLCA.sqlcode,"","",1)  #No.FUN-660115
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        AFTER FIELD qcu03                        #check 編號是否重複
            IF NOT cl_null(g_qcu[l_ac].qcu03) THEN
               IF g_qcu[l_ac].qcu03 != g_qcu_t.qcu03 OR
                  cl_null(g_qcu_t.qcu03) THEN
                   SELECT count(*) INTO l_n FROM qct_file
                    WHERE qct03 = g_qcu[l_ac].qcu03 AND qct07>0
                      AND qct01 = g_qcu01 AND qct02=g_qcu02
                      AND qct021=g_qcu021
                   IF l_n = 0 THEN
                      CALL cl_err(g_qcu[l_ac].qcu03,'aqc-030',0)
                      LET g_qcu[l_ac].qcu03 = g_qcu_t.qcu03
                      NEXT FIELD qcu03
                   END IF
               END IF
            END IF
 
        AFTER FIELD qcu04
           IF NOT cl_null(g_qcu[l_ac].qcu04) THEN
              SELECT qce03 INTO g_qcu[l_ac].qce03 FROM qce_file
                 WHERE qce01=g_qcu[l_ac].qcu04
              IF STATUS THEN NEXT FIELD qcu04 END IF
           END IF
 
        AFTER FIELD qcu05
           IF g_qcu[l_ac].qcu05<0 OR g_qcu[l_ac].qcu05 IS NULL THEN
              LET g_qcu[l_ac].qcu05=0
           END IF
 
#FUN-830131  --BEGIN
#FUN-830131  --END
 
        BEFORE DELETE                            #是否取消單身
            IF g_qcu_t.qcu03 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
 
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
 
               DELETE FROM qcu_file
                #WHERE qcu03 = g_qcu03                            #TQC-840007
                 WHERE qcu03 = g_qcu_t.qcu03                      #TQC-840007
                  AND qcu01 = g_qcu01_t AND qcu02 = g_qcu02_t    
                  AND qcu021= g_qcu021_t
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_qcu_t.qcu03,SQLCA.sqlcode,0)   #No.FUN-660115
                  CALL cl_err3("del","qcu_file",g_qcu01,g_qcu_t.qcu03,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_qcu[l_ac].* = g_qcu_t.*
               CLOSE t111_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_qcu[l_ac].qcu03,-263,1)
               LET g_qcu[l_ac].* = g_qcu_t.*
            ELSE
               UPDATE qcu_file SET qcu01=g_qcu01,
                                   qcu02=g_qcu02,
                                   qcu021=g_qcu021,
                                   qcu03=g_qcu[l_ac].qcu03,
                                   qcu04=g_qcu[l_ac].qcu04,
                                   qcu05=g_qcu[l_ac].qcu05,
                                   qcuicd01=g_qcu[l_ac].qcuicd01,                        #No.FUN-7B0027
                                   qcuicd02=g_qcu[l_ac].qcuicd02                         #No.FUN-7B0027
               WHERE qcu03=g_qcu_t.qcu03
                 AND qcu01=g_qcu01
                 AND qcu02=g_qcu02
                 AND qcu021=g_qcu021
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_qcu[l_ac].qcu03,SQLCA.sqlcode,0)   #No.FUN-660115
                  CALL cl_err3("upd","qcu_file",g_qcu01,g_qcu_t.qcu03,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                  LET g_qcu[l_ac].* = g_qcu_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_qcu[l_ac].* = g_qcu_t.*
               END IF
               CLOSE t111_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE t111_bcl
            COMMIT WORK
 
#       ON ACTION CONTROLN
#           CALL t111_b_askkey()
#           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(qcu01) AND l_ac > 1 THEN
                LET g_qcu[l_ac].* = g_qcu[l_ac-1].*
                NEXT FIELD qcu01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
#No.FUN-7B0027--add--begin--#                                                                                                       
        ON ACTION controlp                                                                                                          
         CASE                                                                                                                       
           WHEN INFIELD(qcuicd01)                                                                                                     
             CALL cl_init_qry_var()                                                                                                 
             LET g_qryparam.form = "q_ida"                                                                                          
             LET g_qryparam.arg1 = g_qcu01  
             LET g_qryparam.arg2 = g_qcu02 
             LET g_qryparam.default1 = g_qcu[l_ac].qcuicd01                                                                                  
             CALL FGL_DIALOG_SETBUFFER(g_qcu[l_ac].qcuicd01)                                                                                 
             DISPLAY BY NAME g_qcu[l_ac].qcuicd01                                                                                            
             NEXT FIELD qcuicd01                                                                                                       
          #WHEN INFIELD(qucicd02) #TQC-8C0052 mark
           WHEN INFIELD(qcuicd02) #TQC-8C0052
             CALL cl_init_qry_var()                                                                                                 
             LET g_qryparam.form = "q_icd2"                                                                                         
             LET g_qryparam.default1 = g_qcu[l_ac].qcuicd02                                                                                  
             CALL FGL_DIALOG_SETBUFFER(g_qcu[l_ac].qcuicd02)                                                                                 
             DISPLAY BY NAME g_qcu[l_ac].qcuicd02                                                                                            
             CALL i111_icd03('d')                                                                                                   
             NEXT FIELD qcuicd02                                                                                                       
           OTHERWISE                                                                                                                
             EXIT CASE
         END CASE                                                                                                                   
#No.FUN-7B0027--add--end--#
 
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
        END INPUT
 
    CLOSE t111_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t111_b_askkey()
    CLEAR FORM
    CALL g_qcu.clear()
 
    CONSTRUCT g_wc2 ON qcu03,qcu04,qcu05
         FROM s_qcu[1].qcu03, s_qcu[1].qcu04, s_qcu[1].qcu05
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
 
    CALL t111_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION t111_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(200)
 
     #LET g_sql ="SELECT qcu03,'','',qcu04,qce03,qcu05,''",  #TQC-840007
     #LET g_sql = "SELECT qcu03,'','',qcu04,qce03,qcu05 ",    #TQC-840007  #No.FUN-830131 MARK
      LET g_sql = "SELECT qcu03,'','',qcuicd01,qcuicd02,'',qcu04,qce03,qcu05 ", #No.FUN-830131
                " FROM qcu_file,qce_file",
                " WHERE qcu01='",g_qcu01,"' AND qcu02='",g_qcu02,"' ",
                " AND qcu021='",g_qcu021,"' AND qcu04=qce01 AND",p_wc2 CLIPPED,
                " ORDER BY 1"
    PREPARE t111_pb FROM g_sql
    DECLARE qcu_curs CURSOR FOR t111_pb
 
    CALL g_qcu.clear()
 
    LET g_cnt = 1
    MESSAGE "Searching!"
 
    FOREACH qcu_curs INTO g_qcu[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        CASE g_argv4
             WHEN 1
                  SELECT qct04,azf03 INTO g_qcu[g_cnt].item,g_qcu[g_cnt].azf03
                    FROM qct_file,OUTER azf_file
                   WHERE qct01=g_qcu01 AND qct02=g_qcu02 AND qct021=g_qcu021
                     AND qct03=g_qcu[g_cnt].qcu03
                     AND qct04=azf01 AND azf_file.azf02='6'
             WHEN 2
                  SELECT qcg04,azf03 INTO g_qcu[g_cnt].item,g_qcu[g_cnt].azf03
                    FROM qcg_file,OUTER azf_file
                   WHERE qcg01=g_qcu01 AND qcg03=g_qcu[g_cnt].qcu03
                     AND qcg04=azf01 AND azf_file.azf02='6'
             WHEN 3
                  SELECT qcn04,azf03 INTO g_qcu[g_cnt].item,g_qcu[g_cnt].azf03
                    FROM qcn_file,OUTER azf_file
                   WHERE qcn01=g_qcu01 AND qcn03=g_qcu[g_cnt].qcu03
                     AND qcn04=azf01 AND azf_file.azf02='6'
        END CASE
#No.FUN-830131  --begin
#No.FUN-830131  --end
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
 
    END FOREACH
    CALL g_qcu.deleteElement(g_cnt)
    MESSAGE ""
 
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION t111_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_ud <> "G"  OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qcu TO s_qcu.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
#     ON ACTION query
#        LET g_action_choice="query"
      ON ACTION first
         CALL t111_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
#     ON ACTION previous
         CALL t111_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t111_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
#     ON ACTION next
         CALL t111_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t111_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
#     ON ACTION detail
#        LET g_action_choice="detail"
#     ON ACTION help
#        LET g_action_choice="help"
 
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
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
     #@ON ACTION 相關文件                         #FUN-830068                                                                       
      ON ACTION related_document                                                                                                    
         LET g_action_choice="related_document"                                                                                     
         EXIT DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      #No.MOD-530688  --begin
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      #No.MOD-530688  --end
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#Patch....NO.TQC-610036 <001> #
