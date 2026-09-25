# =====================================================================
#  SOSPENDI_SEDIE_PICCOLO_CHR.ps1              MARCATORE_SOSPENDI_PICCOLO_CHR_v2
#
#  BERSAGLIO: VPS VMI3047753, SOLO la cartella dati del piccolo 50503392
#    %APPDATA%\MetaQuotes\Terminal\215D85D767A1C39E22D242C8114BF9F5
#    (programma C:\Program Files\BCM Markets MT5 Terminal, SENZA -V3),
#    profilo ORO, e SOLO a terminale CHIUSO.
#  NON TOCCA: FTMO 541452707 (C:\FTMO), REALE 10105439 (C:\BCM_Reale),
#    100k 50504263 (BCM Markets MT5 Terminal -V3), manuale 50503635
#    (C:\MT5_MANUALE), banco 50504400 (C:\MT5_Backtest), Pepperstone,
#    Tickmill. Nessun processo viene chiuso o aperto.
#
#  PERCHE' (25/09/2026): FTMO ha scritto che il divieto di hedging fra conti
#  vale anche sui DEMO e sugli indici correlati (docs/RISPOSTA_SUPPORTO_FTMO_
#  2026-09-25.md). Claudio ha firmato la sospensione delle 15 sedie indice del
#  piccolo (report/SOSPENSIONE_SEDIE_DEMO_2026-09-25.md par. 1). Il terminale
#  del piccolo e' CHIUSO dal 23/09 19:35: se si riapre, le 15 sedie ripartono
#  dai .chr del profilo ORO. Questo script toglie il blocco <expert>...</expert>
#  dai .chr di quelle 15 sedie, cosi' i grafici si riaprono SENZA EA.
#
#  COME SCEGLIE I FILE: per CONTENUTO (nome EA, simbolo, magic letti dentro il
#  .chr), mai per nome di file. In piu' la SPAZZATA (classe 788): ogni altro
#  .chr del profilo ORO con simbolo U30USD/D30EUR/NASUSD/225JPY e un EA sopra
#  viene ELENCATO; si toglie solo con -AncheSpazzata (decide Claudio).
#
#  USO:
#    ... -File SOSPENDI_SEDIE_PICCOLO_CHR.ps1                 prova a secco
#    ... -File SOSPENDI_SEDIE_PICCOLO_CHR.ps1 -Esegui         scrive
#    ... -Esegui -AncheSpazzata                               scrive anche la spazzata
#    ... -Annulla <cartella BACKUP_PROFILO_ORO_...>           rimette gli originali
#
#  PROVA SU CARTELLA FINTA (solo per il banco di Claude, mai sul VPS):
#    -ProvaRadice <dir>  : APPDATA e Desktop diventano <dir>\AppData e
#                          <dir>\Desktop; la guardia della macchina e'
#                          sostituita da un avviso; i processi terminal64 NON
#                          si leggono: si usano i percorsi di -ProvaTerminali
#                          (una stringa, percorsi separati da |).
#    Rifiutata se <dir> sta dentro il vero %APPDATA%.
#
#  L'esito (tabella + STATO) va sul Desktop: esito_sospendi_piccolo_<ts>.txt
#  La riga di lancio legge la riga "STATO:" del file, non il codice d'uscita
#  (classe 154).
#  ASCII puro (regola delle righe di lancio, 17/08).
# =====================================================================
param(
  [switch]$Esegui,
  [switch]$AncheSpazzata,
  [string]$Annulla = "",
  [string]$ProvaRadice = "",
  [string]$ProvaTerminali = ""
)

$ErrorActionPreference = 'Stop'
trap { Write-Host ("ERRORE IMPREVISTO: " + $_.Exception.Message) -ForegroundColor Red; try { Dillo ("ERRORE IMPREVISTO: " + $_.Exception.Message) 'Red'; Scrivi-Esito "ERRORE_IMPREVISTO" } catch {}; exit 4 }
$INV = [Globalization.CultureInfo]::InvariantCulture
$TS  = (Get-Date).ToString('yyyyMMdd_HHmmss_fff', $INV)

