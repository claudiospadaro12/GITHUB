# 🪑 QUANTE SEDIE CI STANNO DAVVERO SUL CONTO DA 80.000 EUR — **R232**, 23/09/2026

**Sigla:** `R232` (grepata libera nel momento in cui questa riga è stata scritta:
`grep -rn "R232" --include="*.md" .` → nessuna occorrenza).
**Costo macchina:** 🟢 **ZERO minuti.** Nessun round, nessuna riga verso il VPS o verso il PC di
backtest, nessun MT5 aperto. Questo referto legge **solo file già in repo**.
🚫 **Nessuna sedia, nessun preset, nessun `.set`, nessun EA, nessun forward toccato** — sei sedie
stanno operando adesso. 🚫 **Niente sul conto reale.** 🚫 **Nessun candidato promosso o archiviato.**

---

> # 🔴 LA COSA DA LEGGERE PRIMA DI TUTTO IL RESTO
>
> ## **UNA LEVA PIÙ ALTA VUOL DIRE PIÙ *SPAZIO*, NON MENO *RISCHIO*.**
>
> Scoprire che la leva è **1:50** e non 1:15 cambia **una sola cosa**: quanti euro il broker
> immobilizza per tenere aperta una posizione. 🔴 **Non cambia di un millimetro** quanto si perde
> se lo stop viene preso, né il muro **statico del 10%**, né il muro **giornaliero del 5%**, né il
> cap sul rischio aperto.
> 👉 **Niente in questo referto autorizza ad alzare una taglia o ad accendere una sedia in più.**
> Taglie, numero di sedie e parametri di rischio sono **firma di Claudio**. Io porto i numeri.
> 🔴 **E il numero che conta più di tutti è questo: a 2,00% per sedia, il muro che si tocca per
> primo NON è il margine — è il muro GIORNALIERO del 5%, e lo si tocca alla TERZA sedia aperta
> insieme.** Il margine, che credevamo il primo, è **l'ultimo**.

---

# 0️⃣ 🎯 LA RISPOSTA IN OTTO RIGHE

1. 🟢 **La leva 1:50 è confermata, e l'ho allargata da 3 a 5 simboli** — chiudendo il buco #1 che
   `R229` aveva dichiarato aperto. **Indici e oro: 1:50. Forex: 1:100.** `GER40.cash` lo dice
   **senza cambio di mezzo**: `25.312,17 / 506,24 = ` **`50,000` esatto**. §1.
2. ✅ **R230 ha ragione sulle taglie, e l'ho riverificato file per file**: i **sette** preset EA
   della rosa portano tutti `InpRiskPercent=2.00`. 🟠 **Con una precisazione che R230 non fa**: la
   cartella FTMO contiene **dieci** preset, e le tre PostNews sono a **1,30**. La flotta
   **0,65/1,00** non esiste più; una flotta **2,00/1,30** sì — ma le PostNews **non tradano**. §2.
3. ✅ **R230 ha ragione anche sull'orologio**: `770202` e `770260` armano **allo stesso minuto**
   (`InpSessionHour=16`, `InpSessionMin=30`), e `771531` e `770511` girano **0-24 senza guardia
   oraria** (`InpUseCutoff=false` · `InpUseTimeWindow=false`). Verificato nei `.set`. §3.
4. 📐 **Il momento peggiore della giornata è la finestra `17:05 → 19:00` ora server FTMO**
   (`16:05 → 18:00` ora italiana): è l'unica in cui **tutte e sei** le sedie possono avere una
   posizione aperta nello stesso istante. §3.
5. 🔢 **Se tutte e sei fossero aperte insieme a 2,00%, il margine chiesto è 84.055 EUR = 105,07%
   del conto**: il **sesto** ordine verrebbe **rifiutato** dal broker. Calcolato **non** riscalando
   i vecchi numeri, ma dai **margini misurati dal broker** e dal conto vero in EUR. §3.
6. 🧱 **L'ordine dei muri, e quale morde per primo — con i numeri**: pausa morbida del Guardian
   **3,5%** → **2ª** sedia · muro **giornaliero 5%** → **3ª** · muro **statico 10%** → **5ª** ·
   **margine** → **6ª**. 🔴 **Il margine è l'ULTIMO dei quattro.** §4.
7. 🔴 **E ho trovato un buco che nessun referto in repo dichiara: il cap C1 non vede gli ordini
   PENDENTI, e tutte e sei le sedie entrano con ordini pendenti.** Quindi il C1 al 4,00%
   **non** limita a due il rischio simultaneo: è una guardia sull'**aggiunta**, non un tetto.
   **Classe 645.** §5.
8. 📋 **Chi è pronto a occupare un posto**: nessuno lo è **oggi**. Il più vicino è il **Dow
   Apertura in versione breakout a due lati** (`770201`) — **80 passate ≈ 6,8 minuti** per
   chiudere il suo unico difetto. Lista completa con costi al §7.

---

# 1️⃣ 🔬 LA LEVA — riverificata, e allargata da 3 a 5 simboli

## 1.1 La fonte, e perché è la migliore che abbiamo

`backtest_pipeline/risultati_prove/PREVOLO_FTMO_specifiche_2026-09-20.csv`, prodotto il **20/09
alle 17:08** sul conto della challenge dallo script `ABTG_PrevoloFTMO_Specifiche.mq5` (sola
lettura). La colonna **`Margine1Lotto`** esce da **`OrderCalcMargin()`**: 🎯 **è il broker a fare
il conto, non noi.** Nella stessa riga ci sono **`Bid`, `Ask` e `ContractSize`**: il rapporto si
chiude **dentro una riga sola**, senza andare a cercare prezzi altrove.

