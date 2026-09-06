# 📘 ANALISI DEL MANUALE ESTERNO «ALTA VELOCITÀ» (Manuela Negro) — estrazione disciplinata e confronto col corpus di casa

**Data: 06/09/2026** · dossier dell'**analista di documenti**
**Fonte esaminata:** `ALTA_V_1.pdf` — *«ALTA VELOCITÀ — La strategia di Manuela
Negro spiegata passo per passo»*, **38 pagine, lette tutte** (3 blocchi:
1-13, 14-26, 27-38).
**Natura dichiarata dal documento stesso** (p.1 e p.38): *«Documento di studio
personale ricavato dalle registrazioni del percorso di 12 lezioni. Non è
materiale ufficiale né materiale da distribuire. Non è consulenza
finanziaria.»* → **materiale di TERZI, di secondo passaggio** (appunti su
registrazioni, non testo dell'autrice).

> 🛑 **Questo dossier non tocca niente.** Nessun EA, nessun preset, nessun
> parametro di forward, nessun conto, nessuna riga di lancio. Porta
> un'**estrazione**, un **confronto** e delle **proposte dichiarate e NON
> applicate**. Decide Claudio.

---

## 0. 🥇 LE DUE RIGHE CHE RESTANO

> **1️⃣ Questo manuale NON è materiale nuovo: è la fonte di un capitolo che
> abbiamo già aperto, codificato, misurato e CHIUSO l'11/08/2026.**
> `backtest_pipeline/prove/ALTA_VELOCITA_TESI.md` cita testualmente
> *«manuale 38 pp. + 84 slide caricati da Claudio l'11/08/2026»*. Da lì sono
> nati `mql5/Experts/ABTG_AltaVelocita.mq5` (1.422 righe, v2) e il verdetto
> `REFERTO_ALTA_VELOCITA_V1.md`: **v1, v1.1 e v2 tutte rosse, in campione e
> fuori campione, in OHLC e a TICK REALI**, su due combo dichiarate prima dei
> numeri. Capitolo chiuso con **patto di chiusura scritto**.
>
> **2️⃣ Rileggendo il PDF pagina per pagina, la nostra distillazione dell'11/08
> regge: nessun parametro del manuale è stato tradotto male, nessun numero è
> stato inventato.** Ho trovato **7 incoerenze interne al documento** (una
> arriva a mettere lo stop dal lato sbagliato del massimo di ciclo, p.25) e
> **4 bandiere che vanno agli atti** — ma **zero parametri nuovi**.
>
> 🔴 **L'Appendice D NON contiene codice né formule.** Descrive un indicatore
> `AltaVelocita.mq5/.mq4` allegato al corso (che noi **non abbiamo**) e
> ammette in chiaro che *«la formula esatta dell'indicatore ciclico usato nel
> percorso non viene spiegata nelle lezioni»* (p.37). 👉 **La nostra
> implementazione è più fedele dell'indicatore ufficiale del corso**: noi la
> formula originale ce l'abbiamo, arrivata da **3 fonti indipendenti**
> l'11/08.

---

## 1. 📜 CHE RANGO HA QUESTA FONTE (dichiarato prima dei numeri)

| | |
|---|---|
| **Rango** | **4° — DICHIARAZIONE SINGOLA, per giunta di SECONDO PASSAGGIO.** Un solo metodo, una sola autrice, e il testo non è nemmeno suo: sono appunti di un allievo sulle registrazioni |
| **Cosa NON contiene** | ❌ nessun backtest · ❌ nessun profit factor · ❌ nessun drawdown misurato · ❌ nessun forward · ❌ nessun trade reale · ❌ nessun CSV, `.htm`, `.set` o screenshot di conto |
| **Cosa contiene invece** | **parametri tecnici precisi e regole di gestione** — è un manuale **didattico e DISCREZIONALE**, e va giudicato come tale. I grafici sono dichiarati **ricostruzioni didattiche** (p.2: *«sono costruiti apposta perché la sequenza si veda con chiarezza, cosa che sul mercato vero capita raramente in modo così pulito»*) |
| **Regola di casa applicata** | Non forzo un confronto su PF/DD **che il documento non ha**. I pochi numeri di performance che compaiono sono **claim di marketing del percorso**, e li tratto come tali (§5) |
| **Onestà del documento** | 🟢 **alta, e va riconosciuta**: dichiara i grafici come ricostruzioni, dichiara che l'indicatore *«non decide per te»* (p.38), dichiara che la formula del ciclo non è spiegata (p.37), dichiara di non essere consulenza |

---

## 2. 🔢 ESTRAZIONE DISCIPLINATA — I PARAMETRI CON VALORE

**Regola d'estrazione**: ogni riga porta il **valore esatto** e la **pagina**.
Etichette: **[DICHIARATO]** = c'è scritto il numero · **[NON DICHIARATO]** =
il manuale nomina lo strumento ma non i suoi parametri · **[INFERITO]** = lo
deduco da più passaggi, e dico quali.

### 2.1 I quattro indicatori

| # | parametro | valore | pagina | etichetta |
|---|---|---|---|---|
| **P1** | **Williams %R — periodo** | **140** | p.3 (indice), **p.9** (tabella «Setup»), p.11 (§3.3), p.36 (glossario) | ✅ **[DICHIARATO]**, ripetuto **4 volte** nel documento |
| **P2** | **RSI — periodo** | **4** | p.3, **p.9**, p.12 (§3.4), p.13 | ✅ **[DICHIARATO]**, ripetuto 4 volte |
| **P3** | **Williams — soglia ipercomprato** | **«vicino a 0»** (zona rossa nel grafico p.11, senza numero) | p.11-12 | ⚠️ **[NON DICHIARATO come numero]** — il grafico p.11 disegna la banda ma **non scrive la soglia**. Il nostro EA usa **−20** come ipotesi |
| **P4** | **Williams — soglia ipervenduto** | **«vicino a −100»** | p.12 | ⚠️ **[NON DICHIARATO come numero]** — EA: **−80** (ipotesi) |
| **P5** | 🥇 **Williams — il limite oltre il quale il segnale NON si prende** | **−50** | **p.12** (§«Il limite del −50»), p.17 (punto 7), p.24 (*«circa −23, sopra il −50»*), p.32 (errore n.3), p.34 (checklist) | ✅ **[DICHIARATO]** — **è il numero più ripetuto del manuale dopo il 140**: 5 occorrenze |
| **P6** | **Supertrend — periodo ATR e moltiplicatore** | ⛔ **NIENTE.** p.9 scrive letteralmente **«standard»** nella colonna «Setup» | p.9, p.10 | 🔴 **[NON DICHIARATO]** — **confermata la lacuna registrata l'11/08**. Il documento parla di Supertrend in 14 pagine e **non dà mai un parametro**. Il nostro EA li tiene come **ipotesi sweepabili** (`InpStAtrPeriod=10`, `InpStMult=3.0`) proprio per questo |
| **P7** | **ATR del target — periodo** | ⛔ **NIENTE.** p.14 dice solo *«l'ATR misura quanto si muove mediamente lo strumento su un certo time frame»* | p.14, p.36 | 🔴 **[NON DICHIARATO]** — EA: `InpAtrPeriod=14` **dichiarato come ipotesi** |
| **P8** | **Oscillatore ciclico — formula** | ⛔ **NIENTE**, e il documento **lo ammette**: *«la formula esatta dell'indicatore ciclico usato nel percorso non viene spiegata nelle lezioni»* | **p.37 (App. D)** | 🔴 **[NON DICHIARATO — ammesso dalla fonte]** 🥇 **e noi ce l'abbiamo lo stesso**: vedi §7 |
| **P9** | **Media mobile dell'uscita anticipata** | **9 periodi** | **p.23** (*«quando il prezzo comincia a lavorare sotto la media a 9 periodi del grafico di gestione»*) | ✅ **[DICHIARATO]** — unico parametro di gestione con un numero |

### 2.2 Scala, cicli e geometria

| # | parametro | valore | pagina | etichetta |
|---|---|---|---|---|
| **P10** | **La scala dei time frame ammessi** | **100 tick · M1 · M5 · M15 · H1 · H4 · Daily · Weekly · Mensile · Trimestrale** — e **solo questi**: *«non esistono i 30 minuti, non esistono i 2 minuti… gli indicatori sono stati tarati su questa scala»* | **p.6** | ✅ **[DICHIARATO]** con la motivazione |
| **P11** | 🥇 **Durata di un ciclo** | **6 barre del suo time frame** | **p.6** | ✅ **[DICHIARATO]** — è la costante che genera tutta la tabella delle durate |
| **P12** | Durate derivate | M5 30' · M15 1h30' · H1 6h · H4 24h · Daily 6 giorni · Weekly 6 settimane · Mensile 6 mesi · Trimestrale 18 mesi | p.6-7, p.35 | ✅ **[DICHIARATO]**, coerente con P11 |
| **P13** | 🥇 **La regola madre** | **Williams e Supertrend 2 TF SOTTO il ciclo direzionale · RSI 1 TF SOTTO · Ciclo e ATR SUL direzionale** | **p.7** | ✅ **[DICHIARATO]** (schema a colori) |
| **P14** | 🥇 **La stessa regola letta dal grafico d'ingresso** | **Williams di contesto = 1 gradino sopra l'ingresso · RSI di contesto = 2 gradini sopra · ATR del target = 3 gradini sopra** | **p.8**, confermata da **p.35 (App. B)** riga per riga | ✅ **[DICHIARATO]** — 👉 **è la lettura che il nostro EA implementa** |
| **P15** | Combo operative complete | H4→M5 · Daily→M15 · H1→M1 · M15→100tick (+ Weekly→H1, Mensile→H4) | **p.19**, **p.35** | ✅ **[DICHIARATO]** |
| **P16** | 🥇 **Il target** | **2 × ATR del ciclo direzionale**, misurati **DAL massimo (o minimo) DI CICLO**, non dal prezzo d'ingresso | **p.14** (§3.5), p.11, p.23, p.34, p.35 | ✅ **[DICHIARATO]** — ripetuto 5 volte, ed è **l'errore n.5 della lista dei 10** (p.32) se lo si misura dall'ingresso |
| **P17** | **«Massimo di ciclo»** | **il prezzo più alto raggiunto dentro il ciclo** — **NON** la punta dell'indicatore ciclico | p.11, p.36 | ✅ **[DICHIARATO]**, con avvertenza in riquadro rosso |
| **P18** | Ritardo dell'indicatore ciclico | **circa 1 ATR** dopo il massimo/minimo (su ciclo mensile: *«la conferma arrivava tre mesi dopo, quando il movimento aveva già fatto 650 pip dei 700 previsti»*) | **p.11** | ✅ **[DICHIARATO]** — è il motivo per cui il ciclo **non si usa per entrare** |
| **P19** | Durata di ogni fase della sequenza | **almeno 2 cicli del grafico operativo per fase** → su M15: *«tre ore per la rottura, tre per il ritest, tre per la ripartenza. Circa nove ore»* | **p.16** | ✅ **[DICHIARATO]** |
| **P20** | Quota di cicli M15 controtendenza | **circa 80%** — *«è lì che si prendono gli schiaffi»*, e **non si prendono** | **p.18**, ripetuto p.32 (errore n.7), p.33 | ✅ **[DICHIARATO]** — 🔴 **numero senza fonte né misura**, è un'affermazione del percorso |
| **P21** | R/R massimo per gradino di discesa | 1 gradino **1:3** · 2 **1:6** · 3 **1:12** · 4 **1:24** · 5-6 **1:48 e oltre** | **p.19-20** | ⚠️ **[DICHIARATO ma incoerente]** — vedi incoerenza **X3** |

### 2.3 Stop, rischio, «patente»

| # | parametro | valore | pagina | etichetta |
|---|---|---|---|---|
| **P22** | 🥇 **Stop iniziale** | **1 pip oltre il massimo** (sell) **o il minimo** (buy) **della fase di inversione** | **p.21**, p.26, p.34 | ✅ **[DICHIARATO]** |
| **P23** | 🥇 **Filtro R/R — il cancello d'ingresso** | **se non arriva a 1:3 si avvicina lo stop alla cuspide del Supertrend più vicina; se nemmeno così arriva a 1:3, IL SEGNALE NON SI PRENDE** | **p.21**, p.34 (checklist: *«Rapporto verificato >= 1:3»*), p.37 (l'indicatore lo marca da scartare) | ✅ **[DICHIARATO]** — **è la regola più netta del manuale** |
| **P24** | **Dimensionamento sano dello stop** | riferimento = **ATR del M5**: *«se l'ATR M5 è 5 pip, uno stop di 5-6 pip è giusto. Uno stop di 1 pip e mezzo non è coraggio, è rumore… uno stop di 20 pip significa che sei entrato sul grafico sbagliato»* | **p.21** | ✅ **[DICHIARATO]** → **[INFERITO]** la banda implicita è **≈ 0,3 – 4,0 × ATR operativo**. Il nostro EA v1.1 usa **0,8 – 4,0**: **il tetto è quello del manuale, il pavimento è più severo** (scelta nostra, dichiarata) |
| **P25** | **Rischio per operazione** | **2%** se target fisso a 3% con operazioni brevi chiuse in giornata · **1%** se si lascia correre il trend | **p.29**, p.33 (checklist: *«1-2% di rischio»*) | ✅ **[DICHIARATO]** |
| **P26** | 🥇 **I tre numeri della «patente»** | **Drawdown reale ≤ 3%** · **Deviazione standard ≤ 2%** · **Drawdown prospettico ≤ 7%** | **p.28** (grafico + tabella) | ✅ **[DICHIARATO]** — *«prima che quei numeri escano, non si va in reale»* |
| **P27** | Gli altri due obiettivi del report | **Affidabilità ≥ 80%** · **Media del rapporto ≥ 3** | **p.28** | ⚠️ **[DICHIARATO ma TESTO SOVRAPPOSTO nel PDF]**: la grafica accavalla le due caselle. Il valore 80% e il valore 3 si leggono, la loro attribuzione va **ricontrollata sull'originale** |
| **P28** | **Tetto di drawdown prospettico complessivo** | **≤ 20%** su tutte le strategie insieme (*«trenta è già esagerato»*) | **p.29** | 🔴 **[DICHIARATO ma INCOERENTE]** — vedi incoerenza **X5** |
| **P29** | Cadenza di revisione del report | **ogni 20-30 operazioni** si ricontrolla e si reinserisce l'ultimo blocco | **p.28** | ✅ **[DICHIARATO]** |
| **P30** | Frequenza-obiettivo | **210 operazioni chiuse** con **rapporto medio 3** (media, non massimo) | **p.4** | ✅ **[DICHIARATO]** |

