# 📦 PACCHETTO DI SCHIERAMENTO PROP — **si parte DOMENICA NOTTE 20/09/2026, FTMO**

**Scritto la notte del 19→20/09/2026** · branch `lavoro` ·
🚫 **SOLA LETTURA**: nessun EA, nessun preset, nessun forward, nessuna taglia toccata.
Conto reale **10105439** non toccato in nessun modo. Nessun round lanciato.
🚫 **Nessuna taglia scelta qui dentro**: `InpRiskPercent` resta **[NON DECISO da Claudio]**.

> ## 🔴 CAMBIO DI DATA — Claudio, 19/09 notte: *«Io pagherò la challenge e si inizia domani notte. Prepara tutto»*
> **Non è più lunedì mattina: è DOMENICA 20/09, alla riapertura dei mercati.**
> La finestra si accorcia di una notte, e il **cammino critico diventa l'installazione del
> terminale FTMO** — che oggi sul VPS **non esiste**. Cronologia con i minuti al **§Ⓐ**.

> ## 🎯 A COSA SERVE QUESTO FILE
> Domenica sera si apre questo, si parte dal **§Ⓐ CRONOLOGIA** (che dice *quando*) e si esegue
> il **§④ ORDINE DI ACCENSIONE** (che dice *come si verifica*). Tutto il resto è il **perché**
> dei numeri che stanno lì dentro.

---

# ⓪ 🔴 LE RIGHE CHE CAMBIANO LA MATTINATA

> # 🟢 ZERO — **IN VALUTAZIONE NON SI APPLICA NIENTE. NÉ LE NEWS, NÉ LA NOTTE, NÉ IL WEEKEND.**
> Due schermate della **FAQ ufficiale FTMO in italiano**, mandate da Claudio il **19/09 alle
> 23:01-23:02** — 🥇 **[POSTATO DA CLAUDIO]**, il rango più alto che abbiamo su questa materia:
> - *«Le restrizioni al trading durante la pubblicazione di determinati comunicati stampa si
>   applicano **solo al conto Standard**. Il conto **Swing** non prevede restrizioni… Per i conti
>   Standard, queste restrizioni si applicano **solo dopo aver iniziato a fare trading su un conto
>   FTMO**. **Non si applicano durante il processo di valutazione**… indipendentemente dal tipo di
>   conto.»*
> - *«Le restrizioni relative alle **posizioni aperte durante la notte e nei fine settimana** si
>   applicano **solo al conto Standard**. Il conto **Swing** non prevede alcuna restrizione… Per i
>   conti Standard si applicano **solo dopo** aver iniziato su un conto FTMO. **Non si applicano
>   durante il processo di valutazione.**»*
>
> ## 👉 **Quindi da domenica notte NESSUNA delle sette sedie è toccata da una regola FTMO sulle news o sull'overnight. Nessuna.** Né le due che tengono posizioni di notte, né quelle che operano sui dati macro.
> 🟢 Conferma quello che avevamo già in casa dal 13/08 (`docs/REGOLAMENTO_FTMO_2026-08.md` **r.45**),
> **ma ora con una seconda restrizione che non avevamo messo a fuoco** (notte/weekend) e con una
> fonte di rango superiore. Il problema nasce sul **conto finanziato**, cioè fra settimane — ed è
> lì che si decide **adesso** Standard o Swing (§⑤bis).

> ## ① ⏰ **L'OROLOGIO DI FTMO NON È QUELLO DI BCM: È AVANTI DI DUE ORE.**
> BCM = ora italiana **−1**. FTMO = **GMT+2 inverno / GMT+3 estate** = ora italiana **+1**
> (`docs/REGOLAMENTO_FTMO_2026-08.md` **r.130**, testuale: *«Diverso da BCM: FTMO server = ora
> italiana +1 (es. DAX apre 10:00 ora server FTMO), da RIMAPPARE in tutti gli .ini!»*).
> 👉 **Ogni `InpSessionHour`, `InpBoxStartHour`, `InpPlaceHour`, `InpCloseHour` dei nostri preset
> va aumentato di 2 su FTMO.** Un preset caricato com'è oggi fa aprire il DAX alle **06:00**
> di mercato reale invece che alle 08:00, e il Dow alle **12:30** invece che alle 14:30.
> 🔴 **Questa non è un'ipotesi di rischio: è una certezza aritmetica se nessuno rimappa.**
> ⚠️ Etichetta della fonte: **[LETTO-VIA-SEARCH, 13/08]**, non verificata a terminale.
> **Si chiude in 10 secondi domenica sera**, appena fatto il login: orologio di Market Watch contro orologio di Windows (§④ passo 4).

> # ✏️🔴 NOTA DI CORREZIONE AL §② — **23/09/2026, sessione `R232`** · *il riquadro qui sotto NON è stato riscritto*
>
> 🔴 **LA COLONNA GIUSTA DEL §② È `1:50`, NON `1:15`. La leva indici di questo conto è MISURATA, e
> vale 1:50.** Il titolo *«A leva 1:15 le sette sedie non entrano»* parte da un'ipotesi
> **falsificata**: a 1:50 **entrano tutte e sette** — **36,6%** del conto a 0,65% e **56,3%** a 1,00%
> (la colonna in corsivo del §② era già quella giusta, ed era relegata a un *«se fosse»*).
>
> - **chi l'ha misurata**: `R229` (`report/LA_LEVA_E_1_50_2026-09-23.md`, commit `36b7e9e5`),
>   riverificata e allargata a **cinque simboli** da `R232`
>   (`report/QUANTE_SEDIE_CI_STANNO_2026-09-23.md` §1);
> - **fonte**: `backtest_pipeline/risultati_prove/PREVOLO_FTMO_specifiche_2026-09-20.csv`, colonna
>   **`Margine1Lotto`** = **`OrderCalcMargin()`** — **il conto lo fa il broker**;
> - **la prova**: `GER40.cash` quota in EUR e paga margine in EUR → `25.312,17 / 506,24 =`
>   **`50,000` esatto, senza cambio di mezzo**. `US30.cash`, `US100.cash` e `XAUUSD` danno **lo
>   stesso identico rapporto `57,428` = 50 × 1,1486**, con contract size **1 · 1 · 100**. `USDJPY`
>   dà **`114,855` = 100 × 1,1486**: il **forex è 1:50 × 2 = 1:100**, gli indici e l'oro 1:50.
>
> ## 🟢 E CADE ANCHE L'ETICHETTA `[INFERITO]` CHE PESAVA SU TUTTO IL §②
> L'ipotesi **H2** (*«margine = nozionale / leva»*) è marcata `[INFERITO]` in ogni cella del §②,
> con la nota *«non abbiamo mai letto una specifica di contratto FTMO»*. 🟢 **Adesso H2 è
> MISURATA**: cinque simboli, tre contract size diverse (`1`, `100`, `100.000`), due valute di
> quotazione, **un solo cambio implicito (1,1486)**. 👉 **Le celle del §② smettono di essere
> `[INFERITO]` e diventano derivazioni da un margine misurato.**
>
> ## 🔴 LE CONCLUSIONI DEL PACCHETTO CHE CADONO — dette per nome
> 1. 🔴 **CADE** il titolo del §② e la frase *«la scelta Standard-vs-Swing è la scelta che decide
>    se la rosa esiste»*: la rosa esiste, e il margine non la decide.
> 2. 🔴 **CADE, alle taglie di cui parla il pacchetto (0,65-1,00%)**, il §③ *«il 4°, 5°, 6° ordine
>    viene RIFIUTATO per margine insufficiente… si crede di correre con sette sedie e si corre con
>    tre»*. 🟠 **Non cade in assoluto**: alla taglia **2,00%** che i preset portano **oggi** —
>    riletta da `R232` nei dieci `.set` di `mql5/Presets/FTMO/`, **sette a `2.00`** e tre PostNews a
>    `1.30`, **nessuno a 0,65 e nessuno a 1,00** — il margine torna a mordere, ma al **sesto**
>    ordine: sei sedie aperte insieme chiedono **105,07%** del conto.
> 3. 🟢 **RESTA VERO** il §③ nella parte che conta davvero: **lo stop-out per margine è
>    irraggiungibile** perché i muri prop brecciano prima. A maggior ragione a 1:50.
> 4. 🔴 **E si ribalta l'ordine dei muri.** Il pacchetto mette il margine per **primo**. A 1:50 è
>    **l'ultimo**: a 2,00% per sedia il muro **giornaliero del 5%** è toccato dalla **terza** sedia
>    aperta insieme, lo **statico 10%** dalla **quinta**, il **margine** dalla **sesta**
>    (`R232` §3).
>
> 🔴 **Da leggere prima di tutto il resto: una leva più alta vuol dire più SPAZIO, non meno
> RISCHIO.** Nessuna taglia, nessuna sedia in più e nessun parametro di rischio sono autorizzati da
> questa nota. Restano **firma di Claudio**.


> ## ② 🔢 **A LEVA 1:15 LE SETTE SEDIE NON ENTRANO: SERVONO 121.894 $ DI MARGINE SU UN CONTO DA 100.000, E QUELLO È IL CASO *PIÙ ECONOMICO* (taglia 0,65%).**
> A 1,00% servono **187.529 $**. A 1,30% **243.788 $**.
> 🟢 A **1:50** (che è la leva indici del conto **Standard**) le sette entrano tutte a qualunque
> taglia fino all'1,00% (**56.259 $ = 56%**).
> 👉 **La scelta Standard-vs-Swing non è una scelta di regole news: è la scelta che decide se la
> rosa esiste.**
>
> ### 💰 LA TABELLA IN UNO SCHERMO — margine totale delle **sette** sedie, conto 100.000 $
> | taglia ↓ · leva → | **1:15** *(Swing)* | **1:25** | **1:30** | *1:50 (Standard)* |
> |---|---:|---:|---:|---:|
> | **0,65%** | 🔴 **121.894 (121,9%)** · **3 sedie** | 🟠 73.136 (73,1%) · 5 | 🟠 60.947 (60,9%) · 6 | 🟢 ***36.568 (36,6%) · 7*** |
> | **1,00%** | 🔴 **187.529 (187,5%)** · **2 sedie** | 🔴 112.518 (112,5%) · 4 | 🟠 93.765 (93,8%) · 4 | 🟢 *56.259 (56,3%) · 6* |
> | **1,30%** | 🔴 **243.788 (243,8%)** · **2 sedie** | 🔴 146.273 (146,3%) · 3 | 🔴 121.894 (121,9%) · 3 | 🟠 *73.136 (73,1%) · 5* |
>
> *(«· N sedie» = quante entrano tenendosi sotto il **50% del conto**, cioè con margin level ≥ 200%.
> Ipotesi, fonti e contro-esempio: §②. Ogni cella è `[INFERITO]` finché non arriva lo screenshot
> delle specifiche di contratto.)*

> ## ③ 🎯 **E IL DANNO DEL MARGINE NON È LO STOP-OUT — è l'ORDINE RIFIUTATO, silenzioso.**
> Contraddico qui la tesi di partenza, e coi numeri: lo stop-out MT5 scatta a **margin level 50%**,
> cioè quando l'equity scende sotto **metà** del margine impegnato (≈ **−54%** di conto). Il muro
> FTMO **statico al 10%** (`docs/REGOLAMENTO_FTMO_2026-08.md` · tabella muri in
> `report/LE_PROP_E_GLI_EA_COSA_SAPPIAMO_2026-09-19.md` §2.3) **breccia il conto molto prima**:
> lo stop-out per margine è **irraggiungibile**.
> 🔴 **Quello che succede davvero è che il 4°, 5°, 6° ordine della giornata viene RIFIUTATO per
> margine insufficiente** (`not enough money`) — e a essere rifiutate sono **sempre le stesse**:
> le sedie che armano **più tardi**, cioè le americane (`770202`, `771531`, `770511`, Nasdaq),
> perché le europee (`770402` alle 07:00, `770101` alle 08:00) il margine se lo sono già preso.
> 👉 **Risultato: si crede di correre con sette sedie e si corre con tre, senza che nessuno se ne
> accorga**, perché un ordine rifiutato non lascia una posizione: lascia una riga di Giornale.

