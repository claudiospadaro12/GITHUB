#!/bin/bash
# uso: run.sh NOME scenario.json [modifica_sed] [charts=ok|ea|zero|rotto] [pin] [macchina] [serve_mut=drv|orig|] [term=ok|assente|link]
# Stessa forma di collaudo_riga_DAXAP03/run.sh (che e quella di DAXAP02). Il magazzino serve SOLO il file che la riga scarica: righe/RIGA_ROUND_VPS_RETRY.ps1 AL PIN
# (git show), con le mutazioni 'drv' (un byte in piu': SHA diverso) e 'orig' (l'ORIGINALE RIGA_ROUND_VPS.ps1 servito col nome della copia:
# classe 1028, il marcatore v2 c'e' ma il RETRY_v1 no). Disco C: finto con la cartella programma del solo terminale ammesso.
QD="$(cd "$(dirname "$0")" && pwd)"; REPO_ROOT="$(cd "$QD/../.." && pwd)"; OUT=${HARNESS_OUT:-/tmp/r280_harness}; mkdir -p $OUT
N=$1; SCEN=$(readlink -f $2); MOD=$3; CH=${4:-ok}; PINV=${5:-$(git -C $REPO_ROOT rev-parse HEAD)}; PCN=${6-DESKTOP-H4D7CAJ}; SMUT=${7:-}; TERM=${8:-ok}; RIGA=${RIGA_FILE:-$REPO_ROOT/backtest_pipeline/righe/RIGA_ROUND_R280.txt}
H=$OUT/run_$N; rm -rf $H; mkdir -p $H/user/Desktop $H/appdata/MetaQuotes/Terminal/ABC123 $H/appdata/MetaQuotes/Terminal/Common $H/srv $H/cdrive
printf '\xff\xfe' > $H/appdata/MetaQuotes/Terminal/ABC123/origin.txt; printf 'C:\\Program Files\\BCM Markets MT5 Terminal' | iconv -f ascii -t utf-16le >> $H/appdata/MetaQuotes/Terminal/ABC123/origin.txt
mkdir -p $H/appdata/MetaQuotes/Terminal/ZZZ999; printf 'C:\\MT5_MANUALE' > $H/appdata/MetaQuotes/Terminal/ZZZ999/origin.txt
CD="$H/appdata/MetaQuotes/Terminal/ABC123/MQL5/Profiles/Charts"
if [ "$CH" != "zero" ]; then mkdir -p "$CD/Default" "$CD/SQUADRA"; printf '\xff\xfe' > "$CD/Default/chart01.chr"; printf '<chart>\nsymbol=U30USD\n</chart>\n' | iconv -f ascii -t utf-16le >> "$CD/Default/chart01.chr"; cp "$CD/Default/chart01.chr" "$CD/SQUADRA/chart02.chr"; fi
if [ "$CH" = "ea" ]; then printf '\xff\xfe' > "$CD/SQUADRA/chart03.chr"; printf '<chart>\nsymbol=U30USD\n<window>\n<expert>\nname=ABTG_Nasdaq_Apertura_US\n</expert>\n</window>\n</chart>\n' | iconv -f ascii -t utf-16le >> "$CD/SQUADRA/chart03.chr"; fi
if [ "$CH" = "rotto" ]; then ln -s /nonexistent/x.chr "$CD/SQUADRA/chart09.chr"; fi
TBD="$H/cdrive/Program Files/BCM Markets MT5 Terminal"
if [ "$TERM" = "ok" ]; then mkdir -p "$TBD"; printf 'x' > "$TBD/terminal64.exe"; fi
if [ "$TERM" = "link" ]; then mkdir -p "$H/cdrive/altrove" "$H/cdrive/Program Files"; printf 'x' > "$H/cdrive/altrove/terminal64.exe"; ln -s "$H/cdrive/altrove" "$TBD"; fi
git -C $REPO_ROOT show $PINV:backtest_pipeline/righe/RIGA_ROUND_VPS_RETRY.ps1 > $H/srv/RIGA_ROUND_VPS_RETRY.ps1
if [ "$SMUT" = "drv" ]; then printf '\n# mutato\n' >> $H/srv/RIGA_ROUND_VPS_RETRY.ps1; fi
if [ "$SMUT" = "orig" ]; then git -C $REPO_ROOT show $PINV:backtest_pipeline/righe/RIGA_ROUND_VPS.ps1 > $H/srv/RIGA_ROUND_VPS_RETRY.ps1; fi
cp $RIGA $H/riga.txt
if [ -n "$MOD" ]; then sed -i "$MOD" $H/riga.txt; fi
# pwsh 7.4: l'alias irm e' COSTANTE (non si puo' togliere): nel banco di prova la riga usa irmShim al posto di irm (unica differenza dal testo vero: il nome del comando)
sed -i 's/irm (/irmShim (/g' $H/riga.txt
mkdir -p $OUT/bin_$N; printf '#!/bin/sh\nexec python3 "$STUB" "$@"\n' > $OUT/bin_$N/powershell.exe; chmod +x $OUT/bin_$N/powershell.exe
export COMPUTERNAME=$PCN USERPROFILE=$H/user APPDATA=$H/appdata HOME=$H/user DESKTOP_DIR=$H/user/Desktop SCENARIO=$SCEN HARNESS_LOG=$H/stub.log STUB=$QD/stub_driver.py REPO_ROOT=$REPO_ROOT SRV=$H/srv CDRIVE=$H/cdrive PATH=$OUT/bin_$N:$PATH
# PRE_OLD=<etichetta>: una cartella ROUND_<etichetta> di una corsa PRECEDENTE sul Desktop, con un referto che direbbe "tutto = riga".
if [ -n "${PRE_OLD:-}" ]; then mkdir -p $H/user/Desktop/ROUND_$PRE_OLD; printf 'pin             : %s\r\nmacchina        : DESKTOP-H4D7CAJ   (x)\r\nterminale       : C:\\Program Files\\BCM Markets MT5 Terminal\\terminal64.exe\r\ndeposito        : 10000\r\nmodello         : 4  (tick reali)\r\ndriver          : walkforward_generico_RETRY.ps1\r\n' $PINV > $H/user/Desktop/ROUND_$PRE_OLD/REFERTO_ROUND_$PRE_OLD.txt; fi
# PRE_MT5=1: un processo che si chiama terminal64 (copia di sleep) vivo durante la corsa: la guardia "MT5 aperto" deve fermare la riga.
MT5PID=""; if [ "${PRE_MT5:-}" = "1" ]; then cp "$(command -v sleep)" $OUT/bin_$N/terminal64; $OUT/bin_$N/terminal64 60 & MT5PID=$!; sleep 0.3; fi
cd $H
# NO_RM=<etichetta>: Remove-Item NON toglie la cartella ROUND_<etichetta> (file tenuto aperto su Windows). ZIP_DROP=<testo>: Compress-Archive perde le voci che lo contengono (classe 1021).
# ZIP_STALE=1: lo zip risulta scritto un'ora fa (lo zip di una corsa precedente rimasto li' perche' Compress-Archive non l'ha riscritto).
# Sono funzioni con lo stesso nome del cmdlet: hanno la precedenza, e senza le variabili passano tutto al cmdlet vero.
pwsh -NoProfile -Command 'New-PSDrive -Name C -PSProvider FileSystem -Root $env:CDRIVE | Out-Null; function Remove-Item { [CmdletBinding()] param([string]$LiteralPath,[string]$Path,[switch]$Recurse,[switch]$Force) if($env:NO_RM -and $LiteralPath -and $LiteralPath.EndsWith("ROUND_" + $env:NO_RM)){ return }; Microsoft.PowerShell.Management\Remove-Item @PSBoundParameters }; function Compress-Archive { [CmdletBinding()] param([string[]]$Path,[string]$DestinationPath,[switch]$Force) Microsoft.PowerShell.Archive\Compress-Archive @PSBoundParameters; if($env:ZIP_DROP){ Add-Type -AssemblyName System.IO.Compression.FileSystem; $zz=[IO.Compression.ZipFile]::Open($DestinationPath,"Update"); @($zz.Entries | Where-Object { $_.FullName -like ("*" + $env:ZIP_DROP + "*") }) | ForEach-Object { $_.Delete() }; $zz.Dispose() }; if($env:ZIP_STALE -eq "1"){ (Get-Item -LiteralPath $DestinationPath).LastWriteTime=(Get-Date).AddHours(-1) } }; function irmShim { param([string]$Uri,[string]$OutFile) $n=($Uri -split "[?]")[0]; $n=$n.Substring($n.LastIndexOf("/")+1); Copy-Item -LiteralPath (Join-Path $env:SRV $n) -Destination $OutFile -Force }; $t=Get-Content -Raw ./riga.txt; Invoke-Expression $t; "EXIT=" + $LASTEXITCODE' > $H/out.txt 2>&1
RCS=$?; if [ -n "$MT5PID" ]; then kill $MT5PID 2>/dev/null; wait $MT5PID 2>/dev/null; fi
echo "--- $N: exit shell $RCS"
