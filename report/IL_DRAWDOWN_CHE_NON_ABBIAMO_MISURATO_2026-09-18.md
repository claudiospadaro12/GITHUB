# 🎲 IL DRAWDOWN CHE NON ABBIAMO MISURATO — **la coda per riordino, misurata**

**Venerdì 18/09/2026. Mancano 13 giorni.** Scritto dal **collaudatore prop**.
**SOLA LETTURA**: nessun backtest lanciato, nessun EA / preset / parametro in
forward toccato, `coda/CODA.txt` non aperto. Il conto reale non è stato letto
né nominato come bersaglio. **Costo macchina: 0** (tutto CPU su dati già in repo).

🔴 **Questo referto NON promuove e NON boccia nessuna sedia.** Aggiunge una
misura che mancava. I verdetti hanno criteri congelati altrove e restano lì.

- 🧮 Strumento rieseguibile: `backtest_pipeline/distribuzione_dd_riordino.py` (ASCII puro)
- 📄 Output grezzo della corsa citata: `backtest_pipeline/risultati_archivio/DD_RIORDINO_2026-09-18.txt`
- 🔁 Riga per rifarlo identico:
  `python3 backtest_pipeline/distribuzione_dd_riordino.py --riordini 20000 --blocchi 20000 --avversari 5000`
  (seed di default `20260918`)

---

> # 🥇 LA RIGA DI TESTA
> ## 🟢 **La domanda del collega era giusta, la sua risposta no — e adesso abbiamo il numero al posto della stima.** Lui scriveva «tipicamente 1,5-2x». **Misurato su 6 sedie: il rapporto P95/osservato va da 0,71 a 1,95.** Su **3 sedie su 6** sta nella sua banda; su **2 su 6 è SOTTO 1**, cioè il drawdown osservato è già **peggiore** del P95 dei riordini.
> ## 🔴 **E il motivo per cui sta sotto 1 è esattamente il difetto che il riordino casuale introduce: distrugge i grappoli.** Su `EMA200` `771531` l'autocorrelazione dei P/L a lag 1 è **+0,2844**: il riordino iid dà P95 **5,52%** contro un osservato di **7,54%** — la stima iid è **rotta in quel caso**, e va sostituita con la permutazione a blocchi, che dà P95 **8,08%** e P99 **9,45%**.
> ## 🟢 **La notizia BUONA, e vale per tutte e sei: il muro giornaliero del 5% non viene sfiorato in NESSUNO dei 120.000 riordini.** La peggior giornata peggiore trovata su tutta la flotta misurata è **−3,93%** (`EMA200`), e su **4 sedie su 6 è matematicamente INVARIANTE** al riordino perché fanno **una posizione al giorno**.
> ## 🟠 **Il muro che invece si tocca è quello TOTALE, e su una sedia sola: `ORB_Ottimizzato` `770611` a rischio 1% sfonda il 10% nel 14,4% dei riordini casuali e nel 6,8% delle permutazioni a blocchi.** Alla taglia viva (0,65%) il conto è un altro e **non è stato rifatto qui**: vedi §7.

---

# 1. 📋 IL CENSIMENTO — tutti i per-trade in repo, e cosa manca alla rosa

## 1.1 Come è stato fatto

Sono stati cercati in tutto il repo (escluse le copie di lavoro degli altri
agenti in `.claude/worktrees/`) i file con intestazione
`close_time;symbol;magic;position_id;deal_type;volume;price;net_profit`.
**Sono 136 file.** Sono file **deal-level**: una posizione con `InpTP1_ClosePct=50`
produce **due** righe. L'aggregazione in POSIZIONI si fa per `position_id`,
sommando i `net_profit`; la posizione si data al suo **ultimo** deal.

⚠️ **Una trappola da dichiarare**: i file
`ABTG_Dow_Apertura_US_U30USD_{IS,OOS}_ptc.csv`, che il nome fa sembrare
per-trade, **NON lo sono**: sono CSV di **ottimizzazione**, una riga per passata.
Il per-trade vero di quella cella è un altro file (vedi sotto).

## 1.2 🔴 LA ROSA DI OTTOBRE, SEDIA PER SEDIA — chi ha il per-trade e chi no

Confronto con `report/ROSA_OTTOBRE_2026-09-18.md` §1.2, **elencando per nome**.

