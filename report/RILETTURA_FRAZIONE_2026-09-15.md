# 🔧 LA COLONNA DELLA FRAZIONE, RIPARATA — e le pagelle rilette con il metro giusto

**15/09/2026.** Riparazione di `backtest_pipeline/analizza_trades.py` (classe **358**) e
rilettura di **tutto lo storico**: 385 operazioni della flotta con almeno una frazione
calcolabile, **32 pagelle scritte** di cui **19 toccate** da una correzione.

---

## 0. 🔴 PRIMA DI TUTTO: LA MIA LETTURA DI IERI ERA GIUSTA NEL MECCANISMO E SBAGLIATA NELL'ENFASI

Ieri sera ho scritto che il verso pericoloso del difetto e' la **SOVRASTIMA**, perche'
*"un falso «ha preso il 77%» non lo si guarda affatto"*. Il meccanismo e' confermato — il
verso dell'errore **non e' fisso**, e adesso e' provato su 31 righe invece che su 2.
🔴 **Ma la conseguenza operativa che gli avevo attaccato NON si e' verificata.** Misurato
su tutto lo storico:

- **falsi rassicuranti** (stampavano ≥30%, il vero e' <30%): **TRE in assoluto**, e sono
  del **20/07, 24/07 e 31/07** — cioe' **prima che le pagelle esistessero** (la prima e'
  del 03/08). 🟢 **Nessuna pagella scritta ha mai portato un falso rassicurante.**
- e i tre non sono solo pochi, sono **marginali**: gli scarti valgono **6,5 · 8,1 · 9,0
  punti**, tutti sotto i 10, e tutti e tre stanno **a cavallo stretto del 30%**
  (30,7→24,1 · 30,0→21,9 · 38,7→29,7).
- e in particolare `STREV NAS H1 S 1/3` di ieri, il caso da cui sono partito: stampava
  77%, il vero e' 45% — **ma sta sopra il 30% in tutt'e due i casi**, quindi
  **l'AVVISO AUTOMATICO non sarebbe scattato ne' prima ne' dopo** (verificato nel codice:
  l'avviso `📉` guarda solo `f < 0,30`).
  🔴 **Ma «avviso automatico» non vuol dire «decisione»**, e la differenza e' misurata:
  il **31/08** la frazione ha alimentato un **giudizio in prosa** — *"`LARRY EURAUD`, che
  oggi fa +38,74 col **76% catturato**: e' la sedia…"* — citata **quattro volte** in quella
  pagella. Una colonna sbagliata non ha bisogno di far scattare un avviso per entrare in
  un ragionamento.

👉 **Il difetto vero, misurato, e' un altro e piu' grosso**: la colonna stampava
**percentuali impossibili** sulle posizioni multi-giorno. Sotto.

---

## 1. 🩺 CHE COSA ERA ROTTO, ed erano DUE cose

```
# PRIMA (sbagliata)
preso = close_price - open_price        # prezzo dell'ULTIMO deal
frazione = preso / (session_high - open_price)
```
`profit` e' **cumulativo su tutti i deal**, `close_price` e' **puntuale sull'ultimo**. Con
un parziale i due campi descrivono cose diverse.

**(a) L'errore col parziale non ha un verso fisso.** E' il segno di
`(prezzo ultimo deal − prezzo del parziale)`: se il parziale ha incassato meglio
dell'ultimo deal la colonna **sottostima**, se ha incassato peggio **sovrastima**.

**(b) 🔴 E il difetto piu' costoso non era nemmeno quello: era la finestra.**
`session_high/low` l'EA li misura **dall'ingresso alle 23:59 del giorno D'INGRESSO**. Su
una posizione multi-giorno il numeratore percorre giorni, il denominatore uno solo — e il
rapporto esplode. **Non era una teoria: la colonna ha stampato queste cose.**

---

## 2. 💥 LE PERCENTUALI IMPOSSIBILI CHE ABBIAMO PUBBLICATO

Il vecchio cancello accettava tutto fino al **300%**. Dentro le pagelle scritte ci sono
finite **quattordici frazioni sopra il 100%** (in **dodici righe** di tabella: due righe
portano due EA), di cui **undici sopra il 150%** — numeri che **non possono esistere**:
nessuno puo' prendere il 242% di quello che c'era.

