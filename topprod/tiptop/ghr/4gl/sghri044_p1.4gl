# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#
# Pattern name...: ghri044_p1.4gl
# Descriptions...: 请假整批录入
# Date & Author..: 13/07/05 By yangjian
# Modify.........: NO.130912 13/09/12 By wangxh 将部门，职位，状态修改成显示名称;
# Modify.........: NO.130912_1 13/09/12 By wangxh 请假时长做管控
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE  g_hrcd     RECORD  LIKE hrcd_file.*
DEFINE  g_hrcd_t   RECORD  LIKE hrcd_file.*
DEFINE  g_hrcd_o   RECORD  LIKE hrcd_file.*
DEFINE  g_hrat     DYNAMIC ARRAY OF RECORD
           hrat01   LIKE  hrat_file.hrat01,
           hrat02   LIKE  hrat_file.hrat02,
           hrat04   LIKE  hrat_file.hrat04,
           hrat05   LIKE  hrat_file.hrat05,
           hrat25   LIKE  hrat_file.hrat25,
           hrat19   LIKE  hrat_file.hrat19
             END  RECORD
DEFINE  g_hrat_t     RECORD
           hrat01   LIKE  hrat_file.hrat01,
           hrat02   LIKE  hrat_file.hrat02,
           hrat04   LIKE  hrat_file.hrat04,
           hrat05   LIKE  hrat_file.hrat05,
           hrat25   LIKE  hrat_file.hrat25,
           hrat19   LIKE  hrat_file.hrat19
             END  RECORD
DEFINE  g_hrat_o     RECORD
           hrat01   LIKE  hrat_file.hrat01,
           hrat02   LIKE  hrat_file.hrat02,
           hrat04   LIKE  hrat_file.hrat04,
           hrat05   LIKE  hrat_file.hrat05,
           hrat25   LIKE  hrat_file.hrat25,
           hrat19   LIKE  hrat_file.hrat19
             END  RECORD  ,
     g_mhrcda   DYNAMIC ARRAY OF RECORD
        hrcda05      LIKE hrcda_file.hrcda05,
        hrcda06      LIKE hrcda_file.hrcda06,
        hrcda07      LIKE hrcda_file.hrcda07,
        hrcda08      LIKE hrcda_file.hrcda08,
        hrcda09      LIKE hrcda_file.hrcda09,
        hrcda10      LIKE hrcda_file.hrcda10,
        hrcda15      LIKE hrcda_file.hrcda15
                    END RECORD,
     g_shrcda   DYNAMIC ARRAY OF RECORD
        hrcda05      LIKE hrcda_file.hrcda05,
        hrcda06      LIKE hrcda_file.hrcda06,
        hrcda07      LIKE hrcda_file.hrcda07,
        hrcda08      LIKE hrcda_file.hrcda08,
        hrcda09      LIKE hrcda_file.hrcda09,
        hrcda10      LIKE hrcda_file.hrcda10,
        hrcda15      LIKE hrcda_file.hrcda15
                    END RECORD,
     g_yhrcda   DYNAMIC ARRAY OF RECORD
        hrcda05      LIKE hrcda_file.hrcda05,
        hrcda06      LIKE hrcda_file.hrcda06,
        hrcda07      LIKE hrcda_file.hrcda07,
        hrcda08      LIKE hrcda_file.hrcda08,
        hrcda09      LIKE hrcda_file.hrcda09,
        hrcda10      LIKE hrcda_file.hrcda10,
        hrcda15      LIKE hrcda_file.hrcda15
                    END RECORD
DEFINE  g_rec_b   LIKE   type_file.num10
DEFINE  l_ac      LIKE   type_file.num5
DEFINE  g_cnt     LIKE   type_file.num5         
DEFINE  g_sql     STRING
DEFINE  g_h,g_m   LIKE   type_file.num5
                                     
