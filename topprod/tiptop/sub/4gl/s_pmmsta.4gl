# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: s_pmmsta.4gl
# Descriptions...: 將採購單之狀況碼轉換為狀況說明
# Date & Author..: 90/09/26 By Nora
# Usage..........: CALL s_pmmsta(p_file,p_code1,p_code2,p_code3) RETURNING l_sta
# Input Parameter: p_file    採購單
#                  p_code1   狀況碼
#                  p_code2   確認碼
#                  p_code3   簽核否
# Return code....: l_sta     狀況說明
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_pmmsta(p_file,p_code1,p_code2,p_code3)
   DEFINE  p_file   LIKE oay_file.oayslip,         #No.FUN-680147 VARCHAR(03)
           p_code1  LIKE type_file.chr1,           #No.FUN-680147 VARCHAR(01)
           p_code2  LIKE type_file.chr1,           #No.FUN-680147 VARCHAR(01)
           p_code3  LIKE type_file.chr1,           #No.FUN-680147 VARCHAR(01)
           l_sta    LIKE type_file.chr12           #LIKE cqo_file.cqo12            #No.FUN-680147 VARCHAR(12)   #TQC-B90211
   LET l_sta = " "
   IF cl_null(p_code1) THEN RETURN  l_sta END IF
   IF p_file != 'pmm' THEN
      RETURN l_sta
   END IF
#..當狀況碼為開立且確認碼='Y'and 簽核碼='Y' --> p_code1='S' -- 送簽中
   IF p_code1='0' AND p_code2='Y' AND p_code3='Y' AND g_aza.aza23='N'
      THEN  
      LET p_code1='S'  
   END IF 
   CASE p_code1
		WHEN '0' CALL cl_getmsg('mfg3211',g_lang) RETURNING l_sta
		WHEN '1' CALL cl_getmsg('mfg3212',g_lang) RETURNING l_sta
		WHEN '2' CALL cl_getmsg('mfg3213',g_lang) RETURNING l_sta
		WHEN '6' CALL cl_getmsg('mfg3214',g_lang) RETURNING l_sta
		WHEN '7' CALL cl_getmsg('mfg3215',g_lang) RETURNING l_sta
		WHEN '8' CALL cl_getmsg('mfg3216',g_lang) RETURNING l_sta
		WHEN '9' CALL cl_getmsg('mfg3217',g_lang) RETURNING l_sta
		WHEN 'X' CALL cl_getmsg('mfg3218',g_lang) RETURNING l_sta
		WHEN 'S' CALL cl_getmsg('mfg3546',g_lang) RETURNING l_sta
                WHEN 'R' CALL cl_getmsg('mfg3548',g_lang) RETURNING l_sta
                WHEN 'W' CALL cl_getmsg('mfg3556',g_lang) RETURNING l_sta
   END CASE
   RETURN l_sta
END FUNCTION
