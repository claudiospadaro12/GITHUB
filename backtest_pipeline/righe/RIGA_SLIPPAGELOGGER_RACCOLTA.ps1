# =====================================================================
#  MARCATORE_RIGA_SLIPPAGELOGGER_RACCOLTA_v1
#  RIGA_SLIPPAGELOGGER_RACCOLTA.ps1 -- RACCOGLIE e LEGGE i dati
#  accumulati da ABTG_SlippageLogger sul terminale del conto REALE.
#
#  COSA FA, in una riga: COPIA i tre file che l'EA ha scritto in
#  MQL5\Files, RIFA' DA CAPO mediana / P95 / massimo dello scarto
#  partendo dal registro grezzo dei deal, CONFRONTA il proprio conto
#  con quello scritto dall'EA, e ne fa un referto leggibile piu' uno
#  zip sul Desktop.
#
#  >>> NON TOCCA NIENTE. Legge dalla cartella dati del terminale e
#      scrive SOLO nella propria cartella di lavoro e sul Desktop.
#      Nessuna scrittura dentro MetaQuotes\Terminal, nessuna
#      compilazione, nessun processo fermato: MT5 puo' (e deve)
#      restare APERTO e le due sedie continuano a lavorare. Si puo'
#      rilanciare tutte le volte che si vuole, anche a meta' raccolta.
#
#  >>> PERCHE' RIFA' I CONTI invece di fidarsi del referto dell'EA:
#      perche' un numero prodotto da un solo pezzo di codice non ha
#      nessuno che lo contraddica. Qui il conto si fa DUE VOLTE con due
#      attrezzi diversi (MQL5 e PowerShell) sullo stesso registro
#      grezzo, e se i due non coincidono il referto lo dice invece di
#      scegliere.
#
#  >>> STESSA GUARDIA SUL CONTO DELLA RIGA GEMELLA, e per lo stesso
#      motivo: raccogliere dal terminale sbagliato non fa danno ai
#      soldi, ma produce un numero intestato al conto sbagliato -- e
#      sul demo quel numero e' ZERO PER COSTRUZIONE (BCM ha
#      confermato che li' lo slippage non e' simulato). Quindi:
#      -LoginAtteso obbligatorio, i due conti demo (50503392 e
#      50504263) vietati per sempre, e il login deve comparire nei log
#      della cartella scelta.
#      In piu' qui c'e' una verifica che la riga gemella non puo'
#      fare: OGNI RIGA del registro porta scritto il proprio login e
#      il proprio tipo di conto, e il referto conta quante righe non
#      sono del conto atteso. Se ce n'e' anche una sola, lo dice.
#
#  >>> IL CONTROLLO CHE VALE DA SOLO LA RACCOLTA: se il prezzo preso
#      dall'ORDINE coincide con il prezzo ESEGUITO su TUTTE le righe,
#      vuol dire che questo server non riporta il livello richiesto, e
#      una misura che si fosse fidata solo di quella fonte avrebbe
#      detto "slippage zero" su qualunque conto. Il referto lo scrive
#      a lettere chiare invece di stampare uno zero (classe 106).
#
#  >>> LE ORE del registro sono in ORA SERVER (le scrive l'EA con
#      TimeCurrent). L'orologio di Windows del VPS e' in ora ITALIANA,
#      cioe' un'ora AVANTI: non si confrontano.
#
#  QUANTO CI METTE [STIMA]: pochi secondi.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_SLIPPAGELOGGER_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  [string]$Pin = "",
  [string]$LoginAtteso = "",
  [string]$CartellaDati = "",
  [string]$ConfermoConto = "",
  [string]$Prefisso = "ABTG_SlippageLogger"
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
$INV = [Globalization.CultureInfo]::InvariantCulture

$VIETATI_CONTI = @("50503392","50504263")
$NCOL          = 30

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
$Work = Join-Path $env:USERPROFILE "abtg_slippagelogger_raccolta"

# --- stato della raccolta: tutto nasce PRIMA del try (classe 125)
$Problemi = New-Object System.Collections.ArrayList
$Rilievi  = New-Object System.Collections.ArrayList
$Cand     = New-Object System.Collections.ArrayList
$righeC   = New-Object System.Collections.ArrayList
[void]$righeC.Add("CARTELLE GUARDATE: nessuna scansione")
$Fatale    = ""
$Scelta    = "NON SCELTA"
$Criterio  = "n/d"
$ContoTxt  = "NON MISURATO"
$Copiati   = New-Object System.Collections.ArrayList
$Confronto = "NON ESEGUITO"
$Righe     = @()
$nRighe    = 0
$nBrutte   = 0
$nAltroConto = 0
$Conti     = @{}
$Modi      = @{}
$FontiTxt  = "NON MISURATE"
$SpiaB     = "NON MISURATA"
$TabRighe  = New-Object System.Collections.ArrayList
$Peggio    = New-Object System.Collections.ArrayList

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
    Percorso=$full; Origine=$origine; HaMql=$mq; Origin=""; Logins=""; FileLog=0
    VistoAtteso=$false; VistiVietati=""; Eleggibile=$false; Profilo=$false; Scarto=""; Leggibile=$true
  })
}
# NUMERO facoltativo: "n/d" nel registro vuol dire "non c'era", e un
# n/d non e' uno zero. Torna $null quando manca.
function Num([string]$s){
  if($null -eq $s){ return $null }
  $t = $s.Trim()
  if($t -eq "" -or $t -eq "n/d"){ return $null }
  $v = 0.0
  if([double]::TryParse($t, [Globalization.NumberStyles]::Float, $INV, [ref]$v)){ return $v }
  return $null
}
# PERCENTILE col METODO IDENTICO a quello dell'EA: rango piu' vicino su
# array ORDINATO CRESCENTE, indice = ceil(frac*n)-1. Nessuna
# interpolazione: il numero che esce e' un valore davvero osservato.
# L'ordinamento si fa con [Array]::Sort su un double[] e NON con
# Sort-Object: su chiavi con dei pari Sort-Object non e' stabile
# (R109, 26/08). Qui i pari non cambierebbero il valore, ma il gesto
# giusto non si fa "quando serve", si fa sempre.
function Percentile([double[]]$v,[double]$frac){
  if($null -eq $v){ return $null }
  $n = $v.Length
  if($n -le 0){ return $null }
  $idx = [int][math]::Ceiling($frac * $n) - 1
  if($idx -lt 0){ $idx = 0 }
  if($idx -gt ($n-1)){ $idx = $n-1 }
  return $v[$idx]
}
function Pad([string]$s,[int]$n){ while($s.Length -lt $n){ $s = " " + $s }; return $s }
function PadDx([string]$s,[int]$n){ while($s.Length -lt $n){ $s = $s + " " }; return $s }
function F([object]$v,[int]$d){
  if($null -eq $v){ return "n/d" }
  return ([double]$v).ToString("F" + $d, $INV)
}

