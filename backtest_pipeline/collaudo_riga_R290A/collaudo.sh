#!/bin/bash
# collaudo.sh -- tutto il collaudo di PASSATA_STOP_SUPREV_NAS.ps1 + file prova R290a + riga RIGA_LANCIA_R290A.txt, in ordine. Esce diverso da 0 al primo che fallisce.
# Uso: bash backtest_pipeline/collaudo_riga_R290A/collaudo.sh [COMMIT_DELLO_SCRIPT]   (il commit serve solo alla prova della riga: bootstrap_test.py)
# Richiede pwsh 7 e python3 su Linux. NON copre Windows PowerShell 5.1 ne' MT5 (vedi ESITO_COLLAUDO.txt).
set -e
QD="$(cd "$(dirname "$0")" && pwd)"; REPO="$(cd "$QD/../.." && pwd)"
python3 $REPO/backtest_pipeline/controlla_riga.py --oggetto ps1 $REPO/backtest_pipeline/righe/PASSATA_STOP_SUPREV_NAS.ps1 | grep -E "ESITO|BLOCCANTI|^  X"
python3 $REPO/backtest_pipeline/controlla_riga.py --oggetto prova $REPO/backtest_pipeline/prove/R290a_stop_SUPREV_NASUSD_LS_ancora970913.txt | grep -E "ESITO|BLOCCANTI|^  X"
python3 $REPO/backtest_pipeline/controlla_prova.py --ea $REPO/mql5/Experts/ABTG_SupertrendReversal.mq5 $REPO/backtest_pipeline/prove/R290a_stop_SUPREV_NASUSD_LS_ancora970913.txt | tail -2
python3 $QD/statico.py | tail -3
python3 $QD/report_veri.py | tail -2
python3 $QD/battery.py --jobs 6 --lenti | tail -5
python3 $QD/mutazioni.py --jobs 6 | tail -5
if [ -n "$1" ]; then python3 $QD/bootstrap_test.py $1 | tail -8; python3 $REPO/backtest_pipeline/controlla_riga.py --oggetto riga $REPO/backtest_pipeline/righe/RIGA_LANCIA_R290A.txt | grep -E "ESITO|BLOCCANTI|^  X|PASSATI"; fi
