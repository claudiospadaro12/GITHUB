# 🔢 I QUARANTOTTO — stato di lettura dei 48 round in `dal_vps/`

**18/09/2026** · perimetro **SOLA LETTURA** · nessun backtest lanciato, nessun EA
toccato, `coda/CODA.txt` non aperto in scrittura, conto reale **10105439** non
nominato in nessuna riga operativa.

---

## 🥇 LA RISPOSTA IN UNA RIGA

> ### 🟢 **48 round su 48 sono GIUDICATI, con i numeri dei loro CSV, e lo sono dal 13/09.** Il verdetto di ognuno sta in `report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` (righe 105-153), commit `7aaa9526` del **13/09 23:32 +0200** — cioè **25 minuti dopo** che i CSV erano stati committati (23:05-23:07 +0200). 🔴 **Ma nessuno dei 48 ha una riga di risultato in `REGISTRO_TEST.md`: 36 tag su 48 non ci compaiono affatto, e i 12 che ci sono, ci sono come «file prova pronto» o «misura proposta».**

🔴 **E questo capovolge la premessa di stamattina.** Il referto
`report/AUDJPY_E_GBPUSD_IL_NUMERO_CHE_MANCAVA_2026-09-18.md` scrive *«i quattro CSV
sono nel repo dal 13/09... Letti oggi, 18/09. Cinque giorni»*. **Falso per R139a/R139b**:
erano stati letti il 13/09 alle 23:32, con PF, DD e n presi da quei CSV, e con un
verdetto (`FAIL S3 (rischio)` per R139a, `FAIL S3 + S4` per R139b) che **coincide con
la conclusione di oggi**. Quel referto non cita `LETTURA_BACKLOG_NOTTE_2026-09-13.md`
da nessuna parte (verificato: zero occorrenze della stringa nel file).

> ✏️ **AGGIORNAMENTO, poche ore dopo — e va scritto perché è la parte che funziona.**
> Il paragrafo qui sopra descrive il referto AUDJPY **com'era quando l'ho letto**.
> È stato **corretto alla fonte** nel commit `96548df3` del 18/09 06:26: adesso
> quel referto apre con *«Non è vero»*, cita `LETTURA_BACKLOG_NOTTE_2026-09-13.md`
> (r.6 e r.45) e si prende la classe 411 che aveva denunciato nella stessa riga.
> 🟢 **Il difetto è stato verificato alla fonte da chi l'aveva commesso e riparato
> prima di arrivare a Claudio** — che è esattamente il protocollo Sviluppatore /
> Agente dei Controlli del 13/09. **Lascio il paragrafo com'era**: cancellarlo
> nasconderebbe la misura che ha fatto scattare la correzione.

**Che cosa mancava davvero**, e vale per tutti e 48: **la riga nel registro**. Chi cerca
in `REGISTRO_TEST.md` — che è dove si cerca — trova *«file prova pronto, cancello
deterministico passato»* e conclude che il numero non esiste. **Il numero esiste, in un
referto che il registro non linka.** È la classe 415 vista dall'altra parte: non «la
frase c'è ma parla d'altro», ma **«il verdetto c'è e il registro non lo sa»**.

🟢 **La cosa andata bene, e va detta:** la lettura del 13/09 è un lavoro serio — 49
coppie, numeri al quinto decimale, cancelli applicati, un canarino di riproduzione
(`r127c`) messo davanti a tutto e sette buchi dichiarati in fondo. **Non è stata una
misura persa: è stata una misura non indicizzata.**

---

## 🔬 COME L'HO VERIFICATO (e il contro-esempio che mi sono costruito contro)

Il test debole — «il tag compare da qualche parte» — è quello che ha ingannato
stamattina. Il test che ho usato è **numerico e automatico**:

1. dai 98 CSV ho estratto **390 righe di cella** — che sono **329 celle distinte**,
   perché la cella di riferimento è ripetuta apposta in più passate — con PF,
   Equity DD %, Trades, Profit, `Pass` e la colonna `Inp*` che varia dentro il round;
2. per ogni round ho preso **i numeri della sua riga nella tabella dei verdetti** e
   ho chiesto a un confronto esatto se stessero **in quel CSV** — non «in un CSV»;
3. **contro-esempio costruito apposta**: i quattro round `r136a/b/c/d` più `cemad05`
   citano tutti la **stessa** cella S1 (`1,20110 / 1,52365 · 5,73 / 7,83 · 237 / 517`).
   Se il test fosse «il numero esiste nel corpus», passerebbero **anche se la riga
   parlasse di un altro round**. Ho verificato che quella cella è **fisicamente presente
   in tutti e cinque i CSV** (r136a IS riga 2, r136b IS riga 2, r136c IS riga 1,
   r136d IS riga 1, cemad05 IS riga 1) **e** che per tutti e cinque **ogni singola
   cella del loro asse** (`InpSLatr`, `InpTP1_ATRmult`, `InpTP1Pct`, `InpUseTrailing`,
   `InpTF`) è scritta con il suo PF in
   `backtest_pipeline/risultati_archivio/R136_R137_LA_NOTTE_CHE_I_CSV_SONO_ARRIVATI_2026-09-13.md`
   §2.1-2.5: **zero celle mute su cinque round**. Il contro-esempio non rompe il
   verdetto.
