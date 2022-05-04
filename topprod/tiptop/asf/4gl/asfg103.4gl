# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asfg103.4gl
# Descriptions...: 派工單資料列印
# Date&Auther....: 99/07/07 by patricia
# Modify.........: NO.FUN-510029 05/01/13 By Carol 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: NO.FUN-530120 05/03/16 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-550124 05/05/30 By echo  新增報表備註
# Modify.........: No.TQC-5A0036 05/10/13 By Rosayu 料件編號放大到40
# Modify.........: NO.FUN-590118 06/01/10 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610080 06/03/02 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: NO.FUN-670106 06/08/24 By flowld voucher 型報表轉 template1
# Modify.........: No.FUN-680121 06/09/04 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0090 06/11/01 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-6A0090 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-710082 07/01/30 By day 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.TQC-740008 07/04/09 By pengu 增加(ctrl-g)功能
# Modify.........: No.MOD-820086 08/02/26 By Pengu 單身品名部份應印出下階品名，目前系統皆印出上階品名
# Modify.........: No.FUN-7A0077 08/05/13 By jamie 1.QBE「備註製造」請改為「部門\廠商」，QBE增加開窗功能。
#                                                  2.rpt->「來源」改資料title為「來源特性」. 作業編號 移至 料號後面.
# Modify.........: No.FUN-940008 09/05/12 By hongmei發料改善
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20037 10/03/15 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No:TQC-A60097 10/05/27 By Carrier MOD-9B0192追单
# Modify.........: No.FUN-A60027 10/06/09 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.TQC-A60097 10/06/22 By liuxqa TQC-A60097拆单过来，不做修改，过单用
# Modify.........: No.FUN-B50018 11/06/01 By xumm CR轉GRW
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-B50018 11/08/11 By xumm 程式規範修改
# Modify.........: No.FUN-BB0047 12/01/06 By fengrui  調整時間函數問題
# Modify.........: No.FUN-C10036 12/01/16 By xuxz 程序規範修改
# Modify.........: No.FUN-C40019 12/04/11 By yangtt GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50003 12/05/07 By yangtt GR程式優化
# Modify.........: No.TQC-D70059 13/07/23 By yangtt 1."工單單號"、"生產料件"欄位增加開窗功能
#                                                   2."部門/廠商"開窗改成q_gem_pmc1
#                                                   3.新增"幫助"按鈕
#                                                   4.報表單身添加"作業名稱"
#                                                   5.資料不換行
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
#          wc      VARCHAR(600),       # Where condition    TQC-630166
           wc      STRING,          # Where condition    TQC-630166
           more    LIKE type_file.chr1  #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
              END RECORD,
        g_argv1     LIKE sfb_file.sfb01,    # 工單編號
        g_argv2     LIKE sfb_file.sfb05     # 料件編號
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
#No.FUN-710082--begin
DEFINE  g_sql      STRING                                                       
DEFINE  l_table    STRING                                                       
DEFINE  l_table1   STRING    #FUN-B50018                                                   
DEFINE  l_table2   STRING    #FUN-B50018                                                   
DEFINE  l_str      STRING   
DEFINE  i          LIKE type_file.num5 
DEFINE  j          LIKE type_file.num5 
#No.FUN-710082--end  
###GENGRE###START
TYPE sr1_t RECORD
    sfb01 LIKE sfb_file.sfb01,
    sfb02 LIKE sfb_file.sfb02,
    sfb04 LIKE sfb_file.sfb04,
    sfb39 LIKE sfb_file.sfb39,
    sfb22 LIKE sfb_file.sfb22,
    sfb221 LIKE sfb_file.sfb221,
    sfb82 LIKE sfb_file.sfb82,
    gem02 LIKE gem_file.gem02,
    sfb05 LIKE sfb_file.sfb05,
    ima02 LIKE ima_file.ima02,
    ima021 LIKE ima_file.ima021,
    sfb071 LIKE sfb_file.sfb071,
    sfb08 LIKE sfb_file.sfb08,
    sfb09 LIKE sfb_file.sfb09,
    sfb11 LIKE sfb_file.sfb11,
    sfb40 LIKE sfb_file.sfb40,
    sfb34 LIKE sfb_file.sfb34,
    sfb28 LIKE sfb_file.sfb28,
    sfb41 LIKE sfb_file.sfb41,
    sfb06 LIKE sfb_file.sfb06,
    sfb27 LIKE sfb_file.sfb27,
    sfb07 LIKE sfb_file.sfb07,
    sfb38 LIKE sfb_file.sfb38,
    sfb42 LIKE sfb_file.sfb42,
    sfb87 LIKE sfb_file.sfb87,
    sfb13 LIKE sfb_file.sfb13,
    sfb15 LIKE sfb_file.sfb15,
    sfb25 LIKE sfb_file.sfb25,
    sfb251 LIKE sfb_file.sfb251,
    sfb88 LIKE sfb_file.sfb88,
    ima55 LIKE ima_file.ima55,
    ima08 LIKE ima_file.ima08,
    sign_type LIKE type_file.chr1,     #FUN-C40019 add
    sign_img LIKE type_file.blob,      #FUN-C40019 add
    sign_show LIKE type_file.chr1,     #FUN-C40019 add
    sign_str LIKE type_file.chr1000    #FUN-C40019 add
END RECORD

TYPE sr2_t RECORD
    sfa01 LIKE sfa_file.sfa01,
    sfa03 LIKE sfa_file.sfa03,
    sfa05 LIKE sfa_file.sfa05,
    sfa06 LIKE sfa_file.sfa06,
    sfa062 LIKE sfa_file.sfa062,
    sfa063 LIKE sfa_file.sfa063,
    sfa07 LIKE sfa_file.sfa07,
    sfa08 LIKE sfa_file.sfa08,
    sfa09 LIKE sfa_file.sfa09,
    sfa11 LIKE sfa_file.sfa11,
    sfa12 LIKE sfa_file.sfa12,
    sfa25 LIKE sfa_file.sfa25,
    sfa26 LIKE sfa_file.sfa26,
    sfa29 LIKE sfa_file.sfa29,
    sfa012 LIKE sfa_file.sfa012,
    sfa013 LIKE sfa_file.sfa013,
    ima02a LIKE ima_file.ima02,
    ima021a LIKE ima_file.ima021,
    i LIKE type_file.num5,
    j LIKE type_file.num5
END RECORD

TYPE sr3_t RECORD
    sfb01 LIKE sfb_file.sfb01,
    ecm012 LIKE ecm_file.ecm012,
    ecm03 LIKE ecm_file.ecm03,
    ecm04 LIKE ecm_file.ecm04,
    ecm45 LIKE ecm_file.ecm45,
    ecm06 LIKE ecm_file.ecm06,
    eca02 LIKE eca_file.eca02,
    ecm50 LIKE ecm_file.ecm50,
    ecm51 LIKE ecm_file.ecm51 
END RECORD


