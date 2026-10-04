#!/bin/bash
# collaudo.sh -- tutto il collaudo della riga LATI (tre cancelli con la TOLLERANZA DI BANCO), in ordine: rigenerazione byte per byte al pin, parser e controlli meccanici (riga e file prova),
# lettore indipendente (autotest con mutanti), giornali veri (compresi DUE gambe OOS degeneri VERE del 27/09), file RIPROVE scritti dal driver VERO, batteria (stub del driver con la gamba OOS
# degenere, CSV VERI di R110 per A2), mutazioni (il collaudo del collaudo). Esce diverso da 0 al primo che fallisce.
# Uso: bash backtest_pipeline/collaudo_riga_LATI/collaudo.sh <PIN_40_hex>
set -e
QD="$(cd "$(dirname "$0")" && pwd)"; REPO="$(cd "$QD/../.." && pwd)"; PIN=$1
python3 $QD/assembla.py $PIN --verifica
python3 $REPO/backtest_pipeline/controlla_riga.py --oggetto riga --riga $REPO/backtest_pipeline/righe/RIGA_ROUND_LATI.txt | grep -E "ESITO|OK   compila|BLOCCANTI|^  X"
python3 $REPO/backtest_pipeline/controlla_prova.py $REPO/backtest_pipeline/prove/LATI_A1_EMA200_U30USD_DISCESA_long.txt $REPO/backtest_pipeline/prove/LATI_A1_EMA200_U30USD_DISCESA_short.txt $REPO/backtest_pipeline/prove/LATI_A2_EMA200_U30USD_TORO_long.txt $REPO/backtest_pipeline/prove/LATI_A2_EMA200_U30USD_TORO_short.txt | grep -E "ESITO|OK$"
python3 $REPO/backtest_pipeline/leggi_lati.py --autotest | tail -1
python3 $QD/giornali_veri.py | tail -1
python3 $QD/riprove_veri.py | tail -1
python3 $QD/battery.py $PIN | tail -1
python3 $QD/mutazioni.py $PIN | tail -1
