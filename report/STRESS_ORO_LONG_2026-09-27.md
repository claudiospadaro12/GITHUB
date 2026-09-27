# STRESS DEI COSTI -- ORO 770402 SOLO LONG (R260a) -- 27/09/2026

**Cosa e'**: il cancello del degrado dei costi chiesto dalla seconda opinione
(`docs/RISPOSTA_GEMINI_2026-09-27.md` par. 2: spread/slippage +30-50% prima del campo), applicato
**in post-processing, zero tester** alla cella oggi piu' vicina a una sedia.
**Fonte unica**: `backtest_pipeline/risultati_archivio/ROUND_CORTI_B_2026-09-27/PERTRADE/abtg_trades_ABTG_MaxMinNotte_XAUUSD_795301.csv`
(375 deal d'uscita = 279 posizioni, OHLC M1, 2020.01.01 -> 2026.06.30, deposito 100000, rischio 0,5%).
Referto di provenienza: `report/REFERTO_ROUND_CORTI_B_2026-09-27.md` par. 1 e 5.
**Strumento**: `backtest_pipeline/stress_pertrade.py` (`--autotest` 14/14 PASS). Riga che rifa' tutto:
```
python3 backtest_pipeline/stress_pertrade.py --pertrade backtest_pipeline/risultati_archivio/ROUND_CORTI_B_2026-09-27/PERTRADE/abtg_trades_ABTG_MaxMinNotte_XAUUSD_795301.csv --k 1.8113 --base-spread 0.45 --base-spread 0.30 --attesa-pf 1.3357 --attesa-dd 4.1549
```
**Questo referto non propone taglie, non promuove, non tocca EA/preset/sedie/conti.**

---

## 0. I CRITERI -- congelati PRIMA dei numeri
File: `backtest_pipeline/prove/COLLAUDO_ORO_770402_LONG_CRITERI.md`, **commit `323605fb`**, pushato
prima di calcolare un solo numero sotto stress. In breve:

- **Metodo** (per POSIZIONE, deal aggregati per `position_id`; V = volume d'ingresso = somma dei
  volumi d'uscita; C = 100 oz/lotto; q_t = cambio USD->EUR alla data):
  `netto_stress = [somma net - k x V] - [ds x V + slip x V + slip x somma(vol d'uscita)] x C x q_t`,
  k = 1,8113 EUR/lotto (classe 844). `ds` si paga UNA volta per andata-e-ritorno; lo slippage sull'ingresso
  e su **ogni** deal d'uscita (superinsieme dell'"uscita a stop": TP1/TP2/EMA200/17:30 sono chiusure a
  mercato nell'EA, solo il TP finale 4R e' un limite -> leggermente pessimista).
- **Scala**: base spread **b = 0,45 $** = P95 FTMO ora 10 server (`report/SPREAD_APERTURA_FTMO_2026-09-21.md`,
  45 punti, GG=1 = SOTTILE) -- **e' FTMO, non BCM**. Gradini +25/+50/+100% -> ds 0,1125 / 0,225 / 0,45 $.
  Sensibilita' b = 0,30 $. Slippage 0/1/2 punti (XAUUSD Digits=2: prezzi del per-trade a 2 decimali ->
  **1 punto = 0,01 $**); sensibilita' 5/10/50 punti.
- **Soglie** (lette su ds(gradino, b=0,45) **+ slippage 2 punti**, q misurato):
  **S1** +25%: PF in posizioni >= 1,20 **e** DD saldo chiuso a 0,5% <= 5,0% ·
  **S2** +50%: PF >= 1,10 · **S3** +100%: PF >= 1,00.
  PASS = S1+S2+S3 · FRAGILE = S1+S2 senza S3 · BOCCIATO = cade S1 o S2.
  Meta' (taglio 2023.04.01) e anni si scrivono e **non decidono**.
- **Contro-esempi obbligatori**: (1) degrado zero = PF 1,3357 / DD 4,1549% del referto; (2) +1000% -> PF < 1;
  (3) monotonia; (4) una posizione a mano al centesimo. Se uno fallisce: nessun verdetto.

## 1. I CONTRO-ESEMPI -- tutti e quattro tornano
| # | prova | atteso | ottenuto | esito |
|---|---|---|---|---|
| 1 | degrado zero | PF 1,3357 · DD 4,1549% · netto +14.062,14 · meta' 135/1,171 e 144/1,521 | PF **1,3357** · DD **4,1549%** · netto **+14.062,14** · meta' **135/1,171** e **144/1,521** | OK |
| 2 | +1000% (ds 4,50 $, slip 2) | PF < 1,00 | PF **0,537** (DD 32,7%, 6/7 anni negativi) | OK: la formula morde |
| 3 | monotonia del PF 0 -> +1000% | mai in salita | 1,325 -> 1,296 -> 1,268 -> 1,213 -> 0,537 | OK |
| 4 | posizione 63 (2020.03.24, 2 x 0,07 lotti) a mano, ds 0,45 + slip 2 | 463,41 - 0,2536 - (0,063+0,0028+0,0028) x 100 x 0,91337 = **456,89** | script **456,8907** | OK |

