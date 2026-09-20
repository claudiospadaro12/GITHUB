# 🔢 LE 2.000 RICHIESTE — **LA MISURA**, non piu' la stima

> **Referto gemello e precedente**: `report/LE_2000_RICHIESTE_2026-09-20.md` (592 righe,
> il CENSIMENTO SUL CODICE, chiamata per chiamata, dai pin schierati).
> Quello **stimava**. Questo **conta**. E in tre punti su quattro **il conto smentisce la
> stima** — a nostro favore, ma la ragione conta piu' del verdetto.

**Fonte primaria**: `RICHIESTE_SERVER_50503392_2026-09-20_2131.zip` → `referto.txt`,
prodotto da `backtest_pipeline/righe/CONTA_RICHIESTE_SERVER.ps1` (pin `7ad081db`, 6 PASS
al cancello) lanciato da Claudio sul VPS sul **giornale del BCM piccolo `50503392`**
(`C:\Program Files\BCM Markets MT5 Terminal`, hash dati `215D85D767A1C39E22D242C8114BF9F5`).
**210.570 righe di giornale lette, 191 giornate.**
**Fonte secondaria** (per l'attribuzione): `data/statements/trades_auto.csv`, 1.322 trade.

---

## ⓪ 🎯 LA RISPOSTA IN QUATTRO RIGHE

1. 🟢 **Su 191 giornate vere, 189 stanno sotto — e larghissimo: mediana ~20 richieste,
   massimo 563 (28% della soglia).**
2. 🔴 **UNA giornata ha sfondato di 27 volte: il 10/04/2026, 54.508 richieste.**
3. 🟢 **E ha un colpevole col nome e cognome, e NON e' una delle sei sedie FTMO**: magic
   **`20250001` `BULGE_MULTI_SIGNAL_VIOLA_S`**, su **CADJPY e NZDJPY**. Nessuno dei due
   simboli, e nessun EA con quel magic, e' schierato su FTMO.
4. 🟢 **Il rubinetto che temevamo di piu' — `770411`, il trailing sul bid vivo — E'
   ASSOLTO DALLA MISURA**: nelle quattro giornate in cui ha tenuto una posizione sul DAX,
   **tutto il conto insieme** ha fatto 75 / 117 / 43 / 30 richieste. La previsione era
   «da 2.600 a 26.000». **Non e' successo, e adesso si sa anche perche'.**

🪑 **Tradotto in sedie schierabili il 1° ottobre: la Forbidden Practice delle 2.000
richieste NON e' un ostacolo per la challenge FTMO. Nessuna sedia va spenta, nessun
parametro va cambiato per questo motivo.**

---

## ① 📊 IL CONTO, GIORNATA PER GIORNATA

| | giornate | ESITI |
|---|---:|---:|
| 🟢 sotto soglia | **189 su 191** | mediana ~20, massimo **563** |
| 🟠 oltre meta' soglia | **1** (14/04/2026) | **1.171** (59%) |
| 🔴 **SFONDATA** | **1** (10/04/2026) | **54.508** (2.725%) |

Le colonne, come le definisce lo script:
- **ESITI** = una riga per richiesta andata al server (done/failed) — **e' la colonna che
  conta per FTMO**;
- **RETE** = con `done in <n> ms`: **il giro di rete e' DIMOSTRATO**;
- **FALLITI** = esito negativo. Senza tempo di rete puo' essere un **rifiuto LOCALE** del
  terminale, che al server non arriva.

---

## ② 🕵️ LA GIORNATA CHE HA SFONDATO — attribuita per NOME

### Quello che dice il giornale (referto, §DETTAGLIO)
| | |
|---|---|
| tipo di operazione | **`MODIFY` (PositionModify): 54.473 su 54.508 = 99,94%** |
| ora (LOCALE del PC) | **16:00 → 53.532** · 17:00 → 902 · tutte le altre ≤ 24 |
| simboli | **NZDJPY 27.349** · **CADJPY 27.027** · NZDCAD 74 · AUDUSD 21 · USDCAD 17 |

### Quello che dice lo storico dei trade — **e qui si chiude il cerchio**
Il giornale e' in **ora locale del PC** (regola di casa: log = ora italiana, grafico = ora
server). **Ora locale 16:00 = ora server 15:00.** Alle **15:00:00 server** del 10/04/2026,
`trades_auto.csv` dice che si sono aperte **cinque posizioni in un colpo solo**, tutte dello
stesso magic:

