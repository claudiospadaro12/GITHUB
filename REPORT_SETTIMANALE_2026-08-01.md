# 📊 REPORT SETTIMANALE — 24/07 → 31/07/2026

_Fonti: `ReportHistory50503392.xlsx` (statement COMPLETO) + `weekly_report.pdf` (bias) + classifiche. Analisi Claude._
_Conto: DEMO BCM **50503392** (EUR, Hedge). Bilancio fine periodo: **5.742,91 €**._

---

## ⚠️ 0. CONTESTO CRITICO (leggere prima dei numeri)
Questa settimana (24-31/07) è **PRIMA della ricompilazione VPS del 01/08** che ha corretto:
- il **bug gestione Hedge** e i **doppioni DAX**.

👉 Quindi le perdite qui — **soprattutto sul DAX** — sono in gran parte il **bug già corretto**, NON un verdetto sugli EA validati. Il forward "pulito" parte dal **01/08**. Questa settimana serve come **baseline pre-fix** (e a quantificare quanto costava il bug).
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
| **NASUSD (Nasdaq)** | 12 | **+585,78 €** | 10/12 | ⭐ il migliore, 83% win |

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
1. **Il buco è tutto DAX (−885 €)** e cade su 29-30/07 con trade identici simultanei = **il bug doppioni/Hedge già corretto il 01/08**. Senza il DAX, la settimana sarebbe stata **≈ +700 €**. → conferma che il fix era vitale; il vero forward parte ora.
2. **SHORT −698 vs LONG +512**: settimana **anti-trend** (coerente col bias al 25%). Gli short hanno sanguinato. Il DAX apertura era già noto come **"ottimo solo LONG"** → conferma sul campo.
3. **Nasdaq è il cavallo** (+586, 83% win) — coerente col bias 80% e col fatto che NASUSD H1 SupRev è candidato prop top. **Dow positivo** (+99), **Oro settimana no** (ma size minima).

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
3. **Nasdaq SupRev H1 — PF 1,40 / DD 1,2%** ← confermato dal forward (+586 €)
4. 200AUD EMA200 H4 — PF 1,59 / DD 1,4%
5. GoldenCross USDCHF H4 — PF ~2,6 / DD 1,9%

**🥇 Miglior strategia: EMA200** (6/8 reggono i tick reali, nessuno crolla). Squadra forward: **13 EA, 3 strategie**.

---

## 5. ⏭️ AZIONI
1. ✅ Statement completo ricevuto e analizzato.
2. 🔴 **Verificare sul VPS che i doppioni DAX siano spariti** dal 01/08 (dopo il fix): controllare che non ci siano più trade identici simultanei su D30EUR. È la prova che il buco −885 non si ripete.
3. 🟡 **Considerare di spegnere/limitare gli SHORT** sul DAX apertura (dato "solo LONG") e i "morti" ancora accesi in demo.
4. 🟢 **Lanciare `confronto_aperture.ps1`** (STOP vs RETEST) — la settimana anti-trend rafforza l'ipotesi.
5. 🟢 Lasciar girare il forward PULITO dal 01/08 → pagella reale ~2-3 mesi.