| # | sedia · magic rosa | per-trade in repo? | file usato (magic dentro il file) | posizioni |
|---:|---|---|---|---:|
| 1 | `Dow_Apertura_US` **`770202`** | 🟢 **SÌ**, gemello | `risultati_prove/trades_portafoglio/abtg_trades_ABTG_Dow_Apertura_US_U30USD_770206.csv` (`770206`) | **96** |
| 2 | `EMA200` **`771531`** | 🟢 **SÌ**, gemello | `risultati_prove/trades_candidati_r23/abtg_trades_ABTG_EMA200_U30USD_771521.csv` (`771521`) | **257** |
| 3 | `DAX_Apertura_EU` **`770101`** | 🟠 **SÌ ma di un'ALTRA taglia** (§3) | `risultati_prove/trades_portafoglio/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_770115.csv` (`770115`) | **193** |
| 4 | `ORB_Ottimizzato` **`770611`** | 🟠 **SÌ ma di un'ALTRA taglia** (§3) | `risultati_prove/trades_portafoglio/abtg_trades_ABTG_ORB_Ottimizzato_U30USD_770612.csv` (`770612`) | **119** |
| 5 | `MaxMinNotte_DAX_Short_Ott` **`770411`** | 🟡 sì, ma **14 posizioni** | `..._trades_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_770413.csv` (`770413`) | **14** 🔴 |
| 6 | `SupertrendReversal` **`770901`** | 🟡 sì, ma **31 posizioni** | `..._trades_ABTG_SupertrendReversal_225JPY_770903.csv` (`770903`) | **31** 🔴 |
| 7 | `SupRev_NAS_H1_Ott` **`970913`** | 🔴 **NO — BUCO DICHIARATO** | nessun file per-trade con questo magic, né con NASUSD su H1 di questa cella | — |
| 8 | `SuperWave_DOW_H1_Ott` **`770511`** | 🟠 **SÌ ma di un'ALTRA CELLA** (§3) | `risultati_prove/trades_candidati_r23/abtg_trades_ABTG_SuperWave_U30USD_770521.csv` (`770521`) | **50** |
| 9 | `Nasdaq_Apertura_US` GATED SHORT **`770250`** | 🔴 **NO — BUCO DICHIARATO** | nessun file per-trade con questo magic | — |
| 10 | `PTE` **`771321`** | 🟡 sì, ma **23 posizioni** | `risultati_prove/trades_candidati_r23/abtg_trades_ABTG_PTE_U30USD_771311.csv` (`771311`) | **23** 🔴 |

🔴 **I DUE BUCHI, per nome: `970913` (SupRev NAS H1) e `770250` (Nasdaq
Apertura gated short).** Per queste due la distribuzione del drawdown per
riordino **non è calcolabile oggi con i dati in casa**, e non è stata stimata.
Serve un round per-trade (`CODA_12` fa già questo mestiere).

### 🧊 La soglia, dichiarata prima dei numeri
**50 POSIZIONI** (non deal). Sotto quella soglia lo script **rifiuta** di
calcolare la distribuzione e lo scrive. Motivo: sotto ~50 la distribuzione del
massimo di un cammino aleatorio è dominata dal singolo trade estremo e il P95
diventa un altro modo di leggere la peggior perdita, non una coda.
👉 **Restano quindi fuori per campione sottile: `770411` (14), `771321` (23),
`770901` (31).** Ma — regola di casa — **il campione sottile sospende il
giudizio sul MERITO, mai sul RISCHIO**: i loro DD osservati e ricalcolati sono
comunque scritti in §2.

---

# 2. ✅ LA VERIFICA CHE VIENE PRIMA DI TUTTO IL RESTO

> Il compito era esplicito: **prima di ogni altra cosa, il mio DD ricalcolato
> deve coincidere con quello che il tester chiama DD.** Altrimenti sto
> misurando un'altra cosa e il resto non vale niente.

## 2.1 Come ho abbinato ogni per-trade alla sua riga di tester — **senza fidarmi dei nomi**

Ho indicizzato **62.237 righe** di ottimizzazione da **2.182 CSV** del repo
(tutti quelli con la colonna `Equity DD %`) e ho cercato la riga che combacia
con il per-trade su **due vincoli insieme**: il **Profit totale** e il **numero
di Trades**. Il numero di Trades è un'uguaglianza dura; sul Profit la tolleranza
è dichiarata e **il residuo viene sempre stampato**.

**Risultato: su 9 per-trade, 8 abbinano con residuo `0,00`.** Uno solo no, ed è
scritto sotto.

## 2.2 🔴 LA TABELLA DELLO SCARTO — e il verso è sempre lo stesso

