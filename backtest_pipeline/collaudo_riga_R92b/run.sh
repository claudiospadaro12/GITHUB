#!/bin/bash
# uso: run.sh NOME scenario.json [modifica_sed] [charts=ok|ea|zero]
QD="$(cd "$(dirname "$0")" && pwd)"; REPO_ROOT="$(cd "$QD/../.." && pwd)"; OUT=${HARNESS_OUT:-/tmp/r92b_harness}; mkdir -p $OUT
N=$1; SCEN=$(readlink -f $2); MOD=$3; CH=${4:-ok}
H=$OUT/run_$N; rm -rf $H; mkdir -p $H/user/Desktop $H/appdata/MetaQuotes/Terminal/ABC123 $H/appdata/MetaQuotes/Terminal/Common
printf '\xff\xfe' > $H/appdata/MetaQuotes/Terminal/ABC123/origin.txt; printf 'C:\\Program Files\\BCM Markets MT5 Terminal' | iconv -f ascii -t utf-16le >> $H/appdata/MetaQuotes/Terminal/ABC123/origin.txt
# un altro terminale col suo origin (deve essere ignorato)
mkdir -p $H/appdata/MetaQuotes/Terminal/ZZZ999; printf 'C:\\MT5_MANUALE' > $H/appdata/MetaQuotes/Terminal/ZZZ999/origin.txt
CD="$H/appdata/MetaQuotes/Terminal/ABC123/MQL5/Profiles/Charts"
if [ "$CH" != "zero" ]; then mkdir -p "$CD/Default" "$CD/SQUADRA"; printf '\xff\xfe' > "$CD/Default/chart01.chr"; printf '<chart>\nsymbol=EURUSD\n</chart>\n' | iconv -f ascii -t utf-16le >> "$CD/Default/chart01.chr"; cp "$CD/Default/chart01.chr" "$CD/SQUADRA/chart02.chr"; fi
if [ "$CH" = "ea" ]; then printf '\xff\xfe' > "$CD/SQUADRA/chart03.chr"; printf '<chart>\nsymbol=GBPUSD\n<window>\n<expert>\nname=ABTG_Bulge\n</expert>\n</window>\n</chart>\n' | iconv -f ascii -t utf-16le >> "$CD/SQUADRA/chart03.chr"; fi
cp $REPO_ROOT/backtest_pipeline/righe/RIGA_ROUND_R92B.txt $H/riga.txt
if [ -n "$MOD" ]; then sed -i "$MOD" $H/riga.txt; fi
export COMPUTERNAME=DESKTOP-H4D7CAJ USERPROFILE=$H/user APPDATA=$H/appdata HOME=$H/user DESKTOP_DIR=$H/user/Desktop SCENARIO=$SCEN HARNESS_LOG=$H/stub.log STUB=$QD/stub_driver.py REPO_ROOT=$REPO_ROOT PATH=$OUT/bin:$PATH
mkdir -p $OUT/bin; printf '#!/bin/sh\nexec python3 "$STUB" "$@"\n' > $OUT/bin/powershell.exe; chmod +x $OUT/bin/powershell.exe
cd $H
pwsh -NoProfile -Command 'Remove-Item Alias:irm -ErrorAction SilentlyContinue; function irm { param([string]$Uri,[string]$OutFile) Copy-Item -LiteralPath "$env:REPO_ROOT/backtest_pipeline/righe/RIGA_ROUND_VPS.ps1" -Destination $OutFile -Force }; $t=Get-Content -Raw ./riga.txt; Invoke-Expression $t; "EXIT=" + $LASTEXITCODE' > $H/out.txt 2>&1
echo "--- $N: exit shell $?"; 
