# 📜 CONTRATTO DELLA SEDIA — `ABTG_PostNews` ECB EURJPY, magic **771201**

**Scritto il 10/09/2026 alle 14:05 italiane, PRIMA di armarla.**
Regola di casa (referto del 07/09): *"il contratto va scritto **prima** di
riaccenderle, non dopo"*. Decisione di Claudio: **"SI, ARMIAMOLO"**.

> 🔴 **Questa non e' una promozione.** E' l'autorizzazione a **UNA misura**, su
> conto **DEMO**. La sedia resta **NON MISURATA** fino a prova contraria.

---

## 🪑 CHI E' — letto dal pannello F7 del grafico vivo, oggi
| | |
|---|---|
| conto | **DEMO piccolo 50503392** (`C:\Program Files\BCM Markets MT5 Terminal`) |
| grafico | **EURJPY M5** |
| magic | **771201** · commento ordini `ECB PostNews` |
| filtro | titolo contiene **ECB** · valuta **EUR** · impatto **>= 3** |
| calendario | `abtg_news.csv`, cartella **Common** |
| azione | **14:00 ora server = 15:00 italiane** |
| scadenza pendenti | **17:15 server = 18:15 italiane** |
| ordini | BUY STOP a max+3 pip · SELL STOP a min-3 pip · **OCO acceso** |
| stop / target | **SL 25 pip · TP 50 pip** = RR **2:1** |
| trailing | **acceso**: a +25 pip di profitto lo SL va a **+15 pip** |
| rischio | `InpRiskPercent` **1.3** con `InpRiskRefSLpips` **50** contro SL vero **25** |

---

# ✍️ IL CONTRATTO, in numeri

## 1. 💸 RISCHIO — **0,65% per evento**
Il lotto e' dimensionato su **50 pip** mentre lo stop vero e' **25**: una gamba
stoppata costa **meta'** di `InpRiskPercent`. E con **OCO acceso**, appena una
gamba si riempie **l'altra viene cancellata** → **le due gambe non si sommano**.

> 🎯 **Rischio massimo per evento: 0,65%.** E' esattamente il metro di casa
> firmato il 18/08. Contro il cap C1 (3,25% di rischio aperto) pesa il **20%**.

## 2. 📉 DRAWDOWN PROMESSO — **nessuno, ed e' dichiarato**
🔴 **Non esiste un backtest di questa sedia**: il calendario non c'e' mai stato,
e l'unica misura tentata diceva *"Trades 0"* ed e' stata ritirata. **Non posso
promettere un DD che nessuno ha misurato.**
Quello che si puo' scrivere e' il **caso peggiore aritmetico**: **0,65% per
evento**, e la BCE decide **~8 volte l'anno** → se le sbagliasse **tutte**,
~**5,2% in un anno**. Non e' una previsione: e' un tetto.

## 3. ⏱️ FREQUENZA PROMESSA — **~8 operazioni l'anno = 0,03 al giorno**
🔴 **E qui va detta la cosa scomoda: e' 33 volte sotto il pavimento di 1,00
op/giorno per famiglia.** Questa sedia, **da sola, NON e' schierabile a ottobre**
— non per il merito, per la portata. Vale come **misura di un meccanismo**, e
come mattoncino di una famiglia PostNews piu' larga (ECB + FOMC + NFP + ISM
insieme fanno ~30-40 eventi l'anno, ancora pochi).

## 4. 💰 CANCELLO DEL COSTO — ✅ **PASSA, e con margine**
| | |
|---|---|
| spread EURJPY misurato | **4 punti = 0,4 pip** (sonda del 17/08, `SpreadPt`) |
| stop | **25 pip = 250 punti** |
| **stop / spread** | **62,5x** contro i **40x** richiesti → 🟢 **+56% di margine** |

⚠️ **MA la misura e' a mercato CALMO** (17:34 del 17/08). Alle 15:00 di un giorno
di conferenza stampa BCE lo spread su EURJPY **si allarga**, e non sappiamo di
quanto. Se si allargasse **5 volte** (a 2 pip) saremmo a **12,5x**, cioe' **sotto
il pavimento duro**.
> 🎯 **E questa e' la seconda ragione per armarla oggi**: e' l'occasione per
> misurare lo **spread nell'orario del trade**, che e' la misura che ci manca su
> tutta la flotta e che il documento del collega mette al primo posto.

---

# 🔮 L'ATTESA, dichiarata PRIMA (cosi' stasera si giudica, non si racconta)

**Esiti possibili di oggi, uno solo di questi:**
1. 🟢 **TP a 50 pip** → **+2R lordo**;
2. 🟡 **trailing**: tocca +25 pip, poi torna indietro → chiude a **+15 pip = +0,6R**;
3. 🔴 **SL a 25 pip** → **−1R = −0,65%** del conto;
4. ⚪ **scadenza 18:15** senza che nessuna gamba si riempia, oppure posizione
   chiusa in pari/parziale all'orario → **~0R**;
5. ⚫ **nessun ordine piazzato** → allora **la catena non ha funzionato** e il
   difetto e' nostro, non del mercato: si va a leggere il log.

**Cosa NON promettiamo:** niente sul merito. Un evento e' **n=1**: sospende il
giudizio sul MERITO, **mai** quello sul RISCHIO (valvola R59).

**Cosa guardiamo stasera, in ordine:**
1. ha piazzato **due pendenti** alle 15:00 italiane? (se no → log)
2. **l'OCO ha cancellato la gamba opposta** appena la prima si e' riempita?
   👉 E' la stessa domanda che il documento PS5 misura con una frequenza di
   inversione del **57% sul DAX**: qui la guardiamo su un caso vero;
3. **spread al momento del riempimento** — il numero che ci manca;
4. **slippage in ingresso e in uscita**, se il `SlippageLogger` lo cattura.

---

## 🛑 CRITERIO DI USCITA (regola del 18/08, applicata da subito)
- **RISCHIO**: se il DD forward supera lo **0,65% per evento** promesso qui
  (per esempio perche' l'OCO non ha cancellato e si sono riempite tutte e due le
  gambe) → **revisione IMMEDIATA**, a qualunque n.
- **MERITO**: sospeso, si riparla a **20 operazioni** di famiglia.
- **TAGLIANDO**: 6 mesi, oppure prima se la frequenza reale scende sotto le ~8
  l'anno promesse.

## ✅ COSA SI TOCCA OGGI, e nient'altro
1. si scrive **una riga** in `Common\Files\abtg_news.csv`;
2. si fa **F7 → OK** sul grafico **EURJPY M5** (rilegge il calendario).

🚫 **NON si toccano**: EURUSD 771202 (e' la sedia **FOMC**, e condivide il magic
con un preset ECB mai caricato — vedi `DA_FIRMARE` 2-bis), USDJPY 771203, il
**100k 50504263**, il **REALE 10105439**, e nessun altro parametro.
