# 🪑 CHI VA CON CHI — quali sedie si schierano INSIEME il 1° ottobre
**11/09/2026** · costruzione di portafoglio, non giudizio di merito sulle singole.

**Domanda**: dopo `report/ANOMALIE_PICCOLO_2026-09-11.md` (25 posizioni su 83
sovrapposte a una posizione OPPOSTA sullo stesso simbolo, netto −91,20 contro
+293,73 delle altre 58), **quali sedie possono girare insieme senza annullarsi?**

**Fonte unica**: `data/statements/trades_auto.csv`, finestra **25/08 → 10/09**,
**83 posizioni chiuse**, 31 magic, `magic=0` assente.
**Strumento**: `backtest_pipeline/chi_va_con_chi.py` (nuovo, sola lettura) +
`backtest_pipeline/sovrapposizione_sedie.py` (già in casa) +
il metodo di correlazione di `backtest_pipeline/dd_portafoglio.py` (R16).
**Nessun backtest eseguito. Nessun parametro, `.set`, `.mq5` o terminale toccato.**

---

## 🔴 LA RIGA CHE VALE PIÙ DI TUTTE (e non è una statistica)

> **Proiettata a taglia prop (0,65% per sedia, A1 congelato), la flotta di oggi
> nel CASO PEGGIORE apre 20,15% di rischio simultaneo: 6,2 volte il cap
> complessivo C1 di 3,25% firmato il 18/08.**
> Sul solo cluster `U30USD`: **5,20%** contro il **3,0% per cluster firmato il
> 07/09 — che è FIRMATO e NON ATTIVO** (Guardian in campo = v1.12, non conosce
> i cluster).

E non è solo teoria: **nei 13 giorni misurati il picco osservato è stato di
8 sedie / 10 posizioni aperte insieme (08/09 alle 12:50:47)** = **5,20%
per-SEDIA / 6,50% per-POSIZIONE** a taglia prop. Il **p50 giornaliero** è già
**3,25% per-SEDIA**: *metà delle giornate sta esattamente sul cap*.

⚠️ Lettura corretta: sul demo piccolo **non è stato violato nulla** — le taglie
lì sono altre. Questo è il numero **se queste stesse sedie andassero in
challenge alla taglia firmata**. È una proiezione, ed è dichiarata come tale.

---

## 1. 📊 LA MATRICE DELLE SOVRAPPOSIZIONI OPPOSTE

### 1a. Il conteggio corretto — ogni posizione UNA volta sola

| | |
|---|---:|
| posizioni EA nella finestra | **83** |
| posizioni con almeno una sovrapposizione opposta | **25 (30%)** |
| **netto del gruppo sovrapposto** | 🔴 **−91,20** |
| netto delle altre | 🟢 **+293,73** (n=58) |
| episodi di coppia | **23** |
| 🔴 **se si contassero le COPPIE** | **−266,36** ← *l'errore da non fare* |

✅ Riprodotto **al centesimo** il numero del referto anomalie (−91,20 / +293,73 /
25 posizioni / `U30USD` 22, `XAUUSD` 3), il che convalida anche il conteggio
originale. **Sommare i netti delle 23 coppie gonfia la zavorra di 2,9x**, perché
una posizione che incontra tre avversarie viene contata tre volte.

📌 **Conseguenza per la tabella 1b**: la colonna `netto` di ogni COPPIA conta le
sue posizioni una volta sola **dentro quella riga**, ma una posizione presente in
più coppie appare in più righe. **La colonna NON somma a −91,20, e non deve.**

### 1b. Matrice per coppia (11 coppie, tutte quelle esistenti)

