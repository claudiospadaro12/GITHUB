# 📋 APERTURA DOW JONES (U30USD) — piano operativo e checklist

_Costruito sulla checklist ABTG "Apertura del Dow Jones (DJIA)", 8 punti._
_Claudio Spadaro — 03/08/2026 · conto demo BCM 50503392_

> ⏰ **Apertura 15:30 ora italiana = 14:30 ora server BCM** (fuso server = IT − 1).
> Il Dow è **l'unico motore di apertura che ha superato i tick reali**: PF mediano **1,30** su 348 operazioni, DD 7,9%. Tutto quello che segue parte da lì.

---

## 1) Trend su Giornaliero (D1), H4 e H1

| Cosa serve | Chi lo fa |
|---|---|
| Trend rialzista / ribassista / laterale | 🤖 **EA**: filtro `InpUseEmaFilter` — prezzo vs **EMA 50 su H4** |
| Livelli chiave di supporto/resistenza per TF | 👤 **occhio** — non meccanizzato |
| Allineamento H4/D1 con H1 | 🤖 parziale: l'EA guarda solo H4 |

**Numero che conta:** il filtro H4 sul Dow **funziona**. Studio 30/07: +0,126 R per trade col filtro, +0,074 senza. È l'unico indice dove aiuta davvero (sul DAX peggiora).

**Se D1 e H4 sono in conflitto** → giornata da saltare. L'EA non lo sa fare: valuta tu.

---

## 2) Massimi e minimi della sessione precedente

- 🤖 **EA**: `InpRangeMode = PREVBAR` + `InpLevelTF = H1` → max/min della candela H1 precedente.
- 📌 Variante del piano ABTG mai testata: **max/min dei 15 minuti pre-apertura** (15:15–15:30 IT). Da provare.
- 👤 Da tracciare a mano se vuoi il quadro completo: max/min di **ieri** (D1) e della **notte**.

---

## 3) Segnali: breakout o rimbalzo

### Breakout — *è il motore che usiamo*
Ordini pendenti oltre il livello: **BUY STOP** sopra il massimo, **SELL STOP** sotto il minimo. OCO: quando uno parte, l'altro si cancella.

