# 🏹 SWEEP DEI MECCANISMI — 23/08/2026

**Mandato:** l'imbuto e' VUOTO. Quattro round chiusi in 24 ore, quattro
bocciature nette (R95 0/30, R96 0/4, R97 0/4, R98 0/6). Serve materiale
nuovo per Dow, DAX scorrelato, ORO, e mercati mai esplorati.

**Perimetro congelato applicato:** vietato Nasdaq, vietato JPY, vietati i
parametri diversi di motori gia' morti. Ogni candidato e' passato prima dalla
lista dei caduti (`backtest_pipeline/REGISTRO_TEST.md`, referti R42/R43/R45/
R63/R88/R95-R98, `SETACCIO_MANUALE.md`, le cacce del 16/08, 19/08, 21/08 e i
due sweep del 22/08).

---

## ⚡ IL RISULTATO IN UNA RIGA

> **Su 1.591 titoli del Code Base ricrawlati e ritagliati con filtri nuovi, 11
> sorgenti scaricati e letti, 3 paper scaricati in PDF e letti nelle sezioni
> che contano, 6 fonti sottoposte a controllo positivo — arrivano al sorgente
> o al testo 14 candidati, ne propongo 5, e il primo non e' un EA di fuori:
> e' un buco che abbiamo in casa.**
>
> 🔴 **La scoperta che riordina tutta la caccia e' un vincolo di DATI, non di
> idee:** a BCM **gli indici e l'energia partono dal 2024.09.26 e il broker non
> ha altro** (`REFERTO_SONDA_STORICO_17-08.md`, stato `COMPLETO`). Sono ~22
> mesi = ~450 sedute. **Qualunque meccanismo che spari meno di una volta a
> settimana su un indice e' STRUTTURALMENTE NON MISURABILE da noi**: turn of
> the month = 22 osservazioni, EIA del mercoledi' = ~95, FOMC = ~14. Non e'
> che siano cattive idee: e' che il campione non esiste, e la regola A
> (>=150 operazioni) le boccia prima di partire.
>
> 🟢 **E lo stesso documento dice dove il campione ESISTE, ed e' clamoroso:
> XAUUSD parte dal 2004.06.11 — 22,1 anni.** Ho controllato tutti i file prova
> sull'oro del repo: **tutti girano su `@DAQUANDO 2024.09.26` o su un
> segnaposto dichiarato prudente.** Vent'anni di oro sono li' e non li abbiamo
> mai usati, nemmeno una volta. **Il candidato numero uno e' quello, costa zero
> righe di codice, e la letteratura esterna che ho letto oggi punta esattamente
> li'.**

---

## 1. 📡 CONTROLLO POSITIVO — fonte per fonte, misurato oggi

| fonte | HTTP | bersaglio noto verificato | esito |
|---|---|---|---|
| **MQL5 Code Base** `/en/code/mt5/experts` | **200** | 40 pagine crawlate → **1.591 id+titolo unici** (il 22/08 ne contava 1.595: stesso catalogo). Le schede rendono autore, data, `UserDownloads:`. `/en/code/download/<id>` rende lo ZIP col `.mq5` | 🟢 **PASSA** |
| **arXiv API** (`export.arxiv.org`, https) | **200** | 8 query, entry con titolo/data/id veri; PDF scaricati e convertiti (3 file, 8-22 pagine) | 🟢 **PASSA** ⚠️ **l'endpoint `http://` risponde 301 e restituisce 0 entry: va usato `https://`** |
| **Quantpedia** | **200 con `-L` + UA** | pagina `strategies/turn-of-the-month-in-equity-indexes` → 222 KB, testo pieno con "Fundamental reason" e "Simple trading strategy". Articoli `/an-extensive-test-.../` leggibili | 🟢 **PASSA — ed e' RISORTA**: il 22/08 era 466 su 5 slug su 6 |
| Quantpedia `sitemap.xml` | **466** | — | 🔴 non enumerabile: si arriva agli slug solo via ricerca web |
| **Ricerca web** | 200 | usata SOLO per trovare URL, mai come fonte di fatti | 🟢 passa come indice |
| **TradingView** `/scripts/` | 200 | **0 link `/script/` nell'HTML**, 0 `//@version`, 0 `strategy(` | 🔴 **NON SETACCIABILE** — quarta caccia di fila |
| **GitHub ricerca** (`github.com/search`, `api.github.com/search`) | **403** | — | 🔴 **NULLA** — leggibile solo `raw.githubusercontent.com` con URL gia' noto |
| **SSRN** | **403** | Cloudflare | 🔴 **NULLA** — quarta caccia di fila |
| **Forex Factory** `/forum/71-trading-systems` | **403** | — | 🔴 **NULLA** — quarta caccia di fila |

### Cosa ho sfogliato dove ha funzionato

- **Code Base:** catalogo completo ricrawlato (1.591 titoli), tolti i **538
  involucri `Exp_*`** restano **1.053 titoli veri**, ritagliati con **filtri
  NUOVI rispetto al 22/08**: `dow|us30` · `dax|de40|ger30` · `gold|xau` ·
  `oil|wti|brent|crude` · `vwap` · `retest|pullback|throwback` ·
  `close|end.of.day|eod|last hour` · `month|friday|monday|week` ·
  `revers|mean.rev|fade` · `correlat|pair|arbitr` · `volatil|squeeze` ·
  `seasonal|calendar|anomal`.
  📌 **Reperti di struttura, da mettere a verbale:** su 1.053 titoli,
  `dax|de40|ger30` rende **ZERO**, `oil|wti|brent|crude` rende **ZERO**,
  `vwap` rende **ZERO**, `retest|pullback` rende **UNO**. **Il Code Base non
  ha niente su DAX, petrolio, VWAP e retest. Non e' "non ho trovato": e' che
  non esiste.**
