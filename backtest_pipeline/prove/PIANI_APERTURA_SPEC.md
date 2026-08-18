# 🕘 PIANI DI APERTURA — SPECIFICA IMPLEMENTABILE RICOSTRUITA DAI 4 FILE UFFICIALI

**Data:** 18/08/2026 sera · **Fonte:** i 4 file in
`backtest_pipeline/caccia_strategie/corso_documenti_2026-08-18/`, estratti PER
INTERO (testo di ogni slide/pagina, in ordine):

| documento | slide/pagine | autore dichiarato |
|---|---|---|
| `Piano di trading Europeo (1).pptx` | **26 slide** | Forex Trading Diary / **Emiliano Monza** [SLIDE 1] |
| `Piano di Trading America (1).pptx` | **12 slide** | (nessun autore in copertina) |
| `Piano di Trading America Strategia Nasdaq (1).pptx` | **15 slide** | (nessun autore in copertina) |
| `ABTG-Apertura Mercati 20240507 (1).pdf` | **41 pagine** | Alfio Bardolla Training Group SpA, *«La Magia delle Aperture Europee e Americane»*, release 07.05.2025 [PAG 1-2]; metadati PDF: autore `michaelagenova196`, creato 07/05/2025 |

**Consegna gemella:** fedeltà delle sedie vive, attriti prop e verdetto in
`caccia_strategie/ANALISI_PIANI_APERTURA_2026-08-18.md`.

> 📌 **Storia di casa, dichiarata subito:** questi IDENTICI file erano già stati
> letti il 02/08 (estratto: `docs/live_emiliano/ANALISI_SLIDE_APERTURE.md`,
> audit: `docs/live_emiliano/AUDIT_EA_vs_DOCUMENTI.md` — punteggio 11/21).
> Questa è la **rifattura col protocollo di rigore**
> (`report/PROMPT_DI_INTELLIGENZA_PRECISA.md`): censimento riga per riga,
> aritmetica controllata, etichette esplicite. Dove trovo cose che il 02/08
> non aveva visto, lo dico.

> ⚠️ Fonte **slide + PDF** (testo scritto, nessun audio). Etichette:
> **[SLIDE n]/[PAG n]** = testuale dal documento · **[INFERITO]** = deduzione
> dichiarata · **[INCERTO]** = non ricostruibile. Le pagine del PDF sono
> numerate col numero stampato in calce (1-41).

---

## 0. 🎯 IL VERDETTO DI MECCANIZZABILITA'

⚠️ **I 4 file contengono SEI impianti operativi diversi** (Europeo discrezionale,
America a size divisa, Nasdaq a ordini stop, e nel PDF: breakout notturno,
breakout classico, gap fill). Vanno contati SEPARATI — la media unica
nasconderebbe che il Nasdaq è quasi un EA già scritto e l'Europeo è un
mestiere a occhio.

| piano | decisioni censite | 🟢 certe | 🟠 ambigue risolvibili | 🔴 buchi | **meccanizzabilità con assunzioni** |
|---|---:|---:|---:|---:|---:|
| **Nasdaq** (pptx, §4) | 14 | 7 | 6 | 1 | **13/14 = 93%** |
| **America** (pptx, §3) | 17 | 7 | 6 | 4 | **13/17 = 76%** |
| **PDF** (4 strategie, §5) | 29 | 9 | 13 | 7 | **22/29 = 76%** |
| **Europeo** (pptx, §2) | 23 | 7 | 7 | 9 | **14/23 = 61%** |
| **TOTALE MISSIONE** | **83** | **30** | **32** | **21** | **62/83 ≈ 75%** |

🚨 **I buchi che decidono il P&L, piano per piano:**
1. **Piano Europeo: NON dichiara MAI né lo stop loss iniziale né la size.**
   Ventisei slide, zero money management. L'unica cifra di gestione è il
   trailing (150/410 punti [SLIDE 20]).
