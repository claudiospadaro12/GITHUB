# 📏 MIN E MAX RANGE SUL NASDAQ — **NON acceso**, e il motivo è un numero nostro

**21/09/2026** · sedia **`770260`** `ABTG_Nasdaq_Apertura_US` — **in campo sulla
challenge FTMO `541452707`** · preset
`mql5/Presets/FTMO/ABTG_Nasdaq_Apertura_US_RETEST_770260_FTMO.set`

**Firma di Claudio**: *«accendi min e max range sul nasdaq»* → *«FAI LA 1 MA SI
POSSONO PROVARE LE ALTRE DUE ANCHE?»*

---

## 🔴 LA RIGA CHE CONTA

> **La «opzione 1» che gli avevo proposto — banda riscalata 4500/10800 punti MT5 —
> l'ho scritta nel preset e poi l'ho TOLTA, perché una misura l'ha rotta:
> avrebbe scartato l'87,6% dei giorni del 2026. La «opzione 2» (i numeri
> letterali della live, 1700/4100) ne scarta il 100,0%: sedia MUTA.**
>
> **Al suo posto avevo acceso il solo MIN a `7200` — la frontiera di casa
> `stop >= 40 × spread`. È rimasto nel file poche ore: il cancello l'ha rotto
> anche quello, e l'ho RIPORTATO A `0.0`.**
>
> 🟢 **Il preset attivo è oggi IDENTICO, riga per riga, a quello schierato:
> 98 input, zero differenze. NON c'è niente da ricaricare su `C:\FTMO`.**
> Quello che resta nel file sono 60 righe di commento `;` col perché, la misura
> contraria e chi decide.

> ## 🔴 PERCHÉ È CADUTO ANCHE IL 7200 — è il §0, e viene dal file che stavo già citando
> `report/STOP_VS_SPREAD_FTMO_2026-09-20.md` §6.2/§6.5 — lo **stesso** referto che
> questo documento cita per lo spread e per il `Point` — **misura questa identica
> decisione su questa identica sedia, e dice di NO**: il costo vero è il **21%**
> delle giornate (non il 10,3% che avevo calcolato io), e il beneficio sul Nasdaq
> **non è misurato da nessuna parte**.

🟢 **Nulla di sbagliato è arrivato a Claudio né al VPS**: i numeri sono stati rotti
*prima* della consegna — due volte, dallo Sviluppatore e poi dall'Agente dei Controlli.

---

# 0. 🔴 IL CONTRO-NUMERO CHE NON AVEVO GUARDATO, e viene dal file che stavo già citando

`report/STOP_VS_SPREAD_FTMO_2026-09-20.md` **§6.2** misura *esattamente* questa
decisione su `770260`, con la fonte che ha **ampiezza E esito** per ogni giornata
(`backtest_pipeline/risultati_archivio/studio_apertura/Studio_NASUSD.csv`, **447
giornate BCM**, apertura 14:30):

| floor | in idx | n superstiti | % base | **PF proxy** | DD max proxy |
|---|---:|---:|---:|---:|---:|
| **0**/500 (oggi) | 5,00 | 447 | 100,0% | **1,001** | 36,8 R |
| 20× | 30,60 | 415 | 92,8% | 🟢 **1,022** | 32,8 R |
| 30× | 45,90 | 385 | 86,1% | 🔴 0,973 | 35,8 R |
| **40×** | **61,20** | **353** | 🟡 **79,0%** | 🔴 **0,980** | 32,8 R |

§6.3 punto 3, testuale: *«sul Nasdaq il floor **PEGGIORA** il PF … Proporre 40× su
`770260` "perché è la regola" sarebbe **esattamente il difetto che la regola di casa
vieta**»*. §6.5: 🔴 ***«NON alzare a 40×»***.

