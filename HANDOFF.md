# HANDOFF — punto d'ingresso per una chat nuova

> **Da incollare in una chat nuova:**
> *"Leggi `HANDOFF.md`, `PIANO_PROP.md`, `CACCIA_MOTORE_APERTURE.md`, `FLOTTA_ATTIVA.md`, `PROMEMORIA_APERTURE.md` e `backtest_pipeline/risultati_archivio/CLASSIFICHE.md` nel branch `lavoro` del repo `claudiospadaro12/GITHUB` e riprendi da li'."*
>
> Ultimo aggiornamento: **2026-09-03 mezzogiorno**. **Branch unico di lavoro: `lavoro`** (qui e' consolidato TUTTO).

---

## 🗓️ AGGIORNAMENTO 03/09 — LA GIORNATA PIU' DENSA: gemelli ORB risolti, LondonFx promosso+firmato (R116), spread misurato, migrazione Fase 1 avviata

### 🔫 MISTERO GEMELLI ORB — RISOLTO (dossier `report/ORB_GEMELLI_DIVERGENZA_2026-08-22.md`)
- Causa **confermata su 3 giorni su 3** (19/08, 21/08, 02/09): `SelPos()` usa
  `PositionSelect(_Symbol)` che su conto HEDGING prende la posizione col TICKET
  PIU' BASSO del simbolo; se e' di un altro magic, l'ORB e' cieco alla propria
  posizione → trailing/breakeven/OCO/OneTradePerDay muti. Pistola fumante:
  `LARRY DOW S` (772341) aperta dal 01/09 sul Dow del piccolo.
- **FIX v1.04** scritto (commit `19312c8`, SOLO REPO, mai compilato):
  selezione hedge-safe per simbolo+magic ovunque, chiusure per ticket, 33 casi
  autotest, log che verifica in campo. **7 cambi di comportamento reali** da
  leggere prima della firma. **Perimetro deploy FIRMATO** (11:05): solo conto
  PICCOLO, 100k intatto fino a fine Fase 1 (D1 mirror). Stringa di compilazione
  di prova in preparazione dal verificatore.
- **TAGLIA ORB 100k 3,3x** scoperta dalla pagella (girava a 1,0% invece di
  0,3% dal 24/08) → **CORRETTA da Claudio** alle 08:10 (foto prima/dopo).

### 🕶️ AUDIT DI FLOTTA `PositionSelect` (report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md)
- 126 EA censiti: **26 VULNERABILI + 8 MEZZO-FIX (chiudono per simbolo) + 85 sani**.
- `report/VERIFICA_CHIUSURE_INCROCIATE_2026-09-03.md`: danno ATTIVO mai successo
  (0/1264); danno PASSIVO misurato (ORB nativo 770601: secondo lato aperto
  4 giornate su 16). Coda fix: rossi prima, 100k dopo Fase 1.
- **ANTIPASTO eseguito** (commit `7d0da9f`, repo-only): `InpOneTradePerDay`
  IMPLEMENTATO (era dichiarato e mai letto) in ABTG_ORB.mq5 v1.01 e
  ABTG_MaxMinNotte.mq5 v1.11, hedge-safe. Sul MaxMin oro 770402 cambia i
  numeri alla prossima ricompilazione (changelog avvisa).

### 🏹 VIVAIO — un morto misurato, un promosso firmato, due in coda
- **V8 (RSI+EMA)**: NON PROMOSSO **confermato da misura** — l'ablazione mostra
  che il filtro RSI toglie solo il 9-13% degli incroci EMA (e' un incrocio EMA,
  famiglia gia' morta). `REFERTO_SONDARSIEMAV8_2026-09-03.md`. L'esperimento
  MANUALE di Claudio continua (diario, il V8 come sveglia).
- **LondonFx**: PRIMO SUPERSTITE del passo 0 — EURUSD 19/24 righe vive, GBPUSD
  24/24, filtro RSI taglia 73-77% (filtro VERO). `REFERTO_SONDALONDONFX_2026-09-03.md`.
  **R116 FIRMATO** (F5=A soglia short 20, ora 8, rischio 0,65%): criteri in
  `LONDONFX_TICK_CRITERI.md`, firma in `report/FIRME_2026-09-03.md`. **EA
  contenitore `ABTG_LondonFx.mq5` COSTRUITO** (commit `42eb67b`, repo-only,
  3 motori a interruttore, nato hedge-safe, 112 casi autotest).
- **RELATIVO** (scarto DAX/Dow come motore) e **VGRSI** (paper arXiv): promossi
  della 4a battuta di caccia, in coda. Sonda RELATIVO in costruzione.

### 💸 SPREAD FLOTTA — MISURATO (`SPREAD_FLOTTA_MISURA_2026-09-03.md`)
252M tick, **solo-bid 0,000% su 3 simboli** (le corse Model 4 usano lo spread
vero, niente da rifare). Mediane in sessione: NASUSD 1,6-1,8, U30USD 1,9-2,0,
D30EUR 1,6-1,7 punti indice; **DAX di notte 3,5-3,9** (MaxMinNotte paga).
Il "2.0 NON MISURATO" dei prova e' storia: dai round futuri si cita questa misura.

### 🕐 OROLOGIO vs BREEDON — confronto CHIUSO (`OROLOGIO_VS_BREEDON_2026-09-03.md`)
La cella pre-registrata dal paper (EURUSD SHORT 08:00-16:00 server) **passa il
cancello C1 su ENTRAMBE le finestre** (IS C1 4,59 / OOS 5,31). Conferma a doppia
fonte. Killer noto: il costo (~1bp slippage uccide la versione ingenua).

### 🚚 MIGRAZIONE 100k — Fase 4 VERDE, collaudo Fase 1 in corso
- **Censimento sedie mute 6/6 VIVE e attaccate** (`CENSIMENTO_SEDIE_MUTE_2026-09-03.md`)
  → semaforo Fase 4 verde.
- **PIANO_PROP v18** (`report/PIANO_PROP.md`) incorpora tutta la giornata.
- **Collaudo enforcement Fase 1 sessione 1** (cap/fail-open): pacchetto costruito
  (`backtest_pipeline/righe/COLLAUDO_FASE1_SESSIONE1_DA_MANDARE.md`, driver v2 pin
  `2e37a67`). SCOPERTA: il terminale del 100k gira sotto l'utente Windows
  **Administrator** (non Master) → il collaudo si lancia dalla sessione
  Administrator. Idraulica confermata (conto trovato, filo ok), ma
  **rischioAperto=0,00%** alle 11:19 → collaudo VERO rimandato alle ~15:30
  (ore USA, mirror con posizioni aperte). Le 3 stringhe sono in chat.
  ⚠️ **Difetto noto sulla S1 (classe 130, misurato il 05/09 e NON corretto per
  non far divergere il file dal pin): `$global:CAN_RIASS` sopravvive fra due
  invocazioni nella STESSA console → una `-Chiusura` che non trova referti del
  canarino conta quelli della corsa precedente. Contromisura di procedura:
  lanciare la riga 3 della S1 da una console APPENA APERTA.**
- **Collaudo enforcement Fase 1 sessione 2** (criteri 5 = pausa B1 che morde,
  6 = posizioni gestite durante la pausa): pacchetto **costruito e pinnato il
  05/09** — `backtest_pipeline/righe/COLLAUDO_FASE1_SESSIONE2_DA_MANDARE.md`,
  driver `RIGA_COLLAUDO_FASE1_S2.ps1` v1, pin **`e487932`**, marcatore
  `MARCATORE_RIGA_COLLAUDO_FASE1_S2_v1`. 16 passi, 3 righe PowerShell di sola
  lettura, **5 corse del canarino** (la 4ª misura il LATCH, la 5ª certifica che
  il 100k e' tornato a casa). 🔴 **Precondizione fisica: si lancia SOLO in una
  giornata in PERDITA** (`Perdita oggi` > 0 nel pannello: Guardian riga 400 —
  con dailyPct<=0 nessuna soglia positiva morde). Il driver ha il GATE a
  macchina sul campo `dayLoss=`. **Mai lo stesso giorno della sessione 1.**
  Provato ESEGUENDO su banco stubbato: 5 casi (felice / giornata in utile /
  GV cancellate prima di rialzare la soglia / pausa rimasta accesa / zero
  referti del canarino), tutti con l'esito atteso. Manca solo il verificatore.

### 🎫 DUKA + esperimento manuale
- DUKA tranche-sonda Dow (2024-10 → 2025-06) in completamento (~14:45 oggi).
  Riga IMPORT+SONDA di validazione in preparazione (cancello: mediana ≤0,05%,
  copertura ≥80%, DST — decide se scaricare la storica da 5 giorni).
- **Diario manuale V8** (`report/DIARIO_MANUALE_V8.md`): **SOSPESO da Claudio
  alle ~14:40** ("molto male, mi concentro sulla creazione di EA"): 8 trade in
  2 giorni, 3 senza stop dichiarato, 5 su 8 sul DAX (3 fuori sessione cash), il
  laterale ha segato entrambi i lati. Numeri finali di 6-7-8 da leggere dallo
  storico. Se si riprende, regole da rifirmare PRIMA.
- **🔴 FATTO NUOVO 16:08 (VPS): TUTTA LA FLOTTA GIRA SOTTO `Administrator`, NON Master.**
  `Get-CimInstance Win32_Process`: pid 9452 (piccolo) e pid 4948 (-V3/100k) entrambi
  `VMI3047753\Administrator`. Le cartelle dati vive stanno sotto `C:\Users\Administrator\...`
  (piccolo `215D85...` con ORB v1.02 del 22/08; 100k `BCA8AD...`). Le copie sotto
  `C:\Users\Master\...` sono MORTE: il PASSO 1 di stamattina ha compilato leggendo una
  copia morta (innocuo: non ha scritto), e ogni deploy fatto da Master dopo il 22/08 non
  e' mai arrivato in forward. Da oggi: **ogni riga per il VPS si lancia dalla sessione
  Administrator** (collaudo, deploy, pagelle). Pagina del deploy corretta con banner.
- **ORB v1.04 — PASSO 1 FATTO alle 14:18: COMPILA (0 errori, 0 warning)**,
  referto `risultati_archivio/REFERTO_COMPILA_ORB104_2026-09-03.txt`. Rilievo: il
  giro e' partito dal VPS (nessun danno, tre INVARIATO misurati): la prossima
  compilazione di prova dal PC di backtest. **PASSO 2 (deploy SOLO piccolo):
  PAGINA PRONTA E PINNATA** — `righe/RIGA_DEPLOY_ORB104_PICCOLO_DA_MANDARE.md`
  (pin `8167c772ac15df23ef177fa5754839232829869b`, driver
  `RIGA_DEPLOY_ORB104_PICCOLO.ps1` marcatore `_v1`): due blocchi, CONTROLLO
  (anche di giorno, non scrive) poi CORSA (VPS, sessione **Master**, MT5 e
  MetaEditor CHIUSI, dopo le 22:15). Cartella dati scelta per QUATTRO fatti
  (bases BCM, niente 100k, login 50503392, profilo della sessione: checklist
  **115-bis**), foto prima/dopo di piccolo E -V3 (byte+sha256), backup su
  `Desktop\backup_orb_v102_<data>\<ora>`, ripristino su fallimento. 27 casi
  eseguiti su banco stubbato, verificatore PASS (eseguito a mano: strumento
  Agent non disponibile): `risultati_archivio/REFERTO_DEPLOY_ORB104_PICCOLO_PREPARAZIONE.md`.
  PASSO 3: la prova della v1.04 e' la riga `ORB AUTOTEST ... 0 falliti` nella
  scheda Esperti (OnInit NON stampa la versione). `aggiorna_verifica_orb.ps1`
  NON toccato (viola il perimetro: resta agli atti).

### ⏳ CODA (prossimi passi)
1. Collaudo Fase 1 sessione 1 alle 15:30 (VPS come Administrator, rischio>0).
2. DUKA fine corsa → zip → import+sonda → cancello storica.
3. Passo C diagnosi GBPUSD stasera a banco pulito (chiude H1 vs H3).
4. ~~Compilazione di prova ORB v1.04~~ FATTA (OK) → deploy sul piccolo stasera
   dopo le 22:15 con la riga PASSO 2: **pagina pronta**
   (`RIGA_DEPLOY_ORB104_PICCOLO_DA_MANDARE.md`, pin `8167c77…`): CONTROLLO
   prima (va bene anche di giorno), CORSA con MT5 chiuso, poi PASSO 3.
5. Righe in costruzione da agenti (03/09 ~14:50): **R116 LondonFx** (tick,
   EURUSD+GBPUSD) -> **PRONTA** (03/09 pom.): `backtest_pipeline/righe/RIGA_R116_LONDONFX_DA_MANDARE.md`,
   driver `RIGA_R116_LONDONFX.ps1` v1 + 2 prova `LONDONFX_R116_*.txt`, 5 blocchi
   (EUR vuoto/corsa, GBP vuoto/corsa, -SoloFase2), pin nella pagina. NOTA: l'EA
   v1.00 NON esporta il per-trade (5.0.5 e S4 dei criteri non eseguibili: segnalato).
   E **sonda RELATIVO** (4 prove) — da lanciare quando il PC di
   backtest si libera dopo il DUKA. Poi il giacimento di classe 3:
   AllineaLondra e VwapRevert (righe gia' scritte, costano UNA corsa).
6. Collaudo Fase 1 sessione 2 (pausa/gestione) — MAI lo stesso giorno della 1.

---

## 🗓️ AGGIORNAMENTO 29/08 — SAGA IN-BULGE, PAGELLA, SETACCIO PINE, STATO TF-BASSO

### 🎯 IN-BULGE del Bulge — costruito, misurato, CHIUSO ordinato
- **`ABTG_BreakingBand.mq5` → v1.05** (commit su `lavoro`). Aggiunto input opt-in
  **`InpContEntryMode`**: 0=primo tocco (storico, sedie vive), 1=retest banda
  opposta (protocollo scritto), **2=IN-BULGE di Claudio** (primo-tocco-opposta +
  filtro trend mediana + candela direzionale + range). Scoperta chiave: l'EA
  entrava al PRIMO tocco, il protocollo scritto dice RETEST, ma il VERO IN-BULGE
  di Claudio (stabile su v1/v3/v10 dei suoi Pine) e' **primo-tocco-con-trend**.
- **A/B MISURATA** (`REFERTO_ABTEST_CONTENTRY_2026-08-29.md`, driver
  `RIGA_ABTEST_CONTENTRY.ps1`, pin 203a519, GBPUSD/EURUSD/AUDUSD H1 tick reali):
  **VINCE IL PRIMO TOCCO (mode 0).** PF OOS EURUSD (test decisivo, solo
  continuazione): mode 0 = 2.944 (n43) vs mode 2 = 0.948 (n8, PERDE). GBPUSD
  mode 0 = 1.904 > mode 2 = 1.495. AUDUSD tris identico (solo inversione,
  InpContEntryMode inerte = **conferma correttezza build**). Mode 2 over-filtra.
- **CONSEGUENZA: default resta 0, mode 1/2 restano codice opt-in misurato NON
  adottato** (come R91/InpMinRR). Niente grid-search (Seconda Caccia). Riserve:
  campione sottile (merito sospeso) + tick BCM forex non misurati. Capitolo chiuso.

### 📊 PAGELLA SETTIMANALE 24-29/08 (`report/PAGELLA_SETT_2026-08-29.md`)
- +303,95 EUR totali, ma **due conti opposti**: piccolo −60,51 (PF 0.76, 34
  trade, tutto) vs 100k dry-run +364,46 (PF 1.46, 11 trade, SOLO indici).
  **La selettivita' ha vinto.**
- **DAX Apertura EU RETEST BUY** = edge su ENTRAMBI (+40 / +586). **ORB OTT BUY**
  = peggiore (−19,98 / **−405,35**) → conferma forward "ORB chiuso" → OSSERVAZIONE
  al prossimo censimento (criterio uscita sedie). Bias 17% coerente (forex 0%,
  DAX 75%).

### 🧹 3 corse lette + setaccio 32 Pine esterni
- **Corse** (G1PAOLO, VWAPREV, FVGRET): nessuna da' una proposta. VWAPREV/FVGRET
  sono D30EUR M15 (bassi TF indici): VWAPREV campione sottile+OOS perde, FVGRET
  DD 42,9% (bocciato rischio).
- **32 Pine esterni valutati → 0 candidati nuovi.** Tutti dominati (EMA-cross→HAM,
  BB-MR→Bulge, struttura→HH&LL) o chiusi (ORB/breakout) o red-flag (3 recovery/
  griglia: 2 pyramiding + 1 rebuy; 2 licenza CC-NC). **2 mattoncini archiviati**:
  idea EMA-retest (Grant), Laguerre RSI.
- **Tassonomia Bulge di Claudio mappata** (dai suoi Pine BOLL BULGE v1/v3/v10 +
  Sequence 1-2-3-4): IN-BULGE (opposta+trend) / POST-BULGE (=INVERSIONE, gia'
  nell'EA) / 3a famiglia RANGE-o-CONTINUATION (**Claudio non ha ancora deciso**).
- **I DUE motori veri di Claudio**: (1) SuperTrend+EMA9/21 → rappresentante **HAM**;
  (2) Bollinger mean-reversion → **Bulge** (schierato) + cugini.

### 📉 STATO TF-BASSO SUGLI INDICI (l'obiettivo dichiarato di Claudio)
- **R108/R111**: il Bulge NON scende a M15/M30 (6/6 finestre rosse, "morto di
  SEGNALE non di costo"). La tesi "operativita' M5/M15" del Bulge e' MISURATA E FALSA.
- **R109 ATR Exhaustion Volume Spike su INDICI** (D30EUR/NASUSD/U30USD M15):
  **BOCCIATO SENZA APPELLO** dalla corsia rischio (DD 44-68% a 1%, peggior
  giornata −9,72% vs muro −5%). MA **la FREQUENZA c'e'** (655-927 op/cella in 21
  mesi): sugli indici la frequenza low-TF esiste, **manca il SEGNALE/edge**.
  Lezione congelata: **pavimento SL OBBLIGATORIO** (mai InpMinSLPts=0) per ogni
  futuro candidato M15 indici; gate per riaprire = **prova di regime** (_EXT, in frigo).
- **Lettura d'insieme**: la lane FADE/mean-reversion su indici M15 (R109 + VWAPREV
  + FVGRET) = frequenza si', edge no (tutto bocciato/debole, e sono 21 mesi di
  UN solo toro). L'edge indici vero vive nell'**APERTURA/RETEST** (DAX Apertura
  vince in forward), non nei fade. Prossimo candidato fade gia' in porting citato
  da R109: **VWAP Mean Reversion** con SL strutturale (= il pezzo che mancava).

### 🧵 FILI APERTI (decisioni/lavori)
- **HH&LL** (struttura pivot, LonesomeTheBlue+ABTG): l'unico motore NUOVO del
  giorno. Da riscrivere come `strategy` → PASSO 0.
- **HAM su oro**: consolidare 4 varianti (TEST A/WIDE/v10/PROFIT MAX) in un EA,
  sizing LotByRisk, rispettare split Emiliano-Lock/Optimizer.
- **ORB OTT BUY**: osservazione/spegnimento al censimento (perde in forward).
- **3a famiglia Bulge**: decidere RANGE vs CONTINUATION prima di costruirla.
- **Micro-dettaglio mode 2**: ATR aref (congelato) vs corrente dei Pine — 1 riga,
  default aref, cambiabile.
- **.set delle 3 sedie BB vive** non in repo (TODO da R91).
- **[DA CHIARIRE con Claudio] "l'orologio"**: cita cosa intende — candidati:
  (a) fuso BCM / ora log MT5 vs grafico, (b) pagella automatica 23:15, (c) altro
  strumento/EA a orario.

---

## 🌙 AGGIORNAMENTO 26/08 NOTTE (2) — CHIUSURE DI MEZZANOTTE

- 🏁 **R112 CHIUSO**: nessun dial passa il cancello (dial 2 fermato dalla
  peggior giornata −2,70 vs −2,45, dial 3 dal DD): sedia 771531 resta
  com'e'. G0-B OK due volte (banco riproducibile). Peggior giornata della
  sedia viva misurata (−2,45% fisso). Scoperta: n = deal di USCITA,
  posizioni ≈ n/2. Checklist 87 e 88 nate qui. `R112_REFERTO.md`.
- 📚 **STORICO INDICI COMPLETO AL 100%** (corsa 23:34): tutte e 4 le serie
  OK — NASUSD 362.325 M15 / 93.085 H1, SPXUSD 360.619 M15 / 92.932 H1,
  2010→2026 zero anni vuoti. Capitolo chiuso.
- 🏛️ **FTMO, due letture pronte da firmare**: `ANALISI_TAGLIA_FASE1` (la
  LEVA 1:15 e' il problema, non la taglia: C1 a 5 SL = 149% del margine ai
  massimi) e `PROPOSTA_GUARDIAN_FTMO` (10 decisioni, "FIRMO PRESET
  GUARDIAN FTMO"). Claudio orientato a taglia alta: il milione non si
  compra, si scala (supplemento dossier).
- 📐 **R113 FIRMATO E PRONTO AL LANCIO** ("FIRMO R113" + "FIRMO GUARDIAN"
  ~00:10): criteri firmati, 18 file prova, driver con fabbrica .ini
  propria (no walkforward), verificatore FAIL->CORRETTO (3 difetti,
  checklist 89/89-bis/89-ter: spread dichiarato NON MISURATO - il banco
  _EXT potrebbe essere senza attrito -, elenco attesi fuori dal try,
  ripiego CSV che poteva leggere il banco sbagliato). **PIN `9ddf37b`**,
  stringhe consegnate in chat (blocchi 1+2, MT5 chiuso, stima 10-25 min).
- 📨 **TRE MAIL PROP INVIATE da Claudio** (~23:50-00:00): FTMO, FundedNext
  (auto-ack 12-24h), Alpha — 5 domande su misura ciascuna. Le risposte
  scritte decidono la classifica (girarle in chat appena arrivano).
- 🖊️ **"FIRMO GUARDIAN"**: preset FTMO firmato con le 10 decisioni,
  compresa D9 versione raccomandata (soglie nuove provate PRIMA sul 100k).
  I 5 prerequisiti (D10) restano da eseguire.
- 💰 Stima 5×200k archiviata (`STIMA_GUADAGNI_5PROP_2026-08-27.md`).
- 📈 Pagella 26/08: massimo storico 100k (100.777,29), 7/8 vincenti.
- ⚠️ **27-28/08 Jackson Hole**: nessun lancio live, Guardian di guardia.

---

## 🌙 AGGIORNAMENTO 26/08 NOTTE — R112 FIRMATO, PIANO PROP v14, DOSSIER PROP, EXCEL

Claudio scollegato in serata ("A DOPO"). Stato al momento del distacco:

- ✍️ **R112 "contratto EMADOW short" FIRMATO** ("FIRMO R112"): criteri
  `R112_CRITERI.md` (lucchetto tolto), 4 file prova `prove/R112_*.txt`,
  CSV riferimento G0-B in `prove/R110_CSV_EMADOW/`, driver
  `righe/RIGA_R112_EMADOW_CONTRATTO.ps1` + foglio `RIGA_R112_DA_MANDARE.md`
  (segnaposto @@PIN@@) costruiti. **IN CORSO: verifica del verificatore-
  stringhe.** Dopo il PASS: pin, ripin ricette, stringhe a Claudio
  (blocchi 1+2, MT5 CHIUSO, ~30-45 min). Novita' del round: G0-B
  applicabile (riproduzione R110 al centesimo), peggior giornata dai
  per-trade (OOS, doppio denominatore, IS n/d per costruzione).
- 🚦 **PIANO_PROP v14**: sezione CANCELLO CHALLENGE a 6 cancelli (col 6°
  nuovo: PROVA DELLA TAGLIA), orientamento di Claudio "challenge fra le
  piu' alte" registrato come ORIENTAMENTO. Trovato: **criterio C3 gia'
  scattato su Aperture DAX** (38 ingressi, -698 EUR -> corsia MERITO,
  revisione dovuta; RETEST verde, BUY/SELL rossi); conteggi forward
  dagli statement (solo Aperture DAX 38 e ORB 25 sopra soglia 20);
  anomalia magic 770101 chiuso su NASUSD il 22/07 (da verificare al
  prossimo censimento .chr); 15,2% delle chiusure forward sotto i 2 min.
- 🏛️ **DOSSIER_PROP_CANDIDATE_2026-08-26.md**: 9 prop censite, classifica
  FTMO Swing 2-Step > FundedNext Stellar > Alpha Swing > Goat (riserva).
  Supplemento MILIONE: le taglie 1M dirette (Ment/Lux/Axi) hanno muri
  6-7% < nostro 6,37% gia' accaduto -> il milione si scala da 200k
  (FTMO ~32 mesi a >=10% netto/mese; tetto per strategia cade con lo
  scaling SOLO su FTMO, dichiarato). Tutto [LETTO-VIA-SEARCH], da
  riverificare sulle pagine prima dell'acquisto. Q1-Q10 aperte per
  Claudio.
- 📉 **ANALISI_DD_TOTALE_2026-08-26.md**: con muro 5% giornaliero, al
  dial 1,00 il DD totale worst e' -6,37% sui chiusi (0 violazioni del
  -10% su 481 partenze; trailing 6% romperebbe anche sui chiusi).
- 📊 **report/MONITOR_CHALLENGE.xlsx** consegnato a Claudio (registro
  challenge/funded: impostazioni, giornaliero coi muri, prelievi,
  dashboard). Verifica LibreOffice non disponibile in ambiente (si
  blocca anche su file banale): controllo a mano sulla riga d'esempio.
- ⚠️ **Jackson Hole gio 27 - ven 28/08**: flotta senza filtro news,
  Guardian e' la rete.

---

## 🌃 AGGIORNAMENTO 26/08 SERA — LA SERATA DEI CINQUE ZIP: TUTTO ESEGUITO

Claudio al PC dalle 17: **tutta la scaletta serale è stata eseguita e letta**.

1. ✅ **STORICO (pin `2ba0286`)**: NASUSD_EXT conta-barre OK dopo il gesto
   grafico (M15 362.325 / H1 93.085, zero anni vuoti); **SPXUSD_EXT importato**
   (4.598.932 barre, diff 0,0608%). Resta solo il gesto grafico SPXUSD per il
   suo conta (bassa priorità).
2. ✅ **MISURE LAMPO (pin `03268a2`)**: vol oraria MISURATA, 3 eventi su 3 =
   movimenti veri. → **FIRMA "FIRMO FRIGO NASUSD"** registrata come
   emendamento in `prove/PROVA_REGIME_CRITERI.md`: metro relativo 0,20×vol
   per i soli indici, **NASUSD_EXT AMMESSO alla prova di regime** (rapporto
   0,199; parametri congelati, mai promozione), SPX/225JPY restano in frigo.
3. ✅ **ANATOMIA APERTURE (pin `3b95be3`)**: canarino fuso VERDE (feed = ora
   NY su due misure indipendenti), IS 2010-2020 pulito (sospetti 0-2%).
   **Risposta: RIENTRO 38,7% ma payoff ~0; DRIVE 45% con asimmetria 5-6:1**
   (MFE60 0,53-0,64% vs MAE 0,11%). Persistenza dei primi 15' ≈ moneta. Gap
   non sposta le frequenze. Rilievo: 2023 (cassaforte) 22,9% sospetti.
   Cassaforte SIGILLATA (archiviata, non letta). Lettura:
   `LETTURA_ANATOMIA_APERTURE_2026-08-26.md` + artefatti in
   `ANATOMIA_APERTURE_20260826/`. FASE 2 da disegnare sull'asimmetria.
4. ✅ **DIAGNOSI DAX (pin `386346d`)**: **grxeur 2020-06→2023-11 NON è il
   DAX** (sessione 02-15 NY + prezzi 3,2-4,4k, 2022 = 85% barre fuori banda;
   [INFERITO] EuroStoxx50). 2019+2024-26 puliti ma insufficienti. Densità
   SOSPESA (soglia bocciava anche il controllo positivo), Q1 SOSPESA
   (troncamento). **DAX fuori dallo studio; strada 2 = Dukascopy DEUIDXEUR
   (~25h, decisione di Claudio).** Lettura: `LETTURA_DIAGNOSI_DAX_2026-08-26.md`.
5. ✅ **R110 CHIUSO (pin `4d6952f`, corsa 1,3h, 12/12, 0 guasti)**: referto
   `R110_REFERTO.md`. **Titolo: EMADOW short = prima cella dei lati con
   MERITO PIENO sugli indici, CANDIDATA** (OOS PF 1,891 n302, DD 2,66% vs
   7,83% della sedia; verde anche in IS). SWDOW long 3,28 (n100, indizio) ma
   short ROSSO 0,429; SUPNAS short verde-indizio 1,870 (n34); SUPDAX short
   NON MISURABILE (n29). Spina dorsale (short vive nelle discese) confermata
   terza volta — EMADOW short è l'eccezione che guadagna anche in salita.
   **Nessuna promozione (G5)**: la proposta "EMADOW short-only/pesi diversi"
   è un round di modifica contratto, da firmare.

**Prossimi passi aperti**: round modifica contratto EMADOW; prova di regime
NASUSD_EXT (criteri da scrivere — risponde a SUPNAS short e R107); FASE 2
anatomia (ipotesi su IS, criteri propri); decisione Dukascopy DAX/Dow;
gesto grafico SPXUSD; round VWAP MR / FVG / SupertrendInvert in coda.
⚠️ Jackson Hole gio 27-ven 28/08: flotta senza filtro news, Guardian è la rete.

---

## 🧭 AGGIORNAMENTO 26/08 POMERIGGIO — FIRME, ANALISI DIAL, SCALETTA SERALE

- ✍️ **FIRME di giornata**: "FIRMO LO STUDIO ANATOMIA CON PROPOSTE" (criteri
  sbloccati, pin `3b95be3`), "FIRMO x S&P" (emendamento D-B: SIMBOLI
  NASUSD,SPXUSD; pin storico `2ba0286`), "FIRMO R110" (gia' del 25/08 sera).
- 📊 **Due analisi chiuse sui 481 giorni** (base riconciliata al centesimo):
  `ANALISI_DIAL_TAGLIE` — pass-rate fa il PICCO a dial 1,00 (99,6%) e crolla
  sopra (dirupo a d≈1,055; a 1,15 pass 96,7%); alzare i lotti NON aumenta il
  guadagno per challenge (piatto 8,5-9,3k), accorcia solo i giorni.
  `ANALISI_SOPRAVVIVENZA_FUNDED` — alla taglia firmata sopravvivenza 12 mesi
  100% (230/230), ma da d≈1,06 restare diventa MOLTO piu' difficile che
  passare (1 anno funded = 21x i giorni neri di una challenge). Proposta
  DUE-DIAL: challenge 1,00 / funded 0,74 (da firmare all'apertura challenge).
  Ipotesi di Claudio "piu' difficile passare che restare" = giusta alla
  taglia firmata, per un capello.
- 🔴 Risposta data e motivata: NO all'aumento lotti col Guardian come rete
  (slippage 21,5 pt misurato, guardian-as-stop = sistema non misurato).
- 📼 Trade del giorno letti a Claudio: MaxMinNotte DAX short +227 (08:27) e
  DAX Apertura RETEST long +226 (10:26, parziale+BE+trailing da manuale) —
  stesso indice, due lati, stesso giorno: la scorrelazione dal vivo.
- 🌆 **SCALETTA SERALE PRONTA** (Claudio arriva al PC piu' tardi): 1)
  conta-barre (grafico NASUSD_EXT M15 + Riga 2); 2) R110 pin `4d6952f`
  (giro a vuoto + corsa SENZA switch); 3) misure lampo pin `03268a2`
  (blocchi 1+2, MT5 puo' restare aperto); 4) anatomia pin `3b95be3`
  (blocchi 1+2); 5) Riga 1 storico pin `2ba0286` (scarico S&P ~6 min);
  6) diagnosi DAX pin `386346d` (blocchi 1+2). Le stringhe sono nei
  rispettivi DA_MANDARE, tutte col PASS del verificatore.

## 🧭 AGGIORNAMENTO 26/08 — LA NOTTATA DEI QUATTRO ROUND (R107-R111) E DEI 16 ANNI DI NASDAQ

- 🏁 **CHIUSI CON REFERTO (0 problemi aperti)**: **R107** (short aperture:
  DAX short niente edge n257, Dow=R54 confermato, NAS non si trasporta; long
  RITESTATI e riprodotti), **R108** (BB M15: morta di SEGNALE non di costo,
  6/6 rosse, S0a passato su tutti e 3 — EURUSD recuperato dall'indagine),
  **R109** (ATR Exhaustion M15: bocciato dalla corsia RISCHIO, DD 44-68%,
  peggior giornata −9,72%; EA ASSOLTO — A0 7/7; frequenza alta misurata;
  lezione: pavimento SL obbligatorio sui futuri M15), **R111** (il CONFINE:
  gradiente MONOTONO H1>M30>M15 su tutti e 3 i simboli; GBPUSD misurabile a
  campione pieno per finestra e dice NO; capitolo discesa-TF della BB CHIUSO).
- 🔬 **INDAGINE DEAL**: i "deal anomali" di R108/R109 erano il PARSER
  (`Sort-Object` NON stabile sui pari secondo, checklist 81) — EA innocenti,
  fix per il record nei driver. Checklist 63→**82** in 36 ore (classi 64-82).
- ✍️ **FIRME di Claudio**: R108 "FIRMO CON PROPOSTE", R109 "FIRMO",
  R110 "FIRMO R110" (timbrata NEI criteri: la corsa gira SENZA switch),
  R111 pre-firma "FIRMO R111", STORICO 6 decisioni firmate.
- 📡 **STORICO NASDAQ**: 16 anni HistData M1 scaricati (5,23M barre, prezzi
  sani 2010→2026) e IMPORTATI in MT5 come `NASUSD_EXT` (shift +5 auto,
  copertura 97%). Cancello qualita' resta CHIUSO (diff 0,0756% > 0,05%) come
  dichiarato: dati prodotti, uso = firma successiva. Conta-barre da rifare
  a grafico aperto (stasera).
- 🎯 **PRONTI PER STASERA (PC)**: zip conta-barre (Riga 2 dopo grafico
  NASUSD_EXT M15 + scroll) e **R110** (lati short dei motori vivi, pin
  `4d6952f`, giro a vuoto + corsa SENZA -CriteriFirmati, 20-45 min).
- 📼 **Live Paolo 25/08 analizzata**: spunto top = `ABTG_SupertrendInvert`
  gia' in repo, mai misurato sugli indici (candidato R112 dopo R110); ADR
  50gg meccanizzabile; Jackson Hole "non si trada" confermato dal docente
  (data 27-28 = prudenziale, attribuzione corretta). VWAP MR portato
  (`ABTG_VwapRevert.mq5` + tesi, col bug ATR-960 dell'autore trovato).
- 🧹 Flotta: 970911 SPENTA con delibera 11/08 (REFERTO_FUORILISTA) —
  FLOTTA_ATTIVA corretta; restano da pulire RIEPILOGO_FORWARD,
  TRACKING_FORWARD, CLASSIFICA_PF (in corso).

## 🧭 AGGIORNAMENTO 25/08 SERA — R107 FIRMATO, CACCIA M5/M15 CHIUSA, R108 IN PREPARAZIONE

- ✍️ **R107 (lati short Dow/DAX/Nasdaq) FIRMATO**: "FIRMO CON PROPOSTE" 25/08
  (D1 trasposizione letterale NAS, D2 cancello R54, D3 solo lettura spina
  dorsale). Verbale in `R107_CRITERI.md` (52ebe61). Stringhe consegnate
  (pin `690773f`, verificatore PASS): giro a vuoto + corsa vera con
  `-CriteriFirmati`. **In attesa che Claudio lanci sul PC di backtest.**
- 🏹 **Caccia M5/M15 per la challenge CHIUSA** (2 dossier del 25/08 in
  `caccia_strategie/`): lotto INDICI promuove ATR-Exhaustion+VolumeSpike
  (9/10), VWAP MeanReversion (8/10), OutOfTheNoise (in coda); lotto
  FOREX+ORO promuove **BreakingBand su M15 (zero codice, `InpTF` gia' input,
  motore vivo R103)**, KA-Gold Keltner (Code Base 48251), DayFlow VWAP
  Relay. File prova `prove/R108_BB_M15_FOREX.txt` gia' OK. Scoperte:
  TradingView RIAPERTA (procedura nel memo fonti); soffitto del costo M5
  misurato da terzi (arXiv 2605.04004) spiega i nostri M5 morti; il volume
  come conferma vale SOLO sugli indici (non si esporta su forex/oro).
- 🔜 **R108 = BreakingBand M15** in preparazione (criteri [DA FIRMARE] +
  driver via filiera builder→verificatore). ⚠️ @DAQUANDO 2022.07.01 e'
  DERIVATO dal tetto 100k barre, PASSO 0 dichiara la prima operazione vera;
  celle M5 solo diagnostiche (~1,3 anni di tetto).

## 🧭 AGGIORNAMENTO 25/08 — REVISIONE CHIUSA, R104+R105 CHIUSI, ATTREZZI IN CONSEGNA

- ✅ **Revisione "A+b" VERIFICATA** (censimento VPS 07:31: 4 spente sparite, 5
  taglie nuove esatte, somma 35,25%). Argento orfano chiuso dallo SL server.
  Flotta viva REALE: **35 sedie** (Ichimoku era un fantasma .chr — ERRATA agli
  atti, e il suo DD trovato nel report: 21,5% a taglia 0,5% → candidato
  BOCCIATO dalla corsia rischio).
- 📐 **R104 chiuso**: trailing largo NET-POSITIVO (12,93R raccolti vs 6,60R del
  tetto "incassa a 1R"); 5 restituzioni ~1,25R = prezzo dei runner; n=29<30 →
  conteggi, non frequenze. Nessun cambio al forward.
- 🏁 **R105 chiuso** (firmato ed eseguito in giornata, zero ore tester):
  **la squadra ottima È la flotta intera** (verificato anti-pesca split 14+7);
  peggior giorno −4,74% STRUTTURALE, due cluster (GapFill-lunedì + Dow, che nei
  10 giorni neri vale −21k da solo); leva unica = manopola globale **×0,74**
  (≈ la convenzione 0,65 del 100k, ora misurata). Dataset giornaliero 481g×40
  agli atti (`R105_dataset_giornaliero.csv`).
- 🛠️ **Attrezzi** (post-incidente posizioni orfane): `ABTG_ChiudiSedie.mq5`
  v1.01 (tre sicure + esito a TRE stati) e `censimento_rischio.ps1 v2`
  (profilo attivo CONFIG/UNICO/ASSUNTO, FUORI SALVATAGGIO, residui fuori
  somma). Verificatore: FAIL→corretti→**checklist 68-69** (verdetto senza lo
  stato "niente da fare"; cancellazione preventiva spacciata per freschezza).
  Pin: ChiudiSedie `360a36c`, censimento `94946f4`. Righe in DA_MANDARE.
- 💰 Stime agli atti: 31/12/26 (prudente +27,3k su 100k) e 1M prop (cauto
  ~260k/anno netti al 90%) — SEMPRE con la scala dell'onestà e l'ancora del
  forward (~pari: il banco va DIMOSTRATO tagliando dopo tagliando).
- 🔴 **IN ATTESA DI FIRMA: R106 "LA SQUADRA DA CHALLENGE"** — simulazione di
  challenge rolling sul dataset (probabilità di passare, flotta vs squadre per
  criteri, split anti-pesca). Zero ore tester, gira in minuti alla firma.
- Watchpoint: **Jackson Hole gio 27 - ven 28** (alta volatilità, Guardian B1 in
  guardia); scheda live 24/08 agli atti (conferme: volumi-su-ORB = candidato
  R101; correlazioni rotte = verdetto G3; spunti PSAR-trailing e ORB-DAX).

## 🏆 AGGIORNAMENTO 24/08 pomeriggio — **R103 PRONTO E BENEDETTO: la classifica della FLOTTA (40 sedie, anni negativi inclusi)**

- ✍️ Firmato da Claudio ("FIRMO TUTTE E TRE, PARTIAMO") + chiarimento mattina
  (una riga per SEDIA, spina dorsale anno-per-anno OBBLIGATORIA, colonna anni
  negativi/anni operati). Perimetro: 25 forex+metalli su 2020→2026 (6,5 anni,
  covid dentro) + 15 indici su 21 mesi in tabella SEPARATA (trimestre per
  trimestre — a ~1-2 op/mese il mese-per-mese sarebbe rumore).
- 🏗️ Costruito (driver 2.284 righe, autotest 56 asserzioni) e **verificato DUE
  volte**: FAIL con 3 difetti veri (PF 0.000 al posto di n/d in classifica;
  n=-1 grezzo; -TickReali che mescolava OHLC e tick nello stesso zip) →
  corretti → **PASS al pin `bb139de`**, marcatore `MARCATORE_RIGA_R103_v2`.
  → **checklist 66** (sentinelle su TUTTE le colonne: si prova con una sedia
  vuota e si LEGGE la riga) e **67** ("non devono nemmeno poter" = specifica
  di guardia: si cerca l'if, e si provano le combinazioni di switch che il
  DA_MANDARE non propone).
- 🪑 38 sedie misurate + 2 dichiarate fuori (BREAKOUT_EA_JPY_v3 senza sorgente;
  GapContinuation 225JPY rischio non leggibile). Gold_Ichimoku: solo singola,
  DD equity NON MISURATO dichiarato. Magic 76xxxx (120, verificati vergini).
- 📋 Righe in `righe/RIGA_R103_DA_MANDARE.md` (pin `bb139de` ovunque):
  giro a vuoto → Blocco 1 = tutto il gruppo INDICI (`-SoloGruppo 'INDICI'`).
  Decisione aperta non bloccante: `-TickReali` per gli indici (firmato OHLC;
  lo switch esiste, con guardia che rifiuta di mescolare i modelli).
- 🚦 **CODA SUL PC DI BACKTEST (un tester alla volta)**: 1) R102 Blocco 2
  GapFill `'C14,C15,C16'` (pin `fd23d4a`, PASS — stessi 3 simboli del Blocco 1,
  M1 già a disco); 2) R103 giro a vuoto + blocchi; 3) R104 misura MFE
  MaxMinNotte DAX (pin `4be07ed`, PASS — nato dal trade #3221475 del 24/08:
  +200 flottanti → +15,10, TP1 mai toccato, confermato dalla scheda AFFARI).
- ⚠️ Nota serale: l'archiviatore delle 23:30 sposta anche le cartelle R1xx dal
  Desktop in ARCHIVIO_TEST — se una corsa finisce di sera, lo zip puo' essere
  li' e non sul Desktop.

## 📊 AGGIORNAMENTO 24/08 notte — **R102 BLOCCO 1 LETTO: LA CLASSIFICA PARLA, E DICE NO**

- ✅ **LA MACCHINA FUNZIONA.** Corsa 00:05→00:24 (**19 minuti**), pin `393c68f`:
  scarico M1 **COMPLETO** dei 3 simboli (9,6-10 **milioni** di barre ciascuno),
  21 CSV, 3 sedie **OK**, gemelli identici al centesimo, magic `79xxxx` vergini.
  Il fix `Battito-Basi` del guardiano (crescita di `bases\`) ha retto sul campo:
  **lo scarico non è più il muro**.
- 🔴 **LA RISPOSTA ALLA DOMANDA DI CLAUDIO ("Breaking Band 133k anche col lungo?")
  è NO, e su GBPUSD cambia di SEGNO** (taglia viva 1,0% su 100k):

  | sedia | COMUNE 2009→2026 | ~27 anni OPERATI | DD lungo | DD promesso |
  |---|---:|---:|---:|---:|
  | C03 AUDUSD | **+13.025** PF 1,491 | **+8.901** PF 1,207 | 8,97% | 1,20% (7,5x) |
  | C01 GBPUSD | +5.838 PF 1,078 | 🔴 **−11.574** PF 0,897 | **23,43%** | 1,90% (**12,3x**) |
  | C02 EURUSD | +2.347 PF 1,069 | +4.129 PF 1,075 | 8,24% | 1,20% (6,9x) |

  Spina dorsale GBPUSD: **1999-2007 nove anni di erosione** (cumulato −17.623),
  fondo **−20.744 nel 2021**, risalita solo 2022-2025 (+2.281/+1.000/+2.764/+3.912).
  **L'edge vive nel PRESENTE.** Per Emendamento B questo NON boccia: dice che il
  merito si giudica sul recente e che **il rischio è 7-12x il contratto** (stessa
  dinamica dell'oro R99/R100). Peggior giornata invece tranquilla: −1,02/−1,05%,
  e le DUE misure indipendenti (report `.htm` + OPTFRAME) coincidono al centesimo.
  Tutte e tre → **REVISIONE corsia RISCHIO** (proposta a blocchi finiti, non su 3/20).
- 🧨 **RILIEVO NUOVO CHE VALE IL ROUND: tutte e tre le sedie fanno la PRIMA
  OPERAZIONE fra il 7 e il 18 GENNAIO 1999**, su simboli con M1 dichiarato
  COMPLETO dal 1993 (GBPUSD/AUDUSD) e dal **1971** (EURUSD). Tre motori
  indipendenti che tacciono per 6 anni (28 su EURUSD) e partono nella stessa
  settimana **non è il motore: è il feed BCM**. Il GATE 4 lo cattura: nominali
  34/56 anni → **operati 28**. 👉 **Da qui in avanti "storico lungo" su BCM = ~27
  anni dal 1999**, non 33 né 55. Se anche gli altri 9 simboli iniziano nel 1999,
  quello diventa il pavimento di casa (= decisione 2 firmata: prima si misura).
- 🩹 **Difetto di leggibilità corretto** (classe 47, dentro il NOSTRO referto): il
  driver scriveva `ESITO: PARZIALE -- 0 sedie su 3 non sono OK` + exit 1 su una
  corsa riuscita, e Claudio ha creduto al fallimento. Ora: `PARZIALE` solo con
  sedie mancanti (exit 1), **`COMPLETO CON RILIEVI` verde + exit 0** quando i
  rilievi sono dichiarativi. Pin `fd23d4a`, dal verificatore.
- ⏭️ **Coda**: Blocco 2 `'C14,C15,C16'` (GapFill forex) col pin nuovo. Le barre M1
  dei 3 simboli fatti **restano a disco**: i blocchi che li riusano partono
  avvantaggiati. Referto: `risultati_archivio/R102_REFERTO_BLOCCO1.md`.

## 🏁 AGGIORNAMENTO 23/08 notte (chiusura) — **R101 CHIUSO: UN SOLO CANDIDATO (02_volumi), CELLE VIVE CONFERMATE**

- 📦 Zip SOLODAX arrivato (23:14, dopo la ripresa post-falso-rosso). **G0
  riprodotto su ENTRAMBE le famiglie** (DAX: PF 1.397 vs 1.400 in tolleranza,
  DD esatto; n entra agli atti: IS 175/OOS 270). Referto CHIUSO:
  `risultati_archivio/R101_REFERTO.md`.
- 🟢 **UNICO candidato sopravvissuto a G1+G2+G3: `02_volumi`** (VOLUMI ≥1,5×
  media20, dal corso): coerente su DUE mercati e DUE finestre — Dow OOS PF
  1,543/DD 2,83 (viva 1,270/4,39), DAX OOS PF 1,550/DD 4,63 (viva 1,397/7,23).
  Prezzo: metà campione e profitto assoluto giù (−1.584€ Dow, −8.706€ DAX
  OOS). Onestà scritte: campione filtrato sub-150, un solo regime, NON è
  affiancabile (sottoinsieme dei trade → solo SOSTITUZIONE con firma).
  **G5: niente promosso, forward intatto.** Prossimo passo se Claudio vuole:
  prova di regime sul gemello volumi → firma di sostituzione.
- ❌ G3 ha ucciso `06_correlazione` (Dow peggio / DAX meglio — lo scenario
  R46); `05_supertrend3` e l'EMA sul DAX cadono per RIBALTONE IS/OOS
  (coerente sui due mercati → dipendenza da regime, lezione R98 doppia);
  `08_tondi` COSTA su entrambi; `03_atr` filtro NULLO al centesimo su
  entrambi; `09_corso_pieno` NON MISURABILE (n 26 e 28 < 30, previsto per
  iscritto). **01: la cella viva Dow esce CONFERMATA** (senza EMA H4 l'IS
  perde −2.274€).
- 🛠️ Il falso rosso della prima corsa = **checklist 64**; nella stessa serata
  il verificatore ha preso la **65** su R102 prima dell'invio. R102: righe
  DEFINITIVE al pin `7aa83fd`, PASS doppio, coda aperta ora che R101 è chiuso.

## 🧭 (storico) 23/08 notte (tardi) — R101: DOW letto, DAX fermato dal falso rosso (checklist 64), ripresa consegnata

- 📦 Zip della corsa arrivato (`R101_ABLAZIONE_CORSA_20260823_2159.zip`).
  **G0 DOW: RIPRODOTTO AL CENTESIMO** (PF 1.270 · DD 4.39 · n 130). Le 5 celle
  «SALTATA DAL DRIVER» (Dow 00–04, CSV del lancio precedente della stessa
  serata, stesso pin) **adjudicate VALIDE** nel referto.
- 🔴 **G0 DAX: falso rosso.** Metro riprodotto NEI FATTI (PF 1.397 vs 1.400,
  tolleranza firmata ±0,01; DD 7.23 esatto; gemelli identici) ma il driver
  l'ha bocciato confrontando n=270 col **sentinella `-1`**: argomento
  posizionale negativo → **stringa** `"-1"`, e `"stringa" -gt 0` è VERO su
  Windows PowerShell 5.1 (NLS: trattino ignorabile) e FALSO su pwsh/Linux del
  verificatore. **Prima classe di difetto che passa un'esecuzione reale del
  verificatore e cade solo sull'OS di destinazione** → `CHECKLIST 64`.
- 🛠️ Driver corretto (`[int]$n` tipizzato + cast nei confronti), commit
  `3c39326`. **I 9 gradini DAX vanno rigirati**: riga `-SoloEa DAX` dal
  verificatore, poi a Claudio.
- 📊 **Referto PARZIALE agli atti**: `risultati_archivio/R101_REFERTO.md`
  (tabella madre IS+OOS completa dai CSV, costo in € e op tolte per filtro).
  Letture Dow (INDIZI — G4 sospende il merito, n IS 74): **01_ema conferma la
  cella viva** (senza EMA l'IS perde −2.274€); **03_atr = filtro NULLO**
  (identico alla viva al centesimo: la soglia del corso non toglie UN trade);
  **02_volumi candidato Dow-side** (PF 1,543 · DD 2,83, aspetta G3);
  05_supertrend3 ribaltone IS/OOS (lezione R98); 06/08 COSTANO;
  **09_corso_pieno n=26 → NON MISURABILE, come scritto prima dei numeri**.
  Il DAX metro ha **n IS 175 ≥ 150**: sul DAX il merito si giudica.
- ✍️ **R102 FIRMATO da Claudio** ("FIRMO CON PROPOSTE", 23/08 sera): tutte e
  6 le decisioni risolte con le proposte. Registrazione + modifiche ai file
  prova (finestra 2009, pavimento dopo GATE 4) in corso; ripin + verificatore
  prima delle righe. **Resta in coda DOPO la chiusura di R101** (decisione 4).

## 🧭 AGGIORNAMENTO 23/08 notte — **R102 «LA CLASSIFICA LUNGA» È PRONTO, IN BOZZA E IN CODA**

- 🗣️ **Nasce da una domanda di Claudio in chat (23/08 sera)**: *"una classifica
  di guadagno su 100k con più anni… Breaking Band mi hai detto 133k ma con 10
  anni di storico avrebbe fatto lo stesso?"*
- 📦 **Consegnato, pin `fe86b4255d7f97d3dab0b2bde806d878590b97ee`**:
  - **20 file prova** `prove/R102_<ea>_<simbolo>_<magic>.txt`, generati dai
    sorgenti (`prove/R102_GENERA_PROVE.py` agli atti);
  - driver `righe/RIGA_R102_CLASSIFICA_LUNGA.ps1` (`MARCATORE_RIGA_R102_v1`) —
    è la macchina di **R100 generalizzata ai simboli diversi**;
  - criteri **IN BOZZA** `risultati_archivio/R102_CRITERI.md`;
  - `righe/RIGA_R102_DA_MANDARE.md` con le righe pinnate.
- 🛑 **DUE CANCELLI, e sono nel documento**: **(1)** i criteri **NON sono
  firmati** — ci sono **sei decisioni di Claudio**, e due cambiano cosa gira;
  **(2)** **R102 gira DOPO R101** (una macchina, un lavoro).
- 🪑 **PERIMETRO: 20 sedie forex/argento, 12 simboli.** Fuori gli **indici**
  (misurato: tutti a `2024.09.26`, verdetto `COMPLETO` = **il broker non ce
  l'ha**) e fuori l'**oro** (già fatto: R99 + R100, si cita).
- 🟢 **E una cosa buona**: il censimento `.chr` **del 23/08 15:49** esiste, e
  **tutte e venti** le sedie hanno il **rischio vivo MISURATO**. In R102 **non
  esiste il GRUPPO 2 di R100** (le sedie a taglia di riferimento).
- ⚖️ **La cornice è l'Emendamento regola B**: *il VECCHIO giudica il RISCHIO, il
  RECENTE il MERITO*. **R102 non promuove e non boccia niente**: produce una
  classifica di **[ROBUSTEZZA]** e una di **[RISCHIO]**, con l'etichetta
  stampata su ogni colonna. L'unica decisione meccanica resta il **`2x`** sul DD
  promesso.
- 🏆 **La classifica è ordinata sulla FINESTRA COMUNE `2009→2026`**, non sulle
  finestre lunghe: quelle hanno lunghezze diverse (GBPUSD 33 anni, XAGUSD 17,6)
  e ordinare su quelle darebbe **una classifica della profondità dello storico**.
- 🦴 **La risposta letterale alla domanda è la SPINA DORSALE ANNO PER ANNO**
  (anno · n · netto · cumulato), letta dai deal del report `.htm`.
- 🧨 **E un rilievo nuovo, misurato: il GATE 4 (DENSITÀ).** La sonda dà `EURUSD`
  e `USDJPY` dal **1971**, ma con **~6.800 barre D1 = ~26 anni**. **Non sono 55
  anni di storico: sono serie RADE e ricostruite** (l'euro esiste dal
  1999.01.04). Il gate conta gli anni solari a **zero operazioni** e obbliga il
  referto a dire gli anni **operati**, non quelli nominali.
- ⏳ **[STIMA] 6-16 ore di tester** (~2.280 anni-sedia contro gli ~886 di R100)
  **più** il collo di bottiglia vero: **lo scarico M1 di dodici simboli**, mai
  misurato. 👉 **Per questo si lancia A BLOCCHI** (`-SoloSedia C01,C02,C03`), e
  il **primo blocco è Breaking Band**.
- ✅ **Verificato eseguendo, prima dell'invio** (checklist 63): parse con `pwsh`
  **0 errori**; **20/20** file prova gatati; **7/7** marcatori di log provati sul
  campione **positivo e negativo**; `LeggiDeal` su due report finti (con e senza
  la colonna `Commento`); `DDPromesso` sul file vero → **18 estratti, 2 ambigui
  attesi** (le PTE GBPUSD, contratti scritti a due taglie).
- ⛔ **NON MISURABILE**: `BREAKOUT_EA_JPY_v3` USDJPY — **il sorgente non esiste
  nel repo**, e nel `.chr` del 23/08 la riga c'è ancora senza rischio leggibile.
  È il **rilievo del 18/08, ancora aperto**.

---

## 🏅 AGGIORNAMENTO 23/08 sera — **R100 È PRONTO AL LANCIO**: TUTTA la flotta ORO su 22 anni

- ✍️ **Ordinato da Claudio in chat**: *"FAI PARTIRE R99 SULLE ALTRE SEDIE ORO"*
  — **quell'ordine è la firma dell'estensione**, verbalizzata al §0 di
  `backtest_pipeline/risultati_archivio/R100_CRITERI.md`. I criteri sono quelli
  **firmati di R99**, estesi **INVARIATI** sedia per sedia. Era già previsto:
  lo scrive il referto R99 (*"è un round nuovo… ma ora la macchina esiste"*).
- 📦 **Consegnato, pin `9fbe18d`**:
  - **12 file prova** `prove/R100_<ea>_<magic>.txt`, **generati dai sorgenti**
    (`prove/R100_GENERA_PROVE.py` agli atti): EA diversi hanno input diversi;
  - driver `righe/RIGA_R100_ORO_FLOTTA.ps1` (`MARCATORE_RIGA_R100_v1`);
  - `righe/RIGA_R100_DA_MANDARE.md` con le **due righe** pinnate.
- 🪑 **IL CENSIMENTO, e la tensione MISURATA fra le fonti**: `FLOTTA_ATTIVA.md`
  (02/08) dice **12 grafici** sull'oro; il `.chr` più recente (**19/08 15:34**)
  ne censisce **5**; il censimento frequenza del 22/08 misura **ZERO trade** su
  quelle della squadra storica. Traduzione dichiarata, **due gruppi**:
  - 🟢 **GRUPPO 1 (3)** — rischio vivo **MISURATO**: `EMA200_Ottimizzato`
    971501 (DD promesso **4,4%**), `MaxMinNotte` 770402 (**5,3%**),
    `PunteLarry` 772343 (**3,5%**). ✅ **Qui il confronto `2x` è FINALMENTE
    calcolabile**: sono numeri, non aggettivi;
  - 🟡 **GRUPPO 2 (9)** — rischio vivo **non censito**: misurate a **1,00%
    dichiarato come taglia di riferimento**, il numero è un **DD-per-1%** e il
    verdetto resta **NON MISURABILE**. ⚠️ **Non è un via libera: è il rilievo.**
    **Prerequisito agli atti: serve un censimento `.chr` nuovo del VPS.**
  - ⛔ **NON MISURABILE (1)** — `Gold_Ichimoku` 250604: **non ha l'OPTFRAME**
    (misurato: 0 occorrenze di `OptResults` nel sorgente) → nessun DD. È
    **l'ultima sedia a contratto PARZIALE** della flotta.
  - 🧊 `SupertrendReversal_Ottimizzato` 970901 **si salta**: è R99, già fatta.
- 🔴 **NOVE SEDIE ORO SENZA NESSUN DD PROMESSO**: è lo stesso rilievo che era il
  vero risultato di R99, **moltiplicato per nove**.
- 🐛 **CORRETTO IL BUG DEL CRITERIO B DI R99** (anche in `RIGA_R99`, marcatore
  → **`v2`**, commit separato): il parser cercava `saldo`/`balance`, ma MT5 in
  italiano scrive **`Bilancio`** → tornava vuoto e il criterio B usciva
  **NON MISURATA** su una tabella leggibilissima. **Una parola mancante.** E un
  secondo difetto nascosto dal primo: la somma usava il solo `Profitto`, non
  **`Profitto+Commissioni+Swap`** — la peggior giornata usciva **migliore del
  vero**, cioè l'errore nella direzione comoda.
- 🧲 **Magic VERGINI `78xxxx`** (verificato: **zero occorrenze in tutto il
  repo**), schema `78SSNN`. Vietati e controllati **tutti** i magic vivi
  dell'oro, i `7799xx` di R99 e la collisione `770901`.
- 🎁 **Il prodotto finale è LA TABELLA MADRE** del referto: sedia · rischio ·
  DD promesso · DD 22 anni · `2x?` · peggior giornata · verdetto corsia
  RISCHIO. **È la fotografia del rischio di tutta la concentrazione oro.**
- 🔴 **Quello che R100 NON dirà**, e va ricordato leggendo la tabella: **il DD
  di PORTAFOGLIO dell'oro**. Dodici sedie sullo stesso simbolo non fanno la
  somma dei loro DD né il massimo: dipende dalla **sovrapposizione**. È **un
  round diverso**, ed è la **domanda successiva ovvia**.
- ⏭️ **Prossimo passo**: giro dal **verificatore** (in testa: **i `.ps1` non
  sono stati parsati**, qui non c'è PowerShell — sono stati controllati a mano
  per bilanciamento graffe/parentesi e here-string), poi le due righe a
  Claudio. 🚫 **Nessun backtest è stato eseguito qui.**

---

## 🥇 AGGIORNAMENTO 23/08 — **R99 È PRONTO AL LANCIO**: l'ORO su 22 anni, la misura del RISCHIO

- ✍️ **FIRMATO da Claudio in chat**: *"FIRMO R99, PARTIAMO CON L'ORO"*.
  Criteri: `backtest_pipeline/risultati_archivio/R99_CRITERI.md` — promossi
  **parola per parola** dall'header del file prova, a numeri mai visti.
- 🎯 **La domanda**: la sedia `ABTG_SupertrendReversal_Ottimizzato` XAUUSD H4
  ha un contratto firmato su **21 mesi**, e il broker sull'oro ha **22 anni**
  (`2004.06.11`, MISURATO dalla sonda del 17/08). Il DD promesso non ha mai
  visto né l'**ottobre 2008** né l'**aprile 2013**. **Emendamento regola B: il
  VECCHIO giudica il RISCHIO** — nessuna promozione, nessuna bocciatura.
- 📦 **Consegnato, pin `9ce568c`**:
  - file prova **completato** `prove/R99_ORO_22ANNI_RISCHIO.txt` (45 righe
    vive = 3 direttive + **42 input** della cella viva congelata);
  - driver `righe/RIGA_R99_ORO_RISCHIO.ps1` (`MARCATORE_RIGA_R99_v1`);
  - documento `righe/RIGA_R99_DA_MANDARE.md` con le **due righe** pinnate.
- 🧲 **Magic VERGINI `7799xx`** (`779910/11` intera, `779912` singola,
  `779920…779971` finestre): il magic vivo è `970901` e c'è la **collisione
  `770901`** misurata il 22/08 — **nessuno dei due viene toccato**.
- 🛠️ **Il fatto che comanda il disegno**: quell'EA **non esporta il
  per-trade**. Quindi DD e `n` escono dall'**OptResults** di due passate
  **gemelle**, la **prima operazione** da **due misure indipendenti** (log del
  tester + report `.htm`) e la **peggior giornata** dai **deal del report**.
- 🔴 **Il buco che si vedrà nel referto**: il **DD promesso NON È UN NUMERO**
  (contratto 🟡 PARZIALE, *"a referto solo «basso», mai quantificato"*), quindi
  il confronto **`2x` è NON CALCOLABILE** — e **non è un via libera**: è esso
  stesso un rilievo della corsia RISCHIO. Il criterio firmato **non è stato
  riaperto** (checklist 57: si dichiara la traduzione, in tre posti).
- ⏭️ **Prossimo passo**: giro dal **verificatore** (in testa: **il `.ps1` non è
  stato parsato**, qui non c'è PowerShell), poi le due righe a Claudio.
  🚫 **Nessun backtest è stato eseguito qui.**

---

## 🚀 AGGIORNAMENTO 22/08 notte — **R98 È PRONTO AL LANCIO** (criteri firmati ➜ riga eseguibile)

- ✍️ **Criteri FIRMATI**: `backtest_pipeline/risultati_archivio/R98_CRITERI.md`
  — **opzione A**: **PF OOS ≥ 1,20** + **cancello zero S0 sullo spread**.
- 📦 **Consegnato stanotte**, pin **`81d1314`**:
  - **8 file prova** in `backtest_pipeline/prove/`: `R98rif_nuda` (il paper
    letterale) + `R98a` (overnight off) + `R98b` (secondo segnale) + `R98c`
    (soglia 0,10%) + `R98d` (SL 3×ATR) + `R98e` (slippage 100 pt) **+ 2
    PASSATE DIAGNOSTICHE sui lati** (`R98diagNoLong`, `R98diagNoShort`), che
    **NON sono celle** e non entrano in nessun cancello (malattia R52);
  - **driver** `backtest_pipeline/righe/RIGA_R98_MOMENTUM_NASUSD.ps1`
    (marcatore `MARCATORE_RIGA_R98_v1`), meccanica del gemello R97 v2;
  - **documento da mandare** `backtest_pipeline/righe/RIGA_R98_DA_MANDARE.md`
    con le due righe (giro a vuoto + corsa vera) pinnate.
- 🧲 **Magic**: `772800/01` (nuda, = il magic dell'EA), poi `772820…772881`;
  **PASSO 0 su `772890/91`**, fuori dalla griglia (checklist 41).
- 🔴 **Il gate FATALE è l'autotest** (45 casi × 2 passate, zero `*** FAIL ***`,
  parser col controllo positivo). 🐤 **Il canarino NON blocca**: n IS/n OOS si
  misurano al PASSO 0 e, sotto 100 in IS, il **merito è sospeso** e si legge il
  **rischio** (regola B).
- ⚠️ **S0 è a metà per costruzione**: lo script misura il **risultato medio per
  operazione in punti indice** e stampa *"S0 superato se lo spread della fascia
  ≤ X punti indice"*; **lo spread NON è misurabile da PowerShell** e il referto
  scrive **S0 = DA MISURARE A MANO** con tre metodi. **Non è stato inventato
  nessun numero.**
- ⏭️ **Prossimo passo**: giro dal **verificatore**, poi le due righe a Claudio.
  🚫 **Nessun backtest è stato eseguito qui: non esistono MT5 né Strategy
  Tester in questo ambiente.**

---

## 🥇 AGGIORNAMENTO 22/08 (mql5-ea-developer) — NASDAQ, SECONDA CACCIA: scritto l'EA A1 "Market Intraday Momentum"

**Perche' esiste:** R97 ha bocciato l'ORB su NASUSD **0/4**
(`backtest_pipeline/risultati_archivio/R97_REFERTO.md`) e la lettura e' precisa —
le 4 celle avevano **gli stessi INGRESSI** e perdevano tutte in OOS, quindi il
problema non e' la geometria delle uscite. **Regola della seconda caccia (19/08):
meccanismo DIVERSO sulla stessa inefficienza.**

- 📦 **Consegnato:** `mql5/Experts/ABTG_IntradayMomentum.mq5` **v1.00**, magic
  **772800** (blocco 7728xx libero, verificato su tutto il repo; mai 770201, mai
  770611, mai 7797xx di R97).
- 🧭 **Il motore, tre righe:** r1 = rendimento della **prima mezz'ora** di cassa
  (**14:30-15:00 ORA SERVER**) → alle **20:30 server** si apre **nel verso di r1**
  → si chiude entro le **21:00 server**, sempre. **Zero overnight per
  costruzione**, un solo trade al giorno, 30 minuti di esposizione.
  Fonte: **Gao/Han/Li/Zhou**, scheda `report/SWEEP_MECCANISMI_LIBERI_2026-08-22.md`
  §A1 (9/10). **I numeri del paper sono [DICHIARATI, NON MISURATI DA NOI].**
- 🎯 **Scorrelazione ORARIA vera:** alle 20:30 server **non abbiamo nessuno** (le
  nostre aperture sparano alle 08:00 e alle 14:30).
- 🧪 **AUTOTEST: 45 casi** sul **nucleo puro** (le stesse funzioni che aprono gli
  ordini), stampe `[A1][AUTOTEST]` con atteso/ottenuto e `*** FAIL ***`.
- ✅ **COMPILATO ED ESEGUITO sul PC di Claudio la sera stessa (22/08, 23:04)**
  con la riga automatica `backtest_pipeline/verifica_autotest_a1.ps1`:
  compilazione **0 errori**, autotest **0 FAIL** (nucleo A1 + suite Guardian
  "TUTTI I CASI PASSATI"), referto in zip `verifica_a1_20260822_230424`.
  Il motore e' pronto per il round appena i criteri sono firmati.
  (Storia: prima della verifica la logica era stata provata solo trasposta
  in C++ — 44 casi verdi — che non era una compilazione MQL5.)
- 📄 **Criteri del round:** `backtest_pipeline/risultati_archivio/R98_CRITERI_BOZZA.md`
  — 🟡 **BOZZA NON FIRMATA**. Dentro c'e' **una decisione che aspetta Claudio**:
  PF OOS **1,40** (come R97, confrontabile) oppure **1,20** (questo motore non ha
  TP, il payoff e' simmetrico: 1,40 puo' essere l'unita' di misura sbagliata).
  **Si sceglie PRIMA dei numeri.**

---

## 📏 AGGIORNAMENTO 21/08 (mql5-ea-developer) — SONDA MEDIAZIONE: lo strumento c'e', il numero no

Claudio ha firmato il 21/08 (**"metro,frequenza, firmo r93, r94 lancia, e prepara jpy"**)
l'**opzione C** del nodo Mediazione: **solo un contatore di segnali**, nessun ordine,
nessun sizing, nessun forward, **nessun EA operativo**.

- 📦 **Consegnato:** `mql5/Scripts/ABTG_SondaMediazione.mq5` (**SCRIPT**, non EA: niente
  `OnTick`, niente `CTrade`, **nessun `#include`** — i due grep escono vuoti).
- 📐 **Conta PACCHETTI, mai ticket** (regola G2 congelata oggi): un pacchetto = **un
  segnale valido che ha messo ordini**, qualunque sia il numero di livelli riempiti
  (1..6). I livelli finiscono nell'**istogramma**, non nel conteggio.
- 🎯 **La domanda unica:** **>= 150 pacchetti in-sample?** Se **no**, il nodo si chiude
  da solo con un numero e **non serve scrivere nessun EA**.
- 🚀 **Riga di lancio pronta:** `backtest_pipeline/righe/RIGA_SONDA_MEDIAZIONE.md`
  (pin `13db8c9`) — PASSO 0 storico H1 dei 3 cross (MT5 chiuso), PASSO 1 installa+compila
  da riga di comando, PASSO 2 trascina lo script su un grafico, PASSO 3 raccolta con
  **ricontrollo del numero dal CSV** e zip sul Desktop.
- 📄 **Referto (cosa conta, come, 10 assunzioni numerate, cosa il numero NON dira'):**
  `backtest_pipeline/risultati_archivio/SONDA_MEDIAZIONE_FREQUENZA_2026-08-21.md`.
- 🔴 **Assunzione A1, dichiarata inventata da noi:** SuperTrend **ATR 10 / mult 3,0** —
  il corso non lo detta MAI e il `super trend.ex4` della lez. 10 non ce l'abbiamo (M15b).
  Se il conteggio finisse **vicino** a 150, quella richiesta diventa **bloccante**.
- ⛔ **Non compilato, non eseguito, zero numeri prodotti.** Il "MAI" del 12/08 sulla
  pratica di Emiliano **resta in vigore**: qui si misura un altro oggetto (lez. 26-33).

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