- **11 sorgenti scaricati ed estratti e letti**: `73884`, `74148`, `76117`,
  `76153`, `75586`, `56773`, `73958`, `23108`, `75301`, `57020`, `58135`.
- **3 PDF scaricati e convertiti**: arXiv `2605.04004v2` (8 pagine, letto
  §4.1 §4.4 §4.8 §5), arXiv `2010.01727v1` (Knuteson, letto abstract + §I),
  + le pagine Quantpedia `an-extensive-test-of-market-timing-strategies-in-
  the-gold-market` e `turn-of-the-month-in-equity-indexes` lette per intero.

---

## 2. 🧱 IL VINCOLO CHE HA DECISO LA CACCIA — la profondita' dei dati

Misurato, non ipotizzato. Fonte: `backtest_pipeline/risultati_archivio/
REFERTO_SONDA_STORICO_17-08.md` (59 simboli su 59, 0 date recuperate).

| gruppo | simboli | prima data | stato dichiarato dal broker |
|---|---|---|---|
| **indici + energia** | `100GBP` `200AUD` `225JPY` `D30EUR` `E35EUR` `E50EUR` `F40EUR` `NASUSD` `SPXUSD` `U30USD` `UKOIL` `USOIL` | **2024.09.26** | **`COMPLETO`** = non manca sul disco, **il broker NON CE L'HA** |
| **metalli** | **XAUUSD** | **2004.06.11** (**22,1 anni**) | profondo |
| | XAGUSD | 2008.11.07 | profondo (ma 26.036 barre in locale: da scaricare) |
| **forex** | GBPUSD / USDJPY / EURUSD | 1993 / 1971 / 1971 | profondo |

### 🎯 La conseguenza operativa, scritta una volta per tutte

Su un indice a BCM abbiamo **~450 sedute**. Perche' un round sia giudicabile
sul MERITO servono **>=150 operazioni** (Emendamento A). Quindi:

| frequenza del meccanismo | n atteso su indice | verdetto a priori |
|---|---:|---|
| ~1 al giorno | ~450 | 🟢 misurabile |
| ~1 a settimana (es. EIA mercoledi') | ~95 | 🔴 **merito sospeso per costruzione** |
| ~1 al mese (turn of the month) | ~22 | 🔴 **non misurabile** |
| ~8 all'anno (FOMC) | ~14 | 🔴 **non misurabile** |

**Questo ha ucciso, prima ancora di leggerli, tutti gli effetti di calendario
sugli indici** — che erano il bersaglio (d) del mandato. Non li propongo, e
scrivo perche': non perche' siano falsi, ma perche' **noi non possiamo
misurarli**, e un round che parte con n=22 e' un round che produce una cella
verde per caso. Restano riaperibili SOLO se un giorno i dati esterni
(`_EXT`, oggi in frigo per il cancello zero) diventano usabili sugli indici.

---

## 3. ✅ LA SHORTLIST — 5 promossi, ordinati per rapporto VALORE/LAVORO

### 🥇 G1 — **L'ORO SU 22 ANNI: il rischio delle sedie vive non l'abbiamo mai misurato**

```
NOME            (round nostro, non un EA di fuori)
FONTE           REFERTO_SONDA_STORICO_17-08.md sez.2 + tutti i file prova oro del repo
                + Quantpedia "An Extensive Test of Market Timing Strategies in the
                  Gold Market" -> Bartsch, Baur, Dichtl, Drobetz,
                  "Investing in the Gold Market: Market Timing or Buy-and-Hold?"
                  https://quantpedia.com/an-extensive-test-of-market-timing-strategies-in-the-gold-market/
LICENZA         n/a (roba nostra)
RIGHE / INPUT   ZERO righe nuove. La cella e' quella viva, congelata.
```

**LA TESI IN UNA RIGA**
_"Il contratto di rischio delle sedie oro e' firmato su 16-21 mesi, mentre il
broker ci da' 22 anni: il DD promesso non ha mai visto ne' l'ottobre 2008 ne'
il 12-15 aprile 2013."_

**IL FATTO, MISURATO IN CASA OGGI** — ho aperto **tutti** i file prova che
toccano XAUUSD (`R2`, `R3`, `R10`, `R17`, `R19`, `R20`, `R21`, `R32a`,
`R39c`, `R45a`, `R86a-d`, `R87a-b`, `ABTG_EMA200`, `ABTG_GoldenCross`,
`ABTG_SupertrendReversal*`, `ABTG_PTE`, `ABTG_WOL`, `CELLE_REGIME`):
**nessuno usa una data anteriore al 2024.09.26.** Quelli che ne parlano
scrivono `@DAQUANDO qui sotto e' un SEGNAPOSTO prudente, non una misura`.
📌 `2024.09.26` **e' il muro dei TICK DEGLI INDICI**, ed e' finito sull'oro
per copia-incolla. La sonda del 17/08 lo dice a chiare lettere:
_"Sull'oro erano vent'anni di storico dati per persi."_ Da allora, **nessun
round ha usato quei vent'anni.**
📌 E c'e' un secondo pezzo: la **prova di regime** (`CELLE_REGIME.txt`) gira
su `XAUUSD_EXT`, che **parte dal 2018.01.01**. Il simbolo nativo del broker
e' **piu' profondo del dato importato di quattordici anni**.

**COSA DICE LA LETTERATURA, E PERCHE' PUNTA QUI** _[DICHIARATO, NON MISURATO
DA NOI]_: Bartsch-Baur-Dichtl-Drobetz testano su oro **1990-2015** oltre
4.000 strategie (4.096 allocazioni stagionali mensili, 18 tecniche, 15
fondamentali) e passano tutto per lo **SPA-test di Hansen** contro il
data-snooping. Sopravvivono **solo le tecniche** — time-series momentum e
incroci di medie — mentre **le stagionali NON sopravvivono**.
👉 Tradotto per noi: **sull'oro la letteratura seria dice che funziona
esattamente la famiglia che gia' abbiamo** (Supertrend, EMA200, GoldenCross)
**e che le stagionalita' non vanno inseguite**. Non ci manca un motore
nuovo: ci manca la misura lunga di quelli che abbiamo. 💰 **Un round di
caccia risparmiato: la pista "stagionalita' dell'oro" si chiude qui.**