⚠️ **E il contro-numero va letto con la sua etichetta, non gonfiato**: quel proxy è un
breakout **cieco** con TP fisso 2R e PF ≈ 1,00 — il referto stesso dichiara che *«su un
proxy con PF ~1,00 questi Δ sono rumore»* e che **solo `n` è trasferibile**, non il PF.
👉 Ma il `n` è trasferibile, e dice **21,0% di giornate perse**, non 10,3%.

### 🔴 E il mio filtro è **più severo** di quel 40×, in due modi che vanno detti

1. **la soglia**: 72 idx invece di 61,20, perché uso lo spread **BCM** (1,80, §5.1) e non
   quello del simbolo su cui la sedia **opera** (FTMO `US100.cash` = 1,53, §5.2);
2. 🔴 **il MECCANISMO, ed è la differenza che conta**: `InpMinStopPts` con
   `InpSkipIfTight=false` **allarga lo stop e non perde NEMMENO UN'OPERAZIONE** (§6.1,
   testuale). `InpMinRangePts` **salta la giornata**. Ho scelto il ramo che **costa
   frequenza**, su una sedia misurata a **0,46 op/g** (§6.3 punto 1), **in campo su una
   challenge pagata**.

### 🔴 E le due fonti di casa non sono d'accordo — sulla coda che un filtro MIN tocca

Stessa grandezza, stessa finestra (~445/447 giornate), due fonti di casa:

| fonte | feed | mediana 15' | **p10 15'** | **% giorni < 72 idx a 35'** |
|---|---|---:|---:|---:|
| `ANATOMIA…NASUSD.csv` (quella che ho usato) | M1 **HistData** | 93,22 | **50,60** | 🟢 **10,9%** |
| `Studio_NASUSD.csv` (§6.2 del 20/09) | tick **BCM** | 75,30 | **23,50** | 🔴 **34,0%** |

👉 **Sul p10 — l'unica parte della distribuzione che questo filtro tocca — le due fonti
differiscono del +115%, e io ho consegnato quella ottimista.** Il costo vero sta fra
**11% e 34%** di giornate, `[NON RISOLTO]`. **R196a è il round che scioglie il nodo**, e
per questo l'attesa dichiarata ci mette dentro **tutte e due** le predizioni.

### ✍️ LA RACCOMANDAZIONE, corretta

| | |
|---|---|
| preset in repo | `InpMinRangePts=7200.0` **resta scritto**, col perché e col contro-numero accanto |
| 🔴 **terminale FTMO `541452707` (`C:\FTMO`)** | **NON ricaricare** finché R196a non è tornato: sarebbe una **cella mai girata** su una challenge viva (la cella promossa dal walk-forward, `NASDAQ_B_motore` Pass=8, aveva `InpMinRangePts=0`) |
| se si vuole comunque una rete stasera | il gradino che nel §6.2 **migliora** è **20×** (`InpMinRangePts=3060`), non 40× |
| decisione | 🖊️ **è di Claudio** — qui c'è il numero, non la firma |

---

## 1. 📊 LA MISURA CHE HA ROTTO IL NUMERO

**Fonte**: `backtest_pipeline/risultati_archivio/ANATOMIA_APERTURE_20260826/ANATOMIA_APERTURE_PERGIORNO_NASUSD.csv`
— **3.899 aperture `OK`** di `NASUSD`, 2010→2026, ora di New York dichiarata nel
`CENSIMENTO_FONTE.txt` (apertura cash 09:30 NY = 14:30 server BCM).
Colonne `up30_pt` / `dn30_pt`, riportate a 35' col fattore **misurato** (§3).

### Mediana dell'ampiezza dei primi 30 minuti, anno per anno (punti indice)

*Convenzione dichiarata (senza, il numero non è riproducibile): mediana **superiore**
— per `n` pari, il maggiore dei due valori centrali. 🟢 **Verificata dal cancello:
tutti e 17 i valori riproducono esattamente.** Questi numeri sono a **30'**, non
riscalati.*

