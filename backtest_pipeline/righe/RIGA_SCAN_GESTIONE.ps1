# =====================================================================
#  MARCATORE_RIGA_SCAN_GESTIONE_v2
#  RIGA_SCAN_GESTIONE.ps1 -- lo STUDIO DELLA GESTIONE sul terminale da
#  backtest, con le guardie di RIGA_ROUND_VPS.ps1 (non reinventate).
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (09/09/2026)
#  scan_gestione.ps1 e' scritto dal 14/08 e NON E' MAI STATO LANCIATO
#  (audit delle uscite, report\AUDIT_USCITE_2026-09-09.md). Ma e' del
#  tempo in cui c'era UN SOLO MT5: lanciato oggi sul VPS avrebbe
#  ricompilato l'EA dentro la cartella del PICCOLO (50503392), che ha le
#  sedie VIVE. La v2 dello script chiude quel buco alla radice; questa
#  riga aggiunge il resto del cinturone gia' collaudato:
#    - LA GUARDIA POSITIVA sul bersaglio (11/09/2026): non elenca i
#      vietati, AMMETTE un solo bersaglio e uccide tutto il resto -- il
#      piccolo 50503392, il 100k 50504263, il REALE 10105439, la
#      challenge FTMO 541452707, la radice di un disco, i nomi 8.3 e la
#      fuga col '..'. E' la copia dichiarata (byte per byte, e c'e' una
#      macchina che lo controlla) di quella di RIGA_ROUND_VPS.ps1.
#      DAL 21/09/2026 E' PER MACCHINA: una tabella dice quale terminale
#      e' ammesso su quale PC (VMI3047753 = il VPS -> C:\MT5_Backtest;
#      DESKTOP-H4D7CAJ = il PC di backtest -> il suo terminale), perche'
#      lo STESSO percorso e' il bersaglio di qua e il piccolo 50503392
#      con le sedie vive di la'. Macchina non in tabella = si rifiuta;
#    - censimento PID PRIMA e DOPO, con allarme rosso se sparisce un
#      terminale NON bersaglio: e' la prova STAMPATA che il reale non e'
#      stato toccato;
#    - chiusura CHIRURGICA del solo terminale da backtest (classe 159);
#    - PIN di commit sullo script e sull'EA (classe 164);
#    - raccolta con ZIP sul Desktop, sempre, anche se una corsa fallisce.
#
#  COSA MISURA (e cosa NO)
#    48 combinazioni di USCITA a tick reali, INGRESSO FISSATO ai default:
#      parziale 0/50% x BE-dopo-parziale x BE indipendente x
#      trailing OFF/ATR/PREVBAR/FIXED.
#    NON tocca l'ingresso, NON promuove niente, NON scrive in forward.
#    Il metro esiste gia': R46 ha misurato che la sola struttura d'uscita
#    sposta il DAX da PF 0,88 a PF 1,49 fuori campione. Qui si cerca il
#    CENTRO DELL'ALTOPIANO, mai il picco.
#
#  NIENTE EMOJI: Windows PowerShell 5.1 legge i .ps1 come ANSI.
# =====================================================================
param(
  [string]$Pin               = "lavoro",
  # 21/09/2026: il default NON e' piu' un percorso cablato (era
  # "C:\MT5_Backtest", che sta SOLO sul VPS). Vuoto = "usa il bersaglio
  # della macchina su cui sto girando", che la tabella decide. Su una
  # macchina non in tabella resta vuoto e viene RIFIUTATO: il vuoto non
  # e' un permesso.
  [string]$TerminaleBacktest = "",
  [string]$Work              = "$env:USERPROFILE\abtg_gestione",
  [string]$Fase              = "struttura",
  [switch]$ChiudiBacktest,
  [switch]$SoloControllo
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$MARC_MIO = "MARCATORE_RIGA_SCAN_GESTIONE_v2"   # v2 = guardia PER MACCHINA (21/09/2026)
$MARC_SCN = "MARCATORE_SCAN_GESTIONE_v2_VPS"
$RawBase  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"
$Avvio    = Get-Date

function Muori($m){ Write-Host ""; Write-Host ("ERRORE: " + $m) -ForegroundColor Red; exit 1 }

# --- LE DUE CORSE. Ora SERVER BCM (= italiana - 1): DAX 8, Nasdaq 14.
$CORSE = @(
  @{ Robot="ABTG_DAX_Apertura_EU";    Symbol="D30EUR"; Ora=8  },
  @{ Robot="ABTG_Nasdaq_Apertura_US"; Symbol="NASUSD"; Ora=14 }
)

Write-Host ""
Write-Host "=== STUDIO GESTIONE -- fase '$Fase' -- pin $Pin ===" -ForegroundColor Cyan

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

# ---------------------------------------------------------------------
#  L'ADATTATORE DI QUESTO FILE (21/09/2026). Sta FUORI dal blocco
#  condiviso apposta: il blocco e' identico nei tre file e non puo'
#  contenere niente che sia "di questo file". Qui si legge LA MACCHINA e
#  si ricava il bersaglio; i nomi $BANCO_PERC / $BANCO_CONTO restano
#  quelli di prima perche' li usano i messaggi piu' sotto -- cambia il
#  CONTENUTO, non il nome.
# ---------------------------------------------------------------------
$MACCHINA = NomeMacchinaPulito $env:COMPUTERNAME

# IL GUARDIANO DEL GUARDIANO: la tabella e' scritta a mano, e una guardia
# che si regge su una tabella rotta non e' una guardia.
$motivoTab = TabellaCoerente
if($motivoTab -ne ""){
  Muori ("LA TABELLA DEI BERSAGLI E' SCRITTA MALE: " + $motivoTab + "`n" +
         "    Non parto. Si corregge `$BERSAGLI_PER_MACCHINA nel blocco condiviso --`n" +
         "    e nelle ALTRE DUE copie, nello stesso commit -- e si ripassa dal cancello.")
}

$rigaMac     = RigaMacchina $MACCHINA
$BANCO_PERC  = ""
$BANCO_CONTO = ""
if($null -ne $rigaMac){ $BANCO_PERC = $rigaMac.perc; $BANCO_CONTO = $rigaMac.conto }

# LA MACCHINA SI DICHIARA, e prima di tutto il resto (regola dei
# terminali multipli, 06/09 e 12/09).
Write-Host ("  pc  : " + $(if($MACCHINA -ne ""){$MACCHINA}else{"<COMPUTERNAME VUOTO>"}))
Write-Host ("  term: " + $(if(("" + $TerminaleBacktest).Trim() -ne ""){$TerminaleBacktest}else{"<non passato: lo decide la tabella per macchina>"}))

# IL BERSAGLIO NON PASSATO SI RISOLVE, NON SI INDOVINA. Su una macchina
# sconosciuta resta vuoto apposta, e due righe piu' sotto viene rifiutato.
if(("" + $TerminaleBacktest).Trim() -eq "" -and $null -ne $rigaMac){
  $TerminaleBacktest = $rigaMac.perc
  Write-Host ("  -TerminaleBacktest non passato: su " + $rigaMac.macchina + " il bersaglio e' " + $rigaMac.perc) -ForegroundColor DarkGray
  Write-Host  "  (e passa comunque da TUTTI i controlli qui sotto, come se l'avessi scritto tu)." -ForegroundColor DarkGray
}

# =====================================================================
#  1. IL TERMINALE: LA GUARDIA E' POSITIVA **E PER MACCHINA**
#     (positiva dall'11/09/2026, per macchina dal 21/09/2026)
# =====================================================================
# PRIMA ERA NEGATIVA, ED ERA LA COPIA LETTERALE DELLA GUARDIA VECCHIA:
# "-like *-V3* oppure *BCM_Reale*". Eseguita contro bersagli finti,
# lasciava passare QUATTRO cose, e tre sono terminali VERI del VPS:
#   C:\Program Files\BCM Markets MT5 Terminal -> il PICCOLO 50503392, che
#       ha le sedie VIVE sopra ed e' proprio quello che questa riga e'
#       nata per NON toccare (vedi l'intestazione, 09/09/2026);
#   C:\  -> la RADICE di un disco, e qui il danno non e' teorico: la pipe
#       di Bersagli()/Risparmiati() qui sotto e' ($cartellaBT + "\*"), che
#       con la radice diventa "C:\*" = OGNI terminal64 della macchina,
#       conto REALE 10105439 compreso, e li chiude tutti con -ChiudiBacktest;
#   C:\PROGRA~1\BCMMAR~1 -> lo stesso posto del piccolo scritto in nome
#       8.3: una lista di divieti guarda le LETTERE, non il POSTO;
#   C:\MT5_Backtest\..\Program Files\BCM Markets MT5 Terminal -> nomina il
#       banco, ma il '..' porta altrove.
# Adesso dice UNA COSA SOLA: DEVE ESSERE IL BERSAGLIO DI QUESTA MACCHINA.
# Ed e' la forma giusta per QUESTA riga, che non e' uno scandaglio di
# sola lettura: compila un EA dentro la cartella dati del terminale
# bersaglio e ci fa girare il tester.
# 21/09/2026: il bersaglio non e' piu' UNO per tutti, e' uno PER
# MACCHINA. Sul VPS resta il banco C:\MT5_Backtest (demo 50504400,
# solo-tester); sul PC di backtest e' il suo terminale, che pero' E'
# LOGGATO SU UN CONTO VIVO (50503392) -- percio' qui sotto, su quella
# macchina, si stampa un'AVVERTENZA e non si fa finta che sia un banco.
$motivoNo = MotivoRifiutoBersaglio $TerminaleBacktest $MACCHINA
if($motivoNo -ne ""){
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
         "    terminale su UNA macchina. Se un bersaglio cambiasse casa, o nascesse`n" +
         "    una macchina nuova, si cambia LA TABELLA, a mano, e si ripassa dal`n" +
         "    cancello.")
}
# LA COSTANTE, NON LA STRINGA DI FUORI. E' questa riga che chiude il buco
# della radice del disco: la pipe qui sotto e' SEMPRE la cartella della
# tabella + "\*" e non puo' diventare "C:\*" per colpa di come e' stato
# scritto un argomento. Vale anche per $exeBT e $medBT, che nascono da qui.
# $rigaMac qui NON puo' essere $null: se lo fosse, MotivoRifiutoBersaglio
# avrebbe gia' detto "MACCHINA SCONOSCIUTA" e saremmo morti sopra.
$cartellaBT = $rigaMac.perc
Write-Host ("  bersaglio AMMESSO su " + $rigaMac.macchina + ": " + $cartellaBT + "   (conto " + $BANCO_CONTO + ")") -ForegroundColor Green
# L'AVVERTENZA CHE COSTA, stampata SOLO dove e' vera. Sul PC di backtest
# il bersaglio non e' un banco solo-tester: e' loggato sul demo piccolo
# 50503392 e il 14/08/2026 da quella macchina sono PARTITI ordini veri
# (#3160534/#3160535, -104,60). Questa riga COMPILA e fa girare il tester
# li' dentro, e con -ChiudiBacktest lo chiude: sapere non e' controllare,
# ma chi lancia deve almeno sapere.
if($rigaMac.deroga){
  Write-Host ""
  Write-Host "  +---------------------------------------------------------------+" -ForegroundColor Yellow
  Write-Host "  | AVVERTENZA SUL BERSAGLIO -- LEGGERE PRIMA DI -ChiudiBacktest   |" -ForegroundColor Yellow
  Write-Host "  +---------------------------------------------------------------+" -ForegroundColor Yellow
  Write-Host ("  Questo terminale e' loggato sul conto " + $BANCO_CONTO + " (demo piccolo), NON e'") -ForegroundColor Yellow
  Write-Host  "  un banco solo-tester come C:\MT5_Backtest sul VPS." -ForegroundColor Yellow
  Write-Host  "  Il 14/08/2026 da QUESTA macchina sono partiti ordini veri:" -ForegroundColor Yellow
  Write-Host  "  #3160534 / #3160535 -> -104,60 sul piccolo (DAX_14-08_DUE_MOTORI.md r.401)." -ForegroundColor Yellow
  Write-Host  "  Prima di lanciare: guarda che non abbia SEDIE attaccate ai grafici." -ForegroundColor Yellow
}
if(-not (Test-Path -LiteralPath $cartellaBT -PathType Container)){ Muori ("la cartella '" + $cartellaBT + "' non esiste.") }
# --- GUARDIA_BANCO_POSITIVA_v2, GRADINO f (COPIA dichiarata dello stesso
#     gradino di RIGA_ROUND_VPS.ps1). Sta FUORI dal blocco condiviso
#     perche' il blocco e' PURO e questo tocca il disco: e' il gradino
#     che la sola stringa NON puo' fare, perche' un nome giusto puo'
#     puntare nel posto sbagliato se la cartella e' una junction.
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
         "    Se il terminale " + $BANCO_CONTO + " e' davvero installato cosi', si guarda`n" +
         "    insieme dove punta e si cambia LA TABELLA. Non si tira a indovinare.")
}
$exeBT = Join-Path $cartellaBT "terminal64.exe"
$medBT = Join-Path $cartellaBT "metaeditor64.exe"
if(-not (Test-Path -LiteralPath $exeBT -PathType Leaf)){ Muori ("in '" + $cartellaBT + "' non c'e' terminal64.exe.") }
if(-not (Test-Path -LiteralPath $medBT -PathType Leaf)){ Muori ("in '" + $cartellaBT + "' non c'e' metaeditor64.exe: senza compilatore lo studio non parte.") }

