# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcp312.4gl
# Descriptions...: 每月人工製費整批產生作業
# Date & Author..: 01/11/16 BY DS/P
# Modify.........: No.FUN-570153 06/03/14 By yiting 批次背景執行
# Modify.........: No.FUN-660103 06/06/21 By Sarah 3.1成本改善:製程成本分攤,增加寫入cax_file,caz_file
# Modify.........: No.FUN-660201 06/06/29 By Sarah caz05計算有誤(需加入成本中心自己的科目餘額)
# Modify.........: No.TQC-670010 06/07/04 By Sarah 計算caz_file數據有誤
# Modify.........: No.FUN-670006 06/07/10 By Jackho 帳別權限修改
# Modify.........: No.FUN-680122 06/08/30 By zdyllq 類型轉換 
# Modify.........: No.TQC-6A0072 06/10/25 By Sarah 計算總分攤權量時,不同的科目要分開計算
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.FUN-710027 07/01/17 By atsea 增加修改單身批處理錯誤統整功能
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-730057 07/04/02 By bnlent 會計科目加帳套
# Modify.........: No.MOD-770070 07/07/18 By Carol 將azi05,azi04取位改為使用azi03
# Modify.........: No.TQC-790087 07/09/13 By Sarah 修正Primary Key後,程式判斷錯誤訊息-239時必須改變做法
# Modify.........: No.FUN-7B0012 07/11/07 By Carrier db分隔符,call s_dbstring()處理
# Modify.........: No.FUN-820017 08/02/15 By alex 修正 s_dbstring用法
# Modify.........: No.FUN-910031 09/01/14 By kim 十號公報 for 重複性生產
# Modify.........: No.CHI-940027 09/04/24 By ve007 制費分為5大類
# Modify.........: No.CHI-970021 09/08/21 By jan 1.新增cad_file時，需考慮單一和多部門分攤情況.
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980031 09/11/11 By jan axcp305與axcp312合并
# Modify.........: No.FUN-990066 09/11/11 By jan axci040若設定為單一部門，則axci001/002不需要設資料，但目前程式處理一定會去撈cay_file資料來處理
# Modify.........: No:CHI-9A0021 09/10/13 By Lilan 將YEAR/MONTH的語法改成用BETWEEN語法 
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:TQC-9C0073 09/12/10 By Carrier 不过plant字段时,g_dbs_new的赋值
# Modify.........: No:TQC-9C0077 09/12/11 By Carrier 给oriu/orig赋值
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No.FUN-A50102 10/06/11 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A90065 10/10/26 By kim 增加製程成本-人工/製費收集
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-C80092 12/12/05 By xujing 成本相關作業增加日誌功能

IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
            yy         LIKE type_file.num5,       #No.FUN-680122 SMALLINT,
            mm         LIKE type_file.num5,       #No.FUN-680122 SMALLINT,
            p_plant    LIKE azp_file.azp01,       #No.FUN-680122 VARCHAR(10),
            e          LIKE aaa_file.aaa01        #No.FUN-670006
          END RECORD
DEFINE g_row,g_col,n   LIKE type_file.num5        #No.FUN-680122 SMALLINT
DEFINE g_cnt           LIKE type_file.num10       #No.FUN-680122 INTEGER
DEFINE g_flag          LIKE type_file.chr1        #No.FUN-680122 VARCHAR(1)
DEFINE l_flag          LIKE type_file.chr1,       #No.FUN-570153        #No.FUN-680122 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1,       # Prog. Version..: '5.30.06-13.03.12(01),              #是否有做語言切換 No.FUN-570153
       ls_date         STRING,                    #No.FUN-570153
       g_bdate,g_edate LIKE cam_file.cam01        #FUN-660103 add
DEFINE g_chr           LIKE type_file.chr1        #CHI-970021
DEFINE g_actcap        LIKE srl_file.srl05        #FUN-980031
DEFINE g_sql           STRING                     #FUN-980031
DEFINE g_argv0         LIKE type_file.chr1        #FUN-A90065  #when g_argv0='1' =>for 重複性生產-人工製費收集  (axcp312)

                                                               #when g_argv0='2' =>for 製程成本  -人工製費收集  (axcp310)
DEFINE g_cka00         LIKE cka_file.cka00        #FUN-C80092 add
DEFINE g_cka09         LIKE cka_file.cka09        #FUN-C80092 add
MAIN
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
#->No.FUN-570153 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_argv0    = ARG_VAL(1)   #FUN-A90065
   LET tm.yy      = ARG_VAL(2)   #FUN-A90065                    
   LET tm.mm      = ARG_VAL(3)   #FUN-A90065                  
   LET tm.p_plant = ARG_VAL(4)   #FUN-A90065                   
   LET tm.e       = ARG_VAL(5)   #FUN-A90065                   
   LET g_bgjob    = ARG_VAL(6)   #FUN-A90065              
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570153 ---end---
 
   #FUN-A90065(S)
   IF cl_null(g_argv0) THEN
      LET g_argv0='1'
   END IF
   IF g_argv0 = '1' THEN
      LET g_prog = 'axcp312'
   ELSE
      LET g_prog = 'axcp310'
   END IF
   #FUN-A90065(E)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
#NO.FUN-570153 mark--
#   LET g_row = 5 LET g_col = 27
 
#   OPEN WINDOW p312_w AT g_row,g_col WITH FORM "axc/42f/axcp312"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#   CALL cl_ui_init()
# Prog. Version..: '5.30.06-13.03.12(0,0)				#
#   CLOSE WINDOW p312_w
#NO.FUN-570153 mark--
 
#NO.FUN-570153 start--
#  CALL cl_used('axcp312',g_time,1) RETURNING g_time  #FUN-570153   #No.FUN-6A0146
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   LET g_success = 'Y'
   WHILE TRUE
      LET g_flag = 'Y' 
      IF g_bgjob = "N" THEN
         CLEAR FORM
         CALL p312_tm(0,0)
         IF g_flag = 'N' THEN
            CONTINUE WHILE
         END IF
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         #No.TQC-9C0073  --Begin                                                
         LET g_plant_new= tm.p_plant  #工厂编号                                 
         CALL s_getdbs()                                                        
         #No.TQC-9C0073  --End 
         IF cl_sure(18,20) THEN 
            #FUN-C80092--add--str--
            LET g_cka09 = " tm.yy='",tm.yy,"'; tm.mm='",tm.mm,"'; tm.p_plant='",tm.p_plant,
                          "'; tm.e='",tm.e,"'; g_bgjob='",g_bgjob,"'"
            CALL s_log_ins(g_prog,tm.yy,tm.mm,'',g_cka09) RETURNING g_cka00
            #FUN-C80092--add--end--
            BEGIN WORK
            LET g_success = 'Y'
            LET g_prog = 'axcp312'  #FUN-A90065
            CALL axcp312()
            #FUN-A90065(S)
            IF g_argv0 = '1' THEN
               LET g_prog = 'axcp312'
            ELSE
               LET g_prog = 'axcp310'
            END IF
            #FUN-A90065(E)
            CALL s_showmsg()        #No.FUN-710027  
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL s_log_upd(g_cka00,'Y')  #FUN-C80092 add
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL s_log_upd(g_cka00,'N')  #FUN-C80092 add
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN 
               CONTINUE WHILE 
            ELSE 
               CLOSE WINDOW p312_w
               EXIT WHILE 
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p312_w
      ELSE
         #FUN-C80092--add--str--
         LET g_cka09 = " tm.yy='",tm.yy,"'; tm.mm='",tm.mm,"'; tm.p_plant='",tm.p_plant,
                       "'; tm.e='",tm.e,"'; g_bgjob='",g_bgjob,"'"
         CALL s_log_ins(g_prog,tm.yy,tm.mm,'',g_cka09) RETURNING g_cka00
         #FUN-C80092--add--end--
         BEGIN WORK
         LET g_success = 'Y'
         #No.TQC-9C0073  --Begin                                                
         LET g_plant_new= tm.p_plant  #工厂编号                                 
         CALL s_getdbs()                                                        
         #No.TQC-9C0073  --End 
         LET g_prog = 'axcp312'  #FUN-A90065
         CALL axcp312()
         #FUN-A90065(S)
         IF g_argv0 = '1' THEN
            LET g_prog = 'axcp312'
         ELSE
            LET g_prog = 'axcp310'
         END IF
         #FUN-A90065(E)
         CALL s_showmsg()        #No.FUN-710027  
         IF g_success = "Y" THEN
            COMMIT WORK
            CALL s_log_upd(g_cka00,'Y')  #FUN-C80092 add
         ELSE
            ROLLBACK WORK
            CALL s_log_upd(g_cka00,'N')  #FUN-C80092 add
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-570153   #FUN-6A0146  #FUN-A90065
#->No.FUN-570153 ---end---
 
END MAIN
 
FUNCTION p312_tm(p_row,p_col)
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE l_sql         STRING   
   DEFINE lc_cmd        LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(500)           #No.FUN-570153
   DEFINE li_chk_bookno  LIKE type_file.num5         #No.FUN-680122 SMALLINT  #No.FUN-670006
#->No.FUN-570153 ---start---
   LET g_row = 5 LET g_col = 27
 
   OPEN WINDOW p312_w AT g_row,g_col WITH FORM "axc/42f/axcp312"  
      ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()
   CALL cl_opmsg('z')
#->No.FUN-570153 ---end---
 
   CALL cl_opmsg('z')
 
   WHILE TRUE
      MESSAGE ""
      IF s_shut(0) THEN
         RETURN
      END IF
      CLEAR FORM
      INITIALIZE tm.* TO NULL			# Default condition
      LET tm.yy = g_ccz.ccz01
      LET tm.mm = g_ccz.ccz02
      LET tm.p_plant=g_plant
      LET tm.e  = g_aaz.aaz64   #預設帳別   #FUN-660103 add
      LET g_bgjob = 'N'    #NO.FUN-570153
 
      DISPLAY BY NAME tm.yy,tm.mm,tm.p_plant,tm.e   #FUN-660103 add tm.e
 
      #INPUT BY NAME tm.yy,tm.mm,tm.p_plant,tm.e WITHOUT DEFAULTS
      INPUT BY NAME tm.yy,tm.mm,tm.p_plant,tm.e,g_bgjob WITHOUT DEFAULTS  #NO.FUN-570153 
 
         AFTER FIELD yy
            IF tm.yy IS NULL THEN
               NEXT FIELD yy
            END IF
 
         AFTER FIELD mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.mm > 12 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF tm.mm > 13 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
            IF tm.mm IS NULL THEN
               NEXT FIELD mm
            END IF
#No.TQC-720032 -- begin --
#            IF tm.mm < 1 OR tm.mm > 12 THEN
#               NEXT FIELD mm
#            END IF
#No.TQC-720032 -- end --
 
         AFTER FIELD p_plant
            IF tm.p_plant IS NULL THEN
               NEXT FIELD p_plant
            END IF
            SELECT COUNT(*) INTO g_cnt FROM azp_file WHERE azp01=tm.p_plant
            IF g_cnt=0 THEN
               CALL cl_err(tm.p_plant,'apm-277',1) NEXT FIELD p_plant
            END IF
            CALL p312_get_dbs(tm.p_plant)
 
         AFTER FIELD e  #帳別
            IF tm.e IS NULL THEN
               NEXT FIELD e
            END IF
            IF NOT cl_null(tm.e) THEN
              #No.FUN-670006--begin
              CALL s_check_bookno(tm.e,g_user,tm.p_plant)
                  RETURNING li_chk_bookno
	      IF (NOT li_chk_bookno) THEN
                  NEXT FIELD e
              END IF 
              LET g_plant_new= tm.p_plant  #工廠編號
                 #CALL s_getdbs()   #FUN-A50102
                 LET l_sql = "SELECT *",
                             #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",
                             "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'),  #FUN-A50102
                             " WHERE aaa01 = '",tm.e,"' ",
                             "   AND aaaacti IN ('Y','y') "
 	             CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                 CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
                 PREPARE p312_pre2 FROM l_sql
                 DECLARE p312_cur2 CURSOR FOR p312_pre2
                 OPEN p312_cur2
                 FETCH p312_cur2 INTO g_cnt
#             SELECT * FROM aaa_file WHERE aaa01 = tm.e AND aaaacti='Y'
              #No.FUN-670006--end
              IF STATUS THEN
                 CALL cl_err(tm.e,'aap-229',0) NEXT FIELD e
              END IF
             END IF
             #LET l_sql= " SELECT COUNT(*) FROM ",g_dbs_new CLIPPED,"aaa_file ",
             LET l_sql= " SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'aaa_file'),  #FUN-A50102
                        " WHERE aaa01='",tm.e,"'"   #FUN-670058 modify
 	         CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
             CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
             PREPARE p312_e_pre FROM l_sql
             DECLARE p312_e_cur CURSOR FOR p312_e_pre
             OPEN p312_e_cur
             FETCH p312_e_cur INTO g_cnt
             IF g_cnt=0 THEN
                CALL cl_err(tm.e,'anm-062',1) NEXT FIELD e
             END IF
             CLOSE p312_e_cur
 
        #start FUN-660103 add 
         AFTER INPUT
            IF tm.yy IS NULL THEN
               NEXT FIELD yy
            END IF
            IF tm.mm IS NULL THEN
               NEXT FIELD mm
            END IF
            IF tm.p_plant IS NULL THEN
               NEXT FIELD p_plant
            END IF
            IF tm.e IS NULL THEN
               NEXT FIELD e
            END IF
        #end FUN-660103 add 
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
    
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION exit  #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION locale  #genero
#NO.FUN-570153 start--
#            LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_change_lang = TRUE
#NO.FUN-570153 end---
            EXIT INPUT
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
#NO.FUN-570153 start--
   #->No.FUN-570153 --start--
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         LET g_flag = 'N'
         RETURN
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p312_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211   
         EXIT PROGRAM
      END IF
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = g_prog             #FUN-A90065
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err(g_prog,'9031',1)  #FUN-A90065
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.yy CLIPPED ,"'",
                         " '",tm.mm CLIPPED ,"'",
                         " '",tm.p_plant CLIPPED ,"'",
                         " '",tm.e CLIPPED ,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat(g_prog,g_time,lc_cmd CLIPPED)  #FUN-A90065
         END IF
         CLOSE WINDOW p312_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
    EXIT WHILE
 END WHILE
