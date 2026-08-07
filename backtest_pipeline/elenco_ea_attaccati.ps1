# =====================================================================
#  elenco_ea_attaccati.ps1  --  quali EA sono DAVVERO sui grafici
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (07/08/2026)
#  flotta_attesa.csv l'ho costruito da quello che AVEVO: la riga
#  CONFIG IN USO nei log e le posizioni aperte. Ma un EA attaccato che
#  non ha ancora operato e non stampa niente e' INVISIBILE da li'.
#  Venti righe su trentaquattro sono marcate "storico", cioe' IPOTESI.
#
#  MT5 salva la configurazione di ogni grafico in
#     MQL5\Profiles\Charts\<profilo>\chart*.chr
#  Sono file binari, ma il nome dell'EA e il simbolo ci stanno dentro
#  come testo leggibile. Questo script li estrae: e' l'unica fonte
#  che dice cosa e' ATTACCATO, non cosa ha operato.
#
#  ⚠️ LIMITE, dichiarato: il .chr viene riscritto da MT5 quando il
#  profilo si salva (chiusura del terminale, cambio profilo). Se hai
#  attaccato un EA cinque minuti fa e MT5 non ha ancora salvato, qui
#  non c'e'. Per un elenco certo: chiudi MT5, poi lancia questo.
#
#  USO (sul VPS):
#    powershell -ExecutionPolicy Bypass -File .\elenco_ea_attaccati.ps1
#
#  Scrive %USERPROFILE%\ea_attaccati.txt, pronto da mandare.
# =====================================================================
param(
  [switch]$Tutto,        # mostra anche i grafici senza EA
  [switch]$Diagnostica   # se non trova niente: mostra cosa c'e' DENTRO un .chr
)
$ErrorActionPreference = "Continue"

$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
if (-not (Test-Path $termRoot)) { Write-Host "Cartella MetaQuotes non trovata." -ForegroundColor Red; exit 1 }

$out = New-Object System.Collections.ArrayList
function Riga($t, $col = "Gray") { Write-Host $t -ForegroundColor $col; [void]$out.Add($t) }

Riga "=== EA ATTACCATI AI GRAFICI ===" "Cyan"
Riga ("letto il  " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + "  (ora locale del VPS)")
Riga ""

$mt5Aperto = [bool](Get-Process -Name "terminal64" -ErrorAction SilentlyContinue)
if ($mt5Aperto) {
  Riga "!! MT5 e' APERTO: i .chr potrebbero non essere aggiornati." "Yellow"
  Riga "   Per un elenco certo, chiudi MT5 e rilancia." "Yellow"
  Riga ""
}

