#!/bin/bash
# uso: run.sh NOME scenario.json [modifica_sed] [charts=ok|ea|zero|rotto] [pin] [macchina] [serve_mut=drv|] [term=ok|assente|link]
# Stessa forma di collaudo_riga_R92BAB/run.sh. In piu': un disco C: finto (New-PSDrive C -> $H/cdrive) con la cartella programma
# C:\Program Files\BCM Markets MT5 Terminal\terminal64.exe, perche' la riga DAXAP02 controlla che il SOLO terminale ammesso esista e non sia un collegamento.
QD="$(cd "$(dirname "$0")" && pwd)"; REPO_ROOT="$(cd "$QD/../.." && pwd)"; OUT=${HARNESS_OUT:-/tmp/daxap02_harness}; mkdir -p $OUT
N=$1; SCEN=$(readlink -f $2); MOD=$3; CH=${4:-ok}; PINV=${5:-$(git -C $REPO_ROOT rev-parse HEAD)}; PCN=${6-DESKTOP-H4D7CAJ}; SMUT=${7:-}; TERM=${8:-ok}; RIGA=${RIGA_FILE:-$REPO_ROOT/backtest_pipeline/righe/RIGA_ROUND_DAXAP02.txt}
H=$OUT/run_$N; rm -rf $H; mkdir -p $H/user/Desktop $H/appdata/MetaQuotes/Terminal/ABC123 $H/appdata/MetaQuotes/Terminal/Common $H/srv $H/cdrive
printf '\xff\xfe' > $H/appdata/MetaQuotes/Terminal/ABC123/origin.txt; printf 'C:\\Program Files\\BCM Markets MT5 Terminal' | iconv -f ascii -t utf-16le >> $H/appdata/MetaQuotes/Terminal/ABC123/origin.txt
mkdir -p $H/appdata/MetaQuotes/Terminal/ZZZ999; printf 'C:\\MT5_MANUALE' > $H/appdata/MetaQuotes/Terminal/ZZZ999/origin.txt
CD="$H/appdata/MetaQuotes/Terminal/ABC123/MQL5/Profiles/Charts"
if [ "$CH" != "zero" ]; then mkdir -p "$CD/Default" "$CD/SQUADRA"; printf '\xff\xfe' > "$CD/Default/chart01.chr"; printf '<chart>\nsymbol=D30EUR\n</chart>\n' | iconv -f ascii -t utf-16le >> "$CD/Default/chart01.chr"; cp "$CD/Default/chart01.chr" "$CD/SQUADRA/chart02.chr"; fi
if [ "$CH" = "ea" ]; then printf '\xff\xfe' > "$CD/SQUADRA/chart03.chr"; printf '<chart>\nsymbol=D30EUR\n<window>\n<expert>\nname=ABTG_DAX_Apertura_EU\n</expert>\n</window>\n</chart>\n' | iconv -f ascii -t utf-16le >> "$CD/SQUADRA/chart03.chr"; fi
if [ "$CH" = "rotto" ]; then ln -s /nonexistent/x.chr "$CD/SQUADRA/chart09.chr"; fi
TBD="$H/cdrive/Program Files/BCM Markets MT5 Terminal"
if [ "$TERM" = "ok" ]; then mkdir -p "$TBD"; printf 'x' > "$TBD/terminal64.exe"; fi
if [ "$TERM" = "link" ]; then mkdir -p "$H/cdrive/altrove" "$H/cdrive/Program Files"; printf 'x' > "$H/cdrive/altrove/terminal64.exe"; ln -s "$H/cdrive/altrove" "$TBD"; fi
# il solo file che la riga scarica dal pin: il driver, AL PIN (git show), poi l'eventuale mutazione
git -C $REPO_ROOT show $PINV:backtest_pipeline/righe/RIGA_ROUND_VPS.ps1 > $H/srv/RIGA_ROUND_VPS.ps1
if [ "$SMUT" = "drv" ]; then printf '\n# mutato\n' >> $H/srv/RIGA_ROUND_VPS.ps1; fi
cp $RIGA $H/riga.txt
if [ -n "$MOD" ]; then sed -i "$MOD" $H/riga.txt; fi
# pwsh 7.4: l'alias irm e' COSTANTE (non si puo' togliere): nel banco di prova la riga usa irmShim al posto di irm (unica differenza dal testo vero: il nome del comando)
sed -i 's/irm (/irmShim (/g' $H/riga.txt
mkdir -p $OUT/bin_$N; printf '#!/bin/sh\nexec python3 "$STUB" "$@"\n' > $OUT/bin_$N/powershell.exe; chmod +x $OUT/bin_$N/powershell.exe
export COMPUTERNAME=$PCN USERPROFILE=$H/user APPDATA=$H/appdata HOME=$H/user DESKTOP_DIR=$H/user/Desktop SCENARIO=$SCEN HARNESS_LOG=$H/stub.log STUB=$QD/stub_driver.py REPO_ROOT=$REPO_ROOT SRV=$H/srv CDRIVE=$H/cdrive PATH=$OUT/bin_$N:$PATH
# PRE_OLD=1: una cartella ROUND_DAXAP02 di una corsa PRECEDENTE sul Desktop, con un referto che direbbe "tutto = riga": la riga deve toglierla prima del job.
if [ "${PRE_OLD:-}" = "1" ]; then mkdir -p $H/user/Desktop/ROUND_DAXAP02; printf 'pin             : %s\r\nmacchina        : DESKTOP-H4D7CAJ   (x)\r\nterminale       : C:\\Program Files\\BCM Markets MT5 Terminal\\terminal64.exe\r\ndeposito        : 100000\r\nmodello         : 4  (tick reali)\r\n' $PINV > $H/user/Desktop/ROUND_DAXAP02/REFERTO_ROUND_DAXAP02.txt; fi
# PRE_MT5=1: un processo che si chiama terminal64 (copia di sleep) vivo durante la corsa: la guardia "MT5 aperto" deve fermare la riga.
MT5PID=""; if [ "${PRE_MT5:-}" = "1" ]; then cp "$(command -v sleep)" $OUT/bin_$N/terminal64; $OUT/bin_$N/terminal64 60 & MT5PID=$!; sleep 0.3; fi
cd $H
# NO_RM=1: Remove-Item NON toglie la cartella ROUND_DAXAP02 (file tenuto aperto su Windows). ZIP_DROP=<testo>: Compress-Archive perde le voci che lo contengono (classe 1021).
# Sono funzioni con lo stesso nome del cmdlet: hanno la precedenza, e senza le due variabili passano tutto al cmdlet vero.
pwsh -NoProfile -Command 'New-PSDrive -Name C -PSProvider FileSystem -Root $env:CDRIVE | Out-Null; function Remove-Item { [CmdletBinding()] param([string]$LiteralPath,[string]$Path,[switch]$Recurse,[switch]$Force) if($env:NO_RM -eq "1" -and $LiteralPath -and $LiteralPath.EndsWith("ROUND_DAXAP02")){ return }; Microsoft.PowerShell.Management\Remove-Item @PSBoundParameters }; function Compress-Archive { [CmdletBinding()] param([string[]]$Path,[string]$DestinationPath,[switch]$Force) Microsoft.PowerShell.Archive\Compress-Archive @PSBoundParameters; if($env:ZIP_DROP){ Add-Type -AssemblyName System.IO.Compression.FileSystem; $zz=[IO.Compression.ZipFile]::Open($DestinationPath,"Update"); @($zz.Entries | Where-Object { $_.FullName -like ("*" + $env:ZIP_DROP + "*") }) | ForEach-Object { $_.Delete() }; $zz.Dispose() } }; function irmShim { param([string]$Uri,[string]$OutFile) $n=($Uri -split "[?]")[0]; $n=$n.Substring($n.LastIndexOf("/")+1); Copy-Item -LiteralPath (Join-Path $env:SRV $n) -Destination $OutFile -Force }; $t=Get-Content -Raw ./riga.txt; Invoke-Expression $t; "EXIT=" + $LASTEXITCODE' > $H/out.txt 2>&1
RCS=$?; if [ -n "$MT5PID" ]; then kill $MT5PID 2>/dev/null; wait $MT5PID 2>/dev/null; fi
echo "--- $N: exit shell $RCS"
