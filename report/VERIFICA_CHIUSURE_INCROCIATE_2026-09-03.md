# 🔎 VERIFICA STORICA DELLE CHIUSURE INCROCIATE — è già successo in forward?

_03/09/2026 · repo `/home/user/GITHUB`, branch `lavoro` · **SOLO ANALISI: nessun
file EA è stato toccato.**_

**Mandato**: il punto 5 della proposta di fix di
`report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md` — _"prima di toccare
qualunque cosa, cercare sullo storico se una sedia Aperture 🟠 ha **già** chiuso
la posizione di un vicino"_ — con la clausola che se la si trova **l'ordine di
priorità si capovolge e i 🟠 passano davanti ai 🔴**.

---

## 🎯 RISPOSTA IN UNA RIGA

**ZERO candidati di chiusura incrociata. I 🟠 NON passano davanti ai 🔴.**
Anzi: la stessa passata ha trovato **la prima prova SUL CAMPO del difetto 🔴**,
indipendente dalla FOTO A dell'ORB — **4 giornate su 16** in cui `ABTG_ORB`
nativo ha aperto **il secondo lato che il suo pannello vieta**, e in **4 casi su
4** c'era un vicino a ticket più basso vivo per tutta la durata del primo trade.

---

## 📐 IL METODO, dichiarato prima dei numeri

### Fonti usate (e perché solo queste)
| fonte | cosa contiene | uso |
|---|---|---|
| `data/statements/trades_auto.csv` | **1264 posizioni CHIUSE**, conto piccolo, 30/03/2026 → 02/09/2026 | corpo della verifica |
| `data/statements/trades_100k.csv` | 23 posizioni chiuse, conto 100k, 10/08 → 02/09 | controprova |
| sorgenti `mql5/Experts/*.mq5` | orari di flat, magic di default, gate del codice | mappa regola↔codice |
| `mql5/Presets/**.set` + `FLOTTA_ATTIVA.md` | **valori configurati**, non i default | orari veri delle sedie vive |

❌ **Scartato**: `backtest_pipeline/risultati_prove/**/abtg_trades_*.csv` — sono
**uscite di Strategy Tester**, non forward. Nel tester l'EA è solo sul simbolo:
per costruzione il difetto lì non può comparire. `data/snapshots/*.json` sono
dati di mercato (SMA, pivot, fib), **non contengono posizioni**.

### Il filtro che rende la ricerca decisiva
L'exporter (`ABTG_TradeExporter.mq5:158-168`) scrive **il magic del deal di
APERTURA** e **il motivo dell'ultimo deal di CHIUSURA**. Quindi:

| `close_reason` | chi l'ha prodotto | può essere una chiusura incrociata? |
|---|---|---|
| `sl` / `tp` | server del broker | ❌ no |
| `manuale` (`DEAL_REASON_CLIENT`) / `mobile` | Claudio | ❌ no |
| `stopout` | broker | ❌ no |
| **`expert`** (`DEAL_REASON_EXPERT`) | **un EA ha mandato un ordine a mercato** | ✅ **è l'unico candidato possibile** |

Su 1264 posizioni: **706 sl · 388 tp · 101 mobile · 44 manuale · 19 `expert` ·
6 stopout**. **L'universo da esaminare sono 19 righe** (+2 sul 100k). Le ho
guardate **tutte e ventuno, una per una.**

### ⚠️ UNA CORREZIONE ALLA PREMESSA DELL'AUDIT — misurata, non opinata
L'audit dice: _"`PositionSelect(_Symbol)` seleziona la posizione **più vecchia**
del simbolo"_. **La formulazione giusta è: la PRIMA della lista interna, cioè
quella con il TICKET/`position_id` più basso** — che di solito, ma **non
sempre**, è anche la più vecchia in orologio.

La differenza non è teorica: **una posizione nata da un ordine PENDENTE eredita
il ticket del pendente**, timbrato quando l'ordine è stato *piazzato*, non
quando è stato *riempito*. Tutti i motori a BuyStop/SellStop (ORB, MaxMinNotte,
Aperture breakout) piazzano a inizio sessione: **entrano in lista "vecchi"
anche se si riempiono per ultimi.**

