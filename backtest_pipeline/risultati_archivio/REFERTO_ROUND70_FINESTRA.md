# 🔬 R70 — LA FINESTRA RECENTE **SCEGLIE MEGLIO**, ma il ribaltamento **NON ERA L'EPOCA: È IL REGIME**

> ## ✍️ RITRATTAZIONE (aggiunta dopo R71, 16/08)
> **Il §2 di questo referto e' SBAGLIATO nella parte numerica.** I rapporti di
> cattura (97,3% / 61,1% contro 51,5% / 54,5%) erano calcolati sulla **cella
> migliore dell'IS — il PICCO** — mentre il criterio 1 di casa dice _"centro
> dell'altopiano, MAI il picco"_. Rifatto con la regola giusta, la finestra
> vecchia su USDJPY cattura **92,4%** contro l'**83,5%** di quella nuova: **il
> vantaggio della finestra recente sparisce.** Il §2 era gia' dichiarato
> "sospeso, non un verdetto" per n sotto soglia, e per fortuna. Numeri corretti
> e conclusione in **`REFERTO_ROUND71_FINESTRA_CAMPIONE_PIENO.md` §1-2**.
> Gli altri paragrafi (regime, buffer, config viva) **reggono e sono stati
> riconfermati da R71**.

_Verifica dell'**EMENDAMENTO DELLA FINESTRA** congelato in `CLAUDE.md` il 16/08
su richiesta di Claudio. Le tre domande erano scritte in
`prove/PTE_FINESTRA_VECCHIA_O_RECENTE.txt` **prima** di aprire lo zip._

**Banco:** griglia **identica carattere per carattere** a R68/R69 (7×4 = 28 celle,
`SLbufferPips` 0-30 × `TP2_ATRmult` 1,5-3,0), **OHLC**, deposito 100.000,
rischio 1%, `SLfromDoji` pinnato a 0. **L'unica variabile del round è la data.**

**Igiene: 4 CSV su 4, 28 celle su 28 ciascuno, cancelli verificati nei quattro
`.ini`** — `Symbol`, `Period=H1`, `Model=1`, `Deposit=100000`,
`AllowLiveTrading=false`, `ForwardMode=0`, tutti i pinnati identici a R68/R69.
**IS `2019.01.01 → 2021.12.30`** (3,0 anni) · **OOS `2021.12.31 → 2026.06.30`** (4,5 anni).

---

## 1. ❌ DOMANDA 1 — «L'IS recente smette di essere 0/28?» → **NO. E questo cambia la diagnosi.**

| | IS vecchio (R68/R69) | **IS recente (R70)** |
|---|---|---|
| **USDJPY** celle positive IS | **0 / 28** (2010-2016) | **0 / 28** (2019-2022) 🔴 |
| **GBPUSD** celle positive IS | maggioranza positive | **3 / 28** (2019-2022) 🔴 |
| **OOS** celle positive | 28/28 e 25/28 | **28/28 e 28/28** |

**Su USDJPY il motore perde in tutte e 28 le celle anche nella finestra recente.
E su GBPUSD la finestra recente è PEGGIORE di quella vecchia.**

> ### 🎯 L'ipotesi «lo yen di Abenomics bocciava per un'epoca morta» **NON REGGE**: senza Abenomics l'IS resta 0/28.
>
> **Quello che si ribalta non è VECCHIO → RECENTE. È 2019-2022 → 2022-2026.**
> Due regimi: covid + tassi zero + laterale da una parte, dollaro forte e
> tassi dall'altra. **Il motore perde nel primo e guadagna nel secondo, su
> entrambi i cambi, in QUALUNQUE finestra lo si tagli.**

📌 **Questa è una smentita parziale del punto di partenza di Claudio, e va scritta
così.** Ma non tocca l'emendamento — **lo sposta sul punto C**: se il segno
dipende dal regime e non dall'epoca, allora *"quanti anni indietro"* è la domanda
sbagliata, e **`prova di regime > storia contigua`** è la risposta giusta.
La regola era già scritta bene; la ragione per cui è giusta era un'altra.

