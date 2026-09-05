# =====================================================================
#  MARCATORE_RIGA_SPREADLOGGER_RACCOLTA_v1
#  RIGA_SPREADLOGGER_RACCOLTA.ps1 -- RACCOGLIE e LEGGE i dati accumulati
#  da ABTG_SpreadLogger sul terminale del conto PICCOLO 50503392.
#
#  COSA FA, in una riga: COPIA i tre file che l'EA ha scritto in
#  MQL5\Files, RICALCOLA da solo mediana e P95 per simbolo e per ora
#  dall'istogramma grezzo, CONFRONTA il proprio conto con quello
#  dell'EA, e ne fa un referto leggibile piu' uno zip sul Desktop.
#
#  >>> NON TOCCA NIENTE. Legge dalla cartella dati del terminale e
#      scrive SOLO nella propria cartella di lavoro e sul Desktop.
#      Nessuna scrittura dentro MetaQuotes\Terminal, nessuna
#      compilazione, nessun processo fermato: MT5 puo' (e deve) restare
#      APERTO e la flotta continua a lavorare. Si puo' lanciare tutte le
#      volte che si vuole, anche a meta' raccolta: l'EA continua ad
#      accumulare per conto suo.
#
#  >>> PERCHE' RICALCOLA invece di fidarsi del referto dell'EA: perche'
#      un numero prodotto da un solo pezzo di codice non ha nessuno che
#      lo contraddica. Qui il conto si fa DUE VOLTE con due attrezzi
#      diversi (MQL5 e PowerShell) sullo stesso istogramma grezzo, e se
#      i due non coincidono il referto lo dice invece di scegliere.
#
#  >>> LE FASCE SI CALCOLANO SOMMANDO GLI ISTOGRAMMI, non facendo la
#      media dei percentili delle singole ore: la media di sei P95 non
#      e' il P95 di niente.
#
#  >>> LE ORE SONO IN ORA SERVER (come le scrive l'EA, TimeCurrent).
#      L'orologio di Windows del VPS e' in ora ITALIANA, cioe' un'ora
#      AVANTI. Il referto lo ripete accanto a ogni confronto di orari,
#      perche' e' l'errore che in questo progetto e' gia' costato due
#      diagnosi sbagliate.
#
#  QUANTO CI METTE [STIMA]: pochi secondi.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_SPREADLOGGER_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  [string]$Pin = "",
  [string]$CartellaDati = "",
  [string]$Prefisso = "ABTG_SpreadLogger",
  # quante GIORNATE distinte servono in un secchio orario perche' quel
  # numero si possa citare in un round. Non e' una legge: e' la soglia
  # che il referto usa per marcare le righe SOTTILI.
  [int]$MinGiorni = 5
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
$INV = [Globalization.CultureInfo]::InvariantCulture

$CONTO_PICCOLO = "50503392"
$CONTO_GRANDE  = "50504263"
$BASE_BCM      = "BCMMarkets-Server"
$MAXBIN        = 10001

$Avvio = Get-Date
$Stamp = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
function TrovaDesktop(){
  foreach($p in @([Environment]::GetFolderPath("Desktop"),
                  (Join-Path $env:USERPROFILE "Desktop"),
                  (Join-Path $env:USERPROFILE "OneDrive\Desktop"))){
    if($p -and (Test-Path -LiteralPath $p)){ return $p }
  }
  return $env:USERPROFILE
}
$Dsk  = TrovaDesktop
$Work = Join-Path $env:USERPROFILE "abtg_spreadlogger_raccolta"

