# 🟢 PASSO 5 CHIUSO — storico sul quarto MT5, e il conto reale **non è stato sfiorato**

Lanciato da Claudio sul VPS l'08/09/2026. **Tutto verde.**

---

## 🛡️ PRIMA DI TUTTO: LA PROVA CHE CONTA

Lo script che fino a stamattina **ammazzava tutti i terminali** ha stampato, sul
campo, questo:

```
BERSAGLIO (terminale da backtest, l'unico che posso chiudere):
    PID 7604    C:\MT5_Backtest\terminal64.exe
LASCIATI VIVI (forward e conto reale: NON li tocco):
    PID 7824    C:\BCM_Reale\terminal64.exe
    PID 8664    C:\Program Files\BCM Markets MT5 Terminal -V3\terminal64.exe
    PID 9780    C:\Program Files\BCM Markets MT5 Terminal\terminal64.exe
...
--- PROVA, DOPO LA CHIUSURA ---
ancora vivi (attesi: gli altri terminali, intatti):
    PID 7824 . PID 8664 . PID 9780
```

> ### 🎯 **Stessi tre PID prima e dopo.** Il terminale del conto reale, con
> posizioni aperte, non è stato toccato — **e non è una promessa: è stampato.**

E il terminale scelto lo dice da solo: `via: parametro esplicito
-TerminaleBacktest`. 👉 **Anche il passo 6 è confermato sul campo**, non solo
nel parser.

---

## 📊 LO STORICO — **COMPLETO su tutte e sei le righe**

| simbolo | TF | barre | prima data | verdetto |
|---|---|---:|---|---|
| **D30EUR** | M1 | **643.567** | 2024.09.26 | 🟢 COMPLETO |
| **D30EUR** | M5 | **129.930** | 2024.09.26 | 🟢 COMPLETO |
| **D30EUR** | **TICK** | **35.496.307** | 2024.09.26 | 🟢 COMPLETO |
| **U30USD** | M1 | **668.718** | 2024.09.26 | 🟢 COMPLETO |
| **U30USD** | M5 | **133.819** | 2024.09.26 | 🟢 COMPLETO |
| **U30USD** | **TICK** | **68.558.736** | 2024.09.26 | 🟢 COMPLETO |

**104 milioni di tick** sul terminale nuovo. La macchina da backtest ha i dati.

📌 E il muro dello storico è **riconfermato con una misura fresca**:
**2024.09.26** su tutti e due gli indici, sia in barre sia in tick. Non è
un'abitudine dei file prova: **è il dato del broker.**

---

## 🔴 UN OSTACOLO SULLA STRADA DEL PASSO 7 — trovato leggendo i numeri

**D30EUR M5 = 129.930 barre. U30USD M5 = 133.819.** Tutte e due **sopra
130.000**, cioè **sopra il tetto di 100.000 barre** che MT5 applica di default
al grafico (`Strumenti → Opzioni → Grafici → Massimo barre nel grafico`).

⚠️ **Perché conta ADESSO e non dopo**: se il terminale nuovo ha il valore di
default e il PC di backtest aveva "Illimitato", il round dell'ancora **girerebbe
su meno storico** — e uscirebbe **un numero diverso**. A quel punto penseremmo
*"la macchina nuova non riproduce"* quando invece **è solo un'impostazione**.

> ### 🎯 È esattamente il tipo di differenza che si scopre DOPO aver perso una
> giornata a cercarla nel posto sbagliato. Si controlla prima, costa 20 secondi.

**Va messo su `Illimitato` sul terminale `C:\MT5_Backtest` (conto 50504400)
prima di lanciare l'ancora.**

---

## ✅ DOVE SIAMO SULLA CATENA DEL QUARTO MT5

| passo | stato |
|---|---|
| 1-3 conto nuovo, HEDGING, zero EA | ✅ |
| 4 agenti del tester a 3 | ✅ (da confermare su quale terminale) |
| **5 storico** | ✅ **CHIUSO OGGI — 104 milioni di tick** |
| **6 driver `-TerminaleBacktest`** | ✅ **confermato sul campo** |
| **7 ancora R119** | 🟡 **il prossimo**, dopo il tetto delle barre |
| 8 canarino sul forward | ⏳ dopo la prima notte |

**L'ancora deve ridare, alla cifra:**
`770611` OOS **2484,17 / PF 1,67490 / DD 6,5389% / 119 trade**
`770101` OOS **1103,31 / PF 1,41105 / DD 4,3501% / 270 trade**
