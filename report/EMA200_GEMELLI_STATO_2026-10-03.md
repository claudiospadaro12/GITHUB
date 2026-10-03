# EMA200 (771531): i SIMBOLI GEMELLI e i TF, stato misurato / non misurato (03/10/2026)

Sola lettura d'archivio + tre file prova nuovi. **Nessun backtest eseguito, nessuna riga di lancio, nessun forward, nessuna taglia, nessun preset toccato.**
Etichette: [MISURATO] letto da un CSV o da un referto; [DERIVATO] calcolo mio da numeri misurati (formula scritta); [INFERITO] deduzione; [NON MISURATO]; [NON RICONCILIATO] due fonti in casa che non concordano.
La cella e' quella della sedia: ABTG_EMA200, EMA 200 / EMA14 / ATR14, O1 0,20 / O2 0,30, SLatr 1,0, TP_RR 2,0, TP1Pct 50, BE e trailing accesi, due lati, rischio 1,0 (il preset vivo e' 0,65: i DD si moltiplicano per 0,65). Il motore ha UNA posizione o UN pendente alla volta per magic e simbolo (`ABTG_EMA200.mq5` r.322, `HasPosition()`/`HasPending()` r.509-528): **long e short si escludono, quindi n(L+S) NON e' n(L)+n(S)** e l'additivita' di R235 qui non e' un cancello.

## 1. Il riferimento: la sedia sul Dow (tick, 2024.09.26 -> 2026.06.30, split 40/60, deposito 100.000)

| TF | IS PF / n deal / DD% | OOS PF / n deal / DD% | fonte |
|---|---|---|---|
| M30 | 1,03404 / 508 / 10,92 | 0,90713 / 1268 / 15,87 | `risultati_prove/dal_vps/ABTG_EMA200/..._U30USD_{IS,OOS}_cemad05.csv` |
| **H1 (la sedia)** | **1,20110 / 237 / 5,73** | **1,52365 / 517 / 7,83** | R110 / R112 / r136a / cemad05 (4 corse, stessi numeri) |
| H2 | 2,59887 / 127 / 2,42 | 1,17278 / 266 / 6,12 | cemad05 |
| H3 | 2,15163 / 36 / 2,18 | 0,90825 / 170 / 9,00 | cemad05 |
| H4 | 1,66012 / 26 / 2,37 | 1,42483 / 116 / 4,45 | cemad05 |

Posizioni (non deal) all'H1: IS 132, OOS 257 (rapporto 1,795 / 2,0117, `report/EMA200_LA_PORTA_DEL_TRAILING_2026-09-18.md`). Un solo regime (toro 2024-26 con una discesa breve). Metà-anno: PF 2,05 contro 0,87 fra due metà dell'anno (`OROLOGIO_BCM_2026-09-24.md` 5.1.3): **il PF di questa famiglia oscilla molto da solo, anche senza orologio.**

## 2. TABELLA GEMELLI: misurato / non misurato (per simbolo e TF)

Sorgenti delle tabelle sotto: `risultati_archivio/EMA200/{H1_OHLC,H4_OHLC,realtick_H4}/`, `risultati_prove/ABTG_EMA200/`, `risultati_prove/risultati_scan_ABTG_EMA200_H1/`, `report/REFERTO_13_ROUND_2026-09-23.md` (R234: i CSV R234 **NON sono in repo**, i numeri vengono dal referto), `report/EMA200_RIMBALZO_STATO_DELLARTE_2026-09-30.md` sez. 2-3, `backtest_pipeline/REGISTRO_TEST.md`. Ho ricontato io i CSV con la cella esatta (O1 0,2 / O2 0,3 / TP_RR 2,0, EMA 200).
"OHLC" = Modello 1 = screening, non verdetto. La finestra degli scan OHLC e' 2024.01.01-2026.06.30, dichiarata dal driver e non dal CSV.

