# =====================================================================
#  MARCATORE_SCHIERA_FTMO_v2
#
#  PORTA I SORGENTI E I PRESET DELLA ROSA NELLA CARTELLA DATI DEL
#  TERMINALE FTMO -- CHE OGGI NON ESISTE E QUINDI VA SCOPERTO.
#  NON COMPILA: l'F7 e' a mano, ed e' di Claudio.
#  NON attacca EA, NON apre grafici, NON accende AutoTrading.
#
#  Referto: report/SCHIERAMENTO_FTMO_2026-09-20.md
#  Pacchetto di riferimento: report/PACCHETTO_SCHIERAMENTO_PROP_2026-09-21.md
#  Censimento di partenza  : report/I_BINARI_DELLA_ROSA_2026-09-19.md
#  Modello                 : backtest_pipeline/righe/COMPILA_771531_770511.ps1
#
#  -------------------------------------------------------------------
#  IL VINCOLO CHE DECIDE TUTTO IL DISEGNO
#  -------------------------------------------------------------------
#  Il terminale FTMO non esiste ancora: NESSUN percorso e' cablato.
#  La cartella dati si SCOPRE, e la scoperta puo' finire in tre modi:
#    - UNA candidata confermata  -> si lavora;
#    - ZERO candidate            -> SI RIFIUTA e si stampa l'elenco;
#    - PIU' DI UNA candidata     -> SI RIFIUTA e si stampa l'elenco.
#  Su un conto che costa soldi veri non si indovina.
#
#  LE QUATTRO SERRATURE, in ordine, e servono tutte e quattro:
#    1. la cartella NON deve essere una delle SETTE gia' censite
#       (per HASH della cartella dati);
#    2. il suo origin.txt NON deve contenere nessuno dei nomi vietati
#       (BCM / Pepperstone / Tickmill / MT5_Backtest / MT5_MANUALE) e
#       NON deve essere uguale a nessuno dei sette percorsi noti;
#    3. il GIORNALE (<dati>\logs, non MQL5\Logs) deve contenere il
#       numero passato con -ContoAtteso;
#    4. il giornale o l'origin.txt devono nominare FTMO.
#  In piu': -ContoAtteso viene RIFIUTATO in partenza se e' uno dei
#  conti di casa. E' la stessa idea di InpLoginAtteso sul reale.
#
#  -------------------------------------------------------------------
#  COSA FA, PER INTERO
#  -------------------------------------------------------------------
#    1. scopre e CERTIFICA la cartella dati FTMO (sopra);
#    2. si assicura che esistano MQL5\Experts, MQL5\Include,
#       MQL5\Presets -- su un terminale appena installato Include e
#       Presets possono mancare, e un F7 senza include muore
#       (classe 27);
#    3. MISURA tutto PRIMA di scrivere: se e' gia' tutto a posto si
#       ferma con uscita 0 senza scaricare e senza copiare niente
#       (secondo lancio di fila = niente da fare);
#    4. COPIA DI SICUREZZA sul Desktop di ogni file che sta per essere
#       SOVRASCRITTO (su un terminale nuovo di solito e' vuota);
#    5. scarica dai PIN e VERIFICA L'IMPRONTA PRIMA di scrivere;
#    6. copia, rilegge dal disco e stampa la tabella dei due righelli;
#    7. stampa gli ORARI e le TAGLIE trovati dentro i preset --
#       STAMPA, non cambia. I preset arrivano da mql5/Presets/FTMO e
#       sono GIA' rimappati: quelli col marcatore si segnano "GIA'
#       FTMO, non toccare", quelli senza (il Guardian) prendono la
#       proposta +2;
#    8. lascia sul Desktop referto + zip.
#
#  -------------------------------------------------------------------
#  COSA NON FA, ED E' UNA PROMESSA VERIFICABILE RIGA PER RIGA
#  -------------------------------------------------------------------
#    - NON compila (F7 a mano, di Claudio);
#    - NON apre, NON chiude, NON termina nessun processo. In questo
#      file non esiste nessuna chiamata capace di toccare un processo:
#      niente Stop-Process, niente Get-Process, niente Start-Process,
#      niente taskkill;
#    - NON scrive in NESSUNA delle sette cartelle dati esistenti. La
#      destinazione e' UNA SOLA, ed e' quella che ha passato le quattro
#      serrature;
#    - NON scrive MAI fuori da MQL5\Experts, MQL5\Include,
#      MQL5\Presets. Nessun .chr, nessun profilo, nessun config:
#      e' il motivo per cui questo script NON pretende MT5 chiuso.
#      Quei file li riscrive il terminale alla chiusura; i .mq5 e i
#      .set no;
#    - NON MODIFICA nessun preset: li copia e basta. La rimappatura
#      degli orari e la taglia sono decisioni di Claudio;
#    - NON tocca il conto reale 10105439 in nessun modo.
#
#  -------------------------------------------------------------------
#  I PIN, E PERCHE' NON SONO TUTTI HEAD
#  -------------------------------------------------------------------
#  Ogni .mq5 ha il SUO pin, perche' il contratto misurato di ogni
#  sedia appartiene a UNA versione del sorgente, non alla piu' recente.
#    ABTG_EMA200.mq5                       -> 26a18566 (19/08), 552 righe
#    ABTG_SuperWave_DOW_H1_Ottimizzato.mq5 -> 872dba82 (08/09), 645 righe
#  HEAD di tutti e due e' un commit che dice ESPLICITAMENTE
#  "IN CORSO D'OPERA -- NON COMPILARE": vedi COMPILA_771531_770511.ps1.
#
#  ABTG_Guardian.mq5 -> d884f7e1 (v1.12), NON HEAD, e il motivo e'
#  MISURATO, non di gusto:
#    - il Guardian a HEAD (v1.14) chiama ABTG_ClusterParse_Calc,
#      ABTG_ClusterGVRadice e ABTG_SimboloNelCluster_Calc, che NON
#      esistono nell'include v1.20. Con v1.20 il suo F7 MUORE;
#    - l'unico include che li ha e' quello a HEAD, che pero' sta sul
#      commit "LAVORO IN CORSO -- tetto cluster C2 collegato": e' il
#      difetto che COMPILA_771531_770511 si era gia' rifiutata di
#      spedire per i due EA;
#    - il v1.12 invece compila con l'include v1.20 (quello VIVO e gia'
#      compilato sul 100k) e porta dentro il FIX CRITICO del 06/09:
#      la baseline giornaliera presa dall'EQUITA' e non dal BILANCIO.
#      Su FTMO la perdita giornaliera e' esattamente quel numero;
#    - il preset ABTG_Guardian_FTMO_2Step.set ha 15 input e TUTTI E 15
#      esistono nel v1.12 (verificato nome per nome). Il sedicesimo
#      input del v1.12, InpAutotest, ha default false: no-op.
#    - cosa si perde: il tetto per CLUSTER (C2). CLAUDE.md lo dichiara
#      NON NECESSARIO adesso e lo prova in quattro modi; il cap C1 al
#      3,25%, che e' quello firmato e vivo, c'e' ed e' nel preset.
#
#  ABTG_MaxMinNotte.mq5 (sedia 770402 ORO) NON VIENE COPIATA, ed e'
#  una OMISSIONE DICHIARATA, non una dimenticanza: il suo bersaglio
#  non e' deciso. Il binario in campo (08239510) ha il breakeven
#  annegato nel parziale, HEAD (7d0da9f9) cambia la FREQUENZA con cui
#  il contratto e' stato misurato. Serve una firma di Claudio dopo una
#  corsa di controllo. Lo script lo STAMPA come sedia SOSPESA.
#
#  -------------------------------------------------------------------
#  PERCHE' GLI EA HANNO L'IMPRONTA CONGELATA E I PRESET NO
#  -------------------------------------------------------------------
#  Un .mq5 e' il sorgente da cui nasce il binario su cui sono stati
#  misurati PF, DD e frequenza: se cambia di una riga, il contratto
#  non e' piu' quello. Quindi impronta CONGELATA nel file.
#  I .set no, e il 20/09 si e' visto perche': sono stati RIGENERATI da
#  un'altra sessione (mql5/Presets/FTMO, dieci file rimappati) mentre
#  questo script era gia' scritto. Un'impronta congelata li' dentro
#  avrebbe fatto fallire la riga per un motivo che NON e' un difetto.
#  Quindi i preset si prendono dal -Pin (immutabile per costruzione) e
#  si controllano NEL MERITO: devono contenere InpMagic=<magic atteso>.
#  L'impronta viene STAMPATA e finisce nel referto, cosi' resta
#  tracciata. E le TAGLIE si stampano a parte, perche' InpRiskPercent
#  e' territorio di Claudio e nei preset di stasera non e' uniforme.
#
#  ASCII PURO: niente emoji, niente accentate (PS 5.1 legge i .ps1
#  come ANSI -- regola di casa del 17/08).
# =====================================================================

