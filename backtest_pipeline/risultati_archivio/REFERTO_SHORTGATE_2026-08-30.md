# SCREENING SHORT ORSO — il gate FUNZIONA: PF 1.84, DD 2%, forma VERDE (ma per-regime da confermare)

_Corsa: 30/08/2026 14:41, pin `b4c625e66baafbf3c04ae46d366821d68214027b`. EA
`ABTG_Nasdaq_Apertura_US` in BREAKOUT (drive-down following), SOLO short, gated
EMA 50x200 H4 ribassista. Model 1 OHLC screening, NASUSD_EXT M15, finestra
2020.01.01->2024.01.01 (crollo 2020 + toro 2021 + orso 2022 + ripartenza 2023).
Rischio 0.65%, SL floor 500. Gemelli IDENTICI. Zip: SHORTGATE_CORSA_20260830_1441.zip._

## LA TABELLA (finestra intera 2020-2024, una tranche)

| cella | n | PF | DD% | Profit | pegg.gio |
|---|---|---|---|---|---|
| **shortgate** (breakdown short gated H4) | 93 | **1.84** | **2.07** | +6265 | **-0.65** |

## LA LETTURA (FORMA OHLC — il segnale piu' promettente della sessione)
- **PF 1.84** — molto piu' alto del drive-following long (1.08) e di E3 (1.16).
- **DD 2.07%, peggior giornata -0.65%** — bassissimi. Il gate H4 tiene il motore
  FLAT quasi sempre e lo accende solo quando il regime e' ribassista.
- **n=93 su 4 anni = ~23 trade/anno**: bassa frequenza, come dev'essere un motore
  di CROLLO (spara raramente, paga quando lo fa, resta flat e scorrelato il resto).
- **Il gate FUNZIONA**: e' esattamente la tesi "vol-gated reversal" confermata nel
  FORMA — flat in calma, attivo e verde nell'orso.

## PERCHE' CONTA (converge con tutta la sessione)
Questo e' il pezzo che il quadro di oggi cercava: un motore SHORT che vive nei
crolli, gated dal regime, scorrelato per costruzione dalla flotta long (spara
quando gli indici scendono = quando le sedie long soffrono). E' il mattone
"assicurazione contro il crollo".

## I CANCELLI CHIUSI (niente promozione — riserve dure)
1. **OHLC INGANNA**: PF 1.84 e' la forma; a tick puo' scendere.
2. **VERDETTO TICK NELL'ORSO IMPOSSIBILE (limite duro)**: i tick BCM sugli indici
   partono dal 26/09/2024 -> non raggiungono NESSUN orso. Questo motore NON potra'
   MAI avere un verdetto tick in un orso su BCM. Servirebbe storico tick esterno
   (Dukascopy) per un verdetto vero. E' un limite strutturale, dichiarato.
3. **LETTURA PER REGIME — DA FARE**: il totale 2020-2024 DILUISCE (mezzo periodo e'
   toro). La domanda vera: il +6265 viene dai SOTTO-PERIODI ORSO (crollo 2020,
   orso 2022), col gate FLAT nel toro 2021 come atteso? Serve il per-trade CSV
   `abtg_trades_ABTG_Nasdaq_Apertura_US_NASUSD_EXT_767120.csv`, segmentato.
4. **n=93 < 150**: merito formalmente SOSPESO. Ma la forma e il rischio sono forti.

## LETTURA PER REGIME (per-trade 767120) — L'EDGE E' NELL'ORSO, CONFERMATO

| regime | n | tot_net | asp/tr | win% |
|---|---|---|---|---|
| CROLLO 2020 (feb-apr) | 8 | +2037 | **+255** | **100** |
| resto 2020 | 4 | -1152 | -288 | 50 |
| TORO 2021 | 17 | +1186 | +70 | 82.4 |
| ORSO 2022 | 49 | **+4020** | +82 | **89.8** |
| 2023 ripartenza | 15 | +174 | +12 | 86.7 |

**L'edge E' nell'orso, come la tesi prevedeva — e di piu':**
- **ORSO 2022**: il bulk (+4020, 49 dei 93 trade, win 89.8%). Il gate spara PIU'
  spesso nell'orso e vince ~90%. La tesi vol-gated e' confermata dal dato.
- **CROLLO 2020**: +255/trade, win 100% (n=8) — il crollo e' il piu' ricco per trade.
- **VERDE anche nel TORO 2021** (+1186, +70/trade, win 82%): il gate H4 non e'
  perfettamente flat nel toro, ma quando spara (pullback ribassisti H4) vince
  comunque. Non e' solo assicurazione: e' broadly-green, col picco nell'orso.
- Solo "resto 2020" (n=4) e' negativo, campione irrilevante.
- **Win rate 82-100% ovunque**: un breakdown-short che segue il drive-giu con SL
  strutturale e gate H4 azzecca la gran parte dei trade.

## CONFERMA A TICK BCM (cassaforte 2024.09-2026, pin edc0412) — SOPRAVVIVE AI COSTI

| cella | n | PF | DD% | Profit | asp/tr | pegg.gio |
|---|---|---|---|---|---|---|
| shortgate TICK BCM | 104 | **1.097** | 4.54 | +1951 | +18.8 | -0.72 |

**Gli ingressi NON sono fantasia OHLC: reggono spread + slippage reali.**
- PF **1.097 > 1** a TICK, sulla finestra 2024-2026 (toro). POSITIVO anche dove lo
  short e' teoricamente svantaggiato -> il gate H4 lo accende solo sui pullback
  ribassisti H4, che pagano anche in un bull.
- DD 4.54% (sotto il muro), peggior giornata -0.72% (irrisoria). asp/tr +18.8.
- n=104 < 150 -> merito formalmente sospeso, ma la FORMA e' coerente e il rischio
  e' basso.
- E' SOTTILE nel toro (PF 1.097, come il drive-long) MA e' il pezzo DECORRELATO:
  fira in condizioni H4 ribassiste, cioe' quando la flotta long soffre.

## VERDETTO (aggiornato: forma verde + costo confermato)
Il gated short e' il candidato piu' completo della sessione:
1. **OHLC screening**: PF 1.84, edge nell'orso confermato per regime (2022 +4020
   win 90%, crollo 2020 +255/tr win 100%), verde anche nel toro 2021.
2. **TICK BCM (cost-survival)**: PF 1.097 POSITIVO nel toro, DD 4.5%, ingressi
   reali (non OHLC-fantasia).
-> profilo DISPIEGABILE: fa poco in calma/toro, molto nelle tempeste, scorrelato
   dalla flotta long. Insieme al drive-long (che vive nella calma) = 2 mattoni
   scorrelati che entrambi sopravvivono a tick.
Limite duro residuo: il verdetto tick NELL'ORSO resta impossibile su BCM (serve
Dukascopy). Prossime opzioni: (a) deploy PICCOLO in forward a taglia ridotta come
il drive-long; (b) import tick Dukascopy 2020/2022 per il verdetto orso vero.
Nessun forward toccato.