### D30EUR (DAX)
| TF | misurato (PF / n deal / DD%, banco, fonte) | non misurato |
|---|---|---|
| M30 | corto puro tick: OOS PF 0,950 (R234b, referto) | **L+S tick**; long; IS/n/DD del corto (non nel referto) |
| **H1** | L+S cella esatta, OHLC: **0,84842 / 777 / 14,53** (`risultati_scan_ABTG_EMA200_H1/scan_..._D30EUR.csv`); solo long OHLC 0,81733 / 408 / 10,00 e 0,79020 / 371 / 11,05; griglia L+S 0/28 positive, migliore 0,81 / n659 / DD 11,4; corto tick OOS **0,724** (R234b) | **L+S a tick reali IS/OOS** |
| H2 | corto tick OOS 0,540 | L+S |
| H3 | corto tick OOS 0,758 | L+S |
| H4 | solo long OHLC cella esatta 1,44341 / 118 / 3,89 (30/30 celle positive); L+S OHLC 23/28, 1,16 / 180 / 4,7 (cella di PF massimo); corto tick OOS 0,662 | **L+S tick**; n=59-90 posizioni [DERIVATO, rapporto 2,0]: sotto 150 comunque |
| uscita | -- | **ad asse su D30EUR: [NON MISURATO]** (solo sul Dow, R136a-d) |

### NASUSD
| TF | misurato | non misurato |
|---|---|---|
| M30 | corto tick OOS **1,230 / 569** (R234c), ESCLUSA PER COSTO (23,7x) | **L+S tick** |
| **H1** | cella esatta **assente** dalle griglie OHLC (compare solo come cella spenta, n 0); griglia L+S 0/26 positive, migliore 0,75 / n550 / DD 10,6; solo long 1/29 (0,83), solo short 0/30 (0,77); altro scan H1: 2/83 positive, migliore 1,0285 | **L+S tick IS/OOS** |
| H2 / H3 | -- | tutto |
| H4 | corto tick: OOS 1,166 ma **IS 0,318 su n=15** (R234c); `scan_ABTG_EMA200_H4_NASUSD.csv` **NON ESISTE** | **tutto il resto a H4** (unico buco della matrice dei gemelli, REGISTRO 12/09) |
| uscita | -- | [NON MISURATO]; nessun ATR(14) di NASUSD e' misurato (ANCORA_ADR sez. 4) |

### SPXUSD
| TF | misurato | note |
|---|---|---|
| M30 | L+S cella di DEFAULT (O1 0,10 / O2 0,35 / TP_RR 2): IS 0,51920 / 415 / 29,75; OOS 0,93270 / 920 / 15,29 (tick) | finestra non dichiarata nel CSV [NON VERIFICABILE] |
| H1 | default: IS 0,54644 / 223 / 17,18; OOS 0,82598 / 423 / 9,83 (tick); cella esatta assente; griglia OHLC L+S 0/27, migliore 0,76 | -- |
| H4 | cella esatta OHLC L+S **1,40060 / 138 / 2,27**; tick (valid, genetico, senza split) L 31/31 positive, PF 1,59, n74 | n basso (21-74 pos) |
| costo | **ESCLUSO PER COSTO a ogni TF**: ATR H1 10,4 (ADR ~49,9 [INFERITO, n=2] x radice(60/1380)), spread 1,40: H1 **7,4x**, H4 **14,9x** [DERIVATO]; MAPPA_COSTO sez. 5: "esclusa in modo DEFINITIVO su BCM" | |

### XAUUSD
| TF | misurato | note |
|---|---|---|
| M30 | default L+S tick IS 0,94428 / 553 / 14,41; OOS 0,92297 / 784 / 14,57 | costo M30 **36,1-36,9x**: sotto 40 |
| **H1** | **cella esatta, tick, R32a: IS 0,5643 / 270 / 15,23; OOS 1,10337 / 358 / 8,79** (30 celle IS tutte in perdita, PF 0,56-0,85) | costo H1 **51,1-52,1x**: passa. **Misurato e negativo sull'IS** (n 270 deal = 135-150 posizioni circa [DERIVATO]) |
| H4 | R264d (IS 2017-23 OHLC, L+S): PF 0,810-0,836 / n 654-880 / DD 12,7-17,1; OOS 2024-26: 1,223-1,646 / 274-397 / 5,1-6,4; R100 a 22 anni DD 55,02% | **NO PER RISCHIO** (certificato completo, `CHI_E_PIU_VICINO_AL_CAMPO_2026-09-24.md`); uscita ad asse (R264d4) |
| uscita | `InpTP1Pct` 0/25/50/75 a H4 (R264d4) | a H1: [NON MISURATO] |

