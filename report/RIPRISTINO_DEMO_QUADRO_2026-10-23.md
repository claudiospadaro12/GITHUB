# Ripristino delle sedie sui demo piccolo e 100k: quadro e lista dei set (23/10/2026)

**Non controllata da agenti. Sola lettura del repo: nessun terminale, preset o sedia e stato toccato.** Sorgenti: sonda `CODA_01_sedie_attaccate_20261023_033006.log` (stato di stanotte), `CODA_08_preset_dai_chr_20260925_033004.log` (configurazioni del piccolo prima della sospensione) e `CODA_08_..._20260924_...` (100k), `SOSPENSIONE_SEDIE_DEMO_2026-09-25.md`.

## 1. Stato oggi (23/10, 03:30)
- **Piccolo 50503392** (`C:\Program Files\BCM Markets MT5 Terminal`, profilo `ORO`): **56 grafici attivi**, forex e oro piu molti EA demo del Market. **Le 15 sedie su indici (e il 225JPY) sospese il 25/09 NON ci sono**, e non restano come residui: vanno ricreate.
- **100k 50504263** (`... -V3`, profilo `SQUADRA 100K`): **2 grafici** (TradeExporter EURUSD, Guardian 779001 AUDNZD). Nel profilo `Default` restano **6 residui** (Guardian AUDCAD, DAX 770101, Dow 770202, MaxMin 770411, SupertrendReversal 225JPY 770901, ORB 770611) a rischio 0,65 / 0,3.
- Non toccati e non in questo elenco: reale 10105439 (Guardian FAILED, ORB EURAUD), manuale 50503635, banco 50504400.

## 2. Perche erano state tolte (25/09) e se vale ancora
FTMO aveva risposto che il divieto di posizioni opposte fra conti vale anche sui demo e su indici correlati. Dai documenti: **challenge 541452707 finita il 30/09, free trial 1514806751 scaduta il 14/10** (`HANDOFF.md`, `FTMO_TRIAL_AUTOPSIA_2026-10-08.md`): **nessun conto FTMO attivo risulta oggi**. Se ne apri uno nuovo il divieto torna valido. **Conferma tua necessaria.**

