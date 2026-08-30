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

## VERDETTO PROVVISORIO
Il motore drive-following delle aperture Nasdaq mostra una FORMA VERDE a OHLC su
un arco multi-regime — il miglior segnale della sessione. I filtri F1/F3 non
affilano l'edge (il nudo e' gia' il migliore) ma domano la coda di rischio.
**Prossimo passo obbligato: la lettura PER REGIME (serve il per-trade CSV), poi
la conferma a tick sulla cassaforte 2024.09->2026.** Nessun forward toccato.
