DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm          RECORD
               #wc   LIKE type_file.chr1000, # Head Where condition  #No.FUN-690026 VARCHAR(500)   #MOD-B90146 mark
               #wc2  LIKE type_file.chr1000  # Body Where condition  #No.FUN-690026 VARCHAR(500)   #MOD-B90146 mark
                wc   STRING,                 #MOD-B90146
                wc2  STRING                  #MOD-B90146
                END RECORD,
    g_cxm       DYNAMIC ARRAY OF RECORD
                oga02  LIKE oga_file.oga02,
                oga69  LIKE oga_file.oga69,  #tianry add 170215
                oga01  LIKE oga_file.oga01,
                oga032 LIKE oga_file.oga032,
                ogb04  LIKE ogb_file.ogb04,
                ogb06  LIKE ogb_file.ogb06,
                ogb05  LIKE ogb_file.ogb05,
                ogb12  LIKE ogb_file.ogb12,
                ogb31  LIKE ogb_file.ogb31,
                ogb13  LIKE ogb_file.ogb13,
                sum1   LIKE ogb_file.ogb13,
                tran_1 LIKE occ_file.occ02,
                tran_no LIKE oga_file.oga01,
                occ02  LIKE occ_file.occ02,
                oga24  LIKE oga_file.oga24,
                oeb13 LIKE oeb_file.oeb13,
                diference1 LIKE ogb_file.ogb13,
                ogapost  LIKE oga_file.ogapost,  #add by huanglf161104
                oga23    LIKE oga_file.oga23,
                ogbud02  LIKE ogb_file.ogbud02,   #tianry add 161205
                ogaud03  LIKE oga_file.ogaud03,    #tianry add 161205
                ogaud01  LIKE oga_file.ogaud01     #tianry add 161216
                END RECORD,
    l_ac        LIKE type_file.num5,
    g_cxm03     LIKE qcs_file.qcs03,
    g_qcu04     LIKE qcu_file.qcu04,
    g_qct08     LIKE qct_file.qct08,
    g_argv1     LIKE imd_file.imd01,      #INPUT ARGUMENT - 1
    g_sql       string,                   #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b     LIKE type_file.num5       #單身筆數  #No.FUN-690026 SMALLINT
DEFINE g_wc            STRING
DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
 
DEFINE g_row_count     LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index    LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5    #No.FUN-690026 SMALLINT
MAIN
#     DEFINE   l_time LIKE type_file.chr8     #No.FUN-6A0074
   DEFINE       l_sl   LIKE type_file.num5       #No.FUN-690026 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CXM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580ET 088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074

    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW cxmq002_w AT p_row,p_col
         WITH FORM "cxm/42f/cxmq002"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#    IF cl_chk_act_auth() THEN
#       CALL q002_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q002_q() END IF
    CALL q002_menu()
    CLOSE WINDOW cxmq002_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
  
 
FUNCTION q002_menu()
 
   WHILE TRUE
      CALL q002_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q002_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cxm),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

 
FUNCTION q002_q()    
    CLEAR FORM
    CALL g_cxm.clear()
     CONSTRUCT g_wc ON                     # 螢幕上取條件  #huanglf161104
        oga02,oga69,oga01,oga032,ogb04,ogb06,ogb05,ogb12,ogb31,ogb13,sum1,tran_1,tran_no,occ02,oga24,sfvud07,diference1,ogapost,oga23,ogbud02,ogaud03,ogaud01   #tianry add 161205
        FROM s_cxm[1].oga02,s_cxm[1].oga69,s_cxm[1].oga01,s_cxm[1].oga032,s_cxm[1].ogb04,s_cxm[1].ogb06,s_cxm[1].ogb05,
        s_cxm[1].ogb12,s_cxm[1].ogb31,s_cxm[1].ogb13,s_cxm[1].sum1,s_cxm[1].tran_1,s_cxm[1].tran_no,
        s_cxm[1].occ02,s_cxm[1].oga24,s_cxm[1].oeb13,s_cxm[1].diference1,s_cxm[1].ogapost,s_cxm[1].oga23, #tianry add 161121
        s_cxm[1].ogbud02,s_cxm[1].ogaud03,s_cxm[1].ogaud01   #tianry add 161205  ogbud02&ogaud03
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

        ON ACTION controlp
           CASE
              WHEN INFIELD(oga01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oga7"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = '2' 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oga01
                 NEXT FIELD oga01
              
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

                 ON ACTION qbe_select
                   CALL cl_qbe_select()
                 ON ACTION qbe_save
                   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL q002_b_fill(g_wc)
END FUNCTION
 
 
FUNCTION q002_b_fill(p_wc2)              #BODY FILL UP
  #DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)   #MOD-B90146 mark
   DEFINE l_sql     STRING
   DEFINE l_sql1    STRING
   DEFINE p_wc2  STRING
   DEFINE l_qcs03  LIKE qcs_file.qcs03
   DEFINE l_qce03  LIKE qce_file.qce03
   DEFINE l_qcs09  LIKE qcs_file.qcs09
   DEFINE l_qcu04  LIKE qcu_file.qcu04
   DEFINE l_n      LIKE type_file.num5
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_str   STRING
   DEFINE l_chr   LIKE type_file.chr20

   LET l_sql =                                                                                                        #tianry add 
        "SELECT oga02,oga69,oga01,oga032,ogb04,ogb06,ogb05,ogb12,ogb31,ogb13,'',ogaud04,ogaud05,occ02,oga24,oeb13,'',ogapost,oga23,ogbud02,ogaud03,ogaud01  ",  #MOD-6A0130 modify
        " FROM  oga_file LEFT JOIN occ_file ON occ01=oga04 ",  #FUN-640006   #No.TQC-780080 add
        " ,ogb_file LEFT JOIN oeb_file ON ogb31=oeb01 and ogb03=oeb03 ",
        " WHERE ",p_wc2 CLIPPED,
        " and oga01 = ogb01 and oga09='2' AND ogaconf!='X' ",
        " ORDER BY oga01 "
    PREPARE q002_pb FROM l_sql
    DECLARE q002_bcs                       #BODY CURSOR
        CURSOR FOR q002_pb
    CALL g_cxm.clear()
    LET g_cnt = 1
    FOREACH q002_bcs INTO g_cxm[g_cnt].*
     
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
    LET g_cxm[g_cnt].sum1 = g_cxm[g_cnt].ogb12 * g_cxm[g_cnt].ogb13
    LET g_cxm[g_cnt].diference1 = g_cxm[g_cnt].ogb13 - g_cxm[g_cnt].oeb13
        LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_cxm.deleteElement(g_cnt)      #No:MMOD-810252 add
    LET g_rec_b=g_cnt-1                  #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q002_bp(p_ud)
 DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
            
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cxm TO s_cxm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
                 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
              
      #ON ACTION detail
      #   LET g_action_choice="detail"
      #   LET l_ac = 1
      #   EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
      #ON ACTION accept
      #   LET g_action_choice="detail"
      #   LET l_ac = ARR_CURR()
      #   EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE          #MOD-570244  mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
         
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
         
      AFTER DISPLAY
         CONTINUE DISPLAY
         
      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
      
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