### 2.4 Orari — ⏰ **il fuso NON è dichiarato: NON si convertono**

| fascia (come scritta) | cosa si muove | p. |
|---|---|---|
| **07:00 – 09:00** | cross con lo **yen** | p.30 |
| **08:00 – 12:00** | cross **europei** (euro, sterlina, franco) | p.30 |
| **12:00 – 18:00** | europei **+ americani** — *«la più volatile, quella che paga di più. Anche la più difficile»* | p.30 |
| **dopo le 18:00** | solo **americani** | p.30 |

> 🔴 **REGOLA DI CASA APPLICATA (`CLAUDE.md`, fuso BCM):** *«gli orari citati
> sono quasi sempre in un ALTRO fuso: convertili SOLO se il fuso è dichiarato,
> altrimenti [INCERTO] — un orario col fuso sbagliato è peggio di nessun
> orario»*. **Il manuale non dichiara MAI il fuso** in nessuna delle 38 pagine.
> 👉 Questi quattro orari sono **[INCERTO]** e **non entrano in nessun preset**.
> Se fossero ora italiana, in ora server BCM sarebbero 06:00-08:00 /
> 07:00-11:00 / 11:00-17:00 / dopo le 17:00 — **ma questa è un'ipotesi non
> verificabile dal documento, e come tale resta fuori.**