| sedia (magic del file) | `Equity DD %` del tester | mio DD **a posizioni chiuse** | scarto | scarto relativo |
|---|---:|---:|---:|---:|
| ORB `770612` | **9,7623** | **9,7203** | −0,0420 pp | **−0,43%** |
| EMA200 `771521` | **7,8323** | **7,5367** | −0,2956 pp | **−3,77%** |
| Dow Apertura `770206` | **4,3941** | **4,2235** | −0,1706 pp | **−3,88%** |
| DAX Apertura `770115` | **7,2328** | **6,2516** | −0,9812 pp | **−13,57%** |
| SuperWave `770521` | **4,2745** | **3,3069** | −0,9676 pp | **−22,64%** |
| SupertrendReversal `770903` | **0,8752** | **0,6493** | −0,2259 pp | **−25,81%** |
| MaxMinNotte XAUUSD `770406` | **4,2436** | **2,9838** | −1,2598 pp | **−29,69%** |
| PTE `771311` | **3,2166** | **2,1825** | −1,0341 pp | **−32,15%** |
| MaxMin DAX Short `770413` | **1,9213** | **2,4102** | **+0,4889 pp** | **+25,45%** 🟠 |

### 🟢 E **NON coincide**, e la ragione è nota e ha un verso
Il tester misura l'**Equity DD**, cioè il drawdown dell'equità **flottante,
tick per tick, a posizione aperta**. Io misuro il drawdown della curva delle
**posizioni CHIUSE**. Il flottante non può che peggiorare il minimo, quindi il
mio numero è **una sottostima strutturale**, ed è infatti **negativo in 8 casi
su 9**, da −0,43% a −32,15%.

🟠 **L'eccezione, dichiarata:** `770413` con **+25,45%**. Con **14 posizioni**
qualunque scarto percentuale è un accidente di campione, e infatti la riga del
tester è su **deposito 50.000** mentre le altre otto sono su 100.000. **Non la
uso per niente.**

### 👉 La conseguenza sul numero che consegno
**Non correggo il mio DD con il numero del tester.** Il rapporto **P95/osservato**
ha **la stessa definizione al numeratore e al denominatore** (entrambi a
posizioni chiuse), quindi il bias si **semplifica al prim'ordine** ed è il modo
onesto di citare la coda. 🔴 **Il valore ASSOLUTO del P95 in percentuale, invece,
è una sottostima della stessa quantità che il tester chiama Equity DD**, e va
letto così ogni volta che compare in questo referto.

## 2.3 🥇 LA PROVA CHE INCHIODA IL METODO — quattro decimali, da un conto indipendente

Non mi bastava un DD "vicino". Ho cercato una grandezza che il tester scrive e
che io posso ricostruire **esattamente**, e l'ho trovata: la colonna
**`Peggior Giornata %`**.

| sedia | `Peggior Giornata %` del tester | mia, ricalcolata | scarto |
|---|---:|---:|---:|
| **Dow Apertura `770206`** | **−1,0227** | **−1,0227** | **0,0000** |
| **DAX Apertura `770115`** | **−1,0780** | **−1,0780** | **0,0000** |

Due riproduzioni **esatte a 4 decimali**, con la convenzione
`somma del giorno / equity a inizio giornata` e deposito 100.000. Questo
verifica **in un colpo solo tre cose**: l'aggregazione deal→posizione, la
convenzione di giornata, e il deposito dedotto.

⚠️ **E la terza non torna, quindi la scrivo**: su **PTE `771311`** il tester dice
**−1,0045** e io ricalcolo **−1,2783**. Sedia da **23 posizioni**, sotto soglia,
**esclusa da tutto il resto** — ma lo scarto è reale e resta segnalato.

## 2.4 🧮 Il deposito non l'ho assunto: l'ho dedotto, e si verifica da sé
Lo script prova una lista di depositi candidati e tiene quello che minimizza lo
scarto sul DD. **Esce 100.000 per otto per-trade su nove** — ed è confermato in
modo indipendente dalle due riproduzioni esatte della peggior giornata di §2.3.

---

# 3. 🔴 CHE COSA STO MISURANDO DAVVERO — le sostituzioni, dichiarate

**Nessuno dei per-trade in repo porta il magic della sedia della rosa.** Ho
usato dei gemelli, e vanno dichiarati uno per uno perché **due di loro non
descrivono la cella promessa**.