###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #LET g_argv1 = ARG_VAL(8)  #TQC-610080 
   #LET g_argv2 = ARG_VAL(9)  #TQC-610080
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   #No.FUN-710082--begin
   #FUN-B50018----mod-----end--------------------
   LET g_sql ="sfb01.sfb_file.sfb01,",
              "sfb02.sfb_file.sfb02,",
              "sfb04.sfb_file.sfb04,",
              "sfb39.sfb_file.sfb39,",
              "sfb22.sfb_file.sfb22,",
 
              "sfb221.sfb_file.sfb221,",
              "sfb82.sfb_file.sfb82,",
              "gem02.gem_file.gem02,",
              "sfb05.sfb_file.sfb05,",
              "ima02.ima_file.ima02,",
 
              "ima021.ima_file.ima021,",
              "sfb071.sfb_file.sfb071,",
              "sfb08.sfb_file.sfb08,",
              "sfb09.sfb_file.sfb09,",
              "sfb11.sfb_file.sfb11,",
 
              "sfb40.sfb_file.sfb40,",
              "sfb34.sfb_file.sfb34,",
              "sfb28.sfb_file.sfb28,",
              "sfb41.sfb_file.sfb41,",
              "sfb06.sfb_file.sfb06,",
 
              "sfb27.sfb_file.sfb27,",
              "sfb07.sfb_file.sfb07,",
              "sfb38.sfb_file.sfb38,",
              "sfb42.sfb_file.sfb42,",
              "sfb87.sfb_file.sfb87,",
 
              "sfb13.sfb_file.sfb13,",
              "sfb15.sfb_file.sfb15,",
              "sfb25.sfb_file.sfb25,",
              "sfb251.sfb_file.sfb251,",
              "sfb88.sfb_file.sfb88,",
 
              "ima55.ima_file.ima55,",
              "ima08.ima_file.ima08,",           #FUN-B50018----del,----
              "sign_type.type_file.chr1,",  #簽核方式            #FUN-C40019 add
              "sign_img.type_file.blob,",   #簽核圖檔            #FUN-C40019 add
              "sign_show.type_file.chr1,",                       #FUN-C40019 add
              "sign_str.type_file.chr1000"                       #FUN-C40019 add
   LET l_table = cl_prt_temptable('asfg103',g_sql) CLIPPED
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add #FUN-BB0047 mark 
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)   #FUN-B50018  add#FUN-C10036 mark
      EXIT PROGRAM 
   END IF

   LET g_sql ="sfa01.sfa_file.sfa01,",
              "sfa03.sfa_file.sfa03,",
              "sfa05.sfa_file.sfa05,",
              "sfa06.sfa_file.sfa06,",
              "sfa062.sfa_file.sfa062,",
              "sfa063.sfa_file.sfa063,",

              "sfa07.sfa_file.sfa07,",
              "sfa08.sfa_file.sfa08,",
              "sfa09.sfa_file.sfa09,",
              "sfa11.sfa_file.sfa11,",
              "sfa12.sfa_file.sfa12,",

              "sfa25.sfa_file.sfa25,",
              "sfa26.sfa_file.sfa26,",
              "sfa29.sfa_file.sfa29,",
              "sfa012.sfa_file.sfa012,",    #FUN-A60027
              "sfa013.sfa_file.sfa013,",    #FUN-A60027

              "ima02a.ima_file.ima02,",
              "ima021a.ima_file.ima021,",     #FUN-B50018----del,----
              "i.type_file.num5,",
              "j.type_file.num5"
   LET l_table1 = cl_prt_temptable('asfg1031',g_sql) CLIPPED
   IF l_table1 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add #FUN-BB0047
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)   #FUN-B50018  add#FUN-C10036 mark
      EXIT PROGRAM 
   END IF

  LET g_sql = "sfb01.sfb_file.sfb01,",
              "ecm012.ecm_file.ecm012,",    #FUN-A60027 
              "ecm03.ecm_file.ecm03,",
              "ecm04.ecm_file.ecm04,",
              "ecm45.ecm_file.ecm45,",
              "ecm06.ecm_file.ecm06,",

              "eca02.eca_file.eca02,",
              "ecm50.ecm_file.ecm50,",
              "ecm51.ecm_file.ecm51 " 
   LET l_table2 = cl_prt_temptable('asfg1032',g_sql) CLIPPED
   IF l_table2 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add  #FUN-BB0047 mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)   #FUN-B50018  add#FUN-C10036 mark
      EXIT PROGRAM 
   END IF
   #FUN-B50018----mod-----end--------------------

   #No.FUN-710082--end  
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL asfg103_tm(0,0)        # Input print condition
      ELSE CALL asfg103()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
END MAIN
 
