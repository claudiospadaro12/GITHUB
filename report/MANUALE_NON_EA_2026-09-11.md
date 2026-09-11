# 🎯 "ESEGUITO MANUALE, NON CON EA" — e la precisazione **cambia la domanda**

**Claudio (11/09).** Ha ragione, e non è un dettaglio: **cambia quale manopola
dobbiamo guardare.**

---

## 🔴 IL DISACCORDO, adesso è NETTO e MISURABILE

| | ora **server** | = italiane | |
|---|---|---|---|
| l'EA **piazza** i pendenti sui livelli notturni | 07:59 | 08:59 | |
| 🔴 **l'EA li CANCELLA** (preset vivo) | **08:30** | **09:30** | *"solo la rottura fresca dell'apertura"* |
| il massimo mai provato in archivio | 09:30 | 10:30 | |
| 🧑 **il TUO ingresso di oggi** | **15:36** | **16:36** | **7h 06min dopo il cutoff** |
| l'EA chiude tutto | 17:30 | 18:30 | |

> ## 🔴 **Fra quando l'EA butta via i livelli e quando chiude la giornata ci sono NOVE ORE. Non sono mai state aperte.**
> `InpEntryCutoffHour` ha **due soli valori** in **486 righe** di archivio: **8 e
> 9**. Mosso di **un'ora**, mai di più.

## 🎯 E QUESTA È UNA VERA DISPUTA, non una svista
- 🤖 **L'EA dice**: *"solo la rottura **fresca** dell'apertura"* — è una scelta
  **deliberata e scritta** nel commento del codice.
- 🧑 **La tua pratica dice**: *il livello della notte funziona ancora **sette ore
  dopo***. E oggi ha funzionato: **+3.993,83 €**.

👉 **Uno dei due ha torto, e si può misurare con UN input.**

---

## ⚠️ MA NON È GRATIS, e lo dico prima
Allungare il cutoff vuol dire lasciare **un pendente vivo tutto il giorno**.
Conseguenze attese, da scrivere prima dei numeri:
- 🟢 **più operazioni** (e la frequenza è il nostro requisito n.1);
- 🔴 **più rotture stantie**: alle 16:00 il livello della notte ha già preso
  tutto il giorno di notizie addosso;
- 🔴 e il rischio resta aperto per ore invece che per minuti — **che tocca il
  cap C1** sul rischio simultaneo.

📌 **E una cosa che nessuno ha mai provato**: `InpOneTradePerDay` vale **1** in
**tutte e 486** le righe. Il commento dell'EA dice che `false` *"riproduce la
v1.10 esatta, per il confronto"* — **quel confronto non è mai stato fatto.**

---

## 🔑 E LA DIFFERENZA CHE LA TUA PRECISAZIONE RENDE CHIARA
Da te va preso **il LIVELLO** (meccanico, si scrive in codice: max/min del box
notturno) — **non il MOMENTO** (discrezionale: guardi il grafico e decidi).

🎯 **La domanda giusta allora non è "a che ora entrare", ma:**
> ### *"Per quante ore dopo l'alba il livello della notte conserva valore?"*

E quella si misura: **`InpEntryCutoffHour` da 8 a 17, un asse solo.**
Se il valore decade dopo un'ora, l'EA ha ragione e la tua è stata fortuna.
Se regge fino al pomeriggio, **abbiamo buttato via nove ore di occasioni su una
sedia viva.**
