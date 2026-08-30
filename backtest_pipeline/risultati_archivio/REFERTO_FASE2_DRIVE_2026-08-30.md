# FASE 2 DRIVE — il motore delle aperture e' VERDE nel FORMA (OHLC), i filtri NON affilano l'edge

_Corsa: 30/08/2026 07:40, pin `c222f3dd0cfb64d877c8133a2420d0e160ae2565`,
driver `RIGA_FASE2_DRIVE.ps1`. EA `ABTG_Nasdaq_Apertura_US` in BREAKOUT
(drive-following), gestione TUTTO RUNNER (RunnerTP=-1, ClosePct=0), SL floor
500 (R109). **MODELLO 1 (OHLC screening), NON verdetto tick.** NASUSD_EXT M15,
finestra intera 2017.01.01->2020.07.01 (una tranche). Rischio 1.0% (pinnato nei
prova). Gemelli IDENTICI su tutte le celle. Zip: FASE2_DRIVE_CORSA_20260830_0740.zip._

## LA TABELLA (finestra intera 2017-2020, ablazione a stella)

| cella | n | PF | DD% (@1.0%) | Profit | asp/trade | pegg.gio% |
|---|---|---|---|---|---|---|
| **00_baseline** (nudo) | **832** | **1.32** | 15.60 | +141664 | **+170** | -9.35 |
| 01_F1_k10 (F1 k=1.0) | 170 | 1.39 | 18.30 | +30498 | +179 | -12.96 |
| 02_F1_k15 (F1 k=1.5) | 166 | 1.24 | 14.85 | +18265 | +110 | -1.00 |
| 03_F3_ema (F3 HTF EMA) | 547 | 1.19 | 13.27 | +55433 | +101 | -1.00 |

_(DD a rischio 1.0%; alla taglia di casa 0.65% scala a ~2/3: baseline ~10%, F3 ~8.6%.)_

## IL RISULTATO GROSSO: il drive-following NUDO ha edge, su piu' regimi
**PF 1.32 su 832 trade** (n>=150, merito MISURABILE) su una finestra che contiene
toro 2017 + orso Q4-2018 + laterale 2019 + crollo/V 2020. Al TETTO OHLC, la FORMA
e' **verde**: il drive delle aperture Nasdaq **e' raccoglibile**, il RIENTRO non lo
uccide. E' il primo motore verde della sessione. **Non e' una moneta.**

## MA la domanda della FASE 2 e' ribaltata dal risultato
Il contratto chiedeva: "esiste un filtro (F1/F3) che rende il drive-following un
motore e non una moneta?" La risposta misurata: **il baseline NON e' una moneta**
(PF 1.32 nudo), quindi non ha BISOGNO del filtro per avere edge. E i filtri **non
affilano l'edge**:
- **F1 k=1.0**: PF 1.39 e asp/trade +179 (marginale sopra il nudo), MA DD PEGGIORE
  (18.3%), taglia l'80% dei trade (832->170), ed e' CONFUSO col cambio di timing
  (pendente -> mercato-su-chiusura, dichiarato). Non vince: DD non sotto il muro.
- **F1 k=1.5**: PF 1.24, asp/trade +110 -> PEGGIO del nudo. Piu' stretto = peggio.
- **F3 (EMA H1)**: PF 1.19, asp/trade +101 -> PEGGIO del nudo sull'edge. Taglia
  volume e qualita' per trade.
- Criteri par.5: un filtro VINCE solo con asp/trade positiva E STABILE E DD sotto
  il muro. **Nessun filtro vince.** Il baseline e' il migliore sull'edge.

## DOVE i filtri SERVONO: la coda di rischio, non l'edge
Il baseline ha **peggior giornata -9.35%** (vicino al muro): e' il costo del TUTTO
RUNNER (scelta diagnostica, per non mascherare l'edge). F1 k1.5 e F3 tagliano la
peggior giornata a **-1.00%** (-9.35 -> -1.00, enorme). Cioe': i filtri non
migliorano il MERITO, ma domano il RISCHIO. Esattamente la lezione della scelta
all-runner: prima misuri l'edge (verde), poi lo addolcisci per la prop (filtro
e/o parziale = gestione, §5F).

## I TRE CANCELLI ANCORA CHIUSI (niente promozione, e' uno screening)
1. **OHLC INGANNA**: PF 1.32 e' la FORMA, non il numero. A tick (con slippage e
   ordine dei tick nel breakout) puo' scendere. Verdetto tick SOLO sulla
   cassaforte 2024.09->2026 (BCM), che si apre dopo.
