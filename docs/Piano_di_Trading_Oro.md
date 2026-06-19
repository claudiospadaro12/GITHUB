# Piano di Trading — Strategia ORO (XAUUSD)

> *"Plan a Trade and Trade a Plan."* Documento personale di Claudio Spadaro.
> Formato ispirato al piano FiboH4 di Paolo, adattato all'operatività sull'oro.
> *v1 — Ultimo agg.: 2026-06-19.*

---

## Razionale
La strategia sull'oro è uno **scalping/intraday momentum**: si opera **in direzione della spinta del momento**, usando l'incrocio **Ichimoku (Tenkan/Kijun)** e l'**inclinazione/espansione delle Bollinger** confermati su **più timeframe** (M5 operativo, M1 di conferma). Gestione **attiva**: parziale rapida + break-even + trailing, per chiudere spesso in positivo (alto win rate). Si opera **solo quando c'è volatilità reale** e quando **l'indicatore dà il segnale**: non su ogni candela.
**Filosofia chiave:** *chiudere la giornata in positivo quasi sempre* — incassando presto e tagliando le giornate storte entro i limiti.

---

## 1) Money Management
- a) **Capitale:** **10.000 €**.
- b) **Position size:** **0,50 lotti fissi** su XAUUSD.
  - ⚠️ *Nota rischio:* 0,50 lotti = ~€45–50 per ogni $1 di movimento. Con uno stop di pochi $ il rischio è circa **1,5–2,5% del conto per trade** → relativamente **aggressivo** su 10k. Da tenere d'occhio.
- c) **Rapporto rischio/rendimento:** stile a **parziali** (non R:R fisso); sul *runner* puntare ≥ **1:1,5–1:2**.
- d) **Limite di perdita:** **3 stop consecutivi → STOP per la giornata** (oltre al limite in € sotto).
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
- **Alert Ichimoku** su TradingView (avvisa al segnale → guida l'operatività in ~1h).

### c) Regole di ingresso (due modalità)
**Modo A — Ichimoku multi-timeframe:** incrocio **Tenkan/Kijun**, direzione data dalla **linea rossa (Tenkan)**; entro se **≥ 2 timeframe concordi** (M5 **e** M1).

**Modo B — Bande inclinate:** **Bollinger inclinate** nella stessa direzione **sia su M1 sia su M5** → entro in quella direzione.

**Filtro di selettività (obbligatorio):** solo con **volatilità sufficiente** (ATR/ADR). *Non entrare su ogni candela: solo sul segnale.*

### ✓ AVVERTENZE (quando NON si trada)
- a) **Niente trade in lateralità** / volatilità bassa.
- b) **Niente trade contro** la direzione del momento.
- c) **Niente trade a ridosso di news** ad alto impatto.
- d) Nessun segnale chiaro → **si resta fuori**.

### d) Stop loss
- **Iniziale:** stretto, su **struttura/ATR** (sotto/sopra minimo/massimo recente).
- **Break-even:** stop a pari **appena il broker lo consente** (prezzo oltre l'ingresso della distanza minima).

### e) Take profit / gestione
- **Parziale 50%** al raggiungimento di **+€20** ("porto sempre qualcosa a casa").
- **Sul residuo:** **trailing ATR-adattivo** (più largo nei trend forti, regge i ritracciamenti M1).
- **Uscita a tempo:** se dopo **~2 candele** non funziona → chiudo.
- **Uscita anticipata:** se la **forza rallenta** (bande che si contraggono / ATR in calo) → stringo o chiudo.

---

## 3) Limiti di sessione (anti-emotività)
- **Target giornaliero:** **+€500** (ideale) — accettabile anche **+€300**. Raggiunto → **stop sessione** (blinda la giornata).
- **Stop perdita giornaliero:** **3 stop consecutivi** **oppure** **−€300** → **stop sessione**.
- **Principio guida:** *chiudere la giornata in positivo quasi sempre.* Nelle giornate storte: incassare il poco che c'è e fermarsi.
- ⚠️ **Regola d'oro (onestà):** "chiudere green quasi sempre" vale **SOLO** tagliando le perdite. **MAI** tenere o mediare un trade in perdita per evitare la giornata rossa → è così che si bruciano i conti. La giornata rossa *ogni tanto* (entro i limiti) è normale e accettata.

---

## 4) Disciplina e Obiettivi
- **Tempo dedicato:** **max ~1 ora/giorno** (l'oro lo consente con l'alert dell'indicatore).
- **Errori da correggere:** **[DA COMPILARE con te]** — candidati tipici: non spostare lo stop in perdita; non rientrare "per vendetta"; rispettare il filtro volatilità; fermarsi ai limiti giornalieri.
- **Esercizi:** seguire il piano senza deviazioni per **20 operazioni** consecutive; annotare ogni trade.
- **Quando:** mini-review a fine sessione (5 min) + review settimanale.
- **Obiettivo realistico:** prima **chiudere la settimana/mese in positivo** con disciplina; poi fissare un target % mensile **realistico** (da validare col journal — niente numeri da sogno).

---

## 5) Monitoraggio e Aggiornamento
- **Journal di ogni trade:** ora, direzione, **motivo d'ingresso** (Modo A/B), esito, screenshot.
- **Statistiche** (settimanali): win rate, payoff, profit factor, drawdown, € medi/giorno.
- **Controllo conto:** P&L **giornaliero**; equity **settimanale**.
- **Revisione piano e backtest:** **mensile**.

---

### 📌 Ultimo campo da definire
- **Disciplina (punto 4):** dimmi **1-2 errori** che riconosci di fare più spesso → li scrivo come regole personali da correggere.
