# 📰🪑 PACCHETTO POSTNEWS — I TRE GRAFICI (FOMC · ECB · NFP)

**19/09/2026** · controllo-preventivo · branch `lavoro`
**Richiesta di Claudio, testuale**: *«Un'altro ea che dobbiamo avere é post news e
caricare i 3 grafici con i 3 preset FOMC, ecb, us employment»*

> ## 🔴 LEGGI QUESTE TRE RIGHE PRIMA DI TUTTO IL RESTO
> 1. **Il magic era in collisione, ed era una CANCELLAZIONE, non una confusione di
>    referti**: con i due grafici EURUSD accesi insieme, la sedia **FOMC non avrebbe
>    operato MAI**. 🟢 **Corretto in questo pacchetto**: `ECB_EURUSD` passa da
>    `771202` a **`771204`**.
> 2. **La sedia NFP, com'è scritto il preset oggi, è CIECA in campo** — punta a un
>    calendario che finisce il **03/07/2025** e che nessuno aggiorna. 🔴 **Non
>    corretta qui**: è una decisione, ed è il punto ① di «cosa deve fare Claudio».
> 3. **Le tre sedie entrano senza PF, senza DD e senza campione.** Non è un modo di
>    dire: i CSV in `risultati_prove/ABTG_PostNews/` hanno **`Trades = 0`**. È una
>    scelta legittima di Claudio, ma dev'essere **informata**.

---

# 1. 📋 LA TABELLA DEI TRE GRAFICI

🪟 **Terminale bersaglio: DEMO piccolo `50503392`**, cartella
`C:\Program Files\BCM Markets MT5 Terminal` (quella **SENZA** `-V3`).
🚫 **NON** il 100k `50504263` (`...-V3`) · **NON** il reale `10105439` (`C:\BCM_Reale`)
· **NON** il banco `50504400` (`C:\MT5_Backtest`) · **NON** Pepperstone, **NON** Tickmill.

| # | simbolo | TF | preset | magic | **azione (ORA SERVER)** | = ora IT | scadenza pendenti (server) | **rischio vero/evento** | frequenza attesa |
|---|---|---|---|---:|---|---|---|---:|---|
| 1 | **EURUSD** | M5 | `ABTG_PostNews_FOMC_EURUSD.set` | `771202` | **19:40** ⚠️ | 20:40 | 20:45 (chiude anche la posizione) | **0,65%** | ~8 FOMC/anno = **0,03 op/g** |
| 2 | **EURUSD** | M5 | `ABTG_PostNews_ECB_EURUSD.set` | **`771204`** 🔧 | **14:00** | 15:00 | 17:15 (chiude anche la posizione) | **0,65%** | ~8 BCE/anno = **0,03 op/g** |
| 3 | **USDJPY** | M5 | `ABTG_PostNews_NFP_USDJPY.set` | `771203` | **13:45** | 14:45 | 16:59 pendenti · posizione fino a **21:50** ven | 🔴 **1,30%** | ~12/anno = **0,05 op/g** |

**Ora server BCM = ora italiana − 1** (regola di casa). Tutti e tre i preset hanno già
l'ora **server**, non quella italiana: verificato riga per riga.

⚠️ **La nota sulla riga 1 è una scadenza con una DATA**: `19:40` vale **solo con l'ora
legale italiana**. Il **28/10/2026** (primo FOMC dopo il caricamento) l'Italia è già in
ora solare e gli USA no: l'annuncio arriva alle **19:30 IT**, quindi vanno messi
**`InpActionHour=18` / `InpActionMin=40`** e **`InpExpiryHour=19` / `InpExpiryMin=45`**.
Lo dice già il commento del preset stesso, ed è **corretto**: qui lo si trasforma in una
voce di calendario. *(Italia esce dal DST il **25/10**, gli USA il **01/11**.)*

### 🧮 Il conto della famiglia
Le tre sedie **più** la `771201` ECB EURJPY già viva su `chart43` fanno **~36 eventi
l'anno ≈ 0,14 operazioni/giorno**. 🔴 **Il pavimento di casa è 1,00 op/giorno PER
FAMIGLIA** (firma del 07/09): questa famiglia è **7 volte sotto**. Non è un motivo per
non misurarla su demo; **è un motivo per non contarla come sedia della challenge.**

### 🧮 Il rischio quando si sommano
Le tre non cadono mai lo stesso giorno (BCE = giovedì · FOMC = mercoledì · NFP =
venerdì). Nel caso peggiore aritmetico **0,65 + 0,65 + 1,30 = 2,60%**, sotto il cap
**C1 = 3,25%**. 🟠 **Ma nel giorno di BCE si sommano DUE sedie sullo stesso evento e su
due cambi EUR correlati**: `771201` EURJPY **0,65%** + `771204` EURUSD **0,65%** =
**1,30% su un solo annuncio**.

---

# 2. 🔬 I CINQUE FATTI, VERIFICATI — file e riga

## ① 🔴 COLLISIONE DI MAGIC — **confermata, ed è peggio di come era descritta**

