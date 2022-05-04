# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#
# Pattern name...: ghri044_p3.4gl
# Descriptions...: 批量年休
# Date & Author..: 13/07/15 By yangjian
# Modify..........: No.130912 13/09/12 by wangxh 程序无法运行
# Modify.........: NO.130912 13/09/12 By wangxh 将部门，职位，状态修改成显示名称;
 
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
     g_hrch   DYNAMIC ARRAY OF RECORD
        hrch13      LIKE hrch_file.hrch13,
        hrch14      LIKE hrch_file.hrch14,
        hrch08      LIKE hrch_file.hrch08,
        hrch15      LIKE hrch_file.hrch15,
        hrch17      LIKE hrch_file.hrch17,
        hrch04      LIKE hrch_file.hrch04,
        hrch06      LIKE hrch_file.hrch06,
        hrch07      LIKE hrch_file.hrch07,
        hrch09      LIKE hrch_file.hrch09,
        hrch20      LIKE hrch_file.hrch20,
        hrch10      LIKE hrch_file.hrch10,
        hrch21      LIKE hrch_file.hrch21,
        hrch11      LIKE hrch_file.hrch11,
        hrch22      LIKE hrch_file.hrch22,
        hrch18      LIKE hrch_file.hrch18
                    END RECORD
DEFINE  g_rec_b   LIKE   type_file.num10
DEFINE  l_ac      LIKE   type_file.num5
DEFINE  g_cnt     LIKE   type_file.num5         
DEFINE  g_sql     STRING
DEFINE  g_h,g_m   LIKE   type_file.num5
                                     
FUNCTION sghri044_p3()
 DEFINE p_row,p_col  LIKE  type_file.num5
 DEFINE l_n          LIKE  type_file.num5
 DEFINE l_msg        LIKE  type_file.chr1000

    WHENEVER ERROR CONTINUE 
    LET g_success = 'Y'
    LET p_row = 5 LET p_col = 22
    OPEN WINDOW i044_w_p3 AT p_row,p_col WITH FORM "ghr/42f/ghri044_p3"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
    CALL cl_set_label_justify("i044_w_p3","right")

   INITIALIZE g_hrcd.*,g_hrcd_o.*,g_hrcd_t.* ,g_hrat_o.*,g_hrat_t.* TO NULL
   CALL g_hrat.clear()
   CALL g_hrch.clear()
   
   LET g_rec_b = 0
   LET g_action_choice = " "
   
   WHILE TRUE
   CALL cl_set_act_visible("accept,cancel",FALSE) 
   DIALOG ATTRIBUTES(UNBUFFERED)
         DISPLAY ARRAY g_hrat TO s_hrat.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
            IF l_ac > 0 THEN 
            	 CALL sghri044_p3_fill(g_hrcd.hrcd01,g_hrat[l_ac].hrat01)
            END IF 
            CALL cl_show_fld_cont()                  
         
      END DISPLAY
      
      DISPLAY ARRAY g_hrch TO s_hrch.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE ROW
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      END DISPLAY
      
      ON ACTION insert
         LET g_action_choice="insert"
         IF cl_chk_act_auth() THEN
            CALL sghri044_p3_a()
         END IF
         EXIT DIALOG
         
      ON ACTION detail
         LET g_action_choice = "detail"
         IF cl_chk_act_auth() THEN
         	  CALL sghri044_p3_b()
         END IF 
         EXIT DIALOG
         
      ON ACTION accept
         LET g_action_choice = "detail"
         IF cl_chk_act_auth() THEN
            CALL sghri044_p3_b()
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
            CALL sghri044_p3_group_insert()
         END IF 
      ON ACTION done_exit
         LET g_action_choice="done_exit"
         IF cl_chk_act_auth() THEN
            CALL sghri044_p3_insert()
            EXIT DIALOG
         END IF 
         
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
   CLOSE WINDOW i044_w_p3 

END FUNCTION 

