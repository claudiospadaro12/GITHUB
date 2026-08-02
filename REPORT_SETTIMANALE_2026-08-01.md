# 📊 REPORT SETTIMANALE — 24/07 → 31/07/2026

_Fonti: `ReportHistory50503392.xlsx` (statement COMPLETO) + `weekly_report.pdf` (bias) + classifiche. Analisi Claude._
_Conto: DEMO BCM **50503392** (EUR, Hedge). Bilancio fine periodo: **5.742,91 €**._

---

## ⚠️ 0. CONTESTO CRITICO (leggere prima dei numeri)
Questa settimana (24-31/07) è **PRIMA della ricompilazione VPS del 01/08** che ha corretto il **bug gestione Hedge** (`SelectMyPosition`) → gestione ora **per-ticket**.

### 🔴 COSA È SUCCESSO DAVVERO SUL DAX (racconto di Claudio, confermato dai dati)
> *"Ero +800 e sono finito −700 perché NON ha parzializzato né portato lo stop in pari."*

**Confermato dallo statement.** Il 29/07 c'erano **molte posizioni DAX aperte contemporaneamente**; il bug Hedge faceva gestire all'EA **una sola** posizione per simbolo → le altre **senza parziale e senza breakeven** → i trade andati in profitto sono **tornati indietro fino allo STOP PIENO**.
- **Prova nei dati:** il **29/07** su ~10 trade DAX **solo 1** ha lo SL portato a pari; tutti gli altri con SL fermo all'entrata → stop pieno. Il **30/07** invece (meno sovrapposizioni) il "SL=entry (BE)" compare su **molti** trade → lì la gestione è scattata.
- Non è (solo) "doppioni": la **causa** è la gestione Hedge che non partiva sulle posizioni non-selezionate. **È esattamente il bug corretto il 01/08.**

👉 Quindi il buco DAX **NON è un verdetto sul motore/EA**, ma sulla **gestione pre-fix**. Il forward "pulito" parte dal **01/08**. Questa settimana = **baseline pre-fix** + quantifica quanto costava il bug (≈ −900 € sul solo DAX).
⚠️ Lo statement **non ha la colonna magic** → attribuzione per SIMBOLO/direzione, non per singolo EA.

---

## 1. 💰 ANDAMENTO REALE DEI TRADE
**84 posizioni chiuse · P/L netto −186,81 € · PF 0,90 · Win rate 60%**

| Metrica | Valore |
|---|---|
| Profitto netto | **−186,81 €** (lordo −152, commissioni −23, swap −12) |
| Profit Factor | **0,90** (sotto 1 = settimana in perdita) |
| Drawdown massimo | **1.116 € = 18,20%** ⚠️ alto |
| Media vincita / perdita | +33,4 € / **−61,8 €** (le perdite pesano il doppio) |
| Max perdite consecutive | **7 (−694 €)** |

### 📉 P/L per SIMBOLO (chi ha fatto cosa)
| Simbolo | N | P/L netto | Win | Lettura |
|---|---|---|---|---|
| **D30EUR (DAX)** | 51 | **−885,38 €** | 30/51 | ☠️ il buco: doppioni/bug pre-fix (trade identici simultanei) |
| XAUUSD (Oro) | 6 | −144,49 € | 1/6 | settimana no (size mini 0.01-0.02) |
| GBPUSD | 2 | −128,11 € | 0/2 | — |
| EURNZD | 3 | −28,11 € | 1/3 | — |
| U30USD (Dow) | 6 | +99,39 € | 4/6 | 🟢 positivo |
| EURUSD | 4 | +314,11 € | 4/4 | 🟢 perfetto |
| **NASUSD (Nasdaq)** | 12 | **+585,78 €** | 10/12 | ⭐ il migliore — ma per EA (dai COMMENTI ordini): **ORB +329**, Nasdaq Live5m +142 (1 trade), SupRev H1 +66, **Apertura US solo +47**, DAX Live5m +2. Cioè i soldi li fanno EA "morti nel backtest" (ORB/Live5m) su campione minuscolo (31/07 domina). Non l'apertura. |

### 🧭 LONG vs SHORT — enormemente direzionale
- **LONG: +511,62 €** (36/52 win) 🟢
- **SHORT: −698,43 €** (14/32 win) 🔴

### 📅 P/L per GIORNO
| Giorno | P/L | Note |
|---|---|---|
| 24/07 | +16,77 € | 1 trade |
| 27/07 | +55,82 € | |
| 28/07 | −40,66 € | |
| **29/07** | **−477,76 €** | ☠️ disastro doppioni DAX |
| **30/07** | **−320,60 €** | ancora DAX + Oro short |
| **31/07** | **+579,62 €** | 🟢 miglior giorno (NASUSD/DAX long) |