**Chi aveva il numero sbagliato: `ECB_EURUSD`.** L'ipotesi era giusta, e la prova è
nel preset stesso: `ABTG_PostNews_ECB_EURUSD.set` è **nato l'08/09/2026** con
l'intestazione letterale *«NATO PER EVITARE UNA COLLISIONE DI MAGIC»* con la `771201`
EURJPY — e si è preso **`771202`, che è il magic della FOMC**, già viva su `chart44`
del piccolo (`report/CENSIMENTO_CAMPO_VS_MISURATO_2026-09-13.md` r.159).
**La riparazione dell'08/09 ha spostato la collisione, non l'ha tolta.**
La numerazione di casa resta quella di `report/POSTNEWS_NEUTRALIZZATE_2026-09-07.md`:
**`771201` ECB · `771202` FOMC · `771203` NFP**. Quindi la FOMC tiene il suo numero, e
la ECB EURUSD — che è una sedia **nuova** — ne prende uno libero.

### 🔴 Cosa sarebbe successo davvero, letto nel sorgente
Non «statistiche fuse». In `mql5/Experts/ABTG_PostNews.mq5` **ogni** funzione di
gestione seleziona per **simbolo + magic e basta**: guardia anti-duplicato r.245-249 ·
`OcoCheck()` r.364 · `ManageTrailing()` r.389 · `CloseAllMine()` r.414 ·
`ExpiryCloseCheck()` r.439. E `ExpiryCloseCheck` **non è un istante, è una finestra**:

```
r.447:   if(nowMin < expMin) return;      // ... e sotto: CloseAllMine()
```

cioè **dall'orario di scadenza fino a mezzanotte, a OGNI TICK**.

| | |
|---|---|
| la **ECB** EURUSD scade alle | **17:15 server** (`InpCloseAtExpiry=true`) |
| la **FOMC** EURUSD piazza alle | **19:40 server** |
| ⇒ | 🔴 **i due pendenti della FOMC nascono DENTRO la finestra di pulizia della ECB e vengono cancellati entro un tick** |

👉 **Con i due grafici accesi insieme — che è esattamente quello che Claudio ha
chiesto — la sedia FOMC non avrebbe mai operato**, e nel log non sarebbe comparso
nessun errore: solo un `OCO/scadenza: cancellata…`.

### 🔧 LA MODIFICA FATTA, dichiarata
`mql5/Presets/ABTG_PostNews_ECB_EURUSD.set` → **`InpMagic=771202` ⟶ `InpMagic=771204`**
(+ commento di testa aggiornato con la ragione).
- **`771204` è libero**: cercato su **tutto** il repo — **0 occorrenze**, tranne la
  riga di `report/DA_FIRMARE.md` r.151 che lo **proponeva già** il 10/09. Nessuno l'ha
  mai usato.
- 🔴 **È un identificativo, non una taglia.** Nessun numero di rischio è stato toccato.
- 📌 **Conseguenza da sapere**: la ECB EURUSD non ha **nessuna** operazione storica
  (zero, verificato) — quindi cambiarle il magic **non spezza nessuna statistica**.
  Questo è il momento giusto per farlo: fra un mese non lo sarebbe più.
- 🔴 **E RESTA IN ATTESA DI FIRMA, e lo dichiaro invece di farla passare.**
  `report/DA_FIRMARE.md` r.152-153: *«resta di Claudio, perché un magic identifica
  una sedia e cambiarlo significa che le operazioni vecchie e nuove non si sommano
  più nelle statistiche»*. Il file è **inerte** finché nessuno carica quel preset su
  un grafico: **nessuna sedia viva è stata toccata**. Se Claudio preferisce un altro
  numero, si cambia una riga.

### 🔎 E IL CENSIMENTO DI TUTTI GLI ALTRI PRESET, come chiesto
**64 preset con `InpMagic`, 55 magic distinti.** Dopo la correzione restano **8** numeri
condivisi. Ognuno passa **due** domande, non una: *stesso simbolo?* e *accendibili
insieme?* Solo SÌ+SÌ è rosso.

| magic | preset | stesso simbolo? | accendibili insieme? | verdetto |
|---:|---|---|---|---|
| `770101` | `DAX_Apertura_EU_D30EUR_M5_770101_100K` · `DAX_Apertura_EU_LEGACY_2pct` | sì (D30EUR) | **no** — `LEGACY` è la versione superata | 🟢 benigno |
| `770201` | `Apertura_Nasdaq_US_H4` · `Nasdaq_Apertura_US` | **sì** (NASUSD, stesso EA) | **no** — sono la stessa sedia con/senza filtro H4 | 🟠 **trappola latente**: se un giorno si vogliono confrontare «cieco vs H4» sullo stesso conto, si ricade nel caso ① |
| `770202` | `Dow_Apertura_US_U30USD_M5_770202_100K` · `Nasdaq_GapFill` | **no** (U30USD vs NASUSD) e **EA diversi** | sì | 🟠 **referti fusi**: due sedie diverse sotto un numero. `770202` è **viva sul 100k** |
| `770401` | `MaxMinNotte_DAX` · `MaxMinNotte_EURUSD` | no (D30EUR vs EURUSD), stesso EA | **sì** | 🟠 **referti fusi** — è la stessa forma che l'08/09 aveva fatto nascere il preset ECB EURUSD |
| `770901` | `SupertrendReversal_225JPY_H2_770901_100K` · `SupertrendReversal_H4` (generico) | dipende dal simbolo su cui si attacca il generico | sì | 🟠 rosso **se** il generico finisce su 225JPY dello stesso conto |
| `771203` | `PostNews_NFP_USDJPY` · `PostNews_NFP_USDJPY_LIVE_2026-09-04` | sì | **no** — il `_LIVE_` è la fotografia di una singola osservazione | 🟢 benigno |
| `771701` | `Nightly` (generico) · `Nightly_EURUSD` | no se il generico va su altri cross | **sì** | 🟠 **referti fusi** su più cambi |
| `779001` | `Guardian_50504263_779001_VIVO` · `Guardian_FTMO_2Step` | conti diversi | no | 🟢 benigno |