---

## 3. ⚙️ I MECCANISMI, come descritti

### 3.1 L'ingresso: ROTTURA → RITEST → CONTROLLO → RIPARTENZA (p.15-17)

Motivazione dichiarata (p.15): *«farti entrare quando la fase laterale sta
finendo, non quando comincia»*. Esempio SELL (il BUY è specchiato, tabella
completa a p.26):

| fase | cosa deve succedere | p. |
|---|---|---|
| **1. ROTTURA** | il Supertrend del grafico operativo **cambia colore e diventa rosso**, con **l'RSI dello stesso grafico già ribassista** (*«almeno due massimi di ciclo che scendono»*). **Si traccia la LINEA VIOLA** sul supporto rotto | p.16 |
| **2. RITEST** | il prezzo **risale**, con RSI rialzista (*«almeno due minimi di ciclo che salgono»*). **Può rompere o non rompere il Supertrend: è indifferente** | p.16 |
| **3. CONTROLLO** 🥇 | il nuovo supporto (nuovo Supertrend verde, **se si è formato**) deve essere **minore o uguale alla linea viola**. Se è salito, **la rottura è annullata: si cancella tutto e si torna ad aspettare un nuovo ritest** | p.16-17 |
| **4. RIPARTENZA** | **RSI torna ribassista + Supertrend torna rosso + il ciclo passa negativo. QUESTO è il segnale** | p.16 |
| **+ filtro di livello** | il Williams **deve stare ancora nella prima metà** dell'oscillatore (fra la zona estrema e il **−50**) | p.17 |

**La riga che il manuale marca come decisiva** (p.17, riquadro):
> *«Il punto 5 è quello che fa la differenza. Il controllo sulla linea viola è
> il filtro che elimina la maggior parte dei falsi segnali… è il motivo per cui
> la strategia ha un'affidabilità alta.»*

**Regola d'ordine** (p.16, riquadro rosso): *«Il ritest viene DOPO la rottura,
mai prima. È l'errore più comune… non si può prendere come ritest un massimo
che è avvenuto prima della rottura: si guarda solo in avanti»*.

**Rottura vera vs falsa** (p.10): *«Se una candela tocca il gradino con l'ombra
ma chiude prima, NON è una rottura»* → **conta la CHIUSURA, non l'ombra**.

**La scorciatoia strutturale** (p.16): *«la rottura del Supertrend di un time
frame equivale a un allineamento completato sul time frame immediatamente
inferiore»*.

**Il filtro laterale/direzionale** (p.18): se il Supertrend del grafico
superiore **ha già attraversato la linea viola** → grafico **direzionale**, si
prendono **solo** i segnali col trend. Se non l'ha ancora attraversata →
**laterale**, si prendono entrambi i lati.

### 3.2 La gestione (p.21-23) — la parte che il manuale dichiara «più importante di tutto il resto»

| meccanismo | regola esatta | p. |
|---|---|---|
| **Stop a zero — condizione A** | il **Williams del grafico d'ingresso entra nella zona estrema opposta** senza che il Supertrend sia stato rotto (*«a quel punto sei, statisticamente, già al target del ciclo che stavi tradando»*) | p.21 |
| **Stop a zero — condizione B** | il **Supertrend del grafico d'ingresso attraversa il prezzo d'ingresso** | p.21 |
| **«Zero» significa zero davvero** | *«spread e commissioni già coperte»*: lo stop al prezzo esatto d'ingresso **non è** breakeven | p.21 |
| 🥇 **La cascata** | quando il Supertrend attraversa l'ingresso **si sale di un grafico**; lo stop segue il Supertrend del grafico nuovo; chi può farti uscire diventa **l'allineamento del TF immediatamente inferiore** | **p.22** |
| 🥇 **LA REGOLA D'ORO** | *«Passando a un grafico superiore lo stop non si allarga MAI. Se il Supertrend del grafico nuovo è più lontano del tuo stop a zero, lasci lo stop a zero dov'è. Non si torna mai indietro sul profitto già consolidato.»* | **p.22**, ripetuta p.27 e p.32 (errore n.8) | 
| **Non attaccare lo stop al Supertrend** | *«il Supertrend può essere toccato da uno spike senza che la candela chiuda oltre… lascia sempre qualche pip di margine oltre la cuspide»* | p.21 |

**Le tre uscite** (p.23), in ordine di qualità dichiarata:

| # | uscita | quando | giudizio del manuale |
|---|---|---|---|
| 1 | **Target** | il prezzo raggiunge i **2 ATR** del ciclo direzionale | *«l'uscita ottimale»* |
| 2 | **Uscita anticipata** | l'**RSI del grafico di gestione gira contro (divergenza)**, oppure si completa un **allineamento contrario sul TF inferiore**. Segnale più usato: **prezzo sotto la MA9 del grafico di gestione + divergenza RSI dello stesso grafico** | *«è questa che ti porta a casa il profitto invece di restituirlo… fra la divergenza e il Supertrend c'è tutta la differenza fra chiudere al 3% e chiudere all'1%»* |
| 3 | **Stop tecnico** | il **Supertrend del grafico di gestione viene rotto** | *«è la peggiore delle tre: significa che le prime due non le hai viste»* |

**Multiday** (p.23): per portare una posizione al giorno dopo la gestione deve
essere **già passata almeno all'H1**; per portarla al lunedì, **almeno all'H4**
e il movimento dev'essere *«un weekly o un mensile in partenza, non in
esaurimento»*. Criterio in numeri dato dal manuale: *«se restituisco 70 per
prenderne 100, il rapporto è 1:1,4 e non vale la pena. Se restituisco 70 per
prenderne 250, allora sì»*.

---

## 4. 🚩 BANDIERE ROSSE — cercate esplicitamente, ed **eccole**

**Verifica fatta per prima cosa, come da regola di casa.** Risultato: il
manuale è **quasi pulito**, ma **NON del tutto**. Ecco tutto quello che ho
trovato, con la citazione che lo prova.

### 🔴 B1 — LA COPERTURA (HEDGING) SU POSIZIONE IN CORSO — **p.23**