$trovati = 0
$primoChr = $true
foreach ($dir in (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue)) {
  $profili = Join-Path $dir.FullName "MQL5\Profiles\Charts"
  if (-not (Test-Path $profili)) { continue }

  foreach ($prof in (Get-ChildItem $profili -Directory -ErrorAction SilentlyContinue)) {
    $chr = @(Get-ChildItem $prof.FullName -Filter "chart*.chr" -ErrorAction SilentlyContinue)
    if ($chr.Count -eq 0) { continue }
    Riga ("--- profilo '" + $prof.Name + "'   (" + $chr.Count + " grafici)") "Yellow"

    foreach ($f in ($chr | Sort-Object Name)) {
      # Il .chr e' binario ma i nomi ci stanno dentro come testo. Il nome
      # dell'EA puo' essere attaccato ad altri byte leggibili, quindi NON si
      # puo' pretendere che una "stringa estratta" cominci con ABTG_: si cerca
      # DENTRO il testo. (07/08: la prima versione pretendeva l'inizio riga e
      # ha trovato 0 EA su 29 grafici.)
      $bytes = [IO.File]::ReadAllBytes($f.FullName)
      $testo = New-Object Text.StringBuilder
      foreach ($b in $bytes) {
        if ($b -ge 32 -and $b -le 126) { [void]$testo.Append([char]$b) } else { [void]$testo.Append(' ') }
      }
      $txt = $testo.ToString()

      # simbolo: prima parola tutta maiuscola/cifre lunga 5-9
      $sym = "?"
      $noti = @('D30EUR','NASUSD','U30USD','XAUUSD','EURUSD','GBPUSD','F40EUR','SPXUSD',
                'AUDCAD','AUDNZD','AUDUSD','AUDJPY','CADCHF','GBPJPY','NZDJPY','USDJPY','USDCAD')
      foreach ($n in $noti) { if ($txt -match [regex]::Escape($n)) { $sym = $n; break } }
      if ($sym -eq "?") {
        $mSym = [regex]::Match($txt, '(?<![A-Z0-9])[A-Z][A-Z0-9]{4,8}(?![A-Z0-9])')
        if ($mSym.Success) { $sym = $mSym.Value }
      }

      # EA: prima un nome di file .ex5, poi i prefissi noti, ovunque nel testo
      $ea = $null
      $m1 = [regex]::Match($txt, '([A-Za-z][A-Za-z0-9_\-]{2,60})\.ex5')
      if ($m1.Success) { $ea = $m1.Groups[1].Value.Trim() }
      if (-not $ea) {
        $m2 = [regex]::Match($txt, '(ABTG_[A-Za-z0-9_]+|BULGE[A-Za-z0-9_]*|DAX_MASTER[A-Za-z0-9_]*|Gold_[A-Za-z0-9_]+|IchiCross[A-Za-z0-9_]*|NQ_[A-Za-z0-9_]+|SuperWave[A-Za-z0-9_]*)')
        if ($m2.Success) { $ea = $m2.Groups[1].Value }
      }

      if ($Diagnostica -and $primoChr) {
        $primoChr = $false
        Riga "" ; Riga ("    [DIAGNOSTICA] " + $f.Name + " - le sequenze leggibili piu' lunghe:") "Magenta"
        $pezzi = @($txt -split ' +' | Where-Object { $_.Length -ge 5 } | Select-Object -Unique -First 40)
        foreach ($p in $pezzi) { Riga ("       " + $p) "DarkMagenta" }
        Riga ""
      }

      if ($ea) {
        $trovati++
        Riga ("    {0,-10}  {1}" -f $sym, $ea) "Green"
      } elseif ($Tutto) {
        Riga ("    {0,-10}  (nessun EA)" -f $sym) "DarkGray"
      }
    }
    Riga ""
  }
}

Riga ""
Riga ("=== TOTALE: $trovati grafici con un EA attaccato ===") "Cyan"
if ($trovati -eq 0) {
  Riga "" "Yellow"
  Riga "Nessun EA trovato. Le cause possibili, in ordine:" "Yellow"
  Riga "  1. sei sul PC SBAGLIATO. Gli EA girano sul VPS (utente Administrator)," "Yellow"
  Riga "     non sul PC di backtest (utente Master): li' i grafici non hanno EA." "Yellow"
  Riga "  2. MT5 e' aperto e non ha ancora salvato i .chr: chiudilo e rilancia." "Yellow"
  Riga "  3. il formato del .chr non e' quello che mi aspetto. In quel caso:" "Yellow"
  Riga "       powershell -ExecutionPolicy Bypass -File .\elenco_ea_attaccati.ps1 -Diagnostica" "Yellow"
  Riga "     e mandami l'output: dentro ci sara' scritto come sono salvati i nomi." "Yellow"
}
Riga ""
Riga "Confronta questo elenco con backtest_pipeline/flotta_attesa.csv:"
Riga "  - qui e NON nel csv  -> gira qualcosa di non dichiarato"
Riga "  - nel csv e NON qui  -> il csv dichiara un EA che non e' attaccato"

$dest = Join-Path $env:USERPROFILE "ea_attaccati.txt"
$out | Set-Content -Path $dest -Encoding UTF8
Write-Host ""
Write-Host "=====================================================" -ForegroundColor Green
Write-Host " IL FILE DA MANDARMI E' QUESTO:" -ForegroundColor Green
Write-Host "   $dest" -ForegroundColor White
Write-Host "=====================================================" -ForegroundColor Green
try { Start-Process notepad.exe $dest } catch { }
try { Set-Clipboard -Value $dest } catch { }