#->No.FUN-570153 ---end---   
 
#NO.FUN-570153 MARK---
#      IF g_action_choice = "locale" THEN  #genero
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
# 
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0 EXIT PROGRAM
#      END IF
#      IF cl_sure(21,21) THEN   #genero
#         BEGIN WORK
#         LET g_success='Y'
#         CALL cl_wait()
#         CALL axcp312()
#         #genero
#         IF g_success = 'Y' THEN
#            COMMIT WORK
#            CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#         ELSE
#            ROLLBACK WORK
#            CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#         END IF
#         IF g_flag THEN
#            CONTINUE WHILE
#         ELSE
#            EXIT WHILE
#         END IF
#      END IF
#   END WHILE
#   #genero
#   #CLOSE WINDOW p312_w
#NO.FUN-570153 mark--
END FUNCTION
 
FUNCTION axcp312()
   DEFINE l_name1,l_name2        LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20),     # External(Disk) file name
          l_name3,l_name4,l_name LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20),     # FUN-660103 add
          l_name2_1              LIKE type_file.chr20,          #TQC-6A0072 add
          l_sql                  STRING,       # RDSQL STATEMENT
          l_sql1,l_sql2,l_sqlw   STRING,       # RDSQL STATEMENT   #FUN-660103 add
          l_cmd                  LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(30),
          aao                    RECORD LIKE aao_file.*,
          caa                    RECORD LIKE caa_file.*,
          cax                    RECORD LIKE cax_file.*,   #TQC-6A0072 add
          cay                    RECORD LIKE cay_file.*,   #FUN-660103 add
          l_aag221               LIKE aag_file.aag221, 
          l_cax07_sum            LIKE cax_file.cax07,      #FUN-660103 add
          l_aaosum               LIKE aao_file.aao05,      #FUN-660201 add
          l_cax10                LIKE cax_file.cax10,      #FUN-660103 add
         #l_cam07                LIKE cam_file.cam07,      #FUN-660103 add#CHI-970021
          l_srl06                LIKE srl_file.srl06,      #CHI-970021
          l_caz09_sum            LIKE caz_file.caz09,      #FUN-660103 add
          l_caz10                LIKE caz_file.caz10       #FUN-660103 add
   DEFINE sr                     RECORD LIKE caz_file.*    #FUN-660103 add
   #CHI-970021--begin--add--
   DEFINE tm1      RECORD
          caa01   LIKE caa_file.caa01,
          caa05   LIKE caa_file.caa05,
          caa04   LIKE caa_file.caa04,
          caa10   LIKE caa_file.caa10,
          caa06   LIKE caa_file.caa06
                  END RECORD,
          tm2     RECORD
          caa01   LIKE caa_file.caa01,
          caa02   LIKE caa_file.caa02,
          caa05   LIKE caa_file.caa05,
          caa04   LIKE caa_file.caa04,
          caa06   LIKE caa_file.caa06,
          cay03   LIKE cay_file.cay03,
          cay05   LIKE cay_file.cay05
                  END RECORD,
          l_name5,l_name6   LIKE type_file.chr20
    #CHI-970021--end--add--
    DEFINE  unit_cost         LIKE cae_file.cae07    #FUN-980031
    DEFINE  p_sum             LIKE cae_file.cae05    #FUN-980031
    DEFINE  l_cae11           LIKE cae_file.cae11    #FUN-980031
    DEFINE  l_cae             RECORD LIKE cae_file.* #FUN-980031
         
 
    #start FUN-660103 add
     LET g_bdate = MDY(tm.mm,1,tm.yy)
     LET g_edate = MDY(tm.mm+1,1,tm.yy)-1
 
     #FUN-980031--begin--add--
     LET g_sql="SELECT SUM(ima58)",
               #"  FROM ",g_dbs_new CLIPPED," ima_file ",
               "  FROM ",cl_get_target_table(g_plant_new,'ima_file'),  #FUN-A50102
               " WHERE ima34= ? " CLIPPED     #成本中心
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
     PREPARE ima_pre FROM g_sql
     DECLARE ima_cur CURSOR WITH HOLD FOR ima_pre

     LET g_sql="SELECT SUM(ima912)",
               #"  FROM ",g_dbs_new CLIPPED," ima_file ",
               "  FROM ",cl_get_target_table(g_plant_new,'ima_file'),  #FUN-A50102
               " WHERE ima34= ? " CLIPPED     #成本中心
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
     PREPARE ima_pre1 FROM g_sql
     DECLARE ima_cur1 CURSOR WITH HOLD FOR ima_pre1
     #FUN-980031--end--add--

     #FUN-A90065(S)
     LET g_sql=" SELECT SUM(ecb19) FROM ecb_file ",
               "   WHERE ecb08= ? " CLIPPED  #成本中心
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
     PREPARE ecb_pre FROM g_sql
     DECLARE ecb_cur CURSOR WITH HOLD FOR ecb_pre

     LET g_sql=" SELECT SUM(ecb21) FROM ecb_file ",
               "   WHERE ecb08= ? " CLIPPED  #成本中心
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
     PREPARE ecb_pre1 FROM g_sql
     DECLARE ecb_cur1 CURSOR WITH HOLD FOR ecb_pre1
     #FUN-A90065(E)

    #1.寫入成本分攤權數及金額檔-直接部門(cax_file)
     LET l_sql = "SELECT aao_file.*,cay_file.*,aag221",
                 #"  FROM ",g_dbs_new CLIPPED," aao_file,",
                 #          g_dbs_new CLIPPED," cay_file,",
                 #          g_dbs_new CLIPPED," aag_file ",
                 "  FROM ",cl_get_target_table(g_plant_new,'aao_file'),",",  #FUN-A50102
                           cl_get_target_table(g_plant_new,'cay_file'),",",  #FUN-A50102
                           cl_get_target_table(g_plant_new,'aag_file'),      #FUN-A50102
                 " WHERE aao00='",tm.e,"'",
                 "   AND aao03='",tm.yy,"'",
                 "   AND aao04='",tm.mm,"'",
                 "   AND aao02=cay03",
                 "   AND aao01=cay06",
                 "   AND aao01=aag01",
                 "   AND aao00=aag00",          #No.FUN-730057
                 "   AND cay08='B'"   #間接部門
     DISPLAY "l_sql=",l_sql
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
     PREPARE axcp312_p1 FROM l_sql
     IF STATUS THEN 
        CALL cl_err('prepare1:',STATUS,1) 
        CALL cl_batch_bg_javamail("N")      #FUN-570153
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM 
     END IF
     DECLARE axcp312_c1 CURSOR FOR axcp312_p1
 
     #先刪除舊資料
     DELETE FROM cax_file WHERE cax01=tm.yy and cax02=tm.mm
     
     CALL cl_outnam('axcp312') RETURNING l_name1
     START REPORT axcp312_rep1 TO l_name1
     FOREACH axcp312_c1 INTO aao.*,cay.*,l_aag221
        IF STATUS THEN
           CALL cl_err('foreach1:',STATUS,1)
           LET g_success='N'
           EXIT FOREACH
        END IF
        IF cl_null(aao.aao06) THEN LET aao.aao06=0 END IF
 
        #計算總分攤權數SUM(cay05)
        LET l_sql = "SELECT SUM(cay05)",
                    #"  FROM ",g_dbs_new CLIPPED,"cay_file",
                    "  FROM ",cl_get_target_table(g_plant_new,'cay_file'), #FUN-A50102
                    " WHERE cay01='",tm.yy,"'",
                    "   AND cay02='",tm.mm,"'",
                    "   AND cay03='",cay.cay03,"'",
                    "   AND cay06='",cay.cay06,"'",
                    "   AND cay00='",cay.cay00,"'"   #TQC-670010 add
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE axcp312_p1_sum FROM l_sql
        DECLARE axcp312_c1_sum CURSOR FOR axcp312_p1_sum
        OPEN axcp312_c1_sum
        FETCH axcp312_c1_sum INTO l_cax07_sum
        IF cl_null(l_cax07_sum) THEN LET l_cax07_sum = 0 END IF
  
        OUTPUT TO REPORT axcp312_rep1(aao.*,cay.*,l_aag221,l_cax07_sum)
     END FOREACH
     FINISH REPORT axcp312_rep1
