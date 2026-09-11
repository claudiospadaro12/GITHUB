# 📋 RESOCONTO DEL PROGETTO — venerdì 11/09/2026, ore 21:00

*(Il netto del giorno sugli EA lo fa la **pagella delle 23:00** in `report/giornata_2026-09-11.md`.
Questo è il punto sul **progetto**.)*

---

# 🤖 1. COSA HA FATTO LA MACCHINA DA SOLA

## 🌙 Il runner notturno — **10 su 10, esito COMPLETO**
`coda/referti/REFERTO_RUNNER_20260911_033002.txt` `[MISURATO]`:
**10 righe in coda · 10 eseguite · 0 rifiutate · 0 fallite · tutte uscita 0.**

## 🆕 E IL REFERTO HA DENTRO UNA COSA CHE NON SAPEVAMO

> ### 🔴 **Sul VPS ci sono SEI installazioni MT5, non tre.**

`CODA_03_conti_dei_terminali` le ha lette **dai giornali dei terminali**, non da
una tabella scritta a mano:

| cartella programma | conto | note |
|---|---|---|
| `C:\MT5_Backtest` | **50504400** | il banco |
| `C:\Program Files\BCM Markets MT5 Terminal` | **50503392** | il piccolo |
| `C:\Program Files\BCM Markets MT5 Terminal -V3` | **50504263** | il 100k |
| `C:\BCM_Reale` | **10105439** | il reale |
| 🆕 **`C:\Program Files\Pepperstone MetaTrader 5`** | **NON TROVATO** | 🔴 azienda: **`PepperstoneUK-Live`** |
| 🆕 **`C:\Program Files\Tickmill Europe MT5 Terminal`** | **NON TROVATO** | 🔴 |

🔴 **Due broker che non sono in nessuna nostra mappa**, e uno dice **`Live`**.
E oggi è saltato fuori un **conto da 109k** che non conoscevo: **potrebbe essere
uno di questi due.**

📌 **La REGOLA DEI TERMINALI MULTIPLI parla di TRE terminali.** È nata da un
incidente vero (06/09: un EA destinato al demo stava per finire sul reale).
👉 **Una regola di sicurezza che descrive metà della macchina protegge a metà.**
E il dato era **già nei referti**: la macchina l'aveva misurato, **nessuno
l'aveva letto**.

## 🪑 Le sedie in campo
`CODA_08` `[MISURATO]`: **49 sedie stampate** — 40 sul piccolo, 7 e 2 sugli
altri. **Due terminali con ZERO EA sopra.**

## 📉 Lo slippage sul reale: **ancora niente**
`CODA_10` ha guardato in **cinque** cartelle dati: *"MQL5\Files c'è, **nessun
file `ABTG_Slippage*` dentro**"*. 🔴 **Il ledger non esiste su nessuno.**
*(La lista non include `C:\BCM_Reale`: il cancello vieta agli script di coda di
nominarlo, ed è voluto.)*

## 🔎 La caccia automatica
Un dossier nuovo: `CACCIA_FORMA_UTILE_2026-09-11.md`. Esito già registrato:
**1.079 titoli censiti, 16 sorgenti letti, ZERO promossi.**

---

# 💶 2. IL CONTO

| | |
|---|---|
| 💰 **conto 109k di Claudio** (manuale, **nessun EA sopra**) | 🟢 **+5.957,29 € = +5,47% oggi** — 3 operazioni, conto verificato al centesimo |
| 📊 il netto sugli EA | → **pagella delle 23:00** |
| 📉 slippage sul reale | 🔴 **NON MISURATO**, nessun ledger da nessuna parte |
| 🏁 round girati oggi | 🔴 **ZERO**. Il perimetro è firmato, ma **nessun round è ancora partito** |

🔴 **E il numero che pesa sul 109k**: la somma dei **movimenti in dollari** delle
5 operazioni degli ultimi 3 giorni è **−31,23**. Il guadagno viene **dalla
taglia**, non dalle letture. Almeno una posizione **non aveva un limite
automatico**: quella perdita l'ha fermata Claudio guardando lo schermo.

---

# 🔬 3. COSA HO DECISO IO