## 1.2 🔢 Il conto, simbolo per simbolo

| simbolo | `Ask` | `ContractSize` | nozionale (valuta quotata) | `Margine1Lotto` (EUR) | **nozionale ÷ margine** |
|---|---:|---:|---:|---:|---:|
| `GER40.cash` | 25.312,17 | 1 | **25.312,17 EUR** | 506,24 | 🟢 **50,000** |
| `US30.cash` | 51.735,36 | 1 | 51.735,36 USD | 900,87 | **57,428** |
| `US100.cash` | 29.686,67 | 1 | 29.686,67 USD | 516,94 | **57,428** |
| `XAUUSD` | 4.378,25 | 100 | 437.825,00 USD | 7.623,89 | **57,428** |
| `USDJPY` | 156,882 | 100.000 | 100.000,00 USD | 870,66 | **114,855** |

> ## 🎯 **`GER40.cash` quota in EUR e paga il margine in EUR: la sua leva si legge NUDA e fa `50,000` esatto.**
> I tre simboli quotati in **USD** danno tutti e tre **lo stesso identico `57,428`** = `50 × 1,1486`.
> `USDJPY` dà **`114,855`** = `100 × 1,1486`.
> 👉 **Indici e oro: 1:50. Forex: 1:100.** E `1,1486` è il cambio EUR/USD di settembre 2026.

## 1.3 🧪 IL CONTRO-ESEMPIO, costruito per far sbagliare questa conclusione

**L'ipotesi alternativa da battere** non è *«non c'è niente»* — quella non è un test. È:
> *«il margine non è `nozionale ÷ leva`: è un margine FISSO per lotto deciso a tavolino dal
> broker, e i numeri che ti tornano sono coincidenze.»*

Se fosse vera, tre simboli con **contract size `1`, `1` e `100`**, prezzi che vanno da 156 a 51.735
e **due valute di quotazione diverse** darebbero **tre rapporti diversi**. Danno **`57,428`,
`57,428`, `57,428`**: 🔴 **uguali alla terza cifra decimale.** E il quarto (`USDJPY`, contract size
**100.000**) dà **esattamente il doppio**, che è la firma di una **classe d'asset diversa**, non di
un numero a caso.

🟢 **Seconda gamba**: il cambio implicito che rende coerenti tutti e quattro è **1,1486**. Se
l'ipotesi fosse sbagliata, quel numero sarebbe **un numero qualunque**; invece è il **cambio
EUR/USD di mercato**, e lo si ritrova — misurato per una strada completamente diversa — nel
contro-esempio 2.1 del pacchetto di schieramento (rapporti P/L **1,147 / 1,148 / 1,149** su
operazioni **vere**).

🟢 **Terza gamba, ed è quella che chiude**: `GER40.cash` non ha **nessun** cambio dentro. Se il
`1,1486` fosse un errore mio, il DAX non farebbe `50,000` **esatto**.

## 1.4 🟢 CHE COSA CHIUDO DEI BUCHI DICHIARATI DA `R229`

| buco dichiarato in `LA_LEVA_E_1_50_2026-09-23.md` §7 | esito qui |
|---|---|
| **#1** *«`XAUUSD` e `USDJPY`: non li ho verificati»* | 🟢 **CHIUSO**: `XAUUSD` è **1:50** (stessa classe degli indici), `USDJPY` è **1:100** |
| **#3** *«il margine di `770402`: `[NON CALCOLABILE DA QUI]`»* | 🟢 **CHIUSO**: a 2,00% su 80.000 EUR fa **4.253 EUR = 5,32%** del conto (§3.2) — 🔴 **e la sedia non è schierata** |
| **#2** *«la leva 1:50 è DEDOTTA dai margini, non letta da una specifica di contratto FTMO»* | 🔴 **RESTA APERTO.** È una deduzione, per quanto verificata cinque volte. Si chiude con uno screenshot di *Specification* → riga *Initial margin*, **cinque secondi dentro MT5** — e oggi non si può fare (Claudio è da cellulare) |
| **#4** *«il margine dei tre PostNews»* | 🔴 **RESTA APERTO**: i loro simboli non sono tutti nel CSV e **non tradano** (§7.3) |

---

# 2️⃣ ⚖️ LE TAGLIE — ho riverificato R230 leggendo i dieci `.set`, uno per uno

**Comando** (sola lettura): `grep -iE "^InpRiskPercent=" mql5/Presets/FTMO/*.set`

| preset FTMO | `InpRiskPercent` | schierata? |
|---|---:|---|
| `ABTG_DAX_Apertura_EU_770101_FTMO.set` | **2.00** | 🟢 sì |
| `ABTG_Dow_Apertura_US_770202_FTMO.set` | **2.00** | 🟢 sì |
| `ABTG_EMA200_771531_FTMO.set` | **2.00** | 🟢 sì |
| `ABTG_MaxMinNotte_DAX_Short_770411_FTMO.set` | **2.00** | 🟢 sì |
| `ABTG_Nasdaq_Apertura_US_RETEST_770260_FTMO.set` | **2.00** | 🟢 sì |
| `ABTG_SuperWave_DOW_H1_770511_FTMO.set` | **2.00** | 🟢 sì |
| `ABTG_MaxMinNotte_ORO_770402_FTMO.set` | **2.00** | 🔴 **NO** — `NOTTE_2026-09-20.md` r.137 |
| `ABTG_PostNews_ECB_EURUSD_771204_FTMO.set` | **1.30** | 🟠 attaccata, **muta** |
| `ABTG_PostNews_FOMC_EURUSD_771202_FTMO.set` | **1.30** | 🟠 attaccata, **muta** |
| `ABTG_PostNews_NFP_USDJPY_771203_FTMO.set` | **1.30** | 🟠 attaccata, **muta** |

