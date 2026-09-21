# 🎯 IL NUMERO VERO DELLE SEDIE — lo slippage, misurato e composto con lo spread FTMO

**21/09/2026** · branch `lavoro` · **SOLA LETTURA e POST-PROCESSING**
🛑 Nessun backtest lanciato, nessun EA, nessun preset, nessun parametro, nessuna taglia,
nessun rischio. Sul conto reale **10105439** ho **letto un file di dati e basta**. Il runner
resta fuori perimetro e i round, da oggi, girano sul PC di backtest (firma del 21/09).

> ### ❓ LA DOMANDA DI CLAUDIO
> *«23.321 su 100.000 è A BOTTINO PIENO secondo me. Devi calcolare che spesso col trailing
> il prezzo torna e tocca lo stop ed il profitto è minore.»*

---

# 0️⃣ 🥇 LA RISPOSTA IN CINQUE RIGHE

1. 🔴 **Sul MECCANISMO il `Profit` del tester è già netto**, e adesso l'ho contato io deal per
   deal: `pertrade_00_metro_763400.csv`, **517 righe**, somma **+23.321,47 €** — identica al
   tester. **Lorde: vincite 67.858,01 · perdite 44.536,54 · PF 1,52365.** I ritorni sullo stop
   di cui parla Claudio **sono dentro quelle 44.536,54**, non fuori.
2. ✅ **Ma sul MERITO Claudio ha ragione lo stesso, e il numero è misurato: dal vivo è meno.**
   Quanto meno dipende dalla scala, e la scala è congelata qui sotto (§4).
3. 🔴 **E LA SCOPERTA DELLA GIORNATA RIBALTA IL CONTO IN MEGLIO**: *«Latenza zero, esecuzione
   ideale»* **NON vuol dire stop riempiti al livello.** Il tester a tick reali chiude lo stop
   al **primo tick oltre**, e quello scarto in casa è **già misurato su 484 stop**: mediana
   **0,40**, media **0,91** punti indice. 👉 **Il backtest lo slippage sugli stop LO PAGA
   GIÀ — e lo paga PIÙ del conto reale** (media misurata sul vero: **0,42**, n=5).
   Sommarcelo sopra sarebbe stato **doppio conteggio**.
4. 🎯 **Quello che il tester azzera davvero è la gamba d'INGRESSO** — e lì la misura vera del
   conto `10105439` dice **+0,06 punti indice di media** (mediana **−0,10**: metà delle volte
   ci va bene), **n=5**, IC95 che **contiene lo zero**.
5. 🟠 **Verdetto composto (spread FTMO + slippage, scala prudente G2, per giro):**
   `771531` PF **1,52365 → 1,433–1,460**, profitto **−12,1%** · `770101` **invariata** ·
   `770202` **1,230–1,237** · `770260` **1,109** (🔴 era già sotto 1,20 prima dei costi) ·
   `770411` invariata · `770511` **1,358–1,424** con **−30,0%** di profitto.
   **Nessuna sedia scende sotto PF 1,20 per colpa dei costi. Una ci era già.**

---

# 1️⃣ 📂 I REGISTRI DI SLIPPAGE — tutti, per nome

| # | file | che cos'è | n | dove sta |
|---|---|---|---:|---|
| **A** | **`ABTG_SlippageLogger_10105439_deal.csv`** | 🥇 **l'unica misura di slippage su ESECUZIONE VERA** (conto **REALE** BCM 10105439) | **13 deal** = 5 ingressi + 5 uscite SL + 3 uscite EA | `C:\BCM_Reale\MQL5\Files` sul VPS. **In repo NON c'è come file**: il suo contenuto **integrale** è trascritto in `backtest_pipeline/coda/referti/CODA_10_slippage_AAAAMMGG_*.log` (11 copie notturne, 10→20/09). Ho letto quella del **20/09** |
| **B** | `ABTG_SlippageLogger_10105439_REFERTO.txt` | sintesi dello stesso logger (69 righe) | idem | idem |
| **C** | `ABTG_SlippageLogger_10105439_sintesi.csv` | 3 righe di aggregato per simbolo/motivo | idem | idem |
| **D** | **`backtest_pipeline/risultati_archivio/slippage_20260905/slippage_dettaglio_2026-09-05.csv`** | 🥈 slippage **DEL TESTER** estratto dai `.htm` dello Strategy Tester (133 KB) | **638 SL + 283 TP = 921 uscite** | in repo |
| **E** | `backtest_pipeline/risultati_archivio/slippage_20260905/REFERTO_PARSER_2026-09-05.txt` | referto del parser di **D** | idem | in repo |
| **F** | `report/MISURA_SLIPPAGE_2026-09-05.md` | la lettura di **D** | 484 SL in sessione + 67 fuori | in repo |
| **G** | `report/IL_PRIMO_SLIPPAGE_VERO_2026-09-11.md` | la lettura di **A** quando aveva **n=3** | 3 | in repo |
| **H** | `backtest_pipeline/risultati_archivio/Walkforward_Aperture/{DAX,NASDAQ}_C_slippage_FULL.csv` | ❌ **NON è una misura**: è una **griglia** sull'input `InpSlippagePts` (colonna presente, valori 200…) | — | in repo |
| **I** | `backtest_pipeline/risultati_archivio/REFERTO_ROUND55_SLIPPAGE.md` · `prove/R55a_slippage_PTE.txt` · `R55b_slippage_ORB.txt` · `R98e_slippage100_NASUSD.txt` · `LONDONFX_R116_FASE2_SLIPPAGE.txt` | ❌ prove di **stress**, non misure | — | in repo |