function Terminali(){ return @(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) }
function Bersagli($p){ return @($p | Where-Object { $_.Path -and ($_.Path -like ($cartellaBT + "\*")) }) }
function Risparmiati($p){ return @($p | Where-Object { -not ($_.Path -and ($_.Path -like ($cartellaBT + "\*"))) }) }

$tutti = Terminali; $berPri = Bersagli $tutti; $salPri = Risparmiati $tutti
$pidSalvi = @($salPri | ForEach-Object { $_.Id })

Write-Host ""
Write-Host "--- TERMINALI MT5 VISTI ADESSO (PRIMA) ------------------------------" -ForegroundColor Cyan
if($berPri.Count -eq 0){ Write-Host "  BERSAGLIO (backtest): nessuno vivo. Bene." -ForegroundColor Green }
else{ Write-Host "  BERSAGLIO (backtest, l'unico che posso chiudere):" -ForegroundColor Yellow
      $berPri | ForEach-Object { Write-Host ("    PID " + $_.Id + "    " + $_.Path) -ForegroundColor Yellow } }
Write-Host "  LASCIATI VIVI (forward e CONTO REALE: NON li tocco):" -ForegroundColor Green
if($salPri.Count -eq 0){ Write-Host "    (nessuno)" -ForegroundColor Green }
else{ $salPri | ForEach-Object { Write-Host ("    PID " + $_.Id + "    " + $(if($_.Path){$_.Path}else{"<percorso non leggibile: NON e' un bersaglio>"})) -ForegroundColor Green } }
Write-Host "---------------------------------------------------------------------" -ForegroundColor Cyan