> *«**La copertura (hedging).** Mentre tieni aperta una posizione multiday, sul
> time frame basso arrivano segnali nella direzione opposta. Si possono
> prendere: **quello che perdi sulla posizione grande lo recuperi
> sull'intraday**, e nel frattempo hai tempo di capire se conviene chiudere.
> Serve però un conto che liberi il margine sulle posizioni coperte,
> altrimenti con capitali piccoli non è materialmente possibile.»*

| | |
|---|---|
| **Che cos'è** | **aprire una posizione contraria per compensare la perdita di una posizione aperta**, invece di chiuderla |
| **Che cosa NON è** | **non è martingala** (nessun aumento di size dichiarato), **non è griglia** (nessuna scala di ordini), **non è mediazione** (non si aggiunge nella stessa direzione a prezzo peggiore) |
| **Perché è comunque una bandiera** | è **recovery in senso proprio**: la logica dichiarata è *«quello che perdi sulla grande lo recuperi sull'intraday»*, cioè **usare un'operazione nuova per rimediare a una perdita in corso** invece di chiuderla. E la giustificazione data è **il margine**, non l'edge |
| **Verdetto di casa** | 🔴 **VIETATO PER NOI, senza discussione.** La clausola è scritta **in testata su 8 sorgenti** della flotta (`ABTG_BreakinBox.mq5:112`, `ABTG_CRT_TurtleSoup.mq5:52`, `ABTG_ChaosLyapunov.mq5:35`…): *«NIENTE martingala/griglia/recovery/DCA/mediazione»* |
| **Cosa abbiamo già fatto** | ✅ **niente da fare: era già escluso l'11/08.** L'intestazione di `ABTG_AltaVelocita.mq5` lo dichiara nero su bianco fra le approssimazioni: *«Niente hedging multiday… una posizione alla volta, nessuna griglia»* |

### 🟠 B2 — IL RIENTRO RIPETUTO DOPO L'USCITA IN PERDITA, dichiarato «funzionamento normale» — **p.26-27**

> p.26: *«Nel percorso viene descritta una giornata in cui, per via delle
> notizie, lo stesso cross ha fatto entrare e uscire **quattro volte**: 3% in
> sell, 3% in buy, di nuovo sell, di nuovo buy, e **solo alla quinta è partito
> davvero**.»*
> p.27: *«**Uscire quattro volte a zero o in piccola perdita e poi prendere il
> movimento buono è il funzionamento normale della strategia, non un tuo
> errore.**»* + tabella: *«Cosa NON fare: saltare da un cross all'altro dopo
> ogni uscita → Cosa fare: restare sullo stesso cross: prima o poi parte, e
> quando parte sei lì»*.

| | |
|---|---|
| **Che cos'è** | **rientro sistematico sullo stesso strumento dopo un'uscita in perdita**, a size invariata |
| **Perché non è rosso pieno** | ✅ **la size non aumenta**, ✅ il rientro richiede **un segnale nuovo completo** (p.27: *«Cosa NON fare: rientrare senza segnale, "tanto ormai" → Cosa fare: aspettare che il Williams torni in zona di scarico»*). **Non è martingala.** |
| **Perché è arancione lo stesso** | ⚔️ **contraddice frontalmente l'unica misura esterna che abbiamo su questo esatto comportamento.** `report/ANALISI_STUDIO_PS5_ORB_2026-09-06.md` §C1, misurata sul conto vero di Garbuglia, 29/07-04/08: **rientro dopo lo stop in 4 sedute su 4, costo netto −2.836 €**. E il suo backtest: *«qualsiasi schema che rientri dopo uno stop moltiplica l'esposizione proprio all'evento che ha causato la perdita»*, con **frequenze di inversione 35% UK100 / 57% DAX / 68% Russell** |
| **Verdetto di casa** | 🟡 **si registra, non si adotta.** Un metodo dice *«è il funzionamento normale»*; l'altro porta **il conto in euro** che dice il contrario. **La dichiarazione senza numeri perde contro la misura con numeri.** E il nostro EA ha già `InpMaxTradesPerDay` come cappello, oggi a 0 = illimitato |
| **Nota** | il *«3% in sell, 3% in buy»* è **[TRASCRITTO DUBBIO]**: nel contesto sembrano perdite, ma la percentuale non è mai spiegata. **Non si usa questo numero per niente.** |

### 🔴 B3 — IL CLAIM DEL CAPITALIZZAZIONE: **2.000 € → 1.000.000 € in 210 operazioni** — **p.5**

> Didascalia del grafico, p.5: *«Servono ~210 operazioni chiuse al 3% per
> portare 2.000 EUR a 1.000.000 EUR.»*

**L'ho verificato con l'aritmetica**: 2.000 × 1,03²¹⁰ = **≈ 992.000 €**. ✅ Il
conto **torna esattamente** — ed è proprio questo il problema:

| | |
|---|---|
| **Cosa assume quel numero** | **210 operazioni consecutive, TUTTE vincenti al 3%, in capitalizzazione piena.** Nessuna perdita è sottratta |
| **Cosa dice il manuale STESSO tre pagine prima** | p.4: *«Rapporto 3… ma è una **media**, non un massimo… qualche operazione farà meno di 3 e la media scenderà sotto»* — e p.28 fissa **l'affidabilità a ≥80%**, cioè **1 operazione su 5 in perdita** |
| **Verdetto** | 🔴 **la copertina numerica del metodo è aritmeticamente incompatibile con le sue stesse regole a pagina 4 e a pagina 28.** È un claim di percorso, non una previsione |
| **Regola di casa applicata** | `ASPETTATIVE_REALISTICHE.md`: *«+223% annuo metterebbe il progetto sopra qualunque fondo al mondo (i migliori: 20-40% annuo). **Se un numero suona così, non è una previsione**»*. Un ×500 in 210 operazioni è **due ordini di grandezza oltre** quella soglia |

### 🟠 B4 — «la media giornaliera con rischio 1% può arrivare al 12-13%» — **p.4**

> *«Nel percorso si dice che **la media giornaliera con rischio 1% può arrivare
> al 12-13%**.»*

**[DICHIARATO, NON VERIFICATO, e ambiguo]**: non è detto se «12-13%» sia
rendimento giornaliero, mensile, o il rapporto medio. Se fosse **giornaliero**,
sarebbe **+3.000% annuo composto**. **Non si usa.** Nessun'altra pagina del
documento ci torna sopra.

### ✅ E ORA COSA **NON** C'È — dichiarato esplicitamente

Ho cercato, riga per riga, i meccanismi che la nostra regola di casa vieta:

| meccanismo vietato | presente? | evidenza |
|---|---|---|
| **Martingala / raddoppio dopo la perdita** | ❌ **ASSENTE** | nessun passaggio parla di aumentare la size dopo una perdita. Il rischio è **fisso all'1-2%** (p.29) |
| **Griglia di ordini** | ❌ **ASSENTE** | il metodo è **una posizione, un segnale** |
| **Mediazione / DCA** | ❌ **ASSENTE** | mai nominata |
| **Operare senza stop loss** | ❌ **ASSENTE — anzi, l'opposto** | p.32, errore n.8: *«**Allargare o togliere lo stop.** Non si allarga mai»*. p.27: *«Lo stop non si tocca mai in peggio»* |
| **Allargamento dello stop in corsa** | ❌ **VIETATO DAL MANUALE STESSO** | la «regola d'oro» di p.22 e l'errore n.8 di p.32 |
| **Trucchi per aggirare le prop firm** | ❌ **ASSENTE** | il documento **non nomina mai** le prop firm, il copy trading o il rilevamento degli EA. **Zero materiale di questa categoria** |