🔴 **E il buco che vale di più, già scritto il 05/09 e ancora aperto**: `data/statements/trades_auto.csv`
ha **720 stop veri** su conto vero (30/03→04/09) e **non se ne può misurare lo slippage**,
perché `ABTG_TradeExporter` scrive il prezzo **eseguito** ma non il livello **richiesto**.
Manca **una colonna** (`DEAL_COMMENT` sull'uscita). Il fix è descritto in
`report/MISURA_SLIPPAGE_2026-09-05.md` §5 ed è **dichiarato, non applicato**.

---

# 2️⃣ 📏 LA MISURA VERA — registro `A`, riga per riga

Simbolo **`D30EUR`**, magic **`770101`** (= una delle nostre sei sedie, sul suo simbolo, col
suo meccanismo: il trasferimento più corto che esista). Ore **server**. Segno: **positivo =
AVVERSO**. Unità: **punti indice** (1 punto indice = 100 punti MT5).

| gamba | n | media | mediana | min | max |
|---|---:|---:|---:|---:|---:|
| **INGRESSI** | **5** | **+0,0600** | **−0,10** | −0,30 | **+0,70** |
| **USCITE SL** | **5** | **+0,4200** | **0,00** | 0,00 | **+1,70** |
| **USCITE EA (a mercato)** | **3** | 🔴 **`[NON MISURABILE]`** — tutte e tre senza prezzo richiesto | | | |

**Per GIRO** (ingresso + uscita SL, appaiati per `position_id`): `+0,70 · +1,40 · −0,10 ·
+0,30 · +0,10` → **media +0,4800**, sd 0,5933, **IC95 `[−0,257 ; +1,217]`**.

> ⚖️ **REGOLA DI CASA, applicata**: con **n=5** il giudizio sul **MERITO è sospeso** (l'IC95
> della media contiene lo zero: non posso dire che in media si scivoli). **Il RISCHIO si legge
> lo stesso**: una scivolata da **+1,70 punti su uno stop è ACCADUTA**, e un fatto accaduto
> vale a qualunque `n`.

📏 **In scala**: 1,70 punti su uno stop tipico del DAX (55-86 punti) = **2-3% di un R, in una
volta sola**. E l'ingresso peggiore, +0,70, vale **il 41% dello spread mediano dell'ora 8**.

---

# 3️⃣ 🔴 IL CONTRO-ESEMPIO CHE HO COSTRUITO CONTRO ME STESSO — e che **mi ha corretto il conto**

La prima stesura di questo referto caricava sul backtest **tutti e 0,48 i punti per giro**.
**È sbagliato, e l'ho scoperto prima di consegnare.**

**Domanda che mi sono fatto**: *«"Esecuzione ideale" vuol dire davvero che lo stop viene
riempito ESATTAMENTE al livello?»* → **No.** A tick reali il tester chiude lo stop al **primo
tick che attraversa il livello**, e quello scarto è **già dentro il `Profit`**.

**E in casa è già MISURATO** — registro `D`/`F`, 05/09, **484 stop `D30EUR` in sessione,
23 mesi a tick reali**:

| | n | mediana | P95 | max | **media** |
|---|---:|---:|---:|---:|---:|
| 🧪 **quello che il TESTER paga già** (D30EUR, ore 07-20) | **484** | **0,40** | 3,25 | 25,80 | **0,91** |
| 🥇 **quello che il conto VERO ha pagato** (D30EUR, registro A) | **5** | **0,00** | — | 1,70 | **0,42** |

> ## 🎯 **Sul gambo dello STOP il tester NON è ottimista: è PIÙ PESSIMISTA del conto reale.**
> Media **0,91** contro **0,42**. Mediana **0,40** contro **0,00**.
> 👉 **Caricarci sopra la gamba SL misurata sarebbe stato doppio conteggio**, e avrebbe
> prodotto un danno **più che doppio di quello vero**.

🧾 **E il controllo positivo che rende credibile il numero del tester non l'ho inventato
adesso**: il parser del 05/09 misurava con la **stessa formula** anche i take profit e ha
ottenuto **0 su 283** riempiti peggio del livello, contro **81% su 638** stop. Se la formula
fosse rotta, i TP uscirebbero a caso. 🟢 **Non escono a caso.**

⚠️ **Il tester copre anche i GAP**: nel campione `D` le nove peggiori scivolate su dieci sono
**fuori sessione** (`00:05:15`, `23:05:15`, `01:16:00` — il primo tick dopo l'interruzione),
fino a **294,40 punti**. Quindi *«e i gap?»* **non è un buco di questo conto**: il backtest a
tick reali quei gap li ha già pagati.

---

# 4️⃣ 🧊 LA SCALA, CONGELATA PRIMA DEI NUMERI

Quello che resta da aggiungere al backtest è **solo ciò che il tester azzera**:
**(a)** l'esecuzione della gamba d'**ingresso** e **(b)** le uscite **a mercato** dell'EA
(TP1 parziale, chiusura a tempo), che nel registro `A` sono **3 su 3 non misurabili**.

| gradino | formula | punti indice per giro (base `D30EUR`) | come va letto |
|---|---|---:|---|
| **G0 — LORDO** | ingresso + uscita SL misurati | **0,480** | 🔴 **SCARTATO: doppio conteggio** dello stop (§3). Lo scrivo per tracciabilità |
| **G1 — CENTRALE** | ingresso misurato + uscita a mercato *come l'ingresso* (25% del volume) | **0,075** | la lettura letterale della misura |
| **G2 — PRUDENTE** | ingresso misurato + uscita a mercato *come uno SL vero* (50% del volume) | **0,270** | 🟠 **è questa che uso per decidere** |
| **G3 — SEVERO** | ingresso all'**estremo superiore dell'IC95** (+0,538) + uscita a mercato come SL | **0,748** | il caso brutto plausibile |

🔴 **Il gradino che decide è G2**, dichiarato **prima** di guardare i risultati: assume che
l'uscita a mercato non misurata scivoli come uno **stop** e su **metà** del volume. È
**pessimistico sul dato che non ho**, che è il verso giusto.

### 🔁 Il trasferimento agli altri due simboli — due regole, si prende la peggiore
- **T1 assoluto**: gli stessi punti indice su tutti e tre (lo spread mediano dei tre indici
  è simile in punti indice — 1,70 / 1,90-2,00 / 1,80 — nonostante prezzi molto diversi).
- **T2 in multipli di spread**: `slip / 1,70 × spread FTMO del simbolo`.

| | `GER40` (1,43) | `US30` (2,63) | `US100` (1,53) |
|---|---:|---:|---:|
| **G2 · valore usato** | **0,270** (T1) | **0,418** (T2) | **0,270** (T1) |
| **G3 · valore usato** | **0,748** (T1) | **1,157** (T2) | **0,748** (T1) |

### 💱 E il pedaggio in **R** è indipendente da taglia e broker
`lotti = rischio / (stop × valore_punto)` ⇒ `costo/rischio = slippage / stop`. **Il valore per
punto si semplifica.** È la stessa algebra del §5.3 di `STOP_VS_SPREAD_FTMO_2026-09-20.md`,
e si paga **UNA volta per giro**.

---

# 5️⃣ ✅ LA VERIFICA DEL PEZZO GIÀ FATTO — e **un difetto trovato nel §5.4**

Ho rifatto i conti del §5.4 sulla `771531` partendo dai dati grezzi:
`GL = 23.321,47/(1,52365−1) = 44.536,9` · `GW = 67.858,6` · `C = 517 × 0,00700 × 1.000 =
3.619` → PF **1,4091 – 1,4424**, profitto **−15,52%**. 🟢 **Coincide al centesimo con il
§5.4: `1,409–1,442` e `−15,5%`. Verificato.**

> ## 🔴 **MA IL §5.4 HA MOLTIPLICATO PER `n = 517 DEAL`, E 517 SONO I DEAL, NON I GIRI.**
> Le posizioni sono **257** (contate nel per-trade, e il §2 del censimento contratti le
> dichiara). Il pedaggio dello spread **si paga una volta per giro**: un ingresso ad ask e
> l'uscita a bid, e **spezzare l'uscita in due parziali NON raddoppia lo spread**.
> 👉 **Sulla `771531` il §5.4 carica il pedaggio dello spread ≈ 2 volte.** Con la convenzione
> del suo stesso §5.3, il solo spread fa **−7,7%**, non −15,5%.

🧪 **Il contro-esempio che ho costruito contro questa mia correzione**: *«e se il parziale
pagasse comunque due volte?»* — Un giro compra 10 lotti ad ask; esce 5+5 a bid. Il costo di
spread è `volume × spread`, **pagato all'apertura**: 10 × spread. Spezzare l'uscita non
aggiunge niente. ✅ La correzione regge. *(Nota: per lo **slippage** invece ogni esecuzione
scivola — ed è esattamente perché il mio G2 include la gamba dell'uscita a mercato.)*

🧮 **E la coincidenza che vale la pena scrivere, perché altrimenti sembra un errore**: il
numero del §5.4 (**−15,5%** sul solo spread, per deal) è **quasi identico** al numero corretto
per giro **con dentro anche lo slippage lordo G0** (−15,6%). **Stesso numero, ragione diversa.**

---

# 6️⃣ 📊 LA TAVOLA — sedia per sedia, spread FTMO **+** slippage, **per GIRO**

`Δ_spread` dal §5.3 di `STOP_VS_SPREAD_FTMO_2026-09-20.md` · `Δ_slip = slip/stop` ·
`C = n_giri × Δ × R` · PF nuovo come **banda** fra *tutto il costo sulle vincenti* e *tutto
sulle perdenti* · **rendimento mensile su 80.000 € a rischio 2,00%** (scala lineare di casa,
`[APPROSSIMATO]`, e **sovrastima** — la capitalizzazione rende il DD sub-lineare).

### 🟠 G2 — IL GRADINO CHE DECIDE

| sedia | simbolo | stop | n giri | **Δ spread** | **Δ slip** | **Δ tot** | costo | **PF: da → a** | **profitto** | **mens. su 80k** |
|---|---|---:|---:|---:|---:|---:|---:|---|---|---:|
| **`770101`** DAX Apertura | GER40 | 86,48 | **193** | −0,00312 | +0,00312 | **0,00000** | 0 € | 1,39709 → 🟢 **1,397** | 18.029 → **18.029** (0,0%) | 2,851 → **2,850%** |
| **`770202`** Dow Apertura | US30 | 123,80 | **96** | +0,00509 | +0,00337 | **+0,00846** | 813 € | 1,27013 → 🟠 **1,230–1,237** | 6.722 → **5.909** (−12,1%) | 1,063 → **0,934%** |
| **`770260`** Nasdaq RETEST | US100 | 83,20 | **94** | −0,00325 | +0,00325 | **0,00000** | 0 € | 1,10936 → 🔴 **1,109** | 274 → **274** (0,0%) | 0,457 → **0,457%** |
| **`770411`** MaxMin DAX Short | GER40 | **59,20** 🆕 | **14** | −0,00456 | +0,00456 | **0,00000** | 0 € | 2,15985 → 🟢 **2,160** | 6.143 → **6.143** (0,0%) | 0,971 → **0,971%** |
| **`770511`** SuperWave | US30 | 77,10 | 🔴 **165** *(tetto: giri `[NON MISURATO]`, forbice 71-165)* | +0,00817 | +0,00542 | **+0,01359** | 224 € | 1,60552 → 🟠 **1,358–1,424** | 746 → **522** (−30,0%) | 1,180 → **0,825%** |
| **`771531`** EMA200 Dow | US30 | 104,30 | **257** | +0,00700 | +0,00400 | **+0,01100** | 2.828 € | 1,52365 → 🟢 **1,433–1,460** | 23.321 → **20.493** (−12,1%) | 3,687 → **3,240%** |

🔵 **Lo zero secco su tre sedie non è pigrizia: è un'identità.** Su `GER40` e `US100` lo
spread FTMO **migliora** rispetto a BCM esattamente di quanto costa lo slippage G2. Coincidenza
aritmetica, non un risultato — e infatti a G1 e a G3 le stesse tre sedie si muovono.

### 🟢 G1 (centrale) e 🔴 G3 (severo) — la scala **completa**, non i gradini comodi

| sedia | **G1** PF / profitto / mens. | **G2** PF / profitto / mens. | **G3** PF / profitto / mens. |
|---|---|---|---|
| `770101` | 🟢 1,407–1,411 / **+2,4%** / 2,919% | 1,397 / 0,0% / 2,850% | 1,365–1,374 / **−5,9%** / 2,682% |
| `770202` | 1,241–1,247 / −8,6% / 0,971% | 1,230–1,237 / −12,1% / 0,934% | 🔴 **1,203–1,214** / −20,6% / 0,844% |
| `770260` | 🔴 1,118–1,119 / +8,0% / 0,494% | 🔴 1,109 / 0,0% / 0,457% | 🔴 **1,086–1,088** / −19,7% / 0,367% |
| `770411` | 2,169–2,179 / +0,8% / 0,979% | 2,160 / 0,0% / 0,971% | 2,115–2,139 / −1,8% / 0,953% |
| `770511` | 1,421–1,476 / −21,4% / 0,927% | 1,358–1,424 / −30,0% / 0,825% | 🔴 **1,225–1,295** / −51,2% / 0,575% |
| `771531` | 1,456–1,477 / −8,9% / 3,358% | 1,433–1,460 / −12,1% / 3,240% | 🟠 1,380–1,419 / **−19,9%** / 2,952% |
| **somma mensile** *(sei sedie, **senza** correlazione e **senza** il cap C1: è un tetto, non una previsione)* | **9,65%** | **9,28%** | **8,37%** — base **10,21%** |

🆕 **Lo stop della `770411` l'ho misurato io**, perché nel §5.3 non c'era: dai 5 **stop pieni**
del suo per-trade (`abtg_trades_..._770413.csv`), `distanza = |perdita| / volume` →
**42,0 · 49,9 · 59,2 · 99,2 · 102,7** punti indice, **mediana 59,20** `[MISURATO, n=5]`.
🧪 *Contro-esempio*: la riga `−3,90 € su 19,5 lotti` dà 0,20 punti — **non è uno stop, è un
breakeven**, e infatti l'ho esclusa. E le cinque perdite valgono **1.050-1.068 €** su banco
100.000 a 1,00%: 🟢 **confermano deposito e rischio della cella.**

---

# 7️⃣ 📉 IL DRAWDOWN — **ricostruito sulla curva vera**, non stimato

🔴 **Claudio mi ha avvertito dell'effetto denominatore** (*«se il profitto cala, lo stesso DD
in valuta sembra più grande»*). **Non mi sono fidato di nessuna delle due letture: ho
ricostruito la curva dei saldi** dai per-trade, applicando il costo **alla chiusura di ogni
giro**, e ho misurato il DD **in valuta** e **in percentuale del picco**.

| sedia | **DD valuta** base → G2 | **DD % picco** base → G2 | contratto @2,00% | **@2,00% coi costi (G2 / G3)** |
|---|---|---|---:|---|
| `770101` | 7.662,91 → **7.662,91** (0,0%) | 6,2516 → **6,2516%** | 14,47% | **14,47% / 14,88%** |
| `770202` | 4.271,61 → **4.483,11** (**+5,0%**) | 4,2235 → **4,4352%** | 8,79% | **9,23% / 9,54%** |
| `770411` | 1.332,13 → **1.332,13** (0,0%) | 1,2654 → **1,2654%** | 3,84% | **3,84% / 3,91%** |
| `771531` | 8.817,93 → **9.323,93** (**+5,7%**) | 7,5367 → **8,0479%** (**+6,8%**) | 15,66% | 🔴 **16,73% / 17,42%** |

> ## 🔴 E QUI DEVO CORREGGERE L'AVVERTENZA, NON CONFERMARLA.
> L'effetto denominatore **esiste**, ma **non è tutto**: sulla `771531` il DD **in VALUTA**
> peggiora di **+5,7%** (G2) e **+9,4%** (G3). Il motivo è meccanico: il costo si accumula
> **durante le strisce perdenti**, che è proprio dove si forma il DD. 👉 **Non è solo la
> percentuale che sembra più grande: la discesa in euro è davvero più profonda.**
> ✅ *Ma la parte dell'avvertenza che regge in pieno*: su `770101` e `770411` il DD in valuta
> **non si muove di un centesimo**, perché a G2 il costo netto è zero.

⚠️ **Calibrazione onesta della mia ricostruzione**: sul base dà `770101` 6,2516% contro il
**7,2328%** del tester e `771531` 7,5367% contro **7,8323%**. **Scarto nel verso atteso**:
io ricostruisco il **balance** DD (solo trade chiusi), il tester misura l'**equity** DD
(include il flottante), che è sempre ≥. 👉 Uso i **rapporti**, non i livelli assoluti — ed è
per questo che la colonna «@2,00% coi costi» è il contratto del censimento **scalato dal mio
rapporto**, non un numero mio.
🔴 `770260` e `770511` non hanno per-trade in repo: **DD coi costi `[NON MISURATO]`**.

---

# 8️⃣ 🚦 SOPRAVVIVE? — il verdetto contro la soglia **PF 1,20**

| sedia | PF base | **PF a G2** | **PF a G3** | verdetto |
|---|---:|---|---|---|
| **`770101`** | 1,39709 | **1,397** | 1,365–1,374 | 🟢 **SOPRAVVIVE**, con ampio margine. *(e a G1 **migliora**: lo spread FTMO sul DAX è più stretto di BCM)* |
| **`770411`** | 2,15985 | **2,160** | 2,115–2,139 | 🟢 **SOPRAVVIVE** — è la più robusta ai costi di tutte. ⚠️ **ma n=14 giri: MERITO SOSPESO** |
| **`771531`** | 1,52365 | **1,433–1,460** | 1,380–1,419 | 🟢 **SOPRAVVIVE** in tutta la scala. 🔴 **Ma il DD @2,00% sale a 16,7-17,4%**, ed è la sedia col DD promesso più alto della rosa |
| **`770511`** | 1,60552 | **1,358–1,424** | 🔴 **1,225–1,295** | 🟠 **FRAGILE** — regge la soglia ovunque, ma perde **30-51% del profitto** e i giri sono `[NON MISURATO]`: se fossero 165, a G3 è a **2 centesimi** dal muro |
| **`770202`** | 1,27013 | **1,230–1,237** | 🔴 **1,203–1,214** | 🟠 **A RISCHIO** — a G3 il bordo basso è **1,203**: margine **+0,3%** sulla soglia. Basta un gradino in più e passa sotto |
| **`770260`** | 🔴 **1,10936** | 🔴 **1,109** | 🔴 **1,086–1,088** | 🔴 **SOTTO 1,20 — MA C'ERA GIÀ PRIMA DEI COSTI.** Il suo problema **non è lo slippage**: la cella validata esce da un backtest a **PF 1,109** su 94 giri |

> ## 🎯 LA RIGA DEL §8
> 🟢 **Nessuna sedia viene spinta sotto PF 1,20 dai costi.** La sola sotto 1,20 ci era già, e
> il difetto è nella **cella**, non nell'esecuzione.
> 🟠 **Le due da guardare sono `770202` e `770511`**, che al gradino severo arrivano a
> **1,20** e **1,23**: il margine c'è, ma è sottile, e su `770511` non sappiamo nemmeno
> quanti giri siano.
> ✋ **Nessuno spegnimento proposto, nessuna taglia, nessun parametro: raccomandazione a
> Claudio, come da regola di casa.**

---

# 9️⃣ 🧪 I CONTRO-ESEMPI — i due assegnati e il terzo, costruito da me

### ① Effetto denominatore ✅ accolto **e misurato** (§7)
Non mi sono limitato a evitarlo: ho **ricostruito la curva** e trovato che il DD in **valuta**
peggiora comunque (+5,7% su `771531`). **L'avvertenza era giusta come cautela, e incompleta
come conclusione.**

### ② Il pedaggio si paga **una volta per giro** ✅ rispettato — **e ho trovato dove non lo era** (§5)
Tutta la tavola del §6 gira su **giri**, non su deal. E nel farlo è emerso che il **§5.4
usava i deal**: sulla `771531` il pedaggio dello spread lì è **≈ raddoppiato**.

### ③ 🔴 IL TERZO, QUELLO CHE DOVEVO COSTRUIRE IO
**Domanda**: *«in quale scenario questa correzione SOTTOSTIMA il danno?»* — Ho trovato
**cinque** vie, e una sola le batte tutte.

| # | scenario | è coperto? |
|---|---|---|
| **a** | 🔴 **L'ora dell'apertura USA.** Il registro `A` è **tutto `D30EUR` fra le 10:07 e le 16:17 server**. `770202`, `770260` e `771531` lavorano **sull'apertura cash americana**, dove lo spread BCM su `U30USD` ha un **massimo di 47,0 punti indice**. Lo slippage lì è `[NON MISURATO]` su conto vero | 🔴 **NO** — e questa è la falla principale |
| **b** | 🔴 **Asimmetria stop vs ingressi.** Nel registro vero gli stop scivolano **7 volte** più degli ingressi (0,42 contro 0,06); nel campione del tester **l'81% degli stop** scivola contro di noi e **0 su 283 TP** scivolano a favore. Se sul feed FTMO l'asimmetria fosse **maggiore** di quella del tester, il pavimento del §3 non basterebbe | 🟠 **parziale**: G2/G3 ci mettono sopra un margine, ma non è una misura |
| **c** | 🔴 **L'uscita a mercato è NON MISURATA, 3 su 3.** È la gamba che i motori con TP1 parziale usano **ogni giro**. Tutta la differenza fra G1 (0,075) e G3 (0,748) è lì dentro | 🟠 **dichiarato**, non misurato |
| **d** | 🔴 **Requote e rifiuti non esistono in questo conto.** Un ordine rifiutato non è uno slippage: è **un'operazione che non c'è**. Su `771531` e `770101`, che entrano con ordini **LIMIT**, il rischio vero non è scivolare — è **NON essere riempiti** su un movimento che poi va | ❌ **NO, per niente** |
| **e** | 🟢 **Gap di riapertura** | ✅ **SÌ**, e mi ha stupito: nel campione del tester (n=551) le 9 peggiori su 10 sono fuori sessione, fino a **294,40 punti** — quindi **il backtest i gap li paga già** |

> ## 🔴 E IL PEGGIORE DI TUTTI È QUELLO CHE NON HO SCRITTO SOPRA:
> **lo slippage misurato è di UN ALTRO BROKER.** BCM reale ≠ FTMO. FTMO dichiara esecuzione
> **simulata** su conti demo (`docs/REGOLAMENTO_FTMO_2026-08.md` r.133): *può* essere più
> pulita o *può* essere peggiore, e **non lo sappiamo**.
> 👉 **Se la falla `a` (apertura USA) e la falla `d` (rifiuti) mordessero insieme, il gradino
> vero potrebbe stare SOPRA G3.** Non lo escludo: dichiaro che non lo copro.

---

# 🔟 🚩 LA COSA CHE HO TROVATO E CHE NON POSSO NON DIRE

Nel registro `A`, il deal **2899263** dell'08/09:

```
D30EUR · magic 770101 · IN · ACQUISTO · 0,30 lotti
chiesto 25.983,10  ->  eseguito 25.983,80   =  +0,70 punti AVVERSI
commento: "DAX Apertura EU RETEST BUY"
```

🔴 **Quella è una `BuyLimit`.** `mql5/Experts/ABTG_DAX_Apertura_EU.mq5`, `MonitorRetest()`:
`gTrade.BuyLimit(lot, entry, _Symbol, sl, tp, ..., ABTG_DEF_NAME+" RETEST BUY")` — e la riga
205 del sorgente la descrive testualmente come *«rottura + ritorno sul livello con LIMIT
(Emiliano: niente slippage)»*.

> ## 🔴 **Un ordine LIMIT è stato riempito 0,70 punti PEGGIO del suo livello.** Un limit può
> essere riempito al livello o **meglio**, mai peggio. È **l'ingresso peggiore di tutto il
> campione**, ed è sul meccanismo che in casa consideriamo *«senza slippage»*.

**Non so ancora perché**, e non invento la causa. Le ipotesi da distinguere sono tre e si
distinguono con una lettura, non con un'opinione: **(1)** BCM esegue tutto in *Market
execution* e il "limit" è di fatto un trigger a mercato; **(2)** l'ordine è stato modificato
e `fonte ORDINE` non è più il livello originale; **(3)** un errore del logger su quella riga.
👉 **Finché non è distinta, l'assunzione "i limit non scivolano" NON va usata** — e infatti
in tutta la tavola del §6 **non l'ho usata**: alla `771531`, che entra **solo** con
`BuyLimit`/`SellLimit`, ho applicato lo slippage d'ingresso misurato come a tutte le altre.

🔎 **Per completezza, il meccanismo d'ingresso di ogni sedia** *(letto al sorgente)*:
`770101`/`770202`/`770260` = **Stop/Limit pendenti** · `770411` = **BuyStop/SellStop** ·
`770511` = **1/3 a mercato + 2/3 BuyStop** · `771531` = **solo Limit**.
👉 **L'unica con una gamba di ingresso puramente a mercato è la `770511`** — la stessa che
esce peggio da questo referto.

---

# 1️⃣1️⃣ 🕳️ CHE COSA QUESTA MISURA **NON** COPRE — per nome

1. 🔴 **`n = 5` giri.** Il **MERITO è sospeso** (l'IC95 della media contiene lo zero). Il
   **RISCHIO** si legge lo stesso: +1,70 su uno stop è successo.
2. 🔴 **Un simbolo solo (`D30EUR`) e una sedia sola (`770101`).** `US30` e `US100` sono
   **trasferiti**, non misurati. La regola T2 è una scelta mia, dichiarata al §4.
3. 🔴 **Un broker solo, e non è quello giusto.** BCM reale ≠ FTMO.
4. 🔴 **L'apertura USA su conto vero è `[NON MISURATA]`** — e tre sedie lavorano lì.
5. 🔴 **L'uscita a mercato è `[NON MISURABILE]`**: 3 righe su 3 senza prezzo richiesto.
6. 🔴 **Requote, rifiuti, ordini non riempiti: non modellati** — e sui LIMIT valgono più
   dello slippage.
7. 🔴 **UN SOLO REGIME.** La finestra OOS `2025.06.10 → 2026.06.30` è **toro**, e la **prova
   di regime resta assente** su tutte e sei. Questo referto **non la sostituisce**: corregge i
   costi dentro un regime, non dice cosa succede fuori.
8. 🟠 **Scala lineare del rischio 1%→2%**: convenzione di casa `[APPROSSIMATA]`, e **sovrastima**
   il DD (la discesa su `N` perdite è `1−(1−2r)^N < 2·(1−(1−r)^N)`). Quindi le righe «@2,00%»
   del §7 **scattano tardi, non presto**.
9. 🟠 **La somma mensile delle sei** è una somma **senza correlazione** e **senza il cap C1 al
   3,25%**: è un **tetto aritmetico**, non una previsione di conto.
10. 🟢 **Le COMMISSIONI invece sono coperte, e valgono ZERO**: FTMO dichiara gli indici
    **commission-free** (`docs/REGOLAMENTO_FTMO_2026-08.md` r.132) e **tutte e sei le sedie
    sono su indici**. 🟠 **Lo SWAP no**: `771531` (banda 01-21) e `770511` (24h) tengono
    posizioni overnight, e il rollover è **`[NON MISURABILE]` da qui**.
11. ⚠️ **Lo spread NON l'ho rifatto**, per mandato: ho **verificato** il §5.3/§5.4 (e trovato
    la convenzione `deal` vs `giro`, §5). 🟢 **Nota a favore**: la misura viva di stamattina
    (`report/SPREAD_APERTURA_FTMO_2026-09-21.md`) dà `GER40` **1,23** e `US30` **2,10** all'ora
    10 server, **più stretti** dell'1,43/2,63 usati qui ⇒ il pedaggio dello spread del §6 è,
    per le ore europee, **conservativo**. 🔴 Ma quella misura è `GG=1` e **l'apertura USA non
    c'è**: il giro è stato chiuso alle 10:50 server.

---

# 1️⃣2️⃣ 🏁 LA RISPOSTA A CLAUDIO, in chiaro

> **«23.321 è a bottino pieno»** → 🔴 **No, sul meccanismo**: quel numero è **già netto**.
> Vincite lorde 67.858,01 meno perdite lorde 44.536,54, contate da me su 517 deal. I ritorni
> sullo stop col trailing **sono dentro le perdite**, non fuori.
>
> **«Dal vivo il profitto sarà minore»** → ✅ **Sì, e adesso c'è il numero**:
> **20.493 € invece di 23.321** al gradino prudente (**−12,1%**), **18.673 €** al gradino
> severo (**−19,9%**). Non è bottino pieno: è **bottino vero**.
>
> 🟢 **E la bella notizia, misurata**: il pezzo che temevamo di più — lo slippage sugli stop —
> **il backtest lo pagava già, e lo pagava più caro del nostro conto reale.** La botta vera è
> quasi tutta **spread FTMO sul Dow**, non esecuzione.
>
> 🔴 **E quella che non lo è**: il DD promesso della `771531` a taglia 2,00% passa da
> **15,66%** a **16,7-17,4%**, contro un muro FTMO del **10% statico dal saldo iniziale**.
> Non è una sedia che smette di guadagnare: è una sedia **grossa**. La taglia è firma tua.

---

*Misura prodotta in sola lettura il 21/09/2026. I numeri che decidono — le 13 righe del
registro dello slippage, i 517 deal e le 257 posizioni della `771531`, i 5 stop pieni della
`770411`, le quattro curve di drawdown ricostruite e il meccanismo d'ingresso delle sei sedie —
sono stati letti da me al file sorgente. Dove un numero non esiste, c'è scritto `[NON
MISURATO]`, e non c'è un numero al suo posto.*
