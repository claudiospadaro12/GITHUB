# Piano di Trading — Strategia ORO (XAUUSD)

> *"Plan a Trade and Trade a Plan."* Documento personale di Claudio Spadaro.
> Formato ispirato al piano FiboH4 di Paolo, adattato all'operatività sull'oro.
> *Bozza v1 — i campi [DA CONFERMARE] vanno definiti insieme. Ultimo agg.: 2026-06-19.*

---

## Razionale
La strategia sull'oro è uno **scalping/intraday momentum**: si opera **in direzione della spinta del momento**, usando l'incrocio **Ichimoku (Tenkan/Kijun)** e l'**inclinazione/espansione delle Bollinger** confermati su **più timeframe** (M5 operativo, M1 di conferma). La gestione è **attiva**: parziale rapida + break-even + trailing, per chiudere spesso in positivo (alto win rate) e lasciar correre i movimenti forti. Si opera **solo quando c'è volatilità reale** (filtro ATR/ADR): non su ogni candela.

---

## 1) Money Management
- a) **Position size per operazione:** **[DA CONFERMARE]** — proposta **1%** del capitale (Paolo usa 2%). Size di partenza sull'oro **0,50 lotti**, da rapportare al rischio.
- b) **Rapporto rischio/rendimento:** stile a **parziali** (non R:R fisso). Sul *runner* (residuo) puntare almeno **1:1,5 – 1:2**; la maggior parte dei trade chiude con parziale rapida.
- c) **Drawdown massimo tollerato:** **[DA CONFERMARE]** — proposta **10%** (sia in % sia in €). Raggiunto il limite → **stop e revisione**.

---

## 2) Strategia operativa

### a) Generalità
- **Tipo trade:** Intraday — scalping/momentum **con-trend** (a mercato).
- **Strumento:** XAUUSD. **Time frame operativo:** M5. **Conferma:** M1 (ed eventualmente M15).
- **News:** prima di news ad alto impatto **si chiudono le posizioni / non si entra** (l'oro è molto sensibile).
- **Fascia oraria:** **[DA CONFERMARE]** — tu dici "a istinto, senza orari fissi". Consigliata comunque la preferenza per le **sessioni attive (Londra/New York)**, dove l'oro si muove di più.

### b) Setup grafico
- Candele giapponesi.
- **Ichimoku:** Tenkan **7** (linea rossa = dà la direzione), Kijun **22**, Senkou B **44**, displacement **26** (nuvola Kumo).
- **Bollinger:** periodo **20**, dev. **2.0**.
- **ATR(14)** per volatilità e stop.
- **Alert Ichimoku** impostato su TradingView (ti avvisa al segnale).

### c) Regole di ingresso (due modalità)
**Modo A — Ichimoku multi-timeframe:**
- Incrocio **Tenkan/Kijun**; la **linea rossa (Tenkan)** dà la direzione.
- Entro se **≥ 2 timeframe sono concordi** (es. M5 **e** M1 nella stessa direzione).

**Modo B — Bande inclinate:**
- Le **Bollinger sono inclinate** nella stessa direzione **sia su M1 sia su M5** → entro in quella direzione.

**Filtro di selettività (obbligatorio):** entro **solo con volatilità sufficiente** (ATR/ADR adeguato). *Non entrare su ogni candela: solo quando c'è l'opportunità.*

### ✓ AVVERTENZE (quando NON si trada)
- a) **Niente trade in lateralità** / volatilità bassa (ATR piccolo).
- b) **Niente trade contro** la direzione del momento.
- c) **Niente trade a ridosso di news** ad alto impatto.
- d) Non forzare: se non c'è un setup chiaro, **si resta fuori**.

### d) Stop loss
- **Iniziale:** stretto, basato su **struttura/ATR** (sotto/sopra il minimo/massimo recente).
- **Break-even:** sposto lo stop a pari **appena il broker lo consente** (prezzo oltre l'ingresso della distanza minima).

### e) Take profit / gestione
- **Parziale 50%** al raggiungimento di **+€20** di profitto ("porto sempre qualcosa a casa").
- **Sul residuo:** **trailing ATR-adattivo** (più largo nei trend forti, per reggere i ritracciamenti su M1).
- **Uscita a tempo:** se dopo **~2 candele** il trade non funziona → chiudo.
- **Uscita anticipata:** se la **forza rallenta** (bande che si contraggono / ATR in calo) → stringo o chiudo.

---

## 3) Limiti di sessione (regole anti-emotività)
- **Max operazioni al giorno:** **[DA CONFERMARE]** — proposta **6**.
- **Target giornaliero:** **+€500** → **stop sessione** (blinda la giornata). *(Tetto per chiudere bene, NON aspettativa quotidiana.)*
- **Stop perdita giornaliero:** **−€300** → **stop sessione** (basta per oggi).

---

## 4) Disciplina e Obiettivi
- **Errori da correggere:** **[DA COMPILARE con te]** — es. non spostare lo stop in perdita; non rientrare per "vendetta" dopo una perdita; rispettare il filtro volatilità.
- **Esercizi/obiettivi:** **[DA COMPILARE]** — es. seguire il piano senza deviazioni per 20 operazioni consecutive; annotare ogni trade.
- **Quando:** review a fine sessione (5 min) + review settimanale.
- **Obiettivi realizzabili:** **[DA CONFERMARE]** — definire un target di rendimento mensile realistico e il tempo dedicato a studio/operatività.

---

## 5) Monitoraggio e Aggiornamento
- **Journal di ogni trade:** ora, direzione, **motivo d'ingresso** (Modo A/B), esito, screenshot.
- **Statistiche** (aggiornate **settimanalmente**): win rate, payoff, profit factor, drawdown.
- **Controllo conto:** P&L **giornaliero**; equity **settimanale**.
- **Revisione del piano e backtest:** **mensile**, in base ai risultati e alle condizioni di mercato.

---

### 📌 Campi da definire insieme
1. Capitale del conto (per money management e DD in €).
2. Position size % (proposta 1%) e size di partenza (0,50?).
3. Drawdown massimo tollerato (proposta 10%).
4. Fascia oraria (libera o finestra preferita?).
5. Max trade/giorno (proposta 6) e conferma target/stop giornaliero (+€500 / −€300).
6. Errori da correggere e obiettivi di disciplina (personali).
