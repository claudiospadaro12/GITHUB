# =====================================================================
#  rilancia_scan_market.ps1  --  SCAN di un EA su TUTTO il market
#  (tutti i simboli della lista) in OHLC, per scoprire su quali
#  strumenti rende di piu' in ~2,5 anni.
#
#  Uso (-Robot):
#    ABTG_MaxMinNotte · ABTG_Nightly · ABTG_HARSI (M5)
#    ABTG_SupertrendReversal (H4) · ABTG_EMA200 (H4) · ABTG_GoldenCross (H1)
#    ABTG_SuperWave (H4) · ABTG_SupertrendInvert (H1) · ABTG_PTE (H4)
#    ABTG_WOL (D1) · ABTG_FiboH4_Multi (H4)
#    ABTG_Bulge (H1, i 22 cross del basket -- vedi la nota qui sotto)
#
#  NOTA ABTG_Bulge (R92-scan, 21/08/2026): questo EA e' MULTI-SIMBOLO
#  (input Symbols_List). Nel tester si prova UN CROSS ALLA VOLTA, con
#  Symbols_List pinnato al simbolo della passata: MT5 modella male i
#  simboli diversi da quello del grafico (docs\Guida_Test_BULGE.md).
#  Per questo il suo blocco usa il segnaposto __SYM__, che il ciclo
#  sostituisce simbolo per simbolo. Il blocco porta anche la SUA lista
#  di simboli (i 22 del basket, non i 48 del market) e la SUA finestra.
#  -Tf non ha effetto sul BULGE: il timeframe e' PERIOD_H1 scritto nel
#  sorgente, non un input.
#  Opzionale -Tf M5/M15/M30/H1/H4/D1: forza il timeframe (es. confronto H1 vs H4).
#    I risultati vanno in risultati_scan_<EA>_<Tf> (non si sovrascrivono).
#
#  Come funziona: per ogni simbolo genera un .ini al volo, lancia l'EA
#  in OHLC (Model 1) con una piccola griglia, salva un CSV per simbolo
#  in .\risultati_scan_<EA>\. Poi Claudio manda i CSV e Claude
#  classifica gli strumenti per PF (filtro: almeno N trade).
#  Ripresa: salta i simboli gia' fatti.
#
#  NB: ogni simbolo deve avere lo storico scaricato. Quelli senza dati
#  (o con nome diverso sul tuo BCM) danno 0 trade e vengono saltati.
#  SL ad ATR (agnostico). Rischio 1%.
# =====================================================================
param(
  [Parameter(Mandatory=$true)][string]$Robot,   # ABTG_MaxMinNotte | ABTG_Nightly | ABTG_HARSI | ...
  [string]$Tf="",                                # opzionale: M5/M15/M30/H1/H4/D1 -> forza il timeframe
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force
)
$ErrorActionPreference="Stop"
$EA=$Robot   # (rinominato: -EA e' riservato da PowerShell come alias di -ErrorAction)
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$Branch="lavoro"   # era un branch fermo dal 31/07: scaricava sorgenti VECCHI senza dare errore
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Branch"

# --- LISTA SIMBOLI (modifica se sul tuo BCM hanno nomi diversi) -------
$Symbols=@(
  # Indici
  "D30EUR","NASUSD","U30USD","SPXUSD","100GBP","F40EUR","E50EUR","E35EUR","200AUD","225JPY",
  # Metalli / energia
  "XAUUSD","XAGUSD","XPTUSD","XPDUSD","UKOIL","USOIL","XNGUSD",
  # Forex majors
  "EURUSD","GBPUSD","USDJPY","USDCHF","USDCAD","AUDUSD","NZDUSD",
  # Forex cross
  "EURGBP","EURJPY","EURCHF","EURAUD","EURCAD","EURNZD","GBPJPY","GBPCHF","GBPAUD","GBPCAD","GBPNZD",
  "AUDJPY","CADJPY","CHFJPY","NZDJPY","CADCHF","NZDCAD","NZDCHF",
  # Forex esotici EU
  "EURNOK","USDNOK","EURPLN","USDPLN","EURSEK","USDSEK"
)

