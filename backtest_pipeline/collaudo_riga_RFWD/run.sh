#!/bin/bash
# uso: run.sh NOME scenario.json [modifica_sed] [charts=ok|ea|zero|rotto] [pin] [macchina] [python=si|no] [serve_mut=cft|drv|xlsx|]
QD="$(cd "$(dirname "$0")" && pwd)"; REPO_ROOT="$(cd "$QD/../.." && pwd)"; OUT=${HARNESS_OUT:-/tmp/rfwd_harness}; mkdir -p $OUT
N=$1; SCEN=$(readlink -f $2); MOD=$3; CH=${4:-ok}; PINV=${5:-$(git -C $REPO_ROOT rev-parse HEAD)}; PCN=${6:-DESKTOP-H4D7CAJ}; PY=${7:-si}; SMUT=${8:-}
H=$OUT/run_$N; rm -rf $H; mkdir -p $H/user/Desktop $H/appdata/MetaQuotes/Terminal/ABC123 $H/appdata/MetaQuotes/Terminal/Common $H/srv
printf '\xff\xfe' > $H/appdata/MetaQuotes/Terminal/ABC123/origin.txt; printf 'C:\\Program Files\\BCM Markets MT5 Terminal' | iconv -f ascii -t utf-16le >> $H/appdata/MetaQuotes/Terminal/ABC123/origin.txt
mkdir -p $H/appdata/MetaQuotes/Terminal/ZZZ999; printf 'C:\\MT5_MANUALE' > $H/appdata/MetaQuotes/Terminal/ZZZ999/origin.txt
CD="$H/appdata/MetaQuotes/Terminal/ABC123/MQL5/Profiles/Charts"
if [ "$CH" != "zero" ]; then mkdir -p "$CD/Default" "$CD/SQUADRA"; printf '\xff\xfe' > "$CD/Default/chart01.chr"; printf '<chart>\nsymbol=EURUSD\n</chart>\n' | iconv -f ascii -t utf-16le >> "$CD/Default/chart01.chr"; cp "$CD/Default/chart01.chr" "$CD/SQUADRA/chart02.chr"; fi
if [ "$CH" = "ea" ]; then printf '\xff\xfe' > "$CD/SQUADRA/chart03.chr"; printf '<chart>\nsymbol=GBPUSD\n<window>\n<expert>\nname=ABTG_Bulge\n</expert>\n</window>\n</chart>\n' | iconv -f ascii -t utf-16le >> "$CD/SQUADRA/chart03.chr"; fi
if [ "$CH" = "rotto" ]; then ln -s /nonexistent/x.chr "$CD/SQUADRA/chart09.chr"; fi
# i tre file che la riga scarica dal pin: prima le versioni AL PIN (git show), poi l'eventuale mutazione
git -C $REPO_ROOT show $PINV:backtest_pipeline/righe/RIGA_ROUND_VPS.ps1 > $H/srv/RIGA_ROUND_VPS.ps1
git -C $REPO_ROOT show $PINV:backtest_pipeline/confronto_forward_tester.py > $H/srv/confronto_forward_tester.py
git -C $REPO_ROOT show $PINV:data/statements/FTMO_541452707_cronistorico_2026-09-30.xlsx > $H/srv/FTMO_541452707_cronistorico_2026-09-30.xlsx
if [ "$SMUT" = "cft" ]; then printf '\n# mutato\n' >> $H/srv/confronto_forward_tester.py; fi
if [ "$SMUT" = "cftrot" ]; then sed -i 's/<= tol$/< tol/; s/abs(f\["t"\] - t\["t"\]) <= tol and/abs(f["t"] - t["t"]) < tol and/' $H/srv/confronto_forward_tester.py; fi
if [ "$SMUT" = "drv" ]; then printf '\n# mutato\n' >> $H/srv/RIGA_ROUND_VPS.ps1; fi
if [ "$SMUT" = "xlsx" ]; then printf 'x' >> $H/srv/FTMO_541452707_cronistorico_2026-09-30.xlsx; fi
cp $REPO_ROOT/backtest_pipeline/righe/RIGA_ROUND_RFWD.txt $H/riga.txt
if [ -n "$MOD" ]; then sed -i "$MOD" $H/riga.txt; fi
# pwsh 7.4: l'alias irm e' COSTANTE (non si puo' togliere): nel banco di prova la riga usa irmShim al posto di irm (unica differenza dal testo vero: il nome del comando)
sed -i 's/irm (/irmShim (/g' $H/riga.txt
mkdir -p $OUT/bin_$N; printf '#!/bin/sh\nexec python3 "$STUB" "$@"\n' > $OUT/bin_$N/powershell.exe; chmod +x $OUT/bin_$N/powershell.exe
if [ "$PY" = "si" ]; then printf '#!/bin/sh\nexec python3 "$@"\n' > $OUT/bin_$N/python.exe; chmod +x $OUT/bin_$N/python.exe; fi
export COMPUTERNAME=$PCN USERPROFILE=$H/user APPDATA=$H/appdata HOME=$H/user DESKTOP_DIR=$H/user/Desktop SCENARIO=$SCEN HARNESS_LOG=$H/stub.log STUB=$QD/stub_driver.py REPO_ROOT=$REPO_ROOT SRV=$H/srv PATH=$OUT/bin_$N:$PATH
cd $H
pwsh -NoProfile -Command 'function irmShim { param([string]$Uri,[string]$OutFile) $n=($Uri -split "[?]")[0]; $n=$n.Substring($n.LastIndexOf("/")+1); Copy-Item -LiteralPath (Join-Path $env:SRV $n) -Destination $OutFile -Force }; $t=Get-Content -Raw ./riga.txt; Invoke-Expression $t; "EXIT=" + $LASTEXITCODE' > $H/out.txt 2>&1
echo "--- $N: exit shell $?"
