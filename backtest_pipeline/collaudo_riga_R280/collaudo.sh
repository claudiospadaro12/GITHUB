#!/bin/bash
# collaudo.sh -- tutto il collaudo della riga R280 (cancello G0 + G1 con la TOLLERANZA CONGELATA il 03/10), in ordine: rigenerazione byte per byte al pin, parser e controlli meccanici,
# autotest del lettore indipendente, giornali veri (R262 del 27/09), fixture RIPROVE vere, batteria (stub del driver con la riprova, riga VERA di R262b per R280e), mutazioni (il collaudo del
# collaudo). Esce diverso da 0 al primo che fallisce.
# Uso: bash backtest_pipeline/collaudo_riga_R280/collaudo.sh <PIN_40_hex>
set -e
QD="$(cd "$(dirname "$0")" && pwd)"; REPO="$(cd "$QD/../.." && pwd)"; PIN=$1
python3 $QD/assembla.py $PIN --verifica
python3 $REPO/backtest_pipeline/controlla_riga.py --oggetto riga --riga $REPO/backtest_pipeline/righe/RIGA_ROUND_R280.txt | grep -E "ESITO|OK   compila|BLOCCANTI|^  X"
python3 $REPO/backtest_pipeline/controlla_prova.py $REPO/backtest_pipeline/prove/R280a_filtrotf_h1_memoria_candidato_dow_U30USD.txt $REPO/backtest_pipeline/prove/R280e_ancora_g1_candidato_dow_U30USD.txt | grep -E "ESITO|OK$"
python3 $REPO/backtest_pipeline/leggi_r280.py --autotest | tail -1
python3 $QD/giornali_veri.py | tail -1
python3 $QD/riprove_veri.py | tail -1
python3 $QD/battery.py $PIN | tail -1
python3 $QD/mutazioni.py $PIN | tail -1
