# =====================================================================
#  RIPRISTINA_SEDIE_100K_CHR.ps1            MARCATORE_RIPRISTINA_100K_CHR_v1
#
#  BERSAGLIO: VPS VMI3047753, SOLO la cartella dati del 100k 50504263
#    %APPDATA%\MetaQuotes\Terminal\BCA8AD18563BF5B64A433C2662D0A104
#    (programma C:\Program Files\BCM Markets MT5 Terminal -V3),
#    profilo SQUADRA 100K, e SOLO a terminale CHIUSO.
#  NON TOCCA: FTMO, REALE 10105439, piccolo 50503392, manuale 50503635,
#    banco 50504400, Pepperstone, Tickmill. Nessun processo chiuso o aperto.
#
#  COSA FA (richiesta di Claudio, 23/10/2026: rimettere le 5 sedie del 100k
#  tolte a mano il 24-25/09): prende i 5 grafici ORIGINALI che restano nel
#  profilo Default della STESSA cartella dati (chart*.chr con EA e input
#  identici, risk 0,65 e ORB 0,3) e li COPIA nel profilo SQUADRA 100K come
#  NUOVI file chartNN.chr (numeri liberi dopo l'ultimo). NON sovrascrive MAI
#  un file esistente, NON cambia il profilo attivo, NON copia il Guardian di
#  Default (AUDCAD): il Guardian 779001 resta quello di AUDNZD.
#  Ogni nuovo file porta un id= nuovo (massimo del profilo + 2k).
#
#  OROLOGIO (BCM e UTC+1 fisso; dal 26/10 il DAX arma alle 08:00 = 1 ora prima di Xetra):
#    -Dax prima  : DAX 770101 e MaxMin 770411 come erano (ore d'estate)
#    -Dax cash   : DAX 770101: SessionHour 8->9 e CloseHour 17->18;
#                  MaxMin 770411: BoxStart 23->0, BoxEnd 4->5, Place 7->8,
#                  EntryCutoff 8->9, Close 17->18 (SOLO se i valori sono quelli attesi)
#    -Dax no     : DAX 770101 e MaxMin 770411 NON si rimettono
#    Dow e ORB (USA) tornano come erano: dal 02/11 vanno rivisti a mano.
#
#  USO:
#    ... -File RIPRISTINA_SEDIE_100K_CHR.ps1 [-Dax prima|cash|no]               prova a secco
#    ... -File RIPRISTINA_SEDIE_100K_CHR.ps1 -Esegui [-Dax ...]                 scrive
#    ... -File RIPRISTINA_SEDIE_100K_CHR.ps1 -Annulla <ELENCO_RIPRISTINO_100K_*.csv>  toglie i file creati
#    -Origine <cartella>  per usare un'altra cartella di origine (default: profilo Default)
#
#  Prima di scrivere fa il backup verificato dell'INTERA cartella del profilo
#  (Desktop\BACKUP_PROFILO_100K_<ts>_PRIMA_DI_RIPRISTINO). Dopo ogni file rilegge
#  e verifica byte e contenuto; se la verifica fallisce il file nuovo viene tolto.
#  Esito sul Desktop: esito_ripristina_100k_<ts>.txt ASCII puro.
#  NON provato su un MT5 vero: ha prova a secco, backup e -Annulla.
# =====================================================================
param(
  [switch]$Esegui,
  [string]$Origine = "",
  [string]$Annulla = "",
  [string]$Dax = "prima",
  [string]$ProvaRadice = "",
  [string]$ProvaTerminali = ""
)

$ErrorActionPreference = 'Stop'
trap { Write-Host ("ERRORE IMPREVISTO: " + $_.Exception.Message) -ForegroundColor Red; try { Dillo ("ERRORE IMPREVISTO: " + $_.Exception.Message) 'Red'; Scrivi-Esito "ERRORE_IMPREVISTO" } catch {}; exit 4 }
$INV = [Globalization.CultureInfo]::InvariantCulture
$TS  = (Get-Date).ToString('yyyyMMdd_HHmmss_fff', $INV)

$MACCHINA    = 'VMI3047753'
$PROGRAMMA   = 'C:\Program Files\BCM Markets MT5 Terminal -V3'
$HASHDATI    = 'BCA8AD18563BF5B64A433C2662D0A104'
$PROFILO     = 'SQUADRA 100K'
$SIMB_INDICI = @('U30USD','D30EUR','NASUSD','225JPY')
# v2 (cancello 25/09, classe 180 sui processi): i terminal64 vivi ammessi si
# ELENCANO per cartella. Un terminal64 in una cartella che non e' qui (anche il
# piccolo lanciato da un percorso scritto diverso, es. 8.3 C:\PROGRA~1\...) = FERMO.
$ALTRI_NOTI = @('C:\FTMO','C:\BCM_Reale','C:\Program Files\BCM Markets MT5 Terminal','C:\MT5_MANUALE','C:\MT5_Backtest','C:\Program Files\Pepperstone MetaTrader 5','C:\Program Files\Tickmill Europe MT5 Terminal')

