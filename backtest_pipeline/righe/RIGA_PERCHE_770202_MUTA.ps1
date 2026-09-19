# =====================================================================
#  MARCATORE_RIGA_PERCHE_770202_MUTA_v1
#  RUNNER_SOLA_LETTURA
# ---------------------------------------------------------------------
#  COSA FA: stampa le righe INTERE (NON troncate) che la sedia
#  ABTG_Dow_Apertura_US (magic 770202, U30USD M5) ha scritto nella
#  scheda Esperti degli ultimi N giorni, su OGNI cartella dati, e
#  accanto quelle di ABTG_ORB_Ottimizzato su U30USD.
#  Non scrive dentro MT5, non apre e non chiude nessun terminale, non
#  compila, non tocca ordini: LEGGE file di log e STAMPA.
#
#  PERCHE' ESISTE -- la domanda a cui risponde, e una sola
#  Dal 28/08/2026 la sedia 770202 non ha piu' aperto niente. Dai
#  referti notturni si vede che ARMA ogni seduta ("RETEST armato") e
#  che dopo non manda nessun ordine. Restano TRE strade possibili, e
#  tutte e tre sono scritte per intero in quella stessa riga di log:
#    (A) bias = -1 o 2  -> il filtro EMA H4 tiene il lato LONG chiuso
#        e InpAllowShort=false chiude l'altro: l'ordine non parte mai;
#    (B) bias = 0 o +1, rottura avvenuta, BUY LIMIT piazzato e SCADUTO
#        non eseguito (offset 400 pt dentro il livello);
#    (C) bias = 0 o +1 e rottura MAI avvenuta.
#  Il referto notturno CODA_02 tronca la riga a 110 caratteri, e il
#  numero del bias sta DOPO il taglio. Questa riga toglie il taglio.
#
#  E RIPARA UN DIFETTO DELLO STRUMENTO (classe 466, 19/09/2026)
#  CODA_02 ordina i log dal PIU' RECENTE al piu' vecchio e poi, nel
#  ciclo, SOVRASCRIVE la variabile "ultima riga": il valore che resta
#  e' quello del file PIU' VECCHIO dei tre. Quella colonna non e'
#  l'ultima riga: e' l'ultima riga di due giorni fa. Qui i file si
#  leggono in ordine CRESCENTE di nome e la data viene stampata
#  accanto a ogni riga, presa dal NOME del file.
#
#  ATTENZIONE, I LIMITI, DICHIARATI
#   1. la scheda Esperti e' in ORA LOCALE del VPS; il grafico e' in ORA
#      SERVER = locale meno 1. Le 16:05 locali sono le 15:05 server,
#      cioe' 14:30 + 35 minuti di range: e' l'ora GIUSTA;
#   2. un EA che non stampa non vuol dire che non opera. Qui pero' la
#      sedia ha InpVerbose=true, quindi stampa;
#   3. i log vecchi possono essere stati ruotati o cancellati: se un
#      giorno manca, questa riga lo dice e non lo inventa.
# =====================================================================

param(
  [string]$Pin = "",
  [int]$Giorni = 25
)

$ErrorActionPreference = "Stop"

$EA_SEDIA = "ABTG_Dow_Apertura_US"
$EA_VICINO = "ABTG_ORB_Ottimizzato"

$stamp  = Get-Date -Format "yyyy-MM-dd"
$outDir = Join-Path ([Environment]::GetFolderPath("Desktop")) ("PERCHE_770202_MUTA_" + $stamp)
if(-not (Test-Path $outDir)){ New-Item -ItemType Directory -Path $outDir | Out-Null }
$ref = Join-Path $outDir "REFERTO_770202_MUTA.txt"

$righe = New-Object System.Collections.ArrayList
function Dire([string]$t){
  Write-Host $t
  [void]$righe.Add($t)
}

Dire "=== PERCHE 770202 E MUTA -- righe INTERE della scheda Esperti ==="
Dire ("data lettura: " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + "  (ora LOCALE del VPS)")
Dire ("pin del pacchetto: " + $(if($Pin){ $Pin } else { "(non passato)" }))
Dire ("giorni di log richiesti: " + $Giorni)
Dire "NB: scheda Esperti = ORA LOCALE. Grafico = ORA SERVER = locale meno 1."
Dire "NB: 16:05 locali = 15:05 server = 14:30 apertura + 35 minuti di range."
Dire "SOLA LETTURA: nessun terminale aperto, chiuso, compilato o toccato."
Dire ""

$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
if(-not (Test-Path $root)){
  Dire "NESSUNA cartella MetaQuotes\Terminal: non si conclude niente."
  Set-Content -LiteralPath $ref -Value $righe -Encoding ASCII
  exit 1
}

$cartelle = @(Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object { Test-Path (Join-Path $_.FullName "MQL5") })
Dire ("cartelle dati trovate: " + $cartelle.Count)

$totArmato = 0
$totOrdine = 0

