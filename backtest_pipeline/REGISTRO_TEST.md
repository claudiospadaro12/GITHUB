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
| L3 | DAX_Live5m_v2 | D30EUR | +floor +slippage +direzione, 3 varianti | real tick | solo V3 (PrevWin15+ST) marginale, PF 1.04 | 🟠 in pari |

_Nota: in OHLC i Live5m davano numeri finti enormi (+129k DAX, +30k Nasdaq). In real tick: morti. Lezione: M5/breakout → OHLC inganna._

---

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

### Tassonomia famiglie EA (tutte → backtest → real-tick → forward)
- **NOSTRI (validati):** Oro (SupRev_Multi/EMA200/GoldenCross), DAX aperture LONG, SupertrendReversal indici (DAX H1/H4, Nasdaq H1 in validazione).
- **EMILIANO:** motore aperture + filtri (volumi/direzione D1/correlazione/ampiezza) — test A6.
- **MARCO:** `ABTG_Apertura_Marco` + filtri modulari (RSI/ADX/ATR/MA) + nuovi indici (UK100/Russell/Dow) — test A7.