**Il cambio q e' MISURATO dal file, non stimato** (40 ancore: posizioni con due uscite di pari volume a
prezzi diversi, la commissione d'uscita si elide): min **0,8102** (dic 2020) · mediana **0,9166** · max
**0,9972** (ott 2022). Torna con la storia di EURUSD (1,22 a fine 2020, parita' nell'autunno 2022).
**La banda del mandante 0,85-0,95 era troppo stretta**: il file va da 0,81 a 1,00. Sensibilita' in par. 4.

## 2. LA TABELLA -- base 0,45 $ (FTMO), q misurato, TUTTA la scala
| gradino | ds $ | slip pt | pos | PF posizioni | netto EUR | DD chiuso % | meta' 1 PF | meta' 2 PF |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| base | 0 | 0 | 279 | 1,3357 | +14.062,14 | 4,155 | 1,171 | 1,521 |
| base | 0 | 1 | 279 | 1,3304 | +13.869,79 | 4,174 | 1,166 | 1,516 |
| base | 0 | 2 | 279 | 1,3252 | +13.677,44 | 4,194 | 1,161 | 1,510 |
| +25% | 0,1125 | 0 | 279 | 1,3064 | +12.980,18 | 4,265 | 1,143 | 1,491 |
| +25% | 0,1125 | 1 | 279 | 1,3012 | +12.787,83 | 4,285 | 1,138 | 1,485 |
| **+25%** | **0,1125** | **2** | 279 | **1,2961** | +12.595,48 | **4,305** | 1,134 | 1,480 |
| +50% | 0,225 | 0 | 279 | 1,2777 | +11.898,22 | 4,377 | 1,116 | 1,461 |
| +50% | 0,225 | 1 | 279 | 1,2727 | +11.705,87 | 4,397 | 1,111 | 1,455 |
| **+50%** | **0,225** | **2** | 279 | **1,2677** | +11.513,53 | 4,478 | 1,107 | 1,450 |
| +100% | 0,45 | 0 | 279 | 1,2223 | +9.734,31 | 5,294 | 1,064 | 1,403 |
| +100% | 0,45 | 1 | 279 | 1,2175 | +9.541,96 | 5,382 | 1,059 | 1,398 |
| **+100%** | **0,45** | **2** | 279 | **1,2127** | +9.349,61 | **5,471** | 1,054 | 1,392 |
| +1000% (c.e.) | 4,50 | 2 | 279 | 0,5366 | -29.600,85 | 32,749 | 0,434 | 0,658 |

**Dove sta il pareggio** (slip 2, bisezione sullo script): PF = 1,20 a ds **0,503 $** (+112% della base) ·
PF = 1,10 a ds **0,942 $** (+209%) · **PF = 1,00 a ds 1,422 $ (+316%)**.

Slippage fuori scala (sensibilita', non decide; a spread base): 5 pt PF 1,310 / DD 4,25 · 10 pt (0,10 $)
PF 1,284 / DD 4,35 · **50 pt (0,50 $ su ingresso E su ogni uscita) PF 1,096 / DD 7,76%, meta' 1 a 0,945**.
Tradotto: lo slippage pesa il doppio dello spread a parita' di dollari (si paga sull'ingresso E sulle uscite, 2 x V),
e **0,50 $ di slittamento sistematico sarebbe l'unico scenario letto qui che rompe una meta'**.

## 3. ANNO PER ANNO (base 0,45, slippage 2 pt) -- n / netto EUR / PF
| gradino | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 (giu) | anni < 0 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| base | 42 / +2.880 / 1,491 | 35 / -576 / 0,921 | 40 / +1.513 / 1,270 | 42 / -1.278 / 0,842 | 56 / +5.897 / 1,770 | 47 / +2.948 / 1,488 | 17 / +2.293 / 2,551 | 2/7 |
| +25% | 42 / +2.710 / 1,456 | 35 / -732 / 0,901 | 40 / +1.332 / 1,234 | 42 / -1.486 / 0,819 | 56 / +5.666 / 1,731 | 47 / +2.831 / 1,465 | 17 / +2.274 / 2,533 | 2/7 |
| +50% | 42 / +2.540 / 1,422 | 35 / -888 / 0,881 | 40 / +1.151 / 1,200 | 42 / -1.694 / 0,797 | 56 / +5.435 / 1,694 | 47 / +2.714 / 1,443 | 17 / +2.255 / 2,515 | 2/7 |
| +100% | 42 / +2.201 / 1,356 | 35 / -1.200 / 0,843 | 40 / +788 / 1,134 | 42 / -2.110 / 0,753 | 56 / +4.973 / 1,621 | 47 / +2.481 / 1,399 | 17 / +2.217 / 2,480 | 2/7 |