# --- LE 5 SEDIE DEL 100k (report/RIPRISTINO_DEMO_QUADRO_2026-10-23.md par. 4, CODA_01 24/09).
#     c = campo del magic dentro <inputs> dell'EA; tf e chr = foto CODA_01
#     del 25/09 03:30 (profilo salvato 23/09 19:35), SOLO informativi.
$TABELLA = @(
  @{n=1; ea='ABTG_DAX_Apertura_EU';                   s='D30EUR'; m='770101'; c='InpMagic'; tf='M5';  chr='Default\chart02.chr'},
  @{n=2; ea='ABTG_Dow_Apertura_US';                   s='U30USD'; m='770202'; c='InpMagic'; tf='M5';  chr='Default\chart03.chr'},
  @{n=3; ea='ABTG_MaxMinNotte_DAX_Short_Ottimizzato'; s='D30EUR'; m='770411'; c='InpMagic'; tf='M15'; chr='Default\chart04.chr'},
  @{n=4; ea='ABTG_SupertrendReversal';                s='225JPY'; m='770901'; c='InpMagic'; tf='H2';  chr='Default\chart05.chr'},
  @{n=5; ea='ABTG_ORB_Ottimizzato';                   s='U30USD'; m='770611'; c='InpMagic'; tf='M5';  chr='Default\chart06.chr'}
)

# ---------------------------------------------------------------- uscita
$script:RIGHE = New-Object System.Collections.ArrayList
$script:DESK  = ""
function Dillo([string]$t, [string]$col){
  [void]$script:RIGHE.Add($t)
  if($col){ Write-Host $t -ForegroundColor $col } else { Write-Host $t }
}
function Scrivi-Esito([string]$stato){
  Dillo ("STATO: " + $stato) 'Cyan'
  if(-not $script:DESK){ return }
  try{
    if(-not (Test-Path -LiteralPath $script:DESK)){ New-Item -ItemType Directory -Force -Path $script:DESK | Out-Null }
    $f = Join-Path $script:DESK ("esito_ripristina_100k_" + $TS + ".txt")
    [IO.File]::WriteAllLines($f, [string[]]$script:RIGHE.ToArray(), (New-Object Text.UTF8Encoding($false)))
    Write-Host ("esito scritto in: " + $f) -ForegroundColor Green
  } catch { Write-Host ("ESITO NON SCRITTO SUL DESKTOP: " + $_.Exception.Message) -ForegroundColor Red }
}
function Ferma([string]$perche, [switch]$GiaScritto){
  Dillo "" $null
  if($GiaScritto){
    Dillo ("FERMO DOPO LA SCRITTURA: i .chr SONO GIA' STATI SCRITTI (backup sul Desktop, BACKUP_PROFILO_100K_" + $TS + "). " + $perche) 'Red'
    Scrivi-Esito "FERMO_DOPO_SCRITTURA"
    exit 3
  }
  Dillo ("FERMO, NIENTE E' STATO SCRITTO: " + $perche) 'Red'
  Scrivi-Esito "FERMO_GUARDIA"
  exit 2
}

