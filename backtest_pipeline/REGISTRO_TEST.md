# REGISTRO TEST EA — DAX / Nasdaq / Oro
_Documento vivo: aggiornato ad ogni nuovo backtest. Pensato anche per condividere i parametri con Emiliano e farsi consigliare._

## Contesto fisso (per tutti i test)
- **Conto:** DEMO BCM Markets 50503392, tipo **HEDGING**. Server **BCM = ora italiana − 1** (DAX apre 08:00 server, Nasdaq 14:30 server).
- **Periodo backtest:** 01.01.2024 → 30.06.2026 (2,5 anni).
- **Deposito:** 10.000 €. **Rischio per trade:** 1% (per confronto pulito; in live si alza dopo forward).
- **Modelli:** *OHLC 1-min* = screen veloce (affidabile su H1/H4, ottimista su M5/breakout intraday). *Real tick* = verità (obbligatorio per validare).
- **Criterio ottimizzazione:** Recovery Factor.
- **Regola:** gli `_Ottimizzato` girano in parallelo agli originali (magic diversi). NIENTE hedging/martingala.

---

## 1) APERTURE (breakout apertura mercato)

| # | EA | Sym | TF/finestra | Config chiave | Modello | Risultato | Verdetto |
|---|---|---|---|---|---|---|---|
| A1 | DAX_Apertura_EU | D30EUR | range 15 min, ora 8 | **entrambe + Supertrend ON**, buffer 200-600, floor 200 | real tick | 3% combo pos, best PF 1.03 | 🔴 morto (config sbagliata) |
| A2 | DAX_Apertura_EU | D30EUR | range 15 min, ora 8 | **SOLO LONG, ST OFF**, buffer 600, floor 200 | real tick | **PF 1.49 (avg 1.25), DD 3.8%, 314 tr**, cluster 100% pos | 🟢 **KEEPER** |
| A3 | DAX_Apertura_EU | D30EUR | range 15 min, ora 8 | **SOLO SHORT**, ST OFF, buffer 200-600 | real tick | — | ⏳ in coda |
| A4 | Nasdaq_Apertura_US | NASUSD | candela H1 prec, ora 14:30 | **SOLO LONG**, floor 0-400, buffer 50-350 | real tick | 0% combo pos, best PF 0.91 | 🔴 morto |
| A5 | DAX + Nasdaq "stile Monza" | D30EUR/NASUSD | candela 5-min pre-apertura | **direzione ADATTIVA Supertrend D1** + filtro 17-40 pt + floor | real tick | — | ⏳ in coda |

**A2 = configurazione vincente DAX aperture (da discutere con Emiliano):**
`Ora apertura 8:00 server | Range 15 min | Buffer 600 pt (6 punti indice) | SOLO LONG | Supertrend OFF | Floor SL 200 pt | Slippage 100 pt | Rischio 1%`
→ già messa nell'EA `ABTG_DAX_Apertura_EU_Ottimizzato` (magic 770111).

---

## 2) LIVE 5 MINUTI (rottura candela pre-apertura)

| # | EA | Sym | Config | Modello | Risultato | Verdetto |
|---|---|---|---|---|---|---|
| L1 | DAX_Live5m (orig.) | D30EUR | buffer 700, entrambe | real tick | 27/27 combo NEGATIVE | 🔴 morto |
| L2 | Nasdaq_Live5m (orig.) | NASUSD | buffer 700, entrambe | real tick | 27/27 combo NEGATIVE | 🔴 morto |
| L3 | DAX_Live5m_v2 | D30EUR | +floor +slippage +range filter (32 combo) | real tick | best PF **1.04** DD ~10% (solo con Supertrend ON + PrevWin15); resto negativo, DD 15-26% | 🔴 morto |

_Nota: in OHLC i Live5m davano numeri finti enormi (+129k DAX, +30k Nasdaq). In real tick: morti. Lezione: M5/breakout → OHLC inganna._

> **VERDETTO DEFINITIVO — capitolo BREAKOUT M5 CHIUSO (26.07.26).** Provati e morti in real-tick: Live5m nativo, Live5m_v2 (ricetta migliorata), DAX_M3, aperture Nasdaq, ORB_Fibo, Londra_ORB. Il breakout in apertura su M5 NON ha edge sul tick vero. **Non costruire altri v2 M5.** L'edge sta su H1/H4 (SupRev) e sull'apertura DAX LONG (che è M5 ma su livello H1, non breakout M5).

---

---

## 2-bis) FIBO H4 — il "0/8" e' UN NUMERO SOLO, CONTATO OTTO VOLTE (trovato il 21/08/2026)

| # | EA | Sym | Risultato in archivio | Verdetto |
|---|---|---|---|---|
| F1 | FiboH4_Multi | 8 coppie forex+oro H4 | **0/8 promossi** (coda fascia B, 10-11/08) | 🔴 bocciato allora, e **il numero resta** |

🔴 **MA il banco era rotto, ed e' misurato.** `ABTG_FiboH4_Multi` e'
**multi-simbolo**: opera su `InpSymbols`, non sul simbolo del grafico. Il file
prova scriveva `InpSymbols=` **vuoto** con sopra la nota *"il pin sotto e'
OBBLIGATORIO"* — e **MT5 ignora un pin di stringa vuoto**, usando il default
compilato. Nei 16 CSV in archivio la colonna `InpSymbols` dice
`GBPUSD;USDJPY;EURUSD` in **tutte** le passate, e **7 file su 8 danno lo stesso
numero al centesimo** (IS da −384,56 a −394,13 / OOS da +116,17 a +118,68).
➡️ Quel "0/8" e' **una configurazione bocciata, contata otto volte**.

🔵 **E non ha mai giudicato la strategia del corso.** Le tre divergenze di
geometria (18/08): distanza ordini **~x10**, target **x2,1**, stop **~x4**.
➡️ **R93** (bozza `risultati_archivio/R93_CRITERI.md`, decisione di Claudio del
21/08 *"1,2,3 si guardano"*) rimisura in due gambe: **A** il filtro news sul
nostro EA, **B** la geometria del corso con `ABTG_FiboH4_Corso.mq5` (nuovo).

🛠️ **Corretto per non ripeterlo:** `scan_market.ps1` (blocco FiboH4) ora usa il
segnaposto `__SYM__`; e c'e' `backtest_pipeline/controlla_prova.py`, che il pin
vuoto lo trova **prima** di svegliare MT5.


## 3) ORB e altri breakout indici (screen OHLC + direzione L/S)

| # | EA | Sym | Miglior config | Risultato | Verdetto |
|---|---|---|---|---|---|
| O1 | ORB | NASUSD | EntryPoints 20, TP_R 2.5, entrambe | real tick: 50% pos, best PF 1.15, DD 16%, 625 tr | 🟡 marginale |
| O2 | ORB_Fibo | NASUSD | — | OHLC 29% pos | 🔴 morto |
| O3 | DAX_M3 | D30EUR | — | OHLC 33% pos, short 0% | 🔴 morto |
| O4 | Londra_ORB | GBPUSD | — | OHLC 11% pos, DD 23% | 🔴 morto |

---

## 4) SUPERTREND REVERSAL portato su indici (screen OHLC 1-min)
_Strategia = trend + rimbalzo (NON breakout). Su oro fa PF 3.17. Ottimizza StMult / StAtrPeriod / TP_RR, rischio 1%._

| # | Sym | TF | Risultato | Verdetto |
|---|---|---|---|---|
| S1 | DAX (D30EUR) | **H1** | **66% combo pos**, best +2254 PF 1.48 (419 tr) / +1955 **PF 2.01 DD 4.0%** (239 tr), 67 combo con PF>1.2 | 🟢 **grande candidato** (da validare real tick) |
| S2 | DAX (D30EUR) | M5 | 0% pos, DD 30-37% | 🔴 morto |
| S3 | Nasdaq (NASUSD) | H4 | 43% pos ma best solo 15-19 trade | 🟡 pochi trade, inaffidabile |
| S4 | DAX (D30EUR) | **H4** | 55% pos, 68 combo PF>1.2; best +1196 PF 1.64 DD 6.6% (181tr), fino a PF 3.34 (85tr) | 🟢 edge robusto |
| S5 | Nasdaq (NASUSD) | **H1** | 47% pos, **58 combo PF>1.2**; best **PF 1.79 DD 0.9% 135tr**, cluster PF 1.66-1.79 DD ~1% | 🟢 edge pulito |
| S6 | Nasdaq (NASUSD) | M5 | 5% pos, best PF 1.10 DD 11.5% | 🔴 morto |

**SCOPERTA INDICI (da validare in real tick, poi forward):**
- `SupertrendReversal DAX **H1**` | StMult 3.0 / AtrP 9-10 / TP_RR 3.0 → PF 1.5-2.0, DD 4%, **419 tr**
- `SupertrendReversal DAX **H4**` | StMult 3.0 / AtrP 8-9 / TP_RR 3.0 → PF 1.6-2.6, DD 3-7%, 85-181 tr
- `SupertrendReversal Nasdaq **H1**` | StMult 3.0-3.5 / AtrP 10 / TP_RR 3.0 → PF 1.66-1.79, **DD ~1%**, 135-155 tr
- M5 morto su entrambi. H4 Nasdaq pochi trade.

### ✅ VALIDAZIONE REAL-TICK (26.07.26) — CONFERMATA, promossi a _Ottimizzato
_Griglia stretta StMult 3.0/3.5 × AtrP 9/10 × TP_RR 2.5/3.0, rischio 1%, tick reali._

| # | Sym | TF | Config vincente | Profit | PF | DD% | Trade | EA creato | Magic |
|---|---|---|---|---|---|---|---|---|---|
| S1v | DAX (D30EUR) | **H1** | StMult 3.5 / AtrP 10 / TP 3.0 | 1075 | **1.45** | 5.6% | 223 | `ABTG_SupRev_DAX_H1_Ottimizzato` | 970911 |
| S4v | DAX (D30EUR) | **H4** | StMult 3.0 / AtrP 9 / TP 3.0 | 781 | **1.96** | 5.7% | 86 | `ABTG_SupRev_DAX_H4_Ottimizzato` | 970912 |
| S5v | Nasdaq (NASUSD) | **H1** | StMult 3.0 / AtrP 10 / TP 3.0 | 479 | **1.57** | **1.17%** | 155 | `ABTG_SupRev_NAS_H1_Ottimizzato` | 970913 |

- **DAX H1:** solo StMult **3.5** in positivo (4/8); StMult 3.0 tutte negative. Plateau pulito sulle 3.5.
- **DAX H4:** 6/8 positive; 3.0/AtrP9 miglior profitto, 3.5/AtrP10 miglior DD (3.5%).
- **Nasdaq H1:** **8/8 positive**, DD ~1-2.4%. Il più forte: prop-friendly. ⭐
- CSV archiviati: `valid_SupRevRT_D30EUR_H1/H4.csv`, `valid_SupRevRT_NASUSD_H1.csv`.

