# =====================================================================
#  MARCATORE_RIGA_ROUND_VPS_v2
#  RIGA_ROUND_VPS.ps1 -- UN ROUND QUALUNQUE SUL TERMINALE DA BACKTEST
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (08/09/2026)
#  Oggi il PASSO 7 e' passato: C:\MT5_Backtest (conto demo 50504400) ha
#  riprodotto ALLA CIFRA le due corse di R119 gia' agli atti
#  (report\PASSO7_ANCORA_SUPERATA_2026-09-08.md, RILIEVI 0). Da adesso i
#  round possono girare SUL VPS e non solo sul PC di Claudio.
#  Ma RIGA_ANCORA_R119.ps1 e' CABLATA sulle due sedie dell'ancora e sui
#  loro quattro numeri attesi: serve per il passo 7, non per un round.
#  Questa e' la versione GENERICA: stesse guardie, stessi cancelli,
#  nessun numero atteso.
#
#  COSA FA (e cosa NON fa)
#   - ESEGUE un round: scarica il driver e il file prova dal PIN, chiude
#     SOLO il terminale da backtest, lancia walkforward_generico.ps1,
#     raccoglie i CSV e scrive un referto sul Desktop.
#   - NON GIUDICA. Qui non ci sono numeri attesi ne' confronti: il
#     verdetto si scrive dopo, coi criteri congelati PRIMA del round.
#
#  COSA E' RIUSATO DA RIGA_ANCORA_R119.ps1 v3 (non reinventato)
#   1. le GUARDIE SUL TERMINALE -- riusate, e poi RIFATTE AL CONTRARIO
#      l'11/09/2026 (il perche' sta al PUNTO 1, piu' sotto). L'ancora
#      ELENCAVA i vietati (-V3, BCM_Reale): una lista di divieti non
#      vede il bersaglio che nessuno ci ha ancora messo, e infatti
#      lasciava passare il PICCOLO 50503392, la RADICE di un disco e i
#      nomi 8.3 di Windows. Adesso la guardia AMMETTE il banco
#      C:\MT5_Backtest e uccide tutto il resto; i divieti per nome
#      restano come seconda rete. Restano anche le guardie sulla
#      cartella che non c'e' e su terminal64.exe che manca;
#   2. il PRE-VOLO SUL TETTO BARRE (MaxBars in config\common.ini):
#      classe 160, un tetto a 100.000 fa girare su MENO storico senza
#      dirlo;
#   3. il CENSIMENTO PID PRIMA E DOPO, col confronto fatto DAL CODICE e
#      l'allarme rosso se sparisce un terminale NON bersaglio: e' la
#      prova stampata che il conto reale non e' stato toccato;
#   4. la CHIUSURA CHIRURGICA del solo terminale da backtest (classe
#      159: la guardia del driver e' GLOBALE e sul VPS i terminali sono
#      quattro) e -Force al driver;
#   5. il CONTROLLO DEL MARCATORE del driver scaricato (classe 161:
#      senza la v5 il driver non porta gli #include nostri, l'EA non
#      compila e il round muore con ZERO CSV);
#   6. la RACCOLTA con zip sul Desktop e il REFERTO con la riga 'data:'.
#
#  COSA CAMBIA RISPETTO ALL'ANCORA
#   - niente numeri attesi, niente confronto, niente "RIPRODUCE";
#   - il referto stampa, per OGNI CSV prodotto (IS e OOS): quante righe
#     e, per ognuna, Profit / PF / Equity DD % / Trades. Cosi' il
#     risultato si legge senza aprire il CSV;
#   - IL CANCELLO CHE CONTA: se il CSV non c'e' o Trades = 0, il referto
#     lo dice a chiare lettere ->
#        "Trades=0 non vuol dire nessun edge, vuol dire NON E' GIRATA:
#         guardare il log"
#     E' l'errore del verdetto PostNews del 07/08, gia' pagato una volta.
#
#  CODICI D'USCITA (il gate sta sull'ARTEFATTO, non sul rc del driver --
#  classe 154: il codice che torna dal driver e' quello dell'ultimo .exe
#  lanciato dentro, non il suo)
#     0 = ROUND GIRATO          (i due CSV ci sono, freschi, con Trades>0)
#     2 = NON MISURATO          (CSV assente/vuoto, oppure Trades=0)
#     3 = GIRATO CON RILIEVI    (i numeri ci sono ma qualcosa va guardato)
#     1 = non e' nemmeno partito (pre-volo fallito)
#  La RACCOLTA si fa SEMPRE, anche a esito 2: un round che non e' girato
#  e' gia' una risposta, e il referto va mandato lo stesso (punto 26-bis).
#
#  USO -- IL PRIMO ROUND CHE DEVE LANCIARE (PASSO 0 di conteggio)
#    -Expert "ABTG_OpeningReversalB"
#    -Prova  "ABTG_OpeningReversalB_00_conta.txt"
#    -Etichetta "P0CONTA"
#  (U30USD M5, EA nel repo dal 30/08 e MAI girato; la cella e' gia'
#   committata e validata: 27 input pin, 2 celle, 4 passate.)
#
#  PRIMA LA PROVA A VUOTO (-SoloControllo), SEMPRE. E si sappia cosa NON
#  copre, perche' e' scritto in checklist e non e' cambiato:
#    - punto 39: il -SoloControllo del driver generico NON COMPILA. Un
#      #include mancante salta fuori solo a corsa avviata;
#    - punto 31: nel ramo di prova del driver Model=4 e' HARDCODED, cioe'
#      con -Modello 1 l'anteprima .ini dice comunque Model=4 (Deposit
#      invece e' la variabile vera, verificato riga per riga);
#    - il driver esce PRIMA di scegliere il terminale: il giro a vuoto
#      NON collauda -TerminaleBacktest.
#
#  -------------------------------------------------------------------
#  NOTA SUL NOME DEL FILE (21/09/2026): SI CHIAMA "VPS" MA NON GIRA PIU'
#  SOLO SUL VPS. Da oggi la stessa riga gira anche sul PC DI BACKTEST
#  (DESKTOP-H4D7CAJ). Il nome NON si cambia apposta: ci puntano righe di
#  lancio pinnate (report\RIGHE_R190_R187_2026-09-19.md,
#  report\RIGA_ROUND_VPS_2026-09-08.md) e altri .ps1 del repo
#  (righe\RIGA_SOTTILE_ROUND.ps1, righe\MISURA_LOTTI_U30USD.ps1) che lo
#  scaricano per NOME, e rinominarlo le romperebbe tutte in una volta.
#  Leggasi come "la riga dei round", non come "la riga del VPS".
#
#  COSA CAMBIA NELLA v2 -- LA GUARDIA DIVENTA "MACCHINA + PERCORSO"
#  PERCHE' (firma di Claudio del 21/09/2026, in CLAUDE.md): dopo che un
#  backtest a tick reali ha inchiodato il VPS nella prima mezz'ora del
#  primo giorno di challenge FTMO, i round girano sul PC DI BACKTEST.
#  Ma la v1 ammetteva UN SOLO percorso, C:\MT5_Backtest, che sta SUL VPS
#  (censito: report\collaudi\CENSIMENTO_MT5_VPS_2026-09-12_0846.txt,
#  macchina VMI3047753): cioe' la macchina dei round era CABLATA sul VPS
#  e la firma non era eseguibile.
#
#  IL PUNTO DIFFICILE, ed e' tutto il lavoro: il terminale del PC di
#  backtest e' C:\Program Files\BCM Markets MT5 Terminal, e QUELLO STESSO
#  PERCORSO sul VPS e' il PICCOLO 50503392, che ha sedie vive sopra ed e'
#  in $TERMINALI_VIETATI per un'ottima ragione. Lo stesso testo deve
#  essere AMMESSO su una macchina e VIETATO sull'altra.
#  >>> QUINDI IL DISCRIMINANTE NON E' IL PERCORSO: E' LA MACCHINA. <<<
#  Una tabella (un nome di macchina -> un solo terminale ammesso), letta
#  da $env:COMPUTERNAME con confronto ORDINALE, e FAIL-CLOSED: macchina
#  che non e' in tabella = si rifiuta, e si stampa il nome trovato e i
#  nomi ammessi. Nessun ripiego "se non riconosco, lascio passare".
#  I VIETATI PER NOME NON SONO STATI INDEBOLITI: si consultano PRIMA
#  della tabella e vincono loro. L'unica deroga e' il percorso del
#  piccolo sulla SOLA DESKTOP-H4D7CAJ, ed e' scritta col suo perche'
#  accanto alla tabella.
#
#  CONSEGUENZE DICHIARATE (non sono opinioni, sono catene che si rompono):
#   - chi controlla il marcatore _v1 adesso MUORE invece di girare. E'
#     voluto, ed e' un fallimento SICURO (non parte, non tocca niente).
#     Da aggiornare quando si ripassa di li':
#     righe\MISURA_LOTTI_U30USD.ps1 r.67 e righe\RIGA_SOTTILE_ROUND.ps1
#     r.1451 (che inchioda anche lo SHA-256 di QUESTO file, r.1452-1585);
#   - LE DUE COPIE SONO STATE ALLINEATE (21/09/2026, secondo passo). Il
#     blocco condiviso qui sotto porta adesso il marcatore
#     GUARDIA_BANCO_POSITIVA_v2 ed e' IDENTICO BYTE PER BYTE in
#     walkforward_generico.ps1 e in righe\RIGA_SCAN_GESTIONE.ps1. Prima
#     erano ferme alla v1, cioe' cablate sul banco del VPS: un round su
#     DESKTOP-H4D7CAJ passava QUESTA guardia e poi moriva DENTRO IL
#     DRIVER -- fallendo chiuso, quindi senza pericolo, ma senza girare.
#     Che le tre copie non divergano NON e' piu' affidato alla buona
#     volonta': lo dimostra backtest_pipeline\banco_guardia_macchina.ps1,
#     che estrae il blocco dai tre file e confronta le impronte SHA-256.
#     Chi cercava il marcatore _v1 non lo trova piu': e' voluto.
#     Vedi report\I_ROUND_SUL_PC_DI_BACKTEST_2026-09-21.md.
#  -------------------------------------------------------------------
#
#  NIENTE EMOJI: Windows PowerShell 5.1 legge i .ps1 come ANSI.
# =====================================================================