| sedia rosa | il per-trade che ho | **coincide col numero della rosa?** |
|---|---|---|
| **`770202`** Dow | `770206`: PF **1,27013** · n **130** deal · DD **4,3941** · pegg. giorn. **−1,0227** | 🟢 **SÌ, identico** alla riga della rosa (`ROSA_OTTOBRE` §1.2 riga 1), che cita gli stessi quattro numeri |
| **`771531`** EMA200 | `771521`: PF **1,52365** · n **517** deal = **257 pos** · DD **7,8323** | 🟢 **SÌ, identico** alla riga della rosa (riga 2) |
| **`770101`** DAX | `770115`: PF **1,39709** · DD **7,2328** · **rischio 1%**, dep. 100.000 | 🔴 **NO.** La rosa promette **PF 1,41105 · DD 4,3501% @0,65% · dep. 10.000 €**. È **un'altra taglia e un altro banco**. `CENSIMENTO_CONTRATTI_v2.md` r.259 dice già che la **stessa cella long-only a 1,0%** fa **6,7111 a 10.000** e **7,2328 a 100.000** — e **7,2328 è esattamente la riga che ho abbinato**, il che conferma di quale corsa si tratti |
| **`770611`** ORB | `770612`: PF **1,67419** · DD **9,7623** · **rischio 1%**, dep. 100.000 | 🔴 **NO.** La rosa promette **DD 6,5389% già a 0,65%**. `CENSIMENTO_CONTRATTI_v2.md` r.262 riporta per la stessa sedia **«9,72% a 100k (R16)» a rischio 1%**: combacia col mio abbinamento |
| **`770511`** SuperWave | `770521`: PF **1,76179** · n **88** deal = **50 pos** · DD **4,2745** | 🔴 **NO, è UN'ALTRA CELLA.** La rosa parla di **n 227, DD 4,0151, finestra piena**. Il mio per-trade è la cella **R23d, solo OOS**. La misura resta valida **per quella cella**, non per la sedia della rosa |

🟢 **Quindi i due risultati direttamente spendibili sulla rosa sono `770202` e
`771531`.** Gli altri tre sono misure vere su celle vicine, e il rapporto
P95/osservato — che è **adimensionale** — è la parte che sopravvive alla
differenza di taglia. 🔴 **Il valore assoluto no.**

---

# 4. 🧊 IL METODO, CONGELATO PRIMA DEI NUMERI

## 4.1 Modello di equity — e perché NON è quello additivo
🔴 **Il sizing di queste sedie è una percentuale dell'equity (`InpRiskPercent`),
quindi l'ordine conta DUE volte**: sul percorso *e* sulla taglia di ogni
operazione successiva. Un riordino fatto sommando euro costanti sarebbe il
modello sbagliato.

Il modello usato è **moltiplicativo**: si misurano i rendimenti relativi
`r_i = pl_i / equity_prima_di_i` sulla **sequenza vera**, e un riordino
ricompone `equity *= (1 + r_perm)`.

✅ **Verificato che sulla sequenza vera riproduce la curva vera in modo
ESATTO**, non approssimato: DD additivo e DD moltiplicativo coincidono a
**3·10⁻¹⁴** su Dow e a **−5,6·10⁻¹⁴** su EMA200. È un'identità, quindi il
modello moltiplicativo è un'**estensione stretta** di quello additivo, non
un'alternativa.

⚠️ **L'unità è il P/L in VALUTA di conto** (non in R). La taglia **non è
costante** lungo la serie, ed è misurato: su Dow il volume medio passa da
**5,57** nel primo quarto a **4,40** nell'ultimo. 🟢 **Ma non cresce con
l'equity** — è dominato dalla larghezza dello stop, non dal capitale: infatti
l'equity cresce del **+6,7%** su Dow e il volume **scende**. Il che vuol dire
che l'effetto di compounding, su queste finestre, è **piccolo** — e lo si vede
in §6.3, dove il modello additivo dà rapporti P95 **più alti di ~1-6%**, non di
ordini di grandezza.

## 4.2 🗓️ LA PEGGIOR GIORNATA — il metodo prima dei numeri
Riordinare le operazioni **cambia la loro data**, quindi «peggior giornata» va
definita. La definizione usata:

> **Si tengono i CONTENITORI-GIORNO della sequenza vera** — il giorno *d*
> conteneva *k_d* posizioni chiuse — **e si ridistribuiscono i P/L riordinati
> dentro quei contenitori, in ordine.** La percentuale è
> `somma del giorno / equity a inizio giornata`.

🟢 Convenzione **verificata contro il tester** in §2.3 (due riproduzioni esatte).

### 🔴 CHE COSA QUESTO METODO **NON** CATTURA — e va detto ogni volta
1. **Il calendario vero**: quali giorni cadono vicini, i ponti, i festivi.
2. **Le posizioni a cavallo di mezzanotte**: qui una posizione appartiene per
   intero al giorno della sua chiusura.
3. **Il flottante infragiornaliero**: la prop misura il muro del 5% sull'equity
   **live**, che include le posizioni aperte. Io misuro solo i realizzati.
   👉 **Questo è il limite che pesa di più**, ed è nello stesso verso di §2.2:
   **la mia peggior giornata è una SOTTOSTIMA.**
4. **La compresenza di più sedie sullo stesso conto**: qui ogni sedia è
   misurata **da sola**. Il muro giornaliero della prop è sul **conto**.

---

# 5. 📊 LA TABELLA — la distribuzione del drawdown per riordino

**20.000 riordini casuali per sedia · modello moltiplicativo · seed 20260918 ·
DD a posizioni chiuse · deposito 100.000 · rischio 1% · tutti i gradini, non
solo i favorevoli.**

