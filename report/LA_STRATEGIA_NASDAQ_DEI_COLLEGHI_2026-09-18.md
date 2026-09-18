# 🇺🇸 LA STRATEGIA NASDAQ DEI COLLEGHI — cosa c'è davvero nell'EA

**18/09/2026** · domanda di Claudio: *«I miei colleghi dicevano che il Nasdaq apre long o short,
poi fa una candela dell'altro colore e poi riparte del colore che ha aperto, e fa di solito 50
punti e poi si gira. E che all'inizio si mettono due ordini pendenti a 7 pip o punti di distanza.
CONFERMI?»*

> ## 🎯 **VERDETTO IN UNA RIGA: due pezzi su quattro li confermo alla lettera, uno c'è ma È SPENTO sul Nasdaq (ed è quello che ha salvato il DAX), e uno nell'EA non esiste.**

---

## ✅ ① I DUE ORDINI PENDENTI — **confermato, è il cuore del motore**

`ABTG_Nasdaq_Apertura_US.mq5`, intestazione del motore condiviso, **rr.65-67**:

> *«2) **BREAKOUT con ordini pendenti: BUY STOP sopra il massimo, SELL STOP sotto il minimo**
> (buffer configurabile) · 3) **OCO: quando uno parte, l'altro viene cancellato**»*

Implementato davvero: `HandleOCO()` chiamata a **r.631**, definita a **r.2094** —
*«OCO: se una posizione dell'EA è aperta, cancella i pendenti»*.

**I livelli**: `InpRangeMode=2` = massimi/minimi della **candela precedente**, su
`InpLevelTF=PERIOD_H1`, finestra `InpRangeMinutes=15` dopo l'apertura
(`InpSessionHour=14`, cioè **15:30 italiane** — fuso BCM).

---

## 🟠 ② I «7 PUNTI» — **il numero è di casa, ma sono due cose diverse. E il 7 non gira.**

### (a) Non è la distanza FRA i due ordini
`InpBufferPoints` è il **buffer OLTRE ciascun livello**, non la distanza fra i due pendenti.
La distanza fra BUY STOP e SELL STOP è **l'ampiezza del range + 2 × buffer**.
👉 Se i colleghi intendono *«i due ordini distano 7 punti l'uno dall'altro»*, **quella non è
questa strategia**: un range da 7 punti sul Nasdaq è minuscolo (il filtro di casa vuole il range
fra **17 e 40** punti indice, `InpMinRangePts=1700` / `InpMaxRangePts=4000`).

### (b) 🔴 E il «7» sta in un COMMENTO che non corrisponde a niente che giri

| dove | valore | = punti indice |
|---|---:|---:|
| commento `ABTG_ApertureCore.mqh` r.127 e Nasdaq r.213 — *«live: **700** = 7 punti indice»* | 700 | **7** |
| **default compilato** del Nasdaq (r.134; il file **non** sovrascrive `ABTG_DEF_BUFFER`) | 200 | **2** |
| `mql5/Presets/ABTG_Nasdaq_Apertura_US.set` | 300 | **3** |
| `backtest_pipeline/allinea_nasdaq_volumi.ps1` (**scrive il preset vivo**, 80 parametri) | **200** | **2** |

> ## 🔴 **Il commento dice 7. La macchina ne mette 2. E il commento è nel motore CONDIVISO, quindi lo legge chiunque apra il file.** È la stessa forma del bug C4 sul DAX: chi apre il sorgente trova un numero, chi guarda il preset ne trova un altro.

🟢 *Sul DAX invece torna*: lì `ABTG_DEF_BUFFER = 500` e il commento dice *«500 = 5 punti indice»*.

---

## 🔴 ③ «CANDELA DELL'ALTRO COLORE, POI RIPARTE» — **il meccanismo c'è, ma sul Nasdaq è SPENTO**

Nell'EA ci sono **sei** modalità d'ingresso (`ENUM_ABTG_ENTRY`, rr.149-157). Due somigliano a
quello che descrivono i colleghi:

| modo | cosa fa | etichetta nel sorgente |
|---|---|---|
| `ABTG_RETEST` (2) | rottura **+ ritorno sul livello** con LIMIT | *«**leva Emiliano**: niente slippage»* |
| `ABTG_OPENCONFIRM` (5) | la candela deve **APRIRE già oltre** il livello, poi si entra | *«**regola delle live**»* |

### 🔴 Ma il Nasdaq in campo gira `InpEntryMode = 0` = **BREAKOUT puro**
Verificato in tutti e due i posti: `mql5/Presets/ABTG_Nasdaq_Apertura_US.set` e
`allinea_nasdaq_volumi.ps1`. **Entra alla rottura e basta: non aspetta nessun ritorno.**

