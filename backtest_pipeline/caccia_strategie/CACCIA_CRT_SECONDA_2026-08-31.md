# 🏹 SECONDA CACCIA — CRT / TURTLE SOUP: meccanismi alternativi sullo sweep di liquidità — 31/08/2026

**Mandato (Regola della Seconda Caccia, 19/08):** dopo il verdetto rosso del CRT
(`risultati_archivio/REFERTO_CRT_2026-08-30.md`, chiuso il 31/08 con PF **0,459**
a tick reali col gate acceso), si cercano **MECCANISMI alternativi sulla stessa
inefficienza** — lo sweep di liquidità / falso breakout dei livelli di range —
**mai parametri diversi del motore morto**.

---

## ⚡ IL RISULTATO IN UNA RIGA

> **Su 6 fonti sottoposte a controllo positivo (4 vive, 2 nulle) e 41 candidati
> guardati, 6 sono arrivati al sorgente e li ho letti riga per riga. NE PROMUOVO
> UNO — e non viene da fuori: viene da una spec già scritta in casa il 23/08 e
> mai provata. Le altre due piste del mandato NON le propongo, perché nel corso
> di questa caccia ho trovato la misura che le falsifica ENTRAMBE, su 6.442
> eventi.**

🔴 **La scoperta che cambia il mandato, e va scritta per prima.**
Il paper arXiv **2605.04004** (Mesfin, maggio 2026) — che il nostro repo già
cita in due dossier ma **solo per il §6.1** — al **§4.3** misura esattamente le
piste 1 e 2 di questo mandato, sullo **stesso strumento** (Nasdaq futures):

> _"This signal identifies bars where price temporarily pierces a recent session
> high or low before closing back inside the range. The hypothesis is that this
> stop-order sweep creates a reversal opportunity. I found **6,442** such events
> across the dataset (3,419 long grabs, 3,023 short grabs). **Fading the grab
> direction: mean net −2.20 points, T = −14.12. Trading with the grab: mean net
> −1.80 points, T = −13.24.** Both directions are significantly negative. The
> gross directional content of the signal is **0.20–0.80 points in either
> direction**, which cannot clear a 2-point friction threshold in either
> direction. **This is a pure friction ceiling result.**"_
> [VERIFICATO — letto nel PDF, pag. 5]

👉 **La pista 2 del mandato ("turtle soup inverso": sweep in direzione del trend)
non è un'ipotesi aperta: è una misura già fatta, con segno negativo e T = −13.24
su n = 6.442.** Non la propongo. Proporla sarebbe portare a Claudio un
esperimento il cui esito è già agli atti.

---

## 0. ⚖️ I CRITERI, CONGELATI PRIMA DEI NUMERI

Scritti prima di aprire un solo sorgente. Valgono per ogni candidato.

**C1 — NIENTE PARAMETRI DIVERSI DELLO STESSO MORTO.** Un candidato entra solo se
cambia **almeno uno** fra: (a) la **definizione del livello**, (b) il **momento
dell'ingresso**, (c) la **geometria dell'uscita**. Cambiare soglie del pattern
a 2 candele = scarto automatico.

**C2 — IL CANCELLO È LA FRIZIONE, NON IL PF.** Metro di casa `R98_CRITERI.md`
§3.2 + `METRO_PROP.md` D4: **mediana del take LORDO ≥ 3 × spread**, spread di
riferimento **2,0 punti indice** [SPREAD NON MISURATO — è ancora il lato alto
della forchetta, e il *RealCost Spread P95 Logger* (Code Base 74148, promosso il
23/08) **non è ancora mai stato usato**: quarta caccia che lo scrive].
👉 **Soglia operativa: take mediano ≥ 6,0 punti indice.**

**C3 — VERDETTI SOLO A TICK REALI.** L'OHLC conta i trade, non dà il segno (R57).

**C4 — PAVIMENTO SL OBBLIGATORIO** (`InpMinSLPts`, lezione R109).

**C5 — DUE LATI SEMPRE** (regola di Claudio del 25/08).

**C6 — CAMPIONE:** ≥150 operazioni IS (Emendamento della Finestra §A). Sotto →
**"non misurabile"**, non "senza edge".

**C7 — NIENTE** martingala, griglia, recovery, hedge, lotto fisso, stop virtuale,
repaint, `WebRequest`, `iCustom` non allegato. Il §4 non si ammorbidisce.

**C8 — NON SI TOCCA IL FORWARD.** Nessun EA vivo, nessun magic **7691xx** (CRT)
né **770250**. Questo dossier non ha modificato una sola riga di codice.

---

## 1. 📕 LA LISTA DEI CADUTI — riletta PRIMA di uscire