# ---------------------------------------------------------------- lettura .chr
# Codifica: BOM FF FE = UTF-16LE; EF BB BF = UTF-8; senza BOM euristica dei
# byte zero (stessa di CODA_01/CODA_08). Si toglie il BOM PRIMA di decodificare
# e lo si rimette uguale in scrittura.
function Leggi-Chr([string]$path){
  $b = [IO.File]::ReadAllBytes($path)
  $r = New-Object psobject -Property @{ Byte=$b; Bom=[byte[]]@(); Enc=$null; Testo=""; NomeEnc="" }
  if($b.Length -ge 2 -and $b[0] -eq 0xFF -and $b[1] -eq 0xFE){
    $r.Bom = [byte[]]@(0xFF,0xFE); $r.Enc = New-Object Text.UnicodeEncoding($false,$false,$true); $r.NomeEnc = "UTF-16LE+BOM"
  } elseif($b.Length -ge 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB -and $b[2] -eq 0xBF){
    $r.Bom = [byte[]]@(0xEF,0xBB,0xBF); $r.Enc = New-Object Text.UTF8Encoding($false,$true); $r.NomeEnc = "UTF-8+BOM"
  } else {
    $zeri = 0; $n = [math]::Min(400,$b.Length)
    for($i=1; $i -lt $n; $i+=2){ if($b[$i] -eq 0){ $zeri++ } }
    if($n -gt 0 -and $zeri -gt ($n/4)){ $r.Enc = New-Object Text.UnicodeEncoding($false,$false,$true); $r.NomeEnc = "UTF-16LE senza BOM" }
    else { $r.Enc = New-Object Text.UTF8Encoding($false,$true); $r.NomeEnc = "UTF-8 senza BOM" }
  }
  $k = $r.Bom.Length
  $r.Testo = $r.Enc.GetString($b, $k, $b.Length - $k)
  return $r
}
function Byte-Uguali([byte[]]$a, [byte[]]$b){
  if($a.Length -ne $b.Length){ return $false }
  for($i=0; $i -lt $a.Length; $i++){ if($a[$i] -ne $b[$i]){ return $false } }
  return $true
}
function Componi([byte[]]$bom, $enc, [string]$testo){
  $corpo = $enc.GetBytes($testo)
  $out = New-Object byte[] ($bom.Length + $corpo.Length)
  if($bom.Length -gt 0){ [Array]::Copy($bom, 0, $out, 0, $bom.Length) }
  [Array]::Copy($corpo, 0, $out, $bom.Length, $corpo.Length)
  return ,$out
}
function Campo([string]$txt, [string]$chiave){
  $m = [regex]::Match($txt, "(?im)^[ \t]*" + [regex]::Escape($chiave) + "[ \t]*=[ \t]*(.*?)[ \t]*$")
  if($m.Success -and $m.Groups[1].Value.Trim().Length -gt 0){ return $m.Groups[1].Value.Trim() }
  return "-"
}
function TF([string]$tipo, [string]$size){
  $t = 0; $s = 0
  if(-not [int]::TryParse($tipo, [Globalization.NumberStyles]::Integer, $INV, [ref]$t)){ return "?" }
  if(-not [int]::TryParse($size, [Globalization.NumberStyles]::Integer, $INV, [ref]$s)){ return "?" }
  switch($t){ 0 { return ("M" + $s) } 1 { return ("H" + $s) } 2 { return ("D" + $s) } 3 { return ("W" + $s) } 4 { return ("MN" + $s) } default { return "?" } }
}
# Il blocco da togliere: dall'inizio della RIGA di <expert> fino a </expert>
# e al suo a-capo. Se <expert> non e' a inizio riga, o ce n'e' piu' d'uno,
# il file NON si tocca (fail-closed).
$RX_BLOCCO = '(?m)^[ \t]*<expert>(?s:.*?)</expert>[ \t]*(?:\r?\n)?'

function Analizza($file){
  $r = New-Object psobject -Property @{ File=$file; Chr=$file.Name; Simbolo="-"; TF="?"; EA="-"; Magic="-"; Riga=$null; Azione=""; Nota=""; Letto=$null; Blocco=$null }
  try { $L = Leggi-Chr $file.FullName } catch { $r.Azione = "ILLEGGIBILE"; $r.Nota = $_.Exception.Message; return $r }
  $r.Letto = $L
  $t = $L.Testo
  $r.Simbolo = Campo $t "symbol"
  $r.TF = TF (Campo $t "period_type") (Campo $t "period_size")
  $nAperti = ([regex]::Matches($t, '<expert>')).Count
  $nChiusi = ([regex]::Matches($t, '</expert>')).Count
  if($nAperti -eq 0 -and $nChiusi -eq 0){ $r.Azione = "NESSUN EA"; return $r }
  $mm = [regex]::Matches($t, $RX_BLOCCO)
  if($nAperti -ne 1 -or $nChiusi -ne 1 -or $mm.Count -ne 1){
    $r.Azione = "ANOMALO"; $r.Nota = ("<expert> aperti=" + $nAperti + " chiusi=" + $nChiusi + " blocchi a inizio riga=" + $mm.Count + ": NON si tocca"); return $r
  }
  $r.Blocco = $mm[0]
  $blk = $mm[0].Value
  $r.EA = Campo $blk "name"
  if($r.EA -eq "-"){
    $mp = [regex]::Match($blk, "(?im)^[ \t]*path[ \t]*=[ \t]*Experts\\(.+?)\.ex5")
    if($mp.Success){ $r.EA = [IO.Path]::GetFileNameWithoutExtension($mp.Groups[1].Value) }
  }
  # v2: MT5 scrive un blocco <expert> anche sui grafici SENZA EA (nome vuoto o
  # 'Main'): CODA_08 25/09, 'senza <expert> 0' su tutte le cartelle dati. Stessa
  # regola di CODA_08: quello NON e' un EA, e non entra nella spazzata.
  if($r.EA -eq "-" -or $r.EA -ieq "Main"){ $r.Azione = "NESSUN EA"; $r.Nota = "blocco <expert> senza EA (nome '" + $r.EA + "'): non si tocca"; return $r }
  $im = [regex]::Match($blk, '(?s)<inputs>(.*?)</inputs>')
  $inp = ""; if($im.Success){ $inp = $im.Groups[1].Value }
  $mg  = Campo $inp "InpMagic"
  $mgn = Campo $inp "InpMagicNumber"
  if($mg -ne "-"){ $r.Magic = $mg } elseif($mgn -ne "-"){ $r.Magic = $mgn + " (InpMagicNumber)" }
  foreach($x in $TABELLA){
    if(($r.EA -ceq $x.ea) -and ($r.Simbolo -ieq $x.s) -and ((Campo $inp $x.c) -eq $x.m)){ $r.Riga = $x; break }
  }
  if($r.Riga){ $r.Azione = "SOSPENDI" }
  elseif($SIMB_INDICI -icontains $r.Simbolo){ $r.Azione = "SPAZZATA" }
  else { $r.Azione = "RESTA" }
  return $r
}

