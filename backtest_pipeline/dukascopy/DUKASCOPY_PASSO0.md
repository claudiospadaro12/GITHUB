# 🎫 DUKASCOPY TICK — PASSO 0: PROGETTO + STRUMENTI (31/08/2026)

_Questo e' un **PASSO 0**: fattibilita' misurata, mappa del fuso, piano in
passi e strumenti pronti. **NIENTE righe di lancio**: arriveranno con
verificatore quando Claudio decidera' di lanciare. Fino ad allora qui non
parte nulla._

---

## 1. 🎯 PERCHE': i DUE verdetti parcheggiati che questo import sblocca

| verdetto | dov'e' fermo | cosa serve |
|---|---|---|
| **NY Session Retest** (Dow) | cella slope75 **PF 1.37-1.43, DD 3.7-4.7%**, ma **n=114 < muro R59 (150)** → merito SOSPESO; tagliando stimato primavera-estate 2027 a forza di forward (REFERTO_NYRETEST_2026-08-31.md) | **tick Dow pre-2024**: la stessa cella congelata su piu' anni → n≥150 SUBITO, tagliando anticipato di anni |
| **CRT Turtle Soup** (Nasdaq) | vive nel **chop 2022-2023** su OHLC (+10135 gated, ogni regime verde), ma il tick BCM parte dal 26/09/2024 → **verdetto tick nel SUO regime impossibile su BCM** (REFERTO_CRT_2026-08-30.md) | **tick Nasdaq 2022-2023**: il verdetto tick nel regime giusto, con la cella e il gate GIA' congelati |

In entrambi i casi l'uso e' **VERDETTO A PARAMETRI CONGELATI** — celle gia'
tarate su BCM, criteri gia' scritti. Non e' taratura: e' esattamente l'uso
che la regola d'oro degli import esterni permette.

> ### 🧊 REGOLA D'USO (congelata, identica agli _EXT)
> I simboli `*_DK` servono **SOLO per verdetti a parametri congelati**
> (prova di regime, allungamento del campione di una cella gia' tarata su
> BCM). **Non si tara MAI un parametro su un feed esterno.**

---

## 2. 📏 FATTIBILITA' — i numeri, con l'etichetta giusta accanto

### 2a. Profondita' storica reale dei due strumenti

| nostro | Dukascopy | tick da | come lo sappiamo |
|---|---|---|---|
| `U30USD` (Dow) | `USA30IDXUSD` | **2012** (2011 = 404 veri) | **[MISURATO]** sonda 15/08 dal PC di backtest, controllo positivo OK (REFERTO_SONDA_DUKASCOPY.md) |
| `NASUSD` (Nasdaq) | `USATECHIDXUSD` | **2012** (2011 = 404 veri) | **[MISURATO]** stessa sonda |

Controprova pubblica **[DOCUMENTATO, non misurato da noi]**: il catalogo
dukascopy-node riporta tick `usa30idxusd` dal **2012-04-04** e
`usatechidxusd` dal **2012-06-14** — coerente con la nostra sonda
(fonti: dukascopy-node.app/instrument/usa30idxusd e /usatechidxusd,
consultate il 31/08/2026; la doc ufficiale Dukascopy e' irraggiungibile dal
cloud, proxy 403 — misurato il 18/08).

👉 **Le finestre che servono (2019+ Dow, 2022-2023 Nasdaq) sono COPERTE con
anni di margine.**

### 2b. Formato `.bi5` **[VERIFICATO dalla sonda e dall'autotest]**

- URL: `datafeed.dukascopy.com/datafeed/{SIMBOLO}/{AAAA}/{MM-1}/{GG}/{HH}h_ticks.bi5`
  — **mese ZERO-BASED** (giugno = 05), un file per ORA UTC.
- Contenuto: LZMA → record da **20 byte big-endian**: ms-offset nell'ora,
  prezzo1, prezzo2 (interi da dividere per 10^k), vol1, vol2.
