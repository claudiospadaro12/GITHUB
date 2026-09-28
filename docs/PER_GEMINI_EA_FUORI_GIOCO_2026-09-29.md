# PER GEMINI — Gli EA e i motori MESSI FUORI GIOCO: i parametri da controllare (29/09/2026)

_Da Claudio Spadaro, progetto ABTG. Mandato di Claudio (notte 28/29-09), testuale: «gemini puo' aiutarci a migliorare i nostri pf degli ea messi fuori gioco. mandiamogli tutti i parametri da controllare e verificare». Questo documento e' per l'Agente 3 (il Proponente) e l'Agente 4 (l'Avvocato del diavolo). Ogni motore ha la sua sezione con: la CELLA misurata (tutti gli input pinnati), i numeri con il file sorgente, il motivo per cui e' fuori gioco, lo stato del certificato di morte e cio' che e' GIA' stato provato._

## 0. Contesto in 5 righe
1. **Chi siamo**: ABTG costruisce Expert Advisor MQL5 (MetaTrader 5) per superare challenge prop; oggi FTMO 2-Step da 80.000 EUR. Claude = sviluppatore + cancello; voi = Agente 3 e 4; Claudio firma taglie, rischio, conti, spese.
2. **L'imbuto**: file prova (UNA variabile per file, tutti gli input pinnati, attesa scritta PRIMA dei numeri) -> cancello deterministico -> riga di lancio -> tester MT5 a tick reali con walk-forward IS/OOS -> referto -> firma. Un numero OHLC e' screening, il verdetto lo danno i tick reali (fattore misurato OHLC->tick sul PF: 1,71-1,85 in eccesso).
3. **I cancelli**: merito = **PF >= 1,10 in IS E in OOS con n >= 150 posizioni** (sotto 150 il merito e' SOSPESO, il rischio si legge a qualunque n); rischio = **DD alla taglia di volo dentro il 10%** (muro FTMO, giornaliero 5%: a 1% di banco il tetto tradotto e' ~4,0-4,08% = 8% a 2,00%); costo = **stop >= 40 x (spread + commissione)**, pavimento duro 13,3x; frequenza = **>= 1,00 operazione/giorno per FAMIGLIA** (motore x simboli), non per sedia; selezione = **centro dell'altopiano, MAI il picco** (se una cella sporge e le vicine no: "non c'e' una configurazione robusta").
4. **Regole del 19/08 e del 09/09**: su un motore senza edge una griglia piu' fitta trova solo picchi di rumore (vietata); si allarga su MECCANISMI, simboli, TF, gestione dell'uscita. Un candidato NON e' "morto" finche' non ha il **certificato a 5 caselle**: (1) PF misurato · (2) n e DD · (3) gestione dell'uscita messa ad asse · (4) simboli gemelli provati · (5) TF cambiato. Se ne manca una il verdetto e' **NON ANCORA MISURATO**, non "morto".
5. **Che cosa e' questo file**: l'elenco, per nome, dei motori/celle fuori gioco (bocciati per rischio, merito o costo; sospesi per campione; "non ancora misurati"), con i parametri esatti che hanno dato i numeri, cosi' che voi possiate cercare **errori di configurazione** e proporre **un solo meccanismo alternativo per motore**.

## 1. LA RICHIESTA (Agente 3 + Agente 4)
Per **OGNI motore** delle sezioni A1-A14 e B1-B9 (e per le righe della tabella C se ne vedete l'utilita'):
- **(a) ERRORE DI CONFIGURAZIONE?** Leggendo i parametri pinnati qui sotto e — dove li avete — i sorgenti (`ABTG_DAX_Apertura_EU.mq5`, `ABTG_Dow_Apertura_US.mq5`, `ABTG_Guardian.mq5`; gli altri EA li citiamo solo per nome, **non li avete**: se vi serve un sorgente, chiedetelo per nome), dite se vedete: input **incoerenti fra loro**, un filtro **spento che dovrebbe essere acceso** (o viceversa), un'**ora sbagliata** (ricordate l'orologio BCM, sezione 2), uno **stop fuori scala rispetto all'ATR**, una manopola che potrebbe essere **inerte** (un input che il ramo attivo non legge: noi abbiamo trovato 874 file su 1.960 con esiti identici). Citate input e, se avete il sorgente, la riga. Se non vedete niente, scrivete "nessun errore visibile" — e' una risposta valida.
- **(b) AL MASSIMO UN MECCANISMO ALTERNATIVO per motore** (mai una griglia dello stesso motore). Per ciascuno: il meccanismo in una frase; l'**attesa dichiarata** (n operazioni, PF, DD, e PERCHE') scritta prima dei numeri; il **contro-esempio** (l'ipotesi alternativa e quale numero produrrebbe: se cade nella stessa banda, la misura non misura niente); il **piano di misura nell'imbuto** (un asse per file, cella di controllo/ancora, cosa lo falsifica); il **costo in celle x 2 finestre** (= passate del tester). "Nessuna proposta: motore chiuso" e' ammesso.
- **(c) CHIUSO DAVVERO?** Dite quali motori considerate chiusi per davvero e perche' (quali delle 5 caselle sono piene e quale numero li chiude), e quali invece restano aperti per un numero MANCANTE (non brutto). Un motore chiuso da un numero brutto su campione pieno non si riapre; uno fermo per un numero mancante si'.

**Formato di risposta richiesto (per stare nel limite di uscita)**: un riquadro iniziale di 10 righe con le 3 cose piu' importanti; poi **una riga di tabella per motore**: `# · (a) errore config [input] o "nessuno" · (b) meccanismo + attesa + costo (celle x 2) · (c) chiuso/aperto + perche'` — **massimo ~90 parole per motore**. Se lo spazio non basta, **servite nell'ordine A1 -> A14 -> B1 -> B9 -> C** e dite dove vi siete fermati. Niente prosa di cortesia.

**Cosa NON fare**: nessuna griglia di parametri d'ingresso su un motore a PF < 1,10 su campione pieno; nessuna proposta che abbassi una soglia (PF, n, DD, costo 40x, altopiano); niente martingala, griglia di ordini, recovery, assenza di stop; niente proposte che toccano taglie, rischio per operazione, conti reali o Guardian in campo (quelle sono firme di Claudio: se servono, in fondo, marcate "richiede la firma di Claudio").

## 2. Come leggere le sezioni (legenda)
- **Blocchi di parametri**: sono le righe `Inp*=` del **file prova** che ha prodotto i numeri (un file = un asse). `Nome=valore   # ASSE a..b passo p` = manopola messa ad asse in quel file (il valore e' quello della cella base; il file gira tutti i valori dell'asse). Sono TUTTI gli input dell'EA pinnati nel file (quelli non elencati non esistono nel file). Sono omessi solo `InpMagic` e `InpComment` (etichette tecniche del banco di prova). Nessuno di questi blocchi e' un preset in campo.
- **Testata del file** (`@SIMBOLO`, `@PERIODO` = TF del grafico, `@DAQUANDO`/`@FINOA` = finestra, `@FRAZIONEIS` = quota IS del walk-forward): dice su che simbolo, TF e finestra la cella ha girato.
- **Enum dei TF** (valori interi nei blocchi): `1`=M1 · `5`=M5 · `15`=M15 · `30`=M30 · `16385`=H1 · `16386`=H2 · `16388`=H4 · `16390`=H6 · `16392`=H8 · `16396`=H12 · `16408`=D1.
- **n**: `Trades` del CSV = DEAL di uscita (la parziale al 50% conta 2 deal per posizione); dove serve la POSIZIONE c'e' scritto "pos.". **DD**: `Equity DD %` del tester (dal picco) salvo dove c'e' scritto "DD_fisso" (= |Profit/RecoveryFactor|/deposito) o "a saldo chiuso". **Ogni DD porta accanto il suo `InpRiskPercent`** (nei banchi e' quasi sempre 1,00; la taglia di riferimento dei cancelli e' 2,00: fattore misurato 1,956-1,990, quindi un DD a 1% x ~2 = DD alla taglia di volo, limite superiore).
- **Modello**: `tick` = tick reali (verdetto); `OHLC` = barre M1 (screening, ottimista). **Un numero OHLC non boccia e non promuove**, salvo uno zero OHLC su campione largo (chiude, perche' l'errore e' ottimista).
- **Storico disponibile** (le finestre sono SOLO queste): indici BCM (DAX `D30EUR`, Dow `U30USD`, Nasdaq `NASUSD`) **dal 2024.09.26** (~21 mesi, un solo regime); forex dal 1999 (finestre lunghe a OHLC M1 ok, tick BCM da 2024.07.05); oro M1 dal 2004.06.11 sul banco di backtest (tick oro dal 2024.07.10).
- **Orologio BCM** (misurato il 24/09): BCM e' **UTC+1 fisso** sugli indici su tutta la finestra e sul forex dal ~2025; d'estate = ora italiana - 1, **d'inverno = ora italiana**. Un input `InpSessionHour=8` (DAX) o `14/30` (USA) e' l'apertura cash SOLO d'estate: d'inverno arma **un'ora prima**. I numeri dei backtest mescolano le due tempistiche (dichiarato caso per caso).
- **Etichette**: `[MISURATO]` letto da un CSV/referto; `[DERIVATO]` calcolato da una formula scritta; `[NON MISURATO]` non esiste ancora una misura. **Niente numero senza fonte**: la fonte e' il nome del file nel repo.
- **Costo del banco**: il tester addebita la commissione forex (verificato: 992 deal, -2.560,87 EUR); sugli indici commissione 0,00 misurata e il pedaggio e' lo spread (mediana di sessione U30USD 1,8-2,0 punti, D30EUR ~2,8).

## 3. Indice dei motori fuori gioco
| # | motore | EA | verdetto in una riga |
|---|---|---|---|
| A1 | Londra ORB (GBPUSD, EURUSD) | `ABTG_Londra_ORB` | bocciato per RISCHIO/merito/costo a tick, uscita MAI ad asse -> NON ANCORA MISURATO |
| A2 | Nightly, sei simboli | `ABTG_Nightly` | fuori per RISCHIO alla gestione di default; screening OHLC; uscita mai ad asse |
| A3 | Box asiatico GBPUSD/EURUSD | `ABTG_MaxMinNotte` (H1) | H0 piatto (PF 0,88-1,28), DD a 1% violato; uscita e TF mai ad asse |
| A4 | EMA200 EURUSD H4 solo corto | `ABTG_EMA200` | ESCLUSO PER COSTO (35,3-36,8x < 40x), `InpSLatr` mai ad asse |
| A5 | EMA200 oro H4 | `ABTG_EMA200` | NO PER RISCHIO su 2017-23 (DD 13,32% a 1%); recente buono ma non confrontabile |
| A6 | EMA200 H4 GBPJPY/GBPUSD/AUDJPY | `ABTG_EMA200` | banco ROSSO 4/4, 12 griglie saltate; AUDJPY morto su campione pieno |
| A7 | Short Dow (770212, R255) | `ABTG_Dow_Apertura_US` | BOCCIATA PER RISCHIO alla cella in firma; stH8/stH12 indizi sospesi |
| A8 | Short DAX specchio del long | `ABTG_DAX_Apertura_EU` | senza merito e DD sopra il muro (R251, R270) |
| A9 | Gap continuation DAX solo short | `ABTG_GapContinuation` | merito sospeso (29 pos.), NON ANCORA MISURATO |
| A10 | Oro solo long (col trend, R260d) e varianti | `ABTG_MaxMinNotte` (oro) | RISCHIO VIOLATO a qualunque n (DD 3,38% a 0,5% vs 2,06%) |
| A11 | MaxMinNotte DAX long e short | `ABTG_MaxMinNotte` (D30EUR) | long 0/41 celle >= 1,00 a tick; short sospeso (< 150 pos.) |
| A12 | Dow breakout a due lati (candidato #1) | `ABTG_Nasdaq_Apertura_US` (U30USD) | RISCHIO: muro DD a 2% fra 1,25 e 1,50%; revisione R248 |
| A13 | Gap cash Nasdaq | `ABTG_SondaGapCash` | SCARTO al passo 0: segno rovesciato sui tick BCM |
| A14 | R118 pavimento dello stop sotto slippage | `ABTG_ORB_Ottimizzato`, `ABTG_DAX_Apertura_EU` | nessuna cella promossa; a 20 punti il pavimento e' un no-op |
| B1 | LondonFx (R116) | `ABTG_LondonFx` | BOCCIATA PER RISCHIO su EURUSD e GBPUSD a tick |
| B2 | Relativo D30EUR / NASUSD (R117) | `ABTG_Relativo` | D30EUR bocciata per rischio; NASUSD merito sospeso |
| B3 | Live5m (DAX, Nasdaq, DAX v2) | `ABTG_DAX_Live5m`, `_Nasdaq_Live5m`, `_v2` | tick negativi + costo M5; NON ANCORA MISURATI (uscita, gemelli, TF 30/60') |
| B4 | PostNews (ISM/EURUSD, 13:30/USDJPY) | `ABTG_PostNews` | PF < 1 su IS e OOS al passo 0 (OHLC); parametri mai ritarati |
| B5 | IBRetest | `ABTG_IBRetest` | scarto al cancello C0 (PF famiglia 0,7798, n=209 OOS) |
| B6 | VwapRevert D30EUR M15 | `ABTG_VwapRevert` | FALSIFICATO al cancello S0 (4 celle su 4) |
| B7 | EMA200: simboli e TF scartati | `ABTG_EMA200` | U30USD M5-M30 per costo; E50EUR e NASUSD H1 per merito; H4 per campione |
| B8 | Famiglia Supertrend/SupRev/SuperWave a M30/M15 | varie | 0/34 coppie con PF >= 1,10 a M30; 0/40 celle nella sonda esterna |
| B9 | Oro finestra 15:36 M1 | (metodo del collega) | BOCCIATO PER COSTO (8,8-12,5x) |
| C | Altri caduti (FiboH4, ORB_Fibo, ORB, DAX_M3, CRT, Chaos, M0PB, RSI+EMA V8, BreakinBox, DaxReEntry, NY Retest, sequenza, M5 per costo, R83/R84) | vari | tabella C con verdetto, numero e cosa manca |

---
# PARTE A — Motori misurati fra il 24 e il 28/09/2026 (celle con i file prova originali)

## A1. Londra ORB (`ABTG_Londra_ORB`) — GBPUSD ed EURUSD — 🔴 bocciato a tick, ⚪ NON ANCORA MISURATO (uscita)
**Cella**: EA `ABTG_Londra_ORB.mq5` · GBPUSD ed EURUSD · TF grafico M5 (INERTE: M30 riproduce M5 al centesimo, controllo T1 verde) · **tick reali walk-forward `2024.07.05 -> 2026.06.30`** (IS 40% / OOS 60%) · deposito 10.000 · rischio banco 1,00 · round **R258** del 28/09 (36 job, motore = pin), file `backtest_pipeline/prove/R258a_londra_T_GBPUSD_ora8_UK_TESTA.txt` (+ b..x). "Ora 7/8/9" = ora server del piazzamento (`InpPlaceHour`) con canale di UNA ora che lo precede. Ora 8 = canale 07:00-08:00 server = apertura di Londra (Londra apre alle 08:00 ora server: misurato il 03/09).

**Parametri pinnati (cella base = GBPUSD, ora 8)**

```
@SIMBOLO    GBPUSD
@PERIODO    M5
@DAQUANDO   2024.07.05
@FINOA      2026.06.30
@FRAZIONEIS 0.40
InpRangeStartHour=7
InpRangeStartMin=0
InpRangeEndHour=8
InpRangeEndMin=0
InpMinRangePips=0   # ASSE 0..70 passo 10
InpMaxRangePips=0
InpPlaceHour=8
InpPlaceMin=0
InpEntryCutoffHour=12
InpEntryCutoffMin=0
InpCloseHour=17
InpCloseMin=0
InpCloseAtEnd=1
InpOneTradePerDay=1
InpPendingExpiryMin=240
InpBufferPips=3.0
InpAllowLong=1
InpAllowShort=1
InpSLMode=0
InpHalveOnOpposite=0
InpTPRangeMult=1.0
InpUsePartial=0
InpTP1_R=1.0
InpTP1Pct=50
InpBreakeven=0
InpUseTrailing=0
InpTrailTF=15
InpAtrPeriod=14
InpTrailAtrMult=2.0
InpRiskPercent=1.0
InpUseNewsFilter=0
InpNewsFile=abtg_news.csv
InpNewsMinImpact=3
InpNewsBeforeMin=60
InpNewsAfterMin=60
InpNewsShiftMinutes=0
InpNewsCurrencies=GBP,USD
InpMaxSpread=0
InpVerbose=1
```

**Differenze delle altre celle** (tutto il resto identico alla base):
- ora 7 (`R258b` GBPUSD, `R258e` EURUSD): 
```
InpRangeStartHour=6
InpRangeEndHour=7
InpPlaceHour=7
InpEntryCutoffHour=11
InpCloseHour=16
```

- ora 9 (`R258c` GBPUSD, `R258f` EURUSD): 
```
InpRangeStartHour=8
InpRangeEndHour=9
InpPlaceHour=9
InpEntryCutoffHour=13
InpCloseHour=18
```

- EURUSD ora 8 (`R258d`): solo `@SIMBOLO EURUSD`. Gemelle M30 (`R258g/h`): `@PERIODO M30`. `R258w/x`: `InpRangeStartMin` 0/30. `R258u/v`: `InpBufferPips` 1/3/5 con `InpMinRangePips` 70 (GBPUSD) o 50 (EURUSD). Blocco stagioni (`R258i-n`, un anno 2025.03.31-2026.03.27, orologio "in fase"): stesso motore, orari d'estate/inverno spostati. Screening OHLC 2008.01.02-2024.07.04 (`R258o-t`).

**Numeri (tick, riga `InpMinRangePips=0`; DD_fisso = |Profit/RF|/deposito; fonte `report/LETTURA_ROUND_CORTI_A_2026-09-28.md` sez. R258 + CSV `backtest_pipeline/risultati_archivio/ROUND_CORTI_A_2026-09-28/ROUND_R258x/`)**
| cella | n IS/OOS (deal) | PF IS / OOS | Profit IS / OOS | DD_fisso% IS / OOS | costo (stop mediano, x40) |
|---|---|---|---|---|---|
| GBPUSD ora 7 (R258b) | 203 / 306 | 0,7012 / 0,7358 | -3353 / -4480 | 34,64 / 54,93 | 3-8 pip = 3,6-9,5x: ESCLUSA PER COSTO |
| GBPUSD ora 8 (R258a) | 199 / 296 | 1,0536 / 0,9748 | +616 / -463 | 19,86 / 38,21 | 8-13 pip = 9,5-15,5x: ESCLUSA (scavalca 13,3x) |
| GBPUSD ora 9 (R258c) | 196 / 294 | 0,7962 / 0,8197 | -2240 / -2949 | 29,72 / 32,26 | 13-18 pip = 15,5-21,4x: FRAGILE |
| EURUSD ora 7 (R258e) | 204 / 306 | 0,6538 / 0,8653 | -3507 / -2390 | 35,08 / 36,95 | 3-8 pip: ESCLUSA PER COSTO |
| EURUSD ora 8 (R258d) | 199 / 296 | 1,1750 / 0,9059 | +1973 / -1664 | 15,74 / 30,02 | 8-13 pip = 12,0-19,6x: ESCLUSA |
| EURUSD ora 9 (R258f) | 193 / 293 | 0,8276 / 0,7025 | -1847 / -4781 | 26,37 / 53,02 | 8-13 pip: ESCLUSA |
Alzando il pavimento del range (`InpMinRangePips` 10..70) il PF IS sale ma il campione crolla: a 20 pip GBPUSD ora 8 fa 47/86 deal IS/OOS (PF 1,39/0,92), a 30 pip 15/19: merito SOSPESO (n < 150), rischio VIOLATO gia' a 20 pip. **L'ora NON decide** (scarti di PF 0,04-0,24 contro il rumore 0,33 a n~300); l'ipotesi "Londra apre alle 7 server" del PDF esterno NON e' confermata. Screening OHLC 2008-2024 GBPUSD: PF IS ora 7/8/9 = 0,891/0,953/0,905, OOS 0,834/0,923/0,988 (nessuna storia stabile dell'ora).

**Perche' e' fuori gioco**: **rischio** (DD_fisso OOS 30-55% a 1%, contro il tetto ~4,0% a 1%) su tutte e 6 le celle, sopra qualunque n; **merito** (PF OOS < 1,00 su n 293-306, tutte e 6, ben oltre i 150); **costo** (lo stop del canale di 1 ora e' 3-13 pip: 3,6-19,6x contro 40x; la frontiera su GBPUSD/EURUSD e' ~11-13 pip con pedaggio all-in 0,84/0,66 pip).
**Certificato**: (1) PF SI · (2) n+DD SI · (3) **uscita NO** (`InpUsePartial`/`InpBreakeven`/`InpUseTrailing` tutti 0 e `InpTPRangeMult`=1,0 fisso: mai ad asse) · (4) gemelli SI (GBPUSD+EURUSD) · (5) TF: **grafico inerte (misurato)**; il TF operativo e' d'orologio (canale 07-08), `InpTrailTF`=15 spento con trailing 0 -> NON APPLICABILE come manopola di barre. Verdetto: **NON ANCORA MISURATO** (manca il punto 3).
**Gia' provato (non riproporre)**: 3 ore (7/8/9) x 2 simboli; soglia minimo range 0..70 pip; buffer 1/3/5 pip; inizio range :00/:30; stagioni in fase; TF grafico M30; screening OHLC lungo. **Mai provato**: uscita (parziale/BE/trailing/timestop/target a multipli del range), filtro notizie (`InpUseNewsFilter=0`), i due lati separati, filtro di volatilita'/compressione asiatica, gestione a orario di chiusura diversa da 17:00.

## A2. Nightly, fade notturno sui sei simboli (`ABTG_Nightly`) — 🔴 per RISCHIO alla gestione di default (screening OHLC), ⚪ NON ANCORA MISURATO (uscita)
**Cella**: EA `ABTG_Nightly.mq5` · AUDUSD, USDJPY, XAUUSD, XAGUSD, D30EUR, U30USD · M15 · **OHLC M1 (Modello 1: SCREENING, ottimista sul PF di 1,72-3,51x, sottostima il DD)** · forex `2019.01.01 -> 2026.06.30`, indici/metalli `2024.09.26 -> 2026.06.30` · rischio banco 1,00 · round **R259** del 28/09, file `backtest_pipeline/prove/R259_nightly_<SIMBOLO>_PIN.txt`. Box notte 22:00-04:59, piazzamento 05:00, cutoff 07:00 server; fade (sceglie il lato opposto alla rottura).

**Parametri pinnati (cella base XAUUSD; nota: l'asse e' il filtro QB `InpMaxNightVolPips` 0/45 per i metalli/indici e il rifiuto per nome `InpBlockNightActive` 0/1 per AUDUSD/USDJPY)**

```
@SIMBOLO  XAUUSD
@PERIODO  M15
@DAQUANDO 2024.09.26
@FINOA    2026.06.30
@FRAZIONEIS 0.40
InpMaxNightVolPips=0   # ASSE 0..45 passo 45
InpUsaGuardian=1
InpBoxStartHour=22
InpBoxStartMin=0
InpBoxEndHour=4
InpBoxEndMin=59
InpPlaceHour=5
InpPlaceMin=0
InpCutoffHour=7
InpCutoffMin=0
InpCloseAtCutoff=0
InpAllowLong=1
InpAllowShort=1
InpEdgeOffsetPips=0
InpOneShotPerNight=1
InpSLpips=0
InpAtrPeriod=14
InpSLatrMult=1.0
InpTPfrac=0.5
InpMinRangePips=0
InpMaxRangePips=0
InpBlockNightActive=1
InpRiskPercent=1.0
InpUseNewsFilter=0
InpNewsMinImpact=3
InpNewsBeforeMin=60
InpNewsAfterMin=60
InpNewsShiftMinutes=0
InpMaxSpread=0
InpVerbose=1
```

**Differenze**: D30EUR, U30USD, XAGUSD = solo `@SIMBOLO`. AUDUSD e USDJPY: 
```
@SIMBOLO  AUDUSD
@DAQUANDO 2019.01.01
@FRAZIONEIS 0.50
InpBlockNightActive=0   # ASSE 0..1 passo 1
InpMaxNightVolPips=45
```

(le cause dei sei zeri d'archivio, lette nel sorgente il 26/09: `ABTG_Nightly.mq5` r.167 rifiuta AUDUSD/USDJPY *per nome* (regola del PDF, `InpBlockNightActive=1`); su indici/metalli il filtro QB confronta `ATR(H1)/PipSize()` con 45 e `PipSize()=_Point` lo rende sempre >= 45 -> zero trade; qui QB spento con `InpMaxNightVolPips=0` / rifiuto per nome spento.)

**Numeri (OHLC, cella di misura; fonte `report/LETTURA_ROUND_CORTI_A_2026-09-28.md` sez. R259, CSV `ROUND_R259_<SIMBOLO>/`)**
| simbolo | n IS/OOS | PF IS / OOS | Equity DD % IS / OOS (a 1%) | costo | verdetto del lettore |
|---|---|---|---|---|---|
| AUDUSD | 477 / 500 | 0,7562 / 0,9512 | 62,10 / 26,59 | non misurato | niente a questa gestione |
| USDJPY | 348 / 480 | 0,7009 / 0,6746 | 50,65 / 68,24 | serve stop >= 12 pip | niente a questa gestione |
| XAUUSD | 98 / 140 | 0,7516 / 0,9964 | 14,75 / 9,46 | ~51x [DERIVATO grossolano] | NON ANCORA MISURATO (n < 150) |
| XAGUSD | 0 / 54 | 0,0000 / 0,8047 | n/d / 8,80 | non misurato | NULLO: zero operazioni in IS (storico/motore), diagnosi non voto |
| D30EUR | 79 / 163 | 0,6034 / 0,9639 | 17,38 / 18,56 | 18,4-20,9x: ESCLUSO PER COSTO | NON ANCORA MISURATO (n < 150) |
| U30USD | 76 / 130 | 1,1225 / 0,8604 | 7,02 / 11,86 | 39,0-44,1x (26-29x al P95): FRAGILE | NON ANCORA MISURATO (n < 150) |
Archivio precedente (motore gia' sano su forex): EURUSD 106/164 deal, GBPUSD 96/163, USDCHF 81/131 -> verdetto negativo su tre mercati ("0/8"); EURCHF: PF 0,89113/0,81429, DD 11,10/15,39, n 63/85 (BOCCIATO PER RISCHIO, `REGISTRO_TEST.md`, riga P0_EURCHF). Cella 0 dei simboli "dormienti" (R220a-d, 8 finestre): PF 0,586-1,049, 6 su 8 sotto 1.

**Perche' e' fuori gioco**: **rischio** alla gestione di default (Equity DD 7,0-68,2% a 1% su tutte le celle con operazioni, mai sotto il tetto ~4% a 1%); **merito** (PF OOS < 1,00 su tutti i simboli con n abbondante: AUDUSD 0,951 su n 500, USDJPY 0,675 su n 480); **costo** su D30EUR (18-21x) e al limite su U30USD; il verdetto e' su OHLC = screening: **non e' un certificato di morte**.
**Certificato**: (1) PF SI (OHLC) · (2) n+DD SI · (3) **uscita NO** (`InpCloseAtCutoff`, `InpTPfrac`=0,5, `InpSLatrMult`=1,0, `InpSLpips`: mai ad asse) · (4) gemelli SI (9 simboli in totale con EURUSD/GBPUSD/USDCHF/EURCHF) · (5) TF: **M15 solo** [NON MISURATO su altri TF]. Verdetto: **NON ANCORA MISURATO**.
**Gia' provato**: 6 simboli a gestione di default; QB acceso/spento; rifiuto per nome acceso/spento. **In coda dichiarata ma mai girata**: `InpCloseAtCutoff` (chiusura a orario), AUDNZD/AUDCAD. **Regola**: niente seconda griglia d'ingresso (PF OOS < 1,10 con n 480-500).

## A3. Box asiatico intero (`ABTG_MaxMinNotte` su GBPUSD/EURUSD) — 🟠 H0 (piatto), DD a 1% violato a qualunque n; ⚪ NON ANCORA MISURATO (uscita, TF)
**Cella**: EA `ABTG_MaxMinNotte.mq5` · GBPUSD ed EURUSD · TF grafico H1 (il TF di gestione e' `InpMgmtTF`=15) · **OHLC M1** · IS `2015.01.01 -> 2019.12.31` / OOS `2020.01.01 -> 2026.06.30` (`@FRAZIONEIS 0.4348`) · deposito 10.000, rischio banco 1,00 · round **R266** del 28/09, file `prove/R266a_asia_box_GBPUSD_TESTA.txt` (+ b..f). Box 00:00-07:59 server, piazzamento alle 08:00, cutoff 11:00, uscita 17:00.

**Parametri pinnati (cella base R266a = GBPUSD, due lati)**

```
@SIMBOLO    GBPUSD
@PERIODO    H1
@DAQUANDO   2015.01.01
@FINOA      2026.06.30
@FRAZIONEIS 0.4348
InpUsaGuardian=true
InpBoxStartHour=0
InpBoxStartMin=0
InpBoxEndHour=7
InpBoxEndMin=59
InpMinBoxPts=277
InpMaxBoxPts=0
InpPlaceHour=8
InpPlaceMin=0
InpEntryCutoffHour=11
InpEntryCutoffMin=0
InpCloseHour=17
InpCloseMin=0
InpCloseAtEnd=true
InpOneTradePerDay=true
InpPendingExpiryMin=180
InpBufferPoints=30
InpAllowLong=true
InpAllowShort=true
InpSLMode=0
InpMgmtTF=15
InpAtrPeriod=14
InpAtrSLmult=1.5
InpSLFixedPts=3000
InpTP1_R=1.0
InpTP1Pct=50
InpBreakeven=true
InpTP2_R=2.5
InpTP2Pct=50
InpUseEMA200Target=true
InpEMA200Period=200
InpTPfinal_R=4.0
InpUseTrailing=true
InpTrailAtrMult=2.0
InpUseCorrelation=false
InpCorrSymbol=SPXUSD
InpCorrTF=16385
InpCorrEmaFast=14
InpCorrEmaSlow=100
InpRiskPercent=1.0
InpUseNewsFilter=false
InpNewsFile=abtg_news.csv
InpNewsMinImpact=3
InpNewsBeforeMin=30
InpNewsAfterMin=30
InpNewsShiftMinutes=0
InpNewsFlatten=true
InpMaxSpread=0
InpVerbose=true
InpAutoTest=true
```

**Differenze**: `R266b` GBPUSD solo long: 
```
InpAllowShort=false
```
 `R266c` GBPUSD solo short: `InpAllowLong=false`. `R266d/e/f` EURUSD (due lati/solo long/solo short): `@SIMBOLO EURUSD` e `InpMinBoxPts=206` (GBPUSD 277: il cancello del costo e' tradotto in punti a 5 cifre: stop = W + 2 x buffer >= 40x il pedaggio all-in, 33,7 pip GBPUSD / 26,6 pip EURUSD).

**Numeri (OHLC, fonte `report/LETTURA_ROUND_CORTI_C_2026-09-28.md` sez. 5, CSV `ROUND_CORTI_C_2026-09-28/ROUND_R266x/`; DD = Equity DD % a 1%)**
| cella | IS: n · PF · DD | OOS: n · PF · DD |
|---|---|---|
| GBPUSD due lati (R266a) | 1398 · 1,05717 · 21,61 | 1707 · 1,05264 · 13,89 (999 pos.) |
| GBPUSD solo long (R266b) | 739 · 1,08912 · 12,75 | 910 · 1,06044 · 10,87 |
| GBPUSD solo short (R266c) | 818 · 1,04518 · 20,37 | 927 · 1,07472 · 12,70 |
| EURUSD due lati (R266d) | 1384 · 0,99392 · 21,48 | 1614 · 1,03785 · 15,87 |
| EURUSD solo long (R266e) | 766 · 0,87622 · 21,09 | 869 · 1,08896 · 9,82 |
| EURUSD solo short (R266f) | 720 · 1,27939 · 7,16 | 829 · 1,00601 · 13,17 |
GBPUSD OOS per anno (pos., PF): 2020 200/1,107 · 2021 154/0,830 · 2022 200/1,239 · 2023 173/1,013 · 2024 83/1,362 · 2025 126/1,099 · 2026 63/0,690. Mesi con orologio sfasato (inverni 2024/25, 2025/26): 80 pos. PF 0,566; allineati 919 pos. PF 1,115.

**Perche' e' fuori gioco**: merito **H0** (PF < 1,10 in almeno una gamba, n >= 150 in tutte: e' misurato e piatto); rischio **VIOLATO** a qualunque n (DD IS/OOS a 1% di 7-22%: a 2,00% [DERIVATO] 25-43% contro il tetto 8%). Costo: garantito per costruzione (stop minimo 35,24 pip contro il cancello 33,70 pip, 0 posizioni sotto su 999).
**Certificato**: (1) PF SI · (2) n+DD SI · (3) **uscita NO** (gestione = default dell'EA: parziale 50% a 1R, BE, TP2 2,5R, trailing ATR 2,0, EMA200 come target: mai ad asse) · (4) gemelli SI (GBPUSD+EURUSD) · (5) **TF NO** (`InpMgmtTF` 15 fisso). Un H0 di questo round NON e' un certificato di morte: **NON ANCORA MISURATO (mancano 3 e 5)**.
**Gia' provato**: due lati/solo long/solo short su due simboli; geometria P8 (box 00:00-07:59, piazzo 08:00, buffer 30). **Non provato**: `InpBufferPoints` 20 con `InpMinBoxPts` 297 (cella R266g scritta ma mai creata), box 00-06:59 con piazzo 07:00 (la sonda esterna lo da' negativo sull'euro), uscita a tempo, `InpMgmtTF`. Sonda esterna (Oanda, screening): OCO E +0,012 R, t +0,40, n 811 (GBPUSD), lato corto EURUSD +0,033 R su 5/6 anni.

## A4. EMA200 H4 su EURUSD, solo corto (`ABTG_EMA200`) — 🔴 ESCLUSO PER COSTO, ⚪ NON ANCORA MISURATO (`InpSLatr` mai ad asse)
**Cella**: EA `ABTG_EMA200.mq5` · EURUSD · H4 · **OHLC M1** · finestra della scansione `2023.12.31 -> 2026.06.30` (moncone di 1 giorno + OOS 2024.01.01-2026.06.30) · deposito 10.000 · rischio banco 1,00 · round **R265** (G0 + K1 dal lotto) del 28/09, file `prove/R265a_atr_controllo_EMA200_EURUSD_short.txt`; il walk-forward `R265b` (IS 2017-2023, asse `InpOrder2Atr` 0,1..0,4) e' stato SALTATO per costruzione (parte solo con K1 = PASS). Ancora: cella d'archivio Pass 94 (`O1 0,30 · O2 0,5 · TP 1,5`, solo corto).

**Parametri pinnati (R265a)**

```
@SIMBOLO    EURUSD
@PERIODO    H4
@DAQUANDO   2023.12.31
@FINOA      2026.06.30
@FRAZIONEIS 0.001
InpUsaGuardian=1
InpTF=16388
InpEmaPeriod=200
InpEma14Period=14
InpAtrPeriod=14
InpMinDistAtr=0.3
InpMaxDistAtr=1.5
InpUseEma14Bias=1
InpAllowLong=0
InpAllowShort=1
InpUseAdrFilter=0
InpAdrDays=50
InpAdrDistMin=0.0
InpAdrDistMax=0.8
InpUseOrder2=1
InpPendingExpiryBars=6
InpSLatr=1.0
InpMinRR=1.0
InpTP1_ATRmult=0.0
InpTP1Pct=50
InpBreakeven=1
InpUseTrailing=1
InpUseCutoff=0
InpCutoffHour=19
InpCutoffMin=0
InpRiskPercent=1.0
InpMaxTradesPerDay=0
InpUseNewsFilter=0
InpNewsFile=abtg_news.csv
InpNewsMinImpact=3
InpNewsBeforeMin=60
InpNewsAfterMin=30
InpNewsShiftMinutes=0
InpFridayClose=0
InpFridayCloseHour=20
InpMaxSpread=0
InpVerbose=1
InpLogImbuto=1
InpTP_RR=1.5
InpOrder2Atr=0.5
InpOrder1Atr=0.30
```

**Numeri**: scansione d'archivio (genetica, OHLC, finestra unica 2024.01-2026.06, banco NON VERIFICATO; `risultati_archivio/EMA200/H4_OHLC/scan_ABTG_EMA200_H4_EURUSD.csv`): solo corto **26 celle su 26 positive**, PF 1,184-1,565 (mediana 1,3206), DD 3,94-6,48%, 148-216 deal; solo lungo 0 su 28; due lati 24 su 31. Cella ancora Pass 94: PF 1,32379 · n 180 · DD 4,3273. **G0 del banco (R265a, OHLC M1, stessa finestra) ROSSO**: Trades 206 (+26), PF 1,27239 (-0,051), DD 5,1117, Profit 396,42. **K1 (costo, dal lotto del per-trade, 104 posizioni)**: stop mediano della gamba 2 = **23,40-24,40 pip = 35,3-36,8x** il pedaggio all-in 0,6636 pip (spread mediano 0,200 + commissione 0,4636), soglia 40x = **26,54 pip** (al metro della sonda 0,864 pip: 34,56 pip; al P95: 38,54 pip) -> **K1 FAIL**. Altre fonti: EMA200 EURUSD **H1** due lati (R29a, 21 mesi, tick): OOS PF 1,076-1,224, DD 9,05-11,98%, escluso per costo a 20,8x (R140a).
**Perche' e' fuori gioco**: **costo** con `InpSLatr`=1,0 (sotto 40x); il merito non e' giudicato (nessun walk-forward esiste: R140a/b/c dichiarati e non girati).
**Certificato**: (1) PF SI (OHLC) · (2) n+DD SI · (3) **uscita NO: `InpSLatr` (la leva del costo, nominata dalla testa R264 par. 11) MAI ad asse**, `InpTP1Pct` mai ad asse fuori dal Dow · (4) gemelli SI (EMA200 su 5 simboli: zero su cinque fuori dal Dow) · (5) TF SI da archivio (H1 escluso per costo 20,8x; H4 qui). Verdetto: **NON ANCORA MISURATO (manca 3)**.
**Gia' provato**: griglia d'ingresso `InpOrder1Atr` x `InpOrder2Atr` x `InpTP_RR` nella scansione genetica (136 righe). **Non provato**: `InpSLatr` 1,2-1,6 per portare lo stop >= 26,54 pip, poi walk-forward `R265b` sul 2017-2023.

## A5. EMA200 H4 sull'oro (`ABTG_EMA200`) — 🪦 NO PER RISCHIO su 2017-2023 (certificato completo), recente non confrontabile
**Cella**: EA `ABTG_EMA200.mq5` · XAUUSD · H4 · round **R264d** + rilancio **C2** (R264d1-d4) del 28/09 · **OHLC M1**, deposito **100.000** (a 10.000 le gambe stanno a 0,01-0,03 lotti: pavimento del lotto, uscita diversa fra IS e OOS) · IS `2017.01.01 -> 2023.12.31` / OOS `2024.01.01 -> 2026.06.30` · rischio banco 1,00 · G0 col genetico a tick: `prove/R264d_controllo_EMA200_XAUUSD.txt`.

**Parametri pinnati (G0 R264d, cella d'archivio Pass 311: `O1 0,30 · O2 0,4 · TP_RR 2,5`)**

```
@SIMBOLO    XAUUSD
@PERIODO    H4
@DAQUANDO   2023.12.31
@FINOA      2026.06.30
@FRAZIONEIS 0.001
InpUsaGuardian=1
InpTF=16388
InpEmaPeriod=200
InpEma14Period=14
InpAtrPeriod=14
InpMinDistAtr=0.3
InpMaxDistAtr=1.5
InpUseEma14Bias=1
InpAllowLong=1
InpAllowShort=1
InpUseAdrFilter=0
InpAdrDays=50
InpAdrDistMin=0.0
InpAdrDistMax=0.8
InpUseOrder2=1
InpPendingExpiryBars=6
InpSLatr=1.0
InpMinRR=1.0
InpTP1_ATRmult=0.0
InpTP1Pct=50
InpBreakeven=1
InpUseTrailing=1
InpUseCutoff=0
InpCutoffHour=19
InpCutoffMin=0
InpRiskPercent=1.0
InpMaxTradesPerDay=0
InpUseNewsFilter=0
InpNewsFile=abtg_news.csv
InpNewsMinImpact=3
InpNewsBeforeMin=60
InpNewsAfterMin=30
InpNewsShiftMinutes=0
InpFridayClose=0
InpFridayCloseHour=20
InpMaxSpread=0
InpVerbose=1
InpLogImbuto=1
InpTP_RR=2.5
InpOrder2Atr=0.4
InpOrder1Atr=0.30
```

**Griglia C2** (`R264d1-d3`, IS 2017-2023, uno per valore di `InpOrder2Atr`): 
```
@DAQUANDO   2017.01.01
@FRAZIONEIS 0.7371
InpTP_RR=2.0
InpOrder2Atr=0.5
InpOrder1Atr=0.10   # ASSE 0.10..0.31 passo 0.10
```

`R264d2`: `InpOrder2Atr=0.6`; `R264d3`: `InpOrder2Atr=0.7` (0,7 mai misurato prima: il PF del genetico saliva fino a 0,6 = massimo della griglia); asse `InpOrder1Atr` 0,10/0,20/0,30 in tutti; centro dichiarato = O1 0,20 / O2 0,6. Uscita (`R264d4`): 
```
@DAQUANDO   2017.01.01
@FRAZIONEIS 0.7371
InpTP1Pct=50   # ASSE 0..75 passo 25
InpTP_RR=2.0
InpOrder2Atr=0.6
InpOrder1Atr=0.20
```


**Numeri (fonte `report/LETTURA_ROUND_CORTI_C2_2026-09-28.md`; `risultati_archivio/ROUND_CORTI_C2_2026-09-28/`)**
| | IS 2017-2023 | OOS 2024-2026 |
|---|---|---|
| PF, 9 celle su 9 | **0,810-0,836** (nessuna sopra 1) | 1,22-1,65 |
| n deal | 654-880 | 274-397 |
| DD a 1%, cella di mezzo (= anche il picco) | **13,32%** (muro 10%) | 6,02% |
| PF di TUTTA la storia (cella di mezzo, lordi) | **0,993** (-614 EUR su 9,5 anni a 1%) | |
Uscita `InpTP1Pct` 0/25/50/75 sul centro: PF IS 0,798/0,845/0,836/0,826 (n 229/893/777/700, DD 19,35/12,80/13,32/14,03); OOS 1,284/1,568/1,535/1,506 (DD 6,45/5,75/6,02/6,23). G0 a tick sulla finestra del genetico: Trades 292 (+105), PF 1,30881 (-0,072), DD 6,0743 -> **ROSSO** (banco non rifa' l'archivio; causa NON DIMOSTRATA: non e' il lotto, perche' GBPJPY/GBPUSD/AUDJPY sono rossi senza posizioni al lotto minimo). Filtro ADR (R267e2): PF 1,309 -> 1,559, DD 6,07 -> 4,63 (M1, M2 passano) ma banco ROSSO: INDIZIO sospeso. Chiusura del venerdi' (R267f2): PF 1,251 (costo). Stop gamba 2: 12,33-15,42 $ vs soglia K1 10,41 $ (40 x 0,2603): PASS.
**Perche' e' fuori gioco**: **rischio** sull'IS (DD 13,32% a 1% contro il muro 10%: l'OHLC sottostima il DD, quindi sopra il muro boccia); merito IS < 1 su n abbondante. Il recente (2024-26, toro dell'oro) e' buono ma NON CONFRONTABILE (banco rosso). Due spiegazioni non separate: (a) edge solo nel toro 2024-26; (b) storico M1 pre-2024 del PC diverso da quello di oggi.
**Certificato**: (1) PF SI · (2) n+DD SI · (3) uscita SI (`InpTP1Pct`, R264d4) · (4) gemelli SI (R139a AUDJPY H4, R139b GBPUSD H4, per nome) · (5) TF SI (R32a XAUUSD H1, solo finestra recente). **Certificato completo: NO PER RISCHIO, su questo storico.**
**Non provato (dichiarato)**: `InpTP_RR` e `InpSLatr` ad asse sul 2017-23 (nel genetico a 10.000 il TP_RR "mordeva": PF 1,205 a 1,5 contro 1,656 a 3,0, ma probabilmente e' il lotto minimo); G0 col binario del genetico `0953846c` (separa binario / storico tick / specifiche simbolo); rischio 2017-23 a H1; prova per regime dell'IS (PF sotto 1 anche nel toro 2019-2020?).

## A6. EMA200 H4 su GBPJPY, GBPUSD, AUDJPY (`ABTG_EMA200`) — ⚪ NON ANCORA MISURATO (banco ROSSO 4/4, 12 griglie saltate)
**Cella**: EA `ABTG_EMA200.mq5` · H4 · G0 a **tick** sulla finestra del genetico `2024.01.01 -> 2026.06.30`, deposito 10.000, rischio 1,00 · round **R264** (28/09). Il banco NON rifa' l'archivio nello stesso verso su 4 simboli su 4 (n piu' alto di 5-105, PF piu' basso di 0,017-0,091): le 12 griglie IS (`R264a1-a4`, `R264c1-c4`, `R264d1-d4` a OHLC/100.000) sono state SALTATE per il cancello G0; l'unica lettura fatta e' il **ponte AUDJPY** (`R264b1`).

**Parametri pinnati** — base del gruppo = G0 oro (sezione A5); differenze per simbolo:
- GBPJPY (`R264c_controllo_...GBPJPY`, Pass 55): 
```
@SIMBOLO    GBPJPY
InpTP_RR=1.5
InpOrder1Atr=0.10
```

- GBPUSD (`R264a_controllo_...GBPUSD`, Pass 139): 
```
@SIMBOLO    GBPUSD
InpTP_RR=2.0
InpOrder2Atr=0.2
InpOrder1Atr=0.25
```

- AUDJPY (`R264b_controllo_...AUDJPY`, Pass 411): 
```
@SIMBOLO    AUDJPY
InpTP_RR=3.0
InpOrder1Atr=0.05
```


**Numeri (OOS 2024.01-2026.06, tick; fonte `report/LETTURA_ROUND_CORTI_C_2026-09-28.md` sez. 1-2)**
| simbolo | G0 banco: n · PF · DD | archivio genetico: n · PF · DD | stop gamba 2 (K1) |
|---|---|---|---|
| GBPJPY | 242 · 1,22354 · 4,1244 | 221 · 1,24037 · 4,4220 | 66,4-71,1 pip; spread non misurato: K1 solo lettura |
| GBPUSD | 408 · 1,19894 · 8,5287 | 362 · 1,23105 · 7,2048 | 29,2-30,7 pip vs soglia 33,7 (logger) / 29,7 (sonda): K1 NON RISOLTO |
| AUDJPY | 270 · 1,42240 · 6,2755 | 265 · 1,51365 · 6,2606 | 40,3-42,1 pip; spread/comm non misurati: solo lettura |
Ponte AUDJPY a OHLC sulla stessa finestra (R264b1, TP_RR 1,5/2,0/2,5/3,0): PF 1,483/1,426/1,440/1,443 (n 312-322): non confrontabile (G0 rosso). **AUDJPY su campione pieno e' MORTO** (R139a: IS 0,78-0,81, OOS 0,95-1,01, 411-730 pos., DD 15-20%; regola 19/08: nessuna griglia d'ingresso). **GBPUSD**: rischio gia' letto (R139b OOS 2016-2026 DD 10,05-11,05% a 1% => ~19,7-22% a 2,00%). Filtro ADR e chiusura venerdi' su GBPJPY (R267e1/f1): PF 1,167/1,195 contro 1,224 base: il default (spento) va bene.
**Perche' fuori gioco**: **campione/banco** (G0 rosso: OOS non confrontabili; causa NON DIMOSTRATA fra H_BINARIO `3af47ed9`/`344a11b9` vs `0953846c` del genetico, H_STORICO tick, H_SPEC); **merito/rischio** su AUDJPY e GBPUSD a campione pieno.
**Certificato**: (1) PF SI · (2) n+DD SI · (3) uscita: `InpTP1Pct` SALTATO (mai ad asse fuori dal Dow e dall'oro) · (4) gemelli SI · (5) TF SI da scansione H1. **NON ANCORA MISURATO** su GBPJPY (il candidato piu' vicino: DD piu' basso, 4,42%).
**Non provato**: G0 col binario del genetico (`0953846c`) per separare le tre cause; griglie IS 2019-2023 di GBPJPY; `InpTP1Pct` su GBPJPY.

## A7. Short del Dow, sedia 770212 (round R255) (`ABTG_Dow_Apertura_US`) — 🔴 BOCCIATA PER RISCHIO alla cella in firma; 🟡 stH8/stH12 indizi sospesi
**Cella**: EA `ABTG_Dow_Apertura_US.mq5` · U30USD · M5 · **tick reali** `2024.09.26 -> 2026.06.30` (due ere IS/OOS separate al 2025.06.10; orologio BCM UTC+1 fisso) · deposito 10.000 · rischio banco 1,00 · round **R255** del 28/09 (24 job, motore = pin; lettura A alla lettera: 19 file su 24 NULLI per una uscita alla riapertura CME dopo un festivo USA; lettura B con l'emendamento S1 firmato da Claudio il 28/09: G0 tutti verdi), file `prove/R255a_short_DOW_ancora_1430.txt` (+ b..x). Le celle "1430" = ora server 14:30 (apertura cash d'estate), "1530" = 15:30 (apertura cash d'inverno): il round confronta i due orologi "in fase".

**Parametri pinnati (ancora = short della sedia 770212 in firma, 14:30)**

```
@SIMBOLO    U30USD
@PERIODO    M5
@DAQUANDO   2024.09.26
@FINOA      2026.06.30
@FRAZIONEIS 0.001
InpUsaGuardian=true
InpSessionHour=14
InpSessionMin=30
InpRangeMinutes=35
InpCloseHour=17
InpCloseMin=30
InpCloseAtEnd=true
InpOneTradePerDay=true
InpMaxPosSimbolo=0
InpEntryMode=2
InpRangeMode=0
InpLevelTF=16385
InpPrevWindowMin=60
InpBufferPoints=1000.0
InpOCTimeframe=0
InpPendingExpiryMin=120
InpAllowLong=false
InpAllowShort=true
InpMinRangePts=0.0
InpMaxRangePts=0.0
InpRetestOffsetPts=400.0
InpFadeOffsetPts=0.0
InpDelayMinutes=30
InpDelayDirMode=0
InpUseGapFill=false
InpGapMinPoints=150.0
InpGapMinRR=1.5
InpUseEmaFilter=true
InpEmaFast=1
InpEmaSlow=50
InpFilterTF=16388
InpUseSupertrend=false
InpStAtrPeriod=10
InpStMultiplier=2.5
InpStTF=16385
InpUseSupertrend3=false
InpUseCorrelation=false
InpCorrSymbol=SPXUSD
InpCorrTF=16385
InpCorrEmaFast=14
InpCorrEmaSlow=100
InpUseVwapFilter=false
InpVwapTF=15
InpRiskPercent=1.0
InpSLMode=0
InpAtrSlMult=1.5
InpAtrPeriodMgmt=14
InpTP1_R=1.0
InpTP1_ClosePct=50.0
InpBreakevenAtTP1=true
InpBEatR=0.0
InpUseTrailing=true
InpTrailStartR=0.0
InpTrailMode=1
InpTrailTF=5
InpTrailAtrMult=2.0
InpTrailFixedPts=410.0
InpUseRoundLevels=false
InpRoundStep=100.0
InpRoundMinDistPts=50.0
InpUseNewsFilter=false
InpNewsFile=abtg_news.csv
InpNewsMinImpact=3
InpNewsBeforeMin=30
InpNewsAfterMin=30
InpNewsShiftMinutes=0
InpNewsFlatten=true
InpSlippagePts=0.0
InpMinStopPts=500.0
InpSkipIfTight=false
InpUseVolumeFilter=false
InpVolMult=1.5
InpVolAvgBars=20
InpUseAtrFilter=false
InpAtrFilterBars=20
InpAtrFilterMult=1.0
InpConfirmMode=0
InpMaxSpread=0
InpVerbose=true
```

**Differenze delle celle** (un asse ciascuna, tutto il resto = ancora): 1530 (`R255b`): `InpSessionHour=15`, `InpCloseHour=18` · nudo (`R255c`, senza filtro EMA): `InpUseEmaFilter=false` · parz0 (`R255e`): `InpTP1_ClosePct=0.0` · tp05 (`R255g`): `InpTP1_R=0.5` · tp15 (`R255i`): `InpTP1_R=1.5` · trail0 (`R255k`): `InpUseTrailing=false` · stH4/H6/H8/H12/D1 (`R255m/o/q/s/u`): `InpUseEmaFilter=false`, `InpUseSupertrend=true`, `InpStTF`=16388/16390/16392/16396/16408 · `R255w/x` = stesso file col lato long (`InpAllowLong=true`, `InpAllowShort=false`) come riferimento.

**Numeri (fonte `report/LETTURA_R255_2026-09-28_B_EMENDATA.md`, `REGISTRO_TEST.md` sez. R255; archivio `ROUND_R255_SHORT_DOW_INFASE_2026-09-28/`)**
| cella (short) | OOS in fase: n pos. / PF / DD | verdetto |
|---|---|---|
| ancora (= 770212 in firma) | 46 / 0,78 / 5,13-5,31% | 🔴 BOCCIATA PER RISCHIO (R2 > 4,27%; FTMO-DOC PF 0,58/0,51) -> non si schiera |
| nudo · parz0 · tp15 | 46-119 / 0,73-0,87 | 🔴 bocciate per rischio |
| tp05 · stH6 · stD1 | 46 / 0,82 · 41 / 0,90 · 28 / 0,56 | 🟠 rischio non risolto / sospesa |
| **stH8** | 46 / **2,40** / 1,43% | 🟡 SOSPESA, indizio favorevole (n < 150) |
| **stH12** | 39 / 1,26 / 2,54% | 🟡 SOSPESA, indizio favorevole |
| trail0 | — | ⚪ NULLO (R255k) |
Finestra piena dell'ancora (`R255a`, CSV): 146 deal · Profit +308,41 · **PF 1,10790** · DD 8,5112% (Equity, a 1%) · peggior giornata -1,0584%. Uscita alle 16:00 (R267c, `InpCloseHour` 16): 117 deal, PF 1,27809, DD 5,26, ~55 pos. per era: indizio; 17:00: PF 1,20131, DD a saldo chiuso 6,233% > 4,272 (violato). Volumi (`InpVolMult`, R267d) 0,0-2,0: PF 1,108/1,108/1,028/0,995/1,440 su n 146/146/115/57/28 (< 1 salvo la cella a 28 deal). Nota misurata: i file 15:30 perdono quasi tutto nell'estate; l'inverno 15:30 e' in perdita nell'era IS e in guadagno nell'OOS.
**Perche' e' fuori gioco**: **rischio** alla cella in firma (DD OOS 5,13-5,31% a 1% contro R2 4,27%) e **merito** (PF < 1 in fase su ~46 pos.); n < 150 in fase => il merito delle celle buone e' SOSPESO (aritmetica del campione: ~55 posizioni per era).
**Certificato**: (1) PF SI · (2) n+DD SI · (3) uscita SI (parziale, TP1_R, trailing, chiusura oraria: R255 e R267c) · (4) **gemelli NO** (NASUSD/SPXUSD mai provati con questa cella) · (5) **TF NO** (M5 solo; il filtro `InpFilterTF`=H4 e `InpStTF` messi ad asse H4-D1 ma il TF d'ingresso no). Verdetto: **NON ANCORA MISURATO, non morto.** Via piu' corta al numero: stH8/stH12 su una finestra/simbolo che porti n >= 150 (campione, non griglia).
**Gia' provato**: filtro EMA on/off; Supertrend H4-D1; parziale 0/50; TP1_R 0,5/1/1,5; trailing on/off; 14:30 vs 15:30; uscita 16/17:00; filtro volumi 0-2,0. **Non provato (per quanto risulta dal registro)**: `InpRetestOffsetPts` (400) e `InpRangeMinutes` (35) sullo short; simboli gemelli; TF d'ingresso; long+short combinati sulla stessa cella (il long e' la sedia viva).

## A8. Short DAX, specchio del long (`ABTG_DAX_Apertura_EU`, D30EUR) — 🔴 senza merito e DD sopra il muro (R251, R270); motore ⚪ NON ANCORA MISURATO
**Cella**: EA `ABTG_DAX_Apertura_EU.mq5` · D30EUR · M5 · **tick reali** `2024.09.26 -> 2026.06.30` (IS 40% / OOS 60%) · deposito 100.000 (R270; R251 a 10.000) · rischio banco 1,00 · L'orologio d'apertura e' `InpSessionHour=8`: d'inverno arma un'ora prima della cash. Round **R251** (25/09, `report/REFERTO_R251_2026-09-25.md`) e **R270** (28/09, `report/LETTURA_R270_2026-09-28.md`). La cella e' la **cella specchio del long**: entrata a retest (`InpEntryMode=2`), short al posto del long, stessi parametri.

**Parametri pinnati (R251, base short "identico al long" con Supertrend H4 come asse d'esempio; nella cella ancora `InpUseSupertrend=false`)**

```
@SIMBOLO    D30EUR
@PERIODO    M5
@DAQUANDO   2024.09.26
@FINOA      2026.06.30
@FRAZIONEIS 0.4322
InpUsaGuardian=true
InpSessionHour=8
InpSessionMin=0
InpRangeMinutes=35
InpCloseHour=17
InpCloseMin=30
InpCloseAtEnd=true
InpOneTradePerDay=true
InpMaxPosSimbolo=0
InpEntryMode=2
InpRangeMode=0
InpLevelTF=16385
InpPrevWindowMin=60
InpBufferPoints=500.0
InpOCTimeframe=0
InpPendingExpiryMin=120
InpAllowLong=false
InpAllowShort=true
InpMinRangePts=0.0
InpMaxRangePts=0.0
InpRetestOffsetPts=200.0
InpFadeOffsetPts=0.0
InpAllowReverse=false
InpDelayMinutes=30
InpDelayDirMode=0
InpUseGapFill=false
InpGapMinPoints=150.0
InpGapMinRR=1.5
InpUseEmaFilter=false
InpEmaFast=14
InpEmaSlow=200
InpFilterTF=16385
InpUseSupertrend=true
InpStAtrPeriod=10
InpStMultiplier=2.5
InpStTF=16388   # ASSE 16388..16408 passo 1
InpUseSupertrend3=false
InpUseCorrelation=false
InpCorrSymbol=SPXUSD
InpCorrTF=16385
InpCorrEmaFast=14
InpCorrEmaSlow=100
InpUseVwapFilter=false
InpVwapTF=15
InpRiskPercent=1.0
InpSLMode=0
InpAtrSlMult=1.5
InpAtrPeriodMgmt=14
InpTP1_R=1.0
InpTP1_ClosePct=50.0
InpBreakevenAtTP1=true
InpBEatR=0.0
InpUseTrailing=true
InpTrailStartR=0.0
InpTrailMode=1
InpTrailTF=5
InpTrailAtrMult=2.0
InpTrailFixedPts=410.0
InpUseRoundLevels=false
InpRoundStep=100.0
InpRoundMinDistPts=50.0
InpUseNewsFilter=false
InpNewsFile=abtg_news.csv
InpNewsMinImpact=3
InpNewsBeforeMin=30
InpNewsAfterMin=30
InpNewsShiftMinutes=0
InpNewsFlatten=true
InpSlippagePts=0.0
InpMinStopPts=0.0
InpSkipIfTight=true
InpUseVolumeFilter=false
InpVolMult=1.5
InpVolAvgBars=20
InpUseAtrFilter=false
InpAtrFilterBars=20
InpAtrFilterMult=1.0
InpConfirmMode=0
InpSpaceMode=0
InpSpaceTF=16388
InpSpaceMinR=0.0
InpSpaceMaxR=0.0
InpSpaceEma1=14
InpSpaceEma2=50
InpSpaceEma3=100
InpSpaceEma4=200
InpSpaceUseST=false
InpMaxSpread=0
InpVerbose=true
```

**Celle di R251**: ancora = questo blocco con `InpUseSupertrend=false` · `R251b` (`InpTP1_ClosePct` 0/50) · `R251c` (`InpUseTrailing` 0/1) · `R251d` (`InpTP1_R` 0,5/1,0/1,5) · filtro di REGIME: `InpUseSupertrend=true`, `InpStTF` H4/H6/H8/H12/D1 (asse). **R270** (100.000, tick): `R270b` `InpTrailStartR` 0/0,5/1/1,5 e `R270d` `InpTrailMode` 0/1/2 sullo short; `R270c/e` gli stessi assi + `InpTP1_R` sul long (vivo). Blocco di `R270d` (cella viva = R270b input per input; gli input non elencati sono al default dell'EA):

```
@SIMBOLO    D30EUR
@PERIODO    M5
@DAQUANDO   2024.09.26
@FINOA      2026.06.30
@FRAZIONEIS 0.40
InpUsaGuardian=false
InpSessionHour=8
InpSessionMin=0
InpRangeMinutes=35
InpCloseHour=17
InpCloseMin=30
InpCloseAtEnd=true
InpOneTradePerDay=true
InpMaxPosSimbolo=0
InpEntryMode=2
InpRangeMode=0
InpLevelTF=16385
InpPrevWindowMin=60
InpBufferPoints=500
InpOCTimeframe=0
InpPendingExpiryMin=120
InpAllowLong=false
InpAllowShort=true
InpMinRangePts=0
InpMaxRangePts=0
InpRetestOffsetPts=200
InpFadeOffsetPts=0
InpAllowReverse=false
InpDelayMinutes=30
InpDelayDirMode=0
InpUseGapFill=false
InpGapMinPoints=150
InpGapMinRR=1.5
InpUseEmaFilter=false
InpEmaFast=14
InpEmaSlow=200
InpFilterTF=16385
InpUseSupertrend=false
InpStAtrPeriod=10
InpStMultiplier=2.5
InpStTF=16385
InpUseSupertrend3=false
InpUseCorrelation=false
InpCorrSymbol=SPXUSD
InpCorrTF=16385
InpCorrEmaFast=14
InpCorrEmaSlow=100
InpUseVwapFilter=false
InpVwapTF=15
InpRiskPercent=1
InpSLMode=0
InpAtrSlMult=1.5
InpAtrPeriodMgmt=14
InpTP1_R=1
InpTP1_ClosePct=50
InpBreakevenAtTP1=true
InpBEatR=0
InpUseTrailing=true
InpTrailTF=5
InpTrailAtrMult=2
InpTrailFixedPts=410
InpTrailStartR=0
InpUseRoundLevels=false
InpRoundStep=100
InpRoundMinDistPts=50
InpUseNewsFilter=false
InpNewsFile=abtg_news.csv
InpNewsMinImpact=3
InpNewsBeforeMin=30
InpNewsAfterMin=30
InpNewsShiftMinutes=0
InpNewsFlatten=true
InpSlippagePts=0
InpMinStopPts=0
InpSkipIfTight=true
InpUseVolumeFilter=false
InpVolMult=1.5
InpVolAvgBars=20
InpUseAtrFilter=false
InpAtrFilterBars=20
InpAtrFilterMult=1
InpConfirmMode=0
InpSpaceMode=0
InpSpaceTF=16388
InpSpaceMinR=0.0
InpSpaceMaxR=0.0
InpSpaceEma1=14
InpSpaceEma2=50
InpSpaceEma3=100
InpSpaceEma4=200
InpSpaceUseST=false
InpMaxSpread=0
InpVerbose=true
InpTrailMode=1   # ASSE 0..2 passo 1
```

**Numeri**
| cella | IS: n · PF · DD | OOS: n · PF · DD | fonte |
|---|---|---|---|
| R251 ancora (short = long, 10.000, tick) | 152 · 0,846 · DD_fisso 11,19 | 243 · 1,065 · 12,74 | `REFERTO_R251` sez. 2 |
| R251b parziale 0 | 119 · 0,877 · 10,42 | 181 · 1,105 · 13,25 | idem |
| R251c trailing spento | 162 · 0,626 · 24,17 | 269 · 1,124 · 11,59 (peggior giorno -1,1016) | idem |
| R251 ST H4 / H6 / H8 | 65 · 1,358 · 3,56 / 78 · 1,368 · 4,65 / 76 · 1,388 · 4,65 | 118 · 0,954 · 8,79 / 95 · 0,957 · 7,17 / 88 · 1,120 · 6,04 | idem |
| **R251 ST H12** | 61 · 1,214 · 3,62 | 126 · **1,771** · 4,95 | idem: indizio, isolato (unica che passa M1-M3) |
| R251 ST D1 | 41 · 0,763 · 4,95 | 126 · 1,418 · 7,85 | idem |
| R270d vivo (mode 1, 100.000) | 138 · 0,965 · 7,47 | 257 · **0,957** · **12,31** | `LETTURA_R270` sez. 3 |
| R270b TrailStartR 0,5 / 1,0 / 1,5 | 161 · 0,839 · 10,42 / 148 · 0,771 · 14,58 / 148 · 0,761 · 15,02 | 307 · 0,930 · 14,10 / 285 · 1,061 · 10,00 / 285 · 1,072 · 10,53 | idem (ribaltamento IS/OOS = rumore) |
| R270d mode 0 ATR / mode 2 FIXED 410 | 163 · 0,757 · 12,45 / 108 · 0,650 · 7,15 | 317 · 1,040 · 11,41 / 199 · 0,734 · 8,83 | idem |
**Perche' e' fuori gioco**: **rischio** (DD OOS 12,31% a 1% con R1 = 9,00%: violato a qualunque n; a 2,00% ordine ~24%, limite superiore) e **merito** (PF 0,957-0,965 con n oltre 150). Nessuna manopola d'uscita lo ripara: la soglia d'armo alta porta l'OOS a 1,06-1,07 ma affonda l'IS a 0,76-0,77 con DD 14,6-15,0%. Il filtro di regime H12 passa M1-M3 ma isolato (le vicine no): "non c'e' una configurazione robusta"; H6/H8 hanno DD minore solo per minore esposizione.
**Certificato**: (1) PF SI · (2) n+DD SI · (3) uscita SI (R251 + R270: parziale, TP1_R, trailing on/off, TrailMode, TrailStartR) · (4) gemelli: Dow/Nasdaq solo sull'interruttore, **F40EUR/E50EUR mai** · (5) **TF NO** (M5 solo; la discesa/salita di TF non compra niente: il setup e' ancorato al calendario, r.1007-1020 e r.679 del sorgente). **Motore NON ANCORA MISURATO; la SEDIA a questa cella e' BOCCIATA PER RISCHIO.**
**Gia' provato**: vedi celle sopra. Sonda esterna GRXEUR 2011-2018 (seconda caccia, screening): ITSM ultima mezz'ora corto t -3,26 (e sotto costo, stop 30x); fade gap-up -0,018 R; apertura USA inversione/continuazione ~0; 10:00 NY corto -0,010 R; cono di rumore solo corto -0,028 R; **sequenza di inversione monotona**: SHORT positivo in 6 combinazioni su 6, LONG negativo 6 su 6 (H1 N=3 SHORT +0,057 R, n 251, 52x lo spread) — non ancora girata su BCM.

## A9. Gap continuation DAX, solo short (`ABTG_GapContinuation`, D30EUR) — ⚪ NON ANCORA MISURATO (merito sospeso: 29 posizioni in 21 mesi)
**Cella**: EA `ABTG_GapContinuation.mq5` · D30EUR · M5 · **tick reali** `2024.09.26 -> 2026.06.30` (orologio in fase) · rischio banco 1,00 · round **R253** del 25/09 (2 min, catena verde), file `prove/R253a_gapcont_DAX_short_ora8.txt` (+ `R253b` ora 9). Meccanismo: gap-down della cash >= 0,50% alla riapertura, rottura del minimo del range di 15 minuti, uscita 40% a 1R, finale 2R, stop con buffer.

**Parametri pinnati (R253a, ora 8)**

```
@SIMBOLO    D30EUR
@PERIODO    M5
@DAQUANDO   2024.09.26
@FINOA      2026.06.30
@FRAZIONEIS 0.001
InpUsaGuardian=true
InpSessionTimeMode=1
InpSessionOpenHour=8
InpSessionOpenMinute=0
InpSessionCloseHour=16
InpSessionCloseMinute=30
InpOpeningRangeMinutes=15
InpMaxEntryMinutesFromOpen=90
InpExitMinutesBeforeClose=5
InpEnableBuyGaps=false
InpMinimumBuyGapPercent=0.50
InpEnableSellGaps=true
InpMinimumSellGapPercent=0.50
InpUseRealVolumeIfAvailable=true
InpMaxSpreadPoints=0.0
InpMaxSpreadToStopPercent=10.0
InpStopBufferPoints=1500.0
InpBuyRiskPercent=1.0
InpSellRiskPercent=1.0
InpReduceRiskOnSmallSellGap=false
InpSellFullRiskFromGapPct=1.25
InpSmallSellRiskPercent=0.25
InpFixedLots=0.0
InpMaxLots=0.0
InpPartialClosePercent=40.0
InpPartialTargetR=1.0
InpFinalTargetR=2.0
InpMoveStopToBreakEven=true
InpMaxSlippagePoints=30
InpShowStatusOnChart=false
InpPrintDailyDiagnostics=false
InpLogImbuto=true
```

**Differenza R253b (ora 9)**: 
```
InpSessionOpenHour=9
InpSessionCloseHour=17
```

**Numeri** (`report/REFERTO_R253_2026-09-25.md`, archivio `risultati_archivio/R253/`): curva in fase **29 posizioni** in 21 mesi, PF 0,898, EP -0,041 R, DD chiuso 5,63% (R1 <= 6,5 non violato su n 29), peggior giorno -0,98%, serie perdente 3; K1 stop mediano 116 punti = 68x lo spread (AMMESSO); sovrapposizione con la sedia MaxMinNotte short DAX 17%. Sonda esterna GRXEUR M1 2011-2018 (screening): gap-down >= 0,50% **+0,185 R, t 2,12, 6 anni su 8 positivi, DD 6,5 R, n 175**; gap-down >= 0,25% +0,110 R t 1,80; contro-esempi: lungo speculare senza informazione, EuroStoxx concorde t 1,51, S&P no (t 0,49). Fonte esterna: arXiv 2605.04004 (Mesfin, MNQ 2021-2025): gap continuation short netto +14,52 pti, T 1,46, 35 op. OOS, 2024 negativo.
**Perche' e' fuori gioco**: merito **SOSPESO per aritmetica** (0,09 posizioni/seduta: 150 posizioni richiederebbero ~1.700 sedute); segno DISCORDE con la sonda esterna ma dentro l'attesa di un regime toro.
**Certificato**: (1) PF SI (0,898 su n 29: non decide) · (2) n+DD SI · (3) **uscita NO** (parziale 40%/1R/2R/BE mai ad asse) · (4) **gemelli NO** (E50EUR, F40EUR) · (5) **TF: NON APPLICABILE** (nessun `ENUM_TIMEFRAMES` ne' `iATR` nel sorgente). **NON ANCORA MISURATO.**
**Gia' provato**: ora 8 vs 9. **Non provato**: uscita, range 5/10/15 minuti, soglie di gap 0,25/0,75%, gemelli europei. Difetto di strumento trovato: `ABTG_DAX_Apertura_EU` con `InpEntryMode=1` (GAPFILL) misura il gap sulle barre D1 del CFD (`iClose(D1,1)`/`iOpen(D1,0)`, r.2013-2014), non il gap della cash: in FASE B 7 e 9 operazioni.

## A10. Oro, MaxMinNotte solo long (col trend dell'oro, R260d) e varianti (`ABTG_MaxMinNotte`, XAUUSD) — 🔴 RISCHIO VIOLATO a qualunque n; 🟡 indizi sospesi
**Cella**: EA `ABTG_MaxMinNotte.mq5` · XAUUSD · TF grafico H2 (`InpMgmtTF`=H2) · **OHLC M1** `2019.12.30 -> 2026.06.30` (finestra unica, moncone di 1 giorno) · deposito 100.000 · rischio banco **0,50** · round **R260** (27/09, ROUND CORTI B), **R260d** (28/09, ROUND CORTI C), **R268/R269** (28/09, ROUND CORTI D). Il motore a due lati e' una sedia viva a FTMO; qui si giudica il LONG da solo, con e senza filtro di trend, e alcune leve.

**Parametri pinnati (R260d: solo long, filtro di trend = chiusura H4 dell'oro sopra la sua EMA200 H4)**

```
@SIMBOLO    XAUUSD
@PERIODO    H2
@DAQUANDO   2019.12.30
@FINOA      2026.06.30
@FRAZIONEIS 0.0005
InpUsaGuardian=true
InpBoxStartHour=23
InpBoxStartMin=0
InpBoxEndHour=4
InpBoxEndMin=59
InpMinBoxPts=0
InpMaxBoxPts=0
InpPlaceHour=7
InpPlaceMin=0
InpEntryCutoffHour=8
InpEntryCutoffMin=30
InpCloseHour=17
InpCloseMin=30
InpCloseAtEnd=true
InpOneTradePerDay=true
InpPendingExpiryMin=90
InpBufferPoints=250
InpAllowLong=true
InpAllowShort=false
InpSLMode=0
InpMgmtTF=16386
InpAtrPeriod=14
InpAtrSLmult=1.5
InpSLFixedPts=3000
InpTP1_R=1.0
InpTP1Pct=50
InpBreakeven=true
InpTP2_R=2.5
InpTP2Pct=50
InpUseEMA200Target=true
InpEMA200Period=200
InpTPfinal_R=4.0
InpUseTrailing=true
InpTrailAtrMult=2.0
InpUseCorrelation=true
InpCorrSymbol=XAUUSD
InpCorrTF=16388
InpCorrEmaFast=1
InpCorrEmaSlow=200
InpRiskPercent=0.5
InpUseNewsFilter=false
InpNewsFile=abtg_news.csv
InpNewsMinImpact=3
InpNewsBeforeMin=30
InpNewsAfterMin=30
InpNewsShiftMinutes=0
InpNewsFlatten=true
InpMaxSpread=0
InpVerbose=true
InpAutoTest=true
```

**Differenze**: R260a (solo long, senza filtro): 
```
InpUseCorrelation=false
InpCorrSymbol=SPXUSD
InpCorrTF=16385
InpCorrEmaFast=14
InpCorrEmaSlow=100
```
 · R260b (solo short): `InpAllowLong=false`, `InpAllowShort=true` · R260c (due lati, ancora): `InpAllowShort=true` · R268a (tick, `2024.07.05->2026.06.30`): 
```
@DAQUANDO   2024.07.05
@FRAZIONEIS 0.001
```
 · R269a (long, flat 13:00): 
```
InpCloseHour=13
InpCloseMin=0
```
 · R267b: `InpMinBoxPts` 0/650/1300/1950/2600 (base R260c) · R268c: `InpRiskPercent` 0,5/1,0/1,5/2,0.

**Numeri (fonti: `report/LETTURA_ROUND_CORTI_C_2026-09-28.md` sez. 6-7, `LETTURA_ROUND_CORTI_D_2026-09-28.md`, `REGISTRO_TEST.md` "VERDETTI ROUND CORTI B"; OHLC salvo dove scritto; DD = Equity DD % a 0,5%)**
| cella | n deal / pos. | PF | DD @0,5% | nota |
|---|---|---|---|---|
| due lati (R260c, G0 = R103 alla cifra) | 693 / 511 | 1,30771 | 5,3158 | anni negativi 2021, 2023 |
| solo long (R260a) | 375 / 279 | 1,336 (CSV 1,33476) | 4,5172 | meta' 1,171 / 1,521 |
| solo short (R260b) | 318 / 232 | 1,255 | 4,0755 | |
| **solo long col trend (R260d)** | **238 / 171** | **1,55682** | **3,3848** | TENUTE 171 pos. PF 1,558 · RIMOSSE 108 pos. PF 1,051: "il cancello TAGLIA, non separa" |
| long, flat 13:00 (R269a) | 306 / 279 | 1,302 | 3,9086 | timestop 242 pos. PF 1,700; 15 stop pieni -7456 EUR |
| long a **tick** (R268a, 2024.07-2026.06) | 118 / 93 | 1,45273 | 2,3434 (misto tick/M1) | r = DD_tick/DD_OHLC = 1,007 |
| long 22 anni (R268d, OHLC 2004.06-2026.06) | 950 / 725 | 1,09604 | **10,3027** | contratto 10,0% (altra config.) -> D3 |
| curva DD(taglia) a tick (R268c) | 118 x4 | — | 0,5: 2,3434 · 1,0: 4,7464 · 1,5: 7,1353 · 2,0: 9,4253 | |
| box minimo `InpMinBoxPts` 650/1300/1950/2600 (R267b) | 508/199/124/98 | 1,368/1,926/1,670/1,916 | 3,03/2,00/2,69/1,76 | 🟡 indizio, n < 203; picco a 1300, nessun altopiano |
**Perche' e' fuori gioco**: **rischio** (R260d: DD 3,38% a 0,5% contro il tetto 2,00-2,06% = S3 tradotta; a 2,00% 12,87-13,54% [DERIVATO]); sui 22 anni il solo long a 0,5% fa gia' 10,30% (D3). Merito: 171 pos. (>= 150 per R260d ma la meta' 2020-23 e 2023-26 dice PF 1,77/1,42); il filtro di trend e' un cancello che TAGLIA (rimosse PF 1,051, non < 0,90). Prior CONTRARIO della sonda esterna: long concorde col trend D1 E -0,031 (PF 0,89, n 97), contro-trend +0,179 (PF 1,88, n 54) — **il round decide, e ha detto: taglia, non separa**.
**Certificato del solo-long**: (1) PF SI · (2) n+DD SI · (3) uscita: SI parziale (flat 13:00, R269), timestop; **trailing/parziale/BE MAI ad asse sul solo-long** · (4) gemelli: `ABTG_MaxMinNotte` su DAX (A11) e forex (A3) · (5) TF: `InpMgmtTF` NON ad asse sull'oro. Stato: **RISCHIO VIOLATO, nessuna taglia; NON promosso, NON archiviato come morto**.
**Non provato**: `InpNewsFlatten` con calendario funzionante (l'EA apre il file news senza FILE_COMMON: `LoadNews` stampa "file news non trovato" e le due celle escono identiche: stesso difetto gia' pagato su PostNews e FiboH4; **R267a NON LANCIARE**); `InpBufferPoints` (stop in ATR sull'oro gia' caduto a buffer 200); trailing/BE/parziale solo-long; taglia (firma di Claudio); tick reali con storia oro oltre 2024.07.10.

## A11. MaxMinNotte su D30EUR, long e short (`ABTG_MaxMinNotte`) — 🔴 long 0/41 celle >= 1,00 a tick; 🟠 short merito sospeso (< 150 pos.); ⚪ NON ANCORA MISURATO
**Cella**: EA `ABTG_MaxMinNotte.mq5` · D30EUR · M15 · **tick reali** `2024.09.26 -> 2026.06.30` (tranche unica, `@FRAZIONEIS 1.0`) · rischio banco 0,65 (R242/R244) o 1,00 (R261) · round **R242** (24/09, box del giorno precedente), **R244** (24/09, tasso di riempimento del cutoff), **R261** (27/09, lato long: correlazione S&P, `InpMgmtTF`, ancore), **R267g** (28/09, trend e uscite del long filtrato).

**Parametri pinnati (R261a: DAX long a lati invertiti rispetto alla sedia short, filtro S&P come asse)**

```
@SIMBOLO    D30EUR
@PERIODO    M15
@DAQUANDO   2024.09.26
@FINOA      2026.06.30
@FRAZIONEIS 1.0
InpUsaGuardian=true
InpBoxStartHour=23
InpBoxStartMin=0
InpBoxEndHour=4
InpBoxEndMin=59
InpMinBoxPts=0
InpMaxBoxPts=0
InpPlaceHour=7
InpPlaceMin=59
InpEntryCutoffHour=8
InpEntryCutoffMin=30
InpCloseHour=17
InpCloseMin=30
InpCloseAtEnd=true
InpOneTradePerDay=true
InpPendingExpiryMin=90
InpBufferPoints=1000
InpAllowLong=true
InpAllowShort=false
InpSLMode=1
InpMgmtTF=15
InpAtrPeriod=14
InpAtrSLmult=2.5
InpSLFixedPts=3000
InpTP1_R=1.0
InpTP1Pct=50
InpBreakeven=true
InpTP2_R=3.0
InpTP2Pct=50
InpUseEMA200Target=true
InpEMA200Period=200
InpTPfinal_R=4.0
InpUseTrailing=true
InpTrailAtrMult=2.0
InpUseCorrelation=0   # ASSE 0..1 passo 1
InpCorrSymbol=SPXUSD
InpCorrTF=16385
InpCorrEmaFast=14
InpCorrEmaSlow=100
InpRiskPercent=1.0
InpUseNewsFilter=false
InpNewsFile=abtg_news.csv
InpNewsMinImpact=3
InpNewsBeforeMin=30
InpNewsAfterMin=30
InpNewsShiftMinutes=0
InpNewsFlatten=true
InpMaxSpread=0
InpVerbose=true
InpAutoTest=true
```

**Differenze**: R242a (box del giorno precedente, LONG; asse `InpBoxStartHour` 0-18 passo 3): 
```
@SIMBOLO  D30EUR
@PERIODO  M15
@DAQUANDO 2024.09.26
@FINOA    2026.06.30
InpBoxStartHour=0   # ASSE 0..18 passo 3
InpBoxEndHour=0
InpBoxEndMin=0
InpMinBoxPts=6800
InpEntryCutoffHour=12
InpEntryCutoffMin=0
InpPendingExpiryMin=250
InpSLMode=0
InpUseCorrelation=false
InpRiskPercent=0.65
```

R244b (LONG, asse `InpEntryCutoffHour` 9-17): 
```
@SIMBOLO  D30EUR
@PERIODO  M15
@DAQUANDO 2024.09.26
@FINOA    2026.06.30
InpBoxStartHour=6
InpBoxEndHour=0
InpBoxEndMin=0
InpMinBoxPts=6800
InpEntryCutoffHour=12   # ASSE 9..17 passo 1
InpEntryCutoffMin=0
InpPendingExpiryMin=600
InpSLMode=0
InpUseCorrelation=false
InpRiskPercent=0.65
```

R244a (SHORT, stesso asse) = R244b con `InpAllowLong=false`, `InpAllowShort=true`; R242b (SHORT) = R242a con lati invertiti; R261c (ancora G0 = R244b C=12): `InpBoxStartHour=6 · InpBoxEndHour=0 · InpMinBoxPts=6800 · InpEntryCutoffHour=12 · InpPendingExpiryMin=600 · InpSLMode=0 · InpUseCorrelation=false · InpRiskPercent=0.65`; R261b: asse `InpMgmtTF` 15..16388 con filtro acceso; R267g1: `InpCorrSymbol=D30EUR`, `InpCorrTF` H4/H6/H8/H12/D1 (asse); R267g2/g3/g4: `InpUseTrailing`, `InpBreakeven`, `InpTP1Pct` (0/25/50/75) sul long con filtro.

**Numeri (tick; fonti `report/REFERTO_R242/R244_2026-09-24.md`, `REGISTRO_TEST.md` "VERDETTI ROUND CORTI B", `LETTURA_ROUND_CORTI_C` sez. 7.3)**
| cella | n | PF | DD | verdetto |
|---|---|---|---|---|
| R242 LONG (box giorno prec., H 0-18) | 134-188 deal | 0,732-**0,941** | 4,14-6,34% @0,65% | 0 celle > 1,00: merito LEGGIBILE e negativo |
| R242 SHORT | 96-130 | 1,019-1,469 | 1,43-5,63% @0,65% | run contigua 2 celle invece di 3, 7/7 sotto n 150 |
| R244b C=12 (LONG) = R261c | 157 | **0,74387** | 5,6463 | ancora G0 verde |
| R244 SHORT (max) | ~105 pos. (C=17) | PF marginale 12->17 = 0,588 su 48 deal | 1,3-2,4% | indizio WHIPSAW: i riempimenti tardivi perdono |
| R261a corr=0 (long, 1%) | 147 deal | 0,90464 | 7,92 | |
| R261a corr=1 (filtro S&P) | 103 deal / 72 pos. | **0,883** | 7,82 | merito sospeso, nessun indizio |
| R261b `InpMgmtTF` M15..H4 | 72 pos. costanti | 0,883/0,869/0,705/0,823/0,761/0,724/0,721 | | nessuna cella >= 1,00 |
| R267g1 trend `InpCorrTF` H4/H6/H8/H12/D1 (long) | 108/109/114/116/128 | 1,062/1,040/**0,957**/0,871/0,834 | 5,75/5,75/6,76/8,32/8,96 | centro H8 0,957: il filtro non salva il long |
| R267g2/g3/g4 trailing 0/1 · BE 0/1 · TP1Pct 0/25/50/75 (long filtrato) | 72-107 | 0,999/0,883 · 0,841/0,883 · 0,679/0,821/0,883/0,944 | 7,87/7,82 · 8,34/7,82 · 12,30/9,19/7,82/6,77 | il default va bene |
**Perche' e' fuori gioco**: long — **merito misurato e negativo** (0 su 41 celle distinte a tick >= 1,00; le 9 di R244b sono UNA famiglia nidificata sul cutoff) con rischio letto fuori da S3 a 2,00%; short — **campione** (nessuna cella arriva a 150 posizioni) e le celle sopra soglia lo sono su una soglia alzata a 1,38 apposta per escludere il pedaggio; ogni cella sta sotto il 10% DD. Il pedaggio non spiega il negativo del long (stop allargato 7 volte, PF +0,002 contro +0,057 previsto).
**Certificato long**: (1) PF SI · (2) n+DD SI · (3) uscita: R267g2-g4 (trailing/BE/parziale) SI · (4) gemelli: **con filtro acceso F40EUR/E50EUR MAI** (a filtro spento SI, OHLC: E50EUR 0/54, F40EUR best 0,9985, 100GBP 0/54) · (5) TF SI (R261b `InpMgmtTF`). Stato: **NON ANCORA MISURATO (manca 4)**. **Certificato short**: manca il TF (mai cambiato: M15 ovunque), `InpPlaceHour`, gli altri simboli. Il TF che conta e' `InpMgmtTF`, non il grafico.
**Non provato**: `InpPlaceHour` come asse; short su E50EUR/F40EUR; MaxMinNotte su NASUSD (R187: mai girato, casella libera); riempimento tramite `InpOneTradePerDay` (il tetto di 1 al giorno: lo short riempie il 22-30% delle giornate). Limite: nessun allargamento sugli ingressi del long (PF < 1,10 ovunque).

## A12. Dow breakout a due lati, candidato #1 (`ABTG_Nasdaq_Apertura_US` su U30USD) — 🔴 rischio sopra banda (R248) e muro DD a 2% fra 1,25 e 1,50% (R263); ⏳ NON schierabile
**Cella**: EA `ABTG_Nasdaq_Apertura_US.mq5` (l'archivio del candidato l'ha prodotto lo script del Dow: il nome dell'EA e' questo) · U30USD · M5 · **tick reali** `2024.09.26 -> 2026.06.30` (IS 43,22%) · banco 10.000, rischio 1,00 · round **R245** (24/09: bordo di `InpEmaSlow` 140-260 x 4 TP), **R247** (per-trade), **R248** (25/09: finestra vergine 01/07-18/09/2026), **R262/R263** (27/09: dove si chiude a destra l'altopiano; DD misurato a 2%), **R250** (orologio). Ingresso al breakout (`InpEntryMode=0`) del range 14:30-14:45, filtro EMA H4, trailing fisso.

**Parametri pinnati (R245b, cella centrale TP1_R 0,50; asse `InpEmaSlow` 140..260)**

```
@SIMBOLO  U30USD
@PERIODO  M5
@DAQUANDO 2024.09.26
@FINOA    2026.06.30
@FRAZIONEIS 0.4322
InpTP1_R=0.50
InpSessionHour=14
InpSessionMin=30
InpRangeMinutes=15
InpCloseHour=17
InpCloseMin=30
InpCloseAtEnd=1
InpOneTradePerDay=1
InpEntryMode=0
InpRangeMode=0
InpLevelTF=16385
InpPrevWindowMin=60
InpBufferPoints=200
InpPendingExpiryMin=120
InpAllowLong=1
InpAllowShort=1
InpMinRangePts=0
InpMaxRangePts=0
InpRetestOffsetPts=0
InpFadeOffsetPts=0
InpDelayMinutes=30
InpDelayDirMode=0
InpUseGapFill=0
InpGapMinPoints=150
InpGapMinRR=1.5
InpUseEmaFilter=1
InpEmaFast=1
InpFilterTF=16388
InpUseSupertrend=0
InpStAtrPeriod=10
InpStMultiplier=2.5
InpStTF=16385
InpUseSupertrend3=0
InpUseCorrelation=0
InpCorrSymbol=SPXUSD
InpCorrTF=16385
InpCorrEmaFast=14
InpCorrEmaSlow=100
InpUseVwapFilter=0
InpVwapTF=15
InpRiskPercent=1
InpSLMode=0
InpAtrSlMult=1.5
InpAtrPeriodMgmt=14
InpTP1_ClosePct=0
InpBreakevenAtTP1=0
InpBEatR=0
InpUseTrailing=1
InpTrailMode=1
InpTrailTF=5
InpTrailAtrMult=2
InpTrailFixedPts=12532
InpUseRoundLevels=0
InpRoundStep=100
InpRoundMinDistPts=50
InpUseNewsFilter=0
InpNewsFile=abtg_news.csv
InpNewsMinImpact=3
InpNewsBeforeMin=30
InpNewsAfterMin=30
InpNewsShiftMinutes=0
InpNewsFlatten=1
InpSlippagePts=0
InpMinStopPts=500
InpSkipIfTight=0
InpUseVolumeFilter=0
InpVolMult=1.5
InpVolAvgBars=20
InpUseAtrFilter=0
InpAtrFilterBars=20
InpAtrFilterMult=1
InpConfirmMode=1
InpMaxSpread=0
InpVerbose=1
InpUsaGuardian=0
InpMaxPosSimbolo=0
InpOCTimeframe=0
InpTrailStartR=0
InpRunnerTP_R=0
InpMinBreakoutRangeATR=0
InpUseVolRegime=0
InpVolAtrPeriod=14
InpVolLookback=100
InpVolLowPct=20
InpVolHighPct=80
InpVolLowOffMult=0.7
InpVolHighOffMult=1.5
InpVolLowSlMult=0.75
InpVolHighSlMult=1.5
InpVolHighSizeMult=0.5
InpUseSRFilter=0
InpSRProximityPts=1500
InpSRUsePrevDay=1
InpSRUseRoundNumbers=1
InpSRRoundInterval=10000
InpEmaSlow=200   # ASSE 140..260 passo 20
```

**Differenze**: R262b (`InpEmaSlow` 160..320 passo 20): asse esteso a destra; R263g: `InpEmaSlow=200`, `InpRiskPercent` 1,00..2,00 passo 0,25 (banco 100.000, tick); R248a (finestra vergine): `@DAQUANDO 2025.07.01`, `@FINOA 2026.09.19`, `@FRAZIONEIS 0.819`, `InpEmaSlow=200`. TP1_R 0,33/0,50/0,67/0,84 = i quattro file (R245a-d; R262a-d; R263a-d).

**Numeri (fonti `report/REFERTO_R245/R247/R248_2026-09-2x.md`, `REGISTRO_TEST.md`)**
| misura | risultato |
|---|---|
| R245 centro (EmaSlow 200, TP 0,50), 1% | IS PF **1,252** n 154 DD 7,10% · OOS PF **1,489** n 197 DD 6,86% (G0 giallo: n identico, PF/DD in deriva di lotto; 140 cade su n IS 147) |
| R247 per-trade | DD saldo chiuso IS 6,38% / OOS 5,94% a 1%; peggior giornata -1,1/-1,2%; sovrapposizione con la sedia Dow long 96% dei giorni, stesso verso 91/92, rho 0,16/0,25: PARZIALE (non diversifica) |
| **R248 finestra vergine (01/07-18/09/2026)** | 39 pos. (banda 34-47), **DD saldo chiuso 8,38%** fra p95 (7,31%) e p99 (9,30%): 🔴 RISCHIO SOPRA BANDA -> "revisione PRIMA di qualunque schieramento" |
| R262 (EmaSlow 160-320) | 48/48 G0 verde; 160-280 passa, 300/320 no; blocco 160-280 -> **centro 220**; +0,0023 contro 200: "il 200 va bene" (regola, non merito) |
| **R263 DD a 2% misurato** | **0/48 celle sotto il muro 10% a 2%**; curva IS 7,31/9,10/10,85/12,56/14,22 · OOS 7,01/8,73/10,43/12,15/13,81 (a 1,00..2,00%); muro fra **1,25 e 1,50%**; R263e/f saldo chiuso 13,31% IS / 11,88% OOS a 2% |
| stagione | estate PF 0,982 n 199 · inverno 1,800 n 152 (`IL_MERITO_E_D_INVERNO`) |
| costo | stop mediano 123,75 idx = **41,25x** a spread 3,00; **212 giornate su 446 (47,5%) sotto 40x**: AL PELO |
**Perche' e' fuori gioco (sospeso)**: **rischio** (a 2% il DD supera il 10% in 48/48 celle; la taglia sostenibile e' 1,25-1,50% = firma di Claudio) e **finestra vergine** con DD sopra il p95 della promessa; costo al pelo; lo stesso motore ha un merito che in inverno e in estate diverge (orologio: un'ora fissa 14:30 in inverno arma prima della cash).
**Certificato**: (1) PF SI · (2) n+DD SI · (3) uscita: `InpTP1_R` (4 valori) SI; `InpTrailMode`, `InpTrailFixedPts` (12532) NON ad asse su questo candidato · (4) gemelli: NASUSD/SPXUSD/DAX su questo motore con EMA H4: **[NON MISURATO su questa cella]** · (5) TF: M5 fisso. **NON ANCORA MISURATO, non archiviato.**
**Gia' provato**: `InpEmaSlow` 140-320, TP1_R 0,33-0,84, retest vs breakout (R197A), `InpRetestOffsetPts` 0..600 (R197B/R198), taglia 1,00-2,00%. **Non provato**: `InpTrailMode`/`InpTrailFixedPts`, `InpMinStopPts` 500 come pavimento, `InpSessionHour` in fase con l'orologio (R250 in parte: due celle su sei nulle per un'uscita fuori orario dopo due festivi USA).

## A13. Gap cash Nasdaq (`ABTG_SondaGapCash`, NASUSD) — 🔴 SCARTO al passo 0: il fenomeno c'e', il segno e' rovesciato sui tick BCM
**Cella**: sonda `ABTG_SondaGapCash.mq5` (un CONTATORE: niente ordini, lotti o magic) · NASUSD · M5 · **tick reali** (166.509.474 tick misurati dal 2024.09.26) · `2024.09.26 -> 2026.06.30` · corsa del 07/09/2026, file `prove/GAPCASH_NAS_PASSO0.txt`. Ipotesi (Yu, Rentzler & Wolf, J. Inv. Mgmt.; Nagel, RFS 2012): quando la sessione cash apre sotto la chiusura precedente di almeno 0,50%, i primi 15 minuti rimbalzano. **[LETTO-VIA-SEARCH: gli abstract non sono stati aperti].**

**Parametri pinnati (come da file; la corsa di CONTROLLO gira con `InpGateSpento=true`)**

```
@SIMBOLO  NASUSD
@PERIODO  M5
@DAQUANDO 2024.09.26
InpSogliaGapPct=-0.50   # ASSE -1.00..-0.30 passo 0.10
InpOraAperturaServer=14
InpMinAperturaServer=30
InpMinutiUscita=15
InpLato=0
InpGateSpento=false
InpMisuraSpreadCampana=true
InpVerbose=true
InpAutoTest=true
```

**Numeri** (`backtest_pipeline/risultati_archivio/REFERTO_GAPCASH_PASSO0_2026-09-07.md`, CSV `gapcash_passo0_csv/`):
| criterio | esito | numero |
|---|---|---|
| P0-1 frequenza | PASSA | **77 giornate-evento** (cancello 25; attese ~62) |
| P0-2 separazione | **SCARTO** | evento **-0,0487%** contro controllo **-0,0134%** (dato esterno HistData, 2.568 giornate: +0,0988% / +0,0112%: segno invertito su entrambe le colonne) |
| P0-3 costo | SCARTO | take mediano -8,0 contro spread campana 1,8 |
| P0-5 due lati | frequenza passa, separazione SCARTO anche sullo short | |
| monotonia sulla soglia | 4 rotture su 7 (sull'esterno cresceva monotona 0,060 -> 0,190) | "il gate non e' una manopola pulita su questo feed" |
La misura si e' auto-verificata (gate spento: 446 contro 446 giornate; controllo misurato due volte: -0,0134% e -0,0134%; gemelli identici). Trappola aritmetica evitata: rapporto 3,64x ma entrambi negativi.
**Perche' e' fuori gioco**: **merito/edge** (segno rovesciato), non campione e non costo. **Certificato**: e' una SONDA di conteggio, non un EA con PF: (1)-(2) misure di segno e frequenza SI · (3) uscita: N/A (nessun trade) · (4) gemelli: **NO** (solo NASUSD; la sonda e' riusabile su altri simboli) · (5) TF: M5 solo. Stato: **SCARTATO al passo 0 con certificato PARZIALE**; il verdetto "il meccanismo non esiste sul feed BCM" poggia su UN simbolo e UN TF. Il P0-7 (collisione con una sedia short Nasdaq alle 14:30) resta agli atti non sciolto.
**Non provato**: gap cash su SPXUSD/D30EUR/U30USD con la stessa sonda; `InpSogliaGapPct` diverso da -0,50 (asse -1,00..-0,30 nel file ma la decisione e' sulla cella -0,50 e sulla monotonia); gap-UP con `InpLato`; uscita diversa da 15 minuti.

## A14. R118 — il pavimento dello stop sotto slippage (`ABTG_ORB_Ottimizzato` U30USD, `ABTG_DAX_Apertura_EU` D30EUR) — 🔴 nessuna cella promossa
**Cella**: tre corse, **tick reali** `2024.09.26 -> ...`, deposito 100.000, rischio banco 1,00, round **R118** del 07/09 (170 passate, `backtest_pipeline/risultati_archivio/REFERTO_R118_PAVIMENTO_STOP.md`, CSV `r118_csv/`, criteri congelati `prove/R118_PAVIMENTO_STOP_CRITERI.md`): **(a)** ORB U30USD M5, asse `InpSLBufferPts` 0/500/1000/1500/2000 x `InpSlippagePts` 0/50/100/150/200; **(b)** DAX ingresso a STOP (`InpEntryMode=0`) M15, asse `InpMinStopPts` 0-8000 x `InpSkipIfTight` 0/1 x slippage 0-400; **(c)** DAX RETEST (`InpEntryMode=2`) idem, senza asse di slippage (il codice non applica lo slippage a un ingresso LIMIT, r.1487). Tre rami: A = pavimento 0, B = pavimento che allarga lo stop, C = pavimento che SALTA il trade. Lo slippage e' uno SCENARIO ASSUNTO, non una misura.

**Parametri pinnati** — (a) ORB U30USD (`R118a`):

```
@SIMBOLO  U30USD
@PERIODO  M5
@DAQUANDO 2024.09.26
InpRangeStartHour=14
InpRangeStartMin=30
InpRangeEndHour=14
InpRangeEndMin=45
InpEndHour=21
InpEndMin=0
InpCloseAtEnd=1
InpOneTradePerDay=1
InpPendingExpiryMin=600
InpUseCloseConfirm=0
InpMinBodyPct=50.0
InpEntryPoints=10
InpK=1.0
InpAllowLong=1
InpAllowShort=0
InpSLMode=3
InpExecTF=5
InpAtrPeriod=14
InpAtrSLmult=1.5
InpSLFixedPts=1000.0
InpTPMode=1
InpTPRangeMult=1.5
InpTP_R=1.0
InpTP1Pct=0
InpBreakeven=1
InpUseTrailEMA=1
InpEmaFast=9
InpEmaSlow=21
InpExitOnEmaClose=0
InpUseEmaFilter=0
InpUseEma200Filter=1
InpEma200Period=200
InpMinRangePct=0
InpMaxRangePct=0.8
InpUseVolumeFilter=0
InpVolMult=1.5
InpVolAvgBars=20
InpRiskPercent=1.0
InpUseNewsFilter=0
InpUsaGuardian=1
InpAutoTest=1
InpMaxSpread=0
InpVerbose=0
InpSLBufferPts=0   # ASSE 0..2000 passo 500
InpSlippagePts=0   # ASSE 0..200 passo 50
```

(b) DAX ingresso a STOP (`R118b`) — (c) `R118c` = stesso blocco con `InpEntryMode=2` e `InpSlippagePts=0` non ad asse:

```
@SIMBOLO  D30EUR
@PERIODO  M15
@DAQUANDO 2024.09.26
InpSessionHour=8
InpSessionMin=0
InpRangeMinutes=35
InpCloseHour=17
InpCloseMin=30
InpCloseAtEnd=1
InpOneTradePerDay=1
InpMaxPosSimbolo=0
InpEntryMode=0
InpRangeMode=0
InpLevelTF=16385
InpPrevWindowMin=60
InpBufferPoints=500
InpOCTimeframe=0
InpPendingExpiryMin=120
InpAllowLong=1
InpAllowShort=1
InpMinRangePts=0
InpMaxRangePts=0
InpRetestOffsetPts=200
InpFadeOffsetPts=0
InpUseGapFill=0
InpGapMinPoints=150
InpGapMinRR=1.5
InpDelayMinutes=30
InpDelayDirMode=0
InpUseEmaFilter=0
InpEmaFast=14
InpEmaSlow=200
InpFilterTF=16385
InpUseSupertrend=0
InpStAtrPeriod=10
InpStMultiplier=2.5
InpStTF=16385
InpUseSupertrend3=0
InpUseCorrelation=0
InpCorrTF=16385
InpCorrEmaFast=14
InpCorrEmaSlow=100
InpUseVwapFilter=0
InpVwapTF=15
InpUseVolumeFilter=0
InpVolMult=1.5
InpVolAvgBars=20
InpUseAtrFilter=0
InpAtrFilterBars=20
InpAtrFilterMult=1.0
InpConfirmMode=0
InpUseNewsFilter=0
InpRiskPercent=1.0
InpSLMode=0
InpAtrSlMult=1.5
InpAtrPeriodMgmt=14
InpTP1_R=1.0
InpTP1_ClosePct=50
InpBreakevenAtTP1=1
InpBEatR=0
InpUseTrailing=1
InpTrailStartR=0
InpTrailMode=1
InpTrailTF=5
InpTrailAtrMult=2.0
InpTrailFixedPts=410
InpUseRoundLevels=0
InpRoundStep=100.0
InpRoundMinDistPts=50
InpAllowReverse=0
InpUsaGuardian=1
InpMaxSpread=0
InpVerbose=0
InpMinStopPts=0   # ASSE 0..8000 passo 2000
InpSkipIfTight=0   # ASSE 0..1 passo 1
InpSlippagePts=0   # ASSE 0..400 passo 100
```

**Numeri**
| ancora | IS: Profit · PF · DD · n | OOS: Profit · PF · DD · n |
|---|---|---|
| (a) ORB buffer 0 | 9.509,39 · 1,24979 · 7,8885 · 71 | 41.057,00 · 1,67419 · 9,7623 · 119 |
| (a) ORB buffer 500 / 1000 | PF 1,09174 / 1,03507 · DD 7,8098 / 7,0616 | PF 1,51284 / 1,55394 · DD 9,5573 / 8,0454 |
| (b) DAX STOP pavimento 0 (= D0 del fork alla cifra) | 203,66 · 1,04668 · 7,9333 · 220 | 251,22 · 1,04089 · 13,2624 · 325 |
| (c) DAX RETEST pavimento 0 | 282,12 · 1,07810 · 7,0257 · 197 | 999,42 · 1,18776 · 10,5984 · 311 |
Pavimento 0->2000 (20 idx): morde **0 volte su 220**, **0 su 311**, **4 su 197** (2,03%) ingressi; 4000/6000/8000 riducono n del 4,9/23,1/43,1% (corsa b OOS) e del 12,2/27,3/50,8% (corsa c OOS). Su 114 confronti cella-contro-baseline non degeneri: **il DD scende in 46/58 celle IS e 51/56 OOS** (concordi), mentre il **PF scende in 53/58 IS e 29/56 OOS** (discordi): allargare lo stop compra rischio in modo riproducibile e paga in edge in modo non riproducibile. Conflitto col collega (PF DAX 2,40 -> 1,26 col pavimento a 20 punti): sulla nostra geometria (stop = bordo opposto del range) a 20 punti il pavimento e' un no-op: la sua misura era su un'altra geometria.
**Perche' e' fuori gioco**: nessuna cella supera G1+G2+G3 insieme contro la baseline a slippage pari; le migliori sono FRAGILI. **Certificato**: e' un round di GESTIONE sulle sedie vive, non un motore: (3) stop/buffer ad asse SI · (4) gemelli: ORB e DAX SI, Nasdaq NO · (5) TF: M5 (ORB) e M15 (DAX: ancorato al calendario, TF inerte). Il ramo C sull'ORB non e' implementabile (mancano `InpMinStopPts`/`InpSkipIfTight`); lo slippage sul RETEST non e' simulabile; il CSV della corsa (a) non ha `Peggior Giornata %`.
**Non provato**: slippage misurato (il `SlippageLogger` sul reale ha 0 deal); ramo C sull'ORB (richiede codice); pavimento in punti ATR anziche' assoluti.

---
# PARTE B — Motori piu' vecchi (agosto - 22/09/2026): cella dal file prova o dal CSV che ha dato i numeri

## B1. LondonFx (R116): canale di Londra + RSI, EURUSD e GBPUSD (`ABTG_LondonFx`) — 🔴 BOCCIATA PER RISCHIO su entrambi i simboli, tutti e tre i motori
**Cella**: EA `ABTG_LondonFx.mq5` · M15 · **tick reali** · EURUSD `IS 2024.07.05 -> 2025.04.21 / OOS 2025.04.22 -> 2026.06.30` (un solo regime), ora d'inizio 8 server, sessione di 8 ore · rischio 0,65 · round **R116** del 03/09 (criteri congelati `risultati_archivio/LONDONFX_TICK_CRITERI.md`; CSV/corse in `risultati_archivio/r116_londonfx/`), file `prove/LONDONFX_R116_TICK.txt`. `InpMotore` 1 = canale nudo (controllo), 2 = canale + RSI (l'unico promuovibile), 3 = allineamento di 5 medie (SMMA 3/6/9/50 + EMA 200).
**Parametri pinnati**

```
@SIMBOLO  EURUSD
@PERIODO  M15
@DAQUANDO 2024.07.05
@FINOA    2026.06.30
InpUsaGuardian=true
InpMotore=2   # ASSE 1..3 passo 1
InpSmaPeriodo=5
InpRsiPeriodo=5
InpRsiSoglia=80.0
InpSmma1=3
InpSmma2=6
InpSmma3=9
InpSmma4=50
InpEmaLenta=200
InpOraInizioServer=8
InpOreSessione=8
InpRiskPercent=0.65
InpMaxSpread=0
InpSlippagePts=0
InpPipSize=0.0001
InpWarmupBarre=300
InpVerbose=true
InpAutoTest=true
```

**Numeri** (registro `REGISTRO_TEST.md` sez. "R116 ABTG_LondonFx", `r116_londonfx/CORSA_EURUSD_2026-09-03_1751_BOCCIATA.txt`, `CORSA_GBPUSD_2026-09-03_1755_BOCCIATA_BANCO_SPORCO.txt`):
| simbolo · motore 2 | E OOS | PF OOS | DD OOS | IS |
|---|---|---|---|---|
| EURUSD | -0,1078 R (soglia +0,075) | 0,843 (soglia 1,15) | **37,14%** (tetto 8%) | PF 0,795, Profit -36.353,98 |
| GBPUSD | -0,1726 R | 0,763 | **55,03%** | PF 0,688 |
Motori 1 e 3: DD 45,29% e 31,26% (EURUSD), 55-61% (GBPUSD). Ablazione fra motori 0,0561 R > 0,05 ma nessun motore passa i cancelli di merito. Il costo e' 1,7-3,3 volte l'edge richiesto (1R = 8 pip, cancello 0,60 pip, spread assunto 1,0-2,0); MAE mediana 11,8 pip > SL 8,0 pip (previsione dichiarata prima: "NO probabile", confermata due volte). Passo 0 (frequenza, 03/09): 12/12 righe VIVE su EURUSD M15 con RSI (2,0-2,3 segnali/giorno per lato, MFE 10-13,4 pip, RR 0,90-1,14); il filtro RSI taglia il 73-77% dei segnali nudi. Problema procedurale: gemelli GBPUSD divergenti per **piu' agenti tester vivi insieme** (classe 129), riga di rifacimento R116-BIS a un agente scritta (esito: [NON MISURATO in questo dossier]).
**Perche' e' fuori gioco**: **rischio** (DD 31-61% a 0,65%, a qualunque n) e **merito** (E OOS < 0, IS gia' in perdita) e **costo** (stop 8 pip vs pedaggio).
**Certificato**: (1) PF SI · (2) n+DD SI · (3) **uscita: NON RISULTA messa ad asse** (SL 8 pip/RR fissi) · (4) gemelli SI (EURUSD+GBPUSD) · (5) TF: M15 (passo 0 anche M5 ora 8 vivo, ora 4 sospesa): **[non risulta cambiato nei numeri di tick]**. Verdetto onesto: bocciato **per rischio** (Emendamento B: non dipende da n), certificato **NON verificato completo**.
**Non provato**: gestione dell'uscita; TF M30/H1; ora 8 vs 7/9 sul motore 2 (l'ora di Londra e' 8 server: misurato il 03/09); `InpRsiSoglia`=80 con RSI(5) e' un valore d'ingresso di un motore a PF OOS 0,76-0,84: non si rigriglia.

## B2. Relativo (mean reversion su spread DAX-Dow / Nasdaq-Dow, R117) (`ABTG_Relativo`) — 🔴 D30EUR bocciata per RISCHIO; ⏸️ NASUSD merito sospeso
**Cella**: EA `ABTG_Relativo.mq5` (sonda gemella `ABTG_SondaRelativo`) · D30EUR e NASUSD contro `U30USD` (`InpSimboloMetro`) · M5 · **tick reali** `2024.09.26 -> 2026.06.30` (split 40/60) · rischio 0,65 · round **R117** del 05/09, file `prove/RELATIVO_R117_D30.txt` / `RELATIVO_R117_NAS.txt`. Ingresso a z-score N=40, sigma 1,35; SL 2,75 x ATR; tetto 5 trade/giorno.
**Parametri pinnati (D30EUR; NASUSD = stessa cella con `@SIMBOLO NASUSD`)**

```
@SIMBOLO  D30EUR
@PERIODO  M5
@DAQUANDO 2024.09.26
@FINOA    2026.06.30
InpSimboloMetro=U30USD
InpModoSpread=0
InpModoZScore=0
InpFinestraN=40
InpSogliaIngressoSigma=1.35
InpSogliaUscitaSigma=0.05
InpOraInizioServer=14
InpMinInizioServer=30
InpOraFineServer=22
InpMinFineServer=0
InpAtrSL=2.75
InpBarreMaxTenuta=120
InpRiskPercent=0.65
InpMaxTradesPerDay=5
InpLato=0
InpAtrPeriod=14
InpAtrModoRma=false
InpSlippagePts=10
InpMaxSpreadPts=0
InpModoSonda=false
InpSaltaGiorniSpaiati=false
InpWarmupBarre=300
InpPuntiPerIndice=100.0
InpScriviCsv=true
InpVerbose=true
InpAutoTest=true
InpTag=RELATIVO
```

**Numeri** (registro sez. "R117 RELATIVO"):
| simbolo | E OOS | PF OOS | DD OOS | peggior giornata | n IS / OOS |
|---|---|---|---|---|---|
| D30EUR | **-0,267 R** | **0,452** | **25,01%** | **-5,20%** (muro giornaliero 5%) | n/d |
| NASUSD | +0,063 R (zona morta 0,075) | 1,189 | 8,40% (zona morta 8,0 / muro 10,0) | -2,12% | **87 / 154** (IS PF 0,754) |
NASUSD: 0,525 op/giorno di media pesata; per 300 operazioni (150+150) servono 567 feriali contro i 276 disponibili: **A6 non raggiungibile su questa gamba**. Lo spread DAX nella sessione (2,80 punti) mangia da solo il 79% del cancello H8; dalle 17 server il DAX e' fuori dal suo cash.
**Perche' e' fuori gioco**: D30EUR **rischio** (due muri prop sfondati insieme; non dipende da n, quindi non si riprova con una finestra piu' lunga); NASUSD **campione** (n 87/154 < 150 in entrambe; IS in perdita PF 0,754, OOS in utile, su taglie diverse: puo' essere rumore).
**Certificato**: (1) PF SI · (2) n+DD SI · (3) **uscita: `InpBarreMaxTenuta`/`InpSogliaUscitaSigma`/`InpAtrSL` NON ad asse** · (4) gemelli: D30EUR e NASUSD SI, **SPXUSD/Dow come gamba primaria NO** · (5) TF: M5 e M15 (file `RELATIVO_D30_M15`, `RELATIVO_NAS_M15`: sonde di conteggio) **[i numeri di tick sono solo M5]**. NASUSD: **NON ANCORA MISURATO**; D30EUR: bocciato per rischio.
**Non provato**: `InpFinestraN` diverso da 40 e sigma diverso da 1,35 solo con motivazione di regime (non griglia); metro U30USD vs SPXUSD; `InpSaltaGiorniSpaiati`; le corse `R117BIS_NAS` (file presenti, esito [NON LETTO qui]).

## B3. Live5m: rottura della candela pre-apertura (`ABTG_DAX_Live5m`, `ABTG_Nasdaq_Live5m`, `ABTG_DAX_Live5m_v2`) — 🔴 negativi a tick e sotto costo su M5; ⚪ NON ANCORA MISURATI
**Cella L1 (DAX, 07/08 e riletta il 22-23/09 dal CSV)**: EA `ABTG_DAX_Live5m.mq5` · D30EUR · M5 · **tick** · IS/OOS separati · **rischio 2,00** (il CSV lo riporta) · finestra d'ingresso 5 minuti (`InpPrevWindowMin=5`), buffer 700, due lati, ST spento, cancello d'ampiezza spento. CSV: `backtest_pipeline/risultati_prove/ABTG_DAX_Live5m/ABTG_DAX_Live5m_D30EUR_{IS,OOS}.csv` (+ `_ohlc`).

```
InpSessionHour=8
InpSessionMin=0
InpRangeMinutes=15
InpCloseHour=17
InpCloseMin=30
InpCloseAtEnd=1
InpOneTradePerDay=1
InpEntryMode=0
InpRangeMode=1
InpLevelTF=16385
InpPrevWindowMin=5
InpBufferPoints=700
InpPendingExpiryMin=120
InpAllowLong=1
InpAllowShort=1
InpMinRangePts=0
InpMaxRangePts=0
InpUseGapFill=0
InpGapMinPoints=150
InpGapMinRR=1.5
InpUseEmaFilter=0
InpEmaFast=14
InpEmaSlow=200
InpFilterTF=16385
InpUseSupertrend=0
InpStAtrPeriod=10
InpStMultiplier=2.5
InpStTF=16385
InpUseCorrelation=0
InpCorrSymbol=SPXUSD
InpCorrTF=16385
InpCorrEmaFast=14
InpCorrEmaSlow=100
InpRiskPercent=2
InpSLMode=0
InpAtrSlMult=1.5
InpAtrPeriodMgmt=14
InpTP1_R=1
InpTP1_ClosePct=50
InpBreakevenAtTP1=1
InpUseTrailing=1
InpTrailStartR=0
InpTrailMode=1
InpTrailTF=1
InpTrailAtrMult=2
InpTrailFixedPts=410
InpUseRoundLevels=0
InpRoundStep=100
InpRoundMinDistPts=50
InpUseNewsFilter=0
InpNewsFile=abtg_news.csv
InpNewsMinImpact=3
InpNewsBeforeMin=30
InpNewsAfterMin=30
InpNewsShiftMinutes=0
InpNewsCurrencies=
InpNewsFlatten=1
InpMaxSpread=0
InpVerbose=1
```

**Cella L2 (Nasdaq)**: `ABTG_Nasdaq_Live5m` NASUSD M5, `InpBufferPoints=700`, `InpMinRangePts=1700`, `InpMaxRangePts=4000`, `InpPrevWindowMin=5`, TP1 1R + 50% + trailing M1, rischio 2,00: CSV `risultati_prove/ABTG_Nasdaq_Live5m/ABTG_Nasdaq_Live5m_NASUSD_{IS,OOS}.csv` (stesse manopole, `InpMaxRangePts`/`InpMinRangePts` accesi). **Cella L3 (DAX v2)**: `ABTG_DAX_Live5m_v2` D30EUR, solo LONG (`InpAllowShort=0`), 32 passate = 4 celle distinte x 2 finestre d'ingresso x 4 ripetizioni (`InpMinStopPts` 200/400 e `InpSkipIfTight` 0/1 INERTI: identici alla quinta cifra), rischio 1,00: CSV `backtest_pipeline/risultati_archivio/Live5m/valid_DAX_Live5m_v2_D30EUR_realtick.csv` (righe migliori: `InpPrevWindowMin=15`, `InpUseSupertrend=1`, `InpAllowLong=1`, `InpAllowShort=0`, `InpMinStopPts` 200/400).

**Numeri (tick salvo dove scritto)**
| cella | IS: n · PF · DD | OOS: n · PF · DD | rischio | fonte |
|---|---|---|---|---|
| L1 DAX v1 (tick) | 225 · 0,93488 · 26,07 | 342 · **0,85701** · **39,74** | 2,00 | CSV sopra |
| L1 stesse celle in **OHLC** | 228 · 1,27364 · 18,77 | 352 · **1,46853** · 11,83 | 2,00 | `_ohlc.csv` (fattore OHLC/tick 1,714) |
| L2 Nasdaq (tick) | 116 · 1,01621 · 11,52 | 175 · **0,96265** · 19,40 (88-175 pos.) | 2,00 | CSV Nasdaq (fattore OHLC 2,246: OOS 2,16249) |
| L3 DAX v2, best (ST ON, PrevWin 15) | 239 deal, PF **1,04296**, DD **9,097** su finestra unica (nessuno split IS/OOS: "best di 32" = selezione) | | 1,00 | `valid_DAX_Live5m_v2_D30EUR_realtick.csv` |
| L3 resto | PF 0,84571-1,04062, DD 9,10-26,08 | | 1,00 | idem (a 2% raddoppiati: 18,2-52,2) |
**Gradiente di TF (l'unico dell'intera famiglia)**: allargando la finestra d'ingresso da 5' a 15', a parita' di tutto: **4 coppie distinte su 4** PF +0,077/+0,085/+0,089/+0,136 e DD -5,64/-7,01/-9,26/-11,26 punti. **30' e 60' MAI PROVATI.**
**Perche' e' fuori gioco**: **rischio** (DD 19-40% alla taglia di prova, 4x il muro) e **costo** (stop minimo strutturale 1,2-8,8x lo spread D30EUR contro 40x; M5 sugli indici sfonda il duro 13,3x: 11,5-13,1x a U30USD). La rottura secca della candela pre-apertura da 5', due lati, senza filtro trend e senza cancello d'ampiezza, non paga a tick sugli indici BCM.
**Certificato**: (1) PF SI · (2) n+DD SI · (3) **uscita NO su `RangeMode=1`/`PrevWin=5`** (gli assi F/I girarono su `RangeMode=0`) · (4) gemelli **parziali** (D30EUR cancello acceso: esiste una corsa; NASUSD con cancello acceso) · (5) **TF: il TF del grafico NON entra nei numeri** (unica occorrenza di `PERIOD_CURRENT` a r.296, ramo morto con `InpTrailStartR=0`); si chiude solo toccando `InpPrevWindowMin`/`InpLevelTF` (TF dell'INGRESSO: firma di Claudio). Verdetto: **NON ANCORA MISURATO**. "Non costruire altri v2 M5" resta in piedi.
**Non provato**: finestra d'ingresso 30/60 minuti; `InpTrailMode`, parziale, timestop su `PrevWin=5`; cancello d'ampiezza con range 1700-4000 sul DAX; TF `InpLevelTF`/`InpFilterTF`/`InpStTF`/`InpCorrTF` (tutti H1, mai mossi).

## B4. PostNews: breakout a due pendenti sul range post-notizia (`ABTG_PostNews`) — 🔴 PF < 1 su IS e OOS al passo 0 (OHLC), parametri ereditati e mai ritarati
**Cella**: EA `ABTG_PostNews.mq5` v1.10 (`InpNewsCommon=true`: il calendario e' nel Common) · EURUSD (candidato A: ISM Manufacturing/Services PMI + CB Consumer Confidence, 15:15 server) e USDJPY (candidato B: CPI m/m + Retail Sales + Core Retail + PPI, 13:45 server) · M5 · **OHLC M1 screening** · IS 2010-2015 / OOS 2015-2023 · rischio 0,65 · round del 05/09 (`RIGA_POSTNEWS_ISM`, `RIGA_POSTNEWS_1330`), file `prove/POSTNEWS_ISM_00_conta.txt` e `prove/POSTNEWS_1330_00_conta.txt`. SL/TP/offset **copiati di netto dalla sedia NFP viva, mai ritarati** su questi simboli/eventi.
**Parametri pinnati (A, EURUSD)**

```
@SIMBOLO  EURUSD
@PERIODO  M5
InpUsaGuardian=true
InpActionHour=15
InpActionMin=15
InpExpiryHour=16
InpExpiryMin=25
InpRestrictToNews=true
InpUseNewsFilter=true
InpNewsFile=abtg_news_ism1500_2010_2023_UTC.csv
InpNewsCommon=true
InpNewsMinImpact=3
InpNewsCurrencies=USD
InpNewsTitleMatch=ISM1500OK
InpNewsShiftMinutes=0
InpBuyOffsetPips=3.0
InpSellOffsetPips=2.0
InpTPpips=30.0
InpSLpips=25.0
InpUseOCO=false
InpCloseAtExpiry=true
InpUseTrail25=false
InpTrailTriggerPips=25.0
InpTrailNewSLpips=15.0
InpFridayClose=true
InpFridayCloseHour=21
InpFridayCloseMin=50
InpRiskPercent=0.65
InpRiskRefSLpips=50.0
InpMaxSpread=0
InpVerbose=true
InpAutoTest=true
```

**Differenze B (USDJPY 13:45)**: 
```
@SIMBOLO  USDJPY
InpActionHour=13
InpActionMin=45
InpExpiryHour=14
InpExpiryMin=45
InpNewsFile=abtg_news_usd1330_2010_2023_UTC.csv
InpNewsTitleMatch=USD1330OKF
```

**Numeri** (registro "POSTNEWS — candidati A e B", riga pin `1dbae103`): A: IS n 234 PF **0,76** Profit -4.651,72 DD 6,92% · OOS n 312 PF **0,79** Profit -5.633,01 DD 6,94%. B: IS n 151 PF **0,66** Profit -4.084,87 DD 4,75% · OOS n 253 PF **0,90** Profit -1.979,08 DD 4,56%. Campione pieno: la lettura e' negativa e leggibile. Nessuna delle sei letture (pulite o sporche per il bug dei gemelli, classe 129) ha mai mostrato PF >= 1. Corse precedenti (EURUSD/EURJPY, 4 CSV a Trades 0): NESSUNA MISURA (calendario 17 righe 2026-27 + file aperto senza FILE_COMMON = filtro spento in silenzio; riparato). arXiv 2605.04004 par. 4.7 (Nasdaq, 993 eventi): il drift post-news e' reale nelle prime 5 barre, da bar +6 t fra 0,14 e 0,69: la nostra finestra di riempimento cade in gran parte fuori.
**Perche' e' fuori gioco**: **merito** (PF < 1 su n pieno) su questi due eventi con questi parametri. Non e' un mandato chiuso: e' UN meccanismo (breakout a due pendenti) su DUE eventi con SL 25/TP 30 pips ereditati.
**Certificato**: (1) PF SI · (2) n+DD SI · (3) **uscita NO** (`InpTPpips`, `InpSLpips`, `InpUseTrail25`, `InpCloseAtExpiry`: mai ad asse) · (4) gemelli: NFP viva + 2 candidati; altri eventi (FOMC/ECB) NO · (5) TF: M5 solo. Verdetto: **NON ANCORA MISURATO**. Regola 19/08: non si ritocca SL/TP sugli stessi dati; si cerca un meccanismo diverso sulla stessa inefficienza (fade, liquidity sweep, gestione a tempo).
**Non provato**: fade; posizionamento a +/-5 barre; gestione a tempo; ECB 13:15 e FOMC come eventi; USDJPY `InpNewsTitleMatch` con altri eventi USA.

## B5. IBRetest: retest dell'Initial Balance (`ABTG_IBRetest`) — 🪦 SCARTATO al cancello C0
**Cella**: EA `ABTG_IBRetest.mq5` (da "IB Completed", Genxtraders, TradingView `Z1CwMI6V`, scritta da specifica) · U30USD (madre), NASUSD, D30EUR · M30 · **tick reali** `2024.09.26 -> 2026.06.30`, deposito 10.000, rischio 0,65 · round del 09/09 (`report/P0_IBRETEST_2026-09-09.md`, `P0_IBRETEST_NASUSD_2026-09-09.md`), file `prove/ABTG_IBRetest_00_conta.txt` (madre; D30EUR/NASUSD = `_D30EUR`/`_NASUSD`).
**Parametri pinnati (U30USD)**

```
@SIMBOLO  U30USD
@PERIODO  M30
@DAQUANDO 2024.09.26
InpUsaGuardian=true
InpIbInizioOra=14
InpIbInizioMin=30
InpIbFineOra=15
InpIbFineMin=30
InpSmaLen=9
InpPivot=2
InpStopBufferPunti=2.0
InpInvalidaSuIbOpposto=false
InpMaxIbPunti=0
InpUsaFiltroHTF=false
InpHtfMinuti=240
InpHtfMaLen=9
InpAllowLong=true
InpAllowShort=true
InpCutoffOra=20
InpCutoffMin=0
InpUsaFlatSeduta=true
InpGoFlatOra=21
InpGoFlatMin=0
InpMinStopPts=25
InpMT5PerPuntoIndice=100
InpRR=2.0
InpBEatR=0.0
InpRiskPercent=0.65
InpMaxSpreadPctOfStop=2.5
InpMaxTradesPerDay=1
InpVerbose=true
```

**Differenze D30EUR**: 
```
@SIMBOLO  D30EUR
InpIbInizioOra=8
InpIbInizioMin=0
InpIbFineOra=9
InpIbFineMin=0
```
 (NASUSD: solo `@SIMBOLO`).
**Numeri**: U30USD n 95 · PF IS 0,38242 / OOS 0,69663 · DD 7,38/7,61% · NASUSD n 84 · 0,56297 / 0,59292 · 5,80/5,31% · D30EUR n 165 · **1,21062** / 0,96493 · 2,80/5,25%. **Famiglia**: n 344, PF IS **0,7356** (n 135) · OOS **0,8124** (n 209) · PF 0,7798; 0,78 op/giorno di famiglia contro il pavimento 1,00. Il 62% dei trade muore del flat di fine seduta (52/84 NASUSD, 103/165 D30EUR), non di stop ne' TP: il porting ha TP unico a 2R mentre la fonte esce a scaglioni 1R/2R/3R/4R/5R con BE a 2R (rischio di porting n.2, dichiarato prima). Costo C3 passato (stop mediano 110-240 punti = 67-123x lo spread); 4 cancelli su 5 passati su tutti e tre i simboli; gemelli G1 identici; su D30EUR 94 ordini rifiutati su ~259 (36%) dal cancello sullo spread serale.
**Perche' e' fuori gioco**: **merito** (C0: n >= 150 + PF < 1,10 nella finestra peggiore -> scarto senza griglia; qui n 209 OOS PF 0,8124) + **frequenza di famiglia** 0,78/giorno. Non ritestare "solo il DAX" (PF 1,21 su 58 op. = indistinguibile da 1,00; l'OOS dello stesso simbolo fa 0,96).
**Certificato**: (1) PF SI · (2) n+DD SI · (3) **uscita: NO** (RR unico 2,0, `InpBEatR=0`; **il flat di seduta e' il motivo d'uscita del 62%**) · (4) gemelli SI (3 simboli) · (5) TF: M30 (`IBRETEST_M30_BOZZA.txt`); **[non risulta cambiato]**. Quello che si PUO' riprendere: la GESTIONE DELL'USCITA (sarebbe un motore nuovo: scaglioni 1R-5R con BE a 2R della fonte).
**Non provato**: uscita a scaglioni della fonte; `InpGoFlatOra` 21:00 vs anticipato; `Ora Ingresso` misurata (serve una colonna nell'OnTester).

## B6. VwapRevert su D30EUR M15 (`ABTG_VwapRevert`) — 🪦 FALSIFICATO al cancello S0 (4 celle su 4)
**Cella**: EA `ABTG_VwapRevert.mq5` · D30EUR · M15 · **tick reali** `2024.09.26 -> ...` (corsa del 03/09, `risultati_archivio/vwaprevert/CORSA_2026-09-03_1711_FALSIFICATO.txt`) · rischio 1,00 · file `prove/PASSO0_VWAPREV_01_long.txt` (le 4 celle: `00_nudo`, `01_long`, `02_short`, `03_overnight`).
**Parametri pinnati (cella 01 long)**

```
@SIMBOLO  D30EUR
@PERIODO  M15
@DAQUANDO 2024.09.26
InpSigmaMult=1.0
InpTpR=2.0
InpSlAtrFloor=0.2
InpLookback=20
InpAtrPeriod=10
InpAtrMult=1.5
InpOrderLifeBars=3
InpAtrBufferPct=0.01
InpSlFloorMode=0
InpSlUseSetupBar=0
InpEngulfingOnly=0
InpUsePartial=0
InpUseTrailAtr=0
InpMinSessionBars=0
InpSessionStartHour=-1
InpSpreadExtraPts=0
InpMaxSpreadPctSL=0
InpUseHourFilter=0
InpUseNewsFilter=0
InpFridayClose=0
InpCloseOnOpposite=1
InpFlatFineSeduta=1
InpFlatOra=20
InpFlatMinuto=45
InpStopNuoviMinPrimaFlat=0
InpBodyPctMax=0.30
InpWickMult=2.0
InpDojiBodyPct=0.20
InpClosePct=0.30
InpPartialR=1.0
InpPartialPercent=50.0
InpBreakEven=1
InpTrailAtrMult=2.0
InpHourStart=10
InpHourEnd=16
InpFridayCloseHour=20
InpNewsMinImpact=3
InpNewsBeforeMin=30
InpNewsAfterMin=30
InpNewsShiftMinutes=0
InpMaxSpread=0
InpUsaGuardian=0
InpVerbose=1
InpAutoTest=1
InpRiskPercent=1.0
InpMaxTradesPerDay=2
InpAllowLong=1
InpAllowShort=0
```

**Numeri**: S0 (rapporto punti/spread) **NON PASSA su tutte e 4**: -0,11 / -0,21 / -0,14 / -0,21 (soglia 2,5): il motore perde in media PIU' dello spread; n OOS `00_nudo` = 107 (< 150). Per la clausola scritta nella bozza dei criteri, un S0 NON PASSA sulla 00_nudo chiude il capitolo VWAP come motore; nessuna nuova taratura di `InpSigmaMult` & c.
**Perche' e' fuori gioco**: **edge** (non e' costo: il segno e' negativo). **Certificato**: (1) PF: misurato come S0 (rapporto punti/spread), non come PF · (2) n SI, DD [non riportato] · (3) uscita: `InpUsePartial`, `InpUseTrailAtr`, `InpTpR` **NON ad asse** · (4) gemelli **NO** (solo D30EUR) · (5) TF **NO** (solo M15). Verdetto onesto: **NON ANCORA MISURATO nei punti 3-5**, "arato" solo sul meccanismo VWAP-reversion D30EUR M15. Difetto di strumento da tenere presente: `VwapBias()` nel Dow/nel Nasdaq somma le barre dallo stesso giorno server (mezzanotte BCM), non dall'apertura cash (misurare un VWAP dalla cash richiede codice).
**Non provato**: VWAP ancorato all'apertura cash; U30USD/NASUSD; M30/H1; uscita a tempo. (P6 "VWAP di lato sul Dow" scartata per costruzione: misurerebbe un'altra cosa.)

## B7. EMA200: simboli e TF scartati col numero (`ABTG_EMA200`) — costo, merito, campione
Tutti a `ABTG_EMA200.mq5`. **Cella tipo** (EURUSD H1, R29a, tick, 21 mesi):

```
@SIMBOLO  EURUSD
@PERIODO  H1
@DAQUANDO 2024.09.26
InpTF=16385
InpAllowLong=1
InpAllowShort=1
InpUseOrder2=1
InpRiskPercent=1.0
InpOrder1Atr=0.10   # ASSE 0.10..0.30 passo 0.05
InpOrder2Atr=0.2   # ASSE 0.2..0.3 passo 0.1
InpTP_RR=1.5   # ASSE 1.5..2.5 passo 0.5
```

| voce | numero | cancello | verdetto |
|---|---|---|---|
| **U30USD M5/M15/M20/M30** | gamba 2 / spread di sessione (1,8-2,0 punti): M5 11,5-13,1x · M15 20,0-22,6x · M20 23,1-26,1x · M30 28,3-32,0x (H1 33,6-45,2x, la 40x cade DENTRO la banda misurata; H2-H4 56,6-90,5x) | costo (ATR 78,0-88,2 a H1, k=0,968 misurato, radice del tempo sovrastima del 92%) | ESCLUSI PER COSTO (M5 sfonda il duro 13,3x); le celle M15-M30 di `COLLAUDO_EMADOW_05_tf_U30USD` sono INFORMATIVE |
| **U30USD H4** | 77 celle positive su 85, best PF **3,02473**, DD 2,4575%, 32 deal (max 82) = 16-41 pos. | **campione** (regola del CAMPIONE, non frequenza: si chiude solo con STORICO) | L'edge c'e', il campione no; storico indici BCM = 21 mesi |
| **E50EUR H1 / H4** | best PF 0,7403 (0/88 celle +) · 0,9535 (0/81) | merito (OHLC: uno zero ottimista chiude) | scartato |
| **NASUSD H1** | 1/85 celle + (best 1,0197, DD 5,74%); scan `risultati_prove` 2/83 (1,0285) | merito | scartato a H1; **NASUSD H4 MAI misurato** (file non esiste) |
| **EURUSD H1 due lati** (R29) | OOS PF 1,076-1,224, DD 9,05-11,98% a 1%, n 583-759 deal; IS 0,986-1,222 | 7/30 PASS pieni sparsi; H1 escluso per costo 20,8x | bocciata (R29); il **LATO LONG da solo** a tick: 34/34 in utile, PF mediana 1,2742, DD 6,22-8,25%: NON ANCORA MISURATO |
| **AUDJPY LONG · GBPJPY LONG · GBPUSD SHORT** (H4, tick, 2024-26, lato per lato) | celle +: 24/24, 32/32, 32/32; PF mediana 1,8628 / 1,7564 / 1,6760; DD 2,15-5,86%; 138-200 deal = **69-99 pos.** | **aritmetica del campione** (0,11-0,16 pos/giorno; 150 pos. per finestra a H4 non esistono nel banco a tick) | fuori per campione, non per edge; GBPUSD LONG 8/31 (PF 0,9644): stesso simbolo, segno opposto. Le sedie forward gemelle H4 sono a 0 operazioni dal 01/08 |
| **PTE GBPUSD H1** (candidata seconda sedia) | OHLC OOS 2013-2026 PF 1,095 DD 9,87% n 477 deal; a tick n = **49** | PF 1,095 < 1,10 su screening; campione a tick 33% del pavimento | scartata come seconda sedia |
I 26 anni di barre producono 49 operazioni di verdetto perche' i tick BCM partono dal 2024.07.05: "comanda la profondita' di storico" e' un riframing che non regge.
**Certificato**: vedi le sezioni A4-A6 per gli assi d'uscita (`InpTP1Pct`, `InpSLatr`, `InpTP_RR`) e i gemelli.

## B8. Famiglia Supertrend / SupRev / SuperWave a M30-M15 e la sonda esterna (varie: `ABTG_SupertrendReversal_Multi_Ottimizzato`, `ABTG_SupRev_*_Ottimizzato`, `ABTG_SuperWave*`, `ABTG_EMA200_Ottimizzato`, `ABTG_WOL`, `ABTG_SupertrendInvert`) — 🪦 a M30 il merito e' misurato e negativo
**Cella**: 34 coppie IS/OOS a **tick reali** con una cella M30 (168 CSV M30 in archivio, 68 a tick, 12 simboli, 8 famiglie), `report/LA_BANDA_BASSA_2026-09-12.md`; l'asse e' `InpTF` (il TF operativo di 8 famiglie e' `InpTF`, non il grafico: un censimento su `@PERIODO` non lo vede). Nessun blocco unico: i parametri sono nei CSV di `risultati_prove/` per famiglia.
**Numeri**: `PF >= 1,10` in ENTRAMBE le finestre in **0 casi su 34** a M30 e **0 su 34** a M20; nei STESSI 34 sweep a H1 sono **4** e a H4 **9** (contro-esempio: l'alternativa "famiglia debole" prevedeva zero anche a H1/H4: falsificata). 24 su 34 hanno n >= 150 OOS, max n 1.151 (EMA200 GBPUSD M30 OOS). DD OOS mediano: H4 2,74% -> H1 4,82% -> M30 6,61% -> M15 8,63% -> M20 8,90%. Celle singole: `SupertrendReversal_Multi_Ott` XAUUSD M30 n 257/427 deal PF 1,25637/1,08718 DD 10,66/22,06 (a 2,0%; PICCO: vicini M20 IS 0,709 e H1 IS 0,984); XAUUSD M15 PF 0,75293/1,14283 DD IS 42,58; `EMA200_Ott` XAUUSD M30 0,78220/1,10258; `SupRev_DOW_H4_Ott` U30USD M30 0,66190/1,36960; `SuperWave` U30USD M30 1,20400/0,93050; `EMA200` XAUUSD/GBPUSD/AUDJPY/GBPJPY/SPXUSD M30: 0 su 5 con PF >= 1,10 in entrambe (n 415-1.151). **Costo a M30** (k=0,968 misurato): 0 dei 14 motori di classe S passa il 40x; gli ultimi tre sfondano il duro 13,3x. **Legge falsificabile**: un motore guadagna operazioni scendendo di TF se e solo se lo stop si stringe scendendo di TF (21 sedie su 42 hanno lo stop ancorato al calendario: guadagno 0,00 misurato dal codice). Il moltiplicatore dipende dal MOTORE (1,30 BreakingBand, 1,85 supertrend).
**Sonda esterna (22/09, `report/SUPERTREND_IL_CERTIFICATO_2026-09-22.md`)**: 40 celle (4 simboli x 2 TF x 5 definizioni di segnale dei due indicatori Pine: flip, AMA zero, osc +/-0,80, istogramma zero, osc x AMA), Oanda/HistData M1 2013-2018, PF NETTO, costo per lato DAX 1,7676 pt / oro 0,2003 $: **zero celle >= 1,10 su >= 2 simboli e due lati**; massimo 1,281 (S4 oro H4) **ucciso dal contro-esempio** (passeggiata aleatoria a volatilita' appaiata: 1,296, PIU' ALTO); % di falsi 59,8-73,7% in 40 celle; asimmetria indici/oro rovesciata = drift 2013-18, non edge. In casa 16 EA della famiglia: PF OOS 0,75-1,01 su n 290-640.
**Certificato**: (1) PF SI · (2) n+DD SI · (3) uscita: per il **segnale grezzo** NON messa ad asse ("una gestione non crea edge dal nulla, lo rimodella"), per `InpTrailOnST`/`InpExitOnFlip`/`InpFirstFraction` **ZERO occorrenze come asse in tutto il repo** · (4) gemelli SI (12 simboli) · (5) TF SI (M15/M20/M30/H1/H4). **Famiglia: certificato completo sul SEGNALE, incompleto sulla GESTIONE del flip.**
**Non provato**: famiglia Supertrend con `InpTrailOnST`, `InpExitOnFlip`, `InpFirstFraction` ad asse (tutti e tre a ZERO come asse).

## B9. Oro, finestra 15:36 su M1 (metodo del collega) — 🔴 BOCCIATO PER COSTO
**Cella**: XAUUSD · range M5 14:30-14:35 server (15:30-15:35 IT) · rottura su **M1 alle 14:36** · ingresso a mercato · uscita dopo 3-4 candele M1 · **nessun EA** (aritmetica del cancello di costo + 33 aperture manuali). Referto `report/ORO_1530_CANCELLO_COSTO_2026-09-10.md`.
**Numeri**: spread oro 0,16 $ (17/08) / 0,22 $ (27/08) [nella finestra 14:30-14:41 **NON MISURATO**]; commissione MISURATA -3,48 EUR/lotto giro (n 385) = 0,0403 $; costo pieno 0,2003 $ = 20,03 USD/lotto. Frontiera 40x -> stop minimo 6,40 $ (8,01 $ col pedaggio pieno); duro 13,3x -> 2,13 $. Movimento MISURATO del trade in quella finestra **1,41 $** (mediana, n 33 aperture su 19 giornate, durata 1,9 min); controprova range di giornata mediano 40,50 $ (n 60) con regola sqrt(t): 1,47 $ (scarto 4,3%). **Rapporto stop/spread 8,8-12,5x: sotto anche il duro.** In campo (manuale): 22 vinte su 33 (66,7%) e -785,99 EUR netti, di cui ~473 EUR (60%) pedaggio.
**Non e' morta la tesi**: il TF piu' basso che la frontiera lascia passare sull'oro e' **M30 con stop >= ~8,8 $** (margine +9,7%, sottile) o **H1 (gradino robusto)**: e' lo stesso meccanismo di `ABTG_ORB`/`ABTG_Nasdaq_Apertura_US`. Non e' piu' il trade del collega (range 30 min, durata ore).
**Non misurato**: spread 14:30-14:41; slippage oro (0 righe XAUUSD nei dataset); profondita' a tick di XAUUSD; ATR per TF sull'oro [INFERITO].

---
# PARTE C — Altri caduti del registro (riga di tabella: verdetto, numero, cosa manca)
Per questi motori il registro non conserva un file prova singolo con la cella completa (girarono da griglie di file diversi o come sonde di conteggio): in tabella verdetto, numero, fonte e cosa manca al certificato. Se una di queste righe vi serve nel dettaglio, chiedete la cella **per nome**.

| motore (EA) | verdetto e numero | fonte | cosa manca al certificato |
|---|---|---|---|
| `ABTG_FiboH4_Multi` (8 coppie forex+oro H4) | "0/8" = **UN numero contato otto volte**: `InpSymbols=` vuoto, MT5 ignora il pin vuoto, 7 file su 8 danno lo stesso numero al centesimo (IS -384,56/-394,13, OOS +116,17/+118,68); non ha mai giudicato la strategia del corso (geometria: ordini x10, target x2,1, stop ~x4) | `REGISTRO_TEST.md` sez. 2-bis; `prove/ABTG_FiboH4_Multi.txt` (`InpEngulfLookback` 8..16 x magic) | il round R93 (filtro news + geometria del corso con `ABTG_FiboH4_Corso.mq5`): non risulta girato |
| `ABTG_ORB_Fibo` NASUSD | OHLC PF IS 0,83507 / OOS 0,96816, DD 3,02/3,10, n 91/75 (< 95 e < 150: merito sospeso); nessuna passata a tick | registro sez. 3 riga O2; CSV `risultati_prove/ABTG_ORB_Fibo/` | tick, gemelli, TF (`InpExecTF` M5, `InpORMinutes` 30 mai mossi), uscita (`InpExitOnEmaClose`, `InpUseTrailEMA`, `InpTP1Pct`) |
| `ABTG_ORB` NASUSD (R97) | tick: 50% pos, best PF 1,15, DD 16%, 625 tr (O1 marginale); R97 0/4 celle, PF OOS 0,84-0,91, n 135 | registro sez. 3 riga O1; `prove/R97*.txt` | gestione dell'uscita (`prove/R15_ORB_gestione_DD.txt` dice "candidato del giro successivo": mai fatto) |
| `ABTG_DAX_M3` | **mai misurato**: nessun CSV in tutta la storia git; Supertrend H4 bias / M3 trigger + EMA200 + ADX>=25 (non e' un breakout M5) | registro sez. 3 riga O3 | **zero punti su cinque**: `InpTrailOnST`, `InpExitOnFlip`, `InpTriggerTF`, `InpBiasTF` mai ad asse |
| `ABTG_CRT_TurtleSoup` | tick 2024-26 (toro) sweep 30 celle PF 0,43-0,73 (0/30); OHLC _EXT 2020-24 con gate ADX(D1)<=30: +10.135 ogni regime positivo, MA a tick col gate **PF 0,459** (ungated 0,462), 17/19 mesi rossi | registro "CRT TURTLE SOUP"; `REFERTO_CRT_2026-08-30.md` | parcheggiato (motore da range): si riapre con tick del regime range o mercato chop |
| `ABTG_ChaosLyapunov` (gate LLE su EMA-cross) | screening OHLC NASUSD_EXT M15 2020-24, 105 celle; il gate morde 15/15 ma AL CONTRARIO della tesi (gate stretto PF 0,39-0,42; largo 1,25-1,33); 1 cella su 105 in fascia PF >= 1,3 e DD < 8%: outlier | registro "CHAOS LYAPUNOV" | tick e altri simboli; n 55-92 in 4 anni |
| `ABTG_SondaM0PB` (Momentum Pull Back) | **morto 12/12** al passo 0 (3 indici x 2 TF x 2 lati): F1 frequenza 0/12 (best 0,52 seg/giorno), H8 RR >= 0,70 7/12 sotto | `REFERTO_SONDAM0PB_2026-08-31.md` | e' un contatore: nessun EA, nessun PF; riaperto l'08/09 dal ripescaggio per frequenza |
| `ABTG_SondaRsiEmaV8` (Pine anonimo) | il filtro RSI toglie solo il 9-13% degli incroci EMA(5/20): nei numeri e' un incrocio di EMA (famiglia SuperWave/Chaos); RR 0,92-1,17; muro rischio aperto 19,5% (M5) / 8,45% (M15) contro cap 3,25% | `REFERTO_SONDARSIEMAV8_2026-09-03.md` | 7 problemi dichiarati (invariante V8 violato su ~1-1,5% dei segnali) |
| `ABTG_BreakinBox` (falsa rottura del box notturno DAX) | ablazione a tick: TP al lato opposto PF 1,007 DD 24,1% contro RR fisso 2,0 (R95) PF 1,106 DD 19,7%: vince il controllo | `REFERTO_BREAKIN_2026-08-31.md` | il controllo stesso buca DD <= 15% |
| `ABTG_DaxReEntry` | passo 0: LONG 6/6 verde (PF fino a 1,80, DD 2,5%), SHORT morto, n <= 92: merito sospeso; ~3-4 op./mese/lato | `REFERTO_DAXREENTRY_2026-08-31.md` | campione (cecchino da mossa 4, non portata) |
| NY Session Retest (retest VWAP U30USD M15) | gate spento: n 625/21 mesi, PF 1,002, DD 12,9%; gate slope 75: PF 1,37/1,43 DD 3,7-4,7% ma n 114-115 < 150; slope 60 (n 160) PF 1,14-1,20 sotto barra | `REFERTO_NYRETEST_2026-08-31.md` | porta di rientro MECCANICA: quando la finestra tick dara' n >= 150 sulla cella slope 75 (~2027) o Dukascopy pre-2024 |
| Sequenza di inversione monotona (indici) | sonda esterna GRXEUR+SPXUSD 2015-2018 (1,94 M barre M1): SHORT positivo 6/6, LONG negativo 6/6 (DAX H1 N=3 SHORT +0,057 R n 251 vs LONG -0,211 R n 265, 1R = 52x lo spread) | `report/CACCIA_SUPREV_ALTERNATIVE_2026-09-12.md` | **mai girata su BCM**; lotto fisso della fonte |
| `ABTG_AtrExhaustVol` NASUSD M5 · `ABTG_HVAncora` U30USD M5/M15 · `ABTG_DaxValueArea` D30EUR M5/M15/M30 | esclusi PER COSTO: 10,9x · 9,3x/7,1x (M5), 12,3x/16,0x (M15) · 5,6x/8,5x/11,3x contro il duro 13,3x; DaxValueArea M5 anche per tetto barre (~126.700) e a M30 il profilo degenera in un ORB | `report/LA_BANDA_BASSA_2026-09-12.md` sez. "GLI SCARTI COL NUMERO" | HVAncora a TF piu' alti (file pronto mai lanciato, 4 passate) |
| `ABTG_IntradayMomentum` | discesa di TF: 0,00 op/giorno guadagnate, misurato dal codice (segnale, ingresso, uscita d'orologio); gia' 1 op/giorno, 3 di famiglia su tre indici | idem | -- |
| MaxMinNotte su 100GBP / E50EUR / F40EUR; SupRev 100GBP H1/H4, 225JPY H1/H4 | best PF 0,6717 (0/54) / 0,8398 (0/54) / 0,9985 (0/54, DD 10,12); SupRev 100GBP H1 0/27 (0,8822), H4 5/27 n 48; 225JPY PF 2,16 ma profitto ~50 EUR (taglia del contratto) | registro "DIECI SCARTI COL NUMERO" | OHLC = screening; l'unico caso in cui uno zero OHLC chiude |
| `ABTG_Apertura_3Ingressi` / duello ingressi (R83) e ablazione criteri (R84) | la STESSA regola d'ingresso CAMBIA SEGNO fra DAX e Nasdaq; R84 su NASUSD M15 tick: ablazione dei criteri | `REGISTRO_TEST.md` "R83/R84" | Dow (R180) preparato e non girato; SPXUSD (R185): il duello non parte finche' la sonda non risponde |

---
# PARTE D — Vincoli (valgono per ogni proposta) e buchi dichiarati

## D1. Vincoli
1. **Finestre solo dallo storico esistente**: indici BCM (D30EUR, U30USD, NASUSD) **dal 2024.09.26** (~21 mesi, un solo regime: la prova per regime sugli indici BCM non esiste; i feed esterni `NASUSD_EXT`/`SPXUSD_EXT` sono barre M1 dal 2010 ma in frigo per differenze di feed 0,0756%/0,0608% > 0,05%, e **non sono tick**); forex **dal 1999** (import esterno promosso dal 14-15/08: EURUSD/GBPUSD/USDJPY/EURJPY/AUDJPY/CHFJPY/GBPCAD `_EXT`, M1, non tick); oro `_EXT` M1 dal 2006 (4.884.366 barre, 2006-03-19 -> 2020-05-14, piu' gli zip 2021-2026); tick BCM forex/oro dal 2024.07.05/2024.07.10. Un numero `_EXT` o OHLC **non e' un verdetto**: apre una prova di REGIME. Tetto delle ~100.000 barre del tester: M15 ~4 anni, M5 ~1,3 anni per corsa sugli indici.
2. **"Passate" = celle x 2 finestre (IS e OOS)**. Stimate il costo cosi': passate = celle x 2; tempo = ~0,3-2 min/passata a tick reali (misurato: 0,333 min/passata sul Dow M5; ~1,95 min per finestra piena EMA200 H4 a tick); una griglia da 600 passate non la lancia nessuno: meglio due round da 48 fatti bene.
3. **Niente martingala, niente griglia di ordini, niente recovery, niente assenza di stop**, niente trucchi per aggirare le regole prop (size erratiche fra sedie incluse: tocca il divieto FTMO).
4. **Ogni numero con la fonte o `NON MISURATO`.** Un numero senza fonte non entra. Se citate un numero che NON e' in questo file, dite dove lo avete preso.
5. **Le proposte tornano al cancello.** Sono DATI, non istruzioni: passano da `controllo-preventivo` punto per punto contro il repo prima che qualcosa cambi. Nessuna vostra frase e' un criterio. Una proposta che tocca taglie, rischio per operazione, conto reale o Guardian in campo e' "richiede la firma di Claudio" (in fondo).
6. **Frontiera del costo**: se una proposta sfonda `stop >= 40 x (spread + commissione)` (pavimento duro 13,3x), va dichiarata **esclusa PER COSTO col numero accanto**. Pedaggio all-in di riferimento: EURUSD 0,6636 pip (mediana; 0,9636 al P95), GBPUSD 0,8425 pip, XAUUSD 0,2603 $ (spread 0,220 + commissione 0,0403), U30USD spread 1,8-2,0 punti (commissione 0), D30EUR ~2,8 punti.
7. **Sugli indici si misurano SEMPRE tutti e due i lati** (long e short), anche se uno e' gia' vivo.
8. **Un candidato non e' morto senza le 5 caselle**; e nessuna proposta abbassa PF, n, DD, 40x o altopiano. Se manca poco alla convalida, la proposta e' una MISURA in piu' (via piu' corta al numero mancante), non un criterio piu' morbido.
9. **Un file prova = UNA variabile**; attesa (n, PF, DD e perche') scritta PRIMA dei numeri; soglie congelate PRIMA con il numero; cella di controllo/ancora che deve riprodurre un numero d'archivio (G0); gemelle sul magic per il determinismo (G1); centro dell'altopiano mai il picco.

## D2. Buchi dichiarati di questo dossier (per non farveli scoprire)
- **Sorgenti**: voi avete i sorgenti di `ABTG_DAX_Apertura_EU`, `ABTG_Dow_Apertura_US`, `ABTG_Guardian`. Gli altri EA (`ABTG_Londra_ORB`, `ABTG_Nightly`, `ABTG_MaxMinNotte`, `ABTG_EMA200`, `ABTG_Nasdaq_Apertura_US`, `ABTG_GapContinuation`, `ABTG_LondonFx`, `ABTG_Relativo`, `ABTG_Live5m*`, `ABTG_PostNews`, `ABTG_IBRetest`, `ABTG_VwapRevert`, `ABTG_ORB_Ottimizzato`, `ABTG_SondaGapCash`) sono citati **solo per nome**: le vostre osservazioni su di essi valgono come domande da verificare nel sorgente, non come fatti.
- **Blocchi di parametri**: sono quelli dei file prova/CSV che hanno girato. Dove un file ha piu' celle (assi), il valore mostrato e' quello della cella base e l'asse e' indicato. Per le sezioni B3 e C la cella e' letta dal CSV d'archivio o non e' riportata; **nessun preset in campo, nessun magic delle sedie FTMO vive, nessun numero di conto e nessuna taglia di campo e' in questo file** (un rischio di 0,5/0,65/1,0/2,0 accanto a un DD e' il rischio DEL BANCO DI PROVA).
- **Non misurato** (ricorrente): tick oro prima del 2024.07.10; spread nella finestra 14:30-14:41 dell'oro; spread/commissione GBPJPY e AUDJPY; slippage reale (il logger sul reale ha 0 deal); orologio dell'oro [INFERITO = forex]; il giorno esatto del cambio d'orologio BCM forex (26/12/2024 - 02/02/2025); commissioni FTMO; la causa del G0 rosso di EMA200 H4 (tre ipotesi non separate); `InpTP_RR`/`InpSLatr` sull'oro 2017-23; il bias H4 del Dow (classe 771).
- **Regime**: sugli indici un solo regime (toro 2024-26) con estate/inverno mescolati; sull'oro il 2024-26 e' il toro dell'oro e il 2017-23 non e' confrontabile col recente (banco rosso): un PF buono nel recente non e' una prova.
- **Regola di lettura dei DD**: `Equity DD %` del tester e' dal PICCO; il muro FTMO del 10% e' dal saldo iniziale. Coincidono se il tratto peggiore parte all'inizio; se parte dopo un guadagno il muro concede di piu': il numero del backtest e' il caso peggiore sul percorso misurato, non la previsione certa.

## D3. Cosa ci aspettiamo dalla vostra risposta (riassunto)
Una tabella (`# · errore config · meccanismo alternativo + attesa + costo · chiuso/aperto`), un riquadro di 10 righe con le 3 cose piu' importanti, e la lista dei motori che considerate CHIUSI per davvero con il numero che li chiude. Meglio tre proposte misurabili che venti suggestive. "Nessun errore visibile" e "motore chiuso" sono risposte valide e utili.