---

## 5) ORO (baseline già validati — spina dorsale)
| EA | Sym | TF | PF | Note |
|---|---|---|---|---|
| SupertrendReversal_Multi | XAUUSD | H4 | **3.17** | migliore in assoluto |
| EMA200 | XAUUSD | — | 1.92 | 100% combo pos |
| GoldenCross | XAUUSD | — | 1.58 | |
| SupertrendReversal | XAUUSD | H4 | 2.74 | |

---

## SPUNTI DALLA LIVE DI EMILIANO MONZA (17.07.26, apertura Nasdaq)
**Da usare:**
- Direzione decisa PRIMA dal trend Weekly/Daily + correlazione S&P → opera solo in quella direzione (→ test A5 stile Monza).
- Filtro ampiezza candela **17-40 punti** (sotto=whipsaw, sopra=stop troppo largo).
- Ordine a **7 punti** oltre max/min della candela 5-min pre-apertura.
- ORB: volumi in crescita alla rottura + EMA 9/21 allineate + ingresso sul **retest** se apre lontano.
- Parziale 50% a ~20 punti + stop in pari.

**Da NON usare (pericoloso):**
- Piano B/C = hedging/martingala (raddoppio contro la perdita). È ciò che gli ha causato −500k / −1,4M di drawdown. Escluso.

---

## DOMANDE PER EMILIANO (bozza)
1. Sul **DAX aperture** conviene davvero solo-LONG, o la direzione adattiva (Supertrend Daily) rende di più anche prendendo gli short nei giorni ribassisti?
2. Buffer: 7 punti fissi o proporzionale all'ATR/ampiezza candela?
3. Filtro ampiezza 17-40: valori confermati anche sul DAX o solo Nasdaq?
4. Sul **Nasdaq** l'aperture da solo non ha edge nei nostri test: quali filtri aggiuntivi usi tu (correlazione, imbalance, livelli) che possiamo automatizzare?
5. Il SupertrendReversal su **DAX H1** ci dà PF ~1.5-2.0: ha senso come "core" indici o preferisci sempre l'apertura?

---
_Ultimo aggiornamento: dopo i test aperture real-tick + SupertrendReversal indici (parziale). Mancano: A3, A5, S4/S5/S6, DAX short._

---

# REGOLE EMILIANO MONZA — sintesi da 18 live (apertura DAX)
_Estratte da 18 trascrizioni (mattina DAX + qualche serale + 1 di Paolo). Distinte: RICORRENTE (in più live) = affidabile / ONE-OFF = detto una volta. Le live sono quasi tutte DAX; sul Nasdaq quasi nulla (vedi sezione dedicata)._

## A. Orari (ora italiana; server BCM = −1)
- **RICORRENTE** DAX apre 09:00 IT (08:00 server). Studio pre-apertura su D1/H4/H1 prima.
- **RICORRENTE** **ORB = prima candela M15, 09:00-09:15 IT** (08:00-08:15 server). Si opera **dalle 09:15**.
- **RICORRENTE** Chiusura **sempre in giornata, MAI overnight** (una overnight = 50k € di swap).
- Bassa volatilità 11:00-12:00; ECB/Lagarde parla alle 09:00 (muove DAX/EURUSD).

## B. Direzione (la cosa più martellata — "prima di tutto: long o short?")
- **RICORRENTE** La direzione la dà il **Daily**: struttura max/min crescenti (long) o decrescenti (short) + **forza delle ultime 3 candele** + "metà candela" = livello che invalida.
- **RICORRENTE** **Correlazione S&P500 (H1): il DAX segue l'S&P** ("il DAX non parte se non parte l'SMP"). EUR/USD correlato al DAX; USD/JPY all'S&P; di notte guida il Nikkei/Japan.
- **RICORRENTE** Livelli S/R su **D1 + Weekly**: "1 sopra e 1 sotto il prezzo, non 2000 linee". Open Weekly = spartiacque.
- Opera **solo in direzione del bias** ("battezzatura"); controtrend a metà size o niente.

## C. Ingresso
- **RICORRENTE (CENTRALE)** ORB: si entra alla rottura del max/min della candela M15 **SOLO se**: (1) la candela **chiude col corpo fuori dal range** (non solo spike), (2) **volumi ≥ +50% / 1,5× la media(20)**, (3) **medie 9/21 inclinate** nella direzione. Se apre lontano dal livello → **entra sul RETEST**, mai inseguire.
- **RICORRENTE** Max/min della notte: ordine pendente a **10 punti** oltre (indici).
- Se un livello viene "sfiorato" la prima volta → sposta l'ordine (la 2ª volta rompe). 2° tocco = più probabile la rottura (setup A+).

## D. Filtri e DIVIETI
- **RICORRENTE** Niente ingresso su rottura **senza volumi** (= fake breakout).
- **RICORRENTE** Niente trade se **range troppo ampio / stop troppo largo** (ORB tardivo con canale ~140 pt → skip).
- **RICORRENTE** Blackout **news**: 11:00 e 14:30 IT (CPI/PPI) + ECB 09:00 → **cancella i pendenti**. No giorni FOMC/NFP.
- Vietato "terra di nessuno" (metà candela) e inseguire i prezzi.
- **Declassano il setup** (5 ostacoli): media 200 H1, VWAP, S/R, pre-section, numero tondo.

## E. Stop / Target / Gestione
- **RICORRENTE** Stop DAX tipico **~40 punti**, messo **sotto media/Supertrend/minimo** (5-10 pt oltre), MAI dove c'è la liquidità retail. ATR(14) come metodo base. La **size si calcola dallo stop** (~1 €/punto per contratto).
- **RICORRENTE** RR **1:1 → 1:2**. Target: numeri tondi, VWAP, max/min notte, chiusura gap. 1° obiettivo ~30 pt o media 50.
- **RICORRENTE** **Parziale 50% + stop in pari dopo ~20-30 punti.** Trailing sotto medie/Supertrend.
- **RICORRENTE** Money management **1/3 + 2/3** (il 2/3 deve essere eseguito → su livelli price action, distanza ≥20 pt dal 1°).
- **Stop temporale** (Dr. Mind): trade >6 min sospetto, ~33 min chiudi. "Se entri bene, esci veloce".

## F. Indicatori e SETTAGGI ESATTI
- **Bollinger:** DAX/giorno **37 / dev 3** ("37,3"); valute **20 / 2**; pre-apertura/notte/laterale **20 o 22**.
- **Medie:** 200 (istituzionale, MAI da sola → sempre con S/R), 100, 89, 50, 21, 14, 9. ORB usa **9 e 21** inclinate.
- **Supertrend:** 3 livelli, il **3° è il più importante**; es. **mult 3.5 / ATR 10**; livelli D1 e Weekly.
- **VWAP M15** (volatility-weighted, custom) = filtro direzionale: sopra=long, sotto=short.
- **Volumi:** media **20** (o 50), soglia **≥ +50% / 1,5×** per validare la rottura.
- **ATR(14)** per lo stop. Rischio **1-2%**.

## G. NASDAQ (poco materiale — importante saperlo)
- Nelle 18 live **quasi NIENTE sul Nasdaq**: le live pomeridiane USA non c'erano.
- Emiliano **EVITA il Nasdaq vicino alle trimestrali (earnings)**: troppo sensibile/volatile; di notte preferisce l'S&P.
- **Differenza prezzi tra broker più marcata sul Nasdaq** → i livelli notte vanno letti sul PROPRIO broker.
- Traduzione per noi: sul Nasdaq il breakout aperture è debole (test lo confermano). Meglio (a) filtro correlazione + evitare earnings, oppure (b) puntare sul **SupertrendReversal H1** (da validare).

## H. DA NON AUTOMATIZZARE (pericoloso / discrezionale)
- **Hedging/"edging"** e **martingala/prezzo medio** (raddoppio contro la perdita) → è ciò che gli ha fatto −500k/−1,4M. ESCLUSO.
- Reversal discrezionale, scalping M1/M3, overnight, letture "a sentimento", size aggressive su conto grande.

---

## MODIFICHE CONCRETE DA FARE AGLI EA (priorità)
1. **Filtro VOLUMI alla rottura** (≥1,5× media 20) — è il filtro anti-fake più ripetuto. NON ce l'abbiamo nell'aperture → **da aggiungere nel codice**. [alta priorità]
2. **Filtro VWAP M15** direzionale — da aggiungere. [alta]
3. **Direzione adattiva D1 (Supertrend) + correlazione S&P** — gli input ESISTONO già (`InpUseSupertrend`+`InpStTF=D1`, `InpUseCorrelation`+`SPXUSD`) → **solo da testare** (parzialmente nel test "Monza" A5). [media, già avviata]
4. **Blackout news 11:00/14:30** — input `InpUseNewsFilter` già presente → caricare `abtg_news.csv` e attivarlo. [media]
5. **Filtro ampiezza candela** (relativo/17-40) — input `InpMinRangePts`/`InpMaxRangePts` già presenti → testare. [media]
6. **Conferma "chiusura corpo fuori range" + retest** invece del solo pending-stop — modifica al motore. [bassa, complessa]

_Ultimo aggiornamento: consolidate le 18 live di Emiliano. Prossimo: aggiungere filtro volumi + VWAP al motore aperture e ri-testare._

