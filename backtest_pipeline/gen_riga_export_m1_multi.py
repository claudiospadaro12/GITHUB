#!/usr/bin/env python3
# -*- coding: ascii -*-
"""Genera RIGA_LANCIA_EXPORT_M1_MULTI.txt: la riga unica che, sul PC di backtest
DESKTOP-H4D7CAJ, esporta le barre M1 di PIU simboli (forex e indici) su piu finestre.

Uso:  python3 backtest_pipeline/gen_riga_export_m1_multi.py <PIN40>

<PIN40> = commit (40 esadecimali minuscoli) che CONTIENE gia' questi due file:
    mql5/Scripts/ABTG_ExportM1_Multi.mq5
    backtest_pipeline/righe/RIGA_EXPORT_M1_MULTI.ps1
Gli SHA256 sono CALCOLATI qui da `git show <PIN>:<file>` (byte del commit):
mai ricopiati a mano. Se il pin non contiene i file, o non contiene il
marcatore, il generatore si ferma e non scrive niente.

Simboli e finestre della testa informativa (e il calcolo dello spazio su disco)
vengono LETTI dai default dello script .mq5 al pin: la riga non puo' descrivere
una lista diversa da quella che lo script esporta davvero.

Dopo la generazione: python3 backtest_pipeline/controlla_riga.py --oggetto riga
backtest_pipeline/righe/RIGA_LANCIA_EXPORT_M1_MULTI.txt
"""
import hashlib, os, re, subprocess, sys

MQ5_PATH = 'mql5/Scripts/ABTG_ExportM1_Multi.mq5'
PS1_PATH = 'backtest_pipeline/righe/RIGA_EXPORT_M1_MULTI.ps1'
OUT_NAME = 'RIGA_LANCIA_EXPORT_M1_MULTI.txt'
MARCATORE = 'MARCATORE_EXPORT_M1_MULTI_v1'
PS1_LOCALE = 'RIGA_EXPORT_M1_MULTI.ps1'
TIMEOUT_MIN = 180   # deve coincidere con $TIMEOUT_MIN del .ps1 (controllato sotto)

# stime di spazio (NON misurate sui simboli nuovi): dal CSV dell oro, circa
# 350.000 barre = 20-25 MB per anno. Qui si usano 20 MB per anno pieno.
MB_ANNO = 20
GIORNI_ANNO = 365


def muori(msg):
    sys.stderr.write('ERRORE: ' + msg + '\n')
    sys.exit(1)


if len(sys.argv) != 2 or not re.fullmatch(r'[0-9a-f]{40}', sys.argv[1]):
    muori('uso: gen_riga_export_m1_multi.py <PIN40>  (40 esadecimali minuscoli, un COMMIT)')
PIN = sys.argv[1]

QUI = os.path.dirname(os.path.abspath(__file__))
RADICE = subprocess.check_output(['git', '-C', QUI, 'rev-parse', '--show-toplevel'], text=True).strip()


def blob(percorso):
    """Byte del file nel commit PIN. Si ferma se il commit o il file non esistono."""
    r = subprocess.run(['git', '-C', RADICE, 'show', PIN + ':' + percorso], capture_output=True)
    if r.returncode != 0:
        muori('il pin ' + PIN[:8] + ' non contiene ' + percorso + ' (git: ' + r.stderr.decode('ascii', 'replace').strip()
              + '). Fai prima commit+push dei file e `git fetch`, poi rilancia col pin giusto.')
    return r.stdout


b_mq5 = blob(MQ5_PATH)
b_ps1 = blob(PS1_PATH)
for nome, b in ((MQ5_PATH, b_mq5), (PS1_PATH, b_ps1)):
    try:
        b.decode('ascii')
    except UnicodeDecodeError:
        muori(nome + ' al pin non e ASCII puro')
if MARCATORE.encode() not in b_ps1:
    muori('il .ps1 al pin non contiene il marcatore ' + MARCATORE)
SHA_MQ5 = hashlib.sha256(b_mq5).hexdigest().upper()
SHA_PS1 = hashlib.sha256(b_ps1).hexdigest().upper()

# il timeout dichiarato nella testa deve essere quello del .ps1
m = re.search(rb'\$TIMEOUT_MIN\s*=\s*(\d+)', b_ps1)
if not m or int(m.group(1)) != TIMEOUT_MIN:
    muori('TIMEOUT_MIN del .ps1 (' + (m.group(1).decode() if m else '?') + ') diverso da quello del generatore (' + str(TIMEOUT_MIN) + ')')

