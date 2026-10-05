#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
bootstrap.py -- scrive backtest_pipeline/righe/RIGA_LANCIA_DUKA_P1.txt: il bootstrap CORTO (una riga fisica, ASCII) che Claudio incollera' DOPO i cancelli e DOPO la firma F2.
Scarica RIGA_DUKA_P1_OROLOGIO.ps1 dal commit che la contiene (git show, mai dal disco), controlla SHA256 e marcatore, la salva in %USERPROFILE%\abtg_duka_p1 e la lancia passando il pin e le
impronte SHA256 dei QUATTRO file che la riga usa (dukascopy_tick.py, leggi_f2_dk.py, RIGA_DUKA_IMPORT_SONDA.ps1, ABTG_ImportaTickEsterno.mq5), tutte lette con git show al commit: la riga le verifica una per una.
La guardia macchina sta QUI (prima di qualunque download) e dentro la riga. Il commit DEVE essere raggiungibile da origin/lavoro.
Uso: python3 backtest_pipeline/collaudo_riga_DUKAP1/bootstrap.py <COMMIT_40_hex> [--dest FILE]
"""
import hashlib, os, re, subprocess, sys
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
RAW = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/"
FILE_DRV = "backtest_pipeline/righe/RIGA_DUKA_P1_OROLOGIO.ps1"
FILE_PY = "backtest_pipeline/dukascopy/dukascopy_tick.py"
FILE_F2 = "backtest_pipeline/dukascopy/leggi_f2_dk.py"
FILE_IMP = "backtest_pipeline/righe/RIGA_DUKA_IMPORT_SONDA.ps1"
FILE_MQ5 = "mql5/Scripts/ABTG_ImportaTickEsterno.mq5"
MARC = "MARCATORE_RIGA_DUKA_P1_v1"


def git_show(commit, rel):
    return subprocess.run(["git", "show", "%s:%s" % (commit, rel)], cwd=REPO, capture_output=True, check=True).stdout


def sha(b):
    return hashlib.sha256(b).hexdigest().upper()


def genera(commit, shas=None, raw=RAW):
    """shas: dict(drv, py, f2, imp, mq5); se None si leggono con git show al commit."""
    if shas is None:
        shas = {k: sha(git_show(commit, f)) for k, f in (("drv", FILE_DRV), ("py", FILE_PY), ("f2", FILE_F2), ("imp", FILE_IMP), ("mq5", FILE_MQ5))}
    msg = ("BERSAGLIO: SOLO una finestra PowerShell sul PC di backtest DESKTOP-H4D7CAJ; la riga apre e chiude da sola il terminale C:\\Program Files\\BCM Markets MT5 Terminal (demo 50503392, "
           "LO STESSO numero del piccolo del VPS: due macchine, stesso conto) e SI FERMA se un grafico salvato ha un EA attaccato. Questa e la riga P1 del piano Dow Dukascopy (commit %s): "
           "NESSUN download di dati Dukascopy; riconverte dalla cache i CSV di dukascopy_lavoro con orologio UTC+1 fisso DOPO averne fatto una copia di sicurezza (tick_0309_backup), "
           "reimporta il custom U30USD_DK e ne crea uno nuovo U30USD_DKNEG nel terminale, e scrive sul Desktop le cartelle DUKA_P1_data e DUKA_IMPORT_SONDA_simbolo_data con i loro zip. "
           "PERIMETRO COMPLETO DI SCRITTURA: nel profilo utente dukascopy_lavoro (tick riscritti, tick_0309_backup, dukascopy_neg rifatta da capo) e abtg_duka_p1 (file al pin, log, risultati); "
           "nella cartella dati del SOLO terminale BCM Markets MT5 Terminal: MQL5\\Scripts\\ABTG_ImportaTickEsterno (riscaricato e ricompilato), MQL5\\Files (CSV U30USD_DK e referti della sonda; i CSV del negativo li toglie), "
           "MQL5\\Presets\\abtg_duka_import.set (parametri dello script di import, NON un preset di EA), bases (i due custom, U30USD_DKNEG resta e si toglie a mano; e lo storico tick nativo U30USD che il terminale puo scaricare da BCM per la sonda); "
           "in TEMP abtg_duka_import.ini (avvio con AllowLiveTrading=false). Chiude con la forza SOLO i terminal64 di C:\\Program Files\\BCM Markets MT5 Terminal, cioe quello che ha aperto lei. "
           "NON tocca EA, preset di EA, taglie, rischio, conti. NON TOCCATI, per nome, PRIMA SU QUESTO PC (censimento P0 del 05/10): C:\\MT5_Backtest (cartella dati 04C7A32B, conto non censito) e C:\\FundedNext_Manuale (cartella dati 2B8180C3, conto non censito): "
           "la riga cerca il terminale solo dentro C:\\Program Files e C:\\Program Files (x86) col nome BCM Markets MT5 Terminal, scrive solo nella cartella dati che ha quella origine e chiude solo i terminal64 con quel percorso. "
           "PER TUTTA LA CORSA (fino a ~8 ore e mezza) NON aprire nessun MT5 su questo PC, FundedNext_Manuale compreso: la riga li vuole tutti chiusi alla partenza e ciascuna delle due importazioni si ferma se ne trova uno aperto (ore perse, nessun danno). "
           "POI, altrove: il VPS VMI3047753 e tutte le sue cartelle dati -- FTMO trial 1514806751 (C:\\FTMO, ex challenge 541452707), "
           "REALE 10105439 (C:\\BCM_Reale), piccolo 50503392 sul VPS (BCM Markets MT5 Terminal), 100k 50504263 (BCM Markets MT5 Terminal -V3), manuale 50503635 (C:\\MT5_MANUALE), "
           "banco 50504400 (C:\\MT5_Backtest), Pepperstone, Tickmill. Esegue la riga solo se impronta e marcatore tornano; la riga verifica poi le impronte di tutti i file che usa. "
           "NON lanciarla se MT5 o una riga di round e aperta su questo PC (la riga si ferma da sola). DURATA NON MISURATA nel suo insieme: la riconversione dei 222 giorni ha preso ~12 minuti il 03/09, "
           "la importazione di ~20,75 milioni di tick non e mai stata cronometrata (la riga figlia aspetta al massimo 240 minuti per import): lascia il PC acceso finche la console stampa ESITO P1. "
           "Ciascuno dei due import si ferma da solo a 240 minuti (o dopo 25 minuti senza progressi), quindi la riga finisce da sola entro ~8 ore e mezza: se dopo 9 ore non vedi ESITO P1, fotografa la console e mandala, NON chiudere MT5 a mano. "
           "NON incollarla una seconda volta mentre la prima gira, anche se sembra ferma: la riconversione e la importazione possono stare a lungo senza stampare. "
           "Se la console mostra >>, Ctrl+C prima di incollare." % commit[:8])
    assert "'" not in msg
    t = ("& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Write-Host '" + msg + "' -ForegroundColor Yellow; "
         "if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia mai. Nessun download e stato fatto.') }; "
         "$u='" + raw + commit + "/" + FILE_DRV + "'; "
         "$wc=New-Object Net.WebClient; $b=$wc.DownloadData($u); $sha=New-Object Security.Cryptography.SHA256Managed; $h=[BitConverter]::ToString($sha.ComputeHash($b)).Replace('-',''); "
         "if($h -ne '" + shas["drv"] + "'){ Write-Host ('IMPRONTA DIVERSA ('+$h+'): mi fermo, non lancio niente.') -ForegroundColor Red; return }; "
         "Write-Host ('Riga P1 scaricata, impronta OK: '+$h.Substring(0,8)); $t=[Text.Encoding]::ASCII.GetString($b); "
         "if(-not ($t | Select-String -SimpleMatch -Quiet -Pattern '" + MARC + "')){ Write-Host 'Marcatore della riga P1 assente nella riga scaricata: mi fermo.' -ForegroundColor Red; return }; "
         "$d=Join-Path $env:USERPROFILE 'abtg_duka_p1'; New-Item -ItemType Directory -Force -Path $d | Out-Null; $p=Join-Path (Convert-Path -LiteralPath $d) 'RIGA_DUKA_P1_OROLOGIO.ps1'; Remove-Item -LiteralPath $p -Force -ErrorAction SilentlyContinue; "
         "[IO.File]::WriteAllBytes($p,$b); $global:LASTEXITCODE=0; "
         "& $p -Pin '" + commit + "' -ShaPy '" + shas["py"] + "' -ShaF2 '" + shas["f2"] + "' -ShaImp '" + shas["imp"] + "' -ShaMq5 '" + shas["mq5"] + "'; "
         "Write-Host ('codice d uscita della riga P1: '+$LASTEXITCODE) }")
    t.encode("ascii")
    assert "\n" not in t
    return t


if __name__ == "__main__":
    C = sys.argv[1]
    assert re.match(r"^[0-9a-f]{40}$", C)
    r = subprocess.run(["git", "merge-base", "--is-ancestor", C, "origin/lavoro"], cwd=REPO)
    assert r.returncode == 0, "il commit %s NON e' raggiungibile da origin/lavoro: prima push, poi bootstrap" % C[:8]
    assert git_show(C, FILE_DRV).count(MARC.encode()) == 1
    t = genera(C)
    dest = os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_LANCIA_DUKA_P1.txt")
    if "--dest" in sys.argv:
        dest = sys.argv[sys.argv.index("--dest") + 1]
    open(dest, "w", newline="").write(t)
    print(len(t), "byte; SHA256 del bootstrap", hashlib.sha256(t.encode("ascii")).hexdigest().upper())