#    LET l_cmd = "chmod 777 ", l_name1                   #No.FUN-9C0009
#    RUN l_cmd                                           #No.FUN-9C0009
     IF os.Path.chrwx(l_name1 CLIPPED,511) THEN END IF   #No.FUN-9C0009
     IF g_success='N' THEN RETURN END IF
 
    #2.寫入成本分攤權數及金額檔-成本中心(caz_file)
     LET l_sql = "SELECT aao_file.*,cay_file.*,aag221",
                 #"  FROM ",g_dbs_new CLIPPED," aao_file,",
                 #          g_dbs_new CLIPPED," cay_file,",
                 #          g_dbs_new CLIPPED," aag_file ",
                 "  FROM ",cl_get_target_table(g_plant_new,'aao_file'),",", #FUN-A50102
                           cl_get_target_table(g_plant_new,'cay_file'),",", #FUN-A50102
                           cl_get_target_table(g_plant_new,'aag_file'),     #FUN-A50102
                 " WHERE aao00='",tm.e,"'",
                 "   AND aao03='",tm.yy,"'",
                 "   AND aao04='",tm.mm,"'",
                 "   AND aao02=cay03",     #科目
                 "   AND aao01=cay06",     #部門
                 "   AND aao01=aag01",     #科目
                 "   AND aao00=aag00",     #帳別  #No.FUN-730057
                 "   AND cay08='A'"        #直接部門
     DISPLAY "l_sql=",l_sql
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
     PREPARE axcp312_p2 FROM l_sql
     IF STATUS THEN 
        CALL cl_err('prepare2:',STATUS,1) 
        CALL cl_batch_bg_javamail("N")      #FUN-570153
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM 
     END IF
     DECLARE axcp312_c2 CURSOR FOR axcp312_p2
     
     #先刪除舊資料
     DELETE FROM caz_file WHERE caz01=tm.yy and caz02=tm.mm
 
     CALL cl_outnam('axcp312') RETURNING l_name2
     START REPORT axcp312_rep2 TO l_name2
     FOREACH axcp312_c2 INTO aao.*,cay.*,l_aag221
        IF STATUS THEN
           CALL cl_err('foreach2:',STATUS,1)
           LET g_success='N'
           EXIT FOREACH
        END IF
        IF cl_null(aao.aao06) THEN LET aao.aao06=0 END IF
       #start FUN-660201 add
        #抓成本中心(cay04)的科目餘額
        LET l_sql ="SELECT SUM(aao05 -aao06)",
                   #"  FROM ",g_dbs_new CLIPPED," aao_file",
                   "  FROM ",cl_get_target_table(g_plant_new,'aao_file'),     #FUN-A50102
                   " WHERE aao00='",tm.e,"'",
                   "   AND aao03='",tm.yy,"'",
                   "   AND aao04='",tm.mm,"'",
                   "   AND aao02='",cay.cay04,"'",
                   "   AND aao01='",aao.aao01,"'"
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE axcp312_p2_aao FROM l_sql
        DECLARE axcp312_c2_aao CURSOR FOR axcp312_p2_aao
        OPEN axcp312_c2_aao
        FETCH axcp312_c2_aao INTO l_aaosum
        IF cl_null(l_aaosum) THEN LET l_aaosum = 0 END IF
       #end FUN-660201 add
 
        #抓直接部門的分攤金額
        LET l_sql ="SELECT SUM(cax10)",
                   #"  FROM ",g_dbs_new CLIPPED," cax_file",
                   "  FROM ",cl_get_target_table(g_plant_new,'cax_file'),     #FUN-A50102
                   " WHERE cax00='",cay.cay00,"'",
                   "   AND cax01='",tm.yy,"'",
                   "   AND cax02='",tm.mm,"'",
                  #"   AND cax06='",aao.aao02,"'",    #TQC-6A0072 mark
                   "   AND cax06='",cay.cay04,"'",    #TQC-6A0072
                   "   AND cax04='",aao.aao01,"'" 
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE axcp312_p2_cax10 FROM l_sql
        DECLARE axcp312_c2_cax10 CURSOR FOR axcp312_p2_cax10
        OPEN axcp312_c2_cax10
        FETCH axcp312_c2_cax10 INTO l_cax10
        IF cl_null(l_cax10) THEN LET l_cax10 = 0 END IF
 
        #計算約當產量
       #CHI-970021--begin--mod-
       #LET l_sql ="SELECT SUM(cam07)",
       #           "  FROM ",g_dbs_new CLIPPED," cam_file",
       #           " WHERE cam01 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
       #           "   AND cam02='",cay.cay04,"'" 
       #FUN-A90065(S)
        IF g_argv0 ='2' THEN
           LET l_sql ="SELECT SUM(cam07)",
                       "  FROM ",cl_get_target_table(g_plant_new,'cal_file'),",",
                                 cl_get_target_table(g_plant_new,'cam_file'),  
                       " WHERE cal01 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                       "   AND cal02='",cay.cay04,"'" ,
                       "   AND calfirm = 'Y'",
                       "   AND cal01 = cam01",
                       "   AND cal02 = cam02"
        ELSE
        #FUN-A90065(E)
            LET l_sql = "SELECT SUM(srl06)",
                        #"  FROM ",g_dbs_new CLIPPED,"srk_file,",
                        #          g_dbs_new CLIPPED,"srl_file",
                        "  FROM ",cl_get_target_table(g_plant_new,'srk_file'),",", #FUN-A50102
                                  cl_get_target_table(g_plant_new,'srl_file'),     #FUN-A50102
                        " WHERE srk01 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                        "   AND srk02 = '",cay.cay04,"'",
                        "   AND srkfirm = 'Y'",
                        "   AND srl01 = srk01",
                        "   AND srl02 = srk02"
        END IF
        #CHI-970021--end--mod--
 	      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE axcp312_p2_srl06 FROM l_sql   #CHI-970021
        DECLARE axcp312_c2_srl06 CURSOR FOR axcp312_p2_srl06#CHI-970021
        OPEN axcp312_c2_srl06  #CHI-970021
        FETCH axcp312_c2_srl06 INTO l_srl06 #CHI-970021
        IF cl_null(l_srl06) THEN LET l_srl06 = 0 END IF #CHI-970021
 
        #計算總分攤權量SUM(cay05*cam07)
       #CHI-970021--begin--mod--
       #LET l_sql = "SELECT SUM(cay05*cam07)",
       #            "  FROM ",g_dbs_new CLIPPED," cay_file,",
       #                      g_dbs_new CLIPPED," cam_file",
       #            " WHERE cam01 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
       #            "   AND cam02=cay04",
       #            "   AND cay03='",cay.cay03,"'",
       #            "   AND cay00='",cay.cay00,"'",   #TQC-670010 add
       #            "   AND cay06='",cay.cay06,"'"    #TQC-6A0072 add
       #FUN-A90065(S)
        IF g_argv0 ='2' THEN
           LET l_sql = "SELECT SUM(cay05*cam07)",
                       "  FROM ",cl_get_target_table(g_plant_new,'cay_file'),",",
                                 cl_get_target_table(g_plant_new,'cal_file'),",", 
                                 cl_get_target_table(g_plant_new,'cam_file'),     
                       " WHERE cal01 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                       "   AND cal02=cay04 ",
                       "   AND cal01=cam01 AND cal02=cam02 ",
                       "   AND calfirm = 'Y'",
                       "   AND cay03='",cay.cay03,"'",
                       "   AND cay00='",cay.cay00,"'",   #TQC-670010 add
                       "   AND cay06='",cay.cay06,"'"    #TQC-6A0072 add
        ELSE
        #FUN-A90065(E)
           LET l_sql = "SELECT SUM(cay05*srl06)",
                       #"  FROM ",g_dbs_new CLIPPED," cay_file,",
                       #          g_dbs_new CLIPPED," srk_file,",
                       #          g_dbs_new CLIPPED," srl_file",
                       "  FROM ",cl_get_target_table(g_plant_new,'cay_file'),",", #FUN-A50102
                                 cl_get_target_table(g_plant_new,'srk_file'),",", #FUN-A50102
                                 cl_get_target_table(g_plant_new,'srl_file'),     #FUN-A50102
                       " WHERE srk01 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                       "   AND srk02=cay04",
                       "   AND srl01=srk01 AND srl02=srk02 ",
                       "   AND srkfirm = 'Y'",
                       "   AND cay03='",cay.cay03,"'",
                       "   AND cay00='",cay.cay00,"'",
                       "   AND cay06='",cay.cay06,"'"
       END IF
       #CHI-970021--end--mod--
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE axcp312_p2_sum FROM l_sql
        DECLARE axcp312_c2_sum CURSOR FOR axcp312_p2_sum
        OPEN axcp312_c2_sum
        FETCH axcp312_c2_sum INTO l_caz09_sum
        IF cl_null(l_caz09_sum) THEN LET l_caz09_sum = 0 END IF
 
        OUTPUT TO REPORT axcp312_rep2(aao.*,cay.*,l_aag221,l_aaosum,l_cax10,l_srl06,l_caz09_sum)#CHI-970021
     END FOREACH
     FINISH REPORT axcp312_rep2
#    LET l_cmd = "chmod 777 ", l_name2                   #No.FUN-9C0009
#    RUN l_cmd                                           #No.FUN-9C0009
     IF os.Path.chrwx(l_name2 CLIPPED,511) THEN END IF   #No.FUN-9C0009
     IF g_success='N' THEN RETURN END IF
    #end FUN-660103 add
 
    #start TQC-6A0072 add
    #2-1.寫入成本分攤權數及金額檔-成本中心(caz_file)
     LET l_sql = "SELECT aao_file.*,cay_file.*,aag221",
                 #"  FROM ",g_dbs_new CLIPPED," aao_file,",
                 #          g_dbs_new CLIPPED," cay_file,",
                 #          g_dbs_new CLIPPED," aag_file ",
                 "  FROM ",cl_get_target_table(g_plant_new,'aao_file'),",", #FUN-A50102
                           cl_get_target_table(g_plant_new,'cay_file'),",", #FUN-A50102
                           cl_get_target_table(g_plant_new,'aag_file'),     #FUN-A50102
                 " WHERE aao00='",tm.e,"'",
                 "   AND aao03='",tm.yy,"'",
                 "   AND aao04='",tm.mm,"'",
                 "   AND aao02=cay03",     #科目
                 "   AND aao01=cay06",     #部門
                 "   AND aao01=aag01",     #科目
                 "   AND aao00=aag00",     #FUN-730057
                 "   AND cay08='B'"        #間接部門
     DISPLAY "l_sql=",l_sql
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
     PREPARE axcp312_p2_1 FROM l_sql
     IF STATUS THEN 
        CALL cl_err('prepare2_1:',STATUS,1) 
        CALL cl_batch_bg_javamail("N")      #FUN-570153
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM 
     END IF
     DECLARE axcp312_c2_1 CURSOR FOR axcp312_p2_1
 
     CALL cl_outnam('axcp312') RETURNING l_name2_1
     START REPORT axcp312_rep2 TO l_name2_1
     CALL s_showmsg_init()   #No.FUN-710027 
     FOREACH axcp312_c2_1 INTO aao.*,cay.*,l_aag221
        IF STATUS THEN
#           CALL cl_err('foreach2_1:',STATUS,1)         #No.FUN-710027
           CALL s_errmsg('','','foreach2_1:',STATUS,1)  #No.FUN-710027
           LET g_success='N'
           EXIT FOREACH
        END IF
#No.FUN-710027--begin 
         IF g_success='N' THEN  
            LET g_totsuccess='N'  
            LET g_success="Y"   
         END IF 
#No.FUN-710027--end
        IF cl_null(aao.aao06) THEN LET aao.aao06=0 END IF
 
        #看間接部門分攤到直接部門之後，直接部門是否又分攤出去
        LET l_sql = "SELECT cax_file.*,cay_file.*,aag221",
                    #"  FROM ",g_dbs_new CLIPPED," cax_file,",
                    #          g_dbs_new CLIPPED," cay_file,",
                    #          g_dbs_new CLIPPED," aag_file ",
                    "  FROM ",cl_get_target_table(g_plant_new,'cax_file'),",", #FUN-A50102
                              cl_get_target_table(g_plant_new,'cay_file'),",", #FUN-A50102
                              cl_get_target_table(g_plant_new,'aag_file'),     #FUN-A50102
                    "  WHERE cax01='",tm.yy,"'",
                    "    AND cax02='",tm.mm,"'",
                    "    AND cax06=cay03",
                    "    AND cax04=cay06",
                    "    AND cax04=aag01",
                    "    AND aag00='",tm.e,"'",     #No.FUN-730057
                    "    AND cay03='",cay.cay04,"'" 
        DISPLAY "l_sql=",l_sql
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE axcp312_p2_1_B FROM l_sql
        IF STATUS THEN 
#           CALL cl_err('prepare2_1_B:',STATUS,1)             #No.FUN-710027
           CALL s_errmsg('','','prepare2_1_B:',STATUS,1)      #No.FUN-710027
           CALL cl_batch_bg_javamail("N")      #FUN-570153
#           EXIT PROGRAM            #No.FUN-710027
           CONTINUE FOREACH         #No.FUN-710027 
        END IF
        DECLARE axcp312_c2_1_B CURSOR FOR axcp312_p2_1_B
        FOREACH axcp312_c2_1_B INTO cax.*,cay.*,l_aag221
           LET aao.aao02 = cax.cax06
           LET aao.aao05 = cax.cax10
           LET aao.aao06 = 0
           LET l_aaosum = 0
           LET l_cax10 = 0
 
           #計算約當產量
          #CHI-970021--begin--mod--
          #LET l_sql ="SELECT SUM(cam07)",
          #           "  FROM ",g_dbs_new CLIPPED," cam_file",
          #           " WHERE cam01 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
          #           "   AND cam02='",cay.cay04,"'" 
          #FUN-A90065(S)
           IF g_argv0 ='2' THEN
              LET l_sql ="SELECT SUM(cam07)",
                          " FROM ",cl_get_target_table(g_plant_new,'cal_file'),",", 
                                   cl_get_target_table(g_plant_new,'cam_file'),     
                          " WHERE cal01 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                          "   AND cal02 = '",cay.cay04,"'",
                          "   AND calfirm = 'Y'",
                          "   AND cam01 = cal01",
                          "   AND cam02 = cal02"
           ELSE
           #FUN-A90065(E)
              LET l_sql = "SELECT SUM(srl06)",
                          #"  FROM ",g_dbs_new CLIPPED,"srk_file,",
                          #          g_dbs_new CLIPPED,"srl_file",
                          "  FROM ",cl_get_target_table(g_plant_new,'srk_file'),",", #FUN-A50102
                                    cl_get_target_table(g_plant_new,'srl_file'),     #FUN-A50102
                          " WHERE srk01 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                          "   AND srk02 = '",cay.cay04,"'",
                          "   AND srkfirm = 'Y'",
                          "   AND srl01 = srk01",
                          "   AND srl02 = srk02"
          END IF
          #CHI-970021--end--mod--
 	         CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
           PREPARE axcp312_p2_1_srl06 FROM l_sql   #CHI-970021
           DECLARE axcp312_c2_1_srl06 CURSOR FOR axcp312_p2_1_srl06 #CHI-970021
           OPEN axcp312_c2_1_srl06 #CHI-970021
           FETCH axcp312_c2_1_srl06 INTO l_srl06  #CHI-970021
           IF cl_null(l_srl06) THEN LET l_srl06= 0 END IF #CHI-970021
 
           #計算總分攤權量SUM(cay05*cam07)
          #CHI-970021--begin--mod--
          #LET l_sql = "SELECT SUM(cay05*cam07)",
          #            "  FROM ",g_dbs_new CLIPPED," cay_file,",
          #                      g_dbs_new CLIPPED," cam_file",
          #            " WHERE cam01 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
          #            "   AND cam02=cay04",
          #            "   AND cay03='",cay.cay03,"'",
          #            "   AND cay00='",cay.cay00,"'",   #TQC-670010 add
          #            "   AND cay06='",cay.cay06,"'"    #TQC-6A0072 add
          #FUN-A90065(S)
           IF g_argv0 ='2' THEN
              LET l_sql = "SELECT SUM(cay05*cam07)",
                          "  FROM ",cl_get_target_table(g_plant_new,'cay_file'),",",
                                    cl_get_target_table(g_plant_new,'cal_file'),",",
                                    cl_get_target_table(g_plant_new,'cam_file'), 
                          " WHERE cal01 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                          "   AND cal02=cay04",
                          "   AND cam01=cal01 AND cam02=cal02 ",
                          "   AND calfirm = 'Y'",
                          "   AND cay03='",cay.cay03,"'",
                          "   AND cay00='",cay.cay00,"'",   #TQC-670010 add
                          "   AND cay06='",cay.cay06,"'"    #TQC-6A0072 add
           ELSE
           #FUN-A90065(E)
              LET l_sql = "SELECT SUM(cay05*srl06)",
                          #"  FROM ",g_dbs_new CLIPPED," cay_file,",
                          #          g_dbs_new CLIPPED," srk_file,",
                          #          g_dbs_new CLIPPED," srl_file",
                          "  FROM ",cl_get_target_table(g_plant_new,'cay_file'),",", #FUN-A50102
                                    cl_get_target_table(g_plant_new,'srk_file'),",", #FUN-A50102
                                    cl_get_target_table(g_plant_new,'srl_file'),     #FUN-A50102
                          " WHERE srk01 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                          "   AND srk02=cay04",
                          "   AND srl01=srk01 AND srl02=srk02 ",
                          "   AND srkfirm = 'Y'",
                          "   AND cay03='",cay.cay03,"'",
                          "   AND cay00='",cay.cay00,"'",
                          "   AND cay06='",cay.cay06,"'"
          END IF
          #CHI-970021--end--mod--
 	        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
           PREPARE axcp312_p2_1_sum FROM l_sql
           DECLARE axcp312_c2_1_sum CURSOR FOR axcp312_p2_1_sum
           OPEN axcp312_c2_1_sum
           FETCH axcp312_c2_1_sum INTO l_caz09_sum
           IF cl_null(l_caz09_sum) THEN LET l_caz09_sum = 0 END IF
 
           OUTPUT TO REPORT axcp312_rep2(aao.*,cay.*,l_aag221,l_aaosum,l_cax10,l_srl06,l_caz09_sum)#CHI-970021
        END FOREACH
     END FOREACH
 