👉 **Nessun altro caso 🔴.** I quattro 🟠 non cancellano ordini (simboli diversi ⇒ la
guardia per simbolo li separa): **sporcano i referti**, ed è un costo reale ma non
urgente. Il solo che merita una riga in agenda è **`770202`, perché è viva**.
📌 Classi nuove aggiunte: **472** e **473** in `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`.

---

## ② 🟢 IL RISCHIO È GIÀ AL METRO DI CASA — aritmetica rifatta nel sorgente

`ABTG_PostNews.mq5` **r.325**: `double lot=LotByRisk(InpRiskRefSLpips*pip);`
`LotByRisk` (r.476-505) dimensiona il lotto perché **la distanza passata** costi
`InpRiskPercent` del **balance**. Gli viene passata `InpRiskRefSLpips = 50`, ma lo stop
davvero piazzato è `InpSLpips = 25` (`CalcLivelli`, r.295-306).
👉 **una gamba stoppata costa esattamente METÀ di `InpRiskPercent`.**

| sedia | `InpRiskPercent` | per gamba | `InpUseOCO` | **rischio vero PER EVENTO** |
|---|---:|---:|---|---:|
| `771202` FOMC EURUSD | 1,30 | 0,65% | ✅ **true** (default r.99, il preset non lo scrive) | **0,65%** |
| `771204` ECB EURUSD | 1,30 | 0,65% | ✅ **true** (default r.99) | **0,65%** |
| `771203` NFP USDJPY | 1,30 | 0,65% | 🔴 **false** (scritto nel preset) | 🔴 **1,30%** = 0,65% × 2 |

**Perché sul NFP si sommano davvero** (e non è teorico): con OCO spento nessuno cancella
la gamba opposta, e `InpCloseAtExpiry=false` lascia correre. Uno spike su, BUY riempito
e stoppato (−0,65%), ritorno giù, SELL riempito e stoppato (−0,65%) = **−1,30%**. È il
comportamento voluto dalla slide (*«non si tocca più niente»*), ed è **dichiarato nel
preset stesso** alle sue righe 71-74. **Non l'ho cambiato**: tocca le taglie.

### 🔴 E il difetto che nessun `.set` può proteggere
`ABTG_PostNews.mq5` **r.113**: `input double InpRiskPercent = 3.0;`
Il **default compilato** è ancora **3,0**, cioè **1,50% per gamba**. Un `Resetta` nella
finestra degli input, o un EA riattaccato senza caricare il `.set`, riarma quel numero.
**Non è un'ipotesi**: il **10/09** la `771201` ha perso **80,90 EUR su 5.427,56 =
1,4905%** contro lo 0,65% del contratto scritto la mattina stessa — il lotto uscito
(**0,58**) era quello del 3,0, non quello dell'1,3 (che dava **0,25**).
📄 `report/POSTNEWS_ECB_ESITO_2026-09-10.md` · `report/DA_FIRMARE.md` §3-bis.
👉 **Voce per Claudio**: portare il default compilato a `1.30` è una ricompilazione e
una firma. Finché non si fa, **il `.set` va ricaricato a mano a ogni riattacco**.

---

## ③ 🔴 LA DIPENDENZA DAL CALENDARIO — ricostruita anello per anello

Tutti e tre hanno `InpRestrictToNews=true`. Senza calendario **non parte un solo
ordine**, e il sorgente lo dice in faccia (r.544-548):
> *«CALENDARIO CIECO … NON verrà piazzato UN SOLO ORDINE: una passata così NON misura
> la strategia, misura il nulla. NON leggerla come "niente edge".»*

### La catena, per intero
| anello | cosa fa | stato misurato |
|---|---|---|
| 1 | GitHub Action `news-export.yml`, cron **`40 4 * * *` UTC** (= 06:40 IT) → scrive `data/abtg_news.csv` | 🟢 **lo `schedule` c'è** (aggiunto il 19/09, classe 460) |
| 2 | `agent/news_export.py` → **solo** `ff_calendar_thisweek.json`; `nextweek` e `lastweek` **404** | 🟠 il calendario copre **solo la settimana in corso** |
| 3 | `data/abtg_news.csv` in repo | 🟢 **non è più vuoto**: commit `f6b276e4`, **16 eventi 14→18/09** |
| 4 | attività VPS `ABTG_AggiornaNews` **07:20 IT** → `aggiorna_news.ps1` → scrive **`<piccolo>\MQL5\Files\abtg_news.csv`** (r.104) | 🟠 **non verificabile da qui** (vedi §4) |
| 5 | l'EA ricarica il file **una volta al giorno**, al **primo tick di un giorno nuovo** (r.228-230) | 🟢 letto nel sorgente |

