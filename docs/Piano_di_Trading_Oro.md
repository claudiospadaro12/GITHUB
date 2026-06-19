# Piano di Trading — Strategia ORO (XAUUSD)

> *"Plan a Trade and Trade a Plan."* Documento personale di Claudio Spadaro.
> Formato ispirato al piano FiboH4 di Paolo, adattato all'operatività sull'oro.
> *v1.0 completa — Ultimo agg.: 2026-06-19.*

---

## Razionale
La strategia sull'oro è uno **scalping/intraday momentum**: si opera **in direzione della spinta del momento**, usando l'incrocio **Ichimoku (Tenkan/Kijun)** e l'**inclinazione/espansione delle Bollinger** confermati su **più timeframe** (M5 operativo, M1 di conferma). Gestione **attiva**: parziale rapida + break-even + trailing, per chiudere spesso in positivo. Si opera **solo quando l'indicatore dà il segnale** e c'è **volatilità reale**: non su ogni candela.
**Filosofia chiave:** *chiudere la giornata in positivo quasi sempre* — incassando presto e tagliando le giornate storte entro i limiti.

---

## 1) Money Management
- a) **Capitale:** **10.000 €**.
- b) **Rischio per operazione:** **1%** = **€100 per trade**. La **size si calcola** in modo da rischiare al massimo €100 sullo **stop iniziale** (lotto adattato alla distanza dello stop — non un lotto fisso).
- c) **Rapporto rischio/rendimento:** stile a **parziali**; sul *runner* (residuo) puntare ≥ **1:1,5–1:2**.
- d) **Stop perdita giornaliero:** **−3% (€300)** → **STOP per la giornata** (≈ dopo ~3 stop pieni).
- e) **Drawdown massimo di conto:** se il conto scende del **~10%** complessivo → **stop totale e revisione del piano**.

---

## 2) Strategia operativa

### a) Generalità
- **Tipo trade:** Intraday — scalping/momentum **con-trend** (a mercato).
- **Strumento:** XAUUSD. **TF operativo:** M5. **Conferma:** M1 (ed eventualmente M15).
- **News:** prima di news ad alto impatto **si chiudono le posizioni / non si entra**.
- **Fascia oraria:** **libera** — si opera **quando l'indicatore dà il segnale** (alert Ichimoku su TradingView). Tempo dedicato: **~1 ora al giorno**.

### b) Setup grafico
- Candele giapponesi.
- **Ichimoku:** Tenkan **7** (linea rossa = direzione), Kijun **22**, Senkou B **44**, displacement **26**.
- **Bollinger:** **20 / 2.0**.
- **ATR(14)** per volatilità e stop.
- **Alert Ichimoku** su TradingView (guida l'operatività in ~1h).

### c) Regole di ingresso (due modalità)
**Modo A — Ichimoku multi-timeframe:** incrocio **Tenkan/Kijun**, direzione data dalla **linea rossa (Tenkan)**; entro se **≥ 2 timeframe concordi** (M5 **e** M1).

**Modo B — Bande inclinate:** **Bollinger inclinate** nella stessa direzione **sia su M1 sia su M5** → entro in quella direzione.

**Filtro di selettività (obbligatorio):** solo con **volatilità sufficiente** (ATR/ADR) e **solo sul segnale**.

### ✓ AVVERTENZE (quando NON si trada)
- a) **Niente trade in lateralità** / volatilità bassa.
- b) **Niente trade contro** la direzione del momento.
- c) **Niente trade a ridosso di news** ad alto impatto.
- d) Nessun segnale chiaro → **si resta fuori**.

### d) Stop loss
- **Iniziale:** stretto, su **struttura/ATR** (sotto/sopra minimo/massimo recente). Lo stop definisce la size (rischio 1%).
- **Break-even:** stop a pari **appena il broker lo consente**.

### e) Take profit / gestione
- **Parziale 50%** al raggiungimento di **+€20**.
- **Sul residuo:** **trailing ATR-adattivo** (più largo nei trend forti).
- **Uscita a tempo:** se dopo **~2 candele** non funziona → chiudo.
- **Uscita anticipata:** se la **forza rallenta** (bande in contrazione / ATR in calo) → stringo o chiudo.

---

## 3) Limiti di sessione (anti-emotività)
- **Target giornaliero:** **+€500** (ideale) — accettabile anche **+€300**. Raggiunto → **stop sessione**.
- **Stop perdita giornaliero:** **−3% (€300)** → **stop sessione**.
- **Principio guida:** *chiudere la giornata in positivo quasi sempre.*
- ⚠️ **Regola d'oro:** "chiudere green quasi sempre" vale **SOLO** tagliando le perdite. **MAI** tenere/mediare un trade in perdita per evitare la giornata rossa. La giornata rossa *ogni tanto* (entro il −3%) è normale e accettata.

---

## 4) Disciplina e Obiettivi
- **Tempo dedicato:** **max ~1 ora/giorno**.
- **I MIEI 2 errori da correggere (regole personali):**
  1. ❌ *Entro senza segnale* (capita in demo, per noia/leggerezza). → ✅ **REGOLA: entro SOLO sul segnale dell'indicatore. Nessun segnale = nessun trade.** Tratto la demo **come fosse reale**.
  2. ❌ *Allargo lo stop quando il prezzo ritraccia* (perché non conosco bene le zone). → ✅ **REGOLA: lo stop NON si allarga MAI. Si muove solo a favore (break-even/trailing).** Prima di entrare, **studio e segno le zone** (supporti/resistenze, pivot) così lo stop è giusto fin da subito.
- **Esercizio:** seguire il piano senza deviazioni per **20 operazioni** consecutive, annotandole.
- **Review:** mini-review a fine sessione (5 min) + review settimanale.
- **Obiettivo realistico:** prima **chiudere la settimana/mese in positivo** con disciplina; poi fissare un target % mensile **realistico** dal journal (niente numeri da sogno).

---

## 5) Monitoraggio e Aggiornamento
- **Journal di ogni trade:** ora, direzione, **motivo d'ingresso** (Modo A/B), esito, screenshot.
- **Statistiche** (settimanali): win rate, payoff, profit factor, drawdown, € medi/giorno.
- **Controllo conto:** P&L **giornaliero**; equity **settimanale**.
- **Revisione piano e backtest:** **mensile**.
