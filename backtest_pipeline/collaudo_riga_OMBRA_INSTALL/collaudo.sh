#!/bin/bash
# collaudo.sh -- tutto il collaudo di RIGA_OMBRA_INSTALL.ps1, in ordine. Esce diverso da 0 al primo che fallisce.
# Uso: bash backtest_pipeline/collaudo_riga_OMBRA_INSTALL/collaudo.sh [COMMIT_DELLA_RIGA]   (il commit serve al banco del bootstrap e al confronto col file committato)
set -e
QD="$(cd "$(dirname "$0")" && pwd)"; REPO="$(cd "$QD/../.." && pwd)"; export HARNESS_TMP=${HARNESS_TMP:-$(mktemp -d)}
cd $QD
python3 statico.py --autotest | tail -1
python3 statico.py | tail -1
python3 $REPO/backtest_pipeline/controlla_riga.py --ps1 $REPO/backtest_pipeline/righe/RIGA_OMBRA_INSTALL.ps1 | grep -E "ESITO|OK   compila|BLOCCANTI|^  X"
python3 battery.py | tail -3
python3 mutazioni.py | tail -2
if [ -n "$1" ]; then
  python3 bootstrap_test.py $1 | tail -2
  python3 $REPO/backtest_pipeline/controlla_riga.py --oggetto riga $REPO/backtest_pipeline/righe/RIGA_LANCIA_OMBRA_INSTALL.txt | grep -E "ESITO|OK   compila|BLOCCANTI|^  X"
fi