FUNCTION asfg103_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_dir        LIKE type_file.chr1,         #No.FUN-680121 VARCHAR(1)#Direction Flag
          l_cmd        LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
 
   LET p_row = 5 LET p_col =20
   OPEN WINDOW asfg103_w AT p_row,p_col
        WITH FORM "asf/42f/asfg103"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON sfb01,sfb05,sfb82
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          EXIT CONSTRUCT
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT CONSTRUCT
 
       ON ACTION CONTROLG CALL cl_cmdask()    #No.TQC-740008 add
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---

      #TQC-D70059--add--str---
       ON ACTION help
          CALL cl_show_help()
      #TQC-D70059--add--end---
 
        #FUN-7A0077---add---str---
         ON ACTION controlp
            CASE
               WHEN INFIELD(sfb82)
                    CALL cl_init_qry_var()
                   #TQC-D70059---mod--str-
                   #LET g_qryparam.form     = "q_gem"
                   #LET g_qryparam.state    = "c"
                   #CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_gem_pmc1(TRUE,TRUE,g_plant) RETURNING g_qryparam.multiret
                   #TQC-D70059---mod--end-
                    DISPLAY g_qryparam.multiret TO sfb82
                    NEXT FIELD sfb82
              #-------------------No:TQC-A60097 add                             
               WHEN INFIELD(sfb01)                                              
                    CALL cl_init_qry_var()                                      
                    LET g_qryparam.form     = "q_sfb"                           
                    LET g_qryparam.state    = "c"                               
                    CALL cl_create_qry() RETURNING g_qryparam.multiret          
                    DISPLAY g_qryparam.multiret TO sfb01                        
                    NEXT FIELD sfb01                                            
                                                                                
               WHEN INFIELD(sfb05)                                              
                    CALL cl_init_qry_var()                                      
                    LET g_qryparam.form     = "q_sgl05"                         
                    LET g_qryparam.state    = "c"                               
                    CALL cl_create_qry() RETURNING g_qryparam.multiret          
                    DISPLAY g_qryparam.multiret TO sfb05                        
                    NEXT FIELD sfb05                                            
              #-------------------No:TQC-A60097 end 
            END CASE
        #FUN-7A0077---add---end---
 
     END CONSTRUCT
 
     IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
     END IF
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
 
     IF tm.wc=" 1=1 " THEN
        CALL cl_err(' ','9046',0)
        CONTINUE WHILE
     END IF
     DISPLAY BY NAME tm.more         # Condition
     INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        AFTER FIELD more
           IF tm.more = 'Y'
              THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies)
                        RETURNING g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies
           END IF
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---

      #TQC-D70059--add--str---
       ON ACTION help
          CALL cl_show_help()
      #TQC-D70059--add--end---
 
     END INPUT
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
               WHERE zz01='asfg103'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('asfg103','9031',1)  
        ELSE
           LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
           LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                           " '",g_pdate CLIPPED,"'",
                           " '",g_towhom CLIPPED,"'",
                           #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                           " '",g_bgjob CLIPPED,"'",
                           " '",g_prtway CLIPPED,"'",
                           " '",g_copies CLIPPED,"'",
                           " '",tm.wc CLIPPED,"'",
                          #TQC-610080-begin
                          # " '",tm.more CLIPPED,"'",
                          # " '",g_argv1 CLIPPED,"'",
                          # " '",g_argv2 CLIPPED,"'",
                          #TQC-610080-end
                           " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                           " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                           " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
           CALL cl_cmdat('asfg103',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW asfg103_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL asfg103()
     ERROR ""
   END WHILE
   CLOSE WINDOW asfg103_w
 
END FUNCTION
 
 
FUNCTION asfg103()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  TQC-630166          #No.FUN-680121 VARCHAR(1000)
          l_sql     STRING,                       # RDSQL STATEMENT  TQC-630166
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
#         l_order    ARRAY[5] OF LIKE apm_file.apm08,#No.FUN-680121 VARCHAR(10) # TQC-6A0079
          sr            RECORD
                        sfb        RECORD LIKE sfb_file.*,
                        ima02    LIKE ima_file.ima02,      #品名規格
                        ima021   LIKE ima_file.ima021,    #規格
                        ima55    LIKE ima_file.ima55,       #生產單位
                        ecm012   LIKE ecm_file.ecm012,      #FUN-A60027  
                        ecm03    LIKE ecm_file.ecm03,
                        ecm04    LIKE ecm_file.ecm04,
                        ecm45    LIKE ecm_file.ecm45,
                        ecm06    LIKE ecm_file.ecm06,
                        eca02    LIKE eca_file.eca02,
                        ecm50    LIKE ecm_file.ecm50,
                        ecm51    LIKE ecm_file.ecm51   #完工日期
                        END        RECORD
#No.FUN-710082--begin
DEFINE    sr1            RECORD
                        sfa01    LIKE sfa_file.sfa01,
                        sfa03    LIKE sfa_file.sfa03,    #料件編號
                        sfa05    LIKE sfa_file.sfa05,    #應發數量
                        sfa06    LIKE sfa_file.sfa06,    #已發數量
                        sfa062  LIKE sfa_file.sfa06,     #超領量
                        sfa063  LIKE sfa_file.sfa06,     #報廢量
                        sfa07    LIKE sfa_file.sfa07,    #缺料數量
                        sfa08    LIKE sfa_file.sfa08,    #作業編號
                        sfa09    LIKE sfa_file.sfa09,    #前置時間調整
                        sfa11    LIKE sfa_file.sfa11,    #旗標
                        sfa12    LIKE sfa_file.sfa12,    #發料單位
                        sfa25    LIKE sfa_file.sfa25,    #未備料量
                        sfa26    LIKE sfa_file.sfa26,    #來源
                        sfa29    LIKE sfa_file.sfa29,    #add
                        sfa012   LIKE sfa_file.sfa012,   #製程段號
                        sfa013   LIKE sfa_file.sfa013    #製程序   
                        END        RECORD
DEFINE    l_dept      LIKE gem_file.gem02
DEFINE    l_ima02     LIKE ima_file.ima02
DEFINE    l_ima021    LIKE ima_file.ima021
DEFINE    l_ima08     LIKE ima_file.ima08
#No.FUN-710082--end  
DEFINE    l_short_qty LIKE sfa_file.sfa07   #FUN-940008 add
DEFINE    l_sfa27     LIKE sfa_file.sfa27   #FUN-940008 add
DEFINE    l_flag      LIKE type_file.chr1   #FUN-B50018 add
DEFINE    l_n1        LIKE type_file.num5   #FUN-B50018 add
DEFINE    l_n2        LIKE type_file.num5   #FUN-B50018 add
DEFINE l_img_blob     LIKE type_file.blob     #FUN-C40019 add

     LOCATE l_img_blob    IN MEMORY                #FUN-C40019 add

     LET l_flag = 'N' 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
# NO.FUN-670106 --start--
#     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asfg103'
      SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'asfg103'  
#     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
# NOlFUN-670106 ---end---
#No.CHI-6A0004--------Begin--------------    
#      SELECT azi03,azi05 INTO g_azi03,g_azi05       #幣別檔小數位數讀取
#       FROM azi_file WHERE azi01=g_aza.aza17
#No.CHI-6A0004--------End--------------
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND sfbuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
     #End:FUN-980030
    
    #FUN-B50018---mod-----str--------------
    #LET l_sql = " SELECT sfb_file.*,ima02,ima021,ima55,ecm012,ecm03,ecm04,",    #FUN-A60027 add ecm012
    #            "  ecm45,ecm06,'',ecm50,ecm51 ",
    #            " FROM sfb_file,OUTER ima_file,OUTER ecm_file",
    #            " WHERE  sfb_file.sfb05 = ima_file.ima01  ",
    #            "  AND  sfb_file.sfb01 = ecm_file.ecm01  AND sfb87!='X' ",
    #            "  AND ",tm.wc CLIPPED
    #LET l_sql=l_sql CLIPPED," ORDER BY sfb01,ecm03"   #No.FUN-710082
     LET l_sql = " SELECT sfb_file.*,ima02,ima021,ima55 ",    #FUN-A60027 add ecm012
            #FUN-C50003------mod----str---
            #    " FROM sfb_file,OUTER ima_file",
            #    " WHERE  sfb_file.sfb05 = ima_file.ima01  ",
            #    "  AND sfb87!='X' ",
                 " FROM sfb_file LEFT OUTER JOIN ima_file ON sfb05 = ima01",
                 "  WHERE sfb87!='X' ",
            #FUN-C50003------mod----end---
                 "  AND ",tm.wc CLIPPED
     LET l_sql=l_sql CLIPPED," ORDER BY sfb01"   #No.FUN-710082
    #FUN-B50018---mod-----end--------------

     PREPARE asfg103_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('p1:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
         EXIT PROGRAM
    END IF
     DECLARE asfg103_curs1 CURSOR FOR asfg103_p1
 
     #No.FUN-710082--begin
     CALL cl_del_data(l_table) 
     CALL cl_del_data(l_table1)    #FUN-B50018
     CALL cl_del_data(l_table2)    #FUN-B50018
 
#  LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,             #FUN-940008 mark
  #FUN-B50018------mod------str-------------
  #LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,   #FUN-940008 add
  #            " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
  #            "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
  #            "        ?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
  #            "        ?,?, ",
  #            "        ?,?,?,?,?, ?,?,?,?,?,?,?,?) "                    #FUN-A60027 add 3?
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,   #FUN-940008 add
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ? )"         #FUN-C40019 add 4?
  #FUN-B50018------mod------end---------------- 
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
     # CALL cl_used(g_prog,g_time,2) RETURNING g_time         #FUN-B80086   MARK
      CALL cl_err("insert_prep1:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B80086   ADD
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)   #FUN-B50018  add
      EXIT PROGRAM
   END IF

   #FUN-B50018----add-----str-----------------
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,             
               " VALUES(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,?,?,?,?,? )"
   PREPARE insert_prep2 FROM g_sql                                              
   IF STATUS THEN                                  
     # CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B80086    MARK                       
      CALL cl_err("insert_prep2:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086    ADD
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)   #FUN-B50018  add
      EXIT PROGRAM                        
   END IF
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?,?, ?,?,? )"                                                                                 
     PREPARE insert_prep3 FROM g_sql                                                                                                
     IF STATUS THEN                                 
       # CALL cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B80086    MARK                                                                              
        CALL cl_err("insert_prep3:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time         #FUN-B80086    ADD
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)   #FUN-B50018  add
        EXIT PROGRAM                                                                          
     END IF
   #FUN-B50018----add-----end----------------- 
