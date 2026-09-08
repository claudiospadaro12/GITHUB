# 🚀 `ABTG_ImpulsoApertura` — L'EA C'E'. Scritto, non compilato.

**Data:** 08/09/2026 · **Branch:** `lavoro` · **File:**
`mql5/Experts/ABTG_ImpulsoApertura.mq5` (875 righe, `#property version "1.00"`)
**Origine:** promosso **9/10 "PROVA SUBITO"** in `report/CACCIA_APERTURE_ORO_2026-09-08.md`
**Criteri congelati:** `backtest_pipeline/prove/ABTG_ImpulsoApertura.txt` (**non toccati**)

> 🛑 **DICHIARAZIONE OBBLIGATORIA, PRIMA DI TUTTO IL RESTO:
> QUESTO FILE NON E' STATO COMPILATO.** Qui non c'e' MetaEditor, non c'e'
> MT5, non c'e' Strategy Tester. Quello che segue e' **revisione statica**
> (lettura doppia + controlli automatici a tavolino), **non una
> compilazione**. La prova e' **F7 sul PC di Claudio**. Niente di quanto
> scritto qui va letto come "funziona": va letto come "e' coerente con la
> specifica congelata".

---

## ⚙️ 1. IL MECCANISMO IN DIECI RIGHE

1. Si guarda **una sola barra al giorno**: quella che comincia a
   `InpOpenHour:InpOpenMinute` **in ORA SERVER** (DAX 08:00, Nasdaq/Dow 14:30).
2. La decisione si prende **alla sua chiusura** (shift 1), mai sulla barra in
   formazione: niente look-ahead, niente repaint.
3. **GATE COSTITUTIVO:** si opera solo se `range della barra >= InpImpulseATRMult x ATR`.
   Se la barra e' una qualunque, **non si opera**. Senza il gate non esiste
   nessun segnale: il filtro **E'** il motore.
4. **Il lato lo decide il dato, non un input:** `close > punto medio E close > open`
   → LONG; specchiato → SHORT; ambiguo → **fuori**.