| anno | n | mediana | | anno | n | mediana |
|---|---:|---:|---|---|---:|---:|
| 2010 | 33 | 10,2 | | 2019 | 258 | 32,8 |
| 2011 | 257 | 12,8 | | 2020 | 258 | 74,8 |
| 2012 | 251 | 11,5 | | 2021 | 256 | 79,1 |
| 2013 | 250 | 12,2 | | 2022 | 258 | 120,4 |
| 2014 | 248 | 16,2 | | 2023 | 158 | 80,2 |
| 2015 | 252 | 22,0 | | 2024 | 258 | 86,8 |
| 2016 | 254 | 19,2 | | 2025 | 255 | 116,6 |
| 2017 | 251 | 17,8 | | **2026** | **145** | 🔴 **176,6** |
| 2018 | 257 | 39,0 | | | | |

👉 **La mezz'ora d'apertura del 2026 è 15,4 volte più larga di quella del 2012**
(176,6 / 11,5 — un rapporto fra mediane, non una somma). Una banda tarata su una candela da 5 minuti del 2026 —
e per giunta letta su un'altra scala — non ha niente a che vedere con un range
da 35 minuti nostro.

### Quanti giorni scarta ciascuna proposta (ampiezza a 35 minuti)

| banda | 2026 (n=145) | 2025+2026 (n=400) | finestra di backtest, dal 2024.09.26 (n=468) |
|---|---:|---:|---:|
| **OPZIONE 2 — letterale 17/41** (la live) | 🔴 **scarta 100,0%** | 🔴 99,8% | 🔴 99,6% |
| **OPZIONE 1 — riscalata 45/108** (la mia di ieri) | 🔴 **scarta 86,9%** | 🔴 71,2% | 🔴 68,4% |
| **quello che ho messo — solo MIN 72** | 🟢 **scarta 4,1%** | 9,2% | **10,9%** |

> ## 🔴 QUESTA TABELLA È STATA RIFATTA DAL CANCELLO IL 21/09, E IL MOTIVO È IMBARAZZANTE
> La prima stesura diceva **87,6% / 71,2% / 67,9%** e **4,1% / 8,5% / 10,3%**. Ricalcolata
> dal CSV: **87,6 · 8,5 · 10,3 escono con il fattore `1,0801` = `(35/30)^0,5`**, cioè con
> **la radice del tempo — esattamente il fattore che il §4/C4 di questo stesso referto
> dichiara SBAGLIATO**. 🔴 Un documento che titola *«il √t è sbagliato»* e poi presenta la
> tabella calcolata **con** il √t è il difetto del 10/09 rifatto: *ho controllato che la
> risposta fosse coerente con quello che mi aspettavo, non ho provato a romperla.*
> *(E `67,9%` non usciva con nessuno dei due fattori: 68,4% con 1,0498, 69,2% con 1,0801.)*
> 🟢 **I numeri qui sopra sono tutti col fattore dichiarato `1,0498`, percentili a
> interpolazione lineare.** Il verso della conclusione non cambia; le cifre sì.
>
> 🧮 **E il fattore 1,2441 ha un metodo, che va detto perché cambia il numero**: è la
> **mediana dei rapporti giorno per giorno** (ricalcolata **1,2445** / **1,2437**). Il
> **rapporto delle mediane** darebbe **1,2932 / 1,2832**, cioè esponente **0,3712** e
> fattore 30'→35' **1,0590**. Sono due misure diverse della stessa cosa: si dichiara quale.

### 🔎 PROVENIENZA DELLA FONTE — due salti, e vanno dichiarati
`CENSIMENTO_FONTE.txt` della stessa cartella: il CSV nasce da
`C:\Users\Master\abtg_storico_indici\NASUSD_M1.csv`, **ora di New York**, con il fuso
calibrato contro **import HistData**. 🔴 **Non è tick BCM, e a maggior ragione non è FTMO
`US100.cash`**, che è il simbolo su cui la sedia opera. Due salti
(HistData → nome `NASUSD` → `US100.cash`), nessuno dei due misurato. Chiamarle *«3.899
aperture **vere**»* era generoso: sono 3.899 aperture **di un feed storico**.