---
## AGGIORNAMENTO — motore aperture con filtri Emiliano
- Aggiunto al codice degli EA aperture (+ _Ottimizzato + Live5m_v2) il **filtro VOLUMI** (`InpUseVolumeFilter`, `InpVolMult`, `InpVolAvgBars`): entra solo se il volume della rottura ≥ mult × media. Default OFF (nessun impatto finché non attivato).
- Nuovo test **A6 — DAX Apertura "motore Emiliano"** (`valid_DAX_Apertura_Emiliano`): real tick, 48 config, variando Buffer(400/600/800) × Direzione(solo-LONG / entrambe) × Supertrend-D1(off/on) × FiltroVolumi(off/on) × VolMult(1.5/2.0). Base fissa: ora 8, range 15, floor 200, slippage 100, rischio 1%. → ⏳ da lanciare (`rilancia_dax_emiliano.ps1`). Risultati in `risultati_dax_emiliano\`.
- Cartelle nuove: `docs/live_paolo/` (trascrizioni Paolo) e `backtest_pipeline/risultati_archivio/` (archivio CSV per progetto; indice = questo file).
- TODO prossimo: filtro VWAP M15 (per gestione/direzione), da aggiungere dopo aver validato il filtro volumi.

---
# REGOLE PAOLO — sintesi (6 live; NB: strategie diverse dall'apertura)
_Paolo fa soprattutto **forex swing/reversal** (Super Trend Inverte, Fibonacci, Bollinger, Wyckoff/Volume Profile). NON fa breakout in apertura. Estratto solo ciò che serve come FILTRO ai nostri EA._

## Filtri AUTOMATIZZABILI utili (nuovi rispetto a Emiliano)
- **Filtro distanza/ADR (importante per l'apertura):** NON entrare se al segnale il prezzo è **troppo lontano** dal livello di rottura (minimo notte/range): movimento già impulsivo → il retest lo supera. Confronto distanza vs **ADR giornaliero**. Il retest è affidabile solo se **vicino** al livello (es. scartare se >50 punti). → mecanizzabile.
- **ADX(14)** soglie **20 / 25 / 50**: <20 laterale (no trade), >25 forza, ~50 esaurimento. Filtro di forza (non direzione).
- **Medie ordinate 14/50/200 + posizione vs EMA200** come conferma trend (14>50>200 long / 14<50<200 short).
- **Std Dev in espansione** (uscita da compressione Bollinger) come conferma di breakout vero.
- **Imbalance/FVG:** se la candela successiva **chiude DENTRO** l'imbalance → rientro (gap richiuso); se chiude **FUORI** → prosecuzione.

## Conferme importanti (allineate ai nostri test)
- **Volumi affidabili SOLO sugli indici** (regolamentati), NON sulle valute → il nostro filtro volumi sugli indici (DAX/Nasdaq) è legittimo. ✅
- **DAX più debole dell'S&P** → se l'S&P scende, il DAX scende di più (direzione da correlazione S&P). ✅ (come Emiliano)
- Apertura considerata **"pericolosa"** se pre-apertura ha già fatto un movimento impulsivo forte → coerente col filtro distanza/ampiezza.

## Da NON automatizzare (Paolo)
- Gestione/parziali "a sentimento", Wyckoff (accumulo/distribuzione), lettura swing/BOS discrezionale, PTE (iperestensione, molto soggettiva), VWAP/volumi letti a occhio.

## Idea EA futura (bassa priorità)
- **Filtro ADR/distanza** da aggiungere al motore aperture: skip se il prezzo alla rottura è troppo lontano dal livello (o se l'ampiezza pre-apertura > X% dell'ADR). Riduce i falsi breakout impulsivi. Da valutare dopo il filtro volumi.

---
# REGOLE MARCO GARBUGLIA — audio (crea EA, obiettivo prop)
## Metodo (= quello che stiamo costruendo)
- Ogni EA con set di **filtri toggle ON/OFF + valori regolabili a mano**: **RSI** (momentum E ipercomprato/ipervenduto), **ADX**, **ATR**, **media mobile** (long/short vs MA, periodo config), **incrocio medie** (9>21, entrambe>200), **Supertrend**.
- Partire con **tutti i filtri OFF**, attivarne **uno alla volta** (parte da RSI) → trovare la combo ideale.
- Prima della consegna: **verificare tutte le combinazioni, evitare conflitti/paradossi**, ricontrollare il codice 2 volte.

## Strumenti consigliati (LEAD)
- Mattina: **DAX** + **FTSE (UK100)**.
- Pomeriggio: **Russell (US2000)** + **Dow (US30)** → "**vanno meglio del Nasdaq**". ← da testare!
- DAX: max/min della notte; ORB su indici.

## Idee nuove (da valutare)
- **ORB breakout + RETEST** (non breakout secco): M5 chiude fuori senza ombra sopra → candela che rientra e si appoggia sull'ORB → entra. (Ombra% difficile da codificare.)
- **Canale notturno** (dalle 21-22 indici piatti): range M5 → breakout della mediana, stop dall'altro lato. Buono per conto personale, NON per prop.
- **Russell/Dow pomeriggio mean-reversion**: aprono sotto la media, apertura forte long → sparano 2-3 candele M5 poi si schiantano sulla media e tornano al livello pre-apertura (quasi ogni giorno). Idea: long fino a MA200 poi short al rifiuto, target = livello pre-apertura. Stop corto → 1:5/1:6.

## Test avviato
- **A7 — Aperture su nuovi indici** (`valid_Apertura_UK100/US2000/US30`): real tick, varia direzione(long/short/both) × buffer(200/500/800), ora 8 (UK100) / 14:30 (Russell,Dow), range 15, floor 200. Runner `rilancia_apertura_nuovi_indici.ps1`. ⏳ da lanciare (verificare che i simboli siano in Market Watch).

## TODO framework filtri modulari (Marco + Emiliano + Paolo)
Aggiungere al motore aperture, tutti toggle indipendenti (AND-gate, no conflitti): RSI, ADX, ATR, MA-filter, MA-cross (volumi ✅ e Supertrend ✅ gia' presenti). Poi sweep di tutte le combo + validazione real-tick del vincitore (evitare overfitting/pochi trade).

---
## EA APERTURA MARCO (nuovo, famiglia "Marco")
- Creato **`ABTG_Apertura_Marco.mq5`** (magic 770301): motore aperture + TUTTI i filtri di Marco come **toggle indipendenti** (AND-gate, no conflitti):
  - `InpUseMaFilter` (prezzo vs MA, periodo/metodo/TF), `InpUseRsi` (mode 0=momentum / 1=ipercomprato-venduto), `InpUseAdx` (soglia min), `InpUseAtr` (min/max punti) — oltre a Supertrend, correlazione, volumi già presenti.
  - Tutti **default OFF** (metodo Marco: parti da tutto OFF, accendi 1 filtro alla volta).
- **Test M-base** (`valid_Marco_DAX_base`): tutti i filtri OFF, DAX ora 8, range 15, LONG, floor 200, buffer 400/600/800 → deve ridare **~PF 1.49** (conferma che l'EA è sano). Runner `rilancia_marco.ps1`. ⏳ da lanciare.
- Poi: accendere i filtri uno alla volta (RSI, ADX, ATR, MA...) e vedere se migliorano PF/DD, con validazione del vincitore.

### ✅ RISULTATI CACCIA MOTORE M5 (26.07.26) — filtri Emiliano nel motore Marco, real-tick
_Sweep isolato: direzione × correlazione S&P × volumi × EMA. DAX ora 8, Nasdaq ora 14:30, rischio 1%._

**DAX (D30EUR M5):**
| Config | PF | DD% | Trade |
|---|---|---|---|
| baseline LONG buffer 600 (nessun filtro) ⭐ | **1.24** | 4.7% | 309 |
| + Volumi | 1.21 | 5.0% | 264 |
| + Correlazione S&P | 1.21 | 3.9% | 178 |
| + EMA / qualsiasi SHORT | ≤0.92 ❌ | — | — |

→ Motore sano (LONG edge confermato, PF 1.24; SHORT distrugge). **I filtri NON migliorano il PF**; la correlazione dimezza i trade e abbassa il DD ma taglia anche il profitto. L'`_Ottimizzato` esistente (logica candela H1, PF 1.49) resta il campione DAX.

**NASDAQ (NASUSD M5):**
| Config | PF (range) | Trade |
|---|---|---|
| baseline nudo | 0.63–0.84 ❌ | 336–454 |
| + Volumi | 0.66–0.68 ❌ | 129–184 |
| + Correlazione S&P | 0.51–0.66 ❌ | 199–215 |
| + Corr + Vol | 0.60–0.67 ❌ | 122–181 |

→ **IPOTESI FALSATA: la correlazione S&P NON salva il Nasdaq.** Nessuna combo supera PF 0.76. Il filtro funziona meccanicamente (taglia i trade da 336 a ~200 → dati S&P presenti, test valido), ma non crea edge dove non c'è.

> **CONCLUSIONE M5 (definitiva).** Il breakout M5 in apertura è morto sul Nasdaq anche coi filtri di Emiliano; sul DAX funziona solo LONG e l'Ottimizzato esistente lo cattura meglio. **Fine della caccia al motore M5.** L'edge reale resta: DAX aperture LONG (M5 su candela H1) + SupRev su H1/H4 + oro. Nota: questo è un *proxy automatico* della regola di Emiliano (EMA 14/100 su S&P H1); la sua lettura discrezionale live è un'altra cosa e non è automatizzabile 1:1.

### Tassonomia famiglie EA (tutte → backtest → real-tick → forward)
- **NOSTRI (validati):** Oro (SupRev_Multi/EMA200/GoldenCross), DAX aperture LONG, SupertrendReversal indici (DAX H1/H4, Nasdaq H1 in validazione).
- **EMILIANO:** motore aperture + filtri (volumi/direzione D1/correlazione/ampiezza) — test A6.
- **MARCO:** `ABTG_Apertura_Marco` + filtri modulari (RSI/ADX/ATR/MA) + nuovi indici (UK100/Russell/Dow) — test A7.

---

## APERTURA su NUOVI INDICI — FTSE & Dow (26.07.26, real-tick)
_Idea di Marco: Russell/Dow/UK100 in apertura > Nasdaq. Testato col motore aperture (ora 8 FTSE, 14:30 Dow), sweep direzione×buffer, rischio 1%. Russell 2000 NON quotato su BCM._

| Sym | Strumento | Migliore config | Profit | PF | DD% | Verdetto |
|---|---|---|---|---|---|---|
| 100GBP | FTSE 100 | buffer 800 LONG | -302 | 0.90 | 9.6% | 🔴 morto |
| U30USD | Dow Jones | buffer 200 LONG | -9 | 0.997 (pari) | 8.6% | 🔴 morto (a malapena in pari) |

> **CONCLUSIONE APERTURA (definitiva).** Il breakout M5 in apertura funziona SOLO sul DAX, SOLO LONG. Su Nasdaq/FTSE/Dow → morto. Non è un motore generalizzabile: è un'anomalia del DAX. L'idea di Marco (Dow>Nasdaq) NON regge in versione automatica. **Fine dell'espansione della famiglia aperture.** Il vero motore generalizzabile resta il **SupertrendReversal** (DAX+Nasdaq+oro, H1/H4).

---

## SupRev su NUOVI INDICI — screen OHLC (26.07.26)
_SupertrendReversal (il motore che generalizza) su Dow/Stoxx50/CAC/FTSE/Nikkei, H1+H4, griglia StMult 2.5-3.5 x AtrP 8-10 x TP_RR 2.0-3.0, rischio 1%._

| Sym | Strumento | TF | Migliore config | PF | DD% | Trade | Verdetto |
|---|---|---|---|---|---|---|---|
| U30USD | Dow | **H4** | StMult 3.5 / AtrP 8-9 / TP 3.0 | **2.1-2.58** | 3-4% | ~80 | 🟢 FORTE (cluster) |
| U30USD | Dow | **H1** | StMult 3.5 / AtrP 9 / TP 3.0 | 1.2-1.33 | 7-8% | 273-454 | 🟢 buono |
| F40EUR | CAC 40 | H4 | StMult 2.5 / AtrP 9 | ~1.7 | 3% | 65 | 🟡 decente |
| E50EUR | Stoxx 50 | H1 | StMult 3.5 / AtrP 10 | 1.32-1.47 | 1.2% | 60 | 🟡 marginale |
| E50EUR | Stoxx 50 | H4 | StMult 3.0 / AtrP 8 | 2.8 | 0.6% | 49 | 🟡 troppo pochi trade |
| F40EUR | CAC 40 | H1 | StMult 3.5 / AtrP 9 | 1.29 | 6% | 131 | 🟡 debole |
| 100GBP | FTSE | H4 | StMult 3.0 / AtrP 9 | 1.29 | 2% | 48 | 🔴 debole |
| 100GBP | FTSE | H1 | — | tutte neg | — | — | 🔴 morto |
| 225JPY | Nikkei | H1/H4 | StMult 3.5 | PF ~2 | 0.2% | 24-75 | 🔴 profitto irrisorio (~€50, lotto JPY minuscolo) |

> **SCOPERTA: il SupRev generalizza sul Dow (U30USD).** H4 PF 2.5 DD ~3% (livello prop), H1 buono con tanti trade. Il Dow era morto in apertura, vivo col SupRev. CAC H4 secondario. FTSE/Nikkei scartati. **Da validare real-tick: Dow H4 + H1 (+ CAC H4 bonus).**

### ✅ VALIDAZIONE REAL-TICK SupRev nuovi indici (26.07.26) — CONFERMATA
| Sym | TF | Config vincente | Profit | PF | DD% | Trade | EA creato | Magic |
|---|---|---|---|---|---|---|---|---|
| U30USD (Dow) | **H4** | StMult 3.5 / AtrP 8 / TP 3.0 | 1661 | **2.77** | 4.0% | 79 | `ABTG_SupRev_DOW_H4_Ottimizzato` | 970914 |
| F40EUR (CAC) | **H4** | StMult 2.5 / AtrP 9 / TP 2.5 | 519 | **1.79** | 3.5% | 65 | `ABTG_SupRev_CAC_H4_Ottimizzato` | 970915 |
| U30USD (Dow) | **H1** | StMult 3.5 / AtrP 9 / TP 3.0 | 560 | 1.20 | 9.8% | 273 | `ABTG_SupRev_DOW_H1_Ottimizzato` (opzionale, DD alto) | 970916 |

- **Dow H4:** cluster StMult 3.5 → PF 2.09-2.77, DD 3-4%. Identico all'OHLC. 🟢 forte (livello prop/oro).
- **CAC H4:** StMult 2.5/AtrP9 → PF 1.70-1.79 DD 3%; StMult 3.0 negativo. 🟢 keeper.
- **Dow H1:** positivo (PF 1.20, 273tr) ma DD ~10% → secondario/opzionale.
- Il SupRev ora ha edge REAL-TICK confermato su: Oro, DAX (H1/H4), Nasdaq (H1), Dow (H4/H1), CAC (H4). **Motore che generalizza, dimostrato.**

---

## MaxMinNotte — rottura range notturno all'apertura europea (26.07.26, real-tick)
_Box 23:00-04:59 server, piazza 07:59, cutoff 08:30. Sweep direzione x buffer, SL ad ATR, rischio 1%._

| Indice | Migliore config | PF | DD% | Trade | Verdetto |
|---|---|---|---|---|---|
| DAX (D30EUR) | **SHORT only, buffer 1000, TP2 3.0** | **1.19** | 7.3% | 107 | 🟡 unica viva (edge modesto) |
| FTSE (100GBP) | — | max 0.67 | — | — | 🔴 morto |
| CAC (F40EUR) | — | max ~1.0 | — | — | 🔴 morto |
| Stoxx50 (E50EUR) | — | max 0.59 | — | — | 🔴 morto |

> **Night-box: solo DAX SHORT ha edge (PF 1.19)** — la rottura al RIBASSO del range notturno (opposto dell'aperture che e' LONG). Complementare all'aperture. In raffinamento (`valid_MaxMin_DAX_short_refine`: buffer x SL-ATR x filtro ampiezza box x correlazione S&P). Nota: un AGENTE non puo' ottimizzare (non ha MT5); l'ottimizzazione gira sul PC di backtest.

### ✅ RAFFINAMENTO DAX night-box SHORT (26.07.26) — CONFERMATO real-tick
_Sweep buffer x SL-ATR x filtro box x correlazione S&P. La correlazione e' la CHIAVE._

| Config (short) | PF | DD% | Trade | Note |
|---|---|---|---|---|
| **corr ON, buffer 1000, AtrSL 2.5, TP2 3.0** ⭐ | **2.05** | 3.1% | 41 | scelto (centrale del plateau) |
| corr ON, buffer 1300, AtrSL 2.5 | 2.25 | 3.2% | 38 | miglior profitto |
| corr ON, buffer 700, AtrSL 2.0 | 2.10 | 3.5% | 39 | |
| corr OFF (qualsiasi) | 1.0-1.25 | 6-9% | ~100 | modesto |

- **La correlazione S&P raddoppia il PF (1.2→2.0+) e dimezza il DD (7%→3%)**, taglia i trade a ~40. Filtro ampiezza box irrilevante (notti DAX sempre larghe).
- Promosso: `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` (magic 770411) — short only, corr S&P ON, buffer 1000, SL ATR x2.5, TP2 3.0, rischio 1%.
- **Complementare all'aperture LONG:** sul DAX ora copriamo entrambe le direzioni (aperture LONG + night-box SHORT), con setup e orari diversi.
- Nota metodologica: la correlazione S&P NON salvava il breakout M5 (test Marco/Emiliano) ma QUI salva il night-box. Il filtro giusto dipende dalla strategia.

### 🌙 23/08/26 — analisi del PDF di corso "Strategia NIGHTLY" (33 pag.)
Referto completo (parametri, confronto regola-per-regola, verdetto):
**`caccia_strategie/ANALISI_NIGHTLY_PDF_2026-08-23.md`**. Le tre righe che
toccano questo registro — il resto sta nel referto, non si duplica:
- ⚠️ **RETTIFICA al "Nightly 0/8"**: su **U30USD, D30EUR, XAUUSD** l'EA fa
  **ZERO trade** perche' il filtro QB (`InpMaxNightVolPips=45`) e' confrontato
  con `ATR(H1)/PipSize()`, e su indici/oro `PipSize()=_Point` → sempre ≥45.
  **Su quei mercati il fade non e' stato bocciato: non e' stato misurato.**
  Il verdetto negativo regge su EURUSD/GBPUSD/USDCHF (~160 trade a testa).
- ✅ Il **BREAKOUT** del box (questa famiglia) e' confermato dal PDF e dalla
  misura di casa (91,1% delle notti rompe un lato, `NOTTE_ORO.md`).
- 🆕 Unica proposta uscita: **BREAKIN del box notturno** (falsa rottura →
  reversal, PAG 26/28) sul motore `ABTG_LiquiditySweep`, che R89 aveva chiuso
  per **carenza di livelli** (14 trade IS): il box notturno ne da' ~250/anno
  per lato. Spec nel referto §7b; **nessun file prova ancora scritto**.

---

## EA SuperWave — cross EMA14x200 a favore del Supertrend (26.07.26, screen OHLC)
_Nuovo EA dalla dashboard SuperWave (magic 770501). Ingresso: incrocio EMA14xEMA200 confermato dal Supertrend. Griglia StMult 2.5/3.0/3.5 x TP_RR 2.0/2.5/3.0, entrambe direzioni, rischio 1%._

| Sym | Strumento | TF | Migliore | PF | DD% | Trade | Verdetto |
|---|---|---|---|---|---|---|---|
| U30USD | Dow | **H1** | StMult 2.5 / TP 3.0 | **1.42** | 4.3% | 226 | 🟢 vincitore (tutte pos.) |
| D30EUR | DAX | H4 | StMult 3.0 / TP 2.0 | 1.30 | 3.3% | 56 | 🟡 decente |
| U30USD | Dow | H4 | StMult 3.5 | 2.5 | 5.9% | 23 | 🟡 pochi trade |
| NASUSD | Nasdaq | H1 | StMult 3.0 / TP 2.0 | 1.26 | 2.0% | 95 | 🟡 marginale |
| D30EUR | DAX | H1 | — | max 0.84 | 17% | — | 🔴 morto |
| NASUSD | Nasdaq | H4 | — | negative | — | 16-18 | 🔴 morto |
| XAUUSD | Oro | H1/H4 | — | ~1.0/neg | — | — | 🔴 morto (l'oro rende col SupRev, non col cross) |

> **SuperWave: il cross 14x200 e' un motore di TREND** — vivo su Dow H1 (netto, 226tr) e DAX H4 (56tr). Su oro/Nasdaq no. Da validare real-tick: Dow H1 + DAX H4.

### ✅ VALIDAZIONE REAL-TICK SuperWave (26.07.26) — CONFERMATA
| Sym | TF | Config | Profit | PF | DD% | Trade | EA creato | Magic |
|---|---|---|---|---|---|---|---|---|
| U30USD (Dow) | **H1** | StMult 2.5 / TP 3.0 | 1433 | **1.52** | 4.0% | 227 | `ABTG_SuperWave_DOW_H1_Ottimizzato` | 770511 |
| D30EUR (DAX) | **H4** | StMult 3.0 / TP 2.0 | 278 | **1.28** | 3.3% | 56 | `ABTG_SuperWave_DAX_H4_Ottimizzato` | 770512 |

- Dow H1: tutte 9 positive, real-tick (1.52) anche > OHLC (1.42). Robusto.
- DAX H4: 7/9 positive, DD basso. Secondario.
- La dashboard SuperWave (cross EMA14x200 + Supertrend) e' diventata un EA reale validato. Il Dow conferma di essere lo strumento piu' tradabile del parco (SupRev + SuperWave).

---

## G1-PAOLO — i tre valori della live del 27/08, PREPARATO (28.08.26) — NON ANCORA GIRATO

_Ablazione a stella sui tre input che la live di Paolo del 27/08 sera ha
nominato e che **abbiamo gia' nel codice senza averli mai misurati**
(`risultati_archivio/ANALISI_LIVE_PAOLO_2026-08-27.md` §3, spunti P1/P2/P5)._

**🔴 La correzione che cambia il disegno, verificata per grep nel sorgente:
i tre input NON stanno nello stesso EA.**

| input | dove vive DAVVERO |
|---|---|
| `InpEma2` (89 vs **50**) | **solo** famiglia **SupRev** (base + tutti i derivati) |
| `InpAdxMin` (20 vs **25**) | **solo** `ABTG_SupertrendInvert` (riga 65) |
| `InpUseStoch` (ON vs **OFF**) | **solo** `ABTG_SupertrendInvert` (riga 69) |

La famiglia SupRev **non ha** un filtro ADX ne' uno stocastico: non sono spenti,
**non esistono** (`adx=0 stoch=0` su tutti e dieci i file). Le "quattro celle su
un EA solo" non si possono fare, e **nessun input e' stato aggiunto a nessun EA**
(quattro di quelli hanno una sedia viva).

**5 celle, 2 motori, 2 banchi**, tutte su **XAUUSD**:

| cella | EA | TF | delta | magic |
|---|---|---|---|---|
| 00_suprev_base | `ABTG_SupertrendReversal` | H4 | baseline `InpEma2=89` | 778000/778001 |
| 01_suprev_ema50 | `ABTG_SupertrendReversal` | H4 | **`InpEma2` 89 -> 50** | 778100/778101 |
| 10_invert_base | `ABTG_SupertrendInvert` | H1 | baseline ADX 20 + Stoch ON | 778300/778301 |
| 11_invert_adx25 | `ABTG_SupertrendInvert` | H1 | **`InpAdxMin` 20 -> 25** | 778400/778401 |
| 12_invert_stochoff | `ABTG_SupertrendInvert` | H1 | **`InpUseStoch` ON -> OFF** | 778500/778501 |

**Banchi**: S = modello 1 OHLC M1 2020.01.01->2026.06.30 (il campione, n≈208
sull'antenato R103/R114) · V = modello 4 tick reali 2024.07.05->2026.06.30 (il
riempimento vero, campione sottile: n=44 agli atti su oro H4).
**Criterio congelato**: il delta si propone solo se ha lo **stesso segno su
tutte e 4 le sotto-finestre**; segno opposto fra S e V sull'OOS = **conflitto
dichiarato, nessuna proposta**.

- Artefatti: `prove/G1PAOLO_*.txt` (5) · `prove/REFERTO_PREPARAZIONE_G1PAOLO.md`
  (criteri PRIMA dei numeri) · `righe/RIGA_G1PAOLO.ps1` ·
  `righe/RIGA_G1PAOLO_DA_MANDARE.md`.
- ⚠️ **Aperto**: la profondita' **TICK di XAUUSD non e' mai stata misurata**
  (R86/R87 §2.0). Il `2024.07.05` e' **INFERITO** da GBPUSD -> PASSO 0 nella
  pagina della riga.
- ⚠️ **Nessuna sedia viva toccata.** Nessun numero: **il round non e' ancora
  girato.**

---

## CRT TURTLE SOUP (Neo Malesa, MIT) — CHIUSO 31/08/2026: senza edge a tick nel toro, gate compreso

Saga completa in `risultati_archivio/REFERTO_CRT_2026-08-30.md`. In sintesi:

| banco | finestra | config | risultato | verdetto |
|---|---|---|---|---|
| tick BCM M4 | 2024-2026 (toro) | sweep 30 celle, ungated | PF 0.43-0.73, 0/30 | 🔴 morto nel toro |
| OHLC _EXT M1 | 2020-2024 (4 regimi) | cella robusta | +5744, vive nel CHOP (2022/2023), perde crollo e toro | 🟡 motore da range |
| OHLC _EXT M1 | 2020-2024 | + gate ADX(D1)<=30 | +10135, OGNI regime positivo | 🟢 gate valido su OHLC |
| tick BCM M4 | 2024-2026 (toro) | + gate ADX(D1)<=30, corsa VERA | **PF 0.459** (ungated 0.462), 17/19 mesi rossi, 2 lati rossi | 🔴 **il gate non salva a tick** |

- **NON deployabile. PARCHEGGIATO** candidato-chop: si riapre solo con tick
  Dukascopy del regime range, o mercato tornato chop. Magic 7691xx riservati.
- Lasciti tecnici: EA v3 (CopyRates D1 + fallback M15 — gli handle iADX/iATR
  su D1 NON popolano nel tester tick su nativo: vale per ogni EA futuro);
  classe "skip-senza-Rifai" in CHECKLIST_RIGA_DI_LANCIO.md (4 corse della
  saga erano zombie: CSV stantii spacciati per freschi).

---

## CHAOS LYAPUNOV (gate LLE su EMA-cross, da jojoale CB76446) — BOCCIATO 31/08/2026

Screening OHLC NASUSD_EXT M15 2020-2024, 105 celle (referto:
`risultati_archivio/REFERTO_CHAOS_2026-08-31.md`). Il gate MORDE (15/15 gruppi
monotoni) ma **al CONTRARIO della tesi**: gate stretto (solo "regime leggibile",
LLE basso) = PF 0.39-0.42; gate largo = PF 1.25-1.33. La fascia PF>=1.3 & DD<8%
e' UNA cella su 105 -> outlier -> BOCCIA da criterio congelato. Il verde a gate
largo = drift Nasdaq + ottimismo OHLC su EMA-cross, non edge del gate. n sottile
ovunque (55-92 trade/4 anni). **La tesi "LLE basso = tradeable" e' falsificata
sugli indici.** Magic 769200 libero. Il calcolo LLE resta come mattone misurato.

### Chaos ablazione (31/08, corsa 09:57) — ingrediente LLE NON promosso (criterio congelato)
Gate al massimo (0.09) vs nudo (999) su 2020-2024 OHLC: PF 1.789 vs 1.150,
DD 8.78% vs 21.01%, profit 33175 vs 39724. Passa la condizione PF (+0.64),
fallisce profit_totale -> sepoltura da lettera congelata. Osservazione
registrata: la condizione profit_totale e' anti-filtro per costruzione
(lezione in checklist, vale per le ablazioni FUTURE, non retroattiva).
Porta di rientro: round nuovo su motore diverso con criteri risk-adjusted
congelati prima. EA resta bocciato. Referto:
risultati_archivio/REFERTO_CHAOSABL_2026-08-31.md

### NY Session Retest — PASSO 0 VALIDO (31/08, corsa v5 10:36, tick M15 U30USD)
Retest-VWAP nudo (gate OFF): n=625/21 mesi (~1/gg), **PF 1.002** (pareggio
perfetto), DD 12.9%, pegg.gio -2.0%, take mediano win +87.6 idx pts, LONG
+4789 / SHORT -4575. Overnight veri 2.88% (<5% firmato, assenza tick festivi).
Lezioni pagate nel round: H1 muto per costruzione, flat a ora-del-giorno che
si resetta a mezzanotte (fix: flat di recupero + open_time nel CSV), criterio
zero-overnight-assoluto fisicamente irraggiungibile (riscritto prima dei
numeri). Prossimo: TARATURA del gate slope+espansione (criteri gia' nel
prova). Referto: risultati_archivio/REFERTO_NYRETEST_2026-08-31.md

### NY Session Retest — TARATURA CHIUSA (31/08): gate REALE, edge sotto barra al n minimo
Estensione finale 8 celle: PF massimo a slope 75 (1.37/1.43, DD 3.7-4.7%,
pegg.gio -0.69%) ma n=114-115 < 150 -> muro R59, merito sospeso. A slope 60
(n=160) PF 1.14-1.20 sotto barra. NON promosso, NON deployabile. Primo gate
costitutivo della flotta VALIDATO a tick (slope VWAP: monotono, DD dimezzato;
espansione decorativa). Porta di rientro MECCANICA: tagliando quando la
finestra tick BCM dara' n>=150 sulla cella slope 75 (~5.4 trade/mese, stima
2027) o Dukascopy pre-2024. Referto completo:
risultati_archivio/REFERTO_NYRETEST_2026-08-31.md

---

## IMPORT DUKASCOPY TICK — PASSO 0 CONSEGNATO (31/08/2026): strumenti pronti, NIENTE lancio

L'operazione che sblocca i DUE verdetti parcheggiati (NY Retest slope75
n=114<150; CRT candidato-chop senza tick del suo regime). Consegnati:
- `dukascopy/DUKASCOPY_PASSO0.md` — fattibilita' misurata (tick Dow/Nasdaq
  dal 2012, ~4 min/giorno di crawl misurato il 18/08 = il muro vero),
  mappa fuso UTC->server con le 4 settimane sfasate USA/EU nella
  sovrapposizione, criteri della SONDA congelati PRIMA (mediana diff
  minuto <=0,05%, copertura >=80%, discriminante DST);
- `dukascopy/dukascopy_tick.py` (DUKA-TICK-v1, autotest 9/9 in cloud) —
  .bi5 -> CSV tick mensili in ORA SERVER, due calendari DST implementati,
  cache condivisa col fratello M1, riconversione --solo-cache gratis;
- `mql5/Scripts/ABTG_ImportaTickEsterno.mq5` (BOZZA, MAI COMPILATA) —
  clone U30USD/NASUSD -> U30USD_DK/NASUSD_DK + CustomTicksReplace +
  sonda incorporata col cancello.
Missioni proposte (da firmare): B = NASUSD 2022-2023 (2 notti) prima,
A = U30USD 2019-2024 (4-5 notti) poi. Le righe di lancio arriveranno con
verificatore quando Claudio decidera'. Regola d'uso: SOLO verdetti a
parametri congelati, mai taratura su feed esterno.

### CACCIA FREQUENZA (31/08 sera) — le tre righe che toccano questo registro

Dossier completo: `caccia_strategie/CACCIA_FREQUENZA_2026-08-31.md`. Il resto
sta li', non si duplica.

- 🪦 **DUE LAPIDI NUOVE, da paper letti per intero — risparmiano due cacce.**
  (a) arXiv **2605.11423** (Mesfin): il day-classifier volatilita'+volume+gap
  su MNQ attiva su **4,4% dei giorni = 40 in 4 anni**, e l'autore ha gia'
  falsificato **8 configurazioni direzionali su 8**. Ci lascia pero' una
  conferma esterna del lead sul Dow: **77,6% di quei giorni si ribalta dal
  picco intraday** (restituzione media 11,73 pt, picco fra le 14:00 e le 15:30
  ET). (b) arXiv **2605.17724** (Mesfin): LSTM e gradient boosting su OHLCV
  5-min MNQ, **nessuna configurazione sopra il tasso base del 51,8%**,
  944 giorni. Conclusione dell'autore: **4 anni di OHLCV a 5 minuti su un solo
  strumento NON BASTANO**. La nostra finestra tick sugli indici e' **21 mesi**,
  meno della meta'. 👉 **Niente round ML sugli indici finche' i dati non
  crescono.**
- 🔴 **I due "vincitori" di arXiv 2605.04004 §5 (RTH Confluence, London Signal
  B) NON sono riproducibili**: il loro cuore e' un classificatore GMM che
  l'autore dichiara di "a separate research program" e che **non e' pubblicato
  in nessuno dei suoi tre paper** (verificato per interrogazione autore su
  arXiv). E comunque **fallirebbero il pavimento di frequenza**: 0,72 e 0,31
  trade/giorno contro il minimo di 1. **Non si portano nell'imbuto.**
- 🆕 **Unico promosso: `M0PB`** (Marcns_, MPL 2.0, TradingView, Pine letto
  integrale) — impulso estremo RSI(6) **nel verso** + rientro sulla EMA5,
  uscita al massimo mobile a 12 barre, stop 2,75·ATR(10), **un solo input
  libero**, due lati simmetrici, zero bandiere rosse nel motore.
  **PASSO 0 = SONDA DI CONTEGGIO, non griglia** (le tre fonti dati sono murate
  dal proxy: la frequenza da qui NON si misura). Bozza con criteri congelati:
  `prove/M0PB_FREQUENZA_BOZZA.txt`. Cancelli: **< 1 segnale/giorno → scarto**;
  **take mediano < 6,0 punti indice → scarto**. Ablazione gia' congelata:
  massimo mobile a 12 barre **contro** uscita a tempo alla barra 13.

---

### BreakinBox (falsa rottura box notturno DAX) — CHIUSO 31/08: l'ablazione lo smaschera come R95 con un livello nuovo
Ablazione A/B a tick (2024-2026, D30EUR): TP al lato opposto (tesi) PF 1.007
DD 24.1% contro RR fisso 2.0 (controllo R95) PF 1.106 DD 19.7% -> vince il
controllo su PF E DD = tesi falsificata, e il controllo stesso buca il
cancello DD<=15%. Candidato chiuso da criterio congelato, niente caccia
all'RR. In cassa: conversione D30EUR=100 misurata (prima volta), frequenza
~20/mese due lati, EA-mattone autotestato. Referto:
risultati_archivio/REFERTO_BREAKIN_2026-08-31.md

### DaxReEntry — PASSO 0 misurato (31/08 16:25): LONG 6/6 verde (PF fino 1.80, DD 2.5%), SHORT morto, n<=92 -> merito sospeso R59
Banda long vera ordinata col filtro, bordo aperto a break=40. Take mediano win
+76.8 idx (long): S0 preannunciato largo, si chiude con lo spread flotta.
Frequenza ~3-4/mese/lato: cecchino da mossa-4, non portata. Referto:
risultati_archivio/REFERTO_DAXREENTRY_2026-08-31.md

### CACCIA FREQUENZA — SECONDA BATTUTA (31/08 notte): le righe che toccano questo registro

Dossier completo: `caccia_strategie/CACCIA_FREQUENZA2_2026-08-31.md`. Il resto
sta li', non si duplica.

- 🔧 **CORREZIONE MISURATA, e conta per ogni round forex futuro: il pavimento
  1999 del forex e' su OHLC M1, NON sui tick.** `R102_REFERTO_BLOCCO1.md`
  riga 6 dice *"modello OHLC M1"* e riga 136 *"niente tick reali"*;
  `BLOCCO2` riga 19 dice *"Prima operazione 1999.01.04 su tutte e tre"*.
  ➡️ Sul forex abbiamo **~27 anni di M1 OHLC misurati** (vantaggio vero per lo
  SCREENING e per la PROVA DI REGIME: toro/orso/laterale/crollo si scelgono
  davvero, contro i 21 mesi a regime unico degli indici), ma **la profondita'
  TICK del forex BCM non e' mai stata sondata** — stesso buco aperto di XAUUSD
  (G1-PAOLO). **`F6 verdetti solo a tick` non si ammorbidisce**: `@DAQUANDO` si
  MISURA con `scarica_storico.ps1`.
- 🪦 **Il Code Base ha smesso di produrre motori, ed e' misurato.** Interrogati
  uno per uno i 20 id piu' recenti (76669 → 75473): **15 attrezzi** (pannelli,
  calcolatori, sei utility `Quantora` di fila, logger), **3 recovery/basket**,
  1 gia' bocciato (Chaos 76446), 1 motore generico. **Zero EA di sessione, zero
  forex intraday, zero uscite a tempo, in quattro pagine.** ➡️ **Non aprire piu'
  il Code Base per cercare MOTORI intraday: aprirlo per gli ATTREZZI** — come
  il *RealCost Spread P95 Logger* (**74148**), promosso il 23/08 e **mai usato:
  sesta caccia che lo scrive**.
- 🆕 **QuantConnect e' raggiungibile (200 su bersaglio noto, mai usata prima in
  6 dossier) ma NON e' una fonte per noi**: la libreria e' fatta di strategie
  di PORTAFOGLIO a ribilancio giornaliero/mensile. Lette per intero
  `Combining Mean Reversion and Momentum in Forex Market` (**ribilancio
  MENSILE**, ~1-2 trade/mese, nessuno stop) e `Dual Thrust` (range breakout,
  nessuno stop, ~1/giorno). **Quantpedia riconfermata PREMIUM** su 4 slug reali
  (302.356 byte identici = home page).
- 🔴 **DIREZIONE "tenuta lunga" (12-15 barre, arXiv 2605.04004 §6.2): ZERO
  candidati nel web gratuito**, e il motivo e' strutturale (il retail esce su
  TP/SL, l'accademia ribilancia il mese). 🎯 **La risposta e' in casa e non e'
  mai stata accesa: la `SONDA DELL'OROLOGIO`** (EA `ABTG_SondaOrologio.mq5`,
  7 file prova, `RIGA_SONDA_OROLOGIO_DA_MANDARE.md`, referto di preparazione —
  tutti preparati il 28/08). **In `risultati_archivio` NON esiste nessun
  referto: non e' MAI girata.** E' il solo meccanismo FX a tenuta di ore con
  frequenza >=1/giorno che il progetto possieda.