Lo stress **non crea anni negativi nuovi**: restano 2021 e 2023 (gli stessi della base e di R103), e si
approfondiscono (2023: PF 0,842 -> 0,753 a +100%). Peggior giornata a saldo chiuso: -0,507% (base) ->
**-0,548%** (+100%): lontanissima dal muro giornaliero 5% a questa taglia. Serie perdente massima: 8
posizioni a ogni gradino.

## 4. SENSIBILITA' (non decidono -- e non cambiano il verdetto)
**Base 0,30 $** (slip 2): +25% PF 1,306 / DD 4,27 · +50% PF 1,287 · +100% PF 1,249 / DD 4,81 -> PASS.
**Cambio q fisso** (base 0,45, slip 2):

| q | +25% PF / DD | +50% PF | +100% PF / DD | ds a PF = 1,00 | verdetto |
|---|---|---:|---|---:|---|
| 0,85 | 1,298 / 4,29 | 1,272 | 1,219 / 5,31 | 1,511 $ | PASS |
| **misurato** | **1,296 / 4,30** | **1,268** | **1,213 / 5,47** | **1,422 $** | **PASS** |
| 0,95 | 1,294 / 4,31 | 1,264 | 1,206 / 5,55 | 1,348 $ | PASS |
| 1,05 (tetto storico) | 1,290 / 4,33 | 1,257 | 1,194 / 5,79 | 1,216 $ | PASS |

**Slippage: la sensibilita' che CAMBIEREBBE il verdetto -- e per regola si scrive "dipende da".**
Soglia di slippage sistematico (su ingresso E su ogni uscita) oltre la quale un gradino cade, b 0,45, q misurato:

| gradino | slippage massimo che regge | cosa cade oltre | a quel punto |
|---|---:|---|---|
| +25% (S1) | **0,136 $ = 13,6 punti** | il **DD** (5,0%), non il PF | PF 1,238 · DD 5,00% |
| +50% (S2) | 0,379 $ = 37,9 punti | il PF | PF 1,100 · DD 7,67% |
| +100% (S3) | 0,506 $ = 50,6 punti | il PF | PF 1,000 · DD 10,06% |

A +25% con 5 pt: PF 1,281 / DD 4,37 · 10 pt: PF 1,256 / DD 4,69 · 50 pt: PF 1,072 / DD 8,32.
**Lo slippage vero FTMO sugli stop dell'oro e' [NON MISURATO]** (in casa `misura_slippage.py` legge i report
del tester sugli indici, non il campo). Per il verdetto: **regge fino a ~13 punti (0,13 $) di slittamento
medio sistematico per deal**; sopra, S1 cade per il DD.

## 5. IL VERDETTO, contro i criteri congelati
| soglia | richiesto | misurato (b 0,45 + slip 2, q misurato) | esito |
|---|---|---|---|
| **S1** (+25%) | PF >= 1,20 e DD <= 5,0% | PF **1,296** · DD **4,30%** | **ok** (margine +0,096 di PF, 0,70 punti di DD) |
| **S2** (+50%) | PF >= 1,10 | PF **1,268** | **ok** (+0,168) |
| **S3** (+100%) | PF >= 1,00 | PF **1,213** | **ok** (+0,213) |

## -> **PASS** (in OHLC M1, sul modello di costo dichiarato) -- **DIPENDE DALLO SLIPPAGE oltre ~13 punti**
Meta' a ogni gradino superato: tutte >= 1,00 (la piu' debole: meta' 1 a +100% = **1,054**).
Il verdetto regge su b 0,30 e su q 0,85-1,05. **Non regge** su uno slittamento medio sistematico oltre
**0,136 $ per deal** (S1 cade per il DD, par. 4): lo slippage vero e' [NON MISURATO], quindi il PASS vale
**alla scala richiesta 0-2 punti e fino a ~13 punti**, non oltre.

**Le due cose da leggere accanto al PASS, perche' senza non si capisce**:
1. 🟠 **Il DD sale oltre il 5% a +100%** (5,47%; 5,79% col q peggiore). Non e' un cancello (S1 guarda il DD
   solo a +25%), ma e' un fatto: e **tutti i DD qui sono OHLC = limite inferiore** (niente flottante,
   volumi fissi). Il rischio alla taglia vera resta [DERIVATO] (referto B par. 1.5) e lo misura solo R193b.