param(
  [Parameter(Mandatory=$true)][string]$ContoAtteso,
  [Parameter(Mandatory=$true)][string]$Pin,
  [switch]$SoloDiagnosi,
  [switch]$SenzaPostNews
)

$ErrorActionPreference = 'Stop'
$INV = [Globalization.CultureInfo]::InvariantCulture
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch { }
$CRONO = [Diagnostics.Stopwatch]::StartNew()

$REPO_RAW = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB'

# ---------------------------------------------------------------------
# LE SETTE CARTELLE DATI GIA' CENSITE SUL VPS.
# Questi nomi compaiono qui SOLO per essere RIFIUTATI: sono la lista
# nera, non una destinazione. Nessuna scrittura punta a nessuno di
# questi percorsi -- l'unica destinazione dello script e' la variabile
# $dati, che nasce dalla scoperta e passa quattro serrature.
# ---------------------------------------------------------------------
$HASH_NOTI = @{
  '215D85D767A1C39E22D242C8114BF9F5' = '50503392  piccolo demo      (C:\Program Files\BCM Markets MT5 Terminal)'
  'BCA8AD18563BF5B64A433C2662D0A104' = '50504263  100k demo         (C:\Program Files\BCM Markets MT5 Terminal -V3)'
  'E23E1504A8D02A22179395F0652B86B6' = '10105439  *** REALE ***     (C:\BCM_Reale)'
  '04C7A32B575E40027B4FF8724D14D702' = '50504400  banco di backtest (C:\MT5_Backtest)'
  'CF6C240A869369695913FB76DA84BD22' = '50503635  manuale           (C:\MT5_MANUALE)'
  '73B7A2420D6397DFF9014A20F1201F97' = 'broker esterno Pepperstone'
  '857385E4B0F2356AD99AA95CDF40FAE9' = 'broker esterno Tickmill'
}
$NOMI_VIETATI  = @('BCM', 'Pepperstone', 'Tickmill', 'MT5_Backtest', 'MT5_MANUALE')
$CONTI_DI_CASA = @('50503392', '50504263', '10105439', '50504400', '50503635')

# ---------------------------------------------------------------------
# LA TAVOLA DEI SORGENTI. Uno per sedia, piu' il Guardian.
# Righe/Sha = impronta ATTESA del file AL SUO PIN, misurata prima di
# scrivere questo script e verificata contro i numeri gia' approvati
# in COMPILA_771531_770511.ps1 (EMA200 552 e SuperWave 645 combaciano).
# ---------------------------------------------------------------------
$SORGENTI = @(
  [pscustomobject]@{ Nome='ABTG_DAX_Apertura_EU.mq5';                    Sedia='770101 DAX Apertura EU  D30EUR M5';  Cartella='Experts'; RepoDir='mql5/Experts'; Pin='9fca63d98046e60b29f9300fc09dad7738cc887d'; Righe=2425; Sha='59B67F5F912476E270C62079C80799B3E86F696AEE2F17BD158E2B4828BAD692' },
  [pscustomobject]@{ Nome='ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5';  Sedia='770411 MaxMin DAX Short  D30EUR M15'; Cartella='Experts'; RepoDir='mql5/Experts'; Pin='5fc0bc31f3a74431f23976e52051af1c1e3b4e0d'; Righe=619;  Sha='B4A56E089F001C3E9E7DA51F24CE713FA34CDCFD58A917159611038D4DF8563A' },
  [pscustomobject]@{ Nome='ABTG_Dow_Apertura_US.mq5';                    Sedia='770202 Dow Apertura US   U30USD M5';  Cartella='Experts'; RepoDir='mql5/Experts'; Pin='9fca63d98046e60b29f9300fc09dad7738cc887d'; Righe=2205; Sha='0BF7A1B3466DA1A0807421B3CFAF59A0455276B2DD98CA8FBF610FEB391019B1' },
  [pscustomobject]@{ Nome='ABTG_EMA200.mq5';                             Sedia='771531 EMA200 Dow       U30USD H1';  Cartella='Experts'; RepoDir='mql5/Experts'; Pin='26a185661c120de6fa0a33b79279595740e264e8'; Righe=552;  Sha='5CA99D90A5F34E9630083C91E16A5E7F2DA48FC77EF63B138C5C2C3485BE85F4' },
  [pscustomobject]@{ Nome='ABTG_SuperWave_DOW_H1_Ottimizzato.mq5';       Sedia='770511 SuperWave DOW     U30USD H1';  Cartella='Experts'; RepoDir='mql5/Experts'; Pin='872dba82d7b3b345c8ae15cb1033b66df6066ae5'; Righe=645;  Sha='3C487F289023CEDC87375A6E589C7C8C43423A38151F19A8436A218F3EE7C18B' },
  [pscustomobject]@{ Nome='ABTG_Nasdaq_Apertura_US.mq5';                 Sedia='770260 Nasdaq RETEST     NASUSD M5';  Cartella='Experts'; RepoDir='mql5/Experts'; Pin='9fca63d98046e60b29f9300fc09dad7738cc887d'; Righe=2624; Sha='87BD4B187CCE6195D5F328FD833E61EF3B741FAED7FB2C7CD18AA3AE60CCB8A8' },
  [pscustomobject]@{ Nome='ABTG_Guardian.mq5';                           Sedia='779001 Guardian v1.12   (non trada)'; Cartella='Experts'; RepoDir='mql5/Experts'; Pin='d884f7e1328aacb35c7b7d94056f18a7643fce01'; Righe=498;  Sha='A457F2CDF211F312A4F6BEACC3D2B72B07B068EE2C5BC38514924693EE6B7DF8' },
  [pscustomobject]@{ Nome='ABTG_PausaGuardian.mqh';                      Sedia='include v1.20 -- SENZA DI LUI NESSUN F7 PARTE'; Cartella='Include'; RepoDir='mql5/Include'; Pin='26a185661c120de6fa0a33b79279595740e264e8'; Righe=398; Sha='D179846B407FDACC963825103F850E8F8BEE39B1DA3521A504EF74F8638AC8BC' }
)

