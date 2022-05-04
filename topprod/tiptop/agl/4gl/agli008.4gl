# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli008.4gl
# Descriptions...: 外幣換算匯率維護
# Date & Author..: 05/08/15 By Dido
# Modify.........: No.TQC-660048 06/06/12 By Smapmin 單身期別不能輸入
# Modify.........: No.FUN-660123 06/06/28 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0040 06/11/15 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-720019 07/02/28 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.FUN-720012 07/03/01 By jamie 報表格式調整
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-740015 07/04/04 By Judy 勾選定義科目歷史匯率前,公司編號，科目編號不可輸入
# Modify.........: No.FUN-740020 07/04/13 By bnlent 會計科目加帳套
# Modify.........: No.MOD-740129 07/04/20 By rainy 整合測試
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760053 07/06/27 By Sarah 隱藏單頭的"定義科目歷史匯率維護","公司代號","科目代號"
# Modify.........: No.TQC-770095 07/07/18 By Sarah 無法修改單身
# Modify.........: No.FUN-780037 07/07/26 By sherry 報表改由p_query輸出
# Modify.........: No.FUN-780013 07/08/22 By kim 期別要可以輸入0
# Modify.........: No.FUN-770069 07/10/09 By Sarah 單身刪除的WHERE條件句,axp02的部份應該用g_axp_t.axp02
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A90034 11/01/26 By lixia 追單 增加更新平均匯率ACTION
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.CHI-B40058 11/05/13 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式 
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global" 
#FUN-BA0012
#FUN-BA0006 
#模組變數(Module Variables)
DEFINE 
    g_axp01         LIKE axp_file.axp01,  
    g_axp03         LIKE axp_file.axp03,  
    g_axp04         LIKE axp_file.axp04,  
    g_check         LIKE type_file.chr1,     #定義科目歷史匯率   #No.FUN-680098 VARCHAR(1)
    g_axp08         LIKE axp_file.axp08,  
    g_axp09         LIKE axp_file.axp09,  
    g_axp01_t       LIKE axp_file.axp01, 
    g_axp03_t       LIKE axp_file.axp03, 
    g_axp04_t       LIKE axp_file.axp04, 
    g_check_t       LIKE type_file.chr1,     #定義科目歷史匯率  #No.FUN-680098 VARCHAR(1)
    g_axp08_t       LIKE axp_file.axp08, 
    g_axp09_t       LIKE axp_file.axp09, 
    g_axp01_o       LIKE axp_file.axp01,
    g_axp03_o       LIKE axp_file.axp03,
    g_axp04_o       LIKE axp_file.axp04,
    g_axp08_o       LIKE axp_file.axp08,
    g_axp09_o       LIKE axp_file.axp09,
    g_axp           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        axp02       LIKE axp_file.axp02,                 
        axp05       LIKE axp_file.axp05,                 
        axp06       LIKE axp_file.axp06,                 
        axp07       LIKE axp_file.axp07                 
                    END RECORD,
    g_axp_t         RECORD                 #程式變數 (舊值)
        axp02       LIKE axp_file.axp02,                 
        axp05       LIKE axp_file.axp05,                 
        axp06       LIKE axp_file.axp06,                 
        axp07       LIKE axp_file.axp07                 
                    END RECORD,
    i               LIKE type_file.num5,    #No.FUN-680098 smallint
    g_wc,g_sql,g_wc2    STRING,             
    g_rec_b         LIKE type_file.num5,    #單身筆數                #No.FUN-680098  smallint
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT     #No.FUN-680098  smallint
 
#主程式開始
DEFINE   g_forupd_sql   STRING      #SELECT ... FOR UPDATE SQL       
DEFINE   g_sql_tmp      STRING      #No.TQC-720019
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 smallint
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680098 smallint
DEFINE   g_flag         LIKE type_file.chr1          #No.FUN-740020
DEFINE   g_bookno1      LIKE aza_file.aza81          #No.FUN-740020
DEFINE   g_bookno2      LIKE aza_file.aza82          #No.FUN-740020
DEFINE   l_cmd          LIKE type_file.chr1000       #No.FUN-780037
MAIN
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680098  smallint
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET i=0
   LET g_axp01_t = NULL
   LET g_axp03_t = NULL
   LET g_axp04_t = NULL
   LET g_axp08_t = NULL
   LET g_axp09_t = NULL
   LET p_row = 4 LET p_col = 12
 
   OPEN WINDOW i008_w AT p_row,p_col WITH FORM "agl/42f/agli008" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
 
   CALL cl_set_comp_visible("c,axp08,axp09",FALSE)   #FUN-760053 add
 
   CALL i008_menu()
   CLOSE FORM i008_w                      #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION i008_cs()
    CLEAR FORM                            #清除畫面
    CALL g_axp.clear()
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
    INITIALIZE g_axp01 TO NULL    #No.FUN-750051
    INITIALIZE g_axp03 TO NULL    #No.FUN-750051
    INITIALIZE g_axp04 TO NULL    #No.FUN-750051
    INITIALIZE g_axp08 TO NULL    #No.FUN-750051
    INITIALIZE g_axp09 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON axp01,axp02,axp03,axp04,axp08,axp09 
         FROM axp01,s_axp[1].axp02,axp03,axp04,axp08,axp09  #螢幕上取條件
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(axp03)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_azi"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO axp03 
                  NEXT FIELD axp03
             WHEN INFIELD(axp04)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_azi"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO axp04 
                  NEXT FIELD axp04
             WHEN INFIELD(axp08)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_axz"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret 
                  DISPLAY g_qryparam.multiret TO axp08 
                  NEXT FIELD axp08
             WHEN INFIELD(axp09)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aag"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO axp09 
                  NEXT FIELD axp09
             OTHERWISE 
                  EXIT CASE
          END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about    
          CALL cl_about()
 
       ON ACTION help 
          CALL cl_show_help() 
 
       ON ACTION controlg 
          CALL cl_cmdask()
    
       #No.FUN-580031 --start--     HCN
       ON ACTION qbe_select
          CALL cl_qbe_select() 
       ON ACTION qbe_save
          CALL cl_qbe_save()
       #No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('axpuser', 'axpgrup') #FUN-980030
 
    IF INT_FLAG THEN 
       RETURN 
    END IF
 
   #LET g_sql= "SELECT DISTINCT axp01,axp03,axp04,axp08,axp09 FROM axp_file ",   #FUN-760053 mark
    LET g_sql= "SELECT DISTINCT axp01,axp03,axp04 FROM axp_file ",               #FUN-760053
               " WHERE ", g_wc CLIPPED,
              #" ORDER BY axp01,axp03,axp04,axp08,axp09"   #FUN-760053 mark
               " ORDER BY axp01,axp03,axp04"               #FUN-760053
    PREPARE i008_prepare FROM g_sql        #預備一下
    DECLARE i008_bcs                       #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i008_prepare
 