FUNCTION sghri044_p1()
 DEFINE p_row,p_col  LIKE  type_file.num5
 DEFINE l_n          LIKE  type_file.num5
 DEFINE l_msg        LIKE  type_file.chr1000

    WHENEVER ERROR CONTINUE 
    LET g_success = 'Y'
    LET p_row = 5 LET p_col = 22
    OPEN WINDOW i044_w_p1 AT p_row,p_col WITH FORM "ghr/42f/ghri044_p1"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
    CALL cl_set_label_justify("i044_w_p1","right")

   INITIALIZE g_hrcd.*,g_hrcd_o.*,g_hrcd_t.* ,g_hrat_o.*,g_hrat_t.* TO NULL
   CALL g_hrat.clear()
   CALL g_mhrcda.clear()
   CALL g_shrcda.clear()
   CALL g_yhrcda.clear()
   
   LET g_rec_b = 0
   LET g_action_choice = " "
   
   WHILE TRUE
   CALL cl_set_act_visible("accept,cancel",FALSE) 
   DIALOG ATTRIBUTES(UNBUFFERED)
         DISPLAY ARRAY g_hrat TO s_hrat.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
            IF l_ac > 0 THEN 
            	 CALL sghri044_p1_msy_fill(g_hrcd.hrcd01,g_hrat[l_ac].hrat01)
            END IF 
            CALL cl_show_fld_cont()                  
         
      END DISPLAY
      
      DISPLAY ARRAY g_mhrcda TO s_mhrcda.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE ROW
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      END DISPLAY
      
      DISPLAY ARRAY g_shrcda TO s_shrcda.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE ROW
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      END DISPLAY   
      
      DISPLAY ARRAY g_yhrcda TO s_yhrcda.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE ROW
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      END DISPLAY   
      
      ON ACTION insert
         LET g_action_choice="insert"
         IF cl_chk_act_auth() THEN
            CALL sghri044_p1_a()
         END IF
         EXIT DIALOG
         
      ON ACTION detail
         LET g_action_choice = "detail"
         IF cl_chk_act_auth() THEN
            CALL sghri044_p1_b()
         END IF 
         EXIT DIALOG
         
      ON ACTION accept
         LET g_action_choice = "detail"
         IF cl_chk_act_auth() THEN
            CALL sghri044_p1_b()
         END IF 
         EXIT DIALOG
         
      ON ACTION close 
         LET g_action_choice="close"
         LET INT_FLAG = TRUE
         EXIT DIALOG
         
      ON ACTION exit
         LET g_action_choice="exit"
         LET INT_FLAG = TRUE
         EXIT DIALOG
         
      ON ACTION group_insert
         LET g_action_choice="group_insert"
         IF cl_chk_act_auth() THEN
            CALL sghri044_p1_group_insert()
         END IF 
      ON ACTION done_exit
         LET g_action_choice="done_exit"
         CALL sghri044_p1_insert()
         EXIT DIALOG
         
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         CALL cl_cmdask()    
         CONTINUE DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG  
 
      ON ACTION about     
         CALL cl_about()    
 
   END DIALOG
   CALL cl_set_act_visible("accept,cancel",TRUE)
   IF INT_FLAG THEN 
      LET INT_FLAG = 0
      EXIT WHILE
   END IF 
   END WHILE
   CLOSE WINDOW i044_w_p1 

END FUNCTION 

