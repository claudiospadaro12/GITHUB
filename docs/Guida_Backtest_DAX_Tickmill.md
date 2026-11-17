# Guida Backtest — DAX_MASTER_PROP su Tickmill

Guida passo-passo per validare l'EA **DAX_MASTER_PROP.mq5** nello Strategy Tester
di MetaTrader 5, broker **Tickmill** (spread stretto, lo stesso usato per validare
l'oro). Obiettivo: capire se la strategia ha un edge reale e — soprattutto — se il
**drawdown resta basso** abbastanza per una prop firm (FTMO).

> ⚠️ **Nessun numero è ancora validato.** I PF/DD/Sharpe scritti nei commenti dei
> vecchi EA erano *dichiarati*, su pochi trade e con il news filter spento. Questo
> backtest serve a verificarli da zero.

---

## 0) Prima di tutto: il simbolo DAX su Tickmill

Su Tickmill l'indice tedesco si chiama di solito **`DE40`** (a volte `DE30` o
`GER40`), NON `D30EUR` (che è il nome BCM). Apri *Market Watch → click destro →
Symbols → Indices* e trova il simbolo del DAX.

**Verifica le specifiche del simbolo** (click destro sul simbolo → *Specification*):

| Cosa guardare | Perché è critico |
|---|---|
| **Digits** (decimali) | L'EA lavora in "price units". Se DE40 ha 2 decimali (`Point=0.01`) o 1 decimale, i parametri SL/TP restano in unità di prezzo corrette. Annota il valore. |
| **Tick value / Tick size** | Servono per il calcolo lotti. Se sballati, il sizing è sbagliato. |
| **Volume min / step** | Tickmill su DE40 ha spesso lotto minimo 0.01 o 0.1 — verifica. |
| **Trading hours** | Confronta con gli orari che imposti nell'EA (punto 2). |

---

## 1) Importa dati di qualità (real ticks)

Apri lo Strategy Tester (`Ctrl+R`) e per prima cosa scarica i dati:

1. Modello dati: **"Every tick based on real ticks"** (real ticks, non "1 minute OHLC").
2. Fai partire un test breve a vuoto: MT5 scarica i tick reali da Tickmill.
3. Controlla la **% di qualità modellazione** nel report (in alto):
   - **vicino a 100%** → ottimo, dati affidabili.
   - **basso / buchi** → i tick reali Tickmill potrebbero non coprire tutto lo
     storico. In quel caso importa tick di qualità da **Dukascopy** via **TickStory**
     (stessa procedura della guida oro) e poi testa.

> Il DAX cash (DE40) ha festività e mezze sessioni: aspettati qualche buco nei
> giorni di festa — è normale.

---

## 2) ⏰ Allinea gli orari di sessione (PASSO PIÙ DELICATO)

L'EA costruisce l'ORB all'**apertura del DAX cash = 09:00 ora di Francoforte (CET)**.
Ma gli input sono in **ora del server del broker**, e Tickmill di solito gira su
**GMT+2 (inverno) / GMT+3 (estate)**, mentre Francoforte è GMT+1/GMT+2.

➡️ Spesso significa che **09:00 Francoforte = 10:00 ora server Tickmill**.

**Come verificarlo con certezza:**
1. Apri un grafico DE40 su M15.
2. Guarda a che ora (sul server, asse orizzontale) parte il movimento dell'apertura
   cash del DAX (il salto di volatilità delle 09:00 di Francoforte).
3. Se parte alle 10:00 sul grafico → il server è 1h avanti → imposta:

| Input | Valore default (BCM) | Possibile valore Tickmill |
|---|---|---|
| `InpMorningStartHour` | 9 | **10** (se server +1h) |
| `InpMorningEndHour` | 12 | 13 |
| `InpAfternoonStartHour` | 15 | 16 |
| `InpEODHour` | 21 | 22 |

> Se sbagli questo, l'ORB si costruisce sull'ora sbagliata e **tutti i risultati
> sono privi di senso**. Verifica sempre prima di lanciare il test lungo.

---

## 3) Impostazioni Strategy Tester

