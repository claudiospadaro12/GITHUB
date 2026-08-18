# HANDOFF — punto d'ingresso per una chat nuova

> **Da incollare in una chat nuova:**
> *"Leggi `HANDOFF.md`, `PIANO_PROP.md`, `CACCIA_MOTORE_APERTURE.md`, `FLOTTA_ATTIVA.md`, `PROMEMORIA_APERTURE.md` e `backtest_pipeline/risultati_archivio/CLASSIFICHE.md` nel branch `lavoro` del repo `claudiospadaro12/GITHUB` e riprendi da li'."*
>
> Ultimo aggiornamento: **2026-08-15 mattina**. **Branch unico di lavoro: `lavoro`** (qui e' consolidato TUTTO).

---

## 🧾 AGGIORNAMENTO NOTTE 18->19/08 (agente in background) — HISTDATA: scritta la cura DST, da collaudare

Il passo 4 dell'import HistData e' **fermo al cancello ZERO** (par. 14 di
`backtest_pipeline/risultati_archivio/REFERTO_HISTDATA_FATTIBILITA.md`): i tre
indici `_EXT` hanno diff media H1 **0,061-0,101%** contro il **<=0,05%**
richiesto, con shift +5 confermato 3 volte su 3. Diagnosi: **HistData scrive in
ora locale di New York (calendario DST USA), il server BCM segue il DST
europeo**, e per **503-671 ore l'anno** i due calendari non coincidono -> uno
shift costante sbaglia di un'ora.

- **Deliverable**: `mql5/Scripts/ABTG_ImportaStoricoEsterno_v2.mq5`
  (`IMP-EXT-v2`). Shift che segue **entrambi** i calendari, domeniche di cambio
  ora **calcolate** (vale 2000-2040), referto con **le due misure affiancate**
  (DST-aware + shift fisso come controprova), spaccatura della diff **dentro e
  fuori** le finestre sfasate, diagnosi del residuo (bias mediano), autotest
  integrato. **La v1 non e' stata toccata.**
- **NON COMPILATO, NON PROVATO** (niente MetaEditor in cloud). Collaudo in due
  passi nel par. **14-bis**: prima `InpAutoTest=true` (deve dare `0 ROTTI`),
  poi il re-import dei tre indici.
- **Previsione dichiarata prima della misura**: la cura DST e' **necessaria ma
  probabilmente non sufficiente** (SPXUSD forse passa al pelo, NASUSD e 225JPY
  probabilmente no): il resto sembra **basis indice-cash contro CFD-su-future**,
  che col fuso non c'entra. Se e' cosi', **non si aggiungono pezze**: si porta
  il numero a Claudio e si decide se 0,05% e' il cancello giusto per gli indici.
- **Sugli 8 forex del 15/08**: hanno **lo stesso difetto**, ma sotto soglia
  (un'ora di forex vale ~0,05% del prezzo, un'ora di indice ~0,2-0,3%).
  **Nessuna re-importazione decisa**: il loro numero puo' solo migliorare.
- Le **righe di lancio sono solo BOZZA-DA-VERIFICARE** (par. 14-bis.6): le
  scrive la sessione principale. Attenzione: `importa_storico_esterno.ps1`
  oggi scarica e compila **la v1**.

---

## 🧾 AGGIORNAMENTO 18/08 (agente in background) — DUKASCOPY: la pipeline e' pronta, tocca al PC

Missione "storico indici Dukascopy" chiusa lato cloud
(`backtest_pipeline/risultati_archivio/REFERTO_DUKASCOPY_FATTIBILITA.md`):
- **dal cloud NON si scarica** (proxy: 403 sul CONNECT, misurato su due
  canali) → strada (b), la pipeline gira **sul PC di Claudio**;
- date gia' misurate dalla sonda del 15/08: **DAX/Dow/Nasdaq dal 2012,
  Nikkei dal 2013** → le finestre di regime 2019-2022 degli indici sono a
  portata di mano;
- deliverable: `backtest_pipeline/dukascopy/dukascopy_m1.py` — tick `.bi5`
  → M1 CSV **Formato 1** (quello che `ABTG_ImportaStoricoEsterno` legge
  gia'), ordine campi e divisore **misurati a runtime**, fuso `ny` =
  convenzione HistData (controprova obbligatoria: **shift calibrato +5**),
  autotest sintetico 6/6 passato;
- **prossimo passo di Claudio**: le due righe del passo 1 (`--autotest` +
  `--validazione`, referto sez. 7) e mandare lo zip in chat. Poi la corsa
  notturna 2019→oggi, un simbolo alla volta, e l'ultimo miglio verso
  `D30EUR_EXT` e fratelli (cancello ZERO + lezione R80 obbligatori).

---

## 🧾 AGGIORNAMENTO 15/08 — quattro round chiusi in una notte, e il fantasma misurato fino in fondo

### 0. IL NUMERO CHE RIBALTA DUE SETTIMANE DI LETTURE

Il fantasma sul PC **non erano due giornate: erano SEDICI**. Censimento di
tutti gli `order #` nei giornali di entrambe le macchine
(`report/CENSIMENTO_ORDINI_PC.md`):

| il PC ha piazzato | |
|---|---:|
| ordini sul conto vivo 50503392 | **174** |
| giorni distinti (06/07 -> 14/08) | **16** |
| di cui diventati trade veri | **33** |
| netto dei 33 | **-511,28** |

**Il controllo che valida tutto**: dei trade non attribuiti, quelli con un
magic di EA sono **ZERO** — sono tutti manuali/mobile (che non passano dal
giornale desktop) e stanno prima del 22/07. **Per gli EA l'attribuzione e'
completa al 100%.**

> ### Dal 22/07 il conto piccolo fa -340,70, ma il PC ci mette -475,56 e il
> ### VPS **+93,14**. Tolto il fantasma: **+134,86**.
> **La flotta sul VPS non e' in perdita. E' in leggero utile.** Il rosso del
> periodo del vivaio era il fantasma, non la varianza.

Conseguenze scritte e non ancora eseguite:
- il magic **770101 era un miscuglio di due macchine** (15 trade PC per
  -437,87 + 11 VPS per -211,65): va ricalcolato **solo sul VPS** prima di
  confrontarlo con qualunque backtest;
- le classifiche del forward vanno rifatte **escludendo i 33 trade del PC**;
- R47 resta valido come misura del payoff, ma **la premessa "il conto e'
  sotto" era in parte falsa**.

**E il 29/07 alle 08:53:56 lo stesso segnale e' stato eseguito DUE VOLTE da
due macchine** (VPS SELL 1,60 -120,80 · PC SELL 1,60 -115,04 = **-235,84 su un
segnale solo**). La mitigazione A1 non poteva vederlo: un terminale non vede i
pendenti dell'altro.

### 0-bis. 🚨 IL FILO, non gli interruttori

Screenshot del 15/08 alle 07:00, barra del titolo di MT5 **sul PC**:
`50503392 - BCMMarkets-Server`. **Il PC di backtest e' LOGGATO SUL CONTO
VIVO.** Gli EA attaccati e AutoTrading sono i due interruttori; il filo e'
quello. **La chiusura vera del caso non e' staccare gli EA: e' scollegare il PC
dal conto vivo** — il tester gira sullo storico e non ne ha bisogno.

**Metodo che ne esce, e vale piu' del caso**: la firma che distingue chi ha
piazzato da chi guarda e' `order #N ... done in NNN ms` (ha piazzato) contro
`deal #M (based on order #N)` (vede l'esecuzione). E **il controllo positivo**:
in ogni caccia si cerca anche un ticket di cui si conosce gia' la risposta,
altrimenti "non trovato" e' ambiguo — puo' voler dire "non c'e'" oppure "non so
cercare". Strumenti: `caccia_ticket.ps1`, `censimento_ordini.ps1`.

**Onesta' sull'errore**: nella pagella del 14/08 avevo inferito che **tre** stop
pieni fossero del fantasma. Erano **due**: il 06/08 e' del VPS, trade regolare.
Era marcato [INFERITO] ed e' servito a far fare la verifica, ma "tre indizi
convergenti" non vuol dire "vero".

### 1. QUATTRO ROUND CHIUSI, e tre ribaltamenti nuovi

| round | verdetto | il numero |
|---|---|---|
| **R51** reverse DAX | **RISERVA**, resta spento | OOS +74,6% e DD giu', **ma la peggior giornata RADDOPPIA** (-1,07 -> -2,06%) e i due banchi vanno in direzioni opposte. **30° ribaltamento** |
| **R53** fuso Easy Trend | **la fascia NON decide**, si tiene 8-18 | 7-17 e 8-18 pari a 2 voti: serviva 3 su 4. Se fosse un fuso vincerebbe DAPPERTUTTO: e' il pattern delle sessioni di ogni cambio. **29° ribaltamento** (AUDJPY) |
| **R54** i lati mai misurati del Dow | **due short BOCCIATI** | Dow short PF 0,840 (n=73, bocciato per merito); ORB short rosso in entrambe le finestre. **28° ribaltamento**: lo short e' la cella MIGLIORE in campione |
| **R55** slippage | **scala lo STOP LARGO**, non il tipo di ordine | PTE a 200 pt: DD 3,2166 -> 3,2711% (**scala**). ORB: DD 9,76 -> **10,34%**, fuori dal cancello prop con **1,5 punti indice** |

**La scoperta di R55 vale piu' del suo verdetto**: stesso slippage in punti,
sensibilita' che differisce di **undici volte**. Non lo spiega il tipo di
ordine, lo spiega la **larghezza dello stop** (`lotto = R / distanza_stop`).
E' la stessa lezione della FASE H del 07/08 da un'altra porta: **una cella con
lo stop stretto e' fragile due volte.** Criterio gratis su tutte e 32 le celle
vive: basta leggere `InpSLMode`.

**Igiene, tutte e quattro le volte**: gemelli identici al centesimo, e le celle
vive riprodotte contro i round precedenti (R54b = R46 riga 33 al centesimo ·
R53 8-18 = R48 con stesso n=41 · R55 slip 0 = R54b al centesimo).

### 2. FATTO ANCHE

- **Guardia A4 chiusa su tutti e quattro** gli EA Apertura (Dow 1.01, Nasdaq
  1.02, Marco 1.01): `HaGiaOperatoOggi()` restituisce anche `storicoOk`. **E i
  log del 14/08 contengono la fotografia del difetto** — riarmo alle 16:17:43
  su giornata gia' operata, guardia che funziona dalle 16:38. Non era teorica.
  **Da ricompilare sul VPS.**
- **`InpSlippagePts` aggiunto** a `ABTG_PTE` v1.01 e `ABTG_ORB_Ottimizzato`
  v1.01, **default 0 = forward invariato**, come si e' fatto con
  `InpAllowReverse`.
- **Scheda prop Upcomers** (`report/SCHEDA_PROP_UPCOMERS.md`): **NO adesso**.
  Il loro DD e' **TRAILING** e tutte le nostre MC sono su DD statico; piu'
  "best day rule" e payout negati con motivazioni soggettive
  ("one-sided betting") che colpiscono proprio le strategie direzionali
  d'apertura. **Il lavoro che vale comunque: rifare la MC col trailing.**
- **Fuso BCM riconfermato al secondo** su un caso reale: stesso evento, log PC
  09:16:16 (ora locale) e CSV VPS 08:16:16 (ora server).

### 3. DA FARE, in ordine

1. **Controllo di tenuta**: rilanciare `censimento_ordini.ps1` **fra una
   settimana**. Se il PC ha piazzato **zero** ordini nuovi, il caso si chiude.
   **E' l'unica prova che vale.**
2. **Scollegare il PC dal conto vivo** (o metterci un demo separato): e' il
   filo, non l'interruttore.
3. **Staccare gli 11 EA non nostri** dai grafici del PC — a mano in MT5 (tasto
   destro > Consulenti esperti > Rimuovi), cosi' grafici e template restano.
   Checklist coi simboli: `backtest_pipeline/stacca_ea_terzi.ps1` (anteprima,
   non tocca niente). Controllo di chiusura: `EA NON NOSTRI: 0`.
4. Ricalcolare classifiche del forward e magic 770101 **senza i trade del PC**.
5. **Monte Carlo col DD trailing** (serve per qualunque prop moderna).
6. Misura **DST su BCM** (scadenza 25/10/2026) e **Pepperstone** (il conto demo
   non risulta creato: `Invalid account`, ricognitore a 0 file).

---

## 🔴🟢 AGGIORNAMENTO 14/08 SERA — la giornata in cui abbiamo scoperto CHI operava, e i primi dati di regime

### 1. UN EA FANTASMA OPERAVA SUL CONTO DAL **PC**, non dal VPS

Partito dalla domanda di Claudio "cosa e' successo?" su una perdita del DAX.
I due trade gemelli del mattino avevano commenti **diversi**: sul 100k
`DAX Apertura EU RETEST BUY` (BUY LIMIT), sul piccolo `DAX Apertura EU BUY`
(BUY STOP). Sono due rami di codice che non si incrociano.

**Provato dal giornale**, non dedotto: alle 09:25:01 il terminale del **PC di
backtest** (DESKTOP-H4D7CAJ, utente Master, conto **50503392**) ha piazzato
`buy stop 2 D30EUR at 26479.00` (ticket **#3160534**) e il sell stop gemello,
da un grafico **D30EUR M3** con **motore BREAKOUT, range 15, buffer 20 pt,
trailing FIXED M1, rischio 2%** — una configurazione **mai validata**, col
**magic 770101** della cella promossa. Ha perso 1R (−104,60).

**Il meccanismo** (questa e' la parte che vale): i driver lanciano MT5 con
`/config:<ini>` del tester, ma `/config` **avvia il terminale**, che carica
l'ultimo profilo coi grafici e gli EA attaccati. Con AutoTrading acceso quegli
EA operano sul conto collegato. **Ogni backtest sul PC accendeva una seconda
flotta sul conto vivo.** Spiega l'alternanza retest/breakout sul magic 770101
dal 07/08 in poi: i giorni "breakout" sono i giorni in cui si lanciavano
round.

Ed e' **risuccesso alle 16:17:43** dello stesso giorno, mentre indagavamo: due
pendenti veri, cancellati un minuto dopo — nel giornale si vede il gesto di
Claudio che spegne AutoTrading.

**Chiuso con tre lucchetti:** AutoTrading spento sul PC · EA staccato dal
grafico M3 · **23 driver** che generano ini del tester ora scrivono
`[Experts] AllowLiveTrading=false`.
Referto completo, 4 appendici: `report/DAX_14-08_DUE_MOTORI.md`.

### 2. BUG VERO NELLA GUARDIA A4 (corretto)

Il secondo armamento non doveva avvenire. `CicliOggi()` faceva
`if(!HistorySelect(...)) return(0)` — cioe' rispondeva **"non ho operato"**
anche quando lo storico non era ancora sincronizzato all'avvio; e il chiamante
timbrava `gGuardiaGiorno` **prima** di sapere, quindi non ci riprovava mai
piu'. Confondere "non lo so" con "no". Corretto in
`ABTG_DAX_Apertura_EU.mq5` (ora `CicliOggi` restituisce anche `storicoOk`).
~~**Stesso difetto ancora da correggere** in Dow, Nasdaq, Marco.~~
**-> CHIUSO il 14/08 sera su tutti e tre** (vedi aggiornamento 15/08 §2).

### 3. R50 — LA PRIMA PROVA DI REGIME DELLA STORIA DEL PROGETTO

8 celle congelate x 4 finestre (**ORSO 2022 · CROLLO 2020 · TORO 2021 ·
LATERALE 2019**) su storico importato `GBPUSD_EXT`/`EURUSD_EXT` (2,55 milioni
di barre M1, differenza dal feed BCM 0,004-0,005%, copertura 99,6%).
32 CSV su 32, righe gemelle del magic identiche in tutti.

| cella | verdetto | criterio |
|---|---|---|
| **PTE_GBPUSD** | **PROMOSSO DI RANGO** | C (PF 1,62 orso · 1,07 crollo) + A (DD OOS 3,27% -> soglia 6,54%; fatti 1,99% e 1,41%) + D |
| **EASY TREND** | **FUORI, definitivo** | E negato: fallisce B (crollo PF 0,39, −4.507) |
| **SW_GBPUSD** | sopravvive, **osservazione speciale** | A+B passati; ma nel TORO fa −3.187 PF 0,56 dove fuori campione faceva +3.560 PF 1,84 |
| **BB_GBPUSD** | resta dov'e' | B (0,93 e 1,00) |
| **LARRY · BB_EURUSD** | nessuna decisione | D: orso e crollo si contraddicono (e crollo con n=3 / n=1) |
| **GAP x2** | **non misurabile** | 0 trade: dipende dai confini di sessione, che il feed esterno con shift costante non riproduce |

Referto: `risultati_archivio/REFERTO_ROUND50_REGIME.md` · CSV in
`risultati_prove/regime_r50/`.

**Limite da citare SEMPRE:** niente indici e niente oro (HistData non li ha),
cioe' **4 titolari su 5 fuori**. Questo round parla solo della fascia forex.

### 4. SEI DIFETTI DELLA PIPELINE TROVATI ARRIVANDOCI

R50 non era mai girato prima e ha fatto emergere, tutti corretti:
1. l'import **ammazzava MT5** con `Stop-Process -Force`: le barre custom
   restavano su disco ma la **registrazione del simbolo si perdeva** ->
   `Tester: symbol GBPUSD_EXT not exist`. Era **la causa dei 32 lanci a
   vuoto**. Ora `Chiudi-MT5-Pulito` in 3 script.
2. il file celle si scaricava **solo se mancante** -> una correzione pushata
   non arrivava mai al tester. Ora si riscarica sempre.
3. la memoria dei flag di ottimizzazione (`Profiles\Tester\<EA>.set`) non
   veniva buttata.
4. `/config` con percorso non quotato e `-Wait` invece dell'attesa sul solo
   terminale.
5. nessun ripiego se il CSV usciva con un altro nome.
6. il messaggio di fallimento **faceva una domanda** invece di indicare il
   giornale, dove MT5 scrive il motivo a parole sue.

### 5. R51 e R52 — SCRITTI (R51 poi CHIUSO il 14/08 notte: RISERVA, vedi §1 del 15/08)

- **R51, lo short di ritorno** (idea di Claudio): il retest e' simmetrico ma
  dopo il primo LIMIT la macchina a stati va in `PH_PLACED` e abbandona il
  lato opposto — il motore promosso **lavorava mezza giornata**. Aggiunto
  `InpAllowReverse` (v1.01, **default false**), tetto 2 cicli/giorno, solo da
  flat. Tesi e criteri: `prove/R51_REVERSE_TESI.md`, prova pronta
  `prove/R51_reverse_DAX.txt`. **Il verdetto lo da' il drawdown, non il PF.**
- **R52, il lato scartato**: sulle 8 celle di R50 **nessuna e' long-only**
  (7 bidirezionali, LARRY short-only), quindi li' la domanda non morde. Morde
  sulle celle **indici**, tarate su 21 mesi di mercato in salita. Tesi
  congelata: `prove/R52_LATI_TESI.md`. **Regola madre: i dati `_EXT`
  PROPONGONO, non validano.**

### 6. CORREZIONI DICHIARATE AI CRITERI (fatte a numeri non visti)

In coda a `prove/PROVA_REGIME_CRITERI.md`:
- **n.1** la soglia del cancello zero era in "points" (unita' sbagliata) ->
  **0,05% del prezzo**;
- **n.2** il criterio B parlava di celle "quasi tutte long-only" che **in R50
  non esistono** -> la clemenza non si applica, il giudizio diventa **piu'
  severo**.

### 7. ERRORI MIEI DELLA GIORNATA, per non ripeterli

Tutti della stessa famiglia: **dedurre invece di leggere**.
- ho letto il livello sbagliato di `bases\Custom` e detto che i simboli non
  c'erano (c'erano, 148 MB ciascuno);
- ho letto `Tester\logs` invece del **giornale del terminale**, dove la
  risposta era scritta in chiaro dalle 16:50;
- ho dato la colpa a `Optimization=2`, poi ho definito "innocente" il blocco
  `[Experts]` con un ragionamento circolare;
- ho "corretto" `InpTF` di SuperWave da 16386 a 16388 peggiorandolo, e poi ho
  **dichiarato annullata** una misura che era giusta, senza avere in mano
  l'ini con cui era stata prodotta (**ritrattato**).

Regola operativa che ne esce: **prima si legge il log, poi si formula
l'ipotesi.** E quando MT5 non parte, il file da aprire e'
`<CartellaDati>\logs\AAAAMMGG.log`.

### 8. STATO CONTI (14/08 sera)

- **100k (50504263)**: saldo **99.173,14** (−0,83% dal via), 6 trade 3/3.
  Pavimento FTMO 90.000 -> **9.173 di margine**. La perdita del DAX di oggi
  e' **1R esatto**, cioe' la taratura prevista.
- **piccolo (50503392)**: contaminato fino a oggi dall'istanza fantasma del
  PC. Da qui in avanti i numeri del DAX tornano leggibili.
  **-> MISURATO il 15/08**: 33 trade del PC per -511,28; dal 22/07 la flotta
  vera e' a **+93,14**, non in perdita. Saldo 5.150,99. Vedi §0 del 15/08.
- **Vivaio**: 23 in prova + 5 in osservazione. Verdetti a **15 trade per
  famiglia**. Pagella serale: si guarda **il win rate**, non il P/L.

---

## 🟢🟢 AGGIORNAMENTO 14/08 MATTINA (la notte piu' lunga: R42->R48)

- **FASCIA C ESAURITA in una serata**: R42 fade BOCCIATO 48/48 · R43
  rimbalzo ORL/ORH bocciato su tutti e 4 i lati (**26° ribaltamento**) ·
  R44 target 2x/3x: scia VERA sul Dow (PF 1,955 a 3,0x) ma **cambio
  bocciato dal cancello DD** · R45 ORB di Londra bocciato 48/48 ->
  **famiglia ORB chiusa su ogni sessione misurata**. Zero codice scritto,
  3 capitoli sigillati, backlog ORB esaurito.
- **QUINTO EA NATO: ABTG_EasyTrend v1.00** (1.605 righe, magic base
  772401, zero repaint) dalle 7 trascrizioni del corso ->
  `prove/EASY_TREND_TESI.md`. CAL (detector src0/PivotR 3, scelto SOLO
  sulla frequenza) -> scan 48 (campo rosso 24/48, testa viva) -> **tick
  reali 4/4 con tenute 85-104%: lo spread NON uccide** -> **R48
  walk-forward IN CORSO** (EURGBP short / GBPUSD, AUDJPY, CHFJPY long).
  QUINTA famiglia mono-lato di fila. **R48 tre promossi** (GBPUSD, AUDJPY,
  CHFJPY, +2.667 OOS) ma **R49 BOCCIA la famiglia in portafoglio** (alza
  tutte le code: p99 12,47 -> 14,63) e **nessun sottoinsieme viene
  ripescato** (senza tesi strutturale sarebbe pesca a posteriori) ->
  **sedie 30-32 in OSSERVAZIONE sul 50503392** (magic 772421-23, verifica
  **26/26**), porta del 100k CHIUSA. Vivaio: 23 in prova + 5 osservati.
- **DOSSIER USCITE (3 ricorrenze del "vincente chiuso stretto") APERTO e
  gia' con un verdetto**: R46 ha ASSOLTO il trailing PREVBAR (e' la
  migliore gestione su entrambi gli indici) e ha indicato il **parziale
  50% a 1R** come causa vera della vincita media bassa. Toglierlo dava
  DAX +30,9% ma **cancelli falliti sul Dow -> NESSUN CAMBIO LIVE**.
  **27° ribaltamento** (TP 3R secco: migliore IS, peggiore OOS, 63k di
  differenza). Fase 2 pronta: `prove/R47a-d_pertrade_*.txt` (magic
  vergini 772501-04) per win rate e payoff esatti.
- **DUE DOMANDE DI CLAUDIO CHE VALGONO PIU' DI UN ROUND** (entrambe
  registrate in `report/ASPETTATIVE_REALISTICHE.md`, da leggere PRIMA di
  citare qualunque cifra): (1) il portafoglio simulato **non e' uno
  stipendio** — scenario centrale onesto 2.500-3.500 EUR/mese netti su
  una prop, primo payout realistico nov-dic 2026; (2) **la finestra e'
  corta** (21 mesi, un solo regime, nessun orso) -> strada dichiarata
  per allungarla sul forex (demo altro broker > import Dukascopy, come
  sola PROVA DI REGIME, mai per tarare).
- **Pagella 13/08**: piccolo −15,15 · 100k −139,98 (saldo 99.820,96).
  Lo stop dell'ORB ha EVITATO una perdita 6 volte piu' grande. Payoff dal
  via: 3 vinti su 5 ma vincita media 82 contro perdita media 212 ->
  servirebbe il 72% di win rate.
- **Attrezzi corretti**: `valida_realtick.ps1` ora raccoglie e zippa da
  solo sul Desktop, e **il bug `-Symbols` con `powershell -File`** (la
  lista arrivava come UN simbolo, zero CSV senza errore) e' stato
  normalizzato in **6 script**. Nuovo: `riordina_desktop.ps1` (anteprima,
  log, comando -Annulla) — Desktop del PC di backtest riordinato il 14/08.

---

## 🟢 RIPARTI DA QUI — stato al 13/08 sera (le sezioni sotto questa sono STORICHE)
**Per il quadro vivo leggere, in ordine:** `report/DIARIO.md` (righe 11-13/08),
`report/ASPETTATIVE_REALISTICHE.md` (**leggere PRIMA di citare qualunque
cifra**: il portafoglio simulato e' un metro di laboratorio, non uno
stipendio), `report/CAMPAGNA_ARSENALE.md` (29 sedie), `report/SCHEDA_SECONDA_PROP.md`
(dossier D3), `backtest_pipeline/prove/BREAKING_BAND_TESI.md` e
`prove/GAP_FILL_TESI.md`.

- **Vivaio a 23 sul conto piccolo 50503392** (verificato **23/23** dai .chr,
  13/08 sera): MAXMIN ORO 770402 · PTE Dow/GBP/JPY 771321-23 · SW Dow/GBP
  770531-32 · EMA200 Dow 771531 · **Breaking Band GBPUSD/EURUSD/AUDUSD
  772161-63 (sedie 13-15: pattern 2/0/1, taratura CAL1 1,35/1,0, TPMode
  0)** · **Gap-fill GBPUSD/EURUSD/AUDUSD 772231-33 (sedie 16-18: fill
  100/50/100, spread 300 acceso, time-stop 48h — R35...R37 in un giorno)**
  · **Gap-fill Dow/Nikkei 772234-35 (sedie 19-20 in OSSERVAZIONE: fill
  100/75, collaudo pieno ma porta 100k CHIUSA — R37: cumulo lunedi',
  bocciati anche a mezzo peso; 4 IS-rossi in riserva regime, E35EUR
  senza tick)** · **Punte di Larry 772341-46 (sedie 21-26: Smash
  punta/libro, exit R/FPO, lati per referto R38 — Dow e EURAUD L+S,
  oro/GBPJPY/EURCAD solo L, GBPUSD solo S; spread 300, time-stop 5gg;
  verdetto famiglia atteso in 6-8 settimane)** · **Cost-to-cost
  EURJPY/GBPCAD/XAGUSD 772361-63 (sedie 27-29, primi grafici H4 del
  vivaio: exit FLIP/R/COST puro, tutti SOLO LONG, spread 300,
  MaxBarsHold 100 — R40→R41, quarto "aggiunge e abbassa"; ⚠️ famiglia
  con avvertenza: campo scan 28/48 rosso, il forward qui pesa piu' che
  altrove; verdetto dei 15 in ~3 mesi). Portafoglio simulato 27 serie:
  +223.230, DD 5,50%, p99 12,47 (a 0,65% = 8,1%)**. **Regola vivaio aggiornata 13/08 (Claudio):
  collaudo 10 trade/mercato, VERDETTO a 15 trade/famiglia (era 30)** →
  se in linea, promozione al 100k demo a mezzo peso; regola 30/07 sulla
  prop pagata INTOCCATA (BB = famiglia unica sui 3 mercati). Squadra
  100k sul -V3 invariata (+ pagella doppia automatica ogni sera 23:15
  sul Desktop VPS).
- **Breaking Band: dall'aula al vivaio in ~36 ore** — tesi → EA v1.02 →
  CAL1 → tick 7/7 → R33 walk-forward (3 promossi) → R34 portafoglio
  **12→15 serie, +133.654, DD 8,74%, code MC tutte giù** (seconda volta
  nella storia). Salto diretto al 100k RIFIUTATO: trafila invariata.
- **Nasdaq base ALLINEATO 12/08** (volumi ON + AND, rischio 0,25, verificato
  5/5): primo collaudo dal vivo nelle pagelle.
- **Pulizia chiusa 4/4** (ultimo: SupRev_DOW_H1 da flat). Flotta 20 grafici,
  tutti referto-giustificati.
- **v21 dell'amico**: intercettato sul vivo, spento pre-apertura, misurato nel
  tester (bocciato: fuso+unita' punti), referto `REFERTO_V21_ESTERNO.md`.
- **Referti nuovi**: R30 (S/R bocciato 20° ribaltamento, VolRegime in
  cassetta), R31 (portafoglio 12 serie +126.255), R32 (oro 0/30, Nikkei 21°
  ribaltamento a regione intera: EMA200 = specialista del Dow).
- **D3 (seconda prop) AVVIATA**: FundedNext SCARTATA (3% cumulativo),
  The5ers candidata CON RISERVE (3 chiarimenti scritti dovuti), FTMO da
  istruire con scheda dedicata. Due prop da ads Instagram investigate e
  DA EVITARE (`report/INDAGINE_PROP_INSTAGRAM.md`).
- **Nuovo fronte strategie del corso**: tesi Breaking Band distillata
  (motore = squeeze Bollinger; servono da Claudio: slide, indicatore StdDev
  di Paolo, regole di Leonardo). CATALOGO completo delle strategie del corso
  in lavorazione (agente). Sweep range apertura 15-60' ESEGUITO come R35
  (13/08): nessun cambio, cella live DAX = migliore OOS, Initial Balance
  archiviata (`REFERTO_ROUND35_RANGE_APERTURA.md`).
- **Stile chat**: titoli grandi + emoji + hype (regola in CLAUDE.md).

---

## 🛡️ VERIFICATO 04/08 08:15 — 4 posizioni aperte (da ReportTrade50503392.xlsx)
- 🟢 **CAC F40EUR ×2** (#2943866/69, STREV CAC H4): SL 8499 SOPRA ingresso 8478 → **protetti in profitto**, non possono perdere.
- ⚠️ **ORO XAUUSD ×2** (#2957063 STREV MULTI, #2958388 STREV): SL 4111,19 = 36pt SOPRA ingresso ~4075 = **NON protetti**. Ora +10€ l'uno; se oro risale a 4111 → **−31€ l'uno**. Consigliato a Claudio: SL a BE ~4075 (o incassare). Causa: SupRev muove BE solo a +1R, questi a ~0,3R → EA non scattato.
- 💡 INSIGHT per studio uscite: un trade in profitto da giorni ma <1R resta senza BE per giorni → valutare **BE a tempo** (se in profitto da N ore/giorni → SL a pari) sugli EA swing.

- 🔬 **Oro lasciato correre (deciso 04/08):** i 2 oro NON protetti restano APERTI apposta (gruppo di controllo) → osservare se profitto→perdita. Caso tracciato in `report/CASO_ORO_osservazione_04-08.md`. Aggiornare l'ESITO al report 23:00.

## ⏰ PENDING — alla PROSSIMA risposta a Claudio (accordo 04/08)
Il report di giornata (`report/giornata_2026-08-04.md`) viene generato dal trigger delle **23:00** anche se Claudio non è al PC. **Appena Claudio riscrive (anche la mattina dopo), la PRIMA cosa da fare** è: presentargli **com'è andata oggi + le mie considerazioni per ridurre le perdite**, e **proporre di analizzare i dati insieme**. Non aspettare che lo chieda lui. (Branch unico = `lavoro`.)

## 🔴 STATO OGGI (02/08) — riparti da qui
- **ROTTA (vedi `PIANO_PROP.md`):** PROP = priorità n°1. EA prop ideali: **H1**, trade chiusi in **1-2 gg** (max 4), gestione **parziale+BE+trailing**, **DD basso**. Conto personale: **aperture M5**.
- **🔬 ROTTA NUOVA (Claudio, 03/08): studiare il MOVIMENTO, non solo l'ingresso.** → `STUDIO_MOVIMENTO_APERTURE.md`
  Il forward del 03/08 ha mostrato che l'ingresso giusto con la gestione sbagliata vale **+33 € invece di +241 €** (trailing a 4,1 punti indice, chiusi in 39 secondi). Due fasi: **A** misurare MAE/MFE/durata (`studio_apertura.ps1`, branch corretto), **B** spazzolare le distanze di BE/trailing/TP (`scan_gestione.ps1 -Fase distanze`, nuovo).
- **⏭️ TOCCA A TE (PC di backtest, MT5 CHIUSO — vedi `CACCIA_MOTORE_APERTURE.md`):**
  ```powershell
  # ENTRATA RITARDATA + FIRST-CANDLE (motori #4 e #6) — l'ultima idea vera sulle aperture
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/confronto_ritardata.ps1" | iex
  ```
  Poi zippa dal Desktop `risultati_APERT_DAX_M5_delay_realtick` e `risultati_APERT_US_M5_delay_realtick` e caricamele.
- **FATTO oggi (tutto pushato):**
  1. **Motore RETEST** (opt-in `InpEntryMode=RETEST`) → testato a tick reali e **BOCCIATO**: peggiora il Dow (1,30→0,94), Nasdaq 0,73 (DD 27%), DAX 0,79. Selezione avversa sui falsi break. → **famiglia breakout (stop+limit) ELIMINATA** per DAX/Nasdaq apertura; sopravvive solo **Dow STOP 1,30**.
  2. **Motore RANGE-FADE** (`InpEntryMode=RANGE_FADE`) → testato a tick reali sul DAX e **BOCCIATO, il peggiore dei tre**: PFmed 0,73, **0 combo su 136 sopra PF 1** (max 0,94), DD mediano **23,5%** (quasi doppio di stop/retest). L'ipotesi "il DAX è whipsaw, quindi fada" è smentita dai numeri. Dettaglio: `risultati_archivio/DAX_Apertura/ANALISI_MOTORI_DAX_M5.md`.
  3. **Motore ENTRATA RITARDATA/CONFERMATA** (`InpEntryMode=DELAYED`, `InpDelayMinutes`, `InpDelayDirMode`) su Nasdaq/DAX apertura: aspetta N minuti e poi entra **a mercato** dalla parte scelta → niente stop da inseguire, niente slippage di rottura. Il modo `InpDelayDirMode=2` copre anche il **first-candle follow**. **Da testare** (griglia 15/30/45 min × break/mid/candela).
  4. **FIX gestione PER-TICKET** su TUTTE le aperture (Nasdaq/DAX/Marco): parziale+BE su OGNI posizione (risolve il +800→−700 del 29/07). **Da ricompilare sul VPS per attivarlo in forward.**
  5. **`REPORT_SETTIMANALE_2026-08-01.md`** + **`PAGELLA_EA_2026-08-01.md`**: statement 24-31/07 net −187€ (buco = DAX intraday, causa bug gestione ora corretto). Pagella per-EA dai COMMENTI ordini.
  6. **`FLOTTA_ATTIVA.md`**: mappa 52 grafici VPS. Scoperte: **TradeExporter attivo** su NZDCADH1 (scrive `ABTG_Trades.csv` con magic → caricarlo per pagelle perfette); **D30EURM54 vuoto** (verificare).
- **IPOTESI motore-per-mercato:** Nasdaq direzionale vs DAX whipsaw. Il RETEST doveva servire a entrambi e ha fallito su entrambi → ora si prova a **non inseguire affatto la rottura** (fade / entrata ritardata). Registro completo in `CACCIA_MOTORE_APERTURE.md`.
- **Dato nuovo:** Dow STOP tick reali col fix gestione = **PF 1,30** (era 1,16).
- **Prossimo passo PROP:** validare **GoldenCross H1 tick reali** (TF preferito di Claudio).

---

## 📐 FASE A FATTA (03/08) — `risultati_archivio/STUDIO_MOVIMENTO_RISULTATI.md`
8 indici, ~3 500 trade, breakout cieco con stop 1R / TP 2R. **Risultato scomodo: sette indici su otto danno aspettativa ZERO o negativa.**
- Aspettativa R/trade: **Dow +0,074** ✅ · DAX +0,026 · Nasdaq +0,001 · SPX −0,017 · IBEX/EuroStoxx −0,048 · CAC −0,056 · FTSE −0,138.
- ⚠️ **Corregge la mia conclusione del 03/08** (*"entriamo bene, usciamo male"*): su 5 trade era plausibile, su 3 500 no. Sistemare l'uscita porta da negativo a **zero**, non a buono. Il margine sta nella **selezione** (coerente con l'ablazione: solo i volumi spostano).
- **Nessun TP salva niente**: il migliore per simbolo resta ~0 e salta a caso → non esiste "la distanza giusta".
- 💡 **DAX: il 48% dei perdenti era prima a +0,5R, il 23% a +1R.** La domanda *"ero a più e si è girato"* ha risposta strutturale. Argomento forte per il BE — costo da misurare in FASE B.
- ⏱️ **Vincente mediano DAX = 135 min, Nasdaq = 80 min. Il nostro EA chiude in 39 secondi.**
- ✅ **Stop a 1R confermato, non stringerlo**: un vincente su 10 va contro di 0,80R prima di girarsi.
- 🌍 Filtro trend H4: **aiuta sui 3 indici USA, danneggia sui 4 europei** (netto e ordinato).
- 🎯 **Il Dow è il mercato migliore e lo stiamo trascurando** — terzo riscontro indipendente (tick reali PF 1,30). Ipotesi derivata: **Dow + H4 + TP 1,5R + stop invariato + niente trailing nei primi 45 min**.

## 🧭 ROTTA DECISA DA CLAUDIO (05/08, notte) — tre binari, in quest'ordine

**1. ~~FINIRE IL DOW~~ → PARAMETRI CHIUSI (05/08).** `trailing2` ha risolto il dubbio: la curva del PF è una gobba (M1 1,200 … **M5-M6 1,371** … M20 1,251), l'ottimo non stava oltre il bordo. Si tiene **M5** (M6 fa 298 € in più ma con DD 5,88% contro 5,32% e recovery 5,14 contro 6,51).
   **Configurazione definitiva: U30USD M5 · range 15 min · EMA50 su H4 · volumi OFF · stop sul range (floor 500) · TP 1,5R · niente parziale né BE · trailing a BASE CANDELA M5.**
   **PF 1,371 · DD 5,32% · 329 trade.** Dal breakout cieco (1,03 / 14,9%): PF +33%, drawdown a un terzo. 106 pass a tick reali.
   ✅ **WALK-FORWARD SUPERATO (05/08).** 80 pass su due finestre. In OOS (12 mesi mai usati per scegliere): **40 combinazioni su 40 profittevoli**, minimo PF **1,267**, DD massimo 8,70%. L'edge non è un artefatto del periodo. **Primo sistema della flotta a passare questo cancello.**
   ⚠️ Ma il **picco si sposta**: ottimo IS = EMA 40 (1,546 → 1,340 in OOS); ottimo OOS = EMA 80 (1,560 → 1,241 in IS). E il TP a 2,5R è il **peggiore** in IS e fra i **migliori** in OOS. → si tiene un valore CENTRALE, non il massimo. La scelta dell'EMA 50 invece del 40 era giusta.
   🟡 Segnale giallo da non nascondere: l'OOS è andato **meglio** dell'IS (mediana 1,374 vs 1,277) e ha prodotto 186-198 trade in 12 mesi contro 138-154 in 18 → periodo più mosso e favorevole, non sistema migliore. Una finestra OOS resta un campione solo.
   ⏭️ Da qui il giudice non è più il backtest: **forward** (in corso dal 05/08) e poi **dry-run col Guardian sul demo 100k**.

**2. MIGLIORARE ANCORA DAX E NASDAQ.** ⚠️ Correggo una mia frase di ieri (*"quella miniera è esaurita"*): era vera **per i filtri d'ingresso**, non per la gestione. Ci sono tre cose mai provate lì, e non sono scavare dove si è già scavato:
   - 🔑 **Il trailing a BASE CANDELA su DAX e Nasdaq.** È la scoperta del 05/08 sul Dow (PF 1,238 → 1,371, DD −23%), e — punto importante — **l'indizio originale veniva proprio dal DAX** (04/08: 25,64 punti contro 1,90). Mai misurato a backtest su quei due simboli. **Questo è il test numero uno.**
   - **Il filtro volumi sul DAX.** È l'unico filtro che funziona sul Nasdaq (0,90 → 1,15) e sul DAX **non è mai stato provato**.
   - **`InpTP1_R = 0.5`** (TP totale 1,5R invece di 3R) su DAX e Nasdaq: la prova diretta è del 04/08 sul Nasdaq (2R colpito, 3R mai avvicinato nello stesso minuto).
   - Già scritti e mai lanciati: motore **DELAYED**, **ORB con `InpUseCloseConfirm`** (la regola d'ingresso che Emiliano descrive nella live).

**3. PROP SU H1** — priorità n°1 dichiarata in `PIANO_PROP.md`, ferma da lunedì.
   - **GoldenCross H1 a tick reali** su **XAUUSD · EURCAD · GBPUSD · USDJPY** (mai fatto).
   - Perché quei quattro: nello scan OHLC a 48 simboli l'oro è **primo** (PFmed 1,29). Il DAX è ottavo a **0,92**, sotto 1 → escluso.
   - ⚠️ Da dire prima di spendere ore: campioni ~61 trade (soglia 150), il "2,01" del piano è il **massimo** non la mediana, ed è OHLC — che sovrastima (CAC 7,37 → 0,96).

_I binari 2 e 3 si possono alternare: usano script diversi e non si pestano._

## 🎯 DOW APERTURA — miglior risultato finora (03/08) — `risultati_archivio/Dow_Apertura/DOW_MOTORE.md`
Tick reali, U30USD M5, gestione NUDA (solo stop+TP), 12 pass.
- **Filtro trend H4 ACCESO: PF 1,03 → 1,24 · DD 14,9% → 6,9% · 329 trade.** Migliora tutte e tre le colonne, campione ampio. Conferma sui P&L veri la previsione della FASE A (+0,052 R/trade).
- ❌ **Il filtro volumi NON si trasferisce dal Nasdaq**: da solo 1,01/0,99/1,05 (rumore), e sopra l'H4 fa danno in modo monotòno (1,24 → 0,96).
- 📌 **Regola nuova: non esiste "il filtro giusto", esiste quello giusto per QUEL mercato.** Volumi = Nasdaq. Trend H4 = Dow (e dannoso sugli europei).
- Miglior sistema di aperture che abbiamo: Dow+H4 (1,24 / 6,9% / 329) batte Nasdaq+volumi (1,15 / 9,6% / 152) su tutti e tre i criteri.
- ✅ **ROBUSTEZZA SUPERATA**: EMA del filtro da 20 a 200 → **10/10 sopra PF 1,20** (min 1,202, max 1,299). Nessuna punta, è un altopiano. Sottostruttura: EMA **corta (20-80) DD 7,4%** vs lunga (100-200) DD 11,4% → **restare sotto 100**; si tiene 50.
- ⚠️ Resta non dimostrato: **nessun out-of-sample**, e la gestione è ancora nuda.
- 📏 **FASE DISTANZE FATTA (04/08): la gestione DISTRUGGE valore sul Dow.** Nuda (stop 1R, TP 1,5R, niente parziale/BE/trailing) = **profit 3 917 · PF 1,24 · DD 6,9%**; la migliore gestita = 2 575 (−34%), a parità di TP = 1 701 (−57%). E con DD più alto.
- ❌ **Il BE anticipato costa**: 6 confronti puliti su 8 in perdita, fino a **−38%**. Smentisce l'ipotesi che avevo tratto dalla fase A ("48% dei perdenti era prima a +0,5R"): quelli che ritracciano sono gli stessi che poi corrono.
- 🟡 Trailing: largo (0,72–0,96 R) batte stretto (0,24 R), ma **niente batte tutti**. ⚠️ `InpTrailMode` era pinnato a 2 (punti fissi): **il trailing a base candela — quello che in forward ha fatto 13× — non è mai stato testato.**
- **⏭️ TOCCA A TE:** testare `InpTrailMode=1` a parità di tutto il resto.

## ✅ ABLAZIONE NASDAQ CHIUSA (03/08) — tutti e 7 i gradini
**Su sei filtri candidati ne funziona uno solo: i volumi di pre-apertura.**
Nudo 0,90 → **volumi 1,15** → ATR 0,93 → volumi OR ATR **0,99** → +EMA H4 0,81 → +correlazione 0,80 → news non misurato.
- 🔴 **Azione:** l'`InpConfirmMode=OR` che avevo messo il 02/08 **annulla l'unico filtro buono** (a soglia 1,8: PF 1,38 → 0,99, riammette 269 trade sbagliati). Rimetterlo ad **AND** / spegnere l'ATR nei preset forward Nasdaq.
- Punto d'esercizio onesto: **VolMult 1,5 → PF 1,15, DD 9,6%, 152 trade.** A 1,8 il PF è 1,38 ma restano 80 trade (sotto soglia campione).
- **Non c'è altro da cercare nei filtri d'ingresso** → conferma dai numeri la rotta "studiare il movimento/l'uscita".
- Dettaglio + CSV grezzi: `risultati_archivio/Nasdaq_Apertura/ABLAZIONE_NASDAQ.md` e `csv_ablazione/`.

## 🔁 ROUTINE ATTIVA — pagella giornaliera (dal 03/08)
`trig_015ZH6kR1HcmgT6jUTgpMSK2` · **21:00 UTC = 23:00 italiane, lun-ven** (mercati chiusi, dopo l'ultimo export).
**Agganciata alla chat di lavoro** (richiesta di Claudio 03/08: *"deve arrivare nella chat in cui parliamo"*). La prima versione apriva una sessione nuova e il report finiva altrove: sostituita.
⚠️ Quando si apre una chat nuova, la routine va **ricreata** puntandola a quella (un trigger agganciato vive con la sua sessione).
Ogni sera, qui in chat: scarica `lavoro` → lancia `backtest_pipeline/analizza_trades.py` su `data/statements/trades_auto.csv` → scrive `report/giornata_AAAA-MM-GG.md` con in fondo una **"🧠 Lettura"** ragionata → aggiunge una riga a `report/DIARIO.md` (la memoria che si accumula e segnala i problemi che si RIPETONO) → committa e pusha.

**Perché serve:** il 03/08 cinque operazioni hanno insegnato più di una settimana di backtest, ma le ho ricostruite a mano da cinque screenshot. Ora si fa da sola.

⚠️ **Precondizione sul VPS, altrimenti la pagella è cieca:**
1. ricompilare `ABTG_TradeExporter.mq5` (colonne nuove: `magic`, `close_reason`, `session_high`, `session_low`);
2. mettere `pubblica_trades.ps1` nel Task Scheduler, la sera.
Senza `close_reason` non si distingue lo stop iniziale dal trailing — cioè il nodo del 03/08. Senza `session_high/low` non si calcola la frazione di movimento catturata (il 14% del DAX).

## ⚠️ NOTA BRANCH (importante)
Il lavoro delle chat vecchie viveva su branch diversi (`ea-market-openings-d79m8l`, `creating-agents-SgGpD`). **Il 31/07 è stato consolidato tutto in `lavoro`**: preset forward, Guardian, walkforward, studio aperture, promemoria + tutti gli scan archiviati. Questo è ora **l'unico branch da usare**. Salvare SEMPRE qui (commit + push).

## Chi sono / contesto
- Trader retail, conto **DEMO BCM 50503392** (EUR, Hedge, ~6k). Backtest sul PC fisso; EA in **forward su demo** (VPS/PC).
- **Doppio obiettivo**: (1) EA **PROP-GRADE** (DD basso, robusti → challenge FTMO); (2) EA **conto personale** (basta siano profittevoli).
- ⏰ **Fuso BCM = ora italiana − 1**. Orari EA/.ini in ORA SERVER (DAX 08:00, Nasdaq 14:30).

## Metodo (imbuto, una strategia alla volta)
**scan OHLC su più TF → classifico i migliori → tick reali sui vincitori → forward → walk-forward → dry-run prop.**
Regola d'oro: conta il **PF a TICK REALI** (l'OHLC sovrastima, vedi CAC 7.37→0.96) e il **DD basso**.

---

## 📊 DOVE SONO LE CLASSIFICHE
- **`backtest_pipeline/risultati_archivio/CLASSIFICHE.md`** ← vista unica (EA + simboli + strategie). **Parti da qui.**
- `backtest_pipeline/risultati_archivio/CLASSIFICA_STRATEGIE.md` — matrice motori × TF.
- `backtest_pipeline/CLASSIFICA_PF.md` — i 14 EA `_Ottimizzato` per PF.
- Per strategia: `risultati_archivio/<Strategia>/ANALISI_*.md` (GoldenCross, SupertrendReversal + TICK_REALI_INDICI).

## 🟢 SQUADRA FORWARD (13 EA validati, in demo; EMA200 dal 01/08)
5 SupRev: **Oro** (770921) · **Argento** (770922) · **DAX** (770923) · **Nikkei** (770924) H4 + **Nasdaq H1** (770925).
3 GoldenCross H4: **USDCHF** (770331) · **USDCAD** (770332) · **NZDUSD** (770333).
5 EMA200 H4: **200AUD** (771511) · **AUDJPY** (771512) · **GBPJPY** (771513) · **SPXUSD** (771514) · **GBPUSD**/SHORT (771515).
_NB: sul demo gira TUTTA la flotta (~50 EA, anche i "morti") per osservazione fino alla quadra del mese — decisione Claudio._
→ Serve TEMPO: pagella PF/DD reale tra ~2-3 mesi. Claudio manda statement → Claude archivia/traccia.
**Scartati** (crollo tick reali): SupRev Dow, ASX, CAC.

## 🎯 PROP — piano
- Prop scelta: **FTMO 2-Step** (−5% giorno / −10% totale statico, target +10%, no time limit, EA ok). Alt: The5ers.
- **Guardiano pronto**: `ABTG_Guardian.mq5` + `ABTG_Guardian_FTMO_2Step.set` (InpStartBalance=100000). Solo sul demo dry-run, MAI sul forward.
- Sequenza: forward → walk-forward IS/OOS (`walkforward.ps1`) → aprire demo 100k → dry-run col guardiano → valutare. **Deciso 30/07: aspettare il forward, niente pagamenti ora.**
- ⚠️ PostNews FOMC/BCE = news trading → a rischio regole prop.

## ⏳ DA FARE (priorità)
0. ✅ **RISOLTO senza toccare codice (09/08 sera)** — Commenti ordini: il censimento
   cercava solo `InpComment`, ma la famiglia Apertura passa il commento via
   `#define ABTG_DEF_NAME` su OGNI ordine ("Dow Apertura US BUY", "DAX Apertura EU
   BUY", ecc.). TUTTA la squadra del 100k ha commenti riconoscibili. Nessuna
   modifica necessaria.
0-bis. 🟢 **IN CORSO: deploy demo 100k col Guardiano** — scaletta completa in
   `report/DEPLOY_GUARDIANO_100K.md` (nuovo conto BCM 100k EUR hedging, seconda
   istanza MT5 sul VPS, Guardian FTMO preset per primo, 5 EA a rischio 0,65% con
   ORB a 0,3%, legge dello screenshot a ogni fase).
0-ter. 🔵 **PAGELLA DOPPIA (prossimo lavoro mio)**: estendere `analizza_trades.py`
   a leggere anche `ABTG_Trades_100k.csv` (conto 50504263, dry-run Guardiano) —
   sezione FTMO con distanza dai pavimenti 95k/90k giorno per giorno. L'exporter
   sul -V3 e' gia' attivo (EURUSD H1, export ogni 30').
1. 🔄 **EMA200**: scan OHLC H4 (in corso) + H1 → poi tick reali sui vincitori.
2. ⏳ **Tick reali mancanti**: SupRev IBEX (E35EUR) H1; GoldenCross H1 sui top OHLC (Oro/USDJPY/GBPUSD); SupRev non-indici H4 (XAU/CHFJPY/GBPJPY/AUDUSD).
3. ✅ **CODA FASCIA B ESEGUITA (notte 10-11/08, 48/48 lavori)** — referto completo in `risultati_archivio/REFERTO_CODA_FASCIA_B.md`. Capitoli CHIUSI: Nightly 0/8 (il posto non se l'è guadagnato), FiboH4_Multi 0/8, SupertrendInvert (non opera: 0-2 trade), WOL (profitti da spread). **Sorpresa: PTE** — bocciata a casa sua (oro), passa i criteri congelati su **Dow H1 (altopiano BE 0-1, 43 trade OOS, PF 1,32), GBPUSD H1 (51 trade, PF 1,45), USDJPY (12 celle su 16)** + DAX H1 con riserve. SuperWave: Dow H2 (61 trade, PF 1,73) e GBPUSD H2 (63 trade, PF 2,09). ⚠️ Righe H3 PTE = pattern regime (IS rosso/OOS verde), non contarle. **Prossimo: R23 per-trade dei 5 candidati** (magic vergini) → dd_portafoglio → eventuale vivaio, decisione di Claudio.
4. ❓ **SupertrendInvert tick reali** — da ritrovare sul PC (non in archivio).
5. 🟢 **VPS — PULIZIA IN CORSO (via libera di Claudio 10/08 sera)**: checklist completa in `report/PULIZIA_VPS_10-08.md` — 15 voci Tier 1 (bocciati con referto: ORB corso, ORB_Fibo, Nightly, MaxMin EURUSD, GoldenCross ×5, PTE, WOL, SupertrendInvert, PostNews ×2, SupRev CAC, doppioni STREV, EMA200 base ×6, HARSI), Tier 2 da verificare, whitelist squadra+vivaio. Prima di staccare: chiudere le posizioni aperte dei morti (incluso il gruppo di controllo oro del 04/08 → annotare esito). La ricompilazione coi log del filtro (5-bis) resta per un momento calmo, NON stasera.
6. ✅ **ALTA VELOCITA' — CAPITOLO CHIUSO IN GIORNATA (11/08, referto:
   `REFERTO_ALTA_VELOCITA_V1.md`)**: manuale → tesi → formula originale del
   ciclo (3 fonti) → EA 1.045 righe (compilato al 1° colpo) → collaudo →
   v1.1 (regola stop del manuale) → **BOCCIATO su GBPUSD coi criteri
   congelati** (v1 tick 8/8 rosse; v1.1 OOS 4/4 rosse). La macchina
   funziona, l'edge della traduzione meccanica no: il cuore non tradotto
   (trendline sulle punte RSI) e' probabilmente IL cuore. Niente coda a
   8 simboli (sarebbe pesca); `CODA_ALTAV.csv` resta pronta SOLO per
   un'eventuale v2 con tesi nuova. Zero forward speso.
5-bis. 🟡 **Log del filtro nel MaxMinNotte_DAX_Short** (deciso 10/08, alla prossima
   ricompilazione — MAI a forward caldo): quando il filtro di correlazione S&P
   nega il piazzamento, oggi l'EA salta IN SILENZIO (verificato nel codice:
   nessuna Log() sul ramo bias). Aggiungere una riga tipo
   "filtro S&P contrario: niente short oggi" nel punto in cui CorrBias() blocca.
   Motivo: i rami silenziosi sono ambigui — il 10/08 il silenzio delle 08:59 sul
   100k ha richiesto un'ispezione del sorgente per capire che era tutto regolare.
   Stessa occasione: valutare la stessa riga anche nel MaxMinNotte generico.
   📌 CASO 11/08 (secondo silenzio in due giorni): DAX giu' di ~100 punti in
   mattinata, nessun ingresso short sul 100k. DAX Apertura = corretto (la
   cella validata e' SOLO LONG; il piccolo con lo short vecchio il 10/08 ha
   pagato -101,83). MaxMin DAX Short = DA VERIFICARE nel journal del -V3
   (07:00-09:30 server): pendente piazzato e mai preso, oppure veto S&P
   muto? Se e' il veto, sono 2 giornate short-vincenti bloccate in 2 giorni:
   il log del 5-bis serve anche a MISURARE il costo del filtro.

## Stile richiesto
Precisione sopra tutto. Etichettare [VERIFICATO]/[INFERITO]/[INCERTO]. Segnalare premesse sbagliate PRIMA di rispondere. Mai inventare. **Salvare SEMPRE tutto nel repo** (commit+push): ciò che non è pushato è perso.

## Comandi utili (PowerShell) — branch `lavoro`
```powershell
# Scan di un EA su tutto il market (OHLC). -Tf opzionale per forzare il timeframe.
powershell -ExecutionPolicy Bypass -Command "iwr 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/scan_market.ps1' -OutFile scan_market.ps1; .\scan_market.ps1 -Robot ABTG_EMA200 -Tf H1"
# Validazione tick reali dei vincitori
#   .\valida_realtick.ps1 -Symbols E35EUR -Tf H1
```

---

## 📌 IN SOSPESO (16/08/2026) — sbloccare le fonti per la caccia

Claudio ha chiesto di riprendere **"il discorso che tu puoi entrare a trovare
sui vari siti"**. Non e' urgente e non blocca niente, ma moltiplica la resa.

👉 **Procedura completa, misurata, con la lista dei domini da incollare:**
`backtest_pipeline/caccia_strategie/PROMEMORIA_SBLOCCO_FONTI.md`

In due righe: l'ambiente ha una allowlist e **`mql5.com`, `arxiv.org`,
`tradingview.com`, `ssrn.com`, `forexfactory.com`, `quantpedia.com` e
`quantconnect.com` rispondono 403 al CONNECT** (misurato al proxy, non
ipotizzato). Si sblocca da **claude.ai/code** → icona a nuvola sopra la
casella del messaggio → ingranaggio sull'ambiente → **Network access:
`Custom`** → domini uno per riga → ⚠️ **spuntare "Also include default list
of common package managers"**, altrimenti si perde GitHub. Poi serve una
**sessione nuova**.

---

## 🗂️ CODA DELLA PROSSIMA SESSIONE (16/08/2026)

Tutto quello che era in sospeso quando Claudio ha lasciato il PC sta in
**`CODA_PROSSIMA_SESSIONE.md`**, in ordine di esecuzione, con le righe di
lancio gia' scritte e passate dalla checklist.

Sintesi: **(1)** screening di `ABTG_MeanRevert` — EA gia' scritto e compilato,
due righe pronte, giro a vuoto per primo · **(2)** sbloccare i domini delle
fonti · **(3)** `Nikkei Gap Continuation` dopo aver sfrondato gli input e
risolto il fuso · **(4)** misure aperte (DD OOS di `COST_EURJPY`, indici a
tick reali, Pepperstone, LZMA) · **(5)** filone nuovo: **motori per le
aperture di DAX e Nasdaq**, con la bussola di R42 (_"agli estremi del range
di apertura non c'e' edge in nessuna direzione: paga solo il RETEST"_).