> ## 🟢 **E QUI C'È LA COSA CHE VALE DAVVERO, perché sul DAX quel pezzo È ACCESO e ha cambiato il segno della sedia.** `770101` gira in **RETEST**, e il cambio del **7 agosto** l'ha portata da **−168 a +149 €**. Il sorgente lo documenta a `ABTG_DAX_Apertura_EU.mq5` r.261: *«06/08: era BREAKOUT. Unico motore in utile fuori campione con campione vero (+392,96 · PF 1,065 · 244 trade)»*.

👉 **Quindi la memoria dei colleghi non descrive il nostro Nasdaq: descrive il nostro DAX.**
E la domanda che ne esce è buona: **il RETEST sul Nasdaq non è mai stato provato** —
`InpRetestOffsetPts` è a `0` e il modo non è mai stato acceso su quel simbolo.
⚠️ Va messo in coda all'imbuto **come misura**, non acceso: `770201` è spenta dal 18/08 con
PF 0,82 · DD 17% · 19/20 celle OOS negative, e il RETEST è una manopola in più, non un'assoluzione.

---

## ❌ ④ «50 PUNTI E POI SI GIRA» — **nell'EA non esiste. Ma esiste altrove, e su un altro mercato.**

### Nell'EA il primo obiettivo è **1R**, non 50 punti
`InpTP1_R = 1.0` (r.264) · `InpTP1_ClosePct = 50` (r.265, *«% di posizione chiusa al 1° obiettivo
— piano: "dimezzo"»*) → poi **stop in pari** e **trailing** (`InpTrailMode=1`, base candela M1).

🔴 **Attenzione al numero 50: nel file compare due volte e nessuna delle due è un target.**
- `InpTP1_ClosePct = 50` → è una **percentuale di volume**, non punti.
- `InpRoundMinDistPts = 50` → è la **distanza minima per validare un numero tondo**, e nel
  preset vivo vale **50**, in quello in repo **300**.

### 📌 Ma i «50 punti» sono veri — nelle live, **sul DAX**, e come regola del pollice
Nelle trascrizioni in repo compaiono di continuo, sempre con lo stesso senso (quanto fa il
mercato in una giornata / quando parzializzare):
- Emiliano, **14/09** r.195: *«Quanti punti abbiamo fatto? **50 punti al giorno**.»*
- Emiliano, **18/09** r.147: *«i prezzi hanno fatto **quasi 50 punti**»* — e a r.133: *«siamo
  posizionati a distanza di **20 punti**, metterlo a 40-50 punti non ha senso, è troppo distante»*
- Paolo, 28/04 r.393: *«parzializzo dopo un po', dopo **40-50 punti**»*

👉 **È una regola del pollice sul DAX per la parzializzazione e per il movimento tipico di
giornata — non una legge del Nasdaq, e non un "si gira dopo 50 punti".**
🔴 E il Nasdaq non è il DAX: 50 punti indice su NASUSD a ~24.000 sono un altro mestiere.
**Trasferire un numero da un mercato all'altro senza rimisurarlo è esattamente il difetto che
paghiamo di più.**

---

## 📊 RIEPILOGO

| pezzo della strategia | c'è nell'EA? | è ACCESO sul Nasdaq? |
|---|---|---|
| due pendenti, uno per lato, con OCO | ✅ **sì**, è il cuore | ✅ **sì** |
| buffer oltre il livello | ✅ sì | 🟠 sì, **ma a 2 punti, non 7** |
| ritorno/candela contraria prima di entrare | ✅ sì (`RETEST` / `OPENCONFIRM`) | 🔴 **NO** — gira BREAKOUT puro |
| target a 50 punti e inversione | ❌ **no**, il target è **1R** | — |

## 📌 In una riga
**La memoria di Claudio è buona: i due pendenti e il numero 7 stanno davvero nei nostri file.**
Ma il 7 è un commento che nessuna macchina rispetta (gira a **2**), il «ritorno prima di entrare»
sul Nasdaq **è spento** — mentre sul DAX è acceso ed è **la modifica che ha girato quella sedia** —
e i 50 punti vengono dalle **live sul DAX**, non dal Nasdaq.
🎯 **La cosa da fare non è confermare o smentire: è provare il RETEST sul Nasdaq, che non è mai
stato misurato.**

---
*Fonti, per riga: `mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5` rr.9, 65-67, 134, 149-157, 213,
221-222, 224-226, 264-265, 287, 631, 2094 · `mql5/Include/ABTG/ABTG_ApertureCore.mqh` rr.68, 127 ·
`mql5/Experts/ABTG_DAX_Apertura_EU.mq5` rr.89, 261, 265 · `mql5/Presets/ABTG_Nasdaq_Apertura_US.set` ·
`backtest_pipeline/allinea_nasdaq_volumi.ps1` · `docs/live_emiliano/trascrizioni/` (14/09 r.195,
18/09 rr.133 e 147) · `docs/live_paolo/PAOLO LIVE 28.04.26…txt` r.393 ·
`report/CONTRATTI_SEDIE.md` r.54 per lo stato di `770201`.*
