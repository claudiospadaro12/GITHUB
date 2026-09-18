# 🪑 LA ROSA DI OTTOBRE — **CHI PUÒ ESSERE IN CAMPO IL 1° OTTOBRE, E COSA MANCA A OGNUNA**

**Venerdì 18/09/2026. Mancano 13 giorni.** Scritto dall'**architetto-prop**.
**SOLA LETTURA**: nessun EA, preset, file prova, riga di coda, backtest o
terminale è stato toccato. Il conto reale `10105439` non è stato letto né
nominato come bersaglio. **Nessuna taglia e nessun parametro di rischio è
proposto qui: sono di Claudio.** Costo macchina di questo referto: **0**.

---

> # 🥇 LA RIGA DI TESTA
> ## 🔴 **Il 1° ottobre possiamo schierarne ZERO che passino tutti e cinque i requisiti del piano. UNA (`770202`) ne passa QUATTRO su cinque OGGI, senza nessuna firma e senza nessuna misura nuova — e il quinto (il pavimento di frequenza di FAMIGLIA) NON è raggiungibile da nessuna famiglia della rosa, perché ognuna ha UN SIMBOLO SOLO.**
> ## 🟠 **Con due firme che costano ZERO macchina — `770611` in OPPRANGE (scaduta il 15/09) e l'unità in cui si legge il pavimento (mai firmata) — si arriva a TRE a 4/5 e a UNA a 5/5 (`771531`), entro il 29/09.**
> ## 🔴 **E prima di tutte: il conto su cui girerebbero NON ESISTE. La firma #7 del piano (*quale prop, quale taglia*) scade il 29/09, ma la sua ultima data utile VERA è il 22-23/09 — e il conto già comprato il 15/09 (FundedNext Stellar Lite 100k) è, per i documenti in repo, il conto MANUALE di Claudio, non quello degli EA.**

---

# 0. 📣 PRIMA LE VITTORIE, perché fra il 12 e il 18/09 ne sono maturate quattro vere

| cosa si diceva | cosa è oggi | fonte |
|---|---|---|
| 🔴 *"`770202`: NESSUN PRESET SU FILE, lo 0,65 vive solo dentro un `.chr`"* — R4 rotto (`PIANO_CHALLENGE_OTTOBRE_v2.md` r.380) | 🟢 **CHIUSO**: `mql5/Presets/ABTG_Dow_Apertura_US_U30USD_M5_770202_100K.set` esiste dal **12/09** (commit `2ad44504`), **81 chiavi**, con `InpRiskPercent=0.65` e `InpMagic=770202` — letto da me riga per riga in questo giro | il `.set` stesso · `git log` |
| 🔴 *"`770202` R5 51,0× ma su stop `~102 idx [INFERITO]`"* | 🟢 **`[MISURATO]`**: stop **123,8 idx**, **61,9× alla mediana (+55%)** e **41,3× al p95 (+3%)** — **passa anche al p95**, cosa che prima non faceva | `ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` **r.411 e r.426** |
| 🔴 *"la peggior giornata VERA manca su 7 sedie su 8; eccezione `771531`"* (`PIANO_..._v2.md` §6 punto 4) | 🟢 **NON È PIÙ VERO, e sono DUE in più**: `770202` ha **Peggior Giornata OOS −1,0227%** e `770101` sta fra **−1,0086% e −1,1524% su TUTTE e 180 le celle** | misurato **da me** su `..._OOS_ptc.csv` (col. 9) · `TRE_ASSI_MAI_LETTI_2026-09-17.md` §🥈 |
| 🔴 *"il conflitto di DD di `771531` (6,48 / 7,21 / 7,83) blocca R2"* | 🟢 **ATTRIBUITO**: tre configurazioni diverse (OHLC vs tick · 10k vs 100k · finestra piena vs OOS) | `A3_IL_DD_DELLA_771531_2026-09-12.md` §1 |

🟢 **E la colonna (C) — «manca codice» — resta VUOTA su TUTTA la rosa.** Non
manca una riga di codice a nessuna delle otto. Lo dice il referto del 17/09
sulla sedia più avanti, e lo confermo qui allargando il perimetro alle altre
sette: quello che manca sono **misure, firme e gesti**, mai software.

---

# 1. 🪑 LA ROSA, PER NOME — le otto del piano + le due che il cancello nuovo ha rimesso in gioco

## 1.1 🧊 Le regole di lettura, congelate prima della tabella

- **«Schierabile»** = passa i **cinque requisiti** dichiarati in
  `PIANO_CHALLENGE_OTTOBRE_v2.md` §1 (**R1** cella promossa · **R2** DD
  dichiarato con deposito/rischio/modello · **R3** frequenza ≥ 1,00 op/g **per
  FAMIGLIA** · **R4** rischio vero = dichiarato · **R5** `stop ≥ 40 × pedaggio`).
- **Il cancello di costo usa i numeri NUOVI** (`ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md`).
  🔴 **E NON ci si aggiunge il «+18-27%»** del 12/09: quella sottostima è già
  dentro la correzione dell'ancora (regola in testa a quel referto).
- **Le quattro categorie di ciò che manca**: **(M)** misura · **(C)** codice ·
  **(F)** firma di Claudio · **(A)** azione manuale sul VPS.
- 🔴 **Classe 408**: `[MISURATO]` sta attaccato a **una riga di un file con un
  `n`**. Dove il numero è mio, lo dico. Dove è di un altro referto, cito **file
  e riga** e non me lo attribuisco.

## 1.2 📊 LA TABELLA MADRE