---

## 2. 🔑 LE 3 LEZIONI DELLA SETTIMANA
1. **Il buco è tutto DAX (−885 €)** e la causa NON è il motore ma la **gestione Hedge non scattata**: con più posizioni DAX aperte insieme (29/07), l'EA gestiva una sola posizione → le altre **senza parziale né stop-in-pari** → i profitti (+800) sono tornati a **stop pieno** (−700). **Bug corretto il 01/08** (gestione per-ticket). Senza il DAX la settimana era **≈ +700 €**. → il vero forward parte ora.
2. **SHORT −698 vs LONG +512**: settimana **anti-trend** (coerente col bias al 25%). Gli short hanno sanguinato. Il DAX apertura era già noto come **"ottimo solo LONG"** → conferma sul campo.
3. **Nasdaq è il cavallo** (+586, 83% win) — ma dai COMMENTI ordini il merito è di **ORB (+329)** e **Nasdaq Live5m (+142, 1 trade)**, EA classificati "morti" nel backtest, su campione minuscolo (il 31/07 domina). L'**Apertura US** ha fatto solo +47, il **SupRev H1** +66. → NON è né l'apertura né il SupRev: è rumore fortunato di 2 settimane, da tenere d'occhio ma non da promuovere. **Dow positivo** (+99), **Oro settimana no** (ma size minima).

---

## 3. 🎯 Il BIAS del report giornaliero era corretto? **NO — 25%**
20/80 coerenti. 🟢 Nasdaq 80%, Nikkei 60%. ⛔ 0%: FTSE MIB, WTI, EUR/USD, USD/JPY, USD/CAD, AUD/USD.
→ Settimana di **reversal**: favorisce i motori reversal (SupRev/EMA200), penalizza breakout/short. Altra spinta a favore del test **RETEST** sulle aperture.

---

## 4. 🏆 SIMBOLI/EA MIGLIORI (backtest validato tick reali — la classifica che conta)
_Una settimana pre-fix non cambia il ranking; lo confermano però Nasdaq/Dow/Long._

**⭐ TOP prop-grade (DD più basso):**
1. Nikkei 225 SupRev H4 — DD 0,14%
2. Oro SupRev H4 — PF 1,46 / DD 1,2%
3. **Nasdaq SupRev H1 — PF 1,40 / DD 1,2%** (NB: in forward ha fatto solo +66 dei +586 Nasdaq; il grosso è ORB/Live5m — vedi §1)
4. 200AUD EMA200 H4 — PF 1,59 / DD 1,4%
5. GoldenCross USDCHF H4 — PF ~2,6 / DD 1,9%

**🥇 Miglior strategia: EMA200** (6/8 reggono i tick reali, nessuno crolla). Squadra forward: **13 EA, 3 strategie**.

---

## 4b. 🧪 PRIMO DATO TICK-REALI col fix gestione (02/08) — Dow STOP
Backtest tick reali Dow (U30USD) M5, STOP, **con la nuova gestione per-ticket**:
- **PF mediano 1,30** · **100% pass positivi** (143/143) · DD ~7,9% · ~348 trade · distribuzione 1,14–1,31 (stretta = robusta).
- 📈 **Prima del fix era 1,16 → ora 1,30**: il solo fix parziale/BE per-ticket ha migliorato il motore STOP. Conferma che il fix serviva.
- DD ~8% resta alto per la prop → apertura resta roba da "conto personale".
- ⏳ Mancano ancora: Dow RETEST, Nasdaq (no storico M5 sul tester), DAX STOP/RETEST → confronto STOP vs RETEST da completare (script corretto, vedi sotto).

## 5. ⏭️ AZIONI
1. ✅ Statement completo ricevuto e analizzato.
2. 🔴 **Verificare sul VPS che i doppioni DAX siano spariti** dal 01/08 (dopo il fix): controllare che non ci siano più trade identici simultanei su D30EUR. È la prova che il buco −885 non si ripete.
3. 🟡 **Considerare di spegnere/limitare gli SHORT** sul DAX apertura (dato "solo LONG") e i "morti" ancora accesi in demo.
4. 🟢 **Lanciare `confronto_aperture.ps1`** (STOP vs RETEST) — la settimana anti-trend rafforza l'ipotesi.
5. 🟢 Lasciar girare il forward PULITO dal 01/08 → pagella reale ~2-3 mesi.