| giorno | EA | stampato |
|---|---|---:|
| 2026-09-09 | `SUPERWAVE DOW H1 S 1/3` e `S 2/3` | **242%** |
| 2026-09-09 | `LARRY EURAUD S` | **231%** |
| 2026-09-09 | `EMA200 OTT L2` | **202%** |
| 2026-08-26 | `EASYTREND GBPUSD S` | **200%** |
| 2026-08-21 | `LARRY ORO L` | **198%** |
| 2026-08-18 | `EZ GBPUSD S` | **192%** |
| 2026-09-09 | `LARRY DOW S` | **178%** |
| 2026-09-01 | `SUPERWAVE DOW H1 S 1/3` e `S 2/3` | **173%** |
| 2026-08-19 | `EZ AUDJPY S` | **152%** |
| 2026-09-07 | `GAP NIKKEI S` | **148%** |
| 2026-08-25 | `EMA200 DOW S2` | **139%** |
| 2026-09-02 | `LARRY GBPUSD S` | **121%** |

🟢 **Nessuno di questi numeri ha mai fatto scattare un avviso automatico** (l'avviso guarda
solo sotto il 30%). **Ma stavano nelle pagelle**, e una pagella che stampa 242% e' una
pagella che non si puo' usare per giudicare una gestione — e, come dice il §0, un numero
non ha bisogno di un avviso per finire dentro un ragionamento.

---

## 3. 📋 LA RILETTURA, riga per riga — le **32** frazioni che cambiano, nelle **19 pagelle toccate**

| giorno | EA | simbolo | stampato | VERO | scarto | che cosa cambia |
|---|---|---|---:|---:|---:|---|
| 2026-08-03 | `Nasdaq Apertura US SELL` | NASUSD | **28%** | **56%** | +28 pt | falso allarme: era gestita meglio di come appariva |
| 2026-08-06 | `DAX Live5m v2 SELL` | D30EUR | **61%** | **48%** | −14 pt | sovrastima |
| 2026-08-11 | `STREV DOW H1 L 1/3` | U30USD | **60%** | **37%** | −23 pt | sovrastima |
| 2026-08-11 | `STREV DOW H1 L 2/3` | U30USD | **60%** | **45%** | −15 pt | sovrastima |
| 2026-08-14 | `PTE GBPUSD S` | GBPUSD | **85%** | **70%** | −15 pt | sovrastima |
| 2026-08-17 | `SUPERWAVE DOW H1 S 2/3` | U30USD | **0%** | **15%** | +15 pt | zero falso (§4) — ma **15,1% resta sotto il 30%**: l'avviso scattava prima e scatta adesso |
| 2026-08-18 | `MAXMIN DAX SHORT SELL` | D30EUR | **0%** | **26%** | +26 pt | zero falso, ma **resta sotto il 30%**: l'avviso scattava prima e scatta adesso |
| 2026-08-19 | `PTE USDJPY L` | USDJPY | **0%** | **27%** | +27 pt | zero falso, ma **resta sotto il 30%**: l'avviso scattava prima e scatta adesso |
| 2026-08-25 | `SUPERWAVE DOW H1 L 2/3` | U30USD | **0%** | **16%** | +16 pt | zero falso, ma **resta sotto il 30%**: l'avviso scattava prima e scatta adesso |
| 2026-09-07 | `GAPCONT L` | 225JPY | **0%** | **40%** | +40 pt | falso allarme: era **ben gestita** |
| 2026-09-15 | `STREV NAS H1 S 1/3` | NASUSD | **77%** | **45%** | −32 pt | sovrastima |
| 2026-08-31 | `LARRY EURAUD L` | EURAUD | **76%** | **— soppressa** | — | valore punto non stimabile (3 perdenti). 🟢 **Il numero pubblicato era GIUSTO**: con la stima a n=3 viene **76,6%**. Si perde la **copertura**, non si lascia un errore — ma quella pagella lo cita **4 volte**, una come argomento su una sedia |
| _(20 righe)_ | multi-giorno | vari | 0%–242% | **— soppressa** | — | **la banda non era il suo MFE: il numero non andava stampato** |

