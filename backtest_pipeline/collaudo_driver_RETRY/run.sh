#!/bin/bash
# run.sh -- tutto il collaudo del driver con la riprova, nell'ordine in cui conviene leggerlo.
#   1. cancello deterministico (ASCII, parser PowerShell VERO, costrutti pwsh-7, cultura) sui due file nuovi;
#   2. la guardia per macchina: il blocco condiviso deve restare IDENTICO anche nelle due copie (5 file);
#   3. le funzioni della riprova contro i giornali VERI del tester (R92BAB 01/10, R92B e RFWD 30/09) e costruiti;
#   4. la batteria: driver VERO + terminale finto, e riga VERA + driver VERO + terminale finto (~2-3 minuti).
# Uso: bash backtest_pipeline/collaudo_driver_RETRY/run.sh      (esce 0 solo se tutto passa)
set -u
QD="$(cd "$(dirname "$0")" && pwd)"; REPO="$(cd "$QD/../.." && pwd)"
export HARNESS_OUT=${HARNESS_OUT:-/tmp/retry_harness}
rc=0
cd "$REPO"
for f in backtest_pipeline/walkforward_generico_RETRY.ps1 backtest_pipeline/righe/RIGA_ROUND_VPS_RETRY.ps1; do
  python3 backtest_pipeline/controlla_riga.py --ps1 "$f" > "$HARNESS_OUT.cr.txt" 2>&1; r=$?
  echo "controlla_riga $f -> rc $r ($(grep -c 'BLOCC\|!!' "$HARNESS_OUT.cr.txt") righe bloccanti; $(grep -o 'compila: 0 errori dal parser PowerShell vero' "$HARNESS_OUT.cr.txt"))"
  [ $r -eq 0 ] || rc=1
done
pwsh -NoProfile -Command '& ./backtest_pipeline/banco_guardia_macchina.ps1 -Files @("backtest_pipeline/righe/RIGA_ROUND_VPS.ps1","backtest_pipeline/walkforward_generico.ps1","backtest_pipeline/righe/RIGA_SCAN_GESTIONE.ps1","backtest_pipeline/walkforward_generico_RETRY.ps1","backtest_pipeline/righe/RIGA_ROUND_VPS_RETRY.ps1"); exit $LASTEXITCODE' > "$HARNESS_OUT.bg.txt" 2>&1; r=$?
echo "banco_guardia_macchina su 5 copie -> rc $r: $(grep -E 'IMPRONTE IDENTICHE|TUTTO PASSATO|FALLITO' "$HARNESS_OUT.bg.txt" | tr '\n' ' ')"
[ $r -eq 0 ] || rc=1
python3 "$QD/giornali_veri.py" | tail -1; [ ${PIPESTATUS[0]} -eq 0 ] || rc=1
python3 "$QD/battery.py" > "$HARNESS_OUT.battery.txt" 2>&1; r=$?
tail -3 "$HARNESS_OUT.battery.txt"; [ $r -eq 0 ] || rc=1
echo "COLLAUDO DRIVER RETRY: $([ $rc -eq 0 ] && echo TUTTO PASSATO || echo QUALCOSA E FALLITO) (dettagli in $HARNESS_OUT.*.txt)"
exit $rc
