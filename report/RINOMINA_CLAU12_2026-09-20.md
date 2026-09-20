# 🏷️ RINOMINA `ABTG_` → `CLAU12_` — solo sul terminale FTMO

**Richiesta di Claudio, 20/09/2026**, testuale:
> _«possiamo rinominarli mettendo anziche' abtg mettere clau12 e poi il nome dell'ea.
> clau12 e' tipo un mio nickname. lo puoi fare tu in background che devo uscire.
> fallo solo sulla piattaforma ftmo su vps»_

---

## 🛑 LA COSA DA SAPERE SUBITO: **non posso eseguirla io**

Il **perimetro del runner è SOLA LETTURA** — è una firma di Claudio, non una mia cautela.
Io non ho nessun canale che scrive sul VPS: tutto quello che arriva là ci arriva perché
**lui incolla una riga in PowerShell**. Non c'è un agente sul VPS che io possa svegliare.

👉 Quindi *«fallo tu in background»* si traduce così, onestamente:
- ✅ **quello che HO fatto in background**: scritto lo script, passato il cancello
  deterministico, mandato il cancello di giudizio, misurato gli effetti collaterali,
  scritto questo referto;
- ⏳ **quello che resta a lui**: **una riga, 5 secondi**, quando rientra.

---

## ✅ PERCHÉ ADESSO È IL MOMENTO GIUSTO (e non è una cortesia, è un conto)

| quando | costo della rinomina |
|---|---|
| **ADESSO** (F7 fatti, EA non ancora attaccati, AutoTrading spento) | 🟢 rifare **7 F7**. Dieci minuti. Nient'altro |
| **Dopo l'attacco ai grafici** | 🟠 staccare 7 EA, rinominare, riattaccare, ricaricare 7 preset, riverificare |
| **Dopo la prima operazione** | 🔴 si tocca un terminale con posizioni vive. **Non si fa** |

Siamo nella finestra buona. Se la chiedeva martedì, la risposta sarebbe stata diversa.

---

## 🔍 CHE COSA CAMBIA DAVVERO — misurato, non supposto

### 🟢 Quello che NON cambia (e sono le cose che contano)

| cosa | perché non cambia |
|---|---|
| **I magic number** | `770101` `770411` `770202` `771531` `770511` `770260` `779001` stanno negli **input dei preset**, non nel nome del file |
| **Le taglie e il rischio** | `InpRiskPercent=2.00` e il cap C1 a `4.00` stanno nei `.set`. Lo script **rinomina file, punto**: non apre nessun preset |
| **Quello che vede FTMO** | 🔎 **verificato nel sorgente**: il commento degli ordini è `InpComment`, e vale `"EMA200"`, `"MAXMIN DAX SHORT"`, `"SUPERWAVE DOW H1"`. **La stringa `ABTG` non compare in nessun commento d'ordine.** Il nome del file EA **non viene trasmesso al broker**: FTMO non lo vede né prima né dopo |
| **Il comportamento di trading** | zero righe di logica toccate. Lo SHA256 di ogni file viene **riletto dopo** la rinomina per provarlo |
| **Il repo e i terminali di casa** | restano `ABTG_`. Pin, SHA e centinaia di righe di lancio cercano quel nome |

🔴 **E dico anche la cosa che NON è**: rinominare **non nasconde niente a FTMO** e non è una
misura "furba". È un nickname su un file locale. Se qualcuno te la vendesse come protezione,
ti starebbe vendendo fumo.

### 🟠 L'unico effetto collaterale, ed è cosmetico

Sei EA su sette costruiscono il nome dei CSV di diario così:

```
"abtg_trades_" + MQLInfoString(MQL_PROGRAM_NAME) + "_" + _Symbol + "_" + InpMagic + ".csv"
```

Dopo la rinomina diventeranno `abtg_trades_CLAU12_EMA200_U30USD_771531.csv`.
🟢 Il prefisso `abtg_trades_` è una **costante nel sorgente**, non deriva dal nome del file:
i nostri strumenti che cercano `abtg_trades_*` continuano a trovarli.

---

## 🚫 COSA LO SCRIPT **NON** TOCCA — elencato per nome, mai "tutto il resto"

| file | perché resta com'è |
|---|---|
| `ABTG_PausaGuardian.mqh` | 🔴 è l'**include**. Tutti e sette hanno `#include <ABTG_PausaGuardian.mqh>`: rinominarlo fa morire F7 con `cannot open include file` |
| `ABTG_PrevoloFTMO_Specifiche.mq5` | è lo **script del prevolo**, già compilato e **ancora da lanciare**. È sulla strada critica: non gli si cambia il nome adesso |
| `ABTG_*.set` (10 preset) | su MT5 il nome del preset **non deve** combaciare con quello dell'EA — si carica col pulsante **Load**. Verificato: dentro i `.set` la stringa `ABTG_` compare **solo in righe di commento** (`;`) |

---

## 🚦 IL CANCELLO HA FATTO IL SUO MESTIERE — **v1 BOCCIATA, due difetti BLOCCANTI**

Lo script è arrivato a Claudio in versione **v2**. La **v1 era rotta**, e la cosa
interessante è che il cancello deterministico era **verde**: serviva lo strato di giudizio.