### 225JPY
| TF | misurato | note |
|---|---|---|
| **H1** | cella esatta tick, R32b: **IS 1,35584 / 291 / 6,88; OOS 0,71903 / 504 / 13,43**; segno ribaltato su 30 celle | **ESCLUSO PER COSTO**: ATR H1 165,4 (ADR 793, n=9 [INFERITO]) / spread 35 (h08) o 23 (h14) = **4,7x / 7,2x** [DERIVATO]; sotto anche il pavimento duro 13,3x |
| H4 | OHLC cella esatta solo long 1,22086 / 29 / 0,35; tick valid: lungo 22/29 PF 1,10 n29 | n minuscolo |
| M30 | -- | [NON MISURATO]; costo 3,3-5,1x |

## 3. COSTO (frontiera stop >= 40 x spread), numeri miei
Stop della gamba debole = 1,0 x ATR(TF) (REGISTRO 12/09: "Stop della gamba debole = InpSLatr x ATR"); ATR(T) = ATR(H1) x radice(T/60). Spread ricalcolati io il 03/10 dai `spread_orario_*.csv`: **mediana delle 24 mediane orarie** DAX **2,70**, Nasdaq **2,40**, Dow **2,60**; mediana di sessione DAX 1,70 (ore 08-16), Nasdaq 1,70 (ore 14-21), Dow 1,90 (ore 14-21). Il motore non ha filtro d'ora: decide la mediana delle 24 (classe 650); la sessione e' il bordo ottimista.

| TF | D30EUR (ATR 70,0): sessione / 24med | NASUSD (ATR 80,2 [INFERITO]): sessione 1,80 / 24med 2,40 |
|---|---|---|
| M30 | 29,1x / 18,3x **ESCLUSA** | 31,5x / 23,6x **ESCLUSA** |
| H1 | 41,2x / 25,9x **FRAGILE** | 44,6x / 33,4x **FRAGILE** |
| H2 | 58,2x / 36,7x FRAGILE | 63,0x / 47,3x passa |
| H3 | 71,3x / 44,9x passa | 77,2x / 57,9x passa |
| H4 | 82,4x / 51,9x passa | 89,1x / 66,8x passa |

- **Il Dow H1 stesso e' FRAGILE**: 78,0-88,2 di ATR misurato = 39,0-44,1x a spread 2,00, 30,0-33,9x a 2,60 (stessa formula): la sedia passa il 40x solo a spread di sessione.
- **Bande**: se l'ATR DAX fosse 51,5 (la legge W=1440 del 17/09, smentita il 18/09 con -26,2% su H4 misurato) H1 scende a 30,3x/19,1x; per NASUSD l'ancora alternativa di R234c (ATR H1 64,1) da' H1 35,6x/26,7x e H2 50,4x/37,8x. **Il verdetto fra FRAGILE ed ESCLUSA dipende dall'ancora ed e' dichiarato nei file prova.**
- [NON RICONCILIATO] (1) MAPPA_COSTO e R234c citano 2,70 (Nasdaq) e 3,00 (Dow) come "mediana delle 24": dal CSV io ricavo 2,40 e 2,60; il DAX 2,70 coincide. Nei file riporto entrambe. (2) Il REGISTRO 12/09 scrive per la sedia Dow "33,6-45,2x": con la mia formula ottengo 39,0-44,1x a 2,00; la convenzione dello spread usata la' non l'ho ritrovata.
- **Conseguenza dichiarata prima dei numeri**: a H1 su DAX/Nasdaq questo round non puo' produrre una cella PROMUOVIBILE al 40x onesto, solo FRAGILE (come la sedia). Le celle H3/H4 passano il costo ma hanno n troppo piccolo. Il round serve a **chiudere la casella "gemelli, cella intera, tick"**, non a trovare una sedia.