**Misura sul nostro storico:** su **170 coppie** di posizioni contemporanee
sullo stesso simbolo, di **magic diversi**, aperte a più di 60 secondi di
distanza, **28 (16,5%) hanno l'ordine per ticket INVERTITO rispetto all'ordine
per orologio.** Un caso su sei.

**Esempio che si legge da solo — D30EUR, 24/07:**

| pid (= ordine di selezione) | magic | apertura |
|---|---|---|
| **2898578** | 770401 `MaxMin BUY` (entra da BuyStop piazzato alle 07:59) | **08:01:08** |
| 2898603 | 770103 `DAX Live 5m BUY` (entra a mercato) | **08:00:24** |

Il MaxMin è aperto **44 secondi DOPO** e ha comunque il **ticket più basso**.
Ed è provato da come si è comportato: quel giorno `ABTG_MaxMinNotte` (che è 🔴,
tutta la sua `ManagePos()` è dietro `if(!SelPos()) return;`) **ha eseguito
parziali e chiusura regolarmente** — cosa impossibile se `PositionSelect` avesse
restituito il Live5m.

📌 **Per questo tutta l'analisi qui sotto ordina i vicini per `position_id`, non
per orario.** È la stessa cosa nell'83,5% dei casi e la cosa GIUSTA nel 100%.

---

## 1️⃣ PASSATA A — le 19+2 chiusure `expert`, una per una

Per ognuna: chi altro era **vivo** su quel simbolo in quell'istante, e chi aveva
il ticket più basso (= chi avrebbe incassato una `PositionClose(_Symbol)`).

| # | data ora | simbolo | magic aperto | commento | reason | vicini vivi | verdetto |
|---:|---|---|---|---|---|---:|---|
| 1 | 06/05 17:00:00 | XAUUSD | 20260001 | NIGHT_BREAK_BOX | expert | **0** | flat proprio |
| 2 | 07/05 17:00:00 | XAUUSD | 20260001 | NIGHT_BREAK_BOX | expert | **0** | flat proprio |
| 3 | 08/05 17:00:00 | XAUUSD | 20260001 | NIGHT_BREAK_BOX | expert | **0** | flat proprio |
| 4 | **24/07 08:17:34** | **D30EUR** | **770401** | MaxMin BUY | expert | **2** | 🔍 **esaminata a parte, sotto** |
| 5 | 24/07 14:35:00 | NASUSD | 770601 | ORB SELL | expert | 0 | gestione propria |
| 6 | 28/07 17:30:00 | D30EUR | 770101 | DAX Apertura EU SELL | expert | **0** | **flat proprio (17:30 = suo)** |
| 7 | 07/08 17:30:00 | U30USD | 770202 | Dow Apertura US BUY | expert | **0** | **flat proprio (17:30 = suo)** |
| 8 | 11/08 17:30:00 | XAUUSD | 770402 | MAXMIN ORO SELL | expert | **0** | flat proprio (`.set` 17:30) |
| 9 | 13/08 17:30:00 | XAUUSD | 770402 | MAXMIN ORO SELL | expert | **0** | flat proprio |
| 10 | 19/08 00:00:01 | GBPUSD | 772345 | LARRY GBPUSD S | expert | 1 (ticket più alto) | flat di mezzanotte proprio |
| 11 | 20/08 00:00:01 | EURCAD | 772346 | LARRY EURCAD L | expert | 0 | flat proprio |
| 12 | 24/08 16:00:00 | EURJPY | 772361 | COST EURJPY L | expert | 0 | uscita propria |
| 13 | 24/08 17:30:00 | XAUUSD | 770402 | MAXMIN ORO BUY | expert | **0** | flat proprio |
| 14 | 26/08 00:00:03 | EURJPY | 772361 | COST EURJPY L | expert | 0 | uscita propria |
| 15 | 26/08 08:31:39 | D30EUR | 770411 | MAXMIN DAX SHORT | expert | 0 | 🟢 EA, gestione propria |
| 16 | 26/08 17:30:00 | XAUUSD | 770402 | MAXMIN ORO SELL | expert | **0** | flat proprio |
| 17 | 28/08 17:30:00 | D30EUR | 770101 | DAX Apertura EU RETEST BUY | expert | **0** | **flat proprio (17:30 = suo)** |
| 18 | 31/08 00:00:00 | U30USD | 772341 | LARRY DOW L | expert | 1 (ticket più alto) | flat di mezzanotte proprio |
| 19 | 02/09 07:47:28 | GBPUSD | 772345 | LARRY GBPUSD S | expert | 0 | uscita propria |
| 20 | 26/08 08:31:39 | D30EUR | 770411 | _(conto 100k)_ | expert | 0 | 🟢 EA |
| 21 | 28/08 17:30:00 | D30EUR | 770101 | _(conto 100k)_ | expert | 0 | flat proprio |

