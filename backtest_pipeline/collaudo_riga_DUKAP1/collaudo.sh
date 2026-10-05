#!/bin/bash
# collaudo.sh -- tutto il collaudo di P1, in ordine. Esce diverso da 0 al primo che fallisce.
# Uso: bash backtest_pipeline/collaudo_riga_DUKAP1/collaudo.sh [COMMIT_DEL_DRIVER]   (il commit serve solo al banco del bootstrap)
set -e
QD="$(cd "$(dirname "$0")" && pwd)"; REPO="$(cd "$QD/../.." && pwd)"; export HARNESS_TMP=${HARNESS_TMP:-$(mktemp -d)}
python3 $REPO/backtest_pipeline/dukascopy/dukascopy_tick.py --autotest | tail -2
python3 $REPO/backtest_pipeline/dukascopy/leggi_f2_dk.py --autotest | tail -1
python3 $QD/mutazioni_py.py | tail -2
python3 $QD/mql5_sanity.py --autotest | tail -1
python3 $QD/mql5_sanity.py | tail -1
for f in RIGA_DUKA_P1_OROLOGIO.ps1 RIGA_DUKA_IMPORT_SONDA.ps1; do python3 $REPO/backtest_pipeline/controlla_riga.py --oggetto ps1 $REPO/backtest_pipeline/righe/$f | grep -E "ESITO|OK   compila|BLOCCANTI|^  X"; done
python3 $QD/battery_figlia.py | tail -3
python3 $QD/battery.py | tail -3
python3 $QD/mutazioni_ps1.py | tail -3
if [ -n "$1" ]; then python3 $QD/bootstrap_test.py $1 | tail -4; fi
