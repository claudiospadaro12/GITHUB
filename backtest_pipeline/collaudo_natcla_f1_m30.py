#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
collaudo_natcla_f1_m30.py -- prova A PEZZI di backtest_pipeline/righe/NATCLA_F1_M30_PASSATE.ps1 (driver del lotto M30 di EA_NatCla v1.12) con il
PowerShell vero (pwsh), senza MT5, e i MUTANTI del driver. DERIVATO da backtest_pipeline/collaudo_natcla_f1.py (stesso metodo: le FUNZIONI del
driver si estraggono col parser di PowerShell, i blocchi in linea che decidono si TAGLIANO fra marcatori di testo del sorgente e si eseguono su
dati finti nel formato vero). Cambia COSA si prova:
  - il file prova VERO del lotto (backtest_pipeline/prove/NATCLA_F1_M30_2026-10-11.txt): 4 passate nell'ordine scritto, soglie, devia=si|no;
  - le DEVIAZIONI M1-M9 del driver: versione 1.12, 74 pin, pin fisso InpAmmettiTFSottoH1=true, conteggio dei blocchi, coerenza devia/periodo;
  - il controllo NUOVO M8 (deviazione DICHIARATA su M30, ASSENTE su H1) nel giornale e nel CSV, con un contro-esempio per ogni ramo;
  - l'.ini di una passata M30 (InpTF=30, Period=M30) e della gamba di controllo H1;
  - un report .htm VERO (R290A, UTF-16) riscritto con simbolo XAUUSD e periodo M30.