| A | B | simbolo | episodi | ore | pos. | netto | cop. A | cop. B | mediana A | mediana B | 🏷️ classe |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| `770511` SW DOW H1 | `771321` PTE DOW | U30USD | 2 | 19,0 | 3 | −13,19 | 51% | 100% | 23,18 h | 9,48 h | 🔴 **CONFLITTO** |
| `770531` SW DOW H2 | `771321` PTE DOW | U30USD | 2 | 18,8 | 3 | −48,32 | 59% | 99% | 29,55 h | 9,48 h | 🔴 **CONFLITTO** |
| `770511` SW DOW H1 | `772234` GAP DOW | U30USD | 2 | 17,0 | 3 | **+97,08** | 31% | 63% | 23,18 h | 13,51 h | 🟠 parziale |
| `770402` MAXMIN ORO | `772343` LARRY ORO | XAUUSD | 1 | 12,5 | 2 | −26,57 | 100% | 72% | 6,03 h | 17,42 h | 🔴 **CONFLITTO** |
| `770511` SW DOW H1 | `772341` LARRY DOW | U30USD | 2 | 10,9 | 3 | **+99,01** | 20% | 100% | 23,18 h | 42,19 h | 🟠 parziale |
| `770511` SW DOW H1 | `771531` EMA200 DOW | U30USD | 4 | 10,4 | 4 | **−0,87** | 43% | 21% | 23,18 h | 3,70 h | 🟢 orizzonti div. |
| `770531` SW DOW H2 | `771531` EMA200 DOW | U30USD | 2 | 3,8 | 3 | −12,61 | 20% | 15% | 29,55 h | 3,70 h | 🟢 orizzonti div. |
| `770402` MAXMIN ORO | `971501` EMA200 ORO | XAUUSD | 1 | 2,6 | 2 | **+39,72** | 21% | 19% | 6,03 h | 12,82 h | ⚪ sfioramento |
| `770611` ORB DOW | `772341` LARRY DOW | U30USD | 3 | 1,8 | 4 | −62,31 | 67% | 1% | 1,00 h | 42,19 h | 🟢 orizzonti div. |
| `771531` EMA200 DOW | `772234` GAP DOW | U30USD | 2 | 0,1 | 3 | −48,10 | 100% | 0% | 3,70 h | 13,51 h | ⚪ sfioramento |
| `771531` EMA200 DOW | `772341` LARRY DOW | U30USD | 2 | 0,1 | 4 | −59,21 | 50% | 0% | 3,70 h | 42,19 h | ⚪ sfioramento |

`cop. A/B` = quota **della vita** della posizione di A (o di B) passata sotto
copertura, media sugli episodi.

### 1c. 🧪 IL CONTRO-ESEMPIO CHE MI ERO PROMESSO: "opposte = spreco" è FALSO

La consegna diceva: *due sedie opposte possono essere una copertura voluta*.
**Misurato, ed è vero in 3 coppie su 11.** Criteri **dichiarati prima di
classificare** (e sono classificazioni, non giudizi di merito):

| classe | regola | coppie |
|---|---|---:|
| 🔴 **CONFLITTO VERO** | sovrapposizione ≥ 3 h **E** copre ≥ 50% della vita di **ENTRAMBE** | **3** |
| 🟠 **CONFLITTO PARZIALE** | ≥ 3 h, ≥ 50% di **una** e ≥ 20% dell'altra | **2** |
| 🟢 **ORIZZONTI DIVERSI** | copertura **asimmetrica** (la lunga cede < 25% della vita) **o** rapporto delle mediane ≥ 4x | **3** |
| ⚪ **SFIORAMENTO** | sovrapposizione **< 3 ore**: irrilevante in ogni caso | **3** |

🟢 **Il caso più bello, ed è quello che salva una sedia**:
`770611` ORB (mediana **1,00 h**) dentro `772341` LARRY DOW (mediana **42,19 h**)
— **rapporto 42x**, l'ORB cede il 67% della sua vita ma LARRY solo **l'1%**.
Quello **non è un conflitto: è uno scalp dentro uno swing**, cioè un portafoglio.
Il netto di quella riga (−62,31) è **interamente degli stop dell'ORB**
(−50,91 e −50,61 contro +76,66): sarebbero arrivati **comunque**, con o senza
LARRY aperta. 🔴 **Chiamarlo "costo della sovrapposizione" sarebbe stato un
errore di attribuzione**, ed è esattamente la trappola che questo referto doveva
evitare.

🟢 **E l'altro**: `770511` SW DOW H1 (23,18 h) vs `771531` EMA200 DOW (3,70 h),
rapporto 6,3x, **la coppia più frequente della matrice (4 episodi)** →
**netto −0,87**. Cioè: **la coppia che si incontra più spesso è quella che costa
zero.** Se la sovrapposizione fosse il difetto, questa sarebbe la peggiore.

