# =====================================================================
#  stacca_ea_terzi.ps1  --  TOGLIE DAI GRAFICI DEL PC GLI EA NON NOSTRI
# ---------------------------------------------------------------------
#  ATTENZIONE AL NOME - "TERZI" E' UNA SCORCIATOIA IMPRECISA
#    Lo script chiama "NON NOSTRO" tutto cio' che non si chiama ABTG_*.
#    Ma il 15/08 Claudio ha fatto notare la cosa giusta: quelli sul PC
#    NON sono di sconosciuti, sono LE FONTI del nostro lavoro -
#    PTE_V3_23 e' l'originale da cui viene ABTG_PTE, GOLDEN_CROSS_V03
#    da cui viene ABTG_GoldenCross, BULGE_MULTI_SIGNAL da cui viene
#    ABTG_BreakingBand, NIGHT_BREAK_BOX da cui viene ABTG_MaxMinNotte,
#    NQ_v21_S e' l'EA dell'amico (misurato e bocciato il 12/08).
#    Il motivo per staccarli non e' la proprieta': e' che stanno su un
#    terminale COLLEGATO AL CONTO VIVO, su una macchina che serve da
#    banco di prova. Nessun file .mq5/.ex5 viene toccato.
#
#  E QUESTO NON GUARDA MT4
#    Legge solo MQL5\Profiles\Charts, che esiste solo in MT5. Un
#    terminale MT4 usa profiles\ (senza MQL5) e viene saltato: se hai
#    gli stessi EA su un MT4, questo script non li vede e non li tocca.
#
#  COSA SI PERDE STACCANDO (leggilo prima di -Applica)
#    Sposta via il GRAFICO INTERO, non solo l'EA: se su quel grafico
#    c'e' un template o degli indicatori che usi per guardare a occhio
#    (la bulge, per dire), sparisce anche quello. Torna tutto con
#    -Annulla. Se vuoi TENERE il grafico e togliere solo l'EA, si fa a
#    mano in MT5: tasto destro sul grafico > Consulenti esperti >
#    Rimuovi. Trenta secondi a grafico, ed e' la via piu' pulita.
#
#  PERCHE' ESISTE (15/08/2026, dal censimento degli ordini)
#    Il PC di backtest ha piazzato 174 ordini sul conto VIVO in sedici
#    giorni, e ha collezionato 126 ordini falliti (104 "Invalid price").
#    Quelli non li fa il DAX Apertura: li fanno gli EA di terzi rimasti
#    appesi ai grafici del PC da mesi. Referto:
#    report/CENSIMENTO_ORDINI_PC.md
#
#    AutoTrading sul PC e' gia' spento, quindi adesso non possono
#    operare. Ma "spento" e' una spunta che si riaccende per sbaglio:
#    il lucchetto vero e' non averli attaccati.
#
#  COME LO FA (e perche' cosi')
#    Un grafico di MT5 = un file  MQL5\Profiles\Charts\<profilo>\chartNN.chr
#    Dentro c'e' scritto anche quale EA e' attaccato. Questo script NON
#    modifica i .chr (sono binari, e riscriverli a mano e' il modo di
#    rompere un profilo): SPOSTA VIA per intero i file dei grafici che
#    hanno sopra un EA non nostro. Al riavvio MT5 quei grafici non li
#    apre piu', gli altri restano identici.
#    Tutto finisce in una cartella con la data: si rimette com'era con
#    -Annulla, senza toccare niente a mano.
#
#  SICUREZZA
#    1. Si rifiuta di girare su una macchina diversa da quella attesa.
#       SUL VPS QUESTO SCRIPT SPEGNEREBBE IL FORWARD: la guardia c'e'
#       apposta e va lasciata stare.
#    2. Si rifiuta di girare con MT5 aperto: MT5 riscrive i profili
#       quando si chiude, e annullerebbe il lavoro.
#    3. DI DEFAULT NON TOCCA NIENTE: fa vedere l'elenco e si ferma.
#       Serve -Applica per agire, dopo aver letto l'anteprima.
#
#  USO (PC di backtest, MT5 CHIUSO):
#    powershell -ExecutionPolicy Bypass -File .\stacca_ea_terzi.ps1
#        -> ANTEPRIMA: dice cosa farebbe, non tocca niente
#    powershell -ExecutionPolicy Bypass -File .\stacca_ea_terzi.ps1 -Applica
#    powershell -ExecutionPolicy Bypass -File .\stacca_ea_terzi.ps1 -Annulla
# =====================================================================
param(
  [string] $MacchinaAttesa = "DESKTOP-H4D7CAJ",   # il PC di backtest. Guardia anti-VPS.
  [string] $NostriPattern  = "ABTG_,EasyTrend",   # cosa consideriamo "nostro"
  [switch] $Applica,                              # senza questo NON tocca niente
  [switch] $Annulla,                              # rimette com'era dall'ultimo backup
  [switch] $ForzaMacchina                         # scavalca la guardia (da usare quasi mai)
)
$ErrorActionPreference = "Continue"

