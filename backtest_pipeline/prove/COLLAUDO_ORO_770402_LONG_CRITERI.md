# COLLAUDO ORO 770402 SOLO LONG -- CRITERI CONGELATI PRIMA DEI NUMERI (27/09/2026)

**Questo file si committa PRIMA di calcolare un solo numero sotto stress.** I numeri gia' noti
al momento della stesura sono SOLO quelli del referto di provenienza (base, degrado zero) e la
calibrazione del cambio `q` (par. 4), che e' una conversione di unita', non un risultato.

## 1. La cella
- EA `ABTG_MaxMinNotte` (binario HEAD `7d0da9f9`), **XAUUSD H2**, sedia di provenienza **770402**,
  variante **solo LONG** (`InpAllowShort=false`), magic di banco **795301** (gemello 795351).
- Parametri: quelli di `backtest_pipeline/prove/R260a_oro_770402_solo_long.txt` (= cella R103 input
  per input salvo `InpAllowShort`, `InpComment`, `InpMagic`); box 23:00-04:59, piazzamento 07:00,
  cutoff 08:30, buffer 250 pt, `InpSLMode=0` (stop = estremo opposto del box), TP1 1R 50% + BE,
  TP2 2,5R 50%, target EMA200, TP finale 4R, trailing 2xATR, chiusura 17:30 (ora server BCM).
- Corsa: OHLC M1 (Modello 1), 2020.01.01 -> 2026.06.30, deposito 100000, rischio 0,5%.
- Fonte: `backtest_pipeline/risultati_archivio/ROUND_CORTI_B_2026-09-27/PERTRADE/abtg_trades_ABTG_MaxMinNotte_XAUUSD_795301.csv`
  (375 deal d'uscita = 279 posizioni). Referto: `report/REFERTO_ROUND_CORTI_B_2026-09-27.md` par. 1 e 5
  (PF in posizioni 1,3357, DD saldo chiuso con k 4,1549%).
- Richiesta di origine: `docs/RISPOSTA_GEMINI_2026-09-27.md` par. 2 (stress come cancello prima del campo).

## 2. Il metodo (post-processing, zero tester) -- [APPROSSIMAZIONE dichiarata]
Per ogni POSIZIONE (deal aggregati per `position_id`), con V = volume d'ingresso = somma dei volumi
d'uscita, C = 100 oz/lotto, q_t = cambio USD->EUR alla data:
```
netto_base   = somma(net_profit dei deal) - k x V            (k = 1,8113 EUR/lotto, classe 844)
peggioramento = [ ds x V  +  slip x V  +  slip x somma(vol deal d'uscita) ] x C x q_t
netto_stress = netto_base - peggioramento
```
- `ds` = aumento dello spread in $/oz, pagato UNA volta per andata-e-ritorno.
- `slip` = slippage in $/oz, su ingresso e su **ogni** deal d'uscita (superinsieme dell'"uscita a
  stop": nell'EA TP1/TP2/EMA200/17:30 sono chiusure a mercato, solo il TP finale 4R e' un limite ->
  leggera sovrastima del costo, dalla parte pessimista).
- Volumi FISSI come nella base (nella realta' un saldo piu' basso darebbe lotti piu' piccoli): per il
  DD e' una sovrastima lieve, per il PF e' neutro in prima approssimazione.
- NON modella: l'insieme degli ingressi che cambia con lo spread (un ask piu' largo fa scattare il
  buy stop prima -> falsi breakout in piu'), requote, rifiuti, slippage favorevole, esecuzione FTMO vera.
- DD = drawdown relativo del saldo CHIUSO, deposito 100000, rischio 0,5%, deal in ordine di chiusura.
- PF = in POSIZIONI. Meta' = taglio 2023.04.01 sulla data di chiusura dell'ultimo deal; anno = data
  di chiusura dell'ultimo deal.

## 3. La scala
Base dello spread: **b = 0,45 $** = P95 FTMO ora 10 server (`report/SPREAD_APERTURA_FTMO_2026-09-21.md`,
45 punti, GG=1 = SOTTILE). **E' FTMO, non BCM**: lo spread del backtest BCM e' [NON MISURATO]
(classe 394). Lettura: il gradino +100% (ds = 0,45 $) equivale al caso "il backtest pagava spread
ZERO e FTMO fa pagare tutto il P95".

| gradino | ds (b = 0,45) | ds (b = 0,30, sensibilita') |
|---|---:|---:|
| 0 (base) | 0 | 0 |
| +25% | 0,1125 $ | 0,075 $ |
| +50% | 0,225 $ | 0,150 $ |
| +100% | 0,45 $ | 0,30 $ |
| +1000% (contro-esempio) | 4,50 $ | 3,00 $ |

Slippage: XAUUSD Digits = 2 (prezzi del per-trade a 2 decimali) -> **1 punto = 0,01 $**.
Scala richiesta: 0 / 1 / 2 punti. Scala di casa adattata al tick (solo sensibilita', NON decide):
5 punti, 10 punti (0,10 $), 50 punti (0,50 $).

## 4. Il cambio q (USD -> EUR)
`q` si MISURA dal file: nelle posizioni con due deal d'uscita di pari volume a prezzi diversi,
`q = (net_1 - net_2) / ((p_1 - p_2) x vol x C)` (la commissione d'uscita si elide). Interpolazione
lineare per data fra le ancore, costante fuori dagli estremi. Sensibilita': q fisso 0,85 / 0,95
(la banda del mandante) e **1,05** (tetto storico: EURUSD 2020-2026 mai sotto ~0,95).

## 5. LE SOGLIE (congelate)
Il verdetto si legge sulla combinazione **ds(gradino, b = 0,45) + slippage 2 punti**, q misurato.
- **S1** (gradino +25%): PF in posizioni **>= 1,20** E DD saldo chiuso a 0,5% **<= 5,0%**.
- **S2** (gradino +50%): PF **>= 1,10**.
- **S3** (gradino +100%): PF **>= 1,00**.
- **PASS** = S1 e S2 e S3. **FRAGILE** = S1 e S2 ma non S3 (non bocciato: decide Claudio col
  margine scritto). **BOCCIATO** = cade S1 o S2.
- Meta' e anni: si scrivono a ogni gradino e **non decidono**; ma una meta' con PF < 1,00 a un
  gradino superato si scrive accanto al verdetto.
- Sensibilita' (b = 0,30, q in banda, slippage 5/10/50 pt): **non cambia il verdetto**; se lo
  cambierebbe, si scrive "dipende da ...".
- Regola di casa: **il campione sottile sospende il MERITO, mai il RISCHIO**: il DD si legge a ogni
  gradino a qualunque n. OHLC M1 = DD LIMITE INFERIORE.

## 6. Contro-esempi obbligatori (se uno fallisce, NESSUN verdetto)
1. Degrado zero -> PF 1,3357 (+-0,0005) e DD 4,1549% (+-0,001) del referto; netto 14.062,14.
2. Degrado assurdo +1000% -> PF **< 1,00**. Se non crolla, la formula e' rotta.
3. Monotonia: il PF non cresce mai salendo di gradino.
4. Una posizione ricalcolata a mano deve tornare al centesimo con lo script.

## 7. Cosa questo collaudo NON copre
Spread in memoria del tester BCM [NON MISURATO, classe 394] · commissione FTMO su XAUUSD [NON
MISURATA] · tick reali (tutto e' OHLC M1) · requote/rifiuti/slippage vero FTMO · swap (le posizioni
chiudono in giornata alle 17:30: nessuna notte, salvo eccezioni da verificare nel file).
**Nessuna proposta di taglia.**