#    CALL cl_outnam('asfg103') RETURNING l_name
#    START REPORT asfg103_rep TO l_name

    #FUN-C50003-------add----str---
     LET l_sql = "SELECT ecm012,ecm03,ecm04,",   
                 "  ecm45,ecm06,'',ecm50,ecm51 ",
                 " FROM ecm_file WHERE ecm01 = ?"
     PREPARE g103_p3 FROM l_sql
     IF STATUS THEN CALL cl_err('p3:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
        EXIT PROGRAM
     END IF
     DECLARE g103_c3 CURSOR FOR g103_p3

     LET l_sql = " SELECT sfa01,sfa03,sfa05,sfa06,sfa062,sfa063,'',sfa08,", 
                 " sfa09,sfa11,sfa12,sfa25,sfa26,sfa29,sfa012,sfa013,sfa27", 
                 " FROM sfa_file",
                 " WHERE sfa01 = ?",
                 " AND sfa26 IN ('0','1','2','3','4','5','6','7','8')", 
                 " ORDER BY sfa03"
     PREPARE g103_p2 FROM l_sql
     IF STATUS THEN CALL cl_err('p2:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
        EXIT PROGRAM
     END IF
     DECLARE g103_c2 CURSOR FOR g103_p2
    #FUN-C50003-------add----end---

 
#    LET g_pageno = 0
    #FOREACH asfg103_curs1 INTO sr.*       #FUN-B50018 mark
     FOREACH asfg103_curs1 INTO sr.sfb.*,sr.ima02,sr.ima021,sr.ima55   #FUN-B50018 add
       IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
       END IF
       SELECT eca02 INTO sr.eca02 FROM eca_file
       WHERE eca01 = sr.ecm06
 
      IF sr.sfb.sfb04='2' #發放
         THEN
         UPDATE sfb_file set sfb04='3'
          WHERE sfb01=sr.sfb.sfb01
         IF sqlca.sqlerrd[3]=0
            THEN
            CALL cl_err3("upd","sfb_file",sr.sfb.sfb01,"",status,"","upd sfb04",0)     #No.FUN-660128
         END IF
      END IF
 
 
      IF NOT cl_null(sr.sfb.sfb02) THEN
         IF sr.sfb.sfb02 = 7 THEN
            SELECT pmc03 INTO l_dept FROM pmc_file
             WHERE pmc01 = sr.sfb.sfb82
            IF SQLCA.sqlcode THEN
               LET l_dept = ' '
            END IF
         ELSE
            SELECT gem02 INTO l_dept FROM gem_file
             WHERE gem01 = sr.sfb.sfb82
            IF SQLCA.sqlcode THEN
               LET l_dept = ' '
            END IF
         END IF
      END IF
         #FUN-B50018----add---str---------
         SELECT COUNT(*) INTO l_n1 FROM ecm_file WHERE ecm01 = sr.sfb.sfb01  
         SELECT COUNT(*) INTO l_n2 FROM sfa_file WHERE sfa01 = sr.sfb.sfb01 
         IF l_n1 != 0 OR l_n2 != 0 THEN  
            EXECUTE insert_prep1 USING sr.sfb.sfb01,sr.sfb.sfb02,sr.sfb.sfb04,sr.sfb.sfb39,sr.sfb.sfb22,
                                   sr.sfb.sfb221,sr.sfb.sfb82,l_dept,sr.sfb.sfb05,sr.ima02,
                                   sr.ima021,sr.sfb.sfb071,sr.sfb.sfb08,sr.sfb.sfb09,sr.sfb.sfb11,
                                   sr.sfb.sfb40,sr.sfb.sfb34,sr.sfb.sfb28,sr.sfb.sfb41,sr.sfb.sfb06,
                                   sr.sfb.sfb27,sr.sfb.sfb07,sr.sfb.sfb38,sr.sfb.sfb42,sr.sfb.sfb87,
                                   sr.sfb.sfb13,sr.sfb.sfb15,sr.sfb.sfb25,sr.sfb.sfb251,sr.sfb.sfb88,
                                   sr.ima55,l_ima08,
                                   "",l_img_blob,"N",""    #FUN-C40019 add
         END IF
        #FUN-C50003-------mark---str---
        #LET l_sql = "SELECT ecm012,ecm03,ecm04,",   
        #            "  ecm45,ecm06,'',ecm50,ecm51 ",
        #            " FROM ecm_file WHERE ecm01 = '",sr.sfb.sfb01,"'"
        #PREPARE g103_p3 FROM l_sql
        #IF STATUS THEN CALL cl_err('p3:',STATUS,1)
        #   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        #   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
        #   EXIT PROGRAM
        #END IF
        #DECLARE g103_c3 CURSOR FOR g103_p3
        #FUN-C50003-------mark---end---
        #LET l_flag = 'Y'
         FOREACH g103_c3 USING sr.sfb.sfb01 INTO sr.ecm012,sr.ecm03,sr.ecm04,sr.ecm45,sr.ecm06,sr.eca02,sr.ecm50,sr.ecm51    #FUN-C50003 add USING sr.sfb.sfb01
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            #FUN-C50003---add---str--
            SELECT eca02 INTO sr.eca02 FROM eca_file
               WHERE eca01 = sr.ecm06
            #FUN-C50003---add---end--
            EXECUTE insert_prep3 USING sr.sfb.sfb01,sr.ecm012,sr.ecm03,sr.ecm04,sr.ecm45,sr.ecm06,sr.eca02,sr.ecm50,sr.ecm51                        
         END FOREACH    
        #IF l_flag = 'N' THEN 
        #   EXECUTE insert_prep3 USING sr.sfb.sfb01,'','','','','','','',''
        #END IF
         #FUN-B50018----add---end--------- 
 
        #FUN-C50003-------mark---str---
        #LET l_sql = " SELECT sfa01,sfa03,sfa05,sfa06,sfa062,sfa063,'',sfa08,",  #FUN-940008 sfa07-->''
        #            " sfa09,sfa11,sfa12,sfa25,sfa26,sfa29,sfa012,sfa013,sfa27",         #FUN-9400008 sfa27 add  #FUN-A60027 add sfa012,sfa013
        #            " FROM sfa_file",
        #            " WHERE sfa01 = '",sr.sfb.sfb01,"'",
        #            " AND sfa26 IN ('0','1','2','3','4','5','6','7','8')",  #bugno:7111 add '56'   #FUN-A20037 add '7,8'
        #            " ORDER BY sfa03"
        #PREPARE g103_p2 FROM l_sql
        #IF STATUS THEN CALL cl_err('p2:',STATUS,1) 
        #   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        #   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
        #   EXIT PROGRAM 
        #END IF
        #DECLARE g103_c2 CURSOR FOR g103_p2
        #FUN-C50003-------mark---end---
#        LET l_cnt = 0
         LET j=1
         FOREACH g103_c2 USING sr.sfb.sfb01 INTO sr1.*,l_sfa27    #FUN-940008 add l_sfa27   #FUN-C50003 add USING sr.sfb.sfb01
            IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
            #FUN-940008---Begin add #欠料量計算
            CALL s_shortqty(sr.sfb.sfb01,sr1.sfa03,sr1.sfa08,
                            sr1.sfa12,l_sfa27,sr1.sfa012,sr1.sfa013)    #FUN-A60027 add sfa012,sfa013
                 RETURNING l_short_qty
            IF cl_null(l_short_qty) THEN LET l_short_qty = 0 END IF
            LET sr1.sfa07 = l_short_qty
            #FUN-940008---End
            #-------------No.MOD-820086 modify
            #SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file WHERE ima01=sr1.sfa29
             SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file WHERE ima01=sr1.sfa03
            #-------------No.MOD-820086 end
#           EXECUTE insert_prep1 USING sr1.*,l_ima02,l_ima021,j
 
         LET j=j+1
        #FUN-B50018----mod----str----------
        #EXECUTE insert_prep USING sr.sfb.sfb01,sr.sfb.sfb02,sr.sfb.sfb04,sr.sfb.sfb39,sr.sfb.sfb22,
        #                          sr.sfb.sfb221,sr.sfb.sfb82,l_dept,sr.sfb.sfb05,sr.ima02,
        #                          sr.ima021,sr.sfb.sfb071,sr.sfb.sfb08,sr.sfb.sfb09,sr.sfb.sfb11,
        #                          sr.sfb.sfb40,sr.sfb.sfb34,sr.sfb.sfb28,sr.sfb.sfb41,sr.sfb.sfb06,
        #                          sr.sfb.sfb27,sr.sfb.sfb07,sr.sfb.sfb38,sr.sfb.sfb42,sr.sfb.sfb87,
        #                          sr.sfb.sfb13,sr.sfb.sfb15,sr.sfb.sfb25,sr.sfb.sfb251,sr.sfb.sfb88,
        #                          sr.ima55,l_ima08,sr1.*,l_ima02,l_ima021,
        #                          sr.ecm012,sr.ecm03,sr.ecm04,                                         #FUN-A60027 add ecm012     
        #                          sr.ecm45,sr.ecm06,sr.eca02,sr.ecm50,sr.ecm51,i,j
         EXECUTE insert_prep2 USING sr1.*,l_ima02,l_ima021,i,j               
        #FUN-B50018----mod----str----------
 
         END FOREACH
#      OUTPUT TO REPORT asfg103_rep(sr.*)
     END FOREACH
 
#    FINISH REPORT asfg103_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED,  #TQC-730088
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED, 
###GENGRE###                " ORDER BY sfb01,sfa03 "    
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN                                                         
        CALL cl_wcchp(tm.wc,'sfb01,sfb05,sfb82')  
        RETURNING tm.wc                                                           
     END IF                      
###GENGRE###     LET l_str = tm.wc CLIPPED,";",g_zz05 CLIPPED
 
   # CALL cl_prt_cs3('asfg103',l_sql,l_str)   #TQC-730088
   # CALL cl_prt_cs3('asfg103','asfg103',l_sql,l_str)   #FUN-A60027
   #FUN-A60027 ------------start------------------
  #IF g_sma.sma541 = 'Y' THEN #FUN-C10036 mark
###GENGRE###      CALL cl_prt_cs3('asfg103','asfg103_1',l_sql,l_str)   #FUN-C10036 mark 
  # CALL asfg103_grdata()    ###GENGRE####FUN-C10036 mark
  #ELSE#FUN-C10036 mark
###GENGRE###      CALL cl_prt_cs3('asfg103','asfg103',l_sql,l_str)
    LET g_cr_table = l_table                   #主報表的temp table名稱          #FUN-C40019 add
    LET g_cr_apr_key_f = "sfb01"               #報表主鍵欄位名稱，用"|"隔開     #FUN-C40019 add
    CALL asfg103_grdata()    ###GENGRE###
  #END IF #FUN-C10036 mark
   #fun-a60027 -------------end------------------       
     #No.FUN-710082--end  
END FUNCTION
 
#No.FUN-710082--begin
#REPORT asfg103_rep(sr)
#  DEFINE l_last_sw     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#         sr            RECORD
#                       sfb        RECORD LIKE sfb_file.*,
#                       ima02    LIKE ima_file.ima02,      #品名規格
#                       ima021    LIKE ima_file.ima021,    #規格
#                       ima55    LIKE ima_file.ima55,        #生產單位
#                       ecm03    LIKE ecm_file.ecm03,
#                       ecm04    LIKE ecm_file.ecm04,
#                       ecm45    LIKE ecm_file.ecm45,
#                       ecm06    LIKE ecm_file.ecm06,
#                       eca02    LIKE eca_file.eca02,
#                       ecm50    LIKE ecm_file.ecm50,
#                       ecm51    LIKE ecm_file.ecm51   #完工日期
#                       END        RECORD,
#         sr1            RECORD
#                       sfa03    LIKE sfa_file.sfa03,    #料件編號
#                       sfa05    LIKE sfa_file.sfa05,    #應發數量
#                       sfa06    LIKE sfa_file.sfa06,    #已發數量
#                       sfa062  LIKE sfa_file.sfa06,     #超領量
#                       sfa063  LIKE sfa_file.sfa06,     #報廢量
#                       sfa07    LIKE sfa_file.sfa07,    #缺料數量
#                       sfa08    LIKE sfa_file.sfa08,    #作業編號
#                       sfa09    LIKE sfa_file.sfa09,    #前置時間調整
#                       sfa11    LIKE sfa_file.sfa11,    #旗標
#                       sfa12    LIKE sfa_file.sfa12,    #發料單位
#                       sfa25    LIKE sfa_file.sfa25,    #未備料量
#                       sfa26    LIKE sfa_file.sfa26     #來源
#                       END        RECORD,
#     l_sql     LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(1000)
#     l_dept    LIKE gem_file.gem02,
#     l_page    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
#     l_page1   LIKE type_file.num5,          #No.FUN-680121 SMALLINT
#     l_lineno  LIKE type_file.num5,          #No.FUN-680121 SMALLINT
#     l_eca04    LIKE eca_file.eca04,
#     l_sum1,l_sum2,l_sum3    LIKE csb_file.csb05,#No.FUN-680121 DECIMAL(13,5)
#     l_cnt        LIKE type_file.num5,           #No.FUN-680121 SMALLINT
#     ss           LIKE type_file.num5,           #No.FUN-680121 SMALLINT#status code
#     l_chr        LIKE type_file.chr1            #No.FUN-680121 VARCHAR(1)
# OUTPUT TOP MARGIN 0
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN 5
#        PAGE LENGTH g_page_line
# ORDER BY sr.sfb.sfb01,sr.ecm03
# FORMAT
#  PAGE HEADER
## NO.FUN-670106 --start--
##      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##      IF cl_null(g_towhom)
##         THEN PRINT '';
##         ELSE PRINT 'TO:',g_towhom;
##      END IF
##      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
##      PRINT ' '
##      LET g_pageno = g_pageno + 1
##      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
##            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
##      PRINT g_dash[1,g_len]
         
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     PRINT ' '
#     PRINT g_dash
## NO.FUN-670106 ---end---
#     LET l_last_sw = 'n'
#     LET l_page1 = PAGENO
 
#  #BEFORE GROUP OF sr.sfb.sfb01
#   AFTER  GROUP OF sr.ecm03
#     SKIP TO TOP OF PAGE
### No:2455 modify 1998/09/29 -----------
#     IF sr.sfb.sfb04='2' #發放
#        THEN
#        UPDATE sfb_file set sfb04='3'
#         WHERE sfb01=sr.sfb.sfb01
#        IF sqlca.sqlerrd[3]=0
#           THEN
##           CALL cl_err('upd sfb04',status,0)          #No.FUN-660128
#           CALL cl_err3("upd","sfb_file",sr.sfb.sfb01,"",status,"","upd sfb04",0)     #No.FUN-660128
#        END IF
#     END IF
##
#     IF (PAGENO>1 OR LINENO>9) THEN SKIP TO TOP OF PAGE END IF
#     LET l_page = l_page1
#     PRINT g_x[11] CLIPPED,sr.sfb.sfb01,"   (",
#           s_wotype(sr.sfb.sfb02) CLIPPED,"/",s_wostatu(sr.sfb.sfb04) CLIPPED,
#           ")"
#     IF NOT cl_null(sr.sfb.sfb02) THEN
#        IF sr.sfb.sfb02 = 7 THEN
#           SELECT pmc03 INTO l_dept FROM pmc_file
#            WHERE pmc01 = sr.sfb.sfb82
#           IF SQLCA.sqlcode THEN
#              LET l_dept = ' '
#           END IF
#        ELSE
#           SELECT gem02 INTO l_dept FROM gem_file
#            WHERE gem01 = sr.sfb.sfb82
#           IF SQLCA.sqlcode THEN
#              LET l_dept = ' '
#           END IF
##        END IF
#     END IF
#     PRINT g_x[12] CLIPPED,sr.sfb.sfb05
#     PRINT COLUMN 10,sr.ima02 CLIPPED
#     PRINT COLUMN 10,sr.ima021 CLIPPED
#     PRINT g_x[15] CLIPPED,sr.sfb.sfb07;
#     IF sr.sfb.sfb37 IS NOT NULL THEN
#         PRINT COLUMN 53,sr.sfb.sfb37
#     ELSE
#         PRINT
#     END IF
#     PRINT g_x[17] CLIPPED,sr.sfb.sfb071,'    ','(BOM/ROUTING)';
#     IF sr.sfb.sfb38 IS NOT NULL THEN
#         PRINT COLUMN 53,sr.sfb.sfb38
#     ELSE
#         PRINT
#     END IF
#     #PRINT g_x[18] CLIPPED,sr.sfb.sfb06,COLUMN 43,g_x[19] CLIPPED, #TQC-5A0036 mark
#     PRINT g_x[18] CLIPPED,sr.sfb.sfb06,COLUMN 73,g_x[19] CLIPPED,  #TQC-5A0036 add
#           sr.sfb.sfb41
#     #PRINT g_x[20] CLIPPED,sr.sfb.sfb40,COLUMN 39,g_x[21] CLIPPED; #TQC-5A0036 mark
#     PRINT g_x[20] CLIPPED,sr.sfb.sfb40,COLUMN 69,g_x[21] CLIPPED;  #TQC-5A0036 add
#     IF sr.sfb.sfb42 IS NULL OR sr.sfb.sfb42 = '0' THEN
#        PRINT '0'
#     ELSE
#        PRINT sr.sfb.sfb42
#     END IF
#     #PRINT g_x[22] CLIPPED,sr.sfb.sfb34,COLUMN 43,g_x[23] CLIPPED, #TQC-5A0036 mark
#     PRINT g_x[22] CLIPPED,sr.sfb.sfb34,COLUMN 73,g_x[23] CLIPPED,  #TQC-5A0036 add
#           sr.sfb.sfb22,'/',sr.sfb.sfb221 USING '<<<'
#     #PRINT g_x[24] CLIPPED,sr.ima55,COLUMN 43,g_x[25] CLIPPED, #TQC-5A0036 mark
#     PRINT g_x[24] CLIPPED,sr.ima55,COLUMN 73,g_x[25] CLIPPED,  #TQC-5A0036 add
#           sr.sfb.sfb27
#     PRINT g_x[26] CLIPPED,sr.sfb.sfb08
#        #  COLUMN 37,g_x[27] CLIPPED,sr.sfb.sfb03
#     IF sr.sfb.sfb88 =' ' or sr.sfb.sfb88 IS NULL THEN
#         PRINT
#     ELSE
#           #PRINT COLUMN 43,g_x[85] CLIPPED,sr.sfb.sfb88,COLUMN 66, #TQC-5A0036 mark
#           PRINT COLUMN 63,g_x[85] CLIPPED,sr.sfb.sfb88,COLUMN 86,  #TQC-5A0036 add
#                     g_x[86] CLIPPED, sr.sfb.sfb87
#     END IF
#     #PRINT COLUMN 39,g_x[32] CLIPPED,sr.sfb.sfb13 #TQC-5A0036 mark
#     PRINT COLUMN 69,g_x[32] CLIPPED,sr.sfb.sfb13  #TQC-5A0036 add
#     #PRINT g_x[35] CLIPPED,sr.sfb.sfb11,
#     #PRINT COLUMN 39,g_x[34] CLIPPED,sr.sfb.sfb15 #TQC-5A0036 mark
#     PRINT COLUMN 69,g_x[34] CLIPPED,sr.sfb.sfb15  #TQC-5A0036 add
#     #PRINT COLUMN 39,g_x[36] CLIPPED,sr.sfb.sfb251,' '; #TQC-5A0036 mark
#     PRINT COLUMN 69,g_x[36] CLIPPED,sr.sfb.sfb251,' ';  #TQC-5A0036 add
#      IF sr.sfb.sfb04 = '1' THEN
#       PRINT g_x[82] CLIPPED
#     ELSE
#        PRINT
#     END IF
#     PRINT g_x[84] CLIPPED,sr.sfb.sfb82 CLIPPED,' / ',l_dept
#
#     PRINT ' '
## NO.FUN-670106 --start--
##         #PRINT "---------------------------------";#TQC-5A0036 mark
##         PRINT "------------------------------------------"; #TQC-5A0036 add
##         #PRINT g_x[44] CLIPPED,"------------------------------" #TQC-5A0036 mark
##         PRINT g_x[44] CLIPPED,"---------------------------------------" #TQC-5A0036 add
#          PRINT g_dash2[1,(g_len-FGL_WIDTH(g_x[44]))/2]; 
#          PRINT COLUMN ((g_len-FGL_WIDTH(g_x[44] CLIPPED))/2)+1,g_x[44] CLIPPED; 
#           PRINT g_dash2[(g_len+FGL_WIDTH(g_x[44]))/2+1,g_len]           
## NO.FUN-670106 ---end---
#        LET l_sql = " SELECT sfa03,sfa05,sfa06,sfa062,sfa063,sfa07,sfa08,",
#                    " sfa09,sfa11,sfa12,sfa25,sfa26",
#                    " FROM sfa_file",
#                    " WHERE sfa01 = '",sr.sfb.sfb01,"'",
#                    " AND sfa26 IN ('0','1','2','3','4','5','6')",  #bugno:7111 add '56'
#                    " ORDER BY sfa03"
#        PREPARE g103_p2 FROM l_sql
#        IF STATUS THEN CALL cl_err('p2:',STATUS,1) 
#           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
#           EXIT PROGRAM 
#        END IF
#        DECLARE g103_c2 CURSOR FOR g103_p2
#        LET l_cnt = 0
#        FOREACH g103_c2 INTO sr1.*
#           IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#        IF l_cnt = 0 THEN              # PRINT HEADING
## NO.FUN-670106 --start-- 
##            PRINT COLUMN 26,g_x[45],g_x[46] CLIPPED
##             PRINT COLUMN 2,g_x[47] CLIPPED,g_x[48] CLIPPED
##                #PRINT "    -------------------- -- ---- ------------ ",#TQC-5A0036 mark
##                PRINT "   ---------------------------------------- -- ---- ------------ ", #TQC-5A0036 add
##                   "------------ ------------ --------"
#            PRINTX name=H1 g_x[87],g_x[88],g_x[89],g_x[90],g_x[91],
#                           g_x[92],g_x[93]
#            PRINTX name=H2 g_x[94],g_x[95],g_x[96],g_x[97],g_x[98],
#                           g_x[99],g_x[100]        
#            PRINT g_dash1
## NO.FUN-670106 ---end---
#        END IF
#               LET l_lineno = LINENO
#               IF l_lineno > 56 THEN
#                  SKIP TO TOP OF PAGE
#               END IF
#               IF l_page < l_page1 THEN
#                   PRINT g_x[11] CLIPPED,sr.sfb.sfb01,'  ',
#                         g_x[12] CLIPPED,sr.sfb.sfb05,'  ',
#                         g_x[26] CLIPPED,sr.sfb.sfb08
#                   PRINT
## NO.FUN-670106 --start--
##                    PRINT COLUMN 26,g_x[45],g_x[46] CLIPPED
##                    PRINT COLUMN 2,g_x[47] CLIPPED,g_x[48] CLIPPED
##                    #PRINT "    -------------------- -- ---- ------------ ", #TQC-5A0036 mark
##                    PRINT "    ---------------------------------------- -- ---- ------------ ",  #TQC-5A0036 add
##                      "------------ ------------ --------"
#                   PRINTX name=H1 g_x[87],g_x[88],g_x[89],g_x[90],g_x[91],
#                                  g_x[92],g_x[93]
#                   PRINTX name=H2 g_x[94],g_x[95],g_x[96],g_x[97],g_x[98],
#                                  g_x[99],g_x[100]
#                   PRINT g_dash1
## NO.FUN-670106 ---end---
 
#                   LET l_page = l_page1
#               END IF
#           LET l_cnt = l_cnt + 1
## NO.FUN-670106 --start--
##            PRINT COLUMN 5,sr1.sfa03 CLIPPED,
##                  #TQC-5A0036 mark
##                  #COLUMN 26,sr1.sfa11,'  ',sr1.sfa12 CLIPPED,
##                  #COLUMN 34,sr1.sfa05 USING'-------&.&&&',
##                  #COLUMN 47,sr1.sfa06 USING'-------&.&&&',
##                  #COLUMN 60,sr1.sfa07 USING'-------&.&&&',
##                  #COLUMN 73,sr1.sfa08
##            #PRINT COLUMN 34,sr1.sfa062 USING '-------&.&&&',
##                  #COLUMN 47,sr1.sfa063 USING '-------&.&&&',' '
##                  #TQC-5A0036 end mark
##                  #TQC-5A0036 add
##                  COLUMN 45,sr1.sfa11,'  ',sr1.sfa12 CLIPPED,
##                  COLUMN 53,sr1.sfa05 USING'-------&.&&&',
##                  COLUMN 66,sr1.sfa06 USING'-------&.&&&',
##                  COLUMN 79,sr1.sfa07 USING'-------&.&&&',
##                  COLUMN 92,sr1.sfa08
##            PRINT COLUMN 53,sr1.sfa062 USING '-------&.&&&',
##                  COLUMN 66,sr1.sfa063 USING '-------&.&&&',' '
##                  #TQC-5A0036 end
 
#            PRINTX name=D1 COLUMN g_c[87],sr1.sfa03 CLIPPED,
#                           COLUMN g_c[88],sr1.sfa11 CLIPPED,
#                           COLUMN g_c[89],sr1.sfa12 CLIPPED,
#                           COLUMN g_c[90],sr1.sfa05 USING '-----------&.&&&',
#                           COLUMN g_c[91],sr1.sfa06 USING '-----------&.&&&',
#                           COLUMN g_c[92],sr1.sfa07 USING '-----------&.&&&',
#                           COLUMN g_c[93],sr1.sfa08 
#            PRINTX name=D2 COLUMN g_c[97],sr1.sfa062 USING '-----------&.&&&',
#                           COLUMN g_c[98],sr1.sfa063 USING '-----------&.&&&'
#            END FOREACH
#          IF l_cnt = 0 THEN  #若無備料資料
#           PRINT
##            PRINT COLUMN 32,g_x[56] CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[56] CLIPPED))/2)+1,g_x[56] CLIPPED   
#       END IF
## NO.FUN-670106 ---end--- 
#        PRINT
#        ########製程表頭/////////////////////////
## NO.FUN-670106 --start--
##          PRINT "---------------------------------";
##         #PRINT "---------------------------------------------";  #TQC-5A0036 add
##         PRINT g_x[52] CLIPPED,"------------------------------" #TQC-5A0036 mark
##         #PRINT g_x[52] CLIPPED,"------------------------------------------"  #TQC-5A0036 add
      
#         PRINT g_dash2[1,(g_len-FGL_WIDTH(g_x[52]))/2];
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[52] CLIPPED))/2)+1,g_x[44] CLIPPED;
#         PRINT g_dash2[(g_len+FGL_WIDTH(g_x[52]))/2+1,g_len]
## NO.FUN-670106 ---end---   
 