| apertura (server) | chiusura | simbolo | magic | strategia | richieste nell'ora |
|---|---|---|---:|---|---:|
| 2026.04.10 15:00:00 | 15:57:32 | **CADJPY** | `20250001` | `BULGE_MULTI_SIGNAL_VIOLA_S` | 🔴 **27.027** |
| 2026.04.10 15:00:00 | 15:57:32 | **CADJPY** | `20250001` | `BULGE_MULTI_SIGNAL_VIOLA_S` | *(idem)* |
| 2026.04.10 15:00:00 | 16:02:16 | **NZDJPY** | `20250001` | `BULGE_MULTI_SIGNAL_VIOLA_S` | 🔴 **27.349** |
| 2026.04.10 15:00:00 | 16:02:16 | **NZDJPY** | `20250001` | `BULGE_MULTI_SIGNAL_VIOLA_S` | *(idem)* |
| 2026.04.10 15:00:00 | 16:40:19 | NZDCAD | `20250001` | `BULGE_MULTI_SIGNAL_VIOLA_S` | 🟢 **74** |

🔴 **L'attribuzione e' chiusa**: stesso magic, stessa ora, stessi simboli, stessa durata.
~13.500 `PositionModify` per posizione in 58 minuti = **3,9 richieste al secondo**.

### 🧪 IL CONTRO-ESEMPIO, perche' senza non vale
**L'altra spiegazione possibile era: «e' una tempesta di tick, la fa chiunque sia in
posizione».** 🟢 **Smentita dalla riga NZDCAD**: stesso EA, stesso magic, stessa ora, viva
piu' a lungo delle altre — **74 richieste**. E dalla riga NZDCHF (magic 0, manuale, viva
13:07→15:55): **non compare fra i primi dieci simboli**. Quindi **non e' l'ora, non e' il
mercato, non e' il tick rate: sono quei due cross JPY dentro quell'EA.**

> 🟠 **Cosa NON dico**: non dichiaro il difetto esatto dentro `BULGE_MULTI_SIGNAL`. La
> differenza JPY (3 decimali) vs non-JPY (5 decimali) e' il sospetto naturale — una
> `PositionModify` il cui esito viene arrotondato dal server in modo che la condizione
> `slChanged || tpChanged` **resti vera per sempre**. Ma il sorgente di aprile non e'
> nel repo (a HEAD `BULGE_MASTER.mq5` r.1056 e `ABTG_Bulge.mq5` r.1731 **hanno gia'** la
> soglia `MathAbs(newSL-sl) > 5*point`). Quindi: **[NON MISURATO]**, e resta tale.
> 🟢 **Non serve saperlo per la challenge**: quell'EA su FTMO non c'e'.

---

## ③ ✅ LE SEI SEDIE FTMO — riga per riga, e questa volta col numero accanto

`SCHIERA_FTMO.ps1` schiera: `770101` · `770202` · `770260` · `770411` · `770511` · `771531`
+ `779001` Guardian + due sonde che non tradano. **Nessuna tocca NZDJPY, CADJPY o NZDCAD**:
il paniere e' `GER40.cash` / `US30.cash` / `US100.cash`.

### 🟢 Cinque sedie su sei sono limitate DALLA MATEMATICA, non dalla fortuna

| sedia | trailing agganciato a | costante per | tetto `PositionModify` |
|---|---|---|---:|
| `770101` DAX M5 | `iLow(_Symbol, M5, 1)` — barra **chiusa** (`InpTrailMode=1` = `ABTG_TRAIL_PREVBAR`) | 5 min | **≤1 / barra M5** |
| `770202` Dow M5 | idem | 5 min | **≤1 / barra M5** |
| `770260` Nasdaq M5 | idem | 5 min | **≤1 / barra M5** |
| `770511` SuperWave H1 | `line[1]` Supertrend — barra **chiusa** | 1 ora | **≤1 / ora** |
| `771531` EMA200 H1 | `EmaVal()` = `CopyBuffer(h,0,**1**,1)` — barra **chiusa** | 1 ora | **≤1 / ora** |

✏️ **CORREZIONE A UNA MIA LETTURA PRECEDENTE, e cambia il verdetto su una sedia.** Avevo
segnato `771531` come *«trailing sul bid vivo»*. **E' falso**: a HEAD, `ABTG_EMA200.mq5`
r.438 e' `double n=NormalizePrice(e14);` — **e' l'EMA14 della barra chiusa**, non il bid. Il
bid compare solo come guardia di validita' (`n<bid`). 🟢 **`771531` e' al sicuro per
costruzione.** *(Il referto gemello lo aveva gia' scritto giusto al §③; l'errore era mio, in
sessione, e muore qui.)*

### ⚠️ La sesta: `770411`, l'unica agganciata al prezzo vivo — **e perche' NON esplode**

`ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` r.363-364 (HEAD):
```
if(isLong){ double n=NormalizePrice(bid-a*InpTrailAtrMult); if(n>sl && n>openP) gTrade.PositionModify(...); }
else      { double n=NormalizePrice(ask+a*InpTrailAtrMult); if((n<sl||sl==0)&&n<openP) gTrade.PositionModify(...); }
```
`a=AtrVal()` = `CopyBuffer(hAtr,0,**1**,1)` → **ATR della barra chiusa, costante**. Ma `bid`
e `ask` sono **vivi**: `n` si muove a ogni tick. **Il rubinetto c'e'.**