📉 Un numero che però dà ragione a Claudio: sulla perdita IS di USDJPY,
**per anno** — vecchio: da **−1.470 a −4.030/anno**; recente: da **−245 a
−1.148/anno**. **Perdeva 4-6 volte tanto nella finestra vecchia.** Il motore
non è "uguale": è **meno peggio adesso**. Ma non abbastanza da cambiare segno.

## 2. ⏸️ DOMANDA 2 — «Quale IS sceglie meglio?» → **SOSPESA DAL MIO STESSO CRITERIO**

Il criterio 0, congelato prima dei numeri: _"n ≥ 150 nell'IS per considerare
valida la selezione. Se l'IS esce sotto 150, **la selezione è SOSPESA e si
dichiara**"_.

| | n IS misurato | soglia |
|---|---:|---:|
| GBPUSD | **75 → 125** | 150 ❌ |
| USDJPY | **95 → 159** (solo `buf 30` sopra soglia) | 150 ❌ |

🔴 **La stima era 95-150 e la realtà è uscita sotto. Criterio applicato: quello
che segue è un'OSSERVAZIONE, non un verdetto.**

**Osservazione — quanto dell'ottimo OOS ha catturato la cella scelta sull'IS:**

| round | IS | cella scelta sull'IS | OOS di quella cella | miglior OOS | **catturato** |
|---|---|---|---:|---:|---:|
| R68 | 2010-2016 | `buf 20 · TP 2,5` | +3.001 | +5.823 | **51,5%** |
| R69 | 2010-2016 | `buf 30 · TP 3,0` | +4.156 | +7.631 | **54,5%** |
| **R70 GBPUSD** | **2019-2022** | `buf 10 · TP 3,0` | **+7.255** | +7.460 | **97,3%** 🟢 |
| **R70 USDJPY** | **2019-2022** | `buf 20 · TP 3,0` | **+9.717** | +15.910 | **61,1%** |

⚠️ **Confronto legittimo solo perché normalizzato dentro ogni round** (la
trappola degli OOS annidati era dichiarata: le performance assolute **non** si
confrontano). **Va nella direzione del punto A — ma con n sotto soglia non è
un verdetto, e non lo chiamo così.**

### 🔍 E la superficie IS dice PERCHÉ la soglia esiste

**Profitto medio IS per riga di buffer, GBPUSD:**

| finestra | buf 0 | 5 | 10 | 15 | 20 | 25 | 30 |
|---|---:|---:|---:|---:|---:|---:|---:|
| **vecchia** (R68) | \-\-\- | monotona crescente, altopiano largo | | | | | ✅ |
| **recente** (R70) | −3.239 | −1.529 | **+88** | −562 | −1.582 | −1.244 | −407 |

**Nella finestra recente non c'è nessun altopiano: c'è UNA cella che sporge e il
resto va su e giù.** Criterio 1 dice _"centro dell'altopiano MAI il picco"_ —
e qui **il picco è tutto quello che c'è**.

> 🎯 **Questo è esattamente l'aspetto di un IS sotto-campionato, ed è il costo
> misurato dell'accorciare: meno trade = superficie rumorosa = selezione che
> insegue il rumore. La soglia dei 150 non era decorativa: MORDE.**

## 3. ✅ DOMANDA 3 — «Il buffer regge?» → **SÌ SUL RISCHIO. NO SUL RENDIMENTO.**

**Drawdown OOS (media sulle 4 colonne TP):**

| buffer | 0 | 5 | 10 | 15 | 20 | 25 | 30 |
|---|---:|---:|---:|---:|---:|---:|---:|
| **GBPUSD** | 8,13 | 6,05 | 4,31 | 3,60 | 3,61 | 2,90 | **2,88** |
| **USDJPY** | 6,45 | 6,00 | 5,04 | 4,94 | 4,41 | 4,34 | **4,28** |

**Terza e quarta conferma indipendente: il drawdown scende col buffer, sempre,
in ogni finestra, su ogni cambio. Da 8,1% a 2,9% su GBPUSD.**

**Ma il profitto NO.** Su USDJPY 2022-2026 il massimo assoluto è **`buffer 0`**
(+15.910), e la riga `buffer 5` è **la PEGGIORE delle sette** (media +5.230
contro +12.210 di `buffer 0`). In R69 il buffer 0 era il peggiore. **Si è
ribaltato.**

