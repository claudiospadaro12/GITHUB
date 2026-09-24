# 🧮 IL DD DELLE SEI SEDIE ALLA TAGLIA CHE VOLA — la moltiplicazione, fatta su tutte e sei

**24/09/2026** · branch `lavoro` · conto **FTMO `541452707`** (80.000 EUR, 2-Step)
🛑 **SOLA LETTURA E SOLA MISURA.** Nessun EA, nessun preset, nessun parametro, nessun
terminale, nessun forward toccato. Il conto reale **10105439 non compare in nessun comando**.
✋ **Nessun cambio di taglia proposto**: le taglie e il rischio sono firma di Claudio
(firmata il 21/09, `report/FIRMA_TAGLIA_2026-09-21.md`: *«PROVO COSI»*).

---

# 0️⃣ 🔴 IL CONTO CHE APRE IL DOCUMENTO

> ## **DUE sedie su sei sfondano il tetto del 10% DA SOLE sulla finestra fuori campione.**
> ## **TRE su sei se si conta anche la finestra in campione.**
> ## **E il numero di PORTAFOGLIO — che è quello che conta davvero — è 13,91%, MISURATO, su quattro sedie su sei.**

| | sedia | DD @2,00% (finestra OOS) | verdetto |
|---|---|---:|---|
| 1 | 🔴 **`771531`** EMA200 Dow | **15,66%** *(metrica stretta: 18,39%)* | **SFORA** |
| 2 | 🔴 **`770101`** DAX Apertura | **14,50%** *(misurato diretto: **14,14%**; metrica stretta 17,81%)* | **SFORA** |
| 3 | 🟠 **`770202`** Dow Apertura | 8,79% OOS · 🔴 **11,35% IS** | **SFORA SOLO IN CAMPIONE** |
| 4 | 🟢 **`770511`** SuperWave Dow | 8,43% *(banda 7,82–8,43)* | sotto |
| 5 | 🟢 **`770260`** Nasdaq RETEST | **7,86%** — 🥇 **misurato A 2,00% E A 80.000, zero proporzioni** | sotto |
| 6 | 🟢 **`770411`** MaxMin DAX Short | 3,84% | sotto |

🟢 **E la prima buona notizia, che va detta subito**: la moltiplicazione **era già stata fatta**
il 20/09 (`report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` **§10, r.419-425**) e il suo conto
— *«due sedie sfondano, altre due sulla finestra IS»* — **regge alla riverifica**. Questo
documento non scopre il buco: lo **riverifica al CSV**, lo **aggiorna con tre misure nuove** che
nel frattempo sono arrivate, e **corregge una riga che nel frattempo è diventata falsa**
(la `770260`, §4).

---

# 1️⃣ ⚖️ LA CLAUSOLA ONESTA, prima di ogni numero — e non è una formalità

🔴 **Un `Equity DD %` misurato su 12-21 mesi NON è la perdita attesa in una challenge che dura
settimane.** La frase corretta, e la scrivo una volta perché valga per tutta la pagina:

> ## **Le sedie sono tarate in modo che una brutta serie NORMALE — una che nei dati capita — chiuda la challenge.**
> **Non**: *«perderemo il 15%»*. La challenge può benissimo finire prima che quella serie arrivi.

E con essa, le **cinque differenze fra il banco e il campo**, tutte dichiarate:

| # | differenza | verso dell'errore |
|---|---|---|
| **a** | `Equity DD %` misura la discesa **dal PICCO**; il muro FTMO 2-Step è **STATICO dal saldo iniziale** (*«equity must not drop below 90% of the initial account balance at any given time»*, `docs/REGOLAMENTO_FTMO_2026-08.md` **r.27**) | ⬇️ **a nostro favore**: un 15% dal picco, con il picco a +20%, non tocca il muro |
| **b** | la scala del rischio è **lineare** (convenzione di casa), e il lineare **SOVRASTIMA**: misurato su `771531` short, 2,6628→5,2951 dove il lineare predice 5,3256 (**+0,58%**) e 4,5113→8,9027 contro 9,0226 (**+1,35%**) | ⬇️ **a nostro favore**: i `×2` sono **tetti**, non stime |
| **c** | il feed è **BCM** (`D30EUR`/`U30USD`/`NASUSD`), il campo è **FTMO** (`GER40`/`US30`/`US100.cash`) | ❓ **incognita** — ma un DD è una **percentuale**, e una percentuale non si sposta di quattro punti cambiando feed |
| **d** | 🔴 **lo slippage vero non è nel backtest.** Il primo stop vero della challenge (22/09, `771531`) è stato riempito **7,83 punti oltre** il livello: **−1.757,68 €** contro i **−1.590,37 €** promessi = **+10,5%** (`report/PRIMO_STOP_FTMO_2026-09-22.md` §1-2) | ⬆️ **contro di noi** — ⚠️ **è UNA osservazione (n=1)**, non un fattore accertato |
| **e** | nessuna delle misure descrive **esattamente** il binario che vola: i `.set` FTMO portano `InpUsaGuardian=true` e qualche input nuovo che il banco non aveva | ❓ vedi §7 |