| Campo | Valore |
|---|---|
| **Expert** | `DAX_MASTER_PROP` |
| **Symbol** | `DE40` (il DAX di Tickmill) |
| **Timeframe** | **M15** (l'ORB mattutino lavora su M15) |
| **Modeling** | Every tick based on real ticks |
| **Deposit** | uguale alla challenge che vuoi simulare (es. 100.000) |
| **Leverage** | quella del conto prop (es. 1:30 o 1:100) |
| **Optimization** | Disabled (per il primo test singolo) |

---

## 4) Periodi: in-sample, out-of-sample, walk-forward

Non testare un solo periodo: è il modo più facile per illudersi. Usa questo schema:

1. **In-sample (ottimizzazione/tuning):** es. **2023-01-01 → 2024-12-31**.
   Qui puoi guardare i parametri, ma NON cambiarli a caso per inseguire la curva.
2. **Out-of-sample (verifica onesta):** es. **2025-01-01 → 2026-06-01**.
   Dati MAI visti durante il tuning. È QUESTO il risultato che conta.
3. **Stress per regime:** isola periodi difficili (es. **Q2 2025**, lo shock dazi
   citato nei vecchi EA) e verifica che i **4 filtri anti-shock** facciano il loro
   lavoro (poche perdite, non un disastro).

Se il PF in out-of-sample crolla rispetto all'in-sample → la strategia è
**overfittata**, non si tocca con soldi veri.

---

## 5) Parametri consigliati per il primo test (profilo prop low-DD)

Lascia i default dell'EA, che sono già conservativi:

- `InpRiskPerTradePercent` = **0.5** (rischio basso)
- `InpMaxConsecutiveSL` = **3** (halt dopo 3 stop)
- `InpMaxTotalDDPercent` = **6.0** (kill-switch sotto il 10% FTMO)
- `InpUseEquityDailyStop` = **true**
- `InpMaxDailyLossPercent` = come da regola FTMO (di solito **5%**, ma puoi tenerti
  più stretto, es. 3-4%)
- `InpHAFilterEnabled` = **false** (Heiken Ashi non validato)
- `InpTradeAfternoon` = **false** (sessione pomeridiana non validata)
- `InpTradeMonday` / `InpTradeFriday` = **false** (Lun/Ven storicamente peggiori)

Lascia gli altri filtri ai valori di default (ADX 24, distanza MA200 35, gap 75,
ecc.: sono i valori v1.8.2).

---

## 6) Cosa controllare nel report (criteri di accettazione)

Per entrare nel **portafoglio prop**, l'EA deve passare TUTTI questi punti
**in out-of-sample**, non solo in-sample:

| Metrica | Soglia minima | Ideale |
|---|---|---|
| **Max Drawdown (equity)** | **< 6%** | < 4% |
| **Profit Factor (PF)** | > 1.3 | ≥ 1.5 |
| **N. trade** | > 100 (meglio > 300) | tanti = statistica solida |
| **Recovery Factor** | > 2 | > 3 |
| **Sharpe** | > 1 | > 1.5 |
| **Kill-switch (6%)** | **mai scattato** | mai |
| **Daily loss stop** | rari, mai violato il limite FTMO | — |

**Bandiere rosse (= NON usare):**
- PF alto ma su **pochissimi trade** (es. 15-40) → non è statistica, è fortuna.
- Risultato ottimo in-sample ma scarso out-of-sample → **overfit**.
- DD oltre 6% o kill-switch scattato → la strategia non rispetta i limiti prop.
- Quasi tutto il profitto da **2-3 trade** → fragile.

---

## 7) Controlli specifici per questo EA

1. **Journal CSV:** l'EA scrive un journal dei trade. Aprilo (cartella
   `MQL5/Files` del tester) per analizzare ogni trade: quali filtri erano attivi,
   il contesto, l'esito. Utile per capire *perché* vince o perde.
2. **Long vs Short:** nei vecchi backtest lo SHORT aveva edge (WR ~57%) e il LONG
   no (WR ~35%) in un certo regime. Controlla nel report lo split long/short: se
   il LONG è strutturalmente perdente anche qui, valuteremo un bias.
3. **Effetto spread:** come per l'oro, lo spread è decisivo. Tickmill (stretto)
   dovrebbe aiutare. Se i risultati fossero molto peggiori che su uno spread
   teorico, è un segnale che la strategia è troppo sensibile ai costi.

---

## 8) Dopo il backtest

Mandami:
1. Il **report HTML** dello Strategy Tester (in-sample E out-of-sample).
2. La **% qualità modellazione**.
3. Conferma di che **simbolo** e che **orari di sessione** hai usato.

Da lì analizzo se il DAX_MASTER_PROP ha un edge reale e a basso DD, e se può entrare
nel portafoglio diversificato per la challenge prop — accanto all'oro
(Gold_Ichimoku) già validato.

---

### Riepilogo checklist veloce
- [ ] Trovato simbolo DAX Tickmill (DE40) e verificate le specs
- [ ] Scaricati dati real ticks, qualità ~100%
- [ ] **Allineati gli orari di sessione all'ora server** (passo critico)
- [ ] Test in-sample 2023-2024
- [ ] Test out-of-sample 2025-2026 (quello che conta)
- [ ] Stress test Q2 2025 (anti-shock)
- [ ] DD < 6%, PF > 1.3, kill-switch mai scattato
- [ ] Inviato report HTML per analisi