| sedia (cella misurata) | n pos | **osservato** | mediana | P90 | **P95** | P99 | max | **P95/oss** | P99/oss |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| **Dow Apertura `770202`** (via `770206`) | 96 | **4,2235** | 5,2509 | 7,4812 | **8,2421** | 9,7253 | 13,5046 | 🔴 **1,952** | 2,303 |
| **DAX Apertura** (cella `770115`, **non** la cella rosa) | 193 | **6,2516** | 5,6263 | 7,9989 | **8,8223** | 10,5616 | 15,6822 | 🟠 **1,411** | 1,689 |
| **ORB** (cella `770612`, **non** la taglia rosa) | 119 | **9,7203** | 7,4629 | 10,6537 | **11,7939** | 14,1080 | 20,3092 | 🟠 **1,213** | 1,451 |
| **EMA200 `771531`** (via `771521`) | 257 | **7,5367** | 3,5228 | 4,9906 | **5,5206** | 6,6929 | 9,6305 | 🟢 **0,733** | 0,888 |
| **SuperWave** (cella `770521`, **non** la cella rosa) | 50 | **3,3069** | 1,4315 | 2,1017 | **2,3343** | 2,8141 | 4,2236 | 🟢 **0,706** | 0,851 |
| *MaxMinNotte XAUUSD* (**fuori rosa**, per confronto) | 68 | **2,9838** | 2,2702 | 3,3086 | **3,6918** | 4,4225 | 6,6205 | 1,237 | 1,482 |

## 5.1 🎯 LA RISPOSTA AL COLLEGA, secca

Lui scrive: *«il novantacinquesimo percentile sta **tipicamente sopra** il
valore osservato»*, e nel dossier stima **1,5-2x** dichiarandolo incerto.

**Misurato, su 6 celle:**
- 🟢 **Ha ragione sul VERSO in 4 casi su 6** (P95 > osservato).
- 🟠 **Ha ragione sulla BANDA 1,5-2x in 1 caso su 6**: solo `770202` (**1,952**).
  DAX **1,411** e ORB **1,213** sono sotto la sua banda; XAUUSD **1,237** idem.
- 🔴 **Ha torto in 2 casi su 6, e non di poco**: `EMA200` **0,733** e SuperWave
  **0,706**. Lì il drawdown osservato è **peggiore del P99** dei riordini iid
  (`EMA200`: osservato 7,54 contro P99 6,69).

**La media dei sei rapporti P95/osservato è 1,209.** 🔴 **E questa media non va
usata come fattore di sicurezza**, perché la dispersione (0,71 → 1,95) è più
grande dell'effetto che si vorrebbe correggere: dire «moltiplica per 1,2»
sarebbe esattamente il tipo di numero comodo che questo referto esiste per
evitare.

👉 **La frase giusta è**: *il margine 7 → 10 non è tre punti, e il collega ha
ragione; ma quanto valga la coda **cambia di sedia in sedia di un fattore 2,8**,
e si misura, non si applica.*

---

# 6. 🧪 I CONTRO-ESEMPI — costruiti per rompere il mio stesso numero

## 6.1 🔴 L'AUTOCORRELAZIONE: in quale verso sbaglia la mia stima

Il riordino casuale **distrugge i grappoli**. Se le perdite arrivano
appiccicate, l'iid **sottostima** la coda. Misurato:

| sedia | **ACF lag 1** | lag 2 | lag 3 | lag 4 | lag 5 | corsa perdente max | **verso dell'errore iid** |
|---|---:|---:|---:|---:|---:|---:|---|
| **SuperWave `770521`** | 🔴 **+0,4540** | +0,2458 | +0,0646 | −0,1798 | −0,0496 | 6 | 🔴 **SOTTOSTIMA** |
| **EMA200 `771521`** | 🔴 **+0,2844** | −0,0095 | +0,0851 | −0,0672 | −0,0548 | 8 | 🔴 **SOTTOSTIMA** |
| ORB `770612` | +0,0871 | −0,0875 | −0,0813 | −0,0365 | +0,0323 | 9 | 🟢 sovrastima |
| DAX `770115` | +0,0116 | −0,0930 | −0,0037 | −0,0697 | +0,1564 | 3 | 🟢 sovrastima |
| Dow `770206` | **−0,1006** | +0,0080 | −0,1858 | +0,1114 | +0,1296 | 3 | 🟢 sovrastima |
| XAUUSD `770406` | −0,1952 | +0,2854 | −0,1629 | +0,2801 | −0,0736 | 3 | 🟢 sovrastima |