# ---------------------------------------------------------------- guardie
function Percorso-Dir([string]$p){
  $q = $p.Trim().TrimEnd('\')
  $i = $q.LastIndexOf('\')
  if($i -lt 0){ return "" }
  return $q.Substring(0, $i)
}
function Guardia-Processi([string]$quando, [switch]$GiaScritto){
  $percorsi = @()
  if($ProvaRadice){
    $percorsi = @($ProvaTerminali -split '\|' | Where-Object { $_.Trim().Length -gt 0 })
    Dillo ("    [PROVA] processi terminal64 SIMULATI (" + $quando + "): " + $percorsi.Count) 'DarkYellow'
  } else {
    $pp = @(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)
    foreach($p in $pp){
      $x = $null
      try { $x = $p.Path } catch { $x = $null }
      if(-not $x){
        try { $w = Get-CimInstance Win32_Process -Filter ("ProcessId=" + $p.Id) -ErrorAction Stop; if($w){ $x = $w.ExecutablePath } } catch { $x = $null }
      }
      if(-not $x){ Ferma ("terminal64 PID " + $p.Id + " ha il percorso NON LEGGIBILE (" + $quando + "): potrebbe essere il 100k. Senza sapere chi e', non si tocca niente.") -GiaScritto:$GiaScritto }
      $percorsi += $x
    }
    Dillo ("    processi terminal64 vivi (" + $quando + "): " + $percorsi.Count) $null
  }
  foreach($x in $percorsi){
    $d = Percorso-Dir $x
    $eTarget = ($d -ieq $PROGRAMMA)
    $eNoto = ($ALTRI_NOTI -icontains $d)
    $tag = "SCONOSCIUTO"; if($eTarget){ $tag = "IL 100k 50504263" } elseif($eNoto){ $tag = "altro terminale noto, NON toccato" }
    Dillo ("      " + $x + "   -> " + $tag) $null
    if($eTarget){ Ferma ("il terminale del 100k 50504263 (" + $PROGRAMMA + ") e' APERTO (" + $quando + "). Alla chiusura riscriverebbe i .chr e rimetterebbe le sedie. Chiudilo A MANO (File -> Esci) e rilancia.") -GiaScritto:$GiaScritto }
    if(-not $eNoto){ Ferma ("terminal64 in una cartella NON in elenco (" + $d + ", " + $quando + "): potrebbe essere il 100k lanciato da un altro percorso. Senza sapere chi e', non si tocca niente.") -GiaScritto:$GiaScritto }
  }
}


# ---------------------------------------------------------------- avvio
Dillo "=== RIPRISTINA LE 5 SEDIE DEL 100k 50504263 NEL PROFILO SQUADRA 100K -- MARCATORE_RIPRISTINA_100K_CHR_v1 ===" 'Cyan'
Dillo ("ora locale di questa macchina: " + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $INV) + "   macchina " + $env:COMPUTERNAME + "   utente " + $env:USERNAME) $null
Dillo ("BERSAGLIO: VPS " + $MACCHINA + ", SOLO la cartella dati " + $HASHDATI + " del 100k 50504263 (" + $PROGRAMMA + "), profilo " + $PROFILO + ", a terminale CHIUSO.") 'Green'
Dillo "NON TOCCATI: FTMO, REALE 10105439 (C:\BCM_Reale), piccolo 50503392, manuale 50503635, banco 50504400, Pepperstone, Tickmill. Nessun processo chiuso o aperto. Nessun file esistente viene sovrascritto." 'Green'
if(@('prima','cash','no') -notcontains $Dax){ Ferma ("-Dax deve essere prima, cash o no (ricevuto '" + $Dax + "').") }
$modo = "PROVA A SECCO (non scrive niente)"
if($Annulla){ $modo = "ANNULLA (toglie i file creati dal ripristino)" } elseif($Esegui){ $modo = "ESEGUI (scrive)" }
Dillo ("MODO: " + $modo + "   orologio DAX/MaxMin: " + $Dax) 'Yellow'

# (a) la macchina, e le radici
if($ProvaRadice){
  if($env:APPDATA){
    $vera = [IO.Path]::GetFullPath($env:APPDATA).TrimEnd('\','/')
    $fin  = [IO.Path]::GetFullPath($ProvaRadice).TrimEnd('\','/')
    if($fin.StartsWith($vera, [StringComparison]::OrdinalIgnoreCase)){ Write-Host "RIFIUTATO: -ProvaRadice dentro il vero APPDATA." -ForegroundColor Red; exit 2 }
  }
  $APPD = Join-Path $ProvaRadice 'AppData'
  $script:DESK = Join-Path $ProvaRadice 'Desktop'
  Dillo ("[PROVA] MODALITA' PROVA su cartella finta " + $ProvaRadice + ": guardia della macchina SOSTITUITA da questo avviso.") 'DarkYellow'
} else {
  $script:DESK = [Environment]::GetFolderPath('Desktop')
  if($env:COMPUTERNAME -ne $MACCHINA){ Ferma ("questa macchina si chiama " + $env:COMPUTERNAME + ", non " + $MACCHINA + " (il VPS). Sul PC di backtest il 100k non c'e'.") }
  $APPD = $env:APPDATA
  if(-not $APPD){ Ferma "APPDATA vuota." }
}

# (b) il terminale del 100k deve essere CHIUSO
Dillo "--- GUARDIA (b): terminale del 100k chiuso?" $null
Guardia-Processi "inizio"

# (c) la cartella dati esatta e il suo origin.txt
$DATI = Join-Path (Join-Path (Join-Path $APPD 'MetaQuotes') 'Terminal') $HASHDATI
Dillo ("--- GUARDIA (c): cartella dati " + $DATI) $null
if(-not (Test-Path -LiteralPath $DATI -PathType Container)){ Ferma ("la cartella dati " + $DATI + " non esiste.") }
$ORIG = Join-Path $DATI 'origin.txt'
if(-not (Test-Path -LiteralPath $ORIG)){ Ferma "origin.txt assente nella cartella dati." }
$o = ""
try { $o = (Leggi-Chr $ORIG).Testo } catch { Ferma ("origin.txt illeggibile: " + $_.Exception.Message) }
$o = ($o -replace "[^\x20-\x7E]", "").Trim()
Dillo ("    origin.txt -> '" + $o + "'") $null
if(-not ($o.TrimEnd('\') -ieq $PROGRAMMA)){ Ferma ("origin.txt punta a '" + $o + "', non a '" + $PROGRAMMA + "'.") }

# (d) profilo attivo = SQUADRA 100K
$INI = Join-Path (Join-Path $DATI 'config') 'common.ini'
Dillo "--- GUARDIA (d): profilo attivo in config\common.ini" $null
if(-not (Test-Path -LiteralPath $INI)){ Ferma "config\common.ini assente." }
$ci = ""
try { $ci = (Leggi-Chr $INI).Testo } catch { Ferma ("common.ini illeggibile: " + $_.Exception.Message) }
$pm = [regex]::Matches($ci, "(?im)^[ \t]*ProfileLast[ \t]*=[ \t]*(.*?)[ \t]*$")
if($pm.Count -ne 1){ Ferma ("in common.ini le righe ProfileLast sono " + $pm.Count + ", attesa 1.") }
$pa = $pm[0].Groups[1].Value.Trim()
Dillo ("    ProfileLast=" + $pa) $null
if($pa -ne $PROFILO){ Ferma ("il profilo attivo e' '" + $pa + "', non '" + $PROFILO + "'. Se si riapre con un altro profilo le sedie di SQUADRA 100K non sono quelle che partono: da rivedere prima di toccare.") }
$PDIR = Join-Path (Join-Path (Join-Path (Join-Path $DATI 'MQL5') 'Profiles') 'Charts') $PROFILO
if(-not (Test-Path -LiteralPath $PDIR -PathType Container)){ Ferma ("cartella del profilo assente: " + $PDIR) }
$PDIR = (Get-Item -LiteralPath $PDIR).FullName.TrimEnd('\','/')
Dillo ("    cartella profilo: " + $PDIR) $null

# ---------------------------------------------------------------- backup
function Fai-Backup([string]$etichetta){
  $dst = Join-Path $script:DESK ("BACKUP_PROFILO_100K_" + $TS + $etichetta)
  if(Test-Path -LiteralPath $dst){ Ferma ("la cartella di backup esiste gia': " + $dst) }
  Copy-Item -LiteralPath $PDIR -Destination $dst -Recurse -Force
  $dst = (Get-Item -LiteralPath $dst).FullName.TrimEnd('\','/')
  $a = @(Get-ChildItem -LiteralPath $PDIR -Recurse -File)
  $b = @(Get-ChildItem -LiteralPath $dst  -Recurse -File)
  if($a.Count -ne $b.Count -or $a.Count -eq 0){ Ferma ("backup NON verificato: file nel profilo " + $a.Count + ", nel backup " + $b.Count) }
  foreach($f in $a){
    $rel = $f.FullName.Substring($PDIR.Length).TrimStart('\','/')
    $g = Join-Path $dst $rel
    if(-not (Test-Path -LiteralPath $g)){ Ferma ("backup NON verificato: manca " + $rel) }
    if((Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash -ne (Get-FileHash -LiteralPath $g -Algorithm SHA256).Hash){ Ferma ("backup NON verificato: SHA256 diverso su " + $rel) }
  }
  Dillo ("    BACKUP VERIFICATO: " + $b.Count + " file, SHA256 uguali uno per uno -> " + $dst) 'Green'
  return $dst
}


# ---------------------------------------------------------------- ANNULLA
if($Annulla){
  Dillo ("--- ANNULLA da elenco: " + $Annulla) $null
  if(-not (Test-Path -LiteralPath $Annulla -PathType Leaf)){ Ferma "l'elenco indicato non esiste." }
  if((Split-Path -Leaf $Annulla) -notlike 'ELENCO_RIPRISTINO_100K_*.csv'){ Ferma "il file indicato non e' un ELENCO_RIPRISTINO_100K_*.csv." }
  $righeA = @(Import-Csv -LiteralPath $Annulla)
  if($righeA.Count -eq 0){ Ferma "l'elenco e' vuoto." }
  $primaA = Fai-Backup "_PRIMA_DI_ANNULLA_RIPRISTINO"
  Guardia-Processi "subito prima di togliere"
  $tolti = 0; $kk = 0
  foreach($x in $righeA){
    $p = Join-Path $PDIR $x.File
    if(-not (Test-Path -LiteralPath $p)){ Dillo ("    gia' assente: " + $x.File) 'Yellow'; continue }
    $h = (Get-FileHash -LiteralPath $p -Algorithm SHA256).Hash
    if($h -ne $x.Sha256){ $kk++; Dillo ("    NON TOLTO " + $x.File + ": e' cambiato dopo il ripristino (SHA256 diverso).") 'Red'; continue }
    Remove-Item -LiteralPath $p -Force
    $tolti++; Dillo ("    TOLTO " + $x.File + "  (" + $x.Sedia + ")") 'Green'
  }
  Dillo ("    tolti: " + $tolti + "   non toccati perche cambiati: " + $kk + "   (stato di prima salvato in " + $primaA + ")") $null
  if($kk -gt 0){ Scrivi-Esito "ANNULLA_CON_AVVISI"; exit 3 }
  Scrivi-Esito "ANNULLATO_OK"; exit 0
}

# ---------------------------------------------------------------- origine
$BK0 = $Origine
if(-not $BK0){ $BK0 = Join-Path (Split-Path -Parent $PDIR) 'Default' }
Dillo ("--- ORIGINE (le sedie come erano): " + $BK0) $null
if(-not (Test-Path -LiteralPath $BK0 -PathType Container)){ Ferma ("la cartella di origine non esiste: " + $BK0) }
$BK0 = (Get-Item -LiteralPath $BK0).FullName.TrimEnd('\','/')
if($BK0 -ieq $PDIR){ Ferma "la cartella di origine coincide con il profilo di destinazione." }
$fbk = @(Get-ChildItem -LiteralPath $BK0 -Filter 'chart*.chr' -File | Sort-Object Name)
if($fbk.Count -eq 0){ Ferma "nell'origine non ci sono chart*.chr." }
$anaB = @(); foreach($f in $fbk){ $anaB += (Analizza $f) }
$cur = @(Get-ChildItem -LiteralPath $PDIR -Filter 'chart*.chr' -File | Sort-Object Name)
$anaC = @(); foreach($f in $cur){ $anaC += (Analizza $f) }
Dillo ("    chart*.chr nell'origine: " + $fbk.Count + "   nel profilo SQUADRA 100K adesso: " + $cur.Count) $null

$maxN = 0
foreach($f in $cur){ $mn = [regex]::Match($f.Name, '^chart(\d+)\.chr$'); if($mn.Success){ $vn = [int]$mn.Groups[1].Value; if($vn -gt $maxN){ $maxN = $vn } } }
$maxId = [int64]0
foreach($a in $anaC){ if($a.Letto){ $mi = [regex]::Match($a.Letto.Testo, '(?m)^id=(\d+)'); if($mi.Success){ $iv = [int64]0; if([int64]::TryParse($mi.Groups[1].Value, [Globalization.NumberStyles]::Integer, $INV, [ref]$iv)){ if($iv -gt $maxId){ $maxId = $iv } } } } }

$MOD_CASH = @{
  1 = @( @('InpSessionHour','8','9'), @('InpCloseHour','17','18') )
  3 = @( @('InpBoxStartHour','23','0'), @('InpBoxEndHour','4','5'), @('InpPlaceHour','7','8'), @('InpEntryCutoffHour','8','9'), @('InpCloseHour','17','18') )
}

# ---------------------------------------------------------------- piano
$piano = New-Object System.Collections.ArrayList
$k = 0
foreach($x in $TABELLA){
  $gia = @($anaC | Where-Object { $_.Riga -and $_.Riga.n -eq $x.n })
  $inB = @($anaB | Where-Object { $_.Riga -and $_.Riga.n -eq $x.n })
  $stato = ""; $nota = ""; $nome = "-"; $testo = $null; $b = $null
  if($gia.Count -ge 1){ $stato = "GIA ATTACCATA"; $nota = "nel profilo c'e gia: " + $gia[0].Chr }
  elseif($inB.Count -ne 1){ $stato = "NON NELL ORIGINE"; $nota = "righe trovate nell origine: " + $inB.Count }
  elseif(($x.n -eq 1 -or $x.n -eq 3) -and $Dax -eq 'no'){ $stato = "SALTATA (-Dax no)"; $nota = "decisione sull'orologio" }
  else {
    $b = $inB[0]
    $t = $b.Letto.Testo
    $okMod = $true
    if(($x.n -eq 1 -or $x.n -eq 3) -and $Dax -eq 'cash'){
      foreach($mod in $MOD_CASH[$x.n]){
        $rx = '(?m)^(' + [regex]::Escape($mod[0]) + '=)' + [regex]::Escape($mod[1]) + '(\r?)$'
        $mc = [regex]::Matches($t, $rx)
        if($mc.Count -ne 1){ $okMod = $false; $nota = $mod[0] + " non vale " + $mod[1] + " nel backup: orologio NON cambiato, sedia non rimessa"; break }
        $t = [regex]::Replace($t, $rx, ('${1}' + $mod[2] + '${2}'))
      }
    }
    if(-not $okMod){ $stato = "DA GUARDARE" }
    else {
      $k++
      $nome = "chart" + ([string]($maxN + $k)).PadLeft(2,'0') + ".chr"
      $mi2 = [regex]::Match($t, '(?m)^id=(\d+)')
      if($mi2.Success){
        $nid = $maxId + (2 * $k)
        $t = $t.Substring(0, $mi2.Index) + ('id=' + $nid.ToString($INV)) + $t.Substring($mi2.Index + $mi2.Length)
      }
      $stato = "RIPRISTINA"
      if($Dax -eq 'cash' -and ($x.n -eq 1 -or $x.n -eq 3)){ $nota = "orologio +1h (apertura cash)" }
      $testo = $t
    }
  }
  [void]$piano.Add((New-Object psobject -Property @{ Num=$x.n; EA=$x.ea; Simbolo=$x.s; TF=$x.tf; Magic=$x.m; Stato=$stato; Nota=$nota; Nome=$nome; Testo=$testo; Letto=$(if($b){ $b.Letto } else { $null }) }))
}
$fmt = "{0,2}. {1,-40} {2,-7} {3,-4} magic {4,-7} {5,-18} {6,-12} {7}"
Dillo "" $null
foreach($r in $piano){
  $col = 'Green'; if($r.Stato -ne "RIPRISTINA"){ $col = 'Yellow' }
  Dillo ($fmt -f $r.Num, $r.EA, $r.Simbolo, $r.TF, $r.Magic, $r.Stato, $r.Nome, $r.Nota) $col
}
$daFare = @($piano | Where-Object { $_.Stato -eq "RIPRISTINA" })
$giaN = @($piano | Where-Object { $_.Stato -eq "GIA ATTACCATA" }).Count
$strani = @($piano | Where-Object { $_.Stato -ne "RIPRISTINA" -and $_.Stato -ne "GIA ATTACCATA" -and $_.Stato -notlike "SALTATA*" }).Count
Dillo ("DA RIPRISTINARE: " + $daFare.Count + "   gia attaccate: " + $giaN + "   da guardare / non nel backup: " + $strani) 'White'

if(-not $Esegui){
  Dillo "" $null
  Dillo ("PROVA A SECCO: niente e' stato scritto. Con -Esegui si creerebbero " + $daFare.Count + " nuovi file chartNN.chr nel profilo SQUADRA 100K.") 'Yellow'
  if($strani -gt 0){ Scrivi-Esito "SECCO_DA_GUARDARE (righe non rimettibili: leggi la tabella)" } else { Scrivi-Esito "SECCO_OK" }
  exit 0
}
if($daFare.Count -eq 0){ Dillo "niente da ripristinare." 'Green'; Scrivi-Esito "ESEGUITO_NIENTE_DA_FARE"; exit 0 }

# ---------------------------------------------------------------- scrittura
Dillo "" $null
Dillo "--- BACKUP dell'INTERA cartella del profilo SQUADRA 100K" $null
$BKp = Fai-Backup "_PRIMA_DI_RIPRISTINO"
Guardia-Processi "subito prima di scrivere"
$ok = 0; $ko = 0
$elenco = New-Object System.Collections.ArrayList
[void]$elenco.Add("File,Sha256,Sedia")
foreach($r in $daFare){
  $dst = Join-Path $PDIR $r.Nome
  if(Test-Path -LiteralPath $dst){ $ko++; Dillo ("    NON SCRITTO " + $r.Nome + ": esiste gia (non si sovrascrive mai).") 'Red'; continue }
  $L0 = $r.Letto
  $nb = Componi $L0.Bom $L0.Enc $r.Testo
  try {
    [IO.File]::WriteAllBytes($dst, $nb)
    $rb = [IO.File]::ReadAllBytes($dst)
    $A2 = Analizza (Get-Item -LiteralPath $dst)
    $semOk = ($A2.Riga -ne $null) -and ($A2.Riga.n -eq $r.Num) -and ($A2.Simbolo -ieq $r.Simbolo) -and ($A2.EA -ceq $r.EA)
    if((Byte-Uguali $rb $nb) -and $semOk){
      $ok++
      $sha = (Get-FileHash -LiteralPath $dst -Algorithm SHA256).Hash
      [void]$elenco.Add($r.Nome + "," + $sha + "," + $r.EA + " " + $r.Simbolo + " " + $r.Magic)
      Dillo ("    CREATO " + $r.Nome + "  (" + $r.EA + " " + $r.Simbolo + " " + $r.TF + " magic " + $r.Magic + ")   " + $nb.Length + " byte, " + $L0.NomeEnc) 'Green'
    } else {
      $ko++
      Remove-Item -LiteralPath $dst -Force -ErrorAction SilentlyContinue
      Dillo ("    VERIFICA FALLITA su " + $r.Nome + ": file nuovo TOLTO.") 'Red'
    }
  } catch {
    $ko++
    try { if(Test-Path -LiteralPath $dst){ Remove-Item -LiteralPath $dst -Force } } catch {}
    Dillo ("    ERRORE su " + $r.Nome + ": " + $_.Exception.Message + " -- file nuovo tolto.") 'Red'
  }
}
Guardia-Processi "dopo la scrittura" -GiaScritto
$ELF = Join-Path $script:DESK ("ELENCO_RIPRISTINO_100K_" + $TS + ".csv")
[IO.File]::WriteAllLines($ELF, [string[]]$elenco.ToArray(), (New-Object Text.UTF8Encoding($false)))

# rilettura finale per contenuto
$dopo = @()
foreach($f in @(Get-ChildItem -LiteralPath $PDIR -Filter 'chart*.chr' -File | Sort-Object Name)){ $dopo += (Analizza $f) }
$presenti = @($dopo | Where-Object { $_.Azione -eq "SOSPENDI" })
Dillo "" $null
Dillo ("--- RILETTURA: sedie della tabella con EA nel profilo adesso: " + $presenti.Count + " su 5   file creati: " + $ok + "   errori: " + $ko) 'White'
foreach($r in $presenti){ Dillo ("    " + $r.Chr + "  " + $r.EA + " " + $r.Simbolo + " " + $r.TF + " magic " + $r.Magic) 'Green' }
Dillo ("BACKUP del profilo prima del ripristino: " + $BKp) 'Cyan'
Dillo ("ELENCO dei file creati: " + $ELF + "   -> per tornare indietro: -Annulla '" + $ELF + "'") 'Cyan'
Dillo "ORA apri a mano il terminale del 100k 50504263 (profilo SQUADRA 100K): controlla che i grafici abbiano l'EA (faccina sorridente), che l'Algo Trading del terminale sia come lo vuoi e guarda la scheda Trade per ordini pendenti e posizioni." 'Yellow'
if($ko -gt 0){ Scrivi-Esito "ESEGUITO_CON_ERRORI"; exit 3 }
if($strani -gt 0){ Scrivi-Esito "ESEGUITO_DA_GUARDARE (righe non rimettibili: leggi la tabella)"; exit 0 }
Scrivi-Esito "ESEGUITO_OK"
exit 0
