# 🖥️🖥️ SONO **DUE MACCHINE**, E NE AVEVAMO CENSITA UNA SOLA

**12/09/2026.** Claudio manda lo screenshot di "Programmi e funzionalita'":
*"PEPPERSTONE E' INSTALLATO SUL DESKTOP. TICKMILL NON LO VEDO"*, e poi chiarisce:
*"QUESTA MACCHINA E' IL PC DESKTOP"*.

## 🎯 LA RISPOSTA ERA GIA' SUL DISCO (e non l'avevo cercata)

Non serviva nessuna riga nuova: **`CODA_04` stampa il nome della macchina da
cinque notti.** Referto del 12/09, 03:30:

```
nome macchina: VMI3047753   utente: Administrator
    CPU: AMD EPYC Processor (with IBPB)
    core fisici: 6   processori logici: 6
    RAM totale: 11.99 GB
    C:  totale 199.7 GB
```

👉 **`VMI3047753`, AMD EPYC, 6 core, 12 GB: quella e' il VPS.** Quindi tutti i
censimenti `CODA_*` — le 6 cartelle dati, le 49 sedie, i conti, lo slippage —
descrivono il **VPS**. 🔴 **Il PC desktop non l'abbiamo MAI censito.**

📌 Regola del 10/09 applicata e pagata: *"prima si cerca il file che ha gia' la
risposta"*. Stavo scrivendo uno strumento per misurare una cosa **che era in un
log committato nel repo**.

## 🟢 CLAUDIO HA RAGIONE, E I DUE FATTI NON SI CONTRADDICONO

| | PC desktop (screenshot) | VPS `VMI3047753` (misurato) |
|---|---|---|
| BCM Markets MT5 Terminal | ✅ 1 voce, 07/09 | ✅ **quattro** terminali |
| **Pepperstone MT5** | ✅ installato **14/08** | ✅ `73B7A242…`, **0,12 GB** |
| **Tickmill Europe MT5** | ❌ **non c'e'** | ✅ `857385E4…`, **12,08 GB** |
| 🆕 **FTMO Global Markets MT5** | ✅ installato **27/08** | ❌ non fra le 6 identificate |

🟢 *"Tickmill non lo vedo"* e' **giusto**: Tickmill sta sul **VPS**.
🟢 **Pepperstone esiste in DUE copie**, una per macchina.
🔴 **Il terminale FTMO sta sul PC desktop** ed e' la cosa nuova piu' grossa:
nel repo FTMO compare **206 volte**, sempre come **prop firm** (`METRO_PROP.md`),
**mai come terminale installato**. A 19 giorni dalla challenge, non e' un
dettaglio.

## 🪪 CONSEGUENZA OPERATIVA CHE CAMBIA LA RISPOSTA

**`BREAKOUT_EA_JPY_v3.mq5` (v3.00, 1016 righe, assente dal repo) sta sul
Tickmill del VPS**, non sul PC desktop. Quindi:

- ✅ **Disinstallare Pepperstone dal PC desktop NON lo perde.** Quel sorgente
  non e' su questa macchina.
- 🔴 **E la riga di salvataggio va lanciata SUL VPS, non sul PC desktop.**
  L'avevo scritta senza saperlo: avrebbe girato sulla macchina sbagliata e
  avrebbe stampato *"NON INSTALLATO"* su Tickmill. Difetto trovato **prima** di
  consegnarla, ma trovato per fortuna di un referto, non per metodo.

## 🔴 E UN NUMERO DI CASA CHE ERA SBAGLIATO: **non SEI, OTTO**

`report/EXPORTER_SUL_REALE_2026-09-11.md` dice *"Sul VPS ci sono **SEI**
cartelle dati MT5 (misurato stanotte)"*. **Falso.** Incrociando `CODA_04`
(che le pesa tutte) con `CODA_03` (che le identifica dai giornali):

| cartella dati | peso | identificata |
|---|---:|---|
| `215D85D7…` | **20,61 GB** | BCM Markets MT5 Terminal — 50503392 |
| `857385E4…` | **12,08 GB** | **Tickmill Europe MT5** |
| `BCA8AD18…` | 7,56 GB | BCM `-V3` — 50504263 |
| `04C7A32B…` | 1,82 GB | `C:\MT5_Backtest` — 50504400 |
| `E23E1504…` | 0,24 GB | `C:\BCM_Reale` — 10105439 |
| `73B7A242…` | 0,12 GB | Pepperstone |
| 🔴 `15BEB048…` | 0,07 GB | **MAI IDENTIFICATA** |
| 🔴 `FF5C0E29…` | 0,00 GB | **MAI IDENTIFICATA** |

**OTTO esistono, SEI sono identificate.** `CODA_03` scrive *"cartelle dati: 6"*
perche' conta quelle di cui **sa dire il programma** — ed e' corretto lui: sono
io che ho riportato il numero delle **identificate** come numero delle
**esistenti**.

🔑 **Ed e' la stessa classe di errore che avevo appena messo per iscritto**:
`CODA_03` dice, su Pepperstone e Tickmill, *"CONTO: NON TROVATO nei giornali
recenti (**non vuol dire che non ci sia**)"* — la cautela era **scritta nel
referto**, e l'ho ignorata scrivendo un totale. Il conteggio l'ho rifatto **a
macchina** (incrocio dei due log), non a occhio.

## ⚖️ COSA NE SEGUE, SEDIA PER SEDIA

1. 🖊️ **PC desktop — Pepperstone: rischio BASSO ma NON MISURATO.** Nessuna
   nostra misura e' mai venuta da quella macchina. "Basso" e' un'inferenza:
   un censimento di sola lettura (1 minuto) la fa diventare un fatto.
2. 🔴 **PC desktop — il terminale FTMO: da guardare PRIMA.** 27/08, mai visto
   da noi, e l'11/09 e' emerso un **conto da 109k** di cui non conosciamo il
   broker. Non dico che sia quello: dico che **non lo sappiamo** e costa un
   minuto saperlo.
3. 🔴 **VPS — Tickmill: NON si disinstalla adesso.** Tre ragioni misurate:
   `BREAKOUT_EA_JPY_v3` che non esiste altrove · **12,08 GB** di storico, la
   seconda cartella piu' grossa della macchina · **2 sedie agganciate**. Ed e'
   l'unica fonte non-BCM di storico per la **prova di regime**
   (Emendamento C): `prepara_broker_esterno.ps1` esiste per quello.
4. 🟠 **VPS — le due cartelle non identificate** (`15BEB048`, `FF5C0E29`):
   vanno chiuse. Sono piccole, quindi probabilmente terminali aperti e mai
   usati — **probabilmente non e' una misura.**

## 🧰 LO STRUMENTO, E DOVE VA

`backtest_pipeline/righe/RIGA_CENSIMENTO_MT5_MACCHINA.ps1` (pin
`05b8075a…`) resta valido e serve **piu' di prima**: stampa
`COMPUTERNAME`, trova i `terminal64.exe` **dal disco** (il Pannello di
controllo non vede copie e portable: mostra **un** BCM su **quattro**), ed
elenca **tutte** le cartelle dati — comprese quelle **senza `origin.txt`**,
cioe' proprio le due che `CODA_03` non identifica.

🖥️ **Va lanciato DUE volte: una sul PC desktop, una sul VPS.** Sono due
macchine, due censimenti — e il PC desktop e' **terra vergine**.