🔴 **E le due sedie con ACF lag-1 grande e positiva sono ESATTAMENTE le due con
rapporto P95/osservato sotto 1.** Non è una coincidenza: è la stessa cosa detta
due volte. Su quelle due la sequenza vera **non è un pescaggio sfortunato dal
mucchio iid** — è una serie con memoria, e il mucchio iid è il modello sbagliato.

## 6.2 🧱 LA PERMUTAZIONE A BLOCCHI — la correzione, e un difetto che ho trovato nel mio stesso codice

Per misurare il verso servono riordini che **conservino i grappoli**. Ho usato
la **permutazione a blocchi**: la serie si spezza in blocchi consecutivi lunghi
quanto la **massima corsa perdente osservata**, e i blocchi si rimescolano.

> 🔴 **Difetto trovato e corretto prima della consegna.** La prima stesura usava
> un **bootstrap a blocchi circolari**, cioè ricampionamento **con ripetizione**.
> Quello **non è un riordino**: può pescare due volte il blocco peggiore e
> produce un percorso che **con quelle operazioni non esiste**. Dava numeri più
> grossi (fino a **28,8%** su DAX) e **falsi**. Con la permutazione vera —
> stesso multinsieme, ogni operazione una volta e una sola, verificato da un
> `assert` nello script — quel numero scende a **13,39%**. La differenza fra i
> due, **15,4 punti**, è il prezzo di quell'errore se fosse passato.

| sedia | len blocco | P95 **blocchi** | P95 **iid** | P99 blocchi | max blocchi | verso *(scarto = iid/blocchi − 1)* |
|---|---:|---:|---:|---:|---:|---|
| **EMA200 `771521`** | 8 | 🔴 **8,0773** | 5,5206 | **9,4538** | 12,2768 | **iid SOTTOSTIMA di 1,46x** |
| **SuperWave `770521`** | 6 | 🔴 **3,7726** | 2,3343 | 4,0568 | 4,5831 | **iid SOTTOSTIMA di 1,62x** |
| Dow `770206` | 3 | 8,1086 | 8,2421 | 9,2730 | 12,0557 | iid sovrastima dell'1,6% |
| DAX `770115` | 3 | 8,0532 | 8,8223 | 9,4886 | 13,3929 | iid sovrastima del 9,6% |
| ORB `770612` | 9 | 10,4137 | 11,7939 | 11,8595 | 14,5005 | iid sovrastima del 13,3% |
| XAUUSD `770406` | 3 | 3,0651 | 3,6918 | 3,5502 | 4,8186 | iid sovrastima del 20,4% |

### 🥇 **Il numero che conta, per la sedia #2 della rosa**
Su **`EMA200` `771531`** la stima iid (P95 **5,52%**) è **da buttare**. La stima
corretta, quella a blocchi, dice **P95 = 8,08% · P99 = 9,45% · peggiore su
20.000 = 12,28%**, contro un **osservato di 7,54%**. 👉 Il rapporto onesto
P95/osservato per questa sedia **non è 0,73: è 1,07**, e il P99 è **1,25x**.

## 6.3 🔨 «Esiste un riordino NON casuale ma plausibile peggiore del mio P99?» — **SÌ, su tutte e sei**

Tre prove, tutte **riordini veri** (stesso multinsieme):

| sedia | **P99 iid** | **A**: il blocco perdente VERO traslato | **B**: peggior permutazione a blocchi (5.000 tentativi) | *tetto NON plausibile* (tutte le vincite, poi tutte le perdite) |
|---|---:|---:|---:|---:|
| Dow `770206` | 9,7253 | 7,0606 | 🔴 **10,7234** | *21,2429* |
| EMA200 `771521` | 6,6929 | 7,5679 | 🔴 **12,3109** | *32,5364* |
| DAX `770115` | 10,5616 | 8,2272 | 🔴 **12,4531** | *33,2882* |
| ORB `770612` | 14,1080 | 11,7834 | 🔴 **13,9665** | *39,9208* |
| SuperWave `770521` | 2,8141 | 3,6331 | 🔴 **4,5831** | *4,9050* |
| XAUUSD `770406` | 4,4225 | 3,4275 | 🔴 **4,6181** | *10,2032* |

🔴 **Risposta: sì. Su 5 sedie su 6 la peggior permutazione a blocchi supera il
P99 iid** (su ORB lo sfiora, 13,97 contro 14,11). **Quindi il P99 casuale NON è
il caso peggiore plausibile, e non va citato come tale.**

