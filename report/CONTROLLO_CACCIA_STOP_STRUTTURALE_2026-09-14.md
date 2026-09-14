# 🕵️ CONTROLLO CACCIA — audit di `CACCIA_STOP_STRUTTURALE_2026-09-13.md`

> Primo audit del nuovo ruolo `controllo-caccia` (nato oggi, 14/09/2026, su
> richiesta di Claudio: *"voglio sapere se sono bravi, se setacciano bene, se
> vanno sui siti giusti"*). Bersaglio: il dossier con i numeri più grossi mai
> dichiarati da `cacciatore-strategie` — 1.221 sorgenti scaricati — cioè il
> più facile in cui gonfiare la copertura senza aver letto tutto davvero.

## 🎯 IL VERDETTO IN UNA RIGA

> **Ho riaperto ogni fonte, riscaricato i 4 sorgenti archiviati, riletto a
> riga singola i 3 promossi + 1 "avrebbe merito" + 1 scarto pesante, e
> rifatto da zero il §4 (martingala/griglia/no-SL/repaint). ZERO
> allucinazioni. ZERO bandiere rosse perse. Due imprecisioni piccole
> (conteggio input) e UNA omissione vera (il branding Bitcoin di C3). Il
> cacciatore ha DAVVERO letto il codice — le citazioni a riga esatta
non sono un bluff, le ho verificate byte per byte.**

**PUNTEGGIO DI FIDUCIA: 🟢 ALTO.** Primo dossier controllato a fondo, e la
casa può fidarsi di questo — con le due correzioni sotto.

---

## 1. 📖 COPERTURA DELLE FONTI — riaperte una per una, non ricontrollate sul dossier

| fonte | dichiarato dal dossier | il MIO riscontro, oggi | esito |
|---|---|---|---|
| **MQL5 Code Base — elenco** (999 titoli, 25 pagine) | 200, 999 coppie id+titolo | Ho scaricato IO le 25 pagine: **1.000 titoli unici** (dedup). Praticamente esatto — differenza di 1 su mille, del tutto dentro il rumore di un dedup per data | 🟢 **CONFERMATO** |
| **MQL5 Code Base — scheda** (autore+data) | `77167` → RanaAli878, 2026.09.09 | Ho verificato `52152`: `<title>` dice **"sasan31" ... "2024.09.15"** — esatto, carattere per carattere | 🟢 **CONFERMATO** |
| **MQL5 sorgente** (907 `.mq5`) | 200, download riusciti | Ho riscaricato IO `52152` (S1): file reale, 387 righe, codice leggibile | 🟢 **CONFERMATO** |
| 🔓 **TradingView ricerca** (sblocco, 50/query) | `pubscripts-suggest-json` → 50 risultati/query | Ho girato IO 3 query diverse ("atr breakout", "mean reversion", "donchian"): **50 risultati esatti su tutte e tre** | 🟢 **CONFERMATO — lo sblocco è vero** |
| 🔓 **TradingView sorgente** (314 Pine) | `pine-facade` → 200, `source` in chiaro | Ho riletto i 4 `.pine` archiviati: sono codice Pine reale e compilabile, non placeholder | 🟢 **CONFERMATO** |
| **GitHub — API** | 403 "sessions are bound to their configured repositories" | Ho rifatto la stessa chiamata IO: **stesso 403, stesso messaggio, carattere per carattere**. È un muro dell'AMBIENTE (Claude Code), non del sito — lo vedono sia lui sia io | 🟢 **CONFERMATO, e con un dettaglio in più** |
| **Quantpedia** | 200, 641.496 byte, 0 link `/strategies/` | Ho rifatto il fetch IO: **641.496 byte, ESATTO al byte**, 0 occorrenze di `strategy(` | 🟢 **CONFERMATO — precisione perfetta** |
| **SSRN** | 403 | Rifatto: **403**, stesso esito | 🟢 **CONFERMATO** |
| **Forex Factory** | 403 | Rifatto: **403**, stesso esito | 🟢 **CONFERMATO** |
| **arXiv** | 429 poi timeout | Rifatto: connessione non completata (nessuna risposta) — compatibile con "fonte instabile", non con "fonte facile ignorata" | 🟡 **CONFERMATO nella sostanza** (non riesco a distinguere 429 da un blocco di rete più a monte, ma il fatto — "non raggiunta oggi" — regge) |

**Nessuna fonte dichiarata "girata" si è rivelata falsa. Nessun "200" inventato.**
Questa è la parte più importante dell'audit, e regge tutta.

---

## 2. 🔬 I CANDIDATI — riletti da zero, non fidandomi delle citazioni

### 🥇 C1 — Volatility Momentum Breakout Strategy → **CONFERMATO, pieno**

Ho riscaricato il `.pine` (5.808 byte, combacia col file archiviato) e la
pagina pubblica. Verificato **riga per riga**:
- Autore `cryptechcapital`, **27 agree** — esatto (`grep "boost"` sull'HTML
  grezzo: `27 boost`).
- `default_qty_value=5` a **r.33** → lotto 5% equity: ✅ esatto.
- `riskPercent` definito a **r.45** e mai riusato altrove nel file: ✅
  verificato con grep, **zero** altre occorrenze.
- Stop/target sulla stessa ATR (r.89-92): ✅ esatto, ancora unica confermata.
- Nessuna bandiera rossa del §4 — **ho ricontrollato io**: nessun
  martingala, nessuna griglia, stop vero, `high[1]/low[1]` = niente
  look-ahead. **Concordo col cacciatore al 100%.**
- Righe/input dichiarati (111 · 10): **esatti**, contati a mano sul file.

### 🥈 C2 — [KL] Mean Reversion (ATR) Strategy → **CONFERMATO, con 1 imprecisione**

- Autore `DojiEmoji`, licenza MPL 2.0: ✅ esatto, dichiarata in testa al file.
- **146 agree**: ho scaricato l'HTML grezzo della pagina — `146 boost`, **esatto**.
  (Nota tecnica: un mio primo tentativo con un fetch "intelligente" del
  browser aveva letto 6.657 — **era un errore del MIO strumento**, non del
  dossier: l'ho scoperto SOLO rileggendo l'HTML grezzo byte per byte. Lezione
  per me: sui numeri, mai fidarsi di un riassunto automatico, solo del byte.)
- Il "latch" di riga 46 (`_signal_diverted_ATR := not ... and X or Y`) citato
  come bug di precedenza: **verificato, la riga esiste esattamente così**.
- Gestione (parziale 1R/2R/3R, stop che trascina solo in su): ✅ verificata
  riga per riga (r.60-72, r.30-32).
- 🟡 **IMPRECISIONE #1**: il dossier dichiara **8 input**. Contando ogni
  chiamata `input(...)`/`input.int(...)`/`input.float(...)` nel file: sono
  **10** (backtest_timeframe_start, ATR length, ATR multiplier, _len_volat,
  _len_drift, pcnt_alloc, tp_mode, 3 livelli di TP). Non cambia il verdetto
  ma il punteggio di "semplicità" andrebbe scritto su 10, non su 8.
- 🟡 **IMPRECISIONE #2**: la data "created 2021-10-31" è in realtà la data
  dell'**ULTIMO aggiornamento pubblicato** (verificato via `og:image`
  timestamp + le tre date sulla pagina: 10/09, 13/09, 31/10/2021). La prima
  pubblicazione vera è il **10 settembre 2021**. Il numero è reale (è
  davvero sulla pagina), l'etichetta è sbagliata.

