# RESOCONTO DI TUTTI GLI EA - PIANO DI LAVORO (FASE 1) - 05/10/2026

> **DOCUMENTO INTERNO. NON ESCE.** Nato dalla richiesta di Claudio del 05/10/2026:
> *"un resoconto di tutti gli EA creati con PF sopra 1 e quelli sotto 1. Per ogni EA: che backtest e' stato fatto,
> che anni sono stati misurati, che tipologie di mercati hanno superato, se sono migliorabili e cosa abbiamo
> bisogno per migliorarli."*
>
> **Questo file e' la FASE 1: enumera e prepara.** Non contiene le schede riempite. Contiene (1) l'elenco
> completo degli EA e delle famiglie, (2) la regola unica di classificazione SOPRA 1 / SOTTO 1 / NON MISURATO,
> (3) la scheda-modello, (4) il piano per far riempire le schede a sei agenti in parallelo.
>
> **Perimetro e vincoli.** Sola lettura d'archivio: nessun EA, preset, parametro o sedia toccati; nessun round
> lanciato (i round, se servono, girano SOLO sul PC di backtest e con firma di Claudio); nessun file di altri agenti
> toccato (DUKA / righe / dukascopy / ombra / regime). Il forward citato e' **solo demo**; niente challenge o trial
> FTMO nel resoconto (Claudio ha deciso di non parlarne all'esterno: il documento e' interno ma resta pulito).
> I numeri di questa pagina sono **ripresi dalle fonti con il tipo di dato dichiarato** (tick `[T]`, barre `[B]`) e **non sono
> stati ricalcolati**: dove la fonte non dichiara il tipo c'e' scritto `[?]`. Le classi sono **provvisorie**: le conferma o
> le smentisce l'agente del gruppo leggendo la fonte primaria.


---

## 1. PERIMETRO E CONTEGGI

| cosa | quanti | nota |
|---|---:|---|
| voci in `mql5/Experts/` ("130 file") | 130 | = **125 `.mq5`** + 2 `.md` (README) + 3 cartelle (`esterni/`, `standalone/`, `trailfix_9fca63d9/`) |
| `.mq5` nella root | 125 | di cui **16 strumenti** (non tradano un'idea: sez. 2) e **109 EA di TRADING** |
| **EA di TRADING (root)** | **109** | l'unita' del resoconto |
| `esterni/` | 1 `.mq5` + 1 `.ex5` | `Nasdaq_PreOpen_Breakout_EA.mq5` (mai girato) e `NasdaqOpeningBreakout_EA_v21_OPTIMIZED.ex5` (binario orfano, senza sorgente) |
| `standalone/` | 22 `.mq5` | 19 sono copie "tutto-in-uno" di EA della root (**diverse** dalla root: `cmp` = diff su tutti e 19); **3 esistono SOLO li'**: `ABTG_PointBreak`, `ABTG_SuperFilter`, `ABTG_FiboH4` |
| `trailfix_9fca63d9/` | 3 `.mq5` + 3 `.patch` | `CLAU12_*`: copie del pin `9fca63d9` + guardia trailing, **NON in campo** |
| **Righe nell'elenco della sez. 4** | **116** | 1 riga = 1 EA (alcune righe raggruppano 2-3 file gemelli); le varianti (`_Ottimizzato`, `_Pin9fca`, `_TrailFix`, copie standalone/CLAU12) stanno ciascuna sulla riga della propria famiglia |
| **Famiglie di motore** | **26** | sez. 3 |
| Gruppi di lavoro proposti | **6** | sez. 7 |

**Verifica d'integrita' dell'elenco**: ognuno dei 109 EA di trading della root compare **una sola volta** nella sez. 4 (controllo
fatto per nome con confini di parola, 0 mancanti, 0 doppi). I 16 strumenti stanno nella sez. 2.

**Cose che NON sono nel perimetro e si dichiarano**: (a) `mql5/Indicators/` e `mql5/Scripts/` (non sono EA); (b) i 25 `.mq5` di
`backtest_pipeline/caccia_strategie/biblioteca/sorgenti/`, 1 in `docs/sorgenti_ricevuti/` e 3 in `backtest_pipeline/toppe_da_applicare/` (sorgenti di terzi *letti* o toppe, non nostri EA);
(c) `BREAKOUT_EA_JPY_v3` (famiglia citata in `CENSIMENTO_CONTRATTI_v2` §4d: **sorgente non presente** nel repo); (d) i candidati
cacciati sul web che **non sono mai arrivati a un `.mq5`** (88 righe esterne in `CENSIMENTO_SCARTATI_PROSA` sez. B): non sono "EA creati".


---

## 2. I 16 STRUMENTI (NON ENTRANO NELLA CLASSIFICA PF)

Non hanno un PF perche' non sono una strategia. Il loro **esito** pero' rientra nelle schede delle famiglie (colonna "sonde / strumenti collegati").

| strumento | cosa fa | famiglia collegata |
|---|---|---|
| `ABTG_Guardian` | modulo di rischio sul conto: pausa giornaliera, cap sul rischio aperto, emergenza | trasversale (rischio) |
| `ABTG_SlippageLogger` · `ABTG_SpreadLogger` · `ABTG_TradeExporter` | logger / esportatore dei trade (attribuzione per magic e commento) | trasversale (dati) |
| `ABTG_StopManuale` | guardia dello stop per operazioni MANUALI (richiesta 25/09); non apre mai | nessuna |
| `ABTG_MIS_SIZING_EMA200` · `ABTG_MIS_SIZING_SWDOW` | strumenti di misura del sizing: *non e' una sedia, mai su un conto vivo* | EMA200 / SW |
| `ABTG_Apertura_Study_EA` | studio dell'apertura per lo Strategy Tester (un passaggio) | AP-* |
| `ABTG_EMA200_Ombra` | modalita' ombra della dashboard EMA200: **zero chiamate di trading**, scrive esiti simulati in R | EMA200 |
| `ABTG_SondaGapCash` | contatore del gap della sessione cash Nasdaq (A69: segno rovesciato sui tick BCM) | AP-NAS |
| `ABTG_SondaLondonFx` | contatore segnali LondonFx (passo 0 superato 03/09) | LONDRA |
| `ABTG_SondaM0PB` | contatore M0PB (morto al passo 0, 31/08) | CAC-C |
| `ABTG_SondaMargine` | stampa le specifiche di margine dentro il tester | nessuna |
| `ABTG_SondaOrologio` | sonda dell'orologio del broker (ramo DAX: LONG = -SHORT esatto) | trasversale (orologio) |
| `ABTG_SondaRelativo` | contatore attraversamenti z-score (passo 0 del candidato Relativo) | CAC-C |
| `ABTG_SondaRsiEmaV8` | contatore RSI+EMA V8 (non promosso 03/09) | CAC-C |


---

## 3. LE 26 FAMIGLIE DI MOTORE

Raggruppate per **motore del segnale** (la mappa di partenza e' `docs/MAPPA_MOTORI_EA.md`, rivista: la SuperWave e' un incrocio 14/200, non un rimbalzo).
Una famiglia puo' contenere sedie su simboli diversi: la classificazione SOPRA/SOTTO si fa per **cella** (EA x simbolo x TF x lato), non per file.