| # | decisione | il numero che la giustifica |
|---|---|---|
| 1 | 🛑 **Ritirata la raccomandazione** di ridurre la taglia della `770101` | separando la colonna `strategy`: **ROTTURA −482 punti** (spenta dal 14/08) contro **RETEST +176** (viva). La perdita era della configurazione morta |
| 2 | 🛑 **Ritirata la firma** sulla geometria OPPRANGE `770611` | è un **picco**: massimo su 4 metriche e minimo sul DD, **vicini che crollano da entrambe le parti** |
| 3 | 🛑 **Bocciato** il ritrovamento "più promettente" del giorno (R118c) | PF OOS **1,4382** ma **in campione 1,0077 con n=109**, e IS/OOS si muovono in **direzioni opposte** |
| 4 | 🏗️ **Cancello positivo** invece di allungare la lista dei divieti | e **ha pagato oggi stesso**: quando è saltato fuori il quarto conto, il cancello positivo l'ha **rifiutato per difetto** |
| 5 | 🌙 **Prima notte: UN solo round** (`r125d`, ~0,4 min) | *se va storto si perde un round, non una flotta*. Ed è **auto-diagnostico**: due celle gemelle per costruzione |
| 6 | 🔓 **Riparati tre gemelli** della guardia sul terminale | il **piccolo 50503392 con le sedie vive**, la radice di un disco, i nomi 8.3 e la fuga col `..\` **passavano tutti** |

## ❌ E GLI ERRORI MIEI DI OGGI — otto, tutti corretti col numero
`"le manopole non sono mai state messe ad asse"` (erano 6 su 17) · `"49 celle"`
(erano 30) · `"il trailing taglia i vincitori"` (mai successo sulla viva) ·
`"72% del pavimento"` (veniva da **n=2**; il vero è 43,8×) · `"graffe
sbilanciate"` (stavano dentro stringhe) · il **pin sbagliato** dato al cancello
(il ri-pin era al commit **successivo**) · il **canarino di R131 rovesciato**
(il filtro è un **veto** su una sedia **long-only**: `Trades` **cresce**, non
cala) · e l'ipotesi dei **numeri tondi** sui livelli, chiusa dal suo screenshot.

🔴 **Sei di questi otto li ha trovati il cancello o un agente, non io.**
🟢 **E zero sono arrivati in campo**: nessun preset vivo modificato, nessun
parametro toccato, nessun conto sfiorato.

---

# ⚠️ 4. COSA ASPETTA CLAUDIO

## 🔴 Tre risposte, **gratis** (nessun comando, nessun rischio)
1. **Sul PC di backtest esiste `C:\MT5_Backtest`?** → chiude il buco per cui
   `walkforward`, lanciato a mano senza parametro, sceglie **il piccolo con le
   sedie vive**.
2. 🆕 **Pepperstone e Tickmill sul VPS: cosa sono? Il 109k è lì?** → serve per
   la mappa dei terminali, che è una **regola di sicurezza**.
3. **Su quale conto andrebbe il cambio della `770611`?** Due documenti si
   contraddicono.

## 🖥️ E il pacchetto VPS, **col PASS del cancello**
Tre passi separati, il primo è **sola lettura**: collaudo a secco → aggiornare
il runner (**sul VPS gira ancora la v2**) → **una** riga di R125.
**Pronto in `report/PACCHETTO_VPS_2026-09-11.md`, con il modo di annullare ogni passo.**

## ⛔ Niente che tocchi il conto reale, le taglie o i soldi.

---

# 🎯 5. DOMANI

1. 🥇 **Far girare il primo round in assoluto** — `r125d`, 24 secondi di
   macchina. È la prima misura di una casella oggi vuota.
2. 🔬 Leggere il ritorno di **MaxMin `end=6` vs `end=4`** (in corso).
3. 🗺️ **Riscrivere la mappa dei terminali** con sei voci e i due broker nuovi.
4. 🔧 Chiudere il conflitto **`R130a` vs l'ancora R120** sul Guardian, prima
   che uno dei due round giri.

---

## 🧭 LA BUSSOLA, onestamente
🔴 **Oggi non è nata nessuna sedia schierabile. È stata una giornata di
ponteggio**, e va dichiarata così.

🟢 **Ma il ponteggio ha retto tre volte**: ha fermato un picco spacciato per
ritrovamento, un pin sbagliato che avrebbe buttato un round, e un errore di
unità che bruciava **l'80% del rischio in commissioni**.

🔥 **E le due ricerche migliori della giornata non le ho trovate io: sono uscite
da uno screenshot e da una frase di Claudio.**
**92 commit. 45 referti. Zero round girati.** Domani quel numero deve cambiare.