🔴 **I tre conflitti veri** sono invece motori con **lo stesso orizzonte** sullo
stesso simbolo che si mettono uno contro l'altro: SW vs PTE sul Dow (due volte) e
**MAXMIN ORO vs LARRY ORO** — quest'ultimo è già agli atti come *"una perdita
certa, decisa alle 07:19"* (conflitto oro dell'08/09, **esposizione netta zero
per 12,5 ore**). Qui la misura lo conferma: **copertura 100% / 72%**.

### 1d. 🧪 SECONDO CONTRO-ESEMPIO: quanto vale davvero il "doppio spread"?

Il meccanismo che si racconta è *"paghi lo spread su tutte e due le gambe"*.
**Misurato**: le 25 posizioni sovrapposte hanno **commissioni + swap per −1,06
EUR in totale** (le altre 58: −21,68). Il loro **profit lordo** è −90,14.

🔴 **Quindi i costi ESPLICITI non spiegano niente dei −91,20.** La componente di
spread è dentro il prezzo di esecuzione e **questo CSV non la separa**:
👉 **[NON MISURABILE] con questi dati.** Si misura solo con lo spread del tick
storico o col Giornale del terminale. **Non ho un numero, e non lo invento.**

### 1e. ⚠️ Dove il campione NON regge (dichiarato)

Su 11 coppie: **2 hanno UN SOLO episodio**, **7 ne hanno 2 o 3**, e **una sola
ne ha 4**. 👉 **Nessuna conclusione per singola coppia è sostenibile.** La
matrice serve a dire **quale struttura** esiste (chi può incrociare chi, con che
orizzonti), **non quale coppia rende**.

---

## 2. 🧮 LA CORRELAZIONE GIORNALIERA — riusata da R16, e con il suo limite

Metodo: identico a `dd_portafoglio.py` (P&L giornalieri per sedia, Pearson),
lo stesso di `REFERTO_PORTAFOGLIO_R16.md` (09/08) dove **4-6 candidate
misuravano fra −0,16 e +0,08** e la diversificazione toglieva **13,2 punti di
DD** (somma 22,11% → combinato 8,91%).

🔴 **MA qui la finestra è di 13 giorni, non di 239.** L'errore standard di una
correlazione su 13 punti è **≈ 0,32**: solo **|r| > 0,63** è distinguibile da
zero a due errori standard.

**Risultato, su 9 sedie con n ≥ 3**: **una sola coppia su 36 supera 0,63**
(`770611` ORB vs `971501` EMA200 oro = **+0,75**, e sono n=3 e n=5 posizioni:
è rumore finché non lo rimisuriamo). Le altre 35 stanno fra **−0,41 e +0,59**,
cioè **dentro la banda del rumore**.

👉 **Verdetto onesto**: su questi 13 giorni **le correlazioni non sono
misurabili**. ❌ Non si può dire "sono scorrelate" — si può dire **"non lo
sappiamo da qui"**. Le uniche correlazioni **misurate davvero** su queste
famiglie restano quelle di **R16 su 239 giornate**: DAX Apertura EU / Dow
Apertura US / MaxMinNotte DAX Short / ORB-EMA200 lab / Nikkei STREV, tutte fra
**−0,12 e +0,06**, con **DD combinato 8,91% contro 22,11% di somma**.
🎯 **Sono, guarda caso, tre delle cinque sedie che propongo qui sotto.**

Valori nella finestra, per le sole coppie che entrano nelle proposte:

| coppia | r (13 gg) | n pos. | lettura |
|---|---:|---|---|
| `770511` vs `771531` | +0,16 | 8 / 11 | dentro il rumore |
| `770511` vs `770101` | −0,18 | 8 / 7 | dentro il rumore |
| `771531` vs `770101` | +0,12 | 11 / 7 | dentro il rumore |
| `771531` vs `970913` | +0,55 | 11 / 2 | dentro il rumore (n=2 su una gamba) |
| `770101` vs `770411` | −0,00 | 7 / 2 | dentro il rumore |
| `770202` vs `770101` | −0,52 | 1 / 7 | 🚫 **n=1: non è un numero** |

---

## 3. 🥇 LA PROPOSTA — tre insiemi alternativi per il 1° ottobre

### 3a. Le regole, dichiarate PRIMA di guardare i netti