🟢 **E il tappo c'e' anche, ed e' una riga sola**: `n` e' **normalizzato PRIMA del
confronto**. Quindi il valore confrontato e' **identico** a quello che il server memorizza:
dopo una modifica riuscita `sl == n`, e `n>sl` torna vero **solo su un NUOVO RECORD del
prezzo**. Non e' «una richiesta per tick»: e' **una richiesta per nuovo estremo**.

**E la misura lo conferma** — le quattro giornate in cui `770411` ha tenuto una posizione:

| giornata | posizione `770411` su `D30EUR` | durata | ESITI di **TUTTO IL CONTO** |
|---|---|---:|---:|
| 18/08/2026 | 08:14:43 → 09:18:58 | 1h 04 | 🟢 **75** |
| 20/08/2026 | 08:02:11 → 10:54:45 | 2h 52 | 🟢 **117** |
| 24/08/2026 | 08:01:08 → 08:47:01 | 0h 46 | 🟢 **43** |
| 26/08/2026 | 08:27:25 → 08:31:39 | 0h 04 | 🟢 **30** |

> 🔴 **Questa e' la riga da ricordare**: la stima diceva **2.600-26.000**, la misura dice
> **≤117 per tutto il conto**. **Due ordini di grandezza di errore.** La stima non era
> disonesta — era il tetto peggiore con le ipotesi dichiarate — ma **era una stima, e il
> giornale c'era gia'.** Il costo di non averlo letto prima: una notte di preoccupazione e
> una proposta di modifica a un EA schierato che **non serviva**.

---

## ④ 🚰 I QUATTRO RUBINETTI DEL REFERTO GEMELLO — cosa dice la misura di ciascuno

| | previsione (referto gemello) | 📏 MISURA | stato |
|---|---|---|---|
| **CODA A** — `770411` trailing sul bid | 2.600-26.000/giorno | ≤117 conto intero, 4 giornate | 🟢 **ASSOLTO** |
| **CODA B** — `PositionModify` rifiutata che si ripete a ogni tick (le tre Aperture) | fino a 3.000 per episodio | **328 FALLITI in un giorno, il massimo su 191** | 🟠 **VIVO ma piccolo** |
| **CODA C** — «riprovo al prossimo tick» sulle chiusure | non quantificata | nessuna firma nel conto | 🟢 **non osservata** |
| **CODA D** — Guardian `OnTimer(1)` dopo challenge fallita | 86.400/giorno | il Guardian **non e' mai girato** su quel conto | 🔴 **[NON MISURATO]** |

### 🟠 CODA B — la misura la vede, e la ridimensiona
Le giornate con molti **FALLITI e pochissima RETE** sono la firma esatta della `PositionModify`
rifiutata che si ripete:

| giornata | ESITI | di cui RETE | **FALLITI** |
|---|---:|---:|---:|
| 11/09/2026 | 350 | 22 | 🟠 **328** |
| 25/08/2026 | 370 | 51 | 🟠 **319** |
| 17/09/2026 | 217 | 16 | 🟠 **201** |
| 17/08/2026 | 70 | 36 | 34 |

🟢 **Due buone notizie, e sono misurate:**
1. **I FALLITI non hanno tempo di rete.** Nessuna riga `done in <n> ms` → il terminale li ha
   respinti **localmente**, al server non sono arrivati. Per FTMO **non contano**.
2. 🔴 **E anche contandoli TUTTI** — l'ipotesi piu' severa possibile — il massimo su 191
   giornate resta **370**: **5,4 volte sotto la soglia**.

> 🟠 **[NON NOTO] dichiarato**: «nessun tempo di rete» e' un **indizio forte**, non una prova,
> che la richiesta non sia partita. Lo dichiara lo script stesso nella sezione «cio' che
> questa riga non copre». Non lo trasformo in certezza.

### 🔴 CODA D resta APERTA — e va detto
Il Guardian `779001` **non ha mai girato** sul `50503392` (giornale 11 e 12/09: *«GUARDIAN:
nessuna riga»*). Il suo ramo da 86.400 richieste/giorno si accende **solo dopo una challenge
gia' fallita**, e quella condizione non si e' mai verificata. 🔴 **Quindi su CODA D la misura
NON dice niente, e il referto gemello resta l'unica fonte.** Non e' un rischio della
challenge in corso: e' un rischio del giorno in cui la challenge e' gia' persa — ma e'
esattamente il giorno in cui aggiungere *hyperactive* a *failed* costa la **termination of
all agreements**, non la sola *disqualification*.

---