#   LET g_sql = "SELECT DISTINCT axp01,axp03,axp04,axp08,axp09 ",      #No.TQC-720019
   #LET g_sql_tmp = "SELECT DISTINCT axp01,axp03,axp04,axp08,axp09 ",  #No.TQC-720019   #FUN-760053 mark
    LET g_sql_tmp = "SELECT DISTINCT axp01,axp03,axp04 ",  #No.TQC-720019               #FUN-760053
                "  FROM axp_file ",
                " WHERE ", g_wc CLIPPED,
                " INTO TEMP x "
    DROP TABLE x
#   PREPARE i008_pre_x FROM g_sql      #No.TQC-720019
    PREPARE i008_pre_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i008_pre_x
 
    LET g_sql = "SELECT COUNT(*) FROM x"
    PREPARE i008_precnt FROM g_sql
    DECLARE i008_cnt CURSOR FOR i008_precnt
END FUNCTION
 
FUNCTION i008_menu()
 
   WHILE TRUE
      CALL i008_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i008_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i008_q()
            END IF
 
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i008_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i008_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i008_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               #No.FUN-780037---Begin
               #CALL i008_out()
               IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF                   
               LET l_cmd = 'p_query "agli008" "',g_wc CLIPPED,'"'               
               CALL cl_cmdrun(l_cmd)                                             
               #No.FUN-780037---End     
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document" 
            IF cl_chk_act_auth() THEN
               IF g_axp01 IS NOT NULL THEN
                  LET g_doc.column1 = "axp01"
                  LET g_doc.value1 = g_axp01
                  CALL cl_doc()
               END IF
            END IF
#FUN-A90034 --Begin
         WHEN "upd_avg_rate"
            IF cl_chk_act_auth() THEN
               CALL i008_upd_avg_rate()
            END IF
#FUN-A90034 --End
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_axp),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i008_a()
    IF s_shut(0) THEN RETURN END IF                #判斷目前系統是否可用
    MESSAGE ""
    CLEAR FORM
    CALL g_axp.clear()
    INITIALIZE g_axp01 LIKE axp_file.axp01         #DEFAULT 設定
    INITIALIZE g_axp03 LIKE axp_file.axp03         #DEFAULT 設定
    INITIALIZE g_axp04 LIKE axp_file.axp04         #DEFAULT 設定
    LET g_check='N'
#TQC-740015.....begin
    CALL cl_set_comp_entry("axp08",FALSE)                                       
    CALL cl_set_comp_entry("axp09",FALSE)
#   LET g_axp08=' '
#   LET g_axp09=' '
#TQC-740015.....end
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i008_i("a")                           #輸入單頭
        IF INT_FLAG THEN                           #使用者不玩了
            LET g_axp01=NULL
            LET g_axp03=NULL
            LET g_axp04=NULL
            LET g_axp08=' '
            LET g_axp09=' '
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_axp01 IS NULL THEN # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF g_axp03 IS NULL THEN # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF g_axp04 IS NULL THEN # KEY 不可空白
            CONTINUE WHILE
        END IF
       #str TQC-770095 mark
       #IF g_check = 'Y' THEN 
       #   IF g_axp08 IS NULL THEN # KEY 不可空白
       #       CALL cl_err('','afa-091',0)
       #       CONTINUE WHILE
       #   END IF
       #   IF g_axp09 IS NULL THEN # KEY 不可空白
       #       CALL cl_err('','afa-091',0)
       #       CONTINUE WHILE
       #   END IF
       #END IF
       #end TQC-770095 mark
 
        CALL g_axp.clear()
        LET g_rec_b = 0 
        CALL i008_b()                              #輸入單身
        SELECT axp01 INTO g_axp01 FROM axp_file
            WHERE axp01 = g_axp01 AND axp03 = g_axp03 AND axp04 = g_axp04
       #      AND axp08 = g_axp08 AND axp09 = g_axp09          #FUN-760053 mark
        LET g_axp01_t = g_axp01                    #保留舊值
        LET g_axp03_t = g_axp03                    #保留舊值
        LET g_axp04_t = g_axp04                    #保留舊值
        LET g_check_t = g_check                    #保留舊值
        LET g_axp08_t = g_axp08                    #保留舊值
        LET g_axp09_t = g_axp09                    #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i008_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入 #No.FUN-680098 VARCHAR(1)
    l_n1,l_n        LIKE type_file.num5,    #No.FUN-680098         smallint
    p_cmd           LIKE type_file.chr1     #a:輸入 u:更改        #No.FUN-680098 VARCHAR(1)
    
    DISPLAY g_axp01,g_axp03,g_axp04,g_check,g_axp08,g_axp09
         TO axp01,axp03,axp04,c,axp08,axp09
    CALL cl_set_head_visible("","YES")      #No.FUN-6B0029  
 
    INPUT g_axp01,g_axp03,g_axp04,g_check,g_axp08,g_axp09 FROM axp01,axp03,axp04,c,axp08,axp09
 
        BEFORE FIELD axp01
            IF p_cmd = 'a' THEN
               LET g_check = 'N'
               DISPLAY g_check TO c 
            END IF
 
        AFTER FIELD axp01
            IF cl_null(g_axp01) or g_axp01 = 0 THEN
               CALL cl_err(g_axp01,'afa-370',0)
               NEXT FIELD axp01
            END IF     #MOD-740129
            #No.FUN-740020  --Begin
            CALL s_get_bookno(g_axp01) RETURNING g_flag,g_bookno1,g_bookno2
            IF g_flag = '1' THEN
               CALL cl_err(g_axp01,'aoo-081',1)
               NEXT FIELD axp01
            END IF
            #No.FUN-740020  --End
            #END IF     #MOD-740129
 
        AFTER FIELD axp03
            IF NOT cl_null(g_axp03) THEN
               SELECT * FROM azi_file
                WHERE azi01 = g_axp03 
               IF SQLCA.sqlcode THEN 