| caduto | dove | meccanismo | verdetto misurato |
|---|---|---|---|
| **CRT Turtle Soup** | `REFERTO_CRT_2026-08-30.md` | fade del wick di sweep su range a **1 candela M15** | **0/30 celle** a tick; gated ADX(D1)≤30 **PF 0,459** vs ungated 0,462; **17 mesi su 19 rossi**, long E short |
| **R95 — SWEEP + RECLAIM** | `R95_REFERTO.md` | buca lo swing, richiude dentro; livelli = swing 21 barre/lato | **30 passate su 30 in perdita**, PF 0,65-0,80, DD 27-99,9%, n da 149 a 3.641 |
| **§4.3 — Liquidity Grab, ENTRAMBE le direzioni** | arXiv **2605.04004** pag. 5 | sweep di un estremo di sessione, ingresso a barra+1 | fade **T = −14,12**; con il grab **T = −13,24**; **n = 6.442** |
| **§4.1 — ORB pullback** | arXiv 2605.04004 pag. 4 | attesa del ritorno a 5 punti dal livello rotto | **80,7% di stop-out** su stop da 20 punti, n=83, netto −4,44 |
| **R42 — fade degli estremi d'apertura** | `REFERTO_ROUND42_FADE.md` | fade sul box 15'/35' | **0/24 IS e 0/24 OOS** |
| **R45 / famiglia ORB** | `REFERTO_ROUND45_LONDRA.md`, `SETACCIO_MANUALE.md` | rottura di box di sessione | **0/48**; ~**210 celle** a tick su 4 mercati |
| **capitolo M5 / capitolo M1** | `REGISTRO_TEST.md` §2, `CACCIA_M1_TFBASSO_2026-08-29.md` | breakout intraday a TF basso | chiuso a tick reali |
| **filtro appiccicato a motore già tarato** | `ROBUSTEZZA.md` §5B | R20 ADX, R12, R26, R45, R54 | **0 successi su 5** |

### 📌 Le tre frasi che ho usato come bussola

1. **CRT, misura del 31/08:** il gate ha tagliato **il 28% dei trade** e il PF
   **non si è mosso** (0,459 vs 0,462). 👉 Non è un problema di *selezione*: la
   perdita è **uniforme sulla popolazione**. Nessun gate nuovo può creare un
   edge che non c'è — ed è la ragione per cui **la pista 3 del mandato (altri
   filtri di regime sul CRT) non produce un candidato in questo dossier**:
   sarebbe il sesto "filtro appiccicato" di una serie che fa 0/5.
2. **Mesfin §6.2, la spiegazione strutturale** [VERIFICATO, pag. 11]:
   _"both of them use regime classification and **hold positions for 60–75
   minutes instead of 5–30 minutes** […] The longer hold period gives the signal
   enough room to generate net points above friction. **The ceiling applies
   specifically to single-bar directional predictions from publicly observable
   OHLCV features.**"_ e _"The two strategy types that avoid this ceiling share
   one feature: they **hold positions for 12–15 bars rather than 1–6**."_
3. **R42:** _"L'unica cosa che ha sempre pagato è il **RETEST**"_.

---

## 2. 🔬 LA DIAGNOSI DEL MORTO, LETTA NEL SORGENTE — e perché indica una sola uscita

Ho riletto `ABTG_CRT_TurtleSoup.mq5` per capire **cosa** esattamente è stato
falsificato. La geometria è tutta in quattro funzioni:

```
SegnaleCRT_Calc  (riga 235)  long: c2Bear && c1Bull && (l1 < l2) && (c1 > c2)
                              && (lowerWick1 >= wickFactor*body1)
SlWick_Calc      (riga 273)  SL = low(C1) − buffer      <- l'estremo del WICK
Tp1Mid_Calc      (riga 281)  TP1 = (h2+l2)/2            <- metà di UNA candela
Tp2Ext_Calc      (riga 290)  TP2 = high(C2)             <- l'estremo di UNA candela
```

**Il difetto non è il regime: è la GEOMETRIA, e si legge senza tester.**

| | il CRT | conseguenza |
|---|---|---|
| il "range" | **una sola candela M15** (C2) | il take massimo è l'ampiezza di **una** candela |
| lo stop | l'estremo del **wick di rifiuto**, e il pattern **pretende** un wick lungo (`wickFactor` 2,5-4,0 nella griglia) | **più il segnale è "bello", più lo stop è LONTANO** |
| il take | metà (TP1) di quella stessa candela | **più vicino dello stop, per costruzione** |
| la durata | dentro la candela successiva | **1-6 barre** = la classe che Mesfin dichiara sotto il soffitto di frizione |

> 🎯 **[INFERITO dalle righe 235-293]:** il CRT è un motore che chiede uno stop
> largo per pagare un target stretto, tenuto per poche barre. Non è un motore
> "in attesa del regime giusto": è un motore con il **rapporto premio/rischio
> rovesciato in codice**. E i **2.573 pattern** contati in 21 mesi (referto,
> DIAG) dicono che ogni candela M15 può essere un "range" — cioè che il livello
> **non è selettivo**.

