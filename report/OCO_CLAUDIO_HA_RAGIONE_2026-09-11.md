# 🎯 L'OCO — **Claudio ha ragione, ed è già dentro l'EA.** Ma è SPENTO, e nessuno l'ha mai misurato

**Claudio (11/09):** *"Ma basta mettere due ordini pendenti uno sopra ed uno
sotto, il primo che si attiva si cancella l'altro."*

---

## ✅ 1. È ESATTAMENTE QUELLO CHE L'EA FA GIÀ — si chiama `InpUseOCO`

`mql5/Experts/ABTG_PostNews.mq5` `[MISURATO nel sorgente]`:

| | |
|---|---|
| r.11 | *"OCO configurabile (`InpUseOCO`): al 1º scatto cancella l'altra"* |
| **r.99** | `input bool InpUseOCO = true;` ← 🟢 **il DEFAULT dell'EA è ACCESO** |
| r.361-383 | `OcoCheck()`: appena una gamba diventa posizione, **cancella ogni pendente residuo dello stesso magic** |

👉 **La funzione è scritta, funziona, ed è accesa di fabbrica.**

---

## 🔴 2. MA TUTTI E QUATTRO I PRESET LO SPENGONO

```
ABTG_PostNews_ISM1500_EURUSD.set          InpUseOCO=false
ABTG_PostNews_NFP_USDJPY.set              InpUseOCO=false
ABTG_PostNews_NFP_USDJPY_LIVE_2026-09-04  InpUseOCO=false   <-- LA SEDIA VIVA
ABTG_PostNews_USD1330_USDJPY.set          InpUseOCO=false
```

**4 su 4.** E la motivazione scritta nel preset è una sola riga:
> *"niente OCO: **il corso lo nega esplicitamente** e le sedie vive non lo usano"*

## 🔴 3. E QUELLA MOTIVAZIONE **NON HA FONTE**

Ho cercato nel dossier del corso (`coach_paolo/NEWS_BREAKOUT_OCO_NFP_2026-09-03.md`).
**Non dice quello. Dice l'opposto:**

| dove | cosa dice |
|---|---|
| dossier caccia 04/09, r.280 | *"Il **motore range-M5 + OCO** non dipende dal TIPO di evento…"* |
| dossier caccia 04/09, r.500 | *"Il **motore range-M5 + OCO** di `ABTG_PostNews` funziona su…"* |
| 🔥 il nome dell'EA del coach | **`News Breakout M15 OCO \| NFP SEL`** |

> ## 🔴 **L'EA del coach ha "OCO" NEL NOME. I nostri dossier chiamano il meccanismo "range-M5 + OCO". E il nostro preset lo spegne dicendo che "il corso lo nega".**
> È la stessa classe di difetto che paghiamo da giorni: **una motivazione che
> cita una fonte che dice un'altra cosa.** E la seconda metà della frase —
> *"le sedie vive non lo usano"* — **è vera ma circolare**: non lo usano perché
> l'abbiamo spento noi.

## 🔴 4. E NON È MAI STATO MESSO AD ASSE

`[MISURATO da me]`: gli **unici 4 CSV** del repo che contengono la colonna
`InpUseOCO` sono in `risultati_prove/ABTG_PostNews/`, hanno **2 righe ciascuno**,
e il valore è **`1` in tutte e quattro**. 👉 **Un valore solo = la manopola non
è mai stata mossa.** La colonna c'è, la misura no.

---

## ⚠️ 5. MA ATTENZIONE — l'OCO **non risolve** il rischio che sembra risolvere

E non lo dico io: è scritto **nel nostro stesso dossier**, §5.2, insidia n.3:

> 🔴 *"**DOPPIO RIEMPIMENTO nel whipsaw**: il prezzo va su, scatta il buy, torna
> giù e **scatta anche il sell prima che l'OCO cancelli**. Due stop presi nello
> stesso minuto. È il rischio strutturale numero uno di questo meccanismo."*
>
> *"E anche dove l'OCO c'è, **è software**: fra l'attivazione del primo ordine e
> la cancellazione del secondo **passa un tick**, e sul rilascio di un NFP un
> tick può valere 30 punti."*

📌 **Confermato leggendo il codice**: `OcoCheck()` è una funzione che gira **sul
tick**, non un ordine OCO lato broker. Fra il fill e la cancellazione c'è una
finestra reale.

### Il bilancio onesto delle due vie

| | **OCO acceso** | **OCO spento (oggi)** |
|---|---|---|
| whipsaw | 🟡 **mitigato**, non eliminato | 🔴 **doppio stop: 0,65% invece di 0,325%** |
| inversione dopo il primo fill | 🔴 hai cancellato la gamba che avrebbe corso | 🟢 la prendi |
| trade per evento | **1** | fino a **2** |

👉 **Non è "OCO è meglio": è una domanda a due risposte possibili, e noi ne
abbiamo scelta una senza misurarla.**

---

## 🎯 6. COSA PROPONGO — e costa quasi niente

`InpUseOCO` **0/1** come **asse dichiarato** dentro il round del blocco USD1330.

| | |
|---|---|
| celle in più | **2** (è un booleano) |
| passate in più | **4** |
| tempo macchina | **~20 secondi** |
| cosa risponde | *"il doppio riempimento nel whipsaw ci costa più di quanto ci renda la seconda gamba?"* |

🔑 **E ha un contro-esempio pulito, per costruzione**: se il whipsaw fosse raro,
le due celle darebbero lo **stesso `Trades`** e lo stesso P/L — la manopola
sarebbe **inerte**, e lo si vedrebbe subito. Se invece i doppi riempimenti
esistono, la cella `OCO=0` ha **più trade** e un DD **peggiore**. 👉 **Le due
ipotesi non possono dare la stessa tabella.**

---

## 🛑 7. E UN VINCOLO CHE VALE PER TUTTE E DUE LE VIE
`docs/REGOLAMENTO_FTMO_2026-08.md` §4: vietato aprire **o chiudere** qualunque
trade, **pendenti compresi**, nella finestra **±2 minuti** attorno alla notizia.
🟢 **Noi siamo fuori**: la nostra ora d'azione è **news+15**. Ma se qualcuno
proponesse di piazzare i pendenti *prima* del dato — che è la versione più
naturale dell'idea — **quella versione è vietata dalle prop**, e va detto prima
di provarla, non dopo.

> ## 🔥 Riassunto in una riga: l'idea di Claudio è quella giusta, è già scritta nell'EA, l'abbiamo spenta noi per un motivo che non ha fonte, e non l'abbiamo mai misurata. Costa 20 secondi di macchina scoprirlo.
