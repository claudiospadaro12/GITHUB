# 📊 Portafoglio Strategie di Trading — Registro

> Documento di lavoro: traccia tutte le strategie sviluppate, il loro **stato** (validata / scartata / in corso), le **metriche chiave** e la **roadmap**.
> Aggiornare a ogni nuovo test. *Ultimo aggiornamento: 2026-06-17.*

---

## 🎯 Visione

Costruire un **portafoglio di strategie** diversificato su più asset (oro, indici, materie prime) e più stili (trend, breakout/espansione, range, apertura), **tenendo solo quelle con un edge reale e robusto**.

> 🔑 **Principio chiave: diversificare = BASSA CORRELAZIONE, non "tanti EA".**
> 7 EA sui cross JPY = un'unica scommessa sullo yen (drawdown −83%). NON è diversificazione.
> La diversificazione vera nasce da **asset poco correlati × stili che guadagnano in fasi opposte**.

---

## 🗺️ Matrice Asset × Strategia

Legenda: ✅ validata · 🟡 in corso · 🔜 in programma · ❌ scartata · ⬜ non iniziata

| Asset | Trend-following | Espansione/Breakout | Range/Mean-rev | Apertura (ORB) |
|---|---|---|---|---|
| **Oro (XAUUSD)** | ✅ Ichimoku TK+ATR *(valido su broker spread stretto)* | 🔜 prossimo | ⬜ (difficile, costi) | ⬜ |
| **Indici** (DAX, US500, NAS100) | ⬜ | ⬜ | ⬜ | ⬜ (buono per indici) |
| **Materie prime** (WTI, argento, gas) | ⬜ | ⬜ | ⬜ | ⬜ |
| **Forex** (storico) | — | ❌ Breakout JPY | — | — |

---

## 📒 Registro dettagliato delle strategie testate

### ✅ Gold Ichimoku TK + ATR — VALIDATA (su broker a spread stretto)

> 🎯 **Svolta 2026-06-18:** lo **spread di BCM** era il killer. Stesso EA/periodo/config su **Tickmill (Raw, spread stretto)**, XAUUSD H1 2015-2026, default 7/22/1.5:
> **PF 1,54** · netto **+8.408 €** · **max DD 4,57%** · **Sharpe 2,53** · **Recovery 9,06** · 661 trade · win 34,8% · payoff 2,9.
> Su **BCM** (spread largo) lo stesso test dava PF 1,01 / DD 28%. → Per le nostre soglie è **candidato LIVE**. Parametri di default (non ottimizzati) = nessun overfitting.
> **Cautele:** qualità storico 64% (riscaricare per confermare ~PF 1,5) · poi forward test demo su Tickmill prima del live.


