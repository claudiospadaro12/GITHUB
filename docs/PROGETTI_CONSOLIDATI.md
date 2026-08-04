# 📦 Progetti consolidati su `lavoro` (04/08/2026)

Consolidamento di **tutto il lavoro** su un unico branch = **`lavoro`**, così c'è **un solo riferimento**.
Portati 58 file (solo codice/documenti, 0 dump di risultati) dagli altri branch, **in modo additivo** (nessun file esistente sovrascritto).

## Da `friendly-hamilton-u32q1h` (44 file)
- **EA MT5:** BULGE_MASTER, DAX_MASTER_PROP, DAX_M3_Supertrend, BREAKOUT_EA_JPY (+Multi), EasyTrend_EURUSD, Gold_Ichimoku_TK_ATR_EA, Gold_Scalper_TK_BB_BE_EA, HARSI_Assistant, ORB_DAX_BASE/PM, ORB_GOLD_FIBONACCI (+v3.21), ORB_OpeningRange
- **Indicatori:** HARSI_JayRogers
- **Pine (TradingView):** Universal_Scalper_Pro_alerts, Gold_Ichimoku_ATR (indicator+strategy, v1/v2/v3), HARSI (signals+backtest), Ichimoku_TK_Cross_Bollinger, DAX_M3_Supertrend_Backtest, Confronto_Ichimoku_vs_EMA_HA, Gold_Direzionale_Ichimoku_BB
- **Documenti:** Playbook_XAUUSD, Piano_di_Trading_Oro, Portafoglio_Strategie, Oro_Giornate_Direzionali, Analisi_EA_BULGE/DAX, Analisi_Trading_Manuale_Scalper, Guida_Backtest_DAX_Tickmill, Guida_Test_BULGE, Test_Ichimoku_vs_EMA_HA + README vari

## Da `practical-goodall-s8zauu` (4 file)
- GoldBreakout_Levels.mq5, IchiCross_Gold_722.mq5, IchiCross_Bollinger_Dashboard.mq5 (indicatore), agente mql5-ea-developer

## Da `ea-market-openings-d79m8l` (8 file)
- Versioni `standalone/` di: SupertrendReversal (+Multi), PTE, WOL, Nightly, Londra_ORB, FiboH4_Multi
- Script: valida_realtick_gc.ps1

## Da `creating-agents-SgGpD` (2 file)
- Snapshot giornalieri: data/snapshots/2026-08-03.json, 2026-08-04.json

## Branch senza file unici (già tutto su lavoro)
- `fix-daily-report-cron` · `backtest-pipeline-review-et11mo`

---
⚠️ `claude/chat-ea-market-openings-zoba2j` (vecchio nome): 0 file unici, da cancellare (il proxy blocca la cancellazione via git → cancellare dal web: GitHub → Branches → cestino).
Gli altri branch NON sono stati cancellati: restano come backup finché non confermi che `lavoro` va bene.

## ⏭️ PROSSIMO PASSO (con calma) — richiesto da Claudio 04/08
Rivedere **uno per uno i progetti importati** per capire se c'è qualcosa da **migliorare**:
- EA "prop-oriented": **DAX_MASTER_PROP**, BULGE_MASTER, DAX_M3_Supertrend
- Oro: Gold_Ichimoku_TK_ATR, Gold_Scalper_TK_BB_BE, IchiCross_Gold, GoldBreakout_Levels
- ORB: ORB_DAX_BASE/PM, ORB_GOLD_FIBONACCI, ORB_OpeningRange
- Altri: BREAKOUT_EA_JPY (+Multi), EasyTrend_EURUSD, HARSI_Assistant
- Pine (idee da portare in MT5): Universal_Scalper_Pro, Gold_Ichimoku_ATR, Ichimoku_TK_Cross_Bollinger
- Documenti/playbook: Playbook_XAUUSD, Piano_di_Trading_Oro, Portafoglio_Strategie
→ Per ognuno: che fa, stato, se ha edge, cosa si può migliorare. Priorità sempre: PROP (H1, trade 1-2gg, DD basso) + aperture M5 conto personale.