2. 🟠 **Lo stop dell'oro nel backtest e' molto piu' corto del "32,94 $" di casa.** Ricavato per ogni
   posizione con la classe 846 (stop = R / (V x C x q), R = 0,5% x saldo prima dell'ingresso, q misurato):
   **mediana 14,70 $** (banda di arrotondamento del lotto 14,50-14,89), P10 9,96, min 7,94. Per anno:

   | anno | n | stop mediano $ | min $ | ds 0,45 in R (mediana) | posizioni con stop < 18 $ (= 40 x 0,45) |
   |---|---:|---:|---:|---:|---:|
   | 2020 | 42 | 14,34 | 8,25 | 3,14% | 34 |
   | 2021 | 35 | 12,83 | 8,35 | 3,51% | 33 |
   | 2022 | 40 | 12,78 | 9,27 | 3,52% | 36 |
   | 2023 | 42 | 11,35 | 7,94 | 3,96% | 39 |
   | 2024 | 56 | 14,74 | 8,55 | 3,05% | 43 |
   | 2025 | 47 | 28,32 | 9,22 | 1,59% | 10 |
   | 2026 | 17 | 49,36 | 34,49 | 0,91% | 0 |

   Quindi **195 posizioni su 279 (70%) starebbero sotto la frontiera 40x con lo spread FTMO di OGGI** --
   ma il 2020-2024 aveva l'oro a 1.500-2.400 $ e lo spread in dollari di allora [NON MISURATO] non era
   quello di oggi a ~4.000 $: applicare 0,45 $ a quegli anni e' **pessimista**, e lo stress e' piu' severo
   proprio dove il campione e' piu' lungo. Nel regime di prezzo di oggi (2025-2026) la frontiera tiene
   (10/64 sotto, 0/17 nel 2026) e il costo di +100% vale ~1-1,6% di R. **La buona notizia misurata**: anche
   applicando lo spread di oggi alla storia intera, dove la regola 40x "boccerebbe" il 70% delle notti, il
   PF resta **1,21** a +100% -- il costo si mangia **0,11 di PF**, non l'edge.
   Il 32,94 $ (n=2, forward sul piccolo) resta dentro l'ordine di grandezza del 2025-2026; la controprova
   interna sugli stop pieni (56 posizioni, rapporto 1,001) **non e' indipendente** (perdita ~ R per
   costruzione del filtro) e si cita solo come coerenza.

## 6. COSA QUESTO COLLAUDO NON COPRE -- e quindi cosa resta aperto
- **Spread in memoria del tester BCM** su cui gira la base: **[NON MISURATO]** (classe 394). Lo stress e'
  un'AGGIUNTA a quello spread ignoto. Lettura prudente: il gradino +100% = "il backtest pagava spread
  zero e FTMO fa pagare tutto il P95 di 0,45 $", e **passa**.
- **Commissione FTMO su XAUUSD: [NON MISURATA]** (una lettura [SECONDARIA] in
  `report/RICERCA_SPREAD_PROP_XAUUSD_2026-09-17.md` dice zero sui metalli; non usata). Nel conto e'
  rimasta la k BCM di banco (1,8113 EUR/lotto per lato).
- **Tick reali: nessuno.** Tutto e' OHLC M1 -> DD limite inferiore. La riprova a tick e' R268 (Gemini par. 2).
- **Lo spread FTMO di base e' UNA giornata** (GG=1, SOTTILE) all'ora 10 FTMO; gli ingressi dell'EA cadono
  07:00-08:30 BCM (08:00-09:30 IT d'estate): l'ora 10 FTMO e' dentro la finestra, ma non la copre tutta.
- **Non modellato**: l'insieme degli ingressi che cambia con lo spread (un ask piu' largo fa scattare il buy
  stop prima -> falsi breakout in piu'), requote, rifiuti, slippage favorevole, esecuzione FTMO vera,
  volumi che si ridurrebbero con un saldo piu' basso.
- **Swap**: nessuna posizione attraversa la notte (0/279 con deal su date diverse) -> non applicabile.
- **Orologio dell'oro** = forex [INFERITO] (referto B par. 5e): lo stress non lo tocca.
- **La taglia**: nessuna proposta. Tutto qui e' a 0,5% di banco.

---
Fonti: per-trade `795301` (archivio `3a67aead`), criteri `323605fb`, referto `REFERTO_ROUND_CORTI_B_2026-09-27.md`,
spread `SPREAD_APERTURA_FTMO_2026-09-21.md`, EA `mql5/Experts/standalone/ABTG_MaxMinNotte.mq5` (r.31 enum SL:
`InpSLMode=0` = estremo opposto del box; r.284-307 parziali a mercato; r.393 rischio sul BALANCE).