1. **R1 — cap per cluster 3,0%** (firmato 07/09, **NON ATTIVO**): nel **caso
   peggiore** (tutte le sedie del gruppo armate insieme) il rischio aperto sullo
   **stesso simbolo** deve stare ≤ 3,0% → **massimo 4 sedie per simbolo** a 0,65%.
2. **R2 — cap complessivo C1 3,25%** (firmato 18/08): caso peggiore totale
   ≤ 3,25% → **massimo 5 sedie** contemporaneamente armabili.
3. **R3 — nessun CONFLITTO VERO dentro il gruppo** (classe 🔴 di §1c).
4. **R4 — gli ORIZZONTI DIVERSI sono AMMESSI e dichiarati** (classe 🟢): uno
   scalp dentro uno swing è portafoglio, non spreco. Misurato in §1c.
5. **R5 — pavimento di frequenza 1,00 op/giorno per FAMIGLIA** (firmato 07/09).
6. 🔴 **R6 — il merito delle singole NON si giudica qui.** 13 giornate e n fra 1
   e 11 per sedia: *il campione sottile sospende il giudizio sul MERITO, mai sul
   RISCHIO*. I DD usati sotto sono quelli **contrattuali** di
   `report/CENSIMENTO_CONTRATTI.md` (backtest, n da 21 a 444), **non** i 13 giorni.

### 3b. I tre gruppi

| | 🥇 **GRUPPO 1 — "un orizzonte per simbolo"** | 🥈 **GRUPPO 2 — "il veloce"** | 🥉 **GRUPPO 3 — "due orizzonti dichiarati sul Dow"** |
|---|---|---|---|
| sedie | `770511` SW DOW H1 · `770202` Dow Apertura US · `770101` DAX Apertura EU · `970913` SupRev NAS H1 · `770411` MaxMin DAX Short | `771531` EMA200 DOW · `770202` · `770101` · `970913` · `770411` | `770511` · `771531` EMA200 DOW · `770101` · `970913` · `770411` |
| **caso peggiore totale** | **3,25%** ✅ = C1 | **3,25%** ✅ | **3,25%** ✅ |
| **caso peggiore per cluster** | U30USD 1,30% · D30EUR 1,30% · NASUSD 0,65% ✅ | idem ✅ | idem ✅ |
| **DD contrattuale: somma** | ~~13,82%~~ 🆕 **11,28%** | ~~15,91%~~ 🆕 **13,37%** | ~~15,77%~~ 🆕 **13,23%** |
| **DD contrattuale: max singolo** | ~~6,89%~~ 🆕 **4,3501%** (`770101`, **dep. 10.000 EUR**) | ~~6,89% (`770101`)~~ 🔴🆕 **4,69% — e CAMBIA PADRONE: `771531` EMA200 DOW** | ~~6,89% (`770101`)~~ 🔴🆕 **4,69% — `771531` EMA200 DOW** |
| **frequenza contrattuale** | **2,35 op/g** | **3,40 op/g** | **3,44 op/g** ⭐ |
| **sovrapposizioni opposte (13 gg)** | 🟢 **0 episodi** | 🟢 **0 episodi** | 🟡 **4 episodi / 10,4 h → netto −0,87** |
| conflitti VERI possibili | **0** (un orizzonte per simbolo) | **0** | **0** (la coppia è 🟢 orizzonti diversi, 6,3x) |
| osservato nei 13 gg (⚠️ descrittivo) | n=20 · 1,54 op/g · netto +348,75 · DD 0,53% | n=23 · 1,77 op/g · netto +54,04 · DD 1,01% | n=30 · 2,31 op/g · netto +284,86 · DD 1,30% |
| picco osservato di sedie simultanee | 2 = 1,30% | 2 = 1,30% | 2 = 1,30% |