- 🆕 **Unico promosso: `EURUSD 5min london session strategy`** (SoftKill21,
  MPL 2.0, TradingView, Pine v4 letto integrale, **52 righe / 8 input**) —
  canale SMA5(high)/SMA5(low) rotto in **chiusura**, sessione di Londra,
  conferma RSI(5) **che l'autore dichiara opzionale**, `close_all`
  incondizionato a fine sessione, **`max_intraday_filled_orders(6)`** e
  **`max_intraday_loss(2, percent_of_equity)`** dentro il motore.
  🎯 **Il numero che lo promuove e' la GEOMETRIA: `tp=150 / sl=80` tick =
  RR 1,875 → supera il cancello H8 con un win rate del 37,4% lordo / 42,0%
  netto a 1 pip di costo, contro il 62-79% richiesto da M0PB e il 53,8% di
  P2.** Frequenza **~5/giorno DICHIARATA DALL'AUTORE** sulla pagina e
  confermata da due righe di codice — [DICHIARATA, non misurata: le tre fonti
  dati restano murate].
  **PASSO 0 = SONDA DI CONTEGGIO, non griglia.** Bozza coi criteri congelati:
  `prove/LONDONFX_FREQUENZA_BOZZA.txt`. Cancelli: **<1 segnale/giorno →
  scarto**; **escursione favorevole mediana <3,0 pip → scarto**; **RR<0,70 →
  scarto per aritmetica senza corsa a tick**.
  🔬 **Due ablazioni gia' congelate:** (1) canale **nudo** contro canale+RSI
  (l'autore dichiara l'RSI accessorio → filtro appiccicato, 0/5 in casa);
  (2) **UN SOLO EA contenitore** (`ABTG_LondonFx`: sessione + flat + cap
  giornalieri + rischio %) con **tre motori a interruttore** — canale nudo,
  canale+RSI, e **l'allineamento a 5 medie del P2 del 28/08 (stesso autore,
  stessa coppia, stessa sessione, mai girato)**. Se i tre vanno uguale, **il
  contenitore E' l'edge** e il segnale non conta.

