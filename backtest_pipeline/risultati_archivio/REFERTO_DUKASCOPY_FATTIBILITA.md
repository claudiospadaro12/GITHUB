# 🏗️ DUKASCOPY PER GLI INDICI — REFERTO DI FATTIBILITÀ (18/08/2026)

_Missione: chiudere IL buco storico del progetto — gli indici BCM partono
dal 26/09/2024, quindi niente finestre di regime 2019-2022 per DAX / Dow /
Nasdaq / Nikkei. Agente in background, ambiente cloud, branch `lavoro`._

---

## 1. 🚫 RETE DAL CLOUD: **NO** — e la missione ha cambiato strada come previsto

**[VERIFICATO, due canali indipendenti, 18/08 ~12:00 UTC]**

| prova | risposta |
|---|---|
| `curl` → `datafeed.dukascopy.com` (path con `DEU.IDX/EUR` E path concatenato `DEUIDXEUR`) | **`CONNECT tunnel failed, 403`** dal proxy |
| `curl` → `www.dukascopy.com` | **`CONNECT tunnel failed, 403`** |
| status del proxy (`__agentproxy/status`) | `connect_rejected: gateway answered 403 to CONNECT (policy denial)` su `datafeed.dukascopy.com:443` |
| WebFetch (canale separato dal proxy shell) | **`EGRESS_BLOCKED: Access to datafeed.dukascopy.com is blocked by the network egress proxy`** |

Non è un problema di path, di TLS o di rate limiting: è **policy dell'ambiente
cloud**. Quindi la strada (a) — scaricare qui e committare i dati — è **morta
in partenza**, indipendentemente dai volumi.

> ➡️ **Strada scelta: (b) — la pipeline gira sul PC di Claudio.**
> Deliverable: `backtest_pipeline/dukascopy/dukascopy_m1.py` (sotto).

---

## 2. 🎯 STRUMENTI E DATE DI PARTENZA: **già misurati il 15/08 dal PC di Claudio**

Non c'era niente da ri-misurare: la sonda a tre giri
(`REFERTO_SONDA_DUKASCOPY.md`, dati grezzi in
`risultati_prove/dukascopy_sonda/`) ha già inchiodato tutto, **con controllo
positivo EURUSD passato** nel giro valido.

**[VERIFICATO, misurato da `DESKTOP-H4D7CAJ` il 15/08/2026]**

| nostro | Dukascopy | primo anno con dati | come lo sappiamo |
|---|---|---|---|
| `D30EUR` (DAX) | `DEUIDXEUR` | **2012** (2011 = 404) | fase "stringo" |
| `U30USD` (Dow) | `USA30IDXUSD` | **2012** (2011 = 404) | fase "stringo" |
| `NASUSD` (Nasdaq) | `USATECHIDXUSD` | **2012** (2011 = 404) | fase "stringo" |
| `225JPY` (Nikkei) | `JPNIDXJPY` | **2013** (2012 vuoto) | fase "stringo" |

I nomi sono **decisi per esclusione**, non intuiti: `US30IDXUSD`, `USA30USD`,
`WS30IDXUSD`, `GERIDXEUR` danno **404 veri** con controllo positivo OK.
Il formato dell'URL è **[VERIFICATO]** dalle risposte 200 della sonda:

```
https://datafeed.dukascopy.com/datafeed/{SIMBOLO}/{AAAA}/{MM-1}/{GG}/{HH}h_ticks.bi5
                                                          ^^^^ MESE ZERO-BASED (giugno = 05)
```

**Cosa c'è dentro la finestra 2019-2024 che serve alle prove di regime:**
crollo Covid 2020 ✅ · orso+inflazione 2022 ✅ · toro 2019/2021/2023 ✅ —
per tutti e quattro gli indici. (BCM: 21 mesi, un regime solo.)

---

## 3. 🧰 IL DELIVERABLE: `backtest_pipeline/dukascopy/dukascopy_m1.py`

Un file Python solo, autosufficiente (stdlib pura: `lzma`, `struct`,
`urllib`), **ASCII puro**, per il PC di backtest (Python c'è già:
`run_all.ps1` lo invoca). Fa tutta la catena:

**scarica** (cache su disco, ripresa gratuita, 404 memorizzati) →
**decodifica** i `.bi5` (LZMA → record da 20 byte big-endian:
ms-offset, prezzo1, prezzo2, vol1, vol2) → **costruisce le M1**
(OHLC sul **bid**, volume = **conteggio tick**) → **scrive il CSV nel
Formato 1** che `ABTG_ImportaStoricoEsterno` legge già
(`YYYY.MM.DD HH:MM,O,H,L,C,V` — parsing verificato riga per riga nel
sorgente MQL5, righe 89-111 e 302-306) → **raccoglie sul Desktop + zip**
(regola delle righe di lancio, punto 2).

### 3a. ⚖️ Le tre cose che lo script MISURA invece di assumere