Cultura del thread it-IT. LIMITE DICHIARATO: pwsh 7 su Linux, NON Windows PowerShell 5.1; nessun terminale, nessun tester, nessuno Start-Process:
la parte che lancia MT5, la compilazione e lo zip finale NON sono provati qui (sono le righe della madre, invariate).
Il lettore leggi_natcla_f1.py NON e' toccato e NON legge questo lotto (VERSIONE_EA 1.11 cablata): qui non lo si prova.
USO: python3 backtest_pipeline/collaudo_natcla_f1_m30.py [--senza-mutanti]   (esce 1 se un controllo cade o un mutante resta VIVO)
"""
import os, shutil, subprocess, sys, tempfile

QD = os.path.dirname(os.path.abspath(__file__))
DRIVER = os.path.join(QD, "righe", "NATCLA_F1_M30_PASSATE.ps1")
PROVA = os.path.join(QD, "prove", "NATCLA_F1_M30_2026-10-11.txt")
REPORT_VERO = os.path.join(QD, "risultati_archivio", "R290A_PASSATA_STOP_NAS_20261006_2040", "PASSATA_STOP_NAS.htm")


def taglia(testo, da, a):
    i = testo.index(da)
    j = testo.index(a, i)
    return testo[i:j]


def esegui(src_driver, stampa=True):
    src = src_driver
    tmp = tempfile.mkdtemp(prefix="collaudo_f1m30_")
    drv = os.path.join(tmp, "driver.ps1")
    open(drv, "w").write(src)
    try:
        b_cost = taglia(src, "$EXPERT = 'EA_NatCla'", "if($Pin -notmatch")
        b_lotto = taglia(src, "if($Lotto -notmatch", "foreach($hx in @($ShaEA")
        b_prova = taglia(src, "# --- il file prova: pin, asse tecnico, blocchi F1", "Copy-Item -LiteralPath $srcEA")
        b_ini = taglia(src, "  # --- l'ini: i 74 pin del file prova", "  $foto = Fotografia")
        b_re = taglia(src, "$reAvvio = New-Object", "# la scoperta ricorsiva dei .log")
        b_dopo = taglia(src, "  # --- lettura delle sole righe scritte DOPO la fotografia", "  # il log dell'EA di questa passata, per intero")
        b_man = taglia(src, "$manifest = New-Object System.Collections.ArrayList", "$nOk = 0; $nKo = 0")
        b_base = taglia(src, "  $base = $Lotto + ';'", "  $minDa = ")
        b_okrow = taglia(src, "  [void]$manifest.Add($base + ';' + $tRun", "  $col = 'Green'")
    except ValueError:
        return (0, 1, 1)
    for nome, testo in (("b_cost.ps1", b_cost), ("b_lotto.ps1", b_lotto), ("b_prova.ps1", b_prova), ("b_ini.ps1", b_ini), ("b_re.ps1", b_re), ("b_dopo.ps1", b_dopo),
                        ("b_man.ps1", b_man), ("b_base.ps1", b_base), ("b_okrow.ps1", b_okrow)):
        open(os.path.join(tmp, nome), "w").write(testo)
    rep = open(REPORT_VERO, "rb").read().decode("utf-16")
    shutil.copy(PROVA, os.path.join(tmp, "prova.txt"))
    open(os.path.join(tmp, "report_vero.txt"), "w", encoding="utf-8").write(rep)
    ps = TEST_PS.replace("@@TMP@@", tmp.replace("\\", "/")).replace("@@DRIVER@@", drv)
    open(os.path.join(tmp, "test.ps1"), "w").write(ps)
    r = subprocess.run(["pwsh", "-NoProfile", "-NonInteractive", "-File", os.path.join(tmp, "test.ps1")], capture_output=True, text=True, timeout=900)
    if stampa:
        print(r.stdout)
        if r.stderr.strip():
            print("STDERR:\n" + r.stderr)
    righe = [l for l in r.stdout.splitlines() if l.startswith("CONTROLLO ")]
    falliti = [l for l in righe if l.rstrip().endswith(" FALLITO")]
    shutil.rmtree(tmp, ignore_errors=True)
    return (len(righe), len(falliti), r.returncode)


# MUTANTI: un errore plausibile per ogni riga NUOVA (M2-M8) e per le righe della madre che decidono su M30; ognuno DEVE far cadere almeno un controllo
MUTANTI = [
    ("M3 versione rimasta 1.11", "$VERSIONE_ATTESA = '1.12'", "$VERSIONE_ATTESA = '1.11'"),
    ("M4 pin attesi 73 (quelli della madre)", "$N_PIN_ATTESI = 74\n", "$N_PIN_ATTESI = 73\n"),
    ("M5 lotto P ammesso", "if($Lotto -notmatch '^(M30)$')", "if($Lotto -notmatch '^(M30|P)$')"),
    ("M6 pin fisso della deviazione tolto", "; InpAmmettiTFSottoH1 = 'true' }", " }"),
    ("M7 conteggio dei simboli della madre (11)", "@($blocchi.SIMBOLO).Count -ne 2 -or", "@($blocchi.SIMBOLO).Count -ne 11 -or"),
    ("M8 coerenza devia/periodo tolta", "if(($c['devia'] -eq 'si') -ne ($c['periodo'] -eq 'M30' -and $c['tf'] -eq '30')){", "if($false){"),
    ("M8 riga AVVISO non pretesa su M30", "if($cfg['devia'] -eq 'si' -and ($devAvv.Count -ne 1", "if($false -and ($devAvv.Count -ne 1"),
    ("M8 AVVISO ammesso su H1", "if($cfg['devia'] -eq 'no' -and $devAvv.Count -gt 0){", "if($false){"),
    ("M8 CFG InpTF non controllata", "if($devTF.Count -ne 1 -or -not ([string]$devTF[0]).StartsWith($tfAtt, [StringComparison]::Ordinal)){", "if($false){"),
    ("M8 CFG InpAmmettiTFSottoH1 non controllata", "if($devAmm.Count -ne 1 -or -not ([string]$devAmm[0]).StartsWith($ammAtt, [StringComparison]::Ordinal)){", "if($false){"),
    ("M8 #cfg;InpTF del CSV non controllato", "if(-not $cs.CfgTF.StartsWith($csvTF, [StringComparison]::Ordinal)){", "if($false){"),
    ("M8 #cfg;InpAmmettiTFSottoH1 del CSV non controllato", "if(-not $cs.CfgAmm.StartsWith($csvAmm, [StringComparison]::Ordinal)){", "if($false){"),
    ("M8 ContaSetup non legge #cfg;InpTF", "        if($ln.StartsWith('#cfg;InpTF;', [StringComparison]::Ordinal)){ $r.CfgTF = $ln }\n", ""),
    ("M8 etichetta H1 attesa = quella della deviazione", "$tfAtt = '[NatCla] CFG InpTF = PERIOD_' + $cfg['periodo'] + '   A MANO [FONTE A-R8 / P-p05]'", "$tfAtt = '[NatCla] CFG InpTF = PERIOD_' + $cfg['periodo'] + '   A MANO ['"),
    # madre: righe che decidono anche qui
    ("TF della config non sostituito nell'ini", "    if($pp[0] -eq 'InpTF'){ $val = $cfg['tf'] }\n", ""),
    ("TF dell'AVVIO non controllato", "if($G['tf'].Value -ne $cfg['periodo'])", "if($false)"),
    ("magic dell'AVVIO non controllato", "if($G['mg'].Value -ne $cfg['magic'])", "if($false)"),
    ("periodo del report: qualunque TF accettato", "$mpd = [regex]::Match($lr.Periodo, '^' + $cfg['periodo'] + '\\(", "$mpd = [regex]::Match($lr.Periodo, '^[A-Z0-9]+\\("),
    ("soglia non sostituita", "    if($pp[0] -eq 'InpInclMinAtr'){ $val = $ru.Soglia }\n", ""),
    ("colla operazioni tolta", "if($dTr -lt 0 -or $dTr -gt 3)", "if($false)"),
]


def main():
    src = open(DRIVER, encoding="ascii").read()
    n, f, rc = esegui(src)
    print("COLLAUDO DRIVER F1 M30: %d controlli, %d falliti, rc %d" % (n, f, rc))
    if "--senza-mutanti" in sys.argv:
        sys.exit(0 if (n and not f and rc == 0) else 1)
    vivi = []
    for nome, a, b in MUTANTI:
        if src.count(a) != 1:
            print("   MUTANTE %s: testo d'ancora trovato %d volte nel driver (atteso 1: il mutante va riscritto)" % (nome, src.count(a)))
            vivi.append(nome)
            continue
        nm, fm, rcm = esegui(src.replace(a, b, 1), stampa=False)
        preso = fm > 0 or rcm != 0 or nm < n
        print("   MUTANTE %-55s %s (controlli %d, falliti %d, rc %d)" % (nome, "PRESO" if preso else "VIVO", nm, fm, rcm))
        if not preso:
            vivi.append(nome)
    print("MUTANTI DEL DRIVER M30: %d presi su %d" % (len(MUTANTI) - len(vivi), len(MUTANTI)))
    sys.exit(0 if (n and not f and rc == 0 and not vivi) else 1)


TEST_PS = r'''
$ErrorActionPreference = 'Stop'
[Threading.Thread]::CurrentThread.CurrentCulture = [Globalization.CultureInfo]::GetCultureInfo('it-IT')
$IC = [Globalization.CultureInfo]::InvariantCulture
$DIRC = '@@TMP@@'; $env:USERPROFILE = $DIRC
$script:nC = 0
function C($cond, $nome){ $script:nC++; if($cond){ Write-Host ('CONTROLLO ' + $nome + ' OK') } else { Write-Host ('CONTROLLO ' + $nome + ' FALLITO') } }
. ([scriptblock]::Create((Get-Content -Raw -LiteralPath (Join-Path $DIRC 'b_cost.ps1'))))
$ast = [System.Management.Automation.Language.Parser]::ParseFile('@@DRIVER@@', [ref]$null, [ref]$null)
$fdefs = $ast.FindAll({ param($n) $n -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)
foreach($fd in $fdefs){ . ([scriptblock]::Create($fd.Extent.Text)) }
C ($fdefs.Count -ge 14) ('funzioni estratte: ' + $fdefs.Count)
C ($VERSIONE_ATTESA -eq '1.12' -and $PROVA -eq 'NATCLA_F1_M30_2026-10-11.txt' -and $N_PIN_ATTESI -eq 74 -and $DEPOSITO -eq 1000000 -and $MODELLO -eq 4 -and $DATA_A -eq '2025.06.30') ('costanti M2-M4 e della madre: v' + $VERSIONE_ATTESA + ' ' + $PROVA + ' pin ' + $N_PIN_ATTESI + ' dep ' + $DEPOSITO + ' modello ' + $MODELLO + ' fine IS ' + $DATA_A)
# M5: il solo lotto ammesso
foreach($pz in @(@('M30', $false), @('P', $true), @('O', $true), @('m30x', $true))){
  $Lotto = $pz[0]; $rotto = $false
  try { . ([scriptblock]::Create((Get-Content -Raw -LiteralPath (Join-Path $DIRC 'b_lotto.ps1')))) } catch { $rotto = $true }
  C ($rotto -eq $pz[1]) ('lotto ' + $pz[0] + ': ' + $(if($pz[1]){'rifiutato'}else{'ammesso'}))
}

# ---------------- 1. il file prova VERO e il lotto M30 ----------------
$fileProva = Join-Path $DIRC 'prova.txt'; $Lotto = 'M30'
. ([scriptblock]::Create((Get-Content -Raw -LiteralPath (Join-Path $DIRC 'b_prova.ps1'))))
$v = ($runs | ForEach-Object { $_.Sim['nome'] + ':' + $_.Cfg['nome'] + ':' + $_.Lato['nome'] + ':' + $_.Modo['nome'] + ':' + $_.Soglia + ':' + $_.Cfg['devia'] + ':' + $_.Cfg['magic'] + ':' + $_.Cfg['tf'] }) -join ','
C ($v -eq 'XAUUSD:AUDIO_H1:LONG:GEOM:0.700:no:778601:16385,XAUUSD:AUDIO_M30:LONG:GEOM:0.700:si:778603:30,XAUUSD:AUDIO_M30:LONG:PIU:0.700:si:778603:30,EURUSD:M2_M30:SHORT:GEOM:0.207:si:778623:30') ('lotto M30: ' + $v)
C ($tettoMin -eq 45) ('tetto del lotto ' + $tettoMin + ' minuti (atteso 45)')
C ($pinProva.Count -eq 74 -and $pinH['InpAmmettiTFSottoH1'] -eq 'true') ('pin letti ' + $pinProva.Count + ', InpAmmettiTFSottoH1=' + $pinH['InpAmmettiTFSottoH1'])
function ProvaRotta($nome, $sost){
  $txt = Get-Content -Raw -LiteralPath (Join-Path $DIRC 'prova.txt')
  $rotta = & $sost $txt
  $fp = Join-Path $DIRC 'prova_rotta.txt'
  Set-Content -LiteralPath $fp -Value $rotta -NoNewline
  $script:fileProva = $fp; $script:Lotto = 'M30'
  $preso = $false; $script:ultimo = '(nessuna eccezione)'
  if($rotta -eq $txt){ $script:ultimo = 'SOSTITUZIONE A VUOTO: il contro-esempio non e stato costruito' }
  else { try { . ([scriptblock]::Create((Get-Content -Raw -LiteralPath (Join-Path $DIRC 'b_prova.ps1')))) } catch { $preso = $true; $script:ultimo = $_.Exception.Message } }
  C $preso ('prova rotta "' + $nome + '" -> lo script si ferma (' + $script:ultimo + ')')
  $script:fileProva = Join-Path $DIRC 'prova.txt'
}
ProvaRotta 'deviazione spenta nel file prova' { param($t) $t.Replace('InpAmmettiTFSottoH1=true', 'InpAmmettiTFSottoH1=false') }
ProvaRotta 'pin della deviazione assente' { param($t) ($t -replace "(?m)^InpAmmettiTFSottoH1=true\r?\n", "") }
ProvaRotta 'devia mancante su AUDIO_M30' { param($t) $t.Replace('modi=GEOM,LINEA,PIU devia=si', 'modi=GEOM,LINEA,PIU') }
ProvaRotta 'devia=no su M30' { param($t) $t.Replace('linee=E200 adx=spento modi=GEOM,LINEA devia=si', 'linee=E200 adx=spento modi=GEOM,LINEA devia=no') }
ProvaRotta 'devia=si su H1' { param($t) $t.Replace('modi=GEOM,LINEA,PIU devia=no', 'modi=GEOM,LINEA,PIU devia=si') }
ProvaRotta 'M30 con tf 16385' { param($t) $t.Replace('nome=M2_M30 modalita=2 tf=30', 'nome=M2_M30 modalita=2 tf=16385') }
ProvaRotta 'SoloConta=true' { param($t) $t.Replace('InpSoloConta=false', 'InpSoloConta=true') }
ProvaRotta 'rischio 0.5' { param($t) $t.Replace('InpRischioSetupPct=0.25', 'InpRischioSetupPct=0.5') }
ProvaRotta 'una config in piu' { param($t) $t.Replace('#  @F1-MODO nome=GEOM', "#  @F1-CONFIG nome=M2_H1 modalita=2 tf=16385 periodo=H1 magic=778621 linee=E200 adx=spento modi=GEOM,LINEA devia=no`n#  @F1-MODO nome=GEOM") }
ProvaRotta 'soglia mancante per FX7 AUDIO_H1' { param($t) ($t -replace "(?m)^#  @F1-INCL famiglia=FX7 config=AUDIO_H1 soglia=0\.623\r?\n", "") }
ProvaRotta 'asse diverso' { param($t) $t.Replace('InpMagic=0||0||1||1||Y', 'InpMagic=0||0||1||2||Y') }

# ---------------- 2. l'.ini: una passata M30 e la gamba di controllo H1 ----------------
$fileProva = Join-Path $DIRC 'prova.txt'; $Lotto = 'M30'
. ([scriptblock]::Create((Get-Content -Raw -LiteralPath (Join-Path $DIRC 'b_prova.ps1'))))
$Work = Join-Path $DIRC 'work'; New-Item -ItemType Directory -Force -Path $Work | Out-Null
$Cart = Join-Path $DIRC 'cart'; New-Item -ItemType Directory -Force -Path (Join-Path $Cart 'ini'), (Join-Path $Cart 'csv'), (Join-Path $Cart 'trades'), (Join-Path $Cart 'report'), (Join-Path $Cart 'log') | Out-Null
$casiIni = @(
  @(1, 'M30_002_XAUUSD_AUDIO_M30_LONG_GEOM', @('InpModalita=0','InpTF=30','InpAmmettiTFSottoH1=true','InpDirezione=1','InpStopModo=0','InpInclMinAtr=0.700','InpMagic=0','InpSoloConta=false'), @('Symbol=XAUUSD','Period=M30','FromDate=2024.07.10','ToDate=2025.06.30','Model=4','Deposit=1000000','AllowLiveTrading=false','Report=NATCLA_F1_M30_002_XAUUSD_AUDIO_M30_LONG_GEOM')),
  @(3, 'M30_004_EURUSD_M2_M30_SHORT_GEOM', @('InpModalita=2','InpTF=30','InpAmmettiTFSottoH1=true','InpDirezione=2','InpStopModo=0','InpInclMinAtr=0.207'), @('Symbol=EURUSD','Period=M30','FromDate=2024.07.05')),
  @(0, 'M30_001_XAUUSD_AUDIO_H1_LONG_GEOM', @('InpModalita=0','InpTF=16385','InpAmmettiTFSottoH1=true','InpDirezione=1','InpStopModo=0','InpInclMinAtr=0.700'), @('Symbol=XAUUSD','Period=H1','FromDate=2024.07.10'))
)
foreach($ci in $casiIni){
  $ru = $runs[$ci[0]]; $sim = $ru.Sim; $cfg = $ru.Cfg; $lato = $ru.Lato; $modo = $ru.Modo; $tag = $ci[1]
  . ([scriptblock]::Create((Get-Content -Raw -LiteralPath (Join-Path $DIRC 'b_ini.ps1'))))
  $ini = Get-Content -Raw -LiteralPath $iniF
  $ti = @($ini -split "`r`n" | Where-Object { $_ -match '^Inp' })
  C ($ti.Count -eq 75) ($tag + ': ini con 75 input (74 pin + InpMagic), letti ' + $ti.Count)
  foreach($atteso in $ci[2]){ C ($ti -contains $atteso) ($tag + ': ini contiene ' + $atteso) }
  foreach($atteso in $ci[3]){ C ($ini.Contains($atteso + "`r`n")) ($tag + ': ini contiene ' + $atteso) }
  C (-not ($ini -match 'InpMagic=0\|\|')) ($tag + ': ini senza la riga dell asse')
}

# ---------------- 3. dopo la passata: giornale, report, CSV (formato vero, testi dell EA v1.12) ----------------
. ([scriptblock]::Create((Get-Content -Raw -LiteralPath (Join-Path $DIRC 'b_re.ps1'))))
$DataFolder = Join-Path $DIRC 'dati'; $InstAttesa = Join-Path $DIRC 'inst'; $MqlFiles = Join-Path $DIRC 'mqlfiles'; $CommonFiles = Join-Path $DIRC 'common'; $LogRoot = Join-Path $DIRC 'logroot'
New-Item -ItemType Directory -Force -Path $DataFolder, $InstAttesa, $MqlFiles, $CommonFiles, $LogRoot | Out-Null
$repVero = Get-Content -Raw -LiteralPath (Join-Path $DIRC 'report_vero.txt') -Encoding UTF8
$INTEST = 'tipo;barra;linea;lato;tocco_n;nuovo_ep;troncato;ctx_arm;ctx_tocco;vicino_ok;conferma_ok;dist_apertura_atr;adx;incl_atr;confl_dist_atr;confl_etichetta;ema9;ema21;bb_larg;atr14;linea_prezzo;ingresso;n_ordini;p1;p2;p3;sl;tp1;tp2;tp3;lotto1;lotto2;lotto3;spread;commissione;stop_ped1;stop_ped2;stop_ped3;rischio_soldi;n_riempiti;esito_soldi;esito_R;durata_min;motivo;stop_modo;linea_stop;stop_esito'
function RigaSetup($barra, $soldi, $riemp){ return ('SETUP;' + $barra + ';ST35;1;1;;;;;;;0.000;15.00;0.900;1.000;0;0;0;0;3.00;2400.00;SCALA3;3;2405.00;2400.00;2395.00;2390.00;2410.00;2410.00;2410.00;1.00;1.00;1.00;0.30;0;50.0;33.0;17.0;2500.00;' + $riemp + ';' + $soldi + ';' + ([double]::Parse($soldi, $IC) / 2500.0).ToString('0.000', $IC) + ';45.0;TP;0;0.00;0') }
function Scenario($nome, $k, $o){
  foreach($d in @($CommonFiles, $DataFolder, $LogRoot)){ Get-ChildItem -LiteralPath $d -File | Remove-Item -Force }
  $script:ru = $runs[$k]; $script:sim = $script:ru.Sim; $script:cfg = $script:ru.Cfg; $script:lato = $script:ru.Lato; $script:modo = $script:ru.Modo
  $per = $script:cfg['periodo']; $mg = $script:cfg['magic']
  $script:tag = 'M30_00' + ($k + 1) + '_X'; $script:nomeRep = 'NATCLA_F1_' + $script:tag
  $script:timeout = $false; $script:foto = @{}
  $script:tRun = (Get-Date).AddSeconds(-30)
  $ver = 'v1.12'; if($o.ContainsKey('ver')){ $ver = $o['ver'] }
  $perAv = $per; if($o.ContainsKey('per_avvio')){ $perAv = $o['per_avvio'] }
  $mgAv = $mg; if($o.ContainsKey('mg_avvio')){ $mgAv = $o['mg_avvio'] }
  $avvio = "[NatCla] AVVIO " + $ver + " | modalita' AUDIO | XAUUSD PERIOD_" + $perAv + " | 1 u = 1.00 (AUTO_CLASSE metallo: 1,0 USD) | 1 pip = 0.01 | magic " + $mgAv + " | linee ST25 ST30 ST35  | ADX ACCESO, iADX MetaQuotes, max 20.0, periodo 14 | ingresso SCALA3_PENDENTI | rischio setup 0.25% (SEGNAPOSTO DA FIRMARE DA CLAUDIO) | guardian ON (nel tester FAIL-OPEN) | solo conta no | placebo 0.00 ATR | fonte SOLO AUDIO (PDF escluso 07/10) | stop GEOMETRIA_ATTUALE"
  if($script:cfg['devia'] -eq 'si'){
    $rTF = "[NatCla] CFG InpTF = PERIOD_" + $per + "   A MANO [DEVIAZIONE DALLA FONTE A-R8/R9 'non sotto H1': ammesso da InpAmmettiTFSottoH1, firma di Claudio 11/10/2026, SOLO MISURA]"
    $rAmm = "[NatCla] CFG InpAmmettiTFSottoH1 = true   DEVIAZIONE ATTIVA: TF PERIOD_" + $per + " sotto H1 [FIRMA Claudio 11/10/2026]"
    $cTF = "#cfg;InpTF;PERIOD_" + $per + ";A MANO [DEVIAZIONE DALLA FONTE A-R8/R9 'non sotto H1': ammesso da InpAmmettiTFSottoH1, firma di Claudio 11/10/2026, SOLO MISURA]"
    $cAmm = "#cfg;InpAmmettiTFSottoH1;true;DEVIAZIONE ATTIVA: TF PERIOD_" + $per + " sotto H1 [FIRMA Claudio 11/10/2026]"
    $rAvv = "[NatCla] AVVISO DEVIAZIONE DALLA FONTE ACCESA: TF PERIOD_" + $per + " sotto H1 (fonte A-R8/R9: 'non sotto H1'), ammesso da InpAmmettiTFSottoH1 con la firma di Claudio del 11/10/2026: e' una MISURA, non il metodo della collega"
  } else {
    $rTF = "[NatCla] CFG InpTF = PERIOD_" + $per + "   A MANO [FONTE A-R8 / P-p05]"
    $rAmm = "[NatCla] CFG InpAmmettiTFSottoH1 = true   nessun effetto: TF PERIOD_" + $per + " non e' sotto H1 [FIRMA Claudio 11/10/2026]"
    $cTF = "#cfg;InpTF;PERIOD_" + $per + ";A MANO [FONTE A-R8 / P-p05]"
    $cAmm = "#cfg;InpAmmettiTFSottoH1;true;nessun effetto: TF PERIOD_" + $per + " non e' sotto H1 [FIRMA Claudio 11/10/2026]"
    $rAvv = $null
  }
  if($o.ContainsKey('rTF')){ $rTF = $o['rTF'] }
  if($o.ContainsKey('rAmm')){ $rAmm = $o['rAmm'] }
  if($o.ContainsKey('cTF')){ $cTF = $o['cTF'] }
  if($o.ContainsKey('cAmm')){ $cAmm = $o['cAmm'] }
  if($o.ContainsKey('senza_avviso')){ $rAvv = $null }
  if($o.ContainsKey('avviso')){ $rAvv = $o['avviso'] }
  $ea = @($avvio, '[NatCla] CFG InpDirezione = NC_DIR_LONG   [FONTE: direzione mai dichiarata, A-R26]', ('[NatCla] CFG Inclinazione = ACCESA, N 20, soglia ' + $script:ru.Soglia + ' ATR, verso NC_INCL_QUALSIASI   DA_MODALITA [FONTE A-R19] misura [NOSTRA]'), '[NatCla] CFG Stop = GEOMETRIA_ATTUALE   v1.10 [FONTE Claudio 08/10]', '[NatCla] VERIFICA ADX barra 2024.07.10 10:30 periodo 14: terminale iADX = 21.34 | ricalcolo MetaQuotes = 21.30 | ricalcolo Wilder = 18.10 -> il terminale coincide con: formula MetaQuotes (DI per barra, media esponenziale 2/(n+1))')
  if($null -ne $rTF){ $ea = $ea + @($rTF) }
  if($null -ne $rAmm){ $ea = $ea + @($rAmm) }
  if($null -ne $rAvv){ $ea = $ea + @($rAvv) }
  $lines = New-Object System.Collections.ArrayList
  $perFin = $per; if($o.ContainsKey('per_fin')){ $perFin = $o['per_fin'] }
  [void]$lines.Add("RE`t0`t10:00:00.000`tTester`tXAUUSD," + $perFin + " (BCMMarkets-Server): testing of Experts\EA_NatCla.ex5 from 2024.07.10 00:00 to 2025.06.30 00:00")
  [void]$lines.Add("CS`t0`t10:00:00.001`tTester`tXAUUSD: ticks data begins from 2024.07.10")
  foreach($x in $ea){ [void]$lines.Add("KO`t0`t10:00:01.000`tEA_NatCla (XAUUSD," + $per + ")`t2024.07.10 00:00:00   " + $x) }
  if($o.ContainsKey('soldi')){ [void]$lines.Add("KO`t0`t10:00:03.000`tEA_NatCla (XAUUSD," + $per + ")`t2024.08.21 10:00:00   [NatCla] INVIO FALLITO NATCLA_A_ST35_O2: retcode 10019 No money") }
  [void]$lines.Add("KO`t0`t10:00:02.000`tEA_NatCla (XAUUSD," + $per + ")`t2024.08.20 22:30:00   [NatCla] INVIO FALLITO NATCLA_A_ST35_O1: retcode 10018 Market closed")
  [void]$lines.Add("CS`t0`t10:05:00.000`tTester`tXAUUSD," + $per + ": 53339206 ticks, 11300 bars generated. Environment synchronized in 0:00:00.020. Test passed in 0:04:00.000")
  $enc = New-Object Text.UnicodeEncoding($false, $true)
  [IO.File]::WriteAllText((Join-Path $LogRoot 'agente.log'), (($lines -join "`r`n") + "`r`n"), $enc)
  $csv = @(("#AVVIO " + $ver + " | modalita' AUDIO | XAUUSD PERIOD_" + $perAv + " | solo conta no | placebo 0.00 ATR | stop GEOMETRIA_ATTUALE"), '#cfg;InpDirezione;NC_DIR_LONG;[FONTE]', ('#cfg;Inclinazione;ACCESA, N 20, soglia ' + $script:ru.Soglia + ' ATR, verso NC_INCL_QUALSIASI;x'), '#cfg;Stop;GEOMETRIA_ATTUALE;x')
  if($null -ne $cTF){ $csv = $csv + @($cTF) }
  if($null -ne $cAmm){ $csv = $csv + @($cAmm) }
  for($i = 0; $i -lt 18; $i++){ $csv = $csv + @('#cfg;Altro' + $i + ';x;y') }
  $csv = $csv + @($INTEST, (RigaSetup '2024.08.01 10:30' '250.00' 2), (RigaSetup '2024.08.02 11:00' '-2500.00' 2), (RigaSetup '2024.08.03 10:30' '250.00' 2))
  $mgCsv = $mg; if($o.ContainsKey('mg_csv')){ $mgCsv = $o['mg_csv'] }
  $pcsv = Join-Path $CommonFiles ('natcla_setup_XAUUSD_' + $mgCsv + '.csv')
  [IO.File]::WriteAllText($pcsv, (($csv -join "`r`n") + "`r`n"), [Text.Encoding]::ASCII)
  $trades = 6; if($o.ContainsKey('trades')){ $trades = $o['trades'] }
  $perRep = $per; if($o.ContainsKey('per_rep')){ $perRep = $o['per_rep'] }
  $r = $repVero.Replace('<b>ABTG_SupertrendReversal</b>', '<b>EA_NatCla</b>').Replace('<b>NASUSD</b>', '<b>XAUUSD</b>').Replace('<b>H1 (2024.09.26 - 2026.06.30)</b>', '<b>' + $perRep + ' (2024.07.10 - 2025.06.30)</b>')
  $r = $r.Replace('Deposito Iniziale:</td>' + "`r`n" + '      <td nowrap colspan="10" align="left"><b>100 000.00</b>', 'Deposito Iniziale:</td>' + "`r`n" + '      <td nowrap colspan="10" align="left"><b>1 000 000.00</b>')
  $r = $r.Replace('Numero di Operazioni di Trading Totali:</td>' + "`r`n" + '      <td nowrap><b>172</b>', 'Numero di Operazioni di Trading Totali:</td>' + "`r`n" + '      <td nowrap><b>' + $trades + '</b>')
  $r = $r.Replace('Profitto Totale Netto:</td>' + "`r`n" + '      <td nowrap><b>4 848.97</b>', 'Profitto Totale Netto:</td>' + "`r`n" + '      <td nowrap><b>-2 000.00</b>')
  [IO.File]::WriteAllText((Join-Path $DataFolder ($script:nomeRep + '.htm')), $r, (New-Object Text.UnicodeEncoding($false, $true)))
  $script:DirLog = @{ $LogRoot = $true }
  $script:PatLog = @()
  . ([scriptblock]::Create((Get-Content -Raw -LiteralPath (Join-Path $DIRC 'b_dopo.ps1'))))
  $script:esito = @{ Motivi = @($motivi); Avvio = $avvioOk; Adx = $adxV; Fin = $finest; Setup = $setupN; Riemp = $riemp; Soldi = $soldiS; Invio = $nInvio }
  Write-Host ('   scenario ' + $nome + ': motivi ' + $motivi.Count + ' | ' + (($motivi | Select-Object -First 3) -join ' || '))
}
# il report VERO riscritto deve contenere le celle che lo scenario sostituisce (altrimenti i contro-esempi del report sarebbero ciechi)
C ($repVero.Contains('<b>H1 (2024.09.26 - 2026.06.30)</b>') -and $repVero.Contains('<b>NASUSD</b>')) 'report vero: celle del periodo e del simbolo presenti (sostituibili)'
Scenario 'M30 pulito' 1 @{}
C ($esito.Motivi.Count -eq 0) 'M30 pulito: nessun motivo'
C ($esito.Avvio -eq 'si' -and $esito.Adx -eq 'MetaQuotes' -and $esito.Fin -eq '2024.07.10-2025.06.30') ('M30 pulito: AVVIO si, ADX MetaQuotes, finestra (' + $esito.Avvio + ' ' + $esito.Adx + ' ' + $esito.Fin + ')')
C ($esito.Setup -eq '3' -and $esito.Riemp -eq '6' -and $esito.Soldi -eq '-2000.00' -and $esito.Invio -eq 1) ('M30 pulito: setup 3, riempiti 6, soldi -2000.00, 10018 contato e non KO (' + $esito.Setup + ' ' + $esito.Riemp + ' ' + $esito.Soldi + ' ' + $esito.Invio + ')')
Scenario 'H1 di controllo pulito' 0 @{}
C ($esito.Motivi.Count -eq 0) 'H1 di controllo pulito (InpAmmettiTFSottoH1=true senza effetto): nessun motivo'
$casi = @(
  @('M30 senza riga AVVISO', 1, @{ senza_avviso = 1 }, 'DEVIAZIONE NON DICHIARATA'),
  @('M30 con CFG InpTF da fonte (senza deviazione)', 1, @{ rTF = '[NatCla] CFG InpTF = PERIOD_M30   A MANO [FONTE A-R8 / P-p05]' }, 'riga CFG InpTF'),
  @('M30 senza CFG InpTF', 1, @{ rTF = $null }, 'riga CFG InpTF'),
  @('M30 con CFG InpAmmettiTFSottoH1 senza effetto', 1, @{ rAmm = "[NatCla] CFG InpAmmettiTFSottoH1 = true   nessun effetto: TF PERIOD_M30 non e' sotto H1 [FIRMA Claudio 11/10/2026]" }, 'riga CFG InpAmmettiTFSottoH1'),
  @('M30 senza CFG InpAmmettiTFSottoH1', 1, @{ rAmm = $null }, 'riga CFG InpAmmettiTFSottoH1'),
  @('M30 CSV con #cfg;InpTF da fonte', 1, @{ cTF = '#cfg;InpTF;PERIOD_M30;A MANO [FONTE A-R8 / P-p05]' }, '#cfg;InpTF del CSV'),
  @('M30 CSV senza #cfg;InpAmmettiTFSottoH1', 1, @{ cAmm = $null }, '#cfg;InpAmmettiTFSottoH1 del CSV'),
  @('M30 con AVVISO di un altro TF', 1, @{ avviso = "[NatCla] AVVISO DEVIAZIONE DALLA FONTE ACCESA: TF PERIOD_M15 sotto H1 (fonte A-R8/R9: 'non sotto H1')" }, 'DEVIAZIONE NON DICHIARATA'),
  @('H1 con riga AVVISO', 0, @{ avviso = "[NatCla] AVVISO DEVIAZIONE DALLA FONTE ACCESA: TF PERIOD_H1 sotto H1" }, 'DEVIAZIONE DICHIARATA su una passata che NON devia'),
  @('H1 con CFG InpTF di deviazione', 0, @{ rTF = "[NatCla] CFG InpTF = PERIOD_H1   A MANO [DEVIAZIONE DALLA FONTE A-R8/R9 'non sotto H1']" }, 'riga CFG InpTF'),
  @('H1 con CFG InpAmmettiTFSottoH1 attiva', 0, @{ rAmm = '[NatCla] CFG InpAmmettiTFSottoH1 = true   DEVIAZIONE ATTIVA: TF PERIOD_H1 sotto H1' }, 'riga CFG InpAmmettiTFSottoH1'),
  @('H1 senza CFG InpAmmettiTFSottoH1 (pin non applicato)', 0, @{ rAmm = $null; cAmm = $null }, 'InpAmmettiTFSottoH1'),
  @('M30 con AVVIO v1.11', 1, @{ ver = 'v1.11' }, 'versione EA'),
  @('M30 girato su H1 (AVVIO)', 1, @{ per_avvio = 'H1' }, 'TF PERIOD_H1 invece di PERIOD_M30'),
  @('M30 con magic H1 (AVVIO e CSV)', 1, @{ mg_avvio = '778601'; mg_csv = '778601' }, 'magic 778601 invece di 778603'),
  @('M30 con report H1', 1, @{ per_rep = 'H1' }, 'periodo del report'),
  @('M30 con finestra del tester su H1', 1, @{ per_fin = 'H1' }, 'finestra girata'),
  @('INVIO FALLITO 10019', 1, @{ soldi = 1 }, 'SOLDI'),
  @('operazioni del report fuori tolleranza', 1, @{ trades = 10 }, 'operazioni del report')
)
foreach($cs0 in $casi){
  Scenario $cs0[0] $cs0[1] $cs0[2]
  $hit = @($esito.Motivi | Where-Object { $_ -like ('*' + $cs0[3] + '*') }).Count
  C ($hit -gt 0) ('contro-esempio "' + $cs0[0] + '" -> motivo con "' + $cs0[3] + '"')
}
# ---------------- 4. il MANIFEST: 33 colonne come la madre (il lettore e il formato restano quelli di F1) ----------------
$script:ru = $runs[1]; $script:sim = $runs[1].Sim; $script:cfg = $runs[1].Cfg; $script:lato = $runs[1].Lato; $script:modo = $runs[1].Modo; $tag = 'M30_002_X'
. ([scriptblock]::Create((Get-Content -Raw -LiteralPath (Join-Path $DIRC 'b_man.ps1'))))
. ([scriptblock]::Create((Get-Content -Raw -LiteralPath (Join-Path $DIRC 'b_base.ps1'))))
$nHead = ($manifest[0] -split ';').Count
$nNonL = (($base + $codaNonLanciata + 'motivo') -split ';').Count
C ($nHead -eq 33 -and $nNonL -eq 33) ('MANIFEST: header ' + $nHead + ' colonne, riga NON_LANCIATA ' + $nNonL + ' (attese 33)')
C ($base.StartsWith('M30;M30_002_X;XAUUSD;AUDIO_M30;LONG;GEOM;778603;0.700;2024.07.10;2025.06.30')) ('MANIFEST: base della passata M30: ' + $base)
Scenario 'per la riga OK' 1 @{}
$tRun = Get-Date; $dur = 200; $stato = 'OK'; $bgTxt = '11300'
. ([scriptblock]::Create((Get-Content -Raw -LiteralPath (Join-Path $DIRC 'b_okrow.ps1'))))
$nOkR = ($manifest[$manifest.Count - 1] -split ';').Count
C ($nOkR -eq 33) ('MANIFEST: riga OK ' + $nOkR + ' colonne (attese 33)')
Write-Host ('CONTROLLI ESEGUITI: ' + $script:nC)
'''

if __name__ == "__main__":
    main()