- Ordine ask/bid e divisore: **MISURATI a runtime** dallo script, mai
  assunti (coerenza ≥95% sull'ordine, mediana in banda per il divisore,
  regola della banda del 20/08: rapporto < 10).

### 2c. Dimensioni stimate per le due missioni **[DERIVATO da misure]**

Ancore misurate: hour-file DAX 5,6-87,7 KB; la corsa del 18/08 ha fatto
596 ore = 7,4 MB → **~12,4 KB/ora media**. Rapporto LZMA ~4-6x, record
20 byte, riga CSV ~45 byte.

| voce | Missione A: Dow 2019.09→2024.09 (~5 anni) | Missione B: Nasdaq 2022.01→2023.12 (2 anni) |
|---|---|---|
| ore da chiedere | ~38.000 | ~15.000 |
| download `.bi5` | **~300-500 MB** | **~120-200 MB** |
| tick attesi | ~60-120 M | ~25-50 M |
| CSV tick prodotti | **~3-6 GB** | **~1,5-2,5 GB** |
| base tick MT5 (dopo import) | stesso ordine di grandezza | idem |

(Paragone di sanita': i tick NATIVI BCM di NASUSD sono 166,5 M in 23 mesi —
REFERTO_MISURA_TICK_NASUSD. Dukascopy su indici e' meno denso: se i conti
usciranno molto sopra queste bande, fermarsi e capire.)

⚠️ **Serve DISCO: ~10 GB liberi** sul PC di backtest per la missione A
(cache + CSV + base MT5). Va verificato prima della riga, non durante.

### 2d. 🧱 IL MURO VERO: il rate limit (gia' pagato il 18/08)

**[MISURATO]** La corsa M1 DEUIDXEUR del 18/08 e' stata strozzata dal
server: 25 giorni in 1h43m con 503/reset continui = **~4 minuti per giorno
di storico**. A quel ritmo:

- Missione A (~1.580 giorni): **~105 ore di crawl** = 4-5 notti;
- Missione B (~630 giorni): **~42 ore** = 2 notti.

Come lo gestiamo (tutto gia' dentro `dukascopy_tick.py`):
1. **finestre DICHIARATE obbligatorie** (`--da/--a`: senza, non parte);
2. **cache con ripresa gratuita** (404 memorizzati, scritture atomiche,
   cache avvelenata riscaricata da sola) — la STESSA cache `raw/` di
   `dukascopy_m1.py`: i 25 giorni DAX gia' scaricati restano buoni;
3. **CSV MENSILI scritti man mano**: una corsa interrotta conserva i mesi
   finiti (chiuso il limite noto del fratello M1: "CSV solo a fine
   simbolo");
4. **proiezione stampata ogni 25 giorni** ("RESTANO ~N ORE"): se il ritmo
   e' quello del 18/08, la misura lo dice subito e si ridiscute il piano
   (spezzare in tranche notturne), non si insiste alla cieca;
5. pausa di rispetto 250 ms + retry 2/5/15/30 s + stop dopo 20 errori di
   fila (il ban 503 e' temporaneo: si aspetta e si rilancia).

**Rischio dichiarato**: il ritmo del 18/08 era una sera sola; puo' andare
meglio (orari diversi) o uguale. **Si misura al primo lancio, la
proiezione e' nel log.** Se ~4 min/giorno regge, la missione A e' un
lavoro da una settimana di notti — fattibile ma da decidere con questi
numeri davanti, non col "vediamo".

---

## 3. 🕐 LA MAPPA DEL FUSO — GMT → server BCM, con le settimane maledette

I `.bi5` sono in **UTC** (certo). Il server BCM sta a **"ora italiana - 1"**
(regola di casa). Il problema sono le settimane in cui DST USA e DST EU non
coincidono — **gia' pagate care** (flat oltre orario nelle settimane DST di
marzo nel passo 0 NyRetest; la falla del flat era proprio li').

### 3a. Cosa e' MISURATO, cosa e' APERTO

| fatto | etichetta |
|---|---|
| estate piena e inverno pieno: server = UTC+1 / UTC+0 (= italiana -1) | **[MISURATO]** 8/8 import forex HistData calibrati +5 piatto, diff 0,005-0,011% su 7 anni |
| nelle settimane sfasate il server segue il calendario **USA** | **[INDIZIATO, non chiuso]**: la cura DST-aware NY→EU della v2 ha PEGGIORATO la diff del 7,7-8,6% (REFERTO_HISTDATA §15) — coerente col calendario USA — MA quella misura e' contaminata dall'evento anomalo del 23/03/2026 11:00 (diff 3-4% su tre simboli nello stesso istante) |

**Decisione PASSO 0**: il convertitore implementa **TUTTE E DUE** le regole,
autotestate al minuto sui confini:

- `--dst usa` (default, ipotesi meglio supportata): server = UTC **+1h
  quando il DST USA e' attivo** (2a dom. marzo 07:00 UTC → 1a dom.
  novembre 06:00 UTC);
- `--dst europa`: server = UTC **+1h quando il DST EU e' attivo** (ultima
  dom. marzo 01:00 UTC → ultima dom. ottobre 01:00 UTC);
- `--fuso utc`: uscita in UTC, solo per confronti.

La conversione e' **per-tick nel convertitore Python** (dichiarata nel
referto di ogni corsa), **MAI uno shift a mano** e MAI demandata
all'import MQL5 (che infatti applica shift ZERO).

