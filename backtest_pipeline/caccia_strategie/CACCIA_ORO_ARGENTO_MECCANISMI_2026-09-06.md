# 🥇 CACCIA ORO E ARGENTO — MECCANISMI, non parametri (06/09/2026)

**Mandato:** *"cercare motori nuovi su oro (XAUUSD) e argento (XAGUSD),
applicando la Regola della seconda caccia: MECCANISMI ALTERNATIVI sulla stessa
inefficienza, MAI parametri diversi di un motore gia' bocciato."*

---

## ⚡ IL RISULTATO IN UNA RIGA

> **Su 6 canali passati al controllo positivo (4 vivi, 2 nulli), 1.609 titoli
> del Code Base MQL5 ricrawlati (catalogo COMPLETO, 42 pagine), 8 interrogazioni
> a TradingView per 169 script, 7 all'API arXiv e 82 slug Quantpedia — sono
> arrivato al SORGENTE su 12 oggetti (4 `.mq5` nuovi + 8 Pine sui metalli) e ho
> MISURATO da solo 4 meccanismi specifici dell'oro su 594.311 barre M5 reali.**
>
> 🔴 **ZERO candidati promossi. Zero file prova nuovi. Zero EA toccati.**
> **Su ~430 configurazioni misurate col cancello congelato PRIMA, NESSUNA
> passa.** E non e' pigrizia: e' che tre dei quattro meccanismi sono
> **negativi in ENTRAMBI i versi**, che e' la firma di una zona dove si paga
> il costo e basta.
>
> 🟢 **La cosa che vale davvero di piu' e' una scoperta, e non e' un EA:**
> il lead-lag **BOND → ORO esiste ed e' vero** (t = **+4,12**, PF 1,303,
> **8 anni su 9**, e la sua falsificazione passa: il momentum dell'oro da solo
> e' morto a t = **+0,46**). **Ma vive INTERAMENTE dentro lo spread.** Con uno
> stop vero, un take vero e un costo dichiarato di 0,25 $ andata/ritorno:
> **54 celle, 0 promosse**, la migliore **+0,02 R** contro un cancello di
> +0,075 R.
>
> 🧨 **E c'e' un rilievo di processo che vale piu' di un candidato: durante
> questa caccia una sonda ha prodotto PF 2,72 · WR 76,4% · 9 anni su 9.**
> Non l'ho scritta come scoperta: l'ho trattata come **sospetto di bug**, e il
> bug c'era — **look-ahead di UNA barra M5**. Corretto, quelle stesse celle
> vanno da **+0,39 R a −0,20 R**. **Il look-ahead di una barra valeva 0,6 R
> per operazione.** Dettaglio in §7.

---

## 0. 📕 LA LISTA DEI CADUTI — riletta PRIMA di uscire

Niente di quanto segue e' stato riproposto. Verificato in
`REGISTRO_TEST.md` (1.590 righe), `SETACCIO_MANUALE.md` (912) e nei due
dossier oro precedenti (25/08 e 28/08).

| caduto | dove | verdetto misurato |
|---|---|---|
| **Alta Velocita** (Williams %R 140 + RSI 4 + target 2×ATR) | `REFERTO_ALTA_VELOCITA_V1.md` | rosso **8 su 8** ai tick reali, e rosso dopo l'iterazione. **Chiuso dal mandato stesso** |
| **R45 — ORB di sessione Londra su XAUUSD** | `REFERTO_ROUND45_LONDRA.md` | **0 celle positive su 48**. Il filtro volumi *"attenua ma non inverte mai"* |
| **`GoldLondonBreakout`** (Code Base 75586) | `SETACCIO_MANUALE.md` | *"e' LETTERALMENTE il nostro R45"*. Non si rimisura |
| **PS5 ORB-straddle su XAGUSD** | `ANALISI_STUDIO_PS5_ORB_2026-09-06.md` (fonte esterna) | l'autore stesso lo scarta: **PF 0,59 mattina / 0,84 pomeriggio**. Non riprovato |
| **Post-news sui metalli** | `CACCIA_POSTNEWS_MECCANISMI_2026-09-05.md` | 683 giornate-evento su oro: ISM **PF 0,73** (t −2,41); blocco 13:30 **PF 1,08 contro un controllo casuale a 1,11** = *peggio del caso*. **Sull'oro il controllo casuale guadagna da solo** (+0,055 R) |
| **R60 `ABTG_MeanRevert`** | `REFERTO_ROUND60_MEANREVERT.md` | **12 celle su 12** in perdita (fade a N barre senza regime) |
| **R42/R43 fade degli estremi** | `REFERTO_ROUND42_FADE.md` | **0/24 IS e 0/24 OOS**. *"e' morto il MOTORE, non la gestione"* |
| **R95 sweep + reclaim** | `R95_REFERTO.md` | **30 passate su 30** in perdita |
| **`CostToCost` XAGUSD** (sedia vera, spenta) | `PROPOSTA_REVISIONE_FLOTTA_2026-08-24.md` | **PF 0,70 · 6 anni negativi su 7 · DD 16,4%**. Spenta il 24/08 |
| **famiglia BREAKOUT / ORB** | `REGISTRO_TEST.md` §2 | **CHIUSA il 26.07.26** a tick reali, ~210 celle |
| **`XANDER Gold Recovery`, `Daily Zone Recovery`, `Quantum Gold Silver Trader`, `Gold Dust`, `Pending tread`** | `SETACCIO_MANUALE.md` 16/08 | 5 file sull'oro, **zero promossi**, quattro gravi |
| **`2-Pair Correlation EA`** (Code Base 52043) | `SWEEP_MECCANISMI_LIBERI_2026-08-22.md` §D4 | *"senza stop, e rotto"* |
| **deriva oraria oro** | `CACCIA_FREQUENZA3_ART_PAPER_2026-09-01.md` | gia' in coda: `ABTG_SondaOrologio` ha una cella XAUUSD H1, **mai girata**. Non e' terreno nuovo |

