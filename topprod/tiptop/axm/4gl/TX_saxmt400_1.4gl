# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: saxmt400.4gl
# Descriptions...: 合約/訂單維護作業
# Date & Author..: 94/12/22 By Danny
# Modify	 : 95/06/20 by nick 在csd重計時,有已發量及待發量的項次將不予列入
# Modify(V.2.0)..: 95/11/07 By Apple 取消確認時必須check 是否已出貨
# 應帶出符合該客戶的資料,2.其它資料中銷貨待驗收入應check match Y/N,
                   # CSD 應check match Y/N
                   # (1)增加自動確認&立即確認功能,(2)客戶編號改為10碼
                   # (3)將客戶品號轉為本公司品號
                   # (4)csd展開時show輸入金額和總金額差額
                   # (5)發票別不可空白
                   # (6)信用查核超限處理
                   # 增加備置欄位
# Modify.........: 99/07/05 By Carol 新增簽核功能
# Modify.........: 00/04/11 By Carol 新增報價單轉入
#                : 01-04-10 BY ANN CHEN B326 統一oea49的碼別
#                                            0.表開立/送簽中 1.已核淮
# Modify.........: 01/04/27 By Tommy No.B457 新增 D.拋轉請購單
# Modify.........: 02/08/16 By Kitty No.3795 新增 oeb904議價單價(定價)
# Modify.........: 02/08/16 By Kitty No.3795 新增 oeb904議價單價(定價)
# Modify.........: No:7677 03/08/08 Carol delete時,應判斷有無產生訂金
#                                         應收於 axrt300 (無論其確認否)
# Modify.........: No.FUN-4B0038 04/11/16 By pengu ARRAY轉為EXCEL檔
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 BEGIN WORK
#                                         中(transaction)才會達到lock 的功能
# Modify.........: No:7578 03/08/29 Carol 訂單量100,有做備置量 60,後來修改訂單量
#                                         ->修改訂單量時顯示訊息提示,訂單量<備置
# Modify.........: No.7946 03/08/27 Kammy 多角貿易共用本支程式
#                  1.非多角訂單有 (1)一般 (2)換貨 (3)出至境外 (4)境外出貨 (5)BU
#                  2.多角訂單只有 (1)一般 (2)換貨
# Modify.........: No:8330 03/09/26 Carol 使用OUTER ima_file,要oeb04=ima_file.ima01才對
#                                         -->調整ora
# Modify.........: No:9436 04/04/09 Melody 原MOD遇大數時有問題,改寫
# Modify.........: No:9803 04/07/27 Wiky   訂單列印簡表時,程式原來的寫法就有考慮讓 user下查詢條件
#                                          但組sql 時,僅有考慮單頭條件,未考慮單身下的條件
# Modify.........: No.MOD-480274 04/08/10 Wiky 1.若客戶編號與送貨客戶不同時,送貨地址碼開窗後帶出資料後,按ENTER卻異常
# Modify.........: No:9864 04/08/18 ching  做複製時需將oea99清空
# Modify.........: No.MOD-490073 Kammy 境外倉出貨收款客戶未帶出，且轉入項次應可自動帶出資料
# Modify.........: No.MOD-490388 Wiky  1.品名規格有時會空白(檢查,INSERT/UPDATE),測試第一筆改完,又往前面修改方式
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.MOD-490485 04/10/04 By Yuna 麥頭代號開窗不會帶出
# Modify.........: No.MOD-4A0063 04/10/06 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.FUN-4A0014 04/10/08 By Carol axmt4004 add CALL q_bma101()
#                                                  construct add call q_oea6()
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-4A0252 04/10/19 By Smapmin 增加麥頭代號開窗功能,修正訂單單號開窗資料
# Modify.........: No.MOD-4B0043 04/11/04 By Mandy 做單身修正時,單頭有合約單號,輸入轉入項次後,無重新帶出產品編號...等值
# Modify.........: No.MOD-4A0299 04/11/19 By Echo 複製功能，並無判斷合約單號、訂單單號是否簽核
# Modify.........: No.MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: No.FUN-4B0050 04/11/23 By Mandy 匯率加開窗功能
# Modify.........: No.MOD-4B0275 04/11/27 By Danny CALL q_coc2
# Modify.........: No.MOD-4B0293 04/11/30 By Carol 傳值呼叫另一隻程式時,參數應該用引號括起來,避免參數中的空白影響執行結果
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-4C0041 04/12/13 By Echo  查看"簽核狀況"的button
# Modify.........: No.MOD-4B0136 04/12/13 By Mandy 在進行功能鍵「受訂庫存明細查詢」時，系統應自動帶出所有訂單單身之料號，而不是讓使用者自行輸入料號查詢。
# Modify.........: No.FUN-4C0076 04/12/15 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: NO.FUN-4C0096 05/01/11 By Carol 修改報表架構轉XML
# Modify.........: NO.MOD-510128 05/01/18 By Carol 單身由報價單轉訂單,oqu02 應 = g_oeb[l_ac].oeb71(來源項次)
#                                                  不是g_oeb[l_ac].oeb03(訂單項次)
# Modify.........: No.MOD-510171 05/03/02 By Carrier 內銷時可以KEY手冊編號
# Modify.........: NO.FUN-530031 05/03/22 By Carol 單價/金額欄位所用的變數型態應為 dec(20,6),匯率 dec(20,10)
# Modify.........: NO.MOD-530369 05/03/29 By Mandy 修改客戶編號時, 送貨客戶應該比照收款客戶的方式一併異動.
# Modify.........: NO.MOD-530535 05/03/30 By Mandy 1.資料來源為5:報價單轉入時, 稅別/價格條件/收款條件/銷售分類一
#                                                  請根據客戶編號取客戶主檔的慣用稅別/價格條件/收款條件/銷售分類為Deafault值.
#                                                  2.資料來源為5:報價單轉入時, 單身由報價單自動轉為訂單, 未稅金額未計算.
# Modify.........: No.MOD-530870 05/03/30 By Smapmin 將VAR CHAR轉為CHAR
# Modify.........: No.MOD-4A0299 05/05/06 By Echo  複製功能，並無判斷合約單號、訂單單號是否簽核
#                                                  將送簽程式段獨立
# Modify.........: No.FUN-540049 05/05/11 By Carrier 雙單位內容修改
# Modify.........: No.FUN-550052 05/05/25 By wujie   單據編號加大
# Modify.........: No.FUN-550103 05/05/26 By Lifeng  料件多屬性內容修改
# Modify.........: No.FUN-550095 05/06/06 By Mandy 特性BOM
# Modify.........: No.MOD-560007 05/06/02 By Echo   重新定義整合FUN名稱
# Modify.........: No.FUN-560074 05/06/16 By pengu  CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-530193 05/04/18 By Mandy 新增完整張單據後，再去修改稅別 (有可能其稅額有變，或者含稅改為未稅)，此時並未重新計算單身金額，以及單頭的未稅金額
# Modify.........: No.MOD-530194 05/04/18 By Mandy 條格條件的取價方式為"2:取產品價格檔訂價方式"在輸入訂單時，check產品價格檔中的國別
# Modify.........: No.MOD-550004 05/05/02 By Mandy 無法正確執行列印明細
# Modify.........: No.MOD-530157 05/05/09 By Mandy QR 查詢無法RUN
# Modify.........: No.MOD-520018 05/06/19 By Smamin 退補轉入,數量不可大於原銷退量
# Modify.........: No.FUN-560106 05/06/19 By wujie   單據編號加大
# Modify.........: No.FUN-560132 05/06/20 By wujie   單據編號加大
# Modify.........: No.FUN-570098 05/07/13 By Nicola 1.增加一個Action "其它資料",秀出單身的[其他資料]
# Modify.........: No.MOD-570405 05/08/03 By Nicola 右側的多角貿易按鍵,出現prompt 但沒有任何訊息
# Modify.........: No.MOD-570047 05/08/03 By Nicola "MPS轉入"功能Mark
# Modify.........: No.MOD-570192 05/08/04 By Nicola 取消oaz43的Mark
# Modify.........: No.MOD-570251 05/08/04 By Nicola 轉入之單據，應不可修改單位、取位放大
# Modify.........: No.MOD-570397 05/08/04 By Nicola 料件需在報價單中控管
# Modify.........: No.FUN-570020 05/07/04 By kim oea08修改時Noentry,選境外倉出貨訂單時,輸入客戶編號後帶出其他資料
# Modify.........: No.FUN-520002 05/08/05 By saki 自訂欄位功能範例
# Modify.........: NO.MOD-580085 05/08/11 By Rosayu 麥頭代號開窗挑完資料後,檢查不過,開窗改用q_ocf
# Modify.........: No.MOD-570260 05/08/11 By Rosayu
# Modify.........: No.MOD-570253 05/08/11 By Rosayu oeb08=>no use
# Modify.........: No.MOD-580021 05/08/15 By Nicola 銷售分類二新增開窗功能並顯示銷售名稱
# Modify.........: NO.MOD-570103 05/07/20 By Yiting 輸入業務員後，會自動帶出部門
# Modify.........: NO.MOD-570284 05/07/21 By Yiting NEXT FIELD時，卻跳到了另一個
# Modify.........: NO.MOD-580261 05/08/23 By Carrier set_oeb917有誤,沒有考慮不使用計價的情況
# Modify.........: NO.MOD-570250 05/07/21 By YITING 若訂單已有來源單據 ,重要欄位要秀訊息
# Modify.........: NO.MOD-580175 05/09/08 By Nicola 無使用多單位參數,單身修改後會出現aim-996 錯誤訊息
# Modify.........: No.MOD-590122 05/09/09 By Carrier set_origin_field修改
# Modify.........: NO.MOD-570396 05/09/12 By Nicola 選擇完業務員後，自動帶出部門代號
# Modify.........: NO.MOD-580145 05/09/12 By Nicola 修改產品編號後，重新取價
# Modify.........: No.FUN-580155 05/09/14 By Sarah 以EF為backend engine,由TIPTOP處理前端簽核動作
# Modify.........: No.MOD-590346 05/09/16 By Carrier mark du_default()
# Modify.........: No.MOD-580284 05/09/30 By Nicola 數量修改時，需重新取價
# Modify.........: No.MOD-570248 05/10/07 By Mandy 當取價是依價格表取價時,若異動數量,單價也要重新取
# Modify.........: No.MOD-590192 05/10/20 By Nicola 由報價轉入未帶收款客戶/起運/到達地 /交運方式
# Modify.........: No.MOD-590540 05/10/20 By Nicola 住址碼有輸入時，oap042不可輸入
# Modify.........: No.MOD-5A0001 05/10/20 By Nicola _u() 如原先地址碼(oea044)為MISC 有insert oap_file ,之後修改成不是 MISC ,應要將oap_file delete
# Modify.........: No.MOD-5A0083 05/10/21 By Nicola 無資料時，不可按其他資料
# Modify.........: No.FUN-5A0103 05/10/24 By Sarah 將oea904的controlp部分換成call q_poz1
# Modify.........: No.MOD-5A0271 05/10/24 By Rosayu 參數中'訂單單身儲存最大筆數'應放在after row 的interrupt之後判斷
# Modify.........: NO.MOD-590451 05/10/25 By Yiting  IF g_flag=1 THEN NEXT FIELD ofe04錯誤
# Modify.........: No.TQC-5B0117 05/11/17 By Echo 單據程式裡的「相關文件」button，在簽核時應顯示。
# Modify.........: No.TQC-5A0093 05/11/22 By Nicola oap041,oap042,oap043的值會被清空
# Modify.........: No.MOD-5A0137 05/11/23 By Rosayu 由合約轉訂單時,若已經轉過其中一部份的數量 ,第二次登打資料自動轉出的時候並未扣掉已轉出的數量(兩個單位都未扣除)
# Modify.........: No.MOD-5B0115 05/11/29 By Nicola 客戶單號輸入完後，需重show到主畫面
# Modify.........: No.TQC-5B0078 05/11/29 By Nicola 單身修改數量(由10->12->10)後,後面的金額欄位不會跟著換算
# Modify.........: No.MOD-5C0037 05/12/06 By Nicola 從估價單轉入時不會生成訂單總金額
# Modify.........: No.TQC-5C0014 05/12/07 By Carrier set_required時去除單位換算率
# Modify.........: No.FUN-5C0076 05/12/21 By wujie  增加oeb906欄位，判斷是否需要檢驗，并把此欄位值傳給出貨單
# Modify.........: No.FUN-610053 06/01/10 By Nicola 新增程式axmt401，傳入的參數為"A"
# Modify.........: No.FUN-610056 06/01/11 By Carrier 出貨驗收功能 -- 新增oea65
# Modify.........: No.FUN-610055 06/01/18 By Elva 分銷系統更改
# Modify.........: No.TQC-5C0103 06/01/23 By Nicola 計價數量會自己跑出來
# Modify.........: No.TQC-5C0104 06/01/23 By Nicola 不使用計價數量時，計價數量需等於單據數量
# Modify.........: No.TQC-5C0107 06/01/23 By Nicola 計價數量改變時，金額要跟著改變
# Modify.........: No.MOD-5C0150 06/01/23 By Nicola 修改時，g_tt_oeb12也要給值
# Modify.........: NO.MOD-610123 06/01/23 By PENGU 若來源單號不是NULL就要控制幣別欄位不允許輸入
# Modify.........: No.FUN-610055 06/03/07 BY Ray 訂單簡表格式修改
# Modify.........: No.FUN-640024 06/04/07 By Echo 新增流程訊息通知功能
# Modify.........: No.MOD-610149 06/04/03 By pengu 單身的含稅金額應卡關,不得小于未稅金額
# Modify.........: No.TQC-640085 06/04/08 By Elva 返利時不拋轉請購單
# Modify.........: No.FUN-640181 06/04/13 By Alexstar 若在「系統參數設定作業(aoos010)」裡未設定「簽核流程與EasyFlow串聯」，
#                                                     請"隱藏"整合單據作業裡的「EasyFlow送簽」及「簽核狀況」Button.
# Modify.........: No.FUN-640074 06/04/11 By Rayven 根據aqci150的設定來決定檢驗否
# Modify.........: No.FUN-610076 06/01/23 By Nicola 計價單位功能改善
# Modify.........: No.FUN-610002 06/01/23 By Nicola 使用多屬性料件(sma120='Y')時,訂單輸入料號時,應可開窗查詢貨號
# Modify.........: NO.FUN-5A0071 06/02/08 By yiting MENU 其它資料  改用多欄維護display
# Modify.........: No.FUN-620063 06/02/27 By Saki 自訂欄位功能
# Modify.........: No.FUN-630006 06/03/06 By Nicola oeb920有值，不可取消確認
# Modify.........: No.FUN-640013 06/03/27 By Lifeng 料件多屬性新機制修改
# Modify.........: No.FUN-630013 06/04/03 By pengu 查詢時,提供來源號碼可開窗
# Modify.........: No.FUN-640025 06/04/08 By Nicola 新增欄位oea37
# Modify.........: No.FUN-640048 06/04/08 By Sarah 將show0()段裡,原來CALL t400_oea1015()改掉
# Modify.........: No.MOD-640107 06/04/09 By Lifeng Fix Bug
# Modify.........: No.TQC-640132 06/04/18 By Nicola 日期調整
# Modify.........: No.MOD-640540 06/04/21 By wujie t320_b_get_price重新取價后，oeb17沒有更新
# Modify.........: No.TQC-640171 06/04/28 By Rayven 多屬性新增訂價編號判定
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-640013 06/04/25 By pengu ma116的值已改變為0,1,2,3 所以應改寫
# Modify.........: No.FUN-640259 06/04/28 By Sarah 其他資料畫面增加顯示oeb17(取得單價)
# Modify........,: No.MOD-640569 06/04/26 By Nicola 出貨改用況狀碼判斷 (by Clinton 060502)
# Modify.........: No.FUN-570069 06/05/04 By Sarah t400_out(),修改ON ACTION print_this_order里的g_msg
# Modify.........: No.TQC-650075 06/05/19 By Rayven 現將程序中涉及的imandx表改為imx表，原欄位imandx改為imx000
# Modify.........: No.TQC-650111 06/05/24 By Elva 單別去出后自動帶出是否計算業績
# Modify.........: No.FUN-650108 06/06/05 By Rayven 將atmt230和axmt410合并成一支程序
# Modify.........: No.FUN-640248 06/05/26 By Echo 自動執行確認功能
# Modify.........: No.TQC-650117 06/06/07 By Pengu axmt410 串axmr400時,單價金額無法印出
# Modify.........: No.MOD-650026 06/06/16 By Claire 查詢的資料再以其它資料鈕開窗,再以X關閉時,會將原單身資料清除
# Modify.........: No.MOD-540201 06/06/23 By Mandy 更新料件主檔的最近售價ima33
# Modify.........: No.TQC-660097 06/06/23 By Rayven 多屬性功能改進:查詢時不顯示多屬性內容
# Modify.........: No.FUN-650108 06/06/28 By Rayven cl_err --> cl_err3
# Modify.........: No.MOD-660156 06/07/03 By kim 修改單身時,第一數量不會跟著第二數量作轉變
# Modify.........: No.FUN-660216 06/07/11 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-670061 06/07/17 By kim GP3.5 利潤中心
# Modify.........: No.FUN-670063 06/07/20 By kim GP3.5 利潤中心
# Modify.........: No.MOD-670123 06/07/28 By Rayven 訂單單身筆數顯示不正確
# Modify.........: NO.FUN-670007 06/08/04 BY yiting 1.add oeb27/oeb28 2.改拋轉請購單畫面
#                                                   3.單頭新增(7.多角銷售轉入)
#                                                   4.若資料來源為1輸入，單身轉入項次改為「客戶訂單項次」並可輸入:
# Modify.........: No.FUN-680022 06/08/25 By cl     多帳期處理
# Modify.........: No.FUN-670099 06/08/28 By Nicola 價格管理處理
# Modify.........: No.FUN-660073 06/08/28 By Nicola 原因碼外顯可維護
# Modify.........: No.TQC-690018 06/09/05 By Rayven 隱藏有些程式不顯示的調貨客戶，代送商欄位

# Modify.........: No.FUN-680137 06/09/18 By bnlent 欄位型態用LIKE定義
# Modify.........: No.FUN-680057 06/09/18 By rainy 1.代入預設倉儲位
#                                                  2.未確認單據可按"其他資料"
# Modify.........: No.TQC-680107 06/09/22 By Rayven 修改流通配銷下axmr820,axmr830 CALL的參數
# Modify.........: No.FUN-690024 06/09/28 By jamie 判斷pmcacti
# Modify.........: No.FUN-690025 06/09/28 By jamie 改判斷狀況碼ima1010、occ1004
# Modify.........: No.FUN-690044 06/10/23 By rainy 取消BU間銷售
# Modify.........: NO.CHI-6A0016 06/10/26 BY yiting 訂單?轉請購單時,未default 統購否及拋轉否兩欄位的值='N'
#                  會造成所產生的請購單透過apmp500請購轉採購時,無法自動產生單身
# Modify.........: No.CHI-6A0004 06/11/06 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0092 06/11/13 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0058 06/11/14 By day 在單價、金額截位后加顯示
# Modify.........: No.TQC-6A0045 06/11/15 By Claire 合約訂單檢驗否default 'N'
# Modify.........: No.FUN-6A0020 06/11/17 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0046 06/11/21 By Judy 復制未控管，導致復制無法退出
# Modify.........: No.TQC-6B0117 06/11/21 By day 欄位加控管
# Modify.........: No.FUN-6B0065 06/11/21 By Ray atmi217并入aooi313(azf09,10,11,12,13取代tqe03,04,05,11,08)
# Modify.........: No.TQC-690060 06/11/24 By Sarah 當aza50='N',oea00='7'時,要可以帶出oea1015(代送商)
# Modify.........: NO.FUN-670007 06/12/01 by Yiting poz05取消使用/站別流程從第0站開始
# Modify.........: No.FUN-6A0151 06/12/04 By jamie 加show欄位oeb16"排定交貨日"
# Modify.........: No.FUN-690082 06/12/06 By Claire 列印時menu多一個放棄action
# Modify.........: No.MOD-6B0153 06/12/06 By Claire 傳參數錯誤
# Modify.........: No.MOD-680102 06/12/06 By Claire insert into pml_file pml190,pml192 default 'N'
# Modify.........: No.MOD-6A0087 06/12/06 By Claire mark不需給值
# Modify.........: No.TQC-690041 06/12/06 By Claire 由合約轉入時,l_qty需回傳,調整MOD-660090
# Modify.........: No.TQC-690027 06/12/06 By Claire 其它資料的抬頭會有多單位的顯示
# Modify.........: No.MOD-690033 06/12/05 By pengu 程式6578行sql語法錯誤
# Modify.........: No.CHI-690038 06/12/08 By pengu oea72不管是不是首次確認，均應於確認時更新成Today
# Modify.........: No.MOD-6B0151 06/12/11 By claire update oeb17改 oeb07
# Modify.........: No.MOD-6A0171 06/12/11 By claire oea11不需選項A訂單底稿
# Modify.........: No.MOD-680093 06/12/14 By pengu 2434行BUG單FUN-540049新增判斷式錯誤
# Modify.........: No.MOD-6A0080 06/12/14 By Mandy 做ckd/skd 時,insert 單身,有些欄位oeb920,oeb906給default
# Modify.........: No.TQC-6B0124 06/12/19 By pengu 參數勾選不使用多單位但使用計價單位時，計價單位與計價數量會異常
# Modify.........: No.TQC-6C0138 06/12/25 By Rayven 當流通配銷大陸版時，如果單別是勾選自動審核的，單身沒有走到返利單身就直接審核了
# Modify.........: No.TQC-6C0183 06/12/29 By chenl  修正查詢無效資料時報錯信息錯誤的bug。
# Modify.........: No.TQC-6C0217 06/12/28 By Rayven 點作廢沒有立即顯示作廢的圖標
# Modify.........: No.MOD-710012 07/01/03 By jamie 資料來源為合約轉入時，輸入時會帶錯oeb05_fac
# Modify.........: No.FUN-6C0006 07/01/10 By kim GP3.6產業別程式模組化(與aza50相關處理移至saxmt400dis.4gl)
# Modify.........: No.FUN-710037 07/01/17 By kim GP3.6 add saxmt400icd
# Modify.........: No.FUN-6C0050 07/01/29 By rainy 新增拋轉採購單功能
# Modify.........: No.TQC-710032 07/01/30 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-710046 07/02/02 By cheunl 錯誤訊息匯整
# Modify.........: No.FUN-710074 07/02/02 By kim 修正FUN-6C0006的問題
# Modify.........: No.FUN-720009 07/02/07 By kim 行業別架構調整
# Modify.........: No.CHI-6A0054 07/02/08 By rainy 作廢還原時檢查要還原的訂單來源是否也為2.退補，且銷退單號相同的未作廢訂單
# Modify.........: No.FUN-6A0136 07/02/12 By Nicola 增加一action"取消分配"
# Modify.........: No.MOD-720009 07/02/13 By pengu 訂單拋轉請購單時pml18會被default "1899/12/31"
# Modify.........: No.CHI-6B0006 07/02/14 By rainy 稅別更改時，訊問是否更新單價並重算，幣別匯率更改時，提示使用者要更改單身資
# Modify.........: No.FUN-730002 07/02/27 By kim 行業別架構調整
# Modify.........: No.FUN-720014 07/03/02 By rainy 地址擴充為5欄255
# Modify.........: No.FUN-720043 07/03/05 By Mandy APS整合調整
# Modify.........: No.FUN-730018 07/03/07 By kim 行業別試調整
# Modify.........: No.TQC-6B0105 07/03/09 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-730022 07/03/12 By rainy GP5.0新功能，修改拋轉請購單及採購單
# Modify.........: No.MOD-730043 07/03/14 By claire axm-033的判斷調整
# Modify.........: No.FUN-730012 07/03/16 By kim 將確認段和過帳段移到saxmt400_sub.4gl
# Modify.........: No.FUN-730018 07/03/27 By kim 行業別架構
# Modify.........: No.MOD-730103 07/04/04 By claire 補傳 l_qty
# Modify.........: No.MOD-710180 07/04/04 By claire obg07,obg08,obg22取值來自於occ21,occ20,occ22
# Modify.........: No.MOD-730075 07/04/04 By claire oeb916 誤寫oeb12 csd 取價問題
# Modify.........: No.TQC-740041 07/04/09 By claire get_price 的判斷修改
# Modify.........: No.TQC-6C0131 07/04/11 By pengu 未考慮計價數量的沖銷的情形
# Modify.........: No.FUN-740040 07/04/11 By Nicola 原因碼應只開出 azf02='2' 理由碼資料
# Modify.........: No.FUN-740046 07/04/12 By rainy pmn94->pmn24
# Modify.........: No.CHI-730002 07/04/12 By Smapmin 當類別＝出至境外倉時，單頭[出貨簽收]欄位default='N' 且設為noentry
# Modify.........: No.FUN-740053 07/04/12 By Nicola 原因碼改call q_azf
# Modify.........: No.FUN-740016 07/04/16 By Nicola 借出管理修改
# Modify.........: No.CHI-740014 07/04/16 By kim (多角訂單) oea905(多角拋轉否) 應不可輸入
# Modify.........: No.TQC-740127 07/04/18 By claire Easy Flow 開啟畫面時,action取消分配不可顯示
# Modify.........: No.TQC-740135 07/04/19 By arman 估價單、報價單轉入時候，單身不能自動帶出
# Modify.........: No.TQC-740152 07/04/20 By rainy GP5.0整合測試
# Modify.........: No.TQC-740202 07/04/22 By claire 原因碼的條件應同於qry的 azf02='2'
# Modify.........: No.TQC-740203 07/04/23 By elva 取消atmr231,atmr230
# Modify.........: No.MOD-740365 07/04/23 By Nicola q_pmc4傳回值不正確
# Modify.........: NO.MOD-740313 07/04/23 BY yiting 若不提供客戶簽收流程，則"客戶出貨簽收否"欄位應隱藏，以免造成誤解。
# Modify.........: No.MOD-740308 07/04/24 By Claire 由流通配銷合約轉入的訂單,不用check料號
# Modify.........: No.TQC-740281 07/04/24 By Echo 若由TIPTOP走簽核流程,APS Action要隱藏
# Modify.........: No.MOD-740114 07/04/25 By Mandy 料件的正確性控管,不應只限制在走流通配銷的參數內
# Modify.........: No.TQC-740227 07/04/25 By rainy 若訂單留置，確認時，不可執行流程自動化的自動拋轉作業
# Modify.........: No.FUN-740091 07/04/25 By rainy 流程自動化應過濾掉非axmt410的
# Modify.........: No.TQC-740302 07/04/25 By Sarah 串報表axmr401少傳參數
# Modify.........: No.MOD-740441 07/04/24 By claire 使用計價單位(ex,KPCS)由報價單轉入時,單位(ex,PCS)至訂單單身計價單位仍應為KPCS且計價數量要轉換為KPCS的數量
# Modify.........: No.TQC-740323 07/04/26 By Rayven 第一次單身使用搭贈類的原因碼，在這一行輸入完畢以后再回到原因碼的欄位修改成非搭贈類的，然后就離開當前行，這個時候金額是不會重新計算的，導致金額錯誤
# Modify.........: No.TQC-740349 07/04/28 By Rayven 若為帶出訂價編號也應先可以過"單位"欄位，返利單身的小數金額沒有截位
# Modify.........: No.TQC-750013 07/05/04 By Mandy 1.參數設不串APS時或axmt400或axmt420 Action "APS相關資料"不要出現
#                                                  2.一進入程式,不查詢直接按APS相關資料,當出
# Modify.........: No.FUN-750036 07/05/09 By rainy 商品借貨送貨單
# Modify.........: No.FUN-740034 07/05/14 By kim 確認過帳不使用rowid,改用單號
# Modify.........: No.TQC-750111 07/05/21 By rainy 單身由報價單轉入oeb906要default
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750133 07/05/24 By jamie 按Action "拋轉請購單"或"拋轉採購單",因為留置[oeahold]而無動作,加show message
# Modify.........: NO.TQC-750157 07/05/25 BY yiting oeb900改為oeb920
# Modify.........: NO.TQC-750207 07/05/28 BY kim 合約轉入訂單時,合約單號開窗有誤
# Modify.........: No.TQC-750231 07/05/29 By wujie 刪除資料時，需同時更新mps的資料
# Modify.........: NO.TQC-750150 07/06/03 BY yiting 依package做法先不處理
# Modify.........: No.TQC-720023 07/06/05 By Echo 若此單別勾選自動確認時，新增單據完成時應詢問使用者「是否確認」而不該直接執行確認段。
# Modify.........: No.TQC-760132 07/06/14 By Judy 沒有根據客戶+債權帶出相應的稅種，收款條件
# Modify.........: No.MOD-760083 07/06/20 By claire 來源自報價單時應先帶入發票別及客戶簡稱
# Modify.........: No.TQC-760210 07/06/29 By wujie  合約單時，隱藏備置按鈕
# Modify.........: No.TQC-770039 07/07/06 By Rayven 稅種已設為無效,錄入此稅種無控管
# Modify.........: No.TQC-780001 07/08/01 By wujie  axmt410中，當在銷售參數檔axms100中勾選“訂單錄入時，依客戶品號轉換”，在下訂單時，目前無法錄入客戶料號通過。
# Modify.........: No.MOD-780014 07/08/02 By claire EasyFlow執行時遇到axm-802會造成執行結果與原據狀況不符
#                                                                     axm-104 修改同上
# Modify.........: No.TQC-710080 07/08/11 By pengu  當不使用計價單位時,若去修改請購單位時隱藏的計價單位不會跟著變動
# Modify.........: No.MOD-770007 07/08/24 By claire 由單身新增時自行帶報價單項次資料會沒帶出計價數量及計價單位
# Modify.........: NO.CHI-780042 07/08/27 BY yiting oeb1001理由碼不需為not null
# Modify.........: NO.MOD-780118 07/08/28 BY claire 維護oeb15時 oeb15也需調整
# Modify.........: NO.MOD-780272 07/08/29 BY claire oeb11的值被清空
# Modify.........: NO.MOD-780165 07/08/29 BY claire 調貨出貨代送商(oga1016)可以空白且可輸入
# Modify.........: NO.MOD-780155 07/08/30 BY yiting oeb1001要判斷流通配銷參數
# Modify.........: NO.MOD-790121 07/09/26 BY claire 使用母子單位依產品價格檔取價錯誤
# Modify.........: NO.MOD-7A0003 07/10/04 BY Carol 單身修改狀態下fetch資料後重新讀取料件ima_file的相關資料
# Modify.........: No.TQC-7A0009 07/10/05 By saki unicode區程式段缺
# Modify.........: No.MOD-7A0063 07/10/11 By Pengu 使用母子單位時oeb12的值會異常
# Modify.........: No.MOD-7A0074 07/10/15 By claire order_query加入權限控管
# Modify.........: No.CHI-7A0036 07/10/24 By Carol 金額計算的處理同AXR
# Modify.........: No.MOD-7A0155 07/10/29 By claire 合約主檔的單身oeb24應改為已訂數量而非已交數量
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/14 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.FUN-7B0080 07/11/16 By saki 自定義欄位功能修改
# Modify.........: No.MOD-7B0155 07/11/16 By claire 新增時oeb16被清空是不合理的
# Modify.........: No.TQC-7B0136 07/11/26 By wujie  非搭增時單身金額應不小于數量*單價
# Modify.........: No.MOD-7B0216 07/11/26 By claire 報表傳入語言別有誤
# Modify.........: No.MOD-7C0023 07/12/05 By claire 寄銷訂單若已帶入預設倉庫不應再重取主要倉庫(ima35)
# Modify.........: No.TQC-7C0011 07/12/05 By Judy 已拋轉資料，取消審核時無錯誤提示信息
# Modify.........: No.TQC-7C0054 07/12/06 By Rayven 點擊“多角拋轉還原”無任何反應，亦無提示信息
# Modify.........: No.TQC-7C0069 07/12/07 By heather 點擊"多角貿易"后會彈出對話框"請按ENTER繼續",
#                                                     現在要求將這個對話框去掉
# Modify.........: No.TQC-7C0103 07/12/08 By Unicorn 增加ROLLBACK
# Modify.........: No.TQC-7C0098 07/12/08 By Judy 1.寄銷出貨時代送商不為必要輸入
#                                                 2.更改報錯信息"atm-028"->"atm-045"
#                                                 3.可修改訂單單價時，可手動輸入定價編號和單價
#                                                 4.出貨單身為非搭贈時，總金額不可修改
#                                                 5.單身單價要考慮單頭是否含稅
#                                                 6.出貨單身輸入提案取單價時，要加入幣別條件
#                                                 7.出貨單身有正常出貨和搭贈時，總金額欄位不可輸入
#                                                 8.出貨單身理由媽應該開出貨類型
#                                                 9.出貨單為寄銷出貨時，不可勾選客戶出貨簽收
# Modify.........: No.TQC-7C0118 07/12/08 By agatha 修改CALL cl_err3("sel","occ_file",g_oea.oea17,"",STATUS,"","select occ",1) 將status 替換成axm-177
# Modify.........: No.FUN-7B0142 07/12/10 By jamie不應在rpt寫入各語言的title，要廢除這樣的寫法(程式中使用g_rlang再切換)，報表列印不需參考慣用語言的設定。
# Modify.........: No.MOD-7B0201 07/12/12 By Carol oeb906欄位給值後應再display一次
# Modify.........: No.MOD-7C0196 07/12/26 By claire axmr401只印出對外公司名稱
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-810016 08/01/31 By hongmei 增加oebislk01
# Modify.........: No.FUN-810045 08/02/13 rainy 項目管理，單身新增專案代號oeb41/WBS編號oeb42/活動代號oeb43
# Modify.........: No.FUN-7C0017 08/02/26 By bnlent 新增ICD行業字段
# Modify.........: No.FUN-7B0018 08/02/16 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-820046 08/03/05 By xumin 增加混合包裝和二維單身錄入功能
# Modify.........: No.FUN-820033 08/03/10 By wujie 返利改善，增加“生成現返”，“生成物返”，“物返結案”三個功能
# Modify.........: No.FUN-7B0077 08/03/12 By mike  新增ICD功能
# Modify.........: No.MOD-810066 08/03/19 By claire 新增單身時輸入其它資料的出貨倉儲批, 待寫入後就不該再重取ima35,ima36的資料
# Modify.........: No.MOD-810072 08/03/19 By claire 需加入小數取位再判斷
# Modify.........: No.MOD-810088 08/03/19 By claire 使用客戶品號轉換(oaz46)規格調整
# Modify.........: No.MOD-810135 08/03/19 By claire 來源以報價單轉入時,oeb1012應給值,以免造成AR無法立帳
# Modify.........: No.MOD-820174 08/03/20 By claire 確認時,判段的錯誤訊息顯示
# Modify.........: No.MOD-830183 08/03/24 By claire 應使用g_oeb_t.oeb03,否則會有axm-073的錯誤
# Modify.........: No.FUN-830089 FUN-840036 08/03/27 By xumin  單頭二維輸入欄位修改時管控
# Modify.........: No.FUN-840011 08/04/02 By saki 單身自定義欄位範例
# Modify.........: No.MOD-840060 08/04/08 By claire 於項次時,按確定應為不寫入
# Modify.........: No.MOD-840077 08/04/10 By claire 取消確認時排除已作廢的帳款資料
# Modify.........: No.FUN-830116 08/01/31 By hongmei 修改oebislk01為非必輸欄位
# Modify.........: No.CHI-840015 08/04/18 By claire 使用參考單位時,修改單位一(銷售)單位時,應更新單位一的轉換率,以oeb05不以ima31
# Modify.........: No.MOD-840073 08/04/09 By chenl 多角貿易下，隱藏"拋轉請購單,拋轉采購單"兩個按鈕.
# Modify.........: No.MOD-840473 08/04/21 By kim 因單頭的幣別可能會更改,單身單價不管事後有無修改都應該重計金額
# Modify.........: No.MOD-840574 08/04/22 By hellen 客戶代號沒有任何卡關，但是到出通知單時，會卡occ06性質必為1.買受人才能填，
#                                                   若是要卡關，在訂單就開始卡關。
# Modify.........: No.FUN-840210 08/04/25 By kim 若該幣別的匯率檔取不到匯率資料，應該設定錯誤訊息
# Modify.........: No.FUN-840128 08/04/28 By Carrier 拋轉采購單成功后,要即時將采購單及數量顯示在單身上
# Modify.........: No.CHI-840073 08/04/29 By claire 單價比取得單價低時,要停在單價欄位
# Modify.........: No.MOD-850014 08/05/05 By claire 需加入小數取位再判斷
# Modify.........: No.MOD-850198 08/05/20 By Carrier sma908判斷時,加入sma120='Y'的額外判斷
# Modify.........: No.FUN-850128 08/05/26 by sherry 選擇類別為 "借貨還價" , 輸入資料來源為 : 借貨訂單 ,
#                                                   但是, 開窗看不到 借貨訂單資料
# Modify.........: No.FUN-850027 08/05/30 By douzh WBS編碼錄入時要求時尾階并且為成本對象的WBS編碼
# Modify.........: No.FUN-840165 08/06/02 By xiaofeizhu 類別為8或者9時動態地顯示title“借貨申請單資料”以及報表改為CR
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: NO.MOD-860078 08/06/06 BY Yiting ON IDLE 處理
# Modify.........: No.MOD-860114 08/06/12 By Smapmin 無法連續列印二次
# Modify.........: No.MOD-860171 08/06/16 By Smapmin axmt420無法複製
# Modify.........: No.FUN-860096 08/06/24 By xiaofeizhu axmt420打印時選擇“打印訂單變更單”時，報表動態變換title內容為"借貨申請單資料"
# Modify.........: No.MOD-870031 08/07/02 By Smapmin 修改檢驗(oeb906)輸入與否的判斷
# Modify.........: No.MOD-870034 08/07/03 By Smapmin 當oeb1012為NULL時,預設為'N'
# Modify.........: No.FUN-840184 08/07/07 By xiaofeizhu oeb11不需做隱藏的管控，直接顯示
# Modify.........: No.MOD-860316 08/07/08 By Sarah CALL cl_flow_notify(g_oea.oea01,'D')時,g_oea.oea01已被清空,需在g_oea清空前LET l_oea01=g_oea.oea01,cl_flow_notify改傳l_oea01
# Modify.........: No.MOD-860095 08/07/10 By claire 拋請購單及拋採購單的Action,若為最終訂單且沒有最終供應商的設定才可以使用
# Modify.........: No.MOD-870139 08/07/11 By Smapmin 備品料號不可與訂單銷售料號相同.
# Modify.........: No.MOD-830073 08/07/14 By jan  將show函數內對表進行更新操作的語句mark。對單頭金額的統計已經在單身中存在，此處已不再需要做統計。且show函數內不該出現update的動作。
# Modify.........: No.FUN-840183 08/07/14 By xiaofeizhu axmt410在新增時，訂金條件、尾款條件帶出做為預設
# Modify.........: No.MOD-870175 08/07/14 By Smapmin 複製時,單身請購單號與請購數量要清空
# Modify.........: No.MOD-820066 08/07/15 By jan  修改金額計算，將單價*折扣率后的單價進行取位后再與數量相乘得到金額。
# Modify.........: No.MOD-830016 08/07/15 By jan  修正MOD-820066。需判斷折扣率是否為null，若為null則應該賦值為100
# Modify.........: No.MOD-870229 08/07/21 By Smapmin 約定交貨日,應卡關不可小於訂單日期
# Modify.........: No.MOD-880038 08/08/06 By Smapmin 訂單來源為合約單時,訂單數量應考慮與合約單單位換算的問題
# Modify.........: No.MOD-880064 08/08/12 By Pengu 資料來源為估價單轉入時單價未依單頭含稅否存放正確值
# Modify.........: No.MOD-880102 08/08/13 By lumx 修改產品編號時候 直接點擊確定沒有更新客戶產品編號
# Modify.........: No.MOD-880123 08/08/15 By claire 單身自定義欄位新增時未寫回oeb_file
# Modify.........: No.FUN-870117 08/08/20 By chenyu 服飾版單頭增加出口國欄位
# Modify.........: No.MOD-820125 08/02/25 By chenl  對取價后的單價進行取位。
# Modify.........: No.TQC-890035 08/09/16 BY DUKE 移除 APS 相關資料ACTION
# Modify.........: No.MOD-890150 08/09/18 By Smapmin 更改報表temp table定義的位置
# Modify.........: No.MOD-890137 08/09/19 By Smapmin 客戶產品編號(oeb11)無法維護
# Modify.........: No.FUN-890011 08/10/14 By xiaofeizhu 由估價單/報價單轉入時，要檢查客戶是否存在於正式客戶資料(occ_file)中，如未存在顯示錯誤訊息并不允許新增
# Modify.........: No.MOD-8A0144 08/10/16 By Smapmin 輸入完單身資料後開窗輸入其他資料時,無法update oeb_file
# Modify.........: No.MOD-8A0137 08/10/17 By chenl   若計價單位與銷售單位一致，則計價數量等于銷售數量，不必通過轉換取得，以避免尾數。
# Modify.........: No.MOD-8A0154 08/10/17 By chenl   若使用計價單位，則取價時應以計價單位為主。
# Modify.........: No.MOD-8A0098 08/10/22 By wujie  設定單別綁定屬性群組時，修改多屬性料件欄位，開窗返回的還是未修改的老料號
# Modify.........: No.TQC-8A0073 08/10/29 By claire 若以借貨訂單要帶出單身時,無法帶出
# Modify.........: No.MOD-8A0267 08/10/31 By sherry 在call t400_two_uygur()前加入判斷是否使用多屬性料件
# Modify.........: No.MOD-8B0048 08/11/10 By Smapmin 料號若未更改,檢驗否欄位不需重新帶出
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910
# Modify.........: No.MOD-8C0003 08/12/02 By Smapmin 客戶編號輸入時,不應限制只能輸入買受人
# Modify.........: No.MOD-8C0053 08/12/05 By Smapmin 修改其他資料裡的客戶產品編號,但並未update到資料庫
# Modify.........: No.CHI-8B0015 08/12/11 By xiaofeizhu 在axmt410判斷如oea00='6' 則 oea65 不可輸入，且設為"N"
# Modify.........: No.MOD-8C0118 08/12/15 By Smapmin 取消留置後未重新查詢,留置的變數未更新導致判斷錯誤
# Modify.........: No.MOD-8C0193 08/12/22 By Smapmin 複製後版號應default為0
# Modify.........: NO.FUN-8C0078 08/12/23 BY yiting add oea918訂金立帳分期/oea919尾款立帳分期
# Modify.........: No.TQC-910038 09/01/16 By xiaofeizhu axmt420借貨償價(oea00='9')訂單之倉庫批預設為oeb09=oaz78，oeb091=" "，oeb092=oea03
# Modify.........: NO.FUN-920041 09/02/04 By ve007 列印明細時會列出重復的資料
# Modify.........: No.MOD-920047 09/02/04 By Smapmin 訂單單號存在出貨單單頭/單身時,皆不能取消確認
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-920091 09/02/06 By Smapmin 執行單身其他資料action之後,要停留在原先的欄位
# Modify.........: No.MOD-920281 09/02/23 By Smapmin 確保跑ON ROW CHANGE段
# Modify.........: No.MOD-920301 09/02/24 By Smapmin 使用多單位時,無法使用價格表取價
# Modify.........: No.CHI-930018 09/03/11 By jan 解決執行 axmt410_icd 打印 [打印明細]，會出現報表檔案路徑無效 的錯誤
# Modify.........: No.MOD-930071 09/03/12 By Pengu 新增時無法修改檢驗碼
# Modify.........: No.FUN-920186 09/03/20 By lala  理由碼oeb1001必須為銷售原因
# Modify.........: No.MOD-930223 09/03/25 By Dido oea65 需增加 oea901 = 'Y' 時預設值為 'N'
# Modify.........: No.MOD-940052 09/04/07 By Dido oea00 為 4.境外倉出貨訂單, 不可以點選 carry_po,carry_pr action
# Modify.........: No.MOD-940118 09/04/09 By lutingting單身得轉入項次,若在修改時,不應再預設為1或NULL
# Modify.........: No.MOD-940151 09/04/12 By Dido 將報價單客戶料號(oqu04)轉至訂單客戶料號(oeb11)中
# Modify.........: No.MOD-940312 09/04/23 By Smapmin 抓取庫存量時,要用SUM(img10*img21)
# Modify.........: No.MOD-940271 09/04/20 By Smapmin g_oeb17的值未重新抓取
# Modify.........: No.MOD-940263 09/04/22 By Dido oeb14與oeb14t須先取位後再計算
# Modify.........: No.MOD-940276 09/04/22 By Dido 串至出至境外倉訂單取 oea10
# Modify.........: No.TQC-940120 09/04/24 By sherry 其它資料action打不開
# Modify.........: No.MOD-940385 09/04/30 By Smapmin 抓取產品客戶檔(obk_file)時,應加上幣別條件的判斷
# Modify.........: No.TQC-950002 09/05/04 By chenyu b_ima918應該為b_ima921
# Modify.........: No.TQC-950020 09/05/13 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法
# Modify.........: No.FUN-940008 09/05/17 By hongmei 發料改善
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.TQC-950054 09/06/22 By jan 單身更改時，ICD行業欄位更改不成功
# Modify.........: No.TQC-960137 09/06/12 By lilingyu sql語句中請增加關聯oea_file
# Modify.........: No.MOD-960187 09/06/17 By Dido 取消確認執行 axmp810 條件應與 restore action 一致
# Modify.........: No.MOD-940234 09/06/24 By mike 當訂單類別為9.借貨償價時,資料來源oea11應該要默認為8.借貨訂單,oea12要為必輸欄>
# Modify.........: No.MOD-960262 09/06/24 By Dido 料號異動時 oeb904 依 oeb13 異動
# Modify.........: No.FUN-960066 09/07/02 By Mandy 若單據需要跟EASYFLOW整合，將"信用額度"的檢查時間點調整為=>按下EASYFLOW送簽按鈕當下
# Modify.........: No.MOD-960046 09/07/07 By Smapmin 使用多單位且料件為單一單位時,單位一的轉換率有錯誤
# Modify.........: No.TQC-960401 09/07/07 By lilingyu 依原來設計,若不先輸入料號,應該單身輸入客戶產品編號后,
# ...................................................會自動從obk_file帶出料號,銷售單位等欄位,不過目前此功能無效
# Modify.........: No.MOD-960225 09/07/09 By Smapmin 單身oeb71名稱顯示問題
# Modify.........: No.TQC-970111 09/07/13 By lilingyu 輸入完單頭后就報錯:無法將NULL值插入到oea_file
# Modify.........: No.MOD-970142 09/07/16 By Smapmin 新增完後執行列印,應印出該筆新增的資料
# Modify.........: No.MOD-970154 09/07/21 By Dido 複製時 oea00,oea08 不可維護
# Modify.........: No.MOD-970229 09/07/24 By Dido t400_mixed_wrap() 應僅限用於 SLK 行業別
# Modify.........: No.FUN-870007 09/07/27 By Zhangyajun 流通零售功能修改
# Modify.........: No.CHI-970074 09/08/03 By mike axmt410手動登打類別為4.境外倉出貨時,或是出至境外倉出貨單確認時自動產生境外倉出貨訂
#                                                 都要將檢驗碼default為'N'
# Modify.........: No.MOD-980022 09/08/04 By mike 將IF l_count < 1 THEN ....END IF的判斷拿掉.
# Modify.........: No.CHI-960007 09/08/12 By mike 發現訂單不定時出現計價數量／計價單位為null值的情況
# Modify.........: No.TQC-980055 09/08/17 By lilingyu 1.返利單身錄入,確定后,返利單身的資料丟失 2.返利單身有資料的情況,含稅欄位的值顯示到了非直營KAB欄位上
# Modify.........: No.TQC-8C0091 09/08/18 By hongmei 同FUN-8C0078
# Modify.........: No.MOD-980150 09/08/19 By Dido 取消作廢邏輯更新 oeb_file 問題調整
# Modify.........: No.FUN-960130 09/08/27 By Sunyanchun 取價
# Modify.........: No.TQC-980181 09/08/21 By sherry 賬務資料頁簽“定金應收比例、出貨應收比例”應該控管為不可輸入負數！
# Modify.........: No.TQC-980182 09/08/21 By sherry 幣種后面的匯率欄位輸入負數沒有控管！
# Modify.........: No.TQC-980149 09/08/31 By lilingyu "交運方式"欄位旁需增加一個欄位,并且自動帶出值
# Modify.........: No.TQC-980184 09/08/31 By lilingyu "允許超交率"欄位輸入負數及超過100沒有控管
# Modify.........: No.FUN-980010 09/08/31 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.CHI-970015 09/09/01 By Dido 依據不同訂單類型開窗
# Modify.........: No.MOD-990022 09/09/02 By sherry 修改單頭的客戶后，增加提示，請用戶確認單身的單價
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.MOD-980285 09/09/07 By mike oeb17=oeb13應取消，否則將導致復制后之oeb17被改變與原單據不同，如此在確認段做低於單
# Modify.........: No.MOD-990026 09/09/07 By mike 若換貨訂單單身料號相同有多筆會卡住
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-980029 09/08/05 By baofei 1.刪除段增加刪除tqw_file
#                                                   2.把自動編號放在事物中
# Modify.........: No.MOD-990184 09/09/29 By Smapmin 訂單變更單要依不同行業別執行不同的程式
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No:MOD-9A0154 09/10/26 By Smapmin oeb19 default 為N
# Modify.........: No:MOD-9A0165 09/10/27 By Smapmin 單頭"其他資料"ACTION,oebislk01只有在slk行業別時才update
# Modify.........: No:CHI-9A0052 09/11/02 By Smapmin 畫面沒有a1015_cs這個欄位
# Modify.........: No.FUN-9B0016 09/11/08 By Sunyanchun post no
# Modify.........: No:CHI-980019 09/11/05 By jan 虛擬料件不可做任何單據
# Modify.........: No:MOD-9B0110 09/11/18 By Smapmin 輸入完資料來源的單號後,要再檢核一下訂單單號是否正確
# Modify.........: No:MOD-9B0185 09/11/30 By Smapmin 境外倉出貨訂單分批產生
# Modify.........: No:FUN-9B0025 09/12/02 By Cockroach oeb48 0-->1,1-->2 和添加對 oeb13的管控
# Modify.........: No:MOD-9C0016 09/12/03 By mike 原有的零售管控非成本仓拿掉
# Modify.........: No:FUN-9C0064 09/12/14 By Cockroach oha87 改为开窗录入
# Modify.........: No:FUN-9C0082 09/12/16 By Cockroach 自动带出单身报错
# Modify.........: No:FUN-9C0083 09/12/16 By mike 取价call s_fetch_price_new()
# Modify.........: No:FUN-9C0090 09/12/16 By Cockroach mark cancle_price
# Modify.........: No:FUN-9C0120 09/12/21 By mike 通过价格条件管控单价栏位未取到价格时是否可以输入
# Modify.........: No:MOD-9C0326 09/12/24 By Smapmin 單身原因碼若屬於樣品時，建議不受取出單價控管
# Modify.........: No:MOD-9C0204 09/12/24 By Smapmin 境外倉出貨訂單的數量不可大於出至境外倉出貨單的數量
# Modify.........: No:MOD-9C0388 09/12/24 By Dido 於 oea01 時顯示 oaydesc
# Modify.........: No:FUN-9C0073 10/01/07 By chenls 程序精簡
# Modify.........: No:FUN-A10014 10/01/05 By Carrier 资料来源为2.退补时,自动产生单身
# Modify.........: No:TQC-A10104 10/01/11 By Carrier 输入杂项客户时,按"退出"会使单头输入完后,无法保存的现象
# Modify.........: No:FUN-A10110 10/01/26 By Cockroach 訂購單新增【折價明細】按鈕
# Modify.........: No:FUN-A10106 10/02/01 By destiny 订单新增赠品发放按钮      
# Modify.........: No:TQC-A20002 10/02/03 By cockroach 點【更改】時,oeb13應該不可更改,以及金額應在單價或數量更改后從新自動帶出
# Modify.........: No:MOD-A10123 10/02/03 By Smapmin oeb1006若為空時,default 100
# Modify.........: No:CHI-A10002 10/02/23 By sabrina 確認時,無倉儲批的錯誤訊息請加上料號,當單身筆數很多時,會查不出是哪一筆的問題
# Modify.........: No.TQC-A20058 10/02/25 By Cockroach lpj05的條件不完全
# Modify.........: No:CHI-880006 10/02/25 By Smapmin 在產品客戶檔(obk_file)有對應資料,且檢驗否(obk11)為Y時,才允許維護檢驗碼(oeb906)
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A30026 10/03/05 By Smapmin 延續MOD-8C0003的調整
# Modify.........: No:MOD-A30087 10/03/15 By Smapmin 修改來源單號後,單身若已有資料,詢問是否刪除
# Modify.........: No.TQC-A30041 10/03/16 By Cockroach add oriu/orig
# Modify.........: No.FUN-A20044 10/03/20 By jiachenchao 刪除字段ima26*
# Modify.........: No.TQC-A30149 10/04/02 By lilingyu 一般訂單作業,“尾款應收比率”欄位應控管不可更改
# Modify.........: No:TQC-A30155 10/04/02 By houlia  增加大陸版本的時候oea212的錄入查詢資料
# Modify.........: No:MOD-A30147 10/04/14 By Smapmin 單據複製時,匯率要重抓
# Modify.........: NO.MOD-A30239 10/04/14 By Smapmin 出至境外倉訂單要能輸入代送商
# Modify.........: No:CHI-990037 10/04/14 By Smapmin 還原TQC-960401
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->AXM
# Modify.........: No:MOD-A40121 10/04/21 By Smapmin 沒有使用計價單位時,畫面不可呈現計價數量
# Modify.........: No:TQC-A40113 10/04/22 By lilingyu 訂單復制時,未情況已分配量oeb920,導致無法取消審核
# Modify.........: No:TQC-A40142 10/04/29 By houlia oea212調整顯示資料
# Modify.........: No:MOD-A50014 10/05/05 By Smapmin 借貨訂單,單頭資料來源為1.輸入.借貨償價,單頭資料來源為8.借貨訂單
# Modify.........: No:FUN-A40055 10/05/10 By destiny 将construct和单身显示改为dialog写法
# Modify.........: No:MOD-A50009 10/05/10 By sabrina CALL s_signx1為舊的簽核功能，目前已不使用
# Modify.........: No.FUN-A50071 10/05/19 By vealxu GP5.2 相關程序增加POS單號字段 并管控如果不為空的情況下 不可取消審核與取消過帳
# Modify.........: No:TQC-A50060 10/05/20 By houlia 調整稅種oea21開窗資料顯示 
# Modify.........: No.FUN-A50054 10/05/25 By chenmoyan 增加服饰版二维功能
# Modify.........: No:FUN-A50103 10/06/03 By Nicola 訂單多帳期 1.取消訂單/尾款分期立帳欄位 2.增加訂單多帳期維護 3.增加訂金/出貨/尾款應收金額欄位
# Modify.........: No.FUN-A60027 10/06/08 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:CHI-A50004 10/06/24 By Summer 在確認/取消確認時,將lock資料的動作往前移至FUNCTION的一開始
# Modify.........: No:FUN-A60035 10/07/01 By chenls INSERT INTO oeb之前檢查oeb44
#                                                   slk行业下考虑项次问题
# Modify.........: No.FUN-A50102 10/07/23 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A60035 10/07/28 By chenls 服飾版二維功能mark
# Modify.........: No:MOD-A70112 10/07/29 By Smapmin 複製後要回到舊資料的畫面
# Modify.........: No:MOD-A50128 10/07/30 By Smapmin 由報價單轉入資料時,要考慮單位轉換率
# Modify.........: No:MOD-A60146 10/07/30 By Smapmin 訂單類別與訂單單別必須一致
# Modify.........: No:MOD-A70041 10/07/30 By Smapmin 由報價單default單身資料的方式要一致.
# Modify.........: No:MOD-A50092 10/07/30 By Smapmin 修改單身項次時,要連動修改選配件資料的對應
# Modify.........: No:FUN-A70146 10/08/02 By lilingyu 增加“單價查詢”action,通過輸入訂單項次,自動帶出"銷售價格明細查詢作業"axmq411
# Modify.........: No:MOD-A70164 10/07/21 By Carrier s_t400oeo时,加传订单单身数量
# Modify.........: No:TQC-A70029 10/08/03 By lilingyu  由客戶編號回推料號等資料時,加入單頭的幣別去obk_file 抓取資料
# Modify.........: No:CHI-A60026 10/08/03 By Summer 變更價格條件時，詢問是否update單價 
# Modify.........: No:CHI-A70030 10/08/03 By Summer 延續CHI-A60026,訂單單頭的金額沒有一併update
# Modify.........: No:FUN-A80024 10/08/09 By wujie  增加oeb32栏位
# Modify.........: No:MOD-A80124 10/08/16 By Smapmin oeb906為空時,未給N
# Modify.........: No:FUN-A80056 10/08/18 By destiny 資料來源為報價單時,幣別,稅別等皆抓取報價單上的資料
# Modify.........: No:FUN-A80102 10/08/18 By kim GP5.25號機管理
# Modify.........: No:FUN-A80054 10/08/25 By jan GP5.25工單合拼--新增oeb918欄位
# Modify.........: No.FUN-A80121 10/08/25 By shenyang  單身選擇料件可以多選，多選后自動生成多筆單身資料
# Modify.........: No.MOD-A80183 10/09/03 By lilingyu 經營方式欄位沒有帶出值
# Modify.........: No:FUN-A70132 10/09/08 By lixh1   增加“單身稅別明顯”按鈕
# Modify.........: No:MOD-A10134 10/09/28 By sabrina 在判斷排定交貨日oeb16為空時，將oeb05/oeb12回押oeb916/oeb917，
#                                                    會造成有使用雙單位時的單價錯誤
# Modify.........: No.FUN-A90048 10/09/29 By huangtao 修改料號欄位控管以及開窗
# Modify.........: No.FUN-A90040 10/10/08 By shenyang 添加單位編號和商戶編號兩個欄位
# Modify.........: No.FUN-AA0047 10/10/20 By Huangtao 修改料號管控bug
# Modify.........: No.TQC-AA0101 10/10/21 By lilingyu 1.單身欄位"折扣率"改為"配銷折扣率"(當流通配銷參數='Y'時)
#                                                     2.當營運中心的業態<>'2'時,隱藏action"可發贈品,單身稅別明細,折價明細,取消折價"
# Modify.........: No.TQC-AA0118 10/10/21 By lilingyu 1.若訂單為流通配銷的合約訂單時,單身的客戶項次可以不輸入值
#                                                     2."產生物返"action,諸多sql語法錯誤,以及程序邏輯更改
# Modify.........: No.TQC-A80141 10/10/21 By lilingyu 若是配銷合約時,不需要提示"是否由合約轉入訂單內容"的訊息和相關邏輯 
# Modify.........: No.TQC-AA0025 10/10/22 By lilingyu 1.合約訂單的截止日期判斷有誤 2.若債權對於的產品及其產品系列不符時,手工輸入會出現'atm-018'的提示,但開窗不會出現 
#                                                     3.在錄入單身"提案編號"後,程式判別單價抓取,若抓取不到,則加err msg     
#                                                     4.在錄入單身"產品編號"後,程式立即判別單價,但尚未輸入數量未產生計價數量,所以程式一定會卡住
# Modify.........: No:FUN-AA0038 10/10/22 By Nicola 訂金/尾款多帳期時，無分期資料不要詢問
# Modify.........: No.FUN-A30072 10/10/25 By jan 單價不可低于設定的最低單價
# Modify.........: No.TQC-AA0135 10/10/28 By lilingyu 單身無法新增
# Modify.........: No:MOD-AA0180 10/10/28 By Smapmin 修改計價單位與計價數量沒有值的問題
# Modify.........: No:MOD-AA0054 10/10/28 By Smapmin 由obk01預設給oeb04時,未給予ima相關的變數值
# Modify.........: No:MOD-AA0128 10/10/28 By Smapmin occ1029改由occ66取代
# Modify.........: No:FUN-AA0048 10/10/28 By Carrier GP5.2架构下仓库权限修改
# Modify.........: No:TQC-AA0139 10/11/01 By lilingyu AFTER INSERT 段oeb71,oeb04的判斷邏輯調整至確認段
# Modify.........: No:TQC-AA0128 10/11/04 By Carrier oeb1006赋值100
# Modify.........: No.FUN-AA0089 10/11/04 By suncx  單身選擇料件可以多選，多選后自動生成多筆單身資料,资料抓取修改
# Modify.........: No:FUN-AB0011 10/11/08 By huangtao 從庫存抓取資料前做料號控管
# Modify.........: No:TQC-AB0045 10/11/12 By lilingyu 選擇"資料來源"後,光標會移到合約單號的欄位,但這個欄位判別的原則是需加入客戶代號作為判別來源,這樣在輸入順便有點怪,
#                                                     現調整為"輸入合約只判別合約是否存在,之後才在客戶代號欄位判別此合約的客戶和訂單的客戶是否相同"(幣別欄位相同情況) 
# Modify.........: No.FUN-AB0061 10/11/16 By vealxu 增加基础单价oeb37和修改分摊折价计算
# Modify.........: No:MOD-AB0018 10/11/23 By Smapmin 帳款客戶編號不能選擇已停止交易的客戶
# Modify.........: No:MOD-A90080 10/11/23 By Smapmin 修改銷售性質後重抓匯率
# Modify.........: No:MOD-A80202 10/11/23 By Smapmin 多單位時也要做MOD-9C0204的控卡
# Modify.........: No:MOD-A80145 10/11/23 By Smapmin 計算已新增換貨訂單數量時,未排除作廢單據
# Modify.........: No:MOD-A80149 10/11/24 By Smapmin 修正錯誤訊息顯示內容
# Modify.........: No:FUN-AB0039 10/11/25 By lixh1   當程式代碼為"axmt410"時,"單身稅別明細"Action 才顯示,否則隱藏
# Modify.........: No:TQC-AB0025 10/11/26 By chenying 修改Sybase問題
# Modify.........: No:MOD-AB0233 10/11/26 By Dido 若訂金比率為 100 則 oea07 應為 'N' 
# Modify.........: No:TQC-AB0170 10/11/29 By lixh1   當留置碼oeahold不為空時才彈出'取消留置'提示
# Modify.........: No:TQC-AB0286 10/11/30 By wangxin after field oea12帶出後面的資料
# Modify.........: No:TQC-AB0407 10/12/02 By wuxj   insert tqn_file前判断tqn01,tqn02 是否为空
# Modify.........: No:TQC-AC0034 10/12/03 By lilingyu 單身"折扣"頁簽page07,在g_aza.aza26='0'時,不需隱藏
# Modify.........: No:TQC-AC0030 10/12/03 By lilingyu 产生现返时,t400_cash_cs4 cursor,foreach时,不可在回圈中加入commit,这样会造成无穷回圈 
# Modify.........: No:TQC-AC0028 10/12/03 By lilingyu 产生现返时,計算折扣金額的時候,折扣率tqr05應先除以100再進行計算
# Modify.........: No:TQC-AC0031 10/12/03 By lilingyu 产生现返时,會抓取預設現金折扣單別,若抓不到時需顯示error message,並且跳離現返作業(目前程式會卡,無法往下運作)
# Modify.........: No:TQC-AB0204 10/11/30 By shiwuying 单身折扣率oeb1006修改后，更新单价oeb13
# Modify.........: No:FUN-AC0012 10/12/03 By shiwuying 單價按鈕修改單價后,INSERT一筆到rxc_file,rxc03='13'
# Modify.........: No:FUN-AA0057 10/12/06 BY shenyang  修改q_lnt06_1 傳入參數
# Modify.........: No:TQC-AB0368 10/12/08 By wangxin   流通配銷勾選時也帶出oea12後面資料
# Modify.........: No:FUN-AB0096 10/12/14 By shiwuying 稅別明細按鈕只有azw04=2才顯示
# Modify.........: No:TQC-AC0139 10/12/15 By suncx 單身出貨倉庫修改後，游標移至下一筆時會回復原狀
# Modify.........: No:TQC-AC0163 10/12/15 By huangtao  INSERT INTO oeb_file時，有些字段未賦初值
# Modify.........: No:TQC-AC0035 10/12/16 By lilingyu 錄入"現金折扣單"欄位時,不需要加arg3:訂單單號
# Modify.........: No:TQC-AC0153 10/12/16 By huangtao 調整現返管控
# Modify.........: No:TQC-AC0251 10/12/17 By lilingyu 資料來源為3:合約轉入時,訂單單身無法由合約單自動帶出資料
# Modify.........: No:TQC-AA0040 10/12/17 By houlia 對oeb47、oeb48賦初值
# Modify.........: No:MOD-AC0151 10/12/18 By huangtao 單身輸入資料報錯無法繼續進行
# Modify.........: No:MOD-AC0180 10/12/18 By suncx p_qry的查詢條件資料錄入有誤，oea12開窗無資料
# Modify.........: No:MOD-AC0205 10/12/20 By shiwuying 查询画面最下方几个栏位显示异常
# Modify.........: No:MOD-AC0314 10/12/27 By chenying 輸入按確認 (跳到單身),此時單頭的價格條件、收款條件、業務、部門的說明都未自動帶出來
# Modify.........: No:MOD-AC0170 10/12/28 By shiwuying 現金折扣項次,料號DEFAULT 'MISC' 數量DEFAULT '1'方式處理
# Modify.........: No:FUN-AC0097 10/12/29 By shenyang 修改bug
# Modify.........: No:MOD-AC0316 10/12/30 By huangtao 料號未作轉換之前就做判斷
# Modify.........: No.MOD-AC0381 11/01/05 By Smapmin 複製時,oebi_file的資料無法完全複製
# Modify.........: No:CHI-AC0036 11/01/06 By Smapmin 信用查核要納入送簽中的單據
# Modify.........: No:TQC-B10013 11/01/06 By shiwuying 
# Modify.........: No:FUN-B10010 11/01/06 By shenyang 右邊單價按鈕的畫面中顯示基礎單價;
# Modify.........: No:FUN-B10014 11/01/07 By shiwuying 零售才写rxc_file
# Modify.........: No:TQC-B10066 11/01/10 By shiwuying 现返栏位赋预设值
# Modify.........: No:MOD-B20074 11/02/17 By Summer 借貨出貨/借貨償價訂單,因為都不會有簽收流程,故改為-->單頭[出貨簽收]欄位default='N' 且設為noentry
# Modify.........: No:MOD-B20125 11/02/22 By lilingyu 新增一筆訂單資料,沒有正確產生多帳期資料
# Modify.........: No:FUN-A50013 11/03/07 By Lilan EF整合ICD
# Modify.........: No:TQC-B30088 11/03/09 By lilingyu ICD行業別的程式段,where條件有誤,導致執行axmt410_icd無法顯示單身
# Modify.........: No:MOD-B30116 11/03/11 By suncx 修正尾款金額為負數的BUG 
# Modify.........: No:MOD-B30131 11/03/11 By Summer 新增單頭時，oea07預設為N
# Modify.........: No:MOD-B30121 11/03/11 By baogc 控管資料來源項中的9.POS拋轉的顯示
# Modify.........: No:MOD-B30127 11/03/11 By lixia axmt410及axmt810流通零售時,oeacont 隱藏掉
# Modify.........: No:MOD-B30166 11/03/11 By Summer 非鞋服業不要顯示『二維輸入』 
# Modify.........: No:MOD-B30224 11/03/12 By suncx 增加合約轉訂單報錯信息
# Modify.........: No.MOD-B30347 11/03/14 By lixia 合約轉入時修改訂單日期時增加失效日期判斷
# Modify.........: No.MOD-B30466 11/03/14 By chenying 修改合約轉入時,單身欄位[轉入項次]報錯信息的判斷
# Modify.........: No.MOD-B30297 11/03/14 By chenying Action'更改單價'修改完單身單價後，也要重算單頭訂金/出貨/尾款金額
# Modify.........: No.MOD-B30440 11/03/15 By Summer 控卡已產生至一般訂單的合約訂單不可取消確認 
# Modify.........: No.MOD-B30404 11/03/15 By Summer 於AFTER INPUT段再做一次axm-987的控卡,若是匯率小於等於0就NEXT FIELD幣別 
# Modify.........: No.MOD-B30428 11/03/15 By chenying 訂單Action[修改價格]修改
# Modify.........: No.MOD-B30443 11/03/16 By baogc 修改取价函数的调用
# Modify.........: No.FUN-B30012 11/03/16 By huangtao 促銷贈品發放和退還邏輯調整
# Modify.........: No:MOD-B30277 11/03/17 By Summer oea00 MATCHES '[123467]'時開窗出來的資料要加上ima130 <> '0' 
# Modify.........: No:MOD-B30451 11/03/17 By Summer 在自動產生單身時,判斷若是分量計價的狀況,給一個提示訊息 
# Modify.........: No:MOD-B30616 11/03/20 By lilingyu 單頭選擇CKD/SKD時然後選擇SKD單階展開,報錯
# Modify.........: No:CHI-B30081 11/03/22 By Smapmin 從報價單將地址預先帶入訂單

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30085 12/07/03 By nanbing CR改串GR

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/saxmt400.global"

DEFINE  g_multi_ima01  STRING     #  No.FUN-A80121 

FUNCTION t400(p_argv1,p_oea901,p_argv2,p_argv3)
   DEFINE p_argv1      LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)   # 0.合約 1.訂單/換貨訂單
   DEFINE p_oea901     LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)   # 多角貿易否 No.7946
   DEFINE p_argv2      LIKE oea_file.oea01 #No.FUN-640024
   DEFINE p_argv3      STRING              #No.FUN-640024

   WHENEVER ERROR CONTINUE   #CHI-9A0052

    LET g_wc2=' 1=1'
    LET g_wc3=' 1=1'
    LET g_wc4=' 1=1' #FUN-6C0006

    LET g_sql = "l_gen02.gen_file.gen02,",
                "l_gem02.gem_file.gem02,",
                "oea00.oea_file.oea00,",
                "oea01.oea_file.oea01,",
                "oea02.oea_file.oea02,",
                "oea03.oea_file.oea03,",
                "oea032.oea_file.oea032,",
                "oea14.oea_file.oea14,",
                "oea15.oea_file.oea15,",
                "oea25.oea_file.oea25,",
                "oea23.oea_file.oea23,",
                "oea61.oea_file.oea61,",
                "oea1006.oea_file.oea1006,",
               # "l_tax.ima_file.ima26,", # FUN-A20044
                "l_tax.type_file.num15_3,", # FUN-A20044
               # "l_tax1.ima_file.ima26,", # FUN-A20044
                "l_tax1.type_file.num15_3,", # FUN-A20044
               # "l_tot.ima_file.ima26,",  # FUN-A20044
                "l_tot.type_file.num15_3,",  # FUN-A20044
                "t_azi04.azi_file.azi04"
    LET l_table = cl_prt_temptable('axmt420',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-C30085 add
       EXIT PROGRAM
    END IF                  # Temp Table產生
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,                         ?, ?, ?, ?, ?, ?, ?)"
   PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-C30085 add
       EXIT PROGRAM
    END IF
##-MOD-B30121 -ADD --BEGIN--
   LET cb = ui.ComboBox.forName("oea11")
   IF (g_aza.aza88 <> 'Y') THEN
      CALL cb.removeItem('9')
   END IF
##-MOD-B30121 -ADD ---END---

   #No.FUN-A90040  begin--  
   IF (g_azw.azw04 <> '2') THEN 
       CALL cl_set_comp_visible("oeb49,oeb50",FALSE)
    ELSE
       CALL cl_set_comp_visible("oeb49,oeb50",TRUE)
   END IF
   #No.FUN-A90040  end--  
   
#TQC-AA0101 --begin--
   IF g_azw.azw04 <> '2' THEN 
      CALL cl_set_act_visible("detail_tax,kefa,cancel_price,discount_detail",FALSE)
   ELSE
   	  CALL cl_set_act_visible("detail_tax,kefa,cancel_price,discount_detail",TRUE)  
   END IF 
#TQC-AA0101 --end--
#FUN-AB0039 --Begin--
  #IF p_argv1 = '1'  THEN                      #FUN-AB0096
   IF p_argv1 = '1' AND g_azw.azw04 = '2' THEN #FUN-AB0096
      CALL cl_set_act_visible("detail_tax",TRUE)
   ELSE
      CALL cl_set_act_visible("detail_tax",FALSE)
   END IF
#FUN-AB0039 --End----
#MOD-B30127--add--str--
   IF p_argv1 = '1' AND g_azw.azw04 <> '2' THEN 
      CALL cl_set_comp_visible("oeacont",FALSE)
   END IF
#MOD-B30127--add--end--
    
    LET g_oea901 = p_oea901          #No.7946

    IF g_oea901 = 'Y' THEN
        CALL cl_set_comp_visible("oea65",FALSE)
    ELSE
        CALL cl_set_comp_visible("oea65",TRUE)
    END IF
    IF g_prog != 'axmt410' OR g_aza.aza50 = 'N' THEN
        CALL cl_set_comp_visible("oeb935,oeb936,oeb937",FALSE)
    END IF
    #CALL cl_set_comp_visible("oea917,oeaslk02",FALSE)  #FUN-A50054 add oeaslk02  #FUN-A60035 ---MARK
    CALL cl_set_comp_visible("oea917",FALSE) 
#MOD-B30166 mark --start--
#&ifndef ICD
#    IF g_sma.sma120 NOT MATCHES '[Yy]' OR g_sma.sma115 MATCHES '[Yy]' THEN
#        CALL cl_set_comp_visible("oea917",FALSE)
#    ELSE
#        CALL cl_set_comp_visible("oea917",TRUE)
#    END IF
#&endif
#MOD-B30166 mark --end--
#FUN-A60035 ---ADD BEGIN   #二維功能mark后 款式明細欄位去掉
    CALL cl_set_comp_required("oeaslk02",FALSE)
    CALL cl_set_comp_visible("oeaslk02",FALSE)
#FUN-A60035 ---ADD END
    CALL cl_set_comp_visible("grhide",g_azw.azw04='2')
    CALL cl_set_comp_visible("oeb44,oeb45,oeb46,oeb47,oeb48",g_azw.azw04='2')
    CALL cl_set_comp_visible("oea94",g_aza.aza88 = 'Y')                          #FUN-A50071 add
    CALL cl_set_act_visible("carry_po",g_azw.azw04<>'2')
    CALL cl_set_act_visible("pay_money,money_detail,modify_rate",g_azw.azw04='2') #FUN-9C0083
#   CALL cl_set_act_visible("discount_detail",g_prog='axmt410')       #FUN-A10110 ADD  #TQC-AA0101 mark
    
    CALL cl_set_comp_visible("oeb918",g_sma.sma541='Y')   #FUN-A80054
    LET g_forupd_sql = "SELECT * FROM oea_file WHERE oea01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t400_cl CURSOR FROM g_forupd_sql
    LET g_argv1 = p_argv1
    LET g_argv2 = p_argv2            #No.FUN-640024
    LET g_argv3 = p_argv3            #No.FUN-640024

    CALL t400_init() #FUN-710037


      LET g_action_choice = ""

     IF NOT cl_null(g_argv2) THEN
        CASE g_argv3
           WHEN "query"
              LET g_action_choice = "query"
              IF cl_chk_act_auth() THEN
                 CALL t400_q()
              END IF
           WHEN "insert"
              LET g_action_choice = "insert"
              IF cl_chk_act_auth() THEN
                 CALL t400_a()
              END IF
           WHEN "efconfirm"
              CALL t400_q()
              CALL t400sub_y_chk('1',g_oea.oea01)         #CALL 原確認的 check 段  #FUN-730012 #FUN-740034
              IF g_success = "Y" THEN
                 CALL t400sub_y_upd(g_oea.oea01,'efconfirm')       #CALL 原確認的 update 段 #FUN-730012   #FUN-740034
              END IF
              CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-C30085 add
              EXIT PROGRAM
           OTHERWISE
              CALL t400_q()
        END CASE
     END IF

      #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
      CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale, void, confirm, undo_confirm, easyflow_approval, csd_data, expense_data, on_hold, undo_on_hold, change_status, restore, carry_pr,carry_po, mul_trade, mul_trade_other, allocate, undo_distribution, modify_price, modify_rate, pref, discount_allowed, deposit_multi_account, balance_multi_account, new_code_application, product_inf") ##TQC-5B0117   #FUN-6C0050 add carry_po #TQC-740127  #TQC-740281  #FUN-A50013
           RETURNING g_laststage
    CALL t400_menu()

END FUNCTION

FUNCTION t400_cs()
DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE  l_i             LIKE type_file.num5    #FUN-610055  #No.FUN-680137 SMALLINT
DEFINE  l_oea11         LIKE oea_file.oea11       #No.FUN-630013
DEFINE cb ui.ComboBox                          #TQC-A30155
DEFINE  aza26           LIKE aza_file.aza26    #TQC-A30155
DEFINE  l_msg           STRING                 #TQC-A30155

    CLEAR FORM                       #清除畫面
    CALL g_oeb.clear()
    CALL g_oeb1.clear()

#start TQC-A30155
   LET cb = ui.ComboBox.forName("oea212")
   IF g_aza.aza26 = '2' THEN
      LET l_msg=cl_getmsg('axm-397',g_lang)
      LET l_msg="A:",l_msg CLIPPED
      CALL cb.addItem('A', l_msg)

      LET l_msg=cl_getmsg('axm-398',g_lang)
      LET l_msg="B:",l_msg CLIPPED
      CALL cb.addItem('B', l_msg)

 #    LET l_msg=cl_getmsg('axm-399',g_lang)      #TQC-A40142
      LET l_msg=cl_getmsg('axm-400',g_lang)      #TQC-A40142
      LET l_msg="C:",l_msg CLIPPED
      CALL cb.addItem('C', l_msg)
   END IF
#end   TQC-A30155

    IF NOT cl_null(g_argv2) THEN
       LET g_wc = " oea01 = '",g_argv2,"'"
       LET g_wc2 = " 1=1"
       LET g_wc3 = " 1=1"
       LET g_wc4 = " 1=1" #FUN-6C0006
    ELSE
       WHILE TRUE
          CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
          INITIALIZE g_oea.* TO NULL      #No.FUN-750051
       #No.FUN-A40055--begin
#          CONSTRUCT BY NAME g_wc ON      # 螢幕上取單頭條件
#             oea00,oea08,oea01,oea06,oea02,oea11,oea12,oea03,oea032,
#             oea04,oea17,oea1004,oea1015,oea14,oea15,oea1002,oea1009,
#             oea1003,oea917,
#&ifdef SLK
#             oeaslk01,    #FUN-870117 add oeaslk01
#&endif
#             oea10,oea23,oea24,oea21,oea211,oea212,oea213,  #FUN-820046 add oea917
#             oea31,oea32,oea37,oea50,oeamksg,oea1005,oeahold,oeaconf,oeacont,oea49, #No.FUN-870007-add-oeacont
#             oea044,oea41,oea42,oea43,oea44,oea33,oea09,oea1012,oea1013,
#             oea1014,oea161,oea162,oea163,oea1011,oea1010,oea05,oea18,
#             oea07,oea62,oea63,oea65,                          #No.FUN-870007
#             oea83,oea84,oea85,oea86,oea87,oeaplant,oeaconu,   #No.FUN-870007
#             oea88,oea89,oea90,oea91,oea92,oea93,              #No.FUN-870007
#             oea25,oea26,oea46,oea80,oea81,oea47,oea48,        #No.FUN-870007
#             oea905,oea99,oea61,oeauser,oeagrup,oeamodu,oeadate,
#             oeaoriu,oeaorig,                                  #TQC-A30041 ADD
#             oeaud01,oeaud02,oeaud03,oeaud04,oeaud05,
#             oeaud06,oeaud07,oeaud08,oeaud09,oeaud10,
#             oeaud11,oeaud12,oeaud13,oeaud14,oeaud15,
#             oea918,oea919      #FUN-8C0078
#
#               BEFORE CONSTRUCT
#                  CALL cl_qbe_init()
#
#               AFTER FIELD oea11
#                  LET l_oea11 = GET_FLDBUF(oea11)
#
#             ON ACTION controlp
#                CASE
#                   WHEN INFIELD(oea01) #查詢單据
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_oea11"   #MOD-4A0252
#                        IF g_argv1='0' THEN
#                           LET g_qryparam.where = " oea00 = '0' "
#                        END IF
#                        IF g_argv1='1' THEN
#			   LET g_qryparam.where = " oea00 MATCHES '[123467]' AND oea901 = '",g_oea901,"' "
#                        END IF
#                        IF g_argv1='2' THEN
#                           LET g_qryparam.where = " oea00 MATCHES '[89]' "
#                        END IF
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea01
#                        NEXT FIELD oea01
#                   WHEN INFIELD(oea12)
#                      CASE l_oea11
#                         WHEN '2'
#                            CALL cl_init_qry_var()
#                            LET g_qryparam.state = "c"
#                            LET g_qryparam.form ="q_oha"
#                            CALL cl_create_qry() RETURNING g_qryparam.multiret
#                            DISPLAY g_qryparam.multiret TO oea12
#                         WHEN '3'
#                            CALL cl_init_qry_var()
#                            LET g_qryparam.state = "c"
#                            LET g_qryparam.form ="q_oea2"
#                            CALL cl_create_qry() RETURNING g_qryparam.multiret
#                            DISPLAY g_qryparam.multiret TO oea12
#                         WHEN '4'
#                            CALL cl_init_qry_var()
#                            LET g_qryparam.state = "c"
#                            LET g_qryparam.form ="q_oqa"
#                            CALL cl_create_qry() RETURNING g_qryparam.multiret
#                            DISPLAY g_qryparam.multiret TO oea12
#                         WHEN '5'
#                            CALL cl_init_qry_var()
#                            LET g_qryparam.state = "c"
#                            LET g_qryparam.form ="q_oqt"
#                            CALL cl_create_qry() RETURNING g_qryparam.multiret
#                            DISPLAY g_qryparam.multiret TO oea12
#                         WHEN '7'
#                            CALL cl_init_qry_var()
#                            LET g_qryparam.state = "c"
#                            LET g_qryparam.form ="q_oga"
#                            CALL cl_create_qry() RETURNING g_qryparam.multiret
#                            DISPLAY g_qryparam.multiret TO oea12
#                         OTHERWISE EXIT CASE
#                      END CASE
#
#                   WHEN INFIELD(oea1015)
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.state = "c"
#                      LET g_qryparam.form ="q_pmc8"
#                      LET g_qryparam.default1 = g_oea.oea1015
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO oea1015
#                      NEXT FIELD oea1015
#                   WHEN INFIELD(oea03)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        #-----MOD-A30026---------
#                        #LET g_qryparam.form ="q_occ3"   
#                        IF g_aza.aza50='Y' THEN  
#                           LET g_qryparam.form ="q_occ3" 
#                        ELSE 
#                           LET g_qryparam.form ="q_occ"  
#                        END IF   
#                        #-----END MOD-A30026-----
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea03
#                        NEXT FIELD oea03
#                   WHEN INFIELD(oea04)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        IF g_aza.aza50='Y' THEN
#                           LET g_qryparam.form ="q_occ4"    #FUN-610055
#                        ELSE
#                           LET g_qryparam.form ="q_occ"  #No.FUN-650108
#                        END IF
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea04
#                        NEXT FIELD oea04
#                   WHEN INFIELD(oea14)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_gen"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea14
#                        NEXT FIELD oea14
#                   WHEN INFIELD(oea15)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_gem"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea15
#                        NEXT FIELD oea15
#                   WHEN INFIELD(oea1011)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_occ7"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea1011
#                        NEXT FIELD oea1011
#                   WHEN INFIELD(oea17)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        IF g_aza.aza50='Y' THEN
#                           LET g_qryparam.form ="q_occ6"
#                        ELSE
#                           LET g_qryparam.form ="q_occ"  #No.FUN-650108
#                        END IF
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea17
#                        NEXT FIELD oea17
#                   WHEN INFIELD(oea1002)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_tqa1"
#                        LET g_qryparam.arg1 ='20'
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea1002
#                        NEXT FIELD oea1002
#                   WHEN INFIELD(oea1003)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_tqb"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea1003
#                        NEXT FIELD oea1003
#                   WHEN INFIELD(oea1004)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_occ5"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea1004
#                        NEXT FIELD oea1004
#                   WHEN INFIELD(oea1009)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_tqa1"
#                        LET g_qryparam.arg1 ='19'
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea1009
#                        NEXT FIELD oea1009
#                   WHEN INFIELD(oea1010)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_tqb"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea1010
#                        NEXT FIELD oea1010
#                   WHEN INFIELD(oea21)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_gec"
#                        LET g_qryparam.arg1 = '2'
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea21
#                        NEXT FIELD oea21
#                   WHEN INFIELD(oea23)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_azi"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea23
#                        NEXT FIELD oea23
#                   WHEN INFIELD(oea25)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_oab"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea25
#                        NEXT FIELD oea25
#                   WHEN INFIELD(oea26)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_oab"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea26
#                        NEXT FIELD oea26
#                   WHEN INFIELD(oea31)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_oah"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea31
#                        NEXT FIELD oea31
#                   WHEN INFIELD(oea32)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_oag"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea32
#                        NEXT FIELD oea32
#                   WHEN INFIELD(oea044)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_ocd"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea044
#                   WHEN INFIELD(oea41)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_oac"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea41
#                   WHEN INFIELD(oea42)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_oac"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea42
#                   WHEN INFIELD(oea43)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_ged"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea43
#                   WHEN INFIELD(oea44)    #MOD-4A0252
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form = "q_ocf"   # MOD-580085
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea44
#                   WHEN INFIELD(oea46)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_pja2"  #FUN-810045
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea46
#                   WHEN INFIELD(oea47)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form = "q_pmc4"
#                        LET g_qryparam.arg1 = '4'
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea47
#                   WHEN INFIELD(oea48)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form = "q_ofs"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea48
#                   WHEN INFIELD(oeahold)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_oak1"
#                        LET g_qryparam.default1= g_oea.oeahold
#                        LET g_qryparam.arg1 ='1'
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oeahold
#                        NEXT FIELD oeahold
#                   WHEN INFIELD(oea80)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_oag"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea80
#                        NEXT FIELD oea80
#                   WHEN INFIELD(oea81)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_oag"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea81
#                        NEXT FIELD oea81
#&ifdef SLK
#                   WHEN INFIELD(oeaslk01)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_geb"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oeaslk01
#                        NEXT FIELD oeaslk01
#&endif
#                   WHEN INFIELD(oea83)
#                         CALL cl_init_qry_var()
#                         LET g_qryparam.state = "c"
#                         LET g_qryparam.form ="q_oea83"
#                         CALL cl_create_qry() RETURNING g_qryparam.multiret
#                         DISPLAY g_qryparam.multiret TO oea83
#                         NEXT FIELD oea83
#                   WHEN INFIELD(oea84)
#                         CALL cl_init_qry_var()
#                         LET g_qryparam.state = "c"
#                         LET g_qryparam.form ="q_oea84"
#                         CALL cl_create_qry() RETURNING g_qryparam.multiret
#                         DISPLAY g_qryparam.multiret TO oea84
#                         NEXT FIELD oea84
#                   WHEN INFIELD(oea86)
#                         CALL cl_init_qry_var()
#                         LET g_qryparam.state = "c"
#                         LET g_qryparam.form ="q_oea86"
#                         CALL cl_create_qry() RETURNING g_qryparam.multiret
#                         DISPLAY g_qryparam.multiret TO oea86
#                         NEXT FIELD oea86
#                   WHEN INFIELD(oeaconu)
#                         CALL cl_init_qry_var()
#                         LET g_qryparam.state = "c"
#                         LET g_qryparam.form ="q_oeaconu"
#                         CALL cl_create_qry() RETURNING g_qryparam.multiret
#                         DISPLAY g_qryparam.multiret TO oeaconu
#                         NEXT FIELD oeaconu
#                   WHEN INFIELD(oeaplant)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_azp"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oeaplant
#                        NEXT FIELD oeaplant
#                   WHEN INFIELD(oeaud02)
#                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO oeaud02
#                      NEXT FIELD oeaud02
#                   WHEN INFIELD(oeaud03)
#                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO oeaud03
#                      NEXT FIELD oeaud03
#                   WHEN INFIELD(oeaud04)
#                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO oeaud04
#                      NEXT FIELD oeaud04
#                   WHEN INFIELD(oeaud05)
#                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO oeaud05
#                      NEXT FIELD oeaud05
#                   WHEN INFIELD(oeaud06)
#                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO oeaud06
#                      NEXT FIELD oeaud06
#                END CASE
#
#             ON IDLE g_idle_seconds
#                CALL cl_on_idle()
#                CONTINUE CONSTRUCT
#
#             ON ACTION about         #MOD-4C0121
#                CALL cl_about()      #MOD-4C0121
#
#             ON ACTION help          #MOD-4C0121
#                CALL cl_show_help()  #MOD-4C0121
#
#             ON ACTION controlg      #MOD-4C0121
#                CALL cl_cmdask()     #MOD-4C0121
#
#                 ON ACTION qbe_select
#		   CALL cl_qbe_list() RETURNING lc_qbe_sn
#		   CALL cl_qbe_display_condition(lc_qbe_sn)
#          END CONSTRUCT
#
#          IF INT_FLAG THEN RETURN END IF
#          EXIT WHILE
#       END WHILE
#
#       CONSTRUCT g_wc2 ON
#           oeb03,
#&ifdef SLK
#           oebislk01,    #No.FUN-810016
#&endif
#           oeb04,oeb06,oeb11,oeb1001,oeb1012,oeb906,oeb092,
#           oeb15,oeb30,oeb31,oeb05,oeb12,  #No.FUN-5C0076     #No.FUN-740016
#           oeb913,oeb914,oeb915,oeb910,oeb911,oeb912,
#           oeb916,oeb917,oeb29,oeb24,oeb25,oeb27,oeb28,oeb1004,oeb1002,   # 螢幕上取單身條件  #NO.FUN-670007   #No.FUN-740016
#           oeb13,oeb1006,oeb14,oeb14t,oeb41,oeb42,oeb43,oeb09,oeb091,    #FUN-810045 add oeb41,42,43
#           oeb930,oeb908,oeb22,oeb19,oeb70,oeb16  #FUN-670063 #FUN-6B0151 add oeb16
#&ifdef ICD
#           ,oebiicd01,oebiicd03,oebiicd05,oebiicd07  #No.FUN-7C0017
#&endif
#           ,oebud01,oebud02,oebud03,oebud04,oebud05
#           ,oebud06,oebud07,oebud08,oebud09,oebud10
#           ,oebud11,oebud12,oebud13,oebud14,oebud15
#           ,oeb44,oeb45,oeb46,oeb47,oeb48          #No.FUN-870007
#       FROM
#           s_oeb[1].oeb03,                           #No.FUN-7C0017
#&ifdef SLK
#           s_oeb[1].oebislk01,     #No.FUN-810016
#&endif
#           s_oeb[1].oeb04,s_oeb[1].oeb06,
#           s_oeb[1].oeb11,s_oeb[1].oeb1001,s_oeb[1].oeb1012,s_oeb[1].oeb906,s_oeb[1].oeb092,
#           s_oeb[1].oeb15,s_oeb[1].oeb30,s_oeb[1].oeb31,s_oeb[1].oeb05,s_oeb[1].oeb12,    #No.FUN-5C0076   #No.FUN-740016
#           s_oeb[1].oeb913,s_oeb[1].oeb914,s_oeb[1].oeb915,
#           s_oeb[1].oeb910,s_oeb[1].oeb911,s_oeb[1].oeb912,
#           s_oeb[1].oeb916,s_oeb[1].oeb917,s_oeb[1].oeb29,s_oeb[1].oeb24,s_oeb[1].oeb25,   #No.FUN-740016
#           s_oeb[1].oeb27,s_oeb[1].oeb28,       #NO.FUN-670007 add
#           s_oeb[1].oeb1004,s_oeb[1].oeb1002,
#           s_oeb[1].oeb13,s_oeb[1].oeb1006,
#           s_oeb[1].oeb14,s_oeb[1].oeb14t,
#           s_oeb[1].oeb41,s_oeb[1].oeb42,s_oeb[1].oeb43,  #FUN-810045
#           s_oeb[1].oeb09,s_oeb[1].oeb091,s_oeb[1].oeb930,s_oeb[1].oeb908,  #FUN-670063
#           s_oeb[1].oeb22,s_oeb[1].oeb19,s_oeb[1].oeb70,s_oeb[1].oeb16  #FUN-6B0151 add oeb16
#&ifdef ICD
#          ,s_oeb[1].oebiicd01,s_oeb[1].oebiicd03,s_oeb[1].oebiicd05,s_oeb[1].oebiicd07  #No.FUN-7C0017
#&endif
#           ,s_oeb[1].oebud01,s_oeb[1].oebud02,s_oeb[1].oebud03,s_oeb[1].oebud04,s_oeb[1].oebud05
#           ,s_oeb[1].oebud06,s_oeb[1].oebud07,s_oeb[1].oebud08,s_oeb[1].oebud09,s_oeb[1].oebud10
#           ,s_oeb[1].oebud11,s_oeb[1].oebud12,s_oeb[1].oebud13,s_oeb[1].oebud14,s_oeb[1].oebud15
#           ,s_oeb[1].oeb44,s_oeb[1].oeb45,s_oeb[1].oeb46,s_oeb[1].oeb47,s_oeb[1].oeb48   #No.FUN-870007
#
#		BEFORE CONSTRUCT
#		   CALL cl_qbe_display_condition(lc_qbe_sn)
#          ON ACTION controlp
#             CASE
#&ifdef SLK
#                WHEN INFIELD(oebislk01)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form  = "q_skd01"
#                   LET g_qryparam.state = "c"   #多選
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oebislk01
#                   NEXT FIELD oebislk01
#&endif
#                WHEN INFIELD(oeb1001)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                      LET g_qryparam.form ="q_azf03" #TQC-7C0098
#                      LET g_qryparam.arg1 = "2"   #No.FUN-660073
#                      LET g_qryparam.arg2 = "1"   #No.TQC-7C0098
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oeb1001
#                   NEXT FIELD oeb1001
#                WHEN INFIELD(oeb31)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_azf1"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oeb31
#                   NEXT FIELD oeb31
#                WHEN INFIELD(oeb04)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   IF g_aza.aza50='Y' THEN
#                      LET g_qryparam.form ="q_ima15"   #FUN-610055
#                   ELSE
#                      LET g_qryparam.form ="q_ima"   #FUN-610055
#                   END IF
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oeb04
#                   NEXT FIELD oeb04
#
#                WHEN INFIELD(oeb05)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_gfe"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oeb05
#                   NEXT FIELD oeb05
#
#                WHEN INFIELD(oeb908)
#                   CALL q_coc2(TRUE,TRUE,g_oeb[1].oeb908,'',g_oea.oea02,'0',
#                               '',g_oeb[1].oeb04)
#                   RETURNING g_oeb[1].oeb908
#                   DISPLAY BY NAME g_oeb[1].oeb908
#                   NEXT FIELD oeb908
#                WHEN INFIELD(oeb913)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_gfe"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oeb913
#                   NEXT FIELD oeb913
#
#                WHEN INFIELD(oeb910)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_gfe"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oeb910
#                   NEXT FIELD oeb910
#
#                WHEN INFIELD(oeb916)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_gfe"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oeb916
#                   NEXT FIELD oeb916
#                WHEN INFIELD(oeb1004)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_tqx3"  #TQC-7C0098
#                   LET g_qryparam.arg1 = g_oea.oea23  #TQC-7C0098
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oeb1004
#                   NEXT FIELD oeb1004
#                WHEN INFIELD(oeb41) #專案
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form ="q_pja2"
#                  LET g_qryparam.state = "c"   #多選
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO oeb41
#                  NEXT FIELD oeb41
#                WHEN INFIELD(oeb42)  #WBS
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form ="q_pjb4"
#                  LET g_qryparam.state = "c"   #多選
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO oeb42
#                  NEXT FIELD oeb42
#                WHEN INFIELD(oeb43)  #活動
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form ="q_pjk3"
#                  LET g_qryparam.state = "c"   #多選
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO oeb43
#                  NEXT FIELD oeb43
#
#                WHEN INFIELD(oeb09)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_imd01"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oeb09
#                   NEXT FIELD oeb09
#                WHEN INFIELD(oeb091)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_ime"
#                   LET g_qryparam.arg1 = g_oeb[1].oeb09
#                   LET g_qryparam.arg2 = 'SW'
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oeb091
#                   NEXT FIELD oeb091
#                WHEN INFIELD(oeb930)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form  = "q_gem4"
#                   LET g_qryparam.state = "c"   #多選
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oeb930
#                   NEXT FIELD oeb930
#&ifdef ICD
#                WHEN INFIELD(oebiicd01)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = 'c'
#                   LET g_qryparam.form = "q_imaicd00"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oebiicd01
#                   NEXT FIELD oebiicd01
#
#                WHEN INFIELD(oebiicd07)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = 'c'
#                   LET g_qryparam.form = "q_icd3"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oebiicd07
#                   NEXT FIELD oebiicd07
#&endif
#                WHEN INFIELD(oebud02)
#                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oebud02
#                   NEXT FIELD oebud02
#                WHEN INFIELD(oebud03)
#                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oebud03
#                   NEXT FIELD oebud03
#                WHEN INFIELD(oebud04)
#                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oebud04
#                   NEXT FIELD oebud04
#                WHEN INFIELD(oebud05)
#                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oebud05
#                   NEXT FIELD oebud05
#                WHEN INFIELD(oebud06)
#                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oebud06
#                   NEXT FIELD oebud06
#
#                OTHERWISE
#             END CASE
#
#          ON IDLE g_idle_seconds
#             CALL cl_on_idle()
#             CONTINUE CONSTRUCT
#
#          ON ACTION about         #MOD-4C0121
#             CALL cl_about()      #MOD-4C0121
#
#          ON ACTION help          #MOD-4C0121
#             CALL cl_show_help()  #MOD-4C0121
#
#          ON ACTION controlg      #MOD-4C0121
#             CALL cl_cmdask()     #MOD-4C0121
#
#              ON ACTION qbe_save
#                 CALL cl_qbe_save()
#
#       END CONSTRUCT

#       IF INT_FLAG THEN RETURN END IF #FUN-720009
#
#       IF g_aza.aza50='Y' THEN
#          CONSTRUCT g_wc3 ON oeb03_1,oeb1007,oeb1008,oeb1009,oeb1010,
#                             oeb1011,oeb1001_1,oeb14_1,oeb14t_1
#                  FROM s_oeb1[1].oeb03_1,s_oeb1[1].oeb1007,s_oeb1[1].oeb1008,
#                       s_oeb1[1].oeb1009,s_oeb1[1].oeb1010,
#                       s_oeb1[1].oeb1011,s_oeb1[1].oeb1001_1,
#                       s_oeb1[1].oeb14_1,s_oeb1[1].oeb14t_1
#
#   		          BEFORE CONSTRUCT
#   		             CALL cl_qbe_display_condition(lc_qbe_sn)
#                ON ACTION controlp
#                   CASE
#                      WHEN INFIELD(oeb1007)
#                         CALL cl_init_qry_var()
#                         LET g_qryparam.state = "c"
#                         LET g_qryparam.form ="q_tqw2"      #No.FUN-820033
#                         CALL cl_create_qry() RETURNING g_qryparam.multiret
#                         DISPLAY g_qryparam.multiret TO oeb1007
#                         NEXT FIELD oeb1007
#                      OTHERWISE
#                   END CASE
#
#                ON IDLE g_idle_seconds
#                   CALL cl_on_idle()
#                   CONTINUE CONSTRUCT
#
#                ON ACTION about         #MOD-4C0121
#                   CALL cl_about()      #MOD-4C0121
#
#                ON ACTION help          #MOD-4C0121
#                   CALL cl_show_help()  #MOD-4C0121
#
#                ON ACTION controlg      #MOD-4C0121
#                   CALL cl_cmdask()     #MOD-4C0121
#
#   		          ON ACTION qbe_save
#   		             CALL cl_qbe_save()
#             END CONSTRUCT
#
#          IF INT_FLAG THEN RETURN END IF #FUN-720009
#       END IF
#    END IF   #FUN-580155
#####
       IF g_aza.aza50='N' THEN
          DIALOG ATTRIBUTES(UNBUFFERED)
          CONSTRUCT BY NAME g_wc ON      # 螢幕上取單頭條件
             oea00,oea08,oea01,oea06,oea02,oea11,oea12,oea03,oea032,
             oea04,oea17,oea1004,oea1015,oea14,oea15,oea1002,oea1009,
             oea1003,oea917,
             oea10,oea23,oea24,oea21,oea211,oea212,oea213,  #FUN-820046 add oea917
             oea31,oea32,oea37,oea50,oeamksg,oea1005,oeahold,oeaconf,oeacont,oea49, #No.FUN-870007-add-oeacont
             oea044,oea41,oea42,oea43,oea44,oea33,oea09,oea1012,oea1013,
             oea1014,oea161,oea261,oea162,oea262,oea163,oea263,oea1011,oea1010,oea05,oea18,     #No:FUN-A50103
             oea07,oea62,oea63,oea65,                          #No.FUN-870007
             oea83,oea84,oea85,oea86,oea87,oeaplant,oeaconu,   #No.FUN-870007
             oea88,oea89,oea90,oea91,oea92,oea93,oea94,        #No.FUN-870007   #FUN-A50071 add oea94
             oea25,oea26,oea46,oea80,oea81,oea47,oea48,        #No.FUN-870007
             oea905,oea99,oea61,oeauser,oeagrup,oeamodu,oeadate,
             oeaoriu,oeaorig,                                  #TQC-A30041 ADD
             oeaud01,oeaud02,oeaud03,oeaud04,oeaud05,
             oeaud06,oeaud07,oeaud08,oeaud09,oeaud10,
             oeaud11,oeaud12,oeaud13,oeaud14,oeaud15    #No:FUN-A50103
#            oea918,oea919      #FUN-8C0078   #No:FUN-A50103 Mark

               BEFORE CONSTRUCT
                  CALL cl_qbe_init()

               AFTER FIELD oea11
                  LET l_oea11 = GET_FLDBUF(oea11)
          END CONSTRUCT 
          
          CONSTRUCT g_wc2 ON oeb03,
           oeb49,oeb50,oeb04,oeb06,oeb918,oeb11,oeb1001,oeb1012,oeb906,oeb092,  #FUN-A80054  #FUN-A90040
           oeb15,oeb32,oeb30,oeb31,oeb05,oeb12,  #No.FUN-5C0076     #No.FUN-740016  #No.FUN-A80024
           oeb913,oeb914,oeb915,oeb910,oeb911,oeb912,
           oeb916,oeb917,oeb29,oeb24,oeb25,oeb27,oeb28,oeb1004,oeb1002,   # 螢幕上取單身條件  #NO.FUN-670007   #No.FUN-740016
           oeb37,oeb13,oeb1006,oeb14,oeb14t,oeb919,oeb41,oeb42,oeb43,oeb09,oeb091,    #FUN-810045 add oeb41,42,43  ##FUN-A80102    #FUN-AB0061 add oeb37
           oeb930,oeb908,oeb22,oeb19,oeb70,oeb16  #FUN-670063 #FUN-6B0151 add oeb16
           ,oebud01,oebud02,oebud03,oebud04,oebud05
           ,oebud06,oebud07,oebud08,oebud09,oebud10
           ,oebud11,oebud12,oebud13,oebud14,oebud15
           ,oeb44,oeb45,oeb46,oeb47,oeb48          #No.FUN-870007
       FROM
           s_oeb[1].oeb03,                           #No.FUN-7C0017
           s_oeb[1].oeb49,s_oeb[1].oeb50,s_oeb[1].oeb04,s_oeb[1].oeb06,s_oeb[1].oeb918, #FUN-A80054  #FUN-A90040
           s_oeb[1].oeb11,s_oeb[1].oeb1001,s_oeb[1].oeb1012,s_oeb[1].oeb906,s_oeb[1].oeb092,
           s_oeb[1].oeb15,s_oeb[1].oeb32,s_oeb[1].oeb30,s_oeb[1].oeb31,s_oeb[1].oeb05,s_oeb[1].oeb12,    #No.FUN-5C0076   #No.FUN-740016  #No.FUN-A80024
           s_oeb[1].oeb913,s_oeb[1].oeb914,s_oeb[1].oeb915,
           s_oeb[1].oeb910,s_oeb[1].oeb911,s_oeb[1].oeb912,
           s_oeb[1].oeb916,s_oeb[1].oeb917,s_oeb[1].oeb29,s_oeb[1].oeb24,s_oeb[1].oeb25,   #No.FUN-740016
           s_oeb[1].oeb27,s_oeb[1].oeb28,       #NO.FUN-670007 add
           s_oeb[1].oeb1004,s_oeb[1].oeb1002,
           s_oeb[1].oeb37,s_oeb[1].oeb13,s_oeb[1].oeb1006,  #FUN-AB0061 add s_oeb[1].oeb37 
           s_oeb[1].oeb14,s_oeb[1].oeb14t,s_oeb[1].oeb919,  #FUN-A80102
           s_oeb[1].oeb41,s_oeb[1].oeb42,s_oeb[1].oeb43,  #FUN-810045 
           s_oeb[1].oeb09,s_oeb[1].oeb091,s_oeb[1].oeb930,s_oeb[1].oeb908,  #FUN-670063
           s_oeb[1].oeb22,s_oeb[1].oeb19,s_oeb[1].oeb70,s_oeb[1].oeb16  #FUN-6B0151 add oeb16
           ,s_oeb[1].oebud01,s_oeb[1].oebud02,s_oeb[1].oebud03,s_oeb[1].oebud04,s_oeb[1].oebud05
           ,s_oeb[1].oebud06,s_oeb[1].oebud07,s_oeb[1].oebud08,s_oeb[1].oebud09,s_oeb[1].oebud10
           ,s_oeb[1].oebud11,s_oeb[1].oebud12,s_oeb[1].oebud13,s_oeb[1].oebud14,s_oeb[1].oebud15
           ,s_oeb[1].oeb44,s_oeb[1].oeb45,s_oeb[1].oeb46,s_oeb[1].oeb47,s_oeb[1].oeb48   #No.FUN-870007

	       	BEFORE CONSTRUCT
		        CALL cl_qbe_display_condition(lc_qbe_sn)     
	      	END CONSTRUCT 
		          
             ON ACTION controlp
                CASE
                   WHEN INFIELD(oea01) #查詢單据
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oea11"   #MOD-4A0252
                        IF g_argv1='0' THEN
                           LET g_qryparam.where = " oea00 = '0' "
                        END IF
                        IF g_argv1='1' THEN
			                     LET g_qryparam.where = " oea00 MATCHES '[123467]' AND oea901 = '",g_oea901,"' "
                        END IF
                        IF g_argv1='2' THEN
                           LET g_qryparam.where = " oea00 MATCHES '[89]' "
                        END IF
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea01
                        NEXT FIELD oea01
                   WHEN INFIELD(oea12)
                      CASE l_oea11
                         WHEN '2'
                            CALL cl_init_qry_var()
                            LET g_qryparam.state = "c"
                            LET g_qryparam.form ="q_oha"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO oea12
                         WHEN '3'
                            CALL cl_init_qry_var()
                            LET g_qryparam.state = "c"
                            LET g_qryparam.form ="q_oea2"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO oea12
                         WHEN '4'
                            CALL cl_init_qry_var()
                            LET g_qryparam.state = "c"
                            LET g_qryparam.form ="q_oqa"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO oea12
                         WHEN '5'
                            CALL cl_init_qry_var()
                            LET g_qryparam.state = "c"
                            LET g_qryparam.form ="q_oqt"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO oea12
                         WHEN '7'
                            CALL cl_init_qry_var()
                            LET g_qryparam.state = "c"
                            LET g_qryparam.form ="q_oga"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO oea12
                         OTHERWISE EXIT CASE
                      END CASE

                   WHEN INFIELD(oea1015)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_pmc8"
                      LET g_qryparam.default1 = g_oea.oea1015
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oea1015
                      NEXT FIELD oea1015
                   WHEN INFIELD(oea03)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        #-----MOD-A30026---------
                        #LET g_qryparam.form ="q_occ3"   
                        IF g_aza.aza50='Y' THEN  
                           LET g_qryparam.form ="q_occ3" 
                        ELSE 
                           LET g_qryparam.form ="q_occ"  
                        END IF   
                        #-----END MOD-A30026-----
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea03
                        NEXT FIELD oea03
                   WHEN INFIELD(oea04)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        IF g_aza.aza50='Y' THEN
                           LET g_qryparam.form ="q_occ4"    #FUN-610055
                        ELSE
                           LET g_qryparam.form ="q_occ"  #No.FUN-650108
                        END IF
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea04
                        NEXT FIELD oea04
                   WHEN INFIELD(oea14)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_gen"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea14
                        NEXT FIELD oea14
                   WHEN INFIELD(oea15)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_gem"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea15
                        NEXT FIELD oea15
                   WHEN INFIELD(oea1011)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_occ7"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea1011
                        NEXT FIELD oea1011
                   WHEN INFIELD(oea17)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        IF g_aza.aza50='Y' THEN
                           LET g_qryparam.form ="q_occ6"
                        ELSE
                           LET g_qryparam.form ="q_occ"  #No.FUN-650108
                        END IF
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea17
                        NEXT FIELD oea17
                   WHEN INFIELD(oea1002)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_tqa1"
                        LET g_qryparam.arg1 ='20'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea1002
                        NEXT FIELD oea1002
                   WHEN INFIELD(oea1003)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_tqb"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea1003
                        NEXT FIELD oea1003
                   WHEN INFIELD(oea1004)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_occ5"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea1004
                        NEXT FIELD oea1004
                   WHEN INFIELD(oea1009)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_tqa1"
                        LET g_qryparam.arg1 ='19'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea1009
                        NEXT FIELD oea1009
                   WHEN INFIELD(oea1010)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_tqb"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea1010
                        NEXT FIELD oea1010
                   WHEN INFIELD(oea21)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        IF g_aza.aza26 = '2' THEN         #TQC-A50060 --modify
                           LET g_qryparam.form ="q_gec9"  #TQC-A50060 --modify
                        ELSE                              #TQC-A50060 --modify
                        LET g_qryparam.form ="q_gec"
                        END IF                            #TQC-A50060 --modify
                        LET g_qryparam.arg1 = '2'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea21
                        NEXT FIELD oea21
                   WHEN INFIELD(oea23)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_azi"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea23
                        NEXT FIELD oea23
                   WHEN INFIELD(oea25)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oab"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea25
                        NEXT FIELD oea25
                   WHEN INFIELD(oea26)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oab"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea26
                        NEXT FIELD oea26
                   WHEN INFIELD(oea31)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oah"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea31
                        NEXT FIELD oea31
                   WHEN INFIELD(oea32)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oag"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea32
                        NEXT FIELD oea32
                   WHEN INFIELD(oea044)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_ocd"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea044
                   WHEN INFIELD(oea41)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oac"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea41
                   WHEN INFIELD(oea42)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oac"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea42
                   WHEN INFIELD(oea43)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_ged"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea43
                   WHEN INFIELD(oea44)    #MOD-4A0252
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form = "q_ocf"   # MOD-580085
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea44
                   WHEN INFIELD(oea46)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_pja2"  #FUN-810045
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea46
                   WHEN INFIELD(oea47)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form = "q_pmc4"
                        LET g_qryparam.arg1 = '4'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea47
                   WHEN INFIELD(oea48)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form = "q_ofs"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea48
                   WHEN INFIELD(oeahold)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oak1"
                        LET g_qryparam.default1= g_oea.oeahold
                        LET g_qryparam.arg1 ='1'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oeahold
                        NEXT FIELD oeahold
                   WHEN INFIELD(oea80)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oag"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea80
                        NEXT FIELD oea80
                   WHEN INFIELD(oea81)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oag"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea81
                        NEXT FIELD oea81
                   WHEN INFIELD(oea83)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = "c"
                         LET g_qryparam.form ="q_oea83"
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO oea83
                         NEXT FIELD oea83
                   WHEN INFIELD(oea84)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = "c"
                         LET g_qryparam.form ="q_oea84"
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO oea84
                         NEXT FIELD oea84
                   WHEN INFIELD(oea86)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = "c"
                         LET g_qryparam.form ="q_oea86"
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO oea86
                         NEXT FIELD oea86
                   WHEN INFIELD(oeaconu)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = "c"
                         LET g_qryparam.form ="q_oeaconu"
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO oeaconu
                         NEXT FIELD oeaconu
                   WHEN INFIELD(oeaplant)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_azp"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oeaplant
                        NEXT FIELD oeaplant
                   WHEN INFIELD(oeaud02)
                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oeaud02
                      NEXT FIELD oeaud02
                   WHEN INFIELD(oeaud03)
                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oeaud03
                      NEXT FIELD oeaud03
                   WHEN INFIELD(oeaud04)
                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oeaud04
                      NEXT FIELD oeaud04
                   WHEN INFIELD(oeaud05)
                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oeaud05
                      NEXT FIELD oeaud05
                   WHEN INFIELD(oeaud06)
                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oeaud06
                      NEXT FIELD oeaud06
##

  #No.FUN-A90040      begin--       
             WHEN INFIELD(oeb49)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_oeb49"  
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oeb49
                 NEXT FIELD oeb49
    #No.FUN-A90040      end-- 

                WHEN INFIELD(oeb1001)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_azf03" #TQC-7C0098
                      LET g_qryparam.arg1 = "2"   #No.FUN-660073
                      LET g_qryparam.arg2 = "1"   #No.TQC-7C0098
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb1001
                   NEXT FIELD oeb1001
                WHEN INFIELD(oeb31)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_azf1"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb31
                   NEXT FIELD oeb31
                WHEN INFIELD(oeb04)
         #No.FUN-A90048 -------------start-----------------------       
         #          CALL cl_init_qry_var()
         #          LET g_qryparam.state = "c"
         #          IF g_aza.aza50='Y' THEN
         #             LET g_qryparam.form ="q_ima15"   #FUN-610055
         #          ELSE
         #             LET g_qryparam.form ="q_ima"   #FUN-610055
         #          END IF
         #          CALL cl_create_qry() RETURNING g_qryparam.multiret
                   IF g_aza.aza50='Y' THEN
                      CALL q_sel_ima( TRUE, "q_ima15","","","","","","","",'') 
                              RETURNING  g_qryparam.multiret
                   ELSE
                      CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')
                              RETURNING  g_qryparam.multiret
                   END IF
          #No.FUN-A90048 -------------end -------------------------
                   DISPLAY g_qryparam.multiret TO oeb04
                   NEXT FIELD oeb04

                WHEN INFIELD(oeb05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb05
                   NEXT FIELD oeb05

                #FUN-A80054--begin--add----------
                WHEN INFIELD(oeb918)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_eda"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb918
                   NEXT FIELD oeb918
                #FUN-A80054--end--add------------

                WHEN INFIELD(oeb908)
                   CALL q_coc2(TRUE,TRUE,g_oeb[1].oeb908,'',g_oea.oea02,'0',
                               '',g_oeb[1].oeb04)
                   RETURNING g_oeb[1].oeb908
                   DISPLAY BY NAME g_oeb[1].oeb908
                   NEXT FIELD oeb908
                WHEN INFIELD(oeb913)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb913
                   NEXT FIELD oeb913

                WHEN INFIELD(oeb910)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb910
                   NEXT FIELD oeb910

                WHEN INFIELD(oeb916)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb916
                   NEXT FIELD oeb916
                WHEN INFIELD(oeb1004)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_tqx3"  #TQC-7C0098
                   LET g_qryparam.arg1 = g_oea.oea23  #TQC-7C0098
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb1004
                   NEXT FIELD oeb1004
                WHEN INFIELD(oeb41) #專案
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pja2"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb41
                  NEXT FIELD oeb41
                WHEN INFIELD(oeb42)  #WBS
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjb4"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb42
                  NEXT FIELD oeb42
                WHEN INFIELD(oeb43)  #活動
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjk3"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb43
                  NEXT FIELD oeb43
                WHEN INFIELD(oeb09)
                #No.FUN-AA0048  --Begin
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.state = "c"
                #  LET g_qryparam.form ="q_imd01"
                #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
                #No.FUN-AA0048  --End  
                   DISPLAY g_qryparam.multiret TO oeb09
                   NEXT FIELD oeb09
                WHEN INFIELD(oeb091)
                #No.FUN-AA0048  --Begin
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.state = "c"
                #  LET g_qryparam.form ="q_ime"
                #  LET g_qryparam.arg1 = g_oeb[1].oeb09
                #  LET g_qryparam.arg2 = 'SW'
                #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_ime_1(TRUE,TRUE,"","","","","","","") RETURNING g_qryparam.multiret
                #No.FUN-AA0048  --End  
                   DISPLAY g_qryparam.multiret TO oeb091
                   NEXT FIELD oeb091
                WHEN INFIELD(oeb930)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_gem4"
                   LET g_qryparam.state = "c"   #多選
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb930
                   NEXT FIELD oeb930
                WHEN INFIELD(oebud02)
                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oebud02
                   NEXT FIELD oebud02
                WHEN INFIELD(oebud03)
                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oebud03
                   NEXT FIELD oebud03
                WHEN INFIELD(oebud04)
                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oebud04
                   NEXT FIELD oebud04
                WHEN INFIELD(oebud05)
                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oebud05
                   NEXT FIELD oebud05
                WHEN INFIELD(oebud06)
                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oebud06
                   NEXT FIELD oebud06                      
                END CASE

             ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE DIALOG

             ON ACTION about         #MOD-4C0121
                CALL cl_about()      #MOD-4C0121

             ON ACTION help          #MOD-4C0121
                CALL cl_show_help()  #MOD-4C0121

             ON ACTION controlg      #MOD-4C0121
                CALL cl_cmdask()     #MOD-4C0121

             ON ACTION qbe_select
		            CALL cl_qbe_list() RETURNING lc_qbe_sn
	              CALL cl_qbe_display_condition(lc_qbe_sn)
	              
             ON ACTION accept
                EXIT DIALOG
       
             ON ACTION EXIT
                LET INT_FLAG = TRUE
                EXIT DIALOG 
                 
             ON ACTION cancel
                LET INT_FLAG = TRUE
                EXIT DIALOG          
            END DIALOG       
       ELSE 
          DIALOG ATTRIBUTES(UNBUFFERED)
          CONSTRUCT BY NAME g_wc ON      # 螢幕上取單頭條件
             oea00,oea08,oea01,oea06,oea02,oea11,oea12,oea03,oea032,
             oea04,oea17,oea1004,oea1015,oea14,oea15,oea1002,oea1009,
             oea1003,oea917,
             oea10,oea23,oea24,oea21,oea211,oea212,oea213,  #FUN-820046 add oea917
             oea31,oea32,oea37,oea50,oeamksg,oea1005,oeahold,oeaconf,oeacont,oea49, #No.FUN-870007-add-oeacont
             oea044,oea41,oea42,oea43,oea44,oea33,oea09,oea1012,oea1013,
             oea1014,oea161,oea261,oea162,oea262,oea163,oea263,oea1011,oea1010,oea05,oea18,     #No:FUN-A50103
             oea07,oea62,oea63,oea65,                          #No.FUN-870007
             oea83,oea84,oea85,oea86,oea87,oeaplant,oeaconu,   #No.FUN-870007
             oea88,oea89,oea90,oea91,oea92,oea93,              #No.FUN-870007
             oea25,oea26,oea46,oea80,oea81,oea47,oea48,        #No.FUN-870007
             oea905,oea99,oea61,oeauser,oeagrup,oeamodu,oeadate,
             oeaoriu,oeaorig,                                  #TQC-A30041 ADD
             oeaud01,oeaud02,oeaud03,oeaud04,oeaud05,
             oeaud06,oeaud07,oeaud08,oeaud09,oeaud10,
             oeaud11,oeaud12,oeaud13,oeaud14,oeaud15    #No:FUN-A50103
#            oea918,oea919      #FUN-8C0078   #No:FUN-A50103 Mark

               BEFORE CONSTRUCT
                  CALL cl_qbe_init()

               AFTER FIELD oea11
                  LET l_oea11 = GET_FLDBUF(oea11)
          END CONSTRUCT 
          
          CONSTRUCT g_wc2 ON oeb03,
           oeb49,oeb50,oeb04,oeb06,oeb918,oeb11,oeb1001,oeb1012,oeb906,oeb092, #FUN-A80054  #FUN-A90040
           oeb15,oeb32,oeb30,oeb31,oeb05,oeb12,  #No.FUN-5C0076     #No.FUN-740016  #No.FUN-A80024
           oeb913,oeb914,oeb915,oeb910,oeb911,oeb912,
           oeb916,oeb917,oeb29,oeb24,oeb25,oeb27,oeb28,oeb1004,oeb1002,   # 螢幕上取單身條件  #NO.FUN-670007   #No.FUN-740016
           oeb37,oeb13,oeb1006,oeb14,oeb14t,oeb919,oeb41,oeb42,oeb43,oeb09,oeb091,    #FUN-810045 add oeb41,42,43  #FUN-A80102    #FUN-AB0061 add oeb37
           oeb930,oeb908,oeb22,oeb19,oeb70,oeb16  #FUN-670063 #FUN-6B0151 add oeb16
           ,oebud01,oebud02,oebud03,oebud04,oebud05
           ,oebud06,oebud07,oebud08,oebud09,oebud10
           ,oebud11,oebud12,oebud13,oebud14,oebud15
           ,oeb44,oeb45,oeb46,oeb47,oeb48          #No.FUN-870007
       FROM
           s_oeb[1].oeb03,                           #No.FUN-7C0017
           s_oeb[1].oeb49,s_oeb[1].oeb50,s_oeb[1].oeb04,s_oeb[1].oeb06,s_oeb[1].oeb918, #FUN-A80054  #FUN-A90040
           s_oeb[1].oeb11,s_oeb[1].oeb1001,s_oeb[1].oeb1012,s_oeb[1].oeb906,s_oeb[1].oeb092,
           s_oeb[1].oeb15,s_oeb[1].oeb32,s_oeb[1].oeb30,s_oeb[1].oeb31,s_oeb[1].oeb05,s_oeb[1].oeb12,    #No.FUN-5C0076   #No.FUN-740016  #No.FUN-A80024
           s_oeb[1].oeb913,s_oeb[1].oeb914,s_oeb[1].oeb915,
           s_oeb[1].oeb910,s_oeb[1].oeb911,s_oeb[1].oeb912,
           s_oeb[1].oeb916,s_oeb[1].oeb917,s_oeb[1].oeb29,s_oeb[1].oeb24,s_oeb[1].oeb25,   #No.FUN-740016
           s_oeb[1].oeb27,s_oeb[1].oeb28,       #NO.FUN-670007 add
           s_oeb[1].oeb1004,s_oeb[1].oeb1002,
           s_oeb[1].oeb37,s_oeb[1].oeb13,s_oeb[1].oeb1006,   #FUN-AB0061 add s_oeb[1].oeb37
           s_oeb[1].oeb14,s_oeb[1].oeb14t,s_oeb[1].oeb919,  #FUN-A80102
           s_oeb[1].oeb41,s_oeb[1].oeb42,s_oeb[1].oeb43,  #FUN-810045
           s_oeb[1].oeb09,s_oeb[1].oeb091,s_oeb[1].oeb930,s_oeb[1].oeb908,  #FUN-670063
           s_oeb[1].oeb22,s_oeb[1].oeb19,s_oeb[1].oeb70,s_oeb[1].oeb16  #FUN-6B0151 add oeb16
           ,s_oeb[1].oebud01,s_oeb[1].oebud02,s_oeb[1].oebud03,s_oeb[1].oebud04,s_oeb[1].oebud05
           ,s_oeb[1].oebud06,s_oeb[1].oebud07,s_oeb[1].oebud08,s_oeb[1].oebud09,s_oeb[1].oebud10
           ,s_oeb[1].oebud11,s_oeb[1].oebud12,s_oeb[1].oebud13,s_oeb[1].oebud14,s_oeb[1].oebud15
           ,s_oeb[1].oeb44,s_oeb[1].oeb45,s_oeb[1].oeb46,s_oeb[1].oeb47,s_oeb[1].oeb48   #No.FUN-870007

	      	 BEFORE CONSTRUCT
		          CALL cl_qbe_display_condition(lc_qbe_sn)     
	      	 END CONSTRUCT 
           CONSTRUCT g_wc3 ON oeb03_1,oeb1007,oeb1008,oeb1009,oeb1010,
                            oeb1011,oeb1001_1,oeb14_1,oeb14t_1
                 FROM s_oeb1[1].oeb03_1,s_oeb1[1].oeb1007,s_oeb1[1].oeb1008,
                      s_oeb1[1].oeb1009,s_oeb1[1].oeb1010,
                      s_oeb1[1].oeb1011,s_oeb1[1].oeb1001_1,
                      s_oeb1[1].oeb14_1,s_oeb1[1].oeb14t_1

   		         BEFORE CONSTRUCT
   		            CALL cl_qbe_display_condition(lc_qbe_sn)
           END CONSTRUCT		          
             ON ACTION controlp
                CASE
                   WHEN INFIELD(oea01) #查詢單据
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oea11"   #MOD-4A0252
                        IF g_argv1='0' THEN
                           LET g_qryparam.where = " oea00 = '0' "
                        END IF
                        IF g_argv1='1' THEN
			                     LET g_qryparam.where = " oea00 MATCHES '[123467]' AND oea901 = '",g_oea901,"' "
                        END IF
                        IF g_argv1='2' THEN
                           LET g_qryparam.where = " oea00 MATCHES '[89]' "
                        END IF
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea01
                        NEXT FIELD oea01
                   WHEN INFIELD(oea12)
                      CASE l_oea11
                         WHEN '2'
                            CALL cl_init_qry_var()
                            LET g_qryparam.state = "c"
                            LET g_qryparam.form ="q_oha"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO oea12
                         WHEN '3'
                            CALL cl_init_qry_var()
                            LET g_qryparam.state = "c"
                            LET g_qryparam.form ="q_oea2"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO oea12
                         WHEN '4'
                            CALL cl_init_qry_var()
                            LET g_qryparam.state = "c"
                            LET g_qryparam.form ="q_oqa"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO oea12
                         WHEN '5'
                            CALL cl_init_qry_var()
                            LET g_qryparam.state = "c"
                            LET g_qryparam.form ="q_oqt"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO oea12
                         WHEN '7'
                            CALL cl_init_qry_var()
                            LET g_qryparam.state = "c"
                            LET g_qryparam.form ="q_oga"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO oea12
                         OTHERWISE EXIT CASE
                      END CASE

                   WHEN INFIELD(oea1015)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_pmc8"
                      LET g_qryparam.default1 = g_oea.oea1015
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oea1015
                      NEXT FIELD oea1015
                   WHEN INFIELD(oea03)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        #-----MOD-A30026---------
                        #LET g_qryparam.form ="q_occ3"   
                        IF g_aza.aza50='Y' THEN  
                           LET g_qryparam.form ="q_occ3" 
                        ELSE 
                           LET g_qryparam.form ="q_occ"  
                        END IF   
                        #-----END MOD-A30026-----
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea03
                        NEXT FIELD oea03
                   WHEN INFIELD(oea04)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        IF g_aza.aza50='Y' THEN
                           LET g_qryparam.form ="q_occ4"    #FUN-610055
                        ELSE
                           LET g_qryparam.form ="q_occ"  #No.FUN-650108
                        END IF
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea04
                        NEXT FIELD oea04
                   WHEN INFIELD(oea14)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_gen"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea14
                        NEXT FIELD oea14
                   WHEN INFIELD(oea15)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_gem"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea15
                        NEXT FIELD oea15
                   WHEN INFIELD(oea1011)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_occ7"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea1011
                        NEXT FIELD oea1011
                   WHEN INFIELD(oea17)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        IF g_aza.aza50='Y' THEN
                           LET g_qryparam.form ="q_occ6"
                        ELSE
                           LET g_qryparam.form ="q_occ"  #No.FUN-650108
                        END IF
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea17
                        NEXT FIELD oea17
                   WHEN INFIELD(oea1002)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_tqa1"
                        LET g_qryparam.arg1 ='20'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea1002
                        NEXT FIELD oea1002
                   WHEN INFIELD(oea1003)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_tqb"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea1003
                        NEXT FIELD oea1003
                   WHEN INFIELD(oea1004)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_occ5"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea1004
                        NEXT FIELD oea1004
                   WHEN INFIELD(oea1009)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_tqa1"
                        LET g_qryparam.arg1 ='19'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea1009
                        NEXT FIELD oea1009
                   WHEN INFIELD(oea1010)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_tqb"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea1010
                        NEXT FIELD oea1010
                   WHEN INFIELD(oea21)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        IF g_aza.aza26 = '2' THEN         #TQC-A50060 --modify
                           LET g_qryparam.form ="q_gec9"  #TQC-A50060 --modify
                        ELSE                              #TQC-A50060 --modify
                        LET g_qryparam.form ="q_gec"
                        END IF                            #TQC-A50060 --modify
                        LET g_qryparam.arg1 = '2'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea21
                        NEXT FIELD oea21
                   WHEN INFIELD(oea23)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_azi"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea23
                        NEXT FIELD oea23
                   WHEN INFIELD(oea25)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oab"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea25
                        NEXT FIELD oea25
                   WHEN INFIELD(oea26)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oab"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea26
                        NEXT FIELD oea26
                   WHEN INFIELD(oea31)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oah"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea31
                        NEXT FIELD oea31
                   WHEN INFIELD(oea32)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oag"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea32
                        NEXT FIELD oea32
                   WHEN INFIELD(oea044)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_ocd"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea044
                   WHEN INFIELD(oea41)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oac"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea41
                   WHEN INFIELD(oea42)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oac"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea42
                   WHEN INFIELD(oea43)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_ged"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea43
                   WHEN INFIELD(oea44)    #MOD-4A0252
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form = "q_ocf"   # MOD-580085
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea44
                   WHEN INFIELD(oea46)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_pja2"  #FUN-810045
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea46
                   WHEN INFIELD(oea47)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form = "q_pmc4"
                        LET g_qryparam.arg1 = '4'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea47
                   WHEN INFIELD(oea48)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form = "q_ofs"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea48
                   WHEN INFIELD(oeahold)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oak1"
                        LET g_qryparam.default1= g_oea.oeahold
                        LET g_qryparam.arg1 ='1'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oeahold
                        NEXT FIELD oeahold
                   WHEN INFIELD(oea80)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oag"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea80
                        NEXT FIELD oea80
                   WHEN INFIELD(oea81)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oag"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea81
                        NEXT FIELD oea81
                   WHEN INFIELD(oea83)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = "c"
                         LET g_qryparam.form ="q_oea83"
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO oea83
                         NEXT FIELD oea83
                   WHEN INFIELD(oea84)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = "c"
                         LET g_qryparam.form ="q_oea84"
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO oea84
                         NEXT FIELD oea84
                   WHEN INFIELD(oea86)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = "c"
                         LET g_qryparam.form ="q_oea86"
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO oea86
                         NEXT FIELD oea86
                   WHEN INFIELD(oeaconu)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = "c"
                         LET g_qryparam.form ="q_oeaconu"
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO oeaconu
                         NEXT FIELD oeaconu
                   WHEN INFIELD(oeaplant)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_azp"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oeaplant
                        NEXT FIELD oeaplant
                   WHEN INFIELD(oeaud02)
                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oeaud02
                      NEXT FIELD oeaud02
                   WHEN INFIELD(oeaud03)
                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oeaud03
                      NEXT FIELD oeaud03
                   WHEN INFIELD(oeaud04)
                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oeaud04
                      NEXT FIELD oeaud04
                   WHEN INFIELD(oeaud05)
                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oeaud05
                      NEXT FIELD oeaud05
                   WHEN INFIELD(oeaud06)
                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oeaud06
                      NEXT FIELD oeaud06
##

   #No.FUN-A90040      begin--       
             WHEN INFIELD(oeb49)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_oeb49"   
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oeb49
                 NEXT FIELD oeb49
          #No.FUN-A90040      end-- 
                WHEN INFIELD(oeb1001)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_azf03" #TQC-7C0098
                      LET g_qryparam.arg1 = "2"   #No.FUN-660073
                      LET g_qryparam.arg2 = "1"   #No.TQC-7C0098
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb1001
                   NEXT FIELD oeb1001
                WHEN INFIELD(oeb31)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_azf1"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb31
                   NEXT FIELD oeb31
                WHEN INFIELD(oeb04)
         #No.FUN-A90048 -------------start-----------------------       
         #          CALL cl_init_qry_var()
         #          LET g_qryparam.state = "c"
         #          IF g_aza.aza50='Y' THEN
         #             LET g_qryparam.form ="q_ima15"   #FUN-610055
         #          ELSE
         #             LET g_qryparam.form ="q_ima"   #FUN-610055
         #          END IF
         #          CALL cl_create_qry() RETURNING g_qryparam.multiret
                    IF g_aza.aza50='Y' THEN
                       CALL q_sel_ima( TRUE, "q_ima15","","","","","","","",'')
                              RETURNING  g_qryparam.multiret
                    ELSE
                       CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'') 
                              RETURNING  g_qryparam.multiret
                    END IF
          #No.FUN-A90048 -------------end -------------------------
                   DISPLAY g_qryparam.multiret TO oeb04
                   NEXT FIELD oeb04

                WHEN INFIELD(oeb05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb05
                   NEXT FIELD oeb05

                #FUN-A80054--begin--add----------
                WHEN INFIELD(oeb918)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_eda"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb918
                   NEXT FIELD oeb918
                #FUN-A80054--end--add------------

                WHEN INFIELD(oeb908)
                   CALL q_coc2(TRUE,TRUE,g_oeb[1].oeb908,'',g_oea.oea02,'0',
                               '',g_oeb[1].oeb04)
                   RETURNING g_oeb[1].oeb908
                   DISPLAY BY NAME g_oeb[1].oeb908
                   NEXT FIELD oeb908
                WHEN INFIELD(oeb913)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb913
                   NEXT FIELD oeb913

                WHEN INFIELD(oeb910)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb910
                   NEXT FIELD oeb910

                WHEN INFIELD(oeb916)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb916
                   NEXT FIELD oeb916
                WHEN INFIELD(oeb1004)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_tqx3"  #TQC-7C0098
                   LET g_qryparam.arg1 = g_oea.oea23  #TQC-7C0098
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb1004
                   NEXT FIELD oeb1004
                WHEN INFIELD(oeb41) #專案
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pja2"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb41
                  NEXT FIELD oeb41
                WHEN INFIELD(oeb42)  #WBS
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjb4"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb42
                  NEXT FIELD oeb42
                WHEN INFIELD(oeb43)  #活動
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjk3"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb43
                  NEXT FIELD oeb43

                WHEN INFIELD(oeb09)
                   #No.FUN-AA0048  --Begin
                   #CALL cl_init_qry_var()
                   #LET g_qryparam.state = "c"
                   #LET g_qryparam.form ="q_imd01"
                   #CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
                   #No.FUN-AA0048  --End  
                   DISPLAY g_qryparam.multiret TO oeb09
                   NEXT FIELD oeb09
                WHEN INFIELD(oeb091)
                   #No.FUN-AA0048  --Begin
                   #CALL cl_init_qry_var()
                   #LET g_qryparam.state = "c"
                   #LET g_qryparam.form ="q_ime"
                   #LET g_qryparam.arg1 = g_oeb[1].oeb09
                   #LET g_qryparam.arg2 = 'SW'
                   #CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_ime_1(TRUE,TRUE,"","","","","","","") RETURNING g_qryparam.multiret
                   #No.FUN-AA0048  --End  
                   DISPLAY g_qryparam.multiret TO oeb091
                   NEXT FIELD oeb091
                WHEN INFIELD(oeb930)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_gem4"
                   LET g_qryparam.state = "c"   #多選
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb930
                   NEXT FIELD oeb930
                WHEN INFIELD(oebud02)
                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oebud02
                   NEXT FIELD oebud02
                WHEN INFIELD(oebud03)
                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oebud03
                   NEXT FIELD oebud03
                WHEN INFIELD(oebud04)
                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oebud04
                   NEXT FIELD oebud04
                WHEN INFIELD(oebud05)
                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oebud05
                   NEXT FIELD oebud05
                WHEN INFIELD(oebud06)
                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oebud06
                   NEXT FIELD oebud06   
###                     
                WHEN INFIELD(oeb1007)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_tqw2"      #No.FUN-820033
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb1007
                   NEXT FIELD oeb1007                                    
                END CASE

             ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE DIALOG

             ON ACTION about         #MOD-4C0121
                CALL cl_about()      #MOD-4C0121

             ON ACTION help          #MOD-4C0121
                CALL cl_show_help()  #MOD-4C0121

             ON ACTION controlg      #MOD-4C0121
                CALL cl_cmdask()     #MOD-4C0121

             ON ACTION qbe_select
		            CALL cl_qbe_list() RETURNING lc_qbe_sn
	              CALL cl_qbe_display_condition(lc_qbe_sn)
	              
             ON ACTION accept
                EXIT DIALOG
       
             ON ACTION EXIT
                LET INT_FLAG = TRUE
                EXIT DIALOG 
                 
             ON ACTION cancel
                LET INT_FLAG = TRUE
                EXIT DIALOG          
            END DIALOG        
       END IF
       IF INT_FLAG THEN RETURN END IF
       EXIT WHILE
       END WHILE       
    END IF   #FUN-580155
    #No.FUN-A40055--end
    #資料權限的檢查

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')

    IF g_argv1='0' THEN
       LET g_wc=g_wc clipped," AND oea00 = '0'"
    END IF

    IF g_argv1='1' THEN
       LET g_wc=g_wc clipped," AND oea00 IN ('1','2','3','4','6','7')"  #FUN-610055     #FUN-690044
    END IF

    IF g_argv1='A' THEN
       LET g_wc=g_wc CLIPPED," AND oea00 = 'A'"
    END IF

    IF g_argv1='2' THEN
       LET g_wc=g_wc CLIPPED," AND oea00 IN ('8','9')"
    END IF

    IF g_oea901 = 'Y' THEN
       LET g_wc=g_wc CLIPPED," AND oea901 = 'Y' "
    ELSE
       LET g_wc=g_wc CLIPPED," AND (oea901 = 'N' OR oea901 IS NULL) "
    END IF

    LET g_wc4 = g_wc3
    LET g_wc4 = cl_replace_str(g_wc4,'oeb03_1','oeb03')
    LET g_wc4 = cl_replace_str(g_wc4,'oeb14_1','coo14')
    LET g_wc4 = cl_replace_str(g_wc4,'oeb1001_1','oeb1001')
    LET g_wc4 = cl_replace_str(g_wc4,'oeb14t_1','oeb14t')
    #下面這段改用上面的寫法
    IF g_wc2 = " 1=1"  AND g_wc4 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  oea01 FROM oea_file",
                   " WHERE ", g_wc CLIPPED,
                   "   AND oeaplant IN ",g_auth CLIPPED,   #No.FUN-870007
                   " ORDER BY oea01"  #FUN-610055
    ELSE				# 若單身有輸入條件

       IF g_wc2 != " 1=1"  AND g_wc4 != " 1=1" THEN	
          LET g_sql = "SELECT UNIQUE  oea01 ",
                   "  FROM oea_file, oeb_file",
                   " WHERE oea01 = oeb01 ",
                   "   AND oeaplant=oebplant ",           #No.FUN-870007
                   "   AND oeaplant IN ",g_auth CLIPPED,  #No.FUN-870007
                   "   AND ",g_wc CLIPPED,
                   "   AND (",g_wc2 CLIPPED,
                   "   OR  ",g_wc4 CLIPPED,")"
       ELSE
          LET g_sql = "SELECT UNIQUE  oea01 ",
                   "  FROM oea_file, oeb_file",
                   " WHERE oea01 = oeb01 ",
                   "   AND oeaplant=oebplant ",           #No.FUN-870007
                   "   AND oeaplant IN ",g_auth CLIPPED,  #No.FUN-870007
                   "   AND ",g_wc CLIPPED

          IF g_wc2 != " 1=1"  THEN
             LET g_sql =g_sql CLIPPED," AND ",g_wc2 CLIPPED
          END IF
          IF g_wc4 != " 1=1"  THEN
             LET g_sql =g_sql CLIPPED," AND ",g_wc4 CLIPPED
          END IF
       END IF
    END IF

    PREPARE t400_prepare FROM g_sql
    DECLARE t400_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t400_prepare

    IF g_wc2 = " 1=1" AND g_wc4 = " 1=1" THEN			# 取合乎條件筆數
       LET g_sql="SELECT COUNT(*) FROM oea_file ",
                 " WHERE ", g_wc CLIPPED,
                 "   AND oeaplant IN ",g_auth CLIPPED  #No.FUN-870007
    ELSE
       LET g_sql="SELECT COUNT(DISTINCT oea01) ",
                 "  FROM oea_file,oeb_file ",
                 " WHERE oeb01=oea01 ",
                 "   AND oeaplant=oebplant ",           #No.FUN-870007
                 "   AND oeaplant IN ",g_auth CLIPPED,  #No.FUN-870007
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED,
                 "   AND ",g_wc4 CLIPPED
    END IF

    PREPARE t400_precount FROM g_sql
    DECLARE t400_count CURSOR FOR t400_precount
    # 2004/02/06 by Hiko : 為了上下筆資料所做的設定.
    OPEN t400_count
    FETCH t400_count INTO g_row_count
    CLOSE t400_count

END FUNCTION

FUNCTION t400_menu()
   DEFINE l_cmd LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(80)
   DEFINE l_creator   LIKE type_file.chr1    #No.FUN-680137  VARCHAR(1)   #「不准」時是否退回填表人 #FUN-580155
   DEFINE l_flowuser  LIKE type_file.chr1    #No.FUN-680137  VARCHAR(1)   # 是否有指定加簽人員      #FUN-580155
   DEFINE l_price1    LIKE oeb_file.oeb14t   #No.FUN-870007
   LET l_flowuser = "N"   #FUN-580155

   WHILE TRUE
      CASE
         WHEN (g_action_flag IS NULL) OR (g_action_flag = "deliver")
            CALL t400_bp("G")
         WHEN (g_action_flag = "return_benefit")
            CALL t400_bp1("G")
      END CASE

      CASE g_action_choice

         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t400_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t400_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t400_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t400_u()
            END IF

         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t400_copy()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CASE
                  WHEN (g_action_flag IS NULL) OR (g_action_flag = "deliver")
                     CALL t400_b()
                  WHEN (g_action_flag = "return_benefit")
                     CALL t400_b1()
               END CASE
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "output"
            CALL t400_out()

#FUN-A70146 --begin--
        WHEN "qry_price"
          IF cl_chk_act_auth() THEN 
             CALL t400_qry_price()
          END IF           
#FUN-A70146 --end--

#FUN-A70132 --begin--
        WHEN "detail_tax"
          IF cl_chk_act_auth() THEN
            CALL t400_detail_tax()
          END IF     
#FUN-A70132 --end--

         WHEN "cancel_price"
            IF cl_chk_act_auth() THEN
               CALL t400_cancel_price()
            END IF

         WHEN "mul_trade"
            CALL t400_v()
            CALL t400_show() #FUN-6C0006

         WHEN "mul_trade_other"
            CALL axmt811(g_oea.oea01,g_oea.oea04,'a')

         WHEN "restore"
            IF cl_chk_act_auth() AND g_oea.oea905 = 'Y'
               AND g_oea.oea906= 'Y'
               AND g_oea.oea99 IS NOT NULL THEN   #NO.FUN-670007 add
               LET l_cmd="axmp810 '",g_oea.oea01,"' "
               CALL cl_cmdrun_wait(l_cmd)
            END IF
            IF g_oea.oea905 = 'N' OR cl_null(g_oea.oea905) THEN
               CALL cl_err('','axm-928',1)
            END IF
            IF g_oea.oea906 = 'N' OR cl_null(g_oea.oea906) THEN
               CALL cl_err('','axm-929',1)
            END IF
            IF cl_null(g_oea.oea99) THEN
               CALL cl_err('','axm-930',1)
            END IF
            SELECT * INTO g_oea.* FROM oea_file WHERE oea01=g_oea.oea01
            CALL t400_show() #FUN-6C0006

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "carry_pr"
            IF cl_chk_act_auth() THEN
               IF g_oea.oea00 = '4' THEN
                 CALL cl_err('','axm-054',1)
                 CONTINUE WHILE
               END IF
               IF g_oea901='Y' THEN #多角貿易訂單才需判斷是否為最終訂單
                  CALL t400_chk_oeb904()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,1)
                     CONTINUE WHILE
                  END IF
               END IF
               IF cl_null(g_oea.oeahold) THEN      #TQC-740227
                 CALL t400sub_exp(g_oea.oea01,'','')      #TQC-730022
                 IF g_success='Y' THEN #FUN-730018 裡面會呼叫確認段,執行完後必須更新data
                    CALL t400sub_refresh(g_oea.oea01)  RETURNING g_oea.* #FUN-730018 更新g_oea
                    CALL t400_show() #FUN-730018
                 END IF
               ELSE                                      #TQC-750133 add
                 CALL cl_err('','axm-296',1)             #TQC-750133 add
               END IF   #TQC-740027
            END IF
         WHEN "carry_po"
            IF cl_chk_act_auth() THEN
               IF g_oea.oea00 = '4' THEN
                 CALL cl_err('','axm-054',1)
                 CONTINUE WHILE
               END IF
               IF g_oea901='Y' THEN #多角貿易訂單才需判斷是否為最終訂單
                  CALL t400_chk_oeb904()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,1)
                     CONTINUE WHILE
                  END IF
               END IF
               IF cl_null(g_oea.oeahold) THEN            #TQC-740227
                 CALL t400sub_exp_po(g_oea.oea01,'','')  #TQC-730022
                 CALL t400sub_refresh(g_oea.oea01)  RETURNING g_oea.* #FUN-730018 更新g_oea
                 CALL t400_show() #FUN-730018
               ELSE                                      #TQC-750133 add
                 CALL cl_err('','axm-296',1)             #TQC-750133 add
               END IF   #TQC-740027
            END IF

         WHEN "allocate"
            IF g_oea.oeaconf = 'X' THEN
               CALL cl_err('',9024,0)
            ELSE
               LET g_msg="axmp450 '",g_oea.oea01,"'"
                CALL cl_cmdrun_wait(g_msg) #MOD-570260 add
            END IF
            CALL t400_show()

         WHEN "qry_inv_ordered"
            IF cl_chk_act_auth() THEN
                LET g_msg="axmq450 '' '",g_oea.oea01,"' " #MOD-4B0136
               CALL cl_cmdrun(g_msg)
            END IF
 
         WHEN "discount_detail"                          #FUN-A10110 ADD
            IF cl_chk_act_auth()  THEN
               LET g_msg="artq800 '01' '",g_oea.oea01,"' "  
               CALL cl_cmdrun(g_msg)
            END IF

         WHEN "csd_data"
            IF cl_chk_act_auth() THEN
               CALL t400_4()
               CALL t400_b_fill(' 1=1')#FUN-6C0006
            END IF

         WHEN "expense_data"
            IF cl_chk_act_auth() THEN
               CALL t400_5()
            END IF

         WHEN "on_hold"
            IF cl_chk_act_auth() THEN
               IF g_oea.oea49 matches '[Ss]' THEN            #FUN-A50013 add
                  CALL cl_err('','apm-030',0)                #FUN-A50013 add
               ELSE                                          #FUN-A50013 add
                  CALL t400_6()
               END IF                                        #FUN-A50013 add
            END IF
         WHEN "pay_money"
	    IF cl_chk_act_auth() THEN
               CALL t400_pay_chk()
               CALL t400_l_price() RETURNING l_price1
              CALL s_pay('01',g_oea.oea01,g_oea.oeaplant,l_price1,g_oea.oeaconf)
            END IF
        WHEN "money_detail"
	    IF cl_chk_act_auth() THEN
             	 CALL s_pay_detail('01',g_oea.oea01,g_oea.oeaplant,g_oea.oeaconf)
            END IF

         WHEN "undo_on_hold"
            IF cl_chk_act_auth() THEN
               IF g_oea.oea49 matches '[Ss]' THEN            #FUN-A50013 add
                  CALL cl_err('','apm-030',0)                #FUN-A50013 add
               ELSE                                          #FUN-A50013 add
                  CALL t400_7()
               END IF                                        #FUN-A50013 add
            END IF

         WHEN "order_query"
            IF cl_chk_act_auth() THEN       #MOD-7A0074
               CALL s_ordqry(g_oea.oea01)
            END IF                          #MOD-7A0074

         WHEN "query_customer"
            CALL s_cusqry(g_oea.oea03)  #FUN-610055
         #No.FUN-A10106--begin
         WHEN "kefa"
            IF cl_null(g_oea.oea01) THEN 
               CALL cl_err('','-400',1)
#              RETURN
            ELSE
               CALL s_gifts('01',g_oea.oea01,g_oea.oeaplant,g_oea.oea02,g_oea.oea87)
               CALL t400_b_fill(' 1=1')                  #FUN-B30012 add
            END IF
         #No.FUN-A10106--end  
       
         WHEN "query_qr"
            IF cl_chk_act_auth() THEN
               CALL t400_qr()
            END IF

         WHEN "change_status"
            IF cl_chk_act_auth() THEN
                  LET g_cmd = "axmt800 '",g_oea.oea01,"'"
               CALL cl_cmdrun_wait(g_cmd)  #FUN-660216 add
            END IF

         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_oea.oea01 IS NOT NULL THEN
                  LET g_doc.column1 = "oea01"
                  LET g_doc.value1 = g_oea.oea01
                  CALL cl_doc()
               END IF
            END IF

         WHEN "memo"
            IF cl_chk_act_auth() THEN
               CALL t400_m()
            END IF

         WHEN "modify_price"
            IF cl_chk_act_auth() THEN
               CALL t400_m1()
               CALL t400_show()
            END IF

         WHEN "modify_rate"
            IF cl_chk_act_auth() THEN
               CALL t400_m2()
               CALL t400_show()
            END IF

         WHEN "pref"
            IF cl_chk_act_auth() THEN
               CALL t400_pref()
            END IF

         WHEN "discount_allowed"
            IF cl_chk_act_auth() THEN
               CALL t400sub_y_chk('2',g_oea.oea01)          #CALL 原確認的 check 段  #FUN-730012
               IF g_success = "Y" THEN
                  CALL t400sub_y_upd(g_oea.oea01,'discount_allowed')      #CALL 原確認的 update 段 #FUN-730012
                  CALL t400sub_refresh(g_oea.oea01)  RETURNING g_oea.* #FUN-730012 更新g_oea
                  CALL t400_show() #FUN-6C0006
               END IF
            END IF

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
#TQC-AA0139 --begin--           
              LET g_success = 'Y'
              CALL t400_check()       
              IF g_success = 'Y' THEN 
#TQC-AA0139 --end--              
               CALL t400sub_y_chk('1',g_oea.oea01)         #CALL 原確認的 check 段 #FUN-610055 #FUN-730012
               IF g_success = "Y" THEN
                  CALL t400sub_y_upd(g_oea.oea01,'confirm')       #CALL 原確認的 update 段 #FUN-730012
                  CALL t400sub_refresh(g_oea.oea01)  RETURNING g_oea.* #FUN-730012 更新g_oea
                  CALL t400_show() #FUN-6C0006
                # 單據自動化產生下游單據
                  IF g_success = "Y" AND g_prog = 'axmt410' THEN   #FUN-740091
                    IF cl_null(g_oea.oeahold) THEN      #TQC-740227
                    CALL s_auto_gen_doc('axmt410',g_oea.oea01,'')
                    END IF    #TQC-740227
                  END IF
               END IF
             END IF   #TQC-AA0139                
            END IF

         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t400_z()
               CALL t400_show() #FUN-6C0006
            END IF

         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t400_x()
            END IF

         #-----No:FUN-A50103-----
         WHEN "deposit_multi_account"   #訂金多帳期
            IF cl_chk_act_auth() THEN
               IF g_oea.oea49 matches '[Ss]' THEN            #FUN-A50013 add
                  CALL cl_err('','apm-030',0)                #FUN-A50013 add
               ELSE                                          #FUN-A50013 add
                  CALL t400_multi_account('1')
               END IF                                        #FUN-A50013 add
            END IF

         WHEN "balance_multi_account"   #尾款多帳期
            IF cl_chk_act_auth() THEN
               IF g_oea.oea49 matches '[Ss]' THEN            #FUN-A50013 add
                  CALL cl_err('','apm-030',0)                #FUN-A50013 add
               ELSE                                          #FUN-A50013 add
                  CALL t400_multi_account('2')
               END IF                                        #FUN-A50013 add 
            END IF
         #-----No:FUN-A50103 END-----

         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oeb),'','')
            END IF
       #@WHEN "簽核狀況"
          WHEN "approval_status"               # BUG-4C0041   #MOD-4A0299
            IF cl_chk_act_auth() THEN  #DISPLAY ONLY
               IF aws_condition2() THEN
                    CALL aws_efstat2()                 #MOD-560007
               END IF
            END IF

          WHEN "easyflow_approval"     #MOD-4A0299
            IF cl_chk_act_auth() THEN
                 CALL t400_ef()
            END IF

         WHEN "other_data"
            IF cl_chk_act_auth() THEN
               CALL t400_b_more1()  #No.FUN-5A0071
               CALL t400_b_fill(' 1=1')#FUN-6C0006
            END IF

      #@WHEN "准"
      WHEN "agree"
           IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加簽人員
              CALL t400sub_y_upd(g_oea.oea01,'agree') #CALL 原確認的 update 段 #FUN-730012
              CALL t400sub_refresh(g_oea.oea01)  RETURNING g_oea.* #FUN-730012 更新g_oea
              CALL t400_show() #FUN-6C0006
           ELSE
              LET g_success = "Y"
              IF NOT aws_efapp_formapproval() THEN
                 LET g_success = "N"
              END IF
           END IF
           IF g_success = 'Y' THEN
              IF cl_confirm('aws-081') THEN
                 IF aws_efapp_getnextforminfo() THEN
                    LET l_flowuser = 'N'
                    LET g_argv2 = aws_efapp_wsk(1)   #參數:key-1
                    IF NOT cl_null(g_argv2) THEN
                       CALL t400_q()
                       #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                       CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale, void, confirm, undo_confirm, easyflow_approval, csd_data, expense_data, on_hold, undo_on_hold, change_status, restore, carry_pr,carry_po, mul_trade, mul_trade_other, allocate, undo_distribution, modify_price, modify_rate, pref, discount_allowed, deposit_multi_account, balance_multi_account, new_code_application, product_inf") ##TQC-5B0117   #FUN-6C0050 add carry_po #TQC-740127  #TQC-740281 #FUN-A50013
                            RETURNING g_laststage
                    ELSE
                       EXIT WHILE
                    END IF
                 ELSE
                    EXIT WHILE
                 END IF
              ELSE
                 EXIT WHILE
              END IF
           END IF

      #@WHEN "不准"
      WHEN "deny"
          IF (l_creator := aws_efapp_backflow()) IS NOT NULL THEN
             IF aws_efapp_formapproval() THEN
                IF l_creator = "Y" THEN
                   LET g_oea.oea49 = 'R'
                   DISPLAY BY NAME g_oea.oea49
                END IF
                IF cl_confirm('aws-081') THEN
                   IF aws_efapp_getnextforminfo() THEN
                      LET l_flowuser = 'N'
                      LET g_argv2 = aws_efapp_wsk(1)   #參數:key-1
                      IF NOT cl_null(g_argv2) THEN
                         CALL t400_q()
                         #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                         CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale, void, confirm, undo_confirm, easyflow_approval, csd_data, expense_data, on_hold, undo_on_hold, change_status, restore, carry_pr,carry_po, mul_trade, mul_trade_other, allocate, undo_distribution, modify_price, modify_rate, pref, discount_allowed, deposit_multi_account, balance_multi_account, new_code_application, product_inf") ##TQC-5B0117   #FUN-6C0050 add carry_po #TQC-740127  #TQC-740281
                              RETURNING g_laststage
                      ELSE
                         EXIT WHILE
                      END IF
                   ELSE
                      EXIT WHILE
                   END IF
                ELSE
                   EXIT WHILE
                END IF
             END IF
           END IF

      #@WHEN "加簽"
      WHEN "modify_flow"
          IF aws_efapp_flowuser() THEN   #選擇欲加簽人員
             LET l_flowuser = 'Y'
          ELSE
             LET l_flowuser = 'N'
          END IF
          
      #@WHEN "撤簽"
      WHEN "withdraw"
           IF cl_confirm("aws-080") THEN
              IF aws_efapp_formapproval() THEN
                 EXIT WHILE
              END IF
           END IF

      #@WHEN "抽單"
      WHEN "org_withdraw"
           IF cl_confirm("aws-079") THEN
              IF aws_efapp_formapproval() THEN
                 EXIT WHILE
              END IF
           END IF

     #@WHEN "簽核意見"
      WHEN "phrase"
           CALL aws_efapp_phrase()

      WHEN "undo_distribution"
         IF cl_chk_act_auth() THEN
            IF g_oea.oea49 matches '[Ss]' THEN               #FUN-A50013 add
               CALL cl_err('','apm-030',0)                   #FUN-A50013 add
            ELSE                                             #FUN-A50013 add
               CALL t400_undo_dis()
               CALL t400_show()
            END IF                                           #FUN-A50013 add
         END IF


      WHEN "obj_return_close"
            IF cl_chk_act_auth() THEN
               IF g_oea.oea49 matches '[Ss]' THEN            #FUN-A50013 add
                  CALL cl_err('','apm-030',0)                #FUN-A50013 add
               ELSE                                          #FUN-A50013 add
                  LET g_msg="atmi300 '",g_oea.oea01,"'"
                  CALL cl_cmdrun_wait(g_msg)
               END IF                                        #FUN-A50013 add
            END IF
      WHEN "cash_return"
            IF cl_chk_act_auth() THEN
               IF g_oea.oea49 matches '[Ss]' THEN            #FUN-A50013 add
                  CALL cl_err('','apm-030',0)                #FUN-A50013 add
               ELSE                                          #FUN-A50013 add
                  CALL t400_cash_return()
               END IF                                        #FUN-A50013 add
            END IF
      WHEN "obj_return"
            IF cl_chk_act_auth() THEN
               IF g_oea.oea49 matches '[Ss]' THEN            #FUN-A50013 add
                  CALL cl_err('','apm-030',0)                #FUN-A50013 add
               ELSE                                          #FUN-A50013 add
                  CALL t400_obj_return()
               END IF                                        #FUN-A50013 add
            END IF


      END CASE
   END WHILE

END FUNCTION

#TQC-AA0139 --begin--
FUNCTION t400_check()   
DEFINE l_count  LIKE type_file.num5    
DEFINE i        LIKE type_file.num5 
DEFINE l_flag   LIKE type_file.num5 
DEFINE l_ima906 LIKE ima_file.ima906
DEFINE l_ima907 LIKE ima_file.ima907
DEFINE l_ima908 LIKE ima_file.ima908

   LET l_count = 0             
   SELECT COUNT(*) INTO l_count FROM tqp_file
    WHERE tqp01 = g_oea.oea12
       
   FOR i=1 TO g_oeb.getLength()
      IF cl_null(g_oeb[l_ac].oeb32) AND g_argv1 ='0' THEN
         CALL cl_err(g_oeb[l_ac].oeb32,'axm-338',0)
         LET g_success = 'N'
         EXIT FOR 
      END IF   
     IF cl_null(g_oeb[i].oeb71) AND g_oea.oea11 MATCHES '[5]' THEN  
        CALL cl_err(g_oeb[i].oeb04,'axm-331',0)
        LET g_success = 'N'
        EXIT FOR 
     END IF      
     
     IF cl_null(g_oeb[i].oeb71) AND g_oea.oea11 = '3' THEN 
       IF l_count = 0 THEN
          CALL cl_err(g_oeb[i].oeb04,'axm-332',0)       
          LET g_success = 'N'
          EXIT FOR 
       END IF      
     END IF     
     
     IF g_sma.sma115 = 'Y' THEN
        CALL s_chk_va_setting(g_oeb[i].oeb04)
            RETURNING l_flag,l_ima906,l_ima907
        IF l_flag=1 THEN
           CALL cl_err(g_oeb[i].oeb04,'axm-339',0)     
           LET g_success = 'N'
           EXIT FOR 
        END IF

        CALL s_chk_va_setting1(g_oeb[i].oeb04)
            RETURNING l_flag,l_ima908
        IF l_flag=1 THEN
           CALL cl_err(g_oeb[i].oeb04,'axm-341',0)  
           LET g_success = 'N'
           EXIT FOR 
        END IF
     END IF        
     
   END FOR                 
END FUNCTION
#TQC-AA0139 --end--

#FUN-A70132 --begin--
FUNCTION t400_detail_tax() 
   DEFINE     l_sql     LIKE type_file.chr1000
   DEFINE     g_rec_b   LIKE type_file.num5,
              g_cnt     LIKE type_file.num5 
   DEFINE l_oeg         DYNAMIC ARRAY OF RECORD     #--定義一個動態數組
              oeg02     LIKE oeg_file.oeg02,
              oeb04     LIKE oeb_file.oeb04,
              oeb04_n   LIKE ima_file.ima02,
              oeg03     LIKE oeg_file.oeg03,
              oeg04     LIKE oeg_file.oeg04,
              gec02     LIKE gec_file.gec02,
              oeg05     LIKE oeg_file.oeg05,
              oeg06     LIKE oeg_file.oeg06,
              oeg07     LIKE oeg_file.oeg07,
              oeg08     LIKE oeg_file.oeg08,
              oeg08t    LIKE oeg_file.oeg08t,
              oeg09     LIKE oeg_file.oeg09
   END RECORD
   IF l_ac = 0  OR cl_null(l_ac)  THEN
      RETURN
   END IF       
   IF (g_azw.azw04='2') AND ( NOT cl_null(g_oea.oea94) ) THEN 
      LET l_sql ="SELECT oeg02,oeb04,' ',oeg03,oeg04,' ',oeg05,oeg06,",
                 "oeg07,oeg08,oeg08t,oeg09 ",
                 "  FROM oeg_file,oeb_file ",
                 " WHERE oeg01 = oeb01 ",
                 "   AND oeg02 = oeb03 ",
                 "   AND oeg02 = '",g_oeb[l_ac].oeb03,"'",
                 "   AND oeb01 = '",g_oea.oea01,"'",
                 " ORDER BY oeg04 "
      PREPARE t400_prepare1 FROM l_sql
         IF SQLCA.sqlcode THEN CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time 
            RETURN 
         END IF
      DECLARE t400_curs1 CURSOR WITH HOLD FOR t400_prepare1 
      CALL l_oeg.clear()
      LET g_cnt = 1     
      FOREACH t400_curs1 INTO l_oeg[g_cnt].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         SELECT ima02 INTO l_oeg[g_cnt].oeb04_n FROM ima_file 
          WHERE ima01 = l_oeg[g_cnt].oeb04
         SELECT gec02 INTO l_oeg[g_cnt].gec02 FROM gec_file
          WHERE gec01 = l_oeg[g_cnt].oeg04
            AND gec011 = '2' 
         LET g_cnt = g_cnt + 1
      END FOREACH 
      CALL l_oeg.deleteElement(g_cnt)
      LET g_rec_b=g_cnt-1
      OPEN WINDOW axmt410_d_w WITH FORM "axm/42f/axmt410_d"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      CALL cl_ui_locale("axmt410_d")         
      DISPLAY g_rec_b TO FORMONLY.cn2 
      DISPLAY ARRAY l_oeg TO s_oeg.*  ATTRIBUTE(COUNT=g_rec_b)
         ON ACTION controlg                                 
            CALL cl_cmdask() 
      END DISPLAY       
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW axmt410_d_w 
      END IF        
   ELSE 
      RETURN   
   END IF
   CLOSE WINDOW axmt410_d_w   
END FUNCTION
#FUN-A70132 --end----

#FUN-A70146 --begin--
FUNCTION t400_qry_price()
DEFINE l_oeb03      LIKE oeb_file.oeb03  
DEFINE l_cnt        LIKE type_file.num5 
DEFINE l_oeb04      LIKE oeb_file.oeb04
DEFINE l_msg        LIKE type_file.chr1000
  
  OPEN WINDOW axmt410_q_w WITH FORM "axm/42f/axmt410_q"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
         
    CALL cl_ui_init()    
  
  WHILE TRUE 
      LET l_oeb03 = NULL 
      LET l_cnt   = 0 
         
      INPUT l_oeb03 WITHOUT DEFAULTS FROM oeb03

      AFTER FIELD oeb03
        IF NOT cl_null(l_oeb03) THEN
           SELECT COUNT(*),oeb04 INTO l_cnt,l_oeb04 FROM oeb_file
            WHERE oeb01 = g_oea.oea01
              AND oeb03 = l_oeb03
             GROUP BY oeb04
           IF l_cnt = 0 THEN 
              CALL cl_err('','axm-974',0)
              NEXT FIELD oeb03
           END IF    
        END IF   
    
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
   ON ACTION CONTROLG 
      CALL cl_cmdask()	
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()    
 
      ON ACTION help          
         CALL cl_show_help() 
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()    

      ON ACTION exit                            
          LET INT_FLAG = 1
          EXIT INPUT

         BEFORE INPUT
           CALL cl_qbe_init()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save() 
   END INPUT
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW axmt410_q_w
      EXIT WHILE 
   ELSE
   	  LET l_msg = "axmq411 '",l_oeb04,"' "   
   	  CALL cl_cmdrun_wait(l_msg)
      
      CONTINUE WHILE    	  
   END IF    
   
 END WHILE   
END FUNCTION 

#FUN-A70146 --end--

FUNCTION t400_cancel_price()
DEFINE l_i    LIKE type_file.num5

   IF s_shut(0) THEN RETURN END IF
   IF g_oea.oea01 IS NULL THEN RETURN END IF
   IF g_oea.oeaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_oea.oeaconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF

   OPEN WINDOW t410_s_w WITH FORM "axm/42f/axmt410_s"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL t400_s_fill()

   INPUT ARRAY g_oeb7 WITHOUT DEFAULTS FROM s_oeb7.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=FALSE,DELETE ROW=FALSE,
                APPEND ROW=FALSE)

       ON ACTION all
          FOR l_i = 1 TO g_oeb7.getLength()
              LET g_oeb7[l_i].status = 'Y'
          END FOR
       ON ACTION no_all
          FOR l_i = 1 TO g_oeb7.getLength()
              LET g_oeb7[l_i].status = 'N'
          END FOR
   END INPUT

   IF INT_FLAG THEN
      CALL g_oeb7.clear()
      LET INT_FLAG = 0
      CLOSE WINDOW t410_s_w
      RETURN
   END IF

   BEGIN WORK
   FOR l_i = 1 TO g_oeb7.getLength()
       IF g_oeb7[l_i].status = 'Y' THEN
          UPDATE oeb_file SET oeb47 = 0,oeb48 = 1     #FUN-9B0025 ADD
               WHERE oeb01 = g_oea.oea01 AND oeb03 = g_oeb7[l_i].oeb03
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN             
             CALL cl_err3("upd","oeb_file",g_oea.oea01,"",SQLCA.sqlcode,"","",1)
             ROLLBACK WORK
             EXIT FOR
          END IF
       END IF
   END FOR

   COMMIT WORK
   CLOSE WINDOW t410_s_w
   CALL t400_b_fill(" 1=1")
   CALL t400_bp_refresh()
END FUNCTION

FUNCTION t400_s_fill()

   LET g_sql = "SELECT 'N',oeb03,oeb04,oeb06,'',oeb05,oeb12,oeb47 ",
               "   FROM oeb_file ",
               "  WHERE oeb01 = ? AND oeb47 IS NOT NULL AND oeb47>0 "
   PREPARE pre_sel_oeb FROM g_sql
   DECLARE cur_oeb CURSOR FOR pre_sel_oeb

   CALL g_oeb7.clear()
   LET g_cnt = 1
   FOREACH cur_oeb USING g_oea.oea01 INTO g_oeb7[g_cnt].*
      IF STATUS THEN
         CALL cl_err('',STATUS,1)
         EXIT FOREACH
      END IF

      SELECT ima021 INTO g_oeb7[g_cnt].ima021 FROM ima_file
          WHERE ima01 = g_oeb7[g_cnt].oeb04

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_oeb7.deleteElement(g_cnt)

END FUNCTION

FUNCTION t400_pay_chk()
DEFINE l_cnt LIKE type_file.num5
   IF s_shut(0) THEN RETURN END IF
   IF g_oea.oea01 IS NULL THEN RETURN END IF
   IF g_oea.oeaconf='Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_oea.oeaconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   IF g_oea.oea61 > 0 AND g_oea.oea61 = g_oea.oea62 THEN
      CALL cl_err('','art-276',0)
      RETURN
   END IF
   IF g_oea.oea49 matches '[sS]' THEN
      CALL cl_err('','art-277',0)
      RETURN
   END IF
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM oeb_file
    WHERE oeb01=g_oea.oea01 AND oeb70='N'
   IF l_cnt=0 THEN CALL cl_err('','art-278',0) RETURN END IF
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM oeb_file
    WHERE oeb01=g_oea.oea01
      AND oeb47<0
   IF l_cnt>0 THEN
      CALL cl_err('','art-483',0)
      LET g_success='N'
      RETURN
   END IF
END FUNCTION

FUNCTION t400_l_price()
   DEFINE l_oeb14t LIKE oeb_file.oeb14t
   DEFINE l_occ72 LIKE occ_file.occ72
   DEFINE l_price LIKE oeb_file.oeb14t
#  DEFINE l_oeb47 LIKE oeb_file.oeb47       #FUN-AB0061 mark

   SELECT SUM(oeb14t) INTO l_oeb14t FROM oeb_file
    WHERE oeb01=g_oea.oea01 AND oeb70='N'

#FUN-AB0061 ------------mark start------------
#  SELECT SUM(oeb47) INTO l_oeb47 FROM oeb_file
#   WHERE oeb01=g_oea.oea01 AND oeb70='N'
#
#  IF g_oea.oea213='N' THEN
#     LET l_oeb47=l_oeb47*(1+g_oea.oea211/100)
#     CALL cl_digcut(l_oeb47,t_azi04) RETURNING l_oeb47
#  END IF
#
#  LET l_price=(l_oeb14t-l_oeb47)*g_oea.oea161/100
#FUN-AB0061 ---------------mark end-------------------
   LET l_price = l_oeb14t*g_oea.oea161/100           #FUN-AB0061 add
   CALL cl_digcut(l_price,t_azi04) RETURNING l_price
 
   IF g_oea.oeaconf <> 'N' THEN
      SELECT SUM(rxx04) INTO l_price FROM rxx_file
       WHERE rxx00 ='01' AND rxx01 = g_oea.oea01
         AND rxx03 = '1' AND rxxplant = g_oea.oeaplant
   END IF

   IF l_price IS NULL THEN LET l_price = 0 END IF

   RETURN l_price

END FUNCTION

FUNCTION t400_a()
   DEFINE   li_result   LIKE type_file.num5        #No.FUN-550052  #No.FUN-680137 SMALLINT

   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""

   CLEAR FORM
   CALL g_oeb.clear()
   CALL g_oeb1.clear()
   LET g_wc = NULL   #MOD-970142
   LET g_wc2=' 1=1'  #MOD-970142
   INITIALIZE g_oea.* TO NULL
   INITIALIZE g_oea_t.* TO NULL
   LET g_oap.oap041=NULL #No.MOD-480274
   LET g_oap.oap042=NULL #No.MOD-480274
   LET g_oap.oap043=NULL #No.MOD-480274
   LET g_oap.oap044=NULL #FUN-720014
   LET g_oap.oap045=NULL #FUN-720014
   LET g_oea.oeaslk02 = 'N'  #FUN-A50054 add oeaslk02 

   LET g_oea.oea917 = 'N'
#  LET g_oea.oea918 = 'N'  #FUN-8C0078   #No:FUN-A50103 Mark
#  LET g_oea.oea919 = 'N'  #FUN-8C0078   #No:FUN-A50103 Mark
   LET g_oea_o.* = g_oea.*

   CALL cl_opmsg('a')

   WHILE TRUE
      CALL t400_a_default()


      CALL t400_i("a")                #輸入單頭

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         ROLLBACK WORK
         EXIT WHILE
      END IF

      IF g_oea.oea01 IS NULL THEN
         CONTINUE WHILE
      END IF

      BEGIN WORK  #No:7829
      CALL s_auto_assign_no("axm",g_oea.oea01,g_oea.oea02,g_buf,"oea_file","oea01","","","")
                  RETURNING li_result,g_oea.oea01
      IF (NOT li_result) THEN
         ROLLBACK WORK
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_oea.oea01

      IF g_oea.oea00 IS NULL OR g_oea.oea00 NOT MATCHES '[0123467A89]' THEN  #No.FUN-610053  #FUN-610055   #FUN-690044   #No.FUN-740016
         DISPLAY BY NAME g_oea.oea00
         CONTINUE WHILE
      END IF

      IF g_oea.oea11='1' THEN LET g_oea.oea12=g_oea.oea01 END IF
      IF g_oea.oea24 IS NULL THEN LET g_oea.oea24=1 END IF
      IF g_oea.oea901='Y' THEN LET g_oea.oea65='N' END IF

      IF cl_null(g_oea.oea85) THEN
         LET g_oea.oea85 = '1'
      END IF
      #TQC-AB0025---------add----------------str-----------
      IF cl_null(g_oea.oeaslk02) THEN
         LET g_oea.oeaslk02 = 'N'
      END IF
      #TQC-AB0025---------add----------------end------------    
      INSERT INTO oea_file VALUES (g_oea.*)
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL cl_err3("ins","oea_file",g_oea.oea01,"",SQLCA.sqlcode,"","",1)  #No.FUN-650108
         ROLLBACK WORK   #No:7829
         CONTINUE WHILE
      END IF

      COMMIT WORK   #No:7829
      CALL cl_flow_notify(g_oea.oea01,'I')

# 新增雜項客戶資料
      IF g_oea.oea03[1,4] = 'MISC' THEN  #FUN-610055
         IF (NOT cl_null(g_occm.occm02)) OR (NOT cl_null(g_occm.occm03))
             OR (NOT cl_null(g_occm.occm04)) OR (NOT cl_null(g_occm.occm05))
             OR (NOT cl_null(g_occm.occm06))
             OR (NOT cl_null(g_occm.occm07)) OR (NOT cl_null(g_occm.occm08))  #FUN-720014 add
         THEN
            LET g_occm.occm01=g_oea.oea01
            INSERT INTO occm_file VALUES(g_occm.*)
         END IF
      END IF

      IF g_oea.oea044[1,4] ='MISC' AND g_oea.oea11='3' THEN
         LET g_oap.oap01=NULL
         SELECT * INTO g_oap.* FROM oap_file WHERE oap01=g_oea.oea12
         IF g_oap.oap01 IS NOT NULL THEN
            LET g_oap.oap01=g_oea.oea01
            INSERT INTO oap_file VALUES (g_oap.*)
         END IF
      END IF

      IF g_oea.oea044[1,4]='MISC' AND g_oea.oea11 != '3' THEN
         LET g_oap.oap01 = g_oea.oea01
         INSERT INTO oap_file VALUES(g_oap.*)
         IF STATUS THEN
            CALL cl_err3("ins","oap_file",g_oap.oap01,"",SQLCA.sqlcode,"","INS-oap",1)  #No.FUN-650108
         END IF
      END IF


      IF g_oea.oea901 = 'Y' THEN CALL t400_v() END IF #多角貿易 No.7946 add

      LET g_oea_t.* = g_oea.*

      CALL g_oeb.clear()
      CALL g_oeb1.clear()
      LET g_rec_b=0
      LET g_rec_b1=0

      IF g_oea.oea50 ='Y' THEN
         CALL t400_4()
      END IF

      CALL t400_sign()

      DISPLAY BY NAME g_oea.oeamksg
      #No.FUN-A10014  --Begin
      CALL t400_g_b3()
      CALL t400_b_fill(' 1=1')
      #No.FUN-A10014  --End
      CALL t400_g_b1()                #由估價自動產生單身
      CALL t400_b_fill(' 1=1') #FUN-6C0006
      CALL t400_g_b5()                #由報價自動產生單身
      CALL t400_b_fill(' 1=1') #FUN-6C0006
      CALL t400_g_b7()                #由出至境外倉出貨單自動產生單身 no.7175
      CALL t400_b_fill(' 1=1') #FUN-6C0006


      CALL t400_b()                   #輸入單身1
      IF g_aza.aza50 = 'Y' THEN  #No.FUN-650108 #FUN-6C0006
         IF g_aza.aza26 != '0' THEN
            CALL t400_b1()                  #輸入單身2
         END IF
      END IF  #No.FUN-650108

      # 多角其他資料
      IF g_oea.oea901 = 'Y' THEN
         CALL axmt811(g_oea.oea01,g_oea.oea04,'a')
      END IF

      EXIT WHILE

   END WHILE

END FUNCTION

#處理INPUT
FUNCTION t400_i(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1                  #a:輸入 u:更改  #No.FUN-680137 VARCHAR(1)
   DEFINE l_flag       LIKE type_file.chr1                  #判斷必要欄位是否有輸入  #No.FUN-680137 VARCHAR(1)
   DEFINE l_n1,l_cnt   LIKE type_file.num5,    #No.FUN-680137 SMALLINT
          l_slip       LIKE oay_file.oayslip   # Prog. Version..: '5.30.06-13.03.12(05)               #No.FUN-550052
   DEFINE li_result    LIKE type_file.num5        #No.FUN-550052  #No.FUN-680137 SMALLINT
   DEFINE l_pmc03      LIKE pmc_file.pmc03   #No.MOD-740365
   DEFINE l_ged02      LIKE ged_file.ged02     #TQC-980149
  #CHI-A60026 add --start--
   DEFINE l_oeb13    LIKE oeb_file.oeb13
   DEFINE l_oeb17    LIKE oeb_file.oeb17
   DEFINE l_oeb904   LIKE oeb_file.oeb904
  #CHI-A60026 add --end--
   DEFINE l_oeb37    LIKE oeb_file.oeb37  #FUN-AB0061

   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

   INPUT BY NAME g_oea.oeaoriu,g_oea.oeaorig,
         g_oea.oea00,g_oea.oea08,g_oea.oea01,g_oea.oea06,g_oea.oea02,
         g_oea.oea11,g_oea.oea12,g_oea.oea03,g_oea.oea032,g_oea.oea04,
         g_oea.oea17,g_oea.oea1004,g_oea.oea1015,g_oea.oea14,g_oea.oea15,
         g_oea.oea1002,g_oea.oea1003,g_oea.oea917,
         g_oea.oea10,g_oea.oea23,  #No.FUN-820046 add oea917
         g_oea.oea24,g_oea.oea21,g_oea.oea211,g_oea.oea212,g_oea.oea213,
         g_oea.oea31,g_oea.oea32,g_oea.oea37,g_oea.oea50,g_oea.oeamksg,
         g_oea.oeaconf,g_oea.oea49,g_oea.oea044,g_oap.oap041,g_oap.oap042,g_oap.oap043,g_oap.oap044,g_oap.oap045,  #FUN-720014 add oap044/045
         g_oea.oea41,g_oea.oea42,g_oea.oea43,g_oea.oea44,g_oea.oea33,g_oea.oea09,g_oea.oea1012,
         g_oea.oea161,g_oea.oea261,g_oea.oea162,g_oea.oea262,g_oea.oea163,g_oea.oea263,    #No:FUN-A50103
         g_oea.oea1011,g_oea.oea05,g_oea.oea18,g_oea.oea07,
         g_oea.oea62,g_oea.oea63,g_oea.oea65,                            #No.FUN-870007
         g_oea.oea83,g_oea.oea84,g_oea.oea85,g_oea.oea86,g_oea.oea87,    #No.FUN-870007
         g_oea.oeaplant,g_oea.oeaconu,g_oea.oea88,g_oea.oea89,           #No.FUN-870007
         g_oea.oea90,g_oea.oea91,g_oea.oea92,g_oea.oea93,g_oea.oea94,    #No.FUN-870007     #No.FUN-A50071 add oea94
         g_oea.oea25,g_oea.oea26,                                        #No.FUN-870007
         g_oea.oea46,g_oea.oea80,g_oea.oea81,g_oea.oea47,g_oea.oea48,g_oea.oea99, #No.FUN-680022 add  oea80,oea81 #CHI-740014拿掉oea905
         g_oea.oea61,g_oea.oeauser,g_oea.oeagrup,g_oea.oeamodu,g_oea.oeadate,
         g_oea.oeaud01,g_oea.oeaud02,g_oea.oeaud03,g_oea.oeaud04,g_oea.oeaud05,
         g_oea.oeaud06,g_oea.oeaud07,g_oea.oeaud08,g_oea.oeaud09,g_oea.oeaud10,
         g_oea.oeaud11,g_oea.oeaud12,g_oea.oeaud13,g_oea.oeaud14,g_oea.oeaud15    #No:FUN-A50103
#        g_oea.oea918,g_oea.oea919      #FUN-8C0078   #No:FUN-A50103 Mark

           WITHOUT DEFAULTS

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t400_set_entry(p_cmd)
         CALL t400_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("oea01")

      BEFORE FIELD oea00
         CALL t400_set_entry(p_cmd)
         CALL t400_set_no_required()  #FUN-610055

      AFTER FIELD oea00
         IF NOT t400_chk_oea00(p_cmd) THEN
            NEXT FIELD CURRENT
         ELSE
            #-----MOD-A60146---------
            IF NOT t400_chk_oea01() THEN 
               NEXT FIELD oea01
            END IF
            #-----END MOD-A60146-----
            IF NOT cl_null(g_oea.oea00) THEN
               #-----MOD-A50014---------
               IF g_oea.oea00 = '8' THEN                                                                                          
                  LET g_oea.oea11 = '1'                                                                                           
                  DISPLAY BY NAME g_oea.oea11                                                                                     
               END IF                                                                                                             
               #-----END MOD-A50014-----
               #MOD-940234--start--
               IF g_oea.oea00 = '9' THEN
                  LET g_oea.oea11 = '8'
                  DISPLAY BY NAME g_oea.oea11
               END IF
               #MOD-940234--end
               CALL t400_set_required()  #FUN-610055
               CALL t400_set_no_entry(p_cmd)          #FUN-610055
            END IF
         END IF

      BEFORE FIELD oea05
         CALL t400_bfd_oea05()

      #-----MOD-A90080---------
      BEFORE FIELD oea08
         LET g_oea_o.oea08 = g_oea.oea08
      #-----END MOD-A90080-----

      AFTER FIELD oea08
         IF NOT t400_chk_oea08() THEN
             NEXT FIELD CURRENT
         END IF
         #-----MOD-A90080---------
         IF g_oea.oea08 <> g_oea_o.oea08 AND  
            NOT cl_null(g_oea.oea23) AND NOT cl_null(g_oea.oea02) THEN  
            IF cl_confirm('axm-449') THEN 
               IF g_oea.oea08='1' THEN
                  LET exT=g_oaz.oaz52
               ELSE
                  LET exT=g_oaz.oaz70
               END IF
               CALL s_curr3(g_oea.oea23,g_oea.oea02,exT) RETURNING g_oea.oea24
               DISPLAY BY NAME g_oea.oea24
            END IF
         END IF
         #-----END MOD-A90080-----

      AFTER FIELD oea09
         IF NOT cl_null(g_oea.oea09) THEN
            IF g_oea.oea09 < 0 OR g_oea.oea09 > 100 THEN
               CALL cl_err('','aec-002',0)
               NEXT FIELD oea09
            END IF
         END IF

      AFTER FIELD oea01
         IF NOT t400_chk_oea01() THEN
            NEXT FIELD CURRENT
         ELSE
            IF NOT cl_null(g_oea.oea01) THEN
               LET g_t1=s_get_doc_no(g_oea.oea01)
               SELECT oay15
                 INTO g_oea.oea1005
                 FROM oay_file WHERE oayslip = g_t1
               DISPLAY BY NAME g_oea.oea1005  #TQC-650111
            END IF
         END IF

      #MOD-B30347---add--str--
      AFTER FIELD oea02
         IF NOT cl_null(g_oea.oea02) AND g_oea.oea02 != g_oea_t.oea02 THEN
            IF g_oea.oea11 = "3" AND NOT cl_null(g_oea.oea12) THEN
               CALL t400_chk_oea02(g_oea.oea01,g_oea.oea02,g_oea.oea12) RETURNING l_flag
               IF NOT l_flag THEN 
                  CALL cl_err('','apm-815',1)
                  LET g_oea.oea02 = g_oea_t.oea02
                  DISPLAY BY NAME g_oea.oea02
                  NEXT FIELD oea02
               END IF
            END IF
         END IF
      #MOD-B30347---add--end--   

      BEFORE FIELD oea11
         CALL t400_set_entry(p_cmd)
         CALL t400_set_no_required()  #MOD-940234

      AFTER FIELD oea11
         IF NOT t400_chk_oea11(p_cmd) THEN
            NEXT FIELD CURRENT
         ELSE
            CALL t400_set_required()   #MOD-940234
            CALL t400_set_no_entry(p_cmd)          #FUN-610055
         END IF

      BEFORE FIELD oea12
         CALL t400_set_entry(p_cmd)

           AFTER FIELD oea12
              IF NOT cl_null(g_oea.oea12) THEN
                 IF NOT t400_chk_oea12() THEN
                    NEXT FIELD CURRENT
                 ELSE
                   #CALL t400_show() #CHI-A60026 mark
#No.FUN-A40041 --begin
                    CASE WHEN g_oea.oea00 = '0' CALL s_check_no("axm",g_oea.oea01,"","20","oea_file","oea01","") RETURNING li_result,g_oea.oea01
                         WHEN g_oea.oea00 = '1' CALL s_check_no("axm",g_oea.oea01,"","30","oea_file","oea01","") RETURNING li_result,g_oea.oea01
                         WHEN g_oea.oea00 = 'A' CALL s_check_no("axm",g_oea.oea01,"","30","oea_file","oea01","") RETURNING li_result,g_oea.oea01
                         WHEN g_oea.oea00 = '2' CALL s_check_no("axm",g_oea.oea01,"","32","oea_file","oea01","") RETURNING li_result,g_oea.oea01
                         WHEN g_oea.oea00 MATCHES '[37]' CALL s_check_no("axm",g_oea.oea01,"","33","oea_file","oea01","") RETURNING li_result,g_oea.oea01
                         WHEN g_oea.oea00 = '4' CALL s_check_no("axm",g_oea.oea01,"","34","oea_file","oea01","") RETURNING li_result,g_oea.oea01
                         WHEN g_oea.oea00 = '6' CALL s_check_no("axm",g_oea.oea01,"","30","oea_file","oea01","") RETURNING li_result,g_oea.oea01
                         WHEN g_oea.oea00 = '8' CALL s_check_no("axm",g_oea.oea01,"","22","oea_file","oea01","") RETURNING li_result,g_oea.oea01
                         WHEN g_oea.oea00 = '9' CALL s_check_no("axm",g_oea.oea01,"","22","oea_file","oea01","") RETURNING li_result,g_oea.oea01
# 	            CASE WHEN g_oea.oea00 = '0' CALL s_check_no(g_sys,g_oea.oea01,"","20","oea_file","oea01","") RETURNING li_result,g_oea.oea01
# 	                 WHEN g_oea.oea00 = '1' CALL s_check_no(g_sys,g_oea.oea01,"","30","oea_file","oea01","") RETURNING li_result,g_oea.oea01
# 	                 WHEN g_oea.oea00 = 'A' CALL s_check_no(g_sys,g_oea.oea01,"","30","oea_file","oea01","") RETURNING li_result,g_oea.oea01
# 	                 WHEN g_oea.oea00 = '2' CALL s_check_no(g_sys,g_oea.oea01,"","32","oea_file","oea01","") RETURNING li_result,g_oea.oea01
# 	                 WHEN g_oea.oea00 MATCHES '[37]' CALL s_check_no(g_sys,g_oea.oea01,"","33","oea_file","oea01","") RETURNING li_result,g_oea.oea01
# 	                 WHEN g_oea.oea00 = '4' CALL s_check_no(g_sys,g_oea.oea01,"","34","oea_file","oea01","") RETURNING li_result,g_oea.oea01
# 	                 WHEN g_oea.oea00 = '6' CALL s_check_no(g_sys,g_oea.oea01,"","30","oea_file","oea01","") RETURNING li_result,g_oea.oea01
# 	                 WHEN g_oea.oea00 = '8' CALL s_check_no(g_sys,g_oea.oea01,"","22","oea_file","oea01","") RETURNING li_result,g_oea.oea01
# 	                 WHEN g_oea.oea00 = '9' CALL s_check_no(g_sys,g_oea.oea01,"","22","oea_file","oea01","") RETURNING li_result,g_oea.oea01
#No.FUN-A40041 --end
                    END CASE
                    IF (NOT li_result) THEN
                        NEXT FIELD oea01
                    END IF
                 END IF
              END IF
              CALL t400_set_no_entry(p_cmd) #-NO.MOD-610123 add

           BEFORE FIELD oea03
              CALL t400_set_entry(p_cmd)

           AFTER FIELD oea03
              IF NOT t400_chk_oea03(p_cmd) THEN
                 NEXT FIELD CURRENT
              ELSE
                 IF NOT cl_null(g_oea.oea03) THEN
                    IF g_oea.oea03 != g_oea_t.oea03 THEN
                       SELECT COUNT(*) INTO l_n1 FROM oeb_file
                        WHERE oeb01 = g_oea.oea01
                       IF l_n1 > 0 THEN
                          CALL cl_err('','axm-098',1)
                       END IF
                    END IF
                   #CALL t400_show() #CHI-A60026 mark
                    CALL t400_show() #MOD-AC0314 add 
                    CALL t400_set_no_entry(p_cmd)
                 END IF
                 IF g_azw.azw04='2' THEN   #No.FUN-870007
                    CALL t400_oea03('d')   #No.FUN-870007
                 END IF                    #No.FUN-870007
                 
              END IF

           BEFORE FIELD oea032
#開視窗輸入雜項客戶資料
              CALL t400_ioccm()
              IF cl_null(g_oea.oea032) THEN
                 LET g_oea.oea032=g_occm.occm03
              END IF

           AFTER FIELD oea04
              IF NOT T400_chk_oea04(p_cmd) THEN
                 NEXT FIELD CURRENT
              END IF

           AFTER FIELD oea14
             #IF NOT t400_chk_oea14() THEN      #TQC-B10013
              IF NOT t400_chk_oea14(p_cmd) THEN #TQC-B10013
                 NEXT FIELD CURRENT
              END IF

           AFTER FIELD oea15
              IF NOT t400_chk_oea15() THEN
                 NEXT FIELD CURRENT
              END IF

           AFTER FIELD oea1011
              IF NOT t400_chk_oea1011() THEN
                 NEXT FIELD CURRENT
              END IF

           AFTER FIELD oea17
              IF NOT t400_chk_oea17() THEN
                 NEXT FIELD CURRENT
              END IF

           AFTER FIELD oea1002
              IF NOT t400_chk_oea1002() THEN
                 NEXT FIELD CURRENT
              ELSE
                 IF NOT cl_null(g_oea.oea1002) THEN
                    #CALL t400_show() #CHI-A60026 mark
                   #CHI-A60026 add --start--
                    SELECT tqk04,tqk05 INTO g_oea.oea32,g_oea.oea23 FROM tqk_file
                     WHERE tqk01=g_oea.oea03 
                       AND tqk02=g_oea.oea1002
                       AND tqk03=g_oea.oea17
                    DISPLAY BY NAME g_oea.oea32,g_oea.oea23
                   #CHI-A60026 add --end--
                 END IF
              END IF

           AFTER FIELD oea1003
              IF NOT t400_chk_oea1003() THEN
                 NEXT FIELD CURRENT
              END IF

           AFTER FIELD oea1015
              IF NOT t400_chk_oea1015() THEN
                 NEXT FIELD CURRENT
              END IF

           AFTER FIELD oea1004
              IF NOT t400_chk_oea1004() THEN
                 NEXT FIELD CURRENT
              END IF

           AFTER FIELD oea23
               IF NOT t400_chk_oea23(p_cmd) THEN
                  NEXT FIELD CURRENT
               END IF

           AFTER FIELD oea24     #匯率
               IF g_oea.oea23 =g_aza.aza17 THEN
                  LET g_oea.oea24 =1
                  DISPLAY g_oea.oea24  TO oea24
               END IF
               IF g_oea.oea24 <= 0 THEN
                  CALL cl_err(g_oea.oea24,'axm-987',0)
                  NEXT FIELD oea24
               END IF

           AFTER FIELD oea21
               IF NOT t400_chk_oea21(p_cmd) THEN
                  NEXT FIELD CURRENT
               ELSE
                  IF g_chg_oea21 THEN
                     CALL t400_b_fill(' 1=1') #FUN-6C0006
                  END IF
               END IF

           AFTER FIELD oea25
               IF NOT t400_chk_oea25() THEN
                  NEXT FIELD CURRENT
               END IF

           AFTER FIELD oea26
               IF NOT t400_chk_oea26() THEN
                  NEXT FIELD CURRENT
               END IF

           AFTER FIELD oea31
               IF NOT t400_chk_oea31() THEN
                  NEXT FIELD CURRENT
               END IF

           AFTER FIELD oea32
               IF NOT t400_chk_oea32() THEN
                  NEXT FIELD CURRENT
               END IF
              ##-----No:FUN-A50103 Mark-----
              #IF cl_null(g_oea_t.oea32) OR
              #   (g_oea_t.oea32 IS NOT NULL AND (g_oea_t.oea32 <> g_oea.oea32)) THEN
              #    LET g_oea.oea918 = 'N'
              #    LET g_oea.oea919 = 'N'
              #    DISPLAY BY NAME g_oea.oea918
              #    DISPLAY BY NAME g_oea.oea919
              #END IF
              ##-----No:FUN-A50103 Mark END-----
               CALL t400_set_entry(p_cmd)
               CALL t400_set_no_entry(p_cmd)


           AFTER FIELD oea37
              IF NOT s_chk_checkbox(g_oea.oea37) THEN
                  NEXT FIELD CURRENT
              END IF

         AFTER FIELD oea50
              IF NOT s_chk_checkbox(g_oea.oea50) THEN
                  NEXT FIELD CURRENT
              END IF

         BEFORE FIELD oea044
            CALL t400_set_entry('a')

         AFTER FIELD oea044
               IF NOT t400_chk_oea044() THEN
                  NEXT FIELD CURRENT
               END IF

         AFTER FIELD oea41
               IF NOT t400_chk_oea41() THEN
                  NEXT FIELD CURRENT
               END IF

         AFTER FIELD oea42
               IF NOT t400_chk_oea42() THEN
                  NEXT FIELD CURRENT
               END IF

         AFTER FIELD oea43
               IF cl_null(g_oea.oea43) THEN
                  DISPLAY '' TO FORMONLY.oea43_43
               END IF
               IF NOT t400_chk_oea43() THEN
                  NEXT FIELD CURRENT
               ELSE
               	  DISPLAY '' TO FORMONLY.oea43_43
               	  LET l_ged02 = NULL
               	  SELECT ged02 INTO l_ged02 FROM ged_file
               	   WHERE ged01 = g_oea.oea43
               	  DISPLAY l_ged02 TO FORMONLY.oea43_43
               END IF

         AFTER FIELD oea44
               IF NOT t400_chk_oea44() THEN
                  NEXT FIELD CURRENT
               END IF

         AFTER FIELD oea07
           #IF cl_null(g_oea.oea07) THEN             #MOD-AB0233 mark
            IF NOT cl_null(g_oea.oea07) THEN         #MOD-AB0233
               IF g_oea.oea07 NOT MATCHES '[YN]' THEN
                  NEXT FIELd CURRENT
               END IF
              #-MOD-AB0233-add-
               IF g_oea.oea161 = 100 THEN
                  LET g_oea.oea07 = 'N' 
                  DISPLAY BY NAME g_oea.oea07
               END IF
              #-MOD-AB0233-end-
            END IF

         #-----No:FUN-A50103-----
         BEFORE FIELD oea161
            CALL t400_set_no_required()
         #-----No:FUN-A50103 END-----

         AFTER FIELD oea161
            IF g_oea.oea161 < 0 THEN
               CALL cl_err(g_oea.oea161,'aim-223',0)
               NEXT FIELD oea161
            #-----No:FUN-A50103-----
            ELSE
#              IF g_oea.oea261 = 0 THEN            #FUN-A60035
              #IF g_oea.oea261=0 OR cl_null(g_oea.oea261) THEN #FUN-A60035 #TQC-AB0286 mark
               IF g_oea.oea261=0 OR cl_null(g_oea.oea261) OR p_cmd='u' THEN #TQC-AB0286 add
                  LET g_oea.oea261 = g_oea.oea61 * g_oea.oea161/100
                  DISPLAY BY NAME g_oea.oea261  #TQC-AB0286 add
               END IF
            #-----No:FUN-A50103 END-----
            END IF
          #-MOD-AB0233-add-
           IF g_oea.oea161 = 100 THEN
              LET g_oea.oea07 = 'N' 
              DISPLAY BY NAME g_oea.oea07
           END IF
          #-MOD-AB0233-end-
            CALL t400_set_required()

         #-----No:FUN-A50103-----
         BEFORE FIELD oea162
            CALL t400_set_no_required()
         #-----No:FUN-A50103 END-----

         AFTER FIELD oea162
            IF NOT t400_chk_oea162() THEN
               NEXT FIELD CURRENT
            #-----No:FUN-A50103-----
            ELSE
              #IF g_oea.oea262 = 0 THEN  #TQC-AB0286 mark
               IF g_oea.oea262 = 0 OR p_cmd='u' THEN   #TQC-AB0286 add 
                  LET g_oea.oea262 = g_oea.oea61 * g_oea.oea162/100
                  #TQC-AB0286 add ---------------begin---------------
                  DISPLAY BY NAME g_oea.oea262  
                  IF NOT cl_null(g_oea.oea61) AND g_oea.oea61 <> 0 THEN
                     IF g_oea.oea213 = 'Y' THEN
                        LET g_oea.oea263 = g_oea.oea1008 - ( g_oea.oea261 + g_oea.oea262 )
                     ELSE
                        LET g_oea.oea263 = g_oea.oea61 - ( g_oea.oea261 + g_oea.oea262 )
                     END IF
                     IF g_oea.oea263 < 0 THEN
                        CALL cl_err('','axm-967',0)
                        LET g_oea.oea263 = 0
                        DISPLAY BY NAME g_oea.oea263
                        RETURN FALSE
                     ELSE
                        DISPLAY BY NAME g_oea.oea263
                     END IF
                  END IF
                  #TQC-AB0286 add ----------------end----------------
               END IF  
            #-----No:FUN-A50103 END-----
            END IF
            CALL t400_set_required()

         #-----No:FUN-A50103-----
         AFTER FIELD oea261
            IF g_oea.oea261 < 0 THEN
               CALL cl_err(g_oea.oea261,'aim-223',0)
               NEXT FIELD oea261
            END IF

         AFTER FIELD oea262
            IF NOT t400_chk_oea262() THEN
               NEXT FIELD CURRENT
            END IF
         #-----No:FUN-A50103 END-----

         AFTER FIELD oea46        #bugno:7255
            IF NOT t400_chk_oea46() THEN
               NEXT FIELD CURRENT
            END IF

         AFTER FIELD oea47
            IF NOT t400_chk_oea47() THEN
               NEXT FIELD CURRENT
            END IF

          AFTER FIELD oea48
               IF NOT t400_chk_oea48() THEN
                  NEXT FIELD CURRENT
               END IF

          AFTER FIELD oea80
               IF NOT t400_chk_oea80() THEN
                  NEXT FIELD CURRENT
               END IF
              ##-----No:FUN-A50103 Mark-----
              #IF cl_null(g_oea_t.oea80) OR
              #   (g_oea_t.oea80 IS NOT NULL AND (g_oea_t.oea80 <> g_oea.oea80)) THEN
              #    LET g_oea.oea918 = 'N'
              #    DISPLAY BY NAME g_oea.oea918
              #END IF
              ##-----No:FUN-A50103 Mark-----
               CALL t400_set_entry(p_cmd)
               CALL t400_set_no_entry(p_cmd)

          AFTER FIELD oea81
               IF NOT t400_chk_oea81() THEN
                  NEXT FIELD CURRENT
               END IF
               IF cl_null(g_oea_t.oea80) OR
                  (g_oea_t.oea81 IS NOT NULL AND (g_oea_t.oea81 <> g_oea.oea81)) THEN
                   LET g_oea.oea919 = 'N'
                   DISPLAY BY NAME g_oea.oea919
               END IF
               CALL t400_set_entry(p_cmd)
               CALL t400_set_no_entry(p_cmd)
         AFTER FIELD oea84
            IF NOT cl_null(g_oea.oea84) THEN
               IF p_cmd='a' OR (p_cmd='u' AND g_oea.oea84<>g_oea_t.oea84) THEN
                  CALL t400_oea84('d')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_oea.oea84,g_errno,0)
                     LET g_oea.oea84=g_oea_t.oea84
                     DISPLAY BY NAME g_oea.oea84
                  END IF
               END IF
            END IF

         AFTER FIELD oea86
            IF NOT cl_null(g_oea.oea86) THEN
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM tqa_file
                WHERE tqa01=g_oea.oea86 AND tqa03='23' AND tqaacti='Y'
                  IF l_cnt=0 THEN
                     CALL cl_err('','art-251',0)
                     NEXT FIELD oea86
                  END IF
            END IF

         AFTER FIELD oea87
            IF NOT cl_null(g_oea.oea87) THEN
                  LET l_cnt=0
                  SELECT COUNT(*) INTO l_cnt FROM lpj_file
                   WHERE lpj03=g_oea.oea87 AND lpj04<=g_today
                 #   AND lpj05=g_today     AND lpj09='2'                   #TQC-A20058 MARK
                     AND (lpj05 IS NULL OR lpj05>=g_today) AND lpj09='2'   #ADD
                  IF l_cnt=0 THEN
                     CALL cl_err('','art-313',0)
                     NEXT FIELD oea87
                  END IF
            END IF

          AFTER FIELD oeaud01
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oeaud02
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oeaud03
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oeaud04
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oeaud05
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oeaud06
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oeaud07
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oeaud08
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oeaud09
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oeaud10
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oeaud11
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oeaud12
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oeaud13
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oeaud14
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oeaud15
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

         AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET g_oea.oeauser = s_get_data_owner("oea_file") #FUN-C10039
            LET g_oea.oeagrup = s_get_data_group("oea_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT  END IF
            CASE t400_chk_inpoea()
               WHEN "oea12" NEXT FIELD oea12
               WHEN "oea03" NEXT FIELD oea03
               WHEN "oea04" NEXT FIELD oea04
               WHEN "oea14" NEXT FIELD oea14
               WHEN "oea15" NEXT FIELD oea15
               WHEN "oea23" NEXT FIELD oea23
               WHEN "oea25" NEXT FIELD oea25
               WHEN "oea31" NEXT FIELD oea31
               WHEN "oea32" NEXT FIELD oea32
               WHEN "oea21" NEXT FIELD oea21
               WHEN "oea161" NEXT FIELD oea161  #No.TQC-770039
            #MOD-AC0314-----add------str-------------
            OTHERWISE
               IF NOT T400_chk_oea04('a') THEN
                  NEXT FIELD oea04
               END IF
               IF NOT t400_chk_oea17() THEN
                  NEXT FIELD oea17
               END IF
              #IF NOT t400_chk_oea14() THEN    #TQC-B10013
               IF NOT t400_chk_oea14('d') THEN #TQC-B10013
                  NEXT FIELD oea14
               END IF
               IF NOT t400_chk_oea15() THEN
                  NEXT FIELD oea15
               END IF
               IF NOT t400_chk_oea31() THEN
                  NEXT FIELD oea31
               END IF
               IF NOT t400_chk_oea32() THEN
                  NEXT FIELD oea32
               END IF
               IF NOT t400_chk_oea1015() THEN
                  NEXT FIELD oea1015
               END IF
               IF NOT t400_chk_oea1004() THEN
                  NEXT FIELD oea1004
               END IF 
            #MOD-AC0314-----add------end-------------
            END CASE
            #MOD-B30404 add --start--
            IF g_oea.oea24 <= 0 THEN
               CALL cl_err(g_oea.oea24,'axm-987',0)
               NEXT FIELD oea23
            END IF
            #MOD-B30404 add --end--

            #CHI-A60026 add --start--
            IF g_oea.oea02 != g_oea_t.oea02 OR g_oea.oea03 != g_oea_t.oea03 OR g_oea.oea21 != g_oea_t.oea21 
               OR g_oea.oea213 != g_oea_t.oea213 OR g_oea.oea23 != g_oea_t.oea23 OR g_oea.oea24 != g_oea_t.oea24 
               OR g_oea.oea25 != g_oea_t.oea25 OR g_oea.oea31 != g_oea_t.oea31 OR g_oea.oea32 != g_oea_t.oea32 THEN
               SELECT COUNT(*) INTO g_cnt FROM oeb_file
                WHERE oeb01=g_oea.oea01
               IF g_cnt > 0 THEN
                  IF cl_confirm('apm-543') THEN  #是否重新取價
                     LET g_success ='Y'
                     FOR l_ac = 1 TO g_cnt
            #           CALL t400_b_get_price()                  #MOD-B30443 MARK
            ###-MOD-B30443- ADD - BEGIN ------------------------------------------------------------
                        CALL s_fetch_price_new(g_oea.oea03,g_oeb[l_ac].oeb04,g_oeb[l_ac].oeb05,
                                               g_oea.oea02,'1',g_oea.oeaplant,g_oea.oea23,g_oea.oea31,
                                               g_oea.oea32,g_oea.oea01,g_oeb[l_ac].oeb03,
                                               g_oeb[l_ac].oeb12,g_oeb[l_ac].oeb1004,p_cmd)
                           RETURNING g_oeb[l_ac].oeb13,g_oeb[l_ac].oeb37
            ###-MOD-B30443- ADD -  END  ------------------------------------------------------------
            #           LET l_oeb13 = g_oeb17                    #MOD-B30443 MARK
                        LET l_oeb13 = g_oeb[l_ac].oeb13          #MOD-B30443 ADD
                        LET l_oeb17 =l_oeb13
                       #FUN-AB0061 --------add start--------------
            #           LET l_oeb37 = g_oeb37                    #MOD-B30443 MARK
                        LET l_oeb37 = g_oeb[l_ac].oeb37          #MOD-B30443 ADD
                        IF cl_null(l_oeb37) THEN
                           LET l_oeb37 = 0
                        END IF 
                       #FUN-AB0061 --------add end---------------
                        IF cl_null(l_oeb17) THEN
                           LET l_oeb17 =0
                        END IF 
                        LET l_oeb904 =l_oeb13
                        IF cl_null(l_oeb904) THEN
                           LET l_oeb904 =0
                        END IF 
                        #更新單價
                        UPDATE oeb_file SET oeb13 = l_oeb13,
                                            oeb37 = l_oeb37,                  #FUN-AB0061 
                                            oeb17 = l_oeb17,
                                            oeb904 = l_oeb904
                         WHERE oeb01 =g_oea.oea01
                           AND oeb03 = g_oeb[l_ac].oeb03
                        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                           CALL cl_err3("upd","oeb_file",g_oea.oea01,g_oeb[l_ac].oeb03,STATUS,"","upd oeb:",1)
                           LET g_success ='N'
                           EXIT FOR
                        END IF
                     END FOR

                     IF g_success='Y' THEN
                        IF t400_mdet() THEN #更新金額
                           CALL t400_b_fill(' 1=1')
                           CALL t400_oea_sum()  #CHI-A70030
                        END IF
                     END IF
                  END IF
               END IF 
            END IF
            #CHI-A60026 add --end--

        ON ACTION maintain_customer_data
           CALL cl_cmdrun('axmi221')

        ON ACTION controlp
           CASE
              WHEN INFIELD(oea01) #查詢單据
                 LET g_t1=s_get_doc_no(g_oea.oea01)
		 CASE WHEN g_oea.oea00 = '0' LET g_buf='20'
		      WHEN g_oea.oea00 = '1' LET g_buf='30'
		      WHEN g_oea.oea00 = 'A' LET g_buf='30'   #No.FUN-610053
		      WHEN g_oea.oea00 = '2' LET g_buf='32'
		      WHEN g_oea.oea00 = '3' LET g_buf='33'
		      WHEN g_oea.oea00 = '4' LET g_buf='34'
		      WHEN g_oea.oea00 = '6' LET g_buf='30'   #FUN-610055
		      WHEN g_oea.oea00 = '7' LET g_buf='33'   #FUN-610055
		      WHEN g_oea.oea00 = '8' LET g_buf='22'   #No.FUN-740016
		      WHEN g_oea.oea00 = '9' LET g_buf='22'   #No.FUN-740016
		 END CASE
                 CALL q_oay(FALSE,FALSE,g_t1,g_buf,'AXM') RETURNING g_t1  #FUN-610055
                 LET g_oea.oea01=g_t1
                 DISPLAY BY NAME g_oea.oea01
                 NEXT FIELD oea01

              WHEN INFIELD(oea12)
                 CASE g_oea.oea11
                    WHEN '2'
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_oha"
                       LET g_qryparam.default1 = g_oea.oea12
                       CALL cl_create_qry() RETURNING g_oea.oea12
                    WHEN '3'
                       CALL cl_init_qry_var()
                       IF g_aza.aza50='N' THEN
                          LET g_qryparam.form ="q_oea2"
                          LET g_qryparam.default1 = g_oea.oea12
                       ELSE
                          LET g_qryparam.form ="q_tqp03"
#TQC-AB0045 --begin--
#                          LET g_qryparam.arg1 = g_oea.oea03
#                          LET g_qryparam.arg2 = g_plant
                           LET g_qryparam.arg1 = g_plant
#TQC-AB0045 --end--
                          LET g_qryparam.default1 = g_oea.oea12
                       END IF
                       CALL cl_create_qry() RETURNING g_oea.oea12
                    WHEN '4'
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_oqa"
                       LET g_qryparam.default1 = g_oea.oea12
                       CALL cl_create_qry() RETURNING g_oea.oea12
                    WHEN '5'
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_oqt"
                       LET g_qryparam.default1 = g_oea.oea12
                       CALL cl_create_qry() RETURNING g_oea.oea12
                    WHEN '7'
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_oga"
                       LET g_qryparam.default1 = g_oea.oea12
                       CALL cl_create_qry() RETURNING g_oea.oea12
                    WHEN 'A'
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_oea13"
                       LET g_qryparam.default1 = g_oea.oea12
                       CALL cl_create_qry() RETURNING g_oea.oea12
                    WHEN '8'
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_oea14"
                       LET g_qryparam.arg1 ='8'
                       LET g_qryparam.default1 = g_oea.oea12
                       CALL cl_create_qry() RETURNING g_oea.oea12
                    OTHERWISE EXIT CASE
                 END CASE
                 DISPLAY BY NAME g_oea.oea12
                 NEXT FIELD oea12

              WHEN INFIELD(oea1015)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmc8"
                 LET g_qryparam.default1 = g_oea.oea1015
                 CALL cl_create_qry() RETURNING g_oea.oea1015
                 DISPLAY BY NAME g_oea.oea1015
                 NEXT FIELD oea1015
              WHEN INFIELD(oea03)
                 CALL cl_init_qry_var()
                 #-----MOD-A30026---------
                 #LET g_qryparam.form ="q_occ3"   
                 IF g_aza.aza50='Y' THEN  
                    LET g_qryparam.form ="q_occ3" 
                 ELSE 
                    LET g_qryparam.form ="q_occ"  
                 END IF   
                 #-----END MOD-A30026-----
                 LET g_qryparam.default1 = g_oea.oea03
                 CALL cl_create_qry() RETURNING g_oea.oea03
                 DISPLAY BY NAME g_oea.oea03
                 IF g_azw.azw04='2' THEN   #No.FUN-870007
                    CALL t400_oea03('d')   #No.FUN-870007
                 END IF                    #No.FUN-870007
                 NEXT FIELD oea03
              WHEN INFIELD(oea04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_occ4"  #FUN-610055
                 LET g_qryparam.default1 = g_oea.oea04
                 CALL cl_create_qry() RETURNING g_oea.oea04
                 DISPLAY BY NAME g_oea.oea04
                 NEXT FIELD oea04
              WHEN INFIELD(oea14)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gen"
                 LET g_qryparam.default1 = g_oea.oea14
                 CALL cl_create_qry() RETURNING g_oea.oea14
                 DISPLAY BY NAME g_oea.oea14
                 NEXT FIELD oea14
              WHEN INFIELD(oea15)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.default1 = g_oea.oea15
                 CALL cl_create_qry() RETURNING g_oea.oea15
                 DISPLAY BY NAME g_oea.oea15
                 NEXT FIELD oea15
              WHEN INFIELD(oea1011)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_occ7"
                 LET g_qryparam.default1 = g_oea.oea1011
                 CALL cl_create_qry() RETURNING g_oea.oea1011
                 DISPLAY BY NAME g_oea.oea1011
                 NEXT FIELD oea1011
              WHEN INFIELD(oea17)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_occ6"
                 LET g_qryparam.default1 = g_oea.oea17
                 CALL cl_create_qry() RETURNING g_oea.oea17
                 DISPLAY BY NAME g_oea.oea17
                 NEXT FIELD oea17
              WHEN INFIELD(oea1002)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_tqa1"
                 LET g_qryparam.default1 = g_oea.oea1002
                 LET g_qryparam.arg1 = '20'
                 CALL cl_create_qry() RETURNING g_oea.oea1002
                 DISPLAY BY NAME g_oea.oea1002
                 NEXT FIELD oea1002
              WHEN INFIELD(oea1003)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_tqb"
                 LET g_qryparam.default1 = g_oea.oea1003
                 CALL cl_create_qry() RETURNING g_oea.oea1003
                 DISPLAY BY NAME g_oea.oea1003
                 NEXT FIELD oea1003
              WHEN INFIELD(oea1004)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_occ5"
                 LET g_qryparam.default1 = g_oea.oea1004
                 CALL cl_create_qry() RETURNING g_oea.oea1004
                 DISPLAY BY NAME g_oea.oea1004
                 NEXT FIELD oea1004
              WHEN INFIELD(oea21)
                 CALL cl_init_qry_var()
                 IF g_aza.aza26 = '2' THEN             #TQC-A50060  --modify
                    LET g_qryparam.form ="q_gec9"      #TQC-A50060  --modify
                 ELSE                                  #TQC-A50060  --modify
                 LET g_qryparam.form ="q_gec"
                 END IF                                #TQC-A50060  --modify
                 LET g_qryparam.default1 = g_oea.oea21
                 LET g_qryparam.arg1 = '2'
                 CALL cl_create_qry() RETURNING g_oea.oea21
                 DISPLAY BY NAME g_oea.oea21
                 NEXT FIELD oea21
              WHEN INFIELD(oea23)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_oea.oea23
                 CALL cl_create_qry() RETURNING g_oea.oea23
                 DISPLAY BY NAME g_oea.oea23
                 NEXT FIELD oea23
              WHEN INFIELD(oea24)
                   CALL s_rate(g_oea.oea23,g_oea.oea24) RETURNING g_oea.oea24
                   DISPLAY BY NAME g_oea.oea24
                   NEXT FIELD oea24
              WHEN INFIELD(oea25)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oab"
                 LET g_qryparam.default1 = g_oea.oea25
                 CALL cl_create_qry() RETURNING g_oea.oea25
                 DISPLAY BY NAME g_oea.oea25
                 NEXT FIELD oea25
              WHEN INFIELD(oea26)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oab"
                 LET g_qryparam.default1 = g_oea.oea26
                 CALL cl_create_qry() RETURNING g_oea.oea26
                 DISPLAY BY NAME g_oea.oea26
                 NEXT FIELD oea26
              WHEN INFIELD(oea31)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oah"
                 LET g_qryparam.default1 = g_oea.oea31
                 CALL cl_create_qry() RETURNING g_oea.oea31
                 DISPLAY BY NAME g_oea.oea31
                 NEXT FIELD oea31
              WHEN INFIELD(oea32)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oag"
                 LET g_qryparam.default1 =g_oea.oea32
                 CALL cl_create_qry() RETURNING g_oea.oea32
                 DISPLAY BY NAME g_oea.oea32
                 NEXT FIELD oea32
            WHEN INFIELD(oea044)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ocd"
                 LET g_qryparam.default1 = g_oea.oea044
                  LET g_qryparam.arg1     = g_oea.oea04   #No.MOD-480274
                 LET g_qryparam.construct= 'N'
                 CALL cl_create_qry() RETURNING g_oea.oea044
                 DISPLAY BY NAME g_oea.oea044 NEXT FIELD oea044
            WHEN INFIELD(oea41)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oac"
                 LET g_qryparam.default1 = g_oea.oea41
                 CALL cl_create_qry() RETURNING g_oea.oea41
                 DISPLAY BY NAME g_oea.oea41 NEXT FIELD oea41
            WHEN INFIELD(oea42)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oac"
                 LET g_qryparam.default1 = g_oea.oea42
                 CALL cl_create_qry() RETURNING g_oea.oea42
                 DISPLAY BY NAME g_oea.oea42 NEXT FIELD oea42
            WHEN INFIELD(oea43)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ged"
                 LET g_qryparam.default1 = g_oea.oea43
                 CALL cl_create_qry() RETURNING g_oea.oea43
                 DISPLAY BY NAME g_oea.oea43 NEXT FIELD oea43
             WHEN INFIELD(oea44)   #MOD-4A0252
                 CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ocf"   # MOD-580085
                 LET g_qryparam.default1 = g_oea.oea44
                 LET g_qryparam.arg1 = g_oea.oea04
                 CALL cl_create_qry() RETURNING g_oea.oea44
                  DISPLAY BY NAME g_oea.oea44    #No.MOD-490485
                 NEXT FIELD oea44
             WHEN INFIELD(oea46)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pja2"  #FUN-810045
                  LET g_qryparam.default1 = g_oea.oea46
                  CALL cl_create_qry() RETURNING g_oea.oea46
                  DISPLAY BY NAME g_oea.oea46
                  CALL t400_oea46()  #FUN-810045
                  NEXT FIELD oea46
             WHEN INFIELD(oea47)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmc4"
                  LET g_qryparam.default1 = g_oea.oea47
                  LET g_qryparam.arg1 = '4'
                  CALL cl_create_qry() RETURNING g_oea.oea47,l_pmc03  #No.MOD-740365
                  DISPLAY BY NAME g_oea.oea47
                  NEXT FIELD oea47
             WHEN INFIELD(oea48)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ofs"
                  LET g_qryparam.default1 = g_oea.oea48
                  CALL cl_create_qry() RETURNING g_oea.oea48
                  DISPLAY BY NAME g_oea.oea48
                  NEXT FIELD oea48
              WHEN INFIELD(oea80)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oag"
                 LET g_qryparam.default1 =g_oea.oea80
                 CALL cl_create_qry() RETURNING g_oea.oea80
                 DISPLAY BY NAME g_oea.oea80
                 NEXT FIELD oea80
              WHEN INFIELD(oea81)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oag"
                 LET g_qryparam.default1 =g_oea.oea81
                 CALL cl_create_qry() RETURNING g_oea.oea81
                 DISPLAY BY NAME g_oea.oea81
                 NEXT FIELD oea81
              WHEN INFIELD(oea84)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azp"
                 LET g_qryparam.default1 = g_oea.oea84
                 CALL cl_create_qry() RETURNING g_oea.oea84
                 DISPLAY BY NAME g_oea.oea84
                 CALL t400_oea84('d')
                 NEXT FIELD oea84
              WHEN INFIELD(oea86)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.default1 = g_oea.oea86
                 LET g_qryparam.arg1='23'
                 CALL cl_create_qry() RETURNING g_oea.oea86
                 DISPLAY BY NAME g_oea.oea86
                 NEXT FIELD oea86
                 WHEN INFIELD(oea87)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lpj03_1"
                 LET g_qryparam.default1 = g_oea.oea87
                 LET g_qryparam.arg1=g_today
                 CALL cl_create_qry() RETURNING g_oea.oea87
                 DISPLAY BY NAME g_oea.oea87
                 NEXT FIELD oea87

             WHEN INFIELD(oeaud02)
                CALL cl_dynamic_qry() RETURNING g_oea.oeaud02
                DISPLAY BY NAME g_oea.oeaud02
                NEXT FIELD oeaud02
             WHEN INFIELD(oeaud03)
                CALL cl_dynamic_qry() RETURNING g_oea.oeaud03
                DISPLAY BY NAME g_oea.oeaud03
                NEXT FIELD oeaud03
             WHEN INFIELD(oeaud04)
                CALL cl_dynamic_qry() RETURNING g_oea.oeaud04
                DISPLAY BY NAME g_oea.oeaud04
                NEXT FIELD oeaud04
             WHEN INFIELD(oeaud05)
                CALL cl_dynamic_qry() RETURNING g_oea.oeaud05
                DISPLAY BY NAME g_oea.oeaud05
                NEXT FIELD oeaud05
             WHEN INFIELD(oeaud06)
                CALL cl_dynamic_qry() RETURNING g_oea.oeaud06
                DISPLAY BY NAME g_oea.oeaud06
                NEXT FIELD oeaud06
            END CASE
       ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913


        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121


    END INPUT

END FUNCTION

FUNCTION t400_b()
DEFINE
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-680137 VARCHAR(1)
    p_chk           LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)   #處理狀態
    l_allow_insert  LIKE type_file.num5,                 #可新增否  #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5,                 #可刪除否  #No.FUN-680137 SMALLINT
    g_tt_oeb12      LIKE oeb_file.oeb12,  #No.TQC-5B0078
    l_cnt           LIKE type_file.num5,
    l_check_res     LIKE type_file.num5,   #No.FUN-680137 SMALLINT
    l_b2            LIKE cob_file.cob08,    #No.FUN-680137 VARCHAR(30)
    l_ima130        LIKE ima_file.ima130,    #No.FUN-680137 VARCHAR(1)
    l_ima131        LIKE ima_file.ima131,   #No.FUN-680137 VARCHAR(10)
    l_ima25         LIKE ima_file.ima25,
    l_imaacti       LIKE ima_file.imaacti,
    l_qty           LIKE type_file.num10,   #No.FUN-680137 INTEGER
    l_cmd           LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(100)
    l_coc04         LIKE coc_file.coc04,   #No.MOD-4B0275
    l_fac           LIKE oeb_file.oeb05_fac,
    l_m             LIKE type_file.num5,   #No.FUN-810016
    li_result       LIKE type_file.num5,
    l_pjb25         LIKE pjb_file.pjb25,  #FUN-810045
    l_oeo04         LIKE oeo_file.oeo04   #MOD-870139
DEFINE l_oeb03_t   LIKE oeb_file.oeb03   #MOD-A50092

DEFINE l_oeb931     LIKE oeb_file.oeb931  #No.FUN-820046
DEFINE l_oeb932     LIKE oeb_file.oeb932  #No.FUN-820046

    DEFINE l_pjb09  LIKE pjb_file.pjb09    #No.FUN-850027
    DEFINE l_pjb11  LIKE pjb_file.pjb11    #No.FUN-850027
#TQC-A70029 --unmark-- begin--    
   #-----CHI-990037--------
DEFINE l_obk01      LIKE obk_file.obk01
DEFINE l_obk07      LIKE obk_file.obk07
DEFINE l_obk08      LIKE obk_file.obk08
DEFINE l_obk09      LIKE obk_file.obk09
DEFINE l_obk11      LIKE obk_file.obk11
DEFINE l_ima02      LIKE ima_file.ima02
DEFINE l_ima021     LIKE ima_file.ima021
DEFINE l_count      LIKE type_file.num5
    #-----END CHI-990037-----
#TQC-A70029 --unmark-- end--

DEFINE l_occ930 LIKE occ_file.occ930 #No.FUN-870007
DEFINE lc_type  LIKE type_file.chr1  #No.FUN-870007
DEFINE li_ret   LIKE type_file.num5  #No.FUN-870007
DEFINE l_rth03  LIKE rth_file.rth03  #No.FUN-870007
DEFINE l_rtz04  LIKE rtz_file.rtz04  #No.FUN-870007
DEFINE l_oeb05  LIKE oeb_file.oeb05  #NO.FUN-960130   #NO.FUN-9B0016
DEFINE l_sum    LIKE oeb_file.oeb47  #NO.FUN-960130
DEFINE l_oah04  LIKE oah_file.oah04  #NO.FUN-960130
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#DEFINE l_ima151 LIKE ima_file.ima151
#DEFINE l_count  LIKE type_file.num5  
#DEFINE l_ata02  LIKE ata_file.ata02
#DEFINE l_ata04  LIKE ata_file.ata04
#DEFINE l_n1     LIKE type_file.num5
#DEFINE l_n2     LIKE type_file.num5
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END
DEFINE l_ima130_wc STRING #MOD-B30277 add 

   LET g_action_choice = ""
   SELECT * INTO g_oea.* FROM oea_file WHERE oea01 = g_oea.oea01    #mark by liuxqa 091020
   LET g_oea49 = g_oea.oea49          #MOD-4A0299
   IF g_oea.oea01 IS NULL THEN RETURN END IF
   IF g_oea.oeaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_oea.oeaconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   IF g_oea.oea61 > 0 AND g_oea.oea61 = g_oea.oea62 THEN
      CALL cl_err('','axm-162',0)
      RETURN
   END IF
   IF g_oea.oea49 matches '[Ss]' THEN          #MOD-4A0299
      CALL cl_err('','apm-030',0)
      RETURN
   END IF
#FUN-B30012 --------STA
   IF NOT t400_chk_oeb1001_1(g_oea.oea01) THEN
      CALL cl_err('','axm-667',0)
      RETURN
   END IF
#FUN-B30012 --------END

   IF g_sma.sma120 = "N" THEN
      CALL cl_set_act_visible("qry_item",FALSE)
   END IF

#TQC-A80141 --begin--
   LET l_count = 0 
   SELECT COUNT(*) INTO l_count FROM tqp_file
    WHERE tqp01 = g_oea.oea12   
   IF g_oea.oea11='3' AND l_count >0 THEN 
   ELSE 
#TQC-A80141 --end--
      CALL t400_g_b()                 #由合約自動產生單身
   END IF   #TQC-A80141
   
   IF g_oea.oea917 != 'Y' OR cl_null(g_oea.oea917) THEN
   ELSE
      CALL t400_two_uygur()           #FUN-820046 二維單身輸入
   END IF    #No.MOD-8A0267
   CALL cl_opmsg('b')

   SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file     #No.CHI-6A0004
    WHERE azi01=g_oea.oea23

   LET g_forupd_sql = "SELECT * FROM oeb_file ",
                      " WHERE oeb01= ? AND oeb03= ?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t400_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR


    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_oeb WITHOUT DEFAULTS FROM s_oeb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            LET g_before_input_done = FALSE
            LET g_before_input_done = TRUE
            
        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'                   #DEFAULT
           #LET g_chr1 = 'N'    #MOD-870031   #CHI-880006

           CALL t400_set_entry_b('a')          #No.TQC-7C0098
           CALL t400_set_no_entry_b('a','N')   #No.TQC-7C0098
           CALL t400_set_no_required_b()     #MOD-A50014
           CALL t400_set_required_b()     #MOD-A50014
           LET g_value = NULL
           LET g_oeb04 = NULL
           LET g_chr2  = '0'
           LET g_chr3  = '0'
#FUN-AC0097--add--begin 
           IF cl_null(g_oeb[l_ac].oeb49) THEN
              LET g_oeb[l_ac].oeb50 ='' 
           END IF             
#FUN-AC0097--add--end 
            LET l_oeb931 = NULL
            LET l_oeb932 = NULL
            SELECT oeb931,oeb932 INTO l_oeb931,l_oeb932
              FROM oeb_file
             WHERE oeb01 = g_oea.oea01
               AND oeb03 = g_oeb[l_ac].oeb03
            IF g_sma.sma128 = 'Y' AND g_sma.sma115 !='Y' AND
               NOT cl_null(l_oeb931) AND NOT cl_null(l_oeb932) THEN
               CALL cl_set_comp_entry("oeb04,oeb05,oeb31,oeb32,oeb12,oeb15" ,FALSE)
            ELSE
               CALL cl_set_comp_entry("oeb04,oeb05,oeb31,oeb32,oeb12,oeb15" ,TRUE)
            END IF

           BEGIN WORK

           OPEN t400_cl USING g_oea.oea01    #mod by liuxqa 091020
           IF STATUS THEN
              CALL cl_err("OPEN t400_cl:", STATUS, 1)
              CLOSE t400_cl
              ROLLBACK WORK
              RETURN
           END IF

           FETCH t400_cl INTO g_oea.*  # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)     # 資料被他人LOCK
              CLOSE t400_cl
              ROLLBACK WORK
              RETURN
           END IF

           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_oeb_t.* = g_oeb[l_ac].*  #BACKUP
              LET g_tt_oeb12 = g_oeb[l_ac].oeb12   #No.MOD-5C0150
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#             IF g_oea.oeaslk02 = 'Y' THEN
#                DECLARE t400_ata1 SCROLL CURSOR FOR
#                 SELECT ata02,ata03,ata04 FROM ata_file 
#                  WHERE ata00=g_prog
#                    AND ata01=g_oea.oea01
#                    AND ata02=g_oeb_t.oeb03
#                FOREACH t400_ata1 INTO l_ata02,g_oeb_t.oeb03,l_ata04
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END
                    OPEN t400_bcl USING g_oea.oea01,g_oeb_t.oeb03
                    IF STATUS THEN
                       CALL cl_err("OPEN t400_bcl:", STATUS, 1)
                       LET l_lock_sw = "Y"
                    ELSE
                       FETCH t400_bcl INTO b_oeb.*
                       IF SQLCA.sqlcode THEN
                          CALL cl_err('lock oeb',SQLCA.sqlcode,1)
                          LET l_lock_sw = "Y"
                       ELSE
                      END IF
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifndef SLK
##FUN-A50054 --End
#FUN-A60035 ---MARK END
                      CALL t400_b_move_to() #MOD-4A0299
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END
                   END IF
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#               END FOREACH
#               LET b_oeb.oeb03 = l_ata02
#               LET b_oeb.oeb04 = l_ata04
#               LET g_oeb_t.* = g_oeb[l_ac].*
#            END IF
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END
              LET g_change = 'N' #No.FUN-540049
              LET g_change1= 'N' #No.FUN-540049
             #後續的欄位檢查需要用到l_ima25,所以必須先讀取料件資料
              CALL t400_chk_oeb04_1(p_cmd) RETURNING
                   l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,
                   g_buf2,l_ima25,l_imaacti,l_qty
              IF g_aza.aza50 = 'Y' THEN  #No.FUN-650108
                 CALL t400_set_entry_b(p_cmd)          #No.FUN-610055
                 CALL t400_set_no_entry_b(p_cmd,'N')   #No.FUN-610055
              END IF
              IF g_azw.azw04='2' THEN                   #No.FUN-870007
                 CALL t400_set_entry_b(p_cmd)           #No.FUN-870007
                 CALL t400_set_no_entry_b(p_cmd,'N')    #No.FUN-870007
              END IF                                    #No.FUN-870007
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
           CALL cl_set_comp_entry("oeb13",FALSE)
         # CALL cl_set_comp_entry("oeb13",TRUE)    #NO.FUN-960130   #TQC-A20002 mark
           LET g_oeb17   = b_oeb.oeb17             #TQC-AB0204
           LET g_oeb17_t = b_oeb.oeb17             #TQC-AB0204

        BEFORE INSERT
           LET p_cmd='a'
           CALL t400_b_bef_ins()
           LET g_tt_oeb12 = g_oeb[l_ac].oeb12   #No.MOD-5B0078
           LET g_oeb17   = '' #TQC-AB0204
           LET g_oeb17_t = '' #TQC-AB0204
           NEXT FIELD oeb03

        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF

           CASE t400_b_inschk()
              WHEN "oeb71"   # NEXT FIELD oeb71  #TQC-AA0139 move to "confirm" to check
              WHEN "oeb04"   # NEXT FIELD oeb04  #TQC-AA0139 move to "confirm" to check              
              WHEN "oeb32"   # NEXT FIELD oeb32   #No.FUN-A80024      #TQC-AA0139         
           END CASE


           LET l_occ930=''
           SELECT occ930 INTO l_occ930 FROM occ_file WHERE occ01=g_oea.oea03
           IF cl_null(l_occ930) THEN
              LET lc_type='1' #外部客戶
           ELSE
              LET lc_type='2' #內部客戶
           END IF
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#           IF g_oea.oeaslk02 <> 'Y' THEN
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END
           IF g_oea.oea213 = 'N' THEN
              LET g_oeb[l_ac].oeb14 = t400_amount(g_oeb[l_ac].oeb917,g_oeb[l_ac].oeb13,g_oeb[l_ac].oeb1006,t_azi03)
              CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04)  RETURNING g_oeb[l_ac].oeb14
              LET g_oeb[l_ac].oeb14t= g_oeb[l_ac].oeb14*(1+ g_oea.oea211/100)
              CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t
           ELSE
              LET g_oeb[l_ac].oeb14t= t400_amount(g_oeb[l_ac].oeb917,g_oeb[l_ac].oeb13,g_oeb[l_ac].oeb1006,t_azi03)
              CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t
              LET g_oeb[l_ac].oeb14 = g_oeb[l_ac].oeb14t/(1+ g_oea.oea211/100)
              CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04)  RETURNING g_oeb[l_ac].oeb14
           END IF
           #計算折價
           SELECT SUM(rxc06) INTO l_sum FROM rxc_file WHERE rxc00 = '01'
                                             AND rxc01 = g_oea.oea01
                                             AND rxc02 = g_oeb[l_ac].oeb03
           IF l_sum IS NULL THEN LET l_sum = 0 END IF
           UPDATE oeb_file SET oeb47 = l_sum WHERE oeb01 = g_oea.oea01 AND oeb03 = g_oeb[l_ac].oeb03
           LET g_oeb[l_ac].oeb47 = l_sum
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#           END IF
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END
           CALL t400_b_move_back() #No.MOD-7A0063 add
           IF NOT t400_b_ins() THEN
              CANCEL INSERT
           ELSE
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn3
              IF g_aza.aza50 = 'N' THEN  #No.FUN-650108
                 CALL t400_bu()     #FUN-610055
              ELSE   #No.FUN-650108
                 CALL t400_oea_sum()  #FUN-610055
                 CALL t400_weight_cubage()
              END IF #No.FUN-650108
              COMMIT WORK
           END IF

        BEFORE FIELD oeb03                            #default 序號
           CALL t400_bef_oeb03(p_cmd)
           LET l_oeb03_t = g_oeb[l_ac].oeb03   #MOD-A50092

        AFTER FIELD oeb03                        #check 序號是否重複
           CALL t400_chk_oeb03(p_cmd,p_chk) RETURNING l_check_res,p_chk
           IF NOT l_check_res THEN
              NEXT FIELD CURRENT
           ELSE    #MOD-870031
              CALL t400_set_no_entry_b(p_cmd,p_chk)   #MOD-870031
           END IF
           #-----MOD-A50092---------
           IF l_oeb03_t <> g_oeb[l_ac].oeb03 THEN 
              LET l_cnt = 0 
              SELECT COUNT(*) INTO l_cnt FROM oeo_file
                WHERE oeo01 = g_oea.oea01 AND oeo03 = l_oeb03_t
              IF l_cnt > 0 THEN  
                 IF cl_confirm('axm0002') THEN
                    UPDATE oeo_file SET oeo03 = g_oeb[l_ac].oeb03
                      WHERE oeo01 = g_oea.oea01 AND oeo03 = l_oeb03_t
                 ELSE
                    DELETE FROM oeo_file 
                      WHERE oeo01 = g_oea.oea01 AND oeo03 = l_oeb03_t
                 END IF 
              END IF
           END IF
           LET l_oeb03_t = g_oeb[l_ac].oeb03   
           #-----END MOD-A50092-----
           IF g_oeb[l_ac].oeb03<=0 THEN
              CALL cl_err('','aim-223',0)
              LET g_oeb[l_ac].oeb03=g_oeb_t.oeb03
              NEXT FIELD oeb03
           END IF

        BEFORE FIELD oeb71   #No.MOD-570251
           CALL t400_set_entry_b(p_cmd)

        AFTER FIELD oeb71
           IF NOT t400_chk_oeb71(p_cmd,p_chk) THEN
              NEXT FIELD CURRENT
           ELSE
              CALL t400_set_no_entry_b(p_cmd,p_chk)   #No.MOD-570251
           END IF

#TQC-A70029 --unmark --begin--
      #-----CHI-990037---------
      AFTER FIELD oeb11
        IF NOT cl_null(g_oeb[l_ac].oeb11) THEN
          SELECT COUNT(*) INTO l_count FROM obk_file
            WHERE obk03 = g_oeb[l_ac].oeb11
              AND obk05 = g_oea.oea23            #TQC-A70029 add            
           IF cl_null(g_oeb[l_ac].oeb04) THEN
              SELECT UNIQUE obk01,obk07,obk08,obk09,obk11
                INTO l_obk01,l_obk07,l_obk08,l_obk09,l_obk11
                FROM obk_file
               WHERE obk03 = g_oeb[l_ac].oeb11
                 AND obk05 = g_oea.oea23       #TQC-A70029 add               
              LET g_oeb[l_ac].oeb04  = l_obk01
              #-----MOD-AA0054---------
              CALL t400_chk_oeb04_1(p_cmd) RETURNING 
                   l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,
                   g_buf2,l_ima25,l_imaacti,l_qty 
              #-----END MOD-AA0054-----
              LET g_oeb[l_ac].oeb05  = l_obk07
              LET g_oeb[l_ac].oeb12  = l_obk09
              LET g_oeb[l_ac].oeb13  = l_obk08
              LET g_oeb[l_ac].oeb37  = l_obk08      #FUN-AB0061
              CALL t400_set_oeb917()   #MOD-AA0180
              IF g_oea.oea00<>'4' THEN #CHI-970074
                 LET g_oeb[l_ac].oeb906 = l_obk11
                 IF cl_null(g_oeb[l_ac].oeb906) THEN   #MOD-A80124
                    LET g_oeb[l_ac].oeb906 = 'N'   #MOD-A80124
                 END IF   #MOD-A80124
              ELSE #CHI-970074
                 LET g_oeb[l_ac].oeb906 = 'N' #CHI-970074
              END IF  #CHI-970074
              SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
               WHERE ima01 = g_oeb[l_ac].oeb04
              LET g_oeb[l_ac].oeb06 = l_ima02
              LET g_oeb[l_ac].ima021 = l_ima021
              CALL t400_oea01()  #FUN-A80054
              DISPLAY BY NAME g_oeb[l_ac].oeb04,g_oeb[l_ac].oeb05,g_oeb[l_ac].oeb12,
                              g_oeb[l_ac].oeb13,g_oeb[l_ac].oeb906,g_oeb[l_ac].oeb06,
                              g_oeb[l_ac].oeb37,                                       #FUN-AB0061 
                              g_oeb[l_ac].ima021,g_oeb[l_ac].oeb918    #FUN-A80054
           END IF
        END IF
      #-----END CHI-990037-----
#TQC-A70029 --unmark --begin--

        BEFORE FIELD oeb1001
           CALL t400_set_entry_b(p_cmd)

        AFTER FIELD oeb1001
           IF NOT t400_chk_oeb1001(p_cmd,p_chk) THEN
              NEXT FIELD CURRENT
           ELSE
              CALL t400_set_no_entry_b(p_cmd,p_chk)   #FUN-610055
           END IF
# No.FUN-AA0057--add--begin
       AFTER FIELD oeb49,oeb50
#FUN-AC0097--add--begin
       IF NOT  cl_null(g_oeb[l_ac].oeb49) THEN
          SELECT lnt04 INTO g_oeb[l_ac].oeb50
          FROM lnt_file   WHERE lnt06 = g_oeb[l_ac].oeb49 AND lntplant = g_oea.oea83
                                AND lnt26 = 'Y' AND g_oea.oea02 BETWEEN lnt17 AND lnt18
       END IF
#FUN-AC0097--add--end
       IF NOT  cl_null(g_oeb[l_ac].oeb49)  THEN
          SELECT COUNT(*) INTO g_cnt
          FROM lnt_file WHERE lnt04 = g_oeb[l_ac].oeb50
                        AND lnt06 = g_oeb[l_ac].oeb49 AND lntplant = g_oea.oea83
                        AND lnt26 = 'Y' AND g_oea.oea02 BETWEEN lnt17 AND lnt18
          IF g_cnt = 0 THEN
             CALL cl_err('','axm_609',0)
             NEXT FIELD oeb49
          END IF
       END IF
# No.FUN-AA0057--add--end
#FUN-AC0097--add--begin    
       IF cl_null(g_oeb[l_ac].oeb49) THEN
          LET g_oeb[l_ac].oeb50 =''
       END IF  
#FUN-AC0097--add--end  
        BEFORE FIELD oeb04
           #LET g_chr1 = 'N'  #No.FUN-640074   #CHI-880006
           CALL t400_set_entry_b(p_cmd)
           CALL t400_set_no_required_b()  #FUN-610055


        AFTER FIELD oeb04
          IF NOT cl_null(g_oeb[l_ac].oeb04) THEN         #FUN-AA0047
#NO.FUN-A90048 add -----------start--------------------     
#          IF NOT s_chk_item_no(g_oeb[l_ac].oeb04,'') THEN
#             CALL cl_err('',g_errno,1)
#             LET g_oeb[l_ac].oeb04 = g_oeb_t.oeb04 
#             NEXT FIELD oeb04
#          END IF
#NO.FUN-A90048 add ------------end --------------------  
#FUN-A60035 ---MARK BEGIN
#       #FUN-A50054---Begin
#   &ifdef SLK
#        IF g_oea.oeaslk02 = 'Y' THEN
#           IF p_cmd='a' OR (p_cmd='u' AND g_oeb[l_ac].oeb04!=g_oeb_t.oeb04) THEN
#              SELECT COUNT(*)
#                INTO l_count
#                FROM ata_file
#                WHERE ata00 = g_prog
#                  AND ata01 = g_oea.oea01
#                  AND ata05 = g_oeb[l_ac].oeb04
#               IF l_count>0  THEN
#                  CALL cl_err('','aim1100',0)
#                  NEXT FIELD oeb04
#               END IF
#            END IF
#         END IF
#   &endif
#       #FUN-A50054---end
#FUN-A60035 ---MARK END

           DECLARE oeo_cs CURSOR FOR
              SELECT oeo04 FROM oeo_file
                WHERE oeo01 = g_oea.oea01
                  AND oeo03 = g_oeb[l_ac].oeb03
           FOREACH oeo_cs INTO l_oeo04
              IF g_oeb[l_ac].oeb04 = l_oeo04 THEN
                 CALL cl_err('','axm-091',0)
                 NEXT FIELD oeb04
              END IF
           END FOREACH
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#         SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01= g_oeb[l_ac].oeb04
#         IF g_sma.sma120='Y' AND l_ima151='Y' AND g_oea.oeaslk02 = 'Y' THEN
#            CALL cl_set_comp_entry("oeb12",FALSE)
#            IF g_sma.sma120='Y' THEN
#            #CALL cl_set_comp_visible("att01,att01_c,att02,att02_c,
#            #                         att03,att03_c,att04,att04_c,
#            #                         att05,att05_c,att06,att06_c,
#            #                         att07,att07_c,att08,att08_c,
#            #                         att09,att09_c,att10,att10_c",FALSE)
#                CALL t400_chk_oeb04_1(p_cmd) RETURNING
#                     l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,
#                      g_buf2,l_ima25,l_imaacti,l_qty  #後續的欄位檢查需要用到l_qty,所以必須回傳來 
#                IF NOT l_check_res THEN
#                   NEXT FIELD CURRENT
#                END IF
#                IF NOT cl_null(g_oeb[l_ac].oeb04) THEN 
#                  IF g_oeb_t.oeb04 <> g_oeb[l_ac].oeb04 THEN 
#                     DELETE FROM oeb_file
#                      WHERE oeb01=g_oea.oea01
#                        AND oeb03 IN 
#                      (SELECT ata03 FROM ata_file
#                        WHERE ata00=g_prog
#                        AND ata01=g_oea.oea01
#                        AND ata02=g_oeb[l_ac].oeb03)
#                     DELETE FROM oebi_file
#                      WHERE oebi01=g_oea.oea01
#                        AND oebi03 IN 
#                      (SELECT ata03 FROM ata_file
#                        WHERE ata00=g_prog
#                        AND ata01=g_oea.oea01
#                        AND ata02=g_oeb[l_ac].oeb03)
#                     DELETE FROM ata_file 
#                      WHERE ata00=g_prog 
#                        AND ata01=g_oea.oea01 
#                        AND ata02=g_oeb[l_ac].oeb03
#                  END IF
#                  CALL s_detail(g_prog,g_oea.oea01,g_oeb[l_ac].oeb03,g_oeb[l_ac].oeb04,'N') #FUN-A50054
#                       RETURNING g_oeb[l_ac].oeb12
#                  DISPLAY BY NAME g_oeb[l_ac].oeb12
#                 END IF 
#            END IF
#         ELSE
##&endif
#              CALL cl_set_comp_entry("oeb12",TRUE)   #FUN-A50054 add
#             CALL t400_chk_oeb04_1(p_cmd) RETURNING
#                  l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,
#                   g_buf2,l_ima25,l_imaacti,l_qty  #後續的欄位檢查需要用到l_qty,所以必須回傳來 
#             IF NOT l_check_res THEN
#                NEXT FIELD CURRENT
#             END IF
##FUN-A60035 ---MARK BEGIN
#&ifdef SLK
#          END IF
#&endif
##FUN-A50054 --End 
#FUN-A60035 ---MARK END
           CALL t400_chk_oeb04_1(p_cmd) RETURNING
              l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,
              g_buf2,l_ima25,l_imaacti,l_qty  #後續的欄位檢查需要用到l_qty,所以必須回傳來
           IF NOT l_check_res THEN
              NEXT FIELD CURRENT
           END IF
#MOD-AC0316 ------------------STA
           IF NOT s_chk_item_no(g_oeb[l_ac].oeb04,'') THEN
              CALL cl_err('',g_errno,1)
              LET g_oeb[l_ac].oeb04 = g_oeb_t.oeb04
              NEXT FIELD oeb04
           END IF
#MOD-AC0316 ------------------END
           IF NOT s_chkima08(g_oeb[l_ac].oeb04) THEN
              NEXT FIELD CURRENT
           END IF
           #FUN-A80054--begin--add----------
           CALL t400_oea01()  #FUN-A80054
           END IF                                           #FUN-AA0047
           IF NOT cl_null(g_oeb[l_ac].oeb04) AND NOT cl_null(g_oeb[l_ac].oeb918) THEN
              LET l_cnt=0
              SELECT COUNT(*) INTO l_cnt FROM eda_file,edb_file
               WHERE eda01=edb01 AND edaconf='Y'
                 AND edb03=g_oeb[l_ac].oeb04
                 AND edb01=g_oeb[l_ac].oeb918
              IF l_cnt = 0 THEN NEXT FIELD oeb918 END IF
           END IF
           #FUN-A80054--end-add------------
              
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef  SLK
##       END IF
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END

        #FUN-A80054--begin--add-----
        AFTER FIELD oeb918
          IF NOT cl_null(g_oeb[l_ac].oeb918) THEN
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt FROM eda_file,edb_file
              WHERE edb03=g_oeb[l_ac].oeb04
                AND edb01=g_oeb[l_ac].oeb918
                AND edb01=eda01 AND edaconf='Y'
             IF l_cnt = 0 THEN
                CALL cl_err(g_oeb[l_ac].oeb918,'aec-057',1)
                NEXT FIELD oeb918
             END IF
          END IF
        #FUN-A80054--end--add-------

        BEFORE FIELD att00
           CALL t400_bef_att00()

        #  以下是為料件多屬性機制新增的20個屬性欄位的AFTER FIELD代碼
        #下面是十個輸入型屬性欄位的判斷語句
        AFTER FIELD att00
            #檢查att00里面輸入的母料件是否是符合對應屬性組的母料件
            SELECT COUNT(ima01) INTO l_cnt FROM ima_file
              WHERE ima01 = g_oeb[l_ac].att00 AND imaag = lg_oay22
            IF l_cnt = 0 THEN
               CALL cl_err_msg('','aim-909',lg_oay22,0)
               NEXT FIELD CURRENT
            END IF

            LET g_oeb04 = g_oeb[l_ac].att00  #No.TQC-640171

            #如果設置為不允許新增
            IF g_sma.sma908 <> 'Y' AND g_sma.sma120 = 'Y' THEN  #No.MOD-850198
               CALL t400_check_oeb04('imx00',l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                ,l_qty   #TQC-690041 add
               IF NOT l_check_res THEN NEXT FIELD CURRENT END IF
            END IF

        AFTER FIELD att01
            CALL t400_check_att0x(g_oeb[l_ac].att01,1,l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
            IF NOT l_check_res THEN NEXT FIELD att01 END IF
        AFTER FIELD att02
            CALL t400_check_att0x(g_oeb[l_ac].att02,2,l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
            IF NOT l_check_res THEN NEXT FIELD att02 END IF
        AFTER FIELD att03
            CALL t400_check_att0x(g_oeb[l_ac].att03,3,l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
            IF NOT l_check_res THEN NEXT FIELD att03 END IF
        AFTER FIELD att04
            CALL t400_check_att0x(g_oeb[l_ac].att04,4,l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
            IF NOT l_check_res THEN NEXT FIELD att04 END IF
        AFTER FIELD att05
            CALL t400_check_att0x(g_oeb[l_ac].att05,5,l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
            IF NOT l_check_res THEN NEXT FIELD att05 END IF
        AFTER FIELD att06
            CALL t400_check_att0x(g_oeb[l_ac].att06,6,l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
            IF NOT l_check_res THEN NEXT FIELD att06 END IF
        AFTER FIELD att07
            CALL t400_check_att0x(g_oeb[l_ac].att07,7,l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
            IF NOT l_check_res THEN NEXT FIELD att07 END IF
        AFTER FIELD att08
            CALL t400_check_att0x(g_oeb[l_ac].att08,8,l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
            IF NOT l_check_res THEN NEXT FIELD att08 END IF
        AFTER FIELD att09
            CALL t400_check_att0x(g_oeb[l_ac].att09,9,l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
            IF NOT l_check_res THEN NEXT FIELD att09 END IF
        AFTER FIELD att10
            CALL t400_check_att0x(g_oeb[l_ac].att10,10,l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
            IF NOT l_check_res THEN NEXT FIELD att10 END IF
        #下面是十個輸入型屬性欄位的判斷語句
        AFTER FIELD att01_c
            CALL t400_check_att0x_c(g_oeb[l_ac].att01_c,1,l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
            IF NOT l_check_res THEN NEXT FIELD att01_c END IF
        AFTER FIELD att02_c
            CALL t400_check_att0x_c(g_oeb[l_ac].att02_c,2,l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
            IF NOT l_check_res THEN NEXT FIELD att02_c END IF
        AFTER FIELD att03_c
            CALL t400_check_att0x_c(g_oeb[l_ac].att03_c,3,l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
            IF NOT l_check_res THEN NEXT FIELD att03_c END IF
        AFTER FIELD att04_c
            CALL t400_check_att0x_c(g_oeb[l_ac].att04_c,4,l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
            IF NOT l_check_res THEN NEXT FIELD att04_c END IF
        AFTER FIELD att05_c
            CALL t400_check_att0x_c(g_oeb[l_ac].att05_c,5,l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
            IF NOT l_check_res THEN NEXT FIELD att05_c END IF
        AFTER FIELD att06_c
            CALL t400_check_att0x_c(g_oeb[l_ac].att06_c,6,l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
            IF NOT l_check_res THEN NEXT FIELD att06_c END IF
        AFTER FIELD att07_c
            CALL t400_check_att0x_c(g_oeb[l_ac].att07_c,7,l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
            IF NOT l_check_res THEN NEXT FIELD att07_c END IF
        AFTER FIELD att08_c
            CALL t400_check_att0x_c(g_oeb[l_ac].att08_c,8,l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
            IF NOT l_check_res THEN NEXT FIELD att08_c END IF
        AFTER FIELD att09_c
            CALL t400_check_att0x_c(g_oeb[l_ac].att09_c,9,l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
            IF NOT l_check_res THEN NEXT FIELD att09_c END IF
        AFTER FIELD att10_c
            CALL t400_check_att0x_c(g_oeb[l_ac].att10_c,10,l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
            IF NOT l_check_res THEN NEXT FIELD att10_c END IF

       BEFORE FIELD oeb906
          CALL t400_bef_oeb04()

       AFTER FIELD oeb092
          IF NOT t400_chk_oeb092() THEN
             NEXT FIELD CURRENT
          END IF

       AFTER FIELD oeb05
           IF NOT t400_chk_oeb05(l_ima25) THEN
              NEXT FIELD CURRENT
           END IF
           IF NOT cl_null(g_oeb[l_ac].oeb05) THEN
             #CALL t400_fetch_price('a')   #FUN-AC0012
              CALL t400_fetch_price(p_cmd) #FUN-AC0012
           END IF

       AFTER FIELD oeb12
          IF NOT t400_chk_oeb12(p_cmd,l_qty,g_tt_oeb12) THEN
             NEXT FIELD CURRENT
          END IF
           IF NOT cl_null(g_oeb[l_ac].oeb05) THEN
             #CALL t400_fetch_price('a')   #FUN-AC0012
              CALL t400_fetch_price(p_cmd) #FUN-AC0012
           END IF
#TQC-AA0025 --begin--  
         IF NOT cl_null(g_oeb[l_ac].oeb04) AND NOT cl_null(g_oeb[l_ac].oeb15) 
            AND g_aza.aza50 = 'Y' THEN  
            CALL t400_price(l_ac) RETURNING l_fac
         END IF
#TQC-AA0025 --end--               
          LET g_tt_oeb12 = g_oeb[l_ac].oeb12   #No.MOD-5B0078

      ON CHANGE oeb12
         IF g_sma.sma116 MATCHES '[01]' THEN     #No.TQC-640013
            LET g_oeb[l_ac].oeb916=g_oeb[l_ac].oeb05
            LET g_oeb[l_ac].oeb917=g_oeb[l_ac].oeb12
            DISPLAY BY NAME g_oeb[l_ac].oeb916,g_oeb[l_ac].oeb917
         END IF

        BEFORE FIELD oeb913
           IF NOT cl_null(g_oeb[l_ac].oeb04) THEN
              SELECT ima25,ima31 INTO g_ima25,g_ima31
                FROM ima_file
               WHERE ima01=g_oeb[l_ac].oeb04
           END IF
           CALL t400_set_no_required_b() #FUN-610055
           SELECT DISTINCT oah04 INTO l_oah04 FROM oah_file WHERE oah01 = g_oea.oea31
           IF l_oah04 = 'N' THEN
              CALL cl_set_comp_entry("oeb13,oeb14,oeb14t",FALSE)  #FUN-9B0025 09/12/09 add oeb14,oeb14t
           ELSE
              CALL cl_set_comp_entry("oeb13,oeb14,oeb14t",TRUE)   #FUN-9B0025 09/12/09 add oeb14,oeb14t
           END IF


        AFTER FIELD oeb913  #第二單位
           IF NOT t400_chk_oeb913() THEN
              NEXT FIELD CURRENT
           END IF

        AFTER FIELD oeb914  #第二轉換率
           IF (g_oeb_t.oeb914 IS NULL AND g_oeb[l_ac].oeb914 IS NOT NULL) OR #CHI-960007 add()
              (g_oeb_t.oeb914 IS NOT NULL AND g_oeb[l_ac].oeb914 IS NULL) OR #CHI-960007 add()
              (g_oeb_t.oeb914 <> g_oeb[l_ac].oeb914) THEN #CHI-960007 add()
              LET g_change1='Y'
           END IF
           IF NOT cl_null(g_oeb[l_ac].oeb914) THEN
              IF g_oeb[l_ac].oeb914=0 THEN
                 NEXT FIELD CURRENT
              END IF
           END IF

        AFTER FIELD oeb915  #第二數量
          #IF NOT t400_chk_oeb915() THEN      #FUN-AC0012
           IF NOT t400_chk_oeb915(p_cmd) THEN #FUN-AC0012
              NEXT FIELD CURRENT
           END IF

        BEFORE FIELD oeb910
           IF NOT cl_null(g_oeb[l_ac].oeb04) THEN
              SELECT ima25,ima31 INTO g_ima25,g_ima31
                FROM ima_file
               WHERE ima01=g_oeb[l_ac].oeb04
           END IF
           CALL t400_set_no_required_b()  #FUN-610055

        AFTER FIELD oeb910  #第一單位
           IF NOT t400_chk_oeb910() THEN
              NEXT FIELD CURRENT
           END IF

        AFTER FIELD oeb911  #第一轉換率
           IF (g_oeb_t.oeb911 IS NULL AND g_oeb[l_ac].oeb911 IS NOT NULL) OR #CHI-960007 add()
              (g_oeb_t.oeb911 IS NOT NULL AND g_oeb[l_ac].oeb911 IS NULL) OR #CHI-960007 add()
              (g_oeb_t.oeb911 <> g_oeb[l_ac].oeb911) THEN #CHI-960007 add()
              LET g_change1='Y'
           END IF
           IF NOT cl_null(g_oeb[l_ac].oeb911) THEN
              IF g_oeb[l_ac].oeb911=0 THEN
                 NEXT FIELD CURRENT
              END IF
           END IF

        AFTER FIELD oeb912  #第一數量
          #IF NOT t400_chk_oeb912() THEN      #FUN-AC0012
           IF NOT t400_chk_oeb912(p_cmd) THEN #FUN-AC0012
              NEXT FIELD CURRENT
           END IF
           IF g_oeb[l_ac].oeb1012 = 'Y' AND g_aza.aza50 = 'Y' THEN  #No.TQC-740323
              LET g_oeb[l_ac].oeb14=0
              LET g_oeb[l_ac].oeb14t=0
              DISPLAY BY NAME g_oeb[l_ac].oeb14
              DISPLAY BY NAME g_oeb[l_ac].oeb14t
           END IF

        BEFORE FIELD oeb916
           IF NOT cl_null(g_oeb[l_ac].oeb04) THEN
              SELECT ima25,ima31 INTO g_ima25,g_ima31
                FROM ima_file WHERE ima01=g_oeb[l_ac].oeb04
           END IF
           CALL t400_set_no_required_b()  #FUN-610055

        AFTER FIELD oeb916  #計價單位
           IF NOT t400_chk_oeb916() THEN
              NEXT FIELD CURRENT
           END IF
           IF NOT cl_null(g_oeb[l_ac].oeb04) THEN  #No.FUN-650108
             IF g_aza.aza50='Y' THEN
              IF g_oeb_t.oeb916 IS NULL OR g_oeb_t.oeb916 <> g_oeb[l_ac].oeb916 THEN
                 IF g_change1='Y' THEN
                    CALL t400_set_oeb917()
                 END IF
              #CALL t400_fetch_price('a') #NO.FUN-960130 #FUN-AC0012
               CALL t400_fetch_price(p_cmd) #FUN-AC0012
              END IF
             END IF
           END IF

        BEFORE FIELD oeb917
           IF g_change1='Y' THEN
              CALL t400_set_oeb917()
           END IF

        AFTER FIELD oeb917  #計價數量
           IF NOT t400_chk_oeb917() THEN
              NEXT FIELD CURRENT
           END IF
          			
        AFTER FIELD oeb1004
           IF NOT t400_chk_oeb1004() THEN
              NEXT FIELD CURRENT
           END IF
           IF NOT cl_null(g_oeb[l_ac].oeb1004) THEN
             #CALL t400_fetch_price('a')   #FUN-AC0012
              CALL t400_fetch_price(p_cmd) #FUN-AC0012
           END IF

        BEFORE FIELD oeb13
	
           IF g_azw.azw04<>'2' THEN   #No.FUN-870007
           CASE t400_bef_oeb13(p_cmd,l_qty)
              WHEN "oeb915" NEXT FIELD oeb915
              WHEN "oeb912" NEXT FIELD oeb912
           END CASE
           END IF    #No.FUN-870007


        AFTER FIELD oeb13
          #CALL t400_set_oeb917()     #FUN-A50054   #FUN-A60035 ---MARK
          IF g_azw.azw04='2' THEN
            #TQC-B10013 Begin---
             IF NOT t400_chk_oeb13_1() THEN
                NEXT FIELD CURRENT
             ELSE
            #TQC-B10013 End-----
                CALL t400_chk_oeb13_3()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_oeb[l_ac].oeb13,g_errno,0)
                   NEXT FIELD oeb13
                END IF
             END IF #TQC-B10013
          ELSE
             IF NOT t400_chk_oeb13_1() THEN
                NEXT FIELD CURRENT
             ELSE
                IF cl_null(g_oeb[l_ac].oeb1004) THEN
                   CALL t400_chk_oeb13_2()
                   IF NOT cl_null(g_errno) THEN NEXT FIELD oeb13 END IF #CHI-840073 add
                END IF
             END IF
             IF g_oeb[l_ac].oeb1012 = 'Y' AND g_aza.aza50 = 'Y' THEN  #No.TQC-740323
                LET g_oeb[l_ac].oeb14=0
                LET g_oeb[l_ac].oeb14t=0
                DISPLAY BY NAME g_oeb[l_ac].oeb14
                DISPLAY BY NAME g_oeb[l_ac].oeb14t
             END IF
          END IF  #No.FUN-870007
         #TQC-B10013 Begin---
          IF cl_null(g_oeb[l_ac].oeb37) OR g_oeb[l_ac].oeb37=0 THEN
             LET g_oeb[l_ac].oeb37=g_oeb[l_ac].oeb13
             DISPLAY BY NAME g_oeb[l_ac].oeb37
          END IF
         #TQC-B10013 End-----

        AFTER FIELD oeb1006
          #IF NOT t400_chk_oeb1006() THEN      #TQC-AB0204
           IF NOT t400_chk_oeb1006(p_cmd) THEN #TQC-AB0204
              NEXT FIELD CURRENT
           END IF

        BEFORE FIELD oeb14
           IF g_oea.oea50='Y' AND NOT cl_null(g_oea.oea55) THEN  # 原幣金額
              SELECT SUM(oeb14) INTO g_oea.oea61 FROM oeb_file
               WHERE oeb01=g_oea.oea01
              LET g_diff = g_oea.oea55-(g_oea.oea61 -
                           g_oeb_t.oeb14 +g_oeb[l_ac].oeb14)
              CALL cl_err(g_diff,'axm-266',0)
           END IF

        AFTER FIELD oeb14
           IF NOT t400_chk_oeb14() THEN
              NEXT FIELD CURRENT
           END IF

        AFTER FIELD oeb14t
           IF NOT t400_chk_oeb14t() THEN
              NEXT FIELD CURRENT
           END IF

       AFTER FIELD oeb41
          IF NOT cl_null(g_oeb[l_ac].oeb41) THEN
             SELECT COUNT(*) INTO g_cnt FROM pja_file
              WHERE pja01 = g_oeb[l_ac].oeb41
                AND pjaacti = 'Y'
                AND pjaclose = 'N'           #No.FUN-960038
             IF g_cnt = 0 THEN
                CALL cl_err(g_oeb[l_ac].oeb41,'asf-984',0)
                NEXT FIELD oeb41
             END IF
          ELSE
             NEXT FIELD oeb908    #IF 專案沒輸入資料，直接跳到手冊編號，WBS/活動不可輸入
          END IF

       BEFORE FIELD oeb42
         IF cl_null(g_oeb[l_ac].oeb41) THEN
            NEXT FIELD oeb41
         END IF

       AFTER FIELD oeb42
          IF NOT cl_null(g_oeb[l_ac].oeb42) THEN
             SELECT COUNT(*) INTO g_cnt FROM pjb_file
              WHERE pjb01 = g_oeb[l_ac].oeb41
                AND pjb02 = g_oeb[l_ac].oeb42
                AND pjbacti = 'Y'
             IF g_cnt = 0 THEN
                CALL cl_err(g_oeb[l_ac].oeb42,'apj-051',0)
                LET g_oeb[l_ac].oeb42 = g_oeb_t.oeb42
                NEXT FIELD oeb42
             ELSE
                SELECT pjb09,pjb11 INTO l_pjb09,l_pjb11
                 FROM pjb_file WHERE pjb01 = g_oeb[l_ac].oeb41
                  AND pjb02 = g_oeb[l_ac].oeb42
                  AND pjbacti = 'Y'
                IF l_pjb09 != 'Y' OR l_pjb11 != 'Y' THEN
                   CALL cl_err(g_oeb[l_ac].oeb42,'apj-090',0)
                   LET g_oeb[l_ac].oeb42 = g_oeb_t.oeb42
                   NEXT FIELD oeb42
                END IF
             END IF
             SELECT pjb25 INTO l_pjb25 FROM pjb_file
              WHERE pjb02 = g_oeb[l_ac].oeb42
             IF l_pjb25 = 'Y' THEN
                NEXT FIELD oeb43
             ELSE
                LET g_oeb[l_ac].oeb43 = ' '
                DISPLAY BY NAME g_oeb[l_ac].oeb43
                NEXT FIELD oeb908
             END IF
          END IF

       BEFORE FIELD oeb43
         IF cl_null(g_oeb[l_ac].oeb42) THEN
            NEXT FIELD oeb42
         ELSE
            SELECT pjb25 INTO l_pjb25 FROM pjb_file
             WHERE pjb02 = g_oeb[l_ac].oeb42
            IF l_pjb25 = 'N' THEN  #WBS不做活動時，活動帶空白，跳開不輸入
               LET g_oeb[l_ac].oeb43 = ' '
               DISPLAY BY NAME g_oeb[l_ac].oeb43
               NEXT FIELD oeb908
            END IF
         END IF

       AFTER FIELD oeb43
          IF NOT cl_null(g_oeb[l_ac].oeb43) THEN
             SELECT COUNT(*) INTO g_cnt FROM pjk_file
              WHERE pjk02 = g_oeb[l_ac].oeb43
                AND pjk11 = g_oeb[l_ac].oeb42
                AND pjkacti = 'Y'
             IF g_cnt = 0 THEN
                CALL cl_err(g_oeb[l_ac].oeb43,'apj-049',0)
                NEXT FIELD oeb43
             END IF
          END IF

        AFTER FIELD oeb15
           IF g_oeb[l_ac].oeb15 < g_oea.oea02 THEN
              CALL cl_err('','axm-330',0)
              NEXT FIELD oeb15
           END IF
              LET b_oeb.oeb16 = g_oeb[l_ac].oeb15    #MOD-780118 mark
              LET g_oeb[l_ac].oeb16=b_oeb.oeb16 #FUN-710037
              DISPLAY BY NAME g_oeb[l_ac].oeb16 #FUN-710037
           IF g_aza.aza50='Y' THEN
              CALL t400_price(l_ac) RETURNING l_fac
           END IF

        AFTER FIELD oeb09
           IF NOT t400_chk_oeb09(l_b2) THEN
              NEXT FIELD CURRENT
           END IF

        AFTER FIELD oeb091
           IF NOT t400_chk_oeb091(l_b2) THEN
              NEXT FIELD CURRENT
           END IF

        AFTER FIELD oeb908
           IF NOT t400_chk_oeb908() THEN
              NEXT FIELD CURRENT
           END IF

        AFTER FIELD oeb930
           IF NOT t400_chk_oeb930() THEN
              NEXT FIELD CURRENT
           END IF


        AFTER FIELD oebud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oebud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oebud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oebud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oebud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oebud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oebud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oebud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oebud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oebud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oebud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oebud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oebud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oebud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oebud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        BEFORE DELETE                            #是否取消單身
           IF l_lock_sw = "Y" THEN
              CALL cl_err("", -263, 1)
              RETURN FALSE
           END IF
           IF NOT t400_b_delchk() THEN
              CANCEL DELETE
           END IF
           IF g_oeb_t.oeb03 > 0 AND g_oeb_t.oeb03 IS NOT NULL THEN
             IF g_sma.sma128 = 'Y' AND g_sma.sma115 !='Y' AND
                NOT cl_null(l_oeb931) AND NOT cl_null(l_oeb932) THEN
                IF NOT cl_confirm('axm_107') THEN
                  CANCEL DELETE
                END IF
             ELSE
              CALL t400_fetch_price('d') #FUN-AC0012
              IF NOT t400_b_del() THEN
                 ROLLBACK WORK
                 CANCEL DELETE
              ELSE
                 IF g_aza.aza50 = 'N' THEN  #No.FUN-650108
                    CALL t400_bu()     #FUN-610055
                 ELSE   #No.FUN-650108
                    CALL t400_oea_sum()  #FUN-610055
                    CALL t400_weight_cubage()
                    CALL t400_upd_try(g_oeb[l_ac].oeb935,g_oeb[l_ac].oeb936,g_oeb[l_ac].oeb12,g_oeb[l_ac].oeb05,g_oeb[l_ac].oeb1012)               #No.FUN-820033
                 END IF #No.FUN-650108
                 COMMIT WORK
                 LET g_rec_b=g_rec_b-1
                 DISPLAY g_rec_b TO FORMONLY.cn3
                #CALL t400_fetch_price('d') #FUN-AC0012
              END IF
             END IF  #No.FUN-820046
           END IF

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_oeb[l_ac].* = g_oeb_t.*
               CLOSE t400_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
#          IF cl_null(g_oeb[l_ac].oeb71) AND g_oea.oea11 MATCHES '[35]' THEN   #TQC-AA0118
           IF cl_null(g_oeb[l_ac].oeb71) AND g_oea.oea11 MATCHES '[5]' THEN   #TQC-AA0118
               NEXT FIELD oeb71
            END IF
#TQC-AA0118 --begin--
           LET l_count = 0 
           SELECT COUNT(*) INTO l_count FROM tqp_file
            WHERE tqp01 = g_oea.oea12
           IF cl_null(g_oeb[l_ac].oeb71) AND g_oea.oea11 = '3' AND l_count = 0 THEN 
              NEXT FIELD oeb71
           END IF  
#TQC-AA0118 --end--            
            
#No.FUN-A80024 --begin
            IF cl_null(g_oeb[l_ac].oeb32) AND g_argv1 ='0' THEN
               NEXT FIELD oeb32
            END IF            
#No.FUN-A80024 --end
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_oeb[l_ac].oeb03,-263,1)
               LET g_oeb[l_ac].* = g_oeb_t.*
            ELSE
               #No.MOD-A70164  --Begin                                          
               IF g_oeb[l_ac].oeb12 <> g_oeb_t.oeb12 THEN                       
                  IF NOT s_t400oeo_u(g_oea.oea01,g_oeb[l_ac].oeb03,g_oeb[l_ac].oeb04,g_oeb[l_ac].oeb12) THEN
                     ROLLBACK WORK                                              
                  END IF                                                        
               END IF                                                           
               #No.MOD-A70164  --End
               CALL t400_upd_try(g_oeb[l_ac].oeb935,g_oeb[l_ac].oeb936,g_oeb_t.oeb12-g_oeb[l_ac].oeb12,g_oeb[l_ac].oeb05,g_oeb[l_ac].oeb1012)               #No.FUN-820033
               CASE t400_b_updchk()
                  WHEN "oeb04" NEXT FIELD oeb04
               END CASE
               CALL t400_b_move_back() #FUN-6C0006

               IF NOT t400_b_upd() THEN
                  ROLLBACK WORK
               ELSE
                  IF g_aza.aza50 = 'N' THEN  #No.FUN-650108
                     CALL t400_bu()     #FUN-610055
                  ELSE   #No.FUN-650108
                     CALL t400_oea_sum()  #FUN-610055
                     CALL t400_weight_cubage()
                  END IF #No.FUN-650108
                  CALL t400_fetch_price('u')
                  COMMIT WORK
                  CALL t400_b_fill('1=1')
               END IF
            END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_oeb[l_ac].* = g_oeb_t.*
                  CALL t400_b_fill(g_wc2)   #No.TQC-740323
               END IF
               CLOSE t400_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            SELECT oaz681 INTO g_oaz.oaz681 FROM oaz_file   #FUN-610055
            SELECT COUNT(*) INTO g_cnt FROM oeb_file WHERE oeb01=g_oea.oea01
            IF (g_oea.oea08='1' AND g_cnt > g_oaz.oaz681) OR
               (g_oea.oea08 MATCHES '[23]' AND g_cnt > g_oaz.oaz682) THEN
                 CALL cl_err('','axm-156',0)  #TQC-7C0103
                 CLOSE t400_bcl #TQC-7C0103
                 ROLLBACK WORK                  #TQC-7C0103
                 DELETE FROM oeb_file           #TQC-7C0103
                  WHERE oeb01=g_oea.oea01       #TQC-7C0103
                    AND oeb03=g_oeb[l_ac].oeb03 #TQC-7C0103
                 INITIALIZE g_oeb[l_ac].* TO NULL #TQC-7C0103
                 CALL g_oeb.deleteElement(l_ac) #TQC-7C0103
                 LET g_rec_b=g_rec_b-1          #TQC-7C0103
                 DISPLAY g_rec_b TO FORMONLY.cn3#TQC-7C0103
                 DISPLAY g_rec_b TO FORMONLY.cn2#TQC-7C0103

            ELSE
            CLOSE t400_bcl
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#&ifdef SLK
#           SELECT COUNT(*) INTO l_n1 FROM oeb_file WHERE oeb01 = g_oea.oea01
#           SELECT COUNT(*) INTO l_n2 FROM ata_file WHERE ata00 = g_prog
#                                                     AND ata01 = g_oea.oea01
#           IF l_n1 <> l_n2 THEN
#              DELETE FROM ata_file WHERE ata00 = g_prog
#                                     AND ata01 = g_oea.oea01
#                                     AND ata03 NOT IN (SELECT oeb03 FROM oeb_file
#                                                        WHERE oeb01 = g_oea.oea01)
#           END IF
#&endif
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
            COMMIT WORK
            END IF
            CALL t400_b_fill(" 1=1") #FUN-AC0012

        ON ACTION controls  
           CALL cl_set_head_visible("","AUTO")

        ON ACTION controlo
           IF (l_ac > 1) THEN
              LET g_oeb[l_ac].* = g_oeb[l_ac-1].*
              LET g_oeb[l_ac].oeb03 = NULL
           END IF

        ON ACTION mntn_accessory
           #No.MOD-A70164  --Begin                                              
           #CALL s_t400oeo(g_oea.oea01,g_oeb[l_ac].oeb03,g_oeb[l_ac].oeb04)     
           CALL s_t400oeo(g_oea.oea01,g_oeb[l_ac].oeb03,g_oeb[l_ac].oeb04,g_oeb[l_ac].oeb12)
           #No.MOD-A70164  --End

        ON ACTION fas_combine
           CALL t400_fas_combine()

        ON ACTION query_qr
           LET l_cmd="amsq502 '",g_oeb[l_ac].oeb04,"' ",g_oeb[l_ac].oeb12
           CALL cl_cmdrun(l_cmd)

        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION other_data
           CALL t400_b_more()

        ON ACTION controlp
           CASE
              #新增的母料件開窗
              #這里只需要處理g_sma.sma908='Y'的情況,因為不允許單身新增子料件則在前面
              #BEFORE FIELD att00來做開窗了
              #需注意的是其條件限制是要開多屬性母料件且母料件的屬性組等于當前屬性組
              WHEN INFIELD(att00)
                 #可以新增子料件,開窗是單純的選取母料件
       #No.FUN-A90048 -------------start------------------------------          
       #          CALL cl_init_qry_var()
       #          LET g_qryparam.form ="q_ima_p"
       #          LET g_qryparam.arg1 = lg_group
       #          CALL cl_create_qry() RETURNING g_oeb[l_ac].att00
                  CALL q_sel_ima(FALSE, "q_ima_p","","",lg_group, "", "", "" ,"" ,'')
                                  RETURNING g_oeb[l_ac].att00  
       #No.FUN-A90048 --------------end----------------------------------
                 DISPLAY BY NAME g_oeb[l_ac].att00        #No.MOD-490371
                    LET g_oeb[l_ac].oeb04 = g_oeb[l_ac].att00
                    LET g_oeb[l_ac].att01 =null
                    LET g_oeb[l_ac].att01_c =null
                    LET g_oeb[l_ac].att02 =null
                    LET g_oeb[l_ac].att02_c =null
                    LET g_oeb[l_ac].att03 =null
                    LET g_oeb[l_ac].att03_c =null
                    LET g_oeb[l_ac].att04 =null
                    LET g_oeb[l_ac].att04_c =null
                    LET g_oeb[l_ac].att05 =null
                    LET g_oeb[l_ac].att05_c =null
                    LET g_oeb[l_ac].att06 =null
                    LET g_oeb[l_ac].att06_c =null
                    LET g_oeb[l_ac].att07 =null
                    LET g_oeb[l_ac].att07_c =null
                    LET g_oeb[l_ac].att08 =null
                    LET g_oeb[l_ac].att08_c =null
                    LET g_oeb[l_ac].att09 =null
                    LET g_oeb[l_ac].att09_c =null
                    LET g_oeb[l_ac].att10 =null
                    LET g_oeb[l_ac].att10_c =null
                 NEXT FIELD att00
  #No.FUN-A90040      begin--       
             WHEN INFIELD(oeb49)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lnt06_1"   
                 LET g_qryparam.default1 = g_oeb[l_ac].oeb49
                 LET g_qryparam.default2 = g_oeb[l_ac].oeb50
                 LET g_qryparam.arg1 = g_oea.oea83   #FUN-AA0057  
                 LET g_qryparam.arg2 = g_oea.oea02   #FUN-AA0057 
                 CALL cl_create_qry() RETURNING g_oeb[l_ac].oeb49,g_oeb[l_ac].oeb50
                 DISPLAY BY NAME g_oeb[l_ac].oeb49,g_oeb[l_ac].oeb50
                 NEXT FIELD oeb49
    #No.FUN-A90040      end-- 
              WHEN INFIELD(oeb1001)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azf03"   #TQC-7C0098
                 LET g_qryparam.default1 = g_oeb[l_ac].oeb1001
                 LET g_qryparam.arg1 = '2'    #No.FUN-740040
                 LET g_qryparam.arg2 = '1'    #No.TQC-7C0098
                 CALL cl_create_qry() RETURNING g_oeb[l_ac].oeb1001
                 DISPLAY BY NAME g_oeb[l_ac].oeb1001
                 NEXT FIELD oeb1001
              WHEN INFIELD(oeb31)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azf1"
                 LET g_qryparam.default1 = g_oeb[l_ac].oeb31
                 CALL cl_create_qry() RETURNING g_oeb[l_ac].oeb31
                 DISPLAY BY NAME g_oeb[l_ac].oeb31
                 NEXT FIELD oeb31
              WHEN INFIELD(oeb04)
# No.FUN-A80121  ..begin
              IF p_cmd = 'a' THEN  
                 #MOD-B30277 add --start--
                 IF g_oea.oea00 MATCHES '[123467]' THEN
                    CALL q_ima_2(1,1,g_plant) RETURNING g_multi_ima01  
                 ELSE
                 #MOD-B30277 add --end--
                    CALL q_ima(1,1,g_plant) RETURNING g_multi_ima01  
                 END IF #MOD-B30277 add
                    IF NOT cl_null(g_multi_ima01)  THEN     
                       CALL t400_multi_ima01()
#TQC-AA0025 --begin--
                       IF g_success = 'N' THEN 
                          NEXT FIELD oeb04
                       END IF 
#TQC-AA0025 --end--                       
                       CALL t400_b_fill(" 1=1")
                       CALL t400_bp_refresh()
                       CALL t400_b()
                       EXIT INPUT
                    END IF 
                ELSE
# No.FUN-A80121    ..end
        #No.FUN-A90048 ------------start----------------------------
        #         CALL cl_init_qry_var()
        #         IF g_azw.azw04='2' THEN         
        #            SELECT rtz04 INTO l_rtz04 FROM rtz_file
        #             WHERE rtz01=g_plant
        #            IF NOT cl_null(l_rtz04) THEN
        #               LET g_qryparam.form="q_rte03_3"
        #               LET g_qryparam.arg1= l_rtz04
        #            ELSE
        #               LET g_qryparam.form="q_ima"
        #            END IF
        #         ELSE
        #            IF g_aza.aza50 = 'Y' THEN  #No.FUN-650108
        #               LET g_qryparam.form ="q_ima15"           #No.FUN-A90048 mark
        #            ELSE
        #               LET g_qryparam.form ="q_ima"              #No.FUN-A90048 mark
        #            END IF
        #         END IF   #No.FUN-870007
        #         LET g_qryparam.default1 = g_oeb[l_ac].oeb04   #No.FUN-A90048 mark
        #         IF g_aza.aza50 = 'Y' THEN  #No.FUN-650108
        #            LET g_qryparam.arg1 = g_oea.oea1002
        #         END IF  #No.FUN-650108
        #         CALL cl_create_qry() RETURNING g_oeb[l_ac].oeb04
                 #MOD-B30277 add --start--
                 IF g_oea.oea00 MATCHES '[123467]' THEN
                    LET l_ima130_wc = "ima130 <>'0'"
                 ELSE
                    LET l_ima130_wc = ""
                 END IF
                 #MOD-B30277 add --end--
                  IF g_aza.aza50 = 'Y'  THEN
                    #CALL q_sel_ima(FALSE, "q_ima15", "", g_oeb[l_ac].oeb04  , g_oea.oea1002, "", "", "" ,"",'' ) #MOD-B30277 mark 
                     CALL q_sel_ima(FALSE, "q_ima15", l_ima130_wc, g_oeb[l_ac].oeb04  , g_oea.oea1002, "", "", "" ,"",'' )  #MOD-B30277
                                RETURNING g_oeb[l_ac].oeb04
                  ELSE
                    #CALL q_sel_ima(FALSE, "q_ima",   "", g_oeb[l_ac].oeb04  , "", "", "", "" ,"",'') #MOD-B30277 mark 
                     CALL q_sel_ima(FALSE, "q_ima",   l_ima130_wc, g_oeb[l_ac].oeb04  , "", "", "", "" ,"",'') #MOD-B30277
                                RETURNING g_oeb[l_ac].oeb04
                  END IF
        #No.FUN-A90048 ----------------------end ---------------------------
                  DISPLAY BY NAME g_oeb[l_ac].oeb04
                 NEXT FIELD oeb04
            END IF              # No.FUN-A80121
              WHEN INFIELD(oeb05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_oeb[l_ac].oeb05
                 CALL cl_create_qry() RETURNING g_oeb[l_ac].oeb05
                  DISPLAY BY NAME g_oeb[l_ac].oeb05        #No.MOD-490371
                 NEXT FIELD oeb05

              #FUN-A80054--begin--add---------
              WHEN INFIELD(oeb918)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oeb918"
                 LET g_qryparam.default1 = g_oeb[l_ac].oeb918
                 LET g_qryparam.arg1 = g_oeb[l_ac].oeb04
                 CALL cl_create_qry() RETURNING g_oeb[l_ac].oeb918
                 DISPLAY BY NAME g_oeb[l_ac].oeb918
                 NEXT FIELD oeb918
              #FUN-A80054--end--add-----------

              WHEN INFIELD(oeb908)
                 CALL q_coc2(FALSE,FALSE,g_oeb[l_ac].oeb908,'',g_oea.oea02,'0',
                             '',g_oeb[l_ac].oeb04)
                 RETURNING g_oeb[l_ac].oeb908,l_coc04
                  DISPLAY BY NAME g_oeb[l_ac].oeb908       #No.MOD-490371
                 NEXT FIELD oeb908
              WHEN INFIELD(oeb41) #專案
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pja2"
                 CALL cl_create_qry() RETURNING g_oeb[l_ac].oeb41
                 DISPLAY BY NAME g_oeb[l_ac].oeb41
                 NEXT FIELD oeb41
              WHEN INFIELD(oeb42)  #WBS
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pjb4"
                 LET g_qryparam.arg1 = g_oeb[l_ac].oeb41
                 CALL cl_create_qry() RETURNING g_oeb[l_ac].oeb42
                 DISPLAY BY NAME g_oeb[l_ac].oeb42
                 NEXT FIELD oeb42
              WHEN INFIELD(oeb43)  #活動
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pjk3"
                 LET g_qryparam.arg1 = g_oeb[l_ac].oeb42
                 CALL cl_create_qry() RETURNING g_oeb[l_ac].oeb43
                 DISPLAY BY NAME g_oeb[l_ac].oeb43
                 NEXT FIELD oeb43

              WHEN INFIELD(oeb910) #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_oeb[l_ac].oeb910
                 CALL cl_create_qry() RETURNING g_oeb[l_ac].oeb910
                 DISPLAY BY NAME g_oeb[l_ac].oeb910
                 NEXT FIELD oeb910

              WHEN INFIELD(oeb913) #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_oeb[l_ac].oeb913
                 CALL cl_create_qry() RETURNING g_oeb[l_ac].oeb913
                 DISPLAY BY NAME g_oeb[l_ac].oeb913
                 NEXT FIELD oeb913

              WHEN INFIELD(oeb916) #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_oeb[l_ac].oeb916
                 CALL cl_create_qry() RETURNING g_oeb[l_ac].oeb916
                 DISPLAY BY NAME g_oeb[l_ac].oeb916
                 NEXT FIELD oeb916
              WHEN INFIELD(oeb1004)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_tqx3"  #TQC-7C0098
                 LET g_qryparam.default1 = g_oeb[l_ac].oeb1004
                 LET g_qryparam.arg1 = g_oea.oea03
                 LET g_qryparam.arg2 = g_oea.oea23  #TQC-7C0098
                 LET g_qryparam.where = " (tqz03 ='",g_oeb[l_ac].oeb04,"' OR                                            tqz03 IN (SELECT ima01 FROM ima_file                                                       WHERE ima135='",g_oeb[l_ac].ima135,"'))"
                 CALL cl_create_qry() RETURNING g_oeb[l_ac].oeb1004
                 DISPLAY BY NAME g_oeb[l_ac].oeb1004
                 NEXT FIELD oeb1004
              WHEN INFIELD(oeb09)
                 #No.FUN-AA0048  --Begin
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_imd01"
                 #LET g_qryparam.default1 = g_oeb[l_ac].oeb09
                 #CALL cl_create_qry() RETURNING g_oeb[l_ac].oeb09
                 CALL q_imd_1(FALSE,TRUE,g_oeb[l_ac].oeb09,"","","","imd11='Y'") RETURNING g_oeb[l_ac].oeb09
                 #No.FUN-AA0048  --End  
                 DISPLAY BY NAME g_oeb[l_ac].oeb09
                 NEXT FIELD oeb09
              WHEN INFIELD(oeb091)
                 #No.FUN-AA0048  --Begin
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_ime"
                 #LET g_qryparam.default1 = g_oeb[l_ac].oeb091
                 #LET g_qryparam.arg1 = g_oeb[l_ac].oeb09
                 #LET g_qryparam.arg2 = 'SW'
                 #CALL cl_create_qry() RETURNING g_oeb[l_ac].oeb091
                 CALL q_ime_1(FALSE,TRUE,g_oeb[l_ac].oeb091,g_oeb[l_ac].oeb09,"","","","","") RETURNING g_oeb[l_ac].oeb091
                 #No.FUN-AA0048  --End  
                 DISPLAY BY NAME g_oeb[l_ac].oeb091
                 NEXT FIELD oeb091
              WHEN INFIELD(oeb930)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem4"
                 CALL cl_create_qry() RETURNING g_oeb[l_ac].oeb930
                 DISPLAY BY NAME g_oeb[l_ac].oeb930
                 NEXT FIELD oeb930

              WHEN INFIELD(oebud02)
                 CALL cl_dynamic_qry() RETURNING g_oeb[l_ac].oebud02
                 DISPLAY BY NAME g_oeb[l_ac].oebud02
                 NEXT FIELD oebud02
              WHEN INFIELD(oebud03)
                 CALL cl_dynamic_qry() RETURNING g_oeb[l_ac].oebud03
                 DISPLAY BY NAME g_oeb[l_ac].oebud03
                 NEXT FIELD oebud03
              WHEN INFIELD(oebud04)
                 CALL cl_dynamic_qry() RETURNING g_oeb[l_ac].oebud04
                 DISPLAY BY NAME g_oeb[l_ac].oebud04
                 NEXT FIELD oebud04
              WHEN INFIELD(oebud05)
                 CALL cl_dynamic_qry() RETURNING g_oeb[l_ac].oebud05
                 DISPLAY BY NAME g_oeb[l_ac].oebud05
                 NEXT FIELD oebud05
              WHEN INFIELD(oebud06)
                 CALL cl_dynamic_qry() RETURNING g_oeb[l_ac].oebud06
                 DISPLAY BY NAME g_oeb[l_ac].oebud06
                 NEXT FIELD oebud06

              OTHERWISE
                 LET g_msg="axmq450 '",g_oeb[l_ac].oeb04,"' " #MOD-4B0293 modify
                 CALL cl_cmdrun(g_msg)
           END CASE

        ON ACTION qry_item
   #No.FUN-A90048 ----------------start-----------------------------
   #        CALL cl_init_qry_var()
   #        LET g_qryparam.form ="q_ima16"
   #        LET g_qryparam.default1 = g_oeb[l_ac].oeb04
   #        CALL cl_create_qry() RETURNING g_oeb[l_ac].oeb04
            CALL q_sel_ima(FALSE, "q_ima16","",g_oeb[l_ac].oeb04,"", "", "", "" ,"" ,'')
                                  RETURNING g_oeb[l_ac].oeb04
   #No.FUN-A90048 ----------------end--------------------------------
           DISPLAY BY NAME g_oeb[l_ac].oeb04
           NEXT FIELD oeb04

        ON ACTION qry_return
           IF g_oea.oea00 = '2' THEN
              CALL cl_init_qry_var()
              #need return du content,change a new qry
              LET g_qryparam.form = 'q_ohb'
              LET g_qryparam.default1 = g_oeb[l_ac].oeb04
              LET g_qryparam.arg1 = g_oea.oea03     #FUN-610055
              LET g_qryparam.arg2 = g_oea.oea23
              LET g_qryparam.arg3 = g_oea.oea21
              CALL cl_create_qry()
              RETURNING g_oeb[l_ac].oeb04,g_oeb[l_ac].oeb05,g_oeb[l_ac].oeb12
              NEXT FIELD oeb04
           END IF

        ON ACTION qry_order_detail
           LET g_msg="axmq450 '",g_oeb[l_ac].oeb04,"' " #MOD-4B0293 modify
           CALL cl_cmdrun(g_msg)

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121


   END INPUT

   #-----No:FUN-A50103-----
#  IF g_oea.oea261 = 0 THEN                        #FUN-A60035
   IF g_oea.oea261=0 OR cl_null(g_oea.oea261) THEN #FUN-A60035
      IF g_oea.oea213 = 'Y' THEN
         LET g_oea.oea261 = g_oea.oea1008 * g_oea.oea161/100
      ELSE
         LET g_oea.oea261 = g_oea.oea61 * g_oea.oea161/100
      END IF
   END IF

#  IF g_oea.oea262 = 0 THEN                        #FUN-A60035
   IF g_oea.oea262=0 OR cl_null(g_oea.oea262) THEN #FUN-A60035
      IF g_oea.oea213 = 'Y' THEN
         LET g_oea.oea262 = g_oea.oea1008 * g_oea.oea162/100
      ELSE
         LET g_oea.oea262 = g_oea.oea61 * g_oea.oea162/100
      END IF
   END IF

   IF g_oea.oea213 = 'Y' THEN
      LET g_oea.oea263 = g_oea.oea1008 - g_oea.oea261 - g_oea.oea262
   ELSE
      LET g_oea.oea263 = g_oea.oea61 - g_oea.oea261 - g_oea.oea262
   END IF
   #-----No:FUN-A50103 END-----
    
   UPDATE oea_file SET oeamodu = g_user,oeadate = g_today,oea49 = g_oea49,
                       oea261 = g_oea.oea261,    #No:FUN-A50103
                       oea262 = g_oea.oea262,    #No:FUN-A50103
                       oea263 = g_oea.oea263     #No:FUN-A50103
    WHERE oea01 = g_oea_t.oea01       #mod by liuxqa 091020

   LET g_oea.oea49 = g_oea49
   DISPLAY BY NAME g_oea.oea49              #MOD-4A0299
   DISPLAY BY NAME g_oea.oea261,g_oea.oea262,g_oea.oea263

   #MOD-B30116  add begin-----------------------------------
   IF g_oea.oea263 < 0 THEN
      CALL cl_err('','axm1018',1)
      ROLLBACK WORK
      RETURN
   END IF
   #MOD-B30116  add -end------------------------------------
  
   CALL t400_ins_oeaa()    #No:FUN-A50103

   CALL t400_pic()

   CALL t400_fetch_price('e')

   CALL t400_b_fill('1=1')

   SELECT COUNT(*) INTO g_cnt FROM oeb_file WHERE oeb01=g_oea.oea01
   CLOSE t400_bcl


   COMMIT WORK

   IF g_oea.oea50='Y' THEN
      IF g_oea.oea55!=g_oea.oea61 THEN
         IF cl_confirm('axm-121') THEN
            CALL t400_csd_price()
         END IF
      END IF
   END IF

   IF g_aza.aza50 ='Y' AND (NOT cl_null(g_oea.oea12)) AND g_prog ='axmt410' THEN
      SELECT COUNT(*) INTO l_m FROM oeb_file
       WHERE oeb01 =g_oea.oea01
         AND oeb1012 ='Y'
      IF l_m =0 THEN
         IF cl_confirm("axm-474") THEN
            CALL t400_cash_return()
         END IF
      END IF
   END IF

# 新增自動確認功能 Modify by WUPN 96-05-06 ----------
    LET g_t1=s_get_doc_no(g_oea.oea01)
    SELECT * INTO g_oay.* FROM oay_file WHERE oayslip=g_t1
    IF STATUS THEN
       CALL cl_err3("sel","oay_file",g_t1,"",STATUS,"","sel oay_file",1)  #No.FUN-650108
       RETURN
    END IF
    IF g_oea.oeaconf='Y' OR g_oay.oayconf='N' OR g_oay.oayapr  = 'Y' #No.FUN-640248
       THEN RETURN
    ELSE
       LET g_action_choice = "insert"      #No.FUN-640248
       IF g_aza.aza26 <> '2' THEN #No.TQC-6C0138
          CALL t400sub_y_chk('1',g_oea.oea01)          #CALL 原確認的 check 段 #FUN-610055 #FUN-730012
          IF g_success = "Y" THEN
              CALL t400sub_y_upd(g_oea.oea01,g_action_choice)      #CALL 原確認的 update 段 #FUN-730012
              CALL t400sub_refresh(g_oea.oea01)  RETURNING g_oea.* #FUN-730012 更新g_oea
              CALL t400_show() #FUN-6C0006
          END IF
       END IF #No.TQC-6C0138
    END IF
    IF g_aza.aza26 <> '2' THEN #No.TQC-6C0138
       IF g_oay.oayprnt='Y' THEN CALL t400_out() END IF   #單據需立即列印
    END IF #No.TQC-6C0138

END FUNCTION


FUNCTION t400_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)


   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_argv1 != '1' THEN
      CALL cl_set_act_visible("carry_pr,carry_po", FALSE)  #FUN-6C0050 add carry_po
   END IF
   IF g_argv1 = '0' THEN
      CALL cl_set_act_visible("allocate", FALSE)
   END IF
   IF g_oea901 != 'Y' THEN
      CALL cl_set_act_visible("mul_trade,mul_trade_other,restore", FALSE)
   END IF
   IF g_aza.aza23 matches '[ Nn]' THEN
      CALL cl_set_act_visible("easyflow_approval,approval_status",FALSE)
   END IF
   IF g_prog[1,7] = 'axmt410' AND (g_sma.sma128 MATCHES '[Yy]' AND g_sma.sma115 NOT MATCHES '[Yy]') THEN
      CALL cl_set_act_visible("mixed_wrap",TRUE)
   ELSE
      CALL cl_set_act_visible("mixed_wrap",FALSE)
   END IF
   DISPLAY ARRAY g_oeb TO s_oeb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
            LET g_chr='@'
            IF g_argv1 <> '1' THEN
               CALL cl_set_act_visible("carry_pr,carry_po",FALSE)  #FUN-6C0050 add carry_po
            END IF
            IF g_prog != 'axmt410' OR g_aza.aza50 = 'N' THEN
               CALL cl_set_act_visible("obj_return_close,cash_return,obj_return",FALSE)
            END IF
            CALL cl_set_act_visible("modify_control",(g_azw.azw04='2' AND g_aza.aza88='Y')) #No.FUN-870007
         #上下筆資料的ToolBar控制.
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_prog != 'axmt410' THEN                      #FUN-A10110 ADD
            CALL cl_set_act_visible("discount_detail",FALSE)
         END IF 

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION return_benefit
         LET g_action_flag="return_benefit"
         EXIT DISPLAY

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY

      ON ACTION first
         CALL t400_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION previous
         CALL t400_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION jump
         CALL t400_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION next
         CALL t400_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION last
         CALL t400_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      #No.FUN-A10106--begin  
      ON ACTION kefa  
         LET g_action_choice="kefa"
         EXIT DISPLAY
      #No.FUN-A10106--end  
     #多角貿易
      ON ACTION mul_trade
         LET g_action_choice="mul_trade"
         EXIT DISPLAY

      ON ACTION mul_trade_other
         LET g_action_choice="mul_trade_other"
         EXIT DISPLAY

     #多角貿易拋轉還原
      ON ACTION restore
         LET g_action_choice="restore"
         EXIT DISPLAY


      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092


#@    ON ACTION 拋轉請購單
      ON ACTION carry_pr
         LET g_action_choice="carry_pr"
         EXIT DISPLAY

#@    ON ACTION 拋轉採購單
      ON ACTION carry_po
         LET g_action_choice="carry_po"
         EXIT DISPLAY

#@    ON ACTION 備置
      ON ACTION allocate
         LET g_action_choice="allocate"
         EXIT DISPLAY


#@    ON ACTION 受訂庫存查詢
      ON ACTION qry_inv_ordered
         LET g_action_choice="qry_inv_ordered"
         EXIT DISPLAY

#@    ON ACTION CSD資料
      ON ACTION csd_data
         LET g_action_choice="csd_data"
         EXIT DISPLAY

#@    ON ACTION 費用資料
      ON ACTION expense_data
         LET g_action_choice="expense_data"
         EXIT DISPLAY

#@    ON ACTION 留置
      ON ACTION on_hold
         LET g_action_choice="on_hold"
         EXIT DISPLAY

#@    ON ACTION 取消留置
      ON ACTION undo_on_hold
         LET g_action_choice="undo_on_hold"
         EXIT DISPLAY

#@    ON ACTION 訂單相關查詢
      ON ACTION order_query
         LET g_action_choice="order_query"
         EXIT DISPLAY

#@    ON ACTION 客戶相關查詢
      ON ACTION query_customer
         LET g_action_choice="query_customer"
         EXIT DISPLAY

#@    ON ACTION QR查詢
      ON ACTION query_qr
          LET g_action_choice="query_qr"    #MOD-530157
         EXIT DISPLAY

#@    ON ACTION 變更狀況
      ON ACTION change_status
         LET g_action_choice="change_status"
         EXIT DISPLAY

#@    ON ACTION 相關文件
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

#@    ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
      ON ACTION modify_price
         LET g_action_choice="modify_price"
         EXIT DISPLAY

      ON ACTION modify_rate
         LET g_action_choice="modify_rate"
         EXIT DISPLAY
      ON ACTION pref
         LET g_action_choice="pref"
         EXIT DISPLAY

      ON ACTION discount_allowed
         LET g_action_choice="discount_allowed"
         EXIT DISPLAY

       ON ACTION easyflow_approval     #MOD-4A0299
         LET g_action_choice="easyflow_approval"
         EXIT DISPLAY

#@    ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

#@    ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY

#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

      #-----No:FUN-A50103-----
#@    ON ACTION 訂金多帳期
      ON ACTION deposit_multi_account
         LET g_action_choice="deposit_multi_account"
         EXIT DISPLAY

#FUN-A70132 --Begin--
      ON ACTION detail_tax
         LET g_action_choice="detail_tax"
         EXIT DISPLAY
#FUN-A70132 --End--         

#@    ON ACTION 尾款多帳期
      ON ACTION balance_multi_account
         LET g_action_choice="balance_multi_account"
         EXIT DISPLAY
      #-----No:FUN-A50103 END-----

      ON ACTION pay_money
         LET g_action_choice = "pay_money"
         EXIT DISPLAY

      ON ACTION money_detail
         LET g_action_choice = "money_detail"
         EXIT DISPLAY

      ON ACTION discount_detail           #FUN-A10110 折價明細 
         LET g_action_choice="discount_detail"
         EXIT DISPLAY  

      ON ACTION cancel_price        #取消折价
         LET g_action_choice = "cancel_price"
         EXIT DISPLAY

#FUN-A70146 --begin--
      ON ACTION qry_price
         LET g_action_choice = "qry_price"
         EXIT DISPLAY          
#FUN-A70146 --end--

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION locale
         CALL t400_set_perlang() #FUN-710037
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL t400_pic()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      #@ON ACTION 簽核狀況
       ON ACTION approval_status     #MOD-4C0041
         LET g_action_choice="approval_status"
         EXIT DISPLAY


      AFTER DISPLAY
         CONTINUE DISPLAY

      #@ON ACTION 其他資料
      ON ACTION other_data
         LET g_action_choice="other_data"
         EXIT DISPLAY

      ON ACTION agree
         LET g_action_choice = 'agree'
         EXIT DISPLAY

      ON ACTION deny
         LET g_action_choice = 'deny'
         EXIT DISPLAY

      ON ACTION modify_flow
         LET g_action_choice = 'modify_flow'
         EXIT DISPLAY

      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DISPLAY

      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DISPLAY

      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DISPLAY

#@    ON ACTION 取消分配
      ON ACTION undo_distribution
         LET g_action_choice = 'undo_distribution'
         EXIT DISPLAY



      &include "qry_string.4gl"
     ON ACTION obj_return_close
         LET g_action_choice = 'obj_return_close'
         EXIT DISPLAY
     ON ACTION cash_return
         LET g_action_choice = 'cash_return'
         EXIT DISPLAY
     ON ACTION obj_return
         LET g_action_choice = 'obj_return'
         EXIT DISPLAY


   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION t400_q()
   #初始化單頭資料筆數.
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   INITIALIZE g_oea.* TO NULL    #No.FUN-6A0020

   CALL cl_opmsg('q')
   #MESSAGE ""                   #No.FUN-640248 MARK
   CALL cl_msg("")               #No.FUN-640248
   DISPLAY '   ' TO FORMONLY.cnt

   IF g_sma.sma120 = 'Y'  THEN
      LET lg_oay22 = ''
      LET lg_group = ''
      CALL t400_refresh_detail()
   END IF

   CALL t400_cs()

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_oea.* TO NULL

      RETURN
   END IF
   #MESSAGE " SEARCHING ! "                #No.FUN-640248 MARK
   CALL cl_msg(" SEARCHING ! ")            #No.FUN-640248

   OPEN t400_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_oea.* TO NULL
   ELSE
      OPEN t400_count
      FETCH t400_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t400_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF

END FUNCTION

FUNCTION t400_u()

   IF NOT t400_u_chk() THEN
      RETURN
   END IF

   BEGIN WORK
   OPEN t400_cl USING g_oea.oea01
   IF STATUS THEN
      CALL cl_err("OPEN t400_cl:", STATUS, 1)
      CLOSE t400_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t400_cl INTO g_oea.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t400_cl
      ROLLBACK WORK
      RETURN
   END IF

   CALL t400_show() #FUN-6C0006

   WHILE TRUE
      LET g_oea01_t = g_oea.oea01
      LET g_oea.oeamodu=g_user
      LET g_oea.oeadate=g_today
#      LET g_oea.oeaslk02=' '       #FUN-A60035 ---mark

      CALL t400_i("u")                      #欄位更改

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_oea.*=g_oea_t.*
         CALL t400_show() #FUN-6C0006
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF

      IF NOT t400_u_ins() THEN
         ROLLBACK WORK
         CALL t400_show() #FUN-6C0006
         RETURN
      END IF

      CALL t400_show() #FUN-6C0006
      EXIT WHILE
   END WHILE

   CLOSE t400_cl
   COMMIT WORK

   CALL t400_ins_oeaa()    #No:FUN-A50103

   CALL cl_flow_notify(g_oea.oea01,'U')

   # 新增自動確認功能 Modify by WUPN 96-05-06 ----------
   LET g_t1=s_get_doc_no(g_oea.oea01)

   SELECT * INTO g_oay.* FROM oay_file
    WHERE oayslip=g_t1
   IF STATUS THEN
      CALL cl_err3("sel","oay_file","","",STATUS,"","sel oay_file",1)  #No.FUN-650108
      RETURN
   END IF

   IF g_oea.oeaconf='Y' OR g_oay.oayconf='N' OR g_oay.oayapr  = 'Y' THEN #單據已確認或單據不需自動確認  #No.FUN-640248
      RETURN
   ELSE
      LET g_action_choice = "insert"      #No.FUN-640248

      CALL t400sub_y_chk('1',g_oea.oea01)         #CALL 原確認的 check 段 #FUN-610055 #FUN-730012

      IF g_success = "Y" THEN
         CALL t400sub_y_upd(g_oea.oea01,g_action_choice)  #CALL 原確認的 update 段 #FUN-730012
         CALL t400sub_refresh(g_oea.oea01)  RETURNING g_oea.* #FUN-730012 更新g_oea
         CALL t400_show() #FUN-6C0006
      END IF
   END IF

   IF g_oay.oayprnt='Y' THEN    #單據需立即列印
      CALL t400_out()
   END IF


END FUNCTION

FUNCTION t400_copy()
   DEFINE old_no,new_no   LIKE oea_file.oea01,
          new_date        LIKE type_file.dat     #No.FUN-680137 DATE
   DEFINE l_oea           RECORD LIKE oea_file.*
   DEFINE l_oayapr        LIKE oay_file.oayapr
   DEFINE li_result       LIKE type_file.num5    #No.FUN-550052  #No.FUN-680137 SMALLINT
   DEFINE l_oea23         LIKE oea_file.oea23   #MOD-A30147
   DEFINE l_oea24         LIKE oea_file.oea24   #MOD-A30147

   IF g_oea.oea11 ='3' THEN RETURN END IF
   LET new_date=g_today
   LET old_no  = g_oea.oea01

   IF g_oea.oea01 IS NULL THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF

   BEGIN WORK
   LET g_before_input_done = FALSE
   CALL t400_set_entry('a')
   CALL cl_set_comp_entry("oea00,oea08",FALSE) 	#MOD-970154
   LET g_before_input_done = TRUE

WHILE TRUE
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
    INPUT new_no,new_date FROM oea01,oea02
    BEFORE INPUT
    CALL cl_set_docno_format("oea01")

       AFTER FIELD oea01
          IF NOT cl_null(new_no) THEN
             SELECT COUNT(*) INTO i FROM oea_file WHERE oea01=new_no
             IF i>0 THEN
                CALL cl_err('sel oea:','-239',0)
                NEXT FIELD oea01
             END IF
             LET g_t1=s_get_doc_no(new_no)
  	       CASE WHEN g_oea.oea00 = '0' CALL s_check_no('axm',new_no,"","20","oea_file","oea01","") RETURNING li_result,new_no #合約單別
  	            WHEN g_oea.oea00 = '1' CALL s_check_no('axm',new_no,"","30","oea_file","oea01","") RETURNING li_result,new_no #訂單單別
  	            WHEN g_oea.oea00 = 'A' CALL s_check_no('axm',new_no,"","30","oea_file","oea01","") RETURNING li_result,new_no #訂單單別  #No.FUN-610053
  	            WHEN g_oea.oea00 = '2' CALL s_check_no('axm',new_no,"","32","oea_file","oea01","") RETURNING li_result,new_no #換貨訂單
  	            WHEN g_oea.oea00 MATCHES '[37]' CALL s_check_no('axm',new_no,"","33","oea_file","oea01","") RETURNING li_result,new_no   #No.FUN-610055
  	            WHEN g_oea.oea00 = '4' CALL s_check_no('axm',new_no,"","34","oea_file","oea01","") RETURNING li_result,new_no
  	            WHEN g_oea.oea00 = '6' CALL s_check_no('axm',new_no,"","30","oea_file","oea01","") RETURNING li_result,new_no #代送訂單單別  #No.FUN-610055
  	            WHEN g_oea.oea00 = '8' CALL s_check_no('axm',new_no,"","22","oea_file","oea01","") RETURNING li_result,g_oea.oea01  #MOD-860171
  	            WHEN g_oea.oea00 = '9' CALL s_check_no('axm',new_no,"","22","oea_file","oea01","") RETURNING li_result,g_oea.oea01  #MOD-860171
             END CASE
                    IF (NOT li_result) THEN
                       LET g_oea.oea01=g_oea_o.oea01
                       NEXT FIELD oea01
                    END IF
               LET g_t1=new_no[1,g_doc_len]
               SELECT oayapr INTO l_oayapr
                 FROM oay_file WHERE oayslip = g_t1
          END IF

        ON ACTION controlp
           CASE
              WHEN INFIELD(oea01) #查詢單据
                 LET g_t1=s_get_doc_no(new_no)
		 CASE WHEN g_oea.oea00 = '0' LET g_buf='20'
		      WHEN g_oea.oea00 = '1' LET g_buf='30'
		      WHEN g_oea.oea00 = 'A' LET g_buf='30'  #No.FUN-610053
		      WHEN g_oea.oea00 = '2' LET g_buf='32'
		      WHEN g_oea.oea00 MATCHES '[37]' LET g_buf='33'    #No.FUn-610055
		      WHEN g_oea.oea00 = '4' LET g_buf='34'
		      WHEN g_oea.oea00 = '6' LET g_buf='30'  #FUN-610055
		      WHEN g_oea.oea00 = '8' LET g_buf='22'   #No.FUN-740016
		      WHEN g_oea.oea00 = '9' LET g_buf='22'   #No.FUN-740016
		 END CASE
                 CALL q_oay(FALSE,FALSE,g_t1,g_buf,'AXM') RETURNING g_t1 #FUN-610055
                 LET new_no=g_t1
                 DISPLAY new_no TO oea01
                 NEXT FIELD oea01
           END CASE

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

    IF INT_FLAG THEN
       LET INT_FLAG = 0 #No.FUN-870007
       DISPLAY g_oea.oea02 TO oea02  #No.FUN-870007
       DISPLAY g_oea.oea01 TO oea01
       RETURN
    END IF
        CALL s_auto_assign_no("axm",new_no,new_date,g_buf,"oea_file","oea01","","","")
        RETURNING li_result,new_no
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY new_no TO oea01
    EXIT WHILE
END WHILE

    IF INT_FLAG THEN
       LET INT_FLAG=0
       ROLLBACK WORK
       RETURN
    END IF

    IF NOT cl_sure(0,0) THEN
       ROLLBACK WORK
       RETURN
    END IF

    DROP TABLE x
    SELECT * FROM oea_file
        WHERE oea01=g_oea.oea01     #mod by liuxqa 091020
        INTO TEMP x
    #-----MOD-A30147---------
    LET l_oea23 = '' 
    SELECT oea23 INTO l_oea23 FROM oea_file 
      WHERE oea01 = g_oea.oea01 
    CALL s_curr3(l_oea23,new_date,exT)
                RETURNING l_oea24
    #-----END MOD-A30147-----
    UPDATE x
        SET oea01=new_no,     #資料鍵值
            oea02=new_date,   #日期
            oea24=l_oea24,    #MOD-A30147
            oea06=0,   #MOD-8C0193
            oea62=0,
            oea63=0,
            oea40=NULL,
            oea49='0',
            oea905='N',
            oea99 =NULL,  #No.9864
            oeaconf='N',
            oeahold=NULL,
            oeaprsw=0,
            oeauser=g_user,   #資料所有者
            oeagrup=g_grup,   #資料所有者所屬群
            oeaoriu=g_user,   #TQC-A30041 ADD
            oeaorig=g_grup,   #TQC-A30041 ADD
            oeamodu=NULL,     #資料修改日期
            oeadate=g_today,   #資料建立日期
            oeaconu=NULL,     #No.FUN-870007
            oeacont=NULL,     #No.FUN-870007
            oeamksg=l_oayapr                            ##MOD-4A0299

    INSERT INTO oea_file
        SELECT * FROM x
    IF STATUS OR SQLCA.SQLCODE THEN
       CALL cl_err3("ins","oea_file",new_no,"",SQLCA.sqlcode,"","ins oea:",1)  #No.FUN-650108
       ROLLBACK WORK RETURN
    END IF

    DROP TABLE x       #---------------------------------------- copy oeb_file
    SELECT * FROM oeb_file WHERE oeb01=old_no INTO TEMP x
    IF STATUS THEN
       CALL cl_err3("ins","x",old_no,"",STATUS,"","oeb- x:",1)  #No.FUN-650108
       ROLLBACK WORK
       RETURN
    END IF

    UPDATE x SET oeb01=new_no,
                 oeb23=0, oeb24=0, oeb25=0, oeb26=0, oeb70='N',oeb70d=NULL,
                 oeb15 = g_today,oeb16=g_today,     #No.B303 add
                #oeb17 = oeb13,                     #no.7150 #MOD-980285
                 oeb27='',oeb28=0   #MOD-870175
                ,oeb920 = 0         #TQC-A40113

    INSERT INTO oeb_file SELECT * FROM x

    IF STATUS OR SQLCA.SQLCODE THEN
       CALL cl_err3("ins","oeb_file",new_no,"",SQLCA.sqlcode,"","ins oeb:",1)  #No.FUN-650108
       ROLLBACK WORK RETURN
    END IF

    DROP TABLE x       #---------------------------------------- copy oao_file

    SELECT * FROM oao_file WHERE oao01=old_no INTO TEMP x
    IF STATUS THEN
       CALL cl_err3("ins","x",old_no,"",STATUS,"","oao- x:",1)   #No.FUN-650108
       ROLLBACK WORK
       RETURN
    END IF

    UPDATE x SET oao01=new_no

    INSERT INTO oao_file SELECT * FROM x
    IF STATUS THEN
       CALL cl_err3("ins","oao_file",new_no,"",STATUS,"","ins oao:",1)  #No.FUN-650108
       ROLLBACK WORK
       RETURN
    END IF

    DROP TABLE x       #---------------------------------------- copy oeo_file

    SELECT * FROM oeo_file WHERE oeo01=old_no INTO TEMP x
    IF STATUS THEN
       CALL cl_err3("ins","x",old_no,"",STATUS,"","oeo- x:",1)   #No.FUN-650108
       ROLLBACK WORK
       RETURN
    END IF

    UPDATE x SET oeo01=new_no

    INSERT INTO oeo_file SELECT * FROM x
    IF STATUS THEN
       CALL cl_err3("ins","oeo_file",new_no,"",STATUS,"","ins oeo:",1)  #No.FUN-650108
       ROLLBACK WORK
       RETURN
    END IF

    DROP TABLE x       #---------------------------------------- copy oap_file

    SELECT * FROM oap_file WHERE oap01=old_no INTO TEMP x
    IF STATUS THEN
       CALL cl_err3("ins","x",old_no,"",STATUS,"","oap- x:",1)   #No.FUN-650108
       ROLLBACK WORK
       RETURN
    END IF

    UPDATE x SET oap01=new_no

    INSERT INTO oap_file SELECT * FROM x
    IF STATUS THEN
       CALL cl_err3("ins","oap_file",new_no,"",STATUS,"","ins oap:",1)   #No.FUN-650108
       ROLLBACK WORK
       RETURN
    END IF

    DROP TABLE x         #---------------------------------------- copy oed_file
    SELECT * FROM oed_file WHERE oed01=old_no INTO TEMP x
    IF STATUS THEN
       CALL cl_err3("ins","x",old_no,"",STATUS,"","oed- x:",1)    #No.FUN-650108
       ROLLBACK WORK
       RETURN
    END IF

    UPDATE x SET oed01=new_no
    INSERT INTO oed_file SELECT * FROM x
    IF STATUS THEN
       CALL cl_err3("ins","oed_file",new_no,"",STATUS,"","ins oed:",1)  #No.FUN-650108
       ROLLBACK WORK
       RETURN
    END IF

    COMMIT WORK          #---------------------------------------- commit work

    CALL cl_msg("Copy Ok!")
    SELECT oea_file.* INTO g_oea.* FROM oea_file WHERE oea01=new_no   #mod by liuxqa 091020
    CALL t400_show() #FUN-6C0006
    CALL t400_u()
    SELECT oea_file.* INTO g_oea.* FROM oea_file WHERE oea01=old_no   #MOD-A70112
    CALL t400_show()   #MOD-A70112
END FUNCTION

FUNCTION t400_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-680137 VARCHAR(1)
DEFINE l_slip          LIKE oay_file.oayslip  #No.FUN-680137 VARCHAR(10)  #No.FUN-640013

   CASE p_flag
       WHEN 'N' FETCH NEXT     t400_cs INTO g_oea.oea01
       WHEN 'P' FETCH PREVIOUS t400_cs INTO g_oea.oea01
       WHEN 'F' FETCH FIRST    t400_cs INTO g_oea.oea01
       WHEN 'L' FETCH LAST     t400_cs INTO g_oea.oea01
       WHEN '/'
           IF (NOT mi_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0  ######add for prompt bug
              PROMPT g_msg CLIPPED,': ' FOR g_jump

                 ON IDLE g_idle_seconds
                    CALL cl_on_idle()

                 ON ACTION about         #MOD-4C0121
                    CALL cl_about()      #MOD-4C0121

                 ON ACTION help          #MOD-4C0121
                    CALL cl_show_help()  #MOD-4C0121

                 ON ACTION controlg      #MOD-4C0121
                    CALL cl_cmdask()     #MOD-4C0121

              END PROMPT

              IF INT_FLAG THEN
                 LET INT_FLAG = 0
                 EXIT CASE
              END IF
           END IF
           FETCH ABSOLUTE g_jump t400_cs INTO g_oea.oea01
           LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err('not found',SQLCA.sqlcode,0)        #No.TQC-6C0183
      INITIALIZE g_oea.* TO NULL   #No.TQC-6B0105
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
   END IF

   SELECT * INTO g_oea.* FROM oea_file WHERE oea01 = g_oea.oea01   #mod by liuxqa 091020
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","oea_file",g_oea.oea01,"",SQLCA.sqlcode,"","",1)  #No.FUN-650108
      INITIALIZE g_oea.* TO NULL
      RETURN
   END IF

   #在使用Q查詢的情況下得到當前對應的屬性組oay22
   IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
      LET l_slip = g_oea.oea01[1,g_doc_len]
      SELECT oay22 INTO lg_oay22 FROM oay_file
         WHERE oayslip = l_slip
   END IF

   SELECT * INTO g_occm.* FROM occm_file WHERE occm01=g_oea.oea01
   IF STATUS <> 0 THEN
      INITIALIZE g_occm.* TO NULL
   END IF

   LET g_data_owner = g_oea.oeauser      #FUN-4C0057 add
   LET g_data_group = g_oea.oeagrup      #FUN-4C0057 add
   LET g_data_plant = g_oea.oeaplant #FUN-980030
   CALL t400_show() #FUN-6C0006
END FUNCTION


FUNCTION t400_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
    DEFINE l_oea01      LIKE oea_file.oea01    #MOD-860316 add

    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_oea.* FROM oea_file WHERE oea01 = g_oea.oea01   #mod by liuxqa 091020
    IF g_oea.oea01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_oea.oeaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_oea.oeaconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
    SELECT SUM(oeb24) INTO g_oea.oea62 FROM oeb_file WHERE oeb01=g_oea.oea01
    IF g_oea.oea62 != 0 THEN CALL cl_err('','axm-162',0) RETURN END IF
     IF g_oea.oea49 matches '[Ss1]' THEN          #MOD-4A0299
         CALL cl_err("","mfg3557",0)
         RETURN
    END IF

    LET g_cnt= 0
    SELECT COUNT(*) INTO g_cnt FROM oma_file
     WHERE oma16 = g_oea.oea01
    IF g_cnt > 0 THEN
       CALL cl_err('','axm-610',0)
       RETURN
    END IF
    BEGIN WORK

    OPEN t400_cl USING g_oea.oea01      #mod by liuxqa 091020
    IF STATUS THEN
       CALL cl_err("OPEN t400_cl:", STATUS, 1)
       CLOSE t400_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH t400_cl INTO g_oea.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)
       CLOSE t400_cl ROLLBACK WORK RETURN
    END IF
    LET g_cnt= 0
    SELECT COUNT(*) INTO g_cnt FROM oep_file
     WHERE oep01=g_oea.oea01
    IF g_cnt>0 THEN
       LET g_msg=cl_getmsg('axm-500',g_lang)
       ERROR g_msg
    END IF
    IF NOT (cl_delete()) THEN
       RETURN
    END IF
    INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
    LET g_doc.column1 = "oea01"         #No.FUN-9B0098 10/02/24
    LET g_doc.value1 = g_oea.oea01      #No.FUN-9B0098 10/02/24
    CALL cl_del_doc()                            #No.FUN-9B0098 10/02/24
    CALL cl_msg("Delete oea,oeb,oem,oeo,oao,oap!")
    DELETE FROM oea_file WHERE oea01 = g_oea.oea01
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("del","oea_file",g_oea.oea01,"",SQLCA.sqlcode,"","No oea deleted",1)  #No.FUN-650108
       ROLLBACK WORK
       RETURN
    END IF

    DELETE FROM oeb_file WHERE oeb01 = g_oea.oea01
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#    DELETE FROM ata_file WHERE ata00=g_prog AND ata01=g_oea.oea01  #FUN-A50054
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END
    DELETE FROM rxc_file WHERE rxc00 = '01' AND rxc01 = g_oea.oea01   #NO.FUN-960130


    DELETE FROM oef_file WHERE oef01 = g_oea.oea01
    DELETE FROM oem_file WHERE oem01 = g_oea.oea01
    DELETE FROM oeo_file WHERE oeo01 = g_oea.oea01
    DELETE FROM oao_file WHERE oao01 = g_oea.oea01
    DELETE FROM oap_file WHERE oap01 = g_oea.oea01
    DELETE FROM oep_file WHERE oep01 = g_oea.oea01
    DELETE FROM oeq_file WHERE oeq01 = g_oea.oea01
    DELETE FROM tqw_file WHERE tqw01 = g_oea.oea01     #TQC-980029
    DELETE FROM oer_file WHERE oer01 = g_oea.oea01
    DELETE FROM oed_file WHERE oed01 = g_oea.oea01 #No.7946
    DELETE FROM azd_file WHERE azd01 = g_oea.oea01 AND azd02=25
    DELETE FROM azd_file WHERE azd01 = g_oea.oea01 AND azd02=26
    IF g_azw.azw04='2' THEN
      DELETE FROM rxx_file WHERE rxx00='01' AND rxx01=g_oea.oea01
      DELETE FROM rxy_file WHERE rxy00='01' AND rxy01=g_oea.oea01
      DELETE FROM rxz_file WHERE rxz00='01' AND rxz01=g_oea.oea01
    END IF
    IF g_oaz.oaz06 = 'Y' THEN
       FOR i =1 TO g_oeb.getlength()
          CALL s_mpslog('R','','','',g_oeb[i].oeb04,g_oeb[i].oeb12,
                         g_oeb[i].oeb15,g_oea.oea01,g_oeb[i].oeb03,'')
       END FOR
    END IF
    LET g_msg=TIME
    INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980004 add azoplant,azolegal
       VALUES ('axmt400',g_user,g_today,g_msg,g_oea.oea01,'delete',g_plant,g_legal) #FUN-980004 add g_plant,g_legal
    CLEAR FORM
    CALL g_oeb.clear()
    LET l_oea01 = g_oea.oea01   #MOD-860316 add
    INITIALIZE g_oea.* TO NULL
    LET g_oap.oap041=NULL #No.MOD-480274
    LET g_oap.oap042=NULL #No.MOD-480274
    LET g_oap.oap043=NULL #No.MOD-480274
    LET g_oap.oap044=NULL #FUN-720014
    LET g_oap.oap045=NULL #FUN-720014
    CALL cl_msg("")
    CLOSE t400_cl
    COMMIT WORK
    CALL cl_flow_notify(l_oea01,'D')   #MOD-860316 mod g_oea.oea01->l_oea01

    OPEN t400_count
    IF STATUS THEN
       CLOSE t400_count
    ELSE
       FETCH t400_count INTO g_row_count
       IF SQLCA.sqlcode THEN
          CLOSE t400_count
       ELSE
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN t400_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL t400_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET mi_no_ask = TRUE
             CALL t400_fetch('/')
          END IF
       END IF
    END IF
END FUNCTION

FUNCTION t400_show()
DEFINE l_oeaplant_desc LIKE azp_file.azp02 #No.FUN-870007
DEFINE l_oeaconu_desc LIKE gen_file.gen02  #No.FUN-870007
DEFINE l_ged02          LIKE ged_file.ged02     #TQC-980149


   IF g_oea.oea11='1' THEN LET g_oea.oea12='' END IF
   LET g_oea_t.* = g_oea.*                #保存單頭舊值

    DISPLAY BY NAME g_oea.oea00  ,g_oea.oea08  ,g_oea.oea01  ,g_oea.oea06  , g_oea.oeaoriu,g_oea.oeaorig,
                    g_oea.oea02  ,g_oea.oea11  ,g_oea.oea12  ,g_oea.oea03  ,
                    g_oea.oea032 ,g_oea.oea04  ,g_oea.oea1015,g_oea.oea17  ,
                    g_oea.oea14  ,g_oea.oea15  ,g_oea.oea1004,g_oea.oea10  ,
                    g_oea.oea25  ,g_oea.oea26  ,g_oea.oea23  ,g_oea.oea24  ,
                    g_oea.oea21  ,g_oea.oea211 ,g_oea.oea212 ,g_oea.oea213 ,
                    g_oea.oea31  ,g_oea.oea32  ,g_oea.oeamksg,g_oea.oeahold,
                    g_oea.oeaconf,g_oea.oea72  ,g_oea.oea49  ,g_oea.oea905 ,
                    g_oea.oea99  ,g_oea.oea50  ,g_oea.oea37  ,g_oea.oea044 ,
                    g_oea.oea41  ,g_oea.oea42  ,g_oea.oea43  ,g_oea.oea44  ,
                    g_oea.oea33  ,g_oea.oea09  ,g_oea.oea46  ,g_oea.oea47  ,
                    g_oea.oea48  ,g_oea.oea80  ,g_oea.oea81  ,
                    g_oea.oea161 ,g_oea.oea162 ,g_oea.oea163 ,
                    g_oea.oea261 ,g_oea.oea262 ,g_oea.oea263 ,    #No:FUN-A50103
                    g_oea.oea05  ,g_oea.oea18  ,
                    g_oea.oea07  ,g_oea.oea62  ,g_oea.oea63  ,g_oea.oea61  ,
                    g_oea.oea65  ,g_oea.oeauser,g_oea.oeagrup,g_oea.oeamodu,
                    g_oea.oeadate,g_oea.oeaud01,g_oea.oeaud02,g_oea.oeaud03,
                    g_oea.oeaud04,g_oea.oeaud05,g_oea.oeaud06,g_oea.oeaud07,
                    g_oea.oeaud08,g_oea.oeaud09,g_oea.oeaud10,g_oea.oeaud11,
                    g_oea.oeaud12,g_oea.oeaud13,g_oea.oeaud14,g_oea.oeaud15,
                    g_oea.oea1010,g_oea.oea1011,g_oea.oea1002,g_oea.oea1009,
                    g_oea.oea1003,g_oea.oea1005,g_oea.oea1012,g_oea.oea1013,
                    g_oea.oea1014,g_oea.oea1006,  #FUN-610055
                    g_oea.oea83  ,g_oea.oea84  ,g_oea.oea85  ,g_oea.oea86  ,
                    g_oea.oea87  ,g_oea.oeaplant ,g_oea.oeaconu,g_oea.oea88  ,
                    g_oea.oea89  ,g_oea.oea90  ,g_oea.oea91  ,g_oea.oea92  ,
                    g_oea.oea93  ,g_oea.oea94  ,g_oea.oeacont,                   #FUN-A50071 add oea94
                    g_oea.oea917       #FUN-820046   #No:FUN-A50103
#                   g_oea.oea918,g_oea.oea919       #FUN-8C0078 add   #No:FUN-A50103 Mark
    LET g_buf = s_get_doc_no(g_oea.oea01)
    SELECT oaydesc INTO g_buf FROM oay_file WHERE oayslip=g_buf
    DISPLAY g_buf TO oaydesc LET g_buf = NULL

  	  DISPLAY '' TO FORMONLY.oea43_43
   	  SELECT ged02 INTO l_ged02 FROM ged_file
  	   WHERE ged01 = g_oea.oea43
   	  DISPLAY l_ged02 TO FORMONLY.oea43_43

    SELECT azi03,azi04 INTO t_azi03,t_azi04               #No.CHI-6A0004
      FROM azi_file WHERE azi01=g_oea.oea23

    SELECT occ02 INTO g_buf FROM occ_file WHERE occ01=g_oea.oea04
    DISPLAY g_buf TO occ02 LET g_buf = NULL

    SELECT occ02 INTO g_buf FROM occ_file WHERE occ01=g_oea.oea1004
    DISPLAY g_buf TO occ02_a LET g_buf = NULL


    CALL t400_oea46()  #FUN-810045
    IF g_azw.azw04='2' THEN
       CALL t400_oea83('d')
       CALL t400_oea84('d')
       SELECT azp02 INTO l_oeaplant_desc FROM azp_file
        WHERE azp01 = g_plant
       IF NOT cl_null(g_oea.oeaconu) THEN
          SELECT gen02 INTO l_oeaconu_desc FROM gen_file
           WHERE gen01 = g_oea.oeaconu
          DISPLAY l_oeaconu_desc TO oeaconu_desc
       END IF
    END IF
    SELECT pmc03 INTO g_buf FROM pmc_file WHERE pmc01 = g_oea.oea1015 AND pmc14 = '6'
    DISPLAY g_buf TO FORMONLY.oea1015_occ02   #CHI-9A0052
    LET g_buf = NULL

   #CHI-A60026 mark --start--
   #SELECT tqk04,tqk05 INTO g_oea.oea32,g_oea.oea23 FROM tqk_file
   # WHERE tqk01=g_oea.oea03 
   #   AND tqk02=g_oea.oea1002
   #   AND tqk03=g_oea.oea17
   #DISPLAY BY NAME g_oea.oea32,g_oea.oea23
   #CHI-A60026 mark --end--

    SELECT gen02 INTO g_buf FROM gen_file WHERE gen01=g_oea.oea14
    DISPLAY g_buf TO gen02 LET g_buf = NULL

    SELECT gem02 INTO g_buf FROM gem_file WHERE gem01=g_oea.oea15
    DISPLAY g_buf TO gem02 LET g_buf = NULL

    SELECT oab02 INTO g_buf FROM oab_file WHERE oab01=g_oea.oea25
    DISPLAY g_buf TO oab02 LET g_buf = NULL

    SELECT oab02 INTO g_buf FROM oab_file WHERE oab01=g_oea.oea26
    DISPLAY g_buf TO oab02_2 LET g_buf = NULL

    SELECT oah02 INTO g_buf FROM oah_file WHERE oah01=g_oea.oea31
    DISPLAY g_buf TO oah02 LET g_buf = NULL

    SELECT oag02 INTO g_buf FROM oag_file WHERE oag01=g_oea.oea32
    DISPLAY g_buf TO oag02 LET g_buf = NULL

    SELECT oak02 INTO g_buf FROM oak_file WHERE oak01=g_oea.oeahold
    DISPLAY g_buf TO oak02 LET g_buf = NULL

    SELECT oag02 INTO g_buf FROM oag_file WHERE oag01=g_oea.oea80
    DISPLAY g_buf TO oag02_1 LET g_buf = NULL

    SELECT oag02 INTO g_buf FROM oag_file WHERE oag01=g_oea.oea81
    DISPLAY g_buf TO oag02_2 LET g_buf = NULL

    SELECT oac02 INTO g_buf FROM oac_file WHERE oac01=g_oea.oea41
    DISPLAY g_buf TO oac02 LET g_buf=NULL
    SELECT oac02 INTO g_buf FROM oac_file WHERE oac01=g_oea.oea42
    DISPLAY g_buf TO oac02_2 LET g_buf=NULL
    SELECT occ02 INTO g_buf FROM occ_file WHERE occ01=g_oea.oea17
    DISPLAY g_buf TO FORMONLY.oea17_ds LET g_buf=NULL
    SELECT pmc03 INTO g_buf FROM pmc_file WHERE pmc01=g_oea.oea47
    DISPLAY g_buf TO pmc03  LET g_buf = NULL
    SELECT pmc03 INTO g_buf FROM pmc_file WHERE pmc01=g_oea.oea1015
    DISPLAY g_buf TO FORMONLY.oea1015_occ02 LET g_buf = NULL
    SELECT ofs02 INTO g_buf FROM ofs_file WHERE ofs01=g_oea.oea48
    DISPLAY g_buf TO ofs02  LET g_buf = NULL
    --DIS--
    SELECT tqb02 INTO g_buf FROM tqb_file WHERE tqb01=g_oea.oea1010
    DISPLAY g_buf TO tqb02_a LET g_buf = NULL

    SELECT occ02 INTO g_buf FROM occ_file WHERE occ01=g_oea.oea1011
    DISPLAY g_buf TO occ02_d LET g_buf = NULL

    SELECT tqa02 INTO g_buf FROM tqa_file WHERE tqa01=g_oea.oea1002 AND tqa03 = '20'
    DISPLAY g_buf TO tqa02_a LET g_buf = NULL

    SELECT tqa02 INTO g_buf FROM tqa_file WHERE tqa01=g_oea.oea1009 AND tqa03 = '19'
    DISPLAY g_buf TO tqa02_b LET g_buf = NULL

    SELECT tqb02 INTO g_buf FROM tqb_file WHERE tqb01=g_oea.oea1003
    DISPLAY g_buf TO tqb02_b LET g_buf = NULL
    --DIS--


   CALL s_addr(g_oea.oea01,g_oea.oea04,g_oea.oea044)
        RETURNING g_oap.oap041,g_oap.oap042,g_oap.oap043,g_oap.oap044,g_oap.oap045  #FUN-720014 add oap044/045
   DISPLAY BY NAME g_oap.oap041,g_oap.oap042,g_oap.oap043,g_oap.oap044,g_oap.oap045 #FUN-720014 add oap044/045

   CALL t400_oea_sum() #MOD-AC0205 Add

   CALL t400_pic()

   CALL t400_show_oao()

   CALL t400_b_fill(g_wc2)                 #單身

   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

   IF g_aza.aza50='Y' THEN
      CALL t400_b1_fill(g_wc4)     #FUN-610055
   END IF
END FUNCTION

FUNCTION t400_g_b()                    #由合約自動產生單身
   IF g_oea.oea11='3' OR g_oea.oea11='8' THEN   #No.FUN-740016  #MOD-6A0171 mark OR g_oea.oea11="A" THEN   #No.FUN-610053
      SELECT COUNT(*) INTO g_cnt FROM oeb_file
       WHERE oeb01=g_oea.oea01
      IF g_cnt > 0 THEN RETURN END IF		#已有單身則不可再產生
      CALL t400_g_b2()
      CALL t400_b_fill(' 1=1')
      IF g_aza.aza50 = 'N' THEN  #No.FUN-650108
         CALL t400_bu()     #FUN-610055
      ELSE   #No.FUN-650108
         CALL t400_oea_sum()  #FUN-610055
      END IF #No.FUN-650108
   END IF
END FUNCTION

FUNCTION t400_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(200)
   DEFINE l_sql STRING       #NO.TQC-740135
   DEFINE l_sql2 STRING      #No.FUN-810016
   DEFINE l_sql3 STRING      #No.FUN-810016
#FUN-A60035 ---MARK BEGIN
#  DEFINE l_sum14  LIKE oeb_file.oeb14  #FUN-A50054 add
#  DEFINE l_sum14t LIKE oeb_file.oeb14t #FUN-A50054 add
#  #FUN-A60035 ---add begin
#  DEFINE l_oeb03  DYNAMIC ARRAY OF RECORD
#         oeb03    LIKE oeb_file.oeb03
#         END RECORD
#  DEFINE l_i      LIKE type_file.num5
#  DEFINE l_go     LIKE type_file.chr1
#  #FUN-A60035 ---add end
#FUN-A60035 ---MARK END

    LET l_sql =                         #NO.TQC-740135
        "SELECT oeb03,'',oeb71,oeb935,oeb936,oeb937,oeb49,oeb50,oeb04,'','','','','','','','','',", #No.FUN-A90040
        "       '','','','','','','','','','','','',oeb06,ima021,ima1002,ima135,oeb918,oeb11,",   #No.FUN-640013 #TQC-750163  #No.FUN-810016 #FUN-820033 #FUN-A80054
        "       oeb1001,oeb1012,",    #TQC-750163  oeb71搬到oeb04之前
        "       oeb906,oeb092,oeb15,oeb30,oeb31,oeb32,oeb05,oeb12,",  #FUN-5C0076   #No.FUN-740016  FUN-A80024
        "       oeb913,oeb914,oeb915,oeb910,oeb911,oeb912,",
        "       oeb916,oeb917,oeb29,oeb24,oeb25,oeb27,oeb28,oeb1004,oeb1002,",  #NO.FUN-670007   #No.FUN-740016
        "       oeb37,oeb13,oeb1006,oeb14,oeb14t,oeb919,oeb41,oeb42,oeb43,oeb09,oeb091,oeb930,'',oeb908,oeb22,oeb19,", #FUN-670063  #FUN-810045 add oeb41/42/43 #FUN-A80102     #FUN-AB0061 add oeb37
        "       oeb70,ima15,oeb16, ",   #No.FUN-6B0151 add oeb16
        "       '','','','','', ",       #No.FUN-7C0017
        "       oebud01,oebud02,oebud03,oebud04,oebud05,oebud06,oebud07,oebud08,oebud09,oebud10,oebud11,oebud12,oebud13,oebud14,oebud15,", #No.FUN-840011
        "       oeb44,oeb45,oeb46,oeb47,oeb48", #No.FUN-870007
        " FROM oeb_file LEFT OUTER JOIN  ima_file ON oeb04 = ima01",
        " WHERE oeb01 ='",g_oea.oea01,"'",  #單頭
        " AND ",p_wc2 CLIPPED,                     #單身
       #" AND oeb1003='1' ",    #TQC-AC0163 By shi
        " AND oeb03<'9001' ",   #TQC-AC0163 By shi
        " ORDER BY oeb03"
    PREPARE t400_pb FROM l_sql
    DECLARE oebglobal_curs                       #CURSOR
        CURSOR WITH HOLD FOR t400_pb
#FUN-A60035 ---MARK BEGIN
#&ifdef SLK
#    LET l_sum14 = 0  #FUN-A50054 add
#    LET l_sum14t= 0  #FUN-A50054 add
#&endif   
#FUN-A60035 ---MARK END
    CALL g_oeb.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH oebglobal_curs INTO g_oeb[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#          IF g_oea.oeaslk02 = 'Y' THEN
#             SELECT ata02,ata05 INTO g_oeb[g_cnt].oeb03,g_oeb[g_cnt].oeb04
#               FROM ata_file
#              WHERE ata00 = g_prog
#                AND ata01 = g_oea.oea01
#                AND ata03 = g_oeb[g_cnt].oeb03
#             LET l_oeb03[l_oeb03.getLength() + 1] = g_oeb[g_cnt].oeb03   #FUN-A60035 add
# 
#   SELECT SUM(oeb14),SUM(oeb14t) INTO l_sum14,l_sum14t  
#   FROM oeb_file WHERE oeb01 = g_oea.oea01
#    AND  oeb03 IN  (SELECT ata03 FROM ata_file WHERE ata00 = g_prog
#    AND  ata01 = g_oea.oea01 
#    AND  ata02 =  g_oeb[g_cnt].oeb03 ) 

#      LET g_oeb[g_cnt].oeb14=l_sum14
#      LET g_oeb[g_cnt].oeb14t=l_sum14t
#  #          LET l_sum14t = g_oeb[g_cnt].oeb14t+l_sum14t
#             IF g_cnt > 1 THEN
#          #FUN-A60035 ---mark begin
#          #     IF g_oeb[g_cnt].oeb03 = g_oeb[g_cnt-1].oeb03 THEN
#          #        CONTINUE FOREACH
#          #     ELSE
#          #   #    LET g_oeb[g_cnt-1].oeb14=l_sum14
#          #   #    LET g_oeb[g_cnt-1].oeb14t=l_sum14t
#          #   #    LET l_sum14 =0
#          #   #    LET l_sum14t=0
#          #     END IF
#          #FUN-A60035 ---mark end
#          #FUN-A60035 ---add begin
#                LET l_go = 'N'
#                FOR l_i = 1 TO l_oeb03.getLength()-1
#                    IF g_oeb[g_cnt].oeb03 = l_oeb03[l_i].oeb03 THEN
#                       LET l_go = 'Y'
#                       EXIT FOR
#                    END IF
#                END FOR
#                IF l_go = 'Y' THEN
#                   CONTINUE FOREACH
#                END IF
#           #FUN-A60035 ---add end
#             END IF
#             SELECT SUM(ata08) INTO g_oeb[g_cnt].oeb12 from ata_file
#              WHERE ata00 = g_prog
#                AND ata01 = g_oea.oea01
#                AND ata02 = g_oeb[g_cnt].oeb03
#             
#          ELSE
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END

        #如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改
        IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
              #得到該料件對應的父料件和所有屬性
              SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,
                     imx07,imx08,imx09,imx10 INTO
                     g_oeb[g_cnt].att00,g_oeb[g_cnt].att01,g_oeb[g_cnt].att02,
                     g_oeb[g_cnt].att03,g_oeb[g_cnt].att04,g_oeb[g_cnt].att05,
                     g_oeb[g_cnt].att06,g_oeb[g_cnt].att07,g_oeb[g_cnt].att08,
                     g_oeb[g_cnt].att09,g_oeb[g_cnt].att10
              FROM imx_file WHERE imx000 = g_oeb[g_cnt].oeb04

              LET g_oeb[g_cnt].att01_c = g_oeb[g_cnt].att01
              LET g_oeb[g_cnt].att02_c = g_oeb[g_cnt].att02
              LET g_oeb[g_cnt].att03_c = g_oeb[g_cnt].att03
              LET g_oeb[g_cnt].att04_c = g_oeb[g_cnt].att04
              LET g_oeb[g_cnt].att05_c = g_oeb[g_cnt].att05
              LET g_oeb[g_cnt].att06_c = g_oeb[g_cnt].att06
              LET g_oeb[g_cnt].att07_c = g_oeb[g_cnt].att07
              LET g_oeb[g_cnt].att08_c = g_oeb[g_cnt].att08
              LET g_oeb[g_cnt].att09_c = g_oeb[g_cnt].att09
              LET g_oeb[g_cnt].att10_c = g_oeb[g_cnt].att10
        END IF
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#           END IF
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END
        LET g_oeb[g_cnt].gem02c=s_costcenter_desc(g_oeb[g_cnt].oeb930) #FUN-670063
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_oeb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
       DISPLAY g_rec_b TO FORMONLY.cn2 #No.FUN-650108
    LET g_cnt = 0

    CALL t400_refresh_detail()  #No.FUN-640013   刷新單身的欄位顯示
    DISPLAY g_rec_b TO FORMONLY.cn3 #FUN-710074
    DISPLAY g_rec_b TO FORMONLY.cn2 #No.MOD-670123 #FUN-710074
END FUNCTION

FUNCTION t400_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)


   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_argv1 != '1' THEN
      CALL cl_set_act_visible("carry_pr,carry_po", FALSE)  #FUN-6C0050 add carry_po
   END IF
   IF g_oea901 != 'Y' THEN
      CALL cl_set_act_visible("mul_trade,mul_trade_other,restore", FALSE)
   END IF

   CALL t400_b1_fill('1=1')   #No.FUN-650108

   DISPLAY ARRAY g_oeb1 TO s_oeb1.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)

      BEFORE DISPLAY
            LET g_chr='@'
            IF g_argv1 <> '1' THEN
               CALL cl_set_act_visible("carry_pr,carry_po",FALSE)  #FUN-6C0050 add carry_po
            END IF

         #上下筆資料的ToolBar控制.
         CALL cl_navigator_setting(g_curs_index, g_row_count)

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION deliver
         LET g_action_flag="deliver"
         EXIT DISPLAY

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY

      ON ACTION first
         CALL t400_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION previous
         CALL t400_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION jump
         CALL t400_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION next
         CALL t400_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION last
         CALL t400_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      #No.FUN-A10106--begin
      ON ACTION kefa  
         LET g_action_choice="kefa"
         EXIT DISPLAY
      #No.FUN-A10106--end
     #多角貿易
      ON ACTION mul_trade
         LET g_action_choice="mul_trade"
         EXIT DISPLAY

      ON ACTION mul_trade_other
         LET g_action_choice="mul_trade_other"
         EXIT DISPLAY

     #多角貿易拋轉還原
      ON ACTION restore
         LET g_action_choice="restore"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY


#@    ON ACTION 拋轉請購單
      ON ACTION carry_pr
         LET g_action_choice="carry_pr"
         EXIT DISPLAY
#@    ON ACTION 拋轉請購單
      ON ACTION carry_po
         LET g_action_choice="carry_po"
         EXIT DISPLAY

#@    ON ACTION 備置
      ON ACTION allocate
         LET g_action_choice="allocate"
         EXIT DISPLAY


#@    ON ACTION 受訂庫存查詢
      ON ACTION qry_inv_ordered
         LET g_action_choice="qry_inv_ordered"
         EXIT DISPLAY

#@    ON ACTION CSD資料
      ON ACTION csd_data
         LET g_action_choice="csd_data"
         EXIT DISPLAY

#@    ON ACTION 費用資料
      ON ACTION expense_data
         LET g_action_choice="expense_data"
         EXIT DISPLAY

#@    ON ACTION 留置
      ON ACTION on_hold
         LET g_action_choice="on_hold"
         EXIT DISPLAY

#@    ON ACTION 取消留置
      ON ACTION undo_on_hold
         LET g_action_choice="undo_on_hold"
         EXIT DISPLAY

#@    ON ACTION 訂單相關查詢
      ON ACTION order_query
         LET g_action_choice="order_query"
         EXIT DISPLAY

#@    ON ACTION 客戶相關查詢
      ON ACTION query_customer
         LET g_action_choice="query_customer"
         EXIT DISPLAY

#@    ON ACTION QR查詢
      ON ACTION query_qr
          LET g_action_choice="query_qr"    #MOD-530157
         EXIT DISPLAY

#@    ON ACTION 變更狀況
      ON ACTION change_status
         LET g_action_choice="change_status"
         EXIT DISPLAY

#FUN-A70132 --Begin--
      ON ACTION detail_tax
         LET g_action_choice="detail_tax"
         EXIT DISPLAY
#FUN-A70132 --End--           

#@    ON ACTION 相關文件
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

#@    ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY

      ON ACTION pref
         LET g_action_choice="pref"
         EXIT DISPLAY

      ON ACTION discount_allowed
         LET g_action_choice="discount_allowed"
         EXIT DISPLAY

       ON ACTION easyflow_approval     #MOD-4A0299
         LET g_action_choice="easyflow_approval"
         EXIT DISPLAY

#@    ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

#@    ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY

#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

         CALL t400_pic()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      #@ON ACTION 簽核狀況
       ON ACTION approval_status     #MOD-4C0041
         LET g_action_choice="approval_status"
         EXIT DISPLAY


      AFTER DISPLAY
         CONTINUE DISPLAY

      #@ON ACTION 其他資料
      ON ACTION other_data
         LET g_action_choice="other_data"
         EXIT DISPLAY

      ON ACTION agree
         LET g_action_choice = 'agree'
         EXIT DISPLAY

      ON ACTION deny
         LET g_action_choice = 'deny'
         EXIT DISPLAY

      ON ACTION modify_flow
         LET g_action_choice = 'modify_flow'
         EXIT DISPLAY

      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DISPLAY

      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DISPLAY

      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DISPLAY

      &include "qry_string.4gl"

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t400_b1()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680137 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-680137 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-680137 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680137 SMALLINT
   l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-680137 SMALLINT

   LET g_action_choice = ""
   SELECT * INTO g_oea.* FROM oea_file WHERE oea01= g_oea.oea01   #mod by liuxqa 091020
   LET g_oea49 = g_oea.oea49          #MOD-4A0299
   IF g_oea.oea01 IS NULL THEN RETURN END IF
   IF g_oea.oeaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_oea.oeaconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   IF g_oea.oea61 > 0 AND g_oea.oea61 = g_oea.oea62 THEN
      CALL cl_err('','axm-162',0)
      RETURN
   END IF
   IF g_oea.oea49 matches '[Ss]' THEN          #MOD-4A0299
      CALL cl_err('','apm-030',0)
      RETURN
   END IF
   CALL cl_opmsg('b')

   SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file             #No.CHI-6A0004
    WHERE azi01=g_oea.oea23

    LET g_forupd_sql = "SELECT oeb03,oeb1007,'','','',oeb1008,",
                      "       oeb1009,oeb1010,oeb1011,",
                      "       oeb1001,oeb14,oeb14t ",
                      "  FROM oeb_file ",
                      " WHERE oeb01= ? AND oeb03= ?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t400_b1cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_oeb1 WITHOUT DEFAULTS FROM s_oeb1.*
         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
          LET g_before_input_done = FALSE
          LET g_before_input_done = TRUE

       BEFORE ROW
          LET p_cmd = ''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'                   #DEFAULT

          BEGIN WORK

          OPEN t400_cl USING g_oea.oea01      #mod by liuxqa 091020
          IF STATUS THEN
             CALL cl_err("OPEN t400_cl:", STATUS, 1)
             CLOSE t400_cl
             ROLLBACK WORK
             RETURN
          END IF

          FETCH t400_cl INTO g_oea.*  # 鎖住將被更改或取消的資料
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)     # 資料被他人LOCK
             CLOSE t400_cl
             ROLLBACK WORK
             RETURN
          END IF

          IF g_rec_b1 >= l_ac THEN
             LET p_cmd='u'
             LET g_oeb1_t.* = g_oeb1[l_ac].*  #BACKUP

             OPEN t400_b1cl USING g_oea.oea01,g_oeb1_t.oeb03_1
             IF STATUS THEN
                CALL cl_err("OPEN t400_b1cl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t400_b1cl INTO g_oeb1[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err('lock oeb',SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
                IF NOT cl_null(g_oeb1[l_ac].oeb1007) THEN
                   SELECT tqw16,tqw07,tqw08
                     INTO g_oeb1[l_ac].tqw16,g_oeb1[l_ac].tqw07,g_oeb1[l_ac].tqw08
                     FROM tqw_file
                    WHERE tqw01 = g_oeb1[l_ac].oeb1007
                      AND tqw10 = '3'
                      AND tqw17 = g_oea.oea23
                      AND tqw05 = g_oea.oea03
                END IF
             END IF
             CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF

       BEFORE INSERT
          LET p_cmd='a'
          INITIALIZE g_oeb1[l_ac].* TO NULL
          LET g_oeb1[l_ac].oeb14_1=0
          LET g_oeb1[l_ac].oeb14t_1=0
          LET g_oeb1_t.* = g_oeb1[l_ac].*
          CALL cl_show_fld_cont()     #FUN-550037(smin)
          IF g_aza.aza50 ='Y' AND (NOT cl_null(g_oea.oea12)) AND g_prog ='axmt410' THEN
             IF cl_confirm("axm-475") THEN
                CALL t400_obj_return()
             END IF
          END IF
          NEXT FIELD oeb03_1

       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          IF NOT t400_b1_ins() THEN
             CANCEL INSERT
          ELSE
             CALL cl_msg('INSERT O.K')
             LET g_rec_b1=g_rec_b1+1
             DISPLAY g_rec_b1 TO FORMONLY.cn4
             CALL t400_oea_sum()        #FUN-610055
             COMMIT WORK
          END IF

       BEFORE FIELD oeb03_1                          #default 序號
          CALL t400_b1_bef_oeb03(p_cmd)

       AFTER FIELD oeb03_1                        #check 序號是否重複
          IF NOT t400_b1_chk_oeb03() THEN
             NEXT FIELD CURRENT
          ELSE    #MOD-870031
             CALL t400_set_no_entry_b(p_cmd,'N')   #MOD-870031
          END IF

       BEFORE FIELD oeb1007
          CALL t400_set_entry_b1()

       AFTER FIELD oeb1007
          IF NOT t400_b1_chk_oeb1007(p_cmd) THEN
             NEXT FIELD CURRENT
          END IF

       BEFORE FIELD oeb14_1
          CALL t400_b1_bef_oeb14()

       AFTER FIELD oeb14_1
          IF NOT t400_b1_chk_oeb14() THEN
             NEXT FIELD CURRENT
          END IF

       AFTER FIELD oeb14t_1
          IF NOT t400_b1_chk_oeb14t() THEN
             NEXT FIELD CURRENT
          END IF

       BEFORE DELETE                            #是否取消單身
          IF g_oeb1_t.oeb03_1 > 0 AND g_oeb1_t.oeb03_1 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF

             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF

             IF NOT t400_b1_del() THEN
                ROLLBACK WORK
                CANCEL DELETE
             ELSE
                CALL t400_oea_sum()        #FUN-610055
                COMMIT WORK
                LET g_rec_b1=g_rec_b1-1
                DISPLAY g_rec_b1 TO FORMONLY.cn4
             END IF
          END IF

       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_oeb1[l_ac].* = g_oeb1_t.*
              CLOSE t400_b1cl
              ROLLBACK WORK
              EXIT INPUT
           END IF

           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_oeb1[l_ac].oeb03_1,-263,1)
              LET g_oeb1[l_ac].* = g_oeb1_t.*
           ELSE
              IF NOT t400_b1_upd() THEN
                 CONTINUE INPUT
              ELSE
                 CALL cl_msg('UPDATE O.K')
                 LET g_oea49= '0'      #MOD-4A0299
                 CALL t400_oea_sum()        #FUN-610055
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
                 LET g_oeb1[l_ac].* = g_oeb1_t.*
              END IF
              CLOSE t400_b1cl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           SELECT oaz681 INTO g_oaz.oaz681 FROM oaz_file   #FUN-610055
           LET g_cnt=0
           SELECT COUNT(*) INTO g_cnt FROM oeb_file WHERE oeb01=g_oea.oea01
           IF (g_oea.oea08='1' AND g_cnt > g_oaz.oaz681) OR
              (g_oea.oea08 MATCHES '[23]' AND g_cnt > g_oaz.oaz682) THEN
                CALL cl_err('','axm-156',0) NEXT FIELD oeb03_1
           END IF
           CLOSE t400_b1cl
           COMMIT WORK

       ON ACTION controlo
          IF (l_ac > 1) THEN
             LET g_oeb1[l_ac].* = g_oeb1[l_ac-1].*
             LET g_oeb1[l_ac].oeb03_1 = NULL
          END IF

      ON ACTION CONTROLF
        CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913


       ON ACTION CONTROLR
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON ACTION controlp
          CASE
             WHEN INFIELD(oeb1007)
                CALL cl_init_qry_var()
                IF g_prog !='axmt410' THEN
                   LET g_qryparam.form ="q_tqw"
                   LET g_qryparam.default1 = g_oeb1[l_ac].oeb1007
                   LET g_qryparam.arg1 = g_oea.oea23
                   LET g_qryparam.arg2 = g_oea.oea03
                ELSE
                   LET g_qryparam.form ="q_tqw2"
                   LET g_qryparam.default1 = g_oeb1[l_ac].oeb1007
                   LET g_qryparam.arg1 = g_oea.oea03
                   LET g_qryparam.arg2 = g_oea.oea23
#                  LET g_qryparam.arg3 = g_oea.oea01      #TQC-AC0035
                END IF
                CALL cl_create_qry() RETURNING g_oeb1[l_ac].oeb1007
                DISPLAY BY NAME g_oeb1[l_ac].oeb1007
                NEXT FIELD oeb1007
          END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

     ON ACTION about         #MOD-4C0121
        CALL cl_about()      #MOD-4C0121

     ON ACTION help          #MOD-4C0121
        CALL cl_show_help()  #MOD-4C0121


   END INPUT
   #MOD-4A0299
   UPDATE oea_file SET oeamodu = g_user,oeadate = g_today,oea49 = g_oea49
    WHERE oea01 = g_oea_t.oea01   #mod by liuxqa 091020
   LET g_oea.oea49 = g_oea49
   DISPLAY BY NAME g_oea.oea49              #MOD-4A0299
   CALL t400_pic()

   SELECT COUNT(*) INTO g_cnt FROM oeb_file WHERE oeb01=g_oea.oea01
   CLOSE t400_b1cl
   COMMIT WORK

   IF g_oea.oea50='Y' THEN
      IF g_oea.oea55!=g_oea.oea61 THEN
         IF cl_confirm('axm-121') THEN
            CALL t400_csd_price()
         END IF
      END IF
   END IF

   LET g_t1=s_get_doc_no(g_oea.oea01)
   SELECT * INTO g_oay.* FROM oay_file WHERE oayslip=g_t1
   IF STATUS THEN
      CALL cl_err3("sel","oay_file",g_t1,"",STATUS,"","sel oay_file",1)  #No.FUN-650108
      RETURN
   END IF
   IF (g_oea.oeaconf='Y' OR g_oay.oayconf='N') #單據已確認或單據不需自動確認
      THEN RETURN
   ELSE
      LET g_action_choice = "insert"       #TQC-720023
      CALL t400sub_y_chk('1',g_oea.oea01)         #CALL 原確認的 check 段 #FUN-610055 #FUN-730012
      IF g_success = "Y" THEN
          CALL t400sub_y_upd(g_oea.oea01,g_action_choice)    #CALL 原確認的 update 段 #FUN-730012 #TQC-720023
          CALL t400sub_refresh(g_oea.oea01)  RETURNING g_oea.* #FUN-730012 更新g_oea
          CALL t400_show() #FUN-6C0006
      END IF
      LET g_action_choice = " "            #TQC-720023
   END IF
   IF g_oay.oayprnt='Y' THEN CALL t400_out() END IF   #單據需立即列印
END FUNCTION

###以下由saxmt400 global移過來### #FUN-730002

FUNCTION t400_init()

#TQC-AC0034 --begin--
#   IF g_aza.aza26 = '0' THEN
#      CALL cl_set_comp_visible("page07",FALSE)
#   END IF
#TQC-AC0034 --end--

   IF g_aza.aza50 = 'N'THEN
       CALL cl_set_comp_visible("oea1010,oea1011,oea1002,oea1009,oea1003,                                 oea1005,oea1012,oea1013,oea1014,ima1002,                                 ima135,oeb1012,oeb1004,oeb1002,                                 oeb1006,oeb09,oeb091,tqa02_a,tqa02_b,tqb02_b,                                 oea1011,occ02_d,oea1010,tqb02_a,ttl2,ttl1,                                 ttl3,oea1006,cn3,dummy01,dummy02,page07,",FALSE)
       CALL cl_set_act_visible("pref,discount_allowed",FALSE)
   END IF
   IF g_aza.aza50 = 'Y' THEN              #NO.MOD-780155
       CALL cl_set_comp_required("oeb1001",TRUE)
   END IF                                 #no.MOD-780155

   # 流通配銷合約的畫面先設定與訂單一樣

    IF g_oea901 = 'N' THEN
       CALL cl_set_comp_visible("oea905,oea99",FALSE)
    END IF

    #非一般行業別的單身欄位一律隱藏,個別行業別自行打開
    IF g_aza.aza50='Y' THEN

       CALL cl_set_comp_visible("ima1002,ima135,oeb1012,oeb1004,oeb1002,                                 oeb1006,oeb09,oeb091,",TRUE)
    ELSE
       CALL cl_set_comp_visible("ima1002,ima135,oeb1012,oeb1004,oeb1002,                                 oeb1006,oeb09,oeb091,",FALSE)
    END IF

    CALL cl_set_comp_visible("oeb911,oeb914",FALSE)
    IF g_sma.sma115 ='N' THEN
       CALL cl_set_comp_visible("oeb913,oeb914,oeb915",FALSE)
       CALL cl_set_comp_visible("oeb910,oeb911,oeb912",FALSE)
    ELSE
       CALL cl_set_comp_visible("oeb05,oeb12",FALSE)
    END IF
    IF g_sma.sma116 MATCHES '[01]' THEN   #FUN-610076
       CALL cl_set_comp_visible("oeb916,oeb917",FALSE)
    END IF
#No.FUN-A80024 --begin
    IF g_argv1 <>'0' THEN 
       CALL cl_set_comp_visible("oeb32",FALSE)
    END IF 
#No.FUN-A80024 --end

    CALL cl_set_comp_visible("oeb930,gem02c",g_aaz.aaz90='Y')  #FUN-670063

   CALL cl_set_comp_visible("oeb41,oeb42,oeb43,oea46,pja02",g_aza.aza08='Y')
   CALL cl_set_comp_visible("oeb1002",g_azw.azw04='2')  #No.FUN-870007
   CALL cl_set_comp_visible("oeb919",g_sma.sma1421='Y')  #FUN-A80102
    #初始化界面的樣式(沒有任何默認屬性組)
    LET lg_oay22 = ''
    LET lg_group = ''
    CALL t400_refresh_detail()

    IF fgl_getenv('EASYFLOW') = "1" THEN   #判斷是否為簽核模式
       LET g_argv2 = aws_efapp_wsk(1)   #取得單號
    END IF

    #建立簽核模式時的 toolbar icon
    CALL aws_efapp_toolbar()
    CALL t400_set_perlang() #FUN-710037
END FUNCTION

FUNCTION t400_g_b2()                  #由合約產生單身
   DEFINE #l_sql    LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(600)
          l_sql   STRING,      #NO.FUN-910082
          l_oeo    RECORD LIKE oeo_file.*
   DEFINE l_oeb912 LIKE oeb_file.oeb912,
          l_oeb915 LIKE oeb_file.oeb915,
          l_oeb917 LIKE oeb_file.oeb917
   DEFINE l_oeb930 LIKE oeb_file.oeb930 #FUN-670063
   DEFINE l_oea01  LIKE oea_file.oea01,  #MOD-B30224
          l_oeb03  LIKE oeb_file.oeb03,  #MOD-B30224
          l_msg    STRING                #MOD-B30224

   IF g_oea.oea00 = "9" THEN
      IF NOT cl_confirm('axm-114') THEN
         RETURN
      END IF
   ELSE
      IF NOT cl_confirm('axm-133') THEN
         RETURN
      END IF
   END IF

   LET l_oeb930=s_costcenter(g_oea.oea15) #FUN-670063
   LET l_sql = " SELECT * FROM oeo_file ",
               "  WHERE oeo01=? AND oeo03=? "
   PREPARE oeo_pre FROM l_sql
   DECLARE oeo_cur CURSOR FOR oeo_pre

  IF g_oea.oea00 = "9" THEN
     LET l_sql = "SELECT * FROM oeb_file ",
                 " WHERE oeb01='",g_oea.oea12,"' ",
                 "   AND (oeb24-oeb25-oeb29)>0 AND oeb70='N'"
  ELSE
     LET l_sql = "SELECT * FROM oeb_file ",
                 " WHERE oeb01='",g_oea.oea12,"' ",
                 "   AND (oeb12-oeb24+oeb25)>0 AND oeb70='N'",
 #               "   AND oeb32 > '",g_oea.oea02,"'"         #No.FUN-A80024             #TQC-AC0251 
                 "   AND oeb32 >= '",g_oea.oea02,"'"                                   #TQC-AC0251 
  END IF #TQC-8A0073 add
    PREPARE t400_g_b_c2_pre FROM l_sql
    DECLARE t400_g_b_c2                      #CURSOR
        CURSOR WITH HOLD FOR t400_g_b_c2_pre

   FOREACH t400_g_b_c2 INTO b_oeb.*
     IF STATUS THEN EXIT FOREACH END IF

     IF g_oea.oea00="9" THEN
        IF cl_null(b_oeb.oeb24) THEN
           LET b_oeb.oeb24 = 0
        END IF
        IF cl_null(b_oeb.oeb25) THEN
           LET b_oeb.oeb25 = 0
        END IF
        IF cl_null(b_oeb.oeb29) THEN
           LET b_oeb.oeb29 = 0
        END IF
        LET b_oeb.oeb12 = b_oeb.oeb24-b_oeb.oeb25-b_oeb.oeb29
        LET b_oeb.oeb24 = 0
        LET b_oeb.oeb25 = 0
        LET b_oeb.oeb29 = 0
        LET b_oeb.oeb09 = g_oaz.oaz78
        LET b_oeb.oeb091 = ' '
        LET b_oeb.oeb092 = g_oea.oea03
        DISPLAY BY NAME b_oeb.oeb09,b_oeb.oeb091,b_oeb.oeb092
     END IF

     # 如果已有轉入過則必須先減去數量
     SELECT SUM(oeb912),SUM(oeb915),SUM(oeb917) INTO l_oeb912,l_oeb915,l_oeb917 FROM oeb_file, oea_file
        WHERE oea12=b_oeb.oeb01 AND oeb71=b_oeb.oeb03 AND
             #oea11 ='3' AND oeb01=oea01
              oea11 =g_oea.oea11 AND oeb01=oea01   #No.FUN-610053
     IF cl_null(l_oeb912) THEN
        LET l_oeb912 = 0
     END IF
     IF cl_null(l_oeb915) THEN
        LET l_oeb915 = 0
     END IF
     IF cl_null(l_oeb917) THEN
        LET l_oeb917 = 0
     END IF
     LET b_oeb.oeb912 = b_oeb.oeb912 - l_oeb912
     LET b_oeb.oeb915 = b_oeb.oeb915 - l_oeb915
     LET b_oeb.oeb917 = b_oeb.oeb917 - l_oeb917
     LET b_oeb.oeb01 = g_oea.oea01
     LET b_oeb.oeb71 = b_oeb.oeb03
     CALL t400_g_b_detail()
     LET b_oeb.oeb17 = b_oeb.oeb13  #no.7150
     LET b_oeb.oeb19 = 'N'   #MOD-9A0154
     LET b_oeb.oeb905= 0            #no.7182
     LET b_oeb.oeb24 = 0 LET b_oeb.oeb25 = 0 LET b_oeb.oeb26 = 0
     MESSAGE b_oeb.oeb03,' ',b_oeb.oeb04,' ',b_oeb.oeb12

     IF cl_null(b_oeb.oeb091) THEN LET b_oeb.oeb091=' ' END IF
     IF cl_null(b_oeb.oeb092) THEN LET b_oeb.oeb092=' ' END IF
     LET b_oeb.oeb1003 = '1'
     LET b_oeb.oeb930=l_oeb930  #FUN-670063
     LET b_oeb.oebplant = g_plant #FUN-980004 add
     LET b_oeb.oeblegal = g_legal #FUN-980004 add
     IF cl_null(b_oeb.oeb1006) THEN LET b_oeb.oeb1006 = 100 END IF   #MOD-A10123
     INSERT INTO oeb_file VALUES(b_oeb.*)
     IF STATUS OR SQLCA.SQLCODE THEN
        CALL cl_err3("ins","oeb_file",b_oeb.oeb01,"",SQLCA.sqlcode,"","ins oeb:",1)  #No.FUN-650108
     END IF
     OPEN oeo_cur USING g_oea.oea12,b_oeb.oeb03
     IF SQLCA.sqlcode THEN
        CALL cl_err('oeo_cur',SQLCA.SQLCODE,1)
     END IF

     FOREACH oeo_cur INTO l_oeo.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach oeo_cur',SQLCA.SQLCODE,1)
        END IF
        LET l_oeo.oeo01 = b_oeb.oeb01
        LET l_oeo.oeo03 = b_oeb.oeb03
        LET l_oeo.oeoplant = g_plant #FUN-980010 add
        LET l_oeo.oeolegal = g_legal #FUN-980010 add

        INSERT INTO oeo_file VALUES(l_oeo.*)
        IF STATUS OR SQLCA.SQLCODE THEN
           CALL cl_err3("ins","oeo_file",l_oeo.oeo01,"",SQLCA.sqlcode,"","ins oeo:",1)  #No.FUN-650108
        END IF
     END FOREACH
   END FOREACH
   #MOD-B30224 add begin--------------------------------
   IF g_oea.oea00 <> "9" THEN
      SELECT COUNT(*) INTO g_cnt FROM oeb_file 
       WHERE oeb01=g_oea.oea12
         AND (oeb12-oeb24+oeb25)>0 AND oeb70='N'
         AND oeb32 < g_oea.oea02
      IF g_cnt > 0 THEN      #如果合約已過截至日期則報錯提示那些單身已經過期了
         LET l_sql = " SELECT oea01,oeb03 FROM oea_file,oeb_file ",
                     "  WHERE oea01 = oeb01 AND oeb01 = '",g_oea.oea12,"'",
                     "    AND (oeb12-oeb24+oeb25)>0 AND oeb70='N'",
                     "    AND oeb32 < '",g_oea.oea02,"'"  
         PREPARE t400_g_b2_pre1 FROM l_sql
         DECLARE t400_g_b2_1 CURSOR WITH HOLD FOR t400_g_b2_pre1
         
         CALL s_showmsg_init()

         FOREACH t400_g_b2_1 INTO l_oea01,l_oeb03
            LET l_msg = l_oea01,"/",l_oeb03 
            CALL s_errmsg('oea01/oeb03',l_msg,'','axm1017',1) 
         END FOREACH
         CALL s_showmsg() 
      END IF
   END IF
   #MOD-B30224 add -end---------------------------------

END FUNCTION

FUNCTION t400_g_b_detail()

   LET b_oeb.oeb12 = b_oeb.oeb12-b_oeb.oeb24+b_oeb.oeb25

   IF cl_null(b_oeb.oeb916) THEN
      LET b_oeb.oeb916=b_oeb.oeb05
      LET b_oeb.oeb917=b_oeb.oeb12
   END IF

   IF g_oea.oea213 = 'N' THEN

      LET b_oeb.oeb14=b_oeb.oeb917*b_oeb.oeb13
      CALL cl_digcut(b_oeb.oeb14,t_azi04) RETURNING b_oeb.oeb14   #CHI-7A0036-add
      LET b_oeb.oeb14t=b_oeb.oeb14*(1+g_oea.oea211/100)
      CALL cl_digcut(b_oeb.oeb14t,t_azi04) RETURNING b_oeb.oeb14t #CHI-7A0036-add
   ELSE
      LET b_oeb.oeb14t=b_oeb.oeb917*b_oeb.oeb13
      CALL cl_digcut(b_oeb.oeb14t,t_azi04) RETURNING b_oeb.oeb14t #CHI-7A0036-add
      LET b_oeb.oeb14=b_oeb.oeb14t/(1+g_oea.oea211/100)
      CALL cl_digcut(b_oeb.oeb14,t_azi04) RETURNING b_oeb.oeb14   #CHI-7A0036-add
   END IF

   CALL cl_numfor(b_oeb.oeb13,8,t_azi03) RETURNING b_oeb.oeb13      #No.CHI-6A0004
   CALL cl_numfor(b_oeb.oeb14,18,t_azi04) RETURNING b_oeb.oeb14     #No.MOD-570251  CHI-6A0004
   CALL cl_numfor(b_oeb.oeb14t,18,t_azi04) RETURNING b_oeb.oeb14t   #No.MOD-570251  CHI-6A0004

END FUNCTION

FUNCTION t400_two_uygur()
DEFINE l_cmd  STRING

   IF cl_null(g_oea.oea01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_oea.oea917 != 'Y' OR cl_null(g_oea.oea917) THEN
      CALL cl_err('','axm-822',0)
      RETURN
   END IF
   LET l_cmd = " axmt410_1 '",g_oea.oea01,"'"
   CALL cl_cmdrun_wait(l_cmd)
   CALL t400_b_oeb03()    #No.FUN-870117
   CALL t400_b_fill(" 1=1")
   CALL t400_bp_refresh()
   CALL t400_oea_sum()

END FUNCTION

#重新排一下單身的項次
FUNCTION t400_b_oeb03()
 DEFINE  l_sql      STRING
 DEFINE  l_oeb03    LIKE oeb_file.oeb03
 DEFINE  l_cnt      LIKE type_file.num5

   LET g_success = 'Y'

   LET l_sql = "SELECT oeb03 FROM oeb_file WHERE oeb01 = '",g_oea.oea01,"'",
               " ORDER BY oeb03"
   PREPARE t400_oeb03_p FROM l_sql
   DECLARE t400_oeb03_c CURSOR FOR t400_oeb03_p

   BEGIN WORK
   LET l_cnt = 1
   FOREACH t400_oeb03_c INTO l_oeb03
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       UPDATE oeb_file SET oeb03 = l_cnt
        WHERE oeb01 = g_oea.oea01
          AND oeb03 = l_oeb03
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       LET l_cnt = l_cnt+1
   END FOREACH

   IF
 g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION

FUNCTION t400_bp_refresh()
   DISPLAY ARRAY g_oeb TO s_oeb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
   BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  SELECT oea61 INTO g_oea.oea61 FROM oea_file
   WHERE oea01 = g_oea.oea01
  DISPLAY BY NAME g_oea.oea61

END FUNCTION

FUNCTION t400_mixed_wrap()
DEFINE l_n   SMALLINT

   IF cl_null(g_oea.oea01) THEN
     CALL cl_err('',-400,0)
     RETURN
   END IF
   IF g_oea.oea917 MATCHES '[Yy]' THEN
     CALL cl_err('','axm-823',0)
     RETURN
   END IF
   IF g_sma.sma115 MATCHES '[Yy]' THEN
     CALL cl_err('','axm-824',0)
     RETURN
   END IF
   IF g_sma.sma128 NOT MATCHES '[Yy]' THEN
     CALL cl_err('','axm-825',0)
     RETURN
   END IF
   SELECT COUNT(*) INTO l_n FROM oeb_file
    WHERE oeb01 = g_oea.oea01
   IF cl_null(l_n) THEN
      LET l_n = 0
   END IF
   IF l_n > 0 THEN
      CALL cl_err('','axm-826',0)
      RETURN
   END IF
   IF NOT cl_confirm('axm_103') THEN RETURN END IF

   BEGIN WORK
   CALL t400_mixed_wrap_b()
   IF g_success = 'Y' THEN
     COMMIT WORK
   ELSE
     ROLLBACK WORK
   END IF
   CALL t400_b_fill(" 1=1")
   CALL t400_bu()
   CALL t400_bp_refresh()
END FUNCTION

FUNCTION t400_mixed_wrap_b()
DEFINE l_oeb15     LIKE oeb_file.oeb15
DEFINE l_oeb931    LIKE oeb_file.oeb931
DEFINE l_oeb932    LIKE oeb_file.oeb932
DEFINE i           SMALLINT
DEFINE p_close     VARCHAR(1)
DEFINE l_oeb       RECORD LIKE oeb_file.*
DEFINE l_obj02     LIKE obj_file.obj02
DEFINE l_obj06     LIKE obj_file.obj06
DEFINE l_obj07     LIKE obj_file.obj07
DEFINE l_sql       STRING
DEFINE l_ima908    LIKE ima_file.ima908
DEFINE l_unit      LIKE oeb_file.oeb05
DEFINE l_success   LIKE type_file.num5

   IF g_oea.oeaconf = 'Y' THEN
      RETURN
   END IF
   LET g_success = 'Y'

   OPEN WINDOW t600f_w WITH FORM "axm/42f/axmt600f"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()

    INPUT l_oeb15,l_oeb931,l_oeb932 FROM oeb15,oeb931,oeb932
    BEFORE INPUT
         LET l_oeb15 = g_today
         DISPLAY l_oeb15 TO l_oeb15

       AFTER FIELD oeb15
         IF cl_null(l_oeb15) THEN
            CALL cl_err('','aar-011',0)
            NEXT FIELD oeb15
         END IF

       AFTER FIELD oeb931
         IF NOT cl_null(l_oeb931) THEN
            CALL t400_oeb931(l_oeb931)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(l_oeb931,g_errno,1)
               NEXT FIELD oeb931
            END IF
         END IF

       AFTER FIELD oeb932
         IF NOT cl_null(l_oeb932) THEN
            IF l_oeb932 <= 0 THEN
               CALL cl_err(l_oeb932,'axm_104',1)
               NEXT FIELD oeb932
            END IF
         END IF
       ON ACTION controlp
          CASE
            WHEN INFIELD(oeb931)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oeb9312" #by hellen
                 LET g_qryparam.default1 = l_oeb931
                 CALL cl_create_qry() RETURNING l_oeb931
                 DISPLAY BY NAME l_oeb931
                 NEXT FIELD oeb931
            OTHERWISE EXIT CASE
          END CASE

          AFTER INPUT
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                LET g_success = 'N'
                LET p_close = 'Y'
             ELSE
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


      IF p_close = 'Y' THEN CLOSE WINDOW t600f_w LET p_close = 'N' RETURN END IF

      CLOSE WINDOW t600f_w
      #刪除原單身資料
      DELETE FROM oeb_file WHERE oeb01 = g_oea.oea01
      IF SQLCA.sqlcode THEN
        CALL cl_err3("del","oeb_file",g_oea.oea01,'',SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN
      END IF
      INITIALIZE l_oeb.* TO NULL
      LET l_sql = "SELECT obj02,obj06,obj07 FROM obi_file,obj_file ",
                  " WHERE obi01 = obj01 ",
                  "   AND obi01 = '",l_oeb931,"'"
      PREPARE t400_wrap_pre FROM l_sql
      DECLARE t400_wrap_cur CURSOR FOR t400_wrap_pre
      FOREACH t400_wrap_cur INTO l_obj02,l_obj06,l_obj07
        IF STATUS THEN
          LET g_success = 'N'
        END IF
        LET l_oeb.oeb01 = g_oea.oea01
        LET l_oeb.oeb15 = l_oeb15
        LET l_oeb.oeb931 = l_oeb931
        LET l_oeb.oeb932 = l_oeb932
        LET l_oeb.oeb04 = l_obj02

        SELECT ima908 INTO l_ima908 FROM ima_file
         WHERE ima01 = l_oeb.oeb04
        IF g_sma.sma116 MATCHES '[23]' THEN
           LET l_oeb.oeb05=l_ima908
        ELSE
           LET l_oeb.oeb05 = l_obj07
        END IF

        LET l_oeb.oeb12 = l_obj06*l_oeb932
        LET l_oeb.oeb933 = ''
        LET l_oeb.oeb934 = ''
        SELECT ima31_fac,ima02 INTO l_oeb.oeb05_fac,l_oeb.oeb06 FROM ima_file
         WHERE ima01 = l_obj02

        IF cl_null(l_oeb.oeb05_fac) THEN
           LET l_oeb.oeb05_fac = 1
        END IF
        SELECT MAX(oeb03) INTO l_oeb.oeb03 FROM oeb_file
         WHERE oeb01 = g_oea.oea01
        IF cl_null(l_oeb.oeb03) THEN
          LET  l_oeb.oeb03 = 1
        ELSE
          LET l_oeb.oeb03 = l_oeb.oeb03 +1
        END IF
        LET l_oeb.oeb916 =l_oeb.oeb05
        LET l_oeb.oeb917 =l_oeb.oeb12
        LET l_oeb.oeb15 = g_oea.oea59
        LET l_oeb.oeb16 = g_oea.oea59
        IF g_aza.aza50 = 'Y' THEN
          IF NOT cl_null(l_oeb.oeb916) THEN
             LET l_unit=l_oeb.oeb916
          ELSE
             LET l_unit=l_oeb.oeb05
          END IF
        END IF
        IF g_sma.sma116 MATCHES '[23]' AND NOT cl_null(l_oeb.oeb916) THEN
           LET l_unit=l_oeb.oeb916
        ELSE
           LET l_unit=l_oeb.oeb05
        END IF
        CALL s_fetch_price_new(g_oea.oea03,l_oeb.oeb04,l_unit,l_oeb.oeb15,
                              '1',g_oea.oeaplant,g_oea.oea23,g_oea.oea31,g_oea.oea32,
                               g_oea.oea01,l_oeb.oeb03,l_oeb.oeb917,l_oeb.oeb1004,'e')
        #  RETURNING l_oeb.oeb13                       #FUN-AB0061 mark
           RETURNING l_oeb.oeb13,l_oeb.oeb37           #FUN-AB0061
        IF l_oeb.oeb13 = 0 THEN CALL s_unitprice_entry(g_oea.oea03,g_oea.oea31,g_oea.oeaplant) END IF #FUN-9C0120
        LET l_oeb.oeb14 = l_oeb.oeb917 * l_oeb.oeb13
        CALL cl_digcut(l_oeb.oeb14,t_azi04)RETURNING l_oeb.oeb14
        LET l_oeb.oeb14t=l_oeb.oeb14*(1+g_oea.oea211/100)
        CALL cl_digcut(l_oeb.oeb14t,t_azi04)RETURNING l_oeb.oeb14t
        LET l_oeb.oeb15 = g_oea.oea59 LET l_oeb.oeb16 = g_oea.oea59
        LET l_oeb.oeb19 = 'N'                  #genero
        LET l_oeb.oeb23 = 0 LET l_oeb.oeb24 = 0
        LET l_oeb.oeb25 = 0 LET l_oeb.oeb26 = 0
        LET l_oeb.oeb70 = 'N'
        LET l_oeb.oeb71 = g_oea.oea71
        IF cl_null(l_oeb.oeb15) THEN
             LET l_oeb.oeb15=g_today
             LET l_oeb.oeb16=g_today
        END IF
        LET l_oeb.oeb905 = 0 #no.7182
        CALL t400_g_du(l_oeb.oeb04,l_oeb.oeb05,l_oeb.oeb12)
        IF cl_null(l_oeb.oeb091) THEN LET l_oeb.oeb091=' ' END IF
        IF cl_null(l_oeb.oeb092) THEN LET l_oeb.oeb092=' ' END IF
        LET l_oeb.oeb1003 = '1'
        LET l_oeb.oeb930=s_costcenter(g_oea.oea15)
        LET l_oeb.oeb44='1'
        LET l_oeb.oeb920 = 0
        IF g_oea.oea00<>'4' THEN #CHI-970074
           SELECT obk11 INTO l_oeb.oeb906
             FROM obk_file
            WHERE obk01 = l_oeb.oeb04
              AND obk02 = g_oea.oea03
              AND obk05 = g_oea.oea23   #MOD-940385
           IF cl_null(l_oeb.oeb906) THEN
              LET l_oeb.oeb906 = 'N'
           END IF
        ELSE #CHI-970074
           LET l_oeb.oeb906 ='N' #CHI-970074
        END IF #CHI-970074
        IF cl_null(l_oeb.oeb1012) THEN LET l_oeb.oeb1012 = 'N' END IF   #MOD-870034
        IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF   #MOD-A10123
        LET l_oeb.oebplant = g_plant #FUN-980010 add
        LET l_oeb.oeblegal = g_legal #FUN-980010 add
        INSERT INTO oeb_file VALUES(l_oeb.*)
        IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","oeb_file",g_oea.oea01,'',SQLCA.sqlcode,"","",1)
          LET g_success = 'N'
          EXIT FOREACH
        END IF
      END FOREACH
END FUNCTION

FUNCTION t400_oeb931(l_oeb931)
DEFINE l_obiacti   LIKE obi_file.obiacti
DEFINE l_obi02     LIKE obi_file.obi02
DEFINE l_oeb931    LIKE oeb_file.oeb931

     LET g_errno = ''

     SELECT DISTINCT obiacti,obi02 INTO l_obiacti,l_obi02 FROM obj_file,obi_file
      WHERE obj01 = obi01
        AND obi01 = l_oeb931
        AND obi12 IS NOT NULL
        AND obi14 IS NOT NULL
     IF cl_null(l_obiacti) THEN LET l_obiacti = 'N' END IF

     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno ='axm-810'
          WHEN l_obiacti NOT MATCHES '[Yy]'     LET g_errno ='axm_105'
          OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE

     IF NOT cl_null(g_errno) THEN
        LET l_obi02 = NULL
     END IF
     DISPLAY l_obi02 TO obi02
END FUNCTION

FUNCTION t400_sign()
   DEFINE p_cmd        LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_slip       LIKE oay_file.oayslip,  # Prog. Version..: '5.30.06-13.03.12(05)   #No.FUN-550052
          l_cnt        LIKE type_file.num5,    #No.FUN-680137 SMALLINT
          l_azc        RECORD LIKE azc_file.*,
          l_azd        RECORD LIKE azd_file.*,
          l_azd01      LIKE azd_file.azd01,
          l_oayapr     LIKE oay_file.oayapr,
          l_oaysign    LIKE oay_file.oaysign,
          l_oeasign    LIKE oea_file.oeasign

   IF cl_null(g_oea.oea01) THEN RETURN END IF

   LET l_oeasign = ' '

   LET l_slip = s_get_doc_no(g_oea.oea01)

   SELECT oayapr,oaysign INTO g_oea.oeamksg,l_oeasign
     FROM oay_file
    WHERE oayslip = l_slip

   IF cl_null(g_oea.oeamksg) THEN
      LET g_oea.oeamksg='N'
      LET g_oea.oeasign=' '
   END IF

   IF cl_null(g_oea.oeasign) THEN
      LET g_oea.oeasign=l_oeasign
   END IF

   IF cl_null(g_oea.oeasign) THEN
      LET g_oea.oeasign=' '
   END IF

   LET l_azd01 = g_oea.oea01

   DELETE FROM azd_file WHERE azd01 = l_azd01 AND azd02 = 25

   IF g_oea.oeamksg='N' THEN
      UPDATE oea_file SET oeamksg = g_oea.oeamksg,
                          oeasign = g_oea.oeasign
       WHERE oea01 = g_oea.oea01
      COMMIT WORK
      RETURN
   END IF

   LET l_cnt = NULL

   SELECT COUNT(*) INTO l_cnt FROM azc_file
    WHERE azc01 = g_oea.oeasign

   IF l_cnt IS NULL THEN
      LET l_cnt=0
   END IF

   LET g_oea.oeamksg = 'Y'
   LET g_oea.oeasmax = l_cnt

   UPDATE oea_file SET oeasign = g_oea.oeasign,
                       oeamksg = g_oea.oeamksg,
                       oeasmax = g_oea.oeasmax,
                       oeasseq = 0
    WHERE oea01 = g_oea.oea01

END FUNCTION

FUNCTION t400_upoea21()
   DEFINE l_oeb  RECORD LIKE oeb_file.*

   SELECT azi03,azi04 INTO t_azi03,t_azi04        #No.CHI-6A0004
     FROM azi_file
    WHERE azi01 = g_oea.oea23

   DECLARE oeb_upd CURSOR FOR SELECT * FROM oeb_file
                               WHERE oeb01=g_oea.oea01

   FOREACH oeb_upd INTO l_oeb.*
      # 用計價數量來算
     #MOD-A10134---mark---start---
     #IF cl_null(l_oeb.oeb16) THEN
     #   LET l_oeb.oeb916=l_oeb.oeb05
     #   LET l_oeb.oeb917=l_oeb.oeb12
     #END IF
     #MOD-A10134---mark---end---

      IF g_oea.oea213 = 'N' THEN
         LET l_oeb.oeb14=l_oeb.oeb917*l_oeb.oeb13
         CALL cl_digcut(l_oeb.oeb14,t_azi04) RETURNING l_oeb.oeb14   #CHI-7A0036-add
         LET l_oeb.oeb14t=l_oeb.oeb14*(1+g_oea.oea211/100)
         CALL cl_digcut(l_oeb.oeb14t,t_azi04) RETURNING l_oeb.oeb14t #CHI-7A0036-add
      ELSE
         LET l_oeb.oeb14t=l_oeb.oeb917*l_oeb.oeb13
         CALL cl_digcut(l_oeb.oeb14t,t_azi04) RETURNING l_oeb.oeb14t #CHI-7A0036-add
         LET l_oeb.oeb14=l_oeb.oeb14t/(1+g_oea.oea211/100)
         CALL cl_digcut(l_oeb.oeb14,t_azi04) RETURNING l_oeb.oeb14   #CHI-7A0036-add
      END IF

      CALL cl_digcut(l_oeb.oeb13,t_azi03) RETURNING l_oeb.oeb13    #No.CHI-6A0004
      IF cl_null(l_oeb.oeb916) THEN
         LET l_oeb.oeb916=l_oeb.oeb05
         LET l_oeb.oeb917=l_oeb.oeb12
      END IF

      UPDATE oeb_file SET oeb14 = l_oeb.oeb14,
                          oeb14t= l_oeb.oeb14t,
                          oeb13 = l_oeb.oeb13
       WHERE oeb01 =g_oea.oea01
         AND oeb03 = l_oeb.oeb03

      IF SQLCA.SQLCODE THEN
         CALL cl_err3("upd","oeb_file",g_oea.oea01,l_oeb.oeb03,SQLCA.sqlcode,"","upd oeb:",1)  #No.FUN-650108
      END IF
   END FOREACH

END FUNCTION

FUNCTION t400_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("oea00,oea01,oea917",TRUE) #FUN-570020 add oea08 #FUN-820046 add oea917   #MOD-A90080 del oea08
   END IF

   IF INFIELD(oea00) THEN
      CALL cl_set_comp_entry("oea1004,oea1015",TRUE)
   END IF

   IF INFIELD(oea03) OR ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("oea032",TRUE)
   END IF

   #IF INFIELD(oea11) OR ( NOT g_before_input_done ) THEN   #MOD-A50014
   IF INFIELD(oea00) OR INFIELD(oea11) OR ( NOT g_before_input_done ) THEN   #MOD-A50014
      CALL cl_set_comp_entry("oea12",TRUE)
   END IF

   IF INFIELD(oea044) OR ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("oap041,oap042,oap043,oap044,oap045",TRUE)  #FUN-720014 add oap044/045
   END IF

   IF INFIELD(oea12) OR ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("oea23",TRUE)
   END IF

   CALL cl_set_comp_entry("oea65",TRUE)   #CHI-730002
   CALL cl_set_comp_entry("oea11",TRUE)   #MOD-A50014
#  CALL cl_set_comp_entry("oea918,oea919",TRUE)  #FUN-8C0078   #No:FUN-A50103 Mark

END FUNCTION

FUNCTION t400_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
   DEFINE l_n     LIKE type_file.num5    #No.FUN-820046 ADD
   DEFINE l_oas_cnt LIKE type_file.num5  #FUN-8C0078
   DEFINE l_oas_cnt1 LIKE type_file.num5  #FUN-8C0078

   IF g_argv1='0' OR g_argv1='A' THEN   #No.FUN-610053
      CALL cl_set_comp_entry("oea00",FALSE)
   END IF

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("oea01,oea00",FALSE) #FUN-570020 add oea08    #MOD-A90080 del oea08
      SELECT COUNT(*) INTO l_n FROM oeb_file
       WHERE oeb01 = g_oea.oea01
      IF l_n = 0 THEN
        CALL cl_set_comp_entry("oea917",TRUE)
      ELSE
        CALL cl_set_comp_entry("oea917",FALSE)
      END IF
   END IF

   IF INFIELD(oea03) OR ( NOT g_before_input_done ) THEN
      IF g_oea.oea03[1,4] != 'MISC' OR cl_null(g_oea.oea03) THEN
         CALL cl_set_comp_entry("oea032",FALSE)
      END IF
   END IF

   #IF INFIELD(oea11) OR ( NOT g_before_input_done ) THEN   #MOD-A50014
   IF INFIELD(oea00) OR INFIELD(oea11) OR ( NOT g_before_input_done ) THEN   #MOD-A50014
      IF g_oea.oea11='1' THEN
         CALL cl_set_comp_entry("oea12",FALSE)
      END IF
   END IF

   #-----MOD-A50014---------
   IF INFIELD(oea00) THEN
      IF g_oea.oea00 = '8' OR g_oea.oea00 = '9' THEN
         CALL cl_set_comp_entry("oea11",FALSE)
      END IF
   END IF
   #-----END MOD-A50014-----

#TQC-A30149 --begin--
  IF NOT g_before_input_done THEN
     CALL cl_set_comp_entry("oea163,oea263",FALSE)    #No:FUN-A50103
  END IF 
#TQC-A30149 --end--

   IF INFIELD(oea044) OR ( NOT g_before_input_done ) THEN
      IF g_oea.oea044[1,4] !='MISC' OR cl_null(g_oea.oea044) THEN
         CALL cl_set_comp_entry("oap041,oap042,oap043,oap044,oap045",FALSE)  #No.MOD-590540   #FUN-720014 add oap044/045
      END IF
   END IF

   IF INFIELD(oea00) OR ( NOT g_before_input_done ) THEN
      IF (g_oea.oea00 != '7' AND g_aza.aza50 = 'Y') OR   #No.FUN-650108
         (g_oea.oea00 != '1' AND g_oea.oea00 != '7' AND g_aza.aza50 = 'N'
          AND g_oea.oea00 != '6' AND g_oea.oea00 != '3') THEN  #No.FUN-650108   #MOD-780165 modify '6'   #MOD-A30239 add '3'
         CALL cl_set_comp_entry("oea1015",FALSE)
      END IF
      IF g_oea.oea00 != '6' THEN
         LET g_oea.oea1004 =NULL
         CALL cl_set_comp_entry("oea1004",FALSE)
      END IF
   END IF

   IF INFIELD(oea12) OR ( NOT g_before_input_done ) THEN
      IF NOT cl_null(g_oea.oea12) THEN
       #  CALL cl_set_comp_entry("oea23",FALSE)  #TQC-AB0286 mark
      END IF
   END IF
  #IF g_oea.oea00='3' THEN #MOD-B20074 mark
   IF g_oea.oea00='3' OR g_oea.oea00='8' OR g_oea.oea00='9' THEN #MOD-B20074
      CALL cl_set_comp_entry("oea65",FALSE)
      LET g_oea.oea65='N'
      DISPLAY BY NAME g_oea.oea65
   END IF
   IF p_cmd = 'a' OR p_cmd = 'u' THEN
      IF g_oea.oea00 = '6' OR g_oea.oea00 = '7'  THEN                                       #CHI-8B0015
         CALL cl_set_comp_entry("oea65",FALSE)
         LET g_oea.oea65 ='N'
         DISPLAY BY NAME g_oea.oea65
      END IF
   END IF

  ##-----No:FUN-A50103 Mark-----
  ##找axmi051裡如果沒有分期資料,oea918不可輸入--
  #IF cl_null(g_oea.oea80) THEN
  #    SELECT COUNT(*) INTO l_oas_cnt
  #      FROM oas_file
  #     WHERE oas01 = g_oea.oea32
  #ELSE
  #    SELECT COUNT(*) INTO l_oas_cnt
  #      FROM oas_file
  #     WHERE oas01 = g_oea.oea80
  #END IF
  #IF l_oas_cnt = 0 THEN
  #    CALL cl_set_comp_entry("oea918",FALSE)
  #    LET g_oea.oea918 = 'N'
  #    DISPLAY BY NAME g_oea.oea918
  #END IF

  ##找axmi051裡如果沒有分期資料,oea919不可輸入--
  #IF cl_null(g_oea.oea81) THEN
  #    SELECT COUNT(*) INTO l_oas_cnt1
  #      FROM oas_file
  #     WHERE oas01 = g_oea.oea32
  #ELSE
  #    SELECT COUNT(*) INTO l_oas_cnt1
  #      FROM oas_file
  #     WHERE oas01 = g_oea.oea81
  #END IF
  #IF l_oas_cnt1 = 0 THEN
  #    CALL cl_set_comp_entry("oea919",FALSE)
  #    LET g_oea.oea919 = 'N'
  #    DISPLAY BY NAME g_oea.oea919
  #END IF
  ##-----No:FUN-A50103 Mark-----

END FUNCTION

FUNCTION t400_show_oao()
   DEFINE i,j       LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_oao06   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(60)

   DECLARE t400_show_c CURSOR FOR
           SELECT oao03,oao04,oao06 FROM oao_file
                                   WHERE oao01=g_oea.oea01
                                   ORDER BY oao03,oao04

   LET g_msg=''
   FOREACH t400_show_c INTO i,j,l_oao06
      IF STATUS THEN
         EXIT FOREACH
      END IF
      LET g_msg = g_msg CLIPPED,' ',l_oao06
   END FOREACH


   CALL cl_msg(g_msg CLIPPED)                #No.FUN-640248

END FUNCTION

FUNCTION t400_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)

    IF (p_cmd = 'a' AND ( NOT g_before_input_done )) OR  #No.FUN-650108
       (p_cmd = 'a' AND g_aza.aza50 = 'Y') THEN          #No.FUN-650108
        CALL cl_set_comp_entry("oeb71,oeb092,oeb22,oeb19,oeb908,oeb05",TRUE)   #No.MOD-570251
    END IF

    IF INFIELD(oeb04) THEN
       CALL cl_set_comp_entry("oeb06",TRUE)
    END IF
    IF INFIELD(oeb15) THEN
       CALL cl_set_comp_entry("oeb22,oeb19",TRUE)
    END IF

    CALL cl_set_comp_entry("oeb913,oeb915,oeb916,oeb917",TRUE)

    CALL cl_set_comp_entry("oeb906",TRUE)  #No.FUN-640074

    CALL cl_set_comp_entry("oeb05,oeb910,oeb913",TRUE)

    IF g_oea.oea00 <> "9" THEN
       CALL cl_set_comp_entry("oeb15,oeb30",TRUE)
    END IF
END FUNCTION

FUNCTION t400_set_no_entry_b(p_cmd,p_chk)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
  DEFINE p_chk   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(01)
  DEFINE l_occ1027  LIKE occ_file.occ1027  #FUN-610055

    IF (p_cmd = 'a' AND ( NOT g_before_input_done )) OR  #No.FUN-650108
       (p_cmd = 'a' AND g_aza.aza50 = 'Y') THEN          #No.FUN-650108
       IF g_oea.oea11 MATCHES '[24]' THEN      #NO.FUN-670007
          CALL cl_set_comp_entry("oeb71",FALSE)
       END IF
       IF g_oaz.oaz104='N' THEN
          CALL cl_set_comp_entry("oeb092",FALSE)
       END IF
       IF g_argv1 = '0' OR g_argv1 ='A' THEN  #No.FUN-610053
          CALL cl_set_comp_entry("oeb22,oeb19",FALSE)
       END IF
       IF g_aza.aza27 != 'Y' THEN
          CALL cl_set_comp_entry("oeb908",FALSE)
       END IF
    END IF

    IF g_oea.oea00 = "9" THEN
       CALL cl_set_comp_entry("oeb15,oeb30",FALSE)
    END IF
    IF g_aza.aza50 = 'Y' AND (p_cmd = 'u' OR p_cmd = 'a') THEN
       CALL cl_set_comp_entry("oeb14,oeb14t",FALSE)
    END IF

    IF INFIELD(oeb04) THEN
       IF g_oeb[l_ac].oeb04[1,4] !='MISC' THEN
          CALL cl_set_comp_entry("oeb06",FALSE)
       END IF
    END IF

    IF INFIELD(oeb03) THEN
       IF p_cmd = 'u' AND p_chk = 'Y'  THEN
          CALL cl_set_comp_entry("oeb13",FALSE)
       END IF
    END IF

    IF g_ima906 = '1' THEN
       CALL cl_set_comp_entry("oeb913,oeb914,oeb915",FALSE)
    END IF
    IF g_ima906 = '2' THEN
       CALL cl_set_comp_entry("oeb911,oeb914",FALSE)
    END IF
    #參考單位，每個料件只有一個，所以不開放讓用戶輸入
    IF g_ima906 = '3' THEN
       CALL cl_set_comp_entry("oeb913",FALSE)
    END IF
    IF g_sma.sma116 MATCHES '[01]' THEN  #FUN-610076
       CALL cl_set_comp_entry("oeb916,oeb917",FALSE)
    END IF

    IF g_oeb[l_ac].oeb906 <> 'Y' OR cl_null(g_oeb[l_ac].oeb906) THEN   #CHI-880006
       CALL cl_set_comp_entry("oeb906",FALSE)
    END IF

    IF g_aza.aza50 = 'Y' THEN  #No.FUN-650108
       IF l_ac !=0 THEN
           IF NOT cl_null(g_oeb[l_ac].oeb1012) THEN
              IF g_oeb[l_ac].oeb1012 = 'Y' THEN
                 CALL cl_set_comp_entry("oeb14",FALSE)
                 CALL cl_set_comp_entry("oeb14t",FALSE)
                 CALL cl_set_comp_entry("oeb1004",FALSE)
              END IF
           END IF
       END IF
       SELECT occ1027 INTO l_occ1027 FROM occ_file
        WHERE occ01=g_oea.oea03      #FUN-610055
       IF l_occ1027 = 'N' AND g_oea.oea03[1,4]!='MISC' THEN  #FUN-610055
          CALL cl_set_comp_entry("oeb13",FALSE)
       END IF
    END IF  #No.FUN-650108
    IF NOT cl_null(g_oea.oea12) AND NOT cl_null(g_oeb[l_ac].oeb71) THEN
       CALL cl_set_comp_entry("oeb05,oeb910,oeb913",FALSE)
    END IF
    CALL cl_set_comp_entry("oeb14,oeb14t",g_azw.azw04<>'2') #No.FUN-870007
END FUNCTION

FUNCTION t400_set_required_b()  #FUN-610055

  #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
  IF g_sma.sma115 = 'Y' THEN   #No.TQC-5C0103
     IF g_ima906 = '3' THEN
        CALL cl_set_comp_required("oeb913,oeb915,oeb910,oeb912",TRUE)
     END IF
     #單位不同,轉換率,數量必KEY
     IF NOT cl_null(g_oeb[l_ac].oeb910) THEN
        CALL cl_set_comp_required("oeb912",TRUE)
     END IF
     IF NOT cl_null(g_oeb[l_ac].oeb913) THEN
        CALL cl_set_comp_required("oeb915",TRUE)
     END IF
     IF g_sma.sma116 MATCHES '[23]' THEN   #MOD-A40121
       IF NOT cl_null(g_oeb[l_ac].oeb916) THEN
          CALL cl_set_comp_required("oeb917",TRUE)
       END IF
     END IF   #MOD-A40121
   END IF

   #-----MOD-A50014---------
   IF g_oea.oea00='9' AND g_oea.oea11='8' AND NOT cl_null(g_oea.oea12) THEN
      CALL cl_set_comp_required("oeb71",TRUE)
   END IF 
   #-----END MOD-A50014-----
#No.FUN-A80024 --begin
    IF g_argv1 ='0' THEN 
       CALL cl_set_comp_required("oeb32",TRUE)
    END IF 
#No.FUN-A80024 --end
    
    #FUN-A80102(S)
    IF g_sma.sma1422 ='Y' THEN 
       CALL cl_set_comp_required("oeb919",TRUE)
    END IF 
    #FUN-A80102(E)
   
END FUNCTION

FUNCTION t400_set_no_required_b()  #FUN-610055

   CALL cl_set_comp_required("oeb913,oeb914,oeb915,oeb910,oeb911,oeb912,oeb916,oeb917",FALSE)
   CALL cl_set_comp_required("oeb71",FALSE)   #MOD-A50014
#FUN-A60035 ---MARK BEGIN
#  #No.FUN-A50054 --begin-- by dxfwo
#  IF g_oea.oeaslk02 <> "Y" THEN
#     CALL cl_set_comp_required("oeb12",FALSE)
#  END IF
#  #No.FUN-A50054 --end--    
#FUN-A60035 ---MARK END

END FUNCTION

FUNCTION t400_set_no_required()

  CALL cl_set_comp_required("oea1004",FALSE)
  CALL cl_set_comp_required("oea1015",FALSE)
  CALL cl_set_comp_required("oea12",FALSE)   #MOD-940234
  CALL cl_set_comp_required("oea80,oea81",FALSE)    #No:FUN-A50103

END FUNCTION

FUNCTION t400_b_move_to()
   LET g_oeb[l_ac].oeb03 = b_oeb.oeb03
   LET g_oeb[l_ac].oeb1001 = b_oeb.oeb1001
   LET g_oeb[l_ac].oeb1012 = b_oeb.oeb1012
   LET g_oeb[l_ac].oeb1004 = b_oeb.oeb1004
   LET g_oeb[l_ac].oeb1002 = b_oeb.oeb1002
   LET g_oeb[l_ac].oeb1006 = b_oeb.oeb1006
   LET g_oeb[l_ac].oeb11 =  b_oeb.oeb11
   LET g_oeb[l_ac].oeb09 =  b_oeb.oeb09
   LET g_oeb[l_ac].oeb091 = b_oeb.oeb091
   LET g_oeb[l_ac].oeb71 = b_oeb.oeb71
   LET g_oeb[l_ac].oeb935 = b_oeb.oeb935
   LET g_oeb[l_ac].oeb936 = b_oeb.oeb936
   LET g_oeb[l_ac].oeb937 = b_oeb.oeb937
   LET g_oeb[l_ac].oeb04 = b_oeb.oeb04
   LET g_oeb[l_ac].oeb06 = b_oeb.oeb06
   LET g_oeb[l_ac].oeb092= b_oeb.oeb092
   LET g_oeb[l_ac].oeb05 = b_oeb.oeb05
   LET g_oeb[l_ac].oeb32 = b_oeb.oeb32      #No.FUN-A80024
   LET g_oeb[l_ac].oeb12 = b_oeb.oeb12
   LET g_oeb[l_ac].oeb13 = b_oeb.oeb13
   LET g_oeb[l_ac].oeb37 = b_oeb.oeb37      #FUN-AB0061  
   LET g_oeb[l_ac].oeb14 = b_oeb.oeb14
   LET g_oeb[l_ac].oeb14t= b_oeb.oeb14t
   LET g_oeb[l_ac].oeb918= b_oeb.oeb918  #FUN-A80054
   LET g_oeb[l_ac].oeb919= b_oeb.oeb919  #FUN-A80102
   LET g_oeb[l_ac].oeb41= b_oeb.oeb41
   LET g_oeb[l_ac].oeb42= b_oeb.oeb42
   LET g_oeb[l_ac].oeb43= b_oeb.oeb43
   LET g_oeb[l_ac].oeb15 = b_oeb.oeb15
   LET g_oeb[l_ac].oeb30 = b_oeb.oeb30   #No.FUN-740016
   LET g_oeb[l_ac].oeb31 = b_oeb.oeb31   #No.FUN-740016
   LET g_oeb[l_ac].oeb22 = b_oeb.oeb22
   LET g_oeb[l_ac].oeb19 = b_oeb.oeb19
   LET g_oeb[l_ac].oeb70 = b_oeb.oeb70
   LET g_oeb[l_ac].oeb24 = b_oeb.oeb24
   LET g_oeb[l_ac].oeb27 = b_oeb.oeb27   #NO.FUN-670007
   LET g_oeb[l_ac].oeb28 = b_oeb.oeb28   #NO.FUN-670007
   LET g_oeb[l_ac].oeb908 = b_oeb.oeb908
   LET g_oeb[l_ac].oeb910= b_oeb.oeb910
   LET g_oeb[l_ac].oeb911= b_oeb.oeb911
   LET g_oeb[l_ac].oeb912= b_oeb.oeb912
   LET g_oeb[l_ac].oeb913= b_oeb.oeb913
   LET g_oeb[l_ac].oeb914= b_oeb.oeb914
   LET g_oeb[l_ac].oeb915= b_oeb.oeb915
   LET g_oeb[l_ac].oeb916= b_oeb.oeb916
   LET g_oeb[l_ac].oeb917= b_oeb.oeb917
   LET g_oeb[l_ac].oeb906= b_oeb.oeb906    #No.FUN-5C0076
   LET g_oeb[l_ac].oeb930= b_oeb.oeb930 #FUN-670063
   LET g_oeb[l_ac].gem02c=s_costcenter_desc(g_oeb[l_ac].oeb930) #FUN-670063
   IF g_azw.azw04="2" THEN
      LET g_oeb[l_ac].oeb49 = b_oeb.oeb49     #No.FUN-A90040
      LET g_oeb[l_ac].oeb50 = b_oeb.oeb50     #No.FUN-A90040
      LET g_oeb[l_ac].oeb44=b_oeb.oeb44
      LET g_oeb[l_ac].oeb45=b_oeb.oeb45
      LET g_oeb[l_ac].oeb46=b_oeb.oeb46
      LET g_oeb[l_ac].oeb47=b_oeb.oeb47
      LET g_oeb[l_ac].oeb48=b_oeb.oeb48
   END IF
END FUNCTION

FUNCTION t400_b_move_back()
   LET b_oeb.oeb03 = g_oeb[l_ac].oeb03
   LET b_oeb.oeb1001 = g_oeb[l_ac].oeb1001
   LET b_oeb.oeb1012 = g_oeb[l_ac].oeb1012
   LET b_oeb.oeb1004 = g_oeb[l_ac].oeb1004
   LET b_oeb.oeb1002 = g_oeb[l_ac].oeb1002
   LET b_oeb.oeb1006 = g_oeb[l_ac].oeb1006
   LET b_oeb.oeb11 = g_oeb[l_ac].oeb11     #MOD-780272 mark    #MOD-890137取消mark
  #IF cl_null(b_oeb.oeb09) THEN            #TQC-AC0139 mark
   LET b_oeb.oeb09 = g_oeb[l_ac].oeb09
   LET b_oeb.oeb091 = g_oeb[l_ac].oeb091
  #END IF                                  #TQC-AC0139 mark
   LET b_oeb.oeb71 = g_oeb[l_ac].oeb71
   LET b_oeb.oeb935 = g_oeb[l_ac].oeb935
   LET b_oeb.oeb936 = g_oeb[l_ac].oeb936
   LET b_oeb.oeb937 = g_oeb[l_ac].oeb937
   LET b_oeb.oeb04 = g_oeb[l_ac].oeb04
   LET b_oeb.oeb06 = g_oeb[l_ac].oeb06
   IF g_oea.oea00 = '9' THEN
      LET b_oeb.oeb09 = g_oaz.oaz78
      LET b_oeb.oeb091 = ' '
      LET b_oeb.oeb092 = g_oea.oea03
   ELSE
      LET b_oeb.oeb092= g_oeb[l_ac].oeb092
   END IF
   LET b_oeb.oeb05 = g_oeb[l_ac].oeb05
   LET b_oeb.oeb32 = g_oeb[l_ac].oeb32       #No.FUN-A80024
   LET b_oeb.oeb12 = g_oeb[l_ac].oeb12
   LET b_oeb.oeb13 = g_oeb[l_ac].oeb13
   LET b_oeb.oeb37 = g_oeb[l_ac].oeb37       #FUN-AB0061
   LET b_oeb.oeb14 = g_oeb[l_ac].oeb14
   LET b_oeb.oeb14t= g_oeb[l_ac].oeb14t
   LET b_oeb.oeb918 = g_oeb[l_ac].oeb918   #FUN-A80054
   LET b_oeb.oeb919 = g_oeb[l_ac].oeb919   #FUN-A80102
   LET b_oeb.oeb41= g_oeb[l_ac].oeb41
   LET b_oeb.oeb42= g_oeb[l_ac].oeb42
   LET b_oeb.oeb43= g_oeb[l_ac].oeb43
   LET b_oeb.oeb15 = g_oeb[l_ac].oeb15
   LET b_oeb.oeb30 = g_oeb[l_ac].oeb30   #No.FUN-740016
   LET b_oeb.oeb31 = g_oeb[l_ac].oeb31   #No.FUN-740016
   LET b_oeb.oeb22 = g_oeb[l_ac].oeb22
   LET b_oeb.oeb19 = g_oeb[l_ac].oeb19
   LET b_oeb.oeb70 = g_oeb[l_ac].oeb70
   LET b_oeb.oeb24 = g_oeb[l_ac].oeb24
   LET b_oeb.oeb27 = g_oeb[l_ac].oeb27   #NO.FUN-670007
   LET b_oeb.oeb28 = g_oeb[l_ac].oeb28   #NO.FUN-670007
   LET b_oeb.oeb908 = g_oeb[l_ac].oeb908
   LET b_oeb.oeb910= g_oeb[l_ac].oeb910
   LET b_oeb.oeb911= g_oeb[l_ac].oeb911
   LET b_oeb.oeb912= g_oeb[l_ac].oeb912
   LET b_oeb.oeb913= g_oeb[l_ac].oeb913
   LET b_oeb.oeb914= g_oeb[l_ac].oeb914
   LET b_oeb.oeb915= g_oeb[l_ac].oeb915
   LET b_oeb.oeb916= g_oeb[l_ac].oeb916
   LET b_oeb.oeb917= g_oeb[l_ac].oeb917
   LET b_oeb.oeb906= g_oeb[l_ac].oeb906
   LET b_oeb.oeb930= g_oeb[l_ac].oeb930 #FUN-670063
   LET b_oeb.oebud01= g_oeb[l_ac].oebud01
   LET b_oeb.oebud02= g_oeb[l_ac].oebud02
   LET b_oeb.oebud03= g_oeb[l_ac].oebud03
   LET b_oeb.oebud04= g_oeb[l_ac].oebud04
   LET b_oeb.oebud05= g_oeb[l_ac].oebud05
   LET b_oeb.oebud06= g_oeb[l_ac].oebud06
   LET b_oeb.oebud07= g_oeb[l_ac].oebud07
   LET b_oeb.oebud08= g_oeb[l_ac].oebud08
   LET b_oeb.oebud09= g_oeb[l_ac].oebud09
   LET b_oeb.oebud10= g_oeb[l_ac].oebud10
   LET b_oeb.oebud11= g_oeb[l_ac].oebud11
   LET b_oeb.oebud12= g_oeb[l_ac].oebud12
   LET b_oeb.oebud13= g_oeb[l_ac].oebud13
   LET b_oeb.oebud14= g_oeb[l_ac].oebud14
   LET b_oeb.oebud15= g_oeb[l_ac].oebud15
   IF g_azw.azw04="2" THEN
      LET  b_oeb.oeb49 =g_oeb[l_ac].oeb49    #No.FUN-A90040
      LET  b_oeb.oeb50 =g_oeb[l_ac].oeb50     #No.FUN-A90040
      LET b_oeb.oeb44=g_oeb[l_ac].oeb44
      LET b_oeb.oeb45=g_oeb[l_ac].oeb45
      LET b_oeb.oeb46=g_oeb[l_ac].oeb46
      LET b_oeb.oeb47=g_oeb[l_ac].oeb47
      LET b_oeb.oeb48=g_oeb[l_ac].oeb48
   ELSE
      LET b_oeb.oeb44='1'
      LET b_oeb.oeb47=0
      LET b_oeb.oeb48='2'    #FUN-9B0025 ADD
   END IF
END FUNCTION

FUNCTION t400_mlog(p_cmd)   # Transaction Modify Log (存入 oem_file)
   DEFINE p_cmd		LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
   DEFINE l_oem05       LIKE type_file.chr8    #No.FUN-680137 VARCHAR(8)
   DEFINE l_oem		RECORD LIKE oem_file.*
   IF g_oea.oea06 IS NULL THEN RETURN END IF
   INITIALIZE l_oem.* TO NULL
   LET l_oem.oem01=g_oea.oea01
   LET l_oem.oem03=b_oeb.oeb03
   LET l_oem.oem04=g_today
   LET l_oem05 = TIME
   LET l_oem.oem05=l_oem05
   LET l_oem.oem06=g_user
   LET l_oem.oem07=p_cmd
   LET l_oem.oem08=g_oea.oea06
   LET l_oem.oemplant = g_plant #FUN-980010 add
   LET l_oem.oemlegal = g_legal #FUN-980010 add
   IF p_cmd='A' THEN
      LET l_oem.oem10o=NULL LET l_oem.oem11o=NULL
      LET l_oem.oem12o=NULL LET l_oem.oem13o=NULL LET l_oem.oem15o=NULL
      LET l_oem.oem10n=b_oeb.oeb04
      LET l_oem.oem11n=b_oeb.oeb092
      LET l_oem.oem12n=b_oeb.oeb12
      LET l_oem.oem13n=b_oeb.oeb13
      LET l_oem.oem15n=b_oeb.oeb15
   END IF
   IF p_cmd='R' THEN
      LET l_oem.oem10o=g_oeb_t.oeb04
      LET l_oem.oem11o=g_oeb_t.oeb092
      LET l_oem.oem12o=g_oeb_t.oeb12
      LET l_oem.oem13o=g_oeb_t.oeb13
      LET l_oem.oem15o=g_oeb_t.oeb15
      LET l_oem.oem10n=NULL LET l_oem.oem11n=NULL
      LET l_oem.oem12n=NULL LET l_oem.oem13n=NULL LET l_oem.oem15n=NULL
   END IF
   IF p_cmd='U' THEN
      IF g_oeb_t.oeb04 != b_oeb.oeb04 THEN
         LET l_oem.oem10o=g_oeb_t.oeb04 LET l_oem.oem10n=b_oeb.oeb04
      END IF
      IF g_oeb_t.oeb092 != b_oeb.oeb092 OR
         (cl_null(g_oeb_t.oeb092) AND NOT cl_null(b_oeb.oeb092))
         THEN
         LET l_oem.oem11o=g_oeb_t.oeb092 LET l_oem.oem11n=b_oeb.oeb092
      END IF
      IF g_oeb_t.oeb12 != b_oeb.oeb12 THEN
         LET l_oem.oem12o=g_oeb_t.oeb12 LET l_oem.oem12n=b_oeb.oeb12
      END IF
      IF g_oeb_t.oeb13 != b_oeb.oeb13 THEN
         LET l_oem.oem13o=g_oeb_t.oeb13 LET l_oem.oem13n=b_oeb.oeb13
      END IF
      IF g_oeb_t.oeb15 != b_oeb.oeb15 THEN
         LET l_oem.oem15o=g_oeb_t.oeb15 LET l_oem.oem15n=b_oeb.oeb15
      END IF
      IF cl_null(l_oem.oem10n) AND cl_null(l_oem.oem11n) AND
         cl_null(l_oem.oem12n) AND cl_null(l_oem.oem13n) AND
         cl_null(l_oem.oem15n) THEN RETURN
      END IF
      IF l_oem.oem12n=0 THEN LET l_oem.oem12n=NULL END IF
      IF l_oem.oem13n=0 THEN LET l_oem.oem13n=NULL END IF
   END IF
   INSERT INTO oem_file VALUES (l_oem.*)
END FUNCTION

FUNCTION t400_b_get_price()
   DEFINE l_oah03	LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)		#單價取價方式
   DEFINE l_ima131	LIKE type_file.chr20   #No.FUN-680137 VARCHAR(20)	#Product Type
   DEFINE l_occ20	LIKE occ_file.occ20	#MOD-710180 add
   DEFINE l_occ21	LIKE occ_file.occ21	#MOD-710180 add
   DEFINE l_occ22	LIKE occ_file.occ22	#MOD-710180 add
   DEFINE l_oeb05       LIKE oeb_file.oeb05     #NO.FUN-960130

   SELECT oah03 INTO l_oah03 FROM oah_file WHERE oah01 = g_oea.oea31
   CASE WHEN l_oah03 = '0' LET g_oeb17 = 0 LET b_oeb.oeb17 = 0 RETURN   #MOD-940271
        WHEN l_oah03 = '1'
             IF g_oea.oea213='Y'
                THEN SELECT ima128 INTO g_oeb[l_ac].oeb13 FROM ima_file
                            WHERE ima01 = g_oeb[l_ac].oeb04
                ELSE SELECT ima127 INTO g_oeb[l_ac].oeb13 FROM ima_file
                            WHERE ima01 = g_oeb[l_ac].oeb04
             END IF
              #->將單價除上匯率
              LET g_oeb[l_ac].oeb13=g_oeb[l_ac].oeb13/g_oea.oea24
        WHEN l_oah03 = '2'
             IF cl_null(g_oeb[l_ac].oeb916) THEN
                LET g_oeb[l_ac].oeb916=g_oeb[l_ac].oeb05
             END IF
             SELECT ima131 INTO l_ima131 FROM ima_file
                    WHERE ima01 = g_oeb[l_ac].oeb04
                 SELECT occ20,occ21,occ22 INTO l_occ20,l_occ21,l_occ22 FROM occ_file
                  WHERE occ01=g_oea.oea03
                    AND occacti='Y'
             DECLARE t400_b_get_price_c CURSOR FOR
                 SELECT obg21,
                        obg01,obg02,obg03,obg04,obg05,
                        obg06,obg22,obg07,obg08,obg09,obg10           #MOD-710180 add
                   FROM obg_file
                    WHERE (obg01 = l_ima131          OR obg01 = '*')
                      AND (obg02 = g_oeb[l_ac].oeb04 OR obg02 = '*')
                      AND (obg03 = g_oeb[l_ac].oeb916)
                      AND (obg04 = g_oea.oea25       OR obg04 = '*')
                      AND (obg05 = g_oea.oea31       OR obg05 = '*')
                      AND (obg06 = g_oea.oea03       OR obg06 = '*')  #FUN-610055
                      AND (obg22 = l_occ22           OR obg22 = '*')  #MOD-710180 add
                      AND (obg07 = l_occ21           OR obg07 = '*')  #MOD-710180 add
                      AND (obg08 = l_occ20           OR obg08 = '*')  #MOD-710180 add
                      AND (obg09 = g_oea.oea23      )
                      AND (obg10 = g_oea.oea21       OR obg10 = '*')
                 ORDER BY obg01 DESC,obg02 DESC,obg03 DESC,obg04 DESC, #FUN-610055
                          obg05 DESC,obg06 DESC,obg07 DESC,obg08 DESC, #FUN-610055
                          obg09 DESC,obg10 DESC #FUN-610055  #MOD-710180
             FOREACH t400_b_get_price_c INTO g_oeb[l_ac].oeb13
               IF STATUS THEN CALL cl_err('foreach obg',STATUS,1) END IF
               EXIT FOREACH
             END FOREACH
        WHEN l_oah03 = '3'
           SELECT obk08 INTO g_oeb[l_ac].oeb13 FROM obk_file
                  WHERE obk01 = g_oeb[l_ac].oeb04 AND obk02 = g_oea.oea03     #FUN-610055
                    AND obk05 = g_oea.oea23
        WHEN l_oah03 = '4'
           IF g_sma.sma116 MATCHES '[23]' AND NOT cl_null(g_oeb[l_ac].oeb916) THEN
              LET l_oeb05=g_oeb[l_ac].oeb916
           ELSE
              LET l_oeb05=g_oeb[l_ac].oeb05
           END IF
   END CASE
   LET g_oeb17 = g_oeb[l_ac].oeb13    #no.7150 預設取出單價
   DISPLAY BY NAME g_oeb[l_ac].oeb13 #MOD-570248 add 重新DISPLAY 確保正確執行ON ROW CHANGE
   LET g_oeb37 = g_oeb[l_ac].oeb13          #FUN-AB0061 
   DISPLAY BY NAME g_oeb[l_ac].oeb37        #FUN-AB0061

   LET b_oeb.oeb17 =g_oeb[l_ac].oeb13
   IF cl_null(b_oeb.oeb17) THEN
      LET b_oeb.oeb17 =0
   END IF

   LET b_oeb.oeb904 =g_oeb[l_ac].oeb13
   IF cl_null(b_oeb.oeb904) THEN
      LET b_oeb.oeb904 =0
   END IF
END FUNCTION

#取消標記
FUNCTION t400_bu()

   LET g_oea.oea61 = NULL
   LET g_oea.oea1008 = NULL    #FUN-A50103

   SELECT SUM(oeb14),SUM(oeb14t) INTO g_oea.oea61,g_oea.oea1008    #FUN-A50103
     FROM oeb_file WHERE oeb01 = g_oea.oea01

   IF cl_null(g_oea.oea61) THEN LET g_oea.oea61 = 0 END IF
   IF cl_null(g_oea.oea1008) THEN LET g_oea.oea1008 = 0 END IF    #FUN-A50103

   CALL cl_digcut(g_oea.oea61,t_azi04) RETURNING g_oea.oea61              #No.CHI-6A0004
   CALL cl_digcut(g_oea.oea1008,t_azi04) RETURNING g_oea.oea1008    #FUN-A50103

   #MOD-B30297------add-----str----------------------------
      IF g_oea.oea213 = 'Y' THEN
         LET g_oea.oea261 = g_oea.oea1008 * g_oea.oea161/100
      ELSE
         LET g_oea.oea261 = g_oea.oea61 * g_oea.oea161/100
      END IF
   
      IF g_oea.oea213 = 'Y' THEN
         LET g_oea.oea262 = g_oea.oea1008 * g_oea.oea162/100
      ELSE
         LET g_oea.oea262 = g_oea.oea61 * g_oea.oea162/100
      END IF


   IF g_oea.oea213 = 'Y' THEN
      LET g_oea.oea263 = g_oea.oea1008 - g_oea.oea261 - g_oea.oea262
   ELSE
      LET g_oea.oea263 = g_oea.oea61 - g_oea.oea261 - g_oea.oea262
   END IF
   #MOD-B30297------add--------end----------------------------

   UPDATE oea_file SET oea61 = g_oea.oea61,
                       oea1008=g_oea.oea1008,    #FUN-A50103
                       oea261 = g_oea.oea261,   #MOD-B30297    
                       oea262 = g_oea.oea262,   #MOD-B30297 
                       oea263 = g_oea.oea263    #MOD-B30297 
                 WHERE oea01 = g_oea_t.oea01
      

   DISPLAY BY NAME g_oea.oea61

END FUNCTION

FUNCTION t400_out()
   DEFINE l_wc string

    IF g_oea.oea01 IS NULL THEN RETURN END IF

    CLOSE WINDOW screen

    CALL cl_set_act_visible("accept,cancel", TRUE)
    MENU "" #ATTRIBUTE(STYLE="popup")
       ON ACTION list
          CALL t400_out1()

       ON ACTION print_this_order

           LET l_wc=' oea01="',g_oea.oea01 CLIPPED,'"'
              LET l_wc='oea01="',g_oea.oea01,'"'
         IF g_oea.oea00 MATCHES '[89]'  THEN
             # LET g_msg = "axmr421", #FUN-C30085 mark
              LET g_msg = "axmg421", #FUN-C30085 add
                  " '",g_today CLIPPED,"' ''",
                  " '",g_lang CLIPPED,"' 'Y' '' '1'",  #FUN-7B0142 mod #MOD-7B0216 modify g_lang
                  " '",l_wc CLIPPED,"' "
         ELSE
             # LET g_msg = "axmr400", #FUN-C30085 mark
              LET g_msg = "axmg400", #FUN-C30085 add
                  " '",g_today CLIPPED,"' ''",
                  " '",g_lang CLIPPED,"' 'Y' '' '1'",  #FUN-7B0142 mod #MOD-7B0216 modify g_lang
                  " '",l_wc CLIPPED,"' ",
                  " 'Y' 'Y' "
         END IF
          CALL cl_cmdrun(g_msg)

       ON ACTION print_this_sc
               LET l_wc='oea01="',g_oea.oea01,'"'
              # LET g_msg = "axmr401",#FUN-C30085 mark
              LET g_msg = "axmg401", #FUN-C30085 add
                   " '",g_today CLIPPED,"' ''",
                   " '",g_lang CLIPPED,"' 'Y' '' '1'",
                   " '",l_wc CLIPPED,"' "
                  ," '1' 'N' 'N' 'Y'"   #TQC-740302 add  #MOD-7C0196 modify
          CALL cl_cmdrun(g_msg)

       ON ACTION print_order_chang
           LET l_wc = ' oep01 = "',g_oea.oea01 CLIPPED,'" '
          # LET g_msg = "axmr800 '",g_today,"' '' '",g_lang,"' 'Y' '' '' '", #FUN-C30085 mark
           LET g_msg = "axmg800 '",g_today,"' '' '",g_lang,"' 'Y' '' '' '", #FUN-C30085 add
                        l_wc CLIPPED,"' '3' '' '' '' '' '",g_oea.oea00,"'" CLIPPED    #FUN-860096 ADD
           CALL cl_cmdrun(g_msg)
       ON ACTION cancel
          LET INT_FLAG=FALSE
          LET g_action_choice="exit"
          EXIT MENU

       ON ACTION exit
          EXIT MENU

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121



        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU

    END MENU
    CALL cl_set_act_visible("accept,cancel", FALSE)


END FUNCTION

FUNCTION t400_out1()
DEFINE
    l_i             LIKE type_file.num5,    #No.FUN-680137 SMALLINT
    sr              RECORD
        oea00       LIKE oea_file.oea00,   # No.FUN-840165
        oea01       LIKE oea_file.oea01,
        oea02       LIKE oea_file.oea02,
        oea03       LIKE oea_file.oea03,
        oea032      LIKE oea_file.oea032,
        oea14       LIKE oea_file.oea14,
        oea15       LIKE oea_file.oea15,
        oea25       LIKE oea_file.oea25,
        oea23       LIKE oea_file.oea23,
        oea61       LIKE oea_file.oea61,
        oea1006     LIKE oea_file.oea1006  #No.FUN-610055
                    END RECORD,
    l_name          LIKE type_file.chr20               #External(Disk) file name  #No.FUN-680137 VARCHAR(20)

#DEFINE  l_table     STRING,                ### FUN-840165 ###     #MOD-890150
DEFINE  g_str       STRING,                ### FUN-840165 ###
        l_sql       STRING,                ### FUN-840165 ###
        g_sql       STRING                 ### FUN-840165 ###
DEFINE  l_name1     LIKE type_file.chr20   #No.FUN-840165
DEFINE  l_name2     LIKE type_file.chr20   #No.FUN-840165
DEFINE  l_gen02     LIKE gen_file.gen02    #No.FUN-840165
DEFINE  l_gem02     LIKE gem_file.gem02    #No.FUN-840165
DEFINE  l_oea61     LIKE oea_file.oea61    #No.FUN-840165
DEFINE  l_oea1006   LIKE oea_file.oea1006  #No.FUN-840165
DEFINE  l_oea1007   LIKE oea_file.oea1007  #No.FUN-840165
DEFINE  l_oea1008   LIKE oea_file.oea1008  #No.FUN-840165
#DEFINE  l_tax       LIKE ima_file.ima26    #No.FUN-840165 #FUN-A20044
DEFINE  l_tax       LIKE type_file.num15_3    #No.FUN-840165 #FUN-A20044
#DEFINE  l_tax1      LIKE ima_file.ima26    #No.FUN-840165 #FUN-A20044
DEFINE  l_tax1      LIKE type_file.num15_3     #No.FUN-840165 #FUN-A20044
#DEFINE  l_tot       LIKE ima_file.ima26    #No.FUN-840165 #FUN-A20044
DEFINE  l_tot       LIKE type_file.num15_3    #No.FUN-840165 #FUN-A20044
DEFINE  g_wc_2      STRING   #MOD-860114


    IF cl_null(g_wc) AND NOT cl_null(g_oea.oea01) THEN
       LET g_wc = " oea01 = '",g_oea.oea01,"'"
    END IF
    IF g_wc IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    CALL cl_wait()

    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang

    #視單身是否輸入資料決定sql 組法
    IF g_wc2 = " 1=1" THEN
         LET g_sql="SELECT oea00,oea01,oea02,oea03,oea032,oea14,oea15,",           #No.FUN-840165
                           "       oea25,oea23,oea61,oea1006",     #No.FUN-610055
                           " FROM oea_file",
                           "  WHERE ",g_wc CLIPPED,
                           " ORDER BY oea01"  #FUN-610055
    ELSE
          LET g_sql="SELECT DISTINCT oea00,oea01,oea02,oea03,oea032,oea14,oea15,",          #No.FUN-840165  #NO.FUN-920041
                            "       oea25,oea23,oea61,oea1006",    #No.FUN-610055
                            " FROM oea_file,oeb_file",
                            "  WHERE ",g_wc CLIPPED,
                            " AND   ",g_wc2 CLIPPED,
                            " AND oea01=oeb01 ",
                            " ORDER BY oea01"  #FUN-610055
    END IF
    PREPARE t400_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t400_co                         # CURSOR
        CURSOR FOR t400_p1

     LET g_program = g_prog                                                                 #MOD-550004
     LET g_prog= 'axmt400'                             #MOD-550004 #No.FUN-610055
    CALL cl_outnam('axmt400') RETURNING l_name         #No.FUN-610055
     LET l_name = g_program CLIPPED,l_name[8,11]                                            #MOD-550004
     LET g_xml_rep = l_name CLIPPED,".xml"                                                  #MOD-550004
     CALL fgl_report_set_document_handler(om.XmlWriter.createFileWriter(g_xml_rep CLIPPED)) #MOD-550004

     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-840165 *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-840165 add ###
     #------------------------------ CR (2) ------------------------------#

     IF g_aza.aza50 = 'Y' THEN
        IF g_argv1 = '0' THEN                          #No,FUN-840165
           LET l_name1 = 'axmt400'                     #No,FUN-840165
           LET l_name2 = 'axmt400'                     #No,FUN-840165
        ELSE                                           #No,FUN-840165
           IF g_argv1 = '2' THEN                       #No,FUN-840165
              LET l_name1 = 'axmt420'                  #No,FUN-840165
              LET l_name2 = 'axmt420'                  #No,FUN-840165
           ELSE                                        #No,FUN-840165
              IF g_argv1 = '1' THEN                    #No,FUN-840165
                 IF g_oea901 = 'N' THEN                #No,FUN-840165
                    LET l_name1 = 'axmt410'            #No,FUN-840165
                    LET l_name2 = 'axmt410'            #No,FUN-840165
                 ELSE                                  #No,FUN-840165
                    LET l_name1 = 'axmt810'            #No,FUN-840165
                    LET l_name2 = 'axmt810'            #No,FUN-840165
                 END IF                                #No,FUN-840165
              END IF                                   #No,FUN-840165
           END IF                                      #No,FUN-840165
         END IF
     ELSE
        LET l_name1 = 'axmt420_1'                      #No,FUN-840165
         IF g_argv1 = '0' THEN                         #No,FUN-840165
           LET l_name1 = 'axmt400'                     #No,FUN-840165
           LET l_name2 = 'axmt400_1'                   #No,FUN-840165
        ELSE                                           #No,FUN-840165
           IF g_argv1 = '2' THEN                       #No,FUN-840165
              LET l_name1 = 'axmt420'                  #No,FUN-840165
              LET l_name2 = 'axmt420_1'                #No,FUN-840165
           ELSE                                        #No,FUN-840165
              IF g_argv1 = '1' THEN                    #No,FUN-840165
                 IF g_oea901 = 'N' THEN                #No,FUN-840165
                    LET l_name1 = 'axmt410'            #No,FUN-840165
                    LET l_name2 = 'axmt410_1'          #No,FUN-840165
                 ELSE                                  #No,FUN-840165
                    LET l_name1 = 'axmt810'            #No,FUN-840165
                    LET l_name2 = 'axmt810_1'          #No,FUN-840165
                 END IF                                #No,FUN-840165
              END IF                                   #No,FUN-840165
           END IF                                      #No,FUN-840165
         END IF
     END IF

    FOREACH t400_co INTO sr.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
           SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
             FROM azi_file WHERE azi01 = sr.oea23
           SELECT gen02 INTO l_gen02 FROM gen_file
            WHERE gen01 = sr.oea14
           SELECT gem02 INTO l_gem02 FROM gem_file
            WHERE gem01 = sr.oea15
           SELECT oea61,oea1006,oea1007,oea1008 INTO l_oea61,l_oea1006,l_oea1007,l_oea1008 FROM oea_file
            WHERE oea01 = sr.oea01
           IF cl_null(l_oea61) THEN
              LET l_oea61 = 0
           END IF
           IF cl_null(l_oea1006) THEN
              LET l_oea1006 = 0
           END IF
           IF cl_null(l_oea1007) THEN
              LET l_oea1007 = 0
           END IF
           IF cl_null(l_oea1008) THEN
              LET l_oea1008 = 0
           END IF
           LET l_tax  = l_oea1008 - l_oea61
           LET l_tax1 = l_oea1007 - l_oea1006
           LET l_tot  = l_oea61 + l_tax - l_oea1006 - l_tax1
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-840165 *** ##
           EXECUTE insert_prep USING
                   l_gen02,l_gem02,sr.oea00,sr.oea01,sr.oea02,sr.oea03,sr.oea032,
                   sr.oea14,sr.oea15,sr.oea25,sr.oea23,sr.oea61,sr.oea1006,l_tax,
                   l_tax1,l_tot,t_azi04
          #------------------------------ CR (3) ------------------------------#
    END FOREACH


    CLOSE t400_co
    ERROR ""
     LET g_prog = g_program  #MOD-550004 add
      IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(g_wc,'oea01')
              RETURNING g_wc_2     #MOD-860114
      END IF
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-840165 **** ##
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    LET g_str = ''
    LET g_str = g_wc_2    #MOD-860114
    CALL cl_prt_cs3(l_name1,l_name2,l_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
END FUNCTION

FUNCTION t400_4()
  DEFINE choice  LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)   #CKD OR SKD
  DEFINE choice1 LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)   #單身各自取價否
  DEFINE l_ima910  LIKE ima_file.ima910 #FUN-550095 add

    IF g_oea.oea01 IS NULL THEN RETURN END IF
    IF g_oea.oea50 = 'N' THEN RETURN END IF
    LET choice = ' '
    LET choice1 = 'Y'
    LET g_choice1 = ' '
    LET g_flag =''
    LET g_tot3 =''

    OPEN WINDOW t4004_w WITH FORM "axm/42f/axmt4004"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("axmt4004")

    LET g_action_choice="modify"
    IF NOT cl_chk_act_auth() OR g_oea.oeaconf = 'Y' THEN

       DISPLAY BY NAME g_oea.oea51,g_oea.oea52,g_oea.oea53,
                  g_oea.oea54,g_oea.oea55,g_oea.oea61,g_oea.oea56,
                  g_oea.oea57,g_oea.oea59
            LET INT_FLAG = 0  ######add for prompt bug
       PROMPT ">" FOR CHAR g_chr

          ON IDLE g_idle_seconds
             CALL cl_on_idle()

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121


       END PROMPT
       CLOSE WINDOW t4004_w
       RETURN
    END IF

    IF cl_null(g_oea.oea52) THEN LET g_oea.oea52=g_today END IF
    INPUT BY NAME choice,g_oea.oea51,g_oea.oea52,g_oea.oea53,
                  g_oea.oea54,g_oea.oea55,g_oea.oea56,g_oea.oea57,
                  g_oea.oea59,choice1
                  WITHOUT DEFAULTS
       AFTER FIELD choice
          IF NOT cl_null(choice) THEN
             IF choice NOT MATCHES '[12]' THEN
                NEXT FIELD choice
             END IF
          END IF

       #No.FUN-AA0048  --Begin
       AFTER FIELD oea57
          IF NOT s_chk_ware(g_oea.oea57) THEN
             NEXT FIELD oea57
          END IF
       #No.FUN-AA0048  --End  

       AFTER FIELD oea51
          IF NOT cl_null(g_oea.oea51) THEN
#NO.FUN-A90048 add -----------start--------------------     
             IF NOT s_chk_item_no(g_oea.oea51,'') THEN
                CALL cl_err('',g_errno,1)
                LET g_oea.oea51 = g_oea_t.oea51 
                NEXT FIELD oea51
             END IF
#NO.FUN-A90048 add ------------end --------------------   
             SELECT ima130 INTO g_chr FROM ima_file
                    WHERE ima01=g_oea.oea51
             IF STATUS THEN
                CALL cl_err3("sel","ima_file",g_oea.oea51,"",STATUS,"","sel ima",1)  #No.FUN-650108
                NEXT FIELD oea51
             END IF
             SELECT COUNT(*) INTO i FROM bma_file WHERE bma01=g_oea.oea51
             IF i=0 THEN
                CALL cl_err('sel bma',100,0) NEXT FIELD oea51
             END IF
           END IF

       AFTER FIELD oea54
          LET g_oea.oea55=g_oea.oea53*g_oea.oea54
          CALL cl_digcut(g_oea.oea55,t_azi04) RETURNING g_oea.oea55              #No.CHI-6A0004
          DISPLAY BY NAME g_oea.oea55

       AFTER FIELD choice1
          IF NOT cl_null(choice1) THEN
             IF choice1 NOT MATCHES '[YN]' THEN
                NEXT FIELD choice1
             END IF
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


       ON ACTION controlp
           CASE
              WHEN INFIELD(oea51)
      #No.FUN-A90048 ----------------start--------------------        
      #           CALL cl_init_qry_var()
      #           LET g_qryparam.form ="q_bma101"
      #           LET g_qryparam.default1 = g_oea.oea51
      #           CALL cl_create_qry() RETURNING g_oea.oea51
                 CALL q_sel_ima(FALSE, "q_bma101","",g_oea.oea51,"", "", "", "" ,"" ,'')
                                  RETURNING g_oea.oea51  
      #No.FUN-A90048 ------------------end --------------------
                 DISPLAY BY NAME g_oea.oea51
                 NEXT FIELD oea51
           END CASE
    END INPUT

    IF INT_FLAG THEN
       LET INT_FLAG=0
       CLOSE WINDOW t4004_w
       RETURN
    END IF

    CLOSE WINDOW t4004_w

    UPDATE oea_file SET * = g_oea.* WHERE oea01 = g_oea.oea01
    IF SQLCA.SQLCODE THEN
       CALL cl_err3("upd","oea_file",g_oea.oea01,"",SQLCA.sqlcode,"","update oea",1)  #No.FUN-650108
    END IF

    IF g_oea.oeaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_oea.oeaconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
    IF g_oea.oea62 != 0 THEN CALL cl_err('','axm-162',0) RETURN END IF

    IF NOT cl_confirm('axm-120') THEN RETURN END IF

   #詢問是否刪除oeb_file
    SELECT COUNT(*) INTO g_cnt FROM oeb_file
     WHERE oeb01 = g_oea.oea01
    IF g_cnt>0 THEN
        IF cl_confirm('axm-122') THEN
          LET g_flag ='Y'
          IF g_oea.oeaconf ='N' THEN
            DELETE FROM oeb_file WHERE oeb01 = g_oea.oea01
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL cl_err3("del","oeb_file",g_oea.oea01,"",SQLCA.sqlcode,"","del oeb:",1)  #No.FUN-650108
            END IF
          END IF
        ELSE
          LET g_flag ='N'
          LET g_tot3 = g_cnt #記錄單身原先筆數
        END IF
    ELSE
         LET g_flag ='Y'
    END IF

    IF choice1='Y' THEN
       LET g_choice1='Y'
    ELSE
       LET g_choice1='N'
    END IF

    LET l_ima910 = NULL
    SELECT ima910 INTO l_ima910 FROM ima_file
     WHERE ima01=g_oea.oea51
    IF l_ima910 IS NULL THEN LET l_ima910 = ' ' END IF
    IF choice='1' THEN
       CALL t400_csd_bom(g_oea.oea51,l_ima910,g_oea.oea52) #CKD(展至尾階) #FUN-550095 add l_ima910
    ELSE
       CALL t400gloabl_csd()
    END IF

END FUNCTION


FUNCTION t400_csd_bom(p_item,p_code,p_date) #FUN-550095 add p_code
  DEFINE i       LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE p_item  LIKE bma_file.bma01,
         p_code  LIKE bma_file.bma06, #FUN-550095 add
         p_date  LIKE bmb_file.bmb04,
         l_bma01 LIKE bma_file.bma01,
         l_bma06 LIKE bma_file.bma06  #FUN-550095 add bma06

    #產生一暫存檔
     CALL t400_create_tmp()

     DECLARE bma01_cur CURSOR FOR
       SELECT UNIQUE bma01,bma06 FROM bma_file
        WHERE bma01 = p_item
          AND bma06 = p_code
     IF SQLCA.sqlcode THEN
        CALL cl_err('bma_cur',STATUS,1)
     END IF
     FOREACH bma01_cur INTO l_bma01,l_bma06 #FUN-550095 add bma06
       IF SQLCA.sqlcode THEN CALL cl_err('bma_for',STATUS,1) END IF
       CALL t400_bom(l_bma01,l_bma06,p_date,'0','0')   #FUN-550095 add l_bma06
     END FOREACH

     CALL t400_bom_update()
     CALL t400_csd_price()
     DELETE FROM tmp1_file WHERE 1=1

END FUNCTION

FUNCTION t400_create_tmp()
    DROP TABLE tmp1_file
    IF SQLCA.sqlcode != -242 THEN #BugNo:5075
        SELECT bmb_file.* ,ima31,ima25,ima55,ima31_fac,ima02,ima127
          FROM bmb_file,ima_file
         WHERE bmb01='@@@@'
           AND bmb01=ima01
          INTO TEMP tmp1_file
        IF SQLCA.SQLCODE THEN
            LET g_success='N'
            CALL cl_err3("sel","bmb_file,ima_file","","",SQLCA.sqlcode,"","create tmp1_file:",1)  #No.FUN-650108
        END IF
    END IF
    DELETE FROM tmp1_file WHERE 1=1
END FUNCTION

FUNCTION t400_bom_update()
 DEFINE l_bma01  LIKE bma_file.bma01,
        p_date   LIKE bmb_file.bmb04,
        l_sql   STRING, #NO.TQC-630166
        l_bmb   RECORD LIKE bmb_file.*,
        b03,b03_old  LIKE bmb_file.bmb03,
        l_ima   RECORD
                ima31  LIKE ima_file.ima31,
                ima25  LIKE ima_file.ima25,
                ima55  LIKE ima_file.ima55,

                ima31_fac LIKE ima_file.ima31_fac,
                ima02  LIKE ima_file.ima02,
                ima127 LIKE ima_file.ima127
               END RECORD,
        b_oeb   RECORD LIKE oeb_file.* ,
        l_bmb03 LIKE bmb_file.bmb03,
        l_bmb06 LIKE bmb_file.bmb06,
        l_bmb07 LIKE bmb_file.bmb07,
        l_oeb12 LIKE oeb_file.oeb12
   DEFINE l_cnt LIKE type_file.num5      #No.FUN-680137 SMALLINT
   DEFINE l_oeb930 LIKE oeb_file.oeb930  #FUN-670063

     DECLARE bom_update_cur CURSOR FOR
        SELECT * FROM tmp1_file
        ORDER BY bmb03

     IF SQLCA.sqlcode THEN call cl_err('bom_cur',status,1) END IF
     INITIALIZE b_oeb.* TO NULL
     IF g_flag ='Y' THEN
       LET b_oeb.oeb03 = 0
     ELSE
       LET b_oeb.oeb03 = g_tot3  #原先單身筆數
     END IF
     LET b03 = ' '
     LET b03_old =' '
     let l_cnt = 0
     LET l_oeb930=s_costcenter(g_oea.oea15) #FUN-670063
     LET b_oeb.oeb44='1'           #No.FUN-870007
     LET b_oeb.oebplant = g_plant  #No.FUN-870007
     LET b_oeb.oeblegal = g_legal  #No.FUN-870007
     FOREACH bom_update_cur INTO l_bmb.*,l_ima.*
          MESSAGE '1:',l_bmb.bmb03
          LET b03 = l_bmb.bmb03
     #檢查是否有重複料件
       IF  b03_old != b03  THEN  #新料
          LET b_oeb.oeb01 = g_oea.oea01
          LET b_oeb.oeb03 = b_oeb.oeb03 + 1
          LET b_oeb.oeb04 = l_bmb.bmb03
          LET b_oeb.oeb05 = l_ima.ima31
          LET l_sql =" SELECT COUNT(*) FROM tmp1_file  ",
                   # " WHERE b03 = ? " clipped
                     " WHERE bmb03 = ? " clipped
          prepare count_pre from l_sql
          declare count_cur cursor for count_pre
          open count_cur using l_bmb.bmb03
          fetch count_cur into l_cnt
          IF l_cnt > 1 THEN
           #-----------計算數量
           LET l_sql=" SELECT bmb03,bmb06,bmb07",
                     " FROM tmp1_file ",
                     " WHERE bmb03 = ? " CLIPPED
           PREPARE oeb12_pre FROM l_sql
           DECLARE oeb12_cur CURSOR FOR oeb12_pre
           LET l_oeb12 = 0
           LET b_oeb.oeb12 = 0
           FOREACH oeb12_cur
           USING l_bmb.bmb03
           INTO l_bmb03,l_bmb06,l_bmb07
            IF SQLCA.sqlcode THEN CALL cl_err('fore-oeb12',STATUS,1)
              EXIT FOREACH END IF
            LET l_oeb12 = g_oea.oea53 *(l_bmb06/l_bmb07)
            IF l_oeb12 IS NULL THEN LET l_oeb12 = 0 END IF
            LET b_oeb.oeb12 = b_oeb.oeb12 + l_oeb12
           END FOREACH
          #---------------
          END IF
          IF cl_null(b_oeb.oeb05) THEN LET b_oeb.oeb05=l_ima.ima25 END IF
          LET b_oeb.oeb05_fac = l_ima.ima31_fac
          IF cl_null(b_oeb.oeb05_fac) THEN LET b_oeb.oeb05_fac=1 END IF
          LET b_oeb.oeb06 = l_ima.ima02
          LET b_oeb.oeb09 = g_oea.oea57

         #----------- 數量 ---------------------------------------#
          IF l_cnt <= 1 THEN
            LET b_oeb.oeb12 = g_oea.oea53 * (l_bmb.bmb06 / l_bmb.bmb07)
            IF cl_null(b_oeb.oeb12) THEN LET b_oeb.oeb12=0 END IF
          END IF
         #--------------------------------------------------------#

          IF g_choice1='Y' THEN
             CALL s_fetch_price_new(g_oea.oea03,b_oeb.oeb04,b_oeb.oeb05,b_oeb.oeb15,g_oea.oea00,
                                g_plant,g_oea.oea23,g_oea.oea31,g_oea.oea32,g_oea.oea01,
                                 b_oeb.oeb03,b_oeb.oeb12,b_oeb.oeb1004,'a')
             #   RETURNING b_oeb.oeb13               #FUN-AB0061 mark
                 RETURNING b_oeb.oeb13,b_oeb.oeb37   #FUN-AB0061
             IF b_oeb.oeb13 = 0 THEN CALL s_unitprice_entry(g_oea.oea03,g_oea.oea31,g_plant) END IF #FUN-9C0120
          ELSE
            LET b_oeb.oeb13 = l_ima.ima127 / g_oea.oea24
            LET b_oeb.oeb37 = b_oeb.oeb13                  #FUN-AB0061  
          END IF

          IF cl_null(b_oeb.oeb13) THEN LET b_oeb.oeb13=0 END IF
          CALL cl_digcut(b_oeb.oeb13,t_azi03) RETURNING b_oeb.oeb13     #No.CHI-6A0004
          IF cl_null(b_oeb.oeb37) THEN LET b_oeb.oeb37 = 0 END IF       #FUN-AB0061 
          CALL cl_digcut(b_oeb.oeb37,t_azi03) RETURNING b_oeb.oeb37     #FUN-AB0061
          LET b_oeb.oeb17 = b_oeb.oeb13         #no.7150

         #-----------未稅金額--------------------------------------
          # 用計價數量來算
          IF cl_null(b_oeb.oeb916) THEN
             LET b_oeb.oeb916=b_oeb.oeb05
             LET b_oeb.oeb917=b_oeb.oeb12
          END IF
          LET b_oeb.oeb14 = b_oeb.oeb917 * b_oeb.oeb13
          CALL cl_digcut(b_oeb.oeb14,t_azi04) RETURNING b_oeb.oeb14       #No.CHI-6A0004
          LET b_oeb.oeb14t=b_oeb.oeb14*(1+g_oea.oea211/100)
          CALL cl_digcut(b_oeb.oeb14t,t_azi04) RETURNING b_oeb.oeb14t     #No.CHI-6A0004
          #--------------------------------------------------------

          LET b_oeb.oeb15 = g_oea.oea59 LET b_oeb.oeb16 = g_oea.oea59
          LET b_oeb.oeb23 = 0 LET b_oeb.oeb24 = 0
          LET b_oeb.oeb25 = 0 LET b_oeb.oeb26 = 0
          LET b_oeb.oeb70 = 'N'
          LET b_oeb.oeb71 = g_oea.oea71
          IF cl_null(b_oeb.oeb15) THEN
             LET b_oeb.oeb15=g_today
             LET b_oeb.oeb16=g_today
          END IF
          LET b_oeb.oeb19 = 'N'   #MOD-9A0154
          LET b_oeb.oeb905 = 0 #no.7182
          CALL t400_g_du(b_oeb.oeb04,b_oeb.oeb05,b_oeb.oeb12)
          IF cl_null(b_oeb.oeb091) THEN LET b_oeb.oeb091=' ' END IF
          IF cl_null(b_oeb.oeb092) THEN LET b_oeb.oeb092=' ' END IF
          LET b_oeb.oeb1003 = '1'
          LET b_oeb.oeb930=l_oeb930 #FUN-670063
          LET b_oeb.oeb920 = 0
          #抓產品客戶檔obk11
          IF g_oea.oea00<>'4' THEN #CHI-970074
             SELECT obk11 INTO b_oeb.oeb906
               FROM obk_file
              WHERE obk01 = b_oeb.oeb04
                AND obk02 = g_oea.oea03
                AND obk05 = g_oea.oea23   #MOD-940385
             IF cl_null(b_oeb.oeb906) THEN
                LET b_oeb.oeb906 = 'N'
             END IF
          ELSE #CHI-970074
             LET b_oeb.oeb906='N' #CHI-970074
          END IF  #CHI-970074
          IF cl_null(b_oeb.oeb1012) THEN LET b_oeb.oeb1012 = 'N' END IF   #MOD-870034
          IF cl_null(b_oeb.oeb1006) THEN LET b_oeb.oeb1006 = 100 END IF   #MOD-A10123
          IF cl_null(b_oeb.oeb47) THEN LET b_oeb.oeb47 = '0' END IF     #TQC-AA0040
          IF cl_null(b_oeb.oeb48) THEN LET b_oeb.oeb48 = '1' END IF     #TQC-AA0040
          LET b_oeb.oebplant = g_plant #FUN-980010 add
          LET b_oeb.oeblegal = g_legal #FUN-980010 add
          INSERT INTO oeb_file VALUES (b_oeb.*)
          IF STATUS OR SQLCA.SQLCODE THEN
             CALL cl_err3("ins","oeb_file",b_oeb.oeb01,"",SQLCA.SQLCODE,"","ins oeb:",1) #No.FUN-650108
             RETURN
          END IF
          LET b03_old = b03
      END IF
        END FOREACH

        DELETE FROM tmp1_file WHERE 1=1
END FUNCTION

FUNCTION t400_bom(p_item,p_code,p_date,p_root,p_play) #FUN-550095 add p_code
  DEFINE p_item  LIKE bma_file.bma01
  DEFINE p_code  LIKE bma_file.bma06 #FUN-550095 add
  DEFINE p_date  LIKE bmb_file.bmb04,
         l_cnt,i   LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         p_root   LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
         p_play   LIKE bmb_file.bmb06,
         l_bmb   DYNAMIC ARRAY OF RECORD LIKE bmb_file.*,
         l_flag  LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
         l_factor LIKE ima_file.ima31_fac,  #No.FUN-680137 dec(16,8)
         l_bma   ARRAY[600] OF LIKE bma_file.bma01,
         l_ima   DYNAMIC ARRAY OF RECORD
                  ima31     LIKE ima_file.ima31,
                  ima25     LIKE ima_file.ima25,
                  ima55     LIKE ima_file.ima55,  #單位
                  ima31_fac LIKE ima_file.ima31_fac,
                  ima02     LIKE ima_file.ima02,
                  ima127    LIKE ima_file.ima127
                 END RECORD
  DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035

  LET g_sql =" SELECT bmb_file.*,ima31,ima25,ima55,ima31_fac,",
                "                ima02,ima127,bma01",
                " FROM bmb_file LEFT OUTER JOIN ima_file ON (bmb03 = ima01) LEFT OUTER JOIN  bma_file ON (bmb03 = bma01)",
                " WHERE bmb01 ='",p_item,"'",
                "   AND bmb29 ='",p_code,"'", #FUN-550095 add
                " AND (bmb04 <='",p_date,"' OR bmb04 IS NULL )",
                " AND (bmb05 > '",p_date,"' OR bmb05 IS NULL )"

       PREPARE t400_bmb_pre FROM g_sql
       IF SQLCA.sqlcode THEN CALL cl_err('t400_bmb_pre',STATUS,1) END IF
       DECLARE t400_bmb_cur CURSOR FOR t400_bmb_pre
       IF SQLCA.sqlcode THEN CALL cl_err('t400_bmb_cur',STATUS,1) END IF
        LET l_cnt = 1
       FOREACH t400_bmb_cur INTO l_bmb[l_cnt].*,l_ima[l_cnt].*,l_bma[l_cnt]
           IF SQLCA.sqlcode THEN CALL cl_err('t400_bmb_cur foreach:',STATUS,1)
              EXIT FOREACH END IF
           IF p_root ='1' THEN   #所展元件
             IF l_ima[l_cnt].ima55 = l_bmb[l_cnt].bmb10 THEN #單位相同
                LET l_bmb[l_cnt].bmb06 = l_bmb[l_cnt].bmb06 * p_play
             ELSE
                CALL s_umfchk(l_bmb[l_cnt].bmb03,l_ima[l_cnt].ima55,
                              l_bmb[l_cnt].bmb10)
                RETURNING l_flag,l_factor
                LET l_bmb[l_cnt].bmb06 = l_bmb[l_cnt].bmb06 *p_play*l_factor
             END IF
           END IF
           LET l_ima910[l_cnt]=''
           SELECT ima910 INTO l_ima910[l_cnt] FROM ima_file WHERE ima01=l_bmb[l_cnt].bmb03
           IF cl_null(l_ima910[l_cnt]) THEN LET l_ima910[l_cnt]=' ' END IF
           LET l_cnt = l_cnt + 1
       END FOREACH
       LET l_cnt = l_cnt - 1
       FOR i = 1 TO l_cnt
         IF l_bma[i] IS NOT NULL THEN  #有下階料件
              CALL t400_bom(l_bmb[i].bmb03,l_ima910[i],p_date,'1',l_bmb[i].bmb06) #FUN-8B0035
         ELSE
             INSERT INTO tmp1_file VALUES (l_bmb[i].*,l_ima[i].*)
             IF SQLCA.sqlerrd[3]=0 THEN
                CALL cl_err3("ins","tmp1_file","","",STATUS,"","ins tmp",1)   #No.FUN-650108
             END IF
         END IF
       END FOR
END FUNCTION


FUNCTION t400gloabl_csd()
    DEFINE l_bmb     RECORD LIKE bmb_file.*
    DEFINE l_ima     RECORD LIKE ima_file.*,
           b03, b03_old LIKE bmb_file.bmb03
    DEFINE l_ima910  LIKE ima_file.ima910     #FUN-550095 add
    DEFINE l_bmb03   LIKE bmb_file.bmb03,
           l_bmb06   LIKE bmb_file.bmb06,
           l_bmb07   LIKE bmb_file.bmb07,
           l_oeb12   LIKE oeb_file.oeb12
    DEFINE l_oeb930  LIKE oeb_file.oeb930     #FUN-670063

    LET l_ima910 = NULL
    SELECT ima910 INTO l_ima910 FROM ima_file
     WHERE ima01=g_oea.oea51
    IF l_ima910 IS NULL THEN LET l_ima910 = ' ' END IF

    DECLARE t400_csd_c CURSOR FOR
        SELECT bmb_file.*, ima_file.*
          FROM bmb_file LEFT OUTER JOIN ima_file ON bmb03 = ima01
          WHERE bmb01 = g_oea.oea51
            AND bmb29 = l_ima910 #FUN-550095 add
            AND (bmb04 <=g_oea.oea52 OR bmb04 IS NULL)
            AND (bmb05 > g_oea.oea52 OR bmb05 IS NULL)
       ORDER BY bmb03

    #產生一暫存檔
    CALL t400_create_tmp2()
    FOREACH t400_csd_c INTO l_bmb.*,l_ima.*
       INSERT INTO tmp2_file(p01) VALUES (l_bmb.bmb03)
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","tmp2_file",l_bmb.bmb03,"",STATUS,"","ins tmp2",1)   #No.FUN-650108
       END IF
    END FOREACH

    INITIALIZE b_oeb.* TO NULL
    IF g_flag ='Y' THEN
      LET b_oeb.oeb03 = 0
    ELSE
      LET b_oeb.oeb03 = g_tot3
    END IF
    LET b03 = ' '
    LET b03_old = ' '
    LET l_oeb930=s_costcenter(g_oea.oea15) #FUN-670063
    LET b_oeb.oebplant = g_plant  #No.FUN-870007
    LET b_oeb.oeblegal = g_legal  #No.FUN-870007
    LET b_oeb.oeb44 = '1'         #No.FUN-870007
    FOREACH t400_csd_c INTO l_bmb.*, l_ima.*
       IF STATUS THEN CALL cl_err('foreach',STATUS,1) RETURN END IF
       MESSAGE '1:',l_bmb.bmb03
       LET b03 = l_bmb.bmb03
       IF b03 != b03_old THEN
         SELECT COUNT(*) INTO g_cnt FROM tmp2_file WHERE p01 = l_bmb.bmb03
         LET b_oeb.oeb01 = g_oea.oea01
         LET b_oeb.oeb03 = b_oeb.oeb03 + 1
         LET b_oeb.oeb04 = l_bmb.bmb03
         LET b_oeb.oeb05 = l_ima.ima31
         IF cl_null(b_oeb.oeb05) THEN LET b_oeb.oeb05=l_ima.ima25 END IF
         LET b_oeb.oeb05_fac = l_ima.ima31_fac
         IF cl_null(b_oeb.oeb05_fac) THEN LET b_oeb.oeb05_fac=1 END IF
         LET b_oeb.oeb06 = l_ima.ima02
         LET b_oeb.oeb09 = g_oea.oea57
         LET b_oeb.oeb12 = (g_oea.oea53 *(l_bmb.bmb06 / l_bmb.bmb07)) *g_cnt
         IF cl_null(b_oeb.oeb12) THEN LET b_oeb.oeb12=0 END IF

         IF g_choice1='Y' THEN
            CALL s_fetch_price_new(g_oea.oea03,b_oeb.oeb04,b_oeb.oeb05,b_oeb.oeb15,g_oea.oea00,
                                g_plant,g_oea.oea23,g_oea.oea31,g_oea.oea32,g_oea.oea01,
                                 b_oeb.oeb03,b_oeb.oeb12,b_oeb.oeb1004,'a')
             #   RETURNING b_oeb.oeb13             #FUN-AB0061 mark
                 RETURNING b_oeb.oeb13,b_oeb.oeb37 #FUN-AB0061 
             IF b_oeb.oeb13 = 0 THEN CALL s_unitprice_entry(g_oea.oea03,g_oea.oea31,g_plant) END IF #FUN-9C0120
         ELSE
           LET b_oeb.oeb13 = l_ima.ima127 / g_oea.oea24
           LET b_oeb.oeb37 = b_oeb.oeb13           #FUN-AB0061
         END IF

         IF cl_null(b_oeb.oeb13) THEN LET b_oeb.oeb13=0 END IF
         CALL cl_digcut(b_oeb.oeb13,t_azi03)RETURNING b_oeb.oeb13      #No.CHI-6A0004
         IF cl_null(b_oeb.oeb37) THEN LET b_oeb.oeb37 = 0 END IF       #FUN-AB0061
         CALL cl_digcut(b_oeb.oeb37,t_azi03)RETURNING b_oeb.oeb37      #FUN-AB0061 
         LET b_oeb.oeb17 = b_oeb.oeb13   #no.7150

         #用計價數量來算
         IF g_sma.sma115 = 'Y' THEN
            SELECT ima31,ima906,ima907 INTO g_ima31,g_ima906,g_ima907
              FROM ima_file WHERE ima01=b_oeb.oeb04
            LET b_oeb.oeb910=b_oeb.oeb05
            LET g_factor = 1
            CALL s_umfchk(b_oeb.oeb04,b_oeb.oeb910,g_ima31)
                 RETURNING g_cnt,g_factor
            IF g_cnt = 1 THEN
               LET g_factor = 1
            END IF
            LET b_oeb.oeb911=g_factor
            LET b_oeb.oeb912=b_oeb.oeb12
            LET b_oeb.oeb913=g_ima907
            LET g_factor = 1
            CALL s_umfchk(b_oeb.oeb04,b_oeb.oeb913,g_ima31)
                 RETURNING g_cnt,g_factor
            IF g_cnt = 1 THEN
               LET g_factor = 1
            END IF
            LET b_oeb.oeb914=g_factor
            LET b_oeb.oeb915=0
            IF g_ima906 = '3' THEN
               LET g_factor = 1
               CALL s_umfchk(b_oeb.oeb04,b_oeb.oeb910,b_oeb.oeb913)
                    RETURNING g_cnt,g_factor
               IF g_cnt = 1 THEN
                  LET g_factor = 1
               END IF
               LET b_oeb.oeb915=b_oeb.oeb912*g_factor
            END IF
         END IF
         LET b_oeb.oeb916 =b_oeb.oeb05
         LET b_oeb.oeb917 =b_oeb.oeb12
         LET b_oeb.oeb14 = b_oeb.oeb917 * b_oeb.oeb13
         CALL cl_digcut(b_oeb.oeb14,t_azi04)RETURNING b_oeb.oeb14      #No.CHI-6A0004
         LET b_oeb.oeb14t=b_oeb.oeb14*(1+g_oea.oea211/100)
         CALL cl_digcut(b_oeb.oeb14t,t_azi04)RETURNING b_oeb.oeb14t    #No.CHI-6A0004
         LET b_oeb.oeb15 = g_oea.oea59 LET b_oeb.oeb16 = g_oea.oea59
         LET b_oeb.oeb19 = 'N'                  #genero
         LET b_oeb.oeb23 = 0 LET b_oeb.oeb24 = 0
         LET b_oeb.oeb25 = 0 LET b_oeb.oeb26 = 0
         LET b_oeb.oeb70 = 'N'
         LET b_oeb.oeb71 = g_oea.oea71
          IF cl_null(b_oeb.oeb15) THEN
             LET b_oeb.oeb15=g_today
             LET b_oeb.oeb16=g_today
          END IF
          LET b_oeb.oeb905 = 0 #no.7182
         CALL t400_g_du(b_oeb.oeb04,b_oeb.oeb05,b_oeb.oeb12)
         IF cl_null(b_oeb.oeb091) THEN LET b_oeb.oeb091=' ' END IF
         IF cl_null(b_oeb.oeb092) THEN LET b_oeb.oeb092=' ' END IF
         LET b_oeb.oeb1003 = '1'
         LET b_oeb.oeb930=l_oeb930 #FUN-670063
         LET b_oeb.oeb920 = 0
         IF g_oea.oea00<>'4' THEN #CHI-970074
           #抓產品客戶檔obk11
            SELECT obk11 INTO b_oeb.oeb906
              FROM obk_file
             WHERE obk01 = b_oeb.oeb04
               AND obk02 = g_oea.oea03
               AND obk05 = g_oea.oea23   #MOD-940385
            IF cl_null(b_oeb.oeb906) THEN
               LET b_oeb.oeb906 = 'N'
            END IF
         ELSE #CHI-970074
            LET b_oeb.oeb906='N' #CHI-970074
         END IF #CHI-970074
         IF cl_null(b_oeb.oeb1012) THEN LET b_oeb.oeb1012 = 'N' END IF   #MOD-870034
         IF cl_null(b_oeb.oeb1006) THEN LET b_oeb.oeb1006 = 100 END IF   #MOD-A10123
         LET b_oeb.oebplant = g_plant #FUN-980010
         LET b_oeb.oeblegal = g_legal #FUN-980010
#MOD-B30616 --BEGIN--
         IF cl_null(b_oeb.oeb47) THEN
            LET b_oeb.oeb47 = 0 
         END IF 
         IF cl_null(b_oeb.oeb48) THEN
            LET b_oeb.oeb48 = '1'
         END IF
#MOD-B30616 --END--
         INSERT INTO oeb_file VALUES (b_oeb.*)
         IF STATUS OR SQLCA.SQLCODE THEN
            CALL cl_err3("ins","oeb_file",b_oeb.oeb01,"",SQLCA.SQLCODE,"","ins oeb:",1)   #No.FUN-650108
            RETURN
         END IF
       END IF
       LET b03_old = b03
    END FOREACH
    CALL t400_csd_price()
    delete  from tmp2_file where 1=1
END FUNCTION


FUNCTION t400_csd_price()
    DEFINE max_tot,tot2,tot3    LIKE oeb_file.oeb14
    DEFINE max_i		LIKE type_file.num10   #No.FUN-680137 INTEGER

    SELECT SUM(oeb14) INTO tot FROM oeb_file WHERE oeb01=g_oea.oea01
    IF cl_null(tot) OR tot=0 THEN LET tot=1 END IF

    SELECT SUM(oeb14) INTO tot3 FROM oeb_file WHERE oeb01=g_oea.oea01
                           		        AND (oeb23>0 OR oeb24>0)
	IF cl_null(tot3) THEN LET tot3=0 END IF
	LET tot=tot-tot3

    DECLARE t400_csd_c2 CURSOR FOR
       SELECT * FROM oeb_file
       WHERE oeb01 = g_oea.oea01
	 AND (oeb23=0 AND oeb24=0)
	ORDER BY oeb03

    LET i = 0 LET max_tot = 0 LET tot2 = 0
    FOREACH t400_csd_c2 INTO b_oeb.*
       IF STATUS THEN CALL cl_err('foreach2',STATUS,1) RETURN END IF
       MESSAGE '2:',b_oeb.oeb03
       LET b_oeb.oeb13 = b_oeb.oeb13 * (g_oea.oea55-tot3) / tot
       CALL cl_digcut(b_oeb.oeb13,t_azi03)RETURNING b_oeb.oeb13    #No.CHI-6A0004

       #未稅金額#
       #用計價數量來算
       IF g_sma.sma115 = 'Y' THEN
          SELECT ima31,ima906,ima907 INTO g_ima31,g_ima906,g_ima907
            FROM ima_file WHERE ima01=b_oeb.oeb04
          LET b_oeb.oeb910=b_oeb.oeb05
          LET g_factor = 1
          CALL s_umfchk(b_oeb.oeb04,b_oeb.oeb910,g_ima31)
               RETURNING g_cnt,g_factor
          IF g_cnt = 1 THEN
             LET g_factor = 1
          END IF
          LET b_oeb.oeb911=g_factor
          LET b_oeb.oeb912=b_oeb.oeb12
          LET b_oeb.oeb913=g_ima907
          LET g_factor = 1
          CALL s_umfchk(b_oeb.oeb04,b_oeb.oeb913,g_ima31)
               RETURNING g_cnt,g_factor
          IF g_cnt = 1 THEN
             LET g_factor = 1
          END IF
          LET b_oeb.oeb914=g_factor
          LET b_oeb.oeb915=0
          IF g_ima906 = '3' THEN
             LET g_factor = 1
             CALL s_umfchk(b_oeb.oeb04,b_oeb.oeb910,b_oeb.oeb913)
                  RETURNING g_cnt,g_factor
             IF g_cnt = 1 THEN
                LET g_factor = 1
             END IF
             LET b_oeb.oeb915=b_oeb.oeb912*g_factor
          END IF
       END IF
       LET b_oeb.oeb916 =b_oeb.oeb05
       LET b_oeb.oeb917 =b_oeb.oeb12
       LET b_oeb.oeb14 = b_oeb.oeb917 * b_oeb.oeb13
       CALL cl_digcut(b_oeb.oeb14,t_azi04) RETURNING b_oeb.oeb14        #No.CHI-6A0004
       LET b_oeb.oeb14t=b_oeb.oeb14*(1+g_oea.oea211/100)
       CALL cl_digcut(b_oeb.oeb14t,t_azi04) RETURNING b_oeb.oeb14t      #No.CHI-6A0004

       LET tot2 = tot2 + b_oeb.oeb14
       IF b_oeb.oeb14 >= max_tot THEN
          LET max_tot = b_oeb.oeb14 LET max_i   = b_oeb.oeb03
       END IF
       IF cl_null(b_oeb.oeb091) THEN LET b_oeb.oeb091=' ' END IF
       IF cl_null(b_oeb.oeb092) THEN LET b_oeb.oeb092=' ' END IF
       UPDATE oeb_file SET * = b_oeb.*
            WHERE oeb01 = g_oea.oea01 AND oeb03 = b_oeb.oeb03
    END FOREACH
    LET tot = (g_oea.oea55-tot3) - tot2
    SELECT * INTO b_oeb.* FROM oeb_file WHERE oeb01=g_oea.oea01 AND oeb03=max_i
       LET b_oeb.oeb14 = b_oeb.oeb14 + tot
       CALL cl_digcut(b_oeb.oeb14,t_azi04) RETURNING b_oeb.oeb14  #No.CHI-6A0004
       #用計價數量來算
       IF g_sma.sma115 = 'Y' THEN
          SELECT ima31,ima906,ima907 INTO g_ima31,g_ima906,g_ima907
            FROM ima_file WHERE ima01=b_oeb.oeb04
          LET b_oeb.oeb910=b_oeb.oeb05
          LET g_factor = 1
          CALL s_umfchk(b_oeb.oeb04,b_oeb.oeb910,g_ima31)
               RETURNING g_cnt,g_factor
          IF g_cnt = 1 THEN
             LET g_factor = 1
          END IF
          LET b_oeb.oeb911=g_factor
          LET b_oeb.oeb912=b_oeb.oeb12
          LET b_oeb.oeb913=g_ima907
          LET g_factor = 1
          CALL s_umfchk(b_oeb.oeb04,b_oeb.oeb913,g_ima31)
               RETURNING g_cnt,g_factor
          IF g_cnt = 1 THEN
             LET g_factor = 1
          END IF
          LET b_oeb.oeb914=g_factor
          LET b_oeb.oeb915=0
          IF g_ima906 = '3' THEN
             LET g_factor = 1
             CALL s_umfchk(b_oeb.oeb04,b_oeb.oeb910,b_oeb.oeb913)
                  RETURNING g_cnt,g_factor
             IF g_cnt = 1 THEN
                LET g_factor = 1
             END IF
             LET b_oeb.oeb915=b_oeb.oeb912*g_factor
          END IF
       END IF
       LET b_oeb.oeb916 =b_oeb.oeb05
       LET b_oeb.oeb917 =b_oeb.oeb12
       LET b_oeb.oeb13 = b_oeb.oeb14 / b_oeb.oeb917
       CALL cl_digcut(b_oeb.oeb13,t_azi03) RETURNING b_oeb.oeb13    #No.CHI-6A0004
       LET b_oeb.oeb14t=b_oeb.oeb14*(1+g_oea.oea211/100)
       CALL cl_digcut(b_oeb.oeb14t,t_azi04) RETURNING b_oeb.oeb14t  #No.CHI-6A0004
       IF cl_null(b_oeb.oeb091) THEN LET b_oeb.oeb091=' ' END IF
       IF cl_null(b_oeb.oeb092) THEN LET b_oeb.oeb092=' ' END IF
       UPDATE oeb_file SET * = b_oeb.*
              WHERE oeb01 = g_oea.oea01 AND oeb03 = b_oeb.oeb03
    SELECT SUM(oeb14),SUM(oeb14t) INTO g_oea.oea61,g_oea.oea1008 FROM oeb_file WHERE oeb01=g_oea.oea01    #FUN-A50103
    CALL cl_digcut(g_oea.oea61,t_azi04) RETURNING g_oea.oea61  #CHI-7A0036-add
    CALL cl_digcut(g_oea.oea1008,t_azi04) RETURNING g_oea.oea1008    #FUN-A50103
    IF cl_null(g_oea.oea61) THEN LET g_oea.oea61=0 END IF
    IF cl_null(g_oea.oea1008) THEN LET g_oea.oea1008=0 END IF    #FUN-A50103
    UPDATE oea_file SET oea61 = g_oea.oea61,
                        oea1008=g_oea.oea1008    #FUN-A50103
     WHERE oea01 = g_oea.oea01
    DISPLAY BY NAME g_oea.oea61
END FUNCTION

FUNCTION t400_5()
   IF g_oea.oea01 IS NULL THEN RETURN END IF

   LET g_action_choice="modify"
   IF NOT cl_chk_act_auth() THEN
      LET g_chr='d'
   ELSE
      LET g_chr='u'
   END IF

   CALL s_axm_fee(g_oea.oea01,g_chr)
END FUNCTION

FUNCTION t400_6()
    DEFINE p_cmd,o_hold LIKE imd_file.imd01  #No.FUN-680137 VARCHAR(10)

    BEGIN WORK
    OPEN t400_cl USING g_oea.oea01
    IF STATUS THEN
       CALL cl_err("OPEN t400_cl:", STATUS, 1)
       CLOSE t400_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH t400_cl INTO g_oea.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t400_cl ROLLBACK WORK RETURN
    END IF

    IF g_oea.oea01 IS NULL THEN RETURN END IF
    LET o_hold=g_oea.oeahold
    INPUT BY NAME g_oea.oeahold WITHOUT DEFAULTS
       AFTER FIELD oeahold
              SELECT oak02 INTO g_buf FROM oak_file
               WHERE oak01=g_oea.oeahold AND oak03='1'
              IF STATUS THEN
                 CALL cl_err3("sel","oak_file",g_oea.oeahold,"",STATUS,"","select oak",1)  #No.FUN-650108
                 NEXT FIELD oeahold
              END IF
              DISPLAY g_buf TO oak02
      ON ACTION controlp
         CASE
            WHEN INFIELD(oeahold)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oak1"
               LET g_qryparam.default1= g_oea.oeahold
               LET g_qryparam.arg1 ='1'
               CALL cl_create_qry() RETURNING g_oea.oeahold
               DISPLAY BY NAME g_oea.oeahold
               NEXT FIELD oeahold
          END CASE

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
    IF INT_FLAG THEN
       LET g_oea.oeahold=o_hold DISPLAY BY NAME g_oea.oeahold
       LET INT_FLAG=0 RETURN
    END IF

    UPDATE oea_file SET oeahold = g_oea.oeahold WHERE oea01 = g_oea.oea01
    IF SQLCA.SQLCODE THEN
        CALL cl_err3("upd","oea_file",g_oea.oea01,"",SQLCA.sqlcode,"","update oea",1)  #No.FUN-650108
        ROLLBACK WORK
    ELSE
        COMMIT WORK
    END IF

END FUNCTION

FUNCTION t400_7()

    BEGIN WORK
    OPEN t400_cl USING g_oea.oea01
    IF STATUS THEN
       CALL cl_err("OPEN t400_cl:", STATUS, 1)
       CLOSE t400_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH t400_cl INTO g_oea.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t400_cl ROLLBACK WORK RETURN
    END IF
    IF NOT cl_null(g_oea.oeahold) THEN   #TQC-AB0170
       IF NOT cl_confirm("axm-102") THEN
          RETURN
       END IF
    ELSE              #TQC-AB0170
       ROLLBACK WORK  #TQC-AB0170
       RETURN         #TQC-AB0170
    END IF            #TQC-AB0170
    IF g_oea.oea01 IS NULL THEN RETURN END IF

    UPDATE oea_file SET oeahold = NULL WHERE oea01 = g_oea.oea01
    IF SQLCA.SQLCODE THEN
       CALL cl_err3("upd","oea_file",g_oea.oea01,"",SQLCA.sqlcode,"","update oea",1)  #No.FUN-650108
       ROLLBACK WORK
       RETURN
    ELSE
        COMMIT WORK
    END IF
    LET g_oea.oeahold = ''  #MOD-8C0118
    DISPLAY '','' TO oeahold,oak02

END FUNCTION

FUNCTION t400_b_more1()
   DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
   DEFINE l_oac02   LIKE oac_file.oac02,
          l_ged02   LIKE ged_file.ged02,
          l_oah02   LIKE oah_file.oah02,
          l_n       LIKE type_file.num5,    #No.FUN-680137 SMALLINT
          l_qty     LIKE img_file.img10    #No.FUN-680137 INTEGER #FUN-6C0006

   DEFINE l_oeb     DYNAMIC ARRAY OF RECORD
          oeb03     LIKE oeb_file.oeb03,
          oebislk01 LIKE oebi_file.oebislk01,  #No.FUN-810016
          oeb49     LIKE oeb_file.oeb49,     #No.FUN-A90040
          oeb50     LIKE oeb_file.oeb50,     #No.FUN-A90040
          oeb04     LIKE oeb_file.oeb04,
          oeb06     LIKE oeb_file.oeb06,
          oeb18     LIKE oeb_file.oeb18,
          oac02     LIKE oac_file.oac02,
          oeb20     LIKE oeb_file.oeb20,
          ged02     LIKE ged_file.ged02,
          oeb21     LIKE oeb_file.oeb21,
          oah02     LIKE oah_file.oah02,
          oeb11     LIKE oeb_file.oeb11,
          oeb07     LIKE oeb_file.oeb07,
          oeb09     LIKE oeb_file.oeb09,
          oeb091    LIKE oeb_file.oeb091,
          oeb092    LIKE oeb_file.oeb092,
          oeb05_fac LIKE oeb_file.oeb05_fac,
          oeb913    LIKE oeb_file.oeb913,
          oeb914    LIKE oeb_file.oeb914,
          oeb910    LIKE oeb_file.oeb910,
          oeb911    LIKE oeb_file.oeb911,
          oeb17     LIKE oeb_file.oeb17    #FUN-640259 add
                       END RECORD
   DEFINE l_oeb_t   RECORD
          oeb03     LIKE oeb_file.oeb03,
          oebislk01 LIKE oebi_file.oebislk01,
          oeb49     LIKE oeb_file.oeb49,     #No.FUN-A90040
          oeb50     LIKE oeb_file.oeb50,     #No.FUN-A90040
          oeb04     LIKE oeb_file.oeb04,
          oeb06     LIKE oeb_file.oeb06,
          oeb18     LIKE oeb_file.oeb18,
          oac02     LIKE oac_file.oac02,
          oeb20     LIKE oeb_file.oeb20,
          ged02     LIKE ged_file.ged02,
          oeb21     LIKE oeb_file.oeb21,
          oah02     LIKE oah_file.oah02,
          oeb11     LIKE oeb_file.oeb11,
          oeb07     LIKE oeb_file.oeb07,
          oeb09     LIKE oeb_file.oeb09,
          oeb091    LIKE oeb_file.oeb091,
          oeb092    LIKE oeb_file.oeb092,
          oeb05_fac LIKE oeb_file.oeb05_fac,
          oeb913    LIKE oeb_file.oeb913,
          oeb914    LIKE oeb_file.oeb914,
          oeb910    LIKE oeb_file.oeb910,
          oeb911    LIKE oeb_file.oeb911,
          oeb17     LIKE oeb_file.oeb17    #FUN-640259 add
                    END RECORD
   DEFINE l_rec_b   LIKE type_file.num5,    #No.FUN-680137 SMALLINT
          l_cnt     LIKE type_file.num5    #No.FUN-680137 SMALLINT

   IF l_ac = 0 THEN
      LET l_ac = 1
   END IF

   IF cl_null(g_oea.oea01) OR cl_null(g_oeb[l_ac].oeb03) THEN
      RETURN
   END IF

   OPEN WINDOW t4005_memo_w WITH FORM "axm/42f/axmt4005_memo"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_locale("axmt4005_memo")

    IF g_sma.sma115 ='N' THEN
       CALL cl_set_comp_visible("oeb913,oeb914",FALSE)
       CALL cl_set_comp_visible("oeb910,oeb911",FALSE)
    END IF

   IF NOT s_industry('slk') THEN
      CALL cl_set_comp_visible("oebislk01",FALSE)
   END IF
   LET g_success = 'Y'
   LET g_sql = "SELECT oeb03,'',oeb04,oeb06,oeb18,'',oeb20,'',oeb21,'',oeb11, ",   #No.FUN-810016 oeb03后加一個空
               "       oeb07,oeb09,oeb091,oeb092,oeb05_fac,oeb913,oeb914,oeb910,oeb911,oeb17 ",   #FUN-640259 add oeb17
               "  FROM oeb_file ",
               " WHERE oeb01 = '",g_oea.oea01,"'"
   LET g_sql = g_sql CLIPPED," ORDER BY oeb03,oeb04 "

   PREPARE s_axmt4005_pre1 FROM g_sql

   DECLARE s_axmt4005_c1 CURSOR FOR s_axmt4005_pre1

   CALL g_oeb.clear()
   LET l_cnt = 1

   FOREACH s_axmt4005_c1 INTO l_oeb[l_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach oeb',STATUS,0)
         EXIT FOREACH
      END IF

      IF NOT cl_null(l_oeb[l_cnt].oeb18) THEN
         SELECT oac02 INTO l_oeb[l_cnt].oac02 FROM oac_file
          WHERE oac01 = l_oeb[l_cnt].oeb18
         IF SQLCA.sqlcode THEN
            LET l_oeb[l_cnt].oac02 = ' '
         END IF
         DISPLAY l_oeb[l_cnt].oac02 TO FORMONLY.oac02  #MOD-6B0153 modify [i]
      END IF

      IF NOT cl_null(l_oeb[l_cnt].oeb20) THEN
         SELECT ged02 INTO l_oeb[l_cnt].ged02 FROM ged_file
          WHERE ged01 = l_oeb[l_cnt].oeb20   #MOD-6B0153 modify [i]
         IF SQLCA.sqlcode THEN
            LET l_oeb[l_cnt].ged02 = ' '
         END IF
         DISPLAY l_oeb[l_cnt].ged02 TO FORMONLY.ged02
      END IF

      IF NOT cl_null(l_oeb[l_cnt].oeb21) THEN
         SELECT oah02 INTO l_oeb[l_cnt].oah02 FROM oah_file
          WHERE oah01 = l_oeb[l_cnt].oeb21
         IF SQLCA.sqlcode THEN
            LET l_oeb[l_cnt].oah02 = ' '
         END IF
         DISPLAY l_oeb[l_cnt].oah02 TO FORMONLY.oah02
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH

   CALL l_oeb.deleteElement(l_cnt)
   LET l_rec_b = l_cnt - 1
   LET i = 1
   CALL cl_set_act_visible("cancel", FALSE)

   IF g_oea.oeaconf !="N" THEN           #FUN-680057
      DISPLAY ARRAY l_oeb TO s_oeb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY

        ON ACTION about
           CALL cl_about()

        ON ACTION help
           CALL cl_show_help()

      END DISPLAY
   ELSE
      CALL cl_set_comp_entry("oeb910,oeb914,oeb911,oeb913",FALSE)

      IF g_sma.sma115 = 'Y' THEN
         CALL cl_set_comp_visible("oeb05_fac",FALSE)
         CALL cl_set_comp_att_text("oeb05_fac",' ')
         CALL cl_set_comp_entry("oeb910,oeb914,oeb911,oeb913",FALSE)
      ELSE
         CALL cl_set_comp_visible("oeb914,oeb913",FALSE)
         CALL cl_set_comp_visible("oeb911,oeb910",FALSE)
         CALL cl_set_comp_att_text("oeb914,oeb913",' ')
         CALL cl_set_comp_att_text("oeb911,oeb910",' ')
      END IF

      IF g_sma.sma122 ='1' THEN
         CALL cl_getmsg('asm-353',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("oeb914",g_msg CLIPPED)
         CALL cl_getmsg('asm-354',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("oeb911",g_msg CLIPPED)
      END IF

      IF g_sma.sma122 ='2' THEN
         CALL cl_getmsg('asm-355',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("oeb914",g_msg CLIPPED)
         CALL cl_getmsg('asm-356',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("oeb911",g_msg CLIPPED)
      END IF

      INPUT ARRAY l_oeb WITHOUT DEFAULTS FROM s_oeb.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=TRUE,DELETE ROW=FALSE,APPEND ROW=FALSE)
         BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(i)
            END IF

         BEFORE ROW
            LET p_cmd = ''
            LET i=ARR_CURR()
            IF g_rec_b >= i THEN
               LET l_oeb_t.* = l_oeb[i].*  #BACK UP
               BEGIN WORK
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            LET g_before_input_done = FALSE
            CALL t400_set_entry_b_more()
            CALL t400_set_no_entry_b_more()
            CALL t400_set_no_required_b_more()
            LET g_before_input_done = TRUE

         AFTER FIELD oeb18
            IF NOT cl_null(l_oeb[i].oeb18) THEN
               SELECT oac02 INTO l_oeb[i].oac02 FROM oac_file
                WHERE oac01 = l_oeb[i].oeb18
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","oac_file","l_oeb[i].oeb18","","mfg3119","","",1)  #No.FUN-650108
                  NEXT FIELD oeb18
               END IF
               DISPLAY l_oeb[i].oac02 TO FORMONLY.oac02
            END IF

         AFTER FIELD oeb20
            IF NOT cl_null(l_oeb[i].oeb20) THEN
               SELECT ged02 INTO l_oeb[i].ged02 FROM ged_file
                WHERE ged01 = l_oeb[i].oeb20
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","ged_file",l_oeb[i].oeb20,"","axm-309","","",1)  #No.FUN-650108
                  NEXT FIELD oeb20
               END IF
               DISPLAY l_oeb[i].ged02 TO FORMONLY.ged02
            END IF

         AFTER FIELD oeb21
            IF NOT cl_null(l_oeb[i].oeb21) THEN
               SELECT oah02 INTO l_oeb[i].oah02 FROM oah_file
                WHERE oah01 = l_oeb[i].oeb21
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","oah_file",l_oeb[i].oeb21,"","mfg4101","","",1)  #No.FUN-650108
                  NEXT FIELD oeb21
               END IF
               DISPLAY l_oeb[i].oah02 TO FORMONLY.oah02
            END IF

         #No.FUN-AA0048  --Begin
         AFTER FIELD oeb09
            IF NOT s_chk_ware(l_oeb[i].oeb09) THEN
               NEXT FIELD oeb09
            END IF
         #No.FUN-AA0048  --End  

         AFTER FIELD oeb092
            IF NOT cl_null(l_oeb[i].oeb092) THEN
#FUN-AB0011 --------------------STR
               IF s_joint_venture( l_oeb[i].oeb04,g_plant) OR NOT s_internal_item( l_oeb[i].oeb04,g_plant ) THEN
               ELSE
#FUN-AB0011 --------------------END
                  IF g_oea.oea00!='0' THEN
                     LET l_n = 0
                     SELECT COUNT(*),SUM(img10*img21) INTO l_n,l_qty
                       FROM img_file
                      WHERE img01 = l_oeb[i].oeb04
                        AND img04 = l_oeb[i].oeb092
                     IF l_n = 0 THEN
                       #CALL cl_err('part+lot:','axm-244',0)         #CHI-A10002 mark
                        CALL cl_err(l_oeb[i].oeb04,'axm-244',0)      #CHI-A10002 add
                        NEXT FIELD oeb092
                     END IF
                     IF l_qty IS NULL THEN
                        LET l_qty = 0
                     END IF
                     LET g_msg=NULL
                     SELECT ze03 INTO g_msg FROM ze_file
                      WHERE ze01='axm-246'
                        AND ze02=p_lang
                     ERROR g_msg CLIPPED,l_qty
                   END IF
               END IF                                      #FUN-AB0011 add       
            END IF
            IF g_sma.sma115 = 'Y' THEN
               IF NOT cl_null(l_oeb[i].oeb09) THEN
                  IF cl_null(l_oeb[i].oeb091) THEN
                     LET l_oeb[i].oeb091 = ' '
                  END IF
                  IF cl_null(l_oeb[i].oeb092) THEN
                     LET l_oeb[i].oeb092 = ' '
                  END IF
                  SELECT img09 INTO g_img09 FROM img_file
                   WHERE img01=l_oeb[i].oeb04
                     AND img02=l_oeb[i].oeb09
                     AND img03=l_oeb[i].oeb091
                     AND img04=l_oeb[i].oeb092
                  IF SQLCA.sqlcode = 0 THEN
                     CALL t400_set_du_fac()
                  END IF
               END IF
            END IF

         ON ROW CHANGE
            UPDATE oeb_file SET oeb03 = l_oeb[i].oeb03,
                                oeb04 = l_oeb[i].oeb04,
                                oeb06 = l_oeb[i].oeb06,
                                oeb18 = l_oeb[i].oeb18,
                                oeb20 = l_oeb[i].oeb20,
                                oeb21 = l_oeb[i].oeb21,
                                oeb11 = l_oeb[i].oeb11,
                                oeb07 = l_oeb[i].oeb07,
                                oeb09 = l_oeb[i].oeb09,
                                oeb091 = l_oeb[i].oeb091,
                                oeb092 = l_oeb[i].oeb092,
                                oeb05_fac = l_oeb[i].oeb05_fac,
                                oeb914 = l_oeb[i].oeb914,
                                oeb911 = l_oeb[i].oeb911,
                                oeb913 = l_oeb[i].oeb913,
                                oeb910 = l_oeb[i].oeb910
                          WHERE oeb01 = g_oea.oea01
                            AND oeb03 = l_oeb_t.oeb03
            IF STATUS THEN
               LET g_success = 'N'
               CALL cl_err3("upd","oeb_file",g_oea.oea01,l_oeb_t.oeb03,STATUS,"","upd oeb:",1)  #No.FUN-650108
            END IF
         AFTER ROW
            LET i = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET l_oeb[i].* = l_oeb_t.*
               END IF
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF g_success = 'Y' THEN
               COMMIT WORK
            ELSE
               ROLLBACK WORK
            END IF

         ON ACTION controlp
            CASE
               WHEN INFIELD(oeb18)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_oac"
                    LET g_qryparam.default1 = l_oeb[i].oeb18
                    CALL cl_create_qry() RETURNING l_oeb[i].oeb18
                    DISPLAY BY NAME l_oeb[i].oeb18
                    NEXT FIELD oeb18
               WHEN INFIELD(oeb20)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ged"
                    LET g_qryparam.default1 = l_oeb[i].oeb20
                    CALL cl_create_qry() RETURNING l_oeb[i].oeb20
                    DISPLAY BY NAME l_oeb[i].oeb20 NEXT FIELD oeb20
               WHEN INFIELD(oeb21)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_oah"
                    LET g_qryparam.default1 = l_oeb[i].oeb21
                    CALL cl_create_qry() RETURNING l_oeb[i].oeb21
                    DISPLAY BY NAME l_oeb[i].oeb21 NEXT FIELD oeb21
               WHEN INFIELD(oeb09)
                    #No.FUN-AA0048  --Begin
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form ="q_imd"
                    #LET g_qryparam.default1 = l_oeb[i].oeb09
                    # LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                    #LET g_qryparam.construct= 'N'
                    #CALL cl_create_qry() RETURNING l_oeb[i].oeb09
                    CALL q_imd_1(FALSE,TRUE,l_oeb[i].oeb09,"","","","") RETURNING l_oeb[i].oeb09
                    #No.FUN-AA0048  --End  
                     DISPLAY BY NAME l_oeb[i].oeb09
                     NEXT FIELD oeb09

               WHEN INFIELD(oeb091)
                    #No.FUN-AA0048  --Begin
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form ="q_ime"
                    #LET g_qryparam.default1 = l_oeb[i].oeb091
                    #LET g_qryparam.arg1     = l_oeb[i].oeb09 #倉庫編號 #MOD-4A0063
                    #LET g_qryparam.arg2     = 'SW'              #倉庫類別 #MOD-4A
                    #LET g_qryparam.construct= 'N'
                    #CALL cl_create_qry() RETURNING l_oeb[i].oeb091
                    CALL q_ime_1(FALSE,TRUE,l_oeb[i].oeb091,l_oeb[i].oeb09,"","","","","") RETURNING l_oeb[i].oeb091
                    #No.FUN-AA0048  --End  
                     NEXT FIELD oeb091
               OTHERWISE EXIT CASE
            END CASE

         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_sma.sma115 = 'Y' THEN
               CALL t400_set_origin_field('m')
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
   END IF

   CLOSE WINDOW t4005_memo_w

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF


END FUNCTION

FUNCTION t400_b_more()
  DEFINE l_oac02  LIKE oac_file.oac02,
         l_ged02  LIKE ged_file.ged02,
         l_oah02  LIKE oah_file.oah02,
         l_n      LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_qty    LIKE img_file.img10    #No.FUN-680137 INTEGER
#FUN-A60035 ---MARK BEGIN
#  DEFINE l_oeb03_old   LIKE oeb_file.oeb03  #FUN-A60035 add
#  DEFINE l_oeb12_old   LIKE oeb_file.oeb12  #FUN-A60035 add
#  DEFINE l_oeb917_old  LIKE oeb_file.oeb917 #FUN-A60035 add
#FUN-A60035 ---MARK END

    IF l_ac = 0 THEN
       LET l_ac = 1
    END IF

    IF cl_null(g_oea.oea01) OR cl_null(g_oeb[l_ac].oeb03) THEN
       RETURN
    END IF

    OPEN WINDOW t4005_w WITH FORM "axm/42f/axmt4005"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("axmt4005")

    IF g_action_choice="other_data" THEN
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#&ifdef SLK 
#      LET l_oeb03_old = g_oeb[l_ac].oeb03
#      DECLARE t540_b_more CURSOR FOR
#       SELECT ata03 FROM ata_file
#        WHERE ata00 = g_prog
#          AND ata01 = g_oea.oea01
#          AND ata02 = g_oeb[l_ac].oeb03
#      FOREACH t540_b_more INTO g_oeb[l_ac].oeb03 
#         IF STATUS THEN
#            CALL cl_err('',STATUS,0)
#         END IF
#         EXIT FOREACH
#      END FOREACH
#&endif
##FUN-A60035 ---add end   
#FUN-A60035 ---MARK END    
       SELECT * INTO b_oeb.* FROM oeb_file
        WHERE oeb01= g_oea.oea01 AND oeb03= g_oeb[l_ac].oeb03

       IF NOT cl_null(b_oeb.oeb18) THEN
          SELECT oac02 INTO l_oac02 FROM oac_file
           WHERE oac01 = b_oeb.oeb18
          IF SQLCA.sqlcode THEN LET l_oac02 = ' ' END IF
          DISPLAY l_oac02 TO FORMONLY.oac02
       END IF

       IF NOT cl_null(b_oeb.oeb20) THEN
          SELECT ged02 INTO l_ged02 FROM ged_file
           WHERE ged01 = b_oeb.oeb20
          IF SQLCA.sqlcode THEN LET l_ged02 = ' ' END IF
          DISPLAY l_ged02 TO FORMONLY.ged02
       END IF
       IF NOT cl_null(b_oeb.oeb21) THEN
          SELECT oah02 INTO l_oah02 FROM oah_file
           WHERE oah01 = b_oeb.oeb21
          IF SQLCA.sqlcode THEN LET l_oah02 = ' ' END IF
          DISPLAY l_oah02 TO FORMONLY.oah02
       END IF


       DISPLAY BY NAME b_oeb.oeb18,b_oeb.oeb20,b_oeb.oeb21,
                        b_oeb.oeb11,b_oeb.oeb07,             #MOD-570253
                       b_oeb.oeb09,b_oeb.oeb091,b_oeb.oeb092,
                       b_oeb.oeb05_fac,
                       b_oeb.oeb17   #FUN-640259 add

      CALL cl_anykey('')
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#&ifdef SLK
#      LET g_oeb[l_ac].oeb03 = l_oeb03_old
#&endif
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END

      CLOSE WINDOW t4005_w                 #結束畫面

   ELSE


    SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=b_oeb.oeb04
    CALL cl_set_comp_entry("oeb914,oeb911",FALSE)
    IF g_sma.sma115 = 'Y' THEN
       CALL cl_set_comp_visible("oeb05_fac",FALSE)
       CALL cl_set_comp_att_text("oeb05_fac",' ')
       CALL cl_set_comp_entry("oeb914,oeb911",FALSE)
    ELSE
       CALL cl_set_comp_visible("oeb914",FALSE)
       CALL cl_set_comp_visible("oeb911",FALSE)
       CALL cl_set_comp_att_text("oeb914",' ')
       CALL cl_set_comp_att_text("oeb911",' ')
    END IF
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-353',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb914",g_msg CLIPPED)
       CALL cl_getmsg('asm-354',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb911",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-355',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb914",g_msg CLIPPED)
       CALL cl_getmsg('asm-356',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb911",g_msg CLIPPED)
    END IF

    IF NOT cl_null(b_oeb.oeb18) THEN
       SELECT oac02 INTO l_oac02 FROM oac_file
        WHERE oac01 = b_oeb.oeb18
       IF SQLCA.sqlcode THEN LET l_oac02 = ' ' END IF
       DISPLAY l_oac02 TO FORMONLY.oac02
    END IF

    IF NOT cl_null(b_oeb.oeb20) THEN
       SELECT ged02 INTO l_ged02 FROM ged_file
        WHERE ged01 = b_oeb.oeb20
       IF SQLCA.sqlcode THEN LET l_ged02 = ' ' END IF
       DISPLAY l_ged02 TO FORMONLY.ged02
    END IF

    IF NOT cl_null(b_oeb.oeb21) THEN
       SELECT oah02 INTO l_oah02 FROM oah_file
        WHERE oah01 = b_oeb.oeb21
       IF SQLCA.sqlcode THEN LET l_oah02 = ' ' END IF
       DISPLAY l_oah02 TO FORMONLY.oah02
    END IF

    INPUT BY NAME b_oeb.oeb18,b_oeb.oeb20,b_oeb.oeb21,
                   b_oeb.oeb11,b_oeb.oeb07,             #MOD-570253
                  b_oeb.oeb09,b_oeb.oeb091,g_oeb[l_ac].oeb092,b_oeb.oeb05_fac,
                  g_oeb[l_ac].oeb914,g_oeb[l_ac].oeb911,
                  b_oeb.oeb17   #FUN-640259 add
                  WITHOUT DEFAULTS

       BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t400_set_entry_b_more()
         CALL t400_set_no_entry_b_more()
         CALL t400_set_no_required_b_more()
         LET g_before_input_done = TRUE
         IF g_oea.oea00 = '9' THEN
            LET b_oeb.oeb09 = g_oaz.oaz78
            LET b_oeb.oeb091 = ' '
            LET b_oeb.oeb092 = g_oea.oea03
            DISPLAY BY NAME b_oeb.oeb09,b_oeb.oeb091,b_oeb.oeb092
         END IF

       AFTER FIELD oeb18
         IF NOT cl_null(b_oeb.oeb18) THEN
            SELECT oac02 INTO l_oac02 FROM oac_file
             WHERE oac01 = b_oeb.oeb18
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","oac_file",b_oeb.oeb18,"","mfg3119","","",1)  #No.FUN-650108
               NEXT FIELD oeb18
            END IF
            DISPLAY l_oac02 TO FORMONLY.oac02
         END IF

       AFTER FIELD oeb20
         IF NOT cl_null(b_oeb.oeb20) THEN
            SELECT ged02 INTO l_ged02 FROM ged_file
             WHERE ged01 = b_oeb.oeb20
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","ged_file",b_oeb.oeb20,"","axm-309","","",1)  #No.FUN-650108
               NEXT FIELD oeb20
            END IF
            DISPLAY l_ged02 TO FORMONLY.ged02
         END IF

       AFTER FIELD oeb21
         IF NOT cl_null(b_oeb.oeb21) THEN
            SELECT oah02 INTO l_oah02 FROM oah_file
             WHERE oah01 = b_oeb.oeb21
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","oah_file",b_oeb.oeb21,"","mfg4101","","",1)  #No.FUN-650108
               NEXT FIELD oeb21
            END IF
            DISPLAY l_oah02 TO FORMONLY.oah02
         END IF

       AFTER FIELD oeb11       
          LET g_oeb[l_ac].oeb11 = b_oeb.oeb11

       #No.FUN-AA0048  --Begin
       AFTER FIELD oeb09
          IF NOT cl_null(b_oeb.oeb09) THEN
             IF NOT s_chk_ware(b_oeb.oeb09) THEN
                NEXT FIELD oeb09
             END IF
          END IF
       #No.FUN-AA0048  --End  

       AFTER FIELD oeb092
           IF NOT cl_null(g_oeb[l_ac].oeb092) THEN
#FUN-AB0011 ------------------STR
              IF s_joint_venture( g_tlf.tlf01,g_plant) OR NOT s_internal_item( g_tlf.tlf01,g_plant ) THEN
              ELSE
#FUN-AB0011 ------------------END
                 IF g_oea.oea00!='0' THEN
                    LET l_n=0
                    SELECT COUNT(*),SUM(img10*img21) INTO l_n,l_qty FROM img_file
                     WHERE img01=g_oeb[l_ac].oeb04 AND img04=g_oeb[l_ac].oeb092
                    IF l_n=0 THEN
                      #CALL cl_err('part+lot:','axm-244',0)        #CHI-A10002 mark
                       CALL cl_err(g_oeb[l_ac].oeb04,'axm-244',0)  #CHI-A10002 add
                       NEXT FIELD oeb092
                    END IF
                    IF l_qty IS NULL THEN LET l_qty=0 END IF
                    LET g_msg=NULL
                    SELECT ze03 INTO g_msg FROM ze_file
                     WHERE ze01='axm-246' AND ze02=p_lang
                    ERROR g_msg CLIPPED,l_qty
                 END IF
              END IF                                                #FUN-AB0011  add 
           END IF
            IF g_sma.sma115 = 'Y' THEN
               IF NOT cl_null(b_oeb.oeb09) THEN
                 IF cl_null(b_oeb.oeb091) THEN LET b_oeb.oeb091=' ' END IF
                 IF cl_null(g_oeb[l_ac].oeb092) THEN LET g_oeb[l_ac].oeb092=' ' END IF
                 SELECT img09 INTO g_img09 FROM img_file
                  WHERE img01=g_oeb[l_ac].oeb04
                    AND img02=b_oeb.oeb09
                    AND img03=b_oeb.oeb091
                    AND img04=g_oeb[l_ac].oeb092
                 IF SQLCA.sqlcode = 0 THEN
                    CALL t400_set_du_fac()
                 END IF
              END IF
           END IF

      ON ACTION controlp
         CASE
            WHEN INFIELD(oeb18)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oac"
                 LET g_qryparam.default1 = b_oeb.oeb18
                 CALL cl_create_qry() RETURNING b_oeb.oeb18
                 DISPLAY BY NAME b_oeb.oeb18
                 NEXT FIELD oeb18
            WHEN INFIELD(oeb20)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ged"
                 LET g_qryparam.default1 = b_oeb.oeb20
                 CALL cl_create_qry() RETURNING b_oeb.oeb20
                 DISPLAY BY NAME b_oeb.oeb20 NEXT FIELD oeb20
            WHEN INFIELD(oeb21)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oah"
                 LET g_qryparam.default1 = b_oeb.oeb21
                 CALL cl_create_qry() RETURNING b_oeb.oeb21
                 DISPLAY BY NAME b_oeb.oeb21 NEXT FIELD oeb21
            WHEN INFIELD(oeb09)
                 #No.FUN-AA0048  --Begin
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_imd"
                 #LET g_qryparam.default1 = b_oeb.oeb09
                 #LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                 #LET g_qryparam.construct= 'N'
                 #CALL cl_create_qry() RETURNING b_oeb.oeb09
                 CALL q_imd_1(FALSE,TRUE,b_oeb.oeb09,"","","","") RETURNING b_oeb.oeb09
                 #No.FUN-AA0048  --End  
                  DISPLAY BY NAME b_oeb.oeb09
                  NEXT FIELD oeb09

            WHEN INFIELD(oeb091)
                 #No.FUN-AA0048  --Begin
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_ime"
                 #LET g_qryparam.default1 = b_oeb.oeb091
                 #LET g_qryparam.arg1     = b_oeb.oeb09 #倉庫編號 #MOD-4A0063
                 #LET g_qryparam.arg2     = 'SW'              #倉庫類別 #MOD-4A0063
                 #LET g_qryparam.construct= 'N'
                 #CALL cl_create_qry() RETURNING b_oeb.oeb091
                 CALL q_ime_1(FALSE,TRUE,b_oeb.oeb091,b_oeb.oeb09,"","","","","") RETURNING b_oeb.oeb091
                 #No.FUN-AA0048  --End  
                  NEXT FIELD oeb091
            OTHERWISE EXIT CASE
         END CASE

       AFTER INPUT
           IF INT_FLAG THEN EXIT INPUT END IF
           IF g_sma.sma115 = 'Y' THEN
              CALL t400_set_origin_field('m')
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

    CLOSE WINDOW t4005_w                 #結束畫面

    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF cl_null(b_oeb.oeb091) THEN LET b_oeb.oeb091=' ' END IF
    IF cl_null(b_oeb.oeb092) THEN LET b_oeb.oeb092=' ' END IF

#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#&ifdef SLK
#      LET l_oeb03_old = g_oeb[l_ac].oeb03
#      LET l_oeb12_old = g_oeb[l_ac].oeb12
#      LET l_oeb917_old = g_oeb[l_ac].oeb917
#      DECLARE t540_b_more2 CURSOR FOR
#       SELECT ata03 FROM ata_file
#        WHERE ata00 = g_prog
#          AND ata01 = g_oea.oea01
#          AND ata02 = g_oeb[l_ac].oeb03
#      FOREACH t540_b_more2 INTO g_oeb[l_ac].oeb03
#         IF STATUS THEN
#            CALL cl_err('',STATUS,0)
#         END IF
#         SELECT oeb12,oeb917 INTO g_oeb[l_ac].oeb12,g_oeb[l_ac].oeb917 FROM oeb_file
#          WHERE oeb01 = g_oea.oea01
#            AND oeb03 = g_oeb[l_ac].oeb03
#&endif
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
    UPDATE oeb_file SET oeb18 = b_oeb.oeb18,
                        oeb20 = b_oeb.oeb20,
                        oeb21 = b_oeb.oeb21,
                        oeb11 = b_oeb.oeb11,
                        oeb07 = b_oeb.oeb07,  #MOD-6B0151 modify oeb17->oeb07
                        oeb09 = b_oeb.oeb09,
                        oeb091= b_oeb.oeb091,
                        oeb092= g_oeb[l_ac].oeb092,
                        oeb05     = g_oeb[l_ac].oeb05,
                        oeb05_fac = b_oeb.oeb05_fac,
                        oeb12     = g_oeb[l_ac].oeb12,
                        oeb911    = g_oeb[l_ac].oeb911,
                        oeb914    = g_oeb[l_ac].oeb914,
                        oeb916    = g_oeb[l_ac].oeb916,
                        oeb917    = g_oeb[l_ac].oeb917
     WHERE oeb01 = g_oea.oea01 AND oeb03 = g_oeb[l_ac].oeb03   #MOD-8A0144

#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#&ifdef SLK
#    END FOREACH
#    LET g_oeb[l_ac].oeb03 = l_oeb03_old
#    LET g_oeb[l_ac].oeb12 = l_oeb12_old
#    LET g_oeb[l_ac].oeb917 = l_oeb917_old
#&endif
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END

   END IF

END FUNCTION

FUNCTION t400_set_entry_b_more()

    IF NOT g_before_input_done THEN
        CALL cl_set_comp_entry("oeb09,oeb091,oeb092",TRUE)       #MOD-570253
    END IF
END FUNCTION

FUNCTION t400_set_no_entry_b_more()

    IF NOT g_before_input_done THEN
       IF g_oaz.oaz102='N' THEN
          CALL cl_set_comp_entry("oeb09",FALSE)
       END IF
       IF g_oaz.oaz103='N' THEN
          CALL cl_set_comp_entry("oeb091",FALSE)
       END IF
       IF g_oaz.oaz104='N' THEN
          CALL cl_set_comp_entry("oeb092",FALSE)
       END IF
    END IF

END FUNCTION

FUNCTION t400_set_no_required_b_more()

  CALL cl_set_comp_required("oeb911,oeb914",FALSE)

END FUNCTION

#三角貿易資料維護=== No.7946 add this function
FUNCTION t400_v()
   DEFINE l_poz02  LIKE poz_file.poz02,
          l_poy03  LIKE poy_file.poy03,
          l_poy31  LIKE poy_file.poy03,
          l_poy32  LIKE poy_file.poy03,
          l_poy33  LIKE poy_file.poy03,
          l_poy34  LIKE poy_file.poy03,
          l_poy35  LIKE poy_file.poy03,
          l_poy36  LIKE poy_file.poy03,
          l_occ09  LIKE occ_file.occ09
   DEFINE l_ans    LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
   DEFINE i        LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_poy04  LIKE poy_file.poy04    #FUN-670007
   DEFINE l_poy20  LIKE poy_file.poy20    #FUN-670007

    BEGIN WORK
    OPEN t400_cl USING g_oea.oea01    #mod by liuxqa 091020
    IF STATUS THEN
       CALL cl_err("OPEN t400_cl:", STATUS, 1)
       CLOSE t400_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH t400_cl INTO g_oea.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t400_cl ROLLBACK WORK RETURN
    END IF

    IF g_oea.oea01 IS NULL THEN RETURN END IF

    #重新讀取資料
    SELECT * INTO g_oea.* FROM oea_file
     WHERE oea01=g_oea.oea01


    OPEN WINDOW t8103_w AT 06,11 WITH FORM "axm/42f/axmt4003"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_locale("axmt4003")

    #讀取流程代碼相關資料
    LET l_poz02=null
    LET l_poy31=null  LET l_poy32=null
    LET l_poy33=null  LET l_poy34=null
    LET l_poy35=null  LET l_poy36=null
    IF g_oea.oea904 IS NOT NULL THEN
       SELECT poz02 INTO l_poz02 FROM poz_file WHERE poz01 = g_oea.oea904
       FOR i = 0 TO 6  #FUN-670007  從第0站開始
           SELECT poy03 INTO l_poy03 FROM poy_file
            WHERE poy01 = g_oea.oea904 AND poy02 = i
           IF STATUS THEN LET l_poy03 = '' END IF
           CASE i
              WHEN 1 LET l_poy31 = l_poy03
              WHEN 2 LET l_poy32 = l_poy03
              WHEN 3 LET l_poy33 = l_poy03
              WHEN 4 LET l_poy34 = l_poy03
              WHEN 5 LET l_poy35 = l_poy03
              WHEN 6 LET l_poy36 = l_poy03
           END CASE
       END FOR
    END IF
    DISPLAY l_poz02 TO FORMONLY.poz02
    DISPLAY l_poy31 TO FORMONLY.poy31
    DISPLAY l_poy32 TO FORMONLY.poy32
    DISPLAY l_poy33 TO FORMONLY.poy33
    DISPLAY l_poy34 TO FORMONLY.poy34
    DISPLAY l_poy35 TO FORMONLY.poy35
    DISPLAY l_poy36 TO FORMONLY.poy36

    #若已拋轉則不可更改資料
    IF NOT cl_chk_act_auth() OR g_oea.oea905='Y'  THEN
       DISPLAY BY NAME g_oea.oea901,g_oea.oea902,g_oea.oea904,
                       g_oea.oea911,g_oea.oea912,g_oea.oea913,g_oea.oea914,
                       g_oea.oea915,g_oea.oea916,g_oea.oea10,g_oea.oea903,
                       g_oea.oea905

        CALL t400_menu1( )   #TQC-7C0069 add

       CLOSE WINDOW t8103_w
       RETURN

    END IF

    INPUT BY NAME g_oea.oea901,g_oea.oea902,g_oea.oea904,
                  g_oea.oea911,g_oea.oea912,g_oea.oea913,g_oea.oea914,
                  g_oea.oea915,g_oea.oea916,g_oea.oea10,g_oea.oea903,
                  g_oea.oea905
          WITHOUT DEFAULTS

       BEFORE INPUT
          IF cl_null(g_oea.oea904) THEN
             SELECT poe04 INTO g_oea.oea904 FROM poe_file
              WHERE poe01 = g_oea.oea03
                AND poe02 = "*"
             IF STATUS THEN
                LET g_oea.oea904=""
             END IF
          END IF

       AFTER FIELD oea901
          IF NOT cl_null(g_oea.oea901) THEN
             IF g_oea.oea901 NOT MATCHES '[YN]' THEN
                NEXT FIELd oea901
             END IF
             IF g_oea.oea901 = 'N' THEN
                NEXT FIELD oea901
             END IF
          END IF

       AFTER FIELD oea902
          IF NOT cl_null(g_oea.oea902) THEN
             IF g_oea.oea902 NOT MATCHES '[YN]' THEN
                NEXT FIELd oea902
             END IF
          END IF

       AFTER FIELD oea904
          IF NOT cl_null(g_oea.oea904) THEN
             SELECT * INTO g_poz.* FROM poz_file
              WHERE poz01 = g_oea.oea904 AND pozacti = 'Y'
             IF STATUS THEN
                CALL cl_err3("sel","poz_file",g_oea.oea904,"","tri-006","","",1)  #No.FUN-650108
                NEXT FIELD oea904
             END IF
             IF g_poz.poz00 != '1' THEN
                CALL cl_err('','tri-008',1) NEXT FIELD oea904
             END IF
             SELECT poy04 INTO l_poy04
               FROM poy_file
              WHERE poy01 = g_poz.poz01
                AND poy02 = 0
             IF l_poy04 <> g_plant THEN
                CALL cl_err('','apm-012',1)
                 NEXT FIELD oea904   #MOD-570284
             END IF
             FOR i = 1 TO 6
                 SELECT poy03 INTO l_poy03 FROM poy_file
                  WHERE poy01 = g_oea.oea904 AND poy02 = i
                 IF STATUS THEN LET l_poy03 = '' END IF
                 CASE i
                   WHEN 1 LET l_poy31 = l_poy03
                   WHEN 2 LET l_poy32 = l_poy03
                   WHEN 3 LET l_poy33 = l_poy03
                   WHEN 4 LET l_poy34 = l_poy03
                   WHEN 5 LET l_poy35 = l_poy03
                   WHEN 6 LET l_poy36 = l_poy03
                END CASE
             END FOR

             DISPLAY g_poz.poz02 TO poz02
             DISPLAY l_poy31 TO poy31
             DISPLAY l_poy32 TO poy32
             DISPLAY l_poy33 TO poy33
             DISPLAY l_poy34 TO poy34
             DISPLAY l_poy35 TO poy35
             DISPLAY l_poy36 TO poy36
             SELECT poy20 INTO l_poy20
               FROM poy_file
              WHERE poy01 = g_poz.poz01
                AND poy02 = 0
             LET g_oea.oea903=l_poy20
             DISPLAY BY NAME g_oea.oea903
             LET g_oea.oea911 = l_poy31
             LET g_oea.oea912 = l_poy32
             LET g_oea.oea913 = l_poy33
             LET g_oea.oea914 = l_poy34
             LET g_oea.oea915 = l_poy35
             LET g_oea.oea916 = l_poy36
             DISPLAY BY NAME g_oea.oea911,g_oea.oea912,g_oea.oea913,
                             g_oea.oea914,g_oea.oea915,g_oea.oea916
          END IF

       AFTER FIELD oea903
          IF NOT cl_null(g_oea.oea903) THEN
             IF g_oea.oea903 NOT MATCHES '[123]' THEN
                NEXT FIELd oea903
             END IF
          END IF

       AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT
          END IF

# ---------------------------------------------
        ON ACTION controlp
           CASE WHEN INFIELD(oea904)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_poz1'   #FUN-5A0103
                LET g_qryparam.default1 = g_oea.oea904
                LET g_qryparam.arg1 = '1'
                CALL cl_create_qry() RETURNING g_oea.oea904
                DISPLAY BY NAME g_oea.oea904
                NEXT FIELD oea904
           END CASE

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

    IF INT_FLAG THEN
       LET INT_FLAG=0
       CLOSE WINDOW t8103_w
       RETURN
    END IF

    CLOSE WINDOW t8103_w

    UPDATE oea_file SET * = g_oea.* WHERE oea01 = g_oea.oea01
    IF SQLCA.SQLCODE THEN
       CALL cl_err3("upd","oea_file",g_oea.oea01,"",SQLCA.sqlcode,"","update oea",1)  #No.FUN-650108
       ROLLBACK WORK
    ELSE
       COMMIT WORK
    END IF

END FUNCTION

FUNCTION t400_menu1()
MENU ""
     ON ACTION locale
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()

     ON ACTION exit
        LET g_action_choice = "exit"
           EXIT MENU
     ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145
          #  LET g_action_choice = "exit"
            EXIT MENU

     ON IDLE g_idle_seconds
        CALL cl_on_idle()

     ON ACTION about
        CALL cl_about()

     ON ACTION help
        CALL cl_show_help()

     ON ACTION controlg
        CALL cl_cmdask()

END MENU
END FUNCTION

FUNCTION t400_m()
   IF g_oea.oea01 IS NULL THEN RETURN END IF

   IF NOT cl_chk_act_auth() THEN
      LET g_chr='d'
   ELSE
      LET g_chr='u'
   END IF
   CALL s_axm_memo(g_oea.oea01,0,g_chr)

END FUNCTION

FUNCTION t400_m1()
DEFINE l_cnt LIKE type_file.chr1
   IF s_shut(0) THEN RETURN END IF
   IF g_oea.oea01 IS NULL THEN RETURN END IF
   IF g_oea.oeaconf='Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_oea.oeaconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   IF g_oea.oea61 > 0 AND g_oea.oea61 = g_oea.oea62 THEN
      CALL cl_err('','axm-162',0)
      RETURN
   END IF
   IF g_oea.oea49 matches '[Ss]' THEN
      CALL cl_err('','apm-030',0)
      RETURN
   END IF
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM oeb_file
    WHERE oeb01=g_oea.oea01 AND oeb70='N'
   IF l_cnt=0 THEN CALL cl_err('','art-272',0) RETURN END IF
   LET g_rec_b2=0
   CALL t400_modify_price()
   CALL t400_bu()  #No.FUN-870007 bnlent add
END FUNCTION


FUNCTION t400_modify_price()
 DEFINE i LIKE type_file.num5
 DEFINE l_oeb DYNAMIC ARRAY OF RECORD
                 l_no       LIKE oeb_file.oeb03,
                 l_p_no     LIKE oeb_file.oeb04,
                 l_p_desc   LIKE oeb_file.oeb06,
                 oeb37_1    LIKE oeb_file.oeb37,     #FUN-B10010
                 l_price    LIKE oeb_file.oeb13,
                 l_price2   LIKE oeb_file.oeb13
              END RECORD
 DEFINE l_oeb_t1 RECORD
                    l_no       LIKE oeb_file.oeb03,
                    l_p_no     LIKE oeb_file.oeb04,
                    l_p_desc   LIKE oeb_file.oeb06,
                    oeb37_1    LIKE oeb_file.oeb37,     #FUN-B10010
                    l_price    LIKE oeb_file.oeb13,
                    l_price2   LIKE oeb_file.oeb13
                 END RECORD
#MOD-B30428---add---str------------------                
DEFINE b_oeb_tmp    RECORD
                    l_no       LIKE oeb_file.oeb03,
                    l_p_no     LIKE oeb_file.oeb04,
                    l_p_desc   LIKE oeb_file.oeb06,
                    oeb37_1    LIKE oeb_file.oeb37,      
                    l_price    LIKE oeb_file.oeb13,
                    l_price2   LIKE oeb_file.oeb13
                 END RECORD   
#MOD-B30428---add----end---------------                               
 DEFINE l_exit_sw  LIKE type_file.chr1
 DEFINE l_rth06    LIKE rth_file.rth06
 DEFINE l_rtg01    LIKE rtg_file.rtg01
 DEFINE l_rtg07    LIKE rtg_file.rtg07
 DEFINE l_rtg08    LIKE rtg_file.rtg08
 DEFINE l_cnt      LIKE type_file.num5
 DEFINE l_no_1     LIKE oeb_file.oeb03
 DEFINE l_price2_1 LIKE oeb_file.oeb13
 DEFINE p_cmd      LIKE type_file.chr1
 DEFINE l_account  LIKE oeb_file.oeb14
 DEFINE l_account1 LIKE oeb_file.oeb14t
 DEFINE l_oeb12    LIKE oeb_file.oeb12
 DEFINE l_oeb13    LIKE oeb_file.oeb13
 DEFINE l_occ930   LIKE occ_file.occ930
 DEFINE l_type     LIKE type_file.chr1
 DEFINE l_rxc      RECORD LIKE rxc_file.*  #FUN-AC0012
 DEFINE l_lock_sw  LIKE type_file.chr1     #MOD-B30428 

   WHENEVER ERROR CONTINUE

   OPEN WINDOW t410_a_w WITH FORM "axm/42f/axmt410_a"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale('axmt410_a')

   DROP TABLE oeb_tmp
   CREATE TEMP TABLE oeb_tmp
   (
    l_no      dec(5),   #LIKE type_file.num5,    #dec(5),
    l_price2  dec(20,6), #LIKE type_file.num20_6  #dec(20,6)
    l_p_no    varchar(40),  #MOD-B30428 add
    l_p_desc  varchar(120), #MOD-B30428 add
    oeb37_1   dec(20,6),     #MOD-B30428 add   
    l_price   dec(20,6)      #MOD-B30428 add 
    );

   WHILE TRUE
      #MOD-B30428-------add-----str------------------------------------------
      LET g_sql ="SELECT oeb03,oeb04,oeb06,oeb13,oeb37 FROM oeb_file ",
                 " WHERE oeb01 = '",g_oea.oea01,"'"
                 
      PREPARE oeb_tmp_prep FROM g_sql
      DECLARE oeb_tmp_cus CURSOR FOR oeb_tmp_prep
      LET g_cnt = 1
      FOREACH oeb_tmp_cus INTO b_oeb_tmp.l_no,b_oeb_tmp.l_p_no,
                                b_oeb_tmp.l_p_desc,b_oeb_tmp.l_price,
                                b_oeb_tmp.oeb37_1
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF   
        INSERT INTO oeb_tmp VALUES(b_oeb_tmp.l_no,0,b_oeb_tmp.l_p_no,b_oeb_tmp.l_p_desc,b_oeb_tmp.oeb37_1,b_oeb_tmp.l_price)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","oeb_tmp",g_oea.oea01,"",STATUS,"","",1)
        END IF
        LET g_cnt = g_cnt + 1
      END FOREACH
      
      LET g_sql = "SELECT l_no,l_p_no,l_p_desc,oeb37_1,l_price,l_price2 FROM oeb_tmp "
      PREPARE oeb_tmp_prep2 FROM g_sql
      DECLARE oeb_tmp_cus2 CURSOR FOR oeb_tmp_prep2
      CALL l_oeb.clear()
      LET g_rec_b = 0
      LET g_cnt = 1
      FOREACH oeb_tmp_cus2 INTO l_oeb[g_cnt].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	         EXIT FOREACH
        END IF
     END FOREACH
     CALL l_oeb.deleteElement(g_cnt)
     LET g_rec_b2=g_cnt - 1
    
   #  DISPLAY ARRAY l_oeb TO s_oeb_a.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)     
       
      
      
      LET g_sql = "SELECT l_no,l_p_no,l_p_desc,l_price,oeb37_1,l_price2 FROM oeb_tmp ",
                  "WHERE l_no =? AND l_p_no = ? "
      PREPARE oeb_tmp_prep1 FROM g_sql
      DECLARE oeb_tmp_cus1 CURSOR FOR oeb_tmp_prep1
      #MOD-B30428------add-------end------------------------------------------

      LET l_exit_sw = 'y'
      INPUT ARRAY l_oeb WITHOUT DEFAULTS FROM s_oeb_a.*
         ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED,
            #INSERT ROW=TRUE,DELETE ROW=TRUE,APPEND ROW=TRUE)     #MOD-B30428 mark
             INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)   #MOD-B30428 add
                
      BEFORE INPUT
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(i)
         END IF

      BEFORE ROW
         LET i=ARR_CURR()
         LET l_lock_sw = 'N'  #MOD-B30428 add
         CALL cl_set_comp_entry("l_no",FALSE)
         #MOD-B30428---mark----
         #IF g_rec_b2>=i THEN
         #   LET p_cmd ='u'
         #   LET l_oeb_t1.*= l_oeb[i].*
         #MOD-B30428---mark----   
            BEGIN WORK
               #MOD-B30428----add-----str------------
               IF g_rec_b2 >= i THEN
               LET p_cmd='u'
               LET l_oeb_t1.*= l_oeb[i].*
               OPEN oeb_tmp_cus1 USING l_oeb_t1.l_no, l_oeb_t1.l_p_no
               IF STATUS THEN
                  CALL cl_err("OPEN oeb_tmp_cus1", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                    FETCH oeb_tmp_cus1 INTO b_oeb_tmp.*
                    IF SQLCA.sqlcode THEN
                       CALL cl_err(l_oeb_t1.l_no,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                    END IF
               END IF
               #MOD-B30428---add------end----------------- 
            CALL cl_show_fld_cont()
         END IF

#MOD-B30428---mark--------         
#      BEFORE INSERT
#         LET p_cmd='a'
#         INITIALIZE l_oeb_t1.* TO NULL
#         CALL cl_show_fld_cont()


#      AFTER FIELD l_no
#         IF NOT cl_null(l_oeb[i].l_no) THEN
#            IF l_oeb[i].l_no<=0  THEN
#               CALL cl_err('','aec-994',0)
#               NEXT FIELD l_no
#            ELSE
#               LET l_cnt=0
#               SELECT COUNT(*) INTO l_cnt FROM oeb_file
#                WHERE oeb01=g_oea.oea01 AND oeb03=l_oeb[i].l_no AND oeb70='N'
#               IF l_cnt=0 THEN
#                  CALL cl_err('','art-267',0)
#                  NEXT FIELD l_no
#               END IF
#            END IF
#            IF l_oeb[i].l_no !=l_oeb_t1.l_no OR l_oeb_t1.l_no IS NULL THEN
#               LET l_cnt=0
#               SELECT COUNT(*) INTO l_cnt FROM oeb_tmp
#                WHERE l_no=l_oeb[i].l_no
#               IF l_cnt > 0 THEN
#                  CALL cl_err('',-239,0)
#                  LET l_oeb[i].l_no=l_oeb_t1.l_no
#                  NEXT FIELD l_no
#               END IF
#            END IF
#         END IF
#         SELECT oeb04,oeb06,oeb13,oeb37                           #FUN-B10010
#           INTO l_oeb[i].l_p_no,l_oeb[i].l_p_desc,l_oeb[i].l_price,l_oeb[i].oeb37_1 #FUN-B10010
#          FROM oeb_file
#          WHERE oeb01=g_oea.oea01 AND oeb03=l_oeb[i].l_no
#         IF SQLCA.sqlcode=100 THEN
#            LET l_oeb[i].l_p_no=NULL
#            LET l_oeb[i].l_p_desc=NULL
#            LET l_oeb[i].l_price=NULL
#            LET l_oeb[i].oeb37_1 = NULL      #FUN-B10010
#         END IF
#MOD-B30428---mark--------         
         
      AFTER FIELD l_price2
         IF NOT cl_null(l_oeb[i].l_price2) THEN
           #MOD-B30428-----mark------
           #IF l_oeb[i].l_price2<=0  THEN
           #   CALL cl_err('','art-180',0)
           #   NEXT FIELD l_price2
           #END IF
           #MOD-B30428---mark--------
            SELECT rtz05 INTO l_rtg01 FROM rtz_file
             WHERE rtz01 = g_plant
            SELECT rtg07,rtg08 INTO l_rtg07,l_rtg08
              FROM rtg_file,rtf_file    #FUN-A60035 add rtf_file
             WHERE rtg01 = rtf01 AND rtfconf='Y'
               AND rtg01 = l_rtg01
               AND rtg03 = l_oeb[i].l_p_no
               AND rtg04 = (SELECT oeb05 FROM oeb_file
                             WHERE oeb01=g_oea.oea01 AND oeb03=l_oeb[i].l_no)
            IF l_rtg08 = 'Y' THEN
               SELECT rth06
                 INTO l_rth06
                 FROM rth_file
                WHERE rth01=l_oeb[i].l_p_no AND rth02=(SELECT oeb05 FROM oeb_file
                                                        WHERE oeb01=g_oea.oea01 AND oeb03=l_oeb[i].l_no)
                  AND rthplant=g_oea.oeaplant
               IF SQLCA.sqlcode=100 THEN
                  CALL cl_err('','art-273',0)
                  NEXT FIELD l_price2
               END IF
               IF l_oeb[i].l_price2<l_rth06 THEN
                  CALL cl_err('','art-300',0)
                  NEXT FIELD l_price2
               END IF
            ELSE
               IF l_oeb[i].l_price2<l_rtg07 THEN
                  CALL cl_err('','art-268',0)
                  NEXT FIELD l_price2
               END IF
            END IF
            IF l_oeb[i].l_price2=l_oeb[i].l_price THEN
               CALL cl_err('','art-269',0)
               NEXT FIELD l_price2
            END IF
         END IF
#MOD-B30428---mark--------
#      BEFORE DELETE
#         IF l_oeb_t1.l_no>0 AND l_oeb_t1.l_no IS NOT NULL THEN
#            IF NOT cl_delb(0,0) THEN
#               CANCEL DELETE
#            END IF
#            DELETE FROM oeb_tmp WHERE l_no = l_oeb_t1.l_no
#            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#               CALL cl_err3("del","oeb_tmp",g_oea.oea01,"",STATUS,"","",1)
#               ROLLBACK WORK
#               CANCEL DELETE
#            END IF
#            LET g_rec_b2=g_rec_b2-1
#         END IF
#         COMMIT WORK
#MOD-B30428---mark--------         
         
         
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG=0
            LET l_oeb[i].*=l_oeb_t1.*
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(l_oeb[i].l_no,-263,1)
            LET l_oeb[i].* = l_oeb_t1.*
         ELSE 
            LET b_oeb_tmp.l_price2 = l_oeb[i].l_price2    #MOD-B30428 add
            IF l_oeb[i].l_price2 != 0 AND l_oeb[i].l_price2 != l_oeb[i].l_price THEN   #MOD-B30428 add
            
            #MOD-B30428---mod-------str----------------- 
            #UPDATE oeb_tmp SET l_no = l_oeb[i].l_no,
            #               l_price2 = l_oeb[i].l_price2
            # WHERE l_no = l_oeb_t1.l_no AND l_price2=l_oeb_t1.l_price2
               UPDATE oeb_tmp SET l_price2 = b_oeb_tmp.l_price2
                            WHERE l_no     = l_oeb[i].l_no  
            #MOD-B30428---mod-------end------------------ 
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                 CALL cl_err3("upd","oeb_tmp",g_oea.oea01,"",STATUS,"","",1)
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF   #MOD-B30428 
         END IF   #MOD-B30428
#MOD-B30428---mark--------
#     AFTER INSERT
#        IF INT_FLAG THEN
#           CALL cl_err('',9001,0)
#           LET INT_FLAG = 0
#           CANCEL INSERT
#        END IF
#        INSERT INTO oeb_tmp VALUES(l_oeb[i].l_no,l_oeb[i].l_price2)
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("ins","oeb_tmp",g_oea.oea01,"",STATUS,"","",1)
#           CANCEL INSERT
#        ELSE
#           MESSAGE 'INSERT O.K'
#           COMMIT WORK
#           LET g_rec_b2=g_rec_b2+1
#        END IF
#MOD-B30428---mark--------

     AFTER ROW
        LET i = ARR_CURR()
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET l_oeb[i].*=l_oeb_t1.*
           END IF
           ROLLBACK WORK
           EXIT INPUT
        END IF
        COMMIT WORK
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT

     END INPUT
     IF l_exit_sw='y' THEN EXIT WHILE ELSE CONTINUE WHILE END IF
  END WHILE

  CLOSE WINDOW t410_a_w

  IF INT_FLAG THEN
     LET INT_FLAG = 0
     RETURN
  END IF

 #FUN-AC0012 Begin---
  BEGIN WORK
  LET g_success = 'Y'
 #FUN-AC0012 End-----

  LET g_sql="SELECT * FROM oeb_tmp ORDER BY l_no "
  PREPARE sele_prep FROM g_sql
  DECLARE sele_decl CURSOR FOR sele_prep
  FOREACH sele_decl INTO l_no_1,l_price2_1
     
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)
        EXIT FOREACH
     #MOD-B30428---add----str------------   
     ELSE
     	  IF l_price2_1 = 0 THEN 
           CONTINUE FOREACH
        END IF  
     #MOD-B30428---add-----end--------   
     END IF
     
     CALL cl_digcut(l_price2_1,t_azi03) RETURNING l_price2_1
     SELECT oeb12,oeb13 INTO l_oeb12,l_oeb13 FROM oeb_file
      WHERE oeb01=g_oea.oea01 AND oeb03=l_no_1
     IF g_oea.oea213 = 'N' THEN
        LET l_account= l_oeb12* l_price2_1
        CALL cl_digcut(l_account,t_azi04)  RETURNING l_account
        LET l_account1= l_account*(1+ g_oea.oea211/100)
        CALL cl_digcut(l_account1,t_azi04) RETURNING l_account1
     ELSE
        LET l_account1= l_oeb12*l_price2_1
        CALL cl_digcut(l_account1,t_azi04) RETURNING l_account1
        LET l_account = l_account1/(1+ g_oea.oea211/100)
        CALL cl_digcut(l_account,t_azi04)  RETURNING l_account
     END IF

    #FUN-AC0012 Begin---
     IF g_azw.azw04='2' THEN #FUN-B10014
     INITIALIZE l_rxc.* TO NULL
     LET l_rxc.rxc06 = (l_oeb13-l_price2_1)*l_oeb12
     LET g_cnt = 0
     SELECT COUNT(*) INTO g_cnt FROM rxc_file
      WHERE rxc00 = '01'
        AND rxc01 = g_oea.oea01
        AND rxc02 = l_no_1
        AND rxc03 = '13'
        AND rxc04 = ' '
     IF g_cnt = 0 THEN
        LET l_rxc.rxc00 = '01'
        LET l_rxc.rxc01 = g_oea.oea01
        LET l_rxc.rxc02 = l_no_1
        LET l_rxc.rxc03 = '13'
        LET l_rxc.rxc04 = ' '
        LET l_rxc.rxc05 = ' '
        LET l_rxc.rxc08 = ' '
        LET l_rxc.rxc09 = 0
        LET l_rxc.rxc10 = 0
        IF NOT cl_null(g_oea.oea87) THEN
           LET g_cnt = 0
           SELECT COUNT(*) INTO g_cnt FROM lpj_file,lpk_file
            WHERE lpj01=lpk01
              AND lpj03=g_oea.oea87
           IF g_cnt > 0 THEN
              LET l_rxc.rxc11 = 'Y'
           ELSE
              LET l_rxc.rxc11 = 'N'
           END IF
        ELSE
           LET l_rxc.rxc11 = 'N'
        END IF
        LET l_rxc.rxc15 = l_oeb12
        LET l_rxc.rxcplant = g_oea.oeaplant
        LET l_rxc.rxclegal = g_oea.oealegal
        INSERT INTO rxc_file VALUES (l_rxc.*)
     ELSE
        UPDATE rxc_file SET rxc06 = rxc06 + l_rxc.rxc06
         WHERE rxc00 = '01'
           AND rxc01 = g_oea.oea01
           AND rxc02 = l_no_1
           AND rxc03 = '13'
           AND rxc04 = ' '
     END IF
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("ins","rxc_file",g_oea.oea01,l_no_1,SQLCA.sqlcode,"","",1)
        LET g_success = 'N'
     END IF
     SELECT SUM(rxc06) INTO l_rxc.rxc06 FROM rxc_file
      WHERE rxc00 = '01'
        AND rxc01 = g_oea.oea01
        AND rxc02 = l_no_1
     END IF  #FUN-B10014
     IF cl_null(l_rxc.rxc06) THEN LET l_rxc.rxc06 = 0 END IF
    #FUN-AC0012 End-----
     
     UPDATE oeb_file SET oeb13=l_price2_1,
                         oeb47=l_rxc.rxc06, #FUN-AC0012
                         oeb14=l_account,
                         oeb14t=l_account1
      WHERE oeb01=g_oea.oea01 AND oeb03=l_no_1
    #FUN-AC0012 Begin---
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("ins","oeb_file",g_oea.oea01,l_no_1,SQLCA.sqlcode,"","",1)
        LET g_success = 'N'
     END IF
    #FUN-AC0012 End-----

     LET l_no_1=''
     LET l_price2_1=''
  END FOREACH
 #FUN-AC0012 Begin---
  IF g_success = 'Y' THEN
     COMMIT WORK
  ELSE
     ROLLBACK WORK
  END IF
 #FUN-AC0012 End-----
END FUNCTION

FUNCTION t400_m2()
DEFINE l_cnt LIKE type_file.chr1
   IF s_shut(0) THEN RETURN END IF
   IF g_oea.oea01 IS NULL THEN RETURN END IF
   IF g_oea.oeaconf='Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_oea.oeaconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   IF g_oea.oea61 > 0 AND g_oea.oea61 = g_oea.oea62 THEN
      CALL cl_err('','axm-162',0)
      RETURN
   END IF
   IF g_oea.oea49 matches '[Ss]' THEN
      CALL cl_err('','apm-030',0)
      RETURN
   END IF
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM oeb_file
    WHERE oeb01=g_oea.oea01 AND oeb70='N'
   IF l_cnt=0 THEN CALL cl_err('','art-272',0) RETURN END IF
   LET g_rec_b3=0
   CALL t400_modify_rate()
END FUNCTION

FUNCTION t400_modify_rate()
DEFINE i  LIKE type_file.num5
DEFINE l_oeb_b    DYNAMIC ARRAY OF RECORD
                   l_no         LIKE oeb_file.oeb03,
                   l_p_no       LIKE oeb_file.oeb04,
                   l_p_desc     LIKE oeb_file.oeb06,
                   l_koulv      LIKE oeb_file.oeb46,
                   l_koulv2     LIKE oeb_file.oeb46
                END RECORD
DEFINE l_oeb_t2 RECORD
                   l_no       LIKE oeb_file.oeb03,
                   l_p_no     LIKE oeb_file.oeb04,
                   l_p_desc   LIKE oeb_file.oeb06,
                   l_koulv    LIKE oeb_file.oeb46,
                   l_koulv2   LIKE oeb_file.oeb46
                END RECORD
DEFINE l_exit_sw     LIKE type_file.chr1
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_no_b        LIKE oeb_file.oeb03
DEFINE l_koulv2_b    LIKE oeb_file.oeb46
DEFINE p_cmd         LIKE type_file.chr1
DEFINE l_oeb44       LIKE oeb_file.oeb44

   WHENEVER ERROR CONTINUE

   OPEN WINDOW t410_b_w WITH FORM "axm/42f/axmt410_b"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale('axmt410_b')

   DROP TABLE oeb_b_tmp
   CREATE TEMP TABLE oeb_b_tmp
   (
    l_no       dec(5),   #LIKE type_file.num5    #dec(5),
    l_koulv2   dec(5,2)  #LIKE oeb_file.oeb46    #dec(5,2)
    );

 WHILE TRUE
  LET l_exit_sw = 'y'
   INPUT ARRAY l_oeb_b WITHOUT DEFAULTS FROM s_oeb_b.*
          ATTRIBUTE(COUNT=g_rec_b3,UNBUFFERED,
                    INSERT ROW=TRUE,DELETE ROW=TRUE,APPEND ROW=TRUE)

     BEFORE INPUT
        IF g_rec_b3 != 0 THEN
           CALL fgl_set_arr_curr(i)
        END IF

     BEFORE ROW
        LET i=ARR_CURR()
        IF g_rec_b3>=i THEN
           LET p_cmd='u'
           LET l_oeb_t2.*=l_oeb_b[i].*
           BEGIN WORK
           CALL cl_show_fld_cont()
        END IF
     BEFORE INSERT
        LET p_cmd='a'
        INITIALIZE l_oeb_t2.* TO NULL
        CALL cl_show_fld_cont()

     AFTER FIELD l_no
        IF NOT cl_null(l_oeb_b[i].l_no) THEN
           IF l_oeb_b[i].l_no<=0  THEN
              NEXT FIELD l_no
           ELSE
              LET l_cnt=0
             SELECT COUNT(*) INTO l_cnt FROM oeb_file
               WHERE oeb01=g_oea.oea01 AND oeb03=l_oeb_b[i].l_no AND oeb70='N'
              IF l_cnt=0 THEN
                 CALL cl_err('','art-267',0)
                 NEXT FIELD l_no
              END IF
              LET l_oeb44=''
              SELECT oeb44 INTO l_oeb44 FROM oeb_file
               WHERE oeb01=g_oea.oea01 AND oeb03=l_oeb_b[i].l_no
             #IF l_oeb44 !='3' OR l_oeb44 != '4' THEN   #mark by cockroach 100715
              IF l_oeb44 NOT MATCHES '[34]' THEN        #add  FUN-A60035
                 CALL cl_err('','art-439',0)
                 NEXT FIELD l_no
              END IF
           END IF
           IF l_oeb_b[i].l_no !=l_oeb_t2.l_no OR l_oeb_t2.l_no IS NULL THEN
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM oeb_b_tmp
                WHERE l_no=l_oeb_b[i].l_no
               IF l_cnt > 0 THEN
                  CALL cl_err('',-239,0)
                  LET l_oeb_b[i].l_no=l_oeb_t2.l_no
                  NEXT FIELD l_no
               END IF
            END IF
         END IF
         SELECT oeb04,oeb06,oeb46
           INTO l_oeb_b[i].l_p_no,l_oeb_b[i].l_p_desc,l_oeb_b[i].l_koulv
          FROM oeb_file
          WHERE oeb01=g_oea.oea01 AND oeb03=l_oeb_b[i].l_no
         IF SQLCA.sqlcode=100 THEN
            LET l_oeb_b[i].l_p_no=NULL
            LET l_oeb_b[i].l_p_desc=NULL
            LET l_oeb_b[i].l_koulv=NULL
         END IF
   AFTER FIELD l_koulv2
      IF NOT cl_null(l_oeb_b[i].l_koulv2) THEN
         IF l_oeb_b[i].l_koulv2<=0 OR
            l_oeb_b[i].l_koulv2>=100  THEN
            CALL cl_err('','atm-070',0)
            NEXT FIELD l_koulv2
         END IF
         IF l_oeb_b[i].l_koulv2=l_oeb_b[i].l_koulv THEN
            CALL cl_err('','art-270',0)
            NEXT FIELD l_koulv2
         END IF
      END IF
    BEFORE DELETE
         IF l_oeb_t2.l_no>0 AND l_oeb_t2.l_no IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            DELETE FROM oeb_b_tmp WHERE l_no = l_oeb_t2.l_no
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err3("del","oeb_b_tmp",g_oea.oea01,"",STATUS,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b3=g_rec_b3-1
         END IF
         COMMIT WORK
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG=0
            LET l_oeb_b[i].*=l_oeb_t2.*
            ROLLBACK WORK
            EXIT INPUT
         END IF
         UPDATE oeb_b_tmp SET l_no = l_oeb_b[i].l_no,
                            l_koulv2= l_oeb_b[i].l_koulv2
          WHERE l_no = l_oeb_t2.l_no AND l_koulv2=l_oeb_t2.l_koulv2
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","oeb_b_tmp",g_oea.oea01,"",STATUS,"","",1)
         ELSE
            MESSAGE 'UPDATE O.K'
            COMMIT WORK
         END IF
    AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CANCEL INSERT
        END IF
        INSERT INTO oeb_b_tmp VALUES(l_oeb_b[i].l_no,l_oeb_b[i].l_koulv2)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","oeb_b_tmp",g_oea.oea01,"",STATUS,"","",1)
           CANCEL INSERT
        ELSE
           MESSAGE 'INSERT O.K'
           COMMIT WORK
           LET g_rec_b3=g_rec_b3+1
        END IF


      AFTER ROW
            LET i = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET l_oeb_b[i].*=l_oeb_t2.*
               END IF
               ROLLBACK WORK
               EXIT INPUT
            END IF
            COMMIT WORK

     ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT

   END INPUT

  IF l_exit_sw='y' THEN EXIT WHILE ELSE CONTINUE WHILE END IF
  END WHILE

   CLOSE WINDOW t410_b_w
  IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
  LET g_sql="SELECT * FROM oeb_b_tmp ORDER BY l_no "
  PREPARE sele_prep1 FROM g_sql
  DECLARE sele_decl1 CURSOR FOR sele_prep1
  FOREACH sele_decl1 INTO l_no_b,l_koulv2_b
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
     UPDATE oeb_file SET oeb46=l_koulv2_b WHERE oeb01=g_oea.oea01 AND oeb03=l_no_b
     LET l_no_b=''
     LET l_koulv2_b=''
  END FOREACH

END FUNCTION

FUNCTION t400_z()   #when g_oea.oeaconf='Y' (Turn to 'N')
  DEFINE l_pmk01 LIKE pmk_file.pmk01
  DEFINE li_cnt  LIKE type_file.num5    #TQC-730022
  DEFINE l_zz01  LIKE zz_file.zz01      #TQC-730022
  DEFINE l_buf1  LIKE oay_file.oayslip  #TQC-730022

  #CHI-A50004 程式搬移 --start--
   BEGIN WORK
   OPEN t400_cl USING g_oea.oea01      #mod by liuxqa 091020
   IF STATUS THEN
      CALL cl_err("OPEN t400_cl:", STATUS, 1)
      CLOSE t400_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t400_cl INTO g_oea.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t400_cl ROLLBACK WORK RETURN
   END IF
  #CHI-A50004 程式搬移 --end--

    IF g_oea.oea49 = 'S' THEN
       CALL cl_err(g_oea.oea49,'apm-030',1)
       ROLLBACK WORK #CHI-A50004 add 
       RETURN
    END IF

#在取消確認之前要先check多角拋轉還原否(如果oax07 = 'Y'時)
    IF g_oea.oea901 = 'Y' AND g_success = 'Y' THEN
        IF g_oax.oax07 = 'Y' THEN
            IF g_oea.oea99 IS NOT NULL OR g_oea.oea99 <> '' THEN
                CALL cl_err('','axm-316',0)  #TQC-7C0011
                ROLLBACK WORK #CHI-A50004 add
                RETURN
            END IF
        END IF
    END IF

    SELECT * INTO g_oea.* FROM oea_file WHERE oea01 = g_oea.oea01   #mod by liuxqa 091020
    IF g_oea.oeaconf = 'N' THEN ROLLBACK WORK RETURN END IF #CHI-A50004 add ROLLBACK WORK
    IF g_oea.oeaconf = 'X' THEN CALL cl_err('',9024,0) ROLLBACK WORK RETURN END IF #CHI-A50004 add ROLLBACK WORK
    IF g_oea.oea62 != 0 THEN CALL cl_err('','axm-162',0) ROLLBACK WORK RETURN END IF #CHI-A50004 add ROLLBACK WORK
    IF g_oea.oea901='Y' AND  g_oea.oea905='Y' THEN
       CALL cl_err('','axm-316',0)
       ROLLBACK WORK #CHI-A50004 add
       RETURN
    END IF

#No.FUN-A50071 ----start------
    #-->POS拋轉時，不可取消確認
    IF g_oea.oea11 = '9' THEN
       CALL cl_err('','axm-745',0)
    END IF 
#No.FUN-A50071 -------end------

    #====>此訂單在"工單維護作業asfi301"已有資料,不可取消確認!
    SELECT COUNT(*) INTO g_cnt FROM sfb_file
     WHERE sfb22 = g_oea.oea01
       AND sfb87 != 'X'
    IF g_cnt >0 THEN
        CALL cl_err(g_oea.oea01,'axm-016',0)
        ROLLBACK WORK #CHI-A50004 add
        RETURN
    END IF

    #此訂單已拋請購單,就不可以取消確認
    SELECT pmk01 INTO l_pmk01
      FROM pmk_file,oea_file
     WHERE oea01 = g_oea.oea01
       AND pmk01 = oea40
       AND pmk18 != 'X' #作廢
    IF NOT cl_null(l_pmk01) THEN
        CALL cl_err('','axm-001',0)
        ROLLBACK WORK #CHI-A50004 add
        RETURN
    END IF

    #此訂單已拋採購單,就不可以取消確認
    SELECT COUNT(*) INTO li_cnt
      FROM pmn_file,pmm_file
     WHERE pmn24 = g_oea.oea01      #FUN-740046
       AND pmm01 = pmn01
       AND pmm18 != 'X' #作廢
    IF li_cnt > 0 THEN
        CALL cl_err('','axm-581',0)
        ROLLBACK WORK #CHI-A50004 add
        RETURN
    END IF

    #MOD-B30440 add --start--
    #已產生至一般訂單的合約訂單,就不可以取消確認
    SELECT COUNT(*) INTO g_cnt
      FROM oea_file
     WHERE oea11 = '3' 
       AND oea12 = g_oea.oea01
       AND oeaconf <> 'X' #作廢
    IF g_cnt > 0 THEN
        CALL cl_err('','axm-346',0)
        ROLLBACK WORK
        RETURN
    END IF
    #MOD-B30440 add --end--

   #流程自動化判斷是否已產生下游單據，如已產生，則不可取消確認
    LET l_buf1 = s_get_doc_no(g_oea.oea01)
    SELECT gfa03 INTO l_zz01 FROM gfa_file
     WHERE gfa01 = '1'
       AND gfa02 = l_buf1
       AND gfaacti = 'Y'
    IF NOT cl_null(l_zz01) THEN
       LET li_cnt = 0
       CASE l_zz01
         WHEN "apmt420"
           SELECT COUNT(*) INTO li_cnt
             FROM pmk_file,oea_file
            WHERE oea01 = g_oea.oea01
              AND pmk01 = oea40
              AND pmk18 != 'X' #作廢
            IF li_cnt > 0 THEN
                CALL cl_err('','axm-001',0)
                ROLLBACK WORK #CHI-A50004 add
                RETURN
            END IF
         WHEN "apmt540"
            SELECT COUNT(*) INTO li_cnt
              FROM pmn_file,pmm_file
             WHERE pmn24 = g_oea.oea01   #FUN-740046
               AND pmm01 = pmn01
               AND pmm18 != 'X' #作廢
            IF li_cnt > 0 THEN
                CALL cl_err('','axm-581',0)
                ROLLBACK WORK #CHI-A50004 add
                RETURN
            END IF
         WHEN "asfi301"
            SELECT COUNT(*) INTO li_cnt
              FROM sfb_file
             WHERE sfb22 = g_oea.oea01
               AND sfb87 != 'X' #作廢
            IF li_cnt > 0 THEN
                CALL cl_err('','axm-583',0)
                ROLLBACK WORK #CHI-A50004 add
                RETURN
            END IF

         WHEN "axmt610"
            SELECT COUNT(*) INTO li_cnt
              FROM oga_file,ogb_file
             WHERE oga01 = ogb01
               AND ogb31 = g_oea.oea01
               AND (oga09 = '1' OR oga09 = '5')  #出通單
               AND ogaconf != 'X' #作廢
            IF li_cnt > 0 THEN
                CALL cl_err('','axm-584',0)
                ROLLBACK WORK #CHI-A50004 add
                RETURN
            END IF
         WHEN "axmt620"
            SELECT COUNT(*) INTO li_cnt
              FROM oga_file,ogb_file
             WHERE oga01 = ogb01
               AND ogb31 = g_oea.oea01
               AND oga09 IN ('2','3','4','6')  #出貨單
               AND ogaconf != 'X' #作廢
            IF li_cnt > 0 THEN
                CALL cl_err('','axm-585',0)
                ROLLBACK WORK #CHI-A50004 add
                RETURN
            END IF
       END CASE
    END IF

    SELECT COUNT(*) INTO g_cnt FROM oeb_file
     WHERE oeb01=g_oea.oea01
       AND oeb70='Y'
    IF g_cnt>0 THEN
       CALL cl_err('','aap-730',0)
       ROLLBACK WORK #CHI-A50004 add
       RETURN
    END IF

   SELECT COUNT(*) INTO g_cnt FROM oga_file,ogb_file
    WHERE oga01 = ogb01
      AND ogb31 = g_oea.oea01
      AND ogaconf <> 'X'
   IF g_cnt > 0 THEN
      CALL cl_err('','axm-407',0)
      ROLLBACK WORK #CHI-A50004 add
      RETURN
   END IF

   SELECT COUNT(*) INTO g_cnt FROM oga_file
    WHERE oga16 = g_oea.oea01
      AND ogaconf <> 'X'
   IF g_cnt > 0 THEN
      CALL cl_err('','axm-407',0)
      ROLLBACK WORK #CHI-A50004 add
      RETURN
   END IF

   SELECT COUNT(*) INTO g_cnt FROM oma_file WHERE oma16=g_oea.oea01
                                              AND omavoid <> 'Y' #MOD-840077 排除已作廢單據
   IF g_cnt>0 THEN CALL cl_err(g_oea.oea01,'axm-512',0) ROLLBACK WORK RETURN END IF #CHI-A50004 add
   SELECT COUNT(*) INTO g_cnt FROM oep_file
    WHERE oep01 = g_oea.oea01
   IF g_cnt > 0 THEN
      CALL cl_err('','axm-800',0)
      ROLLBACK WORK #CHI-A50004 add
      RETURN
   END IF
   IF NOT cl_confirm('axm-109') THEN ROLLBACK WORK RETURN END IF #CHI-A50004 add ROLLBACK WORK

  #CHI-A50004 程式搬移至FUNCTION一開始 mark --start--
  #BEGIN WORK
  #OPEN t400_cl USING g_oea.oea01      #mod by liuxqa 091020
  #IF STATUS THEN
  #   CALL cl_err("OPEN t400_cl:", STATUS, 1)
  #   CLOSE t400_cl
  #   ROLLBACK WORK
  #   RETURN
  #END IF
  #
  #FETCH t400_cl INTO g_oea.*          # 鎖住將被更改或取消的資料
  #IF SQLCA.sqlcode THEN
  #   CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)     # 資料被他人LOCK
  #   CLOSE t400_cl ROLLBACK WORK RETURN
  #END IF
  #CHI-A50004 程式搬移至FUNCTION一開始 mark --end--

   LET g_success = 'Y'

   IF g_aza.aza50 = 'Y' THEN  #No.FUN-650108 #FUN-6C0006
      CALL t400sub_tqw08_update(2,g_oea.*)       #FUN-610055
   END IF  #No.FUN-650108

   DELETE FROM azd_file WHERE azd01=g_oea.oea01 AND azd02=25

   LET g_oea.oea49='0'

   CALL t400_z1()
   IF g_success = 'Y' THEN
      LET g_oea.oeaconf='N'
      COMMIT WORK
      DISPLAY BY NAME g_oea.oeaconf,g_oea.oea49

      SELECT oea49 INTO g_oea.oea49 FROM oea_file
       WHERE oea01 = g_oea.oea01
      DISPLAY BY NAME g_oea.oea49
     IF g_azw.azw04='2' THEN
         LET g_oea.oea72=''
         LET g_oea.oeaconu=''
         LET g_oea.oeacont=''
         DISPLAY BY NAME g_oea.oea72,g_oea.oeaconu,g_oea.oeacont
      END IF
   ELSE
      LET g_oea.oeaconf='Y'
      LET g_oea.oea49='1'
      ROLLBACK WORK
   END IF

   SELECT * INTO g_oea.* FROM oea_file WHERE oea01=g_oea.oea01
END FUNCTION

FUNCTION t400_z1()
   DEFINE l_cmd LIKE type_file.chr1000  #NO.FUN-670007  #No.FUN-680137 VARCHAR(80)
   DEFINE l_oea61   LIKE oea_file.oea61   #No.FUN-740016
   DEFINE l_oea14   LIKE oea_file.oea14   #No.FUN-740016
   DEFINE l_ocn03   LIKE ocn_file.ocn03   #No.FUN-740016
   DEFINE l_ocn04   LIKE ocn_file.ocn04   #No.FUN-740016

   SELECT oea61*oea24,oea14 INTO l_oea61,l_oea14 FROM oea_file
    WHERE oea01=g_oea.oea01

   CALL cl_digcut(l_oea61,g_azi04) RETURNING l_oea61     #CHI-7A0036-add

   SELECT ocn03,ocn04 INTO l_ocn03,l_ocn04 FROM ocn_file
    WHERE ocn01 = l_oea14

   LET l_ocn03 = l_ocn03-l_oea61
   LET l_ocn04 = l_ocn04+l_oea61

   UPDATE ocn_file SET ocn03 = l_ocn03,
                       ocn04 = l_ocn04
    WHERE ocn01 = l_oea14

   UPDATE oea_file SET oeaconf='N',oea49='0',oeasseq=0,
                       oea72=NULL,oeaconu=NULL,oeacont=NULL    #No.FUN-870007
    WHERE oea01 = g_oea.oea01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","oea_file",g_oea.oea01,"",SQLCA.sqlcode,"","upd oea49",1)  #No.FUN-650108
      LET g_success = 'N' RETURN
   ELSE
  #MOD-A50009---mark---start---
  #...將簽核資料還原
  #   IF g_oea.oeamksg MATCHES '[Yy]'  THEN
  #      LET g_oea.oeasseq = 0
  #      DELETE FROM azd_file WHERE azd01 = g_oea.oea01 AND azd02 = 25
  #      IF STATUS  THEN LET g_success = 'N' RETURN
  #      ELSE
  #         CALL s_signx1(6,34,g_lang,'2',g_oea.oea01,25,g_oea.oeasign,
  #              g_oea.oeadays,g_oea.oeaprit,g_oea.oeasmax,g_oea.oeasseq)
  #      END IF
  #   END IF
  #MOD-A50009---mark---end---
   END IF

   DECLARE t400_z1_c CURSOR FOR SELECT * FROM oeb_file
                                 WHERE oeb01 = g_oea.oea01
                                 ORDER BY oeb03

   CALL s_showmsg_init()    #MOD-820174 add

   FOREACH t400_z1_c INTO b_oeb.*
      IF STATUS THEN
         CALL s_errmsg('','',"z1 foreach",SQLCA.sqlcode,1)  #No.FUN-710046
         LET g_success = 'N'
         RETURN
      END IF
     IF g_success = "N" THEN
        LET g_totsuccess = "N"
        LET g_success = "Y"
     END IF

         IF b_oeb.oeb920 > 0 THEN  #No.FUN-650108
            CALL s_errmsg('','','',"axm-036",1) #No.FUN-710046
            LET g_success = "N"
            CONTINUE FOREACH      #No.FUN-710046
         END IF

      CALL t400sub_bu1(g_oea.*,b_oeb.*) #更新合約已轉訂單量

      IF g_success = 'N' THEN
         RETURN
      END IF
   END FOREACH

      CALL s_showmsg()   #MOD-820174 add

     IF g_totsuccess="N" THEN
        LET g_success="N"
     END IF
#如oax07設定為Y，在取消確認時，則要自動執行多角拋轉還原的動作
   IF g_oea.oea905 = 'Y' AND g_success = 'Y' THEN   				#MOD-960187
       IF (g_oea.oea99 IS NULL OR g_oea.oea99 = '' ) AND g_oax.oax07 = 'Y' THEN
           LET l_cmd="axmp810 '",g_oea.oea01,"' "
           CALL cl_cmdrun_wait(l_cmd)
       END IF
   END IF


END FUNCTION

# 新增作廢/作廢還原功能
FUNCTION t400_x()
   DEFINE l_oeb70   LIKE oeb_file.oeb70,
          l_oeb70d  LIKE oeb_file.oeb70d,
          l_oqaconf LIKE oqa_file.oqaconf,
          l_oqtconf LIKE oqt_file.oqtconf
   DEFINE l_cnt     LIKE type_file.num5   #CHI-6A0054

   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_oea.* FROM oea_file WHERE oea01=g_oea.oea01
   IF g_oea.oea01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_oea.oeaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_oea.oea49 matches '[Ss1]' THEN          #MOD-4A0299
      CALL cl_err("","mfg3557",0)
      RETURN
   END IF

   LET g_success = 'Y'

   BEGIN WORK
   OPEN t400_cl USING g_oea.oea01    #mod by liuxqa 091020
   IF STATUS THEN
      CALL cl_err("OPEN t400_cl:", STATUS, 1)
      CLOSE t400_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t400_cl INTO g_oea.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t400_cl ROLLBACK WORK RETURN
    END IF
    IF cl_void(0,0,g_oea.oeaconf) THEN
       LET g_chr = g_oea.oeaconf
       IF g_oea.oeaconf = 'N' THEN
          IF g_oea.oea00 = "A" THEN
             SELECT COUNT(*) INTO g_cnt FROM oeb_file
              WHERE oeb01 = g_oea.oea01
             IF g_cnt > 0 THEN
                CALL cl_err("","axm-036",0)
                LET g_success = "N"
             END IF
          END IF

          LET g_oea.oeaconf = 'X'
          LET l_oeb70  = 'Y'     #結案否 (Y/N)
          LET l_oeb70d = g_today #結案日期
       ELSE
          #資料來源之估價單已作廢或未確認,請將"估價單"取消作廢及確認!
          IF g_oea.oea11 = '4' AND NOT cl_null(g_oea.oea12) THEN
             SELECT oqaconf INTO l_oqaconf FROM oqa_file
              WHERE oqa01 = g_oea.oea12
             IF l_oqaconf != 'Y' THEN
                 CALL cl_err(g_oea.oea12,'axm-005',0)
                 RETURN
             END IF
          END IF

          #資料來源之報價單已作廢或未確認,請將"報價單"取消作廢及確認!
          IF g_oea.oea11 = '5' AND NOT cl_null(g_oea.oea12) THEN
              SELECT oqtconf INTO l_oqtconf
                FROM oqt_file
               WHERE oqt01 = g_oea.oea12
              IF l_oqtconf != 'Y' THEN
                  CALL cl_err(g_oea.oea12,'axm-009',0)
                  RETURN
              END IF
           END IF

          IF g_oea.oea11='2' THEN
            IF NOT cl_null(g_oea.oea12) THEN
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM oea_file
               WHERE oea12=g_oea.oea12
                 AND oea11=g_oea.oea11
                 AND oeaconf !='X'
                 AND oea01 <> g_oea.oea01
               IF l_cnt > 0 THEN
                  CALL cl_err(l_cnt,'axm-602',1)
                  RETURN
               END IF
            END IF
          END IF


           LET g_oea.oeaconf = 'N'
           LET l_oeb70 = 'N'
           LET l_oeb70d= NULL

        END IF
    END IF

    UPDATE oea_file
       SET oeaconf = g_oea.oeaconf,
           oeamodu = g_user,
           oeadate = g_today,
           oea72   = g_today
     WHERE oea01 = g_oea.oea01
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err3("upd","oea_file",g_oea.oea01,"",SQLCA.sqlcode,"","upd oeaconf:",1)  #No.FUN-650108
       LET g_oea.oeaconf = g_chr
       LET g_success = 'N'
    END IF
    DISPLAY BY NAME g_oea.oea49
    IF g_oea.oeaconf = 'X' THEN
       LET g_void = "Y"
    ELSE
       LET g_void = "N"
    END IF

    IF g_oea.oea49 = '1' THEN
       LET g_approve = "Y"
    ELSE
       LET g_approve = "N"
    END IF

    CALL cl_set_field_pic(g_oea.oeaconf,g_approve,"","",g_void,"")

    IF l_oeb70 = 'Y' OR l_oeb70 = 'N' THEN  	#MOD-980150
       UPDATE oeb_file
          SET oeb70 = l_oeb70, #結案否 (Y/N)
              oeb70d= l_oeb70d,#結案日期
              #oeb19 = NULL   #MOD-9A0154
              oeb19 = 'N'   #MOD-9A0154
        WHERE oeb01 = g_oea.oea01
       IF SQLCA.SQLCODE THEN
          CALL cl_err3("upd","oeb_file",g_oea.oea01,"",SQLCA.sqlcode,"","upd oeb70:",1)  #No.FUN-650108
          LET g_success = 'N'
       END IF
    END IF					#MOD-980150

    CLOSE t400_cl
    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_flow_notify(g_oea.oea01,'V')
    ELSE
       ROLLBACK WORK
    END IF

    SELECT * INTO g_oea.* FROM oea_file WHERE oea01=g_oea.oea01
    DISPLAY BY NAME g_oea.oeaconf

END FUNCTION

FUNCTION t400_signo_count(p_label)  #讀取應簽人數  #FUN-610055
   DEFINE p_max LIKE type_file.num5,    #No.FUN-680137 SMALLINT
          p_label    LIKE type_file.chr4    # Prog. Version..: '5.30.06-13.03.12(04)        #等級

    LET g_chr=' '

    SELECT COUNT(*) INTO p_max FROM azc_file WHERE azc01=p_label

    IF SQLCA.sqlcode OR
       p_max =0 OR p_max IS NULL THEN
        LET g_chr='E'
    END IF
    RETURN p_max

END FUNCTION


FUNCTION t400_create_tmp2()
  CREATE TEMP TABLE tmp2_file(
     p01 LIKE bmb_file.bmb03);

END FUNCTION

FUNCTION t400_oqa()
   DEFINE l_oqa    RECORD LIKE oqa_file.*
   DEFINE l_occ    RECORD LIKE occ_file.*

   SELECT * INTO l_oqa.* FROM oqa_file WHERE oqa01=g_oea.oea12
   LET g_oea.oea03=l_oqa.oqa06  #FUN-610055
   LET g_oea.oea14=l_oqa.oqa07
   LET g_oea.oea15=l_oqa.oqa05
   LET g_oea.oea23=l_oqa.oqa08
   LET g_oea.oea24=l_oqa.oqa09
   LET g_oea.oea61=l_oqa.oqa17   #No.MOD-5C0037

   SELECT * INTO l_occ.* FROM occ_file WHERE occ01=g_oea.oea03 AND occacti='Y'
   LET g_oea.oea032 = l_occ.occ02  #FUN-610055
   LET g_oea.oea04 = l_occ.occ09
   LET g_oea.oea17 = l_occ.occ07  #FUN-610055
   LET g_oea.oea05 = l_occ.occ08
   LET g_oea.oea21 = l_occ.occ41
   LET g_oea.oea65 = l_occ.occ65   #No.FUN-610056

   SELECT gec04,gec05,gec07
     INTO g_oea.oea211,g_oea.oea212,g_oea.oea213
     FROM gec_file
    WHERE gec01 = g_oea.oea21
      AND gec011 = '2'  #銷項
   LET g_oea.oea25 = l_occ.occ43
   LET g_oea.oea31 = l_occ.occ44
   LET g_oea.oea32 = l_occ.occ45
   LET g_oea.oea33 = l_occ.occ46
   LET g_oea.oea34 = l_occ.occ53
   LET g_oea.oea41 = l_occ.occ48
   LET g_oea.oea42 = l_occ.occ49
   LET g_oea.oea43 = l_occ.occ47

   CALL t400_show()
END FUNCTION

FUNCTION t400_oqt()
   DEFINE l_oqt    RECORD LIKE oqt_file.*
   DEFINE l_rate   LIKE azj_file.azj03

   SELECT * INTO l_oqt.* FROM oqt_file WHERE oqt01=g_oea.oea12
   LET g_errno=''
   IF l_oqt.oqtconf = 'N' THEN
      LET g_errno = 'axm-184'
      RETURN
   END IF
   LET g_oea.oea03=l_oqt.oqt04  #FUN-610055
   LET g_oea.oea04=l_oqt.oqt04
   LET g_oea.oea14=l_oqt.oqt07
   LET g_oea.oea15=l_oqt.oqt06
   LET g_oea.oea23=l_oqt.oqt09
   #-----CHI-B30081---------
   DISPLAY g_oea.oea03 TO oea03
   DISPLAY g_oea.oea04 TO oea04
   DISPLAY g_oea.oea14 TO oea14
   DISPLAY g_oea.oea15 TO oea15
   DISPLAY g_oea.oea23 TO oea23
   IF NOT cl_null(l_oqt.oqt051) OR NOT cl_null(l_oqt.oqt052) OR 
      NOT cl_null(l_oqt.oqt053) OR NOT cl_null(l_oqt.oqt054) OR
      NOT cl_null(l_oqt.oqt055) THEN 
      LET g_oea.oea044 = 'MISC'
      LET g_oap.oap041 = l_oqt.oqt051
      LET g_oap.oap042 = l_oqt.oqt052
      LET g_oap.oap043 = l_oqt.oqt053
      LET g_oap.oap044 = l_oqt.oqt054
      LET g_oap.oap045 = l_oqt.oqt055
      DISPLAY g_oea.oea044 TO oea044
      DISPLAY g_oap.oap041 TO oap041
      DISPLAY g_oap.oap042 TO oap042
      DISPLAY g_oap.oap043 TO oap043
      DISPLAY g_oap.oap044 TO oap044
      DISPLAY g_oap.oap045 TO oap045
   END IF
   #-----END CHI-B30081-----

   #稅別
   #價格條件
   #收款條件
   #銷售分類一
   SELECT occ41,occ44,occ45,occ43,occ07,occ48,occ49,occ47   #No.MOD-590192
          ,occ02,occ08                                      #MOD-760083 add
     INTO g_oea.oea21,g_oea.oea31,g_oea.oea32,g_oea.oea25,
          g_oea.oea17,g_oea.oea41,g_oea.oea42,g_oea.oea43   #No.MOD-590192
          ,g_oea.oea032,g_oea.oea05             #MOd-760083 add
     FROM occ_file
    WHERE occ01 = g_oea.oea03     #FUN-610055

   SELECT gec04,gec05,gec07
     INTO g_oea.oea211,g_oea.oea212,g_oea.oea213
     FROM gec_file
    WHERE gec01=g_oea.oea21
      AND gec011='2'  #銷項

   IF g_oea.oea08='1' THEN
      LET exT=g_oaz.oaz52
   ELSE
      LET exT=g_oaz.oaz70
   END IF
   #NO.FUN-A80056--begin
   LET g_oea.oea21=l_oqt.oqt24
   LET g_oea.oea31=l_oqt.oqt10
   LET g_oea.oea32=l_oqt.oqt25
   LET g_oea.oea41=l_oqt.oqt26
   LET g_oea.oea42=l_oqt.oqt27
   LET g_oea.oea43=l_oqt.oqt11
   #NO.FUN-A80056--end
   CALL s_curr3(l_oqt.oqt09,g_oea.oea02,exT) RETURNING g_oea.oea24
   #-----CHI-B30081---------
   DISPLAY g_oea.oea21 TO oea21
   DISPLAY g_oea.oea25 TO oea25
   DISPLAY g_oea.oea42 TO oea42
   DISPLAY g_oea.oea31 TO oea31
   DISPLAY g_oea.oea17 TO oea17
   DISPLAY g_oea.oea43 TO oea43
   DISPLAY g_oea.oea32 TO oea32
   DISPLAY g_oea.oea41 TO oea41
   DISPLAY g_oea.oea032 TO oea032
   DISPLAY g_oea.oea05 TO oea05
   DISPLAY g_oea.oea211 TO oea211
   DISPLAY g_oea.oea212 TO oea212
   DISPLAY g_oea.oea213 TO oea213
   DISPLAY g_oea.oea24 TO oea24
   #CALL t400_show()
   #-----END CHI-B30081-----
END FUNCTION

FUNCTION t400_oga()
   DEFINE l_oga    RECORD LIKE oga_file.*

   LET g_errno = ''
   SELECT * INTO l_oga.* FROM oga_file WHERE oga01 = g_oea.oea12
   LET g_oea.oea03  = l_oga.oga03        #帳款客戶
   LET g_oea.oea032 = l_oga.oga032       #帳款客戶
   IF g_oea.oea901='Y' THEN
      LET g_oea.oea65='N'
   ELSE
      LET g_oea.oea65 = l_oga.oga65        #No.FUN-610056
   END IF
   LET g_oea.oea033 = l_oga.oga033       #帳款客戶統一編號
   LET g_oea.oea04  = l_oga.oga04        #送貨客戶編號
   LET g_oea.oea044 = l_oga.oga044       #送貨客戶地址碼
   LET g_oea.oea05  = l_oga.oga05        #發票別

   SELECT oea10 INTO g_oea.oea10
     FROM oea_file
    WHERE oea01 = l_oga.oga16

   LET g_oea.oea14  = l_oga.oga14        #人員編號
   LET g_oea.oea15  = l_oga.oga15        #部門編號
   LET g_oea.oea17  = l_oga.oga18        #收款客戶 No.MOD-490073
   LET g_oea.oea21  = l_oga.oga21        #稅別
   LET g_oea.oea211 = l_oga.oga211       #稅率
   LET g_oea.oea212 = l_oga.oga212       #聯數
   LET g_oea.oea213 = l_oga.oga213       #含稅否
   LET g_oea.oea23  = l_oga.oga23        #幣別
   LET g_oea.oea24  = l_oga.oga24        #匯率
   LET g_oea.oea25  = l_oga.oga25        #銷售分類一
   LET g_oea.oea26  = l_oga.oga26        #銷售分類二
   LET g_oea.oea31  = l_oga.oga31        #價格條件編號
   LET g_oea.oea32  = l_oga.oga32        #收款條件編號
END FUNCTION

FUNCTION t400_g_b1()                      	#由估價自動產生單身
   DEFINE l_oqb       RECORD LIKE oqb_file.*
   DEFINE l_check     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(01)
          l_ima25     LIKE ima_file.ima25,
          l_oeb05_fac LIKE oeb_file.oeb05_fac,
          l_oeb14t    LIKE oeb_file.oeb14t,
          l_oeb14     LIKE oeb_file.oeb14,     #No.MOD-880064 add
          l_price     LIKE oeb_file.oeb17,
          l_oqa       RECORD LIKE oqa_file.*

   IF g_oea.oea11='4' THEN
      SELECT COUNT(*) INTO g_cnt FROM oeb_file WHERE oeb01=g_oea.oea01
      IF g_cnt > 0 THEN RETURN END IF		#已有單身則不可再產生
      #--------------------------------
      IF NOT cl_confirm('axm-504') THEN RETURN END IF
      SELECT * INTO l_oqa.* FROM oqa_file WHERE oqa01=g_oea.oea12
      SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=l_oqa.oqa03
      LET l_oeb05_fac=1

      IF g_oea.oea213 = 'N' THEN
         LET l_oeb14 =l_oqa.oqa17          #No.MOD-880064 add
         CALL cl_digcut(l_oeb14,t_azi04)RETURNING l_oeb14      #MOD-940263 add
         LET l_oeb14t=l_oeb14*(1+g_oea.oea211/100)             #MOD-940263 add
         CALL cl_digcut(l_oeb14t,t_azi04)RETURNING l_oeb14t    #MOD-940263 add
      ELSE
         LET l_oeb14t=l_oqa.oqa17
         CALL cl_digcut(l_oeb14t,t_azi04)RETURNING l_oeb14t    #MOD-940263 add
         LET l_oeb14=l_oeb14t/(1+g_oea.oea211/100)
         CALL cl_digcut(l_oeb14,t_azi04)RETURNING l_oeb14      #MOD-940263 add
      END IF

      CALL cl_digcut(l_oqa.oqa17,t_azi04)RETURNING l_oqa.oqa17     #No.CHI-6A0004

      IF l_oqa.oqa10 IS NOT NULL AND l_oqa.oqa10!=0 THEN
         LET l_price=l_oqa.oqa17/l_oqa.oqa10
      ELSE
         LET l_price=0
      END IF
      LET b_oeb.oeb930=s_costcenter(g_oea.oea15) #FUN-670063
      CALL t400_g_du(l_oqa.oqa03,l_ima25,l_oqa.oqa10)
      INSERT INTO oeb_file(oeb01,oeb03,oeb04,oeb05,oeb06,
                           oeb12,oeb13,oeb37,oeb14,oeb71,oeb70,             #FUN-AB0061 add oeb37
                           oeb05_fac,oeb14t,oeb23,oeb24,oeb27,oeb28,oeb25,  #NO.FUN-670007
                           oeb26,oeb901,oeb19,oeb15,oeb16,
                           oeb17,oeb905,oeb910,oeb911,oeb912,
                           oeb913,oeb914,oeb915,oeb916,oeb917,
                           oeb1003,oeb930,oeb1012,oeb1006,oebplant,oeblegal)   #no.7150,7182 #FUN-670063  #MOD-810135 modify #FUN-980010 add oebplant,oeblegal   #MOD-A10123 add oeb1006
                    VALUES(g_oea.oea01,1,l_oqa.oqa03,
                           l_ima25,l_oqa.oqa031,l_oqa.oqa10,
                           l_price,l_price,l_oeb14,0,'N',                   #FUN-AB0061 add l_pirce
                           l_oeb05_fac,l_oeb14t,0,0,0,0,0,0,b_oeb.oeb901,'N',g_today,g_today,   #NO.TQC-740135
                           l_price,0,b_oeb.oeb910,b_oeb.oeb911,b_oeb.oeb912,
                           b_oeb.oeb913,b_oeb.oeb914,b_oeb.oeb915,
                           b_oeb.oeb916,b_oeb.oeb917,'1',b_oeb.oeb930,'N',100,g_plant,g_legal) #no.7150,7182 #FUN-670063  #MOD-810135 modify #FUN-980010 add g_plant,g_legal   #MOD-A10123 add oeb1006
      #--------------------------------
   END IF

END FUNCTION

FUNCTION t400_g_b5()                          #由報價自動產生單身
   DEFINE l_oqu       RECORD LIKE oqu_file.*
   DEFINE l_oao       RECORD LIKE oao_file.*
   DEFINE l_oeb       RECORD LIKE oeb_file.*  #No.FUN-540049
   DEFINE l_check     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(01)
          l_ima25     LIKE ima_file.ima25,
          l_ima908    LIKE ima_file.ima908,   #MOD-740441 add
          l_oeb05_fac LIKE oeb_file.oeb05_fac,
          l_oeb14t    LIKE oeb_file.oeb14t,
          l_amt       LIKE oeb_file.oeb14t,
          l_oeb930    LIKE oeb_file.oeb930    #FUN-670063
   DEFINE l_oeb906    LIKE oeb_file.oeb906    #TQC-750111
   DEFINE l_oqt12     LIKE oqt_file.oqt12     #MOD-B30451 add

   IF g_oea.oea11='5' THEN
      LET l_oeb930=s_costcenter(g_oea.oea15) #FUN-670063
      DECLARE oao_cur CURSOR FOR SELECT * FROM oao_file
                                  WHERE oao01 = g_oea.oea12

      FOREACH oao_cur INTO l_oao.*
         LET l_oao.oao01=g_oea.oea01
         INSERT INTO oao_file VALUES(l_oao.*)
      END FOREACH

      SELECT COUNT(*) INTO g_cnt FROM oeb_file WHERE oeb01=g_oea.oea01

      IF g_cnt > 0 THEN RETURN END IF		#已有單身則不可再產生

      #--------------------------------
      IF NOT cl_confirm('axm-510') THEN RETURN END IF
      DECLARE oqu_cur CURSOR FOR
         SELECT * FROM oqu_file WHERE oqu01=g_oea.oea12

      FOREACH oqu_cur INTO l_oqu.*
         IF STATUS THEN EXIT FOREACH END IF
         IF l_oqu.oqu03[1,4] !='MISC' THEN
            SELECT ima25,ima908 INTO l_ima25,l_ima908 FROM ima_file  #MOD-740441 add ima908
             WHERE ima01 = l_oqu.oqu03
            CALL s_umfchk(l_oqu.oqu03,l_oqu.oqu05,l_ima25)
                       RETURNING l_check,l_oeb05_fac
         ELSE
            LET l_check='0'
            LET l_oeb05_fac=1
         END IF
         IF l_check = '1' THEN
            CALL cl_err(l_oqu.oqu03,'abm-731',1)
            #LET l_oeb05_fac=0   #MOD-A50128
            LET l_oeb05_fac=1   #MOD-A50128
         END IF
         IF cl_null(l_oqu.oqu06) THEN LET l_oqu.oqu06=0 END IF
         IF cl_null(l_oqu.oqu07) THEN LET l_oqu.oqu07=0 END IF
         IF g_oea.oea213 = 'N' THEN
            LET l_amt   =l_oqu.oqu06*l_oqu.oqu07
            CALL cl_digcut(l_amt,t_azi04) RETURNING l_amt
            LET l_oeb14t= l_amt * (1+g_oea.oea211/100)
            CALL cl_digcut(l_oeb14t,t_azi04) RETURNING l_oeb14t
         ELSE
            LET l_oeb14t=l_oqu.oqu06*l_oqu.oqu07
            CALL cl_digcut(l_oeb14t,t_azi04) RETURNING l_oeb14t
            LET l_amt   =l_oeb14t/(1+g_oea.oea211/100)
            CALL cl_digcut(l_amt,t_azi04) RETURNING l_amt
         END IF
         IF cl_null(l_amt) THEN LET l_amt=0  END IF
         IF cl_null(l_oeb14t) THEN LET l_oeb14t=0  END IF

         CALL t400_g_du(l_oqu.oqu03,l_oqu.oqu05,l_oqu.oqu06)
           IF g_sma.sma116 MATCHES '[23]' THEN
              LET b_oeb.oeb916=l_ima908
           END IF
           CALL t400_set_oeb917_exp(l_oqu.oqu03,l_oqu.oqu05,l_oqu.oqu06)

        IF g_oea.oea00<>'4' THEN #CHI-970074
           LET l_oeb906 = NULL
           SELECT obk11 INTO l_oeb906
             FROM obk_file
            WHERE obk01 = l_oqu.oqu03
              AND obk02 = g_oea.oea03
              AND obk05 = g_oea.oea23
           IF cl_null(l_oeb906) THEN
              LET l_oeb906 = 'N'
           END IF
        ELSE #CHI-970074
            LET l_oeb906='N' #CHI-970074
        END IF #CHI-970074

         INSERT INTO oeb_file
                (oeb01,oeb03,oeb04,oeb05,oeb06,oeb11,     #MOD-940151 add oeb11
                 oeb12,oeb13,oeb37,oeb17,oeb14,oeb71,oeb70,#no.7150(add oeb17)    #FUN-AB0061 add oeb37
                 #oeb05_fac,oeb14t,oeb23,oeb24,oeb25,
                 oeb05_fac,oeb14t,oeb23,oeb24,oeb27,oeb28,oeb25,  #NO.FUN-670007
                 oeb26,oeb901,oeb19,oeb15,oeb16,oeb905,
                 oeb910,oeb911,oeb912,oeb913,oeb914,oeb915,oeb916,oeb917,oeb1003,oeb930,oeb906,oeb1012,oeb1006,oebplant,oeblegal)  #FUN-670063  #TQC-750111 add oeb906  #MOD-810135 modify #FUN-980010 add oebplant,oeblegal   #MOD-A10123 add oeb1006
          VALUES(g_oea.oea01,l_oqu.oqu02,l_oqu.oqu03,
                 l_oqu.oqu05,l_oqu.oqu031,l_oqu.oqu04,l_oqu.oqu06,  #MOD-940151 add oqu04
                 l_oqu.oqu07,l_oqu.oqu07,l_oqu.oqu07, l_amt,l_oqu.oqu02,'N',  #no.7150    #FUN-AB0061 add l_oqu.oqu07
                 l_oeb05_fac,l_oeb14t,0,0,'',0,0,0,0,'N',g_today,g_today,0,   #TQC-740152
                 b_oeb.oeb910,b_oeb.oeb911,b_oeb.oeb912,b_oeb.oeb913,
                 b_oeb.oeb914,b_oeb.oeb915,b_oeb.oeb916,b_oeb.oeb917,'1',l_oeb930,l_oeb906,'N',100,g_plant,g_legal)#no.7182  #FUN-670063  #MOD-810135 modify 'N'  #FUN-980010 add g_plant,g_legal   #MOD-A10123 add oeb1006
      END FOREACH
      #--------------------------------
      #MOD-B30451 add --start--
      SELECT oqt12 INTO l_oqt12 FROM oqt_file WHERE oqt01=g_oea.oea12
      IF l_oqt12 = 'Y' THEN
         CALL cl_err('','axm-375',1)
      END IF
      #MOD-B30451 add --end--
       #資料來源為5:報價單轉入時, 單身由報價單自動轉為訂單, 未稅金額重新計算
      SELECT SUM(oeb14),SUM(oeb14t) INTO g_oea.oea61,g_oea.oea1008    #FUN-A50103
        FROM oeb_file WHERE oeb01=g_oea.oea01
      IF cl_null(g_oea.oea61) THEN LET g_oea.oea61=0 END IF
      IF cl_null(g_oea.oea1008) THEN LET g_oea.oea1008=0 END IF    #FUN-A50103
      CALL cl_digcut(g_oea.oea61,t_azi04) RETURNING g_oea.oea61   #CHI-7A0036-add
      CALL cl_digcut(g_oea.oea1008,t_azi04) RETURNING g_oea.oea1008    #FUN-A50103
      UPDATE oea_file SET oea61 = g_oea.oea61,
                          oea1008=g_oea.oea1008    #FUN-A50103
       WHERE oea01 = g_oea.oea01
      DISPLAY BY NAME g_oea.oea61
   END IF
END FUNCTION

FUNCTION t400_g_b7()
   DEFINE b_ogb    RECORD LIKE ogb_file.*
   DEFINE l_oeb    RECORD LIKE oeb_file.*
   DEFINE l_oga910 LIKE oga_file.oga910
   DEFINE l_oga911 LIKE oga_file.oga911
   DEFINE l_oeb12_tot LIKE oeb_file.oeb12     #MOD-9B0185
   DEFINE l_oeb912_tot LIKE oeb_file.oeb912   #MOD-9B0185
   DEFINE l_oeb915_tot LIKE oeb_file.oeb915   #MOD-9B0185
   DEFINE l_oeb917_tot LIKE oeb_file.oeb917   #MOD-9B0185

   IF g_oea.oea11 != '7' THEN RETURN END IF

   SELECT COUNT(*) INTO g_cnt FROM oeb_file
    WHERE oeb01 = g_oea.oea01

   IF g_cnt > 0 THEN RETURN END IF

   IF NOT cl_confirm('axm-806') THEN
      RETURN
   END IF
   SELECT oga910,oga911 INTO l_oga910,l_oga911 FROM oga_file
    WHERE oga01 = g_oea.oea12

   DECLARE ogb_cs CURSOR FOR
     SELECT * FROM ogb_file WHERE ogb01 = g_oea.oea12

   FOREACH ogb_cs INTO b_ogb.*
      LET l_oeb.oeb01    = g_oea.oea01
      LET l_oeb.oeb03    = b_ogb.ogb03
      LET l_oeb.oeb71    = b_ogb.ogb03 #No.MOD-490073
      LET l_oeb.oeb04    = b_ogb.ogb04
      LET l_oeb.oeb05    = b_ogb.ogb05
      LET l_oeb.oeb05_fac= b_ogb.ogb05_fac
      LET l_oeb.oeb06    = b_ogb.ogb06
      LET l_oeb.oeb07    = b_ogb.ogb07
      LET l_oeb.oeb906   = 'N' #CHI-970074
      LET l_oeb.oeb09    = l_oga910
      LET l_oeb.oeb091   = l_oga911
      LET l_oeb.oeb092   = ' '
      LET l_oeb.oeb11    = b_ogb.ogb11
      LET l_oeb.oeb12    = b_ogb.ogb12
      SELECT SUM(oeb12) INTO l_oeb12_tot
        FROM oea_file,oeb_file
       WHERE oea01 = oeb01
         AND oeaconf <> 'X'
         AND oea12 = g_oea.oea12
         AND oeb71 = l_oeb.oeb71
         AND (oeb01 <> g_oea.oea01
          OR (oeb01 = g_oea.oea01 AND oeb03 <> l_oeb.oeb03))
      IF cl_null(l_oeb12_tot) THEN LET l_oeb12_tot = 0 END IF
      LET l_oeb.oeb12 = l_oeb.oeb12 - l_oeb12_tot
      LET l_oeb.oeb13    = b_ogb.ogb13
      LET l_oeb.oeb37    = b_ogb.ogb37     #FUN-AB0061 
      LET l_oeb.oeb14    = b_ogb.ogb14
      LET l_oeb.oeb14t   = b_ogb.ogb14t
      LET l_oeb.oeb41   = b_ogb.ogb41
      LET l_oeb.oeb42   = b_ogb.ogb42
      LET l_oeb.oeb43   = b_ogb.ogb43
      LET l_oeb.oeb15    = g_today               #約訂交貨日
      LET l_oeb.oeb17    = l_oeb.oeb13           #取出單價
      LET l_oeb.oeb19    = 'N'                   #備置否
      LET l_oeb.oeb23    = 0                     #待出貨數量
      LET l_oeb.oeb24    = 0                     #已出貨數量
      LET l_oeb.oeb25    = 0                     #已銷退數量
      LET l_oeb.oeb26    = 0                     #被結案數量
      LET l_oeb.oeb70    = 'N'                   #結案否
      LET l_oeb.oeb901   = 0                     #已包裝數
      LET l_oeb.oeb905   = 0                     #備置量
      LET l_oeb.oeb910   = b_ogb.ogb910
      LET l_oeb.oeb911   = b_ogb.ogb911
      LET l_oeb.oeb912   = b_ogb.ogb912
      LET l_oeb.oeb913   = b_ogb.ogb913
      LET l_oeb.oeb914   = b_ogb.ogb914
      LET l_oeb.oeb915   = b_ogb.ogb915
      LET l_oeb.oeb916   = b_ogb.ogb916
      LET l_oeb.oeb917   = b_ogb.ogb917
      SELECT SUM(oeb912),SUM(oeb915),SUM(oeb917)
         INTO l_oeb912_tot,l_oeb915_tot,l_oeb917_tot
        FROM oea_file,oeb_file
       WHERE oea01 = oeb01
         AND oeaconf <> 'X'
         AND oea12 = g_oea.oea12
         AND oeb71 = l_oeb.oeb71
         AND (oeb01 <> g_oea.oea01
          OR (oeb01 = g_oea.oea01 AND oeb03 <> l_oeb.oeb03))
      IF cl_null(l_oeb912_tot) THEN LET l_oeb912_tot = 0 END IF
      IF cl_null(l_oeb915_tot) THEN LET l_oeb915_tot = 0 END IF
      IF cl_null(l_oeb917_tot) THEN LET l_oeb917_tot = 0 END IF
      LET l_oeb.oeb912 = l_oeb.oeb912 - l_oeb912_tot
      LET l_oeb.oeb915 = l_oeb.oeb915 - l_oeb915_tot
      LET l_oeb.oeb917 = l_oeb.oeb917 - l_oeb917_tot
      IF cl_null(l_oeb.oeb916) THEN
         LET l_oeb.oeb916=l_oeb.oeb05
         LET l_oeb.oeb917=l_oeb.oeb12
      END IF
      IF cl_null(l_oeb.oeb091) THEN LET l_oeb.oeb091=' ' END IF
      IF cl_null(l_oeb.oeb092) THEN LET l_oeb.oeb092=' ' END IF
      LET l_oeb.oeb1003 = '1'
      LET l_oeb.oeb930=b_ogb.ogb930 #FUN-670063
      IF cl_null(l_oeb.oeb1012) THEN LET l_oeb.oeb1012 = 'N' END IF   #MOD-870034
     #IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 'N' END IF   #MOD-A10123  #No.TQC-AA0128
      IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF   #MOD-A10123  #No.TQC-AA0128
      IF g_azw.azw04='2' THEN
         LET l_oeb.oeb45 = b_ogb.ogb45
         LET l_oeb.oeb46 = b_ogb.ogb46
         LET l_oeb.oeb47 = b_ogb.ogb47
         LET l_oeb.oeb48 = '2'        #FUN-9C0082 ADD ---
      END IF
      LET l_oeb.oeb44 = b_ogb.ogb44
      LET l_oeb.oebplant=g_plant
      LET l_oeb.oeblegal=g_legal
      IF cl_null(l_oeb.oeb03)     THEN LET l_oeb.oeb03   =  1 END IF
      IF cl_null(l_oeb.oeb05_fac) THEN LET l_oeb.oeb05_fac =  1 END IF
      IF cl_null(l_oeb.oeb12)     THEN LET l_oeb.oeb12   =  0 END IF
      IF cl_null(l_oeb.oeb13)     THEN LET l_oeb.oeb13   =  0 END IF
      IF cl_null(l_oeb.oeb37)     THEN LET l_oeb.oeb37   =  0 END IF  #FUN-AB0061
      IF cl_null(l_oeb.oeb14)     THEN LET l_oeb.oeb14   =  0 END IF
      IF cl_null(l_oeb.oeb14t)    THEN LET l_oeb.oeb14t  =  0 END IF
      IF cl_null(l_oeb.oeb23)     THEN LET l_oeb.oeb23   =  0  END IF
      IF cl_null(l_oeb.oeb24)     THEN LET l_oeb.oeb24   =  0  END IF
      IF cl_null(l_oeb.oeb25)     THEN LET l_oeb.oeb25   =  0  END IF
      IF cl_null(l_oeb.oeb26)     THEN LET l_oeb.oeb26   =  0  END IF
      IF cl_null(l_oeb.oeb44)     THEN LET l_oeb.oeb44   = '1' END IF
      IF cl_null(l_oeb.oeb47)     THEN LET l_oeb.oeb47   =  0  END IF
      IF cl_null(l_oeb.oeb48)     THEN LET l_oeb.oeb48   = '2' END IF
      INSERT INTO oeb_file VALUES (l_oeb.*)
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         LET g_success='N'
         CALL cl_err3("ins","oeb_file",l_oeb.oeb01,"",STATUS,"","ins oeb:",1)  #No.FUN-650108
         EXIT FOREACH
      END IF
   END FOREACH

END FUNCTION

FUNCTION t400_ef()

   CALL t400sub_y_chk('1',g_oea.oea01)  #FUN-730012
   IF g_success = "N" THEN
      RETURN
   END IF

   #-----CHI-AC0036---------
   BEGIN WORK
   UPDATE oea_file SET oea49='S' WHERE oea01=g_oea.oea01
   #-----END CHI-AC0036-----
   CALL t400sub_hu1(g_oea.*) #客戶信用查核
   IF g_success = 'N' THEN
      ROLLBACK WORK   #CHI-AC0036
      RETURN
   END IF
   ROLLBACK WORK   #CHI-AC0036

   CALL aws_condition()                            #判斷送簽資料
   IF g_success = 'N' THEN
      RETURN
   END IF

##########
# CALL aws_efcli()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
##########
      IF aws_efcli2(base.TypeInfo.create(g_oea),base.TypeInfo.create(g_oeb),'','','','')
      THEN
          LET g_success = 'Y'
          LET g_oea.oea49 = 'S'   #開單成功, 更新狀態碼為 'S. 送簽中'
          DISPLAY BY NAME g_oea.oea49
      ELSE
          LET g_success = 'N'
      END IF
END FUNCTION

##----------------------------------------------------------------------
FUNCTION t400_csd_get_price(p_oeb)
   DEFINE l_oah03	LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)		#單價取價方式
   DEFINE l_ima131	LIKE type_file.chr20   #No.FUN-680137 VARCHAR(20)	#Product Type
   DEFINE p_oeb         RECORD LIKE oeb_file.*

   SELECT oah03 INTO l_oah03 FROM oah_file WHERE oah01 = g_oea.oea31
   LET p_oeb.oeb13=0
   CASE WHEN l_oah03 = '0' RETURN 0
        WHEN l_oah03 = '1'
             IF g_oea.oea213='Y'
                THEN SELECT ima128 INTO p_oeb.oeb13 FROM ima_file
                            WHERE ima01 = p_oeb.oeb04
                ELSE SELECT ima127 INTO p_oeb.oeb13 FROM ima_file
                            WHERE ima01 = p_oeb.oeb04
             END IF
              #->將單價除上匯率
              LET p_oeb.oeb13=p_oeb.oeb13/g_oea.oea24
        WHEN l_oah03 = '2'
             SELECT ima131 INTO l_ima131 FROM ima_file
                    WHERE ima01 = p_oeb.oeb04
             IF cl_null(p_oeb.oeb916) THEN
                LET p_oeb.oeb916 = p_oeb.oeb05   #MOD-730075
             END IF
             DECLARE t400_csd_get_price_c CURSOR FOR
                 SELECT obg21,obg01,obg02,obg03,obg04,obg05,
                        obg06,obg07,obg08,obg09,obg10
                   FROM obg_file
                    WHERE (obg01 = l_ima131          OR obg01 = '*')
                      AND (obg02 = p_oeb.oeb04 OR obg02 = '*')
                      AND (obg03 = p_oeb.oeb916)
                      AND (obg04 = g_oea.oea25       OR obg04 = '*')
                      AND (obg05 = g_oea.oea31       OR obg05 = '*')
                      AND (obg06 = g_oea.oea03       OR obg06 = '*') #FUN-610055
                      AND (obg09 = g_oea.oea23      )
                      AND (obg10 = g_oea.oea21       OR obg10 = '*')
                 ORDER BY obg02 DESC,obg03 DESC,obg04 DESC, #FUN-610055
                          obg05 DESC,obg06 DESC,obg07 DESC,obg08 DESC, #FUN-610055
                          obg09 DESC,obg10 DESC #FUN-610055
             FOREACH t400_csd_get_price_c INTO p_oeb.oeb13
               IF STATUS THEN CALL cl_err('foreach obg',STATUS,1) END IF
               EXIT FOREACH
             END FOREACH
        WHEN l_oah03 = '3'
           SELECT obk08 INTO p_oeb.oeb13 FROM obk_file
                  WHERE obk01 = p_oeb.oeb04 AND obk02 = g_oea.oea03    #FUN-610055
                    AND obk05 = g_oea.oea23
   END CASE
   RETURN p_oeb.oeb13
END FUNCTION

FUNCTION t400_g()
  DEFINE choice  LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)   #CKD OR SKD
  DEFINE choice1 LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)   #單身各自取價否
  DEFINE msb     RECORD LIKE msb_file.*,
         l_ima910   LIKE ima_file.ima910, #FUN-550095 add
         l_sfb08,l_sfb09 LIKE type_file.num10,   #No.FUN-680137 INTEGER
         l_n     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_i     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_star  LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
         l_msp   RECORD LIKE msp_file.*

    IF g_oea.oea01 IS NULL THEN RETURN END IF
    IF (g_oea.oeaconf='Y' OR g_oea.oeaconf='X') THEN RETURN END IF

    OPEN WINDOW t400v_w WITH FORM "axm/42f/axmt400v"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("axmt400v")

    LET tm.bdate=g_today

    INPUT BY NAME tm.msa01,tm.bdate,tm.msm06,tm.msm02,tm.msp01,tm.ware
                  WITHOUT DEFAULTS

       AFTER FIELD msa01
          IF NOT cl_null(tm.msa01) THEN
             SELECT COUNT(*) INTO i FROM msa_file
              WHERE msa01 = tm.msa01
             IF i=0 THEN
                CALL cl_err('sel msa',100,0)
                NEXT FIELD msa01
             END IF
          END IF

       AFTER FIELD msm06
          IF NOT cl_null(tm.msm06) THEN
             SELECT COUNT(*) INTO i FROM gem_file
              WHERE gem01=tm.msm06
                AND gemacti='Y'   #NO:6950
             IF i=0 THEN
               CALL cl_err('sel gem',100,0) NEXT FIELD msm06
             END IF
          END IF

       AFTER FIELD msm02
          IF NOT cl_null(tm.msm02) THEN
             SELECT COUNT(*) INTO i FROM pme_file WHERE pme01=tm.msm02
             IF i=0 THEN
               CALL cl_err('sel pme',100,0) NEXT FIELD msm02
             END IF
          END IF

       AFTER FIELD msp01
          IF NOT cl_null(tm.msp01) THEN
             SELECT COUNT(*) INTO i FROM msp_file
              WHERE msp01=tm.msp01
             IF i=0 THEN
                CALL cl_err('sel msp',100,0)
                NEXT FIELD msp01
             END IF
          END IF

       AFTER FIELD ware
          IF NOT cl_null(tm.ware) THEN
             SELECT COUNT(*) INTO i FROM imd_file
              WHERE imd01=tm.ware
                 AND imdacti = 'Y' #MOD-4B0169
             IF i=0 THEN
                CALL cl_err('sel imd',100,0)
                NEXT FIELD ware
             END IF
             #No.FUN-AA0048  --Begin
             IF NOT s_chk_ware(tm.ware) THEN
                LET tm.ware = ''
             END IF
             #No.FUN-AA0048  --End  
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

    IF INT_FLAG THEN
       LET INT_FLAG=0
       CLOSE WINDOW t400v_w
       RETURN
    END IF

    CLOSE WINDOW t400v_w

    IF NOT cl_confirm('axm-120') THEN RETURN END IF

    LET l_n=1
    IF NOT cl_null(tm.msp01) THEN
      DECLARE sel_msp_cur CURSOR FOR
       SELECT * FROM msp_file
        WHERE msp01 = tm.msp01
      FOREACH sel_msp_cur INTO l_msp.*
        IF STATUS THEN CALL cl_err('for msp:',STATUS,0) EXIT FOREACH END IF
        LET l_star='N'
        IF NOT cl_null(l_msp.msp03) THEN
## 看看是不是有星號
          FOR l_i=1 TO LENGTH(l_msp.msp03)
            IF l_msp.msp03[l_i,l_i]='*' THEN
              IF l_n=1 THEN
                LET g_sql2=g_sql2 CLIPPED,
                    " AND (imd01 MATCHES '",l_msp.msp03 CLIPPED,"'"
              ELSE
                LET g_sql2=g_sql2 CLIPPED,
                    "      OR imd01 MATCHES '",l_msp.msp03 CLIPPED,"'"
              END IF
              LET l_star='Y'  ## 表示有星號
              EXIT FOR
            END IF
          END FOR

          IF l_star='N' THEN
            IF l_n=1 THEN
              LET g_sql2= g_sql2 CLIPPED," AND (imd01 = '",l_msp.msp03 ,"'"
            ELSE
              LET g_sql2= g_sql2 CLIPPED,"   OR imd01 = '",l_msp.msp03 ,"'"
            END IF
          END IF

        END IF

        LET l_star='N'
        IF NOT cl_null(l_msp.msp04) THEN
## 看看是不是有星號
          FOR l_i=1 TO LENGTH(l_msp.msp04)
            IF l_msp.msp04[l_i,l_i]='*' THEN
              IF l_n=1 THEN
                LET g_sql3=g_sql3 CLIPPED,
                    " AND (smyslip MATCHES '",l_msp.msp04 CLIPPED,"'"
              ELSE
                LET g_sql3=g_sql3 CLIPPED,
                    "      OR smyslip MATCHES '",l_msp.msp04 CLIPPED,"'"
              END IF
              LET l_star='Y'  ## 表示有星號
              EXIT FOR
            END IF
          END FOR

          IF l_star='N' THEN
            IF l_n=1 THEN
              LET g_sql3= g_sql3 CLIPPED," AND (smyslip = '",l_msp.msp04 ,"'"
            ELSE
              LET g_sql3= g_sql3 CLIPPED,"   OR smyslip = '",l_msp.msp04 ,"'"
            END IF
          END IF

        END IF
        LET l_n=l_n+1
      END FOREACH
    END IF

    LET g_sql2 = g_sql2 CLIPPED," )"
    LET g_sql3 = g_sql3 CLIPPED," )"

    SELECT COUNT(*) INTO g_cnt FROM oeb_file WHERE oeb01 = g_oea.oea01
    #詢問是否刪除oeb_file
    IF g_cnt>0 THEN
        IF cl_confirm('axm-122') THEN
          LET g_flag ='Y'
          IF g_oea.oeaconf ='N' THEN
            DELETE FROM oeb_file WHERE oeb01 = g_oea.oea01
            IF STATUS THEN
               CALL cl_err3("del","oeb_file",g_oea.oea01,"",STATUS,"","del oeb",1)  #No.FUN-650108
            END IF
          END IF
        ELSE
          LET g_flag ='N'
          LET g_tot3 = g_cnt #記錄單身原先筆數
        END IF
    ELSE
         LET g_flag ='Y'
    END IF
    LET g_cnt = 1
    LET g_nn  = 1
    INITIALIZE msb.* TO NULL
    DECLARE t400_msb_c CURSOR FOR
     SELECT * FROM msb_file
      WHERE msb01 = tm.msa01
    FOREACH t400_msb_c INTO msb.*
     IF STATUS THEN CALL cl_err('for msb:',STATUS,0) EXIT FOREACH END IF

     SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file
      WHERE sfb22=msb.msb01 AND sfb221=msb.msb02
        AND sfb04 != '8'   #未結案者, 以開工量為準
     IF l_sfb08 IS NULL THEN LET l_sfb08=0 END IF
     SELECT SUM(sfb09) INTO l_sfb09 FROM sfb_file
      WHERE sfb22=msb.msb01 AND sfb221=msb.msb02
        AND sfb04  = '8'   #已結案者, 以完工量為準
     IF l_sfb09 IS NULL THEN LET l_sfb09=0 END IF
     LET l_sfb08 = l_sfb08 + l_sfb09
     LET g_nopen = msb.msb05 - l_sfb08

     IF NOT cl_null(msb.msb03) THEN
       LET l_ima910 = NULL
       SELECT ima910 INTO l_ima910 FROM ima_file
        WHERE ima01=msb.msb03
       IF l_ima910 IS NULL THEN LET l_ima910 = ' ' END IF
       CALL t400_mps_bom(msb.msb03,l_ima910,tm.bdate) ## 現在要展多階了 SOB #FUN-550095 add ima910
     END IF
    END FOREACH
END FUNCTION

FUNCTION t400_mps_bom(p_item,p_code,p_date) #FUN-550095 add p_code
  DEFINE i LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE p_item  LIKE bma_file.bma01,
         p_code  LIKE bma_file.bma06, #FUN-550095 add
         p_date  LIKE bmb_file.bmb04,
         l_bma01 LIKE bma_file.bma01,
         l_bma06 LIKE bma_file.bma06  #FUN-550095 add

      #產生一暫存檔
      CALL t400_create_tmp()

     DECLARE bma01_cur_xxx CURSOR FOR
         SELECT UNIQUE bma01,bma06 FROM bma_file
          WHERE bma01 = p_item
            AND bma06 = p_code
     IF SQLCA.sqlcode THEN CALL cl_err('bma_cur',STATUS,1) END IF
     FOREACH bma01_cur_xxx INTO l_bma01,l_bma06 #FUN-550095 add l_bma06
       IF SQLCA.sqlcode THEN CALL cl_err('bma_for',STATUS,1) END IF
       CALL t400_bom1(l_bma01,l_bma06,p_date,'0','0')   #FUN-550095 add bma06
     END FOREACH

    CALL t400_mps_bom_update()
    SELECT SUM(oeb14),SUM(oeb14t) INTO g_oea.oea61,g_oea.oea1008    #FUN-A50103
      FROM oeb_file WHERE oeb01=g_oea.oea01
    IF cl_null(g_oea.oea61) THEN LET g_oea.oea61=0 END IF
    IF cl_null(g_oea.oea1008) THEN LET g_oea.oea1008=0 END IF    #FUN-A50103
    CALL cl_digcut(g_oea.oea61,t_azi04) RETURNING g_oea.oea61   #CHI-7A0036-add
    CALL cl_digcut(g_oea.oea1008,t_azi04) RETURNING g_oea.oea1008    #FUN-A50103
    UPDATE oea_file SET oea61 = g_oea.oea61,
                        oea1008=g_oea.oea1008    #FUN-A50103
     WHERE oea01 = g_oea.oea01
    DISPLAY BY NAME g_oea.oea61

    delete  from tmp1_file where 1=1
    MESSAGE "Generate Finish!!"

END FUNCTION

FUNCTION t400_bom1(p_item,p_code,p_date,p_root,p_play) #FUN-550095 add p_code
  DEFINE p_item  LIKE bma_file.bma01
  DEFINE p_code  LIKE bma_file.bma06 #FUN-550095 add
  DEFINE p_date  LIKE bmb_file.bmb04,
         l_cnt,i,l_n   LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         p_root   LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
         p_play   LIKE bmb_file.bmb06,
         l_bmb   DYNAMIC ARRAY OF RECORD LIKE bmb_file.*,
         l_flag  LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
         l_ima138 LIKE ima_file.ima138,
         l_factor LIKE bmb_file.bmb10_fac,
         l_bma   ARRAY[600] OF LIKE bma_file.bma01,
         l_ima   DYNAMIC ARRAY OF RECORD
                  ima31     LIKE ima_file.ima31,
                  ima25     LIKE ima_file.ima25,
                  ima55     LIKE ima_file.ima55,  #單位
                  ima31_fac LIKE ima_file.ima31_fac,
                  ima02     LIKE ima_file.ima02,
                  ima127    LIKE ima_file.ima127
                 END RECORD
  DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035

  LET g_sql =" SELECT bmb_file.*,ima31,ima25,ima55,ima31_fac,ima02,ima127,bma01",
                " FROM bmb_file LEFT OUTER JOIN ima_file ON (bmb03 = ima01) LEFT OUTER JOIN  bma_file ON (bmb03 = bma01)",
                " WHERE bmb01 ='",p_item,"'",
                "   AND bmb29 ='",p_code,"'",  #FUN-550095 add
                " AND (bmb04 <='",p_date,"' OR bmb04 IS NULL )",
                " AND (bmb05 > '",p_date,"' OR bmb05 IS NULL )"

       PREPARE t400_bmb_pre_xxx FROM g_sql
       IF SQLCA.sqlcode THEN CALL cl_err('t400_bmb_pre',STATUS,1) END IF
       DECLARE t400_bmb_cur_xxx CURSOR FOR t400_bmb_pre_xxx
       IF SQLCA.sqlcode THEN CALL cl_err('t400_bmb_cur',STATUS,1) END IF
        LET l_cnt = 1
       FOREACH t400_bmb_cur_xxx INTO l_bmb[l_cnt].*,l_ima[l_cnt].*,l_bma[l_cnt]
           IF SQLCA.sqlcode THEN CALL cl_err('t400_bmb_cur foreach:',STATUS,1)
              EXIT FOREACH END IF
           IF p_root ='1' THEN   #所展元件
             IF l_ima[l_cnt].ima55 = l_bmb[l_cnt].bmb10 THEN #單位相同
                LET l_bmb[l_cnt].bmb06 = l_bmb[l_cnt].bmb06 * p_play
             ELSE
                CALL s_umfchk(l_bmb[l_cnt].bmb03,l_ima[l_cnt].ima55,l_bmb[l_cnt].bmb10)
                RETURNING l_flag,l_factor
                LET l_bmb[l_cnt].bmb06 = l_bmb[l_cnt].bmb06 *p_play*l_factor
             END IF
           END IF
           LET l_ima910[l_cnt]=''
           SELECT ima910 INTO l_ima910[l_cnt] FROM ima_file WHERE ima01=l_bmb[l_cnt].bmb03
           IF cl_null(l_ima910[l_cnt]) THEN LET l_ima910[l_cnt]=' ' END IF
           LET l_cnt = l_cnt + 1
       END FOREACH
       LET l_cnt = l_cnt - 1
       FOR i = 1 TO l_cnt
         IF l_bma[i] IS NOT NULL THEN  #有下階料件
             SELECT ima138 INTO l_ima138 FROM ima_file
              WHERE ima01=l_bmb[i].bmb03
             SELECT COUNT(*) INTO l_n FROM msm_file
              WHERE msm01 = l_bma[i]
                AND msm06 = tm.msm06
                AND msm02 = tm.msm02
             IF (l_n = 0 AND l_ima138!='Y') THEN
               CALL t400_bom(l_bmb[i].bmb03,l_ima910[i],p_date,'1',l_bmb[i].bmb06) #FUN-8B0035
             ELSE
               INSERT INTO tmp1_file VALUES (l_bmb[i].*,l_ima[i].*)
               IF SQLCA.sqlerrd[3]=0 THEN
                  CALL cl_err3("ins","tmp1_file","","",STATUS,"","ins tmp",1)  #No.FUN-650108
               END IF
             END IF
         ELSE
             INSERT INTO tmp1_file VALUES (l_bmb[i].*,l_ima[i].*)
             IF SQLCA.sqlerrd[3]=0 THEN
                CALL cl_err3("ins","tmp1_file","","",STATUS,"","ins tmp",1)  #No.FUN-650108
             END IF
         END IF
       END FOR
END FUNCTION

FUNCTION t400_mps_bom_update()
 DEFINE l_bma01  LIKE bma_file.bma01,
        p_date   LIKE bmb_file.bmb04,
        l_sql   STRING,  #NO.TQC-630166
        l_bmb   RECORD LIKE bmb_file.*,
        b03,b03_old  LIKE bmb_file.bmb03,
        l_n,l_i LIKE type_file.num5,    #No.FUN-680137 SMALLINT
        l_ima   RECORD
                ima31  LIKE ima_file.ima31,
                ima25  LIKE ima_file.ima25,
                ima55  LIKE ima_file.ima55,

                ima31_fac LIKE ima_file.ima31_fac,
                ima02  LIKE ima_file.ima02,
                ima127 LIKE ima_file.ima127
               END RECORD,
        b_oeb   RECORD LIKE oeb_file.* ,
        l_bmb03 LIKE bmb_file.bmb03,
        l_bmb06 LIKE bmb_file.bmb06,
        l_bmb07 LIKE bmb_file.bmb07,
        l_oeb12 LIKE oeb_file.oeb12,
        l_img10_mrp  LIKE img_file.img10,
        l_img10_loc  LIKE img_file.img10,
        l_sfa06_07   LIKE sfa_file.sfa06,
        l_sfa07      LIKE sfa_file.sfa07,
        l_oeb930     LIKE oeb_file.oeb930 #FUN-670063
   DEFINE l_cnt  LIKE type_file.num5      #No.FUN-680137 SMALLINT
   DEFINE lr_sfa RECORD LIKE sfa_file.*      #No.FUN-940008 add
   DEFINE lr_short_qty  LIKE sfa_file.sfa07  #No.FUN-940008 add

     DECLARE bom_mps_update_cur CURSOR FOR
        SELECT * FROM tmp1_file
        ORDER BY bmb03

     IF SQLCA.sqlcode THEN call cl_err('bom_cur',status,1) END IF
     INITIALIZE b_oeb.* TO NULL
     IF g_flag ='Y' THEN
       LET b_oeb.oeb03 = 0
     ELSE
       LET b_oeb.oeb03 = g_tot3  #原先單身筆數
     END IF
     LET b03 = ' '
     LET b03_old =' '
     let l_cnt = 0
     LET l_oeb930=s_costcenter(g_oea.oea15) #FUN-670063
     LET b_oeb.oeb44='1' #No.FUN-870007
     LET b_oeb.oebplant = g_plant #No.FUN-870007
     LET b_oeb.oeblegal = g_legal #No.FUN-870007
     FOREACH bom_mps_update_cur INTO l_bmb.*,l_ima.*
          MESSAGE '1:',l_bmb.bmb03
          LET b03 = l_bmb.bmb03
     #檢查是否有重複料件
       IF  b03_old != b03  THEN  #新料
          LET b_oeb.oeb01 = g_oea.oea01
          LET b_oeb.oeb03 = g_nn
          LET b_oeb.oeb04 = l_bmb.bmb03
          LET b_oeb.oeb05 = l_ima.ima31
          LET l_sql =" SELECT COUNT(*) FROM tmp1_file  ",
                     " WHERE bmb03 = ? " clipped
          prepare count_mps_pre from l_sql
          declare count_mps_cur cursor for count_mps_pre
          open count_mps_cur using l_bmb.bmb03
          fetch count_mps_cur into l_cnt
          IF l_cnt > 1 THEN
           #-----------計算數量
           LET l_sql=" SELECT bmb03,bmb06,bmb07",
                     " FROM tmp1_file ",
                     " WHERE bmb03 = ? " CLIPPED
           PREPARE oeb12_mps_pre FROM l_sql
           DECLARE oeb12_mps_cur CURSOR FOR oeb12_mps_pre
           LET l_oeb12 = 0
           LET b_oeb.oeb12 = 0
           FOREACH oeb12_mps_cur
           USING l_bmb.bmb03
           INTO l_bmb03,l_bmb06,l_bmb07
            IF SQLCA.sqlcode THEN CALL cl_err('fore-oeb12',STATUS,1)
              EXIT FOREACH END IF
            LET l_oeb12 = g_nopen *(l_bmb06/l_bmb07)
            IF l_oeb12 IS NULL THEN LET l_oeb12 = 0 END IF
            LET b_oeb.oeb12 = b_oeb.oeb12 + l_oeb12
           END FOREACH
          #---------------
          END IF
          IF cl_null(b_oeb.oeb05) THEN LET b_oeb.oeb05=l_ima.ima25 END IF
          LET b_oeb.oeb05_fac = l_ima.ima31_fac
          IF cl_null(b_oeb.oeb05_fac) THEN LET b_oeb.oeb05_fac=1 END IF
          LET b_oeb.oeb06 = l_ima.ima02
          LET b_oeb.oeb09 = g_oea.oea57

         #----------- 數量 ---------------------------------------#

##  數量 = MPS需求量 - (除了本地倉庫量)
          LET g_sql1 = "SELECT SUM(img10*img21) FROM img_file,imd_file ",   #MOD-940312
                       " WHERE img01 = '",b_oeb.oeb04,"'",
                       "   AND img02 = imd01 ",g_sql2 CLIPPED

          PREPARE sum_img10_pre FROM g_sql1
          DECLARE sum_img10_cur CURSOR FOR sum_img10_pre

          FOREACH sum_img10_cur INTO l_img10_mrp EXIT FOREACH END FOREACH

          IF cl_null(l_img10_mrp) THEN LET l_img10_mrp=0 END IF

          SELECT img10 INTO l_img10_loc FROM img_file
           WHERE img01 = b_oeb.oeb04
             AND img02 = tm.ware
          IF cl_null(l_img10_loc) THEN LET l_img10_loc=0 END IF
##  扣除掉MRP限定版本的工單未備料及欠料量
          LET g_sql1 = "SELECT sfa_file.* ",
                       "  FROM sfb_file,sfa_file,smy_file ",
                       " WHERE sfa03 = '",b_oeb.oeb04,"'",
                       "   AND sfb01 = sfa01 AND sfb04 !='8' ",
                       "   AND sfb01 like trim(smyslip)||'-%' ",g_sql3 CLIPPED

          PREPARE sum_sfa07_pre FROM g_sql1
          DECLARE sum_sfa07_cur CURSOR FOR sum_sfa07_pre

          #欠料量計算
          FOREACH sum_sfa07_cur INTO lr_sfa.*
             CALL s_shortqty(lr_sfa.sfa01,lr_sfa.sfa03,lr_sfa.sfa08,
                             lr_sfa.sfa12,lr_sfa.sfa27,lr_sfa.sfa012,lr_sfa.sfa013)               #FUN-A60027 addsfa012,sfa013
                  RETURNING lr_short_qty
             IF cl_null(lr_short_qty) THEN LET lr_short_qty = 0 END IF
             IF (lr_sfa.sfa05 > (lr_sfa.sfa06+ lr_short_qty)) OR (lr_short_qty > 0) THEN
                LET l_sfa06_07 = l_sfa06_07 + ((lr_sfa.sfa05 - lr_sfa.sfa06 - lr_short_qty) * lr_sfa.sfa13)
                LET l_sfa07 = l_sfa07 + lr_short_qty
             END IF
          END FOREACH
          IF cl_null(l_sfa06_07) THEN LET l_sfa06_07=0 END IF
          IF cl_null(l_sfa07) THEN LET l_sfa07=0 END IF

          IF l_cnt <= 1 THEN
            LET b_oeb.oeb12 = g_nopen * (l_bmb.bmb06 / l_bmb.bmb07)
            IF cl_null(b_oeb.oeb12) THEN LET b_oeb.oeb12=0 END IF
          END IF

          LET b_oeb.oeb12=b_oeb.oeb12-l_img10_mrp+l_img10_loc-
                                      l_sfa06_07-l_sfa07

         #--------------------------------------------------------#

             CALL s_fetch_price_new(g_oea.oea03,b_oeb.oeb04,b_oeb.oeb05,b_oeb.oeb15,g_oea.oea00,
                                g_plant,g_oea.oea23,g_oea.oea31,g_oea.oea32,g_oea.oea01,
                                 b_oeb.oeb03,b_oeb.oeb12,b_oeb.oeb1004,'a')
             #   RETURNING b_oeb.oeb13                        #FUN-AB0061 mark  
                 RETURNING b_oeb.oeb13,b_oeb.oeb37            #FUN-AB0061
             IF b_oeb.oeb13 = 0 THEN CALL s_unitprice_entry(g_oea.oea03,g_oea.oea31,g_plant) END IF #FUN-9C0120
          IF cl_null(b_oeb.oeb13) THEN LET b_oeb.oeb13=0 END IF
          CALL cl_digcut(b_oeb.oeb13,t_azi03) RETURNING b_oeb.oeb13     #No.CHI-6A0004
          IF cl_null(b_oeb.oeb37) THEN LET b_oeb.oeb37 = 0 END IF       #FUN-AB0061
          CALL cl_digcut(b_oeb.oeb37,t_azi03) RETURNING b_oeb.oeb37     #FUN-AB0061 
          LET b_oeb.oeb17 = b_oeb.oeb13  #no.7150

         #-----------未稅金額--------------------------------------
          LET b_oeb.oeb14 = b_oeb.oeb12 * b_oeb.oeb13
          CALL cl_digcut(b_oeb.oeb14,t_azi04) RETURNING b_oeb.oeb14     #No.CHI-6A0004
          LET b_oeb.oeb14t=b_oeb.oeb14*(1+g_oea.oea211/100)
          CALL cl_digcut(b_oeb.oeb14t,t_azi04) RETURNING b_oeb.oeb14t   #No.CHI-6A0004
          #--------------------------------------------------------

          LET b_oeb.oeb15 = g_oea.oea59 LET b_oeb.oeb16 = g_oea.oea59
          LET b_oeb.oeb23 = 0 LET b_oeb.oeb24 = 0
          LET b_oeb.oeb25 = 0 LET b_oeb.oeb26 = 0
          LET b_oeb.oeb70 = 'N'
          LET b_oeb.oeb71 = g_oea.oea71
          LET b_oeb.oeb901= 0
          SELECT COUNT(*) INTO l_n FROM msm_file
           WHERE msm01 = b_oeb.oeb04
             AND msm02 = tm.msm02
             AND msm06 = tm.msm06
          LET b_oeb.oeb19 = 'N'   #MOD-9A0154
          LET b_oeb.oeb905 = 0 #no.7182
          IF l_n = 0 THEN
          ELSE
            IF b_oeb.oeb12>0 THEN
              CALL t400_g_du(b_oeb.oeb04,b_oeb.oeb05,b_oeb.oeb12)
              IF cl_null(b_oeb.oeb091) THEN LET b_oeb.oeb091=' ' END IF
              IF cl_null(b_oeb.oeb092) THEN LET b_oeb.oeb092=' ' END IF
              LET b_oeb.oeb1003 = '1'
              LET b_oeb.oeb930=l_oeb930 #FUN-670063
             #-----------未稅金額--------------------------------------
              LET b_oeb.oeb14 = b_oeb.oeb917 * b_oeb.oeb13
              CALL cl_digcut(b_oeb.oeb14,t_azi04) RETURNING b_oeb.oeb14     #No.CHI-6A0004
              LET b_oeb.oeb14t=b_oeb.oeb14*(1+g_oea.oea211/100)
              CALL cl_digcut(b_oeb.oeb14t,t_azi04) RETURNING b_oeb.oeb14t   #No.CHI-6A0004
              #--------------------------------------------------------
              IF cl_null(b_oeb.oeb1012) THEN LET b_oeb.oeb1012 = 'N' END IF   #MOD-870034
              IF cl_null(b_oeb.oeb1006) THEN LET b_oeb.oeb1006 = 100 END IF   #MOD-A10123
              INSERT INTO oeb_file VALUES (b_oeb.*)
              IF STATUS THEN
                 CALL cl_err3("ins","oeb_file",b_oeb.oeb01,"",STATUS,"","ins oeb",1)  #No>FUN-650108
                 RETURN
              END IF
              LET g_nn=g_nn+1
            END IF
          END IF

          LET b03_old = b03
      END IF
   END FOREACH

   delete from tmp1_file where 1=1

END FUNCTION

FUNCTION t400_qr()
   DEFINE l_oeb03   LIKE oeb_file.oeb03
   DEFINE p_oeb04   LIKE oeb_file.oeb04
   DEFINE p_oeb12   LIKE oeb_file.oeb12
   DEFINE l_cmd     LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(100)

   OPEN WINDOW t400q_w WITH FORM "axm/42f/axmt400q"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_locale("axmt400q")

   INPUT l_oeb03 WITHOUT DEFAULTS FROM oeb03

      BEFORE FIELD oeb03
         LET l_oeb03 = 1
         DISPLAY l_oeb03 TO oeb03

      AFTER FIELD oeb03
         IF NOT cl_null(l_oeb03) THEN
            SELECT oeb04,oeb12 INTO p_oeb04,p_oeb12 FROM oeb_file
             WHERE oeb01 = g_oea.oea01
               AND oeb03 = l_oeb03
            IF STATUS = 100 THEN
               CALL cl_err3("sel","oeb_file",g_oea.oea01,l_oeb03,STATUS,"","sel oeb:",1)  #No.FUN-650108
               NEXT FIELD oeb03
            END IF
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

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t400q_w
      RETURN
   END IF

   CLOSE WINDOW t400q_w

   LET l_cmd="amsq502 '",p_oeb04,"' ",p_oeb12
   CALL cl_cmdrun(l_cmd)

END FUNCTION

#用于default 雙單位/轉換率/數量
FUNCTION t400_du_default(p_cmd)
   DEFINE l_item     LIKE img_file.img01,     #料號
          l_ima25    LIKE ima_file.ima25,     #ima單位
          l_ima31    LIKE ima_file.ima31,
          l_ima906   LIKE ima_file.ima906,
          l_ima907   LIKE ima_file.ima907,
          l_ima908   LIKE ima_file.ima907,
          l_unit2    LIKE img_file.img09,     #第二單位
          l_fac2     LIKE img_file.img21,     #第二轉換率
          l_qty2     LIKE img_file.img10,     #第二數量
          l_unit1    LIKE img_file.img09,     #第一單位
          l_fac1     LIKE img_file.img21,     #第一轉換率
          l_qty1     LIKE img_file.img10,     #第一數量
          l_unit3    LIKE img_file.img09,     #計價單位
          l_qty3     LIKE img_file.img10,     #計價數量
          p_cmd      LIKE type_file.chr1,     #No.FUN-680137 VARCHAR(1)
          l_factor   LIKE ima_file.ima31_fac  #No.FUN-680137 DECIMAL(16,8)

   LET l_item = g_oeb[l_ac].oeb04

   SELECT ima25,ima31,ima906,ima907,ima908
     INTO l_ima25,l_ima31,l_ima906,l_ima907,l_ima908
     FROM ima_file
    WHERE ima01 = l_item

   IF g_sma.sma115 = 'Y' THEN            #No.TQC-6B0124 add
      IF l_ima906 = '1' THEN  #不使用雙單位
         LET l_unit2 = NULL
         LET l_fac2  = NULL
         LET l_qty2  = NULL
      ELSE
         LET l_unit2 = l_ima907
         CALL s_du_umfchk(l_item,'','','',l_ima31,l_ima907,l_ima906)
              RETURNING g_errno,l_factor
         LET l_fac2 = l_factor
         LET l_qty2  = 0
      END IF
   END IF #No.TQC-6B0124 add

   LET l_unit1 = l_ima31
   LET l_fac1  = 1
   LET l_qty1  = 0

   IF g_sma.sma116 MATCHES '[01]' THEN   #FUN-610076
      LET l_unit3 = NULL
      LET l_qty3  = NULL
   ELSE
      LET l_unit3 = l_ima908
      LET l_qty3  = 0
   END IF

   IF p_cmd = 'a' OR g_change = 'Y' THEN
      LET g_oeb[l_ac].oeb913=l_unit2
      LET g_oeb[l_ac].oeb914=l_fac2
      LET g_oeb[l_ac].oeb910=l_unit1
      LET g_oeb[l_ac].oeb911=l_fac1
      LET g_oeb[l_ac].oeb916=l_unit3
   END IF

END FUNCTION

FUNCTION t400_set_du_fac()
   DEFINE l_ima25    LIKE ima_file.ima25,     #ima單位
          l_ima31    LIKE ima_file.ima31,
          l_ima906   LIKE ima_file.ima906,
          l_ima907   LIKE ima_file.ima907,
          l_img09    LIKE img_file.img09,     #img單位
          l_item     LIKE ima_file.ima01,
          l_fac2     LIKE inb_file.inb08_fac, #第二轉換率
          l_fac1     LIKE inb_file.inb08_fac, #第一轉換率
          l_factor   LIKE ima_file.ima31_fac  #No.FUN-680137 DECIMAL(16,8)

   LET l_item = g_oeb[l_ac].oeb04

   SELECT ima25,ima31,ima906,ima907
     INTO l_ima25,l_ima31,l_ima906,l_ima907
     FROM ima_file
    WHERE ima01 = l_item

   IF l_ima906 = '1' THEN  #不使用雙單位
      LET l_fac2  = NULL
   ELSE
      CALL s_du_umfchk(l_item,'','','',l_ima31,g_oeb[l_ac].oeb913,l_ima906)
           RETURNING g_errno,l_factor
      LET l_fac2 = l_factor
   END IF

   CALL s_du_umfchk(l_item,'','','',l_ima31,g_oeb[l_ac].oeb910,l_ima906)
        RETURNING g_errno,l_factor
   LET l_fac1 = l_factor

   LET g_oeb[l_ac].oeb914=l_fac2
   LET g_oeb[l_ac].oeb911=l_fac1

END FUNCTION

#對原來數量/換算率/單位的賦值
FUNCTION t400_set_origin_field(p_code)
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE oeb_file.oeb914,
            l_qty2   LIKE oeb_file.oeb915,
            l_fac1   LIKE oeb_file.oeb911,
            l_qty1   LIKE oeb_file.oeb912,
            l_factor LIKE ima_file.ima31_fac,  #No.FUN-680137 DECIMAL(16,8)
            l_ima25  LIKE ima_file.ima25,
            l_ima31  LIKE ima_file.ima31,
            p_code   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(01)

    IF g_sma.sma115='N' THEN RETURN END IF
    SELECT ima25,ima31 INTO l_ima25,l_ima31
      FROM ima_file WHERE ima01=g_oeb[l_ac].oeb04
    IF SQLCA.sqlcode = 100 THEN
       IF g_oeb[l_ac].oeb04 MATCHES 'MISC*' THEN
          SELECT ima25,ima31 INTO l_ima25,l_ima31
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima31) THEN LET l_ima31=l_ima25 END IF

    LET l_fac2=g_oeb[l_ac].oeb914
    LET l_qty2=g_oeb[l_ac].oeb915
    LET l_fac1=g_oeb[l_ac].oeb911
    LET l_qty1=g_oeb[l_ac].oeb912

    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF

    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_oeb[l_ac].oeb05=g_oeb[l_ac].oeb910
                   LET g_oeb[l_ac].oeb12=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_oeb[l_ac].oeb05=l_ima31
                   LET g_oeb[l_ac].oeb12=l_tot
          WHEN '3' LET g_oeb[l_ac].oeb05=g_oeb[l_ac].oeb910
                   LET g_oeb[l_ac].oeb12=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_oeb[l_ac].oeb914=l_qty1/l_qty2
                   ELSE
                      LET g_oeb[l_ac].oeb914=0
                   END IF
       END CASE
    END IF

    LET g_factor = 1
    CALL s_umfchk(g_oeb[l_ac].oeb04,g_oeb[l_ac].oeb05,l_ima25)
          RETURNING g_cnt,g_factor
    IF g_cnt = 1 THEN
       LET g_factor = 1
    END IF
    LET b_oeb.oeb05_fac = g_factor

END FUNCTION

#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t400_du_data_to_correct()

   IF cl_null(g_oeb[l_ac].oeb910) THEN
      LET g_oeb[l_ac].oeb911 = NULL
      LET g_oeb[l_ac].oeb912 = NULL
   END IF

   IF cl_null(g_oeb[l_ac].oeb913) THEN
      LET g_oeb[l_ac].oeb914 = NULL
      LET g_oeb[l_ac].oeb915 = NULL
   END IF

   IF cl_null(g_oeb[l_ac].oeb916) THEN
      LET g_oeb[l_ac].oeb917 = NULL
   END IF

   DISPLAY BY NAME g_oeb[l_ac].oeb911
   DISPLAY BY NAME g_oeb[l_ac].oeb912
   DISPLAY BY NAME g_oeb[l_ac].oeb914
   DISPLAY BY NAME g_oeb[l_ac].oeb915
   DISPLAY BY NAME g_oeb[l_ac].oeb916
   DISPLAY BY NAME g_oeb[l_ac].oeb917

END FUNCTION

FUNCTION t400_set_oeb917()
   DEFINE l_item     LIKE img_file.img01,     #料號
          l_ima25    LIKE ima_file.ima25,     #ima單位
          l_ima31    LIKE ima_file.ima31,     #銷售單位
          l_ima906   LIKE ima_file.ima906,
          l_fac2     LIKE img_file.img21,     #第二轉換率
          l_qty2     LIKE img_file.img10,     #第二數量
          l_fac1     LIKE img_file.img21,     #第一轉換率
          l_qty1     LIKE img_file.img10,     #第一數量
          l_tot      LIKE img_file.img10,     #計價數量
          l_unit     LIKE ima_file.ima25,     #No.MOD-580261
          l_unit1    LIKE ima_file.ima25,     #No.MOD-580261
          l_factor   LIKE ima_file.ima31_fac  #No.FUN-680137 DECIMAL(16,8)

   SELECT ima25,ima31,ima906
     INTO l_ima25,l_ima31,l_ima906
     FROM ima_file
    WHERE ima01=g_oeb[l_ac].oeb04

   IF SQLCA.sqlcode = 100 THEN
      IF g_oeb[l_ac].oeb04 MATCHES 'MISC*' THEN
         SELECT ima25,ima31,ima906
           INTO l_ima25,l_ima31,l_ima906
           FROM ima_file
          WHERE ima01='MISC'
      END IF
   END IF

   IF cl_null(l_ima31) THEN
      LET l_ima31=l_ima25
   END IF

   LET l_fac2=g_oeb[l_ac].oeb914
   LET l_qty2=g_oeb[l_ac].oeb915

   IF g_sma.sma115 = 'Y' THEN
      LET l_fac1=g_oeb[l_ac].oeb911
      LET l_qty1=g_oeb[l_ac].oeb912
      LET l_unit1=g_oeb[l_ac].oeb910   #No.MOD-580261
   ELSE
      LET l_fac1=1
      LET l_qty1=g_oeb[l_ac].oeb12
      CALL s_umfchk(g_oeb[l_ac].oeb04,g_oeb[l_ac].oeb05,l_ima31)
          RETURNING g_cnt,l_fac1
      IF g_cnt = 1 THEN
         LET l_fac1 = 1
      END IF
      LET l_unit1=g_oeb[l_ac].oeb05    #No.MOD-580261
   END IF

   IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
   IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
   IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
   IF cl_null(l_qty2) THEN LET l_qty2=0 END IF


   IF g_sma.sma115 = 'Y' THEN
      CASE l_ima906
         WHEN '1' LET l_tot=l_qty1*l_fac1
         WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
         WHEN '3' LET l_tot=l_qty1*l_fac1
      END CASE
   ELSE  #不使用雙單位
      LET l_tot=l_qty1*l_fac1
   END IF

   IF cl_null(l_tot) THEN
      LET l_tot = 0
   END IF

   IF g_sma.sma116 MATCHES '[01]' THEN  #FUN-610076
      IF g_sma.sma115 = 'Y' THEN
         CASE l_ima906
            WHEN '1' LET l_unit=l_unit1
            WHEN '2' LET l_unit=l_ima31
            WHEN '3' LET l_unit=l_unit1
         END CASE
      ELSE  #不使用雙單位
         LET l_unit=l_unit1
      END IF
      LET g_oeb[l_ac].oeb916=l_unit
   END IF

   LET l_factor = 1
   IF g_sma.sma115 = 'Y' THEN
      CALL s_umfchk(g_oeb[l_ac].oeb04,g_oeb[l_ac].oeb05,g_oeb[l_ac].oeb916)
          RETURNING g_cnt,l_factor
   ELSE
      CALL s_umfchk(g_oeb[l_ac].oeb04,l_ima31,g_oeb[l_ac].oeb916)
          RETURNING g_cnt,l_factor
   END IF
   IF g_cnt = 1 THEN
      LET l_factor = 1
   END IF

   LET l_tot = l_tot * l_factor
   LET g_oeb[l_ac].oeb917 = l_tot
   IF g_oeb[l_ac].oeb05 = g_oeb[l_ac].oeb916 AND g_sma.sma115='N' THEN
      LET g_oeb[l_ac].oeb917 = g_oeb[l_ac].oeb12
   END IF

END FUNCTION

FUNCTION t400_g_du(p_item,p_unit,p_qty)
   DEFINE p_item  LIKE ima_file.ima01
   DEFINE p_unit  LIKE img_file.img09
   DEFINE p_qty   LIKE img_file.img10

   IF g_sma.sma115 = 'Y' THEN
      SELECT ima31,ima906,ima907
        INTO g_ima31,g_ima906,g_ima907
        FROM ima_file
       WHERE ima01=p_item

      LET b_oeb.oeb910=p_unit
      LET g_factor = 1

      CALL s_umfchk(p_item,b_oeb.oeb910,g_ima31)
          RETURNING g_cnt,g_factor
      IF g_cnt = 1 THEN
         LET g_factor = 1
      END IF

      LET b_oeb.oeb911=g_factor
      LET b_oeb.oeb912=p_qty
      LET b_oeb.oeb913=g_ima907
      LET g_factor = 1

      CALL s_umfchk(p_item,b_oeb.oeb913,g_ima31)
          RETURNING g_cnt,g_factor
      IF g_cnt = 1 THEN
         LET g_factor = 1
      END IF

      LET b_oeb.oeb914=g_factor
      LET b_oeb.oeb915=0

      IF g_ima906 = '3' THEN
         LET g_factor = 1
         CALL s_umfchk(p_item,b_oeb.oeb910,b_oeb.oeb913)
             RETURNING g_cnt,g_factor
         IF g_cnt = 1 THEN
            LET g_factor = 1
         END IF
         LET b_oeb.oeb915=p_qty*g_factor
      END IF
   END IF

   LET b_oeb.oeb916 =p_unit
   LET b_oeb.oeb917 =p_qty

END FUNCTION


FUNCTION t400_refresh_detail()
  DEFINE l_compare          LIKE oay_file.oay22
  DEFINE li_col_count       LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE li_i, li_j         LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE lc_agb03           LIKE agb_file.agb03
  DEFINE lr_agd             RECORD LIKE agd_file.*
  DEFINE lc_index           STRING
  DEFINE ls_combo_vals      STRING
  DEFINE ls_combo_txts      STRING
  DEFINE ls_sql             STRING
  DEFINE ls_show,ls_hide    STRING
  DEFINE l_gae04            LIKE gae_file.gae04

  #判斷是否進行料件多屬性新機制管理以及是否傳入了屬性群組
  IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' ) AND NOT cl_null(lg_oay22) THEN
     #首先判斷有無單身記錄，如果單身根本沒有東東，則按照默認的lg_oay22來決定
     #顯示什么組別的信息，如果有單身，則進行下面的邏輯判斷
     IF g_oeb.getLength() = 0 THEN
        LET lg_group = lg_oay22
     ELSE
       #讀取當前單身所有的料件資料，如果它們都屬于多屬性子料件，并且擁有一致的
       #屬性群組，則以該屬性群組作為顯示單身明細屬性的依據，如果有不統一的狀況
       #則返回一個NULL，下面將不顯示任明細屬性列
       FOR li_i = 1 TO g_oeb.getLength()
         #如果某一個料件沒有對應的母料件(已經在前面的b_fill中取出來放在imx00中了)
         #則不進行下面判斷直接退出了
         IF  cl_null(g_oeb[li_i].att00) THEN
            LET lg_group = ''
            EXIT FOR
         END IF
         SELECT imaag INTO l_compare FROM ima_file WHERE ima01 = g_oeb[li_i].att00
         #第一次是賦值
         IF cl_null(lg_group) THEN
            LET lg_group = l_compare
         #以后是比較
         ELSE
           #如果在單身料件屬于不同的屬性組則直接退出（不顯示這些東東)
           IF l_compare <> lg_group THEN
              LET lg_group = ''
              EXIT FOR
           END IF
         END IF
         IF lg_group <> lg_oay22 THEN
            LET lg_group = ''
            EXIT FOR
         END IF
       END FOR
     END IF

     #到這里時lg_group中存放的已經是應該顯示的組別了，該變量是一個全局變量
     #在單身INPUT或開窗時都會用到，因為refresh函數被執行的時機較早，所以能保証在需要的時候有值
     SELECT COUNT(*) INTO li_col_count FROM agb_file WHERE agb01 = lg_group

     #走到這個分支說明是采用新機制，那么使用att00父料件編號代替oeb04子料件編號來顯示
     #得到當前語言別下oeb04的欄位標題
     SELECT gae04 INTO l_gae04 FROM gae_file
       WHERE gae01 = g_prog AND gae02 = 'oeb04' AND gae03 = g_lang
     CALL cl_set_comp_att_text("att00",l_gae04)

     #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
     IF NOT cl_null(lg_group) THEN
        LET ls_hide = 'oeb04,oeb06'
        LET ls_show = 'att00'
     ELSE
        LET ls_hide = 'att00'
        LET ls_show = 'oeb04,oeb06'
     END IF

     #顯現該有的欄位,置換欄位格式
     CALL lr_agc.clear()  #因為這個過程可能會被執行多次，作為一個公共變量，每次執行之前必須要初始化
     FOR li_i = 1 TO li_col_count
         SELECT agb03 INTO lc_agb03 FROM agb_file
           WHERE agb01 = lg_group AND agb02 = li_i

         LET lc_agb03 = lc_agb03 CLIPPED
         SELECT * INTO lr_agc[li_i].* FROM agc_file
           WHERE agc01 = lc_agb03

         LET lc_index = li_i USING '&&'

         CASE lr_agc[li_i].agc04
           WHEN '1'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)

             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
           WHEN '2'
             LET ls_show = ls_show || ",att" || lc_index || "_c"
             LET ls_hide = ls_hide || ",att" || lc_index
             CALL cl_set_comp_att_text("att" || lc_index || "_c",lr_agc[li_i].agc02)
             LET ls_sql = "SELECT * FROM agd_file WHERE agd01 = '",lr_agc[li_i].agc01,"'"
             DECLARE agd_curs CURSOR FROM ls_sql
             LET ls_combo_vals = ""
             LET ls_combo_txts = ""
             FOREACH agd_curs INTO lr_agd.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF ls_combo_vals IS NULL THEN
                   LET ls_combo_vals = lr_agd.agd02 CLIPPED
                ELSE
                   LET ls_combo_vals = ls_combo_vals,",",lr_agd.agd02 CLIPPED
                END IF
                IF ls_combo_txts IS NULL THEN
                   LET ls_combo_txts = lr_agd.agd02 CLIPPED,".",lr_agd.agd03 CLIPPED
                ELSE
                   LET ls_combo_txts = ls_combo_txts,",",lr_agd.agd02 CLIPPED,".",lr_agd.agd03 CLIPPED
                END IF
             END FOREACH
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c",ls_combo_vals,ls_combo_txts)
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index || "_c","NOT NULL|REQUIRED|SCROLL","1|1|1")
          WHEN '3'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
       END CASE
     END FOR

  ELSE
    #否則什么也不做(不顯示任何屬性列)
    LET li_i = 1
    #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
    LET ls_hide = 'att00'
    LET ls_show = 'oeb04'
  END IF

  #下面開始隱藏其他明細屬性欄位(從li_i開始)
  FOR li_j = li_i TO 10
      LET lc_index = li_j USING '&&'
      #注意att0x和att0x_c都要隱藏，別忘了_c的
      LET ls_hide = ls_hide || ",att" || lc_index || ",att" || lc_index || "_c"
  END FOR

  #這樣只用調兩次公共函數就可以解決問題了，效率應該會高一些
  CALL cl_set_comp_visible(ls_show, TRUE)
  CALL cl_set_comp_visible(ls_hide, FALSE)

END FUNCTION

#--------------------在修改下面的代碼前請讀一下注釋先，謝了! -----------------------

#下面代碼是從單身INPUT ARRAY語句中的AFTER FIELD段中拷貝來的，因為在多屬性新模式下原來的oea04料件編號
#欄位是要被隱藏起來，并由新增加的imx00（母料件編號）+各個明細屬性欄位來取代，所以原來的AFTER FIELD
#代碼是不會被執行到，需要執行的判斷應該放新增加的几個欄位的AFTER FIELD中來進行，因為要用多次嘛，所以
#單獨用一個FUNCTION來放，順便把oeb04的AFTER FIELD也移過來，免得將來維護的時候遺漏了
#下標g_oeb[l_ac]都被改成g_oeb[p_ac]，請注意

#本函數返回TRUE/FALSE,表示檢核過程是否通過，一般說來，在使用過程中應該是如下方式□
#    AFTER FIELD XXX
#        IF NOT t400_check_oeb04(.....)  THEN NEXT FIELD XXX END IF
FUNCTION t400_check_oeb04(p_field,p_ac,p_cmd)
DEFINE
  p_field                     STRING,    #當前是在哪個欄位中觸發了AFTER FIELD事件
  p_ac                        LIKE type_file.num5,    #No.FUN-680137 SMALLINT  #g_oeb數組中的當前記錄下標

  l_ps                        LIKE sma_file.sma46,
  l_str_tok                   base.stringTokenizer,
  l_tmp, ls_sql               STRING,
  l_param_list                STRING,
  l_cnt, li_i                 LIKE type_file.num5,    #No.FUN-680137 SMALLINT
  ls_value                    STRING,
  ls_pid,ls_value_fld         LIKE ima_file.ima01,
  ls_name, ls_spec            STRING,
  lc_agb03                    LIKE agb_file.agb03,
  lc_agd03                    LIKE agd_file.agd03,
  ls_pname                    LIKE ima_file.ima02,
  l_misc                      LIKE type_file.chr4,    #No.FUN-680137 VARCHAR(04)
  l_n                         LIKE type_file.num5,    #No.FUN-680137 SMALLINT
  l_b2                        LIKE ima_file.ima31,
  l_ima130                    LIKE ima_file.ima130,
  l_ima131                    LIKE ima_file.ima131,
  l_ima25                     LIKE ima_file.ima25,
  l_imaacti                   LIKE ima_file.imaacti,
  l_qty                       LIKE type_file.num10,   #No.FUN-680137 INTEGER
  p_cmd                       LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
  l_ima135                    LIKE ima_file.ima135,
  l_ima1002                   LIKE ima_file.ima1002,
  l_ima35                     LIKE ima_file.ima35,
  l_ima36                     LIKE ima_file.ima36,
  l_tuo03                     LIKE tuo_file.tuo03,   #No.FUN-650108
  l_tuo031                    LIKE tuo_file.tuo031,  #No.FUN-650108
  l_occ1028                   LIKE occ_file.occ1028,
  l_ima1010                   LIKE ima_file.ima1010,
  l_sum1                      LIKE oeb_file.oeb12,
  l_sum2                      LIKE oeb_file.oeb12,
  l_sum3                      LIKE oeb_file.oeb12,
  l_sum4                      LIKE oeb_file.oeb12,
  l_fac                       LIKE oeb_file.oeb05_fac,
  l_max                       LIKE tqw_file.tqw07,
  l_check_r                   LIKE type_file.chr1    #No.FUN-680137  VARCHAR(01)
  DEFINE l_oeb05  LIKE oeb_file.oeb05   #MOD-880038
  DEFINE l_factor LIKE ima_file.ima31_fac   #MOD-880038
DEFINE l_rtz04                LIKE rtz_file.rtz04    #No.FUN-870007
DEFINE l_rte05                LIKE rte_file.rte05    #No.FUN-870007
DEFINE l_rte07                LIKE rte_file.rte07    #No.FUN-870007
DEFINE l_rtdconf              LIKE rtd_file.rtdconf  #No.FUN-870007
#DEFINE l_oeb04                LIKE oeb_file.oeb04    #FUN-A50054   #FUN-A60035 ---MARK

#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#
#&ifdef SLK
#  IF g_oea.oeaslk02 = 'N' OR cl_null(g_oea.oeaslk02) THEN
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END
  IF g_chr3 = '0' THEN   #No.TQC-640171
     #如果當前欄位是新增欄位（母料件編號以及十個明細屬性欄位）的時候，如果全部輸了值則合成出一個
     #新的子料件編號并把值填入到已經隱藏起來的oeb04中（如果imxXX能夠顯示，oeb04一定是隱藏的）
     #下面就可以直接沿用oeb04的檢核邏輯了
     #如果不是，則看看是不是oeb04自己觸發了，如果還不是則什么也不做(無聊)，返回一個FALSE
     IF ( p_field = 'imx00' )OR( p_field = 'imx01' )OR( p_field = 'imx02' )OR
        ( p_field = 'imx03' )OR( p_field = 'imx04' )OR( p_field = 'imx05' )OR
        ( p_field = 'imx06' )OR( p_field = 'imx07' )OR( p_field = 'imx08' )OR
        ( p_field = 'imx09' )OR( p_field = 'imx10' ) THEN

        #首先判斷需要的欄位是否全部完成了輸入（只有母料件編號+被顯示出來的所有明細屬性
        #全部被輸入完成了才進行后續的操作
        LET ls_pid = g_oeb[p_ac].att00   # ls_pid 父料件編號
        LET ls_value = g_oeb[p_ac].att00   # ls_value 子料件編號
        IF cl_null(ls_pid) THEN
           #MOD-640107 Add ,所有要返回TRUE的分支都要加這兩句話,原來下面的會被
           #注釋掉
           CALL t400_set_no_entry_b(p_cmd,'N')
           CALL t400_set_required()

           RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                 ,l_qty   #TQC-690041 add
        END IF  #注意這里沒有錯，所以返回TRUE

        #取出當前母料件包含的明細屬性的個數
        SELECT COUNT(*) INTO l_cnt FROM agb_file WHERE agb01 =
           (SELECT imaag FROM ima_file WHERE ima01 = ls_pid)
        IF l_cnt = 0 THEN
           #MOD-640107 Add ,所有要返回TRUE的分支都要加這兩句話,原來下面的會被
           #注釋掉
           CALL t400_set_no_entry_b(p_cmd,'N')
           CALL t400_set_required()

            RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                  ,l_qty   #TQC-690041 add
        END IF

        FOR li_i = 1 TO l_cnt
            #如果有任何一個明細屬性應該輸而沒有輸的則退出
            IF cl_null(arr_detail[p_ac].imx[li_i]) THEN
               #MOD-640107 Add ,所有要返回TRUE的分支都要加這兩句話,原來下面的會被
               #注釋掉
               CALL t400_set_no_entry_b(p_cmd,'N')
               CALL t400_set_required()

               RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                     ,l_qty   #TQC-690041 add
            END IF
        END FOR

        #得到系統定義的標准分隔符sma46
        SELECT sma46 INTO l_ps FROM sma_file

        #合成子料件的名稱
        SELECT ima02 INTO ls_pname FROM ima_file   # ls_name 父料件名稱
          WHERE ima01 = ls_pid
        LET ls_spec = ls_pname  # ls_spec 子料件名稱
        #方法□循環在agd_file中找有沒有對應記錄，如果有，就用該記錄的名稱來
        #替換初始名稱，如果找不到則就用原來的名稱
        FOR li_i = 1 TO l_cnt
            LET lc_agd03 = ""
            LET ls_value = ls_value.trim(), l_ps, arr_detail[p_ac].imx[li_i]
            SELECT agd03 INTO lc_agd03 FROM agd_file
             WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = arr_detail[p_ac].imx[li_i]
            IF cl_null(lc_agd03) THEN
               LET ls_spec = ls_spec.trim(),l_ps,arr_detail[p_ac].imx[li_i]
            ELSE
               LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
            END IF
        END FOR

        #解析ls_value生成要傳給cl_copy_bom的那個l_param_list
        LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)
        LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉

        LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                     "ima01 = '",ls_pid CLIPPED,"' AND agb01 = imaag ",
                     "ORDER BY agb02"
        DECLARE param_curs CURSOR FROM ls_sql
        FOREACH param_curs INTO lc_agb03
          #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
          IF cl_null(l_param_list) THEN
             LET l_param_list = '#',lc_agb03,'#|',l_str_tok.nextToken()
          ELSE
             LET l_param_list = l_param_list,'|#',lc_agb03,'#|',l_str_tok.nextToken()
          END IF
        END FOREACH

        LET g_value = ls_value
        LET g_chr2  = '1'

        IF g_sma.sma908 <> 'Y' AND g_sma.sma120 = 'Y' THEN  #No.MOD-850198
           SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_value
           IF l_n=0 THEN
              CALL cl_err(g_value,'ams-003',1)
              RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                    ,l_qty   #TQC-690041 add
           END IF
        END IF

        #調用cl_copy_ima將新生成的子料件插入到數據庫中
        IF cl_copy_ima(ls_pid,ls_value,ls_spec,l_param_list) = TRUE THEN
           #如果向其中成功插入記錄則同步插入屬性記錄到imx_file中去
           LET ls_value_fld = ls_value

           INSERT INTO imx_file VALUES(ls_value_fld,ls_pid,arr_detail[p_ac].imx[1],
             arr_detail[p_ac].imx[2],arr_detail[p_ac].imx[3],arr_detail[p_ac].imx[4],
             arr_detail[p_ac].imx[5],arr_detail[p_ac].imx[6],arr_detail[p_ac].imx[7],
             arr_detail[p_ac].imx[8],arr_detail[p_ac].imx[9],arr_detail[p_ac].imx[10])
           #如果向imx_file中插入記錄失敗則也應將ima_file中已經建立的紀錄刪除以保証兩邊
           #記錄的完全同步
           IF SQLCA.sqlcode THEN
#             CALL cl_err('Failure to insert imx_file , rollback insert to ima_file !','',1)   #No.FUN-650108
              CALL cl_err3("ins","imx_file",ls_value_fld,"",SQLCA.sqlcode,"","Failure to insert imx_file , rollback insert to ima_file !",1)  #No.FUN-650108
              DELETE FROM ima_file WHERE ima01 = ls_value_fld
              RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                    ,l_qty   #TQC-690041 add
           END IF
        END IF
        #把生成的子料件賦給oeb04，否則下面的檢查就沒有意義了
        LET g_oeb[p_ac].oeb04 = ls_value
     ELSE
       IF ( p_field <> 'oeb04' )AND( p_field <> 'imx00' ) THEN
          RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                 ,l_qty   #TQC-690041 add
       END IF
     END IF
  END IF   #No.TQC-640171
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#   END IF 
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END
  #到這里已經完成了以前在cl_itemno_multi_att()中做的所有准備工作，在系統資料庫
  #中已經有了對應的子料件的名稱，下面可以按照oeb04進行判斷了

  #--------重要 !!!!!!!!!!!-------------------------
  #下面的代碼都是從原INPUT ARRAY中的AFTER FIELD oeb04段拷貝來的，唯一做的修改
  #是將原來的NEXT FIELD 語句都改成了RETURN FALSE, xxx,xxx ... ，因為NEXE FIELD
  #語句要交給調用方來做，這里只需要返回一個FALSE告訴它有錯誤就可以了，同時一起
  #返回的還有一些CHECK過程中要從ima_file中取得的欄位信息，其他的比如判斷邏輯和
  #錯誤提示都沒有改，如果你需要在里面添加代碼請注意上面的那個要點就可以了

  IF NOT cl_null(g_oeb[l_ac].oeb04) THEN
     IF g_oeb_t.oeb04 IS NULL OR g_oeb_t.oeb04 <> g_oeb[l_ac].oeb04 THEN
        LET g_change = 'Y'
        IF g_oaz.oaz46='Y' THEN		# 將客戶品號轉為本公司品號
           LET g_msg=NULL
           SELECT MIN(obk01) INTO g_msg FROM obk_file
            WHERE obk03=g_oeb[l_ac].oeb04 AND obk02=g_oea.oea03
              AND obk05=g_oea.oea23
           IF STATUS=0 AND g_msg IS NOT NULL THEN #MOD-810088
              LET b_oeb.oeb11 = g_oeb[l_ac].oeb04
              LET g_oeb[l_ac].oeb04 = g_msg
           END IF
              DISPLAY BY NAME g_oeb[l_ac].oeb04
        END IF
     END IF

#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#  IF g_oea.oeaslk02 <> 'Y' THEN     
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END
     #新增一個判斷,如果lg_oay22不為空,表示當前采用的是料件多屬性的新機制,因此這個函數應該是被
     #attxx這樣的明細屬性欄位的AFTER FIELD來調用的,所以不再使用原來的輸入機制,否則不變
     IF cl_null(lg_oay22) THEN
       IF g_sma.sma120 = 'Y' THEN
          CALL cl_itemno_multi_att("oeb04",g_oeb[l_ac].oeb04,"","1",'1') RETURNING l_check_r,g_oeb[l_ac].oeb04,g_oeb[l_ac].oeb06 #No.TQC-650111 新增返回參數l_check_r By Rayven
          IF l_check_r = '0' THEN   #No.TQC-650111
             RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti  #No.TQC-650111
                   ,l_qty   #TQC-690041 add
          END IF  #No.TQC-650111
          DISPLAY g_oeb[l_ac].oeb04 TO oeb04
          DISPLAY g_oeb[l_ac].oeb06 TO oeb06
          LET g_value = g_oeb[l_ac].oeb04
          LET g_chr2  = '1'
          SELECT imx00 INTO g_oeb04
            FROM imx_file
           WHERE imx000 = g_oeb[l_ac].oeb04
       END IF
     END IF
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#  END IF
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END

     LET l_misc=g_oeb[l_ac].oeb04[1,4]
 
     IF g_oeb[l_ac].oeb04[1,4]='MISC' THEN  #NO:6808
        SELECT COUNT(*) INTO l_n FROM ima_file
         WHERE ima01=l_misc
           AND ima01='MISC'
        IF l_n=0 THEN
           CALL cl_err('','aim-806',0)
           RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                 ,l_qty   #TQC-690041 add
        END IF
     ELSE
           SELECT imaacti,ima1010 INTO l_imaacti,l_ima1010
             FROM ima_file
            WHERE ima01=g_oeb[l_ac].oeb04
           IF STATUS=100 THEN
              CALL cl_err3("sel","ima_file",g_oeb[l_ac].oeb04,"","apm-168","","",1)  #No.FUN-650108
              RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                    ,l_qty   #TQC-690041 add
           END IF
           IF l_imaacti = 'N' THEN
              CALL cl_err('','9028',0)
              RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                    ,l_qty   #TQC-690041 add
           END IF
           IF l_ima1010 != '1' THEN           #No.FUN-690025
              CALL cl_err('','atm-017',0)
              RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                    ,l_qty   #TQC-690041 add
           END IF
        IF g_aza.aza50 = 'Y' THEN  #No.FUN-650108 #MOD-740114 流通配銷的判斷挪至此,因為以上程式段為對料件的正確性控管
           SELECT * FROM tqh_file,ima_file
            WHERE tqh02=ima1006
              AND tqhacti='Y'
              AND ima01=g_oeb[l_ac].oeb04
              AND tqh01=g_oea.oea1002
           IF STATUS=100 THEN
              CALL cl_err3("sel","tqh_file,ima_file","","","atm-018","","",1)  #No.FUN-650108
              RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                    ,l_qty   #TQC-690041 add
           END IF
        END IF  #No.FUN-650108
     END IF

     IF g_aza.aza50 = 'Y' THEN  #No.FUN-650108
        IF g_oea.oea00 = '1' AND g_oea.oea11='2'
           AND NOT cl_null(g_oea.oea12) THEN
           SELECT * FROM ohb_file
            WHERE ohb04=g_oea.oea04
              AND ohb01=g_oea.oea11
           IF STATUS=0 THEN
              CALL cl_err3("sel","ohb_file",g_oea.oea11,"","atm-029","","",1)  #No.FUN-650108
              RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                    ,l_qty   #TQC-690041 add
           END IF
        END IF
        IF g_oeb[l_ac].oeb04[1,4] != 'MISC' AND g_oeb[l_ac].oeb04 != g_oeb_t.oeb04
           OR cl_null(g_oeb_t.oeb04) THEN
           IF g_oea.oea00 = '7' THEN
              SELECT tuo03,tuo031
                INTO l_tuo03,l_tuo031
                FROM tuo_file
               WHERE tuo01 = g_oea.oea03
                 AND tuo02 = g_oea.oea04
              LET g_oeb[l_ac].oeb09 = l_tuo03
              LET g_oeb[l_ac].oeb091= l_tuo031
           END IF
           SELECT ima1002,ima135,ima35,ima36
             INTO l_ima1002,l_ima135,l_ima35,l_ima36
             FROM ima_file
            WHERE ima01=g_oeb[l_ac].oeb04
           LET g_oeb[l_ac].ima1002=l_ima1002
           LET g_oeb[l_ac].ima135=l_ima135
           IF g_oeb[l_ac].oeb09 IS NULL AND g_oea.oea00 = '7' THEN #No.FUN-650108
              IF g_azw.azw04='2' THEN
                 SELECT rtz07 INTO g_oeb[l_ac].oeb09 FROM rtz_file
                  WHERE rtz01 = g_plant
              ELSE
              LET g_oeb[l_ac].oeb09=l_ima35
              END IF #No.FUN-870007
              LET g_oeb[l_ac].oeb091=l_ima36
           ELSE
              IF g_oea.oea00 <> '7' THEN
                 IF g_azw.azw04='2' THEN
                    SELECT rtz07 INTO g_oeb[l_ac].oeb09 FROM rtz_file
                     WHERE rtz01 = g_plant
                 ELSE
                 LET g_oeb[l_ac].oeb09=l_ima35
                 END IF  #No.FUN-870007
                 LET g_oeb[l_ac].oeb091=l_ima36
              END IF
           END IF
           DISPLAY BY NAME g_oeb[l_ac].ima1002
           DISPLAY BY NAME g_oeb[l_ac].ima135
           DISPLAY BY NAME g_oeb[l_ac].oeb09
           DISPLAY BY NAME g_oeb[l_ac].oeb091
        END IF
     END IF  #No.FUN-650108
     IF g_oeb[l_ac].oeb04 != g_oeb_t.oeb04 THEN
        IF b_oeb.oeb24 > 0 THEN
           CALL cl_err('','axm-254',0)
           LET g_oeb[l_ac].oeb04 = g_oeb_t.oeb04
           RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                 ,l_qty   #TQC-690041 add
        END IF
     END IF

     SELECT ima02,ima021,ima31,ima130,ima131,ima15,ima25,imaacti
       INTO g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
       FROM ima_file
      WHERE ima01=g_oeb[l_ac].oeb04
     IF SQLCA.SQLCODE  AND g_oeb[l_ac].oeb04[1,4] != 'MISC' THEN
        CALL cl_err('sel ima',SQLCA.SQLCODE,0)
        RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
             ,l_qty   #TQC-690041 add
     END IF
     IF g_oeb[l_ac].oeb04 != g_oeb_t.oeb04 OR g_oeb_t.oeb04 IS NULL THEN
        LET g_oeb[l_ac].oeb05=l_b2
        DISPLAY BY NAME g_oeb[l_ac].oeb05
     END IF

     IF g_oeb[l_ac].oeb06 IS NULL OR
        (g_oeb[l_ac].oeb04 != g_oeb_t.oeb04 ) OR
         g_oeb_t.oeb04 IS NULL THEN  #No.MOD-490388
        LET g_oeb[l_ac].oeb06 = g_buf
        LET g_oeb[l_ac].ima021= g_buf1
        LET g_oeb[l_ac].ima15 = g_buf2
        DISPLAY g_oeb[l_ac].oeb06 TO oeb06
        DISPLAY g_oeb[l_ac].ima021 TO ima021
        DISPLAY BY NAME g_oeb[l_ac].oeb04   #MOD-920281
     END IF

     IF g_oea.oea00 MATCHES '[123467]' AND l_imaacti='N' THEN     #FUN-690044
        CALL cl_err(g_oeb[l_ac].oeb04,'9028',0)
        RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
              ,l_qty   #TQC-690041 add
     END IF

     IF g_oea.oea00 MATCHES '[123467]' AND l_ima130 = '0' THEN    #FUN-690044
        CALL cl_err('ima130=0:','axm-188',0)
        RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
              ,l_qty   #TQC-690041 add
     END IF

     LET g_buf = NULL
     LET g_buf1 = NULL
     SELECT obk03 INTO g_buf FROM obk_file
      WHERE obk01 = g_oeb[l_ac].oeb04
        AND obk02 = g_oea.oea03     #FUN-610055
        AND obk05 = g_oea.oea23      #No.FUN-670099
    IF g_oeb_t.oeb04 IS NULL OR g_oeb_t.oeb04 <> g_oeb[l_ac].oeb04 THEN   #MOD-890137
           LET b_oeb.oeb11 = g_buf
           LET g_oeb[l_ac].oeb11 = b_oeb.oeb11
    END IF    #MOD-890137

    IF g_aza.aza50 = 'N' THEN           #MOD-740308 add
     IF g_oea.oea11 = '3' THEN		# 檢查是否存在合約檔
        SELECT oeb12*(100+oea09)/100-oeb24,oeb05 INTO l_qty,l_oeb05   #MOD-880038
          FROM oeb_file,oea_file
         WHERE oeb01 = g_oea.oea12
           AND oeb01 = oea01
           AND oeb03 = g_oeb[l_ac].oeb71
           AND oeb04 = g_oeb[l_ac].oeb04
#          AND oeb32 > g_oea.oea02         #No.FUN-A80024   #TQC-AA0025
           AND oeb32 <= g_oea.oea02         #No.FUN-A80024   #TQC-AA0025
        IF STATUS THEN
           CALL cl_err3("sel","oeb_file,oea_file","","","axm-238","","",1)  #No.FUN-650108
           RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                 ,l_qty   #TQC-690041 add
        END IF
        CALL s_umfchk(g_oeb[l_ac].oeb04,l_oeb05,g_oeb[l_ac].oeb05)
          RETURNING l_cnt,l_factor
        IF l_cnt = 1 THEN LET l_factor = 1 END IF
        LET l_qty = l_qty * l_factor
     END IF
    END IF                              #MOD-740308 add

     IF g_oea.oea11='5' THEN           # 檢查是否存在報價單中
        SELECT COUNT(*) INTO l_n FROM oqu_file
         WHERE oqu01=g_oea.oea12
           AND oqu02=g_oeb[l_ac].oeb71
           AND oqu03=g_oeb[l_ac].oeb04
        IF l_n = 0 THEN
           CALL cl_err('','axm-813',0)
           RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                 ,l_qty   #TQC-690041 add
        END IF
     END IF

     IF g_azw.azw04='2' THEN
        LET l_rtz04=''
        SELECT rtz04 INTO l_rtz04 FROM rtz_file
         WHERE rtz01=g_plant
        IF SQLCA.sqlcode=100 THEN
           CALL cl_err('','art-430',0)
           RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti,l_qty
        END IF
        IF cl_null(l_rtz04) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM ima_file
             WHERE ima01=g_oeb[l_ac].oeb04
            IF l_n= 0 THEN
               CALL cl_err('','art-440',0)
               RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti,l_qty
            END IF
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM ima_file
             WHERE ima01=g_oeb[l_ac].oeb04 AND imaacti='Y'
            IF l_n= 0 THEN
               CALL cl_err('','art-441',0)
               RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti,l_qty
            END IF
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM ima_file
             WHERE ima01=g_oeb[l_ac].oeb04 AND imaacti='Y' AND ima1010='1'
            IF l_n= 0 THEN
               CALL cl_err('','art-507',0)
               RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti,l_qty
            END IF
       ELSE
         SELECT rte05,rte07,rtdconf INTO l_rte05,l_rte07,l_rtdconf
           FROM rtd_file,rte_file
          WHERE rtd01=rte01 AND rtd01=l_rtz04 AND rte03=g_oeb[l_ac].oeb04
         IF SQLCA.sqlcode=100 THEN
             CALL cl_err('','art-431',0)
             RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti,l_qty
         END IF
         IF l_rte05 = 'N' THEN
            CALL cl_err('','art-432',0)
            RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti,l_qty
         END IF
         IF l_rte07='N' THEN
            CALL cl_err('','art-433',0)
            RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti,l_qty
         END IF
         IF l_rtdconf !='Y' THEN
            CALL cl_err('','art-434',0)
            RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti,l_qty
         END IF
      END IF
     END IF
     IF g_sma.sma115 = 'Y' THEN
        CALL s_chk_va_setting(g_oeb[l_ac].oeb04)
             RETURNING g_flag,g_ima906,g_ima907
        IF g_flag=1 THEN
           RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                 ,l_qty   #TQC-690041 add
        END IF
        CALL s_chk_va_setting1(g_oeb[l_ac].oeb04)
             RETURNING g_flag,g_ima908
        IF g_flag=1 THEN
           RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                 ,l_qty   #TQC-690041 add
        END IF
        IF g_ima906 = '3' THEN
           LET g_oeb[l_ac].oeb913=g_ima907
           DISPLAY BY NAME g_oeb[l_ac].oeb913
        END IF
     END IF
     LET g_ima25 = l_ima25
     LET g_ima31 = l_b2
     IF g_oeb_t.oeb04 IS NULL OR g_oeb_t.oeb04 <> g_oeb[l_ac].oeb04 THEN
        IF g_sma.sma116 MATCHES '[23]' THEN  #FUN-610076
           LET g_oeb[l_ac].oeb916=g_ima908
           DISPLAY BY NAME g_oeb[l_ac].oeb916
        END IF
           CALL t400_du_default(p_cmd)
#TQC-AA0025 --begin--  
#         IF NOT cl_null(g_oeb[l_ac].oeb15) AND g_aza.aza50 = 'Y' THEN  #No.FUN-650108
#            CALL t400_price(l_ac) RETURNING l_fac
#         END IF
#TQC-AA0025 --end--    
     END IF

     IF g_oeb[l_ac].oeb04 != g_oeb_t.oeb04
        OR g_oeb[l_ac].oeb12 !=g_oeb_t.oeb12 OR cl_null(g_oeb_t.oeb04) THEN
       #CALL t400_fetch_price('a')    #NO.FUN-960130----add-----
        CALL t400_fetch_price(p_cmd)  #FUN-AC0012
        IF g_oea.oea213 = 'N'  THEN # 不內含
           LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb12*g_oeb[l_ac].oeb13
           CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04) RETURNING g_oeb[l_ac].oeb14    #CHI-7A0036-add
           LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb14*(1+g_oea.oea211/100)
           CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t  #CHI-7A0036-add
        ELSE
           LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb12*g_oeb[l_ac].oeb13
           CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t  #CHI-7A0036-add
           LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb14t/(1+g_oea.oea211/100)
           CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04) RETURNING g_oeb[l_ac].oeb14    #CHI-7A0036-add
        END IF
       
        DISPLAY BY NAME g_oeb[l_ac].oeb14
        DISPLAY BY NAME g_oeb[l_ac].oeb14t
     END IF

     IF g_oeb[l_ac].oeb04 != g_oeb_t.oeb04 OR cl_null(g_oeb_t.oeb04) THEN   #MOD-8B0048
        SELECT COUNT(*) INTO l_n
          FROM obk_file
         WHERE obk01 = g_oeb[l_ac].oeb04
           AND obk02 = g_oea.oea03
           AND obk05 = g_oea.oea23      #No.FUN-670099
        IF l_n = 1 THEN
           #LET g_chr1 = 'Y'   #CHI-880006
           IF g_oea.oea00<>'4' THEN #CHI-970074
              SELECT obk11 INTO g_oeb[l_ac].oeb906
                FROM obk_file
               WHERE obk01 = g_oeb[l_ac].oeb04
                 AND obk02 = g_oea.oea03
                 AND obk05 = g_oea.oea23      #No.FUN-670099
            END IF  #CHI-970074
        END IF
        IF g_oea.oea00<>'4' THEN #CHI-970074
           IF cl_null(g_oeb[l_ac].oeb906) THEN
              LET g_oeb[l_ac].oeb906 = 'N'
           END IF
        ELSE #CHI-970074
           LET g_oeb[l_ac].oeb906='N' #CHI-970074
        END IF #CHI-970074
     END IF   #MOD-8B0048

     CALL t400_set_no_entry_b(p_cmd,'N')
     CALL t400_set_required_b()   #FUN-610055

     IF g_sma.sma908 <> 'Y' AND g_sma.sma120 = 'Y' THEN  #No.MOD-850198
        SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_oeb[l_ac].oeb04
        IF l_n=0 THEN
           CALL cl_err(g_oeb[l_ac].oeb04,'ams-003',1)
           RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                 ,l_qty   #TQC-690041 add
        END IF
     END IF

     RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti  #FUN-640013 Add
           ,l_qty   #TQC-690041 add
  ELSE
     #如果是由oeb04來觸發的,說明當前用的是舊的流程,那么oeb04為空是可以的
     #如果是由att00來觸發,原理一樣
     IF ( p_field = 'oeb04' )OR( p_field = 'imx00' ) THEN
        #MOD-640107 Add ,所有要返回TRUE的分支都要加這兩句話,原來下面的會被
        #注釋掉
        CALL t400_set_no_entry_b(p_cmd,'N')
        CALL t400_set_required()

        IF g_sma.sma908 <> 'Y' AND g_sma.sma120 = 'Y' THEN  #No.MOD-850198
           LET g_value = ls_value
           SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_value
           IF l_n=0 THEN
              CALL cl_err(g_value,'ams-003',1)
              RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                    ,l_qty   #TQC-690041 add
           END IF
        END IF

        RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
              ,l_qty   #TQC-690041 add
     ELSE
        #如果不是oeb,則是由attxx來觸發的,則非輸不可
        RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
              ,l_qty   #TQC-690041 add
     END IF #如果為空則不允許新增
  END IF

END FUNCTION

FUNCTION t400_price_1(p_ac)
DEFINE p_ac LIKE type_file.num5
DEFINE l_flag  LIKE type_file.chr1

   #IF g_aza.aza50 = 'Y' THEN #FUN-A60035
   IF g_azw.azw04 = '2' THEN #FUN-A60035
      CALL t400_chk_oeb04() RETURNING l_flag
      IF l_flag='1' THEN
         RETURN 1
      END IF
   END IF                    #FUN-A60035
   IF cl_null(g_oeb[p_ac].oeb916) THEN
      LET g_oeb[p_ac].oeb917 = g_oeb[p_ac].oeb12
   END IF
   IF g_oea.oea213 = 'N' THEN
      LET g_oeb[p_ac].oeb14 = g_oeb[p_ac].oeb12* g_oeb[p_ac].oeb13
      CALL cl_digcut(g_oeb[p_ac].oeb14,t_azi04)  RETURNING g_oeb[p_ac].oeb14
      LET g_oeb[p_ac].oeb14t= g_oeb[p_ac].oeb14*(1+ g_oea.oea211/100)
      CALL cl_digcut(g_oeb[p_ac].oeb14t,t_azi04) RETURNING g_oeb[p_ac].oeb14t
   ELSE
      LET g_oeb[p_ac].oeb14t= g_oeb[p_ac].oeb12*g_oeb[p_ac].oeb13
      CALL cl_digcut(g_oeb[p_ac].oeb14t,t_azi04) RETURNING g_oeb[p_ac].oeb14t
      LET g_oeb[p_ac].oeb14 = g_oeb[p_ac].oeb14t/(1+ g_oea.oea211/100)
      CALL cl_digcut(g_oeb[p_ac].oeb14,t_azi04)  RETURNING g_oeb[p_ac].oeb14
   END IF
   RETURN 0
END FUNCTION

#用于att01~att10這十個輸入型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可
#與t400_check_oeb04相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION t400_check_att0x(p_value,p_index,p_row,p_cmd)
DEFINE
  p_value      LIKE imx_file.imx01,
  p_index      LIKE type_file.num5,    #No.FUN-680137  SMALLINT
  p_row        LIKE type_file.num5,    #No.FUN-680137 SMALLINT
  p_cmd        LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
  li_min_num   LIKE agc_file.agc05,
  li_max_num   LIKE agc_file.agc06,
  l_index      STRING,

  l_check_res     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
  l_b2            LIKE cob_file.cob08,  #No.FUN-680137 VARCHAR(30)
  l_imaacti       LIKE ima_file.imaacti,
  l_ima130        LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
  l_ima131        LIKE ima_file.ima131,   #No.FUN-680137 VARCHAR(10)
  l_qty           LIKE img_file.img10,   #MOD-730103
  l_ima25         LIKE ima_file.ima25

  #這個欄位一旦進入了就不能忽略，因為要保証在輸入其他欄位之前必須要生成oeb04料件編號
  IF cl_null(p_value) THEN
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  END IF

  #這里使用到了一個用于存放當前屬性組包含的所有屬性信息的全局數組lr_agc
  #該數組會由t400_refresh_detail()函數在較早的時候填充

  #判斷長度與定義的使用位數是否相等
  IF LENGTH(p_value CLIPPED) <> lr_agc[p_index].agc03 THEN
     CALL cl_err_msg("","aim-911",lr_agc[p_index].agc03,1)
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  END IF
  #比較大小是否在合理范圍之內
  LET li_min_num = lr_agc[p_index].agc05
  LET li_max_num = lr_agc[p_index].agc06
  IF (lr_agc[p_index].agc05 IS NOT NULL) AND
     (p_value < li_min_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  END IF
  IF (lr_agc[p_index].agc06 IS NOT NULL) AND
     (p_value > li_max_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  END IF
  #通過了欄位檢查則可以下面的合成子料件代碼以及相應的檢核操作了
  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL t400_check_oeb04('imx' || l_index ,p_row,p_cmd)
    RETURNING l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
             ,l_qty   #MOD-730103 add
    RETURN l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
END FUNCTION

#用于att01_c~att10_c這十個選擇型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可
#與t400_check_oeb04相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION t400_check_att0x_c(p_value,p_index,p_row,p_cmd)
DEFINE
  p_value  LIKE imx_file.imx01,
  p_index  LIKE type_file.num5,    #No.FUN-680137 SMALLINT
  p_row    LIKE type_file.num5,    #No.FUN-680137 SMALLINT
  p_cmd    LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
  l_index  STRING,

  l_check_res     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
  l_b2            LIKE cob_file.cob08,    #No.FUN-680137 VARCHAR(30)
  l_imaacti       LIKE ima_file.imaacti,
  l_ima130        LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
  l_ima131        LIKE ima_file.ima131,  #No.FUN-680137 VARCHAR(10)
  l_qty           LIKE img_file.img10,    #MOD-730103
  l_ima25         LIKE ima_file.ima25



  #這個欄位一旦進入了就不能忽略，因為要保証在輸入其他欄位之前必須要生成oeb04料件編號
  IF cl_null(p_value) THEN
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  END IF
  #下拉框選擇項相當簡單，不需要進行范圍和長度的判斷，因為肯定是符合要求的了
  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL t400_check_oeb04('imx'||l_index,p_row,p_cmd)
    RETURNING l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
             ,l_qty   #MOD-730103 add
  RETURN l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
END FUNCTION


FUNCTION t400_chk_oea00(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   IF NOT cl_null(g_oea.oea00) THEN
      IF g_oea.oea00 NOT MATCHES '[0123467A89]' THEN   #No.FUN-610053 #FUN-610055     #FUN-690044   #No.FUN-740016
         RETURN FALSE
      END IF
      IF g_oea.oea00 = '4' THEN
         LET g_oea.oea11 = '7'
         DISPLAY BY NAME g_oea.oea11
      END IF
      # 多角貿易
      IF g_oea901='Y' THEN
         IF g_oea.oea00 NOT MATCHES '[126]' THEN
            RETURN FALSE
         END IF   #FUN-610055
      END IF

   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_bfd_oea05()
   IF cl_null(g_oea.oea05) THEN
      SELECT occ08 INTO g_oea.oea05 FROM occ_file
       WHERE occ01 = g_oea.oea03
      DISPLAY BY NAME g_oea.oea05
   END IF
END FUNCTION

FUNCTION t400_chk_oea08()
   IF NOT cl_null(g_oea.oea08) THEN
      IF g_oea.oea08 NOT MATCHES '[123]' THEN
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea01()
   DEFINE li_result    LIKE type_file.num5        #No.FUN-550052  #No.FUN-680137 SMALLINT
            IF NOT  cl_null(g_oea.oea01) THEN
               LET g_t1=s_get_doc_no(g_oea.oea01)

               #得到該單別對應的屬性群組
               IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' ) THEN
                  #讀取oay_file中指定作業對應的默認屬性群組
                  SELECT oay22 INTO lg_oay22 FROM oay_file WHERE oayslip = g_t1
                  #刷新界面顯示
                  CALL t400_refresh_detail()
               ELSE
                  LET lg_oay22 = ''
               END IF

               #檢查單別
#No.FUN-A40041 --begin
  	       CASE WHEN g_oea.oea00 = '0' CALL s_check_no("axm",g_oea.oea01,g_oea_t.oea01,"20","oea_file","oea01","") RETURNING li_result,g_oea.oea01 #合約單別
  	            WHEN g_oea.oea00 = '1' CALL s_check_no("axm",g_oea.oea01,g_oea_t.oea01,"30","oea_file","oea01","") RETURNING li_result,g_oea.oea01 #訂單單別
  	            WHEN g_oea.oea00 = 'A' CALL s_check_no("axm",g_oea.oea01,g_oea_t.oea01,"30","oea_file","oea01","") RETURNING li_result,g_oea.oea01 #訂單單別  #No.FUN-610053
  	            WHEN g_oea.oea00 = '2' CALL s_check_no("axm",g_oea.oea01,g_oea_t.oea01,"32","oea_file","oea01","") RETURNING li_result,g_oea.oea01 #換貨訂單
  	            WHEN g_oea.oea00 MATCHES '[37]' CALL s_check_no("axm",g_oea.oea01,g_oea_t.oea01,"33","oea_file","oea01","") RETURNING li_result,g_oea.oea01   #No.FUn-610055
  	            WHEN g_oea.oea00 = '4' CALL s_check_no("axm",g_oea.oea01,g_oea_t.oea01,"34","oea_file","oea01","") RETURNING li_result,g_oea.oea01
  	            WHEN g_oea.oea00 = '6' CALL s_check_no("axm",g_oea.oea01,g_oea_t.oea01,"30","oea_file","oea01","") RETURNING li_result,g_oea.oea01 #代送訂單單別  #No.FUN-610055
  	            WHEN g_oea.oea00 = '8' CALL s_check_no("axm",g_oea.oea01,g_oea_t.oea01,"22","oea_file","oea01","") RETURNING li_result,g_oea.oea01   #No.FUN-740016
  	            WHEN g_oea.oea00 = '9' CALL s_check_no("axm",g_oea.oea01,g_oea_t.oea01,"22","oea_file","oea01","") RETURNING li_result,g_oea.oea01   #No.FUN-740016
# 	       CASE WHEN g_oea.oea00 = '0' CALL s_check_no(g_sys,g_oea.oea01,g_oea_t.oea01,"20","oea_file","oea01","") RETURNING li_result,g_oea.oea01 #合約單別
# 	            WHEN g_oea.oea00 = '1' CALL s_check_no(g_sys,g_oea.oea01,g_oea_t.oea01,"30","oea_file","oea01","") RETURNING li_result,g_oea.oea01 #訂單單別
# 	            WHEN g_oea.oea00 = 'A' CALL s_check_no(g_sys,g_oea.oea01,g_oea_t.oea01,"30","oea_file","oea01","") RETURNING li_result,g_oea.oea01 #訂單單別  #No.FUN-610053
# 	            WHEN g_oea.oea00 = '2' CALL s_check_no(g_sys,g_oea.oea01,g_oea_t.oea01,"32","oea_file","oea01","") RETURNING li_result,g_oea.oea01 #換貨訂單
# 	            WHEN g_oea.oea00 MATCHES '[37]' CALL s_check_no(g_sys,g_oea.oea01,g_oea_t.oea01,"33","oea_file","oea01","") RETURNING li_result,g_oea.oea01   #No.FUn-610055
# 	            WHEN g_oea.oea00 = '4' CALL s_check_no(g_sys,g_oea.oea01,g_oea_t.oea01,"34","oea_file","oea01","") RETURNING li_result,g_oea.oea01
# 	            WHEN g_oea.oea00 = '6' CALL s_check_no(g_sys,g_oea.oea01,g_oea_t.oea01,"30","oea_file","oea01","") RETURNING li_result,g_oea.oea01 #代送訂單單別  #No.FUN-610055
# 	            WHEN g_oea.oea00 = '8' CALL s_check_no(g_sys,g_oea.oea01,g_oea_t.oea01,"22","oea_file","oea01","") RETURNING li_result,g_oea.oea01   #No.FUN-740016
# 	            WHEN g_oea.oea00 = '9' CALL s_check_no(g_sys,g_oea.oea01,g_oea_t.oea01,"22","oea_file","oea01","") RETURNING li_result,g_oea.oea01   #No.FUN-740016
#No.FUN-A40041 --end
  	       END CASE
           IF (NOT li_result) THEN
              LET g_oea.oea01=g_oea_o.oea01
              RETURN FALSE
           END IF
  	       DISPLAY BY NAME g_oay.oaydesc                  #MOD-9C0388 remark

#..............check是否須簽核處理....................................
               SELECT oayapr,oaysign
                 INTO g_oea.oeamksg,g_oea.oeasign
                 FROM oay_file WHERE oayslip = g_t1
               IF cl_null(g_oea.oeamksg) THEN
                  LET g_oea.oeamksg='N'
                  LET g_oea.oeasign=' '
               END IF
               IF cl_null(g_oea.oeasign) THEN LET g_oea.oeasign=' ' END IF
               DISPLAY BY NAME g_oea.oeamksg
#....................................................................
            ELSE
               IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
                  LET lg_oay22 = ''
                  CALL t400_refresh_detail()
               END IF
            END IF
            RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea11(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   IF g_oea.oea11 ='1' THEN
       CALL cl_getmsg('axm-905',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb71",g_msg CLIPPED)
   END IF
   IF g_oea.oea11 !='1' THEN
       CALL cl_getmsg('axm-906',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb71",g_msg CLIPPED)
   END IF
   # 增加'7.境外倉出貨'選項
   IF NOT cl_null(g_oea.oea11) THEN
       IF g_oea.oea11 NOT MATCHES '[1234578]' THEN  #No.FUN-610053   #MOD-6A0171 add   #No.FUN-740016
         RETURN FALSE
      END IF
      IF g_oea.oea00 !='4' AND g_oea.oea11='7' THEN
         RETURN FALSE
      END IF
      IF g_oea.oea11='1' THEN
         LET g_oea.oea12=NULL
         DISPLAY BY NAME g_oea.oea12
      END IF
      #  多角 oea11 matches '1-5'
      IF g_oea901 = 'Y' THEN
         IF g_oea.oea11 NOT MATCHES '[12345]' THEN
            RETURN FALSE
         END IF
      END IF
      IF g_oea.oea11='6' THEN
         CALL cl_err('','axm-990',0)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea12_0()
   LET l_t1 = s_get_doc_no(g_oea.oea12)
   IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') THEN
      #讀取oay_file中指定作業對應的默認屬性群組
      SELECT oay22 INTO lg_oay221 FROM oay_file WHERE oayslip = l_t1
      IF NOT cl_null(g_oea.oea01) THEN
         IF lg_oay221 <> lg_oay22 THEN
            CALL cl_err(g_oea.oea12,'axm-057',0)
            RETURN FALSE
         END IF
         IF (cl_null(lg_oay221) AND NOT cl_null(lg_oay22)) OR
            (NOT cl_null(lg_oay221) AND cl_null(lg_oay22)) THEN
            CALL cl_err(g_oea.oea12,'axm-057',0)
            RETURN FALSE
         END IF
      END IF
   ELSE
      LET lg_oay221 = ''
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea12()
   DEFINE l_oea        RECORD LIKE oea_file.*
   DEFINE l_oha        RECORD LIKE oha_file.*
   DEFINE l_ogb12_tot  LIKE ogb_file.ogb12,   #MOD-9B0185
          l_oeb12_tot  LIKE oeb_file.oeb12    #MOD-9B0185
   DEFINE l_cnt        LIKE type_file.num5    #MOD-A30087

   IF NOT cl_null(g_oea.oea12) THEN
      LET g_t1 = s_get_doc_no(g_oea.oea12)
      IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') THEN
         #讀取oay_file中指定作業對應的默認屬性群組
         SELECT oay22 INTO lg_oay221 FROM oay_file WHERE oayslip = g_t1
         IF NOT cl_null(g_oea.oea01) THEN
            IF lg_oay221 <> lg_oay22 THEN
               CALL cl_err(g_oea.oea12,'axm-057',0)
               RETURN FALSE
            END IF
            IF (cl_null(lg_oay221) AND NOT cl_null(lg_oay22)) OR
               (NOT cl_null(lg_oay221) AND cl_null(lg_oay22)) THEN
               CALL cl_err(g_oea.oea12,'axm-057',0)
               RETURN FALSE
            END IF
         END IF
      ELSE
         LET lg_oay221 = ''
      END IF

      IF g_aza.aza50 = 'Y' THEN  
         IF g_oea.oea11='3' THEN
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM tqp_file,tqq_file
             WHERE tqq01 = tqq01
#              AND tqq03 =g_oea.oea03  #TQC-AB0045
               AND tqpacti ='Y'
               AND tqp04 ='3'
               AND tqq06 =g_plant
               AND tqp01 =g_oea.oea12

            IF g_cnt =0 THEN
               CALL cl_err(g_oea.oea12,'atm-515',1)
               RETURN FALSE
            END IF
         END IF
         #TQC-AB0368 add ------------------------------begin-------------------------------
         IF g_oea.oea11='8' THEN  
            SELECT * INTO l_oea.* FROM oea_file
             WHERE oea01 = g_oea.oea12
            IF SQLCA.SQLCODE THEN    
               CALL cl_err3("sel","oea_file",g_oea.oea12,"",STATUS,"","select oea",1)
               RETURN FALSE
            END IF

            IF l_oea.oeaconf='N' THEN
               CALL cl_err(l_oea.oeaconf,'9029',0)
               RETURN FALSE
            END IF

            LET l_oea.oea00 = g_oea.oea00
            LET l_oea.oea01 = g_oea.oea01
            LET l_oea.oea02 = g_oea.oea02
            LET l_oea.oea11 = g_oea.oea11
            LET l_oea.oea12 = g_oea.oea12
            LET l_oea.oeaconf = 'N'
            LET l_oea.oea49='0'
            LET g_oea.* = l_oea.*
            IF g_oea901 = 'Y' THEN
               LET g_oea.oea901 = 'Y'
               LET g_oea.oea902 = 'N'
               LET g_oea.oea905 = 'N'
               LET g_oea.oea906 = 'Y'
            END IF
            DISPLAY BY NAME g_oea.oea03,g_oea.oea032,
                            g_oea.oea04,g_oea.oea17,
                            g_oea.oea1015,g_oea.oea14,g_oea.oea15,
                            g_oea.oea14,g_oea.oea15,g_oea.oea1002,
                            g_oea.oea1003,g_oea.oea23,g_oea.oea21,
                            g_oea.oea31,g_oea.oea32,g_oea.oea161,
                            g_oea.oea162,g_oea.oea163,g_oea.oea261,
                            g_oea.oea262,g_oea.oea263,g_oea.oea1011

            
         END IF
         #TQC-AB0368 add -------------------------------end--------------------------------
      ELSE  
         IF g_oea.oea11='3' OR g_oea.oea11='8' THEN   #No.FUN-740016 #MOD-6A0171 mark OR g_oea.oea11="A" THEN
            SELECT * INTO l_oea.* FROM oea_file
             WHERE oea01 = g_oea.oea12
            IF SQLCA.SQLCODE THEN    #FUN-610055
               CALL cl_err3("sel","oea_file",g_oea.oea12,"",STATUS,"","select oea",1)  #No.FUN-650108
               RETURN FALSE
            END IF

            IF l_oea.oeaconf='N' THEN
               CALL cl_err(l_oea.oeaconf,'9029',0)
               RETURN FALSE
            END IF

            LET l_oea.oea00 = g_oea.oea00
            LET l_oea.oea01 = g_oea.oea01
            LET l_oea.oea02 = g_oea.oea02
            LET l_oea.oea11 = g_oea.oea11
            LET l_oea.oea12 = g_oea.oea12
            LET l_oea.oeaconf = 'N'
            LET l_oea.oea49='0'
            LET g_oea.* = l_oea.*
            IF g_oea901 = 'Y' THEN
               LET g_oea.oea901 = 'Y'
               LET g_oea.oea902 = 'N'
               LET g_oea.oea905 = 'N'
               LET g_oea.oea906 = 'Y'
            END IF
            #TQC-AB0286 add -------------begin----------------
            DISPLAY BY NAME g_oea.oea03,g_oea.oea032,
                            g_oea.oea04,g_oea.oea17,
                            g_oea.oea1015,g_oea.oea14,g_oea.oea15,
                            g_oea.oea14,g_oea.oea15,g_oea.oea1002,
                            g_oea.oea1003,g_oea.oea23,g_oea.oea21,
                            g_oea.oea31,g_oea.oea32,g_oea.oea161,
                            g_oea.oea162,g_oea.oea163,g_oea.oea261,
                            g_oea.oea262,g_oea.oea263,g_oea.oea1011

            #TQC-AB0286 add ---------------end----------------
         END IF
     END IF

      #-----MOD-A30087---------
      IF g_oea.oea11 <> g_oea_o.oea11 OR g_oea.oea12 <> g_oea_o.oea12 THEN
         IF g_oea.oea11='3' THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM oeb_file
              WHERE oeb01=g_oea.oea01
            IF l_cnt > 0 THEN
               IF cl_confirm('axm-388') THEN
                  DELETE FROM oeb_file WHERE oeb01=g_oea.oea01
               ELSE
                  RETURN FALSE
               END IF
            END IF
         END IF
      END IF
      #-----END MOD-A30087-----

      IF g_oea.oea11='2' THEN
         IF NOT cl_null(g_oea.oea12) THEN
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM oea_file
             WHERE oea12=g_oea.oea12
               AND oea11=g_oea.oea11
               AND oeaconf !='X'
               AND oea01 <> g_oea.oea01
            IF g_cnt > 0 THEN
               CALL cl_err(g_cnt,'axm-602',1)
               RETURN FALSE #CHI-6A0054 add
            END IF
            SELECT * INTO l_oha.* FROM oha_file
             WHERE oha01=g_oea.oea12
               AND ohaconf = 'Y' #01/08/17 mandy
            IF SQLCA.SQLCODE THEN    #FUN-610055
               CALL cl_err3("sel","oha_file",g_oea.oea12,"","axm-361","","",1)  #No.FUN-650108
               RETURN FALSE
            END IF
            LET g_oea.oea00=g_oea.oea11
            IF g_aza.aza50 = 'N' THEN  #No.FUN-650108
               LET g_oea.oea03=l_oha.oha03
            END IF   #No.FUN-650108
            LET g_oea.oea04=l_oha.oha03
            LET g_oea.oea14=l_oha.oha14
            LET g_oea.oea15=l_oha.oha15
            LET g_oea.oea23=l_oha.oha23
            LET g_oea.oea21=l_oha.oha21
            LET g_oea.oea211=l_oha.oha211
            LET g_oea.oea212=l_oha.oha212
            LET g_oea.oea213=l_oha.oha213
            LET g_oea.oea25=l_oha.oha25
            LET g_oea.oea31=l_oha.oha31
            IF g_aza.aza50 = 'Y' THEN  #No.FUN-650108
               LET g_oea.oea17=l_oha.oha1001
               LET g_oea.oea1011=l_oha.oha1011
               LET g_oea.oea03=l_oha.oha1016
            END IF   #No.FUN-650108
            SELECT occ45 INTO g_oea.oea32  #收款條件
              FROM occ_file
             WHERE occ01=g_oea.oea03
               AND occacti='Y'
            IF g_oea.oea08='1' THEN
               LET exT=g_oaz.oaz52
            ELSE
               LET exT=g_oaz.oaz70
            END IF
            CALL s_curr3(g_oea.oea23,g_oea.oea02,exT)
                        RETURNING g_oea.oea24
         END IF
      END IF
      IF g_oea.oea11='4' THEN
         IF NOT cl_null(g_oea.oea12) THEN
            SELECT * FROM oqa_file WHERE oqa01 = g_oea.oea12
                                     AND oqaconf='Y'
            IF SQLCA.SQLCODE THEN   #FUN-610055
               #無此估價單或此估價單未確認!
               CALL cl_err3("sel","oqa_file",g_oea.oea12,"","axm-006","","select oqa",1)  #No.FUN-650108
               RETURN FALSE
            ELSE
               CALL t400_oqa()
            END IF
         END IF
      END IF
      IF g_oea.oea11='5' THEN
         IF NOT cl_null(g_oea.oea12) THEN
            SELECT * FROM oqt_file WHERE oqt01=g_oea.oea12
                                     AND oqtconf='Y'
            IF SQLCA.SQLCODE THEN  #FUN-610055
               #無此報價單或此報價單未確認!
               CALL cl_err3("sel","oqt_file",g_oea.oea12,"","axm-010","","select oqt",1)  #No.FUN-650108
               RETURN FALSE
            ELSE
               CALL t400_oqt()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('select oqt',g_errno,0)
                  RETURN FALSE
               END IF
            END IF
         END IF
      END IF
      IF g_oea.oea11='7' THEN
         IF NOT cl_null(g_oea.oea12) THEN
            SELECT * FROM oga_file WHERE oga01  = g_oea.oea12
                                     AND ogaconf= 'Y'
                                     AND oga00  = '3' #出至境外倉
            IF SQLCA.SQLCODE THEN  #FUN-610055
               CALL cl_err3("sel","oga_file",g_oea.oea12,"","abx-002","","sel oga:",1)  #No.FUN-650108
               RETURN FALSE
            ELSE
               SELECT SUM(ogb12) INTO l_ogb12_tot
                 FROM ogb_file WHERE ogb01=g_oea.oea12
               IF cl_null(l_ogb12_tot) THEN LET l_ogb12_tot = 0 END IF
               SELECT SUM(oeb12) INTO l_oeb12_tot
                 FROM oea_file,oeb_file
                WHERE oea01 = oeb01
                  AND oeaconf <> 'X'
                  AND oea12 = g_oea.oea12
                  AND oea01 <> g_oea.oea01
               IF cl_null(l_oeb12_tot) THEN LET l_oeb12_tot = 0 END IF
               IF l_ogb12_tot <= l_oeb12_tot THEN
                  CALL cl_err('','axm-380',0)
                  RETURN FALSE
               ELSE
                  CALL t400_oga()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('sel oga:',g_errno,0)
                     RETURN FALSE
                  END IF
               END IF   #MOD-9B0185
            END IF
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea03(p_cmd)
   DEFINE l_occ        RECORD LIKE occ_file.*
   DEFINE p_cmd        LIKE type_file.chr1
   DEFINE l_cnt        LIKE type_file.num5           #No.FUN-890011
   
   IF NOT cl_null(g_oea.oea03) THEN  #No.FUN-650108
      IF g_oea.oea11 = '4' OR g_oea.oea11 = '5' THEN
         SELECT COUNT(*) INTO l_cnt FROM occ_file
          WHERE occ01=g_oea.oea03
            AND occ06='1'
         IF l_cnt = 0 THEN
            CALL cl_err(g_oea.oea03,'axm518',1)
            RETURN FALSE
         END IF
      END IF
#TQC-AB0045 --begin--
      IF g_aza.aza50 = 'Y' THEN
         IF g_oea.oea11='3' THEN
            LET l_cnt=0
            SELECT COUNT(*) INTO l_cnt FROM tqp_file,tqq_file
             WHERE tqq01 = tqq01
               AND tqq03 =g_oea.oea03 
               AND tqpacti ='Y'
               AND tqp04 ='3'
               AND tqq06 =g_plant
               AND tqp01 =g_oea.oea12
            IF l_cnt =0 THEN
               CALL cl_err(g_oea.oea12,'atm-517',1)
               RETURN FALSE
            END IF    
         END IF
      END IF
#TQC-AB0045 --end--   
      IF g_aza.aza50 = 'Y' THEN      #No.FUN-650108
         SELECT * INTO l_occ.* FROM occ_file
          WHERE occ01=g_oea.oea03
            AND occ06='1'
         #分情況顯示錯誤訊息
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_oea.oea03,'axm-187',0)
            RETURN FALSE
         END IF
      ELSE
         SELECT * INTO l_occ.* FROM occ_file
          WHERE occ01=g_oea.oea03
         #分情況顯示錯誤訊息
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_oea.oea03,'axm-187',0)
            RETURN FALSE
         END IF
         IF l_occ.occacti = 'N' THEN
            CALL cl_err(g_oea.oea03,'axm-189',0)
            RETURN FALSE
         END IF
         #-----MOD-AB0018---------
         IF l_occ.occ1004!='1' THEN    
            CALL cl_err(g_oea.oea03,'axm-496',0) 
            RETURN FALSE    
         END IF
         #-----END MOD-AB0018-----
         IF g_azw.azw04='2' THEN
            IF l_occ.occ930 = g_plant THEN
               CALL cl_err('','art-444',0)
               RETURN FALSE
            END IF
         END IF
      END IF
      #已在上面分情況顯示錯誤訊息了，所以mark此處
      IF g_aza.aza50 = 'Y' THEN  #No.FUN-650108
         IF l_occ.occacti='N' THEN
            CALL cl_err('select occ',9028,0) RETURN FALSE
         END IF
         IF l_occ.occ1004!='1' THEN        #No.FUN-690025
            #CALL cl_err('select occ',9029,0) RETURN FALSE     #MOD-A80149
            CALL cl_err('select occ','axm-496',0) RETURN FALSE     #MOD-A80149
         END IF
      END IF  #No.FUN-650108
      IF g_oea.oea03[1,4] != 'MISC' THEN
         LET g_oea.oea032 = l_occ.occ02
         DISPLAY BY NAME g_oea.oea032
      END IF
      IF ((g_oea.oea11 = '1')
         OR (g_oea.oea11 = '7')) #FUN-570020
         AND (p_cmd = 'a' OR g_oea.oea03 != g_oea_t.oea03) THEN
            LET g_oea.oea04 = l_occ.occ09
            DISPLAY BY NAME g_oea.oea04
            LET g_oea.oea17 = l_occ.occ07  #FUN-610055
         IF cl_null(g_oea.oea05) THEN
            LET g_oea.oea05 = l_occ.occ08 DISPLAY BY NAME g_oea.oea05
         END IF
         # 人員帶出客戶主檔中設定的人
         IF  l_occ.occ04  IS  NOT  NULL  AND
             NOT cl_null(l_occ.occ04) THEN
             LET  g_oea.oea14  =  l_occ.occ04
         END IF
         SELECT gen03 INTO g_oea.oea15 FROM gen_file
               WHERE gen01=g_oea.oea14 DISPLAY BY NAME g_oea.oea15
         LET g_oea.oea21 = l_occ.occ41 DISPLAY BY NAME g_oea.oea21
         SELECT gec04,gec05,gec07
           INTO g_oea.oea211,g_oea.oea212,g_oea.oea213
           FROM gec_file WHERE gec01=g_oea.oea21
                           AND gec011='2'  #銷項
         DISPLAY BY NAME g_oea.oea211,g_oea.oea212,g_oea.oea213
         IF g_aza.aza50 = 'N' THEN  #No.FUN-650108
            LET g_oea.oea23 = l_occ.occ42 DISPLAY BY NAME g_oea.oea23   #No.FUN-610055
         END IF  #No.FUN-650108
         LET g_oea.oea25 = l_occ.occ43 DISPLAY BY NAME g_oea.oea25
         LET g_oea.oea31 = l_occ.occ44 DISPLAY BY NAME g_oea.oea31
         LET g_oea.oea80 = l_occ.occ68 DISPLAY BY NAME g_oea.oea80      #FUN-840183
         LET g_oea.oea81 = l_occ.occ69 DISPLAY BY NAME g_oea.oea81      #FUN-840183
         IF g_aza.aza50 = 'N' THEN  #No.FUN-650108
            LET g_oea.oea32 = l_occ.occ45 DISPLAY BY NAME g_oea.oea32   #No.FUN-610055
         END IF  #No.FUN-650108
         LET g_oea.oea33 = l_occ.occ46
         LET g_oea.oea34 = l_occ.occ53
         LET g_oea.oea41 = l_occ.occ48
         LET g_oea.oea42 = l_occ.occ49
         LET g_oea.oea43 = l_occ.occ47
         IF g_oea.oea901='Y' THEN
            LET g_oea.oea65='N'
         ELSE
            LET g_oea.oea65 = l_occ.occ65  #No.FUN-610056
         END IF
         IF g_aza.aza50 = 'Y' THEN  #No.FUN-650108
            LET g_oea.oea04 = l_occ.occ09
            LET g_oea.oea1011=l_occ.occ1022
            LET g_oea.oea17=l_occ.occ07     #No.FUN-650108
            LET g_oea.oea1009=l_occ.occ1006
            LET g_oea.oea1010=l_occ.occ1005
            LET g_oea.oea1003=l_occ.occ1024
            IF g_oea.oea00 ='7' THEN
               #LET g_oea.oea1015=l_occ.occ1029   #MOD-AA0128
               LET g_oea.oea1015=l_occ.occ66   #MOD-AA0128
            ELSE
               LET g_oea.oea1015=NULL
               CALL t400_oea1015('d')
            END IF
            DISPLAY BY NAME g_oea.oea04
            DISPLAY BY NAME g_oea.oea1011
            DISPLAY BY NAME g_oea.oea17
            DISPLAY BY NAME g_oea.oea1009
            DISPLAY BY NAME g_oea.oea1010
            DISPLAY BY NAME g_oea.oea1003
            IF NOT cl_null(g_oea.oea03) AND NOT cl_null(g_oea.oea1002)
               AND NOT cl_null(g_oea.oea17) THEN
                SELECT tqk04,tqk05 INTO g_oea.oea32,g_oea.oea23 FROM tqk_file
                 WHERE tqk01 =g_oea.oea03
                   AND tqk02 =g_oea.oea1002
                   AND tqk03 =g_oea.oea17
                   AND tqkacti ='Y'
                IF g_oea.oea08='1' THEN
                   LET exT=g_oaz.oaz52
                ELSE
                   LET exT=g_oaz.oaz70
                END IF
                CALL s_curr3(g_oea.oea23,g_oea.oea02,exT) RETURNING g_oea.oea24
            END IF
         ELSE  #No.FUN-650108
           #不使用流通配銷功能時,也需要用到代送商功能,所以一樣要Default帶出
            IF g_oea.oea00 ='7' THEN
               LET g_oea.oea1015=l_occ.occ66
            ELSE
               LET g_oea.oea1015=NULL
               CALL t400_oea1015('d')
            END IF
            IF g_oea.oea08='1' THEN
               LET exT=g_oaz.oaz52
            ELSE
               LET exT=g_oaz.oaz70
            END IF
            CALL s_curr3(g_oea.oea23,g_oea.oea02,exT) RETURNING g_oea.oea24
         END IF  #No.FUN-650108
      END IF
      IF g_aza.aza50 = 'Y' THEN  #No.FUN-650108
         IF NOT cl_null(g_oea.oea1004) THEN
            IF g_oea.oea03=g_oea.oea1004 THEN
               CALL cl_err('','atm-252',0)
               RETURN FALSE
            END IF
         END IF
      END IF  #No.FUN-650108
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION T400_chk_oea04(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   DEFINE l_occ66 LIKE occ_file.occ66

   IF NOT cl_null(g_oea.oea04) THEN
      IF p_cmd = 'a' OR g_oea.oea04 != g_oea_t.oea04
         OR g_oea_t.oea01 IS NULL THEN
            IF NOT (g_oea.oea11='5' AND NOT cl_null(g_oea.oea044) ) THEN   #CHI-B30081
               LET g_oea.oea044=NULL
               LET g_oap.oap041=NULL
               LET g_oap.oap042=NULL
               LET g_oap.oap043=NULL
               LET g_oap.oap044=NULL    #FUN-720014
               LET g_oap.oap045=NULL    #FUN-720014
               CALL s_addr(g_oea.oea01,g_oea.oea04,g_oea.oea044)
                    RETURNING g_oap.oap041,
                              g_oap.oap042,
                              g_oap.oap043,
                              g_oap.oap044,   #FUN-720014
                              g_oap.oap045    #FUN-720014
               DISPLAY g_oea.oea044 TO oea044
               DISPLAY g_oap.oap041 TO oap041
               DISPLAY g_oap.oap042 TO oap042
               DISPLAY g_oap.oap043 TO oap043
               DISPLAY g_oap.oap044 TO oap044
               DISPLAY g_oap.oap045 TO oap045
            END IF   #CHI-B30081
      END IF
      SELECT occ02,occ66 INTO g_buf,l_occ66
        FROM occ_file
       WHERE occ01=g_oea.oea04
         AND occacti = 'Y'
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("sel","occ_file",g_oea.oea04,"",STATUS,"","select occ",1)  #No.FUN-650108
         RETURN FALSE
      END IF
      DISPLAY g_buf TO occ02
      IF g_oea.oea00 MATCHES '[01]' THEN #FUN-710037
         LET g_oea.oea1015=l_occ66
      ELSE
         IF g_oea.oea00 <> '7' THEN
            LET g_oea.oea1015=NULL
         END IF
      END IF
      CALL t400_oea1015('d')
      DISPLAY BY NAME g_oea.oea1015
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea14(p_cmd)       #TQC-B10013
 DEFINE p_cmd    LIKE type_file.chr1 #TQC-B10013

   IF NOT cl_null(g_oea.oea14) THEN
      SELECT gen02 INTO g_buf FROM gen_file
       WHERE gen01=g_oea.oea14
      IF SQLCA.SQLCODE THEN  #FUN-610055
         CALL cl_err3("sel","gen_file",g_oea.oea14,"",STATUS,"","select gen",1)  #No.FUN-650108
         RETURN FALSE
      END IF
      DISPLAY g_buf TO gen02
      IF p_cmd <> 'd' THEN #TQC-B10013
         IF g_oea.oea14 != g_oea_t.oea14 OR cl_null(g_oea_t.oea14) THEN
            SELECT gen03 INTO g_oea.oea15 FROM gen_file
             WHERE gen01=g_oea.oea14
            DISPLAY BY NAME g_oea.oea15
        END IF
      END IF               #TQC-B10013
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_oea1015(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
       l_pmc03   LIKE pmc_file.pmc03,
       l_pmcacti LIKE pmc_file.pmcacti

   LET g_errno = ' '

   SELECT pmc03,pmcacti
     INTO l_pmc03,l_pmcacti
     FROM pmc_file
    WHERE pmc01 = g_oea.oea1015
      AND pmc14 = '6'

   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-000'
                                 LET l_pmc03 = ''
        WHEN l_pmcacti = 'N'     LET g_errno = '9028'
        WHEN l_pmcacti MATCHES '[PH]'  LET g_errno = '9038'   #No.FUN-690024  add
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE

   IF cl_null(g_errno) OR p_cmd='d' THEN
      DISPLAY l_pmc03 TO FORMONLY.oea1015_occ02
   END IF
END FUNCTION

FUNCTION t400_chk_oea15()
   IF NOT cl_null(g_oea.oea15) THEN
      SELECT gem02 INTO g_buf FROM gem_file
       WHERE gem01=g_oea.oea15
         AND gemacti='Y'   #NO:6950
      IF SQLCA.SQLCODE THEN  #FUN-610055
         CALL cl_err3("sel","gem_file",g_oea.oea15,"",STATUS,"","select gem",1)  #No.FUN-650108
         RETURN FALSE
      END IF
      DISPLAY g_buf TO gem02
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea1015()
   IF NOT cl_null(g_oea.oea1015) THEN
      CALL t400_oea1015('a')
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_oea.oea1015,g_errno,0)
         LET g_oea.oea1015 = g_oea_t.oea1015
         RETURN FALSE
      END IF
   ELSE                                      #CHI-690060 add
      DISPLAY '' TO FORMONLY.oea1015_occ02   #CHI-690060 add
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea1004()
   DEFINE l_occ1004 LIKE occ_file.occ1004
   DEFINE l_occacti LIKE occ_file.occacti

   IF NOT cl_null(g_oea.oea1004) THEN
      IF g_aza.aza50 = 'Y' THEN  #No.FUN-650108
         IF NOT cl_null(g_oea.oea03) THEN
            IF g_oea.oea03=g_oea.oea1004 THEN
               CALL cl_err('','atm-252',0)
               RETURN FALSE
            END IF
         END IF
      END IF  #No.FUN-650108
      SELECT occ02,occ1004,occacti
        INTO g_buf,l_occ1004,l_occacti
        FROM occ_file
       WHERE occ01=g_oea.oea1004
         AND occ06='1'
      IF SQLCA.SQLCODE THEN  #FUN-610055
         CALL cl_err3("sel","occ_file",g_oea.oea1004,"",STATUS,"","select occ",1)  #No.FUN-650108
         RETURN FALSE
      END IF
      IF l_occacti='N' THEN
         CALL cl_err('select occ',9028,0) RETURN FALSE
      END IF
      IF l_occ1004!='1' THEN            #No.FUN-690025
         #CALL cl_err('select occ',9029,0) RETURN FALSE     #MOD-A80149
         CALL cl_err('select occ','axm-496',0) RETURN FALSE     #MOD-A80149
      END IF
      DISPLAY g_buf TO occ02_a
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea23(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   IF NOT cl_null(g_oea.oea23) THEN
      SELECT azi02,azi03,azi04 INTO g_buf,t_azi03,t_azi04                #No.CHI-6A0004
             FROM azi_file WHERE azi01=g_oea.oea23
      IF SQLCA.SQLCODE THEN  #FUN-610055
         CALL cl_err3("sel","azi_file",g_oea.oea23,"",STATUS,"","select azi",1)  #No.FUN-650108
         RETURN FALSE
      END IF
      IF (g_oea.oea23 <> g_oea_o.oea23) THEN
          SELECT COUNT(*) INTO g_cnt FROM oeb_file
           WHERE oeb01 = g_oea.oea01
           IF g_cnt > 0 THEN
           #確定是你要變更的幣別嗎?
               IF NOT cl_confirm2('axm-918',g_oea.oea23) THEN
                   LET g_oea.oea23=g_oea_o.oea23
                   DISPLAY BY NAME g_oea.oea23
                   RETURN FALSE
               END IF
           END IF
      END IF
      IF p_cmd='a' OR (p_cmd='u' AND g_oea.oea23<> g_oea_o.oea23) THEN
         IF g_oea.oea08='1' THEN
            LET exT=g_oaz.oaz52
         ELSE
            LET exT=g_oaz.oaz70
         END IF
         CALL s_curr3_flagon()
         LET g_errno=NULL
         CALL s_curr3(g_oea.oea23,g_oea.oea02,exT) RETURNING g_oea.oea24
         CALL s_curr3_flagoff()
         IF NOT cl_null(g_errno) THEN
            CALL cl_err('','axm-084',1)
            RETURN FALSE
         END IF
      END IF
   END IF
   IF cl_null(g_oea.oea24) THEN LET g_oea.oea24=0 END IF
   LET g_oea_o.oea23=g_oea.oea23   #No.+050
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea21(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   DEFINE l_oeb        RECORD LIKE oeb_file.* #MOD-530193 add
   DEFINE l_gecacti    LIKE gec_file.gecacti  #No.TQC-770039

   LET g_chg_oea21=FALSE  #FUN-6C0006
   IF NOT cl_null(g_oea.oea21) THEN
      SELECT gec04,gec05,gec07,gecacti                        #No.TQC-770039 add gecacti
        INTO g_oea.oea211,g_oea.oea212,g_oea.oea213,l_gecacti #No.TQC-770039 add gecacti
        FROM gec_file
       WHERE gec01=g_oea.oea21
         AND gec011='2'  #銷項
      IF SQLCA.SQLCODE THEN  #FUN-610055
         CALL cl_err3("sel","gec_file",g_oea.oea21,"",STATUS,"","select gec",1)  #No.FUN-650108
         RETURN FALSE
      END IF
      IF l_gecacti <> 'Y' THEN
         CALL cl_err('','axm-985',1)
         RETURN FALSE
      END IF
      DISPLAY BY NAME g_oea.oea211, g_oea.oea212, g_oea.oea213
      IF p_cmd = 'u' AND
         ((g_oea.oea213 != g_oea_t.oea213 OR g_oea_t.oea213 IS NULL)
         OR (g_oea.oea211 != g_oea_t.oea211 OR g_oea_t.oea211 IS NULL)) THEN
         SELECT COUNT(*) INTO g_cnt FROM oeb_file
          WHERE oeb01 = g_oea.oea01
         IF g_cnt > 0 THEN
             #確定是你要變更的稅別嗎?
             IF cl_confirm2('axm-415',g_oea.oea21) THEN
                 DECLARE oeb14_cs CURSOR FOR
                   SELECT oeb03,oeb917,oeb13 FROM oeb_file                    #CHI-7A0036--modify oeb12->oeb917
                     WHERE oeb01 = g_oea.oea01
                 FOREACH oeb14_cs INTO l_oeb.oeb03,l_oeb.oeb917,l_oeb.oeb13   #CHI-7A0036--modify oeb12->oeb917
                   IF g_oea.oea213 = 'N' THEN
                      LET l_oeb.oeb14 = l_oeb.oeb917 * l_oeb.oeb13             #CHI-7A0036--modify oeb12->oeb917
                      LET l_oeb.oeb14 = cl_digcut(l_oeb.oeb14,t_azi04)        #CHI-7A0036-add
                      LET l_oeb.oeb14t= l_oeb.oeb14 * (1+g_oea.oea211/100)
                      LET l_oeb.oeb14t= cl_digcut(l_oeb.oeb14t,t_azi04)       #CHI-7A0036-add
                   ELSE
                      LET l_oeb.oeb14t= l_oeb.oeb917 * l_oeb.oeb13
                      LET l_oeb.oeb14t= cl_digcut(l_oeb.oeb14t,t_azi04)       #CHI-7A0036-add
                      LET l_oeb.oeb14 = l_oeb.oeb14t/ (1+g_oea.oea211/100)
                      LET l_oeb.oeb14 = cl_digcut(l_oeb.oeb14,t_azi04)        #CHI-7A0036-add
                   END IF
                   UPDATE oeb_file SET oeb14 = l_oeb.oeb14,
                                       oeb14t= l_oeb.oeb14t
                    WHERE oeb01 = g_oea.oea01 AND oeb03 = l_oeb.oeb03
                   IF SQLCA.SQLCODE THEN  #FUN-610055
                      CALL cl_err3("upd","oeb_file",g_oea.oea01,l_oeb.oeb03,STATUS,"","upd oeb14:",1)  #No.FUN-650108
                      EXIT FOREACH
                   END IF
                 END FOREACH
                 LET g_chg_oea21=TRUE #FUN-6C0006
                 SELECT SUM(oeb14) INTO g_oea.oea61 FROM oeb_file
                  WHERE oeb01 = g_oea.oea01
                 CALL cl_digcut(g_oea.oea61,t_azi04) RETURNING g_oea.oea61   #CHI-7A0036-add
                 IF cl_null(g_oea.oea61) THEN LET g_oea.oea61 = 0 END IF
                 DISPLAY BY NAME g_oea.oea61
             ELSE
                 LET g_oea.oea21 = g_oea_o.oea21
                 DISPLAY BY NAME g_oea.oea21
                 RETURN FALSE
             END IF
         END IF
        END IF
   END IF
   LET g_oea_o.oea21=g_oea.oea21   #MOD-570250
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea25()
   IF NOT cl_null(g_oea.oea25) THEN
      SELECT oab02 INTO g_buf FROM oab_file
       WHERE oab01=g_oea.oea25
      IF SQLCA.SQLCODE THEN  #FUN-610055
         CALL cl_err3("sel","oab_file",g_oea.oea25,"",STATUS,"","select oab",1)  #No.FUN-650108
         RETURN FALSE
      END IF
      DISPLAY g_buf TO oab02
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea26()
   IF NOT cl_null(g_oea.oea26) THEN
      SELECT oab02 INTO g_buf FROM oab_file
       WHERE oab01=g_oea.oea26
      IF SQLCA.SQLCODE THEN  #FUN-610055
         CALL cl_err3("sel","oab_file",g_oea.oea26,"",STATUS,"","select oab",1)  #No.FUN-650108
         RETURN FALSE
      END IF
      DISPLAY g_buf TO oab02_2
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea31()
   IF NOT cl_null(g_oea.oea31) THEN
      SELECT oah02 INTO g_buf FROM oah_file
       WHERE oah01=g_oea.oea31
      IF SQLCA.SQLCODE THEN  #FUN-610055
         CALL cl_err3("sel","oah_file",g_oea.oea31,"",STATUS,"","select oah",1)  #No.FUN-650108
         RETURN FALSE
      END IF
      DISPLAY g_buf TO oah02
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea32()
   IF NOT cl_null(g_oea.oea32) THEN
      SELECT oag02 INTO g_buf FROM oag_file
       WHERE oag01=g_oea.oea32
      IF SQLCA.SQLCODE THEN  #FUN-610055
         CALL cl_err3("sel","oag_file",g_oea.oea32,"",STATUS,"","select oag",1)  #No.FUN-650108
         RETURN FALSE
      END IF
      DISPLAY BY NAME g_oea.oea32
      DISPLAY g_buf TO oag02
   ELSE                       #No.FUN-680022 add
      DISPLAY '' TO oag02     #No.FUN-680022 add
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea044()
   IF NOT cl_null(g_oea.oea044) THEN
      IF g_oea.oea044[1,4] !='MISC' THEN
         SELECT ocd221,ocd222,ocd223,ocd230,ocd231   #FUN-720014 add ocd230/231
           INTO g_oap.oap041,g_oap.oap042,g_oap.oap043,g_oap.oap044,g_oap.oap045  FROM ocd_file  #FUN-720014 add oap044/045
          WHERE ocd01=g_oea.oea04 AND ocd02=g_oea.oea044
         IF SQLCA.SQLCODE THEN  #FUN-610055
            CALL cl_err3("sel","ocd_file",g_oea.oea04,"",STATUS,"","",1)  #No.FUN-650108
            RETURN FALSE
         END IF
      END IF
      DISPLAY BY NAME g_oap.oap041,g_oap.oap042,g_oap.oap043,g_oap.oap044,g_oap.oap045   #FUN-720014 add oap044/045
   END IF
   IF (cl_null(g_oea.oea044) OR g_oea.oea044[1,4] !='MISC')
      AND g_oea_t.oea044[1,4] ="MISC" THEN
      DELETE FROM oap_file WHERE oap01 = g_oea.oea01
   END IF

   CALL t400_set_no_entry('a')
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea41()
   IF NOT cl_null(g_oea.oea41) THEN
      SELECT oac02 INTO g_buf FROM oac_file WHERE oac01=g_oea.oea41
      IF SQLCA.SQLCODE THEN  #FUN-610055
         CALL cl_err3("sel","oac_file",g_oea.oea41,"",STATUS,"","sel oac:",1)  #No.FUN-650108
         RETURN FALSE
      END IF
      DISPLAY g_buf TO oac02
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea42()
   IF NOT cl_null(g_oea.oea42) THEN
      SELECT oac02 INTO g_buf FROM oac_file
       WHERE oac01=g_oea.oea42
      IF SQLCA.SQLCODE THEN   #FUN-610055
         CALL cl_err3("sel","oac_file",g_oea.oea42,"",STATUS,"","sel oac:",1)  #No.FUN-650108
         RETURN FALSE
      END IF
      DISPLAY g_buf TO oac02_2
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea43()
   DEFINE l_cnt LIKE type_file.num10
   IF NOT cl_null(g_oea.oea43) THEN
      SELECT COUNT(*) INTO l_cnt FROM ged_file
       WHERE ged01=g_oea.oea43
      IF l_cnt =0 THEN
         CALL cl_err('','axm-309',0)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea44()

   IF NOT cl_null(g_oea.oea44) THEN
      SELECT ocf02 INTO g_buf FROM ocf_file
       WHERE ocf01=g_oea.oea04 AND ocf02=g_oea.oea44
      IF SQLCA.SQLCODE THEN   #FUN-610055
         CALL cl_err3("sel","ocf_file",g_oea.oea04,"",STATUS,"","sel ocf:",1)  #No.FUN-650108
         RETURN FALSE
      END IF
   END IF

   RETURN TRUE

END FUNCTION

FUNCTION t400_chk_oea162()

   IF NOT cl_null(g_oea.oea162) THEN
      IF g_oea.oea162 < 0 THEN
         CALL cl_err(g_oea.oea162,'aim-223',0)
         RETURN FALSE
      ELSE
         LET g_oea.oea163 = 100 - ( g_oea.oea161 + g_oea.oea162 )
         IF g_oea.oea163 < 0 THEN
            CALL cl_err('','axm-263',0)
            LET g_oea.oea163 = 0
            DISPLAY g_oea.oea163 TO oea163
            RETURN FALSE
         ELSE
            DISPLAY g_oea.oea163 TO oea163
         END IF
       END IF    #TQC-980181 add
   END IF

   RETURN TRUE

END FUNCTION

#-----No:FUN-A50103-----
FUNCTION t400_chk_oea262()

   IF NOT cl_null(g_oea.oea262) THEN
      IF g_oea.oea262 < 0 THEN
         CALL cl_err(g_oea.oea262,'aim-223',0)
         RETURN FALSE
      ELSE
         IF NOT cl_null(g_oea.oea61) AND g_oea.oea61 <> 0 THEN
            IF g_oea.oea213 = 'Y' THEN
               LET g_oea.oea263 = g_oea.oea1008 - ( g_oea.oea261 + g_oea.oea262 )
            ELSE
               LET g_oea.oea263 = g_oea.oea61 - ( g_oea.oea261 + g_oea.oea262 )
            END IF
            IF g_oea.oea263 < 0 THEN
               CALL cl_err('','axm-967',0)
               LET g_oea.oea263 = 0
               DISPLAY BY NAME g_oea.oea263
               RETURN FALSE
            ELSE
               DISPLAY BY NAME g_oea.oea263
            END IF
         END IF
      END IF 
   END IF

   RETURN TRUE

END FUNCTION
#-----No:FUN-A50103 END-----

FUNCTION t400_chk_oea46()
   IF NOT cl_null(g_oea.oea46) THEN
      IF g_aza.aza08='Y' THEN
         SELECT * FROM pja_file WHERE pja01=g_oea.oea46
                                  AND pjaclose = 'N'           #No.FUN-960038
         IF SQLCA.SQLCODE THEN   #FUN-610055
            CALL cl_err3("sel","pja_file",g_oea.oea46,"","apj-005","","sel_pja",1)  #No.FUN-650108
            RETURN FALSE
         END IF
      END IF
   END IF
   CALL t400_oea46()  #FUN-810045
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea47()
   DEFINE l_pmc54 LIKE pmc_file.pmc54
   IF NOT cl_null(g_oea.oea47) THEN
      SELECT pmc03,pmc54 INTO g_buf,l_pmc54 FROM pmc_file
       WHERE pmc01=g_oea.oea47 AND pmc14 = '4'
      IF SQLCA.SQLCODE THEN   #FUN-610055
         CALL cl_err3("sel","pmc_file",g_oea.oea47,"","mfg3001","","",1)  #No.FUN-650108
         RETURN FALSE
      END IF
      DISPLAY g_buf TO pmc03
      IF cl_null(g_oea.oea48) THEN
         LET g_oea.oea48 = l_pmc54
         DISPLAY BY NAME g_oea.oea48
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea48()
   IF NOT cl_null(g_oea.oea48) THEN
      SELECT ofs02 INTO g_buf FROM ofs_file WHERE ofs01=g_oea.oea48
      IF SQLCA.SQLCODE THEN   #FUN-610055
         CALL cl_err3("sel","ofs_file",g_oea.oea48,"","gxm-012","","",1)  #No.FUN-650108
         RETURN FALSE
      END IF
      DISPLAY g_buf TO ofs02
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea80()
   IF NOT cl_null(g_oea.oea80) AND (cl_null(g_oea_o.oea80) OR g_oea.oea80!=g_oea_o.oea80) THEN
      SELECT oag02 INTO g_buf FROM oag_file
       WHERE oag01=g_oea.oea80
      IF SQLCA.SQLCODE THEN  #FUN-610055
         CALL cl_err3("sel","oag_file",g_oea.oea80,"",STATUS,"","select oag",1)
         RETURN FALSE
      END IF
      DISPLAY BY NAME g_oea.oea80
      DISPLAY g_buf TO oag02_1
   ELSE                        #No.FUN-680022 add
      DISPLAY '' TO oag02_1    #No.FUN-680022 add
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea81()
   IF NOT cl_null(g_oea.oea81) AND (cl_null(g_oea_o.oea81) OR g_oea.oea81!=g_oea_o.oea81)THEN
      SELECT oag02 INTO g_buf FROM oag_file
       WHERE oag01=g_oea.oea81
      IF SQLCA.SQLCODE THEN  #FUN-610055
         CALL cl_err3("sel","oag_file",g_oea.oea81,"",STATUS,"","select oag",1)
         RETURN FALSE
      END IF
      DISPLAY BY NAME g_oea.oea81
      DISPLAY g_buf TO oag02_2
   ELSE                         #No.FUN-680022 add
      DISPLAY '' TO oag02_2     #No.FUN-680022 add
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_inpoea()
   DEFINE l_cnt LIKE type_file.num10
   IF g_oea.oea11 != '1' THEN
      IF cl_null(g_oea.oea12) THEN
         CALL cl_err('','axm-812',1)
         RETURN "oea12"
      END IF
   END IF
    #  重要欄位再檢查一次是否存在及是否有效
       SELECT count(*) INTO l_cnt FROM occ_file
        WHERE occ01=g_oea.oea03  #FUN-610055
          AND occacti='Y'
       IF l_cnt = 0 THEN
          CALL cl_err('select occ',STATUS,0)
          RETURN "oea03"
       END IF
       LET l_cnt = 0
        SELECT count(*) INTO l_cnt FROM occ_file
               WHERE occ01=g_oea.oea04
                 AND occacti = 'Y'
        IF l_cnt = 0 THEN
           CALL cl_err('select occ',STATUS,0)
           RETURN "oea04"
        END IF
        LET l_cnt = 0

      SELECT count(*) INTO l_cnt FROM gen_file
       WHERE gen01=g_oea.oea14
         AND genacti = 'Y'
      IF l_cnt = 0 THEN
         CALL cl_err('select gen',STATUS,0)
         RETURN "oea14"
      END IF
      LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM gem_file
        WHERE gem01=g_oea.oea15
          AND gemacti = 'Y'
       IF l_cnt = 0 THEN
          CALL cl_err('','aap-039',0)
          RETURN "oea15"
       END IF
       LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM azi_file
       WHERE azi01=g_oea.oea23
         AND aziacti = 'Y'
      IF l_cnt = 0 THEN
         CALL cl_err('select azi',STATUS,0)
         RETURN "oea23"
      END IF
      LET l_cnt = 0
      SELECT count(*) INTO l_cnt FROM oab_file
       WHERE oab01=g_oea.oea25
      IF l_cnt = 0 THEN
         CALL cl_err('select oab',STATUS,0)
         RETURN "oea25"
      END IF
      LET l_cnt = 0
      SELECT count(*) INTO l_cnt FROM oah_file
       WHERE oah01=g_oea.oea31
      IF l_cnt= 0 THEN
         CALL cl_err('select oah',STATUS,0)
         RETURN "oea31"
      END IF
      LET l_cnt = 0
      SELECT count(*) INTO l_cnt FROM oag_file
       WHERE oag01=g_oea.oea32
      IF l_cnt = 0 THEN
         CALL cl_err('select oag',STATUS,0)
         RETURN "oea32"
      END IF
      LET l_cnt = 0
    SELECT count(*)
      INTO l_cnt
      FROM gec_file
     WHERE gec01=g_oea.oea21
       AND gec011='2'  #銷項
    IF l_cnt = 0 THEN
       CALL cl_err('select gec',STATUS,0)
       RETURN "oea21"
    END IF

    LET l_cnt = 0

   IF g_oea.oea161+g_oea.oea162+g_oea.oea163 > 100 THEN
      CALL cl_err('','axm-263',0)
      RETURN "oea161"
   END IF

   RETURN NULL

END FUNCTION

FUNCTION t400_ioccm()
   DEFINE l_occm RECORD LIKE occm_file.*

   OPEN WINDOW t400_cm WITH FORM "axm/42f/axmt400m"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_locale("axmt400m")

   INPUT BY NAME g_occm.occm01,g_occm.occm02,g_occm.occm03,
                 g_occm.occm031,g_occm.occm04,g_occm.occm05,g_occm.occm06,
                 g_occm.occm07,g_occm.occm08     #FUN-720014 add
        WITHOUT DEFAULTS

      AFTER FIELD occm02
         IF NOT cl_null(g_occm.occm02) THEN
            DECLARE occm_cur CURSOR FOR SELECT * FROM occm_file
                                         WHERE occm02=g_occm.occm02
            OPEN occm_cur
            FETCH occm_cur INTO l_occm.*
            IF STATUS <> 0 THEN
               LET l_occm.occm03=' '
               LET l_occm.occm031=' '
               LET l_occm.occm04=' '
               LET l_occm.occm05=' '
               LET l_occm.occm06=' '
               LET l_occm.occm07=' '  #FUN-720014 add
               LET l_occm.occm08=' '  #FUN-720014 add
            END IF
            CLOSE occm_cur

            IF cl_null(g_occm.occm03) THEN
               LET g_occm.occm03=l_occm.occm03
               LET g_occm.occm031=l_occm.occm031
            END IF

            IF cl_null(g_occm.occm04) THEN
               LET g_occm.occm04=l_occm.occm04
               LET g_occm.occm05=l_occm.occm05
               LET g_occm.occm06=l_occm.occm06
               LET g_occm.occm07=l_occm.occm07   #FUN-720014 add
               LET g_occm.occm08=l_occm.occm08   #FUN-720014 add
            END IF

            DISPLAY BY NAME g_occm.occm03,g_occm.occm031,g_occm.occm04,
                            g_occm.occm05,g_occm.occm06,
                            g_occm.occm07,g_occm.occm08   #FUN-720014 add
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

   CLOSE WINDOW t400_cm
   #No.TQC-A10104  --Begin
   IF INT_FLAG THEN
      LET INT_FLAG=0
   END IF
   #No.TQC-A10104  --End

END FUNCTION

FUNCTION t400_u_chk()
   IF s_shut(0) THEN RETURN FALSE END IF

   SELECT * INTO g_oea.* FROM oea_file WHERE oea01=g_oea01.oea01   #mod by liuxqa 091020

   SELECT * INTO g_occm.* FROM occm_file WHERE occm01=g_oea.oea01
   IF STATUS <> 0 THEN
      INITIALIZE g_occm.* TO NULL
   END IF

   IF g_oea.oea01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN FALSE
   END IF

   IF g_oea.oeaconf = 'Y' THEN
      CALL cl_err('',9023,0)
      RETURN FALSE
   END IF

   IF g_oea.oeaconf = 'X' THEN
      CALL cl_err('',9024,0)
      RETURN FALSE
   END IF

   IF g_oea.oea62 != 0 THEN
      CALL cl_err('','axm-162',0)
      RETURN FALSE
   END IF

   IF g_oea.oea49 MATCHES '[Ss]' THEN          #MOD-4A0299
      CALL cl_err('','apm-030',0)
      RETURN FALSE
   END IF


   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_oea_o.* = g_oea.*
   RETURN TRUE
END FUNCTION

FUNCTION t400_u_ins()
   CALL t400_signo_count(g_oea.oeasign) RETURNING g_oea.oeasmax  #FUN-610055

   IF g_oea.oea11='1' THEN
      LET g_oea.oea12=g_oea.oea01
   END IF

   LET g_oea.oea49 = '0'                          #MOD-4A0299

   UPDATE oea_file SET * = g_oea.*
    WHERE oea01 = g_oea01_t       #mod by liuxqa 091020
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","oea_file",g_oea_t.oea01,"",SQLCA.sqlcode,"","",1)  #No.FUN-650108
      RETURN FALSE
   END IF

    IF g_oea.oea21 <> g_oea_t.oea21 THEN
       #訊問是否更新單價/金額，如果是，則重算單身的單價/金額
       IF cl_confirm('axm-191') THEN
          IF NOT t400_mdet() THEN
            RETURN FALSE
          END IF
       END IF
    END IF
    IF g_oea.oea23 <> g_oea_t.oea23 OR g_oea.oea24 <> g_oea_t.oea24 THEN
      #show 提示訊息
      CALL cl_err(g_oea.oea01,'axm-190',1)
    END IF

   DISPLAY BY NAME g_oea.oea49              #MOD-4A0299
   IF g_oea.oeaconf = 'X' THEN
      LET g_void = "Y"
   ELSE
      LET g_void = "N"
   END IF

   IF g_oea.oea49 = '1' THEN
      LET g_approve = "Y"
   ELSE
      LET g_approve = "N"
   END IF

   CALL cl_set_field_pic(g_oea.oeaconf,g_approve,"","",g_void,"")

   # 98/11/07 Eric Add:新增雜項客戶資料
   DELETE FROM occm_file
    WHERE occm01=g_oea_t.oea01

   IF g_oea.oea03[1,4] = 'MISC' THEN  #FUN-610055
      IF (NOT cl_null(g_occm.occm02)) OR (NOT cl_null(g_occm.occm03))
         OR (NOT cl_null(g_occm.occm04))
         OR (NOT cl_null(g_occm.occm05))
         OR (NOT cl_null(g_occm.occm06))
         OR (NOT cl_null(g_occm.occm07))   #FUN-720014
         OR (NOT cl_null(g_occm.occm08))   #FUN-720014
      THEN

         LET g_occm.occm01=g_oea.oea01
         INSERT INTO occm_file VALUES(g_occm.*)
      END IF
   END IF

   IF g_oea.oea044[1,4]='MISC' THEN
      DELETE FROM oap_file WHERE oap01 = g_oea_t.oea01
      LET g_oap.oap01 = g_oea.oea01
      INSERT INTO oap_file VALUES(g_oap.*)
      IF STATUS THEN
         CALL cl_err3("ins","oap_file",g_oap.oap01,"",STATUS,"","INS-oap",1)  #No.FUN-650108
         RETURN FALSE
      END IF
   END IF

   IF g_oea.oea01 != g_oea_t.oea01 THEN
      UPDATE oeb_file SET oeb01=g_oea.oea01
       WHERE oeb01=g_oea_t.oea01
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL cl_err3("upd","oeb_file",g_oea_t.oea01,"",SQLCA.sqlcode,"","INS-oap",1)  #No.FUN-650108
         LET g_oea.*=g_oea_t.*
         RETURN FALSE
      END IF

      UPDATE oao_file SET oao01=g_oea.oea01
       WHERE oao01=g_oea_t.oea01
      IF STATUS THEN
         CALL cl_err3("upd","oao_file",g_oea_t.oea01,"",STATUS,"","upd oao01",1)  #No.FUN-650108
         LET g_oea.*=g_oea_t.*
         RETURN FALSE
      END IF

      UPDATE oap_file SET oap01=g_oea.oea01
       WHERE oap01=g_oea_t.oea01
      IF STATUS THEN
         CALL cl_err3("upd","oap_file",g_oea_t.oea01,"",STATUS,"","upd oap01",1)  #No.FUN-650108
         LET g_oea.*=g_oea_t.*
         RETURN FALSE
      END IF

      UPDATE oeo_file SET oeo01=g_oea.oea01
       WHERE oeo01=g_oea_t.oea01
      IF STATUS THEN
         CALL cl_err3("upd","oeo_file",g_oea_t.oea01,"",STATUS,"","upd oeo01",1)  #No.FUN-650108
         LET g_oea.*=g_oea_t.*
         RETURN FALSE
      END IF

      UPDATE oem_file SET oem01=g_oea.oea01
       WHERE oem01=g_oea_t.oea01
      IF STATUS THEN
         CALL cl_err3("upd","oem_file",g_oea_t.oea01,"",STATUS,"","upd oem01",1)  #No.FUN-650108
         LET g_oea.*=g_oea_t.*
         RETURN FALSE
      END IF

      UPDATE oed_file SET oed01=g_oea.oea01
       WHERE oed01=g_oea_t.oea01
      IF STATUS THEN
         CALL cl_err3("upd","oed_file",g_oea_t.oea01,"",STATUS,"","upd oed01",1)  #No.FUN-650108
         LET g_oea.*=g_oea_t.*
         RETURN FALSE
      END IF
   END IF

   # 稅別不同時要更新金額欄位
   IF g_oea.oea21 != g_oea_t.oea21 THEN
      CALL t400_upoea21()
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_b_bef_ins()
   INITIALIZE g_oeb[l_ac].* TO NULL      #900423
   INITIALIZE arr_detail[l_ac].* TO NULL   #No.FUN-640013
   INITIALIZE b_oeb.* TO NULL
   LET b_oeb.oeb01=g_oea.oea01
   LET g_oeb[l_ac].oeb12=0
   LET g_change = 'Y'
   LET g_change1= 'Y'
   IF g_azw.azw04='2' THEN
   LET g_oeb[l_ac].oeb47=0
   LET g_oeb[l_ac].oeb48=2    #FUN-9B0025 ADD
   ELSE
   LET g_oeb[l_ac].oeb44='1'
   END IF
   LET g_oeb[l_ac].oeb13=0
   LET g_oeb[l_ac].oeb37 = 0     #FUN-AB0061 
   LET g_oeb[l_ac].oeb14=0
   LET g_oeb[l_ac].oeb14t=0
   LET g_oeb[l_ac].oeb24=0
   LET g_oeb[l_ac].oeb28=0              #NO.FUN-670007
   LET g_oeb[l_ac].oeb19='N'
   LET g_oeb[l_ac].oeb906 = 'N'         #No.FUN-5C0076
   IF l_ac = 1 THEN
      LET g_oeb[l_ac].oeb15=g_oea.oea02
   ELSE
      LET g_oeb[l_ac].oeb15=g_oeb[l_ac-1].oeb15
   END IF
   LET b_oeb.oeb1003 = '1'
   LET g_oeb[l_ac].oeb1012 = 'N'   #No.FUN-650108
   LET g_oeb[l_ac].oeb1006 = 100
   IF NOT cl_null(g_oea.oea46) THEN
     LET g_oeb[l_ac].oeb41 = g_oea.oea46
     LET b_oeb.oeb41 = g_oea.oea46
   END IF
   LET b_oeb.oeb05_fac=1
   LET b_oeb.oeb23=0
   LET b_oeb.oeb24=0
   LET b_oeb.oeb25=0
   LET b_oeb.oeb29=0   #No.FUN-740016
   LET b_oeb.oeb26=0
   LET b_oeb.oeb901=0   #No:8754
   LET b_oeb.oeb920=0   #No.FUN-630006
   LET g_oeb[l_ac].oeb32 = g_today     #No.FUN-A80024
   LET g_oeb[l_ac].oeb70='N'
   LET g_oeb_t.* = g_oeb[l_ac].*             #新輸入資料
   CALL cl_show_fld_cont()     #FUN-550037(smin)
   IF g_aza.aza50 = 'Y' THEN   #No.FUN-650108
      CALL t400_set_entry_b('a')          #No.FUN-610055
      CALL t400_set_no_entry_b('a','N')   #No.FUN-610055
   END IF  #No.FUN-650108
   LET g_oeb[l_ac].oeb930=s_costcenter(g_oea.oea15) #FUN-670063
   LET g_oeb[l_ac].gem02c=s_costcenter_desc(g_oeb[l_ac].oeb930) #FUN-670063
END FUNCTION

FUNCTION t400_bef_oeb03(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1

   CALL t400_set_entry_b(p_cmd)
   IF g_oeb[l_ac].oeb03 IS NULL OR g_oeb[l_ac].oeb03 = 0 THEN
#FUN-A60035 ---MARK BEGIN
#FUN-A50054 --Begin
#&ifdef SLK
#      IF g_oea.oeaslk02 = 'Y' THEN
#         SELECT MAX(ata02)+1 INTO g_oeb[l_ac].oeb03
#           FROM ata_file WHERE ata00 = g_prog
#            AND ata01 = g_oea.oea01
#      ELSE
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END
      IF g_aza.aza50 = 'Y' THEN  #No.FUN-650108
         SELECT MAX(oeb03)+1 INTO g_oeb[l_ac].oeb03
           FROM oeb_file WHERE oeb01 = g_oea.oea01
            AND oeb1003='1' AND oeb03<'9001'
      ELSE
         SELECT max(oeb03)+1 INTO g_oeb[l_ac].oeb03
           FROM oeb_file WHERE oeb01 = g_oea.oea01 AND oeb03<'9001'   #FUN-B10010
      END IF
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#      END IF
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END
      IF g_oeb[l_ac].oeb03 IS NULL THEN
         LET g_oeb[l_ac].oeb03 = 1
      END IF
   END IF
END FUNCTION

FUNCTION t400_chk_oeb71(p_cmd,p_chk)
   DEFINE p_cmd LIKE type_file.chr1
   DEFINE p_chk LIKE type_file.chr1,
          l_oeb12_tot     LIKE oeb_file.oeb12,    #MOD-9B0185
          l_oeb912_tot    LIKE oeb_file.oeb912,   #MOD-9B0185
          l_oeb915_tot    LIKE oeb_file.oeb915,   #MOD-9B0185
          l_oeb917_tot    LIKE oeb_file.oeb917,   #MOD-9B0185
          l_oeb912        LIKE oeb_file.oeb912,
          l_oeb915        LIKE oeb_file.oeb915,
          l_oeb917        LIKE oeb_file.oeb917,
          l_oeb70         LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_oqu           RECORD LIKE oqu_file.*,
          l_check         LIKE type_file.chr1     #No.FUN-680137 VARCHAR(1)
   DEFINE l_oeb           RECORD LIKE oeb_file.*  #MOD-A50014
   DEFINE l_fac           LIKE oeb_file.oeb05_fac   #MOD-A50128 
   DEFINE l_ima25         LIKE ima_file.ima25       #MOD-A70041
   DEFINE l_oeb32         LIKE oeb_file.oeb32     #No.FUN-A80024

   IF NOT cl_null(g_oeb[l_ac].oeb71) THEN
#No.FUN-A80024 --begin
      SELECT oeb32 INTO l_oeb32 FROM oeb_file
       WHERE oeb01 = g_oea.oea12
         AND oeb03 = g_oeb[l_ac].oeb71
     #IF g_oea.oea02 <= l_oeb32 THEN   #MOD-B30466  mark
      IF g_oea.oea02 > l_oeb32 THEN    #MOD-B30466  add
         CALL cl_err('','axm-983',1)
         RETURN FALSE 
      END IF 
#No.FUN-A80024 --end
      IF g_oea.oea11='3' AND ((g_oeb[l_ac].oeb71 <> g_oeb_t.oeb71) OR cl_null(g_oeb_t.oeb71)) THEN  #MOD-4B0043
         #如果已有轉入過則必須先減去數量
         SELECT SUM(oeb912),SUM(oeb915),SUM(oeb917)
           INTO l_oeb912,l_oeb915,l_oeb917
           FROM oeb_file,oea_file
          WHERE oea12 = g_oea.oea12
            AND oeb71 = g_oeb[l_ac].oeb71
            AND oea11 = '3'
            AND oeb01 = oea01
            AND oeb03 != g_oeb[l_ac].oeb03

         IF cl_null(l_oeb912) THEN
            LET l_oeb912 = 0
         END IF

         IF cl_null(l_oeb915) THEN
            LET l_oeb915 = 0
         END IF

         IF cl_null(l_oeb917) THEN
            LET l_oeb917 = 0
         END IF

         SELECT oeb04,oeb092,oeb05,oeb05_fac,oeb06,oeb12-oeb24,oeb13,oeb37,oeb15,oeb22,oeb70,   #MOD-710012 add oeb05_fac    #FUN-AB0061 add oeb37
                oeb910,oeb911,oeb912,oeb913,oeb914,oeb915,oeb916,oeb917
           INTO g_oeb[l_ac].oeb04,g_oeb[l_ac].oeb092,g_oeb[l_ac].oeb05,
                b_oeb.oeb05_fac,   #MOD-710012 add
                g_oeb[l_ac].oeb06,g_oeb[l_ac].oeb12,g_oeb[l_ac].oeb13,
                g_oeb[l_ac].oeb37,                                          #FUN-AB0061
                g_oeb[l_ac].oeb15,g_oeb[l_ac].oeb22,l_oeb70,
                g_oeb[l_ac].oeb910,g_oeb[l_ac].oeb911,g_oeb[l_ac].oeb912,
                g_oeb[l_ac].oeb913,g_oeb[l_ac].oeb914,g_oeb[l_ac].oeb915,
                g_oeb[l_ac].oeb916,g_oeb[l_ac].oeb917
           FROM oeb_file
          WHERE oeb01=g_oea.oea12
            AND oeb03=g_oeb[l_ac].oeb71
         IF STATUS THEN
            CALL cl_err3("sel","oeb_file",g_oea.oea12,g_oeb[l_ac].oeb71,STATUS,"","sel contract(oeb):",1)  #No.FUN-650108
            RETURN FALSE
         END IF
         LET g_oeb_t.oeb04 = g_oeb[l_ac].oeb04   #No.TQC-710080 add
         DISPLAY BY NAME g_oeb[l_ac].oeb04
         DISPLAY BY NAME g_oeb[l_ac].oeb092
         DISPLAY BY NAME g_oeb[l_ac].oeb05
         DISPLAY BY NAME g_oeb[l_ac].oeb06
         DISPLAY BY NAME g_oeb[l_ac].oeb12
         DISPLAY BY NAME g_oeb[l_ac].oeb13
         DISPLAY BY NAME g_oeb[l_ac].oeb37         #FUN-AB0061 
         DISPLAY BY NAME g_oeb[l_ac].oeb15
         DISPLAY BY NAME g_oeb[l_ac].oeb22

         LET g_oeb[l_ac].oeb912 = g_oeb[l_ac].oeb912-l_oeb912
         LET g_oeb[l_ac].oeb917 = g_oeb[l_ac].oeb917-l_oeb917

         DISPLAY BY NAME g_oeb[l_ac].oeb912
         DISPLAY BY NAME g_oeb[l_ac].oeb917

         CALL t400_set_oeb917()  #No.TQC-6C0131 add
         IF cl_null(g_oeb[l_ac].oeb916) THEN
            LET g_oeb[l_ac].oeb916=g_oeb[l_ac].oeb05
            LET g_oeb[l_ac].oeb917=g_oeb[l_ac].oeb12
         END IF
         DISPLAY BY NAME g_oeb[l_ac].oeb916
         DISPLAY BY NAME g_oeb[l_ac].oeb917


         IF l_oeb70 = 'Y' THEN
            CALL cl_err('oeb70=Y:','axm-149',0)
            RETURN FALSE
         END IF
        #用計價數量來算
         IF g_oea.oea213 = 'N' THEN
            LET g_oeb[l_ac].oeb14 =g_oeb[l_ac].oeb917*g_oeb[l_ac].oeb13
            CALL cl_numfor(g_oeb[l_ac].oeb14,10,t_azi04) RETURNING g_oeb[l_ac].oeb14    #CHI-7A0036-add
            LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb14*(1+g_oea.oea211/100)
            CALL cl_numfor(g_oeb[l_ac].oeb14t,10,t_azi04) RETURNING g_oeb[l_ac].oeb14t  #CHI-7A0036-add
         ELSE
            LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb917*g_oeb[l_ac].oeb13
            CALL cl_numfor(g_oeb[l_ac].oeb14t,10,t_azi04) RETURNING g_oeb[l_ac].oeb14t  #CHI-7A0036-add
            LET g_oeb[l_ac].oeb14 =g_oeb[l_ac].oeb14t/(1+g_oea.oea211/100)
            CALL cl_numfor(g_oeb[l_ac].oeb14,10,t_azi04) RETURNING g_oeb[l_ac].oeb14    #CHI-7A0036-add
         END IF

         CALL cl_numfor(g_oeb[l_ac].oeb13,8,t_azi03) RETURNING g_oeb[l_ac].oeb13          #No.CHI-6A0004
         CALL cl_numfor(g_oeb[l_ac].oeb37,8,t_azi03) RETURNING g_oeb[l_ac].oeb37          #FUN-AB0061  
         LET b_oeb.oeb17 = g_oeb[l_ac].oeb13 #no.7150
         LET g_oeb17 = g_oeb[l_ac].oeb13     #no.7150 預設取出單價
         DISPLAY BY NAME g_oeb[l_ac].oeb14
         DISPLAY BY NAME g_oeb[l_ac].oeb14t
      END IF

      #-----MOD-A50014---------
      IF g_oea.oea00='9' THEN 
         SELECT * INTO l_oeb.* FROM oeb_file
         WHERE oeb01=g_oea.oea12
           AND oeb03=g_oeb[l_ac].oeb71
           AND (oeb24-oeb25-oeb29)>0 AND oeb70='N'
         IF STATUS THEN
            CALL cl_err3("sel","oeb_file",g_oea.oea12,g_oeb[l_ac].oeb71,STATUS,"","sel oeb",1)  
            RETURN FALSE
         END IF
         IF cl_null(l_oeb.oeb24) THEN
            LET l_oeb.oeb24 = 0
         END IF
         IF cl_null(l_oeb.oeb25) THEN
            LET l_oeb.oeb25 = 0
         END IF
         IF cl_null(l_oeb.oeb29) THEN
            LET l_oeb.oeb29 = 0
         END IF
         LET g_oeb[l_ac].oeb12 = l_oeb.oeb24-l_oeb.oeb25-l_oeb.oeb29
         LET g_oeb[l_ac].oeb24 = 0
         LET g_oeb[l_ac].oeb25 = 0
         LET g_oeb[l_ac].oeb29 = 0
         LET g_oeb[l_ac].oeb09 = g_oaz.oaz78
         LET g_oeb[l_ac].oeb091 = ' '
         LET g_oeb[l_ac].oeb092 = g_oea.oea03

         SELECT SUM(oeb912),SUM(oeb915),SUM(oeb917) 
          INTO l_oeb912,l_oeb915,l_oeb917 FROM oeb_file,oea_file
            WHERE oea12=l_oeb.oeb01 AND oeb71=l_oeb.oeb03 AND
                  oea11 =g_oea.oea11 AND oeb01=oea01  
         IF cl_null(l_oeb912) THEN
            LET l_oeb912 = 0
         END IF
         IF cl_null(l_oeb915) THEN
            LET l_oeb915 = 0
         END IF
         IF cl_null(l_oeb917) THEN
            LET l_oeb917 = 0
         END IF
         LET g_oeb[l_ac].oeb910 = l_oeb.oeb910
         LET g_oeb[l_ac].oeb911 = l_oeb.oeb911
         LET g_oeb[l_ac].oeb912 = l_oeb.oeb912 - l_oeb912
         LET g_oeb[l_ac].oeb913 = l_oeb.oeb913
         LET g_oeb[l_ac].oeb914 = l_oeb.oeb914
         LET g_oeb[l_ac].oeb915 = l_oeb.oeb915 - l_oeb915
         LET g_oeb[l_ac].oeb916 = l_oeb.oeb916
         LET g_oeb[l_ac].oeb917 = l_oeb.oeb917 - l_oeb917
         LET g_oeb[l_ac].oeb13 = l_oeb.oeb13   
         LET g_oeb[l_ac].oeb37 = l_oeb.oeb37      #FUN-AB0061 
         LET b_oeb.oeb17 = g_oeb[l_ac].oeb13 
         LET g_oeb17 = g_oeb[l_ac].oeb13     
         LET g_oeb[l_ac].oeb19 = 'N'   
         LET b_oeb.oeb905= 0           
         LET g_oeb[l_ac].oeb04 = l_oeb.oeb04   
         LET g_oeb[l_ac].oeb05 = l_oeb.oeb05   
         LET g_oeb[l_ac].oeb06 = l_oeb.oeb06    
         LET g_oeb[l_ac].oeb15 = l_oeb.oeb15   
         LET g_oeb[l_ac].oeb22 = l_oeb.oeb22   
         LET g_oeb[l_ac].oeb70 = l_oeb.oeb70
         LET b_oeb.oeb05_fac = l_oeb.oeb05_fac
         SELECT ima021 INTO g_oeb[l_ac].ima021 FROM ima_file
           WHERE ima01=g_oeb[l_ac].oeb04
         LET g_oeb[l_ac].oeb11 = l_oeb.oeb11
         LET g_oeb[l_ac].oeb30 = l_oeb.oeb30
      END IF
      #-----END MOD-A50014-----

      IF cl_null(g_oeb[l_ac].oeb04) AND g_oea.oea11='5' THEN
         SELECT * INTO l_oqu.* FROM oqu_file
          WHERE oqu01=g_oea.oea12
            AND oqu02=g_oeb[l_ac].oeb71   #MOD-510128
         IF NOT STATUS THEN
             CALL t400_g_du(l_oqu.oqu03,l_oqu.oqu05,l_oqu.oqu06)
             IF g_sma.sma116 MATCHES '[23]' THEN
                SELECT ima908 INTO b_oeb.oeb916 FROM ima_file
                 WHERE ima01 = l_oqu.oqu03
             END IF
             LET g_oeb[l_ac].oeb916= b_oeb.oeb916
             CALL t400_set_oeb917_exp(l_oqu.oqu03,l_oqu.oqu05,l_oqu.oqu06)
             LET g_oeb[l_ac].oeb917= b_oeb.oeb917
             DISPLAY BY NAME g_oeb[l_ac].oeb916
             DISPLAY BY NAME g_oeb[l_ac].oeb917
            LET g_oeb[l_ac].oeb04=l_oqu.oqu03
            LET g_oeb_t.oeb04 = g_oeb[l_ac].oeb04   #MOD-A70041
            LET g_oeb[l_ac].oeb06=l_oqu.oqu031
            SELECT ima021 INTO g_oeb[l_ac].ima021 FROM ima_file   #MOD-A70041
              WHERE ima01 = g_oeb[l_ac].oeb04   #MOD-A70041
            LET g_oeb[l_ac].oeb11=l_oqu.oqu04    #MOD-940151 add
            LET g_oeb[l_ac].oeb12=l_oqu.oqu06
            LET g_oeb[l_ac].oeb13=l_oqu.oqu07
            LET g_oeb[l_ac].oeb37=l_oqu.oqu07     #FUN-AB0061
            DISPLAY BY NAME g_oeb[l_ac].oeb04
            DISPLAY BY NAME g_oeb[l_ac].oeb06
            DISPLAY BY NAME g_oeb[l_ac].oeb11    #MOD-940151 add
            DISPLAY BY NAME g_oeb[l_ac].oeb12
            DISPLAY BY NAME g_oeb[l_ac].oeb13
            DISPLAY BY NAME g_oeb[l_ac].oeb37     #FUN-AB0061
            IF cl_null(g_oeb[l_ac].oeb12) THEN
               LET g_oeb[l_ac].oeb12=0
            END IF
            IF cl_null(g_oeb[l_ac].oeb13) THEN
               LET g_oeb[l_ac].oeb13=0
            END IF
            IF cl_null(g_oeb[l_ac].oeb37) THEN      #FUN-AB0061
               LET g_oeb[l_ac].oeb37 = 0            #FUN-AB0061
            END IF                                  #FUN-AB0061
            #-----MOD-A70041---------
            #IF l_oqu.oqu03[1,4] !='MISC' THEN
            #   SELECT ima25 INTO g_oeb[l_ac].oeb05 FROM ima_file
            #    WHERE ima01=l_oqu.oqu03
            #   DISPLAY BY NAME g_oeb[l_ac].oeb05
            #   CALL s_umfchk(l_oqu.oqu03,l_oqu.oqu05,g_oeb[l_ac].oeb05)
            #       #RETURNING l_check,b_oeb.oeb05_fac   #MOD-A50128
            #       RETURNING l_check,l_fac   #MOD-A50128
            #ELSE
            #   LET l_check='0'
            #   #LET b_oeb.oeb05_fac=1   #MOD-A50128
            #   LET l_fac=1   #MOD-A50128
            #END IF
            #
            #IF l_check = '1' THEN
            #   CALL cl_err(l_oqu.oqu03,'abm-731',1)
            #   #LET b_oeb.oeb05_fac=0    #MOD-A50128
            #   LET l_fac=1    #MOD-A50128
            #END IF
            #LET g_oeb[l_ac].oeb12 = g_oeb[l_ac].oeb12 * l_fac   #MOD-A50128
            #LET b_oeb.oeb05_fac = 1   #MOD-A50128

            LET g_oeb[l_ac].oeb05 = l_oqu.oqu05
            DISPLAY BY NAME g_oeb[l_ac].oeb05
            IF l_oqu.oqu03[1,4] !='MISC' THEN
               SELECT ima25 INTO l_ima25 FROM ima_file  
                WHERE ima01=l_oqu.oqu03  
               CALL s_umfchk(l_oqu.oqu03,l_oqu.oqu05,l_ima25)
                   RETURNING l_check,b_oeb.oeb05_fac  
            ELSE
               LET l_check='0'
               LET b_oeb.oeb05_fac=1
            END IF
            
            IF l_check = '1' THEN
               CALL cl_err(l_oqu.oqu03,'abm-731',1)
               LET b_oeb.oeb05_fac=1
            END IF
            #-----END MOD-A70041-----

            IF cl_null(l_oqu.oqu06) THEN LET l_oqu.oqu06=0 END IF
            IF cl_null(l_oqu.oqu07) THEN LET l_oqu.oqu07=0 END IF
            IF g_oea.oea213 = 'N' THEN
               LET g_oeb[l_ac].oeb14=l_oqu.oqu06*l_oqu.oqu07
               CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04)  RETURNING g_oeb[l_ac].oeb14  #MOD-940263 add
               LET g_oeb[l_ac].oeb14t= g_oeb[l_ac].oeb14 * (1+g_oea.oea211/100)        #MOD-940263 add
               CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t #MOD-940263 add
            ELSE
               LET g_oeb[l_ac].oeb14t=l_oqu.oqu06*l_oqu.oqu07
               CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t #MOD-940263 add
               LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb14t/(1+g_oea.oea211/100)
               CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04)  RETURNING g_oeb[l_ac].oeb14  #MOD-940263 add
            END IF
            IF cl_null(g_oeb[l_ac].oeb14) THEN
               LET g_oeb[l_ac].oeb14=0
            END IF
            IF cl_null(g_oeb[l_ac].oeb14t) THEN
               LET g_oeb[l_ac].oeb14t=0
            END IF
            DISPLAY BY NAME g_oeb[l_ac].oeb14
            DISPLAY BY NAME g_oeb[l_ac].oeb14t
         END IF
      END IF
      IF cl_null(g_oeb[l_ac].oeb04) AND g_oea.oea11='7' THEN
         SELECT ogb04,ogb05,ogb05_fac,ogb06,ogb07,   #MOD-9B0185
                ogb11,ogb12,ogb13,ogb37,ogb14,ogb14t,ogb910,ogb911,          #FUN-AB0061 add ogb37
                ogb912,ogb913,ogb914,ogb915,ogb916,ogb917,ogb19              #No.FUN-5C0076
           INTO g_oeb[l_ac].oeb04,g_oeb[l_ac].oeb05,
                b_oeb.oeb05_fac,g_oeb[l_ac].oeb06,
                #g_oeb[l_ac].oeb06,b_oeb.oeb07,b_oeb.oeb11,   #MOD-9B0185
                b_oeb.oeb07,b_oeb.oeb11,   #MOD-9B0185
                g_oeb[l_ac].oeb12,g_oeb[l_ac].oeb13,
                g_oeb[l_ac].oeb37,                             #FUN-AB0061 
                g_oeb[l_ac].oeb14,g_oeb[l_ac].oeb14t,
                g_oeb[l_ac].oeb910,g_oeb[l_ac].oeb911,
                g_oeb[l_ac].oeb912,g_oeb[l_ac].oeb913,
                g_oeb[l_ac].oeb914,g_oeb[l_ac].oeb915,
                g_oeb[l_ac].oeb916,g_oeb[l_ac].oeb917,g_oeb[l_ac].oeb906             #No.FUN-5C0076
           FROM ogb_file,oga_file
          WHERE oga01 = ogb01
            AND ogaconf = 'Y'
            AND oga00 = '3'
            AND ogb01 = g_oea.oea12
            AND ogb03 = g_oeb[l_ac].oeb71

          IF STATUS THEN
             CALL cl_err3("sel","ogb_file,oga_file",g_oea.oea12,"","abx-002","","sel oga:",1)  #No.FUN-650108
             RETURN FALSE
          END IF
          SELECT SUM(oeb12),SUM(oeb912),SUM(oeb915),SUM(oeb917)
             INTO l_oeb12_tot,l_oeb912_tot,l_oeb915_tot,l_oeb917_tot
            FROM oea_file,oeb_file
           WHERE oea01 = oeb01
             AND oeaconf <> 'X'
             AND oea12 = g_oea.oea12
             AND oeb71 = g_oeb[l_ac].oeb71
             AND (oeb01 <> g_oea.oea01
              OR (oeb01 = g_oea.oea01 AND oeb03 <> g_oeb[l_ac].oeb03))
          IF cl_null(l_oeb12_tot) THEN LET l_oeb12_tot = 0 END IF
          IF cl_null(l_oeb912_tot) THEN LET l_oeb912_tot = 0 END IF
          IF cl_null(l_oeb915_tot) THEN LET l_oeb915_tot = 0 END IF
          IF cl_null(l_oeb917_tot) THEN LET l_oeb917_tot = 0 END IF
          LET g_oeb[l_ac].oeb12 = g_oeb[l_ac].oeb12 - l_oeb12_tot
          LET g_oeb[l_ac].oeb912 = g_oeb[l_ac].oeb912 - l_oeb912_tot
          LET g_oeb[l_ac].oeb915 = g_oeb[l_ac].oeb915 - l_oeb915_tot
          LET g_oeb[l_ac].oeb917 = g_oeb[l_ac].oeb917 - l_oeb917_tot

          DISPLAY BY NAME g_oeb[l_ac].oeb04
          DISPLAY BY NAME g_oeb[l_ac].oeb05
          DISPLAY BY NAME g_oeb[l_ac].oeb06
          DISPLAY BY NAME g_oeb[l_ac].oeb12
          DISPLAY BY NAME g_oeb[l_ac].oeb13
          DISPLAY BY NAME g_oeb[l_ac].oeb37          #FUN-AB0061 
          DISPLAY BY NAME g_oeb[l_ac].oeb14
          DISPLAY BY NAME g_oeb[l_ac].oeb14t
          DISPLAY BY NAME g_oeb[l_ac].oeb910   #MOD-9B0185
          DISPLAY BY NAME g_oeb[l_ac].oeb912   #MOD-9B0185
          DISPLAY BY NAME g_oeb[l_ac].oeb913   #MOD-9B0185
          DISPLAY BY NAME g_oeb[l_ac].oeb915   #MOD-9B0185
          IF cl_null(g_oeb[l_ac].oeb916) THEN
             LET g_oeb[l_ac].oeb916=g_oeb[l_ac].oeb05
             LET g_oeb[l_ac].oeb917=g_oeb[l_ac].oeb12
          END IF
          DISPLAY BY NAME g_oeb[l_ac].oeb916
          DISPLAY BY NAME g_oeb[l_ac].oeb917
          DISPLAY BY NAME g_oeb[l_ac].oeb906         #MOD-7B0201-add
      END IF
   END IF

   LET g_oeb_t.oeb71 = g_oeb[l_ac].oeb71 #MOD-4B0043
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oeb1001(p_cmd,p_chk)
   DEFINE p_cmd LIKE type_file.chr1
   DEFINE p_chk LIKE type_file.chr1
   DEFINE l_azf02 LIKE azf_file.azf02   #FUN-920186
   DEFINE l_azf09 LIKE azf_file.azf09   #FUN-920186

   IF NOT cl_null(g_oeb[l_ac].oeb1001) THEN
      IF g_oeb[l_ac].oeb1001 != g_oeb_t.oeb1001
         OR cl_null(g_oeb_t.oeb1001) THEN
             SELECT azf09 INTO l_azf09 FROM azf_file    #FUN-920186
              WHERE azf01=g_oeb[l_ac].oeb1001
                AND azfacti='Y'
                AND azf02='2'  #TQC-740202
             IF l_azf09 != '1' THEN
                CALL cl_err('','aoo-400',1)
                RETURN FALSE
             END IF
          IF STATUS=100 THEN
             CALL cl_err3("sel","azf_file",g_oeb[l_ac].oeb1001,"","100","","",1)  #No.FUN-650108     #No.FUN-6B0065
             LET g_oeb[l_ac].oeb1001=g_oeb_t.oeb1001
             RETURN FALSE
          END IF
          IF g_oeb[l_ac].oeb1012 = 'Y' AND g_aza.aza50 = 'Y' THEN
             LET g_oeb[l_ac].oeb14=0
             LET g_oeb[l_ac].oeb14t=0
          ELSE
             IF NOT cl_null(g_oeb[l_ac].oeb917) AND NOT cl_null(g_oeb[l_ac].oeb13) THEN
                IF g_oea.oea213 = 'N' THEN
                   LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb917*g_oeb[l_ac].oeb13
                   CALL cl_numfor(g_oeb[l_ac].oeb14,10,t_azi04) RETURNING g_oeb[l_ac].oeb14         #CHI-7A0036-add
                   LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb14*(1+g_oea.oea211/100)
                   CALL cl_numfor(g_oeb[l_ac].oeb14t,10,t_azi04) RETURNING g_oeb[l_ac].oeb14t       #CHI-7A0036-add
                ELSE
                   LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb917*g_oeb[l_ac].oeb13
                   CALL cl_numfor(g_oeb[l_ac].oeb14t,10,t_azi04) RETURNING g_oeb[l_ac].oeb14t       #CHI-7A0036-add
                   LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb14t/(1+g_oea.oea211/100)
                   CALL cl_numfor(g_oeb[l_ac].oeb14,10,t_azi04) RETURNING g_oeb[l_ac].oeb14         #CHI-7A0036-add
                END IF
             END IF
          END IF
      END IF
   END IF
   LET g_oeb_t.oeb1001 = g_oeb[l_ac].oeb1001  #No.TQC-740323
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oeb04_1(p_cmd)
   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_check_res   LIKE type_file.num5,   #No.FUN-680137 SMALLINT
          l_b2          LIKE cob_file.cob08,    #No.FUN-680137 VARCHAR(30)
          l_ima130      LIKE ima_file.ima130,    #No.FUN-680137 VARCHAR(1)
          l_ima131      LIKE ima_file.ima131,   #No.FUN-680137 VARCHAR(10)
          l_ima25       LIKE ima_file.ima25,
          l_imaacti     LIKE ima_file.imaacti,
          l_qty         LIKE oeb_file.oeb12,   #No.FUN-680137 INTEGER
          l_imaag       LIKE ima_file.imaag  #No.TQC-650111  By Rayven
   DEFINE b_azp03       LIKE type_file.chr21 #No.FUN-850100
   DEFINE e_azp03       LIKE type_file.chr21 #No.FUN-850100
   DEFINE l_poz011      LIKE poz_file.poz011 #No.FUN-850100
   DEFINE b_ima918      LIKE ima_file.ima918 #No.FUN-850100
   DEFINE b_ima921      LIKE ima_file.ima921 #No.FUN-850100
   DEFINE e_ima918      LIKE ima_file.ima918 #No.FUN-850100
   DEFINE e_ima921      LIKE ima_file.ima921 #No.FUN-850100
   DEFINE l_sql         STRING  #No.FUN-850100
   DEFINE b_azp01       LIKE type_file.chr21 #No.FUN-A50102
   DEFINE e_azp01       LIKE type_file.chr21 #No.FUN-A50102

   #AFTER FIELD 處理邏輯修改為使用下面的函數來進行判斷，請參考相關代碼
   CALL t400_check_oeb04('oeb04',l_ac,p_cmd)
               RETURNING l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,
                         g_buf2,l_ima25,l_imaacti,l_qty   #TQC-690041 add
   IF NOT l_check_res THEN
      RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,
             g_buf2,l_ima25,l_imaacti,l_qty
   END IF

   IF cl_null(g_oeb[l_ac].oeb09) THEN  #MOD-7C0023
      IF g_azw.azw04='2' THEN
         SELECT ima36 INTO g_oeb[l_ac].oeb091 FROM ima_file
          WHERE ima01=g_oeb[l_ac].oeb04
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("sel","ima_file",g_oeb[l_ac].oeb04,"",SQLCA.SQLCODE,"","",0)
            LET b_oeb.oeb091 = ''
         END IF
         SELECT rtz07 INTO g_oeb[l_ac].oeb09 FROM rtz_file
          WHERE rtz01=g_plant
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("sel","rtz_file",g_plant,"",SQLCA.SQLCODE,"","",0)
            LET b_oeb.oeb09 = ''
         END IF
      ELSE
      SELECT ima35,ima36 INTO g_oeb[l_ac].oeb09,g_oeb[l_ac].oeb091 FROM ima_file
       WHERE ima01 = g_oeb[l_ac].oeb04
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("sel","ima_file",g_oeb[l_ac].oeb04,"",SQLCA.SQLCODE,"","",0)
         LET b_oeb.oeb09  = ''
         LET b_oeb.oeb091 = ''
      END IF
      END IF #No.FUN-870007
   END IF   #MOD-7C0023

#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#   IF g_oea.oeaslk02<>'Y' THEN
#&endif
##FUN-A50054 --Begin
#FUN-A60035 ---MARK END
      SELECT imaag INTO l_imaag FROM ima_file
       WHERE ima01 = g_oeb[l_ac].oeb04
      IF NOT cl_null(l_imaag) AND l_imaag <> '@CHILD' THEN
         LET g_oeb[l_ac].oeb06 = ''
         LET g_oeb[l_ac].ima021 = ''
         CALL cl_err(g_oeb[l_ac].oeb04,'aim1004',0)
         RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,
                g_buf2,l_ima25,l_imaacti,l_qty
      END IF
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#   END IF
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END

   IF g_oea901="Y" THEN
      SELECT poz011 INTO l_poz011 FROM poz_file
       WHERE poz01 = g_oea.oea904

      IF l_poz011 = "1" THEN
         #SELECT azp03 INTO b_azp03
         SELECT azp01,azp03 INTO b_azp01,b_azp03  #FUN-A50102
           FROM poy_file,azp_file
          WHERE poy01 = g_oea.oea904
            AND poy02 IN (SELECT MIN(poy02) FROM poy_file
                           WHERE poy01= g_oea.oea904)
            AND poy04 = azp01

         #SELECT azp03 INTO e_azp03
         SELECT azp01,azp03 INTO e_azp01,e_azp03  #FUN-A50102
           FROM poy_file,azp_file
          WHERE poy01 = g_oea.oea904
            AND poy02 IN (SELECT MAX(poy02) FROM poy_file
                           WHERE poy01= g_oea.oea904)
            AND poy04 = azp01
      ELSE
         #SELECT azp03 INTO e_azp03
         SELECT azp01,azp03 INTO e_azp01,e_azp03  #FUN-A50102
           FROM poy_file,azp_file
          WHERE poy01 = g_oea.oea904
            AND poy02 IN (SELECT MIN(poy02) FROM poy_file
                           WHERE poy01= g_oea.oea904)
            AND poy04 = azp01

         #SELECT azp03 INTO b_azp03
         SELECT azp01,azp03 INTO b_azp01,b_azp03  #FUN-A50102
           FROM poy_file,azp_file
          WHERE poy01 = g_oea.oea904
            AND poy02 IN (SELECT MAX(poy02) FROM poy_file
                           WHERE poy01= g_oea.oea904)
            AND poy04 = azp01
      END IF

      LET b_azp03 = s_dbstring(b_azp03 CLIPPED)
      LET e_azp03 = s_dbstring(e_azp03 CLIPPED)
      #LET l_sql = " SELECT ima918,ima921 FROM ",b_azp03 CLIPPED,"ima_file ",
      LET l_sql = " SELECT ima918,ima921 FROM ",cl_get_target_table(b_azp01,'ima_file'), #FUN-A50102
                  "  WHERE ima01 ='",g_oeb[l_ac].oeb04,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102									
	  CALL cl_parse_qry_sql(l_sql,b_azp01) RETURNING l_sql      #FUN-A50102
      PREPARE b_ima_pre FROM l_sql

      DECLARE b_ima_cs CURSOR FOR b_ima_pre

      OPEN b_ima_cs

      FETCH b_ima_cs INTO b_ima918,b_ima921
      IF SQLCA.SQLCODE THEN
         CALL cl_err(b_azp03,'b_ima_cs',0)
      END IF

      IF cl_null(b_ima918) THEN
         LET b_ima918 = "N"
      END IF

      IF cl_null(b_ima921) THEN
         LET b_ima921 = "N"
      END IF

      #LET l_sql = " SELECT ima918,ima921 FROM ",e_azp03 CLIPPED,"ima_file ",
      LET l_sql = " SELECT ima918,ima921 FROM ",cl_get_target_table(e_azp01,'ima_file'), #FUN-A50102
                  "  WHERE ima01 ='",g_oeb[l_ac].oeb04,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102									
	  CALL cl_parse_qry_sql(l_sql,e_azp01) RETURNING l_sql      #FUN-A50102
      PREPARE e_ima_pre FROM l_sql

      DECLARE e_ima_cs CURSOR FOR e_ima_pre

      OPEN e_ima_cs

      FETCH e_ima_cs INTO e_ima918,e_ima921
      IF SQLCA.SQLCODE THEN
         CALL cl_err(e_azp03,'e_ima_cs',0)
      END IF

      IF cl_null(e_ima918) THEN
         LET e_ima918 = "N"
      END IF

      IF cl_null(e_ima921) THEN
         LET e_ima921 = "N"
      END IF

      IF e_ima918 = "Y" OR e_ima921 = "Y" THEN
         IF b_ima918 <> "Y" AND b_ima921 <> "Y" THEN    #No.TQC-950002 add
            CALL cl_err(g_oeb[l_ac].oeb04,'axm-087',1)
            RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,
                   g_buf2,l_ima25,l_imaacti,l_qty
         END IF
      END IF
   END IF

   RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,
          g_buf2,l_ima25,l_imaacti,l_qty

END FUNCTION

FUNCTION t400_bef_att00()
        #No.FUN-640013 , 當sma908 <> 'Y'的時候,即不准通過單身來新增子料件,這時
        #對于采用料件多屬性新機制(與單據性質綁定)的分支來說,各個明細屬性欄位都
        #變NOENTRY的, 只能通過在母料件欄位開窗來選擇子料件,并且母料件本身也不允許
        #接受輸入,而只能開窗,所以這里要進行一個特殊的處理,就是一進att00母料件
        #欄位的時候就auto開窗,開完窗之后直接NEXT FIELD以避免用戶亂動
        #其他分支就不需要這么麻煩了

              #根據子料件找到母料件及各個屬性
              SELECT imx00,imx01,imx02,imx03,imx04,imx05,
                     imx06,imx07,imx08,imx09,imx10
              INTO g_oeb[l_ac].att00, g_oeb[l_ac].att01, g_oeb[l_ac].att02,
                   g_oeb[l_ac].att03, g_oeb[l_ac].att04, g_oeb[l_ac].att05,
                   g_oeb[l_ac].att06, g_oeb[l_ac].att07, g_oeb[l_ac].att08,
                   g_oeb[l_ac].att09, g_oeb[l_ac].att10
              FROM imx_file
              WHERE imx000 = g_oeb[l_ac].oeb04

              LET g_oeb04 = g_oeb[l_ac].att00  #No.TQC-640171
              LET g_chr2  = '1'                #No.TQC-640171

              #賦值所有屬性
              LET g_oeb[l_ac].att01_c = g_oeb[l_ac].att01
              LET g_oeb[l_ac].att02_c = g_oeb[l_ac].att02
              LET g_oeb[l_ac].att03_c = g_oeb[l_ac].att03
              LET g_oeb[l_ac].att04_c = g_oeb[l_ac].att04
              LET g_oeb[l_ac].att05_c = g_oeb[l_ac].att05
              LET g_oeb[l_ac].att06_c = g_oeb[l_ac].att06
              LET g_oeb[l_ac].att07_c = g_oeb[l_ac].att07
              LET g_oeb[l_ac].att08_c = g_oeb[l_ac].att08
              LET g_oeb[l_ac].att09_c = g_oeb[l_ac].att09
              LET g_oeb[l_ac].att10_c = g_oeb[l_ac].att10
              #顯示所有屬性
              DISPLAY BY NAME g_oeb[l_ac].att00  #No.TQC-640171
              DISPLAY BY NAME
                g_oeb[l_ac].att01, g_oeb[l_ac].att01_c,
                g_oeb[l_ac].att02, g_oeb[l_ac].att02_c,
                g_oeb[l_ac].att03, g_oeb[l_ac].att03_c,
                g_oeb[l_ac].att04, g_oeb[l_ac].att04_c,
                g_oeb[l_ac].att05, g_oeb[l_ac].att05_c,
                g_oeb[l_ac].att06, g_oeb[l_ac].att06_c,
                g_oeb[l_ac].att07, g_oeb[l_ac].att07_c,
                g_oeb[l_ac].att08, g_oeb[l_ac].att08_c,
                g_oeb[l_ac].att09, g_oeb[l_ac].att09_c,
                g_oeb[l_ac].att10, g_oeb[l_ac].att10_c

END FUNCTION
FUNCTION t400_bef_oeb04()
   IF NOT cl_null(g_oeb[l_ac].oeb04) AND (g_oeb_t.oeb04 IS NULL OR (g_oeb[l_ac].oeb04 != g_oeb_t.oeb04))THEN
      IF g_oea.oea00<>'4' THEN #CHI-970074
         SELECT obk11 INTO g_oeb[l_ac].oeb906
           FROM obk_file
          WHERE obk01 = g_oeb[l_ac].oeb04
            AND obk02 = g_oea.oea03      #FUN-610055
            AND obk05 = g_oea.oea23      #No.FUN-670099
         IF cl_null(g_oeb[l_ac].oeb906) THEN
            LET g_oeb[l_ac].oeb906 = 'N'
         END IF
      ELSE #CHI-970074
         LET g_oeb[l_ac].oeb906='N' #CHI-970074
      END IF #CHI-970074
      DISPLAY BY NAME g_oeb[l_ac].oeb906
   END IF
END FUNCTION

FUNCTION t400_chk_oeb092()
   DEFINE l_cnt LIKE type_file.num5,
          l_qty LIKE img_file.img10    #No.FUN-680137 INTEGER

   IF NOT cl_null(g_oeb[l_ac].oeb092) THEN
#FUN-AB0011 ---------------------STR
      IF s_joint_venture( g_tlf.tlf01,g_plant) OR NOT s_internal_item( g_tlf.tlf01,g_plant ) THEN
      ELSE
#FUN-AB0011 ---------------------END
        IF g_oea.oea00!='0' THEN
            LET l_cnt=0
            SELECT COUNT(*),SUM(img10*img21) INTO l_cnt,l_qty FROM img_file
             WHERE img01 = g_oeb[l_ac].oeb04
               AND img04 = g_oeb[l_ac].oeb092
            IF l_cnt = 0 THEN
              #CALL cl_err('part+lot:','axm-244',0)       #CHI-A10002 mark
               CALL cl_err(g_oeb[l_ac].oeb04,'axm-244',0) #CHI-A10002 add
               RETURN FALSE
            END IF
            
            IF l_qty IS NULL THEN LET l_qty=0 END IF
            
            LET g_msg=NULL
            SELECT ze03 INTO g_msg FROM ze_file
             WHERE ze01 = 'axm-246'
               AND ze02 = p_lang
            ERROR g_msg CLIPPED,l_qty
        END IF
      END IF                                              #FUN-AB0011   
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oeb05(l_ima25)
   DEFINE l_check LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
   DEFINE l_ima25 LIKE ima_file.ima25,
          l_fac   LIKE oeb_file.oeb05_fac

   IF NOT cl_null(g_oeb[l_ac].oeb05) THEN
      SELECT COUNT(*) INTO g_cnt FROM gfe_file
       WHERE gfe01 = g_oeb[l_ac].oeb05
      IF g_cnt = 0 THEN
         CALL cl_err(g_oeb[l_ac].oeb05,'mfg3377',0)
         RETURN FALSE
      END IF
      CALL s_umfchk(g_oeb[l_ac].oeb04,g_oeb[l_ac].oeb05,l_ima25)
          RETURNING l_check,b_oeb.oeb05_fac
      IF l_check = '1'  THEN
         CALL cl_err(g_oeb[l_ac].oeb05,'abm-731',1)
         RETURN FALSE
      END IF
      IF g_oeb[l_ac].oeb917 = 0 OR
            (g_oeb_t.oeb05  <> g_oeb[l_ac].oeb05 OR
             g_oeb_t.oeb917 <> g_oeb[l_ac].oeb917) THEN

         IF g_sma.sma116 MATCHES '[01]' THEN
            LET g_oeb[l_ac].oeb916 = g_oeb[l_ac].oeb05
         END IF

         CALL t400_set_oeb917()
      END IF
     IF g_azw.azw04="2" THEN
         IF NOT cl_null(g_oeb[l_ac].oeb04) AND g_sma.sma116 MATCHES '[01]' THEN
            IF g_oeb_t.oeb05 IS NULL OR g_oeb_t.oeb05 <> g_oeb[l_ac].oeb05 THEN
               CALL t400_price_1(l_ac) RETURNING l_fac
               IF l_fac THEN
                  RETURN FALSE
               END IF
            END IF
         END IF
      ELSE
      IF g_aza.aza50 = 'Y' THEN  #No.FUN-650108
         IF NOT cl_null(g_oeb[l_ac].oeb04) AND g_sma.sma116 MATCHES '[01]' THEN
            IF g_oeb_t.oeb05 IS NULL OR g_oeb_t.oeb05 <> g_oeb[l_ac].oeb05 THEN
               CALL t400_price(l_ac) RETURNING l_fac
            END IF
         END IF
      END IF  #No.FUN-650108
     END IF #No.FUN-870007
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oeb12(p_cmd,l_qty,g_tt_oeb12)
   DEFINE l_qty   LIKE oeb_file.oeb12   #No.FUN-680137 INTEGER
   DEFINE p_cmd           LIKE type_file.chr1
   DEFINE g_tt_oeb12      LIKE oeb_file.oeb12,
          l_oqt12         LIKE oqt_file.oqt12,
          l_oqv05         LIKE oqv_file.oqv05,
          l_oeb23         LIKE oeb_file.oeb23,   #訂單待出貨數量
          l_oeb24         LIKE oeb_file.oeb24,   #訂單已出貨數量
          l_oeb25         LIKE oeb_file.oeb25,   #訂單已銷退數量
          l_ohb12         LIKE ohb_file.ohb12,   #銷退訂單數量    #MOD-730043
          l_oeb12         LIKE oeb_file.oeb12,   #換貨訂單數量    #MOD-730043
          l_oeb905        LIKE oeb_file.oeb905   #取出備置數量    #No:7578 add
   DEFINE l_oeb05         LIKE oeb_file.oeb05   #MOD-880038
   DEFINE l_cnt           LIKE type_file.num5   #MOD-880038
   DEFINE l_factor        LIKE ima_file.ima31_fac   #MOD-880038
   DEFINE l_fac_1         LIKE type_file.chr1    #No.FUN-870007
   DEFINE l_rth04         LIKE rth_file.rth04    #No.FUN-870007
   DEFINE l_rtg01         LIKE rtg_file.rtg01    #No.FUN-870007
   DEFINE l_rtg05         LIKE rtg_file.rtg05    #No.FUN-870007
   DEFINE l_rtg08         LIKE rtg_file.rtg08    #No.FUN-870007
   DEFINE l_sale_price    LIKE oeb_file.oeb13    #No.FUN-870007
   DEFINE l_ogb12_tot     LIKE ogb_file.ogb12    #MOD-9C0204
   DEFINE l_oeb12_tot     LIKE oeb_file.oeb12    #MOD-9C0204
   DEFINE l_count         LIKE type_file.num5    #TQC-A80141
   
   IF (g_oeb_t.oeb12 IS NULL AND g_oeb[l_ac].oeb12 IS NOT NULL) OR #CHI-960007 add()
      (g_oeb_t.oeb12 IS NOT NULL AND g_oeb[l_ac].oeb12 IS NULL) OR #CHI-960007 add()
      (g_oeb_t.oeb12 <> g_oeb[l_ac].oeb12) THEN #CHI-960007 add()
       LET g_change1='Y'
   END IF
   IF NOT cl_null(g_oeb[l_ac].oeb12) THEN
      IF g_oeb[l_ac].oeb12 <=0 THEN #No:7948
         CALL cl_err(g_oeb[l_ac].oeb12,'afa-037',0) #No.TQC-6B0117
         RETURN FALSE
      END IF
      IF g_oea.oea11 = '2' THEN
         #計算已新增換貨訂單數量(l_oeb12)
          LET l_oeb12=0
          SELECT SUM(oeb12) INTO l_oeb12 FROM oeb_file,oea_file
            WHERE oea12 = g_oea.oea12
              AND oea01 = oeb01
              AND oeb04 = g_oeb[l_ac].oeb04
                   AND (oeb03 <> g_oeb[l_ac].oeb03   #本身項次不列入計算
                         OR oeb01 <> g_oea.oea01)
              AND oeaconf <> 'X'   #MOD-A80145
               IF l_oeb12 IS NULL or l_oeb12 = '' THEN
                  LET l_oeb12 = 0
               END IF
          LET l_ohb12=0
          SELECT SUM(ohb12) INTO l_ohb12 FROM ohb_file #MOD-990026 ohb12-->SUM(ohb12)
           WHERE ohb01=g_oea.oea12         #銷退單
             AND ohb04=g_oeb[l_ac].oeb04   #料號
             LET l_ohb12 = l_ohb12 - l_oeb12  #可新增的銷退量
          IF l_ohb12 IS NULL or l_ohb12 = '' THEN
             LET l_ohb12 = 0
          END IF
          IF g_oeb[l_ac].oeb12 > l_ohb12 THEN
            CALL cl_err('','axm-033',0)
            RETURN FALSE
         END IF
      END IF
      IF g_oea.oea11='3' THEN
         SELECT oeb12*(100+oea09)/100-oeb24,oeb05 INTO l_qty,l_oeb05
           FROM oeb_file,oea_file
          WHERE oeb01 = g_oea.oea12
            AND oeb01 = oea01
            AND oeb03 = g_oeb[l_ac].oeb71
            AND oeb04 = g_oeb[l_ac].oeb04
         CALL s_umfchk(g_oeb[l_ac].oeb04,l_oeb05,g_oeb[l_ac].oeb05)
           RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN LET l_factor = 1 END IF
         LET l_qty = l_qty * l_factor
#TQC-A80141 --begin--
         LET l_count = 0 
         SELECT COUNT(*) INTO l_count FROM tqp_file
          WHERE tqp01 = g_oea.oea12
         IF l_count = 0 THEN  
#TQC-A80141 --end--         
            IF g_oeb[l_ac].oeb12 > l_qty THEN
              IF NOT cl_confirm('axm-240') THEN
                 RETURN FALSE
              END IF
            END IF
         END IF    #TQC-A80141
      END IF

      CALL t400_set_oeb917() #No.MOD-8A0137 move here

      IF g_oea.oea11='5' AND ( g_oeb[l_ac].oeb13 = 0 OR
          g_oeb[l_ac].oeb04 != g_oeb_t.oeb04  OR
          g_oeb[l_ac].oeb12 != g_tt_oeb12 ) THEN   #No.TQC-5B0078
         SELECT oqt12 INTO l_oqt12 FROM oqt_file
          WHERE oqt01=g_oea.oea12
         IF l_oqt12='Y' THEN   #分量計價-取單價
            SELECT oqv05 INTO l_oqv05 FROM oqv_file
             WHERE oqv01=g_oea.oea12
               AND oqv02=g_oeb[l_ac].oeb71
               AND g_oeb[l_ac].oeb12 BETWEEN oqv03 AND oqv04
            IF cl_null(l_oqv05)  THEN LET l_oqv05=0 END IF
            LET g_oeb[l_ac].oeb13=l_oqv05
            LET g_oeb[l_ac].oeb37 = l_oqv05    #FUN-AB0061 
            LET g_oeb17 = g_oeb[l_ac].oeb13   #no.7150
         END IF
      END IF

      IF g_oea.oea11 = '7' THEN
         SELECT SUM(ogb12) INTO l_ogb12_tot
           FROM ogb_file WHERE ogb01=g_oea.oea12
         IF cl_null(l_ogb12_tot) THEN LET l_ogb12_tot = 0 END IF
         SELECT SUM(oeb12) INTO l_oeb12_tot
           FROM oea_file,oeb_file
          WHERE oea01 = oeb01
            AND oeaconf <> 'X'
            AND oea12 = g_oea.oea12
            AND (oea01 <> g_oea.oea01 OR (oea01=g_oea.oea01 AND oeb71<>g_oeb[l_ac].oeb71))
         IF cl_null(l_oeb12_tot) THEN LET l_oeb12_tot = 0 END IF
         IF g_oeb[l_ac].oeb12 > l_ogb12_tot-l_oeb12_tot THEN
            CALL cl_err('','axm-383',0)
            RETURN FALSE
         END IF
      END IF

      IF g_oea.oea11 != '5' OR g_oea.oea11='4' THEN
        #CALL t400_fetch_price('a')   #FUN-AC0012
         CALL t400_fetch_price(p_cmd) #FUN-AC0012
      END IF
      IF p_cmd='u' THEN
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#&ifdef SLK
#        IF g_oea.oeaslk02 = 'Y' THEN
#           DECLARE t400_ata_q_1 SCROLL CURSOR FOR
#            SELECT ata03 FROM ata_file
#             WHERE ata00=g_prog
#               AND ata01=g_oea.oea01
#               AND ata02=g_oeb_t.oeb03
#        FOREACH t400_ata_q_1 INTO g_oeb_t.oeb03
#&endif
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
         #-->如果項次修正用g_oeb[l_ac].oeb03則會有問題
         SELECT oeb23,oeb24,oeb25 INTO l_oeb23,l_oeb24,l_oeb25
           FROM oeb_file
          WHERE oeb01=g_oea.oea01
            AND oeb03=g_oeb_t.oeb03
         IF STATUS THEN
            CALL cl_err3("sel","oeb_file",g_oea.oea01,g_oeb_t.oeb03,"axm-249","","oeb sel2:",1)  #No.FUN-650108
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#&ifdef SLK
#            LET g_oeb_t.oeb03 = g_oeb[l_ac].oeb03
#&endif
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
            RETURN FALSE
         END IF

         IF g_oeb[l_ac].oeb12 < l_oeb24+l_oeb23-l_oeb25 THEN
            CALL cl_err('oeb12:','axm-251',1)
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#&ifdef SLK
#            LET g_oeb_t.oeb03 = g_oeb[l_ac].oeb03
#&endif
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
            RETURN FALSE
         END IF

         SELECT oeb905 INTO l_oeb905 FROM oeb_file
          WHERE oeb01 = g_oea.oea01
            AND oeb03 = g_oeb_t.oeb03  #MOD-830183 modify  g_oeb[l_ac].oeb03
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","oeb_file",g_oea.oea01,g_oeb_t.oeb03,"axm-073","","",1)  #No.FUN-650108  #MOD-830183 modify
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#&ifdef SLK
#            LET g_oeb_t.oeb03 = g_oeb[l_ac].oeb03
#&endif
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
            RETURN FALSE
         ELSE
            IF cl_null(l_oeb905) THEN LET l_oeb905 = 0 END IF
            IF g_oeb[l_ac].oeb12 < l_oeb905 THEN
               CALL cl_err(g_oeb[l_ac].oeb04,'axm-072',1)
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#&ifdef SLK
#               LET g_oeb_t.oeb03 = g_oeb[l_ac].oeb03
#&endif
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
               RETURN FALSE
            END IF
         END IF
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#&ifdef SLK
#         END FOREACH
#         LET g_oeb_t.oeb03 = g_oeb[l_ac].oeb03
#         END IF
#&endif
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
      END IF
      IF cl_null(g_oeb[l_ac].oeb14) OR g_oeb[l_ac].oeb14 = 0 OR
         g_oeb[l_ac].oeb12 != g_oeb_t.oeb12 OR
         g_oeb[l_ac].oeb13 != g_oeb_t.oeb13 THEN
         IF g_oea.oea213 = 'N'  THEN # 不內含
            LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb917*g_oeb[l_ac].oeb13   #No.TQC-5C0107
            CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04)  RETURNING g_oeb[l_ac].oeb14      #CHI-7A0036-add
            LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb14*(1+g_oea.oea211/100)
            CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t     #CHI-7A0036-add
         ELSE
            LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb917*g_oeb[l_ac].oeb13   #No.TQC-5C0107
            CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t     #CHI-7A0036-add
            LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb14t/(1+g_oea.oea211/100)
            CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04)  RETURNING g_oeb[l_ac].oeb14      #CHI-7A0036-add
         END IF
      END IF

      IF cl_null(g_oeb[l_ac].oeb916) THEN
         LET g_oeb[l_ac].oeb916=g_oeb[l_ac].oeb05
         LET g_oeb[l_ac].oeb917=g_oeb[l_ac].oeb12
         DISPLAY BY NAME g_oeb[l_ac].oeb916
         DISPLAY BY NAME g_oeb[l_ac].oeb917
      END IF
      IF g_aza.aza50 = 'Y' THEN  #No.FUN-650108
         IF (g_oeb_t.oeb12 IS NULL OR g_oeb_t.oeb12 <> g_oeb[l_ac].oeb12)
            AND g_oeb[l_ac].oeb1012='N' THEN
            IF g_oea.oea213 = 'N' THEN
              LET g_oeb[l_ac].oeb14 = t400_amount(g_oeb[l_ac].oeb917,g_oeb[l_ac].oeb13,g_oeb[l_ac].oeb1006,t_azi03) #No.MOD-820066
              CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04)  RETURNING g_oeb[l_ac].oeb14      #CHI-7A0036-add
              LET g_oeb[l_ac].oeb14t= g_oeb[l_ac].oeb14*(1+ g_oea.oea211/100)
              CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t     #CHI-7A0036-add
            ELSE
              LET g_oeb[l_ac].oeb14t= t400_amount(g_oeb[l_ac].oeb917,g_oeb[l_ac].oeb13,g_oeb[l_ac].oeb1006,t_azi03) #No.MOD-820066
              CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t     #CHI-7A0036-add
              LET g_oeb[l_ac].oeb14 = g_oeb[l_ac].oeb14t/(1+ g_oea.oea211/100)
              CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04)  RETURNING g_oeb[l_ac].oeb14      #CHI-7A0036-add
            END IF
         END IF
       ELSE
          IF NOT cl_null(g_oeb[l_ac].oeb13) THEN
             IF g_oea.oea213 = 'N'  THEN
                LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb917*g_oeb[l_ac].oeb13
                CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04)  RETURNING g_oeb[l_ac].oeb14
                LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb14*(1+g_oea.oea211/100)
                CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t
             ELSE
                LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb917*g_oeb[l_ac].oeb13
                CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t
                LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb14t/(1+g_oea.oea211/100)
                CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04)  RETURNING g_oeb[l_ac].oeb14
             END IF
          END IF
       END IF  #No.FUN-650108
       DISPLAY BY NAME g_oeb[l_ac].oeb14
       DISPLAY BY NAME g_oeb[l_ac].oeb14t
   END IF
   IF g_oeb[l_ac].oeb1012 = 'Y' AND g_aza.aza50 = 'Y' THEN  #No.FUN-650108
      LET g_oeb[l_ac].oeb14=0
      LET g_oeb[l_ac].oeb14t=0
      DISPLAY BY NAME g_oeb[l_ac].oeb14
      DISPLAY BY NAME g_oeb[l_ac].oeb14t
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oeb913()
   IF cl_null(g_oeb[l_ac].oeb04) THEN RETURN FALSE END IF
   IF (g_oeb_t.oeb913 IS NULL AND g_oeb[l_ac].oeb913 IS NOT NULL) OR #CHI-960007 add()
      (g_oeb_t.oeb913 IS NOT NULL AND g_oeb[l_ac].oeb913 IS NULL) OR #CHI-960007 add()
      (g_oeb_t.oeb913 <> g_oeb[l_ac].oeb913) THEN #CHI-960007 add()
      LET g_change1='Y'
   END IF
   IF NOT cl_null(g_oeb[l_ac].oeb913) THEN
      SELECT gfe02 INTO g_buf FROM gfe_file
       WHERE gfe01=g_oeb[l_ac].oeb913
         AND gfeacti='Y'
      IF STATUS THEN
         CALL cl_err3("sel","gfe_file",g_oeb[l_ac].oeb913,"",STATUS,"","gfe:",1)  #No.FUN-650108
         RETURN FALSE
      END IF
      CALL s_du_umfchk(g_oeb[l_ac].oeb04,'','','',
                       g_ima31,g_oeb[l_ac].oeb913,g_ima906)
           RETURNING g_errno,g_factor
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_oeb[l_ac].oeb913,g_errno,0)
         RETURN FALSE
      END IF
      IF cl_null(g_oeb_t.oeb913) OR g_oeb_t.oeb913 <> g_oeb[l_ac].oeb913 THEN
         LET g_oeb[l_ac].oeb914 = g_factor
         DISPLAY BY NAME g_oeb[l_ac].oeb914
      END IF
   END IF
   CALL t400_set_required_b()  #FUN-610055
   CALL cl_show_fld_cont()     #FUN-550037(smin)
   RETURN TRUE
END FUNCTION

#FUNCTION t400_chk_oeb915()        #FUN-AC0012
FUNCTION t400_chk_oeb915(p_cmd)    #FUN-AC0012
 DEFINE p_cmd  LIKE type_file.chr1 #FUN-AC0012

   IF (g_oeb_t.oeb915 IS NULL AND g_oeb[l_ac].oeb915 IS NOT NULL) OR #CHI-960007 add()
      (g_oeb_t.oeb915 IS NOT NULL AND g_oeb[l_ac].oeb915 IS NULL) OR #CHI-960007 add()
      (g_oeb_t.oeb915 <> g_oeb[l_ac].oeb915) THEN #CHI-960007 add()
      LET g_change1='Y'
   END IF
   IF NOT cl_null(g_oeb[l_ac].oeb915) THEN
      IF g_oeb[l_ac].oeb915 < 0 THEN
         CALL cl_err('','aim-391',0)
         RETURN FALSE
      END IF
         IF g_ima906='3' THEN
            LET g_tot1=g_oeb[l_ac].oeb915*g_oeb[l_ac].oeb914
            IF cl_null(g_oeb[l_ac].oeb912) OR g_oeb[l_ac].oeb912=0 THEN #CHI-960022
               LET g_oeb[l_ac].oeb912=g_tot1*g_oeb[l_ac].oeb911
               DISPLAY BY NAME g_oeb[l_ac].oeb912
            END IF                                                      #CHI-960022
         END IF
   END IF
   IF g_change1='Y' THEN
      CALL t400_set_oeb917()
     #CALL t400_fetch_price('a')   #NO.FUN-960130-----add----
      CALL t400_fetch_price(p_cmd) #FUN-AC0012
      IF g_oea.oea213 = 'N'  THEN # 不內含
         LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb917*g_oeb[l_ac].oeb13
         CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04)  RETURNING g_oeb[l_ac].oeb14    #CHI-7A0036-add
         LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb14*(1+g_oea.oea211/100)
         CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t   #CHI-7A0036-add
      ELSE
         LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb917*g_oeb[l_ac].oeb13
         CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t   #CHI-7A0036-add
         LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb14t/(1+g_oea.oea211/100)
         CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04)  RETURNING g_oeb[l_ac].oeb14    #CHI-7A0036-add
      END IF
      DISPLAY BY NAME g_oeb[l_ac].oeb04
      DISPLAY BY NAME g_oeb[l_ac].oeb14t
   END IF
   CALL cl_show_fld_cont()     #FUN-550037(smin)
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oeb910()
   IF cl_null(g_oeb[l_ac].oeb04) THEN RETURN FALSE END IF
   IF (g_oeb_t.oeb910 IS NULL AND g_oeb[l_ac].oeb910 IS NOT NULL) OR #CHI-960007 add()
      (g_oeb_t.oeb910 IS NOT NULL AND g_oeb[l_ac].oeb910 IS NULL) OR #CHI-960007 add()
      (g_oeb_t.oeb910 <> g_oeb[l_ac].oeb910) THEN #CHI-960007 add()
      LET g_change1='Y'
   END IF
   IF NOT cl_null(g_oeb[l_ac].oeb910) THEN
      SELECT gfe02 INTO g_buf FROM gfe_file
       WHERE gfe01=g_oeb[l_ac].oeb910
         AND gfeacti='Y'
      IF STATUS THEN
         CALL cl_err3("sel","gfe_file",g_oeb[l_ac].oeb910,"",STATUS,"","gfe:",1)  #No.FUN-650108
         RETURN FALSE
      END IF
      CALL t400_set_origin_field('b')
      CALL s_du_umfchk(g_oeb[l_ac].oeb04,'','','',
                       g_oeb[l_ac].oeb05,g_oeb[l_ac].oeb910,'1')
           RETURNING g_errno,g_factor
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_oeb[l_ac].oeb910,g_errno,0)
         RETURN FALSE
      END IF
      IF cl_null(g_oeb_t.oeb910) OR g_oeb_t.oeb910 <> g_oeb[l_ac].oeb910 THEN
         LET g_oeb[l_ac].oeb911 = g_factor
         DISPLAY BY NAME g_oeb[l_ac].oeb911
      END IF
   END IF
   CALL t400_set_required_b()  #FUN-610055
   CALL cl_show_fld_cont()     #FUN-550037(smin)
   RETURN TRUE
END FUNCTION

#FUNCTION t400_chk_oeb912()     #FUN-AC0012
FUNCTION t400_chk_oeb912(p_cmd) #FUN-AC0012
 DEFINE p_cmd           LIKE type_file.chr1   #FUN-AC0012
 DEFINE l_ogb12_tot     LIKE ogb_file.ogb12   #MOD-A80202
 DEFINE l_oeb12_tot     LIKE oeb_file.oeb12   #MOD-A80202 

   IF (g_oeb_t.oeb912 IS NULL AND g_oeb[l_ac].oeb912 IS NOT NULL) OR #CHI-960007 add()
      (g_oeb_t.oeb912 IS NOT NULL AND g_oeb[l_ac].oeb912 IS NULL) OR #CHI-960007 add()
      (g_oeb_t.oeb912 <> g_oeb[l_ac].oeb912) THEN #CHI-960007 add()
      LET g_change1='Y'
   END IF
   #-----MOD-A80202---------
   CALL t400_set_origin_field('b')  
   IF g_oea.oea11 = '7' THEN
      SELECT SUM(ogb12) INTO l_ogb12_tot
        FROM ogb_file WHERE ogb01=g_oea.oea12
      IF cl_null(l_ogb12_tot) THEN LET l_ogb12_tot = 0 END IF 
      SELECT SUM(oeb12) INTO l_oeb12_tot
        FROM oea_file,oeb_file 
       WHERE oea01 = oeb01 
         AND oeaconf <> 'X' 
         AND oea12 = g_oea.oea12
         AND (oea01 <> g_oea.oea01 OR (oea01=g_oea.oea01 AND oeb71<>g_oeb[l_ac].oeb71))
      IF cl_null(l_oeb12_tot) THEN LET l_oeb12_tot = 0 END IF 
      IF g_oeb[l_ac].oeb12 > l_ogb12_tot-l_oeb12_tot THEN
         CALL cl_err('','axm-383',0)
         RETURN FALSE
      END IF
   END IF
   #-----END MOD-A80202----- 
   IF NOT cl_null(g_oeb[l_ac].oeb912) THEN
      IF g_oeb[l_ac].oeb912 < 0 THEN
         CALL cl_err('','aim-391',0)
         RETURN FALSE
      END IF
   END IF
   IF g_change1='Y' THEN
      CALL t400_set_oeb917()
     #CALL t400_fetch_price('a')   #NO.FUN-960130-----add----
      CALL t400_fetch_price(p_cmd) #FUN-AC0012
      IF g_oea.oea213 = 'N'  THEN # 不內含
         LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb917*g_oeb[l_ac].oeb13
         CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04)  RETURNING g_oeb[l_ac].oeb14    #CHI-7A0036-add
         LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb14*(1+g_oea.oea211/100)
         CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t   #CHI-7A0036-add
      ELSE
         LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb917*g_oeb[l_ac].oeb13
         CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t   #CHI-7A0036-add
         LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb14t/(1+g_oea.oea211/100)
         CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04)  RETURNING g_oeb[l_ac].oeb14    #CHI-7A0036-add
      END IF
      DISPLAY BY NAME g_oeb[l_ac].oeb14
      DISPLAY BY NAME g_oeb[l_ac].oeb14t
   END IF
   CALL cl_show_fld_cont()     #FUN-550037(smin)
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oeb916()
   DEFINE l_fac   LIKE oeb_file.oeb05_fac

   IF cl_null(g_oeb[l_ac].oeb04) THEN RETURN FALSE END IF
   IF (g_oeb_t.oeb916 IS NULL AND g_oeb[l_ac].oeb916 IS NOT NULL) OR #CHI-960007 add()
      (g_oeb_t.oeb916 IS NOT NULL AND g_oeb[l_ac].oeb916 IS NULL) OR #CHI-960007 add()
      (g_oeb_t.oeb916 <> g_oeb[l_ac].oeb916) THEN #CHI-960007 add()
      LET g_change1='Y'
   END IF
   IF NOT cl_null(g_oeb[l_ac].oeb916) THEN
      SELECT gfe02 INTO g_buf FROM gfe_file
       WHERE gfe01=g_oeb[l_ac].oeb916
         AND gfeacti='Y'
      IF STATUS THEN
         CALL cl_err3("sel","gfe_file",g_oeb[l_ac].oeb916,"",STATUS,"","gfe:",1)  #No.FUN-650108
         RETURN FALSE
      END IF
      CALL s_du_umfchk(g_oeb[l_ac].oeb04,'','','',
                       g_ima31,g_oeb[l_ac].oeb916,'1')
           RETURNING g_errno,g_factor
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_oeb[l_ac].oeb916,g_errno,0)
         RETURN FALSE
      END IF
   END IF
   CALL t400_set_required_b()  #FUN-610055
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oeb917()
   IF NOT cl_null(g_oeb[l_ac].oeb917) THEN
      IF g_oeb[l_ac].oeb917 < 0 THEN
         CALL cl_err('','aim-391',0)
         RETURN FALSE
      END IF
      IF g_aza.aza50 = 'Y' THEN  #No.FUN-650108
         IF (g_oeb_t.oeb917 IS NULL OR g_oeb_t.oeb917 <> g_oeb[l_ac].oeb917)
            AND g_oeb[l_ac].oeb1012='N' THEN
            IF g_oea.oea213 = 'N' THEN
              LET g_oeb[l_ac].oeb14 = t400_amount(g_oeb[l_ac].oeb917,g_oeb[l_ac].oeb13,g_oeb[l_ac].oeb1006,t_azi03) #No.MOD-820066
              CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04)  RETURNING g_oeb[l_ac].oeb14    #CHI-7A0036-add
              LET g_oeb[l_ac].oeb14t= g_oeb[l_ac].oeb14*(1+ g_oea.oea211/100)
              CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t   #CHI-7A0036-add
            ELSE
              LET g_oeb[l_ac].oeb14t= t400_amount(g_oeb[l_ac].oeb917,g_oeb[l_ac].oeb13,g_oeb[l_ac].oeb1006,t_azi03) #No.MOD-820066
              CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t   #CHI-7A0036-add
              LET g_oeb[l_ac].oeb14 = g_oeb[l_ac].oeb14t/(1+ g_oea.oea211/100)
              CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04)  RETURNING g_oeb[l_ac].oeb14    #CHI-7A0036-add
            END IF
         END IF
      ELSE
         IF NOT cl_null(g_oeb[l_ac].oeb13) THEN
            IF g_oea.oea213 = 'N'  THEN
               LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb917*g_oeb[l_ac].oeb13
               CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04)  RETURNING g_oeb[l_ac].oeb14    #CHI-7A0036-add
               LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb14*(1+g_oea.oea211/100)
               CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t   #CHI-7A0036-add
            ELSE
               LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb917*g_oeb[l_ac].oeb13
               CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t   #CHI-7A0036-add
               LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb14t/(1+g_oea.oea211/100)
               CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04)  RETURNING g_oeb[l_ac].oeb14    #CHI-7A0036-add
            END IF
         END IF
      END IF
      DISPLAY BY NAME g_oeb[l_ac].oeb14
      DISPLAY BY NAME g_oeb[l_ac].oeb14t
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oeb03(p_cmd,p_chk)
   DEFINE p_cmd           LIKE type_file.chr1,
          p_chk           LIKE type_file.chr1,
          l_cnt           LIKE type_file.num10,
          l_oeb23         LIKE oeb_file.oeb23,   #訂單待出貨數量
          l_oeb24         LIKE oeb_file.oeb24,   #訂單已出貨數量
          l_oeb25         LIKE oeb_file.oeb25    #訂單已銷退數量

   IF NOT cl_null(g_oeb[l_ac].oeb03) THEN
      IF g_oeb[l_ac].oeb03 != g_oeb_t.oeb03 THEN
         IF b_oeb.oeb24 > 0 THEN
            CALL cl_err('','axm-254',0)
            LET g_oeb[l_ac].oeb03 = g_oeb_t.oeb03
            RETURN FALSE,p_chk
         END IF
      END IF
      IF g_oeb[l_ac].oeb03 != g_oeb_t.oeb03 OR
         g_oeb_t.oeb03 IS NULL THEN
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#         IF g_oea.oeaslk02 = 'Y' THEN
#            SELECT COUNT(*) INTO l_cnt FROM ata_file
#             WHERE ata00 = g_prog
#               AND ata01 = g_oea.oea01
#               AND ata02 = g_oeb[l_ac].oeb03
#         ELSE
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END
         SELECT count(*) INTO l_cnt FROM oeb_file
          WHERE oeb01 = g_oea.oea01 AND oeb03 = g_oeb[l_ac].oeb03
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#         END IF
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END
         IF l_cnt > 0 THEN
            LET g_oeb[l_ac].oeb03 = g_oeb_t.oeb03
            CALL cl_err('',-239,0)
            RETURN FALSE,p_chk
         END IF
      END IF

      IF g_aza.aza50 = 'Y' THEN  #No.FUN-650108
         IF g_oeb[l_ac].oeb03 > 9000 THEN
            CALL cl_err('','atm-004',0)
            LET g_oeb[l_ac].oeb03 = g_oeb_t.oeb03
            RETURN FALSE,p_chk
         END IF
      END IF  #No.FUN-650108

      IF p_cmd='u' THEN
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#&ifdef SLK
#        IF g_oea.oeaslk02 = 'Y' THEN
#           DECLARE t400_ata_q_2 SCROLL CURSOR FOR
#            SELECT ata03 FROM ata_file
#             WHERE ata00=g_prog
#               AND ata01=g_oea.oea01
#               AND ata02=g_oeb_t.oeb03
#        FOREACH t400_ata_q_2 INTO g_oeb_t.oeb03
#&endif
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
         #-->如果項次修正用g_oeb[l_ac].oeb03則會有問題
         SELECT oeb23,oeb24,oeb25,oeb17
           INTO l_oeb23,l_oeb24,l_oeb25,g_oeb17 #no.7150 (抓oeb17)
           FROM oeb_file
          WHERE oeb01=g_oea.oea01 AND oeb03=g_oeb_t.oeb03
         IF STATUS THEN
            CALL cl_err3("sel","oeb_file",g_oea.oea01,g_oeb_t.oeb03,"axm-249","","oeb sel2:",1)  #No.FUN-650108
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#&ifdef SLK
#            LET g_oeb_t.oeb03 = g_oeb[l_ac].oeb03
#&endif
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
            RETURN FALSE,p_chk
         END IF
         LET p_chk = 'N'
         IF l_oeb23>0 OR l_oeb24>0 OR l_oeb25>0 THEN
            CALL cl_err('oeb13:','axm-252',2)
            LET p_chk = 'Y'
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#&ifdef SLK
#            EXIT FOREACH
#&endif
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
         END IF
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#&ifdef SLK
#         END FOREACH
#         LET g_oeb_t.oeb03 = g_oeb[l_ac].oeb03
#         END IF
#&endif
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
      END IF
   END IF
   RETURN TRUE,p_chk
END FUNCTION

#RETURN 值為 oeb915 或 oeb912 為檢查有問題需NEXT FIELD到回傳值的欄位; NULL(表示檢查沒有錯誤)
FUNCTION t400_bef_oeb13(p_cmd,l_qty)
   DEFINE p_cmd           LIKE type_file.chr1,
          l_qty           LIKE oeb_file.oeb12,
          l_oqt12         LIKE oqt_file.oqt12,
          l_oqv05         LIKE oqv_file.oqv05,
          l_oeb23         LIKE oeb_file.oeb23,   #訂單待出貨數量
          l_oeb24         LIKE oeb_file.oeb24,   #訂單已出貨數量
          l_oeb25         LIKE oeb_file.oeb25,   #訂單已銷退數量
          l_oeb905        LIKE oeb_file.oeb905   #取出備置數量    #No:7578 add
   DEFINE l_oeb05         LIKE oeb_file.oeb05   #MOD-880038
   DEFINE l_cnt           LIKE type_file.num5   #MOD-880038
   DEFINE l_factor        LIKE ima_file.ima31_fac   #MOD-880038
#  DEFINE l_oeb12         LIKE oeb_file.oeb12   #FUN-A60035 add   #FUN-A60035 ---MARK
   DEFINE l_count         LIKE type_file.num5   #TQC-A80141

   IF g_sma.sma115 = 'Y' THEN
      CALL t400_set_origin_field('b')
      IF NOT cl_null(g_oeb[l_ac].oeb12) THEN
         IF g_oeb[l_ac].oeb12 <=0 THEN #No:7948
            IF g_ima906 MATCHES '[23]' THEN
               RETURN "oeb915"
            ELSE
               RETURN "oeb912"
            END IF
         END IF
         IF g_oea.oea11='3' THEN
            SELECT oeb12*(100+oea09)/100-oeb24,oeb05 INTO l_qty,l_oeb05
              FROM oeb_file,oea_file
             WHERE oeb01 = g_oea.oea12
               AND oeb01 = oea01
               AND oeb03 = g_oeb[l_ac].oeb71
               AND oeb04 = g_oeb[l_ac].oeb04
            CALL s_umfchk(g_oeb[l_ac].oeb04,l_oeb05,g_oeb[l_ac].oeb05)
              RETURNING l_cnt,l_factor
            IF l_cnt = 1 THEN LET l_factor = 1 END IF
            LET l_qty = l_qty * l_factor
#TQC-A80141 --begin--
            LET l_count = 0 
            SELECT COUNT(*) INTO l_count FROM tqp_file
             WHERE tqp01 = g_oea.oea12
            IF l_count = 0 THEN  
#TQC-A80141 --end---            
              IF g_oeb[l_ac].oeb12 > l_qty THEN
                 IF NOT cl_confirm('axm-240') THEN
                    IF g_ima906 MATCHES '[23]' THEN
                       RETURN "oeb915"
                    ELSE
                       RETURN "oeb912"
                    END IF
                 END IF
              END IF
            END IF    #TQC-A80141  
         END IF

         IF g_oea.oea11='5' AND ( g_oeb[l_ac].oeb13 = 0 OR #MOD-570248 add oeb12,oeb912,oeb915,oeb917條件
            g_oeb[l_ac].oeb04 != g_oeb_t.oeb04  OR
            g_oeb[l_ac].oeb12 != g_oeb_t.oeb12  OR
            g_oeb[l_ac].oeb912!= g_oeb_t.oeb912 OR
            g_oeb[l_ac].oeb915!= g_oeb_t.oeb915 OR
            g_oeb[l_ac].oeb917!= g_oeb_t.oeb917) THEN
            SELECT oqt12 INTO l_oqt12 FROM oqt_file
             WHERE oqt01=g_oea.oea12
            IF l_oqt12='Y' THEN   #分量計價-取單價
               SELECT oqv05 INTO l_oqv05 FROM oqv_file
                WHERE oqv01=g_oea.oea12 AND
                      oqv02=g_oeb[l_ac].oeb71 AND
                      g_oeb[l_ac].oeb12 BETWEEN oqv03 AND oqv04
               IF cl_null(l_oqv05)  THEN LET l_oqv05=0  END IF
               LET g_oeb[l_ac].oeb13=l_oqv05
               LET g_oeb[l_ac].oeb37 = l_oqv05          #FUN-AB0061`
               LET g_oeb17 = g_oeb[l_ac].oeb13   #no.7150
               DISPLAY BY NAME g_oeb[l_ac].oeb13 #MOD-570248 add 重新DISPLAY ..確保正確跑ON ROW CHANGE
               DISPLAY BY NAME g_oeb[l_ac].oeb37        #FUN-AB0061
            END IF
         END IF

         IF p_cmd='u' THEN
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#&ifdef SLK
#           IF g_oea.oeaslk02 = 'Y' THEN
#              LET l_oeb12 = g_oeb[l_ac].oeb12
#              DECLARE t400_ata_q_3 SCROLL CURSOR FOR
#               SELECT ata03,ata08 FROM ata_file
#                WHERE ata00=g_prog
#                  AND ata01=g_oea.oea01
#                  AND ata02=g_oeb_t.oeb03
#           FOREACH t400_ata_q_3 INTO g_oeb_t.oeb03,g_oeb[l_ac].oeb12
#&endif
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
            #-->如果項次修正用g_oeb[l_ac].oeb03則會有問題
            SELECT oeb23,oeb24,oeb25 INTO l_oeb23,l_oeb24,l_oeb25
              FROM oeb_file
             WHERE oeb01=g_oea.oea01 AND oeb03=g_oeb_t.oeb03
            IF STATUS THEN
               CALL cl_err3("sel","oeb_file",g_oea.oea01,g_oeb_t.oeb03,"axm-249","","oeb sel2:",1)  #No.FUN-650108
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#&ifdef SLK
#               LET g_oeb_t.oeb03 = g_oeb[l_ac].oeb03
#               LET g_oeb[l_ac].oeb12 = l_oeb12
#&endif
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
               IF g_ima906 MATCHES '[23]' THEN
                  RETURN "oeb915"
               ELSE
                  RETURN "oeb912"
               END IF
            END IF
            IF g_oeb[l_ac].oeb12 < l_oeb24+l_oeb23-l_oeb25 THEN
               CALL cl_err('oeb12:','axm-251',1)
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#&ifdef SLK
#               LET g_oeb_t.oeb03 = g_oeb[l_ac].oeb03
#               LET g_oeb[l_ac].oeb12 = l_oeb12
#&endif
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
               IF g_ima906 MATCHES '[23]' THEN
                  RETURN "oeb915"
               ELSE
                  RETURN "oeb912"
               END IF
            END IF
            SELECT oeb905 INTO l_oeb905 FROM oeb_file
             WHERE oeb01 = g_oea.oea01
               AND oeb03 = g_oeb_t.oeb03 #MOD-820183 modify g_oeb[l_ac].oeb03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","oeb_file",g_oea.oea01,g_oeb_t.oeb03,"axm-073","","",1)  #No.FUN-650108  #MOD-830183 modify
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#&ifdef SLK
#               LET g_oeb_t.oeb03 = g_oeb[l_ac].oeb03
#               LET g_oeb[l_ac].oeb12 = l_oeb12
#&endif
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
               IF g_ima906 MATCHES '[23]' THEN
                  RETURN "oeb915"
               ELSE
                  RETURN "oeb912"
               END IF
            ELSE
               IF cl_null(l_oeb905) THEN LET l_oeb905 = 0 END IF
               IF g_oeb[l_ac].oeb12 < l_oeb905 THEN
                  CALL cl_err(g_oeb[l_ac].oeb04,'axm-072',1)
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#&ifdef SLK
#                  LET g_oeb_t.oeb03 = g_oeb[l_ac].oeb03
#                  LET g_oeb[l_ac].oeb12 = l_oeb12
#&endif
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
                  IF g_ima906 MATCHES '[23]' THEN
                     RETURN "oeb915"
                  ELSE
                     RETURN "oeb912"
                  END IF
               END IF
            END IF
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#&ifdef SLK
#            END FOREACH
#            LET g_oeb_t.oeb03 = g_oeb[l_ac].oeb03
#            LET g_oeb[l_ac].oeb12 = l_oeb12
#            END IF
#&endif
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
         END IF
         IF cl_null(g_oeb[l_ac].oeb14) OR g_oeb[l_ac].oeb14 = 0 OR
            g_oeb[l_ac].oeb12 != g_oeb_t.oeb12 OR
            g_oeb[l_ac].oeb13 != g_oeb_t.oeb13 OR      #No.FUN-650108
            g_oeb[l_ac].oeb917 != g_oeb_t.oeb917 THEN  #No.FUN-650108
            IF g_oea.oea213 = 'N'  THEN # 不內含
               #No.用計價數量來算
               LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb917*g_oeb[l_ac].oeb13
               CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04) RETURNING g_oeb[l_ac].oeb14    #CHI-7A0036-add
               LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb14*(1+g_oea.oea211/100)
               CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t  #CHI-7A0036-add
            ELSE
               LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb917*g_oeb[l_ac].oeb13
               CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t  #CHI-7A0036-add
               LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb14t/(1+g_oea.oea211/100)
               CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04) RETURNING g_oeb[l_ac].oeb14    #CHI-7A0036-add
            END IF
            DISPLAY BY NAME g_oeb[l_ac].oeb14
            DISPLAY BY NAME g_oeb[l_ac].oeb14t
         END IF
      END IF
   END IF
   RETURN NULL
END FUNCTION

FUNCTION t400_chk_oeb13_1()
   IF NOT cl_null(g_oeb[l_ac].oeb13) THEN
      IF g_oeb[l_ac].oeb13 < 0 THEN
         CALL cl_err(g_oeb[l_ac].oeb13,'aom-557',0)
         RETURN FALSE
      END IF
      CALL cl_digcut(g_oeb[l_ac].oeb13,t_azi03)RETURNING g_oeb[l_ac].oeb13       #No.CHI-6A0004
      CALL cl_digcut(g_oeb[l_ac].oeb37,t_azi03)RETURNING g_oeb[l_ac].oeb37       #FUN-AB0061  
      DISPLAY BY NAME g_oeb[l_ac].oeb13    #No.TQC-6B0058
      DISPLAY BY NAME g_oeb[l_ac].oeb37    #FUN-AB0061 

      # 當oeb14為NULL時才default modify by WUPN 96-05-09
      IF NOT cl_null(g_oeb[l_ac].oeb13) THEN #MOD-840473
           #用計價數量來算
           IF g_oea.oea213 = 'N' # 不內含
           THEN
              LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb917*g_oeb[l_ac].oeb13
              CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04) RETURNING g_oeb[l_ac].oeb14    #CHI-7A0036-add
              LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb14*(1+g_oea.oea211/100)
              CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t  #CHI-7A0036-add
           ELSE
              LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb917*g_oeb[l_ac].oeb13
              CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t  #CHI-7A0036-add
              LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb14t/(1+g_oea.oea211/100)
              CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04) RETURNING g_oeb[l_ac].oeb14    #CHI-7A0036-add
           END IF
         DISPLAY BY NAME g_oeb[l_ac].oeb14,g_oeb[l_ac].oeb14t
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oeb13_2()
   DEFINE l_oeb17 LIKE oeb_file.oeb17
   DEFINE l_msg LIKE type_file.chr1000    #MOD-780014 add
   DEFINE l_azf08 LIKE azf_file.azf08   #MOD-9C0326
   IF NOT cl_null(g_oeb[l_ac].oeb13) THEN
      # 檢查訂單單價是否低於取出單價(合約訂單不卡)
      IF g_oea.oea00 != '0' THEN
         LET l_oeb17 = g_oeb17 * (100-g_oaz.oaz185) / 100
         LET l_oeb17 = cl_digcut(l_oeb17,t_azi03)               #No.CHI-6A0004
      END IF
      LET l_azf08 = ''
      SELECT azf08 INTO l_azf08 FROM azf_file
       WHERE azf01 = g_oeb[l_ac].oeb1001
         AND azf02 = '2'
         AND azfacti ='Y'
      LET g_errno= ' '   #CHI-840073 add
      IF g_oeb[l_ac].oeb13 < l_oeb17 AND (l_azf08 = 'N' OR cl_null(l_azf08)) THEN   #MOD-9C0326
         CASE g_oaz.oaz184
            WHEN 'R' CALL cl_err(l_oeb17,'axm-802',1)
                     LET g_oeb[l_ac].oeb13 = g_oeb_t.oeb13
                     DISPLAY BY NAME g_oeb[l_ac].oeb13
                     LET g_oeb[l_ac].oeb37 = g_oeb_t.oeb37      #FUN-AB0061
                     DISPLAY BY NAME g_oeb[l_ac].oeb37          #FUN-AB0061
                     LET g_errno='axm-802'   #CHI-840073 add
            WHEN 'W' #CALL cl_err(l_oeb17,'axm-802',1)
                     LET l_msg = cl_getmsg('axm-802',g_lang)
                     LET l_msg=l_msg CLIPPED,l_oeb17
                     CALL cl_msgany(10,20,l_msg)
            WHEN 'N' EXIT CASE
         END CASE
      END IF
   END IF
END FUNCTION

FUNCTION t400_chk_oeb13_3()
DEFINE l_rtg08 LIKE rtg_file.rtg08
DEFINE l_rtg07 LIKE rtg_file.rtg07
DEFINE l_rtg01 LIKE rtg_file.rtg01
DEFINE l_rth06 LIKE rth_file.rth06

    LET g_errno=''
    IF g_oeb[l_ac].oeb13<=0  THEN
       LET g_errno='art-180'
       RETURN
    END IF
    SELECT rtz05 INTO l_rtg01 FROM rtz_file
     WHERE rtz01 = g_plant
    SELECT rtg07,rtg08 INTO l_rtg07,l_rtg08 FROM rtg_file
     WHERE rtg01=g_oeb[l_ac].oeb04 AND rth02=g_oeb[l_ac].oeb05
    IF SQLCA.sqlcode=100 THEN
       LET g_errno='art-273'
       RETURN
    END IF
    IF l_rtg08='Y' THEN
       SELECT rth06 INTO l_rth06 FROM rth_file
        WHERE rth01=g_oeb[l_ac].oeb04
          AND rth02=g_oeb[l_ac].oeb05
          AND rthplant=g_oea.oeaplant
       IF SQLCA.sqlcode=100 THEN
          LET g_errno = 'art-273'
          RETURN
       END IF
       IF g_oeb[l_ac].oeb13<l_rth06 THEN
          LET g_errno='art-300'
          RETURN
       END IF
    ELSE
       IF g_oeb[l_ac].oeb13<l_rtg07 THEN
          LET g_errno='art-268'
          RETURN
       END IF
    END IF
END FUNCTION

FUNCTION t400_chk_oeb14()
DEFINE l_amt     LIKE oeb_file.oeb14       #No.TQC-7B0136

   IF NOT cl_null(g_oeb[l_ac].oeb14) THEN
      IF g_oeb[l_ac].oeb14 < 0 THEN
         CALL cl_err(g_oeb[l_ac].oeb14,'aom-557',0)
         RETURN FALSE
      END IF
      CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04) RETURNING g_oeb[l_ac].oeb14              #No.CHI-6A0004
      IF NOT cl_null(g_oeb[l_ac].oeb14t) THEN
         IF g_oeb[l_ac].oeb14t < g_oeb[l_ac].oeb14 THEN
            CALL cl_err("",'aap-211', 1)
            RETURN FALSE
         END IF
      END IF
      DISPLAY BY NAME g_oeb[l_ac].oeb14
      DISPLAY BY NAME g_oeb[l_ac].oeb14t
      IF g_sma.sma116 ='0' THEN
         LET l_amt =g_oeb[l_ac].oeb12*g_oeb[l_ac].oeb13
      ELSE
         LET l_amt =g_oeb[l_ac].oeb916*g_oeb[l_ac].oeb13
      END IF
      CALL cl_digcut(l_amt,t_azi04) RETURNING l_amt  #MOD-810072 add
      IF g_oeb[l_ac].oeb14t < l_amt THEN
         CALL cl_err('','axm-761',1)
         RETURN FALSE
      END IF
   END IF   #No.TQC-6B0117
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oeb14t()
DEFINE l_amt     LIKE oeb_file.oeb14t      #No.TQC-7B0136

   IF NOT cl_null(g_oeb[l_ac].oeb14t) THEN
      IF g_oeb[l_ac].oeb14t < 0 THEN
         CALL cl_err(g_oeb[l_ac].oeb14t,'aom-557',0)
         RETURN FALSE
      END IF
      CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04)             #No.CHI-6A0004
                     RETURNING g_oeb[l_ac].oeb14t
      CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04) RETURNING g_oeb[l_ac].oeb14              #No.CHI-6A0004
      IF NOT cl_null(g_oeb[l_ac].oeb14) THEN
         IF g_oeb[l_ac].oeb14t < g_oeb[l_ac].oeb14 THEN
            CALL cl_err("",'aap-211', 1)
            RETURN FALSE
         END IF
      END IF
      DISPLAY BY NAME g_oeb[l_ac].oeb14
      DISPLAY BY NAME g_oeb[l_ac].oeb14t
      IF g_oea.oea213 ='Y' THEN
         IF g_sma.sma116 ='0' THEN
            LET l_amt =g_oeb[l_ac].oeb12*g_oeb[l_ac].oeb13*g_oea.oea211/100
         ELSE
            LET l_amt =g_oeb[l_ac].oeb916*g_oeb[l_ac].oeb13*g_oea.oea211/100
         END IF
      ELSE
         IF g_sma.sma116 ='0' THEN
            LET l_amt =g_oeb[l_ac].oeb12*g_oeb[l_ac].oeb13
         ELSE
            LET l_amt =g_oeb[l_ac].oeb916*g_oeb[l_ac].oeb13
         END IF
      END IF
      CALL cl_digcut(l_amt,t_azi04) RETURNING l_amt  #MOD-850014 add
      IF g_oeb[l_ac].oeb14t < l_amt THEN
         CALL cl_err('','axm-762',1)
         RETURN FALSE
      END IF
   END IF   #No.TQC-6B0117
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oeb908()
   DEFINE l_cnt LIKE type_file.num10,
          l_coc10 LIKE coc_file.coc10

   IF NOT cl_null(g_oeb[l_ac].oeb908) THEN
      SELECT coc10 INTO l_coc10 FROM coc_file
       WHERE coc03 = g_oeb[l_ac].oeb908
      IF STATUS THEN
         CALL cl_err3("sel","coc_file",g_oeb[l_ac].oeb908,"","aco-062","","",1)  #No.FUN-650108
         RETURN FALSE
      END IF
      SELECT COUNT(*) INTO l_cnt FROM coc_file,cod_file,coa_file
       WHERE coc01 = cod01 AND cod03 = coa03
         AND coa05 = l_coc10
         AND coa01 = g_oeb[l_ac].oeb04
         AND coc03 = g_oeb[l_ac].oeb908
      IF l_cnt = 0 THEN
         CALL cl_err(g_oeb[l_ac].oeb908,'aco-073',0)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oeb930()
   IF NOT s_costcenter_chk(g_oeb[l_ac].oeb930) THEN
      LET g_oeb[l_ac].oeb930=g_oeb_t.oeb930
      LET g_oeb[l_ac].gem02c=g_oeb_t.gem02c
      DISPLAY BY NAME g_oeb[l_ac].oeb930,g_oeb[l_ac].gem02c
      RETURN FALSE
   ELSE
      LET g_oeb[l_ac].gem02c=s_costcenter_desc(g_oeb[l_ac].oeb930)
      DISPLAY BY NAME g_oeb[l_ac].gem02c
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_fas_combine()
   IF g_oeb[l_ac].oeb04 IS NOT NULL THEN
      CALL cl_err('','axm-287',0)
   ELSE
      IF g_sma.sma895='1' #FAS 產品料號產生方式
         THEN             #1:人工自行輸入
         LET g_sql='abmp630 "',g_oea.oea01,'" "',
                               g_oeb[l_ac].oeb03,'"'
         CALL cl_cmdrun_wait(g_sql)  #FUN-660216 add
      ELSE                # 2:按FAS編碼原則自動產生
         LET g_sql='abmp631 "',g_oea.oea01,'" "',
                               g_oeb[l_ac].oeb03,'"'
         CALL cl_cmdrun_wait(g_sql)  #FUN-660216 add
      END IF
      SELECT MAX(cbc04) INTO g_oeb[l_ac].oeb04 FROM cbc_file
       WHERE cbc02=g_oea.oea01
         AND cbc03=g_oeb[l_ac].oeb03
      IF STATUS THEN
         CALL cl_err3("sel","cbc_file",g_oea.oea01,g_oeb[l_ac].oeb03,STATUS,"","sel cbc",1)  #No.FUN-650108
      END IF
      DELETE FROM cbc_file
       WHERE cbc02=g_oea.oea01
         AND cbc03=g_oeb[l_ac].oeb03
      IF STATUS THEN
         CALL cl_err3("del","cbc_file",g_oea.oea01,g_oeb[l_ac].oeb03,STATUS,"","del cbc",1)  #No.FUN-650108
      END IF
   END IF
END FUNCTION

FUNCTION t400_b_inschk()
DEFINE l_count  LIKE type_file.num5    #TQC-A80141 

#   IF cl_null(g_oeb[l_ac].oeb71) AND g_oea.oea11 MATCHES '[35]' THEN  #TQC-A80141 
    IF cl_null(g_oeb[l_ac].oeb71) AND g_oea.oea11 MATCHES '[5]' THEN  #TQC-A80141 
      RETURN "oeb71"
   END IF

#TQC-A80141 --begin--
   LET l_count = 0 
   SELECT COUNT(*) INTO l_count FROM tqp_file
    WHERE tqp01 = g_oea.oea12
   IF cl_null(g_oeb[l_ac].oeb71) AND g_oea.oea11 = '3' 
#TQC-AA0135 --begin--
#      AND l_count =1  THEN 
#   ELSE
#      RETURN "oeb71"
   THEN   
      IF l_count = 0 THEN
         RETURN "oeb71"  
      END IF  
#TQC-AA0135
   END IF 	     
#TQC-A80141 --end--   
   
#No.FUN-A80024 --begin
   IF cl_null(g_oeb[l_ac].oeb32) AND g_argv1 ='0' THEN
      RETURN "oeb32"
   END IF
#No.FUN-A80024 --end
   IF NOT cl_null(g_oeb[l_ac].oeb04) THEN
      SELECT ima25,ima31 INTO g_ima25,g_ima31
        FROM ima_file
       WHERE ima01=g_oeb[l_ac].oeb04
   END IF

   IF g_sma.sma115 = 'Y' THEN
      CALL s_chk_va_setting(g_oeb[l_ac].oeb04)
           RETURNING g_flag,g_ima906,g_ima907
      IF g_flag=1 THEN
         RETURN "oeb04"    #NO.MOD-590451
      END IF

      CALL s_chk_va_setting1(g_oeb[l_ac].oeb04)
           RETURNING g_flag,g_ima908
      IF g_flag=1 THEN
         RETURN "oeb04"
      END IF

      CALL t400_du_data_to_correct()

      CALL t400_set_origin_field('b')
      #-----MOD-AA0180---------
      #IF cl_null(g_oeb[l_ac].oeb916) THEN
      #   LET g_oeb[l_ac].oeb916=g_oeb[l_ac].oeb05
      #   LET g_oeb[l_ac].oeb917=g_oeb[l_ac].oeb12
      #END IF
      #-----END MOD-AA0180-----
   END IF
   #-----MOD-AA0180---------
   IF cl_null(g_oeb[l_ac].oeb916) THEN
      LET g_oeb[l_ac].oeb916=g_oeb[l_ac].oeb05
      LET g_oeb[l_ac].oeb917=g_oeb[l_ac].oeb12
   END IF
   #-----END MOD-AA0180-----

   IF g_oaz.oaz43='Y' THEN
      CALL t400_b_more()
   ELSE
      IF g_oea.oea00 = '9' THEN
         LET b_oeb.oeb09 = g_oaz.oaz78
         LET b_oeb.oeb091 = ' '
         LET b_oeb.oeb092 = g_oea.oea03
         DISPLAY BY NAME b_oeb.oeb09,b_oeb.oeb091,b_oeb.oeb092
      END IF
   END IF   #No.MOD-570192 Unmark

   LET b_oeb.oeb16 = g_oeb[l_ac].oeb15   #排定交貨日=預定交貨日  #MOD-7B0155
   LET b_oeb.oeb904=b_oeb.oeb13    #No.3795,只有新增給,修改不改
   LET b_oeb.oeb17 = g_oeb17       #no.7150
   IF cl_null(b_oeb.oeb17) THEN
      LET b_oeb.oeb17 = 0
   END IF
   LET b_oeb.oeb901= 0
   LET b_oeb.oeb905= 0             #no.7182
   IF cl_null(b_oeb.oeb092) THEN LET b_oeb.oeb092=' ' END IF
   IF cl_null(b_oeb.oeb1003) THEN LET b_oeb.oeb1003 = '1' END IF
   RETURN NULL
END FUNCTION

FUNCTION t400_b_ins()
   DEFINE l_tqn   RECORD LIKE tqn_file.*

   IF g_aza.aza50 = 'Y' THEN  #No.FUN-650108
      IF g_value IS NOT NULL THEN
         LET g_cnt=0
         SELECT COUNT(*) INTO g_cnt
           FROM tqm_file,tqn_file
          WHERE tqn01 = tqm01
            AND tqm01 = g_oeb[l_ac].oeb1002
            AND tqn03 = g_value
         IF g_cnt = 0 THEN
            INITIALIZE  l_tqn.* TO NULL
            SELECT tqn_file.* INTO l_tqn.*
              FROM tqm_file,tqn_file
             WHERE tqn01 = tqm01
               AND tqm01 = g_oeb[l_ac].oeb1002
               AND tqn03 = g_oeb04
            SELECT MAX(tqn02) INTO l_tqn.tqn02
              FROM tqm_file,tqn_file
             WHERE tqn01 = tqm01
               AND tqm01 = g_oeb[l_ac].oeb1002
            LET l_tqn.tqn02 = l_tqn.tqn02+1
            LET l_tqn.tqn03 = g_value
            IF NOT cl_null(l_tqn.tqn01) AND NOT cl_null(l_tqn.tqn02) THEN    #TQC-AB0407  ADD
               INSERT INTO tqn_file VALUES(l_tqn.*)
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins tqn","tqn_file",l_tqn.tqn01,"",SQLCA.sqlcode,"","ins oeb",1)  #No.FUN-650108
                  RETURN FALSE
               END IF
            END IF        #TQC-AB0407   add
         END IF
      END IF
   END IF
   IF cl_null(b_oeb.oeb1012) THEN LET b_oeb.oeb1012 = 'N' END IF   #MOD-870034
   IF cl_null(b_oeb.oeb1006) THEN LET b_oeb.oeb1006 = 100 END IF   #MOD-A10123
   LET b_oeb.oebplant=g_plant #No.FUN-870007
   LET b_oeb.oeblegal=g_legal #No.FUN-87007
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#  LET l_sql = " SELECT ata03,ata04,ata08 FROM ata_file ",
#              "  WHERE ata00 = '",g_prog,"'",
#              "    AND ata01 = '",g_oea.oea01,"'",
#              "    AND ata02 = '",g_oeb[l_ac].oeb03,"'"
#  DECLARE t400_ata_curs SCROLL CURSOR FROM l_sql
#  FOREACH t400_ata_curs INTO b_oeb.oeb03,b_oeb.oeb04,b_oeb.oeb12
#     LET b_oeb.oeb14 = g_oeb[l_ac].oeb14 * b_oeb.oeb12 / g_oeb[l_ac].oeb12
#     LET b_oeb.oeb14t= g_oeb[l_ac].oeb14t* b_oeb.oeb12 / g_oeb[l_ac].oeb12
#     LET b_oeb.oeb917= g_oeb[l_ac].oeb917 * b_oeb.oeb12 / g_oeb[l_ac].oeb12
#     CALL cl_digcut(b_oeb.oeb14,t_azi04)  RETURNING b_oeb.oeb14
#     CALL cl_digcut(b_oeb.oeb14t,t_azi04) RETURNING b_oeb.oeb14t
#     IF cl_null(b_oeb.oeb44) THEN LET b_oeb.oeb44=' ' END IF   #FUN-A60035 add
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END

#MOD-A80183 --begin--
   IF g_azw.azw04 = '2' THEN
      SELECT rty06 INTO b_oeb.oeb44 FROM rty_file
       WHERE rty01 = g_plant
         AND rty02 = b_oeb.oeb04
   ELSE
     LET b_oeb.oeb44 = '1'
   END IF
#MOD-A80183 --end--

   INSERT INTO oeb_file VALUES(b_oeb.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","oeb_file",b_oeb.oeb01,"",SQLCA.sqlcode,"","ins oeb",1)  #No.FUN-650108
      RETURN FALSE
   ELSE
 --
      MESSAGE 'INSERT O.K'
      LET g_oea49= '0'      #MOD-4A0299
      CALL t400_mlog('A')
      IF g_oaz.oaz06 = 'Y' THEN
         CALL s_mpslog('A',g_oeb[l_ac].oeb04,g_oeb[l_ac].oeb12,
                           g_oeb[l_ac].oeb15,'','','',
                           g_oea.oea01,'',g_oeb[l_ac].oeb03)
      END IF
   END IF
#FUN-A60035 ---MARK BEGIN
#&ifdef SLK
#   END FOREACH
#&endif
#FUN-A60035 ---MARK END
   RETURN TRUE
END FUNCTION

FUNCTION t400_b_delchk()
   IF b_oeb.oeb24 > 0 THEN
      CALL cl_err('oeb24>0','axm-196',0)
      RETURN FALSE
   END IF
   IF NOT cl_delb(0,0) THEN
      RETURN FALSE
   END IF
   INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
   LET g_doc.column1 = "oea01"         #No.FUN-9B0098 10/02/24
   LET g_doc.value1 = g_oea.oea01      #No.FUN-9B0098 10/02/24
   CALL cl_del_doc()                           #No.FUN-9B0098 10/02/24

   RETURN TRUE
END FUNCTION

FUNCTION t400_b_del()
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#  DEFINE l_sql  LIKE type_file.chr1000
#  IF g_oea.oeaslk02 = 'Y' THEN
#     DELETE FROM oeb_file 
#      WHERE oeb01 = g_oea.oea01 
#        AND oeb03 IN
#    (SELECT ata03 FROM ata_file 
#      WHERE ata00 = g_prog
#        AND ata02 = g_oeb[l_ac].oeb03
#        AND ata01 = g_oea.oea01)
#     IF SQLCA.sqlcode THEN
#        CALL cl_err3("del","oeb_file",g_oea.oea01,g_oeb_t.oeb03,SQLCA.sqlcode,"","",1)
#     ELSE
#        DELETE FROM oebi_file 
#         WHERE oebi01 = g_oea.oea01 
#           AND oebi03 IN
#       (SELECT ata03 FROM ata_file 
#         WHERE ata00 = g_prog
#           AND ata02 = g_oeb[l_ac].oeb03
#           AND ata01 = g_oea.oea01)
#        
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("del","oebi_file",g_oea.oea01,g_oeb_t.oeb03,SQLCA.sqlcode,"","",1)
#        ELSE
#           DELETE FROM ata_file 
#            WHERE ata00 = g_prog
#              AND ata02 = g_oeb_t.oeb03
#              AND ata01 = g_oea.oea01
#           IF SQLCA.sqlcode THEN
#              CALL cl_err3("del","ata_file",g_oea.oea01,g_oeb_t.oeb03,SQLCA.sqlcode,"","",1)
#           END IF
#        END IF
#     END IF
#  ELSE
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END
   DELETE FROM oeb_file
    WHERE oeb01 = g_oea.oea01 AND oeb03 = g_oeb_t.oeb03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","oeb_file",g_oea.oea01,g_oeb_t.oeb03,SQLCA.sqlcode,"","",1)  #No.FUN-650108
   END IF
   LET g_oea49= '0'      #MOD-4A0299
   DELETE FROM oeo_file
    WHERE oeo01 = g_oea.oea01 AND oeo03 = g_oeb_t.oeb03
   DELETE FROM oef_file
    WHERE oef01 = g_oea.oea01 AND oef03 = g_oeb_t.oeb03
   DELETE FROM rxc_file
    WHERE rxc00='01' AND rxc01 = g_oea.oea01
      AND rxc02=g_oeb_t.oeb03 #FUN-AB0012 Add
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#END IF
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END
   CALL t400_mlog('R')
   IF g_oaz.oaz06 = 'Y' THEN
      CALL s_mpslog('R','','','',g_oeb_t.oeb04,g_oeb_t.oeb12,
                     g_oeb_t.oeb15,g_oea.oea01,g_oeb_t.oeb03,'')
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_b_updchk()
   IF g_sma.sma115 = 'Y' THEN   #No.FUN-580175
      IF NOT cl_null(g_oeb[l_ac].oeb04) THEN
         SELECT ima25,ima31 INTO g_ima25,g_ima31
           FROM ima_file WHERE ima01=g_oeb[l_ac].oeb04
      END IF

      CALL s_chk_va_setting(g_oeb[l_ac].oeb04)
           RETURNING g_flag,g_ima906,g_ima907
      IF g_flag=1 THEN
         RETURN "oeb04"
      END IF
      CALL s_chk_va_setting1(g_oeb[l_ac].oeb04)
           RETURNING g_flag,g_ima908
      IF g_flag=1 THEN
         RETURN "oeb04"
      END IF

      CALL t400_du_data_to_correct()

      CALL t400_set_origin_field('b')
   END IF

   RETURN NULL
END FUNCTION

FUNCTION t400_b_upd()
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#DEFINE l_ps        LIKE type_file.chr1
#DEFINE l_sql       LIKE type_file.chr1000
#DEFINE l_ata       RECORD LIKE ata_file.*
#DEFINE l_str       STRING
#DEFINE l_str1      STRING
#DEFINE l_count     LIKE type_file.num5
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END
   IF cl_null(b_oeb.oeb091) THEN LET b_oeb.oeb091=' ' END IF
   IF cl_null(b_oeb.oeb092) THEN LET b_oeb.oeb092=' ' END IF
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#  IF g_oea.oeaslk02 = 'Y' THEN
#     DELETE FROM oeb_file WHERE oeb01=g_oea.oea01
#        AND oeb03 NOT IN
#     (SELECT ata03 FROM ata_file
#       WHERE ata00=g_prog
#         AND ata01=g_oea.oea01)
#     DELETE FROM oeb_file WHERE oeb01=g_oea.oea01 
#        AND oeb03 IN
#     ( SELECT ata03 FROM ata_file 
#       WHERE ata00=g_prog
#         AND ata01=g_oea.oea01
#         AND ata02=g_oeb[l_ac].oeb03)
#     DELETE FROM oebi_file WHERE oebi01=g_oea.oea01 
#        AND oebi03 IN
#     ( SELECT ata03 FROM ata_file 
#       WHERE ata00=g_prog
#         AND ata01=g_oea.oea01
#         AND ata02=g_oeb[l_ac].oeb03)
#     LET l_sql = " SELECT * FROM ata_file ",
#                 "  WHERE ata00 = '",g_prog,"'",
#                 "    AND ata01 = '",g_oea.oea01,"'",
#                 "    AND ata02 = '",g_oeb_t.oeb03,"'"
#     DECLARE t400_ata_curs1 SCROLL CURSOR FROM l_sql
#     FOREACH t400_ata_curs1 INTO l_ata.*
#        LET b_oeb.oeb03 = l_ata.ata03
#        LET b_oeb.oeb04 = l_ata.ata04
#        LET b_oeb.oeb12 = l_ata.ata08
#        IF g_oea.oea213 = 'N' THEN
#           LET b_oeb.oeb14 = t400_amount(g_oeb[l_ac].oeb917,g_oeb[l_ac].oeb13,g_oeb[l_ac].oeb1006,t_azi03)
#           CALL cl_digcut(b_oeb.oeb14,t_azi04)  RETURNING b_oeb.oeb14
#           LET b_oeb.oeb14t= b_oeb.oeb14*(1+ g_oea.oea211/100)
#           CALL cl_digcut(b_oeb.oeb14t,t_azi04) RETURNING b_oeb.oeb14t
#        ELSE
#           LET b_oeb.oeb14t= t400_amount(g_oeb[l_ac].oeb917,g_oeb[l_ac].oeb13,g_oeb[l_ac].oeb1006,t_azi03)
#           CALL cl_digcut(b_oeb.oeb14t,t_azi04) RETURNING b_oeb.oeb14t
#           LET b_oeb.oeb14 = b_oeb.oeb14t/(1+ g_oea.oea211/100)
#           CALL cl_digcut(b_oeb.oeb14,t_azi04)  RETURNING b_oeb.oeb14
#        END IF
#        INSERT INTO oeb_file VALUES(b_oeb.*)
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("ins","oeb_file",g_oea.oea01,g_oeb_t.oeb03,SQLCA.sqlcode,"","upd oeb",1)  #No.FUN-650108
#           RETURN FALSE
#        ELSE
#           LET b_oebi.oebi01 = b_oeb.oeb01
#           LET b_oebi.oebi03 = b_oeb.oeb03
#           IF NOT s_ins_oebi(b_oebi.*,b_oeb.oebplant) THEN #FUN-A50054
#              RETURN FALSE
#           END IF
#        END IF
#     END FOREACH
#  ELSE
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END
   UPDATE oeb_file SET * = b_oeb.*
    WHERE oeb01=g_oea.oea01 AND oeb03=g_oeb_t.oeb03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","oeb_file",g_oea.oea01,g_oeb_t.oeb03,SQLCA.sqlcode,"","upd oeb",1)  #No.FUN-650108
      LET g_oeb[l_ac].* = g_oeb_t.*
   ELSE
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#   #DELETE FROM oebi_file 
#   # WHERE oebi01=g_oea.oea01
#   #   AND oebi03 NOT IN
#   #SELECT ata03 FROM ata_file 
#   # WHERE ata00=g_prog
#   #   AND ata01=g_oea.oea01
#   #   AND ata02=g_oeb[l_ac].oeb03)
#   #DELETE FROM oeb_file 
#   # WHERE oeb01=g_oea.oea01
#   #   AND oeb03 NOT IN
#   #SELECT ata03 FROM ata_file 
#   # WHERE ata00=g_prog
#   #   AND ata01=g_oea.oea01
#   #   AND ata02=g_oeb[l_ac].oeb03)
#  END IF
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END
      MESSAGE 'UPDATE O.K'
      LET g_oea49= '0'      #MOD-4A0299
      CALL t400_mlog('U')
      IF g_oaz.oaz06 = 'Y' AND
        (g_oeb[l_ac].oeb03 != g_oeb_t.oeb03 OR
         g_oeb[l_ac].oeb04 != g_oeb_t.oeb04 OR
         g_oeb[l_ac].oeb12 != g_oeb_t.oeb12 OR
         g_oeb[l_ac].oeb15 != g_oeb_t.oeb15) THEN
         CALL s_mpslog('U',g_oeb[l_ac].oeb04,
                        g_oeb[l_ac].oeb12,g_oeb[l_ac].oeb15,
                        g_oeb_t.oeb04,
                        g_oeb_t.oeb12,g_oeb_t.oeb15,
                        g_oea.oea01,g_oeb_t.oeb03,
                        g_oeb[l_ac].oeb03)
      END IF
   END IF
   RETURN TRUE
END FUNCTION

#axmt400 axmt401 axmt410 axmt810 共用per檔
#axmt400差異點 : 類別,合約單號,合約日期,資料來源內容
#axmt401差異點 : 類別,資料來源內容
#axmt810差異點 : 多角續號,多角拋轉否,資料來源內容
#axmt420差異點 : 類別,資料來源內容

FUNCTION t400_set_perlang()
   DEFINE p_prog,l_msg STRING

   IF g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]"  THEN
      RETURN
   END IF

   LET p_prog=g_prog
   LET p_prog=p_prog.substring(5,7)

#TQC-AA0101 --begin--
   IF g_aza.aza50 = 'Y' THEN 
      CALL cl_set_comp_att_text("oeb1006",cl_getmsg('axm-239',g_lang))
   END IF 
#TQC-AA0101 --end--   
   
   CASE p_prog
      WHEN "400" #合約訂單
         LET l_msg=cl_getmsg('axm-373',g_lang)             #MOD-7A0155
         CALL cl_set_comp_att_text("oeb24",l_msg CLIPPED)  #MOD-7A0155
         LET l_msg=cl_getmsg('axm-366',g_lang)
         CALL cl_set_comp_att_text("oea01",l_msg CLIPPED)
         LET l_msg=cl_getmsg('axm-367',g_lang)
         CALL cl_set_comp_att_text("oea02",l_msg CLIPPED)
         LET cb = ui.ComboBox.forName("oea00")
         CALL cb.removeItem('1')
         CALL cb.removeItem('2')
         CALL cb.removeItem('3')
         CALL cb.removeItem('4')
         CALL cb.removeItem('6')
         CALL cb.removeItem('7')
         CALL cb.removeItem('8')   #No.FUN-740016
         CALL cb.removeItem('9')   #No.FUN-740016
         LET cb = ui.ComboBox.forName("oea11")
         CALL cb.removeItem('2')
         CALL cb.removeItem('3')
         CALL cb.removeItem('4')
         CALL cb.removeItem('5')
         CALL cb.removeItem('6')
         CALL cb.removeItem('7')
         CALL cb.removeItem('A')
         CALL cl_set_comp_visible("oeb25,oeb27,oeb28,oeb29,oeb30,oeb31",FALSE)   #No.FUN-740016
      WHEN "401" #訂單底稿
         LET cb = ui.ComboBox.forName("oea11")
         CALL cb.removeItem('1')
         CALL cb.removeItem('2')
         CALL cb.removeItem('3')
         CALL cb.removeItem('4')
         CALL cb.removeItem('5')
         CALL cb.removeItem('6')
         CALL cb.removeItem('7')
         CALL cl_set_comp_visible("oeb25,oeb29,oeb30,oeb31",FALSE)   #No.FUN-740016
      WHEN "410" #一般訂單
         LET cb = ui.ComboBox.forName("oea00")
         CALL cb.removeItem('0')
         CALL cb.removeItem('8')   #No.FUN-740016
         CALL cb.removeItem('9')   #No.FUN-740016
         LET cb = ui.ComboBox.forName("oea11")
         CALL cb.removeItem('6')
         CALL cb.removeItem('A')
         CALL cl_set_comp_visible("oeb25,oeb29,oeb30,oeb31",FALSE)   #No.FUN-740016
      WHEN "810" #多角訂單
         LET cb = ui.ComboBox.forName("oea00")
         CALL cb.removeItem('0')
         CALL cb.removeItem('3')
         CALL cb.removeItem('4')
         CALL cb.removeItem('6')
         CALL cb.removeItem('7')
         CALL cb.removeItem('8')   #No.FUN-740016
         CALL cb.removeItem('9')   #No.FUN-740016
         LET cb = ui.ComboBox.forName("oea11")
         CALL cb.removeItem('6')
         CALL cb.removeItem('7')
         CALL cb.removeItem('A')
         LET l_msg=cl_getmsg('axm-368',g_lang)
         LET l_msg="6:",l_msg CLIPPED
         CALL cb.addItem('6', l_msg)
         LET l_msg=cl_getmsg('axm-369',g_lang)
         LET l_msg="7:",l_msg CLIPPED
         CALL cb.addItem('7', l_msg)
         CALL cl_set_comp_visible("oeb25,oeb29,oeb30,oeb31",FALSE)   #No.FUN-740016
      WHEN "420" #借貨訂單
         LET l_msg=cl_getmsg('axm-880',g_lang)
         CALL cl_set_comp_att_text("oea06",l_msg CLIPPED)
         LET l_msg=cl_getmsg('axm-881',g_lang)
         CALL cl_set_comp_att_text("oeb15",l_msg CLIPPED)
         LET l_msg=cl_getmsg('axm-882',g_lang)
         CALL cl_set_comp_att_text("oeb24",l_msg CLIPPED)
         LET l_msg=cl_getmsg('axm-883',g_lang)
         CALL cl_set_comp_att_text("oeb25",l_msg CLIPPED)
         LET cb = ui.ComboBox.forName("oea00")
         CALL cb.removeItem('0')
         CALL cb.removeItem('1')
         CALL cb.removeItem('2')
         CALL cb.removeItem('3')
         CALL cb.removeItem('4')
         CALL cb.removeItem('6')
         CALL cb.removeItem('7')
         CALL cb.removeItem('A')
         LET cb = ui.ComboBox.forName("oea11")
         CALL cb.removeItem('2')
         CALL cb.removeItem('3')
         CALL cb.removeItem('4')
         CALL cb.removeItem('5')
         CALL cb.removeItem('6')
         CALL cb.removeItem('7')
         CALL cb.removeItem('A')
         CALL cl_set_comp_visible("oeb27,oeb28",FALSE)
         CALL cl_set_comp_visible("oea1004,occ02_a,oea1015,oea1015_occ02",FALSE)
         CALL cl_set_comp_visible("oea50,oea37,oea07,oea65,oea48,ofs02,oea47,pmc03",FALSE)
         CALL cl_set_comp_visible("oeb908,oeb22,oeb19,ima15,oeb16",FALSE)
   END CASE
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("oeb913",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("oeb915",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("oeb910",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("oeb912",g_msg CLIPPED)
   END IF
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("oeb913",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("oeb915",g_msg CLIPPED)
      CALL cl_getmsg('asm-324',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("oeb910",g_msg CLIPPED)
      CALL cl_getmsg('asm-325',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("oeb912",g_msg CLIPPED)
   END IF

   IF g_oea.oea11 ='1' THEN
       CALL cl_getmsg('axm-905',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb71",g_msg CLIPPED)
   END IF
   IF g_oea.oea11 !='1' THEN
       CALL cl_getmsg('axm-906',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb71",g_msg CLIPPED)
   END IF
END FUNCTION

FUNCTION t400_set_required()

   IF g_oea.oea00='6' THEN
      CALL cl_set_comp_required("oea1004",TRUE)
   END IF
   IF g_oea.oea11 = '8' THEN
      CALL cl_set_comp_required("oea12",TRUE)
   END IF

   #-----No:FUN-A50103-----
   IF NOT cl_null(g_oea.oea161) AND g_oea.oea161 <> 0 THEN
      CALL cl_set_comp_required("oea80",TRUE)
   END IF

   IF NOT cl_null(g_oea.oea163) AND g_oea.oea163 <> 0 THEN
      CALL cl_set_comp_required("oea81",TRUE)
   END IF

   #-----No:FUN-A50103 END-----

END FUNCTION

#DIS only
FUNCTION t400_pref()
DEFINE  l_n       LIKE type_file.num5    #No.FUN-680137 SMALLINT

   SELECT COUNT(*) INTO l_n
     FROM oga_file,ogb_file
    WHERE oga01 = ogb01
      AND ogb31 = g_oea.oea01
      AND ogaconf <> 'X'
   IF l_n>0 THEN
      CALL cl_err('','axm-407',0)
      RETURN
   END IF
   IF g_oea.oea1005 = 'Y' THEN
     IF NOT cl_confirm('atm-037') THEN RETURN END IF
     LET g_oea.oea1005 = 'N'
   ELSE
     IF NOT cl_confirm('atm-036') THEN RETURN END IF
     LET g_oea.oea1005 = 'Y'
   END IF

   UPDATE oea_file
      SET oea1005 = g_oea.oea1005
    WHERE oea01= g_oea.oea01

   IF STATUS OR SQLCA.SQLCODE THEN
       CALL cl_err3("upd","oea_file",g_oea.oea01,"",SQLCA.sqlcode,"","update oea:",1)  #No.FUN-650108
       ROLLBACK WORK RETURN
   END IF
   DISPLAY BY NAME g_oea.oea1005
END FUNCTION

#DIS only
FUNCTION t400_chk_oea1011()
   DEFINE l_occacti LIKE occ_file.occacti
   DEFINE l_occ1004 LIKE occ_file.occ1004
   IF NOT cl_null(g_oea.oea1011) THEN
      SELECT occ02,occacti,occ1004
        INTO g_buf,l_occacti,l_occ1004
        FROM occ_file
       WHERE occ01=g_oea.oea1011
         AND occ06 IN ('1','4')
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("sel","occ_file",g_oea.oea1011,"",STATUS,"","select occ",1)  #No.FUN-650108
         RETURN FALSE
      END IF
      IF l_occacti='N' THEN
         CALL cl_err('select occ',9028,0)
         RETURN FALSE
      END IF
      IF l_occ1004!='1' THEN            #No.FUN-690025
         #CALL cl_err('select occ',9029,0)   #MOD-A80149
         CALL cl_err('select occ','axm-496',0)   #MOD-A80149
         RETURN FALSE
      END IF
      DISPLAY g_buf TO FORMONLY.occ02_d
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_chk_oea17()
   DEFINE l_occacti LIKE occ_file.occacti
   DEFINE l_occ1004 LIKE occ_file.occ1004
   IF NOT cl_null(g_oea.oea17) THEN
      SELECT * FROM occ_file WHERE occ01=g_oea.oea17 AND occacti = 'Y'
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_oea.oea17,SQLCA.sqlcode,0)
         RETURN FALSE
      END IF
      SELECT occ02,occacti,occ1004
        INTO g_buf,l_occacti,l_occ1004
        FROM occ_file
       WHERE occ01=g_oea.oea17
         AND occ06 IN ('1','3')
      IF SQLCA.SQLCODE THEN  #FUN-610055
         CALL cl_err3("sel","occ_file",g_oea.oea17,"","axm-177","","select occ",1)  #No.FUN-650108    #TQC-7C0118     Mod status--->axm-177
         RETURN FALSE
      END IF
      IF l_occacti='N' THEN
         CALL cl_err('select occ',9028,0)
         RETURN FALSE
      END IF
      IF l_occ1004!='1' THEN          #No.FUN-690025
         #CALL cl_err('select occ',9029,0)   #MOD-A80149
         CALL cl_err('select occ','axm-496',0)   #MOD-A80149
         RETURN FALSE
      END IF
      DISPLAY g_buf TO FORMONLY.oea17_ds
      IF NOT cl_null(g_oea.oea03) AND NOT cl_null(g_oea.oea1002)
         AND NOT cl_null(g_oea.oea17) THEN
          SELECT tqk04,tqk05 INTO g_oea.oea32,g_oea.oea23 FROM tqk_file
           WHERE tqk01 =g_oea.oea03
             AND tqk02 =g_oea.oea1002
             AND tqk03 =g_oea.oea17
             AND tqkacti ='Y'
          IF g_oea.oea08='1' THEN
             LET exT=g_oaz.oaz52
          ELSE
             LET exT=g_oaz.oaz70
          END IF
          CALL s_curr3(g_oea.oea23,g_oea.oea02,exT) RETURNING g_oea.oea24
      END IF
   END IF
   RETURN TRUE
END FUNCTION

#DIS only
FUNCTION t400_chk_oea1002()
   IF NOT cl_null(g_oea.oea1002) THEN
      SELECT tqa02 INTO g_buf FROM tqa_file
       WHERE tqa01=g_oea.oea1002 AND tqaacti = 'Y'
         AND tqa03 = '20'
      IF SQLCA.SQLCODE THEN  #FUN-610055
         CALL cl_err3("sel","tqa_file","","",STATUS,"","select tqa",1)  #No.FUN-650108
         RETURN FALSE
      END IF
      DISPLAY g_buf TO tqa02_a
      IF NOT cl_null(g_oea.oea03) AND NOT cl_null(g_oea.oea1002)
         AND NOT cl_null(g_oea.oea17) THEN
          SELECT tqk04,tqk05 INTO g_oea.oea32,g_oea.oea23 FROM tqk_file
           WHERE tqk01 =g_oea.oea03
             AND tqk02 =g_oea.oea1002
             AND tqk03 =g_oea.oea17
             AND tqkacti ='Y'
          IF g_oea.oea08='1' THEN
             LET exT=g_oaz.oaz52
          ELSE
             LET exT=g_oaz.oaz70
          END IF
          CALL s_curr3(g_oea.oea23,g_oea.oea02,exT) RETURNING g_oea.oea24
          DISPLAY BY NAME g_oea.oea32
          DISPLAY BY NAME g_oea.oea23
          DISPLAY BY NAME g_oea.oea24
      END IF
   END IF
   RETURN TRUE
END FUNCTION

#DIS only
FUNCTION t400_chk_oea1003()
   IF NOT cl_null(g_oea.oea1003) THEN
      SELECT tqb02 INTO g_buf FROM tqb_file
       WHERE tqb01=g_oea.oea1003 AND tqbacti = 'Y'
      IF SQLCA.SQLCODE THEN  #FUN-610055
         CALL cl_err3("sel","tqb_file",g_oea.oea1003,"",STATUS,"","select tqb",1)  #No.FUN-650108
         RETURN FALSE
      END IF
      DISPLAY g_buf TO tqb02_b
   END IF
   RETURN TRUE
END FUNCTION

#DIS only
FUNCTION t400_price(p_ac)
DEFINE l_n             LIKE type_file.num5,    #No.FUN-680137 SMALLINT
       p_ac            LIKE type_file.num5,    #No.FUN-680137 SMALLINT
       l_success       LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
       l_ima135        LIKE ima_file.ima135,
       l_tqz09         LIKE tqz_file.tqz09,
       l_tqx14         LIKE tqx_file.tqx14,
       l_tqx16         LIKE tqx_file.tqx16,
       l_tqz08         LIKE tqz_file.tqz08,
       l_oeb05         LIKE oeb_file.oeb05,
       l_flag          LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
       l_unitrate      LIKE ima_file.ima31_fac,
       l_unit          LIKE ima_file.ima31,
       l_tqz06         LIKE tqz_file.tqz06,
       l_tqz07         LIKE tqz_file.tqz07,
       l_tqy38         LIKE tqy_file.tqy38,
       l_tqx13         LIKE tqx_file.tqx13
DEFINE l_occ1027       LIKE occ_file.occ1027   #TQC-7C0098
DEFINE l_oah04         LIKE oah_file.oah04   #NO.FUN-9B0025

   IF cl_null(g_oeb[p_ac].oeb15) THEN
      CALL cl_err('','atm-040',0)
      RETURN 0
   END IF
   IF g_sma.sma115 = 'Y' AND cl_null(g_oeb[p_ac].oeb05) THEN
      CALL t400_set_origin_field('m')
   END IF
   IF cl_null(g_oeb[p_ac].oeb916) THEN
      LET g_oeb[p_ac].oeb917 = g_oeb[p_ac].oeb12
   END IF
   #---單位換算
   IF g_sma.sma116 MATCHES '[23]' AND NOT cl_null(g_oeb[p_ac].oeb916) THEN
      LET l_oeb05=g_oeb[p_ac].oeb916
   ELSE
      LET l_oeb05=g_oeb[p_ac].oeb05
   END IF
   CALL s_fetch_price_new(g_oea.oea03,g_oeb[p_ac].oeb04,l_oeb05,g_oeb[p_ac].oeb15,
                          '1',g_oea.oeaplant,g_oea.oea23,g_oea.oea31,g_oea.oea32,
                          g_oea.oea01,g_oeb[p_ac].oeb03,g_oeb[p_ac].oeb917,g_oeb[p_ac].oeb1004,'a')
   #  RETURNING g_oeb[p_ac].oeb13                                       #FUN-AB0061
      RETURNING g_oeb[p_ac].oeb13,g_oeb[p_ac].oeb37                     #FUN-AB0061
   IF g_oeb[p_ac].oeb13 = 0 THEN CALL s_unitprice_entry(g_oea.oea03,g_oea.oea31,g_oea.oeaplant) END IF #FUN-9C0120
   IF g_oeb[p_ac].oeb13 = 0 OR g_oeb[p_ac].oeb13 IS NULL THEN
      RETURN 1
   END IF
  #TQC-AB0204 Begin---
   LET g_oeb17 = g_oeb[l_ac].oeb13
   LET b_oeb.oeb17 = g_oeb[l_ac].oeb13
   IF g_oeb17 <> g_oeb17_t OR cl_null(g_oeb17) OR g_oeb17=0 THEN
      LET g_oeb[l_ac].oeb1006 = 100
      DISPLAY BY NAME g_oeb[l_ac].oeb1006
   END IF
   LET g_oeb[l_ac].oeb13 = g_oeb[l_ac].oeb13 * g_oeb[l_ac].oeb1006/100
  #TQC-AB0204 End-----
   LET g_oeb[p_ac].oeb13 = cl_digcut(g_oeb[p_ac].oeb13,t_azi03) #No.MOD-820125
   LET g_oeb[p_ac].oeb37 = cl_digcut(g_oeb[p_ac].oeb37,t_azi03) #FUN-AB0061
   IF g_oea.oea213 = 'N' THEN
      LET g_oeb[p_ac].oeb14 = t400_amount(g_oeb[p_ac].oeb917,g_oeb[p_ac].oeb13,g_oeb[p_ac].oeb1006,t_azi03) #No.MOD-820066
      CALL cl_digcut(g_oeb[p_ac].oeb14,t_azi04)  RETURNING g_oeb[p_ac].oeb14   #CHI-7A0036-add
      LET g_oeb[p_ac].oeb14t= g_oeb[p_ac].oeb14*(1+ g_oea.oea211/100)
      CALL cl_digcut(g_oeb[p_ac].oeb14t,t_azi04) RETURNING g_oeb[p_ac].oeb14t  #CHI-7A0036-add
   ELSE
      LET g_oeb[p_ac].oeb14t= t400_amount(g_oeb[p_ac].oeb917,g_oeb[p_ac].oeb13,g_oeb[p_ac].oeb1006,t_azi03) #No.MOD-820066
      CALL cl_digcut(g_oeb[p_ac].oeb14t,t_azi04) RETURNING g_oeb[p_ac].oeb14t  #CHI-7A0036-add
      LET g_oeb[p_ac].oeb14 = g_oeb[p_ac].oeb14t/(1+ g_oea.oea211/100)
      CALL cl_digcut(g_oeb[p_ac].oeb14,t_azi04)  RETURNING g_oeb[p_ac].oeb14   #CHI-7A0036-add
   END IF
   IF g_oeb[p_ac].oeb1012 = 'Y' AND g_aza.aza50 = 'Y' THEN  #No.TQC-740323
      LET g_oeb[p_ac].oeb14=0
      LET g_oeb[p_ac].oeb14t=0
   END IF

           SELECT DISTINCT oah04 INTO l_oah04 FROM oah_file WHERE oah01 = g_oea.oea31
           IF l_oah04 = 'Y' AND (cl_null(g_oeb[l_ac].oeb13) OR g_oeb[l_ac].oeb13 = 0) THEN
              CALL cl_set_comp_entry("oeb13,oeb14,oeb14t",TRUE)
           ELSE
              CALL cl_set_comp_entry("oeb13,oeb14,oeb14t",FALSE)
           END IF

   RETURN 0
END FUNCTION

#DIS only
FUNCTION t400_oeb1007(p_cmd,p_ac)
DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
       p_ac      LIKE type_file.num5,    #No.FUN-680137 SMALLINT
       l_tqw15   LIKE tqw_file.tqw15,
       l_tqw16   LIKE tqw_file.tqw16,
       l_tqw07   LIKE tqw_file.tqw07,
       l_tqw08   LIKE tqw_file.tqw08,
       l_tqw11   LIKE tqw_file.tqw11,
       l_tqw12   LIKE tqw_file.tqw12,
       l_tqw14   LIKE tqw_file.tqw14,
       l_tqw19   LIKE tqw_file.tqw19,
       l_tqwacti LIKE tqw_file.tqwacti

   LET g_errno = ' '

   SELECT tqw15,tqw16,tqw07,tqw08,tqw11,tqw12,tqw14,tqw19,tqwacti
     INTO l_tqw15,l_tqw16,l_tqw07,l_tqw08,l_tqw11,l_tqw12,l_tqw14,l_tqw19,l_tqwacti
     FROM tqw_file
    WHERE tqw01 = g_oeb1[p_ac].oeb1007
      AND tqw10 = '3'
      AND (abs(tqw07)-abs(tqw08)>0)
      AND tqw17 = g_oea.oea23
      AND tqw05 = g_oea.oea03
      AND tqwacti ='Y'    #No.FUN-820033

   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-027'
                                 LET l_tqw16 = ''
                                 LET l_tqw07 = ''
                                 LET l_tqw08 = ''
                                 LET l_tqw11 = ''
                                 LET l_tqw12 = ''
                                 LET l_tqw14 = ''
                                 LET l_tqw19 = ''
        WHEN l_tqwacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE

   IF cl_null(g_errno) OR p_cmd='d' THEN
      LET g_oeb1[p_ac].tqw16 = l_tqw16
      LET g_oeb1[p_ac].tqw07 = l_tqw07
      LET g_oeb1[p_ac].tqw08 = l_tqw08
   END IF
   IF cl_null(g_errno) AND p_cmd='a' THEN
      LET g_oeb1[p_ac].oeb1008 = l_tqw11
      LET g_oeb1[p_ac].oeb1009 = l_tqw12
      LET g_oeb1[p_ac].oeb1010 = l_tqw14
      LET g_oeb1[p_ac].oeb1001_1 = l_tqw15
      LET g_oeb1[p_ac].oeb1011 = l_tqw19
   END IF
END FUNCTION

#DIS only
FUNCTION t400_chk_oeb1004()
   DEFINE l_fac LIKE oeb_file.oeb05_fac

   IF NOT cl_null(g_oeb[l_ac].oeb1004) THEN
      SELECT * FROM tqx_file,tqy_file,tqz_file,tsa_file
       WHERE tqx01=tqy01 AND tqx01=tqz01
         AND tqx01=tsa01 AND tqy02=tsa02
         AND tqz02=tsa03 AND tqy03=g_oea.oea03
         AND tqy37= 'Y'  AND tqx07= '3'
         AND tqx09=g_oea.oea23   #TQC-7C0098
         AND tqx01=g_oeb[l_ac].oeb1004
         AND (tqz03 =g_oeb[l_ac].oeb04 OR
              tqz03 IN (SELECT ima01 FROM ima_file
                         WHERE ima135=g_oeb[l_ac].ima135))
      IF STATUS = 100 THEN
         CALL cl_err3("sel","tqx_file,tqy_file,tqz_file,tsa_file","","","anm-027","","",1)  #No.FUN-650108
         RETURN FALSE
      END IF
#MOD-AC0151 ---------------STA
      CALL t400_price(l_ac) RETURNING l_fac
      IF l_fac THEN
         CALL cl_err('','axm-328',0)    #TQC-AA0025
         RETURN FALSE
      END IF
#MOD-AC0151 ---------------END
   END IF
#MOD-AC0151 ---------------mark   
#  CALL t400_price(l_ac) RETURNING l_fac
#  IF l_fac THEN
#     CALL cl_err('','axm-328',0)    #TQC-AA0025 
#     RETURN FALSE
#  END IF
#MOD-AC0151 ---------------mark
  RETURN TRUE
END FUNCTION

#DIS only
FUNCTION t400_chk_oeb1006(p_cmd)    #TQC-AB0204 Add p_cmd
 DEFINE p_cmd   LIKE type_file.chr1 #TQC-AB0204

   IF NOT cl_null(g_oeb[l_ac].oeb1006) THEN
      IF g_oeb[l_ac].oeb1006 <=0 OR g_oeb[l_ac].oeb1006 > 100 THEN
         RETURN FALSE
      END IF
      IF (g_oeb_t.oeb1006 IS NULL OR g_oeb_t.oeb1006 <> g_oeb[l_ac].oeb1006)
         AND g_oeb[l_ac].oeb1012='N' THEN
        #TQC-AB0204 Begin---
         IF cl_null(g_oeb17) THEN LET g_oeb17 = g_oeb[l_ac].oeb13 END IF
         IF g_oeb_t.oeb1006 <> g_oeb[l_ac].oeb1006 OR (NOT cl_null(g_oeb17_t) AND g_oeb17_t <> g_oeb17) THEN
            LET g_oeb[l_ac].oeb13 = g_oeb17 * g_oeb[l_ac].oeb1006/100
         END IF
         LET g_oeb[l_ac].oeb13 = cl_digcut(g_oeb[l_ac].oeb13,t_azi03)
         DISPLAY BY NAME g_oeb[l_ac].oeb13
        #TQC-AB0204 End-----
         IF g_oea.oea213 = 'N' THEN
           LET g_oeb[l_ac].oeb14 = t400_amount(g_oeb[l_ac].oeb917,g_oeb[l_ac].oeb13,g_oeb[l_ac].oeb1006,t_azi03) #No.MOD-820066
           CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04)  RETURNING g_oeb[l_ac].oeb14   #CHI-7A0036-add
           LET g_oeb[l_ac].oeb14t= g_oeb[l_ac].oeb14*(1+ g_oea.oea211/100)
           CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t  #CHI-7A0036-add
         ELSE
           LET g_oeb[l_ac].oeb14t= t400_amount(g_oeb[l_ac].oeb917,g_oeb[l_ac].oeb13,g_oeb[l_ac].oeb1006,t_azi03) #No.MOD-820066
           CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t  #CHI-7A0036-add
           LET g_oeb[l_ac].oeb14 = g_oeb[l_ac].oeb14t/(1+ g_oea.oea211/100)
           CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04)  RETURNING g_oeb[l_ac].oeb14   #CHI-7A0036-add
         END IF
         DISPLAY BY NAME g_oeb[l_ac].oeb14
         DISPLAY BY NAME g_oeb[l_ac].oeb14t
      END IF
   END IF
   LET g_oeb_t.oeb1006 = g_oeb[l_ac].oeb1006
   RETURN TRUE
END FUNCTION

#DIS only
FUNCTION t400_chk_oeb09(l_b2)
   DEFINE l_cnt   LIKE type_file.num10,
          l_sum1  LIKE oeb_file.oeb12,
          l_sum2  LIKE oeb_file.oeb12,
          l_sum3  LIKE oeb_file.oeb12,
          l_sum4  LIKE oeb_file.oeb12,
          l_check LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_fac   LIKE oeb_file.oeb05_fac,
          l_b2    LIKE cob_file.cob08,    #No.FUN-680137 VARCHAR(30)
          l_ima25 LIKE ima_file.ima25

   IF NOT cl_null(g_oeb[l_ac].oeb09) THEN
      IF cl_null(g_oeb_t.oeb09) OR g_oeb[l_ac].oeb09!=g_oeb_t.oeb09 THEN
         SELECT COUNT(*) INTO l_cnt
           FROM imd_file
          WHERE imd01=g_oeb[l_ac].oeb09
            AND imd11='Y' AND imdacti='Y'
         IF l_cnt = 0 THEN
            CALL cl_err(g_oeb[l_ac].oeb09,'mfg0094',0)
            RETURN FALSE
         END IF
         #No.FUN-AA0048  --Begin
         #IF g_azw.azw04='2' THEN
         #   LET l_cnt =0
         #   SELECT COUNT(*) INTO l_cnt FROM imd_file
         #    WHERE imd01=g_oeb[l_ac].oeb09
         #      AND imd20=g_plant
         #   IF l_cnt=0 THEN
         #      CALL cl_err(g_oeb[l_ac].oeb09,'art-487',0)
         #      RETURN FALSE
         #   END IF
         #END IF
         IF NOT s_chk_ware(g_oeb[l_ac].oeb09) THEN
            RETURN FALSE
         END IF
         #No.FUN-AA0048  --End  
      END IF
#FUN-AB0011 -------------STA
      IF s_joint_venture( g_oeb[l_ac].oeb04,g_plant) OR NOT s_internal_item(g_oeb[l_ac].oeb04,g_plant ) THEN
         RETURN TRUE
      END IF
#FUN-AB0011 -------------END
      SELECT SUM(img10*img21) INTO l_sum1 FROM img_file
       WHERE img01=g_oeb[l_ac].oeb04
         AND img02=g_oeb[l_ac].oeb09
      IF cl_null(l_sum1) THEN LET l_sum1=0 END IF
      SELECT SUM(oeb12*oeb05_fac),SUM(oeb24*oeb05_fac)
        INTO l_sum2 ,l_sum3
        FROM oea_file,oeb_file
       WHERE oea01=oeb01 AND oea49='1'
         AND oeb09=g_oeb[l_ac].oeb09
         AND oeb04=g_oeb[l_ac].oeb04
         AND (oeb01!=g_oea.oea01 AND oeb03!=g_oeb[l_ac].oeb03)
      IF cl_null(l_sum2) THEN LET l_sum2=0 END IF
      IF cl_null(l_sum3) THEN LET l_sum3=0 END IF
      IF g_sma.sma115='N' THEN
         CALL s_umfchk(g_oeb[l_ac].oeb04,g_oeb[l_ac].oeb05,l_ima25)
              RETURNING l_check,l_fac
         IF l_check = '1'  THEN
            LET l_fac = 1
         END IF
         LET l_sum4=g_oeb[l_ac].oeb12*l_fac
      ELSE
         CALL s_umfchk(g_oeb[l_ac].oeb04,l_b2,l_ima25)
              RETURNING l_check,l_fac
         IF l_check = '1'  THEN
            LET l_fac = 1
         END IF
         CASE g_ima906
              WHEN '1' LET l_sum4=g_oeb[l_ac].oeb912*g_oeb[l_ac].oeb911*l_fac
              WHEN '2' LET l_sum4=(g_oeb[l_ac].oeb912*g_oeb[l_ac].oeb911+
                                  g_oeb[l_ac].oeb915*g_oeb[l_ac].oeb914)*l_fac
              WHEN '3' LET l_sum4=g_oeb[l_ac].oeb912*g_oeb[l_ac].oeb911*l_fac
         END CASE
      END IF
      IF cl_null(l_sum4) THEN LET l_sum4=0 END IF
      IF (l_sum2-l_sum3)+l_sum4>l_sum1 THEN
         CALL cl_err(g_oeb[l_ac].oeb09,'atm-030',0)
      END IF
   END IF
   RETURN TRUE
END FUNCTION

#DIS only
FUNCTION t400_chk_oeb091(l_b2)
   DEFINE l_cnt   LIKE type_file.num10,
          l_sum1  LIKE oeb_file.oeb12,
          l_sum2  LIKE oeb_file.oeb12,
          l_sum3  LIKE oeb_file.oeb12,
          l_sum4  LIKE oeb_file.oeb12,
          l_check LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_fac   LIKE oeb_file.oeb05_fac,
          l_b2    LIKE cob_file.cob08,    #No.FUN-680137 VARCHAR(30)
          l_ima25 LIKE ima_file.ima25

   IF NOT cl_null(g_oeb[l_ac].oeb091) THEN
      IF cl_null(g_oeb_t.oeb091) OR g_oeb[l_ac].oeb091!=g_oeb_t.oeb091 THEN
         SELECT COUNT(*) INTO l_cnt
           FROM ime_file
          WHERE ime02=g_oeb[l_ac].oeb091
            AND ime01=g_oeb[l_ac].oeb09
            AND ime05='Y'
         IF l_cnt = 0 THEN
            CALL cl_err(g_oeb[l_ac].oeb09,'mfg0094',0)
            RETURN FALSE
         END IF
      END IF
      LET l_sum1 = 0
      LET l_sum2 = 0
      LET l_sum3 = 0
      LET l_sum4 = 0
#FUN-AB0011 -------------STA
      IF s_joint_venture( g_oeb[l_ac].oeb04,g_plant) OR NOT s_internal_item(g_oeb[l_ac].oeb04,g_plant ) THEN
         RETURN TRUE
      END IF
#FUN-AB0011 -------------END
      SELECT SUM(img10*img21) INTO l_sum1
        FROM img_file WHERE img01=g_oeb[l_ac].oeb04
         AND img02=g_oeb[l_ac].oeb09
         AND img03=g_oeb[l_ac].oeb091
      IF cl_null(l_sum1) THEN LET l_sum1=0 END IF
      SELECT SUM(oeb12*oeb05_fac),SUM(oeb24*oeb05_fac)
        INTO l_sum2 ,l_sum3
        FROM oea_file,oeb_file
       WHERE oea01=oeb01 AND oea49='1'
         AND oeb09=g_oeb[l_ac].oeb09
         AND oeb04=g_oeb[l_ac].oeb04
         AND oeb091=g_oeb[l_ac].oeb091
         AND (oeb01!=g_oea.oea01 AND oeb03!=g_oeb[l_ac].oeb03)
      IF cl_null(l_sum2) THEN LET l_sum2=0 END IF
      IF cl_null(l_sum3) THEN LET l_sum3=0 END IF
      IF g_sma.sma115='N' THEN
         CALL s_umfchk(g_oeb[l_ac].oeb04,g_oeb[l_ac].oeb05,l_ima25)
              RETURNING l_check,l_fac
         IF l_check = '1'  THEN
            LET l_fac = 1
         END IF
         LET l_sum4=g_oeb[l_ac].oeb12*l_fac
      ELSE
         CALL s_umfchk(g_oeb[l_ac].oeb04,l_b2,l_ima25)
              RETURNING l_check,l_fac
         IF l_check = '1'  THEN
            LET l_fac = 1
         END IF
         CASE g_ima906
              WHEN '1' LET l_sum4=g_oeb[l_ac].oeb912*g_oeb[l_ac].oeb911*l_fac
              WHEN '2' LET l_sum4=(g_oeb[l_ac].oeb912*g_oeb[l_ac].oeb911+
                                  g_oeb[l_ac].oeb915*g_oeb[l_ac].oeb914)*l_fac
              WHEN '3' LET l_sum4=g_oeb[l_ac].oeb912*g_oeb[l_ac].oeb911*l_fac
         END CASE
      END IF
      IF cl_null(l_sum4) THEN LET l_sum4=0 END IF
      IF (l_sum2-l_sum3)+l_sum4>l_sum1 THEN
         CALL cl_err(g_oeb[l_ac].oeb09,'atm-030',0)
      END IF
   END IF
   RETURN TRUE
END FUNCTION

#DIS only
FUNCTION t400_oea_sum()
DEFINE  l_sum1,l_sum1_t  LIKE oeb_file.oeb14,
        l_sum,l_sum_t    LIKE oeb_file.oeb14,
        l_tax,l_tax1     LIKE oeb_file.oeb14,
        l_ttl3           LIKE oea_file.oea61

   SELECT azi03,azi04 INTO t_azi03,t_azi04           #No.CHI-6A0004
     FROM azi_file WHERE azi_file.azi01=g_oea.oea23
   SELECT SUM(oeb14),SUM(oeb14t) INTO l_sum1,l_sum1_t
     FROM oeb_file
    WHERE oeb01 = g_oea.oea01
      AND oeb1003='1'

   SELECT SUM(oeb14),SUM(oeb14t) INTO l_sum,l_sum_t
     FROM oeb_file
    WHERE oeb01 = g_oea.oea01
      AND oeb1003='2'

   CALL cl_digcut(l_sum,t_azi04) RETURNING l_sum            #CHI-7A0036-add
   CALL cl_digcut(l_sum_t,t_azi04) RETURNING l_sum_t        #CHI-7A0036-add

   IF cl_null(l_sum1) THEN LET l_sum1 = 0 END IF
   IF cl_null(l_sum1_t) THEN LET l_sum1_t = 0 END IF
   IF cl_null(l_sum) THEN LET l_sum = 0 END IF
   IF cl_null(l_sum_t) THEN LET l_sum_t = 0 END IF

   CALL cl_numfor(l_sum1,8,t_azi04) RETURNING l_sum1        #No.CHI-6A0004
   CALL cl_numfor(l_sum1_t,8,t_azi04) RETURNING l_sum1_t     #No.CHI-6A0004
   CALL cl_numfor(l_sum,8,t_azi04) RETURNING l_sum          #No.CHI-6A0004
   CALL cl_numfor(l_sum_t,8,t_azi04) RETURNING l_sum_t      #No.CHI-6A0004

   UPDATE oea_file SET oea61=l_sum1,oea1008=l_sum1_t
    WHERE oea01=g_oea.oea01

   UPDATE oea_file SET oea1006=l_sum,oea1007=l_sum_t
    WHERE oea01=g_oea.oea01
   LET g_oea.oea1006 = l_sum
   LET g_oea.oea1007 = l_sum_t
   LET l_tax = l_sum_t - l_sum
   LET g_oea.oea61=l_sum1
   LET g_oea.oea1008=l_sum1_t
   LET l_tax1=l_sum1_t-l_sum1
   CALL cl_numfor(l_tax,8,t_azi04) RETURNING l_tax       #No.CHI-6A0004
   CALL cl_numfor(l_tax1,8,t_azi04) RETURNING l_tax1      #No.CHI-6A0004

   LET l_ttl3=g_oea.oea61+l_tax1-g_oea.oea1006-l_tax
   CALL cl_numfor(l_ttl3,8,t_azi04) RETURNING l_ttl3     #No.CHI-6A0004
   DISPLAY BY NAME g_oea.oea61
   DISPLAY l_tax1 to FORMONLY.ttl2
   DISPLAY BY NAME g_oea.oea1006
   DISPLAY l_tax TO FORMONLY.ttl1
   DISPLAY l_ttl3 TO FORMONLY.ttl3

END FUNCTION

#DIS only
FUNCTION t400_weight_cubage()
DEFINE l_oeb03       LIKE oeb_file.oeb03,
       l_oeb04       LIKE oeb_file.oeb04,
       l_oeb05       LIKE oeb_file.oeb05,
       l_oeb12       LIKE oeb_file.oeb12,
       l1_oea1013,l_oea1013    LIKE oea_file.oea1013,
       l1_oea1014,l_oea1014    LIKE oea_file.oea1014

    DECLARE t400_b2_b CURSOR FOR
     SELECT oeb03,oeb04,oeb05,oeb12
       FROM oeb_file
      WHERE oeb01 = g_oea.oea01
        AND oeb1003='1'
      ORDER BY oeb03

   LET l_oea1013 = 0
   LET l_oea1014 = 0
   FOREACH t400_b2_b INTO l_oeb03,l_oeb04,l_oeb05,l_oeb12
      CALL s_weight_cubage(l_oeb04,l_oeb05,l_oeb12)
                 RETURNING l1_oea1013,l1_oea1014
      LET l_oea1013 = l_oea1013 + l1_oea1013
      LET l_oea1014 = l_oea1014 + l1_oea1014
   END FOREACH
   IF l_oea1013 > 0 OR l_oea1014 > 0 THEN
      LET g_oea.oea1013 = l_oea1013
      LET g_oea.oea1014 = l_oea1014
      UPDATE oea_file SET oea1013 = g_oea.oea1013,
                          oea1014 = g_oea.oea1014
       WHERE oea01 = g_oea.oea01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","oea_file",g_oea.oea01,"",SQLCA.sqlcode,"","upd oea01:",1)  #No.FUN-650108
         RETURN
      END IF
      DISPLAY BY NAME g_oea.oea1013
      DISPLAY BY NAME g_oea.oea1014
   END IF
END FUNCTION

FUNCTION t400_set_entry_b1()
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
     CALL cl_set_comp_entry("oeb14_1,oeb14t_1",TRUE)
END FUNCTION

FUNCTION t400_pic()
     IF g_oea.oeaconf = 'X' THEN
        LET g_void = "Y"
     ELSE
        LET g_void = "N"
     END IF
     IF g_oea.oea49 = '1' THEN
        LET g_approve = "Y"
     ELSE
        LET g_approve = "N"
     END IF
     CALL cl_set_field_pic(g_oea.oeaconf,g_approve,"","",g_void,"")
END FUNCTION

#DIS only
FUNCTION t400_b1_ins()
   INSERT INTO oeb_file (oeb01,oeb03,oeb1007,oeb1008,oeb1009,
                         oeb1010,oeb1011,oeb1001,oeb1003,
                         oeb05_fac,oeb12,oeb13,oeb23,oeb37,                 #FUN-AB0061 add oeb37
                         oeb44,oebplant,oeblegal,              #No.FUN-870007
                         oeb24,oeb25,oeb26,oeb14,oeb14t,oeb70,oeb1012,oeb1006)  #No.TQC-740349 add oeb1012   #MOD-A10123 add oeb1006
                  VALUES(g_oea.oea01,g_oeb1[l_ac].oeb03_1,g_oeb1[l_ac].oeb1007,
                         g_oeb1[l_ac].oeb1008,g_oeb1[l_ac].oeb1009,g_oeb1[l_ac].oeb1010,
                         g_oeb1[l_ac].oeb1011,g_oeb1[l_ac].oeb1001_1,'2',
                         1,0,0,0,0,                                                  #No.FUN-870007    #FUN-AB0061 add 0 
                         '1',g_plant,g_legal,                                      #No.FUN-870007
                         0,0,0,g_oeb1[l_ac].oeb14_1,g_oeb1[l_ac].oeb14t_1,'N','N',100) #No.FUN-870007   #MOD-A10123 add oeb1006
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","oeb_file",g_oea.oea01,g_oeb1[l_ac].oeb03_1,SQLCA.sqlcode,"","ins oeb",1)  #No.FUN-650108
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION

#DIS only
FUNCTION t400_b1_bef_oeb03(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   CALL t400_set_entry_b(p_cmd)
   IF g_oeb1[l_ac].oeb03_1 IS NULL OR g_oeb1[l_ac].oeb03_1 = 0 THEN
      SELECT max(oeb03)+1 INTO g_oeb1[l_ac].oeb03_1
        FROM oeb_file WHERE oeb01 = g_oea.oea01
         AND oeb1003 = '2' AND oeb03 > 9000
      IF g_oeb1[l_ac].oeb03_1 IS NULL THEN
         LET g_oeb1[l_ac].oeb03_1 = 9001
      END IF
   END IF
END FUNCTION

#DIS only
FUNCTION t400_b1_chk_oeb03()
   IF NOT cl_null(g_oeb1[l_ac].oeb03_1) THEN
      IF g_oeb1[l_ac].oeb03_1 != g_oeb1_t.oeb03_1 OR
         g_oeb1_t.oeb03_1 IS NULL THEN
         LET g_cnt=0
         SELECT count(*) INTO g_cnt FROM oeb_file
          WHERE oeb01 = g_oea.oea01 AND oeb03 = g_oeb1[l_ac].oeb03_1
         IF g_cnt > 0 THEN
            LET g_oeb1[l_ac].oeb03_1 = g_oeb1_t.oeb03_1
            CALL cl_err('',-239,0)
            RETURN FALSE
         END IF

         IF g_oeb1[l_ac].oeb03_1 < 9001 THEN
            CALL cl_err('','atm-003',0)
            LET g_oeb1[l_ac].oeb03_1 = g_oeb1_t.oeb03_1
            RETURN FALSE
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION

#DIS only
FUNCTION t400_b1_chk_oeb1007(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1

   IF NOT cl_null(g_oeb1[l_ac].oeb1007) THEN
      IF g_oeb1[l_ac].oeb1007 != g_oeb1_t.oeb1007
         OR cl_null(g_oeb1_t.oeb1007) THEN
         LET g_cnt=0
         SELECT COUNT(*) INTO g_cnt FROM oeb_file
          WHERE oeb01=g_oea.oea01
            AND oeb1007=g_oeb1[l_ac].oeb1007
         IF g_cnt > 0 THEN
            CALL cl_err(g_oeb1[l_ac].oeb1007,'atm-045',0) #TQC-7C0098
            LET g_oeb1[l_ac].oeb1007=g_oeb1_t.oeb1007
            RETURN FALSE
         END IF
         CALL t400_oeb1007(p_cmd,l_ac)
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_oeb1[l_ac].oeb1007,g_errno,0)
            LET g_oeb1[l_ac].oeb1007=g_oeb1_t.oeb1007
            RETURN FALSE
         END IF
         IF g_oeb1[l_ac].oeb1010 = 'Y' THEN
            LET g_oeb1[l_ac].oeb14_1=g_oeb1[l_ac].oeb14t_1/(1+g_oeb1[l_ac].oeb1009/100)
         ELSE
            LET g_oeb1[l_ac].oeb14t_1=g_oeb1[l_ac].oeb14_1*(1+g_oeb1[l_ac].oeb1009/100)
         END IF
         CALL cl_digcut(g_oeb1[l_ac].oeb14_1,t_azi04) RETURNING g_oeb1[l_ac].oeb14_1
         CALL cl_digcut(g_oeb1[l_ac].oeb14t_1,t_azi04) RETURNING g_oeb1[l_ac].oeb14t_1
         DISPLAY BY NAME g_oeb1[l_ac].oeb14_1
         DISPLAY BY NAME g_oeb1[l_ac].oeb14t_1
      END IF
   END IF
   CALL t400_set_no_entry_b1()
   RETURN TRUE
END FUNCTION

#DIS only
FUNCTION t400_set_no_entry_b1()
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
   IF INFIELD(oeb1007) THEN
      IF g_oeb1[l_ac].oeb1010='Y' THEN
         CALL cl_set_comp_entry("oeb14_1",FALSE)
      ELSE
         CALL cl_set_comp_entry("oeb14t_1",FALSE)
      END IF
   END IF
END FUNCTION

#DIS only
FUNCTION t400_b1_bef_oeb14()
   IF g_oea.oea50='Y' AND NOT cl_null(g_oea.oea55) THEN  # 原幣金額
      SELECT SUM(oeb14_1) INTO g_oea.oea61 FROM oeb_file
       WHERE oeb01=g_oea.oea01
      LET g_diff = g_oea.oea55-(g_oea.oea61 -
                   g_oeb1_t.oeb14_1 +g_oeb1[l_ac].oeb14_1)
      CALL cl_err(g_diff,'axm-266',0)
   END IF
END FUNCTION

#DIS only
FUNCTION t400_b1_chk_oeb14()
   DEFINE l_max           LIKE tqw_file.tqw07

   CALL cl_digcut(g_oeb1[l_ac].oeb14_1,t_azi04) RETURNING g_oeb1[l_ac].oeb14_1                #No.CHI-6A0004
   IF g_oeb1_t.oeb14_1 IS NULL OR g_oeb1_t.oeb14_1 <> g_oeb1[l_ac].oeb14_1 THEN
      LET l_max = g_oeb1[l_ac].tqw07-g_oeb1[l_ac].tqw08
      IF l_max > 0 THEN
         IF g_oeb1[l_ac].oeb14_1>l_max OR g_oeb1[l_ac].oeb14_1<=0 THEN
            CALL cl_err(g_oeb1[l_ac].oeb14_1,'atm-031',0)
            RETURN FALSE
         END IF
      ELSE
         IF g_oeb1[l_ac].oeb14_1<l_max OR g_oeb1[l_ac].oeb14_1>=0 THEN
            CALL cl_err(g_oeb1[l_ac].oeb14_1,'atm-032',0)
            RETURN FALSE
         END IF
      END IF
      LET g_oeb1[l_ac].oeb14t_1=g_oeb1[l_ac].oeb14_1*(1+g_oeb1[l_ac].oeb1009/100)
   END IF
   CALL cl_digcut(g_oeb1[l_ac].oeb14t_1,t_azi04) RETURNING g_oeb1[l_ac].oeb14t_1  #No.TQC-740349
   DISPLAY BY NAME g_oeb1[l_ac].oeb14_1
   DISPLAY BY NAME g_oeb1[l_ac].oeb14t_1
   RETURN TRUE
END FUNCTION

#DIS only
FUNCTION t400_b1_chk_oeb14t()
   DEFINE l_max           LIKE tqw_file.tqw07
   CALL cl_digcut(g_oeb1[l_ac].oeb14t_1,t_azi04)                #No.CHI-6A0004
                  RETURNING g_oeb1[l_ac].oeb14t_1
   CALL cl_digcut(g_oeb1[l_ac].oeb14_1,t_azi04) RETURNING g_oeb1[l_ac].oeb14_1          #No.CHI-6A0004
   IF g_oeb1_t.oeb14t_1 IS NULL OR g_oeb1_t.oeb14t_1 <> g_oeb1[l_ac].oeb14t_1 THEN
      LET l_max = g_oeb1[l_ac].tqw07-g_oeb1[l_ac].tqw08
      IF l_max > 0 THEN
         IF g_oeb1[l_ac].oeb14t_1>l_max OR g_oeb1[l_ac].oeb14t_1<=0 THEN
            CALL cl_err(g_oeb1[l_ac].oeb14t_1,'atm-031',0)
            RETURN FALSE
         END IF
      ELSE
         IF g_oeb1[l_ac].oeb14t_1<l_max OR g_oeb1[l_ac].oeb14t_1>=0 THEN
            CALL cl_err(g_oeb1[l_ac].oeb14t_1,'atm-032',0)
            RETURN FALSE
         END IF
      END IF
      LET g_oeb1[l_ac].oeb14_1=g_oeb1[l_ac].oeb14t_1/(1+g_oeb1[l_ac].oeb1009/100)
   END IF
   CALL cl_digcut(g_oeb1[l_ac].oeb14_1,t_azi04) RETURNING g_oeb1[l_ac].oeb14_1
   CALL cl_digcut(g_oeb1[l_ac].oeb14t_1,t_azi04) RETURNING g_oeb1[l_ac].oeb14t_1
   DISPLAY BY NAME g_oeb1[l_ac].oeb14_1
   DISPLAY BY NAME g_oeb1[l_ac].oeb14t_1
   RETURN TRUE
END FUNCTION

FUNCTION t400_b1_del()

   DELETE FROM oeb_file
    WHERE oeb01 = g_oea.oea01 AND oeb03 = g_oeb1_t.oeb03_1
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","oeb_file",g_oea.oea01,g_oeb1_t.oeb03_1,SQLCA.sqlcode,"","",1)  #No.FUN-650108
      RETURN FALSE
   END IF
   LET g_oea49= '0'      #MOD-4A0299
   DELETE FROM oeo_file
    WHERE oeo01 = g_oea.oea01 AND oeo03 = g_oeb1_t.oeb03_1
   DELETE FROM oef_file
    WHERE oef01 = g_oea.oea01 AND oef03 = g_oeb1_t.oeb03_1
   RETURN TRUE
END FUNCTION

FUNCTION t400_b1_upd()
   IF cl_null(b_oeb.oeb091) THEN LET b_oeb.oeb091=' ' END IF
   IF cl_null(b_oeb.oeb092) THEN LET b_oeb.oeb092=' ' END IF
   UPDATE oeb_file SET oeb03 = g_oeb1[l_ac].oeb03_1,
                       oeb1007 = g_oeb1[l_ac].oeb1007,
                       oeb1008 = g_oeb1[l_ac].oeb1008,
                       oeb1009 = g_oeb1[l_ac].oeb1009,
                       oeb1010 = g_oeb1[l_ac].oeb1010,
                       oeb1011 = g_oeb1[l_ac].oeb1011,
                       oeb1001 = g_oeb1[l_ac].oeb1001_1,
                       oeb14   = g_oeb1[l_ac].oeb14_1,   #No.FUN-650108
                       oeb14t  = g_oeb1[l_ac].oeb14t_1   #No.FUN-650108
    WHERE oeb01=g_oea.oea01 AND oeb03=g_oeb1_t.oeb03_1
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","oeb_file",g_oea.oea01,g_oeb1_t.oeb03_1,SQLCA.sqlcode,"","upd oeb",1)  #No.FUN-650108
      LET g_oeb1[l_ac].* = g_oeb1_t.*
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_b1_fill(p_wc3)              #BODY FILL UP
DEFINE
    p_wc3           LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)

    LET g_sql =
        "SELECT oeb03,oeb1007,'','','',oeb1008,oeb1009,",
        "       oeb1010,oeb1011,oeb1001,oeb14,oeb14t ",
        " FROM oeb_file ",
        " WHERE oeb01 ='",g_oea.oea01,"'",
        " AND ",p_wc3 CLIPPED,
       #" AND oeb1003='2' ",  #TQC-AC0163 By shi
        " AND oeb03>'9000' ", #TQC-AC0163 By shi
        " ORDER BY oeb03"

    PREPARE t400_b1fill_p FROM g_sql
    DECLARE t400_b1fill                       #CURSOR
        CURSOR WITH HOLD FOR t400_b1fill_p

    CALL g_oeb1.clear()
    LET g_cnt = 1
    LET g_rec_b1 = 0
    FOREACH t400_b1fill INTO g_oeb1[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        IF NOT cl_null(g_oeb1[g_cnt].oeb1007) THEN
           SELECT tqw16,tqw07,tqw08
             INTO g_oeb1[g_cnt].tqw16,g_oeb1[g_cnt].tqw07,g_oeb1[g_cnt].tqw08
             FROM tqw_file
            WHERE tqw01 = g_oeb1[g_cnt].oeb1007
              AND tqw10 = '3'
              AND tqw17 = g_oea.oea23
              AND tqw05 = g_oea.oea03
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_oeb1.deleteElement(g_cnt)
    LET g_rec_b1=g_cnt - 1
    DISPLAY g_rec_b1 TO FORMONLY.cn4
    LET g_cnt = 0
END FUNCTION

FUNCTION t400_set_oeb917_exp(l_item,l_oqu05,l_oqu06)   #料號,單位,數量
   DEFINE l_item     LIKE img_file.img01,     #料號
          l_ima25    LIKE ima_file.ima25,     #ima單位
          l_ima31    LIKE ima_file.ima31,     #銷售單位
          l_ima906   LIKE ima_file.ima906,
          l_fac2     LIKE img_file.img21,     #第二轉換率
          l_qty2     LIKE img_file.img10,     #第二數量
          l_fac1     LIKE img_file.img21,     #第一轉換率
          l_qty1     LIKE img_file.img10,     #第一數量
          l_tot      LIKE img_file.img10,     #計價數量
          l_unit     LIKE ima_file.ima25,     #No.MOD-580261
          l_unit1    LIKE ima_file.ima25,     #No.MOD-580261
          l_oqu05    LIKE oqu_file.oqu05,     #單位
          l_oqu06    LIKE oqu_file.oqu06,     #數量
          l_factor   LIKE ima_file.ima31_fac

   SELECT ima25,ima31,ima906
     INTO l_ima25,l_ima31,l_ima906
     FROM ima_file
    WHERE ima01 = l_item

   IF SQLCA.sqlcode = 100 THEN
      IF l_item MATCHES 'MISC*' THEN
         SELECT ima25,ima31,ima906
           INTO l_ima25,l_ima31,l_ima906
           FROM ima_file
          WHERE ima01 = 'MISC'
      END IF
   END IF

   IF cl_null(l_ima31) THEN
      LET l_ima31 = l_ima25
   END IF

   LET l_fac2 = b_oeb.oeb914
   LET l_qty2 = b_oeb.oeb915

   IF g_sma.sma115 = 'Y' THEN
      LET l_fac1 = b_oeb.oeb911
      LET l_qty1 = b_oeb.oeb912
      LET l_unit1 = b_oeb.oeb910
   ELSE
      LET l_fac1 = 1
      LET l_qty1 = l_oqu06
      CALL s_umfchk(l_item,l_oqu05,l_ima31)
          RETURNING g_cnt,l_fac1
      IF g_cnt = 1 THEN
         LET l_fac1 = 1
      END IF
      LET l_unit1 = l_oqu05
   END IF

   IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
   IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
   IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
   IF cl_null(l_qty2) THEN LET l_qty2=0 END IF

   IF g_sma.sma115 = 'Y' THEN
      CASE l_ima906
         WHEN '1' LET l_tot = l_qty1 * l_fac1
         WHEN '2' LET l_tot = l_qty1 * l_fac1 + l_qty2 * l_fac2
         WHEN '3' LET l_tot = l_qty1 * l_fac1
      END CASE
   ELSE  #不使用雙單位
      LET l_tot = l_qty1 * l_fac1
   END IF

   IF cl_null(l_tot) THEN
      LET l_tot = 0
   END IF

   IF g_sma.sma116 MATCHES '[01]' THEN    #No.FUN-610076
      IF g_sma.sma115 = 'Y' THEN
         CASE l_ima906
            WHEN '1' LET l_unit=l_unit1
            WHEN '2' LET l_unit=l_ima31
            WHEN '3' LET l_unit=l_unit1
         END CASE
      ELSE  #不使用雙單位
         LET l_unit=l_unit1
      END IF
      LET b_oeb.oeb916=l_unit
   END IF

   LET l_factor = 1
   CALL s_umfchk(l_item,l_ima31,b_oeb.oeb916)
       RETURNING g_cnt,l_factor

   IF g_cnt = 1 THEN
      LET l_factor = 1
   END IF

   LET l_tot = l_tot * l_factor
   LET b_oeb.oeb917 = l_tot

END FUNCTION


FUNCTION t400_a_default()
DEFINE l_azp02 LIKE azp_file.azp02 #No.FUN-870007

   LET g_oea.oea00 = g_argv1
   LET g_oea.oea02 = g_today
   LET g_oea.oea06 = g_oaz.oaz41

   IF g_oaz.oaz64 = 'O' THEN
     #LET g_oea.oea07  =''  #MOD-B30131 mark
      LET g_oea.oea07  ='N' #MOD-B30131
   ELSE
      LET g_oea.oea07  =g_oaz.oaz64
   END IF

   IF g_oea901 = 'Y' THEN
      LET g_oea.oea08 = '2'
   ELSE
      LET g_oea.oea08 = '1'
   END IF

   LET g_oea.oea09  =g_oaz.oaz201
   LET g_oea.oea11  ='1'
   CALL cl_getmsg('axm-905',g_lang) RETURNING g_msg
   CALL cl_set_comp_att_text("oeb71",g_msg CLIPPED)
   LET g_oea.oea14  =g_user
   LET g_oea.oea15  =g_grup
   LET g_oea.oea161 =0
   LET g_oea.oea162 =100
   IF g_azw.azw04='2' THEN
      LET g_oea.oea161=''
      LET g_oea.oea162=''
   END IF
   LET g_oea.oea163 =0
   LET g_oea.oea261 =0    #No:FUN-A50103
   LET g_oea.oea262 =0    #No:FUN-A50103
   LET g_oea.oea263 =0    #No:FUN-A50103
   LET g_oea.oea18  ='N'          #No.3192 add
   LET g_oea.oea61  =0
   LET g_oea.oea62  =0
   LET g_oea.oea63  =0
   LET g_oea.oea65  ='N'  #No.FUN-610056
   LET g_oea.oea50  ='N'
   LET g_oea.oea37 = 'N'   #No.FUN-640025
   LET g_oea.oea1005='N'   #FUN-610055
   LET g_oea.oea1012='N'   #FUN-610055
   LET g_oea.oea905 ='N'   #FUN-610055
  #LET g_oea.oeaoriu = g_user      #No.FUN-980030 10/01/04
  #LET g_oea.oeaorig = g_grup      #No.FUN-980030 10/01/04

   LET g_oea.oea901 = g_oea901    #非多角貿易
   IF g_oea.oea901 = 'Y' THEN
      LET g_oea.oea902='N'
      LET g_oea.oea905='N'
      LET g_oea.oea906='Y'
   ELSE
      LET g_oea.oea902=''
      LET g_oea.oea905='N'
      LET g_oea.oea906=''
   END IF

   LET g_oea.oeaconf='N'
   LET g_oea.oeacont=''  #No.FUN-870007
   LET g_oea.oeaprsw=0
   LET g_oea.oeauser=g_user
   LET g_oea.oeaoriu = g_user #FUN-980030
   LET g_oea.oeaorig = g_grup #FUN-980030
   LET g_data_plant = g_plant #FUN-980030
   LET g_oea.oeagrup=g_grup
   LET g_oea.oeadate=g_today
   LET g_oea.oea49   = '0'         #0.開立/送簽中 1.已核淮
   LET g_oea.oeamksg = 'N'         #是否簽核 y/n
   LET g_oea.oeasign = ''          #簽核等級
   LET g_oea.oeasmax = 0           #己簽順序
   LET g_oea.oeasseq = 0           #應簽順序
   LET g_oea.oeadays = 0           #簽核完成天數
   LET g_occm.occm01=' '
   LET g_occm.occm02=' '
   LET g_occm.occm03=' '
   LET g_occm.occm04=' '
   LET g_occm.occm05=' '
   LET g_occm.occm06=' '
   LET g_occm.occm07=' '    #FUN-720014 add
   LET g_occm.occm08=' '    #FUN-720014 add
   LET g_oea.oeaplant = g_plant
   LET g_oea.oealegal = g_legal
   IF g_azw.azw04='2' THEN
      LET g_oea.oea83 =g_plant
      LET g_oea.oea84 =g_plant
      DISPLAY BY NAME g_oea.oea83,g_oea.oea84,g_oea.oeaplant
                     ,g_oea.oeaoriu, g_oea.oeaorig
      CALL t400_oea83('d')
      CALL t400_oea84('d')
      SELECT azp02 INTO l_azp02 FROM azp_file
       WHERE azp01 = g_plant
       DISPLAY l_azp02 TO oeaplant_desc
   END IF
END FUNCTION

FUNCTION t400_undo_dis()
   DEFINE l_cnt    LIKE type_file.num5

   SELECT * INTO g_oea.* FROM oea_file WHERE oea01= g_oea.oea01

   IF g_oea.oea37 = "N" THEN
      RETURN
   END IF

   IF g_oea.oeaconf = 'X' THEN
      CALL cl_err('',9024,0)
      RETURN
   END IF

   IF g_oea.oeaconf = 'Y' THEN
      CALL cl_err('','aap-005',0)
      RETURN
   END IF

   IF NOT cl_confirm('axm-081') THEN RETURN END IF

   SELECT COUNT(*) INTO l_cnt FROM oeb_file
    WHERE oeb01 = g_oea.oea01
      AND oeb920 > 0   #NO.TQC-750157

   IF l_cnt > 0 THEN
      CALL cl_err('','axm-082',1)
      RETURN
   END IF

   UPDATE oea_file SET oea37 = "N"
    WHERE oea01 = g_oea.oea01

   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","oea_file",g_oea.oea01,"",SQLCA.SQLCODE,"","update oeafail",1)
      RETURN
   END IF

   SELECT * INTO g_oea.* FROM oea_file WHERE oea01=g_oea.oea01

END FUNCTION

#重算單身的單價金額
FUNCTION t400_mdet()
 DEFINE l_oeb03   LIKE oeb_file.oeb03,
        l_oeb917  LIKE oeb_file.oeb917,    #CHI-7A0036-modify oeb12-> oeb917
        l_oeb13   LIKE oeb_file.oeb13,
        l_oeb14   LIKE oeb_file.oeb14,
        l_oeb14t  LIKE oeb_file.oeb14t

   #更改單身狀況
    DECLARE t400_stat CURSOR FOR
            SELECT oeb03,oeb917,oeb13,oeb14,oeb14t FROM oeb_file
            WHERE oeb01 = g_oea.oea01
    FOREACH t400_stat INTO l_oeb03,l_oeb917,l_oeb13,l_oeb14,l_oeb14t  #CHI-7A0036-modify oeb12->oeb917
      IF g_oea.oea213 = 'N' THEN
        LET l_oeb14 = l_oeb917 * l_oeb13                        #CHI-7A0036-modify oeb12->oeb917
        CALL cl_digcut(l_oeb14,t_azi04)  RETURNING l_oeb14      #CHI-7A0036-add
        LET l_oeb14t= l_oeb14 * (1+g_oea.oea211/100)
        CALL cl_digcut(l_oeb14t,t_azi04) RETURNING l_oeb14t     #CHI-7A0036-add
      ELSE
        LET l_oeb14t= l_oeb917 * l_oeb13                        #CHI-7A0036-modify oeb12->oeb917
        CALL cl_digcut(l_oeb14t,t_azi04) RETURNING l_oeb14t     #CHI-7A0036-add
        LET l_oeb14 = l_oeb14t/ (1+g_oea.oea211/100)
        CALL cl_digcut(l_oeb14,t_azi04)  RETURNING l_oeb14      #CHI-7A0036-add
      END IF

      UPDATE oeb_file
         SET oeb14  = l_oeb14
            ,oeb14t = l_oeb14t
       WHERE oeb01 = g_oea.oea01
         AND oeb03 = l_oeb03
      IF SQLCA.sqlcode THEN
        CALL cl_err3("UPDATE","oeb_file",l_oeb03,"",SQLCA.SQLCODE,"","upd oeb:",1)
        RETURN FALSE
      END IF
    END FOREACH

    RETURN TRUE
END FUNCTION



FUNCTION t400_oea46()
  DEFINE l_pja02   LIKE pja_file.pja02

  LET l_pja02 = ''
  IF NOT cl_null(g_oea.oea46) THEN
    SELECT pja02 INTO l_pja02 FROM pja_file
     WHERE pja01 = g_oea.oea46
    IF SQLCA.sqlcode THEN
       LET l_pja02 = ''
    END IF
  END IF

  DISPLAY l_pja02 TO FORMONLY.pja02
END FUNCTION

FUNCTION t400_cash_return()
DEFINE l_n     LIKE type_file.num5
DEFINE l_tqp12 LIKE tqp_file.tqp12
DEFINE l_tqs04 LIKE tqs_file.tqs04
DEFINE #l_sql   LIKE type_file.chr1000
       l_sql   STRING      #NO.FUN-910082
DEFINE l_tqr   RECORD LIKE tqr_file.*
DEFINE l_tqw   RECORD LIKE tqw_file.*
DEFINE l_tqv   RECORD LIKE tqv_file.*
DEFINE l_tqs   RECORD LIKE tqs_file.*
DEFINE l_oeb   RECORD LIKE oeb_file.*
DEFINE l_oeb12_sum    LIKE oeb_file.oeb12
DEFINE l_oeb14_sum    LIKE oeb_file.oeb14
DEFINE l_oeb14t_sum   LIKE oeb_file.oeb14t
DEFINE l_ohb12_sum    LIKE ohb_file.ohb12
DEFINE l_ogb12_sum    LIKE ogb_file.ogb12
DEFINE l_ogb14_sum    LIKE ogb_file.ogb14
DEFINE l_ogb14t_sum   LIKE ogb_file.ogb14t
DEFINE l_ohb14_sum    LIKE ogb_file.ogb14
DEFINE l_ohb14t_sum   LIKE ogb_file.ogb14t
DEFINE li_result      LIKE type_file.num5
DEFINE l_success      LIKE type_file.num5
DEFINE l_last_month   LIKE type_file.num5
DEFINE l_last_year    LIKE type_file.num5
DEFINE l_month        LIKE type_file.num5
DEFINE l_bg_month     LIKE type_file.num5
DEFINE l_ed_month     LIKE type_file.num5
DEFINE l_last_bg      LIKE type_file.chr14
DEFINE l_last_ed      LIKE type_file.chr14
DEFINE l_bg           LIKE type_file.chr14
DEFINE l_ed           LIKE type_file.chr14
DEFINE l_last_bg_day  LIKE type_file.dat
DEFINE l_last_ed_day  LIKE type_file.dat
DEFINE l_bg_day       LIKE type_file.dat
DEFINE l_ed_day       LIKE type_file.dat
DEFINE l_flag         LIKE type_file.chr1
DEFINE l_count        LIKE  type_file.num5   #TQC-AC0153
 
#TQC-AC0153 ----------------STA
#   IF g_oea.oea11 ='3' AND (NOT cl_null(g_oea.oea12)) THEN
#      RETURN
#   END IF
    LET l_count = 0
    SELECT COUNT(*) INTO l_count FROM tqp_file
     WHERE tqp01 = g_oea.oea12
    IF g_oea.oea11 = '3' AND l_count = 0 THEN
       RETURN
    END IF
#TQC-AC0153 ----------------END
    IF g_oea.oea49 != '0' THEN
       RETURN
    END IF

    DELETE FROM oeb_file WHERE oeb01 =g_oea.oea01 AND oeb1003 ='2'
                           AND oeb03 >9000 #TQC-AC0163 By shi
    CALL t400_oea_sum()

#判斷此訂單是否已有對應的單次返現金折扣單存在
    SELECT COUNT(*) INTO l_n FROM tqw_file
     WHERE tqw23 =g_oea.oea01
       AND tqw22 =g_oea.oea12
       AND tqw21 ='1'
       AND tqw10!='5'
    BEGIN WORK #TQC-980029
    IF l_n ='0' THEN
#取得對應的合同折扣基准是未稅還是含稅金額
       SELECT tqp12 INTO l_tqp12 FROM tqp_file
        WHERE tqp01 =g_oea.oea12
       IF l_tqp12 ='1' THEN    #含稅金額
          LET l_sql ="SELECT * FROM tqr_file ",
                     " WHERE tqr06 ='1'",
                     "   AND tqr07 <= '",g_oea.oea02,"'",
                     "   AND tqr08 >= '",g_oea.oea02,"'",
                     "   AND tqr03 <= '",g_oea.oea1008,"'",
                     "   AND tqr04 >= '",g_oea.oea1008,"'",
                     "   AND tqr01  = '",g_oea.oea12,"'"
          PREPARE t400_cash_pb1 FROM l_sql
          DECLARE t400_cash_cs1 CURSOR FOR t400_cash_pb1
          FOREACH t400_cash_cs1 INTO l_tqr.*
             #insert tqw_file 產生現金折扣單資料
             SELECT oaz80 INTO l_tqw.tqw01 FROM oaz_file
#TQC-AC0031 --begin--
             IF cl_null(l_tqw.tqw01) THEN 
                CALL cl_err('','axm-268',0)
                ROLLBACK WORK 
                RETURN 
             END IF 
#TQC-AC0031 --end--             
            #CALL s_auto_assign_no("axm",l_tqw.tqw01,g_today,"04","tqw_file","tqw01","","","") #FUN-AC0012
             CALL s_auto_assign_no("atm",l_tqw.tqw01,g_today,"U5","tqw_file","tqw01","","","") #FUN-AC0012
                  RETURNING li_result,l_tqw.tqw01
             IF (NOT li_result) THEN
                CONTINUE FOREACH
             END IF
             LET l_tqw.tqw02 =g_today
             LET l_tqw.tqw03 =g_grup
             LET l_tqw.tqw04 =g_user
             LET l_tqw.tqw05 =g_oea.oea03
#            LET l_tqw.tqw07 =l_tqr.tqr05*g_oea.oea1008     #TQC-AC0028
             LET l_tqw.tqw07 =l_tqr.tqr05/100*g_oea.oea1008     #TQC-AC0028
             IF cl_null(l_tqw.tqw07) THEN
                LET l_tqw.tqw07 =0
             END IF
             LET l_tqw.tqw08 =0
             LET l_tqw.tqw081=0
             LET l_tqw.tqw10 ='3'
             LET l_tqw.tqw11 =g_oea.oea21
             LET l_tqw.tqw12 =g_oea.oea211
             LET l_tqw.tqw13 =g_oea.oea212
             LET l_tqw.tqw14 ='Y'
             LET l_tqw.tqw15 =l_tqr.tqr09
             LET l_tqw.tqw17 =g_oea.oea23
             LET l_tqw.tqw18 =g_oea.oea24
             LET l_tqw.tqw20 ='1'
             LET l_tqw.tqw21 ='1'
             LET l_tqw.tqw22 =l_tqr.tqr01
             LET l_tqw.tqw23 =g_oea.oea01
             LET l_tqw.tqwplant = g_plant #FUN-980010 add
             LET l_tqw.tqwlegal = g_legal #FUN-980010 add

             LET l_tqw.tqworiu = g_user      #No.FUN-980030 10/01/04
             LET l_tqw.tqworig = g_grup      #No.FUN-980030 10/01/04
             INSERT INTO tqw_file VALUES (l_tqw.*)
             IF STATUS OR SQLCA.SQLCODE THEN
                CALL cl_err3("ins","tqw_file",l_tqw.tqw01,"",SQLCA.sqlcode,"","",1)
                CONTINUE FOREACH
             END IF

             #insert tqv_file  產生現金折扣單明細資料
             LET l_tqv.tqv01 =l_tqw.tqw01
             LET l_tqv.tqv02 ='1'
             LET l_tqv.tqv03 =l_tqr.tqr09
             LET l_tqv.tqv05 =l_tqw.tqw07
             LET l_tqv.tqv06 ='N'
             LET l_tqv.tqvplant = g_plant #FUN-980010
             LET l_tqv.tqvlegal = g_legal #FUN-980010

             INSERT INTO tqv_file VALUES (l_tqv.*)
             IF STATUS OR SQLCA.SQLCODE THEN
                CALL cl_err3("ins","tqv_file",l_tqv.tqv01,"",SQLCA.sqlcode,"","",1)
                CONTINUE FOREACH
             END IF

             #insert oeb_file(返利單身)
             LET l_oeb.oeb1003 ='2'
             LET l_oeb.oeb1012 ='N'
             LET l_oeb.oeb01   =g_oea.oea01
            #SELECT MAX(oeb03) INTO l_oeb.oeb03 FROM oeb_file   #TQC-AC0163 By shi
             SELECT MAX(oeb03)+1 INTO l_oeb.oeb03 FROM oeb_file #TQC-AC0163 By shi
              WHERE oeb01 =g_oea.oea01 AND oeb03 >= 9001
             IF l_oeb.oeb03 IS NULL THEN
                LET l_oeb.oeb03 =9001
             END IF
             LET l_oeb.oeb1007 =l_tqw.tqw01
             LET l_oeb.oeb1008 =l_tqw.tqw11
             LET l_oeb.oeb1009 =l_tqw.tqw12
             LET l_oeb.oeb1010 =l_tqw.tqw14
             LET l_oeb.oeb1001 =l_tqw.tqw15
             LET l_oeb.oeb14t  =l_tqw.tqw07
            #LET l_oeb.oeb14   =l_tqw.tqw07/(1+l_oeb.oeb1009)     #MOD-AC0170
             LET l_oeb.oeb14   =l_tqw.tqw07/(1+l_oeb.oeb1009/100) #MOD-AC0170
             IF cl_null(l_oeb.oeb14t) THEN
                LET l_oeb.oeb14t =0
             END IF
             IF cl_null(l_oeb.oeb14) THEN
                LET l_oeb.oeb14 =0
             END IF
             LET l_oeb.oeb05_fac='1'
             LET l_oeb.oeb12    ='0'
             LET l_oeb.oeb13    ='0'
             LET l_oeb.oeb37    ='0'          #FUN-AB0061 
             LET l_oeb.oeb23    ='0'
             LET l_oeb.oeb24    ='0'
             LET l_oeb.oeb25    ='0'
             LET l_oeb.oeb26    ='0'
             LET l_oeb.oeb70    ='N'
             LET l_oeb.oeb44 = '1'        #No.FUN-870007
             LET l_oeb.oebplant = g_plant #No.FUN-870007
             LET l_oeb.oeblegal = g_legal #No.FUN-870007
             LET l_oeb.oeb47 = 0 #FUN-9C0083
             LET l_oeb.oeb48 = '1' #FUN-9C0083
             IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF   #MOD-A10123
            #MOD-AC0170 Begin---
             LET l_oeb.oeb04 = 'MISC'
             LET l_oeb.oeb12 = 1
             LET l_oeb.oeb917= 1
            #MOD-AC0170 End-----
            #TQC-B10066 Begin---
             LET l_oeb.oeb70d= ''
             LET l_oeb.oeb72 = ''
             LET l_oeb.oeb902= ''
             LET l_oeb.oeb30 = ''
             LET l_oeb.oebud13 = ''
             LET l_oeb.oebud14 = ''
             LET l_oeb.oebud15 = ''
             LET l_oeb.oeb15 = ''
             LET l_oeb.oeb16 = ''
             SELECT ima02 INTO l_oeb.oeb06 FROM ima_file
              WHERE ima01=l_oeb.oeb04
            #TQC-B10066 End-----
             INSERT INTO oeb_file VALUES (l_oeb.*)
             IF STATUS OR SQLCA.SQLCODE THEN
                CALL cl_err3("ins","oeb_file",l_oeb.oeb01,"",SQLCA.sqlcode,"","",1)
                CONTINUE FOREACH
             END IF
          END FOREACH
       ELSE
          LET l_sql ="SELECT * FROM tqr_file ",
                     " WHERE tqr06 ='1'",
                     "   AND tqr07 <= '",g_oea.oea02,"'",
                     "   AND tqr08 >= '",g_oea.oea02,"'",
                     "   AND tqr03 <= '",g_oea.oea61,"'",
                     "   AND tqr04 >= '",g_oea.oea61,"'",
                     "   AND tqr01  = '",g_oea.oea12,"'"
          PREPARE t400_cash_pb2 FROM l_sql
          DECLARE t400_cash_cs2 CURSOR FOR t400_cash_pb2
          FOREACH t400_cash_cs2 INTO l_tqr.*
             #insert tqw_file
             SELECT oaz80 INTO l_tqw.tqw01 FROM oaz_file
#TQC-AC0031 --begin--
             IF cl_null(l_tqw.tqw01) THEN 
                CALL cl_err('','axm-268',0)
                ROLLBACK WORK 
                RETURN 
             END IF 
#TQC-AC0031 --end--               
            #CALL s_auto_assign_no("axm",l_tqw.tqw01,g_today,"04","tqw_file","tqw01","","","") #FUN-AC0012
             CALL s_auto_assign_no("atm",l_tqw.tqw01,g_today,"U5","tqw_file","tqw01","","","") #FUN-AC0012
                  RETURNING li_result,l_tqw.tqw01
             IF (NOT li_result) THEN
                CONTINUE FOREACH
             END IF
             LET l_tqw.tqw02 =g_today
             LET l_tqw.tqw03 =g_grup
             LET l_tqw.tqw04 =g_user
             LET l_tqw.tqw05 =g_oea.oea03
#            LET l_tqw.tqw07 =l_tqr.tqr05*g_oea.oea61             #TQC-AC0028
             LET l_tqw.tqw07 =l_tqr.tqr05/100*g_oea.oea61         #TQC-AC0028
             IF cl_null(l_tqw.tqw07) THEN
                LET l_tqw.tqw07 =0
             END IF
             LET l_tqw.tqw08 =0
             LET l_tqw.tqw081=0
             LET l_tqw.tqw10 ='3'
             LET l_tqw.tqw11 =g_oea.oea21
             LET l_tqw.tqw12 =g_oea.oea211
             LET l_tqw.tqw13 =g_oea.oea212
             LET l_tqw.tqw14 ='N'
             LET l_tqw.tqw15 =l_tqr.tqr09
             LET l_tqw.tqw17 =g_oea.oea23
             LET l_tqw.tqw18 =g_oea.oea24
             LET l_tqw.tqw20 ='1'
             LET l_tqw.tqw21 ='1'
             LET l_tqw.tqw22 =l_tqr.tqr01
             LET l_tqw.tqw23 =g_oea.oea01
             LET l_tqw.tqwplant = g_plant #FUN-980010 add
             LET l_tqw.tqwlegal = g_legal #FUN-980010 add

             INSERT INTO tqw_file VALUES (l_tqw.*)
             IF STATUS OR SQLCA.SQLCODE THEN
                CALL cl_err3("ins","tqw_file",l_tqw.tqw01,"",SQLCA.sqlcode,"","",1)
                CONTINUE FOREACH
             END IF

             #insert tqv_file
             LET l_tqv.tqv01 =l_tqw.tqw01
             LET l_tqv.tqv02 ='1'
             LET l_tqv.tqv03 =l_tqr.tqr09
             LET l_tqv.tqv05 =l_tqw.tqw07
             LET l_tqv.tqv06 ='N'
             LET l_tqv.tqvplant = g_plant #FUN-980010
             LET l_tqv.tqvlegal = g_legal #FUN-980010

             INSERT INTO tqv_file VALUES (l_tqv.*)
             IF STATUS OR SQLCA.SQLCODE THEN
                CALL cl_err3("ins","tqv_file",l_tqv.tqv01,"",SQLCA.sqlcode,"","",1)
                CONTINUE FOREACH
             END IF

             #insert oeb_file(return benfit)
             LET l_oeb.oeb1003 ='2'
             LET l_oeb.oeb1012 ='N'
             LET l_oeb.oeb01   =g_oea.oea01
            #SELECT MAX(oeb03) INTO l_oeb.oeb03 FROM oeb_file   #TQC-AC0163 By shi
             SELECT MAX(oeb03)+1 INTO l_oeb.oeb03 FROM oeb_file #TQC-AC0163 By shi
              WHERE oeb01 =g_oea.oea01 AND oeb03 >= 9001
             IF l_oeb.oeb03 IS NULL THEN
                LET l_oeb.oeb03 =9001
             END IF
             LET l_oeb.oeb1007 =l_tqw.tqw01
             LET l_oeb.oeb1008 =l_tqw.tqw11
             LET l_oeb.oeb1009 =l_tqw.tqw12
             LET l_oeb.oeb1010 =l_tqw.tqw14
             LET l_oeb.oeb1001 =l_tqw.tqw15
             LET l_oeb.oeb14   =l_tqw.tqw07
            #LET l_oeb.oeb14t  =l_tqw.tqw07/(1+l_oeb.oeb1009)     #MOD-AC0170
             LET l_oeb.oeb14t  =l_tqw.tqw07*(1+l_oeb.oeb1009/100) #MOD-AC0170
             IF cl_null(l_oeb.oeb14t) THEN
                LET l_oeb.oeb14t =0
             END IF
             IF cl_null(l_oeb.oeb14) THEN
                LET l_oeb.oeb14 =0
             END IF
             LET l_oeb.oeb05_fac='1'
             LET l_oeb.oeb12    ='0'
             LET l_oeb.oeb13    ='0'
             LET l_oeb.oeb37    ='0'          #FUN-AB0061
             LET l_oeb.oeb23    ='0'
             LET l_oeb.oeb24    ='0'
             LET l_oeb.oeb25    ='0'
             LET l_oeb.oeb26    ='0'
             LET l_oeb.oeb70    ='N'
             LET l_oeb.oebplant = g_plant #FUN-980010 add
             LET l_oeb.oeblegal = g_legal #FUN-980010 add
             LET l_oeb.oeb44 = '1' #FUN-9C0083
             LET l_oeb.oeb47 = 0 #FUN-9C0083
             LET l_oeb.oeb48 = '1' #FUN-9C0083
             IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF   #MOD-A10123
            #MOD-AC0170 Begin---
             LET l_oeb.oeb04 = 'MISC'
             LET l_oeb.oeb12 = 1
             LET l_oeb.oeb917= 1
            #MOD-AC0170 End-----
            #TQC-B10066 Begin---
             LET l_oeb.oeb70d= ''
             LET l_oeb.oeb72 = ''
             LET l_oeb.oeb902= ''
             LET l_oeb.oeb30 = ''
             LET l_oeb.oebud13 = ''
             LET l_oeb.oebud14 = ''
             LET l_oeb.oebud15 = ''
             LET l_oeb.oeb15 = ''
             LET l_oeb.oeb16 = ''
             SELECT ima02 INTO l_oeb.oeb06 FROM ima_file
              WHERE ima01=l_oeb.oeb04
            #TQC-B10066 End-----
             INSERT INTO oeb_file VALUES (l_oeb.*)
             IF STATUS OR SQLCA.SQLCODE THEN
                CALL cl_err3("ins","oeb_file",l_oeb.oeb01,"",SQLCA.sqlcode,"","",1)
                CONTINUE FOREACH
             END IF
          END FOREACH
       END IF
    ELSE
#抓出此訂單對應的已經審核的現金折扣單資料，放入返利單身
       LET l_sql ="SELECT * FROM tqw_file ",
                  " WHERE tqw23 ='",g_oea.oea01,"'",
                  "   AND tqw22 ='",g_oea.oea12,"'",
                  "   AND tqw21 ='1'",
                  "   AND tqw20 ='1'",
                  "   AND tqw10 ='3'"
       PREPARE t400_cash_pb3 FROM l_sql
       DECLARE t400_cash_cs3 CURSOR FOR t400_cash_pb3
       FOREACH t400_cash_cs3 INTO l_tqw.*
         LET l_oeb.oeb1003 ='2'
         LET l_oeb.oeb1012 ='N'
         LET l_oeb.oeb01   =g_oea.oea01
        #SELECT MAX(oeb03) INTO l_oeb.oeb03 FROM oeb_file   #TQC-AC0163 By shi
         SELECT MAX(oeb03)+1 INTO l_oeb.oeb03 FROM oeb_file #TQC-AC0163 By shi
          WHERE oeb01 =g_oea.oea01 AND oeb03 >= 9001
         IF l_oeb.oeb03  IS NULL THEN
            LET l_oeb.oeb03 =9001
         END IF
         LET l_oeb.oeb1007 =l_tqw.tqw01
         LET l_oeb.oeb1008 =l_tqw.tqw11
         LET l_oeb.oeb1009 =l_tqw.tqw12
         LET l_oeb.oeb1010 =l_tqw.tqw14
         LET l_oeb.oeb1001 =l_tqw.tqw15
         IF l_oeb.oeb1001 ='Y' THEN
            LET l_oeb.oeb14t =l_tqw.tqw07
           #LET l_oeb.oeb14  =l_tqw.tqw07/(1+l_oeb.oeb1009)     #MOD-AC0170
            LET l_oeb.oeb14  =l_tqw.tqw07/(1+l_oeb.oeb1009/100) #MOD-AC0170
         ELSE
            LET l_oeb.oeb14  =l_tqw.tqw07
           #LET l_oeb.oeb14t =l_tqw.tqw07/(1+l_oeb.oeb1009)     #MOD-AC0170
            LET l_oeb.oeb14t =l_tqw.tqw07*(1+l_oeb.oeb1009/100) #MOD-AC0170
         END IF
         IF cl_null(l_oeb.oeb14t) THEN
            LET l_oeb.oeb14t =0
         END IF
         IF cl_null(l_oeb.oeb14) THEN
            LET l_oeb.oeb14 =0
         END IF
         LET l_oeb.oeb05_fac='1'
         LET l_oeb.oeb12    ='0'
         LET l_oeb.oeb13    ='0'
         LET l_oeb.oeb37    ='0'          #FUN-AB0061
         LET l_oeb.oeb23    ='0'
         LET l_oeb.oeb24    ='0'
         LET l_oeb.oeb25    ='0'
         LET l_oeb.oeb26    ='0'
         LET l_oeb.oeb70    ='N'
         LET l_oeb.oebplant = g_plant #FUN-980010 add
         LET l_oeb.oeblegal = g_legal #FUN-980010 add
         LET l_oeb.oeb44 = '1' #FUN-9C0083
         LET l_oeb.oeb47 = 0 #FUN-9C0083
         LET l_oeb.oeb48 = '1' #FUN-9C0083
         IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF   #MOD-A10123
        #MOD-AC0170 Begin---
         LET l_oeb.oeb04 = 'MISC'
         LET l_oeb.oeb12 = 1
         LET l_oeb.oeb917= 1
        #MOD-AC0170 End-----
        #TQC-B10066 Begin---
         LET l_oeb.oeb70d= ''
         LET l_oeb.oeb72 = ''
         LET l_oeb.oeb902= ''
         LET l_oeb.oeb30 = ''
         LET l_oeb.oebud13 = ''
         LET l_oeb.oebud14 = ''
         LET l_oeb.oebud15 = ''
         LET l_oeb.oeb15 = ''
         LET l_oeb.oeb16 = ''
         SELECT ima02 INTO l_oeb.oeb06 FROM ima_file
          WHERE ima01=l_oeb.oeb04
        #TQC-B10066 End-----
         INSERT INTO oeb_file VALUES (l_oeb.*)
         IF STATUS OR SQLCA.SQLCODE THEN
            CALL cl_err3("ins","oeb_file",l_oeb.oeb01,"",SQLCA.sqlcode,"","",1)
            CONTINUE FOREACH
         END IF
       END FOREACH
    END IF
    COMMIT WORK  #TQC-980029
    
    BEGIN WORK        #TQC-AC0030 
    
#現返條件中明折明扣的累計部分
    LET l_sql ="SELECT * FROM tqr_file ",
               " WHERE tqr06 ='2'",
               "   AND tqr01  = '",g_oea.oea12,"'"
    PREPARE t400_cash_pb4 FROM l_sql
    DECLARE t400_cash_cs4 CURSOR FOR t400_cash_pb4
    FOREACH t400_cash_cs4 INTO l_tqr.*
       IF l_tqr.tqr02 ='1' THEN      #按月返
#先檢查上月起始日期是否大于現返條件的截止日期，或者上月截止日期是否小于現返條件的起始日期
          LET l_last_month =MONTH(g_today) -1
          IF l_last_month =0 THEN
             LET l_last_month =12
             LET l_last_year =YEAR(g_today) -1
          ELSE
             LET l_last_year =YEAR(g_today)
          END IF
         #TQC-AC0163 Begin--- By shi
         #LET l_last_bg =l_last_year,"/",l_last_month,"/","01"
         #LET l_last_bg_day =l_last_bg USING "YYMMDD"
         #LET l_last_ed =l_last_year,"/",l_last_month,"/",cl_days(l_last_year,l_last_month)
         #LET l_last_ed_day =l_last_ed USING "YYMMDD"
          LET l_last_bg_day = MDY(l_last_month,1,l_last_year)
          LET l_last_ed_day = MDY(l_last_month,cl_days(l_last_year,l_last_month),l_last_year)
         #TQC-AC0163 End-----
          IF l_last_bg_day > l_tqr.tqr08 OR l_last_ed_day < l_tqr.tqr07 THEN
             CONTINUE FOREACH
          END IF
#本月的起始日期和截止日期
         #TQC-AC0163 Begin--- By shi
         #LET l_bg =YEAR(g_today),"/",MONTH(g_today),"/","01"
         #LET l_bg_day =l_bg USING "YYMMDD"
         #LET l_ed =YEAR(g_today),"/",MONTH(g_today),"/",cl_days(YEAR(g_today),MONTH(g_today))
         #LET l_ed_day =l_ed USING "YYMMDD"
          LET l_bg_day = MDY(MONTH(g_today),1,YEAR(g_today))
          LET l_ed_day = MDY(MONTH(g_today),cl_days(YEAR(g_today),MONTH(g_today)),YEAR(g_today))
         #TQC-AC0163 End-----
#先檢查此合同本月是否已經對上月進行累計返過
          SELECT COUNT(*) INTO l_n FROM tqw_file,tqv_file
           WHERE tqw02 BETWEEN l_bg_day AND l_ed_day
             AND tqw22 =g_oea.oea12
             AND tqw21 ='2'
             AND tqw10 !='5'
             AND tqw01 =tqv01
             AND tqv03 =l_tqr.tqr09
          IF l_n =0 THEN #沒有對上月累計返利，則取得出貨統計的起始截止區間，作為累計返的累計區間
             IF l_last_bg_day < l_tqr.tqr07 THEN
                LET l_last_bg_day =l_tqr.tqr07
             END IF
             IF l_last_ed_day > l_tqr.tqr08 THEN
                LET l_last_ed_day =l_tqr.tqr08
             END IF
          ELSE
#抓出此合同條件相應的已經審核的且未返完的累計返現金折扣單資料，放入返利單身
             LET l_sql ="SELECT * FROM tqw_file,tqv_file ",
                        " WHERE tqw22 ='",g_oea.oea12,"'",
                        "   AND tqw21 ='2'",
                        "   AND tqw20 ='1'",
                        "   AND tqw10 ='3'",
                        "   AND tqw01 =tqv01",
                        "   AND tqv03 ='",l_tqr.tqr09,"'",
                        "   AND tqw07 -tqw08 >0"
             PREPARE t400_cash_pb5 FROM l_sql
             DECLARE t400_cash_cs5 CURSOR FOR t400_cash_pb5
             FOREACH t400_cash_cs5 INTO l_tqw.*
                LET l_oeb.oeb1003 ='2'
                LET l_oeb.oeb1012 ='N'
                LET l_oeb.oeb01   =g_oea.oea01
               #SELECT MAX(oeb03) INTO l_oeb.oeb03 FROM oeb_file   #TQC-AC0163 By shi
                SELECT MAX(oeb03)+1 INTO l_oeb.oeb03 FROM oeb_file #TQC-AC0163 By shi
                 WHERE oeb01 =g_oea.oea01 AND oeb03 >= 9001
                IF l_oeb.oeb03 IS NULL THEN
                   LET l_oeb.oeb03 =9001
                END IF
                LET l_oeb.oeb1007 =l_tqw.tqw01
                LET l_oeb.oeb1008 =l_tqw.tqw11
                LET l_oeb.oeb1009 =l_tqw.tqw12
                LET l_oeb.oeb1010 =l_tqw.tqw14
                LET l_oeb.oeb1001 =l_tqw.tqw15
                IF l_oeb.oeb1001 ='Y' THEN
                   LET l_oeb.oeb14t =l_tqw.tqw07 - l_tqw.tqw08
                  #LET l_oeb.oeb14  =(l_tqw.tqw07 - l_tqw.tqw08)/(1+l_oeb.oeb1009)     #MOD-AC0170
                   LET l_oeb.oeb14  =(l_tqw.tqw07 - l_tqw.tqw08)/(1+l_oeb.oeb1009/100) #MOD-AC0170
                ELSE
                   LET l_oeb.oeb14  =l_tqw.tqw07 - l_tqw.tqw08
                  #LET l_oeb.oeb14t =(l_tqw.tqw07 - l_tqw.tqw08)/(1+l_oeb.oeb1009)     #MOD-AC0170
                   LET l_oeb.oeb14t =(l_tqw.tqw07 - l_tqw.tqw08)*(1+l_oeb.oeb1009/100) #MOD-AC0170
                END IF
                IF cl_null(l_oeb.oeb14t) THEN
                   LET l_oeb.oeb14t =0
                END IF
                IF cl_null(l_oeb.oeb14) THEN
                   LET l_oeb.oeb14 =0
                END IF
                LET l_oeb.oeb05_fac='1'
                LET l_oeb.oeb12    ='0'
                LET l_oeb.oeb13    ='0'
                LET l_oeb.oeb37    ='0'          #FUN-AB0061
                LET l_oeb.oeb23    ='0'
                LET l_oeb.oeb24    ='0'
                LET l_oeb.oeb25    ='0'
                LET l_oeb.oeb26    ='0'
                LET l_oeb.oeb70    ='N'
                LET l_oeb.oebplant = g_plant #FUN-980010 add
                LET l_oeb.oeblegal = g_legal #FUN-980010 add
                LET l_oeb.oeb44 = '1' #FUN-9C0083
                LET l_oeb.oeb47 = 0 #FUN-9C0083
                LET l_oeb.oeb48 = '1' #FUN-9C0083
                IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF   #MOD-A10123
               #MOD-AC0170 Begin---
                LET l_oeb.oeb04 = 'MISC'
                LET l_oeb.oeb12 = 1
                LET l_oeb.oeb917= 1
               #MOD-AC0170 End-----
               #TQC-B10066 Begin---
                LET l_oeb.oeb70d= ''
                LET l_oeb.oeb72 = ''
                LET l_oeb.oeb902= ''
                LET l_oeb.oeb30 = ''
                LET l_oeb.oebud13 = ''
                LET l_oeb.oebud14 = ''
                LET l_oeb.oebud15 = ''
                LET l_oeb.oeb15 = ''
                LET l_oeb.oeb16 = ''
                SELECT ima02 INTO l_oeb.oeb06 FROM ima_file
                 WHERE ima01=l_oeb.oeb04
               #TQC-B10066 End-----
                INSERT INTO oeb_file VALUES (l_oeb.*)
                IF STATUS OR SQLCA.SQLCODE THEN
                   CALL cl_err3("ins","oeb_file",l_oeb.oeb01,"",SQLCA.sqlcode,"","",1)
                   CONTINUE FOREACH
                END IF
             END FOREACH
          END IF
       ELSE
          IF l_tqr.tqr02 ='2' THEN  #按季返
#取得當前季度的第一個月和最后一個月
             LET l_month =MONTH(g_today)
             IF l_month >=1 AND l_month <=3 THEN
                LET l_bg_month =1
                LET l_ed_month =3
             END IF
             IF l_month >=4 AND l_month <=6 THEN
                LET l_bg_month =4
                LET l_ed_month =6
             END IF
             IF l_month >=7 AND l_month <=9 THEN
                LET l_bg_month =7
                LET l_ed_month =9
             END IF
             IF l_month >=10 AND l_month <=12 THEN
                LET l_bg_month =10
                LET l_ed_month =12
             END IF
#上一季度的第一個月
             LET l_last_month =l_bg_month -3
             IF l_last_month =-2 THEN
                LET l_last_month =10
                LET l_last_year =YEAR(g_today) -1
             ELSE
                LET l_last_year =YEAR(g_today)
             END IF
            #TQC-AC0163 Begin--- By shi
            #LET l_last_bg =l_last_year,"/",l_last_month,"/","01"
            #LET l_last_bg_day =l_last_bg USING "YYMMDD"   #上一季度的第一天
            #LET l_last_ed =l_last_year,"/",(l_last_month+2),"/",cl_days(l_last_year,l_last_month+2)
            #LET l_last_ed_day =l_last_ed USING "YYMMDD"    #上一季度的最后一天
             LET l_last_bg_day = MDY(l_last_month,1,l_last_year)
             LET l_last_ed_day = MDY((l_last_month+2),cl_days(l_last_year,l_last_month+2),l_last_year)
            #TQC-AC0163 End-----
             IF l_last_bg_day > l_tqr.tqr08 OR l_last_ed_day < l_tqr.tqr07 THEN
                CONTINUE FOREACH
             END IF
#當前季度的第一天和最后一天
            #TQC-AC0163 Begin--- By shi
            #LET l_bg =YEAR(g_today),"/",l_bg_month,"/","01"
            #LET l_bg_day =l_bg USING "YYMMDD"
            #LET l_ed =YEAR(g_today),"/",l_ed_month,"/",cl_days(YEAR(g_today),l_ed_month)
            #LET l_ed_day =l_ed USING "YYMMDD"
             LET l_bg_day = MDY(l_bg_month,1,YEAR(g_today))
             LET l_ed_day = MDY(l_ed_month,cl_days(YEAR(g_today),l_ed_month),YEAR(g_today))
            #TQC-AC0163 End-----
             SELECT COUNT(*) INTO l_n FROM tqw_file,tqv_file
              WHERE tqw02 BETWEEN l_bg_day AND l_ed_day
                AND tqw22 =g_oea.oea12
                AND tqw21 ='2'
                AND tqw10 !='5'
                AND tqw01 =tqv01
                AND tqv03 =l_tqr.tqr09
             IF l_n =0 THEN
                IF l_last_bg_day < l_tqr.tqr07 THEN
                   LET l_last_bg_day =l_tqr.tqr07
                END IF
                IF l_last_ed_day > l_tqr.tqr08 THEN
                   LET l_last_ed_day =l_tqr.tqr08
                END IF
             ELSE
                LET l_sql ="SELECT * FROM tqw_file,tqv_file ",
                           " WHERE tqw22 ='",g_oea.oea12,"'",
                           "   AND tqw21 ='2'",
                           "   AND tqw20 ='1'",
                           "   AND tqw10 ='3'",
                           "   AND tqw01 =tqv01",
                           "   AND tqv03 ='",l_tqr.tqr09,"'",
                           "   AND tqw07 -tqw08 >0"
                PREPARE t400_cash_pb6 FROM l_sql
                DECLARE t400_cash_cs6 CURSOR FOR t400_cash_pb6
                FOREACH t400_cash_cs6 INTO l_tqw.*
                   LET l_oeb.oeb1003 ='2'
                   LET l_oeb.oeb1012 ='N'
                   LET l_oeb.oeb01   =g_oea.oea01
                  #SELECT MAX(oeb03) INTO l_oeb.oeb03 FROM oeb_file   #TQC-AC0163 By shi
                   SELECT MAX(oeb03)+1 INTO l_oeb.oeb03 FROM oeb_file #TQC-AC0163 By shi
                    WHERE oeb01 =g_oea.oea01 AND oeb03 >= 9001
                   IF l_oeb.oeb03 IS NULL THEN
                      LET l_oeb.oeb03 =9001
                   END IF
                   LET l_oeb.oeb1007 =l_tqw.tqw01
                   LET l_oeb.oeb1008 =l_tqw.tqw11
                   LET l_oeb.oeb1009 =l_tqw.tqw12
                   LET l_oeb.oeb1010 =l_tqw.tqw14
                   LET l_oeb.oeb1001 =l_tqw.tqw15
                   IF l_oeb.oeb1001 ='Y' THEN
                      LET l_oeb.oeb14t =l_tqw.tqw07 - l_tqw.tqw08
                     #LET l_oeb.oeb14  =(l_tqw.tqw07 - l_tqw.tqw08)/(1+l_oeb.oeb1009)     #MOD-AC0170
                      LET l_oeb.oeb14  =(l_tqw.tqw07 - l_tqw.tqw08)/(1+l_oeb.oeb1009/100) #MOD-AC0170
                   ELSE
                      LET l_oeb.oeb14  =l_tqw.tqw07 - l_tqw.tqw08
                     #LET l_oeb.oeb14t =(l_tqw.tqw07 - l_tqw.tqw08)/(1+l_oeb.oeb1009)      #MOD-AC0170
                      LET l_oeb.oeb14t =(l_tqw.tqw07 - l_tqw.tqw08)*(1+l_oeb.oeb1009/100)  #MOD-AC0170
                   END IF
                   IF cl_null(l_oeb.oeb14t) THEN
                      LET l_oeb.oeb14t =0
                   END IF
                   IF cl_null(l_oeb.oeb14) THEN
                      LET l_oeb.oeb14 =0
                   END IF
                   LET l_oeb.oeb05_fac='1'
                   LET l_oeb.oeb12    ='0'
                   LET l_oeb.oeb13    ='0'
                   LET l_oeb.oeb37    ='0'          #FUN-AB0061
                   LET l_oeb.oeb23    ='0'
                   LET l_oeb.oeb24    ='0'
                   LET l_oeb.oeb25    ='0'
                   LET l_oeb.oeb26    ='0'
                   LET l_oeb.oeb70    ='N'
                   LET l_oeb.oebplant = g_plant #FUN-980010 add
                   LET l_oeb.oeblegal = g_legal #FUN-980010 add
                   LET l_oeb.oeb44 = '1' #FUN-9C0083
                   LET l_oeb.oeb47 = 0 #FUN-9C0083
                   LET l_oeb.oeb48 = '1' #FUN-9C0083
                   IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF   #MOD-A10123
                  #MOD-AC0170 Begin---
                   LET l_oeb.oeb04 = 'MISC'
                   LET l_oeb.oeb12 = 1
                   LET l_oeb.oeb917= 1
                  #MOD-AC0170 End-----
                  #TQC-B10066 Begin---
                   LET l_oeb.oeb70d= ''
                   LET l_oeb.oeb72 = ''
                   LET l_oeb.oeb902= ''
                   LET l_oeb.oeb30 = ''
                   LET l_oeb.oebud13 = ''
                   LET l_oeb.oebud14 = ''
                   LET l_oeb.oebud15 = ''
                   LET l_oeb.oeb15 = ''
                   LET l_oeb.oeb16 = ''
                   SELECT ima02 INTO l_oeb.oeb06 FROM ima_file
                    WHERE ima01=l_oeb.oeb04
                  #TQC-B10066 End-----
                   INSERT INTO oeb_file VALUES (l_oeb.*)
                   IF STATUS OR SQLCA.SQLCODE THEN
                      CALL cl_err3("ins","oeb_file",l_oeb.oeb01,"",SQLCA.sqlcode,"","",1)
                      CONTINUE FOREACH
                   END IF
                END FOREACH
             END IF
          ELSE
             IF l_tqr.tqr02 ='3' THEN  #按年返
#取得當年的第一個月和最后一個月
                LET l_bg_month =1
                LET l_ed_month =12
#去年的第一天和最后一天
               #TQC-AC0163 Begin--- By shi
               #LET l_last_bg =YEAR(g_today)-1,"/","01","/","01"
               #LET l_last_bg_day =l_last_bg USING "YYMMDD"
               #LET l_last_ed =YEAR(g_today)-1,"/","12","/","31"
               #LET l_last_ed_day =l_last_ed USING "YYMMDD"
                LET l_last_bg_day = MDY(1,1,YEAR(g_today)-1)
                LET l_last_ed_day = MDY(12,31,YEAR(g_today)-1)
               #TQC-AC0163 End-----
                IF l_last_bg_day > l_tqr.tqr08 OR l_last_ed_day < l_tqr.tqr07 THEN
                   CONTINUE FOREACH
                END IF
#今年的第一天和最后一天
               #TQC-AC0163 Begin--- By shi
               #LET l_bg =YEAR(g_today),"/","01","/","01"
               #LET l_bg_day =l_bg USING "YYMMDD"
               #LET l_ed =YEAR(g_today),"/","12","/","31"
               #LET l_ed_day =l_ed USING "YYMMDD"
                LET l_bg_day = MDY(1,1,YEAR(g_today))
                LET l_ed_day = MDY(12,31,YEAR(g_today))
               #TQC-AC0163 End-----
                SELECT COUNT(*) INTO l_n FROM tqw_file,tqv_file
                 WHERE tqw02 BETWEEN l_bg_day AND l_ed_day
                   AND tqw22 =g_oea.oea12
                   AND tqw21 ='2'
                   AND tqw10 !='5'
                   AND tqw01 =tqv01
                   AND tqv03 =l_tqr.tqr09
                IF l_n =0 THEN
                   IF l_last_bg_day < l_tqr.tqr07 THEN
                      LET l_last_bg_day =l_tqr.tqr07
                   END IF
                   IF l_last_ed_day > l_tqr.tqr08 THEN
                      LET l_last_ed_day =l_tqr.tqr08
                   END IF
                ELSE
                   LET l_sql ="SELECT * FROM tqw_file,tqv_file ",
                              " WHERE tqw22 ='",g_oea.oea12,"'",
                              "   AND tqw21 ='2'",
                              "   AND tqw20 ='1'",
                              "   AND tqw10 ='3'",
                              "   AND tqw01 =tqv01",
                              "   AND tqv03 ='",l_tqr.tqr09,"'",
                              "   AND tqw07 -tqw08 >0"
                   PREPARE t400_cash_pb7 FROM l_sql
                   DECLARE t400_cash_cs7 CURSOR FOR t400_cash_pb7
                   FOREACH t400_cash_cs7 INTO l_tqw.*
                      LET l_oeb.oeb1003 ='2'
                      LET l_oeb.oeb1012 ='N'
                      LET l_oeb.oeb01   =g_oea.oea01
                     #SELECT MAX(oeb03) INTO l_oeb.oeb03 FROM oeb_file   #TQC-AC0163 By shi
                      SELECT MAX(oeb03)+1 INTO l_oeb.oeb03 FROM oeb_file #TQC-AC0163 By shi
                       WHERE oeb01 =g_oea.oea01 AND oeb03 >= 9001
                      IF l_oeb.oeb03 IS NULL THEN
                         LET l_oeb.oeb03 =9001
                      END IF
                      LET l_oeb.oeb1007 =l_tqw.tqw01
                      LET l_oeb.oeb1008 =l_tqw.tqw11
                      LET l_oeb.oeb1009 =l_tqw.tqw12
                      LET l_oeb.oeb1010 =l_tqw.tqw14
                      LET l_oeb.oeb1001 =l_tqw.tqw15
                      IF l_oeb.oeb1001 ='Y' THEN
                         LET l_oeb.oeb14t =l_tqw.tqw07 - l_tqw.tqw08
                        #LET l_oeb.oeb14  =(l_tqw.tqw07 - l_tqw.tqw08)/(1+l_oeb.oeb1009)     #MOD-AC0170
                         LET l_oeb.oeb14  =(l_tqw.tqw07 - l_tqw.tqw08)/(1+l_oeb.oeb1009/100) #MOD-AC0170
                      ELSE
                         LET l_oeb.oeb14  =l_tqw.tqw07 - l_tqw.tqw08
                        #LET l_oeb.oeb14t =(l_tqw.tqw07 - l_tqw.tqw08)/(1+l_oeb.oeb1009)     #MOD-AC0170
                         LET l_oeb.oeb14t =(l_tqw.tqw07 - l_tqw.tqw08)*(1+l_oeb.oeb1009/100) #MOD-AC0170
                      END IF
                      IF cl_null(l_oeb.oeb14t) THEN
                         LET l_oeb.oeb14t =0
                      END IF
                      IF cl_null(l_oeb.oeb14) THEN
                         LET l_oeb.oeb14 =0
                      END IF
                      LET l_oeb.oeb05_fac='1'
                      LET l_oeb.oeb12    ='0'
                      LET l_oeb.oeb13    ='0'
                      LET l_oeb.oeb37    ='0'          #FUN-AB0061
                      LET l_oeb.oeb23    ='0'
                      LET l_oeb.oeb24    ='0'
                      LET l_oeb.oeb25    ='0'
                      LET l_oeb.oeb26    ='0'
                      LET l_oeb.oeb70    ='N'
                      LET l_oeb.oebplant = g_plant #FUN-980010 add
                      LET l_oeb.oeblegal = g_legal #FUN-980010 add
                      LET l_oeb.oeb44 = '1' #FUN-9C0083
                      LET l_oeb.oeb47 = 0 #FUN-9C0083
                      LET l_oeb.oeb48 = '1' #FUN-9C0083
                      IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF   #MOD-A10123
                     #MOD-AC0170 Begin---
                      LET l_oeb.oeb04 = 'MISC'
                      LET l_oeb.oeb12 = 1
                      LET l_oeb.oeb917= 1
                     #MOD-AC0170 End-----
                     #TQC-B10066 Begin---
                      LET l_oeb.oeb70d= ''
                      LET l_oeb.oeb72 = ''
                      LET l_oeb.oeb902= ''
                      LET l_oeb.oeb30 = ''
                      LET l_oeb.oebud13 = ''
                      LET l_oeb.oebud14 = ''
                      LET l_oeb.oebud15 = ''
                      LET l_oeb.oeb15 = ''
                      LET l_oeb.oeb16 = ''
                      SELECT ima02 INTO l_oeb.oeb06 FROM ima_file
                       WHERE ima01=l_oeb.oeb04
                     #TQC-B10066 End-----
                      INSERT INTO oeb_file VALUES (l_oeb.*)
                      IF STATUS OR SQLCA.SQLCODE THEN
                         CALL cl_err3("ins","oeb_file",l_oeb.oeb01,"",SQLCA.sqlcode,"","",1)
                         CONTINUE FOREACH
                      END IF
                   END FOREACH
                END IF
             ELSE
                IF l_tqr.tqr02 ='4' THEN  #按起止期間返
                   SELECT COUNT(*) INTO l_n FROM tqw_file,tqv_file
                    WHERE tqw02 > l_tqr.tqr08
                      AND tqw22 =g_oea.oea12
                      AND tqw21 ='2'
                      AND tqw10 !='5'
                      AND tqw01 =tqv01
                      AND tqv03 =l_tqr.tqr09
                   IF l_n =0 THEN
                      LET l_last_bg_day =l_tqr.tqr07
                      LET l_last_ed_day =l_tqr.tqr08
                   ELSE
                      LET l_sql ="SELECT * FROM tqw_file,tqv_file ",
                                 " WHERE tqw22 ='",g_oea.oea12,"'",
                                 "   AND tqw21 ='2'",
                                 "   AND tqw20 ='1'",
                                 "   AND tqw10 ='3'",
                                 "   AND tqw01 =tqv01",
                                 "   AND tqv03 ='",l_tqr.tqr09,"'",
                                 "   AND tqw07 -tqw08 >0"
                      PREPARE t400_cash_pb8 FROM l_sql
                      DECLARE t400_cash_cs8 CURSOR FOR t400_cash_pb8
                      FOREACH t400_cash_cs8 INTO l_tqw.*
                         LET l_oeb.oeb1003 ='2'
                         LET l_oeb.oeb1012 ='N'
                         LET l_oeb.oeb01   =g_oea.oea01
                        #SELECT MAX(oeb03) INTO l_oeb.oeb03 FROM oeb_file   #TQC-AC0163 By shi
                         SELECT MAX(oeb03)+1 INTO l_oeb.oeb03 FROM oeb_file #TQC-AC0163 By shi
                          WHERE oeb01 =g_oea.oea01 AND oeb03 >= 9001
                         IF l_oeb.oeb03 IS NULL THEN
                            LET l_oeb.oeb03 =9001
                         END IF
                         LET l_oeb.oeb1007 =l_tqw.tqw01
                         LET l_oeb.oeb1008 =l_tqw.tqw11
                         LET l_oeb.oeb1009 =l_tqw.tqw12
                         LET l_oeb.oeb1010 =l_tqw.tqw14
                         LET l_oeb.oeb1001 =l_tqw.tqw15
                         IF l_oeb.oeb1001 ='Y' THEN
                            LET l_oeb.oeb14t =l_tqw.tqw07 - l_tqw.tqw08
                           #LET l_oeb.oeb14  =(l_tqw.tqw07 - l_tqw.tqw08)/(1+l_oeb.oeb1009)     #MOD-AC0170
                            LET l_oeb.oeb14  =(l_tqw.tqw07 - l_tqw.tqw08)/(1+l_oeb.oeb1009/100) #MOD-AC0170
                         ELSE
                            LET l_oeb.oeb14  =l_tqw.tqw07 - l_tqw.tqw08
                           #LET l_oeb.oeb14t =(l_tqw.tqw07 - l_tqw.tqw08)/(1+l_oeb.oeb1009)     #MOD-AC0170
                            LET l_oeb.oeb14t =(l_tqw.tqw07 - l_tqw.tqw08)*(1+l_oeb.oeb1009/100) #MOD-AC0170
                         END IF
                         IF cl_null(l_oeb.oeb14t) THEN
                            LET l_oeb.oeb14t =0
                         END IF
                         IF cl_null(l_oeb.oeb14) THEN
                            LET l_oeb.oeb14 =0
                         END IF
                         LET l_oeb.oeb05_fac='1'
                         LET l_oeb.oeb12    ='0'
                         LET l_oeb.oeb13    ='0'
                         LET l_oeb.oeb37    ='0'          #FUN-AB0061
                         LET l_oeb.oeb23    ='0'
                         LET l_oeb.oeb24    ='0'
                         LET l_oeb.oeb25    ='0'
                         LET l_oeb.oeb26    ='0'
                         LET l_oeb.oeb70    ='N'
                         LET l_oeb.oebplant = g_plant #FUN-980010 add
                         LET l_oeb.oeblegal = g_legal #FUN-980010 add
                         LET l_oeb.oeb44 = '1' #FUN-9C0083
                         LET l_oeb.oeb47 = 0 #FUN-9C0083
                         LET l_oeb.oeb48 = '1' #FUN-9C0083
                         IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF   #MOD-A10123
                        #MOD-AC0170 Begin---
                         LET l_oeb.oeb04 = 'MISC'
                         LET l_oeb.oeb12 = 1
                         LET l_oeb.oeb917= 1
                        #MOD-AC0170 End-----
                        #TQC-B10066 Begin---
                         LET l_oeb.oeb70d= ''
                         LET l_oeb.oeb72 = ''
                         LET l_oeb.oeb902= ''
                         LET l_oeb.oeb30 = ''
                         LET l_oeb.oebud13 = ''
                         LET l_oeb.oebud14 = ''
                         LET l_oeb.oebud15 = ''
                         LET l_oeb.oeb15 = ''
                         LET l_oeb.oeb16 = ''
                         SELECT ima02 INTO l_oeb.oeb06 FROM ima_file
                          WHERE ima01=l_oeb.oeb04
                        #TQC-B10066 End-----
                         INSERT INTO oeb_file VALUES (l_oeb.*)
                         IF STATUS OR SQLCA.SQLCODE THEN
                            CALL cl_err3("ins","oeb_file",l_oeb.oeb01,"",SQLCA.sqlcode,"","",1)
                            CONTINUE FOREACH
                         END IF
                      END FOREACH
                   END IF
                END IF
             END IF
          END IF
       END IF

#抓出上月客戶合同累計出貨金額
       SELECT SUM(ogb14),SUM(ogb14t) INTO l_ogb14_sum,l_ogb14t_sum
        FROM ogb_file,oga_file,oea_file                #TQC-960137 add oea_file
       WHERE oga01 =ogb01
         AND oga00 MATCHES '[12456]'
         AND oga09 MATCHES '[23468]'
         AND oga02 BETWEEN l_last_bg_day AND l_last_ed_day
         AND ogapost ='Y'
         AND ogaconf ='Y'
         AND oea03 =g_oea.oea03
         AND ogb31 =oea01
         AND oea12 =g_oea.oea12
#抓出上月客戶合同累計銷退金額
       SELECT SUM(ohb14),SUM(ohb14t) INTO l_ohb14_sum,l_ohb14t_sum
         FROM ohb_file,oha_file,oea_file
        WHERE ohb01 =oha01
          AND oha02 BETWEEN l_last_bg_day AND l_last_ed_day
          AND ohaconf ='Y'
          AND ohapost ='Y'
          AND oha03 =g_oea.oea03
          AND ohb33 =oea01
          AND oea12 =g_oea.oea12
#取得對應的合同折扣基准是未稅還是含稅金額
#      BEGIN WORK #TQC-980029        #TQC-AC0030 mark
       SELECT tqp12 INTO l_tqp12 FROM tqp_file WHERE tqp01 =g_oea.oea12
       IF l_tqp12 ='1' THEN     #含稅
          IF (l_ogb14t_sum -l_ohb14t_sum >= l_tqr.tqr03) AND (l_ogb14t_sum-l_ohb14t_sum <=l_tqr.tqr04) THEN
             SELECT oaz80 INTO l_tqw.tqw01 FROM oaz_file
#TQC-AC0031 --begin--
             IF cl_null(l_tqw.tqw01) THEN 
                CALL cl_err('','axm-268',0)
                ROLLBACK WORK 
                RETURN 
             END IF 
#TQC-AC0031 --end--               
            #CALL s_auto_assign_no("axm",l_tqw.tqw01,g_today,"04","tqw_file","tqw01","","","") #FUN-AC0012
             CALL s_auto_assign_no("atm",l_tqw.tqw01,g_today,"U5","tqw_file","tqw01","","","") #FUN-AC0012
                  RETURNING li_result,l_tqw.tqw01
             IF (NOT li_result) THEN
                CONTINUE FOREACH
             END IF
             LET l_tqw.tqw02 =g_today
             LET l_tqw.tqw03 =g_grup
             LET l_tqw.tqw04 =g_user
             LET l_tqw.tqw05 =g_oea.oea03
#            LET l_tqw.tqw07 =l_tqr.tqr05*(l_ogb14t_sum -l_ohb14t_sum)            #TQC-AC0028
             LET l_tqw.tqw07 =l_tqr.tqr05/100*(l_ogb14t_sum -l_ohb14t_sum)            #TQC-AC0028
             IF cl_null(l_tqw.tqw07) THEN
                LET l_tqw.tqw07 =0
             END IF
             LET l_tqw.tqw08 =0
             LET l_tqw.tqw081=0
             LET l_tqw.tqw10 ='3'
             LET l_tqw.tqw11 =g_oea.oea21
             LET l_tqw.tqw12 =g_oea.oea211
             LET l_tqw.tqw13 =g_oea.oea212
             LET l_tqw.tqw14 ='Y'
             LET l_tqw.tqw15 =l_tqr.tqr09
             LET l_tqw.tqw17 =g_oea.oea23
             LET l_tqw.tqw18 =g_oea.oea24
             LET l_tqw.tqw20 ='1'
             LET l_tqw.tqw21 ='2'
             LET l_tqw.tqw22 =l_tqr.tqr01
             LET l_tqw.tqw23 =g_oea.oea01
             LET l_tqw.tqwplant = g_plant #FUN-980010 add
             LET l_tqw.tqwlegal = g_legal #FUN-980010 add

             INSERT INTO tqw_file VALUES (l_tqw.*)
             IF STATUS OR SQLCA.SQLCODE THEN
                CALL cl_err3("ins","tqw_file",l_tqw.tqw01,"",SQLCA.sqlcode,"","",1)
                CONTINUE FOREACH
             END IF

             #insert tqv_file
             LET l_tqv.tqv01 =l_tqw.tqw01
             LET l_tqv.tqv02 ='1'
             LET l_tqv.tqv03 =l_tqr.tqr09
             LET l_tqv.tqv05 =l_tqw.tqw07
             LET l_tqv.tqv06 ='N'
             LET l_tqv.tqvplant = g_plant #FUN-980010 add
             LET l_tqv.tqvlegal = g_legal #FUN-980010 add

             INSERT INTO tqv_file VALUES (l_tqv.*)
             IF STATUS OR SQLCA.SQLCODE THEN
                CALL cl_err3("ins","tqv_file",l_tqv.tqv01,"",SQLCA.sqlcode,"","",1)
                CONTINUE FOREACH
             END IF

             #insert oeb_file(return benfit)
             LET l_oeb.oeb1003 ='2'
             LET l_oeb.oeb1012 ='N'
             LET l_oeb.oeb01   =g_oea.oea01
            #SELECT MAX(oeb03) INTO l_oeb.oeb03 FROM oeb_file   #TQC-AC0163 By shi
             SELECT MAX(oeb03)+1 INTO l_oeb.oeb03 FROM oeb_file #TQC-AC0163 By shi
              WHERE oeb01 =g_oea.oea01 AND oeb03 >= 9001
             IF l_oeb.oeb03 IS NULL THEN
                LET l_oeb.oeb03 =9001
             END IF
             LET l_oeb.oeb1007 =l_tqw.tqw01
             LET l_oeb.oeb1008 =l_tqw.tqw11
             LET l_oeb.oeb1009 =l_tqw.tqw12
             LET l_oeb.oeb1010 =l_tqw.tqw14
             LET l_oeb.oeb1001 =l_tqw.tqw15
             LET l_oeb.oeb14t  =l_tqw.tqw07
            #LET l_oeb.oeb14   =l_tqw.tqw07/(1+l_oeb.oeb1009)     #MOD-AC0170
             LET l_oeb.oeb14   =l_tqw.tqw07/(1+l_oeb.oeb1009/100) #MOD-AC0170
             IF cl_null(l_oeb.oeb14t) THEN
                LET l_oeb.oeb14t =0
             END IF
             IF cl_null(l_oeb.oeb14) THEN
                LET l_oeb.oeb14 =0
             END IF
             LET l_oeb.oeb05_fac='1'
             LET l_oeb.oeb12    ='0'
             LET l_oeb.oeb13    ='0'
             LET l_oeb.oeb37    ='0'          #FUN-AB0061
             LET l_oeb.oeb23    ='0'
             LET l_oeb.oeb24    ='0'
             LET l_oeb.oeb25    ='0'
             LET l_oeb.oeb26    ='0'
             LET l_oeb.oeb70    ='N'
             LET l_oeb.oebplant = g_plant #FUN-980010
             LET l_oeb.oeblegal = g_legal #FUN-980010
             LET l_oeb.oeb44 = '1' #FUN-9C0083
             LET l_oeb.oeb47 = 0 #FUN-9C0083
             LET l_oeb.oeb48 = '1' #FUN-9C0083
             IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF   #MOD-A10123
            #MOD-AC0170 Begin---
             LET l_oeb.oeb04 = 'MISC'
             LET l_oeb.oeb12 = 1
             LET l_oeb.oeb917= 1
            #MOD-AC0170 End-----
            #TQC-B10066 Begin---
             LET l_oeb.oeb70d= ''
             LET l_oeb.oeb72 = ''
             LET l_oeb.oeb902= ''
             LET l_oeb.oeb30 = ''
             LET l_oeb.oebud13 = ''
             LET l_oeb.oebud14 = ''
             LET l_oeb.oebud15 = ''
             LET l_oeb.oeb15 = ''
             LET l_oeb.oeb16 = ''
             SELECT ima02 INTO l_oeb.oeb06 FROM ima_file
              WHERE ima01=l_oeb.oeb04
            #TQC-B10066 End-----
             INSERT INTO oeb_file VALUES (l_oeb.*)
             IF STATUS OR SQLCA.SQLCODE THEN
                CALL cl_err3("ins","oeb_file",l_oeb.oeb01,"",SQLCA.sqlcode,"","",1)
                CONTINUE FOREACH
             END IF
          END IF
       ELSE   #按未稅
          IF (l_ogb14t_sum -l_ohb14t_sum >= l_tqr.tqr03) AND (l_ogb14t_sum-l_ohb14t_sum <=l_tqr.tqr04) THEN
             SELECT oaz80 INTO l_tqw.tqw01 FROM oaz_file
#TQC-AC0031 --begin--
             IF cl_null(l_tqw.tqw01) THEN 
                CALL cl_err('','axm-268',0)
                ROLLBACK WORK 
                RETURN 
             END IF 
#TQC-AC0031 --end--               
            #CALL s_auto_assign_no("axm",l_tqw.tqw01,g_today,"04","tqw_file","tqw01","","","") #FUN-AC0012
             CALL s_auto_assign_no("atm",l_tqw.tqw01,g_today,"U5","tqw_file","tqw01","","","") #FUN-AC0012
                  RETURNING li_result,l_tqw.tqw01
             IF (NOT li_result) THEN
                CONTINUE FOREACH
             END IF
             LET l_tqw.tqw02 =g_today
             LET l_tqw.tqw03 =g_grup
             LET l_tqw.tqw04 =g_user
             LET l_tqw.tqw05 =g_oea.oea03
#            LET l_tqw.tqw07 =l_tqr.tqr05*(l_ogb14_sum -l_ohb14_sum)         #TQC-AC0028
             LET l_tqw.tqw07 =l_tqr.tqr05/100*(l_ogb14_sum -l_ohb14_sum)         #TQC-AC0028
             IF cl_null(l_tqw.tqw07) THEN
                LET l_tqw.tqw07 =0
             END IF
             LET l_tqw.tqw08 =0
             LET l_tqw.tqw081=0
             LET l_tqw.tqw10 ='3'
             LET l_tqw.tqw11 =g_oea.oea21
             LET l_tqw.tqw12 =g_oea.oea211
             LET l_tqw.tqw13 =g_oea.oea212
             LET l_tqw.tqw14 ='N'
             LET l_tqw.tqw15 =l_tqr.tqr09
             LET l_tqw.tqw17 =g_oea.oea23
             LET l_tqw.tqw18 =g_oea.oea24
             LET l_tqw.tqw20 ='1'
             LET l_tqw.tqw21 ='2'
             LET l_tqw.tqw22 =l_tqr.tqr01
             LET l_tqw.tqw23 =g_oea.oea01
             LET l_tqw.tqwplant = g_plant #FUN-980010 add
             LET l_tqw.tqwlegal = g_legal #FUN-980010 add

             INSERT INTO tqw_file VALUES (l_tqw.*)
             IF STATUS OR SQLCA.SQLCODE THEN
                CALL cl_err3("ins","tqw_file",l_tqw.tqw01,"",SQLCA.sqlcode,"","",1)
                CONTINUE FOREACH
             END IF

             #insert tqv_file
             LET l_tqv.tqv01 =l_tqw.tqw01
             LET l_tqv.tqv02 ='1'
             LET l_tqv.tqv03 =l_tqr.tqr09
             LET l_tqv.tqv05 =l_tqw.tqw07
             LET l_tqv.tqv06 ='N'
             LET l_tqv.tqvplant = g_plant #FUN-980010 add
             LET l_tqv.tqvlegal = g_legal #FUN-980010 add

             INSERT INTO tqv_file VALUES (l_tqv.*)
             IF STATUS OR SQLCA.SQLCODE THEN
                CALL cl_err3("ins","tqv_file",l_tqv.tqv01,"",SQLCA.sqlcode,"","",1)
                CONTINUE FOREACH
             END IF

             #insert oeb_file(return benfit)
             LET l_oeb.oeb1003 ='2'
             LET l_oeb.oeb1012 ='N'
             LET l_oeb.oeb01   =g_oea.oea01
            #SELECT MAX(oeb03) INTO l_oeb.oeb03 FROM oeb_file   #TQC-AC0163 By shi
             SELECT MAX(oeb03)+1 INTO l_oeb.oeb03 FROM oeb_file #TQC-AC0163 By shi
              WHERE oeb01 =g_oea.oea01 AND oeb03 >= 9001
             IF l_oeb.oeb03 IS NULL THEN
                LET l_oeb.oeb03 =9001
             END IF
             LET l_oeb.oeb1007 =l_tqw.tqw01
             LET l_oeb.oeb1008 =l_tqw.tqw11
             LET l_oeb.oeb1009 =l_tqw.tqw12
             LET l_oeb.oeb1010 =l_tqw.tqw14
             LET l_oeb.oeb1001 =l_tqw.tqw15
             LET l_oeb.oeb14   =l_tqw.tqw07
            #LET l_oeb.oeb14t  =l_tqw.tqw07/(1+l_oeb.oeb1009)     #MOD-AC0170
             LET l_oeb.oeb14t  =l_tqw.tqw07*(1+l_oeb.oeb1009/100) #MOD-AC0170
             IF cl_null(l_oeb.oeb14t) THEN
                LET l_oeb.oeb14t =0
             END IF
             IF cl_null(l_oeb.oeb14) THEN
                LET l_oeb.oeb14 =0
             END IF
             LET l_oeb.oeb05_fac='1'
             LET l_oeb.oeb12    ='0'
             LET l_oeb.oeb13    ='0'
             LET l_oeb.oeb37    ='0'          #FUN-AB0061
             LET l_oeb.oeb23    ='0'
             LET l_oeb.oeb24    ='0'
             LET l_oeb.oeb25    ='0'
             LET l_oeb.oeb26    ='0'
             LET l_oeb.oeb70    ='N'
             LET l_oeb.oebplant = g_plant #FUN-980010 add
             LET l_oeb.oeblegal = g_legal #FUN-980010 add
             LET l_oeb.oeb44 = '1' #FUN-9C0083
             LET l_oeb.oeb47 = 0 #FUN-9C0083
             LET l_oeb.oeb48 = '1' #FUN-9C0083
             IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF   #MOD-A10123
            #MOD-AC0170 Begin---
             LET l_oeb.oeb04 = 'MISC'
             LET l_oeb.oeb12 = 1
             LET l_oeb.oeb917= 1
            #MOD-AC0170 End-----
            #TQC-B10066 Begin---
             LET l_oeb.oeb70d= ''
             LET l_oeb.oeb72 = ''
             LET l_oeb.oeb902= ''
             LET l_oeb.oeb30 = ''
             LET l_oeb.oebud13 = ''
             LET l_oeb.oebud14 = ''
             LET l_oeb.oebud15 = ''
             LET l_oeb.oeb15 = ''
             LET l_oeb.oeb16 = ''
             SELECT ima02 INTO l_oeb.oeb06 FROM ima_file
              WHERE ima01=l_oeb.oeb04
            #TQC-B10066 End-----
             INSERT INTO oeb_file VALUES (l_oeb.*)
             IF STATUS OR SQLCA.SQLCODE THEN
                CALL cl_err3("ins","oeb_file",l_oeb.oeb01,"",SQLCA.sqlcode,"","",1)
                CONTINUE FOREACH
             END IF
	  END IF
       END IF
#      COMMIT WORK  #TQC-980029         #TQC-AC0030 mark
    END FOREACH
  COMMIT WORK                           #TQC-AC0030 
    

#再抓出不存在于此訂單單身中的累計返現金折扣單資料，放入返利單身(因為這部分不存在的現金折扣單有可能是手工錄入的)
    LET l_sql ="SELECT * FROM tqw_file ",
               " WHERE tqw22 ='",g_oea.oea12,"'",
               "   AND tqw21 ='2'",
               "   AND tqw20 ='1'",
               "   AND tqw10 ='3'",
               "   AND tqw07 -tqw08 >0",
               "   AND tqw01 NOT IN ",
               "       (SELECT oeb1007 from oeb_file,oea_file WHERE oea01 =oeb01 AND oea01 ='",g_oea.oea01,"')"
    PREPARE t400_cash_pb9 FROM l_sql
    DECLARE t400_cash_cs9 CURSOR FOR t400_cash_pb9
    FOREACH t400_cash_cs9 INTO l_tqw.*
       LET l_oeb.oeb1003 ='2'
       LET l_oeb.oeb1012 ='N'
       LET l_oeb.oeb01   =g_oea.oea01
      #SELECT MAX(oeb03) INTO l_oeb.oeb03 FROM oeb_file   #TQC-AC0163 By shi
       SELECT MAX(oeb03)+1 INTO l_oeb.oeb03 FROM oeb_file #TQC-AC0163 By shi
        WHERE oeb01 =g_oea.oea01 AND oeb03 >= 9001
       IF l_oeb.oeb03 IS NULL THEN
          LET l_oeb.oeb03 =9001
       END IF
       LET l_oeb.oeb1007 =l_tqw.tqw01
       LET l_oeb.oeb1008 =l_tqw.tqw11
       LET l_oeb.oeb1009 =l_tqw.tqw12
       LET l_oeb.oeb1010 =l_tqw.tqw14
       LET l_oeb.oeb1001 =l_tqw.tqw15
       IF l_oeb.oeb1001 ='Y' THEN
          LET l_oeb.oeb14t =l_tqw.tqw07 - l_tqw.tqw08
         #LET l_oeb.oeb14  =(l_tqw.tqw07 - l_tqw.tqw08)/(1+l_oeb.oeb1009)     #MOD-AC0170
          LET l_oeb.oeb14  =(l_tqw.tqw07 - l_tqw.tqw08)/(1+l_oeb.oeb1009/100) #MOD-AC0170
       ELSE
          LET l_oeb.oeb14  =l_tqw.tqw07 - l_tqw.tqw08
         #LET l_oeb.oeb14t =(l_tqw.tqw07 - l_tqw.tqw08)/(1+l_oeb.oeb1009)     #MOD-AC0170
          LET l_oeb.oeb14t =(l_tqw.tqw07 - l_tqw.tqw08)*(1+l_oeb.oeb1009/100) #MOD-AC0170
       END IF
       IF cl_null(l_oeb.oeb14t) THEN
          LET l_oeb.oeb14t =0
       END IF
       IF cl_null(l_oeb.oeb14) THEN
          LET l_oeb.oeb14 =0
       END IF
       LET l_oeb.oeb05_fac='1'
       LET l_oeb.oeb12    ='0'
       LET l_oeb.oeb13    ='0'
       LET l_oeb.oeb37    ='0'          #FUN-AB0061
       LET l_oeb.oeb23    ='0'
       LET l_oeb.oeb24    ='0'
       LET l_oeb.oeb25    ='0'
       LET l_oeb.oeb26    ='0'
       LET l_oeb.oeb70    ='N'
       LET l_oeb.oebplant = g_plant #FUN-980010 add
       LET l_oeb.oeblegal = g_legal #FUN-980010 add
       LET l_oeb.oeb44 = '1' #FUN-9C0083
       LET l_oeb.oeb47 = 0 #FUN-9C0083
       LET l_oeb.oeb48 = '1' #FUN-9C0083
       IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF   #MOD-A10123
      #MOD-AC0170 Begin---
       LET l_oeb.oeb04 = 'MISC'
       LET l_oeb.oeb12 = 1
       LET l_oeb.oeb917= 1
      #MOD-AC0170 End-----
      #TQC-B10066 Begin---
       LET l_oeb.oeb70d= ''
       LET l_oeb.oeb72 = ''
       LET l_oeb.oeb902= ''
       LET l_oeb.oeb30 = ''
       LET l_oeb.oebud13 = ''
       LET l_oeb.oebud14 = ''
       LET l_oeb.oebud15 = ''
       LET l_oeb.oeb15 = ''
       LET l_oeb.oeb16 = ''
       SELECT ima02 INTO l_oeb.oeb06 FROM ima_file
        WHERE ima01=l_oeb.oeb04
      #TQC-B10066 End-----
       INSERT INTO oeb_file VALUES (l_oeb.*)
       IF STATUS OR SQLCA.SQLCODE THEN
          CALL cl_err3("ins","oeb_file",l_oeb.oeb01,"",SQLCA.sqlcode,"","",1)
          CONTINUE FOREACH
       END IF
    END FOREACH

#再抓取合同費用折扣條件中的部分
#判斷此訂單是否已有對應的單次返現金折扣單存在
    SELECT COUNT(*) INTO l_n FROM tqw_file
     WHERE tqw23 =g_oea.oea01
       AND tqw22 =g_oea.oea12
       AND tqw20 ='2'
       AND tqw10!='5'

    IF l_n ='0' THEN
       SELECT oaz80 INTO l_tqw.tqw01 FROM oaz_file
#TQC-AC0031 --begin--
       IF cl_null(l_tqw.tqw01) THEN 
          CALL cl_err('','axm-268',0)
          RETURN 
       END IF 
#TQC-AC0031 --end--         
       BEGIN WORK #TQC-980029
      #CALL s_auto_assign_no("axm",l_tqw.tqw01,g_today,"04","tqw_file","tqw01","","","") #FUN-AC0012
       CALL s_auto_assign_no("atm",l_tqw.tqw01,g_today,"U5","tqw_file","tqw01","","","") #FUN-AC0012
             RETURNING li_result,l_tqw.tqw01
       IF (NOT li_result) THEN
          ROLLBACK WORK  #TQC-980029
          RETURN
       END IF
       COMMIT WORK   #TQC-980029
       LET l_sql ="SELECT * FROM tqs_file ",
                  " WHERE tqs09 ='Y'",
                  "   AND tqs07 IN('2','3')",
                  "   AND tqs08 >0",
                  "   AND tqs01 ='",g_oea.oea12,"'"
       PREPARE t400_cash_pb10 FROM l_sql
       DECLARE t400_cash_cs10 CURSOR FOR t400_cash_pb10
       LET l_flag ='N'
       FOREACH t400_cash_cs10 INTO l_tqs.*
             IF l_flag ='N' THEN
                LET l_tqs04 =l_tqs.tqs04
                LET l_flag ='Y'
             END IF
             #insert tqv_file  產生現金折扣單明細資料
             LET l_tqv.tqv01 =l_tqw.tqw01
             SELECT MAX(tqv02) INTO l_tqv.tqv02 FROM tqv_file WHERE tqv01 =l_tqw.tqw01
             IF cl_null(l_tqv.tqv02) THEN
                LET l_tqv.tqv02 ='1'
             END IF
             LET l_tqv.tqv03 =l_tqs.tqs02
             LET l_tqv.tqv04 =l_tqs.tqs03
             IF l_tqs.tqs07 ='2' THEN
#取得對應的合同折扣基准是未稅還是含稅金額
                SELECT tqp12 INTO l_tqp12 FROM tqp_file
                 WHERE tqp01 =g_oea.oea12
                IF l_tqp12 ='1' THEN    #含稅金額
                   LET l_tqv.tqv05 =l_tqs.tqs08*g_oea.oea1008
                ELSE
                   LET l_tqv.tqv05 =l_tqs.tqs08*g_oea.oea61
                END IF
             ELSE
                LET l_tqv.tqv05 =l_tqs.tqs08
             END IF
             LET l_tqv.tqv06 =l_tqs.tqs06
             LET l_tqv.tqv07 =l_tqs.tqs05
             LET l_tqv.tqvplant = g_plant #FUN-980010 add
             LET l_tqv.tqvlegal = g_legal #FUN-980010 add

             INSERT INTO tqv_file VALUES (l_tqv.*)
             IF STATUS OR SQLCA.SQLCODE THEN
                CALL cl_err3("ins","tqv_file",l_tqv.tqv01,"",SQLCA.sqlcode,"","",1)
                CONTINUE FOREACH
             END IF
       END FOREACH

       LET l_tqw.tqw02 =g_today
       LET l_tqw.tqw03 =g_grup
       LET l_tqw.tqw04 =g_user
       LET l_tqw.tqw05 =g_oea.oea03
       SELECT SUM(tqv05) INTO l_tqw.tqw07 FROM tqv_file WHERE tqv01 =l_tqw.tqw01
       IF cl_null(l_tqw.tqw07) THEN
          LET l_tqw.tqw07 =0
       END IF
       LET l_tqw.tqw08 =0
       LET l_tqw.tqw081=0
       LET l_tqw.tqw10 ='3'
       LET l_tqw.tqw11 =g_oea.oea21
       LET l_tqw.tqw12 =g_oea.oea211
       LET l_tqw.tqw13 =g_oea.oea212
       SELECT tqp12 INTO l_tqp12 FROM tqp_file WHERE tqp01 =g_oea.oea12
       IF l_tqp12 ='1' THEN
           LET l_tqw.tqw14 ='Y'
       ELSE
           LET l_tqw.tqw14 ='N'
       END IF
       LET l_tqw.tqw15 =l_tqs04
       LET l_tqw.tqw17 =g_oea.oea23
       LET l_tqw.tqw18 =g_oea.oea24
       LET l_tqw.tqw20 ='2'
       LET l_tqw.tqw21 ='1'
       LET l_tqw.tqw22 =g_oea.oea12
       LET l_tqw.tqwplant = g_plant #FUN-980010
       LET l_tqw.tqwlegal = g_legal #FUN-980010

       INSERT INTO tqw_file VALUES (l_tqw.*)
       IF STATUS OR SQLCA.SQLCODE THEN
          CALL cl_err3("ins","tqw_file",l_tqw.tqw01,"",SQLCA.sqlcode,"","",1)
          RETURN
       END IF



       #insert oeb_file(返利單身)
       LET l_oeb.oeb1003 ='2'
       LET l_oeb.oeb1012 ='N'
       LET l_oeb.oeb01   =g_oea.oea01
      #SELECT MAX(oeb03) INTO l_oeb.oeb03 FROM oeb_file   #TQC-AC0163 By shi
       SELECT MAX(oeb03)+1 INTO l_oeb.oeb03 FROM oeb_file #TQC-AC0163 By shi
        WHERE oeb01 =g_oea.oea01 AND oeb03 >= 9001
       IF l_oeb.oeb03 IS NULL THEN
          LET l_oeb.oeb03 =9001
       END IF
       LET l_oeb.oeb1007 =l_tqw.tqw01
       LET l_oeb.oeb1008 =l_tqw.tqw11
       LET l_oeb.oeb1009 =l_tqw.tqw12
       LET l_oeb.oeb1010 =l_tqw.tqw14
       LET l_oeb.oeb1001 =l_tqw.tqw15
       IF l_oeb.oeb1001 ='Y' THEN
          LET l_oeb.oeb14t  =l_tqw.tqw07
         #LET l_oeb.oeb14   =l_tqw.tqw07/(1+l_oeb.oeb1009)     #MOD-AC0170
          LET l_oeb.oeb14   =l_tqw.tqw07/(1+l_oeb.oeb1009/100) #MOD-AC0170
       ELSE
          LET l_oeb.oeb14   =l_tqw.tqw07
         #LET l_oeb.oeb14t  =l_tqw.tqw07/(1+l_oeb.oeb1009)     #MOD-AC0170
          LET l_oeb.oeb14t  =l_tqw.tqw07*(1+l_oeb.oeb1009/100) #MOD-AC0170
       END IF
       IF cl_null(l_oeb.oeb14t) THEN
          LET l_oeb.oeb14t =0
       END IF
       IF cl_null(l_oeb.oeb14) THEN
          LET l_oeb.oeb14 =0
       END IF
       LET l_oeb.oeb05_fac='1'
       LET l_oeb.oeb12    ='0'
       LET l_oeb.oeb13    ='0'
       LET l_oeb.oeb37    ='0'          #FUN-AB0061
       LET l_oeb.oeb23    ='0'
       LET l_oeb.oeb24    ='0'
       LET l_oeb.oeb25    ='0'
       LET l_oeb.oeb26    ='0'
       LET l_oeb.oeb70    ='N'
       LET l_oeb.oebplant = g_plant #FUN-980010 add
       LET l_oeb.oeblegal = g_legal #FUN-980010 add
       LET l_oeb.oeb44 = '1' #FUN-9C0083
       LET l_oeb.oeb47 = 0 #FUN-9C0083
       LET l_oeb.oeb48 = '1' #FUN-9C0083
       IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF   #MOD-A10123
      #MOD-AC0170 Begin---
       LET l_oeb.oeb04 = 'MISC'
       LET l_oeb.oeb12 = 1
       LET l_oeb.oeb917= 1
      #MOD-AC0170 End-----
      #TQC-B10066 Begin---
       LET l_oeb.oeb70d= ''
       LET l_oeb.oeb72 = ''
       LET l_oeb.oeb902= ''
       LET l_oeb.oeb30 = ''
       LET l_oeb.oebud13 = ''
       LET l_oeb.oebud14 = ''
       LET l_oeb.oebud15 = ''
       LET l_oeb.oeb15 = ''
       LET l_oeb.oeb16 = ''
       SELECT ima02 INTO l_oeb.oeb06 FROM ima_file
        WHERE ima01=l_oeb.oeb04
      #TQC-B10066 End-----
       INSERT INTO oeb_file VALUES (l_oeb.*)
       IF STATUS OR SQLCA.SQLCODE THEN
          CALL cl_err3("ins","oeb_file",l_oeb.oeb01,"",SQLCA.sqlcode,"","",1)
          RETURN
       END IF
    ELSE
#抓出此訂單對應的已經審核的現金折扣單資料，放入返利單身
       LET l_sql ="SELECT * FROM tqw_file ",
                  " WHERE tqw23 ='",g_oea.oea01,"'",
                  "   AND tqw22 ='",g_oea.oea12,"'",
                  "   AND tqw20 ='2'",
                  "   AND tqw10 ='3'"
       PREPARE t400_cash_pb11 FROM l_sql
       DECLARE t400_cash_cs11 CURSOR FOR t400_cash_pb11
       FOREACH t400_cash_cs11 INTO l_tqw.*
         LET l_oeb.oeb1003 ='2'
         LET l_oeb.oeb1012 ='N'
         LET l_oeb.oeb01   =g_oea.oea01
        #SELECT MAX(oeb03) INTO l_oeb.oeb03 FROM oeb_file   #TQC-AC0163 By shi
         SELECT MAX(oeb03)+1 INTO l_oeb.oeb03 FROM oeb_file #TQC-AC0163 By shi
          WHERE oeb01 =g_oea.oea01 AND oeb03 >= 9001
         IF l_oeb.oeb03 IS NULL THEN
            LET l_oeb.oeb03 =9001
         END IF
         LET l_oeb.oeb1007 =l_tqw.tqw01
         LET l_oeb.oeb1008 =l_tqw.tqw11
         LET l_oeb.oeb1009 =l_tqw.tqw12
         LET l_oeb.oeb1010 =l_tqw.tqw14
         LET l_oeb.oeb1001 =l_tqw.tqw15
         IF l_oeb.oeb1001 ='Y' THEN
            LET l_oeb.oeb14t =l_tqw.tqw07
           #LET l_oeb.oeb14  =l_tqw.tqw07/(1+l_oeb.oeb1009)     #MOD-AC0170
            LET l_oeb.oeb14  =l_tqw.tqw07/(1+l_oeb.oeb1009/100) #MOD-AC0170
         ELSE
            LET l_oeb.oeb14  =l_tqw.tqw07
           #LET l_oeb.oeb14t =l_tqw.tqw07/(1+l_oeb.oeb1009)     #MOD-AC0170
            LET l_oeb.oeb14t =l_tqw.tqw07*(1+l_oeb.oeb1009/100) #MOD-AC0170
         END IF
         IF cl_null(l_oeb.oeb14t) THEN
            LET l_oeb.oeb14t =0
         END IF
         IF cl_null(l_oeb.oeb14) THEN
            LET l_oeb.oeb14 =0
         END IF
         LET l_oeb.oeb05_fac='1'
         LET l_oeb.oeb12    ='0'
         LET l_oeb.oeb13    ='0'
         LET l_oeb.oeb37    ='0'          #FUN-AB0061
         LET l_oeb.oeb23    ='0'
         LET l_oeb.oeb24    ='0'
         LET l_oeb.oeb25    ='0'
         LET l_oeb.oeb26    ='0'
         LET l_oeb.oeb70    ='N'
         LET l_oeb.oebplant = g_plant #FUN-980010 add
         LET l_oeb.oeblegal = g_legal #FUN-980010 add
         LET l_oeb.oeb44 = '1' #FUN-9C0083
         LET l_oeb.oeb47 = 0 #FUN-9C0083
         LET l_oeb.oeb48 = '1' #FUN-9C0083
         IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF   #MOD-A10123
        #MOD-AC0170 Begin---
         LET l_oeb.oeb04 = 'MISC'
         LET l_oeb.oeb12 = 1
         LET l_oeb.oeb917= 1
        #MOD-AC0170 End-----
        #TQC-B10066 Begin---
         LET l_oeb.oeb70d= ''
         LET l_oeb.oeb72 = ''
         LET l_oeb.oeb902= ''
         LET l_oeb.oeb30 = ''
         LET l_oeb.oebud13 = ''
         LET l_oeb.oebud14 = ''
         LET l_oeb.oebud15 = ''
         LET l_oeb.oeb15 = ''
         LET l_oeb.oeb16 = ''
         SELECT ima02 INTO l_oeb.oeb06 FROM ima_file
          WHERE ima01=l_oeb.oeb04
        #TQC-B10066 End-----
         INSERT INTO oeb_file VALUES (l_oeb.*)
         IF STATUS OR SQLCA.SQLCODE THEN
            CALL cl_err3("ins","oeb_file",l_oeb.oeb01,"",SQLCA.sqlcode,"","",1)
            CONTINUE FOREACH
         END IF
       END FOREACH
    END IF
END FUNCTION

FUNCTION t400_obj_return()
DEFINE l_oeb01        LIKE oeb_file.oeb01
DEFINE l_oeb04        LIKE oeb_file.oeb04
DEFINE l_oeb05        LIKE oeb_file.oeb05
DEFINE l_oeb12_sum    LIKE oeb_file.oeb12
DEFINE l_oeb14_sum    LIKE oeb_file.oeb14
DEFINE l_oeb14t_sum   LIKE oeb_file.oeb14t
DEFINE l_ohb12_sum    LIKE ohb_file.ohb12
DEFINE l_ogb14_sum    LIKE ogb_file.ogb14
DEFINE l_ogb12_sum    LIKE ogb_file.ogb12
DEFINE l_ogb14t_sum   LIKE ogb_file.ogb14t
dEFINE l_ohb14_sum    LIKE ogb_file.ogb14
DEFINE l_ohb14t_sum   LIKE ogb_file.ogb14t
DEFINE l_tqu   RECORD LIKE tqu_file.*
DEFINE l_oeb   RECORD LIKE oeb_file.*
DEFINE l_try   RECORD LIKE try_file.*
DEFINE l_tqp12        LIKE tqp_file.tqp12
DEFINE l_ima25        LIKE ima_file.ima25
DEFINE l_ima906       LIKE ima_file.ima906
DEFINE l_ima907       LIKE ima_file.ima907
DEFINE l_ima908       LIKE ima_file.ima908
DEFINE l_unit         LIKE oeb_file.oeb05
DEFINE l_n            LIKE type_file.num5
DEFINE #l_sql          LIKE type_file.chr1000
       l_sql   STRING      #NO.FUN-910082
DEFINE li_result      LIKE type_file.num5
DEFINE l_success      LIKE type_file.num5
DEFINE l_last_month   LIKE type_file.num5
DEFINE l_last_year    LIKE type_file.num5
DEFINE l_month        LIKE type_file.num5
DEFINE l_bg_month     LIKE type_file.num5
DEFINE l_ed_month     LIKE type_file.num5
DEFINE l_last_bg      LIKE type_file.chr14
DEFINE l_last_ed      LIKE type_file.chr14
DEFINE l_bg           LIKE type_file.chr14
DEFINE l_ed           LIKE type_file.chr14
DEFINE l_last_bg_day  LIKE type_file.dat
DEFINE l_last_ed_day  LIKE type_file.dat
DEFINE l_bg_day       LIKE type_file.dat
DEFINE l_ed_day       LIKE type_file.dat
DEFINE l_count        LIKE type_file.num5      #TQC-AA0118 
DEFINE l_flag         LIKE type_file.num5      #TQC-AA0118
DEFINE l_factor       LIKE type_file.num26_10  #TQC-AA0118
DEFINE l_check        LIKE type_file.chr1      #TQC-AC0163

#TQC-AA0118 --begin--
#    IF g_oea.oea11 ='3' AND (NOT cl_null(g_oea.oea12)) THEN
#       RETURN
#    END IF

     LET l_count = 0 
     SELECT COUNT(*) INTO l_count FROM tqp_file
      WHERE tqp01 = g_oea.oea12
     IF g_oea.oea11 = '3' AND l_count = 0 THEN 
       RETURN 
     END IF            
#TQC-AA0118 --end--
    
    IF g_oea.oea49 != '0' THEN
       RETURN
    END IF

    DELETE FROM oeb_file WHERE oeb01 = g_oea.oea01 AND oeb1003 ='2'
                           AND oeb03 < 9001 #TQC-AC0163 By shi
    CALL t400_oea_sum()

#TQC-AA0118 --begin--    
#    LET l_sql ="SELECT oeb01,oeb04,oeb05,sum(oeb05*oeb05_fac),",
#               "sum(oeb14),sum(oeb14t) FROM oeb_file ",
#               " WHERE oeb01 ='",g_oea.oea01,"'",
#               " GROUP BY oeb01,oeb04.oeb05"
    LET l_sql ="SELECT oeb01,oeb04,oeb05,sum(oeb12*oeb05_fac),",
               "sum(oeb14),sum(oeb14t) FROM oeb_file ",
               " WHERE oeb01 ='",g_oea.oea01,"'",
               " GROUP BY oeb01,oeb04,oeb05"
#TQC-AA0118 --end--               
    
    PREPARE t400_obj_pb1 FROM l_sql
    DECLARE t400_obj_cs1 CURSOR FOR t400_obj_pb1
    FOREACH t400_obj_cs1 INTO l_oeb01,l_oeb04,l_oeb05,l_oeb12_sum,l_oeb14_sum,l_oeb14t_sum
#       LET l_sql ="SELECT tqu_file.*tqp12",    #TQC-A80141 
        LET l_sql ="SELECT tqu_file.*,tqp12",    #TQC-A80141 
                  " FROM tqu_file,tqp_file ",
                  " WHERE tqu02 ='1'",
                  "   AND tqu03 <='",g_oea.oea02,"'",
                  "   AND tqu04 >='",g_oea.oea02,"'",
                  "   AND tqu01 ='",g_oea.oea12,"'",
                  "   AND tqu06 ='",l_oeb04,"'",
                  "   AND tqp01 =tqu01"
       PREPARE t400_obj_pb2 FROM l_sql
       DECLARE t400_obj_cs2 CURSOR FOR t400_obj_pb2
       FOREACH t400_obj_cs2 INTO l_tqu.*,l_tqp12
          IF l_tqu.tqu07 ='1' THEN
             SELECT ima25,ima906,ima907,ima908 INTO l_ima25,l_ima906,l_ima907,l_ima908                         
               FROM ima_file WHERE ima01 =l_tqu.tqu06

#TQC-AA0118 --begin--            
#             LET l_tqu.tqu08 =l_tqu.tqu08*(l_tqu.tqu10/l_ima25)
#             LET l_tqu.tqu09 =l_tqu.tqu09*(l_tqu.tqu10/l_ima25)
              IF l_tqu.tqu10 = l_ima25 THEN 
                 LET l_factor = 1               
              ELSE
              	 CALL s_umfchk(l_tqu.tqu06,l_ima25,l_tqu.tqu10)
              	    RETURNING l_flag,l_factor 
              	 IF l_flag = 0 THEN 
                    LET l_tqu.tqu08 =l_tqu.tqu08*l_factor
                    LET l_tqu.tqu09 =l_tqu.tqu09*l_factor
              	 ELSE
              		  CALL cl_err('','mfg1206',1)
              		  LET g_success = 'N'
              		  EXIT FOREACH    
              	 END IF        
              END IF    
#TQC-AA0118 --end--
           
             IF l_tqu.tqu08 <=l_oeb12_sum AND l_tqu.tqu09 >= l_oeb12_sum THEN
                LET l_oeb.oeb01 =l_oeb01
               #SELECT MAX(oeb03) INTO l_oeb.oeb03 FROM oeb_file   #TQC-AC0163 By shi
                SELECT MAX(oeb03)+1 INTO l_oeb.oeb03 FROM oeb_file #TQC-AC0163 By shi
                 WHERE oeb01 = l_oeb01
                   AND oeb03 < 9001
                IF cl_null(l_oeb.oeb03) THEN
                   LET l_oeb.oeb03 ='1'
                END IF
                LET l_oeb.oeb04 =l_tqu.tqu11
                LET l_oeb.oeb05 =l_tqu.tqu13
                LET l_oeb.oeb12 =l_tqu.tqu12
                IF g_sma.sma115 ='Y' THEN
                   IF l_ima906 ='1' THEN
                      LET l_oeb.oeb910 =l_oeb.oeb05
                      LET l_oeb.oeb911 ='1'
                      LET l_oeb.oeb912 =l_oeb.oeb12
                   ELSE
                      IF l_ima906 ='2' THEN
                         LET l_oeb.oeb910 =l_oeb.oeb05
                         LET l_oeb.oeb911 ='1'
                         LET l_oeb.oeb912 =l_oeb.oeb12
                         LET l_oeb.oeb913 =l_ima907
                         LET l_oeb.oeb914 =l_oeb.oeb913/l_oeb.oeb05
                         LET l_oeb.oeb915 ='0'
                      ELSE
                         IF l_ima906 ='3' THEN
                            LET l_oeb.oeb910 =l_oeb.oeb05
                            LET l_oeb.oeb911 ='1'
                            LET l_oeb.oeb912 =l_oeb.oeb12
                            LET l_oeb.oeb913 =l_ima907
                            LET l_oeb.oeb914 =l_oeb.oeb913/l_oeb.oeb05
                            LET l_oeb.oeb915 =l_oeb.oeb12/l_oeb.oeb914
                         END IF
                      END IF
                   END IF
                END IF                     #TQC-AA0118 add                    
                   IF g_sma.sma116 ='Y' THEN
                      LET l_oeb.oeb916 =l_ima908
                      LET l_oeb.oeb917 =l_oeb.oeb12*(l_oeb.oeb05/l_oeb.oeb16)
                   ELSE
                      LET l_oeb.oeb916 =l_oeb.oeb05
                      LET l_oeb.oeb917 =l_oeb.oeb12
                   END IF   
                   LET l_oeb.oeb14 ='0'
                   LET l_oeb.oeb14t='0'
                  #LET l_oeb.oeb1003 ='1' #TQC-AC0163 By shi
                   LET l_oeb.oeb1003 ='2' #TQC-AC0163 By shi
                   LET l_oeb.oeb1001 =l_tqu.tqu15
                   IF NOT cl_null(l_oeb.oeb916) THEN
                      LET l_unit=l_oeb.oeb916
                   ELSE
                      LET l_unit=l_oeb.oeb05
                   END IF
                   SELECT oeb15 INTO l_oeb.oeb15 FROM oeb_file WHERE oeb01 =l_oeb01 AND oeb04 =l_oeb04
                      AND oeb03 IN (SELECT MIN(oeb03) FROM oeb_file WHERE oeb01 =l_oeb01 AND oeb04 =l_oeb04)
                   CALL s_fetch_price_new(g_oea.oea03,l_oeb.oeb04,l_unit,g_oea.oea02,
                                          '1',g_oea.oeaplant,g_oea.oea23,g_oea.oea31,g_oea.oea32,
                                          g_oea.oea01,l_oeb.oeb03,l_oeb.oeb917,l_oeb.oeb1004,'e')
                   #  RETURNING l_oeb.oeb13        #FUN-AB0061
                      RETURNING l_oeb.oeb13,l_oeb.oeb37    #FUN-AB0061
                   IF l_oeb.oeb13 = 0 THEN CALL s_unitprice_entry(g_oea.oea03,g_oea.oea31,g_oea.oeaplant) END IF #FUN-9C0120
                   LET l_oeb.oeb1012 ='Y'
                   LET l_oeb.oeb937 =l_tqu.tqu14
         #TQC-AC0163 ------------------STA
         #         LET l_oeb.oeb05_fac=l_oeb.oeb05/l_ima25
                   CALL s_umfchk(l_tqu.tqu06,l_oeb.oeb05,l_ima25)
                        RETURNING l_check,l_oeb.oeb05_fac
                   IF l_check = '1'  THEN
                      CALL cl_err('','abm-731',0)
                      LET g_success = 'N'
                      EXIT FOREACH
                   END IF
                   LET l_oeb.oeb13 = '0'
                   LET l_oeb.oeb44 = '1'
                   LET l_oeb.oeb47 = '0'
                   LET l_oeb.oeb48 = '2'
                  #TQC-AC0163 Begin--- By shi
                   LET l_oeb.oeb70d= ''
                   LET l_oeb.oeb72 = ''
                   LET l_oeb.oeb902= ''
                   LET l_oeb.oeb30 = ''
                   LET l_oeb.oebud13 = ''
                   LET l_oeb.oebud14 = ''
                   LET l_oeb.oebud15 = ''
                   LET l_oeb.oeb16 = ''
                   LET l_oeb.oeb47 = 0
                   SELECT ima02 INTO l_oeb.oeb06 FROM ima_file
                    WHERE ima01=l_oeb.oeb04
                  #TQC-AC0163 End-----
         #TQC-AC0163 -------------------END
                   LET l_oeb.oeb23    ='0'
                   LET l_oeb.oeb24    ='0'
                   LET l_oeb.oeb25    ='0'
                   LET l_oeb.oeb26    ='0'
                   LET l_oeb.oeb70    ='N'
                   LET l_oeb.oebplant = g_plant #FUN-980010 add
                   LET l_oeb.oeblegal = g_legal #FUN-980010 add
                   IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF   #MOD-A10123
                   INSERT INTO oeb_file VALUES (l_oeb.*)
                   IF STATUS OR SQLCA.SQLCODE THEN
                      CALL cl_err3("ins","oeb_file",l_oeb.oeb01,"",SQLCA.sqlcode,"","",1)
                   END IF
#               END IF   #TQC-AA0118 mark
             END IF
          ELSE
             IF l_tqp12 ='1' THEN
                SELECT ima25,ima906,ima907,ima908 INTO l_ima25,l_ima906,l_ima907,l_ima908
                  FROM ima_file WHERE ima01 =l_tqu.tqu06
#TQC-AA0118 --begin--            
#             LET l_tqu.tqu08 =l_tqu.tqu08*(l_tqu.tqu10/l_ima25)
#             LET l_tqu.tqu09 =l_tqu.tqu09*(l_tqu.tqu10/l_ima25)
              IF l_tqu.tqu10 = l_ima25 THEN 
                 LET l_factor = 1 
              ELSE
              	 CALL s_umfchk(l_tqu.tqu06,l_ima25,l_tqu.tqu10)
              	    RETURNING l_flag,l_factor 
              	 IF l_flag = 0 THEN 
                    LET l_tqu.tqu08 =l_tqu.tqu08*l_factor
                    LET l_tqu.tqu09 =l_tqu.tqu09*l_factor
              	 ELSE
              		  CALL cl_err('','mfg1206',1)
              		  LET g_success = 'N'
              		  EXIT FOREACH    
              	 END IF        
              END IF    
#TQC-AA0118 --end--             
                IF l_tqu.tqu08 <=l_oeb14t_sum AND l_tqu.tqu09 >= l_oeb14t_sum THEN
                   LET l_oeb.oeb01 =l_oeb01
                  #SELECT MAX(oeb03) INTO l_oeb.oeb03 FROM oeb_file   #TQC-AC0163 By shi
                   SELECT MAX(oeb03)+1 INTO l_oeb.oeb03 FROM oeb_file #TQC-AC0163 By shi
                    WHERE oeb01 =l_oeb01
                      AND oeb03 <9001
                   IF cl_null(l_oeb.oeb03) THEN
                      LET l_oeb.oeb03 ='1'
                   END IF
                   LET l_oeb.oeb04 =l_tqu.tqu11
                   LET l_oeb.oeb05 =l_tqu.tqu13
                   LET l_oeb.oeb12 =l_tqu.tqu12
                   IF g_sma.sma115 ='Y' THEN
                      IF l_ima906 ='1' THEN
                         LET l_oeb.oeb910 =l_oeb.oeb05
                         LET l_oeb.oeb911 ='1'
                         LET l_oeb.oeb912 =l_oeb.oeb12
                      ELSE
                         IF l_ima906 ='2' THEN
                            LET l_oeb.oeb910 =l_oeb.oeb05
                            LET l_oeb.oeb911 ='1'
                            LET l_oeb.oeb912 =l_oeb.oeb12
                            LET l_oeb.oeb913 =l_ima907
                            LET l_oeb.oeb914 =l_oeb.oeb913/l_oeb.oeb05
                            LET l_oeb.oeb915 ='0'
                         ELSE
                            IF l_ima906 ='3' THEN
                               LET l_oeb.oeb910 =l_oeb.oeb05
                               LET l_oeb.oeb911 ='1'
                               LET l_oeb.oeb912 =l_oeb.oeb12
                               LET l_oeb.oeb913 =l_ima907
                               LET l_oeb.oeb914 =l_oeb.oeb913/l_oeb.oeb05
                               LET l_oeb.oeb915 =l_oeb.oeb12/l_oeb.oeb914
                            END IF
                         END IF
                      END IF
                    END IF     #TQC-AA0118                       
                      IF g_sma.sma116 ='Y' THEN
                         LET l_oeb.oeb916 =l_ima908
                         LET l_oeb.oeb917 =l_oeb.oeb12*(l_oeb.oeb05/l_oeb.oeb16)
                      ELSE
                         LET l_oeb.oeb916 =l_oeb.oeb05
                         LET l_oeb.oeb917 =l_oeb.oeb12
                      END IF  
                      LET l_oeb.oeb14 ='0'
                      LET l_oeb.oeb14t='0'
                     #LET l_oeb.oeb1003 ='1' #TQC-AC0163 By shi
                      LET l_oeb.oeb1003 ='2' #TQC-AC0163 By shi
                      LET l_oeb.oeb1001 =l_tqu.tqu15
                      IF NOT cl_null(l_oeb.oeb916) THEN
                         LET l_unit=l_oeb.oeb916
                      ELSE
                         LET l_unit=l_oeb.oeb05
                      END IF
                      SELECT oeb15 INTO l_oeb.oeb15 FROM oeb_file WHERE oeb01 =l_oeb01 AND oeb04 =l_oeb04
                         AND oeb03 IN (SELECT MIN(oeb03) FROM oeb_file WHERE oeb01 =l_oeb01 AND oeb04 =l_oeb04)
                      CALL s_fetch_price_new(g_oea.oea03,l_oeb.oeb04,l_unit,g_oea.oea02,
                                             '1',g_oea.oeaplant,g_oea.oea23,g_oea.oea31,g_oea.oea32,
                                             g_oea.oea01,l_oeb.oeb03,l_oeb.oeb917,l_oeb.oeb1004,'e')
                      #  RETURNING l_oeb.oeb13   #FUN-AB0061
                         RETURNING l_oeb.oeb13,l_oeb.oeb37   #FUN-AB0061
                      IF l_oeb.oeb13 = 0 THEN CALL s_unitprice_entry(g_oea.oea03,g_oea.oea31,g_plant) END IF #FUN-9C0120
                      LET l_oeb.oeb1012 ='Y'
                      LET l_oeb.oeb937 =l_tqu.tqu14
          #TQC-AC0163 ------------------STA
          #           LET l_oeb.oeb05_fac=l_oeb.oeb05/l_ima25
                      CALL s_umfchk(l_tqu.tqu06,l_oeb.oeb05,l_ima25)
                           RETURNING l_check,l_oeb.oeb05_fac
                      IF l_check = '1'  THEN
                          CALL cl_err('','abm-731',0)
                         LET g_success = 'N'
                         EXIT FOREACH
                      END IF
                      LET l_oeb.oeb13 = '0'
                      LET l_oeb.oeb44 = '1'
                      LET l_oeb.oeb47 = '0'
                      LET l_oeb.oeb48 = '2'
                     #TQC-AC0163 Begin--- By shi
                      LET l_oeb.oeb70d= ''
                      LET l_oeb.oeb72 = ''
                      LET l_oeb.oeb902= ''
                      LET l_oeb.oeb30 = ''
                      LET l_oeb.oebud13 = ''
                      LET l_oeb.oebud14 = ''
                      LET l_oeb.oebud15 = ''
                      LET l_oeb.oeb16 = ''
                      LET l_oeb.oeb47 = 0
                      SELECT ima02 INTO l_oeb.oeb06 FROM ima_file
                       WHERE ima01=l_oeb.oeb04
                     #TQC-AC0163 End-----
         #TQC-AC0163 -------------------END
                      LET l_oeb.oeb23    ='0'
                      LET l_oeb.oeb24    ='0'
                      LET l_oeb.oeb25    ='0'
                      LET l_oeb.oeb26    ='0'
                      LET l_oeb.oeb70    ='N'
                      LET l_oeb.oebplant = g_plant #FUN-980010 add
                      LET l_oeb.oeblegal = g_legal #FUN-980010 add
                      IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF   #MOD-A10123
                      INSERT INTO oeb_file VALUES (l_oeb.*)
                      IF STATUS OR SQLCA.SQLCODE THEN
                         CALL cl_err3("ins","oeb_file",l_oeb.oeb01,"",SQLCA.sqlcode,"","",1)
                      END IF
#                   END IF    #TQC-AA0118 mark 
                END IF
             ELSE
                SELECT ima25,ima906,ima907,ima908 INTO l_ima25,l_ima906,l_ima907,l_ima908
                  FROM ima_file WHERE ima01 =l_tqu.tqu06
#TQC-AA0118 --begin--            
#             LET l_tqu.tqu08 =l_tqu.tqu08*(l_tqu.tqu10/l_ima25)
#             LET l_tqu.tqu09 =l_tqu.tqu09*(l_tqu.tqu10/l_ima25)
              IF l_tqu.tqu10 = l_ima25 THEN 
                 LET l_factor = 1 
              ELSE
              	 CALL s_umfchk(l_tqu.tqu06,l_ima25,l_tqu.tqu10)
              	    RETURNING l_flag,l_factor 
              	 IF l_flag = 0 THEN 
                    LET l_tqu.tqu08 =l_tqu.tqu08*l_factor
                    LET l_tqu.tqu09 =l_tqu.tqu09*l_factor
              	 ELSE
              		  CALL cl_err('','mfg1206',1)
              		  LET g_success = 'N'
              		  EXIT FOREACH    
              	 END IF        
              END IF    
#TQC-AA0118 --end--   
                IF l_tqu.tqu08 <=l_oeb14_sum AND l_tqu.tqu09 >= l_oeb14_sum THEN
                   LET l_oeb.oeb01 =l_oeb01
                  #SELECT MAX(oeb03) INTO l_oeb.oeb03 FROM oeb_file   #TQC-AC0163 By shi
                   SELECT MAX(oeb03)+1 INTO l_oeb.oeb03 FROM oeb_file #TQC-AC0163 By shi
                    WHERE oeb01 =l_oeb01
                      AND oeb03 <9001
                   IF cl_null(l_oeb.oeb03) THEN
                      LET l_oeb.oeb03 ='1'
                   END IF
                   LET l_oeb.oeb04 =l_tqu.tqu11
                   LET l_oeb.oeb05 =l_tqu.tqu13
                   LET l_oeb.oeb12 =l_tqu.tqu12
                   IF g_sma.sma115 ='Y' THEN
                      IF l_ima906 ='1' THEN
                         LET l_oeb.oeb910 =l_oeb.oeb05
                         LET l_oeb.oeb911 ='1'
                         LET l_oeb.oeb912 =l_oeb.oeb12
                      ELSE
                         IF l_ima906 ='2' THEN
                            LET l_oeb.oeb910 =l_oeb.oeb05
                            LET l_oeb.oeb911 ='1'
                            LET l_oeb.oeb912 =l_oeb.oeb12
                            LET l_oeb.oeb913 =l_ima907
                            LET l_oeb.oeb914 =l_oeb.oeb913/l_oeb.oeb05
                            LET l_oeb.oeb915 ='0'
                         ELSE
                            IF l_ima906 ='3' THEN
                               LET l_oeb.oeb910 =l_oeb.oeb05
                               LET l_oeb.oeb911 ='1'
                               LET l_oeb.oeb912 =l_oeb.oeb12
                               LET l_oeb.oeb913 =l_ima907
                               LET l_oeb.oeb914 =l_oeb.oeb913/l_oeb.oeb05
                               LET l_oeb.oeb915 =l_oeb.oeb12/l_oeb.oeb914
                            END IF
                         END IF
                      END IF
                    END IF           #TQC-AA0118                        
                      IF g_sma.sma116 ='Y' THEN
                         LET l_oeb.oeb916 =l_ima908
                         LET l_oeb.oeb917 =l_oeb.oeb12*(l_oeb.oeb05/l_oeb.oeb16)
                      ELSE
                         LET l_oeb.oeb916 =l_oeb.oeb05
                         LET l_oeb.oeb917 =l_oeb.oeb12
                      END IF 
                      LET l_oeb.oeb14 ='0'
                      LET l_oeb.oeb14t='0'
                     #LET l_oeb.oeb1003 ='1' #TQC-AC0163 By shi
                      LET l_oeb.oeb1003 ='2' #TQC-AC0163 By shi
                      LET l_oeb.oeb1001 =l_tqu.tqu15
                      IF NOT cl_null(l_oeb.oeb916) THEN
                         LET l_unit=l_oeb.oeb916
                      ELSE
                         LET l_unit=l_oeb.oeb05
                      END IF
                      SELECT oeb15 INTO l_oeb.oeb15 FROM oeb_file WHERE oeb01 =l_oeb01 AND oeb04 =l_oeb04
                         AND oeb03 IN (SELECT MIN(oeb03) FROM oeb_file WHERE oeb01 =l_oeb01 AND oeb04 =l_oeb04)
                      CALL s_fetch_price_new(g_oea.oea03,l_oeb.oeb04,l_unit,g_oea.oea02,
                                             '1',g_oea.oeaplant,g_oea.oea23,g_oea.oea31,g_oea.oea32,
                                             g_oea.oea01,l_oeb.oeb03,l_oeb.oeb917,l_oeb.oeb1004,'e')
                       # RETURNING l_oeb.oeb13    #FUN-AB0061
                         RETURNING l_oeb.oeb13,l_oeb.oeb37   #FUN-AB0061
                       IF l_oeb.oeb13 = 0 THEN CALL s_unitprice_entry(g_oea.oea03,g_oea.oea31,g_oea.oeaplant) END IF #FUN-9C0120
                      LET l_oeb.oeb1012 ='Y'
                      LET l_oeb.oeb937 =l_tqu.tqu14
         #TQC-AC0163 ------------------STA
         #            LET l_oeb.oeb05_fac=l_oeb.oeb05/l_ima25
                      CALL s_umfchk(l_tqu.tqu06,l_oeb.oeb05,l_ima25)
                          RETURNING l_check,l_oeb.oeb05_fac
                      IF l_check = '1'  THEN
                         CALL cl_err('','abm-731',0)
                         LET g_success = 'N'
                         EXIT FOREACH
                      END IF
                      LET l_oeb.oeb13 = '0'
                      LET l_oeb.oeb44 = '1'
                      LET l_oeb.oeb47 = '0'
                      LET l_oeb.oeb48 = '2'
                     #TQC-AC0163 Begin--- By shi
                      LET l_oeb.oeb70d= ''
                      LET l_oeb.oeb72 = ''
                      LET l_oeb.oeb902= ''
                      LET l_oeb.oeb30 = ''
                      LET l_oeb.oebud13 = ''
                      LET l_oeb.oebud14 = ''
                      LET l_oeb.oebud15 = ''
                      LET l_oeb.oeb16 = ''
                      LET l_oeb.oeb47 = 0
                      SELECT ima02 INTO l_oeb.oeb06 FROM ima_file
                       WHERE ima01=l_oeb.oeb04
                     #TQC-AC0163 End-----
         #TQC-AC0163 -------------------END        
                      LET l_oeb.oeb23    ='0'
                      LET l_oeb.oeb24    ='0'
                      LET l_oeb.oeb25    ='0'
                      LET l_oeb.oeb26    ='0'
                      LET l_oeb.oeb70    ='N'
                      LET l_oeb.oebplant = g_plant #FUN-980010 add
                      LET l_oeb.oeblegal = g_legal #FUN-980010 add
                      IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF   #MOD-A10123
                      INSERT INTO oeb_file VALUES (l_oeb.*)
                      IF STATUS OR SQLCA.SQLCODE THEN
                         CALL cl_err3("ins","oeb_file",l_oeb.oeb01,"",SQLCA.sqlcode,"","",1)
                      END IF
#                   END IF     #TQC-AA0118
                END IF
             END IF
          END IF
       END FOREACH      
#TQC-AA0118 --begin--            
       IF g_success = 'N' THEN 
          EXIT FOREACH    
       END IF        
#TQC-AA0118 --end--      
    END FOREACH
#TQC-AA0118 --begin--            
    IF g_success = 'N' THEN 
       RETURN     
    END IF        
#TQC-AA0118 --end--     
    
#再產生累計返的資料
    LET l_sql ="SELECT tqu_file.*,tqp12",
               " FROM tqu_file,tqp_file ",
               " WHERE tqu02 ='2'",
               "   AND tqu01 ='",g_oea.oea12,"'",
               "   AND tqp01 =tqu01"
    PREPARE t400_obj_pb3 FROM l_sql
    DECLARE t400_obj_cs3 CURSOR FOR t400_obj_pb3
    FOREACH t400_obj_cs3 INTO l_tqu.*,l_tqp12
       IF l_tqu.tqu05 ='1' THEN      #按月返
#先檢查上月起始日期是否大于現返條件的截止日期，或者上月截止日期是否小于現返條件的起始日期
          LET l_last_month =MONTH(g_today) -1
          IF l_last_month =0 THEN
             LET l_last_month =12
             LET l_last_year =YEAR(g_today) -1
          ELSE
             LET l_last_year =YEAR(g_today)
          END IF
    
         #TQC-AC0163 Begin--- By shi
         #LET l_last_bg =l_last_year,"/",l_last_month,"/","01"
         #LET l_last_bg_day =l_last_bg USING "YYMMDD"
         #LET l_last_ed =l_last_year,"/",l_last_month,"/",cl_days(l_last_year,l_last_month)
         #LET l_last_ed_day =l_last_ed USING "YYMMDD"
          LET l_last_bg_day = MDY(l_last_month,1,l_last_year)
          LET l_last_ed_day = MDY(l_last_month,cl_days(l_last_year,l_last_month),l_last_year)
         #TQC-AC0163 End-----
    
          IF l_last_bg_day > l_tqu.tqu04 OR l_last_ed_day < l_tqu.tqu03 THEN
             CONTINUE FOREACH
          END IF
#本月的起始日期和截止日期
         #TQC-AC0163 Begin--- By shi
         #LET l_bg =YEAR(g_today),"/",MONTH(g_today),"/","01"
         #LET l_bg_day =l_bg USING "YYMMDD"
         #LET l_ed =YEAR(g_today),"/",MONTH(g_today),"/",cl_days(YEAR(g_today),MONTH(g_today))
         #LET l_ed_day =l_ed USING "YYMMDD"
          LET l_bg_day = MDY(MONTH(g_today),1,YEAR(g_today))
          LET l_ed_day = MDY(MONTH(g_today),cl_days(YEAR(g_today),MONTH(g_today)),YEAR(g_today))
         #TQC-AC0163 End-----
#先檢查此合同本月是否已經對上月進行累計返過
          SELECT COUNT(*) INTO l_n FROM oeb_file,oea_file
           WHERE oea02 BETWEEN l_bg_day AND l_ed_day
             AND oeb01 =oea01
             AND oeb1012 ='Y'
            #AND oeb1003 ='1' #TQC-AC0163 By shi
             AND oeb1003 ='2' #TQC-AC0163 By shi
             AND oea12 =g_oea.oea12
             AND oeb937 =l_tqu.tqu14
          IF l_n =0 THEN #沒有對上月累計返利，則取得出貨統計的起始截止區間，作為累計返的累計區間
             IF l_last_bg_day < l_tqu.tqu03 THEN
                LET l_last_bg_day =l_tqu.tqu03
             END IF
             IF l_last_ed_day > l_tqu.tqu04 THEN
                LET l_last_ed_day =l_tqu.tqu04
             END IF
          ELSE
             CONTINUE FOREACH
          END IF
       ELSE
          IF l_tqu.tqu05 ='2' THEN  #按季返
#取得當前季度的第一個月和最后一個月
             LET l_month =MONTH(g_today)
             IF l_month >=1 AND l_month <=3 THEN
                LET l_bg_month =1
                LET l_ed_month =3
             END IF
             IF l_month >=4 AND l_month <=6 THEN
                LET l_bg_month =4
                LET l_ed_month =6
             END IF
             IF l_month >=7 AND l_month <=9 THEN
                LET l_bg_month =7
                LET l_ed_month =9
             END IF
             IF l_month >=10 AND l_month <=12 THEN
                LET l_bg_month =10
                LET l_ed_month =12
             END IF
#上一季度的第一個月
             LET l_last_month =l_bg_month -3
             IF l_last_month =-2 THEN
                LET l_last_month =10
                LET l_last_year =YEAR(g_today) -1
             ELSE
                LET l_last_year =YEAR(g_today)
             END IF
            #TQC-AC0163 Begin--- By shi
            #LET l_last_bg =l_last_year,"/",l_last_month,"/","01"
            #LET l_last_bg_day =l_last_bg USING "YYMMDD"   #上一季度的第一天
            #LET l_last_ed =l_last_year,"/",(l_last_month+2),"/",cl_days(l_last_year,l_last_month+2)
            #LET l_last_ed_day =l_last_ed USING "YYMMDD"    #上一季度的最后一天
             LET l_last_bg_day = MDY(l_last_month,1,l_last_year)
             LET l_last_ed_day = MDY((l_last_month+2),cl_days(l_last_year,l_last_month+2),l_last_year)
            #TQC-AC0163 End-----
             IF l_last_bg_day > l_tqu.tqu04 OR l_last_ed_day < l_tqu.tqu03 THEN
                CONTINUE FOREACH
             END IF
#當前季度的第一天和最后一天
            #TQC-AC0163 Begin--- By shi
            #LET l_bg =YEAR(g_today),"/",l_bg_month,"/","01"
            #LET l_bg_day =l_bg USING "YYMMDD"
            #LET l_ed =YEAR(g_today),"/",l_ed_month,"/",cl_days(YEAR(g_today),l_ed_month)
            #LET l_ed_day =l_ed USING "YYMMDD"
             LET l_bg_day = MDY(l_bg_month,1,YEAR(g_today))
             LET l_ed_day = MDY(l_ed_month,cl_days(YEAR(g_today),l_ed_month),YEAR(g_today))
            #TQC-AC0163 End-----
             SELECT COUNT(*) INTO l_n FROM oeb_file,oea_file
              WHERE oea02 BETWEEN l_bg_day AND l_ed_day
                AND oea01 =oeb01
                AND oeb1012 ='Y'
               #AND oeb1003 ='1' #TQC-AC0163 By shi
                AND oeb1003 ='2' #TQC-AC0163 By shi
                AND oea12 =g_oea.oea12
                AND oeb937 =l_tqu.tqu14
             IF l_n =0 THEN
                IF l_last_bg_day < l_tqu.tqu03 THEN
                   LET l_last_bg_day =l_tqu.tqu03
                END IF
                IF l_last_ed_day > l_tqu.tqu04 THEN
                   LET l_last_ed_day =l_tqu.tqu04
                END IF
             ELSE
                CONTINUE FOREACH
             END IF
          ELSE
             IF l_tqu.tqu05 ='3' THEN  #按年返
#取得當年的第一個月和最后一個月
                LET l_bg_month =1
                LET l_ed_month =12
#去年的第一天和最后一天
               #TQC-AC0163 Begin--- By shi
               #LET l_last_bg =YEAR(g_today)-1,"/","01","/","01"
               #LET l_last_bg_day =l_last_bg USING "YYMMDD"
               #LET l_last_ed =YEAR(g_today)-1,"/","12","/","31"
               #LET l_last_ed_day =l_last_ed USING "YYMMDD"
                LET l_last_bg_day = MDY(1,1,YEAR(g_today)-1)
                LET l_last_ed_day = MDY(12,31,YEAR(g_today)-1)
               #TQC-AC0163 End-----
                IF l_last_bg_day > l_tqu.tqu04 OR l_last_ed_day < l_tqu.tqu03 THEN
                   CONTINUE FOREACH
                END IF
#今年的第一天和最后一天
               #TQC-AC0163 Begin--- By shi
               #LET l_bg =YEAR(g_today),"/","01","/","01"
               #LET l_bg_day =l_bg USING "YYMMDD"
               #LET l_ed =YEAR(g_today),"/","12","/","31"
               #LET l_ed_day =l_ed USING "YYMMDD"
                LET l_bg_day = MDY(1,1,YEAR(g_today))
                LET l_ed_day = MDY(12,31,YEAR(g_today))
               #TQC-AC0163 End-----
                SELECT COUNT(*) INTO l_n FROM oeb_file,oea_file
                 WHERE oea02 BETWEEN l_bg_day AND l_ed_day
                   AND oeb01 =oea01
                   AND oeb1012 ='Y'
                  #AND oeb1003 ='1' #TQC-AC0163 By shi
                   AND oeb1003 ='2' #TQC-AC0163 By shi
                   AND oea12 =g_oea.oea12
                   AND oeb937 =l_tqu.tqu14
                IF l_n =0 THEN
                   IF l_last_bg_day < l_tqu.tqu03 THEN
                      LET l_last_bg_day =l_tqu.tqu03
                   END IF
                   IF l_last_ed_day > l_tqu.tqu04 THEN
                      LET l_last_ed_day =l_tqu.tqu04
                   END IF
                ELSE
                   CONTINUE FOREACH
                END IF
             ELSE
                IF l_tqu.tqu05 ='4' THEN  #按起止期間返
                   SELECT COUNT(*) INTO l_n FROM oeb_file,oea_file
                    WHERE oea02 > l_tqu.tqu04
                      AND oeb01 =oea01
                      AND oeb1012 ='Y'
                     #AND oeb1003 ='1' #TQC-AC0163 By shi
                      AND oeb1003 ='2' #TQC-AC0163 By shi
                      AND oea12 =g_oea.oea12
                      AND oeb937 =l_tqu.tqu14
                   IF l_n =0 THEN
                      LET l_last_bg_day =l_tqu.tqu03
                      LET l_last_ed_day =l_tqu.tqu04
                   ELSE
                      CONTINUE FOREACH
                   END IF
                END IF
             END IF
          END IF
       END IF

#抓出上月客戶合同累計出貨金額
       SELECT SUM(ogb12*ogb05_fac),SUM(ogb14),SUM(ogb14t) INTO l_ogb12_sum,l_ogb14_sum,l_ogb14t_sum
        FROM ogb_file,oga_file,oea_file      #TQC-960137 add oea_file
       WHERE oga01 =ogb01
         AND oga00 MATCHES '[12456]'
         AND oga09 MATCHES '[23468]'
         AND oga02 BETWEEN l_last_bg_day AND l_last_ed_day
         AND ogapost ='Y'
         AND ogaconf ='Y'
         AND oea03 =g_oea.oea03
         AND ogb31 =oea01
         AND oea12 =g_oea.oea12
         AND ogb04 =l_tqu.tqu06

#TQC-AA0118 --begin--         
       IF cl_null(l_ogb12_sum) THEN LET l_ogb12_sum = 0 END IF 
       IF cl_null(l_ogb14_sum) THEN LET l_ogb14_sum = 0 END IF 
       IF cl_null(l_ogb14t_sum) THEN LET l_ogb14t_sum = 0 END IF               
#TQC-AA0118 --end--

#抓出上月客戶合同累計銷退金額
       SELECT SUM(ohb12*ohb05_fac),SUM(ohb14),SUM(ohb14t) INTO l_ohb12_sum,l_ohb14_sum,l_ohb14t_sum
         FROM ohb_file,oha_file,oea_file
        WHERE ohb01 =oha01
          AND oha02 BETWEEN l_last_bg_day AND l_last_ed_day
          AND ohaconf ='Y'
          AND ohapost ='Y'
          AND oha03 =g_oea.oea03
          AND ohb33 =oea01
          AND oea12 =g_oea.oea12
          AND ohb04 =l_tqu.tqu06

#TQC-AA0118 --begin--         
       IF cl_null(l_ohb12_sum) THEN LET l_ohb12_sum = 0 END IF 
       IF cl_null(l_ohb14_sum) THEN LET l_ohb14_sum = 0 END IF 
       IF cl_null(l_ohb14t_sum) THEN LET l_ohb14t_sum = 0 END IF               
#TQC-AA0118 --end--

       IF l_tqu.tqu07 ='1' THEN
          SELECT ima25,ima906,ima907,ima908 INTO l_ima25,l_ima906,l_ima907,l_ima908
            FROM ima_file WHERE ima01 =l_tqu.tqu06        

#TQC-AA0118 --begin--            
#             LET l_tqu.tqu08 =l_tqu.tqu08*(l_tqu.tqu10/l_ima25)
#             LET l_tqu.tqu09 =l_tqu.tqu09*(l_tqu.tqu10/l_ima25)
              IF l_tqu.tqu10 = l_ima25 THEN 
                 LET l_factor = 1 
              ELSE
              	 CALL s_umfchk(l_tqu.tqu06,l_ima25,l_tqu.tqu10)
              	    RETURNING l_flag,l_factor 
              	 IF l_flag = 0 THEN 
                    LET l_tqu.tqu08 =l_tqu.tqu08*l_factor
                    LET l_tqu.tqu09 =l_tqu.tqu09*l_factor
              	 ELSE
              		  CALL cl_err('','mfg1206',1)
              		  LET g_success = 'N'
              		  EXIT FOREACH    
              	 END IF        
              END IF    
#TQC-AA0118 --end--   
        
          IF l_tqu.tqu08 <=(l_ogb12_sum -l_ohb12_sum) AND l_tqu.tqu09 >= (l_ogb12_sum-l_ohb12_sum) THEN
             LET l_oeb.oeb01 =l_oeb01
            #SELECT MAX(oeb03) INTO l_oeb.oeb03 FROM oeb_file   #TQC-AC0163 By shi
             SELECT MAX(oeb03)+1 INTO l_oeb.oeb03 FROM oeb_file #TQC-AC0163 By shi
              WHERE oeb01 = l_oeb01
                AND oeb03 < 9001
             IF cl_null(l_oeb.oeb03) THEN
                LET l_oeb.oeb03 ='1'
             END IF
             LET l_oeb.oeb04 =l_tqu.tqu11
             LET l_oeb.oeb05 =l_tqu.tqu13
             LET l_oeb.oeb12 =l_tqu.tqu12
             IF g_sma.sma115 ='Y' THEN
                IF l_ima906 ='1' THEN
                   LET l_oeb.oeb910 =l_oeb.oeb05
                   LET l_oeb.oeb911 ='1'
                   LET l_oeb.oeb912 =l_oeb.oeb12
                ELSE
                   IF l_ima906 ='2' THEN
                      LET l_oeb.oeb910 =l_oeb.oeb05
                      LET l_oeb.oeb911 ='1'
                      LET l_oeb.oeb912 =l_oeb.oeb12
                      LET l_oeb.oeb913 =l_ima907
                      LET l_oeb.oeb914 =l_oeb.oeb913/l_oeb.oeb05
                      LET l_oeb.oeb915 ='0'
                   ELSE
                      IF l_ima906 ='3' THEN
                         LET l_oeb.oeb910 =l_oeb.oeb05
                         LET l_oeb.oeb911 ='1'
                         LET l_oeb.oeb912 =l_oeb.oeb12
                         LET l_oeb.oeb913 =l_ima907
                         LET l_oeb.oeb914 =l_oeb.oeb913/l_oeb.oeb05
                         LET l_oeb.oeb915 =l_oeb.oeb12/l_oeb.oeb914
                      END IF
                   END IF
                END IF
             END IF   #TQC-AA0118   
                IF g_sma.sma116 ='Y' THEN
                   LET l_oeb.oeb916 =l_ima908
                   LET l_oeb.oeb917 =l_oeb.oeb12*(l_oeb.oeb05/l_oeb.oeb16)
                ELSE
                   LET l_oeb.oeb916 =l_oeb.oeb05
                   LET l_oeb.oeb917 =l_oeb.oeb12
                END IF
                LET l_oeb.oeb14 ='0'
                LET l_oeb.oeb14t='0'
               #LET l_oeb.oeb1003 ='1' #TQC-AC0163 By shi
                LET l_oeb.oeb1003 ='2' #TQC-AC0163 By shi
                LET l_oeb.oeb1001 =l_tqu.tqu15
                IF NOT cl_null(l_oeb.oeb916) THEN
                   LET l_unit=l_oeb.oeb916
                ELSE
                   LET l_unit=l_oeb.oeb05
                END IF
                SELECT oeb15 INTO l_oeb.oeb15 FROM oeb_file WHERE oeb01 =l_oeb01 AND oeb04 =l_oeb04
                   AND oeb03 IN (SELECT MIN(oeb03) FROM oeb_file WHERE oeb01 =l_oeb01 AND oeb04 =l_oeb04)
                CALL s_fetch_price_new(g_oea.oea03,l_oeb.oeb04,l_unit,g_oea.oea02,
                                      '1',g_oea.oeaplant,g_oea.oea23,g_oea.oea31,g_oea.oea32,
                                       g_oea.oea01,l_oeb.oeb03,l_oeb.oeb917,l_oeb.oeb1004,'e')
                #  RETURNING l_oeb.oeb13    #FUN-AB0061
                   RETURNING l_oeb.oeb13,l_oeb.oeb37   #FUN-AB0061
                IF l_oeb.oeb13 = 0 THEN CALL s_unitprice_entry(g_oea.oea03,g_oea.oea31,g_oea.oeaplant) END IF #FUN-9C0120
                LET l_oeb.oeb1012 ='Y'
                LET l_oeb.oeb937 =l_tqu.tqu14
         #TQC-AC0163 ------------------STA
         #      LET l_oeb.oeb05_fac=l_oeb.oeb05/l_ima25
                CALL s_umfchk(l_tqu.tqu06,l_oeb.oeb05,l_ima25)
                      RETURNING l_check,l_oeb.oeb05_fac
                IF l_check = '1'  THEN
                   CALL cl_err('','abm-731',0)
                   LET g_success = 'N'
                   EXIT FOREACH
                END IF
                LET l_oeb.oeb13 = '0'
                LET l_oeb.oeb44 = '1'
                LET l_oeb.oeb47 = '0'
                LET l_oeb.oeb48 = '2'
               #TQC-AC0163 Begin--- By shi
                LET l_oeb.oeb70d= ''
                LET l_oeb.oeb72 = ''
                LET l_oeb.oeb902= ''
                LET l_oeb.oeb30 = ''
                LET l_oeb.oebud13 = ''
                LET l_oeb.oebud14 = ''
                LET l_oeb.oebud15 = ''
                LET l_oeb.oeb16 = ''
                LET l_oeb.oeb47 = 0
                SELECT ima02 INTO l_oeb.oeb06 FROM ima_file
                 WHERE ima01=l_oeb.oeb04
               #TQC-AC0163 End-----
         #TQC-AC0163 -------------------END
                LET l_oeb.oeb23    ='0'
                LET l_oeb.oeb24    ='0'
                LET l_oeb.oeb25    ='0'
                LET l_oeb.oeb26    ='0'
                LET l_oeb.oeb70    ='N'
                LET l_oeb.oebplant = g_plant #FUN-980010 add
                LET l_oeb.oeblegal = g_legal #FUN-980010 add
                IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF   #MOD-A10123
                INSERT INTO oeb_file VALUES (l_oeb.*)
                IF STATUS OR SQLCA.SQLCODE THEN
                   CALL cl_err3("ins","oeb_file",l_oeb.oeb01,"",SQLCA.sqlcode,"","",1)
                END IF
#            END IF   #TQC-AA0118
          END IF
       ELSE
          IF l_tqp12 ='1' THEN
             SELECT ima25,ima906,ima907,ima908 INTO l_ima25,l_ima906,l_ima907,l_ima908
               FROM ima_file WHERE ima01 =l_tqu.tqu06
#TQC-AA0118 --begin--            
#             LET l_tqu.tqu08 =l_tqu.tqu08*(l_tqu.tqu10/l_ima25)
#             LET l_tqu.tqu09 =l_tqu.tqu09*(l_tqu.tqu10/l_ima25)
              IF l_tqu.tqu10 = l_ima25 THEN 
                 LET l_factor = 1 
              ELSE
              	 CALL s_umfchk(l_tqu.tqu06,l_ima25,l_tqu.tqu10)
              	    RETURNING l_flag,l_factor 
              	 IF l_flag = 0 THEN 
                    LET l_tqu.tqu08 =l_tqu.tqu08*l_factor
                    LET l_tqu.tqu09 =l_tqu.tqu09*l_factor
              	 ELSE
              		  CALL cl_err('','mfg1206',1)
              		  LET g_success = 'N'
              		  EXIT FOREACH    
              	 END IF        
              END IF    
#TQC-AA0118 --end--             
             IF l_tqu.tqu08 <=(l_ogb14t_sum- l_ohb14t_sum) AND l_tqu.tqu09 >= (l_ogb14t_sum -l_ohb14t_sum) THEN
                LET l_oeb.oeb01 =l_oeb01
               #SELECT MAX(oeb03) INTO l_oeb.oeb03 FROM oeb_file   #TQC-AC0163 By shi
                SELECT MAX(oeb03)+1 INTO l_oeb.oeb03 FROM oeb_file #TQC-AC0163 By shi
                 WHERE oeb01 =l_oeb01
                   AND oeb03 <9001
                IF cl_null(l_oeb.oeb03) THEN
                   LET l_oeb.oeb03 ='1'
                END IF
                LET l_oeb.oeb04 =l_tqu.tqu11
                LET l_oeb.oeb05 =l_tqu.tqu13
                LET l_oeb.oeb12 =l_tqu.tqu12
                IF g_sma.sma115 ='Y' THEN
                   IF l_ima906 ='1' THEN
                      LET l_oeb.oeb910 =l_oeb.oeb05
                      LET l_oeb.oeb911 ='1'
                      LET l_oeb.oeb912 =l_oeb.oeb12
                   ELSE
                      IF l_ima906 ='2' THEN
                         LET l_oeb.oeb910 =l_oeb.oeb05
                         LET l_oeb.oeb911 ='1'
                         LET l_oeb.oeb912 =l_oeb.oeb12
                         LET l_oeb.oeb913 =l_ima907
                         LET l_oeb.oeb914 =l_oeb.oeb913/l_oeb.oeb05
                         LET l_oeb.oeb915 ='0'
                      ELSE
                         IF l_ima906 ='3' THEN
                            LET l_oeb.oeb910 =l_oeb.oeb05
                            LET l_oeb.oeb911 ='1'
                            LET l_oeb.oeb912 =l_oeb.oeb12
                            LET l_oeb.oeb913 =l_ima907
                            LET l_oeb.oeb914 =l_oeb.oeb913/l_oeb.oeb05
                            LET l_oeb.oeb915 =l_oeb.oeb12/l_oeb.oeb914
                         END IF
                      END IF
                   END IF
                 END IF   #TQC-AA0118                    
                   IF g_sma.sma116 ='Y' THEN
                      LET l_oeb.oeb916 =l_ima908
                      LET l_oeb.oeb917 =l_oeb.oeb12*(l_oeb.oeb05/l_oeb.oeb16)
                   ELSE
                      LET l_oeb.oeb916 =l_oeb.oeb05
                      LET l_oeb.oeb917 =l_oeb.oeb12
                   END IF
                   
                   LET l_oeb.oeb14 ='0'
                   LET l_oeb.oeb14t='0'
                  #LET l_oeb.oeb1003 ='1' #TQC-AC0163 By shi
                   LET l_oeb.oeb1003 ='2' #TQC-AC0163 By shi
                   LET l_oeb.oeb1001 =l_tqu.tqu15
                   IF NOT cl_null(l_oeb.oeb916) THEN
                      LET l_unit=l_oeb.oeb916
                   ELSE
                      LET l_unit=l_oeb.oeb05
                   END IF
                   SELECT oeb15 INTO l_oeb.oeb15 FROM oeb_file WHERE oeb01 =l_oeb01 AND oeb04 =l_oeb04
                      AND oeb03 IN (SELECT MIN(oeb03) FROM oeb_file WHERE oeb01 =l_oeb01 AND oeb04 =l_oeb04)
                   CALL s_fetch_price_new(g_oea.oea03,l_oeb.oeb04,l_unit,g_oea.oea02,
                                         '1',g_oea.oeaplant,g_oea.oea23,g_oea.oea31,g_oea.oea32,
                                          g_oea.oea01,l_oeb.oeb03,l_oeb.oeb917,l_oeb.oeb1004,'e')
                   #  RETURNING l_oeb.oeb13    #FUN-AB0061
                      RETURNING l_oeb.oeb13,l_oeb.oeb37   #FUN-AB0061
                   IF l_oeb.oeb13 = 0 THEN CALL s_unitprice_entry(g_oea.oea03,g_oea.oea31,g_oea.oeaplant) END IF #FUN-9C0120
                   LET l_oeb.oeb1012 ='Y'
                   LET l_oeb.oeb937 =l_tqu.tqu14
         #TQC-AC0163 ------------------STA
         #         LET l_oeb.oeb05_fac=l_oeb.oeb05/l_ima25
                   CALL s_umfchk(l_tqu.tqu06,l_oeb.oeb05,l_ima25)
                        RETURNING l_check,l_oeb.oeb05_fac
                   IF l_check = '1'  THEN
                      CALL cl_err('','abm-731',0)
                      LET g_success = 'N'
                      EXIT FOREACH
                   END IF
                   LET l_oeb.oeb13 = '0'
                   LET l_oeb.oeb44 = '1'
                   LET l_oeb.oeb47 = '0'
                   LET l_oeb.oeb48 = '2'
                  #TQC-AC0163 Begin--- By shi
                   LET l_oeb.oeb70d= ''
                   LET l_oeb.oeb72 = ''
                   LET l_oeb.oeb902= ''
                   LET l_oeb.oeb30 = ''
                   LET l_oeb.oebud13 = ''
                   LET l_oeb.oebud14 = ''
                   LET l_oeb.oebud15 = ''
                   LET l_oeb.oeb16 = ''
                   LET l_oeb.oeb47 = 0
                   SELECT ima02 INTO l_oeb.oeb06 FROM ima_file
                    WHERE ima01=l_oeb.oeb04
                  #TQC-AC0163 End-----
         #TQC-AC0163 -------------------END
                   LET l_oeb.oeb23    ='0'
                   LET l_oeb.oeb24    ='0'
                   LET l_oeb.oeb25    ='0'
                   LET l_oeb.oeb26    ='0'
                   LET l_oeb.oeb70    ='N'
                   LET l_oeb.oebplant = g_plant #FUN-980010 add
                   LET l_oeb.oeblegal = g_legal #FUN-980010 add
                   IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF   #MOD-A10123
                   INSERT INTO oeb_file VALUES (l_oeb.*)
                   IF STATUS OR SQLCA.SQLCODE THEN
                      CALL cl_err3("ins","oeb_file",l_oeb.oeb01,"",SQLCA.sqlcode,"","",1)
                   END IF
#               END IF    #TQC-AA0118 mark
             END IF
          ELSE
             SELECT ima25,ima906,ima907,ima908 INTO l_ima25,l_ima906,l_ima907,l_ima908
               FROM ima_file WHERE ima01 =l_tqu.tqu06
#TQC-AA0118 --begin--            
#             LET l_tqu.tqu08 =l_tqu.tqu08*(l_tqu.tqu10/l_ima25)
#             LET l_tqu.tqu09 =l_tqu.tqu09*(l_tqu.tqu10/l_ima25)
              IF l_tqu.tqu10 = l_ima25 THEN 
                 LET l_factor = 1 
              ELSE
              	 CALL s_umfchk(l_tqu.tqu06,l_ima25,l_tqu.tqu10)
              	    RETURNING l_flag,l_factor 
              	 IF l_flag = 0 THEN 
                    LET l_tqu.tqu08 =l_tqu.tqu08*l_factor
                    LET l_tqu.tqu09 =l_tqu.tqu09*l_factor
              	 ELSE
              		  CALL cl_err('','mfg1206',1)
              		  LET g_success = 'N'
              		  EXIT FOREACH    
              	 END IF        
              END IF    
#TQC-AA0118 --end--             
             IF l_tqu.tqu08 <=(l_ogb14_sum-l_ohb14_sum) AND l_tqu.tqu09 >= (l_ogb14_sum-l_ohb14_sum) THEN
                LET l_oeb.oeb01 =l_oeb01
               #SELECT MAX(oeb03) INTO l_oeb.oeb03 FROM oeb_file   #TQC-AC0163 By shi
                SELECT MAX(oeb03)+1 INTO l_oeb.oeb03 FROM oeb_file #TQC-AC0163 By shi
                 WHERE oeb01 =l_oeb01
                   AND oeb03 <9001
                IF cl_null(l_oeb.oeb03) THEN
                   LET l_oeb.oeb03 ='1'
                END IF
                LET l_oeb.oeb04 =l_tqu.tqu11
                LET l_oeb.oeb05 =l_tqu.tqu13
                LET l_oeb.oeb12 =l_tqu.tqu12
                IF g_sma.sma115 ='Y' THEN
                   IF l_ima906 ='1' THEN
                      LET l_oeb.oeb910 =l_oeb.oeb05
                      LET l_oeb.oeb911 ='1'
                      LET l_oeb.oeb912 =l_oeb.oeb12
                   ELSE
                      IF l_ima906 ='2' THEN
                         LET l_oeb.oeb910 =l_oeb.oeb05
                         LET l_oeb.oeb911 ='1'
                         LET l_oeb.oeb912 =l_oeb.oeb12
                         LET l_oeb.oeb913 =l_ima907
                         LET l_oeb.oeb914 =l_oeb.oeb913/l_oeb.oeb05
                         LET l_oeb.oeb915 ='0'
                      ELSE
                         IF l_ima906 ='3' THEN
                            LET l_oeb.oeb910 =l_oeb.oeb05
                            LET l_oeb.oeb911 ='1'
                            LET l_oeb.oeb912 =l_oeb.oeb12
                            LET l_oeb.oeb913 =l_ima907
                            LET l_oeb.oeb914 =l_oeb.oeb913/l_oeb.oeb05
                            LET l_oeb.oeb915 =l_oeb.oeb12/l_oeb.oeb914
                         END IF
                      END IF
                   END IF
                END IF   #TQC-AA0118                       
                   IF g_sma.sma116 ='Y' THEN
                      LET l_oeb.oeb916 =l_ima908
                      LET l_oeb.oeb917 =l_oeb.oeb12*(l_oeb.oeb05/l_oeb.oeb16)
                   ELSE
                      LET l_oeb.oeb916 =l_oeb.oeb05
                      LET l_oeb.oeb917 =l_oeb.oeb12
                   END IF
                   LET l_oeb.oeb14 ='0'
                   LET l_oeb.oeb14t='0'
                  #LET l_oeb.oeb1003 ='1' #TQC-AC0163 By shi
                   LET l_oeb.oeb1003 ='2' #TQC-AC0163 By shi
                   LET l_oeb.oeb1001 =l_tqu.tqu15
                   IF NOT cl_null(l_oeb.oeb916) THEN
                      LET l_unit=l_oeb.oeb916
                   ELSE
                      LET l_unit=l_oeb.oeb05
                   END IF
                   SELECT oeb15 INTO l_oeb.oeb15 FROM oeb_file WHERE oeb01 =l_oeb01 AND oeb04 =l_oeb04
                      AND oeb03 IN (SELECT MIN(oeb03) FROM oeb_file WHERE oeb01 =l_oeb01 AND oeb04 =l_oeb04)
                   CALL s_fetch_price_new(g_oea.oea03,l_oeb.oeb04,l_unit,g_oea.oea02,
                                         '1',g_oea.oeaplant,g_oea.oea23,g_oea.oea31,g_oea.oea32,
                                          g_oea.oea01,l_oeb.oeb03,l_oeb.oeb917,l_oeb.oeb1004,'e')
                   #  RETURNING l_oeb.oeb13    #FUN-AB0061
                      RETURNING l_oeb.oeb13,l_oeb.oeb37   #FUN-AB0061
                   IF l_oeb.oeb13 = 0 THEN CALL s_unitprice_entry(g_oea.oea03,g_oea.oea31,g_oea.oeaplant) END IF #FUN-9C0120
                   LET l_oeb.oeb1012 ='Y'
                   LET l_oeb.oeb937 =l_tqu.tqu14
         #TQC-AC0163 ------------------STA
         #         LET l_oeb.oeb05_fac=l_oeb.oeb05/l_ima25
                   CALL s_umfchk(l_tqu.tqu06,l_oeb.oeb05,l_ima25)
                        RETURNING l_check,l_oeb.oeb05_fac
                   IF l_check = '1'  THEN
                      CALL cl_err('','abm-731',0)
                      LET g_success = 'N'
                      EXIT FOREACH
                   END IF
                   LET l_oeb.oeb13 = '0'
                   LET l_oeb.oeb44 = '1'
                   LET l_oeb.oeb47 = '0'
                   LET l_oeb.oeb48 = '2'
                  #TQC-AC0163 Begin--- By shi
                   LET l_oeb.oeb70d= ''
                   LET l_oeb.oeb72 = ''
                   LET l_oeb.oeb902= ''
                   LET l_oeb.oeb30 = ''
                   LET l_oeb.oebud13 = ''
                   LET l_oeb.oebud14 = ''
                   LET l_oeb.oebud15 = ''
                   LET l_oeb.oeb16 = ''
                   LET l_oeb.oeb47 = 0
                   SELECT ima02 INTO l_oeb.oeb06 FROM ima_file
                    WHERE ima01=l_oeb.oeb04
                  #TQC-AC0163 End-----
         #TQC-AC0163 -------------------END
                   LET l_oeb.oeb23    ='0'
                   LET l_oeb.oeb24    ='0'
                   LET l_oeb.oeb25    ='0'
                   LET l_oeb.oeb26    ='0'
                   LET l_oeb.oeb70    ='N'
                   LET l_oeb.oebplant = g_plant #FUN-980010 add
                   LET l_oeb.oeblegal = g_legal #FUN-980010 add
                   IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF   #MOD-A10123
                   INSERT INTO oeb_file VALUES (l_oeb.*)
                   IF STATUS OR SQLCA.SQLCODE THEN
                      CALL cl_err3("ins","oeb_file",l_oeb.oeb01,"",SQLCA.sqlcode,"","",1)
                   END IF
#               END IF    #TQC-AA0118 
             END IF
          END IF
       END IF
    END FOREACH

#TQC-AA0118 --begin--            
    IF g_success = 'N' THEN 
      RETURN 
    END IF   
#TQC-AA0118 --end--   

#最后產生訂單未返需補返的資料
#抓出訂單未返需補返資料檔中未結案且需補返數量大于0的資料

#TQC-AA0118 --begin--
#    LET l_sql ="SELECT try_file.*",
#               " FROM tqr_file ",
#               " WHERE try04-try10 >0",
#               "   AND try08 ='N'",
#               "   AND (try07 ='",g_oea.oea12,"' OR try07 IS NULL"

    LET l_sql ="SELECT try_file.* FROM try_file ",
               " WHERE try04-try10 >0",
               "   AND try08 ='N'",
               "   AND (try07 ='",g_oea.oea12,"' OR try07 IS NULL)"
#TQC-AA0118 --end--               
    PREPARE t400_obj_pb4 FROM l_sql
    DECLARE t400_obj_cs4 CURSOR FOR t400_obj_pb4
    FOREACH t400_obj_cs4 INTO l_try.*
       SELECT ima25,ima906,ima907,ima908 INTO l_ima25,l_ima906,l_ima907,l_ima908
         FROM ima_file WHERE ima01 =l_try.try03
       LET l_oeb.oeb01 =l_oeb01
      #SELECT MAX(oeb03) INTO l_oeb.oeb03 FROM oeb_file   #TQC-AC0163 By shi
       SELECT MAX(oeb03)+1 INTO l_oeb.oeb03 FROM oeb_file #TQC-AC0163 By shi
        WHERE oeb01 =l_oeb01
          AND oeb03 <9001
       IF cl_null(l_oeb.oeb03) THEN
          LET l_oeb.oeb03 ='1'
       END IF
       LET l_oeb.oeb04 =l_try.try03
       LET l_oeb.oeb05 =l_try.try05
       LET l_oeb.oeb12 =l_try.try04
       IF g_sma.sma115 ='Y' THEN
          IF l_ima906 ='1' THEN
             LET l_oeb.oeb910 =l_oeb.oeb05
             LET l_oeb.oeb911 ='1'
             LET l_oeb.oeb912 =l_oeb.oeb12
          ELSE
             IF l_ima906 ='2' THEN
                LET l_oeb.oeb910 =l_oeb.oeb05
                LET l_oeb.oeb911 ='1'
                LET l_oeb.oeb912 =l_oeb.oeb12
                LET l_oeb.oeb913 =l_ima907
                LET l_oeb.oeb914 =l_oeb.oeb913/l_oeb.oeb05
                LET l_oeb.oeb915 ='0'
             ELSE
                IF l_ima906 ='3' THEN
                   LET l_oeb.oeb910 =l_oeb.oeb05
                   LET l_oeb.oeb911 ='1'
                   LET l_oeb.oeb912 =l_oeb.oeb12
                   LET l_oeb.oeb913 =l_ima907
                   LET l_oeb.oeb914 =l_oeb.oeb913/l_oeb.oeb05
                   LET l_oeb.oeb915 =l_oeb.oeb12/l_oeb.oeb914
                END IF
             END IF
          END IF
       END IF
       IF g_sma.sma116 ='Y' THEN
          LET l_oeb.oeb916 =l_ima908
          LET l_oeb.oeb917 =l_oeb.oeb12*(l_oeb.oeb05/l_oeb.oeb16)
       ELSE
          LET l_oeb.oeb916 =l_oeb.oeb05
          LET l_oeb.oeb917 =l_oeb.oeb12
       END IF
       LET l_oeb.oeb14 ='0'
       LET l_oeb.oeb14t='0'
      #LET l_oeb.oeb1003 ='1' #TQC-AC0163 By shi
       LET l_oeb.oeb1003 ='2' #TQC-AC0163 By shi
       LET l_oeb.oeb1001 =l_try.try09
       IF NOT cl_null(l_oeb.oeb916) THEN
          LET l_unit=l_oeb.oeb916
       ELSE
          LET l_unit=l_oeb.oeb05
       END IF
       SELECT oeb15 INTO l_oeb.oeb15 FROM oeb_file WHERE oeb01 =l_oeb01 AND oeb04 =l_oeb04
          AND oeb03 IN (SELECT MIN(oeb03) FROM oeb_file WHERE oeb01 =l_oeb01 AND oeb04 =l_oeb04)
       CALL s_fetch_price_new(g_oea.oea03,l_oeb.oeb04,l_unit,g_oea.oea02,
                             '1',g_oea.oeaplant,g_oea.oea23,g_oea.oea31,g_oea.oea32,
                              g_oea.oea01,l_oeb.oeb03,l_oeb.oeb917,l_oeb.oeb1004,'e')
       #  RETURNING l_oeb.oeb13    #FUN-AB0061
          RETURNING l_oeb.oeb13,l_oeb.oeb37   #FUN-AB0061
       IF l_oeb.oeb13 = 0 THEN CALL s_unitprice_entry(g_oea.oea03,g_oea.oea31,g_oea.oeaplant) END IF #FUN-9C0120
       LET l_oeb.oeb1012 ='Y'
       LET l_oeb.oeb937 =l_try.try08
       LET l_oeb.oeb935 =l_try.try01
       LET l_oeb.oeb936 =l_try.try02
#TQC-AC0163 ------------------STA
#      LET l_oeb.oeb05_fac=l_oeb.oeb05/l_ima25
       CALL s_umfchk(l_try.try03,l_oeb.oeb05,l_ima25)
            RETURNING l_check,l_oeb.oeb05_fac
       IF l_check = '1'  THEN
           CALL cl_err('','abm-731',0)
           EXIT FOREACH
       END IF
       LET l_oeb.oeb13 = '0'
       LET l_oeb.oeb44 = '1'
       LET l_oeb.oeb47 = '0'
       LET l_oeb.oeb48 = '2'
      #TQC-AC0163 Begin--- By shi
       LET l_oeb.oeb70d= ''
       LET l_oeb.oeb72 = ''
       LET l_oeb.oeb902= ''
       LET l_oeb.oeb30 = ''
       LET l_oeb.oebud13 = ''
       LET l_oeb.oebud14 = ''
       LET l_oeb.oebud15 = ''
       LET l_oeb.oeb16 = ''
       LET l_oeb.oeb47 = 0
       SELECT ima02 INTO l_oeb.oeb06 FROM ima_file
        WHERE ima01=l_oeb.oeb04
      #TQC-AC0163 End-----
#TQC-AC0163 -------------------END
       LET l_oeb.oeb23    ='0'
       LET l_oeb.oeb24    ='0'
       LET l_oeb.oeb25    ='0'
       LET l_oeb.oeb26    ='0'
       LET l_oeb.oeb70    ='N'
       LET l_oeb.oebplant = g_plant #FUN-980010 add
       LET l_oeb.oeblegal = g_legal #FUN-980010 add
       IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF   #MOD-A10123
       INSERT INTO oeb_file VALUES (l_oeb.*)
       IF STATUS OR SQLCA.SQLCODE THEN
          CALL cl_err3("ins","oeb_file",l_oeb.oeb01,"",SQLCA.sqlcode,"","",1)
       END IF
       IF l_try.try10+l_oeb.oeb12 >=l_try.try04 THEN
          UPDATE try_file SET try10 =try10+l_oeb.oeb12,try06 ='Y'
           WHERE try01 =l_oeb.oeb935
             AND try02 =l_oeb.oeb936
       ELSE
          UPDATE try_file SET try10 =try10+l_oeb.oeb12,try06 ='N'
           WHERE try01 =l_oeb.oeb935
             AND try02 =l_oeb.oeb936
       END IF
    END FOREACH
    CALL t400_b_fill(" 1=1") #TQC-AC0163 By shi
END FUNCTION

FUNCTION t400_oea03(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
DEFINE l_occ71 LIKE occ_file.occ71
DEFINE l_occ72 LIKE occ_file.occ72

   SELECT occ71,occ72 INTO l_occ71,l_occ72 FROM occ_file
    WHERE occ01=g_oea.oea03 AND occ1004='1'
   IF SQLCA.sqlcode=100 THEN
      LET l_occ71=NULL
      LET l_occ72=NULL
   END IF
   IF p_cmd='d' THEN
      LET g_oea.oea85=l_occ71
      LET g_oea.oea161=l_occ72
      LET g_oea.oea162=100-g_oea.oea161
      DISPLAY BY NAME g_oea.oea85,g_oea.oea161,g_oea.oea162
   END IF
END FUNCTION

FUNCTION t400_oea83(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
DEFINE l_azp02 LIKE azp_file.azp02

   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=g_oea.oea83
   CASE
        WHEN SQLCA.sqlcode=100   LET g_errno = 'art-002'
                                 LET l_azp02 = NULL
        OTHERWISE
        LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF cl_null(g_errno) OR p_cmd='d' THEN
      DISPLAY l_azp02 TO FORMONLY.oea83_desc
   END IF

END FUNCTION

FUNCTION t400_oea84(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
DEFINE l_azp02 LIKE azp_file.azp02

   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=g_oea.oea84
   CASE
        WHEN SQLCA.sqlcode=100   LET g_errno = 'art-002'
                                 LET l_azp02 = NULL
        OTHERWISE
        LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF cl_null(g_errno) OR p_cmd='d' THEN
      DISPLAY l_azp02 TO FORMONLY.oea84_desc
   END IF
END FUNCTION

FUNCTION t400_chk_oeb04()
DEFINE l_rty05 LIKE rty_file.rty05
DEFINE l_rtt01 LIKE rtt_file.rtt01
DEFINE l_rtt11 LIKE rtt_file.rtt11
DEFINE l_rtv12 LIKE rtv_file.rtv12
DEFINE l_rtu08 LIKE rtu_file.rtu08
DEFINE l_rtu01 LIKE rtu_file.rtu01
DEFINE l_occ930 LIKE occ_file.occ930
DEFINE lc_type LIKE type_file.chr1
DEFINE li_result LIKE type_file.num5

   SELECT rty06 INTO g_oeb[l_ac].oeb44 FROM rty_file WHERE rty01=g_plant
    AND rty02=g_oeb[l_ac].oeb04 AND rtyacti="Y"
   IF SQLCA.sqlcode=100 THEN LET g_oeb[l_ac].oeb44=NULL END IF
   IF cl_null(g_oeb[l_ac].oeb44) THEN
#TQC-A80141 --begin--   
#      CALL cl_err(g_oeb[l_ac].oeb44,'art-510',0)
#      RETURN 1
       LET g_oeb[l_ac].oeb44 = '1' 
       CALL cl_err('','axm-384',0)
#TQC-A80141 --end--
   END IF
   
   IF g_oeb[l_ac].oeb44='3' OR g_oeb[l_ac].oeb44='4' THEN
      SELECT rty05 INTO l_rty05 FROM rty_file WHERE rty01=g_plant
         AND rty02=g_oeb[l_ac].oeb04 AND rtyacti="Y"
      IF NOT cl_null(l_rty05) THEN
         SELECT rtt01,rtt11 INTO l_rtt01,l_rtt11 FROM rtt_file,rts_file,rto_file
          WHERE rts01 = rtt01 AND rttplant = rtsplant
           AND rts02 = rtt02 AND rtt04 =g_oeb[l_ac].oeb04 AND rto01 = rts04 AND rtoplant = rtsplant
           AND rto05 = l_rty05  AND rto06 = g_oeb[l_ac].oeb44 AND rto08<=g_oea.oea02
           AND rto09>=g_oea.oea02 AND rtt15="Y"
           AND rtoconf = 'Y' AND rtsconf = 'Y' AND rto03 = rts02 AND rtoplant =  g_plant
         IF NOT cl_null(l_rtt01) THEN
            SELECT rtv12,rtu08,rtu01 INTO l_rtv12,l_rtu08,l_rtu01 FROM rtv_file,rtu_file,rtt_file
             WHERE rtt01=rtu04 AND rtt02=rtu02 AND rttplant=rtuplant AND rtuplant=g_plant
              AND rtuconf="Y" AND rtuplant=rtvplant AND rtu01=rtv01 AND rtu02=rtv02
              AND rtt01=l_rtt01 AND rtu05=l_rty05 AND rtu06=g_oeb[l_ac].oeb44
              AND rtv04=g_oeb[l_ac].oeb04
            IF NOT cl_null(l_rtu01) THEN
               LET g_oeb[l_ac].oeb45=l_rtv12
            ELSE
               LET g_oeb[l_ac].oeb45=l_rtt11
            END IF
         END IF
      END IF
   ELSE
      LET g_oeb[l_ac].oeb45=NULL
   END IF
   LET g_oeb[l_ac].oeb46=g_oeb[l_ac].oeb45  #新扣率
   CALL cl_set_comp_entry("oeb46",false)
   RETURN 0
END FUNCTION

FUNCTION t400_upd_try(p_oeb935,p_oeb936,p_oeb12,p_oeb05,p_oeb1012)
DEFINE l_try04     LIKE try_file.try04
DEFINE l_try05     LIKE try_file.try05
DEFINE l_try10     LIKE try_file.try10
DEFINE p_oeb935    LIKE oeb_file.oeb935
DEFINE p_oeb936    LIKE oeb_file.oeb936
DEFINE p_oeb12     LIKE oeb_file.oeb12
DEFINE p_oeb05     LIKE oeb_file.oeb05
DEFINE p_oeb1012   LIKE oeb_file.oeb1012

    IF (NOT cl_null(p_oeb935))
       AND (NOT cl_null(p_oeb936))
       AND p_oeb1012 ='Y'
       AND g_aza.aza50 ='Y'
       AND g_prog ='axmt410' THEN

       SELECT try05 INTO l_try05
         FROM try_file
        WHERE try01 =p_oeb935
          AND try02 =p_oeb936

       UPDATE try_file SET try10 =try10 -p_oeb12*p_oeb05/l_try05
        WHERE try01 =p_oeb935
          AND try02 =p_oeb936

       SELECT try04,try10 INTO l_try04,l_try10
         FROM try_file
        WHERE try01 =p_oeb935
          AND try02 =p_oeb936
       IF l_try10 <0 THEN
          LET l_try10 =0
       END IF

       IF l_try10 >=l_try04 THEN
          UPDATE try_file SET try06 ='Y',try10 =l_try10
           WHERE try01 =p_oeb935
             AND try02 =p_oeb936
       ELSE
          UPDATE try_file SET try06 ='N',try10 =l_try10
           WHERE try01 =p_oeb935
             AND try02 =p_oeb936
       END IF
    END IF
END FUNCTION

FUNCTION t400_amount(p_qty,p_price,p_rate,p_azi03)
DEFINE   p_qty       LIKE oeb_file.oeb12    #數量
DEFINE   p_price     LIKE oeb_file.oeb13    #單價(未折扣)
DEFINE   p_rate      LIKE oeb_file.oeb1006  #折扣率
DEFINE   p_azi03     LIKE azi_file.azi03    #單價取位位數
DEFINE   l_price     LIKE oeb_file.oeb13    #單價(已折扣)
DEFINE   l_amount    LIKE oeb_file.oeb14    #金額

    IF cl_null(p_rate) THEN
       LET p_rate = 100
    END IF
   #LET l_price = cl_digcut(p_price*p_rate/100,p_azi03)     #折扣后的單價且已取位。#TQC-AB0204
    LET l_price = p_price                               #TQC-AB0204
    LET l_amount= p_qty*l_price
    IF cl_null(l_amount) THEN
       LET l_amount = 0
    END IF
    RETURN l_amount
END FUNCTION

FUNCTION t400_chk_oeb904()
 DEFINE l_poy02  LIKE poy_file.poy02
 DEFINE l_poy04  LIKE poy_file.poy04

    LET g_errno=''
    IF g_oea.oea904 IS NOT NULL AND g_oea.oea901='Y' THEN
       SELECT MAX(poy02) INTO l_poy02 FROM poy_file
        WHERE poy01 = g_oea.oea904
           SELECT poy04 INTO l_poy04 FROM poy_file
            WHERE poy01 = g_oea.oea904 AND poy02 = l_poy02
            IF STATUS THEN LET l_poy04 = '' LET g_errno='axm-934' RETURN END IF
            IF l_poy04 <> g_plant OR l_poy02=99 THEN  #有最終供應商或不是最終站訂單
               LET g_errno='axm-934'
               RETURN
            END IF
    ELSE
       LET g_errno='axm-934'
    END IF
END FUNCTION
FUNCTION t400_fetch_price(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1
DEFINE l_oeb05         LIKE oeb_file.oeb05
DEFINE l_occ930        LIKE occ_file.occ930
DEFINE lc_type         LIKE type_file.chr1
DEFINE li_ret          LIKE type_file.num5
DEFINE l_oah04         LIKE oah_file.oah04   #NO.FUN-9B0025
     IF g_sma.sma116 MATCHES '[23]' AND NOT cl_null(g_oeb[l_ac].oeb916) THEN
        LET l_oeb05=g_oeb[l_ac].oeb916
     ELSE
        LET l_oeb05=g_oeb[l_ac].oeb05
     END IF
    #FUN-AC0012 Begin---
    #IF (cl_null(g_oeb[l_ac].oeb13) OR g_oeb[l_ac].oeb13 = 0 ) AND g_oeb_t.oeb12 <> g_oeb[l_ac].oeb12 THEN
     IF (cl_null(g_oeb[l_ac].oeb13) OR g_oeb[l_ac].oeb13 = 0 ) OR
        g_oeb_t.oeb12 <> g_oeb[l_ac].oeb12 OR p_cmd='d' THEN
    #FUN-AC0012 End-----
         CALL s_fetch_price_new(g_oea.oea03,g_oeb[l_ac].oeb04,g_oeb[l_ac].oeb05,
                               g_oea.oea02,'1',g_oea.oeaplant,g_oea.oea23,g_oea.oea31,
                               g_oea.oea32,g_oea.oea01,g_oeb[l_ac].oeb03,g_oeb[l_ac].oeb12,g_oeb[l_ac].oeb1004,p_cmd)
          # RETURNING g_oeb[l_ac].oeb13  #FUN-AB0061
            RETURNING g_oeb[l_ac].oeb13,g_oeb[l_ac].oeb37   #FUN-AB0061 
       #TQC-AB0204 Begin---
        LET g_oeb17 = g_oeb[l_ac].oeb13
        LET b_oeb.oeb17 = g_oeb[l_ac].oeb13
        IF g_oeb17 <> g_oeb17_t OR cl_null(g_oeb17) OR g_oeb17=0 THEN
           LET g_oeb[l_ac].oeb1006 = 100
           DISPLAY BY NAME g_oeb[l_ac].oeb1006
        END IF
        LET g_oeb[l_ac].oeb13 = g_oeb[l_ac].oeb13 * g_oeb[l_ac].oeb1006/100
       #TQC-AB0204 End-----
     END IF 
         IF g_oeb[l_ac].oeb13 = 0 THEN CALL s_unitprice_entry(g_oea.oea03,g_oea.oea31,g_oea.oeaplant) END IF #FUN-9C0120
     IF g_oea.oea213 = 'N' THEN
        LET g_oeb[l_ac].oeb14 = t400_amount(g_oeb[l_ac].oeb917,g_oeb[l_ac].oeb13,g_oeb[l_ac].oeb1006,t_azi03)
        CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04)  RETURNING g_oeb[l_ac].oeb14
        LET g_oeb[l_ac].oeb14t= g_oeb[l_ac].oeb14*(1+ g_oea.oea211/100)
        CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t
     ELSE
        LET g_oeb[l_ac].oeb14t= t400_amount(g_oeb[l_ac].oeb917,g_oeb[l_ac].oeb13,g_oeb[l_ac].oeb1006,t_azi03)
        CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t
        LET g_oeb[l_ac].oeb14 = g_oeb[l_ac].oeb14t/(1+ g_oea.oea211/100)
        CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04)  RETURNING g_oeb[l_ac].oeb14
     END IF
           SELECT DISTINCT oah04 INTO l_oah04 FROM oah_file WHERE oah01 = g_oea.oea31
           IF l_oah04 = 'Y' AND (cl_null(g_oeb[l_ac].oeb13) OR g_oeb[l_ac].oeb13 = 0) THEN
              CALL cl_set_comp_entry("oeb13,oeb14,oeb14t",TRUE)
           ELSE
              CALL cl_set_comp_entry("oeb13,oeb14,oeb14t",FALSE)
           END IF
END FUNCTION
# No.FUN-9C0073 ------------------By chenls 10/01/08

#No.FUN-A10014  --Begin
FUNCTION t400_g_b3()
   DEFINE l_ohb        RECORD LIKE ohb_file.*
   DEFINE l_oeb        RECORD LIKE oeb_file.*
   DEFINE l_oga910     LIKE oga_file.oga910
   DEFINE l_oga911     LIKE oga_file.oga911
   DEFINE l_oeb12_tot  LIKE oeb_file.oeb12
   DEFINE l_oeb912_tot LIKE oeb_file.oeb912
   DEFINE l_oeb915_tot LIKE oeb_file.oeb915
   DEFINE l_oeb917_tot LIKE oeb_file.oeb917

   IF g_oea.oea11 != '2' THEN RETURN END IF

   SELECT COUNT(*) INTO g_cnt FROM oeb_file
    WHERE oeb01 = g_oea.oea01

   IF g_cnt > 0 THEN RETURN END IF

   #此销退单是否已经对应换货订单
   SELECT COUNT(*) INTO g_cnt FROM oea_file
    WHERE oea12=g_oea.oea12
      AND oea11=g_oea.oea11
      AND oeaconf !='X'
      AND oea01 <> g_oea.oea01
   IF g_cnt > 0 THEN
      RETURN
   END IF

   IF NOT cl_confirm('axm-840') THEN
      RETURN
   END IF

   DECLARE ohb_cs CURSOR FOR
     SELECT * FROM ohb_file WHERE ohb01 = g_oea.oea12

   FOREACH ohb_cs INTO l_ohb.*
      INITIALIZE l_oeb.* TO NULL
      LET l_oeb.oeb01  = g_oea.oea01          #订单单号
      LET l_oeb.oeb03  = l_ohb.ohb03          #项次
      LET l_oeb.oeb04  = l_ohb.ohb04          #产品编号
      LET l_oeb.oeb05  = l_ohb.ohb05          #销售单位
      LET l_oeb.oeb05_fac = l_ohb.ohb05_fac   #销售/库存单位换算率
      LET l_oeb.oeb06  = l_ohb.ohb06    #品名规格
      LET l_oeb.oeb07  = l_ohb.ohb07    #额外品名编号
      LET l_oeb.oeb08  = l_ohb.ohb08    #出货营运中心
      LET l_oeb.oeb09  = l_ohb.ohb09    #出货仓库
      LET l_oeb.oeb091 = l_ohb.ohb091   #出货储位
      LET l_oeb.oeb092 = l_ohb.ohb092   #出货批号
      LET l_oeb.oeb11  = l_ohb.ohb11    #客户产品编号
      LET l_oeb.oeb12  = l_ohb.ohb12    #数量
      LET l_oeb.oeb13  = l_ohb.ohb13    #单价
      LET l_oeb.oeb37  = l_ohb.ohb37    #FUN-AB0061 基础单价
      LET l_oeb.oeb14  = l_ohb.ohb14    #未税金额
      LET l_oeb.oeb14t = l_ohb.ohb14t   #含税金额
      LET l_oeb.oeb15  = g_today        #约定交货日
      LET l_oeb.oeb16  = g_today        #排定交货日
      LET l_oeb.oeb17  = l_oeb.oeb13    #取出单价
      LET l_oeb.oeb18  = NULL           #出货地点
      LET l_oeb.oeb19  = 'N'            #备置否
      LET l_oeb.oeb20  = NULL           #交运方式
      LET l_oeb.oeb21  = NULL           #价格条件
      LET l_oeb.oeb22  = NULL           #版本
      LET l_oeb.oeb23  = 0              #待出货数量
      LET l_oeb.oeb24  = 0              #已出货数量
      LET l_oeb.oeb25  = 0              #已销退数量
      LET l_oeb.oeb26  = 0              #被结案数量
      LET l_oeb.oeb70  = 'N'            #结案否
      LET l_oeb.oeb70d = NULL           #结案日期
      LET l_oeb.oeb71  = l_ohb.ohb03    #合约项次/估价项次/报价项次
      LET l_oeb.oeb72  = NULL           #No Use
      LET l_oeb.oeb901 = 0              #已包装数:出货时需减出货量
      LET l_oeb.oeb902 = NULL           #包装日期
      LET l_oeb.oeb903 = 0              #累积包装量
      LET l_oeb.oeb904 = 0              #议价单价(BI)
      LET l_oeb.oeb905 = 0              #己备置量
      LET l_oeb.oeb906 = 'N'            #检验否
      LET l_oeb.oeb907 = NULL           #No Use
      LET l_oeb.oeb908 = l_ohb.ohb52    #海关手册编号
      LET l_oeb.oeb909 = NULL           #No Use
      LET l_oeb.oeb910 = l_ohb.ohb910   #单位一
      LET l_oeb.oeb911 = l_ohb.ohb911   #单位一换算率(与销售单位)
      LET l_oeb.oeb912 = l_ohb.ohb912   #单位一数量
      LET l_oeb.oeb913 = l_ohb.ohb913   #单位二
      LET l_oeb.oeb914 = l_ohb.ohb914   #单位二换算率(与销售单位)
      LET l_oeb.oeb915 = l_ohb.ohb915   #单位二数量
      LET l_oeb.oeb916 = l_ohb.ohb916   #计价单位
      LET l_oeb.oeb917 = l_ohb.ohb917   #计价数量*/
      LET l_oeb.oeb1001= l_ohb.ohb50    #原因码
      LET l_oeb.oeb1002= l_ohb.ohb1001  #订价编号
      LET l_oeb.oeb1003= '1'            #作业方式
      LET l_oeb.oeb1004= l_ohb.ohb1002  #提案编号
      LET l_oeb.oeb1005= NULL           #订价群组
      LET l_oeb.oeb1006= l_ohb.ohb1003  #折扣率
      LET l_oeb.oeb1007= l_ohb.ohb1007  #现金折扣单号
      LET l_oeb.oeb1008= l_ohb.ohb1008  #税别
      LET l_oeb.oeb1009= l_ohb.ohb1009  #税率
      LET l_oeb.oeb1010= l_ohb.ohb1010  #含税否
      LET l_oeb.oeb1011= l_ohb.ohb1011  #非直营KAB
      LET l_oeb.oeb1012= l_ohb.ohb1004  #搭赠
      LET l_oeb.oeb920 = 0              #已分配量
      LET l_oeb.oeb1013= 0              #本次应返金额
      LET l_oeb.oeb930 = l_ohb.ohb930   #成本中心
      LET l_oeb.oeb27  = NULL           #请购单号
      LET l_oeb.oeb28  = 0              #已转请购量
      LET l_oeb.oeb29  = 0              #偿价数量
      LET l_oeb.oeb30  = NULL           #预计规还日期
      LET l_oeb.oeb31  = NULL           #展延原因码
      LET l_oeb.oeb41  = NULL           #专案代号
      LET l_oeb.oeb42  = NULL           #WBS编号
      LET l_oeb.oeb43  = NULL           #活动代号
      LET l_oeb.oeb935 = l_ohb.ohb33    #补返来源订单单号
      LET l_oeb.oeb936 = l_ohb.ohb34    #补返来源订单项次
      LET l_oeb.oeb937 = NULL           #物返条件来源合同项次
      LET l_oeb.oeb931 = NULL           #包装编号
      LET l_oeb.oeb932 = 0              #包装数量
      LET l_oeb.oeb933 = NULL           #末维属性组
      LET l_oeb.oeb934 = NULL           #属性群组
      LET l_oeb.oebplant = g_plant      #所屬工廠
      LET l_oeb.oeblegal = g_legal      #所屬法人
      LET l_oeb.oeb44  = l_ohb.ohb64    #經營方式
      LET l_oeb.oeb45  = l_ohb.ohb65    #原扣率
      LET l_oeb.oeb46  = l_ohb.ohb66    #新扣率
      LET l_oeb.oeb47  = l_ohb.ohb67    #分攤折價=全部折價字段值的合
      IF g_azw.azw04="2" THEN
         LET l_oeb.oeb48  = '2'         #出貨方式 1.訂貨 2.現貨
      ELSE
         LET l_oeb.oeb48  = '1'         #出貨方式 1.訂貨 2.現貨
      END IF

      IF cl_null(l_oeb.oeb916) THEN
         LET l_oeb.oeb916=l_oeb.oeb05
         LET l_oeb.oeb917=l_oeb.oeb12
      END IF
      IF cl_null(l_oeb.oeb091) THEN LET l_oeb.oeb091=' ' END IF
      IF cl_null(l_oeb.oeb092) THEN LET l_oeb.oeb092=' ' END IF
      IF cl_null(l_oeb.oeb1012) THEN LET l_oeb.oeb1012 = 'N' END IF

      IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF   #MOD-A10123
      INSERT INTO oeb_file VALUES (l_oeb.*)
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("ins","oeb_file",l_oeb.oeb01,"",STATUS,"","ins oeb:",1)
         EXIT FOREACH
      END IF
   END FOREACH

END FUNCTION
#No.FUN-A10014  --End

#FUN-A30072--end--add-----------

#-----No:FUN-A50103-----
FUNCTION t400_multi_account(l_oeaa02)
   DEFINE l_oeaa02        LIKE oeaa_file.oeaa02
   DEFINE l_oeaa          DYNAMIC ARRAY OF RECORD
          oeaa03             LIKE oeaa_file.oeaa03,
          oeaa04             LIKE oeaa_file.oeaa04,
          oag02              LIKE oag_file.oag02,
          oeaa05             LIKE oeaa_file.oeaa05,
          oeaa06             LIKE oeaa_file.oeaa06,
          oeaa07             LIKE oeaa_file.oeaa07,
          oeaa08             LIKE oeaa_file.oeaa08 
                          END RECORD
   DEFINE l_oeaa_t        RECORD
          oeaa03             LIKE oeaa_file.oeaa03,
          oeaa04             LIKE oeaa_file.oeaa04,
          oag02              LIKE oag_file.oag02,
          oeaa05             LIKE oeaa_file.oeaa05,
          oeaa06             LIKE oeaa_file.oeaa06,
          oeaa07             LIKE oeaa_file.oeaa07,
          oeaa08             LIKE oeaa_file.oeaa08 
                          END RECORD
   DEFINE p_cmd           LIKE type_file.chr1 
   DEFINE l_rec_b         LIKE type_file.num5
   DEFINE l_n             LIKE type_file.num5
   DEFINE l_ac            LIKE type_file.num5
   DEFINE l_ac_t          LIKE type_file.num5
   DEFINE l_cnt           LIKE type_file.num5
   DEFINE l_oeaa08        LIKE oeaa_file.oeaa08
   DEFINE l_p_amt         LIKE oea_file.oea161
   DEFINE l_allow_insert  LIKE type_file.num5
   DEFINE l_allow_delete  LIKE type_file.num5

   IF cl_null(g_oea.oea01) THEN
      RETURN
   END IF

   IF l_oeaa02 = '1' AND g_oea.oea261 = 0 THEN
      RETURN
   END IF

   IF l_oeaa02 = '2' AND g_oea.oea263 = 0 THEN
      RETURN
   END IF

   OPEN WINDOW t410_m_w WITH FORM "axm/42f/axmt410_m"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("axmt410_m")

   LET g_sql = "SELECT oeaa03,oeaa04,oag02,oeaa05,oeaa06,oeaa07,oeaa08 ", 
               "  FROM oeaa_file LEFT OUTER JOIN oag_file ON oag01=oeaa04 ",
               " WHERE oeaa01 = '",g_oea.oea01,"' ",
               "   AND oeaa02 = '",l_oeaa02,"' ",
               " ORDER BY oeaa03 "

   PREPARE axmt410_m_pre FROM g_sql

   DECLARE axmt410_m_c CURSOR FOR axmt410_m_pre

   CALL l_oeaa.clear()

   LET l_cnt = 1

   FOREACH axmt410_m_c INTO l_oeaa[l_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach oeaa',STATUS,0)
         EXIT FOREACH
      END IF

      LET l_cnt = l_cnt + 1

   END FOREACH

   CALL l_oeaa.deleteElement(l_cnt)

   LET l_rec_b = l_cnt - 1
   DISPLAY l_rec_b TO FORMONLY.cn2

   LET l_ac = 1

   IF l_oeaa02 = '1' THEN
      LET l_p_amt = g_oea.oea261
   ELSE
      LET l_p_amt = g_oea.oea263
   END IF

   DISPLAY l_oeaa02 TO FORMONLY.oeaa02
   DISPLAY l_p_amt TO FORMONLY.p_amt

   CALL cl_set_act_visible("cancel", FALSE)

   IF g_oea.oeaconf !="N" THEN   #已確認或作廢單據只能查詢 
      DISPLAY ARRAY l_oeaa TO s_oeaa.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)

         ON ACTION CONTROLG
            CALL cl_cmdask()
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
         
         ON ACTION about
            CALL cl_about()
         
         ON ACTION help
            CALL cl_show_help()

      END DISPLAY
   ELSE
      LET g_forupd_sql = "SELECT oeaa03,oeaa04,'',oeaa05,oeaa06,oeaa07,oeaa08 ", 
                         "  FROM oeaa_file ",
                         " WHERE oeaa01 = '",g_oea.oea01,"' ",
                         "   AND oeaa02 = '",l_oeaa02,"' ",
                         "   AND oeaa03 = ? ",
                         "  FOR UPDATE "

      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

      DECLARE t410_m_bc1 CURSOR FROM g_forupd_sql 
    
      WHILE TRUE
         LET l_allow_insert = cl_detail_input_auth("insert")
         LET l_allow_delete = cl_detail_input_auth("delete")

         INPUT ARRAY l_oeaa WITHOUT DEFAULTS FROM s_oeaa.*
               ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                         INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                         APPEND ROW=l_allow_insert)
         
            BEFORE INPUT     
               IF l_rec_b != 0 THEN
                  CALL fgl_set_arr_curr(l_ac)
               END IF
               
            BEFORE ROW            
               LET p_cmd = ''
               LET l_ac = ARR_CURR()
               BEGIN WORK
               IF l_rec_b >= l_ac THEN 
                  LET p_cmd = 'u'
                  LET l_oeaa_t.* = l_oeaa[l_ac].* 
                  OPEN t410_m_bc1 USING l_oeaa_t.oeaa03
                  IF STATUS THEN
                     CALL cl_err("OPEN t410_m_bc1:", STATUS, 1)
                  ELSE
                     FETCH t410_m_bc1 INTO l_oeaa[l_ac].*
                     IF SQLCA.sqlcode THEN
                        CALL cl_err(l_oeaa_t.oeaa03,SQLCA.sqlcode,1)
                     END IF
                     IF NOT cl_null(l_oeaa[l_ac].oeaa04) THEN
                        SELECT oag02 INTO l_oeaa[l_ac].oag02 FROM oag_file 
                         WHERE oag01=l_oeaa[l_ac].oeaa04
                     END IF
                  END IF
               END IF
            
            BEFORE INSERT
               LET p_cmd = 'a'
               INITIALIZE l_oeaa[l_ac].* TO NULL
               LET l_oeaa[l_ac].oeaa08 = 0
               LET l_oeaa_t.* = l_oeaa[l_ac].* 
               NEXT FIELD oeaa03
         
            AFTER INSERT
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  CANCEL INSERT
               END IF
               INSERT INTO oeaa_file(oeaa01,oeaa02,oeaa03,oeaa04,oeaa05,oeaa06,oeaa07,
                                     oeaa08,oeaaplant,oeaalegal)
                              VALUES(g_oea.oea01,l_oeaa02,l_oeaa[l_ac].oeaa03,
                                     l_oeaa[l_ac].oeaa04,l_oeaa[l_ac].oeaa05,
                                     l_oeaa[l_ac].oeaa06,l_oeaa[l_ac].oeaa07,
                                     l_oeaa[l_ac].oeaa08,g_plant,g_legal)
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","oeaa_file",g_oea.oea01,l_oeaa[l_ac].oeaa03,SQLCA.sqlcode,"","",1)  
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  LET l_rec_b=l_rec_b+1
                  DISPLAY l_rec_b TO FORMONLY.cn2  
                  COMMIT WORK
               END IF
         
            ON ROW CHANGE
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  LET l_oeaa[l_ac].* = l_oeaa_t.*
                  CLOSE t410_m_bc1
                  ROLLBACK WORK
                  EXIT INPUT
               END IF
           
               UPDATE oeaa_file SET oeaa03 = l_oeaa[l_ac].oeaa03, 
                                    oeaa04 = l_oeaa[l_ac].oeaa04, 
                                    oeaa05 = l_oeaa[l_ac].oeaa05, 
                                    oeaa06 = l_oeaa[l_ac].oeaa06, 
                                    oeaa07 = l_oeaa[l_ac].oeaa07, 
                                    oeaa08 = l_oeaa[l_ac].oeaa08  
                WHERE oeaa01 = g_oea.oea01
                  AND oeaa02 = l_oeaa02
                  AND oeaa03 = l_oeaa_t.oeaa03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","oeaa_file",g_oea.oea01,l_oeaa_t.oeaa03,SQLCA.sqlcode,"","",1)  
                  LET l_oeaa[l_ac].* = l_oeaa_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
         
            AFTER ROW
               LET l_ac = ARR_CURR()
               LET l_ac_t = l_ac 
               IF INT_FLAG THEN 
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  IF p_cmd = 'u' THEN
                     LET l_oeaa[l_ac].* = l_oeaa_t.*
                  END IF
                  CLOSE t410_m_bc1 
                  ROLLBACK WORK 
                  EXIT INPUT
               END IF
               CLOSE t410_m_bc1 
               COMMIT WORK
         
            BEFORE DELETE                            #是否取消單身
               IF l_oeaa_t.oeaa03 IS NOT NULL THEN
                  IF NOT cl_delete() THEN
                    CANCEL DELETE
                  END IF
                  DELETE FROM oeaa_file 
                   WHERE oeaa01 = g_oea.oea01
                     AND oeaa02 = l_oeaa02
                     AND oeaa03 = l_oeaa_t.oeaa03
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","oeaa_file",g_oea.oea01,l_oeaa_t.oeaa03,SQLCA.sqlcode,"","",1) 
                     EXIT INPUT
                  END IF
                  LET l_rec_b=l_rec_b-1
                  DISPLAY l_rec_b TO FORMONLY.cn2  
                  COMMIT WORK
               END IF
         
            BEFORE FIELD oeaa03
               IF cl_null(l_oeaa[l_ac].oeaa03) OR l_oeaa[l_ac].oeaa03 = 0 THEN
                  SELECT MAX(oeaa03)+1 INTO l_oeaa[l_ac].oeaa03
                    FROM oeaa_file
                   WHERE oeaa01 = g_oea.oea01
                     AND oeaa02 = l_oeaa02
                  IF cl_null(l_oeaa[l_ac].oeaa03) THEN
                     LET l_oeaa[l_ac].oeaa03 = 1
                  END IF
               END IF
         
            AFTER FIELD oeaa03
               IF NOT cl_null(l_oeaa[l_ac].oeaa03) THEN
                  IF l_oeaa[l_ac].oeaa03 != l_oeaa_t.oeaa03 OR cl_null(l_oeaa_t.oeaa03) THEN
                     SELECT COUNT(*) INTO l_n
                       FROM oeaa_file
                      WHERE oeaa01 = g_oea.oea01
                        AND oeaa02 = l_oeaa02
                        AND oeaa03 = l_oeaa[l_ac].oeaa03
                     IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET l_oeaa[l_ac].oeaa03 = l_oeaa_t.oeaa03
                        NEXT FIELD oeaa03
                     END IF
                  END IF
               END IF
         
            AFTER FIELD oeaa04
               IF NOT cl_null(l_oeaa[l_ac].oeaa04) THEN                                                       
                  IF l_oeaa[l_ac].oeaa04 != l_oeaa_t.oeaa04 OR cl_null(l_oeaa_t.oeaa04) THEN                                                                         
                     SELECT COUNT(*) INTO l_n                                                                                          
                       FROM oeaa_file                                                                                                   
                      WHERE oeaa01 = g_oea.oea01                                                   
                        AND oeaa02 = l_oeaa02
                        AND oeaa04 = l_oeaa[l_ac].oeaa04
                     IF l_n > 0 THEN                                                                                                   
                        CALL cl_err(l_oeaa[l_ac].oeaa04,-239,0)                                                                                         
                        LET l_oeaa[l_ac].oeaa04 = l_oeaa_t.oeaa04                                                                        
                        NEXT FIELD oeaa04                                                                                              
                     END IF                                                                                                            

                     SELECT oag02 INTO l_oeaa[l_ac].oag02 FROM oag_file 
                      WHERE oag01=l_oeaa[l_ac].oeaa04                                                         
                     IF STATUS THEN                                                                                                      
                        CALL cl_err3("sel","oag_file",l_oeaa[l_ac].oeaa03,"",STATUS,"","select oag",1)                                                     
                        NEXT FIELD oeaa04                                                                                
                     END IF                                                                                                                 
                 
                     CALL s_rdatem(g_oea.oea03,l_oeaa[l_ac].oeaa04,g_oea.oea02,g_oea.oea02,g_oea.oea02,g_plant)
                         RETURNING l_oeaa[l_ac].oeaa05,l_oeaa[l_ac].oeaa06                                                                          
                     LET l_oeaa[l_ac].oeaa07 = g_oea.oea24
                  END IF                       
               END IF    
         
            ON ACTION controlp
               CASE
                  WHEN INFIELD(oeaa04)                                                                                                  
                       CALL cl_init_qry_var()                                                                                          
                       LET g_qryparam.form ="q_oag"                                                                                    
                       LET g_qryparam.default1 = l_oeaa[l_ac].oeaa04
                       CALL cl_create_qry() RETURNING l_oeaa[l_ac].oeaa04
                       DISPLAY BY NAME l_oeaa[l_ac].oeaa04
                       NEXT FIELD oeaa04 
                  OTHERWISE EXIT CASE
               END CASE
         
            ON ACTION locale
               CALL cl_dynamic_locale()
               CALL cl_show_fld_cont()    
         
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
         
            ON ACTION controlg 
               CALL cl_cmdask()
         
            ON ACTION about 
               CALL cl_about()
         
            ON ACTION help
               CALL cl_show_help()
         
            ON ACTION CONTROLF
               CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
               CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
         
            ON ACTION CONTROLR 
               CALL cl_show_req_fields() 
         
            ON ACTION exit
               EXIT INPUT
         
         END INPUT
        
         SELECT SUM(oeaa08) INTO l_oeaa08 FROM oeaa_file                                                            
          WHERE oeaa01 = g_oea.oea01                                                                                                  
            AND oeaa02 = l_oeaa02
         IF l_oeaa08 <> l_p_amt THEN
            CALL cl_err('','axm-961',1)                                                                                                    
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF                
      END WHILE
   END IF
 
   CLOSE WINDOW t410_m_w

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

END FUNCTION

FUNCTION t400_ins_oeaa()
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_cnt1    LIKE type_file.num5
   DEFINE l_oeaa    RECORD LIKE oeaa_file.*
   DEFINE g_oas     RECORD LIKE oas_file.*
   DEFINE l_oeaa03  LIKE oeaa_file.oeaa03
   DEFINE l_oeaa08  LIKE oeaa_file.oeaa08
 
   SELECT COUNT(*) INTO l_cnt   #訂金多期 
     FROM oeaa_file
    WHERE oeaa01 = g_oea.oea01
      AND oeaa02 = '1'    
 
   SELECT COUNT(*) INTO l_cnt1  #尾款多期
     FROM oeaa_file
    WHERE oeaa01 = g_oea.oea01
      AND oeaa02 = '2'    
 
   #-----No:FUN-AA0038-----
   IF l_cnt > 0 OR l_cnt1 > 0 THEN   #已有訂金/尾款子帳期資料
      IF l_cnt > 1 OR l_cnt1 > 1 THEN   #已有訂金/尾款子帳期資料 
         IF NOT cl_confirm('axm-962') THEN 
            RETURN
         END IF
      END IF
      #訂金子帳期資料
      DELETE FROM oeaa_file
       WHERE oeaa01 = g_oea.oea01
         AND oeaa02 = '1'
      IF STATUS THEN 
         CALL cl_err3("del","oeaa_file",l_oeaa.oeaa01,l_oeaa.oeaa02,SQLCA.sqlcode,"","",1)
         RETURN
      END IF

      DELETE FROM oeaa_file
       WHERE oeaa01 = g_oea.oea01
         AND oeaa02 = '2'
      IF STATUS THEN 
         CALL cl_err3("del","oeaa_file",l_oeaa.oeaa01,l_oeaa.oeaa02,SQLCA.sqlcode,"","",1)
         RETURN
      END IF
   END IF
   #-----No:FUN-AA0038 END-----

   LET l_cnt = 0                     #MOD-B20125

   SELECT COUNT(*) INTO l_cnt
     FROM oas_file
    WHERE oas01 = g_oea.oea80
   
   #無子收款條件時，產生一筆多帳期資料
   IF l_cnt = 0 THEN
      LET l_oeaa.oeaa01 = g_oea.oea01
      LET l_oeaa.oeaa02 = '1'
      LET l_oeaa.oeaa03 = 1
      LET l_oeaa.oeaa04 = g_oea.oea80
   
      CALL s_rdatem(g_oea.oea03,l_oeaa.oeaa04,g_oea.oea02,g_oea.oea02,g_oea.oea02,g_plant)
          RETURNING l_oeaa.oeaa05,l_oeaa.oeaa06                                                                          
   
      LET l_oeaa.oeaa07 = g_oea.oea24
      LET l_oeaa.oeaa08 = g_oea.oea261
      LET l_oeaa.oeaaplant = g_plant 
      LET l_oeaa.oeaalegal = g_legal 
   
      INSERT INTO oeaa_file VALUES(l_oeaa.*)
      IF STATUS THEN 
         CALL cl_err3("ins","oeaa_file",l_oeaa.oeaa01,l_oeaa.oeaa02,SQLCA.sqlcode,"","",1)
#        RETURN
      END IF
   ELSE
      LET g_sql = "SELECT oas01,oas02,oas03,oas04,oas05",
                  "  FROM oas_file ", 
                  " WHERE oas01 = '",g_oea.oea80,"'"
   
      PREPARE t410_oasp1 FROM g_sql
      DECLARE t410_oas1 CURSOR FOR t410_oasp1
   
      FOREACH t410_oas1 INTO g_oas.oas01,g_oas.oas02,g_oas.oas03,g_oas.oas04,g_oas.oas05
   
         LET l_oeaa.oeaa01 = g_oea.oea01
         LET l_oeaa.oeaa02 = '1'
         LET l_oeaa.oeaa03 = g_oas.oas03
         LET l_oeaa.oeaa04 = g_oas.oas04
   
         CALL s_rdatem(g_oea.oea03,l_oeaa.oeaa04,g_oea.oea02,g_oea.oea02,g_oea.oea02,g_plant)
             RETURNING l_oeaa.oeaa05,l_oeaa.oeaa06                                                                          
   
         LET l_oeaa.oeaa07 = g_oea.oea24
         LET l_oeaa.oeaa08 = g_oea.oea261 * g_oas.oas05/100
         LET l_oeaa.oeaaplant = g_plant 
         LET l_oeaa.oeaalegal = g_legal 
   
         IF cl_null(l_oeaa.oeaa08) THEN
            LET l_oeaa.oeaa08 = 0
         END IF
         
         INSERT INTO oeaa_file VALUES(l_oeaa.*)
         IF STATUS THEN
            CALL cl_err3("ins","oeaa_file",l_oeaa.oeaa01,l_oeaa.oeaa02,SQLCA.sqlcode,"","",1)
#           RETURN
         END IF
      END FOREACH
   END IF
   
   #尾差放入最入一筆
   SELECT SUM(oeaa08),MAX(oeaa03) INTO l_oeaa08,l_oeaa03
     FROM oeaa_file
    WHERE oeaa01 = g_oea.oea01
      AND oeaa02 = '1'
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","oeaa_file",g_oea.oea01,"",SQLCA.sqlcode,"","",1)
#     RETURN
   END IF
   
   IF cl_null(l_oeaa08) THEN
      LET l_oeaa08 = 0
   END IF
   
   IF l_oeaa08 <> g_oea.oea261 THEN
      UPDATE oeaa_file SET oeaa08 = oeaa08-(l_oeaa08-g_oea.oea261)
       WHERE oeaa01 = g_oea.oea01
         AND oeaa02 = '1'
         AND oeaa02 = l_oeaa03
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","oeaa_file",g_oea.oea01,l_oeaa03,SQLCA.sqlcode,"","",1)
#        RETURN
      END IF
   END IF       
 
   LET l_cnt = 0                     #MOD-B20125

   #尾款子帳期資料
   SELECT COUNT(*) INTO l_cnt
     FROM oas_file
    WHERE oas01 = g_oea.oea81
   
   #無子收款條件時，產生一筆多帳期資料
   IF l_cnt = 0 THEN
      LET l_oeaa.oeaa01 = g_oea.oea01
      LET l_oeaa.oeaa02 = '2'
      LET l_oeaa.oeaa03 = 1
      LET l_oeaa.oeaa04 = g_oea.oea81
   
      CALL s_rdatem(g_oea.oea03,l_oeaa.oeaa04,g_oea.oea02,g_oea.oea02,g_oea.oea02,g_plant)
          RETURNING l_oeaa.oeaa05,l_oeaa.oeaa06                                                                          
   
      LET l_oeaa.oeaa07 = g_oea.oea24
      LET l_oeaa.oeaa08 = g_oea.oea263
      LET l_oeaa.oeaaplant = g_plant 
      LET l_oeaa.oeaalegal = g_legal 
   
      INSERT INTO oeaa_file VALUES(l_oeaa.*)
      IF STATUS THEN 
         CALL cl_err3("ins","oeaa_file",l_oeaa.oeaa01,l_oeaa.oeaa02,SQLCA.sqlcode,"","",1)
#        RETURN
      END IF
   ELSE
      LET g_sql = "SELECT oas01,oas02,oas03,oas04,oas05",
                  "  FROM oas_file ", 
                  " WHERE oas01 = '",g_oea.oea81,"'"
   
      PREPARE t410_oasp2 FROM g_sql
      DECLARE t410_oas2 CURSOR FOR t410_oasp2
   
      FOREACH t410_oas2 INTO g_oas.oas01,g_oas.oas02,g_oas.oas03,g_oas.oas04,g_oas.oas05
   
         LET l_oeaa.oeaa01 = g_oea.oea01
         LET l_oeaa.oeaa02 = '2'
         LET l_oeaa.oeaa03 = g_oas.oas03
         LET l_oeaa.oeaa04 = g_oas.oas04
   
         CALL s_rdatem(g_oea.oea03,l_oeaa.oeaa04,g_oea.oea02,g_oea.oea02,g_oea.oea02,g_plant)
             RETURNING l_oeaa.oeaa05,l_oeaa.oeaa06                                                                          
   
         LET l_oeaa.oeaa07 = g_oea.oea24
         LET l_oeaa.oeaa08 = g_oea.oea263 * g_oas.oas05/100
         LET l_oeaa.oeaaplant = g_plant 
         LET l_oeaa.oeaalegal = g_legal 
   
         IF cl_null(l_oeaa.oeaa08) THEN
            LET l_oeaa.oeaa08 = 0
         END IF
         
         INSERT INTO oeaa_file VALUES(l_oeaa.*)
         IF STATUS THEN
            CALL cl_err3("ins","oeaa_file",l_oeaa.oeaa01,l_oeaa.oeaa02,SQLCA.sqlcode,"","",1)
#           RETURN
         END IF
      END FOREACH
   END IF
   
   #尾差放入最入一筆
   SELECT SUM(oeaa08),MAX(oeaa03) INTO l_oeaa08,l_oeaa03
     FROM oeaa_file
    WHERE oeaa01 = g_oea.oea01
      AND oeaa02 = '2'
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","oeaa_file",g_oea.oea01,"",SQLCA.sqlcode,"","",1)
#     RETURN
   END IF
   
   IF cl_null(l_oeaa08) THEN
      LET l_oeaa08 = 0
   END IF
   
   IF l_oeaa08 <> g_oea.oea263 THEN
      UPDATE oeaa_file SET oeaa08 = oeaa08-(l_oeaa08-g_oea.oea263)
       WHERE oeaa01 = g_oea.oea01
         AND oeaa02 = '2'
         AND oeaa02 = l_oeaa03
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","oeaa_file",g_oea.oea01,l_oeaa03,SQLCA.sqlcode,"","",1)
#        RETURN
      END IF
   END IF       

END FUNCTION
#FUN-A80054-begin--add---------------
FUNCTION t400_oea01()
    IF NOT cl_null(g_oeb[l_ac].oeb04) AND cl_null(g_oeb[l_ac].oeb918) THEN
       DECLARE eda_cs CURSOR FOR
        SELECT eda01 FROM eda_file,edb_file
         WHERE edb03=g_oeb[l_ac].oeb04
           AND edb01=eda01 AND eda03='Y' AND edaconf='Y'
         ORDER BY eda01
       FOREACH eda_cs INTO g_oeb[l_ac].oeb918
          EXIT FOREACH
       END FOREACH
    END IF
END FUNCTION
#FUN-A80054--end--add--------------
#-----No:FUN-A50103 END-----

#FUN-A80121  ..begin

FUNCTION t400_multi_ima01()        
DEFINE   tok         base.StringTokenizer
DEFINE   l_sql       STRING
DEFINE   l_n         LIKE type_file.num5
DEFINE   l_plant     LIKE azw_file.azw01
DEFINE   l_unit      LIKE oeb_file.oeb05
DEFINE   g_cnt       LIKE type_file.num5 
DEFINE   l_oeb       RECORD LIKE oeb_file.*
DEFINE
  l_cnt, li_i                 LIKE type_file.num5,    
  l_misc                      LIKE type_file.chr4,      
  l_qty                       LIKE type_file.num10,   
  p_cmd                       LIKE type_file.chr1,   
  l_ima135                    LIKE ima_file.ima135,
  l_ima1002                   LIKE ima_file.ima1002,
  l_ima35                     LIKE ima_file.ima35,
  l_ima36                     LIKE ima_file.ima36,
  l_tuo03                     LIKE tuo_file.tuo03,   
  l_tuo031                    LIKE tuo_file.tuo031,  
  l_occ1028                   LIKE occ_file.occ1028,
  l_ima1010                   LIKE ima_file.ima1010,
  l_ima25                     LIKE ima_file.ima25,     #ima單位
  l_ima31                     LIKE ima_file.ima31,
  l_ima130                    LIKE ima_file.ima130,
  l_ima906                    LIKE ima_file.ima906,
  l_ima907                    LIKE ima_file.ima907,
  l_factor                    LIKE ima_file.ima31_fac,
  l_tot                       LIKE img_file.img10,
  l_oeo04                     LIKE oeo_file.oeo04,
  l_rtz04                     LIKE rtz_file.rtz04, 
  l_rte05                     LIKE rte_file.rte05, 
  l_rte07                     LIKE rte_file.rte07,
  l_oeb05                     LIKE oeb_file.oeb05,
  l_rtdconf                   LIKE rtd_file.rtdconf,
  l_idr04                     LIKE idr_file.idr04,
  i                           LIKE type_file.num5     #FUN-B10010
#FUN-AA0089 add begin-----
DEFINE   l_rty05     LIKE rty_file.rty05,
         l_rtt01     LIKE rtt_file.rtt01,                                                                                                  
         l_rtt11     LIKE rtt_file.rtt11,
         l_rtv12     LIKE rtv_file.rtv12, 
         l_rtu01     LIKE rtu_file.rtu01,
         l_ima908    LIKE ima_file.ima908          
#FUN-AA0089 add end-----
   LET l_plant = g_plant
   CALL s_showmsg_init()
   LET tok = base.StringTokenizer.create(g_multi_ima01,"|")
   IF g_oea.oea11 = '1' THEN 
   LET i=1                    #FUN-B10010
   WHILE tok.hasMoreTokens()
      LET l_oeb.oeb04 = tok.nextToken()
#NO.FUN-A90048 add -----------start--------------------      
#     IF NOT s_chk_item_no(l_oeb.oeb04,'') THEN
#        CALL s_errmsg('oeb01',l_oeb.oeb04,'INS oeb_file',g_errno,1)
#        CONTINUE WHILE
#     END IF
#NO.FUN-A90048 add ------------end -------------------- 
      LET l_sql="SELECT max(oeb03)+1 FROM ",cl_get_target_table(l_plant,'oeb_file'),
                " WHERE oeb01 = '",g_oea.oea01,"'",
                " AND   oeb03 < 9001 "                #FUN-B10010
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
      PREPARE sel_oeb_pre FROM l_sql
      EXECUTE sel_oeb_pre INTO l_oeb.oeb03
      IF cl_null(l_oeb.oeb03) THEN
         LET  l_oeb.oeb03 = '1'
      END IF
#FUN-B10010--add---begin
      IF i = 1 THEN
         LET l_oeb.oeb49 = g_oeb[l_ac].oeb49
         LET l_oeb.oeb50 = g_oeb[l_ac].oeb50
      ELSE 
         LET l_oeb.oeb49 = NULL
         LET l_oeb.oeb50 =NULL
     END IF
#FUN-B10010--add--end
      LET l_sql="SELECT oea01,oea02,oea59,oea46 FROM ",cl_get_target_table(l_plant,'oea_file'),
                   " WHERE oea01 = '",g_oea.oea01,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
      PREPARE sel_oea_pre FROM l_sql
      EXECUTE sel_oea_pre INTO  l_oeb.oeb01,l_oeb.oeb15,l_oeb.oeb16,l_oeb.oeb41         
      DECLARE oeo_cs1 CURSOR FOR
         SELECT oeo04 FROM oeo_file
         WHERE oeo01 = g_oea.oea01
         AND oeo03 = l_oeb.oeb03
      FOREACH oeo_cs1 INTO l_oeo04
         IF l_oeb.oeb04 = l_oeo04 THEN
            CALL s_errmsg('oeb01',l_oeb.oeb04,'INS oeb_file','axm-091',1)
            CONTINUE WHILE
         END IF
      END FOREACH   
      IF g_oaz.oaz46='Y' THEN		
         LET g_msg=NULL
         SELECT MIN(obk01) INTO g_msg FROM obk_file
         WHERE obk03=l_oeb.oeb04 AND obk02=g_oea.oea03
            AND obk05=g_oea.oea23
         IF STATUS=0 AND g_msg IS NOT NULL THEN 
            LET b_oeb.oeb11 = l_oeb.oeb04
            LET l_oeb.oeb04 = g_msg
         END IF
      END IF
      LET l_misc=l_oeb.oeb04[1,4]
      IF l_oeb.oeb04[1,4]='MISC' THEN  
         SELECT COUNT(*) INTO l_n FROM ima_file
         WHERE ima01=l_misc
         AND ima01='MISC'
         IF l_n=0 THEN
            CALL s_errmsg('oeb01',l_oeb.oeb04,'INS oeb_file','aim-806',1)
            CONTINUE WHILE   
         END IF
      ELSE
#TQC-AA0025 --begin--
         IF g_aza.aza50 = 'Y' THEN 
            SELECT * FROM tqh_file,ima_file
            WHERE tqh02=ima1006
            AND tqhacti='Y'
            AND ima01 = l_oeb.oeb04
            AND tqh01 = g_oea.oea1002
            IF STATUS=100 THEN
              #      CALL cl_err3("sel","tqh_file,ima_file","","","atm-018","","",1)  #FUN-A80121
              #      LET g_success = 'N'                                              #FUN-A80121
              #      EXIT WHILE                                                       #FUN-A80121
            CALL s_errmsg('oeb01',l_oeb.oeb04,'INS oeb_file','atm-018',1)    #FUN-A80121
            CONTINUE WHILE            #FUN-A80121 
            END IF     
         END IF
      END IF    
#TQC-AA0025 --end--
      IF g_aza.aza50 = 'Y' THEN  
         IF l_oeb.oeb04[1,4] != 'MISC' THEN
            IF g_oea.oea00 = '7' THEN
               SELECT tuo03,tuo031
               INTO l_tuo03,l_tuo031
               FROM tuo_file
               WHERE tuo01 = g_oea.oea03
               AND tuo02 = g_oea.oea04
               LET l_oeb.oeb09 = l_tuo03
               LET l_oeb.oeb091= l_tuo031
            END IF
            SELECT ima1002,ima135,ima35,ima36,ima130
            INTO l_ima1002,l_ima135,l_ima35,l_ima36,l_ima130
            FROM ima_file
            WHERE ima01=l_oeb.oeb04
            IF l_oeb.oeb09 IS NULL AND g_oea.oea00 = '7' THEN 
               IF g_azw.azw04='2' THEN
                  SELECT rtz07 INTO l_oeb.oeb09 FROM rtz_file
                  WHERE rtz01 = g_plant
               ELSE
                  LET l_oeb.oeb09=l_ima35
               END IF 
               LET l_oeb.oeb091=l_ima36
            ELSE
               IF g_oea.oea00 <> '7' THEN
                  IF g_azw.azw04='2' THEN
                     SELECT rtz07 INTO l_oeb.oeb09 FROM rtz_file
                     WHERE rtz01 = g_plant
                  ELSE
                     LET l_oeb.oeb09=l_ima35
                  END IF  
                  LET l_oeb.oeb091=l_ima36
               END IF
            END IF
         END IF 
     END IF
     IF g_oea.oea00 MATCHES '[123467]' AND l_ima130 = '0' THEN  
        CALL s_errmsg('oeb01',l_oeb.oeb04,'INS oeb_file','axm-188',1)
        CONTINUE WHILE
     END IF     
    LET l_sql="SELECT ima31,ima31_fac,ima02,ima908 FROM ",cl_get_target_table(l_plant,'ima_file'),
                   " WHERE ima01 = '",l_oeb.oeb04,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_ima31_pre FROM l_sql
         #EXECUTE sel_ima31_pre INTO  l_oeb.oeb05,l_oeb.oeb05_fac,l_oeb.oeb06,l_oeb.oeb916   #FUN-AA0089 mark
         EXECUTE sel_ima31_pre INTO  l_oeb.oeb05,l_oeb.oeb05_fac,l_oeb.oeb06,l_ima908   #FUN-AA0089 modfiy l_oeb.oeb916 to l_ima908
    
      #FUN-AA0089 add start-----------------------
      IF g_sma.sma116 MATCHES '[23]' THEN
            CALL s_chk_va_setting1(l_oeb.oeb04)
                 RETURNING g_flag,l_ima908
            IF g_flag=1 THEN
               CONTINUE WHILE
            END IF
            IF cl_null(l_oeb.oeb916) THEN
               LET l_oeb.oeb916=l_ima908
            END IF
      END IF
      IF cl_null(l_oeb.oeb916) THEN
         LET l_oeb.oeb916=l_oeb.oeb05
      END IF
      #FUN-AA0089 add end-----------------------

      #LET  l_oeb.oeb07 = null    #FUN-AA0089 mark
      SELECT imc02 INTO l_oeb.oeb07 FROM imc_file    #FUN-AA0089 add
       WHERE imc01 = l_oeb.oeb04                  #FUN-AA0089 add   
      LET  l_oeb.oeb08 = null
      LET  l_oeb.oeb092 = null
      LET l_sql="SELECT obk03,obk11 FROM ",cl_get_target_table(l_plant,'obk_file'),
                   " WHERE obk01 = '",l_oeb.oeb04,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_obk_pre FROM l_sql
         EXECUTE sel_obk_pre INTO  l_oeb.oeb11,l_oeb.oeb906
      IF cl_null(l_oeb.oeb906)  THEN
          LET  l_oeb.oeb906 = 'N'
      END IF
#MOD-AC0316 ----------------STA
      IF NOT cl_null(l_oeb.oeb04 )THEN
         IF NOT s_chk_item_no(l_oeb.oeb04,'') THEN
            CALL s_errmsg('oeb01',l_oeb.oeb04,'INS oeb_file',g_errno,1)
            CONTINUE WHILE
         END IF
      END IF
#MOD-AC0316 ----------------END
      LET  l_oeb.oeb12 = '0'
      IF NOT cl_null(l_oeb.oeb04 )THEN
       CALL s_fetch_price_new(g_oea.oea03,b_oeb.oeb04,b_oeb.oeb05,b_oeb.oeb15,g_oea.oea00,					
                                g_plant,g_oea.oea23,g_oea.oea31,g_oea.oea32,g_oea.oea01,					
                                 b_oeb.oeb03,b_oeb.oeb12,b_oeb.oeb1004,'a')					
        # RETURNING l_oeb.oeb13    #FUN-AB0061
          RETURNING l_oeb.oeb13,l_oeb.oeb37   #FUN-AB0061
      END IF


#FUN-AA0089 add Start------------------
     SELECT rty06 INTO l_oeb.oeb44 FROM rty_file
      WHERE rty01 = g_plant AND rty02 = l_oeb.oeb04
     IF cl_null(l_oeb.oeb44) OR STATUS = 100 THEN

        LET l_oeb.oeb44 = 1
     END IF 
     IF l_oeb.oeb44='3' OR l_oeb.oeb44='4' THEN                                                                           
        SELECT rty05 INTO l_rty05 FROM rty_file WHERE rty01=g_plant                                                              
         AND rty02=l_oeb.oeb04 AND rtyacti="Y"     
        IF STATUS THEN
           CALL s_errmsg("",l_oeb.oeb04,"SEL rty05",STATUS,1)   
           CONTINUE WHILE
        END IF                                                                             
        IF NOT cl_null(l_rty05) THEN                                                                                                  
           SELECT rtt01,rtt11 INTO l_rtt01,l_rtt11 FROM rtt_file,rts_file,rto_file                                                    
            WHERE rts01 = rtt01 AND rttplant = rtsplant                                                                                   
             AND rts02 = rtt02 AND rtt04 =l_oeb.oeb04 AND rto01 = rts04 AND rtoplant = rts9plant                                    
             AND rto05 = l_rty05  AND rto06 = l_oeb.oeb44 AND rto08<=g_oea.oea02                                                
             AND rto09>=g_oea.oea02 AND rtt15="Y"                                                                                     
             AND rtoconf = 'Y' AND rtsconf = 'Y' AND rto03 = rts02 AND rtoplant =  g_plant                                         
           IF NOT cl_null(l_rtt01) THEN                                                                                               
              SELECT rtv12,rtu01 INTO l_rtv12,l_rtu01 FROM rtv_file,rtu_file,rtt_file                     
               WHERE rtt01=rtu04 AND rtt02=rtu02 AND rttplant=rtuplant AND rtuplant=g_plant                                            
                 AND rtuconf="Y" AND rtuplant=rtvplant AND rtu01=rtv01 AND rtu02=rtv02                                                     
                 AND rtt01=l_rtt01 AND rtu05=l_rty05 AND rtu06=l_oeb.oeb44                                                       
                 AND rtv04=l_oeb.oeb04                                                                                           
              IF NOT cl_null(l_rtu01) THEN       
                 LET l_oeb.oeb45=l_rtv12                                                                                        
              ELSE                                                                                                                    
                 LET l_oeb.oeb45=l_rtt11                                                                                        
              END IF                                                                                                                  
           END IF                                                                                                                     
        END IF                                                                                                                        
     ELSE                                                                                                                             
        LET l_oeb.oeb45=NULL                                                                                                    
     END IF
     LET l_oeb.oeb46 = l_oeb.oeb45
#FUN-AA0089 add End--------------------      
      LET  l_oeb.oeb14 = '0'
      LET  l_oeb.oeb14t = '0'
      LET  l_oeb.oeb17 = '0'
      LET  l_oeb.oeb18 = null
      LET  l_oeb.oeb19 = 'N'
      LET  l_oeb.oeb20 = null
      LET  l_oeb.oeb21 = null
      LET  l_oeb.oeb22 = null
      LET  l_oeb.oeb23 = '0'
      LET  l_oeb.oeb24 = '0'
      LET  l_oeb.oeb25 = '0'
      LET  l_oeb.oeb26 = '0'
      LET  l_oeb.oeb70 = 'N'
      LET  l_oeb.oeb70d = null
      LET  l_oeb.oeb71 = null
      LET  l_oeb.oeb72 = null
      LET  l_oeb.oeb901 = null
      LET  l_oeb.oeb902 = null
      LET  l_oeb.oeb903 = null
      LET  l_oeb.oeb904 = null
      LET  l_oeb.oeb905 = '0'
      LET  l_oeb.oeb907 = null
      LET  l_oeb.oeb908 = null
      LET  l_oeb.oeb909 = null  
      SELECT ima25,ima31,ima906,ima907
      INTO l_ima25,l_ima31,l_ima906,l_ima907
      FROM ima_file
      WHERE ima01 = l_oeb.oeb04
      IF g_sma.sma115 = 'Y' THEN            #No.TQC-6B0124 add
        IF l_ima906 = '1' THEN  #不使用雙單位
            LET l_oeb.oeb913 = NULL
            LET l_oeb.oeb914 = NULL
            LET l_oeb.oeb915 = NULL
        ELSE
           LET l_oeb.oeb913 = l_ima907
           CALL s_du_umfchk(l_oeb.oeb04,'','','',l_ima31,l_ima907,l_ima906)
               RETURNING g_errno,l_factor
           LET l_oeb.oeb914 = l_factor
           LET l_oeb.oeb915 = 0
        END IF
      END IF  
      LET l_oeb.oeb910 = l_ima31
      LET l_oeb.oeb911 = 1
      LET l_oeb.oeb912 = 0
      IF g_sma.sma115 = 'Y' THEN
         CASE l_ima906
             WHEN '1' LET l_tot=l_oeb.oeb912*l_oeb.oeb911
             WHEN '2' LET l_tot=l_oeb.oeb912*l_oeb.oeb911+l_oeb.oeb914*l_oeb.oeb915
             WHEN '3' LET l_tot=l_oeb.oeb912*l_oeb.oeb911
         END CASE
         CALL s_umfchk(l_oeb.oeb04,l_oeb.oeb05,l_oeb.oeb916)
         RETURNING g_cnt,l_factor
      ELSE  #不使用雙單位
          CALL s_umfchk(l_oeb.oeb04,l_ima31,l_oeb.oeb916)
          RETURNING g_cnt,l_factor
          LET l_tot=l_oeb.oeb912*l_oeb.oeb911
      END IF
      IF cl_null(l_tot) THEN
          LET l_tot = 0
      END IF
      IF g_cnt = 1 THEN
          LET l_factor = 1
      END IF
      LET l_tot = l_tot * l_factor
      LET l_oeb.oeb917 = l_tot
      IF l_oeb.oeb05 = l_oeb.oeb916 AND g_sma.sma115='N' THEN
          LET l_oeb.oeb917 = l_oeb.oeb12
      END IF
      LET  l_oeb.oeb1001 = null
      LET  l_oeb.oeb1002 = null
      LET  l_oeb.oeb1003 = '1'
      LET  l_oeb.oeb1004 = null
      LET  l_oeb.oeb1005 = null
     #LET  l_oeb.oeb1006 = '0'    #No.TQC-AA0128
      LET  l_oeb.oeb1006 = 100    #No.TQC-AA0128
      LET  l_oeb.oeb1007 = null
      LET  l_oeb.oeb1008 = null
      LET  l_oeb.oeb1009 = null
      LET  l_oeb.oeb1010 = null
      LET  l_oeb.oeb1011 = null
      LET  l_oeb.oeb1012 = 'N'
      LET  l_oeb.oeb920 = '0'
      LET  l_oeb.oeb1013 = null
      LET  l_oeb.oeb930 = s_costcenter(g_oea.oea15)
      LET  l_oeb.oeb27 = null
      LET  l_oeb.oeb28 = '0'
      LET  l_oeb.oeb29 = '0'
      LET  l_oeb.oeb30 = null
      LET  l_oeb.oeb31 = null
      LET  l_oeb.oeb42 = null
      LET  l_oeb.oeb43 = null
      LET  l_oeb.oeb935 = null
      LET  l_oeb.oeb936 = null
      LET  l_oeb.oeb937 = null
      LET  l_oeb.oeb931 = null
      LET  l_oeb.oeb932 = null
      LET  l_oeb.oeb933 = null
      LET  l_oeb.oeb934 = null
      LET  l_oeb.oebud01 = null
      LET  l_oeb.oebud02 = null
      LET  l_oeb.oebud03 = null
      LET  l_oeb.oebud04 = null
      LET  l_oeb.oebud05 = null
      LET  l_oeb.oebud06 = null
      LET  l_oeb.oebud07 = null
      LET  l_oeb.oebud08 = null
      LET  l_oeb.oebud09 = null
      LET  l_oeb.oebud10 = null
      LET  l_oeb.oebud11 = null
      LET  l_oeb.oebud12 = null
      LET  l_oeb.oebud13 = null
      LET  l_oeb.oebud14 = null
      LET  l_oeb.oebud15 = null
      LET  l_oeb.oebplant = g_plant
      LET  l_oeb.oeblegal = g_legal
      #LET  l_oeb.oeb44 = '1'   #FUN-AA0089 mark
      #LET  l_oeb.oeb45 = null  #FUN-AA0089 mark
      #LET  l_oeb.oeb46 = null  #FUN-AA0089 mark
      LET  l_oeb.oeb47 = '0'
      LET  l_oeb.oeb48 = '2'
    INSERT INTO oeb_file VALUES (l_oeb.*)
    IF STATUS THEN
   #    CALL cl_err3("ins","oeb_file",l_oeb.oeb01,l_oeb.oeb04,SQLCA.sqlcode,"","",1)
        CALL s_errmsg('oeb01',l_oeb.oeb04,'INS rty_file',STATUS,1)
        CONTINUE WHILE
    END IF
    LET i = i+1                         #FUN-B10010
  END WHILE
 END IF
 CALL s_showmsg()
END FUNCTION

  
#FUN-A80121  ..end
#MOD-AC0180 更新p_qry資料
#MOD-B30347---add--str--
#變動訂單日期檢查是否失效
FUNCTION t400_chk_oea02(p_oea01,p_oea02,p_oea12)
   DEFINE p_oea01     LIKE oea_file.oea01
   DEFINE p_oea02     LIKE oea_file.oea02
   DEFINE p_oea12     LIKE oea_file.oea12 
   DEFINE l_oeb32     LIKE oeb_file.oeb32  
   DEFINE l_oeb71     LIKE oeb_file.oeb71   

   DECLARE cur_oea71 CURSOR FOR SELECT oeb71 FROM oeb_file
                                 WHERE oeb01 = p_oea01
   FOREACH cur_oea71 INTO l_oeb71
      IF NOT cl_null(l_oeb71) THEN
         SELECT oeb32 INTO l_oeb32 
           FROM oeb_file
          WHERE oeb01 = p_oea12
            AND oeb03 = l_oeb71
         IF p_oea02 > l_oeb32 THEN            
            RETURN FALSE
         END IF
      END IF
   END FOREACH
   RETURN TRUE
END FUNCTION
#MOD-B30347---add--end--

#FUN-B30012 --------------------STA
FUNCTION t400_chk_oeb1001_1(p_oea01) 
DEFINE p_oea01     LIKE oea_file.oea01
DEFINE l_n         LIKE type_file.num5
    
   SELECT COUNT(*) INTO l_n  FROM oeb_file 
    WHERE oeb01 = p_oea01
      AND oeb1001 = g_oaz.oaz88
    IF l_n > 0 THEN
       RETURN FALSE
    ELSE
       RETURN TRUE
    END IF

END FUNCTION
#FUN-B30012 --------------------END