4. **residuo del confronto**: sulle 49 righe, i soli numeri non rintracciati nel CSV del
   round sono TF, soglie e conteggi di posizioni (`200`, `30`, `150`, `1,10`, `14,0`,
   `193`, `132`...) — cioè costanti di cancello, non misure. **Una sola eccezione, ed è
   un difetto vero**: la riga `r139a` (r.116) scrive `n OOS 1292-1345`, ma il minimo
   vero di quel CSV è **1322**; **1292 è il minimo di `r139b`**. Contaminazione fra due
   righe adiacenti, non cambia il verdetto (rifiuto per rischio), **ma va corretta**.

---

## 1. 📋 LA TABELLA DEI 48 — stato e riga che lo prova

Legenda: **🟢 GIUDICATO** = esiste un verdetto che riporta numeri presi da quei CSV ·
**🟠 NOMINATO MA NON GIUDICATO** · **🔴 NUMERI MAI LETTI**.
`n` = colonna `Trades` = **deal di uscita**, non posizioni. Il rapporto deal/posizione
è misurato solo su `EMA200` U30USD (**1,7955** in IS, **2,0117** in OOS) e su
`EMA200` forex H4 (**1,8425** AUDJPY / **1,8329** GBPUSD): **altrove scrivo i deal e
basta.**