📌 **Una sola cosa NON e' un caduto ma un SOSPESO, e va detta subito:**
`KA-Gold Bot MT5` (Code Base 48251) e' **promosso 9/10 dal 25/08 e mai
costruito**. Il suo cancello e' esattamente quello che questa caccia ha
ritrovato addosso a tutto (§6).

---

## 1. 🎯 CONTROLLO POSITIVO — fonte per fonte, misurato oggi

| fonte | bersaglio noto | esito |
|---|---|---|
| **mql5.com** Code Base lista experts | titoli, autori, date | ✅ **PASSA** — 42 pagine, HTTP 200, **1.609 titoli unici** |
| **mql5.com** pagina + download sorgente | `/en/code/download/<id>/<file>.mq5` | ✅ **PASSA** — **6 `.mq5` scaricati e letti** |
| **raw.githubusercontent.com** (FutureSharks) | `XAU_USD/2015/…-6.csv` → **200, 1.649.390 byte** | ✅ **PASSA** — e' il banco di misura di tutto il dossier |
| **export.arxiv.org** API (https) | `cat:q-fin.TR` → 3 titoli veri | ✅ **PASSA** |
| **tradingview.com** `/pubscripts-suggest-json/` | `?search=gold` → 200, 29.720 byte, script veri | ✅ **PASSA** — ⚠️ **canale NUOVO rispetto ai dossier precedenti**, dove TradingView era dichiarata bloccata. **Da aggiornare in `PROMEMORIA_SBLOCCO_FONTI.md`** |
| **quantpedia.com** `/strategies/` | 82 slug veri | ✅ **PASSA** (la pagina libera; `?s=` di ricerca torna **466**) |
| **github.com/search** (UI) | repo | 🔴 **403 OGGI** — era viva il 05/09. **Non e' un 404: e' un "non adesso"**, riprovato due volte con attesa. Dichiarata **non raggiunta oggi**, non cancellata |
| **api.github.com** | `contents/` | 🔴 **403** ("sessions are bound to their configured repositories") — coerente col 05/09 |
| **forexfactory.com** | forum Trading Systems | 🔴 **403 — FONTE NULLA** (quinto dossier di fila) |

---

## 2. 🧱 IL BUCO PIU' GRANDE, E VA DETTO PRIMA DI TUTTO: **L'ARGENTO NON E' MISURABILE DA QUI**

Misurato oggi, non ipotizzato:

```
XAG_USD 2015-06: 404  (14 byte)
XAU_USD 2015-06: 200  (1.649.390 byte)
```

`XAG_USD` **non esiste** sulla fonte dati esterna (FutureSharks/Oanda). E'
un **404 vero**, non un 503: il simbolo non c'e'. Esistono invece
`USB10Y_USD`, `USB02Y_USD`, `DE10YB_EUR`, `WTICO_USD` (tutti 200) — ma
niente argento, niente platino, niente palladio, niente rame.

➡️ **Conseguenza operativa, dichiarata:** ogni meccanismo che richiede
l'argento — **spread oro/argento, ratio trading, silver-leads-gold, SMT
divergence fra i due metalli** — **NON E' MISURABILE in questo ambiente.**
Non l'ho misurato, e **non lo invento**.

E c'e' un secondo strato di scomodita' sull'argento, tutto interno:

| fatto | fonte in repo |
|---|---|
| storico BCM XAGUSD parte dal **2008.11.07** | `REFERTO_SONDA_STORICO_17-08.md` |
| ma nel weekend di fase 0 l'argento era **"non giudicabile"**: 71 trade IS contro 336 OOS | `CLASSIFICA_WEEKEND.md` |
| l'import esterno del 15/08 **ha portato XAUUSD e NON XAGUSD** → quella cella di regime e' **dichiarata scoperta** | `CELLE_REGIME.txt` |
| la sedia `CostToCost XAGUSD` e' **spenta dal 24/08**: PF 0,70, 6 anni negativi su 7 | `PROPOSTA_REVISIONE_FLOTTA_2026-08-24.md` |
| lo studio PS5 esterno scarta l'argento: *"perde a prescindere"* | `ANALISI_STUDIO_PS5_ORB_2026-09-06.md` |

**Tre fonti indipendenti** (il nostro forward, il nostro backtest, uno studio
esterno) dicono la stessa cosa sull'argento, e la quarta (la fonte dati) non
permette nemmeno di provare a smentirle. **Non ho proposto niente
sull'argento, e questo e' il motivo scritto.**

---

## 3. 🔬 IL BANCO DI MISURA — e perche' e' credibile

**Dati:** `github.com/FutureSharks/financial-data`, **GPL-3.0**, barre M1
Oanda, **fuso UTC** (collaudo dell'orologio gia' agli atti del 05/09).
Aggregate a M5 dalla sonda.

| simbolo | barre M5 | finestra |
|---|---:|---|
| `XAU_USD` | **594.311** | 2012-01-01 → 2020-05-14 |
| `USB10Y_USD` (future Treasury 10 anni) | **484.218** | 2012-01-03 → 2020-05-14 |
| `EUR_USD` (procura del dollaro) | **623.889** | 2012-01-01 → 2020-05-14 |

### ⚠️ I LIMITI, dichiarati PRIMA dei numeri e validi per ogni riga del §4

1. **NON e' BCM.** Altri orari, altri spread, altri gap. Ogni numero qui e'
   una **MISURA DI OCCASIONI**, mai un verdetto.