**Nessuna riga ha la firma della chiusura incrociata**, che sarebbe:
_posizione di magic X chiusa `expert` a un orario che è il flat di un ALTRO EA
🟠 sullo stesso simbolo, mentre X aveva il ticket più basso._
Le 8 chiusure alle 17:30 appartengono **tutte** a EA il cui `InpCloseHour` è
17:30 (verificato nei `.set`: `sedia_ABTG_DAX_Apertura_EU_770101.set`,
`sedia_ABTG_Dow_Apertura_US_770202.set`, `sedia_MAXMIN_ORO_770402.set`), e in
tutte e 8 **non c'era nessun altro aperto sul simbolo**.

### 🔍 La riga n.4, l'unica che meritava di essere aperta
`pid 2898578` · D30EUR · 770401 `MaxMin BUY` · 24/07 08:01:08 → **08:17:34**,
`expert`, +182,95. È **l'unica** chiusura `expert` di tutto lo storico con dei
vicini vivi *e* con un vicino aperto prima in orologio.

**Non è una chiusura incrociata, ed è dimostrabile:** se un EA avesse sparato
`PositionClose("D30EUR")` alle 08:17:34, avrebbe colpito **il ticket più basso**
del simbolo. Il ticket più basso in quel momento **era proprio il 770401
stesso** (2898578, vedi tabella dei pendenti sopra). Quindi la posizione chiusa
è **quella che il difetto avrebbe scelto comunque**: il colpo è andato a segno
sul legittimo proprietario. Nessun vicino è stato toccato — e infatti il
`DAX Live 5m` 770103 è sopravvissuto fino alle 08:21:15 chiudendo in **TP**, e
il `DAX Apertura EU` 770101 fino alle 08:21:35 in SL.
👉 **Interpretazione**: è la gestione di `ABTG_MaxMinNotte` (parziali +
`PositionClose` del 3° target EMA200, righe 320/342/352) che ha lavorato
**correttamente**. Il rapporto profitto/movimento (182,95 su 250,75 teorici =
73%) conferma che i parziali erano già scattati.

---

## 2️⃣ PASSATA B — quante volte il difetto ha avuto l'OCCASIONE di sparare

Perché "zero trovati" vuol dire poco se l'occasione non si è mai presentata.
Ho contato le **occasioni**, non solo gli esiti: ogni volta che un EA con
scrittura per simbolo è arrivato alla **sua ora di flat con la PROPRIA posizione
ancora aperta**.

| esito | n |
|---|---:|
| eventi di flat con posizione propria viva (tutti i magic 🟠+🔴 in campo) | **7** |
| di cui con **almeno un vicino vivo** sul simbolo | **0** |
| di cui con vicino a **ticket più basso** (= difetto ARMATO) | **0** |

Dettaglio: `770101` × 2 (28/07, 28/08) · `770202` × 1 (07/08) · `770402` × 4
(11, 13, 24, 26/08). Gli altri magic Aperture (`770102`, `770201`, `770203`,
`770211`, `770250`) hanno **sempre** chiuso in SL o TP **prima** dell'ora di
flat: per loro il ramo `EndOfSession()` non ha mai chiuso niente.