### 🎯 IL PRIMO MOMENTO IN CUI UNA DELLE TRE PUÒ RESTARE CIECA
**Passo 5 è il collo di bottiglia**: l'EA ricarica al **primo tick del giorno server**
(≈ 00:0x), cioè **PRIMA** che il task delle 07:20 abbia girato. 👉 **il calendario che
l'EA usa il giorno D è quello scaricato il giorno D−1.**
Poiché `thisweek` ruota la **domenica**, ogni giorno feriale è coperto dallo scarico del
giorno prima — **tranne il LUNEDÌ**, che dipende dallo scarico della **domenica 06:40 IT**,
cioè ~40 minuti dopo il cambio settimana di Forex Factory (domenica 00:00 ET = 06:00 IT).
🔴 **Un evento di LUNEDÌ è il caso che può cadere nel buco.**

> ## 🟢 E PER QUESTE TRE SEDIE QUEL BUCO NON MORDE, ED È UN FATTO DI CALENDARIO
> **BCE = giovedì. FOMC = mercoledì. NFP = venerdì.** Nessuna delle tre ha **mai** un
> evento di lunedì. Il buco del lunedì esiste, va scritto, e **non le tocca**.

### 📅 E QUANDO SPARANO DAVVERO
| sedia | prossimo evento | giorno |
|---|---|---|
| NFP `771203` | **venerdì 02/10/2026** | primo venerdì del mese |
| FOMC `771202` | **mercoledì 28/10/2026** | ⚠️ quello che vuole `18:40/19:45` |
| ECB `771204` | **giovedì 29/10/2026** | |

🟢 **Nella settimana del 21/09 non c'è NESSUN evento per nessuna delle tre.**
👉 **Risposta secca alla domanda «il calendario regge lunedì?»: SÌ — ma perché lunedì
non c'è niente da prendere.** Il primo banco di prova vero è **venerdì 02/10**, ed è la
sedia che oggi è cieca per un'altra ragione (punto ⓪ qui sotto).

### 🟢 Due cose che invece TORNANO, e vanno dette
- **Il filtro per titolo non può sbagliare per queste due sedie.**
  `agent/news_export.py` `_normalize_title()` (r.134-141) **garantisce** la parola
  `ECB` nel titolo di ogni evento EUR di politica monetaria e `FOMC` in ogni evento USD
  sui tassi (`ECB_KEYS` / `FOMC_KEYS`, r.52-54): *«ECB - Main Refinancing Rate»*,
  *«FOMC - Federal Funds Rate»*. `InpNewsTitleMatch=ECB` / `=FOMC` **combaciano per
  costruzione**, non per fortuna.
- **L'impatto torna**: `collect_news(keep_impacts=("High",))` tiene solo `High`, e
  `InpNewsMinImpact=3` = High. 🟢 Nessuna riga scartata per impatto.
- **Il fuso del CSV è irrilevante**: `NewsToday()` (r.263-277) confronta **solo
  anno/mese/giorno**, e questi eventi stanno fra le 14:15 e le 20:30 italiane — lontani
  dalla mezzanotte. 🟢 Nessun rischio di scivolamento di data.

---

## ⓪ 🔴 IL SESTO FATTO, CHE NON ERA NEL MANDATO E CHE VALE PIÙ DEGLI ALTRI
### **`ABTG_PostNews_NFP_USDJPY.set` NON PUÒ OPERARE IN CAMPO. MAI.**

```
ABTG_PostNews_NFP_USDJPY.set  r.89-90:
    InpNewsFile=abtg_news_postnews_2010_2025_UTC.csv
    InpNewsCommon=true
```

| misura | valore |
|---|---|
| righe del file | **600** |
| **ultimo evento** | **`2025.07.03`** |
| **eventi del 2026** | **ZERO** |
| chi lo aggiorna | 🔴 **nessuno** — `aggiorna_news.ps1` r.104 scrive **solo** `abtg_news.csv` |

`NewsToday()` confronta la data dell'evento con la barra d'azione: nel 2026 **non può
mai combaciare** ⇒ `OnTick()` r.251 esce ⇒ **zero ordini, per sempre.**

🔴 **E il canarino dell'EA non se ne accorge.** `LoadNews()` grida `CANARINO ROSSO`
(r.589) solo se gli eventi **utili** sono zero: qui sono **186** (le «Unemployment Rate»
dal 2010 al 2025), **tutte passate**. Il controllo misura *«il file contiene eventi per
questo preset»*, non *«contiene eventi che possono ancora accadere»*.
👉 **In avvio l'EA stamperebbe una riga tranquillizzante**, e la sedia sarebbe morta.