> 🟢 **Va detto con chiarezza: sulla gestione del rischio per-operazione questo
> manuale è più severo di molte fonti che abbiamo analizzato.** Stop
> obbligatorio, mai allargato, rischio fisso, cancello 1:3 che **scarta il
> segnale** invece di forzarlo. L'unica vera crepa è **B1 (hedging)**, ed è
> confinata a un riquadro su un'unica pagina.

---

## 5. 🧮 LE SETTE INCOERENZE INTERNE — trovate leggendo, e vanno agli atti

Non squalificano il documento: **tarano quanto peso dargli**, e servono a chi
volesse implementarlo.

| # | dove | l'incoerenza | perché conta |
|---|---|---|---|
| **X1** | **p.24-25** | 🔴 **Lo stop dell'Esempio 1 è dal lato SBAGLIATO del massimo di ciclo.** Il manuale (p.21) prescrive *«1 pip **oltre** il massimo»*; il massimo di ciclo dichiarato è **106,15**; lo «stop largo» dichiarato è **106,13**, cioè **2 centesimi SOTTO il massimo** — dentro il movimento, non fuori | **chi copia letteralmente l'esempio piazza uno stop che il mercato ha già toccato.** (L'aritmetica del rapporto invece **torna**: ingresso 104,40, stop 106,13, target 99,95 → 4,45/1,73 = **2,57 ≈ 1:2,6** ✅, e con lo stop finale 105,48 → 4,45/1,08 = **4,12 ≈ 1:4,2** ✅) |
| **X2** | **p.17 vs p.19 vs p.35** | 🔴 **Per lo stesso ciclo H4 il manuale dà DUE grafici operativi diversi.** p.17 (i 7 punti): *«voglio vendere un ciclo H4. **Grafico operativo = M15**»*. p.19 (tabella operativa base) e p.35 (App. B): **ciclo H4 → grafico operativo M5** | è **la scelta più strutturale del metodo**. 👉 **Il nostro EA ha seguito la lettura di maggioranza** (App. B + p.8 + p.19 + p.35 = 4 luoghi contro 1): `InpCicloTF=H4` → operativo **M5** |
| **X3** | **p.19-20** | **Il rapporto R/R non raddoppia come dichiarato.** Testo p.19: *«il rapporto rischio/rendimento raddoppia a ogni gradino»*; ma il grafico p.5 dà 1:3 → 1:6 → 1:12 → 1:24 → **1:50** → **1:139** (×2,08 e ×2,78), e p.19 dà **1:48** dove p.5 dà 1:50 | numeri decorativi, non calcolati. **Il 1:139 non è una misura: è un'estrapolazione** |
| **X4** | **p.20 vs p.35** | **«Gradini sotto» è contato in due modi.** p.20: *«1 gradino sotto il direzionale = 1:3»*. p.35 (2ª tabella): ciclo H4 → **ingresso base (1:3) = M5**, che è **3 gradini** sotto H4 | l'ambiguità si scioglie solo capendo che *«il ciclo che tradi davvero»* (p.19, 3ª colonna) è **1 gradino sotto il direzionale** — ma **il documento non lo dice mai in modo esplicito** |
| **X5** | **p.29** | 🔴 **Il paragrafo del «tetto invalicabile» è internamente rotto**: *«Il drawdown prospettico complessivo… non deve mai superare il **20%**. Trenta è già esagerato. **Su un conto da 6.000 euro un 5% significa 300 euro**»*. Tre percentuali diverse (20 / 30 / 5) in tre frasi consecutive, senza collegamento | **il numero da citare è ≤20%**; gli altri due sono **[TRASCRITTO DUBBIO]** e **non si usano** |
| **X6** | **p.24 (titolo del grafico) vs p.24 (titolo di sezione e tabella)** | il titolo della sezione dice **«grafico operativo M5»**, il grafico dentro la stessa pagina dice **«grafico operativo M15»**, e tutti gli 8 passaggi della tabella parlano di **M5** | ricaduta di X2 |
| **X7** | **p.6 + p.11** | 🧮 **Il «140» non deriva dalla regola delle 6 barre.** p.11: *«con 140 periodi copre l'intera vita del ciclo che stai studiando»*. Ma il Williams sta **2 TF sotto il direzionale** (p.7), e per la regola delle 6 barre (p.6) quel ciclo dura **≈72-96 barre** del grafico del Williams (M5→ciclo H1 = 72 · M15→ciclo H4 = 96 · M1→ciclo M15 = 90) | **[INFERITO da p.6 + p.7 + p.11]**: 140 è **1,5-2 volte** la vita del ciclo, non «l'intera vita». 👉 Conseguenza pratica: **140 è una costante scelta, non derivata → è legittimamente un parametro da sondare**, non un dogma |

---

## 6. 📎 APPENDICE D — «L'indicatore per MetaTrader»: il verdetto secco

**Domanda posta**: contiene formule, codice o specifiche implementabili in MQL5?

### ⛔ RISPOSTA: **NO.** Zero righe di codice, zero formule, zero valori di parametro.

L'Appendice D (p.37-38) è **due pagine di descrizione funzionale + istruzioni
d'installazione**. Ecco **tutto** quello che contiene, estratto integralmente:

**I file citati (che NOI non abbiamo):**

| file | piattaforma | nota testuale |
|---|---|---|
| `AltaVelocita.mq5` | MetaTrader **5** | *«MT5 non compila il linguaggio MQL4: per MT5 il codice dev'essere in MQL5, quindi è stato scritto così»* |
| `AltaVelocita.mq4` | MetaTrader **4** | *«Stessa logica, in MQL4»* |

**Cosa dichiara di fare (6 punti, testuali):**
1. Disegna **Supertrend, Williams %R a 140, RSI a 4 e un oscillatore ciclico**
2. Traccia in automatico la **linea viola** quando il Supertrend gira
3. Riconosce le **tre fasi** e segnala la **ripartenza** con una freccia,
   *«verificando tutti i sette punti»*
4. Calcola e disegna **stop** (sul punto estremo o sulla cuspide) e **target a
   2 ATR** presi dal TF direzionale, e mostra il **rapporto R/R: se è sotto 1:3
   il segnale viene marcato come da scartare**
5. **Dashboard** con lo stato di ogni TF da M1 in su: colore del Supertrend,
   zona del Williams, direzione dell'RSI, segno del ciclo, fase raggiunta
6. **Alert** a schermo, push e mail sulla ripartenza confermata

**Le due avvertenze tecniche — e sono la parte che vale davvero** (p.37):

> **1) I grafici a tick.** *«MetaTrader non ha il "100 tick" come time frame:
> l'indicatore parte da M1. Chi vuole lavorare davvero sotto il minuto deve
> costruirsi un grafico a tick o usare un M1 come approssimazione, **sapendo che
> non è la stessa cosa**.»*
>
> 🥇 **2) L'oscillatore ciclico.** *«**La formula esatta dell'indicatore ciclico
> usato nel percorso non viene spiegata nelle lezioni.** Quello nel codice è un
> oscillatore detrended che si comporta allo stesso modo per quello che serve a
> noi: il cambio di segno marca la fine di un ciclo. **Se hai la formula
> originale, va sostituita**: nel file c'è una funzione dedicata, isolata
> apposta.»*

