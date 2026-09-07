# 🥇 SONDA TICK SULL'ORO — e un pericolo trovato mettendola in coda

Claudio (07/09 notte): _"metti la sonda tick dell'oro in cima alla coda di domani"_.

---

## 🔴 PRIMA DI TUTTO: **QUESTA SONDA NON PUÒ GIRARE SUL VPS**

`backtest_pipeline/scarica_storico.ps1`, **riga 413**:

```powershell
Get-Process -Name "terminal64" -ErrorAction SilentlyContinue | Stop-Process -Force
```

E la riga 34 dichiara: `-Auto ... richiede MT5 CHIUSO`.

> ### ⚠️ **Quello script AMMAZZA TUTTI I TERMINALI MT5 DELLA MACCHINA.**
> Sul VPS girano **tre terminali con posizioni aperte**, di cui uno con **soldi
> veri** (10105439). Lanciarla lì significherebbe **chiudere il terminale del
> conto reale mentre ha posizioni vive**.

**Non è teorico: è una riga di codice, e l'ho letta.** È esattamente il tipo di
cosa che ho scoperto perché sono andato a guardare invece di dare per scontato
che "una misura è innocua".

## ✅ E il cancello del runner l'avrebbe fermata da solo

Se qualcuno avesse messo questa riga nella coda del runner, **G2 l'avrebbe
rifiutata**: `Stop-Process` e `terminal64.exe` sono **due dei 24 divieti**, e la
scansione li cerca riga per riga.

👉 Il perimetro firmato ieri sera **ha appena dimostrato di servire, su un caso
vero e non inventato**. Non era teatro.

---

## 📍 DOVE VA, ALLORA — e "coda" va disambiguato

Ho usato la parola *"coda"* in due sensi, ed è colpa mia. Sono due cose diverse:

| coda | chi la esegue | cosa può fare |
|---|---|---|
| **CODA del runner** (`coda/CODA.txt`) | il VPS, da solo, alle 03:30 | **SOLA LETTURA.** Non può pilotare MT5 |
| **CODA delle stringhe** | Claudio, a mano | tutto il resto, MT5 compreso |

👉 **La sonda tick dell'oro sta nella SECONDA.** È una stringa da lanciare a
mano, e **non sul VPS**.

### I due posti dove può girare
1. 🟢 **Il PC di backtest** — è il posto di sempre, e lì i terminali non hanno
   posizioni vive da proteggere. **È la strada per domani.**
2. 🟡 **Il quarto MT5 sul VPS** (`50504400`, `C:\MT5_Backtest`) — sarebbe il
   posto giusto in prospettiva, **ma solo dopo** che lo script ha imparato a
   chiudere *quel* terminale e **non gli altri tre**. Oggi non lo sa fare: la
   riga 413 è indiscriminata. **È un lavoro da fare, non una scorciatoia.**

---

## 🧾 LA RIGA, quando si lancia sul PC di backtest

Stessa forma delle tre già fatte (D30EUR, NASUSD, U30USD), pin `5fa4445e…`:

```
-Simboli 'XAUUSD' -Da '2022.01.01' -Timeframes 'M1,M5' -TimeoutMin 240 -Auto
```

> ### 🔴 GLI APICI SONO OBBLIGATORI — classe 65, già pagata il 07/09
> Senza, PowerShell lega `M1,M5` come **array** e allo script arriva `"M1 M5"`
> (con lo spazio). Il `.mq5` splitta **solo sulla virgola** → nessun timeframe
> riconosciuto → **zero righe di barre** nel CSV, mentre la riga TICK (che sta
> fuori dal ciclo) **viene scritta lo stesso e il referto esce VERDE**.
> Un referto verde su una misura mai fatta.

## 🎯 PERCHÉ VALE LA PENA
Finché non gira, **nessun round sull'oro può dare un verdetto di merito**: solo
screening a OHLC (regola F6 di casa). Sono pochi minuti di macchina e sbloccano
un fronte intero — quello che Claudio ha messo fra le sue due priorità.