2. **LETTURA PER REGIME — LA DECISIVA — ANCORA DA FARE**: il totale 2017-2020
   DILUISCE. La domanda vera e': l'edge SOPRAVVIVE all'orso Q4-2018 e al crollo
   2020, o e' tutto toro-2017 + laterale-2019? Si legge dal per-trade CSV
   `abtg_trades_..._NASUSD_EXT_<magic>.csv` in Common\Files (NON nello zip):
   somma net_profit per finestra di regime. **Serve quel CSV.**
3. **DD sopra/vicino al muro**: baseline 15.6% @1.0% (~10% @0.65%). Da gestire.

## LETTURA PER REGIME (per-trade CSV 767200 baseline / 767230 F3) — LA DECISIVA

**BASELINE nudo (767200), net_profit sommato per regime:**

| regime | n | tot_net | asp/trade | win% |
|---|---|---|---|---|
| 2017 TORO | 212 | +30794 | +145 | 46.7 |
| Q4-2018 ORSO | 64 | +22983 | **+359** | 46.9 |
| 2019 LATERALE | 248 | +27456 | +111 | 37.9 |
| 2020 (feb-apr, crollo+V) | 46 | +40246 | **+875** | 50.0 |

**L'EDGE SOPRAVVIVE A OGNI REGIME, ed e' PIU' FORTE nell'orso e nel crollo.**
Non e' un artefatto toro. Un drive-follower si nutre di volatilita' -> shine
proprio dove gli indici si muovono di piu'. Verde in toro, orso, laterale, crollo.

**F3 EMA (767230): PEGGIORA proprio nei regimi stressati** — Q4-2018 asp +10
(vs +359 nudo), 2020 intero NEGATIVO (-26/trade). Il filtro HTF fa whipsaw nel
crollo/V e blocca i drive migliori. **F3 bocciato, e la lettura per regime spiega
perche'.**

## IL LATO SHORT (la domanda di Claudio) — misurato, onesto: edge NARROW, solo crolli veri
Split del baseline per LATO e per fase (mapping close-deal confermato sul toro 2017):

| finestra | LONG n / net / asp | SHORT n / net / asp |
|---|---|---|
| CROLLO-GIU (20feb-23mar 2020) | 12 / +4871 / +406 | **7 / +11108 / +1587** |
| RIPRESA-V (24mar-30apr 2020) | 14 / +26486 / +1892 | 12 / -6074 / -506 |
| Q4-2018 orso (choppy) | 30 / +22044 / +735 | 34 / +939 / **+28 (~piatto)** |
| 2017 toro | 118 / +31104 | 94 / -310 |

- **Il LONG e' il pane**: positivo in OGNI regime, enorme nella ripresa-V (+1892),
  forte anche nell'orso Q4-2018 (i rimbalzi ribassisti sono drive UP violenti).
- **Lo SHORT ha edge VERO solo nel CROLLO-GIU genuino** (2020 feb-mar: +1587/trade,
  il piu' alto in assoluto). Nell'orso CHOPPY (Q4-2018) e' ~piatto (+28); nei
  range e nella ripresa PERDE. **Lo short degli indici e' un fenomeno da CROLLO
  RAPIDO, non da orso generico** — e il motore simmetrico lo raccoglie da solo
  (lo short ha fatto +11108 nel crollo 2020 senza che glielo chiedessimo).

## VERDETTO PROVVISORIO (aggiornato con la lettura per regime)
1. **Il drive-following delle aperture Nasdaq e' un motore VERDE e ROBUSTO PER
   REGIME** al tetto OHLC (positivo toro/orso/laterale/crollo, piu' forte nello
   stress). E' il miglior candidato della sessione, e risponde al "motore Nasdaq".
2. **Il LONG e' il breadwinner**; lo SHORT aggiunge edge solo nei crolli rapidi
   (ma li' e' fortissimo). Un motore SIMMETRICO cattura entrambi: il long ogni
   giorno, lo short quando arriva il crollo. **Risposta alla domanda short:
   esiste, ma e' crash-concentrato — misurato con orso e crollo nei dati.**
3. **F1/F3 non affilano l'edge**; domano il rischio (peggior giornata) ma non lo
   portano sotto il muro da soli. DD 15.6%@1.0% (~10%@0.65%) da gestire.

## I DUE CANCELLI CHE RESTANO
- **OHLC INGANNA** (specie il crollo: barre enormi = ingressi/uscite OHLC molto
  ottimistici). Il verdetto a tick e' possibile SOLO sulla cassaforte 2024.09->
  2026 (BCM): li' si conferma il FORMA, e li' cade il de-2022/de-2023.
- **DD sopra il muro**: si gestisce con la parziale (che avevamo tolto per la
  diagnostica) e/o una taglia piu' bassa. Gestione, non motore (§5F).

**Nessun forward toccato. Prossimo passo: portare il motore simmetrico sulla
cassaforte 2024-2026 a TICK, con la parziale rimessa, per il verdetto vero.**