- **Asset/TF:** XAUUSD, H1 · **Stile:** trend-following
- **Logica:** Ichimoku Donchian (Tenkan 7 / Kijun 22 / SenkouB 44), entrata su cross TK + filtro Kumo, SL su ATR (×1,5), uscita su cross opposto. **Solo Long.**
- **Backtest 2006–2026 (rischio 0,3%):** PF **1,42** · netto **+390%** · max DD **12,3%** · 1.885 trade · win 42% · payoff 1,94 · **17 anni positivi su 21**.
- **Scaling rischio:** 0,5% → +1.602% / DD 17% · 1% → +30.543% / DD 30% *(il PF "sale" solo per compounding, l'edge per-trade resta ~1,42)*.
- **Esiti dei test:** i filtri ADX/espansione **uccidono l'edge** (PF→0,99, entri tardi). Il "lascia correre" (trailing Kijun) **peggiora** (PF 1,32). Il TP fisso 2R ≈ uscita su cross (il TP non veniva quasi mai colpito).
- **Caveat onesto:** edge **regime-dipendente** (vive sui trend dell'oro; perde poco nei laterali 2012/18/22). È una scommessa long strutturale sull'oro.
- **File:** `pine/Gold_Ichimoku_ATR_Strategy_v3.pine` (+ indicator), `mql5/Experts/Gold_Ichimoku_TK_ATR_EA.mq5`
- **Prossimo passo:** 🟡 backtest MT5 di verifica → **ottimizzazione walk-forward** (pochi parametri: Tenkan/Kijun/atrMultSL).
- **Verifica MT5 (XAUUSD H1, 2024-01→2026-06, tick reali 78%, Solo Long, EXIT_CROSS, 0,3%):** PF **1,31** · netto +1.227 € (+12,3%) · **max DD 4,38%** · Sharpe **1,78** · recovery 1,73 · 217 trade · win 33,6% · payoff 2,6. → Conferma il Pine (differenze attese per spread reale ed esecuzione MT5). DD e Sharpe ottimi; PF al confine demo → obiettivo walk-forward alzarlo.

### ❌ Breakout JPY — SCARTATA
- **Asset/TF:** 7 cross JPY (USDJPY, EURJPY, GBPJPY, CHFJPY, CADJPY, NZDJPY, AUDJPY), M15 · **Stile:** breakout di inversione (fade)
- **Backtest paniere 2022–2024:** aggregato **−20.853 €**, **tutte** le coppie con PF < 1 (0,67–0,95), drawdown 30–48% per coppia.
- **Perché no:** nessun edge; rapporto reale ~1:1 invece del 3:1 teorico; 7 cross JPY **altamente correlati** = un'unica scommessa sullo yen. Disattivare le chiusure anticipate aiutava ma restava marginale.
- **File:** `mql5/Experts/BREAKOUT_EA_JPY.mq5`, `BREAKOUT_EA_JPY_Multi.mq5`

### ❌ Easy Trend (forex) — SCARTATA su EUR/USD
- **Asset/TF:** EUR/USD, H1 · **Stile:** divergenze CCI + Linear Regression Candle, RR 1:1
- **Backtest 2024-07→2026 (tick reali 99%):** PF **1,04** · +319 € · DD 16% · win 52,7% · 74 trade → break-even.
- **Trappola evitata:** "Short-only" sembrava ottimo (PF 1,58) ma su **soli 39 trade**; out-of-sample 2015–2024 (152 trade) → PF **0,999** = testa o croce. Illusione da campione piccolo + selection bias.
- **File:** `mql5/Experts/EasyTrend_EURUSD.mq5` (ha input `TradeDirection`)
- **Nota:** 🔜 da **ri-testare sugli indici** (potrebbe comportarsi diversamente).

---

## ✅ Protocollo di validazione (OBBLIGATORIO per ogni strategia)

Una strategia passa a "validata" **solo se** supera tutti questi punti:

1. **Multi-anno / multi-regime** — testare su anni di trend *e* di laterale (idealmente 8+ anni).
2. **Tick reali** quando possibile.
   - ⚠️ Broker **BCM Markets**: tick reali solo **dal 5 luglio 2024**. Per storico profondo → importare dati **Dukascopy** (TickStory) o usare i dati di **TradingView**.
3. **Costi inclusi** (spread + commissioni). Mai fidarsi di backtest senza costi (es. TradingView ignora lo spread di default).
4. **Out-of-sample / walk-forward** — ottimizzare su una finestra, validare su una **mai vista**. Tenere i parametri solo se reggono OOS.
5. **Campione sufficiente** — centinaia di trade. **Diffidare di PF alti su < 50 trade** (quasi sempre illusione).
6. **Drawdown sostenibile** — un edge con DD da blow-up non è tradeable.
7. **Niente over-filtering / over-fitting** — se la versione semplice funziona, lasciarla semplice.
8. **Correlazione** — prima di sommare due EA al portafoglio, verificare che le loro curve equity siano **poco correlate**.

> 📌 Regola d'oro: **se non passa, si scarta.** Niente affezione "perché ci abbiamo lavorato".

### 📐 Soglie di accettabilità (demo vs live)

| Metrica | ❌ Scarta | 🟡 Demo (promettente) | ✅ Candidato live |
|---|---|---|---|
| **Profit Factor** | < 1,3 | 1,3 – 1,5 | 1,5 – 2,0 *(>3 = sospetto overfit)* |
| **Max Drawdown** | > 35% | 20 – 35% | < 20% (ottimo < 15%) |
| **Recovery Factor** (netto/maxDD) | < 2 | 2 – 5 | > 5 |
| **Sharpe** | < 0,5 | 0,5 – 1,0 | > 1,0 (ottimo > 2) |
| **N° trade** | < 100 | 100 – 300 | > 300 (ideale 500+ su 5 anni) |
| **Expectancy/trade** | ≤ 0 | > 0 | > 0 stabile su OOS |

**Requisiti NON negoziabili (oltre ai numeri):** costi inclusi · tenuta **out-of-sample/walk-forward** · multi-anno/multi-regime · niente overfitting.

**"Haircut" del live (lascia margine):** dal vivo è sempre peggio del backtest → PF cala ~0,2–0,3 · DD cresce ~1,5× · Sharpe cala ~0,5–1,0. Quindi un PF 1,5 in backtest ≈ ~1,2–1,3 reale.

**Processo:** backtest passa le soglie → **forward test in demo 1–3 mesi** → se demo ≈ backtest → **live con size piccola** → si scala solo dopo storico reale.

---

## 🚦 Roadmap (in ordine)

1. 🟡 **Oro trend** — finire backtest MT5 → ottimizzazione walk-forward.
2. 🔜 **Oro espansione/breakout** — volatility breakout (squeeze→esplosione). Candidato forte sull'oro.
3. 🔜 **Oro apertura (ORB)** — breakout sulle aperture Londra/NY.
4. 🔜 **Easy Trend sugli indici** — DAX (fascia 8–18) e indici USA (fascia ~14–22).
5. ⬜ **Trend/breakout su indici e materie prime.**
6. ⬜ **Range / TF basso** — per ultimo, aspettative basse (costi elevati su TF basso).
7. ⬜ **Backtest di portafoglio** — combinare le validate, misurare correlazione e curva equity aggregata.

---

## 🛠️ Note tecniche ricorrenti

- **Tick reali BCM:** dal 5 lug 2024. Pre-2024 = tick generati (qualità bassa).
- **Costi sull'oro:** spread relativamente ampio → penalizza i sistemi a TF basso e ad alta frequenza.
- **Compounding:** alzare il `RiskPercent` gonfia profitto e PF ma alza il drawdown; l'edge per-trade non cambia.
- **PF onesto:** per un trend-follower su singolo strumento, **1,4–1,6** è un buon valore. PF 2+ su lungo periodo = sospetto di overfitting.