📐 **E la metrica stretta, riportata accanto in ogni riga**: `DD fisso % = (Profit / Recovery
Factor) / deposito`. Vale la catena dimostrata in casa
`perdita statica ≤ Equity DD % ≤ DD_ass/deposito`
(`report/IL_MURO_MISURATO_2026-09-22.md` **r.95-102**) — 🟢 **e l'ho riverificata io su tutte e
16 le celle di questo documento: `DD fisso ≥ Equity DD` in 16 casi su 16, nessuna eccezione.**
👉 È un **limite superiore**, quindi la colonna che **scatta presto**, che è il verso giusto.

---

# 2️⃣ 📊 LA TAVOLA — una riga per sedia, come richiesta

**Tutte e sei le sedie volano a `InpRiskPercent = 2.00`** — verificato da me nei sei `.set`
di `mql5/Presets/FTMO/` (righe: `770101` r.268 · `770202` r.283 · `770260` r.292 ·
`770411` r.275 · `770511` r.88 · `771531` r.149).

| magic | **DD promesso dal contratto** | a che **rischio** | **deposito** della misura | **DD scalato a 2,00%** | **supera il 10%?** | fonte (file + riga) |
|---|---:|---:|---:|---:|:---:|---|
| 🔴 **`771531`** EMA200 Dow · U30USD H1 | OOS **7,8323%** · IS **5,7325%** | **1,00%** | **100.000 €** *(conto: 80.000)* | 🔴 **OOS 15,66%** · IS **11,47%**<br>*(DD fisso: **18,39%** · 11,64%)* | 🔴 **SÌ, su tutte e due le finestre** | `backtest_pipeline/risultati_archivio/R112_CORSA_20260826/ABTG_EMA200_U30USD_OOS_00_metro.csv` **r.3** (`Pass 0`, `InpRiskPercent=1`, PF 1,52365, n 517, Profit 23.321,47, RF 2,53681) · `..._IS_00_metro.csv` **r.3** · deposito: `backtest_pipeline/righe/RIGA_R112_EMADOW_CONTRATTO.ps1` **r.204** |
| 🔴 **`770101`** DAX Apertura EU · D30EUR M5 | OOS **7,2506%** · IS **5,4089%** | **1,00%** | 🥇 **80.000 €** *(= il conto vero)* | 🔴 **OOS 14,50%** · IS **10,82%**<br>*(DD fisso: **17,81%** · 11,69%)*<br>🎯 **misurato diretto a 2,00%: 14,14%** | 🔴 **SÌ, su tutte e due le finestre** | `backtest_pipeline/risultati_prove/R201A/ABTG_DAX_Apertura_EU_D30EUR_OOS_R201A.csv` **r.2** (`Pass 0`, `InpBEatR=0`, `InpTP1_ClosePct=50`, `InpRiskPercent=1`, PF 1,39520, n 270, Profit 14.355,32, RF 2,01544) · `..._IS_R201A.csv` **r.2** · deposito: `risultati_prove/R201A/REFERTO_ROUND_R201A.txt` r. `deposito` = **80000** · misura diretta: `report/REFERTO_R239_2026-09-24.md` **r.71** |
| 🟠 **`770202`** Dow Apertura US · U30USD M5 | OOS **4,3944%** · IS **5,6726%** | **1,00%** | 🥇 **80.000 €** *(= il conto vero)* | 🟢 **OOS 8,79%** · 🔴 **IS 11,35%**<br>*(DD fisso: 8,90% · **11,52%**)*<br>🎯 **misurato diretto a 2,00%: 8,30%** | 🟠 **SOLO sulla finestra IS** | `backtest_pipeline/risultati_prove/R172D/ABTG_Dow_Apertura_US_U30USD_OOS_R172D.csv` **r.2** (`Pass 0`, PF 1,27175, n 130, Profit 5.395,25, RF 1,51555) · `..._IS_R172D.csv` **r.2** · deposito: `risultati_prove/R172D/REFERTO_ROUND_R172D.txt` = **80000** · misura diretta: `report/REFERTO_R239_2026-09-24.md` **r.72** |
| 🟢 **`770511`** SuperWave Dow · U30USD H1 | 🔴 **CONTESO**: OOS **3,9082%** ↔ **4,1675%** ↔ **4,2149%** · IS 3,7267 ↔ 4,0393 ↔ 3,4846 | **1,00%** | 🔴 **10.000 €** (due corse) **e 100.000 €** (una) *(conto: 80.000)* | 🟠 **OOS 7,82% – 8,43%** · IS 6,97–8,08%<br>*(DD fisso: 8,47–8,94% · 7,42–8,70%)* | 🟢 **NO** — ma con **banda** e **deposito sbagliato** | archivio 26/07: `risultati_prove/ABTG_SuperWave_DOW_H1_Ottimizzato/..._U30USD_OOS.csv` **r.3** (`Pass 3`, PF 1,32770, n 143, Profit 463,44, RF 1,09483, dep **10.000**) ⚔️ `risultati_prove/dal_vps/ABTG_SuperWave_DOW_H1_Ottimizzato/..._OOS_r120b11.csv` **r.3** (`Pass 0`, PF 1,24312, n 131, dep **10.000**) ⚔️ `..._OOS_r120e11.csv` **r.2** (`Pass 0`, n 184, dep **100.000**) |
| 🟢 **`770260`** Nasdaq RETEST · NASUSD M5 | 🥇 **OOS 7,8576%** · IS **7,3069%** | 🥇 **2,00%** *(= la taglia viva)* | 🥇 **80.000 €** *(= il conto vero)* | 🟢 **OOS 7,86%** · IS **7,31%** — **NESSUNA SCALA**<br>*(DD fisso: 8,19% · 7,63%)* | 🟢 **NO, e senza una sola proporzione** | `backtest_pipeline/risultati_prove/R199B/ABTG_Nasdaq_Apertura_US_NASUSD_OOS_R199B.csv` **r.4** (`Pass 2`, `InpTP1_ClosePct=50`, **`InpRiskPercent=2`**, `InpMagic=770260`, PF 1,21546, n 172, Profit 8.496,74, RF 1,29687) · `..._IS_R199B.csv` **r.4** · deposito: `risultati_prove/R199B/REFERTO_ROUND_R199B.txt` = **80000** |
| 🟢 **`770411`** MaxMin DAX Short · D30EUR M15 | OOS **1,9213%** · IS **3,0977%** | **1,00%** | **100.000 €** *(conto: 80.000)* | 🟢 **OOS 3,84%** · IS 6,20%<br>*(DD fisso: 4,07% · 6,27%)* | 🟢 **NO** | `backtest_pipeline/risultati_prove/ABTG_MaxMinNotte_DAX_Short_Ottimizzato/..._D30EUR_OOS_ptb.csv` **r.3** (`Pass 0`, `InpMagic=770411`, PF 2,15985, n 21, Profit 6.143,38, RF 3,02118) · `..._IS_ptb.csv` **r.3** · deposito: `backtest_pipeline/prove/R16b_pertrade_MaxMinNotte.txt` **r.3** |