try{
  Titolo ("RACCOLTA DEI DATI DI " + $Prefisso + " dal conto REALE")
  Write-Host "Questa riga NON scrive niente dentro il terminale: MT5 puo' restare aperto e le sedie continuano a lavorare." -ForegroundColor Yellow
  if($Pin -ne "" -and $Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin, se lo passi, deve essere un commit di 40 caratteri esadecimali; ricevuto: " + $Pin) }
  if($LoginAtteso -eq ""){ throw "-LoginAtteso OBBLIGATORIO: il numero del conto REALE sta nel NOME dei file scritti dall'EA, e serve per sapere quale registro prendere e per verificare che ogni riga sia di quel conto." }
  if($LoginAtteso -notmatch '^\d{5,12}$'){ throw ("-LoginAtteso deve essere un numero di conto (5-12 cifre), ricevuto: " + $LoginAtteso) }
  foreach($v in $VIETATI_CONTI){
    if($LoginAtteso -eq $v){ throw ("IL CONTO " + $v + " E' VIETATO PER QUESTA RIGA: e' uno dei due conti DEMO, e li' lo slippage non e' simulato. Una raccolta da li' sarebbe un file di zeri intestato a una misura.") }
  }
  if($ConfermoConto -ne "" -and $ConfermoConto -ne $LoginAtteso){ throw ("-ConfermoConto (" + $ConfermoConto + ") e -LoginAtteso (" + $LoginAtteso + ") non coincidono: mi fermo.") }

  New-Item -ItemType Directory -Force -Path $Work | Out-Null
  # LA CARTELLA DI LAVORO SI SVUOTA A OGNI GIRO, PRIMA DI GUARDARE
  # QUALUNQUE COSA. Senza questo, le copie lasciate da una raccolta
  # PRECEDENTE restano li' e il giro dopo le rilegge come se fossero la
  # misura di ADESSO: il referto scriverebbe "fonte: <cartella di oggi>"
  # coi numeri di ieri. RIPRODOTTO ESEGUENDO sulla riga gemella il 05/09.
  $puliti = New-Object System.Collections.ArrayList
  foreach($v in @("_deal.csv","_sintesi.csv","_REFERTO.txt")){
    $vecchio = Join-Path $Work ($Prefisso + "_" + $LoginAtteso + $v)
    if(Test-Path -LiteralPath $vecchio){
      Remove-Item -LiteralPath $vecchio -Force -ErrorAction SilentlyContinue
      if(Test-Path -LiteralPath $vecchio){ throw ("non riesco a cancellare la copia vecchia " + $vecchio + ": mi fermo, perche' leggerla sarebbe la misura di un altro giro spacciata per questa.") }
      [void]$puliti.Add($Prefisso + "_" + $LoginAtteso + $v)
    }
  }
  if($puliti.Count -gt 0){ [void]$Rilievi.Add("cartella di lavoro svuotata prima di cominciare: " + (@($puliti) -join ", ") + " venivano da una raccolta precedente e sono stati BUTTATI (i numeri di questo referto vengono solo dalla copia fatta adesso).") }

  # -------------------------------------------------------------------
  #  1. LA CARTELLA DATI -- stessa scelta severa della riga gemella
  # -------------------------------------------------------------------
  Titolo ("1. CARTELLA DATI DEL CONTO REALE " + $LoginAtteso)
  foreach($pr in @(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)){
    $exe = ""
    try{ $exe = $pr.Path }catch{ $exe = "" }
    if($exe){ AggiungiCandidata (Split-Path -Parent $exe) ("processo terminal64 pid " + $pr.Id) }
  }
  $radici = New-Object System.Collections.ArrayList
  if($env:APPDATA){ [void]$radici.Add((Join-Path $env:APPDATA "MetaQuotes\Terminal")) }
  $drive = $env:SystemDrive
  if(-not $drive){ $drive = "C:" }
  $driveOk = $false
  try{ $driveOk = (Test-Path -LiteralPath ($drive + "\")) }catch{ $driveOk = $false }
  if($driveOk){
    try{
      foreach($u in @(Get-ChildItem -LiteralPath (Join-Path $drive "Users") -Directory -ErrorAction SilentlyContinue)){
        [void]$radici.Add((Join-Path $u.FullName "AppData\Roaming\MetaQuotes\Terminal"))
      }
    }catch{}
  }
  else{ [void]$Rilievi.Add("il disco di sistema '" + $drive + "' non e' leggibile da questa sessione: scansione limitata a %APPDATA% e ai processi vivi. Dichiarato.") }
  foreach($rt in $radici){
    if(-not (Test-Path -LiteralPath $rt)){ continue }
    foreach($d in @(Get-ChildItem -LiteralPath $rt -Directory -ErrorAction SilentlyContinue)){
      if($d.Name -ieq "Common"){ continue }
      AggiungiCandidata $d.FullName ("cartella dati sotto " + $rt)
    }
  }
  if($CartellaDati -ne ""){ AggiungiCandidata $CartellaDati "IMPOSTA A MANO con -CartellaDati" }

  $limite = (Get-Date).AddDays(-180)
  foreach($c in $Cand){
    $o = Join-Path $c.Percorso "origin.txt"
    if(Test-Path -LiteralPath $o){
      try{ $c.Origin = ([string](Get-Content -LiteralPath $o -Raw -ErrorAction Stop)).Trim() }catch{ $c.Origin = ""; $c.Leggibile = $false }
    }
    $loginSet = @{}
    $vietatiVisti = @{}
    foreach($sub in @("logs","MQL5\Logs")){
      $dir = Join-Path $c.Percorso $sub
      if(-not (Test-Path -LiteralPath $dir)){ continue }
      $files = @()
      try{
        $files = @(Get-ChildItem -LiteralPath $dir -Filter "*.log" -File -ErrorAction Stop |
                   Where-Object { $_.LastWriteTime -ge $limite -and $_.Length -lt 60000000 } |
                   Sort-Object LastWriteTime -Descending | Select-Object -First 40)
      }catch{ $c.Leggibile = $false }
      $c.FileLog = $c.FileLog + $files.Count
      foreach($f in $files){
        $righe = @()
        try{ $righe = LeggiTesto $f.FullName }catch{ $c.Leggibile = $false; continue }
        $txt = ($righe -join "`n")
        if($txt.IndexOf("'" + $LoginAtteso + "'") -ge 0){ $c.VistoAtteso = $true }
        foreach($v in $VIETATI_CONTI){ if($txt.IndexOf("'" + $v + "'") -ge 0){ $vietatiVisti[$v] = 1 } }
        foreach($m in [regex]::Matches($txt, "'(\d{5,})': (?:login|authorized) on")){ $loginSet[$m.Groups[1].Value] = 1 }
      }
    }
    if($loginSet.Keys.Count -gt 0){ $c.Logins = (@($loginSet.Keys | Sort-Object) -join ",") }
    if($vietatiVisti.Keys.Count -gt 0){ $c.VistiVietati = (@($vietatiVisti.Keys | Sort-Object) -join ",") }
    if($env:APPDATA){ $c.Profilo = $c.Percorso.StartsWith(($env:APPDATA.TrimEnd("\")), [System.StringComparison]::OrdinalIgnoreCase) }
    if(-not $c.HaMql){ $c.Scarto = "nessuna cartella MQL5\"; continue }
    if($c.VistiVietati -ne ""){ $c.Scarto = "HA VISTO UN CONTO VIETATO nei log (" + $c.VistiVietati + "): fuori dal perimetro"; continue }
    $c.Eleggibile = $true
    if(-not $c.VistoAtteso){ $c.Scarto = "il login " + $LoginAtteso + " NON compare nei log degli ultimi 180 giorni: non si sceglie da sola" }
  }

  $righeC.Clear()
  [void]$righeC.Add("CARTELLE GUARDATE (conto cercato " + $LoginAtteso + ", vietati " + ($VIETATI_CONTI -join "/") + ", candidate " + $Cand.Count + "):")
  foreach($c in $Cand){
    $tag = "scartata"
    if($c.Eleggibile -and $c.VistoAtteso -and $c.Profilo){ $tag = "SCEGLIBILE: login confermato e sotto il profilo di questa sessione" }
    elseif($c.Eleggibile -and $c.VistoAtteso){ $tag = "login confermato, ma sotto un ALTRO profilo" }
    elseif($c.Eleggibile){ $tag = "passa i gate ma SENZA il login nei log" }
    [void]$righeC.Add("  --- " + $c.Percorso + "   [" + $tag + "]")
    [void]$righeC.Add("      trovata come: " + $c.Origine + "   file di log letti=" + $c.FileLog + "   leggibile=" + $c.Leggibile)
    if($c.Origin -ne ""){ [void]$righeC.Add("      origin.txt: " + $c.Origin) }
    $lg = "nessuno"
    if($c.Logins -ne ""){ $lg = $c.Logins }
    [void]$righeC.Add("      login visti nei log: " + $lg + "   atteso " + $LoginAtteso + "=" + $c.VistoAtteso)
    if($c.VistiVietati -ne ""){ [void]$righeC.Add("      CONTI VIETATI VISTI QUI: " + $c.VistiVietati) }
    if($c.Scarto -ne ""){ [void]$righeC.Add("      nota: " + $c.Scarto) }
  }
  foreach($r in $righeC){ Write-Host ("  " + $r) -ForegroundColor Gray }

  $conLogin = @($Cand | Where-Object { $_.Eleggibile -and $_.VistoAtteso })
  $auto     = @($conLogin | Where-Object { $_.Profilo })
  $Reale    = $null
  if($CartellaDati -ne ""){
    $imp = @($Cand | Where-Object { $_.Origine -like "*IMPOSTA A MANO*" })
    if($imp.Count -eq 0){ throw ("-CartellaDati '" + $CartellaDati + "' non esiste o non ha nessuna traccia di un terminale.") }
    if($imp[0].VistiVietati -ne ""){ throw ("-CartellaDati '" + $CartellaDati + "' HA VISTO UN CONTO VIETATO (" + $imp[0].VistiVietati + "): questo cancello non si apre nemmeno a mano.") }
    if($imp[0].VistoAtteso){
      $Reale = $imp[0]
      $Criterio = "IMPOSTA A MANO con -CartellaDati, E col login " + $LoginAtteso + " CONFERMATO nei suoi log"
    }
    elseif($ConfermoConto -ne ""){
      $Reale = $imp[0]
      $Criterio = "SCELTA ATTESTATA A MANO, NON MISURATA: il login non compare nei log di questa cartella; la firma e' -ConfermoConto. Il divieto sui due conti demo resta MISURATO."
      [void]$Rilievi.Add("SCELTA ATTESTATA A MANO: il login " + $LoginAtteso + " non e' stato trovato nei log della cartella scelta. Ma le righe del registro portano ognuna il proprio login: se non fossero del conto atteso, il referto lo direbbe piu' sotto.")
    }
    else{
      throw ("-CartellaDati '" + $CartellaDati + "' NON mostra il login " + $LoginAtteso + " nei log. Se sei sicuro che sia quella, rilancia aggiungendo: -ConfermoConto " + $LoginAtteso)
    }
  }
  elseif($auto.Count -eq 1){
    $Reale = $auto[0]
    $Criterio = "FATTO: unica cartella dati col login " + $LoginAtteso + " nei log, sotto il profilo di questa sessione (" + $env:USERNAME + "), senza tracce dei conti vietati"
  }
  elseif($conLogin.Count -eq 0){
    throw ("NON HO TROVATO NESSUNA CARTELLA CON IL LOGIN " + $LoginAtteso + ". L'elenco di quello che ho guardato e' qui sopra e in CANDIDATE.txt. Se lo riconosci, rilancia con -CartellaDati ""<percorso>"".")
  }
  else{
    throw ("NON SO QUALE CARTELLA E' IL REALE: " + $conLogin.Count + " col login giusto, " + $auto.Count + " sotto questo profilo (ne serve 1). Rilancia con -CartellaDati ""<percorso>"".")
  }
  $Scelta = $Reale.Percorso
  $lg2 = "nessuno"
  if($Reale.Logins -ne ""){ $lg2 = $Reale.Logins }
  $ContoTxt = "atteso " + $LoginAtteso + "; login visti nei log della cartella scelta: " + $lg2 + "; conti vietati visti qui: NESSUNO"
  Dico ("cartella dati scelta: " + $Scelta) "Yellow"

  # -------------------------------------------------------------------
  #  2. COPIA DEI FILE DELL'EA (sola lettura dalla cartella dati)
  # -------------------------------------------------------------------
  Titolo "2. COPIA DEI FILE SCRITTI DALL'EA"
  $Files = Join-Path $Scelta "MQL5\Files"
  $nomi  = @(($Prefisso + "_" + $LoginAtteso + "_deal.csv"),
             ($Prefisso + "_" + $LoginAtteso + "_sintesi.csv"),
             ($Prefisso + "_" + $LoginAtteso + "_REFERTO.txt"))
  foreach($n in $nomi){
    $src = Join-Path $Files $n
    if(Test-Path -LiteralPath $src){
      Copy-Item -LiteralPath $src -Destination (Join-Path $Work $n) -Force
      [void]$Copiati.Add($n + ": " + (Descrivi $src))
      Dico ("copiato " + $n) "Green"
    }
    else{
      [void]$Copiati.Add($n + ": ASSENTE nel terminale (" + $src + ")")
      Dico ($n + " ASSENTE") "Yellow"
    }
  }
  $Ledger = Join-Path $Work ($Prefisso + "_" + $LoginAtteso + "_deal.csv")
  if(-not (Test-Path -LiteralPath $Ledger)){
    [void]$Problemi.Add("IL REGISTRO DEI DEAL NON C'E' (" + (Join-Path $Files $nomi[0]) + "). Tre spiegazioni possibili, e vanno guardate in quest'ordine: (1) l'EA non e' mai stato attaccato a un grafico; (2) e' attaccato ma non ha ancora visto NESSUN deal (nessuna operazione chiusa da quando gira: e' normale nei primi giorni); (3) l'EA gira con un InpPrefissoFile diverso da '" + $Prefisso + "' oppure su un conto diverso da " + $LoginAtteso + " -- guarda in MQL5\Files quali file ci sono davvero.")
    $altri = @()
    if(Test-Path -LiteralPath $Files){ $altri = @(Get-ChildItem -LiteralPath $Files -Filter "ABTG_Slippage*" -File -ErrorAction SilentlyContinue | ForEach-Object { $_.Name + " (" + $_.Length + " byte)" }) }
    if(@($altri).Count -gt 0){ [void]$Rilievi.Add("in MQL5\Files di questo terminale ci sono pero' questi file dello slippage logger: " + (@($altri) -join ", ") + " -- se il numero nel nome non e' " + $LoginAtteso + ", l'EA sta girando su un ALTRO conto.") }
  }
  else{
    # -----------------------------------------------------------------
    #  3. RILETTURA DEL REGISTRO GREZZO
    # -----------------------------------------------------------------
    Titolo "3. RILETTURA DEL REGISTRO E RICALCOLO INDIPENDENTE"
    $tutte = LeggiTesto $Ledger
    $dati = New-Object System.Collections.ArrayList
    foreach($riga in $tutte){
      $t = $riga.TrimEnd()
      if($t -eq ""){ continue }
      if($t.StartsWith("#")){ continue }
      $p = $t -split ';'
      if($p.Count -ne $NCOL){ $nBrutte++; continue }
      if($p[0] -eq "deal"){ continue }
      $d = [pscustomobject]@{
        Deal=$p[0]; Ora=$p[3]; Login=$p[5]; Modo=$p[6]; Sym=$p[7]; Magic=$p[8]
        Entrata=$p[9]; Tipo=$p[10]; Motivo=$p[11]; Volume=(Num $p[12]); Eseguito=(Num $p[13])
        Richiesto=(Num $p[14]); Fonte=$p[15]; RC=(Num $p[16]); RO=(Num $p[17]); RS=(Num $p[18])
        Punti=(Num $p[20]); Unita=$p[22]; Valuta=(Num $p[23]); Point=(Num $p[28])
      }
      [void]$dati.Add($d)
      $nRighe++
      if($d.Login -ne $LoginAtteso){ $nAltroConto++ }
      $Conti[$d.Login] = 1
      $Modi[$d.Modo] = 1
    }
    $Righe = @($dati)
    Dico ("registro: " + $nRighe + " righe buone, " + $nBrutte + " righe scartate") "Green"
    # NOTA: la stringa DEVE stare per prima. "$intero + testo" in PowerShell
    # non concatena: prova a convertire il testo in numero e ESPLODE.
    # Trovato eseguendo, non leggendo.
    if($nBrutte -gt 0){ [void]$Rilievi.Add("" + $nBrutte + " righe del registro non hanno " + $NCOL + " campi e sono state saltate. La spiegazione normale e' UNA: la copia e' stata presa mentre l'EA stava scrivendo in coda, quindi l'ultima riga e' monca. Se sono tante, va guardato a mano.") }
    if($nRighe -eq 0){ [void]$Problemi.Add("il registro esiste ma non ha nessuna riga di dati: l'EA non ha ancora visto nessun deal.") }
    if($nAltroConto -gt 0){ [void]$Problemi.Add("*** " + $nAltroConto + " RIGHE SU " + $nRighe + " NON SONO DEL CONTO " + $LoginAtteso + " *** (login trovati nel registro: " + (@($Conti.Keys | Sort-Object) -join ", ") + "). Il numero di conto sta nel NOME del file, quindi questo non dovrebbe poter succedere: NON si cita nessun numero di questo referto finche' non e' chiaro come ci sono finite.") }
    $modiVisti = @($Modi.Keys | Sort-Object)
    if(@($modiVisti | Where-Object { $_ -ne "REALE" }).Count -gt 0){
      [void]$Problemi.Add("*** NEL REGISTRO CI SONO RIGHE DI UN CONTO NON REALE (tipi visti: " + ($modiVisti -join ", ") + ") *** Su un conto DEMO lo slippage non e' simulato: quelle righe sono zeri per costruzione e NON vanno mescolate con le altre.")
    }

    # --- le tre fonti, e la spia sulla fonte B --------------------------
    $usc = @($Righe | Where-Object { $_.Entrata -ne "IN" })
    $nUsc = @($usc).Count
    $nC = @($usc | Where-Object { $null -ne $_.RC }).Count
    $nO = @($usc | Where-Object { $null -ne $_.RO }).Count
    $nS = @($usc | Where-Object { $null -ne $_.RS }).Count
    $nNiente = @($usc | Where-Object { $_.Fonte -eq "NESSUNA" }).Count
    $nBuguale = 0
    $nCuguale = 0
    $nAcc = 0
    $nConfr = 0
    foreach($u in $usc){
      $tol = 0.0000001
      if($null -ne $u.Point -and $u.Point -gt 0){ $tol = $u.Point * 0.5 }
      if(($null -ne $u.RO) -and ($null -ne $u.Eseguito) -and ([math]::Abs($u.RO - $u.Eseguito) -le $tol)){ $nBuguale++ }
      if(($null -ne $u.RC) -and ($null -ne $u.Eseguito) -and ([math]::Abs($u.RC - $u.Eseguito) -le $tol)){ $nCuguale++ }
      if(($null -ne $u.RC) -and ($null -ne $u.RO)){
        $nConfr++
        if([math]::Abs($u.RC - $u.RO) -le $tol){ $nAcc++ }
      }
    }
    $FontiTxt = "uscite " + $nUsc + "; con COMMENTO (C) " + $nC + "; con ORDINE (B) " + $nO + "; con FOTO SL/TP (A) " + $nS + "; SENZA nessuna fonte " + $nNiente
    if($nConfr -gt 0){ $FontiTxt = $FontiTxt + "; C e B confrontabili " + $nConfr + ", d'accordo " + $nAcc }
    if($nO -gt 0 -and $nBuguale -eq $nO){
      $SpiaB = "ROSSA: la fonte B (prezzo dell'ordine) COINCIDE con l'eseguito in TUTTE le " + $nO + " righe. Questo server NON riporta il livello richiesto nell'ordine: una misura basata su B direbbe 'slippage zero' su qualunque conto. Fa fede la fonte C (commento del server), dove c'e'."
      [void]$Rilievi.Add($SpiaB)
    }
    elseif($nO -gt 0){ $SpiaB = "verde: la fonte B coincide con l'eseguito in " + $nBuguale + " righe su " + $nO + " (non in tutte, quindi il prezzo dell'ordine porta davvero un'informazione)" }
    else{ $SpiaB = "NON MISURABILE: nessuna riga ha il prezzo dell'ordine" }
    if($nUsc -gt 0 -and $nNiente -eq $nUsc){
      [void]$Problemi.Add("NESSUNA uscita ha un prezzo richiesto: in questo registro non c'e' NESSUNA misura di slippage, ci sono solo le esecuzioni.")
    }

    # --- il ricalcolo, e il confronto con quello dell'EA ----------------
    $gruppi = @{}
    foreach($d in $Righe){
      $ent = "OUT"
      $mot = $d.Motivo
      if($d.Entrata -eq "IN"){ $ent = "IN"; $mot = "QUALUNQUE" }
      $k = $d.Sym + "|" + $d.Magic + "|" + $ent + "|" + $mot
      if(-not $gruppi.ContainsKey($k)){ $gruppi[$k] = New-Object System.Collections.ArrayList }
      [void]$gruppi[$k].Add($d)
    }
    $mio = @{}
    foreach($k in $gruppi.Keys){
      $g = @($gruppi[$k])
      $conPunti = @($g | Where-Object { $null -ne $_.Punti })
      $n = @($conPunti).Count
      $senza = @($g).Count - $n
      if($n -le 0){ $mio[$k] = [pscustomobject]@{ N=0; Senza=$senza; Med=$null; P95=$null; Max=$null; Media=$null; Costo=0.0 }; continue }
      $arr = New-Object 'double[]' $n
      for($i=0; $i -lt $n; $i++){ $arr[$i] = [double]$conPunti[$i].Punti }
      [Array]::Sort($arr)
      $somma = 0.0
      foreach($x in $arr){ $somma = $somma + $x }
      $costo = 0.0
      foreach($x in $conPunti){ if($null -ne $x.Valuta){ $costo = $costo + $x.Valuta } }
      $mio[$k] = [pscustomobject]@{
        N=$n; Senza=$senza; Med=(Percentile $arr 0.50); P95=(Percentile $arr 0.95)
        Max=$arr[$n-1]; Media=($somma/$n); Costo=$costo
      }
    }

    $Sintesi = Join-Path $Work ($Prefisso + "_" + $LoginAtteso + "_sintesi.csv")
    if(-not (Test-Path -LiteralPath $Sintesi)){
      $Confronto = "NON ESEGUITO: la sintesi scritta dall'EA non c'e' (l'EA la scrive ogni InpSalvaSec: se e' appena partito, aspetta il primo salvataggio)."
      [void]$Rilievi.Add($Confronto)
    }
    else{
      $rs = LeggiTesto $Sintesi
      $conf = 0; $diff = 0; $soloEA = 0
      $dettagli = New-Object System.Collections.ArrayList
      foreach($riga in $rs){
        $t = $riga.TrimEnd()
        if($t -eq "" -or $t.StartsWith("simbolo;")){ continue }
        $p = $t -split ';'
        if($p.Count -lt 17){ continue }
        $k = $p[0] + "|" + $p[1] + "|" + $p[2] + "|" + $p[3]
        if(-not $mio.ContainsKey($k)){ $soloEA++; [void]$dettagli.Add("gruppo presente nella sintesi dell'EA ma non nel mio ricalcolo: " + $k); continue }
        $m = $mio[$k]
        $nEA = [int]$p[4]
        $medEA = Num $p[6]
        $p95EA = Num $p[7]
        $maxEA = Num $p[8]
        $conf++
        $sbagli = New-Object System.Collections.ArrayList
        if($nEA -ne $m.N){ [void]$sbagli.Add("n EA=" + $nEA + " mio=" + $m.N) }
        if($m.N -gt 0){
          if($null -eq $medEA -or [math]::Abs($medEA - $m.Med) -gt 0.015){ [void]$sbagli.Add("mediana EA=" + (F $medEA 2) + " mio=" + (F $m.Med 2)) }
          if($null -eq $p95EA -or [math]::Abs($p95EA - $m.P95) -gt 0.015){ [void]$sbagli.Add("P95 EA=" + (F $p95EA 2) + " mio=" + (F $m.P95 2)) }
          if($null -eq $maxEA -or [math]::Abs($maxEA - $m.Max) -gt 0.015){ [void]$sbagli.Add("max EA=" + (F $maxEA 2) + " mio=" + (F $m.Max 2)) }
        }
        if($sbagli.Count -gt 0){ $diff++; [void]$dettagli.Add($k + " -> " + (@($sbagli) -join "; ")) }
      }
      if($conf -eq 0){ $Confronto = "NON ESEGUITO: la sintesi dell'EA non ha nessuna riga confrontabile." }
      elseif($diff -eq 0 -and $soloEA -eq 0){ $Confronto = "OK: " + $conf + " gruppi confrontati, ZERO differenze fra il conto dell'EA (MQL5) e il mio (PowerShell)." }
      else{
        $Confronto = "DIFFERENZE: " + $diff + " gruppi su " + $conf + " non coincidono" + $(if($soloEA -gt 0){ ", piu' " + $soloEA + " gruppi solo nell'EA" }else{ "" }) + ". NON si cita nessuno dei due numeri finche' non si capisce perche'."
        [void]$Problemi.Add($Confronto)
        foreach($x in $dettagli){ [void]$Rilievi.Add("confronto: " + $x) }
      }
      Dico ("confronto EA/ricalcolo: " + $Confronto) "Green"
    }

    # --- la tabella del referto, dai MIEI numeri ------------------------
    foreach($k in ($mio.Keys | Sort-Object)){
      $m = $mio[$k]
      $pz = $k -split '\|'
      $un = "punti MT5"
      $ppu = 1.0
      $primo = @($gruppi[$k])[0]
      if($null -ne $primo){
        $un = $primo.Unita
        if($un -eq "pip"){ $ppu = 10.0 } elseif($un -eq "punti indice"){ $ppu = 100.0 }
      }
      if($m.N -le 0){
        [void]$TabRighe.Add("  " + (PadDx ($pz[0] + " magic " + $pz[1] + " " + $pz[2] + " " + $pz[3]) 44) + " | " + (Pad "0" 5) + " |  nessuno scarto calcolabile (" + $m.Senza + " senza prezzo richiesto)")
        continue
      }
      [void]$TabRighe.Add("  " + (PadDx ($pz[0] + " magic " + $pz[1] + " " + $pz[2] + " " + $pz[3]) 44) + " | " +
                          (Pad ([string]$m.N) 5) + " | " + (Pad (F ($m.Med/$ppu) 3) 9) + " | " + (Pad (F ($m.P95/$ppu) 3) 9) + " | " +
                          (Pad (F ($m.Max/$ppu) 3) 9) + " | " + (Pad (F ($m.Media/$ppu) 3) 9) + " | " + (Pad (F $m.Costo 2) 11) + " | " +
                          (PadDx $un 12) + " | senza richiesto " + $m.Senza)
    }

    # --- le peggiori, che le medie nascondono --------------------------
    $conP = @($Righe | Where-Object { $null -ne $_.Punti })
    $ord = @($conP | Sort-Object -Property @{Expression={ [double]$_.Punti }} -Descending | Select-Object -First 10)
    foreach($x in $ord){
      $ppu = 1.0
      if($x.Unita -eq "pip"){ $ppu = 10.0 } elseif($x.Unita -eq "punti indice"){ $ppu = 100.0 }
      [void]$Peggio.Add("  " + $x.Ora + " | " + (PadDx $x.Sym 8) + " | magic " + (Pad $x.Magic 7) + " | " +
                        (PadDx ($x.Entrata + " " + $x.Motivo) 12) + " | vol " + (Pad (F $x.Volume 2) 7) +
                        " | chiesto " + (Pad (F $x.Richiesto 5) 12) + " | eseguito " + (Pad (F $x.Eseguito 5) 12) +
                        " | scarto " + (Pad (F ($x.Punti/$ppu) 3) 9) + " " + $x.Unita +
                        " | costo " + (F $x.Valuta 2) + " | fonte " + $x.Fonte)
    }
  }
}
catch{
  $Fatale = $_.Exception.Message
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  REFERTO + ZIP -- girano SEMPRE
# =====================================================================
try{
  Titolo "REFERTO"
  New-Item -ItemType Directory -Force -Path $Work | Out-Null
  $ReferTxt = Join-Path $Work "REFERTO_SLIPPAGELOGGER_RACCOLTA.txt"
  $r = New-Object System.Collections.ArrayList
  [void]$r.Add("=====================================================================")
  [void]$r.Add("  SLIPPAGE VERO -- RACCOLTA E RICALCOLO INDIPENDENTE")
  [void]$r.Add("=====================================================================")
  $esitoGiro = "COMPLETATO"
  if($Fatale -ne ""){ $esitoGiro = "FERMATO da un gate: " + $Fatale }
  if($Fatale -eq "" -and $Problemi.Count -gt 0){ $esitoGiro = "ARRIVATO IN FONDO MA CON " + $Problemi.Count + " PROBLEMI: leggili PRIMA di citare qualunque numero" }
  [void]$r.Add("ESITO DEL GIRO: " + $esitoGiro)
  [void]$r.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (ORA DI AVVIO di questo giro; le ore del registro sono in ORA SERVER, un'ora indietro)")
  [void]$r.Add("macchina: " + $env:COMPUTERNAME + "     sessione: " + $env:USERNAME)
  if($Pin -ne ""){ [void]$r.Add("pin : " + $Pin) }
  [void]$r.Add("")
  [void]$r.Add("CONTO ATTESO ..............: " + $LoginAtteso)
  [void]$r.Add("CONTI VIETATI PER SEMPRE ..: " + ($VIETATI_CONTI -join ", "))
  [void]$r.Add("guardia sul conto .........: " + $ContoTxt)
  [void]$r.Add("cartella dati .............: " + $Scelta)
  [void]$r.Add("criterio di scelta ........: " + $Criterio)
  [void]$r.Add("")
  [void]$r.Add("FILE COPIATI DAL TERMINALE (sola lettura):")
  foreach($x in $Copiati){ [void]$r.Add("  - " + $x) }
  [void]$r.Add("")
  [void]$r.Add("righe del registro ........: " + $nRighe + " buone, " + $nBrutte + " scartate, " + $nAltroConto + " di un altro conto")
  [void]$r.Add("login trovati nel registro : " + (&{ $k = @($Conti.Keys | Sort-Object); if($k.Count -gt 0){ $k -join ", " } else { "nessuno" } }))
  [void]$r.Add("tipi di conto nel registro : " + (&{ $k = @($Modi.Keys | Sort-Object); if($k.Count -gt 0){ $k -join ", " } else { "nessuno" } }))
  [void]$r.Add("")
  [void]$r.Add("CONFRONTO EA / RICALCOLO ..: " + $Confronto)
  [void]$r.Add("LE TRE FONTI DEL RICHIESTO : " + $FontiTxt)
  [void]$r.Add("SPIA SULLA FONTE B ........: " + $SpiaB)
  [void]$r.Add("")
  [void]$r.Add("COME SI LEGGE:")
  [void]$r.Add(" - SEGNO: positivo = AVVERSO, abbiamo pagato PEGGIO del richiesto.")
  [void]$r.Add("   Negativo = riempimento MIGLIORE del richiesto: capita, non e' un errore.")
  [void]$r.Add(" - la riga che conta e' quella col motivo SL: e' li' che una scivolata")
  [void]$r.Add("   allarga una perdita gia' presa.")
  [void]$r.Add(" - i numeri sono nell'unita' pratica del simbolo (pip / punti indice).")
  [void]$r.Add(" - il costo in valuta usa il valore del tick di quando l'EA ha scritto la")
  [void]$r.Add("   riga, non quello del momento del deal: e' un comodo, non il dato.")
  [void]$r.Add(" - questa misura NON e' lo spread (quello e' ABTG_SpreadLogger).")
  [void]$r.Add("")
  [void]$r.Add("---------------------------------------------------------------------")
  [void]$r.Add("  SCARTO PER SIMBOLO / SEDIA / MOTIVO -- RICALCOLATO QUI DA ZERO")
  [void]$r.Add("---------------------------------------------------------------------")
  [void]$r.Add("  " + (PadDx "gruppo" 44) + " | " + (Pad "n" 5) + " | " + (Pad "mediana" 9) + " | " + (Pad "P95" 9) + " | " + (Pad "max" 9) + " | " + (Pad "media" 9) + " | " + (Pad "costo tot" 11) + " | unita")
  if($TabRighe.Count -eq 0){ [void]$r.Add("  (nessun gruppo: il registro non ha ancora righe)") }
  foreach($x in $TabRighe){ [void]$r.Add($x) }
  [void]$r.Add("")
  [void]$r.Add("---------------------------------------------------------------------")
  [void]$r.Add("  LE 10 SCIVOLATE PEGGIORI (le medie non le fanno vedere)")
  [void]$r.Add("---------------------------------------------------------------------")
  if($Peggio.Count -eq 0){ [void]$r.Add("  (nessuno scarto calcolabile finora)") }
  foreach($x in $Peggio){ [void]$r.Add($x) }
  [void]$r.Add("")
  [void]$r.Add("PROBLEMI: " + $Problemi.Count)
  foreach($p in $Problemi){ [void]$r.Add("  - " + $p) }
  [void]$r.Add("RILIEVI: " + $Rilievi.Count)
  foreach($p in $Rilievi){ [void]$r.Add("  - " + $p) }
  if($Fatale -ne ""){ [void]$r.Add(""); [void]$r.Add("!!! FERMATO: " + $Fatale) }
  [void]$r.Add("")
  foreach($x in $righeC){ [void]$r.Add($x) }
  Set-Content -LiteralPath $ReferTxt -Value @($r) -Encoding ASCII

  $CandTxt = Join-Path $Work "CANDIDATE.txt"
  Set-Content -LiteralPath $CandTxt -Value @($righeC) -Encoding ASCII

  $daZip = New-Object System.Collections.ArrayList
  [void]$daZip.Add($ReferTxt)
  [void]$daZip.Add($CandTxt)
  foreach($n in @(($Prefisso + "_" + $LoginAtteso + "_deal.csv"),
                  ($Prefisso + "_" + $LoginAtteso + "_sintesi.csv"),
                  ($Prefisso + "_" + $LoginAtteso + "_REFERTO.txt"))){
    $f = Join-Path $Work $n
    if(Test-Path -LiteralPath $f){ [void]$daZip.Add($f) }
  }
  $zip = Join-Path $Dsk ("SLIPPAGELOGGER_RACCOLTA_" + $Stamp + ".zip")
  Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
  Compress-Archive -LiteralPath @($daZip) -DestinationPath $zip -Force
  Write-Host ""
  Write-Host ("REFERTO: " + $ReferTxt) -ForegroundColor Cyan
  Write-Host ("ZIP DA MANDARE IN CHAT: " + $zip) -ForegroundColor Cyan
  Write-Host ("PROBLEMI: " + $Problemi.Count + "   RILIEVI: " + $Rilievi.Count)
}
catch{
  Write-Host ("REFERTO IN DIFFICOLTA': " + $_.Exception.Message) -ForegroundColor Red
  Write-Host "Manda in chat quello che vedi qui sopra: va bene uguale." -ForegroundColor Yellow
}

if($Fatale -ne "" -or $Problemi.Count -gt 0){ exit 1 }
exit 0