#        IF sr.ecm03 IS NULL AND sr.ecm04 IS NULL AND sr.ecm45 IS NULL
#           AND sr.ecm06 IS NULL AND sr.ecm50 IS NULL AND sr.ecm51 IS NULL THEN
## NO.FUN-670106 --start--
##            PRINT COLUMN 34,g_x[80] CLIPPED
#          PRINT COLUMN ((g_len-FGL_WIDTH(g_x[80] CLIPPED))/2)+1,g_x[80] CLIPPED
## NO.FUN-670106 ---end---  
#        ELSE
#           PRINT g_x[53]
#           PRINT g_x[54],g_x[55]
#           PRINT g_x[62],g_x[63]
#           PRINT COLUMN 5,sr.ecm03 USING '###&',' ',sr.ecm04 CLIPPED, #FUN-590118
#                 COLUMN 17,sr.ecm45 CLIPPED,
#                 COLUMN 28,sr.ecm06 CLIPPED,
#                 COLUMN 42,sr.eca02 CLIPPED,
#                 COLUMN 61,sr.ecm50 ,
#                 COLUMN 72,sr.ecm51
         
#     PRINT ' '
#     END IF
         
 
#ON LAST ROW
## NO.FUN-670106 --start--
#  IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'sfb01,sfb02,sfb03,sfb04,sfb05')
#              RETURNING tm.wc
#   PRINT g_dash
#    PRINT tm.wc
# END IF
## NO.FUN-670106 ---end---
##TQC-630166-start
##         CALL cl_prt_pos_wc(tm.wc) 
##             IF tm.wc[001,070] > ' ' THEN            # for 80
##        PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
##             IF tm.wc[071,140] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
##             IF tm.wc[141,210] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
##             IF tm.wc[211,280] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
##TQC-630166-end
      