## M0PB (Momentum Pull Back, Marcns tv/GnsUpEsB, MPL 2.0) — MORTO AL PASSO 0, 31/08/2026
- **Verdetto: MORTO 12/12** (3 indici × 2 TF × 2 lati) alla sonda di conteggio
  `ABTG_SondaM0PB` (contatore puro, zero ordini, open prices, pin `4e1cdf8`,
  corsa 31/08 19:35). Referto: `risultati_archivio/REFERTO_SONDAM0PB_2026-08-31.md`.
- **F1 (frequenza): 0/12.** Lato migliore 0,52 segnali/giorno (U30 M5 short)
  contro soglia 1,00; su M15 0,15-0,21. Il claim "alta frequenza" della pagina
  TradingView sui nostri indici RTH vale un segnale ogni 2 giorni per lato.
- **H8 (RR >= 0,70, FIRMA 2): 7/12 sotto**, i 5 sopra a 0,70-0,74; win rate
  necessario 62-70%. Stop 2,75xATR strutturalmente piu' largo del take.
  T10: nessun mult va pescato per far passare il cancello.
- **F2 (take > 7 punti idx): 12/12 verdi** (27-119 punti) — irrilevante senza
  frequenza e senza RR.
- Collaudi 6/6 verdi (autotest 0/12, determinismo 2 passate, ATR alla Pine
  davvero diverso da iATR: 9,6-16,4%). Costo del verdetto: 1 compilazione +
  12 passate (~minuti), ZERO corse a tick sprecate. **La sonda-prima-dell'EA
  paga: e' il modo giusto di bocciare.**