#                 CALL cl_err(g_axp03,'agl-109',0)   #No.FUN-660123
                  CALL cl_err3("sel","azi_file",g_axp03,"","agl-109","","",1)  #No.FUN-660123
                  NEXT FIELD axp03
               END IF
            END IF
 
        AFTER FIELD axp04
            IF NOT cl_null(g_axp04) THEN
               SELECT * FROM azi_file
                WHERE azi01 = g_axp04 
               IF SQLCA.sqlcode THEN 
#                 CALL cl_err(g_axp04,'agl-109',0)   #No.FUN-660123
                  CALL cl_err3("sel","azi_file",g_axp04,"","agl-109","","",1)  #No.FUN-660123
                  NEXT FIELD axp04
               END IF
            END IF
 
        AFTER FIELD c 
            IF g_check = 'Y' THEN
               CALL cl_set_comp_entry("axp08",TRUE)
               CALL cl_set_comp_entry("axp09",TRUE)
               NEXT FIELD axp08
            ELSE
               LET g_axp08 = ' '
               LET g_axp09 = ' '
               DISPLAY g_axp08 TO axp08 
               DISPLAY g_axp09 TO axp09 
               CALL cl_set_comp_entry("axp08",FALSE)
               CALL cl_set_comp_entry("axp09",FALSE)
            END IF
        
        AFTER FIELD axp08
            IF NOT cl_null(g_axp08) THEN
               SELECT * FROM axz_file
                WHERE axz01 = g_axp08 
               IF SQLCA.sqlcode THEN 
#                 CALL cl_err(g_axp08,'apy-012',0)   #No.FUN-660123
#                 CALL cl_err3("sel","axz_file",g_axp08,"","apy-012","","",1)   #No.FUN-660123   #CHI-B40058
                  CALL cl_err3("sel","axz_file",g_axp08,"","agl-262","","",1)   #CHI-B40058
                  NEXT FIELD axp08
               END IF
            END IF
        
        AFTER FIELD axp09
            IF NOT cl_null(g_axp09) THEN
               SELECT * FROM aag_file
                WHERE aag01 = g_axp09 
                  #AND aag00 = g_axp01     #No.FUN-740020  #MOD-740129
                  AND aag00 = g_bookno1                    #MOD-740129
               IF SQLCA.sqlcode THEN 
#                 CALL cl_err(g_axp09,'agl-001',0)   #No.FUN-660123
                  CALL cl_err3("sel","aag_file",g_axp09,"","agl-001","","",1)  #No.FUN-660123
                  NEXT FIELD axp09
               END IF
            END IF
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(axp03)  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_axp03
                 CALL cl_create_qry() RETURNING g_axp03
                 DISPLAY g_axp03 TO axp03 
                 NEXT FIELD axp03
              WHEN INFIELD(axp04)  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_axp04
                 CALL cl_create_qry() RETURNING g_axp04
                 DISPLAY g_axp04 TO axp04 
                 NEXT FIELD axp04
              WHEN INFIELD(axp08)  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_axz"
                 CALL cl_create_qry() RETURNING g_axp08
                 DISPLAY g_axp08 TO axp08 
                 NEXT FIELD axp08
              WHEN INFIELD(axp09)  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.arg1 = g_bookno1      #No.FUN-740020
                 CALL cl_create_qry() RETURNING g_axp09
                 DISPLAY g_axp09 TO axp09 
                 NEXT FIELD axp09
              OTHERWISE EXIT CASE
           END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about 
          CALL cl_about() 
 
       ON ACTION help 
          CALL cl_show_help() 
    
    END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION i008_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_axp01 TO NULL               #No.FUN-6B0040
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_axp.clear()
    CALL i008_cs()                           #取得查詢條件
    IF INT_FLAG THEN                         #使用者不玩了
        LET INT_FLAG = 0             
        RETURN                       
    END IF                           
    OPEN i008_bcs                            #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                    #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_axp01 TO NULL
    ELSE
        OPEN i008_cnt
        FETCH i008_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
        CALL i008_fetch('F')                 # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i008_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680098 integer
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i008_bcs INTO g_axp01,g_axp03,g_axp04   #,g_axp08,g_axp09   #FUN-760053 mod
        WHEN 'P' FETCH PREVIOUS i008_bcs INTO g_axp01,g_axp03,g_axp04   #,g_axp08,g_axp09   #FUN-760053 mod
        WHEN 'F' FETCH FIRST    i008_bcs INTO g_axp01,g_axp03,g_axp04   #,g_axp08,g_axp09   #FUN-760053 mod
        WHEN 'L' FETCH LAST     i008_bcs INTO g_axp01,g_axp03,g_axp04   #,g_axp08,g_axp09   #FUN-760053 mod
        WHEN '/' 
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                   ON ACTION about 
                      CALL cl_about() 
 
                   ON ACTION help 
                      CALL cl_show_help()
 
                   ON ACTION controlg   
                      CALL cl_cmdask() 
                
                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i008_bcs INTO g_axp01,g_axp03,g_axp04   #,g_axp08,g_axp09    #FUN-760053 mod
            LET mi_no_ask = FALSE
    END CASE
 
   #SELECT unique axp01,axp03,axp04,axp08,axp09   #FUN-760053 mark
    SELECT unique axp01,axp03,axp04               #FUN-760053  
      FROM axp_file 
     WHERE axp01 = g_axp01 AND axp03 = g_axp03 AND axp04 = g_axp04 
   #   AND axp08 = g_axp08 AND axp09 = g_axp09    #FUN-760053 mark
    IF SQLCA.sqlcode THEN                         #有麻煩
