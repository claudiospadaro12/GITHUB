# 🔎 Rilettura delle 17 live con le domande di oggi (05/08)

_Le trascrizioni sono nel repo dal 01/08 e furono lette in una chat precedente. Le ho **rilette adesso** perché in questi giorni sono nate domande precise che allora non avevamo. Ricerca mirata, non riassunto._

---

## 🔴 1. L'ORB è la candela dei 15 MINUTI DOPO l'apertura — e il nostro EA sbaglia finestra

La domanda aperta dal 03/08 era: 5 minuti **prima** dell'apertura (come il nostro `ABTG_ORB` e l'`ORB_Indicator_V15`) o 15 minuti **dopo** (come diceva a voce)?

**Le live rispondono in modo univoco, ripetutamente e in giornate diverse:**

> *"questa è la candela a 15 minuti, dove tracciamo il minimo e il massimo"*
> *"andiamo sull'Orb a 15 minuti, 15 minuti abbiamo questa candela, questo massimo e questo minimo"*
> *"la prima candela a 15 minuti risulta fondamentale per quanto riguarda la direzionalità"*
> *"l'Orb adesso ha chiuso, quindi alle **9.15**"* ← **decisivo**: la candela va da 09:00 a 09:15, cioè i primi 15 minuti **dopo** l'apertura

**[VERIFICATO]** Sei riscontri indipendenti. Il nostro `ABTG_ORB` usa il range **14:25→14:30**, cioè i 5 minuti **prima** dell'apertura USA: **è un'altra cosa.**

⚠️ Non significa che il nostro sia inutile — significa che **non è la strategia che Emiliano insegna**, e che non l'abbiamo mai testata nella sua forma vera.

## 🔴 2. La regola d'ingresso confermata: la candela deve APRIRE oltre, con volumi

> *"se mi apre sotto l'orb, quindi la candela a 15 minuti, **mi apre la candela sotto e c'è un incremento dei volumi**, io lì lo shorto"*

Conferma esattamente quello che avevo estratto dalla live del 03/08: **non alla violazione, ma sull'apertura della candela successiva oltre il livello**, e **solo con volumi in aumento**. I due pezzi vanno insieme, non sono opzionali.

Il nostro ORB entra con pendenti STOP sulla rottura, e ha il filtro volumi **spento** di default. Due differenze, non una.

## 🟡 3. Il breakeven: lo mette a ~30 punti DAX, insieme alla parziale

Cinquanta occorrenze di *"stop in pari"*. Il quadro che ne esce è coerente:

> *"mi porta a casa il meritato guadagno, **metà**, porto lo stop in pari"*
> *"questo è il primo obiettivo per me: chiudere, **portare lo stop in pari e portare in metà** la posizione"*
> *"a questo punto sì che posso mettere lo stop in pari, **perché sono circa 30 punti d'AXE**"*
> *"io porto lo stop in pari, ma **io adesso lo faccio correre**"*

**Parziale a metà + stop in pari, e poi lasciar correre.** Il trigger è **a livello, non in R: ~30 punti DAX**. Su un R del DAX di ~58,7 punti indice fanno **≈ 0,5 R**.

⚠️ **Qui c'è una divergenza vera con i nostri numeri, e non la risolvo a parole:** la fase distanze sul Dow ha mostrato che il BE a 0,5R **perde in 6 confronti su 8**, fino a −38%. Due possibilità, entrambe testabili:
- il Dow non è il DAX (già visto: i filtri non si trasferiscono fra mercati);
- oppure il BE funziona **solo insieme alla parziale**, e nella nostra griglia il parziale c'era ma il confronto isolava il solo BE.
**Da misurare sul DAX, non da decidere.**

## 🟡 4. Bande di Bollinger: "37,3" è periodo 37 · deviazione 3

Era il valore che il 03/08 avevo lasciato come [INCERTO]. Tre riscontri:

> *"bande di Bollinger io le tengo **37, 3**"*
> *"Che valori mettete all'interno di Bollinger? 22.5. … io metto **37.3**"*
> *"le bande di Bollinger **sull'indice** le metto a **37,3** … le metto **più larghe**"*
> *"vi ricordate che le avevo portate a **20**? proviamo a lavorare con le bande a 20"*

**[INFERITO ma solido]** `37,3` = periodo **37**, deviazione **3** — e lo dice esplicitamente: sull'**indice** le tiene *più larghe*. Il **20** (o 22) è per le valute e per il DAX quando smette di essere volatile.

## 🟢 5. I volumi: cosa guarda davvero

344 occorrenze. La definizione operativa è sempre la stessa:

> *"se lo va a violare **con volumi crescenti a istogramma**"*
> *"volumi crescenti vuol dire che lì si stanno concentrando gli **istituzionali**"*
> *"più la rottura è importante l'aumento dei volumi **e la mancanza di un ritorno**"*

E un'avvertenza sua che vale per noi:

> *"il volume che noi andiamo a vedere … è **relativo solo al broker**; invece se io lavoro sui futures, quello è mercato centralizzato"*

**Lo sa e lo dice: il volume su MT5 è tick-volume del broker, non volume vero.** Il nostro filtro misura la stessa cosa, quindi siamo allineati a lui — ma è bene sapere che l'indicatore è un surrogato.

---

## ✅ Cosa cambia, in concreto

| # | Azione | Fondamento |
|---|---|---|
| 1 | **Testare l'ORB con range = 15 min DOPO l'apertura** (non 5 prima) | sei riscontri diretti, univoci |
| 2 | **Accendere il filtro volumi sull'ORB** e testare `InpUseCloseConfirm` | la regola è "apre oltre **+** volumi", i due pezzi insieme |
| 3 | **Testare il BE a ~0,5R sul DAX insieme al parziale** | divergenza dichiarata coi nostri numeri sul Dow |
| 4 | Bollinger 37/3 sugli indici, 20-22 su valute | risolto l'[INCERTO] del 03/08 |

_Nota di metodo: queste trascrizioni erano nel repo da quattro giorni. Le domande giuste per interrogarle sono nate solo dopo i backtest di questa settimana. Vale la pena rileggerle ogni volta che una domanda nuova diventa precisa._