# Il blocco PostNews: UN SOLO EA, tre preset. Si aggiunge alla tavola
# a meno che non venga chiesto -SenzaPostNews.
$POSTNEWS_EA = [pscustomobject]@{ Nome='ABTG_PostNews.mq5'; Sedia='771202/771203/771204 PostNews (FOMC/NFP/ECB)'; Cartella='Experts'; RepoDir='mql5/Experts'; Pin='61dc18c9fe59b273f24560beb196ecac8d94fe6f'; Righe=666; Sha='8982D52748F7438C9250A51C0906E699853278D41C44EF123B4A2CD113B475A3' }

# ---------------------------------------------------------------------
# LA TAVOLA DEI PRESET. Presi dal -Pin, controllati NEL MERITO.
# Obbligatorio=$true -> se manca al pin, lo script RIFIUTA.
# Obbligatorio=$false -> se manca, lo dice forte e prosegue.
#   770260: il .set NON e' in repo (buco B6 del pacchetto). E' segnato
#           NON obbligatorio apposta: se un'altra sessione lo committa
#           prima del lancio, il -Pin giusto se lo porta dietro da
#           solo; se non arriva, la serata non si ferma per lui.
#   PostNews: i tre .set sono in lavorazione stanotte da un'altra
#           sessione, stessa ragione.
# ---------------------------------------------------------------------
$PRESET = @(
  [pscustomobject]@{ Nome='ABTG_DAX_Apertura_EU_770101_FTMO.set';           RepoDir='mql5/Presets/FTMO'; Magic='770101'; Sedia='770101 DAX Apertura';    Obbligatorio=$true;  Blocco='ROSA' },
  [pscustomobject]@{ Nome='ABTG_MaxMinNotte_DAX_Short_770411_FTMO.set';     RepoDir='mql5/Presets/FTMO'; Magic='770411'; Sedia='770411 MaxMin DAX Short'; Obbligatorio=$true;  Blocco='ROSA' },
  [pscustomobject]@{ Nome='ABTG_Dow_Apertura_US_770202_FTMO.set';           RepoDir='mql5/Presets/FTMO'; Magic='770202'; Sedia='770202 Dow Apertura';    Obbligatorio=$true;  Blocco='ROSA' },
  [pscustomobject]@{ Nome='ABTG_EMA200_771531_FTMO.set';                    RepoDir='mql5/Presets/FTMO'; Magic='771531'; Sedia='771531 EMA200 Dow';      Obbligatorio=$true;  Blocco='ROSA' },
  [pscustomobject]@{ Nome='ABTG_SuperWave_DOW_H1_770511_FTMO.set';          RepoDir='mql5/Presets/FTMO'; Magic='770511'; Sedia='770511 SuperWave DOW';   Obbligatorio=$true;  Blocco='ROSA' },
  [pscustomobject]@{ Nome='ABTG_Nasdaq_Apertura_US_RETEST_770260_FTMO.set'; RepoDir='mql5/Presets/FTMO'; Magic='770260'; Sedia='770260 Nasdaq RETEST';   Obbligatorio=$true;  Blocco='ROSA' },
  [pscustomobject]@{ Nome='ABTG_Guardian_FTMO_2Step.set';                   RepoDir='mql5/Presets';      Magic='779001'; Sedia='779001 Guardian FTMO';   Obbligatorio=$true;  Blocco='ROSA' },
  [pscustomobject]@{ Nome='ABTG_PostNews_FOMC_EURUSD_771202_FTMO.set';      RepoDir='mql5/Presets/FTMO'; Magic='771202'; Sedia='771202 PostNews FOMC';   Obbligatorio=$false; Blocco='POSTNEWS' },
  [pscustomobject]@{ Nome='ABTG_PostNews_NFP_USDJPY_771203_FTMO.set';       RepoDir='mql5/Presets/FTMO'; Magic='771203'; Sedia='771203 PostNews NFP';    Obbligatorio=$false; Blocco='POSTNEWS' },
  [pscustomobject]@{ Nome='ABTG_PostNews_ECB_EURUSD_771204_FTMO.set';       RepoDir='mql5/Presets/FTMO'; Magic='771204'; Sedia='771204 PostNews ECB';    Obbligatorio=$false; Blocco='POSTNEWS' }
)

# La sedia che NON si schiera, e si dice perche'.
$SOSPESE = @(
  '770402 MaxMin ORO (ABTG_MaxMinNotte.mq5): BERSAGLIO NON DECISO. Il binario in campo (08239510, 28/07) ha il breakeven annegato nel parziale a 0,01 lotti; HEAD (7d0da9f9) rende effettivo InpOneTradePerDay e cambia la FREQUENZA con cui il contratto e stato misurato. Serve una corsa di controllo e una firma. NON COPIATA DI PROPOSITO.',
  '770402: ATTENZIONE, in repo ESISTE mql5/Presets/FTMO/ABTG_MaxMinNotte_ORO_770402_FTMO.set. NON lo installo, ed e VOLUTO: un preset senza il suo EA e una trappola -- si apre la finestra input, si vede il file, si crede che la sedia ci sia. Quando 770402 verra firmata, arrivano INSIEME il .mq5 al suo pin e il preset.'
)

# =====================================================================
# FUNZIONI
# =====================================================================

# Lettura condivisa: i giornali sono aperti dal terminale, i .mq5
# possono essere aperti da MetaEditor. Stesso schema di CODA_03/CODA_06.
function Leggi-Testo($path) {
  $b = $null
  try {
    $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
  } catch { return '' }
  try {
    $b = New-Object byte[] $fs.Length
    # FileStream.Read non garantisce di riempire il buffer in una volta:
    # un byte mancante diventerebbe una "impronta diversa" inventata.
    $letti = 0
    while($letti -lt $b.Length){
      $q = $fs.Read($b, $letti, $b.Length - $letti)
      if($q -le 0){ break }
      $letti += $q
    }
  } finally { $fs.Close() }
  if($null -eq $b -or $b.Count -lt 2){ return '' }
  if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return [Text.Encoding]::Unicode.GetString($b) }
  $zeri = 0
  $n = [math]::Min(400, $b.Count)
  for($i = 1; $i -lt $n; $i += 2){ if($b[$i] -eq 0){ $zeri++ } }
  if($zeri -gt ($n / 4)){ return [Text.Encoding]::Unicode.GetString($b) }
  return [Text.Encoding]::UTF8.GetString($b)
}

# Impronta ASCII normalizzata: CRLF/LF, BOM e accentate nei commenti
# non cambiano una virgola di codice, quindi si tolgono prima di
# misurare. Stessa identica funzione di COMPILA_771531_770511.ps1:
# verificato che produce gli stessi numeri gia' approvati la' dentro.
function Scheletro($testo) {
  $t = $testo -replace "`r`n", "`n"
  $t = $t -replace "`r", "`n"
  $t = $t -replace '[^\u0009\u000A\u0020-\u007E]', ''
  $t = $t.TrimEnd("`n")
  $righe = ($t -split "`n").Count
  $sha = [Security.Cryptography.SHA256]::Create()
  try { $hb = $sha.ComputeHash([Text.Encoding]::ASCII.GetBytes($t)) } finally { $sha.Dispose() }
  $sb = New-Object Text.StringBuilder
  foreach($x in $hb){ [void]$sb.Append($x.ToString('X2', $INV)) }
  return [pscustomobject]@{ Righe = $righe; Sha = $sb.ToString(); Testo = $t }
}