FUNCTION sghri044_p1_a()
 DEFINE l_hrcd01_name  LIKE  hrbm_file.hrbm04
 DEFINE l_hrbm05       LIKE  hrbm_file.hrbm05  #130912_1
  
 IF cl_null(g_hrcd.hrcd02) THEN  LET g_hrcd.hrcd02 = g_today END IF
 IF cl_null(g_hrcd.hrcd03) THEN  LET g_hrcd.hrcd03 = "00:00" END IF   
 IF cl_null(g_hrcd.hrcd04) THEN  LET g_hrcd.hrcd04 = g_today END IF 
 IF cl_null(g_hrcd.hrcd05) THEN  LET g_hrcd.hrcd05 = "00:00" END IF 
 IF cl_null(g_hrcd.hrcd08) THEN  LET g_hrcd.hrcd08 = 'Y'     END IF 
           
 WHILE TRUE 
   CALL cl_set_act_visible("accept,cancel",TRUE)
   DISPLAY BY NAME g_hrcd.hrcd01,g_hrcd.hrcd02,g_hrcd.hrcd03,g_hrcd.hrcd04,g_hrcd.hrcd05,
                   g_hrcd.hrcd06,g_hrcd.hrcd07,g_hrcd.hrcd08,g_hrcd.hrcd12
   INPUT BY NAME
      g_hrcd.hrcd01,g_hrcd.hrcd02,g_hrcd.hrcd03,g_hrcd.hrcd04,g_hrcd.hrcd05,g_hrcd.hrcd06,
      g_hrcd.hrcd07,g_hrcd.hrcd08,g_hrcd.hrcd12
      WITHOUT DEFAULTS  
      
      BEFORE INPUT
        
          CALL sghri044_p1_set_entry('a')
          CALL sghri044_p1_set_no_entry('a')
          
      AFTER FIELD hrcd01
            IF NOT cl_null(g_hrcd.hrcd01) THEN
               IF g_hrcd.hrcd01 != g_hrcd_t.hrcd01 OR
                  g_hrcd_t.hrcd01 IS NULL THEN
                  CALL sghri044_p1_hrcd01('a') RETURNING g_hrcd.hrcd11,l_hrcd01_name,g_hrcd.hrcd07
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_hrcd.hrcd01,g_errno,0)
                     NEXT FIELD hrcd01
                  END IF 
                  DISPLAY BY NAME g_hrcd.hrcd07
                  DISPLAY l_hrcd01_name TO hrcd01_name
               END IF
            END IF
            
       AFTER FIELD hrcd02
          IF NOT cl_null(g_hrcd.hrcd02) THEN
             IF g_hrcd.hrcd04 IS NULL OR g_hrcd.hrcd04 < g_hrcd.hrcd02 THEN 
                LET g_hrcd.hrcd04 = g_hrcd.hrcd02
                LET g_hrcd.hrcd06 = g_hrcd.hrcd04 - g_hrcd.hrcd02 + 1 
                DISPLAY BY NAME g_hrcd.hrcd04,g_hrcd.hrcd06
             END IF
          END IF
          
       AFTER FIELD hrcd04
          IF NOT cl_null(g_hrcd.hrcd04) THEN
             IF g_hrcd.hrcd04 < g_hrcd.hrcd02 THEN
                CALL cl_err('','ghr-107',0)
                NEXT FIELD hrcd04
             END IF
             LET g_hrcd.hrcd06 = g_hrcd.hrcd04 - g_hrcd.hrcd02 + 1 
             DISPLAY BY NAME g_hrcd.hrcd04,g_hrcd.hrcd06
          END IF        
          
       AFTER FIELD hrcd03
           IF NOT cl_null(g_hrcd.hrcd03) THEN
               LET g_h=''
               LET g_m=''
               LET g_h=g_hrcd.hrcd03[1,2]
               LET g_m=g_hrcd.hrcd03[4,5]
               IF cl_null(g_h) OR cl_null(g_m) OR g_h>23 OR g_m>59 THEN
                  CALL cl_err('','aec-053',0)
                  NEXT FIELD hrcd03
               END IF
               
            END IF

       AFTER FIELD hrcd05
           IF NOT cl_null(g_hrcd.hrcd05) THEN
               LET g_h=''
               LET g_m=''
               LET g_h=g_hrcd.hrcd05[1,2]
               LET g_m=g_hrcd.hrcd05[4,5]
               IF cl_null(g_h) OR cl_null(g_m) OR g_h>23 OR g_m>59 THEN
                  CALL cl_err('','aec-053',0)
                  NEXT FIELD hrcd05
               END IF
            END IF  
 #130912_1 add by wangxh --str--  
         AFTER FIELD hrcd06
             IF NOT cl_null(g_hrcd.hrcd06) THEN
                SELECT hrbm05 INTO l_hrbm05 FROM hrbm_file WHERE hrbm03=g_hrcd.hrcd01
                IF g_hrcd.hrcd06 MOD l_hrbm05<>0 THEN
                   CALL cl_err('','ghr-199',0)
                   NEXT FIELD hrcd06
                END IF                
             END IF
 
 #130912_1 add by wangxh --str--   
       
       ON ACTION controlp
           CASE WHEN INFIELD(hrcd01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_hrbm033"
                   LET g_qryparam.default1 = g_hrcd.hrcd01
                   LET g_qryparam.arg1 = "('004')"
                   CALL cl_create_qry() RETURNING g_hrcd.hrcd01
                   DISPLAY g_hrcd.hrcd01 TO hrcd01
                OTHERWISE
                   EXIT CASE
            END CASE
       
       AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            
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
    CALL cl_set_act_visible("accept,cancel",FALSE)
    IF INT_FLAG THEN 
       LET g_success = 'N'
       LET INT_FLAG = 0
       EXIT WHILE
    END IF 
    
    CALL sghri044_p1_b()
    EXIT WHILE
 END WHILE
 
END FUNCTION

FUNCTION sghri044_p1_b()  
 DEFINE  p_cmd  LIKE type_file.chr1  
 DEFINE  l_allow_insert,l_allow_delete   BOOLEAN
 DEFINE  g_mulit_hrat           STRING

    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
    IF g_hrcd.hrcd01 IS NULL THEN RETURN END IF 
    
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    CALL cl_set_act_visible("accept,cancel",TRUE)
    INPUT ARRAY g_hrat WITHOUT DEFAULTS FROM s_hrat.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
               CALL sghri044_p1_set_b_entry(p_cmd)                                       
               CALL sghri044_p1_set_b_no_entry(p_cmd)                                    
               LET g_hrat_t.* = g_hrat[l_ac].*  #BACKUP
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            
        BEFORE INSERT
           LET g_success = 'Y'
           LET p_cmd='a'
           CALL sghri044_p1_set_b_entry(p_cmd)                                           
           CALL sghri044_p1_set_b_no_entry(p_cmd)                                        
           INITIALIZE g_hrat[l_ac].* TO NULL     
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD hrat01
           
       AFTER FIELD hrat01
            IF NOT cl_null(g_hrat[l_ac].hrat01) THEN
               IF g_hrat[l_ac].hrat01 != g_hrat_t.hrat01 OR
                  g_hrat_t.hrat01 IS NULL THEN
                  CALL sghri044_p1_hrat01('a')  RETURNING g_hrat[l_ac].hrat02,g_hrat[l_ac].hrat04,
                                    g_hrat[l_ac].hrat05, g_hrat[l_ac].hrat25,g_hrat[l_ac].hrat19
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_hrat[l_ac].hrat01,g_errno,0)
                     NEXT FIELD hrat01
                  END IF 
               END IF
            END IF    
            
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            CALL g_mhrcda.clear()
            CALL g_shrcda.clear()
            CALL g_yhrcda.clear()
            LET g_rec_b=g_rec_b-1

        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrat[l_ac].* = g_hrat_t.*
              EXIT INPUT
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()         # 新增
 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_hrat[l_ac].* = g_hrat_t.*
              END IF
              EXIT INPUT
           END IF
           
        ON ACTION CONTROLG
            CALL cl_cmdask()
            
        ON ACTION controlp
              CASE 
                WHEN INFIELD(hrat01)
                   IF p_cmd = 'a' THEN 
                      LET g_mulit_hrat = NULL
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_hrat"
                      LET g_qryparam.state = "c"
                      CALL cl_create_qry() RETURNING g_mulit_hrat
                      DISPLAY g_mulit_hrat TO hrat01
                      CALL sghri044_p1_mulit(g_mulit_hrat)
                   ELSE 
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_hrat"
                      LET g_qryparam.default1 = g_hrat[l_ac].hrat01
                      CALL cl_create_qry() RETURNING g_hrat[l_ac].hrat01
                      DISPLAY g_hrat[l_ac].hrat01 TO hrat01
                   END IF 
                OTHERWISE
                   EXIT CASE
            END CASE
 
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
        
    END INPUT   
    CALL cl_set_act_visible("accept,cancel",FALSE)                                       
