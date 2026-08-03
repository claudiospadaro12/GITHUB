# 🔬 ABLAZIONE FILTRI — Nasdaq apertura M5 (NASUSD), tick reali

_02/08/2026. Motore: STOP breakout su max/min della **candela H1 precedente** (livelli delle slide Nasdaq)._
_Stop ATR ×1,5 con floor 500 punti. Griglia buffer 25→200. 2024.01–2026.06 = **~625 giorni di borsa**._

## Risultati (gradini 1, 2 e 3)

| Configurazione | Trade | % giorni | PFmed | PF min–max | DD med |
|---|---|---|---|---|---|
| **soli livelli H1**, nessun filtro | 481 | 77% | **0,91** | 0,90–0,92 | **35%** |
| volumi ≥ **1,2×** | 296 | 47% | 0,96 | 0,94–0,99 | 17,9% |
| volumi ≥ **1,5×** | 152 | 24% | **1,15** | 1,12–1,20 | 9,6% |
| volumi ≥ **1,8×** | 79 | 13% | **1,38** | 1,37–1,52 | 7,6% |
| ATR ≥ **0,8×** | 469 | 75% | 0,93 | 0,93–0,94 | 31,8% |
| ATR ≥ **1,0×** | 332 | 53% | 0,93 | 0,93–0,97 | 25,6% |
| ATR ≥ **1,2×** | 116 | 19% | **0,76** | 0,74–0,78 | 28,7% |

## Le due risposte

### ❌ I livelli H1 NON sono l'edge — ipotesi smentita
Era l'ipotesi più promettente (*"forse per settimane abbiamo guardato i livelli sbagliati"*). **No**: da soli fanno **0,91 con DD 35%**, cioè peggio del breakout nudo sul range M5 (0,88, DD 14,5%). Il cambio di livelli non spiega niente.

### ✅ L'edge è il FILTRO VOLUMI, e la curva lo dimostra
Monotòna in **tutte e tre** le colonne: più si stringe, più sale il PF (0,91→0,96→1,15→1,38), più scende il DD (35%→18%→9,6%→7,6%), meno trade restano. Un filtro privo di informazione darebbe una curva **rumorosa**, non una scala così ordinata. Il volume all'apertura del Nasdaq porta informazione vera.

### ❌ Il filtro ATR è RUMORE — anzi, danno (gradino 3, 03/08)
Stringendo la soglia: **0,91 → 0,93 → 0,93 → 0,76**. Non sale mai, e alla soglia alta **peggiora** buttando via l'81% dei giorni. **0 pass positivi su 24.** Il DD resta sempre sopra il 25%.

Il contrasto con i volumi è la cosa più informativa dell'intera ablazione:

| Quando stringi la soglia | VOLUMI | ATR |
|---|---|---|
| nessun filtro | 481 trade · PF 0,91 | 481 trade · PF 0,91 |
| soglia bassa | 296 · **0,96** | 470 · 0,93 |
| soglia media | 152 · **1,15** | 332 · 0,95 |
| soglia alta | 79 · **1,38** ⬆ | 116 · **0,76** ⬇ |

Stesso motore, stesso periodo, stesso stop: **un filtro sale in modo ordinato, l'altro scende.** È la differenza tra informazione e rumore, misurata.

### 🔮 Conseguenza sui gradini 4–7 (previsione da verificare)
I gradini successivi impilano **volumi OPPURE ATR** (lettura testuale del PDF). Siccome l'ATR da solo è perdente, l'OR **aggiunge giornate cattive** a quelle buone scelte dai volumi → **il gradino 4 dovrebbe uscire PEGGIORE del gradino 2**. Se si conferma, significa che la regola del piano non è meccanizzabile alla lettera: sul Nasdaq conta il **volume**, non la volatilità.
I gradini 5–7 (H4, correlazione, news) restano utili ma sono **contaminati dall'ATR**: il loro contributo pulito va rimisurato sopra i **soli volumi**.

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
- ~~Gradino 3 (ATR)~~ → fatto 03/08: **rumore, bocciato**.
- Gradini 4–7 in corso. Poi: **ladder pulito sopra i SOLI volumi** (+H4, +correlazione, +news, uno alla volta, senza ATR) per misurarne il contributo non contaminato.
- Implementare e testare il filtro volumi **sulla candela di rottura** (quello vero dei documenti).