2. **Piano America: la % di rischio non c'è** (il "max 2%" sta SOLO nel pptx
   Nasdaq [SLIDE 14]); la proporzione della size divisa non è detta.
3. **Multipivot Qqin / %Custom: indicatore PROPRIETARIO**, presente in tutti e
   tre i pptx, mai definito. Il piano Nasdaq però dà il surrogato da solo:
   *"Primo obiettivo … numero tondo"* [SLIDE 12].
4. **PDF: i take profit sono un menu** (resistenze, Fibonacci, EMA, pivot
   [PAG 14]) senza regola di scelta — tranne il **Gap Fill [PAG 24-25]**, che ha
   TP definito (chiusura precedente), SL definito, RR minimo 1:1.5 e rischio
   max 2%: **è la strategia più chiusa dei 4 documenti (8/9 = 89%)**.

---

## 1. ⏰ FUSI ORARI — ogni orario dei piani, mappato su casa nostra

**Fuso di partenza dei documenti, DICHIARATO:**
- pptx America: *"Apertura mercati Europei: 09:00 (**Ora Italiana**) · Apertura
  mercati Americani: 15:30 (**Ora Italiana**)"* [SLIDE 2] → 🟢 fuso dichiarato.
- pptx Europeo: *"alle ore 9:00 del mattino"* [SLIDE 2] → [INFERITO] ora
  italiana, corroborato dal pptx America e dal PDF.
- PDF: usa **CET/CEST e UTC**, con tabella di conversione [PAG 9-10] e la nota
  *"Durante il periodo marzo-ottobre … NYSE alle 15:30"* → 🟢 coerente con
  l'ora italiana.

**Mappa su ora server BCM (= ora italiana − 1, regola di casa):**

| evento nei piani | ora dichiarata (IT) | ora server BCM | fonte |
|---|---|---|---|
| Pre-apertura EU (setup) | 08:00-09:00 | **07:00-08:00** | [PAG 15] |
| Checklist pre-apertura | 08:30 | **07:30** | [PAG 29, 32] |
| Apertura EU / DAX | 09:00 | **08:00** | [AM SLIDE 2], [PAG 8] |
| Finestra ideale DAX | 09:00-11:00 CET | **08:00-10:00** | [PAG 12] |
| Verifica Supertrend post-apertura | 10:00 | **09:00** | [EU SLIDE 25] |
| Apertura USA | 15:30 | **14:30** | [AM SLIDE 2], [PAG 8] |
| Finestra volatilità USA | primi 5-15 min | 14:30-14:45 | [AM SLIDE 2], [PAG 22] |
| Dow "ottimo" | 15:30-17:00 e 21:00-22:00 | 14:30-16:00 e 20:00-21:00 | [PAG 12] |

> ⚠️ **La tabella broker del PDF NON è il nostro broker.** L'esempio [PAG 10]
> usa un server *"CET-2 = UTC-1"* (Tokyo 00:00 UTC → 23:00 server): quel fuso
> **non è BCM** (BCM = IT−1 = UTC+1 in estate). Il PDF stesso dà la regola
> giusta: *"Verifica sempre sul tuo grafico se l'apertura corrisponde davvero
> alle 09:00 CET"* — ed è la nostra regola di casa. La colonna "server" del
> PDF va IGNORATA, la verifica sul grafico no.

---

## 2. 🇪🇺 PIANO DI TRADING EUROPEO (26 slide) — il più discrezionale

### 2.1 La tesi, come la dichiara il piano
> *"L'apertura dei mercati Europei viene tradata alle ore 9:00 del mattino
> mettendo a confronto gli indici di riferimento: D30EUR … in correlazione con
> il 225JPY … e con l'SPXUSD … Il 225JPY, influenza l'SPXUSD che influenza a
> sua volta il D30EUR."* [SLIDE 2]

⚠️ La catena di influenza è **affermata, mai misurata** nel documento —
motivazione narrativa, non evidenza (stesso pattern del modulo Media200).

