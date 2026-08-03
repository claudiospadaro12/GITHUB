# 🎯 SCHEDA ORB — strategia a sé, non un motore delle aperture

> **Chiarimento 03/08 (Claudio):** l'ORB **non è** una variante d'ingresso dell'EA apertura. È una **terza strategia**, con un suo EA (`ABTG_ORB`, più `ABTG_ORB_Fibo` e `ABTG_Londra_ORB`). Emiliano nelle live: *"l'ORB è **un'altra strategia** che noi abbiamo"*. Era archiviata per errore dentro `CACCIA_MOTORE_APERTURE.md`.

## Le tre strategie ABTG sulla stessa sessione
| Strategia | Livelli | Ingresso |
|---|---|---|
| Apertura Nasdaq | candela H1 prec. / max-min 15 min pre-apertura | ordini STOP, gestione attiva |
| Apertura Europea (DAX) | D1/W1/M (Larry Williams) | pendenti + Supertrend ×3 |
| **ORB** | **primi 30 min DOPO l'apertura** | **chiusura candela**, stop fisso |

---

## 📊 DOVE SIAMO DAVVERO CON L'ORB (non è "morto")
| Fonte | Numero | Lettura |
|---|---|---|
| Backtest tick reali (`REGISTRO_TEST` O1) | **625 trade**, 50% pass positivi, best PF **1,15**, DD 16% | 🟡 **marginale**, non morto — ed è l'unico con campione PIENO (100% dei giorni) |
| Forward (pagella 01/08) | **+328,93 €** su 7 trade, 71% vinti | il migliore sul Nasdaq, ma 7 trade non sono un dato |
| `ABTG_ORB_Fibo` | OHLC 29% pass positivi | 🔴 morto |
| `ABTG_Londra_ORB` | OHLC 11% pass, DD 23% | 🔴 morto |

**Quindi:** morti sono ORB_Fibo e Londra_ORB. `ABTG_ORB` è **marginale con 625 operazioni** — la base migliore che abbiamo per aggiungerci le conferme.

## 🔑 La ricetta era già scritta nel nostro registro — e mai implementata
`REGISTRO_TEST.md` riga 140, estratta dalle live **prima** che arrivasse il ToolKit:
> *"ORB: si entra alla rottura del max/min **SOLO se**: (1) la candela **chiude col corpo fuori dal range** (non solo spike), (2) **volumi ≥ 1,5× la media(20)**, (3) **medie 9/21 inclinate** nella direzione."*

Sono **esattamente** le tre conferme del ToolKit. Erano a registro da giorni e nessuna era nel codice.

---

## 🔍 VERIFICHE 03/08 sui file ORB (richieste da Claudio)

### Esistono TRE specifiche ORB diverse, non una
| Fonte | Range | Ingresso | Stop | Target |
|---|---|---|---|---|
| **ToolKit Vol. V** (base) | 30 min **dopo** l'apertura | alla **CHIUSURA** della candela oltre il range | bordo opposto range, 5–10 pt · **mai spostato** | RR 1:1,5 → 1:2 fisso |
| **Webinar 02.03.2026** (avanzata, Emiliano Monza) | 30 min **dopo** l'apertura | ⭐ **ritracciamento in GOLDEN ZONE 50–61,8% di Fibonacci**, con **ordine LIMITE** | sotto il **78,6%** Fib o swing | TP1 = **0% Fib**, poi trailing su EMA |
| **Il nostro `ABTG_ORB`** | **5 min PRIMA** dell'apertura (15:25–15:30) | ordini STOP pendenti | bordo opposto | TP 2R + parziale + BE + trailing |

⚠️ **Il range del nostro `ABTG_ORB` non corrisponde a NESSUNA delle fonti ABTG.** Non è 30 min post-apertura (ToolKit e webinar) né 15 min pre (piano Nasdaq): è una finestra di 5 minuti pre-apertura che non è scritta da nessuna parte.

### Il webinar ribalta il punto centrale del ToolKit
Testuale: *"Il breakout è il segnale. **Il ritracciamento è l'entrata**."* e *"**Limit Orders Only.** Gli ordini a mercato all'apertura espongono a slippage che distrugge il R:R."*

È **la stessa diagnosi che avevano dato i nostri numeri** sullo slippage degli ordini stop. Ma attenzione:

> 🚨 **Il nostro RETEST bocciato (0,73–0,94) NON era questo.** Il nostro metteva il limit sul **bordo del range rotto**; il webinar lo mette nella **Golden Zone del movimento post-breakout** (Fibonacci tracciato dal session low al massimo raggiunto **dopo** la rottura). Sono due prezzi completamente diversi. **Quella bocciatura non si applica alla strategia del webinar.**