FUNCTION sghri044_p3_a()
 DEFINE l_hrcd01_name  LIKE  hrbm_file.hrbm04
 DEFINE l_hrbm05       LIKE  hrbm_file.hrbm05
  
 IF cl_null(g_hrcd.hrcd02) THEN  LET g_hrcd.hrcd02 = g_today END IF
 IF cl_null(g_hrcd.hrcd03) THEN  LET g_hrcd.hrcd03 = "00:00" END IF   
 IF cl_null(g_hrcd.hrcd04) THEN  LET g_hrcd.hrcd04 = g_today END IF 
 IF cl_null(g_hrcd.hrcd05) THEN  LET g_hrcd.hrcd05 = "00:00" END IF 
           
 WHILE TRUE 
   CALL cl_set_act_visible("accept,cancel",TRUE)
   DISPLAY BY NAME g_hrcd.hrcd01,g_hrcd.hrcd02,g_hrcd.hrcd03,g_hrcd.hrcd04,g_hrcd.hrcd05,
                   g_hrcd.hrcd06,g_hrcd.hrcd07,g_hrcd.hrcd12
   INPUT BY NAME
      g_hrcd.hrcd01,g_hrcd.hrcd02,g_hrcd.hrcd03,g_hrcd.hrcd04,g_hrcd.hrcd05,g_hrcd.hrcd06,
      g_hrcd.hrcd07,g_hrcd.hrcd12
      WITHOUT DEFAULTS  
      
      BEFORE INPUT
        
          CALL sghri044_p3_set_entry('a')
          CALL sghri044_p3_set_no_entry('a')
          
      AFTER FIELD hrcd01
            IF NOT cl_null(g_hrcd.hrcd01) THEN
               IF g_hrcd.hrcd01 != g_hrcd_t.hrcd01 OR
                  g_hrcd_t.hrcd01 IS NULL THEN
                  CALL sghri044_p3_hrcd01('a') RETURNING g_hrcd.hrcd11,l_hrcd01_name,g_hrcd.hrcd07
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
#                 LET g_hrcd.hrcd06 = g_hrcd.hrcd04 - g_hrcd.hrcd02 + 1 
          	 	   DISPLAY BY NAME g_hrcd.hrcd04,g_hrcd.hrcd06
             END IF
          END IF
          
       AFTER FIELD hrcd04
          IF NOT cl_null(g_hrcd.hrcd04) THEN
             IF g_hrcd.hrcd04 < g_hrcd.hrcd02 THEN
                CALL cl_err('','ghr-107',0)
                NEXT FIELD hrcd04
             END IF