⚠️ **L'altro preset NFP ha lo stesso difetto in un'altra forma**:
`ABTG_PostNews_NFP_USDJPY_LIVE_2026-09-04.set` punta a `abtg_news_live_2026-09-04.csv`,
**un file con una data sola** — ed è per di più uno dei tre **svuotati** il 07/09
(`report/POSTNEWS_NEUTRALIZZATE_2026-09-07.md`).
👉 **Nessuno dei due preset NFP legge il calendario che si aggiorna ogni mattina.**

🚫 **Non l'ho corretto io**, perché cambiare quale calendario legge una sedia è una
decisione di comportamento, non un refuso. **La correzione è di due righe** ed è al
punto ① di §4.

---

## ④ 🟠 DOVE LEGGE IL FILE — `Common\Files` **prima** della sandbox

`ABTG_PostNews.mq5` **r.88**: `input bool InpNewsCommon = true;` — e **né il preset ECB
né quello FOMC scrivono questo input** ⇒ **vale il default `true`** ⇒ `LoadNews()`
(r.532-540) prova **prima `Common\Files`**, e solo se fallisce ripiega sulla sandbox.

🔴 **E `aggiorna_news.ps1` non scrive MAI in `Common\Files`**: il suo bersaglio è
`$DataFolder\MQL5\Files\abtg_news.csv` (r.102-104). Quindi:

| se in `Common\Files` c'è `abtg_news.csv`… | …le due sedie leggono un file **che nessuno aggiorna** |
|---|---|
| se **non** c'è | ripiegano sulla sandbox ⇒ 🟢 leggono quello fresco delle 07:20 |