# CODA_06 conta sempre UNO IN PIU' di wc -l (classe 456): si stampano
# tutti e due i righelli, cosi' nessuno confronta mele con pere.
function DueRighelli($n) { return ($n.ToString($INV) + ' (CODA_06: ' + ($n + 1).ToString($INV) + ')') }

$RIGHE_REFERTO = New-Object Collections.ArrayList
function Dillo($testo, $colore) {
  if($colore){ Write-Host $testo -ForegroundColor $colore } else { Write-Host $testo }
  [void]$RIGHE_REFERTO.Add($testo)
}

$DESKTOP = Join-Path $env:USERPROFILE 'Desktop'
if(-not (Test-Path -LiteralPath $DESKTOP)){ $DESKTOP = $env:USERPROFILE }
$STAMPA  = (Get-Date).ToString('yyyy-MM-dd_HHmmss', $INV)
$CARTREF = Join-Path $DESKTOP ('SCHIERA_FTMO_' + $STAMPA)

function Posa-Referto {
  try {
    if(-not (Test-Path -LiteralPath $CARTREF)){ [void](New-Item -ItemType Directory -Path $CARTREF -Force) }
    $f = Join-Path $CARTREF ('SCHIERA_FTMO_' + $STAMPA + '_referto.txt')
    [IO.File]::WriteAllText($f, ($RIGHE_REFERTO -join "`r`n"), [Text.Encoding]::UTF8)
    return $f
  } catch { return '' }
}

function Muori($msg) {
  Dillo '' $null
  Dillo '=====================================================================' 'Red'
  Dillo ('FERMO: ' + $msg) 'Red'
  Dillo 'NESSUN FILE E STATO SCRITTO SU NESSUNA CARTELLA DATI.' 'Red'
  Dillo '=====================================================================' 'Red'
  $f = Posa-Referto
  if($f){ Write-Host ('referto di questo rifiuto: ' + $f) -ForegroundColor Yellow }
  exit 1
}

Dillo '=====================================================================' $null
Dillo ' SCHIERAMENTO FTMO -- SOLO COPIA. NESSUN F7, NESSUN EA ATTACCATO.' $null
Dillo (' conto atteso : ' + $ContoAtteso) $null
Dillo (' pin preset   : ' + $Pin) $null
Dillo (' ora          : ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $INV) + '  (ora locale del VPS)') $null
if($SoloDiagnosi){  Dillo ' MODO         : SOLA DIAGNOSI -- non scrivera NIENTE, nemmeno se trova tutto giusto.' 'Yellow' }
if($SenzaPostNews){ Dillo ' MODO         : SENZA POSTNEWS -- il blocco PostNews e escluso su richiesta.' 'Yellow' }
Dillo '=====================================================================' $null
Dillo '' $null

# =====================================================================
# PASSO 0 -- IL CONTO ATTESO, CONTROLLATO PRIMA DI GUARDARE IL DISCO
# =====================================================================
if($ContoAtteso -notmatch '^[0-9]{6,12}$'){
  Muori ('-ContoAtteso vale "' + $ContoAtteso + '", che non e un numero di conto (servono 6-12 cifre). Non si cerca niente con una chiave sbagliata.')
}
foreach($c in $CONTI_DI_CASA){
  if($ContoAtteso -eq $c){
    Muori ('-ContoAtteso vale ' + $ContoAtteso + ', che e UN CONTO DI CASA (BCM), non FTMO. Questa e la seconda serratura, ed e appena scattata: se avessi accettato, avrei cercato la cartella di un terminale che NON va toccato.')
  }
}
if($Pin -notmatch '^[0-9a-fA-F]{40}$'){
  Muori ('-Pin vale "' + $Pin + '": serve lo SHA completo di 40 caratteri di un commit, non un ramo e non uno SHA corto. Un ramo si muove, un commit no.')
}
Dillo ('[0/8] -ContoAtteso ' + $ContoAtteso + ' accettato: e un numero, e NON e nessuno dei cinque conti di casa.') 'Green'

# =====================================================================
# PASSO 1 -- LA SCOPERTA. Qui non si indovina: si elenca e si esclude.
# =====================================================================
$radice = Join-Path $env:APPDATA 'MetaQuotes\Terminal'
if(-not (Test-Path -LiteralPath $radice)){
  Muori ('non esiste ' + $radice + '. Su questa macchina non c e nessun MT5, oppure -- piu probabile -- questa riga sta girando sull utente sbagliato.')
}

$cartelle = @(Get-ChildItem -LiteralPath $radice -Directory -ErrorAction SilentlyContinue |
              Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'MQL5') })
Dillo ('[1/8] cartelle dati sotto ' + $radice + ': ' + $cartelle.Count.ToString($INV)) $null

$candidate = @()
foreach($d in $cartelle){
  $nome = $d.Name
  $noto = ''
  foreach($k in $HASH_NOTI.Keys){ if($nome -eq $k){ $noto = $HASH_NOTI[$k] } }
  if($noto){
    Dillo ('      ESCLUSA  ' + $nome + '  = ' + $noto) $null
    continue
  }

  $fOrig = Join-Path $d.FullName 'origin.txt'
  if(-not (Test-Path -LiteralPath $fOrig)){
    Dillo ('      ESCLUSA  ' + $nome + '  = manca origin.txt: non posso CERTIFICARE di chi e questa cartella, e senza certificato non si scrive.') 'Yellow'
    continue
  }
  $prog = ((Leggi-Testo $fOrig) -replace '[^\u0020-\u007E]', '').Trim()

  $vietato = ''
  foreach($v in $NOMI_VIETATI){ if($prog -like ('*' + $v + '*')){ $vietato = $v } }
  if($vietato){
    Dillo ('      ESCLUSA  ' + $nome + '  = "' + $prog + '" contiene "' + $vietato + '": e una cartella di casa, non si tocca.') $null
    continue
  }

  $candidate += [pscustomobject]@{ Hash = $nome; Path = $d.FullName; Prog = $prog }
  Dillo ('      candidata ' + $nome + '  = "' + $prog + '"') 'Cyan'
}

if($candidate.Count -eq 0){
  Dillo '' $null
  Dillo '      NESSUNA CANDIDATA. Le cause possibili, in ordine di probabilita:' 'Yellow'
  Dillo '      1. il terminale FTMO non e ancora stato INSTALLATO e AVVIATO almeno una volta' 'Yellow'
  Dillo '      2. e stato avviato ma non ha ancora scritto origin.txt: chiudilo e riaprilo una volta' 'Yellow'
  Dillo ('      3. e installato per un ALTRO utente Windows: questa riga gira come ' + $env:USERNAME) 'Yellow'
  Dillo '      4. e portable (dati dentro la cartella del programma, non in APPDATA)' 'Yellow'
  Muori 'zero candidate: non c e nessuna cartella dati che non sia gia di casa.'
}