#    LET l_last_sw = 'y' 
#    PRINT g_dash
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n' THEN 
#         PRINT g_dash
#  	  PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
## FUN-550124
#     PRINT
#     IF l_last_sw = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[9]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#            PRINT g_x[9]
#            PRINT g_memo
#     END IF
## END FUN-550124
 
#END REPORT
##Patch....NO.TQC-610037 <001,002> #
#No.FUN-710082--end  
#TQC-A60097

###GENGRE###START
FUNCTION asfg103_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    LOCATE sr1.sign_img IN MEMORY   #FUN-C40019
    CALL cl_gre_init_apr()          #FUN-C40019
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("asfg103")
        IF handler IS NOT NULL THEN
            START REPORT asfg103_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY sfb01"
          
            DECLARE asfg103_datacur1 CURSOR FROM l_sql
            FOREACH asfg103_datacur1 INTO sr1.*
                OUTPUT TO REPORT asfg103_rep(sr1.*)
            END FOREACH
            FINISH REPORT asfg103_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT asfg103_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B50018----add-----str-----------------
    DEFINE sr2  sr2_t
    DEFINE sr3  sr3_t
    DEFINE sr1_t                 sr1_t
    DEFINE sr2_t                 sr2_t
    DEFINE sr3_t                 sr3_t
    DEFINE l_sfb02_desc          STRING
    DEFINE l_sfb02desc_sfb04desc STRING
    DEFINE l_sfb04_desc          STRING
    DEFINE l_sfb22_sfb221        STRING
    DEFINE l_sfb221              STRING
    DEFINE l_sfb251              STRING
    DEFINE l_sfb42               STRING
    DEFINE l_sfb42_0             STRING
    DEFINE l_sfb82_gem02         STRING
    DEFINE l_sql                 STRING
    DEFINE l_display             STRING
    DEFINE l_n                   LIKE type_file.num5 

    #FUN-B50018----add-----end-----------------


    
    ORDER EXTERNAL BY sr1.sfb01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.sfb01
            LET l_lineno = 0

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-B50018----add-----str-----------------
            IF sr1.sfb02 = '1' OR sr1.sfb02 = '2' OR sr1.sfb02 = '5' OR sr1.sfb02 = '7' OR sr1.sfb02 = '11' OR sr1.sfb02 = '12' OR sr1.sfb02 = '13'  THEN
               LET  l_sfb02_desc = cl_gr_getmsg("gre-071",g_lang,sr1.sfb02)
            ELSE
               LET  l_sfb02_desc = cl_gr_getmsg("gre-071",g_lang,'0') 
            END IF
            PRINTX  l_sfb02_desc

            IF NOT cl_null(sr1.sfb04)  THEN
               LET l_sfb04_desc = cl_gr_getmsg("gre-072",g_lang,sr1.sfb04) 
            END IF
            PRINTX l_sfb04_desc

            LET l_sfb02desc_sfb04desc = '(',l_sfb02_desc,'/',l_sfb04_desc,')'
            PRINTX l_sfb02desc_sfb04desc

            LET l_sfb221 = sr1.sfb221  USING '###,##&'
            IF NOT cl_null(sr1.sfb22) THEN
               LET l_sfb22_sfb221 = sr1.sfb22,'/',l_sfb221
            ELSE
               LET l_sfb22_sfb221 = ' '
            END IF
            PRINTX l_sfb22_sfb221


            IF sr1.sfb04 = '1'  THEN
               LET l_sfb251 = cl_gr_getmsg("gre-073",g_lang,'1') 
            ELSE 
               LET l_sfb251 = ' '
            END IF
            PRINTX l_sfb251


            LET l_sfb42_0 = sr1.sfb42  USING '###,##&'
            IF cl_null(l_sfb42_0) THEN
               LET l_sfb42 = ' '
            ELSE
               LET l_sfb42 = l_sfb42_0
            END IF
            PRINTX l_sfb42

            LET l_sfb82_gem02 = sr1.sfb82,'/',sr1.gem02
            PRINTX l_sfb82_gem02


            IF NOT cl_null(sr1_t.sfb01) THEN
               IF sr1_t.sfb01 = sr1.sfb01 THEN
                  LET l_display = 'N '
               ELSE
                  LET l_display = 'Y '
               END IF 
            END IF
            PRINTX l_display

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE sfa01 = '",sr1.sfb01 CLIPPED,"'"
            START REPORT asfg103_subrep01
            DECLARE asfg103_repcur1 CURSOR FROM l_sql
            FOREACH asfg103_repcur1 INTO sr2.*
                OUTPUT TO REPORT asfg103_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT asfg103_subrep01
          
            LET l_sql = " SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                        " WHERE sfb01 = '",sr1.sfb01 CLIPPED,"'"
            DECLARE asfg103_repcur2_1 CURSOR FROM l_sql
            FOREACH asfg103_repcur2_1 INTO l_n  
            END FOREACH
            PRINTX l_n           
 
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                        " WHERE sfb01 = '",sr1.sfb01 CLIPPED,"'"
            START REPORT asfg103_subrep02
            DECLARE asfg103_repcur2 CURSOR FROM l_sql
            FOREACH asfg103_repcur2 INTO sr3.*
                OUTPUT TO REPORT asfg103_subrep02(sr3.*)
            END FOREACH
            FINISH REPORT asfg103_subrep02 
            #FUN-B50018----add-----end-----------------


            PRINTX sr1.*

            LET sr1_t.* = sr1.*    #FUN-B50018

        AFTER GROUP OF sr1.sfb01

        
        ON LAST ROW