# --- GRIGLIA per EA (OHLC, Model 1) -----------------------------------
# $Period = timeframe del Tester per questo EA (default H1; HARSI e' scalping -> M5)
$Period="H1"
# Finestra e modo di ottimizzazione: DEFAULT identici a sempre (nessuno
# scan gia' fatto cambia di una virgola). Un EA puo' sovrascriverli nel
# suo blocco quando ha una ragione, e la ragione va scritta li'.
$FromDate="2024.01.01"
$ToDate="2026.06.30"
$OptMode=2          # 2 = genetica (default storico). 1 = completa: si usa
                    #     quando le celle sono pochissime e la genetica non
                    #     ha niente da ottimizzare.
# VARIANTI (21/08/2026, R92): un EA puo' chiedere PIU' CORSE per simbolo,
# ognuna con qualche input in piu' e una ETICHETTA che finisce nel nome del
# CSV. Default = UNA sola corsa senza etichetta = comportamento identico a
# sempre per tutti gli EA che c'erano prima.
$Varianti=@( @{ tag=""; extra="" } )
if($EA -eq "ABTG_MaxMinNotte"){
  $Inputs=@"
InpSLMode=1||1||0||1||N
InpAtrSLmult=1.5||1.5||0||1.5||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpAllowLong=0||0||1||1||Y
InpAllowShort=0||0||1||1||Y
InpBufferPoints=200||200||1400||3000||Y
"@
} elseif($EA -eq "ABTG_Nightly"){
  $Inputs=@"
InpSLpips=0||0||0||0||N
InpSLatrMult=1.0||1.0||0.5||1.5||Y
InpRiskPercent=1.0||1.0||0||1.0||N
InpAllowLong=0||0||1||1||Y
InpAllowShort=0||0||1||1||Y
"@
} elseif($EA -eq "ABTG_HARSI"){
  # Scalping contro-trend su M5. Ottimizza direzione + TP (pip) + buffer SL.
  # NB: scan OHLC = solo SHORTLIST; per lo scalping il verdetto vero e' a TICK REALI.
  $Period="M5"
  $Inputs=@"
InpTF=5||5||0||5||N
InpRiskPercent=0.5||0.5||0||0.5||N
InpAllowLong=0||0||1||1||Y
InpAllowShort=0||0||1||1||Y
InpTPpips=4||4||2||10||Y
InpSLbufferPips=1||1||1||3||Y
"@
} elseif($EA -eq "ABTG_SupertrendReversal"){
  # Reversal su flip Supertrend. TF H4. Ottimizza direzione + moltiplicatore Supertrend.
  $Period="H4"
  $Inputs=@"
InpTF=16388||16388||0||16388||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpAllowLong=0||0||1||1||Y
InpAllowShort=0||0||1||1||Y
InpStMult=2.5||2.5||1.0||4.5||Y
"@
} elseif($EA -eq "ABTG_EMA200"){
  # Rimbalzo su EMA200. TF H4. Ottimizza direzione + rapporto TP.
  $Period="H4"
  $Inputs=@"
InpTF=16388||16388||0||16388||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpAllowLong=0||0||1||1||Y
InpAllowShort=0||0||1||1||Y
InpTP_RR=1.5||1.5||0.5||3.0||Y
"@
} elseif($EA -eq "ABTG_GoldenCross"){
  # Incrocio medie + ADX. TF H1 (usa InpTimeframe). Ottimizza direzione + TP.
  $Period="H1"
  $Inputs=@"
InpTimeframe=16385||16385||0||16385||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpAllowLong=0||0||1||1||Y
InpAllowShort=0||0||1||1||Y
InpTP_R=1.5||1.5||0.5||3.0||Y
"@
} elseif($EA -eq "ABTG_SuperWave"){
  # SuperWave: Supertrend + onda. TF H4. Ottimizza direzione + moltiplicatore Supertrend.
  $Period="H4"
  $Inputs=@"
InpTF=16388||16388||0||16388||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpAllowLong=0||0||1||1||Y
InpAllowShort=0||0||1||1||Y
InpStMult=3.5||2.5||1.0||4.5||Y
"@
} elseif($EA -eq "ABTG_SupertrendInvert"){
  # Supertrend "inverte" (reversal intraday). TF H1 nativo. Ottimizza direzione + moltiplicatore Supertrend.
  $Period="H1"
  $Inputs=@"
InpTF=16385||16385||0||16385||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpAllowLong=0||0||1||1||Y
InpAllowShort=0||0||1||1||Y
InpStMult=3.5||2.5||1.0||4.5||Y
"@
} elseif($EA -eq "ABTG_PTE"){
  # PTE: canali TMA fast/slow su iperestensione. TF H4. Ottimizza direzione + ampiezza canale veloce.
  $Period="H4"
  $Inputs=@"
InpTF=16388||16388||0||16388||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpAllowLong=0||0||1||1||Y
InpAllowShort=0||0||1||1||Y
InpMultFast=2.0||2.0||1.5||3.0||Y
"@
} elseif($EA -eq "ABTG_WOL"){
  # WOL: Weekly Open Line + Doji del martedi'. TF D1 nativo. Ottimizza direzione + rapporto TP.
  $Period="D1"
  $Inputs=@"
InpTF=16408||16408||0||16408||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpAllowLong=0||0||1||1||Y
InpAllowShort=0||0||1||1||Y
InpTP_RR=2.0||2.0||1.5||3.0||Y
"@
} elseif($EA -eq "ABTG_FiboH4_Multi"){
  # FiboH4: laddering su ritracciamenti Fibonacci. TF H4. Ottimizza direzione + 1o target (R).
  $Period="H4"
  $Inputs=@"
InpTF=16388||16388||0||16388||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpAllowLong=0||0||1||1||Y
InpAllowShort=0||0||1||1||Y
InpTP1_R=1.0||1.0||0.5||2.0||Y
"@
} elseif($EA -eq "ABTG_BreakingBand"){
  # Breaking Band (bulge Bollinger, guida ufficiale del corso). TF H1
  # di default (-Tf per cambiarlo). Spazzola SOLO il PatternMode:
  # 0=continuazione, 1=inversione, 2=entrambi -> 3 celle per simbolo.
  # Gestione TP = Leonardo puro (mediana secca), soglie ai default
  # dichiarati in tesi: le soglie fini NON si spazzolano allo screening.
  $Period="H1"
  $Inputs=@"
InpTF=16385||16385||0||16385||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpPatternMode=0||0||1||2||Y
InpTPMode=0||0||0||0||N
InpBulgeWidthMult=1.35||1.35||0||1.35||N
InpBulgeNetMoveATR=1.0||1.0||0||1.0||N
"@
} elseif($EA -eq "ABTG_GapFill"){
  # Gap-fill del weekend (Emiliano 19.04, tesi GAP_FILL_TESI.md). ~52
  # eventi/anno a simbolo: allo screening si spazzola SOLO il target
  # (fill 50/75/100%) -> 3 celle per simbolo. Soglie ATR e time-stop
  # ai default di tesi, pinnati per nome. Spread filter SPENTO qui:
  # l'OHLC lo spread della riapertura non lo vede comunque (i verdetti
  # veri saranno solo a tick reali, con filtro acceso).
  $Period="H1"
  $Inputs=@"
InpTF=16385||16385||0||16385||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpGapMinATR=0.3||0.3||0||0.3||N
InpGapMaxATR=2.0||2.0||0||2.0||N
InpSLMode=0||0||0||0||N
InpSLGapMult=1.0||1.0||0||1.0||N
InpMaxHours=48||48||0||48||N
InpMaxSpreadPts=0||0||0||0||N
InpEntryWindowBars=3||3||0||3||N
InpFillPct=100||50||25||100||Y
"@
} elseif($EA -eq "ABTG_CostToCost"){
  # Cost-to-cost sulle punte di Larry (tesi COSTTOCOST_TESI.md). H1 di
  # default (-Tf H4 per il secondo giro). Spazzola SOLO uscita e lati:
  # 3 exit x 4 lati = 12 celle/simbolo. Struttura auto-adattiva, filtri
  # spenti allo screening (lezione BB: prima la frequenza).
  $Period="H1"
  $Inputs=@"
InpTF=16385||16385||0||16385||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpTP_R=1.5||1.5||0||1.5||N
InpSLBufferATR=0.2||0.2||0||0.2||N
InpAtrPeriod=14||14||0||14||N
InpMinRangeATR=0.0||0.0||0||0.0||N
InpMaxBarsHold=100||100||0||100||N
InpMaxSpreadPts=0||0||0||0||N
InpEntryWindowBars=3||3||0||3||N
InpWarmupBars=500||500||0||500||N
InpExitMode=0||0||1||2||Y
InpAllowLong=1||0||1||1||Y
InpAllowShort=1||0||1||1||Y
"@
} elseif($EA -eq "ABTG_EasyTrend"){
  # Easy Trend (tesi EASY_TREND_TESI.md). Detector PINNATO dalla CAL del
  # 14/08 (criterio congelato: solo frequenza, banda 2-8 trade/mese ->
  # PivotSource 0 come il Pine di TISTA, PivotR 3). H1. Spazzola SOLO
  # TP_R e lati: 2 x 4 = 8 celle/simbolo. Spread spento allo screening.
  $Period="H1"
  $Inputs=@"
InpTF=16385||16385||0||16385||N
InpPivotSource=0||0||0||0||N
InpPivotR=3||3||0||3||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpMaxSpreadPts=0||0||0||0||N
InpEntryWindowBars=3||3||0||3||N
InpWarmupBars=500||500||0||500||N
InpTP_R=1.0||1.0||0.5||1.5||Y
InpAllowLong=1||0||1||1||Y
InpAllowShort=1||0||1||1||Y
"@
} elseif($EA -eq "ABTG_Bulge"){
  # =============================================================
  #  R92-SCAN -- BULGE (motore di Claudio, EA ABTG_Bulge v5.00).
  #  UNA CELLA PER SIMBOLO, pinnata ai DEFAULT DI CLAUDIO (BLU +
  #  VIOLA accesi, ARANCIO spento) ma al NOSTRO rischio 1%.
  #  Il verbale completo della cella, con i criteri e i canarini:
  #      prove\R92_scan_BULGE.txt
  #  Se cambi una riga qui, cambiala anche li'. Diff prima di lanciare.
  #
  #  L'UNICO ASSE DELL'OTTIMIZZATORE E' LA VARIANTE DEL VIOLA
  #  (Use_Purple_PineReaction 0/1): 0 = VIOLA-EA, la condizione
  #  "candela non impulsiva" che c'e' nel codice; 1 = VIOLA-PINE,
  #  la candela di reazione verde/rossa del Pine originale di Claudio.
  #  Firma del 21/08: "misura entrambe". Due celle per corsa.
  #
  #  IL CONTO: 22 simboli x 2 gestioni (2 corse) x 2 varianti del
  #  VIOLA (2 celle) = 88 passate.
  #
  #  COME SI RICONOSCE UNA PASSATA NEL CSV -- tre etichette ridondanti,
  #  perche' una sola si perde sempre:
  #    1. il NOME del file:  scan_ABTG_Bulge_<SIMBOLO>_<nuda|gestita>.csv
  #    2. la colonna InpMagic:  772700 = nuda,  772710 = gestita
  #    3. la colonna Use_Purple_PineReaction:  0 = VIOLA-EA, 1 = PINE
  #  (le colonne ci sono perche' OnTesterDeinit scrive gli input di
  #   ogni passata accanto ai numeri: e' il nostro OptFrame di sempre.)
  #
  #  IL CONTROLLO GEMELLO (determinismo del banco) NON sta qui dentro:
  #  costerebbe altre 88 passate. Si fa UNA volta sola, su UN simbolo,
  #  come 89a passata facoltativa, rilanciando la stessa cella col
  #  magic 772701 e confrontando riga per riga. E' scritto in
  #  prove\R92_scan_BULGE.txt.
  #
  #  FINESTRA 2022.01.01 -> 2026.06.30 = la finestra del backtest di
  #  Claudio (2022.01.01-2026.03.30): serve a mettere i nostri numeri
  #  ACCANTO ai suoi senza dover spiegare una differenza di periodo.
  #  >>> TODO PASSO 0: la profondita' dati di questi 22 cross a BCM
  #      NON E' MISURATA (l'unica misura forex agli atti e' GBPUSD,
  #      tick dal 2024.07.05). Finche' non e' misurata, i numeri di
  #      questo scan sono PROVVISORI: un cross i cui dati partono dopo
  #      il 2022 ha girato su mezza finestra e il suo conteggio
  #      operazioni non e' confrontabile con gli altri.
  #        .\scarica_storico.ps1 -Simboli "..." -SoloReferto
  # =============================================================
  $Period="H1"
  $FromDate="2022.01.01"
  $ToDate="2026.06.30"
  $OptMode=1
  # LE DUE GESTIONI (firma di Claudio del 21/08, "c" = misurale entrambe).
  # Non sono un asse dell'ottimizzatore: sono DUE CORSE separate per
  # simbolo, cosi' ogni CSV porta la gestione scritta nel NOME e nel MAGIC.
  #   nuda    = come BULGE_MASTER: SL 3xATR + TP mediana, nient'altro
  #   gestita = + break-even 1R e trailing a gradini di R, cioe' la
  #             gestione che Claudio usava A MANO col suo Manager MT4
  $extraNuda=@"
Enable_BE_1R=0||0||0||0||N
Enable_Trailing_R=0||0||0||0||N
InpMagic=772700||772700||0||772700||N
"@
  $extraGestita=@"
Enable_BE_1R=1||1||0||1||N
Enable_Trailing_R=1||1||0||1||N
InpMagic=772710||772710||0||772710||N
"@
  $Varianti=@(
    @{ tag="nuda";    extra=$extraNuda },
    @{ tag="gestita"; extra=$extraGestita }
  )
  # I 22 CROSS DEL BASKET (input Symbols_List dell'EA), non i 48 del market.
  $Symbols=@(
    "EURUSD","GBPUSD","AUDUSD","NZDUSD","USDCAD","USDCHF","USDJPY",
    "EURGBP","EURNZD","GBPJPY","GBPAUD","GBPCAD","GBPNZD",
    "AUDJPY","AUDCAD","AUDNZD","NZDJPY","NZDCAD","NZDCHF",
    "CADJPY","CADCHF","CHFJPY"
  )
  $Inputs=@"
BB_Period=20||20||0||20||N
BB_Deviation=2.0||2.0||0||2.0||N
ATR_Period=14||14||0||14||N
SL_ATR_Mult=3.0||3.0||0||3.0||N
BB_Width_Len=50||50||0||50||N
Bulge_Multi=1.1||1.1||0||1.1||N
Lookback_Bars=20||20||0||20||N
Use_Orange=0||0||0||0||N
Use_Blue=1||1||0||1||N
Use_Purple=1||1||0||1||N
Use_ATR_Filter=1||1||0||1||N
ATR_MA_Len=20||20||0||20||N
ATR_Max_Mult=1.8||1.8||0||1.8||N
ATR_Min_Mult=0.5||0.5||0||0.5||N
Use_ADX_Filter=1||1||0||1||N
ADX_Period=14||14||0||14||N
ADX_Threshold=30.0||30.0||0||30.0||N
ADX_Apply_On_Blue=1||1||0||1||N
ADX_Apply_On_Purple=0||0||0||0||N
ADX_Apply_On_Orange=0||0||0||0||N
Use_News_Filter=0||0||0||0||N
Enable_Partial_Close=0||0||0||0||N
Partial_Close_Pct=0.5||0.5||0||0.5||N
Partial_Close_R=1.0||1.0||0||1.0||N
Use_Kill_Switch=1||1||0||1||N
Max_SL_PerDay=4||4||0||4||N
Max_Consecutive_SL=3||3||0||3||N
Max_Daily_Loss_Pct=2.0||2.0||0||2.0||N
Risk_Mode=0||0||0||0||N
Risk_Percent=1.0||1.0||0||1.0||N
Total_Risk_Percent=2.0||2.0||0||2.0||N
Max_Trades=4||4||0||4||N
Manage_Manual_Orders=0||0||0||0||N
Manual_SL_ATR_Mult=3.0||3.0||0||3.0||N
Symbols_List=__SYM__
InpComment=BULGE
InpUsaGuardian=1||1||0||1||N
InpVerbose=0||0||0||0||N
InpAutoTest=0||0||0||0||N
BE_At_R=1.0||1.0||0||1.0||N
BE_Offset_Points=2||2||0||2||N
Trail_Start_R=1.5||1.5||0||1.5||N
Trail_Step_R=0.25||0.25||0||0.25||N
Trail_MinMove_Points=10||10||0||10||N
Use_Purple_PineReaction=0||0||1||1||Y
"@
} else { Write-Host "EA non gestito: MaxMinNotte, Nightly, HARSI, SupertrendReversal, EMA200, GoldenCross, SuperWave, SupertrendInvert, PTE, WOL, FiboH4_Multi, BreakingBand, GapFill, CostToCost, EasyTrend, Bulge" -ForegroundColor Red; exit 1 }