END FUNCTION 

FUNCTION sghri044_p1_msy_fill(p_hrcda03,p_hrcda04)
 DEFINE p_hrcda03  LIKE  hrcda_file.hrcda03
 DEFINE p_hrcda04  LIKE  hrcda_file.hrcda04

   CALL g_mhrcda.clear()
   CALL g_shrcda.clear()
   CALL g_yhrcda.clear()
   LET p_hrcda04 = i044_hrat012hratid(p_hrcda04)
   
   IF cl_null(p_hrcda04) THEN RETURN END IF 
   LET g_sql = "SELECT hrcda05,hrcda06,hrcda07,hrcda08,hrcda09,hrcda10,hrcda15 FROM hrcda_file ",
               " WHERE hrcda04 = '",p_hrcda04,"' ",
               "   AND hrcda03 = '",p_hrcda03,"' ",
               "   AND hrcda16 = 'N' ",
               "   AND hrcda17 = '4' "
   PREPARE sghri044_p1_m_prep FROM g_sql||" AND (TO_CHAR(hrcda05,'yyyy') = TO_CHAR(SYSDATE,'yyyy') OR TO_CHAR(hrcda07,'yyyy') = TO_CHAR(SYSDATE,'yyyy')) "||
                            " AND (TO_CHAR(hrcda05,'MM') = TO_CHAR(SYSDATE,'MM') OR TO_CHAR(hrcda07,'MM') = TO_CHAR(SYSDATE,'MM'))  "||
                            " ORDER BY 1,2,3,4"
   PREPARE sghri044_p1_s_prep FROM g_sql||" AND (TO_CHAR(hrcda05,'yyyy') = TO_CHAR(SYSDATE,'yyyy') OR TO_CHAR(hrcda07,'yyyy') = TO_CHAR(SYSDATE,'yyyy')) "||
                            " AND (TO_CHAR(hrcda05,'Q') = TO_CHAR(SYSDATE,'Q') OR TO_CHAR(hrcda07,'Q') = TO_CHAR(SYSDATE,'Q'))  "||
                            " AND NOT (TO_CHAR(hrcda05,'MM') = TO_CHAR(SYSDATE,'MM') OR TO_CHAR(hrcda07,'MM') = TO_CHAR(SYSDATE,'MM')) "||
                            " ORDER BY 1,2,3,4"
   PREPARE sghri044_p1_y_prep FROM g_sql||" AND (TO_CHAR(hrcda05,'yyyy') = TO_CHAR(SYSDATE,'yyyy') OR TO_CHAR(hrcda07,'yyyy') = TO_CHAR(SYSDATE,'yyyy')) "||
                            " AND NOT (TO_CHAR(hrcda05,'Q') = TO_CHAR(SYSDATE,'Q') OR TO_CHAR(hrcda07,'Q') = TO_CHAR(SYSDATE,'Q'))  "||
                            " ORDER BY 1,2,3,4"
   DECLARE sghri044_p1_m_cs CURSOR FOR sghri044_p1_m_prep
   DECLARE sghri044_p1_s_cs CURSOR FOR sghri044_p1_s_prep
   DECLARE sghri044_p1_y_cs CURSOR FOR sghri044_p1_y_prep

   LET g_cnt = 1 
   FOREACH sghri044_p1_m_cs INTO g_mhrcda[g_cnt].*
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF 
      
      LET g_cnt = g_cnt + 1 
   END FOREACH
   CALL g_mhrcda.deleteElement(g_cnt)
   
   LET g_cnt = 1 
   FOREACH sghri044_p1_s_cs INTO g_shrcda[g_cnt].*
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF 
      
      LET g_cnt = g_cnt + 1 
   END FOREACH
   CALL g_shrcda.deleteElement(g_cnt)
   
   LET g_cnt = 1 
   FOREACH sghri044_p1_y_cs INTO g_yhrcda[g_cnt].*
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF 
      
      LET g_cnt = g_cnt + 1 
   END FOREACH
   CALL g_yhrcda.deleteElement(g_cnt)   