- **NON ritestare con altre griglie** (seconda caccia 19/08). Alternative gia'
  in vivaio, stessa missione frequenza: LondonFx (RR 1,875, bozza congelata)
  e Sonda dell'Orologio (pronta dal 28/08, mai girata).

## RSI+EMA V8 (Pine anonimo, incollato in chat 01-02/09) — NON PROMOSSO, CONFERMATO DA MISURA, 03/09/2026
- **Verdetto: il filtro RSI toglie solo il 9-13% degli incroci EMA(5/20)**
  (ablazione su 7 corse: 3 indici x M5/M15 + ORO_M15, 21 mesi, sonda
  `ABTG_SondaRsiEmaV8`, pin `0f01962`). Nei numeri e' un incrocio di EMA:
  famiglia SuperWave/ChaosLyapunov, gia' morta due volte. Il verdetto di
  carta del 31/08 (SCHEDA_RSIEMA_V8) esce CONFERMATO DA UNA MISURA — la
  porta di rientro e' stata esercitata coi numeri, come chiesto da Claudio.
- F1 abbondante (2,0-6,6 segnali/giorno per lato: la frequenza non era il
  problema); geometria MFE~MAE, RR 0,92-1,17, WR necessario 50-56% =
  moneta lanciata (indicazione, limiti superiori); muro F4: a taglia di
  flotta 19,5% (M5) / 8,45% (M15) di rischio aperto contro cap 3,25%.