$MACCHINA    = 'VMI3047753'
$PROGRAMMA   = 'C:\Program Files\BCM Markets MT5 Terminal'
$HASHDATI    = '215D85D767A1C39E22D242C8114BF9F5'
$PROFILO     = 'ORO'
$SIMB_INDICI = @('U30USD','D30EUR','NASUSD','225JPY')
# v2 (cancello 25/09, classe 180 sui processi): i terminal64 vivi ammessi si
# ELENCANO per cartella. Un terminal64 in una cartella che non e' qui (anche il
# piccolo lanciato da un percorso scritto diverso, es. 8.3 C:\PROGRA~1\...) = FERMO.
$ALTRI_NOTI = @('C:\FTMO','C:\BCM_Reale','C:\Program Files\BCM Markets MT5 Terminal -V3','C:\MT5_MANUALE','C:\MT5_Backtest','C:\Program Files\Pepperstone MetaTrader 5','C:\Program Files\Tickmill Europe MT5 Terminal')

# --- LE 15 SEDIE (report/SOSPENSIONE_SEDIE_DEMO_2026-09-25.md par. 1).
#     c = campo del magic dentro <inputs> dell'EA; tf e chr = foto CODA_01
#     del 25/09 03:30 (profilo salvato 23/09 19:35), SOLO informativi.
$TABELLA = @(
  @{n=1;  ea='ABTG_PTE';                               s='U30USD'; m='771321'; c='InpMagic';       tf='H1';  chr='chart02.chr'},
  @{n=2;  ea='ABTG_GapFill';                           s='U30USD'; m='772234'; c='InpMagic';       tf='H1';  chr='chart09.chr'},
  @{n=3;  ea='ABTG_GapFill';                           s='225JPY'; m='772235'; c='InpMagic';       tf='H1';  chr='chart10.chr'},
  @{n=4;  ea='ABTG_PunteLarry';                        s='U30USD'; m='772341'; c='InpMagic';       tf='H1';  chr='chart11.chr'},
  @{n=5;  ea='ABTG_GapContinuation';                   s='225JPY'; m='774101'; c='InpMagicNumber'; tf='M1';  chr='chart23.chr'},
  @{n=6;  ea='ABTG_SuperWave';                         s='U30USD'; m='770531'; c='InpMagic';       tf='H4';  chr='chart27.chr'},
  @{n=7;  ea='ABTG_DAX_Apertura_EU';                   s='D30EUR'; m='770101'; c='InpMagic';       tf='M5';  chr='chart30.chr'},
  @{n=8;  ea='ABTG_Dow_Apertura_US';                   s='U30USD'; m='770202'; c='InpMagic';       tf='M5';  chr='chart31.chr'},
  @{n=9;  ea='ABTG_MaxMinNotte_DAX_Short_Ottimizzato'; s='D30EUR'; m='770411'; c='InpMagic';       tf='M15'; chr='chart32.chr'},
  @{n=10; ea='ABTG_SupertrendReversal';                s='225JPY'; m='770924'; c='InpMagic';       tf='H2';  chr='chart35.chr'},
  @{n=11; ea='ABTG_SuperWave_DOW_H1_Ottimizzato';      s='U30USD'; m='770511'; c='InpMagic';       tf='H1';  chr='chart37.chr'},
  @{n=12; ea='ABTG_SupRev_DAX_H4_Ottimizzato';         s='D30EUR'; m='970912'; c='InpMagic';       tf='H4';  chr='chart38.chr'},
  @{n=13; ea='ABTG_SupRev_NAS_H1_Ottimizzato';         s='NASUSD'; m='970913'; c='InpMagic';       tf='H1';  chr='chart39.chr'},
  @{n=14; ea='ABTG_ORB_Ottimizzato';                   s='U30USD'; m='770611'; c='InpMagic';       tf='M5';  chr='chart40.chr'},
  @{n=15; ea='ABTG_Nasdaq_Apertura_US';                s='NASUSD'; m='770250'; c='InpMagic';       tf='M15'; chr='chart41.chr'}
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
    $f = Join-Path $script:DESK ("esito_sospendi_piccolo_" + $TS + ".txt")
    [IO.File]::WriteAllLines($f, [string[]]$script:RIGHE.ToArray(), (New-Object Text.UTF8Encoding($false)))
    Write-Host ("esito scritto in: " + $f) -ForegroundColor Green
  } catch { Write-Host ("ESITO NON SCRITTO SUL DESKTOP: " + $_.Exception.Message) -ForegroundColor Red }
}
function Ferma([string]$perche, [switch]$GiaScritto){
  Dillo "" $null
  if($GiaScritto){
    Dillo ("FERMO DOPO LA SCRITTURA: i .chr SONO GIA' STATI SCRITTI (backup sul Desktop, BACKUP_PROFILO_ORO_" + $TS + "). " + $perche) 'Red'
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
      if(-not $x){ Ferma ("terminal64 PID " + $p.Id + " ha il percorso NON LEGGIBILE (" + $quando + "): potrebbe essere il piccolo. Senza sapere chi e', non si tocca niente.") -GiaScritto:$GiaScritto }
      $percorsi += $x
    }
    Dillo ("    processi terminal64 vivi (" + $quando + "): " + $percorsi.Count) $null
  }
  foreach($x in $percorsi){
    $d = Percorso-Dir $x
    $ePiccolo = ($d -ieq $PROGRAMMA)
    $eNoto = ($ALTRI_NOTI -icontains $d)
    $tag = "SCONOSCIUTO"; if($ePiccolo){ $tag = "IL PICCOLO 50503392" } elseif($eNoto){ $tag = "altro terminale noto, NON toccato" }
    Dillo ("      " + $x + "   -> " + $tag) $null
    if($ePiccolo){ Ferma ("il terminale del piccolo 50503392 (" + $PROGRAMMA + ") e' APERTO (" + $quando + "). Alla chiusura riscriverebbe i .chr e rimetterebbe le sedie. Chiudilo A MANO (File -> Esci, dopo aver fatto la foto dei grafici) e rilancia.") -GiaScritto:$GiaScritto }
    if(-not $eNoto){ Ferma ("terminal64 in una cartella NON in elenco (" + $d + ", " + $quando + "): potrebbe essere il piccolo lanciato da un altro percorso. Senza sapere chi e', non si tocca niente.") -GiaScritto:$GiaScritto }
  }
}