if($berPri.Count -gt 0 -and -not $SoloControllo){
  if(-not $ChiudiBacktest){ Muori "il terminale da backtest e' aperto: rilancia con -ChiudiBacktest (chiudo SOLO quello)." }
  Write-Host "  chiudo SOLO il bersaglio..." -ForegroundColor Yellow
  $berPri | ForEach-Object { try{ Stop-Process -Id $_.Id -Force -ErrorAction Stop }catch{} }
  Start-Sleep -Seconds 4
}

# --- CARTELLA DATI: prima il portable (MQL5 dentro l'installazione), poi
#     origin.txt in APPDATA. Si STAMPA quale delle due ha vinto.
$DataFolder = ""; $viaDati = ""
if(Test-Path -LiteralPath (Join-Path $cartellaBT "MQL5") -PathType Container){
  $DataFolder = $cartellaBT; $viaDati = "PORTABLE (MQL5 dentro l'installazione)"
} else {
  $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  if(Test-Path $termRoot){
    $d = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
           $o = Join-Path $_.FullName "origin.txt"
           (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $cartellaBT)
         } | Select-Object -First 1
    if($d){ $DataFolder = $d.FullName; $viaDati = "APPDATA via origin.txt" }
  }
}
if(-not $DataFolder){ Muori "cartella dati MT5 non trovata ne' portable ne' via origin.txt." }
Write-Host ("  cartella dati : " + $DataFolder + "   [" + $viaDati + "]") -ForegroundColor Gray