**Sui 🟠 in senso stretto le occasioni sono 3.** Tre. Con n=3 e zero eventi,
**l'assenza di prova NON è prova di assenza** — è un campione che non permette
di concludere in nessuna delle due direzioni. È esattamente la valvola di R59
("il campione sottile sospende il giudizio sul MERITO, mai sul RISCHIO"): qui
sospende il giudizio sul fatto che il danno sia **avvenuto**, non sul fatto che
sia **possibile**.

### ✅ E il secondo ramo di scrittura cieca è SPENTO, misurato
L'altra `PositionClose(_Symbol)` dei 🟠 è il **flatten news**
(`ABTG_Dow_Apertura_US.mq5:609` e gemelle). Non può aver sparato:
- `InNewsBlackout()` (riga 511) esce subito con
  `if(!InpUseNewsFilter || gNewsCount == 0) return(false);`
- **`data/abtg_news.csv` è un file VUOTO (0 righe)** → `gNewsCount` è sempre 0
- e nei `.set` delle sedie vive `InpUseNewsFilter=false`.

👉 **In tutto il forward il flatten news non è mai stato eseguito.** Il ramo
esiste nel codice ma è morto in campo. Va corretto lo stesso, ma **non ha
prodotto storia**.

---

## 3️⃣ PASSATA C — l'ALTRA metà del mandato: OCO cieco e `OneTradePerDay`

Qui la ricerca **ha trovato**. E ha trovato sul lato 🔴.

### 📊 `ABTG_ORB` nativo (NASUSD, magic 770601) — 16 giornate operative

| giorno | vicino a ticket più basso vivo per TUTTA la vita del 1° trade? | 2° lato riempito? |
|---|---|---|
| 20/07 | ✅ **SÌ** — `Nasdaq Live 5m` 770203, pid 2852307, 14:30:04→14:39:05 | ✅ **SÌ** |
| 30/07 | ✅ **SÌ** — `STREV NAS H1` 970913, pid 2945736, 00:00:00→15:27:43 | ✅ **SÌ** |
| 31/07 | ✅ **SÌ** — `Nasdaq Live 5m` 770203, pid 2965050, 14:30:22→14:35:01 | ✅ **SÌ** |
| 06/08 | ✅ **SÌ** — `Nasdaq Live 5m` 770203, pid 3092171, 14:30:02→14:31:23 | ✅ **SÌ** |
| altri 12 giorni | ❌ no (o copertura solo parziale) | ❌ **no**, 12 su 12 |

**Tavola di contingenza: cieco+2 lati = 4 · cieco+1 lato = 0 · vede+2 lati = 0 ·
vede+1 lato = 12.** Separazione perfetta, 16 giorni su 16.
Per confronto, la probabilità che 4 giorni scelti a caso su 16 coincidano
esattamente con i 4 "doppi" è **1 su 1820**.

**La catena causale, riga per riga:** `ABTG_ORB.mq5:450`
`void HandleOCO(){ if(SelPos()) CancelPendings(); }`. Con un vicino a ticket più
basso `SelPos()` è falso → **il pendente opposto non viene mai cancellato** →
si riempie anche l'altro lato. Nei 12 giorni "puliti" l'OCO ha funzionato e il
secondo lato non è mai arrivato.

**Le 4 seconde operazioni non autorizzate:**

| giorno | 1° lato | 2° lato (NON autorizzato) | P/L 2° lato |
|---|---|---|---|
| 20/07 | BUY 14:30:51 → tp | SELL 14:57:21 → tp | **+70,52** |
| 30/07 | SELL 14:33:27 → sl | BUY 14:35:37 → tp | **+86,08** |
| 31/07 | BUY 14:30:24 → tp | SELL 14:40:19 → tp | **+90,02** |
| 06/08 | BUY 14:30:28 → sl | SELL 14:31:24 → sl | **−45,47** |
| | | **totale** | **+201,15 EUR** |