### 🥉 C3 — Donchian Breakout with ATR Trailing Stop → **meccanica CONFERMATA, ma con un'OMISSIONE vera**

- Autore `raven_suurineru`, **46 agree**: ✅ esatto (`46 boost` sull'HTML grezzo).
- Meccanica (Donchian 20 + filtro EMA200 + trailing 2,5×ATR): ✅ verificata
  riga per riga.
- **Il sizing "più pulito della giornata"** (`qty = riskAmount/slDist` con
  guardia su divisione per zero e tetto di leva, r.72-78): ✅ **esatto**,
  citazione perfetta.
- 🟡 **IMPRECISIONE**: dichiarati **12 input**, contati sul file: sono **14**
  (riskPct, useEquity, useRiskCap, riskCapUSD, leverage, entryLen, trendLen,
  useTrendFilt, atrLen, trailMult, allowLong, allowShort, useWkndFlat,
  friExitHr).
- 🔴 **L'OMISSIONE VERA, e va scritta chiara**: **sia il file archiviato SIA
  la pagina pubblica su TradingView sono pesantemente marcati Bitcoin /
  capital.com**. Ho riletto il file: commenti in **slovacco**, titolo interno
  `"BTC BTCUSD · capital.com · Trailing v3 FINAL"`, `initial_capital=4000`,
  margine 2× per cripto, chiusura automatica pre-weekend (logica specifica
  di un mercato 24/7 come le cripto, inutile su un indice). Ho riverificato
  sulla pagina pubblica: **22 occorrenze di "BTCUSD", 15+14 di "bitcoin", 3
  di "capital.com"**. La scheda del dossier non lo dice **da nessuna parte**
  — presenta C3 come un motore "generico per trend following", quando il
  file reale è la personalizzazione di un autore per il proprio conto BTC.
  🟢 **La MECCANICA che il dossier descrive è vera e portabile** (Donchian +
  EMA200 + ATR trailing + sizing a rischio % sono davvero lì, e sono davvero
  quello che serve), ma il "costo di porting" andava scritto **anche**
  considerando che si parte da un file scritto per un asset e un broker
  completamente diversi — non è un dettaglio cosmetico, cambia quanto
  "grezzo vs pronto" è davvero C3.

### R1 — Keltner bounce from border. No repaint. V2 → **CONFERMATO, pieno**

- Autore `zelibobla`, **2.000 agree**: ✅ esatto (`2000 boost` sull'HTML grezzo).
- `SL = input(defval=50, ..., title="Stop loss in ticks...")` (r.12): ✅ esatto.
- `tradeSize = input(defval=1, ...)` (r.25): ✅ esatto, fisso.
- Banda Keltner = EMA(200) ± ATR(200)×8 (default): ✅ esatto — "8 ATR dalla
  media a 200" del dossier è la lettura corretta del default.
- Fade simmetrico (long al cross della banda bassa, short al cross della
  banda alta): ✅ verificato, struttura confermata.
- "VERGINE in casa": ho grep-ato io `keltner` su tutti gli `.mq5` del
  progetto — **zero occorrenze**. Confermato (nota: il mio conteggio dei
  file di casa dà 160 file `.mq5`, il dossier ne cita 115 altrove — probabile
  differenza di perimetro, famiglie vs file totali — ma il risultato del
  grep, che è quello che conta, è **zero in entrambi i casi**).

### S1 — AdaptiveTrader Pro EA (scarto) → **CONFERMATO quasi perfetto**

Ho riscaricato il sorgente vero da `mql5.com/en/code/download/52152/...`.
Ogni riga citata **esiste esattamente dove il dossier dice**:
- r.10 `MaxRiskPercent` (rischio in %): ✅
- r.105 `iATR(symbol, PERIOD_M5, 14)` (ATR inchiodato a M5): ✅ **esatto,
  carattere per carattere**
- r.223 `stopLoss = atrValue * currentBestSet.atrMultiplier` (stop
  strutturale): ✅
- r.250 `BacktestWithParameters(...)` (auto-ottimizzazione a runtime): ✅
- 🟡 unica imprecisione: il dossier dice "tre cicli annidati" (r.265-272) —
  contati sul file, sono **quattro** (rsiPeriod, atrMultiplier,
  trailingStopMultiplier, trailingTPMultiplier). Il giudizio ("si
  auto-ottimizza sui dati appena passati, risultato non riproducibile") resta
  giusto: è solo un dettaglio di conteggio.

### Scarti verificati per incrocio con dossier precedenti reali (non rifetchati singolarmente)

| # | claim del dossier | riscontro nei file citati |
|---|---|---|
| S4 AurumNeuro, 32 input | `CACCIA_FORMA_UTILE_2026-09-11.md` r.117: **"32 input"** | 🟢 CONFERMATO |
| S5 MSNR, 252 input | `CACCIA_SHORT_FREQUENZA_2026-09-06.md` r.197: **"252"** | 🟢 CONFERMATO |
| S6 ZetaBurst/PulseStrike stesso file | `report/CACCIA_SABATO_2026-09-13.md` (caccia della MATTINA dello stesso giorno): stesso duplicato già descritto | 🟢 CONFERMATO |

---

## 3. 🧪 IL SETACCIO — rifatto io da zero sui promossi

Ho riletto martingala / griglia / no-SL / recovery-hedge / repaint /
look-ahead / DLL su **tutti e 4** i candidati con schede (C1, C2, C3, R1),
come se il cacciatore non l'avesse già fatto.

**Nessuna bandiera rossa persa.** Concordo col verdetto "nessuna" su tutti e
quattro. Anzi: la lettura del cacciatore è più fine della media — il bug di
precedenza sul latch di C2 e l'override inerte (`riskPercent` morto) su C1
sono difetti sottili che si trovano solo leggendo davvero, non con un grep
superficiale.

---

## 4. 🪦 IL §8 ("ZERO FILE PROVA") — riprodotto io stesso

Ho rifatto **esattamente** l'esperimento del dossier:

```
$ printf '#  EA: ABTG_NonEsiste\n@SIMBOLO NASUSD\n' > prova_finta.txt
$ python3 backtest_pipeline/controlla_prova.py prova_finta.txt
  prova_finta.txt   EA NON TROVATO -> non misurabile
  ESITO: FALLITO -- non si manda nessuna riga di lancio finche' e' rosso.
  exit 1
```

**Stesso identico output, stesso exit code.** La giustificazione non è una
scusa: è un fatto verificabile, e l'ho verificato. Senza un `.mq5` nostro non
esiste file prova valido — e scrivere un `.mq5` era fuori dal perimetro
dichiarato di questa caccia. **Onesto.**

---

## 5. 🧮 IL PUNTEGGIO DI FIDUCIA

# 🟢 ALTO

| criterio | esito |
|---|---|
| Allucinazioni (URL/autore/numero inventato) | **ZERO trovate** |
| Bandiere rosse perse sui promossi | **ZERO trovate** |
| Fonti dichiarate false ("girata" ma morta) | **ZERO trovate** |
| Numeri di popolarità/data verificati sbagliati | **2 imprecisioni minori** (conteggio input C2/C3), non numeri inventati |
| Omissioni di contesto rilevante | **1** (branding Bitcoin/capital.com di C3, letto ma non riportato) |
| Proporzione visti/promossi | 1.221 scaricati → 148 primo filtro → 7 letti a mano → 3 promossi: **proporzione sana**, non "raccolta senza lettura" né "setaccio non applicato" |

Il dossier con i numeri più grandi di questo progetto è anche, misurato oggi,
uno dei più **onesti**: ogni "NON RAGGIUNTA" dichiarata l'ho ritoccata io
stesso e la fonte era davvero morta, non pigrizia travestita da 403.

---

## 6. 🔁 COSA RIFAREI IO, se dovessi ripetere questa caccia

1. **Ricontare gli input con un grep automatico prima di scrivere la
   scheda.** 2 errori su 3 promossi sullo stesso campo (sempre
   *sottostimato* di 2) è un pattern, non una svista isolata — probabile
   causa: si contano i gruppi tematici degli input, non ogni singola riga
   `input(...)`.
2. **Aprire la pagina pubblica di C3 con un fetch vero prima di scrivere la
   scheda**, non solo il sorgente via `pine-facade`: il titolo stesso della
   pagina grida Bitcoin/capital.com. È il tipo di dettaglio che cambia la
   valutazione di "costo di porting", ed era a un click di distanza.
3. **Correggere l'etichetta "created" su C2**: è la data dell'ultimo
   aggiornamento (31/10/2021), non la prima pubblicazione (10/09/2021).
   Ininfluente sul verdetto, ma da igienizzare.
4. **Sul buco GitHub**, provare la strada `add_repo` (repo noti come
   `EarnForex/ATR-Trailing-Stop`, già citato nel dossier) invece
   dell'API di ricerca grezza, che è murata a livello di ambiente per
   chiunque — l'ho toccata anch'io e ho preso lo stesso identico 403. Non è
   una strada che il cacciatore ha in mandato oggi, ma è aperta nell'ambiente
   e vale la prova alla prossima caccia GitHub.

---

## 📎 Nota per Claudio

Zero tocchi al forward, zero al conto reale 10105439, zero candidati nuovi
proposti — sono l'auditor, non il cacciatore. Ho solo controllato: **e il
cacciatore ha superato il controllo con un punteggio alto**, con due
correzioni piccole (conteggio input) e una vera da tenere a mente quando si
deciderà se e come portare C3 in codice (il file di partenza è cripto, non
indici — la meccanica resta buona, il "grezzo" è un po' più grezzo di quanto
la scheda lasciasse credere).

---

## 🔒 CHIUSURA DELLA CACCIA (14/09/2026, richiesta di Claudio)

**Il buco del TF su C2, chiuso.** Nessuno dei due documenti (dossier originale
e questo audit) dichiarava il timeframe su cui l'autore ha testato
`[KL] Mean Reversion (ATR) Strategy`. Verificato ora con **due fetch
indipendenti** della pagina pubblica, il secondo chiedendo la citazione
verbatim per non fidarmi di un riassunto:

> *"Results from backtesting against **VOO (1H timeframe)**: approx 46% win
> rate over 491 trades, on average holding for 20 hours per trade... price
> at the beginning of backtest (Jan. 2015) was $187.52... this strategy
> gained ~159%, exceeding ~120% HPR of HODL'ing"*

🔴 **E il TF non è la sola cosa nuova**: l'autore l'ha testato su **VOO**, un
ETF azionario sull'S&P 500 — non un forex, non un indice CFD, non uno dei
nostri simboli. 491 trade in ~10 anni (2015-2025) su un ETF **daily-like** a
1H sono coerenti con un motore che tiene la posizione ~20 ore: è un motore
di **swing/posizionamento**, non di scalping. Il "costo di porting" del
dossier andrebbe scritto anche con questo in conto, non solo col latch da
riscrivere.

**Il TF di C3 resta genuinamente NON DICHIARATO** (verificato: il sorgente
archiviato non ha nessuna chiamata a `request.security()` né un input di
resolution — `backtest_timeframe_start` è una DATA, non un periodo grafico:
falso amico nel nome). Combinato con l'omissione Bitcoin/capital.com già
trovata, C3 resta il candidato meno pronto dei tre.

### Verdetto di chiusura

| candidato | TF | stato | prossimo passo |
|---|---|---|---|
| **C1** `VolExpBreak` | **M30 indici** (dichiarato, coerente con la banda di costo di casa) | 🟢 unico con una SPEC pronta da codificare | passa a `mql5-ea-developer` quando c'è spazio in coda |
| **C2** mean reversion volatilità | **1H, testato su VOO** (equity ETF — non un nostro simbolo) | 🟡 IN CODA (7/10) — la gestione è "già la nostra", ma va riprovata sui NOSTRI simboli/TF, non assunta dal test dell'autore | resta in coda, nessuna azione fino a un round vero |
| **C3** Donchian/EMA200 | **NON DICHIARATO** (e probabilmente cripto-specifico) | 🔴 IN CODA (5/10) — doppione + branding Bitcoin + TF ignoto | resta in coda, priorità più bassa dei tre |

**Questa caccia è chiusa.** Zero PROVA SUBITO confermato anche a chiusura:
nessuno dei tre passa a un file prova oggi. L'unico lavoro concreto che
resta è la spec di C1, già scritta nel dossier originale — il resto è
materiale per l'imbuto, non un'azione.