# =====================================================================
#  2. LO SCRIPT DALLO STESSO PIN, COL SUO MARCATORE
# =====================================================================
New-Item -ItemType Directory -Force -Path $Work | Out-Null
$scn = Join-Path $Work "scan_gestione.ps1"
Remove-Item $scn -ErrorAction SilentlyContinue
$u = $RawBase + "/backtest_pipeline/scan_gestione.ps1?cb=" + [guid]::NewGuid().ToString()
try{ Invoke-WebRequest -Uri $u -OutFile $scn -UseBasicParsing }catch{ Muori ("download di scan_gestione.ps1 fallito dal pin " + $Pin) }
if(-not (Select-String -Path $scn -SimpleMatch -Pattern $MARC_SCN -Quiet)){
  Muori ("scan_gestione.ps1 scaricato NON e' la v2 (manca " + $MARC_SCN + "): la v1 puo' ricompilare dentro il terminale del PICCOLO. Fermato.")
}
Write-Host ("  scan_gestione : v2 verificata (" + $MARC_SCN + ")") -ForegroundColor Green

if($SoloControllo){
  Write-Host ""
  Write-Host "GIRO A VUOTO: guardie passate, dati e script a posto. Niente e' stato lanciato." -ForegroundColor Cyan
  Write-Host "ATTENZIONE: il giro a vuoto NON compila e NON collauda il tester." -ForegroundColor Yellow
  exit 0
}