**Cosa sappiamo, e cosa no.** Il **07/09** è stato **misurato** che
`Common\Files\abtg_news.csv` **non esiste** (lì c'era solo `abtg_news_live_2026-09-04.csv`)
— quindi allora il ripiego funzionava. 🔴 **Da qui non posso verificare com'è oggi**:
nessun referto in repo riporta il contenuto di `Common\Files` al 19/09 (vedi §5, buco 2).

👉 **La verifica costa zero e la fa l'EA da solo.** All'avvio stampa:
```
[PostNews][NEWS] letto da <Common\Files | MQL5\Files (sandbox)> | righe N | UTILI per questo preset N | dal .. al ..
```
**Se dice `Common\Files`, il file va guardato.** Se dice `MQL5\Files (sandbox)`, è
quello aggiornato stamattina. 📌 La correzione definitiva è una riga —
`InpNewsCommon=false` nei due preset — ma è un cambio di comportamento: **proposta, non
applicata** (punto ② di §4).

---

## ⑤ 🎭 L'IRONIA FTMO — detta con la struttura giusta, senza allarmismo e senza sconti

I tre eventi che queste sedie cercano sono **esattamente tre voci** della tabella degli
eventi ristretti FTMO (`docs/REGOLAMENTO_FTMO_2026-08.md` r.50-71, copiata da Claudio
da ftmo.com il 04/09):

| valuta | voce ristretta | la nostra sedia |
|---|---|---|
| **USD** | *Federal Funds Rate & Statement* | FOMC `771202` |
| **EUR** | *ECB Main Refinancing Rate* | ECB `771204` |
| **USD** | *Non-Farm Employment Change* · *Unemployment Rate & Wages* | NFP `771203` |

- 🟢 **In Challenge e Verification: NESSUNA restrizione, per nessun tipo di conto.**
  Testuale FTMO: *«Restrictions… apply only once you start trading on an FTMO Account.
  They do not apply during the Evaluation Process.»* 👉 **Per la challenge del 1°
  ottobre non c'è niente da decidere.**
- 🟢 **Su conto Swing: nessuna restrizione news, mai.**
- 🔴 **Su Standard da funded: sono la definizione del divieto.** Finestra **−2 / +2
  minuti** attorno all'annuncio, e *«if a Stop Loss or Take Profit is triggered within
  the restricted time window, this will also be considered a breach»*.

### 🟢 E QUI C'È UNA MISURA CHE MIGLIORA IL QUADRO — l'ho cercata provando a romperlo
La finestra vietata è **±2 minuti**. Le nostre tre sedie agiscono **molto dopo**:

| sedia | annuncio | azione | **distanza** |
|---|---|---|---:|
| ECB | 14:15 IT (tasso) · 14:45 IT (conferenza) | 15:00 IT | **+45 / +15 min** |
| FOMC | 20:00 IT (tasso) · 20:30 IT (conferenza) | 20:40 IT | **+40 / +10 min** |
| NFP | 14:30 IT | 14:45 IT | **+15 min** |

👉 **Nessuna delle tre apre dentro la finestra vietata**, nemmeno su Standard funded: il
meccanismo è *post*-news per costruzione. 🔴 **Quello che resta scoperto è l'altra metà
della regola**: uno **SL o TP che scatta** dentro i ±2 minuti di un *altro* evento
ristretto sullo stesso strumento, mentre la posizione è ancora aperta (la ECB tiene
fino alle 18:15 IT, la FOMC fino alle 21:45, la **NFP fino alle 22:50**). 🔴 **Non è
stato misurato quante volte accade**, e con la NFP che resta aperta 8 ore è il caso da
guardare per primo il giorno in cui si passa a un conto funded Standard.

---

# 3. 🛠️ COSA DEVE FARE CLAUDIO — passo per passo

> 🪟 **Tutto quello che segue è sul terminale DEMO piccolo `50503392`**, cartella
> `C:\Program Files\BCM Markets MT5 Terminal` (**senza** `-V3`).
> 🚫 Non si tocca il **100k `50504263`**, non si tocca il **reale `10105439`**
> (`C:\BCM_Reale`), non si tocca il banco **`50504400`** (`C:\MT5_Backtest`).
> ✋ Per riconoscere la finestra **non a occhio**: in PowerShell sul VPS
> `Get-Process terminal64 | select Id, MainWindowTitle, Path` — PID, titolo e cartella
> stampati, così il riconoscimento è un fatto e non un'inferenza.

### ① 🔴 PRIMA DI TUTTO — decidere sul calendario della NFP *(serve una firma)*
La sedia NFP **non può operare** finché legge `abtg_news_postnews_2010_2025_UTC.csv`.
Due strade, e la scelta è di Claudio:
- **A — puntarla al calendario vivo** *(consigliata)*: nel preset,
  `InpNewsFile=abtg_news.csv` e `InpNewsCommon=false`. ⚠️ Va poi **verificato in avvio**
  che gli eventi utili siano `>0` sul file fresco: il titolo cercato è
  `Unemployment Rate`, e **da qui non posso confermare** che Forex Factory lo pubblichi
  come `High` (il feed è bloccato in questo ambiente — §5, buco 1).
- **B — caricarla lo stesso e sapere che è muta**: legittimo se lo scopo è provare il
  resto della catena, **ma allora non è una sedia, è un banco di prova.**
🚫 Finché non si decide, **il verdetto su `771203` è `[NON ANCORA MISURATO]`**, mai
«non opera».

### ② 🟠 Decidere su `InpNewsCommon` per ECB e FOMC
Metterlo a `false` nei due preset toglie l'ambiguità e li incolla al file che il task
delle 07:20 aggiorna davvero. **Proposto, non applicato.** In alternativa: caricare, e
poi **leggere la riga `letto da …`** del log (passo ⑥).

### ③ 📥 Aggiornare i preset sul VPS
I `.set` corretti stanno su `lavoro`. **Il magic della ECB EURUSD è cambiato**: se nella
cartella `MQL5\Presets` del piccolo c'è una copia vecchia, va **sostituita**, altrimenti
si ricarica il `771202` e la collisione torna.

### ④ 🪟 Attaccare i tre EA — **uno per grafico, e il preset si carica SEMPRE a mano**
| grafico | preset da caricare | controllo in F7 prima di premere OK |
|---|---|---|
| **EURUSD M5** | `ABTG_PostNews_FOMC_EURUSD.set` | `InpMagic` = **771202** · `InpActionHour` = **19** |
| **EURUSD M5** *(secondo grafico)* | `ABTG_PostNews_ECB_EURUSD.set` | `InpMagic` = **771204** · `InpActionHour` = **14** |
| **USDJPY M5** | `ABTG_PostNews_NFP_USDJPY.set` | `InpMagic` = **771203** · `InpActionHour` = **13** |

🔴 **`InpRiskPercent` deve leggere `1.3` in tutti e tre.** Se legge `3` il preset non è
stato caricato: è il default compilato (r.113), ed è il numero che il 10/09 è costato
**1,49%** invece dello 0,65%. **Non premere OK finché non dice 1.3.**

### ⑤ ✅ Controllare che i magic siano DAVVERO tre diversi
Aperti i tre F7: **771202 · 771204 · 771203**. Se due coincidono, **staccare e
ricominciare**: due sedie sullo stesso simbolo con lo stesso magic si cancellano gli
ordini a vicenda (§2 ①).

### ⑥ 🔎 Leggere la riga del calendario nella scheda **Esperti**, per ognuno dei tre
```
[PostNews][NEWS] letto da ... | righe N | UTILI per questo preset N | dal ... al ...
```
| cosa si legge | cosa vuol dire |
|---|---|
| `letto da MQL5\Files (sandbox)` | 🟢 è il file aggiornato stamattina |
| `letto da Common\Files` | 🟠 **va guardata la data del file**: nessuno lo aggiorna |
| `dal … al …` con l'ultima data **nel 2025** | 🔴 **sedia cieca** — è il caso della NFP |
| `UTILI … 0` + `CANARINO ROSSO` | 🔴 filtro sbagliato o file che non copre il periodo |
| `CALENDARIO CIECO` | 🔴 il file non esiste in nessuna delle due cartelle |

### ⑦ 📅 SEGNARE SUL CALENDARIO — **lunedì 26/10**
Prima del FOMC del **28/10**: nel preset FOMC mettere `InpActionHour=18` /
`InpActionMin=40` e `InpExpiryHour=19` / `InpExpiryMin=45`.
🔴 **E lo stesso giorno va verificato l'orologio del server**: la regola «server = IT−1»
è documentata *«in questo periodo dell'anno»*, e in ora solare **non è mai stata
misurata**. `report/CACCIA_CONFIG_PROP_2026-09-13.md` r.191 la **assume** stabile
(server UTC+0 d'inverno) — assunzione ragionevole, **prova zero**. Si chiude in dieci
secondi confrontando l'ultima candela M5 con l'orologio di Windows.

### ⑧ 🚫 Cosa NON fare
- **Non** caricare `ABTG_PostNews_ECB_EURJPY.set` su EURUSD «tanto il `.set` non
  contiene il simbolo»: porta dentro `771201` e si ricade nella collisione.
- **Non** usare `Resetta` nella finestra degli input: riarma `InpRiskPercent = 3.0`.
- **Non** contare queste tre nella rosa della challenge: **0,14 op/giorno di famiglia**.

---

# 4. 🕳️ COSA **NON** SAPPIAMO — per nome

### 🔴 I buchi che riguardano il merito
1. **PF: non esiste. n: non esiste. DD: non esiste.** In
   `backtest_pipeline/risultati_prove/ABTG_PostNews/` ci sono **4 CSV `_ohlc` da 3
   righe**, e le righe dicono **`Trades = 0`, `Profit = 0`, `Profit Factor = 0`**, con
   `InpRiskPercent=3` (il valore vecchio). 🔴 **Non è «screening»: sono passate che non
   hanno misurato niente**, e la causa è nota — il calendario non veniva letto.
   👉 **Il verdetto corretto su tutte e tre è `[NON ANCORA MISURATO]`.** Non «morte»,
   non «promosse»: **mai misurate**.
   📄 `report/CONTRATTO_POSTNEWS_ECB_771201_2026-09-10.md` r.8 (*«NON MISURATA fino a
   prova contraria»*), r.39 (*nessun DD promesso*), r.47 (*~8 op/anno = 0,03 al giorno*).
2. 🔴 **Il cancello di costo NON passa, e questa è la cosa che il mandato non nominava.**
   `report/IL_CANCELLO_IN_DUE_UNITA_2026-09-18.md` r.189-192 e r.227-230, letto in
   **costo pieno** (spread + commissione), che è l'unità stabilita:

   | sedia | stop | in **spread nudo** | in **costo pieno** | pavimento 40× |
   |---|---:|---:|---:|---|
   | `771202` FOMC EURUSD | 25 pip | 62,5× 🟢 | **28,9×** | 🔴 **NO** |
   | `771203` NFP USDJPY | 25 pip | 83,3× 🟢 | **26,8×** | 🔴 **NO** |
   | `771201` ECB EURJPY | 25 pip | 62,5× 🟢 | **22,0×** | 🔴 **NO** |
   | `771201` ECB EURJPY **dopo il trailing a 15 pip** | 15 pip | 37,5× | **13,2×** | ⛔ **SFONDA IL PAVIMENTO DURO (13,3×)** |

   La `771204` ECB EURUSD è **la gemella della `771202`** (stesso simbolo, stesso stop):
   **28,9×** in costo pieno, e **17,4×** dopo il trailing — che nel suo preset è
   **ACCESO** (`InpUseTrail25=true`).
   🔴 **E c'è un aggravante che quei numeri non contengono**: sono calcolati su uno
   spread di **calma** (sonda del 17/08, EURUSD 0,400 pip). Queste sedie operano **10-45
   minuti dopo un annuncio ad alto impatto**, quando lo spread è molto più largo — e
   **`InpMaxSpread=0` in tutti e tre i preset significa filtro spread DISATTIVATO**
   (`SpreadOK()` r.507 torna sempre `true`). 👉 **Il numero vero è peggiore di 28,9×, e
   non lo sappiamo di quanto.**
3. **Nessuna delle tre ha mai avuto: gestione dell'uscita messa ad asse · simboli
   gemelli provati · TF cambiato.** Tre delle cinque voci del certificato di morte sono
   vuote — motivo in più per cui il verdetto non può essere «morto» né «promosso».

### 🟠 I buchi che riguardano la catena
4. **Non so com'è `Common\Files` sul VPS OGGI.** Il dato citato nel mandato (file del
   10/09, 82 byte) **non è in nessun referto del repo**: viene dall'output della riga di
   diagnosi girata sul VPS, che **non è stato committato**. L'ultima misura agli atti è
   del **07/09** e dice che `Common\Files\abtg_news.csv` **non esiste**. 👉 Lo chiude il
   passo ⑥.
5. **Non so se la riparazione del canale news del 19/09 sia stata ESEGUITA sul VPS.**
   `report/RIPARAZIONE_NEWS_VPS_2026-09-19.md` prepara la riga; l'esito della corsa non
   è in repo. Finché non lo è, l'anello 4 della catena di §2 ③ è **dichiarato, non
   verificato**. 🟢 Quello che **so** è che l'anello 3 è vivo: `data/abtg_news.csv` ha
   **16 eventi** al commit `f6b276e4`, contro i **0 byte** di ieri.
6. **Non ho potuto interrogare Forex Factory** (il proxy di questo ambiente blocca
   `nfs.faireconomy.media`). Quindi: *(a)* non ho verificato che `Unemployment Rate` esca
   come `High` nel feed vivo — l'ho dedotto dal calendario storico di casa, che è
   costruito **dagli stessi feed** e lo contiene **186 volte**; *(b)* non ho verificato
   l'ora esatta con cui il feed pubblicherà la BCE del 29/10.
7. **Non ho verificato l'offset del server BCM in ora solare.** Tutti e tre gli orari
   d'azione ne dipendono, e con loro **tutta la flotta**. Vedi passo ⑦.
8. **Il Guardian non protegge queste sedie.** I preset ECB/FOMC non scrivono
   `InpUsaGuardian` (default `true`, r.67) e il NFP lo mette a `true` — ma sul **piccolo
   50503392 nessun Guardian gira** (giornale 11-12/09: *«GUARDIAN: nessuna riga»*).
   👉 `ABTG_GuardiaIngresso` è **fail-open**: pausa B1 e cap C1 **non agiscono** su
   questo conto. È demo, quindi non è un'emergenza — **ma il numero non va citato come
   se fosse protetto.**

### ✅ COSA HO CONTROLLATO E TORNA — perché un elenco di soli difetti descrive male la realtà
- 🟢 **Tutti e tre i preset hanno l'ora SERVER**, non quella italiana (DAX-style: 13/14/19,
  non 14/15/20). Verificato riga per riga.
