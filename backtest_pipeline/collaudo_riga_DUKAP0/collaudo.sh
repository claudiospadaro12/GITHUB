#!/bin/bash
# collaudo.sh -- tutto il collaudo di RIGA_DUKA_P0_CENSIMENTO.ps1 + bootstrap, in ordine. Esce diverso da 0 al primo che fallisce.
# Uso: bash backtest_pipeline/collaudo_riga_DUKAP0/collaudo.sh [COMMIT_DELLA_RIGA]   (il commit serve solo per il banco del bootstrap)
set -e
QD="$(cd "$(dirname "$0")" && pwd)"; REPO="$(cd "$QD/../.." && pwd)"; export HARNESS_TMP=${HARNESS_TMP:-$(mktemp -d)}
python3 $QD/statico.py --autotest
python3 $QD/statico.py
python3 $REPO/backtest_pipeline/controlla_riga.py --oggetto ps1 $REPO/backtest_pipeline/righe/RIGA_DUKA_P0_CENSIMENTO.ps1 | grep -E "ESITO|OK   compila|BLOCCANTI|^  X"
python3 $QD/battery.py | tail -3
python3 $QD/mutazioni.py | tail -3
if [ -n "$1" ]; then python3 $QD/bootstrap_test.py $1 | tail -3; fi