| # | sedia · magic · **dove gira oggi** | sym · TF | **PF / n / DD** + fonte | **R5 costo (numeri NUOVI)** | **frequenza · famiglia** | 🔴 **cosa manca** |
|---:|---|---|---|---|---|---|
| **1** | `Dow_Apertura_US` **`770202`** · 🟢 **100k `50504263` @0,65% + Guardian `779001` vivo sullo stesso terminale** | U30USD M5 | **OOS PF 1,27013 · n 130 (deal) · DD 4,3941% @1%** · **IS PF 1,22247 · n 74 · DD 5,6692%** · **peggior giornata OOS −1,0227%** — 🥇 **misurato DA ME** su `risultati_prove/ABTG_Dow_Apertura_US/ABTG_Dow_Apertura_US_U30USD_{IS,OOS}_ptc.csv`, celle `InpRangeMinutes=35 · InpAllowShort=0` (gemelli `770202`/`770203` identici). 🔴 **Secondo valore di casa**: **4,22% @1%, dep. 100.000, n 130** (R16, `PIANO_..._v2.md` r.381) → **[NON MISURATO]** il valore esatto, **entrambi scritti**; `ptc` non dichiara il deposito | 🟢 **PASS · 61,9× mediana (+55%) · 41,3× p95 (+3%)** · stop **123,8 idx [MISURATO]** su `Studio_U30USD.csv` n=446 — `ANCORA...2026-09-18.md` r.411/426. 🟢 **E il PASS è CONSERVATIVO**: il 123,8 è calcolato su un range di **15'**, la sedia viva gira a **`InpRangeMinutes=35`** (preset r. chiave) ⇒ stop vero **più largo** `[INFERITO, direzione dimostrata]` | **0,46 op/g** promessa (uscite) · **0,08 op/g** in campo (17%) · 🔴 **famiglia = 1 simbolo ⇒ 0,46 < 1,00** | 🔴 **(F)** il conto della challenge (#7) · **(F)** quante sedie il giorno 1 (#8) · **(F)** il pavimento di frequenza: **non chiudibile misurando** · **(M)** `n` in POSIZIONI (`InpTP1_ClosePct=50` ⇒ forbice **65-130**) — sbloccata dal trasporto o da 1 round per-trade · **(A)** trasporto dei CSV di **`r172a-e`** (5 assi d'uscita già girati) |
| **2** | `EMA200` **`771531`** · 🔴 **piccolo `50503392` @1,0%, dove NESSUN Guardian gira** | U30USD H1 | **OOS PF 1,52365 · n 517 deal = 257 POSIZIONI · DD 7,8323%** · **IS PF 1,20110 · n 237 deal = 132 POSIZIONI · DD 5,7325%** (dep. **100.000**, rischio **1,0%**, **tick**) — 🥇 PF/DD/n **riletti DA ME** su `risultati_prove/ABTG_EMA200/ABTG_EMA200_U30USD_{IS,OOS}_r31.csv` **righe 2-3**; le **132 posizioni IS** sono di `EMA200_DOW_COSA_MANCA_PER_IL_1_OTTOBRE_2026-09-17.md` **rr.213-217** (5 notti di `CODA_12`). **DD @0,65%: 5,09% `[APPROSSIMATO]`, e il metro sbaglia del 6%** | 🟠 **FRAGILE** — **54,9× aggregato [MIS] n=8** (`CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.401) **ma 37,1× sulla gamba 2** e **33,2× di notte** (`EMA200_DOW_COSA_MANCA_2026-09-12.md` §4). ⚪ **L'ancora nuova NON la tocca**: il suo stop è già `[MIS]` | **0,931-0,945 pos/g** 🔴 sotto · **1,873-1,901 deal/g** 🟢 sopra · **0,847 pos/g su tutta la finestra** 🔴 · famiglia = **1 simbolo** | **(A)** F7 + ricarico (il binario in campo è del **06/08**, 486 righe, **zero `InpUsaGuardian`**) · **(A)** un Guardian vivo sul conto · **(M)** DD a 0,65% — **~1 minuto di tester** · **(F)** IS a **132 < 150** (Em. A) · **(F)** l'**unità** del pavimento · **(F)** conto e taglia |
| **3** | `DAX_Apertura_EU` **`770101`** · 🏛️ **reale + 100k @0,65% + piccolo** — la più veloce | D30EUR M5 | **OOS PF 1,41105 · n 270 uscite = 193 POSIZIONI · DD 4,3501% @0,65%** (dep. **10.000 €**, tick) · **IS PF 1,1540 · n 175 · DD 3,1749%** — `CENSIMENTO_CONTRATTI_v2.md` r.215/259 · conflitto chiuso in `CONFLITTO_DD_770101_2026-09-11.md`. 🔴 **Su banco 100.000 € il DD è `[NON MISURATO]`** (+7,8% misurato sul solo effetto deposito ⇒ ≈4,69% **per proporzione**) | 🟡 **FRAGILE, e sotto dove conta**: **42,3×** alla mediana · **33,0× sulla GEOMETRIA VIVA (n=2)** · **26,6× al P95** (`CENSIMENTO_CONTRATTI_v2.md` r.215) | **~0,84 op/g** (uscite) · **~0,60** (posizioni) · **0,54** in campo · famiglia = **1 simbolo** 🔴 | **(F)** R5: 33,0× sulla geometria viva — serve una firma sulla manopola o una misura nuova · **(M)** DD a banco 100k · **(F)** conto e taglia · 🔴 **(F) e questa sedia gira anche sul REALE: qualunque cosa si firmi su di lei va scritta come NON applicabile a `10105439` senza una firma separata** |
| **4** | `ORB_Ottimizzato` **`770611`** · 🏛️ **reale @0,65% · 100k @0,30%** | U30USD M5 | **OOS PF 1,67490 · n 119 POSIZIONI · DD 6,5389%** · **IS PF 1,23076 · n 71 · DD 5,6530%** — 🥇 **misurato DA ME** su `risultati_archivio/ritardo_r119_csv/ABTG_ORB_Ottimizzato_U30USD_{IS,OOS}_R119_ORB_D0000.csv` **riga 2** (`InpMagic=770611`, dep. 10.000 €, **già a 0,65%**, tick). 🟢 `InpTP1Pct=0` ⇒ **sono posizioni**, non deal | 🔴 **SOTTO: 29,5×** (74%) · e **19,7× al p95** · 🔴 **peggiora ancora se si usa lo spread dell'ora VERA**: la sedia apre sul range **14:30-14:45** e l'ora 14 ha mediana **3,00**, non 2,00 ⇒ **19,7×** (`ANCORA...2026-09-18.md` **r.336-338**). ⚪ **L'ancora nuova NON la salva**: lo stop 59,0 è `[MIS] n=7`, e lo **Studio la conferma a 59,9 su 446 giornate** (convergenza **1,5%**) | **0,43 op/g** · famiglia = **1 simbolo** 🔴 | 🔴 **(F) FIRMA #1 — geometria OPPRANGE**, **SCADUTA il 15/09**: porta lo stop a **~128 idx ≈ 64,0×** (42,7× al p95) e apre R5. ⚠️ **La motivazione del piano è ERRATA e va letta corretta**: il *«−4,04 punti di DD»* non regge, e in campione **OPPRANGE PERDE** (PF IS 0,962) → `A4_LA_GEOMETRIA_DELLO_STOP_2026-09-12.md`. **La ragione vera è il costo, non il DD** · **(C)** 🔴 **il preset OPPRANGE NON ESISTE su file**: `mql5/Presets/ABTG_ORB_Ottimizzato_U30USD_M5_770611_100K.set` porta **`InpSLMode=3` (HALFRANGE)** — verificato da me · **(F)** conto e taglia |
| **5** | `MaxMinNotte_DAX_Short_Ott` **`770411`** · 100k @0,65% | D30EUR M15 | **DD 1,27% @1% → ≈0,83% @0,65%** (dep. **100.000 €**, tick) · 🔴 **n 21 deal → `[NON MISURATO]`**, forbice **9-21 posizioni** (`InpTP1Pct=50`, per-trade R16 assente) — `CENSIMENTO_CONTRATTI_v2.md` r.262 | 🟠 **da ⚪ NM a FRAGILE**: **37,8 – 51,5×** alla mediana 1,70 — la soglia cade **dentro** la banda; **23,8-32,4× alla coda a tick 2,70** 🔴. `ANCORA...2026-09-18.md` r.412/427. 🔴 **E il referto stesso NON la promuove a PASS**, perché la banda è fra **due leggi**, non fra due misure | 🔴 **0,078 op/g — 13× sotto il pavimento** · famiglia = 1 simbolo | **(M)** `n` in posizioni · **(M)** lo stop vero (**0 gambe in stop pieno su 4**) · 🔴 **(F)/impossibile**: 13× sotto il pavimento **non è una firma, è un'altra sedia** |
| **6** | `SupertrendReversal` **`770901`** · 100k @0,65% | 225JPY H2 | **DD 0,88% @1% → ≈0,57%** (dep. 100.000, tick) · 🔴 **n 50 deal → forbice 22-50 posizioni** — `CENSIMENTO_CONTRATTI_v2.md` r.263 | ⛔ **13,6×**, cioè **0,3 decimi sopra il pavimento DURO (13,3×)**. ⚪ L'ancora nuova non la tocca (`225JPY` ha ancora `[SOTTILE]` n=9) | 🔴 **0,18 op/g** · famiglia = 1 simbolo | **(M)** spread `225JPY` alle **h01-h07** (cash Tokyo APERTO): il verso è **a favore**, e senza quella misura il 13,6× è pessimista · 🔴 **(F)/impossibile**: frequenza 5,5× sotto |
| **7** | `SupRev_NAS_H1_Ott` **`970913`** · piccolo @1,0% | NASUSD H1 | 🔴 **PF 1,57491 · DD 1,1706% · n 155 — MA la cella viene da una GRIGLIA DI 8 PASSATE SU UNA SOLA FINESTRA, senza split** (classe 224, confermata per misura) — `CENSIMENTO_CONTRATTI_v2.md` r.316. **Deposito NON dichiarato** | 🔴 **28,7×** (72%), stop 51,65 idx n=4 — e il **minimo delle gambe è 9,70 idx = 5,4×**, **sotto il duro**. ⚠️ Il referto del 18/09 aggiunge che **quel 51,65 non è un ATR** e non vale come righello (`ANCORA...` §3 in coda) | 🔴 **0,34** · famiglia = 1 simbolo | **(M)** un **fuori campione vero** (R1 rotto) · **(M)** `n` in posizioni · **(A)** compilazione (campo 578 righe vs repo 653) · 🔴 **R5 sotto** |
| **8** | `SuperWave_DOW_H1_Ott` **`770511`** · piccolo @1,0% | U30USD H1 | 🔴 **PF 1,52140 · DD 4,0151% · n 227 — FINESTRA PIENA, 9 passate, nessuno split**; spezzata fa **84 e 143, tutte e due sotto 150** — `CENSIMENTO_CONTRATTI_v2.md` r.317. **Deposito NON dichiarato** | 🔴 **forbice 25,7× – 85,7×**, angolo pessimista **29,1×**; **minimo delle gambe 12,7 idx = 6,3×**, **sotto il duro** | 🔴 **0,50** promessa · **0,62** in campo (124%) | **(M)** split IS/OOS vero · **(M)** chiusura della forbice di costo (R126, già girato 12/13-09 — **CSV fermi sul VPS**) · **(A)** rischio VERO **2,00× misurato in campo** il 20/08 → compilazione R4 |
| **9** 🆕 | `Nasdaq_Apertura_US` **GATED SHORT `770250`** · piccolo @0,35% | NASUSD M15 | **DD 4,54% @0,65% → ~2,4% @0,35%** · pegg. giornata −0,72% · 🔴 **n 104 deal → forbice 45-104**, e **finestra intera, nessuno split** — `CENSIMENTO_CONTRATTI_v2.md` r.352 | 🟢 **DA 🟡 NO (93%) A PASS (+16%) ALLA MEDIANA** (46,2×) — stop **83,2 idx `[INFERITO]`**, `ANCORA...2026-09-18.md` r.410/425. 🔴 **Ma il verdetto DI CODA è `[NON MISURATO]`, con due valori scritti: 43,8× sul vivo · 30,8× sull'archivio** (`CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.1154, propagazione del 18/09 sera). ⚠️ **E il referto ha RITIRATO il proprio «pavimento MISURATO 75,3»**: il tag è sceso da `[MIS]` a `[INF]`, il verdetto no | 🔴 **~0,23 op/g** promessa · ✏️ **1 operazione il 15/09 14:31** (uscita in profitto ⇒ **nessuno stop misurato**) — `CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.414. Prima era **zero dal 30/08** | 🔵 **L'esclusione «per costo» NON REGGE PIÙ.** Resta ferma su **(M)** uno split IS/OOS vero, **(M)** il verdetto di coda, e **(M)** perché in 19 giorni ha fatto **una** operazione. 👉 **Coda all'imbuto, MAI in campo in automatico** |
| **10** 🆕 | `PTE` **`771321`** · piccolo @1,0% | U30USD H1 | ⚪ **PF/n/DD `[NON MISURATO]` in questo giro** — non ho aperto i CSV di questa sedia e **non riporto numeri di seconda mano** | 🟠 **DA 🔴 NO (81%) A FRAGILE**: **39,0 – 44,1×**, la soglia cade **dentro** la banda; stop **78,05-88,25 `[MISURATO]`** — `ANCORA...2026-09-18.md` r.409/424. **26,0-29,4× alla coda** 🔴 | ⚪ `[NON MISURATO]` qui | 🔵 **L'etichetta «escluso per costo» va RISCRITTA in «fragile».** **(M)** tutto il resto. 👉 Coda all'imbuto |

### 🔴 IL CONTO, ed è la riga che il piano dovrà correggere

| lettura | numero | commento |
|---|---:|---|
| candidate esaminate | **10** | 8 del piano + 2 rimesse in gioco dal cancello nuovo |
| con **R5 ≥ 40× alla mediana** | 🟢 **3** — `770202` (61,9×) · `770250` (46,2×) · `770101` (42,3×, ma **33,0× sulla geometria viva**) | era **2**, e uno dei due era su stop inferito |
| con **R5 ≥ 40× anche alla CODA** | 🟢 **1 certo** — `770202` (**41,2-41,3×**, PASS in tutte e due le letture di coda, `CANCELLO_COSTO_FLOTTA` r.1155) · 🟠 **1 con la coda `[NON MISURATO]`** — `770250` (**43,8× vivo · 30,8× archivio**) | 🆕 **non era mai stato scritto** |
| con **R3 ≥ 1,00 op/g per FAMIGLIA** | 🔴 **ZERO su 10** | 🔴 **Il piano §2 ne dava UNA (`771531`, «1,55»): quel numero contava i DEAL. In POSIZIONI fa 0,931-0,945, cioè SOTTO.** Dal 17/09 **R3 è 0/10**, non 1/10 |
| 🔴 **che passano TUTTI E CINQUE oggi, con numeri misurati** | # **ZERO** | e la ragione **non è cambiata di sedia: è R3, ed è strutturale** |
| 🟠 che passano **4 su 5** (tutto tranne R3) **senza nessuna firma** | 🟢 **1 — `770202`** | R1 ✅ · R2 ✅ (con due valori di casa) · R4 ✅ (preset dal 12/09) · R5 ✅ (misurato, passa anche al p95) |
| 🟠 che arrivano a **4/5** con **una sola firma a costo zero** | **2 in più** — `770611` (firma OPPRANGE) e `771531` (R5 resta 🟠 fragile sulla gamba 2) | |

> ## 🧪 IL CONTRO-ESEMPIO, costruito prima di consegnare la riga di testa
> *«Sto dicendo ZERO perché R3 è un criterio comodo da far fallire?»*
> **Ho provato a romperlo nelle due direzioni, e regge in tutte e due.**
> - **Se il pavimento si legge in DEAL** (la lettura più generosa che esista in
>   casa): passa **solo `771531`** (1,873-1,901). `770101` fa 0,84 in uscite,
>   `770202` 0,46, `770611` 0,43 — **tutte sotto anche in deal**. Il verdetto va
>   da **0** a **1**, non a 3.
> - **Se il pavimento si legge su TUTTA la finestra** invece che sul solo OOS:
>   `771531` scende a **0,847**, cioè il buco cresce dal 5,5% al **15,3%**
>   (`EMA200_IL_PAVIMENTO_DI_FREQUENZA_2026-09-17.md` §1). **Il contro-esempio
>   che non fa comodo l'ho scritto lo stesso.**
> 👉 **La conclusione non dipende da quale delle due letture si sceglie**, e
> questo è ciò che la rende una risposta e non un'opinione.

---

# 2. 🎯 LA CLASSIFICA — ordinata per **quanto poco manca**, non per quanto sono belle

| pos. | sedia | **quanto manca, contato** | il residuo, per nome |
|---:|---|---|---|
| 🥇 **1** | **`770202`** Dow Apertura | **2 firme, 0 misure, 0 codice, 0 gesti sul VPS** | **(F)** #7 conto+taglia · **(F)** #8 quante sedie. 🟢 È **già attaccata sul 100k a 0,65%**, il preset è su file, **il Guardian gira su quello stesso terminale** (`779001`, `CODA_01_..._20260917` r.79). 🔴 **E resta sotto R3 comunque** |
| 🥈 **2** | **`771531`** EMA200 Dow | **5 firme + 3 gesti + 1 misura da ~1 minuto** | l'elenco completo è `EMA200_DOW_COSA_MANCA_PER_IL_1_OTTOBRE_2026-09-17.md` §1, e **la colonna (C) è vuota**. Il gesto che pesa: **F7 + ricarico**, perché il binario in campo è del **06/08** e **non legge il Guardian** |
| 🥉 **3** | **`770101`** DAX Apertura | **1 firma sul costo + 1 misura (DD a 100k) + le 2 di conto** | è **la più veloce** e **l'unica con un `n` pieno** (193 posizioni OOS), ma **33,0× sulla geometria viva** è il numero che morde. ⚠️ **Gira anche sul reale `10105439`: perimetro separato** |
| **4** | **`770611`** ORB Dow | **1 firma scaduta + 1 file `.set` da scrivere + le 2 di conto** | la firma OPPRANGE è **ferma dal 15/09**, e **il preset OPPRANGE non esiste**: `..._770611_100K.set` porta `InpSLMode=3` = HALFRANGE. 🔴 Scriverlo è lavoro nostro, **caricarlo è firma sua** |
| **5** | **`770250`** GatedShort NAS | **1 round (split IS/OOS) + capire perché non opera** | 🔵 **rientra in gioco oggi**: il cancello di costo la promuove. Ma R1 è rotto, il verdetto **di coda** è `[NON MISURATO]`, e in campo ha fatto **una operazione in 19 giorni** |
| **6** | **`770511`** SuperWave Dow | **1 round di split + 1 compilazione + il costo** | `R126a/b/d` **hanno già girato** la notte 12/13-09: **i CSV sono sul VPS** |
| **7** | **`970913`** SupRev NAS | **1 round di split + 1 compilazione**, e **R5 resta sotto** | il minimo delle gambe è **5,4×**, sotto il pavimento duro |
| **8** | **`771321`** PTE Dow | **tutto tranne il costo** | 🔵 l'etichetta di costo va riscritta da «escluso» a «fragile» |
| **9** | **`770411`** MaxMin DAX | **la frequenza, e non è colmabile** | 0,078 op/g = **13× sotto**. Il costo migliora, il resto no |
| **10** | **`770901`** SupRev Nikkei | **la frequenza e il costo insieme** | 13,6× contro un pavimento duro di 13,3× |

> ## 🔴 **E LA RISPOSTA SECCA ALLA DOMANDA DEL MANDATO**
> **«Il 1° ottobre possiamo schierarne N, di cui M solo se Claudio firma entro il GG»:**
> ## **N = 0 a criteri invariati.** **N = 1 (`770202`) se si legge la rosa a 4 requisiti su 5, e allora la firma che serve è UNA SOLA: il conto (#7), entro il 22-23/09.** **N = 3 se, oltre al conto, Claudio firma entro il 26/09 la geometria OPPRANGE (#1, scaduta) e l'unità del pavimento di frequenza.**
> 🔴 **E va detto per intero: in tutti e tre i casi si parte con famiglie mono-simbolo sotto il pavimento di frequenza, cioè con una CONCENTRAZIONE firmata sapendola — non con un requisito soddisfatto.**

---

# 3. ⏰ LE SCADENZE, IN ORDINE DI CALENDARIO

## 3.1 🔴 QUATTRO firme sono scadute, non una

Il mandato ne cita **una** (la #2). **Sono QUATTRO**: il piano §7 mette
`entro **15/09**` sulle firme **#1, #2, #3 e #4**.

| # | firma | scadenza del piano | stato al 18/09 |
|---:|---|---|---|
| **#1** | Geometria ORB del giorno 1: **OPPRANGE** | **15/09** | 🔴 **SCADUTA da 3 giorni.** E la motivazione scritta nel piano è **errata** (il *−4,04* non regge): va rifirmata **sul costo**, non sul DD |
| **#2** | Spostare `771531` sul conto della challenge a 0,65% | **15/09** | 🔴 **SCADUTA da 3 giorni** — e **dipende dal conto, che non esiste** |
| **#3** | Invio delle domande ai supporti prop | **15/09** | 🟢 **ESEGUITA IN ANTICIPO, il 26/08**: tre mail (FTMO, FundedNext, Alpha), `HANDOFF.md` **r.714-716**, con **risposta scritta FundedNext del 27/08** (`backtest_pipeline/risultati_archivio/RISPOSTA_FUNDEDNEXT_2026-08-27.md`, DKIM PASS). 🔴 **MA la risposta è per lo Stellar 2-Step 200k, non per lo Stellar Lite 100k**: per il prodotto che si userebbe, la risposta scritta **non esiste**. 🔴 E `report/DOMANDE_SUPPORTO_PROP.md` porta ancora in testa *«INVIO RINVIATO»*: **due documenti di casa in disaccordo, scritti entrambi** |
| **#4** | Compilazione R4 (F7 + ricarico) | **15/09** | 🔴 **SCADUTA**, e il perimetro vero **non è 15 sorgenti ma 42 su 42** sul piccolo `50503392` (A5-bis) |
| **#5** | Default compilato PostNews 3.0 → 1.30 | **22/09** | ⏳ 4 giorni. **Non tocca nessuna sedia della rosa** |
| **#6** | Insieme dei **CLUSTER** per il tetto C10 | **22/09** | ⏳ 4 giorni — 🟢 **ma è stato MISURATO il 12/09 che il C2 non serve adesso**: `AZIONARIO` a 3,5% è **più largo del C1 a 3,25% già acceso**, e su 57 ingressi veri il picco è **1,300%**, con **zero** superamenti (`CLAUDE.md` §12/09 sera). 👉 **Declassabile: diventa una rete alla QUARTA sedia sullo stesso cluster** |
| **#7** | **Quale prop, quale taglia, quale `InpDailyBaseline`** | **29/09** | 🔴 **È IL BLOCCO VERO.** Vedi §3.2: **la data del piano è troppo tarda** |
| **#8** | Quante sedie e quali il giorno 1 | **29/09** | ⏳ 11 giorni |
| **#9** | *(opzionale)* allargare il perimetro del runner | quando vuole | 🟢 **già fatto il 13/09** (corsia ROUND sul solo `C:\MT5_Backtest`, conto `50504400`) |

## 3.2 📅 L'ULTIMA DATA UTILE VERA, contata all'indietro dal 1° ottobre

**Il conto all'indietro include il tempo macchina e di calendario DOPO la firma
— che è esattamente quello che il piano non aveva contato.**

| data | cosa deve essere vero quel giorno | perché non si può spostare più in là |
|---|---|---|
| **🔴 22/09 (lun)** | **#7 firmata: quale prop, quale conto, quale taglia** | 🔴 **Se il conto è su un feed NON-BCM** (FundedNext usa `US30`/`GER30`, non `U30USD`/`D30EUR`), **tutto il cancello di costo di questo referto va rimisurato da zero su quel feed** — e `ABTG_SpreadLogger` ha bisogno di **5-6 giorni di calendario** per arrivare a `GG ≥ 5` come gli altri otto simboli. 22/09 + 6 = **28/09**, e restano 2 giorni |
| **🟠 23/09 (mar)** | la **FASE 2 della leva** girata (§4.3) | ~4 minuti di tester, ma il risultato può **cambiare quante sedie ci stanno** ⇒ va prima della #8 |
| **🟠 24/09 (mer)** | **#4 compilazione R4** sulle sole sedie della rosa | il referto che ha trovato il difetto **sconsiglia il colpo unico**: l'ordine è **Guardian → inventario firmato → una sedia per volta, col rapporto dei lotti prima/dopo come prova**. Tre sedie a una al giorno = 3 giorni |
| **🟠 26/09 (ven)** | **#1 OPPRANGE** + **l'unità del pavimento** | il `.set` OPPRANGE **non esiste**: va scritto (nostro, ~1 h), passato dal doppio cancello, e **caricato da Claudio**. Poi serve **almeno una giornata di borsa** di verifica ⇒ 26/09 + lun 28 = margine di 2 giorni |
| **🟠 27/09 (dom)** | **#2** `771531` sul conto della challenge, con **F7 + ricarico** | il runbook mette questa sedia **per prima** nell'ordine di ricompilazione; il gesto va fatto a mercati chiusi |
| **🟥 29/09 (mar)** | **#8 quante sedie e quali** + **C3 congelare la configurazione del giorno 1** in un solo file | è la data del piano, e **resta giusta** — ma solo se le cinque righe sopra sono già fatte |
| **🟥 30/09 (mer)** | **C4 foto `.chr` fresca** dei terminali + verdetto di freschezza | è l'ultima prova che ciò che è in campo è ciò che è stato firmato |

> 🔴 **LA SCADENZA CHE NESSUNO AVEVA SCRITTO, ed è la prima:** se il conto è su
> un feed diverso da BCM, **il 29/09 è troppo tardi per la #7**. L'ultima data
> utile è **il 22-23/09**, cioè **fra 4-5 giorni**.

## 🕐 GLI ORARI, in **ora server BCM** (= ora italiana − 1), col fuso dichiarato

| sedia | evento | **ora SERVER BCM** | ora ITALIANA | fonte |
|---|---|---|---|---|
| `770611` ORB Dow | range 15' | **14:30 – 14:45** | 15:30 – 15:45 | `.set` reale · `PIANO_..._v2.md` §5 |
| `770611` ORB Dow | flat | **21:00** | 22:00 | idem |
| `770202` Dow Apertura | sessione (preset 100K, letto da me) | **14:30** (`InpSessionHour=14`, `InpSessionMin=30`) · chiusura **17:30** | 15:30 · 18:30 | `..._770202_100K.set` |
| `770101` DAX Apertura | apertura DAX | **08:00** | 09:00 | regola di casa `CLAUDE.md` |
| `771531` EMA200 | ora modale · `InpCutoffHour` | **17** · **19** | 18 · 20 | `trades_auto.csv` n=21 · CSV R112 |
| Guardian | `InpDailyResetHour` | **23** (= 00:00 CEST) | 00:00 | `FIRME_2026-08-18.md` |

🔴 **E il fuso della PROP non è il nostro.** Se il conto è FundedNext, il reset
è **00:00 sul SUO server** (GMT+3 in DST), che sul server BCM legge **22:00**,
non 23:00 — **aritmetica su due fonti scritte, `[NON MISURATO]` sul campo**
(`PIANO_..._v2.md` §0-quinquies). ⚠️ E l'ora legale europea finisce **domenica
25/10**, quella USA **domenica 01/11**: **dentro il primo mese di challenge**.

---

# 4. 🚧 IL CAMMINO CRITICO — cosa va in parallelo e cosa no

## 4.1 🚚 Bloccato **SOLO** dal trasporto dei CSV — costo macchina **ZERO**, e riparte con **una riga**

**47 round hanno i numeri fatti e dal repo non se ne legge uno**
(`IL_TRASPORTO_E_FERMO_2026-09-17.md`). Dentro ci sono, **per nome**:

| famiglia della rosa | etichette ferme | che cosa sbloccano |
|---|---|---|
| 🎯 `ABTG_Dow_Apertura_US` (`770202`) | `r152a` · **`r172a-e`** | **cinque assi d'uscita** della sedia n.1 della classifica: soglia del trailing, ora del flat, breakeven a TP1, breakeven anticipato, TP1_R. È il **requisito 3** del certificato di morte, su una candidata viva |
| 🎯 `ABTG_EMA200` (`771531`) | `r146b` (`InpFridayClose`) · `r147a` (`InpBreakeven`) | due manopole d'uscita della sedia n.2 |
| 🎯 `ABTG_DAX_Apertura_EU` (`770101`) | `canfrz` · `r147c` | la sedia che gira **anche sul conto reale** |
| `ABTG_SuperWave_DOW_H1_Ott` (`770511`) | `r165a` · `r173a` · `r173b` | la forbice di costo e il TP1 |
| `ABTG_SupRev_NAS` (`970913`) | `r163a` | |
| `ABTG_Nasdaq_Apertura_US` (`770250`) | `r170a` | il `closeatend` della sedia che oggi rientra in gioco |

🟢 **Lo strumento esiste, i percorsi COMBACIANO (verificato, non supposto), e
Claudio l'ha già lanciato una volta il 13/09** portando dentro **98 CSV**
(`PIANO_PROP.md` r.2523). 🔴 **Costa pochi minuti di rete e sblocca 47 misure
già pagate. È la cosa a rapporto valore/costo più alta di tutto il piano.**

## 4.2 ✍️ Bloccato **SOLO** da una firma — costo macchina **ZERO**

1. **#1 OPPRANGE** su `770611` (scaduta) — apre R5 · ⚠️ serve **anche** un `.set` nuovo (nostro)
2. **L'unità del pavimento di frequenza** (posizioni o deal) — **mai firmata**, e **ribalta il semaforo su `771531`**
3. **L'IS di `771531` a 132 posizioni contro 150** — lettura asimmetrica (Em. B) oppure ritaglio della finestra
4. **#7 conto e taglia** · **#8 quante sedie**
5. **La concentrazione**: tutte e dieci le famiglie hanno **un simbolo solo**

## 4.3 ⏱️ Richiede davvero **tempo macchina** — con il numero di ore

| misura | costo | perché vale |
|---|---|---|
| 🥇 **La FASE 2 della LEVA: rifare le celle vive con `Leverage=15` nell'`.ini`** | **~10 passate ≈ 4 minuti** (metro di casa: 0,375 min/passata, R112) | 🔴 **È LA MISURA PIÙ ECONOMICA E PIÙ DECISIVA CHE MANCA, E NON È MAI STATA GIRATA.** Vedi §4.4 |
| **DD di `771531` a 0,65%** (buco **M40**) | **~1 minuto** | trasforma l'ultimo `[APPROSSIMATO]` del contratto in `[MISURATO]` |
| **R179a — posizioni con trailing OFF** | **4 passate ≈ 1,5 min** (file prova **pronto, non armato**, `controlla_prova.py` OK) | decide se il **+44,8% di profitto per posizione** è vero o è un artefatto del denominatore |
| **Split IS/OOS di `770250`** | 2-4 passate ≈ **1-2 min** | chiude R1 sull'unica sedia che il cancello nuovo ha promosso |
| **Spread sul feed della PROP** | **0 min di tester · 5-6 GIORNI di calendario** | 🔴 **è la voce che governa la scadenza del 22/09** |
| **Storico lungo indici (`_EXT`, HistData)** | **42-105 ore** | 🔴 **in 13 giorni NON ci sta.** Dichiarato, non nascosto |

## 4.4 🔴🔴 IL VINCOLO CHE NESSUNO AVEVA MESSO NELLA ROSA: **LA LEVA 1:15**

> ### 🎯 **Il terzetto proposto dal piano occupa il 97,5% del margine del conto nel giorno peggiore. Non è un'opinione: è un conto fatto in casa il 27/08 e mai portato davanti alla rosa di ottobre.**

Fonte: `backtest_pipeline/risultati_archivio/ANALISI_TAGLIA_FASE1_2026-08-27.md`
**r.164-176** e **r.185-187**. La leva **1:15 sugli indici in TUTTE le fasi** è
una **`[RISPOSTA SCRITTA]`** di FundedNext (27/08, DKIM PASS), il rango di fonte
più alto che abbiamo.

| sedia | **% del conto, margine di UN ingresso (max)** | mediana |
|---|---:|---:|
| `770611` ORB Dow | 🔴 **44,0%** | 15,5% |
| `771531` EMA200 Dow | 🔴 **38,9%** | 11,3% |
| `770411` MaxMin DAX | 🔴 **31,4%** | **28,9%** |
| `770101` DAX Apertura | 🟠 **20,7%** | 13,9% |
| `770202` Dow Apertura | 🟢 **14,6%** | 14,1% |
| **il terzetto `770611`+`770202`+`771531`** | 🔴 **97,5%** | 40,9% |
| **il cap C1 a 5 SL vivi** | 🔴 **149,5% — il margine finisce prima del 4°-5° ingresso** | 83,7% |

**Tag**: `[PROIETTATO]` su scala lineare, prezzi del 26/08, calcolato su 200k.
🟢 **E la percentuale è INVARIANTE rispetto alla taglia**, e non lo dico io: lo
scrive la fonte stessa alle **r.70-71** (`margine% = lotti × prezzo / (leva ×
conto)`, e i lotti scalano col conto).

### 🧪 IL CONTRO-ESEMPIO, costruito prima di consegnare
*«A 100k invece che a 200k il numero migliora?»* — **No, peggiora, e nella
direzione che fa male.** A 100k i lotti si dimezzano, quindi il **pavimento del
lotto** (`MathMax` sul volume minimo, classe 228) morde **di più**: il lotto
eseguito è **≥** quello proporzionale ⇒ **il 97,5% è un LIMITE INFERIORE a
100k, non una sovrastima.** `[INFERITO, direzione dimostrata]`

### 👉 COSA NE SEGUE, e non è una proposta di taglia
🔴 **Non tocco taglie né rischio: non sono miei.** Dico solo che
**la domanda «quante sedie il giorno 1» (#8) non ha una risposta misurata
finché la FASE 2 non gira**, e che girarla costa **~4 minuti**. Il tester MT5 ha
il campo `Leverage` nell'`.ini`: si mettono le celle vive a `Leverage=15` e si
contano **(a)** i *«not enough money»* nel giornale, **(b)** i trade a lotto
tappato, **(c)** la deviazione da gemello a leva BCM.

## 4.5 🔴 LA DOMANDA SCOMODA: **che cosa stiamo facendo che NON serve per il 1° ottobre**

**Lo dichiaro per nome, come vuole la classe 180 — mai «tutto ciò che non è X».**

| cosa | perché non avvicina una sedia al 1° ottobre |
|---|---|
| 🔴 **L'indicatore `ABTG_SuperEMA_Riding` / il Pine v2** (**quattro** giri di cancello fra il 16 e il 18/09, 13 classi di difetto, ~2.500 righe riviste) | è uno **strumento manuale per Claudio**, non una sedia. Utile, richiesto da lui, **ma è ponteggio rispetto all'obiettivo «sedia schierabile»** e va contato come tale |
| 🔴 **~40 dei 47 round fermi** — `PunteLarry` (8) · `GapFill` (r167a-d, r168a-d, r175a, r178a) · `BreakingBand` (r161a, r174a, r176a, r177a) · `EasyTrend` · `CostToCost` · `Cycle` · `MaxMinNotte` oro · `PTE` GBPUSD | **nessuna di queste famiglie può essere in campo il 1° ottobre**: R1/R2/R5 rotti, o DD fuori muro (`CostToCost` GBPCAD **~10,4% da sola**). Sono **exit-management per DOPO ottobre**, e la coda notturna li sta producendo **al posto** delle misure della rosa |
| 🟠 **La potatura della coda e il `-Rifai`** (~11 h a notte rifatte) | è **ponteggio utile**: libera macchina. Ma **non avvicina nessuna sedia da solo**, e va detto |
| 🟠 **Il tetto per CLUSTER C2/C10** (firma #6, 22/09) | 🟢 **misurato il 12/09 che non serve adesso**: è più largo del C1 già acceso, e su 57 ingressi veri il picco è 1,300% con **zero** rifiuti |
| 🔴 **L'import dello storico lungo indici** | **42-105 ore.** In 13 giorni **non ci sta**, ed è la commessa vera **per dopo ottobre** |

> ### 🎯 **E la contropartita, perché la bussola vale in tutte e due le direzioni**
> Le cose che **servono davvero** e costano **meno di dieci minuti di macchina in
> tutto** sono: **la riga del trasporto** (0 min) · **la FASE 2 della leva**
> (~4 min) · **il DD a 0,65% di `771531`** (~1 min) · **R179a** (~1,5 min) ·
> **lo split di `770250`** (~1-2 min). 🔴 **Totale: ~8 minuti di tester contro
> 13 giorni di calendario.** Il collo di bottiglia del 1° ottobre **non è mai
> stato la macchina.**

---

# 5. 🔓 LE OCCASIONI — cosa era stato scartato per un motivo che oggi non regge più

## 5.1 🟢 Le riaperture **del cancello di costo**, che è appena cambiato

| candidata | motivo scritto ieri | 🟢 oggi | dove va |
|---|---|---|---|
| **`770250`** GatedShort NASUSD M15 | 🟡 *«NO, 93% del pavimento»* (~37,2× `[INF]`) | 🟢 **PASS +16% ALLA MEDIANA** (46,2×) · 🔴 **coda `[NON MISURATO]`: 43,8× vivo contro 30,8× archivio, e i due cadono ai due lati della soglia** | **coda all'imbuto**: mancano uno **split IS/OOS vero** (1-2 min di tester) **e** la riconciliazione della coda |
| **`771321`** PTE U30USD H1 | 🔴 *«NO, 81%»* (32,5× `[INF]`) | 🟠 **FRAGILE: 39,0-44,1×**, con stop **`[MISURATO]`** | l'etichetta va **riscritta**, non ribaltata |
| **`770411`** MaxMin DAX M15 | ⚪ *«non misurato»* | 🟠 **FRAGILE: 37,8-51,5×** | 🔴 **ma resta ferma 13× sotto la frequenza** |
| **`970912`** SupRev DAX H4 | 🟢 PASS su stop `~170 [INF]` | 🟢 **PASS confermato**, numero riscritto a **112-313** | invariato |
| 🆕 **Il TF M30 sul DAX** | 🔴 *«M30 a 1,5 ATR: 32,1-36,5×, NO»* | 🟢 **43,7× (+9%)** con la finestra attiva W=780 | 🔴 **ma solo alla coda da polling 1,70**: alla coda a tick 2,70 **nessuna cella viva del DAX passa**. **[NON MISURATO]**, con **entrambi gli esiti scritti** |

🔴 **E il limite che va scritto accanto, altrimenti la riapertura è una
trappola**: `SPXUSD`, `F40EUR`, `E35EUR`, `E50EUR`, `100GBP`, `200AUD` **non
hanno nessuno spread misurato in casa**. Per loro il cancello è
**`[NON CALCOLABILE]`**, che **non è** *«escluso per costo»* e **non è**
*«passa»*.

## 5.2 🔵 Le riaperture **di frequenza**: già fatte, e ferme da dieci giorni

🟢 **La rilettura chiesta dal mandato ESISTE GIÀ**: `RIPESCAGGIO_FREQUENZA_2026-09-08.md`
ha riletto gli scarti con l'unità firmata il 07/09 e ha trovato **7 candidati
che rientrano in coda** e **3 verdetti da riscrivere**.
🔴 **La notizia vera non è che ce ne sono sette: è che in dieci giorni nessuno
dei sette è arrivato a un round.** Non è una colpa, è una misura del collo di
bottiglia — e **nessuno di loro può essere in campo il 1° ottobre**, perché
partirebbe da zero misure.

## 5.3 🆕 I numeri che erano già in casa e nessuno aveva letto

1. 🟢 **La peggior giornata di `770202` e `770101`.** Il piano §6 punto 4
   elenca *«la peggior giornata VERA di 7 sedie su 8»* fra ciò che al 30/09
   **non avremo**, con **`771531` come unica eccezione**. **Non è più vero**:
   `770202` fa **−1,0227% OOS** (misurato da me su `..._OOS_ptc.csv`, colonna
   `Peggior Giornata %`) e `770101` sta fra **−1,0086% e −1,1524% su tutte e 180
   le celle** di `ptd`. ⚠️ **Limite dichiarato**: è la peggior giornata sui
   **chiusi**, non in equity — su `771531` R112 ha **tutte e due** (−2,45% / −1,98% @1%).
2. 🟢 **La Regola dei Due Lati su `770202` è misurata**, e conferma la
   configurazione viva: accendere lo short dà **+56% di operazioni** fuori
   campione **ma quasi raddoppia il DD** (4,39% → 8,68%) e porta il **PF sotto
   1,10** (1,27013 → 1,09627) — `TRE_ASSI_MAI_LETTI_2026-09-17.md` §🥇.
   👉 **La strada «compro frequenza accendendo il lato mancante» è chiusa col
   numero sulla sedia n.1 della classifica.**
3. 🔴 **E una che va nella direzione opposta**: `770101` è **un bordo, non un
   centro**, lungo l'asse RANGE (RM 30 sta fuori: −21,3% di PF, +2,29 pp di DD).
   Lungo l'asse BUFFER è un centro vero. **Un asse buono e uno no.**

## 5.4 🚫 Cosa NON riapro, e perché

- ❌ **Nessun certificato di morte firmato qui.** `770250`, `771321`, `770411`,
  `770511`, `970913` restano **«non ancora misurate»**, con scritto accanto
  **cosa manca e quanto costa**.
- ❌ **Non propongo di abbassare, spostare o reinterpretare nessuna soglia.** La
  §5.4 del referto sulla frequenza porta a Claudio una **domanda di unità di
  misura**, e quella domanda **può rendere i criteri più severi altrove**: se si
  decide «deal», **lo stesso metro va applicato a tutta la flotta**.
- ❌ **Niente entra in campo in automatico.** La regola firmata il 07/09 dice
  *«tornano in coda all'imbuto, mai in campo in automatico»*, e vale identica
  per le riaperture di costo di oggi.

---

# 6. 📮 COSA MANCA E CHI LO PORTA — le richieste, per nome

| buco | 🎯 chi lo porta | la domanda **esatta** |
|---|---|---|
| 🚚 **I CSV dei 47 round fermi dal 13/09** | 👤 **Claudio**, una riga su una **finestra PowerShell del VPS** (nessun MT5 da toccare) | *«Lancia `carica_risultati.ps1`: sono numeri già pagati, e dentro ci sono `r172a-e` di `770202`, `r146b`/`r147a` di `771531` e `canfrz`/`r147c` di `770101`.»* 🚦 **La riga la prepariamo noi e passa dal doppio cancello prima di uscire** |
| 🔴 **Su QUALE conto girerà la flotta EA** | 👤 **Claudio, e solo lui** | *«Il FundedNext Stellar Lite 100k comprato il 15/09 è il conto degli EA o è il tuo conto MANUALE? Se è degli EA, il cancello di costo va rimisurato sul feed FundedNext e servono 5-6 giorni: la firma #7 scade il 22/09, non il 29/09.»* — nel repo l'unico documento che parla di quell'acquisto è `PROP_MANUALE_CONFRONTO_2026-09-15.md`, **esplicitamente per il trading a mano**, e sul VPS c'è una cartella `C:\MT5_MANUALE` con **0 sedie** (`CODA_01_..._20260917` rr.89-92) |
| 🔴 **La leva vera sugli indici dello Stellar Lite** | 👤 **Claudio**, dalla pagina *Symbols & Conditions* del **suo** account loggato | *«1:15 o 1:25? È il numero che decide se tre sedie sugli indici ci stanno nel margine.»* La risposta scritta del 27/08 dice **1:15 in tutte le fasi**, ma è per il **2-Step 200k** |
| ⚙️ **La FASE 2 della leva** (`Leverage=15` nell'`.ini`) | 🤖 **cacciatore-strategie** — file prova + round, **~4 minuti** | *«Rifai le celle vive di `770611`, `770202`, `771531`, `770101` con `Leverage=15` e conta: ordini rifiutati per margine, trade a lotto tappato, deviazione dal gemello a leva BCM.»* |
| 📏 **Il DD di `771531` a 0,65%** (buco **M40**) | 🤖 **cacciatore-strategie**, **~1 minuto** | *«Stessa cella, stesso file prova, `-Deposito 100000 -Rischio 0,65`. Non è ricavabile da nessun CSV in repo.»* |
| 📁 **Il `.set` OPPRANGE di `770611`** | 🤖 **noi scriviamo · 👤 Claudio carica** | il preset attuale `..._770611_100K.set` porta **`InpSLMode=3` (HALFRANGE)**: il file della geometria firmata **non esiste** |
| 🕐 **Lo spread di `225JPY` alle h01-h07** (cash Tokyo APERTO) | 🤖 **cacciatore-config-prop** | sblocca `770901`, `770924`, `774101`, `772235` — e **il verso è a favore** |
| 📜 **Il regolamento Stellar Lite verificato sul sito ufficiale** | **analista-trascrizioni** / 👤 Claudio | fa fede `DOMANDE_SUPPORTO_PROP.md` **+ la risposta scritta del supporto**: senza, **non si compra**. Oggi la risposta scritta che abbiamo è per **un altro prodotto** |

---

# 7. 🚦 COSA QUESTO REFERTO **NON** FA — dichiarato

- ❌ **Non archivia niente. Nessun certificato di morte.**
- ❌ **Non promuove, non accende e non spegne nessuna sedia.** Le riaperture del
  §5 vanno **in coda all'imbuto**, mai in campo in automatico.
- ❌ **Non propone taglie, parametri di rischio, né l'acquisto di niente.** La
  §4.4 dice che una misura manca; **non dice quante sedie schierare**.
- ❌ **Non ha toccato nessun EA, preset, file prova, riga di coda o terminale**,
  e non ha letto né nominato come bersaglio il conto reale `10105439`.
- ❌ **Non ha lanciato un solo backtest.** Costo macchina: **0**.
- ⚠️ **Buchi che lascio aperti, PER NOME:**
  1. ⚪ **`771321` PTE**: PF, `n` e DD **non li ho misurati io** e non li riporto
     di seconda mano. La riga di costo sì, quella ha file e riga.
  2. ⚪ **Il deposito di `ptc`** (la corsa che dà `770202` OOS 4,3941%) **non è
     dichiarato**: il round `pt*` del 09/08 **non ha un file prova né una riga
     in `REGISTRO_TEST.md`** (verificato con `grep`). Perciò il DD di `770202`
     resta **`[NON MISURATO]` con due valori scritti: 4,22% e 4,3941% @1%**.
  3. ⚪ **`n` in POSIZIONI**: su **6 candidate su 10** il numero conta i **deal**
     (classe 226). Le forbici sono scritte riga per riga in tabella.
  4. ⚪ **Il feed della prop**: **nessuna** misura di spread, tick o commissione
     di questo referto è verificata fuori da BCM.
  5. ⚪ **Il flottante**: tutte le «peggior giornata» sui CSV vedono i **chiusi**;
     il muro giornaliero della prop guarda l'**equity in tempo reale**.
     L'unica sedia con tutte e due è `771531`.

---

# 8. 📜 CHANGELOG

| data | cosa è cambiato | perché |
|---|---|---|
| **18/09/2026** | **Prima stesura.** Rosa portata da **8 a 10** candidate (rientrano `770250` e `771321` per effetto dell'ancora nuova). 🔴 **Corretto il conto del piano su R3**: da *«1 sedia sopra il pavimento»* a **ZERO**, perché il «1,55 op/g» di `771531` contava i **deal** e in **posizioni** fa 0,931-0,945. 🟢 **`770202` promossa a capolista**: R4 chiuso dal preset del 12/09, R5 passato da `[INF] 51,0×` a `[MISURATO] 61,9× / 41,3× al p95`. 🔴 **Scadute QUATTRO firme, non una** (#1, #2, #3, #4 — tutte al 15/09), e **#3 risulta eseguita il 26/08** ma con risposta scritta per il prodotto sbagliato. 🔴 **Aperto il vincolo della LEVA 1:15** (terzetto = 97,5% del margine ai massimi), mai portato davanti alla rosa. 🟢 **Chiuso il punto 4 della lista §6 del piano**: la peggior giornata esiste anche su `770202` e `770101` | mandato del 18/09: *«quali sedie possono essere in campo il 1° ottobre, e per ognuna che cosa manca esattamente»* |
| **18/09/2026**, poche ore dopo | ✏️ **Corretta la riga `770250` su DUE punti**, prima della consegna: **(a)** il verdetto **di coda** non è «PASS +9%» ma **`[NON MISURATO]`**, con **43,8× (vivo)** e **30,8× (archivio)** ai due lati della soglia; **(b)** non fa più **zero** operazioni dal 30/08: ne ha fatta **una il 15/09 14:31**, uscita in profitto (quindi **nessuno stop misurato**) | il commit `b40f3391` (*«Cancello del costo: propagata la ricalibrazione dell'ancora ADR»*) è atterrato **dopo** la mia lettura e raffina due numeri: li recepisco invece di lasciarli divergere |

---

## 📚 FONTI — tutte sul branch `lavoro`, tutte lette in questo giro

**Letti per intero:** `report/EMA200_DOW_COSA_MANCA_PER_IL_1_OTTOBRE_2026-09-17.md` ·
`report/EMA200_IL_PAVIMENTO_DI_FREQUENZA_2026-09-17.md` ·
`report/ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` ·
`report/EMA200_LA_PORTA_DEL_TRAILING_2026-09-18.md` ·
`report/IL_TRASPORTO_E_FERMO_2026-09-17.md` ·
`report/TRE_ASSI_MAI_LETTI_2026-09-17.md` · `report/RESOCONTO_2026-09-17.md` ·
`report/PIANO_CHALLENGE_OTTOBRE_v2.md` §0…§8 ·
`backtest_pipeline/risultati_archivio/RISPOSTA_FUNDEDNEXT_2026-08-27.md`

**Letti nelle sezioni citate:** `report/CENSIMENTO_CONTRATTI_v2.md` (rr.213-320, 352, 383-409) ·
`backtest_pipeline/risultati_archivio/ANALISI_TAGLIA_FASE1_2026-08-27.md` (rr.70-71, 164-176, 185-193, 201-219) ·
`report/RIPESCAGGIO_FREQUENZA_2026-09-08.md` §0-1 ·
`report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md` (righe col cancello `FREQUENZA`) ·
`report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` rr.331, 401, 409, 665 ·
`backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` classi **410** e **411** ·
`HANDOFF.md` rr.705-760 · `report/DOMANDE_SUPPORTO_PROP.md` (intestazione) ·
`report/PROP_MANUALE_CONFRONTO_2026-09-15.md` §0

**CSV e preset aperti DA ME, riga per riga:**
`backtest_pipeline/risultati_prove/ABTG_EMA200/ABTG_EMA200_U30USD_{IS,OOS}_r31.csv` ·
`backtest_pipeline/risultati_archivio/ritardo_r119_csv/ABTG_ORB_Ottimizzato_U30USD_{IS,OOS}_R119_ORB_D0000.csv` ·
`backtest_pipeline/risultati_prove/ABTG_Dow_Apertura_US/ABTG_Dow_Apertura_US_U30USD_{IS,OOS}_ptc.csv` ·
`mql5/Presets/ABTG_Dow_Apertura_US_U30USD_M5_770202_100K.set` ·
`mql5/Presets/ABTG_ORB_Ottimizzato_U30USD_M5_770611_100K.set` ·
`mql5/Presets/ABTG_DAX_Apertura_EU_D30EUR_M5_770101_100K.set` ·
`mql5/Presets/ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_M15_770411_100K.set` ·
`mql5/Presets/ABTG_SupertrendReversal_225JPY_H2_770901_100K.set` ·
`backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260917_033003.log` ·
`backtest_pipeline/coda/referti/CODA_07_desktop_20260917_033003.log` (rr.140-154)