# --- stato della raccolta: tutto nasce PRIMA del try (classe 125)
$Problemi = New-Object System.Collections.ArrayList
$Rilievi  = New-Object System.Collections.ArrayList
$Cand     = New-Object System.Collections.ArrayList
$righeC   = New-Object System.Collections.ArrayList
[void]$righeC.Add("CARTELLE GUARDATE: nessuna scansione")
$Fatale   = ""
$Scelta   = "NON SCELTA"
$Criterio = "n/d"
$Copiati  = New-Object System.Collections.ArrayList
$Righe    = New-Object System.Collections.ArrayList
$Meta     = @{}
$Sym      = @{}
$Ore      = @{}
$Bin      = @{}
$Confronto= "NON ESEGUITO"
$Coperta  = "NON MISURATA"

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$t,[string]$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo([string]$t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }
function Hash16([string]$path){
  try{ return (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.Substring(0,16) }catch{ return "n/d" }
}
function Descrivi([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return "ASSENTE" }
  $i = Get-Item -LiteralPath $path
  return ("" + $i.Length + " byte, sha256 " + (Hash16 $path) + ", " + $i.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV))
}
function LeggiTesto([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return @() }
  $b = [System.IO.File]::ReadAllBytes($path)
  if($b.Length -eq 0){ return @() }
  $txt = ""
  if($b.Length -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254){ $txt = [System.Text.Encoding]::Unicode.GetString($b,2,$b.Length-2) }
  elseif($b.Length -ge 3 -and $b[0] -eq 239 -and $b[1] -eq 187 -and $b[2] -eq 191){ $txt = [System.Text.Encoding]::UTF8.GetString($b,3,$b.Length-3) }
  else{ $txt = [System.Text.Encoding]::UTF8.GetString($b) }
  return @($txt -split "`r`n|`n|`r")
}
function AggiungiCandidata([string]$percorso,[string]$origine){
  if([string]::IsNullOrEmpty($percorso)){ return }
  $full = $percorso
  try{
    if(-not (Test-Path -LiteralPath $percorso)){ return }
    $full = (Get-Item -LiteralPath $percorso -ErrorAction Stop).FullName
  }catch{ return }
  $full = $full.TrimEnd("\")
  foreach($c in $Cand){ if($c.Percorso -ieq $full){ $c.Origine = $c.Origine + " + " + $origine; return } }
  $mq = (Test-Path -LiteralPath (Join-Path $full "MQL5"))
  $lg = (Test-Path -LiteralPath (Join-Path $full "logs"))
  if(-not $mq -and -not $lg){ return }
  [void]$Cand.Add([pscustomobject]@{
    Percorso=$full; Origine=$origine; HaMql=$mq; Origin=""; BaseBcm=$false
    VistoPiccolo=$false; VistoGrande=$false; TracciaV3=""; Eleggibile=$false
    Profilo=$false; Scarto=""; HaStato=$false
  })
}
# PERCENTILE da una tabella secchio->conteggio, con lo stesso metodo
# dell'EA: il totale comprende i campioni oltre il tetto.
function Percentile([hashtable]$bins,[long]$totale,[double]$frac){
  if($totale -le 0){ return [pscustomobject]@{ Bin=-1; Over=$false } }
  $soglia = $frac * [double]$totale
  $cum = 0.0
  foreach($b in ($bins.Keys | Sort-Object)){
    $cum = $cum + [double]$bins[$b]
    if($cum -ge $soglia){ return [pscustomobject]@{ Bin=[long]$b; Over=$false } }
  }
  return [pscustomobject]@{ Bin=[long]$MAXBIN; Over=$true }
}
function Mostra($p,[double]$ppu,[int]$dec){
  if($null -eq $p){ return "n/d" }
  if($p.Bin -lt 0){ return "n/d" }
  if($p.Over){ return ">" + ($MAXBIN-1) }
  return ([double]$p.Bin / $ppu).ToString("F" + $dec, $INV)
}
function Pad([string]$s,[int]$n){ while($s.Length -lt $n){ $s = " " + $s }; return $s }

try{
  Titolo ("RACCOLTA DEI DATI DI " + $Prefisso + " dal piccolo " + $CONTO_PICCOLO)
  Write-Host "Questa riga NON scrive niente dentro il terminale: MT5 puo' restare aperto." -ForegroundColor Yellow
  if($Pin -ne "" -and $Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin, se lo passi, deve essere un commit di 40 caratteri esadecimali; ricevuto: " + $Pin) }
  New-Item -ItemType Directory -Force -Path $Work | Out-Null

  # -------------------------------------------------------------------
  #  1. LA CARTELLA DATI -- stessa scelta per FATTI della riga gemella
  # -------------------------------------------------------------------
  Titolo "1. CARTELLA DATI DEL PICCOLO (scansione LARGA, scelta STRETTA)"
  foreach($pr in @(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)){
    $exe = ""
    try{ $exe = $pr.Path }catch{ $exe = "" }
    if($exe){ AggiungiCandidata (Split-Path -Parent $exe) ("processo terminal64 pid " + $pr.Id) }
  }
  $radici = New-Object System.Collections.ArrayList
  if($env:APPDATA){ [void]$radici.Add((Join-Path $env:APPDATA "MetaQuotes\Terminal")) }
  $drive = $env:SystemDrive
  if(-not $drive){ $drive = "C:" }
  try{
    foreach($u in @(Get-ChildItem -LiteralPath (Join-Path $drive "Users") -Directory -ErrorAction SilentlyContinue)){
      [void]$radici.Add((Join-Path $u.FullName "AppData\Roaming\MetaQuotes\Terminal"))
    }
  }catch{}
  foreach($rt in $radici){
    if(-not (Test-Path -LiteralPath $rt)){ continue }
    foreach($d in @(Get-ChildItem -LiteralPath $rt -Directory -ErrorAction SilentlyContinue)){
      if($d.Name -ieq "Common"){ continue }
      AggiungiCandidata $d.FullName ("cartella dati sotto " + $rt)
    }
  }
  if($CartellaDati -ne ""){ AggiungiCandidata $CartellaDati "IMPOSTA A MANO con -CartellaDati" }

  $limite = (Get-Date).AddDays(-45)
  foreach($c in $Cand){
    $o = Join-Path $c.Percorso "origin.txt"
    if(Test-Path -LiteralPath $o){ try{ $c.Origin = ([string](Get-Content -LiteralPath $o -Raw -ErrorAction Stop)).Trim() }catch{} }
    $c.BaseBcm  = (Test-Path -LiteralPath (Join-Path $c.Percorso ("bases\" + $BASE_BCM)))
    $c.HaStato  = (Test-Path -LiteralPath (Join-Path $c.Percorso ("MQL5\Files\" + $Prefisso + "_stato.csv")))
    foreach($sub in @("logs","MQL5\Logs")){
      $dir = Join-Path $c.Percorso $sub
      if(-not (Test-Path -LiteralPath $dir)){ continue }
      $files = @()
      try{
        $files = @(Get-ChildItem -LiteralPath $dir -Filter "*.log" -File -ErrorAction Stop |
                   Where-Object { $_.LastWriteTime -ge $limite -and $_.Length -lt 60000000 } |
                   Sort-Object LastWriteTime -Descending | Select-Object -First 8)
      }catch{}
      foreach($f in $files){
        $txt = ((LeggiTesto $f.FullName) -join "`n")
        if($txt.IndexOf("'" + $CONTO_PICCOLO + "'") -ge 0){ $c.VistoPiccolo = $true }
        if($txt.IndexOf("'" + $CONTO_GRANDE + "'") -ge 0){ $c.VistoGrande = $true }
      }
    }
    $tr = New-Object System.Collections.ArrayList
    if($c.Origin -like "*-V3*"){ [void]$tr.Add("origin.txt contiene -V3") }
    if($c.Percorso -like "*-V3*"){ [void]$tr.Add("percorso contiene -V3") }
    if($c.VistoGrande){ [void]$tr.Add("login " + $CONTO_GRANDE + " nei log") }
    $c.TracciaV3 = (@($tr) -join "; ")
    if($env:APPDATA){ $c.Profilo = $c.Percorso.StartsWith(($env:APPDATA.TrimEnd("\")), [System.StringComparison]::OrdinalIgnoreCase) }
    if(-not $c.HaMql){ $c.Scarto = "nessuna cartella MQL5\"; continue }
    if(-not $c.BaseBcm){ $c.Scarto = "nessuna bases\" + $BASE_BCM; continue }
    if($c.TracciaV3 -ne ""){ $c.Scarto = "E' IL 100k/-V3 (" + $c.TracciaV3 + "): fuori dal perimetro"; continue }
    $c.Eleggibile = $true
    if(-not $c.Profilo){ $c.Scarto = "eleggibile per i fatti, ma sotto un ALTRO profilo utente (sessione " + $env:USERNAME + ")" }
  }
  $righeC.Clear()
  [void]$righeC.Add("CARTELLE GUARDATE (candidate " + $Cand.Count + "):")
  foreach($c in $Cand){
    $tag = "scartata"
    if($c.Eleggibile -and $c.Profilo){ $tag = "ELEGGIBILE" }
    elseif($c.Eleggibile){ $tag = "eleggibile ma sotto un ALTRO profilo" }
    [void]$righeC.Add("  --- " + $c.Percorso + "   [" + $tag + "]   file di stato del logger presente=" + $c.HaStato)
    [void]$righeC.Add("      trovata come: " + $c.Origine + "   origin.txt: " + $c.Origin)
    [void]$righeC.Add("      bases BCM=" + $c.BaseBcm + "   piccolo=" + $c.VistoPiccolo + "   grande=" + $c.VistoGrande)
    if($c.Scarto -ne ""){ [void]$righeC.Add("      nota: " + $c.Scarto) }
  }
  foreach($r in $righeC){ Write-Host ("  " + $r) -ForegroundColor Gray }

  $eleg = @($Cand | Where-Object { $_.Eleggibile })
  $auto = @($eleg | Where-Object { $_.Profilo })
  # fra le eleggibili, se una sola HA il file di stato, e' quella: il
  # dato che cerchiamo e' un FATTO piu' forte del profilo.
  $conStato = @($auto | Where-Object { $_.HaStato })
  $scelto = $null
  if($CartellaDati -ne ""){
    $imp = @($Cand | Where-Object { $_.Origine -like "*IMPOSTA A MANO*" })
    if($imp.Count -eq 0){ throw ("-CartellaDati '" + $CartellaDati + "' non esiste o non sembra una cartella dati MT5.") }
    if(-not $imp[0].Eleggibile){ throw ("-CartellaDati '" + $CartellaDati + "' NON passa i gate: " + $imp[0].Scarto) }
    $scelto = $imp[0]; $Criterio = "IMPOSTA A MANO con -CartellaDati (gate passati)"
  }
  elseif($conStato.Count -eq 1){ $scelto = $conStato[0]; $Criterio = "FATTO: unica cartella eleggibile sotto questo profilo che contiene gia' il file di stato del logger" }
  elseif($auto.Count -eq 1){ $scelto = $auto[0]; $Criterio = "FATTO: unica cartella dati eleggibile sotto il profilo di questa sessione (nessun file di stato trovato: la raccolta dira' che non c'e' niente da leggere)" }
  else{
    throw ("NON SO DA QUALE CARTELLA DATI RACCOGLIERE (eleggibili sotto questo profilo " + $auto.Count + ", con file di stato " + $conStato.Count + "). L'elenco e' qui sopra. Rilancia aggiungendo al driver: -CartellaDati ""<percorso>"".")
  }
  $Scelta = $scelto.Percorso
  Dico ("cartella dati: " + $Scelta) "Yellow"
  Dico ("criterio ....: " + $Criterio) "Yellow"

  # -------------------------------------------------------------------
  #  2. COPIA DEI FILE (sola lettura dal terminale)
  # -------------------------------------------------------------------
  Titolo "2. COPIA DEI FILE DEL LOGGER (dal terminale NON si tocca niente)"
  $srcDir = Join-Path $Scelta "MQL5\Files"
  $nomi = @(($Prefisso + "_stato.csv"), ($Prefisso + "_orario.csv"), ($Prefisso + "_REFERTO.txt"), ($Prefisso + "_stato.tmp"))
  foreach($n in $nomi){
    $s = Join-Path $srcDir $n
    if(Test-Path -LiteralPath $s){
      $d = Join-Path $Work $n
      Copy-Item -LiteralPath $s -Destination $d -Force
      [void]$Copiati.Add($n + ": " + (Descrivi $s))
    }
    else{ [void]$Copiati.Add($n + ": ASSENTE nel terminale") }
  }
  $statoLoc = Join-Path $Work ($Prefisso + "_stato.csv")
  if(-not (Test-Path -LiteralPath $statoLoc)){
    throw ("NESSUN FILE DI STATO (" + (Join-Path $srcDir ($Prefisso + "_stato.csv")) + " non esiste). Le tre spiegazioni possibili, in ordine di probabilita': 1) l'EA non e' mai stato attaccato a un grafico, o e' stato attaccato su un ALTRO terminale; 2) e' attaccato da meno di InpSalvaSec secondi e non ha ancora salvato; 3) hai cambiato InpPrefissoFile e allora va passato -Prefisso.")
  }

  # -------------------------------------------------------------------
  #  3. LETTURA DELLO STATO GREZZO
  # -------------------------------------------------------------------
  Titolo "3. LETTURA DELLO STATO GREZZO E RICALCOLO"
  $tot = 0; $totScart = 0; $righeBin = 0; $righeOra = 0; $chiuso = $false
  foreach($riga in (LeggiTesto $statoLoc)){
    if($riga -eq ""){ continue }
    if($riga.StartsWith("#")){ continue }
    $p = $riga.Split(",")
    if($p[0] -eq "FINE"){ $chiuso = $true; continue }
    if($p[0] -eq "META" -and $p.Count -ge 3){ $Meta[$p[1]] = ($p[2..($p.Count-1)] -join ","); continue }
    if($p[0] -eq "SYM" -and $p.Count -ge 6){
      $Sym[$p[1]] = [pscustomobject]@{ Digits=[int]$p[2]; Point=[double]::Parse($p[3],$INV); Ppu=[double]::Parse($p[4],$INV); Stato=$p[5] }
      continue
    }
    if($p[0] -eq "ORA" -and $p.Count -ge 11){
      $k = $p[1] + "|" + $p[2]
      $Ore[$k] = [pscustomobject]@{
        Sym=$p[1]; H=[int]$p[2]; N=[long]$p[3]; Scart=[long]$p[4]; Over=[long]$p[5]
        Max=[long]$p[6]; Somma=[double]::Parse($p[7],$INV); Giorni=[long]$p[8]; DaInt=[long]$p[10]
      }
      $tot += [long]$p[3]; $totScart += [long]$p[4]; $righeOra++
      continue
    }
    if($p[0] -eq "BIN" -and $p.Count -ge 5){
      $k = $p[1] + "|" + $p[2]
      if(-not $Bin.ContainsKey($k)){ $Bin[$k] = @{} }
      $b = [int]$p[3]
      if($Bin[$k].ContainsKey($b)){ $Bin[$k][$b] = $Bin[$k][$b] + [long]$p[4] }
      else{ $Bin[$k][$b] = [long]$p[4] }
      $righeBin++
      continue
    }
  }
  if(-not $chiuso){ [void]$Rilievi.Add("il file di stato NON finisce con la riga FINE: la copia e' stata presa mentre l'EA stava scrivendo, oppure il file e' troncato. I numeri qui sotto valgono per la parte letta.") }
  Dico ("righe ORA " + $righeOra + ", righe BIN " + $righeBin + ", campioni validi " + $tot + ", scartati " + $totScart) "Green"
  if($tot -le 0){ throw "IL FILE DI STATO NON HA NEMMENO UN CAMPIONE VALIDO: l'EA e' attaccato ma non sta misurando (simboli sbagliati in InpSimboli, o mercato chiuso da quando e' partito). Guarda la scheda Esperti: le righe [SPREADLOG] dell'avvio dicono simbolo per simbolo se e' selezionabile." }

  # freschezza -- ORE: quelle del file sono ORA SERVER, l'orologio di
  # Windows e' ora ITALIANA (un'ora avanti). Si confronta con tolleranza
  # larga proprio per non fare finta di una precisione che non c'e'.
  $ultimo = "" + $Meta["ultimo_campione"]
  $frescoTxt = "ultimo campione (ora SERVER): " + $ultimo + "   -- l'orologio di questo PC segna " + $Avvio.ToString("yyyy.MM.dd HH:mm:ss",$INV) + " in ora LOCALE (= server + 1 in questo periodo)"
  try{
    $u = [datetime]::ParseExact($ultimo, "yyyy.MM.dd HH:mm:ss", $INV)
    $oreFa = ($Avvio - $u).TotalHours
    if($oreFa -gt 30){ [void]$Rilievi.Add("l'ultimo campione risale a " + [math]::Round($oreFa,1) + " ore fa (contando anche l'ora di scarto fra i due orologi): o l'EA e' stato staccato, o il mercato e' chiuso da un pezzo. La raccolta vale lo stesso, ma NON e' aggiornata a oggi.") }
  }catch{ [void]$Rilievi.Add("non sono riuscito a interpretare la data dell'ultimo campione ('" + $ultimo + "'): la freschezza non e' stata verificata.") }

  # -------------------------------------------------------------------
  #  4. CONFRONTO COL CONTO FATTO DALL'EA
  # -------------------------------------------------------------------
  $orarioLoc = Join-Path $Work ($Prefisso + "_orario.csv")
  if(Test-Path -LiteralPath $orarioLoc){
    $righeCsv = @(LeggiTesto $orarioLoc)
    $confr = 0; $diff = 0; $esempi = New-Object System.Collections.ArrayList
    for($i=1; $i -lt $righeCsv.Count; $i++){
      $c = $righeCsv[$i].Split(",")
      if($c.Count -lt 8){ continue }
      $sy = $c[0].Trim('"'); $h = $c[1].Trim('"')
      $medEA = $c[6].Trim('"'); $p95EA = $c[7].Trim('"')
      $k = $sy + "|" + $h
      if(-not $Ore.ContainsKey($k)){ continue }
      # le righe senza nemmeno un campione valido l'EA le scrive con
      # "n/d" (esistono per dire quanti campioni ha scartato): non sono
      # confrontabili con un percentile, e un confronto fatto lo stesso
      # segnalerebbe una differenza che non c'e'.
      if($Ore[$k].N -le 0){ continue }
      $bins = @{}
      if($Bin.ContainsKey($k)){ $bins = $Bin[$k] }
      $mio  = Percentile $bins $Ore[$k].N 0.50
      $mio9 = Percentile $bins $Ore[$k].N 0.95
      $mioTxt  = "" + $mio.Bin
      $mio9Txt = "" + $mio9.Bin
      if($mio.Over){ $mioTxt = ">" + ($MAXBIN-1) }
      if($mio9.Over){ $mio9Txt = ">" + ($MAXBIN-1) }
      $confr++
      if($mioTxt -ne $medEA -or $mio9Txt -ne $p95EA){
        $diff++
        if($esempi.Count -lt 5){ [void]$esempi.Add($sy + " ora " + $h + ": EA mediana=" + $medEA + " P95=" + $p95EA + " | ricalcolo mediana=" + $mioTxt + " P95=" + $mio9Txt) }
      }
    }
    if($confr -eq 0){ $Confronto = "NON ESEGUITO: il CSV orario dell'EA non ha righe confrontabili" }
    elseif($diff -eq 0){ $Confronto = "OK: " + $confr + " righe confrontate, ZERO differenze fra il conto dell'EA (MQL5) e il ricalcolo di questa riga (PowerShell)" }
    else{
      $Confronto = "ATTENZIONE: " + $diff + " righe su " + $confr + " NON coincidono fra EA e ricalcolo -- " + (@($esempi) -join " ; ")
      [void]$Problemi.Add($Confronto)
    }
  }
  else{ $Confronto = "NON ESEGUITO: manca il CSV orario dell'EA (solo lo stato grezzo)" }
  Dico ("confronto EA/ricalcolo: " + $Confronto) "Green"

  # -------------------------------------------------------------------
  #  5. IL REFERTO
  # -------------------------------------------------------------------
  Titolo "5. REFERTO"
  $simboli = @($Sym.Keys | Sort-Object)
  $r = New-Object System.Collections.ArrayList
  [void]$r.Add("=====================================================================")
  [void]$r.Add("  SPREAD VIVO -- RACCOLTA DEL " + $Avvio.ToString("yyyy-MM-dd HH:mm",$INV) + " (ora locale del PC)")
  [void]$r.Add("  fonte: " + $Prefisso + " sul terminale " + $Scelta)
  [void]$r.Add("=====================================================================")
  [void]$r.Add("conto nel file di stato : " + $Meta["conto"] + " @ " + $Meta["server"])
  [void]$r.Add("primo campione (server) : " + $Meta["primo_campione"])
  [void]$r.Add($frescoTxt)
  [void]$r.Add("passo di campionamento  : " + $Meta["campiona_sec"] + " s   salvataggi " + $Meta["salvataggi"] + "   riprese dello stato " + $Meta["riprese"])
  [void]$r.Add("campioni validi         : " + $tot + "   scartati (mercato fermo / tick vecchio): " + $totScart)
  [void]$r.Add("confronto EA/ricalcolo  : " + $Confronto)
  [void]$r.Add("")
  [void]$r.Add("COME SI LEGGE:")
  [void]$r.Add(" - ore in ORA SERVER (= ora italiana meno 1 in questo periodo).")
  [void]$r.Add(" - i valori sono in unita' pratiche: pip nel forex, punti indice negli indici.")
  [void]$r.Add("   Fra parentesi quadre c'e' sempre il numero GREZZO in punti MT5.")
  [void]$r.Add(" - GG = giornate distinte entrate in quel secchio. E' QUESTO il numero che")
  [void]$r.Add("   dice se la riga si puo' citare: i campioni consecutivi sono")
  [void]$r.Add("   autocorrelati, 3.000 campioni di UN giorno restano un giorno solo.")
  [void]$r.Add("   Le righe con GG < " + $MinGiorni + " sono marcate SOTTILE.")
  [void]$r.Add(" - i percentili di FASCIA si calcolano SOMMANDO gli istogrammi delle ore,")
  [void]$r.Add("   non facendo la media dei percentili (che non sarebbe il P95 di niente).")
  [void]$r.Add(" - qui NON c'e' lo slippage, non ci sono commissioni ne' swap: e' spread.")
  [void]$r.Add("")
  foreach($s in $simboli){
    $ppu = $Sym[$s].Ppu
    $unita = "punti indice"
    if($Sym[$s].Digits -ge 3){ $unita = "pip" }
    $totS = 0; $ggMax = 0
    foreach($h in 0..23){ $k = $s + "|" + $h; if($Ore.ContainsKey($k)){ $totS += $Ore[$k].N; if($Ore[$k].Giorni -gt $ggMax){ $ggMax = $Ore[$k].Giorni } } }
    [void]$r.Add("---------------------------------------------------------------------")
    [void]$r.Add("  " + $s + "   (" + $Sym[$s].Stato + ", " + $Sym[$s].Digits + " decimali, 1 " + $unita + " = " + $ppu + " punti MT5)")
    [void]$r.Add("  campioni validi " + $totS + ", giornate massime in un secchio " + $ggMax)
    [void]$r.Add("---------------------------------------------------------------------")
    [void]$r.Add("   ora |  campioni | GG |  mediana |      P95 |      P99 |  max     | nota")
    [void]$r.Add("   ----+-----------+----+----------+----------+----------+----------+------")
    foreach($h in 0..23){
      $k = $s + "|" + $h
      $sh = "" + $h
      if($sh.Length -lt 2){ $sh = "0" + $sh }
      if(-not $Ore.ContainsKey($k)){ [void]$r.Add("    " + $sh + " |         0 |  - |      n/d |      n/d |      n/d |      n/d | mai campionata"); continue }
      $o = $Ore[$k]
      if($o.N -le 0){ [void]$r.Add("    " + $sh + " | " + (Pad ("" + $o.Scart + " sc") 9) + " |  - |      n/d |      n/d |      n/d |      n/d | solo campioni scartati (mercato fermo)"); continue }
      $bins = @{}
      if($Bin.ContainsKey($k)){ $bins = $Bin[$k] }
      $med = Percentile $bins $o.N 0.50
      $p95 = Percentile $bins $o.N 0.95
      $p99 = Percentile $bins $o.N 0.99
      $nota = ""
      if($o.Giorni -lt $MinGiorni){ $nota = "SOTTILE (GG<" + $MinGiorni + ")" }
      if($o.Over -gt 0){ $nota = ($nota + " " + $o.Over + " campioni oltre il tetto").Trim() }
      if($o.DaInt -gt 0){ $nota = ($nota + " " + $o.DaInt + " campioni dal ripiego intero").Trim() }
      [void]$r.Add("    " + $sh + " | " + (Pad ("" + $o.N) 9) + " | " + (Pad ("" + $o.Giorni) 2) + " | " +
                   (Pad (Mostra $med $ppu 3) 8) + " | " + (Pad (Mostra $p95 $ppu 3) 8) + " | " +
                   (Pad (Mostra $p99 $ppu 3) 8) + " | " + (Pad (([double]$o.Max/$ppu).ToString("F3",$INV)) 8) + " | " + $nota)
    }
    # FASCE: istogrammi sommati
    foreach($f in @(@(0,23,"TUTTA LA GIORNATA"), @(8,15,"cash EUROPA 8-15"), @(14,20,"cash USA 14-20"), @(21,23,"sera/notte 21-23"), @(0,6,"notte 0-6"))){
      $h1 = [int]$f[0]; $h2 = [int]$f[1]; $nome = "" + $f[2]
      $bins = @{}; $n = 0; $gg = 0
      foreach($h in $h1..$h2){
        $k = $s + "|" + $h
        if(-not $Ore.ContainsKey($k)){ continue }
        $n += $Ore[$k].N
        if($Ore[$k].Giorni -gt $gg){ $gg = $Ore[$k].Giorni }
        if($Bin.ContainsKey($k)){
          foreach($b in $Bin[$k].Keys){
            if($bins.ContainsKey($b)){ $bins[$b] = $bins[$b] + $Bin[$k][$b] } else{ $bins[$b] = $Bin[$k][$b] }
          }
        }
      }
      if($n -le 0){ [void]$r.Add("   >> " + $nome + ": nessun campione"); continue }
      $med = Percentile $bins $n 0.50
      $p95 = Percentile $bins $n 0.95
      [void]$r.Add("   >> " + $nome + ": n=" + $n + " GG=" + $gg + "  mediana " + (Mostra $med $ppu 3) + " [" + $med.Bin + " punti MT5]  P95 " + (Mostra $p95 $ppu 3) + " [" + $p95.Bin + " punti MT5]  (" + $unita + ")")
    }
    [void]$r.Add("")
  }
  [void]$r.Add("FILE COPIATI DAL TERMINALE (sola lettura):")
  foreach($c in $Copiati){ [void]$r.Add("  - " + $c) }
  [void]$r.Add("")
  [void]$r.Add("PROBLEMI: " + $Problemi.Count)
  foreach($p in $Problemi){ [void]$r.Add("  - " + $p) }
  [void]$r.Add("RILIEVI: " + $Rilievi.Count)
  foreach($p in $Rilievi){ [void]$r.Add("  - " + $p) }
  [void]$r.Add("")
  foreach($x in $righeC){ [void]$r.Add($x) }
  $Righe = $r
  $Coperta = "" + $tot + " campioni validi, " + $simboli.Count + " simboli"
}
catch{
  $Fatale = $_.Exception.Message
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  RACCOLTA -- gira SEMPRE
# =====================================================================
try{
  New-Item -ItemType Directory -Force -Path $Work | Out-Null
  $ReferTxt = Join-Path $Work "REFERTO_SPREADLOGGER_RACCOLTA.txt"
  if($Righe.Count -eq 0){
    $r2 = New-Object System.Collections.ArrayList
    [void]$r2.Add("RACCOLTA SPREADLOGGER -- " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
    [void]$r2.Add("cartella dati: " + $Scelta + "   criterio: " + $Criterio)
    [void]$r2.Add("copertura: " + $Coperta)
    [void]$r2.Add("")
    [void]$r2.Add("!!! FERMATO: " + $Fatale)
    [void]$r2.Add("")
    foreach($c in $Copiati){ [void]$r2.Add("file: " + $c) }
    foreach($x in $righeC){ [void]$r2.Add($x) }
    $Righe = $r2
  }
  Set-Content -LiteralPath $ReferTxt -Value @($Righe) -Encoding ASCII
  $daZip = New-Object System.Collections.ArrayList
  [void]$daZip.Add($ReferTxt)
  foreach($n in @(($Prefisso + "_stato.csv"), ($Prefisso + "_orario.csv"), ($Prefisso + "_REFERTO.txt"))){
    $p = Join-Path $Work $n
    if(Test-Path -LiteralPath $p){ [void]$daZip.Add($p) }
  }
  $zip = Join-Path $Dsk ("SPREADLOGGER_RACCOLTA_" + $Stamp + ".zip")
  Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
  Compress-Archive -LiteralPath @($daZip) -DestinationPath $zip -Force
  Write-Host ""
  Write-Host ("REFERTO: " + $ReferTxt) -ForegroundColor Cyan
  Write-Host ("ZIP DA MANDARE IN CHAT: " + $zip) -ForegroundColor Cyan
  Write-Host ("PROBLEMI: " + $Problemi.Count + "   RILIEVI: " + $Rilievi.Count)
}
catch{
  Write-Host ("RACCOLTA IN DIFFICOLTA': " + $_.Exception.Message) -ForegroundColor Red
  Write-Host "Manda in chat quello che vedi qui sopra: va bene uguale." -ForegroundColor Yellow
}

if($Fatale -ne "" -or $Problemi.Count -gt 0){ exit 1 }
exit 0