## ⑤ 🧮 IL TETTO PER COSTRUZIONE — il numero da pubblicare

Sommando i tetti **matematici** (non le medie), con tutte e sei le sedie in posizione tutto
il giorno e una sessione indici di ~8 ore:

| sedia | tetto/giorno | come |
|---|---:|---|
| `770101` DAX M5 | ~100 | ≤1 modify/barra M5 × ~96 barre di sessione |
| `770202` Dow M5 | ~100 | idem |
| `770260` Nasdaq M5 | ~100 | idem |
| `771531` EMA200 H1 | ~24 | ≤1 modify/ora |
| `770511` SuperWave H1 | ~24 | ≤1 modify/ora |
| `770411` MaxMin M15 | ~120 | **misurato** ≤117 conto intero |
| ingressi / parziali / chiusure | ~30 | ≤5 per sedia |
| `779001` Guardian | **0** | in esercizio normale non manda niente |
| sonde (TradeExporter, SpreadLogger) | **0** | leggono, non mandano |
| **TOTALE** | 🟢 **~500** | **25% della soglia — margine 4×** |

---

## ⑥ 🧪 I CONTRO-ESEMPI OBBLIGATORI — cosa romperebbe questo verdetto

### 🅐 «Le 189 giornate tranquille sono tranquille perche' le sedie non giravano.»
❌ **Smentito.** `trades_auto.csv` mostra i trade veri di quelle sedie proprio in quelle
giornate: `770101` 39 trade, `771531` 21, `770511` 16, `770411` presente il 18-20-24-26/08.
Le giornate con ESITI coincidono con le giornate in cui hanno operato.

### 🅑 «BCM ticka meno di FTMO.»
🟠 **Vero come obiezione, e va dichiarata: [NON NOTO].** Ma morde **solo** sui meccanismi
agganciati al tick, e qui ce n'e' **uno solo** (`770411`, misurato ≤117 conto intero). Le
altre cinque sedie sono agganciate alla **barra chiusa**: il loro tetto **non dipende dal
tick rate**. Anche con un tick rate **10 volte** superiore, `770411` arriverebbe a ~1.170
con le altre invariate: **ancora sotto**.

### 🅒 «Sul demo non giravano tutte e sei insieme; su FTMO si'.»
🟢 **Coperto dal §⑤**: il tetto e' calcolato con **tutte e sei in posizione contemporanea**,
e fa ~500.

### 🅓 «Il 10/04 e' la prova che il nostro codice sa sfondare.»
🟢 **Si', ed e' proprio per questo che l'attribuzione conta.** Il meccanismo esiste ed e'
reale — ma il file che lo contiene **non sale sull'aereo**. Le sei che salgono hanno tutte
il tappo, e per cinque il tappo e' **strutturale** (barra chiusa), non una guardia che
qualcuno puo' dimenticare.

---

## ⑦ 📌 COSA QUESTO REFERTO **NON** COPRE

1. 🔴 **Come FTMO conti davvero.** La definizione esatta di «request» non e' pubblica. Noi
   contiamo le richieste di trading andate al server. Se contassero anche altro traffico, il
   conto cambia. **[NON NOTO]**, ed e' il buco di metodo gia' dichiarato nel referto gemello.
2. 🔴 **CODA D** (Guardian dopo challenge fallita): **mai osservata**.
3. 🟠 **Il difetto esatto dentro `BULGE_MULTI_SIGNAL`**: non diagnosticato (sorgente di
   aprile non nel repo). Non serve per la challenge, ma **se quell'EA dovesse mai tornare in
   campo su un conto prop, va diagnosticato prima**.
4. 🟠 **Il conto e' del `50503392`**, non di FTMO: e' il miglior sostituto disponibile
   (stessi motori, tick veri, 191 giornate), **non** l'originale.

---

## 🧭 LA BUSSOLA — dove siamo, da socio

🟢 **Una paura in meno, e tolta con un numero, non con un'opinione.** Ieri sera la domanda
«le 2.000 richieste ci fregano?» aveva come risposta *«non lo sappiamo, e forse si'»*. Oggi
ha una risposta: **no, con margine 4×, e le uniche due giornate che sfondarono in 191 sono
di un EA che non sale sull'aereo.**

🪑 **E la cosa che vale davvero: NON tocchiamo niente.** Nessuna sedia da spegnere, nessun
EA schierato da ricompilare, nessun parametro da cambiare **per questo motivo**. Il
pacchetto che parte lunedi' resta quello firmato.

🔴 **La lezione, e costa dirla**: la stima del referto gemello sbagliava di **due ordini di
grandezza** su `770411`, e il giornale con la risposta stava **gia'** sul VPS. La regola del
10/09 — *«prima si cerca il file che ha gia' la risposta»* — l'ho pagata di nuovo. Va in
checklist.

