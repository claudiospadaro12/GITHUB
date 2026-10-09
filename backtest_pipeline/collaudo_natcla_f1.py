#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
collaudo_natcla_f1.py -- prova A PEZZI di backtest_pipeline/righe/NATCLA_F1_PASSATE.ps1 con il PowerShell vero (pwsh), senza MT5, e i MUTANTI
del driver e del lettore backtest_pipeline/leggi_natcla_f1.py (il lettore ha il suo --autotest; qui si controlla che l'autotest PRENDA errori plausibili).

Come: le FUNZIONI del driver si estraggono con il parser di PowerShell (FunctionDefinitionAst, testo esatto, niente copie) e i tre blocchi IN LINEA
che decidono (lettura del file prova + espansione dei lotti; costruzione dell'.ini; lettura di giornale/report/CSV dopo una passata) si TAGLIANO dal
file fra marcatori di testo che esistono nel sorgente, e si eseguono con '. ([scriptblock]::Create(...))' su dati finti costruiti qui:
  - il file prova VERO (backtest_pipeline/prove/NATCLA_F1_STOP_2026-10-09.txt);
  - un report .htm VERO (risultati_archivio/R290A_PASSATA_STOP_NAS_20261006_2040/PASSATA_STOP_NAS.htm, UTF-16, MT5) riscritto nelle sole celle che contano;
  - un giornale finto nel formato VERO dell'agente ('<tab>EA (SIM,TF)<tab>AAAA.MM.GG hh:mm:ss   [NatCla] ...', UTF-16 LE con BOM, come i .log di MT5);
  - un CSV per-setup nel formato della v1.11 (47 colonne).
Cultura del thread it-IT (classe 5: il driver deve reggere anche senza la riga che imposta InvariantCulture).
LIMITE DICHIARATO: pwsh 7 su Linux, NON Windows PowerShell 5.1 (classe 62 estesa: alcuni difetti esistono solo su 5.1); nessun terminale, nessun
tester, nessun Start-Process: la parte che lancia MT5 e lo zip finale NON sono provati qui.
USO: python3 backtest_pipeline/collaudo_natcla_f1.py [--senza-mutanti]   (esce 1 se un controllo cade o un mutante resta VIVO; ~2 minuti)
"""
import os, shutil, subprocess, sys, tempfile

QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, ".."))
DRIVER = os.path.join(QD, "righe", "NATCLA_F1_PASSATE.ps1")
PROVA = os.path.join(QD, "prove", "NATCLA_F1_STOP_2026-10-09.txt")
LETTORE = os.path.join(QD, "leggi_natcla_f1.py")
REPORT_VERO = os.path.join(QD, "risultati_archivio", "R290A_PASSATA_STOP_NAS_20261006_2040", "PASSATA_STOP_NAS.htm")


def taglia(testo, da, a):
    i = testo.index(da)
    j = testo.index(a, i)
    return testo[i:j]


def esegui(src_driver, stampa=True):
    """esegue il collaudo sul testo src_driver (il driver vero o un mutante). Ritorna (controlli, falliti, rc)."""
    src = src_driver
    tmp = tempfile.mkdtemp(prefix="collaudo_f1_")
    drv = os.path.join(tmp, "driver.ps1")
    open(drv, "w").write(src)
    try:
        b_cost = taglia(src, "$EXPERT = 'EA_NatCla'", "if($Pin -notmatch")
        b_prova = taglia(src, "# --- il file prova: pin, asse tecnico, blocchi F1", "Copy-Item -LiteralPath $srcEA")
        b_ini = taglia(src, "  # --- l'ini: i 73 pin del file prova", "  $foto = Fotografia")
        b_re = taglia(src, "$reAvvio = New-Object", "# la scoperta ricorsiva dei .log")
        b_dopo = taglia(src, "  # --- lettura delle sole righe scritte DOPO la fotografia", "  # il log dell'EA di questa passata, per intero")
        b_man = taglia(src, "$manifest = New-Object System.Collections.ArrayList", "$nOk = 0; $nKo = 0")
        b_base = taglia(src, "  $base = $Lotto + ';'", "  $minDa = ")
        b_okrow = taglia(src, "  [void]$manifest.Add($base + ';' + $tRun", "  $col = 'Green'")
    except ValueError:
        return (0, 1, 1)
    for nome, testo in (("b_cost.ps1", b_cost), ("b_prova.ps1", b_prova), ("b_ini.ps1", b_ini), ("b_re.ps1", b_re), ("b_dopo.ps1", b_dopo), ("b_man.ps1", b_man), ("b_base.ps1", b_base), ("b_okrow.ps1", b_okrow)):
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


# MUTANTI: un errore plausibile per riga sensibile del driver; ognuno DEVE far cadere almeno un controllo (classe 1068/1203: i mutanti li scrive chi collauda)
MUTANTI = [
    ("lato non sostituito", "    if($pp[0] -eq 'InpDirezione'){ $val = $lato['valore'] }\n", ""),
    ("modo non sostituito", "    if($pp[0] -eq 'InpStopModo'){ $val = $modo['valore'] }\n", ""),
    ("soglia non sostituita", "    if($pp[0] -eq 'InpInclMinAtr'){ $val = $ru.Soglia }\n", ""),
    ("deposito 100000 nel .ini", "$DEPOSITO = 1000000", "$DEPOSITO = 100000"),
    ("Modello 1", "$MODELLO = 4", "$MODELLO = 1"),
    ("fine dell'IS sbagliata", "$DATA_A = '2025.06.30'", "$DATA_A = '2026.06.30'"),
    ("M2 x PIU non saltato", "          if($ammessi -notcontains $mn){ $saltati = $saltati + 1; continue }", "          if($false){ $saltati = $saltati + 1; continue }"),
    ("controllo del deposito del report tolto", "if($null -eq $lr.Deposito -or [math]::Abs($lr.Deposito - $DEPOSITO) -gt 0.5)", "if($false)"),
    ("colla operazioni tolta", "if($dTr -lt 0 -or $dTr -gt 3)", "if($false)"),
    ("colla soldi tolta", "if([math]::Abs($lr.Profitto - $cs.Soldi) -gt $tolS)", "if($false)"),
    ("CFG InpDirezione non controllata", "if(-not $cfgDirOk){", "if($false){"),
    ("tick: tutti i simboli invece del solo simbolo della prova", "if($pz2[0] -eq $sim['nome']){", "if($true){"),
    ("10019 non conta", "if($mi.Groups['rc'].Value -eq '10019'){", "if($false){"),
    ("lotto<min non conta", "if($nLottoMin -gt 0){", "if($false){"),
    ("righe CONTA ammesse", "if($cs.Conta -gt 0){", "if($false){"),
    ("CSV non fresco accettato", "if($it.LastWriteTime -ge $tDa){ return $it }", "return $it"),
    ("somma soldi con la cultura del thread", "$r.Soldi = $r.Soldi + (Num $c[$iS])", "$r.Soldi = $r.Soldi + [double]$c[$iS].Replace('.', ',')"),
    ("troncate non tolte", "if($tr){ $tronche[$kq] = $true }", "if($false){ $tronche[$kq] = $true }"),
    ("qualita non controllata", "if($lr.Qualita -notmatch '^100%')", "if($false)"),
    ("SoloConta non bloccato nel file prova", "$pinFissi = @{ InpSoloConta = 'false';", "$pinFissi = @{ InpSoloContaX = 'false';"),
    ("riga NON_LANCIATA con una colonna in piu", "$codaNonLanciata = ';;0;NON_LANCIATA' + (';' * 16)", "$codaNonLanciata = ';;0;NON_LANCIATA' + (';' * 17)"),
]


# MUTANTI DEL LETTORE: un mutante e' PRESO solo se l'autotest gira fino in fondo e ne fa cadere almeno uno (un crash non vale come presa)
MUTANTI_LETTORE = [
    ("regola del segno spenta", "return pos, len(votanti), (len(votanti) >= 2 and pos >= serve)", "return pos, len(votanti), True"),
    ("commissione derivata mai sottratta", 'cr = 0.0 if tester_comm else comm_r(r, P["sim"])', "cr = 0.0"),
    ("soglia n 100", "N_GAMBA = 150 ", "N_GAMBA = 100 "),
    ("PF vivo 1,0", "PF_VIVO = 1.15", "PF_VIVO = 1.0"),
    ("lato della riga non controllato", 'if int(r["lato"]) != s:', "if False:"),
    ("SL GEOM non controllato", 'if abs(sl - x4) > tol:\n            return "GEOMETRIA_ATTUALE', 'if False:\n            return "GEOMETRIA_ATTUALE'),
    ("delta dei modi 0", "DPF_MODO = 0.10", "DPF_MODO = 0.0"),
    ("deposito non controllato", 'if rep["deposito"] is None or abs(rep["deposito"] - DEPOSITO) > 0.5:', "if False:"),
    ("colla operazioni tolta", "if d < 0 or d > TOL_TRADES:", "if False:"),
    ("VERIFICA ADX non controllata", 'if len(g["verifica"]) != 1 or "il terminale coincide con: formula MetaQuotes" not in g["verifica"][0]:', "if False:"),
    ("PIU con la linea dentro ammesso", 'if r["linea"] == "ST35" and modo["valore"] == "2" and s * (lp - ls) < -tl:', "if False:"),
    ("determinismo sempre IDENTICHE", 'out.append((k, "IDENTICHE" if visti[k] == impronta else "DIVERSE"))', 'out.append((k, "IDENTICHE"))'),
]


def main():
    src = open(DRIVER, encoding="ascii").read()
    n, f, rc = esegui(src)
    print("COLLAUDO DRIVER F1: %d controlli, %d falliti" % (n, f))
    if "--senza-mutanti" in sys.argv:
        sys.exit(0 if (n and not f and rc == 0) else 1)
    vivi = []
    for nome, a, b in MUTANTI:
        if a not in src:
            print("   MUTANTE %s: testo d'ancora NON trovato nel driver (il mutante va riscritto)" % nome)
            vivi.append(nome)
            continue
        nm, fm, rcm = esegui(src.replace(a, b, 1), stampa=False)
        preso = fm > 0 or rcm != 0 or nm < n
        print("   MUTANTE %-55s %s (controlli %d, falliti %d, rc %d)" % (nome, "PRESO" if preso else "VIVO", nm, fm, rcm))
        if not preso:
            vivi.append(nome)
    print("MUTANTI DEL DRIVER: %d presi su %d" % (len(MUTANTI) - len(vivi), len(MUTANTI)))
    # il lettore: autotest sul vero, poi sui mutanti (copia in una cartella con backtest_pipeline/prove/<file prova>, come nel repo)
    r0 = subprocess.run([sys.executable, "-I", LETTORE, "--autotest"], capture_output=True, text=True)
    print("AUTOTEST DEL LETTORE (vero): " + (r0.stdout.strip().splitlines() or ["?"])[-1])
    lsrc = open(LETTORE, encoding="ascii").read()
    tmp = tempfile.mkdtemp(prefix="collaudo_f1_lettore_")
    os.makedirs(os.path.join(tmp, "backtest_pipeline", "prove"))
    shutil.copy(PROVA, os.path.join(tmp, "backtest_pipeline", "prove"))
    vivi_l = []
    for nome, a, b in MUTANTI_LETTORE:
        if a not in lsrc:
            print("   MUTANTE LETTORE %s: testo d'ancora NON trovato" % nome)
            vivi_l.append(nome)
            continue
        pm = os.path.join(tmp, "backtest_pipeline", "leggi_natcla_f1.py")
        open(pm, "w").write(lsrc.replace(a, b, 1))
        rm = subprocess.run([sys.executable, "-I", pm, "--autotest"], capture_output=True, text=True)
        ultimo = (rm.stdout.strip().splitlines() or ["?"])[-1]
        preso = rm.returncode != 0 and ultimo.startswith("AUTOTEST:")
        print("   MUTANTE LETTORE %-36s %s (%s)" % (nome, "PRESO" if preso else "VIVO", ultimo))
        if not preso:
            vivi_l.append(nome)
    shutil.rmtree(tmp, ignore_errors=True)
    print("MUTANTI DEL LETTORE: %d presi su %d" % (len(MUTANTI_LETTORE) - len(vivi_l), len(MUTANTI_LETTORE)))
    sys.exit(0 if (n and not f and rc == 0 and not vivi and not vivi_l and r0.returncode == 0) else 1)


TEST_PS = r'''
$ErrorActionPreference = 'Stop'
[Threading.Thread]::CurrentThread.CurrentCulture = [Globalization.CultureInfo]::GetCultureInfo('it-IT')
$IC = [Globalization.CultureInfo]::InvariantCulture
$DIRC = '@@TMP@@'; $env:USERPROFILE = $DIRC   # NON $T: PowerShell non distingue maiuscole e il blocco del driver usa $t
$script:nC = 0
function C($cond, $nome){ $script:nC++; if($cond){ Write-Host ('CONTROLLO ' + $nome + ' OK') } else { Write-Host ('CONTROLLO ' + $nome + ' FALLITO') } }
. ([scriptblock]::Create((Get-Content -Raw -LiteralPath (Join-Path $DIRC 'b_cost.ps1'))))
# le funzioni del driver, testo esatto, dal parser di PowerShell
$ast = [System.Management.Automation.Language.Parser]::ParseFile('@@DRIVER@@', [ref]$null, [ref]$null)
$fdefs = $ast.FindAll({ param($n) $n -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)
foreach($fd in $fdefs){ . ([scriptblock]::Create($fd.Extent.Text)) }
C ($fdefs.Count -ge 14) ('funzioni estratte: ' + $fdefs.Count)

# ---------------- 1. il file prova VERO e l'espansione dei lotti ----------------
$fileProva = Join-Path $DIRC 'prova.txt'
$attesi = @{ P = 4; O = 20; FA = 80; FB = 60; I = 36 }
foreach($L in @('P','O','FA','FB','I')){
  $Lotto = $L
  . ([scriptblock]::Create((Get-Content -Raw -LiteralPath (Join-Path $DIRC 'b_prova.ps1'))))
  C ($runs.Count -eq $attesi[$L]) ('lotto ' + $L + ': ' + $runs.Count + ' passate (attese ' + $attesi[$L] + ')')
  if($L -eq 'O'){
    $m2piu = @($runs | Where-Object { $_.Cfg['nome'] -like 'M2_*' -and $_.Modo['nome'] -eq 'PIU' }).Count
    C ($m2piu -eq 0 -and $saltati -eq 4) ('lotto O: nessuna passata M2 x PIU, saltate ' + $saltati + ' (attese 4)')
    $r0 = $runs[0]
    C ($r0.Soglia -eq '0.700' -and $r0.Sim['nome'] -eq 'XAUUSD' -and $r0.Cfg['nome'] -eq 'AUDIO_H1') ('lotto O: prima passata XAUUSD AUDIO_H1 soglia ' + $r0.Soglia)
  }
  if($L -eq 'I'){
    $geom = @($runs | Where-Object { $_.Modo['nome'] -eq 'GEOM' }).Count
    C ($geom -eq 0) 'lotto I: nessuna passata GEOM (escluso per costo)'
  }
  if($L -eq 'P'){
    $v = ($runs | ForEach-Object { $_.Sim['nome'] + ':' + $_.Cfg['nome'] + ':' + $_.Lato['nome'] + ':' + $_.Modo['nome'] }) -join ','
    C ($v -eq 'XAUUSD:AUDIO_H1:LONG:GEOM,XAUUSD:AUDIO_H1:LONG:PIU,EURUSD:AUDIO_H1:SHORT:LINEA,EURUSD:M2_H1:SHORT:GEOM') ('lotto P: ' + $v)
  }
}
# contro-esempi del file prova: ognuno deve FERMARE lo script (throw)
function ProvaRotta($nome, $sost){
  $txt = Get-Content -Raw -LiteralPath (Join-Path $DIRC 'prova.txt')
  $rotta = & $sost $txt
  $fp = Join-Path $DIRC 'prova_rotta.txt'
  Set-Content -LiteralPath $fp -Value $rotta -NoNewline
  $script:fileProva = $fp; $script:Lotto = 'P'
  $preso = $false
  try { . ([scriptblock]::Create((Get-Content -Raw -LiteralPath (Join-Path $DIRC 'b_prova.ps1')))) } catch { $preso = $true; $script:ultimo = $_.Exception.Message }
  C $preso ('prova rotta "' + $nome + '" -> lo script si ferma (' + $script:ultimo + ')')
  $script:fileProva = Join-Path $DIRC 'prova.txt'
}
ProvaRotta 'SoloConta=true' { param($t) $t.Replace('InpSoloConta=false', 'InpSoloConta=true') }
ProvaRotta 'rischio 0.5' { param($t) $t.Replace('InpRischioSetupPct=0.25', 'InpRischioSetupPct=0.5') }
ProvaRotta 'pin doppio' { param($t) $t.Replace('InpPlaceboAtr=0', "InpPlaceboAtr=0`r`nInpPlaceboAtr=0") }
ProvaRotta 'soglia a 2 decimali' { param($t) $t.Replace('soglia=0.700', 'soglia=0.70') }
ProvaRotta 'pin mancante' { param($t) ($t -replace "(?m)^InpStopModo=0\r?\n", "") }
ProvaRotta 'modo PIU su M2 in lista esplicita' { param($t) $t.Replace('EURUSD:M2_H1:SHORT:GEOM', 'EURUSD:M2_H1:SHORT:PIU') }
ProvaRotta 'asse diverso' { param($t) $t.Replace('InpMagic=0||0||1||1||Y', 'InpMagic=0||0||1||2||Y') }
ProvaRotta 'StopOltreU 30' { param($t) $t.Replace('InpStopOltreU=20.0', 'InpStopOltreU=30.0') }
ProvaRotta 'finestra vuota' { param($t) $t.Replace('nome=EURUSD classe=FX famiglia=FX7 da=2024.07.05', 'nome=EURUSD classe=FX famiglia=FX7 da=2025.07.05') }

# ---------------- 2. l'.ini di una passata ----------------
$fileProva = Join-Path $DIRC 'prova.txt'; $Lotto = 'P'
. ([scriptblock]::Create((Get-Content -Raw -LiteralPath (Join-Path $DIRC 'b_prova.ps1'))))
$Work = Join-Path $DIRC 'work'; New-Item -ItemType Directory -Force -Path $Work | Out-Null
$Cart = Join-Path $DIRC 'cart'; New-Item -ItemType Directory -Force -Path (Join-Path $Cart 'ini'), (Join-Path $Cart 'csv'), (Join-Path $Cart 'trades'), (Join-Path $Cart 'report'), (Join-Path $Cart 'log') | Out-Null
$ru = $runs[2]; $sim = $ru.Sim; $cfg = $ru.Cfg; $lato = $ru.Lato; $modo = $ru.Modo
$tag = 'P_003_EURUSD_AUDIO_H1_SHORT_LINEA'
. ([scriptblock]::Create((Get-Content -Raw -LiteralPath (Join-Path $DIRC 'b_ini.ps1'))))
$ini = Get-Content -Raw -LiteralPath $iniF
$ti = @($ini -split "`r`n" | Where-Object { $_ -match '^Inp' })
C ($ti.Count -eq 74) ('ini: 74 input (73 pin + InpMagic), letti ' + $ti.Count)
foreach($atteso in @('InpModalita=0','InpTF=16385','InpDirezione=2','InpStopModo=1','InpInclMinAtr=0.623','InpMagic=0','InpSoloConta=false','InpRischioSetupPct=0.25','InpStopOltreU=20.0')){ C ($ti -contains $atteso) ('ini contiene ' + $atteso) }
foreach($atteso in @('Model=4','Optimization=0','FromDate=2024.07.05','ToDate=2025.06.30','Deposit=1000000','Currency=EUR','AllowLiveTrading=false','Symbol=EURUSD','Period=H1','Report=NATCLA_F1_P_003_EURUSD_AUDIO_H1_SHORT_LINEA','ShutdownTerminal=1')){ C ($ini.Contains($atteso + "`r`n")) ('ini contiene ' + $atteso) }
C (-not ($ini -match 'InpMagic=0\|\|')) 'ini senza la riga dell asse'

# ---------------- 3. dopo la passata: giornale, report, CSV (dati finti nel formato vero) ----------------
. ([scriptblock]::Create((Get-Content -Raw -LiteralPath (Join-Path $DIRC 'b_re.ps1'))))
$DataFolder = Join-Path $DIRC 'dati'; $InstAttesa = Join-Path $DIRC 'inst'; $MqlFiles = Join-Path $DIRC 'mqlfiles'; $CommonFiles = Join-Path $DIRC 'common'; $LogRoot = Join-Path $DIRC 'logroot'
New-Item -ItemType Directory -Force -Path $DataFolder, $InstAttesa, $MqlFiles, $CommonFiles, $LogRoot | Out-Null
$repVero = Get-Content -Raw -LiteralPath (Join-Path $DIRC 'report_vero.txt') -Encoding UTF8
$INTEST = 'tipo;barra;linea;lato;tocco_n;nuovo_ep;troncato;ctx_arm;ctx_tocco;vicino_ok;conferma_ok;dist_apertura_atr;adx;incl_atr;confl_dist_atr;confl_etichetta;ema9;ema21;bb_larg;atr14;linea_prezzo;ingresso;n_ordini;p1;p2;p3;sl;tp1;tp2;tp3;lotto1;lotto2;lotto3;spread;commissione;stop_ped1;stop_ped2;stop_ped3;rischio_soldi;n_riempiti;esito_soldi;esito_R;durata_min;motivo;stop_modo;linea_stop;stop_esito'
function RigaSetup($barra, $soldi, $riemp){ return ('SETUP;' + $barra + ';ST35;-1;1;;;;;;;0.000;15.00;0.900;1.000;0;0;0;0;0.00100;1.10000;SCALA3;3;1.09950;1.10000;1.10050;1.10200;1.09900;1.09900;1.09900;9.00;9.00;9.00;0.00004;0;50.0;40.0;30.0;2500.00;' + $riemp + ';' + $soldi + ';' + ([double]::Parse($soldi, $IC) / 2500.0).ToString('0.000', $IC) + ';45.0;TP;1;1.10000;0') }
function Scenario($nome, $o){
  # pulizia
  foreach($d in @($CommonFiles, $DataFolder, $LogRoot)){ Get-ChildItem -LiteralPath $d -File | Remove-Item -Force }
  $script:sim = $runs[2].Sim; $script:cfg = $runs[2].Cfg; $script:lato = $runs[2].Lato; $script:modo = $runs[2].Modo; $script:ru = $runs[2]
  $script:tag = 'P_003_EURUSD_AUDIO_H1_SHORT_LINEA'; $script:nomeRep = 'NATCLA_F1_' + $script:tag
  $script:timeout = $false; $script:foto = @{}
  $script:tRun = (Get-Date).AddSeconds(-30)
  $stop = 'OLTRE_LINEA_ESTERNA 20.00 u'; if($o.ContainsKey('stop')){ $stop = $o['stop'] }
  $dir = 'NC_DIR_SHORT'; if($o.ContainsKey('dir')){ $dir = $o['dir'] }
  $soglia = '0.623'; if($o.ContainsKey('soglia')){ $soglia = $o['soglia'] }
  $avvio = "[NatCla] AVVIO v1.11 | modalita' AUDIO | EURUSD PERIOD_H1 | 1 u = 0.00010 (AUTO_CLASSE forex: pip) | 1 pip = 0.00010 | magic 778601 | linee ST25 ST30 ST35 | ADX ACCESO, iADX MetaQuotes, max 20.0, periodo 14 | ingresso SCALA3_PENDENTI | rischio setup 0.25% (SEGNAPOSTO DA FIRMARE DA CLAUDIO) | guardian ON (nel tester FAIL-OPEN) | solo conta no | placebo 0.00 ATR | fonte SOLO AUDIO (PDF escluso 07/10) | stop " + $stop
  if($o.ContainsKey('avvio_tronca')){ $avvio = $avvio.Substring(0, $avvio.IndexOf(' | fonte')) }
  $rigaDir = '[NatCla] CFG InpDirezione = ' + $dir + '   [FONTE: direzione mai dichiarata, A-R26]'
  if($o.ContainsKey('senza_cfg_dir')){ $rigaDir = '[NatCla] CFG Altro = x' }
  $ea = @($avvio, $rigaDir, ('[NatCla] CFG Inclinazione = ACCESA, N 20, soglia ' + $soglia + ' ATR, verso NC_INCL_QUALSIASI   DA_MODALITA [FONTE A-R19] misura [NOSTRA]'), ('[NatCla] CFG Stop = ' + $stop + '   v1.10 [FONTE Claudio 08/10]'), '[NatCla] VERIFICA ADX barra 2024.07.08 10:00 periodo 14: terminale iADX = 21.34 | ricalcolo MetaQuotes = 21.30 | ricalcolo Wilder = 18.10 -> il terminale coincide con: formula MetaQuotes (DI per barra, media esponenziale 2/(n+1))')
  $lines = New-Object System.Collections.ArrayList
  [void]$lines.Add("RE`t0`t10:00:00.000`tTester`tEURUSD,H1 (BCMMarkets-Server): testing of Experts\EA_NatCla.ex5 from 2024.07.05 00:00 to 2025.06.30 00:00")
  if($o.ContainsKey('tick_tardi')){ [void]$lines.Add("CS`t0`t10:00:00.002`tTester`tEURUSD: ticks data begins from 2024.09.01") }
  elseif($o.ContainsKey('altro_simbolo')){ [void]$lines.Add("CS`t0`t10:00:00.002`tTester`tXAUUSD: ticks data begins from 2025.01.01") }
  else { [void]$lines.Add("CS`t0`t10:00:00.001`tTester`tEURUSD: ticks data begins from 2024.07.05") }
  foreach($x in $ea){ [void]$lines.Add("KO`t0`t10:00:01.000`tEA_NatCla (EURUSD,H1)`t2024.07.05 00:00:00   " + $x) }
  # dieci righe di testo uguale in ore diverse: la deduplica non deve fonderle
  for($i = 1; $i -le 10; $i++){ [void]$lines.Add("KO`t0`t10:00:02.000`tEA_NatCla (EURUSD,H1)`t2024.08." + $i.ToString('00') + " 10:00:00   [NatCla] RIEMPITO ST35 SHORT (tocco n.1)") }
  # la stessa riga in DUE log, una troncata (classe 1173): conta UNA volta
  [void]$lines.Add("KO`t0`t10:00:02.000`tEA_NatCla (EURUSD,H1)`t2024.08.20 10:00:00   [NatCla] INVIO FALLITO NATCLA_A_ST35_O1: retcode 10015 Invalid price")
  if($o.ContainsKey('soldi')){ [void]$lines.Add("KO`t0`t10:00:03.000`tEA_NatCla (EURUSD,H1)`t2024.08.21 10:00:00   [NatCla] INVIO FALLITO NATCLA_A_ST35_O2: retcode 10019 No money") }
  if($o.ContainsKey('stopout')){ [void]$lines.Add("CS`t0`t10:00:03.000`tTester`tstop out occurred on 2024.09.01") }
  if($o.ContainsKey('lottomin')){ [void]$lines.Add("KO`t0`t10:00:03.000`tEA_NatCla (EURUSD,H1)`t2024.08.22 10:00:00   [NatCla] SCARTATO ST35 O1: lotto sotto il minimo (mai alzato al minimo)") }
  [void]$lines.Add("CS`t0`t10:05:00.000`tTester`tEURUSD,H1: 31000000 ticks, 6200 bars generated. Environment synchronized in 0:00:00.020. Test passed in 0:02:30.000")
  $enc = New-Object Text.UnicodeEncoding($false, $true)
  [IO.File]::WriteAllText((Join-Path $LogRoot 'agente.log'), (($lines -join "`r`n") + "`r`n"), $enc)
  $copia = @("KO`t0`t10:00:02.000`tEA_NatCla (EURUSD,H1)`t2024.08.20 10:00:00   [NatCla] INVIO FALLITO NATCLA_A_ST35_O1: retcode 10015 Inv")
  [IO.File]::WriteAllText((Join-Path $LogRoot 'terminale.log'), (($copia -join "`r`n") + "`r`n"), $enc)
  # il CSV per-setup: 3 setup da 2 riempiti, esiti +250, -2500, +250 (somma -2000)
  $csv = @(('#AVVIO v1.11 | modalita'' AUDIO | EURUSD PERIOD_H1 | solo conta no | placebo 0.00 ATR | stop ' + $stop), ('#cfg;InpDirezione;' + $dir + ';[FONTE]'), ('#cfg;Inclinazione;ACCESA, N 20, soglia ' + $soglia + ' ATR, verso NC_INCL_QUALSIASI;x'), ('#cfg;Stop;' + $stop + ';x'))
  for($i = 0; $i -lt 18; $i++){ $csv = $csv + @('#cfg;Altro' + $i + ';x;y') }
  $csv = $csv + @($INTEST, (RigaSetup '2024.08.01 10:00' '250.00' 2), (RigaSetup '2024.08.02 10:00' '-2500.00' 2), (RigaSetup '2024.08.03 10:00' '250.00' 2))
  if($o.ContainsKey('conta')){ $csv = $csv + @('CONTA;2024.08.04 10:00;ST35;-1') }
  $pcsv = Join-Path $CommonFiles 'natcla_setup_EURUSD_778601.csv'
  [IO.File]::WriteAllText($pcsv, (($csv -join "`r`n") + "`r`n"), [Text.Encoding]::ASCII)
  if($o.ContainsKey('csv_vecchio')){ (Get-Item -LiteralPath $pcsv).LastWriteTime = $script:tRun.AddMinutes(-10) }
  # il report VERO riscritto: EA, simbolo, periodo, deposito, operazioni, profitto, qualita
  $trades = 6; if($o.ContainsKey('trades')){ $trades = $o['trades'] }
  $prof = '-2 000.00'; if($o.ContainsKey('prof')){ $prof = $o['prof'] }
  $dep = '1 000 000.00'; if($o.ContainsKey('dep')){ $dep = $o['dep'] }
  $qual = '100% ticks reali'; if($o.ContainsKey('qual')){ $qual = $o['qual'] }
  $r = $repVero.Replace('<b>ABTG_SupertrendReversal</b>', '<b>EA_NatCla</b>').Replace('<b>NASUSD</b>', '<b>EURUSD</b>').Replace('<b>H1 (2024.09.26 - 2026.06.30)</b>', '<b>H1 (2024.07.05 - 2025.06.30)</b>')
  $r = $r.Replace('Deposito Iniziale:</td>' + "`r`n" + '      <td nowrap colspan="10" align="left"><b>100 000.00</b>', 'Deposito Iniziale:</td>' + "`r`n" + '      <td nowrap colspan="10" align="left"><b>' + $dep + '</b>')
  $r = $r.Replace('Numero di Operazioni di Trading Totali:</td>' + "`r`n" + '      <td nowrap><b>172</b>', 'Numero di Operazioni di Trading Totali:</td>' + "`r`n" + '      <td nowrap><b>' + $trades + '</b>')
  $r = $r.Replace('Profitto Totale Netto:</td>' + "`r`n" + '      <td nowrap><b>4 848.97</b>', 'Profitto Totale Netto:</td>' + "`r`n" + '      <td nowrap><b>' + $prof + '</b>')
  $r = $r.Replace('<b>100% ticks reali</b>', '<b>' + $qual + '</b>')
  if(-not $o.ContainsKey('senza_report')){ [IO.File]::WriteAllText((Join-Path $DataFolder ($script:nomeRep + '.htm')), $r, (New-Object Text.UnicodeEncoding($false, $true))) }
  $script:DirLog = @{ $LogRoot = $true }
  $script:PatLog = @()
  . ([scriptblock]::Create((Get-Content -Raw -LiteralPath (Join-Path $DIRC 'b_dopo.ps1'))))
  $script:esito = @{ Motivi = @($motivi); Avvio = $avvioOk; Adx = $adxV; Fin = $finest; Setup = $setupN; Riemp = $riemp; Soldi = $soldiS; Invio = $nInvio; Unici = $eaOrd.Count; LottoMin = $nLottoMin; Trades = $nTrades; Dep = $depRep }
  Write-Host ('   scenario ' + $nome + ': motivi ' + $motivi.Count + ' | ' + (($motivi | Select-Object -First 3) -join ' || '))
}
Scenario 'pulito' @{}
C ($esito.Motivi.Count -eq 0) 'scenario pulito: nessun motivo'
C ($esito.Avvio -eq 'si' -and $esito.Adx -eq 'MetaQuotes' -and $esito.Fin -eq '2024.07.05-2025.06.30') ('pulito: AVVIO si, ADX MetaQuotes, finestra (' + $esito.Avvio + ' ' + $esito.Adx + ' ' + $esito.Fin + ')')
C ($esito.Setup -eq '3' -and $esito.Riemp -eq '6' -and $esito.Soldi -eq '-2000.00') ('pulito: setup 3, riempiti 6, soldi -2000.00 con cultura it-IT (' + $esito.Setup + ' ' + $esito.Riemp + ' ' + $esito.Soldi + ')')
C ($esito.Invio -eq 1) ('pulito: la riga INVIO FALLITO presente in due log (una troncata) conta UNA volta (' + $esito.Invio + ')')
C ($esito.Unici -ge 16) ('pulito: le 10 righe RIEMPITO di testo uguale in ore diverse NON sono fuse (righe uniche ' + $esito.Unici + ')')
C ($esito.Dep -eq '1000000.00') ('pulito: deposito riletto dal report vero riscritto: ' + $esito.Dep)
Scenario 'avvio troncato (senza | stop)' @{ avvio_tronca = 1 }
C ($esito.Motivi.Count -eq 0 -and $esito.Avvio -eq 'si') 'AVVIO troncato prima di "| stop": nessun KO (lo stop lo dicono CFG Stop e il #AVVIO del CSV)'
$casi = @(
  @('lato sbagliato', @{ dir = 'NC_DIR_LONG' }, 'InpDirezione'),
  @('soglia sbagliata', @{ soglia = '0.000' }, 'Inclinazione'),
  @('stop sbagliato', @{ stop = 'GEOMETRIA_ATTUALE' }, 'stop'),
  @('INVIO FALLITO 10019', @{ soldi = 1 }, 'SOLDI'),
  @('stop out', @{ stopout = 1 }, 'SOLDI'),
  @('lotto sotto il minimo', @{ lottomin = 1 }, 'LOTTO SOTTO IL MINIMO'),
  @('tick del simbolo tardivi', @{ tick_tardi = 1 }, 'ticks data begins'),
  @('qualita 99%', @{ qual = '99% ticks reali' }, 'qualita'),
  @('deposito 100000', @{ dep = '100 000.00' }, 'deposito'),
  @('operazioni del report fuori tolleranza', @{ trades = 10 }, 'operazioni del report'),
  @('profitto del report lontano', @{ prof = '7 000.00' }, 'profitto del report'),
  @('righe CONTA', @{ conta = 1 }, 'CONTA'),
  @('CSV vecchio', @{ csv_vecchio = 1 }, 'NON trovato fresco'),
  @('report assente', @{ senza_report = 1 }, 'report .htm'),
  @('riga CFG InpDirezione assente dal giornale', @{ senza_cfg_dir = 1 }, 'InpDirezione')
)
foreach($cs0 in $casi){
  Scenario $cs0[0] $cs0[1]
  $hit = @($esito.Motivi | Where-Object { $_ -like ('*' + $cs0[2] + '*') }).Count
  C ($hit -gt 0) ('contro-esempio "' + $cs0[0] + '" -> motivo con "' + $cs0[2] + '"')
}
# la riga di un ALTRO simbolo (conversione) con una data tardiva non fa KO (classe 1205): si guarda solo il simbolo della prova
Scenario 'riga tick di un altro simbolo' @{ altro_simbolo = 1 }
C ($esito.Motivi.Count -eq 0) 'riga "ticks data begins" di un altro simbolo, tardiva: nessun KO (classe 1205)'
# ---------------- 4. il MANIFEST: header, riga OK e riga NON_LANCIATA con lo STESSO numero di colonne (33) ----------------
$script:sim = $runs[2].Sim; $script:cfg = $runs[2].Cfg; $script:lato = $runs[2].Lato; $script:modo = $runs[2].Modo; $script:ru = $runs[2]; $tag = 'P_003_X'
. ([scriptblock]::Create((Get-Content -Raw -LiteralPath (Join-Path $DIRC 'b_man.ps1'))))
. ([scriptblock]::Create((Get-Content -Raw -LiteralPath (Join-Path $DIRC 'b_base.ps1'))))
$nHead = ($manifest[0] -split ';').Count
$nNonL = (($base + $codaNonLanciata + 'motivo') -split ';').Count
C ($nHead -eq 33 -and $nNonL -eq 33) ('MANIFEST: header ' + $nHead + ' colonne, riga NON_LANCIATA ' + $nNonL + ' (attese 33)')
Scenario 'per la riga OK' @{}
$tRun = Get-Date; $dur = 120; $stato = 'OK'; $bgTxt = '6200'
. ([scriptblock]::Create((Get-Content -Raw -LiteralPath (Join-Path $DIRC 'b_okrow.ps1'))))
$nOkR = ($manifest[$manifest.Count - 1] -split ';').Count
C ($nOkR -eq 33) ('MANIFEST: riga OK ' + $nOkR + ' colonne (attese 33)')
Write-Host ('CONTROLLI ESEGUITI: ' + $script:nC)
'''

if __name__ == "__main__":
    main()