_Le 19 righe multi-giorno per esteso stanno in §2 (quelle sopra il 100%) e nella tabella
completa prodotta dalla rilettura._

### Il conto, su tutte le 385 operazioni della flotta
| esito | quante |
|---|---:|
| invariato (scarto < 10 punti) | **246** |
| **soppresso**: multi-giorno, la banda non e' l'MFE | **108** |
| scarto ≥ 10 punti | **18** |
| falso allarme (stampava <30%, il vero e' ≥30%) | **5** |
| 🔴 **falso rassicurante** (stampava ≥30%, il vero e' <30%) | **3** *(tutti di luglio, nessuno in una pagella)* |
| soppresso: valore punto non stimabile (`USDCHF` ×4, `EURAUD` ×1) | **5** |

📐 **Il ponte fra le due righe della tabella**: i 22 scarti grossi sono **18 che non
attraversano la soglia del 30% + 4 che la attraversano** (contati una volta sola, nella
riga del loro effetto).
📐 **E fra i 22: 14 sottostime contro 8 sovrastime.** Cioe' la colonna sbagliava **piu'
spesso verso il basso** — il contrario di quello che avevo enfatizzato ieri.

---

## 4. 🔴 UNA FRASE DEL DIARIO VA CORRETTA (17/08)

`report/DIARIO.md`, riga del **17/08**, alla lettera:
> *"Frazione catturata: `SUPERWAVE S 2/3` **0%** con **2,19 R disponibili** (entrata
> 53.648,50, minimo di sessione 53.400,50, uscita al prezzo di ingresso: il trailing sul
> Supertrend H1 non ha stretto una volta)."*

Quella frase ha **due** difetti, e sono di natura diversa.

**(a) ❌ Lo «0%» e' falso: la frazione vera e' 15,1%.** Lo zero nasceva dal confronto fra
prezzo d'ingresso e prezzo dell'**ultimo** deal, che per `S 2/3` coincidono
(53.648,30 → 53.648,30) — mentre il **parziale era gia' stato incassato**, e infatti la
posizione ha chiuso a **+9,64**. Lo stesso zero sta anche in
`report/giornata_2026-08-17.md` (r.9, r.32, r.109).

**(b) ❌ E la frase mescola DUE tranche diverse.** `entrata 53.648,50` **non e' di
`S 2/3`**: e' della gemella **`S 1/3`** (pid 3171488, 0,10 lotti, `profit 0,00`).
`S 2/3` (pid 3171490, 0,30 lotti) e' entrata a **53.648,30**, venti centesimi piu' in
basso. ⚠️ E su `S 1/3` **uno zero sarebbe stato legittimo** — ha chiuso a profitto
esattamente zero, quindi **non e' mai entrata nella colonna**, che prende solo i vincenti.
Il numero da correggere e' **solo quello di `S 2/3`**.

**(c) ✅ «il trailing non ha stretto una volta» resta vero** per tutt'e due: il runner e'
davvero tornato al prezzo d'ingresso.

👉 La conclusione di quel giorno (il parziale come imputato) **non cambia**; cambiano il
numero e l'attribuzione. E il **15,1% resta sotto il 30%**: la gestione tagliava davvero,
e l'avviso `📉` scattava allora e scatta adesso.

---

## 5. ✅ LA RIPARAZIONE, e il contro-esempio che la tiene onesta

```python
frazione = profit / (escursione_favorevole_in_punti × lotti × valore_punto)
```
Numeratore e denominatore parlano della **stessa posizione intera**, parziale compreso, e
sono tutti e due **in euro**. Piu' due cancelli nuovi:
- 🚧 **posizioni multi-giorno → nessun numero** (prima era un avviso scritto nel referto,
  adesso e' un cancello nel codice);
- 🚧 **banda di validita' 0–150%** invece di −50%–300%: sopra il 150% non e' gestione, e'
  un dato rotto.

### Il valore punto non era scritto da nessuna parte: lo stimo, e lo verifico
Non esiste nel CSV. Lo ricavo per simbolo da `profit / (delta_prezzo × lotti)` **sui soli
PERDENTI** — perche' il parziale scatta in profitto, quindi su un perdente quasi sempre
non c'e' e il rapporto torna esatto. **Mediana**, non media, con un cancello sull'IQR
(≤10%): fra i perdenti ci sono le operazioni **manuali** di Claudio, che sbandano di 250
volte e falserebbero una media.

📏 **E la tesi «sui perdenti il parziale quasi sempre non c'e'» adesso e' MISURATA, non
affermata**: su **491** perdenti usati, **21** deviano oltre il 5% dalla mediana e sono
**tutti e 21 operazioni manuali** `XAUUSD` di giugno. Sui perdenti **degli EA**: **0 su
284**. Su `D30EUR` i 65 perdenti danno `min = max = 1,0000`, cioe' **zero parziali,
esattamente**. Togliendo le manuali la mediana si sposta al massimo dell'**1,16%**.

⚠️ **E il cancello sull'IQR, onestamente, non ha escluso NIENTE**: il massimo misurato e'
**3,985%** (`225JPY`), quindi a 5%, 10%, 20% — e persino 50% — l'insieme dei simboli e'
**identico**. Le 5 frazioni soppresse lo sono **tutte per `n < 4`** (`USDCHF` n=3,
`EURAUD` n=3). L'IQR e' una **sentinella**, non una protezione attiva: e' li' per il
giorno in cui servira'.

🧪 **E IL CONTRO-ESEMPIO, che e' la ragione per cui questa stima si puo' usare.** Due
valori punto erano gia' stati misurati **prima e per altra via**: `D30EUR` **1,0000** (su
~140 trade) e `U30USD` **0,8607**. Lo stimatore non li conosce. Restituisce:

| simbolo | stimato dai soli perdenti | misurato prima, per altra via | IQR relativo |
|---|---:|---:|---:|
| `D30EUR` | **1,00000** | 1,0000 | **0,0%** |
| `U30USD` | **0,86071** | 0,8607 | **0,7%** |
| `NASUSD` | 0,86663 | 0,8607 | 1,2% |
| `XAUUSD` | 86,742 €/$/lotto | 86,37 (da 0,8637 €/$ su 0,01 lotti) | 1,6% |

**Riproduce alla quinta cifra i due numeri che non conosceva.**

🔴 **MA QUESTO CONTRO-ESEMPIO NON E' DEL TUTTO INDIPENDENTE, e va detto.** Lo `0,8607`
delle pagelle del 04-11/09 era stato ricavato da `profit/(punti × lotti)` su singole
operazioni: e' **lo stesso stimatore fatto a mano**. Riprodurlo prova che la mediana non
dipende dai casi scelti a mano — **non** prova che il metodo sia giusto.

🧪 **Il contro-esempio DAVVERO indipendente e' un altro, e passa**: lo stimatore ricava
**specifiche di contratto che nei dati non ci sono**, e tornano tutte.

| simbolo | stimato | implica | specifica ricavata |
|---|---:|---|---|
| `D30EUR` | 1,00000 | contratto 1, quotato in EUR | nessuna conversione ⇒ **esattamente 1** |
| `225JPY` | 0,05418 | 9,95 JPY/punto (via `EURJPY` ⇒ JPY/EUR 183,66) | contratto **10** |
| `USOIL` | 87,415 | EURUSD 1,1440 | **100 barili** |
| `XAUUSD` | 86,742 | EURUSD 1,1528 | **100 once** |

🧪 **E il secondo contro-esempio, che vale piu' della banda stessa**: sulle **272**
posizioni mono-giorno la frazione nuova ha massimo **96,7%** e **zero** valori sopra il
100%. Per costruzione `profit ≤ MFE × lotti × valore punto`, quindi `f ≤ 1`: se lo
stimatore o la formula fossero sbagliati, quel tetto si sfonderebbe. Non si sfonda.
_(Contro: sulle multi-giorno, se il cancello non ci fosse, **60 su 120** starebbero sopra
il 100%, fino al **2.765%**.)_

E il controllo e' scritto **dentro** lo script (`CONTROLLO_VALORI_PUNTO`): se un domani
smette di riprodurli — **o se il valore punto sparisce del tutto**, che e' il caso piu'
probabile — la pagella **stampa un avvertimento su stderr** invece di stampare frazioni
silenziosamente sbagliate.
⚠️ Con una riserva dichiarata: la tolleranza del **2%** e' larga **quanto il rumore
fisiologico**, non di piu'. `0,8607` non e' una costante, dipende da **EUR/USD**, e sui 35
perdenti di `U30USD` il rapporto oscilla fra **0,8558 e 0,8819 (±1,5%)**. Prima o poi quel
controllo gridera' per un movimento dell'euro, non per uno stimatore rotto.

---

## 6. 🛑 QUELLO CHE HO DECISO DI **NON** FARE, e perche'

**Non ho rigenerato le pagelle vecchie**, anche se il primo istinto era quello (e l'avevo
gia' fatto: 31 file riscritti, poi annullati).
🔴 **Motivo, misurato sul diff prima di consegnare**: rigenerare `giornata_2026-08-12.md`
con lo script di oggi ci stampa dentro **il saldo del 100k di OGGI** (`103.697,08` al posto
di `99.960,94`), la **peggior giornata di oggi** (−647,82 invece di −149,53) e una tabella
di freschezza datata **2026-09-15**. Sarebbe un referto del 12/08 che contiene numeri del
15/09: **un anacronismo, cioe' un falso**.
👉 Le pagelle vecchie **restano come sono**, con i loro numeri sbagliati, e **questo
referto e' l'errata**. Un file storico si corregge con una nota, non riscrivendolo.

⚠️ E un file si e' rifiutato da solo: `giornata_2026-08-21.md` ha **sei sezioni scritte a
mano fuori dal marcatore**, e il cancello anti-sovrascrittura ha bloccato la rigenerazione.
**Non ho forzato.** E' la stessa protezione nata dall'incidente in cui 487 righe scritte a
mano erano state cancellate.

---

## 7. 📋 COSA RESTA APERTO
- ⬜ **Le 108 frazioni multi-giorno restano non misurabili.** Per averle serve che l'EA
  scriva `session_high/low` **per tutta la vita della posizione**, non fino alle 23:59 del
  primo giorno. E' una modifica a `ABTG_TradeExporter`: **[da preparare, non fatta]**.
- 🔴 ⬜ **MA 26 DI QUELLE 108 NON ANDAVANO BUTTATE, e questo e' il fosso opposto.**
  Su una multi-giorno la banda del primo giorno e' un **sottoinsieme** della vita della
  posizione: il denominatore e' troppo piccolo, quindi la frazione calcolata e' un
  **LIMITE SUPERIORE** (`vera ≤ calcolata`, per costruzione). Quando quel limite e' **gia'
  sotto il 30%**, l'allarme e' **certo** — e non serve nessuna modifica all'EA per dirlo.
  **Misurate: 26 su 108** (filtro: multi-giorno con vecchia frazione < 30%), fra cui
  `LARRY GBPUSD S` del 19/08 a **9,1%** e `COST EURJPY L` del 26/08 a **28,3%**, tutte e
  due dentro pagelle scritte. 👉 **Via corta, zero tempo macchina**: stampare `≤ 9%`
  invece di `—` quando il limite superiore decide da solo. **Proposta, non fatta.**
- ⬜ **`USDCHF` e `EURAUD`**: valore punto non stimabile (meno di 4 perdenti, o dispersione
  sopra il 10%). Cinque operazioni perdono la frazione. Si chiude da se' quando arrivano
  altri perdenti.
- ⬜ **L'ora del minimo 4253,55 dell'oro del 14/09**: ancora aperta, e' l'altro esperimento
  in coda.
- 🔴 **Il difetto strutturale che questa riparazione NON tocca**: `session_high/low` danno
  **l'estremo ma non il QUANDO**. Senza l'orario dell'MFE, "la gestione ha tagliato presto"
  e "il prezzo e' tornato indietro dopo" restano indistinguibili — ed e' esattamente la
  forcella rimasta aperta sull'oro il 14/09.
