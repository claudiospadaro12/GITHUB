#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
bootstrap.py -- scrive la RIGA di lancio di un lotto di NATCLA_F0 (UNA riga fisica, ASCII) in backtest_pipeline/righe/RIGA_LANCIA_NATCLA_F0_<LOTTO>.txt.
Stessa forma di collaudo_riga_R290A/bootstrap.py (la riga e' anche il lancio): scarica NATCLA_F0_PASSATE.ps1 dal commit PINNATO (letto con git show, MAI dal disco), ne controlla l'IMPRONTA
SHA256 e il marcatore, lo scrive sul disco e RICONTROLLA l'impronta del file scritto, e solo allora lo lancia, passandogli anche le impronte SHA256 dell'EA, dell'include e del file prova
(calcolate qui dal commit): lo script le ricontrolla sui file che scarica al pin.
Il commit passato DEVE essere raggiungibile da origin/lavoro (git merge-base --is-ancestor): un commit riscritto da un rebase e' un 404 su GitHub raw.
Uso: python3 backtest_pipeline/collaudo_natcla_f0/bootstrap.py <COMMIT_40_hex> <LOTTO: PILOTA|A|B|C|D|C0> [--dest FILE] [--senza-origin]
C0 (07/10 notte) = VERIFICA DEL RIMEDIO v1.05 sugli indici (4 passate): la riga del lotto C dice di lanciarla SOLO dopo C0 superato.
"""
import hashlib, os, re, subprocess, sys

QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
sys.path.insert(0, QD)
import prova_pins as PP

C = sys.argv[1]
LOTTO = sys.argv[2]
assert re.match(r"^[0-9a-f]{40}$", C), "il commit va passato di 40 caratteri esadecimali minuscoli"
assert LOTTO in ("PILOTA", "A", "B", "C", "D", "C0"), "lotto sconosciuto"
if "--senza-origin" not in sys.argv:
    r = subprocess.run(["git", "merge-base", "--is-ancestor", C, "origin/lavoro"], cwd=REPO)
    assert r.returncode == 0, "il commit %s NON e' raggiungibile da origin/lavoro: prima push, poi bootstrap" % C[:8]
FILE = "backtest_pipeline/righe/NATCLA_F0_PASSATE.ps1"
FPROVA = "backtest_pipeline/prove/NATCLA_F0_conteggio_2026-10-07.txt"
FEA = "mql5/Experts/EA_NatCla.mq5"
FINC = "mql5/Include/ABTG_PausaGuardian.mqh"
for rel in (FILE, FPROVA, FEA, FINC):
    assert subprocess.run(["git", "cat-file", "-e", "%s:%s" % (C, rel)], cwd=REPO).returncode == 0, "il commit %s non contiene %s" % (C[:8], rel)


def git_show(rel):
    return subprocess.run(["git", "show", "%s:%s" % (C, rel)], cwd=REPO, capture_output=True, check=True).stdout


def sha(b):
    return hashlib.sha256(b).hexdigest().upper()


src = git_show(FILE)
src.decode("ascii")
H = sha(src)
SEA, SINC, SPROVA = sha(git_show(FEA)), sha(git_show(FINC)), sha(git_show(FPROVA))
mver = re.search(rb'#define NC_VER "([0-9.]+)"', git_show(FEA))
assert mver, "NC_VER non trovato nell'EA al pin"
VER = mver.group(1).decode("ascii")
mvs = re.search(rb"\$VERSIONE_ATTESA = '([0-9.]+)'", src)
assert mvs and mvs.group(1).decode("ascii") == VER, "la versione attesa dallo script al pin NON e' NC_VER dell'EA al pin: la riga partirebbe per fermarsi"
MARC = "MARCATORE_NATCLA_F0_PASSATE_v1"
assert src.count(MARC.encode()) >= 1 and src.splitlines()[1].decode() == "#  " + MARC, "il marcatore deve stare alla riga 2 dello script"
# i lotti: letti dal file prova AL PIN (la sola fonte), da un file temporaneo FUORI dal repo
import tempfile
fd, tmpf = tempfile.mkstemp(prefix="prova_al_pin_", suffix=".txt")
os.close(fd)
open(tmpf, "wb").write(git_show(FPROVA))
try:
    P = PP.leggi_prova(tmpf)
finally:
    os.remove(tmpf)
lot = [l for l in P["lotti"] if l["nome"] == LOTTO]
assert len(lot) == 1
lot = lot[0]
simboli = lot["simboli"].split(",")
configs = lot["configs"].split(",")
nrun = len(simboli) * len(configs)
tetto = int(lot["tetto_min"])
bassa, alta = nrun * 23 / 60.0, nrun * 68 / 60.0   # [MISURATO] MANIFEST_F0.csv del pilota (28-40 s), del lotto B (23-68 s) e del lotto D (28-33 s), 07/10

bersaglio = ("BERSAGLIO: SOLO una finestra PowerShell sul PC di backtest DESKTOP-H4D7CAJ: terminale C:\\Program Files\\BCM Markets MT5 Terminal (cartella BCM Markets MT5 Terminal), "
             "loggato sul demo 50503392. Lo script lo apre e lo chiude da solo, una volta per passata (backtest, AllowLiveTrading=false, EA in modalita SOLO CONTA: nessun ordine). "
             "NON TOCCATI, per nome, PRIMA SU QUESTO PC (censimento P0 del 05/10): C:\\MT5_Backtest (cartella dati 04C7A32B, conto non censito) e C:\\FundedNext_Manuale (cartella dati 2B8180C3, conto non censito), che devono restare CHIUSI; "
             "POI il VPS VMI3047753 e TUTTE le sue cartelle dati -- FTMO trial 1514806751 (C:\\FTMO, ex challenge 541452707: le sedie e il Guardian), REALE 10105439 (C:\\BCM_Reale), 100k 50504263 (BCM Markets MT5 Terminal -V3), "
             "piccolo 50503392 sul VPS (BCM Markets MT5 Terminal), manuale 50503635 (C:\\MT5_MANUALE), banco 50504400 (C:\\MT5_Backtest), Pepperstone, Tickmill. "
             "NON tocca CODA.txt, il runner notturno, preset, sedie, conti, taglie. "
             "Scrive SOLO: la cartella abtg_passata nel profilo utente, MQL5\\Experts e MQL5\\Include del terminale BCM di questa macchina, il Desktop (cartella e zip NATCLA_F0_" + LOTTO + "); "
             "i file natcla_setup_* in Common\\Files li scrive l EA nel tester e lo script li COPIA senza cancellarli. NON lanciarla se una riga di round o un altro giro NATCLA_F0 sta GIA girando su questo PC (classe 853).")
if LOTTO == "PILOTA":
    cosa = ("NATCLA F0 LOTTO PILOTA (commit " + C[:8] + ") -- PRIMA compilazione vera di EA_NatCla (mql5/Experts/EA_NatCla.mq5 v" + VER + ", MetaEditor non lo ha mai compilato) e primo giro nel tester: "
            "4 simboli (" + ", ".join(simboli) + ") x 2 configurazioni (AUDIO H1 e EMA200 H1) = 8 passate singole, Modello 1 (OHLC su M1), InpSoloConta=true, nessun ordine, finestra per classe fino al 2026.06.30. "
            "Misura il TEMPO per passata e verifica che l EA parta e stampi la riga di avvio giusta (versione " + VER + ", modalita, 1 u per classe, iADX MetaQuotes, magic 778601 e 778621) e la riga VERIFICA ADX. "
            "Nessun PF, nessun DD: la lettura dei setup e leggi_natcla_f0.py sullo zip, i criteri sono scritti nel file prova PRIMA dei numeri.")
    tempo = ("TEMPO ATTESO [STIMA NON AGGANCIATA a un giro a passata singola OHLC di questo EA, lo misura proprio questo lotto]: compilazione circa 1 minuto + 8 passate x 30-120 secondi = 6-18 minuti in tutto. "
             "Il tetto del lotto e " + str(tetto) + " minuti (ferma l AVVIO di una passata, non la sua fine; ogni passata ha un timeout di 20 minuti e se lo supera lo script chiude il terminale da solo con CloseMainWindow). "
             "NON fermarla prima di 65 minuti (caso peggiore: compilazione 2 + tetto 40 + ultima passata fino a 20 + chiusura 2; lo zip si scrive solo alla FINE). Prerequisito: NESSUN MT5 o MetaEditor aperto su questo PC e NESSUNA sedia attaccata ai grafici salvati del terminale BCM (lo script si ferma e lo dice).")
    guarda = ("COSE DA GUARDARE PER PRIME quando torna, scritte PRIMA: (1) la riga di compilazione: 0 errori e quanti avvisi (se la compilazione FALLISCE lo script si ferma con rc 1 PRIMA del tester e mette il log di MetaEditor nello zip NATCLA_F0_PILOTA_COMPILAZIONE_FALLITA.zip sul Desktop: si manda QUELLO); "
              "(2) ESITO F0 e MANIFEST: 8 passate OK, ognuna con AVVIO si, ADX MetaQuotes e finestra uguale a quella dichiarata; se una e KO il motivo e scritto e NESSUN numero di quella passata si legge; "
              "(3) VERIFICA ADX: deve dire formula MetaQuotes su tutte e 8, se dice Wilder o NESSUNA ci si ferma e si manda la finestra; "
              "(4) il numero che sostituisce la stima: la media di secondi per passata e la stima di F0 intera (216 passate) che lo script stampa alla fine. Lo script CONTA e non giudica.")
elif LOTTO == "C0":
    cosa = ("NATCLA F0 LOTTO C0 (commit " + C[:8] + ") -- VERIFICA DEL RIMEDIO di EA_NatCla v" + VER + " (il TOCCO degli handle in CaricaDati, dopo la diagnosi NATCLA_DIAG_U30 del 07/10: "
            "con la v1.04 sugli indici BCM l EMA200 non si calcolava mai e l EA non contava niente). Lo script RICOMPILA EA_NatCla v" + VER + " e gira " + str(len(simboli)) + " indici (" + ", ".join(simboli) + ") x " +
            str(len(configs)) + " configurazioni (" + ", ".join(configs) + ") = " + str(nrun) + " passate singole, Modello 1 (OHLC su M1), InpSoloConta=true, nessun ordine, dal 2024.09.26 al 2026.06.30. "
            "Il lotto C (oro e indici) resta FERMO finche questo lotto non stampa VERIFICA DEL RIMEDIO SUPERATA. Da mandare quando finisce: lo zip NATCLA_F0_C0.zip dal Desktop di questo PC.")
    tempo = ("TEMPO ATTESO [MISURATO dal pilota e dai lotti B e D del 07/10: 23-68 secondi a passata, la maggior parte 28-40; la diagnosi sugli stessi due indici 28-30]: compilazione circa 1 minuto + " + str(nrun) + " passate x 23-68 secondi = " +
             ("%.0f" % (1 + bassa)) + "-" + ("%.0f" % (1 + alta)) + " minuti in tutto. Il tetto del lotto e " + str(tetto) + " minuti (ferma l AVVIO di una passata, non la sua fine; ogni passata ha un timeout di 20 minuti). "
             "NON fermarla prima di " + str(tetto + 25) + " minuti (caso peggiore: tetto " + str(tetto) + " + ultima passata fino a 20 + chiusura 2 + compilazione 2; lo zip si scrive solo alla FINE). Prerequisito: NESSUN MT5 o MetaEditor aperto su questo PC e NESSUNA sedia attaccata ai grafici salvati del terminale BCM (lo script si ferma e lo dice).")
    guarda = ("ATTESA SCRITTA PRIMA DEI NUMERI: (1) compilazione 0 errori (se FALLISCE lo script si ferma con rc 1 PRIMA del tester e lo zip da mandare e NATCLA_F0_C0_COMPILAZIONE_FALLITA.zip); "
              "(2) su TUTTE e " + str(nrun) + " le passate: AVVIO v" + VER + ", riga VERIFICA ADX con formula MetaQuotes (attesa datata 2024.10.16, la barra in cui la diagnosi era guarita) e righe CONTA > 0: allora lo script stampa VERIFICA DEL RIMEDIO SUPERATA e rc 0, e il lotto C si puo lanciare; "
              "(3) se ANCHE UNA passata non ha la VERIFICA ADX o ha zero righe CONTA: VERIFICA DEL RIMEDIO NON SUPERATA, rc 3, il rimedio NON basta e il lotto C resta FERMO (l ipotesi alternativa: il tester calcola gli indicatori solo per copie di piu elementi). Lo script CONTA e non giudica.")
else:
    cosa = ("NATCLA F0 LOTTO " + LOTTO + " (commit " + C[:8] + ") -- " + str(len(simboli)) + " simboli (" + ", ".join(simboli) + ") x " + str(len(configs)) + " configurazioni (" + ", ".join(configs) + ") = " + str(nrun) +
            " passate singole, Modello 1 (OHLC su M1), InpSoloConta=true, nessun ordine, finestra per classe fino al 2026.06.30. DA LANCIARE SOLO DOPO aver letto il lotto PILOTA (EA compilato e partito, VERIFICA ADX MetaQuotes, tempo misurato). " +
            ("UN GIRO ALLA VOLTA (un altro giro NATCLA_F0 gia in corso fa fermare questa con un messaggio rosso). " if LOTTO == "C" else
             "ORDINE CONSIGLIATO: A, poi B, poi D, UNA ALLA VOLTA (la seconda si lancia solo quando la prima ha scritto il suo zip: un altro giro gia in corso fa fermare questa con un messaggio rosso). ") +
            (("DA LANCIARE SOLO DOPO che il lotto C0 ha stampato VERIFICA DEL RIMEDIO v" + VER + " SUPERATA (rc 0, su U30USD e D30EUR): senza, gli indici restano a zero setup come nel pilota. ")
             if LOTTO == "C" else ("Il lotto C (oro e indici) resta FERMO finche il lotto C0 non ha verificato il rimedio v" + VER + ". ")) +
            "Da mandare quando finisce: lo zip NATCLA_F0_" + LOTTO + ".zip dal Desktop di questo PC. "
            "Nessun PF, nessun DD: la lettura dei setup e leggi_natcla_f0.py sullo zip, i criteri sono scritti nel file prova PRIMA dei numeri.")
    tempo = ("TEMPO ATTESO [MISURATO dal pilota e dai lotti B e D del 07/10, anche su H4/H12/D1: 23-68 secondi a passata, la maggior parte 28-40]: compilazione circa 1 minuto + " + str(nrun) + " passate x 23-68 secondi = " + ("%.0f" % bassa) + "-" + ("%.0f" % alta) + " minuti. "
             "Puo durare DI PIU se il terminale deve scaricare lo storico M1 di un simbolo mai usato su questo PC (gli indici diversi da U30USD e D30EUR non sono mai girati qui): per questo il tetto resta largo. "
             "Il tetto del lotto e " + str(tetto) + " minuti (ferma l AVVIO di una passata, non la sua fine; ogni passata ha un timeout di 20 minuti): le passate non lanciate escono NON_LANCIATA nel MANIFEST. "
             "NON fermarla prima di " + str(tetto + 25) + " minuti (caso peggiore: tetto " + str(tetto) + " + ultima passata fino a 20 + chiusura 2 + compilazione 2; lo zip si scrive solo alla FINE). Prerequisito: NESSUN MT5 o MetaEditor aperto su questo PC e NESSUNA sedia attaccata ai grafici salvati del terminale BCM (lo script si ferma e lo dice).")
    guarda = ("COSE DA GUARDARE PER PRIME quando torna, scritte PRIMA: (1) ESITO F0 e MANIFEST: quante passate OK, KO, NON_LANCIATE (con il motivo); (2) VERIFICA ADX: formula MetaQuotes su tutte le passate OK, se Wilder o NESSUNA ci si ferma; "
              "(3) la media di secondi per passata contro la stima" + ("; (4) sugli INDICI la riga VERIFICA ADX su ogni passata (su H12 e D1 cade TARDI: servono 300 barre del TF, riscaldamento dichiarato nel file prova) e righe CONTA > 0 sulle passate H1 come in C0, e XAUUSD con righe CONTA IDENTICHE al PILOTA girato con la v1.04 (riga DETERMINISMO del lettore: misura che la v" + VER + " non cambia niente dove la v1.04 funzionava)" if LOTTO == "C" else "") +
              ". Lo script CONTA e non giudica: la tabella la fa leggi_natcla_f0.py.")
fine = ("FILE ATTESI NELLO ZIP sul Desktop (NATCLA_F0_" + LOTTO + ".zip): RIEPILOGO_F0.txt + MANIFEST_F0.csv + il file prova + compile_natcla.log + csv\\natcla_setup_<simbolo>_<magic>.csv x " + str(nrun) +
        " + log\\EA_<simbolo>_<config>.txt x " + str(nrun) + " + ini\\f0_<simbolo>_<config>.ini x " + str(nrun) + "; rc 0 = tutte OK, rc 3 = almeno una KO o non lanciata (lo zip esce lo stesso), rc 1 = si e fermato prima del tester (se e la COMPILAZIONE, lo zip da mandare e NATCLA_F0_" + LOTTO + "_COMPILAZIONE_FALLITA.zip)")
avviso_mt5 = ("QUI CI SONO TRE MT5 (C:\\Program Files\\BCM Markets MT5 Terminal = demo 50503392, C:\\MT5_Backtest, C:\\FundedNext_Manuale): devono essere TUTTI CHIUSI, MetaEditor compreso. NON serve aprirne nessuno: lo script controlla da solo "
              "i grafici salvati del terminale BCM e si ferma se trova una SEDIA attaccata (il 14/08/2026 da questa macchina sono partiti ordini VERI, #3160534/#3160535, -104,60). "
              "Se uno e aperto, qui sotto compare il suo PID, titolo e cartella: chiudi QUELLO, a mano, e rilancia.")
for s in (bersaglio, cosa, tempo, guarda, fine, avviso_mt5):
    assert "'" not in s, s
    s.encode("ascii")

t = ("& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $PIN='" + C + "'; $T0=Get-Date; "
     "Write-Host '" + bersaglio + "' -ForegroundColor Yellow; "
     "if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia: la challenge FTMO sta operando (firma del 21/09/2026: i round girano sul PC di backtest).') }; "
     "Write-Host '" + avviso_mt5 + "' -ForegroundColor Red; "
     "$mp=@(Get-Process -Name terminal64,metaeditor64 -ErrorAction SilentlyContinue); if($mp.Count -gt 0){ Write-Host 'MT5 / MetaEditor APERTI ORA su questo PC (PID, titolo, cartella):' -ForegroundColor Red; $mp | Select-Object Id, MainWindowTitle, Path | Format-Table -AutoSize | Out-String -Width 300 | Write-Host }; "
     "if((@(Get-Process -Name terminal64,metaeditor64 -ErrorAction SilentlyContinue)).Count -gt 0){ throw 'MT5 o MetaEditor risulta APERTO su questo PC. Ogni passata ne apre una copia sua con /config: col terminale gia aperto il tester non parte. Fai quello che dice la riga rossa qui sopra, poi rilancia.' }; "
     "$W=Join-Path $env:USERPROFILE 'abtg_passata'; New-Item -ItemType Directory -Force -Path $W | Out-Null; $S=Join-Path $W 'NATCLA_F0_PASSATE.ps1'; Remove-Item -LiteralPath $S -Force -ErrorAction SilentlyContinue; "
     "$u='https://raw.githubusercontent.com/claudiospadaro12/GITHUB/'+$PIN+'/" + FILE + "?cb='+[Guid]::NewGuid().ToString('N'); "
     "$wc=New-Object Net.WebClient; $b=$wc.DownloadData($u); $sha=New-Object Security.Cryptography.SHA256Managed; $h=[BitConverter]::ToString($sha.ComputeHash($b)).Replace('-',''); "
     "if($h -ne '" + H + "'){ Write-Host ('IMPRONTA DIVERSA (' + $h + '): copia vecchia o cache di GitHub. Mi fermo, non lancio niente.') -ForegroundColor Red; return }; "
     "$t=[Text.Encoding]::ASCII.GetString($b); "
     "if(-not ($t | Select-String -SimpleMatch -Quiet -Pattern '" + MARC + "')){ Write-Host 'Marcatore " + MARC + " ASSENTE nello script scaricato: mi fermo.' -ForegroundColor Red; return }; "
     "Set-Content -LiteralPath $S -Value $t -Encoding ASCII -NoNewline; "
     "$h2=(Get-FileHash -LiteralPath $S -Algorithm SHA256).Hash; if($h2 -ne '" + H + "'){ Write-Host ('Il file scritto sul disco ha un altra impronta (' + $h2 + '): mi fermo.') -ForegroundColor Red; return }; "
     "Write-Host ('pc  : ' + $env:COMPUTERNAME) -ForegroundColor Green; Write-Host ('pin : ' + $PIN) -ForegroundColor Green; Write-Host ('impronta script: ' + $h.Substring(0,8) + ' OK, marcatore OK') -ForegroundColor Green; Write-Host ('data: ' + $T0.ToString('yyyy-MM-dd HH:mm:ss')) -ForegroundColor Green; "
     "Write-Host '" + cosa + "' -ForegroundColor Cyan; "
     "Write-Host '" + tempo + "' -ForegroundColor Yellow; "
     "Write-Host '" + guarda + "' -ForegroundColor Yellow; "
     "$ErrorActionPreference='Continue'; & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $S -Pin $PIN -Lotto " + LOTTO + " -ShaEA " + SEA + " -ShaInc " + SINC + " -ShaProva " + SPROVA + " -TimeoutRunMin 20; $rc=$LASTEXITCODE; Write-Host ''; "
     "Write-Host ('F0 lotto " + LOTTO + " rc ' + $rc + '   (0 = tutte le passate OK; 3 = almeno una KO o non lanciata, lo zip esce lo stesso; 1 = si e fermato prima del tester, il messaggio rosso dice dove)') -ForegroundColor Cyan; "
     "Write-Host ('durata totale minuti: ' + [int](((Get-Date)-$T0).TotalMinutes)) -ForegroundColor Cyan; "
     "Write-Host '" + fine + "' -ForegroundColor Gray }")
t.encode("ascii")
assert "\n" not in t and "\r" not in t
dest = os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_LANCIA_NATCLA_F0_%s.txt" % LOTTO)
if "--dest" in sys.argv:
    dest = sys.argv[sys.argv.index("--dest") + 1]
open(dest, "w", newline="").write(t)
print(len(t), "byte; SHA256 dello script", H, "; SHA EA", SEA[:12], "inc", SINC[:12], "prova", SPROVA[:12], "; SHA256 della riga", hashlib.sha256(t.encode("ascii")).hexdigest().upper())