# =====================================================================
# PASSO 2 -- LA CERTIFICAZIONE DAL GIORNALE. La cartella la sceglie il
#            NUMERO DI CONTO scritto dal terminale, non il nome.
#            <dati>\logs e' il GIORNALE. MQL5\Logs e' la scheda Esperti:
#            distinzione gia' pagata in casa.
# =====================================================================
Dillo ('[2/8] certificazione dal giornale (<dati>\logs), candidate: ' + $candidate.Count.ToString($INV)) $null
$confermate = @()
foreach($c in $candidate){
  $dirLog = Join-Path $c.Path 'logs'
  $testo = ''
  $nlog = 0
  if(Test-Path -LiteralPath $dirLog){
    $files = @(Get-ChildItem -LiteralPath $dirLog -Filter *.log -ErrorAction SilentlyContinue |
               Sort-Object LastWriteTime -Descending | Select-Object -First 10)
    $nlog = $files.Count
    foreach($f in $files){ $testo = $testo + (Leggi-Testo $f.FullName) }
  }
  $haConto = ($testo -match ('(?<![0-9])' + [regex]::Escape($ContoAtteso) + '(?![0-9])'))
  $haFtmo  = (($testo -match '(?i)ftmo') -or ($c.Prog -match '(?i)ftmo'))

  $riga = '      ' + $c.Hash + '  giornali ' + $nlog.ToString($INV)
  if($haConto){ $riga = $riga + '  conto ' + $ContoAtteso + ': TROVATO' } else { $riga = $riga + '  conto ' + $ContoAtteso + ': non trovato' }
  if($haFtmo){  $riga = $riga + '  |  FTMO: nominato' }             else { $riga = $riga + '  |  FTMO: non nominato' }
  if($haConto -and $haFtmo){
    Dillo ($riga + '  -> CONFERMATA') 'Green'
    $confermate += $c
  } else {
    Dillo ($riga + '  -> scartata') 'Yellow'
  }
}

if($confermate.Count -eq 0){
  Dillo '' $null
  Dillo '      NESSUNA CANDIDATA CONFERMATA. Serve che il GIORNALE contenga tutte e due le cose:' 'Yellow'
  Dillo ('      (a) il numero ' + $ContoAtteso + '   (b) la parola FTMO') 'Yellow'
  Dillo '      Se hai appena fatto il login, il giornale puo essere ancora vuoto: aspetta che il' 'Yellow'
  Dillo '      terminale si colleghi (Market Watch coi prezzi che si muovono) e rilancia.' 'Yellow'
  Dillo '      Se il numero e diverso da quello della mail FTMO, e -ContoAtteso a essere sbagliato.' 'Yellow'
  Muori ('nessuna delle ' + $candidate.Count.ToString($INV) + ' candidate porta nel giornale il conto ' + $ContoAtteso + ' insieme al nome FTMO.')
}
if($confermate.Count -gt 1){
  Dillo '' $null
  foreach($c in $confermate){ Dillo ('      ' + $c.Hash + '  ' + $c.Prog) 'Red' }
  Muori ('CONFERMATE ' + $confermate.Count.ToString($INV) + ' cartelle diverse con lo stesso conto: non so in quale terminale stai per premere F7. Manda questo elenco e si decide a mano. Non si indovina su un conto che costa soldi veri.')
}

$dati = $confermate[0].Path
$prog = $confermate[0].Prog
Dillo '' $null
Dillo ('[2/8] BERSAGLIO CERTIFICATO -- conto ' + $ContoAtteso) 'Green'
Dillo ('      programma     : ' + $prog) 'Green'
Dillo ('      cartella dati : ' + $dati) 'Green'
Dillo ('      le altre ' + ($cartelle.Count - 1).ToString($INV) + ' cartelle dati di questa macchina non verranno nemmeno riaperte.') 'Green'

# Ultima rete, e non e' ridondante: il percorso di destinazione VERO,
# quello su cui si scrivera', passa un'altra volta dalla lista nera.
# Se una riga futura cambiasse la scoperta, morirebbe qui.
foreach($v in $NOMI_VIETATI){
  if($dati -like ('*' + $v + '*')){ Muori ('il percorso di destinazione "' + $dati + '" contiene "' + $v + '". Non si scrive.') }
}
foreach($k in $HASH_NOTI.Keys){
  if($dati -like ('*' + $k + '*')){ Muori ('il percorso di destinazione "' + $dati + '" e la cartella nota ' + $HASH_NOTI[$k] + '. Non si scrive.') }
}

# =====================================================================
# PASSO 3 -- LE TRE CARTELLE. Su un terminale appena installato
#            Include e Presets possono NON esistere: un F7 senza
#            include muore con "cannot open include file" (classe 27).
# =====================================================================
$dirExp = Join-Path $dati 'MQL5\Experts'
$dirInc = Join-Path $dati 'MQL5\Include'
$dirPre = Join-Path $dati 'MQL5\Presets'
Dillo '[3/8] le tre cartelle di destinazione:' $null
foreach($p in @($dirExp, $dirInc, $dirPre)){
  if(Test-Path -LiteralPath $p){
    Dillo ('      c era gia : ' + $p) $null
  } else {
    if($SoloDiagnosi){
      Dillo ('      DA CREARE : ' + $p + '   (sola diagnosi: non la creo)') 'Yellow'
    } else {
      [void](New-Item -ItemType Directory -Path $p -Force)
      Dillo ('      CREATA    : ' + $p) 'Yellow'
    }
  }
}

# =====================================================================
# PASSO 4 -- MISURA PRIMA DI TOCCARE
# =====================================================================
$lavoro = @()
foreach($s in $SORGENTI){ $lavoro += $s }
if(-not $SenzaPostNews){ $lavoro += $POSTNEWS_EA }