## 4. Cosa si fa girare (file in `backtest_pipeline/prove/`, tutti e tre ASCII, `controlla_prova.py` 0 problemi, `controlla_riga.py --oggetto prova` nessun difetto meccanico)
Stessa cella della sedia, **nessuna griglia nuova**: l'unico asse e' il TF (stesso asse del collaudo sul Dow). Finestra, split e banco identici a R110/R234 (2024.09.26 -> 2026.06.30, 40/60, tick reali).
- `EMAGEM_a_ancora_U30USD_H1_LS.txt` — **cancello crociato T1**: U30USD H1 L+S con due celle gemelle sul magic (766801/766802) deve riprodurre al centesimo IS 1,20110 / 5,7325 / 237 e OOS 1,52365 / 7,8323 / 517. 4 passate. Se non torna, **b e c non si leggono**.
- `EMAGEM_b_D30EUR_LS_tf.txt` — D30EUR L+S, asse InpTF (M30 H1 H2 H3 H4), magic 766811. 10 passate.
- `EMAGEM_c_NASUSD_LS_tf.txt` — NASUSD L+S, stesso asse, magic 766821. 10 passate.
**Totale 24 passate, 3 round.** I tre magic 7668xx: 0 occorrenze in tutto il repo prima di questi file.

**Attese scritte nei file prima dei numeri**: H1 su DAX e Nasdaq OOS PF 0,70-0,95 (centro 0,82 e 0,80), DD OOS 8-16% (sopra il muro del 10%), n totale 450-1.100 (DAX) e 400-800 (Nasdaq) deal, scalato dal rapporto tick/OHLC misurato sul Dow (x1,97 per mese); M30 PF < 1; H2-H4 non letti per il merito (n IS atteso ~130/40/30 come sul Dow).
**Cosa smentisce l'attesa (T6, congelato)**: H1 o H2 con OOS PF >= 1,10, OOS n >= 300 deal, IS PF >= 1,00 e DD OOS <= 10% -> "la cella e' del Dow" e' falsa per quel simbolo; la cella entra in coda come CANDIDATA gemella (mai in campo in automatico), col per-trade a contare le posizioni e T2 a dire se e' FRAGILE o promovibile. Se nessuna cella ha OOS n >= 300 il round **non ha falsificato niente** e si scrive "NON ANCORA MISURATO PER IL MERITO".
**Altre soglie**: T3 rischio a qualunque n (DD <= 10% a rischio 1,0); T4 merito solo con OOS n >= 300 deal (proxy di 150 posizioni; rapporto deal/posizione 2,0117 misurato sul Dow, [NON MISURATO] su DAX/Nasdaq); T5 altopiano, non picco; T7 nessuna promozione.
**Finestra e regime**: 642 giorni, 91,7 settimane, ~10.500 barre H1 (M30 ~21.000, H4 ~2.600: tutte sotto il tetto di ~100.000). **Un solo regime** (indici BCM a tick dal 2024.09.26, toro con una discesa breve): Emendamento C non soddisfatto e non soddisfabile su BCM. IS 256 giorni e OOS 385: l'IS a posizioni sara' sotto 150 quasi certamente; si legge come segno.

## 5. Orologio (dal 26/10 DAX, dal 02/11 USA)
- Il motore **non ha filtro d'ora**: `InpUseCutoff=false` (r.449 esce subito), `InpFridayClose=false` (r.279), news spenti, `InpMaxTradesPerDay=0`. L'ora entra solo nel riconoscimento della barra (`iTime(InpTF,0)` r.294) e nella scadenza dei pendenti (6 barre, r.378).
- **A H1 la cella NON e' sensibile all'ora** [ragionamento dal sorgente, non una misura]: i bordi H1 sono ore piene e BCM e' UTC+1 fisso sui tick indici; dal 26/10 e 02/11 cambia il rapporto con l'apertura cash, non la griglia delle barre. Coerente con `OROLOGIO_BCM_2026-09-24.md` 5.1.1: "771531 e 770511 non hanno ingressi orari attivi... non sono sfasate".
- **A H2/H3/H4 la composizione della barra rispetto alla cassa cambia con la stagione** (griglia dalla mezzanotte server): effetto **[NON MISURATO]**, il banco contiene due inverni ma non lo isola.
- Contro-esempio: la stessa 771531 fa PF 2,05 contro 0,87 fra due meta' dell'anno senza essere sensibile all'ora. **Nessuna differenza stagionale si attribuisce all'orologio.**
- Per XAUUSD e 225JPY il banco attraversa il cambio d'orologio del forex (fra il 26/12/2024 e il 02/02/2025, giorno esatto [NON MISURATO]); a H1 la griglia non cambia comunque. Non preparo file per loro (sez. 6).