**Parametro d'uso dichiarato** (unico): *«Nei parametri imposta
**`CicloDirezionale`** sul ciclo che vuoi tradare: l'indicatore ricava da solo
dove leggere Williams, RSI e ATR»* → **stessa architettura del nostro
`InpCicloTF`.**

### 🥇 IL PUNTO CHE CAMBIA IL GIUDIZIO SULL'INTERO DOCUMENTO

L'indicatore **ufficiale del corso** ammette di **non avere la formula del
ciclo** e usa un surrogato detrended.
**Noi la formula originale ce l'abbiamo**, e non da una fonte sola:

> `ALTA_VELOCITA_TESI.md`: *«**FORMULA ORIGINALE OTTENUTA** (11/08,
> `alta_velocita_ciclo.pine`): composito di 4 stocastici lisciati
> **I = (4,1·K1 + 2,5·K2 + K3 + 4·K4) / 11,6** con K1=SMA(St(5),3),
> K2=SMA(St(14),3), K3=SMA(St(45),14), K4=SMA(St(75),20); **CICLO = I −
> SMA(I,9)**»* — e con la nota: *«**Conferme incrociate: la formula del ciclo
> arriva identica da 3 fonti indipendenti** (odt, .pine TradingView, manifest
> del .algo cTrader con gli stessi default 5/3, 14/3, 45/14, 75/20, MM 9)»*.

👉 **Sull'unico pezzo che l'Appendice D dichiara mancante, il nostro
`ABTG_AltaVelocita.mq5` è più fedele al metodo dell'indicatore che il corso
distribuisce.** E il file esiste già nel repo, compilato e collaudato.

**Cosa resterebbe da chiedere, se Claudio avesse i file del corso:** i **valori
del Supertrend** (P6) e il **periodo dell'ATR** (P7) — gli unici due parametri
portanti che il manuale non dichiara in nessuna delle 38 pagine.

---

## 7. ⚖️ IL CONFRONTO — classificazione a tre categorie
*(stesso schema di `report/ANALISI_STUDIO_PS5_ORB_2026-09-06.md`)*

### ✅ CONFERMA INDIPENDENTE — cose che già facciamo, che qui trovano una voce esterna

| # | tema | LUI (manuale, con pagina) | NOI | lettura |
|---|---|---|---|---|
| **C1** | 🛑 **Lo stop non si allarga MAI** | «regola d'oro» p.22 + errore n.8 p.32 | clausola di casa su tutta la flotta; nessun EA ha logica di allargamento in corsa | conferma piena, da fonte indipendente e **discrezionale**: anche a mano la regola è la stessa |
| **C2** | 🚪 **Il segnale che non arriva al rapporto NON si prende** | p.21: *«quel segnale non si prende. Non è un'operazione sbagliata: è un'operazione che non ti porta all'obiettivo»* | `InpMinRR=3.0` in `ABTG_AltaVelocita.mq5:167`; e concettualmente **è il gemello di `InpSkipIfTight`** di `ABTG_DAX_Apertura_EU` (*«saltare il trade invece di allargarlo»*, il «terzo ramo» del dossier PS5 §4.3) | 🥇 **convergenza notevole**: **due fonti esterne diverse, nella stessa settimana, arrivano a "meglio saltare che forzare"** — ed è il ramo che il dossier PS5 ha marcato come *«mai misurato da nessuno»* |
| **C3** | 📅 **Il calendario macro si guarda la sera prima, e non si trada l'istante della notizia** | p.30: *«Tradare l'istante della notizia è pericoloso con qualsiasi broker: lo spread si allarga, gli ordini pendenti vengono presi a prezzi che sul mercato non esistono, gli stop saltano»* | filtro news già negli input (`InpUseNewsFilter`, finestre 60'/30'); `CACCIA_CANDELA_NEWS_2026-09-03.md`; e la misura di casa `SPREAD_FLOTTA_MISURA_2026-09-03.md` (252 M tick) | conferma **qualitativa** di un fenomeno che **noi abbiamo già misurato**. Lui lo racconta, noi abbiamo i tick |
| **C4** | 📉 **Il giudizio si dà su drawdown e regolarità, non sul rendimento** | i tre numeri della patente sono **DD 3 / dev.std 2 / DD prospettico 7** (p.28): **nessuno dei tre è un rendimento** | `ASPETTATIVE_REALISTICHE.md`; criterio `OnTester` su **Recovery Factor** su ~30 sorgenti | conferma piena — **e il manuale si contraddice da solo** a p.5 (bandiera B3), esattamente come Garbuglia si contraddiceva in §6 |
| **C5** | 🧾 **Il report periodico che decide se si può andare in reale** | p.28: *«ogni 20-30 operazioni si cancella e si reinserisce l'ultimo blocco»* | **criterio di uscita a tre corsie** congelato il 18/08 (`FIRME_2026-08-18.md`): MERITO a **20 operazioni**, TAGLIANDO a **6 mesi** | 🥇 **due soglie quasi identiche prese per strade completamente diverse**: lui **20-30 operazioni** per la revisione, noi **20 operazioni**. Il manuale è **discrezionale**, noi automatici: la convergenza sul numero è genuina |
| **C6** | 🚫 **Niente martingala, griglia, mediazione, no-SL** | assenti in tutte le 38 pagine (§4) | clausola in testata su 8 sorgenti | conferma per **assenza**, che è comunque una conferma |
| **C7** | ⏱️ **Un'operazione che non puoi seguire non si apre** | p.4: *«Un'operazione che non puoi seguire non è un'operazione: è una scommessa»*; p.31: *«Se non c'è, non c'è. Non si trada per forza»* | è **la ragione d'essere della flotta EA**: la presenza umana l'abbiamo sostituita con la macchina | ✅ conferma **rovesciata, e importantissima**: il vincolo che il manuale mette al trader umano **è esattamente ciò che noi abbiamo rimosso automatizzando**. È il vantaggio strutturale del nostro impianto su questo metodo |

### 💡 IDEA NUOVA DA VALUTARE — poche, e tutte piccole