> ## 🔴🆕 ERRATA 11/09 (sera) — LE TRE SOMME SONO STATE RIFATTE
> Il DD contrattuale della **`770101`** usato qui era **6,89%**. È **sbagliato**:
> quel numero è la scalatura di **10,5984%**, misurato su
> `r83_csv/..._r83d1.csv`, che ha **`InpAllowShort=1`**, **`InpRiskPercent=1`** e
> **`InpMagic=777120/777121`** — **un'altra configurazione**. Il contratto vero
> della sedia viva è **4,3501% @0,65%** (`ritardo_r119b_csv/..._R119_DAX_D0000.csv`
> r.2: `InpAllowShort=0`, `InpMagic=770101`, PF 1,41105, n 270), **[MISURATO a
> deposito 10.000 EUR]**. ⚠️ **Su un banco da 100.000 EUR il DD promesso è
> `[NON MISURATO]`**: la stessa cella long-only fa **7,2328%** a 100k contro
> **6,7111%** a 10k, **+7,8% a parità esatta di 270 operazioni**. Per proporzione
> starebbe a ~4,69%, **ma una proporzione non fa scattare un allarme.**
> 📄 `report/CONFLITTO_DD_770101_2026-09-11.md`.
>
> **Il conto rifatto** (gli altri quattro DD non cambiano: `770511` 2,60% ·
> `770202` 2,74% · `970913` 0,76% · `770411` 0,83% · `771531` 4,69%):
>
> | | somma | max singolo | ≈ atteso (R16 40,3%) |
> |---|---|---|---|
> | **Gruppo 1** | ~~13,82%~~ → **11,28%** | ~~6,89%~~ → **4,3501%** (`770101`) | ~~5,6%~~ → **4,5%** |
> | **Gruppo 2** | ~~15,91%~~ → **13,37%** | ~~6,89%~~ → **4,69% (`771531`)** | ~~6,4%~~ → **5,4%** |
> | **Gruppo 3** | ~~15,77%~~ → **13,23%** | ~~6,89%~~ → **4,69% (`771531`)** | ~~6,4%~~ → **5,3%** |
>
> ### ⚖️ COSA CAMBIA NEL VERDETTO — e cosa NO
> - ✅ **La raccomandazione NON cambia**: il **Gruppo 1** resta quello col DD
>   contrattuale più basso (**11,28%** contro 13,37% e 13,23%), e il motivo
>   scritto in §3c regge parola per parola.
> - 🔴 **MA CAMBIA IL PADRONE DEL VINCOLO nei Gruppi 2 e 3.** Con 4,3501% la
>   `770101` **non è più la sedia più pesante** di quei due gruppi: lo diventa
>   **`771531` EMA200 DOW con 4,69%**. 👉 La frase di §3d.2 — *"è il vincolo che
>   decide la taglia dell'intero gruppo"* — **è vera solo per il Gruppo 1**.
> - 🟢 **E cade la frase «mangia i due terzi del muro»**: contro un muro di 10%,
>   4,3501% ne mangia **il 43,5%, meno della metà**. Il limite inferiore certo
>   del Gruppo 1 scende di **2,54 punti**.
> - ⚪ **Nessun cap si muove**: R1 (3,0% per cluster) e R2 (3,25% C1) contano il
>   **rischio aperto**, non il DD contrattuale. Restano 3,25% ✅ in tutti e tre.

**DD atteso del gruppo.** L'unica misura di casa che lega somma e combinato è
**R16**: somma 22,11% → combinato **8,91%** = **40,3% della somma**, su 239
giornate. Applicando quel rapporto (🟡 **indicativo, NON una misura di questi
gruppi**): Gruppo 1 ≈ ~~5,6%~~ 🆕 **4,5%**, Gruppo 2 ≈ ~~6,4%~~ 🆕 **5,4%**,
Gruppo 3 ≈ ~~6,4%~~ 🆕 **5,3%**.
**Il limite inferiore certo è il max singolo — 🆕 `4,3501%` nel Gruppo 1,
`4,69%` (`771531`) nei Gruppi 2 e 3 — e il limite superiore certo è
la somma.** 👉 Il numero vero si ottiene solo lanciando `dd_portafoglio.py` sui
CSV per-trade dei backtest di quelle 5 sedie: **è una corsa da preparare, non un
numero da stimare** (proposta operativa in §5).

### 3c. Perché propongo il GRUPPO 1 (e non il più veloce)

- 🥇 **Tre delle cinque sedie hanno la correlazione misurata su 239 giornate**
  (R16: `DAX Apertura EU`, `Dow Apertura US`, `MaxMinNotte DAX Short`, tutte fra
  −0,12 e +0,06). Nessun altro gruppo ha una misura di correlazione vera.