- PROBLEMI 7 dichiarati: invariante V8 della sonda violato su ~1-1,5% dei
  segnali -> escursioni NON certificate; il verdetto poggia sui CONTEGGI
  (robusti). Referto: `risultati_archivio/REFERTO_SONDARSIEMAV8_2026-09-03.md`.
- **NON ritestare con altre griglie.** L'esperimento manuale di Claudio
  (diario DIARIO_MANUALE_V8.md) continua: misura Claudio+V8, non il V8 nudo.

## LONDONFX (canale di Londra + RSI, EURUSD) — PASSO 0 SUPERATO, 03/09/2026
- **PRIMO SUPERSTITE della missione frequenza**: su EURUSD M15 con RSI,
  12/12 righe VIVE (2,0-2,3 segnali/giorno per lato, MFE med 10-13,4 pip,
  RR 0,90-1,14); M5 vivo a ora 8, sospeso a ora 4 (spread non misurato).
  Ablazione: il filtro RSI taglia il 73-77% dei segnali nudi (filtro VERO,
  opposto del V8). Corsa pulita: PROBLEMI 0, collaudi tutti verdi.
- Referto: `risultati_archivio/REFERTO_SONDALONDONFX_2026-09-03.md`.
  GEMELLA GBPUSD (09:16): 24/24 righe VIVE, MFE 12,6-16,3 pip su M15+RSI,
  filtro -76% anche sul Cable. Prossimi passi: SPREAD_FLOTTA (74148), round a
  tick reali su EURUSD M15 ora=8 con criteri congelati prima + ablazione
  a 3 motori (contenitore vs segnale). Il passo 0 conta occasioni: il
  MERITO non e' ancora misurato.
- 📝 **BOZZA DEI CRITERI del round a tick (R116 proposto, numero verificato
  libero il 03/09): `risultati_archivio/LONDONFX_TICK_CRITERI.md`** — DA
  FIRMARE, 12 righe F. Banco: tick REALI dal pavimento misurato 2024.07.05
  -> 2026.06.30 (~23,8 mesi, UN SOLO REGIME), M15, EURUSD+GBPUSD, ora
  CONGELATA a 8, rischio 0,65%. Cancelli: E OOS >= 0,075R NETTA (FIRMA 2
  del 31/08) · PF >= 1,15 · DD <= 8,0% · peggior giornata >= -4,0% (oltre,
  il Guardian avrebbe messo in pausa: backtest non riproducibile) · n >= 150
  per gamba. Ablazione a 3 motori con soglia di somiglianza DICHIARATA PRIMA
  (scarto di E <= 0,05R = 2/3 del cancello H8 -> "il contenitore e' l'edge").
  Numero da tenere in cima: 1R = 8 pip, il cancello vale 0,60 pip e lo
  spread assunto 1,0-2,0 -> **il costo e' 1,7-3,3 volte l'edge richiesto**.
  Previsione dichiarata prima: MAE mediana 11,8 pip > SL 8,0 pip -> l'esito
  piu' probabile e' un NO. NIENTE e' stato girato ne' compilato.

### CACCIA FREQUENZA — QUINTA BATTUTA (03/09, fronte B): le righe che toccano questo registro

Dossier completo: `caccia_strategie/CACCIA_FREQUENZA5_IMPLEMENTAZIONI_2026-09-03.md`.
Il resto sta li', non si duplica. **ZERO EA promossi, ZERO file prova nuovi.**

