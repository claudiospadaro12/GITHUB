# 🕘⚡ I 4 DOCUMENTI DELLE APERTURE — seconda lettura, con gli SCHERMI aperti

_23/08/2026. Fonte: i 4 file caricati da Claudio. Analista: agente trascrizioni/documenti.
Etichette di casa: **[DOC]** = c'è scritto, cito · **[MISURATO]** = l'ho letto io da uno
screenshot/immagine e l'aritmetica torna · **[INFERITO]** = deduzione, con i passaggi ·
**[INCERTO]** = non ricostruibile. I numeri dei relatori sono sempre
**[DICHIARATO DAL CORSO, NON MISURATO DA NOI]**._

---

# 🔴 PRIMA DI TUTTO: QUESTI 4 FILE SONO GIÀ IN CASA, IDENTICI AL BYTE

Verifica MD5 fatta prima di scrivere una riga:

| file caricato | MD5 | già nel repo come |
|---|---|---|
| `ABTGApertura_Mercati_20240507_2.pdf` | `fbea76fe…6190` | `corso_documenti_2026-08-18/ABTG-Apertura Mercati 20240507 (1).pdf` |
| `Piano_di_Trading_America_2.pptx` | `dbae8cb5…36bd` | `corso_documenti_2026-08-18/Piano di Trading America (1).pptx` |
| `Piano_di_Trading_America_Strategia_Nasdaq_2.pptx` | `6ecaa8df…81e5` | `…/Piano di Trading America Strategia Nasdaq (1).pptx` |
| `Piano_di_trading_Europeo_2.pptx` | `a73e2fa1…4d33` | `…/Piano di trading Europeo (1).pptx` |

**Quattro MD5 su quattro coincidono.** Sono gli stessi file già letti **due volte**:
il 02/08 (`docs/live_emiliano/ANALISI_SLIDE_APERTURE.md`, audit 11/21) e il 18/08 col
protocollo di rigore (`ANALISI_PIANI_APERTURA_2026-08-18.md` + spec
`backtest_pipeline/prove/PIANI_APERTURA_SPEC.md`: 83 decisioni censite, 75%
meccanizzabile, 15 controlli aritmetici, 6 contraddizioni, 12 assunzioni A1-A12).

**Non riscrivo quel lavoro.** Questo referto vale solo per ciò che aggiunge, ed è di tre
tipi — tutti e tre assenti dal 18/08:

1. 🖥️ **LE IMMAGINI.** Le letture precedenti erano **testo-only** (i pptx letti nei tag
   `<a:t>`, il PDF come testo). Le slide che dicono solo *"Schermata Operativa"* /
   *"Gestione operazione"* portano screenshot MT5 ad alta risoluzione **mai aperti**.
   Ci ho trovato: la **size divisa VERA (10+20 lotti, non 50/50)**, uno **stop loss in
   punti indice**, il **valore-punto**, lo **spread del Nasdaq**, e la **scala del
   %Custom** che il 18/08 era archiviata come "proprietario, fuori portata".
2. ⏰ **IL FUSO, MISURATO invece che assunto.** Il 18/08 la conversione IT−1 era applicata
   *per regola di casa*. Oggi l'ho **letta sull'orologio del terminale del corso**, che è
   **BCM**, il nostro stesso broker. §2.
3. ⚖️ **I VERDETTI MISURATI ARRIVATI DOPO IL 18/08** — R88, R95, R96, **R97 e R98 di ieri
   e stamattina**. Uno dei quattro documenti prescrive un motore che nel frattempo la casa
   ha **misurato morto a campione pieno**. §7.

---

# 1. 🎯 LA RIGA CHE CONTA

> Su 4 documenti (41 pagine + 53 slide): **47 parametri con valore** estratti (di cui
> **9 MISURATI dagli screenshot, mai visti prima**), **14 meccanismi**, **8 bandiere
> rosse**, **0 numeri di performance dichiarati**, **0 regole prop citate**.
> Il dato più solido è che **lo stop va all'estremo opposto**: converge in 2 documenti
> del corso *e* nella nostra misura R88 sul Dow (DD 9,76% → 3,84%, PF 1,674 → 1,84).
> Il dato più pesante in senso opposto: **il piano più meccanizzabile dei quattro
> (Nasdaq, 93%) prescrive il motore che ieri abbiamo bocciato 0/4 a campione pieno (R97)**.

---

# 2. ⏰ IL FUSO — non più assunto: MISURATO sull'orologio del corso

## 2.1 Il terminale del corso È BCM

Tutti gli screenshot dei 4 documenti mostrano simboli con suffisso **`.bcm`**:
`D30EUR.bcm`, `U30USD.bcm`, `SPXUSD.bcm`, `NASUSD.bcm`, `EURUSD.bcm`, `GBPNZD.bcm`,
`AUDCAD.bcm`, `GBPCAD.bcm` [MISURATO — barra delle finestre e barra delle schede,
PDF PAG 34-35, America SLIDE 10-12, Nasdaq SLIDE 11-12].
**Il corso gira sul nostro stesso broker.** È la stessa firma trovata stamattina nel PDF
Nightly (`ANALISI_NIGHTLY_PDF_2026-08-23.md` §1, PAG 11/16), qui **confermata su un
secondo documento indipendente**.

## 2.2 E l'orologio dice esattamente IT − 1

Due pagine del PDF portano una didascalia con l'ora **e** il grafico con l'orologio del
server. Le ho rese a 300 dpi e lette:

| pagina | didascalia (parole dell'autore) | ultimo dato sul grafico `D30EUR.bcm` | scarto |
|---|---|---|---|
| **PAG 34** | *"PRE-APERTURA MERCATO EUROPEI ORE **08:59**"* | asse M15 fino a **30 Dec 2024 07:30**, candele fino a ~07:45-08:00; crosshair `2024.12.30 6:30` | **−1 h** |
| **PAG 35** | *"APERTURA MERCATI EUROPEI **09:01**"* | asse fino a **30 Dec 2024 07:45**, candele fino a ~08:00 | **−1 h** |

✅ **[MISURATO] Server BCM = ora italiana − 1**, verificato sui grafici del corso, su una
data **INVERNALE** (30 dicembre 2024). La regola di casa (finora dichiarata "in questo
periodo dell'anno") regge **anche d'inverno**: il server accompagna il cambio d'ora
europeo. [INFERITO da due misure: questa invernale + le nostre estive]

🧮 **Il corollario che vale per gli `.ini`:** se il server si sposta con l'Europa, allora
`InpSessionHour` **non va toccato al cambio d'ora**, né sul DAX né sul Dow:

| evento | inverno | estate | ora server |
|---|---|---|---|
| Apertura DAX 09:00 locale | 09:00 CET = 08:00 UTC | 09:00 CEST = 07:00 UTC | **08:00 sempre** |
| Apertura NYSE 09:30 ET | 14:30 UTC | 13:30 UTC | **14:30 sempre** |

Combacia coi default in campo: `ABTG_DAX_Apertura_EU` → `SESSION_HOUR 8`;
`ABTG_Dow_Apertura_US` → `14:30`. ✅ **Le sedie vive sono tarate giuste, e ora è misurato.**

## 2.3 🚩 Ma la tabella di conversione del PDF sbaglia di un'ora — sul terminale dell'autore stesso

[PAG 10] pubblica la regola: *"CET **− 2 ore** = Orario del server del broker"*, con la
tabella `Apertura Euronext 07:00 UTC → 08:00 CET → **06:00 server**`.

- Regola del PDF applicata a BCM: apertura europea alle **07:00 server**.
- Orologio BCM misurato alle pagine 34-35 dello **stesso PDF**: apertura europea alle
  **08:00 server**.

🔴 **Il PDF si contraddice con i propri screenshot, e l'errore è di un'ora piena in
anticipo.** Chi impostasse un EA seguendo [PAG 10] su conto BCM armerebbe il DAX alle
07:00 server = 08:00 IT, **un'ora prima dell'apertura**, dentro il pre-market. È
esattamente l'incidente che la regola di casa sui fusi esiste per prevenire.
Il PDF però si salva da solo alla riga dopo: *"Verifica sempre sul tuo grafico se
l'apertura (es. del DAX) corrisponde davvero alle 09:00 CET"* [PAG 10] — **la verifica
batte la tabella**, e la verifica l'abbiamo fatta noi qui sopra.

## 2.4 La tabella completa delle conversioni (ogni orario dei 4 documenti)

| orario nel documento | fuso dichiarato? | **ora server BCM** | fonte |
|---|---|---|---|
| Pre-apertura EU 08:00-09:00 | ✅ IT [INFERITO dal contesto] | **07:00-08:00** | PDF PAG 15 |
| Checklist pre-apertura 08:30 | ✅ IT | **07:30** | PDF PAG 29, 32 |
| Apertura EU / DAX 09:00 | ✅ *"Ora Italiana"* | **08:00** ✅ MISURATO §2.2 | AM SLIDE 2, EU SLIDE 2, PDF PAG 8 |
| Fascia ideale DAX 09:00-11:00 CET | ✅ CET | **08:00-10:00** | PDF PAG 12 |
| Verifica Supertrend "post apertura ore 10:00" | 🟠 non dichiarato → [INFERITO] IT | **09:00** | EU SLIDE 25 |
| Apertura USA 15:30 | ✅ *"Ora Italiana"* | **14:30** | AM SLIDE 2, PDF PAG 8/21 |
| *"volatilità nei primi 15 minuti"* | ✅ (segue l'apertura) | **14:30-14:45** | AM SLIDE 2 |
| *"volatilità concentrata nei primi 5-15 minuti"* | ✅ | **14:30-14:45** | PDF PAG 22 |
| Dow *"ottimo tra le 15:30 e le 17:00"* | 🟠 [INFERITO] IT | **14:30-16:00** | PDF PAG 12 |
| Dow *"le 21.00 e le 22.00 alla chiusura"* | 🟠 [INFERITO] IT | **20:00-21:00** | PDF PAG 12 |
| Nikkei pre-apertura 08:00-09:00 CET | ✅ CET | **07:00-08:00** | PDF PAG 12 |
| Tabella orari mondiali | ✅ UTC | inverno = server; estate = server −1 | PDF PAG 9 |
| Colonna *"Server Broker"* [PAG 10] | ✅ ma **SBAGLIATA per BCM** | 🔴 **da ignorare** (§2.3) | PDF PAG 10 |
| Timestamp d'ordine `2024.03.07 14:41:37` | (colonna terminale = ora server) | **14:41 server = 15:41 IT** | AM SLIDE 11 [MISURATO] |

---

# 3. 🖥️ LE NOVE MISURE NUOVE — dagli screenshot mai aperti

Questa è la sezione che il 18/08 non poteva avere. Ogni riga: cosa si legge, dove, e
perché conta.

| # | misura | dove | valore | perché conta |
|---|---|---|---|---|
| **M1** | **Size divisa = 10 + 20 lotti (1:2)** | AM SLIDE 10, etichette d'ordine sul `D30EUR.bcm,M5`: `#61756700 buy 10.00` e `#61756747 buy **limit** 20.00` | 1ª tranche 10, 2ª tranche **20** | 🔴 **L'assunzione A4 del 18/08 ("50/50") È SBAGLIATA.** La tranche più grande è quella che si aggiunge **contro** di sé (limit sotto il prezzo). Vedi bandiera B1 |
| **M2** | **Stop loss reale sul DAX = 17,50 punti indice** | AM SLIDE 11, riga del terminale: `buy 10.00 d30eur.bcm 17810.70 · S/L 17793.20` | 17810,70 − 17793,20 = **17,50 pt** | 🥇 **Primo SL numerico dell'intero corpus.** I 26 slide del piano Europeo non dichiarano MAI uno stop; qui è a schermo |
| **M3** | **Valore punto = 1,00 per lotto** | AM SLIDE 11: `Prezzo 17823.00 · Profitto 123.00` con 10 lotti | (17823,00 − 17810,70) × 10 = 123,00 ✅ **l'aritmetica torna esatta** | Sblocca il calcolo del rischio: 10 lotti = 10 €/punto |
| **M4** | **Rischio della 1ª tranche ≈ 175 € ≈ 0,26% del conto** | M2 × M3; equity ≈ 68.577 (margine 3.562,14 × 1925,18%) | 17,50 × 10 = **175 €** | ✅ Il corso **in pratica** rischia molto meno del 2% che predica |
| **M5** | **Commissione 0,00 sugli indici** | AM SLIDE 11, colonna `Commissione` | 0.00 | Conferma [AM SLIDE 3]: *"gli indici … non hanno commissioni"* |
| **M6** | **Spread NASUSD = 200 punti MT5 = 2,0 punti indice** | Nasdaq SLIDE 11 e 12, riga di stato: `Spread 200` (due screenshot indipendenti) | 200 pt MT5 | 📌 Conversione 1 pt indice = 100 pt MT5 **misurata da noi in R97**: il costo del corso e il nostro coincidono |
| **M7** | **Nasdaq: OCO da 10 + 10 lotti** | Nasdaq SLIDE 11: `#6174119? buy stop 10.00` e `#617?172 sell 10.00` | **stessa size sui due lati** | ⚖️ Il piano Nasdaq **NON** divide la size: è simmetrico. Contraddice il piano America (M1) |
| **M8** | **%Custom = scala a passo 0,25%**, da 0,25% a **3,00%**, simmetrica sopra e sotto un'ancora orizzontale etichettata `%Custom` | AM SLIDE 10/11 (`U30USD.bcm,H1`: 0,25→3,00%), Nasdaq SLIDE 12 (`NASUSD.bcm,M15`: 0,25→2,25%) | passo **0,25%**, tetto **3,00%** | 🔓 Il 18/08 il %Custom era *"proprietario, fuori portata anche con assunzioni"*. **Ora la geometria si legge.** L'**ancora** però non è determinabile → [INCERTO], domanda D2 |
| **M9** | **Multipivot = pivot Classic-B + Fibonacci a più TF** | Nasdaq SLIDE 11/12: etichette `Classic-B`, `R1f/R2f/R3b/S1f/S3b/S4b/S5b`, `H4-H1L1T10-Res`, `H1-H1L1T0-Sup` | — | I livelli sono pivot classici + fibo, non magia. I numeri accanto (`R2f 14429`, `S3b 20557`) **non sono prezzi** → [INCERTO] |

> 🧾 **Onestà sulle misure:** M2/M3/M4 vengono da **una sola operazione a schermo**. Sono
> fatti su quel trade, **non statistiche**. M4 in particolare misura cosa ha fatto
> l'autore quel 7 marzo 2024, non cosa prescrive il piano (che dice 2%).

---

# 4. 📋 TUTTI I PARAMETRI CON VALORE — i 4 documenti in una tabella

Ogni riga: valore, fonte puntuale, etichetta. (Il censimento *narrativo* completo delle
83 decisioni sta nella spec del 18/08 — qui c'è **solo ciò che ha un numero**.)

### 4.1 Orari → §2.4 (14 voci, tutte convertite)

### 4.2 Indicatori e livelli

| parametro | valore | fonte | etichetta |
|---|---|---|---|
| Supertrend, 3 istanze | moltiplicatore **2,5 · 3,0 · 3,5** | EU SLIDE 4, AM SLIDE 4 | [DOC] convergente su 2 documenti |
| Supertrend, periodo ATR | ❌ **mai dichiarato** | — | 🔴 buco (assunzione A2 di casa: 10) |
| EMA | **200 · 100 · 89 · 14**, esponenziali, applicate al **close** | AM SLIDE 4, EU SLIDE 4, PDF PAG 16 | [DOC] convergente su 3 documenti |
| EMA usate come obiettivo | 1° target **EMA200 su M15**, 2° target **EMA14** | PDF PAG 33 | [DOC] |
| Timeframe | **D1 / H4 / H1 operativo / M15 gestione** | AM SLIDE 6, EU SLIDE 7, NAS SLIDE 6, PDF PAG 15-16 | [DOC] convergente su **4 documenti su 4** |
| Timeframe di trailing | **M1** | AM SLIDE 11 | [DOC] |
| Bande di Bollinger | su **M15**; parametri (periodi, dev.std) ❌ non dichiarati | EU SLIDE 21 | 🔴 buco |
| %Custom | passo **0,25%**, fino a **3,00%** | M8 | [MISURATO] |
| Numeri tondi | *"(17000-38000)"*, passo 1.000 sul Nasdaq | NAS SLIDE 15 | [DOC] |
| ATR | per calibrare SL; periodo ❌ non dichiarato | PDF PAG 14-16 | 🔴 buco |

### 4.3 Ingresso

| parametro | valore | fonte | etichetta |
|---|---|---|---|
| Nasdaq: livelli | max/min **candela H1 precedente** | NAS SLIDE 10 | [DOC] |
| Nasdaq: ordini | **BUY STOP** sopra i massimi · **SELL STOP** sotto i minimi | NAS SLIDE 10 | [DOC] |
| Nasdaq: size dei due lati | **10 + 10 lotti** (simmetrica) | M7 | [MISURATO] |
| America: size divisa | **10 (mercato) + 20 (limit su EMA14)** | M1, AM SLIDE 10 | [MISURATO] — 🚩 B1 |
| PDF: buffer di rottura | **5-10 punti** sopra/sotto la linea di breakout | PDF PAG 14 | 🚩 **unità non dichiarata** — B2 |
| PDF: momento d'ingresso | **dopo la CHIUSURA** della candela di rottura, *"non durante"* | PDF PAG 17 | [DOC] 🔴 contraddice NAS SLIDE 10 |
| PDF: gap minimo | *"gap significativo"* — ❌ nessuna soglia | PDF PAG 24, 30 | 🔴 buco |
| PDF: esempio gap Nasdaq | gap di **150 punti** (15.000 → 15.150) | PDF PAG 25 | [DOC] esempio, non regola |
| PDF: volumi di conferma | *"superiori alla media delle ultime candele"* — ❌ né media né soglia | PDF PAG 14, 17 | 🚩 B3 |
| PDF: ATR di conferma | *"ATR > media"* — ❌ né periodo né finestra | PDF PAG 14 | 🚩 B3 |
| PDF: candela di rottura | *"ampia, decisa, senza ombre ambigue"* — ❌ non quantificato | PDF PAG 17 | 🚩 B3 |
| Europeo: ingresso | **ordini pendenti sui livelli** tracciati la domenica | EU SLIDE 11, 19 | [DOC] discrezionale |
| Europeo: Supertrend | opero *"quando cambiano tutti e tre"* | EU SLIDE 23 | [DOC] |
| Europeo: conferma 10:00 | candela delle 10:00 che apre **dentro** il livello ST = trend sostenuto | EU SLIDE 25 | [DOC] |

### 4.4 Stop, target, gestione

| parametro | valore | fonte | etichetta |
|---|---|---|---|
| **SL Nasdaq** | **sui massimi/minimi precedenti = estremo OPPOSTO** | NAS SLIDE 11 | [DOC] ⭐ vedi §7.1 |
| **SL America** | *"lo stop lo metto sotto ai minimi"* | AM SLIDE 10 | [DOC] |
| **SL misurato sul DAX** | **17,50 punti indice** | M2 | [MISURATO] |
| SL PDF (notturno) | ATR · **5-10 punti** dalla linea · sotto il minimo della candela prec. | PDF PAG 14 | 🚩 B2 (tre ricette alternative, unità assente) |
| SL PDF (gap fill) | **sopra il massimo d'apertura** (esempio: 15.170) | PDF PAG 24-25 | [DOC] |
| SL PDF (esempio EU) | *"sotto il minimo di giornata **+ 5 pip**"* e *"buffer di sicurezza **(+3 pip)**"* — **su un INDICE** | PDF PAG 33 | 🚩 **B2**: "pip" su D30EUR non è definito |
| Parziale | **50%** (*"dimezzando"*) | NAS SLIDE 11, PDF PAG 18/28 | [DOC] |
| Break-even | stop in pari **dopo la parziale** | NAS SLIDE 11, AM SLIDE 11, PDF PAG 28, 33 | [DOC] convergente su 3 documenti |
| Trailing (metodo) | base della **candela precedente su M1** | AM SLIDE 11 | [DOC] |
| **Trailing (valore) valute** | **150 punti = 1,5 pip** | EU SLIDE 20 | [DOC] ✅ conversione dichiarata |
| **Trailing (valore) indici** | **410 punti = "4 punti indice"** | EU SLIDE 20 | 🟠 aritmetica: 410 pt = **4,1** pt indice (già segnalato 18/08) |
| TP | *"in divenire"*, su livelli/numeri tondi/%Custom | NAS SLIDE 11-12, EU SLIDE 19 | 🔴 nessuna regola chiusa |
| TP gap fill | **chiusura precedente** (target primario) | PDF PAG 24 | [DOC] ✅ l'unico TP chiuso del corpus |
| **RR minimo** | **1:1,5** (solo gap fill) | PDF PAG 24 | [DOC] |
| OCO | cancella il pendente non eseguito | NAS SLIDE 11 | [DOC] |
| Scadenza pendenti | ❌ mai dichiarata | — | 🔴 buco |
| Orario di chiusura forzata | ❌ **mai dichiarato in nessuno dei 4 documenti** | — | 🔴 buco (le nostre sedie chiudono a 17:30 server) |

### 4.5 Rischio e money management

| parametro | valore | fonte | etichetta |
|---|---|---|---|
| Rischio per operazione | **max 2%** | NAS SLIDE 14 | [DOC] |
| Rischio per operazione | **1-3%** | PDF PAG 27, 28 | [DOC] 🟠 contraddice il 2% |
| Rischio per operazione | **max 2%** | PDF PAG 24 (gap fill) | [DOC] |
| Rischio per operazione | **≤ 2-3%** | PDF PAG 30 (checklist) | [DOC] 🟠 |
| Esempio sizing | 10.000 € · 2% = 200 € · SL 40 pt · 5 €/pt → 1 contratto | PDF PAG 28 | 🚩 **formula scritta SBAGLIATA** (manca il valore-punto) — già trovata 18/08 |
| Rischio effettivamente a schermo | **≈ 0,26%** sulla 1ª tranche | M4 | [MISURATO] |
| Cap giornaliero / settimanale | ❌ **mai dichiarato** | — | 🔴 buco: nessuno dei 4 documenti ha un daily stop |
| Numero massimo di posizioni | ❌ mai dichiarato | — | 🔴 buco |
| Filtro news | *"notizie a 3 tori (rosso) … prima di ogni rilascio **vado a togliere tutto**"* — ❌ nessuna finestra in minuti | AM SLIDE 2, NAS SLIDE 3, PDF PAG 30 | [DOC] 🚩 B4 |
| Fonti calendario | ForexFactory.com · Investing.com | AM SLIDE 2, NAS SLIDE 3 | [DOC] |

### 4.6 Strumenti e correlazioni

| parametro | valore | fonte |
|---|---|---|
| Catena di correlazione | **225JPY → SPXUSD → D30EUR** | EU SLIDE 2, 18 |
| Indice guida USA | **SPXUSD** *"traina gli altri indici"* | AM SLIDE 9, EU SLIDE 17 |
| Comportamento sui livelli | D30EUR **risente** · U30USD *"può violare leggermente ma li ritesta"* · SPXUSD **risente** | EU SLIDE 17 |
| Simboli operativi | `US30USD` `NASUSD` `SPXUSD` `D30EUR` (a schermo: `.bcm`) | AM SLIDE 3, NAS SLIDE 4 |
| Colori dei livelli | Monthly **azzurro** · Weekly **arancione** · Daily **verde** | EU SLIDE 9 |
| Tecnica dei livelli | **Larry Williams** su D1/W1/M, tracciati **la domenica** | EU SLIDE 9 |

---

# 5. 📇 LE QUATTRO SCHEDE

## 📄 SCHEDA 1 — `ABTGApertura_Mercati_20240507_2.pdf` (41 pagine)

**RELATORE/CANALE** Alfio Bardolla Training Group SpA, *«La Magia delle Aperture Europee
e Americane»*, `Realise 07.05.2025` [PAG 1]. Autore individuale non dichiarato.
**OGGETTO** Quattro strategie in un solo documento: **breakout notturno** [PAG 14],
**breakout classico d'apertura** [PAG 17], **gap fill** [PAG 24-25], più il blocco
**gestione/rischio/checklist** [PAG 18, 27-30] e un **esempio multi-timeframe** sul DAX
[PAG 32-35].

**PARAMETRI CON VALORE** → §4 (il PDF è la fonte di: buffer 5-10 punti, gap 150 punti
d'esempio, RR 1:1,5, rischio 1-3%, EMA 200/100/89/14, target EMA200 M15 / EMA14, SL
+5 pip / +3 pip, tabella orari UTC).

**MECCANISMI**
- Breakout del **range notturno** (max/min sessione asiatica) con conferma volumi+ATR.
- Breakout **d'apertura** su S/R di D1/W1/M, pivot, max/min del giorno precedente, con
  ingresso **alla chiusura** della candela di rottura.
- **Gap fill**: si opera il ritorno verso la chiusura precedente, **solo se confermato**
  (price action contraria + volumi crescenti).
- Gestione **a due fasi**: parziale sull'impulso, resto in trailing.
- **Checklist a 5+5 voci** [PAG 29-30] con la regola d'oro:
  *"se anche solo un punto è 'NO'… forse è meglio aspettare"*.

**REGOLE PROP CITATE** ❌ **nessuna.** La parola "prop" non compare nel documento.

**NUMERI DI PERFORMANCE** ❌ **nessuno.** Zero win rate, zero rendimenti, zero screenshot
di conto. ✅ **Va a merito del documento** (stessa condotta del PDF Nightly).
L'unico esempio numerico [PAG 25] è dichiaratamente uno **scenario didattico**.

**BANDIERE ROSSE** B2 (5-10 punti / +5 pip senza unità), B3 (volumi/ATR/candela senza
soglia), B5 (*"trasformi il trade da rischioso a senza rischio"* [PAG 27]),
B6 (chiusura che cambia da 14.800 a 15.000 nella stessa pagina [PAG 25]),
B7 (formula di sizing senza valore-punto [PAG 28]), B8 (fuso [PAG 10], §2.3).

**COSA C'ERA A SCHERMO E NON NEL TESTO**
- [PAG 32/34/35] i sei grafici dell'esempio multi-timeframe: ho letto simboli e orologio
  (§2.2), **ma i pannelli dei Supertrend e delle EMA non sono leggibili** alla risoluzione
  del PDF → i **parametri esatti degli indicatori restano ignoti**.
- [PAG 25] la figura del gap fill è un disegno, non uno screenshot: nessun dato reale.

**COSA NE COPIAMO** Il **gap fill con RR 1:1,5 e TP = chiusura precedente** è l'unica
strategia con geometria chiusa del PDF, ed è **già nel nostro core**
(`InpGapMinRR = 1.5` con commento `// PDF: 1:1.5` in `ABTG_DAX_Apertura_EU.mq5`).
Nient'altro di nuovo.

---

## 📄 SCHEDA 2 — `Piano_di_trading_Europeo_2.pptx` (26 slide)

**RELATORE** *Forex Trading Diary — **Emiliano Monza*** [SLIDE 1]. ⚠️ **Stesso autore
della live del 17/07** già agli atti: **NON è una fonte indipendente** dagli altri
materiali "Emiliano" del repo.
**OGGETTO** Apertura europea sul **D30EUR**, impianto a **livelli pre-tracciati** +
**Supertrend ×3** + correlazione 225JPY/SPXUSD. **Non è un ORB.**

**PARAMETRI CON VALORE** ST 2,5/3,0/3,5 · EMA 89/100/200/14 · TF M15-H1-H4-D1 ·
trailing **150 punti = 1,5 pip** (valute) e **410 punti = "4 punti indice"** ·
Bollinger su M15 · colori M/W/D · verifica alle 10:00 IT (= 09:00 server).

**MECCANISMI** Livelli **Larry Williams** tracciati la domenica su D1/W1/M → rottura dei
massimi mensili → conferma sul weekly con *"Breakin Breakout PTE"* → pattern di candela
sul daily → ordini **pendenti** sui livelli a favore di trend → gestione: struttura viva
finché non rompe i minimi precedenti, trailing, Supertrend su TF bassi.
Trigger di trend: *"quando cambiano tutti e tre [i Supertrend], posso entrare"* [SLIDE 23].
Trigger di ritracciamento: Fibonacci / Bollinger / livelli %Custom [SLIDE 24].

**REGOLE PROP CITATE** ❌ nessuna. **NUMERI DI PERFORMANCE** ❌ nessuno.

**BANDIERE ROSSE**
🔴 **La più grave di tutto il corpus: 26 slide, ZERO stop loss e ZERO size.** Il piano
più discorsivo è anche quello senza money management. Un piano d'ingresso senza uscita
non è una strategia, è un'opinione.
🚩 B4 (nessuna finestra news). 🚩 Il *"take profit è in divenire"* [SLIDE 19] = nessun
target definito.

**COSA C'ERA A SCHERMO E NON NEL TESTO**
Le slide **3, 5, 6, 8, 12, 13, 16, 22, 26** hanno testo minimo o nullo e portano solo
immagini: *"ELEMENTI DA TENERE NEL GRAFICO"*, *"SCHERMATA OPERATIVA"*, *"Se non ho
livelli?"*, *"Quale strumento lavorare?"*. Le ho aperte: sono **screenshot di grafici
senza pannelli di parametri leggibili** → nessuna estrazione ulteriore. **Non c'è nulla
da chiedere a Claudio qui: le immagini ci sono già e non contengono numeri.**

**COSA NE COPIAMO** ❌ **Niente di nuovo.** L'impianto (livelli + ST×3) è già censito come
divergenza d'impianto n°20 del 18/08: la nostra sedia `ABTG_DAX_Apertura_EU` fa un ORB
che **questo piano non prescrive**, e vive sul proprio merito misurato (R16/R46), non
sulla fedeltà a queste slide. `InpUseSupertrend3` esiste già nel codice, spento.

---

## 📄 SCHEDA 3 — `Piano_di_Trading_America_2.pptx` (12 slide)

**RELATORE** non dichiarato in copertina; grammatica, indicatori e terminale identici al
piano Europeo → [INFERITO] **stessa scuola, probabilmente stesso autore**.
**OGGETTO** Apertura americana (15:30 IT = **14:30 server**) sugli indici USA, con
**operatività anche sul DAX** in correlazione.

**PARAMETRI CON VALORE** Apertura EU 09:00 / USA 15:30 *"Ora Italiana"* [SLIDE 2] —
✅ **l'unico documento che dichiara il fuso esplicitamente** · *"sfruttiamo la volatilità
nei **primi 15 minuti**"* [SLIDE 2] · ST 2,5/3,0/3,5 · EMA 200/100/89/14 ·
TF D1/H4/H1/M15 · trailing su **M1** sulla base della candela precedente [SLIDE 11] ·
**M1-M5 dagli screenshot**: 10+20 lotti, SL 17,50 pt, valore punto 1,00, rischio 0,26%,
commissione 0.

**MECCANISMI**
1. **Routine news**: controllo ForexFactory/Investing, *"prima di ogni rilascio di un dato
   a 3 tori vado a togliere tutto"* [SLIDE 2] — riguarda **anche i pendenti**.
2. **Correlazione**: SPXUSD guida; si verifica *"per capire se lasciar correre
   l'operazione o ridurre"* [SLIDE 10].
3. **Size divisa** [SLIDE 10]: *"Tradando la rottura dei massimi o dei minimi, scendo di
   time frame. **Non entriamo subito a mercato, ma divido la size**: sui massimi … e sulla
   media a 14 periodi, **per entrare ad un prezzo migliore**. **Lo stop, lo metto sotto ai
   minimi**"*.
4. **Gestione in tre tempi** [SLIDE 11-12]: scendo di TF e stringo lo stop → chiudo metà e
   porto lo stop in pari → M1, stop alla base della candela precedente → *"stop profit
   dove guadagnerò **senza avere rischi**"* → *"sarà il mercato a decidere quando
   chiudere"*.

**REGOLE PROP CITATE** ❌ nessuna. **NUMERI DI PERFORMANCE** ❌ nessuno.

**BANDIERE ROSSE**
🚩 **B1 — LA PIÙ IMPORTANTE DEL REFERTO.** La size divisa **10 + 20 lotti con stop unico**
(M1 + AM SLIDE 10) è **mediazione**: la tranche doppia entra a un prezzo peggiore, mentre
il mercato va contro. Con SL comune il rischio del ciclo **non è quello della prima
tranche**: è la somma. Con i numeri a schermo, il ciclo completo pesa **≈ 2,5 volte** la
prima tranche (175 € + ~256 € se il limit riempie a ~17.806 [il prezzo esatto del limit è
[INCERTO]]). **Un "1R" apparente che vale 2,5R.**
🚩 B5 — *"guadagnerò **senza avere rischi**"* [SLIDE 11]: falso. Stop in pari ≠ rischio
zero (gap, slippage, weekend). Il corso ripete la promessa in [PDF PAG 27].
🚩 B4 — filtro news senza finestra temporale.

**COSA C'ERA A SCHERMO E NON NEL TESTO** ✅ **Aperto tutto** (slide 7-12): §3, misure
M1-M5. Restano illeggibili solo i **pannelli di configurazione** degli indicatori
(Supertrend/Multipivot): mai aperti nemmeno dall'autore.

**COSA NE COPIAMO** 🟠 **Una voce sola, e come SPEC, non come proposta**: se un giorno si
misurasse la size divisa, va misurata **1:2 (M1)**, non 50/50 (A4 del 18/08 è **da
correggere**). Ma vedi il verdetto §8: sulla mediazione la casa ha già una posizione.

---

## 📄 SCHEDA 4 — `Piano_di_Trading_America_Strategia_Nasdaq_2.pptx` (15 slide)

**RELATORE** non dichiarato. **OGGETTO** **Breakout d'apertura sul NASUSD** con ordini
stop sui livelli della candela **H1** precedente. Il 18/08 misurato come **il piano più
meccanizzabile dei quattro: 93%** — *"quasi un EA già scritto"*.

**PARAMETRI CON VALORE** TF D1/H4/H1/M15 [SLIDE 6] · livelli = **candela H1 precedente**
[SLIDE 10] · **BUY STOP / SELL STOP** [SLIDE 10] · SL = **massimi/minimi precedenti**
(estremo opposto) [SLIDE 11] · parziale **"dimezzando"** [SLIDE 11] · BE dopo la parziale
[SLIDE 11] · 1° obiettivo = **numero tondo + %Custom** [SLIDE 12] · numeri tondi
*"17000-38000"* [SLIDE 15] · **rischio max 2%** [SLIDE 14] · **10 + 10 lotti** e
**spread 200** [M6, M7].

**MECCANISMI** Tesi dichiarata: *"L'indice Nasdaq si presta alla strategia della rottura
dei minimi e dei massimi in apertura, **grazie alla sua direzionalità**"* [SLIDE 9].
OCO: eseguito uno, si cancella l'altro [SLIDE 11]. Se il setup non si configura:
*"Verifico se in preapertura non è stato invalidato il setup. Se non ho il setup, **cambio
strumento**"* [SLIDE 13] — ⚠️ *"invalidato"* non è mai definito → [INCERTO].
Money management [SLIDE 14]: **"NON PERDERE!!!"**, max 2%, disciplina, *"trend is your
friend"*. Psicologia [SLIDE 15]: panic selling e numeri tondi come livelli obiettivo.

**REGOLE PROP CITATE** ❌ nessuna. **NUMERI DI PERFORMANCE** ❌ nessuno.

**BANDIERE ROSSE** 🚩 B4 (news senza finestra) · 🚩 *"cambio strumento"* senza criterio =
porta aperta al **cherry-picking** discrezionale · 🚩 il 2% con **nessun cap giornaliero**.

**COSA C'ERA A SCHERMO E NON NEL TESTO** ✅ Aperte le slide 11-12: M6, M7, M8, M9.

**COSA NE COPIAMO** 🔴 **NIENTE — e non per pigrizia: per misura.** Vedi §7.2: questo
motore, su questo simbolo, **è morto misurato in casa nostra**, ieri.

---

# 6. 🔗 SINTESI INCROCIATA — cosa converge e cosa si smentisce DENTRO il corso

## 6.1 ⚠️ Prima: i 4 documenti NON sono 4 fonti indipendenti

Il piano Europeo è firmato **Emiliano Monza**; America e Nasdaq non hanno firma ma
condividono **lo stesso terminale** (stesse schede aperte: `U30USD.bcm,M15`,
`GBPNZD.bcm,M15`, `AUDCAD.bcm,H1`…), **gli stessi indicatori proprietari** (Qqin
Multipivot, %Custom, Supertrend ×3) e **la stessa grammatica**. Il PDF è materiale ABTG
istituzionale che **riassume gli stessi impianti**.
👉 **Per la regola della convergenza valgono come 1-2 fonti, non 4.** Un valore ripetuto
in tre documenti della stessa scuola è **un valore ripetuto**, non tre conferme.

## 6.2 ✅ I valori convergenti

| parametro | Europeo | America | Nasdaq | PDF | convergenza |
|---|---|---|---|---|---|
| TF D1/H4/H1/M15 | ✅ | ✅ | ✅ | ✅ | **4/4** (ma vedi §6.1) |
| EMA 200/100/89/14 close | ✅ | ✅ | — | ✅ (PAG 16) | **3/4** |
| Supertrend ×3 = 2,5/3,0/3,5 | ✅ | ✅ | — | — | **2/4** |
| Parziale 50% + stop in pari | — | ✅ | ✅ | ✅ | **3/4** |
| Filtro news "3 tori, tolgo tutto" | — | ✅ | ✅ | ✅ (PAG 30) | **3/4** |
| **SL all'estremo opposto** | — | ✅ (*"sotto ai minimi"*) | ✅ (*"sui massimi precedenti"*) | ❌ **dice il contrario** | **2/4 + smentita** |
| Rischio max 2% | ❌ assente | ❌ assente | ✅ | 🟠 "1-3%" | **1 valore netto su 4** |
| Trailing su TF basso | ✅ (TF inferiori) | ✅ (M1) | — | ✅ (trailing generico) | **3/4** |
| Correlazione SPX guida | ✅ | ✅ | — | ✅ (PAG 21) | **3/4** |
| Apertura 09:00 / 15:30 IT | ✅ | ✅ (fuso dichiarato) | — | ✅ | **3/4** |

## 6.3 ⚔️ Le contraddizioni interne al corso

| # | contraddizione | dove | peso |
|---|---|---|---|
| **C1** | **Ingresso: ordini STOP (durante la rottura) vs ingresso DOPO la chiusura della candela** | NAS SLIDE 10 ⟷ PDF PAG 17 (*"non durante"*) | 🔴 **due strategie diverse.** Già segnalata 18/08 |
| **C2** | **Stop: estremo opposto (lontano) vs 5-10 punti dalla rottura (vicino)** | NAS SLIDE 11 / AM SLIDE 10 ⟷ PDF PAG 14 | 🔴 su un indice la differenza è di un ordine di grandezza. **Ed è la contraddizione che R88 e R97 hanno arbitrato: §7.1** |
| **C3** | **Size: divisa 1:2 (America) vs simmetrica 10+10 (Nasdaq)** | M1 ⟷ M7 | 🔴 **NUOVA, dagli screenshot.** Due money management incompatibili nella stessa cartella |
| **C4** | Rischio 2% ⟷ 1-3% ⟷ ≤2-3% ⟷ **0,26% praticato** | NAS 14 / PAG 27-28 / PAG 30 / M4 | 🟠 il praticato è **8 volte più prudente** del predicato |
| **C5** | **Fuso: la tabella [PAG 10] contraddice gli screenshot [PAG 34-35] dello stesso PDF** | §2.3 | 🔴 **NUOVA, misurata.** Un'ora piena |
| **C6** | Chiusura Nasdaq 14.800 ⟷ 15.000 nella stessa pagina | PAG 25 | 🔴 già trovata 18/08 |
| **C7** | Dow *"più volatile"* [PAG 8] ⟷ *"struttura più regolare"* [PAG 12] ⟷ *"correlazione più ordinata"* [PAG 21] | PDF | 🟠 caratterizzazioni non conciliate |
| **C8** | DAX *"ideale per strategie di breakout"* [PAG 8] ⟷ il piano Europeo **non prescrive nessun breakout** | PDF ⟷ EU | 🟠 già segnalata 18/08 |

---

# 7. 🏠 IL CONFRONTO CON LA CASA — regola per regola, coi verdetti MISURATI

## 7.1 ⭐ Dove il corso ha RAGIONE, e lo sappiamo perché l'abbiamo misurato

**Lo stop all'estremo opposto (C2, il lato "Nasdaq/America" della contraddizione)
è il lato giusto — sul Dow.**

> **R88** (`REFERTO_ROUND88_ORB_MIGLIORAMENTO.md`, notte 19→20/08, U30USD, tick reali):
> *"Le sei celle migliori per PF sono **tutte `InpSLMode=0` (OPPRANGE = stop all'estremo
> opposto del range, quello che prescrive il corso)**"*.
> Numeri: DD OOS **9,76% → 3,84-5,87%**, PF OOS **1,674 → 1,84**.

✅ È la **convergenza più forte** del referto: una prescrizione del corso [NAS SLIDE 11],
ripetuta nel piano America [SLIDE 10], **confermata da una nostra misura indipendente a
tick reali**. Ed è anche l'arbitrato di C2: **il PDF (5-10 punti dalla rottura) ha torto,
le slide hanno ragione.**
⚠️ Con la clausola di R88: *"nessuna cella supera tutti e quattro i cancelli firmati …
n IS = 71, molto sotto 150 → giudizio di MERITO sospeso"*. Quindi: **fatto sul rischio,
indizio sul merito.**

## 7.2 🔴 Dove il corso è già stato MISURATO E BOCCIATO in casa nostra

### Il piano Nasdaq: il motore è morto, con campione pieno, ieri

Il piano [NAS SLIDE 9-10] prescrive **rottura dei massimi/minimi in apertura sul Nasdaq
con ordini stop**. In casa questo motore è stato misurato **tre volte**:

| misura | cosa ha girato | esito |
|---|---|---|
| **`ABTG_Nasdaq_Apertura_US` (770201)** — la geometria LETTERALE del piano (`RANGE_MODE=2`, `LEVEL_TF=H1`) | forward + backtest | 🔴 **SENZA CONTRATTO**: PF **0,82** a tick reali, **19/20 celle OOS negative** (censimento `report/CONTRATTI_SEDIE.md`, dossier 18/08 §1) |
| **R97** (22/08, tick reali, pin `85874e5`) — ORB sul NASUSD, **incluso lo stop OPPRANGE che il piano prescrive** | 4 celle | 🔴 **0/4.** *"in OOS il motore PERDE, in ogni geometria provata"* · PF OOS 0,84-0,91 · n OOS **135** |
| **R98** (23/08 mattina) — meccanismo alternativo (intraday momentum) sullo stesso simbolo | 6 celle | 🔴 **0/6**, cancello zero S0 **matematicamente impossibile** (−0,31 punti indice per operazione, 410 operazioni) |

> Citazione dal referto R97: *"il problema NON è la geometria dell'uscita: sono gli
> INGRESSI … nella finestra recente gli ingressi del breakout d'apertura sul Nasdaq non
> hanno edge"*. E da R98: *"**La seconda caccia sul NASUSD si chiude qui**"*.

🔴 **VERDETTO SENZA SCONTI: il documento più meccanizzabile dei quattro (93%) descrive il
motore che abbiamo appena dichiarato morto sul suo stesso simbolo.** Il fatto che sia
"quasi un EA già scritto" **non è un argomento a favore**: è la ragione per cui l'abbiamo
potuto misurare bene, e la misura dice no.
🚫 **E il capitolo NON si riapre.** La regola della seconda caccia (19/08) vieta
"parametri diversi dello stesso motore morto", e R98 ha già speso il tentativo di
meccanismo alternativo. Questo referto **non propone nulla sul Nasdaq**.

### Gli estremi del range: chiuso definitivamente, e tocca il piano Europeo e il PDF

Il PDF [PAG 14] e il piano Europeo [SLIDE 24] invitano a lavorare **gli estremi** (rottura
del range notturno; ritracciamento su Fibonacci/Bollinger/%Custom agli estremi).

> **R7 / 02.08 / R25** (breakout) + **R42** (fade, **0/48** — *"la bocciatura più netta
> della storia dell'imbuto"*) + **R43** (rimbalzo ORL/ORH, **2/64 celle verdi, entrambe
> ribaltate fuori campione**) → dal DIARIO: *"il capitolo **estremi del range di apertura
> CHIUDE DEFINITIVAMENTE** … su quegli estremi non c'è edge in nessuna direzione e su
> nessun lato — **paga solo il RETEST**"*.

✅ **E la casa ha già agito di conseguenza**: `ABTG_DAX_Apertura_EU` gira con
`InpEntryMode = ABTG_RETEST` (commento nel sorgente: *"06/08: era BREAKOUT. Unico motore
in utile fuori campione con campione vero (+392,96 · PF 1,065 · 244 trade)"*) e
`InpRetestOffsetPts = 200`. **Il retest è una regola di casa MISURATA che nei 4 documenti
non compare mai.** Su questo punto **noi siamo avanti al corso**.

### L'apertura USA come costruttore di segnale: R96

> **R96** (23/08): CrossEma d'apertura su U30USD e NASUSD → **BOCCIATO**, DD 29-35%.
> *"conferma per contrasto che l'edge del Dow sta **NELLA rottura del range**, non negli
> incroci di medie dentro la sessione"*.

👉 Tocca il corso di striscio ma in modo utile: le **EMA 200/100/89/14** dei documenti
sono **contesto**, non segnale. Chi le usasse come grilletto d'ingresso ha una misura
contraria in casa.

## 7.3 📊 Cosa il corso dice che GIÀ FACCIAMO

| regola del corso | in casa | stato |
|---|---|---|
| Apertura EU alle 09:00 IT | `ABTG_DEF_SESSION_HOUR 8` + commento *"09:00 IT = 08:00 server BCM"* | ✅ **e ora è MISURATO** (§2.2) |
| Apertura USA alle 15:30 IT | Dow: `14:30` server | ✅ idem |
| *"primi 15 minuti"* | Dow: `RANGE_MIN 15` ✅ · DAX: **35** 🟠 | divergenza **misurata** 06/08 (8/8 celle in utile con 35-45, 0/12 sotto) |
| Livelli = candela H1 precedente | `RANGE_MODE=2` + `LEVEL_TF=H1` | ✅ esiste (usato dalla sedia Nasdaq, senza contratto) |
| SL all'estremo opposto | `ABTG_ORB`: `InpSLMode = ORB_SL_OPPRANGE` (default) | ✅ **ed è il vincitore di R88** |
| OCO, cancella il non eseguito | ✅ nel core | ✅ |
| Parziale 50% + BE | `InpTP1_ClosePct 50` · `InpBreakeven true` | ✅ |
| Trailing base-candela | `TRAIL_MODE=1` / `InpUseTrailEMA` | ✅ (in campo vince la base-candela sui 410 fissi, test 05/08) |
| Trailing 410 punti | `InpTrailFixedPts=410` | ✅ esiste, non usato |
| Numeri tondi come target | `InpUseRoundLevels` + `InpRoundStep=100` | ✅ |
| Gap fill RR 1:1,5 | `InpGapMinRR = 1.5` (commento: *"PDF: 1:1.5"*), `InpGapMinPoints 150` | ✅ **già scritto da questo PDF** |
| Volumi ≥ 1,5× media(20) | `InpUseVolumeFilter`, `InpVolMult 1.5`, `InpVolAvgBars 20` | ✅ implementato, **spento** |
| Supertrend ×3 concordi | `InpUseSupertrend3` | ✅ implementato, **spento** |
| Correlazione con SPXUSD | `InpUseCorrelation`, `InpCorrSymbol "SPXUSD"` | 🟠 **un solo** simbolo guida: la **catena 225JPY→SPX→DAX** non è mai stata scritta |
| Filtro news 3 tori | `InpUseNewsFilter` | ✅ implementato, **spento** (e non backtestabile: `CalendarValueHistory` non gira nel tester) |
| Rischio 2% | in campo **0,65-1,0%** | 🔴 divergenza **dichiarata e firmata** (18/08: cap rischio aperto 3,25%) |

## 7.4 ❌ Cosa il corso dice che NON abbiamo MAI implementato

1. **Size divisa** [AM SLIDE 10] — e ora sappiamo che è **1:2 (M1)**, non 50/50.
   Vedi §8 per il verdetto.
2. **Catena di correlazione a due anelli** 225JPY → SPXUSD → D30EUR [EU SLIDE 2/18].
3. **%Custom come griglia di target** — con M8 diventa **descrivibile** (passo 0,25% fino
   a 3,00%) ma **non implementabile** finché l'ancora è ignota (D2).
4. **Livelli Larry Williams tracciati la domenica** su D1/W1/M [EU SLIDE 9] —
   `ABTG_PunteLarry` esiste ma è un'altra famiglia.
5. **Bande di Bollinger su M15 con ingresso fuori banda e target sulla mediana**
   [EU SLIDE 21] — nessun EA di casa lo fa.
6. **La checklist come cancello duro** [PDF PAG 29-30]: *"se anche solo un punto è NO,
   meglio aspettare"*. Le nostre sedie hanno i filtri **spenti** → di fatto operiamo lo
   **scheletro nudo**, non il metodo del corso. **È il debito aperto del 18/08 (§1.2 del
   dossier), e a oggi resta aperto.**

---

# 8. 🚩 LE BANDIERE ROSSE — otto, con la citazione che le prova

| # | bandiera | citazione | classe |
|---|---|---|---|
| **B1** | **Mediazione travestita da size management: 10 + 20 lotti, stop unico** | *"Non entriamo subito a mercato, ma divido la size … per entrare ad un prezzo migliore. Lo stop, lo metto sotto ai minimi"* [AM SLIDE 10] + M1 | 🔴 **rischio ≈2,5R venduto come 1R.** La casa ha già una posizione sulla mediazione (`ANALISI_CORSO_MEDIAZIONE_2026-08-18.md`: *"inciampa nella bandiera n.1 del setaccio"*) |
| **B2** | **Soglie senza unità di misura** | *"5-10 **punti** sotto/sopra la linea di breakout"* [PAG 14] · *"sotto il minimo di giornata **+ 5 pip**"* e *"buffer di sicurezza **(+3 pip)**"* su **D30EUR** [PAG 33] | 🔴 **classe "QB 45".** Su BCM 1 punto indice = **100 punti MT5**: chi scrive `InpBufferPoints=5` mette un buffer **100 volte più piccolo** del voluto. E "pip" su un indice **non esiste** |
| **B3** | **Filtri senza soglia né finestra** | *"volumi superiori alla media delle ultime candele"* [PAG 17] · *"ATR > media"* [PAG 14] · *"candela ampia, decisa, senza ombre ambigue"* [PAG 17] · *"gap significativo"* [PAG 30] | 🟠 non falsificabili come scritti: **ogni implementazione inventa i numeri** (i nostri 1,5×/20 barre sono NOSTRI, non del corso) |
| **B4** | **Filtro news senza finestra temporale** | *"prima di ogni rilascio di un dato a 3 tori, vado a togliere tutto"* [AM SLIDE 2, NAS SLIDE 3] | 🟠 quanti minuti prima? E dopo? Assunzione di casa: ±30' (A3), **non del corso** |
| **B5** | **Promessa del "rischio zero"** | *"gestisco il rischio che diventerà poi uno stop profit dove **guadagnerò senza avere rischi**"* [AM SLIDE 11] · *"Così trasformi il trade da rischioso a **'senza rischio'**"* [PAG 27] | 🟠 falso: gap, slippage e weekend restano. Detto due volte in due documenti |
| **B6** | **Numero che cambia nella stessa pagina** | chiusura Nasdaq *"14.800"* poi *"15.000 (chiusura)"* [PAG 25] | 🔴 nell'**unico** esempio numerico completo del PDF |
| **B7** | **Formula di sizing dimensionalmente sbagliata** | *"Rischio (€) / Stop Loss (in punti) = Quantità"* [PAG 28] | 🔴 manca il valore-punto: chi applica la formula **quintuplica** il rischio nell'esempio stesso |
| **B8** | **Tabella dei fusi che contraddice gli screenshot dello stesso documento** | *"CET − 2 = Orario del server del broker"* [PAG 10] vs orologio BCM [PAG 34-35] | 🔴 **NUOVA**: un'ora di anticipo su conto BCM (§2.3) |

**Bandiere ASSENTI — e va detto, perché è merito:**
✅ **zero numeri di performance**, zero win rate, zero *"€ al mese"*, zero screenshot di
conto in profitto, **in tutti e 4 i documenti**. ✅ Nessun trucco anti-prop, nessuna
tecnica per aggirare regole (le prop non sono mai nominate). ✅ Nessuna griglia, nessun
martingala, ✅ **stop loss sempre obbligatorio** (*"Stop Loss obbligatorio, sempre"*
[PAG 27]). Su un materiale di corso a pagamento, non è poco.

---

# 9. ⚖️ I VERDETTI, DOCUMENTO PER DOCUMENTO

| documento | verdetto | motivo |
|---|---|---|
| **PDF ABTG (41 pag.)** | 🟠 **(a) SI ARCHIVIA + (c) una contraddizione con la casa da dichiarare** | Nessuna strategia nuova rispetto al 18/08. Il gap fill 1:1,5 è già nel core. La **novità è negativa**: [PAG 10] sbaglia il fuso di un'ora su BCM (B8), e [PAG 14] prescrive lo stop stretto che **R88 ha misurato peggiore** dello stop all'estremo opposto |
| **Piano Europeo (26 slide)** | ⬛ **(a) SI ARCHIVIA** | Zero parametri nuovi, zero SL, zero size. L'impianto (livelli+ST×3) non è quello della nostra sedia DAX, e la divergenza è già dichiarata dal 18/08 (n°20). **Nessuna azione** |
| **Piano America (12 slide)** | 🟡 **(b) UNA differenza misurabile — ma la spec va CORRETTA, non aperta** | **M1: la size divisa è 1:2, non 50/50.** Va corretta l'assunzione **A4** nella spec del 18/08 (falsa oggi). ⚠️ **NON diventa un candidato**: con SL comune è mediazione (B1), e la casa la tratta come tale. Se mai si misurasse, si misura 1:2 |
| **Piano Nasdaq (15 slide)** | 🔴 **(c) CONTRADDICE MISURE DI CASA — capitolo chiuso** | Prescrive il breakout d'apertura sul NASUSD: **R97 0/4** (22/08, n OOS 135, tick reali) + **R98 0/6** (23/08) + sedia 770201 **senza contratto** (PF 0,82, 19/20 celle OOS negative). Motore morto misurato. **Nessuna proposta, nessuna riapertura** |

## 🧾 In una riga
**Su 4 documenti già in archivio, il valore netto della seconda lettura sono 9 misure
dagli screenshot (di cui una che CORREGGE una nostra assunzione e una che CORREGGE il
fuso del corso) e zero motori nuovi.** L'unica cosa che il corso ci insegna e che
funziona — lo stop all'estremo opposto — **l'avevamo già misurata noi in R88, meglio di
come il corso la spiega.**

---

# 10. ❓ LE DOMANDE PER CLAUDIO — solo le bloccanti

1. **La correzione di A4 la applico alla spec?**
   `backtest_pipeline/prove/PIANI_APERTURA_SPEC.md` §8 dichiara *"A4: size divisa 50/50"*.
   Lo screenshot dice **10 + 20 (1:2)**. Se un futuro test usasse A4 com'è scritta,
   userebbe una geometria che **il corso non ha mai mostrato**. → Chiedo il via libera a
   **modificare quella riga della spec** (una riga, con rimando a questo referto).
   *Ricordo che non tocco nulla in forward: questa è una modifica di documentazione.*

2. **Il %Custom: qual è l'ANCORA della scala 0,25%?**
   Ho misurato la geometria (passo 0,25%, fino a ±3,00%, linea arancione etichettata
   `%Custom` [M8]) ma **non da quale prezzo parte** (apertura giornaliera? chiusura
   precedente? pivot?). Con l'ancora, il *"primo obiettivo = numero tondo + %Custom"*
   [NAS SLIDE 12] diventa **meccanizzabile**; senza, resta [INCERTO].
   👉 **Serve uno screenshot del pannello di configurazione dell'indicatore Qqin
   Multipivot** (tab "Parametri di input"), che in queste slide non è mai aperto.

3. **Il debito del 18/08 resta aperto: lo chiudiamo o lo dichiariamo chiuso per decadenza?**
   L'**ablazione dei filtri** (volumi, ATR, ST×3, correlazione, news = *il metodo come lo
   prescrive il corso*) **non è mai girata**. Finché non gira, la frase *"il metodo del
   corso non funziona"* **non è dimostrata**: quello che è morto nei nostri round è lo
   **scheletro nudo**. Ma nel frattempo il simbolo su cui l'ablazione era pronta
   (`ablazione_nasdaq.ps1`) è **chiuso da R97+R98**. → **Decisione tua**: (i) si rifà
   l'ablazione **sul Dow o sul DAX** (dove un edge misurato ESISTE), oppure (ii) si
   dichiara il debito **estinto** e si smette di citarlo. Oggi è in mezzo, ed è la cosa
   peggiore.

---

# 11. 🗑️ GLI SCARTI — cosa NON ho estratto e perché

- **PDF PAG 1-13, 19-23, 26, 31, 36-41** (copertine, disclaimer, "perché le aperture sono
  magiche", pre-apertura vs apertura, takeaway, questionario, soluzioni, ringraziamenti):
  **zero parametri operativi**. Il questionario [PAG 38-40] è didattico; le soluzioni
  (1-B, 2-C, 3-C, 4-B, 5-B, 6-C) erano già verificate coerenti col testo il 18/08.
- **Europeo SLIDE 3, 5, 6, 8, 12, 13, 16, 22, 26**: solo immagini, **aperte e controllate**
  → grafici senza pannelli leggibili. Nessuna estrazione possibile, **e nulla da chiedere**.
- **PDF PAG 6-7, 11** (volatilità, indici come bussola, link a `mataf.net`): divulgativo.
- **America SLIDE 5** (come installare il Supertrend in MT4): procedura d'installazione,
  nessun parametro. ⚠️ Nota: parla di **MT4** mentre gli screenshot sono **MT5**.
- **Nasdaq SLIDE 1-2, 7-9, 15**: introduttive/psicologiche.
- **Tutti e quattro**: nessuna regola prop, nessun numero di performance → le due sezioni
  della griglia restano **vuote per assenza di fonte**, non per omissione.

---

## 🔗 Rimandi

- Analisi precedente degli stessi file (**da leggere prima di questa**):
  `caccia_strategie/ANALISI_PIANI_APERTURA_2026-08-18.md` · spec:
  `backtest_pipeline/prove/PIANI_APERTURA_SPEC.md`
- Verdetti misurati citati: `risultati_archivio/REFERTO_ROUND88_ORB_MIGLIORAMENTO.md` ·
  `R96_REFERTO.md` · `R97_REFERTO.md` · `R98_REFERTO.md` ·
  `REFERTO_ROUND42_FADE.md` · `REFERTO_ROUND43_ORL.md` · `report/DIARIO.md`
- Lezione BCM sugli screenshot: `caccia_strategie/ANALISI_NIGHTLY_PDF_2026-08-23.md` §1
- Prop: `caccia_strategie/CONFIG_PROP_2026-08-18.md` · `report/METRO_PROP.md`

_Compilato il 23/08/2026. **Nessun file di prova creato, nessun sorgente EA toccato,
nessuna modifica al forward** — questa è un'analisi._
