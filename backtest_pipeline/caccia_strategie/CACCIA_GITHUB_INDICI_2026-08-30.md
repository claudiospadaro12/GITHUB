# 🎯 CACCIA GITHUB — EA MT5 open-source per indici intraday (30/08/2026)

## RISULTATO IN UNA RIGA
> **Su ~30 repo visti su GitHub (topic `expert-advisor?l=mql5` + 6 ricerche), 6
> repo clonati e letti nel sorgente, PROMUOVO UNO — come SPEC, non come EA
> pronto: `CRT Turtle Soup` (Neo Malesa, MIT).** E' un motore di **sweep di
> liquidita' + reversal** (fade STRUTTURATO di una falsa rottura), che riempie
> i tre buchi veri della flotta — **laterale · short simmetrico · reversal** —
> con un meccanismo DIVERSO dai caduti (ORB/breakout/fade nudo/momentum, tutti
> chiusi). E' `grezzo` (alert-only), **non `rotto`**: zero martingala/griglia/
> repaint. La gestione (esecuzione, rischio %, flat-EOD, OnTester) la mettiamo
> noi — e' la parte che sappiamo fare.

⚠️ **Canale.** L'API GitHub di sessione e' vincolata al repo locale
(`sessions are bound to their configured repositories`) → niente `search_*`
via API. Ho lavorato con **WebSearch** (censimento) + **`git clone --depth 1`**
attraverso il proxy (funziona) + lettura del sorgente in locale con Grep/Read.
**Controllo positivo**: WebSearch restituisce titoli/URL veri (PASS); `git
clone` di un repo noto restituisce l'albero con `.mq5` e `LICENSE` (PASS).

---

## 🥇 IL PROMOSSO — `CRT Turtle Soup` (n30dyn4m1c / Neo Malesa) — **PROVA SUBITO (come SPEC), 8/10**

- **Fonte / URL**: `https://github.com/n30dyn4m1c/crt-turtlesoup-ea`
  (file `CRTTS_M15.mq5` v1.03, `CRTTS_H1.mq5`, base `crt-ts.mq5` v1.08).
  Sorgenti letti e copiati in
  `biblioteca/sorgenti/CRT_TurtleSoup_NeoMalesa_MIT/`.
- **Autore / data**: Neo Malesa (`x.com/n30dyn4m1c`), copyright 2024-2026. 21 stelle.
- **Licenza**: **MIT** — verificata nel file `LICENSE` del repo. ✅ permissiva,
  usabile con attribuzione.
- **Righe / input**: M15 = 111 righe, **2 input** (`TimeFrame`, `WickFactor=3.0`);
  base = 3 input (aggiunge il filtro `MidNotReached` e `UseWickFilter`).

### TESI IN UNA RIGA
> Quando una candela **spazza il minimo/massimo della candela precedente e poi
> RICHIUDE dentro** con un lungo wick di rifiuto (≥3x il corpo), la rottura era
> falsa (liquidita' presa): si entra nel verso opposto puntando al centro e
> all'estremo del range spazzato. **Fade STRUTTURATO, non fade nudo.**

### MECCANICA (pattern a 3 candele, `CRTTS_M15.mq5` righe 90-108)
- **Candela2** = candela range (riferimento).
- **Candela1** = falsa rottura: `l1 < l2 && c1 > c2` (bull) — buca il minimo di
  C2 e richiude sopra la sua chiusura — con `lowerWick1 > 3*body1`.
- **Candela0** = entry al suo `open`. **SL = estremo del wick di C1** (l1/h1,
  strutturale, VERO). **TP1 = punto medio di C2** `(l2+h2)/2`. **TP2 = estremo
  opposto di C2**. Il base aggiunge il gate `high(0) < 50% del range di C1`.
- **Simmetrico**: ramo bull e bear specchiati (fila il buco SHORT).
- **Decide su barre CHIUSE** (C1 e C2 chiuse; entry su open di C0): **niente
  repaint, niente look-ahead**.

### GESTIONE / BANDIERE ROSSE
- **Bandiere rosse §4: NESSUNA.** No martingala, no griglia, no averaging, no
  hedge, no DLL/WebRequest, no `iCustom` esterno (pure price action, zero
  indicatori), no repaint.
- **MA e' alert-only**: `OnTick(){}` vuoto, `OnTimer()` fa solo `Alert()`.
  **Zero `OrderSend`/`CTrade` in tutti e 7 i file** (verificato per grep). Il
  README lo dichiara: _"Alert-only by default — no auto-trading yet."_
- Manca dunque **tutta** la gestione: esecuzione ordini, rischio %, magic,
  `OnTester`, flat-EOD. **Sizing/gestione = da costruire (la nostra parte).**

### PUNTEGGIO (0-2)
- semplicita': **2** (2-3 input, indicator-free, una regola geometrica)
- il filtro E' il motore: **2** (lo sweep-reversal E' la strategia, non un cerotto)
- tesi di mercato scrivibile: **2** (una riga, sopra)
- riempie un BUCO: **2** (laterale + short simmetrico + reversal in un colpo)
- testabile senza riscritture: **0** (serve costruire l'`ABTG_CRT_TurtleSoup`;
  il pattern e' banale da tradurre, ma l'EA oggi non esiste)