⚠️ **Due conferme che il piano richiede e che l'EA oggi NON applica sul Dow:**
- **chiusura di candela** oltre il livello (l'EA entra *durante* la rottura);
- **conferma di volumi** sulla rottura.

Sul Nasdaq il filtro volumi ha portato il PF da 0,91 a 1,38. **Sul Dow non è ancora stato provato** — è il primo test da fare.

### Rimbalzo — *bocciato sui numeri*
Testato come "retest": **PF 0,94 contro 1,30 del breakout**. Sul Dow inseguire la rottura batte l'attesa del ritorno. Non usarlo.

---

## 4) Indicatori tecnici

| Indicatore | Nell'EA | Nota |
|---|---|---|
| **Medie mobili** | ✅ EMA 50 su H4 come filtro direzionale | l'unico validato sul Dow |
| **RSI** (ipercomprato/ipervenduto) | ❌ non implementato | da valutare come filtro |
| **Bande di Bollinger** | ❌ non implementato | nel piano europeo, mai testato |
| Supertrend | ✅ disponibile, spento di default | |
| Correlazione SPXUSD | ✅ disponibile | acceso peggiora il Dow (DD 7,9→13,5%) |

**Attenzione:** aggiungere indicatori *sembra* prudente ma taglia il campione. Sul Nasdaq l'ATR ha bocciato 24 configurazioni su 24 pur "confermando la volatilità". **Un indicatore si aggiunge solo dopo averlo misurato da solo.**

---

## 5) Notizie ed eventi economici

- 🤖 **EA**: `InpUseNewsFilter` legge `abtg_news.csv` e blocca l'operatività intorno ai dati a 3 tori. `InpNewsFlatten` chiude l'esposizione.
- 📏 Regola del ToolKit ABTG: **niente trade se ci sono notizie rosse nelle prossime 2 ore** (`InpNewsBeforeMin = 120`).
- ⚠️ Il CSV va tenuto aggiornato **a mano sul VPS** (`MQL5/Files/`): non si aggiorna da solo.

**Date fisse da ricordare:** FOMC alle 20:00 IT = 19:00 server. Nei giorni FOMC l'apertura Dow è da saltare.

---

## 6) Dimensionamento della posizione

**Formula** (è quella che l'EA applica da solo):

```
Lotti = (Capitale × Rischio%) ÷ (Distanza stop in punti × Valore del punto)
```

| Conto | Rischio 1% | Rischio 2% |
|---|---|---|
| **6.000 €** (demo forward BCM) | 60 € per trade | 120 € per trade |
| **100.000 €** (demo prop) | 1.000 € per trade | 2.000 € per trade |

- 🤖 L'EA calcola i lotti da solo con `InpRiskPercent`, leggendo il valore del punto dal broker. **Non serve calcolarli a mano.**
- 📏 Massimo del piano ABTG: **2%**. Preset Dow attuale: **1%** (più conservativo).
- ⚠️ Più lo stop è largo, più piccola diventa la posizione. È il principio giusto: si adatta la size al rischio, non il contrario.

---

## 7) Stop loss e take profit

| Elemento | Valore | Fonte |
|---|---|---|
| **Stop loss** | bordo opposto del range (`SLMode = RANGE`) | slide Nasdaq: *"porto lo stop sui massimi precedenti"* |
| Alternativa | 5–10 punti indice oltre il livello rotto | ToolKit ORB |
| **Primo obiettivo** | 1R → si chiude **il 50%** | piano: *"TP in divenire, dimezzando"* |
| **Poi** | stop **in pari** | piano |
| **Runner** | trailing sulla base della candela **M1** | slide Nasdaq |
| **RR minimo** | 1:1,5 · ideale **1:2** | ToolKit + piano gap fill |

⚠️ **Divergenza da risolvere:** il ToolKit dice *"lo stop si imposta UNA volta e non si tocca più"*, con TP fisso 1:2. Il nostro EA invece parzializza, va in pari e traila. **Sono due filosofie opposte e non sappiamo quale sia migliore sul Dow** — va misurato.

---

## 8) ✅ CHECKLIST DI CONFERMA INGRESSO

Da verificare **prima** che parta l'operazione. Se anche una sola non è soddisfatta, **la giornata si salta.**

**Prima delle 15:30 IT**
- [ ] Calendario controllato: **nessuna notizia rossa nelle prossime 2 ore**
- [ ] Trend H4 identificato (prezzo sopra o sotto EMA 50)
- [ ] D1 e H4 **non in conflitto**
- [ ] Max/min della candela H1 precedente tracciati
- [ ] Nessun livello tecnico importante **entro 10–15 punti** dall'ingresso previsto

**All'apertura (15:30 IT / 14:30 server)**
- [ ] Il range si è formato ed è di ampiezza normale (né piatto né esplosivo)
- [ ] Gli ordini pendenti sono a **+7/+10 punti** oltre il livello
- [ ] Lo stop è al bordo opposto e la size è coerente col rischio scelto
- [ ] L'operazione è **a favore** del trend H4, non contro

**Dopo l'ingresso**
- [ ] OCO ha cancellato l'ordine opposto
- [ ] Primo obiettivo → parziale 50% + stop in pari
- [ ] **Lo stop non si allarga mai.** Si sposta solo a favore

---

## 📊 I numeri del Dow, per non dimenticarli

| Configurazione | PF | DD% | Trade | Esito |
|---|---|---|---|---|
| **Breakout STOP + filtro H4** | **1,30** | 7,9 | 348 | 🟢 **il setup da usare** |
| + tutti i filtri del piano | 1,11–1,21 | 11–13,8 | 106 | 🟡 peggiora e alza il DD |
| Retest (rimbalzo sul livello) | 0,94 | 11,0 | 452 | ❌ |
| Ingresso ritardato/confermato | 0,66 | 8,3 | 116 | ❌ |

**Preset in forward:** `ABTG_Apertura_Dow_U30_H4.set` — magic **770221**, filtro H4 acceso, rischio 1%.

---

## ⏭️ I due test aperti sul Dow

1. **Filtro volumi** — sul Nasdaq ha portato il PF da 0,91 a 1,38. Sul Dow non è mai stato provato, e il Dow parte già da 1,30.
2. **Gestione: parziale+BE+trailing contro stop fisso + TP 1:2** — le due filosofie non sono mai state confrontate sullo stesso motore.

---

*Ogni numero viene da backtest a tick reali (2024.01–2026.06, ~625 giorni di borsa) archiviati e riproducibili. Dove una regola del piano non è implementata è scritto esplicitamente: serve a sapere cosa stiamo misurando davvero.*