- 🥇 **Zero sovrapposizioni opposte possibili per costruzione**: un solo
  orizzonte per simbolo.
- 🥇 **Il DD contrattuale più basso** dei tre (somma ~~13,82%~~ 🆕 **11,28%**, contro 13,37% e 13,23% — ✅ **il confronto regge anche dopo l'ERRATA**).
- ⚖️ Costa **1,09 op/g contrattuali** rispetto al Gruppo 3 — ma **2,35 op/g
  supera comunque il pavimento di 1,00 per famiglia** con margine 2,3x.

🟡 **Il Gruppo 3 è il migliore se serve FREQUENZA**, e ha una difesa misurata:
la sua unica coppia incrociabile (`770511`/`771531`) è la **più frequente della
matrice (4 episodi)** e costa **−0,87 EUR**. Ma `771531` EMA200 DOW ha DD
contrattuale **4,69% a 0,65%**: da sola, quasi metà del muro. 🔴🆕 **E dopo
l'ERRATA è LEI la sedia più pesante del Gruppo 3** (la `770101` è scesa a
4,3501%): il vincolo di taglia di questo gruppo **non è più il DAX, è l'EMA200
sul Dow**.

### 3d. 🔴 I DUE AVVERTIMENTI CHE NON POSSO TACERE

1. **`770511` SuperWave DOW H1 ha il LATO SHORT misurato ROSSO**:
   **PF 0,429 su n=84** (`CENSIMENTO_LATO_SHORT_2026-09-09.md`, R110). ⚠️ Nei
   13 giorni i suoi short hanno fatto **+244** — **due segnali**, campione che
   non giudica niente. 👉 Chi schiera il Gruppo 1 o il 3 deve decidere prima se
   `770511` va **long-only** o con lo short in osservazione. **Non è una
   decisione che prendo io qui.**
2. ~~**`770101` DAX Apertura EU pesa 6,89% da solo** a 0,65%: *"il suo DD promesso
   da solo mangia i due terzi del muro"* (censimento contratti). È in tutti e tre
   i gruppi perché è la sedia più veloce e con n=311 misurato — ma è **il vincolo
   che decide la taglia dell'intero gruppo**.~~
   🔴🆕 **RISCRITTO 11/09 sera, vedi ERRATA sopra.** La `770101` pesa
   **4,3501%** a 0,65% **[MISURATO a deposito 10.000 EUR]**, non 6,89%: contro il
   muro del 10% ne mangia **il 43,5%, meno della metà**. 🟢 Resta in tutti e tre i
   gruppi perché è la sedia più veloce (0,97 op/g) — e adesso ci resta **costando
   meno**. ⚠️ **Il suo `n` misurato è 270 uscite** (= **193 posizioni** sulla
   gemella long-only), **non 311**: il 311 è della cella col lato corto acceso.
   🔴 **Ed è il vincolo di taglia del solo GRUPPO 1**: nei Gruppi 2 e 3 la sedia
   più pesante è **`771531` EMA200 DOW con 4,69%**.
   ⚠️ **E l'asterisco che non va perso**: il 4,3501% è misurato su banco
   **10.000 EUR**. Sul conto challenge da **100.000 EUR** il DD promesso è
   **`[NON MISURATO]`** (+7,8% misurato sul solo effetto del pavimento del lotto,
   a parità di 270 operazioni) — è la voce **B6** del piano.

### 3e. Chi resta FUORI, e perché — 🚫 nessuna di queste è un verdetto di morte