# =====================================================================
#  3. LE DUE CORSE
# =====================================================================
$esiti = @()
foreach($c in $CORSE){
  Write-Host ""
  Write-Host ("=== CORSA: " + $c.Robot + " su " + $c.Symbol + "   (SessionHour SERVER=" + $c.Ora + ") ===") -ForegroundColor Cyan
  & powershell -NoProfile -ExecutionPolicy Bypass -File $scn `
      -Robot $c.Robot -Symbol $c.Symbol -SessionHour $c.Ora -Fase $Fase -Pin $Pin `
      -Terminal $exeBT -MetaEditor $medBT -DataFolder $DataFolder -Force
  $rc = $LASTEXITCODE
  $esiti += [pscustomobject]@{ Robot=$c.Robot; Symbol=$c.Symbol; Rc=$rc }
  Write-Host ("--- ESITO " + $c.Symbol + ": rc=" + $rc) -ForegroundColor Cyan
}

# =====================================================================
#  4. CENSIMENTO DOPO -- LA PROVA STAMPATA
# =====================================================================
$dopo = Terminali; $salDopo = Risparmiati $dopo
$pidDopo = @($salDopo | ForEach-Object { $_.Id })
$spariti = @($pidSalvi | Where-Object { $pidDopo -notcontains $_ })
Write-Host ""
Write-Host ("PID non bersaglio PRIMA: " + ($pidSalvi -join ", ")) -ForegroundColor Gray
Write-Host ("PID non bersaglio DOPO : " + ($pidDopo  -join ", ")) -ForegroundColor Gray
if($spariti.Count -gt 0){
  Write-Host ("!!! ALLARME: sono spariti terminali NON bersaglio: " + ($spariti -join ", ")) -ForegroundColor Red
} else {
  Write-Host "OK: nessun terminale non bersaglio e' stato toccato." -ForegroundColor Green
}