⚖️ **Da dire con onestà, perché è la parte scomoda: i trade che l'EA non doveva
fare hanno GUADAGNATO.** Questo **non** è un argomento per tenersi il difetto —
è **fortuna su un campione di quattro**. Il fatto misurato è che
`ABTG_ORB` nativo ha eseguito **20 operazioni in 16 giornate** dove il contratto
ne prevedeva **al massimo 16**: **+25% di frequenza rispetto al pannello**. È un
difetto di **RISCHIO** (criterio B delle FIRME 18/08: _"si boccia se avrebbe
fatto un drawdown"_ — qui: si corregge perché la frequenza reale non è quella
promessa), non di merito.

✅ **Una buona notizia, misurata**: nei 4 casi il secondo lato si è aperto
**sempre DOPO** la chiusura del primo (scarti: 19m26s · 5s · 7m13s · 24s).
**Zero sovrapposizioni** → **il "DOPPIO del rischio contrattuale simultaneo"
temuto dall'audit NON si è verificato.** La forma reale del danno è più mite di
quella prevista: un trade in più al giorno, non due posizioni insieme.

### 📊 Gli altri motori a OCO
| EA | giornate | giorni ciechi | 2° lato |
|---|---:|---:|---|
| `ABTG_ORB_Ottimizzato` 770611 U30USD | 6 | **2 con copertura piena** (19/08 e 21/08, entrambe `SW DOW H2` 770531) + 2 parziali | **0** |
| `ABTG_MaxMinNotte` oro 770402 XAUUSD | 5 | **0** | 0 |
| `ABTG_MaxMinNotte` DAX 770401 D30EUR | 2 | **0** | 0 |
| `ABTG_MaxMinNotte_DAX_Short_Ott` 770411 (🟢) | 5 | — | 0 |

📌 Le due giornate cieche del `ORB_Ottimizzato` (19/08, 21/08) **coincidono al
giorno** con quelle già misurate a mano in
`ORB_GEMELLI_DIVERGENZA_2026-08-22.md:366-367`. **Ricostruite qui in modo
indipendente, dal solo CSV.** La terza (02/09, `LARRY DOW S` 772341) risulta
solo "parziale" perché **quella posizione è ancora APERTA** e quindi non è nel
CSV dei chiusi — vedi limiti.
📌 Sul `ORB_Ottimizzato` il secondo lato non è arrivato perché lì
`InpOneTradePerDay` **è** letto (fix 08/08, righe 276-281) e perché il pendente
opposto scade prima; ma quel ramo è a sua volta dietro `SelPos()`.

### 🚨 SCOPERTA COLLATERALE — un input che il pannello mostra e il codice non legge
```
ABTG_ORB.mq5:54          input bool InpOneTradePerDay = true;   <-- MAI usato altrove nel file
ABTG_MaxMinNotte.mq5:65  input bool InpOneTradePerDay = true;   <-- MAI usato altrove nel file
```
In **entrambi** i file l'input è **dichiarato e mai letto**: unica occorrenza
nel sorgente. Solo `ABTG_ORB_Ottimizzato` lo usa davvero. Nel `.set` in campo
(`ABTG_Nasdaq...`/`ABTG_ORB_US.set`) è `InpOneTradePerDay=true`:
**il pannello dice una cosa che il codice non fa.** È lo stesso difetto già
trovato e corretto sugli Aperture il 05/08 (vedi il commento a
`ABTG_Dow_Apertura_US.mq5:707-718`), rimasto qui.