2. **OHLC M5, non tick.** L'ambiguita' intrabarra e' risolta **SEMPRE a
   sfavore** (se in una barra il prezzo tocca sia TP sia SL, conta lo SL).
3. **Finestra 2012-2020: NON copre il regime 2021-2026** in cui girano le
   sedie, e non copre l'oro sopra i 4.000 $.
4. 🔴 **IL COSTO E' DICHIARATO, NON MISURATO.** Uso **0,25 $ andata/ritorno**.
   **Lo spread BCM sull'oro non e' misurato in repo** — buco aperto dal 25/08
   e riconfermato il 28/08. L'unico riferimento esterno agli atti e'
   `MaxSpreadSize = 30` per XAUUSD a 2 cifre in un preset di vendor
   (`CONFIG_PROP_SPREAD_SLIPPAGE_2026-09-05.md`), cioe' **un tetto di 0,30 $**,
   non una misura. **Tutti i numeri del §4 vanno riletti col vero spread
   quando ci sara'.**
5. **Nessun look-ahead**: soglie da deviazione standard mobile sulle **500
   osservazioni gia' passate**, ingresso **all'apertura della barra
   SUCCESSIVA** a quella che genera il segnale. Su questo punto ho sbagliato
   una volta e l'ho corretto: §7.

**Sonde archiviate** in `caccia_strategie/biblioteca/sonde_esterne/`:
`scarica_oanda_m5.py` · `sonda_oro_tassi.py` · `sonda_oro_tassi_falsifica.py` ·
`sonda_oro_tassi_costo.py` · `sonda_oro_tassi_giornaliera.py` ·
`sonda_oro_tassi_R.py` · `sonda_oro_dollaro.py` · `sonda_oro_fixing_lbma.py`

---

## 4. 🧪 I QUATTRO MECCANISMI MISURATI — nessuno mai registrato prima

Verificato con `grep` su `REGISTRO_TEST.md` e `SETACCIO_MANUALE.md`:
**nessuna occorrenza di LBMA, fixing, Treasury, USB10Y, tassi reali.**
Sono quattro meccanismi **nuovi per il progetto**, non varianti di caduti.

### 🥇 M1 — ORO ← TASSI (il lead-lag col future Treasury 10 anni)

**Tesi in una riga:** *l'oro e' l'inverso del tasso reale; il mercato
obbligazionario e' piu' liquido e prezza per primo, quindi uno scatto ampio
del future Treasury dovrebbe essere seguito dall'oro nello stesso verso.*

#### 4.1 Il segnale grezzo E' REALE, e passa la sua falsificazione

Segnale: rendimento del bond su 30', |z| ≥ 2,5 contro la sd mobile a 500;
un solo evento per finestra; uscita a tempo fisso 60'; **senza costi**.

| disegno | n | media/evento | t | PF | anni + |
|---|---:|---:|---:|---:|---:|
| **A) segno dal BOND** | 3.967 | **+0,2212 $** | **+3,44** | 1,186 | 7/9 |
| B) segno dall'ORO (momentum proprio), stessi istanti | 3.967 | +0,1350 $ | +2,10 | 1,110 | 7/9 |
| 🥇 **C) bond FORTE ma oro ancora FERMO (\|z_oro\|<1)** | 2.210 | **+0,3219 $** | **+4,12** | **1,303** | **8/9** |
| 🔴 **D) SOLO momentum dell'oro, il bond non si guarda** | 5.491 | **+0,0265 $** | **+0,46** | 1,020 | 5/9 |

**Il confronto C contro D e' la prova.** Quando il bond si muove e l'oro no,
l'informazione c'e' (t = +4,12). Quando si guarda **solo** l'oro,
**non c'e' niente** (t = +0,46, PF 1,02). ➡️ **L'informazione viene davvero dal
BOND, non e' momentum dell'oro travestito.** E la controprova (l'oro guida il
bond?) da' un effetto **venti volte piu' piccolo** in ampiezza.

**E' il meccanismo meglio documentato che questa caccia abbia prodotto.**

#### 4.2 🔴 E MUORE DENTRO LO SPREAD — 54 celle, zero promosse

