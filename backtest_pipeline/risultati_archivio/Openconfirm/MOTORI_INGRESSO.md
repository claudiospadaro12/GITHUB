# I sei motori d'ingresso, misurati — DAX e Nasdaq (05/08)

Tick reali, M5, 2024.01→2026.06. Gestione validata: TP 1,5R, trailing base candela M5,
niente parziale né BE, rischio 1%. Range 15 min, buffer 200. **`InpOCTimeframe = 15`.**

## Un regalo involontario

Volevo confrontare **due** modi (BREAKOUT vs OPENCONFIRM). Ne ho avuti **sei**: MT5, sugli
input `enum`, **ignora `start||step||stop` e spazzola tutti i valori**. Quindi abbiamo la
mappa completa dei motori d'ingresso, gratis.

## DAX (D30EUR)

| motore | volumi | profit | PF | DD% | Sharpe | trade |
|---|---|---:|---:|---:|---:|---:|
| BREAKOUT | off | −78,78 | 0,994 | 19,74 | −0,24 | 440 |
| BREAKOUT | ON | −434,84 | 0,961 | 18,38 | −1,53 | 387 |
| RETEST | off | −1.058,68 | 0,916 | 19,70 | −3,64 | 432 |
| RETEST | **ON** | **+85,99** | 1,009 | 17,32 | 0,36 | 339 |
| **RANGE_FADE** | off/ON | **−3.676,03** | **0,705** | **39,74** | −5,00 | 440 |
| DELAYED | off | +37,26 | 1,007 | 14,66 | 0,25 | 179 |
| **DELAYED** | **ON** | **+619,91** | **1,197** | **8,12** | **5,66** | 120 |
| OPENCONFIRM | off | +71,31 | 1,006 | 19,58 | 0,20 | 439 |
| OPENCONFIRM | ON | −669,00 | 0,947 | 24,73 | −2,02 | 438 |

## Nasdaq (NASUSD)

| motore | volumi | profit | PF | DD% | Sharpe | trade |
|---|---|---:|---:|---:|---:|---:|
| BREAKOUT | off | −1.184,10 | 0,913 | 21,20 | −4,04 | 439 |
| BREAKOUT | ON | −769,01 | 0,894 | 15,97 | −4,59 | 260 |
| RETEST | off | −2.852,28 | 0,755 | 34,62 | −5,00 | 433 |
| RETEST | ON | −565,66 | 0,934 | 13,79 | −3,07 | 282 |
| **RANGE_FADE** | off/ON | **−2.783,64** | **0,745** | **31,66** | −5,00 | 440 |
| DELAYED | off | −445,36 | 0,909 | 8,74 | −3,50 | 204 |
| **DELAYED** | **ON** | **+387,22** | **1,200** | **4,78** | **6,54** | 99 |
| OPENCONFIRM | off | −1.387,92 | 0,868 | 22,92 | −5,00 | 431 |
| OPENCONFIRM | ON | −450,16 | 0,955 | 14,34 | −1,85 | 403 |

*(GAPFILL dà numeri identici a BREAKOUT: con `InpUseGapFill=0` cade nel ramo breakout.)*

## 1. DELAYED + volumi vince su tutti e due i mercati

| | PF | DD | Sharpe | trade |
|---|---:|---:|---:|---:|
| DAX | **1,197** | 8,12% | 5,66 | 120 |
| Nasdaq | **1,200** | 4,78% | 6,54 | 99 |

**PF 1,197 e 1,200. DD 8,1% e 4,8%.** Due mercati diversi, ore diverse, stesso motore, e
i numeri si sovrappongono. È il tipo di coincidenza che di solito non è coincidenza.

Il DELAYED non insegue la rottura: **aspetta 30 minuti dall'apertura** e poi entra. È
l'opposto di quello che fanno i Live5m — che sparano nei primi secondi e si fanno spazzare
(tre volte su tre documentate).

⚠️ **Ma 120 e 99 trade, ed è il migliore di 12 combinazioni per mercato.** Il rischio di
aver pescato il rumore è reale. **Serve il walk-forward prima di qualunque cosa.**

## 2. RANGE_FADE è morto

−3.676 con **DD 39,74%** sul DAX, −2.784 con 31,66% sul Nasdaq. Il peggiore dei sei su
entrambi, con la gestione buona.

E il filtro volumi **non lo tocca** (numeri identici acceso e spento): il fade piazza i
limit senza aspettare la rottura, quindi non passa mai dal controllo di conferma.

**Questo risponde in anticipo a metà di `aperture_retest_fade.ps1`**: il sell limit sul
livello, come motore sistematico, perde e basta. Il RETEST invece resta marginale
(+86 sul DAX con volumi, −566 sul Nasdaq): vale ancora la pena spazzolarne l'offset.

## 3. OPENCONFIRM su M15 non regge

DAX +71,31 (PF 1,006 = zero); Nasdaq −450,16 e −1.387,92. L'intuizione della candela che
**apre** oltre il livello, valutata su M15, **non paga**.

⚠️ **Ma non sappiamo com'è su M5**, e la colpa è mia — vedi sotto.

## 4. Il filtro volumi si comporta diversamente sui due mercati

- **Nasdaq**: migliora **tutti e cinque** i motori, sempre.
- **DAX**: migliora RETEST (−1.059 → +86) e DELAYED (+37 → +620), ma **peggiora** BREAKOUT
  (−79 → −435) e OPENCONFIRM (+71 → −669).

Non è un filtro "buono" o "cattivo": dipende dal motore a cui lo attacchi.

## 🔧 Difetto mio: la fase 1 è andata persa

`notte_05-08.ps1` scarica gli script **pinnati allo SHA `0a2502f`** — che è *precedente* al
fix con cui ho messo il timeframe nel nome del CSV, fix che ho fatto **nello stesso commit
del file di coda**. Quindi la fase 2 (M15) ha sovrascritto la fase 1 (TF del grafico, M5),
esattamente il problema che credevo di aver risolto.

**Da rifare**: solo il giro con `-OCTimeframe 0`, 4 pass per mercato. Con lo script
aggiornato il nome del CSV porta il TF e non si sovrascrive più.