foreach($d in $cartelle){

  $prog = "(origin.txt assente)"
  $orig = Join-Path $d.FullName "origin.txt"
  if(Test-Path $orig){
    $o = Get-Content -LiteralPath $orig -TotalCount 1 -ErrorAction SilentlyContinue
    if($o){ $prog = ($o -replace "[^\x20-\x7E]","").Trim() }
  }

  $conto = "(non letto)"
  $giorn = @(Get-ChildItem (Join-Path $d.FullName "logs") -Filter *.log -ErrorAction SilentlyContinue |
             Sort-Object Name | Select-Object -Last 3)
  foreach($g in $giorn){
    $m = @(Select-String -LiteralPath $g.FullName -Pattern "account (\d+)" -AllMatches -ErrorAction SilentlyContinue)
    if($m.Count -gt 0){ $conto = $m[$m.Count-1].Matches[0].Groups[1].Value }
  }

  Dire ""
  Dire ("=== CARTELLA " + $d.Name)
  Dire ("    programma: " + $prog)
  Dire ("    conto letto dal GIORNALE: " + $conto)

  $dirLog = Join-Path $d.FullName "MQL5\Logs"
  if(-not (Test-Path $dirLog)){ Dire "    nessuna cartella MQL5\Logs: salto."; continue }

  # ORDINE CRESCENTE DI NOME = ordine cronologico vero (classe 466)
  $files = @(Get-ChildItem $dirLog -Filter *.log -ErrorAction SilentlyContinue |
             Sort-Object Name | Select-Object -Last $Giorni)
  if($files.Count -eq 0){ Dire "    nessun log: salto."; continue }
  Dire ("    log letti: " + $files.Count + "   dal " + $files[0].Name + " al " + $files[$files.Count-1].Name)

  $trovatoQui = 0
  foreach($f in $files){
    $giorno = $f.BaseName   # AAAAMMGG
    $linee = @(Get-Content -LiteralPath $f.FullName -ErrorAction SilentlyContinue |
               Where-Object { $_ -match $EA_SEDIA -or ($_ -match $EA_VICINO -and $_ -match "U30USD") })
    if($linee.Count -eq 0){ continue }
    Dire ""
    Dire ("    --- giorno " + $giorno + "  (" + $linee.Count + " righe)")
    foreach($l in $linee){
      $t = $l.Trim()
      Dire ("      " + $giorno + " | " + $t)
      $trovatoQui = $trovatoQui + 1
      if($t -match "RETEST armato"){ $totArmato = $totArmato + 1 }
      if($t -match "BUY LIMIT|SELL LIMIT|BUY STOP|SELL STOP|OrderSend"){ $totOrdine = $totOrdine + 1 }
    }
  }
  if($trovatoQui -eq 0){ Dire "    nessuna riga dei due EA in questa finestra di log." }
}

Dire ""
Dire "=== COME SI LEGGE, e il criterio e' scritto PRIMA dei numeri ==="
Dire "Cerca nelle righe 'RETEST armato' il campo 'bias N'."
Dire "  bias -1 oppure 2 -> lato LONG CHIUSO dal filtro EMA H4, e InpAllowShort=false"
Dire "                      chiude l'altro: CAUSA (A), l'ordine non parte mai."
Dire "  bias 0 oppure +1 -> il lato long era APERTO. Allora guarda se lo stesso"
Dire "                      giorno compare 'BUY LIMIT (retest)':"
Dire "                        SI -> CAUSA (B): ordine piazzato e scaduto non eseguito."
Dire "                        NO -> CAUSA (C): rottura mai avvenuta (mercato)."
Dire "Le tre cause sono tutte di MERCATO o di DISEGNO: nessuna e' un guasto."
Dire "Quello che le distingue e' COSA si cambia dopo, non se la sedia e' rotta."
Dire ""
Dire ("righe 'RETEST armato' trovate : " + $totArmato)
Dire ("righe di ORDINE trovate       : " + $totOrdine)
Dire ""
Dire "Questa riga ha LETTO e STAMPATO: non ha scritto, copiato o modificato niente dentro MT5."

Set-Content -LiteralPath $ref -Value $righe -Encoding ASCII
Write-Host ""
Write-Host ("REFERTO scritto in: " + $ref)

$zip = Join-Path ([Environment]::GetFolderPath("Desktop")) ("PERCHE_770202_MUTA_" + $stamp + ".zip")
Remove-Item $zip -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $outDir "*") -DestinationPath $zip -Force
Write-Host ("ZIP pronto da mandare: " + $zip)
Write-Host ""
Write-Host "FILE ATTESI, da verificare a occhio in questa console:"
Write-Host ("  1) " + $ref)
Write-Host ("  2) " + $zip)

if($totArmato -eq 0){
  Write-Host "ESITO: PARZIALE - nessuna riga 'RETEST armato' nella finestra di log letta."
  exit 2
}
exit 0
