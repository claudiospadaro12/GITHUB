# 🔬 ABLAZIONE FILTRI — Nasdaq apertura M5 (NASUSD), tick reali

_02/08/2026. Motore: STOP breakout su max/min della **candela H1 precedente** (livelli delle slide Nasdaq)._
_Stop ATR ×1,5 con floor 500 punti. Griglia buffer 25→200. 2024.01–2026.06 = **~625 giorni di borsa**._

## Risultati (gradini 1 e 2)

| Configurazione | Trade | % giorni | PFmed | PF min–max | DD med |
|---|---|---|---|---|---|
| **soli livelli H1**, nessun filtro | 481 | 77% | **0,91** | 0,90–0,92 | **35%** |
| volumi ≥ **1,2×** | 296 | 47% | 0,96 | 0,94–0,99 | 17,9% |
| volumi ≥ **1,5×** | 152 | 24% | **1,15** | 1,12–1,20 | 9,6% |
| volumi ≥ **1,8×** | 79 | 13% | **1,38** | 1,37–1,52 | 7,6% |

## Le due risposte

### ❌ I livelli H1 NON sono l'edge — ipotesi smentita
Era l'ipotesi più promettente (*"forse per settimane abbiamo guardato i livelli sbagliati"*). **No**: da soli fanno **0,91 con DD 35%**, cioè peggio del breakout nudo sul range M5 (0,88, DD 14,5%). Il cambio di livelli non spiega niente.

### ✅ L'edge è il FILTRO VOLUMI, e la curva lo dimostra
Monotòna in **tutte e tre** le colonne: più si stringe, più sale il PF (0,91→0,96→1,15→1,38), più scende il DD (35%→18%→9,6%→7,6%), meno trade restano. Un filtro privo di informazione darebbe una curva **rumorosa**, non una scala così ordinata. Il volume all'apertura del Nasdaq porta informazione vera.

## ⚠️ Cosa misura DAVVERO quel filtro (importante)
Con `InpRangeMode=2` (livelli sulla candela H1 precedente) il controllo scatta alle **14:30 in punto** e `VolumeOK()` legge l'**ultima barra M5 chiusa**, cioè **14:25–14:30: PRIMA dell'apertura**.

Quindi la regola che funziona è: **«il volume nei 5 minuti prima dell'apertura ≥ 1,5× la media dei 100 minuti precedenti»** — un filtro di **pre-apertura**, non di conferma sulla rottura.

I documenti dicono un'altra cosa: *"la rottura supportata da aumento di volumi"*, cioè il volume **sulla candela che rompe**. **Quella versione non è mai stata testata.**
Il risultato resta valido e ha una logica (attività istituzionale prima dell'apertura → giornata direzionale), ma **non è "il filtro di Emiliano"** e non va raccontato come tale.

## 🚧 Il problema aperto: nessuna soglia passa entrambi i criteri
Criteri fissati prima del test: **trade ≥ 150** e **PFmed ≥ 1,3**.

- **1,5×** → 152 trade ✅ · PF 1,15 ❌
- **1,8×** → PF 1,38 ✅ · 79 trade ❌

Il punto utile sta **in mezzo** e la griglia non lo campiona (salta da 1,5 a 1,8).

## ▶️ Prossimo test: sweep fine di VolMult
```powershell
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/sweep_volumi_nasdaq.ps1" | iex
```
VolMult **1,5 → 2,0 a passi di 0,1**, solo filtro volumi, buffer 50→200.
Decide se esiste una soglia con **≥150 trade E PF ≥1,3**, oppure se il PF si compra solo pagando in campione — nel qual caso l'edge esiste ma è troppo raro per costruirci un EA.

## Da fare dopo
- Gradini 3–7 dell'ablazione (ATR, trend H4, correlazione, news): ora vanno giudicati **sopra** i volumi, non da soli.
- Implementare e testare il filtro volumi **sulla candela di rottura** (quello vero dei documenti).