END FUNCTION

FUNCTION sghri044_p1_set_entry(p_cmd)
  DEFINE  p_cmd  LIKE  type_file.chr1
  
     CALL cl_set_comp_entry("hrcd01,hrcd02,hrcd03,hrcd04,hrcd05,hrcd06,hrcd08,hrcd12",TRUE)                                     
END FUNCTION 

FUNCTION sghri044_p1_set_no_entry(p_cmd)
  DEFINE  p_cmd  LIKE  type_file.chr1
  
END FUNCTION 

FUNCTION sghri044_p1_set_b_entry(p_cmd)
  DEFINE  p_cmd  LIKE  type_file.chr1
  
  CALL cl_set_comp_entry("hrat01",TRUE)                                     
END FUNCTION 

FUNCTION sghri044_p1_set_b_no_entry(p_cmd)
  DEFINE  p_cmd  LIKE  type_file.chr1
  
  CALL cl_set_comp_entry("hrat02,hrat04,hrat05,hrat25,hrat19",FALSE) 
END FUNCTION 


FUNCTION sghri044_p1_hrcd01(p_cmd)
 DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_hrbm02    LIKE hrbm_file.hrbm02
   DEFINE l_hrbm04    LIKE hrbm_file.hrbm04 
   DEFINE l_hrbm06    LIKE hrbm_file.hrbm06
   DEFINE l_hrbm07    LIKE hrbm_file.hrbm07
   DEFINE l_n         LIKE type_file.num5

   LET g_errno = NULL
   SELECT hrbm02,hrbm04,hrbm06,hrbm07 INTO l_hrbm02,l_hrbm04,l_hrbm06,l_hrbm07 FROM hrbm_file
    WHERE hrbm03=g_hrcd.hrcd01
      AND hrbm02 IN('004')
    CASE
        WHEN SQLCA.sqlcode=100   LET g_errno='ghr-072'
                                 LET l_hrbm02=NULL LET l_hrbm04=NULL  LET l_hrbm06=NULL
   
        WHEN l_hrbm07='N'      LET g_errno='9028'
                                 LET l_hrbm02=NULL LET l_hrbm04=NULL  LET l_hrbm06=NULL
        OTHERWISE
             LET g_errno=SQLCA.sqlcode USING '------'
    END CASE
    CASE l_hrbm02 
      WHEN '004'  LET l_hrbm02 = '4'
      WHEN '006'  LET l_hrbm02 = '2'
      WHEN '010'  LET l_hrbm02 = '1'
      WHEN '011'  LET l_hrbm02 = '3'
      OTHERWISE     LET l_hrbm02 = NULL
    END CASE 
    RETURN l_hrbm02,l_hrbm04,l_hrbm06