| # | idea | dov'è | cosa facciamo oggi | giudizio |
|---|---|---|---|---|
| **I1** | 🕐 **Il filtro di SESSIONE / fascia oraria** (p.30-31: *«una sola sessione al giorno, non due… mattina e pomeriggio sono due sessioni diverse e il pomeriggio si riparte da foglio bianco»*) | p.30, p.31, p.33 (checklist: *«fascia oraria decisa»*) | 🔴 **`ABTG_AltaVelocita.mq5` NON ha alcun input di sessione o di fascia oraria** (verificato sull'elenco completo dei 32 input): l'EA opera 24 ore | 🟡 **è l'unico pezzo dichiarato del manuale che l'EA non ha mai implementato.** ⚠️ **MA**: il fuso non è dichiarato (§2.4), il capitolo è **chiuso con patto**, e la **REGOLA DELLA SECONDA CACCIA** vieta di rigriglare un motore senza edge con «parametri diversi dello stesso motore morto». **Si registra, non si propone come round.** Vedi **P2** |
| **I2** | 🔢 **Il «140» come parametro da sondare, non come costante** | incoerenza **X7** | l'EA lo ha come input `InpWprPeriod=140`, **mai sondato** (le griglie hanno mosso `StMult` e le punte RSI) | 🟢 **valore conoscitivo, non operativo.** Dimostra che il numero-bandiera del metodo **non deriva dalla sua stessa geometria**. Utile per il registro dei caduti, non per un round |
| **I3** | 📏 **Il rapporto R/R come metrica DI SCARTO calcolata PRIMA di entrare, disegnata sul grafico** | p.14 (*«riportalo sul grafico come linea orizzontale prima di entrare»*), p.34 (checklist *«Rapporto verificato >= 1:3 — se non ci arrivo nemmeno stringendo, NON entro»*) | ce l'abbiamo come **filtro numerico** (`InpMinRR`), non come **disciplina di scrittura** | 🟢 **è l'idea più trasferibile del documento, e non riguarda il codice**: è il gemello di **I7 del dossier PS5** (*«cosa è stato scartato, con i numeri»*). Costo: zero |
| **I4** | 🧮 **Il criterio in euro/pip per tenere una posizione oltre la giornata** (*«se restituisco 70 per prenderne 100 il rapporto è 1:1,4 e non vale la pena; se restituisco 70 per prenderne 250, allora sì»*) | p.23 | non abbiamo un criterio esplicito di **hold overnight in R residui** | 🟡 **idea pulita, applicabile in linea di principio** a `ABTG_MaxMinNotte` e alle sedie multiday. **Ma è un'affermazione senza una sola misura sotto**, e le nostre sedie hanno contratti congelati. **Registrata, non proposta** |

### 🚫 NON APPLICABILE / GIÀ SUPERATO

| # | cosa | perché non si trasferisce |
|---|---|---|
| **N1** | 🔴 **Il metodo nel suo insieme** | **già tradotto, già misurato, già bocciato.** v1 (8/8 celle negative OHLC **e** tick, PF 0,54-0,85, DD fino al 37%), v1.1 (4/4 negative OOS), **v2 col motore vero delle punte RSI** (6 celle su 6 negative, IS e OOS, in tutte le classificazioni — *«anche le SOLE divergenze da manuale perdono»*). **Patto di chiusura firmato: nessuna v3 senza una tesi nuova scritta prima dei numeri** |
| **N2** | **Il gradino «100 tick»** | non esiste come time frame in MT5 — **lo dice il manuale stesso** (p.37) e lo dichiara la nostra tesi (approssimazione n.3). Le combo `M15→100tick` restano **non testabili nel tester** |
| **N3** | ⛔ **L'hedging multiday (B1)** | vietato dalla regola di casa. **Già escluso dall'EA l'11/08, per iscritto** |
| **N4** | **I quattro orari di p.30** | **fuso non dichiarato** → `CLAUDE.md` lo vieta. Non entrano da nessuna parte |
| **N5** | **I numeri di performance (B3, B4, e il 1:139)** | claim di percorso, aritmeticamente incompatibili con le regole del manuale stesso (§4-§5) |
| **N6** | **La lettura fine dell'RSI: canali, ventagli, «pallina», accelerazione/rallentamento** (p.13-14) | **è la parte irriducibilmente umana**, e il referto dell'11/08 dice che è *«probabilmente IL cuore»*. La v2 ha implementato **le punte per-ciclo** (la parte codificabile) **e ha perso lo stesso**: quindi o il cuore è nella parte non codificabile, o non c'è |
| **N7** | **La «doppia uscita» del Williams come pattern d'ingresso** (p.12) | dichiarata fuori dalla v1/v2 (l'EA la approssima con `InpWprGraceBars=10`). Riaprirla è **un round su un motore chiuso** |

---

## 8. 🔬 IL CONFRONTO RIGA-PER-RIGA COL NOSTRO EA — chi ha tradotto cosa

Verifica di fedeltà fatta oggi, manuale alla mano, su `mql5/Experts/ABTG_AltaVelocita.mq5`
(1.422 righe, 32 input, magic **771401**). **Nessuna riga è stata toccata.**