| cosa | come |
|---|---|
| **controllo positivo** (fase 0) | riscarica l'ora EURUSD che la sonda ha GIÀ visto rispondere (16/06/2025 15 UTC, 24.043 byte). Se fallisce → si ferma: se il metro non funziona, non si misura niente |
| **ordine dei campi** ask/bid | la documentazione pubblica dice ask-prima-di-bid **[INFERITO]** → lo script conta su ~20.000 tick quante righe hanno campo2≥campo3; sotto il 95% di coerenza **si ferma** |
| **divisore del prezzo** | il prezzo è un intero da dividere per 10^k ("per gli indici tipicamente /1000" è VOCE, non misura) → k si sceglie mettendo la mediana nella banda plausibile dello strumento (DAX 4.000-30.000 ecc.); se più di un k cade in banda **si ferma** e chiede `--divisore` |

### 3b. 🕐 IL FUSO — la trappola vera, disinnescata con un numero già misurato

I `.bi5` sono in **UTC**. Ma il calibratore di `ABTG_ImportaStoricoEsterno`
applica **UNO shift fisso a tutto il file**, e **UTC non ha ora legale**: uno
shift fisso da UTC sbaglierebbe di un'ora per metà anno.

Il fatto misurato che ci salva: **8 import HistData su 8** (feed in ora di
New York) **hanno calibrato tutti +5** con differenze 0,005-0,011% su 7 anni
di barre (`REFERTO_IMPORT_6_SIMBOLI.md`) — impossibile se il server BCM non
seguisse l'ora legale **americana** come New York. Quindi:

- default **`--fuso ny`**: i timestamp escono in **ora di New York** (regola
  DST USA 2007+ implementata nello script, zero dipendenze), **identica
  convenzione di HistData**;
- 🎯 **CONTROPROVA ATTESA E OBBLIGATORIA: il calibratore deve trovare +5
  anche su questi file.** Se trova un altro numero, fermarsi e capire.
- `--fuso utc` esiste solo per confronti manuali, **non** per l'import.

### 3c. ✅ Cosa è stato provato QUI (e cosa no — detto chiaro)

- **[VERIFICATO in cloud] autotest sintetico 6/6**: round-trip
  pack→LZMA→decodifica sui tick noti; misura dell'ordine campi; misura del
  divisore; costruttore M1 (OHLC bid, volume tick, 2 barre attese); confini
  DST USA 2025 **al minuto** + estate/inverno 2020; riga CSV identica al
  Formato 1.
- **[NON PROVATO su dati veri]**: la rete è bloccata dal cloud, quindi il
  primo `.bi5` vero lo vedrà il PC di Claudio. Per questo il **fail-fast è
  ovunque**: controllo positivo, ordine campi, divisore — al primo segnale
  storto lo script si ferma invece di produrre numeri.

---

## 4. 🔬 VALIDAZIONE DEL CAMPIONE — pronta, delegata al primo lancio

`--validazione` scarica **UN giorno di DAX: lunedì 16/06/2025** (la sonda ha
già visto l'ora 15 UTC di quel giorno rispondere con **17.875 byte**
[VERIFICATO]) e stampa: barre, range del giorno, buchi intragiornalieri >60
minuti, fuso dichiarato.

**Il confronto di sanità è ESATTO, non a memoria**: il 16/06/2025 **sta
dentro lo storico BCM nativo** (che parte dal 26/09/2024) → si mettono
fianco a fianco le M1 prodotte e il grafico `D30EUR` nativo dello stesso
giorno. Stessa forma, stesso range = decoder giusto; divisore sbagliato di
10x sarebbe **impossibile da non vedere**.

---

## 5. 📦 VOLUMI E PIANO

**[INFERITO dagli hour-file misurati dalla sonda — lo script stampa i numeri
veri a ogni corsa]**: gli hour-file DAX visti vanno da 5,6 KB (2012) a 87,7
KB (ora di punta 2020). Stima prudente:

| voce | stima |
|---|---|
| download `.bi5` | ~30-80 MB / anno / strumento |
| CSV M1 prodotto | ~10-15 MB / anno / strumento (≈300-350k barre) |
| CSV M1 zippato | **~2-3 MB / anno / strumento** |
| **missione piena** (4 indici × 2019→oggi) | ~1,0-1,5 GB di download, ~180k richieste HTTP |

⏱️ Con la pausa di default (250 ms — il 15/08 le raffiche hanno preso **503
di rate limiting**, lezione incorporata: retry 2/5/15/30 s) la missione piena
è **una corsa notturna, forse due**. La cache la rende **interrompibile
gratis**: si rilancia e riparte da dove era. Consiglio: **un simbolo alla
volta**, DAX per primo.

---

## 6. 🛤️ L'ULTIMO MIGLIO — dalle M1 al simbolo custom in MT5 (solo procedura, NON eseguita)

La macchina esiste già ed è collaudata 8/8 sul forex
(`importa_storico_esterno.ps1` + `mql5/Scripts/ABTG_ImportaStoricoEsterno.mq5`,
verbale in `REFERTO_IMPORT_6_SIMBOLI.md`). Per gli indici cambia solo
l'imbocco: **il CSV non viene da HistData ma dal nostro script** (la fase
download/concatena del `.ps1` è HistData-specifica e NON va usata).