### 🕳️ BUCO CHE RIEMPIE — e perche' NON e' un caduto
- **Laterale**: fade degli estremi = dove `LARRY_GBPUSD` muore (−6.445 nel 2019).
- **Short simmetrico**: ramo bear specchiato — le celle vive sono quasi tutte long.
- **Reversal in struttura** = la geometria che nei referti ha sempre pagato (R42).
- **NON e' `ABTG_LiquiditySweep` (R89, chiuso per carenza di LIVELLI, 14 trade IS)**:
  la CRT non dipende da livelli esterni, e' un pattern a 3 candele **auto-contenuto**
  → frequenza molto piu' alta (potenzialmente ~ogni barra), il difetto di R89 sparisce.
- **NON e' fade nudo** (chiuso): richiede struttura falsa-rottura + wick di
  rifiuto + gate del 50%. **NON e' ORB/breakout** (li fada, non li insegue).

### 🏛️ In ottica PROP
- **Frequenza alta su M15** → campione robusto in fretta (bene per il verdetto
  a 15-20 trade), ma anche **rischio di concentrazione giornaliera** da misurare
  (piu' segnali lo stesso giorno). Da tenere d'occhio la peggior giornata (muro
  5%), non solo il DD totale.
- **Intraday per costruzione una volta aggiunto il flat-EOD** → zero rischio
  overnight, adatto al trailing-DD delle prop.
- **Scorrelazione**: motore di reversal → dovrebbe perdere in giorni/regimi
  DIVERSI dai nostri trend-follower (SupRev, SuperWave) e dagli aperture. Da
  MISURARE la correlazione, ma la tesi e' opposta per costruzione.

### 💰 COSTO
- Nessun porting di linguaggio (e' gia' MQL5). Costo = **costruire l'EA attorno
  al pattern**: ~mezza giornata, e meta' (rischio %, SL strutturale+pavimento,
  magic, OnTester, flat-EOD) si **riusa dai nostri aperture EA**. Il nuovo vero
  e' il rilevatore del pattern a 3 candele, che sono ~15 righe.

---

## 🟡 IN CODA / SCARTO CON RISERVA — `geraked/metatrader5` (Geraked, MIT)