- 🟢 **L'aritmetica del rischio regge nel sorgente**, e il metro di casa (0,65%) è
  rispettato su due sedie su tre — la terza (1,30%) è **dichiarata nel preset stesso**.
- 🟢 **I filtri per titolo, valuta e impatto combaciano per costruzione** col generatore
  del calendario (`_normalize_title`, `keep_impacts=("High",)`).
- 🟢 **La geometria SL/TP della slide NFP è corretta** e l'EA ha un **autotest** che la
  verifica in avvio (`InpAutoTest=true`, caso *«T3 slide NFP USDJPY»*).
- 🟢 **Il canale news, morto dal 26/07, è tornato vivo oggi** e ha finalmente uno
  `schedule` giornaliero: 40 minuti prima che il VPS scarichi.
- 🟢 **Il censimento dei magic su 64 preset non ha trovato nessun altro caso rosso.**
- 🟢 **La collisione è stata presa PRIMA che i grafici fossero caricati.** Se fosse
  passata, la FOMC sarebbe rimasta muta per settimane e l'avremmo archiviata come
  «senza edge» — che è esattamente l'errore che Claudio ci ha chiesto di non fare più.

---

# 5. ✍️ LA RIGA PER `REGISTRO_TEST.md`

> **19/09/2026 — POSTNEWS, I TRE GRAFICI.** Le sedie `771202` (FOMC EURUSD),
> `771204` (ECB EURUSD, magic corretto da `771202`: collisione con la FOMC sullo stesso
> simbolo) e `771203` (NFP USDJPY) sono **`[NON ANCORA MISURATO]`**, non «morte» e non
> «promosse». **Mancano tutte e cinque le voci del certificato**: nessun **PF**, nessun
> **n**, nessun **DD** (i 4 CSV in `risultati_prove/ABTG_PostNews/` dicono `Trades=0`);
> la **gestione dell'uscita** non è mai stata messa ad asse; i **simboli gemelli** non
> sono stati provati; il **TF** non è mai stato cambiato. **In costo pieno non passano
> il cancello dei 40×** (28,9× · 26,8× · 22,0×; la `771201` trailata **sfonda il
> pavimento duro: 13,2× contro 13,3**), e i numeri sono calcolati su **spread di calma**
> mentre le sedie operano dopo un annuncio, con `InpMaxSpread=0` (**filtro spread
> spento**). **Frequenza di famiglia 0,14 op/giorno contro il pavimento di 1,00.**
> 🔴 **`771203` è inoltre CIECA per costruzione**: il preset punta a
> `abtg_news_postnews_2010_2025_UTC.csv`, ultimo evento **03/07/2025**, che nessuno
> aggiorna (classe **472**). **Non archivia nessun candidato. Non tocca nessuna taglia.
> Non tocca il forward.**