#No.FUN-710027--begin 
      IF g_totsuccess="N" THEN
           LET g_success="N"
      END IF 
#No.FUN-710027--end
 
 
     FINISH REPORT axcp312_rep2
#    LET l_cmd = "chmod 777 ", l_name2_1                   #No.FUN-9C0009
#    RUN l_cmd                                             #No.FUN-9C0009
     IF os.Path.chrwx(l_name2_1 CLIPPED,511) THEN END IF   #No.FUN-9C0009
    #end TQC-6A0072 add
 
    #start FUN-660103 modify
    #LET l_sql=" SELECT caa_file.*,aao_file.*,aag221  FROM ",
    #            g_dbs_new CLIPPED," aao_file,",
    #            g_dbs_new CLIPPED," caa_file,",
    #            g_dbs_new CLIPPED," aag_file ",
    #          "  WHERE aao00='",tm.e,"'",
    #          "    AND aao03='",tm.yy,"'",
    #          "    AND aao04='",tm.mm,"' ",
    #          "    AND aao02=caa01 ",
    #          "    AND aao01=caa05 ",
    #          "    AND aao01=aag01 " CLIPPED
   #start TQC-6A0072 modify 
   # LET l_sql=" SELECT caa_file.*,aao_file.*,cay_file.*,aag221  FROM ",
   #             g_dbs_new CLIPPED," aao_file,",
   #             g_dbs_new CLIPPED," cay_file,",
   #             g_dbs_new CLIPPED," caa_file,",
   #             g_dbs_new CLIPPED," aag_file ",
   #           "  WHERE aao00='",tm.e,"'",
   #           "    AND aao03='",tm.yy,"'",
   #           "    AND aao04='",tm.mm,"' ",
   #           "    AND aao02=cay03",
   #           "    AND aao01=cay06",
   #           "    AND cay04=caa01",
   #           "    AND cay06=caa05",   #TQC-6A0072 add
   #           "    AND aao01=aag01 " CLIPPED
   #CHI-970021--begin--add--
   LET l_sql=" SELECT caa01,caa05,caa04,caa10,caa06 ",
             #"   FROM ",g_dbs_new CLIPPED,"caa_file ",
             "   FROM ",cl_get_target_table(g_plant_new,'caa_file'),  #FUN-A50102
             "  WHERE caa09 = '1'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE p312_caa_c1 FROM l_sql
   DECLARE p312_s1 CURSOR FOR p312_caa_c1
   DELETE FROM cad_file WHERE cad01=tm.yy AND cad02=tm.mm   #CHI-970021
   DELETE FROM cae_file WHERE cae01=tm.yy AND cae02=tm.mm   #CHI-970021
   FOREACH p312_s1 INTO tm1.caa01,tm1.caa05,tm1.caa04,tm1.caa10,tm1.caa06
     LET g_chr = '1'  #CHI-970021
   #CHI-970021--end--add--
     IF cl_null(tm1.caa10) THEN   #CHI-970021 
     LET l_sql=" SELECT caa_file.*,aao_file.*,aag221  FROM ",
                 #g_dbs_new CLIPPED," aao_file,",
                  #g_dbs_new CLIPPED," cay_file,",   #FUN-990066
                 #g_dbs_new CLIPPED," caa_file,",
                 #g_dbs_new CLIPPED," aag_file ",
                 cl_get_target_table(g_plant_new,'aao_file'),",",  #FUN-A50102
                 cl_get_target_table(g_plant_new,'caa_file'),",",  #FUN-A50102
                 cl_get_target_table(g_plant_new,'aag_file'),      #FUN-A50102
               "  WHERE aao00='",tm.e,"'",
                  "    AND aao03=",tm.yy,  #CHI-970021
                  "    AND aao04=",tm.mm,  #CHI-970021
                 #"    AND aao02=cay03",   #FUN-990066
                  "    AND aao01=caa05",   #FUN-990066
                 #"    AND cay04=caa01",   #FUN-990066
                 #"    AND cay06=caa05",   #FUN-990066
                  "    AND caa01='",tm1.caa01,"'",   #CHI-970021 #FUN-990066
                  "    AND caa05='",tm1.caa05,"'",   #CHI-970021 #FUN-990066
               "    AND aao01=aag01",
               "    AND aao00=aag00",     #No.FUN-730057
                 #"    AND cay00 = caa04",   #CHI-970021  #FUN-990066
                  "    AND caa09 = '1'",      #CHI-970021
                  "    AND caa06 = '",tm1.caa06,"'", #CHI-970021
                  "    AND caa04='",tm1.caa04,"'",   #CHI-970021 #FUN-990066
               " UNION",
               " SELECT caa_file.*,aao_file.*,aag221  FROM ",
                 #g_dbs_new CLIPPED," aao_file,",
                   #g_dbs_new CLIPPED," cay_file,",   #FUN-990066
                 #g_dbs_new CLIPPED," cax_file,",
                 #g_dbs_new CLIPPED," caa_file,",
                 #g_dbs_new CLIPPED," aag_file ",
                 cl_get_target_table(g_plant_new,'aao_file'),",",  #FUN-A50102                   
                 cl_get_target_table(g_plant_new,'cax_file'),",",  #FUN-A50102
                 cl_get_target_table(g_plant_new,'caa_file'),",",  #FUN-A50102
                 cl_get_target_table(g_plant_new,'aag_file'),      #FUN-A50102
               " WHERE aao00='",tm.e,"'",
                  "   AND aao03=",tm.yy,   #CHI-970021
                  "   AND aao04=",tm.mm,   #CHI-970021
               "   AND aao02=cax03",
               "   AND aao01=cax04",
                 #"   AND cax06=cay03",    #FUN-990066
                  "   AND cax04=caa05",    #FUN-990066
                 #"   AND cay04=caa01",    #FUN-990066
                 #"   AND cay06=caa05",    #FUN-990066
                  "   AND caa01='",tm1.caa01,"'",   #CHI-970021 #FUN-990066
                  "   AND caa05='",tm1.caa05,"'",   #CHI-970021 #FUN-990066
               "   AND aao00=aag00",     #No.FUN-730057
                 #"   AND cay00 = caa04",   #CHI-970021   #FUN-990066
                 #"   AND cay00='",tm1.caa04,"'",  #CHI-970021 #FUN-990066
                  "   AND caa09 = '1'",      #CHI-970021
                  "   AND caa06 = '",tm1.caa06,"'", #CHI-970021
               "   AND aao01=aag01" 
    #CHI-970021--begin--add--
    ELSE 
     LET l_sql=" SELECT caa_file.*,aao_file.*,aag221  FROM ",
                 #g_dbs_new CLIPPED," aao_file,",
                   #g_dbs_new CLIPPED," cay_file,",  #FUN-990066
                 #g_dbs_new CLIPPED," caa_file,",
                 #g_dbs_new CLIPPED," aag_file ",
                 cl_get_target_table(g_plant_new,'aao_file'),",",  #FUN-A50102
                 cl_get_target_table(g_plant_new,'caa_file'),",",  #FUN-A50102
                 cl_get_target_table(g_plant_new,'aag_file'),      #FUN-A50102
               "  WHERE aao00='",tm.e,"'",
               "    AND aao03='",tm.yy,"'",
               "    AND aao04='",tm.mm,"' ",
                  "    AND aao02=caa10",   #FUN-990066
                  "    AND aao01=caa05",   #FUN-990066
                 #"    AND cay04=caa01",   #FUN-990066
                 #"    AND cay06=caa05",   #FUN-990066
                  "    AND caa01='",tm1.caa01,"'", #FUN-990066
                  "    AND caa05='",tm1.caa05,"'", #FUN-990066
               "    AND aao01=aag01",
               "    AND aao00=aag00",  
                  "    AND aao02='",tm1.caa10,"'",
                 #"    AND cay00 = caa04",   #CHI-970021 #FUN-990066
                  "    AND caa09 = '1'",      #CHI-970021
                  "    AND caa06 = '",tm1.caa06,"'", #CHI-970021
                  "    AND caa04='",tm1.caa04,"'",   #FUN-990066
               " UNION",
               " SELECT caa_file.*,aao_file.*,aag221  FROM ",
                 #g_dbs_new CLIPPED," aao_file,",
                   #g_dbs_new CLIPPED," cay_file,",  #FUN-990066
                 #g_dbs_new CLIPPED," cax_file,",
                 #g_dbs_new CLIPPED," caa_file,",
                 #g_dbs_new CLIPPED," aag_file ",
                 cl_get_target_table(g_plant_new,'aao_file'),",",  #FUN-A50102
                 cl_get_target_table(g_plant_new,'cax_file'),",",  #FUN-A50102
                 cl_get_target_table(g_plant_new,'caa_file'),",",  #FUN-A50102
                 cl_get_target_table(g_plant_new,'aag_file'),      #FUN-A50102
               " WHERE aao00='",tm.e,"'",
               "   AND aao03='",tm.yy,"'",
               "   AND aao04='",tm.mm,"' ",
               "   AND aao02=cax03",
               "   AND aao01=cax04",
                 #"   AND cax06=cay03",  #FUN-990066
                 #"   AND cax04=cay06",  #FUN-990066
                 #"   AND cay04=caa01",  #FUN-990066
                 #"   AND cay06=caa05",  #FUN-990066
                  "   AND caa01='",tm1.caa01,"'", #FUN-990066
                  "   AND caa05='",tm1.caa05,"'", #FUN-990066
               "   AND aao00=aag00", 
                 #"   AND cay00 = caa04",   #CHI-970021 #FUN-990066
                  "   AND caa04='",tm1.caa04,"'",  #FUN-990066
                  "   AND caa10='",tm1.caa10,"'",  #FUN-990066
                  "   AND caa09 = '1'",      #CHI-970021
                  "   AND caa06 = '",tm1.caa06,"'", #CHI-970021
               "   AND aao01=aag01" 
    END IF 
    #CHI-970021--end--add--
   #end TQC-6A0072 modify 
    #end FUN-660103 modify
 
     DISPLAY "l_sql=",l_sql
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql #CHI-970021 add
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
     PREPARE axcp312_p3 FROM l_sql
     IF STATUS THEN 
        CALL cl_err('prepare3:',STATUS,1) 
       CALL s_errmsg('','','prepare3:',STATUS,1)           #No.FUN-710027  
       CALL cl_batch_bg_javamail("N")      #FUN-570153
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
       EXIT PROGRAM 
     END IF
     DECLARE axcp312_c3 CURSOR FOR axcp312_p3
 
     #LET l_name3='yy.txt'                         #FUN-660103 mark
     CALL cl_outnam('axcp312') RETURNING l_name3   #FUN-660103
     START REPORT axcp312_rep3 TO l_name3
    #FOREACH axcp312_c3 INTO caa.*,aao.*,cay.*,l_aag221   #TQC-6A0072 mark
     FOREACH axcp312_c3 INTO caa.*,aao.*,l_aag221         #TQC-6A0072
        IF STATUS THEN
#          CALL cl_err('foreach3:',STATUS,1)             #No.FUN-710027
           CALL s_errmsg('','','foreach3:',STATUS,1)     #No.FUN-710027
           LET g_success='N'
           EXIT FOREACH
           END IF
        IF cl_null(aao.aao06) THEN LET aao.aao06=0 END IF
        OUTPUT TO REPORT axcp312_rep3(aao.*,caa.*,l_aag221,1) #cad_file #CHI-970021 add 1
     END FOREACH
     FINISH REPORT axcp312_rep3
#    LET l_cmd = "chmod 777 ", l_name3                   #No.FUN-9C0009
#    RUN l_cmd                                           #No.FUN-9C0009
     IF os.Path.chrwx(l_name3 CLIPPED,511) THEN END IF   #No.FUN-9C0009
     IF g_success='N' THEN RETURN END IF
 
    #LET l_name4='xx.txt'                          #FUN-660103 mark
     CALL cl_outnam('axcp312') RETURNING l_name4   #FUN-660103
     START REPORT axcp312_rep4 TO l_name4
    #DELETE FROM cae_file WHERE cae01=tm.yy AND cae02=tm.mm  #CHI-970021
     IF STATUS THEN
        CALL cl_err('foreach4:',STATUS,1)
        LET g_success='N'
        RETURN
     END IF
    #FOREACH axcp312_c3 INTO caa.*,aao.*,cay.*,l_aag221   #TQC-6A0072 mark
     FOREACH axcp312_c3 INTO caa.*,aao.*,l_aag221         #TQC-6A0072
        IF STATUS THEN