### 2.2 Censimento delle 23 decisioni operative

| # | decisione | valore | fonte | etichetta |
|---|---|---|---|---|
| 1 | Orario operativo | 09:00 IT (= 08:00 server BCM) | [SLIDE 2] | 🟢 |
| 2 | Strumenti | D30EUR + monitor 225JPY, SPXUSD (+2 valute nel grafico) | [SLIDE 2, 7, 18] | 🟢 lista |
| 3 | **Regola di correlazione** | *"vanno valutati entrambi … per capire la condizione di mercato"* — MAI una condizione operativa (soglia, direzione concorde, ecc.) | [SLIDE 2, 14, 18] | 🔴 **BUCO** |
| 4 | Multipivot Qqin (classic b, Fibonacci, %Custom) | indicatore **proprietario**, mai definito | [SLIDE 4] | 🔴 **BUCO** |
| 5 | Supertrend ×3 | multiplier **2.5 / 3.0 / 3.5** — il periodo ATR NON è mai detto | [SLIDE 4] | 🟠 assunzione: periodo 10 (default comune; il nostro core usa 10) |
| 6 | Medie | EMA **89 / 100 / 200 / 14** (esponenziali; "applicata al close" sta nel gemello America [AM SLIDE 4]) | [SLIDE 4] | 🟢 |
| 7 | "QQ Opposing" su TF inferiori | mai spiegato, presumibilmente proprietario | [SLIDE 4] | 🔴 **BUCO** |
| 8 | Timeframe | ogni strumento su **M15, H1, H4**; Daily con canali di regressione **PTE** | [SLIDE 7] | 🟢 |
| 9 | Routine domenicale | livelli con la **"tecnica di Larry Williams"** su D1/W1/MN (colori: MN azzurro, W1 arancione, D1 verde) — la tecnica NON è definita nelle slide | [SLIDE 9] | 🟠 in casa la tecnica c'è (`ABTG_PunteLarry`, dai materiali Larry): assunzione dichiarata di usare QUELLA definizione |
| 10 | Lettura rottura massimi MN→W1 | *"Breakin Breakout PTE, dove la candela apre totalmente sopra o totalmente sotto per seguirne la direzione"* + max/min candela W1 precedente | [SLIDE 10] | 🟠 definizione c'è (open fuori dal range della candela precedente), procedura multi-TF discrezionale |
| 11 | "Se non ho livelli" | scendo di TF / cerco dove il mercato si è fermato più volte / Fibonacci per i ritracciamenti | [SLIDE 11] | 🔴 **BUCO** (tutto a occhio: quante volte "più volte"? quale ritracciamento?) |
| 12 | Sui massimi assoluti | solo operazioni **a favore di trend**, su "livelli chiave" | [SLIDE 14] | 🟠 direzione definibile (ST/EMA), "livelli chiave" no |
| 13 | Struttura dei mercati | *"cambia quando apre totalmente sotto ai massimi precedenti"* → trading range | [SLIDE 15] | 🟢 come definizione |
| 14 | Ordini pendenti | *"sui livelli … a favore di trend"* — quali livelli, quanti ordini, che size: non detto | [SLIDE 19] | 🔴 **BUCO** |
| 15 | Take profit | *"in divenire, seguiamo l'operazione a time frame più bassi"* | [SLIDE 19] | 🔴 **BUCO** |
| 16 | Invalidazione | *"quando il prezzo rompe i minimi precedenti"* + cambio Supertrend su TF inferiori | [SLIDE 20] | 🟠 (quali "minimi precedenti": assunzione = ultimo swing sul TF operativo) |
| 17 | **Trailing stop** | *"Sulle valute **150 punti** corrispondono a 1 pip e mezzo. Sugli indici **410 punti** corrispondono a 4 punti indice."* | [SLIDE 20] | 🟢 **le uniche cifre di gestione del piano** (verifica aritmetica in §6) |
| 18 | Bollinger M15 | ordine fuori banda; *"la mediana interna … è un obiettivo di prezzo"* — parametri banda MAI detti | [SLIDE 21] | 🟠 assunzione: 20/2 standard |
| 19 | Ingresso TREND | *"Super Trend, quando cambiano **tutti e tre**, posso entrare a mercato"* + medie per la ripartenza | [SLIDE 23] | 🟢 condizione netta (i tre ST concordi) |
| 20 | Ingresso RITRACCIAMENTO | Fibonacci / Bollinger / livelli % del Multipivot | [SLIDE 24] | 🔴 **BUCO** (menu senza regola di scelta, %Custom proprietario) |
| 21 | Conferma post-apertura | ore 10:00 IT: *"se l'ultimo livello di Super Trend ha mantenuto la conformazione e la candela che apre, apre all'interno, il livello è forte"* | [SLIDE 25] | 🟠 ("ultimo livello", "all'interno": ricostruibile con un'assunzione) |
| 22 | **Stop loss iniziale** | **MAI DEFINITO in 26 slide** | — | 🔴 **BUCO CAPITALE** |
| 23 | **Size / rischio %** | **MAI DICHIARATO in 26 slide** | — | 🔴 **BUCO CAPITALE** |

**Conteggio: 🟢 7 · 🟠 7 · 🔴 9 → 14/23 = 61%.**

### 2.3 Le note di mercato (informative, non regole)
- D30EUR *"risente dei livelli tecnici"*; U30USD *"può violare leggermente i
  livelli tecnici ma li risente e li ritesta"*; SPXUSD *"risente dei livelli
  tecnici"* [SLIDE 17] — [dichiarato, NON verificato].
- Rottura massimi Monthly → *"normale … una candela di volatilità"* [SLIDE 10].

### 2.4 🔴 Il punto che il 02/08 aveva già visto e che il censimento CONFERMA
**Il piano Europeo NON descrive un ORB.** Nessuna slide parla di range dei
primi 15 minuti sul DAX: l'impianto è livelli pre-tracciati (domenica, Larry
Williams) + Supertrend ×3 + ordini pendenti sui livelli. Il "primi 15 minuti"
sta nel pptx AMERICA [AM SLIDE 2] e il "breakout" del DAX sta nel PDF
([PAG 8]: *"ideale per strategie di breakout e pre-apertura"* — una
CARATTERIZZAZIONE del mercato, non una spec). Il nostro `ABTG_DAX_Apertura_EU`
è quindi un ORB **costruito su un'indicazione generica del PDF**, non sul
piano Europeo. Confronto completo nella consegna gemella.