> ## ✅ **R230 HA RAGIONE: i sette preset EA della rosa sono TUTTI a `2.00`, e la flotta mista 0,65/1,00 NON esiste più.** Nessun `.set` in quella cartella contiene `0.65` o `1.00` come `InpRiskPercent`.
> 🟠 **La precisazione che R230 non fa, e che conta per il conto dei muri**: la cartella contiene
> **dieci** preset, non sette. Le tre PostNews sono a **1,30%**, quindi *«non esiste più una flotta
> mista»* è vero per **0,65/1,00** e **falso alla lettera**. 🟢 **In pratica non morde**, ed è
> misurato: le tre PostNews **non tradano** nella finestra della challenge
> (`report/LE_POSTNEWS_NON_TRADERANNO_2026-09-20.md`: `771203` ha **zero eventi futuri**, `771202`
> e `771204` non prima del **28-29/10**, e quella data **non è stabilita**).

---

# 3️⃣ ⏰ CHI ARMA QUANDO, E QUANTO MARGINE PESA — **il picco, non la somma**

## 3.1 L'orologio dell'armamento, letto dai `.set`

🔴 **Tutti gli orari qui sono in ORA SERVER FTMO** (= ora italiana **+1**). Le colonne sono
copiate dai preset, non ricordate.

| sedia | simbolo / TF | chiavi d'orario nel `.set` | **arma (server)** | **arma (IT)** | chiude |
|---|---|---|---|---|---|
| `770511` SuperWave | `US30` H1 | `InpUseTimeWindow=false` · `InpStartHour=0` · `InpEndHour=24` | 🔴 **0-24, nessuna guardia** | 0-24 | nessun orario: esce su Supertrend/trailing |
| `771531` EMA200 | `US30` H1 | 🔴 **`InpUseCutoff=false`** · `InpFridayClose=false` | 🔴 **0-24, nessuna guardia** | 0-24 | nessun orario |
| `770411` MaxMin DAX Short | `D30EUR` M15 | `InpPlaceHour=9` · `InpEntryCutoffHour=10` · `InpCloseHour=19` | **09:00** (pendenti) | 08:00 | 19:00 |
| `770101` DAX Apertura | `D30EUR` M5 | `InpSessionHour=10` · `InpSessionMin=0` · `InpRangeMinutes=35` · `InpCloseHour=19` | **10:35** (pendenti) | 09:35 | 19:00 |
| `770202` Dow Apertura | `U30USD` M5 | `InpSessionHour=16` · `InpSessionMin=30` · `InpRangeMinutes=35` · `InpCloseHour=19` | 🔴 **17:05** (pendenti) | 16:05 | 19:00 |
| `770260` Nasdaq RETEST | `NASUSD` M5 | `InpSessionHour=16` · `InpSessionMin=30` · `InpRangeMinutes=35` · `InpCloseHour=19` | 🔴 **17:05** (pendenti) | 16:05 | 19:00 |

> ## ✅ **CONFERMATO, e non per sentito dire: `770202` e `770260` hanno gli stessi identici `InpSessionHour=16` e `InpSessionMin=30`.** Armano **nello stesso minuto**, sullo stesso continente, nella stessa apertura.
> ✅ **CONFERMATO anche il resto**: `771531` e `770511` non hanno **nessuna** guardia oraria accesa.

> ## 🕐 **IL MOMENTO PEGGIORE DELLA GIORNATA È `17:05 → 19:00` ORA SERVER (`16:05 → 18:00` ora italiana): un'ora e cinquantacinque minuti in cui TUTTE E SEI possono avere una posizione aperta insieme.**
> Prima delle 17:05 il massimo teorico è **quattro** (`770511` · `771531` · `770411` · `770101`);
> dopo le 19:00 torna a **due** (le due senza orario).

## 3.2 🔢 IL MARGINE PER SEDIA — rifatto **da capo**, non riscalato

**Formula, tutta in EUR** (il broker fornisce `Margine1Lotto` e `TickValue` **già in valuta conto**):
`lotti = (2,00% × 80.000) ÷ (stop × valore_punto)` · `margine = lotti × Margine1Lotto`

**Valore punto per lotto, dal CSV** (`TickValue ÷ TickSize`): `GER40` **1,000 EUR/punto** ·
`US30` e `US100` **0,871 EUR/punto** · `XAUUSD` **87,061 EUR** per dollaro d'oro.
**Stop**: quelli dell'ipotesi **H4** del pacchetto di schieramento (§2.0), con le sue etichette.