| # | difetto | effetto vero | classe |
|---:|---|---|---|
| **1** | l'impronta di controllo calcolata con **** mentre gli SHA in tavola erano l'impronta **SCHELETRO** di  | 🔴 **7 file su 7 rifiutati.** Lo script sarebbe stato **inerte**, accusando i file di essere sbagliati mentre erano giusti | **484** |
| **2** | la guardia «il terminale è aperto?» confrontava  (una **cartella**) con  (un **eseguibile**) | 🔴 **non scattava mai**: stampava «CHIUSO» a MT5 spalancato | **485** |
| 3 | il ciclo che cancella e rinomina senza  e con copia **non verificata** | 🟠 interruzione a metà = eccezione rossa, nessun rendiconto | **486** |
| 4 |  non guardava il **binario orfano** | 🟠 poteva dichiarare il falso | — |
| 5 | 👁️ ** cablato su ** | 🔴 avrebbe detto «nessuna riga di EA riconosciuta» **mentre le sedie lavorano** — falso muto sulla corsia TAGLIANDO | **487** |

**Verificati con le mie mani**, non presi per buoni:

🟢 **E una cosa l'agente l'aveva dedotta male**, quindi non l'ho copiata: diceva che
 è sul terminale FTMO. **Non c'è**: la corsa è stata fatta con
, che esclude l'EA ( r.476) **e** i tre preset (r.503).

🔴 ** l'ho corretto lo stesso giorno** (), prima della prima
notte operativa. Era l'unico difetto che mordeva **dopo**, non durante.

### ✅ E l'ho provato io su un albero finto, con un'esca

Albero che riproduce il terminale FTMO (i sette file ai loro pin, gli  accanto,
, giornale col conto ) **più una cartella-esca con
l'hash del REALE  e lo stesso conto nel giornale**:

🟢 **Impronta della cartella  del REALE prima e dopo la corsa : identica.**
E al rilancio:  ×7, **codice uscita 2**. Idempotente.

---

## ⚙️ COME È FATTO LO SCRIPT — `backtest_pipeline/righe/RINOMINA_CLAU12.ps1`

**Cinque serrature.** Le prime quattro sono copiate alla lettera da `SCHIERA_FTMO.ps1`,
che su questa macchina ha già girato **due volte** senza sbagliare bersaglio:

1. `-ContoAtteso` dev'essere un numero e **non** uno dei cinque conti di casa
   (`50503392` · `50504263` · 🔴 `10105439` · `50504400` · `50503635`);
2. la cartella dati si **scopre per esclusione** delle sette note, e deve avere `origin.txt`;
3. il **giornale** (`<dati>\logs`) deve contenere il numero di conto **e** la parola FTMO;
4. zero candidate o più di una → **rifiuto**. Non si indovina;
5. 🆕 **propria di questo script**: ogni `.mq5` si rinomina **solo se il suo SHA256 combacia**
   con quello installato dallo schieramento. File diverso = non è il nostro = non si tocca.

**Più tre reti in uscita:**
- 🟢 **default = prova a vuoto.** Senza `-Esegui` stampa cosa farebbe e **non scrive niente**;
- 🟢 **si rifiuta se il terminale FTMO è aperto** (si scavalca con `-AncheSeAperto`);
- 🟢 **i `.ex5` vecchi vengono COPIATI sul Desktop prima di essere tolti**. Niente è irrecuperabile
  — e comunque un `.ex5` si rigenera con un F7.

### ❓ Perché toglie i `.ex5` — e perché è la scelta sicura

Rinominare il `.mq5` **non rinomina il binario compilato**. Se lasciassi `ABTG_EMA200.ex5`,
nel Navigatore resterebbero **due voci**: la vecchia già compilata (**attaccabile!**) e la nuova
ancora da compilare. La trappola sarebbe attaccare al grafico il binario vecchio credendo sia il nuovo.

👉 Quindi dopo lo script **il Navigatore è vuoto** finché non si rifà F7.
**È voluto: meglio vuoto che ambiguo.**

---

## ⚠️ LA TRAPPOLA DEL FUTURO, dichiarata adesso

`SCHIERA_FTMO.ps1` reinstalla i file col nome **`ABTG_`**. Se un domani lo rilanci, ti ritrovi
i **doppioni** (`ABTG_EMA200.mq5` accanto a `CLAU12_EMA200.mq5`).
👉 **Rimedio: rilanciare `RINOMINA_CLAU12.ps1` subito dopo.** Lo script lo scrive da solo in fondo
all'output, così la trappola non dipende dal fatto che qualcuno si ricordi questo referto.

---

## 📋 COSA RESTA DA FARE, in ordine

1. ⏳ **Il prevolo** — `ABTG_PrevoloFTMO_Specifiche.mq5` su un grafico → mandarmi
   `MQL5\Files\PREVOLO_FTMO_specifiche.csv`. **È il cancello della serata**: chiude S2 (orologio),
   S3 (nomi simboli), S4 (margine) e mi dà i numeri per chiudere S5 (il blocco su `771531`/`770511`).
2. 🏷️ **La rinomina** — chiudere il terminale FTMO, una riga, riaprire.
3. 🔨 **Rifare i 7 F7** sui nomi nuovi — Guardian per primo.
4. 📊 Grafici, preset, Guardian, e **solo allora** AutoTrading.

🚦 **L'AutoTrading resta spento finché non ho letto quel CSV.**
