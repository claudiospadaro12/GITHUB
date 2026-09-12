# 🪦 I BOCCIATI HANNO UN CERTIFICATO? — censimento voce per voce, 12/09/2026

> **La richiesta di Claudio, testuale, oggi:** _"Si ma lavoriamo sui motori bocciati. No?"_
>
> **Ha ragione. E la risposta piu' importante di questo dossier non e' un elenco: e' un numero
> che era in casa da sei settimane e che nessuno aveva mai scritto.** Sta al §5.

_Compilato il **12/09/2026** in **sola lettura d'archivio**. **Nessun backtest lanciato,
nessun EA / preset / magic / sedia / parametro di forward toccato. `CODA.txt` non toccata
(letta in sola lettura per non proporre doppioni).** Tre file prova nuovi, gia' passati dal
cancello deterministico. Il secondo strato (agente `controllo-preventivo`) **non lo posso
invocare io**: lo lancia la sessione madre su cio' che consegno. **Lo dichiaro.**_

---

## 1. 🔢 LA FALSIFICAZIONE DEL CONTO 89/12 — e il conto del brief e' RIPRODUCIBILE, ma misura un'altra cosa

**Prima cosa: ho riprodotto i numeri del brief al numero esatto**, con la sua stessa regola
(per RIGA, i cinque termini `senza edge|bocciat|scartat|MORTO|archiviat`):

| misura del brief | il mio ricalcolo | esito |
|---|---:|---|
| righe con verdetto negativo | **89** | ✅ identico |
| di quelle, righe che contengono anche "PF" | **12** | ✅ identico |
| righe che citano la frequenza | **47** | ✅ identico |
| `NON ANCORA MISURATO` gia' dichiarati | **4** | ✅ identico |

🟢 **Quindi il conto del brief non e' sbagliato: e' un conto giusto di un oggetto sbagliato.**
Una RIGA non e' una VOCE. Nel registro una voce puo' occupare **1 riga** (una riga di tabella,
tipo `| O3 | DAX_M3 | ... | morto |`) oppure **quaranta** (una lapide in prosa con la sua
saga). Il conteggio per riga quindi **sovraconta le prose** e **sottoconta le tabelle** — nei
due sensi contemporaneamente, per questo non si corregge con un fattore.

### 🎯 IL CONTO VERO, a mano, per VOCE