# --- -Tf opzionale: forza il timeframe del test e dell'EA, e separa i risultati ---
$EAtag=$EA
if($Tf){
  $map=@{ "M5"=5; "M15"=15; "M30"=30; "H1"=16385; "H4"=16388; "D1"=16408 }
  if(-not $map.ContainsKey($Tf)){ Write-Host "-Tf non valido: usa M5, M15, M30, H1, H4, D1" -ForegroundColor Red; exit 1 }
  $Period=$Tf
  $en=$map[$Tf]
  $Inputs=[regex]::Replace($Inputs,'InpTF=\d+\|\|\d+\|\|\d+\|\|\d+\|\|N',"InpTF=$en||$en||0||$en||N")
  $Inputs=[regex]::Replace($Inputs,'InpTimeframe=\d+\|\|\d+\|\|\d+\|\|\d+\|\|N',"InpTimeframe=$en||$en||0||$en||N")
  $EAtag="${EA}_$Tf"
  Write-Host ("   -Tf $Tf -> Period $Period, risultati in risultati_scan_$EAtag") -ForegroundColor Yellow
}

$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
Write-Host "=== SCAN MARKET: $EA su $($Symbols.Count) simboli x $($Varianti.Count) variante/i (OHLC), finestra $FromDate - $ToDate ===" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path (Join-Path $Work "src_v2"),(Join-Path $Work "ini_scan") | Out-Null
try{Invoke-WebRequest -Uri "$RawBase/mql5/Experts/$EA.mq5" -OutFile (Join-Path $Work "src_v2\$EA.mq5") -UseBasicParsing; Write-Host "   OK src_v2\$EA.mq5" -ForegroundColor Green}
catch{Write-Host "   ERRORE download $EA" -ForegroundColor Red; exit 1}
if(-not $Terminal){
  $allTerm=Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
  if($UseSpare){$c=$allTerm|?{$_.DirectoryName -like "*BCM Markets*" -and $_.DirectoryName -like "*-V3*"}|Select -First 1}
  else{$c=$allTerm|?{$_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*"}|Select -First 1}
  if(-not $c){$c=$allTerm|?{$_.DirectoryName -like "*BCM Markets*"}|Select -First 1}
  if($c){$Terminal=$c.FullName; $MetaEditor=Join-Path $c.DirectoryName "metaeditor64.exe"}
}
if($Terminal -and -not $DataFolder){
  $instDir=Split-Path -Parent $Terminal; $termRoot=Join-Path $env:APPDATA "MetaQuotes\Terminal"
  if(Test-Path $termRoot){$DataFolder=Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue|?{$o=Join-Path $_.FullName "origin.txt";(Test-Path $o)-and((Get-Content $o -Raw).Trim() -ieq $instDir)}|Select -First 1 -ExpandProperty FullName}
}
if(-not $DataFolder -or -not (Test-Path $DataFolder)){Write-Host "Cartella dati non trovata." -ForegroundColor Red; exit 1}
$MqlExperts=Join-Path $DataFolder "MQL5\Experts"; $MqlFiles=Join-Path $DataFolder "MQL5\Files"
$Results=Join-Path $Work "risultati_scan_$EAtag"; New-Item -ItemType Directory -Force -Path $MqlExperts,$Results|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){Write-Host "!!! Chiudi MetaTrader prima (0 CSV altrimenti)." -ForegroundColor Red; exit 1}
Copy-Item (Join-Path $Work "src_v2\$EA.mq5") -Destination $MqlExperts -Force
& $MetaEditor "/compile:$(Join-Path $MqlExperts "$EA.mq5")" "/log" | Out-Null
if(-not (Test-Path (Join-Path $MqlExperts "$EA.ex5"))){Write-Host "ERRORE compilazione $EA" -ForegroundColor Red; exit 1}
Write-Host "   compilato $EA.ex5" -ForegroundColor Green
$n=0
$Totale=$Symbols.Count * $Varianti.Count
foreach($sym in $Symbols){
 foreach($v in $Varianti){
  $n++
  $suff = ""
  if($v.tag -ne ""){ $suff = "_" + $v.tag }
  $done=Join-Path $Results "scan_${EAtag}_${sym}${suff}.csv"
  if(Test-Path $done){Write-Host ("   [{0}/{1}] {2}{3}: gia' fatto, salto" -f $n,$Totale,$sym,$suff) -ForegroundColor DarkGray; continue}
  $iniPath=Join-Path $Work "ini_scan\scan_${EA}_${sym}${suff}.ini"
  # EA multi-simbolo (BULGE): Symbols_List va pinnato al simbolo di QUESTA
  # passata; la variante aggiunge le sue righe in fondo.
  # ATTENZIONE, trappola gia' pagata: un PARAMETRO DOPPIO in
  # [TesterInputs] fa fare a MT5 ZERO passate, in silenzio. Quindi le
  # righe della variante non devono MAI ripetere un parametro gia'
  # presente nel blocco base: il controllo qui sotto ferma lo scan se
  # succede, invece di lasciarti una notte di CSV vuoti.
  $InputsSym=($Inputs + $v.extra).Replace("__SYM__",$sym)
  $nomi=@(); foreach($riga in ($InputsSym -split "`r?`n")){ if($riga.Trim() -ne ""){ $nomi += ($riga -split "=")[0].Trim() } }
  $doppi=@($nomi | Group-Object | Where-Object { $_.Count -gt 1 })
  if($doppi.Count -gt 0){ Write-Host ("!!! PARAMETRO DOPPIO in [TesterInputs]: " + ($doppi.Name -join ", ") + " -> MT5 farebbe ZERO passate. Corretto il blocco dell'EA e rilancia.") -ForegroundColor Red; exit 1 }
  @"
[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$EA.ex5
Symbol=$sym
Period=$Period
Model=1
Optimization=$OptMode
OptimizationCriterion=6
FromDate=$FromDate
ToDate=$ToDate
ForwardMode=0
Deposit=10000
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=OptReport_scan_${EAtag}_${sym}${suff}

[TesterInputs]
$InputsSym
"@ | Set-Content -Path $iniPath -Encoding ASCII
  # il nome del CSV che scrive l'EA e' fisso (OptResults_<EA>_<Symbol>.csv):
  # si copia subito col suffisso della variante, cosi' le due gestioni non
  # si sovrascrivono mai.
  $csv=Join-Path $MqlFiles "OptResults_${EA}_$sym.csv"; if(Test-Path $csv){Remove-Item $csv -Force}
  Write-Host ("   [{0}/{1}] {2}{3} (OHLC)..." -f $n,$Totale,$sym,$suff) -ForegroundColor Cyan
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$iniPath`"" -PassThru).WaitForExit()
  if(Test-Path $csv){Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force; Write-Host ("        OK -> scan_${EAtag}_${sym}${suff}.csv") -ForegroundColor Green}
  else{Write-Host ("        (no CSV: {0} senza storico/nome diverso? salto)" -f $sym) -ForegroundColor Yellow}
 }
}
Write-Host "`n=== FINITO === risultati in $Results" -ForegroundColor Cyan
Write-Host "Zippa la cartella risultati_scan_$EAtag e caricamela (o mandami i CSV): classifico gli strumenti per PF." -ForegroundColor White
