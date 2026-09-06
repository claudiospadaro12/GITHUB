# 🎯 CACCIA NASDAQ — MECCANISMI ALTERNATIVI (regola della seconda caccia) — 06/09/2026

**Mandato (Claudio):** _"non voglio arrendermi sul Nasdaq, a tratti regge"_.
Applicazione della **regola della seconda caccia** (`CLAUDE.md`, 19/08): dopo
un motore senza edge stabile si cercano **MECCANISMI alternativi sulla stessa
inefficienza**, **mai parametri diversi del motore morto**.

🔒 **Nessun EA scritto o toccato. Nessun `.set`. Nessuna sedia viva toccata.
Nessun backtest lanciato.** Consegno: questo dossier, **un file prova di
PASSO 0** (`prove/GAPCASH_NAS_PASSO0.txt`) e **lo strumento che rende
riproducibile ogni numero qui dentro**
(`caccia_strategie/misura_gapcash_nasdaq_2026-09-06.py`).

---

## ⚡ LA RIGA CHE CONTA

> **Su 6 fonti passate al controllo positivo (4 vive, 2 murate) e ~35
> candidati/meccanismi censiti, arrivano al sorgente o al dato **4**.
> Ne promuovo **UNO a PROVA SUBITO** e **uno IN CODA** — e il promosso non
> l'ho letto: l'ho **MISURATO**, su **2.568 giornate di Nasdaq (2010-2020)**
> che avevamo già in casa e che nessuno aveva interrogato così.**
>
> 🥇 **CANDIDATO A — il GAP DELLA SESSIONE CASH.** Quando il Nasdaq apre la
> seduta USA **sotto** la chiusura cash del giorno prima di almeno **0,50%**,
> i **primi 15 minuti rimbalzano**: media **+0,0988%**, **win 60,1%**,
> **n=348**. Il controllo senza il filtro sugli stessi 2.568 giorni fa
> **+0,0112%** e **win 50,8%**. Simulazione stop-only con **costo dedotto**:
> **E da +0,14R a +0,27R netta, PF 1,52-1,82, su 8 stop diversi su 8**;
> **senza il gate** la stessa simulazione fa **+0,015R e PF 1,05**.
> 👉 **Il gate NON è un cerotto: È il motore** (`ROBUSTEZZA.md` §5B).
>
> 🔴 **E la notizia scomoda, che è la ragione per cui questo non era mai
> stato visto:** il nostro `ABTG_Nasdaq_Apertura_US` calcola il gap come
> `iOpen(D1,0) − iClose(D1,1)` su un **CFD che quota quasi 24 ore**, cioè
> **attraverso la mezzanotte del server — dove non succede quasi niente**.
> Il referto R62 se n'era accorto e l'aveva scritto: _"questo motore non
> trada il gap di apertura, trada il gap del weekend"_. **Il gap vero della
> sessione cash del Nasdaq, in casa nostra, non è mai stato calcolato da
> nessun EA.** R61/R62 non hanno bocciato questo meccanismo: hanno misurato
> **un'altra grandezza**.
>
> 🛑 **E il non-candidato che vale un round risparmiato: l'ORB-straddle PS5
> del collega NON è un meccanismo nuovo. È `ABTG_ORB.mq5` (magic 770601),
> stessa finestra al minuto** (14:25-14:30 server = **15:25-15:30 IT**),
> stesso straddle BuyStop/SellStop, stessa parziale+pari. Ed è **già morto
> con i nostri tick**: **R97, 0/4 celle**, PF OOS **0,84-0,91** su n=135.

---

## 0. 📡 CONTROLLO POSITIVO — fonte per fonte, fatto PRIMA di cercare

