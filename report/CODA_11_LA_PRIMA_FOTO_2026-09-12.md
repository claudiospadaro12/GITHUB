# 👁️ LA PRIMA FOTO DEL CANALE — e ha trovato subito una cosa grossa

> `CODA_11` e' entrata in coda stanotte e **ha girato alle 03:31**. Prima
> notte, e non ha fotografato: ha **trovato**.
> Fonte: `backtest_pipeline/coda/referti/CODA_11_canali_e_attivita_20260912_033002.log`

---

## 1. 🔴 IL TASK DELLE 07:20 GIRA UNA COPIA CONGELATA DI UN ALTRO BRANCH

Il comando vero dell'attivita' `ABTG_AggiornaNews`, letto dal registro:

```
powershell.exe -NoProfile -ExecutionPolicy Bypass -File
"C:\Users\Administrator\Desktop\GITHUB-claude-creating-agents-SgGpD (1)\
 GITHUB-claude-creating-agents-SgGpD\backtest_pipeline\aggiorna_news.ps1"
```

Tre cose, tutte e tre verificate:
1. 🔴 **non parte da `C:\ABTG`** e **non parte dal repo di lavoro**: parte da una
   cartella sul **Desktop**;
2. 🔴 quella cartella e' una copia del branch **`claude/creating-agents-SgGpD`**
   — che esiste ancora sul remoto, **ma non e' `lavoro`**;
3. 🔴 il `(1)` nel nome e' la firma di uno **zip scaricato due volte**: e' una
   copia **congelata**, non un clone che si aggiorna.

> ## 👉 QUINDI LE MIE RIPARAZIONI DI STANOTTE A `aggiorna_news.ps1` **NON ARRIVANO A QUELLO CHE GIRA.**
> Il download in due tempi, la validazione, il log datato, la guardia sul
> bersaglio: tutto su `lavoro`. **Alle 07:20 parte un'altra cosa.**

📌 **Ed e' la lezione della classe 251 portata fino in fondo**: avevamo capito
che il canale delle attivita' pianificate non era vagliato. Mancava il pezzo
peggiore — **non e' nemmeno lo stesso codice**. Riparare il file nel repo era
**necessario e non sufficiente**, e senza questa foto non lo avremmo saputo.

### 🧭 E la radice dell'equivoco era scritta in casa
`CLAUDE.md` r.353 diceva ancora *"Sviluppo sul branch
`claude/creating-agents-SgGpD`"*, mentre la **Regola #1**, dieci righe sopra,
dice che il branch di lavoro e' **`lavoro`**. Due righe dello stesso file che
dicono due branch diversi. **Corretta oggi.**

---

## 2. 📋 LE ATTIVITA' VERE — e tre non le sapevamo

| attivita' | quando | da dove parte |
|---|---|---|
| `ABTG_Runner` | 03:30 | `C:\ABTG\runner_abtg.ps1` |
| **`ABTG_AggiornaNews`** | 07:20 | 🔴 **Desktop, branch vecchio** |
| **`ABTG_PubblicaTrades`** | 22:45 | `C:\ABTG\pubblica_trades.ps1` |
| **`ABTG_ScaricaPagella`** | 23:15 | `C:\ABTG\scarica_pagella.ps1` |
| `ReportMercatoGiornaliero` | 07:00 | `C:\report_scheduler\trigger_report.ps1` |
| `ReportSettimanaleTrading` | sab. 09:00 | `C:\report_scheduler\trigger_weekly.ps1` |

🆕 **`ABTG_PubblicaTrades` e `ABTG_ScaricaPagella` non erano nel mio elenco**:
la riga le ha marcate *"ATTIVITA' NUOVA, non nell'elenco di casa"* — che e'
esattamente il lavoro che doveva fare (classe 180: si elenca per nome, **e si
stampa comunque tutto**, se no una attivita' nuova resta fuori dall'elenco e
nessuno la vede).
📌 E `ABTG_Pagella`, che io mi aspettavo, **non esiste**: si chiama
`ABTG_ScaricaPagella`. Il mio elenco era sbagliato in due direzioni.

🗂️ **E i posti da cui parte il codice sono TRE, non uno**: `C:\ABTG`, il
Desktop, e `C:\report_scheduler`.

---

## 3. 🔑 L'IMPRONTA DEL RUNNER — il primo caposaldo

```
file       : C:\ABTG\runner_abtg.ps1
byte       : 18.605
modificato : 2026-09-07 22:59:19
SHA-256    : 74BD28846444F215EB38463239D3C32D3C87F0F4EF4795A285E1FCB83A603C86
marcatore v3 presente: False
```

🟢 **Conferma misurata di quello che il pacchetto diceva**: sul VPS gira la
**v2**. La v3 nel repo ha impronta `21AC6672…` ed e' dell'11/09.
👉 Da stanotte quel numero e' un **caposaldo**: se cambia senza un pacchetto
firmato, **quella riga e' la prova che qualcuno ha cambiato il codice che gira
da solo alle 03:30.**

---

## 4. ✅ E IL PACCHETTO AVEVA RAGIONE ANCHE SULL'ALTRA META'

Il referto del runner di stanotte, riga per riga:
- `marcatore : MARCATORE_RUNNER_ABTG_v2` · `righe di coda: 15`
- le **4 righe di round**: `RIFIUTATO -- G1: manca il marcatore
  'RUNNER_SOLA_LETTURA'`

🟢 **Esattamente il comportamento previsto e scritto nel pacchetto**: *"col
runner v2 vengono rifiutate al primo cancello: nessun round parte, nessun
terminale viene toccato, e il referto lo dice a chiare lettere. Lasciarle in
coda NON fa danno anche se l'installazione slitta."*
👉 **La previsione era giusta al carattere. L'ordine sbagliato costa una
notte, non un danno.**

---

## 5. 🧭 COSA CAMBIA, IN CONCRETO

1. 🔴 **`aggiorna_news.ps1` va fatto partire dal posto giusto.** Riparare il
   file nel repo non basta: finche' il task punta al Desktop, alle 07:20 gira
   la copia vecchia. **E' una decisione operativa sul VPS, quindi va chiesta.**
2. 🟡 Le altre due attivita' nuove (`PubblicaTrades`, `ScaricaPagella`) partono
   da `C:\ABTG`: **da leggere**, non ancora lette.
3. 🟢 Il caposaldo dell'impronta del runner e' preso. Dalla prossima notte il
   confronto e' un **diff**, non una lettura.

*Tutto in sola lettura, dal referto che il runner ha pubblicato da solo.*