> 📎 **Nota sulle righe citate, perché differiscono da quelle del censimento del 20/09.** In tre
> di questi CSV ci sono **due righe gemelle** (le due celle del cancello di determinismo G1, che
> differiscono **solo** per il magic e hanno **valori identici al quinto decimale**). Io cito
> sempre **`Pass 0`**, che è la prima cella della coppia: `771531` → r.3 (`Pass 0`, magic banco
> `763400`) invece di r.2 (`Pass 1`, `763401`); `770411` → r.3 (`Pass 0`, magic **`770411`**)
> invece di r.2 (`Pass 1`, `770412`). **Stessi numeri al quinto decimale, criterio dichiarato.**
> ⚠️ **E sulla `771531` va detto che nessuno dei due magic è quello della sedia**: il banco R112
> gira a `763400/763401`. L'identità della cella è stata stabilita **per diff degli input**, non
> per magic (`CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` §3.1: **39 `Inp*` su 43 identici**).

### 🔢 Il conto, in chiaro
| criterio | quante sfondano il 10% |
|---|---|
| `Equity DD %` **×2**, finestra **OOS** | 🔴 **2 su 6** — `771531` · `770101` |
| `Equity DD %` **×2**, **almeno una** finestra | 🔴 **3 su 6** — `771531` · `770101` · `770202` |
| **DD fisso** (metrica stretta), finestra **OOS** | 🔴 **2 su 6** — le stesse due |
| **DD fisso**, **almeno una** finestra | 🔴 **3 su 6** — le stesse tre |
| col **+10,5% di slippage** del 22/09 applicato *(n=1, sensibilità)* | 🔴 **2 su 6** in OOS (17,30% e 15,63%) · 🟠 `770202` sale a **9,71%**, `770511` a **9,32%**: **due sedie arrivano AL muro** |

🟢 **Notizia buona, e conta**: le due sedie che sfondano sono **le stesse con tutte e due le
metriche e con tutti e quattro i percorsi di misura**. **Non è un artefatto della metrica scelta.**

---

# 3️⃣ 🧪 IL CONTRO-ESEMPIO, costruito PRIMA del verdetto — quattro, e due mordono

### (a) *«il 14% del DAX è un artefatto della scala lineare»* → 🔴 **RESPINTO, e con quattro strade indipendenti**
Se il `×2` fosse il colpevole, la misura **diretta a 2,00%** dovrebbe uscire molto più bassa.
**Non esce.** Le quattro strade per la stessa sedia, stessa cella, stessa finestra OOS:

| strada | deposito | rischio della misura | DD @2,00% |
|---|---:|---:|---:|
| **R239b — misurata DIRETTAMENTE a 2,00%** | 100.000 | **2,00%** | **14,14%** |
| R201A `Pass 0` ×2 | **80.000** *(il conto vero)* | 1,00% | **14,50%** |
| `aperture_r47/..._OOS_r47a.csv` r.2 ×2 | 100.000 | 1,00% | **14,47%** |
| censimento v2 (`4,3501% @0,65%`) ×3,0769 | 10.000 | 0,65% | **13,38%** |

**Escursione fra la più bassa e la più alta: 1,12 punti su ~14.** 👉 Il numero è **robusto**, e
lo scarto va **nel verso previsto** (il lineare sovrastima del 2,3-2,5%: 14,50 → 14,14).

### (b) *«forse il banco non misura la sedia che vola»* → 🔴 **RESPINTO, con il diff campo per campo**
Ho diffato **ogni colonna `Inp*`** delle tre celle di round contro il `.set` FTMO corrispondente
(script mio, confronto per nome, `true/false` normalizzati):

| sedia | uguali | diversi | le differenze, tutte spiegate |
|---|---:|---:|---|
| `770101` (R201A `Pass 0` vs `ABTG_DAX_Apertura_EU_770101_FTMO.set`) | **77** | **5** | `InpSessionHour` 8→10 · `InpCloseHour` 17→19 (**rimappatura oraria FTMO = BCM+2**) · `InpCorrSymbol` `SPXUSD`→`US500.cash` (nome broker) · `InpRiskPercent` 1→2,00 · `InpMagic` |
| `770202` (R172D `Pass 0`) | **76** | **5** | idem (`InpSessionHour` 14→16) · **zero input extra** |
| 🥇 `770260` (R199B `Pass 2`) | **95** | **3** | **solo** le due ore e `InpCorrSymbol`. 🟢 **`InpRiskPercent` NON è fra le differenze: sono 2,00 tutti e due. E il magic coincide: `770260`.** |

🟠 **L'unico residuo, e lo dichiaro**: il CSV di `770101` porta **9 colonne che il `.set` non
valorizza** (`InpSpaceMode`, `InpSpaceTF`, `InpSpaceMinR/MaxR`, `InpSpaceEma1-4`, `InpSpaceUseST`).
**Sono a default inerte**: `InpSpaceMode = ABTG_SPACE_OFF` = `0` = *«spento, no-op»*
(`mql5/Experts/ABTG_DAX_Apertura_EU.mq5` **r.395**), e nel CSV valgono esattamente il default.
👉 **Non toccano il numero.**

### (c) *«e se le due finestre non fossero confrontabili?»* → 🟠 **ACCOLTO IN PARTE, e cambia la lettura**
`770101`, `770202`, `770411`, `770511`, `771531` girano tutte su
**IS 2024.09.26→2025.06.09 · OOS 2025.06.10→2026.06.30**. 🔴 **La `770260` no**: la sua
partizione è **IS 2024.09.26→2025.06.30 · OOS 2025.07.01→2026.06.30** (walk-forward Aperture) —
e nei round R199 gira sulla stessa finestra della famiglia. Dove la finestra differisce, il
confronto fra sedie **non è paritario**, e va letto colonna per colonna, non in classifica.
🔴 **E tutte e sei hanno un SOLO REGIME dentro (toro)**: l'Emendamento C del 16/08 dice che una
storia contigua in un regime solo **descrive un mercato, non il mercato**.

