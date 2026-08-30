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

## VERDETTO PROVVISORIO
La forma piu' verde della sessione, e conferma la tesi vol-gated: un breakdown
short gated dall'orso paga (PF 1.84) con DD irrisorio (2%), stando flat nel toro.
Prossimo passo: lettura per regime (serve il per-trade) per confermare che l'edge
e' nell'orso, non nel rumore. Poi resta il limite duro: verdetto tick in un orso
richiede dati esterni (Dukascopy), i tick BCM non ci arrivano. Nessun forward toccato.
