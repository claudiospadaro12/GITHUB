# Analisi EA "BULGE MULTI SIGNAL" — confronto versioni

> 5 file analizzati. **Sono UNA strategia con add-on incrementali di risk management**, non 5 strategie diverse.

## La strategia (identica in tutti i file)
- **Tipo:** mean-reversion su **Bollinger "Bulge"**, basket forex, **H1**.
- **Bulge** = larghezza BB ≥ 1,1× la sua media a 50 → fase di espansione di volatilità.
- Rileva l'ultimo **impulso** (candela che tocca una banda con corpo ≥ 0,2·ATR), poi entra **in controtendenza** aspettando il ritorno alla mediana.
- **3 segnali:** ARANCIO (off di default), **BLU** (conferma 2ª candela), **VIOLA** (post-bulge). 
- **SL = ATR×3 fisso · TP = mediana BB dinamica** (aggiornata ogni barra).
- ⇒ Profilo **alto win rate / payoff < 1** (TP piccolo, SL grande) → fragile ai trend ("bandriding").

## Le differenze tra le versioni

| File | Cosa aggiunge | Rischio | Simboli | Note |
|---|---|---|---|---|
| **v1** (`BULGE_MULTI_SIGNAL`) | Base "live Apr 2026" | **3%/trade × 10** (fino al 30% esposto!) | **solo 5** selezionati dal backtest | ⚠️ file caricato **corrotto** (OnTick/UpdateAllTP malformati) · 5 simboli = selection bias |
| **v2** | Tetto rischio **totale 3%** (÷ max trade) + **circuit breaker** (3 SL → stop fino a domani) | 3% totale (1%×3) | 22 | branch separato (NON ha l'ADX) |
| **v3** | **Filtro ADX anti-bandriding** sui segnali BLU (ADX≥30 → blocca) | **0,5%/trade × 10** | 22 | = v1 + ADX (NON ha il circuit breaker del v2) |
| **v3_PARALLEL** | = v3 + **Magic diverso** (20250003) per girare insieme al v1 + notifiche col segnale | 0,5% × 10 | 22 | solo "operativo", logica identica al v3 |
| **v3_PARALLEL_KILL** | = v3_PARALLEL + **KILL SWITCH**: max **4 trade** (2% esposto), **stop −2%/giorno**, **3 SL/giorno → stop**, reset a mezzanotte | **0,5% × 4** | 22 | 🟢 **la più controllata** (richiesta Emiliano) |

## Evoluzione (in sintesi)
**v1** (rischioso, 3%) → **v2** (cap rischio + circuit breaker) e **v3** (filtro ADX) su **due rami separati mai uniti** → **v3_PARALLEL** (magic separato) → **v3_PARALLEL_KILL** (kill switch giornaliero).

> Da notare: il **circuit breaker (v2)** e il **filtro ADX (v3)** non sono mai stati fusi in un unico file. La KILL re-introduce gli stop giornalieri/consecutivi (concetto simile al breaker) sopra il v3.

## 🏦 Idoneità prop / verdetto
- **La versione migliore è la `v3_PARALLEL_KILL`**: rischio 0,5%, max 2% esposto, **stop giornaliero −2% < 5% FTMO** ✅, kill switch. Profilo di rischio adatto a una challenge.
- ⚠️ **MA l'edge è ancora da dimostrare.** Il backtest mostrato (PF 2,82 / Sharpe 7,5 / WR 87% / 85 trade / **40% qualità dati**) ha tutti i segnali dell'**overfitting** (Sharpe irreale, pochi trade, 5 simboli selezionati, tanti parametri). Da **validare out-of-sample** (2015-2021, dati puliti, basket completo) prima di crederci.
- 🐛 **v1 corrotto**: il file caricato non compila (frammenti orfani). Usare v3_PARALLEL_KILL come base.

## Note tecniche
- Tutte ricreano gli handle indicatore (iBands/iATR/iADX) a ogni chiamata e li rilasciano — inefficiente ma funziona su H1.
- È la versione "EA" degli indicatori **IN-BULGE/POST-BULGE [Claudio]** visti sui grafici del trading manuale → stesso DNA.
