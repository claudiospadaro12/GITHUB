# 🌅 IL PACCHETTO DEL MATTINO — nove file prova, tutti VERDI al cancello

**Scritto nella notte fra il 22 e il 23/09/2026** · branch `lavoro` · 🛑 **SOLA LETTURA E ZERO
TEMPO MACCHINA**: nessun round lanciato, nessuna riga di lancio scritta, niente VPS, niente
forward, nessun preset toccato, nessuna sedia accesa o spenta.

Claudio, andando a dormire: _«NOTTE. ANDATE AVANTI VOI. DOMANI MATTINA VOGLIO DELLE BELLE
NOVITÀ.»_ 👉 Eccole, e **non sono buone intenzioni: sono nove file già scritti, già pinnati sui
CSV grezzi e già passati dal cancello deterministico.**

```
=== CONTROLLO FILE PROVA ===
  R214a ... R214i     9 file | celle totali: 29 | passate: 58 | problemi: 0
  ESITO: OK
```

> 📌 **Perché si chiamano `R214*` e non `R212*`** (e va detto, perché è successo davvero
> stanotte): un **altro agente** stava scrivendo in parallelo `R212a`…`R212e` sul Dow breakout a
> due lati. Per qualche minuto **`R212a` e `R212b` sono esistiti due volte con contenuti
> diversi** — classe 194. 🔴 Se fossero rimasti così, i risultati di **due round diversi**
> sarebbero finiti archiviati sotto la **stessa etichetta** e nessuno li avrebbe più ritrovati.
> 👉 I miei file sono stati rinominati **contenuto compreso**, con un `grep -ril "r212"`
> case-insensitive a verifica (**zero occorrenze residue**) e il cancello rilanciato dopo. **`R212`
> resta all'altro agente.**

---

## 🎯 IN SEI RIGHE

1. 🟢 **Nove file prova, 58 passate, `controlla_prova.py` → OK con ZERO problemi**, ASCII puro
   (zero byte ≥ 128, verificato a macchina), un solo asse `Y` per file, nove magic vergini
   controllati con `grep -ril` **e** contro i file non ancora committati degli altri agenti.
2. 🔴 **Tre delle quattro misure toccano sedie che OPERANO SU FTMO ADESSO** — `770202` Dow,
   `770260` Nasdaq, `770411` MaxMinNotte DAX. Tutte e tre hanno la **casella 5 del certificato
   (il TF) aperta mentre sono in campo.**
3. 🏆 **La scoperta della notte non costa una passata**: sul Dow e sul Nasdaq
   **`InpLevelTF` è INERTE PER COSTRUZIONE** con la cella viva (`InpRangeMode=0`), perché vive
   solo dentro il ramo `PREVBAR`. 👉 **Due delle otto misure proposte dal dossier aperture
   (righe 1 e 8 della sua tabella dei costi, 28 passate) misurerebbero il NULLA.** Dettaglio al
   §4.
4. 💰 **Costo totale: 58 passate = ~24 minuti nel caso stretto, 86,7 minuti al tetto.** Il tetto
   è quello largo misurato il 21/09 (89,6 s/passata) e **salendo di TF scende, ma NON in
   proporzione**: a modello 4 il tester rigioca lo stesso flusso di tick reali.
5. 🔴 **Due file su nove NON hanno un'ancora di regressione, ed è scritto dentro di loro in
   grassetto.** Al posto dell'ancora c'è, dove possibile, un **contro-esempio con due numeri
   diversi** (il migliore è su `R214h`: 239 contro 168 uscite, scarto del 42%).
6. 🛑 **E c'è una lista di quello che NON ho scritto e perché** (§6). Non si scrive un file
   prova per riempire una casella.

---

## 1️⃣ 📋 LA TABELLA, ORDINATA PER VALORE / COSTO

> La bussola è una sola: **quanto avvicina una sedia schierabile il 1° ottobre.**
> Costo misurato il 21/09 sul PC di backtest (`DESKTOP-H4D7CAJ`, modello 4, 8 passate M5 su
> indice): **caso stretto 2 min 41 s = 20,1 s/passata** · **caso largo 11 min 57 s = 89,6
> s/passata** (`R202A` e `backtest_pipeline/righe/RIGA_R211A_DA_MANDARE.md` r.138).
> 🔴 **Uso il LARGO come tetto**, e dichiaro che salendo di TF il costo scende **ma non in
> proporzione**, perché a modello 4 il numero di tick letti non cambia: cambia solo quante barre
> ci si costruiscono sopra.