👉 **Da qui esce l'unica direzione che il §4.3 non ha già falsificato:** tenere
l'inefficienza (falso breakout di un livello di range) ma cambiare **il livello**
(da 1 candela a un **range vero, multi-ora**), **il target** (dal mezzo di una
candela al **lato opposto di un box grande**) e **la durata** (da 1-6 barre a
un'intera sessione). È la sola uscita compatibile con la §6.2 del paper.

---

## 3. 📡 CONTROLLO POSITIVO — misurato oggi, 31/08, fonte per fonte

| fonte | HTTP | bersaglio noto verificato oggi | esito |
|---|---|---|---|
| **MQL5 Code Base** | **200** | id **68951** → titolo `Liquidity Sweep H4 - M15 (Swing Highs and Lows)`, autore **Osmar Sandoval Espinosa**, data **23/03/2026 13:23** — **identici** al censimento del 26/08 | 🟢 **PASSA** ⚠️ i `UserDownloads` **non sono più resi** nella conversione della pagina: oggi rende `Views: 6951`, `Rating (6)`. **Non li invento** |
| **arXiv API** | **200** | `id_list=2605.04004` → titolo, autore (**Mathias Mesfin**), abstract **verbatim** = quelli citati nei nostri dossier | 🟢 **PASSA in pieno**, e ha consegnato il §4.3 |
| **TradingView** (+ `pine-facade`) | **200** | tag `/scripts/ict/?script_type=strategies` → **11 strategie**, cioè **esattamente il conteggio registrato il 26/08** (`ict 11/11/11`) | 🟢 **PASSA.** `pine-facade` restituisce il `source` completo: verificato su **2 hash** |
| **GitHub** (via `WebFetch` + `raw`) | **200** | `n30dyn4m1c/crt-turtlesoup-ea` → MIT, 21 stelle, **`crt-ts.mq5` + 6 varianti di TF**, autore **Neo Malesa**, e il README descrive **la stessa geometria** del nostro EA (C2 range, C1 falso breakout, SL al wick di C1, TP1 midpoint, TP2 estremo opposto) | 🟢 **PASSA — ed è il miglior controllo possibile**: la fonte mi restituisce, verificabile, l'originale del motore che abbiamo tradotto |
| **GitHub — RICERCA** (`api.github.com`, `curl`) | **403** | — | 🔴 **NULLA — settima caccia di fila.** ⚠️ **Nota tecnica nuova e utile:** il 403 oggi porta un messaggio esplicito — _"sessions are bound to their configured repositories. Use repository-scoped endpoints"_ — e **anche `repos/{owner}/{repo}` risponde 403** (provato su 3 repo). Quindi: **API inutilizzabile in toto**, `WebFetch`+`raw` sì. `gh` non installato |
| **Forex Factory** | **403** | — | 🔴 **NULLA — settima di fila.** Resta **il buco più grave**: è l'unico posto dove si legge come una strategia è *invecchiata* |

### 🆕 Una fonte che i nostri dossier non hanno quasi mai usato: **MQL5 Articles**
Su 41 dossier di caccia, **2 soli** citano `mql5.com/en/articles` come fonte di
strategia. È un canale **distinto dal Code Base**, con **sorgente completo
allegato e gratuito**. Oggi ha reso due articoli in pieno bersaglio (§5, §6.3).

---

## 4. 🟢 IL PROMOSSO — uno solo

### 🥇 P1 — `BREAKIN DEL BOX NOTTURNO` esteso agli INDICI — **il falso breakout di un range VERO**

```
NOME            BREAKIN del box notturno (falsa rottura -> reversal)
ORIGINE         (a) SPEC DI CASA gia' scritta e MAI provata:
                    caccia_strategie/ANALISI_NIGHTLY_PDF_2026-08-23.md §7b
                    (proposta unica del referto, "nessun file prova scritto")
                (b) CONFERMA ESTERNA INDIPENDENTE, letta oggi:
                    https://github.com/martin254/Asian-Turtle-Soup-Trading-Bot
                    (15 stelle, QuantConnect Python, README letto)
                (c) SORGENTE DI LIVELLI, gratuito e attribuibile:
                    https://www.mql5.com/en/articles/19944 "All Sessions EA"
                    (Christian Benjamin, 27/10/2025, .mq5 allegato 32,86 KB)
MOTORE OSPITE   mql5/Experts/ABTG_LiquiditySweep.mq5 (1.176 righe, magic 772600)
LICENZA         (a) nostra · (b) [INCERTO: non dichiarata nel repo martin254]
                (c) termini MQL5 Articles. Attribuzione obbligatoria nel .mq5
```

**TESI IN UNA RIGA**
> _"Un range di sessione è il posto dove il mercato ha lasciato gli stop di tutti
> quelli che hanno dormito. Quando il prezzo lo buca e **rientra subito**, la
> rottura non aveva ordini dietro: chi era entrato sul breakout è ora dalla parte
> sbagliata di un livello che tiene, e il prezzo ha **tutto il box** da
> percorrere prima di incontrare il prossimo ostacolo."_

**MECCANICA — in tre righe** (fedele alla spec §7b, PAG 26/28 del PDF di corso)
1. **Il livello:** MAX e MIN della sessione notturna (**22:00–04:59 ora server
   BCM** [VERIFICATO in `ANALISI_NIGHTLY_PDF` §1.1, dedotto dai simboli `.bcm`
   negli screenshot; **D1 del referto la dà da confermare a Claudio**]).
   **NON** uno swing, **NON** una candela: un range di ~7 ore.
2. **Il grilletto:** barra che **viola** il livello e **richiude/riapre dentro**
   → ingresso reversal. `high[1] > MAXnotte` **E** `close[1] < MAXnotte` → SHORT,
   e simmetrico. Ingresso **nella sessione europea**, cioè **dopo** che il
   livello è chiuso.
3. **L'uscita:** SL **oltre l'estremo dello sweep** (`InpSLMode=0` +
   `InpSLBufferAtr`, già in codice); **TP al LATO OPPOSTO DEL BOX**.

**🔍 PERCHÉ NON È IL MORTO — confronto sui tre assi del C1**

| | **CRT (morto)** | **R95 (morto)** | **§4.3 Mesfin (morto)** | **P1** |
|---|---|---|---|---|
| **livello** | 1 candela M15 | swing 21 barre/lato | estremo di sessione recente | **box notturno di ~7 ore, con ampiezza misurabile** |
| **ingresso** | **immediato**, alla chiusura del wick | **immediato**, sul reclaim | **immediato**, a barra+1 | **differito**: il livello nasce alle 04:59, si opera nella **sessione europea** |
| **target** | metà / estremo della **stessa** candela | `InpTP_RR` fisso | orizzonti 1-6 barre | **lato opposto del BOX** |
| **durata** | 1-6 barre | 1-6 barre | 1-6 barre | **una sessione intera** = la classe 12-15 barre della §6.2 |

> ✅ **Cambia tutti e tre gli assi del C1.** Non è "un altro wickFactor": è un
> altro livello, un altro momento e un'altra geometria d'uscita.

🔴 **E ORA L'OBIEZIONE PIÙ FORTE, che scrivo io prima che la faccia Claudio.**
Il **grilletto** (buca e rientra) è **lo stesso** di R95, e il motore ospite
`ABTG_LiquiditySweep` **è** il motore di R95, misurato **0/30**. Inoltre il
livello di Mesfin §4.3 era _"a recent session high or low"_ — cioè **vicinissimo**
al box notturno.

**Perché lo promuovo lo stesso, e cosa lo salva o lo uccide:**
- R95 e §4.3 hanno falsificato **il grilletto con quel target e quella durata**.
  Nessuno dei due ha misurato **il grilletto con il target al lato opposto di un
  box da 7 ore**. La differenza non è cosmetica: è **esattamente la variabile**
  che la §6.2 identifica come l'unica che fa passare il soffitto di frizione.
- 🔬 **La prova che decide, dichiarata PRIMA:** il round deve girare il TP come
  **gradino di ablazione** — `TP al box opposto` **contro** `TP a RR fisso`
  (il controllo, cioè la geometria di R95). **Se vince l'RR fisso, P1 è R95 con
  un livello nuovo e si chiude lì.** Se vince il box opposto, la tesi della
  durata/taglia del take regge. Senza questa ablazione **P1 non è giudicabile**.

**BANDIERE ROSSE §4** — ✅ **nessuna**: il motore ospite ha già SL/TP veri al
broker, rischio in %, decisione **solo su barra chiusa [1]**, tetto livelli
anti-overflow, `InpUsaGuardian`, `InpMaxSpreadToStopPercent` (R55), e la regola
di consumo del livello dichiarata nell'header. Niente martingala/griglia/hedge.

**💰 COSTO (C2)** — **è il punto forte, ed è il motivo del promosso.** Il take
è **il lato opposto del box**. Su D30EUR il box notturno è tipicamente **decine
di punti indice** [STIMA — **da MISURARE al PASSO 0**, non stimata qui] contro
la soglia di **6,0**. Il CRT invece puntava a **metà di una candela M15**.
⚠️ **Il numero vero è la mediana del take LORDO REALIZZATO, e si misura.**

**📊 FREQUENZA [DA MISURARE]** — la spec §7b dichiara **~250 livelli/anno per
lato**. **Canarino, congelato prima:** se n IS < 150 → **"NON MISURABILE"**, non
"senza edge" (stessa disciplina di R89, che chiuse per **carenza di livelli**:
14 trade IS con `InpSwingBars=21` su H4 — ed è **esattamente il difetto che il
box notturno ripara**).

**🔧 COSA TERREI / COSA RIFAREI**
- **DA TENERE:** tutto il chassis `ABTG_LiquiditySweep` (SL strutturale, TP1/
  parziale, breakeven, Guardian, spread come % dello stop, conteggio livelli).
- **DA SCRIVERE (il solo codice nuovo):** `InpLivelloDaBoxNotturno` — una
  sorgente di livelli che sostituisce lo swing col MAX/MIN della finestra
  22:00–04:59 server, **+ un `InpMinBoxATR`** (pista 4 del mandato: il box opera
  solo se largo ≥ N×ATR). ⚠️ **In ATR relativo, MAI in punti assoluti** — è la
  regola candidata del 23/08, e il costo di ignorarla è già stato pagato: **3
  mercati spenti in silenzio** (`ANALISI_NIGHTLY_PDF` §6.3).
- **DA NON FARE:** accendere il filtro QB. È il parametro rotto del §5.1/§6.3.

**🏛️ IN OTTICA PROP** — 🟢 **la scorrelazione qui è strutturale, non estetica, e
va MISURATA subito.** La sedia viva `ABTG_MaxMinNotte_DAX_Short_Ottimizzato`
(magic **770411**) opera **il BREAKOUT dello stesso box**; P1 ne opera la
**falsa rottura**. Sono **mutuamente esclusivi per costruzione**: se la rottura
tiene paga la sedia viva, se fallisce paga P1. **[IPOTESI: correlazione negativa
— NON misurata]**, e la misura è a costo zero perché le serie per-trade
esistono. 🔴 **Ma la regola di rotta 1 (`ROTTA_PROP`) morde**: stesso box, stesso
simbolo → **mai le due a rischio pieno insieme** finché la correlazione non è
misurata. 🟡 E la misura del **91,1% delle notti che rompono un lato**
(`ANALISI_NIGHTLY_PDF` §370) dice che i segnali candidati sono tanti: serve un
**cap di operazioni al giorno** e la **peggior giornata** va letta, non solo il DD.

**PUNTEGGIO**
- [2] semplicità — il pezzo nuovo sono **due input**, il resto è chassis esistente
- [1] il filtro **È** il motore — il livello è costitutivo ✅, ma il **grilletto è
  ereditato da un motore 0/30**: **un punto in meno, e l'ablazione è obbligatoria**
- [2] tesi di mercato scrivibile — sì, ed è sopra
- [2] riempie un BUCO — **il fade del box notturno non esiste in flotta** (c'è
  solo il breakout), ed è il complemento anti-correlato di una sedia viva
- [2] testabile senza riscritture — **già MQL5, chassis nostro**: una sorgente di
  livelli, non un EA nuovo

## **VERDETTO: 🟢 PROVA — 9/10**
**PERCHÉ:** è l'unico candidato che cambia **tutti e tre** gli assi rispetto ai
tre motori falsificati, ed è l'unico la cui differenza cade **esattamente** sulla
variabile che il paper indica come l'unica che supera il soffitto di frizione.
Costa **una funzione**, non un EA.

---

## 5. 🟡 IN CODA — uno, e con la sua ipoteca dichiarata

### `Automating Trading Strategies in MQL5 (Part 46): Liquidity Sweep on Break of Structure (BoS)`

```
FONTE / URL     https://www.mql5.com/en/articles/20569
AUTORE / DATA   Allan Munene Mutiiria — 12/12/2025   [VERIFICATO sulla pagina]
SORGENTE        .mq5 completo mostrato e allegato all'articolo (gratuito)
[rango]         PAGINA LETTA E LOGICA ESTRATTA; il .mq5 NON scaricato oggi
```

**È la traduzione letterale delle piste 1 e 2 del mandato**, in un solo file:
lo swing dà la struttura (HH → BoS rialzista), lo sweep del **lato opposto**
(SSL: minimo bucato, chiusura sopra, candela rialzista) dà l'ingresso **LONG**.
Cioè: **sweep del minimo in uptrend → long**, con conferma strutturale.

- 🟢 Sweep valutato sulla **barra 1 chiusa** (`iLow(...,1) < swingLow &&
  iClose(...,1) > swingLow && iClose > iOpen`) → **niente repaint**.
- 🟢 SL all'estremo dello sweep + buffer; TP a RR (2:1).
- 🔴 **Lotto FISSO** (`LotSize`, es. 0,01) → §4, gestione da rifare.
- 🔴 **L'ipoteca vera:** il grilletto è **letteralmente R95** (0/30) e la
  direzione "col grab" è **§4.3, T = −13,24 su n = 6.442**. Il BoS è quindi un
  **filtro appiccicato** a un motore due volte falsificato — lo schema che in
  casa fa **0 successi su 5**.

**VERDETTO: 🟡 IN CODA — 5/10.** Si apre **solo** se P1 dà segno di vita, e
**solo** come gamba di ablazione (motore nudo vs +BoS) dentro un round che ha
già un motore che respira. **Non prima**, e non da solo.

---

## 6. 🧱 LE DUE SPECIFICHE DA TENERE AGLI ATTI (promosse come spec, non come EA)

Non sono candidati — sono **definizioni meccaniche** che risolvono difetti noti.

### 6.1 `maDistancePct` — un regime di compressione in **3 righe**, senza ADX
Da `Yuri Garcia Narrow State Strategy` (TradingView, 79 righe,
`created 2026-06-15`, `open_no_auth`), righe 26-27 **verbatim**:
```pine
maDistancePct = math.abs(ema20 - sma200) / sma200 * 100
isNarrowState = maDistancePct <= maxDistancePct     // default 1.5%
```
> 🎯 **È la pista 3 del mandato ("distanza da EMA di fondo"), in forma
> auto-scalante**: una **percentuale del prezzo**, quindi si ritara da sola fra
> D30EUR ed EURUSD, al contrario di ogni soglia in punti.
🔴 **Ma NON la propongo sul CRT**, e il motivo è misurato: il gate ADX ha già
tagliato il 28% dei trade **senza muovere il PF** (0,459 vs 0,462). Un secondo
gate su quel motore è il sesto "filtro appiccicato" di una serie 0/5.
Si registra **per altri motori**, dove il regime sia costitutivo dall'inizio.

### 6.2 Il RANGE come **alternanza di pivot** — una definizione di contrazione
Da `Liquidity Breakout - Strategy [presentTrading]` (**MPL 2.0**, riga 1;
201 righe; `created 2023-08-06`), righe 70-86: un box `top/btm` nasce quando si
incrociano un **pivot high più basso** e un **pivot low più alto**
(`pht == -1 and plt == 1`), con pivot **confermati** (`ta.pivothigh(length,
length)`) → **niente repaint**.
> 🎯 È un modo **meccanico e senza orologio** di dire "qui c'è un range", utile
> come **secondo braccio** del box notturno di P1 per i mercati senza una
> sessione notturna netta. Costo: zero, sono 15 righe.

---

## 7. 🗑️ GLI SCARTATI — uno per riga, col motivo che lo prova

### 7.1 Letti nel SORGENTE, riga per riga

| # | candidato | fonte | motivo dello scarto |
|---|---|---|---|
| S1 | **`SmartMoney_MTF_EA_v2.mq5`** (Apache-2.0, 7 stelle, 4 commit) — 1.555 righe, **49 `input`** | [github.com/SiyabongaDlamini/SmartMoney.MQ5](https://github.com/SiyabongaDlamini/SmartMoney.MQ5) | 🔴 **QUATTRO motivi, e il primo è un §4 secco.** (a) **REPAINT, in due funzioni distinte:** `DetectInternalStructureShift` decide su `iLow(Symbol(), InpEntryTF, **0**)` (riga **1034**) e `iHigh(..., **0**)` (riga **1072**), e `DetectConsolidationBreakout` su `iClose/iOpen(..., **0**)` (righe **969-970**) — **la barra in formazione**. Il segnale cambia dentro la barra (b) **È R95:** `DetectLiquiditySweep` = minimo dei 20 bar bucato + chiusura sopra. (c) La "conferma forte" è un **OR che collassa**: `closePosition > 0.6 \|\| wick/body >= 0.5 \|\| closePosition > 0.4` → di fatto *"chiusura nel 60% alto della barra"*, cioè quasi nulla. (d) `InpEntryTF = PERIOD_M1` = **capitolo chiuso** (29/08). 49 input = **3× il tetto** |
| S2 | **`Liquidity Breakout - Strategy [presentTrading]`** (MPL 2.0, 201 righe) | [tradingview.com/script/UUHabgvo](https://www.tradingview.com/script/UUHabgvo-Liquidity-Breakout-Strategy-presentTrading/) | 🔴 **Il titolo mente, e l'ho verificato per grep:** `liqup`/`liqdn`/`liqup_reach`/`liqdn_reach` compaiono **solo** nel blocco di disegno (righe 143-173) e **non toccano nessuna condizione d'ingresso** (righe 179-180: `bullishEntry = isbull`). La "liquidità" è un plot. In più: è un **BREAKOUT** del box (famiglia chiusa, ~210 celle), il filtro Supertrend è **commentato via** (`//and direction < 0`), l'ingresso usa `high[length]` = **12 barre di ritardo** sull'evento, **nessun TP**, `default_qty_type` dichiarato **due volte**, `stopLossType = "None"` ammesso |
| S3 | **`Yuri Garcia Narrow State Strategy`** (79 righe, 8 input) | [tradingview.com/script/x39mKkAp](https://www.tradingview.com/script/x39mKkAp-Yuri-Garcia-Narrow-State-Strategy-YGILS/) | 🟠 **SCARTO come EA, PROMOSSO come spec (§6.1).** Non è l'inefficienza del mandato: è una **continuazione di trend** (elephant bar o candela di inversione, allineata a SMA200), non un fade di sweep. In più `default_qty_value=2` (% del nozionale, non rischio) e **due `alert()` con `"secret":"YGCLOUD2025"` e una lista di `user_id` cablati** (righe 76, 79): è lo script di un **servizio di segnali**, non un lavoro di ricerca. Va detto |
| S4 | **`crt-ts.mq5` + le 6 varianti di TF** (MIT, 21 stelle) | [github.com/n30dyn4m1c/crt-turtlesoup-ea](https://github.com/n30dyn4m1c/crt-turtlesoup-ea/) | 🔵 **DOPPIONE — è il morto stesso.** Il README conferma riga per riga la geometria che abbiamo tradotto in `ABTG_CRT_TurtleSoup.mq5`: _"Candle2 Range candle; Candle1 False breakout with a long wick; Candle0 currently forming"_, SL al wick di C1, TP1 midpoint di C2, TP2 estremo opposto. Le 6 varianti (`CRTTS_H1/H4/Daily/Weekly/Monthly`) sono **lo stesso pattern su altri TF = C1 violato**. Non è uno scarto di merito: **è già stato misurato, 0/30** |
| S5 | **`All Sessions EA`** (art. 19944, Christian Benjamin, 27/10/2025) | [mql5.com/en/articles/19944](https://www.mql5.com/en/articles/19944) | 🟠 **SCARTO come EA, TENUTO come sorgente di livelli.** _"The EA focuses on visualization and alerts rather than automated trade execution"_: **nessun ingresso, nessuno SL, nessun TP, nessun sizing** → l'imbuto non ha nulla su cui girare. Ma traccia i range delle 4 sessioni con sorgente allegato: **è il pezzo di codice che serve a P1** |
| S6 | **`Asian-Turtle-Soup-Trading-Bot`** (15 stelle, Python/QuantConnect) | [github.com/martin254/…](https://github.com/martin254/Asian-Turtle-Soup-Trading-Bot) | 🟠 **SCARTO come EA (porting = riscrittura da Python; nessuna licenza dichiarata [INCERTO]), TENUTO come CONFERMA INDIPENDENTE di P1.** Il README descrive **la stessa struttura** arrivata da tutt'altra strada: range asiatico 00:00-08:00 UTC, breach ±1 pip, _"Monitor for price rejection"_ e **_"Enter on confirmation during London/NY overlap"_** — cioè **ingresso differito nella sessione successiva**, RR 1:2, **1% di rischio**. Che due fonti indipendenti (un PDF di corso italiano e un repo ICT) convergano sulla stessa geometria non è una prova, **ma è più di zero** |

### 7.2 Scartati al PRIMO TAGLIO (titolo/pagina, sorgente NON aperto — dichiarato)

| gruppo | quanti | motivo |
|---|---|---|
| **TradingView tag `liquidity`** — `[JOAT]` ×7, `Liquidity Sweep Rider`, `Master Sweep`, `Liquidity Sweep Breakout LSB`, `Liquidity Sweep Filter`, `US/SPY Financial Regime Index` | 12 | 🔵 **già setacciati** il 25 e 26/08 (`CACCIA_SMC_OB_FVG` §3.3-3.4). Ciò che è setacciato non si ricontrolla |
| **TradingView tag `ict`** — tutti tranne uno | 10 | 🔵 **già setacciati il 26/08**. ⚠️ **L'unico non ancora setacciato è `ICT Master Suite [Trading IQ]`** — non aperto oggi: è una *suite*, cioè la classe che il 26/08 ha già scartato per **costo di validazione > valore atteso** (§5E). **Lo dichiaro come non-guardato, non come scartato nel merito** |
| **TradingView tag `meanreversion`** | 22 | 🔴 **fuori bersaglio**: sono Bollinger / Z-score / VWAP / IBS. Non è l'inefficienza dello sweep, e in casa ci sono già `ABTG_BandFade` e `ABTG_MeanRevert`. 📌 Registro che **`IBS (Internal Bar Strength)`** e `3 Red / 3 Green` sono lì, per una caccia futura sul mean-reversion di indice |
| **TradingView tag `consolidation`** | 5 | 🔴 sono **breakout** di contrazione + volume: famiglia chiusa |
| **Code Base, cima della lista experts** — `Market Replay Tool` (76669), `Interactive Panel` (76534), `Basket Protective Close` (76518) | 3 | 🔴 **attrezzi, non strategie**: zero ingressi = niente da backtestare |
| **Code Base** — `Sniper Gold Hybrid **Recovery** EA` (76605) | 1 | 🔴 **§4 dal titolo**: "Recovery". Primo taglio, dichiarato |
| **Code Base** — `HybridMicrostructure` (76331), `Session ORB` (76153), `AAPL ORB` (76333), `GoldLondonBreakout` (75586), `KCI N-Matrix`, `Aegis Quantum`, `Market Miner`, `BlueMoon` | 8 | 🔵 **già setacciati** (16/08, 19/08, 21/08, 28/08, 29/08): ORB chiuso, scatole nere, e 76331 **già squalificato alla radice** il 29/08 |

### 7.3 ⛔ Tag TradingView che oggi rendono **ZERO strategie** (misurato, non supposto)
`falsebreakout` · `choch` · `rangebound` → _"Nothing here, yet."_
📌 **Da aggiungere al `PROMEMORIA_SBLOCCO_FONTI.md`**, accanto ai buchi già noti
(`previousdayhighlow`, `timeofday`, `powerhour`, `dailyrange`, `firsthour`).
**Su TradingView il "falso breakout" non esiste come tag**: chi lo cerca lì non
trova niente, e non perché la fonte sia rotta.

---

## 8. ⬜ COSA NON HO POTUTO VEDERE — dichiarato, non taciuto

| oggetto | perché, e cosa ci costa |
|---|---|
| 🔴 **Ricerca GitHub** (403 su `api.github.com`, **anche repo-scoped**; `gh` assente) | **Settima di fila.** Trovo repo solo passando da `WebSearch`, quindi **vedo ciò che è già indicizzato e popolare**, non ciò che è nuovo o piccolo |
| 🔴 **Forex Factory** (403) | **Settima di fila, e qui pesa il doppio**: su un meccanismo falsificato tre volte, i thread lunghi anni sono l'unico posto dove si legge *quando* ha smesso di funzionare e *perché*. **È il buco più grave del dossier** |
| 🔴 **SSRN** | Non interrogata oggi (403 nelle sei cacce precedenti). Non l'ho ritentata: **lo dichiaro invece di fingere di averla coperta** |
| 🟡 **Il `.mq5` dell'articolo 20569** | Ho letto **la pagina** e la logica che l'autore descrive col codice a schermo; **non ho scaricato l'allegato**. Il candidato è in coda, non promosso: la lettura completa si fa **se e quando** si apre |
| 🟡 **`ICT Master Suite [Trading IQ]`** | L'unica strategia del tag `ict` mai setacciata. **Non aperta** — §7.2 |
| 🔴 **I `UserDownloads` del Code Base** | Oggi la pagina non li rende più nella conversione (dà `Views` e `Rating`). **Nessun numero di popolarità in questo dossier**, e non ne invento |
| 🔴 **Lo SPREAD BCM MISURATO** su D30EUR/U30USD/NASUSD | **Ancora non esiste in repo.** Uso i **2,0 punti indice** dichiarati di `METRO_PROP` D4, marcati **[SPREAD NON MISURATO]**. Lo strumento (Code Base **74148**) è promosso dal 23/08 e **mai usato**: è la **quarta** caccia che lo scrive |
| ⚠️ **Nessun backtest eseguito qui** | In questo ambiente non esistono MT5 né Strategy Tester. **Nessun numero di questo dossier è stato misurato oggi**: quelli di casa vengono dai referti citati, quelli di fuori sono `[VERIFICATO su pagina]`, `[DICHIARATO]` o `[STIMA]` |
| 🔴 **I numeri di performance degli autori** | **Letti e NON usati.** `SmartMoney.MQ5` dichiara _"+43,3%, PF 1,20, 434 trade"_ su **XAUUSD M1**: **[DICHIARATO DALL'AUTORE, NON VERIFICATO]**, altro strumento, altro TF. **Non pesa su nessun punteggio** |

---

## 9. 📦 IL FILE PROVA DI P1 — **BOZZA**, e il motivo per cui resta bozza

⚠️ **Non lo committo in `prove/` e non è pigrizia: è la regola di casa.**
L'input `InpLivelloDaBoxNotturno` **non esiste ancora** in
`ABTG_LiquiditySweep.mq5` — l'ho verificato per grep. Un file prova che pinna un
input inesistente è **l'errore n.3 della `CHECKLIST_RIGA_DI_LANCIO`**, e MT5
**ignora in silenzio** un pin che non trova (è esattamente come è nato il falso
"0/8" del FiboH4, `REGISTRO_TEST.md` §2-bis). **Prima la funzione, poi il file.**

```
# IPOTESI: la falsa rottura di un RANGE DI SESSIONE (box notturno 22:00-04:59
#   server) e' un ingresso con edge quando il target e' il LATO OPPOSTO DEL BOX
#   - cioe' quando il take e' grande abbastanza da superare il soffitto di
#   frizione che ha ucciso il CRT (take = meta' di UNA candela M15).
#   L'edge sta nella TAGLIA DEL TAKE e nella DURATA, non nel grilletto.
#
# CRITERI DI ACCETTAZIONE (congelati PRIMA dei numeri):
#   PASSO 0 - FREQUENZA: livelli creati IS >= 150 per lato. Sotto ->
#             "NON MISURABILE" (canarino R89), non "senza edge".
#   PASSO 0 - COSTO: mediana del take LORDO >= 3 x 2,0 punti indice = 6,0.
#             Fra 2,5x e 3,5x: verdetto SOSPESO, si misura lo spread
#             (Code Base 74148) e si rilegge.
#   ABLAZIONE OBBLIGATORIA: TP al lato opposto del box CONTRO TP a RR fisso.
#             Se vince l'RR fisso -> e' R95 con un livello nuovo, SI CHIUDE.
#   RISCHIO (non si sospende mai, a qualunque n): DD <= 15% e peggior
#             giornata > -5,00%.
#   MERITO: PF OOS >= 1,10 con IS positivo, sui DUE LATI misurati separati.
#   SELEZIONE: centro dell'altopiano, MAI il picco (12 Spearman su 13
#             negative). La regola si dichiara INSIEME al numero.
#
# LIMITE DICHIARATO PRIMA: sugli indici BCM la finestra tick e' UN SOLO
#   REGIME (toro). Il MERITO e' provvisorio per costruzione; il RISCHIO
#   vale pieno (Emendamento della Finestra, regola B).
# CORRELAZIONE: stesso box della sedia viva 770411 (breakout). La
#   correlazione fra le due serie per-trade va MISURATA prima di
#   qualunque accensione simultanea (ROTTA_PROP, regola 1).

@SIMBOLO  D30EUR
@PERIODO  M15
@DAQUANDO 2024.09.26     <- MISURATO, REFERTO_SONDA_STORICO_17-08.md (COMPLETO)

InpLivelloDaBoxNotturno=1||1||1||1||N   <- DA SCRIVERE NEL CODICE: non esiste
InpMinBoxATR=0.0||0.0||0.5||1.0||Y      <- pista 4: il box opera se largo >= NxATR
InpTP_RR=0||0||2.0||4.0||Y              <- 0 = TP al lato opposto (la tesi);
                                        <- >0 = RR fisso (il CONTROLLO = R95)
InpSLMode=0||0||0||0||N                 <- strutturale, oltre lo sweep
InpSLBufferAtr=0.5||0.5||0.5||0.5||N
InpMinSLPts=<DA MISURARE>||0||0||0||N   <- C4/R109: pavimento OBBLIGATORIO
InpAllowLong=1||1||1||1||N              <- due lati, misurati separati (C5)
InpAllowShort=1||1||1||1||N
InpRiskPercent=1.0||1.0||1.0||1.0||N    <- 1% per confronto pulito
InpMaxTradesPerDay=2||2||2||2||N        <- cap giornaliero (muro prop -5.000)
InpUseSessionWindow=true||0||0||0||N    <- si opera nella sessione EUROPEA
```
**2 assi liberi** (`InpMinBoxATR` × `InpTP_RR`) = griglia da screening, non da
verdetto. ⚠️ La riga di lancio passa **prima** da
`backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` — inclusa la classe nuova
**skip-senza-`-Rifai`**, che nella saga CRT ha prodotto **4 corse zombie su 6**.

---

## 10. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> ### **Il falso breakout di un range paga quando il take è GRANDE — o non paga mai?**

**È la domanda giusta perché isola l'unica variabile che distingue P1 dai tre
motori già falsificati.** Il grilletto "buca e rientra" è stato misurato tre
volte da tre banchi indipendenti — R95 (0/30), il CRT (0/30 a tick), Mesfin §4.3
(n = 6.442, **entrambe le direzioni** negative) — e **tutte e tre le volte con un
target piccolo e una durata di 1-6 barre.**

La §6.2 del paper dice, testualmente, che è **proprio quello** il discriminante:
_"the ceiling applies specifically to single-bar directional predictions"_ e le
uniche due strategie che lo superano _"hold positions for 12-15 bars rather than
1-6"_.

**Quindi l'ablazione TP-al-box-opposto contro TP-a-RR-fisso non è un dettaglio
della griglia: è l'esperimento.** Se il TP grande non salva il grilletto, allora
la famiglia "sweep di liquidità" ha **quattro** falsificazioni indipendenti e
va chiusa come sono stati chiusi M5 e M1 — e quella sarà una risposta utile
quanto un promosso, perché smetteremo di cercarla.

---

_Dossier chiuso il 31/08/2026. **41 candidati guardati** su 6 fonti (4 vive, 2
nulle), **6 sorgenti letti riga per riga** (2 `.mq5`, 2 Pine, 1 Python via
README, 1 articolo con codice), **1 paper letto integralmente** (14 pagine),
**1 promosso, 1 in coda, 2 spec, 6 scarti motivati + 61 scarti al primo taglio**.
**Nessun backtest eseguito. Nessun numero d'autore usato in nessun punteggio.
Nessun EA modificato, nessun file in `prove/`, nessun magic toccato.**_
