# Guida Test — BULGE_MASTER (paniere diversificato)

Guida per validare l'EA **BULGE_MASTER.mq5** (Bollinger Bulge mean-reversion su forex,
timeframe **H1**) nello Strategy Tester di MetaTrader 5. Broker consigliato: **Tickmill**
(spread stretto) o BCM.

> ⚠️ **Premessa onesta:** il BULGE NON è mai stato validato seriamente. L'unico
> backtest esistente (PF 2.82 / Sharpe 7.5) era su ~40% dei dati e con numeri
> sospetti di **overfitting**. Questo test serve a scoprire se ha un edge VERO.
> L'out-of-sample sarà decisivo: se crolla fuori campione, si scarta.

---

## 0) Il paniere diversificato (4 cross, driver diversi)

Invece dei 22 cross di default (troppo correlati = una scommessa sola), testiamo
**4 coppie con driver valutari diversi tra loro** = vera diversificazione:

| Cross | Driver principale |
|---|---|
| **EURUSD** | Euro / Dollaro (il più liquido) |
| **GBPJPY** | Sterlina / Yen (volatilità alta, risk sentiment) |
| **AUDUSD** | Dollaro australiano (commodity / risk-on) |
| **USDCAD** | Dollaro / Canada (legato al petrolio) |

---

## 1) ⚠️ Metodo: UN cross alla volta (non tutti insieme)

Il BULGE è multi-simbolo, ma lo Strategy Tester MT5 modella male i simboli diversi
da quello del grafico. Per un test **affidabile con tick reali**, si testa
**ogni cross separatamente**:

Per OGNI cross (EURUSD, GBPJPY, AUDUSD, USDCAD):
1. Apri lo Strategy Tester (`Ctrl+R`)
2. **Symbol** = il cross che stai testando (es. EURUSD)
3. **Timeframe** = **H1** (il BULGE lavora su H1)
4. Nell'EA, imposta l'input **`Symbols_List`** = SOLO quel cross (es. `EURUSD`)
   → così l'EA opera solo su quel simbolo, con i suoi tick reali
5. **Modeling** = Every tick based on real ticks
6. Lancia il test

Ripeti 4 volte (uno per cross) × 2 periodi (in-sample + OOS) = 8 report.

> 💡 **Buona notizia:** i tick reali del **forex major** si scaricano molto più in
> fretta del DAX/oro. Puoi farlo mentre il DAX completa il download.

---

## 2) Periodi: in-sample + out-of-sample

| Fase | Periodo | A cosa serve |
|---|---|---|
| **In-sample** | 2023-01-01 → 2024-12-31 | riferimento / tuning (non curve-fit) |
| **Out-of-sample** | 2025-01-01 → 2026-06-19 | **verifica onesta — è il numero che conta** |

Scarica i tick da **almeno ottobre 2022** (warm-up di BB/ATR/ADX a 50 barre H1).

---

## 3) Impostazioni / parametri (lascia i default v4.00)

| Campo | Valore |
|---|---|
| Expert | `BULGE_MASTER` |
| Deposit | uguale alla challenge (es. 100.000) o 10.000 per coerenza con l'oro |
| Leverage | quella del conto prop |
| Risk_Percent | **0.5** (basso, profilo prop) |
| Use_Kill_Switch | true (Max_SL/giorno 4, consecutivi 3, daily loss 2%) |
| Segnali | Blu + Viola ON, Arancio OFF (default) |
| Use_ADX_Filter | true (anti band-riding) |
| Use_ATR_Filter | true (evita caos/piatto) |

Magic Number: 20250100 (default).

---

## 4) Criteri di accettazione (per OGNI cross, in OUT-OF-SAMPLE)

| Metrica | Soglia minima | Ideale |
|---|---|---|
| **Max Drawdown** | < 6% | < 4% |
| **Profit Factor** | > 1.3 | ≥ 1.5 |
| **N. trade** | > 100 | > 200 |
| **Recovery Factor** | > 2 | > 3 |
| **Out-of-sample vs in-sample** | PF non deve crollare | stabile |

**Bandiere rosse (= scarta quel cross):**
- PF ottimo in-sample, scarso out-of-sample → overfit
- Pochissimi trade → non è statistica
- DD oltre 6%

---

## 5) Analisi di portafoglio (DOPO i singoli test)

Una volta che hai i 4 cross testati, il punto NON è solo "quanti sono profittevoli",
ma **quanto sono indipendenti tra loro**:
1. Prendi le curve equity dei cross che passano i criteri.
2. Verifica che le perdite NON arrivino tutte negli stessi periodi (bassa correlazione).
3. Solo i cross profittevoli E poco correlati entrano nel portafoglio prop.

Un BULGE su 2 cross davvero indipendenti vale più di 4 che perdono insieme.

---

## 6) Cosa mandarmi

Per ogni cross: i report HTML (in-sample + OOS) + la % qualità modellazione.
Da lì analizzo:
- quali cross hanno un edge reale,
- la correlazione tra loro,
- se il BULGE può essere la **terza strategia** del portafoglio, poco correlata
  a oro (trend) e DAX (breakout).

---

### Checklist veloce
- [ ] Scaricati tick reali forint dei 4 cross (da ott. 2022)
- [ ] EURUSD: in-sample + OOS (Symbols_List=EURUSD)
- [ ] GBPJPY: in-sample + OOS
- [ ] AUDUSD: in-sample + OOS
- [ ] USDCAD: in-sample + OOS
- [ ] Confronto OOS vs in-sample (overfit?)
- [ ] Analisi correlazione tra i cross sopravvissuti
- [ ] Inviati report per analisi