## 3. Prima di rimetterle: l'orologio (BCM e UTC+1 fisso)
Le ore dei set sono quelle d'ESTATE (italiana -1). **Dal lun 26/10** BCM = ora italiana: Xetra apre alle 09:00 server. **Dal lun 02/11** (USA in ora solare) la cash apre alle 15:30 server.
| sedia | ora nel set | se la vuoi all'apertura cash |
|---|---|---|
| DAX Apertura 770101 | SessionHour 8, Close 17 | **dal 26/10**: 9 e 18 |
| MaxMin DAX short 770411 | box 23-04, place 07, cutoff 08, close 17 | **dal 26/10**: tutto +1h (box 00-05, place 08, cutoff 09, close 18) |
| Dow Apertura 770202 | SessionHour 14, Close 17 | **dal 02/11**: 15 e 18 |
| ORB Dow 770611 | range 14-14, End 21 | **dal 02/11**: 15-15, End 22 |
| Nasdaq Apertura 770250 | SessionHour 14, Close 20 | **dal 02/11**: 15 e 21 (oppure l'EA `_Sicuro`, che lo fa da solo) |
Se li rimetti **com'erano**, dal 26/10 (DAX) e dal 02/11 (USA) armano un'ora PRIMA dell'apertura: e il caso studiato in `DECISIONE_OROLOGIO_INVERNALE_BCM_2026-10-11.md`; la scelta e tua. **Non dipendono dall'ora**: PTE, GapFill x2, PunteLarry, GapContinuation 225JPY (Tokyo), SuperWave, SupertrendReversal, SuperWave Dow, SupRev DAX e NAS.

## 4. Set da caricare (ricostruiti dai grafici, nessun valore modificato)
Cartella `mql5/Presets/RIPRISTINO_DEMO_20261023/` (20 file).
### Piccolo 50503392 (15)
| EA | grafico | magic | rischio | lati | ore (server, estate) | set |
|---|---|---|---|---|---|---|
| PTE | U30USD H1 | 771321 | 1.0% | LS | - | `ABTG_PTE_U30USD_H1_771321_PICCOLO.set` |
| GapFill | U30USD H1 | 772234 | 1.0% | LS | MaxHours=48 | `ABTG_GapFill_U30USD_H1_772234_PICCOLO.set` |
| GapFill | 225JPY H1 | 772235 | 1.0% | LS | MaxHours=48 | `ABTG_GapFill_225JPY_H1_772235_PICCOLO.set` |
| PunteLarry | U30USD H1 | 772341 | 1.0% | LS | - | `ABTG_PunteLarry_U30USD_H1_772341_PICCOLO.set` |
| GapContinuation | 225JPY M1 | 774101 | -% | LS | SessionOpenHour=1, SessionCloseHour=7 | `ABTG_GapContinuation_225JPY_M1_774101_PICCOLO.set` |
| SuperWave | U30USD H4 | 770531 | 1.0% | LS | StartHour=0, EndHour=24 | `ABTG_SuperWave_U30USD_H4_770531_PICCOLO.set` |
| DAX_Apertura_EU | D30EUR M5 | 770101 | 1.0% | L | SessionHour=8, CloseHour=17 | `ABTG_DAX_Apertura_EU_D30EUR_M5_770101_PICCOLO.set` |
| Dow_Apertura_US | U30USD M5 | 770202 | 1.0% | L | SessionHour=14, CloseHour=17 | `ABTG_Dow_Apertura_US_U30USD_M5_770202_PICCOLO.set` |
| MaxMinNotte_DAX_Short_Ottimizzato | D30EUR M15 | 770411 | 1.0% | S | BoxStartHour=23, BoxEndHour=4, PlaceHour=7, EntryCutoffHour=8, CloseHour=17 | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_M15_770411_PICCOLO.set` |
| SupertrendReversal | 225JPY H2 | 770924 | 1.0% | LS | StartHour=0, EndHour=24, FridayCloseHour=20 | `ABTG_SupertrendReversal_225JPY_H2_770924_PICCOLO.set` |
| SuperWave_DOW_H1_Ottimizzato | U30USD H1 | 770511 | 1.0% | LS | StartHour=0, EndHour=24 | `ABTG_SuperWave_DOW_H1_Ottimizzato_U30USD_H1_770511_PICCOLO.set` |
| SupRev_DAX_H4_Ottimizzato | D30EUR H4 | 970912 | 1.0% | LS | StartHour=0, EndHour=24 | `ABTG_SupRev_DAX_H4_Ottimizzato_D30EUR_H4_970912_PICCOLO.set` |
| SupRev_NAS_H1_Ottimizzato | NASUSD H1 | 970913 | 1.0% | LS | StartHour=0, EndHour=24 | `ABTG_SupRev_NAS_H1_Ottimizzato_NASUSD_H1_970913_PICCOLO.set` |
| ORB_Ottimizzato | U30USD M5 | 770611 | 1.0% | L | RangeStartHour=14, RangeEndHour=14, EndHour=21 | `ABTG_ORB_Ottimizzato_U30USD_M5_770611_PICCOLO.set` |
| Nasdaq_Apertura_US | NASUSD M15 | 770250 | 0.35% | S | SessionHour=14, CloseHour=20 | `ABTG_Nasdaq_Apertura_US_NASUSD_M15_770250_PICCOLO.set` |
### 100k 50504263 (5; il Guardian 779001 e il TradeExporter ci sono gia)
| EA | grafico | magic | rischio | lati | ore (server, estate) | set |
|---|---|---|---|---|---|---|
| DAX_Apertura_EU | D30EUR M5 | 770101 | 0.65% | L | SessionHour=8, CloseHour=17 | `ABTG_DAX_Apertura_EU_D30EUR_M5_770101_100K.set` |
| Dow_Apertura_US | U30USD M5 | 770202 | 0.65% | L | SessionHour=14, CloseHour=17 | `ABTG_Dow_Apertura_US_U30USD_M5_770202_100K.set` |
| MaxMinNotte_DAX_Short_Ottimizzato | D30EUR M15 | 770411 | 0.65% | S | BoxStartHour=23, BoxEndHour=4, PlaceHour=7, EntryCutoffHour=8, CloseHour=17 | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_M15_770411_100K.set` |
| SupertrendReversal | 225JPY H2 | 770901 | 0.65% | LS | StartHour=0, EndHour=24, FridayCloseHour=20 | `ABTG_SupertrendReversal_225JPY_H2_770901_100K.set` |
| ORB_Ottimizzato | U30USD M5 | 770611 | 0.3% | L | RangeStartHour=14, RangeEndHour=14, EndHour=21 | `ABTG_ORB_Ottimizzato_U30USD_M5_770611_100K.set` |

## 5. Come
Per ogni sedia: nuovo grafico del simbolo e TF in tabella, trascina l'EA, scheda Input, Carica il `.set`, controlla a vista magic e rischio, Algo Trading del grafico acceso. **Non premere il pulsante generale Algo Trading** (spegnerebbe Guardian, TradeExporter e le altre). Sul 100k non cambiare profilo: `Default` contiene residui con il Guardian su AUDCAD. Piccolo e 100k hanno cartelle quasi uguali (`-V3` e il 100k).

## 6. Da sapere
- Rimettere tutte le sedie su indici insieme ricrea la correlazione di prima (DAX, Dow, Nasdaq, ORB, MaxMin): rischio sommato quello di allora.
- Il Nasdaq 770250 era SOLO SHORT a 0,35%.
- Nessuna taglia modificata. Il piccolo ha anche molti EA demo del Market attaccati: non cambiano.