| sedia | motivo dell'esclusione **dal gruppo** | 🔴 NON è |
|---|---|---|
| `770531` SW DOW H2 | stesso motore e stesso orizzonte di `770511` sullo stesso simbolo: **raddoppia il cluster senza diversificare** (r +0,51, mai opposte, 4.784 min insieme **nella stessa direzione**) | non un giudizio di merito: DD 2,96%, n=88 |
| `771321` PTE DOW · `772234` GAP DOW · `772341` LARRY DOW · `770611` ORB | **cluster U30USD**: R1/R2 lasciano posto a 1-2 sedie sul Dow, non a 8 | `770611` ha DD 6,54% **misurato alla taglia viva** (R119): resta in coda, non in archivio |
| `770402` MAXMIN ORO | DD **19,72% a 1% → 10,0% a 0,5%**: da sola **è tutto il muro**. E fa **CONFLITTO VERO** con `772343` LARRY ORO (copertura 100%/72%) | misurata, n=693 |
| `971501` EMA200 ORO | 🔴 **"prop: NO a nessuna taglia"** — firma del 23/08, DD 45,91% a 1% | fuori per **firma esistente**, non per questa analisi |
| `772362` CostToCost GBPCAD | DD **41,5% a 1% → 10,4% a 0,25%**, PF 0,92 su 6,5 anni | misurata e rossa |
| `772361` EURJPY · `772422` GBPUSD · `772342` EURAUD | DD contrattuali 8,0% / 7,9% / 8,6% alla taglia firmata: entrano solo **al posto** di `770101`, non in aggiunta. 🔴🆕 **ERRATA 11/09 — e il cambio PEGGIORA per loro**: con la `770101` scesa a **4,3501%**, sostituirla con una di queste **aggiunge 3,6-4,3 punti** alla somma del gruppo invece di lasciarla quasi ferma. Lo scambio era quasi neutro contro 6,89%; contro 4,3501% **non lo è più**. | 🔓 **rientrano se il gruppo scende di taglia** — 🔴 ma non più «a costo zero» |
| `770924` STREV Nikkei | 🟠 **DA RIPRODURRE** (deposito ignoto + presenza in campo contesa il 02/09) | **"non ancora misurato"**, non morto |

---

## 4. 🧪 È STATISTICAMENTE REALE? — il test che mi ero imposto

**Domanda giusta**: *quanto sarebbe strano* pescare a caso 25 delle 83 posizioni
e ottenere −91,20 o peggio?

### 4a. Test grezzo
Permutazione (20.000 estrazioni, seed 42): **p = 0,148**.
Distribuzione nulla: p5 **−187,3** · p50 **+56,1** · p95 **+307,9**.
👉 **Non significativo.**

### 4b. 🧪 L'ipotesi alternativa, provata sul serio: *"non è la sovrapposizione, è il Dow"*
22 delle 25 sono su `U30USD`. Se `U30USD` fosse semplicemente il simbolo perdente,
la spiegazione non avrebbe bisogno della sovrapposizione. **Misurato:**

| | n | netto |
|---|---:|---:|
| `U30USD` **totale** | 37 | 🟢 **+189,82** |
| tutto il resto | 46 | 🟡 **+12,71** |
| `U30USD` **sovrapposte** | 22 | 🔴 **−77,99** |
| `U30USD` **non sovrapposte** | 15 | 🟢 **+267,81** |

👉 **L'alternativa cade**: il Dow è stato il simbolo **migliore** della finestra.
Lo spacco è dentro `U30USD`, non fra simboli.

### 4c. 🧪 La SECONDA alternativa — ed è quella che vince
*"Non è la sovrapposizione: sono i GIORNI."*

| | n | netto | di cui sovrapposte | di cui pulite |
|---|---:|---:|---|---|
| chiuse **prima del 05/09** | 66 | 🔴 **−125,28** | n=22 → −77,99 | n=44 → −47,29 |
| chiuse **dal 05/09** | 17 | 🟢 **+327,81** | n=3 → −13,21 | n=14 → **+341,02** |

🔴 **Le giornate buone (07-09/09, trend pulito) contengono quasi solo posizioni
NON sovrapposte.** Il +293,73 delle "pulite" è in buona parte **un effetto
calendario**, non un effetto struttura.

**Test di permutazione STRATIFICATO** (l'etichetta si rimescola **dentro lo
stesso strato**, così il giorno/simbolo non può più spiegare niente):

| stratificazione | osservato | **p** | strati utili |
|---|---:|---:|---:|
| per **GIORNO** | −91,20 | **0,168** | 8/13 |
| per **SIMBOLO** | −91,20 | **0,077** | 2/15 |
| per **SIMBOLO × GIORNO** | −91,20 | **0,174** | 4/49 |
| solo `U30USD`, per **GIORNO** | −77,99 | **0,208** | 3/10 |

⚠️ Nota: il test **non stratificato** dentro `U30USD` dava **p = 0,047** — ed è
proprio quello **confuso dal calendario**. Controllato il giorno, **sale a 0,208**.
Se mi fossi fermato al primo numero avrei consegnato una significatività falsa.