⚪ La colonna del *tetto* è messa per onestà di scala: **non è plausibile** (è
l'ordinamento avversario perfetto) e serve solo a dire dove sta il soffitto
matematico. **Non va usata per nessuna decisione.**

## 6.4 🎲 Il P95 è stabile o è rumore del generatore?
Rifatto con **tre seed diversi** (20260918 · 101 · 202) su 10.000-20.000 riordini,
il rapporto P95/osservato di Dow esce **1,952 · 1,951 · 1,937** (banda **±0,8%**),
e quello di EMA200 **0,733 · 0,738 · 0,743**. 🟢 **L'errore Monte Carlo è sotto
l'1%**: le differenze fra sedie (0,71 → 1,95) sono **reali**, non rumore.

## 6.5 ➕ E se sbagliassi il modello di equity?
Rifatto tutto in **additivo** (taglia costante): i rapporti P95/osservato
diventano Dow **1,982** (era 1,952), DAX **1,495** (1,411), ORB **1,283**
(1,213), EMA200 **0,767** (0,733), SuperWave **0,709** (0,706).
🟢 **Nessuna conclusione cambia di segno**, e il verso è coerente: senza
compounding la coda è leggermente **più larga**. Il modello moltiplicativo è
quindi, per queste sedie, **leggermente il più mite dei due** — e l'ho scritto
invece di tenermelo.

---

# 7. 🧱 IL CONFRONTO COI MURI DI CASA

## 7.1 🟢 IL MURO GIORNALIERO DEL 5% — **non si tocca, e su 4 sedie su 6 non si PUÒ toccare**

| sedia | pegg. giornata **vera** | mediana riordini | P95 | P99 | **peggiore su 20.000** | quota riordini ≤ −5% |
|---|---:|---:|---:|---:|---:|---:|
| **EMA200 `771521`** | −1,9754 | −1,4823 | −2,1352 | −2,5566 | 🔴 **−3,9250** | **0,0000%** |
| ORB `770612` | −1,4055 | −1,4055 | −1,4055 | −1,4055 | −1,4055 | **0,0000%** |
| SuperWave `770521` | −0,9904 | −0,8579 | −1,3378 | −1,3561 | −1,3561 | **0,0000%** |
| DAX `770115` | −1,0780 | −1,0780 | −1,0780 | −1,0780 | −1,0780 | **0,0000%** |
| Dow `770206` | −1,0227 | −1,0227 | −1,0227 | −1,0227 | −1,0227 | **0,0000%** |
| XAUUSD `770406` | −1,0197 | −1,0197 | −1,0197 | −1,0197 | −1,0197 | **0,0000%** |

### 🥇 **La scoperta strutturale: su 4 sedie su 6 la peggior giornata è INVARIANTE al riordino**
Dow, DAX, ORB e XAUUSD fanno **esattamente 1,00 posizione per giornata**
(96 pos/96 giorni · 193/193 · 119/119 · 68/68), e **per costruzione**:
`InpOneTradePerDay=1` è **letto nella riga di tester abbinata** di tutte e tre
le sedie della rosa — Dow (`..._OOS_r54a.csv`), DAX (`..._OOS_ptd.csv` Pass 54)
e ORB (`..._OOS_r55b.csv`). 🟢 **Con una posizione al giorno, la peggior
giornata È la peggior operazione**, e riordinare non la cambia: nel modello
moltiplicativo l'invarianza è **esatta**.

👉 **Tradotto per la challenge: sul muro giornaliero, l'obiezione del collega NON
morde su queste quattro sedie.** Non perché siamo fortunati, ma perché il motore
ha una struttura che rende la domanda vuota.

⚠️ **Controprova nel modello additivo** (dove il denominatore cambia): su Dow la
peggior giornata si muove da −1,0227 a un P99 di **−1,1617** e un peggiore di
**−1,2304**. 🟢 **Cioè l'invarianza è una proprietà esatta del modello
moltiplicativo e una quasi-invarianza in quello additivo: lo scostamento massimo
è 0,21 punti, e resta a 3,8 punti dal muro.**

🔴 **L'unica che si muove davvero è `EMA200`** (2,52 posizioni/giorno): lì il
riordino **conta**, e la peggior giornata passa da **−1,98%** a **−3,93%** nel
peggiore dei 20.000. 🟢 **Resta comunque 1,07 punti dentro il muro del 5%** —
ma il margine si è ridotto da 3,02 punti a **1,07**, e questa è esattamente
l'informazione che mancava.

## 7.2 🟠 IL MURO TOTALE DEL 10% — qui invece morde

| sedia (a **rischio 1%**) | DD osservato | **quota riordini iid ≥ 10%** | **quota permutazioni a blocchi ≥ 10%** |
|---|---:|---:|---:|
| 🔴 **ORB `770612`** | 9,7203 | **14,4450%** | **6,8350%** |
| DAX `770115` | 6,2516 | 1,7050% | 0,6150% |
| Dow `770206` | 4,2235 | 0,7200% | 0,2450% |
| EMA200 `771521` | 7,5367 | 0,0000% | 0,4150% |
| SuperWave `770521` | 3,3069 | 0,0000% | 0,0000% |
| XAUUSD `770406` | 2,9838 | 0,0000% | 0,0000% |

🔴 **ORB alla taglia 1% sfonda il muro totale in circa una sequenza su sette.**
Il suo DD osservato (9,72%) era già **a 28 centesimi dal muro**: la distribuzione
dice che quel 9,72 non era un caso particolarmente sfortunato — era **la
mediana + 2,3 punti**, con mediana a 7,46.

🟢 **MA — e va detto subito — la sedia della rosa `770611` gira a 0,65%, non a
1%**, e alla taglia viva il referto di casa le assegna **6,5389%**
(`CENSIMENTO_CONTRATTI_v2.md` r.262). 🔴 **Il conto della coda a 0,65% NON è
stato rifatto qui**: scalare linearmente il P95 sarebbe una proporzione, non una
misura, e questo referto non ne fa. **È un buco dichiarato (§8).**

---

# 8. 🕳️ BUCHI DICHIARATI

1. 🔴 **Due sedie della rosa non hanno NESSUN per-trade in repo**, per nome:
   **`970913`** (SupRev NAS H1) e **`770250`** (Nasdaq Apertura gated short).
   Per loro la distribuzione **non esiste**, e **non è stata stimata**.
2. 🔴 **Tre sedie della rosa sono sotto la soglia delle 50 posizioni**, per nome:
   **`770411`** (14), **`771321`** (23), **`770901`** (31). Il DD ricalcolato è
   in §2.2 (vale per il RISCHIO), la distribuzione no.
3. 🔴 **Nessun per-trade porta il magic della sedia della rosa**: tutti sono
   gemelli. Per **`770101`** e **`770611`** il gemello è **a un'altra taglia**
   (1% invece di 0,65%) e per **`770101`** anche su un **altro banco**; per
   **`770511`** è **un'altra cella**. §3 li elenca uno per uno.
4. 🔴 **La coda alla taglia VIVA non è misurata.** Tutto questo referto è a
   **rischio 1%**. Riscalare a 0,65% è una proporzione, non una misura — e sul
   DD la proporzione è **già stata misurata come imprecisa** in casa (§7.2).
   👉 È la misura più corta da colmare: bastano i per-trade delle celle a 0,65%.
5. 🔴 **Il mio DD è una SOTTOSTIMA sistematica dell'Equity DD del tester**, da
   −0,43% a −32,15% (§2.2), perché non vedo il flottante infragiornaliero.
   **I rapporti sono robusti, i livelli assoluti no.**
6. 🔴 **La peggior giornata NON include il flottante** né il calendario vero
   (§4.2): anche lì il verso dell'errore è **ottimista**.
7. 🔴 **Ogni sedia è misurata DA SOLA.** Il muro giornaliero della prop è sul
   **conto**, con tutte le sedie insieme e le loro correlazioni. **La
   distribuzione del DD di PORTAFOGLIO non è in questo referto.**
   👉 È la misura che manca di più per la challenge, e i dati per farla ci sono
   (i per-trade hanno le date): è un lavoro di CPU, non di macchina.
8. 🟠 **Un abbinamento su nove non è esatto**: MaxMinNotte XAUUSD `770406`, dove
   il per-trade somma **15.875,16** e la riga del tester dice **15.848,75** —
   **26,41 di scarto (0,1664%)** su 92 deal che invece combaciano. Causa **non
   identificata**; la sedia è **fuori rosa** e serve solo da confronto.
9. 🔴 **Un disaccordo sulla peggior giornata non spiegato**: PTE `771311`, tester
   **−1,0045** contro mia **−1,2783**. Sedia sotto soglia, esclusa dal resto.
10. ⚪ **Non coperto da nessuna parte di questo referto**: spread, slippage,
    requote, rifiuti, commissioni, swap, e l'esecuzione della prop vera. Questo
    referto misura **solo** l'effetto dell'ORDINE, a costi invariati.

---

# 9. 📐 RIPRODUCIBILITÀ

- **Script**: `backtest_pipeline/distribuzione_dd_riordino.py` — ASCII puro
  (verificato), nessun numero incollato: depositi dedotti, righe di tester
  cercate per Profit+Trades su 62.237 righe indicizzate, seed esplicito.
- **Corsa citata**: `--riordini 20000 --blocchi 20000 --avversari 5000`,
  seed **20260918** → `backtest_pipeline/risultati_archivio/DD_RIORDINO_2026-09-18.txt`.
- **Controlli interni che lo script fa da sé e che falliscono rumorosamente**:
  `assert` sulla conservazione del multinsieme nella permutazione a blocchi;
  stampa del **residuo di abbinamento** su ogni riga di tester; rifiuto
  esplicito sotto le 50 posizioni; scelta **deterministica** della riga di
  tester col residuo minimo.
