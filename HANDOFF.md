# HANDOFF — punto d'ingresso per una chat nuova

> **Da incollare in una chat nuova:**
> *"Leggi `HANDOFF.md`, `PIANO_PROP.md`, `CACCIA_MOTORE_APERTURE.md`, `FLOTTA_ATTIVA.md`, `PROMEMORIA_APERTURE.md` e `backtest_pipeline/risultati_archivio/CLASSIFICHE.md` nel branch `lavoro` del repo `claudiospadaro12/GITHUB` e riprendi da lì."*
>
> Ultimo aggiornamento: **2026-08-13 mattina**. **Branch unico di lavoro: `lavoro`** (qui è consolidato TUTTO).

---

## 🟢 RIPARTI DA QUI — stato al 13/08 mattina (le sezioni sotto questa sono STORICHE)
**Per il quadro vivo leggere, in ordine:** `report/DIARIO.md` (righe 11-13/08),
`report/CAMPAGNA_ARSENALE.md` (15 sedie), `report/SCHEDA_SECONDA_PROP.md`
(dossier D3), `backtest_pipeline/prove/BREAKING_BAND_TESI.md`.

- **Vivaio a 10 sul conto piccolo 50503392** (verificato **9/9** dai .chr,
  13/08): MAXMIN ORO 770402 · PTE Dow/GBP/JPY 771321-23 · SW Dow/GBP
  770531-32 · EMA200 Dow 771531 · **Breaking Band GBPUSD/EURUSD/AUDUSD
  772161-63 (sedie 13-15, deployate 13/08: pattern 2/0/1, taratura CAL1
  1,35/1,0, TPMode 0)**. **Regola vivaio aggiornata 13/08 (Claudio):
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