---

## 3. 🇺🇸 PIANO DI TRADING AMERICA (12 slide) — la size divisa

### 3.1 Censimento delle 17 decisioni operative

| # | decisione | valore | fonte | etichetta |
|---|---|---|---|---|
| 1 | Routine news | ForexFactory / Investing; *"le notizie a 3 tori … sono quelle che impattano maggiormente. Se abbiamo operazioni in macchina o pendenti, prima di ogni rilascio di un dato a 3 tori, vado a togliere tutto."* | [SLIDE 2] | 🟠 regola netta, ma **quanti minuti prima** non è detto |
| 2 | Orari | EU 09:00 IT · USA 15:30 IT (**fuso dichiarato**) | [SLIDE 2] | 🟢 |
| 3 | Finestra operativa | *"Sfruttiamo la volatilità nei **primi 15 minuti**"* | [SLIDE 2] | 🟢 |
| 4 | Strumenti | US30USD, NASUSD (*"più volatile in assoluto"*), SPXUSD (guida), D30EUR (per correlazione) | [SLIDE 3] | 🟢 |
| 5a | Multipivot Qqin | proprietario, mai definito | [SLIDE 4] | 🔴 **BUCO** |
| 5b | Supertrend ×3 | multiplier 3.5 / 3.0 / 2.5 — periodo ATR mai detto | [SLIDE 4] | 🟠 assunzione: 10 |
| 5c | Medie | EMA **200 / 100 / 89 / 14**, *"applicata al **close**"* (detto per ognuna) | [SLIDE 4] | 🟢 il parametro meglio dettato del pptx |
| 6 | Timeframe | D1 tendenza · H4 spaccato · **H1 operativo** · M15 gestione; *"più i time frame sono alti, più i livelli sono stabili"* | [SLIDE 6] | 🟢 |
| 7 | Correlazione (come regola d'ingresso) | *"l'spxusd è l'indice di riferimento americano che traina gli altri"* — nessuna condizione operativa | [SLIDE 8-9] | 🔴 **BUCO** |
| 8 | Trigger | *"Tradando la rottura dei massimi o dei minimi, scendo di time frame. Non entriamo subito a mercato"* — QUALI massimi (TF, struttura) qui non è detto | [SLIDE 10] | 🟠 assunzione: i livelli H1 del piano gemello Nasdaq |
| 9 | **Size divisa** | *"divido la size: sui massimi dove potrebbe andare a prendere la forza per ripartire e sulla **media a 14 periodi**, per entrare ad un prezzo migliore"* — proporzione MAI detta | [SLIDE 10] | 🟠 assunzione dichiarata: 50/50 |
| 10 | Stop | *"Lo stop, lo metto **sotto ai minimi**"* (caso long; lo short è simmetrico [INFERITO]) | [SLIDE 10] | 🟠 quali minimi: assunzione = minimi della struttura rotta |
| 11 | Correlazione (in gestione) | *"Verifico la correlazione con l'spxusd per capire se lasciar correre l'operazione o ridurre"* | [SLIDE 10] | 🔴 **BUCO** (discrezionale puro) |
| 12 | Gestione attiva | *"Mi sposto lo stop per rischiare meno. Chiudo **metà posizione** e porto lo **stop in pari**"* — il QUANDO non è quantificato | [SLIDE 11] | 🟠 assunzione: al primo obiettivo (come piano Nasdaq) |
| 13 | Trailing | *"scendo di time frame in **M1**, dove seguirò con lo stop adeguandolo alla **base della candela precedente**"* | [SLIDE 11] | 🟢 |
| 14 | Stop profit | *"Seguirò la posizione con lo stop profit lasciandola correre … sarà il mercato a decidere quando chiudere"* | [SLIDE 12] | 🟢 (= il trailing della riga 13, coerente) |
| 15 | **Rischio %** | **MAI DICHIARATO in questo pptx** (il 2% sta solo nel Nasdaq) | — | 🔴 **BUCO** |

**Conteggio: 🟢 7 · 🟠 6 · 🔴 4 → 13/17 = 76%.**

### 3.2 Nota di merito
La **size divisa in due ingressi** (metà sul livello di rottura, metà in
pullback sulla EMA14) è la caratteristica DISTINTIVA di questo piano — ed è
l'unica regola dei 3 pptx **mai implementata né testata** in casa (audit 02/08,
punto #20, dichiarato "bassa priorità"). Meccanizzabile con 2 assunzioni
(proporzione 50/50; secondo ordine = limit sulla EMA14 H1 con scadenza).

---

## 4. 🎯 PIANO NASDAQ (15 slide) — quasi un EA già scritto: 93%

### 4.1 La tesi
> *"L'indice Nasdaq si presta alla strategia della rottura dei minimi e dei
> massimi in apertura, grazie alla sua direzionalità."* [SLIDE 9]
> [dichiarato, NON verificato — e il nostro walk-forward del 05/08 sul
> Nasdaq ha trovato 19/20 celle OOS NEGATIVE: la direzionalità all'apertura,
> sui NOSTRI tick, non paga il breakout a stop]

### 4.2 Censimento delle 14 decisioni operative

| # | decisione | valore | fonte | etichetta |
|---|---|---|---|---|
| 1 | Routine news 3 tori | identica al piano America (*"vado a togliere tutto"*) | [SLIDE 3] | 🟠 finestra in minuti non detta |
| 2 | Strumenti | US30USD, NASUSD, SPXUSD, D30EUR | [SLIDE 4] | 🟢 |
| 3 | Multipivot %Custom | proprietario — MA il piano stesso dà il surrogato: numeri tondi (§4.3) | [SLIDE 5] | 🟠 |
| 4 | Timeframe | D1 / H4 / **H1 operativo** / M15 gestione | [SLIDE 6] | 🟢 |
| 5 | **Ingresso** | *"Si posizionano ordini nel time frame **H1**. **SELL STOP** sotto i minimi precedenti, per ingresso short. **BUY STOP** sopra i massimi precedenti, per ingresso long"* | [SLIDE 10] | 🟢 **la regola d'ingresso più netta di tutti e 4 i documenti** (assunzione: "precedenti" = candela H1 precedente) |
| 6 | Quando piazzarli | mai detto esplicitamente (contesto = apertura 15:30) | [SLIDE 1-2, 8] | 🟠 assunzione: all'apertura USA |
| 7 | **Stop** | *"PORTO LO STOP SUI MASSIMI PRECEDENTI"* (eseguito lo short; simmetrico = estremo opposto della candela) | [SLIDE 11] | 🟢 |
| 8 | **OCO** | *"CANCELLO L'ORDINE CHE NON È STATO ESEGUITO"* | [SLIDE 11] | 🟢 |
| 9 | Take profit | *"LO STABILISCO IN DIVENIRE **DIMEZZANDO** SUI LIVELLI IMPORTANTI CHE INCONTRA"* | [SLIDE 11] | 🟠 "livelli importanti" → risolto dal piano stesso con §4.3 |
| 10 | Breakeven | *"LO STOP LO PORTO IN PARI, OVVERO SUL LIVELLO D'INGRESSO"* | [SLIDE 11] | 🟢 (sequenza dopo il dimezzo [INFERITO dall'ordine delle frasi]) |
| 11 | 1° obiettivo | *"in concomitanza: **Numero tondo** + % custom (preso dall'algoritmo del multipivot)"* — es. *"(17000-38000)"* [SLIDE 15] | [SLIDE 12] | 🟠 numero tondo meccanico; la "concomitanza" col %Custom non replicabile |
| 12 | Se non c'è setup | *"Verifico se in preapertura non è stato invalidato il setup. Se non ho il setup, **cambio strumento**"* — l'invalidazione NON è definita | [SLIDE 13] | 🔴 **BUCO** |
| 13 | **Money management** | *"STABILISCO LA % DI PERDITA DEL MASSIMO DEL **2%**"* | [SLIDE 14] | 🟢 l'unica % di rischio dei tre pptx |
| 14 | Direzione | *"TREND IS YOUR FRIEND, CERCO SEMPRE DI ANDARE A FAVORE DI TREND"* | [SLIDE 14] | 🟠 trend non definito qui (assunzione: EMA/ST dei TF alti) |

**Conteggio: 🟢 7 · 🟠 6 · 🔴 1 → 13/14 = 93%. Il piano più meccanizzabile
dei quattro documenti** — ed è infatti quello che `ABTG_Nasdaq_Apertura_US`
implementa quasi alla lettera (consegna gemella).

### 4.3 Il surrogato del %Custom, dichiarato dal piano stesso
> *"Un altro effetto è il **numero tondo (17000-38000)**, dove gli operatori
> intervengono per emotività psicologica; i prezzi risentono di questo
> livello, che diventa quindi **un livello obiettivo**"* [SLIDE 15]

→ La griglia dei numeri tondi è il proxy DICHIARATO dei livelli obiettivo:
`InpUseRoundLevels`/`InpRoundStep` nel nostro core è fedele alla fonte, non un
ripiego nostro.