| sedia | simbolo | **stop** | etichetta stop | lotti @2,00% | **margine (EUR)** | **% del conto** | `margine ÷ rischio` |
|---|---|---:|---|---:|---:|---:|---:|
| `770101` DAX Apertura | `GER40` | 71,9 pt | 🟢 `[MISURATO]` | 22,253 | **11.265** | **14,08%** | 7,04× |
| `770411` MaxMin DAX Short | `GER40` | 75,85 pt | 🔴 `[NON MISURATO]` (centro banda 64,2-87,5) | 21,094 | **10.679** | **13,35%** | 6,67× |
| `770202` Dow Apertura | `US30` | 123,8 pt | 🟢 `[MISURATO]` | 14,838 | **13.367** | **16,71%** | 8,35× |
| `771531` EMA200 | `US30` | 104,3 pt | 🟢 `[MISURATO]` | 17,612 | **15.866** | **19,83%** | 9,92× |
| `770511` SuperWave | `US30` | 77,1 pt | 🟢 `[MISURATO]` | 23,826 | 🔴 **21.464** | 🔴 **26,83%** | 🔴 **13,41×** |
| `770260` Nasdaq RETEST | `US100` | 83,2 pt | 🔴 `[INFERITO]` | 22,079 | **11.414** | **14,27%** | 7,13× |
| **TOTALE SEI, tutte aperte insieme** | | | | | 🔴 **84.055** | 🔴 **105,07%** | |
| *(`770402` ORO, **NON schierata**)* | `XAUUSD` | 32,94 $ | 🟢 `[MISURATO]` | 0,558 | *4.253* | *5,32%* | *2,66×* |

🟢 **Controprova incrociata**: riscalando la tabella del `DD_PORTAFOGLIO` (1:15 → 1:50, conto
100.000 $) viene **107,3%**. Rifacendo il conto **da capo** sul conto vero in EUR viene
**105,07%**. 🎯 **Due strade, scarto del 2%** — che è il cambio e la data dei prezzi. Se avessi
sbagliato il metodo, lo scarto non sarebbe del 2%.

> ## 🔴 **LA COLONNA CHE NESSUNO AVEVA MESSO IN TABELLA: `margine ÷ rischio`, e va da 2,66× a 13,41×.**
> Due sedie che rischiano **gli stessi 1.600 EUR** immobilizzano **4.253** e **21.464** euro di
> margine: **cinque volte tanto**. 👉 **La sedia più cara in margine NON è la più rischiosa**: lo
> stop stretto di `770511` (77,1 punti sul Dow) la rende la più pesante in margine **proprio
> perché** è la più efficiente in rischio. **Classe 644.**

## 3.3 📈 LA CUMULATIVA — in ordine di armamento, con il margine libero

| # | sedia (in ordine di armamento) | margine | **cumulato** | **% conto** | **libero** | rischio aperto cum. | margin level |
|---|---|---:|---:|---:|---:|---:|---:|
| 1 | `770511` SuperWave | 21.464 | 21.464 | 26,83% | 58.536 | 2,00% | 372,7% |
| 2 | `771531` EMA200 | 15.866 | 37.330 | 46,66% | 42.670 | 4,00% | 214,3% |
| 3 | `770411` MaxMin DAX | 10.679 | 48.009 | 60,01% | 31.991 | 6,00% | 166,6% |
| 4 | `770101` DAX Apertura | 11.265 | 59.275 | 74,09% | 20.725 | 8,00% | 135,0% |
| 5 | `770202` Dow Apertura | 13.367 | 72.642 | 90,80% | **7.358** | 10,00% | 110,1% |
| 6 | `770260` Nasdaq RETEST | 11.414 | 84.055 | 🔴 **105,07%** | 🔴 **−4.055** | 12,00% | 95,2% |

> ## 🔴 **IL SESTO ORDINE NON ENTRA: servono 11.414 EUR e ne restano 7.358.** `not enough money`, una riga di Giornale e nessuna posizione.
> 🔴 **E il sesto è `770260`, che arma nello stesso minuto di `770202`**: quale dei due viene
> rifiutato **non è deciso da noi**, è una corsa fra due EA. ⚪ **Chi arriva secondo è
> `[NON MISURATO]`** e non si può misurare da qui.

**Il numero simmetrico, che è quello utile a Claudio**: perché **tutte e sei** stiano dentro
80.000 EUR di margine serve una taglia **≤ 1,904%** (a 1,90% il margine è 79.853 EUR = **99,82%**).
🔴 **Questo è un FATTO, non una proposta**: non sto chiedendo di cambiare la taglia.

---

# 4️⃣ 🧱 I QUATTRO MURI — **quale morde per primo, col numero**

## 4.1 Le soglie, lette alla fonte

| muro | valore | dove l'ho letto |
|---|---:|---|
| **C1 · cap rischio aperto** | **4,00%** | `mql5/Presets/ABTG_Guardian_FTMO_2Step.set` → `InpMaxOpenRiskPct=4.00`. 🔴 **Non è il 3,25% della firma del 18/08**: sul preset FTMO è stato portato a 4,00 |
| **B1 · pausa morbida** | **3,5%** di perdita giornaliera | stesso file, `InpDailyPausePct=3.5` |
| **emergenza giornaliera** | **4,5%** | stesso file, `InpDailyLossPct=4.5` · `InpAction=0` · `InpCloseAllMagics=true` |
| **DD totale del Guardian** | **9,3%** statico dal saldo | stesso file, `InpTotalDDPct=9.3` · `InpDDMode=0` |
| **muro prop GIORNALIERO** | **5,00%** | regolamento FTMO |
| **muro prop STATICO** | **10,00%** | regolamento FTMO |
| **margine** | 80.000 EUR | §3.3 |