### 3b. Le settimane di disallineamento dentro la sovrapposizione col nativo

| finestra sfasata (USA in DST, EU no / viceversa) | dentro la sovrapposizione tick BCM (26/09/2024→oggi)? |
|---|---|
| 27/10 → 03/11/2024 | ✅ |
| 09/03 → 30/03/2025 | ✅ |
| 26/10 → 02/11/2025 | ✅ |
| 08/03 → 29/03/2026 | ✅ |

**Quattro finestre di discriminazione**: e' un lusso, usiamolo.

### 3c. 🧪 IL DISCRIMINANTE, congelato PRIMA di misurare

La sonda (sezione 4, passo 5) confronta i giorni campione **dentro** le
finestre sfasate: se col calendario `usa` quei giorni passano il cancello
come i giorni normali → calendario confermato. Se **solo quelli**
esplodono (diff dell'ordine del range di un'ora di mercato) → calendario
sbagliato → si riconverte con `--solo-cache --dst europa` (**zero
riscarichi**, la cache basta) e si rifa' la sonda. Se falliscono giorni
anche FUORI dalle finestre → il problema non e' il fuso: fermarsi e
capire (lezione dell'evento 23/03: prima si isola l'evento, poi si
giudica il calendario).

---

## 4. 🛤️ IL PIANO IN PASSI (ognuno col suo cancello)

```
1. DOWNLOAD    dukascopy_tick.py, finestra dichiarata     [PC di backtest]
2. DECODIFICA  LZMA -> tick (misura ordine campi+divisore) [stesso script]
3. CSV TICK    mensili, ORA SERVER, Time,Msec,Bid,Ask      [stesso script]
4. IMPORT MT5  ABTG_ImportaTickEsterno.mq5                 [MT5 backtest]
               CustomSymbolCreate (clone da U30USD/NASUSD)
               + CustomTicksReplace a blocchi
               -> simboli U30USD_DK / NASUSD_DK
5. SONDA       stesso script MQL5 (InpSoloSonda=true):
               giorni campione 2024.10+ contro tick NATIVI
               -> CANCELLO + discriminante DST
6. (solo dopo) i due verdetti, celle congelate, Modello 4
```

### 4a. I criteri della SONDA, congelati ADESSO (prima di ogni numero)