- **URL**: `https://github.com/geraked/metatrader5` · **MIT** verificata · 622 stelle.
  15 EA (174-352 righe l'uno) su libreria condivisa `Include/EAUtils.mqh`.
- **Il segnale piu' interessante** e' `BBRSI.mq5` (mean-reversion: RSI<30 +
  close sotto BB inferiore, poi richiusura; SL strutturale alla banda;
  simmetrico). Copiato in `biblioteca/sorgenti/geraked_metatrader5_MIT/`.
- 🔴 **Ma la GESTIONE condivisa e' §4-rossa su tre fronti, di default:**
  1. **Griglia/averaging**: `Grid=true`, `GridVolMult=1.1`, `GridMaxLvl=20` →
     `checkForGrid()` (EAUtils riga 1288) aggiunge posizioni a `lastVol*1.1`
     fino a 20 livelli per **recuperare la perdita**.
  2. **Stop virtuale**: `IgnoreSL=true` di default, e `BuyOpen` riga **111**
     `if (grid) isl = true;` → con la griglia accesa lo **SL non va al broker**.
  3. **Martingala** esplicita: `order(...)` riceve `martingale, martingaleRisk`;
     e c'e' un **account-gate** `auth(){ logins={6279587} }` (EAUtils riga 205).
- 🔴 **E il segnale e' un doppione**: BB+RSI mean-reversion ≈ `ABTG_BandFade` /
  `ABTG_MeanRevert` (gia' nostri). MA-cross degli altri EA ≈ SuperWave/SupRev.
- **Verdetto**: la gestione e' proprio cio' che butteremmo; i segnali sono
  doppioni. **Non promosso.** Si riapre SOLO se un giorno serve un secondo
  motore BB-reversion su banco vergine (scheletro gia' in biblioteca).

---

## 🔴 SCARTATI — una riga di motivo a testa

| repo | licenza | motivo dello scarto |
|---|---|---|
| `pipbolt/experts` | **Closed License** | licenza NON permissiva → fuori vincolo duro |
| `llihcchill/ICT-Imbalance-Expert-Advisor` | **NESSUN LICENSE** | senza licenza = diritti riservati; opera ma niente flat-EOD |
| `santiago-cruzlopez/MQL5` | MIT (verificata) | collezione **didattica** (RSI/MA/BB/ADX generici, include un `TSI_Martingale_EA` e roba LSTM); forex, non intraday-indici, doppioni |
| `TyphooN-/MQL5-NNFX-Risk_Management_System` | Apache 2.0 (verificata) | NNFX = **trend D1 swing forex**, non intraday indici; e' piu' risk-manager che strategia |
| `EarnForex/*` (RSI-EA, Template, PositionSizer...) | permissive | **template/attrezzi** (scheletri "crea il tuo"), non strategie con edge |
| `yulz008/GOLD_ORB` | — | **ORB** su oro → famiglia CHIUSA (~210 celle, R45 0/48) |
| `sajidmahamud835/grid-master-pro-mt5-ea` | — | **griglia** dichiarata nel nome → §4 |
| `raracraz/Golden-Strategist-EA` / `NadirAli*` | — | HFT/scalping oro M-basso + ICT 12-scenari (overfit); non indici-intraday puliti |
| `GeneralTradingSarl/expert-mt5` | non dichiarata | nessun LICENSE visibile + EA "ottimizzati" senza descrizione meccanica |

---

## 🕳️ COSA NON HO POTUTO VEDERE (dichiarato)
- **Numeri di performance**: nessun repo serio ne dichiara di credibili, e
  comunque non peserebbero (regola §7). Non misurati da noi: tutto da fondare.
- **Frequenza/edge reale della CRT sugli indici BCM**: **[INCERTO]** — il
  verdetto lo da' l'imbuto, non l'autore. Il file prova sotto congela i criteri.
- **`@DAQUANDO` degli indici BCM**: da MISURARE con `scarica_storico.ps1`
  (sugli indici il tetto ~100k barre del tester limita M15 a ~4 anni/corsa —
  regola di casa 25/08). Lasciato **vuoto** nel file prova, non inventato.
- **Profondita' del catalogo GitHub**: visto il topic top-20 per stelle + 6
  ricerche mirate; **non** ho spazzolato le pagine profonde (`o=updated`) —
  buco dichiarato, non silenziato.

---

## ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE
> Il **turtle-soup sweep-reversal** (falsa rottura + wick di rifiuto + richiusura),
> costruito come EA con rischio %, SL strutturale + pavimento (R109) e **flat-EOD**,
> ha edge su **DAX/Dow/Nasdaq M15 intraday a tick reali** — ed e' **scorrelato**
> dai nostri trend-follower e dagli aperture (perde in giorni diversi)?
> Se si': primo motore di **reversal strutturato** della flotta, che copre il
> laterale e lo short con rischio notturno zero.

---
_Sorgenti letti e archiviati: `biblioteca/sorgenti/CRT_TurtleSoup_NeoMalesa_MIT/`
(3 `.mq5` + LICENSE + README) e `biblioteca/sorgenti/geraked_metatrader5_MIT/`
(BBRSI.mq5 + LICENSE). Attribuzione da riportare in testa a qualunque `.mq5`
derivato: "Motore CRT Turtle Soup da Neo Malesa (n30dyn4m1c), MIT."_
