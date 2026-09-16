# 🌆 RESOCONTO DELLA GIORNATA — 16/09/2026, ore 21:00

_Il punto sul progetto, non sui singoli trade — quello lo fa la pagella delle
23:00 (`report/giornata_2026-09-16.md`, un'altra routine). Qui NON si scrive
sopra quel file._

---

## 🤖 COSA HA FATTO LA MACCHINA DA SOLA

- **Runner VPS, corsa delle 03:30** (`backtest_pipeline/coda/referti/REFERTO_RUNNER_20260916_033005.txt`):
  86 righe di coda, 74 in corsia ROUND, **63 eseguite**. **11 uscite "NON MISURATO"**
  (exit 2): **10 confermano la classe 376** già scritta ieri notte (il gate della
  corsia ROUND non sa gestire `@FRAZIONEIS 1.0`) — e **4 sono round nuovi non
  ancora catalogati** (`R160e`, `R161b`, `R161c`, `R162a`), aggiunti alla lista.
  L'undicesimo (`cemad02`) è un caso diverso, già chiuso (classe 312).
- **Nessun nuovo dossier di caccia esterna oggi**: l'ultimo in
  `backtest_pipeline/caccia_strategie/` resta del 10/09 (la routine "caccia
  continua motori intraday indici" gira ogni 2 giorni alle 08:00 — prossima
  uscita domani).
- **Il grosso della giornata è stato lavoro di scrittura e verifica di file
  prova**, fatto da agenti in parallelo e controllato da me alla fonte prima
  di ogni commit — **20 round nuovi**, tutti passati dal doppio cancello:
  - `InpCloseAtEnd` chiuso su tutte le sedie della lista (R170a-c)
  - `InpSLBufferPts` su EasyTrend, prima famiglia della serata con merito
    misurato (non sospeso) su entrambe le sedie (R171a-b) — ma sotto il
    pavimento di frequenza, non candidata al 1° ottobre
  - **7 manopole su 10** chiuse sulla sedia `770202` (Dow Apertura US), la
    più scoperta della flotta e candidata al terzetto (R172a-g): trovate due
    conseguenze di codice mai documentate (il breakeven indipendente e il TF
    del trailing spostano **entrambi** il bersaglio della parziale, per la
    stessa catena a cascata)
  - 2 manopole su 3 sulla famiglia parziale/breakeven Supertrend-SuperWave,
    sedia `770511` (R173a-b)

---

## 💶 IL CONTO

- **100k dry-run FTMO (50504263)**: ultimo dato disponibile è di **ieri
  (15/09)**: **+3.697,08** dal via su un target di +10.000 (+10%) →
  **36,97% del percorso**. Oggi **[NON ANCORA MISURATO]** — lo calcola la
  pagella delle 23:00.
- **SlippageLogger sul conto REALE (10105439)**: **sì, finalmente ha dati
  veri**, non più zero. 8 deal registrati da inizio raccolta (04/09), tutti
  sulla sedia `770101` (DAX Apertura EU). Sulle **3 uscite in stop**
  misurate: scarto **mediano 0,000** punti indice, **P95 1,700**, costo
  totale **0,68 EUR**. Campione piccolo, ma è la prima misura vera di
  slippage sul conto vero che il progetto abbia mai avuto.
- **P/L pieno del conto reale**: resta buio. Nessun `ABTG_TradeExporter`
  gira sul terminale del reale — lo SlippageLogger è un logger diverso
  (misura solo lo scarto di prezzo, non il P/L). Misurato l'8/09, non
  cambiato oggi.

---

## 🔬 COSA HO DECISO IO

- **Riparato un bug reale negli strumenti di casa** (classe 378):
  `censimento_uscite.py` girato senza escludere le copie di lavoro degli
  agenti paralleli aveva gonfiato i conteggi di **quasi 9 volte** (2.184 →
  19.670). Corretto escludendo `.claude/worktrees` dal suo giro, rigenerato
  il file committato pulito.
- **Confermata empiricamente** (non solo da lettura di codice) la classe
  376, incrociando il referto vero della corsa delle 03:30 — e ampliata la
  lista dei round affetti da 6 a 10 casi noti.
- **Corretti 3 file GIÀ ARMATI** (non solo quelli appena scritti), quando un
  agente parallelo ha trovato difetti non bloccanti al loro interno:
  bande di tolleranza costruite su un riassunto arrotondato invece che sui
  CSV veri dell'ancora (classe 385, su `R165a` e `R173a`), e una citazione
  di riga di sorgente sbagliata condivisa su tre file (`R172a/b/c`). Ogni
  volta con un nuovo giro di pin dichiarato, mai in silenzio.
- **NON ho toccato** `RIGA_ROUND_VPS.ps1` per il fix della classe 376: è
  infrastruttura del runner condivisa da tutti i round futuri — resta la tua
  firma, come deciso ieri notte.
- **Sull'incidente ORB di stasera**: non ho toccato nulla sul conto reale
  (non potrei e non l'ho fatto) — ho solo aiutato a leggere la situazione.
  La cancellazione del pendente è stata una tua azione.
- **Dispatchata una ricerca sui costi XAUUSD** tra prop firm diverse, su tua
  richiesta esplicita — risultato parziale e dichiarato come tale (l'ambiente
  ha bloccato l'apertura di ogni pagina web stasera, anche di controllo: la
  classifica consegnata è da fonti di ricerca, non da pagine aperte).

---

## ⚠️ COSA ASPETTA CLAUDIO

- 🔴 **Il fix della classe 376** (il gate della corsia ROUND non sa gestire
  `@FRAZIONEIS 1.0`): tocca l'infrastruttura del runner, condivisa da tutti
  i round futuri — serve la tua firma prima che un agente la tocchi.
- 🔴 **L'ORB su EURAUD H1 sul conto reale, con un pendente vivo prima della
  FOMC**: scoperto e disinnescato stasera (hai cancellato il pendente in
  tempo). Un dettaglio emerso ora, rileggendo il diario di ieri: **non è
  comparso stasera dal nulla** — il censimento dei `.chr` del 15/09 aveva
  già trovato `ABTG_ORB_Ottimizzato` attaccato al terminale del reale
  (insieme a `DAX_Apertura_EU` e `SlippageLogger`). Quello che non sapevamo
  è che fosse proprio su EURAUD H1, con un ordine pendente vivo. Resta da
  decidere: lasciarlo, spostarlo, o staccarlo del tutto da quel grafico —
  e capire con calma quando e perché è finito lì.
- La taglia di EMA200 (771531): resta aperta la domanda se spostarla dal
  1,0% (piccolo) al 0,65% (challenge). Stasera hai detto "sono rimaste
  uguali" ma non ho capito a cosa ti riferivi esattamente — da chiarire.
- Un pacchetto grande di round armati oggi in coda per la tua firma generale
  (da `R163a` a `R173b`, più `R172f/g` appena scritti): nessuno tocca
  rischio o conto reale, tutte misure di backtest sul banco demo.

---

## 🎯 DOMANI

1. Chiudere le ultime 3 manopole scoperte sulla sedia `770202`
   (`InpSLMode`, `InpMinStopPts`, `InpSkipIfTight`)
2. Passare alla prossima famiglia grande di uscite mai provate
   (BreakingBand, PTE, o `InpSLMode` su GapFill)
3. Leggere i risultati della corsa di stanotte appena arrivano dal VPS
   (serve il tuo `carica_risultati.ps1` — i CSV non sono ancora nel repo,
   solo i log del runner)