Dillo '[4/8] misura di quello che c e gia (nessuna scrittura ancora):' $null
$daFare = @()
$daSalvare = @()
foreach($s in $lavoro){
  $dst = Join-Path $dati ('MQL5\' + $s.Cartella + '\' + $s.Nome)
  $stato = 'ASSENTE'
  $pre = $null
  if(Test-Path -LiteralPath $dst){
    $pre = Scheletro (Leggi-Testo $dst)
    if($pre.Righe -eq $s.Righe -and $pre.Sha -eq $s.Sha){ $stato = 'GIA GIUSTO' } else { $stato = 'PRESENTE DIVERSO' }
  }
  $s | Add-Member -NotePropertyName Dst   -NotePropertyValue $dst   -Force
  $s | Add-Member -NotePropertyName Stato -NotePropertyValue $stato -Force
  $s | Add-Member -NotePropertyName Pre   -NotePropertyValue $pre   -Force
  $col = 'Yellow'
  if($stato -eq 'GIA GIUSTO'){ $col = 'Green' }
  $coda = ''
  if($stato -eq 'PRESENTE DIVERSO'){ $coda = '  (righe ' + $pre.Righe.ToString($INV) + ', attese ' + $s.Righe.ToString($INV) + ')' }
  Dillo ('      ' + $s.Nome.PadRight(46) + $stato.PadRight(20) + $coda) $col
  if($stato -ne 'GIA GIUSTO'){ $daFare += $s }
  if($stato -eq 'PRESENTE DIVERSO'){ $daSalvare += $s }
}

$presetDaFare = @()
foreach($p in $PRESET){
  if($SenzaPostNews -and $p.Blocco -eq 'POSTNEWS'){ continue }
  $presetDaFare += $p
}

if($SoloDiagnosi){
  Dillo '' $null
  Dillo '      SOLA DIAGNOSI: mi fermo qui. Niente download, niente scrittura.' 'Yellow'
  Dillo ('      da copiare sarebbero: ' + $daFare.Count.ToString($INV) + ' sorgenti e ' + $presetDaFare.Count.ToString($INV) + ' preset.') 'Yellow'
  $CRONO.Stop()
  Dillo ('      durata: ' + $CRONO.Elapsed.TotalSeconds.ToString('F1', $INV) + ' s') $null
  $f = Posa-Referto
  if($f){ Write-Host ('referto: ' + $f) -ForegroundColor Green }
  exit 0
}

if($daFare.Count -eq 0){
  Dillo '' $null
  Dillo '      TUTTI I SORGENTI SONO GIA QUELLI GIUSTI, impronta per impronta.' 'Green'
  Dillo '      Controllo comunque i preset, poi finisco: non c era niente da scaricare.' 'Green'
}

# =====================================================================
# PASSO 5 -- COPIA DI SICUREZZA. Solo di quello che sta per essere
#            SOVRASCRITTO. Su un terminale nuovo di solito e vuota.
# =====================================================================
[void](New-Item -ItemType Directory -Path $CARTREF -Force)
if($daSalvare.Count -gt 0){
  $dirBk = Join-Path $CARTREF 'ORIGINALI_SOVRASCRITTI'
  [void](New-Item -ItemType Directory -Path $dirBk -Force)
  foreach($x in $daSalvare){ Copy-Item -LiteralPath $x.Dst -Destination (Join-Path $dirBk $x.Nome) -Force }
  Dillo ('[5/8] COPIA DI SICUREZZA di ' + $daSalvare.Count.ToString($INV) + ' file che erano gia li ed erano DIVERSI: ' + $dirBk) 'Yellow'
} else {
  Dillo '[5/8] niente da salvare: nessun file preesistente verra sovrascritto.' 'Green'
}

# =====================================================================
# PASSO 6 -- SCARICO E VERIFICO PRIMA DI SCRIVERE
#            URL per COMMIT: un commit git e immutabile, quindi la
#            cache ~5 min di raw.githubusercontent non c entra.
# =====================================================================
$dirTmp = Join-Path $CARTREF 'SCARICATI'
[void](New-Item -ItemType Directory -Path $dirTmp -Force)
$wc = New-Object Net.WebClient

if($daFare.Count -gt 0){ Dillo '[6/8] scarico i sorgenti dai pin e ne verifico l impronta PRIMA di scrivere:' $null }
try {
  foreach($s in $daFare){
    $url = $REPO_RAW + '/' + $s.Pin + '/' + $s.RepoDir + '/' + $s.Nome
    $byte = $null
    try {
      $byte = $wc.DownloadData($url)
    } catch {
      Muori ('scaricamento FALLITO di ' + $s.Nome + ' da ' + $url + ' -- ' + $_.Exception.Message + '. Un 404 qui vuol dire PIN SBAGLIATO o file non presente a quel commit. Non e stato scritto niente sul terminale.')
    }
    $sc = Scheletro ([Text.Encoding]::UTF8.GetString($byte))
    if($sc.Righe -ne $s.Righe -or $sc.Sha -ne $s.Sha){
      Muori ('il file scaricato ' + $s.Nome + ' NON e quello atteso (righe ' + $sc.Righe.ToString($INV) + ' contro ' + $s.Righe.ToString($INV) + ', sha ' + $sc.Sha.Substring(0,16) + ' contro ' + $s.Sha.Substring(0,16) + '). Non e stato scritto niente sul terminale.')
    }
    $tmp = Join-Path $dirTmp $s.Nome
    [IO.File]::WriteAllBytes($tmp, $byte)
    $s | Add-Member -NotePropertyName Tmp -NotePropertyValue $tmp -Force
    Dillo ('      ' + $s.Nome.PadRight(46) + ' pin ' + $s.Pin.Substring(0,8) + '  righe ' + (DueRighelli $sc.Righe).PadRight(22) + ' VERIFICATO') 'Green'
  }

  # I PRESET: dal -Pin, controllati NEL MERITO (InpMagic), non per impronta.
  Dillo '[6/8] preset dal pin, controllati nel merito (devono portare il loro InpMagic):' $null
  $presetOk = @()
  $presetMancanti = @()
  foreach($p in $presetDaFare){
    $url = $REPO_RAW + '/' + $Pin + '/' + $p.RepoDir + '/' + $p.Nome
    $byte = $null
    try {
      $byte = $wc.DownloadData($url)
    } catch {
      if($p.Obbligatorio){
        Muori ('preset OBBLIGATORIO mancante al pin: ' + $p.Nome + ' (' + $p.Sedia + ') da ' + $url + ' -- ' + $_.Exception.Message + '. Senza quel preset quella sedia non si accende. Non e stato scritto niente sul terminale.')
      }
      $presetMancanti += $p
      Dillo ('      MANCA AL PIN      ' + $p.Nome.PadRight(56) + '  ' + $p.Sedia + '  -> la sedia NON si accende stasera') 'Yellow'
      continue
    }
    $sc = Scheletro ([Text.Encoding]::UTF8.GetString($byte))
    if($sc.Testo -notmatch ('(?m)^\s*InpMagic\s*=\s*' + [regex]::Escape($p.Magic) + '\s*$')){
      Muori ('il preset ' + $p.Nome + ' NON contiene "InpMagic=' + $p.Magic + '". O e il preset di un altra sedia, o e stato riscritto: in tutti e due i casi caricarlo sul grafico sbagliato e esattamente il modo in cui si perde una serata. Non e stato scritto niente sul terminale.')
    }
    $tmp = Join-Path $dirTmp $p.Nome
    [IO.File]::WriteAllBytes($tmp, $byte)
    $p | Add-Member -NotePropertyName Tmp   -NotePropertyValue $tmp -Force
    $p | Add-Member -NotePropertyName Testo -NotePropertyValue $sc.Testo -Force
    $p | Add-Member -NotePropertyName Sha   -NotePropertyValue $sc.Sha -Force
    $p | Add-Member -NotePropertyName Righe -NotePropertyValue $sc.Righe -Force

    # LO STATO DEL PRESET SUL TERMINALE, e qui la regola e' l OPPOSTA
    # di quella dei .mq5, di proposito:
    #   un .mq5 diverso = binario sbagliato = VA sostituito;
    #   un .set diverso = quasi sempre una MANO UMANA (Claudio che ha
    #   rimappato gli orari +2 e ha premuto Salva dentro MT5), e quella
    #   NON si sovrascrive mai. Al secondo lancio della riga il lavoro
    #   fatto a mano deve sopravvivere.
    $dstP = Join-Path $dirPre $p.Nome
    $statoP = 'ASSENTE'
    if(Test-Path -LiteralPath $dstP){
      $pv = Scheletro (Leggi-Testo $dstP)
      if($pv.Sha -eq $sc.Sha){ $statoP = 'GIA IDENTICO' } else { $statoP = 'PRESENTE DIVERSO' }
    }
    $p | Add-Member -NotePropertyName Dst    -NotePropertyValue $dstP   -Force
    $p | Add-Member -NotePropertyName StatoP -NotePropertyValue $statoP -Force
    $presetOk += $p
    $colP = 'Green'
    if($statoP -eq 'PRESENTE DIVERSO'){ $colP = 'Yellow' }
    Dillo ('      ' + $statoP.PadRight(20) + $p.Nome.PadRight(56) + '  InpMagic=' + $p.Magic + '  righe ' + $sc.Righe.ToString($INV) + '  sha ' + $sc.Sha.Substring(0,16)) $colP
  }
} finally { $wc.Dispose() }

# =====================================================================
# PASSO 7 -- LA SCRITTURA. Unica destinazione: $dati, gia certificata.
#            Se una copia fallisce NON si muore qui: si segna e si va
#            alla tabella finale, che e riletta dal disco. Morire a
#            meta lascerebbe uno stato misto senza referto.
# =====================================================================
Dillo '[7/8] copia...' $null
foreach($s in $daFare){
  try { Copy-Item -LiteralPath $s.Tmp -Destination $s.Dst -Force }
  catch { Dillo ('      COPIA FALLITA su ' + $s.Nome + ': ' + $_.Exception.Message) 'Red' }
}
foreach($p in $presetOk){
  if($p.StatoP -eq 'GIA IDENTICO'){ continue }
  if($p.StatoP -eq 'PRESENTE DIVERSO'){
    # NON si sovrascrive. Si mette accanto la versione del repo con il
    # suffisso _DAL_REPO e si lascia decidere a chi guarda.
    $dirBk2 = Join-Path $CARTREF 'PRESET_GIA_PRESENTI_E_DIVERSI'
    [void](New-Item -ItemType Directory -Path $dirBk2 -Force)
    Copy-Item -LiteralPath $p.Dst -Destination (Join-Path $dirBk2 $p.Nome) -Force
    $accanto = Join-Path $dirPre ([IO.Path]::GetFileNameWithoutExtension($p.Nome) + '_DAL_REPO.set')
    try { Copy-Item -LiteralPath $p.Tmp -Destination $accanto -Force } catch { }
    Dillo ('      NON SOVRASCRITTO: ' + $p.Nome + ' era gia li ed e DIVERSO da quello del repo.') 'Yellow'
    Dillo ('        e quasi sempre una tua modifica a mano (gli orari +2). Quella vince.') 'Yellow'
    Dillo ('        la versione del repo te l ho messa accanto come ' + [IO.Path]::GetFileName($accanto)) 'Yellow'
    continue
  }
  try { Copy-Item -LiteralPath $p.Tmp -Destination $p.Dst -Force }
  catch { Dillo ('      COPIA FALLITA su ' + $p.Nome + ': ' + $_.Exception.Message) 'Red' }
}

# =====================================================================
# PASSO 8 -- LA RILETTURA CHE LO DIMOSTRA
# =====================================================================
Dillo '' $null
Dillo '=====================================================================' $null
Dillo ' RISULTATO -- riletto dal disco del terminale FTMO, non dedotto' $null
Dillo ' righe = wc -l (quello che MetaEditor mostra in fondo alla finestra).' $null
Dillo ' Fra parentesi il numero che stampera CODA_06, che conta sempre UNO' $null
Dillo ' IN PIU (classe 456).' $null
Dillo '=====================================================================' $null
$tuttoBene = $true
foreach($s in $lavoro){
  $ok = $false
  $righe = 0
  if(Test-Path -LiteralPath $s.Dst){
    $sc = Scheletro (Leggi-Testo $s.Dst)
    $righe = $sc.Righe
    $ok = ($sc.Righe -eq $s.Righe -and $sc.Sha -eq $s.Sha)
  }
  if(-not $ok){ $tuttoBene = $false }
  $e = 'C E, ED E QUELLO GIUSTO'
  $col = 'Green'
  if(-not $ok){ $e = 'NON C E o E SBAGLIATO -- controllare a mano'; $col = 'Red' }
  Dillo ('  ' + $s.Nome.PadRight(46) + 'righe ' + (DueRighelli $righe).PadRight(22) + $e) $col
  Dillo ('      ' + $s.Sedia) $null
}
Dillo '' $null
foreach($p in $presetOk){
  $c = 'MANCA -- controllare a mano'
  $col = 'Red'
  if(Test-Path -LiteralPath $p.Dst){
    if($p.StatoP -eq 'PRESENTE DIVERSO'){ $c = 'c era gia e DIVERSO: LASCIATO COM ERA (repo messo accanto, _DAL_REPO.set)'; $col = 'Yellow' }
    elseif($p.StatoP -eq 'GIA IDENTICO'){ $c = 'era gia identico: non toccato'; $col = 'Green' }
    else { $c = 'copiato adesso'; $col = 'Green' }
  } else { $tuttoBene = $false }
  Dillo ('  preset ' + $p.Nome.PadRight(56) + '  ' + $c) $col
}
foreach($p in $presetMancanti){
  Dillo ('  preset ' + $p.Nome.PadRight(56) + '  NON ESISTE AL PIN -> sedia ' + $p.Sedia + ' NON ACCENDIBILE') 'Yellow'
}

# ---------------------------------------------------------------------
# GLI ORARI E LE TAGLIE DEI PRESET. Si STAMPANO, non si cambiano.
#
# ATTENZIONE, QUI IL SIGNIFICATO E' CAMBIATO CON IL RIPUNTAMENTO DEL
# 20/09, ED E' LA RAGIONE PER CUI IL MARCATORE E' PASSATO A v2.
# La v1 pescava i preset BCM e stampava la PROPOSTA "BCM X -> FTMO X+2".
# Adesso i preset arrivano da mql5/Presets/FTMO e sono GIA' RIMAPPATI:
# ristampare "+2" direbbe a Claudio di portare il DAX da 10 a 12, cioe'
# ESATTAMENTE il danno che la tabella doveva evitare. Quindi:
#   - preset col marcatore "RIMAPPATO PER L'OROLOGIO" -> si stampano le
#     ore COSI' COME SONO, con scritto GIA' FTMO, NON TOCCARE;
#   - preset SENZA marcatore (oggi: solo quello del Guardian) -> si
#     stampa la proposta +2, perche' quello nessuno l'ha rimappato.
# ---------------------------------------------------------------------
Dillo '' $null
Dillo '=====================================================================' $null
Dillo ' GLI ORARI DENTRO I PRESET COPIATI' $null
Dillo ' Questo script NON ha cambiato nessun valore: legge e stampa.' $null
Dillo ' Valori >= 24 sono sentinelle (non orari): non si rimappano.' $null
Dillo '=====================================================================' $null
$daRimappare = @()
foreach($p in $presetOk){
  $giaFtmo = ($p.Testo -match "RIMAPPATO PER L'OROLOGIO")
  $righeOra = @()
  foreach($r in ($p.Testo -split "`n")){
    $m = [regex]::Match($r, '^\s*(Inp[A-Za-z0-9_]*Hour)\s*=\s*([0-9]+)\s*$')
    if($m.Success){
      $nomeI = $m.Groups[1].Value
      $val = [int]::Parse($m.Groups[2].Value, $INV)
      if($giaFtmo){
        $righeOra += ('      ' + $nomeI.PadRight(24) + 'FTMO ' + $val.ToString($INV).PadLeft(2) + '   (gia rimappato: NON TOCCARE)')
      } elseif($val -ge 24){
        $righeOra += ('      ' + $nomeI.PadRight(24) + 'BCM ' + $val.ToString($INV).PadLeft(2) + '  ->  FTMO ' + $val.ToString($INV).PadLeft(2) + '   (sentinella, NON un orario)')
      } else {
        $nuovo = ($val + 2) % 24
        $righeOra += ('      ' + $nomeI.PadRight(24) + 'BCM ' + $val.ToString($INV).PadLeft(2) + '  ->  FTMO ' + $nuovo.ToString($INV).PadLeft(2) + '   <<< DA CAMBIARE A MANO')
      }
    }
  }
  if($righeOra.Count -gt 0){
    if($giaFtmo){
      Dillo ('  ' + $p.Sedia.PadRight(26) + 'GIA FTMO   (' + $p.Nome + ')') 'Green'
    } else {
      Dillo ('  ' + $p.Sedia.PadRight(26) + 'DA RIMAPPARE A MANO   (' + $p.Nome + ')') 'Yellow'
      $daRimappare += $p
    }
    foreach($r in $righeOra){ Dillo $r $null }
  }
}
if($daRimappare.Count -eq 0){
  Dillo '' $null
  Dillo '  Nessun preset da rimappare a mano: gli orari sono gia quelli FTMO.' 'Green'
} else {
  Dillo '' $null
  Dillo ('  ATTENZIONE: ' + $daRimappare.Count.ToString($INV) + ' preset NON sono rimappati e vanno corretti a mano:') 'Yellow'
  foreach($p in $daRimappare){ Dillo ('    - ' + $p.Nome + '  (' + $p.Sedia + ')') 'Yellow' }
}

# ---------------------------------------------------------------------
# LE TAGLIE. NON sono una decisione dello script ne' mia: si STAMPANO
# perche' InpRiskPercent e' territorio di Claudio (CLAUDE.md) e perche'
# nei preset di stasera NON sono tutte uguali. Un numero che cambia da
# un file all'altro deve stare sotto gli occhi, non dentro un file.
# ---------------------------------------------------------------------
Dillo '' $null
Dillo '=====================================================================' $null
Dillo ' LE TAGLIE (InpRiskPercent) CHE STANNO NEI PRESET -- DA FIRMARE' $null
Dillo ' Lo script NON le ha scelte e NON le ha cambiate: le legge.' $null
Dillo '=====================================================================' $null
$taglie = @{}
foreach($p in $presetOk){
  $mm = [regex]::Match($p.Testo, '(?m)^\s*InpRiskPercent\s*=\s*([0-9.]+)\s*$')
  $v = 'non presente'
  if($mm.Success){ $v = $mm.Groups[1].Value }
  Dillo ('  ' + $p.Sedia.PadRight(26) + 'InpRiskPercent = ' + $v) $null
  if($mm.Success){ $taglie[$v] = 1 }
}
if($taglie.Count -gt 1){
  Dillo '' $null
  Dillo ('  ATTENZIONE: nei preset ci sono ' + $taglie.Count.ToString($INV) + ' TAGLIE DIVERSE.') 'Yellow'
  Dillo '  Non e un difetto dello script: e una decisione che manca. Il cap C1 (3,25%)' 'Yellow'
  Dillo '  e tarato su 5 posizioni da 0,65%. Con taglie miste il conto del margine non' 'Yellow'
  Dillo '  corrisponde a nessuna riga della tabella del pacchetto: leggi il referto' 'Yellow'
  Dillo '  report/SCHIERAMENTO_FTMO_2026-09-20.md paragrafo 9 PRIMA di dare OK.' 'Yellow'
}

Dillo '' $null
Dillo '=====================================================================' $null
Dillo ' LE SEDIE CHE NON HO SCHIERATO, E PERCHE (non e una dimenticanza)' $null
Dillo '=====================================================================' $null
foreach($x in $SOSPESE){ Dillo ('  - ' + $x) 'Yellow' }

# ---------------------------------------------------------------------
# LA RACCOLTA: referto sul Desktop del VPS + zip, con l elenco atteso.
# ---------------------------------------------------------------------
Dillo '' $null
Dillo '=====================================================================' $null
Dillo ' ADESSO TOCCA A TE, E SOLO A MANO (nell ordine)' $null
Dillo '=====================================================================' $null
Dillo ('  1. MetaEditor del terminale FTMO ' + $ContoAtteso + ' (' + $prog + ')') 'Yellow'
Dillo '  2. F7 sui .mq5 copiati. Se uno e gia aperto in una scheda, CHIUDILA senza' 'Yellow'
Dillo '     salvare e riaprila: altrimenti salvi sopra il sorgente appena messo.' 'Yellow'
Dillo '  3. il primo F7 deve essere ABTG_Guardian.mq5: se l include non va, lo scopri' 'Yellow'
Dillo '     al primo colpo e non al settimo.' 'Yellow'
Dillo '  4. poi grafici, poi preset, poi la rimappatura degli orari, poi AutoTrading.' 'Yellow'
Dillo '     L ordine completo e i tempi stanno in report/SCHIERAMENTO_FTMO_2026-09-20.md' 'Yellow'
Dillo '' $null
Dillo '  QUESTA RIGA NON HA COMPILATO NIENTE, NON HA ATTACCATO NESSUN EA E NON HA' $null
Dillo '  TOCCATO NESSUN PROCESSO. Ha copiato file, e basta.' $null

$CRONO.Stop()
Dillo '' $null
Dillo ('  durata: ' + $CRONO.Elapsed.TotalSeconds.ToString('F1', $INV) + ' s  (tetto dichiarato: 120 s. Oltre, e la rete.)') $null

$fRef = Posa-Referto
$zip = Join-Path $DESKTOP ('SCHIERA_FTMO_' + $STAMPA + '.zip')
try {
  Compress-Archive -Path (Join-Path $CARTREF '*') -DestinationPath $zip -Force
} catch {
  Write-Host ('zip non riuscito: ' + $_.Exception.Message) -ForegroundColor Yellow
  $zip = '(non creato)'
}
Write-Host ''
Write-Host 'LA RACCOLTA (sul Desktop del VPS):' -ForegroundColor Green
Write-Host ('  cartella: ' + $CARTREF) -ForegroundColor Green
Write-Host ('  referto : ' + $fRef) -ForegroundColor Green
Write-Host ('  zip     : ' + $zip) -ForegroundColor Green
Write-Host '  dentro lo zip devi trovare:' -ForegroundColor Green
Write-Host ('    - SCHIERA_FTMO_' + $STAMPA + '_referto.txt  (tutto quello che hai letto qui sopra)') -ForegroundColor Green
Write-Host '    - SCARICATI\  (i file presi dai pin, come verifica)' -ForegroundColor Green
if($daSalvare.Count -gt 0){ Write-Host '    - ORIGINALI_SOVRASCRITTI\  (quello che c era prima)' -ForegroundColor Green }
Write-Host ''

if($tuttoBene){ exit 0 } else {
  Write-Host '  ALMENO UN FILE NON E ENTRATO: NON premere F7, manda lo zip.' -ForegroundColor Red
  exit 2
}