|#|round|riga che lo prova|PF IS/OOS citati|DD% IS/OOS citati|n IS/OOS citati|verdetto (testuale)|stato|
|--:|---|---|---|---|---|---|:-:|
|1|**r136a**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.105|1,20110 / 1,52365|5,73 / 7,83|237 / 517|✅ **PASS** — S1 riproduce; altopiano di **6 celle** (SLatr 0,6-1,6); **"il default va bene"**|🟢|
|2|**r136b**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.106|1,20110 / 1,52365|5,73 / 7,83|237 / 517|✅ **PASS** — S1 ✓; altopiano 0,25-0,75, **centro 0,50 NON batte il default**|🟢|
|3|**r136c**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.107|1,20110 / 1,52365|5,73 / 7,83|237 / 517|✅ **PASS** — S1 ✓; altopiano 25-50-75 **col centro = cella viva**; la cella NUDA è peggiore|🟢|
|4|**r136d**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.108|1,20110 / 1,52365|5,73 / 7,83|237 / 517|⏸️ **NON MISURABILE** — S1 ✓ ma **il segno si inverte fra IS e OOS** (criterio 1 del file)|🟢|
|5|**cemad02**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.109|— / 1,20110|— / 5,73|vuoto / 237|✅ **PASS** — riproduce l'IS di R112; **132 posizioni MISURATE**; codice 2 = falso allarme|🟢|
|6|**cemad05**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.110|1,20110 / 1,52365|5,73 / 7,83|237 / 517|✅ **PASS** — G0-B ✓; **requisito 5 (TF) CHIUSO**: H1 confermato, M15/M20/M30 bocciati|🟢|
|7|**r137a**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.111|1,12634 / 1,39709|5,44 / 7,23|175 / 270 (**193 pos**)|❌ **A1 FALLITO** — 1 sola cella a-costo passa; **prezzo di R5 misurato** (vedi §3)|🟢|
|8|**r137b**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.112|1,12634 / 1,39709|5,44 / 7,23|175 / 270|❌ **FAIL** — ramo SKIP: campione a **24 posizioni** e PF **in calo monotono**|🟢|
|9|**r137c**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.113|1,18323 / **1,49140**|4,96 / **6,27**|132 / **193 pos**|✅ **PASS** — riproduzione 8/8 → **è una FIRMA**|🟢|
|10|**r138a**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.114|1,44028 / **0,76965**|7,36 / **11,82**|130 / 195 (**152 pos**)|❌ **FAIL F3 (rischio)** — DD OOS 11,82% > 10,0%; merito negativo su campione leggibile|🟢|
|11|**q770be**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.115|1,18323 / 1,49140|4,96 / 6,27|132 / 193|❌ **FAIL soglia** — peggior giornata **invariata** (-1,0793% su 4 celle su 4)|🟢|
|12|**r139a**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.116|0,80 / 0,95-1,01|**15,4-16,9 / 16,9-20,4**|757-768 / 1292-1345|❌ **FAIL S3 (rischio)** — DD > 14,0% su **tutte** le celle, in **entrambe** le finestre|🟢|
|13|**r139b**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.117|0,80-0,84 / 1,13|**17,7-20,3** / 10,1-11,0|856-875 / 1292-1321 (**718 pos**)|❌ **FAIL S3 + S4** — DD IS > 14,0%; **segno opposto su 4 celle su 4 = REGIME, non edge**|🟢|
|14|**r139c**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.118|0,79-0,83 / 0,94-0,97|**20,7-23,3 / 17,2-17,7**|548-572 / 725-737 (**643 pos**)|❌ **FAIL F1 (rischio)** — DD > 14,0% ovunque; PF < 1,00 in entrambe|🟢|
|15|**r141a**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.119|**0,60887** / 1,24334|7,76 / 3,03|**146** / 261|⏸️ **NON GIUDICABILE** — IS a **4 operazioni** dal pavimento; segno nettamente discorde|🟢|
|16|**r141b**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.120|**0,59938** / 1,03501|6,42 / 4,41|**146** / 261|⏸️ **NON GIUDICABILE** — stesso schema del gemello, **identico nei conteggi**|🟢|
|17|**r141c**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.121|0,97227 / 1,22915 (cella ATR)|5,69 / 4,14|70 / 96|❌ cella PERC **scartata** (C0 + DD 19,25%) · ⏸️ cella ATR non giudicabile (n<150)|🟢|
|18|**r141d**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.122|1,38464 / 1,92073 (k=1,0)|3,42 / 2,06|22 / 31|⏸️ **NON GIUDICABILE sul merito** — ma **PASSO 0 RIUSCITO**: il motore opera (vedi §4)|🟢|
|19|**r142a**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.123|1,01472 / 0,95624|12,3 / 22,5 @2%|**116 / 175** (riproduce)|❌ **merito: scarta** (tutte < 1,10 con n≥150) · ✅ **voce 3 del certificato CHIUSA**|🟢|
|20|**r142b**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.124|1,01472 / 0,95624|12,3 / 22,5 @2%|116 / 175 (riproduce)|❌ **merito: scarta** — l'asse morde (+0,11 PF) ma **nessuna cella arriva a 1,10**|🟢|
|21|**r142c**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.125|1,01472 / 0,95624|12,3 / 22,5 @2%|116 / 175 (riproduce)|❌ **merito: scarta** — senza trailing il DD OOS sale a **33,62%** @2%|🟢|
|22|**r127c**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.126|1,17686 / 1,52341|11,0 / 12,3|153 / 242 = **395**|✅ **PASS — IL CANARINO DELLA NOTTE** (vedi §1)|🟢|
|23|**r127b**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.127|0,85447 / 1,12525|6,58 / 5,91|230 / 427 = **657**|⏸️ ancora **n 657 esatta** ✅ · merito non giudicabile (OHLC + PF IS < 1,00 su 7/7)|🟢|
|24|**r126a**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.128|**1,48166** / 1,24312|4,04 / 4,17|72 / 131|❌ **ANCORA GRADO C** — PF IS **1,48166 contro 1,84892** (Δ 0,367 > ±0,15) → **round fermo**|🟢|
|25|**r126b**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.129|1,48166 / 1,24312 (lookback 5)|4,04 / 4,17|72 / 131|⏸️ **non leggibile** (stesso gruppo) — **ma conferma il determinismo interno**|🟢|
|26|**r126d**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.130|0,71-1,13 / **0,73-0,84**|1,72 / 2,7-3,2|35-38 / **58-63**|❌ **FAIL G3+G4** — PF OOS < 1,10 su **9 celle su 9**; n OOS < 95 (pavimento)|🟢|
|27|**r132c**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.131|0,98846 / 1,38900 (NearAtr 1,0)|6,17 / 5,91|117 / 152|❌ **ROUND NULLO** — la riproduzione fallisce su **3 celle su 5** (vedi §5)|🟢|
|28|**r120b11**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.132|1,48166 / **1,24312**|4,04 / 4,17|72 / 131|❌ **G1 metro FALLITO** — PF OOS fuori dalla forbice **1,30-1,55** → le altre 3 celle non si leggono|🟢|
|29|**r120b00**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.133|0,90317 / 1,18671|6,04 / 6,23|46 / 90|❌ non leggibile (G1 del gruppo)|🟢|
|30|**r120b01**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.134|1,40616 / 0,98333|4,45 / 5,11|71 / 125|❌ non leggibile (G1 del gruppo)|🟢|
|31|**r120b10**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.135|1,48914 / 1,24312|3,80 / 4,17|72 / 131|❌ non leggibile (G1 del gruppo)|🟢|
|32|**r120e11**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.136|1,39744 / 1,22034|3,48 / 4,21|**106 / 184**|⏸️ metro del banco — **ha misurato la cosa che spiega tutto** (§5)|🟢|
|33|**r120e00**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.137|0,97751 / 1,28437|5,07 / 6,53|74 / 130|⏸️ metro del banco|🟢|
|34|**r133b**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.138|1,24979 / 1,67419 (cella 0)|7,89 / 9,76|71 / 119|❌ cella 1 **scartata per rischio** (DD IS **27,21%** > 12,0%) · merito non leggibile (n<150)|🟢|
|35|**r133c**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.139|1,99749 / 1,01569 (box 0)|4,89 / 9,05|38 / 65|⏸️ **NON GIUDICABILE, dichiarato prima** — consegnata la curva Trades(soglia)|🟢|
|36|**P0_IBRETEST**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.140|0,38242 / 0,69663|7,38 / 7,61|42 / 53|⏸️ archivio — frequenza **0,21 op/g** in banda; merito sospeso; segno negativo concorde|🟢|
|37|**P0IBRTDAX**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.141|1,21062 / 0,96493|2,80 / 5,25|58 / 107|⏸️ archivio — merito sospeso (n<150)|🟢|
|38|**P0IBRTNAS**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.142|0,56297 / 0,59292|5,80 / 5,31|35 / 49|⏸️ archivio — merito sospeso; segno negativo concorde|🟢|
|39|**P0CONTA (LVN)**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.143|0,97856 / 1,05108|**18,01** / 11,33|392 / 618|❌ archivio — **C0 (PF<1,10 con n≥150) + rischio** (DD > 10%)|🟢|
|40|**P0_100K (LVN)**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.144|0,97485 / 1,05227|**19,35** / 11,76|392 / 618|❌ archivio — idem, confermato alla taglia 100k|🟢|
|41|**P0CONTA (ORB-B)**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.145|1,82619 / —|0,96 / 0,00|**2 / 0**|❌ archivio — **bocciato per frequenza**|🟢|
|42|**P0A_FAIL**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.146|1,82619 / —|0,96 / 0,00|2 / 0|❌ archivio — contatori: State1 24-29, State2 16-19, **Entry 2**|🟢|
|43|**P0B_SIGNAL**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.147|0,00-1,83 / —|≤0,96 / 0,00|1-2 / 0|❌ archivio — State1 fino a **49**, ingressi **1-2**|🟢|
|44|**P0C_FT**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.148|1,75-3,56 / —|≤0,96 / 0,00|2-3 / 0|❌ archivio — il PF 3,56 è su **3 operazioni**: numero senza campione|🟢|
|45|**P0_EURCHF**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.149|0,89113 / 0,81429|**11,10 / 15,39**|63 / 85|❌ archivio — **BOCCIATO PER RISCHIO** (soglia congelata: DD > 10% su una cella)|🟢|
|46|**R123AGATE**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.150|0,98837 / 1,38944|6,17 / 5,91|117 / 152|📦 **ancora d'archivio** (09/09) — termine di paragone di r132c|🟢|
|47|**R123BSTMULT**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.151|0,88-2,02 / 0,91-1,42|2,9-8,9 / 3,6-12,4|97-180 / 112-261|📦 ancora d'archivio|🟢|
|48|**R123CATRP**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.152|0,56-1,18 / 0,56-1,39|4,9-9,1 / 2,8-9,2|104-136 / 108-202|📦 ancora d'archivio|🟢|
|49|**R123DNEARATR**|`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.153|0,63-1,00 / 0,99-1,39|4,6-7,2 / 5,9-6,4|64-128 / 122-172|📦 **ancora d'archivio — è quella che r132c non riproduce**|🟢|

**🔴 Conteggio: 48 tag su 48 🟢 · 0 🟠 · 0 🔴.** Le righe sono **49** e non 48 perché
il tag `P0CONTA` copre **due EA diverse** (`ABTG_LVNArbitro` e `ABTG_OpeningReversalB`),
con quattro CSV distinti: 98 file = **49 coppie IS/OOS** su **48 etichette**. E lo scrivo come un fatto scomodo, non come
una vittoria: *il compito chiedeva di trovare i non giudicati, e non ce ne sono*. La
lacuna è altrove, ed è la seconda colonna che questo referto aggiunge.

### 1-bis · 🔴 LA SECONDA COLONNA: `REGISTRO_TEST.md`

| | quanti | quali |
|---|--:|---|
| tag con **zero** occorrenze in `REGISTRO_TEST.md` | **36** | tutti i `P0*` tranne `P0_IBRETEST`, tutti gli `R123*`, `cemad02`, `cemad05`, `q770be`, i sei `r120*`, `r126a/b/d`, `r127b`, `r127c`, `r132c`, `r133b`, `r133c`, `r136a/b/c/d`, `r142a/b/c` |
| tag presenti, ma **solo** come file prova / misura proposta | **12** | `P0_IBRETEST` (r.1947-1948, rimanda a due referti) · `r137a/b/c` (r.2499-2501, *«round proposti»*) · `r138a` (r.2464-2474, *«ritest di un caduto»*) · `r139a/b` (r.2617-2618, *«file prova pronti»*) · `r139c` (r.2614, *«NON ANCORA MISURATO»*) · `r141a/b/c/d` (r.3013-3016, tabella dei round proposti) |
| tag con una **riga di risultato** (PF/DD/n) nel registro | **0** | — |

👉 **Il lavoro che manca non è una misura: è un indice.** 48 verdetti vivono in due
referti; il file che il progetto interroga per sapere «è già stato misurato?» non li
conosce.

---

## 2. 🏁 LA CLASSIFICA PER POTENZIALE — i cancelli di casa applicati a tutte e 329 le celle distinte

Nessun round è 🟠 o 🔴, quindi la classifica che serve è l'altra: **quali meritano di
essere riletti a fondo**, misurati con i quattro cancelli chiesti. Per ogni round è
mostrata **la cella che ne passa di più** (a parità, quella col minimo PF più alto).

Cancelli, nell'ordine delle spunte: **campione** (n ≥ 300 deal in ENTRAMBE) ·
**merito** (PF ≥ 1,10 in ENTRAMBE) · **rischio** (DD ≤ 14,0% **riscalato a rischio
1,0%** dalla colonna `InpRiskPercent` del CSV) · **coerenza dei segni** IS/OOS.

> 🔴 **Il risultato in una riga: ZERO round su 48 passa 4/4, e il cancello che blocca è
> sempre lo stesso — il CAMPIONE.** 19 round arrivano a 3/4 e falliscono solo lì.
> I sei che il campione lo passano si dividono così, elencati per nome: i **tre forex
> a 16,5 anni** (`r139a` 768/1345 deal, `r139b` 875/1321, `r139c` 557/737) cadono sul
> **rischio** (DD@1% 15,35-20,70% sulle celle migliori qui in tabella, fino a 23,33% su altre celle) e sul **merito**; i **due
> indici** (`P0CONTA (LVN)` e `P0_100K`, 392/618 deal) cadono su **merito e rischio**
> (PF 0,975-1,052, DD@1% fino a **29,77%**); e `cemad05` lo passa solo con le celle a
> **TF basso** (M15/M20/M30), che fanno PF 0,771-1,117 e DD@1% 9,13-30,71%.
> 🔴 **Non è una coincidenza: è il ritratto della flotta.** Su 21 mesi di storico
> indici, 300 deal per finestra non ci stanno; chi ci arriva ci arriva col forex lungo
> o abbassando il TF, e in tutti e sei i casi paga in DD.

|round|EA / simbolo|asse|celle|cella migliore|PF IS/OOS|DD@1% IS/OOS|n IS/OOS (deal)|cancelli|
|---|---|---|--:|---|---|---|---|--:|
|`cemad05`|ABTG_EMA200 / U30USD|`InpTF`|7|`16388` (Pass 6)|1,660 / 1,425|2,37 / 4,45|26 / 116|3/4 ❌✅✅✅|
|`R123BSTMULT`|ABTG_SupRev_DOW_H1_Ottimizzato / U30USD|`InpStMult`|5|`4,5` (Pass 4)|2,017 / 1,418|3,75 / 5,70|97 / 117|3/4 ❌✅✅✅|
|`r126a`|ABTG_SuperWave_DOW_H1_Ottimizzato / U30USD|`InpSLBufferAtr`|9|`0,500` (Pass 4)|1,738 / 1,402|3,26 / 4,03|68 / 124|3/4 ❌✅✅✅|
|`r141d`|ABTG_HVAncora / U30USD|`InpStopAtr`|4|`1,0` (Pass 0)|1,385 / 1,921|5,27 / 3,17|22 / 31|3/4 ❌✅✅✅|
|`r137a`|ABTG_DAX_Apertura_EU / D30EUR|`InpMinStopPts`|7|`4800` (Pass 2)|1,317 / 1,496|4,73 / 7,25|178 / 272|3/4 ❌✅✅✅|
|`r126b`|ABTG_SuperWave_DOW_H1_Ottimizzato / U30USD|`InpSLLookback`|7|`9` (Pass 4)|1,591 / 1,305|3,44 / 3,55|68 / 124|3/4 ❌✅✅✅|
|`r136a`|ABTG_EMA200 / U30USD|`InpSLatr`|7|`1,2` (Pass 4)|1,255 / 1,462|4,73 / 5,97|247 / 519|3/4 ❌✅✅✅|
|`r133b`|ABTG_ORB_Ottimizzato / U30USD|`InpUseCloseConfirm`|2|`0` (Pass 0)|1,250 / 1,674|7,89 / 9,76|71 / 119|3/4 ❌✅✅✅|
|`r120b10`|ABTG_SuperWave_DOW_H1_Ottimizzato / U30USD|`InpMagic`|2|`783220` (Pass 0)|1,489 / 1,243|3,80 / 4,17|72 / 131|3/4 ❌✅✅✅|
|`r120b11`|ABTG_SuperWave_DOW_H1_Ottimizzato / U30USD|`InpMagic`|2|`783200` (Pass 0)|1,482 / 1,243|4,04 / 4,17|72 / 131|3/4 ❌✅✅✅|
|`r120e11`|ABTG_SuperWave_DOW_H1_Ottimizzato / U30USD|`InpMagic`|2|`783501` (Pass 1)|1,397 / 1,220|3,48 / 4,21|106 / 184|3/4 ❌✅✅✅|
|`r127c`|ABTG_CostToCost / EURJPY|`InpMaxBarsHold`|8|`25` (Pass 0)|1,220 / 1,452|12,17 / 12,25|161 / 257|3/4 ❌✅✅✅|
|`r136b`|ABTG_EMA200 / U30USD|`InpTP1_ATRmult`|7|`0,00` (Pass 0)|1,201 / 1,524|5,73 / 7,83|237 / 517|3/4 ❌✅✅✅|
|`r136c`|ABTG_EMA200 / U30USD|`InpTP1Pct`|4|`50` (Pass 2)|1,201 / 1,524|5,73 / 7,83|237 / 517|3/4 ❌✅✅✅|
|`r136d`|ABTG_EMA200 / U30USD|`InpUseTrailing`|2|`1` (Pass 1)|1,201 / 1,524|5,73 / 7,83|237 / 517|3/4 ❌✅✅✅|
|`r137b`|ABTG_DAX_Apertura_EU / D30EUR|`InpMinStopPts`|7|`2800` (Pass 1)|1,198 / 1,294|4,50 / 7,20|162 / 264|3/4 ❌✅✅✅|
|`q770be`|ABTG_DAX_Apertura_EU / D30EUR|`InpBEatR`|4|`0,0` (Pass 0)|1,183 / 1,491|4,96 / 6,27|132 / 193|3/4 ❌✅✅✅|
|`r137c`|ABTG_DAX_Apertura_EU / D30EUR|`InpTP1_ClosePct`|2|`0` (Pass 0)|1,183 / 1,491|4,96 / 6,27|132 / 193|3/4 ❌✅✅✅|
|`R123CATRP`|ABTG_SupRev_DOW_H1_Ottimizzato / U30USD|`InpStAtrPeriod`|7|`12` (Pass 6)|1,177 / 1,359|4,93 / 2,84|106 / 133|3/4 ❌✅✅✅|
|`r142b`|ABTG_Nasdaq_Live5m / NASUSD|`InpTrailTF`|5|`2` (Pass 1)|1,238 / 1,070|7,73 / 8,81|124 / 185|2/4 ❌❌✅✅|
|`r133c`|ABTG_MaxMinNotte / D30EUR|`InpMinBoxPts`|9|`4500` (Pass 3)|2,236 / 1,062|3,92 / 8,21|37 / 59|2/4 ❌❌✅✅|
|`R123DNEARATR`|ABTG_SupRev_DOW_H1_Ottimizzato / U30USD|`InpNearAtr`|5|`1,25` (Pass 3)|1,005 / 1,322|5,95 / 6,40|122 / 172|2/4 ❌❌✅✅|
|`r132c`|ABTG_SupRev_DOW_H1_Ottimizzato / U30USD|`InpNearAtr`|8|`1,25` (Pass 4)|1,005 / 1,322|5,95 / 6,40|122 / 172|2/4 ❌❌✅✅|
|`r142a`|ABTG_Nasdaq_Live5m / NASUSD|`InpTP1_ClosePct`|4|`75` (Pass 3)|0,988 / 0,945|6,12 / 10,76|116 / 175|2/4 ❌❌✅✅|
|`r139c`|ABTG_FiboH4_Multi / GBPUSD|`InpEngulfLookback`|3|`16` (Pass 2)|0,831 / 0,950|20,70 / 17,21|557 / 737|2/4 ✅❌❌✅|
|`r126d`|ABTG_SuperWave / NASUSD|`InpSLBufferAtr`|9|`0,750` (Pass 6)|0,863 / 0,809|1,73 / 2,80|35 / 58|2/4 ❌❌✅✅|
|`r139a`|ABTG_EMA200 / AUDJPY|`InpTP_RR`|4|`3,0` (Pass 3)|0,807 / 0,956|15,35 / 20,00|768 / 1345|2/4 ✅❌❌✅|
|`P0IBRTNAS`|ABTG_IBRetest / NASUSD|`InpMagic`|2|`772950` (Pass 1)|0,563 / 0,593|8,92 / 8,17|35 / 49|2/4 ❌❌✅✅|
|`P0_IBRETEST`|ABTG_IBRetest / U30USD|`InpMagic`|2|`772900` (Pass 0)|0,382 / 0,697|11,36 / 11,71|42 / 53|2/4 ❌❌✅✅|
|`P0B_SIGNAL`|ABTG_OpeningReversalB / U30USD|`InpSignalScoreMin`|3|`2` (Pass 0)|0,000 / 0,000|0,06 / 0,00|1 / 0|2/4 ❌❌✅✅|
|`R123AGATE`|ABTG_SupRev_DOW_H1_Ottimizzato / U30USD|`InpMagic`|2|`784100` (Pass 0)|0,988 / 1,389|6,17 / 5,91|117 / 152|1/4 ❌❌✅❌|
|`r120b01`|ABTG_SuperWave_DOW_H1_Ottimizzato / U30USD|`InpMagic`|2|`783210` (Pass 0)|1,406 / 0,983|4,45 / 5,11|71 / 125|1/4 ❌❌✅❌|
|`P0CONTA (LVN)`|ABTG_LVNArbitro / U30USD|`InpMagic`|2|`769900` (Pass 0)|0,979 / 1,051|27,71 / 17,43|392 / 618|1/4 ✅❌❌❌|
|`r120e00`|ABTG_SuperWave_DOW_H1_Ottimizzato / U30USD|`InpMagic`|2|`783510` (Pass 0)|0,978 / 1,284|5,07 / 6,53|74 / 130|1/4 ❌❌✅❌|
|`P0_100K`|ABTG_LVNArbitro / U30USD|`InpMagic`|2|`769950` (Pass 1)|0,975 / 1,052|29,77 / 18,10|392 / 618|1/4 ✅❌❌❌|
|`r141c`|ABTG_AtrExhaustVol / NASUSD|`InpProxMode`|2|`1` (Pass 1)|0,972 / 1,229|8,75 / 6,37|70 / 96|1/4 ❌❌✅❌|
|`P0IBRTDAX`|ABTG_IBRetest / D30EUR|`InpMagic`|2|`772950` (Pass 1)|1,211 / 0,965|4,31 / 8,08|58 / 107|1/4 ❌❌✅❌|
|`r142c`|ABTG_Nasdaq_Live5m / NASUSD|`InpUseTrailing`|2|`1` (Pass 1)|1,015 / 0,956|6,14 / 11,24|116 / 175|1/4 ❌❌✅❌|
|`r120b00`|ABTG_SuperWave_DOW_H1_Ottimizzato / U30USD|`InpMagic`|2|`783230` (Pass 0)|0,903 / 1,187|6,04 / 6,23|46 / 90|1/4 ❌❌✅❌|
|`r127b`|ABTG_SupertrendReversal_Ottimizzato / XAUUSD|`InpSLLookback`|7|`7` (Pass 3)|0,855 / 1,125|6,57 / 6,18|230 / 427|1/4 ❌❌✅❌|
|`r139b`|ABTG_EMA200 / GBPUSD|`InpTP_RR`|4|`3,0` (Pass 3)|0,838 / 1,139|17,73 / 10,81|875 / 1321|1/4 ✅❌❌❌|
|`P0_EURCHF`|ABTG_Nightly / EURCHF|`InpMagic`|2|`771701` (Pass 0)|0,891 / 0,814|11,10 / 15,39|63 / 85|1/4 ❌❌❌✅|
|`r138a`|ABTG_DAX_Apertura_EU / F40EUR|`InpMagic`|2|`786205` (Pass 1)|1,440 / 0,770|7,36 / 11,82|130 / 195|1/4 ❌❌✅❌|
|`r141a`|ABTG_IntradayMomentum / NASUSD|`InpUseSecondSignal`|2|`0` (Pass 0)|0,609 / 1,243|11,94 / 4,66|146 / 261|1/4 ❌❌✅❌|
|`r141b`|ABTG_IntradayMomentum / U30USD|`InpUseSecondSignal`|2|`0` (Pass 0)|0,599 / 1,035|9,87 / 6,79|146 / 261|1/4 ❌❌✅❌|
|`P0A_FAIL`|ABTG_OpeningReversalB / U30USD|`InpFailScoreMin`|3|`2` (Pass 1)|1,826 / 0,000|1,48 / 0,00|2 / 0|1/4 ❌❌✅❌|
|`P0C_FT`|ABTG_OpeningReversalB / U30USD|`InpFollowThroughPct`|3|`40` (Pass 0)|1,753 / 0,000|1,43 / 0,00|2 / 0|1/4 ❌❌✅❌|
|`P0CONTA (ORB-B)`|ABTG_OpeningReversalB / U30USD|`InpMagic`|2|`769400` (Pass 0)|1,826 / 0,000|1,48 / 0,00|2 / 0|1/4 ❌❌✅❌|
|`cemad02`|ABTG_EMA200 / U30USD|InpMagic (gemelli)|—|**IS vuoto per costruzione** (`@FRAZIONEIS 0,002`)|— / 1,20110|— / 5,73|— / 237|n/d|

### 2-bis · 🔎 CHI VA RILETTO PER PRIMO, e perché (insieme elencato per nome)

L'insieme di cui parlo è: **i 19 round a 3/4**. Dentro quell'insieme, tre gruppi.

| priorità | round | perché lo rileggerei | grandezza accanto |
|---|---|---|---|
| 🥇 | **`r126a` + `r126b`** (SuperWave_DOW_H1_Ott, U30USD) | **Sono i due round con più celle mai scritte da nessuna parte: 14 e 10.** Il verdetto del 13/09 li ferma su un cancello di RIPRODUZIONE (`r126a` grado C: PF IS 1,48166 contro l'archivio 1,84892), non su un numero brutto — e intanto **9 celle su 9** (`r126a`) e **7 su 7** (`r126b`) passano merito+rischio+segno | PF OOS 1,135-1,402 (min = `r126b` Pass 5, max = `r126a` Pass 4) · DD@1% 3,15-4,58% · n OOS 115-139 deal |
| 🥈 | **`r133b`** (ORB_Ott, U30USD M30) | Asse a due celle, e la cella spenta (`InpUseCloseConfirm=0`) fa **PF OOS 1,674 con +41.057**. 🔴 Ma la cella **VIVA** in IS fa **PF 0,523 e DD 27,21%**: un fatto di rischio a qualunque n. Il file prova `R133b_filtrovolumi_U30USD.txt` **non è mai stato aperto** — lo dichiara il referto del 13/09 | PF 1,250 / 1,674 · DD@1% 7,89 / 9,76% · n 71 / 119 |
| 🥉 | **`r141d`** (HVAncora, U30USD M30) | **Passo 0 riuscito su un motore che era a zero CSV da 18 giorni**, e il tappo vero è **misurato e sta altrove**: 91 ancore IS e 165 OOS **scadono** senza convertirsi. Il prossimo round è lì, non sui parametri | PF 1,385 / 1,921 · DD@1% 5,27 / 3,17% · n 22 / 31 |
| 4 | **`R123BSTMULT`** / **`R123CATRP`** | Ancore d'archivio del 09/09, rilette il 13/09 **solo come termine di paragone di `r132c`**: il loro merito non è mai stato giudicato per sé. `R123BSTMULT` ha una cella a **PF 2,017 / 1,418** | DD@1% 3,75 / 5,70% · n 97 / 117 |
| 5 | **`r127c`** (CostToCost EURJPY H4) | È il **canarino** che ha validato tutta la notte, e il suo merito è 3/4 pieno. 🔴 Ma è **OHLC = screening, mai un verdetto**, e il DD è **12,17 / 12,25%**: a un soffio dal muro dei 14,0% e misurato su un modello che il DD lo **sottostima** | PF 1,220 / 1,452 · n 161 / 257 |

🚫 **E dichiaro chi NON metto in classifica, per nome**: `r136a/b/c/d`, `cemad02`,
`cemad05`, `r137c`, `r127c` hanno già un **PASS** del 13/09 e non hanno bisogno di
essere «riletti», ma di essere **registrati**; `r139a`, `r139b`, `r139c`, `r138a`,
`q770be`, `r126d`, `r142a/b/c`, `P0CONTA (LVN)`, `P0_100K`, `P0_EURCHF`, `r137a`,
`r137b` hanno un verdetto **chiuso con un numero** (rischio o merito). Nessuno di
questi è archiviato come morto da me: **non è il mio compito qui**, e per i `P0*`
di `OpeningReversalB` il referto del 13/09 è esplicito — *1-3 operazioni in IS e
ZERO in OOS non è un motore che perde, è NON MISURATO*.

---

## 3. 🕳️ LE 69 CELLE CHE NON SONO MAI FINITE IN UNA RIGA DI TESTO

Test: il PF della cella, scritto al **terzo o quinto decimale**, oppure il suo
**P/L al centesimo**, cercato in **tutti** i 2.095 file `.md`/`.txt` del repo (esclusi
`.git` e i worktree degli altri agenti) che **nominano quel tag**. Se non compare, il
numero di quella cella **non è mai stato scritto da nessuno**.

| round | celle distinte mai citate | su quante celle distinte | dove fa più male |
|---|--:|--:|---|
| `r126a` | **14** | 18 | l'intero altopiano `InpSLBufferAtr`: solo la cella b=0 è stata scritta |
| `r126d` | **13** | 17 | tutte tranne le due estreme citate nel confronto |
| `r126b` | **10** | 14 | l'asse `InpSLLookback` quasi per intero |
| `r127b` | **9** | 14 | 4 celle OOS mai scritte su n=427, **tre delle quali sopra PF 1,10**: `1,11209` · `1,11177` · `1,10059` (la quarta è `1,07529`) |
| `r133c` | **9** | 15 | le celle IS ad alto PF su campione ridicolo (PF 9,41 su **13 deal**) |
| `r132c` | **4** | 13 | le due celle OOS a `n=176` (PF 1,24520) |
| `r139c` | **4** | 6 | due celle IS e due OOS dell'asse `InpEngulfLookback` |
| `r137b` | **3** | 14 | le tre celle di coda (n IS 15-43) |
| `R123CATRP` · `r127c` · `r141b` | 1 ciascuno | — | — |

🟡 **Come si legge questo numero, onestamente**: 69 celle su 329 **non** vuol dire «69
misure perse». In `r126d` e `r133c` le celle mute sono celle **brutte o minuscole**, e
non scriverle è ragionevole. In `r126a`, `r126b` e **`r127b`** no: lì la cella muta è
**buona**, e il round è fermo per un cancello di riproduzione o per il modello OHLC.
**Quelle sono le tre righe da cui ripartirei.**

---

## 4. 🕳️ BUCHI DICHIARATI — cosa NON ho potuto verificare, e perché

1. 🔴 **Non ho letto i 48 file prova.** I cancelli che applico in §2 sono **quelli di
   casa** (campione 300 deal / merito 1,10 / rischio 14,0% a 1,0% / coerenza dei segni),
   **non** i criteri congelati dentro ogni `prove/*.txt`. Il referto del 13/09 usa
   quelli veri. **Le due classifiche non sono la stessa cosa, e la mia non sostituisce
   la sua.**
2. 🔴 **Le posizioni sono [NON MISURATE] quasi ovunque.** La colonna `Trades` sono
   **deal di uscita**. Il rapporto è misurato solo per `EMA200` U30USD (1,7955 IS /
   2,0117 OOS) e `EMA200` forex H4 (1,8425 / 1,8329). Per tutti gli altri motori **ho
   scritto i deal e basta**, e il cancello «campione» va riletto sapendo che la soglia
   vera è **150 POSIZIONI**, non 300 deal: dove il rapporto fosse vicino a 1,0 il
   cancello sarebbe **più severo** di come l'ho applicato.
3. 🔴 **Il riscalamento del DD a rischio 1,0% è LINEARE, ed è un'approssimazione.**
   Tocca `r142a/b/c` (girati a `InpRiskPercent=2,0`) e tutti i round a 0,65%. Il DD non
   scala esattamente lineare con la taglia; per `r142*` la direzione però non cambia il
   verdetto (`r142c` resta a 33,62% grezzo, oltre ogni muro).
4. 🔴 **OHLC = screening.** `r127b`, `r127c`, `r139a`, `r139b`, `r139c` girano a Modello
   1: il DD è un **limite inferiore**, quindi i rifiuti **per rischio** reggono, ma le
   **promozioni** no. Nessuna delle celle mute di `r127b` è promuovibile da questo file.
5. 🔴 **Un solo regime.** Tutti i round su indici stanno su 2024.09.26 → 2026.06.30 =
   21 mesi di toro. La regola C dell'Emendamento della Finestra **non è soddisfatta da
   nessuno di questi numeri.**
6. 🟡 **`cemad02` non entra nella classifica**: il suo CSV IS è **vuoto per
   costruzione** (`@FRAZIONEIS 0.002`, dichiarato tre volte nel file prova) e non
   esiste una coppia IS/OOS da accoppiare. L'OOS riproduce l'IS di R112
   (`PF 1,20110 · DD 5,7325% · 237 deal · +4.585,40`).
7. 🟡 **Non ho verificato i 5 `REFERTO_ROUND_*.txt` dentro gli zip sul VPS** — quelli
   che chiuderebbero il codice di uscita 3 sugli `ohlc_*`. Perimetro di sola lettura del
   repo: quei file sul VPS non sono qui.
8. 🟡 **Ho escluso dal corpus `.claude/worktrees/`** (copie di lavoro di altri agenti in
   parallelo): il corpus cercato è **2.095 file** `.md`/`.txt`. Se un verdetto vivesse
   **solo** nel worktree di un altro agente e non ancora su `lavoro`, non l'avrei visto.

---

## 5. 🎯 IN UNA RIGA, PER LA BUSSOLA DEL 1° OTTOBRE

**Zero misure nuove da questo file, e lo dichiaro: è ponteggio.** Ma il ponteggio ha
trovato una cosa che costa: **48 verdetti esistono e il registro non li conosce**, e
quella lacuna ha già fatto rifare oggi un lavoro del 13/09. 🟢 **La riparazione è
economica** — 48 righe di rimando in `REGISTRO_TEST.md` — e va fatta **prima** del
prossimo round, non dopo.

---

*18/09/2026 — audit di sola lettura. Nessun backtest lanciato, nessun EA toccato,
nessun preset cambiato, `coda/CODA.txt` non modificato, conto reale 10105439 non
coinvolto.*