---

# Ⓐ ⏱️ LA SERA DI DOMENICA — cronologia, coi minuti

## A.1 🟢 PRIMA DI TUTTO, LA COSA CHE TOGLIE ANSIA — **ed è MISURATA**

> ## 🟢 **DOMENICA SERA NON SI OPERA: SI ACCENDE IL CONTO.**
> Contato su **96 posizioni vere** della rosa in `data/statements/trades_auto.csv`:
> **nessuna sedia della rosa ha MAI aperto niente di domenica. Zero volte.**
> Le prime aperture vere dopo un weekend cadono **lunedì**, e la rosa ha appuntamenti precisi:
> `770402` ORO alle **07:00** (10 volte su 11), `770101` e `770411` alle **08:00**,
> `770202` alle **14:30-15:00**.
> 👉 **Se domenica sera il conto è acceso e i preset sono giusti, la prima operazione che conta
> arriva lunedì mattina.** C'è tutta la notte di margine.

🔴 **MA con due eccezioni misurate, e sono le stesse due di sempre** — vedi §A.3.

## A.2 ⏱️ LA CATENA, passo per passo, col tempo che costa

🔴 **Il cammino critico è l'installazione**: sul VPS ci sono **SETTE cartelle dati** e
**nessuna è FTMO**. Tutto quello che c'è sotto va fatto **da zero**, la prima volta.