---

# 6. 📦 I FILE TOCCATI

| file | cosa |
|---|---|
| `mql5/Presets/ABTG_PostNews_ECB_EURUSD.set` | 🔧 **`InpMagic` 771202 → 771204** + la ragione nel commento di testa. **Unica modifica funzionale dell'intero pacchetto**, e 🔴 **in attesa della firma di Claudio** (`DA_FIRMARE.md` r.152-153). File inerte: nessuna sedia viva toccata. |
| `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` | ➕ **classe 472** (preset in campo che punta a un calendario storico: filtro spento in silenzio, canarino cieco al futuro) · ➕ **classe 473** (collisione di magic su stesso simbolo = cancellazione, non confusione; e la riparazione che sposta il numero dentro un altro occupato) |
| `report/PACCHETTO_POSTNEWS_TRE_GRAFICI_2026-09-19.md` | questo documento |

🚫 **Non toccati**: nessun EA, nessun altro preset, nessun terminale, nessun conto,
nessuna taglia, nessun round, nessun file in `coda/`. In particolare **non** sono stati
toccati `mql5/Experts/ABTG_MIS_SIZING_*.mq5`, `backtest_pipeline/prove/MIS_SIZING_*`,
`backtest_pipeline/righe/COMPILA_771531_770511.ps1` (altri agenti al lavoro).