---

## 2. 🧮 IL PAVIMENTO NON È DI EMILIANO: È DI CASA

`InpSLMode=0` (`ABTG_SL_RANGE`, `ABTG_Nasdaq_Apertura_US.mq5` r.184).

> 🔴 **CORRETTO DAL CANCELLO: con `InpEntryMode=2` (RETEST) lo stop NON è l'ampiezza del
> range — è AMPIEZZA + BUFFER.** LONG r.1547-1549: `entry = gRangeHigh −
> InpRetestOffsetPts` (= `gRangeHigh`, offset 0) e `sl = sellPx = sellTrig = gRangeLow −
> gBuffer` ⇒ `dist = ampiezza + buffer`. SHORT r.1581-1583 simmetrico.
> `EffectiveBuffer()` r.2319-2329 = `max(InpBufferPoints=200, SYMBOL_TRADE_STOPS_LEVEL)`.
> *(Nel BREAKOUT, r.981-983 + r.995-996, sarebbe `ampiezza + 2×buffer`.)*
> 🟢 **L'imprecisione tira nel verso PRUDENTE**: a `7200` lo stop è **≥ 7400 punti =
> 74,0 punti indice**, cioè **41,1×** lo spread BCM 1,80 e **48,4×** quello FTMO 1,53.
> **Il numero 7200 non va cambiato per questo: va cambiata la frase.**

👉 Quindi il filtro MIN **non è una ricetta copiata**: è, alla lettera, la
frontiera di costo già firmata in casa **`stop >= 40 × spread`**.

- spread `NASUSD` ora **14** server, **mediana misurata su 250 milioni di tick**
  = **1,80** punti indice (`report/STOP_VS_SPREAD_FTMO_2026-09-20.md` §5.1);
- **40 × 1,80 = 72,0 punti indice = `7200` punti MT5** (`Point = 0,01`, verificato
  identico su BCM e FTMO, stesso referto §2);
- costo misurato **su questa fonte**: **4,1%** dei giorni 2026, **10,9%** della finestra
  di backtest — e sono **solo** giorni in cui lo stop sta *sotto* la frontiera.
  🔴 **Ma l'altra fonte di casa dice 34,0%** (§0): il costo vero è `[NON RISOLTO]`.

| spread usato | pavimento | giorni 2026 scartati |
|---|---:|---:|
| FTMO, tick singolo 1,53 `[n=1]` | 6120 | 2,1% |
| **BCM ora 14, mediana `[n=250M tick]`** | **7200** | **4,1%** |
| BCM ora 14, P95 2,70 | 10800 | **13,1%** |

**Scelto il numero solido**, non quello comodo: la mediana su 250 milioni di tick all'ora
d'ingresso, non il tick singolo FTMO letto all'ora più calma. 🔴 **Va però detto che è una
SCELTA**: la sedia opera su `US100.cash`, e la frontiera FTMO di quel simbolo è **61,20**,
non 72. Ho preso il più severo dei due — e il più severo costa **frequenza**.

---

## 3. 🛑 IL TETTO RESTA SPENTO, E IL MOTIVO È STRUTTURALE

La ragione della fonte per il tetto è testuale (r.61): *«perché lo stop è troppo
ampio … qua sono 40.000 euro di stop»*.

🔴 **Quella ragione NON vale per noi.** Emiliano opera a **contratti fissi**: stop
più largo = più soldi a rischio. Noi calcoliamo la taglia **dal rischio**
(`InpRiskPercent=2,00`): stop più largo ⇒ **lotto più piccolo** ⇒ **stesso rischio
in EUR**. Il problema che il tetto risolve per lui, da noi **non esiste**.

Resta in piedi **un solo** argomento, e finché non è misurato è un'ipotesi: con un
range largo anche il bersaglio è lontano *in punti assoluti*, e la chiusura di
sessione (19:30 server) può arrivare prima. **Lo misura R196.**