#           CALL cl_err('foreach4:',STATUS,1)             #No.FUN-710027
           CALL s_errmsg('','','foreach4:',STATUS,1)      #No.FUN-710027
           LET g_success='N'
           EXIT FOREACH
        END IF
        IF cl_null(aao.aao06) THEN LET aao.aao06=0 END IF
 
     #FUN-990066--begin-mark--單一部門可能不會有caz的資料，故直接抓aoo的借減貸，此段搬到rep4里面處理
     # #start FUN-660103 add
     #  #計算分攤金額
     #  IF cl_null(tm1.caa10) THEN  #CHI-970021
     #     LET l_sql ="SELECT SUM(caz10)",
     #                "  FROM ",g_dbs_new CLIPPED," caz_file",
     #                " WHERE caz01=",tm.yy,
     #                "   AND caz02=",tm.mm,
     #                "   AND caz04='",aao.aao01,"'",
     #                "   AND caz06='",caa.caa01,"'",
     #                "   AND caz00='",caa.caa04,"'"   #TQC-670010 add 
     #  #CHI-970021--end--
     #  ELSE
     #     LET l_sql ="SELECT SUM(caz10)",
     #                "  FROM ",g_dbs_new CLIPPED," caz_file",
     #                " WHERE caz01=",tm.yy,
     #                "   AND caz02=",tm.mm,
     #                "   AND caz04='",aao.aao01,"'",
     #                "   AND caz06='",caa.caa01,"'",
     #                "   AND caz00='",caa.caa04,"'",
     #                "   AND caz03='",tm1.caa10,"'"
     #  END IF
     #  #CHI-970021--end--add--  
     #        CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#FUN-920032
     #  PREPARE axcp312_p4_caz10 FROM l_sql
     #  DECLARE axcp312_c4_caz10 CURSOR FOR axcp312_p4_caz10
     #  OPEN axcp312_c4_caz10
     #  FETCH axcp312_c4_caz10 INTO l_caz10
     #  IF cl_null(l_caz10) THEN LET l_caz10 = 0 END IF
     #FUN-990066--end--mark------------------------------
       #end FUN-660103 add
     #FUN-990066--begin--add---------------------
        IF cl_null(tm1.caa10) THEN
           LET l_sql ="SELECT SUM(aao05 -aao06)",
                      #"  FROM ",g_dbs_new CLIPPED," aao_file",
                      "  FROM ",cl_get_target_table(g_plant_new,'aao_file'),  #FUN-A50102
                      " WHERE aao00='",tm.e,"'",
                      "   AND aao03='",tm.yy,"'",
                      "   AND aao04='",tm.mm,"'",
                     #"   AND aao02='",caa.caa10,"'", 此科目無區分部門，故不考慮部門
                      "   AND aao01='",caa.caa05,"'"
        ELSE
           LET l_sql ="SELECT SUM(aao05 -aao06)",
                      #"  FROM ",g_dbs_new CLIPPED," aao_file",
                      "  FROM ",cl_get_target_table(g_plant_new,'aao_file'),  #FUN-A50102
                      " WHERE aao00='",tm.e,"'",
                      "   AND aao03='",tm.yy,"'",
                      "   AND aao04='",tm.mm,"'",
                      "   AND aao02='",caa.caa10,"'",
                      "   AND aao01='",caa.caa05,"'"        
        END IF
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE axcp312_p4_caz10 FROM l_sql
        DECLARE axcp312_c4_caz10 CURSOR FOR axcp312_p4_caz10
        OPEN axcp312_c4_caz10
        FETCH axcp312_c4_caz10 INTO l_caz10
        IF cl_null(l_caz10) THEN LET l_caz10 = 0 END IF
     #FUN-990066--end--add-----------------------------------    
     #FUN-990066--begin--mark--此段搬到rep4里面處理
     # #FUN-980031--begin--add--
     #  LET l_sql="SELECT * ",
     #            "  FROM ",g_dbs_new CLIPPED," cae_file",  
     #            " WHERE cae01 = ",tm.yy,
     #            "   AND cae02 = ",tm.mm,
     #            "   AND cae03 = '",caa.caa01,"'",
     #            "   AND cae04 = '",caa.caa02,"'",
     #            "   AND cae041 = '",caa.caa04,"'",
     #            "   AND cae08 = '",caa.caa06,"'"
     #  CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
     #  PREPARE axcp312_p_cae FROM l_sql
     #  DECLARE axcp312_c_cae CURSOR FOR axcp312_p_cae
     #  OPEN axcp312_c_cae
     #  FETCH axcp312_c_cae INTO l_cae.*
     #  CALL axcp312_dis(l_cae.*) RETURNING p_sum
     #  #單位成本  = 成本  /分攤基準指標總數
     #  LET unit_cost=l_cae.cae05/p_sum 
     #  IF unit_cost IS NULL THEN LET unit_cost=0 END IF 
     #  IF cl_null(l_cae.cae09) THEN
     #     LET l_cae.cae09 = '1'
     #  END IF
     #  IF l_cae.cae09 ='1' THEN #固定
     #     IF cl_null(l_cae.cae10) THEN
     #        LET l_cae.cae10=0
     #     END IF    
     #     LET l_cae11 = l_cae.cae07 * (l_cae.cae10 - g_actcap)  #閒置製費 = 單位成本 * (標準產能 - 實際產能)
     #    IF l_cae11<0 THEN
     #       LET l_cae11=0
     #    END IF
     #  ELSE  #變動
     #    LET l_cae11=NULL
     #  END IF
     # #FUN-980031--end--add--
        OUTPUT TO REPORT axcp312_rep4(aao.*,caa.*,l_aag221,l_caz10,1,unit_cost,l_cae11) #cae_file #CHI-970021 add 1 #FUN-980031 #FUN-990066
     END FOREACH
     FINISH REPORT axcp312_rep4
#    LET l_cmd = "chmod 777 ", l_name4                   #No.FUN-9C0009
#    RUN l_cmd                                           #No.FUN-9C0009
     IF os.Path.chrwx(l_name4 CLIPPED,511) THEN END IF   #No.FUN-9C0009
   END FOREACH    #CHI-970021
   #CHI-970021--begin--add--
   LET l_sql="SELECT DISTINCT caa01,caa02,caa05,caa04,caa06,cay03,cay05 ",
             #"  FROM ",g_dbs_new CLIPPED, "caa_file",
             #"  LEFT OUTER JOIN ",g_dbs_new CLIPPED, " cay_file ON (cay00 = caa04 AND cay04=caa01 AND cay06=caa05 AND cay01='",tm.yy,"' AND cay02='",tm.mm,"')",
             "  FROM ",cl_get_target_table(g_plant_new,'caa_file'), #FUN-A50102
             "  LEFT OUTER JOIN ",cl_get_target_table(g_plant_new,'cay_file'), #FUN-A50102
             "    ON (cay00 = caa04 AND cay04=caa01 AND cay06=caa05 AND cay01='",tm.yy,"' AND cay02='",tm.mm,"')",
             " WHERE  caa09 = '2'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE p312_caa_c2 FROM l_sql
   DECLARE p312_s2 CURSOR FOR p312_caa_c2
   FOREACH p312_s2 INTO tm2.caa01,tm2.caa02,tm2.caa05,tm2.caa04,tm2.caa06,tm2.cay03,tm2.cay05
     IF tm2.cay03 IS NULL OR tm2.cay05=0 THEN CONTINUE FOREACH END IF
     LET g_chr = '2'
     LET l_sql=" SELECT caa_file.*,aao_file.*,aag221  FROM ",
                 #g_dbs_new CLIPPED," aao_file,",
                 #g_dbs_new CLIPPED," cay_file,",
                 #g_dbs_new CLIPPED," caa_file,",
                 #g_dbs_new CLIPPED," aag_file ",
                 cl_get_target_table(g_plant_new,'aao_file'),",",  #FUN-A50102
                 cl_get_target_table(g_plant_new,'cay_file'),",",  #FUN-A50102
                 cl_get_target_table(g_plant_new,'caa_file'),",",  #FUN-A50102
                 cl_get_target_table(g_plant_new,'aag_file'),      #FUN-A50102
               "  WHERE aao00='",tm.e,"'",
               "    AND aao03='",tm.yy,"'",
               "    AND aao04='",tm.mm,"' ",
               "    AND aao02=cay03",
               "    AND aao01=cay06",
               "    AND cay04=caa01", 
               "    AND cay06=caa05",
              #"    AND cay03=caa10",    #多部門包含所有部門
               "    AND cay03=aao02",
               "    AND cay00 = caa04",   #CHI-970021
               "    AND cay04='",tm2.caa01,"'",
               "    AND cay06='",tm2.caa05,"'",
               "    AND aao01=aag01",
               "    AND aao00=aag00",  
               "    AND cay03='",tm2.cay03,"'",
               "    AND cay00='",tm2.caa04,"'",
               "    AND caa02='",tm2.caa02,"'",
               "    AND caa09= '2'",
               " UNION",
               " SELECT caa_file.*,aao_file.*,aag221  FROM ",
                 #g_dbs_new CLIPPED," aao_file,",
                 #g_dbs_new CLIPPED," cay_file,",
                 #g_dbs_new CLIPPED," cax_file,",
                 #g_dbs_new CLIPPED," caa_file,",
                 #g_dbs_new CLIPPED," aag_file ",
                 cl_get_target_table(g_plant_new,'aao_file'),",",  #FUN-A50102
                 cl_get_target_table(g_plant_new,'cay_file'),",",  #FUN-A50102
                 cl_get_target_table(g_plant_new,'cax_file'),",",  #FUN-A50102
                 cl_get_target_table(g_plant_new,'caa_file'),",",  #FUN-A50102
                 cl_get_target_table(g_plant_new,'aag_file'),      #FUN-A50102
               " WHERE aao00='",tm.e,"'",
               "   AND aao03='",tm.yy,"'",
               "   AND aao04='",tm.mm,"' ",
               "   AND aao02=cax03",
               "   AND aao01=cax04",
               "   AND cax06=cay03",
               "   AND cax04=cay06",
               "   AND cay04=caa01", 
               "   AND cay06=caa05",
              #"   AND cay03=caa10",  #多部門包含所有部門
               "   AND cay03=aao02",
               "   AND cay00 = caa04",   #CHI-970021
               "   AND cay04='",tm2.caa01,"'",
               "   AND cay06='",tm2.caa05,"'",
               "   AND cay00='",tm2.caa04,"'",
               "   AND cay03='",tm2.cay03,"'",
               "   AND caa02='",tm2.caa02,"'",
               "   AND caa09= '2'",
               "   AND aao00=aag00", 
               "   AND aao01=aag01" 
     DISPLAY "l_sql=",l_sql
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql  #CHI-970021 add
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
     PREPARE axcp312_p6 FROM l_sql
     IF STATUS THEN 
       CALL s_errmsg('','','prepare6:',STATUS,1)
       CALL cl_batch_bg_javamail("N") 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM 
     END IF
     DECLARE axcp312_c6 CURSOR FOR axcp312_p6
 
     CALL cl_outnam('axcp312') RETURNING l_name5
     START REPORT axcp312_rep3 TO l_name5
     FOREACH axcp312_c6 INTO caa.*,aao.*,l_aag221 
        IF STATUS THEN
           CALL s_errmsg('','','foreach6:',STATUS,1)
           LET g_success='N'
           EXIT FOREACH
           END IF
        IF cl_null(aao.aao06) THEN LET aao.aao06=0 END IF
        OUTPUT TO REPORT axcp312_rep3(aao.*,caa.*,l_aag221,tm2.cay05) #cad_file #CHI-970021 add cay05
     END FOREACH
     FINISH REPORT axcp312_rep3
#    LET l_cmd = "chmod 777 ", l_name5                   #No.FUN-9C0009
#    RUN l_cmd                                           #No.FUN-9C0009
     IF os.Path.chrwx(l_name5 CLIPPED,511) THEN END IF   #No.FUN-9C0009
     IF g_success='N' THEN RETURN END IF
 
     CALL cl_outnam('axcp312') RETURNING l_name6
     START REPORT axcp312_rep4 TO l_name6
     IF STATUS THEN
        CALL cl_err('foreach4:',STATUS,1)
        LET g_success='N'
        RETURN
     END IF
     FOREACH axcp312_c6 INTO caa.*,aao.*,l_aag221 
        IF STATUS THEN
           CALL s_errmsg('','','foreach7:',STATUS,1)
           LET g_success='N'
           EXIT FOREACH
        END IF
        IF cl_null(aao.aao06) THEN LET aao.aao06=0 END IF
 
        #計算分攤金額
        LET l_sql ="SELECT SUM(caz10)",
                   #"  FROM ",g_dbs_new CLIPPED," caz_file",
                   "  FROM ",cl_get_target_table(g_plant_new,'caz_file'),      #FUN-A50102
                   " WHERE caz01='",tm.yy,"'",
                   "   AND caz02='",tm.mm,"'",
                   "   AND caz04='",aao.aao01,"'",
                   "   AND caz06='",caa.caa01,"'",
                   "   AND caz00='",caa.caa04,"'",
                   "   AND caz03='",tm2.cay03,"'"
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE axcp312_p7_caz10 FROM l_sql
        DECLARE axcp312_c7_caz10 CURSOR FOR axcp312_p7_caz10
        OPEN axcp312_c7_caz10
        FETCH axcp312_c7_caz10 INTO l_caz10
        IF cl_null(l_caz10) THEN LET l_caz10 = 0 END IF
      #FUN-990066--begin--mark--這段搬到rep4里面處理-----------------   
      ##FUN-980031--begin--add--
      # LET l_sql="SELECT * ",
      #           "  FROM ",g_dbs_new CLIPPED," cae_file",  
      #           " WHERE cae01 = ",tm.yy,
      #           "   AND cae02 = ",tm.mm,
      #           "   AND cae03 = '",caa.caa01,"'",
      #           "   AND cae04 = '",caa.caa02,"'",
      #           "   AND cae041 = '",caa.caa04,"'",
      #           "   AND cae08 = '",caa.caa06,"'"
      # CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
      # PREPARE axcp312_p1_cae FROM l_sql
      # DECLARE axcp312_c1_cae CURSOR FOR axcp312_p1_cae
      # OPEN axcp312_c1_cae
      # FETCH axcp312_c1_cae INTO l_cae.*
      # CALL axcp312_dis(l_cae.*) RETURNING p_sum
      # #單位成本  = 成本  /分攤基準指標總數
      # LET unit_cost=l_cae.cae05/p_sum 
      # IF unit_cost IS NULL THEN LET unit_cost=0 END IF 
      # IF cl_null(l_cae.cae09) THEN
      #    LET l_cae.cae09 = '1'
      # END IF
      # IF l_cae.cae09 ='1' THEN #固定
      #    IF cl_null(l_cae.cae10) THEN
      #       LET l_cae.cae10=0
      #    END IF    
      #    LET l_cae11 = l_cae.cae07 * (l_cae.cae10 - g_actcap)  #閒置製費 = 單位成本 * (標準產能 - 實際產能)
      #   IF l_cae11<0 THEN
      #      LET l_cae11=0
      #   END IF
      # ELSE  #變動
      #   LET l_cae11=NULL
      # END IF
      ##FUN-980031--end--add--
      #FUN-990066--end--mark---------------------------------
        OUTPUT TO REPORT axcp312_rep4(aao.*,caa.*,l_aag221,l_caz10,tm2.cay05,unit_cost,l_cae11) #cae_file #FUN-980031 #FUN-990066
     END FOREACH
     FINISH REPORT axcp312_rep4