END FUNCTION 

FUNCTION sghri044_p1_hrat01(p_cmd)
 DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_hrat02    LIKE hrat_file.hrat02
   DEFINE l_hrat04    LIKE hrat_file.hrat04
   DEFINE l_hrat05    LIKE hrat_file.hrat05
   DEFINE l_hrat25    LIKE hrat_file.hrat25
   DEFINE l_hrat19    LIKE hrat_file.hrat19   
   DEFINE l_hratconf  LIKE hrat_file.hratconf
   DEFINE l_n         LIKE type_file.num5

   LET g_errno = NULL
   SELECT hrat02,hrat04,hrat05,hrat25,hrat19,hratconf 
     INTO l_hrat02,l_hrat04,l_hrat05,l_hrat25,l_hrat19,l_hratconf 
     FROM hrat_file
    WHERE hrat01=g_hrat[l_ac].hrat01
    CASE
        WHEN SQLCA.sqlcode=100   LET g_errno='ghr-047'
                                 LET l_hrat02=NULL  LET l_hrat04=NULL  LET l_hrat05=NULL  LET l_hrat25=NULL   LET l_hrat19=NULL 
        WHEN l_hratconf='N'      LET g_errno='9029'
                                  LET l_hrat02=NULL  LET l_hrat04=NULL  LET l_hrat05=NULL  LET l_hrat25=NULL   LET l_hrat19=NULL 
        OTHERWISE
             LET g_errno=SQLCA.sqlcode USING '------'
    END CASE
    #130912 add by wangxh --str--
      IF NOT cl_null(l_hrat04) THEN
         SELECT hrao02 INTO l_hrat04 FROM hrao_file WHERE hrao01=l_hrat04
      END IF
      IF NOT cl_null(l_hrat05) THEN
         SELECT hras04 INTO l_hrat05 FROM hras_file WHERE hras01=l_hrat05
      END IF
      IF NOT cl_null(l_hrat19) THEN
         SELECT hrad03 INTO l_hrat19 FROM hrad_file WHERE hrad02=l_hrat19
      END IF
    #130912 add by wangxh --end--
    
    
    RETURN l_hrat02,l_hrat04,l_hrat05,l_hrat25,l_hrat19
END FUNCTION 