| codice | gruppo | motore in una frase | EA (file) | numero-bandiera gia' in archivio |
|---|---|---|---|---|
| AP-DAX | G1 | Apertura DAX: range dei primi 35' dopo l'apertura, ritest/breakout, 1 operazione/giorno | ABTG_DAX_Apertura_EU (+Ottimizzato, Pin9fca, TrailFix, CLAU12), Apertura_Marco, Apertura_3Ingressi, DAX_MASTER_PROP | long 1,13/1,40 (n 132/193) [T]; short 0,97/0,96 [T] |
| AP-DOW | G1 | Apertura Dow: come DAX, con filtro di trend EMA H4 | ABTG_Dow_Apertura_US (+Pin9fca, TrailFix, CLAU12) | long 1,22/1,27 (n 56/96) [T]; short 0,84 su 73 [T] |
| AP-NAS | G1 | Apertura Nasdaq: ritest con filtro volumi; gated short; preopen esterno | ABTG_Nasdaq_Apertura_US (+Ott, Pin9fca, TrailFix, CLAU12), esterni/Nasdaq_PreOpen | retest 1,14/1,11 oppure 1,22/1,22 (non riconciliate) [T] |
| LIVE5 | G1 | Live 5 minuti: rottura della candela pre-apertura (osservazione, 'morti') | ABTG_DAX_Live5m, _v2, ABTG_Nasdaq_Live5m | a tick 0,86 / 0,93 / 0,96 contro 1,47 / 1,71 / 2,16 a barre |
| DAXM3 | G1 | DAX M3 trend-following con bias H4 | ABTG_DAX_M3, DAX_M3_Supertrend | 33% combo positive [B] |
| EMA200 | G2 | EMA200: ordini limite attorno alla media a 200 | ABTG_EMA200 (+Ott oro, Multi_BANCO), tool: Ombra, MIS_SIZING | Dow H1 1,20/1,52 (n 132?/257) [T] |
| SW | G2 | SuperWave: incrocio EMA14xEMA200 accettato se concorde col Supertrend (+ variante M3) | ABTG_SuperWave, _DOW_H1_Ott, _DAX_H4_Ott, _EA | Dow H1 1,85/1,33 (contesa) [T] |
| ORB | G2 | Opening Range Breakout (primo quarto d'ora) + Londra + fibo + toolkit esterni | ABTG_ORB, _Ott, _Fibo, Londra_ORB, ORB_OpeningRange, ORB_DAX_BASE/PM | Dow long 1,25/1,67 (n 71/119) [T] |
| SUPREV | G5 | Supertrend Reversal: rimbalzo sul Supertrend (H1/H4, oro/indici) | ABTG_SupertrendReversal(+Multi, Ott, Multi_Ott), 6 x SupRev_*_Ott, SupertrendInvert | oro 2,74-3,17 bt; DOW H4 0,79 reale |
| GC | G5 | Golden Cross 9/21 con filtri (H1/H4) | ABTG_GoldenCross (+Ott, V1) | oro H1 1,58 bt; forex 0/6 celle |
| ORO-EXT | G5 | EA esterni sull'oro (Ichimoku, scalper TK, ORB Fibonacci, breakout livelli) | Gold_Ichimoku_TK_ATR_EA, Gold_Scalper_TK_BB_BE_EA, IchiCross_Gold_722, IchiTrend_Gold_Base, ORB_GOLD_FIBONACCI(+v3.21), GoldBreakout_Levels | nessun PF in archivio |
| NOTTE | G3 | Box notturno / fade notturno: MaxMinNotte, BreakinBox, Nightly | ABTG_MaxMinNotte (+DAX_Short_Ott, _MFE), BreakinBox, Nightly (+Ott) | DAX short 1,88/2,16 su 14 pos [T]; oro 1,45 tick / 1,10 su 22 anni |
| PTE-WOL | G3 | PTE (EMA200 + canali) e WOL (D1) | ABTG_PTE (+Ott), ABTG_WOL | GBPUSD segno invertito fra feed |
| POSTNEWS | G3 | Operativita' dopo notizie macro (ECB, FOMC, NFP) | ABTG_PostNews | Trades=0 in tutti i CSV archiviati |
| BULGE | G3 | Mean-reversion su bande di volatilita', 15 cross forex H1 | ABTG_Bulge, BULGE_MASTER | 0,87/0,82 su 4 mesi [B] |
| LONDRA | G3 | Sessione di Londra (canale, RSI, 5 medie) | ABTG_LondonFx, ABTG_AllineaLondra | 0,76-0,92 [T], DD 31-61% |
| BB | G4 | Breaking Band (forex H1) | ABTG_BreakingBand | WF n 11-26 deal; lungo 0,90 su 27 anni [B] |
| C2C | G4 | Cost-to-cost (H4 forex/argento) | ABTG_CostToCost | EURJPY per regime 0,02-2,65 [B] |
| EZ | G4 | Easy Trend (LinReg candle + CCI, H1) | ABTG_EasyTrend, EasyTrend_EURUSD | 1,01-1,07 [B], DD 16-22% |
| GAP | G4 | Gap fill e gap continuation | ABTG_GapFill, ABTG_GapContinuation | 774101: 1,398 su 70 [T]; GapFill n 8-20 |
| LARRY | G4 | Punte di Larry (H1 multi-simbolo) | ABTG_PunteLarry | U30USD n 38; EURAUD n 216 [B] |
| FIBO | G4 | Fibo H4 (engulfing + livelli proprietari) | ABTG_FiboH4_Multi, ABTG_FiboH4_Corso, standalone/FiboH4(+_Multi) | '0/8' = un numero contato 8 volte |
| CORSO-JPY | G4 | Breakout Williams %R + SuperTrend, cross JPY (dal corso) | ABTG_BreakoutCorso, BREAKOUT_EA_JPY(+_Multi) | 48/48 OOS negative; PF 0,67-0,95 |
| CAC-A | G6 | Caccia web: reversal / mean-reversion / stagionali | VwapRevert, MeanRevert, TurnaroundTuesday, InvEsaurimento, PointBreak, SuperFilter | quasi tutti bocciati |
| CAC-B | G6 | Caccia web: breakout / struttura / volatilita' / sessione | CRT_TurtleSoup, IBRetest, LVNArbitro, OpeningReversalB, OutOfNoise, NySessionRetest, DaxReEntry, DaxValueArea, HVAncora, AtrExhaustVol, IntradayMomentum, LiquiditySweep, FvgRetest, ImpulsoApertura, VolExpBreak, CanaleLento, Cycle | qualche cella sopra 1 con n<150 |
| CAC-C | G6 | Caccia web: medie / oscillatori / coppie / scalper | CrossEma, CrossEmaApertura, ChaosLyapunov, AltaVelocita, HARSI(+Assistant), Relativo, ScalperDirezionale | quasi tutti bocciati |

---

## 4. ELENCO COMPLETO DEGLI EA DI TRADING (nome -> famiglia -> sorgente principale -> stato noto)

**Come leggere.** Ruolo = dove gira / a cosa serve. Stato noto = una riga con il numero **come scritto nella fonte** (il censimento del 09/09 e' la base;
i round successivi al 09/09 -- R242-R247, R255, R260-R269, ROUND CORTI B/C/C2 -- sono nel `REGISTRO_TEST.md` della root e vanno riletti dal gruppo).
`[T]` tick reali BCM (modello 4) · `[B]` barre OHLC (modello 1) · `[?]` tipo non dichiarato dalla fonte. **Classe provvisoria**: da confermare (sez. 5).
`EREDITA` = copia/pin senza misura propria, vale la riga dell'EA madre. Il tag "(sospeso)" = n<150, merito sospeso per la valvola R59.


### G1 - APERTURE e live5m (sedie 770xxx indici)

| # | EA (file) | famiglia | ruolo | sorgente principale | stato noto (1 riga con numero) | classe provvisoria |
|---:|---|---|---|---|---|---|
| 1 | `ABTG_DAX_Apertura_EU` | AP-DAX | sedia (770101 long, 770105 short) | report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md §2; report/APERTURE_DAX_MAPPA_2026-10-03.md | long: PF IS 1,13 / OOS 1,40, pos 132/193, DD 5,4/7,2% @1% [T] 21 mesi, 1 regime; short: 0,97/0,96, DD 7,5/12,3% [T]; orologio: short estate 1,39 (96 pos) vs inverno 0,90 (85) | MISTA (long SOPRA con IS<150; short SOTTO) |
| 2 | `ABTG_DAX_Apertura_EU_Ottimizzato` | AP-DAX | variante storica (ex 770111, 26/07) | backtest_pipeline/CLASSIFICA_PF.md #11; FLOTTA_ATTIVA.md | PF bt 1,49, DD 3,8% [T] finestra piena 2024.01-2026.06 (su indici = 21 mesi), NESSUN OOS; sostituita dalla cella R47 | SOPRA (senza OOS) |
| 3 | `ABTG_DAX_Apertura_EU_Pin9fca` | AP-DAX | copia pin (build compilata, commit 9fca63d9) | mql5/Experts/trailfix_9fca63d9/LEGGIMI.md | stesso codice della sedia 770101 (copia byte per byte): nessuna misura propria, eredita la riga di ABTG_DAX_Apertura_EU | EREDITA |
| 4 | `ABTG_DAX_Apertura_EU_TrailFix` | AP-DAX | variante di prova NON IN CAMPO (guardia trailing, 25/09) | mql5/Experts/trailfix_9fca63d9/LEGGIMI.md; report/MODIFY_A_RAFFICA_FTMO_2026-09-25.md | prova di neutralita' (deal identici al centesimo, righe 'invalid stops' N->0) descritta ma NON girata: nessun PF proprio | NON MISURATO |
| 5 | `trailfix_9fca63d9/CLAU12_DAX_Apertura_EU.mq5` | AP-DAX | variante di prova NON IN CAMPO (rinomina CLAU12 del TrailFix) | mql5/Experts/trailfix_9fca63d9/LEGGIMI.md | come TrailFix: sorgente pronto, mai misurato | NON MISURATO |
| 6 | `standalone/ABTG_DAX_Apertura_EU.mq5` | AP-DAX | copia 'tutto-in-uno' (08/09), diversa dalla root | mql5/Experts/standalone (copie dell'8/09) | nessuna misura propria nel repo; eredita il motore | EREDITA |
| 7 | `ABTG_Apertura_Marco` | AP-DAX | sedia RITIRATA 06/08 (770301) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A95; FLOTTA_ATTIVA.md | doppione esatto di DAX_Apertura_EU: stesso trade allo stesso secondo, 2%+2%=4% su un segnale; 06/08 -205,92 col gemello; nessun PF proprio | NON MISURATO (doppione) |
| 8 | `ABTG_Apertura_3Ingressi` | AP-DAX/NAS | laboratorio R83 (duello degli ingressi, DAX/Nasdaq) | backtest_pipeline/REGISTRO_TEST.md 'R83'; report/CENSIMENTO_PF_MISURATI_2026-09-09.md | 6 righe con OOS n>=100: 2 sopra / 4 sotto 1, PF mediano OOS da 0,62 a 1,19 [tipo non dichiarato nel censimento]; R83 = ingressi breakout/retest | MISTA |
| 9 | `DAX_MASTER_PROP` | AP-DAX | esterno: consolidato DAXMasterEA v2.0 + 5 protezioni 'low-DD' | report/CENSIMENTO_RISCHIO_VERO_2026-09-10.md (citato); sorgente | nessuna riga PF/OOS nel censimento 09/09; origine esterna | NON MISURATO |
| 10 | `ABTG_Dow_Apertura_US` | AP-DOW | sedia (770202 long) | report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md §2; report/APERTURE_DOW_MAPPA_2026-10-03.md | long: PF IS 1,22 / OOS 1,27, pos 56/96, DD 5,7/4,4% [T] 21 mesi; short: IS 1,51 -> OOS 0,84 su 73 (ribaltamento) [T]; in fase: estate 0,89 (84) / inverno 0,92 (40) | MISTA (long SOPRA sospeso; short SOTTO) |
| 11 | `ABTG_Dow_Apertura_US_Pin9fca` | AP-DOW | copia pin (9fca63d9) | mql5/Experts/trailfix_9fca63d9/LEGGIMI.md | copia del sorgente in campo: eredita ABTG_Dow_Apertura_US | EREDITA |
| 12 | `ABTG_Dow_Apertura_US_TrailFix` | AP-DOW | variante di prova NON IN CAMPO | mql5/Experts/trailfix_9fca63d9/LEGGIMI.md | prova di neutralita' non girata: nessun PF proprio | NON MISURATO |
| 13 | `trailfix_9fca63d9/CLAU12_Dow_Apertura_US.mq5` | AP-DOW | variante di prova NON IN CAMPO | mql5/Experts/trailfix_9fca63d9/LEGGIMI.md | come TrailFix Dow | NON MISURATO |
| 14 | `ABTG_Nasdaq_Apertura_US` | AP-NAS | sedie (770260 retest due lati; 770250 gated short; 770201 breakout SPENTA 18/08) | report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md §2; report/APERTURE_NASDAQ_MAPPA_2026-10-03.md; report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A3/A87 | 770260: PF 1,14/1,11 su 91/94 pos (altra misura 1,22/1,22 su 82/102, NON riconciliate) DD 6,0/3,7% [T]; 770250: 1,097 [T] toro / 1,84 [B] orso; breakout 770201 OOS 0,82 (19/20 negative); short R107 OOS 0,46 | MISTA (retest SOPRA sospeso; breakout/short SOTTO) |
| 15 | `ABTG_Nasdaq_Apertura_US_Ottimizzato` | AP-NAS | variante storica (26/07) | backtest_pipeline/CLASSIFICA_PF.md ('Nasdaq_Apertura_US' 0,91 'morto') | default OHLC: PF 0,91 'morto' (cella A4 solo long, 0% combo positive) [B] finestra unica | SOTTO |
| 16 | `ABTG_Nasdaq_Apertura_US_Pin9fca` | AP-NAS | copia pin (9fca63d9) | mql5/Experts/trailfix_9fca63d9/LEGGIMI.md | eredita ABTG_Nasdaq_Apertura_US | EREDITA |
| 17 | `ABTG_Nasdaq_Apertura_US_TrailFix` | AP-NAS | variante di prova NON IN CAMPO | mql5/Experts/trailfix_9fca63d9/LEGGIMI.md | nessun PF proprio | NON MISURATO |
| 18 | `trailfix_9fca63d9/CLAU12_Nasdaq_Apertura_US.mq5` | AP-NAS | variante di prova NON IN CAMPO | mql5/Experts/trailfix_9fca63d9/LEGGIMI.md | nessun PF proprio | NON MISURATO |
| 19 | `esterni/Nasdaq_PreOpen_Breakout_EA.mq5 (+ NasdaqOpeningBreakout_EA_v21_OPTIMIZED.ex5)` | AP-NAS | esterno, MAI GIRATO (audit: fuso cablato + costo 13,3x) | report/CENSIMENTO_ORB_2026-09-29.md; report/CENSIMENTO_CONTRATTI_v2.md (.ex5 orfano 12/08) | nessun PF: .mq5 mai girato; .ex5 senza sorgente (non misurabile per costruzione) | NON MISURATO |
| 20 | `ABTG_Nasdaq_Apertura_US (standalone)` | AP-NAS | copia 'tutto-in-uno' (08/09) | mql5/Experts/standalone | nessuna misura propria | EREDITA |
| 21 | `ABTG_DAX_Live5m` | LIVE5 | 'morto' tenuto in osservazione | backtest_pipeline/REGISTRO_TEST.md §2; report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A4 | D30EUR M5: OHLC OOS 1,47 -> tick 0,857 (fattore 1,72); IS 27/27 combo negative [B/T] | SOTTO |
| 22 | `ABTG_DAX_Live5m_v2` | LIVE5 | 'morto' in osservazione | backtest_pipeline/REGISTRO_TEST.md §2; report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A6 | D30EUR M5: OHLC OOS 1,71 -> tick 0,925 (1,85x), DD 15-26% [T] | SOTTO |
| 23 | `ABTG_Nasdaq_Live5m` | LIVE5 | 'morto' in osservazione | backtest_pipeline/REGISTRO_TEST.md §2; report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A5 | NASUSD M5: OHLC OOS 2,16 -> tick 0,963 (2,25x); IS 27/27 negative [B/T] | SOTTO |
| 24 | `ABTG_DAX_M3` | DAXM3 | 'morto' (osservazione) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A8; backtest_pipeline/CLASSIFICA_PF.md | D30EUR M3: 33% combo positive, short 0% [B] finestra unica | SOTTO |
| 25 | `DAX_M3_Supertrend` | DAXM3 | riscrittura v2 (esterna) di DAX M3 | report/CENSIMENTO_RISCHIO_VERO_2026-09-10.md (citato) | nessuna riga PF nel censimento 09/09 | NON MISURATO |
| 26 | `standalone/ABTG_DAX_M3.mq5 · standalone/ABTG_DAX_Live5m.mq5 · standalone/ABTG_Nasdaq_Live5m.mq5` | LIVE5/DAXM3 | copie tutto-in-uno | mql5/Experts/standalone | ereditano le righe degli EA omonimi | EREDITA |

### G2 - EMA200 + SUPERWAVE + ORB (sedie 771531, 770511/12/31, 770611)

| # | EA (file) | famiglia | ruolo | sorgente principale | stato noto (1 riga con numero) | classe provvisoria |
|---:|---|---|---|---|---|---|
| 27 | `ABTG_EMA200` | EMA200 | sedia 771531 U30USD H1 (+ nativi H4: 771511-15 AUDJPY/GBPJPY/SPX/GBPUSD/200AUD) | report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md; report/EMA200_GEMELLI_STATO_2026-10-03.md; report/LETTURA_ROUND_CORTI_C2_2026-09-28.md | Dow H1: PF IS 1,20 / OOS 1,52, pos ~132 (dich.)/257, DD 5,7/7,8% [T] 21 mesi 1 regime; gemelli TF: H2 1,17, H4 1,42, M30/H3 0,91; oro H4 PF tutta la storia 0,993 [B]; EURUSD H4 corto ESCLUSO PER COSTO; rimbalzo al tocco H4 6 coppie NULLO | MISTA (Dow H1 SOPRA; oro H4 SOTTO) |
| 28 | `ABTG_EMA200_Ottimizzato` | EMA200 | sedia 971501 XAUUSD H4 (26/07) | backtest_pipeline/CLASSIFICA_PF.md #6; report/CENSIMENTO_CONTRATTI_v2.md §4b | PF bt 1,92 [T finestra piena]; DD 45,91% @1% su 22 anni [B] -> 'prop NO a nessuna taglia' (firma 23/08); censimento OOS mediano 1,25 n 268 | MISTA (SOPRA in OOS; rischio rosso) |
| 29 | `ABTG_EMA200_Multi_BANCO` | EMA200 | copia di BANCO (mandato 01/10: indici e oro, tester/demo) | mql5/Experts/ABTG_EMA200_Multi_BANCO.mq5 (README in testa) | non e' una sedia; nessun PF proprio nel repo (v0.10) | NON MISURATO |
| 30 | `standalone/ABTG_EMA200.mq5` | EMA200 | copia tutto-in-uno | mql5/Experts/standalone | eredita ABTG_EMA200 | EREDITA |
| 31 | `ABTG_SuperWave` | SW | sedie 770531 U30USD H2 · 770532 GBPUSD H2 SPENTA 24/08 · (DAX H1/Nasdaq H4/oro negativi) | report/CENSIMENTO_CONTRATTI_v2.md §4a; report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A27-A30 | U30USD H2: DD 2,96%, 50 pos [T]; GBPUSD H2 6,5 anni PF 0,79, 5/7 anni negativi, DD 13,4% [B]; toro 2021 PF 0,56; DAX H1 0,84 max; Nasdaq H4 n 16-18 | MISTA (U30USD SOPRA?; GBPUSD SOTTO) |
| 32 | `ABTG_SuperWave_DOW_H1_Ottimizzato` | SW | sedia 770511 U30USD H1 | report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md §5; report/CORSIA_DEMO_SUPERWAVE_DAX_2026-09-08.md | PF IS 1,85 / OOS 1,33 (conteso 1,48/1,24), DD 3,7/3,9% [T]; n posizioni NON MISURATO (143/84 uscite); trailing Supertrend OFF: IS 1,49->0,90; short OOS 0,43 su 84 | SOPRA (contratto conteso) |
| 33 | `ABTG_SuperWave_DAX_H4_Ottimizzato` | SW | 770512 D30EUR H4 (NON IN CAMPO) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A31; FLOTTA_ATTIVA.md | PF IS 1,28, 56 pos, DD 3,3% [T] finestra piena 7/9 celle positive; frequenza 0,12 op/g; n 56 <150 | SOPRA (sospeso) |
| 34 | `ABTG_SuperWave_EA` | SW | variante A: Supertrend H4 + inversione M3 (grafico D30EURM3 'test M3') | report/H4_M3_CONFLUENZA_MISURA_2026-10-01.md (via docs/gemini/BASE_CONOSCENZA...) | confluenza H4/M3 come timing: NULLO su DAX e oro (misura d'effetto, non PF di EA); nessun PF proprio nel repo | NON MISURATO (effetto NULLO) |
| 35 | `ABTG_ORB` | ORB | 'marginale' nativo Nasdaq M5 | backtest_pipeline/CLASSIFICA_PF.md; report/ORB_NASDAQ_PERCHE_E_SPENTO_2026-09-23.md; report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A76 | Nasdaq M5: bt 1,15; OOS mediano 1,25 n 357 [B?]; R97 stop all'estremo opposto: IS 1,13-1,32, OOS 0,84-0,91 su 4/4 celle [T]; ORB Nasdaq spento | SOTTO (a tick R97) |
| 36 | `ABTG_ORB_Ottimizzato` | ORB | sedia 770611 U30USD M5 long | report/CENSIMENTO_ORB_2026-09-29.md; report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md | IS 1,25 (71 pos) / OOS 1,67 (119), DD 7,9/9,8% @1% [T]; slippage 1,5 pt: DD >10%; short OOS 0,52 DD 26,4% (R54); forward 8 pos PF 0,27 | SOPRA (sospeso n<150) |
| 37 | `ABTG_ORB_Fibo` | ORB | 'morto' (osservazione) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A7 | Nasdaq M5: 29% combo positive [B] finestra unica | SOTTO |
| 38 | `ABTG_Londra_ORB` | ORB | 'morto' (osservazione) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A9/A82 | GBPUSD M5: R45 0/48 a tick, DD 23%; MA il fuso era sbagliato (misurava la pre-apertura, 03/09): verdetto da rifare | NON MISURATO (verdetto compromesso dal fuso) |
| 39 | `ORB_OpeningRange` | ORB | esterno semplice | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A106 (classe 5) | duplica famiglie ORB gia' sepolte; nessuna misura propria | NON MISURATO |
| 40 | `ORB_DAX_BASE_EA · ORB_DAX_PM_EA` | ORB | esterni (ABTG Toolkit ORB, webinar 02/03/2026) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A106 | duplicano ORB; nessuna riga PF | NON MISURATO |

### G3 - NOTTE, EVENTI, TREND-EMA, BULGE, LONDRA (770402/770411, 771xxx)

| # | EA (file) | famiglia | ruolo | sorgente principale | stato noto (1 riga con numero) | classe provvisoria |
|---:|---|---|---|---|---|---|
| 41 | `ABTG_MaxMinNotte` | NOTTE | sedie 770411 D30EUR short M15 (via Ott.) · 770402 XAUUSD H2 long · EURUSD M15 | report/REFERTO_R242_2026-09-24.md; report/REFERTO_R244_2026-09-24.md; report/STATO_MAXMIN_DAX_LONG_E_ORO_2026-09-26.md | DAX R242: long 0/7 celle sopra 1 (PF 0,73-0,94), short 1,02-1,47 n<150; oro: tick OOS 1,45 su 93 pos, 22 anni [B] PF 1,10 DD 10,3% @0,5%, 11 anni negativi su 23; TF DAX mai cambiato | MISTA (short/oro tick SOPRA; long DAX SOTTO) |
| 42 | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` | NOTTE | sedia 770411 D30EUR short M15 | report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md §4 | PF IS 1,88 / OOS 2,16 su 14 pos (21 deal), DD 3,1/1,9% @1% [T]; freq. 0,051 op/g; n=14 non decide | SOPRA (sospeso n=14) |
| 43 | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato_MFE` | NOTTE | copia di SOLA MISURA (R104) | backtest_pipeline/REGISTRO_TEST.md (R104) | MFE trailing: n=29, NON MISURABILE | NON MISURATO |
| 44 | `ABTG_BreakinBox` | NOTTE | falsa rottura del box notturno (candidato) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A50/A51 | D30EUR M15 tick: OOS 1,007 DD 24,1%; RR 2,0: 1,106 DD 19,7% (cancello DD<=15% fallito) | SOPRA (PF ~1; NO PER RISCHIO) |
| 45 | `ABTG_Nightly` | NOTTE | fade notturno (EURUSD M15 'edge EURUSD') | report/NIGHTLY_SEI_SIMBOLI_2026-09-26.md; report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A39-A41; report/I_MORTI_E_LO_STORICO_2026-09-23.md §0.5 | EURCHF IS 0,89 / OOS 0,81 (n 63/85, DD 11,1/15,4%); forex 3 coppie IS negativo; ATTENZIONE giudicato su 21 mesi per errore di copia (EURCHF parte dal 1993): finestra da rifare | SOTTO provvisorio (certificato INCOMPLETO) |
| 46 | `ABTG_Nightly_Ottimizzato` | NOTTE | copia (439 righe come Nightly) | mql5/Experts | nessuna misura propria | EREDITA |
| 47 | `ABTG_PTE` | PTE-WOL | sedie 771321 U30USD H1 · 771322/771332 GBPUSD H1 (duello) · 771323 USDJPY SPENTA | report/REFERTO_ROUND80_REGIME_PTE (R80); FLOTTA_ATTIVA.md (duello); report/CENSIMENTO_CONTRATTI_v2.md §4a | GBPUSD 13 anni [B] storica 0,972 (DD 17,7%) / candidata 1,095; a tick 2 anni il contrario (+2.091 / +1.172); regimi: USDJPY solo laterale; segno invertito col feed; Dow H1 DD 2,18% su 23 pos | MISTA |
| 48 | `ABTG_PTE_Ottimizzato` | PTE-WOL | variante ottimizzata (GBPUSD/U30USD/USDJPY) | report/CENSIMENTO_PF_MISURATI_2026-09-09.md | 4 righe OOS, tutte con n<100 [tipo non dichiarato] | NON MISURATO (campione) |
| 49 | `ABTG_WOL` | PTE-WOL | D1 oro/indici (osservazione) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A108 | 'profitti da spread, artefatto'; 5 celle OOS n>=100 con PF 0,02-0,46 [tipo non dichiarato] | SOTTO |
| 50 | `ABTG_PostNews` | POSTNEWS | sedie 771201 ECB EURJPY · 771202 FOMC EURUSD · 771203 NFP USDJPY | report/POSTNEWS_TRE_SEDIE_2026-10-02.md; report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md §7; report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A36-A38 | tre sedie: CSV con Trades=0 -> NON MISURATO (nessun PF/DD/n); candidati ISM EURUSD IS 0,76/OOS 0,79 (n 234/312) e USDJPY 0,66/0,90 (151/253) [T] | NON MISURATO (sedie) · SOTTO (due candidati) |
| 51 | `ABTG_Bulge` | BULGE | 'Bulge viola' mean-reversion H1 15 cross forex | report/BULGE_COME_MIGLIORARLO_2026-10-03.md; docs/Analisi_EA_BULGE.md | 4 mesi mie misure [B]: PF 0,87/0,82 (410/363 op), DD 13,7/22,8% @0,8%; forward predecessore PF 0,83 su 297; lordo costi 0,92; l'1,60/n268 e' del backtest di partenza (non nostro) | SOTTO |
| 52 | `BULGE_MASTER` | BULGE | consolidamento esterno di 8 versioni 'Bulge Multi Signal' | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A106 | fade Bollinger gia' sepolta (R108/R111): 'nessuno merita spesa'; nessuna misura propria | NON MISURATO |
| 53 | `ABTG_LondonFx` | LONDRA | contenitore R116: 3 motori (canale / canale+RSI / 5 medie), EURUSD/GBPUSD M15 | backtest_pipeline/REGISTRO_TEST.md 'R116'; report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A53-A56 | EURUSD OOS 0,843/0,898/0,923, DD 37,1/45,3/31,3%; GBPUSD 0,763, DD 55% [T]: BOCCIATA PER RISCHIO | SOTTO |
| 54 | `ABTG_AllineaLondra` | LONDRA | allineamento 5 medie in Londra (P2, 28/08) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A65/A55 | EURUSD M15: OOS 0,60-1,12, profitto negativo su 7/8 letture, DD 10,4-46,6% | SOTTO |

### G4 - FOREX 'famiglie di agosto' (sedie 772xxx e 774101) + Fibo + Corso

| # | EA (file) | famiglia | ruolo | sorgente principale | stato noto (1 riga con numero) | classe provvisoria |
|---:|---|---|---|---|---|---|
| 55 | `ABTG_BreakingBand` | BB | sedie 772161 GBPUSD · 772162 EURUSD · 772163 AUDUSD H1 | report/CENSIMENTO_CONTRATTI_v2.md §4c; report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A88/A89; report/LE_QUATTRO_EPOCHE_GIA_MISURATE_2026-09-23.md | WF OOS: n 26/13/11 deal, DD 3,4/1,2/1,2% [T]; M15 0/3, M30 0/3 (GBPUSD 1,087 n174); GBPUSD 27 anni dal 1999 [B] PF 0,90 DD 23,4% | MISTA (WF corto SOPRA; lungo SOTTO) |
| 56 | `ABTG_CostToCost` | C2C | sedie 772361 EURJPY H4 · 772362 GBPCAD H4 · 772363 XAGUSD SPENTA | report/CENSIMENTO_CONTRATTI_v2.md §4c; report/I_MORTI_E_LO_STORICO_2026-09-23.md | EURJPY 394 pos DD 12,3% @1% [B] 6,5 anni, regimi PF 2,65/1,69/1,05/1,38, crollo feb-apr 2020 PF 0,02 su 23; GBPCAD PF 0,92 DD 41,5%; XAG 0,70 | MISTA (EURJPY SOPRA per regime; GBPCAD/XAG SOTTO) |
| 57 | `ABTG_EasyTrend` | EZ | sedie 772421 CHFJPY · 772422 GBPUSD · 772423 AUDJPY SPENTA H1 | report/CENSIMENTO_CONTRATTI_v2.md §4c | GBPUSD 254 pos DD 15,8% [B] 6,5 anni; CHFJPY PF 1,07, 4/7 anni negativi; AUDJPY 1,01 DD 15,9%; famiglia BOCCIATA in portafoglio (R49) | SOPRA (PF ~1,0-1,1; rischio rosso) |
| 58 | `EasyTrend_EURUSD` | EZ | esterno H1 (LinReg candle + CCI) | mql5/Experts (sorgente); report/CENSIMENTO_PF_MISURATI_2026-09-09.md | nessuna riga PF dedicata nel censimento 09/09 | NON MISURATO |
| 59 | `ABTG_GapFill` | GAP | sedie 772231-35 (GBPUSD/EURUSD/AUDUSD/U30USD/225JPY) | report/CENSIMENTO_CONTRATTI_v2.md §4c | WF OOS n 8-20 pos (nessun parziale), DD 1,9-4,3% [T]; 225JPY PF 1,14 (il piu' tirato); 772234 esclusa dal portafoglio R37 | SOPRA (campione sottile) |
| 60 | `ABTG_GapContinuation` | GAP | sedia 774101 225JPY M1 | FLOTTA_ATTIVA.md; report/PERCHE_NON_PASSANO_2026-09-09.md | OOS PF 1,398, n 70 (deal), DD 11,59%, +8.339,62 [T]; short -2.182 (profitto tutto long); cella PICCO non altopiano | SOPRA |
| 61 | `ABTG_PunteLarry` | LARRY | sedie 772341-46 (U30USD, EURAUD, XAUUSD, GBPJPY, GBPUSD, EURCAD) | report/CENSIMENTO_CONTRATTI_v2.md §4c | U30USD 38 pos DD 3,9% [T]; EURAUD 216 pos DD 17,1% [B] 3/7 anni negativi; XAUUSD DD 29,7% @1% [B]; altri n 19-25 | MISTA |
| 62 | `ABTG_FiboH4_Multi` | FIBO | 'Fibo H4' multi-simbolo (H4) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A35; backtest_pipeline/REGISTRO_TEST.md §2-bis | '0/8' e' UN numero contato 8 volte (pin InpSymbols vuoto): IS -384..-394, OOS +116..+118 (profit); BACO/NON GIRATA | NON MISURATO |
| 63 | `ABTG_FiboH4_Corso` | FIBO | fedele al corso (3 trascrizioni, banda 1,78-1,88) | mql5/Experts (sorgente); nessun round in registro | nessuna misura nel repo (0 menzioni nei report) | NON MISURATO |
| 64 | `standalone/ABTG_FiboH4.mq5 · standalone/ABTG_FiboH4_Multi.mq5` | FIBO | copie tutto-in-uno (FiboH4 esiste SOLO in standalone) | mql5/Experts/standalone | come FiboH4_Multi: nessuna misura valida | NON MISURATO |
| 65 | `ABTG_BreakoutCorso` | CORSO-JPY | Williams %R 140 + SuperTrend M15 cross JPY | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A102 | R12: 48/48 OOS negative; R45 0/48; censimento OOS 7/7 sotto 1 (max 0,98) [tipo non dich.] | SOTTO |
| 66 | `BREAKOUT_EA_JPY · BREAKOUT_EA_JPY_Multi` | CORSO-JPY | esterni v2.3 (famiglia scartata pre-progetto); BREAKOUT_EA_JPY_v3 senza sorgente | report/CENSIMENTO_CONTRATTI_v2.md §4d | 7 cross JPY 2022-24: -20.853 EUR, PF 0,67-0,95 su tutte, DD 30-48% [B?] | SOTTO |

### G5 - SUPERTREND / GOLDENCROSS / ORO (sedie 970xxx, 770331-33, 770901...)

| # | EA (file) | famiglia | ruolo | sorgente principale | stato noto (1 riga con numero) | classe provvisoria |
|---:|---|---|---|---|---|---|
| 67 | `ABTG_SupertrendReversal` | SUPREV | sedie 770901 oro H4 · 770922 XAG · 770923 DAX H4 · 770924 Nikkei H4 · NAS H1 nativa | backtest_pipeline/CLASSIFICA_PF.md; report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A13-A18; report/RIESAME_MORTI_TREND_REVERSAL_2026-09-22.md | nativo oro H4 ~2,74 bt; Nikkei IS ~2 ma profitto ~50 EUR, DD 0,14%, n 21 senza OOS; DAX M5 S2 0% combo, DD 30-37%; censimento OOS n>=100: 3 righe tutte sotto 1 (max 0,84) | MISTA |
| 68 | `ABTG_SupertrendReversal_Ottimizzato` | SUPREV | sedia 970901 XAUUSD H4 | backtest_pipeline/CLASSIFICA_PF.md #3; report/CENSIMENTO_CONTRATTI_v2.md §4b | PF bt 2,74 [T] finestra piena, DD 9,02% @1% [B] 22 anni; CONFLITTO: censimento OOS n>=100 = 0,92-0,99 -> da riconciliare | MISTA (conflitto aperto) |
| 69 | `ABTG_SupertrendReversal_Multi` | SUPREV | nativo oro H4 (770xxx) | backtest_pipeline/CLASSIFICA_PF.md; report/CENSIMENTO_PF_MISURATI_2026-09-09.md | censimento OOS n>=100: 0,77-0,81 [tipo non dich.] contro ~3,17 'base' dell'Ottimizzata | SOTTO |
| 70 | `ABTG_SupertrendReversal_Multi_Ottimizzato` | SUPREV | sedia 971001 XAUUSD H4 ('TOP' PF bt 3,17) | backtest_pipeline/CLASSIFICA_PF.md #1; report/CENSIMENTO_PF_MISURATI_2026-09-09.md | PF bt 3,17; censimento: 3 righe OOS n>=100 tutte sopra 1 (1,14-1,71) [tipo non dich.]; cella R3 OOS 1,71 su 105, DD 5,8% | SOPRA |
| 71 | `ABTG_SupRev_DAX_H4_Ottimizzato` | SUPREV | sedia 970912 D30EUR H4 | backtest_pipeline/CLASSIFICA_PF.md #5; report/CENSIMENTO_CONTRATTI_v2.md §4b | PF bt 1,96, DD 5,74%, 86 deal [T] FINESTRA PIENA (8 passate, nessuno split); short OOS 1,29 su 29 pos | SOPRA (senza OOS) |
| 72 | `ABTG_SupRev_NAS_H1_Ottimizzato` | SUPREV | sedia 970913 NASUSD H1 ('TOP') | backtest_pipeline/CLASSIFICA_PF.md #9; report/CENSIMENTO_CONTRATTI_v2.md §4b; report/I_MORTI_E_LO_STORICO_2026-09-23.md (R113) | PF bt 1,57, DD 1,17%, 155 deal [T] finestra piena (8 passate); R113 prova di regime ~4/3/1/2 pos = non conclusiva | SOPRA (senza OOS) |
| 73 | `ABTG_SupRev_DOW_H1_Ottimizzato` | SUPREV | 970916 U30USD H1 (scartata/osservazione) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A21 | IS 1,20 su 273, DD 9,8-10,0% @1%: NO PER RISCHIO | SOPRA (rischio rosso) |
| 74 | `ABTG_SupRev_DOW_H4_Ottimizzato` | SUPREV | 970914 U30USD H4 (promozione REVOCATA) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A19 | bt 2,77 [OHLC] -> PFmed reale tick 0,79 (illusione OHLC 3,51x) | SOTTO |
| 75 | `ABTG_SupRev_CAC_H4_Ottimizzato` | SUPREV | 970915 F40EUR H4 (promozione REVOCATA) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A20 | cella 1,79 [T] -> PFmed tick 0,96 (overfit) | SOTTO |
| 76 | `ABTG_SupRev_DAX_H1_Ottimizzato` | SUPREV | 970911 D30EUR H1 (SPENTA 11/08) | backtest_pipeline/risultati_archivio/REFERTO_FUORILISTA.md; report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A22 | IS -240 / OOS +1.312 su 223 n, DD 5,6%: spenta per IS rosso a campione pieno | MISTA |
| 77 | `ABTG_SupertrendInvert` | SUPREV | oro/vari H1 (osservazione) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A107 | 0-2 trade nei test: 'non opera' | NON MISURATO |
| 78 | `ABTG_GoldenCross` | GC | sedie 770331-33 USDCHF/USDCAD/NZDUSD H4 · oro H1 nativa | backtest_pipeline/CLASSIFICA_PF.md; backtest_pipeline/risultati_archivio/REFERTO_ROUND20_GOLDENCROSS_FOREX.md | oro H1 ~1,58 bt; forex R20: 0/6 celle; censimento: 11 righe OOS tutte n<100 | MISTA |
| 79 | `ABTG_GoldenCross_Ottimizzato` | GC | sedia 970301 XAUUSD H1 | backtest_pipeline/CLASSIFICA_PF.md #8 | PF bt 1,58 [T] finestra piena; 10 righe OOS n<100 | SOPRA (senza OOS) |
| 80 | `ABTG_GoldenCross_V1` | GC | versione storica V1 (NZDUSD/USDCAD/USDCHF/XAUUSD) | report/CENSIMENTO_PF_MISURATI_2026-09-09.md | 4 righe OOS n<100 | NON MISURATO (campione) |
| 81 | `standalone/ABTG_GoldenCross.mq5 · SupertrendReversal.mq5 · SupertrendReversal_Multi.mq5 · SupertrendInvert.mq5` | GC/SUPREV | copie tutto-in-uno | mql5/Experts/standalone | ereditano gli EA omonimi | EREDITA |
| 82 | `Gold_Ichimoku_TK_ATR_EA` | ORO-EXT | esterno; sedia FANTASMA 250604 (rimossa giugno) | report/CENSIMENTO_CONTRATTI_v2.md §4e | 'TK long/short' zero volte in 1.281 righe di statement; fuori campo | NON MISURATO |
| 83 | `Gold_Scalper_TK_BB_BE_EA` | ORO-EXT | esterno oro M5 (scalper manuale meccanizzato) | mql5/Experts (sorgente) | nessuna riga PF in archivio | NON MISURATO |
| 84 | `IchiCross_Gold_722 · IchiTrend_Gold_Base` | ORO-EXT | esterni oro (Ichimoku + Bollinger; README_IchiTrend_Gold.md) | mql5/Experts/README_IchiTrend_Gold.md | nessuna riga PF in archivio (EA 'base' per demo) | NON MISURATO |
| 85 | `ORB_GOLD_FIBONACCI_EA · ORB_GOLD_FIBONACCI_EA_v3.21 · GoldBreakout_Levels` | ORO-EXT | esterni oro (ORB Fibonacci; breakout livelli H1) | mql5/Experts (sorgenti) | nessuna riga PF in archivio | NON MISURATO |

### G6 - CACCE WEB e MAI MISURATI

| # | EA (file) | famiglia | ruolo | sorgente principale | stato noto (1 riga con numero) | classe provvisoria |
|---:|---|---|---|---|---|---|
| 86 | `ABTG_CRT_TurtleSoup` | CAC-B | caccia web (Neo Malesa, MIT) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A42/A43 | NASUSD M15 tick: 0/30 celle PF>=1, OOS 0,43-0,73; gate ADX 0,459 vs 0,462 non salva; chiuso 31/08 | SOTTO |
| 87 | `ABTG_IBRetest` | CAC-B | caccia web (IB Completed) magic 772900 | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A100; backtest_pipeline/REGISTRO_TEST.md 'IBRetest' | M30 tick: IS 0,38/0,56/1,21; OOS 0,70/0,59/0,96; famiglia IS 0,74 n 135: scartato dal cancello C0 (09/09) | SOTTO |
| 88 | `ABTG_LVNArbitro` | CAC-B | caccia web (TradingView j35ygZIm) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A99 | U30USD M30 tick: IS 0,979 / OOS 1,051 su 618, DD 18,0-19,4% / 11,3-11,8%: NO PER RISCHIO | SOPRA (rischio rosso) |
| 89 | `ABTG_OpeningReversalB` | CAC-B | caccia web (MPL 2.0) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A98 | U30USD M5: IS n=2 (PF 1,83 = rumore), OOS 0; 0,0078 op/g (128x sotto pavimento) | NON MISURATO |
| 90 | `ABTG_OutOfNoise` | CAC-B | porting Zarattini-Aziz-Barbon | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A109 | n=0 su 3 celle: EA ROTTO (CopyRates conta barre di calendario): non bocciato, non misurato | NON MISURATO |
| 91 | `ABTG_NySessionRetest` | CAC-B | caccia web (NY Trend Retest) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A46/A47 | U30USD M15: slope 75 OOS 1,37-1,43 su 114-115 (DD 3,7-4,7%); slope 60 n 160 OOS 1,14-1,20 sotto barra 1,30 | SOPRA (sospeso n<150) |
| 92 | `ABTG_DaxReEntry` | CAC-B | caccia web (sweep+reclaim range mattutino) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A48/A49 | D30EUR M5: long OOS 1,69-1,80 (n 57-92; 6/6 celle verdi, DD 2,5-2,9%); short 0,38-0,54 | MISTA (long SOPRA sospeso; short SOTTO) |
| 93 | `ABTG_DaxValueArea` | CAC-B | market profile / value area (DAX V5) | report/I_QUATTRO_INVISIBILI_2026-09-12.md; report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A105 | 12/09: NON ANCORA MISURATO (R141e 5 celle in coda); 09/09: 'morto su due gambe': stato R141 da verificare in archivio | NON MISURATO |
| 94 | `ABTG_HVAncora` | CAC-B | ancora di volatilita' (08/09) | report/I_QUATTRO_INVISIBILI_2026-09-12.md | NON ANCORA MISURATO (R141d; attesa originale con difetto aritmetico InpMaxSpreadPctOfStop=2,5) | NON MISURATO |
| 95 | `ABTG_AtrExhaustVol` | CAC-B | esaurimento ATR + picco di volume | report/I_QUATTRO_INVISIBILI_2026-09-12.md; report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A59-A64 | 6 celle D30EUR/U30USD/NASUSD: OOS 0,83-0,99 su n 655-927, DD 44-68%, peggior giornata fino a -9,72% | SOTTO |
| 96 | `ABTG_IntradayMomentum` | CAC-B | momentum intraday (Gao): 1a mezz'ora -> ultima | report/I_QUATTRO_INVISIBILI_2026-09-12.md; report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A77 | CONFLITTO fra fonti: 09/09 'OOS 0/6 celle, COSTO C3 -0,31 pt/op' vs 12/09 'NON ANCORA MISURATO (R141a/b)' | NON MISURATO (conflitto da chiudere) |
| 97 | `ABTG_LiquiditySweep` | CAC-B | sweep+reclaim (JPY, R95) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A83 | EURJPY OHLC M1: 0/30 passate, PF 0,65-0,80 (21.354 livelli) | SOTTO |
| 98 | `ABTG_FvgRetest` | CAC-B | fair value gap retest (magic 775501) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A119; report/CONTRADDIZIONI_CHIUSE_2026-09-09.md C1 | il 'DD 42,9%' e' RITIRATO (nessuna traccia): NON ANCORA MISURATO | NON MISURATO |
| 99 | `ABTG_ImpulsoApertura` | CAC-B | impulso d'apertura | mql5/Experts (sorgente) | nessuna misura nel repo (3 menzioni nei report, nessuna riga PF) | NON MISURATO |
| 100 | `ABTG_VolExpBreak` | CAC-B | breakout da espansione di volatilita' | mql5/Experts (sorgente) | nessuna riga nei registri (0 su REGISTRO_TEST) | NON MISURATO |
| 101 | `ABTG_CanaleLento` | CAC-B | canale di Donchian su barre chiuse (oro) | report/CENSIMENTO_PF_MISURATI_2026-09-09.md | 1 riga (XAUUSD) con n<100 | NON MISURATO |
| 102 | `ABTG_Cycle` | CAC-B | ciclo (porting) | mql5/Experts (sorgente) | nessuna misura nel repo | NON MISURATO |
| 103 | `ABTG_VwapRevert` | CAC-A | mean reversion VWAP (D30EUR M15) | backtest_pipeline/REGISTRO_TEST.md 'VwapRevert'; report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A52 | FALSIFICATO 03/09: cancello S0 negativo 4/4 (perde in media piu' dello spread); OOS n 107 | SOTTO |
| 104 | `ABTG_MeanRevert` | CAC-A | fade dell'estremo di N barre | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A78; report/CENSIMENTO_PF_MISURATI_2026-09-09.md | R60: 12/12 celle bocciate; OOS 0,85 su n>=100 (GBPUSD) | SOTTO |
| 105 | `ABTG_TurnaroundTuesday` | CAC-A | stagionale martedi' | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A110 | R63: 0/24 celle OOS (11.928 op); censimento OOS 0,78 (GBPUSD) | SOTTO |
| 106 | `ABTG_InvEsaurimento` | CAC-A | inversione da esaurimento (contratto firmato 30/08) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A71/A72 | E3 PF 1,16 totale ma -5.604 nel toro pulito 2017; E1 0,95 su 68 | MISTA (verdetto per regime: perde nel toro) |
| 107 | `standalone/ABTG_PointBreak.mq5` | CAC-A | Point Break (Bertacchi/ABTG), SOLO in standalone | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A103 | R60: 12/12 bocciate [finestra unica] | SOTTO |
| 108 | `standalone/ABTG_SuperFilter.mq5` | CAC-A | SuperFilter (parte meccanica), SOLO in standalone | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A104 | filtro appiccicato, 0 successi su 5 in casa; mai misurato in proprio | NON MISURATO |
| 109 | `ABTG_CrossEma` | CAC-C | incrocio EMA 9/21 su barra chiusa (richiesta 19/08) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A79; report/CENSIMENTO_PF_MISURATI_2026-09-09.md | CONFLITTO: 'EDGE/PF' citato in blocco (R86) vs censimento 8 righe OOS, 4/6 sopra 1 (max 1,18, D30EUR/oro) | NON MISURATO (conflitto da chiudere) |
| 110 | `ABTG_CrossEmaApertura` | CAC-C | medie di sessione ancorate all'apertura USA (R96) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A73-A75 | Dow IS 0,96 / OOS 0,92 DD 35,5%; Nasdaq 0,99/0,99 DD 35,4% [T] | SOTTO |
| 111 | `ABTG_ChaosLyapunov` | CAC-C | EMA-cross gated da Lyapunov (CB 76446) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A44/A45 | NASUSD_EXT M15 [B] 105 celle: 1/105 in fascia; gate largo IS 1,25-1,33; bocciato 31/08 | SOTTO |
| 112 | `ABTG_AltaVelocita` | CAC-C | metodo Manuela Negro v2 | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A66; report/CENSIMENTO_PF_MISURATI_2026-09-09.md | GBPUSD: 8/8 celle negative, OOS 0,54-0,82, DD fino a 37%; censimento 18/18 sotto 1 | SOTTO |
| 113 | `ABTG_HARSI` | CAC-C | Heikin Ashi RSI (EURUSD M5, sedia 'scan da fare') | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A118 | nessuna misura in archivio | NON MISURATO |
| 114 | `HARSI_Assistant` | CAC-C | trade-assistant HARSI a 4 TF (mostra, opzionalmente trada) | mql5/Experts (sorgente) | nessuna misura in archivio | NON MISURATO |
| 115 | `ABTG_Relativo` | CAC-C | convergenza z-score fra due simboli (APRE ORDINI) | report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md A57/A58 | R117: D30EUR OOS 0,452 DD 25,0% (SOTTO); NASUSD OOS 1,189 su 154 DD 8,4% (sospeso) | MISTA |
| 116 | `ABTG_ScalperDirezionale` | CAC-C | scalper a cicli brevi col verso deciso da Claudio (25/09, v1.07) | mql5/Experts (sorgente) | nessuna misura nel repo | NON MISURATO |

**Conteggio provvisorio delle righe** (non degli EA: una riga = una voce dell'elenco; le 9 righe EREDITA sono copie/pin): SOPRA **16** · SOTTO **28** ·
MISTA (celle da entrambe le parti) **19** · NON MISURATO **44**.
Questo conteggio **non e' un risultato**: e' il punto di partenza che gli agenti devono verificare cella per cella. Le righe NON MISURATO sono **messe in chiaro**, non nascoste (richiesta di Claudio).


---

## 5. LA REGOLA UNICA DI CLASSIFICAZIONE "PF SOPRA 1 / SOTTO 1 / NON MISURATO" (PROPOSTA - da firmare)

> Obiettivo: che un EA con *PF 1,40 su 193 posizioni a tick reali* e uno con *PF 2,16 su 14 posizioni* e uno con *PF 1,10 a barre su 22 anni* **non finiscano nella stessa colonna senza dirlo**.

### 5.1 L'unita' di classificazione e' la CELLA
**Cella = EA x simbolo x TF x lato x configurazione di contratto.** Un EA e' "sopra 1" **se ha almeno una cella SOPRA** e "sotto 1" **se ha almeno una cella SOTTO**: puo' stare in tutte e due le liste, ciascuna con le sue celle (es. `ABTG_DAX_Apertura_EU`: long SOPRA, short SOTTO). Mai una media fra celle.

### 5.2 Quale PF si usa (ordine di preferenza, si scrive SEMPRE quale)
1. **PF OOS a tick reali `[T]`** della cella di contratto, con n in **posizioni** (non deal), deposito e rischio dichiarati. E' il numero che classifica.
2. Se non esiste un OOS: **PF a tick su finestra piena** -> si classifica ma con l'etichetta **"(senza OOS)"** (non conta come prova).
3. Se esiste solo **barre `[B]` / esterne `[E]` / tick generati `[G]`**: si classifica come **SCREENING** e si scrive il tipo. Il PF a barre **non promuove e non boccia** (fattore OHLC->tick misurato 1,72-3,51x in eccesso: `REGISTRO_TEST.md` sez. 0): serve a vedere la forma, non a fissare un PF. Mai mescolato nella stessa colonna di un `[T]`.
4. **Il forward su demo NON classifica**: sta in una colonna a parte ("forward demo, solo demo, n accanto, campione sottile").
5. **Le dichiarazioni di vendor/video/slide non entrano** (al massimo aprono un parametro).
6. In caso di **due misure discordanti sulla stessa cella** (es. Nasdaq 770260: 1,14/1,11 contro 1,22/1,22; SuperWave 770511: 143 contro 131 deal) la cella e' **CONTESA**: si riportano **entrambe** e la classe e' NON MISURATO finche' non si riconcilia.

### 5.3 Le tre classi
| classe | condizione | nota |
|---|---|---|
| **SOPRA 1** | esiste un PF di rif. (5.2) **>= 1,00** con n >= 1 operazione misurata | la **soglia e' sul punto stima**, ma si accompagna SEMPRE al livello di affidabilita' (5.4) e al verdetto di casa (5.5): "sopra 1" **non vuol dire "buono"** |
| **SOTTO 1** | PF di rif. **< 1,00** | idem; per scrivere **MORTO** serve il certificato (5.6), altrimenti e' "sotto 1, non ancora morto" |
| **NON MISURATO** | **nessun** PF di rif.: mai girato, `Trades=0`, EA rotto, solo screening senza OOS e senza tick, cella contesa non riconciliata, sorgente assente | **terza classe esplicita**, con la voce "cosa manca" |

### 5.4 Livello di affidabilita' (accanto a OGNI classe)
- **A**: n OOS >= 150 posizioni **e** OOS vero **e** >= 2 regimi misurati uno per uno (toro/orso/laterale/crollo).
- **B**: n OOS >= 150 ma **un solo regime** (e' il caso di quasi tutti gli indici BCM: 21 mesi, dal 26/09/2024, rialzo).
- **C**: 30 <= n < 150 (**merito sospeso**, valvola R59: il rischio si giudica comunque).
- **D**: n < 30 (**indizio, non lettura**: es. MaxMin DAX short 14 pos).
- Si scrivono sempre: **tipo di dato** (`[T]`/`[B]`/`[E]`/`[G]`), **unita' di n** (posizioni o deal; il fattore deal/posizioni misurato va da 1,00 a 2,31), **deposito e rischio%** del banco.
- **Coerenza IS-OOS**: se IS e OOS stanno da parti opposte di 1 si aggiunge **"SEGNO INVERTITO"** (regola S4: *regime, non edge*). Se il PF OOS e' sopra 1 ma il PF di **tutta la storia** e' sotto (EMA200 oro H4: OOS 1,22-1,65 contro 0,993 su 9,5 anni) si aggiunge **"NON CONFRONTABILE / REGIME"**.

### 5.5 La parola di verdetto (vocabolario di casa, solo queste)
- **Per una MISURA di effetto**: `NULLO` · `ZONA GRIGIA` · `EFFETTO` · `NON ANCORA MISURATO`. Le soglie le fissa **ogni misura PRIMA dei dati**: non si inventano qui (vedi punto dubbio D2).
- **Per un EA** (parole dei cancelli, sempre col numero accanto): `ESCLUSO PER COSTO` (stop sotto la frontiera 40x lo spread; pavimento duro 13,3x) · `FRAGILE` (la frontiera cade dentro la banda misurata) · `NO PER RISCHIO` (DD sopra il limite, a **qualunque n**) · `MERITO SOSPESO` (n<150) · `MORTO` (**solo** col certificato 5/5) · altrimenti `NON ANCORA MISURATO`.
- Mai "promosso/bocciato" come parole nude.

### 5.6 Il certificato di morte (5 caselle, regola del 09/09) - OBBLIGATORIO per ogni EA in SOTTO 1 o NON MISURATO
| casella | si compila con |
|---|---|
| (1) **PF** misurato | PF + tipo di dato + finestra |
| (2) **n e DD** | n (unita') e DD (con deposito e rischio) |
| (3) **gestione dell'uscita messa ad asse** | id dei round (es. `R199B` per `InpTP1_ClosePct`, `R264d4`) o "mancante" |
| (4) **simboli gemelli provati** | elenco per nome |
| (5) **TF cambiato** | **elenco dei TF per nome** (es. "M5 e M15"), non un si/no; dove la manopola TF non esiste nel codice: **NON APPLICABILE con le righe del sorgente citate** |

**Se manca anche una sola casella il verdetto e' `NON ANCORA MISURATO` e si scrive COSA MANCA.** "Morto" senza certificato non e' un morto: e' un'occasione persa.

### 5.7 Due precisazioni di lettura
- **"Che tipologie di mercati hanno superato"** si legge in **due modi**, e la scheda li riporta tutti e due: **(a) classi di strumento** (indici / forex / oro / argento) e simboli su cui la cella e' SOPRA; **(b) regimi** (toro / orso / laterale / crollo, con il periodo) **dichiarando se misurato**. Sugli indici BCM il regime e' **uno solo** (rialzo 2024-26): tutto il resto va scritto `NON MISURATO`, mai stimato.
- **"Che anni sono stati misurati"**: sempre le date esatte della finestra, IS e OOS separati, e il tipo di dato. Riferimento gia' pronto: tabella "anni/dati" di `report/DOSSIER_EXPERT_PER_EMILIANO_2026-10-05.md` (12 expert + 4 famiglie): i gruppi la **estendono**, non la rifanno.


---

## 6. LA SCHEDA-MODELLO (una per EA; per le famiglie con piu' celle, una per cella nella tabella finale)

Ogni campo o ha un numero con la sua fonte (file + riga) o dice `NON MISURATO`. Nessun campo si lascia vuoto.

```
EA: <nome file>            famiglia: <codice>            gruppo: <G1..G6>            ruolo: <sedia magic / candidata / spenta / morta / copia>
1. MOTORE in una frase:
2. SIMBOLI / TF su cui e' stato provato (e quale e' la cella di contratto) + SONDE / STRUMENTI COLLEGATI (sez. 2):
3. BACKTEST FATTI (uno per riga):  round | tipo di dati ([T] tick / [B] barre / [E] esterno / [G] generati) | deposito | rischio% | finestra IS | finestra OOS | file CSV/referto
4. ANNI MISURATI e REGIMI: anni esatti (data inizio-fine) | toro | orso | laterale | crollo (ognuno: MISURATO con PF e n, oppure NON MISURATO)
5. NUMERI per cella:  PF IS | PF OOS | n IS | n OOS (unita') | DD IS | DD OOS (con deposito e rischio) | peggior giornata
6. TIPOLOGIE DI MERCATO superate: (a) classi/simboli con PF>=1 in OOS   (b) regimi superati
7. FORWARD DEMO (solo demo, con n e "campione sottile"): periodo | n | PF | DD | fonte. Mai FTMO.
8. CLASSE (SOPRA/SOTTO/NON MISURATO) + affidabilita' (A/B/C/D) + dato + eventuale SEGNO INVERTITO / CONTESA
9. VERDETTO con parola di casa  +  CERTIFICATO a 5 caselle (se SOTTO o NON MISURATO)
10. MIGLIORABILE?  si / no / non so  + perche' (con il numero che lo giustifica)
11. COSA SERVE per migliorarlo (elenco, ognuno con COSTO): 
      misure mancanti: uscita ad asse | gemelli | TF | storico piu' lungo | prova di regime | costo 40x | per-trade da rilanciare
      dati da raccogliere: (es. storico esterno, tick, calendario) | firma di Claudio necessaria? (si/no)
12. COSTO IN TEMPO MACCHINA stimato per ogni misura (min/ore) e su QUALE macchina (PC di backtest; mai VPS mentre una challenge e' viva)
13. FONTI: elenco file (+riga) da cui viene ogni numero; conflitti fra fonti dichiarati
```

**Costi di riferimento gia' misurati in archivio** (per stimare il campo 12): quattro EA "invisibili" R141a-e = 5,16 minuti in tutto; R245 (6 file, 84 passate) 20-26 minuti;
R246 (12 file, 36 passate) 9-12 minuti; R247 3-6 minuti; ROUND R255 (24 job) 52 minuti; ROUND CORTI C (24 job) 51 minuti; storico esterno Dow (piano, non eseguito): 90-348 ore di calcolo.


---

## 7. IL PIANO DI FAN-OUT: 6 GRUPPI, ORDINE DI PRIORITA', FONTI

**Principio d'ordine (dalla richiesta)**: prima le **sedie vive e i candidati piu' avanzati (770xxx/771xxx)**, poi i **morti con certificato**, poi i **mai misurati**.
Quindi tre ondate: **ONDATA 1 = G1, G2, G3** (sedie 770xxx/771xxx) · **ONDATA 2 = G4, G5** (sedie 772xxx/774101/970xxx/oro e forex) · **ONDATA 3 = G6** (cacce web: dentro G6 prima i *morti con certificato*, poi i *NON MISURATI*).
Le tre ondate possono girare **in parallelo** (sono letture); l'ordine indica **quale consegna conta prima**. Modello consigliato per i lettori: **Sonnet** (lettura e sintesi); **Haiku** per i conteggi/grep meccanici; **Opus** solo per il cancello finale (`controllo-preventivo`) prima che qualsiasi numero esca verso Claudio.

### Fonti COMUNI a tutti i gruppi (leggere per prime; verificate esistenti il 05/10)
| fonte | cosa dice |
|---|---|
| `backtest_pipeline/REGISTRO_TEST.md` (4.635 righe) | registro dei round: **si cerca per nome EA E per numero di round** (R83 non usciva con `grep -i r83`: errore gia' pagato il 18/09) |
| `REGISTRO_TEST.md` (root, 206 righe) | round **21-28/09** (R255, R264-R267, ROUND CORTI C/C2): **piu' recenti del censimento 09/09** |
| `report/CENSIMENTO_PF_MISURATI_2026-09-09.md` + `backtest_pipeline/risultati_archivio/CENSIMENTO_PF_TUTTI_2026-09-09.csv` | 1.558 celle (430 con OOS): **screening**, tipo di dato non dichiarato, n in deal; il CSV e' per `motore`/`simbolo`/`tf` |
| `report/CENSIMENTO_CONTRATTI_v2.md` · `report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` · `report/CENSIMENTO_CAMPO_VS_MISURATO_2026-09-13.md` | DD e frequenza promessi, n in posizioni, codice in campo vs repo (usare le sole parti backtest) |
| `report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md` (tabella A, 119 righe) | tutti gli scartati NOSTRI con PF/n/DD/cancello |
| `report/CENSIMENTO_USCITE_MAI_PROVATE_2026-09-11.md` · `report/CENSIMENTO_CASELLE_VUOTE_2026-09-22.md` · `report/CENSIMENTO_LATO_SHORT_2026-09-09.md` | caselle del certificato (uscita / TF / gemelli / lato) ancora vuote |
| `report/DOSSIER_EXPERT_PER_EMILIANO_2026-10-05.md` | tabella anni/dati gia' fatta (12 expert + 4 famiglie): **base da estendere** |
| `report/LO_STORICO_ESTERNO_MAPPA_2026-09-23.md` · `report/LE_QUATTRO_EPOCHE_GIA_MISURATE_2026-09-23.md` · `report/I_MORTI_E_LO_STORICO_2026-09-23.md` | che storico esiste (nativo/esterno) e le 4 finestre di regime |
| `FLOTTA_ATTIVA.md` · `HANDOFF.md` (2.182 righe, grep per nome) · `PAGELLA_EA_2026-08-01.md` · `backtest_pipeline/CLASSIFICA_PF.md` · `backtest_pipeline/risultati_archivio/CLASSIFICHE.md` | forward demo (solo demo), pagelle, classifiche PF bt a tick 26/07 |
| `docs/MAPPA_MOTORI_EA.md` · `docs/gemini/BASE_CONOSCENZA_PER_GEMINI_2026-10-04.md` (sez. 2-3) | motore di ogni EA; vocabolario dei verdetti; regole firmate |
| `report/PIANO_PROP.md` · `report/METRO_PROP.md` · `report/ROBUSTEZZA.md` | criteri e cancelli (150 operazioni, costo 40x, DD, regime) |
| `backtest_pipeline/risultati_archivio/REFERTO_*.md` (137) · `risultati_prove/<EA>/` · `backtest_pipeline/prove/` (1.203 file) | i numeri **primari**: il censimento e i referti sono secondari, **comanda il CSV** |

**Regole di lavoro per tutti i gruppi**: (i) sola lettura, nessun round lanciato (i "cosa serve" si **scrivono**, non si fanno); (ii) ogni numero con file+riga o `NON MISURATO`;
(iii) il **CSV batte il referto**, il referto batte la prosa; se due fonti dello stesso rango divergono la cella e' CONTESA con entrambe le voci; (iv) niente FTMO, niente trial: forward = solo demo;
(v) niente emoji nei `.ps1` (non se ne scrivono), (vi) output = un file per gruppo `report/RESOCONTO_EA_SCHEDE_G<k>_AAAA-MM-GG.md` con in testa la **tabella di sintesi** (una riga per cella) e sotto le schede;
(vii) commit per path + push su `lavoro` a ogni consegna; (viii) prima di consegnare: contro-esempio sul proprio verdetto e passaggio dal cancello.


### GRUPPO G1 - APERTURE e LIVE5M (ONDATA 1) - 26 righe

- **Sedie / ruoli coperti**: sedie 770101/770105/770202/770260/770250 (+770201 spenta)
- **Famiglie**: AP-DAX, AP-DOW, AP-NAS, LIVE5, DAXM3
- **Output atteso**: `report/RESOCONTO_EA_SCHEDE_G1_AAAA-MM-GG.md` (tabella di sintesi per cella + una scheda per EA, sez. 6)
- **EA, in ordine di lavoro (esatti)**:
  - `ABTG_DAX_Apertura_EU` [AP-DAX]
  - `ABTG_DAX_Apertura_EU_Ottimizzato` [AP-DAX]
  - `ABTG_DAX_Apertura_EU_Pin9fca` [AP-DAX]
  - `ABTG_DAX_Apertura_EU_TrailFix` [AP-DAX]
  - `trailfix_9fca63d9/CLAU12_DAX_Apertura_EU.mq5` [AP-DAX]
  - `standalone/ABTG_DAX_Apertura_EU.mq5` [AP-DAX]
  - `ABTG_Apertura_Marco` [AP-DAX]
  - `ABTG_Apertura_3Ingressi` [AP-DAX/NAS]
  - `DAX_MASTER_PROP` [AP-DAX]
  - `ABTG_Dow_Apertura_US` [AP-DOW]
  - `ABTG_Dow_Apertura_US_Pin9fca` [AP-DOW]
  - `ABTG_Dow_Apertura_US_TrailFix` [AP-DOW]
  - `trailfix_9fca63d9/CLAU12_Dow_Apertura_US.mq5` [AP-DOW]
  - `ABTG_Nasdaq_Apertura_US` [AP-NAS]
  - `ABTG_Nasdaq_Apertura_US_Ottimizzato` [AP-NAS]
  - `ABTG_Nasdaq_Apertura_US_Pin9fca` [AP-NAS]
  - `ABTG_Nasdaq_Apertura_US_TrailFix` [AP-NAS]
  - `trailfix_9fca63d9/CLAU12_Nasdaq_Apertura_US.mq5` [AP-NAS]
  - `esterni/Nasdaq_PreOpen_Breakout_EA.mq5 (+ NasdaqOpeningBreakout_EA_v21_OPTIMIZED.ex5)` [AP-NAS]
  - `ABTG_Nasdaq_Apertura_US (standalone)` [AP-NAS]
  - `ABTG_DAX_Live5m` [LIVE5]
  - `ABTG_DAX_Live5m_v2` [LIVE5]
  - `ABTG_Nasdaq_Live5m` [LIVE5]
  - `ABTG_DAX_M3` [DAXM3]
  - `DAX_M3_Supertrend` [DAXM3]
  - `standalone/ABTG_DAX_M3.mq5 · standalone/ABTG_DAX_Live5m.mq5 · standalone/ABTG_Nasdaq_Live5m.mq5` [LIVE5/DAXM3]
- **Fonti specifiche** (oltre alle comuni):
  - report/APERTURE_DAX_MAPPA_2026-10-03.md
  - report/APERTURE_DOW_MAPPA_2026-10-03.md
  - report/APERTURE_NASDAQ_MAPPA_2026-10-03.md
  - report/PARAMETRI_DAX_APERTURA_2026-10-01.md
  - report/INDURIMENTO_PROP_DUE_SEDIE_2026-09-12.md
  - report/LA_SECONDA_SEDIA_2026-09-12.md
  - report/SEDIA_SHORT_DAX_FTMO_2026-09-25.md
  - report/SEDIA_SHORT_DOW_FTMO_2026-09-26.md
  - report/IL_MERITO_E_D_INVERNO_2026-09-25.md
  - report/ROSA_OTTOBRE_2026-09-18.md
  - report/STOP_VS_SPREAD_FTMO_2026-09-20.md
  - report/I_LATI_MANCANTI_2026-09-23.md
  - report/ORB_NASDAQ_PERCHE_E_SPENTO_2026-09-23.md
  - report/RIESAME_MORTI_APERTURE_2026-09-22.md
  - report/RIESAME_MORTI_BREAKOUT_M5_2026-09-22.md
  - report/CENSIMENTO_CONTRATTI_v2.md §2-§4
  - STUDIO_MOVIMENTO_APERTURE.md · CACCIA_MOTORE_APERTURE.md · PROMEMORIA_APERTURE.md (root)
  - mql5/Experts/trailfix_9fca63d9/LEGGIMI.md (varianti Pin/TrailFix/CLAU12)
  - backtest_pipeline/REGISTRO_TEST.md sez. 1-2 (aperture, live5m), R83/R84, R107, R255
  - risultati_prove/{aperture_r35,aperture_r42,aperture_r43,aperture_r46,aperture_r47,ABTG_DAX_Apertura_EU,ABTG_Dow_Apertura_US,ABTG_Nasdaq_Apertura_US,ABTG_DAX_Live5m,ABTG_DAX_Live5m_v2,ABTG_Nasdaq_Live5m,R196A,R197A,R197B,R198,R199A,R199B,R200*,R201A,R202*}
  - backtest_pipeline/risultati_archivio/ROUND_R255_SHORT_DOW_INFASE_2026-09-28/
- **Cosa guardare per primo**: Punto critico: **orologio** (server UTC+1 fisso: i contratti mescolano due tempistiche) e **un solo regime** (21 mesi dal 26/09/2024). Riconciliare Nasdaq 770260 (1,14/1,11 vs 1,22/1,22). Il TF del grafico e' inerte per costruzione (range letto su M1): i veri assi sono altri 4 input.

### GRUPPO G2 - EMA200, SUPERWAVE, ORB (ONDATA 1) - 14 righe

- **Sedie / ruoli coperti**: sedie 771531 (EMA200 Dow H1), 770511/770512/770531 (SuperWave), 770611 (ORB Dow), 971501 (EMA200 oro)
- **Famiglie**: EMA200, SW, ORB
- **Output atteso**: `report/RESOCONTO_EA_SCHEDE_G2_AAAA-MM-GG.md` (tabella di sintesi per cella + una scheda per EA, sez. 6)
- **EA, in ordine di lavoro (esatti)**:
  - `ABTG_EMA200` [EMA200]
  - `ABTG_EMA200_Ottimizzato` [EMA200]
  - `ABTG_EMA200_Multi_BANCO` [EMA200]
  - `standalone/ABTG_EMA200.mq5` [EMA200]
  - `ABTG_SuperWave` [SW]
  - `ABTG_SuperWave_DOW_H1_Ottimizzato` [SW]
  - `ABTG_SuperWave_DAX_H4_Ottimizzato` [SW]
  - `ABTG_SuperWave_EA` [SW]
  - `ABTG_ORB` [ORB]
  - `ABTG_ORB_Ottimizzato` [ORB]
  - `ABTG_ORB_Fibo` [ORB]
  - `ABTG_Londra_ORB` [ORB]
  - `ORB_OpeningRange` [ORB]
  - `ORB_DAX_BASE_EA · ORB_DAX_PM_EA` [ORB]
- **Fonti specifiche** (oltre alle comuni):
  - report/EMA200_GEMELLI_STATO_2026-10-03.md
  - report/EMA200_H4_D1_FOREX28_MISURA_2026-10-03.md
  - report/EMA200_RIMBALZO_MISURA_2026-10-01.md
  - report/EMA200_RIMBALZO_STATO_DELLARTE_2026-09-30.md
  - report/EMA200_D1_SU_M5_MISURA_2026-10-02.md
  - report/EMA200_DOW_COSA_MANCA_PER_IL_1_OTTOBRE_2026-09-17.md
  - report/DECISIONE_EMA200_RESTA_SUL_DEMO_2026-09-18.md
  - report/PACCHETTO_SCHIERAMENTO_EMA200_2026-09-13.md
  - report/I_BOCCIATI_HANNO_UN_CERTIFICATO_2026-09-12.md
  - report/LETTURA_ROUND_CORTI_C_2026-09-28.md · report/LETTURA_ROUND_CORTI_C2_2026-09-28.md
  - report/EA_EMA200_OMBRA_2026-10-05.md · report/OMBRA_SUPERWAVE_SPEC_2026-10-05.md (solo lettura, file di altro agente)
  - report/CORSIA_DEMO_SUPERWAVE_DAX_2026-09-08.md · report/RIPESCAGGIO_FREQUENZA_2026-09-08.md · report/IL_WIP_E_DIAGNOSTICA_2026-09-12.md · report/LA_BANDA_BASSA_2026-09-12.md
  - report/H4_M3_CONFLUENZA_MISURA_2026-10-01.md
  - report/CENSIMENTO_ORB_2026-09-29.md · report/AUDIT_VIRGOLA_CSV_2026-09-28.md · docs/PER_GEMINI_ORB_2026-09-29.md
  - backtest_pipeline/REGISTRO_TEST.md: sez. 'ORB' (r.802), 'SuperWave' (r.727), 'EMA200' (r.2478), R264-R267 (r.4328-4590)
  - backtest_pipeline/prove/R110_CSV_EMADOW · backtest_pipeline/risultati_prove/{ABTG_EMA200,ABTG_EMA200_Ottimizzato,ABTG_SuperWave*,ABTG_ORB*,risultati_scan_ABTG_EMA200_H1,risultati_valid_ABTG_EMA200_H1_realtick,regime_r50,regime_r57,regime_r59}
- **Cosa guardare per primo**: Punto critico: EMA200 Dow H1 e' la cella piu' avanzata ma **IS in posizioni non ricontabile dal repo** (132 dichiarato) e **un solo regime**; la gemella oro H4 e' NO PER RISCHIO con certificato completo; SuperWave Dow ha il **contratto conteso** (143/131 deal). ORB Dow: slippage 1,5 pt porta il DD oltre il 10%.

### GRUPPO G3 - NOTTE, EVENTI, TREND-EMA, BULGE, LONDRA (ONDATA 1) - 14 righe

- **Sedie / ruoli coperti**: sedie 770411 (MaxMin DAX short), 770402 (oro), 771321-23/771332 (PTE), 771201-03 (PostNews), Bulge
- **Famiglie**: NOTTE, PTE-WOL, POSTNEWS, BULGE, LONDRA
- **Output atteso**: `report/RESOCONTO_EA_SCHEDE_G3_AAAA-MM-GG.md` (tabella di sintesi per cella + una scheda per EA, sez. 6)
- **EA, in ordine di lavoro (esatti)**:
  - `ABTG_MaxMinNotte` [NOTTE]
  - `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` [NOTTE]
  - `ABTG_MaxMinNotte_DAX_Short_Ottimizzato_MFE` [NOTTE]
  - `ABTG_BreakinBox` [NOTTE]
  - `ABTG_Nightly` [NOTTE]
  - `ABTG_Nightly_Ottimizzato` [NOTTE]
  - `ABTG_PTE` [PTE-WOL]
  - `ABTG_PTE_Ottimizzato` [PTE-WOL]
  - `ABTG_WOL` [PTE-WOL]
  - `ABTG_PostNews` [POSTNEWS]
  - `ABTG_Bulge` [BULGE]
  - `BULGE_MASTER` [BULGE]
  - `ABTG_LondonFx` [LONDRA]
  - `ABTG_AllineaLondra` [LONDRA]
- **Fonti specifiche** (oltre alle comuni):
  - report/STATO_MAXMIN_DAX_LONG_E_ORO_2026-09-26.md
  - report/REFERTO_R242_2026-09-24.md · report/REFERTO_R244_2026-09-24.md
  - report/SEDIA_ORO_LONG_FTMO_BOZZA_2026-09-27.md
  - report/RIESAME_MORTI_NOTTURNI_2026-09-22.md
  - report/NIGHTLY_SEI_SIMBOLI_2026-09-26.md · backtest_pipeline/caccia_strategie/ANALISI_NIGHTLY_PDF_2026-08-23.md
  - report/POSTNEWS_TRE_SEDIE_2026-10-02.md · report/PACCHETTO_POSTNEWS_TRE_GRAFICI_2026-09-19.md · report/CONTRATTO_POSTNEWS_ECB_771201_2026-09-10.md
  - report/BULGE_COME_MIGLIORARLO_2026-10-03.md · docs/Analisi_EA_BULGE.md · report/R92B_DIAGNOSI_CRITERI.md
  - backtest_pipeline/caccia_strategie/ANALISI_PDF_LONDRA_2026-09-26.md · CACCIA_LONDRA_MECCANISMI/ALTERNATIVA
  - backtest_pipeline/risultati_archivio/REFERTO_ROUND17_ORO_NOTTE.md · REFERTO_ROUND80_REGIME_PTE.md · R100_REFERTO.md · R103_REFERTO_FINALE.md
  - backtest_pipeline/caccia_strategie/CACCIA_2026-08-16_L_PTE_EMA200.md
  - backtest_pipeline/REGISTRO_TEST.md: 'MaxMinNotte' (r.633), 'POST NEWS' (r.164, r.1508), 'LONDONFX/R116' (r.1156-1301), R81 (r.3901), R187 (r.3832), R260-R263 (r.4219-4268), R268-R269 (r.4590)
  - backtest_pipeline/risultati_prove/{ABTG_MaxMinNotte,ABTG_MaxMinNotte_DAX_Short_Ottimizzato,MaxMin_Oro_r17,MaxMin_Oro_r19,MaxMin_Oro_fase2_vecchioscript,ABTG_Nightly,ABTG_PTE,ABTG_WOL,ABTG_PostNews}
- **Cosa guardare per primo**: Punto critico: MaxMin DAX short = **14 posizioni** (campione che non decide), oro = PF 1,45 a tick (toro) contro 1,10 su 22 anni a barre con 11 anni negativi; **Nightly giudicato su 21 mesi per errore** (EURCHF parte dal 1993): finestra da rifare; PostNews = **nessun PF** (Trades=0).

### GRUPPO G4 - FOREX 'famiglie di agosto' + FIBO + CORSO (ONDATA 2) - 12 righe

- **Sedie / ruoli coperti**: sedie 772161-63 (BB), 772361-63 (C2C), 772421-23 (EZ), 772231-35 (Gap), 774101, 772341-46 (Larry)
- **Famiglie**: BB, C2C, EZ, GAP, LARRY, FIBO, CORSO-JPY
- **Output atteso**: `report/RESOCONTO_EA_SCHEDE_G4_AAAA-MM-GG.md` (tabella di sintesi per cella + una scheda per EA, sez. 6)
- **EA, in ordine di lavoro (esatti)**:
  - `ABTG_BreakingBand` [BB]
  - `ABTG_CostToCost` [C2C]
  - `ABTG_EasyTrend` [EZ]
  - `EasyTrend_EURUSD` [EZ]
  - `ABTG_GapFill` [GAP]
  - `ABTG_GapContinuation` [GAP]
  - `ABTG_PunteLarry` [LARRY]
  - `ABTG_FiboH4_Multi` [FIBO]
  - `ABTG_FiboH4_Corso` [FIBO]
  - `standalone/ABTG_FiboH4.mq5 · standalone/ABTG_FiboH4_Multi.mq5` [FIBO]
  - `ABTG_BreakoutCorso` [CORSO-JPY]
  - `BREAKOUT_EA_JPY · BREAKOUT_EA_JPY_Multi` [CORSO-JPY]
- **Fonti specifiche** (oltre alle comuni):
  - report/CENSIMENTO_CONTRATTI_v2.md §4c-§4d
  - report/LE_QUATTRO_EPOCHE_GIA_MISURATE_2026-09-23.md
  - report/PERCHE_ENTRANO_POCO_2026-09-11.md · report/CENSIMENTO_FREQUENZA_FLOTTA_2026-08-22.md
  - report/LA_BANDA_BASSA_2026-09-12.md
  - report/I_MORTI_E_LO_STORICO_2026-09-23.md
  - report/PERCHE_NON_PASSANO_2026-09-09.md (promozione 774101: R65/R66)
  - backtest_pipeline/risultati_archivio/R100_REFERTO.md · R103_REFERTO_FINALE.md · R103_REFERTO_DRIVER_FOREX_METALLI_20260824_1922.txt
  - backtest_pipeline/caccia_strategie/ANALISI_CORSO_BREAKOUT/EASYTREND/FIBOH4_MEDIA200/MEDIAZIONE_2026-08-18.md
  - backtest_pipeline/REGISTRO_TEST.md: 'FIBO H4' (r.138-163), R108/R111 (BreakingBand), R12/R45 (Corso)
  - backtest_pipeline/risultati_prove/{ABTG_BreakingBand,ABTG_CostToCost,ABTG_EasyTrend,ABTG_GapFill,ABTG_PunteLarry,ABTG_FiboH4_Multi,trades_bb,trades_cost,trades_ez,trades_gap,trades_larry}
- **Cosa guardare per primo**: Punto critico: quasi tutte misurate a **barre su 6,5-27 anni** (screening, mai a tick: i tick forex BCM partono da 07/2024) con finestra piena; il WF a tick ha n 8-26 (campione sottile). Molte sedie spente o 'nessuna operazione in forward'.

### GRUPPO G5 - SUPERTREND REVERSAL, GOLDENCROSS, ORO esterni (ONDATA 2) - 19 righe

- **Sedie / ruoli coperti**: sedie 970901/970912/970913/971001/971501, 770331-33, 770901-24, EA esterni oro
- **Famiglie**: SUPREV, GC, ORO-EXT
- **Output atteso**: `report/RESOCONTO_EA_SCHEDE_G5_AAAA-MM-GG.md` (tabella di sintesi per cella + una scheda per EA, sez. 6)
- **EA, in ordine di lavoro (esatti)**:
  - `ABTG_SupertrendReversal` [SUPREV]
  - `ABTG_SupertrendReversal_Ottimizzato` [SUPREV]
  - `ABTG_SupertrendReversal_Multi` [SUPREV]
  - `ABTG_SupertrendReversal_Multi_Ottimizzato` [SUPREV]
  - `ABTG_SupRev_DAX_H4_Ottimizzato` [SUPREV]
  - `ABTG_SupRev_NAS_H1_Ottimizzato` [SUPREV]
  - `ABTG_SupRev_DOW_H1_Ottimizzato` [SUPREV]
  - `ABTG_SupRev_DOW_H4_Ottimizzato` [SUPREV]
  - `ABTG_SupRev_CAC_H4_Ottimizzato` [SUPREV]
  - `ABTG_SupRev_DAX_H1_Ottimizzato` [SUPREV]
  - `ABTG_SupertrendInvert` [SUPREV]
  - `ABTG_GoldenCross` [GC]
  - `ABTG_GoldenCross_Ottimizzato` [GC]
  - `ABTG_GoldenCross_V1` [GC]
  - `standalone/ABTG_GoldenCross.mq5 · SupertrendReversal.mq5 · SupertrendReversal_Multi.mq5 · SupertrendInvert.mq5` [GC/SUPREV]
  - `Gold_Ichimoku_TK_ATR_EA` [ORO-EXT]
  - `Gold_Scalper_TK_BB_BE_EA` [ORO-EXT]
  - `IchiCross_Gold_722 · IchiTrend_Gold_Base` [ORO-EXT]
  - `ORB_GOLD_FIBONACCI_EA · ORB_GOLD_FIBONACCI_EA_v3.21 · GoldBreakout_Levels` [ORO-EXT]
- **Fonti specifiche** (oltre alle comuni):
  - backtest_pipeline/CLASSIFICA_PF.md · backtest_pipeline/risultati_archivio/CLASSIFICHE.md
  - report/RIESAME_MORTI_TREND_REVERSAL_2026-09-22.md · report/ROUND_USCITE_SUPERTREND_2026-09-09.md · report/PACCHETTO_R4_DA_FIRMARE_2026-09-11.md
  - report/IL_CORTO_DI_DAX_E_NASDAQ_2026-09-23.md · report/I_MORTI_E_LO_STORICO_2026-09-23.md (R113 prova di regime Nasdaq)
  - backtest_pipeline/risultati_archivio/REFERTO_FUORILISTA.md · REFERTO_ROUND20_GOLDENCROSS_FOREX.md · REFERTO_ROUND21_SUPREV_H4.md · REFERTO_ROUND22_GBPJPY_BORDO.md · R103_REFERTO_FINALE.md
  - report/AUDIT_VIRGOLA_CSV_2026-09-28.md (anomalie CSV GoldenCross)
  - report/CENSIMENTO_CONTRATTI_v2.md §4b
  - backtest_pipeline/risultati_prove/{ABTG_SupertrendReversal*,ABTG_SupRev_*_Ottimizzato,ABTG_SupertrendInvert,ABTG_GoldenCross*,SupRev_H4_r21,SupRev_GBPJPY_r22,SupRev_IBEX_r18,GoldenCross_forex_r20,SONDA_SUPERTREND_*.txt}
  - mql5/Experts/README_IchiTrend_Gold.md + sorgenti degli EA esterni oro
- **Cosa guardare per primo**: Punto critico: la 'squadra validata' del 26/07 ha **finestra piena senza OOS** (SupRev NAS H1: 8 passate su UNA finestra), e un **conflitto aperto**: PF bt 2,74 della `SupertrendReversal_Ottimizzato` contro OOS mediano 0,92-0,99 nel censimento; DOW H4 = illusione OHLC (0,79 a tick).

### GRUPPO G6 - CACCE WEB e MAI MISURATI (ONDATA 3) - 31 righe

- **Sedie / ruoli coperti**: nessuna sedia viva (candidati e lapidi)
- **Famiglie**: CAC-A, CAC-B, CAC-C
- **Output atteso**: `report/RESOCONTO_EA_SCHEDE_G6_AAAA-MM-GG.md` (tabella di sintesi per cella + una scheda per EA, sez. 6)
- **EA, in ordine di lavoro (esatti)**:
  - `ABTG_CRT_TurtleSoup` [CAC-B]
  - `ABTG_IBRetest` [CAC-B]
  - `ABTG_LVNArbitro` [CAC-B]
  - `ABTG_OpeningReversalB` [CAC-B]
  - `ABTG_OutOfNoise` [CAC-B]
  - `ABTG_NySessionRetest` [CAC-B]
  - `ABTG_DaxReEntry` [CAC-B]
  - `ABTG_DaxValueArea` [CAC-B]
  - `ABTG_HVAncora` [CAC-B]
  - `ABTG_AtrExhaustVol` [CAC-B]
  - `ABTG_IntradayMomentum` [CAC-B]
  - `ABTG_LiquiditySweep` [CAC-B]
  - `ABTG_FvgRetest` [CAC-B]
  - `ABTG_ImpulsoApertura` [CAC-B]
  - `ABTG_VolExpBreak` [CAC-B]
  - `ABTG_CanaleLento` [CAC-B]
  - `ABTG_Cycle` [CAC-B]
  - `ABTG_VwapRevert` [CAC-A]
  - `ABTG_MeanRevert` [CAC-A]
  - `ABTG_TurnaroundTuesday` [CAC-A]
  - `ABTG_InvEsaurimento` [CAC-A]
  - `standalone/ABTG_PointBreak.mq5` [CAC-A]
  - `standalone/ABTG_SuperFilter.mq5` [CAC-A]
  - `ABTG_CrossEma` [CAC-C]
  - `ABTG_CrossEmaApertura` [CAC-C]
  - `ABTG_ChaosLyapunov` [CAC-C]
  - `ABTG_AltaVelocita` [CAC-C]
  - `ABTG_HARSI` [CAC-C]
  - `HARSI_Assistant` [CAC-C]
  - `ABTG_Relativo` [CAC-C]
  - `ABTG_ScalperDirezionale` [CAC-C]
- **Fonti specifiche** (oltre alle comuni):
  - report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md tabella A (A42-A119)
  - report/PERCHE_NON_PASSANO_2026-09-09.md · report/I_BOCCIATI_HANNO_UN_CERTIFICATO_2026-09-12.md · report/I_QUATTRO_INVISIBILI_2026-09-12.md · report/CONTRADDIZIONI_CHIUSE_2026-09-09.md
  - report/CENSIMENTO_CASELLE_VUOTE_2026-09-22.md · report/CHI_ALTRO_PUO_SCHIERARSI_2026-09-22.md · report/LA_BANDA_BASSA_2026-09-12.md
  - backtest_pipeline/caccia_strategie/AUDIT_CACCIA_MECCANISMI_2026-09-26.md e i dossier CACCIA_*
  - backtest_pipeline/REGISTRO_TEST.md: CRT (r.863), Chaos (r.883), M0PB (r.1058), RSI+EMA V8 (r.1139), VwapRevert (r.1274), Relativo (r.1870-1884), IBRetest (r.2161), sequenza inversione (r.2273), quattro invisibili (r.3124)
  - backtest_pipeline/risultati_prove/{ABTG_AltaVelocita,ABTG_IBRetest,ABTG_LVNArbitro,ABTG_OpeningReversalB,meanrevert_r60,ibretest_p0,R172D}
  - sorgenti `.mq5` (attribuzione/origine in testa a ciascuno)
- **Cosa guardare per primo**: Punto critico: qui stanno i **conflitti fra date** (IntradayMomentum 09/09 vs 12/09; CrossEma) e gli EA con **zero misure** (VolExpBreak, Cycle, ImpulsoApertura, ScalperDirezionale, HARSI). Ordine interno: **(a) i bocciati con un numero** (CRT, IBRetest, Chaos, LiquiditySweep, VwapRevert, AltaVelocita, AtrExhaustVol...: **verificare per ciascuno se il certificato 5/5 e' completo**, altrimenti sono NON ANCORA MISURATI, non morti), **(b) i candidati con n<150 ancora in vita** (NySessionRetest, DaxReEntry long, LVNArbitro, Relativo NASUSD, InvEsaurimento), **(c) i NON MISURATI** (R141a-e, FvgRetest, OutOfNoise, mai-girati).

### Riepilogo del fan-out
| gruppo | ondata | famiglie | righe EA | sedie vive/candidate coperte | modello lettori |
|---|---|---|---:|---|---|
| G1 | ONDATA 1 | AP-DAX, AP-DOW, AP-NAS, LIVE5, DAXM3 | 26 | sedie 770101/770105/770202/770260/770250 (+770201 spenta) | Sonnet (+Haiku per i conteggi) |
| G2 | ONDATA 1 | EMA200, SW, ORB | 14 | sedie 771531 (EMA200 Dow H1), 770511/770512/770531 (SuperWave), 770611 (ORB Dow), 971501 (EMA200 oro) | Sonnet (+Haiku per i conteggi) |
| G3 | ONDATA 1 | NOTTE, PTE-WOL, POSTNEWS, BULGE, LONDRA | 14 | sedie 770411 (MaxMin DAX short), 770402 (oro), 771321-23/771332 (PTE), 771201-03 (PostNews), Bulge | Sonnet (+Haiku per i conteggi) |
| G4 | ONDATA 2 | BB, C2C, EZ, GAP, LARRY, FIBO, CORSO-JPY | 12 | sedie 772161-63 (BB), 772361-63 (C2C), 772421-23 (EZ), 772231-35 (Gap), 774101, 772341-46 (Larry) | Sonnet (+Haiku per i conteggi) |
| G5 | ONDATA 2 | SUPREV, GC, ORO-EXT | 19 | sedie 970901/970912/970913/971001/971501, 770331-33, 770901-24, EA esterni oro | Sonnet (+Haiku per i conteggi) |
| G6 | ONDATA 3 | CAC-A, CAC-B, CAC-C | 31 | nessuna sedia viva (candidati e lapidi) | Sonnet (+Haiku per i conteggi) |

Passi dopo i sei gruppi: **(P1)** un aggregatore (architetto-prop) fonde le sei tabelle di sintesi nelle due liste richieste da Claudio -- **EA con celle SOPRA 1** e **EA con celle SOTTO 1** -- piu' la terza **NON MISURATO**, ciascuna con tipo di dato e affidabilita';
**(P2)** cancello (`controllo-preventivo`, Opus) su ogni numero con file+riga **prima** di mandare qualunque cosa a Claudio; **(P3)** se il documento serve a una persona esterna: PDF (`backtest_pipeline/md2pdf_collega.py`), con l'informazione nel testo e non nelle emoji.


---

## 8. PUNTI DUBBI E BUCHI GIA' VISIBILI (dichiarati, non nascosti)

| id | punto | perche' conta | chi lo chiude |
|---|---|---|---|
| D1 | **Unita' di n**: le fonti mescolano **deal** (uscite) e **posizioni**; il fattore va da 1,00 a 2,31 e dipende dalla cella. Es. EMA200 Dow IS: 237 deal, **132 posizioni dichiarate non ricontabili** dal repo (per-trade assente), forbice 103-237 | un "n>=150" falso cambia la classe di affidabilita' | G2 (con il per-trade da rilanciare, costo basso) |
| D2 | **Soglia di ZONA GRIGIA sul PF non esiste**: il vocabolario dice che le soglie le fissa ogni misura prima dei dati. Il dossier stima un errore tipico ~0,2 su n=144 `[stima]` | senza soglia, "SOPRA 1" per PF 1,01-1,10 e' rumore | **Claudio / cancello**: serve una regola prima di riempire le schede (proposta: affidabilita' C/D + nota 'indistinguibile da 1' sotto errore tipico dichiarato) |
| D3 | **PF su finestra piena senza OOS** (SupRev Ott., GoldenCross Ott., SuperWave DAX H4, EMA200 oro...): e' "sopra 1"? Qui = SOPRA **(senza OOS)** | e' il caso della "squadra validata" del 26/07 | decisione di etichetta (G5 la applica) |
| D4 | **Misure discordanti non riconciliate**: Nasdaq 770260 (1,14/1,11 su 91/94 vs 1,22/1,22 su 82/102); SuperWave 770511 (143 deal/DD 3,91% vs 131/4,17%); `SupertrendReversal_Ottimizzata` (bt 2,74 vs OOS mediano 0,92-0,99) | celle CONTESE -> NON MISURATO finche' non si chiudono | G1 / G2 / G5 |
| D5 | **Conflitti fra date**: `IntradayMomentum` (09/09: OOS 0/6 e costo C3; 12/09: NON ANCORA MISURATO, R141a/b); `CrossEma` (R86 'EDGE/PF' in blocco vs censimento 4/6 sopra 1); `DaxValueArea` (09/09 'morto' vs 12/09 R141e) | un verdetto non puo' essere due cose | G6 (verificare in `prove/` e `CODA` se R141a-e sono girati) |
| D6 | **Verdetti compromessi dal metodo**: `Londra_ORB` R45 misurava la pre-apertura (fuso sbagliato) -> da rifare; `Nightly` giudicato su 21 mesi per errore di copia (EURCHF dal 1993) | sono 'morti' senza certificato valido | G2 / G3 |
| D7 | **Dato non dichiarato nel censimento 09/09**: il CSV non separa tick da barre; per molte righe il tipo va ricavato dalla cartella/etichetta (`ohlc` nel nome) o dal referto | rischio di mescolare `[B]` e `[T]` nella stessa colonna | ogni gruppo, cella per cella |
| D8 | **Finestra indici = 21 mesi e un solo regime** (dal 26/09/2024): per tutti gli EA indice la risposta "regimi superati" e' `NON MISURATO` fuori dal rialzo; esistono storici esterni (DAX 8 anni non importato, Nasdaq 15,7 anni a barre, Dow nessuno) | e' il limite piu' grande dei numeri | si segnala; allungare lo storico e' una decisione di spesa/firma (piano Dow 90-348 h) |
| D9 | **Round successivi al censimento 09/09** (R242-R247, R255, R260-R269, ROUND CORTI B/C/C2, trasformazioni di fine settembre) possono aver cambiato verdetti gia' scritti nelle righe della sez. 4 | le righe vanno aggiornate dalla root `REGISTRO_TEST.md` | ogni gruppo |
| D10 | **"Tipologie di mercati"** ambigua (classi di strumento o regimi): la scheda riporta **tutte e due** (5.7) | evitare di rispondere a meta' | Claudio, se vuole solo una |
| D11 | **Forward demo: solo demo, mai FTMO**; ma molte fonti interne (contratti, mappe aperture) sono nate per una challenge: si usano **solo le parti backtest** | coerenza con la decisione di non parlarne all'esterno | tutti |
| D12 | **Cartelle `standalone/` e `trailfix_9fca63d9/`**: le copie sono diverse dalla root; il resoconto le tratta come EREDITA (stesso motore) **senza averle diffate riga per riga** | se il motore differisce, la riga madre non vale | G1 (trailfix), G5/G6 (standalone) in lettura rapida |
| D13 | `esterni/…v21_OPTIMIZED.ex5` e `BREAKOUT_EA_JPY_v3` **non hanno sorgente**: non sono misurabili ne' classificabili: restano NON MISURATO con la causa | perimetro | nessuno (si dichiara) |

**Cosa NON e' in questa fase (e non va finto)**: nessuna scheda e' riempita; nessun numero e' stato ricalcolato dai CSV; le classi sono provvisorie; nessun round e' stato proposto con i costi (lo faranno i gruppi nel campo 11-12 della scheda).

---

## CHANGELOG
| data | cosa | perche' |
|---|---|---|
| 05/10/2026 | creato il file (FASE 1: elenco, regola, scheda, fan-out) | richiesta di Claudio del 05/10/2026 sul resoconto PF sopra/sotto 1 per ogni EA |
