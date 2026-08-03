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

---

# ✅ GRADINI 4–7 — completati il 03/08. L'ablazione è CHIUSA.

| # | Gradino | Pass | PFmed | PF max | PF>1 | DDmed | Trade med |
|---|---|---|---|---|---|---|---|
| 1 | nudo, nessun filtro | 8 | 0,90 | 0,92 | **0/8** | 34,4% | 482 |
| 2 | **+ volumi** | 24 | **1,15** | **1,52** | **16/24** | **9,6%** | 152 |
| 3 | + ATR (da solo) | 24 | 0,93 | 0,97 | 0/24 | 28,7% | 332 |
| 4 | **volumi OPPURE ATR** | 72 | 0,99 | 1,03 | 29/72 | 22,6% | 380 |
| 5 | + EMA su H4 | 72 | 0,81 | 0,94 | 0/72 | 31,6% | 260 |
| 6 | + correlazione SPXUSD H1 | 72 | 0,80 | 0,93 | 0/72 | 29,2% | 239 |
| 7 | + filtro news | 72 | 0,80 | 0,93 | 0/72 | 29,2% | 240 |

**Su sei filtri candidati ne funziona esattamente uno: i volumi.** Tutto il resto è neutro o dannoso.

## 🎯 La previsione del gradino 4 era giusta — e costa cara

Avevo scritto: *"l'OR aggiunge giornate cattive → il gradino 4 dovrebbe uscire PEGGIORE del gradino 2"*. **Confermato**, e il confronto a parità di soglia lo isola senza ambiguità:

| Soglia volumi | solo volumi (gr. 2) | volumi **OR** ATR (gr. 4) |
|---|---|---|
| 1,2× | PF 0,96 · DD 17,9% · 296 trade | PF 0,95 · DD 20,4% · 411 trade |
| 1,5× | PF **1,15** · DD **9,6%** · 152 trade | PF 1,01 · DD 22,9% · 380 trade |
| 1,8× | PF **1,38** · DD **7,6%** · 80 trade | PF 0,99 · DD 21,9% · 349 trade |

A soglia 1,8 l'OR riammette **269 trade** e il PF crolla da 1,38 a 0,99: sono **esattamente i trade che il filtro volumi aveva ragione a escludere**. Con l'OR il PF mediano (0,99) è indistinguibile dal motore nudo (0,90): l'unico beneficio residuo è il DD (34,4% → 22,6%).

> ⚠️ **Correzione di una mia modifica.** L'`InpConfirmMode=OR` l'ho introdotto io il 02/08 dopo la tua osservazione *"questi 72 trade sono pochi, in M5 deve aprire tutti i giorni"*. L'osservazione sul campione era giusta e resta giusta. **L'OR però non è il rimedio**: rialza il numero di trade riammettendo proprio quelli sbagliati. Il PDF dice *"volumi **o** ATR"*, ma sul Nasdaq quella lettura letterale equivale a non filtrare. **Default da riportare ad AND — o meglio, ai soli volumi con l'ATR spento.**

## ❌ Gradini 5 e 6: peggiorano, e il confronto è pulito

Ogni gradino cambia **un solo toggle** rispetto al precedente [VERIFICATO sui parametri fissi nei CSV], quindi l'incremento è misurato correttamente anche se la base (gradino 4) è già compromessa:

- **EMA 1/50 su H4** (`InpUseEmaFilter`, non Supertrend3 che resta a 0): PFmed **0,99 → 0,81**, DD 22,6% → 31,6%. Taglia 120 trade e peggiora entrambe le colonne: sta escludendo i trade buoni.
- **Correlazione SPXUSD H1**: 0,81 → 0,80. Altri 21 trade in meno, nessun guadagno. **Irrilevante.**

## ⚠️ Gradino 7: il filtro news NON è stato misurato

Su 72 combo, 63 danno risultati **identici** al gradino 6 — coerente con un file news assente (l'EA lo scrive nel log: *"file news non trovato… filtro disattivato di fatto"*).
Ma sulle **9 combo che cambiano, i trade AUMENTANO** (239 → 297, sempre +58):

```
vol 1.2  atr 0.8  buf 25 : trade 239->297   PF 0.74->0.79
```

**Un filtro non può aggiungere trade.** Delle due l'una: o il file news non c'era e la differenza viene da altro (dati scaricati diversi fra le due sessioni), o c'è un difetto. [INCERTO — si risolve leggendo nel log del tester la riga `news caricate: N eventi`.] Finché non è chiarito, **il gradino 7 non conta come risultato.**

## 📏 Il buffer non è una leva

A parità di tutto il resto, buffer **25 / 50 / 75 / 100 danno risultati identici al centesimo** (PF 1,37 · 79 trade). Normale: NASUSD quota a 2 decimali, quindi 100 punti MT5 = **1 punto indice** — sotto lo spread. Solo da 125 in su cambia qualcosa, e in modo irregolare (1,52 / 1,39 / 1,48 / 1,47): **rumore, non una tendenza.** Il PF 1,52 del "migliore in assoluto" è un punto fortunato dentro un intorno piatto: **il numero da citare è la mediana 1,38.**

## 🧾 Verdetto finale dell'ablazione

1. **L'unico filtro con informazione sul Nasdaq apertura è il volume di pre-apertura.** Curva monotòna su PF, DD e trade — un filtro casuale non fa una scala così ordinata.
2. **Nessuna soglia supera entrambi i criteri** (≥150 trade *e* PF ≥1,3). Il punto onesto d'esercizio è **1,5×: PF 1,15, DD 9,6%, 152 trade** — campione appena sufficiente, edge modesto. A 1,8× il PF sale a 1,38 ma restano **80 trade**, cioè sotto la soglia del "non è un dato".
3. **Non c'è altro da cercare fra i filtri.** Sei candidati, uno funziona. Continuare a impilare condizioni sul motore d'ingresso ha smesso di rendere.

→ Questo **conferma dai numeri** la rotta scelta dopo il forward del 03/08: il margine che resta sta nella **gestione dell'uscita**, non nella selezione dell'ingresso. Vedi `STUDIO_MOVIMENTO_APERTURE.md`.

## Da fare dopo
- ~~Gradino 3 (ATR)~~ → **rumore, bocciato**. ~~Gradini 4–7~~ → **fatti, ablazione chiusa**.
- 🔴 **Rimettere `InpConfirmMode` ad AND** (o spegnere l'ATR) nei preset forward del Nasdaq: oggi l'OR sta annullando l'unico filtro che funziona.
- Sweep fine `VolMult` 1,5→2,0 a passi di 0,1 (`sweep_volumi_nasdaq.ps1`): unica cosa che resta da chiedere ai filtri, cioè se esiste il punto con ≥150 trade E PF ≥1,3.
- Implementare e testare il filtro volumi **sulla candela di rottura** (quello vero dei documenti — quello testato è di pre-apertura).
- Chiarire il gradino 7 leggendo il log del tester.
