#!/bin/bash
# collaudo.sh -- tutto il collaudo della riga EMAGEM, in ordine: rigenerazione byte per byte al pin, parser e controlli meccanici, giornali veri,
# batteria (stub del driver con la riprova, CSV VERI di R110 per a), mutazioni (il collaudo del collaudo). Esce diverso da 0 al primo che fallisce.
# Uso: bash backtest_pipeline/collaudo_riga_EMAGEM/collaudo.sh <PIN_40_hex>
set -e
QD="$(cd "$(dirname "$0")" && pwd)"; REPO="$(cd "$QD/../.." && pwd)"; PIN=$1
python3 $QD/assembla.py $PIN --verifica
python3 $REPO/backtest_pipeline/controlla_riga.py --oggetto riga --riga $REPO/backtest_pipeline/righe/RIGA_ROUND_EMAGEM.txt | grep -E "ESITO|OK   compila|BLOCCANTI|^  X"
python3 $REPO/backtest_pipeline/controlla_prova.py $REPO/backtest_pipeline/prove/EMAGEM_a_ancora_U30USD_H1_LS.txt $REPO/backtest_pipeline/prove/EMAGEM_b_D30EUR_LS_tf.txt $REPO/backtest_pipeline/prove/EMAGEM_c_NASUSD_LS_tf.txt | grep -E "ESITO|OK$"
python3 $QD/giornali_veri.py | tail -1
python3 $QD/riprove_veri.py | tail -1
python3 $QD/battery.py $PIN | tail -1
python3 $QD/mutazioni.py $PIN | tail -1