# simboli e finestre: i default dello script al pin
txt_mq5 = b_mq5.decode('ascii')
ms = re.search(r'input\s+string\s+InpSimboli\s*=\s*"([^"]*)"', txt_mq5)
mf = re.search(r'input\s+string\s+InpFinestre\s*=\s*"([^"]*)"', txt_mq5)
if not ms or not mf:
    muori('non trovo i default di InpSimboli/InpFinestre nello script al pin')
VOCI = [v.strip() for v in ms.group(1).split(',') if v.strip()]
FINESTRE = []
for f in mf.group(1).split(','):
    da, a = [x.strip() for x in f.strip().split('-')]
    FINESTRE.append((da, a))


def giorni(da, a):
    import datetime
    d0 = datetime.date(*[int(x) for x in da.split('.')])
    d1 = datetime.date(*[int(x) for x in a.split('.')])
    return (d1 - d0).days


# spazio per finestra (stima lineare sui giorni) e per simbolo
mb_fin = []
for da, a in FINESTRE:
    mb_fin.append(int(round(MB_ANNO * giorni(da, a) / float(GIORNI_ANNO))))
mb_simbolo = sum(mb_fin)
n_sim = len(VOCI)
n_file = n_sim * len(FINESTRE)
mb_tot = mb_simbolo * n_sim
zip_lo = int(mb_tot * 0.18)
zip_hi = int(mb_tot * 0.30)


def etichetta_fin(da, a):
    if giorni(da, a) <= 400:
        return da[:4]
    return da.replace('.', '-') + ' .. ' + a.replace('.', '-') + ' esclusa (circa ' + str(int(round(giorni(da, a) / 30.4))) + ' mesi)'


voci_txt = []
for v in VOCI:
    p = [x.strip() for x in v.split('|')]
    voci_txt.append(p[0] if len(p) == 1 else p[0] + ' (alias ' + ', '.join(p[1:]) + ')')
FIN_TXT = '; '.join(etichetta_fin(da, a) + ' circa ' + str(mb) + ' MB' for (da, a), mb in zip(FINESTRE, mb_fin))

# ---------------------------------------------------------------------------
# La riga. Regole: UNA riga, ASCII puro, nessun apostrofo dentro le stringhe a
# apici singoli di PowerShell, nessuna emoji.
# ---------------------------------------------------------------------------
TESTA = [
    ("EXPORT DELLE BARRE M1 DI PIU SIMBOLI (ABTG_ExportM1_Multi, SOLA LETTURA: nessun ordine). COSA FA: sul PC di backtest esporta le barre a 1 minuto, nello stesso formato dei CSV dell oro (time;open;high;low;close;tickvol;spread, ora del SERVER BCM), di "
     + str(n_sim) + " voci: " + ', '.join(voci_txt) + ". Le finestre sono " + str(len(FINESTRE)) + " (" + ', '.join(etichetta_fin(da, a) for da, a in FINESTRE)
     + "), in un solo lancio: fino a " + str(n_file) + " file CSV. Per ogni voce con alias usa il PRIMO nome che il broker offre. Prima di esportare scrive anche ABTG_SIMBOLI_BCM.txt con TUTTI i simboli che il broker offre e la mappatura voce -> simbolo scelto (o NON TROVATO), cosi se un nome e sbagliato lo correggo io senza rifare niente a mano. A fine corsa raccoglie tutto in UNO zip sul Desktop."),
    ("COSA NON FA: nessun ordine (lo script non ha funzioni di trading); non uccide nessun processo; non cancella nessun file; non cambia EA, input, sedie, .set o grafici esistenti. NON TOCCATI: VPS, FTMO, REALE 10105439, 100k, piccolo sul VPS, manuale, banco, Pepperstone, Tickmill. Effetti collaterali dichiarati: il terminale, uscendo, salva nel profilo attivo un grafico XAUUSD M1; i simboli esportati entrano nel Market Watch."),
    ("PRIMA DI CONFERMARE: MT5 deve essere CHIUSO. La riga si ferma da sola se MT5 e aperto o se nel profilo attivo c e anche UN SOLO EA attaccato ai grafici (non li tocca: li vede e si ferma). Il terminale e loggato sul DEMO 50503392 (C:\\Program Files\\BCM Markets MT5 Terminal). Senza la tua conferma fa solo una PROVA e non scrive niente nel terminale."),
    ("TEMPO: NON MISURATO, e una stima. Riferimento: l export dell oro (21 mesi + 2013) e durato circa 12 secondi di esecuzione con le barre gia nel terminale. Qui i file sono fino a " + str(n_file)
     + ": se il terminale deve scaricare dal server le barre vecchie stima da 10 a 60 minuti, ma puo essere di piu; una settimana senza barre costa circa 2 secondi di ritentativi; il limite della riga e " + str(TIMEOUT_MIN)
     + " minuti. Durante la corsa stampa l avanzamento ogni minuto. Non toccare il terminale mentre lavora."),
    ("SPAZIO SU DISCO (stima dal CSV dell oro, circa 20 MB per anno, NON misurata su questi simboli): per ogni simbolo " + FIN_TXT + "; totale circa " + str(mb_simbolo) + " MB per simbolo e circa " + str(mb_tot) + " MB per " + str(n_sim)
     + " simboli, scritti in Common\\Files del terminale; lo zip sul Desktop circa " + str(zip_lo) + "-" + str(zip_hi) + " MB. Servono almeno 2 GB liberi sul disco. Se BCM non ha le barre M1 di un anno per un simbolo, il file viene vuoto e il riepilogo lo dice."),
    ("Lo script .mq5 non e mai stato compilato da un agente: la riga lo compila con MetaEditor e se non compila SI FERMA prima di eseguire. Questa riga NON e stata collaudata da agenti sul PC di backtest: ha passato SOLO il cancello meccanico controlla_riga.py (niente PowerShell installato dove e stata scritta, quindi sintassi non provata con un parser)."),
]