### ✅ E i 🟠 su questo fronte sono PULITI — con una data che lo prova
`770101` mostra 32 posizioni in 25 giornate, con 28/07 (2), 29/07 (3) e 30/07
(5). **Sono TUTTE e tre PRIMA del 05/08**, cioè prima che la guardia
`HaGiaOperatoOggi()` esistesse. Dopo il 05/08: **zero giornate con più di una
posizione**. E quella guardia **non usa `PositionSelect`**: filtra lo storico
per `DEAL_SYMBOL` **e** `DEAL_MAGIC` (`ABTG_Dow_Apertura_US.mq5:740-745`), quindi
è **hedge-safe e immune** al difetto di questo audit.
👉 Le giornate multiple dei 🟠 di fine luglio **non c'entrano con questo audit**:
sono un difetto diverso, già corretto, e la correzione **ha tenuto**.

---

## 4️⃣ Una cosa che la lettura del codice ha aggiunto (non osservata in campo)

`ABTG_Dow_Apertura_US.mq5:613-618` (e identico in tutti e 5 gli Aperture:
`DAX_Apertura_EU:675` · `DAX_Apertura_EU_Ott:491` · `Nasdaq_Apertura_US:703` ·
`Nasdaq_Apertura_US_Ott:492`):

```
if(TimeInMinutes(now) >= InpCloseHour*60 + InpCloseMin)
  { EndOfSession(); return; }
```

**Non c'è nessuna guardia su `gPhase`.** `EndOfSession()` mette `gPhase=PH_DONE`,
ma il blocco sopra **non lo guarda**: da 17:30 fino al cambio di giornata,
`EndOfSession()` viene rieseguito **a ogni tick**, e dentro c'è
`if(InpCloseAtEnd && SelectMyPosition()) gTrade.PositionClose(_Symbol);`.

🔥 Conseguenza da dichiarare: se la propria posizione **esiste ma non è la prima
in lista**, il ciclo non si ferma dopo un colpo. Chiude il ticket più basso →
al tick dopo `SelectMyPosition()` è **ancora vero** (la nostra è ancora lì) →
chiude il successivo → **finché la propria non diventa la prima e viene chiusa
anche lei.** Il danno potenziale non è "un trade del vicino": è **tutti i vicini
a ticket più basso, in pochi secondi.**

📌 **È una lettura del sorgente, NON un fatto osservato.** In forward non è mai
successo (0 occasioni su 7, passata B). Ma cambia la **gravità attesa** del
difetto 🟠, e va scritta agli atti perché quando le occasioni arriveranno il
conto non sarà lineare.

---

## 📋 LIMITI DICHIARATI DI QUESTA VERIFICA

1. 🚨 **Il CSV contiene solo posizioni CHIUSE.** Le posizioni **ancora aperte
   oggi** (03/09) — a partire da `LARRY DOW S` 772341, aperta il 01/09 08:45 e
   protagonista della FOTO A — **non ci sono**. Il censimento dei vicini è
   quindi un **limite INFERIORE**: alcune finestre di cecità sono invisibili.
   È esattamente perché è successo che il 02/09 risulta "parziale" invece di
   "cieco pieno".
2. **La finestra è 30/03 → 02/09/2026, ~5 mesi**, e molte sedie 🟠 sono nate
   dentro questa finestra (la GATED SHORT 770250 è del 30/08: **0 operazioni**
   nello storico). Il campione delle occasioni è **n=3 sui 🟠**: troppo sottile
   per concludere.
3. **Il magic dell'ordine di CHIUSURA non è esportato**, solo quello di
   apertura. Quando l'ora di chiusura coincide con il flat del proprietario
   **e** di un vicino (17:30 sul D30EUR è di 770101 *e* 770111 *e* 770311),
   dal CSV **i due casi sono indistinguibili**. Qui non ha morso perché in
   tutte e 8 le chiusure alle 17:30 **non c'erano vicini vivi**, ma è un buco
   strutturale: 👉 **se si vuole la prova diretta in futuro, serve il magic del
   deal di uscita nell'exporter** (una riga: `DEAL_MAGIC` sul deal `OUT`).
4. **"Ticket più basso = primo selezionato" resta una premessa**, non una misura
   diretta: nessuno ha eseguito qui un test `PositionSelect` su conto hedging.
   È però **coerente con 16 giornate su 16** dell'ORB nativo e con il caso
   770401 del 24/07, che la formulazione "più vecchia in orologio"
   **contraddice**.
