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
