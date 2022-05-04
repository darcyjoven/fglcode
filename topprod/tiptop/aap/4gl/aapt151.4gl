# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aapt151.4gl
# Descriptions...: 借支單維護作業 
# Date & Author..: 06/10/10 BY ice
#
 
# Modify.........: No.FUN-6A0055 06/10/25 By ice l_time轉g_time
# Modify.........: No.FUN-880095 08/08/28 By xiaofeizhu 增加參數定義
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE    g_msg         LIKE type_file.chr1000
DEFINE    g_argv1       LIKE apa_file.apa01
DEFINE    g_argv2       LIKE type_file.chr1000
DEFINE   g_argv3         STRING           #No.FUN-880095
DEFINE   g_argv4         STRING           #No.FUN-880095
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0055
 
   IF FGL_GETENV("FGLGUI") <> "0" THEN
      OPTIONS
         INPUT NO WRAP
   END IF
 
   DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   LET g_argv3 = ARG_VAL(3)               #No.FUN-880095
   LET g_argv4 = ARG_VAL(4)               #No.FUN-880095   
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
 
   CALL t110('17',g_argv1,g_argv2,g_argv3,g_argv4)   #FUN-880095 add g_argv3,g_argv4
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
END MAIN
