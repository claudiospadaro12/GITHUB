# 🎯 ORB Apertura America (ABTG ToolKit Vol. V) — la specifica completa vs il nostro EA

_03/08/2026. Fonte: `ToolKit_05_ORB_Apertura_America.pdf` (44 pp., Realise 15.02.2026)._

## Perché questo documento conta più degli altri
È l'unico materiale ABTG che dà una **specifica chiusa e senza ambiguità**: range, filtro, ingresso, stop, target, rischio, casi di rigetto. Nessuna interpretazione richiesta.
**E su quattro punti chiave prescrive l'opposto di quello che abbiamo testato per due giorni.**

---

## La specifica

| Elemento | Regola del ToolKit |
|---|---|
| **Range** | primi **30 minuti** dall'apertura US (15:30–16:00 IT = **14:30–15:00 server**), letti su **M5**, **ombre incluse** |
| **Filtro direzionale** | **EMA 9 e EMA 21 su M5**. Long: EMA9>EMA21 **e prezzo sopra entrambe**. Short: EMA9<EMA21 **e prezzo sotto entrambe**. Medie intrecciate o prezzo in mezzo → **nessuna operazione** |
| **Ingresso** | una candela **M5 CHIUDE** oltre il livello (*"non basta che il prezzo tocchi"*) **con corpo ampio**. Si entra **alla chiusura di quella candela** |
| **Stop loss** | **bordo opposto del range**, 5–10 punti oltre. **Si imposta UNA volta e non si tocca più** |
| **Take profit** | RR minimo **1:1,5**, ideale **1:2**. In alternativa: EMA 21 come trailing naturale |
| **Rischio** | **1–2%** del capitale per operazione |
| **News** | notizie rosse nelle **prossime 2 ore** → non si opera |
| **Casi di rigetto** | medie neutre · candela con corpo piccolo/ombra lunga · chiusura rientrata nel range → **si sta fuori** |

Il ToolKit è esplicito anche sul timeframe del range:

| Range | Affidabilità | Giudizio del documento |
|---|---|---|
| 5 minuti | bassa | **sconsigliato** |
| 15 minuti | media | trader con esperienza |
| **30 minuti** | **alta** | ⭐ **"CONSIGLIATO — la nostra scelta"** |

---

## 🚨 I quattro scarti — dove abbiamo testato l'opposto

| # | Il ToolKit dice | Noi abbiamo testato | Gravità |
|---|---|---|---|
| **1** | Range **30 minuti** | 15 minuti, oppure candela **H1 precedente** | 🔴 il documento definisce il range da 5 min *"sconsigliato"* e noi siamo andati anche più in là |
| **2** | Ingresso alla **CHIUSURA** della candela oltre il livello | ordini **STOP riempiti durante** la rottura | 🔴 è l'**errore comune #1** del documento, testuale |
| **3** | Filtro **EMA 9/21 su M5** + prezzo dalla parte giusta | EMA **1 vs 50 su H4** | 🔴 timeframe e periodi diversi; e la condizione *"prezzo sopra entrambe"* **non esiste** nel nostro codice |
| **4** | Stop fisso, **mai spostato**. TP fisso 1:2 | parziale 50% + **break-even** + **trailing** | 🔴 è l'**errore comune #3** del documento: *"Lo stop loss si imposta UNA volta e non si tocca più"* |

**Il nostro "ingresso ritardato" (bocciato a 0,66) somigliava al punto 2 ma non lo era**: entrava a un orario fisso (15/30/45 minuti), non *quando una candela chiude oltre il livello*. E girava senza il filtro EMA 9/21 e con il range sbagliato. Quindi **non è una bocciatura di questa strategia**.

---

## Cosa serve per testarla davvero

**Già configurabile (nessun codice):**
- Range 30 min → `InpRangeMinutes=30`, `InpRangeMode=OPENING`
- EMA 9/21 su M5 → `InpUseEmaFilter=1`, `InpEmaFast=9`, `InpEmaSlow=21`, `InpFilterTF=M5`
- Stop sul bordo opposto → `InpSLMode=SL_RANGE`
- Nessun BE, nessun trailing, nessun parziale → `InpBreakevenAtTP1=0`, `InpUseTrailing=0`, `InpTP1_ClosePct=0`
- TP 1:2 → `InpTP1_R=2`
- News 2 ore prima → `InpUseNewsFilter=1`, `InpNewsBeforeMin=120`
- Rischio 2% → `InpRiskPercent=2`

**Da scrivere (due aggiunte):**
1. **Ingresso su CHIUSURA confermata**: sorvegliare le candele M5 dopo la fine del range e entrare a mercato quando **una candela chiude** oltre il livello (con filtro sul **corpo minimo**). È un motore nuovo — il `DELAYED` attuale decide a un orario fisso, non su un evento.
2. **Condizione "prezzo dalla parte giusta di entrambe le medie"**: oggi `TrendBias()` confronta solo veloce vs lenta. Va aggiunta la posizione del prezzo rispetto a entrambe, e il caso **neutro** (medie intrecciate → nessun trade).

---

## Perché vale la pena

Questa configurazione spiega in un colpo solo diverse nostre bocciature:
- entravamo **durante** la rottura (slippage sui falsi break) invece che sulla chiusura;
- filtravamo il trend sul TF sbagliato;
- spostavamo lo stop, tagliando i trade che sarebbero corsi fino a 1:2.

E c'è un indizio che punta nella stessa direzione dell'unica cosa che ha funzionato finora: il **filtro volumi** ha mostrato che l'informazione all'apertura del Nasdaq esiste ma va **selezionata**. Il ToolKit seleziona in modo diverso (chiusura confermata + medie allineate + corpo ampio) e per la stessa ragione: **evitare i falsi break**.

> ⚠️ Il ToolKit è tarato sull'**S&P 500** ("uno dei mercati più liquidi"). Sul Nasdaq va verificato, non dato per scontato.
