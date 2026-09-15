# 🔧 LA COLONNA DELLA FRAZIONE, RIPARATA — e le pagelle rilette con il metro giusto

**15/09/2026.** Riparazione di `backtest_pipeline/analizza_trades.py` (classe **358**) e
rilettura di **tutto lo storico**: 385 operazioni della flotta con almeno una frazione
calcolabile, 19 giornate con una pagella gia' scritta.

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
- e in particolare `STREV NAS H1 S 1/3` di ieri, il caso da cui sono partito: stampava
  77%, il vero e' 45% — **ma sta sopra il 30% in tutt'e due i casi**, quindi l'avviso
  *"gestione che taglia"* **non sarebbe scattato ne' prima ne' dopo**. Il numero era
  sbagliato di 32 punti; la **decisione** che ne dipendeva, no.

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
finite **dodici frazioni sopra il 100%** — numeri che **non possono esistere**: nessuno
puo' prendere il 242% di quello che c'era.

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

🟢 **Nessuno di questi numeri ha mai fatto scattare un avviso** (l'avviso guarda solo sotto
il 30%), quindi non hanno prodotto decisioni sbagliate. **Ma stavano nelle pagelle**, e una
pagella che stampa 242% e' una pagella che non si puo' usare per giudicare una gestione.

---

## 3. 📋 LA RILETTURA, riga per riga — le 31 frazioni che cambiano nelle 19 pagelle scritte

| giorno | EA | simbolo | stampato | VERO | scarto | che cosa cambia |
|---|---|---|---:|---:|---:|---|
| 2026-08-03 | `Nasdaq Apertura US SELL` | NASUSD | **28%** | **56%** | +28 pt | falso allarme: era gestita meglio di come appariva |
| 2026-08-06 | `DAX Live5m v2 SELL` | D30EUR | **61%** | **48%** | −14 pt | sovrastima |
| 2026-08-11 | `STREV DOW H1 L 1/3` | U30USD | **60%** | **37%** | −23 pt | sovrastima |
| 2026-08-11 | `STREV DOW H1 L 2/3` | U30USD | **60%** | **45%** | −15 pt | sovrastima |
| 2026-08-14 | `PTE GBPUSD S` | GBPUSD | **85%** | **70%** | −15 pt | sovrastima |
| 2026-08-17 | `SUPERWAVE DOW H1 S 2/3` | U30USD | **0%** | **15%** | +15 pt | 🔴 **falso allarme, e tocca una frase del diario** (§4) |
| 2026-08-18 | `MAXMIN DAX SHORT SELL` | D30EUR | **0%** | **26%** | +26 pt | falso allarme |
| 2026-08-19 | `PTE USDJPY L` | USDJPY | **0%** | **27%** | +27 pt | falso allarme |
| 2026-08-25 | `SUPERWAVE DOW H1 L 2/3` | U30USD | **0%** | **16%** | +16 pt | falso allarme |
| 2026-09-07 | `GAPCONT L` | 225JPY | **0%** | **40%** | +40 pt | falso allarme: era **ben gestita** |
| 2026-09-15 | `STREV NAS H1 S 1/3` | NASUSD | **77%** | **45%** | −32 pt | sovrastima |
| _(19 righe)_ | multi-giorno | vari | 0%–242% | **— soppressa** | — | **la banda non era il suo MFE: il numero non andava stampato** |

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

📐 **Fra i 22 scarti grossi: 14 sottostime e 8 sovrastime.** Cioe' la colonna sbagliava
**piu' spesso verso il basso** — il contrario di quello che avevo enfatizzato ieri.

---

## 4. 🔴 UNA FRASE DEL DIARIO VA CORRETTA (17/08)

Il diario del **17/08** scrive:
> *"Frazione catturata: `SUPERWAVE S 2/3` **0%** con **2,19 R disponibili** (entrata
> 53.648,50, minimo di sessione 53.400,50, uscita al prezzo di ingresso: il trailing sul
> Supertrend H1 non ha stretto una volta)."*

- ❌ **«0%» e' falso**: la frazione vera e' **15%**. Lo zero nasceva dal confronto fra
  prezzo d'ingresso e prezzo dell'**ultimo** deal, che coincidono — mentre il **parziale
  era gia' stato incassato**.
- ✅ **«il trailing non ha stretto una volta» resta vero**: il runner e' davvero tornato al
  prezzo d'ingresso, ed e' un fatto indipendente dalla frazione.
👉 La conclusione di quel giorno (il parziale come imputato) **non cambia**; cambia il
numero con cui era stata scritta. E il 15% resta **sotto il 30%**: la gestione tagliava
davvero.

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

🧪 **E IL CONTRO-ESEMPIO, che e' la ragione per cui questa stima si puo' usare.** Due
valori punto erano gia' stati misurati **prima e per altra via**: `D30EUR` **1,0000** (su
~140 trade) e `U30USD` **0,8607**. Lo stimatore non li conosce. Restituisce:

| simbolo | stimato dai soli perdenti | misurato prima, per altra via | IQR relativo |
|---|---:|---:|---:|
| `D30EUR` | **1,00000** | 1,0000 | **0,0%** |
| `U30USD` | **0,86071** | 0,8607 | **0,7%** |
| `NASUSD` | 0,86663 | 0,8607 | 1,2% |
| `XAUUSD` | 86,742 €/$/lotto | 86,37 (da 0,8637 €/$ su 0,01 lotti) | 1,6% |

**Riproduce alla quinta cifra i due numeri che non conosceva.** E il controllo e' scritto
**dentro** lo script (`CONTROLLO_VALORI_PUNTO`): se un domani smette di riprodurli, la
pagella **stampa un avvertimento su stderr** invece di stampare frazioni silenziosamente
sbagliate.

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
- ⬜ **`USDCHF` e `EURAUD`**: valore punto non stimabile (meno di 4 perdenti, o dispersione
  sopra il 10%). Cinque operazioni perdono la frazione. Si chiude da se' quando arrivano
  altri perdenti.
- ⬜ **L'ora del minimo 4253,55 dell'oro del 14/09**: ancora aperta, e' l'altro esperimento
  in coda.
- 🔴 **Il difetto strutturale che questa riparazione NON tocca**: `session_high/low` danno
  **l'estremo ma non il QUANDO**. Senza l'orario dell'MFE, "la gestione ha tagliato presto"
  e "il prezzo e' tornato indietro dopo" restano indistinguibili — ed e' esattamente la
  forcella rimasta aperta sull'oro il 14/09.
