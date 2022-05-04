# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: abxr100s.4gl
# Descriptions...: 委外加工申報
# Date & Author..: 96/08/02 By STAR
# Modify.........: No.FUN-580013 05/08/04 By vivien 憑証類報表轉XML
# Modify.........: No.TQC-610081 06/04/20 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換 
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.TQC-6A0083 06/11/14 By xumin 報表寬度不符調整
# Modify.........: No.TQC-740062 07/04/12 By wujie 報表日期和頁次為英文
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,      # Where condition            #No.FUN-680062 VARCHAR(1000)
              more    LIKE type_file.chr1          # Input more condition(Y/N)  #No.FUN-680062 VARCHAR(1)
              END RECORD,
          g_mount     LIKE type_file.num10,        #No.FUN-680062  integer
          g_chars     LIKE type_file.chr8          #No.FUN-680062  VARCHAR(10)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680062 smallint
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
 
 
   INITIALIZE tm.* TO NULL            # Default condition
#--------------No.TQC-610081 modify
#  LET tm.more = 'N'
#  LET g_pdate = g_today
#  LET g_rlang = g_lang
#  LET g_bgjob = 'N'
#  LET g_copies = '1'
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
#--------------No.TQC-610081 end
   IF cl_null(tm.wc)
      THEN CALL abxr100_tm(4,17)        # Input print condition
      ELSE 
        #LET tm.wc = "bnb01 ='",tm.wc CLIPPED,"'"     #No.TQC-610081 mark
         CALL abxr100s()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr100_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680062 smallint
          l_cmd          LIKE type_file.chr1000       #No.FUN-680062 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 12 END IF
   OPEN WINDOW abxr100_w AT p_row,p_col
        WITH FORM "abx/42f/abxr100"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("abxr100")
 
   CALL cl_ui_locale("abxr100")