STATEMENTS = []
add = STATEMENTS.append
add("if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('VIETATO: questa riga si incolla SOLO nella finestra PowerShell del PC di backtest DESKTOP-H4D7CAJ. Macchina attuale: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia.') }")
add("$ErrorActionPreference='Stop'")
add("[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12")
add("$INV=[Globalization.CultureInfo]::InvariantCulture")
for i, riga in enumerate(TESTA):
    add("Write-Host '" + riga + "' -ForegroundColor Yellow")
add("$PIN='" + PIN + "'")
add("$T0=Get-Date")
add("$TSR=$T0.ToString('yyyyMMdd_HHmmss',$INV)")
add("$DSK=Join-Path ([Environment]::GetFolderPath('Desktop')) 'ABTG_RISULTATI'")
add("New-Item -ItemType Directory -Force -Path $DSK | Out-Null")
add("$W=Join-Path $env:USERPROFILE 'abtg_sonde'")
add("New-Item -ItemType Directory -Force -Path $W | Out-Null")
add("$S=Join-Path $W '" + PS1_LOCALE + "'")
add("Remove-Item -LiteralPath $S -Force -ErrorAction SilentlyContinue")
add("irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PIN + '/" + PS1_PATH + "?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $S")
add("if(-not (Select-String -LiteralPath $S -SimpleMatch -Pattern '" + MARCATORE + "' -Quiet)){ throw 'Script scaricato SENZA il marcatore v1: copia vecchia o cache. Non si parte.' }")
add("$H=(Get-FileHash -LiteralPath $S -Algorithm SHA256).Hash")
add("Write-Host ('SHA256 script: ' + $H)")
add("if($H -ne '" + SHA_PS1 + "'){ throw 'SHA256 del script DIVERSO dall atteso: non si parte.' }")
add("$ErrorActionPreference='Continue'")
add("$C1=Join-Path $W ('console_multi_prova_' + $TSR + '.txt')")
add("$C2=Join-Path $W ('console_multi_esegui_' + $TSR + '.txt')")
add("Write-Host '=== PASSO 1: PROVA (niente scritto nel terminale) ===' -ForegroundColor Cyan")
add("& powershell -NoProfile -ExecutionPolicy Bypass -File $S -Pin $PIN -ShaMq5 '" + SHA_MQ5 + "' 2>&1 | Tee-Object -FilePath $C1")
add("$RC1=$LASTEXITCODE")
add("Write-Host ('codice di uscita della prova, INFORMATIVO (classe 154): ' + $RC1)")
add("$ST1=''")
add("$L1=@(Select-String -LiteralPath $C1 -Pattern '^STATO: ' -ErrorAction SilentlyContinue | Select-Object -Last 1)")
add("if($L1.Count -gt 0){ $ST1=[string]$L1[0].Line }")
add("Write-Host ('stato della prova, letto dal file: ' + $ST1) -ForegroundColor Cyan")
ESEGUI = [
    "Write-Host '=== PASSO 2: ESECUZIONE (-Esegui) ===' -ForegroundColor Cyan",
    "& powershell -NoProfile -ExecutionPolicy Bypass -File $S -Pin $PIN -ShaMq5 '" + SHA_MQ5 + "' -Esegui 2>&1 | Tee-Object -FilePath $C2",
    "$RC2=$LASTEXITCODE",
    "Write-Host ('codice di uscita, INFORMATIVO (classe 154): ' + $RC2)",
    "$L2=@(Select-String -LiteralPath $C2 -Pattern '^STATO: ' -ErrorAction SilentlyContinue | Select-Object -Last 1)",
    "if($L2.Count -gt 0){ Write-Host ('stato dell esecuzione, letto dal file: ' + [string]$L2[0].Line) -ForegroundColor Cyan }",
]
PROVA_OK = ("Write-Host 'La prova e passata: terminale certificato, nessuna sedia nel profilo attivo, script verificato. Se vai avanti il terminale si APRE da solo, gira lo script e si chiude da solo. TEMPO NON MISURATO (stima da 10 a 60 minuti, limite "
            + str(TIMEOUT_MIN) + " minuti, vedi sopra). Non toccare il terminale mentre lavora.' -ForegroundColor Yellow")