**MECCANICA** — nessuna nuova. Si pinna la cella viva
(`ABTG_SupertrendReversal_Ottimizzato`, XAUUSD **H4**, magic 770901,
`InpRiskPercent=1.0`) e si gira su `2004.06.11 → 2026.06.30` + le quattro
finestre di regime. Output: **DD massimo, peggior giornata, DD per regime.**

**PUNTEGGIO**
| voce | pt | perche' |
|---|---:|---|
| semplicita' | 2 | zero input nuovi, una cella |
| il filtro E' il motore | 2 | e' il motore vivo, intatto |
| tesi scrivibile | 2 | una riga |
| riempie un buco | 2 | il buco e' il RISCHIO delle sedie oro, mai misurato |
| testabile senza riscritture | 2 | file prova gia' scritto |
| **TOTALE** | **10/10** | |

**VERDETTO: 🟢 PROVA SUBITO.**
**FILE PROVA GIA' CONSEGNATO:** `backtest_pipeline/prove/R99_ORO_22ANNI_RISCHIO.txt`
— con `@DAQUANDO 2004.06.11` **misurato** e la fonte della misura citata riga
per riga, il PASSO 0 obbligatorio (prima operazione entro il 2005.12.31) e la
trappola del **tetto 100.000 barre** dichiarata in anticipo.