# ---------------------------------------------------------------- avvio
Dillo "=== SOSPENDI SEDIE INDICE DEL PICCOLO 50503392 NEI .chr DEL PROFILO ORO -- MARCATORE_SOSPENDI_PICCOLO_CHR_v2 ===" 'Cyan'
Dillo ("ora locale di questa macchina: " + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $INV) + "   macchina " + $env:COMPUTERNAME + "   utente " + $env:USERNAME) $null
Dillo ("BERSAGLIO: VPS " + $MACCHINA + ", SOLO la cartella dati " + $HASHDATI + " del piccolo 50503392 (" + $PROGRAMMA + ", SENZA -V3), profilo " + $PROFILO + ", a terminale CHIUSO.") 'Green'
Dillo "NON TOCCATI: FTMO 541452707 (C:\FTMO), REALE 10105439 (C:\BCM_Reale), 100k 50504263 (BCM Markets MT5 Terminal -V3), manuale 50503635 (C:\MT5_MANUALE), banco 50504400 (C:\MT5_Backtest), Pepperstone, Tickmill. Nessun processo chiuso o aperto." 'Green'

$modo = "PROVA A SECCO (non scrive niente)"
if($Annulla){ $modo = "ANNULLA (rimette i .chr dal backup)" } elseif($Esegui){ $modo = "ESEGUI (scrive)" }
if($AncheSpazzata -and -not $Esegui){ Dillo "    nota: -AncheSpazzata senza -Esegui: la spazzata viene solo ELENCATA." 'Yellow' }
Dillo ("MODO: " + $modo + "   spazzata: " + $(if($AncheSpazzata){"SI, si toglie anche lei"}else{"solo elencata"})) 'Yellow'

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
  if($env:COMPUTERNAME -ne $MACCHINA){ Ferma ("questa macchina si chiama " + $env:COMPUTERNAME + ", non " + $MACCHINA + " (il VPS). Sul PC di backtest il piccolo e' un'ALTRA installazione.") }
  $APPD = $env:APPDATA
  if(-not $APPD){ Ferma "APPDATA vuota." }
}

# (b) il terminale del piccolo deve essere CHIUSO
Dillo "--- GUARDIA (b): terminale del piccolo chiuso?" $null
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