### (d) 🔴 *«il 10% è quello giusto? e la riga citata lo dice?»* → **ACCOLTO: la citazione del mandato NON regge, il numero SÌ**
Il mandato cita `report/PIANO_CHALLENGE_OTTOBRE_v2.md` **r.268** per il tetto del 10%.
**Sono andato a leggere quella riga, e dice un'altra cosa**: è dentro la sezione del **16/09**
in cui **FundedNext Stellar Lite sostituisce FTMO come metro di quel documento**, e r.268
recita testualmente *«"5% giornaliero", "10% totale" o "STATICI" resta scritto com'era per
tracciabilità»*. 👉 **È una nota di archiviazione, non la fonte del muro.**
🟢 **Il numero però è giusto e la fonte esiste**: `docs/REGOLAMENTO_FTMO_2026-08.md` **r.27** —
*«The 2-Step FTMO Challenge uses a **Static** Maximum Loss type… equity must not drop below 90%
of the initial account balance at any given time»*, più **Max Daily Loss 5% su EQUITY** (r.26).
**Su 80.000 EUR: muro statico a 72.000 · muro giornaliero 4.000 EUR/giorno.**
👉 **Da qui in avanti la fonte del muro è `docs/REGOLAMENTO_FTMO_2026-08.md` r.26-27**, non il
piano di ottobre. *(Classe nuova: una citazione ereditata che punta a una riga che dice un'altra cosa.)*

---

# 4️⃣ ✏️ LA RIGA CHE HO DOVUTO CORREGGERE — **`770260`, e la correzione è in MEGLIO** (classe 693)

Il censimento del 20/09 (`CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` **r.65**) dà alla `770260`
**OOS 3,6753% · IS 5,9528% @1,00% @10.000 €** → **7,35% e 🔴 11,91%** @2,00%.
🔴 **Quella riga oggi è SUPERATA, e lo è per due motivi insieme:**

1. **La cella è CAMBIATA il 21/09 alle 20:22**, con firma di Claudio (*«ACCENDILA AL 50%»*):
   commit **`496408a9`** — *«Nasdaq 770260: ACCESA la parziale al 50%»*. Il `.set` che vola oggi
   ha **`InpTP1_ClosePct=50.0`** (`mql5/Presets/FTMO/ABTG_Nasdaq_Apertura_US_RETEST_770260_FTMO.set`
   **r.354**). Il contratto del 20/09 descrive la cella **`ClosePct=0`**, cioè **un'altra sedia**.
2. **Esiste una misura migliore, ed è al banco e alla taglia VERI.** `R199B`, girato il
   **21/09 alle 22:13** sul PC di backtest, **deposito 80.000**, **`InpRiskPercent=2`**, tick reali.

| | vecchia cella `ClosePct=0` | 🟢 **cella IN CAMPO `ClosePct=50`** |
|---|---:|---:|
| `Equity DD %` **IS** @2,00% | 🔴 **12,3568%** | 🟢 **7,3069%** *(−40,9%)* |
| `Equity DD %` **OOS** @2,00% | 🟠 **9,1244%** | 🟢 **7,8576%** *(−13,9%)* |
| PF IS / OOS | 1,11621 / 1,14894 | **1,22116 / 1,21546** |
| **Peggior Giornata %** IS / OOS | −2,0775 / −2,1282 | **−2,0395 / −2,1327** |

> ## 🎉 **La `770260` è l'UNICA delle sei con un contratto misurato ALLA TAGLIA E AL DEPOSITO VERI. Zero proporzioni, zero asterischi. Ed è sotto il muro su tutte e due le finestre.**
> 🟢 **E la firma del 21/09 ha tolto una sedia dalla lista di quelle che sfondano**: con la
> vecchia cella, l'IS faceva 12,36% — **avrebbe sfondato**. **Il metodo ha funzionato in sei ore.**

🔴 **Nota di metodo, perché è esattamente la classe 693**: se avessi preso la riga PADRE del
20/09 senza guardare cosa era successo il 21, avrei scritto *«770260 sfora in IS»*. **Falso da
tre giorni.**

---

# 5️⃣ 💰 IL DEPOSITO DELLA MISURA — riportato per tutte e due le strade, dove serve

Il deposito **morde**, e in una direzione misurata: a banco piccolo il `MathFloor` sullo step del
lotto **taglia la taglia**, quindi il DD **scende**. Misurato in casa su trade identici:
**`770101` +7,8%** (6,7111% a 10k → 7,2328% a 100k) e **`771531` +8,6%** (7,2138 → 7,8323)
(`CENSIMENTO_CONTRATTI_v2.md` **r.259** e **r.378**).

| sedia | deposito della misura | conto vero | la conclusione cambia? |
|---|---|---|---|
| 🥇 `770101` | **80.000** (R201A) **e** 100.000 (r47a/R239b) | 80.000 | 🟢 **NO, e non serve nessuna proporzione**: le due strade danno **14,50%** e **14,47%**, scarto **0,2%**. **Sfora in tutte e due.** |
| 🥇 `770202` | **80.000** (R172D) **e** 100.000 (r47c) | 80.000 | 🟢 **NO**: 8,79% e 8,79% — identiche al centesimo. |
| 🥇 `770260` | **80.000** | 80.000 | 🟢 **NO: coincidono.** |
| 🟠 `770411` | 100.000 | 80.000 | 🟢 **NO**: misurata a banco **più grande** del vero, e il `MathFloor` dice che a banco **minore** il DD **scende** → **3,84% è un limite SUPERIORE**, e a 80.000 sarebbe **più basso**. Anche invertendo il segno della correzione per prudenza (+8%) resterebbe **4,15%**, cioè 2,4× sotto il muro. |
| 🔴 `770511` | **10.000** (due corse) **e** 100.000 (una) | 80.000 | 🟠 **NON CAMBIA IL VERDETTO, MA RIDUCE IL MARGINE.** A 10.000 il numero è un **limite INFERIORE**: correggendolo del +7,8%/+8,6% misurato, `7,82–8,34%` diventa **8,43–9,06%**. La misura a **100.000** (`r120e11`) dà **8,43%** — **concorda**. 🔴 Con lo slippage del 22/09 sopra (×1,105) arriva a **9,32%**: **sotto il muro, ma con 0,7 punti di margine.** |
| 🟠 `771531` | 100.000 | 80.000 | 🟢 **NO**: 15,66% è un limite superiore, e sfonda di 5,7 punti. |

---

# 6️⃣ 🧱 IL NUMERO DI PORTAFOGLIO — **ESISTE, è MISURATO, ed è 13,91%**

Il mandato chiedeva se in archivio ci fosse una misura di DD **di portafoglio**. **C'è**, ed è
`report/DD_PORTAFOGLIO_FTMO_2026-09-20.md`. Riporto i suoi numeri con la riga.

| | @1,00% *(come misurato)* | **@2,00%** *(la taglia che vola)* | riga |
|---|---:|---:|---|
| netto sulla finestra | +54.216 (+54,2%) | +108.433 | r.109 |
| **max DD dal picco**, in % del deposito | 6,95% | 🔴 **13,91%** | **r.110** |
| **peggior giornata storica** | −3,44% | 🔴 **−6,87%** *(26/02/2026)* | **r.111** |
| giornate oltre **−5,00%** (muro giornaliero FTMO) | **0** | 🔴 **2** | r.112 |
| Monte Carlo 5.000 rimescoli — discesa sotto il saldo iniziale, **p95** | 7,26% | 🔴 **14,53%** | r.115 |
| Monte Carlo — **p99** | 11,46% | 🔴 **22,91%** | r.116 |
| 🔴 **sequenze MC che sfondano il 10% STATICO** | **1,7%** | 🔴 **12,4%** | **r.117** |

🟢 **E la diversificazione NON è il problema**: correlazioni giornaliere **fra −0,01 e +0,13**,
somma dei singoli 19,28% → combinato **5,19%** dal picco a 1,00% (r.121, r.429).
🔴 **Il problema è la TAGLIA**: da 1,00% a 2,00% le sequenze che sfondano passano da **1,7%** a
**12,4%** — **×7,3**, non ×2 (r.123).

## 6.1 🔴 E i **due asterischi** del numero di portafoglio, che vanno detti insieme al numero

| # | limite | verso |
|---|---|---|
| **1** | 🔴 **è misurato su QUATTRO sedie su sei.** Mancano `770511` e `770260`, perché **non esiste il loro per-trade in repo** (r.85-91). E le due che mancano sono **entrambe correlate a quelle che ci sono**: `770511` è la **terza** sedia su `U30USD`, `770260` apre sulla **stessa campana USA** di `770202` | ⬆️ **contro di noi**: aggiungere due sedie correlate non può migliorare il numero in modo prevedibile |
| **2** | 🔴 **`dd_portafoglio.py` aggrega per GIORNO**, quindi **non vede il flottante DENTRO la giornata**: sul DAX dà 6,25% dove il tester tick-by-tick dà 7,2328% (**−15,7%**). E il muro FTMO è su **equity**, cioè include proprio quel flottante | ⬆️ **contro di noi** |

> ## 👉 **Il 13,91% è un PAVIMENTO, non un tetto** (r.97). Ed è, con ogni probabilità, **il numero più importante di tutto il progetto** — perché è l'unico che risponde alla domanda vera: *«quanto scende IL CONTO»*, non *«quanto scende una sedia»*.

## 6.2 🕳️ Che cosa servirebbe per chiuderlo — **`[NON MISURATO]` nominati per nome**

| # | buco | via più corta | costo |
|---|---|---|---|
| **P1** | 🔴 **per-trade di `770511`** sulla finestra OOS, **stesso deposito e stesso rischio** delle altre quattro (100.000 · 1,00% · tick) | una corsa della cella `11` (`InpTrailOnST=true`, `InpExitOnFlip=true`) **con l'export per-trade acceso e un magic vergine** — 🟢 **chiude anche il buco B2/B3 del 20/09** (la sedia **non riproduce** fra il binario di luglio e quello di settembre) | ~1 min di tester |
| **P2** | 🔴 **per-trade di `770260`** sulla stessa finestra e sullo stesso deposito delle altre | una corsa `R199B Pass 2` con l'export acceso | ~1 min |
| **P3** | 🔴 **il portafoglio a SEI**, rifatto con l'equity **intragiornaliera** e non l'aggregazione per giorno | un passaggio su `dd_portafoglio.py` che legga l'equity tick invece dei deal chiusi — **o**, più semplice, leggere `Peggior Giornata %` dell'OPTFRAME, che è **già equity-based tick-per-tick** | **zero macchina** per la seconda strada |
| **P4** | 🔴 **il muro giornaliero della `771531` è `[NON MISURATO]` su OGNI cella**: i CSV di `EMA200` **non hanno la colonna `Peggior Giornata %`** (verificato su tutti quelli citati) | rilanciare la cella `00_metro` con il driver che stampa quella colonna | ~45 s |
| **P5** | 🔴 **il forward vero non è ancora leggibile**: `ABTG_Trades_FTMO.csv` esiste ed è della challenge, ma contiene **2 posizioni chiuse** e `CODA_12` lo salta per un nome di colonna (`pid` invece di `position_id`); `data/statements/trades_ftmo.csv` **non è mai esistito nel repo** (`report/IL_PERTRADE_FTMO_ESISTE_2026-09-23.md` §0) | una riga di lettura + la toppa alla pubblicazione | zero round |

---

# 7️⃣ ℹ️ QUALE RISCHIO RIPORTEREBBE SOTTO IL TETTO — **informazione, NON raccomandazione**

✋ **Non propongo nessun cambio di taglia. La taglia è firmata al 2,00% dal 21/09 ed è firma di
Claudio.** Porto il numero perché è stato chiesto, e perché senza di esso la tabella sopra non si
può usare per decidere.

**Convenzione**: DD e profitto scalano **tutti e due** col rischio. Quindi il taglio di profitto è
**uguale** al taglio di rischio. 🟢 **E il conto è conservativo**: il DD è **sub-lineare**
(`1−(1−2r)^N < 2·(1−(1−r)^N)`), quindi al rischio indicato il DD vero starebbe **un po' sotto** il 10%.

| sedia | DD @2,00% usato | **rischio che la porta a 10%** | **quanto profitto costa** | sulla metrica stretta (DD fisso) |
|---|---:|---:|---:|---:|
| 🔴 `771531` EMA200 Dow | 15,66% | **1,28%** | **−36,1%** | 1,09% → −45,6% |
| 🔴 `770101` DAX Apertura | 14,14% *(misurato diretto)* | **1,41%** | **−29,3%** | 1,12% → −43,8% |
| 🟠 `770202` Dow Apertura *(solo per coprire l'IS)* | 11,35% (IS) | **1,76%** | **−11,9%** | 1,74% → −13,2% |
| 🟢 `770511` · `770260` · `770411` | 8,43 · 7,86 · 3,84% | **già sotto** | — | già sotto |
| 🧱 **IL PORTAFOGLIO** *(il numero che conta)* | **13,91%** | **1,44%** | **−28,1%** | — |

📌 **E la terza via, che non passa dalla taglia, ESISTE ED È GIÀ MISURATA** — sta in
`report/LE_DUE_SEDIE_SOPRA_IL_MURO_2026-09-23.md`, e la cito senza raccomandarla:
- `771531` · `InpTP1_ATRmult` **0,25 → 4,44%** e **0,50 → 7,01%** @2,00%: 🟢 **due celle
  CONTIGUE sotto il muro in TUTTE E DUE le finestre** (altopiano vero, non picco). 🔴 **Ma in IS
  il PF va a 0,99392 / 1,01379**: si compra il drawdown, **non** il merito.
- `770101` · `InpBEatR` **0,15 → 8,74%** @2,00%: 🔴 **è IL PICCO** (1ª su 7 per PF, e il suo unico
  vicino `0,30` è l'**ULTIMA** su 7). **Per la regola di casa NON è selezionabile.**
- `770101` · `InpTP1_ClosePct` **50 → 0**: 🥇 migliora PF, RF, DD **e profitto** in tutte e due le
  finestre, 🔴 **ma resta a 15,95%**: **non porta sotto il muro.**

🟢 **E la rete esiste**: il Guardian chiude tutto a **72.560 EUR** (9,3% statico) contro il muro a
**72.000**. 🔴 **Margine: 560 EUR = 0,70%**, e **lo slippage di chiusura simultanea contro quel
margine è `[NON MISURATO]`** (`FIRMA_TAGLIA_2026-09-21.md` §2 punto 2). 🔴 **E il Guardian non
riporta in gara**: a −9,3% resterebbe 0,70% di spazio e servirebbe **+10%** da lì.

---

# 8️⃣ 🕳️ I BUCHI DI QUESTO DOCUMENTO, dichiarati

| # | buco | perché non l'ho chiuso |
|---|---|---|
| **1** | 🔴 **I CSV di R239 non sono in repo.** Il `14,14%` e l'`8,30%` misurati a 2,00% li ho presi dal referto (`REFERTO_R239_2026-09-24.md` r.71-72), **non dal file sorgente** — che non è stato committato (lo zip stesso dichiara `RIEPILOGO_R239.txt` e i `LOG_TESTER` mancanti) | non è in repository. 🟢 **Ma non decidono niente da soli**: le altre tre strade su `770101` danno 13,38 / 14,47 / 14,50, e su `770202` 8,79 / 8,79 |
| **2** | 🔴 **`770511` ha un contratto CONTESO e il delta è FUORI dal `.set`**: stessa cella, **41 input su 41 identici**, due corse danno `n 143 / DD 3,9082` e `n 131 / DD 4,1675`. Resta il **binario** (contratto del 26/07 = `a4107cf`; vola il pin `872dba82` del 19/09, che contiene il **fix del pavimento del lotto**) o lo **storico tick** ricaricato | serve una corsa, ed è il buco **P1** |
| **3** | 🔴 **Nessuna delle sei misure gira sul binario che vola**: i `.set` FTMO portano **`InpUsaGuardian=true`**, che nei banchi non c'era — 🟢 **eccezione: sulla `771531` il Guardian era GIÀ nel banco** (`InpUsaGuardian=1` nella riga R112) | è il buco **B6** del 20/09, e costa ~10 min sul terminale banco `50504400` (🔴 **spento mentre la challenge opera**, firma del 21/09) |
| **4** | 🟠 **Il `+10,5%` di slippage è UNA osservazione** (un solo stop, due gambe, stessa esecuzione). L'ho usato **solo** come colonna di sensibilità, mai dentro un verdetto | servono altri stop veri. Arrivano da soli |
| **5** | 🔴 **Tutte e sei le finestre contengono UN SOLO REGIME (toro)** | è l'Emendamento C: la prova di regime batte la storia contigua, e qui non c'è |
| **6** | 🟠 **`770260` gira su una partizione IS/OOS DIVERSA** dalle altre cinque | il confronto fra sedie va letto riga per riga, non in classifica |

---

# 9️⃣ ✅ COSA È ANDATO BENE — perché un elenco di difetti senza le vittorie descrive male la realtà

- 🥇 **Il conto era già stato fatto il 20/09, e regge alla riverifica al CSV.** Non abbiamo
  scoperto un buco vecchio di mesi: abbiamo **riconfermato un numero che era già a referto**.
- 🎉 **La `770260` è stata SALVATA da una firma di sei ore.** Il 21/09 la misura ha trovato la
  parziale al 50%, Claudio ha firmato alle 20:22, e oggi quella sedia ha **l'unico contratto del
  progetto misurato alla taglia E al deposito veri** — e **sta sotto il muro**.
- 🟢 **Quattro strade indipendenti concordano su `770101`** (13,38 / 14,14 / 14,47 / 14,50):
  escursione 1,1 punti su 14. **La catena di misura di casa è coerente.**
- 🟢 **Il diff dei preset è pulito**: 77/76/95 input identici, e **ogni** differenza è spiegata
  (ore FTMO = BCM+2, nome simbolo del broker, taglia, magic). Nessuna sorpresa.
- 🟢 **La `770411` è sotto il muro con margine 2,6× e la `770260` con margine 1,3×.** Non è vero
  che «tutta la flotta sfonda»: **quattro sedie su sei stanno sotto**, e due di quelle con i
  numeri misurati al banco giusto.
- 🟢 **La diversificazione FUNZIONA**: 19,28% di somma diventano 5,19% combinati. Il problema
  **non** è che le sedie si sommano: è la **taglia**.
- 🔎 **E un errore di citazione trovato prima che si propagasse**: la riga del muro del 10% non
  sta in `PIANO_CHALLENGE_OTTOBRE_v2.md` r.268 (§3d). Adesso la fonte è quella giusta.

---

## 📌 LA RIGA DA TENERE SOTTO MANO

> **Soglia di revisione IMMEDIATA (criterio del 18/08), DD forward contro DD promesso @2,00%:**
> `771531` **15,66%** · `770101` **14,14%** · `770202` **8,79%** *(IS 11,35%)* ·
> `770511` **7,82%** *(il più stretto della banda)* · `770260` **7,86%** · `770411` **3,84%**
> · 🧱 **PORTAFOGLIO 13,91%**, con **−6,87%** come peggior giornata già accaduta contro un muro
> giornaliero del **5%**.
>
> 🔴 **E la cosa che questo documento aggiunge al criterio del 18/08**: qui non è il forward che
> supera il promesso. **È il PROMESSO che supera il tetto della challenge** — su due sedie e sul
> portafoglio. È un caso che il criterio firmato non copre, e **si poteva sapere prima di
> schierare**.

---

*Misura prodotta in sola lettura il 24/09/2026. I sedici valori di `Equity DD %`, `Recovery
Factor`, `Profit Factor`, `Trades`, `Profit` e `InpRiskPercent` della tavola sono stati letti da
me **al CSV sorgente**, non ripresi dai referti; i tre diff preset↔cella sono stati calcolati
input per input; le catene `DD fisso ≥ Equity DD` sono state verificate su tutte e sedici le
celle. Dove un numero viene da un referto e non da un file (i due valori di R239), è scritto.
Nessun parametro, nessun preset, nessuna sedia, nessun terminale è stato toccato.*