## 6. Perche' non preparo file per SPXUSD, XAUUSD, 225JPY
- **SPXUSD, 225JPY: esclusi PER COSTO col numero** (SPX H1 7,4x / H4 14,9x; 225JPY H1 4,7-7,2x): il costo li chiude prima del PF, e a H4 il 40x resta sotto. Non e' pigrizia: e' la frontiera.
- **XAUUSD**: H1 passa il costo (51-52x) ed e' **gia' misurato a tick sulla cella esatta con split** (R32a: IS 0,56, n 270 deal; OOS 1,10): un IS negativo su tutte e 30 le celle. H4 e' chiuso da R264d (NO PER RISCHIO) col certificato completo. Il TF M30 e' sotto 40x (36,1-36,9x). Resterebbe solo l'uscita ad asse a H1: **non la preparo** perche' sarebbe una griglia su una cella con IS in perdita (regola del 19/08).
- NASUSD H4 resta un buco del solo archivio: coperto dall'asse TF del file c (H4 e' la cella 5).

## 7. Tempo macchina (PC di backtest `DESKTOP-H4D7CAJ`, mai il VPS, tick reali, deposito 100.000)
Base misurata: R112 = 16 passate in 0,1 ore = 11-34 s/passata sul Dow (67,6 M tick). Tick totali al 30/08 (`risultati_archivio/misura_tick/`): D30EUR 35,4 M (0,52x il Dow), NASUSD 166,5 M (2,46x).
- a: 4 passate = 0,7-2,3 min. b: 10 passate = 1-3 min [DERIVATO se il tempo e' proporzionale ai tick: **ASSUNZIONE non provata**]. c: 10 passate = 4,5-14 min. Piu' avvio/compilazione per round [NON MISURATO].
- Tetto alto, dalla media MISURATA dei 13 round del 23/09 (133 min / 94 passate = 1,41 min/passata tutto compreso): 24 passate = ~34 min.
- **Banda dichiarata: 8-34 minuti per i tre round.** M30 e' piu' lento degli altri TF [NON MISURATO].
- **Rilievo per chi prepara la riga**: i tre file vanno nella STESSA riga, **a per primo**, con **`-Deposito 100000`** (il driver non ha `@DEPOSITO`, default 10000: a 10000 il lotto viene troncato e T1 fallirebbe, ed e' proprio il suo lavoro). MT5 chiuso sul PC di backtest.

## 8. BUCHI DICHIARATI
1. I CSV di R234a-c **non sono in repo**: i numeri del corto vengono dal referto del 23/09 (PF OOS solo, senza IS/n/DD per D30EUR e Nasdaq).
2. Nessun ATR(14) di NASUSD e' misurato; l'ATR H1 del DAX viene da una legge validata solo a H4 (+0,3%, n=3); due ancore in casa per il Nasdaq (80,2 e 64,1).
3. Il rapporto deal/posizione (2,0117) e' misurato solo sul Dow: il proxy "300 deal = 150 posizioni" su DAX/Nasdaq e' [NON MISURATO].
4. Le tabelle a cella di DEFAULT (SPX, XAU: O1 0,10 / O2 0,35) NON sono la cella della sedia, e la loro finestra non e' dichiarata nel CSV.
5. L'uscita (TP1Pct, BE, trailing, SLatr) non e' ad asse su nessun gemello a H1: casella 3 del certificato **[NON MISURATO]**; non la preparo ora (griglia su motori senza edge accertata).
6. Un solo regime, per costruzione dei dati BCM sugli indici; l'unica prova di regime possibile (DAX e SPX HistData 2010-2018) e' un altro feed e un altro orologio: un file a parte, non preparato.
7. Il binario in campo della 771531 non e' HEAD (Guardian assente): non tocca queste misure, che girano su HEAD.
8. Questo documento NON archivia nessun candidato come MORTO e NON promuove niente.