> ### 🎯 **IL BUFFER È UN PARAMETRO DI RISCHIO AFFIDABILE E UN PARAMETRO DI RENDIMENTO INAFFIDABILE.**
>
> Il fatto di rischio si replica su 4 misure su 4. Il fatto di rendimento
> cambia segno cambiando finestra. **È letteralmente la regola B
> dell'emendamento** — _"il vecchio giudica il rischio, il recente il merito"_ —
> arrivata da una porta che non avevo previsto: **non è solo il VECCHIO a
> misurare bene il rischio e male il merito. È QUALUNQUE finestra.**

## 4. 🪑 E LA SEDIA VIVA, `buffer 5`: **quattro misure, quattro bocciature**

| round | simbolo | come è finita la config viva |
|---|---|---|
| R68 | GBPUSD 2010-2026 | **2ª peggiore DD** su 7 (13,38% contro 6,70%) |
| R69 | USDJPY 2010-2026 | **una delle 3 celle OOS-NEGATIVE** su 28 |
| **R70** | GBPUSD 2019-2026 | DD **6,05%** contro **2,88%** — **il doppio** |
| **R70** | USDJPY 2019-2026 | **la riga PEGGIORE delle sette** (+5.230 vs +12.210) |

> 🔴 **`InpSLbufferPips = 5` non è mai finito bene, in nessuna finestra, su
> nessun simbolo, con nessun criterio. Quattro su quattro.**

🔴 **E NON SI TOCCA LO STESSO.** Criterio 3, congelato in R68 e ribadito in R70:
nessuna modifica in forward finché non c'è un round **a tick reali** *e* una
decisione esplicita di Claudio. È OHLC, ed è il modello che in **R57** ha
ribaltato il segno di questo stesso motore.

---

## 5. 🚦 VERDETTO

> **1. ❌ L'epoca non era il colpevole.** L'IS resta 0/28 su USDJPY anche nel
> 2019-2022, e su GBPUSD la finestra recente è peggiore della vecchia. **Il
> ribaltamento è di REGIME, non di calendario.**
>
> **2. ⏸️ La finestra recente sembra scegliere molto meglio** (97,3% e 61,1%
> dell'ottimo contro 51,5% e 54,5%) — **ma la selezione è SOSPESA dal criterio
> 0**: n IS 75-159, sotto la soglia dei 150 che avevo scritto io.
>
> **3. ✅ Il buffer taglia il drawdown in tutte e quattro le misure fatte, e il
> valore vivo (5) è finito male in tutte e quattro.**
>
> **4. 📏 L'emendamento regge, ma per la ragione C e non per la A.** E la
> soglia dei 150 trade **morde davvero**: è quella che ha impedito a questo
> round di dire una cosa che gli sarebbe piaciuto dire.

## 6. ➡️ R71 — E STAVOLTA LA FINESTRA LA DETTA IL MOTORE, NON IL CALENDARIO

Frequenza misurata stasera, e risolve la discussione con un numero:

| simbolo | trade/anno (IS) | **anni per fare 150 trade** |
|---|---:|---:|
| GBPUSD H1 | 25 → 42 | **3,6 → 6,0** |
| USDJPY H1 | 32 → 53 | **2,8 → 4,7** |

> ### 🎯 **Il calendario non è una scelta: lo detta la frequenza del motore. Su questo H1 forex servono ~5 anni di IS. Non 16 — ma nemmeno 3.**

**Il driver ha già `-FrazioneIS`** (default 0,40): non serve toccare codice.
**R71 = `-DaQuando 2016.01.01 -FrazioneIS 0.5`** → IS **2016-2021 (5,25 anni,
n atteso 155-215 ✅)**, OOS **2021-2026 (5,25 anni)**. Rispetta il punto A
**senza** tornare al 2010, e allora la domanda 2 si può finalmente chiudere.

**Dopo, in ordine:** ⏱️ tick reali sulla cella che sopravvive · 🔧 il buffer in
multipli di ATR (R69 §7) su copia `_Ottimizzato` · 🪑 e solo allora, con la
parola di Claudio, la domanda su `PTE` in forward.