#       CALL cl_err(g_axp01,SQLCA.sqlcode,0)   #No.FUN-660123
        CALL cl_err3("sel","axp_file",g_axp01,g_axp03,SQLCA.sqlcode,"","",1)  #No.FUN-660123
        INITIALIZE g_axp01 TO NULL  #TQC-6B0105
        INITIALIZE g_axp03 TO NULL  #TQC-6B0105
        INITIALIZE g_axp04 TO NULL  #TQC-6B0105
        INITIALIZE g_axp08 TO NULL  #TQC-6B0105
        INITIALIZE g_axp09 TO NULL  #TQC-6B0105
    ELSE
            #No.FUN-740020  --Begin
            CALL s_get_bookno(g_axp01) RETURNING g_flag,g_bookno1,g_bookno2
            IF g_flag = '1' THEN
               CALL cl_err(g_axp01,'aoo-081',1)
            END IF
            #No.FUN-740020  --End
        CALL i008_show()
        CASE p_flag
           WHEN 'F' LET g_curs_index = 1
           WHEN 'P' LET g_curs_index = g_curs_index - 1
           WHEN 'N' LET g_curs_index = g_curs_index + 1
           WHEN 'L' LET g_curs_index = g_row_count
           WHEN '/' LET g_curs_index = g_jump
        END CASE
    
        CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i008_show()
 
    DISPLAY g_axp01 TO axp01           #單頭
    DISPLAY g_axp03 TO axp03           #單頭
    DISPLAY g_axp04 TO axp04           #單頭
    DISPLAY g_axp08 TO axp08           #單頭
    DISPLAY g_axp09 TO axp09           #單頭
    IF g_axp08 <> ' ' THEN
       LET g_check = 'Y'
    ELSE
       LET g_check = 'N'
    END IF
    DISPLAY g_check TO FORMONLY.c      #單頭
    CALL i008_b_fill(g_wc)             #單身
 
    CALL cl_show_fld_cont() 
END FUNCTION
 