### 4d. 🎯 VERDETTO SULLA SIGNIFICATIVITÀ

> 🔴 **NO: lo svantaggio del gruppo sovrapposto NON è statisticamente reale su
> questo campione.** p fra 0,08 e 0,21 a seconda della stratificazione, e la
> stratificazione più corretta (simbolo × giorno) dà **0,174**. Con 25
> osservazioni su 13 giornate, **−91,20 è compatibile con il caso**.

**E allora cosa resta in piedi?** Tre cose, e non sono statistiche:
1. 🔴 **Il caso peggiore di rischio aperto: 20,15% contro un cap firmato di
   3,25%.** Un fatto aritmetico, non un campione.
2. 🔴 **Il conflitto oro dell'08/09**: esposizione netta **zero per 12,5 ore**
   con copertura **100%/72%** misurata. Una perdita *decisa*, non subita.
3. 🟢 **La struttura degli orizzonti**: 3 coppie su 11 sono **copertura legittima**
   — e quella che si incontra più spesso costa **−0,87 EUR**.

👉 **Quindi il Gruppo 1 non si propone perché "le sovrapposte perdono"** (non è
dimostrato) **ma perché rispetta i due cap firmati e rende il conflitto
impossibile per costruzione.** La differenza fra le due motivazioni è tutta.

---

## 5. 📋 COSA MANCA (e come si chiude, col suo costo)

| # | buco | come si chiude | costo |
|---|---|---|---|
| 1 | 🔴 **DD vero dei tre gruppi** — oggi ho somma e max singolo, non il combinato | `dd_portafoglio.py --deposito 100000` sui CSV per-trade dei backtest di `770511`,`771531`,`770101`,`770202`,`970913`,`770411` | **zero macchina** se i CSV per-trade esistono già in `risultati_prove/`; altrimenti 6 corse tick |
| 2 | 🔴 **Costo di spread della sovrapposizione** — `[NON MISURABILE]` da questo CSV | spread del tick storico, o il Giornale del terminale **50503392** (`BCM Markets MT5 Terminal`, senza `-V3`) | lettura, nessun rischio |
| 3 | 🟠 **Correlazioni vere** di queste 5 sedie: 13 giorni non bastano | stesse corse del punto 1 | come sopra |
| 4 | 🔴 **Il cap per cluster non esiste in campo** (Guardian v1.12) | collaudo di `ABTG_Guardian` v1.13 — già scritto, `backtest_pipeline/attese_cluster.txt` | lavoro di un altro agente, **qui solo registrato** |
| 5 | 🟠 **Il CSV non ha la colonna del conto**: `770101`,`770202`,`770411`,`770611` girano su più terminali | aggiungere il numero di conto all'esportatore | 🔴 **tocca un sorgente: non è mio perimetro** |
| 6 | 🟠 **`770511` lato short PF 0,429 (n=84)** contro +244 in forward su 2 segnali | decisione long-only vs short in osservazione | **decisione, non misura** |

---

## ⚠️ COSA QUESTO REFERTO NON COPRE — dichiarato

- ❌ **Solo posizioni CHIUSE**: le aperte e i pendenti non ci sono. I pendenti
  **impegnano margine** e non entrano in nessun conteggio qui.
- ❌ **13 giornate**: qualunque numero di P/L qui dentro è **descrittivo**.
  Le uniche misure portanti sono i **cap** (aritmetica) e i **DD contrattuali**
  (backtest con n da 21 a 444).
- ❌ **Il rischio è proiettato a 0,65% per sedia** (A1), tenuto vivo per tutta la
  durata: è un **limite SUPERIORE** — parziali, break-even e trailing non sono
  osservabili dal CSV.
- ❌ **Lettura per-SEDIA** usata come primaria: i motori a tranche (`1/3`, `2/3`,
  `L1/L2`) spezzano **un** segnale in più posizioni. La lettura per-POSIZIONE
  (6,50% al picco osservato) è il limite superiore assoluto.
- ❌ **Nessuna simulazione**: non so come questi gruppi si comportino insieme
  fuori da questi 13 giorni. Il punto 1 di §5 è esattamente questo buco.
- ❌ **Nessuna decisione di schieramento**: le sedie in campo **non si toccano**.
  Questo è un documento di **proposta**.