**Perimetro, elencato per nome e non per differenza (classe 180):** una voce e' un candidato
per cui (a) esiste un EA `ABTG_*.mq5` nel repo **e** (b) esiste un verdetto negativo scritto in
`backtest_pipeline/REGISTRO_TEST.md`. L'unita' e' **motore x simbolo x TF**.
**Restano FUORI dal perimetro, e sono contate a parte:** ~30 lapidi da **sonda Python o da
paper** (meccanismi mai diventati EA di casa: M31 salto, M11 fix valutari, M23 numeri tondi,
M25 lead-lag, L1-L6, LBMA, oro<-dollaro, bond->oro, M16 Nagel, quarto d'ora...) e ~20 **EA
esterni** scartati al setaccio §4 senza produrre un numero (Market Miner, ZetaBurst/PulseStrike,
Heikin Ashi Engulfing, KCI Sniper, Bar Counter Trend, AxMan, Bearish Wick, Sniper Gold,
XANDER, Quantum, GoldWarrior, gli 8 Pine sui metalli...).

**Unita' di conto, dichiarata per non barare:** una VOCE = **una riga delle tabelle del §2**.
Sono 72, elencate per nome li' sotto, e chiunque puo' ricontarle.

| | numero VERO | contro il brief |
|---|---:|---|
| **VOCI con verdetto negativo (candidati di casa)** | **72** | il brief contava **89 righe** |
| voci con **almeno un PF misurato** (registro **o** archivio) | **52** su 72 = **72%** | il brief vedeva **12 righe con "PF"** |
| voci **senza** nessun PF | **20** su 72 | il brief ne stimava **77** |
| voci **CHIUSE** (rischio, certificato completo, o costo) | **25** | — |
| voci **NON ANCORA MISURATE** (manca >= 1 voce del certificato) | **47** su 72 = **65%** | il registro ne dichiara **4** |
| di quelle 47, quelle a cui manca la **voce 3 (uscita)** | **38** | — |
| voci con **tutte e cinque** le voci — *lettura LARGA* | **8** (+2 chiuse per COSTO, dove il certificato non si applica) | — |
| voci con **tutte e cinque** — *lettura STRETTA* | **2** (`EMA200 E50EUR` H1 e H4) | — |

🔴 **La tesi del brief ("77 bocciati senza PF") e' FALSA, e va detto forte: i bocciati senza
PF sono 20, non 77 — e 52 su 72 hanno un PF.** Il PF non stava sulla riga accanto: stava
**nel CSV accanto**. Dieci di quei PF li ho **ricalcolati io oggi dai CSV grezzi** perche' nel
registro non c'erano affatto (§3) — e sono tutti numeri che **confermano** la bocciatura, non
che la ribaltano. 👉 **Se avessi consegnato il 77, avremmo speso giorni a cercare numeri che
erano gia' in casa.**

🔴 **Ma il buco vero e' un ALTRO, ed e' piu' grosso di quello che il brief cercava: 47 voci su
72 non hanno il certificato completo**, e in **38 casi su 47 la voce che manca e' la numero 3,
la GESTIONE DELL'USCITA.** Non e' una sorpresa: e' esattamente il numero che
`report/AUDIT_USCITE_2026-09-09.md` §1 riga 3 aveva gia' misurato (*"13 meccanismi su 32 MAI
messi ad asse"*, e su tutta la famiglia Supertrend **zero**). **Il censimento di oggi lo
traduce in candidati: 38.**

### ⚖️ UNA DISTINZIONE CHE HO DOVUTO FARE IO, E VA FIRMATA DA CLAUDIO
Il certificato di morte (09/09) chiede cinque voci. **Ma l'Emendamento B del 16/08 dice che un
drawdown e' un fatto accaduto, che vale a qualunque `n`.** Le due regole si toccano: un
candidato bocciato con **DD oltre il muro prop** ha una ragione che **non ha bisogno delle
altre quattro voci**.
👉 **Lettura che ho applicato, e la dichiaro come mia interpretazione, non come regola
esistente:** una bocciatura **PER RISCHIO** (DD misurato oltre il muro) **chiude il candidato
senza il certificato a cinque voci**; il certificato serve a proteggere dalle bocciature
**PER MERITO**. Sono **15 righe** in questa classe (§2.A). 🙋 **Se Claudio non e' d'accordo,
quelle 15 tornano tutte in coda e i "morti" certificati scendono da 25 a 10.**

---

## 2. 📋 LA TABELLA COMPLETA — 72 voci, cinque colonne, il file che lo prova

Legenda delle cinque voci del certificato: **1** PF · **2** n e DD · **3** gestione
dell'uscita ad asse · **4** simboli gemelli · **5** TF cambiato.
Colonna **3**: `L` = l'asse d'uscita esiste su **un altro simbolo della stessa famiglia di
motore** (lettura LARGA, la piu' generosa); `S` = esiste su **questo** motore e questo
simbolo, con CSV agli atti (lettura STRETTA). Fonte della colonna 3:
`report/AUDIT_USCITE_2026-09-09.md` Tabelle A e B.

### A. 🔒 CHIUSI PER RISCHIO — DD misurato oltre il muro. **Si chiude, e non si ritocca piu'.**
_Emendamento B: un DD e' un fatto accaduto, vale a qualunque n._
⚠️ **Nota sul banco, e vale per A05-A08 e A13:** quei DD sono **OHLC**, cioe' screening.
🟢 **Ma qui la direzione dell'errore aiuta: l'OHLC e' OTTIMISTA**, quindi un DD del
15-22% su OHLC a tick puo' solo PEGGIORARE. E' l'unico caso in cui un numero OHLC vale
come chiusura, e lo scrivo perche' e' un'**eccezione** alla regola di casa, non la regola.

| # | candidato | TF | banco | PF | DD | n | il cancello |
|---|---|---|---|---:|---:|---:|---|
| A01 | `LondonFx` EURUSD motore 2 | M15 | tick | OOS **0,843** (IS 0,795) | **37,14%** | — | DD > 8% e > muro prop 10% |
| A02 | `LondonFx` EURUSD motori 1 e 3 | M15 | tick | — | **45,29% / 31,26%** | — | idem |
| A03 | `LondonFx` GBPUSD motore 2 | M15 | tick | OOS **0,763** (IS 0,688) | **55,03%** | — | idem ⚠️ banco sporco su motore 3, R116-BIS pronta e mai girata: **non cambia il verdetto** |
| A04 | `RELATIVO` D30EUR | M5 | tick | OOS **0,452** | **25,01%** | — | DD + peggior giornata **−5,20%** |
| A05 | `Nightly` EURUSD | (TF grafico) | OHLC | IS 1,049 / OOS **0,861** | 10,80 / **15,49%** | 106 / 164 | DD OOS > muro |
| A06 | `Nightly` GBPUSD | idem | OHLC | IS **0,586** / OOS 1,040 | **22,62** / 11,28% | 96 / 163 | DD IS > muro |
| A07 | `Nightly` USDCHF | idem | OHLC | 0,863 / 0,970 | 11,42 / **14,16%** | 81 / 131 | DD > muro |
| A08 | `Nightly` EURCHF | idem | OHLC | 0,891 / 0,814 | 11,10 / **15,39%** | 63 / 85 | DD > muro |
| A09 | `MaxMinNotte` 100GBP | (notte) | tick | best **0,6717** | **16,03%** | 82 | **0/54 celle positive** + DD |
| A10 | `MaxMinNotte` E50EUR | idem | tick | best **0,8398** | **13,90%** | 80 | **0/54** + DD |
| A11 | `MaxMinNotte` F40EUR | idem | tick | best **0,9985** | **10,12%** | 112 | **0/54** + DD al muro |
| A12 | `BreakinBox` D30EUR | (notte) | tick | tesi 1,007 / controllo 1,106 | **24,10 / 19,70%** | ~20/mese | cancello DD <= 15% |
| A13 | `SuperWave` D30EUR | H1 | OHLC | max **0,84** | **17%** | — | DD + PF |
| A14 | `SuperWave` GBPUSD | H1 | (R103) | **0,79** | **13,4%** | 5/7 anni neg | DD + PF, spenta 24/08 |
| A15 | `RsiEmaV8` (3 indici) | M5/M15 | sonda | [NON MISURATO] | — | — | **muro F4**: rischio aperto **19,5% (M5) / 8,45% (M15)** contro cap **C1 3,25%** |

> 🔴 **A09-A11 sono la novita' di questa tabella**: nel registro quelle tre righe dicevano
> *"max 0.67 / max ~1.0 / max 0.59"* e **nient'altro**. Il `n` e il `DD` non c'erano.
> Li ho estratti oggi da `risultati_archivio/MaxMinNotte/*-valid_MaxMin_*.csv` (54 celle
> ciascuno). **E il numero che chiude e' il DD: sulla cella MIGLIORE, cioe' la piu'
> favorevole, il drawdown e' 10,1-16,0% a rischio 1%.** Un motore la cui cella migliore sta
> a PF <= 1,0 con DD >= 10% non ha una cella buona altrove: ha solo celle peggiori.
> ✏️ E una **errata**: il registro scrive *"CAC max ~1.0"* -> il numero esatto e' **0,9985**,
> quindi **sotto** 1, non "a pari".

### B. 🔒 CHIUSI CON IL CERTIFICATO COMPLETO (5 su 5) o PER COSTO — **10 voci, e si chiude**

| # | candidato | TF | PF | DD | n | 1 | 2 | 3 | 4 | 5 | il cancello |
|---|---|---|---:|---:|---:|:-:|:-:|:-:|:-:|:-:|---|
| B01 | `EMA200` E50EUR | H1 | best **0,7403** | 7,12% | 210 deal | ✅ | ✅ | ✅ S | ✅ | ✅ | **0/88 celle positive** |
| B02 | `EMA200` E50EUR | H4 | best **0,9535** | 4,64% | 81 deal | ✅ | ✅ | ✅ S | ✅ | ✅ | **0/81 celle positive** |
| B03 | `SupRev` 100GBP | H1 | best **0,8822** | 4,55% | 160 deal | ✅ | ✅ | ✅ L | ✅ | ✅ | **0/27 celle positive** |
| B04 | `SupRev` 100GBP | H4 | best 1,2891 | 2,04% | 48 deal | ✅ | ✅ | ✅ L | ✅ | ✅ | 5/27 positive, n 48 -> merito sospeso, e la gamba H1 e' 0/27 |
| B05 | `SupRev` 225JPY | H1 | best 2,1574 | 0,22% | 75 deal | ✅ | ✅ | ✅ L | ✅ | ✅ | 🔴 **scartato per TAGLIA DEL CONTRATTO**, non per edge: profitto ~50 EUR, lotto JPY minuscolo. Il cancello e' strutturale e non si riapre cambiando parametri |
| B06 | `SupRev` 225JPY | H4 | best 2,1626 | 0,12% | 27 deal | ✅ | ✅ | ✅ L | ✅ | ✅ | idem B05 |
| B07 | `SupRev_DOW_H4_Ott` (970914) | H4 | PFmed IS **0,741** / OOS **0,921** | 3,3% | 56-79 | ✅ | ✅ | ✅ L | ✅ | ✅ | **PROMOZIONE REVOCATA 30/07**: un keeper si giudica sulla MEDIANA, e la mediana sta sotto 1 |
| B08 | `SupRev_CAC_H4_Ott` (970915) | H4 | RT **0,96** | 3,5% | 65 | ✅ | ✅ | ✅ L | ✅ | ✅ | idem B07 (overfit) |
| B09 | `EMA200` U30USD | M5·M15·M20·M30 | — | — | — | n/a | n/a | n/a | n/a | ✅ | 🔴 **ESCLUSI PER COSTO col numero**: M5 **11,5-13,1x** (sfonda il duro 13,3x) · M15 20,0-22,6x · M20 23,1-26,1x · M30 28,3-32,0x, contro la frontiera 40x. Spread MISURATO su 64.711.285 tick |
| B10 | ORO finestra 15:36 | M1 | — | — | 33 op reali | n/a | n/a | n/a | n/a | ✅ | 🔴 **BOCCIATO PER COSTO**: stop/spread **8,8-12,5x** contro il pavimento DURO **13,3x**. Manca un fattore 3,2-4,5x al pavimento di lavoro. Prova in campo: **22 vinte su 33 (66,7%) e −785,99 EUR netti**, di cui ~473 di pedaggio |

> 🟢 **B01-B03 sono chiusi da un numero che ho ricalcolato io oggi**, e il registro non lo
> aveva: `EMA200 E50EUR H1` **0 celle positive su 88** con `n` fino a **467 deal**, e
> `SupRev 100GBP H1` **0/27** con `n` **160 deal**. ⚠️ Sono **OHLC**, cioe' **SCREENING** —
> ma qui la direzione dell'errore aiuta: **l'OHLC e' OTTIMISTA**, e un modello ottimista che
> da' **zero celle positive su 169 letture** (E50EUR H1+H4) non sta nascondendo un edge.
> **E' l'unico caso in cui uno zero OHLC vale come chiusura, e va detto perche' e' un'eccezione.**
> ✏️ **ERRATA che ho trovato verificando**: `REGISTRO_TEST.md` r.2296 accoppia *"best PF
> 3,0247, DD 2,59%"* su `EMA200 U30USD H4`. Sul CSV la cella a **PF 3,02473** ha **DD
> 2,4575**; il **2,5927** e' della cella **successiva** (PF 2,81599). Non sposta il verdetto,
> ma e' la stessa classe di difetto del *"PF senza l'aggettivo davanti"*: due numeri di due
> celle diverse su una riga sola.

### C. 🟠 NON ANCORA MISURATI — **47 voci.** Tornano in coda all'imbuto, **mai in campo in automatico**
_Qui scrivo solo **cosa manca**. La graduatoria di cosa conviene misurare sta al §6._

**C.1 — manca SOLO la voce 3 (gestione dell'uscita): 22 voci.** Sono i candidati piu'
vicini a un verdetto vero, perche' il resto c'e' tutto.

| candidato | TF | PF | DD | n | cosa manca |
|---|---|---:|---:|---:|---|
| `EMA200` **AUDJPY** H4 | H4 | tick PFmed **1,364**, centro altopiano **1,623** | **2,90%** | 283 deal (~141 pos) | 🔴 e manca anche lo **SPLIT IS/OOS**: vedi §5, e' il candidato n.1 |
| `EMA200` **GBPUSD** H4 | H4 | tick PFmed **1,235**, centro **1,328** | 5,98% | 295 deal (~147 pos) | idem |
| `EMA200` **GBPJPY** H4 | H4 | tick PFmed **1,456**, best 2,060 | 3,36% | 146-287 deal | idem |
| `EMA200` **200AUD** H4 | H4 | tick PFmed **1,590** | 1,42% | 83-155 deal | idem |
| `EMA200` **SPXUSD** H4 | H4 | tick PFmed **1,444**, 31/31 celle long positive | 1,96% | 68-122 deal | idem + campione |
| `EMA200` **USDNOK** H4 | H4 | tick PFmed **0,903** | 2,27% | 162-177 deal | superficie di rumore: 74 celle sopra 150 ma solo 23 sopra PF 1,10 |
| `EMA200` NASUSD | H1 | 1/85, best **1,0197** | 5,74% | 255 deal | l'uscita **e** il TF su QUESTO simbolo (il file H4 **non esiste**) |
| `SupRev` D30EUR | M5 | 0% celle positive | 30-37% | — | ⚠️ **e comunque M5 sugli indici e' escluso PER COSTO** (11,5-13,1x) |
| `SupRev` NASUSD | M5 | best **1,10** | 11,5% | — | idem |
| `SupRev` F40EUR | H1 / H4 | 1,2853 / 1,7065 | 6,37 / 3,12% | 131 / 65 | l'uscita; H1 8/27 e H4 8/27 positive |
| `SupRev` E50EUR | H1 / H4 | 1,4743 / 2,7997 | 1,21 / 0,60% | 60 / 49 | l'uscita + il campione (6/27 e 10/27) |
| `SuperWave` NASUSD | H4 | "negative" | — | 16-18 | l'uscita + n/DD |
| `SuperWave` XAUUSD | H1/H4 | ~1,0 / neg | — | — | l'uscita + n/DD |
| `SuperWave` DOW **lato short** | H1 | OOS **0,429** | — | — | l'uscita (e il lato long e' vivo: 770511) |
| `Live5m_v2` D30EUR | M5 | best **1,0430** | 9,10% | 239 deal | l'uscita — 8/32 positive. ⚠️ e M5 indici e' escluso per costo |
| `Live5m` D30EUR / NASUSD | M5 | 27/27 negative | 15-26% | — | l'uscita + n/DD. ⚠️ escluso per costo |
| `EasyTrend` AUDJPY | H1 | r48 0,65-3,24 / r53 0,81-1,17 | 8,17-10,86% | 19-54 | l'uscita **e** il TF (H1 solo) |
| `CostToCost` XAGUSD | H1/H4 | **0,70**, 6/7 anni neg | — | — | il DD; `InpExitMode` **e'** ad asse ma solo su screening OHLC |
| `InvEsaurimento` E3 | — | **1,16** totale | — | — | l'uscita; e il verdetto e' **REGIME-CONDIZIONALE** (−5.604 nel toro 2017 / +2.946 nell'orso Q4-2018) |
| `Chaos ablazione` | M15 | 1,789 vs 1,150 | 8,78 vs 21,01% | — | l'uscita; ingrediente LLE non promosso per lettera congelata |
| `Apertura` 100GBP | M5 | **0,90** | 9,6% | — | l'uscita e' ✅ L (famiglia aperture, R46/R47/Dow): manca **n** |
| `Apertura` U30USD | M5 | **0,997** | 8,6% | — | idem: manca **n** |

**C.2 — manca la voce 3 E la voce 5 (uscita + TF): 14 voci.**
`PostNews` A (ISM 15:15 EURUSD, PF 0,76 n 234 DD 6,92 / 0,79 n 312 DD 6,94) ·
`PostNews` B (13:45 USDJPY, PF 0,66 n 151 DD 4,75 / 0,90 n 253 DD 4,56) ·
`IBRetest` U30USD+NASUSD+D30EUR M30 (PF famiglia **0,7798**, n 344, DD max 7,61%, cancello **C0**) ·
`RELATIVO` NASUSD M5 (PF OOS 1,189, DD 8,40%, n 87/154 -> **merito sospeso**, A6 raggiungibile da sola verso il **27/11/2026**) ·
`ChaosLyapunov` NASUSD_EXT M15 (PF 0,39-0,42 gate stretto / 1,25-1,33 largo, **1 cella su 105**, n 55-92) ·
`NYRetest` U30USD M15 (PF **1,37-1,43** a slope 75, DD 3,7-4,7%, **n 114-115 < 150**) ·
`DaxReEntry` D30EUR lato SHORT (long 6/6 verde fino a PF 1,80 DD 2,5%, n <= 92) ·
`CRT TurtleSoup` (PF 0,43-0,73 a tick nel toro, 0/30; col gate 0,459) ·
`R95` sweep+reclaim EURJPY (0/30, PF 0,65-0,80; **n e DD [NON SCRITTI]**) ·
`VwapRevert` D30EUR M15 (S0 −0,11/−0,21/−0,14/−0,21, n OOS 107; **PF [NON SCRITTO]**) ·
`AltaVelocita` (rosso 8/8 a tick; **i numeri non sono nel registro**) ·
`Londra_ORB` GBPUSD (11% celle positive, DD 23%; **PF [NON SCRITTO]** — e il fuso misurato
il 03/09 dice che quel round misurava la **PRE-apertura**, non l'apertura) ·
`DAX_M3` D30EUR (33% positive, short 0%; **PF, n, DD [NON SCRITTI], nessun CSV in archivio**) ·
`SondaOrologio` D30EUR+U30USD (0 fasce asimmetriche su 72 in OOS; la **gamba forex non e'
mai girata**).

**C.3 — manca la voce 4 (simboli gemelli) e/o il banco e' ROTTO: 4 voci.** 🔥 **E' il
giacimento.**

| candidato | cosa e' rotto | cosa manca | il numero che lo prova |
|---|---|---|---|
| `FiboH4_Multi` (8 "simboli") | 🔴 **il banco.** `InpSymbols` pinnato VUOTO -> MT5 lo ignora -> ha girato il default `GBPUSD;USDJPY;EURUSD`. **Ricontato oggi: 96 righe su 96.** | voci **3, 4, 5**. **ZERO simboli singoli misurati, mai.** | 7 file su 8 identici al terzo decimale; l'ottavo (XAUUSD) differisce solo per la **cadenza delle barre del grafico** (`OnTick` guidato dal simbolo del grafico, sorgente r.278-287) |
| `Nightly` AUDUSD · USDJPY · XAUUSD · XAGUSD · D30EUR · U30USD | 🔴 **Trades = 0** su tutti e sei | **tutto**: PF, n, DD | la causa del 23/08 (`PipSize()=_Point`) spiega indici e metalli, **non AUDUSD e USDJPY**. Verificato oggi nel sorgente r.109-111: `digits==5 -> pip = _Point*10`, quindi su AUDUSD il QB vale ~8 pip contro la soglia 45 e **dovrebbe passare**. 🔴 **Causa `[NON MISURATO]`** |
| `EMA200` NASUSD H4 | 🔴 **il file non esiste** (`scan_ABTG_EMA200_H4_NASUSD.csv`), mentre i due vicini a H4 girano (SPXUSD 75/86, U30USD 77/85) | la voce **5** su quel simbolo | e' **l'unico buco della matrice dei gemelli** di questo motore |
| `ORB_Fibo` NASUSD | — | voci **3, 4, 5** + il tick | PF IS 0,835 / OOS 0,968, DD 3,02/3,10%, n 91/75, **1 sola passata utile**, modello OHLC |

**C.4 — casi speciali: 16 voci.**
`M0PB` (12 celle, sonda a **zero ordini**: mancano PF, n, DD e l'uscita — gia' declassato il
09/09) · `Sequenza di inversione monotona` (⏸️ **CONGELATO, non morto**: 2 anni su 4 contro il
cancello "3 su 4", e l'EA non esiste) · `OutOfNoise` (🔧 **non bocciato, ROTTO**: `CopyRates`
conta barre di calendario, `nDays` 4-5 contro `InpConeMinDays=14`, **n=0**) · `PostNews`
EURUSD/EURJPY del 07/08 (verdetto **RITIRATO**: 4 CSV con `Trades 0`) · `A1 DAX_Apertura`
config "entrambe + ST ON" (PF 1,03: **config superata da A2 KEEPER**, non un motore morto) ·
`A4 Nasdaq_Apertura` (PF 0,91, 0% positive: manca `n`) · `DUKA U30USD_DK` (cancello chiuso,
in frigo: **non e' un motore**) · piu' le nove righe di round (`R42` 0/24+0/24 · `R45` 0/48 ·
`R63` · `R82` 0 vincitori su 7 cross · `R89` 14 trade IS · `R98` · `R109` DD 44-68% · `M14`
6 finestre su 6 rosse · `E1` PF 0,95) che sono **verdetti su geometrie**, non su sedie.

---

## 3. 🧮 I DIECI NUMERI CHE HO MESSO IO OGGI, dove il registro non aveva niente
_Tutti da CSV gia' in casa. Costo: **zero passate di tester**._

| candidato | il registro diceva | 🔎 il numero VERO | file |
|---|---|---|---|
| `MaxMinNotte` 100GBP | "max 0.67" | **0/54 positive · bestPF 0,6717 · DD 16,0281% · 82 deal** | `risultati_archivio/MaxMinNotte/efe054b5-valid_MaxMin_100GBP.csv` |
| `MaxMinNotte` E50EUR | "max 0.59" | **0/54 · bestPF 0,8398 · DD 13,9046% · 80 deal** ✏️ (0,59 non e' il PF migliore) | `.../8eefb007-valid_MaxMin_E50EUR.csv` |
| `MaxMinNotte` F40EUR | "max ~1.0" | **0/54 · bestPF 0,9985 · DD 10,1232% · 112 deal** | `.../4528c79b-valid_MaxMin_F40EUR.csv` |
| `SupRev` 100GBP H1 | "tutte neg" | **0/27 · bestPF 0,8822 · DD 4,5548% · 160 deal** | `.../SupRev_nuovi_indici/c016704b-valid_SupRevScr_100GBP_H1.csv` |
| `SupRev` 100GBP H4 | "PF 1.29 DD 2% 48tr" | **5/27 · bestPF 1,2891 · DD 2,0407% · 48 deal** ✅ riprodotto | `.../2ab6d7d9-...` |
| `SupRev` 225JPY H1/H4 | "PF ~2, DD 0.2%, 24-75tr" | **13/27 · 2,1574 · 0,2152% · 75** e **22/27 · 2,1626 · 0,1169% · 27** ✅ riprodotto | `.../9d856486-...`, `.../cfe6ccec-...` |
| `EMA200` E50EUR H1 | "0/88, best 0,7403" | + **DD 7,1197% · 210 deal** (max 467) | `.../EMA200/H1_OHLC/scan_..._E50EUR.csv` |
| `EMA200` E50EUR H4 | "0/81, best 0,9535" | + **DD 4,6388% · 81 deal** (max 150) | `.../EMA200/H4_OHLC/scan_..._E50EUR.csv` |
| `EMA200` NASUSD H1 | "1/85, best 1,0197" | + **DD 5,7355% · 255 deal** (max 594) | `.../EMA200/H1_OHLC/scan_..._NASUSD.csv` |
| `Live5m_v2` D30EUR | "best PF 1.04 DD ~10%" | **8/32 · bestPF 1,0430 · DD 9,0970% · 239 deal** ✅ riprodotto | `.../Live5m/valid_DAX_Live5m_v2_D30EUR_realtick.csv` |

🟢 **Quattro di questi RIPRODUCONO al centesimo numeri scritti da un'altra sessione** — ed e'
il controllo che chiedeva la regola del 10/09: **verificare contro i numeri veri di qualcun
altro, non contro valori che tornano.** Sei erano buchi, e ora non lo sono piu'.

---

## 4. 🎣 LE DUE CLASSI DI RIESAME CHE HANNO PRIORITA' — e una delle due e' MOLTO PIU' PICCOLA di come sembra

### 4.a — Bocciati per SOLA FREQUENZA (firma del 07/09)
**Il brief parte da "47 righe che citano la frequenza". Le ho aperte tutte, una per una.
Il numero vero e' 1.**

| quante | quali |
|---:|---|
| **1** | 🎯 `EMA200` **U30USD H4** — l'unico scarto in `REGISTRO_TEST.md` etichettato *"scartato per FREQUENZA, NON per edge"* (r.2292) |
| 1 | `M0PB` — cancello **F1 applicato PER LATO**, e l'unita' e' decaduta con la firma. **Gia' declassato il 09/09**: non e' nuovo |
| 1 | `IBRetest` — la frequenza (**0,78 op/gg di famiglia** contro 1,00) e' il **secondo** motivo, indipendente. Il primo (**C0**, PF famiglia 0,78 su n=209 OOS a campione pieno) **regge da solo** |
| **44** | 🔵 **NON sono esclusioni**: sono titoli di dossier di caccia, descrizioni di cancelli, conteggi di segnali, frasi di metodo. Il brief le contava come candidate |

🔴 **E SU QUELL'UNICO CASO, L'ETICHETTA E' SBAGLIATA — ed e' la scoperta piu' utile del §4.**
Il registro scrive: *"Trades 15-82 = ~8-41 POSIZIONI => molto sotto il pavimento dei 150.
Scartato per frequenza"*. 🛑 **Quello non e' il pavimento di frequenza: e' la regola del
CAMPIONE** (Emendamento A). E `report/RIPESCAGGIO_FREQUENZA_2026-09-08.md` §0 regola 4 lo
dice a chiare lettere: *"un candidato bocciato perche' il campione IS non arriva a 150
operazioni NON e' un caso di questo referto"*.
👉 **La differenza cambia cosa si deve fare, e per questo conta:**
- il pavimento di **FREQUENZA** si chiude **aggiungendo SIMBOLI** (firma 07/09);
- la regola del **CAMPIONE** si chiude **SOLO aggiungendo STORICO**.
✅ **Numeri miei, sul CSV**: `EMA200 U30USD H4` fa **77 celle positive su 85**, bestPF
**3,02473**, DD **2,4575%**, **32 deal** sulla cella migliore (**82** il massimo del file) =
**16-41 posizioni** al fattore misurato 2,0117. **L'edge c'e'. Il campione no, e nessun
simbolo in piu' lo aggiusta.** Sul Dow lo storico e' **21 mesi**: quella porta e' chiusa
fino a novembre, e va scritto cosi'.

### 4.b — Bocciati su una FINESTRA sbagliata (Emendamento del 16/08)
Qui il conto e' l'opposto: **e' la classe piu' grossa e nessuno l'aveva contata.**

| quante | classe | conseguenza |
|---:|---|---|
| **7** | 🔥 `EMA200` a **H4** su AUDJPY, GBPUSD, GBPJPY, 200AUD, SPXUSD, USDNOK, XAUUSD: **135 celle a TICK REALI su UNA finestra sola, senza nessuno split IS/OOS** | §5. **E' il candidato n.1 di tutto il dossier** |
| 8 | `FiboH4_Multi`: finestra 2024.01.01+, **~2,5 anni**, quando il forex ha **27,5 anni di M1 OHLC misurati** (pavimento 1999.01.04) | §6 riga 3 |
| 4 | `Nightly` sui forex misurati: stessa finestra corta, storico profondo disponibile | ma sono **chiusi per RISCHIO** (§2.A): la finestra non li riapre |
| 2 | `RELATIVO` NASUSD (n 87/154) e `NYRetest` (n 114-115): finestra **fisicamente insufficiente** — indici BCM 21 mesi | `RELATIVO` si chiude **da solo** verso il **27/11/2026** |
| 1 | `CRT TurtleSoup`: misurato **solo nel toro**, ed e' un motore **da CHOP** (2023 +5.259 su n=83) | porta aperta **solo** con tick Dukascopy (strumenti pronti dal 31/08, mai lanciati) |

---

## 5. 🔥 IL NUMERO CHE NON C'ERA — `EMA200` a H4 non ha MAI VISTO UN FUORI CAMPIONE

**Questo e' il pezzo che vale la giornata, ed e' un fatto di archivio, non un'idea.**

Il **01/08/2026** `ABTG_EMA200` a H4 e' stato validato **a tick reali** su 8 simboli
(`risultati_archivio/EMA200/realtick_H4/`, banco `ini/ABTG_EMA200.ini`: **Model=4**,
2024.01.01 -> 2026.06.30, deposito 10000). Il verdetto d'epoca
(`EMA200/ANALISI_EMA200.md` r.40-57) dice: *"6 REGGONO"*, *"il motore PIU' ROBUSTO finora"*,
*"NESSUN simbolo crolla sotto 1"*. Cinque sedie H4 (**771511-771515**) sono state attaccate
**quel giorno**.

🔴 **E poi si sono fermate le misure. Quelle 135 celle per simbolo vengono da UNA FINESTRA
SOLA, ottimizzata intera. Non esiste NEMMENO UNA lettura fuori campione di questo motore a
H4, su nessuno degli otto simboli.** L'ho cercata: nel repo non c'e'.

### 📊 E quello che c'e' non e' poco — l'ho contato oggi, cella per cella

| simbolo | celle L+S | positive | PF min-max | DD min-max | deal (~posizioni) |
|---|---:|---:|---|---|---|
| **AUDJPY** | 28 | 🟢 **28 / 28** | 1,076 - 1,845 | 2,889 - 9,464% | 255-347 (~128-174) |
| **GBPUSD** | 24 | 🟢 **24 / 24** | 1,147 - 1,348 | 5,783 - 9,223% | 274-380 (~137-190) |

E sul solo lato LONG di AUDJPY: **24 celle su 24 positive**, PF **1,231-2,309**, DD
2,168-5,232%. **Non e' un picco con i vicini spenti: e' un altopiano.**

### 🔬 IL CONTRO-ESEMPIO, costruito PRIMA di consegnare — e una parte l'ha vinto lui

**L'ipotesi alternativa da battere:** *"non e' il motore, e' la DERIVA del carry AUD/JPY. Un
trend-follower long-only su una coppia che sale produce un altopiano per deriva."*
**Quale numero produce l'ALTRA spiegazione?** Se e' deriva, il lato opposto deve essere
**sistematicamente ROSSO**. Misurato sugli stessi 135 pass:

| configurazione | celle | positive | PF mediano |
|---|---:|---:|---:|
| LONG only | 24 | 24 | **1,852** |
| **SHORT only** | 32 | **16** | 🟡 **0,991** |
| L+S | 28 | 28 | **1,516** |

🟡 **Verdetto del contro-esempio: NON lo uccide, ma NON lo assolve.** Il lato short e'
**centrato sullo zero** (0,991, 16 positive su 32), non negativo: se fosse pura deriva
rialzista sarebbe rosso come `SuperWave DOW short` (**PF OOS 0,429**) o `SupRev DAX short`
(**<= 0,92**). **Non lo e'.** Ma un lato a 1,85 e l'altro a 0,99 su **un solo regime di 24-30
mesi** e' anche, esattamente, la firma del criterio **I7** (*"una cella simmetrica-opposta e'
DERIVA, non edge"*).
🎯 **E allora il discriminante l'ho trovato, e non e' un'opinione: sono le celle L+S.** Una
configurazione a **DUE LATI** non puo' raccogliere una deriva in **una** direzione, perche'
prende anche l'altra. Sono **28/28 positive su AUDJPY** e **24/24 su GBPUSD**.
🎯 **Secondo discriminante, indipendente e piu' forte: su AUDJPY il lato forte e' il LONG, su
GBPUSD e' lo SHORT** (cella migliore PF 2,066, L0S1). **Stesso motore, lato opposto.** Se
fosse deriva di mercato, il lato forte sarebbe lo stesso.
📌 **Falsificatore pre-dichiarato, scritto nel file prova prima dei numeri:** se sulla
finestra lunga le celle **L+S** scendono sotto PF 1,10 **mentre** le long-only restano sopra,
**l'altopiano era il carry e il candidato muore.** E' per questo che i file prova R139a/b
girano su **L+S** e non sul long: **si misura la cella che falsifica, non quella che conferma.**

### 🔴 E PERCHE' NESSUNO L'HA PROMOSSO: CLASSE 226, NEL VERSO CHE FA MALE
`Trades` conta **DEAL DI USCITA**, non POSIZIONI. Fattore **misurato** su questo motore:
**2,0117** (517 deal = 257 posizioni, `R112_CORSA_20260826/pertrade_00_metro_763400.csv`,
piu' un secondo conteggio indipendente su magic diverso in
`risultati_prove/trades_candidati_r23/` che da' lo stesso 517=257).
👉 **L'altopiano "a 255-347 trade" e' in realta' 128-174 POSIZIONI.** Il verso e' quello
**sfavorevole**: **ne abbiamo MENO di quante sembrava**. La cella centrale di AUDJPY fa **~141
posizioni** su UNA finestra -> **sotto il pavimento dei 150 anche senza split**, e tre volte
sotto se si pretendono 150 **per finestra**.
🎯 **Ed e' questo, non il PF, il motivo per cui cinque sedie sono in campo senza un verdetto.
Il numero non era mai stato scritto. Adesso c'e'.**

### 🚨 E UN FATTO DI CAMPO CHE VA DAVANTI A CLAUDIO SUBITO, PERCHE' SI CHIUDE IN DUE MINUTI
Le cinque sedie H4 **771511-771515** sono attaccate dal **01/08** e hanno fatto
**ZERO posizioni** nello statement 30/03 -> 11/09 (`data/statements/trades_auto.csv`,
concorde con `CENSIMENTO_FREQUENZA_FLOTTA_2026-08-22.md` r.176-180 e con il censimento `.chr`
del 12/09, che non le trova).
**Il conto, con il metro delle attese:** la cella del preset AUDJPY
(`mql5/Presets/ABTG_EMA200_FW_AUDJPY_H4.set`, O1=0,10 / O2=0,35) vale **~33-43 posizioni
l'anno** = **2,8-3,6 al mese**. In 1,35 mesi l'attesa e' **3,8-4,9 posizioni**; su **cinque**
sedie l'attesa aggregata e' **~20**. Osservato: **0**.
🔴 **Con λ ≈ 20, la probabilita' di vedere zero e' ~2 x 10⁻⁹. Non e' sfortuna, ed e' l'unica
frase di questo dossier che non ha bisogno di un altro backtest.** Le tre spiegazioni
possibili, e sono tutte verificabili a mano: **(1)** le sedie non sono attaccate; **(2)** sono
attaccate su un TF o un simbolo sbagliato; **(3)** qualcosa nel preset le blocca.
🙋 **Domanda per Claudio, ed e' di quelle che lui puo' chiudere e io no** — bersaglio:
🪟 **terminale MT5 `50503392` (`BCM Markets MT5 Terminal`)**, i grafici **AUDJPY H4, GBPJPY
H4, GBPUSD H4, 200AUD H4, SPXUSD H4**: **quei cinque EA sono ancora attaccati?**
⚠️ E un rilievo tecnico che trovo scrivendo: **il preset AUDJPY gira una cella che NON E'
MAI STATA MISURATA.** `InpOrder2Atr=0,35` **non esiste** fra i valori dell'asse d'archivio
(che sono 0,2 / 0,3 / 0,4 / 0,5 / 0,6). L'intestazione del `.set` dice *"parametri robusti
(zona stabile, non il best-pass)"* — intenzione giusta, **ma 0,35 e' un'interpolazione, non
una cella con un numero**.

---

## 6. 🏁 LA GRADUATORIA DEI RESUSCITABILI — ordinata per PASSATE MANCANTI
_Metro di casa: **T(min) = 0,6 + 0,077 x passate** per round._
_🔴 Nessuna di queste righe e' stata messa in coda: `CODA.txt` la gestisce la sessione madre._

| # | candidato | simbolo | TF | **LATO** | il numero che manca | dove si prende | passate | **T (min)** |
|---:|---|---|---|---|---|---|---:|---:|
| 🥇 **1** | `EMA200` | **AUDJPY** | H4 | **L+S** (discriminante) | **PF OOS con n >= 150 in ENTRAMBE le finestre** | OHLC M1 **2010-2026** (16,5 anni; forex 27,5 anni misurati dal 1999.01.04) | **8** | **1,22** |
| 🥈 **2** | `EMA200` | **GBPUSD** | H4 | **L+S** | idem | idem — e **e' il major piu' economico**: ~0,67 pip all-in contro 0,86 di EURUSD | **8** | **1,22** |
| 🥉 **3** | `FiboH4_Multi` | **GBPUSD** | H4 | L+S | **il PRIMO PF su UN SIMBOLO SOLO** (mai fatto: 96 righe su 96 sul basket) | OHLC M1 **1999-2026** (pavimento MISURATO su GBPUSD: 1999.01.14) | **6** | **1,06** |
| 4 | `EMA200` | GBPJPY | H4 | L+S | PF OOS con n >= 150 | clone di #1 (tick PFmed 1,456, 146-287 deal) | 8 | 1,22 |
| 5 | `EMA200` | **NASUSD** | **H4** | L+S | **esiste l'edge a H4?** Il file non esiste, ed e' l'unico buco della matrice | scan OHLC H4, cella stretta | 8 | 1,22 |
| 6 | `SupRev_DOW_H1_Ott` | U30USD | H1 | L+S | `InpTrailOnST` e `InpExitOnFlip` — **zero occorrenze come asse in tutto il repo** | 🟢 **I FILE PROVA ESISTONO GIA'** dal 09/09 (`prove/A1_SUPREV_DOW_H1_01_trailonst.txt` e `02_exitonflip.txt`) e **non sono in coda** | 4 + 4 | 0,91 + 0,91 |
| 7 | `Nightly` | AUDUSD, USDJPY | (grafico) | L+S | **perche' `Trades = 0`?** La causa del 23/08 non li spiega | 1 cella con `InpMaxNightVolPips=0` (QB spento) | 4 | 0,91 |
| 8 | `EMA200` | 200AUD, SPXUSD | H4 | L+S | PF OOS; **e per SPXUSD anche il campione** (68-122 deal = 34-61 pos) | cloni di #1 | 16 | 1,83 |
| 9 | `SupRev_CAC_H4_Ott` | F40EUR | H4 | L+S | l'uscita, su una promozione **revocata a PF 0,96** | 4 celle `TrailOnST x ExitOnFlip` | 8 | 1,22 |
| 10 | `MaxMinNotte` | 100GBP, E50EUR, F40EUR | (notte) | SHORT+L | l'uscita — **mai ad asse su questo motore** | 3 celle x 3 indici | 36 | 3,37 |
| 11 | `ORB_Fibo` | NASUSD | M5/M15 | L+S | tick **+** gemello **+** TF **+** uscita = 4 round | quattro file prova da scrivere | ~40 | 3,68 |
| — | `EMA200` E50EUR, `SupRev` 100GBP/225JPY, `SupRev` DOW/CAC H4, ORO 15:36, `EMA200` U30USD M5-M30 | | | | **niente: sono CHIUSI col certificato** (§2.B) | — | **0** | **0** |

**Costo dei primi tre: 22 passate.** Come tre round separati: **1,22 + 1,22 + 1,06 = 3,50
min**. Come round unico: **0,6 + 0,077 x 22 = 2,29 min**. 😄 **Il collo di bottiglia di questo
progetto non e' mai stato la macchina.**

### 📉 TF: la frontiera del costo, con i numeri accanto — nessun "e' basso quindi no"
- 🔴 **ESCLUSI PER COSTO, col numero**: `EMA200 U30USD` **M5 11,5-13,1x** (sfonda il pavimento
  DURO 13,3x) · **M15 20,0-22,6x** · **M20 23,1-26,1x** · **M30 28,3-32,0x**, contro la
  frontiera di lavoro **40x**. Spread **MISURATO su 64.711.285 tick**, commissione indici
  **0,0000 MISURATA** su n=302 deal. Idem per `Live5m`, `SupRev M5`, `DAX_M3` su indici.
- 🔴 **ORO**: la finestra M1 delle 15:36 e' **8,8-12,5x**, **sotto anche il duro**. Il TF piu'
  basso che la frontiera lascia passare e' **M30 con stop >= ~8,8 $** (margine +9,7%,
  sottile); **H1 e' il gradino robusto** (+55%).
- 🟡 **FOREX M5/M15 sfondano il DURO col costo all-in**: EURUSD M5 **9,30x**, M15 **12,56x**
  (pavimento duro 13,3x). Per il 40x su EURUSD serve uno stop **>= 34,4 pip**. Il major piu'
  economico e' **GBPUSD** (~0,67 pip all-in): duro a >= 8,9 pip, lavoro a >= 26,8.
- 🟢 **Ed e' esattamente per questo che i tre file prova di oggi stanno a H4 e non piu' in
  basso**: a H4 lo stop e' `1,0 x ATR(14) H4`, cioe' molte decine di pip, e la frontiera non
  e' il collo di bottiglia. **Scendere di TF qui non comprerebbe frequenza: comprerebbe
  pedaggio.**
- ⚪ **AUDJPY: lo spread BCM e' `[NON MISURATO]`** (la sonda del 17/08 legge **0 = nessun
  tick** su AUDUSD/EURAUD/GBPJPY/CHFJPY). Dichiarato nel file prova. 🟢 **Contro-argomento
  onesto: il costo vero e' GIA' DENTRO i numeri a tick** (PF 1,623 con DD 2,901 su 283 deal,
  spread reale BCM incluso) — su OHLC invece i PF sono **ottimisti di una quantita' non
  misurata**.

### 🔑 E IL RIFRAMING CHE RIORDINA TUTTA LA GRADUATORIA
150 posizioni per lato in 18 giorni di mercato vorrebbero **11,5 op/giorno/lato**:
impossibile. 👉 **I 150 possono venire SOLO DAL BACKTEST.** Quindi cio' che rende schierabile
una sedia e' la **PROFONDITA' DI STORICO**, non la velocita' del motore — e la graduatoria
qui sopra e' ordinata **proprio** su questo: le prime quattro righe sono **FOREX** (27,5 anni
di M1 OHLC misurati), non indici (21 mesi).

### 📊 E la frequenza di FAMIGLIA, col conto esplicito (firma del 07/09)
`EMA200` a H4, sui sei simboli che **reggono a tick** (PFmed >= 1,30: 200AUD 1,59 · AUDJPY
1,50 · GBPJPY 1,46 · SPXUSD 1,44 · GBPUSD 1,38 · XAUUSD 1,33):
**~0,25 op/giorno per simbolo x 6 simboli = ~1,50 op/giorno di FAMIGLIA.**
🟢 **Sopra il pavimento firmato di 1,00** — e **sotto di quattro volte** se lo si applicasse
alla singola sedia. **E' il caso di scuola della firma del 07/09**, e va detto che e' la
firma a renderlo schierabile, non una misura nuova.
⚠️ Banda dichiarata: le posizioni/anno per simbolo escono da `~141 posizioni su 24-30 mesi`
(**quale delle due sia la finestra effettiva e' `[NON MISURATO]`**: l'`.ini` dichiara
2024.01.01 ma il pavimento tick forex MISURATO e' 2024.07.05).

---

## 7. 🛑 IL LIMITE — cosa NON ho proposto, e perche'

- ❌ **Non ho proposto una griglia su nessuno degli 11 candidati chiusi PER RISCHIO** (§2.A).
  Un DD del 37% non si ritocca.
- ❌ **Non ho proposto un'altra griglia d'ingresso su `IBRetest`** (PF famiglia 0,7798 su
  n=209 a campione pieno), ne' su `PostNews` A/B (PF 0,66-0,90 su quattro letture con n
  151-312), ne' su `R95` (0/30). Su un motore a PF < 1,10 con campione pieno una griglia piu'
  fitta trova **solo picchi di rumore**, e la cella verde per caso e' quella che brucia la
  challenge.
- ❌ **Non ho proposto di "ritestare solo il DAX" di `IBRetest`** (PF 1,21 con DD 2,80% su
  **58 operazioni**): e' la scelta a posteriori vietata dal 19/08, e l'OOS dello stesso
  simbolo fa **0,96493** senza che nulla fosse stato ottimizzato.
- ✅ **Ho allargato solo dove la regola lo consente**: **SIMBOLI** (FiboH4 su GBPUSD,
  `EMA200` NASUSD H4), **FINESTRA/STORICO** (i tre file prova), **GESTIONE DELL'USCITA**
  (righe 6, 9, 10 della graduatoria).
- 📐 **E ogni allargamento e' pagato con una prova fuori campione**: tutti e tre i file prova
  girano **IS + OOS**, e nessuno dei tre promuove niente (sono **Modello 1 = OHLC M1 =
  SCREENING**; un numero OHLC non e' mai un verdetto).
- 🚫 **Regola di selezione, dichiarata insieme ai numeri**: le celle dei file prova sono il
  **CENTRO DELL'ALTOPIANO**, non il picco. Su AUDJPY il picco e' `O1=0,30 / O2=0,4`
  (PF 1,845) e **non e' la cella scelta**; su GBPUSD il picco e' una cella SHORT-only
  (PF 2,066) e **non e' la cella scelta**.
- 🔁 **Confronto col DEFAULT, obbligatorio e congelato** (soglia S6 di R139b): il default del
  sorgente e' `InpTP_RR = 2,0`. Se la cella migliore lo batte di **meno di 0,05 di PF**, la
  risposta onesta e' **"il default va bene"** — ed e' un risultato, non un fallimento.

---

## 8. 📦 I FILE PROVA PRONTI — cancello deterministico PASSATO

`python3 backtest_pipeline/controlla_prova.py` lanciato **senza pipe** (classe 254: un
`| grep` butta via il codice d'uscita e produce un falso PASS). **Esito: `OK`, exit code 0.**

| file | EA | pin | celle | passate | ASCII |
|---|---|---:|---:|---:|:-:|
| `backtest_pipeline/prove/R139a_EMA200_AUDJPY_H4_LS.txt` | `ABTG_EMA200` | 43 | 4 | 8 | ✅ 0 byte non-ASCII |
| `backtest_pipeline/prove/R139b_EMA200_GBPUSD_H4_LS.txt` | `ABTG_EMA200` | 43 | 4 | 8 | ✅ 0 byte non-ASCII |
| `backtest_pipeline/prove/R139c_FIBOH4_GBPUSD_unsimbolo.txt` | `ABTG_FiboH4_Multi` | 46 | 3 | 6 | ✅ 0 byte non-ASCII |

**Totale: 11 celle, 22 passate.** ASCII verificato con `python3` byte per byte (zero emoji,
zero punti mediani). Numeri di round **R139a/b/c** verificati liberi nel repo (R137a-c e
R138a sono di un'altra sessione e **non sono stati toccati**). Magic **771560 / 771561 /
772060**, cercati repo-wide: **0 occorrenze** ciascuno.

### 🚨 Classe 273, e la scrivo perche' e' stata pagata DUE VOLTE IN DODICI ORE
Tutti e tre i file girano su **`-Modello 1` = OHLC M1** (NON tick reali), e il motivo e'
**misurato**, non di comodo: il pavimento **tick** del forex BCM e' **2024.07.05**, quindi su
una finestra di 16,5-27,5 anni **i tick non esistono**. `-Modello 4` = tick reali, e su questi
tre round sarebbe **sbagliato per costruzione**.
👉 Argomenti corretti, se la sessione madre decidesse di metterli in coda:
`-Modello 1 -Deposito 10000`. ⚠️ **Nessuno dei tre e' in `CODA.txt`: non l'ho toccata.**

---

## 9. 🕳️ I BUCHI DICHIARATI DI QUESTO DOSSIER

1. 🔴 **La classificazione "chiuso PER RISCHIO senza il certificato a cinque voci" e' una MIA
   interpretazione** di come si incastrano il certificato (09/09) e l'Emendamento B (16/08).
   **Non e' scritta da nessuna parte.** Se Claudio la rifiuta, **le 15 righe del §2.A tornano in coda**.
2. ⚪ **`AltaVelocita`, `DAX_M3`, `Londra_ORB`, `R95`**: i loro numeri (o parte) **non sono
   nel registro e non li ho trovati in archivio** (nessun CSV per DAX_M3 e Londra_ORB). Sono
   **`[NON MISURATO]`**, non "morti".
3. ⚪ **Finestra effettiva della validazione tick H4**: l'`.ini` dichiara 2024.01.01, il
   pavimento tick forex MISURATO e' 2024.07.05. **Quale sia l'effettiva e' `[NON MISURATO]`**,
   e tutte le frequenze del §5-§6 portano la banda **24-30 mesi**, non un punto.
4. ⚪ **Pavimento storico di AUDJPY: `[INFERITO]`.** R102 ha misurato il 1999.01.04 su **sei**
   simboli e **AUDJPY non e' fra quelli**. Il 2010.01.01 sta 11 anni dentro, ma se il referto
   stampa una prima operazione molto dopo, il numero va riletto.
5. ⚪ **Fattore deal/posizione di `FiboH4_Multi`: `[INFERITO]` a ~2** — quell'EA non ha
   nessun file per-trade in archivio. La banda vera e' 1,0-2,3 e tutti i conti sul campione
   di R139c ereditano quell'incertezza, **nei due versi**.
6. ⚪ **Spread BCM su AUDJPY e oro nella finestra di lavoro: `[NON MISURATO]`.** La mossa che
   lo chiude costa **ZERO passate di tester**: *RealCost Spread P95 Logger MT5*
   (Code Base **74148**), promosso in casa il 23/08 e **mai usato — lo segnalano OTTO cacce
   di fila, questa compresa.**
7. ⚪ **Nessuna PROVA DI REGIME separata** nei tre round: 16,5-27,5 anni **contigui**
   diluiscono (Emendamento C). La lettura **per anno** va fatta sul referto; se il driver non
   la stampa, e' un round in piu'.
8. 🔴 **Non ho potuto invocare il secondo strato del cancello** (agente
   `controllo-preventivo`). **Lo dichiaro**: i tre file prova hanno un PASS **deterministico**,
   non un PASS **di giudizio**.

---

## 10. 😄 E LA COSA CHE E' ANDATA BENE, perche' un elenco di difetti senza le vittorie descrive male la realta'

- 🟢 **Il registro e' migliore della sua reputazione**: **52 voci su 72 hanno un PF**, e i
  senza-PF sono **20**, non 77. Il
  progetto non ha archiviato al buio — ha archiviato **scrivendo il numero in un CSV e non
  nella riga accanto**. E' un problema di **indice**, non di rigore.
- 🟢 **Dieci buchi chiusi oggi a costo zero**, e quattro di quei dieci **riproducono al
  centesimo numeri scritti da un'altra sessione**: il metodo di casa regge alla verifica
  incrociata.
- 🟢 **E il pezzo grosso: `EMA200` a H4 non e' un motore bocciato. E' un motore MAI PORTATO A
  TERMINE** — 135 celle a tick su 8 simboli, altopiani da 24/24 e 28/28 celle positive, e
  **zero fuori campione**. La misura che manca costa **8 passate e 1,22 minuti**.
- 🎯 **A 19 giorni dalla challenge, il candidato numero uno non e' un motore nuovo: e' un
  motore nostro a cui manca UN numero, e il numero costa un minuto e ventidue.**

---

_Firma del metodo: nessun backtest eseguito · `CODA.txt` non toccata · `walkforward_generico.ps1`,
`RIGA_SOTTILE_ROUND.ps1`, EA, preset e forward non toccati · nessun saldo del reale 10105439 o
del 100k in questo file (repository pubblico) · i file di `R137a/b/c` e `R138a` di un'altra
sessione non toccati._