# =====================================================================
#  5. RACCOLTA -- SEMPRE, anche se una corsa e' fallita
# =====================================================================
$dsk = [Environment]::GetFolderPath("Desktop")
$dir = Join-Path $dsk ("GESTIONE_" + $Fase.ToUpper())
if(Test-Path -LiteralPath $dir){ Remove-Item -LiteralPath $dir -Recurse -Force }
New-Item -ItemType Directory -Force -Path $dir | Out-Null

$sorgente = Join-Path $Work "risultati_gestione"
$copiati = 0
if(Test-Path -LiteralPath $sorgente){
  Get-ChildItem -LiteralPath $sorgente -Filter *.csv -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime -ge $Avvio } |
    ForEach-Object { Copy-Item $_.FullName -Destination $dir -Force; $copiati++ }
}
$ref = Join-Path $dir "REFERTO_GESTIONE.txt"
$righe = @()
$righe += "REFERTO STUDIO GESTIONE"
$righe += ("marcatore riga  : " + $MARC_MIO)
$righe += ("marcatore script: " + $MARC_SCN)
$righe += ("pin             : " + $Pin)
$righe += ("data            : " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") + "   <-- SE NON E' DI OGGI, IL FILE E' VECCHIO")
$righe += ("terminale       : " + $exeBT)
$righe += ("cartella dati   : " + $DataFolder + "   [" + $viaDati + "]")
$righe += ("fase            : " + $Fase)
$righe += ""
foreach($e in $esiti){ $righe += ("  " + $e.Robot + " / " + $e.Symbol + "   rc=" + $e.Rc) }
$righe += ""
$righe += ("CSV raccolti    : " + $copiati)
if($copiati -eq 0){ $righe += "  ATTENZIONE: zero CSV. NON vuol dire 'nessun edge': vuol dire NON E' GIRATA. Guardare il log." }
$righe += ""
$righe += ("PID non bersaglio PRIMA: " + ($pidSalvi -join ", "))
$righe += ("PID non bersaglio DOPO : " + ($pidDopo  -join ", "))
# NOTA: niente "(if ...)" come espressione fra parentesi -- pwsh 7 lo
# accetta, Windows PowerShell 5.1 no. Sul VPS gira la 5.1.
if($spariti.Count -gt 0){ $righe += ("ALLARME: spariti " + ($spariti -join ", ")) }
else                    { $righe += "OK: nessun terminale non bersaglio toccato." }
$righe | Set-Content -Path $ref -Encoding ASCII

$zip = Join-Path $dsk ("GESTIONE_" + $Fase.ToUpper() + ".zip")
if(Test-Path -LiteralPath $zip){ Remove-Item -LiteralPath $zip -Force }
Compress-Archive -Path (Join-Path $dir "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("ZIP PRONTO DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host ("  CSV dentro: " + $copiati) -ForegroundColor Gray
Write-Host "  REFERTO_GESTIONE.txt" -ForegroundColor Gray
if($copiati -eq 0){ exit 2 } else { exit 0 }