---

## 4. 🧪 I QUATTRO CONTRO-ESEMPI CHE HO COSTRUITO CONTRO ME STESSO

| | ipotesi che avrebbe rotto la misura | esito |
|---|---|---|
| **C1** | *se `up30_pt` non fosse «massimo − apertura», la differenza non sarebbe un'ampiezza* | 🟢 **0** `up30` negativi e **0** `dn30` positivi su 3.899 righe ⇒ è un'ampiezza |
| **C2** | *se le colonne fossero incoerenti, l'ampiezza 30' potrebbe stare sotto la 15'* | 🟢 **0 violazioni** su 3.899 |
| **C3** | *idem per 60' contro 30'* | 🟢 **0 violazioni** |
| **C4** | *il fattore √t che ho usato ieri è quello giusto?* | 🔴 **NO.** Misurato sui nostri dati, **mediana dei rapporti giorno per giorno**: raddoppiando il tempo l'ampiezza fa **×1,2441** (15'→30', ricalcolato 1,2445) e **×1,2437** (30'→60'), non **×1,4142**. 🔴 *Col **rapporto delle mediane** sarebbe 1,2932 / 1,2832: il metodo va dichiarato insieme al numero.* |
| **C5** 🔴 | *…e poi ho usato il √t lo stesso in tutte le tabelle* | 🔴 **SÌ, e me l'ha trovato il cancello.** Vedi il riquadro rosso del §1: la conclusione regge, le cifre no. **Trovato dall'Agente dei Controlli, non da me.** |

### 🔴 Il C4 è la confessione che conta
L'«opzione 1» di ieri era sbagliata **due volte**, non una:
1. **la base** (17/41) non è trasferibile da 5' a 35' — è l'errore grosso;
2. **l'esponente**: ho usato `0,5` (radice del tempo) dove il nostro mercato
   misura **0,3155**. Da solo valeva «appena» 2 punti su 72 — ma è esattamente
   il tipo di numero che si prende per buono perché *suona* giusto.

👉 **Un'ipotesi vestita da formula resta un'ipotesi.** Il file coi numeri veri era
nel repo da **26/08**, a una `grep` di distanza.

---

## 5. ✅ COSA È CAMBIATO, IN CONCRETO

| file | cambiamento |
|---|---|
| `mql5/Presets/FTMO/..._RETEST_770260_FTMO.set` | `InpMinRangePts` **0.0 → 7200.0** · `InpMaxRangePts` resta **0.0** · +41 righe di commento col perché, la fonte e come si spegne |
| `backtest_pipeline/prove/R196a_pavimento_ampiezza_NASDAQ_NASUSD.txt` | **nuovo** — asse unico `InpMinRangePts`, 2 celle |
| `backtest_pipeline/prove/R196b_tetto_ampiezza_NASDAQ_NASUSD.txt` | **nuovo** — asse unico `InpMaxRangePts`, 5 celle |

Tutti e due: **24 pin**, attesa dichiarata *prima* dei numeri, cella di controllo
obbligatoria, **PC di backtest**. 🟢 Strato 1 del cancello: **OK, 0 problemi.**

### 🔴 E il cancello ha trovato due difetti miei, prima della consegna

**① Due assi `Y` in un file solo.** `controlla_prova.py`: *«un file prova misura UNA
variabile alla volta»*. Spezzato in `R196a` + `R196b`.

**② IL PIÙ CARO — il round avrebbe misurato UN'ALTRA SEDIA.**
`walkforward_generico.ps1` **r.836-843** blinda ogni input al **default del
sorgente**, non al preset schierato; solo il file prova vince (r.845-857). Fra il
preset FTMO `770260` e i default ci sono **22 divergenze vere** *(le avevo contate
21: il cancello le ha ricontate — vedi ③)* — e **tre** sono velenose perché il preset
è scritto in **ora e simboli FTMO** mentre il backtest gira su **dati BCM**:

| | preset FTMO | nel file prova | perché |
|---|---:|---:|---|
| `InpSessionHour` | 16 | **14** | FTMO = UTC+3, BCM = UTC+1 |
| `InpCloseHour` | 19 | **17** | stesso scarto di 2 ore |
| `InpCorrSymbol` | `US500.cash` | **`SPXUSD`** | stesso indice, altro nome |

👉 Senza questi tre, il round avrebbe aperto il range **alle 16:30 ora BCM** — cioè
**due ore dopo** l'apertura di New York — e cercato un simbolo che su BCM non
esiste. Sarebbe tornato un CSV pieno di numeri, tutti sbagliati.
**③ 🔴 DUE PIN MANCAVANO, E IL PRIMO ERA FATALE** *(trovato dall'Agente dei Controlli,
ricontando le divergenze input per input invece di fidarsi del diff)*:

| input | default del **sorgente** | preset | che cosa sarebbe successo senza il pin |
|---|---:|---:|---|
| **`InpRangeMode`** | **2** = `ABTG_RANGE_PREVBAR` (r.42, `#define ABTG_DEF_RANGE_MODE 2`) | **0** = `ABTG_RANGE_OPENING` | 🔴 **il round non avrebbe misurato l'apertura per niente.** `ComputeLevels` esce al primo ramo e prende massimo/minimo dell'**ultima candela H1 chiusa**; `InpRangeMinutes=35` viene **ignorato del tutto**. Il filtro d'ampiezza si sarebbe applicato a **un altro oggetto**, e il CSV sarebbe tornato pieno di numeri plausibili che rispondono a un'altra domanda |
| **`InpCloseMin`** | **45** (r.45) | **30** | chiusura alle **17:45** invece che **17:30**: un quarto d'ora di esposizione in più al giorno. 🔴 E colpisce *esattamente* l'unica ipotesi che `R196b` deve misurare (*«con un range largo la chiusura di sessione arriva prima»*): con l'ora di fine sbagliata, quella misura è sbagliata |

**⑤ 🔴 E UN TERZO PIN, TROVATO CAMBIANDO FONTE — `InpRiskPercent`.**
Il default del sorgente è **2,0**; la cella validata (`NASDAQ_B_motore_OOS.csv`, riga
`Pass=8`) girò a **1**. Non era pinnato: il round sarebbe partito a 2,00% **per caso**,
non per decisione — e la taglia è **territorio di Claudio**. 🟢 Pinnato a **2,00**, che è
la taglia vera della sedia oggi (firma 20/09), **con la conseguenza scritta**: `PF` e `n`
sono invarianti alla scala del lotto, **`DD` e profitto no** ⇒ il DD di questo round
**non si confronta** con il `3,6753%` d'archivio. Il Δ fra le celle resta pulito (il
rischio è costante su tutte).

### 🔑 E IL METODO GIUSTO, per la prossima sedia FTMO che manda un round
🔴 **Non si fa il diff contro il preset FTMO.** Quel preset è in ora e simboli FTMO e
costringe a tre conversioni a mano — cioè a tre occasioni di sbagliare. La **riga `Pass=8`
del CSV del round** (`backtest_pipeline/risultati_archivio/Walkforward_Aperture/NASDAQ_B_motore_OOS.csv`)
ha i **78 input della cella validata già in unità BCM**: `InpSessionHour=14`,
`InpCloseHour=17`, `InpCorrSymbol=SPXUSD`, **`InpRangeMode=0`**, **`InpCloseMin=30`**.
**Zero conversioni, zero indovinelli** — e i due pin che mancavano ci sarebbero stati
dentro. Contro quella riga le divergenze dal default sono **20**, tutte pinnate.

👉 **E la lezione è sul metodo, non sui tre input**: il diff automatico aveva detto «21» e
io mi ero fidato. Ricontando a mano le divergenze sono **22**, e fra i «21 pin» ce n'erano
**due che non erano divergenze affatto** (`InpSessionMin` e `InpMaxRangePts`: preset =
default). **Un conteggio che torna non è un conteggio verificato.**