🔎 **E il confronto del C1 è `>=`**, letto nel codice (`ABTG_Guardian.mq5` r.789:
`if(InpMaxOpenRiskPct>0 && riskPct>=InpMaxOpenRiskPct)`). Quindi con due sedie aperte a 2,00%
il rischio è **esattamente 4,00%** e il cap **scatta**.

## 4.2 🔴 LA TABELLA CHE RISPONDE ALLA DOMANDA — quante sedie aperte **insieme** prima che ciascun muro sia toccato

*(caso peggiore dichiarato: tutte le posizioni aperte vengono stoppate lo stesso giorno. È il caso
che i muri prop misurano.)*

| taglia per sedia | **C1 4,00%** | **muro giorno 5%** | **muro statico 10%** | **margine** |
|---:|---:|---:|---:|---:|
| 0,65% | 7 | 7 | 15 | 6 |
| 1,00% | 4 | 5 | 10 | 6 |
| 1,30% | 4 | 3 | 7 | 6 |
| 1,50% | 3 | 3 | 6 | 6 |
| 1,90% | 3 | 2 | 5 | 6 |
| 🔴 **2,00% ← la taglia di oggi** | **2** | 🔴 **2** | **5** | **5** |

> ## 🎯 **LA RISPOSTA, IN UN NUMERO: alla taglia di oggi (2,00%) le sedie che possono stare APERTE INSIEME sono DUE.**
> E il muro che morde per primo è **il giornaliero del 5%**: alla **terza** sedia aperta insieme
> il caso peggiore vale **6,00% > 5,00%** — **challenge fallita in un giorno solo**.
> 🔴 **Il margine è l'ULTIMO dei quattro**: arriva alla **sesta**.
>
> 🔴 **Ed è esattamente il ribaltamento che la correzione della leva produce.** Prima di stamattina
> i referti mettevano il margine **primo** (*«si crede di correre con sette sedie e si corre con
> tre»*). A 1:50 il margine è l'ultimo, e il primo è il muro che **uccide davvero** — quello
> **giornaliero**, che nelle nostre simulazioni fallisce **18,2%** delle volte contro l'**11,5%**
> dello statico (`report/CACCIA_MECCANISMI_2026-09-23.md` r.274 e r.371).

## 4.3 🟢 LA NOTIZIA BUONA, ed è misurata

Il Guardian **interviene prima di tutti e due i muri prop**: pausa morbida a **3,5%**, chiusura
d'emergenza a **4,5%** con `InpCloseAllMagics=true`, DD totale a **9,3%** contro il 10%. 🟢 **I
margini di sicurezza ci sono, e sono scritti nel preset.**
🔴 **Ma il Guardian misura una perdita che è già successa**: con tre sedie aperte insieme a 2,00%
e tre stop presi **nello stesso minuto** (apertura US, gap di news) la perdita arriva a 6,00% **in
un colpo**, e non c'è nessuna soglia intermedia da cui passare. ⚪ **Quanto spesso tre sedie siano
davvero aperte insieme è `[NON MISURATO]`** — vedi §6.2.

---

# 5️⃣ 🔴 IL BUCO CHE HO TROVATO: **il C1 non vede gli ordini PENDENTI**

## 5.1 Il fatto, letto nel codice

`ABTG_Guardian.mq5` r.385, funzione `OpenRiskPct()`: il giro è
**`for(int i=PositionsTotal()-1; ...)`**. 🔴 **Conta le POSIZIONI. Non guarda `OrdersTotal()`.**

E l'include lo dichiara per iscritto (`mql5/Include/ABTG_PausaGuardian.mqh`, intestazione):
> *«**NON e' un cap istantaneo sul rischio**: un ordine PENDENTE gia' piazzato quando il cap era
> libero scattera' lo stesso. Questa e' una guardia sull'AGGIUNTA di rischio.»*

## 5.2 🔴 Perché su QUESTA flotta la cosa morde per davvero

**Tutte e sei le sedie entrano con ordini pendenti**, verificato nei sorgenti:

| sedia | come entra | riga |
|---|---|---|
| `770101` · `770202` · `770260` (famiglia Apertura) | `BuyStop` / `SellStop` | `ABTG_DAX_Apertura_EU.mq5` r.1211, r.1235 |
| `770411` MaxMin | pendenti piazzati a `InpPlaceHour` | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` |
| `771531` EMA200 | **due** ordini limite (`InpUseOrder2=true`) | `ABTG_EMA200_Ottimizzato.mq5` r.413-420 |
| `770511` SuperWave | `InpUsePending=true` | preset FTMO |

E la guardia è chiamata **immediatamente prima di PIAZZARE il pendente**
(`ABTG_DAX_Apertura_EU.mq5` r.1194, subito sopra il `BuyStop` di r.1211) — che è **giusto** secondo
la regola dell'include, ma vuol dire che il C1 viene valutato **ore prima** che il rischio diventi
reale.

> ## 🔴 **CONSEGUENZA, e va detta netta: il C1 al 4,00% NON garantisce che il rischio aperto resti sotto il 4,00%.**
> Ogni sedia supera il cancello **quando piazza il pendente**, cioè in **cinque momenti diversi
> della giornata** (09:00 · 10:35 · 17:05 · e in qualunque momento per le due H1). In ciascuno di
> quei momenti il rischio **già aperto** può essere sotto il 4,00% e il cancello **passa**. Poi i
> pendenti scattano, e il rischio simultaneo può arrivare a **12,00%**.
> 🟢 **Quello che il C1 fa davvero, e lo fa bene**: impedisce di **aggiungere** un pendente quando
> c'è già tanto rischio **aperto**. È una guardia utile. **Non è un tetto.**
> 👉 **Il tetto duro che resta in piedi su questa flotta è il MARGINE** (§3.3) — cioè proprio quello
> che avevamo appena declassato a ultimo muro. **Le due cose vanno lette insieme.**
> 📌 **Classe 645.**

🟢 **E la controprova empirica che ridimensiona l'allarme, perché va detta**: su **57 ingressi
veri** misurati il 12/09 il picco di rischio aperto è stato **1,300%** a taglia 0,65%, cioè **due
posizioni**, con **zero** superamenti (`report/IL_GUARDIAN_CHE_SCHIEREREMO_2026-09-12.md` r.230).
🔴 **Ma quella misura è di un'altra flotta** (due sedie, altro conto, altra taglia) e **non
risponde** alla domanda su sei sedie a 2,00%. È un indizio, non una prova.

---

# 6️⃣ 📊 QUANTE SEDIE IN PIÙ CI STANNO — e la risposta onesta

## 6.1 Per MARGINE

Al picco **realmente osservato finora** (2 posizioni insieme), le due più care sono `770511` e
`770202`: **34.831 EUR = 43,54%** del conto. 🟢 **Margine libero: 45.169 EUR = 56,46%.**

Quante sedie in più ci stanno in quei 45.169 EUR? Dipende dal loro `margine ÷ rischio`, che su
questa flotta va da **6,67×** a **13,41×**. A 2,00% per sedia:
- con un `k` da **7×** (tipo `770101`/`770260`): **~4 sedie** in più;
- con un `k` da **13×** (tipo `770511`): **~2 sedie** in più.

🔴 **E questo è il conto del MARGINE, che è l'ultimo dei quattro muri.**

## 6.2 🔴 Per RISCHIO — e qui la risposta cambia del tutto

Aggiungere sedie **non costa margine: costa muro giornaliero**. Alla taglia di oggi:
- **2 sedie aperte insieme** = 4,00% di rischio → 🟢 sotto il 5% giornaliero;
- **3 sedie aperte insieme** = 6,00% → 🔴 **sopra**.

> ## 🎯 **QUINDI: alla taglia di oggi NON c'è spazio per nessuna sedia in più che possa essere APERTA INSIEME alle altre due. Il margine libero c'è (56%); il muro giornaliero no.**
> 🟢 **Ma c'è spazio per sedie che armano in ORARI DIVERSI** — e quello è un posto vero, che non
> costa niente a nessun muro. La finestra libera più larga è **19:00 → 09:00 ora server**
> (`18:00 → 08:00` ora italiana): in quelle ore hanno una posizione aperta **solo** `770511` e
> `771531`, e la sessione asiatica **non è presidiata da nessuno**.
> ⚪ **Quanto spesso `770511` e `771531` siano DAVVERO aperte di notte è `[NON MISURATO]`**: si
> misura contando le posizioni vive per ora nei loro CSV, e **non l'ho fatto**.

## 6.3 🔴 Il conto che NON ho fatto, e che serve prima di qualunque decisione

**La distribuzione vera del numero di sedie aperte insieme**, ora per ora, misurata sui backtest
appaiati delle sei sedie. 🔴 **Tutto questo referto ragiona sul caso PEGGIORE (tutte aperte, tutte
stoppate lo stesso giorno)**, che è il caso che i muri prop misurano — ma **non è il caso medio**,
e la differenza fra i due decide se c'è posto per una settima sedia o no.
⚪ **Costo per chiuderlo**: **zero passate** (i CSV per-trade ci sono per alcune sedie) ma un
lavoro di incrocio dei per-trade che **non ho fatto** e che **non stimo**, perché non ho
verificato quali sedie abbiano il per-trade salvato.

---

# 7️⃣ 📋 I CANDIDATI PRONTI A OCCUPARE UN POSTO — stato reale, **niente promozioni**

🔴 **Nessuno di questi è pronto oggi.** Porto lo stato e il costo, non un giudizio.

## 7.1 🟡 I vicini — hanno numeri, manca un pezzo

| # | candidato | simbolo / TF | numeri misurati | 🔴 che cosa MANCA | costo per chiuderlo |
|---|---|---|---|---|---|
| **1** 🥇 | **Dow Apertura *BREAKOUT A DUE LATI*, range 15'** (`770201`) — **altro motore** da `770202` | `U30USD` M5 | PF OOS **1,267-1,560**, mediana **1,373**, 🟢 **40/40 celle ≥1,10**; DD max **8,70%** @1%; **n 188 posizioni**; **0,720 pos/g** | 🔴 l'**IS parte dal 2024.01.01**, cioè **prima** del pavimento tick BCM sugli indici (2024.09.26): ✏️ *corretto 24/09*: qui c'era *"~9 mesi su 18 sono tick generati"*, **falso** — prima del 26/09/2024 BCM **non ha nessun dato** (commit `2f4c95ae`: `SERIES_SERVER_FIRSTDATE` = 2024.09.26), quindi l'IS reale parte comunque da lì ed è **più corto** di quanto dichiarato (~9 mesi, non 18), non sporco. R245 lo rigira da `2024.09.26` dichiarato · il **DD alla taglia 2,00%** · la **sovrapposizione con `770202`** (stesso indice, stessa apertura) mai misurata | **80 passate ≈ 6,8 min**, rigirando l'IS da `2024.09.26` |
| **2** 🥈 | `ABTG_ORB_Ottimizzato` **LONG** | `U30USD` M5 | PF OOS **1,657-1,955** (med. 1,736); DD **9,92-11,04%** @1%; **0,449 pos/g** | 🔴 **campione: n 119 < 150** · DD alla taglia vera (≈19,8-22,1% @2%, **stima**) · l'asse `InpTPRangeMult` è **al bordo** (PF sale monotono fino a 3,0) | `R211a` **già scritto**: **8 passate ≈ 1,2 min** + **4 passate** per estendere l'asse a 3,5/4,0 |
| **3** | `ABTG_ORB_Ottimizzato` — **gemello DAX mai provato** | `D30EUR` M5 | `[NON MISURATO]` | **tutto**: il simbolo non è mai stato girato con questo motore | `R211b` **già scritto**, mai eseguito — costo `[NON STIMATO]` nel referto d'origine |
| **4-7** | `ABTG_EMA200` **H4 a DUE LATI** | `GBPUSD` · `AUDJPY` · `GBPJPY` · `XAUUSD` H4 | finestra unica: PF **1,231 / 1,514 / 1,240 / 1,381**; **362 / 265 / 221 / 187 deal**; DD **7,21 / 6,26 / 4,42 / 6,15%** @1% | 🔴 **non hanno un OOS**: finestra unica e ottimizzatore **genetico** → quei PF sono **in-campione per costruzione** · `n` in **posizioni** è derivato · su `AUDJPY` il **costo R5 è `[NON MISURATO]`** · su `XAUUSD` la sovrapposizione con `770402` | **48 / 56 / 38 / 58 passate** ≈ **4,3 / 4,9 / 3,5 / 5,1 min** |
| **8** | `ABTG_CostToCost` | `EURJPY` H4 | PF OOS **1,523** · n **242** · DD **12,26%** @1% | 🔴 **il tappo non è il DD: è la PEGGIOR GIORNATA**, **−8,02%** (OOS) e **−10,07%** (ORSO 2022) contro il muro **giornaliero del 5%**. 🟢 Esiste un **meccanismo** (`InpExitMode` 0/1) che tiene la giornata dentro il 5%, misurato su **864 celle** — ma costa **−49,8% di profitto** · ✏️ *corretto 24/09*: quella colonna parte dall'**equity al primo tick del giorno BCM**, FTMO dal **balance delle 00:00 italiane** in % del capitale iniziale: su un H4 che tiene la notte sbaglia in tutte e due le direzioni. **Il tappo vale per il Guardian in campo; per il muro FTMO è `[NON DIMOSTRATO]`** — colonna FTMO in costruzione nell'EA | **12 passate, tetto 18 minuti** — i due file prova sono **già pronti in repo** (`R214e`, `R214f`) |

## 7.2 🪦 Quelli con il certificato di morte già scritto

| candidato | numero | perché è chiuso |
|---|---:|---|
| `ABTG_MaxMinNotte` gemelli indici — `F40EUR` · `E50EUR` · `100GBP` | PF max **0,999 / 0,840 / 0,672** su **54 celle** ciascuno | 🪦 **nessuna cella arriva a 1,00**, figurarsi a 1,10 |
| `ABTG_DAX_Apertura_EU` gemello **CAC** `F40EUR` | PF **0,770**, n 195, DD 11,82% @1% | 🪦 `R138a` è **girato**: profitto **−7.266,30** |
| `ABTG_ORB_Ottimizzato` SHORT / due lati `U30USD` | PF **0,520** / **1,048**, DD **26,4%** / **17,2%** | 🪦 è **la via ai 150 che non esiste** |
| `ABTG_Nasdaq_Live5m` · `ABTG_DAX_Live5m` | a tick: **0,963 / 0,925 / 0,857** | 🪦 il PF alto del censimento era un **artefatto OHLC** |

## 7.3 ⚪ Quelli che non sono né vivi né morti

- **`ABTG_Londra_ORB`**: 🔴 **non ha MAI avuto un CSV** (riverificato il 23/09 da `R231`), e la
  sua unica misura ha guardato **le 07:00 mentre Londra apre alle 08:00 server BCM**. Verdetto:
  **`[NON ANCORA MISURATO]`**, non *morto*. Costo: `[NON STIMATO]` — manca perfino un file prova.
- **Le tre PostNews** (`771202` · `771203` · `771204`): schierate, capaci, **mute**. Non occupano
  nessun posto e non ne liberano nessuno.
- **`770402` MaxMin ORO**: preset pronto a 2,00%, **non schierata**, e in **revisione** per un DD
  del **19,72%** @1% su 22 anni. Se rientrasse costerebbe **4.253 EUR** di margine (**5,32%**) e
  **2,00%** di rischio — 🔴 cioè **il terzo posto**, quello che sfonda il muro giornaliero.

---

# 8️⃣ 🧪 I CONTRO-ESEMPI, costruiti PRIMA di consegnare

| ipotesi che mi smentirebbe | verifica | esito |
|---|---|---|
| **«il margine non è nozionale/leva, è fisso per lotto: i tuoi rapporti sono coincidenze»** | tre contract size (`1`, `100`, `100.000`), due valute, cinque simboli → **un solo cambio implicito 1,1486** e il simbolo EUR che fa **50,000 esatto senza cambio** | 🔴 **smontata** (§1.3) |
| **«hai solo riscalato i numeri vecchi di 3,33: non hai misurato niente»** | il conto del §3.2 parte da `Margine1Lotto` e `TickValue` **del broker** e dal conto **vero in EUR**; il riscalamento dà **107,3%**, il conto da capo **105,07%** | 🔴 **smontata**: due strade indipendenti, scarto 2% |
| **«dici che il C1 limita a 2 sedie, quindi il margine non si tocca mai: il §3.3 è teoria»** | il C1 conta **`PositionsTotal()`**, non `OrdersTotal()`, e **tutte e sei** le sedie entrano per pendente | 🟢 **regge, ed è il motivo per cui il §3.3 NON è teoria** (§5) |
| **«il muro giornaliero al 5% non si tocca: le sedie sono scorrelate»** | le correlazioni misurate sono **−0,01…+0,13** (`DD_PORTAFOGLIO` §6) — 🟢 **vero, e gioca a favore** | 🟠 **regge in media, non nel caso peggiore**: `770202` e `770260` armano **nello stesso minuto** sulla **stessa apertura US**, che è il momento in cui due indici americani sono **meno** scorrelati |
| **«la taglia è ancora quella mista, stai correggendo una tabella con un'altra tabella vecchia»** | letti i **dieci** `.set` uno per uno il 23/09: sette a `2.00`, tre a `1.30`, **zero** a 0,65 o 1,00 | 🔴 **smontata** (§2) |

---

# 9️⃣ 🕳️ CHE COSA **NON** HO COPERTO — elencato per nome, mai per differenza

1. **La specifica di contratto FTMO letta a schermo** (*Specification* → *Initial margin*). Il
   1:50 resta una **deduzione** verificata cinque volte, non una riga letta. `[NON LETTO]`
2. **Lo stop di `770411`** è `[NON MISURATO]`: uso il centro della banda 64,2-87,5. Il suo margine
   (10.679 EUR) può oscillare **±17%**.
3. **Lo stop di `770260`** è `[INFERITO]`. Stesso caveat.
4. **Il margine dei tre PostNews**: `[NON CALCOLATO]`. `EURUSD` non è nel CSV delle specifiche.
5. **La distribuzione vera di quante sedie sono aperte insieme, ora per ora**: `[NON MISURATO]`.
   Tutto il §4 è sul **caso peggiore**. §6.3.
6. **Chi vince la corsa fra `770202` e `770260`** quando armano nello stesso minuto e il margine
   basta per uno solo: `[NON MISURATO]`, e da qui non è misurabile.
7. **Se il binario in campo sul terminale FTMO contiene davvero la guardia del Guardian**: ho letto
   **i sorgenti a HEAD**, non i `.ex5` in campo. La riga di verifica esiste
   (`report/BINARI_IN_CAMPO_FTMO_2026-09-21.md`) ma **non ho trovato in repo il suo output**.
   🔴 È lo stesso difetto che il 12/09 fece scoprire un `.ex5` di agosto senza Guardian.
8. **Il tempo per passata** dei round del §7 viene dai referti d'origine: non l'ho rimisurato.
9. **Le posizioni multiple per sedia**: `771531` apre **due** ordini limite e `770511` entra
   frazionato. Il **rischio totale** resta 2,00% (`riskPct = InpRiskPercent/nOrders`, r.414), ma il
   **margine** di due gambe con stop diversi **non è esattamente** quello di una gamba sola:
   `[NON CALCOLATO]`, e va nella direzione di **peggiorare** il 105,07%.
10. **Il corto Nasdaq** e il suo file prova: **non l'ho toccato**, è di `R231`.
11. **`ABTG_HVAncora`**: l'ho visto nella lista dei candidati e **non l'ho approfondito**.

---

# 🔟 📌 LE CLASSI NUOVE

Tre, numerate col grep fatto **al momento di scrivere** (`CLASSE 6xx` repo-wide si fermava a
**642**): **643**, **644**, **645**. Testo esteso in
`backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`.

---

# 1️⃣1️⃣ ✅ I TRE REFERTI CORRETTI — e il cancello prima/dopo

| file | dove ho inserito la nota | rilievi **prima** | rilievi **dopo** |
|---|---|---:|---:|
| `report/SCHIERAMENTO_FTMO_2026-09-20.md` | subito **prima** del §⑨ | 1 (classe 225, **7 righe**) | 1 (classe 225, **7 righe**) |
| `report/DD_PORTAFOGLIO_FTMO_2026-09-20.md` | subito **prima** del §5.3 | 1 (classe 225, **1 riga**) | 1 (classe 225, **1 riga**) |
| `report/PACCHETTO_SCHIERAMENTO_PROP_2026-09-21.md` | prima del riquadro §② **e** in testa al §② esteso | 1 (classe 225, **6 righe**) | 1 (classe 225, **6 righe**) |

🟢 **Zero difetti meccanici prima, zero dopo. Zero rilievi nuovi introdotti, e nemmeno una riga in
più sul conteggio della classe 225** — che è il controllo vero, perché quel rilievo conta *righe*,
non *file*.
🔴 **E in nessuno dei tre ho cancellato o riscritto un numero vecchio**: ogni nota porta il numero
vecchio, quello nuovo, la fonte della falsificazione, chi l'ha misurata, e **l'elenco per nome
delle conclusioni che cadono**.