5. **Niente è stato compilato o testato**: qui non c'è MetaEditor né Strategy
   Tester. Ogni numero viene da `file:riga` del repo o dai due CSV.

---

## ⚖️ IL VERDETTO CHE L'AUDIT ASPETTAVA

> _"Se la si trova, l'ordine di priorità si capovolge: i 🟠 salgono sopra i 🔴."_
> — `AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md`, proposta punto 5

### 🚫 NON si è trovata. **I 🟠 NON passano davanti ai 🔴.**

**Perché, in tre punti:**

1. **Zero chiusure incrociate in 21 chiusure `expert` esaminate una per una**, e
   **zero occasioni** in cui il difetto fosse anche solo armato (0 vicini vivi
   su 7 eventi di flat). Il danno **attivo** che avrebbe capovolto la classifica
   **non è agli atti**.
2. **Il danno PASSIVO dei 🔴 invece è agli atti, e per la prima volta con dei
   numeri**: 4 giornate su 16 di `ABTG_ORB` nativo con **il secondo lato aperto
   contro il pannello**, correlate 4 su 4 con la presenza di un vicino a ticket
   più basso. Più le 2 giornate cieche del `ORB_Ottimizzato` ricostruite in
   modo indipendente. **Il difetto 🔴 ha prodotto storia; il difetto 🟠 no.**
3. **L'ordine di gravità dell'audit regge così com'è**, e questa verifica gli
   aggiunge la ragione empirica che gli mancava:
   **(1) `ABTG_ORB_Ottimizzato` → (2) `ABTG_MaxMinNotte` → (3)
   `Gold_Ichimoku_TK_ATR_EA` → (4) i due Aperture 🟠.**

### ➕ Due voci da AGGIUNGERE alla coda dei fix (non erano nell'audit)

| # | intervento | perché adesso |
|---|---|---|
| **A** | **`ABTG_ORB.mq5` (nativo) sale nella coda**: era catalogato ☠️ "morto in osservazione", ma è **l'unico EA con il difetto MISURATO in forward** oltre al gemello. Non solo la sua osservazione è sporca: **sta facendo il 25% di trade in più del contratto** | è l'unico caso provato, e prova il meccanismo per tutti gli altri |
| **B** | **`InpOneTradePerDay` dichiarato e mai letto** in `ABTG_ORB.mq5:54` e `ABTG_MaxMinNotte.mq5:65` — **il pannello mente**. Fix indipendente dal difetto hedging, e **da fare per primo perché costa due righe e non tocca la selezione delle posizioni** | regola di casa: una variabile alla volta, e si parte da quella che non può rompere niente |

### 🧭 E una richiesta operativa
**Rifare l'export di `trades_auto.csv` includendo le posizioni APERTE** (o
almeno la FOTO del tab Trade) **e il `DEAL_MAGIC` del deal di uscita.** Senza
quei due campi questa verifica non potrà mai essere conclusiva: oggi sappiamo
dire "non è successo nei casi che vediamo", non "non è successo".

---

_Verifica del 03/09/2026. Nessun EA modificato, nessun fix scritto, come da
mandato. Prossimo passo su firma di Claudio: la coda dei fix resta quella
dell'audit, con `ABTG_ORB` nativo promosso e il fix dell'input morto come
antipasto._

---

## 🍽️ ANTIPASTO ESEGUITO (repo-only) — 03/09/2026

**Voce B della coda qui sopra: `InpOneTradePerDay` dichiarato e mai letto.
Scelta (a) — IMPLEMENTATO — per TUTTI E DUE gli EA.** Nessuna rimozione
dall'input: in entrambi i casi il comportamento promesso è realizzabile senza
stravolgere l'EA, quindi si è preferito far dire il vero al pannello invece di
cancellargli la promessa.