FUNCTION sghri044_p1_insert()
  DEFINE l_n,i    LIKE  type_file.num5
  DEFINE l_hrcd   RECORD  LIKE  hrcd_file.*
  DEFINE l_hrcda  RECORD  LIKE  hrcda_file.*
  
   LET g_success = 'Y'
   LET l_n = g_hrat.getLength()
   IF l_n = 0 THEN RETURN END IF 
   
   IF NOT cl_confirm('ghr-132') THEN RETURN END IF 
   BEGIN WORK
   FOR i =1 TO l_n
       INITIALIZE l_hrcd.* TO NULL
       LET l_hrcd.hrcd01 = g_hrcd.hrcd01
       LET l_hrcd.hrcd02 = g_hrcd.hrcd02
       LET l_hrcd.hrcd03 = g_hrcd.hrcd03
       LET l_hrcd.hrcd04 = g_hrcd.hrcd04
       LET l_hrcd.hrcd05 = g_hrcd.hrcd05
       LET l_hrcd.hrcd06 = g_hrcd.hrcd06
       LET l_hrcd.hrcd07 = g_hrcd.hrcd07
       LET l_hrcd.hrcd08 = g_hrcd.hrcd08
       LET l_hrcd.hrcd11 = g_hrcd.hrcd11
       LET l_hrcd.hrcd12 = g_hrcd.hrcd12
       LET l_hrcd.hrcdconf = 'N'
       LET l_hrcd.hrcduser = g_user
       LET l_hrcd.hrcdgrup = g_grup
       LET l_hrcd.hrcddate = g_today
       LET l_hrcd.hrcdmodu = g_user
       LET l_hrcd.hrcdoriu = g_user
       LET l_hrcd.hrcdorig = g_grup
       LET l_hrcd.hrcd09 = sghri044_p1_hrat012hratid(g_hrat[i].hrat01)
       SELECT to_char(MAX(hrcd10)+1,'fm0000000000000') INTO l_hrcd.hrcd10 FROM hrcd_file
       # WHERE to_date(substr(hrcd10,1,8),'yyyyMMdd') = g_today
       WHERE substr(hrcd10,1,8) = to_char(g_today,'yyyymmdd')
       IF cl_null(l_hrcd.hrcd10) THEN
       	  LET l_hrcd.hrcd10 = g_today USING 'yyyymmdd'||'00001'
       END IF  
       INSERT INTO hrcd_file VALUES(l_hrcd.*)
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","hrcd_file",l_hrcd.hrcd10,"",SQLCA.sqlcode,"","",1) 
          LET g_success = 'N'
          EXIT FOR
       ELSE  
          CALL sghri044__splitWithExpand(l_hrcd.hrcd10)
          IF g_success = 'N' THEN
             EXIT FOR
          END IF
       END IF
   END FOR
   IF g_success = 'Y' THEN 
   	  COMMIT WORK
   	  CALL cl_err('','abm-019',1)
   	  INITIALIZE g_hrcd.* TO NULL
   	  CALL g_hrat.clear()
   	  CALL g_mhrcda.clear()
   	  CALL g_shrcda.clear()
   	  CALL g_yhrcda.clear()
   	  CLEAR FORM 
   ELSE 
      ROLLBACK WORK
      CALL cl_err('','abm-020',1)
   END IF 

END FUNCTION

FUNCTION sghri044_p1_hrat012hratid(p_hrat01)
   DEFINE p_hrat01  LIKE  hrat_file.hrat01
   DEFINE l_hratid  LIKE  hrat_file.hratid
   
   SELECT hratid INTO l_hratid FROM hrat_file
    WHERE hrat01  = p_hrat01
   IF SQLCA.sqlcode THEN 
   	  LET l_hratid = NULL
   END IF 
   RETURN l_hratid
END FUNCTION 

