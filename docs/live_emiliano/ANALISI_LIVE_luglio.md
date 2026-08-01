# Analisi live Emiliano / Paolo — luglio 2026

Verdetto per ogni trascrizione: strategia meccanizzabile (→ EA), analisi macro (→ report), o discrezionale (non automatizzare).

## Paolo — 28/07 (Fibonacci + EMA200) → ✅ È la nostra ABTG_EMA200
- Rimbalzo su **EMA200**, ordine pendente **1/3 prima + 2/3 dopo** la media, primo target **EMA14**, confluenza **Supertrend 3.5 / ATR 10**.
- Usi della media: **reversal / breakout / break-in**.
- **NOVITÀ da aggiungere:** filtro **distanza ADR** (average daily range a 50gg): opera solo se all'apertura il prezzo è a distanza "raggiungibile" dalla media (ideale ~0,8× ADR; troppo vicino o troppo lontano → salta).
- Fibonacci: ritracciamento (23.6/38.2/50/61.8), estensione (127/161.8/200); ritracciamenti calanti = trend che perde forza.
- **AZIONE:** aggiungere il filtro ADR-distanza a `ABTG_EMA200` e ritestarlo.

## Emiliano — 20/07 (DAX apertura) → ✅ combacia col nostro motore apertura
- Pilastri: **max/min della notte** + max/min giorno prima; **ORB 15 min**; **VWAP 15 min** (spartiacque); ingresso **sul retest** (mai "in corsa"); Supertrend 3.5 D1; Bollinger 22 in apertura.
- Gestione: size divisa **1/3 + 2/3**, **break-even**, **parziale**, stop a metà canale / **ATR(14)** / tecnico; correlazione DAX↔S&P.
- **AZIONE:** conferma il nostro `studio_apertura` / motore apertura. Idea da testare: **filtro VWAP 15min** come conferma di direzione.

## Emiliano — 26/07 (weekend, macro) → 📊 alimenta il report
- COT, open interest, banche centrali (BoE/BoJ), gap del lunedì, swap/spread weekend.
- **Correlazione utile:** petrolio su → DAX giù (peso automotive nel DAX).
- COT + calendario CB già nel report. **AZIONE:** aggiungere la **correlazione petrolio-DAX** al report.

## Emiliano — 27/07 (Oro) → ⛔ NON automatizzare
- Trading **discrezionale sotto stress**, conto piccolo, **anti-martingala** (aggiunge contratti mentre va), "finte su finte", volumi/volatilità bassi.
- **NON meccanizzabile in sicurezza** (anti-martingala senza regole ferree = pericolosa). Semmai esempio di cosa EVITARE.

## Emiliano/De Marco — 29/07 sera FOMC (PostNews) → ✅ VALIDA la nostra ABTG_PostNews
La fonte spiega ESATTAMENTE la nostra strategia PostNews e dice che **"è meccanica, banale, automatizzabile"**.
- **Post-news** (dopo lo speech del governatore, 20:30 IT), NON sul dato (troppo slippage).
- **2 candele da 5 min** dalle 20:30 → range (max/min delle due candele).
- **BUY STOP +3 pip** sopra il max, **SELL STOP −3 pip** sotto il min. *(nostro preset: sell offset 2 → allineare a 3).*
- **Stop 25 pip, Target 50 pip** (1:2). ✓ combacia col nostro preset.
- ⭐ **TENERE fino alle 21:45 ora italiana** = uscita a tempo della strategia. → il nostro EA fa scadere i PENDENTI
  alle 21:45 ma NON chiude la posizione aperta → **AGGIUNGERE chiusura posizione a 21:45** (risponde alla domanda di Claudio).
- Strumenti: **EUR/USD** (il più liquido), **USD/JPY** (inverso), oro con cautela. Indici NO (illiquidi sul dato).
- Refinement personali: BE dopo ~20 pip; TP a 44 se c'è resistenza vicina; primo movimento EUR/USD ~60 pip (statistico).
- ⚠️ **ECB: Emiliano NON la trada** ("per troppi anni ha fatto quel che voleva"). Noi abbiamo un preset ECB → da rivalutare/deprioritizzare.
- Testare ogni strategia ≥ 6 mesi.
- **AZIONE:** aggiungere a `ABTG_PostNews` la **chiusura della posizione all'orario di scadenza** (news+75min = 21:45 IT).

## Emiliano — 29/07 mattina (oro/DAX) → ⛔ discrezionale, poco da meccanizzare
- Ha **bruciato un conto da 10k** lunedì sull'oro (discrezionale) → conferma: NON meccanizzare l'oro discrezionale.
- Regole personali/scalping: uscita a tempo ("6 min 20 sec", "target 15-20 min"), ingresso in M5/M15 su livello H1, scenari A/B/C, volumi crescenti/decrescenti, max/min notte, retest. Framework che si sovrappone al motore apertura.

## Paolo — 30/07 (Japan/JPY: EMA200 reversal + struttura) → ✅ arricchisce ABTG_EMA200
Contesto: giornata di forte rafforzamento JPY su tutti i cross (fattore macro, BoJ/rifugio). Paolo non ha tradato ma spiega il metodo su AUD/NZD e Nasdaq.
- **EMA200 reversal (2 scenari alla media 200):**
  - (a) prezzo **sente la media 200 e torna** → ritracciamento ~50% dell'area, prende liquidità, riparte → *questa è la nostra configurazione EMA200 reversal*.
  - (b) prezzo **rompe** la media → pullback a 23.6/38.2 **sulla EMA200**, poi prosegue il trend.
- ⭐ **NOVITÀ azionabile — laddering a 2 ordini sull'EMA200:**
  - **1° ordine pendente SULLA media 200** (non lontano: "se ipotizzo un rimbalzo, pendente sulla media").
  - **2° ordine a Fibonacci 127** (proiezione) come copertura; quando il prezzo fa il **pullback sulla media 200**, si **chiude il 2° ordine in pari (BE)**.
- ⭐ **Filtro VOLUME alla media 200:** arriva con **volumi crescenti → rompe** (continuazione); **volumi decrescenti → rimbalza** (reversal). Discrimina scenario (a) vs (b).
- **Struttura (già nota, ribadita):** BOS vs cambio di carattere; serve **candela WEEKLY confermata** per validare la rottura ("finché il weekly non chiude sotto, non è short"); massimi/minimi decrescenti = microtrend ribassista.
- **Imbalance/FVG:** si aspetta candela che **chiude l'imbalance** prima di ripartire (conferma filtro FVG già segnato).
- **Bollinger:** dopo espansione la banda "si deve chiudere" → prezzo ritesta la **mediana** (confluenza media 9/21) = mean-reversion (conferma Bollinger squeeze già segnato).
- **AZIONE:** valutare per `ABTG_EMA200` la variante **reversal a 2 ordini** (pendente su EMA200 + copertura a 127, chiusura 2° in pari sul pullback) e il **filtro volume** crescente/decrescente alla media.

## Emiliano — 31/07 → ⛔ nessun contenuto (registrazione di soli saluti, vuota)

## Refinement estratti (da fare)
1. Filtro **ADR-distanza** su `ABTG_EMA200` (Paolo 28/07).
2. Correlazione **petrolio→DAX** nel report giornaliero (Emiliano 26/07).
3. (Opzionale) filtro **VWAP 15min** come conferma sul motore apertura (Emiliano 20/07).
4. (Nuovo, Paolo 30/07) `ABTG_EMA200` **reversal a 2 ordini** (pendente su EMA200 + copertura Fibo 127, 2° in pari sul pullback) + **filtro volume** alla media (crescente=rompe / decrescente=rimbalza).