Stesso segnale, ma con la **geometria vera**: SL = a × ATR(60'), TP = b × SL,
tempo massimo H, ambiguita' intrabarra **a sfavore**, costo **0,25 $** A/R.
Cancello congelato prima: **R netto ≥ +0,075 · n ≥ 150 · anni positivi ≥ 7/9**.

```
  zb     a     b    H |     n   R medio     PF    WR%  anni+
 3.5  1.50  2.00   60 |   510   +0.0201  1.038   45.5   3/9   <- la MIGLIORE
 3.0  1.50  2.00   60 |  1050   -0.0218  0.960   43.2   4/9
 3.5  1.50  1.50   60 |   510   -0.0178  0.965   47.5   4/9
 2.5  0.75  1.00   60 |  2192   -0.2494  0.596   51.6   0/9   <- la peggiore
```

> ### 🚨 **54 celle. Zero passano. La migliore fa +0,02 R contro un cancello di +0,075 R, e sta positiva 3 anni su 9.**

**La lettura:** la deriva c'e' (+0,32 $ per evento) ma **vale quanto lo spread**
(0,25 $). Quel che resta viene poi mangiato dal rumore che tocca lo stop.
**Un edge che non copre il costo non e' un edge piu' piccolo: e' zero.**

#### 4.3 E su scala GIORNALIERA non c'e' proprio — 90 celle, zero

Ipotesi: allargando a un evento al giorno il movimento diventa 10-40 volte lo
spread, quindi il costo smette di contare. **Misurato: falso.**
90 configurazioni (finestra bond 6/12/24 h × ora di taglio 07/12/13/14/20 UTC
× permanenza 12/24 h × soglia 1,5/2,0/2,5): **nessuna raggiunge t = 2,0**, e
le migliori stanno **5-6 anni positivi su 9** con un anno solo che vale
fino al **111%** del totale (2012). ➡️ **Non e' un edge, e' un'epoca.**

---

### 🔴 M2 — ORO ← DOLLARO: **negativo in ENTRAMBI i versi**

La prima cosa che il mandato suggeriva. Stesso disegno C, driver `EUR_USD`.

| disegno | n | netto/evento | t | PF | anni + |
|---|---:|---:|---:|---:|---:|
| ORO ← EURUSD, **verso della tesi** (dollaro giu → oro su), \|z\|≥2,5 | 3.814 | **−0,3447 $** | **−6,31** | 0,718 | **0/9** |
| ORO ← EURUSD, **verso CONTRARIO** (falsificazione), \|z\|≥2,5 | 3.814 | **−0,1553 $** | −2,85 | 0,861 | 2/9 |
| idem, \|z\|≥3,5 | 1.229 | −0,4364 / −0,0636 | −4,07 / −0,59 | 0,682 / 0,946 | 1/9 · 4/9 |

> 🔴 **Perdono TUTTI E DUE I VERSI, su tutte le soglie.** E' la firma della
> zona dove si paga solo il costo: si entra dopo uno strappo, e da li' in poi
> il prezzo e' rumore intorno a un ingresso caro.
> **E lo dice il verso della tesi, che e' quello peggiore: 0 anni positivi su 9.**

**Confluenza (bond E dollaro concordi, oro fermo):** 9 combinazioni, la
migliore t = **+1,30**. **Non aggiunge niente al bond da solo.**
Il caso *discordi* fa t = +2,32 — **ed e' proprio la cella che NON si prende**:
una configurazione sola che sporge in mezzo a diciotto piatte e' la definizione
di picco di rumore, e su tredici Spearman IS→OOS **dodici sono negative**.

📌 **Riga da tenere: "l'oro segue il dollaro" e' vero come CORRELAZIONE e falso
come SEGNALE OPERABILE.** Con questi dati e questo costo.

---

### 🔴 M3 — L'ASTA LBMA (il "fixing" dell'oro): **72 celle, zero, e negative da entrambi i lati**

**Perche' meritava una misura:** il prezzo di riferimento mondiale dell'oro si
forma in **due aste giornaliere, alle 10:30 e alle 15:00 ora di Londra**. E'
un evento **specifico dell'oro** (non esiste sugli indici), mai comparso in
`REGISTRO_TEST.md`, e ci sono due tesi opposte plausibili: il movimento d'asta
si **riassorbe** (fade) oppure **continua**.

Disegno: si prende il movimento nei 15'/30' che chiudono nell'istante d'asta
(richiesto ≥ 0,5 × ATR per contare come "movimento d'asta"), si entra
**all'apertura della barra dopo**, SL = 1 × ATR(60'), TP = b × SL. Ora di
Londra ricostruita con la regola DST **europea**.

| asta | modo | celle | migliore R netto | anni positivi |
|---|---|---:|---:|---:|
| 10:30 Londra | FADE | 18 | −0,1817 | 3/9 |
| 10:30 Londra | CONTINUA | 18 | −0,4057 | **0/9** |
| 15:00 Londra | FADE | 18 | −0,1013 | **0/9** |
| 15:00 Londra | CONTINUA | 18 | −0,1419 | **0/9** |

> ### 🚨 **72 celle su 72 NEGATIVE. In 68 su 72 gli anni positivi sono 0 o 1 su 9.**

**Entrambi i lati perdono, di nuovo.** La finestra d'asta sull'oro, a M5, e'
una **zona di costo puro**: l'unica cosa che si compra li' e' lo spread.

⚠️ E questa e' la sonda che ha prodotto il bug del §7: **prima della correzione
diceva PF 2,721, WR 76,4%, 9 anni su 9.** Il numero vero e' quello della
tabella sopra.

---

### 🔴 M4 — Il Code Base sull'oro: **1.609 titoli, 18 in tema, 5 letti nel sorgente, ZERO promossi**

Catalogo **completo** ricrawlato oggi (42 pagine). Filtro
`gold|xau|silver|xag|metal|bullion|precious|commodit` → **18 titoli**.
Di questi, **6 gia' setacciati** (`SETACCIO_MANUALE.md` 16/08 e 22/08),
**5 famiglia `SilverTrend`** (che e' un indicatore di tendenza russo:
**l'argento non c'entra niente**, falso amico da annotare), **1 promosso
sospeso** (`KA-Gold Bot`), e **4 mai visti**, scaricati e letti oggi.