| EA | prima | dopo | cura |
|---|---|---|---|
| `mql5/Experts/ABTG_ORB.mq5` | v1.00, input dichiarato e mai letto | **v1.01** | **(a)** implementato |
| `mql5/Experts/ABTG_MaxMinNotte.mq5` | v1.10, input dichiarato e mai letto | **v1.11** | **(a)** implementato |

**Semantica**, la stessa del gemello che ce l'ha funzionante
(`ABTG_ORB_Ottimizzato` v1.04, ramo `gHadPos`), in due rami:
1. **non si riarma/ripiazza** una giornata già operata (`PuoArmare_Calc`);
2. **finito il trade del giorno, i pendenti superstiti si cancellano**
   (`GiornataSpesa_Calc`), che è il buco da cui rientrava il trade in più.

**Hedge-safe per costruzione, il difetto 🔴 non entra da questa porta.** La
conoscenza "oggi ho già operato" **non passa da `SelPos()`/`PositionSelect(_Symbol)`**:
scorre `PositionsTotal()` filtrando **simbolo + magic** e legge lo **storico del
giorno** filtrando `DEAL_SYMBOL` + `DEAL_MAGIC` — lo stesso pattern che questo
documento dichiara immune (`ABTG_Dow_Apertura_US.mq5:740-745`), compresa la
distinzione **"non lo so" ≠ "no"** su `HistorySelect` non ancora sincronizzato.

### ⚠️ Quello che l'antipasto NON fa (per non sovravvendere)
- **Non tocca `SelPos()`** in nessuno dei due file: il difetto 🔴 C9 resta
  intero e **conserva la sua priorità nella coda**. In particolare **non
  impedisce che il secondo lato si apra MENTRE il primo è vivo** (le 4 giornate
  su 16 misurate qui sopra): chiude solo la **riapertura DOPO** che il trade del
  giorno è finito.
- **Nessuna compilazione, nessun backtest**: in questo ambiente non esistono
  MetaEditor né Strategy Tester. È stato aggiunto un **autotest a tavolino**
  (4 blocchi / 24 casi per file, tabelle di verità complete, gira in `OnInit`)
  che prova **solo i predicati puri**, non le risposte del terminale.

### 📐 Impatto atteso sui numeri — diverso nei due EA, e va detto
- **`ABTG_ORB` — atteso INERTE nel tester.** Lì l'EA è solo sul simbolo,
  `SelPos()` non è mai cieco e `HandleOCO()` cancella il pendente opposto
  nell'istante in cui la posizione nasce: di superstiti da cancellare non ce
  n'è. **Morde in CAMPO**, dove il difetto 🔴 li lasciava vivi — cioè
  esattamente sul **+25% di frequenza rispetto al contratto** misurato qui.
- **`ABTG_MaxMinNotte` — può cambiare i numeri anche nel tester.** Fino alla
  v1.10 un pendente superstite lo toglieva solo il **cutoff**: una giornata che
  apriva e chiudeva **prima** del cutoff restava scoperta e poteva fare il
  secondo trade. Attesi **meno trade**; profit factor e drawdown **si misurano**.
- In entrambi, **`InpOneTradePerDay=false` riproduce la versione precedente
  esatta**: il confronto con/senza si fa a parità di tutto il resto.

### 🪑 Sedia viva — `ABTG_MaxMinNotte` sull'ORO (magic 770402)
La modifica è **solo nel repo e oggi è INERTE**: la `.ex5` che gira sul VPS non
cambia finché non viene **ricompilata e ricaricata**. **Alla prossima
ricompilazione il comportamento cambia davvero**, nella direzione di *meno*
trade. Prima di sostituire la sedia viva va rifatto il **backtest di
riferimento** con e senza il flag.

### 📌 Residuo noto, dichiarato e non corretto qui
`ABTG_ORB` **non ha** la guardia anti-duplicato al riavvio che
`ABTG_MaxMinNotte` ha già in `OnTick`. Il nuovo ramo `PuoArmare_Calc` copre il
caso "oggi ho già operato", ma **non** il caso "ho già dei pendenti piazzati e
il terminale è ripartito". Voce separata, non aperta in questo giro.