| regola del manuale | p. | input / meccanismo dell'EA | fedeltà |
|---|---|---|---|
| Williams 140 | p.9 | `InpWprPeriod = 140` (riga 142) | ✅ **esatta** |
| RSI 4 | p.9 | `InpRsiPeriod = 4` (riga 149) | ✅ **esatta** |
| Limite −50 | p.12 | `InpWprMid = -50.0` (riga 145) | ✅ **esatta** |
| Target 2 × ATR del direzionale dal massimo di ciclo | p.14 | `InpTargetATRmult = 2.0` (riga 165) + riga 1074: `tp = estremo ± mult*atrDir` — **misurato dall'estremo, non dall'ingresso** | ✅ **esatta, incluso l'errore n.5 evitato** |
| Operativo = 3 gradini sotto il ciclo | p.8/19/35 | `InpCicloTF = PERIOD_H4` con commento *«operativo = 3 gradini sotto»* (riga 135) | ✅ **lettura di maggioranza** (vedi X2) |
| Williams contesto +1 · RSI contesto +2 · ATR sul direzionale | p.8, p.35 | dichiarato in testata e implementato con **handle espliciti sui TF giusti** | ✅ **esatta** |
| Stop 1 pip oltre l'estremo | p.21 | `InpSLBufferPoints = 10` (riga 166) | ✅ (in points, parametrico) |
| R/R < 3 → segnale scartato | p.21 | `InpMinRR = 3.0` (riga 167) | ✅ **esatta** |
| Stop fra «rumore» e «grafico sbagliato» | p.21 | `InpMinStopAtrOp = 0.8` / `InpMaxStopAtrOp = 4.0` (righe 168-169) | ⚠️ **tetto fedele** (20 pip su ATR 5 = 4×), **pavimento più severo del manuale** (0,8× contro l'implicito ~0,3×) — **scelta nostra, dichiarata nel codice** |
| Controllo della linea viola (punto 5) | p.17 | fase **3. CONTROLLO** della macchina a stati (testata righe 28-31) | ✅ **esatta** |
| Filtro direzionale del TF superiore | p.18 | `InpUseDirFilter = true` (riga 161) | ✅ |
| MA9 per l'uscita anticipata | p.23 | `InpMa9Bars = 2` (riga 172) | ⚠️ **parziale**: il manuale chiede **MA9 + divergenza RSI del grafico di gestione**; l'EA usa MA9 + RSI **a lookback**, non a punte — **approssimazione dichiarata in testata** |
| Cascata + stop mai allargato | p.22 | trailing sul Supertrend del TF superiore, *«mai allargando»* (testata) | ✅ **esatta** |
| Rischio 1% | p.29 | `InpRiskPercent = 1.0` (riga 175) | ✅ |
| Filtro news | p.30 | `InpUseNewsFilter` + finestre 60'/30' | ✅ presente (default off) |
| **Sessione unica / fasce orarie** | p.30-31 | 🔴 **ASSENTE** | ❌ **unico buco dichiarato** (→ I1) |
| Parametri Supertrend | — | `InpStAtrPeriod=10`, `InpStMult=3.0` **marcati «IPOTESI sweepabile»** (righe 137-139) | ✅ **onestà corretta**: il manuale non li dà (P6), e l'EA non finge di saperli |

> 🥇 **Verdetto di fedeltà: la traduzione dell'11/08 è buona.** Su 17 voci
> controllate: **13 esatte**, **3 approssimazioni già dichiarate nel codice**,
> **1 buco vero** (la sessione). **Nessun caso di parametro inventato o
> attribuito al manuale senza esserci.** Il verdetto rosso del referto **non è
> figlio di una traduzione sbagliata**.

---

## 9. ✍️ PROPOSTE PER CLAUDIO

> 🛑 **Nessuna è stata applicata. Nessuna tocca un EA, un preset o il forward.**
> Sono **quattro**, ordinate per resa ÷ costo, e **tre su quattro costano meno
> di un'ora**.

### 🥇 P1 — Chiedere a Claudio i due file del corso: `AltaVelocita.mq5` / `.mq4` (costo: una domanda)

L'Appendice D (p.37) dichiara che l'indicatore è **allegato al manuale**. Noi
**non ce l'abbiamo** — la richiesta era già agli atti l'11/08
(`ALTA_VELOCITA_TESI.md`: *«⚠️ Chiedere a Claudio se ha i file»*) e **non
risulta mai evasa**.

**Cosa risolverebbe, esattamente**: 🎯 **i due unici parametri portanti che il
manuale non dichiara mai** — il **Supertrend** (P6: periodo ATR e
moltiplicatore) e il **periodo dell'ATR del target** (P7). Oggi sono **ipotesi
nostre** (10 × 3,0 e 14).

⚠️ **Ma va detto prima**: **anche avendoli, il capitolo resta chiuso.** Il patto
di chiusura è esplicito. Avere quei numeri servirebbe a **sapere se la nostra
ipotesi era lontana**, non a riaprire un round. **È valore d'archivio, non
d'azione** — e per questo costa una domanda e basta.

### 🥈 P2 — Mettere agli atti il buco della SESSIONE, senza aprire un round (costo: 3 righe)

`ABTG_AltaVelocita.mq5` **non ha filtro orario**, mentre il manuale ci insiste
su **tre pagine** (p.30, p.31, p.33). Va scritto **nel referto di chiusura**,
non in una griglia:

> *«La v1/v1.1/v2 è stata misurata **senza il filtro di sessione**, che il
> manuale prescrive (una sola sessione al giorno). Il verdetto rosso vale per
> quello che è stato testato. La sessione **non è stata provata** — e non si
> prova, perché (a) il fuso del manuale non è dichiarato e (b) la REGOLA DELLA
> SECONDA CACCIA vieta di rigriglare un motore senza edge.»*

🎯 **Perché conta**: è la differenza fra *«bocciato»* e *«bocciato, e sappiamo
esattamente cosa non abbiamo provato»*. La seconda frase è quella che protegge
dal rifare due volte lo stesso lavoro fra sei mesi.

### 🥉 P3 — La riga «scarto dichiarato» accanto al filtro R/R (costo: zero, è una scrittura)

Il manuale trasforma il rapporto in **una decisione scritta prima di cliccare**
(p.34: *«Rapporto verificato >= 1:3 — se non ci arrivo nemmeno stringendo, NON
entro»*). **Noi abbiamo il filtro nel codice ma non contiamo mai quante volte
scatta.**

**Proposta**: quando una sedia della flotta ha un cancello di scarto attivo
(`InpMinRR`, `InpSkipIfTight`, `InpMaxSpreadToStopPercent`…), **il numero di
segnali SCARTATI finisca nel log e nella pagella**, accanto a quelli presi.

🎯 È il pezzo che manca per rispondere alla domanda aperta dal dossier PS5
§4.3: *«saltare invece di allargare — mai misurato da nessuno»*. **Senza contare
gli scarti, quel ramo non è misurabile nemmeno volendo.**

### 4️⃣ P4 — Una riga di rimando nel referto di chiusura (costo: fatto oggi, vedi §10)

Il `REFERTO_ALTA_VELOCITA_V1.md` è il documento che chiude il capitolo: chi lo
legge fra un anno deve trovare **da lì** il link a questa rilettura integrale
del manuale. ✅ **Già aggiunto** (§10).

### 🚫 Cosa NON propongo, e perché

| non proposto | motivo |
|---|---|
| **riaprire una v3 di `ABTG_AltaVelocita`** | patto di chiusura firmato l'11/08 sera. **Servirebbe una tesi nuova scritta PRIMA dei numeri, e questo PDF non ne porta nessuna**: non contiene un solo parametro che non avessimo già |
| **sondare `InpWprPeriod` attorno a 140** (X7) | è **esattamente** «parametri diversi dello stesso motore morto» — vietato dalla REGOLA DELLA SECONDA CACCIA. Su un motore 0/6 un'altra griglia trova **solo picchi di rumore** |
| **l'hedging multiday di p.23** | 🔴 **B1** — vietato dalla regola di casa |
| **qualunque uso dei quattro orari di p.30** | fuso non dichiarato (`CLAUDE.md`) |
| **citare i rendimenti del manuale** | **B3/B4** — aritmeticamente incompatibili con le sue stesse regole |
| **toccare qualunque cosa in forward** | regola di casa. **Questo dossier non applica niente** |

---

## 10. 🔗 INTEGRAZIONE COI DOSSIER ESISTENTI

Rimandi aggiunti (non duplicazioni):
- `backtest_pipeline/risultati_archivio/REFERTO_ALTA_VELOCITA_V1.md` → sezione
  di rimando a questo referto in coda (il capitolo resta chiuso; cambia solo
  che ora esiste la **rilettura integrale della fonte**).
- `report/ANALISI_STUDIO_PS5_ORB_2026-09-06.md` → il confronto **B2** (rientro
  dopo la perdita) e **C2** (saltare invece di forzare) parlano con il suo §C1
  e il suo §4.3. **Sono due fonti esterne, indipendenti, analizzate nello stesso
  giorno, che sullo stesso comportamento dicono cose opposte** — e solo una
  delle due porta il conto in euro.

---

## 11. 🕳️ COSA QUESTO DOSSIER **NON** DICE

1. 🔴 **Non ho verificato nessuna affermazione del manuale con una misura
   nuova.** Le uniche misure citate sono **le nostre, dell'11/08**, già agli
   atti.
2. 🔴 **Non ho girato un solo backtest oggi.** Le quattro proposte sono
   **proposte**.
3. ⚠️ **Non ho i file `AltaVelocita.mq5/.mq4` del corso**: tutto ciò che dico
   dell'indicatore ufficiale viene **dalle due pagine dell'Appendice D**, non
   dal codice. **Se quei file contengono i parametri del Supertrend, questo
   confronto ne è cieco** (→ **P1**).
4. ⚠️ **Non ho le 84 slide** citate dalla tesi dell'11/08 come seconda metà
   della fonte: ho letto **solo il PDF di 38 pagine**. Se un parametro del
   Supertrend sta lì, non l'ho visto.
5. ⚠️ **Le 7 incoerenze del §5 sono lette da me sul PDF**, non segnalate
   dall'autore: su X1 e X5 in particolare **la lettura alternativa è un errore
   di impaginazione del PDF**, non del metodo.
6. ⚠️ **La classificazione B1 come «recovery»** è **[INFERITO]** dalla frase
   *«quello che perdi sulla posizione grande lo recuperi sull'intraday»*: il
   manuale non usa mai la parola «recovery», e **non prescrive alcun aumento di
   size**. La bandiera è nostra, dichiarata come tale.

---

*Dossier di sola analisi. Nessun EA modificato, nessun preset toccato, nessun
parametro di forward cambiato, nessun conto sfiorato. Nessuna riga di lancio
prodotta. Le proposte sono quattro, tutte dichiarate e nessuna applicata:
decide Claudio.*
