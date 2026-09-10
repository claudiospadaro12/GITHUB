# ⚖️ "L'ORO RENDE PIU' DEL DAX E DEL NASDAQ ANCHE CON LO SPREAD" — misurato

**La tesi di Claudio (10/09/2026)**: *"lui fa l'oro perche' dovrebbe partire
abbastanza forte e anche con qualche punto si puo' guadagnare sicuramente piu'
del DAX e del Nasdaq, che sono un po' piu' letti; l'oro un po' piu' esclusivo, e
anche se c'e' un po' di spread comunque il guadagno dovrebbe essere sempre
maggiore."*

Misurata sulle **NOSTRE operazioni vere** (`data/statements/trades_auto.csv`),
non su un'opinione. Valore di un'unita' di prezzo **ricavato dai P/L veri**
(`profit / (volume x delta x verso)`), non da una tabella.

---

## 📊 LA TABELLA

| simbolo | n | valore di 1 unita' di prezzo, per lotto | spread | commissione | **COSTO giro completo** | denaro mosso, mediana | **MOSSO / COSTO** |
|---|---:|---:|---:|---:|---:|---:|---:|
| **XAUUSD** | 514 | **87,36 EUR** per **1,00 $** | 13,98 | **3,48** | **17,46 EUR** | 201,90 EUR | 🔴 **11,6x** |
| **D30EUR** | 150 | **1,000 EUR** per **1 punto indice** | 2,80 | 0,00 | **2,80 EUR** | 30,02 EUR | 🔴 **10,7x** |
| **NASUSD** | 55 | 0,867 EUR per punto | 1,56 | 0,00 | **1,56 EUR** | 46,30 EUR | 🟡 **29,7x** |
| **U30USD** | 62 | 0,861 EUR per punto | 1,72 | 0,00 | **1,72 EUR** | 82,78 EUR | 🟢 **48,1x** |

*(spread dalla sonda del 17/08, `215D85D7_ABTG_InfoBroker.csv`, colonna `SpreadPt`:
XAUUSD 16 = 0,16 $ · D30EUR 280 = 2,80 punti · NASUSD 180 = 1,80 · U30USD 200 = 2,00.
Commissione dalla colonna `commission`, mediana per lotto.)*

---

## ✅ DOVE CLAUDIO HA RAGIONE — e ha ragione davvero

**L'oro muove molto piu' denaro degli indici: 201,90 EUR per lotto contro i 30,02
del DAX.** Sette volte tanto. La sensazione al grafico e' giusta e i numeri la
confermano: **un contratto d'oro e' una bestia molto piu' grossa** — 87,36 EUR
per ogni dollaro contro **1,000 EUR** per ogni punto di DAX.

🎯 E il **1,000 EUR/punto del D30EUR** e' la stessa cifra gia' misurata in casa
su 6 operazioni reali su 6. Due misure indipendenti che tornano: la tabella e'
buona.

## 🔴 DOVE LA TESI SI ROMPE — e si rompe su un punto solo

> ## **La taglia del contratto e' una MANOPOLA. Il rapporto col pedaggio NO.**

Se il DAX muove "poco denaro", si aumentano i lotti. **La grandezza del
contratto non e' un vantaggio: e' una scelta di taglia**, e si compra in un
secondo dal pannello dell'ordine. Quello che **non** si puo' cambiare e' quante
volte il proprio pedaggio uno strumento riesce a muovere.

E li' la classifica **si ribalta**:

| | mosso/costo | costo in % del movimento |
|---|---:|---:|
| **U30USD** | **48,1x** | **2,1%** 🟢 |
| **NASUSD** | 29,7x | 3,4% 🟡 |
| **XAUUSD** | **11,6x** | **8,6%** 🔴 |
| **D30EUR** | 10,7x | 9,3% 🔴 |

👉 **A parita' di rischio, sul Dow il pedaggio si mangia il 2,1% del movimento.
Sull'oro l'8,6%: QUATTRO VOLTE tanto.** L'oro non e' lo strumento che rende di
piu' per quello che costa. E' quello che **muove di piu' in valore assoluto**,
che e' un'altra frase.

## 💸 E il secondo pezzo, che nessun conto di casa teneva
**L'oro paga commissione: 3,48 EUR/lotto giro completo. Gli indici ZERO.**
Da sola vale il **20% del costo totale dell'oro** — cioe' l'oro parte gia' con un
handicap che il DAX e il Nasdaq non hanno.

## 🧮 IL CONTO SUI "QUALCHE PUNTO"
Sull'oro **1 punto = 0,01 $ = 0,87 EUR/lotto**. Il pedaggio e' **17,46 EUR/lotto
= 20 punti**.
> 🔴 **Servono 20 punti (0,20 $) solo per andare in pari.** "Qualche punto" — 5,
> 10 — **e' una perdita**, per quanto spesso si vinca. E' la stessa aritmetica
> che ha prodotto **22 vinte su 33 e −785,99 EUR** nelle operazioni vere di
> Claudio in quella finestra.

## 🕵️ "L'oro e' piu' esclusivo, il DAX e il Nasdaq sono piu' letti"
E' una tesi sull'**affollamento**, e non e' assurda. Ma di suo non produce
denaro: produce denaro solo se **il movimento che genera batte il pedaggio**, e
il pedaggio dell'oro e' **4 volte peggiore** di quello del Dow. Fino a prova
contraria l'esclusivita' e' un'ipotesi; il pedaggio e' un fatto.

---

## 🚧 COSA QUESTA TABELLA **NON** DICE — e va detto
1. 🔴 **Non e' un confronto a parita' di strategia.** Sono tutte le nostre
   operazioni vere per simbolo, e ogni simbolo e' operato da sedie diverse con
   durate diverse. Dice **quanto pesa il pedaggio su come operiamo davvero**,
   non "quale simbolo e' migliore".
2. 🔴 **Il confronto nella FINESTRA DELLE 14:30 SERVER non e' fatto**: quanto si
   muove il DAX o il Nasdaq nei 5 minuti dopo l'apertura USA **non e' misurato**.
   E' la misura che manca per rispondere alla tesi **nel suo terreno**, ed e'
   quella che vale la pena fare.
3. 🔴 Lo **spread dentro la finestra** resta non misurato su tutti e quattro: le
   letture usate sono di altri momenti della giornata. Nei primi minuti dopo
   l'apertura lo spread **si allarga**, quindi i rapporti qui sopra sono la
   versione **ottimistica**.
4. Il rapporto `MOSSO/COSTO` **non e'** il cancello `stop >= 40 x spread`: quello
   giudica lo **stop**, questo confronta il **movimento**. Servono a domande
   diverse e non vanno sommati.