Procedura proposta (PC di backtest, MT5 di backtest — MAI il VPS):

1. `dukascopy_m1.py` ha prodotto `D30EUR_M1.csv` (e fratelli) — già col
   nome BCM giusto.
2. Copiare il CSV in `MQL5\Files` del terminale BCM di backtest.
3. Lanciare `ABTG_ImportaStoricoEsterno` (già nel repo) su un grafico
   qualunque con: `InpSimboloSorgente=D30EUR`, `InpSimboloNuovo=D30EUR_EXT`,
   `InpFileCsv=D30EUR_M1.csv`, **`InpFormato=1`**, autoshift attivo
   (`InpShiftMax=6`). Il clone eredita e RI-VERIFICA digits, point,
   tick_size, contract_size dal `D30EUR` nativo.
4. Simboli proposti: **`D30EUR_EXT` · `U30USD_EXT` · `NASUSD_EXT` ·
   `225JPY_EXT`** — stessa convenzione dei 6 forex.
5. **Chiusura PULITA di MT5** a fine import (lezione del 14/08: kill forzato
   = barre salvate ma simbolo non registrato).
6. I tre cancelli, tutti già congelati:
   - **shift calibrato = +5**, come gli 8 forex (se no: fermarsi);
   - **cancello ZERO** (`PROVA_REGIME_CRITERI.md`): diff media > 0,05% o
     copertura < 80% sul periodo di sovrapposizione col nativo
     (26/09/2024→oggi, ~11 mesi — è tanto, e c'è apposta) → **non si usa**;
   - **lezione R80**: prova di riproduzione obbligatoria prima di usare i
     dati nei verdetti.

> ⚠️ E la regola d'uso resta scolpita: i simboli `_EXT` servono **SOLO come
> PROVA DI REGIME a parametri CONGELATI**. Non si tara MAI su un feed
> esterno. Spread e commissioni restano quelli del tester (R55: 1,5 punti
> indice sfondano il cancello del 10% sull'ORB — va ridetto ogni volta).

---

## 7. ▶️ LE RIGHE DI LANCIO PER CLAUDIO (PC di backtest)

**Passo 1 — validazione (10 minuti, ~24 richieste):**
```powershell
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/dukascopy/dukascopy_m1.py" -OutFile "$env:USERPROFILE\dukascopy_m1.py"
python "$env:USERPROFILE\dukascopy_m1.py" --autotest
python "$env:USERPROFILE\dukascopy_m1.py" --validazione
```
La raccolta Desktop + zip (`dukascopy_m1.zip`) la fa lo script da solo.
**Mandare lo zip in chat**: il confronto col grafico `D30EUR` nativo del
16/06/2025 decide se il decoder è promosso.

**Passo 2 — solo DOPO la promozione del passo 1 (notturna, un simbolo):**
```powershell
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/dukascopy/dukascopy_m1.py" -OutFile "$env:USERPROFILE\dukascopy_m1.py"
python "$env:USERPROFILE\dukascopy_m1.py" --simboli DEUIDXEUR --da 2019-01-01
```
Poi gli altri tre (`USA30IDXUSD`, `USATECHIDXUSD`, `JPNIDXJPY`), poi
l'ultimo miglio (sezione 6).

---

## 8. 📋 Etichette, in una riga ciascuna

- **[VERIFICATO]** blocco rete cloud (2 canali) · formato URL e mese
  zero-based (200 veri) · nomi simboli e prime date (sonda 15/08, controllo
  positivo OK) · parsing Formato 1 (sorgente MQL5) · autotest decoder 6/6 ·
  shift +5 degli 8 import HistData.
- **[INFERITO]** layout record tick (doc pubblica → misurato a runtime) ·
  divisore prezzo (misurato a runtime) · BCM segue DST USA (fortemente
  indiziato dagli 8 shift identici) · stime di volume (sezione 5).
- **[INCERTO]** niente che blocchi: ogni incertezza ha il suo fail-fast
  dentro lo script.

**Nessun parametro degli EA in forward cambia per questo referto.**

---

## ESITO DELLA CORSA PIENA (18/08 sera) — INTERROTTA, STRADA CAMBIATA

La corsa DEUIDXEUR 2019->oggi dal PC di backtest e' stata strozzata dal
server: 25/2389 giorni in 1h43m (596 ore, 7,4 MB, 4 errori consumati),
con 503/reset/timeout/DNS continui = proiezione ~7 giorni di crawl.
Interrotta da Claudio con Ctrl+C alle ~17:00; la cache v2 (a prova di
interruzione) conserva i 25 giorni per la controprova incrociata.
DECISIONE: si passa alla strada HistData (M1 mensili dirette, stessa
convenzione oraria dei nostri import _EXT) — fattibilita' in corso.
Dukascopy resta riserva e fonte di controprova sul giorno campione
16/06/2025 (min 23400.56 / max 23715.65, gia' validato).
