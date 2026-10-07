#!/bin/bash
# collaudo.sh -- tutto il collaudo di NATCLA_F0 (passo 0 di Ea Nat&Cla): file prova, driver di passata singola, lettore, riga di lancio. Esce diverso da 0 al primo che fallisce.
# Ogni mutante gira su COPIE in cartelle temporanee FUORI dal repo (classe 1159). Uso: bash backtest_pipeline/collaudo_natcla_f0/collaudo.sh <PIN_40_hex> [--rapido]
set -e
QD="$(cd "$(dirname "$0")" && pwd)"; REPO="$(cd "$QD/../.." && pwd)"; PIN=$1; RAPIDO=$2
python3 -I $QD/prova_pins.py
python3 $REPO/backtest_pipeline/controlla_prova.py --ea $REPO/mql5/Experts/EA_NatCla.mq5 $REPO/backtest_pipeline/prove/NATCLA_F0_conteggio_2026-10-07.txt | grep -E "ESITO|OK$"
python3 $REPO/backtest_pipeline/controlla_riga.py --oggetto prova $REPO/backtest_pipeline/prove/NATCLA_F0_conteggio_2026-10-07.txt | grep -E "ESITO"
python3 $REPO/backtest_pipeline/controlla_riga.py --oggetto ps1 $REPO/backtest_pipeline/righe/NATCLA_F0_PASSATE.ps1 | grep -E "ESITO|OK   compila|BLOCCANTI|^  X"
python3 $REPO/backtest_pipeline/controlla_riga.py --oggetto riga --riga $REPO/backtest_pipeline/righe/RIGA_LANCIA_NATCLA_F0_PILOTA.txt | grep -E "ESITO|OK   compila|BLOCCANTI|^  X"
python3 -I $REPO/backtest_pipeline/leggi_natcla_f0.py --autotest | tail -1
python3 -I $QD/mutazioni_reader.py | tail -1
python3 -I $QD/battery.py $RAPIDO | tail -1
python3 -I $QD/bootstrap_test.py $PIN | tail -1