| # | file | righe | input | verdetto | la riga che lo prova |
|---|---|---:|---:|---|---|
| 1 | **`Sniper Gold Hybrid Recovery EA`** (76605, `shahrukhktk`, **26/08/2026** — piu' recente di tutte le nostre cacce) | 1.126 | **65** | 🔴🔴 **SCARTO: basket recovery** | `input double RecoveryLotMultiplier = 1.20;` + `input bool AllowDeepEmergencyRecovery = true;` + `EmergencyRecoveryDDPercent = 12.0` — **un cap interno del 12% quando il muro prop e' 10%** |
| 2 | **`XANDER Grid XAUUSD`** (71776, `09151993a`, 10/04/2026) | 405 | 21 | 🔴🔴 **SCARTO: griglia bidirezionale** | `#property description "Bidirectional Grid EA for Gold"` · `input int xs_GridStep = 390;` · `AVERAGE_TP = 0, // set shared TP on best + worst position` = **averaging dichiarato** |
| 3 | **`Quantum XAUUSD Silver Trader`** (73622, `09151993a`, 02/06/2026) | 1.455 | **79** | 🔴 **SCARTO: fattoria di manopole + doppia taratura** | `InpGoldATRMultSL = 8.0` accanto a `InpSilverATRMultSL = 2.0`: **due tarature separate cucite nello stesso file**. E' il fratello di `Quantum Gold Silver Trader` (63193), **gia' scartato il 16/08 per lo stesso motivo** |
| 4 | **`GoldWarrior02b`** (20577, Nick Bilak, edizione `barabashkakvn`) | 774 | 14 | 🔴 **SCARTO: hedge moltiplicato + iCustom non allegati + lotto fisso** | `input uchar InpMultiplier = 3; // Multiplier of hedge positions of 1st and 2nd level` · `InpLots = 0.1` fisso · handle `iCustom` di *Impulse* e *ZigZag* **non allegati** → non compila |

> ### 🧭 Correzione di mira, quarta edizione — e stavolta e' definitiva
> **Il Code Base, sull'oro, e' esaurito.** Su 1.609 titoli i metalli sono
> **18**, e di quei 18 **dodici hanno "recovery", "grid" o "quantum" nel nome o
> negli input**. Il 31/08 era gia' scritto: *"non aprire piu' il Code Base per
> cercare motori: aprirlo per gli ATTREZZI"*. **Oggi la frase e' confermata con
> il catalogo completo alla mano, e sul comparto piu' velenoso di tutti.**

---

### 🔻 Le altre fonti, per completezza

| fonte | cosa ho chiesto | resa |
|---|---|---|
| **TradingView** (8 query: `XAUUSD`, `silver`, `gold silver ratio`, `gold session`, `DXY gold`, `gold mean reversion`, `asian session gold`, `gold correlation`) | **169 script**, **113 col sorgente leggibile**, **8 strategie su metalli lette riga per riga** | 🔴 **0 promossi** — dettaglio in §4-bis |
| **arXiv q-fin** (7 query) | ~40 risultati | 🔴 **2 in tema, 0 utilizzabili**: `Turn-of-the-Year Affect in Gold Prices` (2003.11027) e' **calendario annuale** — famiglia chiusa da R63 (0/24 su 11.928 operazioni) e comunque **1 occasione l'anno**; il resto e' safe-haven/COVID e correlazioni con Bitcoin. **Su "gold intraday" arXiv ha DUE paper in tutto, nessuno operabile** |
| **Quantpedia** (pagina libera) | 82 slug | 🔴 **5 su materie prime** (momentum, skewness, term structure, return asymmetry, dollar carry) — **tutti su panieri di futures con roll mensile**: non traducibili su un CFD singolo. **Zero specifici sull'oro** |
| **Forex Factory** | Trading Systems | 🔴 **403 — fonte nulla** |
| **GitHub UI** | repo oro | 🟡 **403 oggi** (viva il 05/09) — **non raggiunta**, non cancellata |

---

## 4-bis. 🌲 LE OTTO STRATEGIE PINE SUI METALLI — lette nel sorgente, zero promosse

⚠️ **Autocorrezione, e la scrivo perche' vale piu' dello scarto.** A meta'
caccia avevo concluso che TradingView *"non da' il codice"*, perche' il campo
`scriptSource` era vuoto in **164 script su 169**. **Era falso**, e la
procedura giusta stava gia' scritta in `PROMEMORIA_SBLOCCO_FONTI.md` §2-A dal
28/08: si legge il campo **`access`** e poi si scarica da **`pine-facade`**.
Rimisurato: **113 script su 169 hanno il sorgente leggibile (67%, non il 3%).**
Ho ripreso e letto le otto strategie sui metalli. *Il campo che dice la verita'
e' `access`, non `scriptSource`.*

| # | script / autore | righe | input | verdetto | la riga che lo prova |
|---|---|---:|---:|---|---|
| 1 | **`Silver Long/Short`** · @tyler747 | 54 | 13 | 🔴 **SCARTO** — ed e' **l'oggetto piu' in tema di tutta la caccia**: e' *letteralmente* il gold/silver ratio | `default_qty_type=strategy.percent_of_equity, default_qty_value=100` = **100% dell'equity per operazione**; **nessuno stop loss** (si esce solo su `strategy.close_all()` al segnale opposto); soglie `overbought=60 / oversold=45` **cablate sull'epoca 2000-2020** — il GSR ha toccato **125 nel marzo 2020** |
| 2 | **`SILVER Midnight Candle Color Strategy`** · @Rendon1 | 35 | **0** | 🔴 **SCARTO** — e lo **zero input non e' semplicita': e' overfitting cablato** | `limit=close + 57*mintick, stop=close - 200*mintick` (long) e `limit=close - 48*mintick, stop=close + 200*mintick` (short): **TP 57 contro SL 200**, e **57 long / 48 short**. Rischio/rendimento **1 : 0,285**, con due costanti asimmetriche scritte a mano. Piu' `nyHour(hour) => (hour-5) % 24` = **UTC-5 fisso, zero DST**, ammesso dal commento dell'autore |
| 3 | **`XAG strategy 1h`** · @SoftKill21 · **MPL-2.0** | 78 | 23 | 🔴🔴 **SCARTO: E' ROTTO** | `strategy.entry("long", 1, when=short1)` e `strategy.entry("short", 0, when=long1)` — **il secondo argomento in Pine v4 e' il bool `long`**, quindi i nomi sono invertiti rispetto alle condizioni. **E' lo stesso identico difetto gia' verbalizzato il 28/08** (*"funziona per caso, come la riga 266 del KA-Gold"*). In piu' **tutte le uscite sono commentate** (righe 66-77): resta un `strategy.close_all()` incondizionato, **nessuno stop** |
| 4 | **`Aurum DCX AVE Gold and Silver Strategy`** · @exlux | 164 | **28** | 🔴 **SCARTO: fattoria di manopole** — ed e' il **meglio scritto** del lotto | ✅ da riconoscere: **tutti e sei i `request.security` hanno `lookahead=barmerge.lookahead_off`**, e ha SL/TP veri piu' trailing. 🔴 Ma sono **28 input** contro il tetto di ~15 e **cinque filtri impilati** (DCX+ADX, inviluppo adattivo, VWAP giornaliera, bias **DXY**, ATR settimanale): e' l'architettura "filtro appiccicato al motore", **0 successi su 5** da noi. E il bias DXY e' proprio cio' che il §M2 misura **negativo in entrambi i versi** |
| 5 | **`Gold/Silver 30m Only Strategy`** · @MtxTrader | 32 | 5 | 🔴🔴 **SCARTO: E' ROTTO** | l'uscita short e' `when = vrsi > RSIOverBought and close > ema(close,162)` — **la stessa condizione RSI dell'uscita long**: lo short non esce mai sulla propria logica. E l'ingresso short usa `vrsi > RSIOverSold` (**35**, non 65): vero quasi sempre. Le **Bollinger sono calcolate e mai usate**. `ema(close, 162)` = costante tarata. **Nessuno stop** |
| 6 | **`Gold Asia Session Breakout`** · @bradenstrock | 120 | 14 | 🔴 **SCARTO: doppione + repaint** | `calc_on_every_tick=true` (bandiera rossa §4) e la meccanica e' **ORB di sessione sull'oro** = famiglia **chiusa il 26.07.26** (~210 celle) e **R45, 0 celle positive su 48** proprio su XAUUSD |
| 7 | **`Silver Risk Management outperformed Buy & Hold`** · @CuriousMacroX | 201 | 28 | 🔴 **SCARTO** | 28 input, `calc_on_every_tick`, e **un solo `strategy.close`**: e' uno studio di *position sizing* contro buy&hold, **non un motore di ingresso**. Il titolo dichiara il confronto col buy&hold, che non e' il nostro metro |
| 8 | **`Gold/Silver Spread`** · @MarcoValente | 13 | 4 | 🔴 **SCARTO: nessun ingresso** (e' uno `study`) — **ma vale come TRAPPOLA da annotare** | `spr = (au - ag)` con `au=XAUUSD` e `ag=XAGUSD`. Con oro a ~2.000 e argento a ~25, **la differenza e' oro al 98,7%**: quello che il grafico chiama "spread" **e' il prezzo dell'oro**. L'oggetto giusto e' il **RAPPORTO** `au/ag`, non la differenza. Chi costruisse un motore su questo indicatore misurerebbe l'oro credendo di misurare la relazione fra i due metalli |

> ### 🧭 Cosa dice il lotto, messo in fila
> **Su otto strategie sui metalli lette riga per riga: due sono ROTTE**
> (ingressi invertiti, uscite che non escono), **quattro non hanno stop loss**,
> **due hanno oltre 28 input**, **una dimensiona al 100% dell'equity**, e
> l'unica che tocca davvero la tesi del gold/silver ratio (`Silver Long/Short`)
> le colleziona quasi tutte insieme.
>
> 🎯 **E il rilievo che conta per il futuro: la tesi del RAPPORTO ORO/ARGENTO
> esiste sul serio come idea, ma non ne esiste UNA implementazione sana.**
> Se un giorno la si vuole provare, **la si scrive da zero** — e prima serve
> l'argento, che da qui non si misura (§2).

---

## 5. 📊 IL BILANCIO — la tabella degli scartati e il conto delle celle

| famiglia | oggetti / celle | promossi | motivo dominante |
|---|---:|---:|---|
| Code Base MQL5 (metalli) | 1.609 titoli → 18 in tema → **4 sorgenti nuovi letti** | **0** | recovery/griglia (2), fattoria di manopole + doppia taratura (1), hedge×3 + iCustom mancanti + lotto fisso (1) |
| TradingView | **169 script**, 113 leggibili, **8 strategie metalli lette** | **0** | 2 **rotte** (ingressi invertiti / uscite che non escono), 4 **senza stop**, 2 con **28+ input**, 1 al **100% dell'equity**, 1 doppione ORB con `calc_on_every_tick` |
| arXiv q-fin | **7 query** | **0** | niente sull'oro intraday |
| Quantpedia | **82 slug** | **0** | panieri di futures con roll, non traducibili |
| **M1 oro←tassi, geometria vera** | **54 celle** | **0** | miglior R netto **+0,02** contro cancello +0,075; **3 anni positivi su 9** |
| **M1 oro←tassi, scala giornaliera** | **90 celle** | **0** | nessuna a t≥2,0; un anno vale fino al **111%** del totale |
| **M1 oro←tassi, sweep a tempo fisso** | **192 celle** | **0** | positive al lordo, sotto il cancello al netto |
| **M2 oro←dollaro** | **19 celle** | **0** | **negativo in entrambi i versi**, 0/9 anni nel verso della tesi |
| **M3 asta LBMA** | **72 celle** | **0** | **72 su 72 negative**, entrambi i lati |
| **TOTALE misurato** | **~430 configurazioni** | 🔴 **0** | — |

### I tre motivi ricorrenti, in ordine

1. 🥇 **IL COSTO.** Tre meccanismi su quattro producono una deriva **piu'
   piccola dello spread**. Sull'oro il costo non e' un dettaglio di
   rifinitura: **e' il motore che decide**.
2. 🥈 **ENTRAMBI I LATI PERDONO.** In M2 e in M3 non e' che abbiamo scelto il
   verso sbagliato: **perdono tutti e due**. Quando succede, non c'e' un
   parametro da girare — c'e' una **zona da evitare**.
3. 🥉 **IL CODE BASE SULL'ORO E' UN NEGOZIO DI MARTINGALE.** Dodici titoli su
   diciotto lo dichiarano negli input.

---

## 6. 🚪 IL CANCELLO CHE BLOCCA TUTTO, E VA APERTO PRIMA DEL PROSSIMO CANDIDATO

> ### 🔴 **LO SPREAD BCM SULL'ORO NON E' MAI STATO MISURATO.**

Non e' una scoperta mia: e' scritto nel dossier del **28/08**, dove blocca
`KA-Gold Bot` (*"il suo cancello zero e' ancora aperto: lo spread BCM
sull'oro NON E' MISURATO IN REPO"*). **Sono dodici giorni.**

Questa caccia lo ha ritrovato addosso a **tutto**:

- il lead-lag bond→oro sopravvive o muore **a seconda di quel numero**: a
  0,00 $ fa PF 1,303 e **8 anni su 9**; a 0,25 $ fa **+0,02 R**; a 0,35 $ e'
  **PF 0,906 e 2 anni su 9**;
- lo strumento per misurarlo esiste, e' gratuito ed e' **gia' promosso dal
  23/08**: `RealCost Spread P95 Logger MT5`, [Code Base 74148](https://www.mql5.com/en/code/74148) — **e non e' mai stato usato**;
- l'unico riferimento agli atti e' un **tetto di vendor** (`MaxSpreadSize=30`
  = 0,30 $ su oro a 2 cifre), che non e' una misura del nostro broker.

> 🎯 **Raccomandazione, ed e' l'unica cosa operativa che questa caccia
> produce:** prima di costruire QUALSIASI EA sull'oro — compreso il
> `KA-Gold Bot` che aspetta dal 25/08 — **si accende il logger e si misura
> lo spread orario dell'oro su BCM, mediana e P95 in sessione.** E' una
> giornata di raccolta, e decide se lo scaffale oro intraday esiste o no.
>
> **Senza quel numero, ogni sweep sull'oro misura la fortuna, non l'edge.**

### 🏛️ In ottica prop — la riga che serve comunque

Anche nell'ipotesi piu' generosa (spread 0,10 $), il lead-lag bond→oro farebbe
**~260 operazioni l'anno** con attesa intorno a **+0,10 R**. A 0,65% per
operazione sono **~1 trade al giorno** su un simbolo dove **non abbiamo
nessuna sedia intraday viva**, quindi **scorrelato per costruzione** dalle
aperture DAX/Dow e dagli swing SupRev. 🟢 **Il posto nel portafoglio ci
sarebbe.** 🔴 **L'edge no.** E il secondo problema e' che il segnale arriva
**a grappoli attorno ai dati macro USA** (§ ora UTC: 12:00-14:00 concentra
2.662 eventi su 7.254): **e' esattamente il rischio giornaliero che il muro
del 5% punisce**, non un edge diversificato.

---

## 7. 🧨 IL RILIEVO DI PROCESSO — un look-ahead da 0,6 R, preso al volo

**Come e' andata, per intero, perche' vale piu' del meccanismo.**

La sonda dell'asta LBMA, alla prima esecuzione, ha stampato questo:

```
POMERIGGIO 15:00 Londra
  finestra 15'  CONTINUA  TP=1.0xSL  H=30'   n=1365  R=+0.3930  t=+18.49  PF=2.721  WR=76.4%  anni+=9/9
```

**PF 2,72 · win rate 76,4% · nove anni su nove.** Su un progetto con
**trenta ribaltamenti** agli atti, quello non e' un risultato: **e' un
allarme.** Non l'ho scritto come scoperta — ho cercato il bug.

Il bug era una riga:

```python
def simula(e, verso, sl_d, tp_d, H):
    px = OO[e]           # <- ingresso all'APERTURA della barra e
...
mov = CL[j] - CL[j-PRE]  # <- segnale dalla CHIUSURA della barra j
r = simula(j, ...)       # <- e chiamo con e = j
```

**Il segnale usa la chiusura della barra `j`, e l'ingresso avviene
all'apertura della STESSA barra `j`.** Cioe' si compra prima di sapere una
cosa che si sa solo dopo. **Look-ahead di una barra M5.** (La sonda gemella
sui tassi era scritta bene: `e = i0 + 1`.)

Corretto a `e = j + 1`, **le stesse identiche celle**:

| cella | prima (con look-ahead) | dopo (corretta) |
|---|---:|---:|
| 15:00 Londra, CONTINUA, TP=1×SL, H=30' | **R +0,3930 · PF 2,721 · WR 76,4% · 9/9** | **R −0,2043 · PF 0,638 · WR 45,8% · 0/9** |

> ### 🚨 **Una barra M5 di look-ahead valeva 0,60 R per operazione, e trasformava una zona di puro costo nella migliore strategia del dossier.**

📌 **Tre cose da portare in casa:**
1. **La regola che ha funzionato e' "un numero troppo bello e' un sospetto,
   non una scoperta".** Va scritta e va usata sempre.
2. **Il segno di riconoscimento e' la SIMMETRIA innaturale**: con il bug,
   `CONTINUA` faceva +0,39 R e `FADE` −0,73 R sugli stessi eventi. Due lati
   che si specchiano cosi' bene attorno alla barra d'ingresso **stanno
   misurando la barra d'ingresso**, non il mercato.
3. Vale anche all'incontrario: **la sonda corretta dice che li' si perde in
   tutti e due i versi**, e quella e' l'informazione vera.

---

## 8. ❓ LA DOMANDA A CUI IL PROSSIMO PASSO DEVE RISPONDERE

> ### **"Quanto costa davvero un'operazione sull'oro su BCM — mediana e P95 orari, in dollari, nella fascia in cui opereremmo?"**

Non e' una domanda di ripiego. E' **la variabile che ribalta il verdetto** di
tutto quello che sta in questo dossier, e blocca da dodici giorni un candidato
gia' promosso 9/10. Ha uno strumento pronto e gratuito
(`RealCost Spread P95 Logger`, Code Base 74148, promosso il 23/08), costa una
giornata di raccolta e **non richiede di scrivere una riga di EA**.

Sotto quel numero:
- **spread ≤ 0,10 $** → il lead-lag bond→oro torna misurabile e merita un round vero;
- **spread ≥ 0,30 $** → **lo scaffale dell'oro intraday si chiude**, e con esso
  `KA-Gold Bot`, e lo si scrive una volta per tutte.

**In entrambi i casi si smette di indovinare.**

---

## 9. 🚧 COSA NON HO POTUTO VEDERE — dichiarato, non taciuto

| buco | perche' |
|---|---|
| 🔴 **Tutto l'argento come meccanismo** | `XAG_USD` **404 vero** sulla fonte dati esterna. Spread oro/argento, ratio trading, SMT fra metalli: **non misurabili da qui**. Non li ho misurati e **non li ho inventati** |
| 🔴 **Il regime 2021-2026** | i dati esterni finiscono il **2020-05-14**. Nessuna misura sull'oro sopra i 2.000 $, figurarsi sopra i 4.000. **La finestra non copre il mercato in cui giriamo** |
| 🔴 **Lo spread vero** | §6. Ogni numero e' al netto di un costo **dichiarato**, non misurato |
| 🟡 **GitHub UI** | 403 oggi (viva il 05/09). Riprovata due volte con attesa crescente. **Non raggiunta**, non cancellata dal catalogo |
| 🟡 **56 script TradingView su 169** | `access` ≠ 1 = **sorgente protetto**. Titolo e autore verificati, il codice no — e per regola di casa un titolo non e' un candidato. ⚠️ Degli altri 113 leggibili ho letto **le 8 strategie sui metalli**, non i 105 indicatori |
| 🧨 **un mio errore di canale, corretto in giornata** | avevo dedotto *"TradingView non da' il codice"* da **un campo vuoto** (`scriptSource`) invece di leggere la procedura gia' in repo dal 28/08 (`access` + `pine-facade`). Sbagliavo di **113 sorgenti contro 5**. Corretto in `PROMEMORIA_SBLOCCO_FONTI.md` e sanato dentro questa stessa caccia (§4-bis) |
| 🟡 **`Sniper Gold Hybrid Recovery`, 65 input** | letto negli input e nell'header, **non riga per riga in tutte le 1.126 righe**. Le bandiere rosse trovate bastavano allo scarto: non ho speso altro tempo su un basket recovery |

---

## 10. 📎 FONTI, VERIFICATE UNA PER UNA

**Aperte oggi (HTTP 200, contenuto letto):**
- `https://www.mql5.com/en/code/mt5/experts/page1` … `page42` — catalogo completo, 1.609 titoli
- `https://www.mql5.com/en/code/76605` + `/download/76605/Sniper_Gold_Hybrid_Recovery_EA.mq5` — 38.415 byte
- `https://www.mql5.com/en/code/71776` + `/download/71776/XANDER_Grid_XAUUSD.mq5` — 18.394 byte
- `https://www.mql5.com/en/code/73622` + `/download/73622/Quantum_XAUUSD_Silver_Trader.mq5` — 56.453 byte
- `https://www.mql5.com/en/code/20577` + `/download/20577/goldwarrior02b.mq5` — 64.610 byte
- `https://www.mql5.com/en/code/48251` (`KA-Gold Bot`) e `52043` (`2-Pair Correlation`) — **gia' setacciati, riaperti solo per confermare l'identita'**
- `https://www.tradingview.com/pubscripts-suggest-json/?search=...` — 8 interrogazioni
- `https://export.arxiv.org/api/query?...` — 7 interrogazioni
- `https://quantpedia.com/strategies/` — 82 slug
- `https://raw.githubusercontent.com/FutureSharks/financial-data/master/pyfinancialdata/data/currencies/oanda/{XAU_USD,USB10Y_USD,EUR_USD}/...` — **303 file mensili M1** (GPL-3.0)

**Fonti NULLE dichiarate oggi:** `forexfactory.com` (403) · `api.github.com`
(403) · `github.com/search` (403 **oggi**, viva il 05/09) ·
`quantpedia.com/?s=` (466).

**Autori citati, come da pagina:** shahrukhktk (76605) · 09151993a (71776,
73622) · Nick Bilak / barabashkakvn (20577) · hungtthanh (48251) ·
sasan31 (52043) · FutureSharks (dati, GPL-3.0).

---

## 11. ✅ COSA HO TOCCATO

- **Creato:** questo dossier + **8 sonde** in `biblioteca/sonde_esterne/`
- **NON toccato:** nessun EA, nessun preset, nessuna sedia, nessun file prova
  esistente. **Nessun backtest lanciato.**
- **Nessun file prova nuovo**, perche' **non c'e' un candidato**. Scriverne uno
  per non tornare a mani vuote sarebbe il modo migliore di bruciare il tempo
  di Claudio.