| # | file prova | cosa misura | attesa DICHIARATA prima | ancora | passate | stretto | **tetto** | se esce bene, cosa cambia |
|---|---|---|---|---|---:|---:|---:|---|
| **1** | **`R214a_tfgrafico_M15_DOW_770202.txt`** | il **TF del grafico** della sedia `770202` (Dow), mai cambiato in 21 mesi, **mentre opera su FTMO** | 🔵 **IDENTITÀ alla quinta cifra** — è un **CANCELLO DI VERIFICA**, non una misura: il range è su `PERIOD_M1` cablato e le 3 vie verso `PERIOD_CURRENT` sono spente dai pin | ✅ `R202A` Pass 3 — IS `2241.62 / 1.22173 / 0.48667 / 5.6726 / 74` · OOS `5395.25 / 1.27175 / 1.51555 / 4.3944 / 130` | 4 | 1,3 min | **6,0 min** | **casella 5 del certificato CHIUSA su una sedia in campo**, e le corse future possono girare a M15/M30 leggendo finestre più lunghe a parità del tetto delle 100.000 barre |
| **2** | **`R214b_tfgrafico_M30_DOW_770202.txt`** | idem, **M30** (la banda che Claudio ha chiesto) | idem. 🔴 **Non si lancia se `R214a` non dà l'identità** | idem | 4 | 1,3 min | **6,0 min** | idem, e chiude anche la banda alta |
| **3** | **`R214c_tfgrafico_M15_NASDAQ_770260.txt`** | 🔴 **QUI IL TF MORDE DAVVERO**: `InpUseVolumeFilter=TRUE` e `VolumeOK()` legge la barra del **grafico** (`ABTG_Nasdaq_Apertura_US.mq5` r.2530). **Misura vera e mai fatta** | 📈 **n in SALITA** (a M15 la media dei 20 periodi pesca su 5 ore invece che su 100 minuti → il filtro rifiuta meno). **Sul PF NON dichiaro una direzione e non me ne invento una** | 🔴 **NESSUNA — buco dichiarato**: l'unica cosa che cambia entra nei numeri. Base di confronto: `R199B` Pass 2 | 4 | 1,3 min | **6,0 min** | una sedia viva può migliorare **senza cambiare meccanismo**; e il merito resta sospeso (102 posizioni < 150) |
| **4** | **`R214d_tfgrafico_M30_NASDAQ_770260.txt`** | idem, **M30** (media su 10 ore) | idem, effetto **più forte**. I due insieme dicono se è un **gradiente** o un **salto isolato** | idem | 4 | 1,3 min | **6,0 min** | idem |
| **5** | **`R214g_mgmttf_MAXMINDAX_D30EUR.txt`** | **`InpMgmtTF`** sulla sedia `770411`: vale **15 in tutti e 43 i CSV del repo**. Casella **libera**, non provata | 📈 **PF su, DD giù da M15 verso M30-H1, poi piatto** (sull'oro: 20/20 celle OOS positive, e da M5 a H1 il PF +19,5% con DD −53% su 4 righe su 4). 🔴 **E costa frequenza: −10/20% di uscite** | ✅ `r81a` — IS `4766.96 / 1.87803 / 1.52059 / 3.0977 / 20` · OOS `6143.38 / 2.15985 / 3.02118 / 1.9213 / 21` | **14** | **9,8 min** *(base misurata su QUESTO EA: 0,700 min/passata)* | **20,9 min** | **è l'unico round che può migliorare una sedia già in campo senza toccarne il meccanismo.** 🛑 Ma il file è esplicito: **misura, non propone di cambiare niente** |
| **6** | **`R214f_uscite_COSTTOCOST_EURJPY_ohlc_lungo.txt`** | le tre uscite (`InpExitMode` 0/1/2) su **6,5 anni**, con **l'ANCORA** e con **due regimi dentro** | `exit 0` tiene **PF ≥ 1,10 in tutte e due le finestre** e DD sotto `exit 2`. 🔴 Se `exit 0` crolla fuori campione mentre `exit 2` tiene, **la tesi del dossier è FALSA** | ✅ `r127c` Pass 3 — IS `13368.74 / 1.17686 / 1.17244 / 10.9946 / 153` · OOS `71284.16 / 1.52341 / 4.30178 / 12.2627 / 242` | 6 | **[NON MISURATO]** *(è modello 1: la base del 21/09 è modello 4 e non si applica)* | **9,0 min** *(tetto prudente, quasi certamente largo)* | 🏆 **è l'unico round del pacchetto con n ≥ 150 in TUTTE E DUE le finestre.** Dice se abbiamo promosso il **picco** invece del **centro** |
| **7** | **`R214e_uscite_COSTTOCOST_EURJPY_tick.txt`** | le stesse tre uscite **a TICK REALI**, sul solo tratto di tick veri | 🔴 **IL PF SCENDERÀ. Lo scrivo adesso.** E il DD salirà (l'OHLC non vede le escursioni intra-barra). 🔴 **n ~47 (IS) e ~74 (OOS): MERITO SOSPESO prima di cominciare** | 🔴 **NESSUNA — buco dichiarato** (modello *e* finestra diversi da tutto l'archivio) | 6 | 2,0 min | **9,0 min** | il **rischio** letto onestamente: se il DD a tick resta sotto il 10% a 1%, abbiamo un candidato; se sfonda, il candidato si chiude **col numero giusto** invece che col numero della cella sbagliata |
| **8** | **`R214h_finestra_LIVE5MV2_D30EUR_long.txt`** | **`InpPrevWindowMin`** {15·30·45·60}, Supertrend **ON**, finestra pulita con split IS/OOS. **30 e 60 non sono mai stati provati** | **PF ≥ 1,04 su tutte e quattro in OOS** e DD in calo monotono. 🔴 **Soglia di scarto congelata: se a 30' E a 60' il PF scende sotto 1,00, il gradiente è un artefatto e il capitolo si chiude DAVVERO** | 🟡 **nessuna esatta**, ma un **controllo numerico a DUE ipotesi**: `n_IS + n_OOS` = **239** (finestra vera 642 gg) **oppure 168** (912 gg). Scarto del **42%** | 8 | 2,7 min | **11,9 min** | il gradiente misurato è **4 coppie su 4, PF su e DD giù**: se regge a 30' e 60' abbiamo un motore nuovo. 🔴 **Ma alla taglia FTMO del 2,00% la cella migliore fa già 17,8-18,1% di DD: non si schiera senza scalare il rischio** |
| **9** | **`R214i_finestra_LIVE5MV2_D30EUR_short.txt`** | lo stesso asse sul **lato SHORT, che non è MAI stato misurato** (`InpAllowShort=0` in tutte e 32 le passate d'archivio) | 🔴 **Non dichiaro una direzione e non me ne invento una**: sul DAX la dottrina di casa dice "solo long", ma la FASE A misura il contrario (short **+0,045** contro long **+0,007** R/op). Dichiaro **PF intorno a 1,00 con incertezza alta** | 🔴 **NESSUNA, e nemmeno il controllo numerico**: le 239 uscite d'archivio sono long-only | 8 | 2,7 min | **11,9 min** | se lo short resta sotto 1,00 su tutte e quattro, si scrive **«long-only, e MISURATO»** nel preset — che chiude un buco del certificato **ed è un risultato** |
| | **TOTALE** | | | | **58** | **~24 min** | **86,7 min** | |

---

## 2️⃣ 🔬 LE QUATTRO MISURE, E PERCHÉ NON SONO LA STESSA COSA

### 2.1 🟢 Dow e Nasdaq: **la differenza NON va appiattita, e non l'ho appiattita**

Letto nel sorgente riga per riga, non dedotto:

| sedia | `SLMode` | `AtrFilter` | `EntryMode` | **`VolumeFilter`** | `VolRegime` | il TF del grafico morde? |
|---|---|---|---|---|---|---|
| `770202` Dow | 0 | false | 2 | **false** | — | 🔵 **NO — invarianza PREVISTA dal sorgente** → `R214a/b` sono **cancelli di verifica** |
| `770260` Nasdaq | 0 | false | 2 | 🟢 **TRUE** (`VolAvgBars=20`) | false | 🔴 **SÌ** → `R214c/d` sono una **misura mai fatta** |

Sul Dow la catena è chiusa in tre punti, e li ho elencati **per nome** dentro il file (classe
180): `octf` vive solo in OPENCONFIRM (`EntryMode=5`, qui 2) · `VolumeOKtf` ritorna `true` alla
prima riga con `InpUseVolumeFilter=0` · `gAtrH` entra solo in rami spenti da `SLMode=0`,
`TrailMode=1`, `UseAtrFilter=false`, `BEatR=0` e `TrailStartR=0`.

🔎 **E ho seguito fino in fondo l'UNICA via che restava viva**, perché era la candidata più
probabile a rompere l'invarianza: con `InpTP1_ClosePct=50` la parziale scatta davvero, e dopo la
parziale `InitialSL()` restituisce un `riskDist` calcolato **sull'ATR del grafico**. Quel
`riskDist` alimenta solo `beTarget` (dentro `if(InpBEatR > 0)`, qui 0) e `profR` (letto solo da
`trailArmato = (InpTrailStartR <= 0) || ...`, qui sempre vero). 👉 **Non viene mai guardato.**

> ### 🧪 IL CONTRO-ESEMPIO CHE HO COSTRUITO PER FAR SBAGLIARE QUESTI QUATTRO ROUND
> L'ipotesi alternativa **non è «il nulla»**: è che **`@PERIODO` non arrivi al tester e la corsa
> giri due volte a M5**. Quella spiegazione produce **esattamente lo stesso CSV** dell'ipotesi
> buona. 👉 **Il CSV da solo non decide**, e la lettura del `.ini` / del Giornale è scritta come
> **OBBLIGATORIA** dentro tutti e quattro i file.
> 🟢 **E c'è un secondo controllo che non costa una passata**: il Dow e il Nasdaq sono **il
> controllo l'uno dell'altro**. *Dow identico + Nasdaq diverso* ⇒ `@PERIODO` arriva davvero (lo
> prova il Nasdaq) **e** l'inerzia del Dow è una misura. *Tutti e due identici* ⇒ non si conclude
> niente finché non si apre il `.ini`.

### 2.2 🥈 `CostToCost`: **la tensione dei tick è sciolta con DUE file, non con una scusa**

Il fatto, dal CSV grezzo (`scan_h4/scan_ABTG_CostToCost_H4_EURJPY.csv`, 9 celle, OHLC, rischio 1%):

| lato | `exit 0` | `exit 1` | `exit 2` |
|---|---|---|---|
| **LONG** | **PF 1,34274 · n 194 · DD 9,1158** | PF 1,23787 · n 160 · DD 10,8444 | 🔴 PF 1,54592 · n 155 · **DD 12,0482** ← *la cella messa in vivaio* |
| SHORT | 0,90832 · DD 27,67 | 0,64382 · DD 32,89 | 0,63017 · DD 44,77 |

🔴 **Abbiamo promosso il picco e poi l'abbiamo bocciata per il drawdown del picco.**

**La tensione**: i tick reali BCM sul forex partono dal **2024.07.05** (misurato:
`risultati_archivio/NOTA_PAVIMENTO_TICK_FOREX_2026-09-01.md`), ma la finestra di `r127c` è
**2020.01.01 → 2026.06.30**. O si accorcia e l'`n` crolla, o si dichiara che i tick veri coprono
solo l'ultimo tratto.

👉 **Ho scelto di non scegliere con una scusa: ho scritto DUE file.**
- **`R214e`** gira **solo sul tratto di tick veri** (725 giorni). Legge il **RISCHIO** onestamente.
  **Merito sospeso per costruzione** (~47 e ~74 operazioni), **nessuna ancora**, e non può
  falsificare l'ipotesi di regime: **tutto dichiarato dentro il file.**
- **`R214f`** gira in **OHLC sulla finestra lunga** di `r127c`. Ha **l'ancora esatta**, ha
  **n ≥ 150 in tutte e due le finestre** (raro in questo progetto) e ha **dentro il crollo 2020 e
  l'orso 2022**. È screening, non verdetto — e lo scrive.

🔴 **E `InpExitMode` è un asse CATEGORICO**, non ordinale: 0, 1 e 2 sono **tre macchine diverse**
(`r.830-831` e `r.902-910`). Fra 0 e 2 non c'è un «1,5». **«Centro dell'altopiano» qui non si
applica, e chiederlo sarebbe una frase senza referente.** La tesi giusta è un'altra, ed è più
forte: **«il risultato non dipende da quale uscita scegli»** — se tutte e tre reggono, l'edge sta
nell'**ingresso**; se ne regge una sola, quella è **una cella scelta fra tre**, cioè selezione.

### 2.3 🥉 `MaxMinNotte`: il numero viene dall'**oro**, e l'asse è un **PACCHETTO**

Sull'oro `InpMgmtTF` è l'unico posto del repo dove questa manopola è stata misurata a tick reali
con IS/OOS: **20 celle su 20 positive in OOS** (PF 1,455-2,266) e, sulla parte bassa dell'asse,
**monotòno su 4 righe su 4** — a buffer 200 il DD passa da **8,56% a 4,02%** (−53%) con PF
**+19,5%**. E le due sedie vive stanno su due punti diversi: `770402` ORO a **H4** (dentro
l'altopiano), `770411` DAX a **M15** (nel tratto dove l'asse morde, sul lato basso).

> ### 🔴 CLASSE 594 — E QUI IL PACCHETTO C'È DAVVERO
> `InpMgmtTF` crea **due handle** (`r.139-140`) che alimentano **TRE meccanismi**: lo **stop**
> (`2,5 × ATR` su quel TF), il **terzo target** (l'EMA200 su quel TF) e il **trailing**
> (`2,0 × ATR`). **Non si può isolare senza snaturare la cella** — spegnere il terzo target e il
> trailing farebbe decadere l'ancora `r81a`. 👉 **Allora l'asse si chiama col suo nome: «il TF DI
> GESTIONE», stop + terzo target + trailing insieme.** È esattamente quello che è stato misurato
> sull'oro, quindi il confronto è lecito. Come si scioglie, se il risultato è buono: **tre round
> da 14 passate, uno per meccanismo** — scritto dentro il file.

> ### 🧪 IL CONTRO-ESEMPIO, contro l'IPOTESI ALTERNATIVA e non contro il nulla
> *«Il gradiente dell'oro non è un fatto sul TF: è un fatto sullo STOP PIÙ LARGO. Salendo di TF
> l'ATR cresce, lo stop si allarga, il lotto si riduce, e un lotto più piccolo abbassa il DD PER
> COSTRUZIONE.»*
> **Quale numero produce quella spiegazione?** DD giù **e PF PIATTO**. Sull'oro invece il PF sale
> del 19,5% mentre il DD scende del 53%: **l'alternativa prevede piatto, la misura trova salita →
> falsificata sui dati.** 🔴 Ma su DAX va **riverificata**, e il criterio è congelato ora: *se il
> DD scende e il PF resta dentro ±0,10, l'effetto è lo stop e non il TF, e si scrive così.*
> 🟢 **E c'è un controllo diretto già pronto**: `R206a` mette ad asse `InpAtrSLmult` **a TF fisso
> M15** sulla stessa sedia. I due round insieme separano «stop più largo» da «TF più alto».

### 2.4 `DAX_Live5m_v2`: il gradiente c'è, **ma il nome del capitolo è sbagliato**

Il CSV d'archivio ha **32 passate e OTTO esiti distinti** (`InpMinStopPts` e `InpSkipIfTight`
totalmente inerti). Le quattro coppie 5' → 15', a parità di tutto il resto:

| coppia (ST, buffer) | Δ PF | Δ DD |
|---|---:|---:|
| OFF, 500 | **+0,085** | **−11,26** |
| OFF, 700 | **+0,077** | **−9,26** |
| ON, 500 | **+0,089** | **−5,63** |
| ON, 700 | **+0,136** | **−7,01** |

🎯 **Quattro su quattro. PF sempre su, DD sempre giù.** Non è il picco isolato che la regola di
casa vieta di inseguire: è un **gradiente monotono su due rami indipendenti**.

🔴 **E il nome del capitolo è sbagliato**: la cella migliore ha `PrevWindowMin=15` e Supertrend
ON — **non è «Live 5 minuti», è un canale di 15 minuti con un filtro di trend sopra.** Il
breakout M5 puro (5', ST OFF) fa **0,846-0,880 con DD 26,05-26,08% a rischio 1%** = **50,9-51,9%
al 2%**. 🪦 **Quello lì è morto, e col numero.** Ma non è il motore che la cella migliore descrive.

> ### 🔴 IL CONTRO-ESEMPIO CHE FA PIÙ MALE, e sta scritto dentro il file
> **A 60 minuti il motore potrebbe convergere su una sedia che c'è già**: una finestra di 60
> minuti pre-apertura è, in pratica, il livello dell'ultima ora — la geometria delle aperture DAX,
> dove `770101` è **già viva**. 👉 **Quale numero lo smaschera?** La **sovrapposizione dei giorni
> operativi**: se la cella a 60' opera negli stessi giorni di `770101`, non è una sedia nuova, è
> una seconda copia — e aggiungerla **peggiora la correlazione** (il tetto per cluster C2 è
> firmato ma **NON attivo**). Si legge nei per-trade con `sovrapposizione_sedie.py`, a **zero
> passate**, e va fatto **prima** di chiamare «candidato» quella cella.

---

## 3️⃣ 🔧 LE REGOLE DI FORMA, VERIFICATE UNA PER UNA

| regola | come l'ho verificata | esito |
|---|---|---|
| **ASCII puro** | conteggio a macchina dei byte ≥ 128 su tutti e nove i file | 🟢 **0** (ne era sfuggito **uno** in `R214e` — un `·` UTF-8 — trovato dal controllo e **corretto prima di consegnare**, non dopo) |
| **`controlla_prova.py` → OK, 0 problemi** | lanciato sui nove insieme | 🟢 `9 file · 29 celle · 58 passate · problemi: 0` |
| **UN SOLO asse `Y` per file** | imposto dal cancello (controllo 4) | 🟢 dove servivano due assi ho fatto **due file** (`R214h`/`R214i` per i lati, `R214e`/`R214f` per i modelli, `R214a`/`R214b` e `R214c`/`R214d` per i TF) |
| **MAGIC vergine** | `grep -ril` su tutto il repo (`.git` e `.claude` esclusi) **+** `git status` per i file degli altri agenti | 🟢 `788111 788161 788112 788162 788113 788163 788114 788164 788211 788212 788311 788411 788413` → **zero occorrenze ciascuno**. Scartati `788101` (3 hit), `788201` (19), `788412` (1) |
| **ORA SERVER** | colonna per colonna | 🟢 DAX `InpSessionHour=8`, USA `=14`/`Min=30`, MaxMin `BoxStart=23 · Place=7:59 · Cutoff=8:30 · Close=17:30`. 🔴 **Nei preset FTMO gli stessi orari sono +2**: usarli in backtest misurerebbe un altro mercato, ed è scritto dentro `R214g` |
| **`@DAQUANDO` MISURATO** | citato col referto che lo misura | 🟢 indici **2024.09.26** (`misura_tick/REFERTO_MISURA_TICK_*.txt`) · forex tick **2024.07.05** (`NOTA_PAVIMENTO_TICK_FOREX_2026-09-01.md`) · `R214f` usa **2020.01.01** perché è OHLC e replica l'ancora |
| **ANCORA di regressione** | letta nei **CSV grezzi**, mai nei referti | 🟢 su 5 file · 🟡 1 approssimata (`R214h`) · 🔴 **3 dichiarate come buco** (`R214c`, `R214d`, `R214e`, `R214i`) |
| **ATTESA prima dei numeri + CONTRO-ESEMPIO** | ogni file ha il suo, costruito contro l'**ipotesi alternativa** | 🟢 9 su 9 |
| **CANCELLO in grandezze invarianti alla taglia** | Recovery Factor, Equity DD %, Profit | 🟢 9 su 9. 🔴 **Mai Expected Payoff** (classe 550: con la parziale accesa `Trades` conta **uscite**) e **mai «DD contro DD» da solo** (una cella che opera meno ha un DD più basso per costruzione) |
| **Classe 594 — chi ALTRO dipende dall'asse** | cercato nel `.mq5` per ogni file | 🟢 trovati **tre** casi e tutti e tre **dichiarati**: `InpTP_R` dentro `exit 1` · il **pacchetto** di `InpMgmtTF` · `InpMinStopPts`/`InpSkipIfTight` dentro un `if` che l'asse rende irraggiungibile |

> ### 🏆 IL CASO DI CLASSE 594 CHE VALE LA PENA RACCONTARE
> Su `R214h`/`R214i` l'asse `InpPrevWindowMin` **allarga lo stop**, e `InpMinStopPts` vive dentro
> `if(InpMinStopPts > 0 && dist < InpMinStopPts*_Point)` (r.678 e r.702): allargando la finestra
> quel blocco diventa **sempre meno raggiungibile**. È lo stesso schema che è costato la classe
> 594 su `R211a`.
> 🟢 **Ma qui costa ZERO, ed è MISURATO e non assunto**: nel CSV d'archivio le **quattro**
> combinazioni di `InpMinStopPts {200,400} × InpSkipIfTight {0,1}` danno risultati **identici al
> centesimo su ogni cella** (32 passate → 8 esiti). Il pavimento **non mordeva già a 5 minuti**,
> dove il range è il più stretto possibile: a 15-60 minuti resta irraggiungibile **a fortiori**.
> 👉 **L'asse muove una cosa sola, ed è dimostrato con un numero invece che con un ragionamento.**

---

## 4️⃣ 🏺 LA SCOPERTA CHE NON COSTA UNA PASSATA — **`InpLevelTF` È INERTE SULLE DUE SEDIE VIVE**

Cercando chi dipende dagli assi ho aperto anche le manopole che **non** ho messo ad asse, e ne è
uscito un fatto che **corregge il dossier aperture**.

`InpLevelTF` compare **una volta sola** in tutti e due i sorgenti, e sta **dentro il ramo
`PREVBAR`**:

| EA | righe | condizione |
|---|---|---|
| `ABTG_Dow_Apertura_US.mq5` | r.814-816 | `if(InpRangeMode == ABTG_RANGE_PREVBAR)` |
| `ABTG_Nasdaq_Apertura_US.mq5` | r.911-913 | idem |

E le due celle vive hanno **`InpRangeMode = 0`** (letto nei CSV di `R202A` e `R199B`, non nei
referti).

> 🔴 **CONSEGUENZA: su `770202` e su `770260` `InpLevelTF` è INERTE PER COSTRUZIONE.** Le due
> misure proposte dal dossier aperture come righe **1** e **8** della sua tabella dei costi
> (*«`InpLevelTF` ad asse × 7 TF»* su NASUSD e su U30USD, **28 passate = 9,4 minuti**)
> **misurerebbero il NULLA** se girate a parità di cella viva.
> 🟢 **E `R133a` si salva, ma NON per il motivo che si crede**: quel file pinna
> `InpRangeMode=2` **e** `InpEntryMode=0` — quindi è valido, ma **non chiude la casella 5 della
> sedia `770260`**: misura la variante **breakout su PREVBAR**, che è un altro motore con lo
> stesso nome. 👉 **Va girato come round autonomo, non come tappabuchi del certificato.**

💰 **Valore di questo paragrafo: 28 passate risparmiate, zero tempo macchina speso per trovarlo.**

---

## 5️⃣ 🗺️ LO STORICO ESTERNO — quello che cambia, e quello che non cambia

Claudio, nella notte: _«ABBIAMO SCARICATO LO STORICO DA ALTRI SITI SIA SU ORO CHE SU INDICI.
CONTROLLA E NON TI DIMENTICARE.»_ 👉 Ha ragione, e **cambia una frase che scrivevamo come
definitiva**. Mappa completa (di un altro agente, non duplicata qui):
`report/LO_STORICO_ESTERNO_MAPPA_2026-09-23.md`.

| bersaglio | cosa c'è | cosa cambia nei miei file |
|---|---|---|
| **`EURJPY`** (`R214e`, `R214f`) | il **nativo BCM** ha storico dal **1993.04.26** (`REFERTO_SONDA_STORICO_17-08.md`: il muro del «2010» era il **tetto delle 100.000 barre del grafico**, non il disco) · più **`EURJPY_EXT`**, HistData M1 dal **2018.01.01**, promosso dal cancello ZERO con **diff media 0,0063%** e **copertura 99,6%** | 🟢 **la PROVA DI REGIME su questo motore È POSSIBILE**, e fino a stanotte la scrivevamo come buco non colmabile. Costo dichiarato: **3 celle × 4 finestre = 12 passate**, e serve **il driver della prova di regime**, non `walkforward_generico` |
| **indici** (`R214a`-`d`, `R214g`, `R214h`, `R214i`) | `NASUSD_EXT` 5,2 M barre dal 2010.11.14 e `SPXUSD_EXT` 4,6 M, ma **IN FRIGO** (diff **0,0756%** e **0,0608%** contro la soglia **0,05%**). Dow e DAX **non risultano importati** | 🔴 **niente cambia**: la prova di regime resta assente e non colmabile, e **non propongo nessun file prova su `NASUSD_EXT`/`SPXUSD_EXT`** |

🔴 **IL VINCOLO CHE NON SI AGGIRA, e sta scritto dentro `R214e` e `R214f`**: il feed `_EXT` è
fatto di **barre M1, non di tick**. Una corsa su `_EXT` **non è modello 4**, e il confronto coi
numeri a tick non è diretto: il fattore **OHLC/tick misurato in casa è 1,71-1,85 in eccesso**
(`L1` 1,46853 → 0,85701 = 1,714 · `L3` 1,71088 → 0,92490 = 1,850).

⚠️ **E quel fattore l'ho usato col suo limite, non alla lettera**: è misurato su un **breakout M5
su indice**, dove ingresso e stop stanno dentro la stessa barra e il percorso intra-barra decide
tutto. Su **H4 forex** la distorsione dovrebbe essere molto minore. 👉 **Il fattore OHLC/tick per
H4 forex è `[NON MISURATO]`**: dentro `R214e` dichiaro **il SEGNO** (PF giù, DD su), **non la
taglia**. Inventare una taglia sarebbe un numero inventato.

---

## 6️⃣ 🛑 QUELLO CHE NON HO SCRITTO, E PERCHÉ

> **Non si scrive un file prova per riempire una casella.** Ecco l'elenco, diviso in due: le cose
> che **non si devono** scrivere, e le cose che **si possono** scrivere ma non erano in questo
> turno.

### 6.1 🪦 NON SI SCRIVONO — il motore è dichiarato senza edge, e allargare sui **parametri** trova solo picchi di rumore (regola del 19/08)

| candidato | il numero che lo chiude | perché NON gli ho scritto un file |
|---|---|---|
| **`ABTG_DAX_Apertura_EU` su `100GBP`** (FTSE) | **72 passate con operazioni su 96, migliore PF 0,90423**, peggiore 0,38577 con DD 32,17%. E la FASE A gli dà **−0,138 R/op su 431 rotture — il peggiore degli 8 indici** | Negativo su **due misure indipendenti**, con **modelli diversi** (tick e OHLC), **meccanismi diversi**, **su entrambi i lati**, su **431+283 operazioni**. Per resuscitarlo servirebbe una gestione che **da sola** recuperi 0,10 di PF: il massimo mai misurato in casa su un asse d'uscita è **+0,13** (`R199B`). 🪦 **Manca troppo** |
| **`ABTG_Apertura_Marco` su `NASUSD`** | **22 celle su 22 negative**, migliore **0,84203**, su **454 uscite**. Controprova col motore nudo: **0,91997 su 484** | La finestra è **unica** (il caso più generoso: nessuna penalità di fuori campione) **e** il numero è il **migliore di 22** (selezione a favore). Con il vento in poppa da tutte e due le parti **non arriva a 0,85** |
| **RANGE-FADE** (`EntryMode=3`) | **0,68-0,84 IS / 0,70-0,93 OOS** su 2 mercati × 2 finestre × 2 TF × 2 modelli. DD fino a **19,97%** | È **il più misurato dei nostri morti**. E la tentazione («il 40% dei giorni rientra, quindi fadare paga») è l'errore che i criteri della FASE A avevano scritto **prima** di guardare i numeri: *«una classe frequente non è un edge, è una frequenza»* |
| **OPENCONFIRM** (`EntryMode=5`) | **1 cella positiva su 8**, e il segno si ribalta con **tutte e tre** le manopole: TF (+1.033 → −669), volumi (+1.033 → −1.378), mercato (+1.033 → −1.552). Su finestre separate: **IS 1,81587 → OOS 0,69553 a campione costante** | È l'**unico** meccanismo della famiglia dove il TF è stato davvero confrontato, **e il confronto l'ha ucciso**. Una cella positiva solo al suo TF, solo col filtro acceso e solo su un mercato non è un motore: è il massimo di una griglia da otto |
| **`CostToCost` lato SHORT** | **6 celle su 144 sopra 1,00**, PF **mediano 0,708**, DD fino a **48,3%**, su **28 coppie × 3 uscite** | Misurato su 28 simboli e 3 meccanismi d'uscita: è **la definizione di «provato»**. 🟢 E serve a qualcosa: **giustifica `InpAllowShort=false`** in `R214e`/`R214f` invece di lasciarlo come copia non spiegata |
| **`DAX_Live5m_v2` ramo Supertrend OFF** | **0,846-0,965 con DD 14,79-26,08%** a rischio 1% (= fino al **51,9% al 2%**) | Per questo in `R214h`/`R214i` `InpUseSupertrend` è **pinnato a 1**, non messo ad asse: il ramo OFF è misurato negativo su **tutte e quattro** le combinazioni |
| **`A3` — il lato SHORT delle aperture DAX** | Il segno **si inverte fra IS e OOS su 3 celle su 3** (0,824/0,846/0,771 → 0,934/1,065/**1,212**) | Per il criterio S4 di casa (*«segno opposto su tutte le celle = REGIME, non edge»*) **questo non è un edge: è una finestra**. E la prova di regime sugli indici BCM **non è possibile** (storico dal 2024.09.26, un regime e mezzo). 🔴 **Non è sbloccabile entro ottobre, e il motivo è il banco, non il motore.** `R205a` è pronto e darebbe **un numero, non un verdetto** |

### 6.2 ⏳ SI POSSONO SCRIVERE, ma non erano in questo turno — **con la specifica pronta**

| misura | passate | tetto | perché non l'ho scritta |
|---|---:|---:|---|
| **`InpFilterTF` ad asse (H1·H2·H3·H4) sul Dow `U30USD`** | 8 | 11,9 min | 🟢 **È la migliore delle non scritte**: sul Dow è la manopola che vale ≈ **+0,21 di PF** e **varia in ZERO** dei 221 CSV della famiglia. Non era nei quattro bersagli del mandato — **è la prima cosa da scrivere al prossimo giro** |
| `InpLevelTF` ad asse su `U30USD` e `NASUSD` **a parità di cella viva** | 28 | 9,4 min | 🔴 **NON si scrive: misurerebbe il nulla** (§4). È l'unica riga di questa tabella che va **cancellata**, non rimandata |
| `MaxMinNotte` su `F40EUR` · `E50EUR` · `100GBP` (`InpMgmtTF`) | 24 | ~17 min | ⛔ **Bloccata da un numero che manca**: lo **spread BCM di quei tre simboli è `[NON MISURATO]`** (`spread_flotta/` ha **3 file su 13 simboli**). Senza, il cancello di costo su quelle sedie **non è né verde né rosso**. 🟢 Misurarlo costa **zero passate di tester** (`ABTG_SpreadOrario`) |
| `CostToCost` su `USDCHF` e `CHFJPY` (`InpExitMode`) | 12 | 18 min | ⏳ Sono gli **altri due «exit 0 long» sotto il muro** nello scan (PF 1,2617 · DD 8,611 · n 186 e PF 1,1474 · DD 7,095 · n 190). **Un simbolo per file**: si scrivono in fotocopia da `R214e`/`R214f` **appena il primo ha risposto** |
| `CostToCost` `InpTF` = **D1** (e H2/H3) | 18 | ~27 min | ⏳ La TESI del motore prescriveva *«H4/D1 da spazzolare»* (commento r.149 del sorgente) e **il D1 non è mai stato provato**. Casella davvero libera, ma un asse alla volta |
| **Prova di REGIME** su `EURJPY` / `EURJPY_EXT` | 12 | **[NON MISURATO]** | ⏳ Diventata possibile **stanotte** (§5). 🔴 Ma **serve il driver della prova di regime**, non `walkforward_generico`: è un lavoro di strumento prima che di round |
| `DAX_M3` `InpTriggerTF` {M15, M30} a tick | 10 | 15 min | ⛔ **Prerequisito a costo zero mancante**: l'**ATR(10) mediano su `D30EUR` per TF** è `[NON MISURATO]`, e senza quello **la frontiera del costo su quel motore non è compilabile**. Una sonda, non un round |
| `ORB_Fibo` `NASUSD` **a tick reali** | 6 | 9 min | ⏳ Zero passate a tick in assoluto su quel motore. Attesa già scritta nel dossier: **scenderà**. Vale, ma sta dietro alle sedie vive |
| Tre round per **sciogliere il pacchetto `InpMgmtTF`** (stop / EMA200 / trailing) | 42 | 63 min | ⏳ **Non si fanno adesso, e il perché è nel file `R214g`**: prima si guarda se il pacchetto si muove. Spendere 42 passate per smontare un effetto che potrebbe non esserci è il modo più caro di non scoprire niente |
| **Sovrapposizione dei giorni** fra la cella a 60' di `Live5m_v2` e `770101` | **0 passate** | 0 min | 🟢 **Non è un round**: è `sovrapposizione_sedie.py` sui per-trade. Va fatto **prima** di chiamare «candidato» quella cella (§2.4) |
| **Dow BREAKOUT a due lati, range 15'** (`770201`) — il candidato n.1 di `CHI_ALTRO_PUO_SCHIERARSI` (**OOS 40/40 celle in utile**, PF 1,267-1,560, n 188 posizioni, DD 8,70% @1%) | — | — | 🚫 **NON l'ho scritto DI PROPOSITO: ci sta già un altro agente stanotte** (file `R212a`…`R212e`, `emaslow` / `ancora_g1` sul Dow breakout). 🔴 **Ed è anche il motivo della collisione di sigla che ha fatto rinominare i miei file da `R212*` a `R214*`** (classe 194): due agenti in parallelo avevano preso lo stesso numero, e due round diversi sarebbero finiti archiviati sotto la stessa etichetta |
| **`ABTG_EMA200` H4 forex a DUE LATI** (`GBPUSD` 362 deal · `AUDJPY` 265 · `GBPJPY` 221 · `XAUUSD` 187, PF mediano 1,231-1,514, DD 4,42-7,21% a tick) | — | — | ⏳ **Non è famiglia mia in questo turno**, ed è già letto in `CHI_ALTRO_PUO_SCHIERARSI_2026-09-22.md` §2.3. 🔴 Il suo difetto è grosso e va ripetuto ogni volta che si cita quel PF: **finestra unica e ottimizzatore GENETICO**, quindi quei numeri sono **in-campione per costruzione**. La misura che lo sblocca è **uno split IS/OOS**, non un altro asse |

---

## 7️⃣ 🕳️ I BUCHI DI QUESTO PACCHETTO — dichiarati, non nascosti

1. 🔴 **Tre file su nove non hanno un'ancora di regressione** (`R214c`, `R214d`, `R214e`) e un
   quarto non ha nemmeno il controllo numerico sostitutivo (`R214i`). È scritto in grassetto
   dentro ognuno, con il motivo.
2. 🔴 **Il MERITO è sospeso su quattro round su nove**: `R214c`/`R214d` (102 posizioni OOS),
   `R214e` (~47 e ~74), `R214g` (20 e 21 uscite). 👉 **Quei round dicono se l'asse morde e come si
   muove il rischio. Non dicono se la sedia è migliore.**
3. ⚪ **`Equity Drawdown Absolute`** — il campo che FTMO misura davvero — **non è nei CSV**. Uso
   `Equity DD %`, che `report/IL_MURO_MISURATO_2026-09-22.md` dimostra essere un **limite
   superiore rigoroso**: i miei DD sono **conservativi**, mai ottimisti.
4. ⚪ **Il `.ex5` sul banco corrisponde al `.mq5`: `[NON MISURATO]` su tutti e nove.** Ogni file
   dice che la corsa va **pinnata a un commit** e il commit scritto nel referto. 🔴 E su
   `R214h`/`R214i` conta più del solito: il CSV d'archivio è del **26/07** e **non ha** le colonne
   `InpUsaGuardian`, `InpBEatR`, `InpTrailStartR`. **L'EA è cambiato dopo quella corsa**: i tre
   input nuovi sono pinnati ai default e vanno **verificati NO-OP, non dati per NO-OP**.
5. ⚪ **«Max barre nel grafico» sul terminale di backtest `50504400`: `[NON MISURATO]`.** Costa
   **zero passate** leggerlo. `R202A` è girata con `MaxBars=100000000`: se il banco di oggi ha lo
   stesso valore, il tetto non morde a nessuno dei TF proposti.
6. ⚪ **Lo spread BCM di `EURJPY`, `F40EUR`, `E50EUR`, `100GBP`: `[NON MISURATO]`.** Il `25,6×`
   citato per `CostToCost` viene da un'altra fonte e **va riconfermato**.
7. ⚪ **Prova di regime assente su tutti gli indici**, e **non colmabile** (§5).

---

## 8️⃣ 📌 COSA DECIDE CLAUDIO, E COSA NO

| cosa | chi |
|---|---|
| I nove file prova esistono, sono verdi, sono pinnati sui CSV grezzi | ✅ fatto stanotte, **zero tempo macchina** |
| **Quali round lanciare e in che ordine** | 🖊️ **CLAUDIO** — il perimetro del runner è **sola lettura**: nessun round parte senza la sua firma |
| **Le righe di lancio** | 🚫 **NON le ho scritte**, per mandato: le scrive il coordinatore e **passano dal cancello** (`controlla_riga.py` + agente `controllo-preventivo`) |
| Taglie, rischio, accensioni, conto reale `10105439` | 🖊️ **CLAUDIO**, sempre |
| Cambiare un parametro su una sedia viva (`770260`, `770411`) | 🖊️ **CLAUDIO**. 🛑 **Nessuno di questi file propone di cambiare niente: misurano** |

> ### 🔴 E LA RIGA CHE VA DETTA OGNI VOLTA
> **I round girano sul PC DI BACKTEST, non sul VPS** (firma di Claudio del 21/09, dopo che lo
> Strategy Tester sul banco ha inchiodato il VPS **mentre le sei sedie della challenge
> operavano**). Sta scritto in testa a tutti e nove i file.

---

## 🧾 FONTI PRIMARIE (tutte CSV grezzi, salvo dove indicato)

`risultati_prove/R202A/ABTG_Dow_Apertura_US_U30USD_{IS,OOS}_R202A.csv` + `REFERTO_ROUND_R202A.txt` ·
`risultati_prove/R199B/ABTG_Nasdaq_Apertura_US_NASUSD_{IS,OOS}_R199B.csv` + `REFERTO_ROUND_R199B.txt` ·
`risultati_prove/ABTG_CostToCost/scan_h4/scan_ABTG_CostToCost_H4_EURJPY.csv` ·
`risultati_prove/dal_vps/ABTG_CostToCost/ABTG_CostToCost_EURJPY_{IS,OOS}_ohlc_r127c.csv` ·
`risultati_archivio/r81_csv/ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_{IS,OOS}_r81a.csv` ·
`risultati_prove/ABTG_MaxMinNotte_DAX_Short_Ottimizzato/*_D30EUR_{IS,OOS}.csv` ·
`risultati_archivio/Live5m/valid_DAX_Live5m_v2_D30EUR_realtick.csv` ·
`risultati_prove/ABTG_DAX_Live5m_v2/ABTG_DAX_Live5m_v2_D30EUR_{IS,OOS}.csv` ·
`backtest_pipeline/ini/valid_DAX_Live5m_v2.ini` ·
`risultati_archivio/misura_tick/REFERTO_MISURA_TICK_{D30EUR,NASUSD,U30USD}.txt` ·
`risultati_archivio/NOTA_PAVIMENTO_TICK_FOREX_2026-09-01.md` ·
`risultati_archivio/REFERTO_SONDA_STORICO_17-08.md` · `risultati_archivio/REFERTO_IMPORT_6_SIMBOLI.md` ·
`risultati_archivio/R104_REFERTO_DRIVER_20260825_0738.txt` ·
sorgenti `mql5/Experts/ABTG_{Dow_Apertura_US,Nasdaq_Apertura_US,CostToCost,MaxMinNotte_DAX_Short_Ottimizzato,DAX_Live5m_v2}.mq5` ·
preset `mql5/Presets/FTMO/ABTG_{Dow_Apertura_US_770202,MaxMinNotte_DAX_Short_770411}_FTMO.set` ·
file prova `backtest_pipeline/prove/{R127c_orologio_EURJPY,R133a_livelliTF_NASUSD,R140c_tfingresso_M15_770101_D30EUR,R206a_moltiplicatore_stop_MAXMINDAX_D30EUR,R211a_parziale_orb_DOW_U30USD,R211b_parziale_orb_DAX_D30EUR}.txt` ·
dossier della notte `report/{RIESAME_MORTI_APERTURE,RIESAME_MORTI_NOTTURNI,RIESAME_MORTI_BREAKOUT_M5,CENSIMENTO_CASELLE_VUOTE,CHI_ALTRO_PUO_SCHIERARSI}_2026-09-22.md` ·
`report/LO_STORICO_ESTERNO_MAPPA_2026-09-23.md`.