# (d) profilo attivo = ORO
$INI = Join-Path (Join-Path $DATI 'config') 'common.ini'
Dillo "--- GUARDIA (d): profilo attivo in config\common.ini" $null
if(-not (Test-Path -LiteralPath $INI)){ Ferma "config\common.ini assente." }
$ci = ""
try { $ci = (Leggi-Chr $INI).Testo } catch { Ferma ("common.ini illeggibile: " + $_.Exception.Message) }
$pm = [regex]::Matches($ci, "(?im)^[ \t]*ProfileLast[ \t]*=[ \t]*(.*?)[ \t]*$")
if($pm.Count -ne 1){ Ferma ("in common.ini le righe ProfileLast sono " + $pm.Count + ", attesa 1.") }
$pa = $pm[0].Groups[1].Value.Trim()
Dillo ("    ProfileLast=" + $pa) $null
if($pa -ne $PROFILO){ Ferma ("il profilo attivo e' '" + $pa + "', non '" + $PROFILO + "'. Se si riapre con un altro profilo le 15 sedie ORO non sono quelle che partono: da rivedere prima di toccare.") }
$PDIR = Join-Path (Join-Path (Join-Path (Join-Path $DATI 'MQL5') 'Profiles') 'Charts') $PROFILO
if(-not (Test-Path -LiteralPath $PDIR -PathType Container)){ Ferma ("cartella del profilo assente: " + $PDIR) }
$PDIR = (Get-Item -LiteralPath $PDIR).FullName.TrimEnd('\','/')
Dillo ("    cartella profilo: " + $PDIR) $null

# ---------------------------------------------------------------- backup
function Fai-Backup([string]$etichetta){
  $dst = Join-Path $script:DESK ("BACKUP_PROFILO_ORO_" + $TS + $etichetta)
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
  Dillo ("--- ANNULLA da: " + $Annulla) $null
  if(-not (Test-Path -LiteralPath $Annulla -PathType Container)){ Ferma "la cartella di backup indicata non esiste." }
  if((Split-Path -Leaf $Annulla) -notlike 'BACKUP_PROFILO_ORO_*'){ Ferma "la cartella indicata non e' un BACKUP_PROFILO_ORO_*." }
  $fb = @(Get-ChildItem -LiteralPath $Annulla -Filter 'chart*.chr' -File)
  if($fb.Count -eq 0){ Ferma "nel backup non ci sono chart*.chr." }
  $prima = Fai-Backup "_PRIMA_DI_ANNULLA"
  $okA = 0; $koA = 0
  Guardia-Processi "subito prima di rimettere"
  foreach($f in $fb){
    $dst = Join-Path $PDIR $f.Name
    $cambia = $true
    if(Test-Path -LiteralPath $dst){ $cambia = ((Get-FileHash -LiteralPath $dst -Algorithm SHA256).Hash -ne (Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash) }
    if(-not $cambia){ continue }
    [IO.File]::WriteAllBytes($dst, [IO.File]::ReadAllBytes($f.FullName))
    if((Get-FileHash -LiteralPath $dst -Algorithm SHA256).Hash -eq (Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash){ $okA++; Dillo ("    RIMESSO " + $f.Name) 'Green' } else { $koA++; Dillo ("    ERRORE nel rimettere " + $f.Name) 'Red' }
  }
  $extra = @(Get-ChildItem -LiteralPath $PDIR -Filter 'chart*.chr' -File | Where-Object { -not (Test-Path -LiteralPath (Join-Path $Annulla $_.Name)) })
  foreach($e in $extra){ Dillo ("    nel profilo c'e' " + $e.Name + " che nel backup NON c'e': lasciato com'e'") 'Yellow' }
  Dillo ("    rimessi: " + $okA + "   errori: " + $koA + "   (stato di prima salvato in " + $prima + ")") $null
  if($koA -gt 0){ Scrivi-Esito "ANNULLA_CON_ERRORI"; exit 3 }
  Scrivi-Esito "ANNULLATO_OK"; exit 0
}

# ---------------------------------------------------------------- lettura
$files = @(Get-ChildItem -LiteralPath $PDIR -Filter 'chart*.chr' -File | Sort-Object Name)
Dillo ("--- LETTURA: " + $files.Count + " file chart*.chr nel profilo " + $PROFILO + " (ultima modifica piu' recente: " + $(if($files.Count){ ($files | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime.ToString('yyyy-MM-dd HH:mm', $INV) } else {"-"}) + ")") $null
$ana = @()
foreach($f in $files){ $ana += (Analizza $f) }

$fmt = "{0,-12} {1,-8} {2,-4} {3,-40} {4,-24} {5}"
Dillo "" $null
Dillo ($fmt -f "grafico","simbolo","TF","EA","magic","AZIONE") 'White'
foreach($r in $ana){
  $az = $r.Azione
  if($az -eq "SOSPENDI"){ $az = "SOSPENDI (riga " + $r.Riga.n + ")" }
  if($az -eq "SPAZZATA"){ if($AncheSpazzata){ $az = "SPAZZATA: si toglie" } else { $az = "SPAZZATA: SOLO ELENCATO, decide Claudio" } }
  if($r.Nota){ $az = $az + " -- " + $r.Nota }
  $col = $null
  if($r.Azione -eq "SOSPENDI"){ $col = 'Yellow' } elseif($r.Azione -eq "SPAZZATA"){ $col = 'Magenta' } elseif($r.Azione -eq "ANOMALO" -or $r.Azione -eq "ILLEGGIBILE"){ $col = 'Red' }
  Dillo ($fmt -f $r.Chr, $r.Simbolo, $r.TF, $r.EA, $r.Magic, $az) $col
}

# confronto con l'elenco atteso dei 15
Dillo "" $null
Dillo "--- ELENCO ATTESO (15, report par. 1) contro TROVATI per contenuto" 'White'
$mancano = 0; $doppi = 0
foreach($x in $TABELLA){
  $tr = @($ana | Where-Object { $_.Riga -and $_.Riga.n -eq $x.n })
  $dove = "NON TROVATO"
  if($tr.Count -ge 1){ $dove = (($tr | ForEach-Object { $_.Chr }) -join ", ") }
  if($tr.Count -eq 0){ $mancano++ }
  if($tr.Count -gt 1){ $doppi++ }
  $nota = ""; if($tr.Count -eq 1 -and $tr[0].Chr -ne $x.chr){ $nota = "   (nella foto del 23/09 era " + $x.chr + ")" }
  $col = 'Green'; if($tr.Count -ne 1){ $col = 'Yellow' }
  Dillo (("{0,2}. {1,-40} {2,-7} magic {3,-7} {4,-4} -> {5}{6}" -f $x.n, $x.ea, $x.s, $x.m, $x.tf, $dove, $nota)) $col
}
$nSosp = @($ana | Where-Object { $_.Azione -eq "SOSPENDI" }).Count
$nSpaz = @($ana | Where-Object { $_.Azione -eq "SPAZZATA" }).Count
$nAnom = @($ana | Where-Object { $_.Azione -eq "ANOMALO" -or $_.Azione -eq "ILLEGGIBILE" }).Count
$nResta = @($ana | Where-Object { $_.Azione -eq "RESTA" }).Count
Dillo ("TROVATE da sospendere: " + $nSosp + " su 15 attese   non trovate: " + $mancano + "   trovate piu' volte: " + $doppi) 'White'
Dillo ("SPAZZATA (indice con EA, fuori tabella): " + $nSpaz + "   anomali/illeggibili: " + $nAnom + "   restano (forex/oro/servizio): " + $nResta) 'White'
$anomIndice = @($ana | Where-Object { ($_.Azione -eq "ANOMALO" -or $_.Azione -eq "ILLEGGIBILE") })
foreach($r in $anomIndice){ Dillo ("    ANOMALO " + $r.Chr + " (" + $r.Simbolo + "): va guardato a mano, questo script non lo tocca.") 'Red' }

$bersagli = @($ana | Where-Object { $_.Azione -eq "SOSPENDI" -or ($AncheSpazzata -and $_.Azione -eq "SPAZZATA") })

if(-not $Esegui){
  Dillo "" $null
  Dillo ("PROVA A SECCO: niente e' stato scritto. Con -Esegui si toglierebbe <expert> da " + $bersagli.Count + " file.") 'Yellow'
  if($mancano -gt 0 -or $doppi -gt 0 -or $nAnom -gt 0){ Scrivi-Esito "SECCO_DA_GUARDARE (non trovate/doppie/anomale: leggi la tabella)" } else { Scrivi-Esito "SECCO_OK" }
  exit 0
}
if($bersagli.Count -eq 0){ Dillo "niente da togliere." 'Green'; Scrivi-Esito "ESEGUITO_NIENTE_DA_FARE"; exit 0 }

# ---------------------------------------------------------------- scrittura
Dillo "" $null
Dillo "--- BACKUP dell'INTERA cartella del profilo ORO" $null
$BK = Fai-Backup ""
# prima di scrivere: il testo decodificato deve tornare IDENTICO ai byte
# originali (round-trip), altrimenti riscrivere cambierebbe anche il resto.
Guardia-Processi "subito prima di scrivere"
$ok = 0; $ko = 0
foreach($r in $bersagli){
  $L = $r.Letto; $bl = $r.Blocco
  $orig = Componi $L.Bom $L.Enc $L.Testo
  if(-not (Byte-Uguali $orig $L.Byte)){ $ko++; Dillo ("    NON TOCCATO " + $r.Chr + ": la codifica " + $L.NomeEnc + " non torna identica ai byte originali.") 'Red'; continue }
  $nuovo = $L.Testo.Substring(0, $bl.Index) + $L.Testo.Substring($bl.Index + $bl.Length)
  $nb = Componi $L.Bom $L.Enc $nuovo
  $lenBlocco = $L.Enc.GetByteCount($bl.Value)
  try {
    [IO.File]::WriteAllBytes($r.File.FullName, $nb)
    $rb = [IO.File]::ReadAllBytes($r.File.FullName)
    $R2 = Leggi-Chr $r.File.FullName
    $prefOk = $R2.Testo.StartsWith($L.Testo.Substring(0, $bl.Index), [StringComparison]::Ordinal)
    $sufOk  = $R2.Testo.EndsWith($L.Testo.Substring($bl.Index + $bl.Length), [StringComparison]::Ordinal)
    $verif = (Byte-Uguali $rb $nb) -and ($rb.Length -eq ($L.Byte.Length - $lenBlocco)) -and ($R2.Testo -notmatch '<expert>') -and ($R2.Testo -notmatch '</expert>') -and $prefOk -and $sufOk
    if($verif){
      $ok++
      Dillo ("    TOLTO <expert> da " + $r.Chr + " (" + $r.Simbolo + " " + $r.EA + " " + $r.Magic + ")   byte " + $L.Byte.Length + " -> " + $rb.Length + " (blocco " + $lenBlocco + ", " + $L.NomeEnc + ")") 'Green'
    } else {
      $ko++
      [IO.File]::WriteAllBytes($r.File.FullName, $L.Byte)
      Dillo ("    VERIFICA FALLITA su " + $r.Chr + ": RIMESSO l'originale.") 'Red'
    }
  } catch {
    $ko++
    try { [IO.File]::WriteAllBytes($r.File.FullName, $L.Byte) } catch {}
    Dillo ("    ERRORE su " + $r.Chr + ": " + $_.Exception.Message + " -- rimesso l'originale.") 'Red'
  }
}
Guardia-Processi "dopo la scrittura" -GiaScritto

# rilettura finale per contenuto: nessuna delle 15 deve avere ancora l'EA
$dopo = @()
foreach($f in @(Get-ChildItem -LiteralPath $PDIR -Filter 'chart*.chr' -File | Sort-Object Name)){ $dopo += (Analizza $f) }
$ancora = @($dopo | Where-Object { $_.Azione -eq "SOSPENDI" })
$spazRim = @($dopo | Where-Object { $_.Azione -eq "SPAZZATA" })
Dillo "" $null
Dillo ("--- RILETTURA: sedie della tabella ancora con EA: " + $ancora.Count + "   spazzata ancora con EA: " + $spazRim.Count + "   file tolti: " + $ok + "   errori: " + $ko) 'White'
foreach($r in $ancora){ Dillo ("    ANCORA ATTACCATA: " + $r.Chr + " " + $r.EA + " " + $r.Simbolo) 'Red' }
foreach($r in $spazRim){ Dillo ("    SPAZZATA ancora con EA (decide Claudio): " + $r.Chr + " " + $r.EA + " " + $r.Simbolo + " " + $r.Magic) 'Magenta' }
Dillo ("BACKUP: " + $BK + "   -> per tornare indietro: -Annulla '" + $BK + "'") 'Cyan'
Dillo "ATTENZIONE: gli ORDINI PENDENTI gia' sul server NON sono toccati da questo script. Alla riapertura del piccolo 50503392 guarda la scheda Trade." 'Yellow'
if($ko -gt 0 -or $ancora.Count -gt 0){ Scrivi-Esito "ESEGUITO_CON_ERRORI"; exit 3 }
if($mancano -gt 0 -or $doppi -gt 0 -or $nAnom -gt 0){ Scrivi-Esito "ESEGUITO_DA_GUARDARE (non trovate/doppie/anomale: leggi la tabella)"; exit 0 }
Scrivi-Esito "ESEGUITO_OK"
exit 0