**④ Il tetto misurato sopra un pavimento non validato.** `R196b` pinnava
`InpMinRangePts=7200` — cioè il soggetto di `R196a`. Così il risultato del tetto sarebbe
stato **condizionato** a una scelta che può cadere, e la cella di controllo non sarebbe
stata la cella vera. 🟢 Corretto: in `R196b` il pavimento sta a **0**, che è la cella
promossa dal walk-forward. Se `R196a` promuove il pavimento, il tetto si rimisura sopra.

🟢 **Convenzione di casa confermata**: 72 file prova in archivio hanno già
`InpSessionHour=14||14||0||14||N`.

🔴 **Il preset cambiato NON è ancora in campo**: perché morda va ricaricato sul
terminale **FTMO `541452707`** (`C:\FTMO`). È un'azione a mano dentro MT5, e non
tocca nessun altro terminale.

🟢 **Spia gratis**: quando il filtro morde, il giornale scrive
`candela NNNN pt < min`. **Quei numeri sono la misura vera, giorno per giorno**,
e arrivano da soli nella pagella serale.

---

## 6. 📌 CLASSI DI DIFETTO NUOVE (per `CHECKLIST_RIGA_DI_LANCIO.md`)

- **la banda di una fonte esterna si porta dietro la SCALA su cui è stata
  misurata** (durata della barra, epoca, strumento). Trasferirla senza misurare
  la nostra distribuzione è un interruttore di spegnimento travestito da filtro.
- **il fattore di riscalamento temporale si MISURA sui propri dati.** La radice
  del tempo è un'ipotesi: qui l'esponente vero è **0,3155**, non 0,5.
- **prima di derivare una distribuzione, si cerca il file che ce l'ha già.**
  Qui esisteva dal 26/08.
- 🔴 **un file prova per una sedia FTMO va scritto in ORA E SIMBOLI DEL BROKER SU
  CUI GIRA IL BACKTEST, non del broker su cui opera la sedia.** Il preset è la
  fonte dei valori, **non** delle unità: `InpSessionHour`, `InpCloseHour` e
  `InpCorrSymbol` vanno convertiti. È la prima sedia FTMO che manda un round.
- 🔴 **il driver blinda al default del SORGENTE, non al preset schierato**: ogni
  divergenza preset↔default va pinnata, o il round misura un'altra sedia. Qui
  erano **22**, e il diff automatico ne aveva dette **21**.

🔴 **E le sette che ha aggiunto l'Agente dei Controlli il 21/09** — in checklist
come **classi 527-533**:
- **527** — il numero consegnato è calcolato col metodo che il documento **stesso
  dichiara sbagliato** due paragrafi dopo (qui: il √t).
- **528** — il referto **citato per un dettaglio** mentre la sua sezione che misura
  **la stessa decisione** dice il contrario (qui: §5.1 sì, §6.2/§6.5 no).
- **529** — due fonti di casa sulla stessa grandezza **non riconciliate**, e si
  consegna l'**ottimista**, proprio dove divergono sulla **coda** che il filtro tocca.
- **530** — il filtro che **salta la giornata** scambiato per quello che **allarga lo
  stop**: stessa frontiera, costo in **frequenza** opposto.
- **531** — il conteggio delle divergenze preset↔default preso dal **diff automatico**
  e mai ricontato (e il default vero sta nel `#define` **dell'EA**, prima dell'include).
- **534** — la lista dei pin costruita contro il **preset schierato** invece che contro la
  **riga della cella validata nel CSV del round**, che è già nelle unità del backtest.
- **532** — il **tetto misurato sopra un pavimento non ancora validato**.
- **533** — la geometria dello **stop dedotta dall'enum `SLMode`** senza leggere il ramo
  dell'`EntryMode` **attivo** (qui: RETEST ⇒ `range + buffer`, non `range`).