**🏛️ RIGA PROP** — e' l'unica voce della shortlist che parla *direttamente* al
muro: il DD dell'oro nell'aprile 2013 e' un **fatto accaduto**, e l'oro e' il
simbolo su cui abbiamo **12 grafici** in flotta (`FLOTTA_ATTIVA.md`:
_"Concentrazione ORO altissima"_). Se il DD lungo di quelle celle e' il doppio
del promesso, **la concentrazione oro e' un rischio di portafoglio che stiamo
portando senza saperlo**, e la corsia RISCHIO del criterio firmato il 18/08
scatta da sola. ⚠️ Modello **OHLC** dichiarato: i tick partono dal 2024.07.05,
su 22 anni non esistono (tensione gia' nominata in R76). Il numero che esce e'
un **limite inferiore** del rischio, mai un permesso.

---

### 🥈 T1+T2 — **I DUE STRUMENTI CHE SBLOCCANO IL CANCELLO ZERO**

```
NOME   RealCost Spread P95 Logger MT5      | Round Trip Cost Reconciler MT5
FONTE  https://www.mql5.com/en/code/74148  | https://www.mql5.com/en/code/76117
AUTORE a1066832477 · 2026.06.20 · DL 203   | usamah41 · 2026.08.13 · DL 57
RIGHE  19.386 byte, 20 input               | 9.696 byte + core .mqh 3.338 byte
BANDIERE ROSSE  nessuna. Nessuno dei due APRE ORDINI (dichiarato nel
                #property description e verificato nel sorgente).
```

**PERCHE' VALGONO ADESSO E NON FRA UN MESE.** R98 e' stato bocciato dal
**cancello zero S0**, e nel suo stesso referto sta scritto il buco:
> _"lo spread NON e' misurabile da PowerShell e il referto scrive **S0 = DA
> MISURARE A MANO** con tre metodi."_

**T1 fa esattamente quella misura.** Campiona `SymbolInfoInteger(_Symbol,
SYMBOL_SPREAD)` (riga 204) su timer da 1 secondo **e su `OnTick()`**
(righe 97, 130, 139), tiene fino a 20.000 campioni e scrive un CSV con
**media, p50, p90, p95, p99 e massimo**.
🎯 **La finezza che ci interessa e' il p95, non la media**: R55 ci ha gia'
insegnato a leggere lo spread come **percentuale dello stop**, e un motore che
sopravvive alla media ma muore al p95 e' un motore che muore nelle giornate
che contano.

**T2 chiude l'altra meta'.** Legge `HistoryDeal*` e riconcilia, posizione per
posizione, `gross_profit` contro `commission + swap + fee = total_costs`
(righe 79-151), con `DEAL_POSITION_ID` come chiave. E' il **costo di
round-trip vero per operazione**, che e' il denominatore del cancello zero.

**COSA TERREI / COSA RIFAREI**
- 🟢 **tengo**: la macchina dei percentili di T1 e la riconciliazione per
  `position_id` di T2. Sono codice che non dobbiamo scrivere.
- 🔧 **rifarei**: T1 campiona "adesso"; a noi serve **per fascia oraria**
  (14:30-15:00, 20:30-21:00, 08:00-08:15). Serve **un filtro orario e una
  riga di CSV per fascia** — poche decine di righe, e il resto e' regalato.
- ⚠️ **[INCERTO] da verificare sul PC prima di fidarsi**: che nel Tester su
  tick reali `SYMBOL_SPREAD` renda lo spread **modellato dallo storico** e non
  un valore fisso. **Non l'ho potuto provare: qui non esistono MT5 ne'
  Strategy Tester.** Se non lo rende, T1 vale solo in forward — e vale
  comunque, perche' in forward il cancello zero si misura una volta e serve
  per sempre.

**PUNTEGGIO:** non si applica (§7 e' per i motori). **VERDETTO: 🟢 DA
SACCHEGGIARE SUBITO, fuori dall'imbuto.** Non producono sedie: rimuovono un
"DA MISURARE A MANO" da tutti i round futuri.

---

### 🥉 M1 — **DUE MIGLIORIE ATR PER LA SEDIA ORO NOTTURNA** (da `GoldLondonBreakout`)

```
NOME     GoldLondonBreakout
FONTE    https://www.mql5.com/en/code/75586
AUTORE   adeolu01 · 2026.08.01 · UserDownloads: 588
RIGHE    383 · 19 input · rischio in % DELL'EQUITY (riga 334: equity * Inp/100)
BANDIERE ROSSE  nessuna. Niente martingala, niente griglia, SL vero,
                pendenti che scadono, guardia sullo spread.
```

🔴 **Come EA e' un DOPPIONE e lo dico subito**: box asiatico 00:00-07:00
server + rottura in finestra 07:00-11:00 = **e' il nostro `ABTG_MaxMinNotte`
sull'oro**, cioe' la sedia R17 gia' viva (box 22:00-06:59, PF 1,91, DD 5,3%).
Non lo propongo come motore.

🟢 **Ma porta due pezzi di meccanica che a noi mancano, e curano un asterisco
che ci siamo scritti da soli.** R17 ha promosso la cella dichiarando:
_"OOS>IS (volatilita' oro RADDOPPIATA nell'OOS)"_. Ecco cosa fa questo codice
e noi no:

| pezzo | riga | cosa fa | ce l'abbiamo? |
|---|---|---|---|
| **filtro di ampiezza del box in frazioni di ATR giornaliero** | 17-18: `InpMinRangeATRFrac=0.15`, `InpMaxRangeATRFrac=0.70` | **salta la giornata** se il box notturno e' troppo stretto (whipsaw) **o troppo largo** (stop insostenibile) | 🔴 **NO** su MaxMinNotte |
| **buffer e stop in ATR, non in punti** | 26-27: `InpBreakoutBufferATR=0.15`, `InpStopATRMult=1.2` | la geometria si riscala da sola quando la volatilita' raddoppia | 🔴 **NO**: il nostro buffer e' in punti (150-350) |
| guardia spread dura | 30: `InpMaxSpreadPoints=350` _("gold spreads run wide")_ | — | 🟡 abbiamo la regola R55 in % dello stop, non una guardia in punti |

📌 Il filtro d'ampiezza **non e' un filtro appiccicato**: e' la stessa idea
che Emiliano usa sul Nasdaq (candela 17-40 punti, `REGISTRO_TEST.md`), e qui
arriva da una seconda fonte indipendente. Ma ⚠️ **attenzione alla lezione dei
5 fallimenti**: aggiunto a un motore gia' tarato, un filtro fa 0/5. Va provato
come **variante gemella** della cella viva, dichiarando prima che se non
migliora si butta.

**PUNTEGGIO**
semplicita' 2 · filtro=motore **1** (e' una miglioria, non un motore) · tesi 2
· buco 1 (non e' un buco di portafoglio, e' una cura di robustezza) ·
testabile 2 → **8/10. 🟢 PROVA SUBITO** (come variante, mai come sostituzione).

**🏛️ RIGA PROP:** l'ATR-scaling attacca direttamente la **peggior giornata**.
Un box notturno gigante con stop in punti fissi e' il modo in cui una sedia
oro fa −2% in una seduta; con lo stop in ATR il rischio resta 1R comunque.

---

### 4️⃣ D1 — **GAP CONTINUATION SHORT: il segnale piu' forte del paper, bocciato solo dal campione**

```
NOME    "Gap Continuation Short (Kalman v>2.5)" — §4.4 di:
        Mesfin (2026), "Structural Limits of OHLCV-Based Intraday Signals in
        MNQ Futures: A Systematic Falsification Study"
FONTE   https://arxiv.org/abs/2605.04004  (v2, 8 pagine, PDF letto)
```

**I NUMERI DELL'AUTORE** _[DICHIARATI, NON MISURATI DA NOI]_, tabella 5:

| strategia | ingresso | N | netto medio (pt) | T-stat | win rate | verdetto dell'autore |
|---|---|---:|---:|---:|---:|---|
| Gap Fill Fade | 09:30 | 238-245/anno | −1,92 | −0,44 | 48,1% | FAIL |
| Gap Fill Fade | 09:45 | 238-245/anno | −1,31 | −0,32 | 47,2% | FAIL |
| Gap Fill Fade | 10:00 | 238-245/anno | −2,24 | −0,59 | 47,9% | FAIL |
| **Gap Continuation SHORT** | 09:30 (Kalman v>2,5) | **22** | **+14,52** | **+3,23** | **68,2%** | **FAIL — solo per N<30** |

Parole dell'autore, non mie: _"The gap continuation short result with a Kalman
velocity filter is **the most interesting finding in the study**. T = 3.23,
win rate 68%, mean net +14.52 points. **Statistically, it looks real.**"_ E la
figura 1 lo conferma: **su quattordici famiglie e' l'UNICA barra che supera
T=2,0**, e cade solo sulla numerosita'.

**PERCHE' NON E' UN CADUTO TRAVESTITO**
- Il **gap fill** — cioe' il fade — e' quello che il paper boccia (T da −0,44 a
  −0,59), ed e' coerente col nostro R42 (fade 48/48) e R43. **Qui si propone
  l'esatto opposto**: la continuazione.
- Il motore **ce l'abbiamo gia' in casa e gira**: `ABTG_GapContinuation.mq5`
  (adottato dal Code Base 75301, sedia viva magic 774101 su 225JPY) ha gia'
  `InpEnableSellGaps`, `InpMinimumSellGapPercent`, rischi separati BUY/SELL e
  `InpMaxSpreadToStopPercent`. **Per una passata solo-SHORT non serve una riga
  nuova.**
- 🎯 **Riempie il buco piu' vecchio del portafoglio: il LATO.**
  `R52_CENSIMENTO_LATI.md`: dei 5 titolari, **4 girano su un lato solo** e sul
  Dow _"short MAI misurato"_ due volte. Un motore short **costitutivo** (non
  un lato spento dall'ottimizzatore) e' esattamente quello che manca.

🔴 **IL BLOCCO, DICHIARATO IN PRIMA PAGINA E NON IN NOTA.** L'autore misura
**22 segnali in 3 anni** su MNQ, **in calo** (12 nel 2022, 6 nel 2023, 4 nel
2024). Portato sulla nostra finestra di 22 mesi fa **~13 operazioni**.
Con n=13 il **MERITO e' sospeso per costruzione** (Emendamento B). E
allentare il filtro di velocita' per fare numeri **e' esattamente
l'overfitting dell'autore**, che il §4 vieta.

👉 **Quindi NON propongo il round. Propongo il PASSO 0 che decide se il round
esiste**, e costa una passata:
> **quanti gap veri (|gap| >= 1,0%) hanno U30USD e D30EUR a BCM fra il
> 2024.09.26 e il 2026.06.30, e quanti sono ribassisti?**

Se sono >= 150 il round si scrive; se sono 20, la pista si chiude con un
numero e non se ne parla piu'. ⚠️ E c'e' un secondo **[INCERTO]** vero: i CFD
indici a BCM girano quasi 24 ore, quindi **non e' ovvio che un "gap" esista**
come su un future con sessione chiusa. Va misurato, non assunto.

**PUNTEGGIO**
semplicita' 2 · filtro=motore 2 (il gap E' il segnale) · tesi 2 · buco **2**
(lato short + orario) · testabile **1** (il filtro Kalman e' codice nuovo, e
la frequenza e' un punto interrogativo) → **9/10 sull'idea, ma 🟡 IN CODA**
finche' il PASSO 0 non dice che il campione esiste.

**🏛️ RIGA PROP:** un motore short e' l'unica assicurazione vera contro il
giorno in cui il muro giornaliero viene sfondato da tutte le nostre sedie
long insieme. Ma ⚠️ 13 operazioni in 22 mesi **non sono una sedia**: sono un
biglietto della lotteria. La riga onesta e': *se il campione non c'e', non
serve a niente in ottica prop.*

---

### 5️⃣ N1 — **L'OVERNIGHT DRIFT SUL DAX: il buco orario che nessuno copre**

```
NOME    "Strikingly Suspicious Overnight and Intraday Returns"
AUTORE  Bruce Knuteson · arXiv:2010.01727v1 [q-fin.GN] · 5 ottobre 2020
FONTE   https://arxiv.org/abs/2010.01727  (PDF scaricato e letto)
```

**LA TESI IN UNA RIGA** _"Su ventun indici mondiali, quasi tutto il rendimento
positivo degli ultimi decenni si e' formato mentre il mercato era CHIUSO."_

**COSA DICE IL PAPER, TESTUALMENTE** _[DICHIARATO, NON MISURATO DA NOI]_ —
figura 1, ventun indici: _"Overnight returns to major stock market indices
over the past few decades have been wildly positive, while intraday returns
have been disturbingly negative."_ Esempio riportato: **TSX 60, +1.062%
overnight contro −67% intraday** su vent'anni. L'autore insiste sulla
robustezza: _"robust to using the price shortly after market open rather than
the official open price... and to using data from different data providers"_,
e dichiara riproducibile con dati pubblici. L'unica eccezione citata e' la
Cina.

**PERCHE' RIGUARDA NOI, E PERCHE' ADESSO**
- 🎯 **E' un buco ORARIO puro.** Le nostre sedie sparano alle **08:00** (DAX
  apertura), alle **14:30** (Dow), di **notte** (MaxMinNotte, box breakout) e
  in swing H1/H4. Fra la **chiusura di Xetra (16:30 server)** e le 08:00 del
  giorno dopo **non abbiamo nessun motore direzionale**: abbiamo solo un
  motore di **rottura di box**, che e' un'altra cosa.
- ✅ **Frequenza giusta per i nostri dati**: una operazione al giorno →
  **~450 nella finestra**. E' l'unico candidato "di calendario" che il §2 non
  uccide.

🔴 **I TRE MOTIVI PER CUI POTREBBE NON ESISTERE DA NOI — vanno detti prima**
1. **CFD ≠ indice cash.** Il D30EUR a BCM gira quasi in continuo: la nostra
   "notte" **non e' un gap**, e' un percorso di prezzo che **contiene tutta la
   sessione americana**. Non e' lo stesso oggetto del paper.
2. **Si paga il finanziamento.** Tenere un CFD indice lungo per la notte
   costa swap, ogni notte, 450 volte. Il paper misura rendimenti **lordi**.
3. **E' beta lungo.** Comprare tutte le sere e' correlato al mercato e alla
   meta' delle nostre sedie: in ottica prop **aggiunge DD nello stesso giorno
   in cui lo aggiungono le altre**, che e' la regola 3 della rotta prop.

👉 **Quindi anche qui propongo una MISURA, non un round, e non serve un EA:**
> **rendimento medio e mediano di D30EUR fra le 16:30 e le 08:00 server, al
> netto dello spread misurato (T1) e dello swap reale del conto, su
> 2024.09.26 → 2026.06.30. E la stessa misura sulla finestra opposta
> (08:00→16:30), per vedere se la firma del paper c'e' o non c'e'.**

E' un cancello zero prima di scrivere codice: **o il numero e' positivo al
netto dei costi, o la pista muore in una serata a costo zero.**

**PUNTEGGIO**
semplicita' 2 · filtro=motore 2 (l'orario E' la strategia) · tesi 2 · buco 2
(fascia 16:30-08:00 scoperta) · testabile **1** (l'EA non esiste, ma il PASSO
0 non ne ha bisogno) → **9/10 sull'idea, 🟡 IN CODA dietro il PASSO 0.**

---

## 4. 🗑️ GLI SCARTI — uno per riga, col motivo che li prova

### 4.1 Scartati perche' **erano gia' morti o gia' scartati** (lista dei caduti)

| # | candidato | fonte | perche' e' fuori |
|---|---|---|---|
| S1 | **`002 - Inside Bar`** | Code Base [73884](https://www.mql5.com/en/code/73884), dj_ermoloff, 2026.06.11, **DL 560**, 334 righe, 11 input veri | 🔴 **GIA' SCARTATO PER ISCRITTO il 16/08** in `CACCIA_2026-08-16_F_SHORT.md`: _"e' un motore di BREAKOUT dalla inside bar, e il breakout e' porta chiusa con ~96 celle (R7-R13, R42, R45, R12). Non lo riapro per la terza volta."_ ⚠️ **Nota onesta: e' il codice migliore che ho letto oggi** (direzione COSTITUTIVA — deriva dal corpo della barra madre, non da un input; SL = 0,62×range, TP a multiplo di R, una posizione, pendente che scade). **Ma non lo riapro io una quarta volta**: la decisione e' di Claudio, non di una caccia. E ha comunque un difetto di gestione: `balance` e' letto **una volta sola in `OnInit()`** (riga 52) → "rischio %" che in realta' e' **lotto fisso travestito**. |
| S2 | **Fade / rimbalzo degli estremi del range d'apertura** | idea mia, uccisa dai nostri referti | 🔴 **R42 0/48 + R43 2/64 (entrambe ribaltate)**: _"il capitolo estremi del range di apertura CHIUDE DEFINITIVAMENTE"_. Ci ho pensato, ho controllato, e' morto. |
| S3 | `Session Opening Range Breakout EA` | Code Base [76153](https://www.mql5.com/en/code/76153), Stridz_z, 2026.08.15, DL 188 | 🔴 doppione secco del nostro `ABTG_ORB`/`ABTG_Dow_Apertura_US`, **senza** il retest: 22 input, ORB nudo, buffer in punti fissi, `InpMaxTradesPerSession=1`. Non aggiunge niente che non abbiamo. |
| S4 | `AAPL cfd - ORB strategy`, `003 - Weekly Day Reversal`, `HybridMicrostructure`, `2-Pair Correlation`, `20 Pips Opposite Last N Hour Trend` | Code Base 76333, 74137, 76331, 52043, 19500 | 🔴 gia' letti, letti bene e scartati **il 22/08** (`SWEEP_MECCANISMI_LIBERI_2026-08-22.md` §D1-D5). Non li ho riaperti: cio' che e' setacciato non si ricontrolla. |
| S5 | **Intraday momentum portato sul Dow** (il motore di R98) | — | 🔴 **NON lo propongo, e spiego perche' invece di tacerlo.** R98 ha misurato che sul NASUSD il risultato medio per operazione e' **−0,31 punti indice GIA' al netto dello spread** su 410 operazioni: il cancello zero e' **matematicamente impossibile**. Spostare lo stesso motore sul Dow e' "parametri diversi di un motore morto" con un simbolo al posto di un parametro. Se qualcuno lo vuole riaprire, deve prima portare una **ragione economica** per cui il Dow sia diverso — e io non ce l'ho. |

### 4.2 Scartati per **bandiera rossa nel sorgente**

| # | candidato | fonte | la riga che lo prova |
|---|---|---|---|
| S6 | `BreakRevertPro EA` | Code Base [56773](https://www.mql5.com/en/code/56773), 1.699 righe UTF-16, 12 input | 🔴 **cambia comportamento nel banco di prova**: `input bool enable_safety_trade = true; // Enable safety trade during testing` + funzione _"Detect if we're in a validation environment"_ + _"Execute a safety trade for validation"_. **Un EA che apre operazioni finte quando si accorge di essere in un tester non e' misurabile**: i nostri verdetti vengono dal tester. Fuori senza discussioni. (In piu': `lookback_period = 1` per una "probabilita'".) |
| S7 | `ADX Trend Pullback EA` | Code Base [73958](https://www.mql5.com/en/code/73958), 295 righe | 🔴 **doppio motivo**: (a) `input double InpLotSize = 0.01; // Fixed lot size` — **lotto fisso**, non scalabile a 100k, motivo di scarto ricorrente nel `SETACCIO_MANUALE.md`; (b) e' lo schema **"filtro ADX appiccicato"** (`InpADXThreshold=25` sopra un pullback su EMA20), cioe' il pattern con **0 successi su 5** in casa nostra (R20 ADX, R12, R26, R45, R54). |
| S8 | `E-Friday` | Code Base [23108](https://www.mql5.com/en/code/23108) | 🔴 `input double InpLots = 1.0` (lotto fisso) + SL/TP in **pip fissi** (50/50) + frequenza **settimanale** → n≈95 su indice, sotto la soglia. Tre motivi indipendenti. |
| S9 | `MeanReversion` (58135) e `Mean Reverse` (57020) | Code Base | 🔴 doppione di `ABTG_MeanRevert.mq5` che abbiamo gia'. Il 58135 in particolare compra il minimo a 200 barre con TP sulla media: **coltello che cade**, e su un mercato in trend e' il modo piu' rapido di fare drawdown. |

### 4.3 Scartati perche' **non abbiamo i dati per misurarli** (§2)

| # | meccanismo | fonte letta | n atteso da noi | perche' e' fuori |
|---|---|---|---|---|
| S10 | **Turn of the Month sugli indici** | [Quantpedia](https://quantpedia.com/strategies/turn-of-the-month-in-equity-indexes/) → Lakonishok & Smidt (1988), McConnell & Xu, Carcano & Tornero. Effetto misurato su **30 mercati**, DJIA **1897-1986** | **~22** | 🔴 22 osservazioni. Non e' un round: e' un aneddoto. Riapribile solo con dati indice esterni usabili. |
| S11 | **EIA del mercoledi' sul petrolio** — il rendimento della TERZA mezz'ora prevede l'ULTIMA nei giorni di annuncio | Wen, Indriawan, Lien, Xu (2023), *The Energy Journal* 44(4) — [scheda](https://journals.sagepub.com/doi/abs/10.5547/01956574.44.4.zwen) | **~95** | 🔴 **Il meccanismo mi piace molto** (evento programmato, causa dichiarata: piu' trader informati + liquidita' che si assottiglia) **ma USOIL a BCM parte dal 2024.09.26**: 95 mercoledi'. Sotto i 150, merito sospeso per costruzione. ⚠️ E ho letto solo l'abstract: **il full text e' su SAGE, non l'ho aperto** — quindi la meccanica esatta resta **[INCERTO]**. |
| S12 | **Pre-FOMC announcement drift** | noto in letteratura, non riaperto oggi | **~14** | 🔴 quattordici osservazioni. |
| S13 | **Stagionalita' dell'oro** (autumn effect, Natale, settembre/novembre) | [Quantpedia](https://quantpedia.com/an-extensive-test-of-market-timing-strategies-in-the-gold-market/) → Bartsch/Baur/Dichtl/Drobetz, 1990-2015 | 22 anni ma **~22 osservazioni per mese** | 🔴 **e stavolta lo boccia la FONTE, non i dati**: delle 4.096 allocazioni stagionali testate, **nessuna sopravvive allo SPA-test di Hansen** contro il data-snooping. Sopravvivono solo le tecniche. 💰 Round risparmiato. |

### 4.4 Scartati come **doppioni delle nostre sedie**

| # | candidato | perche' |
|---|---|---|
| S14 | `GoldLondonBreakout` **come EA** | box asiatico + rottura = `ABTG_MaxMinNotte` sull'oro, sedia R17 gia' viva. 🟢 **Ma i suoi due pezzi ATR entrano in shortlist come M1** — il motore e' doppione, la meccanica no. |
| S15 | **Mean reversion intraday sull'oro** | 🔴 falsificata dal paper che ho letto: arXiv 2605.04004 §4.8, Ornstein-Uhlenbeck su **MGC (micro gold futures)**, tutte le configurazioni FAIL con T da −1,12 a **−4,49**. E l'argomento strutturale e' quello buono: _"the 60-minute signal's mean-reversion half-life works out to roughly 8 hours — longer than a single RTH session"_. 👉 **Conferma per contrasto che l'oro va lavorato su H4/D1, che e' dove stanno le nostre sedie.** |

---

## 5. 🔓 LE PISTE APERTE DI IERI — cosa ne e' rimasto

Il mandato chiedeva di ripartire da qui invece di riscoprire. Esito, una per una.

| pista aperta il 22/08 | esito oggi |
|---|---|
| **Gold Phantom** (Market 161561, 649 USD, unico signal oro dentro il muro del 10%, con la bandiera rossa del sizing circolare) | ⚪ **NON TOCCATA, e per regola.** E' un prodotto **a pagamento senza sorgente**: il §4 non e' applicabile e la strada e' UNA sola — `CANCELLO_ACQUISTI_EA.md` (scheda → setaccio → demo nel tester → decisione di Claudio). **Non e' materia di questa caccia**, che era sul gratuito. Resta com'era. |
| **EquityGuardPanel** (Code Base 73870, `OnTimer`) | ⚪ **non riaperto**: e' gia' stato letto riga per riga il 22/08 e la consegna e' fatta (§3.3 di quel dossier + i 24 buchi del Guardian). Riaprirlo sarebbe rifare lo stesso lavoro. |
| **La versione Market v1.50 dell'upstream del nostro GapContinuation** (prodotto 187414, changelog vuoto) | 🟢 **CHIUSA A META', con una misura.** Ho **riscaricato oggi** il sorgente libero [Code Base 75301](https://www.mql5.com/en/code/75301): **43.393 byte, 1.160 righe, `#property version "1.50"`, `#property copyright "Francesc Jordi Mallol Nolden"`** — **identico byte per byte** a quello che l'header del nostro `ABTG_GapContinuation.mq5` dichiara di aver scaricato il 16/08. ➡️ **Sul lato gratuito l'upstream NON e' cambiato in una settimana: non c'e' nessuna correzione che ci stiamo perdendo.** Il prodotto Market resta **[INCERTO]** e resta fuori: niente sorgente, niente setaccio. |
| **Il conflitto R42-vs-paper sul retest** | 🟢 **SCIOLTO, e non serve un round.** Tre pezzi: **(1)** il paper (arXiv 2605.04004, tabella 3) boccia il pullback su MNQ con **N=83, netto −4,44 pt, T=−1,27, win 19,3%** — ma **T=−1,27 non e' una falsificazione, e' un campione che non dice niente**, e sta sul **Nasdaq**, dove R97 e R98 hanno gia' misurato in casa che non c'e' edge. **(2)** In casa, `ABTG_Dow_Apertura_US.mq5` ha gia' `ABTG_RETEST = 2` (riga 174) con `InpRetestOffsetPts` — **e non e' un ramo mai provato: e' la modalita' su cui girano le sedie vive** (R16d: _"cella FASE M: RETEST 35/500/200 SOLO LONG"_; `InpEntryMode=2` in R35a, R35b, R46a, R46b). **(3)** Quindi le due fonti **non si contraddicono**: parlano di due mercati diversi, e su quello dove il retest gira, gira in live. ➡️ **Nessun round da aprire. La voce si puo' cancellare dalla coda.** 💰 Secondo round risparmiato oggi. |

---

## 6. 🕳️ COSA NON HO POTUTO VEDERE — dichiarato, non taciuto

| non visto | conseguenza concreta |
|---|---|
| 🔴 **SSRN (403, quarta caccia di fila)** | Il paper di Bartsch/Baur/Dichtl/Drobetz sull'oro l'ho letto **solo attraverso la scheda Quantpedia**, non nel PDF. I numeri che riporto sono **di secondo grado** e vanno etichettati come tali. |
| 🔴 **Forex Factory (403, quarta di fila)** | Continuo a non sapere **come sono invecchiati** i sistemi sul Dow e sull'oro. E' l'unica fonte che racconta cosa succede quando una strategia smette di funzionare. |
| 🔴 **Ricerca GitHub (403)** | Canale chiuso: leggo solo repo di cui conosco gia' l'URL. Zero repo nuovi in quattro cacce. |
| 🔴 **Tutto il Pine di TradingView** | `/scripts/` rende **zero link a script**. Non e' "non ho trovato niente": e' **non ho potuto guardare**. |
| 🟡 **Il full text del paper EIA/petrolio** (SAGE) | Ho l'abstract, non la meccanica esatta. E' il motivo per cui S11 e' scartato **anche** per `[INCERTO]`, oltre che per campione. |
| 🟡 **Quantpedia: solo per slug** | Il `sitemap.xml` e' 466: ci arrivo solo se la ricerca web mi da' lo slug. Non ho potuto **enumerare** il catalogo, quindi non so cosa mi sono perso. |
| ⚠️ **Nessun backtest e' stato eseguito qui** | In questo ambiente non esistono MT5 ne' Strategy Tester. **Nessun numero di questo dossier e' stato misurato da noi**: quelli in casa vengono dai referti citati, quelli di fuori sono etichettati `[DICHIARATO]`. |

---

## 7. 🏁 LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> ## 🎯 **"La cella viva dell'oro (`SupertrendReversal_Ott`, XAUUSD H4, 1%) che drawdown avrebbe fatto nell'ottobre 2008 e nell'aprile 2013 — e quel numero sta dentro il contratto che le abbiamo firmato su ventun mesi?"**

**Non "quanto guadagna in vent'anni".** Il merito lo giudica la finestra
recente (Emendamento B). Questa domanda chiede **un fatto accaduto**, e i
fatti accaduti valgono a qualunque n.

E vale piu' di tutte le altre della giornata per un motivo semplice: **su
XAUUSD abbiamo dodici grafici in flotta**. Se il drawdown lungo di quella
famiglia e' il doppio del promesso, non stiamo scegliendo male una sedia:
stiamo portando una concentrazione che il muro del 10% non perdona. E la
risposta costa **una passata e zero righe di codice**.

---

## 8. 📋 RIEPILOGO PER LA CODA

| # | oggetto | buco che riempie | punteggio | verdetto | cosa serve |
|---|---|---|---:|---|---|
| **G1** | **Oro su 22 anni — misura del RISCHIO** | il DD vero delle sedie oro, mai misurato | **10/10** | 🟢 **PROVA SUBITO** | **niente**: file prova gia' scritto (`prove/R99_ORO_22ANNI_RISCHIO.txt`) |
| **T1+T2** | RealCost Spread P95 Logger + Round Trip Cost Reconciler | il cancello zero S0, "DA MISURARE A MANO" da R98 | — | 🟢 **DA SACCHEGGIARE** | filtro orario da aggiungere (~decine di righe) + verifica che `SYMBOL_SPREAD` viva nel tester |
| **M1** | filtro ampiezza box in ATR + geometria in ATR (da GoldLondonBreakout) | la volatilita' oro raddoppiata, asterisco di R17 | **8/10** | 🟢 **PROVA SUBITO** (come gemella) | 2 input nuovi su `ABTG_MaxMinNotte` + file prova |
| **D1** | Gap Continuation SHORT (Kalman) | **il LATO SHORT** (4 titolari su 5 mono-lato) | 9/10 idea | 🟡 **IN CODA dietro un PASSO 0** | contare i gap veri di U30USD/D30EUR. Se <150: chiuso |
| **N1** | Overnight drift 16:30→08:00 sul DAX | la fascia oraria 16:30-08:00, scoperta | 9/10 idea | 🟡 **IN CODA dietro un PASSO 0** | misurare il rendimento notturno netto di spread e swap. Nessun EA |
| S1-S15 | quindici scarti | — | — | 🔴 | motivo per riga in §4 |

---

_Redatto il 23/08/2026. Nessun EA nostro toccato, nessun parametro in forward
modificato, nessun round aperto. Nessun numero di autore ha pesato su un
punteggio. Le uniche due scritture su disco sono questo file e
`backtest_pipeline/prove/R99_ORO_22ANNI_RISCHIO.txt`._