add("if($ST1 -ceq 'STATO: PROVA_OK'){ " + PROVA_OK
    + "; $R1=Read-Host 'Scrivi EXPORT (maiuscolo) per eseguire; qualunque altra cosa = mi fermo senza scrivere niente'; "
    + "if($R1 -ceq 'EXPORT'){ " + "; ".join(ESEGUI) + " } else { Write-Host 'FERMATO su tua scelta: nel terminale non e stato scritto niente.' -ForegroundColor Yellow } "
    + "} else { Write-Host 'La prova NON ha dato PROVA_OK (MT5 aperto, sedie nel profilo, bersaglio non certificato o script non verificato): NIENTE e stato scritto. Mandami la console qui sotto.' -ForegroundColor Red }")
# raccolta finale: la console in uno zip PICCOLO a parte (lo zip grande lo fa gia lo script, non lo si ricomprime)
add("$D=Join-Path $DSK ('EXPORT_M1_MULTI_CONSOLE_' + $TSR)")
add("New-Item -ItemType Directory -Force -Path $D | Out-Null")
add("foreach($c in @($C1,$C2)){ if(Test-Path -LiteralPath $c){ Copy-Item -LiteralPath $c -Destination $D -Force } }")
add("$ZC=Join-Path $DSK ('EXPORT_M1_MULTI_CONSOLE_' + $TSR + '.zip')")
add("Compress-Archive -Path (Join-Path $D '*') -DestinationPath $ZC -Force")
add("$ZS=@(Get-ChildItem -LiteralPath $DSK -Filter 'EXPORT_M1_MULTI_2*.zip' -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $T0 })")
add("if($ZS.Count -gt 0){ $Z=$ZS[$ZS.Count-1].FullName; Write-Host ('RACCOLTA: ' + $Z) -ForegroundColor Green; "
    "Write-Host '#########################################################' -ForegroundColor Black -BackgroundColor Yellow; "
    "Write-Host '###   >>>   QUESTO E LO ZIP DA MANDARE A CLAUDE   <<<   ###' -ForegroundColor Black -BackgroundColor Yellow; "
    "Write-Host ('###   ' + (Split-Path -Leaf $Z) + '   byte=' + (Get-Item -LiteralPath $Z).Length.ToString($INV)) -ForegroundColor Black -BackgroundColor Yellow; "
    "Write-Host '#########################################################' -ForegroundColor Black -BackgroundColor Yellow; "
    "try { Start-Process -FilePath 'explorer.exe' -ArgumentList ('/select,\"' + $Z + '\"') } catch { } "
    "} else { Write-Host 'Nessuno zip dei risultati: la corsa non e partita o si e fermata. Manda lo zip della console:' -ForegroundColor Red; Write-Host ('   ' + $ZC) -ForegroundColor Red }")
add("Write-Host ('FINE. Mandami lo zip senza aprirlo. Lo zip della console (' + (Split-Path -Leaf $ZC) + ') serve SOLO se qualcosa non torna. Se il terminale e rimasto aperto, chiudilo a mano (File > Esci).') -ForegroundColor Yellow")

RIGA = "& { " + "; ".join(STATEMENTS) + " }"

try:
    RIGA.encode('ascii')
except UnicodeEncodeError as e:
    muori('la riga non e ASCII puro: ' + str(e))
if '\n' in RIGA or '\r' in RIGA:
    muori('la riga contiene un a-capo')

dest = os.path.join(QUI, 'righe', OUT_NAME)
os.makedirs(os.path.dirname(dest), exist_ok=True)
with open(dest, 'w', encoding='ascii', newline='') as f:
    f.write(RIGA)
print('scritta', dest, '(' + str(len(RIGA)) + ' caratteri)')
print('pin      ', PIN)
print('SHA256 ps1', SHA_PS1)
print('SHA256 mq5', SHA_MQ5)
print('voci', n_sim, 'finestre', len(FINESTRE), 'file al massimo', n_file, 'stima', mb_tot, 'MB')