FUNCTION i008_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc       LIKE type_file.chr1000     #No.FUN-680098  VARCHAR(200)
 
    LET g_sql = "SELECT axp02,axp05,axp06,axp07 FROM axp_file ",
                " WHERE axp01 = '",g_axp01,"'",
                "   AND axp03 = '",g_axp03,"'",
                "   AND axp04 = '",g_axp04,"'",
               #"   AND axp08 = '",g_axp08,"'",    #TQC-770095 mark
               #"   AND axp09 = '",g_axp09,"'",    #TQC-770095 mark
                "   AND ",p_wc CLIPPED ,
                " ORDER BY axp02"
    PREPARE i008_prepare2 FROM g_sql      #預備一下
    DECLARE axp_cs CURSOR FOR i008_prepare2
 
    CALL g_axp.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH axp_cs INTO g_axp[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
 
      LET g_cnt = g_cnt + 1
      
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      
    END FOREACH
    CALL g_axp.deleteElement(g_cnt)
    LET g_rec_b=g_cnt -1
 
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i008_r()
 
    IF s_shut(0) THEN RETURN END IF
    IF g_axp01 IS NULL 
	THEN CALL cl_err('',-400,0) RETURN 
    END IF
    IF g_axp03 IS NULL 
	THEN CALL cl_err('',-400,0) RETURN 
    END IF
    IF g_axp04 IS NULL 
	THEN CALL cl_err('',-400,0) RETURN 
    END IF
    BEGIN WORK
    IF cl_delh(15,16) THEN
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "axp01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_axp01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        DELETE FROM axp_file 
         WHERE axp01=g_axp01 AND axp03=g_axp03 AND axp04=g_axp04
       #   AND axp08=g_axp08 AND axp09=g_axp09   #FUN-760053 mark
        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#          CALL cl_err(g_axp01,SQLCA.sqlcode,0)   #No.FUN-660123
           CALL cl_err3("del","axp_file",g_axp01,g_axp03,SQLCA.sqlcode,"","",1)  #No.FUN-660123
        ELSE 
           CLEAR FORM
           CALL g_axp.clear()
          #LET g_sql = "SELECT DISTINCT axp01,axp03,axp04,axp08,axp09 ",   #FUN-760053 mark
           LET g_sql = "SELECT DISTINCT axp01,axp03,axp04 ",               #FUN-760053
                       "  FROM axp_file ",
                       " INTO TEMP y "
           DROP TABLE y
           PREPARE i008_pre_y FROM g_sql
#          EXECUTE i008_pre_y                  #No.TQC-720019
          #PREPARE i008_pre_y FROM g_sql_tmp   #No.TQC-720019
           EXECUTE i008_pre_y                  #No.TQC-720019
           LET g_sql = "SELECT COUNT(*) FROM y"
           PREPARE i008_precnt2 FROM g_sql
           DECLARE i008_cnt2 CURSOR FOR i008_precnt2
           OPEN i008_cnt2
           #FUN-B50062-add-start--
           IF STATUS THEN
              CLOSE i008_bcs
              CLOSE i008_cnt2  
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50062-add-end--

           FETCH i008_cnt2 INTO g_row_count
           #FUN-B50062-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE i008_bcs
              CLOSE i008_cnt2 
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50062-add-end--
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i008_bcs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i008_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL i008_fetch('/')
           END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i008_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT  #No.FUN-680098 smallint
    l_n             LIKE type_file.num5,     #檢查重複用      #No.FUN-680098  smalint
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否      #No.FUN-680098  VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態        #No.FUN-680098  VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,     #可新增否        #No.FUN-680098  smallint 
    l_allow_delete  LIKE type_file.num5      #可刪除否        #No.FUN-680098  smallint
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT axp02,axp05,axp06,axp07 FROM axp_file ",
        "  WHERE axp01= ? AND axp02 = ? AND axp03 = ? AND axp04 = ? ",
       #"   AND axp08 = ? AND axp09 = ? ",   #TQC-770095 mark
        "   FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i008_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_axp WITHOUT DEFAULTS FROM s_axp.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
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
               LET g_axp_t.* = g_axp[l_ac].*  #BACKUP
               OPEN i008_bcl USING g_axp01,g_axp[l_ac].axp02,g_axp03,g_axp04
                                 #,g_axp08,g_axp09   #TQC-770095 mark
               IF STATUS THEN
                  CALL cl_err("OPEN i008_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i008_bcl INTO g_axp[l_ac].axp02,g_axp[l_ac].axp05,
                                      g_axp[l_ac].axp06,g_axp[l_ac].axp07
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_axp_t.axp02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont() 
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_axp[l_ac].* TO NULL   
            LET g_axp_t.* = g_axp[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()   
            NEXT FIELD axp02
 
        AFTER INSERT
            IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              INITIALIZE g_axp[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_axp[l_ac].* TO s_axp.*
              CALL g_axp.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
            IF cl_null(g_axp08) THEN LET g_axp08 = ' ' END IF   #FUN-760053 add
            IF cl_null(g_axp09) THEN LET g_axp09 = ' ' END IF   #FUN-760053 add
            INSERT INTO axp_file(axp01,axp02,axp03,axp04,axp05,axp06,axp07,
                                 axp08,axp09,axpuser,axpgrup,axpmodu,axpdate,
                                 axpconf,axppost,axpacti,axporiu,axporig)
                          VALUES(g_axp01,g_axp[l_ac].axp02,g_axp03,g_axp04,
                                 g_axp[l_ac].axp05,g_axp[l_ac].axp06,
                                 g_axp[l_ac].axp07,g_axp08,g_axp09,g_user,
                                 g_grup,g_user,g_today,'N','N','Y', g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_axp[l_ac].axp02,SQLCA.sqlcode,0)   #No.FUN-660123
                CALL cl_err3("ins","axp_file",g_axp01,g_axp[l_ac].axp02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                CANCEL INSERT
            ELSE
                LET g_rec_b = g_rec_b + 1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE 'INSERT O.K'
            END IF
 
        BEFORE FIELD axp02                        #default 期別
          #IF g_axp[l_ac].axp02 IS NULL OR g_axp[l_ac].axp02 = 0 THEN #FUN-780013
           IF g_axp[l_ac].axp02 IS NULL THEN #FUN-780013
              SELECT max(axp02)+1
                INTO g_axp[l_ac].axp02
                FROM axp_file
               WHERE axp01 = g_axp01 AND axp03 = g_axp03 AND axp04 = g_axp04
             #   AND axp08 = g_axp08 AND axp09 = g_axp09    #TQC-770095 mark
              IF g_axp[l_ac].axp02 IS NULL THEN
                 LET g_axp[l_ac].axp02 = 1
              END IF
              IF g_axp[l_ac].axp02 > 12 THEN
                 LET g_axp[l_ac].axp02 = 12
              END IF
           END IF
           IF g_check = 'Y' THEN
              CALL cl_set_comp_entry("axp06",TRUE)
              LET g_axp[l_ac].axp05 = 0
              LET g_axp[l_ac].axp07 = 0
              CALL cl_set_comp_entry("axp05",FALSE)
              CALL cl_set_comp_entry("axp07",FALSE)
              #NEXT FIELD axp06   #TQC-660048
           ELSE
              CALL cl_set_comp_entry("axp05",TRUE)
              CALL cl_set_comp_entry("axp07",TRUE)
              #NEXT FIELD axp05   #TQC-660048
           END IF
 
        AFTER FIELD axp02
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_axp[l_ac].axp02) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_axp01
            IF g_azm.azm02 = 1 THEN
               IF g_axp[l_ac].axp02 > 12 OR g_axp[l_ac].axp02 < 0 THEN #FUN-780013
                  NEXT FIELD axp02
               END IF
            ELSE
               IF g_axp[l_ac].axp02 > 13 OR g_axp[l_ac].axp02 < 0 THEN #FUN-780013
                  NEXT FIELD axp02
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
#           IF NOT cl_null(g_axp[l_ac].axp02) THEN
#              IF g_axp[l_ac].axp02 > 13 OR g_axp[l_ac].axp02 < 1 THEN 
#                 NEXT  FIELD axp02
#              END IF
#           END IF
#No.TQC-720032 -- end --
 
        BEFORE FIELD axp06            
           IF g_check = 'Y' THEN
              LET g_axp[l_ac].axp05 = 0
              LET g_axp[l_ac].axp07 = 0
              CALL cl_set_comp_entry("axp05",FALSE)
              CALL cl_set_comp_entry("axp07",FALSE)
              DISPLAY g_axp[l_ac].axp05 TO axp05  
              DISPLAY g_axp[l_ac].axp07 TO axp07  
           ELSE
              CALL cl_set_comp_entry("axp05",TRUE)
              CALL cl_set_comp_entry("axp07",TRUE)
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_axp_t.axp02 > 0 AND
               g_axp_t.axp02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
 
                DELETE FROM axp_file
                 WHERE axp01 = g_axp01 AND axp02 = g_axp_t.axp02   #FUN-770069 mod
                   AND axp03 = g_axp03 AND axp04 = g_axp04 
                  #AND axp08 = g_axp08   #TQC-770095 mark
                  #AND axp09 = g_axp09   #TQC-770095 mark
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_axp_t.axp02,SQLCA.sqlcode,0)   #No.FUN-660123
                   CALL cl_err3("del","axp_file",g_axp01,g_axp_t.axp02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                   ROLLBACK WORK
                   CANCEL DELETE 
                ELSE
                   LET g_rec_b = g_rec_b-1
                   DISPLAY g_rec_b TO FORMONLY.cn2
                   COMMIT WORK
                END IF
            END IF
 
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_axp[l_ac].* = g_axp_t.*
               CLOSE i008_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_axp[l_ac].axp02,-263,1)
               LET g_axp[l_ac].* = g_axp_t.*
            ELSE
               UPDATE axp_file SET axp02 = g_axp[l_ac].axp02,
                                   axp05 = g_axp[l_ac].axp05,
                                   axp06 = g_axp[l_ac].axp06,
                                   axp07 = g_axp[l_ac].axp07, 
                                   axpmodu = g_user,
                                   axpdate = g_today
                WHERE axp01 = g_axp01 AND axp02 = g_axp_t.axp02
                  AND axp03 = g_axp03 AND axp04 = g_axp04 
                 #AND axp08 = g_axp08    #TQC-770095 mark
                 #AND axp09 = g_axp09    #TQC-770095 mark
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_axp[l_ac].axp02,SQLCA.sqlcode,0)   #No.FUN-660123
                  CALL cl_err3("upd","axp_file",g_axp01,g_axp_t.axp02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                  LET g_axp[l_ac].* = g_axp_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #LET g_axp[l_ac].* = g_axp_t.*   #FUN-D30032 mark
              #FUN-D30032--add--begin--
               IF p_cmd = 'u' THEN
                  LET g_axp[l_ac].* = g_axp_t.*
               ELSE
                  CALL g_axp.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               END IF
              #FUN-D30032--add--end----
               CLOSE i008_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032 add
            LET g_axp_t.* = g_axp[l_ac].*
            CLOSE i008_bcl
            COMMIT WORK
            CALL g_axp.deleteElement(g_rec_b+1)
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(axp02) AND l_ac > 1 THEN
              LET g_axp[l_ac].* = g_axp[l_ac-1].*
              LET g_axp[l_ac].axp02 = g_axp[l_ac-1].axp02 + 1 
              NEXT FIELD axp02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about        
           CALL cl_about()   
 
        ON ACTION help      
           CALL cl_show_help()  
#No.FUN-6B0029--begin                                             
        ON ACTION controls                                        
           CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
    END INPUT
 
    CLOSE i008_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i008_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_axp TO s_axp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()  
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION reproduce 
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION first 
         CALL i008_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY   
                              
      ON ACTION previous
         CALL i008_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY   
                              
      ON ACTION jump
         CALL i008_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY   
                              
      ON ACTION next
         CALL i008_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY   
                              
      ON ACTION last
         CALL i008_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY  
 
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
         CALL cl_show_fld_cont()        
 
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
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about    
         CALL cl_about() 
#FUN-A90034 --Begin
#更新平均匯率
      ON ACTION upd_avg_rate
         LET g_action_choice="upd_avg_rate"
         EXIT DISPLAY
#FUN-A90034 --End
 
   
#@    ON ACTION 相關文件  
      ON ACTION related_document 
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i008_copy()
DEFINE
    l_axp		RECORD LIKE axp_file.*,
    l_old01,l_new01     LIKE axp_file.axp01,
    l_old03,l_new03	LIKE axp_file.axp03,
    l_old04,l_new04	LIKE axp_file.axp04,
    l_oldck,l_newck	LIKE type_file.chr1,   #No.FUN-680098CHAR(1)
    l_old08,l_new08	LIKE axp_file.axp08,
    l_old09,l_new09	LIKE axp_file.axp09
 
    IF s_shut(0) THEN RETURN END IF
 
    IF cl_null(g_axp01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_set_head_visible("","YES")         #No.FUN-6B0029 
 
    INPUT l_new01,l_new03,l_new04,l_newck,l_new08,l_new09 FROM axp01,axp03,axp04,c,axp08,axp09
 
       BEFORE FIELD axp01
          LET l_newck = 'N'
          DISPLAY l_newck TO c 
 
       AFTER FIELD axp01
          IF NOT cl_null(l_new01) THEN
             SELECT count(*) INTO g_cnt FROM axp_file
              WHERE axp01 = l_new01 AND axp03 = l_new03 AND axp04 = l_new04
                AND axp08 = l_new08 AND axp09 = l_new09 
             IF g_cnt > 0 THEN
                CALL cl_err(l_new01,-239,0)
                NEXT FIELD axp01
             END IF
          END IF
 
       AFTER FIELD axp03
          IF NOT cl_null(l_new03) THEN
             SELECT count(*) INTO g_cnt FROM axp_file
              WHERE axp01 = l_new01 AND axp03 = l_new03 AND axp04 = l_new04
                AND axp08 = l_new08 AND axp09 = l_new09
             IF g_cnt > 0 THEN
                CALL cl_err(l_new01,-239,0)
                NEXT FIELD axp03
             END IF
          END IF
 
       AFTER FIELD axp04
          IF NOT cl_null(l_new04) THEN
             SELECT count(*) INTO g_cnt FROM axp_file
              WHERE axp01 = l_new01 AND axp03 = l_new03 AND axp04 = l_new04
                AND axp08 = l_new08 AND axp09 = l_new09
             IF g_cnt > 0 THEN
                CALL cl_err(l_new01,-239,0)
                NEXT FIELD axp04
             END IF
          END IF
 
        AFTER FIELD c 
            IF l_newck = 'Y' THEN
               CALL cl_set_comp_entry("axp08",TRUE)
               CALL cl_set_comp_entry("axp09",TRUE)
               NEXT FIELD axp08
            ELSE
               LET l_new08 = ' '
               LET l_new09 = ' '
               DISPLAY l_new08 TO axp08 
               DISPLAY l_new09 TO axp09 
               CALL cl_set_comp_entry("axp08",FALSE)
               CALL cl_set_comp_entry("axp09",FALSE)
            END IF
 
        AFTER FIELD axp08
          IF NOT cl_null(l_new08) THEN
             SELECT count(*) INTO g_cnt FROM axp_file
              WHERE axp01 = l_new01 AND axp03 = l_new03 AND axp04 = l_new04
                AND axp08 = l_new08 AND axp09 = l_new09
             IF g_cnt > 0 THEN
                CALL cl_err(l_new01,-239,0)
                NEXT FIELD axp08
             END IF
          END IF
 
        AFTER FIELD axp09
          IF NOT cl_null(l_new09) THEN
             SELECT count(*) INTO g_cnt FROM axp_file
              WHERE axp01 = l_new01 AND axp03 = l_new03 AND axp04 = l_new04
                AND axp08 = l_new08 AND axp09 = l_new09
             IF g_cnt > 0 THEN
                CALL cl_err(l_new01,-239,0)
                NEXT FIELD axp09
             END IF
          END IF
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about        
          CALL cl_about()    
 
       ON ACTION help     
          CALL cl_show_help() 
 
       ON ACTION controlg   
          CALL cl_cmdask() 
    
    END INPUT
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY g_axp01 TO axp01 
        RETURN
    END IF
 
    DROP TABLE x
 
    SELECT * 
      FROM axp_file         #單頭複製
     WHERE axp01 = g_axp01 AND axp03 = g_axp03 AND axp04 = g_axp04   
   #   AND axp08 = g_axp08 AND axp09 = g_axp09    #FUN-760053 mark
       INTO TEMP x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_axp01,SQLCA.sqlcode,0)   #No.FUN-660123
       CALL cl_err3("ins","x", g_axp01,g_axp03,SQLCA.sqlcode,"","",1)  #No.FUN-660123
       RETURN
    END IF
 
    UPDATE x
       SET axp01 = l_new01,axp03 = l_new03,axp04 = l_new04
   #       axp08 = l_new08,axp09 = l_new09   #FUN-760053 mark
 
    INSERT INTO axp_file
       SELECT * FROM x
    IF SQLCA.sqlcode THEN
#      CALL cl_err('axp:',SQLCA.sqlcode,0)   #No.FUN-660123
       CALL cl_err3("ins","axp_file",l_new01,l_new03,SQLCA.sqlcode,"","axp",1)  #No.FUN-660123
       RETURN
    END IF
 
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_new01,') O.K'
        
    LET l_old01 = g_axp01 
    LET l_old03 = g_axp03 
    LET l_old04 = g_axp04 
   #LET l_old08 = g_axp08    #FUN-760053 mark
   #LET l_old09 = g_axp09    #FUN-760053 mark
 
    SELECT unique axp01,axp03,axp04,axp08,axp09 
      INTO g_axp01,g_axp03,g_axp04,g_axp08,g_axp09
      FROM axp_file 
     WHERE axp01 = l_new01 AND axp03 = l_new03 AND axp04 = l_new04 
   #   AND axp08 = l_new08 AND axp09 = l_new09    #FUN-760053 mark
 
    CALL i008_b()
 
   #SELECT unique axp01,axp03,axp04,axp08,axp09      #FUN-760053 mark
   #  INTO g_axp01,g_axp03,g_axp04,g_axp08,g_axp09   #FUN-760053 mark
    #FUN-C30027---begin
    #SELECT unique axp01,axp03,axp04 INTO g_axp01,g_axp03,g_axp04                               #FUN-760053
    #  FROM axp_file 
    # WHERE axp01 = l_old01 AND axp03 = l_old03 AND axp04 = l_old04
    #FUN-C30027---end
   #   ANd axp08 = l_old08 AND axp09 = l_old09   #FUN-760053 mark
 
    CALL i008_show()
 
END FUNCTION
 
#No.FUN-780037---Begin
{
FUNCTION i008_out()
    DEFINE
        l_name          LIKE type_file.chr20,   # External(Disk) file name    #No.FUN-680098char(20)
        l_axp           RECORD LIKE axp_file.*
 
    IF g_wc IS NULL THEN
   #    CALL cl_err('',-400,0) 
        CALL cl_err('','9057',0)
        RETURN
    END IF
 
    CALL cl_wait()
    CALL cl_outnam('agli008') RETURNING l_name
 
    SELECT zo02 INTO g_company 
      FROM zo_file 
     WHERE zo01 = g_lang
 
   #SELECT zz17,zz05 INTO g_len,g_zz05  #FUN-720012 mark
    SELECT zz05 INTO g_zz05             #FUN-720012 mod
      FROM zz_file 
     WHERE zz01 = 'agli008'
 
    IF g_len = 0 OR g_len IS NULL THEN 
       LET g_len = 80 
    END IF
 
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR 
 
    LET g_sql="SELECT * FROM axp_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE i008_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i008_co  CURSOR FOR i008_p1
 
    START REPORT i008_rep TO l_name
 
    FOREACH i008_co INTO l_axp.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i008_rep(l_axp.*)
    END FOREACH
 
    FINISH REPORT i008_rep
 
    CLOSE i008_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i008_rep(sr)
    DEFINE
        l_trailer_sw   LIKE type_file.chr1,             #No.FUN-680098 VARCHAR(1)
        sr RECORD LIKE axp_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.axp01,sr.axp03,sr.axp04,sr.axp08,sr.axp09,sr.axp02
 
    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
            PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
                COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39]
            PRINT g_dash1 
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
           PRINT COLUMN g_c[31],sr.axp01, 
                 COLUMN g_c[32],sr.axp03,
                 COLUMN g_c[33],sr.axp04,
                #COLUMN g_c[38],sr.axp08,  #FUN-720012 mark
                #COLUMN g_c[39],sr.axp09,  #FUN-720012 mark
                 COLUMN g_c[34],sr.axp02,
                 COLUMN g_c[35],sr.axp05,
                 COLUMN g_c[36],sr.axp06,
                 COLUMN g_c[37],sr.axp07,
                 COLUMN g_c[38],sr.axp08,
                 COLUMN g_c[39],sr.axp09
 
        ON LAST ROW
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
END REPORT}
#NO.FUN-780037---End
#FUN-A90034 --Begin
FUNCTION i008_upd_avg_rate()
DEFINE l_wc      LIKE type_file.chr1000
DEFINE l_wc1     LIKE type_file.chr1000
DEFINE l_axp02   LIKE axp_file.axp02
DEFINE l_azk041  LIKE azk_file.azk041
DEFINE l_bdate   LIKE type_file.dat
DEFINE l_edate   LIKE type_file.dat
DEFINE l_axp07   LIKE axp_file.axp07
DEFINE l_axp07_1 LIKE axp_file.axp07


   OPEN WINDOW i008_w1
     WITH FORM "agl/42f/agli0081"  ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("agli0081")

   CONSTRUCT l_wc ON axp02 FROM mm
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT

       ON ACTION about
          CALL cl_about()

       ON ACTION help
          CALL cl_show_help()

       ON ACTION controlg
          CALL cl_cmdask()
   END CONSTRUCT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW i008_w1
      RETURN
   END IF

   CLOSE WINDOW i008_w1

   LET g_sql="SELECT axp02 ",
             "  FROM axp_file ",
             " WHERE axp01 = ",g_axp01,
             "   AND axp03 = '",g_axp03,"'",
             "   AND axp04 = '",g_axp04,"'",
             "   AND ",l_wc
   PREPARE i008_pre_axp FROM g_sql
   DECLARE i008_cs_axp CURSOR FOR i008_pre_axp
   DECLARE i008_cs_axp1 SCROLL CURSOR FOR i008_pre_axp
   EXECUTE i008_cs_axp1 INTO l_axp02
   IF SQLCA.SQLCODE <> 100 THEN
      IF cl_confirm('agl-197') THEN
         FOREACH i008_cs_axp INTO l_axp02

            INITIALIZE l_axp07 TO NULL
            INITIALIZE l_axp07_1 TO NULL
            LET l_bdate = MDY(l_axp02,1,g_axp01)
            LET l_edate = s_last(l_bdate)
            IF g_axp04 = g_aza.aza17 THEN
                SELECT SUM(azk041)/COUNT(*)
                  INTO l_axp07
                  FROM azk_file 
                 WHERE azk01 = g_axp03
                   AND azk02 BETWEEN l_bdate AND l_edate
                   AND azk041 IS NOT NULL
                   AND azk041 != 0
            ELSE
            #目的幣別<> 本幣時，要將來源/目的幣別都分別與本幣換算後，相除
                SELECT SUM(azk041)/COUNT(*)
                  INTO l_axp07
                  FROM azk_file 
                 WHERE azk01 = g_axp03
                   AND azk02 BETWEEN l_bdate AND l_edate
                   AND azk041 IS NOT NULL
                   AND azk041 != 0
               SELECT SUM(azk041)/COUNT(*)
                 INTO l_axp07_1
                 FROM azk_file 
                WHERE azk01 = g_axp04
                  AND azk02 BETWEEN l_bdate AND l_edate
                  AND azk041 IS NOT NULL
                  AND azk041 != 0
               LET l_axp07 = l_axp07/l_axp07_1
            END IF
            IF NOT cl_null(l_axp07) THEN
               UPDATE axp_file set axp07 = l_axp07 
                WHERE axp01 = g_axp01
                  AND axp02 = l_axp02
                  AND axp03 = g_axp03
                  AND axp04 = g_axp04 
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","axp_file",g_axp01,l_axp02,SQLCA.sqlcode,"","",1)
               END IF
            END IF
         END FOREACH
      END IF
   END IF
   CALL cl_replace_str(l_wc,"axp02","MONTH(azk02)") RETURNING l_wc1
   LET g_sql=" SELECT SUM(azk041)/COUNT(*),MONTH(azk02)",
             "   FROM azk_file ",
             "  WHERE azk01 = '",g_axp03,"'",
             "    AND YEAR(azk02) = ",g_axp01,
             "    AND azk041 IS NOT NULL ",
             "    AND azk041 != 0 ",
             "    AND ",l_wc1,
             "    AND MONTH(azk02) NOT IN ",
             "      ( SELECT axp02 FROM axp_file ",
             "         WHERE axp01 = '",g_axp01,"'",
             "           AND axp03 = '",g_axp03,"'",
             "           AND axp04 = '",g_axp04,"'",
             "           AND ",l_wc,")",
             " GROUP BY MONTH(azk02)"
   PREPARE i008_pre_azk FROM g_sql
   DECLARE i008_cs_azk CURSOR FOR i008_pre_azk
   FOREACH i008_cs_azk INTO l_axp07,l_axp02
      LET l_bdate = MDY(l_axp02,1,g_axp01)
      LET l_edate = s_last(l_bdate)
      IF g_axp03 <> g_aza.aza17 THEN
         INITIALIZE l_axp07_1 TO NULL
         SELECT SUM(azk041)/COUNT(*)
           INTO l_axp07_1
           FROM azk_file 
          WHERE azk01 = g_axp04
            AND azk02 BETWEEN l_bdate AND l_edate
            AND azk041 IS NOT NULL
            AND azk041 != 0

         LET l_axp07 = l_axp07/l_axp07_1
      END IF
      IF NOT cl_null(l_axp07) THEN
         INSERT INTO axp_file(axp01,axp02,axp03,axp04,axp05,axp06,axp07,
                              axp08,axp09,axpuser,axpgrup,axpmodu,axpdate,
                              axpconf,axppost,axpacti)
                       VALUES(g_axp01,l_axp02,g_axp03,g_axp04,1,1,
                              l_axp07,' ',' ',g_user,
                              g_grup,g_user,g_today,'N','N','Y')
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","axp_file",g_axp01,l_axp02,SQLCA.sqlcode,"","",1)
         END IF
      END IF
   END FOREACH
   CALL i008_b_fill(g_wc)             #單身
   
END FUNCTION
#FUN-A90034 --End