# END genero shell script ADD
################################################################################
   CALL cl_ui_init()    #No.TQC-740062
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = '1=1'
   LET tm.more = 'N'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON bnb01
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
 END CONSTRUCT
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.more
   WITHOUT DEFAULTS
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
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abxr100'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abxr100','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
 
         CALL cl_cmdat('abxr100s',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW abxr100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abxr100s()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr100_w
END FUNCTION
 
FUNCTION abxr100s()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-680062 VARCHAR(20) 
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 #No.FUN-680062 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680062  VARCHAR(1)
          l_za05    LIKE za_file.za05,            #No.FUN-680062  VARCHAR(40)
          l_sfs03   LIKE sfs_file.sfs03,
          l_oga16   LIKE oga_file.oga16,
          sr               RECORD
                                  bnc02  LIKE bnc_file.bnc02,
                                  bnc03  LIKE bnc_file.bnc03,
                                  bnc06  LIKE bnc_file.bnc06,
                                  bnc07  LIKE bnc_file.bnc07,
                                  bnc08  LIKE bnc_file.bnc08,
                                  bnb05  LIKE bnb_file.bnb05,
                                  bnb16  LIKE bnb_file.bnb16,
                                  sfa03  LIKE sfa_file.sfa03,
                                  sfa05  LIKE sfa_file.sfa05,
                                  sfa12  LIKE sfa_file.sfa12,
                                  sfa161 LIKE sfa_file.sfa161,
                                  ima02  LIKE ima_file.ima02,
                                  ima15  LIKE ima_file.ima15
                        END RECORD
 
 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang     #No.TQC-740062
     LET l_sql = "SELECT bnc02,bnc03,bnc06,bnc07,bnc08,bnb05,bnb16, ",
                 "       sfa03,sfa05,sfa12,sfa161,ima02,ima15  ",
                 "  FROM bnb_file,bnc_file, OUTER sfa_file,OUTER ima_file  ",
                 " WHERE bnb01 = bnc01 AND ima_file.ima01=bnc_file.bnc03 ",
                 "   AND bnb_file.bnb16=sfa_file.sfa01 ",
                 "   AND ",tm.wc CLIPPED
 
     SELECT azi03,azi04,azi05
       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
       FROM azi_file
      WHERE azi01=g_aza.aza17
 
     PREPARE abxr100_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
        EXIT PROGRAM
           
     END IF
     DECLARE abxr100_curs1 CURSOR FOR abxr100_prepare1
 
      CALL cl_outnam('abxr100s') RETURNING l_name
 
     START REPORT abxr100_rep TO l_name
     LET g_pageno = 0
     LET g_mount = 0
     FOREACH abxr100_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF cl_null(sr.bnb16) THEN LET sr.bnb16 = ' ' END IF
       IF cl_null(sr.bnc06) THEN LET sr.bnc06 = 0 END IF
       IF cl_null(sr.bnc08) THEN LET sr.bnc08 = 0 END IF
       OUTPUT TO REPORT abxr100_rep(sr.*)
     END FOREACH
 
     FINISH REPORT abxr100_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT abxr100_rep(sr)
DEFINE l_page      LIKE type_file.num5,          #No.FUN-680062 smallint
       l_n         LIKE type_file.num5,          #No.FUN-680062 smallint
          l_sfb05  LIKE sfb_file.sfb05,
          l_sfb08  LIKE sfb_file.sfb08,
          l_ima02  LIKE ima_file.ima02,
          l_ima03  LIKE ima_file.ima03,
          l_pmc081 LIKE pmc_file.pmc081,
          l_desc LIKE zaa_file.zaa08,            #No.FUN-680062 VARCHAR(10)
          l_str  LIKE type_file.chr20,           #No.FUN-680062 VARCHAR(10)
          sr               RECORD
                                  bnc02  LIKE bnc_file.bnc02,
                                  bnc03  LIKE bnc_file.bnc03,
                                  bnc06  LIKE bnc_file.bnc06,
                                  bnc07  LIKE bnc_file.bnc07,
                                  bnc08  LIKE bnc_file.bnc08,
                                  bnb05  LIKE bnb_file.bnb05,
                                  bnb16  LIKE bnb_file.bnb16,
                                  sfa03  LIKE sfa_file.sfa03,
                                  sfa05  LIKE sfa_file.sfa05,
                                  sfa12  LIKE sfa_file.sfa12,
                                  sfa161 LIKE sfa_file.sfa161,
                                  ima02  LIKE ima_file.ima02,
                                  ima15  LIKE ima_file.ima15
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
         ORDER BY sr.bnb16,sr.sfa03
 
  FORMAT
   PAGE HEADER
         SELECT sfb05,sfb08 INTO l_sfb05,l_sfb08 FROM sfb_file
                WHERE sfb01=sr.bnb16
         SELECT ima02,ima03 INTO l_ima02,l_ima03 FROM ima_file
                WHERE ima01=l_sfb05
         SELECT pmc081 INTO l_pmc081 FROM pmc_file WHERE pmc01=sr.bnb05
         LET l_n=1
         LET l_page=1
#No.TQC-740062--begin 
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
         LET g_pageno=g_pageno+1                                                                                                    
         LET pageno_total=PAGENO USING '<<<','/pageno'
         PRINT                                                                                                                      
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED                                                        
#        PRINT g_head CLIPPED,pageno_total                                                                                          
#        PRINT 'DATE:',TODAY,COLUMN 125,'PAGE:',l_page USING '###'                                                                  
#        LET l_page=l_page+1                                                                                                        
#        SKIP 1 LINE    
#No.TQC-740062--end 
         PRINT g_x[11] CLIPPED,sr.bnb16,'(',l_sfb05 CLIPPED,')',
               COLUMN 55,g_x[12] CLIPPED,l_pmc081 CLIPPED  #TQC-6A0083
         PRINT g_x[13] CLIPPED,l_ima02 CLIPPED,l_ima03 CLIPPED  #TQC-6A0083
         PRINT g_x[14] CLIPPED,l_sfb08 USING '########',' ST'
         PRINT g_head CLIPPED,pageno_total     #No.TQC-740062
         PRINT g_dash[1,g_len]
#No.FUN-580013 --start
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
               g_x[36],g_x[37],g_x[38] CLIPPED
         PRINT g_dash1
#No.FUN-580013 --end
 
   ON EVERY ROW
      IF sr.sfa05>sr.bnc06 THEN LET l_desc=g_x[17]
      ELSE LET l_desc='' END IF
#No.FUN-580013 --start
      LET l_str = sr.sfa161 USING '##&.&&','  ',sr.sfa12
      PRINT COLUMN g_c[31],l_n USING '###&',
            COLUMN g_c[32],sr.ima15 CLIPPED,
            COLUMN g_c[33],sr.sfa03[1,14] CLIPPED,
            COLUMN g_c[34],sr.ima02 CLIPPED,
            COLUMN g_c[35],l_str CLIPPED,
            COLUMN g_c[36],sr.sfa05 CLIPPED,
            COLUMN g_c[37],sr.bnc06 CLIPPED,
            COLUMN g_c[38],l_desc CLIPPED
#No.FUN-580013 --end
      LEt l_n=l_n+1
 
   ON LAST ROW
      PRINT g_dash[1,g_len]
#      PRINT g_x[04] CLIPPED,COLUMN (g_len-7),g_x[07] CLIPPED
      PRINT g_x[04] CLIPPED,COLUMN (g_len-9),g_x[07] CLIPPED
END REPORT
#Patch....NO.TQC-610035 <> #