| fonte | bersaglio noto | esito misurato oggi | verdetto |
|---|---|---|---|
| **arXiv API** `export.arxiv.org` | `id_list=2010.01727` deve dare _"Strikingly Suspicious Overnight and Intraday Returns"_ | **HTTP 200**, titolo e abstract corretti | 🟢 **PASSA** |
| **arXiv** (verifica di una citazione di casa) | `2605.04004` deve essere il paper MNQ già citato nel `REGISTRO_TEST` | 200, titolo _"Structural Limits of OHLCV-Based Intraday Signals in MNQ Futures"_, Mesfin | 🟢 **PASSA** |
| **MQL5 Code Base** `/en/code/mt5/experts` pag. 1-3 | devono comparire titoli che **so già** esserci (`Chaos Theory Lyapunov Exponent EA`, `GoldLondonBreakout`, `Daily Zone Recovery`, `Nikkei 225 Gap Continuation EA`, `Price Action Intraday Trading`) | 200, **tutti e cinque presenti** | 🟢 **PASSA** |
| **TradingView** `/scripts/nas100/` | deve dare titoli+autori+slug reali | 200, 17 script con autore e slug | 🟢 **PASSA** |
| **WebSearch** (canale bibliografico) | paper di cui conosco rivista e anno (Donaldson-Kim JFQA 1993, Pagonidis 2013, Yu-Rentzler-Wolf) | rivista, volume e pagine corretti | 🟢 **PASSA** |
| 🔴 **SSRN** `papers.ssrn.com/…712168` | abstract Yu-Rentzler-Wolf | **HTTP 403** | 🔴 **NULLA** (muro già agli atti dal 29/08) |
| 🔴 **Forex Factory** `/forum/71-trading-systems` | elenco thread | **HTTP 403** | 🔴 **NULLA** (stesso muro del 03/09) |
| 🔴 **GitHub ricerca** `/search?q=…` | elenco repo | **HTTP 429, `Retry-After: 3600`** | 🟠 **NON RAGGIUNTA** — ⚠️ **429 ≠ 404**: il canale c'è, è a quota. `gh` non è installato su questa macchina. **Da riprovare, non da cancellare** |
| 🔴 **joim.com** (JOIM, articolo Nasdaq-100) | full text | **EGRESS_BLOCKED** | 🔴 **NULLA** |
| 🔴 **naaim.org** (PDF Pagonidis sull'IBS) | full text | **EGRESS_BLOCKED** | 🔴 **NULLA** |

**Fonti murate: 3 permanenti (SSRN, Forex Factory, joim/naaim) + 1 a quota
(GitHub).** Nessuna sostituita con la memoria: quello che non ho aperto non
è scritto qui.

---

## 1. 📕 COSA HO LETTO IN CASA PRIMA DI USCIRE

`report/ROBUSTEZZA.md` · `report/ROTTA_PROP.md` ·
`backtest_pipeline/REGISTRO_TEST.md` (1.590 righe, per intero il capitolo
indici) · `prove/R52_CENSIMENTO_LATI.md` · `prove/CELLE_REGIME.txt` ·
`caccia_strategie/SETACCIO_MANUALE.md` (indice + le battute Code Base) ·
`caccia_strategie/CACCIA_FREQUENZA5_TASSONOMIA_2026-09-03.md` (**la
tassonomia M1-M31, per intero**) · `CACCIA_NASDAQ_DRIVE_2026-08-29.md` ·
`CACCIA_SHORT_INDICI_2026-08-29.md` · `CACCIA_POMERIDIANO_US_2026-08-30.md` ·
`CACCIA_TF_M5/M15/M30_2026-09-05.md` · `CACCIA_POSTNEWS_MECCANISMI_2026-09-05.md` ·
`report/DOSSIER_EA_NASDAQ_ESTERNI_2026-08-21.md` ·
`risultati_archivio/R97_REFERTO.md` · `REFERTO_ROUND61/62_GAPFILL*.md` ·
`risultati_archivio/ANATOMIA_APERTURE_20260826/*` (referto + censimento fonte) ·
`risultati_archivio/sondarelativo/REFERTO_NAS_M5_ESTESA_…_VIVO.txt` ·
`mql5/Experts/ABTG_ORB.mq5` · `mql5/Experts/ABTG_Relativo.mq5` · `FLOTTA_ATTIVA.md`.

### 1.1 ⛔ Cosa NON ho riaperto, e perché

| oggetto | chiuso da | non si riapre perché |
|---|---|---|
| **ORB / breakout d'apertura sul Nasdaq** | **~210 celle a tick**: R12 (48/48 negative OOS), R45 (0/48), **R97 (0/4, PF OOS 0,84-0,91)**, A4 (0% combo), Live5m (27/27) | capitolo **BREAKOUT M5 CHIUSO** a verbale dal 26/07/26, **più** una falsificazione esterna indipendente (arXiv 2605.04004, 947 giorni MNQ) |
| **RELATIVO (z-score del rapporto NASUSD/U30USD)** | R117 / R117BIS, merito sospeso | la regola **vieta** parametri diversi dello stesso motore. Non l'ho toccato |
| **MQL5 Code Base come miniera di motori** | 02/09, **400 id su 10 pagine**: zero motori intraday | ho fatto solo il **controllo positivo** su 3 pagine, non una rastrellatura |
| **ML sugli indici** | arXiv 2605.17724: **nessuna configurazione sopra il tasso base 51,8%** su 944 giorni MNQ | l'autore stesso: 4 anni di OHLCV a 5 minuti su un solo strumento **non bastano**. Noi ne abbiamo 21 mesi a tick |
| **M13 momentum intraday prima/ultima mezz'ora** | **R98**: 0/6 celle, −0,31 punti indice lordi per trade su 410 | ⬛ |
| **M14 fade di banda** | R60 (12/12), R108/R111 (6 finestre su 6) | ⬛ tre volte |

---

## 2. 🥇 CANDIDATO A — **IL GAP DELLA SESSIONE CASH DEL NASDAQ** · PROVA SUBITO

```
NOME            Rimbalzo dei primi 15 minuti dopo un gap CASH in giu'
                (nome di lavoro: GAPCASH_NAS)
FONTE           MISURA NOSTRA su dato nostro. Il meccanismo e' della
                letteratura (vedi 2.1); il NUMERO e' misurato oggi su
                risultati_archivio/ANATOMIA_APERTURE_20260826/
                ANATOMIA_APERTURE_PERGIORNO_NASUSD.csv (4.877 giornate,
                fonte C:\Users\Master\abtg_storico_indici\NASUSD_M1.csv,
                5.233.590 barre M1, 2010.11.14 -> 2026.07.31)
AUTORE / DATA   meccanismo: Yu, Rentzler & Wolf, "Nasdaq-100 Index Futures:
                Intraday Momentum or Reversal?", Journal of Investment
                Management [LETTO-VIA-SEARCH: SSRN 403, JOIM egress-blocked]
LICENZA         nostra (dato di casa, strumento di casa)
RIGHE / INPUT   l'EA non esiste ancora. Input previsti: 6 (vedi il prova)

TESI IN UNA RIGA
  "Guadagna perche' un gap in giu' del Nasdaq e' una richiesta di liquidita'
   concentrata su un solo lato: chi la fornisce alla campana viene pagato
   per il rischio d'inventario, e il pagamento si incassa nei primi minuti."

MECCANICA        ingresso: LONG a mercato all'apertura cash (14:30:00 server
                 BCM = 15:30 IT) SOLO se gap_cash <= -0,50%
                 uscita  : a TEMPO, al minuto +15. Nessun target.
                 stop    : reale al broker, in % del prezzo (0,40-0,50%)
GESTIONE RISCHIO % dell'equity (0,65% di campo) - un solo trade al giorno -
                 SL vero - nessun overnight - max 1 posizione
BANDIERE ROSSE   nessuna (non c'e' ancora codice: le bandiere si applicheranno
                 al .mq5 quando sara' scritto)
COSTO DI PORTING ~6-8 ore per la SONDA (contatore, zero ordini). L'EA
                 operativo e' un passo successivo e separato

PUNTEGGIO (0-2)
  [2] semplicita'                 6 input, una soglia libera sola
  [2] il filtro E' il motore      MISURATO: col gate +0,20R / PF 1,73;
                                  senza gate +0,017R / PF 1,07
  [2] tesi di mercato scrivibile  vedi sopra, una riga, con un autore dietro
  [1] riempie un BUCO             SI' sul MECCANISMO (mean-reversion condizionata
                                  all'evento, che non abbiamo) e sull'ORARIO
                                  (14:30 server, dove oggi non abbiamo niente
                                  di vivo sul Nasdaq). NO sul LATO: e' LONG,
                                  e il buco n.1 resta lo short. Punto tolto.
  [1] testabile senza riscritture NO: l'EA va scritto. Ma il PASSO 0 e' una
                                  sonda contatore, ed e' il pattern gia' usato
                                  cinque volte (SondaRelativo, SondaM0PB, ...)

VERDETTO   PROVA SUBITO  (8/10)
PERCHE'    e' l'unico candidato di questa caccia che arriva con un numero
           MISURATO su 2.568 giornate, un CONTROLLO che lo separa dal caso,
           e una cassaforte 2021-2026 SIGILLATA pronta a validarlo.
```

### 2.1 L'evidenza esterna, etichettata

- **Yu, Rentzler & Wolf**, _"Nasdaq-100 Index Futures: Intraday Momentum or
  Reversal?"_, **Journal of Investment Management** (SSRN 712168).
  **`[LETTO-VIA-SEARCH]`** — SSRN **403**, JOIM **egress-blocked**: **l'abstract
  non l'ho aperto**. Dalle schede di ricerca: la regressione lega il rendimento
  intraday di oggi a quello di ieri **e a quello della notte**, e la frase che
  ci riguarda è _"last night's return is predominantly associated with
  **reversals**"_, con dipendenza dal **segno** e dal **giorno della settimana**.
  ⚠️ **Non ho letto il paper. Vale come indizio di direzione, zero come numero.**
- **Nagel**, _"Evaporating Liquidity"_, **Review of Financial Studies 25(7),
  2005-2039 (2012)** — già in tassonomia come **M16**. È la **spiegazione
  economica** del perché il rimbalzo esiste **solo sui gap in giù**: la
  reversione a breve _"can be interpreted as a proxy for the returns from
  liquidity provision"_, e quel pagamento **esiste solo quando la liquidità si
  ritira**. Un gap in giù del Nasdaq **è** quel momento. **`[LETTO-VIA-SEARCH]`**
- 🔴 **I numeri degli autori non entrano in nessun punteggio** (C8). Il
  punteggio qui sopra è costruito **solo** sui numeri misurati al §2.2.

### 2.2 🔬 LA MISURA — 2.568 giornate, solo IS, la cassaforte non è stata aperta

**La regola delle due fasi del referto della fonte, rispettata alla lettera:**
_"le IPOTESI di motore si scrivono SOLO sul referto IS (fino al 2020). Il
referto CASSAFORTE (2021-2026) NON si guarda per costruirle."_
👉 **Lo script filtra `fase == 'IS'`. Nessun numero di questo dossier contiene
il 2021-2026.** La cassaforte è **intatta**, e questo candidato ci arriva
davanti con l'ipotesi già congelata: è la condizione migliore in cui un
candidato possa presentarsi in questo progetto.

**Definizione del gap (dal referto della fonte, congelata il 26/08):**
`gap = Open della barra delle 09:30 New York − ultima chiusura cash (ultima
barra con orario <= 16:00 del giorno di borsa precedente)`.
09:30 New York = **14:30 ora server BCM** = 15:30 italiane.

#### A. La correlazione decade con l'orizzonte — la firma della reversione

| orizzonte | corr(gap, rendimento) |
|---|---:|
| +5 min | **−0,1911** |
| +15 min | **−0,1727** |
| +30 min | −0,1124 |
| +60 min | −0,0803 |

#### B. La cella, contro il suo controllo (uscita a +15 min)

| filtro | n | media | mediana | win% | MFE15 med | MAE15 med |
|---|---:|---:|---:|---:|---:|---:|
| **CONTROLLO — tutti i giorni** | 2.568 | **+0,0112%** | +0,0058% | **50,8%** | +0,155% | −0,149% |
| gap ≤ −0,30% | 566 | +0,0601% | +0,0653% | 57,8% | +0,236% | −0,181% |
| gap ≤ −0,40% | 436 | +0,0794% | +0,0851% | 58,3% | +0,257% | −0,192% |
| **gap ≤ −0,50%** | **348** | **+0,0988%** | **+0,1064%** | **60,1%** | +0,277% | −0,196% |
| gap ≤ −0,60% | 283 | +0,0996% | +0,1144% | 59,0% | +0,285% | −0,216% |
| gap ≤ −0,75% | 213 | +0,1179% | +0,1182% | 58,2% | +0,286% | −0,230% |
| gap ≤ −1,00% | 130 | **+0,1895%** | +0,1643% | **63,1%** | +0,373% | −0,228% |

🟢 **MONOTONO nella soglia** (0,060 → 0,079 → 0,099 → 0,100 → 0,118 → 0,190):
più il gap è grande, più il rimbalzo è grande. È il test che il progetto
chiede sempre e che ha bocciato la reversione overnight su DAX e S&P il 05/09.
**Qui passa.**

#### C. ⚖️ IL LATO OPPOSTO, misurato (regola dei due lati, 25/08) — **è NULLO**

| filtro | n | SHORT media | mediana | win% |
|---|---:|---:|---:|---:|
| gap ≥ +0,30% | 766 | +0,0028% | +0,0052% | 50,5% |
| gap ≥ +0,40% | 604 | **−0,0018%** | −0,0000% | 49,7% |
| gap ≥ +0,50% | 463 | +0,0076% | +0,0054% | 51,0% |
| gap ≥ +0,75% | 257 | +0,0294% | +0,0270% | 53,3% |
| gap ≥ +1,00% | 145 | +0,0350% | +0,0069% | 51,0% |

👉 **Non monotono, e a ridosso del controllo.** Il meccanismo è **asimmetrico
per misura, non per scelta**: il lato short non esiste. E l'asimmetria ha la
sua spiegazione (Nagel: la liquidità evapora quando si scende, non quando si
sale). **Il lato è stato misurato e dichiarato, non spento sull'IS.**

#### D. La simulazione con lo stop vero e il costo dedotto

Regola simulata: **LONG all'apertura, stop reale a −s%, uscita a tempo al
minuto +15, nessun target.** Se la MAE dei 15 minuti tocca −s l'operazione
chiude a −s; altrimenti chiude al prezzo del minuto 15. **Costo dedotto:
0,0060% del prezzo = 1,7 punti indice su 28.270** — lo spread **mediano
MISURATO** su NASUSD 14-20 server (`SPREAD_FLOTTA_MISURA_2026-09-03.md`).

| stop % | stop-out % | E netta % | **E in R** | win% | **PF** |
|---:|---:|---:|---:|---:|---:|
| 0,15 | 57,2 | +0,0533 | **+0,356** | 39,9 | 1,587 |
| 0,20 | 49,4 | +0,0546 | +0,273 | 46,0 | 1,520 |
| 0,25 | 40,8 | +0,0647 | +0,259 | 50,9 | 1,577 |
| 0,30 | 33,3 | +0,0651 | +0,217 | 53,4 | 1,553 |
| **0,40** | **18,4** | **+0,0815** | **+0,204** | **56,9** | **1,726** |
| **0,50** | **11,8** | **+0,0802** | **+0,160** | **57,8** | **1,700** |
| 0,60 | 6,9 | +0,0864 | +0,144 | 58,3 | 1,762 |
| 0,80 | 2,3 | +0,0912 | +0,114 | 58,9 | 1,820 |

🔴 **La cella in grassetto NON è la migliore: è il CENTRO DELL'ALTOPIANO.**
Il picco in R è a stop 0,15% (+0,356R) ed è esattamente la cella che la
regola di casa vieta — 57% di stop-out e win 39,9%. **Dodici Spearman IS→OOS
negative su tredici dicono che quella cella è la trappola.**

#### E. 🎯 IL CONTROLLO CHE DECIDE — la stessa simulazione **senza il gate**

| stop % | n | E netta % | **E in R** | win% | **PF** |
|---:|---:|---:|---:|---:|---:|
| 0,30 | 2.568 | +0,0045 | **+0,015** | 47,9 | **1,045** |
| 0,40 | 2.568 | +0,0067 | **+0,017** | 49,3 | **1,067** |
| 0,50 | 2.568 | +0,0051 | **+0,010** | 49,6 | **1,050** |

> 🥇 **Il rapporto è 12:1 in R (0,204 contro 0,017).** Non è un motore con un
> filtro sopra: **è il filtro che genera tutto**. È la forma che in casa
> vale **30 celle su 30** (`ABTG_EMA200` Dow, R29) contro le **0 su 5** dei
> filtri appiccicati.

#### F. Tenuta di regime — si tolgono i due anni più volatili

| | stop 0,30 | 0,40 | 0,50 | 0,60 |
|---|---:|---:|---:|---:|
| **senza 2018 e 2020** (n=251) | +0,183R · PF 1,49 | **+0,173R · PF 1,66** | +0,133R · PF 1,61 | +0,112R · PF 1,62 |

Anni con media positiva sulla cella −0,50%: **9 su 11** (negativi solo 2011 e
2012). **L'edge non è il 2020**, e non è nemmeno il 2018.

#### G. Il cancello di costo, e la frequenza

| voce | numero |
|---|---|
| take mediano della cella | **+0,1064%** = **30,1 punti indice** a 28.270 |
| cancello 3× spread NASUSD in sessione (misurato) | **4,8-5,4 punti indice** |
| **margine** | 🟢 **5,6×** (4,5× usando la mediana senza 2018/2020) |
| frequenza | **348 giornate su 2.568 = 13,6%** ≈ **33 all'anno** |
| **frequenza per giorno** | 🔴 **0,14/giorno — un ottavo del pavimento di 1,00** |

### 2.3 🔴 I CINQUE MOTIVI PER CUI QUESTO PUÒ ANCORA MORIRE — scritti PRIMA

1. 🔴 **Il dato è ESTERNO, non è BCM.** È il feed `abtg_storico_indici`
   (HistData), e il referto del 26/08 lo dichiara **"cancello qualità del feed
   IN VERIFICA"** con **22,9% di giorni sospetti nel 2023**. Il PASSO 0 serve
   proprio a rifare la misura **sui nostri tick**.
2. 🔴 **Il costo è dedotto con lo spread MEDIANO della sessione, e il minuto
   dell'apertura è il peggiore della giornata.** Non l'abbiamo misurato a
   parte. Se lo spread a 14:30:00 fosse 5 punti invece di 1,7, la E scende di
   circa 0,012% per operazione (≈ 0,03R su stop 0,40%): **non lo uccide, ma
   lo morde**. **Va misurato, non stimato.**
3. 🔴 **Il costo è espresso ai prezzi di OGGI.** Nel 2011-2015 il Nasdaq
   stava a 2.500-4.500 e 0,0060% erano 0,2-0,3 punti indice: lo spread vero di
   allora, in percentuale, era più caro. **La E storica è ottimista.**
4. 🔴 **Frequenza 0,14/giorno.** Sui tick BCM (503 feriali dal 26/09/2024)
   fanno **~68 operazioni**: **n = 150+150 NON è raggiungibile** su questo
   simbolo. Questo motore **non può ricevere un verdetto di merito a tick**
   prima di anni. È un **cecchino**, non portata — e va detto adesso, non dopo.
5. 🟠 **Collisione oraria.** Entra a **14:30:00 server**, lo stesso istante di
   `ABTG_ORB` (770601, NASUSD M5), di `Nasdaq_Apertura_US_Ottimizzato` (M5) e
   della **sedia GATED SHORT 770250** (M15, short sulla rottura al ribasso
   dell'apertura). 🔴 **Su una mattina di gap in giù il GATED SHORT vende e
   questo comprerebbe: sono opposti sullo stesso simbolo allo stesso minuto.**
   Regola di rotta: **mai due EA sullo stesso segnale/simbolo/lato**. Va
   sciolto **prima** di qualunque deploy — non è un dettaglio, è architettura.

### 2.4 🏛️ In ottica prop

- **Peggior giornata strutturalmente limitata**: **una** operazione al giorno,
  **uno** stop pieno. A 0,65% di rischio la giornata peggiore possibile è
  **−0,65%**, contro il muro giornaliero di **−5%**. È il profilo più
  gentile che abbia visto in una caccia.
- **Zero overnight, zero swap, zero rischio di gap** (l'operazione dura 15
  minuti). Il **DD trailing** delle prop non lo punisce: non ci sono lunghi
  ritorni dal picco dentro l'operazione.
- **Scorrelazione: buona sulla FORMA, da verificare sul LATO.** Lavora solo
  nei ~33 giorni all'anno di apertura in gap giù, cioè **esattamente le
  mattine in cui le nostre aperture long DAX/Dow non lavorano o perdono**.
  🔴 **Ma è LONG**, e il buco n.1 del portafoglio resta lo short: **non
  riempie quello**.
- 🔴 **Contro:** ~33 operazioni all'anno significa che il **criterio di uscita
  delle sedie a 20 operazioni** (firma 18/08) impiegherebbe **8 mesi** a
  maturare. Un passeggero lento.

---

## 3. 🥈 CANDIDATO B — **IBS (Internal Bar Strength) sull'indice** · IN CODA

```
NOME            IBS - reversione giornaliera basata sulla posizione della
                chiusura DENTRO il range della barra
FONTE / URL     TradingView "SHORT-ONLY Internal Bar Strength (IBS) Mean
                Reversion Strategy", autore Botnet101, 16/02/2025,
                https://www.tradingview.com/script/Ay41FF7e-SHORT-ONLY-Internal-Bar-Strength-IBS-Mean-Reversion-Strategy/
                (pagina APERTA; sorgente Pine NON leggibile: TradingView
                lo carica via JS, il fetch grezzo di 611 kB non contiene
                nessuna riga "strategy(" -- DICHIARATO)
                Fratello long+short: "IBS Trading Strategy for SPY and NDQ",
                Algotradekit, aggiornato 04/03/2025, slug C6uAEwxB
AUTORE / DATA   vedi sopra                POPOLARITA' non misurata
LICENZA         "Open-source subject to TradingView House Rules"
RIGHE / INPUT   3 input dichiarati (soglia alta 0,9 - soglia bassa 0,3 -
                finestra oraria). NON CONTATI NEL SORGENTE: non l'ho letto

TESI IN UNA RIGA
  "Guadagna perche' una chiusura sul massimo (minimo) della giornata segnala
   che la domanda (offerta) ha gia' consumato la liquidita' disponibile, e
   il giorno dopo il prezzo torna indietro."

MECCANICA        SHORT se IBS >= 0,9 E chiusura > massimo del giorno prima
                 uscita quando IBS <= 0,3
                 (il fratello long+short: LONG se IBS <= 0,2 e prezzo sopra
                  EMA 252, uscita a IBS >= 0,9)
GESTIONE RISCHIO 🔴 NESSUNO STOP LOSS dichiarato. Nessun sizing dichiarato
BANDIERE ROSSE   🔴 §4 "nessuno stop loss" -- ma vedi §5F del mandato di
                 ruolo: il MOTORE e' sano, la GESTIONE e' assente. La
                 gestione gliela mettiamo noi, e' la parte che sappiamo fare
COSTO DI PORTING Pine -> MQL5 = RISCRITTURA. ~10-14 ore per la sonda

PUNTEGGIO (0-2)
  [2] semplicita'                 due soglie, una formula di tre termini
  [2] il filtro E' il motore      l'IBS non e' un filtro sopra un motore:
                                  e' l'unica condizione d'ingresso
  [2] tesi di mercato scrivibile  si', ed e' la stessa di Nagel (M16)
  [1] riempie un BUCO             SI' sul LATO (esiste short puro) e sul
                                  TIMEFRAME (giornaliero: non ne abbiamo).
                                  NO come inefficienza: e' parente di M14,
                                  che e' nel cimitero tre volte. Punto tolto
  [0] testabile senza riscritture NO. Riscrittura + sorgente non letto +
                                  n non raggiungibile su BCM (vedi sotto)

VERDETTO   IN CODA  (7/10)
PERCHE'    e' la SOLA pista che il progetto abbia gia' segnato DUE VOLTE
           come "documentata e mai misurata", e questo mandato e' il primo
           che non la esclude per costruzione. Ma non e' pronta.
```

**Perché è in coda e non promossa, in tre righe:**

1. 🔴 **Non ho letto il sorgente** (TradingView non lo serve nell'HTML).
   Regola di casa: passo non saltabile. Il candidato è il **meccanismo**, non
   quello script.
2. 🔴 **La casa l'ha già parcheggiato due volte**, e va detto perché è un
   punto a favore, non contro: `CACCIA_INTRADAY_FOREX_ORO_2026-08-28.md` §S25
   — _"Comparsa **tre volte** oggi in modo indipendente. **Il progetto non
   l'ha mai misurata.** Ma è un meccanismo da barra GIORNALIERA con tenuta
   overnight: fuori dal requisito non negoziabile di oggi. Scritta qui per
   non perderla"_ — e `CACCIA_FREQUENZA_2026-08-31.md` (_"giornalieri, F1
   fallito per definizione"_). **Questo mandato non ha quel requisito.**
3. 🔴 **Il problema strutturale, dichiarato:** su un **CFD che quota ~23 ore**
   la "barra giornaliera" **non è** la barra della sessione cash su cui la
   letteratura misura l'IBS. Un IBS calcolato sulla D1 di BCM misura un altro
   oggetto. **La versione corretta è un IBS di SESSIONE** (15:30-22:00 IT),
   che è codice nuovo. **È esattamente lo stesso errore che ha reso cieco il
   nostro motore gap** (§2, R62): **è il secondo caso in un giorno.** Merita
   di diventare una regola di casa, ed è al §6.

**Evidenza esterna, etichettata:** Pagonidis, _"The IBS Effect: Mean Reversion
in Equity ETFs"_ (NAAIM, 2013) **`[LETTO-VIA-SEARCH]`** — PDF su naaim.org
**EGRESS_BLOCKED**; frase dalle schede: _"average returns when IBS is below
0.20 are .35%, while average returns when IBS is above 0.80 are −0.13%"_,
_"before transaction costs"_. E **arXiv 2306.12434** (Pandey & Joshi,
14/06/2023), _"Using Internal Bar Strength as a Key Indicator for Trading
Country ETFs"_ — **`[VERIFICATO]`**, abstract letto oggi via API: 10 anni,
paniere di ETF-paese. ⚠️ **Nessuno dei due misura il NASDAQ da solo, e nessuno
dei due include i costi in modo che ci serva.**

**In ottica prop:** tenuta **overnight** per 1-3 giorni → **swap** e **rischio
di gap**, e la curva a scalini con lunghi ritorni dal picco è **proprio la
forma che il DD trailing punisce**. Da segnalare adesso, non dopo.

---

## 4. 🛑 GLI SCARTI — uno per riga, col motivo

### 4.1 Il caso che il mandato chiedeva di verificare

| candidato | verdetto | motivo, in una riga |
|---|---|---|
| **ORB-straddle "PS5 ORB Bot" NAS100, sessione 15:25 IT** | 🔴 **NON È UN MECCANISMO NUOVO — è nostro, ed è morto** | **`ABTG_ORB.mq5` magic 770601** su NASUSD ha `InpRangeStartHour/Min = 14:25` e `InpRangeEndHour/Min = 14:30` **server** = **15:25-15:30 IT**: **la stessa finestra al minuto**. Ha lo **stesso straddle** (`TryPlace()` righe 330/342: `BuyStop` + `SellStop` sugli estremi, il primo toccato entra), la **stessa parziale + pari** (`InpTP1Pct=50`, `InpBreakeven=true`, `ManageTP1()` riga 480) e lo stesso stop all'estremo opposto (`ORB_SL_OPPRANGE`). **R97 l'ha misurato a tick reali su 4 geometrie: 0/4, PF OOS 0,84 / 0,86 / 0,89 / 0,91 su n=135, DD 8,2-12,4%.** Le 4 celle hanno **gli stessi ingressi**: il referto conclude _"il problema NON è la geometria dell'uscita: sono gli INGRESSI"_. 👉 **Cambiare la parziale a 80% a 1,5R e il target a 3R è ESATTAMENTE "parametri diversi dello stesso motore morto": vietato dalla regola della seconda caccia.** |

**E il PF 2,17 dichiarato dal collega non cambia niente**, per due motivi che
non sono opinioni: (a) **C8** — i numeri d'autore non entrano in nessun
punteggio; (b) **noi quel motore l'abbiamo già girato sui NOSTRI tick, sul
NOSTRO simbolo, nella STESSA finestra**, e ha fatto PF < 1 in quattro
geometrie su quattro. **Un backtest ideale altrui contro quattro misure
nostre a tick: non è una gara.**

### 4.2 I meccanismi guardati e non promossi

| # | meccanismo | fonte | verdetto e motivo |
|---|---|---|---|
| 1 | **Lead-lag come MOTORE: la divergenza NON converge, il gregario insegue** (M25) | tassonomia 03/09 + _"Intra-Day Anomalies in the Relationship between U.S. Futures and European Stock Indexes"_ `[LETTO-VIA-SEARCH]` | 🔴 **FALSIFICATO DAI NOSTRI DATI, e la misura c'era già.** `REFERTO_NAS_M5_ESTESA_2026-09-04`: **C6 non convergute 9,22%** (L 9,13 / S 9,32) su **1.534 divergenze chiuse** su NASUSD. **Nove su dieci convergono.** Il meccanismo "momentum sulla divergenza" vive sul 9%: non c'è. 🎯 **Vale un round risparmiato: la sonda RELATIVO aveva già in pancia il verdetto sul suo meccanismo gemello, e nessuno l'aveva letto così.** |
| 2 | **Classificatore di regime volatilità-volume-gap su MNQ (VVG)** | arXiv **2605.11423** (Mesfin) | 🔴 **GIÀ NEL REGISTRO come lapide** (righe 683-688): attiva sul **4,4% dei giorni = 40 in 4 anni**, e **l'autore ha già falsificato 8 configurazioni direzionali su 8**. Non si riapre. |
| 3 | **ML sequenziale su OHLCV 5-min MNQ** | arXiv **2605.17724** (Mesfin) | 🔴 **GIÀ NEL REGISTRO**: nessuna configurazione sopra il tasso base **51,8%** su 944 giorni; l'autore conclude che 4 anni **non bastano**. Noi ne abbiamo 21 mesi. |
| 4 | **Barriere psicologiche / numeri tondi sugli indici** (M23 applicato al NAS100) | Donaldson & Kim, _"Price Barriers in the Dow Jones Industrial Average"_, **JFQA 28(3), 313-330 (1993)** `[LETTO-VIA-SEARCH]` | 🟠 **NON PROMOSSO: l'evidenza SUGLI INDICI è contestata.** Donaldson-Kim trovano la barriera sui multipli di 100 del Dow, ma la letteratura successiva _"applying barrier tests to the Dow Jones 30, the FTSE 100 and the Nikkei 225 found **no convincing evidence** of psychological barriers, contrary to previous findings"_. L'evidenza **forte** di Osler è sul **libro ordini FX di una banca dealer**, non su un indice. Aggiungo: la lettura "rimbalzo al livello" è M14 (⬛ tre volte) e la lettura "accelerazione oltre" è breakout (⬛ ~210 celle). **Costo di validazione > valore atteso, oggi.** |
| 5 | **Reversione overnight → intraday, versione univariata** | Knuteson arXiv:2010.01727 · Lou-Polk-Skouras JFE 134 (2019) | 🔴 **GIÀ SEPOLTO IL 05/09** (`CACCIA_TF_M30`): DAX **1.513 coppie, monotonia FALLITA**; S&P **1.262 coppie, monotonia fallita e segno rovesciato**. ⚠️ **Nota di onestà: quella misura è su rendimento overnight PIENO del CFD, non sul gap CASH — non è la stessa grandezza del candidato A**, e infatti il candidato A la monotonia la passa. Ma la famiglia resta ⬛ nella sua forma univariata. |
| 6 | **`QQQ Strategy v2 ESL`** (easy-peasy-x, TradingView, 30/05/2025, slug `dwjybp5i`) | pagina aperta | 🔴 **SCARTO: la tesi è dentro il menu.** Ultimate RSI (LuxAlgo) **+** deviazione standard con segno **+** tre medie mobili **+** un filtro di trend **selezionabile fra quattro** (media / stddev / RSI / nessuno), per lato. È l'ottimizzatore che sceglie la strategia. |
| 7 | **`IBS Trading Strategy for SPY and NDQ`** (Algotradekit, slug `C6uAEwxB`) | pagina aperta | 🟠 **confluito nel candidato B**, non contato due volte. Difetto proprio: **nessuno stop loss** dichiarato. |
| 8 | **`3 Red / 3 Green Strategy with Volatility Check`** (Algotradekit) | elenco TradingView NAS100 | 🔴 **SCARTO: stessa famiglia del candidato B con evidenza peggiore** (barre consecutive = divulgativo). Doppione: non si portano due candidati della stessa famiglia. |
| 9 | **`Nasdaq DowJones RATIO`** (triccomane, indicatore) | elenco TradingView NAS100 | 🔴 **SCARTO: è RELATIVO** (M7), che è in casa e sotto verdetto sospeso. E **non è un EA**: disegna. |
| 10 | **`Vandan V2`** — NQ1! mean reversion, "+730%, PF 1,40, DD 1,61%, 106.000 trade" | trovato via ricerca | 🔴 **SCARTO — e la pagina non esiste**: `ar.tradingview.com/script/o9RQXXax` risponde **404**. 106.000 operazioni su 10 anni = **~42 al giorno**: fuori dal paletto prop HFT (max 25% sotto i 60 s) e comunque **non verificabile**. |
| 11 | **`Master Nasdaq FTMO MT5`** (111837) e **`Artemis NAS100 ORB Edge`** (180116) | già in `DOSSIER_EA_NASDAQ_ESTERNI_2026-08-21.md` | 🔴 **GIÀ SCARTATI il 22/08**: 20 posizioni simultanee + firma dell'ottimizzatore (H8/H6/H4/H3/H2, ATR 59/60/61/62) il primo; **Recovery Ladder ×1,2 dichiarata** il secondo. Non li ho riaperti. |
| 12 | **`Kepiro RangeReEntry`, `NAS100 9:30 NY Displacement`, `NQ 5x Daily Sessions`, `Equity Index Extended Hours`, `SESSIONS`, `Multi-Time Open Levels`, `Regime Dashboard`, `Market Average Trend`, `CE Market Performance Table`, `QQQ NDX NQ Price Converter`, `Binary Signals`, `swing_fun`** | elenco TradingView `/scripts/nas100/` | 🔴 **SCARTO in blocco: sono INDICATORI, non strategie.** Disegnano livelli, non operano: il setaccio §4 e l'imbuto non hanno niente su cui girare. |
| 13 | **`Forex Midpoint Stratejisi For Nasdaq`** (trademasterf, slug `ZnRFkWvB`) | elenco TradingView NAS100 | 🔴 **SCARTO: nessuna tesi leggibile** (mediana del range come segnale), autore senza altro materiale, pagina in turco senza descrizione di meccanica. |
| 14 | **Gap-fill / gap-continuation come famiglia** | M21/M22, `ABTG_GapFill` + `ABTG_GapContinuation` | 🟠 **NON un doppione del candidato A, e la distinzione è misurata**: `ABTG_GapFill` entra **contro il gap** puntando alla **chiusura completa** su H1, `ABTG_GapContinuation` va **col** gap sul Nikkei. Il candidato A ha **trigger diverso** (gap CASH, non gap del CFD), **uscita diversa** (a tempo, +15 min: cattura il 10-20% del gap, **non** il riempimento) e **lato fissato dalla misura**. Dichiarato qui perché la parentela va scritta, non nascosta. |

---

## 5. 🕳️ COSA NON HO POTUTO VEDERE — dichiarato, non riempito

1. 🔴 **SSRN (403)** — l'abstract di Yu-Rentzler-Wolf **non è stato letto**.
   Il candidato A **non poggia su quel paper**: poggia sulla misura del §2.2.
2. 🔴 **joim.com e naaim.org (EGRESS_BLOCKED)** — né l'articolo JOIM sul
   Nasdaq-100 né il PDF di Pagonidis sull'IBS sono stati aperti.
3. 🔴 **Forex Factory (403)** — la fonte forum **non è stata raggiunta**. Il
   valore che avrebbe (come è invecchiato un sistema) resta non acquisito.
4. 🟠 **GitHub (429, `Retry-After: 3600`)** — canale a quota, **non assente**.
   ⚠️ **429 ≠ 404**: da riprovare con attesa, non da cancellare. `gh` non è
   installato su questa macchina (`command -v gh` → vuoto).
5. 🔴 **Il sorgente Pine del candidato B non è leggibile** dall'HTML servito
   (611 kB scaricati, zero occorrenze di `strategy(`).
6. 🔴 **Lo spread NASUSD nel minuto 14:30:00-14:31:00 server non è misurato.**
   La tabella di casa dà la **mediana 14-20 server**; il minuto della campana
   è il peggiore ed è quello in cui il candidato A entra. **È il primo numero
   che il PASSO 0 deve produrre.**

---

## 6. 📌 LA LEZIONE DI METODO CHE ESCE DA QUESTA CACCIA (vale oltre il Nasdaq)

> 🔴 **Su un CFD che quota ~23 ore, ogni grandezza definita "al giorno" va
> ridefinita "alla SESSIONE", altrimenti si misura un'altra cosa — e non ce
> ne si accorge.**

Due casi, trovati **oggi**, sullo stesso repo:

| grandezza | come la calcoliamo | cosa misura davvero |
|---|---|---|
| **gap di apertura** (`ABTG_Nasdaq_Apertura_US:1425-1429`) | `iOpen(D1,0) − iClose(D1,1)` | il salto attraverso la **mezzanotte del server**, dove il Nasdaq è **aperto**: quasi zero infrasettimana → **R61/R62 hanno spazzolato un motore da weekend** (n=19-43), e il referto R62 §5 lo scrive |
| **IBS** (candidato B, se portato ingenuamente) | `(close−low)/(high−low)` sulla barra **D1 del broker** | la posizione della chiusura in una barra che contiene **Asia + Europa + USA + after-hours**: non è l'IBS della letteratura |

**Proposta (non applicata, non è mia da firmare):** una riga in
`CHECKLIST_RIGA_DI_LANCIO.md` — _"se il motore usa una grandezza 'giornaliera'
su un simbolo che quota più di 20 ore, dichiarare PRIMA del round se è
giornaliera-broker o di-sessione, e quale delle due dice la tesi."_

---

## 7. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> **Sui tick di BCM, sul simbolo NASUSD, dal 26/09/2024: le giornate con gap
> cash ≤ −0,50% esistono e quante sono; il rendimento medio dei 15 minuti
> dopo la campana su quelle giornate è positivo e almeno TRE VOLTE quello
> delle giornate normali; e lo spread mediano nel minuto 14:30:00 è tale che
> il take mediano lo copra almeno tre volte.**

**Se una sola delle tre risposte è no, il candidato A muore lì** — e sarà
morto per **48 ore di macchina di una sonda**, non per un round.
**Se sono tre sì, il passo dopo è un round di merito**, e solo allora si
parla di celle, di stop e di altopiano.

File prova pronto: **`backtest_pipeline/prove/GAPCASH_NAS_PASSO0.txt`**
(criteri congelati prima di qualunque numero, `@DAQUANDO` **misurato**).

---

## 8. 🗂️ LE PAGINE APERTE DAVVERO (per chi verrà dopo)

| URL | cosa ci ho preso |
|---|---|
| `export.arxiv.org/api/query?id_list=2010.01727` | controllo positivo (200, titolo corretto) |
| `export.arxiv.org/api/query?id_list=2605.04004` | verifica della citazione di casa: paper REALE, Mesfin |
| `export.arxiv.org/api/query?id_list=2605.11423` · `…2605.17724` | i due abstract Mesfin (già a registro come lapidi) |
| `export.arxiv.org/api/query?id_list=2306.12434` | abstract IBS su ETF-paese, **[VERIFICATO]** |
| `mql5.com/en/code/mt5/experts` (pag. 1, 2, 3) | controllo positivo: 5 titoli noti su 5 |
| `tradingview.com/scripts/nas100/` | 17 script con autore e slug (elenco al §4.2) |
| `tradingview.com/script/dwjybp5i-QQQ-Strategy-v2-ESL-easy-peasy-x/` | inputs e logica del QQQ Strategy v2 |
| `tradingview.com/script/C6uAEwxB-IBS-…-for-SPY-and-NDQ/` | regole IBS long+short, **niente stop** |
| `tradingview.com/script/Ay41FF7e-SHORT-ONLY-Internal-Bar-Strength-…/` | regole IBS short, 3 input; **sorgente NON servito nell'HTML** |
| `ar.tradingview.com/script/o9RQXXax-Vandan-V2/` | **404** |
| `papers.ssrn.com/…abstract_id=712168` | **403** |
| `forexfactory.com/forum/71-trading-systems` | **403** |
| `github.com/search?q=…` (2 tentativi) | **429**, `Retry-After: 3600` |
| `joim.com/article/nasdaq-100-index-futures-intraday-momentum-or-reversal/` | **EGRESS_BLOCKED** |
| `naaim.org/…Pagonidis_The-IBS-Effect…pdf` | **EGRESS_BLOCKED** |
| ricerche bibliografiche (Donaldson-Kim JFQA 1993, barriere psicologiche sugli indici, IBS, NQ vs ES) | citazioni con rivista/volume/pagine, tutte etichettate `[LETTO-VIA-SEARCH]` |

---

## 9. ⚖️ RIEPILOGO DEI NUMERI DELLA CACCIA

| | |
|---|---:|
| fonti col controllo positivo tentato | **10** |
| fonti vive | **5** |
| fonti murate (403 / egress) | **4** |
| fonti a quota (429, da riprovare) | **1** |
| candidati e meccanismi censiti | **~35** |
| arrivati al dato o al sorgente/regole | **4** |
| **PROVA SUBITO** | **1** (candidato A, 8/10) |
| **IN CODA** | **1** (candidato B, 7/10) |
| **SCARTI motivati** | **14 righe** |
| round risparmiati da questa caccia | **2** (ORB-straddle PS5 · momentum sulla divergenza M25) |
| giornate di Nasdaq misurate | **2.568** (solo IS: la cassaforte è intatta) |