#    LET l_cmd = "chmod 777 ", l_name6                   #No.FUN-9C0009
#    RUN l_cmd                                           #No.FUN-9C0009
     IF os.Path.chrwx(l_name6 CLIPPED,511) THEN END IF   #No.FUN-9C0009
   END FOREACH 
   CALL p312_cad08()
   CALL p312_cae05()
   #CHI-970021--end--add--
    #start FUN-660103 add
     CALL cl_outnam('axcp312') RETURNING l_name
 
     LET l_sql = "SELECT * FROM caz_file",
                 " WHERE caz01='",tm.yy,"'",
                 "   AND caz02='",tm.mm,"'"
     PREPARE axcp312_p5 FROM l_sql
     DECLARE axcp312_c5 CURSOR FOR axcp312_p5
     
     LET g_pageno=0
     START REPORT axcp312_rep TO l_name
 
     INITIALIZE sr.* TO NULL
     FOREACH axcp312_c5 INTO sr.*
        IF SQLCA.sqlcode THEN
#            CALL cl_err('axcp312_c5:',SQLCA.sqlcode,1)         #No.FUN-710027
            CALL s_errmsg('','','axcp312_c5:',SQLCA.sqlcode,1)  #No.FUN-710027
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT axcp312_rep(sr.*)
     END FOREACH
   
     FINISH REPORT axcp312_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    #end FUN-660103 add
END FUNCTION
 
#FUN-980031--begin--add-
FUNCTION axcp312_dis(p_cae) 
   DEFINE p_cae    RECORD LIKE cae_file.* 
   DEFINE l_sum    LIKE cae_file.cae06 
   DEFINE l_ima58  LIKE ima_file.ima58 
   DEFINE l_ima912 LIKE ima_file.ima912 
   DEFINE l_caa04  LIKE caa_file.caa04 
   DEFINE l_stander_tim LIKE ima_file.ima58 
   DEFINE l_qty         LIKE srl_file.srl06 
   DEFINE l_cac03       LIKE cac_file.cac03 
   DEFINE l_srl01b      LIKE srl_file.srl01     #CHI-9A0021 add
   DEFINE l_srl01e      LIKE srl_file.srl01     #CHI-9A0021 add
   DEFINE l_correct     LIKE type_file.chr1     #CHI-9A0021 add
   DEFINE l_ecb19  LIKE ecb_file.ecb19  #FUN-A90065
   DEFINE l_ecb21  LIKE ecb_file.ecb21  #FUN-A90065

  #當月起始日與截止日
   CALL s_azm(tm.yy,tm.mm) RETURNING l_correct,l_srl01b,l_srl01e   #CHI-9A0021 add

   CASE p_cae.cae08     #分攤方式 
     WHEN '1' #實際工時  投入工時
         #FUN-A90065(S)
         IF g_argv0='2' THEN
            SELECT SUM(cam08) INTO l_sum FROM cam_file,cal_file
             ,ima_file,cak_file,sfb_file
             WHERE cam01 BETWEEN l_srl01b AND l_srl01e
               AND cam02 = p_cae.cae03 
               AND cam01 = cal01
               AND cam02 = cal02
               AND calfirm = 'Y'
               AND sfb01 = cam04
               AND sfb05 = ima01
               AND ima131 = cak01
               AND cak02 = cam02
               AND cak03 = p_cae.cae04
         ELSE
         #FUN-A90065(E)
              SELECT SUM(srl05) INTO l_sum FROM srl_file,srk_file
               ,ima_file,cak_file    #FUN-990066
              #WHERE YEAR(srl01)=tm.yy AND MONTH(srl01)=tm.mm   #CHI-9A0021
               WHERE srl01 BETWEEN l_srl01b AND l_srl01e        #CHI-9A0021
                 AND srl02=p_cae.cae03 
                 AND srl01=srk01
                 AND srl02=srk02
                 AND srkfirm = 'Y'
                 #FUN-990066--begin--add---------------
                 AND srl04 = ima01
                 AND ima131 = cak01
                 AND cak02 = srl02
                 AND cak03 = p_cae.cae04
                 #FUN-990066--end--add--------------------
         END IF
     WHEN '2' #標準工時  生產數量
         #FUN-A90065(S)
         IF g_argv0='2' THEN
            SELECT SUM(cam07) INTO l_qty FROM cam_file,cal_file 
             ,ima_file,cak_file,sfb_file
             WHERE cam01 BETWEEN l_srl01b AND l_srl01e
               AND cam02=p_cae.cae03  
               AND cam01=cal01
               AND cam02=cal02
               AND calfirm = 'Y'
               AND sfb01 = cam04
               AND sfb05 = ima01
               AND ima131 = cak01
               AND cak02 = cam02
               AND cak03 = p_cae.cae04
         ELSE
         #FUN-A90065(E)
              SELECT SUM(srl06) INTO l_qty FROM srl_file,srk_file 
               ,ima_file,cak_file    #FUN-990066
              #WHERE YEAR(srl01)=tm.yy AND MONTH(srl01)=tm.mm   #CHI-9A0021
               WHERE srl01 BETWEEN l_srl01b AND l_srl01e        #CHI-9A0021
                 AND srl02=p_cae.cae03  
                 AND srl01=srk01
                 AND srl02=srk02
                 AND srkfirm = 'Y'
                 #FUN-990066--begin--add--------
                 AND srl04 = ima01
                 AND ima131 = cak01
                 AND cak02 = srl02
                 AND cak03 = p_cae.cae04
                 #FUN-990066--end--add-----------
         END IF
              IF l_qty IS NULL THEN LET l_qty=0 END IF 
             
              #統計總標準工時
         #FUN-A90065(S)
         IF g_argv0='2' THEN
            OPEN ecb_cur USING p_cae.cae03 
            FETCH ecb_cur INTO l_ecb19
            IF STATUS THEN 
               CALL cl_err('ecb_cur',STATUS,1) 
               LET g_success='N' 
            END IF 
            CLOSE ecb_cur
            IF l_ecb19 IS NULL THEN LET l_ecb19=0 END IF 
            LET l_stander_tim=l_ecb19     #人工  
         ELSE
         #FUN-A90065(E)
              OPEN ima_cur USING p_cae.cae03
              FETCH ima_cur INTO l_ima58 
              IF STATUS THEN 
                 CALL cl_err('ima_cur',STATUS,1) 
                 LET g_success='N' END IF 
              CLOSE ima_cur   
              IF l_ima58  IS NULL THEN LET l_ima58=0  END IF 
              LET l_stander_tim=l_ima58     #人工  
         END IF
              LET l_sum=l_qty*l_stander_tim
     WHEN '3' #標準機時  生產數量
         #FUN-A90065(S)
         IF g_argv0='2' THEN
            SELECT SUM(cam07) INTO l_qty FROM cam_file,cal_file 
             ,ima_file,cak_file,sfb_file
             WHERE cam01 BETWEEN l_srl01b AND l_srl01e
               AND cam02=p_cae.cae03  
               AND cam01=cal01
               AND cam02=cal02
               AND calfirm = 'Y'
               AND sfb01 = cam04
               AND sfb05 = ima01
               AND ima131 = cak01
               AND cak02 = cam02
               AND cak03 = p_cae.cae04
         ELSE
         #FUN-A90065(E)
              SELECT SUM(srl06) INTO l_qty FROM srl_file,srk_file 
               ,ima_file,cak_file    #FUN-990066
              #WHERE YEAR(srl01)=tm.yy AND MONTH(srl01)=tm.mm   #CHI-9A0021
               WHERE srl01 BETWEEN l_srl01b AND l_srl01e        #CHI-9A0021
                 AND srl02=p_cae.cae03  
                 AND srl01=srk01
                 AND srl02=srk02
                 AND srkfirm = 'Y'
                 #FUN-990066--begin--add------
                 AND srl04 = ima01
                 AND ima131 = cak01
                 AND cak02 = srl02
                 AND cak03 = p_cae.cae04
                 #FUN-990066--end--add-------
         END IF
              IF l_qty IS NULL THEN LET l_qty=0 END IF 
             
              #統計總標準工時
         #FUN-A90065(S)
         IF g_argv0='2' THEN
            OPEN ecb_cur1 USING p_cae.cae03 
            FETCH ecb_cur1 INTO l_ecb21
            IF STATUS THEN 
               CALL cl_err('ecb_cur',STATUS,1) 
               LET g_success='N' 
            END IF 
            CLOSE ecb_cur1
            IF l_ecb21 IS NULL THEN LET l_ecb21=0 END IF 
            LET l_stander_tim=l_ecb21
         ELSE
         #FUN-A90065(E)
              OPEN ima_cur1 USING p_cae.cae03
              FETCH ima_cur1 INTO l_ima912 
              IF STATUS THEN 
                 CALL cl_err('ima_cur1',STATUS,1) 
                 LET g_success='N' END IF 
              CLOSE ima_cur1   
              IF l_ima912  IS NULL THEN LET l_ima912=0  END IF 
              LET l_stander_tim=l_ima912
         END IF
              LET l_sum=l_qty*l_stander_tim
     WHEN '4' #總產出數量 
         #FUN-A90065(S)
         IF g_argv0='2' THEN
            SELECT SUM(cam07) INTO l_qty FROM cam_file,cal_file 
             ,ima_file,cak_file,sfb_file
             WHERE cam01 BETWEEN l_srl01b AND l_srl01e
               AND cam02=p_cae.cae03  
               AND cam01=cal01
               AND cam02=cal02
               AND calfirm = 'Y'
               AND sfb01 = cam04
               AND sfb05 = ima01
               AND ima131 = cak01
               AND cak02 = cam02
               AND cak03 = p_cae.cae04
         ELSE
         #FUN-A90065(E)
              SELECT SUM(srl06) INTO l_qty FROM srl_file,srk_file  
               ,ima_file,cak_file    #FUN-990066
              #WHERE YEAR(srl01)=tm.yy AND MONTH(srl01)=tm.mm  #CHI-9A0021
               WHERE srl01 BETWEEN l_srl01b AND l_srl01e       #CHI-9A0021
                 AND srl02=p_cae.cae03  
                 AND srl01=srk01
                 AND srl02=srk02 
                 AND srkfirm = 'Y'
                 #FUN-990066--begin--add----------
                 AND srl04 = ima01
                 AND ima131 = cak01
                 AND cak02 = srl02
                 AND cak03 = p_cae.cae04
                 #FUN-990066--end--add------------
         END IF
              IF l_qty IS NULL THEN LET l_qty=0 END IF 
              SELECT cac03 INTO l_cac03 FROM cac_file 
               WHERE cac01=p_cae.cae03 AND cac02=p_cae.cae04 
              IF l_cac03 IS NULL THEN LET l_cac03=0 END IF 
              LET l_sum=l_qty*l_cac03/100 
     WHEN '5' #實際機時 
         #FUN-A90065(S)
         IF g_argv0='2' THEN
            SELECT SUM(cam081) INTO l_qty FROM cam_file,cal_file 
             ,ima_file,cak_file,sfb_file
             WHERE cam01 BETWEEN l_srl01b AND l_srl01e
               AND cam02=p_cae.cae03  
               AND cam01=cal01
               AND cam02=cal02
               AND calfirm = 'Y'
               AND sfb01 = cam04
               AND sfb05 = ima01
               AND ima131 = cak01
               AND cak02 = cam02
               AND cak03 = p_cae.cae04
         ELSE
         #FUN-A90065(E)
              SELECT SUM(srl09) INTO l_qty FROM srl_file,srk_file 
               ,ima_file,cak_file   #FUN-990066
              #WHERE YEAR(srl01)=tm.yy AND MONTH(srl01)=tm.mm  #CHI-9A0021
               WHERE srl01 BETWEEN l_srl01b AND l_srl01e       #CHI-9A0021
                 AND srl02=p_cae.cae03  
                 AND srl01=srk01
                 AND srl02=srk02
                 AND srkfirm = 'Y'
                 #FUN-990066--begin--add------
                 AND srl04 = ima01
                 AND ima131 = cak01
                 AND cak02 = srl02
                 AND cak03 = p_cae.cae04
                 #FUN-990066--end--add---------
         END IF
              IF l_qty IS NULL THEN LET l_qty=0 END IF 
              LET l_sum=l_qty
     EXIT CASE 
   END CASE 
   IF l_sum IS NULL THEN LET l_sum=0 END IF 
   LET g_actcap = l_sum    #FUN-910031 實際工時
   # 十號公報: 當製費類別=固定時,需比較實際產能vs標準產能,若實際產能< 標準產能,則分攤基礎指標總數=標準產能
   IF p_cae.cae09=1 AND l_sum < p_cae.cae10 THEN
   	  LET l_sum=p_cae.cae10
   END IF
   RETURN l_sum