5. Ingresso **a mercato all'apertura della barra successiva**, **una sola
   posizione**, **un solo tentativo per seduta** (il marcatore si timbra
   *prima* dell'invio: un rifiuto del broker non produce un secondo tentativo).
6. **Stop SEMPRE presente e SEMPRE vero**, allegato all'ordine: strutturale sul
   minimo/massimo della barra d'impulso (`InpSLMode=0`) o `InpSLAtrMult x ATR`
   (`InpSLMode=1`). Mai virtuale, mai solo nel codice.
7. **Pavimento di stop** `InpMinStopPts` (R109) e rispetto di
   `SYMBOL_TRADE_STOPS_LEVEL`: si prende il **maggiore** dei due.
8. **Take profit** a `InpRR x R`. **Breakeven a `InpBEatR` R** come **MODIFICA**
   dell'ordine (non chiude niente, non tocca il TP), una volta per posizione.
9. **Flat di fine seduta obbligatorio** a `InpFlatHour:InpFlatMinute`: **zero
   overnight**. E' la parte che il sorgente esterno **non aveva**.
10. **Rischio in % dell'equity**, **una sola tranche**, **Guardian** interrogato
    immediatamente prima dell'invio. Niente martingala, griglia, recovery,
    averaging, piramidazione.

---

## 🎛️ 2. LA TABELLA DEGLI INPUT — 21 in tutto

| input | default | cosa fa |
|---|---:|---|
| `InpUsaGuardian` | `true` | Guardian del conto (firme B1/C1 18/08). Nel tester le sue GlobalVariable non esistono → **fail-open**: i backtest restano confrontabili |
| `InpImpulseATRMult` | `1.5` | 🎯 **il gate**: `range >= K x ATR`. **Asse Y n.1** della griglia (1,2 → 2,0) |
| `InpATRPeriod` | `14` | quante barre di riferimento per l'ATR |
| `InpATRSuAperture` | `true` | 🔴 **DECISIONE MIA, dichiarata** (§4): `true` = il metro sono le **ultime 14 BARRE D'APERTURA**; `false` = ATR di Wilder sul TF letto a **shift 2** |
| `InpAllowLong` | `true` | ramo LONG (si gira **una corsa per lato**, regola 25/08) |
| `InpAllowShort` | `true` | ramo SHORT |
| `InpOpenHour` | `8` | **ORA SERVER** della barra d'apertura (DAX 8 · Nasdaq/Dow 14) |
| `InpOpenMinute` | `0` | **MINUTO SERVER** (DAX 0 · Nasdaq/Dow 30) |
| `InpFlatHour` | `21` | **ORA SERVER** del flat di fine seduta |
| `InpFlatMinute` | `0` | minuto del flat |
| `InpSLMode` | `0` | `0` = CANDELA (strutturale) · `1` = ATR. **int**, non enum (§4) |
| `InpSLAtrMult` | `0.5` | (solo `InpSLMode=1`) stop = X × ATR di riferimento |
| `InpMinStopPts` | `25` | **pavimento SL in PUNTI INDICE** (§4). `OnInit` **rifiuta se 0** (R109) |
| `InpMT5PerPuntoIndice` | `100` | punti MT5 per 1 punto indice (D30EUR/NASUSD/U30USD = 100) |
| `InpRR` | `3.0` | take profit in R. **Asse Y n.2** della griglia (1,5 → 3,0) |
| `InpBEatR` | `2.0` | breakeven a questo R (`0` = spento) |
| `InpRiskPercent` | `0.65` | rischio per trade in % — contratto di casa |
| `InpMaxSpreadPctOfStop` | `2.5` | gate di spread **in % dello stop** (R55) |
| `InpMagic` | `769800` | 🔢 vedi §3 |
| `InpComment` | `"IMPULSO"` | commento sugli ordini (`IMPULSO L` / `IMPULSO S`) |
| `InpVerbose` | `true` | log |

✅ **Tutti e 14 i pin del file prova esistono con lo stesso nome**: verificato
con `controlla_prova.py`, **zero `input SCONOSCIUTO`**. E' la trappola che il
23/08 costo' un round intero (MT5 ignora in silenzio i nomi che non esistono).

---

## 🔢 3. IL MAGIC: **769800**, e perche' proprio quello

**Scelto: `769800`.** Verificato **LIBERO repo-wide** l'08/09/2026:

```
$ grep -rl "769800" . --exclude-dir=.git | wc -l
0
```

**Perche' il blocco 7698xx.** Gli EA **candidati nuovi** di casa usano il blocco
**769x00 a scendere**, e sono tutti occupati fino a 7697xx:

| magic | EA |
|---:|---|
| 769000 | `ABTG_InvEsaurimento` |
| 769100 | `ABTG_CRT_TurtleSoup` |
| 769200 | `ABTG_ChaosLyapunov` |
| 769300 | `ABTG_DaxReEntry` |
| 769400 | `ABTG_OpeningReversalB` |
| 769500 | `ABTG_NySessionRetest` |
| 769600 | `ABTG_DaxValueArea` |
| 769700 | `ABTG_BreakinBox` |
| **769800** | **`ABTG_ImpulsoApertura` ← questo** |

🔒 **E soprattutto: NON collide con nessuna sedia viva.** Incrociato con
`backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260908_033003.log`
(52 sedie nei profili attivi dei tre terminali): i magic in campo stanno nei
blocchi **770xxx / 771xxx / 772xxx / 779xxx / 97xxxx**. `769800` non compare
in nessuno dei tre terminali (piccolo **50503392**, 100k **50504263**, reale
**10105439**).

💡 **Se un giorno si schiera su piu' simboli**, la convenzione di casa
(`ABTG_GapFill` 772231-772235) suggerisce `769801` D30EUR, `769802` U30USD,
`769803` NASUSD — **uno per simbolo**, cosi' i criteri di uscita si applicano
sedia per sedia. `InpMagic` e' un input: non serve toccare il codice.

---

## 🧭 4. COSA HO PRESO DAL PINE E COSA HO DECISO IO
### (una scelta non dichiarata e' un parametro nascosto)

### ✅ PRESO dal sorgente esterno (letto, non copiato — **nessuna licenza dichiarata**)

| cosa | dove sta nel Pine |
|---|---|
| il grilletto: **la barra d'apertura E' il segnale** | `is_market_open_candle()`, righe 70-75 |
| il gate `range >= atr x impulse_multiplier` (1,5), **costitutivo** | righe 93-98 |
| la **direzione decisa dalla barra** (close vs punto medio e vs open) | righe 93-98 |
| lo **stop strutturale** sul minimo/massimo della barra | `sl_type="Candle"`, righe 125/144 |
| lo stop **dentro l'ordine**, non virtuale | `strategy.exit(..., stop=...)`, righe 138/157 |
| **TP a multiplo del rischio** (3R) | `Risk_reward` |
| **breakeven a 2R come MODIFICA**, non come chiusura | righe 168-187 |
| **sizing `risk_amount / stop_distance`** in % dell'equity | righe 112-113 |
| **una posizione per volta**, decisione **a barra chiusa** | `strategy.position_size == 0`, `calc_on_every_tick` off |

### 🔴 DECISO DA ME — sette scelte, tutte dichiarate

1. **🕐 ORARI IN ORA SERVER.** L'originale gira su `Europe/London`. Qui gli orari
   sono **input in ora server BCM** (italiana − 1): DAX 08:00, Nasdaq/Dow 14:30.
   `OnInit` lo ristampa nel log a ogni avvio.
2. **🚪 FLAT DI FINE SEDUTA (`InpFlatHour`, default 21:00 server).**
   **L'originale non chiude a orario**: e' il suo unico difetto vero. Aggiunto,
   acceso per costruzione, zero overnight.
3. **📏 IL METRO DEL GATE — `InpATRSuAperture`, default `true`. E' la scelta
   piu' pesante del file, quindi la scrivo per prima fra quelle discutibili.**
   Il Pine usa `ta.atr()` sul TF del grafico. Su un CFD che quota ~23 ore, l'ATR
   attorno alla campanella e' fatto di **barre notturne sottili**, e la barra
   d'apertura le supera **quasi sempre**: il gate diventerebbe **decorativo** e
   il cancello **C5** boccerebbe il motore per colpa del **metro**, non del
   motore. Default: il riferimento e' la **media dei range (high−low) delle
   ultime `InpATRPeriod` BARRE D'APERTURA** — cioe' *"quanto e' anomala questa
   apertura rispetto alle aperture normali"*.
   👉 **L'altra lettura resta misurabile**: `InpATRSuAperture=false` da' l'ATR
   di Wilder sul TF, letto a **shift 2** (la barra non entra nel metro che la
   giudica). **Un input, due letture, confronto pulito.**
   ⚠️ **Conseguenza dichiarata:** finche' non ci sono `InpATRPeriod` aperture
   precedenti complete, `RiferimentoATR()` torna 0 e **non si opera** → le
   prime ~14 sedute della finestra **non producono trade**. E' voluto.
4. **📐 `InpMinStopPts` E' IN PUNTI INDICE, non in punti MT5.** Il file prova
   dice `25`. In punti MT5 sarebbero **0,25 punti indice** su D30EUR: un
   pavimento **inerte**, cioe' l'opposto di quel che R109 chiede. In punti
   indice sono **25 punti = 2500 punti MT5**, un pavimento che ha senso su M30.
   La conversione e' l'input `InpMT5PerPuntoIndice` (default 100, come in
   `ABTG_OpeningReversalB`).
5. **🔢 `InpSLMode` e' un `int` (0/1), non un `enum`.** Il file prova lo pinna
   come `InpSLMode=0`; con un `int` il driver e MT5 leggono lo stesso numero
   senza passare dalla tabella dei membri di un enum. Zero ambiguita'.
6. **🛡️ Il prop-hardening di casa, che nel Pine non c'e' affatto:**
   gate di **spread in % dello stop** (R55, 2,5%), **pavimento di stop** (R109),
   **stops-level** rispettato su SL **e** TP, vincoli di **volume**
   (min/max/step), **retcode controllato** dopo ogni ordine, **Guardian**
   chiamato immediatamente prima dell'invio, **`OnTester` + OptFrame + export
   per-trade** in `Common\Files`, **hedge-safe** (posizione selezionata per
   simbolo **e** magic, mai `PositionSelect(_Symbol)`).
7. **🧮 IL LOTTO IN UNA SOLA TRANCHE — ed e' una scelta, non una dimenticanza.**
   Il difetto corretto oggi (`report/FIX_LOTTO_PENDENTE_2026-09-08.md`:
   pavimento del lotto minimo applicato **dopo** il calcolo della seconda
   tranche → fino al **doppio** del rischio dichiarato, misurato **1,42% su un
   contratto da 1,0%** il 20/08) **qui non puo' esistere**: non c'e' nessuna
   seconda tranche, nessun parziale, nessun ordine pendente. **Forma semplice,
   come chiesto.**

### ➕ Input in piu' rispetto all'elenco del file prova
`InpATRSuAperture`, `InpFlatMinute`, `InpMT5PerPuntoIndice`, `InpMagic`,
`InpComment`, `InpVerbose`, `InpUsaGuardian`. **Restano tutti al default** (il
driver li blinda a `v||v||0||v||N`): non spostano la griglia congelata.

---

## 🔍 5. CONTROLLI FATTI (a tavolino — **non e' una compilazione**)

| controllo | esito |
|---|---|
| parentesi bilanciate (fuori da commenti e stringhe) | graffe **80/80**, tonde **456/456**, quadre **52/52** ✅ |
| `OnInit` / `OnDeinit` / `OnTick` / `OnTester` / `OnTesterInit` / `OnTesterDeinit` | tutti presenti ✅ |
| **niente emoji / niente caratteri non-ASCII** nel `.mq5` | **0 occorrenze** ✅ |
| ogni funzione chiamata e' definita nel file o e' API MQL5 / metodo `CTrade` | ✅ (le sole "non risolte" sono `Buy`, `Sell`, `PositionClose`, `PositionModify`, `ResultRetcode*`, `Set*` di `CTrade` e `TesterStatistics`) |
| input duplicati | **nessuno** ✅ |
| i 14 pin del file prova esistono nell'EA | ✅ `controlla_prova.py`: zero `input SCONOSCIUTO` |
| colonne di `OnTester` vs intestazione CSV di `OnTesterDeinit` | **21 = 21**, contate una per una ✅ |
| specificatori di formato vs argomenti in ogni `StringFormat`/`PrintFormat` | contati uno per uno ✅ |
| handle indicatore rilasciato in `OnDeinit` | ✅ `IndicatorRelease(gAtrH)` |
| API usate: solo quelle gia' in uso negli EA di casa | ✅ (modello: `ABTG_DAX_Apertura_EU` + `ABTG_OpeningReversalB`) |

⚠️ **Un difetto che il compilatore avrebbe preso e che ho preso io rileggendo:**
in `GestisciBreakeven()` la variabile si chiamava `open`; rinominandola era
rimasta **una meta' del blocco** con il nome vecchio. Corretto e riverificato
(`grep -n "\bopen\b"` ora trova **solo commenti**). **E' la prova che la
rilettura serve — e che non sostituisce F7.**

---

## 🧱 6. I LIMITI, scritti prima e non dopo

1. 🔴 **NON COMPILATO, NON TESTATO.** Zero numeri. Nessun backtest e' stato
   lanciato. La compilazione la fa Claudio (F7 in MetaEditor).
2. 🟡 **`controlla_prova.py` segnala "2 assi Y".** La griglia congelata
   spazzola `InpImpulseATRMult` **e** `InpRR` (5 × 4 = 20 celle per lato): il
   pre-controllo di casa pretende **un solo** asse. **Non ho toccato la
   griglia** — e' un criterio congelato. Chi lancia sceglie: `walkforward_generico`
   regge due assi, oppure si spezza in due round da un asse ciascuno.
3. 🟡 **Su H1 la campanella US non cade su un confine di barra.** C1 dice "se lo
   stop mediano non arriva a 40 × spread si sale a H1": ma su H1 le barre sono
   `14:00-15:00`, e **14:30 non e' un confine**. `OnInit` **rifiuta l'avvio**
   con un messaggio esplicito invece di girare in silenzio senza mai operare.
   Su H1 andrebbe usato `InpOpenHour=14, InpOpenMinute=0` — **che pero' e' una
   barra che parte mezz'ora PRIMA della campanella, cioe' un'altra strategia.**
   Va deciso, non subito.
4. 🟡 **Le prime ~14 sedute di ogni finestra non producono trade** (campione
   dell'ATR d'apertura incompleto). Su ~490 sedute e' ~3%: incide sul conteggio
   del **PASSO 0**, e va ricordato quando si legge il numero di segnali/giorno.
5. 🟡 **Il breakeven a 2R e' acceso di default** perche' cosi' dice il file
   prova (`InpBEatR=2.0`). Lezione di casa opposta e a verbale: *"R:R invertito
   da gestione troppo stretta"*. A 2R su un TP a 3R il rischio e' contenuto, ma
   **`InpBEatR=0` va misurato come confronto**, non dato per peggiore.
6. 🔴 **Il cancello C4 (scorrelazione) non e' codice, e' un obbligo del round.**
   Alla campanella gia' operano **770101**, **770202**, **770611**, tutte
   **SOLO LONG**. Se i giorni-segnale del ramo long coincidono, **il ramo long
   va scartato** anche se guadagna: raddoppierebbe il rischio sullo stesso
   evento. L'export per-trade in `Common\Files` serve esattamente a misurarlo.
7. 🔴 **Il tetto per cluster firmato il 07/09 NON E' ATTIVO nel Guardian.**
   Tre indici che aprono lo stesso giorno nella stessa direzione sono **UN**
   rischio, non tre. Finche' non e' implementato e collaudato e' **un'intenzione,
   non una protezione**.
8. 🟠 **Il ramo ORO non si lancia.** La profondita' a tick di XAUUSD non e' mai
   stata misurata (`misura_tick/` ha **solo** i tre indici): niente `@DAQUANDO`,
   niente corsa. Non si inventa una data.

---

## ▶️ 7. COSA SERVE ORA (in ordine, e decide Claudio)

1. **F7 in MetaEditor** su `ABTG_ImpulsoApertura.mq5` → se il compilatore
   protesta, gli errori tornano qui e si correggono.
2. **PASSO 0 (conteggio)**, non la griglia: quanti segnali/giorno per simbolo e
   per lato, **stop mediano in punti**, **spread del minuto d'apertura**.
   Rispondono ai cancelli **C0** (pavimento 1,00 op/giorno per **famiglia**) e
   **C1** (`stop >= 40 × spread`). Le colonne `Aperture Valutate / Gate OK /
   Gate NO / Long / Short` del CSV sono li' apposta.
3. Solo se il PASSO 0 passa: **PASSO 1**, due corse separate (una per lato), col
   controllo a ingressi casuali accanto (**C6**).
4. **Demo prima del reale, sempre.** Un backtest bello non e' una promessa.

---

_Agente MQL5 · 08/09/2026 · branch `lavoro`._
_Attribuzione: motore ispirato a **`Market Open Impulse [LuciTech]`** di
**@TradesLuci** (TradingView, `fd3aaa16c57f4a75b712fa311c62594a`, 12/08/2025).
🔴 **Il sorgente NON dichiara nessuna licenza**: e' stato **letto, non copiato**;
il `.mq5` e' scritto **da specifica**, con l'attribuzione in testa al file._