- 🔓 **SI POSSONO SCARICARE BARRE M1 DA QUI.** `github.com/FutureSharks/financial-data`
  (GPL-3.0) via `raw.githubusercontent.com`: **DAX (`GRXEUR`, stessa scala di
  D30EUR), S&P, Nikkei, EuroStoxx M1 2010-2018** e **Nasdaq/oro/major M1
  2005-2020**. Scaricate e usate oggi: **1.870.955 barre M1**. Chiude il buco
  dichiarato in quattro dossier ("da qui nessun agente puo' misurare una
  frequenza"). Limiti e percorsi: `PROMEMORIA_SBLOCCO_FONTI.md` (blocco 03/09)
  e `caccia_strategie/biblioteca/sonde_esterne/LEGGIMI.md`.
  ⚠️ **Non e' BCM, e' OHLC M1, e' senza costi, e finisce nel 2020: da qui
  escono MISURE DI OCCASIONI, mai verdetti.** F6 non si ammorbidisce.
- 🩹 **CORREZIONE:** girava l'idea che **R95 (sweep+reclaim JPY) fosse "in coda,
  non morto"**. `R95_REFERTO.md` (23/08) dice **0/30, PF 0,65-0,80, nessuna
  passata sopra 1,00**, con **21.354 livelli creati e 0 buttati** e l'asse
  della DENSITA' gia' spazzolato da M30 a H4. **E' bocciato.**
- 🪦 **TRE LAPIDI NUOVE, tutte con un numero.**
  (a) **Post-news 15-30 min: chiuso.** `arXiv 2605.04004` §4.7 (paper gia'
  citato in 18 file del repo, §4.7 mai letto): 993 eventi 2022-2025 su MNQ,
  _"the drift is real in the first five bars … From bar +6 onward, T-statistics
  … are between 0.14 and 0.69"_, RTH T=0,38, Appendice A **`D127 — MNQ
  post-news drift permanently rejected — LOCKED`**. E _"news proximity adds no
  value"_ nemmeno come FILTRO. ⚠️ misurato su Nasdaq: per le due sedie
  `ABTG_PostNews` su EURUSD/EURJPY e' un'indicazione forte, non un verdetto.
  (b) **Sweep di micro-pivot sugli indici M5/M15: chiuso.** La densita' che
  aveva ucciso R89 (14 trade IS) **si risolve** — pivot(3,3) da' **4,22-4,57
  segnali/giorno per lato su DAX M5** — ma su **22.616 segnali** il tasso
  TP-prima-di-SL e' **43,5-48,2% contro il 49,6% richiesto da H8 (8/8 sotto)**
  e il **delta contro un ingresso CASUALE della stessa geometria e' −0,2 punti**.
  (c) **Compressione ATR → espansione: chiusa.** Su **9.723 segnali**,
  frequenza **0,55-1,87/gg per lato (0/8 sopra il pavimento)** e TP-prima-di-SL
  **31,6-36,0% contro 35,8% (7/8 sotto)**, delta contro il caso **−1,2 punti**.
- 🧪 **LA LEZIONE DI METODO, e vale per ogni sonda futura: IL CONTROLLO A
  INGRESSI CASUALI.** Un tasso di vittoria da solo non dice niente; dice tutto
  accanto al tasso di un ingresso **a caso con la stessa geometria, sugli
  stessi dati**. Su **16 celle e 32.339 segnali** il delta medio e' **−0,70
  punti**. Costa dieci righe. **Da oggi ogni sonda di conteggio porta il suo.**
- 🛠️ **UNA RIPARAZIONE VALE PIU' DI UNA CACCIA:** `ABTG_OutOfNoise` **non e'
  bocciato, e' rotto** (`REFERTO_PASSO0_OUTOFNOISE_2026-08-29.md`, n=0 su 3
  celle): `CopyRates(...,0,need,r)` conta barre di **calendario** invece che di
  **seduta**, quindi `nDays` resta 4-5 contro `InpConeMinDays=14` e l'EA non
  entra mai. **Ed e' proprio il "momentum intraday M5/M15" che la caccia
  cercava fuori**: la versione ad alta frequenza del paper di Gao e' quella di
  Zarattini-Aziz-Barbon, e il suo porting e' gia' in casa.
- ⛔ **Meccanismi chiusi per ARITMETICA, non per qualita':** gap intraday e
  gap-fill (**un gap di apertura e' UNO al giorno**: nessuna implementazione
  puo' superare il pavimento di 2 segnali/giorno per lato).

## QUINTA BATTUTA CACCIA FREQUENZA (03/09/2026, tre fronti per MECCANISMO) — 0 EA promossi, 3 lapidi misurate, il giacimento e' in casa
- Dossier: `caccia_strategie/CACCIA_FREQUENZA5_TASSONOMIA_2026-09-03.md` (24
  meccanismi in 10 famiglie), `CACCIA_FREQUENZA5_IMPLEMENTAZIONI_2026-09-03.md`
  (8 meccanismi battuti, 47 strategie, 12 sorgenti letti, MISURE su 32.339
  segnali con controllo a ingressi casuali), `report/GIACIMENTO_DI_CASA_2026-09-03.md`
  (122 artefatti censiti).
- **LAPIDI (misurate, non opinate):** (L1) regime post-news 15-30 min su
  Nasdaq: CHIUSO — arXiv 2605.04004 §4.7, 993 eventi, T 0,14-0,69 da barra +6,
  "D127 permanently rejected"; (L2) sweep di micro-pivot sugli indici: densita'
  ok (4,2-4,6/gg) ma TP-prima-di-SL 43-48% contro 49,6% richiesto, 8/8 sotto,
  delta vs caso -0,2 pt su 22.616 segnali; (L3) compressione ATR -> espansione:
  0/8 sopra il pavimento di frequenza, 7/8 sotto H8, delta vs caso -1,2 pt su
  9.723 segnali; (L4) gap intraday: uno al giorno per costruzione, non puo'
  superare il pavimento; (L5) momentum intraday di Gao: morto in casa (R98) per
  attrito overnight che sui CFD non esiste (Elaut-Frommel-Lampaert); (L6)
  contrarian post-sovrareazione su forex/commodity: chiuso dagli autori
  (Caporale-Plastun) e coerente con R42 0/24.
- **CORREZIONE agli atti:** R95 (sweep JPY) NON e' "in coda": `R95_REFERTO.md`
  23/08 = 30/30 passate in perdita, PF 0,65-0,80. E' BOCCIATO.
- **NOVITA' DI METODO:** (a) dati M1 storici raggiungibili via
  raw.githubusercontent (FutureSharks/financial-data, GPL-3: DAX/S&P/Nasdaq/oro
  2005-2020, fuso EST, OHLC non tick, zero costi -> misure di occasioni, mai
  verdetti); (b) controllo a INGRESSI CASUALI con la stessa geometria, sugli
  stessi dati: un win rate senza il suo caso non dice nulla (script in
  `caccia_strategie/biblioteca/sonde_esterne/`); (c) uno zero su arXiv NON e'
  assenza di letteratura (la microstruttura vive su JF/JFE/RFS/JBF, non su arXiv).
- **CONVERGENZA DEI TRE FRONTI:** il materiale migliore e' GIA' IN CASA:
  `ABTG_OutOfNoise` = esattamente il momentum intraday di Zarattini-Aziz-Barbon
  (SFI RP 24-97), baco di warmup gia' corretto (v1.01/v1.02), MAI rigirato ->
  una corsa; Sonda dell'Orologio (celle GBPUSD/oro dopo il Passo C);
  `ABTG_VwapRevert` (M15 DAX, oggi adjudicabile con lo spread misurato);
  `ABTG_AllineaLondra` (M15 EURUSD). Meccanismi nuovi con evidenza da rivista,
  mai toccati: fix valutari (Krohn-Mueller-Whelan JF 2024 — sopravvive SOLO il
  fade dello spike, la deriva muore di costo x2,7), numeri tondi (Osler JF
  2003), salti statistici (Lee-Mykland RFS 2008), lead-lag USA->Europa
  (misurabile con la sonda RELATIVO). Regola nuova proposta: prima di portare
  un meccanismo accademico sui CFD, chiedersi su quale ATTRITO ISTITUZIONALE
  poggia e se esiste su BCM.
- **La mossa piu' economica del prossimo giro:** SPREAD_FLOTTA su
  EURUSD/GBPUSD/XAUUSD (stessa macchina del 03/09, zero modifiche): tutti i
  cancelli forex poggiano ancora su una convenzione.

## 🪦 ABTG_VwapRevert (D30EUR M15) — FALSIFICATO 03/09/2026, cancello S0
Passo 0 girato a tick reali (`backtest_pipeline/risultati_archivio/vwaprevert/CORSA_2026-09-03_1711_FALSIFICATO.txt`):
4 celle (00_nudo, 01_long, 02_short, 03_overnight), tutte **S0 NON PASSA** (rapporto
punti/spread ben sotto 2,5, anzi NEGATIVO su tutte e quattro: -0,11 / -0,21 / -0,14 / -0,21).
Il motore perde in media PIU' dello spread: non e' un problema di costo, e' un problema
di edge. Per la clausola gia' scritta nella bozza dei criteri ("un S0 NON PASSA sulla
00_nudo chiude il capitolo VWAP anche come motore: non si cerca un'altra taratura per
farlo passare"), il candidato e' CHIUSO. n OOS 00_nudo=107 (sotto 150: comunque il
rischio era gia' bocciato dal merito prima che il campione contasse). Nessuna nuova
taratura di InpSigmaMult o altri parametri: il meccanismo VWAP-reversion su D30EUR M15
e' arato.

## 🪦 R116 ABTG_LondonFx EURUSD (M15, tick reali) — BOCCIATA PER RISCHIO, tutti e 3 i motori
`backtest_pipeline/risultati_archivio/r116_londonfx/CORSA_EURUSD_2026-09-03_1751_BOCCIATA.txt`.
IS 2024.07.05->2025.04.21, OOS 2025.04.22->2026.06.30, un solo regime (dichiarato). Motore 2
(canale+RSI, l'unico promuovibile): E OOS=-0,1078R (soglia 0,075R), PF OOS=0,843 (soglia 1,15),
DD OOS=37,14% (tetto 8%), IS gia' in perdita (profit -36.353,98, PF 0,795). Motori 1 e 3
(controlli) bocciati per rischio allo stesso modo (DD 45,29% e 31,26%). Nessuno passa A1/A2/A3/A4.
Ablazione S1: differenza fra motori 0,0561R, sopra soglia 0,05R MA nessun motore passa i cancelli
di merito, quindi nessuna promozione comunque. Fase 2 (slippage) NON dovuta: nessuna cella
passa i cancelli A. **Previsione pre-dichiarata nei criteri (par. 0.2): "NO probabile" -- CONFERMATA.**
Rilievo: motore 1 (controllo, canale nudo) e' strozzato dal tetto giornaliero (38%/22% dei giorni
oltre soglia 20%): il suo posto nel confronto S1 e' contaminato, ma non cambia il verdetto (nessun
motore passa comunque). Spread misurato ed archiviato (F9/H12): EURUSD Londra motore 2, IS mediana
0,200 pip, OOS mediana 0,100 pip. GBPUSD ancora da girare, ma la bocciatura e' PER RISCHIO (non per
frequenza): probabile lo stesso esito, si vede.

## 🪦 R116 ABTG_LondonFx GBPUSD (M15, tick reali) — BOCCIATA PER RISCHIO (numeri peggiori di EURUSD) + BANCO SPORCO su motore 3
`backtest_pipeline/risultati_archivio/r116_londonfx/CORSA_GBPUSD_2026-09-03_1755_BOCCIATA_BANCO_SPORCO.txt`.
Motore 2 (l'unico promuovibile): E OOS=-0,1726R (peggio di EURUSD -0,108R), PF OOS=0,763, DD OOS=55,03%,
IS gia' in perdita pesante (PF 0,688). Motori 1 e 3 bocciati con DD 55-61%. **R116 CHIUSO su entrambi i
simboli, entrambi bocciati per rischio, previsione pre-dichiarata ("NO probabile") confermata due volte.**

⚠️ **PROBLEMA PROCEDURALE, da investigare separatamente:** il gate di sanita' del driver (5.0.1) ha
dichiarato il banco GBPUSD "FERMO" -- i gemelli (stesso motore 3, magic 774001 vs 774002, dovrebbero
dare Profit/Expected Payoff IDENTICI) DIVERGONO su IS e OOS. Non cambia il verdetto (tutti e tre i
motori sono comunque ben dentro la bocciatura per rischio, la divergenza non sposterebbe nessun numero
dentro i cancelli), ma segnala un problema di determinismo/non-riproducibilita' del tester su questo
banco che va capito prima di fidarsi ciecamente dei prossimi round su GBPUSD. Motori 1 e 2 non
segnalati come rotti dal gate.

### SECONDA CACCIA DOPO R116 (03/09 sera) — le righe che toccano questo registro

Dossier completo: `caccia_strategie/CACCIA_LONDRA_ALTERNATIVA_2026-09-03.md`.
Il resto sta li', non si duplica. **ZERO EA promossi, ZERO file prova nuovi.**

- 🪦 **L'APERTURA DI LONDRA E' CHIUSA IN TUTTE E DUE LE FORME "A LIVELLO", e la
  chiusura non viene dal web: viene dai nostri `input`.** I 4 migliori candidati
  esterni letti oggi (TradingView: `4H Range Scalp V3 - Smart Fakeout`,
  `Strategy_500 Turtle Soup NY V5`, `Gold H1 Breakout Failure`,
  `Parent Session Sweeps`) sono **riga per riga `ABTG_BreakinBox`**, che il
  31/08 e' stato misurato a tick su D30EUR e **CHIUSO da lettera congelata**
  (A: TP al lato opposto **PF 1,007 DD 24,1%** · B: RR fisso 2,0 **PF 1,106
  DD 19,7%**, cancello DD <=15%). Verificato negli `input` del nostro EA
  (righe 191-237): `InpConfirmMaxBars=8` **e'** il `max_bars_outside=6` del
  candidato C1; `InpSlBufferPts` **e'** l'SL all'estremo dello sweep;
  `InpMinBoxATR` **e'** il filtro di ampiezza; `InpTP_RR` **e'** l'ablazione.
  👉 **Non si riapre cambiando simbolo**: sarebbe BreakinBox su forex, e R95 ha
  gia' girato quella geometria su EURJPY (**0/30**).
- 🕐 **IL FUSO DI LONDRA E' CHIUSO (aperto come `[INCERTO]` il 19/08 con TRE
  valori diversi in tre posti).** Il Passo 0 di `ABTG_AllineaLondra` (03/09
  16:51) lo scrive misurato: _"l'orologio del server BCM segna la STESSA ora di
  Londra tutto l'anno"_ → **Londra apre alle 08:00 ORA SERVER**. Ne segue che
  `Londra_ORB` ("06-07 server") e R45 ("07:00 server") misuravano la
  **pre-apertura**, non l'apertura.
- 🎯 **L'alternativa vera sulla stessa inefficienza NON e' un range: e' la
  DERIVA ORARIA** (`OROLOGIO_VS_BREEDON_2026-09-03.md`, misurata oggi) —
  EURUSD **SHORT 08:00-16:00 server**, C1 **4,59** su IS 2011-2017 (n=1.607) e
  **5,31** su OOS 2017-2026 (n=2.411), **cella indicata PRIMA dei numeri**.
  Zero livelli, zero rotture: **nessuna parentela con i sei caduti di Londra**,
  e riempie il buco SHORT. Il suo problema e' l'**ESECUZIONE** (~1 bp la uccide),
  non l'edge → la domanda del prossimo round e' *"come si entra senza pagare lo
  spread"*, non *"quale motore"*.
- 🔬 **CONTROLLO DI METODO NUOVO, da rifare sempre: la licenza si verifica
  contro un bersaglio noto.** Prima di scrivere "nessuna licenza" su 8 sorgenti
  ho riscaricato uno script che sappiamo MPL: **l'intestazione c'e'**, quindi il
  canale non la perde. Risultato scomodo: **i due candidati con MPL 2.0 sono
  quelli ROTTI** (`SMC Liquidity Grab Pro` ha `barmerge.lookahead_on`;
  `Falcon Liquidity Grab` ha `low < ta.lowest(low,5)`, condizione
  **matematicamente impossibile**), e i quattro scritti bene non hanno licenza.
  **Una licenza libera non certifica che il codice funzioni.**
- ⛔ **ANGOLO REGIME: bloccato dai DATI, non dall'idea.** `REFERTO_CRT` STAGE-2
  misura che il fade di sessione e' un motore da **CHOP** (2023 **+5.259** su
  n=83; orso 2022 **+2.633**) e **perde nel crollo (−2.760) e nel toro liscio
  (−609)**. I tick BCM coprono **21-24 mesi di solo toro**: il regime in cui la
  famiglia vive **non e' raggiungibile** senza l'import Dukascopy (strumenti
  pronti dal 31/08, **mai lanciati**). Stessa porta di CRT e NY-Retest.
- 🕳️ **Buco dichiarato:** **Osler 2003 (JF) e Osler 2005 (JIMF)** — la tesi
  accademica sotto lo stop-hunt — **NON APERTE**: SSRN 403 (13ª di fila),
  `newyorkfed.org` egress-blocked, mirror `technicalanalysis.org.uk` 403,
  `ideas.repec.org` egress-blocked su due trasporti. ⚠️ E dallo snippet si
  intuisce che taglierebbe **in due direzioni opposte** (il "cascade" dopo il
  livello e' un argomento **pro-breakout**): da leggere prima di citarla.
- 🔧 **Un attrezzo in cassa:** `Dynamic Session Range Sweep Detector`
  (Code Base **76305**, indicatore) — level builder di sessione **in ora
  server**, `PipSize` fatto giusto, e una **penetrazione minima** prima di
  contare uno sweep (`InpMinSweepPips=2,0`) che `ABTG_BreakinBox` **non ha**.