END FUNCTION 
#FUN-980031--end--add--

#start FUN-660103 add
REPORT axcp312_rep1(aao,cay,p_aag221,p_cax07_sum)
   DEFINE aao           RECORD LIKE aao_file.*,
          cay           RECORD LIKE cay_file.*,
          p_aag221      LIKE aag_file.aag221,
          p_cax07_sum   LIKE cax_file.cax07,
          l_sql         STRING,
          l_cax         RECORD LIKE cax_file.*
 
   OUTPUT TOP MARGIN g_top_margin
          LEFT MARGIN g_left_margin
          BOTTOM MARGIN g_bottom_margin
          PAGE LENGTH g_page_line
  
   ORDER BY cay.cay06,cay.cay04  #會計科目-成本中心
  
   FORMAT
     ON EVERY ROW
        LET l_cax.cax00 = cay.cay00              #分攤類別
        LET l_cax.cax01 = tm.yy                  #現行計算年度
        LET l_cax.cax02 = tm.mm                  #現行計算期別
        LET l_cax.cax03 = aao.aao02              #部門編號
        LET l_cax.cax04 = aao.aao01              #科目編號
        LET l_cax.cax05 = aao.aao05 - aao.aao06  #借方餘額-貸方餘額
        LET l_cax.cax06 = cay.cay04              #成本中心
        LET l_cax.cax07 = cay.cay05              #分攤比例
                                                 #當期餘額*(分攤權數/總分攤權數) 
        LET l_cax.cax10 = l_cax.cax05 * (l_cax.cax07 / p_cax07_sum) 
        LET l_cax.caxlegal = g_legal   #FUN-A50075  
        INSERT INTO cax_file VALUES(l_cax.*)
       #IF SQLCA.SQLCODE=-239 THEN               #TQC-790087 mark
        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790087
           DELETE FROM cax_file WHERE cax01=tm.yy AND cax02=tm.mm
           INSERT INTO cax_file VALUES(l_cax.*)
           IF SQLCA.SQLCODE THEN 
              CALL cl_err('ins_cax',SQLCA.SQLCODE,1) 
              LET g_success='N'
           END IF
        END IF
END REPORT
 
REPORT axcp312_rep2(aao,cay,p_aag221,p_aaosum,p_cax10,p_srl06,p_caz09_sum)#CHI-970021 cam07-->srl06
   DEFINE aao           RECORD LIKE aao_file.*,
          cay           RECORD LIKE cay_file.*,
          p_aag221      LIKE aag_file.aag221,
          p_aaosum      LIKE aao_file.aao05,   #FUN-660201 add
          p_cax10       LIKE cax_file.cax10,
         #p_cam07       LIKE cam_file.cam07, #CHI-970021
          p_srl06       LIKE srl_file.srl06, #CHI-970021
          p_caz09_sum   LIKE caz_file.caz09,
          l_sql         STRING,
          l_caz         RECORD LIKE caz_file.*
 
   OUTPUT TOP MARGIN g_top_margin
          LEFT MARGIN g_left_margin
          BOTTOM MARGIN g_bottom_margin
          PAGE LENGTH g_page_line
 
   ORDER BY cay.cay06,cay.cay04  #會計科目-成本中心
 
   FORMAT
 
     ON EVERY ROW
        LET l_caz.caz00 = cay.cay00         #分攤類別
        LET l_caz.caz01 = tm.yy             #現行計算年度
        LET l_caz.caz02 = tm.mm             #現行計算期別
        LET l_caz.caz03 = aao.aao02         #部門編號
        LET l_caz.caz04 = aao.aao01         #科目編號
                                            #借方餘額-貸方餘額+當期餘額
        LET l_caz.caz05 = aao.aao05 - aao.aao06 + p_cax10 + p_aaosum   #FUN-660201 add p_aaosum 
        LET l_caz.caz06 = cay.cay04         #成本中心
        LET l_caz.caz07 = cay.cay05         #分攤比例
        LET l_caz.caz08 = p_srl06           #約當產量 #CHI-970021
                                            #分攤權數*約當產量
        LET l_caz.caz09 = l_caz.caz07 * l_caz.caz08
                                            #當期餘額*(分攤權量/總分攤權量)
        LET l_caz.caz10 = l_caz.caz05 * (l_caz.caz09 / p_caz09_sum)
        LET l_caz.cazlegal = g_legal    #FUN-A50075 
        INSERT INTO caz_file VALUES(l_caz.*)
       #IF SQLCA.SQLCODE=-239 THEN               #TQC-790087 mark
        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790087
           DELETE FROM caz_file WHERE caz01=tm.yy AND caz02=tm.mm
           INSERT INTO caz_file VALUES(l_caz.*)
           IF SQLCA.SQLCODE THEN 
              CALL cl_err('ins_caz',SQLCA.SQLCODE,1) 
              LET g_success='N'
           END IF
        END IF
END REPORT
#end FUN-660103 add
 
REPORT axcp312_rep3(aao,caa,p_aag221,l_cay05)  #CHI-970021
   DEFINE l_sum05      LIKE aao_file.aao06,
          l_cad        RECORD LIKE cad_file.*,
          aao          RECORD LIKE aao_file.*,
          caa          RECORD LIKE caa_file.*,
          l_cay05      LIKE cay_file.cay05,   #CHI-970021
          p_aag221     LIKE aag_file.aag221
 
   OUTPUT TOP MARGIN g_top_margin
          LEFT MARGIN g_left_margin
          BOTTOM MARGIN g_bottom_margin
          PAGE LENGTH g_page_line
 
   ORDER BY caa.caa02,caa.caa05,caa.caa01  #成本項目-會計科目-成本中心
 
   FORMAT
 
     ON EVERY ROW
      #DELETE FROM cad_file WHERE cad01=tm.yy AND cad02=tm.mm  #CHI-970021
 
       LET l_cad.cad01=tm.yy                #年度
       LET l_cad.cad02=tm.mm                #月份
       LET l_cad.cad03=caa.caa01            #成本中心
       LET l_cad.cad04=caa.caa02            #成本項目
       LET l_cad.cad05=caa.caa04            #成本分類
       LET l_cad.cad06=caa.caa05            #會計科目
       LET l_cad.cad07=p_aag221             #固定變動
       IF cl_null(aao.aao05) THEN LET aao.aao05 = 0 END IF  #CHI-970021
       IF cl_null(aao.aao06) THEN LET aao.aao06 = 0 END IF  #CHI-970021
       IF g_chr = '2' THEN                    #CHI-970021
          LET l_cad.cad08=(aao.aao05-aao.aao06)*l_cay05  #本月投入金額  #CHI-970021
          LET l_cad.cad08  = s_trunc(l_cad.cad08,6)  #CHI-970021
       ELSE                                   #CHI-970021
          LET l_cad.cad08=aao.aao05-aao.aao06  #本月投入金額
       END IF
       LET l_cad.cadlegal = g_legal   #FUN-A50075
       INSERT INTO cad_file VALUES(l_cad.*)
       #CHI-970021--begin--mod--
       CASE 
         WHEN SQLCA.sqlcode = 0 Exit case
         WHEN cl_sql_dup_value(SQLCA.SQLCODE) 
                     UPDATE cad_file SET cad08=cad08+l_cad.cad08
                      WHERE cad01=tm.yy AND cad02=tm.mm AND cad03=caa.caa01
                        AND cad04=caa.caa02 AND cad06=caa.caa05
         OTHERWISE
            CALL cl_err3("ins","cad_file",tm.yy,tm.mm,SQLCA.sqlcode,'','',0)
             LET g_success='N'
        END CASE
     ##IF SQLCA.SQLCODE=-239 THEN               #TQC-790087 mark
      #IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790087
      #   DELETE FROM cad_file WHERE cad01=tm.yy AND cad02=tm.mm
      #   INSERT INTO cad_file VALUES(l_cad.*)
      #   IF SQLCA.SQLCODE THEN 
      #      CALL cl_err('INS cad',SQLCA.SQLCODE,1) 
      #      LET g_success='N'
      #   END IF
      #END IF
      #CHI-970021--end--mod--
END REPORT
 