$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
if (-not (Test-Path $termRoot)) {
  Write-Host "Cartella MetaQuotes non trovata: $termRoot" -ForegroundColor Red; exit 1
}

$out = New-Object System.Collections.ArrayList
function Riga($t, $col = "Gray") { Write-Host $t -ForegroundColor $col; [void]$out.Add($t) }

function Trova-Desktop {
  $c = @()
  try { $c += [Environment]::GetFolderPath("Desktop") } catch {}
  $c += (Join-Path $env:USERPROFILE "Desktop")
  $c += (Join-Path $env:USERPROFILE "OneDrive\Desktop")
  foreach ($d in $c) { if ($d -and (Test-Path $d)) { return $d } }
  return $env:USERPROFILE
}

Riga "=== STACCA GLI EA DI TERZI DAI GRAFICI ===" "Cyan"
Riga ("MACCHINA: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME) "Cyan"
Riga ("letto il  " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))
Riga ""

# --- GUARDIA 1: la macchina ------------------------------------------
if ($env:COMPUTERNAME -ne $MacchinaAttesa -and -not $ForzaMacchina) {
  Riga ("MI FERMO: questa macchina e' '" + $env:COMPUTERNAME + "', mi aspettavo '" + $MacchinaAttesa + "'.") "Red"
  Riga "" "Red"
  Riga "Se sei sul VPS, questo script NON va lanciato: staccherebbe gli EA" "Red"
  Riga "che tengono in piedi il forward. Sul VPS non c'e' niente da pulire." "Red"
  Riga "" "Red"
  Riga "Se il PC ha davvero un altro nome, rilancia con:" "Yellow"
  Riga ("   -MacchinaAttesa """ + $env:COMPUTERNAME + """") "Yellow"
  exit 1
}

# --- GUARDIA 2: MT5 chiuso -------------------------------------------
if (Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) {
  Riga "MI FERMO: MetaTrader e' APERTO." "Red"
  Riga "MT5 riscrive i profili quando si chiude, quindi qualunque cosa" "Red"
  Riga "facessi adesso verrebbe cancellata all'uscita. Chiudilo e rilancia." "Red"
  exit 1
}

$nostri = @($NostriPattern -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ })

# =====================================================================
#  -Annulla: rimette i grafici dove erano
# =====================================================================
if ($Annulla) {
  $fatto = 0
  foreach ($dir in (Get-ChildItem $termRoot -Directory -EA SilentlyContinue)) {
    $prof = Join-Path $dir.FullName "MQL5\Profiles"
    if (-not (Test-Path $prof)) { continue }
    $backup = @(Get-ChildItem $prof -Directory -Filter "_STACCATI_*" -EA SilentlyContinue | Sort-Object Name)
    if ($backup.Count -eq 0) { continue }
    $ultimo = $backup[$backup.Count - 1]
    Riga ("--- ripristino da " + $ultimo.Name + " ---") "Yellow"
    foreach ($p in (Get-ChildItem $ultimo.FullName -Directory -EA SilentlyContinue)) {
      $dest = Join-Path $prof ("Charts\" + $p.Name)
      if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Force -Path $dest | Out-Null }
      foreach ($f in (Get-ChildItem $p.FullName -Filter "*.chr" -EA SilentlyContinue)) {
        Move-Item $f.FullName (Join-Path $dest $f.Name) -Force
        Riga ("    rimesso  " + $p.Name + "\" + $f.Name) "Green"
        $fatto++
      }
    }
    Remove-Item $ultimo.FullName -Recurse -Force -EA SilentlyContinue
  }
  if ($fatto -eq 0) { Riga "Niente da ripristinare: non ho trovato nessun backup _STACCATI_*." "Yellow" }
  else { Riga ("Rimessi a posto " + $fatto + " grafici. Riapri MT5 per rivederli.") "Green" }
  exit 0
}

# =====================================================================
#  LETTURA DEI .chr  (stessa tecnica di elenco_ea_attaccati.ps1:
#  le stringhe dentro un .chr stanno in UTF-16 e NON per forza a un
#  offset pari, quindi si legge in tre modi e si concatena)
# =====================================================================
function Stampabili($s) {
  $sb = New-Object Text.StringBuilder
  foreach ($ch in $s.ToCharArray()) {
    $c = [int]$ch
    if ($c -ge 32 -and $c -le 126) { [void]$sb.Append($ch) } else { [void]$sb.Append(' ') }
  }
  return $sb.ToString()
}
function Testo-Chr($path) {
  try { $bytes = [IO.File]::ReadAllBytes($path) } catch { return "" }
  $sbA = New-Object Text.StringBuilder
  foreach ($b in $bytes) {
    if ($b -ge 32 -and $b -le 126) { [void]$sbA.Append([char]$b) } else { [void]$sbA.Append(' ') }
  }
  $u1 = Stampabili ([Text.Encoding]::Unicode.GetString($bytes))
  $u2 = if ($bytes.Count -gt 2) { Stampabili ([Text.Encoding]::Unicode.GetString($bytes, 1, $bytes.Count-1)) } else { "" }
  return ($sbA.ToString() + "  ##  " + $u1 + "  ##  " + $u2)
}
function Nome-EA($txt) {
  $m = [regex]::Match($txt, '([A-Za-z][A-Za-z0-9_\-]{2,60})\.ex5')
  if ($m.Success) { return $m.Groups[1].Value.Trim() }
  $m2 = [regex]::Match($txt, '(ABTG_[A-Za-z0-9_]+|BULGE[A-Za-z0-9_]*|DAX_MASTER[A-Za-z0-9_]*|Gold_[A-Za-z0-9_]+|IchiCross[A-Za-z0-9_]*|IchiTrend[A-Za-z0-9_]*|NQ_[A-Za-z0-9_]+|SuperWave[A-Za-z0-9_]*|NIGHT[A-Za-z0-9_]*)')
  if ($m2.Success) { return $m2.Groups[1].Value }
  return ""
}
# Il SIMBOLO del grafico: serve per ritrovarlo in MT5, dove le schede si
# chiamano col simbolo e non "chart07". Prima si prova con i simboli noti
# del broker, poi con una regola generica; se non lo trovo lo dico, non
# invento un nome.
$noti = @("D30EUR","NASUSD","U30USD","F40EUR","E35EUR","225JPY","200AUD","SPXUSD",
          "XAUUSD","XAGUSD","XPDUSD","USOIL","XNGUSD",
          "EURUSD","GBPUSD","USDJPY","USDCHF","USDCAD","AUDUSD","NZDUSD",
          "EURGBP","EURJPY","EURAUD","EURNZD","EURCAD","EURCHF",
          "GBPJPY","GBPAUD","GBPNZD","GBPCAD","GBPCHF",
          "AUDJPY","AUDNZD","AUDCAD","AUDCHF","CADJPY","CADCHF","CHFJPY","NZDJPY")
function Simbolo-Chr($txt) {
  foreach ($n in $noti) { if ($txt -match [regex]::Escape($n)) { return $n } }
  $m = [regex]::Match($txt, '(?<![A-Z0-9])[A-Z][A-Z0-9]{4,8}(?![A-Z0-9])')
  if ($m.Success) { return $m.Value }
  return "?"
}

function E-Nostro($ea) {
  foreach ($n in $nostri) { if ($ea -like ($n + "*")) { return $true } }
  return $false
}

# =====================================================================
#  ANTEPRIMA (e, con -Applica, l'azione)
# =====================================================================
$stamp    = Get-Date -Format "yyyyMMdd_HHmmss"
$daStaccare = New-Object System.Collections.ArrayList
$nNostri = 0; $nVuoti = 0

foreach ($dir in (Get-ChildItem $termRoot -Directory -EA SilentlyContinue)) {
  $charts = Join-Path $dir.FullName "MQL5\Profiles\Charts"
  if (-not (Test-Path $charts)) { continue }
  Riga ("--- terminale " + $dir.Name + " ---") "Yellow"
  # Da quale installazione viene questo terminale: sul PC ce ne sono due e
  # l'ID cartella NON basta a distinguerle (MT5 lo ricava dall'hash del
  # percorso, quindi due macchine con la stessa cartella hanno lo stesso ID).
  $orig = Join-Path $dir.FullName "origin.txt"
  if (Test-Path $orig) {
    try { Riga ("    installato in: " + ((Get-Content $orig -Raw).Trim())) "DarkGray" } catch {}
  }

  foreach ($prof in (Get-ChildItem $charts -Directory -EA SilentlyContinue | Sort-Object Name)) {
    $chr = @(Get-ChildItem $prof.FullName -Filter "chart*.chr" -EA SilentlyContinue | Sort-Object Name)
    if ($chr.Count -eq 0) { continue }
    # MT5 riscrive i .chr del profilo ATTIVO quando salva o si chiude: il
    # profilo coi file piu' recenti e' quasi sempre quello in uso. E' un
    # indizio, non una certezza - la spunta vera si vede in File > Profili.
    $ultimo = ($chr | Sort-Object LastWriteTime -Descending)[0].LastWriteTime
    Riga ("  profilo '" + $prof.Name + "'  (" + $chr.Count + " grafici)   ultimo salvataggio: " + $ultimo.ToString("yyyy-MM-dd HH:mm")) "DarkYellow"
    foreach ($f in $chr) {
      $txt = Testo-Chr $f.FullName
      $ea  = Nome-EA $txt
      if (-not $ea) { $nVuoti++; Riga ("      " + $f.Name + "   (nessun EA)"); continue }
      $sym = Simbolo-Chr $txt
      if (E-Nostro $ea) {
        $nNostri++
        Riga ("      " + $f.Name + "   NOSTRO  " + $sym.PadRight(8) + " " + $ea) "Green"
      } else {
        Riga ("      " + $f.Name + "   NON NOSTRO  " + $sym.PadRight(8) + " " + $ea + "   <- DA STACCARE") "Red"
        [void]$daStaccare.Add([pscustomobject]@{ file=$f.FullName; nome=$f.Name; profilo=$prof.Name; ea=$ea; sym=$sym; radice=(Join-Path $dir.FullName "MQL5\Profiles") })
      }
    }
  }
  Riga ""
}

Riga "=== RIEPILOGO ===" "Cyan"
Riga "NB: se in MT5 non vedi nessun EA attaccato, quasi sempre e' perche'" "Yellow"
Riga "hai aperto UN ALTRO PROFILO o L'ALTRO TERMINALE. Guarda qui sopra" "Yellow"
Riga "in quale profilo stanno, e vai la' con File > Profili." "Yellow"
Riga "Un profilo non attivo non gira - ma resta armato per il giorno in" "Yellow"
Riga "cui lo riapri. Per questo va svuotato lo stesso." "Yellow"
Riga ""
Riga ("  grafici con EA NOSTRI    : " + $nNostri) "Green"
Riga ("  grafici con EA NON NOSTRI: " + $daStaccare.Count) "Red"
Riga ("  grafici senza EA         : " + $nVuoti)
if ($daStaccare.Count -gt 0) {
  Riga ""
  Riga "  EA non nostri trovati (spesso sono LE FONTI del corso):" "Red"
  foreach ($g in ($daStaccare | Group-Object ea | Sort-Object Name)) {
    Riga ("    " + $g.Name + "   (" + $g.Count + " grafici)") "Red"
  }
}
Riga ""

if ($daStaccare.Count -gt 0) {
  Riga ""
  Riga "=== CHECKLIST DA SPUNTARE IN MT5 (via manuale, quella pulita) ===" "Cyan"
  Riga "Per ognuno: apri la scheda del grafico, tasto destro sul grafico," "Cyan"
  Riga "Consulenti esperti > Rimuovi. Il grafico e il template RESTANO." "Cyan"
  Riga ""
  $i = 0
  foreach ($g in ($daStaccare | Sort-Object sym, ea)) {
    $i++
    Riga ("  [ ] " + $i.ToString().PadLeft(2) + ".  " + $g.sym.PadRight(8) + "  " + $g.ea + "     (profilo '" + $g.profilo + "', " + $g.nome + ")")
  }
  Riga ""
  Riga "Quando hai finito: CHIUDI MT5 e rilancia questa stessa riga SENZA" "Yellow"
  Riga "-Applica. Deve uscire   grafici con EA NON NOSTRI: 0   ." "Yellow"
  Riga "Se non esce 0, qualcuno e' rimasto attaccato: la lista dice quale." "Yellow"
  Riga ""
}

if (-not $Applica) {
  Riga "ANTEPRIMA: non ho toccato NIENTE." "Yellow"
  Riga "RICORDA: sposta il GRAFICO INTERO, non solo l'EA. Template e" "Yellow"
  Riga "indicatori di quel grafico se ne vanno con lui (tornano con -Annulla)." "Yellow"
  Riga "Leggi l'elenco qui sopra. Se e' giusto, rilancia la stessa riga" "Yellow"
  Riga "aggiungendo   -Applica   in fondo." "Yellow"
  Riga "Se qualcosa marcato NON NOSTRO e' invece nostro, dimmelo PRIMA: si" "Yellow"
  Riga "aggiunge al parametro -NostriPattern, non si tocca a mano." "Yellow"
} elseif ($daStaccare.Count -eq 0) {
  Riga "Niente da staccare: nessun EA non nostro sui grafici." "Green"
} else {
  Riga "APPLICO." "Cyan"
  foreach ($g in $daStaccare) {
    $dest = Join-Path $g.radice ("_STACCATI_" + $stamp + "\" + $g.profilo)
    if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Force -Path $dest | Out-Null }
    try {
      Move-Item $g.file (Join-Path $dest $g.nome) -Force
      Riga ("   staccato  " + $g.profilo + "\" + $g.nome + "   (" + $g.ea + ")") "Green"
    } catch {
      Riga ("   NON sono riuscito a spostare " + $g.nome + ": " + $_.Exception.Message) "Red"
    }
  }
  Riga ""
  Riga ("Fatto. I grafici staccati sono in  MQL5\Profiles\_STACCATI_" + $stamp) "Green"
  Riga "Per rimettere tutto com'era:  stacca_ea_terzi.ps1 -Annulla" "Yellow"
  Riga ""
  Riga "CONTROLLO DA FARE ADESSO (legge dello screenshot):" "Cyan"
  Riga "  apri MT5, guarda che i grafici rimasti siano solo i nostri," "Cyan"
  Riga "  e MANDA LO SCREENSHOT prima di riaccendere qualunque cosa." "Cyan"
}

# --- referto sul Desktop ---------------------------------------------
$desk = Trova-Desktop
$dest = Join-Path $desk "stacca_ea_terzi"
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force -EA SilentlyContinue }
New-Item -ItemType Directory -Force -Path $dest | Out-Null
$nome = "stacca_ea_terzi_" + $env:COMPUTERNAME + "_" + $stamp + ".txt"
$out | Set-Content -Path (Join-Path $dest $nome) -Encoding ASCII
$zip = Join-Path $desk "stacca_ea_terzi.zip"
if (Test-Path $zip) { Remove-Item $zip -Force -EA SilentlyContinue }
Write-Host ""
Write-Host "    FILE ATTESO:" -ForegroundColor White
if (Test-Path (Join-Path $dest $nome)) { Write-Host ("      OK      " + $nome) -ForegroundColor Green }
else { Write-Host ("      MANCA  " + $nome) -ForegroundColor Red }
try {
  Compress-Archive -Path (Join-Path $dest "*") -DestinationPath $zip -Force
  Write-Host ""
  Write-Host ("    ZIP PRONTO DA MANDARE:  " + $zip) -ForegroundColor Cyan
} catch {
  Write-Host ("!!! zip non creato: " + $_.Exception.Message) -ForegroundColor Red
  Write-Host ("    il referto e' qui: " + (Join-Path $dest $nome)) -ForegroundColor Yellow
}