| quando | cosa | 🖥️ dove | chi | ⏱️ **[STIMA]** |
|---|---|---|---|---:|
| **appena possibile** | 💰 **comprare la challenge** e ricevere le credenziali per mail | browser | ✍️ Claudio | **5-20 min** *(dipende da FTMO, non da noi)* |
| ↓ | ⬇️ scaricare l'installer MT5 dalla dashboard FTMO e installarlo in **`C:\MT5_FTMO`** — 🔴 **non** dentro una cartella BCM | 🖥️ VPS | ✍️ Claudio | **10-20 min** |
| ↓ | 🔑 login col conto FTMO + attesa della sincronizzazione simboli | 🪟 terminale **FTMO** | ✍️ Claudio | **2-5 min** |
| ↓ | 🔴 **📸 le due letture che valgono tutta la notte**: orologio di Market Watch vs orologio di Windows, e **Specification** di US30 / GER40 / NAS100 / XAUUSD | 🪟 **FTMO** | ✍️ Claudio | **5 min** |
| ↓ | 📁 copiare **6 `.mq5` + `ABTG_Guardian.mq5`** in `MQL5\Experts` e **`ABTG_PausaGuardian.mqh`** in `MQL5\Include` | 🖥️ VPS | ✍️ Claudio *(a mano con Esplora Risorse)* | **5-10 min** |
| ↓ | 🔨 **sei F7** in MetaEditor | 🪟 **FTMO** | ✍️ Claudio | **10-20 min** 🔴 *senza tetto se uno fallisce* |
| ↓ | 📊 aprire **7 grafici**, simbolo + TF giusti | 🪟 **FTMO** | ✍️ Claudio | **10 min** |
| ↓ | ⚙️ caricare **7 preset** e 🔴 **rimappare a mano gli orari (+2h)** e la **taglia** | 🪟 **FTMO** | ✍️ Claudio | 🔴 **20-30 min — è il passo più lungo e il più facile da sbagliare** |
| ↓ | 🛡️ attaccare `ABTG_Guardian` col preset FTMO e `InpDailyResetHour` ricalcolato | 🪟 **FTMO** | ✍️ Claudio | **5 min** |
| ↓ | ▶️ **AutoTrading ON** + controllo delle faccine sui 7 grafici | 🪟 **FTMO** | ✍️ Claudio | **5 min** |
| | | | **TOTALE** | 🔴 **~75-125 minuti** *(un'ora e mezza / due ore)*, **più** il tempo d'acquisto |

> ## 🎯 **CI STA IN UNA SERA — ma solo se si comincia presto e se arriva il `.set` di `770260`.**
> 🔴 **Due cose possono far saltare la sera, e nessuna delle due dipende da Claudio:**
> **(1)** un **F7 che fallisce** — sei sorgenti su sei non sono **mai** stati compilati nella
> forma che va in campo; **(2)** il **`.set` di `770260` che non è in repo** (buco **B6**), e
> senza quello la settima sedia non si accende.
> 🟢 **E la buona notizia: se la sera va storta non si perde niente**, perché la prima operazione
> vera è lunedì alle 07:00-08:00. **La notte è un cuscinetto, non una scadenza.**

## A.3 🪤 LA RIAPERTURA DELLA DOMENICA — **zona grigia dichiarata, e due sedie ci passano dentro**

### La regola, testuale
Il **«gap trading»** sta fra le **Forbidden Trading Practices**, e quelle
🔴 **valgono SEMPRE — anche su Swing e anche in Challenge**
(`docs/REGOLAMENTO_FTMO_2026-08.md` **r.83**, nota finale). Non è come le news, che in
valutazione non si applicano.

> *«performing **gap trading** by opening simulated trades (i) **when major global news,
> macroeconomic events, or corporate reports or earnings are scheduled**…, or (ii) **two hours or
> less before a relevant financial market is closed for at least two hours**»*
> — e il nostro stesso dossier conclude (**r.83** e **r.149**):
> *«Letteralmente vieta aprire PRIMA della chiusura, non DOPO la riapertura; però FTMO etichetta
> il gap trading come "high-risk practice… due to increased volatility". **AMBIGUO per la nostra
> famiglia gap-fill: DA CHIEDERE PER ISCRITTO»* · *«SENZA risposta scritta del supporto, la
> famiglia gap-fill NON va caricata su FTMO.»*

### 🔎 Chi, della rosa, **può** aprire alla riapertura — verificato nei sorgenti E nel campo

| sedia | il codice glielo permette? | cosa ha fatto **davvero** in campo |
|---|---|---|
| `770101` DAX Apertura | ❌ no: `InpSessionHour=8` | 🟢 aperture solo alle **08-16**, mai prima delle 08 |
| `770411` MaxMin DAX Short | ❌ no: `InpPlaceHour=7:59` | 🟢 **tutte e 5** le aperture alle **08** |
| `770402` MaxMin ORO | ❌ no: `InpPlaceHour=7:00` | 🟢 **10 su 11** alle **07**, una alle 08 |
| `770202` Dow Apertura | ❌ no: `InpSessionHour=14:30` | 🟢 **tutte e 4** alle **15** |
| `770260` Nasdaq RETEST | ❌ no: `InpSessionHour=14:30` | ⚪ **[NON MISURATO]**, mai operata |
| 🔴 **`771531` EMA200 Dow** | ✅ **SÌ** — verificato: `CutoffCheck()` (r.446-453) **cancella i pendenti** dopo le 19:00, **non impedisce di entrare prima**. Nessun filtro sul giorno della settimana | 🔴 **lo ha già fatto**: **17/08 alle 01:21 e alle 02:41 server**, su `U30USD`. E il **lunedì è il suo giorno più operoso: 10 aperture su 21** |
| 🔴 **`770511` SuperWave Dow** | ✅ **SÌ, senza nemmeno una guardia** — `InpUseTimeWindow` ha **default `false`** (r.93) e **non è in nessun `.set`**: la finestra `0-24` è **inerte**, l'EA può entrare a qualunque ora, qualunque giorno | 🔴 **lo ha già fatto**: **31/08 alle 06:00** (×2) e **07/09 alle 05:00** (×2). Cluster di aperture alle **03-06**. E il **lunedì vale 8 aperture su 16, cioè metà** |

> ## 🔴 **Le due sedie che tengono posizioni di notte sono LE STESSE DUE che aprono all'alba del lunedì — e per tutte e due il LUNEDÌ è il giorno più operoso dell'anno (48% e 50% delle aperture contro un 20% atteso).**
> 🧪 **Contro-esempio, perché la concentrazione potrebbe essere un artefatto**: se fosse un caso di
> campione, le altre cinque sedie mostrerebbero lo stesso sbilanciamento. **Non lo mostrano**:
> `770101` apre su tutti i giorni in proporzione alle sue 39 posizioni, e `770411`/`770202`/`770402`
> non hanno **nemmeno una** apertura fuori dal loro orario fisso. 👉 **La concentrazione del lunedì
> è del meccanismo, non del campione** — ed è esattamente il meccanismo che FTMO chiama *gap trading*.

### 💡 LA MIA RACCOMANDAZIONE (è una raccomandazione, non un divieto — la firma è di Claudio)

> ## 🟠 **Tenere `770511` SuperWave SPENTA la prima notte, e accenderla lunedì mattina.**
> **Tre ragioni, in ordine di peso:**
> **(1)** è l'unica sedia della rosa **senza nessuna guardia oraria attiva** — la manopola che
> dovrebbe fermarla (`InpUseTimeWindow`) è a `false` per default e non sta in nessun preset:
> non è che *abbiamo deciso* di lasciarla libera, è che **nessuno l'ha mai accesa**;
> **(2)** è quella che **ha davvero aperto all'alba**, con le date in mano;
> **(3)** è anche la **più cara in margine** (29.901 $ a 0,65%/1:15, il 24,5% del totale): tenerla
> ferma la prima notte **libera margine** proprio quando il conto è più vulnerabile.
> 💸 **Il costo, detto onestamente**: SuperWave fa ~10,8 operazioni al mese e metà cadono di
> lunedì. Spegnerla una notte **può costare un'operazione**. **Non è gratis, ed è un cambio di
> frequenza, non una precauzione a costo zero.**
>
> 🟡 **Su `771531` EMA200 NON lo raccomando**, e dico perché: è l'unica sedia della rosa che passa
> **tutti** i cancelli alla lettera (PF OOS **1,52**, n **517**, **30/30 PASS** a walk-forward
> tick). Spegnere la sedia migliore per un'ambiguità di regolamento è un prezzo alto per una
> protezione che nessuno ci ha chiesto per iscritto. 👉 **Invece: si manda la domanda al supporto
> (è già scritta, buco B4) e si decide con la risposta in mano.**
>
> 🔴 **E la cosa onesta da scrivere per ultima: non c'è nessuna regola FTMO che vieti di aprire
> DOPO la riapertura.** La lettera parla di aprire **prima** di una chiusura. La zona grigia è lo
> **spirito** della clausola, non il testo. 👉 **Quindi questa è prudenza, non conformità** — e
> chi decide quanta prudenza comprare, al prezzo di un'operazione, è Claudio.

---

# ① 🪑 LA TABELLA DELLE SEDIE — chi si schiera

## 1.1 Identità, orari e preset

🔴 **Tre colonne di orario, e servono tutte e tre.** La colonna **BCM** è quella che i preset
portano scritta **oggi**; la colonna **FTMO** è quella che devono portare **domenica sera**.

| magic | EA (`.mq5`) | simbolo BCM | TF | preset (file in repo) | ora IT | **ora server BCM (preset di oggi)** | 🔴 **ora server FTMO (= BCM +2)** |
|---|---|---|---|---|---|---|---|
| **`770101`** | `ABTG_DAX_Apertura_EU` | `D30EUR` | **M5** | `mql5/Presets/sedie_piccolo/recupero2/sedia_ABTG_DAX_Apertura_EU_770101.set` | 09:00 → 18:30 | `InpSessionHour=8` `InpSessionMin=0` · `InpCloseHour=17:30` | **10:00** · chiusura **19:30** |
| **`770411`** | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` | `D30EUR` | **M15** | `.../sedia_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_770411.set` | box 00:00-05:59 · pend. 08:59 · cutoff 09:30 · chiusura 18:30 | box `23:00→04:59` · `InpPlaceHour=7:59` · cutoff `8:30` · close `17:30` | box **01:00→06:59** · pend. **09:59** · cutoff **10:30** · close **19:30** |
| **`770202`** | `ABTG_Dow_Apertura_US` | `U30USD` | **M5** | `.../sedia_ABTG_Dow_Apertura_US_770202.set` | 15:30 → 18:30 | `InpSessionHour=14` `InpSessionMin=30` · close `17:30` | **16:30** · chiusura **19:30** |
| **`771531`** | `ABTG_EMA200` | `U30USD` | **H1** | `.../sedia_ABTG_EMA200_771531.set` | cutoff 20:00 · ven. 21:00 | `InpCutoffHour=19` · `InpFridayCloseHour=20` (`InpFridayClose=false`) | cutoff **21:00** · ven. **22:00** |
| **`770511`** | `ABTG_SuperWave_DOW_H1_Ottimizzato` | `U30USD` | **H1** | `.../sedia_ABTG_SuperWave_DOW_H1_Ottimizzato_770511.set` | 24h | `InpStartHour=0` `InpEndHour=24` | **invariato** (è l'unica che non va rimappata) |
| **`770402`** | `ABTG_MaxMinNotte` | `XAUUSD` | **M15** | `mql5/Presets/sedie_piccolo/sedia_MAXMIN_ORO_770402.set` | box 00:00-05:59 · pend. 08:00 · cutoff 09:30 · chiusura 18:30 | box `23:00→04:59` · `InpPlaceHour=7:00` · cutoff `8:30` · close `17:30` | box **01:00→06:59** · pend. **09:00** · cutoff **10:30** · close **19:30** |
| **`770260`** ✅ **dentro (firma Claudio 19/09: *«Sì, dentro il 770260 RETEST»*)** | `ABTG_Nasdaq_Apertura_US` | `NASUSD` | **M5** *(da confermare nel `.set`)* | 🔴 **IL `.set` NON È IN REPO** — buco **B6**, ed è **bloccante** | 15:30 → 18:30 | `InpSessionHour=14` `InpSessionMin=30` · close `17:30` | **16:30** · chiusura **19:30** |
| **`779001`** | `ABTG_Guardian` *(utility, non trada)* | un grafico qualsiasi | — | `mql5/Presets/ABTG_Guardian_FTMO_2Step.set` | reset 01:00 IT | `InpDailyResetHour=23` (= 00:00 CEST) | 🔴 **`=1`** (00:00 CEST = 01:00 server FTMO) |

📌 **Fonti orari**: i `.set` stessi, letti riga per riga stanotte · mappatura fuso
`docs/REGOLAMENTO_FTMO_2026-08.md` r.130 · regola di casa BCM = IT−1 (`CLAUDE.md`, §FUSO ORARIO BCM).
🔴 **La colonna FTMO è `[INFERITO]` finché l'orologio di Market Watch non è stato letto** (§④ passo 4).

## 1.2 Contratto misurato e stato di schieramento

| magic | **PF** (fonte) | **DD promesso** | **frequenza** | 🌙 **tiene posizioni oltre la giornata?** *(campo vero)* | 🔴 **STATO PER DOMENICA NOTTE** | cosa manca, esattamente |
|---|---|---|---|---|---|---|
| **`770101`** | **1,41105** OOS · n 270 deal (**193 posizioni**) | **4,3501%** @0,65% · **6,7111%** @1,0% (banco 10k) · **7,2328%** @1,0% (banco 100k) | **0,699-0,705 op/gg** | 🟢 **MAI** — n=39, oltre mezzanotte **0**, weekend **0** | 🟠 **SERVE F7** | il sorgente a HEAD ha la toppa per ticket del 19/09 (2425 righe) ma **non è mai stato compilato**. Copia + F7 sul terminale FTMO. |
| **`770411`** | **2,05** (promozione 26/07, n 41) | 🟢 **1,27%** @1,0% | **~1,7 op/mese** (21 deal = 14 pos OOS) | 🟢 **MAI** — n=5, oltre mezzanotte **0**, weekend **0**. ⚠️ *si chiama «MaxMinNotte» ma **non opera di notte**: legge il massimo/minimo notturno e apre alle **08:00**, tutte e 5 le volte* | 🟠 **SERVE F7** | codice **già a HEAD** (`5fc0bc31`) e già compilato sul 100k: è la sedia più semplice. Solo copia + F7. |
| **`770202`** | **1,270** OOS · n 130 deal (**96 posizioni**) | **4,22%** | **0,348 op/gg** (backtest) · 🔴 **0,129 in campo** | 🟢 **MAI** — n=4, oltre mezzanotte **0**, weekend **0** | 🟠 **SERVE F7** + ⚠️ **è muta dal 28/08** | come `770101`: HEAD con la toppa, mai compilato. E vedi §⑤.6. |
| **`771531`** | **1,52** OOS · n 517 · 30/30 PASS walk-forward tick | **7,21%** | **~33 op/mese** (444 deal / 12,5 mesi) | 🔴 **SÌ** — n=21, oltre mezzanotte **4**, weekend **2** | 🛑 **F7 IN HOLD** (buco B9) | bersaglio **`26a18566`** (19/08) — **mai compilato da nessuna parte**. Pacchetto pronto: `report/COMPILAZIONE_771531_770511_2026-09-19.md`. 🔴 **L'F7 cambia il sizing** (`OrderCalcProfit`): di quanto su `U30USD` è **[NON MISURATO]**. |
| **`770511`** | **1,52** (9/9 combo positive, validazione) · OOS H1 **1,328** su n 143 | **4,0%** | **~10,8 op/mese** (227 deal / 21 mesi) · 0,290 op/gg | 🔴 **SÌ, la più esposta** — n=16, oltre mezzanotte **6**, weekend **2** *(gira `InpStartHour=0`/`InpEndHour=24`)* | 🛑 **F7 IN HOLD** (buco B9) | bersaglio **`872dba82`** (08/09) — **mai compilato da nessuna parte**. 🔴 **L'F7 fa SCENDERE la taglia** (chiude il pavimento del lotto che oggi piazza `totLot + volMin`): di quanto è **[NON MISURATO su questa sedia]**. |
| **`770402`** | R100 · 22 anni · OHLC | 🟠 **10,0%** @0,5% (19,72% @1,0%) | **~3,7 posizioni/mese** | 🟢 **MAI** — n=11, oltre mezzanotte **0**, weekend **0** | 🔴 **SERVE MISURA** | il binario in campo (`08239510`, **28/07**) ha il **breakeven annegato nel parziale a 0,01 lotti** = 🔴 rischio attivo; ma il bersaglio HEAD (`7d0da9f9`) **rende effettivo `InpOneTradePerDay`** e quindi **cambia la frequenza con cui il contratto è stato misurato**. Serve una corsa di controllo prima. |
| **`770260`** 🔴 **MERITO SOSPESO PER CAMPIONE** | **1,10936** OOS · n **94** · IS 1,14498 · n 91 | **3,68%** 🔴 *(il DD viene da un binario pre-fix di sizing: `PF` e `n` reggono, il **DD no**)* | **[NON MISURATO in posizioni]** | ⚪ **[NON MISURATO]** — mai operata in campo. *Chiude alle 17:30 BCM / 19:30 FTMO per preset: sulla carta non dovrebbe mai tenere* | 🟠 **SERVE IL `.set`** | ✅ **voluta da Claudio** (19/09: *«Sì, dentro il 770260 RETEST»*). 🔴 **n=94 IS / 94 OOS: sotto il pavimento dei 150 in tutte e due le finestre.** Entra col **merito sospeso**, non col merito pieno — e il **criterio di uscita firmato il 18/08 (corsia RISCHIO) vale su di lei dal primo giorno, a qualunque n**. Manca: ① il `.set` (**non in repo**, buco B6) ② il TF da confermare. |
| **`770261`** | **1,06338** OOS · n 108 | 4,13% | — | — | 🔴 **FUORI (merito)** | **PF 1,063 < 1,10**, la soglia che abbiamo firmato noi. Parere confermato: `770260` passa il merito, `770261` no. |

### 📊 IL CONTO, in chiaro
- 🪑 **La rosa voluta da Claudio è di SETTE sedie**: `770101` · `770411` · `770202` · `771531` · `770511` · `770402` · **`770260`**.
- **Sedie PRONTE, che hanno bisogno solo di una copia e di un F7: 3** — `770101` `770411` `770202`.
- 🛑 **Sedie ferme su una firma di Claudio: 2** — `771531` e `770511`: il pacchetto di compilazione è **in HOLD** perché l'F7 **cambia le taglie** e la firma copriva *«compila»*, non *«e la taglia cambia»* (`report/FIRME_2026-09-19_SERA.md` §③). 👉 **Una riga di sì le sblocca tutte e due.**
- **Sedie che richiedono una MISURA prima: 1** — `770402`.
- **Sedie che richiedono un FILE che oggi non esiste: 1** — `770260` (il `.set`).
- **Sedie fuori: 1** — `770261`, per merito.
- 🟢 **Zero sedie sono bloccate da una regola FTMO in valutazione** (§⓪.ZERO). 🟠 L'unica clausola che vale **anche** in Challenge è il **gap trading**, e tocca `770511` e `771531` → §Ⓐ.3.
- 🌙 **Cinque sedie su sette non tengono MAI una posizione oltre la giornata** — misurato sulle posizioni vere di `data/statements/trades_auto.csv`. **Due sì**: `771531` e `770511`. Su **Swing** non è mai un problema; su **Standard da funded** lo diventa (§⑤bis).

---

# ② 🔢 IL MARGINE — tabella parametrica taglia × leva

> ✏️🔴 **NOTA DI CORREZIONE — 23/09/2026, `R232`.** In tutta la tabella qui sotto **la colonna da
> leggere è `1:50`** (quella in corsivo): la leva indici del conto è **misurata** e vale 1:50, non
> 1:15. L'ipotesi **H2** non è più `[INFERITO]`: è **MISURATA** su cinque simboli. Motivo, fonte e
> conclusioni che cadono: **nota estesa al §② in testa a questo file** e
> `report/QUANTE_SEDIE_CI_STANNO_2026-09-23.md` §1-§2. 🔴 **La taglia della tabella è vecchia**: i
> preset FTMO oggi portano **`InpRiskPercent=2.00`**, riga che qui **non esiste** — il totale a
> 2,00% e 1:50 è **105,07%** del conto per sei sedie (ricalcolo in `R232` §3).



## 2.0 🧮 DA QUALI IPOTESI PARTE IL CALCOLO (leggere PRIMA dei numeri)

**Formula**: `lotti = rischio_conto / (stop × valore_punto)` → `nozionale = lotti × valore_punto × prezzo` → `margine = nozionale / leva`.

| # | ipotesi | etichetta | come si sostituisce domenica sera |
|---|---|---|---|
| **H1** | **valore punto = 1 unità di valuta quotata per punto indice per lotto** (contract size 1); **oro = 100 $ per dollaro d'oro** | 🟢 **[MISURATO sul campo BCM]** — vedi il contro-esempio 2.1 | Market Watch → tasto destro sul simbolo → **Specification** → riga *Contract size* |
| **H2** | **margine = nozionale / leva** (margine proporzionale, non fisso per lotto) | 🔴 **[INFERITO]** — alcuni broker usano margine **fisso per lotto** sugli indici | stessa finestra → riga *Initial margin* / *Margin rate* |
| **H3** | **prezzi** `U30USD` **53.200** · `D30EUR` **25.753** · `NASUSD` **29.474** · `XAUUSD` **4.320** | 🟢 **[MISURATO]** — ultimi prezzi veri per magic in `data/statements/trades_auto.csv` (07/09, 17/09, 18/09, 17/09) | sostituire col prezzo di apertura |
| **H4** | **stop** `770101` **71,9** · `770411` **75,85** *(centro della banda 64,2-87,5)* · `770202` **123,8** · `771531` **104,3** · `770511` **77,1** · `770402` **32,94 $** · `770260` **83,2** | `770101/770202/771531/770511/770402` **[MISURATO]**; `770411` 🔴 **[NON MISURATO]**; `770260` 🔴 **[INFERITO]** | — |
| **H5** | **EURUSD = 1,160** (per convertire il nozionale `D30EUR` in dollari) | 🟢 **[MISURATO]** `trades_auto.csv` 31/08 | — |
| **H6** | **conto da 100.000 $**, una posizione per sedia | dichiarata | — |

🔴 **Ogni cella della tabella 2.2 è quindi `[INFERITO]` per via di H2**, anche quando gli ingressi
sono misurati: **non abbiamo mai letto una specifica di contratto FTMO.**
📎 **Fonti degli stop**: `report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` rr.396, 404, 406, 462 ·
`report/ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` rr.407-413.

### 2.1 🧪 IL CONTRO-ESEMPIO CHE SALVA H1 — il valore punto è **misurato**, non assunto

Ipotesi da battere: *«1 punto = 1 dollaro per lotto è una cosa che ti sei inventato»*.
Rifatti i P/L di **cinque operazioni vere** dal `trades_auto.csv` e confrontati col P/L che il
broker ha davvero scritto:

| operazione | mossa | P/L ricostruito (valuta quotata) | P/L **riportato** (EUR) | rapporto |
|---|---:|---:|---:|---:|
| `770101` D30EUR buy 0,40 | +3,10 idx | **1,24 EUR** | **1,24** | 🟢 **1,000** |
| `770250` NASUSD sell 0,20 | +17,60 idx | 3,52 USD | 3,07 | 🟢 **1,147** |
| `770402` XAUUSD buy 0,01 (cs 100) | +56,75 $ | 56,75 USD | 49,38 | 🟢 **1,149** |
| `970901` XAUUSD sell 0,01 (cs 100) | −22,21 $ | −22,21 USD | −19,34 | 🟢 **1,148** |
| `770924` 225JPY sell 0,30 | −580 idx | — | −9,73 | ⚪ **17,88** → contract size ≠ 1 (fuori rosa) |

> ## 🎯 **Il simbolo quotato in EUR torna al centesimo (1,000). I tre quotati in USD tornano tutti e tre allo stesso fattore 1,147-1,149, che è EURUSD.** Se H1 fosse sbagliata, quei tre numeri non sarebbero uguali fra loro — e il DAX non farebbe 1,000.
> 👉 **H1 è verificata su due valute, tre simboli e due contract size diverse.** Resta aperta **solo** la domanda *«FTMO usa le stesse specifiche di BCM?»*, che è una domanda diversa e si chiude con uno screenshot.
> ⚠️ E `225JPY` è la riga che dimostra che il metodo **sa dire di no**: lì il rapporto è 17,88 e non 1,15, cioè il contract size **non** è 1. Fuori rosa, quindi non tocca la tabella — ma se avessi assunto H1 per tutti, avrei sbagliato quella riga.

## 2.2 🔢 LA TABELLA — margine in $ per **una** posizione, conto 100.000 $

### ▸ Taglia **0,65%** (rischio 650 $ per posizione)
| sedia | lotti | **1:15** (Swing) | **1:25** (FundedNext) | **1:30** (Swing FX) | *1:50* (Standard idx) |
|---|---:|---:|---:|---:|---:|
| `770101` DAX Apertura | 7,79 | 15.521 | 9.313 | 7.761 | *4.656* |
| `770411` MaxMin DAX Short | 7,39 | 14.713 | 8.828 | 7.356 | *4.414* |
| `770202` Dow Apertura | 5,25 | 18.621 | 11.173 | 9.311 | *5.586* |
| `771531` EMA200 Dow | 6,23 | 22.103 | 13.262 | 11.051 | *6.631* |
| `770511` SuperWave Dow | 8,43 | **29.901** | 17.940 | 14.950 | *8.970* |
| `770402` MaxMin ORO | 0,20 | 5.684 🔴 *(a 1:9 metalli Swing: **9.474**)* | 3.410 | 2.842 | *1.705* |
| `770260` Nasdaq RETEST | 7,81 | 15.351 | 9.211 | 7.676 | *4.605* |
| **TOTALE 7 sedie** | | 🔴 **121.894 = 121,9%** | 🟠 **73.136 = 73,1%** | 🟠 **60.947 = 60,9%** | 🟢 *36.568 = 36,6%* |
| **TOTALE al massimo di posizioni da codice** | | 🔴 **173.897 = 173,9%** | 🔴 **104.338 = 104,3%** | 🟠 **86.949 = 86,9%** | 🟢 *52.169 = 52,2%* |

### ▸ Taglia **1,00%** (rischio 1.000 $ per posizione)
| sedia | lotti | **1:15** | **1:25** | **1:30** | *1:50* |
|---|---:|---:|---:|---:|---:|
| `770101` DAX Apertura | 11,99 | 23.879 | 14.327 | 11.939 | *7.164* |
| `770411` MaxMin DAX Short | 11,37 | 22.635 | 13.581 | 11.318 | *6.791* |
| `770202` Dow Apertura | 8,08 | 28.648 | 17.189 | 14.324 | *8.595* |
| `771531` EMA200 Dow | 9,59 | 34.004 | 20.403 | 17.002 | *10.201* |
| `770511` SuperWave Dow | 12,97 | **46.001** | 27.601 | 23.000 | *13.800* |
| `770402` MaxMin ORO | 0,30 | 8.744 🔴 *(1:9: **14.573**)* | 5.247 | 4.372 | *2.623* |
| `770260` Nasdaq RETEST | 12,02 | 23.617 | 14.170 | 11.809 | *7.085* |
| **TOTALE 7 sedie** | | 🔴 **187.529 = 187,5%** | 🔴 **112.518 = 112,5%** | 🟠 **93.765 = 93,8%** | 🟢 *56.259 = 56,3%* |
| **TOTALE max posizioni** | | 🔴 **267.535 = 267,5%** | 🔴 **160.521 = 160,5%** | 🔴 **133.767 = 133,8%** | 🟠 *80.260 = 80,3%* |

### ▸ Taglia **1,30%** (rischio 1.300 $ per posizione)
| sedia | lotti | **1:15** | **1:25** | **1:30** | *1:50* |
|---|---:|---:|---:|---:|---:|
| `770101` DAX Apertura | 15,59 | 31.042 | 18.625 | 15.521 | *9.313* |
| `770411` MaxMin DAX Short | 14,78 | 29.426 | 17.656 | 14.713 | *8.828* |
| `770202` Dow Apertura | 10,50 | 37.243 | 22.346 | 18.621 | *11.173* |
| `771531` EMA200 Dow | 12,46 | 44.206 | 26.523 | 22.103 | *13.262* |
| `770511` SuperWave Dow | 16,86 | **59.801** | 35.881 | 29.901 | *17.940* |
| `770402` MaxMin ORO | 0,39 | 11.367 🔴 *(1:9: **18.945**)* | 6.820 | 5.684 | *3.410* |
| `770260` Nasdaq RETEST | 15,62 | 30.702 | 18.421 | 15.351 | *9.211* |
| **TOTALE 7 sedie** | | 🔴 **243.788 = 243,8%** | 🔴 **146.273 = 146,3%** | 🔴 **121.894 = 121,9%** | 🟠 *73.136 = 73,1%* |
| **TOTALE max posizioni** | | 🔴 **347.795** | 🔴 **208.677** | 🔴 **173.897** | 🔴 *104.338* |

📌 *«Max posizioni da codice»* = `771531` e `770511` possono avere **2** posizioni ciascuna
(secondo ordine / pendente + mercato), le altre 1. `770261`, se mai entrasse, ne porta 2 di suo
(whipsaw a due lati) — `report/DUE_SEDIE_NASDAQ_IL_BLOCCO_2026-09-19.md` §③.

## 2.3 🔴 **QUANTE SEDIE ENTRANO DAVVERO** — la riga che decide la rosa

Regola di lettura dichiarata: **budget 50% del conto** = margin level ≥ 200% a equity intatta
(= si può ancora aprire, e un calo del 10% non porta vicino a niente). Sotto anche la lettura
estrema **100%** (= margine pari all'equity: il primo ordine in più viene **rifiutato**).
Conteggio fatto **dalla sedia più economica alla più cara** — è **aritmetica, non una scelta di
quali tagliare**: quella è di Claudio.

| taglia | leva | **entrano sotto il 50%** | **entrano sotto il 100%** |
|---|---|---|---|
| **0,65%** | 🔴 **1:15** | **3 su 7** (35.748 $) | **6 su 7** (91.993 $) |
| 0,65% | 1:25 | **5 su 7** (41.934 $) | 🟢 **7 su 7** (73.136 $) |
| 0,65% | 1:30 | **6 su 7** (45.997 $) | 🟢 **7 su 7** (60.947 $) |
| 0,65% | *1:50* | 🟢 ***7 su 7*** *(36.568 $)* | 🟢 *7 su 7* |
| **1,00%** | 🔴 **1:15** | 🔴 **2 su 7** (31.379 $) | **4 su 7** (78.876 $) |
| 1,00% | 1:25 | **4 su 7** (47.325 $) | **6 su 7** (84.917 $) |
| 1,00% | 1:30 | **4 su 7** (39.438 $) | 🟢 **7 su 7** (93.765 $) |
| 1,00% | *1:50* | **6 su 7** *(42.459 $)* | 🟢 *7 su 7 (56.259 $)* |
| **1,30%** | 🔴 **1:15** | 🔴 **2 su 7** | **3 su 7** |
| 1,30% | 1:25 | **3 su 7** | **5 su 7** |
| 1,30% | 1:30 | **3 su 7** | **6 su 7** |
| 1,30% | *1:50* | **5 su 7** | 🟢 *7 su 7 (73.136 $)* |

> ## 🔴 **LA COMBINAZIONE CHE CLAUDIO HA IN MANO OGGI — FTMO, 1:15 dichiarata — REGGE TRE SEDIE A 0,65% E DUE A 1,00%.** Non sette.
> Le tre più economiche a 0,65%/1:15 sono, **per costo e non per merito**: `770402` ORO (5.684) ·
> `770411` MaxMin DAX Short (14.713) · `770260` Nasdaq (15.351). Tenendo `770511` — che è la
> 🥇 della rosa per campo — il budget del 50% se ne va quasi tutto con **lei sola (29.901)**.
> 👉 **Il margine, non il regolamento, è ciò che sceglie la rosa.** E la manopola che lo sblocca
> non è la taglia: è **il tipo di conto**.

## 2.4 ✏️ CORREZIONE AL RIFERIMENTO DI CASA — il «~67.000 $ = 67%» è **ottimista**

`report/QUALE_PROP_PER_I_NOSTRI_EA_2026-09-18.md` rr.190-197 dà **16.103 $** per una posizione
`U30USD` a 0,65% / 1:15. Da quel numero si ricava il prezzo che ha usato:
`16.103 × 123,8 × 15 / 650` = **46.012**. 🔴 **Ma `U30USD` sta a 53.200** (ultimo prezzo vero
per magic `770511`, 07/09, `trades_auto.csv`). **Sottostima del 13,5%.**
Stesso conto su `NASUSD`: quel referto implica **~21.000**, il prezzo vero è **29.474** —
**sottostima del 29%**.
🟢 **La direzione della correzione è quella brutta**: il margine vero è **più alto** di quello già
segnalato come preoccupante. E il totale di 121.894 $ a 0,65%/1:15 è calcolato sulle **sette sedie
vere con i loro stop veri**, non su cinque copie della stessa posizione.

---

# ③ 🔀 LA MAPPA DELLE COLLISIONI PER SIMBOLO

Su conto **HEDGING**, `gTrade.PositionClose(_Symbol)` chiude la posizione **più vecchia del
simbolo, di chiunque sia** (`report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md` r.39).
Con **una** sedia per simbolo era innocuo. Sul conto prop **non lo è più**.

| simbolo | sedie che lo condividono **sul conto prop** | quante |
|---|---|---:|
| **`U30USD`** | `770202` Dow Apertura · `771531` EMA200 · `770511` SuperWave | **3** |
| **`D30EUR`** | `770101` DAX Apertura · `770411` MaxMin DAX Short | **2** |
| **`NASUSD`** | `770260` Nasdaq RETEST — **e basta** | **1** |
| **`XAUUSD`** | `770402` MaxMin ORO | **1** |

*(Una quarta sedia su `U30USD` esisterebbe — `770611` ORB — ma è **fuori rosa**: 1 vinta su 8 in
campo, −209,18, e DD promesso 9,92% di confine. `report/LA_ROSA_PER_LA_PROP_2026-09-19.md` §④.)*

### 🔴 3.0 UNA CORREZIONE, E VA FATTA PRIMA DI TUTTO IL RESTO

Mi è stato detto: *«il referto dice che la collisione è a DUE vie `770250`↔`770261`, solo sul lato
SELL, e che `770260` è fuori da quella collisione — quindi togliendo il BREAKOUT la collisione
Nasdaq sparisce»*. **L'ho verificato nel referto invece di fidarmi, e non regge: sono DUE cose
diverse nello stesso file.**

| | `report/DUE_SEDIE_NASDAQ_IL_BLOCCO_2026-09-19.md` §② | stesso file, §④ **r.104** |
|---|---|---|
| di che parla | 🔴 **la chiusura `PositionClose(_Symbol)` su conto HEDGING** | 🟡 **la stringa di commento**, cioè quali *strumenti di analisi* confondono le sedie |
| cosa dice testualmente | *«alle 17:30 server **`770260`/`770261`** chiamano `EndOfSession()`. Se hanno una posizione aperta, la `PositionClose(_Symbol)` colpisce la più vecchia su NASUSD — che sarà quella di `770250`»* | *«La collisione è a DUE vie (`770250` ↔ `770261`, solo sul lato SELL), non a tre. `770260` è distinguibile»* — e subito sotto: *«Gli strumenti che ragionano per commento, uno per uno»* |

> ## 🔴 **Quindi `770260` è DENTRO la collisione di chiusura, non fuori.** Il «due vie» di r.104 riguarda `analizza_trades.py` e `classifica_report_mt5.py`, non `CTrade`.

🟢 **MA LA CONCLUSIONE È LA STESSA, PER UN'ALTRA RAGIONE — ed è più solida:**
**`770250` non va sul conto prop.** Non è nella rosa delle sette, e nessuna firma la sposta.
Sta dove sta oggi: terminale **50503392** (`C:\Program Files\BCM Markets MT5 Terminal`),
`ORO\chart41.chr`, `NASUSD` **M15**, rischio **0,35**
(`backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260919_033003.log`).
👉 **Sul conto prop `NASUSD` ha UNA sedia sola, quindi «la più vecchia È la nostra» e la
collisione non può esistere.**

### 🔴 E LA DOMANDA CHE RESTA VIVA, sul piccolo
`770250` **resta accesa** sul 50503392: nessuna firma la spegne, e il suo forward serve.
🟢 **Non collide con niente**, perché `770260` va sul terminale FTMO e non lì.
🔴 **Diventerebbe un problema solo se qualcuno attaccasse `770260` ANCHE sul piccolo** per
confrontarle: in quel caso, su quel terminale, tornano due sedie su `NASUSD` e la chiusura per
ticket serve davvero. **Oggi non è previsto, e non va fatto senza una firma.**

## 3.1 🟢 CHI È GIÀ SICURO DI NATURA — **verificato, non assunto**
Censimento su tutti i 113 `.mq5` di `mql5/Experts/`: **occorrenze in codice eseguibile = 0** per
`ABTG_MaxMinNotte_DAX_Short_Ottimizzato` (`770411`), `ABTG_EMA200` (`771531`),
`ABTG_SuperWave_DOW_H1_Ottimizzato` (`770511`)
(`report/TOPPA_TICKET_A_HEAD_2026-09-19.md` §«Quello che resta aperto»).
🟢 **Queste tre non chiudono mai niente che non sia loro, con qualunque binario.**

## 3.2 🔴 CHI DEVE ESSERE RICOMPILATO PERCHÉ LA PROTEZIONE SIA VIVA

| file da ricompilare (F7) | magic | cosa succede se NON lo si fa |
|---|---|---|
| **`ABTG_DAX_Apertura_EU.mq5`** | `770101` | alle 19:30 server FTMO chiude la posizione **di `770411`** se quella è più vecchia — e la richiama **a ogni tick** finché la propria non è l'ultima rimasta |
| **`ABTG_Dow_Apertura_US.mq5`** | `770202` | idem su `U30USD`: colpisce `771531` e `770511`, dalla più vecchia in giù |
| **`ABTG_Nasdaq_Apertura_US.mq5`** | `770260` | 🟢 **sul conto prop non colpisce nessuno** (una sola sedia su `NASUSD`, §3.0). 🔴 **Si ricompila lo stesso**: costa zero, è lo stesso sorgente a HEAD, e toglie una bomba a orologeria il giorno in cui una seconda sedia Nasdaq entrasse |

🟢 **La toppa è entrata a HEAD stasera** e porta **+58 righe identiche** sui tre file
(`wc -l`: DAX 2367→**2425**, Dow 2147→**2205**, Nasdaq 2566→**2624**; righello `CODA_06`:
2426 / 2206 / 2625).
🔴 **Ma i tre file patchati a HEAD non sono MAI stati compilati da nessuna parte**: il primo F7
è anche il primo collaudo. Se dà errore, non è una sorpresa — è il collaudo che funziona.
### 🔴 3.3 UNA SECONDA CORREZIONE, TROVATA STANOTTE — **e riguarda una sedia della rosa**

`report/TOPPA_TICKET_A_HEAD_2026-09-19.md` scrive: *«🟢 Nessuna delle SEI SEDIE di lunedì resta
col difetto»*, ed elenca `770411`, `771531`, `770511` (0 occorrenze), i tre Apertura (riparati) e
`ABTG_ORB_Ottimizzato` (già a posto). 🔴 **Ma `ABTG_ORB_Ottimizzato` non è nella rosa, e
`ABTG_MaxMinNotte.mq5` — che è la sedia `770402` — SÌ.** Quel file compare nell'elenco dei
*«altri 14 EA … fuori dalle sei sedie»*.

**Verificato a macchina, a HEAD, non dedotto:**
```
mql5/Experts/ABTG_MaxMinNotte.mq5:251:  if(newsBlk && InpNewsFlatten){ CancelPendings(); if(SelPos()) gTrade.PositionClose(_Symbol); }
mql5/Experts/ABTG_MaxMinNotte.mq5:454:  if(isLong && e[0]>openP && bid>=e[0]) { gTrade.PositionClose(_Symbol); ... }
mql5/Experts/ABTG_MaxMinNotte.mq5:455:  if(!isLong && e[0]<openP && ask<=e[0]){ gTrade.PositionClose(_Symbol); ... }
mql5/Experts/ABTG_MaxMinNotte.mq5:490:  if(InpCloseAtEnd && SelPos()){ gTrade.PositionClose(_Symbol); ... }
```
> ## 🔴 **QUATTRO occorrenze in codice eseguibile, su una sedia che va in campo. Il conteggio «zero difetti nella rosa» era sbagliato per omissione — e lo era anche l'elenco, che ha sostituito una sedia della rosa con una che non c'è.**

🟢 **E però il danno pratico sul conto prop è ZERO, ed è dimostrabile:** `770402` è **l'unica
sedia su `XAUUSD`** (§③, mappa). Con una sola posizione sul simbolo, *«la più vecchia È la
nostra»* — la stessa ragione per cui il difetto è stato tollerato per mesi su `770250`.
🔴 **Diventa un problema il giorno in cui una seconda sedia tocca l'oro**, e quel giorno oggi non
è previsto. 👉 **Non propongo di ripararlo prima di domenica**: lo strumento di casa
(`backtest_pipeline/genera_toppa_chiusura_ticket.py`) lo sa già fare, è **una riga di comando**,
ma una toppa in più a 24 ore dalla partenza è un rischio che non compra niente.
📌 **Va scritto nel registro, non nascosto**: è la **classe 462** che si ripete
(fix di famiglia applicato al file generico e non alla variante in campo — qui al contrario:
elencata la variante e dimenticato il generico).

⚠️ E la decisione su `770402` (vintage col breakeven cieco **vs** HEAD che cambia la frequenza)
resta comunque aperta al §⑥ **B8**.

> ## 🎯 **In una riga: sul conto prop vanno ricompilati DUE file per la protezione (`DAX_Apertura_EU`, `Dow_Apertura_US`), TRE per avere il binario giusto (`EMA200` a `26a18566`, `SuperWave_DOW_H1_Ott` a `872dba82`, `MaxMinNotte_DAX_Short_Ott` già a HEAD) e UNO perché ci serve la sedia (`Nasdaq_Apertura_US`).** In tutto **sei F7**, più il Guardian.

---

# ④ 📋 L'ORDINE DI ACCENSIONE — da spuntare, in ordine

🔴 **Premessa che vale per tutta la lista (regola dei terminali multipli, 06/09 + 12/09):**
il terminale FTMO è la **SETTIMA cartella dati** del VPS e **oggi non esiste**. Le sei che ci
sono già — e che **nessun passo di questa lista deve toccare** — sono:
`50503392` (`C:\Program Files\BCM Markets MT5 Terminal`) · `50504263` (`... -V3`) ·
**`10105439` (`C:\BCM_Reale`, conto REALE)** · `50504400` (`C:\MT5_Backtest`) ·
`C:\MT5_MANUALE` · Pepperstone · Tickmill.

| # | passo | 🖥️ **dove / su che terminale** | chi | ✅ **come si verifica che è riuscito** |
|---:|---|---|---|---|
| **1** | **Scaricare e installare MT5 FTMO** dalla dashboard FTMO, in una cartella **dedicata** — proposta: `C:\MT5_FTMO` (🔴 **non** dentro `C:\Program Files\BCM...`) | 🖥️ Desktop del **VPS** | ✍️ **Claudio, a mano** | esiste `C:\MT5_FTMO\terminal64.exe`; le sei cartelle di prima sono **intatte** |
| **2** | **Login** col numero di conto FTMO e la password *trader* | 🪟 il nuovo terminale FTMO | ✍️ **Claudio** | in basso a destra: connesso, e il numero di conto in alto a sinistra è quello FTMO — **non** 50503392, **non** 50504263, **non** 10105439 |
| **3** | **Foto di riconoscimento dei terminali** (sola lettura, non tocca niente) — serve per non sbagliare finestra nei passi dopo: `Get-Process terminal64,metaeditor64 \| Select-Object Id, MainWindowTitle, Path \| Format-Table -AutoSize` | 🖥️ **una finestra PowerShell sul VPS** | ✍️ **Claudio** | compare **una riga con `C:\MT5_FTMO`** accanto alle altre. 🔴 Da qui in poi ogni gesto si fa sulla finestra con **quel** `Path` |
| **4** | 🔴 **LEGGERE L'OROLOGIO DEL SERVER.** In alto in Market Watch c'è l'ora del server FTMO: confrontarla con l'orologio di Windows (che sta in ora italiana) | 🪟 terminale **FTMO** | ✍️ **Claudio** | **se Market Watch è AVANTI di 1 ora su Windows → la mappatura del §①.1 è confermata (FTMO = BCM+2).** Se è *indietro* di 1 ora, FTMO = BCM e **tutta la colonna FTMO del §①.1 va buttata**. 📸 **Screenshot** |
| **5** | 🔴 **LEGGERE LE SPECIFICHE DI CONTRATTO** di `US30`, `GER40`/`DE40`, `NAS100`/`US100`, `XAUUSD`: tasto destro sul simbolo in Market Watch → **Specification**. Servono: **Contract size · Digits · Point · Initial margin · Tick value** | 🪟 terminale **FTMO** | ✍️ **Claudio** | 📸 **quattro screenshot**. Con quelli il §② smette di essere `[INFERITO]` e diventa misurato — **è il pezzo che manca a tutto il pacchetto** |
| **6** | **Copiare i sorgenti** nella cartella dati FTMO: in `MQL5\Experts` i **sei** `.mq5` della rosa + `ABTG_Guardian.mq5`; in `MQL5\Include` **`ABTG_PausaGuardian.mqh`**. 🟢 **Nessun altro include serve**: verificato, i sei EA fanno `#include` di sole due cose, `<Trade/Trade.mqh>` (standard MT5) e `<ABTG_PausaGuardian.mqh>` | 🖥️ PowerShell sul VPS, bersaglio **solo** la cartella dati di `C:\MT5_FTMO` | 🤖 **una riga** (da scrivere e far passare dal doppio cancello) | i file compaiono in `MQL5\Experts`; il conteggio righe combacia con quello dichiarato nel §⑥ buco B7 |
| **7** | 🔴 **L'include prima di tutto**: `ABTG_PausaGuardian.mqh` **deve** stare in `MQL5\Include`, altrimenti l'F7 muore su `cannot open include file` (classe 27). Versione provata: **v1.20**, blob `cc90fb73`, 398 righe | 🪟 MetaEditor del terminale **FTMO** | 🤖 riga / ✍️ Claudio | il file esiste e fa 398 righe |
| **8** | **F7 sui sei EA**, uno per uno: `ABTG_DAX_Apertura_EU`, `ABTG_Dow_Apertura_US`, `ABTG_Nasdaq_Apertura_US`, `ABTG_MaxMinNotte_DAX_Short_Ottimizzato`, `ABTG_EMA200`, `ABTG_SuperWave_DOW_H1_Ottimizzato` (+ `ABTG_Guardian`) | 🪟 MetaEditor del terminale **FTMO** — 🚫 **NON** quello del 50503392, **NON** quello del reale | ✍️ **Claudio, a mano** | **0 errori** in ogni compilazione; l'`.ex5` compare in `MQL5\Experts`. ⚠️ `ABTG_EMA200` **non cambia numero di versione** (resta 1.00): si riconosce solo dal conteggio righe. `ABTG_SuperWave_DOW_H1_Ott` passa **1.00 → 1.01** |
| **9** | **Aprire i grafici**, uno per sedia, sul **simbolo FTMO corrispondente** e sul TF della tabella §①.1 | 🪟 terminale **FTMO** | ✍️ **Claudio** | tanti grafici quante sedie; TF giusto nella barra del titolo |
| **10** | 🔴 **Caricare i preset CON GLI ORARI RIMAPPATI** (§①.1, colonna FTMO) e **con la taglia decisa** | 🪟 terminale **FTMO** | ✍️ **Claudio** — 🔴 **la taglia è sua e non è ancora decisa** | nella finestra input, riga per riga: `InpSessionHour`, `InpCloseHour`, `InpBoxStartHour`, `InpPlaceHour`, `InpCutoffHour`, `InpRiskPercent`, `InpMagic` |
| **11** | ⚠️ **Guardare i tre input NUOVI** che i preset **non** contengono e che quindi prendono il default: `InpUsaGuardian` (**default `true`**), `InpPendingAtr` (0), `InpSLBufferAtr` (0) | 🪟 terminale **FTMO** | ✍️ **Claudio** | 🟢 `InpUsaGuardian=true` **è quello che vogliamo su un conto prop** — ma dev'essere una decisione, non una sorpresa |
| **12** | **Attaccare `ABTG_Guardian`** su **un** grafico qualsiasi, col preset `ABTG_Guardian_FTMO_2Step.set` e 🔴 **`InpDailyResetHour` ricalcolato** (`=1` se il passo 4 conferma GMT+3) | 🪟 terminale **FTMO** | ✍️ **Claudio** | il pannello del Guardian compare sul grafico e scrive `InpStartBalance=100000`, limite 4,9% / 9,9% |
| **13** | **AutoTrading ON** (il pulsante in alto) | 🪟 terminale **FTMO** | ✍️ **Claudio** | il pulsante è **verde**; su ogni grafico la faccina in alto a destra è 🙂 e non 🚫 |
| **14** | ✅ **La verifica della prima giornata**: nel Giornale devono comparire, all'ora giusta **di server FTMO**, le righe di armamento — `RETEST armato` per le Aperture, il piazzamento pendenti per i MaxMin | 🪟 terminale **FTMO**, scheda **Esperti**/**Giornale** | 🤖 + ✍️ | 🔴 **attenzione**: i log di MT5 sono in **ora LOCALE del PC** (italiana), il grafico è in **ora server**. Una riga datata `10:00` nel log è stata scritta alle **09:00 server FTMO**. *(Regola di casa, imparata sbagliando il 06/08.)* |

### 🚫 QUELLO CHE **NON** SI FA IN QUESTA LISTA
- ❌ **Non si tocca `C:\BCM_Reale` (10105439).** Nessun passo lo nomina, nessuno lo apre.
- ❌ **Non si spegne niente sugli altri sei terminali.** Il piccolo `50503392` continua a essere lo strumento di misura.
- ❌ **Non si sceglie la taglia.** Il passo 10 si ferma finché Claudio non risponde.
- ❌ **Nessuna riga PowerShell di questo pacchetto è stata ancora scritta né mandata**: i passi 6 e 7 hanno bisogno di uno script che deve passare **`controlla_riga.py` + l'agente `controllo-preventivo`** prima di uscire (regola del cancello, 09/09).

---

# ⑤ ⚠️ COSA PUÒ ANDARE STORTO — in ordine di **probabilità × danno**

| # | cosa | probabilità | danno | contromisura, e chi la fa |
|---:|---|---|---|---|
| **1** | 🔴 **I preset girano con gli orari di BCM su un server che sta 2 ore avanti.** Il DAX forma il range alle 06:00 di mercato (mercato chiuso/illiquido), il Dow alle 12:30 (tre ore prima dell'apertura USA) | 🔴 **certa se nessuno rimappa** — è aritmetica, non sfortuna | 🔴 **totale**: le sedie non fanno quello che il contratto dice, e i numeri del backtest **non valgono più** | **passo 4** (leggi l'orologio) + **passo 10** (colonna FTMO del §①.1). 10 secondi + 7 campi. ✍️ Claudio |
| **2** | 🔴 **`Digits`/`Point` diversi su FTMO.** `770202` usa `InpBufferPoints=1000` che su BCM vale **10,00 punti indice** *(perché `U30USD` ha `_Digits=2`)*. Se `US30` su FTMO ha 1 decimale, gli stessi 1000 punti diventano **100 punti indice**: il livello di rottura si sposta di **dieci volte** | 🟠 media | 🔴 alto: le sedie a buffer (`770101`, `770202`, `770260`) entrano ai prezzi sbagliati, o non entrano mai | **passo 5** (specifiche: riga `Digits`). Se differisce, `InpBufferPoints` e `InpRetestOffsetPts` vanno riscalati — ✍️ **firma di Claudio**, non un aggiustamento automatico |
| **3** | 🔴 **Ordini rifiutati per margine** (`not enough money`), **non** stop-out. A 1:15 le sette sedie chiedono **121.894 $** a 0,65%: le europee prendono il margine alle 07:00-08:00, le americane trovano il conto pieno alle 14:30-16:30 | 🔴 **alta se il conto è Swing** | 🟠 medio-alto, e **subdolo**: la challenge gira con 3 sedie invece di 7 e il Giornale è l'unico posto dove si vede | leggere la leva vera (**passo 5**) → se è 1:15, **si riduce la rosa PRIMA di accendere**, non dopo. ✍️ Claudio sceglie quali. 📌 E **lo stop-out vero non arriva**: servirebbe equity sotto il 50% del margine (≈ −54%), e il muro del 10% breccia prima |
| **4** | 🟠 **L'F7 fallisce.** **Sei** sorgenti su sei non sono **mai** stati compilati nella forma che va in campo: i tre Apertura con la toppa (HEAD, 19/09), `EMA200` a `26a18566`, `SuperWave` a `872dba82`, `MaxMinNotte_DAX_Short_Ott` a HEAD | 🟠 media | 🟠 medio: si perde tempo, non soldi — 🔴 **ed è la cosa che può far saltare la sera** (§Ⓐ.2) | mandare il testo dell'errore. 🟢 Attenuante misurata: le API usate erano **già tutte presenti** nei file a HEAD, e la stessa forma gira già in campo in `ABTG_ORB_Ottimizzato` v1.04 |
| **5** | 🟠 **Il Guardian conta la giornata sbagliata.** `InpDailyResetHour=23` è tarato su **BCM**. Su un server GMT+3 le 23:00 sono le 21:00 CEST: il contatore del **−5% giornaliero** si azzera **tre ore prima** del reset FTMO | 🟠 media | 🔴 alto **se si perde una giornata brutta**: il Guardian crede che sia un giorno nuovo mentre FTMO conta ancora quello vecchio | **passo 12**: `InpDailyResetHour=1`. 🔴 E resta `[INCERTO]` finché FTMO non conferma per iscritto quale fuso usa per il reset — è scritto **nel preset stesso** |
| **6** | 🟠 **`770202` non apre niente.** Muta dal **28/08**: 15 sedute a secco al 18/09 | 🟢 **alta ma NON è un guasto** | 🟡 basso: la sedia c'è e arma ogni giorno, semplicemente il livello non viene toccato | 🟢 **misurato**: è **solo-long** su un Dow che scende, e la siccità massima del motore nel suo stesso OOS è **23 sedute** (`report/PERCHE_770202_E_MUTA_2026-09-19.md`). 🔴 **Le 23 sedute cadono il 30/09**: quello è il giorno in cui il silenzio smette di essere normale |
| **7** | 🟠 **L'ORO parte al doppio del rischio.** Il preset in repo `sedia_MAXMIN_ORO_770402.set` porta **`InpRiskPercent=1.0`**, ma in campo la sedia gira a **0,5** (`CODA_01` 19/09) e il contratto dice **«prop: solo ≤ 0,5%»** | 🟠 media — **basta caricare il preset senza guardare** | 🔴 alto: DD promesso **19,72%** a 1,0% contro un muro del **10%** | **passo 10**: verificare `InpRiskPercent` a mano, campo per campo. È **due secondi** e vale la challenge |
| **8** | 🟠 **La taglia non è decisa.** A **1,00%** la Monte Carlo di casa dà **p99 = 12,47%** di drawdown contro un muro **statico del 10%** — cioè **lo sfonda più di una volta su cento**; a **0,65%** dà **~8,1%** e non lo sfonda (`report/METRO_PROP.md` rr.24-25, 65-71) | 🔴 aperta | 🔴 totale | ✍️ **solo Claudio**. 📌 E il numero che avevo già dato regge: a **1,30%** la sola `770101` promette **9,40%** (= 7,2328% misurato a 1,0% su banco 100k, scalato ×1,3) contro il muro del 10% — **una sedia sola** |
| **9** | 🟡 **Collisione per simbolo** se uno dei due Apertura va in campo col binario vecchio | 🟢 bassa (la toppa è a HEAD) | 🟠 medio | **passo 8**: se l'F7 è fatto, il problema non esiste. `770411`, `771531`, `770511` sono **sicure di natura** (§3.1) |
| **10** | 🔵 **Una regola FTMO — news, oppure notte/weekend** | 🟢 **ZERO in valutazione**, per tutte e sette e per tutti e due i tipi di conto | — | 🟢 **Fonte 🥇 [POSTATO DA CLAUDIO], schermate FAQ ufficiali del 19/09 23:01-23:02**: *«Non si applicano durante il processo di valutazione… indipendentemente dal tipo di conto»*, e la stessa frase per le **posizioni tenute di notte e nel weekend**. Coincide con `docs/REGOLAMENTO_FTMO_2026-08.md` **r.45**. 🔴 **Nasce sul conto FINANZIATO**, e lì colpisce `771531` e `770511` → §⑤bis |
| **11** | 🟠 **Clausola «gap trading»** (`T-FTMO-2`), l'**unica** che vale anche in Challenge e anche su Swing (`docs/REGOLAMENTO_FTMO_2026-08.md` r.83) | 🟡 bassa ma **non zero** — e **sale la prima notte**, che è una riapertura | 🔴 **squalifica**: è l'unica clausola che uccide un conto che rispetta **tutti** i numeri | tocca 🔴 **`770511`** (nessuna guardia oraria attiva, ha già aperto alle 05:00-06:00 del lunedì) e 🔴 **`771531`** (ha già aperto alle 01:21 e 02:41). 👉 **Contromisura proposta al §Ⓐ.3**: `770511` spenta la prima notte. E la domanda al supporto è **già scritta dal 13/08 e mai inviata** (§⑥ **B4**) |

> ## 🔴 **QUINDI TI CONTRADDICO, COI NUMERI: il primo pericolo NON è lo stop-out per margine.**
> È l'**orologio** (certo, totale, e si chiude in 10 secondi), e subito dopo i **`Digits`** e gli
> **ordini rifiutati**. Lo stop-out per margine, matematicamente, **non può arrivare**: pretende
> un −54% che il muro del 10% rende impossibile. 🟢 **La tua intuizione sul margine era giusta;
> è il MECCANISMO del danno a essere un altro — ed è peggio, perché è silenzioso.**

---

# ⑤bis ⚖️ STANDARD O SWING — **la raccomandazione ha DUE gambe, non una**

🟢 **Niente di questo paragrafo tocca la partenza.** Serve a decidere **adesso** una cosa che morde
**fra settimane**, sul conto finanziato — e che però si compra **prima**, quindi va decisa prima.

Fino a stasera la scelta aveva **una** gamba (le news) e **un** costo (il margine). Le due
schermate FTMO di Claudio ne aggiungono una seconda, e le due gambe colpiscono **esattamente le
stesse due sedie**:

| restrizione | vale su **Standard funded** | vale su **Swing** | quali delle sette colpisce |
|---|---|---|---|
| **News** (±2 min, **incluse le esecuzioni di SL e TP**) | 🔴 **sì** | 🟢 **mai** | `770202` `771531` `770511` `770402` `770260` (strumenti USD/oro **nominati** nella tabella FTMO) — e la più esposta è **`771531`**, che può avere posizione aperta alle 19:00 BCM = ora del FOMC |
| 🆕 **Posizioni tenute di notte e nel weekend** | 🔴 **sì** | 🟢 **mai** | 🔴 **`771531`** (4 notti, 2 weekend su 21 posizioni) e 🔴 **`770511`** (6 notti, 2 weekend su 16). **Le altre cinque: zero e zero** |
| **Margine** | 🟢 indici **1:50** → le sette entrano col **36-56%** del conto | 🔴 indici **1:15**, metalli **1:9** → le sette chiedono **121,9%-187,5%** | **tutte** |

> ## ⚖️ **E QUINDI LE DUE GAMBE TIRANO IN DIREZIONI OPPOSTE, ed è onesto dirlo così.**
> 🟢 **Swing** = zero restrizioni, per sempre, su tutte e sette. 🔴 **Ma a 1:15 la rosa non ci sta:
> ne entrano tre a 0,65%.**
> 🟢 **Standard** = margine comodo, tutte e sette in campo. 🔴 **Ma da funded due sedie
> (`771531`, `770511`) sarebbero in violazione sistematica** sulla notte/weekend, e cinque sono
> esposte alle news.
> 🎯 **La terza via, ed è quella che i numeri suggeriscono**: **Standard**, e le due sedie che
> tengono di notte si affrontano **quando il conto diventa funded** — o spegnendole, o mettendo
> `InpFridayClose=true` su `771531` (la manopola **c'è già** ed è a `false`) e una finestra oraria
> su `770511` (che oggi gira `0-24`). **In valutazione non servono: non c'è nessuna regola.**
> 🔴 **NON LA DECIDO IO.** È una firma di Claudio, ed è **anche una questione di soldi**: Standard
> e Swing costano prezzi diversi. Io porto i numeri, lui porta la firma.

## ⚠️ E UN AVVISO SUL BANNER DELLO SCONTO
Nella schermata compare *«Sconto del 20% — Offerta speciale sulla sfida **1-Step** da 100.000
dollari»*. 🔴 **La 1-Step non è la 2-Step con un passaggio in meno: ha un profilo di rischio
diverso**, e la differenza è scritta in casa:

> *«Max Loss 10% (**2-Step**) — **STATICO**: "equity must not drop below 90% of the initial
> account balance at any given time". (**1-Step** invece: **End-of-Day trailing**, si aggiorna
> alle 23:59:59 CE(S)T solo verso l'alto.)»*
> — `docs/REGOLAMENTO_FTMO_2026-08.md` §2

🔴 **Tutto il nostro metro è tarato sul DD STATICO**: le Monte Carlo di `report/METRO_PROP.md`
danno p99 **12,47%** @1,0% e **~8,1%** @0,65% **su DD statico**, e lo stesso referto dichiara
testualmente che *«con un DD trailing sull'equity quei numeri **non valgono**»*.
👉 **Su 1-Step non sappiamo se passiamo: non l'abbiamo mai calcolato.** Più: la 1-Step ha la
**Best Day Rule 50%**, non ha lo **Swing**, e la fee **non è rimborsata**.
🎯 **Quindi: lo sconto del 20% è su un prodotto che oggi non sappiamo misurare.** Se Claudio lo
vuole valutare, la misura si fa — ma è una misura, non un click.

---

# ⑥ 🕳️ I BUCHI — per nome, con chi li chiude e in quanto tempo

| # | buco | perché costa | **chi lo chiude · in quanto** |
|---|---|---|---|
| 🔴 **B1** | **Standard o Swing? E qual è la leva vera?** In repo **non esiste nessuna prova d'acquisto FTMO**. Tutto il §② poggia sull'inferenza *«1:15 ⇒ Swing»* | 🔴 **decide se la rosa è di 7 sedie o di 3.** È il buco più caro del pacchetto | ✍️ **Claudio** · **30 secondi**: screenshot della dashboard FTMO (tipo conto + leva) oppure la mail d'ordine |
| 🔴 **B2** | **Le specifiche di contratto FTMO non le abbiamo MAI lette**: contract size, Digits, Point, Initial margin, tick value | 🔴 rende `[INFERITO]` **tutta** la tabella del margine **e** i buffer in punti del §⑤.2 | ✍️ **Claudio** · **2 minuti**: 4 screenshot da Market Watch → Specification (**passo 5**). 🤖 io rifaccio la tabella in 10 minuti |
| 🔴 **B3** | **LA TAGLIA.** `InpRiskPercent` per sedia: **[NON DECISA]** | 🔴 blocca il passo 10 dell'accensione | ✍️ **Claudio, esclusivo.** 📌 I numeri sul tavolo, già misurati: 0,65% → p99 8,1% 🟢 · 1,00% → p99 12,47% 🔴 · 1,30% → `770101` da sola promette 9,40% 🔴. **La mia proposta resta 1,00% come TETTO, e resta una proposta** |
| 🔴 **B4** | **Le domande al supporto FTMO sono pronte dal 13/08 e MAI INVIATE** (`report/DOMANDE_SUPPORTO_PROP.md` r.3: *«DECISIONE DI CLAUDIO (13/08): INVIO RINVIATO»*). Sono tre: **gap trading**, **bracket OCO**, **conti multipli** | 🔴 la clausola gap trading può squalificare un conto che rispetta **tutti** i numeri; e il 18/09 abbiamo già pagato una volta il prezzo di non aver verificato (breach FundedNext) | ✍️ **Claudio, dal suo account** · **10 minuti per inviarle**, 1-3 giorni per la risposta. 🔴 **Il testo è già scritto: va solo incollato.** Regola di casa `PIANO_PROP.md` F4: niente acquisti senza risposte scritte — **aperta dal 13/08** |
| 🔴 **B5** | **`770202` non opera dal 28/08.** 15 sedute mute al 18/09 | 🟢 **non è un guasto**, è misurato: sedia **solo-long** su un Dow che scende, record di siccità del motore **23 sedute** | 🤖 **già chiuso come diagnosi** (`report/PERCHE_770202_E_MUTA_2026-09-19.md`). 🔴 **Resta la data**: le 23 sedute scadono il **30/09**. Se quel giorno è ancora muta, si riapre — e allora **non** è più il mercato |
| 🔴 **B6** | **Il `.set` di `770260` NON è in repo.** `grep -rln "770260" --include=*.set` su tutto l'albero = **0 file**, benché il referto del 19/09 lo descriva input per input (*«80 input, nessun valore sbagliato, copertura verificata nei due versi»*) | 🔴 **bloccante**: Claudio ha firmato *«Sì, dentro il 770260 RETEST»* e senza il `.set` quella sedia **non si accende**. Ricostruirla a mano dagli 80 input è esattamente il modo in cui si sbaglia un preset | 🤖 **chi ha prodotto il `.set`** (sessione del 18-19/09) deve **committarlo su `lavoro`** · **minuti**. 🔴 **È il buco più corto da chiudere e il più stupido da lasciare aperto** |
| 🟠 **B7** | **Il conteggio righe atteso dei file da copiare sul terminale FTMO non è ancora scritto da nessuna parte.** Senza, il passo 6 non è verificabile | 🟠 non si può dire *«la copia è riuscita»* | 🤖 **io**, appena esiste la cartella bersaglio · minuti. 📌 I numeri noti: `DAX_Apertura_EU` **2425** (`CODA_06` 2426) · `Dow_Apertura_US` **2205** (2206) · `Nasdaq_Apertura_US` **2624** (2625) · `EMA200` **552** (553) · `SuperWave_DOW_H1_Ott` **645** (646) · `MaxMinNotte_DAX_Short_Ott` **619** (620) · `ABTG_PausaGuardian.mqh` **398** (399) |
| 🟠 **B8** | **Il bersaglio di `770402` non è deciso**: il vintage in campo ha il **breakeven cieco** (rischio attivo), HEAD **cambia la frequenza** del contratto | 🟠 una sedia su sette resta indecisa | ✍️ **firma di Claudio** per autorizzare una corsa di controllo sulla macchina di backtest **50504400** (`C:\MT5_Backtest`) + 🤖 la corsa · **minuti di macchina** |
| 🔴 **B9** | **Quanto cambiano le taglie di `771531` e `770511` dopo l'F7** è **[NON MISURATO su `U30USD`]**: uno porta `OrderCalcProfit`, l'altro il pavimento del lotto. 🛑 **E per questo il pacchetto di compilazione è in HOLD**: la firma di Claudio copriva *«compila»*, non *«e la taglia cambia»* (`report/FIRME_2026-09-19_SERA.md` §③) | 🔴 **blocca due F7 su sei.** Senza il sì esplicito, `771531` e `770511` non si ricompilano — e col binario vecchio `770511` piazza `totLot + volMin`, cioè **più lotti del dichiarato**, su un conto prop | ✍️ **Claudio: una riga di sì.** 🤖 la misura è **già in preparazione** da un altro agente (`backtest_pipeline/righe/MISURA_LOTTI_U30USD.ps1`) — **non la rifaccio e non tocco quei file**. ⚠️ Il suo piano è già stato corretto una volta: **classe 470** (il ramo vecchio non scrive il per-trade, `ExportTrades` nasce dopo) |
| 🟠 **B10** | **Il DAX è "targeted" da FTMO per la BCE?** La nostra risposta «no» è un'inferenza **per assenza** dalla tabella che Claudio ha copiato dal sito il 04/09 | 🟠 se lo fosse, `770101` e `770411` diventano esposte **da funded** (BCE 13:15 BCM cade nella loro finestra) | ✍️ **Claudio / supporto** · una riga dentro la mail di B4: *«Is GER40/DE40 a targeted instrument for the ECB Main Refinancing Rate restriction?»* |
| 🟠 **B11** | **1:9 su Swing = metalli o alcuni indici?** Due nostri file si contraddicono allo stesso rango (`docs/REGOLAMENTO_FTMO_2026-08.md` r.131 dice *metalli*; `report/QUALE_PROP_PER_I_NOSTRI_EA_2026-09-18.md` r.158 dice *HK50/US2000/SPN35*) | 🟠 sull'oro cambia il margine di **1,67×** (5.684 → 9.474 a 0,65%) | ✍️ **Claudio** con lo stesso screenshot di B2 · incluso |
| 🔵 **B12** | **Nessun `.ex5` è verificato crittograficamente**: l'identificazione dei binari è circostanziale forte (righe univoche + versione + finestra temporale), non un hash | 🔵 sul terminale FTMO **il buco non esiste**: là compiliamo noi da zero | — |

---

# ⑦ 📌 IN UNA RIGA

**La rosa firmata è di SETTE sedie. Domenica notte ne sono schierabili CINQUE** — `770101` · `770411` ·
`770202` · `771531` · `770511` — **e tutte e cinque hanno bisogno della stessa identica cosa: una
copia e un F7 su un terminale che oggi non esiste.** `770402` aspetta una misura, **`770260`
aspetta un file `.set` che qualcuno ha scritto e non ha committato**, `770261` è fuori per merito.
🔴 **Ma quante ne regge il conto non lo decide questa tabella: lo decide la leva.** A **1:15** ne
entrano **tre** a 0,65% e **due** a 1,00%. A **1:50** entrano tutte e sette con il 36% del conto
impegnato.
🎯 **Quindi la cosa più preziosa che Claudio può fare domenica sera, prima di ogni F7, è aprire
Market Watch e fare due screenshot: l'orologio e le specifiche di contratto.** Trenta secondi che
valgono più di tutta la notte di lavoro che c'è dietro questo file.

🟢 **E la cosa che toglie ansia, perché è misurata e non detta per consolare: domenica notte non
si opera.** Nessuna sedia della rosa ha mai aperto di domenica, zero volte su 96 posizioni. La
catena di accensione costa **75-125 minuti** e il primo appuntamento vero è **lunedì alle 07:00
server FTMO** *(l'oro)*. 👉 **La notte è un cuscinetto, non una scadenza** — e l'unica cosa che
la può far saltare è un F7 che non compila o un `.set` che non arriva.

---

## 📒 CHANGELOG

| data | cosa | perché |
|---|---|---|
| **20/09/2026 (notte)** | prima stesura | sintesi operativa delle misure del 19/09, ridotta a una lista da spuntare |
| — | ✏️ **corretto** il riferimento `QUALE_PROP…` rr.190-197: il *«~67.000 $ = 67%»* usa `U30USD` a **46.012** e `NASUSD` a **~21.000**, contro prezzi veri **53.200** e **29.474** | il margine vero è **più alto**, non più basso (§2.4) |
| — | ✏️ **contraddetta** l'ipotesi *«il primo rischio è lo stop-out per margine»* | lo stop-out pretende equity < 50% del margine (≈ −54%): il muro del 10% breccia prima. Il danno vero è l'**ordine rifiutato** (§⓪.③, §⑤.3) |
| — | 🆕 **alzato al primo posto** il fuso server FTMO (BCM+2) | è l'unico rischio **certo** della lista, e nessun referto precedente lo aveva messo in cima |
| **20/09/2026 (notte, 3ª passata)** | 🔴 **CAMBIO DI DATA: si parte DOMENICA NOTTE 20/09, non lunedì.** Aggiunto il **§Ⓐ** (cronologia coi minuti, stima del cammino critico **75-125 min**, analisi della riapertura domenicale) e portata **in cima** la tabella del margine | Claudio, 19/09 notte: *«Io pagherò la challenge e si inizia domani notte. Prepara tutto»* |
| — | 🆕 **misurata** la domanda *«chi può aprire alla riapertura?»* su sorgenti **e** campo: 🟢 cinque sedie su sette **non possono** (orario fisso nel preset) · 🔴 `770511` e `771531` **possono, e lo hanno già fatto**, con date e ore in mano | è la zona grigia del **gap trading**, l'unica clausola FTMO che vale anche in Challenge |
| — | 🆕 **raccomandazione** (non divieto): `770511` spenta la prima notte; `771531` **no**, e con la ragione scritta | la manopola `InpUseTimeWindow` di `770511` è a `false` di default e **non sta in nessun preset**: la sua libertà oraria non è una scelta, è una dimenticanza |
| — | ✏️ **CORRETTO `report/TOPPA_TICKET_A_HEAD_2026-09-19.md`**: la frase *«nessuna delle sei sedie resta col difetto»* **omette `ABTG_MaxMinNotte.mq5` (`770402`)**, che ha **4 occorrenze** di `PositionClose(_Symbol)` in codice eseguibile (rr. 251, 454, 455, 490) | 🟢 danno pratico **zero** sul conto prop (`770402` è sola su `XAUUSD`), ma il conteggio era sbagliato e va scritto (§3.3) |
| **20/09/2026 (notte, 2ª passata)** | **`770260` RETEST entra nella rosa** (firma di Claudio: *«Sì, dentro il 770260 RETEST»*), con **merito sospeso per campione** scritto accanto al nome. `770261` resta fuori per merito | la rosa passa da 6 a **7** sedie. 📌 La tabella del margine **conteneva già** `770260`: i totali del §② non cambiano |
| — | ✏️ **CORRETTA una lettura del referto Nasdaq** che mi era stata passata: il *«due vie `770250`↔`770261`»* di r.104 riguarda le **stringhe di commento**, non la `PositionClose(_Symbol)`. Nella chiusura per simbolo **`770260` è dentro la collisione**, non fuori | 🟢 la conclusione regge lo stesso, **ma per un'altra ragione**: `770250` non va sul conto prop (§3.0). Una conclusione giusta con la ragione sbagliata è una trappola per il prossimo che legge |
| — | 🆕 aggiunta la colonna **«tiene posizioni oltre la giornata?»** e il §⑤bis **Standard vs Swing a due gambe** | due schermate della FAQ FTMO ufficiale postate da Claudio il 19/09 alle 23:01-23:02 🥇 **[POSTATO DA CLAUDIO]**: confermano le news e aggiungono la restrizione **notte/weekend**, che nessun referto aveva messo a fuoco |
| — | 🆕 avviso sulla **1-Step scontata del 20%**: Max Loss **trailing End-of-Day** invece che statico | tutto il nostro metro (`METRO_PROP.md`) è tarato su DD **statico**, e quel referto dichiara che su trailing *«quei numeri non valgono»* |

---
*Fonti, per nome: `report/LA_ROSA_PER_LA_PROP_2026-09-19.md` · `report/I_BINARI_DELLA_ROSA_2026-09-19.md` ·
`report/LE_PROP_E_GLI_EA_COSA_SAPPIAMO_2026-09-19.md` · `report/ALLARGARE_LA_ROSA_2026-09-19.md` ·
`report/DUE_SEDIE_NASDAQ_IL_BLOCCO_2026-09-19.md` · `report/COMPILAZIONE_771531_770511_2026-09-19.md` ·
`report/TOPPA_TICKET_A_HEAD_2026-09-19.md` · `report/FIRMA_2026-09-19_CHIUSURA_PER_TICKET.md` ·
`report/PERCHE_770202_E_MUTA_2026-09-19.md` · `report/CONTRATTI_SEDIE.md` · `report/METRO_PROP.md` rr.24-25 e 65-71 ·
`report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` rr.396/404/406/462 · `report/ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` rr.407-413 ·
`report/QUALE_PROP_PER_I_NOSTRI_EA_2026-09-18.md` rr.150-197 · `report/DOMANDE_SUPPORTO_PROP.md` ·
`docs/REGOLAMENTO_FTMO_2026-08.md` rr.45, 48, 57, 130, 131 · `data/statements/trades_auto.csv` (prezzi e P/L veri) ·
`backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260919_033003.log` (TF e rischio in campo) ·
`mql5/Presets/sedie_piccolo/recupero2/*.set`, `mql5/Presets/sedie_piccolo/sedia_MAXMIN_ORO_770402.set`,
`mql5/Presets/ABTG_Guardian_FTMO_2Step.set` (orari e taglie, letti riga per riga).*