#             LET g_hrcd.hrcd06 = g_hrcd.hrcd04 - g_hrcd.hrcd02 + 1 
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
       AFTER FIELD hrcd07
           IF NOT cl_null(g_hrcd.hrcd07) THEN
           	  IF NOT (g_hrcd.hrcd07 ='001' OR g_hrcd.hrcd07 ='002') THEN 
           	  	 CALL cl_err('','ghr-150',0)
           	  	 LET g_hrcd.hrcd07 = g_hrcd_t.hrcd07
           	  	 DISPLAY BY NAME g_hrcd.hrcd07
           	  	 NEXT FIELD hrcd07
           	   END IF 
           END IF                              
       
       ON ACTION controlp
           CASE WHEN INFIELD(hrcd01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_hrbm033"
                   LET g_qryparam.default1 = g_hrcd.hrcd01
                   LET g_qryparam.arg1 = "('006')"
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
    
    CALL sghri044_p3_b()
    EXIT WHILE
 END WHILE
 
END FUNCTION

FUNCTION sghri044_p3_b()  
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
               CALL sghri044_p3_set_b_entry(p_cmd)                                       
               CALL sghri044_p3_set_b_no_entry(p_cmd)                                    
               LET g_hrat_t.* = g_hrat[l_ac].*  #BACKUP
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            
        BEFORE INSERT
           LET g_success = 'Y'
           LET p_cmd='a'
           CALL sghri044_p3_set_b_entry(p_cmd)                                           
           CALL sghri044_p3_set_b_no_entry(p_cmd)                                        
           INITIALIZE g_hrat[l_ac].* TO NULL     
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD hrat01
           
       AFTER FIELD hrat01
            IF NOT cl_null(g_hrat[l_ac].hrat01) THEN
               IF g_hrat[l_ac].hrat01 != g_hrat_t.hrat01 OR
                  g_hrat_t.hrat01 IS NULL THEN
                  CALL sghri044_p3_hrat01('a') RETURNING g_hrat[l_ac].hrat02,g_hrat[l_ac].hrat04,
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
            CALL g_hrch.clear()
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
                      CALL sghri044_p3_mulit(g_mulit_hrat)
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

FUNCTION sghri044_p3_fill(p_hrcda03,p_hrcda04)
 DEFINE p_hrcda03  LIKE  hrcda_file.hrcda03
 DEFINE p_hrcda04  LIKE  hrcda_file.hrcda04

   CALL g_hrch.clear()
   LET p_hrcda04 = i044_hrat012hratid(p_hrcda04)
   
   IF cl_null(p_hrcda04) THEN RETURN END IF 
   LET g_sql = "SELECT hrch13,hrch14,hrch08,hrch15,hrch17,hrch04,hrch06,hrch07,",
               "       hrch09,hrch20,hrch10,hrch21,hrch11,hrch22,hrch18 ",
               "       FROM hrch_file ",
               " WHERE hrch03 = '",p_hrcda04,"' ",
               " ORDER BY hrch02 DESC ,hrch03 DESC "
   PREPARE sghri044_p3_fill_prep FROM g_sql
   DECLARE sghri044_p3_fill_cs CURSOR FOR sghri044_p3_fill_prep

   LET g_cnt = 1 
   FOREACH sghri044_p3_fill_cs INTO g_hrch[g_cnt].*
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF 
      
      LET g_cnt = g_cnt + 1 
   END FOREACH
   CALL g_hrch.deleteElement(g_cnt)
   
END FUNCTION

FUNCTION sghri044_p3_set_entry(p_cmd)
  DEFINE  p_cmd  LIKE  type_file.chr1
  
     CALL cl_set_comp_entry("hrcd01,hrcd02,hrcd03,hrcd04,hrcd05,hrcd06,hrcd12",TRUE)                                     
END FUNCTION 

FUNCTION sghri044_p3_set_no_entry(p_cmd)
  DEFINE  p_cmd  LIKE  type_file.chr1
  
END FUNCTION 

FUNCTION sghri044_p3_set_b_entry(p_cmd)
  DEFINE  p_cmd  LIKE  type_file.chr1
  
  CALL cl_set_comp_entry("hrat01",TRUE)                                     
END FUNCTION 

FUNCTION sghri044_p3_set_b_no_entry(p_cmd)
  DEFINE  p_cmd  LIKE  type_file.chr1
  
  CALL cl_set_comp_entry("hrat02,hrat04,hrat05,hrat25,hrat19",FALSE) 
END FUNCTION 


FUNCTION sghri044_p3_hrcd01(p_cmd)
 DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_hrbm02    LIKE hrbm_file.hrbm02
   DEFINE l_hrbm04    LIKE hrbm_file.hrbm04 
   DEFINE l_hrbm06    LIKE hrbm_file.hrbm06
   DEFINE l_hrbm07    LIKE hrbm_file.hrbm07
   DEFINE l_n         LIKE type_file.num5

   LET g_errno = NULL
   SELECT hrbm02,hrbm04,hrbm06,hrbm07 INTO l_hrbm02,l_hrbm04,l_hrbm06,l_hrbm07 FROM hrbm_file
    WHERE hrbm03=g_hrcd.hrcd01
      AND hrbm02 IN('006')
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

FUNCTION sghri044_p3_hrat01(p_cmd)
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


FUNCTION sghri044_p3_insert()
  DEFINE l_n,i    LIKE  type_file.num5
  DEFINE l_hrcd   RECORD  LIKE  hrcd_file.*
  DEFINE l_hrcda  RECORD  LIKE  hrcda_file.*
  
   LET g_success = 'Y'
   LET l_n = g_hrat.getLength()
   IF l_n = 0 THEN RETURN END IF 
   
   IF NOT cl_confirm('ghr-132') THEN RETURN END IF 
   CALL s_showmsg_init()
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
       LET l_hrcd.hrcd08 = 'Y'
       LET l_hrcd.hrcd11 = g_hrcd.hrcd11
       LET l_hrcd.hrcd12 = g_hrcd.hrcd12
       LET l_hrcd.hrcdconf = 'N'
       LET l_hrcd.hrcduser = g_user
       LET l_hrcd.hrcdgrup = g_grup
       LET l_hrcd.hrcddate = g_today
       LET l_hrcd.hrcdmodu = g_user
       LET l_hrcd.hrcdoriu = g_user
       LET l_hrcd.hrcdorig = g_grup
       LET l_hrcd.hrcd09 = sghri044__hrat012hratid(g_hrat[i].hrat01)
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
          CONTINUE FOR
       END IF
       CALL sghri044_p3_insert_chk(l_hrcd.*) 
       IF g_success = 'N' THEN 
          CONTINUE FOR 
       END IF 

   END FOR
   IF g_success = 'Y' THEN 
   	  COMMIT WORK
   	  CALL cl_err('','abm-019',1)
   	  INITIALIZE g_hrcd.* TO NULL
   	  CALL g_hrat.clear()
   	  CALL g_hrch.clear()
   	  CLEAR FORM 
   ELSE 
      ROLLBACK WORK
      CALL s_showmsg()
      CALL cl_err('','abm-020',0)
   END IF 

END FUNCTION


FUNCTION sghri044_p3_mulit(p_mulit_hrat)
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


FUNCTION  sghri044_p3_group_insert()
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
    	 CALL g_hrch.clear()
    	 
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
    	 PREPARE sghri044_p3_group_insert_prep FROM g_sql
    	 DECLARE sghri044_p3_group_insert_cs CURSOR  FOR sghri044_p3_group_insert_prep
    	 LET g_cnt = 1 
    	 FOREACH sghri044_p3_group_insert_cs INTO g_hrat[g_cnt].*
    	    IF SQLCA.sqlcode THEN EXIT FOREACH END IF 
    	    
    	    LET g_cnt = g_cnt + 1 
       END FOREACH
       CALL g_hrat.deleteElement(g_cnt)
       LET g_cnt = 0
    END IF 

END FUNCTION 

FUNCTION sghri044_p3_insert_chk(p_hrcd)
  DEFINE p_hrcd  RECORD  LIKE hrcd_file.*
  DEFINE l_hrcf  RECORD  LIKE hrcf_file.*
  DEFINE  l_hrch    DYNAMIC ARRAY OF RECORD    
             ptype   LIKE type_file.chr1,
             hrch01  LIKE hrch_file.hrch01,
             hrch02  LIKE hrch_file.hrch02,
             hrch03  LIKE hrch_file.hrch03,
#130912 add by wangxh--str--
             hrch06  LIKE hrch_file.hrch06,
             hrch17  LIKE hrch_file.hrch17,
#130912 add by wangxh--end--
             hrch19  LIKE hrch_file.hrch19,
             l_day_umf  LIKE hrcc_file.hrcc03,
             l_day_unit LIKE hrcc_file.hrcc10
        END RECORD  
  DEFINE l_hrch_1  DYNAMIC ARRAY OF RECORD
            hrch01   LIKE  hrch_file.hrch01,
            hrch02   LIKE  hrch_file.hrch02,
            hrch03   LIKE  hrch_file.hrch03
             END RECORD
  DEFINE l_no  DYNAMIC ARRAY OF RECORD 
            no    LIKE  hrcdb_file.hrcdb03,
            day   LIKE  hrcdb_file.hrcdb04,
            unit  LIKE  hrcdb_file.hrcdb05,
            ytype LIKE type_file.chr1
             END RECORD               
  DEFINE l_n,i     LIKE  type_file.num5
  DEFINE l_nday  LIKE  type_file.num5
  DEFINE l_day   LIKE  type_file.dat
  DEFINE l_msg   STRING
  DEFINE l_hrat01  LIKE  hrat_file.hrat01
  DEFINE l_hrat02  LIKE  hrat_file.hrat02
  DEFINE l_hrch20  LIKE  hrch_file.hrch20
  DEFINE l_hrch21  LIKE  hrch_file.hrch21
  DEFINE l_hrch22  LIKE  hrch_file.hrch22
  DEFINE l_type    LIKE  type_file.chr1
  DEFINE l_res     BOOLEAN
  DEFINE l_end     LIKE  type_file.num5
  DEFINE l_umf_day  LIKE hrcd_file.hrcd06
  DEFINE l_avl_day  LIKE hrcd_file.hrcd06

   SELECT hrcf_file.* INTO l_hrcf.* FROM hrcf_file,hrat_file
    WHERE hrcf01 = hrat03
      AND hrcf02 = hrat04
      AND hratid = p_hrcd.hrcd09
   IF SQLCA.sqlcode = 100 THEN
      SELECT hrcf_file.* INTO l_hrcf.* FROM hrcf_file,hrat_file
       WHERE hrcf01 = hrat03
         AND hrcf02 = ' '
         AND hratid = p_hrcd.hrcd09
   END IF  
   LET l_end = p_hrcd.hrcd04 - p_hrcd.hrcd02  	  
   FOR l_n = 0 TO l_end STEP 1
      CALL l_hrch.clear()
      LET l_day = p_hrcd.hrcd02 + l_n
      CALL sghri044_p3_insertday_chk(p_hrcd.hrcd09,l_day,p_hrcd.hrcd06,p_hrcd.hrcd07,'') RETURNING l_res,l_hrch
      IF NOT l_res THEN
          SELECT hrat01,hrat02 INTO l_hrat01,l_hrat02 FROM hrat_file WHERE hratid = p_hrcd.hrcd09
          LET l_msg = l_day
          CALL s_errmsg('hrat01',l_hrat01||l_hrat02,l_msg,'ghr-141',1)
          LET g_success = 'N'
          EXIT FOR
      ELSE   
          CALL l_no.clear()
          FOR i =1  TO l_hrch.getLength()
             IF l_hrch[i].hrch19 IS NOT NULL THEN 
                LET l_no[i].no = l_hrch[i].hrch19
                LET l_no[i].day = l_hrch[i].l_day_umf
                LET l_no[i].unit = l_hrch[i].l_day_unit
                LET l_no[i].ytype = l_hrch[i].ptype
             END IF 
          END FOR
          IF l_no.getLength() > 0 THEN 
             CALL sghri044__split(p_hrcd.*,l_day,l_no)
          END IF 
          FOR i = 1 TO l_hrch.getLength()
             IF l_hrch[i].hrch19 IS NOT NULL THEN 
                CALL sghri044__umf(l_hrch[i].l_day_umf,l_hrch[i].l_day_unit,'001') RETURNING l_umf_day
                CASE l_hrch[i].ptype
                   WHEN '1'
                      UPDATE hrch_file SET hrch17 = hrch17 - l_umf_day,hrch06 = hrch06 - l_umf_day 
                       WHERE hrch01 = l_hrch[i].hrch01
                         AND hrch02 = l_hrch[i].hrch02
                         AND hrch03 = l_hrch[i].hrch03
                   WHEN '2'
                      LET l_hrch20=0   LET l_hrch21=0   LET l_hrch22=0
                      LET l_avl_day = l_umf_day
                      SELECT hrch20,hrch21,hrch22 INTO l_hrch20,l_hrch21,l_hrch22 
                        FROM hrch_file
                       WHERE hrch01 = l_hrch[i].hrch01
                         AND hrch02 = l_hrch[i].hrch02
                         AND hrch03 = l_hrch[i].hrch03
                      WHILE TRUE
                         IF l_avl_day <=0 THEN EXIT WHILE END IF 
                         #法定假
                         IF l_hrch20 >0 AND l_hrch20 >= l_avl_day THEN 
         	                  UPDATE hrch_file SET hrch17 = hrch17 - l_avl_day,hrch20 = hrch20 - l_avl_day
                             WHERE hrch01 = l_hrch[i].hrch01
                               AND hrch02 = l_hrch[i].hrch02
                               AND hrch03 = l_hrch[i].hrch03
                            LET l_avl_day = 0
                         ELSE 
         	                  UPDATE hrch_file SET hrch17 = hrch17 - l_hrch20,hrch20 = hrch20 - l_hrch20
                             WHERE hrch01 = l_hrch[i].hrch01
                               AND hrch02 = l_hrch[i].hrch02
                               AND hrch03 = l_hrch[i].hrch03
                            LET l_hrch20 = 0 
                            LET l_avl_day = l_avl_day - l_hrch20
                         END IF 
                         #福利假
                         IF l_hrch21 >0 AND l_hrch21 >= l_avl_day THEN 
         	                  UPDATE hrch_file SET hrch17 = hrch17 - l_avl_day,hrch21 = hrch21 - l_avl_day
                             WHERE hrch01 = l_hrch[i].hrch01
                               AND hrch02 = l_hrch[i].hrch02
                               AND hrch03 = l_hrch[i].hrch03
                            LET l_avl_day = 0
                         ELSE 
         	                  UPDATE hrch_file SET hrch17 = hrch17 - l_hrch21,hrch21 = hrch21 - l_hrch21
                             WHERE hrch01 = l_hrch[i].hrch01
                               AND hrch02 = l_hrch[i].hrch02
                               AND hrch03 = l_hrch[i].hrch03                      
                            LET l_hrch21 = 0 
                            LET l_avl_day = l_avl_day - l_hrch20
                         END IF  
                         #调整调
                         IF l_hrch22 >0 AND l_hrch22 >= l_avl_day THEN 
         	                  UPDATE hrch_file SET hrch17 = hrch17 - l_avl_day,hrch22 = hrch22 - l_avl_day
                             WHERE hrch01 = l_hrch[i].hrch01
                               AND hrch02 = l_hrch[i].hrch02
                               AND hrch03 = l_hrch[i].hrch03
                            LET l_avl_day = 0
                         ELSE 
         	                  UPDATE hrch_file SET hrch17 = hrch17 - l_hrch22,hrch22 = hrch22 - l_hrch22
                             WHERE hrch01 = l_hrch[i].hrch01
                               AND hrch02 = l_hrch[i].hrch02
                               AND hrch03 = l_hrch[i].hrch03                      
                            LET l_hrch22 = 0 
                            LET l_avl_day = l_avl_day - l_hrch22
                         END IF
                         IF l_avl_day > 0 THEN  
                         	  SELECT hrat01,hrat02 INTO l_hrat01,l_hrat02 FROM hrat_file WHERE hratid = p_hrcd.hrcd09
                             LET l_msg = l_day
                             CALL s_errmsg('hrat01',l_hrat01||l_hrat02,l_msg,'ghr-141',1)
                             LET g_success = 'N'
                             EXIT WHILE  
                         ELSE 
                             EXIT WHILE   
                         END IF                                                          	 
                      END WHILE
                END CASE 
                IF l_hrcf.hrcf26 = 'Y' THEN
                   CALL l_hrch_1.appendElement()
                   LET l_hrch_1[l_hrch_1.getLength()].hrch01 = l_hrch[i].hrch01
                   LET l_hrch_1[l_hrch_1.getLength()].hrch02 = l_hrch[i].hrch02
                   LET l_hrch_1[l_hrch_1.getLength()].hrch03 = l_hrch[i].hrch03
                END IF  
             END IF 
          END FOR 
      END IF
   END FOR
   FOR l_n = 1 TO l_hrch_1.getLength()
       UPDATE hrch_file SET hrch06 = 0,hrch20=0,hrch21=0,hrch22=0
        WHERE hrch01 = l_hrch_1[l_n].hrch01
          AND hrch02 = l_hrch_1[l_n].hrch02
          AND hrch03 = l_hrch_1[l_n].hrch03
   END FOR

END FUNCTION