#CHI-970021--begin--add--
FUNCTION p312_cad08()
   DEFINE l_aao01      LIKE aao_file.aao01,
          l_aao02      LIKE aao_file.aao02,
          l_cad08      LIKE cad_file.cad08,
          l_cad08_tot  LIKE cad_file.cad08,
          l_aao05      LIKE aao_file.aao05,
          l_aao06      LIKE aao_file.aao06,
          l_cad01      LIKE cad_file.cad01,
          l_cad02      LIKE cad_file.cad02,
          l_cad03      LIKE cad_file.cad03,
          l_cad04      LIKE cad_file.cad04,
          l_cad06      LIKE cad_file.cad06,
          l_sql        STRING
 
     LET l_sql=" SELECT aao01,aao02,SUM(aao05),SUM(aao06)  FROM ",
               #g_dbs_new CLIPPED," aao_file ",
               cl_get_target_table(g_plant_new,'aao_file'),  #FUN-A50102
               "  WHERE aao00='",tm.e,"'",
               "    AND aao03='",tm.yy,"'",
               "    AND aao04='",tm.mm,"' ",
               "  GROUP BY aao01,aao02"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE axcp312_p8 FROM l_sql
   DECLARE axcp312_c8 CURSOR FOR axcp312_p8
 
   FOREACH axcp312_c8 INTO l_aao01,l_aao02,l_aao05,l_aao06
      IF STATUS THEN
         CALL s_errmsg('','','foreach8:',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
         END IF
      IF cl_null(l_aao02) THEN CONTINUE FOREACH END IF #部門為一個空白的排除
      IF cl_null(l_aao05) THEN LET l_aao05=0 END IF
      IF cl_null(l_aao06) THEN LET l_aao06=0 END IF
      LET l_cad08_tot=l_aao05-l_aao06 #本月投入金額  
      LET l_cad08 = 0
      SELECT SUM(cad08) INTO l_cad08 FROM cad_file,caa_file
       WHERE cad01 = tm.yy
         AND cad02 = tm.mm
         AND cad03 = caa01
         AND cad04 = caa02
         AND cad05 = caa04
         AND cad06 = l_aao01
         AND cad06 = caa05
         AND caa09 = '2'
        #AND caa10 = l_aao02 #多部門不考慮部門
         
      IF cl_null(l_cad08) THEN LET l_cad08 = 0 END IF
      IF l_cad08=0 THEN CONTINUE FOREACH END IF
      #判斷是否有尾差
      LET l_cad08_tot = l_cad08_tot - l_cad08
      IF l_cad08_tot > 0 THEN
         #將尾差攤到cad08最大的那一筆
         LET l_sql ="SELECT cad01,cad02,cad03,cad04,cad06 FROM cad_file,caa_file",
                    " WHERE cad01 = ", tm.yy ,
                    "   AND cad02 = ", tm.mm ,
                    "   AND cad03 = caa01 ",
                    "   AND cad04 = caa02 ",
                    "   AND cad05 = caa04 ",
                    "   AND cad06 = '",l_aao01 ,"'",
                    "   AND cad06 = caa05 ",
                    "   AND caa09 = '2' ",
                   #"   AND caa10 = '", l_aao02 ,"'", #多部門不考慮部門
                    "   ORDER BY cad08 DESC "
         PREPARE axcp312_cad08_c_p FROM l_sql
         DECLARE axcp312_cad08_c CURSOR FOR axcp312_cad08_c_p
         FOREACH axcp312_cad08_c_p INTO l_cad01,l_cad02,l_cad03,l_cad04,l_cad06
            UPDATE cad_file SET cad08 = cad08 + l_cad08_tot
             WHERE cad01 = l_cad01
               AND cad02 = l_cad02
               AND cad03 = l_cad03
               AND cad04 = l_cad04
               AND cad06 = l_cad06
            EXIT FOREACH
         END FOREACH
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION p312_cae05()
   DEFINE l_caz00      LIKE caz_file.caz00,
          l_caz03      LIKE caz_file.caz03,
          l_caz04      LIKE caz_file.caz04,
          l_caz06      LIKE caz_file.caz06,
          l_caz10      LIKE caz_file.caz10,
          l_cae05      LIKE cae_file.cae05,
          l_tail       LIKE cae_file.cae05,
          l_cae01      LIKE cae_file.cae01,
          l_cae02      LIKE cae_file.cae02,
          l_cae03      LIKE cae_file.cae03,
          l_cae04      LIKE cae_file.cae04,
          l_cae041     LIKE cae_file.cae041,
          l_cae08      LIKE cae_file.cae08,
          l_sql        STRING
 
     LET l_sql=" SELECT caz00,caz03,caz04,caz06,SUM(caz10)  FROM ",
               #g_dbs_new CLIPPED," caz_file ",
               cl_get_target_table(g_plant_new,'caz_file'),  #FUN-A50102
               "  WHERE caz01= ",tm.yy,
               "    AND caz02= ",tm.mm,
               "  GROUP BY caz00,caz03,caz04,caz06"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
   PREPARE axcp312_p9 FROM l_sql
   DECLARE axcp312_c9 CURSOR FOR axcp312_p9
 
   FOREACH axcp312_c9 INTO l_caz00,l_caz03,l_caz04,l_caz06,l_caz10
      IF STATUS THEN
         CALL s_errmsg('','','foreach8:',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
         END IF
      IF cl_null(l_caz03) THEN CONTINUE FOREACH END IF #部門為一個空白的排除
      IF cl_null(l_caz10) THEN LET l_caz10=0 END IF
      LET l_cae05 = 0
      SELECT SUM(cae05) INTO l_cae05 FROM cae_file,caa_file
       WHERE cae01  = tm.yy     #年度    
         AND cae02  = tm.mm     #月份    
         AND cae03  = l_caz06   #成本中心
        #AND cae04  =           #成本項目
         AND cae041 = l_caz00   #成本分類
        #AND cae08  =           #分攤方式
         AND caa01  = cae03
         AND caa02  = cae04
         AND caa04  = cae041
         AND caa05  = l_caz04
         AND caa09  = '2'
        #AND caa10  = l_caz03  #多部門不考慮部門
         
      IF cl_null(l_cae05) THEN LET l_cae05 = 0 END IF
      IF l_cae05=0 THEN CONTINUE FOREACH END IF
      #判斷是否有尾差
      LET l_tail = l_caz10 - l_cae05
      IF l_tail > 0 THEN
         #將尾差攤到cae05最大的那一筆
         LET l_sql = "SELECT cae01,cae02,cae03,cae04,cae041,cae08 FROM cae_file,caa_file ",
                     " WHERE cae01  =  ", tm.yy ,        #年度    
                     "   AND cae02  =  ", tm.mm ,        #月份    
                     "   AND cae03  = '", l_caz06,"'",   #成本中心
                     "   AND cae041 = '", l_caz00,"'",   #成本分類
                     "   AND caa01  = cae03  ",
                     "   AND caa02  = cae04  ",
                     "   AND caa04  = cae041 ",
                     "   AND caa05  = '", l_caz04,"'",
                     "   AND caa09  = '2'",
                    #"   AND caa10  = '",l_caz03,"'", #多部門不考慮部門
                     "   ORDER BY cae05 DESC "
         PREPARE axcp312_cae05_c_p FROM l_sql
         DECLARE axcp312_cae05_c CURSOR FOR axcp312_cae05_c_p
         FOREACH axcp312_cae05_c_p INTO l_cae01,l_cae02,l_cae03,l_cae04,l_cae041,l_cae08
            UPDATE cae_file SET cae05 = cae05 + l_tail
             WHERE cae01  = l_cae01 
               AND cae02  = l_cae02  
               AND cae03  = l_cae03  
               AND cae04  = l_cae04  
               AND cae041 = l_cae041 
               AND cae08  = l_cae08
            EXIT FOREACH
         END FOREACH
      END IF
   END FOREACH
END FUNCTION
#CHI-970021--end--add--
 
REPORT axcp312_rep4(aao,caa,p_aag221,p_caz10,l_cay05,unit_cost,l_cae11) #CHI-970021 #FUN-980031 #FUN-990066
   DEFINE l_sum05      LIKE aao_file.aao05,
          l_cae        RECORD LIKE cae_file.*,
          aao          RECORD LIKE aao_file.*,
          caa          RECORD LIKE caa_file.*,
          p_aag221     LIKE aag_file.aag221,
          l_cay05      LIKE cay_file.cay05,  #CHI-970021
          p_caz10      LIKE caz_file.caz10,      #FUN-660103 add
          l_sql        STRING                    #FUN-660103 add
   DEFINE l_sum        LIKE cae_file.cae05       #FUN-980031 #FUN-990066
   DEFINE unit_cost    LIKE cae_file.cae07       #FUN-980031
   DEFINE l_cae11      LIKE cae_file.cae11       #FUN-980031
   DEFINE l_cae05      LIKE cae_file.cae05       #FUN-990066
 
   OUTPUT TOP MARGIN g_top_margin
          LEFT MARGIN g_left_margin
          BOTTOM MARGIN g_bottom_margin
          PAGE LENGTH g_page_line
 
   ORDER BY caa.caa01,caa.caa02  #成本中心-成本項目
 
   FORMAT
 
     BEFORE GROUP OF caa.caa01
       LET l_sum05=0
    
     ON EVERY ROW
       PRINT caa.caa01,' ',caa.caa02,' ',aao.aao05,' ',aao.aao06
    
#     AFTER GROUP OF caa.caa02             #No.CHI-940027  --MARK--
      #LET l_sum05=GROUP SUM(aao.aao05-aao.aao06)   #FUN-660103 mark
 
       LET l_cae.cae01=tm.yy               #年
       LET l_cae.cae02=tm.mm               #月
       LET l_cae.cae03=caa.caa01           #成本中心
       LET l_cae.cae04=caa.caa02           #成本項目
      #LET l_cae.cae05=l_sum05             #成本   #FUN-660103 mark
       IF g_chr = '2' THEN                   #CHI-970021
          LET l_cae.cae05 = p_caz10*l_cay05  #CHI-970021
          LET l_cae.cae05  = s_trunc(l_cae.cae05,6) #CHI-970021
       ELSE                                  #CHI-970021
          LET l_cae.cae05=p_caz10             #成本   #FUN-660103
       END IF                                #CHI-970021
      #LET l_cae.cae06=0                   #分攤基礎指標總數 #FUN-990066
      #LET l_cae.cae07=0                   #單位成本         #FUN-990066
       LET l_cae.cae08=caa.caa06           #分攤方式
       LET l_cae.cae09=caa.caa07           #FUN-910031
       LET l_cae.cae10=caa.caa08           #FUN-910031
       LET l_cae.caeuser=g_user            #資料所有者
       LET l_cae.caegrup=g_grup            #資料所有部門
       LET l_cae.caemodu=g_user            #資料修改者
       LET l_cae.caedate=g_today           #最近修改日
       #No.TQC-9C0077  --Begin
       LET l_cae.caeoriu=g_user
       LET l_cae.caeorig=g_grup 
       #No.TQC-9C0077  --End  
       LET l_cae.cae041 = caa.caa04        #NO.CHI-940027
       #FUN-990066--begin--add------------------------
        CALL axcp312_dis(l_cae.*) RETURNING l_sum
        LET l_cae05 = 0 
        SELECT SUM(cae05) INTO l_cae05 FROM cae_file WHERE cae01 = l_cae.cae01
                          AND cae02 = l_cae.cae02
                          AND cae03 = l_cae.cae03
                          AND cae04 = l_cae.cae04
                          AND cae041 = l_cae.cae041
                          AND cae08 = l_cae.cae08
        IF cl_null(l_cae05) THEN LET l_cae05= 0 END IF
        #單位成本 = 成本 / 分攤基准指標總數 
        LET unit_cost=(l_cae.cae05 +l_cae05)/l_sum
        IF unit_cost IS NULL THEN LET unit_cost=0 END IF 
        LET l_cae.cae07=unit_cost  #單位成本
        IF cl_null(l_cae.cae09) THEN
          LET l_cae.cae09 = '1'
       END IF
       IF l_cae.cae09 ='1' THEN  #固定
          IF cl_null(l_cae.cae10) THEN
             LET l_cae.cae10=0
          END IF    
          LET l_cae11 = l_cae.cae07 * (l_cae.cae10 - g_actcap) #閑置制費 = 單位成本 * (標准產能 - 實際產能)
          IF l_cae11<0 THEN
             LET l_cae11=0
          END IF
       ELSE  #變動
         LET l_cae11=NULL
       END IF
       LET l_cae.cae11 = l_cae11 
       LET l_cae.cae06=l_sum  #分攤基礎指標總數
       LET l_cae.cae07=unit_cost #單位成本
       LET l_cae.caelegal = g_legal   #FUN-A50075
       #FUN-990066--end--add--------------------------------------------
       INSERT INTO cae_file VALUES(l_cae.*)
       #CHI-970021--begin--mod--
       CASE
         WHEN SQLCA.sqlcode = 0 EXIT CASE   #FUN-990066
         WHEN cl_sql_dup_value(SQLCA.SQLCODE)
                     UPDATE cae_file SET cae05=cae05+l_cae.cae05,
                                         cae06=l_sum,cae07=unit_cost ,  #FUN-980031 #FUN-990066
                                         cae11=l_cae11                  #FUN-980031
                      WHERE cae01=tm.yy AND cae02=tm.mm AND cae03=caa.caa01
                        AND cae04=caa.caa02 AND cae041=caa.caa04 AND cae08=caa.caa06
         OTHERWISE
            CALL cl_err3("ins","cae_file",tm.yy,tm.mm,SQLCA.sqlcode,'','',0)
             LET g_success='N'
        END CASE
     ##IF SQLCA.SQLCODE=-239 THEN               #TQC-790087 mark
      #IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790087
      #   DELETE FROM cae_file WHERE cae01=tm.yy AND cae02=tm.mm
      #   INSERT INTO cae_file VALUES(l_cae.*)
      #   IF SQLCA.SQLCODE THEN
      #      CALL cl_err('INS cae',SQLCA.SQLCODE,1) 
      #      LET g_success='N'
      #   END IF
      #END IF
      #CHI-970021--end--mod--
END REPORT
 
#start FUN-660103 add
REPORT axcp312_rep(sr)
   DEFINE li_result            LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE l_last_sw            LIKE type_file.chr1,         #No.FUN-680122 VARCHAR(1),
          l_cnt                LIKE type_file.num10,        #No.FUN-680122 INTEGER,
          sr                   RECORD LIKE caz_file.*,
          l_gem02              LIKE gem_file.gem02,
          l_aag02              LIKE aag_file.aag02,
          l_gem02_1            LIKE gem_file.gem02,
          l_str1,l_str2,l_str3 STRING
 
  OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
  ORDER BY sr.caz06,sr.caz04,sr.caz05,sr.caz03
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      LET l_str1 = g_x[11] CLIPPED,sr.caz01 USING '&&&&',' ',
                   g_x[12] CLIPPED,sr.caz02 USING '&&'
      PRINT COLUMN ((g_len-FGL_WIDTH(l_str1 CLIPPED))/2)+1,l_str1 CLIPPED
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.caz05
      #成本中心名稱
      CASE g_ccz.ccz06
         WHEN '3'
            SELECT ecd02 INTO l_gem02 FROM ecd_file WHERE ecd01 = sr.caz06
         WHEN '4'
            SELECT eca02 INTO l_gem02 FROM eca_file WHERE eca01 = sr.caz06
         OTHERWISE
            SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.caz06
      END CASE
      IF cl_null(l_gem02) THEN LET l_gem02='' END IF
      LET l_str1 = sr.caz06,' ',l_gem02 CLIPPED
      #會計科目名稱
      SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=sr.caz04
                                                AND aag00=tm.e       #No.FUN-730057
      IF cl_null(l_aag02) THEN LET l_aag02='' END IF
      LET l_str2 = sr.caz04,' ',l_aag02 CLIPPED
      PRINT COLUMN g_c[31],l_str1,
            COLUMN g_c[32],l_str2,
            COLUMN g_c[33],cl_numfor(sr.caz05,33,g_azi03);   #MOD-770070 modify azi04->azi03
 
   ON EVERY ROW
      #直接部門名稱
      SELECT gem02 INTO l_gem02_1 FROM gem_file WHERE gem01=sr.caz03
      IF cl_null(l_gem02_1) THEN LET l_gem02_1='' END IF
      LET l_str3 = sr.caz03,' ',l_gem02_1 CLIPPED
      PRINT COLUMN g_c[34],l_str3,
            COLUMN g_c[35],cl_numfor(sr.caz07,35,3),
            COLUMN g_c[36],cl_numfor(sr.caz08,36,2),
            COLUMN g_c[37],cl_numfor(sr.caz09,37,2),
            COLUMN g_c[38],cl_numfor(sr.caz10,38,g_azi03)   #MOD-770070 modify azi04->azi03
 
   AFTER GROUP OF sr.caz05
      PRINT COLUMN g_c[34],g_x[13] CLIPPED,
            COLUMN g_c[35],cl_numfor(GROUP SUM(sr.caz07),35,3),
            COLUMN g_c[36],cl_numfor(GROUP SUM(sr.caz08),36,2),
            COLUMN g_c[37],cl_numfor(GROUP SUM(sr.caz09),37,2),
            COLUMN g_c[38],cl_numfor(GROUP SUM(sr.caz10),38,g_azi03)  #MOD-770070 modify azi04->azi03
      PRINT
 
   ON LAST ROW
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len] CLIPPED
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE 
         SKIP 2 LINE
      END IF
END REPORT
#end FUN-660103 add
 
FUNCTION p312_get_dbs(p_plant)
   DEFINE p_plant  LIKE type_file.chr20          #No.FUN-680122 VARCHAR(20)
 
   SELECT azp03 INTO g_dbs_new FROM azp_file
    WHERE azp01 = p_plant
   IF STATUS THEN LET g_dbs_new=NULL RETURN END IF
   LET g_dbs_new=g_dbs_new CLIPPED
   #No.FUN-7B0012  --Begin
   LET g_dbs_new = s_dbstring(g_dbs_new CLIPPED)    #FUN-820017
   #No.FUN-7B0012  --End  
END FUNCTION