param(
  [Parameter(Mandatory=$true)][string]$Expert,
  [Parameter(Mandatory=$true)][string]$Prova,
  [Parameter(Mandatory=$true)][string]$Etichetta,
  [string]$Pin               = "lavoro",
  # v2: il default NON e' piu' un percorso cablato. Vuoto = "usa il
  # bersaglio della macchina su cui sto girando", che la tabella qui
  # sotto decide. Su una macchina non in tabella resta vuoto e viene
  # RIFIUTATO: il vuoto non e' un permesso.
  [string]$TerminaleBacktest = "",
  [int]$Modello              = 4,
  [int]$Deposito             = 10000,
  [string]$Work              = "$env:USERPROFILE\abtg_round",
  [switch]$ChiudiBacktest,
  [switch]$SoloControllo
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$MARC_MIO = "MARCATORE_RIGA_ROUND_VPS_v2"   # v2 = guardia PER MACCHINA (21/09/2026)
$MARC_DRV = "MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE"
$RawBase  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"
$Avvio    = Get-Date

# Il testo del cancello sta in UNA variabile sola: console e referto non
# possono dire due cose diverse (classe 119-bis).
$TESTO_TRADES0 = "Trades=0 non vuol dire nessun edge, vuol dire NON E' GIRATA: guardare il log"

$RILIEVI = New-Object System.Collections.ArrayList
function Muori($m){ Write-Host ""; Write-Host ("ERRORE: " + $m) -ForegroundColor Red; exit 1 }
function Rilievo($m){ [void]$RILIEVI.Add($m); Write-Host ("    RILIEVO: " + $m) -ForegroundColor DarkYellow }

# =====================================================================
#  FUNZIONI PURE -- stanno qui in cima perche' sono COLLAUDABILI OFFLINE
#  (banco: report\RIGA_ROUND_VPS_2026-09-08.md, sezione COLLAUDI)
# =====================================================================

# Cultura invariante SEMPRE: su it-IT "2.0" letto senza InvariantCulture
# diventa 20 (checklist, punto 5).
function NumInv($s){
  if($null -eq $s){ return $null }
  $t = ("" + $s).Trim().Replace(",",".")
  if($t -eq ""){ return $null }
  $v = 0.0
  if([double]::TryParse($t,[Globalization.NumberStyles]::Float,[Globalization.CultureInfo]::InvariantCulture,[ref]$v)){ return $v }
  return $null
}

# Un nome che finisce in una URL e in un nome di file non puo' contenere
# separatori di percorso ne' spazi.
function NomeValido([string]$s){
  if($null -eq $s){ return $false }
  if($s.Trim() -eq ""){ return $false }
  return ($s -match '^[A-Za-z0-9_.-]+$')
}

# L'etichetta e' il suffisso dei CSV: solo lettere, cifre e underscore.
function EtichettaValida([string]$s){
  if($null -eq $s){ return $false }
  if($s.Trim() -eq ""){ return $false }
  return ($s -match '^[A-Za-z0-9_]+$')
}

# Le direttive @ del file prova, lette RIGA PER RIGA: niente regex
# multilinea, cosi' il CRLF non puo' far fallire il match (classe 40).
function DirettivaProva([string]$file,[string]$nome){
  if(-not (Test-Path -LiteralPath $file -PathType Leaf)){ return "" }
  $righe = @()
  try{ $righe = @(Get-Content -LiteralPath $file -ErrorAction Stop) }catch{ return "" }
  foreach($r in $righe){
    $t = ("" + $r).Trim()
    if(-not $t.StartsWith("@")){ continue }
    if($t -match '^@(\w+)\s+(.+)$'){
      if($Matches[1].ToUpper() -eq $nome.ToUpper()){ return $Matches[2].Trim() }
    }
  }
  return ""
}

# Il tetto delle barre nel grafico, dal config\common.ini della cartella
# dati. Torna $null se la chiave non c'e' (= NON VERIFICATO, che si
# dichiara: non si finge di averlo controllato).
function TettoBarre([string]$dataFolder){
  if(-not $dataFolder){ return $null }
  $ciFile = Join-Path $dataFolder "config\common.ini"
  if(-not (Test-Path -LiteralPath $ciFile)){ return $null }
  $val = $null
  foreach($l in @(Get-Content -LiteralPath $ciFile -ErrorAction SilentlyContinue)){
    if($l -match '^\s*MaxBars(InChart)?\s*=\s*([0-9]+)\s*$'){ $val = [int64]$Matches[2] }
  }
  return $val
}

# Legge un CSV di ottimizzazione e ne tira fuori SOLO quello che serve a
# LEGGERE il round senza aprire il file. Non giudica niente.
function LeggiCsvRound([string]$path,$t0){
  $e = [pscustomobject]@{
    Path       = $path
    Presente   = $false
    Fresco     = $false
    NRighe     = 0
    Righe      = @()
    ConTrades  = 0
    ZeroTrades = 0
    Problema   = ""
  }
  if(-not (Test-Path -LiteralPath $path -PathType Leaf)){
    $e.Problema = "CSV ASSENTE"
    return $e
  }
  $e.Presente = $true
  $it = Get-Item -LiteralPath $path
  if($null -ne $t0 -and $it.LastWriteTime -lt $t0){
    # Classe 155: la cartella di lavoro e' riusabile. Un CSV vecchio col
    # nome giusto non e' il risultato di questa corsa.
    $e.Problema = "CSV NON FRESCO (scritto il " + $it.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss") + ", la corsa e' partita dopo)"
    return $e
  }
  $e.Fresco = $true
  if($it.Length -eq 0){
    $e.Problema = "CSV DA 0 BYTE"
    return $e
  }
  $righe = @()
  try{ $righe = @(Import-Csv -LiteralPath $path -ErrorAction Stop) }catch{
    $e.Problema = "CSV NON LEGGIBILE: " + $_.Exception.Message
    return $e
  }
  $e.NRighe = $righe.Count
  if($righe.Count -eq 0){
    $e.Problema = "ZERO RIGHE (solo intestazione): nessuna passata eseguita"
    return $e
  }
  $out = New-Object System.Collections.ArrayList
  $i = 0
  foreach($r in $righe){
    $pass = ("" + $r.'Pass').Trim()
    if($pass -eq ""){ $pass = ("" + $i) }
    $tr = NumInv $r.'Trades'
    $ri = [pscustomobject]@{
      Pass   = $pass
      Profit = (NumInv $r.'Profit')
      PF     = (NumInv $r.'Profit Factor')
      DD     = (NumInv $r.'Equity DD %')
      Trades = $tr
    }
    if($null -eq $tr){ $e.Problema = "colonna Trades non leggibile (il CSV non ha l'intestazione attesa)" }
    elseif([int]$tr -eq 0){ $e.ZeroTrades = $e.ZeroTrades + 1 }
    else{ $e.ConTrades = $e.ConTrades + 1 }
    [void]$out.Add($ri)
    $i = $i + 1
  }
  $e.Righe = @($out)
  return $e
}

# Le righe del referto per UN CSV. Ritorna un array di stringhe: la
# stessa cosa che finisce a schermo e nel file (nessuna divergenza).
function RigheReferto($e,[string]$nome,[string]$testoTrades0){
  $R = New-Object System.Collections.ArrayList
  [void]$R.Add("--- " + $nome + " ---")
  [void]$R.Add("  file  : " + $e.Path)
  if(-not $e.Presente -or -not $e.Fresco -or $e.NRighe -eq 0){
    [void]$R.Add("  ESITO : NON MISURATO -- " + $e.Problema)
    [void]$R.Add("  >>> " + $testoTrades0)
    return @($R)
  }
  [void]$R.Add("  righe : " + $e.NRighe)
  # ATTENZIONE: la variabile del ciclo NON puo' chiamarsi $r -- PowerShell
  # non distingue le maiuscole e schiaccerebbe $R, l'elenco che stiamo
  # costruendo. Trovato dal banco, non a mente.
  foreach($rg in $e.Righe){
    $vp  = if($null -eq $rg.Profit){ "?" } else { $rg.Profit.ToString([Globalization.CultureInfo]::InvariantCulture) }
    $vpf = if($null -eq $rg.PF)    { "?" } else { $rg.PF.ToString([Globalization.CultureInfo]::InvariantCulture) }
    $vdd = if($null -eq $rg.DD)    { "?" } else { $rg.DD.ToString([Globalization.CultureInfo]::InvariantCulture) }
    $vtr = if($null -eq $rg.Trades){ "?" } else { ([int]$rg.Trades).ToString([Globalization.CultureInfo]::InvariantCulture) }
    [void]$R.Add("    Pass " + ("" + $rg.Pass).PadRight(4) + " Profit " + $vp.PadRight(12) + " PF " + $vpf.PadRight(10) + " Equity DD % " + $vdd.PadRight(10) + " Trades " + $vtr)
  }
  if($e.Problema -ne ""){ [void]$R.Add("  nota  : " + $e.Problema) }
  if($e.ConTrades -eq 0){
    [void]$R.Add("  ESITO : NON MISURATO -- TRADES = 0 su tutte le " + $e.NRighe + " righe")
    [void]$R.Add("  >>> " + $testoTrades0)
  }
  elseif($e.ZeroTrades -gt 0){
    [void]$R.Add("  ESITO : LETTO, ma " + $e.ZeroTrades + " righe su " + $e.NRighe + " hanno Trades = 0")
    [void]$R.Add("  >>> " + $testoTrades0)
  }
  else{
    [void]$R.Add("  ESITO : LETTO -- " + $e.NRighe + " righe, tutte con Trades > 0")
  }
  return @($R)
}

# =====================================================================
#  GUARDIA_BANCO_POSITIVA_v2 -- INIZIO DEL BLOCCO CONDIVISO
#
#  QUESTO BLOCCO VIVE IN TRE FILE ED E' IDENTICO BYTE PER BYTE IN TUTTI
#  E TRE. Non e' "codice di questo file": e' LA GUARDIA. Se una delle
#  copie diverge, abbiamo tre guardie diverse che credono di essere la
#  stessa -- ed e' il difetto peggiore che possa avere un cancello.
#  I tre file, per nome:
#     backtest_pipeline\righe\RIGA_ROUND_VPS.ps1      (l'originale)
#     backtest_pipeline\walkforward_generico.ps1      (il driver)
#     backtest_pipeline\righe\RIGA_SCAN_GESTIONE.ps1  (lo studio uscite)
#  Si trovano tutti e tre con:
#     grep -rn "GUARDIA_BANCO_POSITIVA_v2" backtest_pipeline
#
#  SI MODIFICA IN UN POSTO SOLO E SI RICOPIA NEGLI ALTRI DUE, NELLO
#  STESSO COMMIT. E da oggi non e' piu' una raccomandazione scritta in un
#  commento: c'e' UNA MACCHINA CHE LO DIMOSTRA. Estrae il blocco dai tre
#  file, ne confronta le impronte SHA-256 e FALLISCE se divergono:
#     pwsh -NoProfile -File backtest_pipeline/banco_guardia_macchina.ps1
#  Perche' serviva: fino al 21/09/2026 il controllo non esisteva, la
#  guardia dell'originale e' passata alla v2 e le due copie sono rimaste
#  alla v1 -- cioe' cablate sul banco del VPS. Nessuno se ne e' accorto
#  leggendo: se ne e' accorto chi e' andato a guardare i tre file.
#
#  PERCHE' COPIATO E NON INCLUSO -- scelta dichiarata, col suo costo.
#  Un include sarebbe UNA DIPENDENZA IN PIU' DA PINNARE, e qui il pin e'
#  la sola cosa che lega il codice che gira al codice che qualcuno ha
#  letto: RIGA_SOTTILE_ROUND.ps1 inchioda al byte (SHA-256 + pin di
#  commit) i .ps1 che esegue, e RIGA_ROUND_VPS.ps1 scarica il driver da
#  solo, un file alla volta. Con un include il file incluso o viaggia
#  NON pinnato -- e allora il pin non vuol dire piu' niente -- oppure va
#  aggiunto a mano a ogni catena di scaricamento e a ogni elenco di
#  impronte: tre punti nuovi in cui sbagliare, per risparmiare una copia.
#  Fra comodo e stretto, stretto: si duplica, si DICHIARA, e si mette una
#  macchina a controllare che le copie non divergano.
#
#  COSA DEFINISCE -- e nient'altro: qui dentro NON si stampa, non si
#  legge il disco, non si toccano processi. E' PURO apposta, cosi' il
#  banco lo puo' ESEGUIRE su Linux con pwsh, senza MT5 e senza VPS:
#     $BERSAGLI_PER_MACCHINA   tabella: una macchina -> UN solo terminale
#     $TERMINALI_VIETATI       i divieti per nome, consultati PRIMA
#     NormalizzaPercorsoWin / RadiceDiDisco / NomeMacchinaPulito
#     RigaMacchina / ElencoMacchineAmmesse / TabellaCoerente
#     MotivoRifiutoBersaglio   <- IL VERDETTO ("" = ammesso)
#
#  CHI LO USA DEVE FARE QUATTRO COSE, subito sotto (vedi l'ADATTATORE di
#  questo file, che sta fuori dal blocco apposta):
#     1. $MACCHINA = NomeMacchinaPulito $env:COMPUTERNAME
#     2. TabellaCoerente          -> se non torna "", si muore
#     3. MotivoRifiutoBersaglio <chiesto> $MACCHINA -> se non torna "",
#        si muore, e si stampa il motivo per intero
#     4. da li' in avanti si usa LA COSTANTE della tabella (.perc), MAI
#        la stringa arrivata da fuori: e' quella riga che impedisce a
#        $cartellaBT di diventare "C:\" per colpa di un argomento.
#
#  NOTA PER CHI TOCCA QUESTE RIGHE: i due marcatori che il banco usa come
#  confini (quelli del blocco collaudabile, qui sotto) devono comparire
#  in ogni file UNA VOLTA SOLA CIASCUNO. Misurato l'11/09/2026
#  sbagliando: una seconda occorrenza dentro un commento aveva accorciato
#  il blocco estratto da centocinque righe a nove, e il verdetto era
#  "RIFIUTATO" su tutto, banco compreso -- per un difetto del banco e non
#  della guardia.
# =====================================================================
# ===== BLOCCO COLLAUDABILE OFFLINE: INIZIO =====
# Tutto cio' che sta fra questo marcatore e quello di FINE e' PURO: non
# legge il disco, non tocca processi, non stampa niente. Serve perche' il
# banco lo possa estrarre ed ESEGUIRE su Linux con pwsh, senza MT5 e
# senza VPS (banco: backtest_pipeline\banco_guardia_macchina.ps1).
# Il gradino che il disco DEVE fare -- la junction/ReparsePoint -- non sta
# qui: sta al PUNTO 1, perche' nessuna stringa lo sa fare.

# ---------------------------------------------------------------------
#  LA TABELLA DEI BERSAGLI: UNA MACCHINA, UN TERMINALE. (v2, 21/09/2026)
#
#  E' LA COSTANTE DI QUESTO SCRIPT, ed e' la SOLA cosa che il resto usa
#  come bersaglio: la stringa arrivata da fuori serve solo a essere
#  GIUDICATA, mai a essere usata.
#
#  PERCHE' LA MACCHINA E NON IL PERCORSO. Il terminale del PC di backtest
#  ha lo STESSO percorso che sul VPS e' il piccolo 50503392 (sedie vive):
#  un elenco di percorsi ammessi o li ammette tutti e due o li vieta tutti
#  e due, e nessuna delle due cose e' giusta. La macchina li distingue.
#
#  FAIL-CLOSED: una macchina che non e' qui dentro NON ha bersagli. Non
#  esiste un ripiego "non la riconosco, allora lascio passare": se domani
#  nascesse un terzo PC, questa tabella si cambia A MANO e si ripassa dal
#  cancello. E' la stessa scelta della guardia positiva dell'11/09: cio'
#  che non e' AMMESSO ESPLICITAMENTE e' vietato, compreso cio' che nascera'
#  domani.
#
#  I NOMI SONO MISURATI, non ricordati:
#   - VMI3047753      = il VPS. Censimento dei sei terminal64 di quella
#                       macchina: report\collaudi\CENSIMENTO_MT5_VPS_2026-09-12_0846.txt
#                       (li' C:\MT5_Backtest e' il banco, demo 50504400).
#   - DESKTOP-H4D7CAJ = il PC di backtest, utente Master
#                       (report\DAX_STORICO_APERTO_2026-09-10.md r.4;
#                        report\censimento_ordini\riepilogo_DESKTOP-H4D7CAJ.txt r.1;
#                        il terminale: report\COME_ALLUNGARE_STORICO_INDICI_2026-09-09.md r.163).
#
#  >>> E QUI VA LETTA LA RIGA CHE COSTA, prima di lanciare un round sul
#  PC di backtest: quel terminale NON e' un banco solo-tester come
#  C:\MT5_Backtest. E' LOGGATO SUL DEMO PICCOLO 50503392, e il 14/08/2026
#  da quella macchina sono PARTITI ORDINI VERI -- #3160534 / #3160535,
#  -104,60 sul piccolo (report\DAX_14-08_DUE_MOTORI.md r.401; HANDOFF.md
#  r.1463). Quindi: -ChiudiBacktest li' chiude un terminale che ha un
#  conto vivo dentro, e PRIMA si guarda che non abbia sedie attaccate.
#  Lo script lo dice da solo, a schermo e nel referto (AVVERTENZA), ma
#  sapere non e' controllare: il controllo e' un gesto umano. <<<
# ---------------------------------------------------------------------
$BERSAGLI_PER_MACCHINA = @(
  @{ macchina = "VMI3047753"
     perc     = "C:\MT5_Backtest"
     conto    = "50504400"
     comequi  = "il banco solo-tester del VPS"
     # $false = su questa macchina NESSUN percorso della lista dei vietati
     #          puo' essere ammesso, per nessuna ragione.
     deroga   = $false },
  @{ macchina = "DESKTOP-H4D7CAJ"
     perc     = "C:\Program Files\BCM Markets MT5 Terminal"
     conto    = "50503392"
     comequi  = "il terminale del PC di backtest (ATTENZIONE: conto vivo, vedi sopra)"
     # $true = su QUESTA macchina, e SOLO qui, il percorso del piccolo e'
     #         il bersaglio legittimo. PERCHE': sul VPS quel percorso e' la
     #         cartella programma del 50503392 CON LE SEDIE SOPRA; sul PC
     #         di backtest e' l'unico MT5 installato, quello dove vivono i
     #         simboli _EXT e dove i round hanno sempre girato fino
     #         all'08/09. Stesso testo, due macchine, due cose diverse.
     #         La deroga NON e' un permesso generico: vale SOLO per il
     #         percorso che, normalizzato, e' IDENTICO a 'perc' qui sopra
     #         -- quindi "...MT5 Terminal -V3" (il 100k) resta VIETATO
     #         anche qui, perche' non e' lo stesso percorso.
     deroga   = $true }
)

# I vietati per NOME. NON decidono da soli qual e' il bersaglio -- decide
# la tabella qui sopra -- ma servono a tre cose che contano: dare il
# messaggio GIUSTO (chi e' il terminale che stavi per toccare, col suo
# numero di conto in chiaro, regola dei terminali multipli del 06/09),
# fare da seconda rete se un domani qualcuno allentasse il confronto, e
# -- dalla v2 -- essere consultati PRIMA della tabella per macchina, cosi'
# che un terminale vietato resti vietato SU QUALUNQUE MACCHINA.
# 21/09/2026: la lista e' stata ALLARGATA, mai accorciata. Entrano la
# challenge FTMO (sei sedie vive, e' la cosa piu' pericolosa che ci sia
# adesso sul VPS) e il terminale manuale, che nella v1 non erano nominati
# da nessuna parte: erano rifiutati lo stesso dal confronto positivo, ma
# senza dire CHI erano.
$TERMINALI_VIETATI = @(
  @{ p = "BCM_Reale";                chi = "il terminale del conto REALE 10105439" },
  @{ p = "-V3";                      chi = "il terminale del 100k, conto 50504263" },
  @{ p = "BCM Markets MT5 Terminal"; chi = "un terminale con SEDIE VIVE sopra: il piccolo 50503392 (e il 100k, che sta nella stessa famiglia di cartelle)" },
  @{ p = "10105439";                 chi = "il conto REALE" },
  @{ p = "50504263";                 chi = "il 100k" },
  @{ p = "50503392";                 chi = "il piccolo" },
  @{ p = "FTMO";                     chi = "il terminale della CHALLENGE FTMO viva, conto 541452707 (C:\FTMO): sei sedie che stanno operando" },
  @{ p = "541452707";                chi = "il conto della challenge FTMO" },
  @{ p = "MT5_MANUALE";              chi = "il terminale del trading a mano, conto 50503635" },
  @{ p = "50503635";                 chi = "il conto del trading a mano" }
)

# Canonicalizza UNA SCRITTURA DI PERCORSO DI WINDOWS: '/' diventa '\',
# i separatori doppi si collassano, '.' e '..' si risolvono, il
# separatore finale sparisce. Torna "" quando la forma NON e' riducibile
# a un percorso ancorato a una lettera di disco -- e "" vuol dire NO.
# Regola dichiarata: cio' che non so risolvere lo RIFIUTO, non lo
# indovino. L'errore cade sempre verso il no.
#
# PERCHE' NON USO [IO.Path]::GetFullPath(), che farebbe le prime quattro
# cose da solo: perche' il suo risultato DIPENDE DALLA PIATTAFORMA e dal
# runtime. Su Linux -- dove questa guardia e' stata collaudata riga per
# riga -- '\' non e' un separatore e GetFullPath("C:\MT5_Backtest")
# torna "<cartella corrente>/C:\MT5_Backtest"; fra .NET Framework 4 (il
# VPS) e .NET Core cambia anche il trattamento di punti e spazi finali.
# Una guardia il cui significato cambia col runtime e' una guardia che
# non si puo' collaudare, e una che non si puo' collaudare non si sa se
# protegge. Questa fa lo stesso identico conto ovunque.
# Il pezzo che il DISCO deve dire (e che nessuna stringa sa) e' un altro,
# ed e' l'attributo ReparsePoint: sta al PUNTO 1, non qui.
# 21/09/2026: NON e' stata toccata. Regge anche i percorsi con spazi
# dentro ("C:\Program Files\...") perche' non ha mai spezzato sugli spazi
# -- spezza solo su '\' -- ed e' stato ri-collaudato apposta.
function NormalizzaPercorsoWin([string]$p){
  if($null -eq $p){ return "" }
  $s = ("" + $p).Trim()
  if($s -eq ""){ return "" }
  $s = $s.Replace("/","\")
  if($s.Contains("~")){ return "" }              # nome 8.3 (PROGRA~1): espanderlo richiede Win32, quindi si rifiuta
  if($s -match '[\*\?\[\]"|<>]'){ return "" }    # jolly e caratteri che in un percorso non ci vanno
  if($s -notmatch '^[A-Za-z]:\\'){ return "" }   # solo "X:\...": niente UNC, niente \\?\, niente "C:senza-barra"
  $disco = $s.Substring(0,2).ToUpper()
  $resto = $s.Substring(2)
  if($resto.Contains(":")){ return "" }          # un secondo ':' non e' un percorso (flusso NTFS, argomenti incollati)
  $pezzi = New-Object System.Collections.ArrayList
  foreach($t in $resto.Split("\")){
    if($t -eq "" -or $t -eq "."){ continue }
    if($t -eq ".."){
      if($pezzi.Count -eq 0){ return "" }        # si risale sopra la radice: forma senza senso
      $pezzi.RemoveAt($pezzi.Count - 1)
      continue
    }
    [void]$pezzi.Add($t)
  }
  if($pezzi.Count -eq 0){ return ($disco + "\") }   # la RADICE di un disco: normalizzata, e rifiutata piu' sotto
  return ($disco + "\" + ($pezzi -join "\"))
}

# La radice di un disco ("C:\", "D:\") non e' un terminale: e' TUTTO il
# disco. Ha una riga sua perche' merita un messaggio suo -- con un
# bersaglio cosi' la pipe di chiusura diventa "C:\*", cioe' ogni
# terminal64 della macchina, conto reale compreso.
function RadiceDiDisco([string]$norm){
  if($null -eq $norm){ return $false }
  return ($norm -match '^[A-Za-z]:\\$')
}

# Il nome della macchina, ripulito. $env:COMPUTERNAME non dovrebbe avere
# spazi in coda, ma "non dovrebbe" non e' una misura: un nome passato a
# mano per collaudo, o un valore che arriva da un file, li puo' avere, e
# " VMI3047753 " non deve valere meno di "VMI3047753". Il Trim e' l'UNICA
# liberta' concessa: nient'altro viene normalizzato.
function NomeMacchinaPulito([string]$m){
  if($null -eq $m){ return "" }
  return ("" + $m).Trim()
}

# Trova la riga della tabella per una macchina. Torna $null se non c'e':
# ed e' il $null che fa la guardia fail-closed, perche' senza riga non
# esiste nessun bersaglio ammesso.
# CONFRONTO ORDINALE, come sui percorsi e per lo stesso identico motivo
# (vedi MotivoRifiutoBersaglio): il -eq di PowerShell passa dalla CULTURA
# del thread, e sotto una cultura certi caratteri invisibili vengono
# IGNORATI nel confronto -- cioe' due stringhe DIVERSE risultano uguali.
# Qui si guardano i byte. IgnoreCase si': i nomi NetBIOS di Windows non
# distinguono maiuscole e minuscole, e 'desktop-h4d7caj' e'
# LA STESSA MACCHINA di 'DESKTOP-H4D7CAJ'.
function RigaMacchina([string]$macchina){
  $m = NomeMacchinaPulito $macchina
  if($m -eq ""){ return $null }
  foreach($b in $BERSAGLI_PER_MACCHINA){
    if([string]::Equals($m, $b.macchina, [StringComparison]::OrdinalIgnoreCase)){ return $b }
  }
  return $null
}

# L'elenco, in chiaro, di chi e' ammesso dove. Serve al messaggio di
# rifiuto: una guardia che dice NO senza dire "e allora cosa si fa"
# costringe chi la incontra a indovinare, e chi indovina forza.
function ElencoMacchineAmmesse(){
  $righe = @()
  foreach($b in $BERSAGLI_PER_MACCHINA){
    $righe += ("      " + $b.macchina.PadRight(18) + " -> " + $b.perc + "   (conto " + $b.conto + ")")
  }
  return ($righe -join "`n")
}

# IL GUARDIANO DEL GUARDIANO. La tabella e' scritta a mano, e una tabella
# scritta a mano si sbaglia: un percorso con un jolly dentro finirebbe
# nella pipe di chiusura ($cartellaBT + "\*") e la allargherebbe, una
# radice di disco la farebbe diventare "C:\*", un nome di macchina doppio
# renderebbe il bersaglio dipendente dall'ordine delle righe. Si controlla
# qui, all'avvio, e si muore prima di toccare qualunque cosa.
function TabellaCoerente(){
  if($BERSAGLI_PER_MACCHINA.Count -eq 0){ return "la tabella dei bersagli e' VUOTA: nessuna macchina puo' girare." }
  $visti = @()
  foreach($b in $BERSAGLI_PER_MACCHINA){
    $m = NomeMacchinaPulito $b.macchina
    if($m -eq ""){ return "una riga della tabella non ha il nome della macchina." }
    foreach($v in $visti){
      if([string]::Equals($m, $v, [StringComparison]::OrdinalIgnoreCase)){ return ("la macchina '" + $m + "' compare DUE VOLTE nella tabella: il bersaglio dipenderebbe dall'ordine delle righe.") }
    }
    $visti += $m
    $n = NormalizzaPercorsoWin $b.perc
    if($n -eq ""){ return ("il bersaglio di '" + $m + "' non e' un percorso di Windows riconducibile: '" + $b.perc + "'.") }
    if(RadiceDiDisco $n){ return ("il bersaglio di '" + $m + "' e' la RADICE di un disco: '" + $b.perc + "'. La pipe di chiusura diventerebbe '" + $n + "*'.") }
    if(-not [string]::Equals($n, $b.perc, [StringComparison]::Ordinal)){
      return ("il bersaglio di '" + $m + "' non e' scritto in forma canonica: '" + $b.perc + "' si normalizza in '" + $n + "'. Si scrive gia' normalizzato, cosi' il confronto e' una lettura e non un calcolo.")
    }
  }
  return ""
}

# IL VERDETTO SUL BERSAGLIO, in una funzione sola e senza effetti: torna
# "" se il bersaglio e' quello ammesso SU QUESTA MACCHINA, altrimenti il
# MOTIVO del rifiuto.
#
# L'ORDINE DEI CONTROLLI E' SCELTO, e la scelta e' la guardia:
#   1. il VUOTO, che ha un messaggio suo;
#   2. i VIETATI PER NOME, PRIMA della tabella per macchina e con la
#      precedenza su di essa (requisito firmato): il reale 10105439, il
#      100k -V3, la challenge FTMO restano vietati SU QUALUNQUE MACCHINA,
#      anche su una che non e' in tabella, anche se domani qualcuno
#      sbagliasse a scrivere la tabella. L'UNICA deroga e' il percorso del
#      piccolo sulla SOLA DESKTOP-H4D7CAJ, e per applicarla servono TRE
#      cose insieme: la macchina in tabella, il suo flag deroga, e il
#      percorso che normalizzato coincide ESATTAMENTE col suo bersaglio.
#      Nota: la riga della tabella si LEGGE prima (serve alla deroga) ma
#      non ASSOLVE niente -- e su una macchina sconosciuta e' $null,
#      quindi nessuna deroga e' possibile. Leggere non e' decidere.
#   3. la MACCHINA: se non e' in tabella si rifiuta, dicendo il nome
#      trovato e i nomi ammessi (FAIL-CLOSED);
#   4. la NORMALIZZAZIONE e la RADICE DI DISCO, come nella v1;
#   5. il confronto POSITIVO col bersaglio DI QUELLA MACCHINA.
# Il punto 5 da solo basterebbe a rifiutare tutto quanto: gli altri
# servono a dire PERCHE', e il perche' e' cio' che impedisce a chi legge
# il messaggio di aggirare la guardia per tentativi.
function MotivoRifiutoBersaglio([string]$chiesto,[string]$macchina){
  $g = ("" + $chiesto).Trim()
  $m = NomeMacchinaPulito $macchina

  # si LEGGE la riga (serve alla deroga), non si decide ancora niente
  $riga = RigaMacchina $m
  $n    = NormalizzaPercorsoWin $g

  foreach($v in $TERMINALI_VIETATI){
    if($g -like ("*" + $v.p + "*")){
      $derogato = $false
      if($null -ne $riga -and $riga.deroga -and $n -ne "" -and [string]::Equals($n, $riga.perc, [StringComparison]::OrdinalIgnoreCase)){ $derogato = $true }
      if(-not $derogato){
        return ("TERMINALE VIETATO: '" + $g + "' nomina " + $v.chi + ".")
      }
    }
  }

  if($null -eq $riga){
    return ("MACCHINA SCONOSCIUTA: questa macchina si chiama '" + $m + "' e NON e' nella tabella dei bersagli.`n" +
            "    Le macchine ammesse, e il solo terminale ammesso su ognuna, sono:`n" +
            (ElencoMacchineAmmesse) + "`n" +
            "    Non esiste un ripiego: una macchina che non conosco non ha bersagli, perche'`n" +
            "    non so quali MT5 ci vivano sopra ne' quali conti abbiano dentro. Se il round`n" +
            "    deve girare davvero qui, si AGGIUNGE la riga alla tabella, a mano, e si`n" +
            "    ripassa dal cancello.")
  }

  # IL VUOTO SI GIUDICA QUI, DOPO LA MACCHINA, e l'ordine non e' estetica:
  # su una macchina sconosciuta il motivo VERO e' la macchina (il bersaglio
  # e' vuoto proprio PERCHE' non c'e' una riga da cui prenderlo), e un
  # messaggio che accusa la cosa sbagliata manda chi legge a cercare dove
  # non c'e' niente. Misurato eseguendo, il 21/09: con il controllo prima,
  # la macchina sconosciuta usciva come "BERSAGLIO VUOTO".
  if($g -eq ""){
    return ("BERSAGLIO VUOTO: -TerminaleBacktest non dice niente.`n" +
            "    Su '" + $riga.macchina + "' il bersaglio sarebbe " + $riga.perc + " (conto " + $riga.conto + "):`n" +
            "    o lo si passa, o lo si lascia fuori del tutto e lo mette la tabella. Una`n" +
            "    stringa di soli spazi non e' nessuna delle due cose.")
  }

  if($n -eq ""){
    return ("BERSAGLIO NON RICONDUCIBILE A UNA CARTELLA DI WINDOWS: '" + $g + "'." +
            " Un nome 8.3 (PROGRA~1 = C:\Program Files scritto in un altro modo), un" +
            " percorso di rete, un \\?\, un carattere jolly o un percorso non ancorato" +
            " a un disco non si indovinano: si rifiutano.")
  }
  if(RadiceDiDisco $n){
    return ("RADICE DI UN DISCO: '" + $g + "'. Un disco intero non e' un terminale:" +
            " con un bersaglio cosi' la pipe di chiusura diventa '" + $n + "*', cioe'" +
            " OGNI terminal64 della macchina.")
  }
  # Confronto ORDINALE, non -ieq. Il -eq di PowerShell passa dalla CULTURA
  # del thread, e una regola di casa di questo stesso file e' che la cultura
  # non deve mai entrare in un confronto (vedi NumInv, qui sopra): su un
  # confronto culturale certi caratteri invisibili vengono IGNORATI, cioe'
  # due stringhe diverse risultano uguali. Qui si guardano i byte.
  if(-not [string]::Equals($n, $riga.perc, [StringComparison]::OrdinalIgnoreCase)){
    return ("NON E' IL BERSAGLIO DI QUESTA MACCHINA: '" + $g + "' (normalizzato: '" + $n + "').`n" +
            "    Su '" + $riga.macchina + "' l'unico terminale ammesso e' " + $riga.perc + " (conto " + $riga.conto + ").`n" +
            "    Attenzione: un percorso puo' essere legittimo su UN'ALTRA macchina e non qui.`n" +
            "    E' il caso di C:\MT5_Backtest, che e' il banco del VPS e sul PC di backtest`n" +
            "    non esiste. Il bersaglio lo decide la MACCHINA, non il testo del percorso.")
  }
  return ""
}
# ===== BLOCCO COLLAUDABILE OFFLINE: FINE =====
# ---------------------------------------------------------------------
#  GUARDIA_BANCO_POSITIVA_v2 -- FINE DEL BLOCCO CONDIVISO
# ---------------------------------------------------------------------

# =====================================================================
#  0. IL PRE-VOLO SUI PARAMETRI
# =====================================================================
Write-Host "=== ROUND SUL TERMINALE DA BACKTEST ==="
Write-Host ("    " + $MARC_MIO) -ForegroundColor DarkGray
Write-Host ("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss"))
Write-Host ("pin : " + $Pin)
# v2: la macchina si DICHIARA, e si dichiara PRIMA di tutto il resto.
# Regola dei terminali multipli (06/09 e 12/09): chi legge deve sapere
# su che ferro sta girando la riga senza doverlo dedurre.
$MACCHINA = NomeMacchinaPulito $env:COMPUTERNAME
Write-Host ("pc  : " + $(if($MACCHINA -ne ""){$MACCHINA}else{"<COMPUTERNAME VUOTO>"}))
Write-Host ("term: " + $(if(("" + $TerminaleBacktest).Trim() -ne ""){$TerminaleBacktest}else{"<non passato: lo decide la tabella per macchina>"}))

if(-not (NomeValido $Expert)){ Muori ("nome EA non valido: '" + $Expert + "'. Va passato il nome del .mq5 SENZA estensione e senza percorso (es. ABTG_OpeningReversalB).") }
if(-not (NomeValido $Prova)) { Muori ("nome del file prova non valido: '" + $Prova + "'. Va passato il NOME del file dentro backtest_pipeline\prove\ (es. ABTG_OpeningReversalB_00_conta.txt).") }
if(-not (EtichettaValida $Etichetta)){
  Muori ("etichetta non valida: '" + $Etichetta + "'. Ammesse lettere, cifre e underscore.`n" +
         "    L'etichetta e' il suffisso dei CSV: senza, un round nuovo SOVRASCRIVE il precedente.")
}
if($Modello -lt 0 -or $Modello -gt 4){ Muori ("-Modello ammette 0..4. Ricevuto: " + $Modello + " (4 = tick reali, la verita'; 1 = OHLC M1, SOLO screening).") }
if($Modello -ne 4){
  Write-Host ""
  Write-Host ("    ATTENZIONE: -Modello " + $Modello + ", NON tick reali. I CSV escono col suffisso _ohlc") -ForegroundColor Yellow
  Write-Host "    e servono SOLO a scremare: da qui non esce nessun verdetto." -ForegroundColor Yellow
  Rilievo ("round girato a Modello " + $Modello + " (non tick reali): screening, non verdetto")
}
if($Deposito -le 0){ Muori ("-Deposito deve essere positivo. Ricevuto: " + $Deposito) }

# =====================================================================
#  1. IL TERMINALE: LA GUARDIA E' POSITIVA **E PER MACCHINA**
#     (positiva dall'11/09/2026, per macchina dal 21/09/2026)
#
#  COSA E' CAMBIATO IL 21/09 E PERCHE' NON BASTAVA LA v1.
#  La v1 ammetteva UN percorso solo, C:\MT5_Backtest. Giusto finche' i
#  round giravano SOLO sul VPS -- ma quel terminale STA sul VPS, e dal
#  21/09 (firma di Claudio in CLAUDE.md, dopo che un backtest a tick
#  reali ha inchiodato la macchina mentre sei sedie FTMO operavano) i
#  round devono girare sul PC DI BACKTEST. Con la v1 la firma non era
#  eseguibile: -TerminaleBacktest rifiutava per costruzione qualunque
#  cosa non fosse il banco del VPS.
#  E non si poteva semplicemente "aggiungere un percorso alla lista":
#  il terminale del PC di backtest e' C:\Program Files\BCM Markets MT5
#  Terminal, che sul VPS e' IL PICCOLO 50503392 con le sedie vive.
#  Lo stesso testo doveva diventare AMMESSO di qua e VIETATO di la'.
#  L'unica cosa che distingue i due casi e' LA MACCHINA: quindi la
#  macchina e' entrata nella guardia, con una tabella, confronto
#  ordinale e FAIL-CLOSED (vedi il blocco collaudabile, in cima).
#
#  E LA v1 RESTA TUTTA: quello che segue non e' stato indebolito.
#
#  PRIMA ERA NEGATIVA, E PERDEVA. Diceva "non deve essere -V3 ne'
#  BCM_Reale". Eseguita con pwsh contro bersagli finti, lasciava passare
#  QUATTRO cose, e tre sono terminali veri di questa macchina:
#    C:\Program Files\BCM Markets MT5 Terminal  -> PASSAVA. E' il
#        PICCOLO 50503392, che ha sedie VIVE sopra.
#    C:\  -> PASSAVA la guardia. E li' il danno non e' teorico: la pipe
#        di chiusura poco piu' sotto e' ($cartellaBT + "\*"), che con la
#        radice diventa "C:\*" = OGNI terminal64 del disco, il conto
#        REALE 10105439 compreso.
#    C:\PROGRA~1\BCMMAR~1 -> PASSAVA. E' lo stesso posto di sopra
#        scritto in nome 8.3: la lista guarda le lettere, non il posto.
#    C:\MT5_Backtest\..\Program Files\BCM Markets MT5 Terminal ->
#        PASSAVA (trovata mentre si riparava): il nome del banco c'e',
#        ma il '..' porta altrove.
#  E' il gemello esatto del buco che il cancello del runner ha riparato
#  la mattina dell'11/09: una lista di divieti non vede il bersaglio che
#  nessuno ci ha ancora messo. Quando e' comparso un QUARTO conto che
#  nessuno conosceva (109k), a fermarlo e' stato il cancello POSITIVO.
#
#  ADESSO DICE UNA COSA SOLA: DEVE ESSERE IL BERSAGLIO DI QUESTA
#  MACCHINA. Un percorso ammesso PER MACCHINA (v2: la tabella
#  $BERSAGLI_PER_MACCHINA), confrontato DOPO normalizzazione. Tutto il
#  resto muore, compreso cio' che non e' in nessuna lista, compreso cio'
#  che e' legittimo SU UN'ALTRA MACCHINA, e compreso cio' che nascera'
#  domani -- macchine nuove incluse, che senza una riga in tabella non
#  hanno nessun bersaglio.
#
#  E LA NORMALIZZAZIONE E' IL PUNTO DELICATO, percio' e' scritta a
#  gradini e OGNI GRADINO CADE VERSO IL NO (NormalizzaPercorsoWin, in
#  cima al file, collaudabile offline):
#    a) passano solo le forme "X:\..."; niente UNC, niente \\?\, niente
#       "C:senza-barra" (che dipende dalla cartella corrente del disco);
#    b) '/' vale '\', i separatori doppi si collassano, '.' e '..' si
#       risolvono: sono MODI DIVERSI DI SCRIVERE LO STESSO POSTO, ed e'
#       giusto che passino -- ma solo se il posto e' il banco;
#    c) il nome 8.3 NON si indovina (espanderlo vuol dire chiamare Win32):
#       si RIFIUTA, e chi ha una ragione per usarlo scrive il nome lungo;
#    d) i jolly (* ? [ ]) si rifiutano: il bersaglio finisce dentro un
#       -like, e li' una parentesi quadra cambia il significato del
#       confronto;
#    e) il confronto e' con la COSTANTE, e da qui in avanti si usa LA
#       COSTANTE: la stringa che arriva da fuori viene giudicata e poi
#       buttata;
#    f) l'ultimo gradino lo fa il DISCO, non la stringa: se il nome
#       giusto fosse una JUNCTION verso un'altra cartella, nessun
#       controllo sul testo se ne accorgerebbe. L'attributo ReparsePoint
#       si'.
# =====================================================================
# 1a. IL GUARDIANO DEL GUARDIANO, prima di ogni altra cosa: se la tabella
#     scritta a mano fosse sbagliata, la guardia direbbe SI' a un bersaglio
#     sbagliato e nessuno se ne accorgerebbe.
$motivoTab = TabellaCoerente
if($motivoTab -ne ""){
  Muori ("LA TABELLA DEI BERSAGLI E' SCRITTA MALE: " + $motivoTab + "`n" +
         "    Non parto: una guardia che si regge su una tabella rotta non e' una guardia.`n" +
         "    Si corregge `$BERSAGLI_PER_MACCHINA in questo file e si ripassa dal cancello.")
}

# 1b. LA RIGA DI QUESTA MACCHINA. Se non c'e', il bersaglio non si
#     inventa: la guardia dira' di no due righe piu' sotto.
$rigaMac = RigaMacchina $MACCHINA

# 1c. IL BERSAGLIO NON PASSATO SI RISOLVE, NON SI INDOVINA. Un default
#     cablato su un percorso (com'era nella v1) e' giusto su una macchina
#     sola e sbagliato su tutte le altre. Su una macchina sconosciuta
#     resta vuoto apposta: il vuoto non e' un permesso, e viene rifiutato.
if(("" + $TerminaleBacktest).Trim() -eq "" -and $null -ne $rigaMac){
  $TerminaleBacktest = $rigaMac.perc
  Write-Host ""
  Write-Host ("    -TerminaleBacktest non passato: su " + $rigaMac.macchina + " il bersaglio e' " + $rigaMac.perc) -ForegroundColor DarkGray
  Write-Host  "    (e passa comunque da TUTTI i controlli qui sotto, come se l'avessi scritto tu)." -ForegroundColor DarkGray
}

# 1d. IL VERDETTO.
$motivoNo = MotivoRifiutoBersaglio $TerminaleBacktest $MACCHINA
if($motivoNo -ne ""){
  # La tabella si stampa UNA volta sola: il motivo "MACCHINA SCONOSCIUTA"
  # la porta gia' dentro, e ripeterla qui farebbe leggere due volte la
  # stessa cosa a chi ha gia' un errore da capire.
  $codaTabella = ""
  if($motivoNo -notlike "MACCHINA SCONOSCIUTA*"){
    $codaTabella = ("    LA TABELLA DEI BERSAGLI -- una macchina, un terminale:`n" + (ElencoMacchineAmmesse) + "`n")
  }
  Muori ($motivoNo + "`n" +
         $codaTabella +
         "    Gli altri MT5 di queste macchine hanno SEDIE VIVE sopra e non si toccano:`n" +
         "    il piccolo 50503392, il 100k 50504263, il conto REALE 10105439, la`n" +
         "    challenge FTMO 541452707 (C:\FTMO) e il manuale 50503635.`n" +
         "    La guardia e' POSITIVA E PER MACCHINA: non elenca i vietati, ammette UN`n" +
         "    terminale su UNA macchina. Se un bersaglio cambiasse casa, o nascesse una`n" +
         "    macchina nuova, si cambia LA TABELLA, a mano, e si ripassa dal cancello.")
}

# LA COSTANTE, NON LA STRINGA DI FUORI. E' questa riga che chiude il buco
# della radice del disco: la pipe qui sotto e' SEMPRE "C:\MT5_Backtest\*"
# e non puo' diventare "C:\*" per colpa di come e' stato scritto un
# argomento. Vale anche per il valore passato al driver, piu' sotto.
$BERSAGLIO_PERC  = $rigaMac.perc
$BERSAGLIO_CONTO = $rigaMac.conto
$cartellaBT      = $BERSAGLIO_PERC
Write-Host ("    bersaglio AMMESSO su " + $rigaMac.macchina + ": " + $cartellaBT + "   (conto " + $BERSAGLIO_CONTO + ")") -ForegroundColor Green

# L'AVVERTENZA CHE COSTA, e si stampa SOLO dove e' vera. Sul PC di
# backtest il bersaglio NON e' un banco solo-tester: e' un terminale
# loggato su un conto vivo (il demo piccolo 50503392) e il 14/08/2026 da
# quella macchina sono PARTITI ordini veri (#3160534/#3160535, -104,60).
# Non e' un RILIEVO -- non sporca l'esito del round, che parla dei numeri
# usciti -- ma va detto a schermo e messo nel referto, perche' chi lancia
# deve sapere CHE COSA sta per chiudere con -ChiudiBacktest.
$AVVERTENZA_BERSAGLIO = ""
if($rigaMac.deroga){
  $AVVERTENZA_BERSAGLIO = ("il bersaglio su " + $rigaMac.macchina + " NON e' un banco solo-tester: e' loggato sul conto " +
                           $BERSAGLIO_CONTO + " e il 14/08/2026 da questa macchina sono PARTITI ordini veri " +
                           "(#3160534/#3160535, -104,60). Prima di un round: controlla che non abbia SEDIE attaccate.")
  Write-Host ""
  Write-Host "    +---------------------------------------------------------------+" -ForegroundColor Yellow
  Write-Host "    | AVVERTENZA SUL BERSAGLIO -- LEGGERE PRIMA DI -ChiudiBacktest   |" -ForegroundColor Yellow
  Write-Host "    +---------------------------------------------------------------+" -ForegroundColor Yellow
  Write-Host ("    Questo terminale e' loggato sul conto " + $BERSAGLIO_CONTO + " (demo piccolo), NON e'") -ForegroundColor Yellow
  Write-Host  "    un banco solo-tester come C:\MT5_Backtest sul VPS." -ForegroundColor Yellow
  Write-Host  "    Il 14/08/2026 da QUESTA macchina sono partiti ordini veri:" -ForegroundColor Yellow
  Write-Host  "    #3160534 / #3160535 -> -104,60 sul piccolo (DAX_14-08_DUE_MOTORI.md r.401)." -ForegroundColor Yellow
  Write-Host  "    Prima di lanciare: guarda che non abbia SEDIE attaccate ai grafici." -ForegroundColor Yellow
}

if(-not (Test-Path -LiteralPath $cartellaBT -PathType Container)){ Muori ("la cartella '" + $cartellaBT + "' non esiste su questa macchina.") }

# IL GRADINO CHE NESSUNA STRINGA PUO' FARE. Un nome giusto puo' puntare
# nel posto sbagliato: basta che la cartella sia una junction o un link
# simbolico. Il testo e' identico, il posto no -- e quello lo sa solo il
# filesystem. Se e' un collegamento non si parte: non si indovina dove va.
$infoBT = $null
try  { $infoBT = Get-Item -LiteralPath $cartellaBT -Force -ErrorAction Stop }
catch{ $infoBT = $null }
if($null -eq $infoBT){
  Muori ("la cartella '" + $cartellaBT + "' non e' leggibile: non posso dire DOVE punta, e quindi non parto.")
}
if((([int]$infoBT.Attributes) -band ([int][IO.FileAttributes]::ReparsePoint)) -ne 0){
  Muori ("IL BERSAGLIO E' UN COLLEGAMENTO: '" + $cartellaBT + "' non e' una cartella vera,`n" +
         "    e' una junction (o un link simbolico) che rimanda altrove. Il nome e'`n" +
         "    quello giusto, il posto potrebbe non esserlo, e nessun controllo sulla`n" +
         "    STRINGA se ne accorgerebbe.`n" +
         "    Se il terminale " + $BERSAGLIO_CONTO + " e' davvero installato cosi', si guarda insieme`n" +
         "    dove punta e si cambia LA TABELLA. Non si tira a indovinare.")
}

$exeBT = Join-Path $cartellaBT "terminal64.exe"
if(-not (Test-Path -LiteralPath $exeBT -PathType Leaf)){ Muori ("in '" + $cartellaBT + "' non c'e' terminal64.exe: va passata la CARTELLA PROGRAMMA del terminale.") }

# --- censimento PRIMA. Il bersaglio e' UNO SOLO: quello sotto $cartellaBT.
function Terminali(){ return @(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) }
function Bersagli($proc){ return @($proc | Where-Object { $_.Path -and ($_.Path -like ($cartellaBT + "\*")) }) }
function Risparmiati($proc){ return @($proc | Where-Object { -not ($_.Path -and ($_.Path -like ($cartellaBT + "\*"))) }) }

$tutti  = Terminali
$berPri = Bersagli $tutti
$salPri = Risparmiati $tutti
$pidSalvi = @($salPri | ForEach-Object { $_.Id })

Write-Host ""
Write-Host "--- TERMINALI MT5 VISTI ADESSO (PRIMA) ------------------------------" -ForegroundColor Cyan
if($berPri.Count -eq 0){ Write-Host "  BERSAGLIO (terminale da backtest): nessuno vivo. Bene." -ForegroundColor Green }
else{
  Write-Host "  BERSAGLIO (terminale da backtest, l'unico che posso chiudere):" -ForegroundColor Yellow
  $berPri | ForEach-Object { Write-Host ("    PID " + $_.Id + "    " + $_.Path) -ForegroundColor Yellow }
}
Write-Host "  LASCIATI VIVI (forward e CONTO REALE: NON li tocco):" -ForegroundColor Green
if($salPri.Count -eq 0){ Write-Host "    (nessuno)" -ForegroundColor Green }
else{ $salPri | ForEach-Object { Write-Host ("    PID " + $_.Id + "    " + $(if($_.Path){$_.Path}else{"<percorso non leggibile: NON e' un bersaglio>"})) -ForegroundColor Green } }
Write-Host "---------------------------------------------------------------------" -ForegroundColor Cyan

if($berPri.Count -gt 0 -and -not $SoloControllo){
  if($ChiudiBacktest){
    Write-Host ""
    Write-Host "  -ChiudiBacktest: chiudo SOLO il terminale da backtest." -ForegroundColor Yellow
    $berPri | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 6
    $berPri = Bersagli (Terminali)
  }
  if($berPri.Count -gt 0){
    Muori ("il terminale da backtest e' APERTO: il tester non partirebbe e uscirebbero ZERO CSV.`n" +
           "    Chiudi a mano " + $exeBT + " oppure rilancia con -ChiudiBacktest:`n" +
           "    verra' chiuso SOLO quel processo, gli altri terminali (forward e CONTO REALE) restano vivi.")
  }
}

# =====================================================================
#  2. IL TETTO DELLE BARRE NEL GRAFICO (riuso 2 dall'ancora)
#     CLASSE 160: con un tetto a 100.000 il round gira su MENO storico e
#     nessuno lo dice. Su M5 gli indici lo sfondano da soli.
# =====================================================================
$DataFolder = ""
$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
if(Test-Path -LiteralPath $termRoot){
  foreach($d in @(Get-ChildItem -LiteralPath $termRoot -Directory -ErrorAction SilentlyContinue)){
    if($d.Name -ieq "Common"){ continue }
    $o = Join-Path $d.FullName "origin.txt"
    if(-not (Test-Path -LiteralPath $o)){ continue }
    $inst = ""
    try{ $inst = (Get-Content -LiteralPath $o -Raw -ErrorAction Stop).Trim() }catch{ continue }
    if($inst -ieq $cartellaBT){ $DataFolder = $d.FullName; break }
  }
}
if(-not $DataFolder -and (Test-Path -LiteralPath (Join-Path $cartellaBT "config\common.ini"))){ $DataFolder = $cartellaBT }

$MaxBars = TettoBarre $DataFolder
Write-Host ""
if($null -ne $MaxBars -and $MaxBars -ge 1000 -and $MaxBars -lt 200000){
  Muori ("TETTO BARRE NEL GRAFICO = " + $MaxBars + " (config\common.ini di " + $DataFolder + ").`n" +
         "    Serve ILLIMITATO: su M5 gli indici passano le 130.000 barre.`n" +
         "    Con questo tetto il round gira su MENO storico e nessuno lo dice.`n" +
         "    Apri " + $exeBT + " (conto " + $BERSAGLIO_CONTO + "), Strumenti > Opzioni > Grafici >`n" +
         "    'Max barre nel grafico' = Illimitato, CHIUDI il terminale, e rilancia.")
}
elseif($null -ne $MaxBars){ Write-Host ("    tetto barre: MaxBars=" + $MaxBars + " -- sufficiente.") -ForegroundColor Green }
else{
  Write-Host "    tetto barre: NON VERIFICABILE da qui (nessuna chiave MaxBars leggibile)." -ForegroundColor Yellow
  Write-Host "    CONTROLLALO A MANO PRIMA DI LASCIAR GIRARE: Strumenti > Opzioni >" -ForegroundColor Yellow
  Write-Host ("    Grafici > 'Max barre nel grafico' = Illimitato sul terminale " + $BERSAGLIO_CONTO + ".") -ForegroundColor Yellow
  Rilievo "tetto barre nel grafico NON verificato dal codice (chiave MaxBars non trovata)"
}

# =====================================================================
#  3. DRIVER E FILE PROVA, DAL PIN (regola delle righe di lancio, p.1)
#     (riuso 5 dall'ancora: il marcatore del driver si CONTROLLA)
# =====================================================================
$Prove = Join-Path $Work "prove"
New-Item -ItemType Directory -Force -Path $Work  | Out-Null
New-Item -ItemType Directory -Force -Path $Prove | Out-Null

function Scarica($url,$dst){
  Remove-Item -LiteralPath $dst -Force -ErrorAction SilentlyContinue
  $u = $url + "?cb=" + [Guid]::NewGuid().ToString("N")   # cache di GitHub raw (~5 min)
  try  { Invoke-WebRequest -Uri $u -OutFile $dst -UseBasicParsing -TimeoutSec 120 }
  catch{ Muori ("scarico fallito: " + $url + " -- " + $_.Exception.Message) }
  if(-not (Test-Path -LiteralPath $dst)){ Muori ("file non scaricato: " + $url) }
}

$drv = Join-Path $Work "walkforward_generico.ps1"
Scarica ($RawBase + "/backtest_pipeline/walkforward_generico.ps1") $drv
if(-not (Select-String -LiteralPath $drv -SimpleMatch -Pattern $MARC_DRV -Quiet)){
  Muori ("il driver scaricato NON ha il marcatore " + $MARC_DRV + ": e' una copia vecchia. Senza la v5 non porta gli #include nostri sul terminale, l'EA non compila e il round muore con ZERO CSV. Non si prosegue.")
}
Write-Host ""
Write-Host "    driver: scaricato e marcatore v5 verificato." -ForegroundColor Green

$provaLoc = Join-Path $Prove $Prova
Scarica ($RawBase + "/backtest_pipeline/prove/" + $Prova) $provaLoc
$lenProva = (Get-Item -LiteralPath $provaLoc).Length
Write-Host ("    file prova: " + $Prova + " (" + $lenProva + " byte) dal pin " + $Pin) -ForegroundColor Green
if($lenProva -eq 0){ Muori ("il file prova scaricato e' VUOTO: " + $provaLoc) }

# --- il simbolo serve a NOI per sapere come si chiameranno i CSV. Se
#     manca, il driver morirebbe piu' avanti e noi non sapremmo nemmeno
#     cosa cercare: meglio fermarsi adesso, e dire cosa manca.
$Simbolo  = DirettivaProva $provaLoc "SIMBOLO"
$Periodo  = DirettivaProva $provaLoc "PERIODO"
$DaQuando = DirettivaProva $provaLoc "DAQUANDO"
if(-not $Simbolo){ Muori ("nel file prova " + $Prova + " non c'e' la direttiva '@SIMBOLO <SIM>': senza, non so nemmeno come si chiameranno i CSV.") }
if(-not $DaQuando){
  Muori ("nel file prova " + $Prova + " non c'e' la direttiva '@DAQUANDO aaaa.mm.gg'.`n" +
         "    NON si mette a caso: la profondita' vera si MISURA (scarica_storico.ps1 -SoloReferto).")
}
if(-not $Periodo){ $Periodo = "M5 (default del driver)" }
Write-Host ("    prova: simbolo " + $Simbolo + " . periodo " + $Periodo + " . da " + $DaQuando) -ForegroundColor Green

# --- i CSV che questa corsa DEVE produrre. Il suffisso lo decide il
#     driver: "" a tick reali, "_ohlc" altrimenti, poi "_" + etichetta.
$suffMod = if($Modello -eq 4){ "" } else { "_ohlc" }
$Ris     = Join-Path $Work ("risultati_prove\" + $Expert)
$csvIS   = Join-Path $Ris ($Expert + "_" + $Simbolo + "_IS"  + $suffMod + "_" + $Etichetta + ".csv")
$csvOOS  = Join-Path $Ris ($Expert + "_" + $Simbolo + "_OOS" + $suffMod + "_" + $Etichetta + ".csv")

# CLASSE 155, in forma CHIRURGICA: la cartella di lavoro e' riusabile, e
# la raccolta copia PER NOME. Qui NON si rade al suolo risultati_prove
# (ci vivono gli altri round): si cancellano SOLO i due file che questa
# corsa deve riscrivere, e la freschezza si ricontrolla comunque per data.
foreach($f in @($csvIS,$csvOOS)){
  if(Test-Path -LiteralPath $f){
    Remove-Item -LiteralPath $f -Force -ErrorAction SilentlyContinue
    Write-Host ("    tolto il CSV omonimo di una corsa precedente: " + (Split-Path -Leaf $f)) -ForegroundColor DarkYellow
  }
}
$anteprima = Join-Path $Work ("anteprima_" + $Expert + "_" + $Simbolo + ".ini")
Remove-Item -LiteralPath $anteprima -Force -ErrorAction SilentlyContinue

# =====================================================================
#  4. LA CORSA
#     -Force: la guardia "MT5 aperto" del driver e' GLOBALE (classe 159)
#     e sul VPS i terminali sono quattro. Quella CHIRURGICA l'ha gia'
#     fatta questo script: il bersaglio e' chiuso, gli altri restano vivi.
#     -Rifai: senza, il driver SALTA i CSV gia' presenti (classe 15).
# =====================================================================
$arg = @("-NoProfile","-ExecutionPolicy","Bypass","-File",$drv,
         "-Expert",$Expert,"-Prova",$provaLoc,
         "-Etichetta",$Etichetta,"-Modello",("" + $Modello),"-Deposito",("" + $Deposito),
         "-Rifai","-Force","-TerminaleBacktest",$cartellaBT)
if($SoloControllo){ $arg += "-SoloControllo" }

Write-Host ""
Write-Host ("--- " + $Expert + " " + $Simbolo + "   etichetta " + $Etichetta + "   modello " + $Modello + "   deposito " + $Deposito + " ---") -ForegroundColor Cyan
$t0 = Get-Date
$proc = Start-Process -FilePath "powershell.exe" -ArgumentList $arg -NoNewWindow -PassThru -Wait
$rc = $proc.ExitCode
# CLASSE 154: questo rc NON e' il codice del driver, e' quello dell'ultimo
# .exe lanciato dentro (metaeditor esce diverso da 0 anche sui soli
# avvisi). Si STAMPA come informazione; il gate sta sull'ARTEFATTO.
Write-Host ("    rc del driver: " + $rc + "   (informativo: il verdetto sta sui CSV, non qui)") -ForegroundColor DarkGray

# =====================================================================
#  5. IL GIRO A VUOTO: il suo esito dipende dall'ARTEFATTO (classe 14)
# =====================================================================
if($SoloControllo){
  Write-Host ""
  Write-Host "=== GIRO A VUOTO (-SoloControllo): MT5 NON e' stato aperto ===" -ForegroundColor Yellow
  $antOk = (Test-Path -LiteralPath $anteprima) -and ((Get-Item -LiteralPath $anteprima).LastWriteTime -ge $t0)
  if(-not $antOk){
    Write-Host ("  NESSUNA ANTEPRIMA FRESCA in " + $anteprima) -ForegroundColor Red
    Write-Host "  Il giro a vuoto NON e' passato: leggi l'errore del driver qui sopra." -ForegroundColor Red
    exit 1
  }
  Write-Host ("  anteprima .ini fresca: " + $anteprima) -ForegroundColor Green
  Write-Host ""
  Write-Host "  CONTROLLA QUI SOPRA, PRIMA DI LANCIARE LA CORSA VERA:" -ForegroundColor Yellow
  Write-Host "    a) il conto delle CELLE e delle PASSATE torna col file prova;" -ForegroundColor Yellow
  Write-Host "    b) le finestre IS/OOS partono dalla @DAQUANDO misurata;" -ForegroundColor Yellow
  Write-Host ("    c) Symbol=" + $Simbolo + " e Deposit=" + $Deposito + " nell'anteprima.") -ForegroundColor Yellow
  Write-Host "  E QUELLO CHE QUESTO GIRO **NON** COPRE, dichiarato:" -ForegroundColor Yellow
  Write-Host "    - NON compila (checklist 39): un #include mancante salta fuori dopo;" -ForegroundColor Yellow
  Write-Host "    - nell'anteprima Model=4 e' HARDCODED (checklist 31): con -Modello 1" -ForegroundColor Yellow
  Write-Host "      l'anteprima dice comunque 4;" -ForegroundColor Yellow
  Write-Host "    - il driver esce PRIMA di scegliere il terminale: -TerminaleBacktest" -ForegroundColor Yellow
  Write-Host "      NON e' collaudato da questo giro." -ForegroundColor Yellow
  exit 0
}

# =====================================================================
#  6. I CSV: SI LEGGONO, NON SI GIUDICANO
# =====================================================================
$eIS  = LeggiCsvRound $csvIS  $t0
$eOOS = LeggiCsvRound $csvOOS $t0

$blocchi = New-Object System.Collections.ArrayList
foreach($b in (RigheReferto $eIS  "IS  (dentro campione)" $TESTO_TRADES0)){ [void]$blocchi.Add($b) }
[void]$blocchi.Add("")
foreach($b in (RigheReferto $eOOS "OOS (fuori campione)" $TESTO_TRADES0)){ [void]$blocchi.Add($b) }

Write-Host ""
Write-Host "--- I NUMERI, COSI' COME SONO USCITI --------------------------------" -ForegroundColor Cyan
foreach($r in $blocchi){
  $col = "White"
  if($r -like "*NON MISURATO*"){ $col = "Red" }
  elseif($r -like "*>>> Trades=0*"){ $col = "Red" }
  elseif($r -like "*ESITO : LETTO*"){ $col = "Green" }
  Write-Host ("  " + $r) -ForegroundColor $col
}
Write-Host "---------------------------------------------------------------------" -ForegroundColor Cyan

# =====================================================================
#  7. IL CONTO REALE E' INTATTO? SI CONTA, NON SI SPERA (riuso 3)
# =====================================================================
$dopo    = Terminali
$salDopo = Risparmiati $dopo
$pidDopo = @($salDopo | ForEach-Object { $_.Id })
$persi   = @($pidSalvi | Where-Object { $pidDopo -notcontains $_ })
Write-Host ""
Write-Host "--- TERMINALI MT5 (DOPO) --------------------------------------------" -ForegroundColor Cyan
Write-Host ("  PID vivi PRIMA (non bersaglio): " + $(if($pidSalvi.Count -gt 0){$pidSalvi -join " . "}else{"nessuno"}))
Write-Host ("  PID vivi DOPO  (non bersaglio): " + $(if($pidDopo.Count -gt 0){$pidDopo -join " . "}else{"nessuno"}))
if($persi.Count -eq 0){ Write-Host "  STESSI PID: forward e conto reale NON sono stati toccati." -ForegroundColor Green }
else{
  Write-Host ("  MANCANO ALL'APPELLO: " + ($persi -join " . ")) -ForegroundColor Red
  Rilievo ("terminali NON bersaglio spariti durante la corsa: PID " + ($persi -join ", ") + " -- CONTROLLA SUBITO IL CONTO REALE 10105439")
}
Write-Host "---------------------------------------------------------------------" -ForegroundColor Cyan

# =====================================================================
#  8. L'ESITO. Il gate e' sull'ARTEFATTO.
# =====================================================================
$mancanti = @()
if(-not $eIS.Fresco  -or $eIS.NRighe  -eq 0){ $mancanti += "IS" }
if(-not $eOOS.Fresco -or $eOOS.NRighe -eq 0){ $mancanti += "OOS" }
$zero = @()
if($eIS.Fresco  -and $eIS.NRighe  -gt 0 -and $eIS.ConTrades  -eq 0){ $zero += "IS" }
if($eOOS.Fresco -and $eOOS.NRighe -gt 0 -and $eOOS.ConTrades -eq 0){ $zero += "OOS" }

if($mancanti.Count -gt 0){
  $esitoFinale = "NON MISURATO -- CSV mancanti o vuoti: " + ($mancanti -join ", ")
}
elseif($zero.Count -gt 0){
  $esitoFinale = "NON MISURATO -- Trades = 0 su: " + ($zero -join ", ")
}
elseif($persi.Count -gt 0 -or $RILIEVI.Count -gt 0){
  $esitoFinale = "ROUND GIRATO CON RILIEVI (" + $RILIEVI.Count + ")"
}
else{
  $esitoFinale = "ROUND GIRATO"
}

# =====================================================================
#  9. REFERTO + RACCOLTA (riuso 6: regola delle righe di lancio, p.2 e 3)
#     LA RACCOLTA SI FA SEMPRE, anche quando l'esito e' NON MISURATO:
#     "non e' girata" e' gia' una risposta, e il referto va mandato lo
#     stesso (checklist, punto 26-bis).
# =====================================================================
$dsk = [Environment]::GetFolderPath("Desktop")
$d   = Join-Path $dsk ("ROUND_" + $Etichetta)
if(Test-Path -LiteralPath $d){ Remove-Item -LiteralPath $d -Recurse -Force }
New-Item -ItemType Directory -Force -Path $d | Out-Null

$R = New-Object System.Collections.ArrayList
function W($t){ [void]$R.Add($t) }
W ("REFERTO ROUND SUL TERMINALE DA BACKTEST")
W ("marcatore riga  : " + $MARC_MIO)
W ("marcatore driver: " + $MARC_DRV)
W ("pin             : " + $Pin)
W ("data            : " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss") + "   <-- SE QUESTA DATA NON E' DI OGGI, IL FILE E' VECCHIO")
W ("macchina        : " + $MACCHINA + "   (bersaglio ammesso qui: " + $BERSAGLIO_PERC + ", conto " + $BERSAGLIO_CONTO + ")")
W ("terminale       : " + $exeBT)
if($AVVERTENZA_BERSAGLIO -ne ""){ W ("AVVERTENZA      : " + $AVVERTENZA_BERSAGLIO) }
W ("tetto barre     : " + $(if($null -ne $MaxBars){"MaxBars=" + $MaxBars}else{"NON VERIFICATO (chiave MaxBars non trovata)"}))
W ("")
W ("EA              : " + $Expert)
W ("file prova      : " + $Prova + "   (" + $lenProva + " byte, dal pin)")
W ("etichetta       : " + $Etichetta)
W ("simbolo         : " + $Simbolo)
W ("periodo         : " + $Periodo)
W ("da quando       : " + $DaQuando)
W ("modello         : " + $Modello + $(if($Modello -eq 4){"  (tick reali)"}else{"  (NON tick reali: screening, non verdetto)"}))
W ("deposito        : " + $Deposito)
W ("rc del driver   : " + $rc + "   (informativo -- classe 154: e' l'ultimo .exe lanciato dentro, NON il verdetto)")
W ("")
W ("QUESTO REFERTO NON GIUDICA: dice cosa e' uscito. Il verdetto si scrive")
W ("dopo, coi criteri congelati PRIMA del round.")
W ("")
foreach($b in $blocchi){ W ($b) }
W ("")
W ("PID non bersaglio PRIMA: " + $(if($pidSalvi.Count -gt 0){$pidSalvi -join ", "}else{"nessuno"}))
W ("PID non bersaglio DOPO : " + $(if($pidDopo.Count -gt 0){$pidDopo -join ", "}else{"nessuno"}))
W ("")
W ("RILIEVI: " + $RILIEVI.Count)
foreach($x in $RILIEVI){ W ("  - " + $x) }
W ("")
W ("ESITO: " + $esitoFinale)
$ref = Join-Path $d ("REFERTO_ROUND_" + $Etichetta + ".txt")
($R -join "`r`n") | Set-Content -LiteralPath $ref -Encoding ASCII

# I CSV si copiano solo se sono di QUESTA corsa (per DATA, non per nome).
$n = 0
foreach($f in @($csvIS,$csvOOS)){
  if((Test-Path -LiteralPath $f) -and ((Get-Item -LiteralPath $f).LastWriteTime -ge $t0)){ Copy-Item -LiteralPath $f -Destination $d -Force; $n++ }
}
Copy-Item -LiteralPath $provaLoc -Destination $d -Force -ErrorAction SilentlyContinue

$zip = Join-Path $dsk ("ROUND_" + $Etichetta + ".zip")
if(Test-Path -LiteralPath $zip){ Remove-Item -LiteralPath $zip -Force }
Compress-Archive -Path (Join-Path $d "*") -DestinationPath $zip -Force

Write-Host ""
Write-Host ("RACCOLTA: " + $d)
Write-Host ("CSV di QUESTA corsa copiati: " + $n + "   (attesi 2: IS + OOS)")
Write-Host ("ZIP PRONTO DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host "FILE ATTESI NELLO ZIP:" -ForegroundColor Gray
Write-Host ("   REFERTO_ROUND_" + $Etichetta + ".txt") -ForegroundColor Gray
Write-Host ("   " + (Split-Path -Leaf $csvIS)) -ForegroundColor Gray
Write-Host ("   " + (Split-Path -Leaf $csvOOS)) -ForegroundColor Gray
Write-Host ("   " + $Prova) -ForegroundColor Gray
# Out-Host: senza, Format-Table esce DOPO le Write-Host che seguono e
# l'ESITO finirebbe stampato sopra la tabella.
Get-ChildItem -LiteralPath $d | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize | Out-Host

Write-Host ""
$colEsito = "Yellow"
if($esitoFinale -eq "ROUND GIRATO"){ $colEsito = "Green" }
elseif($esitoFinale -like "NON MISURATO*"){ $colEsito = "Red" }
Write-Host ("ESITO: " + $esitoFinale) -ForegroundColor $colEsito
if($esitoFinale -like "NON MISURATO*"){
  Write-Host ("  " + $TESTO_TRADES0) -ForegroundColor Red
  Write-Host "  Il log del tester sta in <cartella dati>\Tester\ e nei log per-agente" -ForegroundColor Red
  Write-Host "  (%APPDATA%\MetaQuotes\Tester\Agent-127.0.0.1-30xx\logs\)." -ForegroundColor Red
  Write-Host "  MANDA LO ZIP LO STESSO: 'non e' girata' e' gia' una risposta." -ForegroundColor Yellow
}
Write-Host ("Nel referto la riga 'data:' dice " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss") + ": e' quella da leggere per sapere se il file e' di oggi.") -ForegroundColor Gray

if($esitoFinale -eq "ROUND GIRATO"){ exit 0 }
if($esitoFinale -like "NON MISURATO*"){ exit 2 }
exit 3
