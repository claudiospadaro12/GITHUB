#!/bin/bash
# collaudo.sh -- tutto il collaudo della riga DAXAP03, in ordine: rigenerazione byte per byte al pin, parser e controlli meccanici, giornali veri,
# batteria (stub del driver con la riprova), mutazioni (il collaudo del collaudo). Esce diverso da 0 al primo che fallisce.
# Uso: bash backtest_pipeline/collaudo_riga_DAXAP03/collaudo.sh <PIN_40_hex>
set -e
QD="$(cd "$(dirname "$0")" && pwd)"; REPO="$(cd "$QD/../.." && pwd)"; PIN=$1
python3 $QD/assembla.py $PIN --verifica
python3 $REPO/backtest_pipeline/controlla_riga.py --riga $REPO/backtest_pipeline/righe/RIGA_ROUND_DAXAP03.txt | grep -E "ESITO|OK   compila|BLOCCANTI|^  X"
python3 $REPO/backtest_pipeline/controlla_prova.py $REPO/backtest_pipeline/prove/PRV_DAXAP_03a_ingresso_meno1_piu1_770411_D30EUR.txt $REPO/backtest_pipeline/prove/PRV_DAXAP_03b_ritardo_5_15_770411_D30EUR.txt | grep -E "ESITO|OK$"
python3 $QD/giornali_veri.py | tail -1
python3 $QD/riprove_veri.py | tail -1
python3 $QD/battery.py $PIN | tail -1
python3 $QD/mutazioni.py $PIN | tail -1