### ✅ E la strategia del webinar è GIÀ IMPLEMENTATA da noi
`ABTG_ORB_Fibo.mq5` la riproduce fedelmente: OR 30 min post-apertura (14:30 server +30), candela M5 che chiude fuori dal range, volume ≥1,5× media(20), corpo ≥50% del range, **Golden Zone 50–61,8%**, **SL al 78,6%**, TP1 allo 0%, filtro EMA 9/21, un trade a sessione.

⚠️ **Contraddizione nel nostro registro, da risolvere:**
- `REGISTRO_TEST` riga 49: *"ORB_Fibo · OHLC 29% pos · 🔴 morto"* → bocciato **solo in OHLC**
- `REGISTRO_TEST` riga 40: *"provati e morti in **real-tick**: … ORB_Fibo …"* → bocciato **a tick reali**

Le due righe dicono cose diverse e non c'è alcun CSV archiviato in `risultati_archivio/ORB/` per verificare. **Va rifatto un run pulito.**
_Nota di onestà: se il 29% fosse davvero solo OHLC, è comunque un segnale negativo forte — l'OHLC **sovrastima**, e per gli ordini limite lo fa ancora di più (assume il fill al tocco). Un ORB_Fibo che fallisce in OHLC difficilmente rinasce a tick reali. Ma il run va fatto lo stesso: è l'unica implementazione fedele della strategia avanzata e non possiamo tenerci un verdetto contraddittorio._

### Gli altri due file
- **`ABTG_ToolKit_05_ORB_Apertura_America_1.pdf`** — è lo **stesso documento** del primo: 20 blocchi di testo su 21 identici, cambia solo la copertina (il primo riporta "Volume V" e la data 15.02.2026). Nessuna informazione nuova.
- **`ORB_Indicator_V15.ex5`** — binario MetaTrader compilato, **senza stringhe leggibili**: non posso ricavarne i parametri da qui. 👉 Per averli: caricalo su un grafico in MT5 e premi **F7** — la finestra mostra tutti gli input. Mandami quello screenshot e verifico se il nostro range 15:25–15:30 viene da lì.
- **`PROMPT_DI_INTELLIGENZA_PRECISA.docx`** — prompt generico di metodo (accuratezza, etichette [VERIFICATO]/[INFERITO]/[INCERTO], anti-allucinazione). Non contiene nulla di operativo sull'ORB. È già di fatto lo stile richiesto in `HANDOFF.md`.

### Un dato nuovo sul DAX
Il webinar dà l'ORB anche per il DAX: **OR 09:00–09:30 CET = 30 minuti**. Il nostro EA apertura DAX usa **15 minuti**. Un'altra finestra mai testata.

---

## Il ToolKit (ABTG Vol. V) — la specifica completa

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

**✅ FATTO 03/08 in `ABTG_ORB.mq5`** (tutto opt-in, default = comportamento attuale):
- `InpUseCloseConfirm` — entra alla **chiusura** di una candela oltre il livello invece che con pendenti STOP (nuova fase `ORB_ARMED` + `TryCloseConfirmEntry`)
- `InpMinBodyPct` — corpo minimo della candela di rottura in % del suo range
- `InpUseEmaFilter` — EMA veloce/lenta allineate **E prezzo dalla parte giusta di entrambe** (`EmaSideOK`)
- `InpUseVolumeFilter` + `InpVolMult`/`InpVolAvgBars` — volume **della candela di rottura** ≥ 1,5× media(20)
- il range 30 min post-apertura non ha richiesto codice: bastano `InpRangeStart/End` (14:30→15:00 server)
- stop fisso + TP 1:2: `InpBreakeven=0`, `InpUseTrailEMA=0`, `InpTP1Pct=0`, `InpTP_R=2`

**▶️ IL TEST**
```powershell
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/test_orb_toolkit.ps1" | iex
```
Scala a 6 gradini su NASUSD + U30USD + **SPXUSD** (il mercato su cui il ToolKit è tarato), ognuno cambia **una** variabile:
**A** attuale (range 5 min pre) → **B** range 30 min post → **C** + chiusura confermata → **D** + corpo → **E** + medie 9/21 → **F** + volumi.
A→B isola l'effetto del **range**, B→C quello dell'**ingresso**, C→F il peso di ogni **filtro**.

_(riferimento storico delle due aggiunte richieste)_
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