END REPORT


#FUN-B50018----add-----str-----------------
REPORT asfg103_subrep01(sr2)
       DEFINE sr2  sr2_t
       DEFINE l_display STRING
       DEFINE l_ecd02   LIKE ecd_file.ecd02    #TQC-D70059

       ORDER EXTERNAL BY sr2.sfa01,sr2.sfa03
     
       FORMAT
        BEFORE GROUP OF sr2.sfa01
            IF cl_null(sr2.sfa03) THEN
               LET l_display = "Y"
            ELSE
               LET l_display = "N"
            END IF
            PRINTX l_display

        ON EVERY ROW
            LET l_ecd02 = NULL  #TQC-D70059
            SELECT ecd02 INTO l_ecd02 FROM ecd_file WHERE ecd01 = sr2.sfa08   #TQC-D70059
            PRINTX l_ecd02    #TQC-D70059
            PRINTX sr2.*
            PRINTX g_sma.sma541
       
END REPORT


REPORT asfg103_subrep02(sr3)
       DEFINE sr3  sr3_t
       DEFINE l_display STRING
       
       ORDER EXTERNAL BY sr3.sfb01,sr3.ecm03

       FORMAT
         BEFORE GROUP OF sr3.sfb01  
            PRINTX g_sma.sma541
          
        ON EVERY ROW
            IF cl_null(sr3.ecm03) THEN
               LET l_display = "Y"
            ELSE 
               LET l_display = "N"
            END IF
            PRINTX l_display 
            PRINTX g_sma.sma541
            PRINTX sr3.*

END REPORT
#FUN-B50018----add-----end-----------------
###GENGRE###END