| criterio | soglia | perche' |
|---|---|---|
| **mediana** \|diff bid\| al minuto (ultimo bid del minuto, % del prezzo nativo) | **≤ 0,05%** | stesso metro del cancello ZERO degli _EXT; MEDIANA e non media: robusta agli eventi tipo 23/03 |
| copertura minuti (minuti coperti da entrambi / minuti nativi) | **≥ 80%** | stesso metro _EXT |
| giorni campione | 10 di default: 2 normali + 7 nelle finestre sfasate + 1 recente | discriminante DST incorporato |
| spread mediano DK vs nativo | **si DICHIARA nel referto** (non e' un cancello) | coi tick veri lo spread storico e' NEI prezzi: il tester Modello 4 lo usa — vantaggio vero del tick, ma va confrontato col nativo per capire cosa stiamo comprando |
| verdetto | tutti i giorni dentro → OK; solo giorni sfasati fuori → riconverti (3c); altro → **CANCELLO CHIUSO, come gli _EXT** | precedente vincolante: gli _EXT HistData sono IN FRIGO da quando il loro cancello (0,061-0,101%) non e' passato. Un _DK che fallisce fa la stessa fine, senza sconti |

### 4b. Le due missioni proposte (da firmare al lancio, non ora)

| | simbolo DK | finestra | verdetto che sblocca |
|---|---|---|---|
| **A** | `U30USD_DK` | 2019-09-01 → 2024-09-26 (si salda al tick nativo) | NY Retest slope75: stessa cella, n da 114 a stima ~600+ (5,4 trade/mese misurati) → muro R59 superato in UNA corsa |
| **B** | `NASUSD_DK` | 2022-01-01 → 2023-12-31 (il SUO regime) | CRT gated (wick 2.0, mid 0, side 2, ADX(D1)≤30): il verdetto tick nel chop |

Ordine proposto: **B prima** (2 notti contro 4-5, e chiude una saga gia'
matura), poi A. Decide Claudio.

---

## 5. 🧰 GLI STRUMENTI CONSEGNATI (questo PASSO 0)

| file | cosa fa | stato |
|---|---|---|
| `backtest_pipeline/dukascopy/dukascopy_tick.py` | scarica finestra dichiarata di `.bi5`, decodifica, misura ordine campi + divisore, converte UTC→server (due calendari DST autotestati), scrive CSV tick MENSILI atomici + referto + raccolta Desktop/zip | **autotest 9/9 passato in cloud** (`--autotest`); ASCII puro; stdlib pura, python 3.8+ (gia' assunto da run_all.ps1) |
| `mql5/Scripts/ABTG_ImportaTickEsterno.mq5` | clona U30USD/NASUSD → `*_DK` (stessa catena di verifica proprieta' della v1 promossa 8/8), importa i CSV a blocchi con `CustomTicksReplace` (idempotente), SONDA coi criteri di 4a, referto CSV in coda | **BOZZA DICHIARATA: mai compilata** (come nacque la v2 M1). Il primo compile e' un passo del lancio |

Cosa NON e' stato provato, detto chiaro: **nessun `.bi5` vero e' passato da
questo script** (rete bloccata dal cloud, misurato) — per questo il
fail-fast e' ovunque: controllo positivo, ordine campi, divisore, banda.
E il `.mq5` va compilato e passato al verificatore con la riga.

---

## 6. ⚠️ RISCHI DICHIARATI (tutti, in fila)

1. **Rate limit** (sez. 2d): il rischio numero uno, con proiezione in log
   e piano a tranche. Se il ritmo non regge, la missione A si ridiscute.
2. **Fuso nelle settimane sfasate** (sez. 3): non chiuso; il discriminante
   e' congelato e la riconversione costa zero riscarichi.
3. **Feed diverso = mercato diverso**: Dukascopy e' un CFD/cash index suo,
   BCM il suo. La sonda misura QUANTO diverso; il cancello decide. Se non
   passa, i _DK vanno in frigo come gli _EXT — nessun "pero' quasi".
4. **Commissioni/slippage** restano quelli del tester (R55). Lo spread
   invece coi tick veri e' nei prezzi: dichiarato nel referto della sonda.
5. **iADX/iATR con handle su D1 NON popolano nel tester tick** (misurato
   30/08): il verdetto CRT sui _DK DEVE usare l'EA v3 (CopyRates). Vale
   per ogni EA con gate su TF alto.
6. **Bande prezzo tarate sulle missioni 2019+**: una finestra pre-2019
   (Nasdaq 2012 ~2500) esce di banda e lo script si ferma chiedendo
   `--divisore`. Voluto, non un baco.
7. **Tetto ~100k barre per corsa del tester**: M15 su 2 anni ≈ 50k barre
   (missione B ok); missione A su M15 ≈ 125k → **si spezza in tranche
   dichiarate** come da regola del 25/08.
8. **Disco**: ~10 GB per la missione A (2c). Verificare prima.
9. **Interruzione a meta'**: mesi CSV gia' scritti restano validi; il mese
   in corso si rifa' dalla cache. Import MQL5 idempotente
   (CustomTicksReplace per intervallo).

---

## 7. 📋 Etichette, in una riga

- **[MISURATO]** profondita' 2012 dei due simboli (sonda 15/08) · formato
  URL/mese zero-based/record 20B · ritmo ~4 min/giorno del 18/08 · +5
  piatto 8/8 forex · peggioramento 7,7-8,6% della cura DST EU · muro tick
  BCM 26/09/2024 · autotest 9/9 di `dukascopy_tick.py`.
- **[DOCUMENTATO]** date di partenza 2012-04-04 / 2012-06-14 (catalogo
  dukascopy-node, 31/08/2026).
- **[DERIVATO]** stime di volume/tempo (sez. 2c/2d) dalle ancore misurate.
- **[APERTO]** calendario DST del server nelle settimane sfasate (il
  discriminante e' pronto) · ritmo reale del crawl tick (proiezione in log).

**Nessun parametro degli EA in forward cambia per questo documento.**

---

## 8. 🚀 ADDENDUM 31/08 pomeriggio — IL BLOCCO ANTI-PYTHON e la CURA (motore curl, DUKA-TICK-v2)

**[MISURATO, PC di backtest Windows, 31/08 pomeriggio]** Il server
`datafeed.dukascopy.com` **strozza le connessioni di Python-urllib**
(WinError 10060/10054 + 503 a raffica, anche con User-Agent Mozilla) ma
**fa passare `curl.exe` e `Invoke-WebRequest`**: `curl.exe` sul canarino
`EURUSD/2025/05/16/15h_ticks.bi5` = **HTTP 200, 24043 byte**, mentre nello
stesso minuto lo script python moriva. E' **discriminazione dell'impronta
TLS**, non un ban dell'IP.

**La cura**: `dukascopy_tick.py` e' passato a **`DUKA-TICK-v2`** con
`--motore {urllib,curl}` (default urllib = storico; la riga di lancio v3
passa **sempre** `--motore curl`). La richiesta grezza via `subprocess` su
`curl`/`curl.exe`; **retry/backoff/contatori/log identici e condivisi** fra
i due motori. Autotest esteso a **10 controlli** (il decimo esercita il
motore curl contro un server HTTP locale: 200 con byte noti, 404,
503-poi-200).

**E la pipeline a valle e' SANA — gia' misurato**: nella corsa delle 15:18
(controllo positivo passato) il feed **Dow** era stato misurato: ordine
campi **`p1_ask`, coerenza 100% su 108108 tick**, **divisore 1000**
(mediana 42156 in banda). Va cambiato SOLO il motore di rete; nessun
numero DST/CSV/cache si tocca.