FUNCTION sghri044_p1_mulit(p_mulit_hrat)
  DEFINE  p_mulit_hrat   STRING
  DEFINE  tok base.StringTokenizer
  DEFINE  l_hrat01       LIKE hrat_file.hrat01
  DEFINE  l_n            LIKE type_file.num5
  
  LET l_n = 1 
  LET tok = base.StringTokenizer.create(p_mulit_hrat,"|")
  WHILE tok.hasMoreTokens()
     LET l_hrat01 = tok.nextToken()
     IF l_n > 1 THEN 
        CALL g_hrat.appendElement()
     END IF 
     LET g_hrat[g_hrat.getLength()].hrat01 = l_hrat01
     CALL sghri044__hratinfo(l_hrat01) RETURNING 
        g_hrat[g_hrat.getLength()].hrat02,g_hrat[g_hrat.getLength()].hrat04,
        g_hrat[g_hrat.getLength()].hrat05,g_hrat[g_hrat.getLength()].hrat25,
        g_hrat[g_hrat.getLength()].hrat19
     LET l_n = l_n + 1 
  END WHILE
  
  DISPLAY ARRAY g_hrat  TO s_hrat.*
     BEFORE DISPLAY 
        EXIT DISPLAY 
        
  END DISPLAY 

END FUNCTION 


FUNCTION  sghri044_p1_group_insert()
  DEFINE  l_hrcka01  LIKE  hrcka_file.hrcka01
  DEFINE  l_hrcka02  LIKE  hrcka_file.hrcka02
  DEFINE  l_hrcka    RECORD LIKE hrcka_file.*

    IF cl_null(g_hrcd.hrcd01) THEN 
    	 CALL cl_err('','arm-019',1)
    	 RETURN
    END IF 
    CALL cl_set_act_visible("accept,cancel",TRUE)
    CALL cl_init_qry_var()
    LET g_qryparam.form = "q_hrcka"
    LET g_qryparam.default1 = l_hrcka01
    LET g_qryparam.default2 = l_hrcka02
    CALL cl_create_qry() RETURNING l_hrcka01,l_hrcka02
    CALL cl_set_act_visible("accept,cancel",FALSE)
    
    IF NOT cl_null(l_hrcka01) AND NOT cl_null(l_hrcka02) THEN 
    	 CALL g_hrat.clear() 
    	 CALL g_mhrcda.clear()  CALL g_shrcda.clear()   CALL  g_yhrcda.clear()
    	 
    	 SELECT * INTO l_hrcka.* FROM hrcka_file 
    	  WHERE hrcka01 = l_hrcka01
    	    AND hrcka02 = l_hrcka02  
    	    
    	 LET g_sql = "SELECT hrat01,hrat02,hrat04,hrat05,hrat25,hrat19 ",
    	             "  FROM hrat_file ",
    	             " WHERE 1=1 "
    	 IF l_hrcka.hrcka03 IS NOT NULL THEN
    	 	  LET g_sql = g_sql||
    	 	              " AND ",l_hrcka.hrcka03," ",l_hrcka.hrcka04," '",l_hrcka.hrcka05,"' "
    	 END IF  
    	 IF l_hrcka.hrcka06 IS NOT NULL THEN
    	 	  LET g_sql = g_sql||
    	 	              " AND ",l_hrcka.hrcka06," ",l_hrcka.hrcka07," '",l_hrcka.hrcka08,"' "
    	 END IF  
    	 IF l_hrcka.hrcka09 IS NOT NULL THEN
    	 	  LET g_sql = g_sql||
    	 	              " AND ",l_hrcka.hrcka09," ",l_hrcka.hrcka10," '",l_hrcka.hrcka11,"' "
    	 END IF  
    	 IF l_hrcka.hrcka12 IS NOT NULL THEN
    	 	  LET g_sql = g_sql||
    	 	              " AND ",l_hrcka.hrcka12," ",l_hrcka.hrcka13," '",l_hrcka.hrcka14,"' "
    	 END IF      	     	     	                    
    	 LET g_sql = g_sql || " ORDER BY hrat01 "
    	 PREPARE sghri044_p1_group_insert_prep FROM g_sql
    	 DECLARE sghri044_p1_group_insert_cs CURSOR  FOR sghri044_p1_group_insert_prep
    	 LET g_cnt = 1 
    	 FOREACH sghri044_p1_group_insert_cs INTO g_hrat[g_cnt].*
    	    IF SQLCA.sqlcode THEN EXIT FOREACH END IF 
    	    
    	    LET g_cnt = g_cnt + 1 
       END FOREACH
       CALL g_hrat.deleteElement(g_cnt)
       LET g_cnt = 0
    END IF 

END FUNCTION 

