# 🚨 UNA RIGA CHE SCRIVE E COMPILA DENTRO IL TERMINALE CON 40 SEDIE VIVE

**Trovata l'11/09** dal cancello, appena gli è stato dato il modo per leggere i
`.md` — cioè **appena ha potuto guardare dove prima era cieco**.

---

## 1. 🎯 IL FATTO

`backtest_pipeline/righe/RIGA_POSTNEWS_ECBFOMC_VERIFICA_DA_MANDARE.md` **r.136**:

```
& $p -Pin $pin -SoloControllo -Terminale 'C:\Program Files\BCM Markets MT5 Terminal'
```

👉 Quella cartella è il **conto piccolo 50503392**, dove il censimento del runner
di stanotte conta **40 sedie attaccate e vive**.

## 2. 🔴 E `-SoloControllo` NON vuol dire "non scrive"

È la trappola, ed è scritta nello script stesso (r.205):

> `[switch]$SoloControllo,   # NON apre MT5: scarica, gatta, **compila, scrive** e verifica gli .ini`

**Cosa fa davvero, verificato riga per riga nel sorgente:**

| riga | operazione |
|---|---|
| 389 | `Copy-Item` — fa il **backup** del file di destinazione |
| 392 | `Set-Content` — scrive una **sentinella** con l'elenco dei backup |
| **393** | `Copy-Item` — 🔴 **installa un sorgente DENTRO la cartella del terminale** |
| 493 | 🔴 **UNA COMPILAZIONE con `metaeditor64` diretto** |
| 497-498 | `Remove-Item` — cancella l'`.ex5` e il log |
| 708-716 | rimette com'era e toglie la sentinella |

🎯 **Non è una lettura: è un'installazione + una compilazione + un ripristino,
dentro la cartella di un terminale che ha 40 sedie in forward.**

## 3. ⚖️ LA LETTURA ONESTA — non è "qualcuno ha fatto una cosa folle"

- ✅ **Lo script è fatto con cura**: backup prima di scrivere, **sentinella su
  file** per poter rimettere a posto anche dopo un'interruzione, ripristino in
  fondo, e una guardia che pretende **MT5 e MetaEditor CHIUSI**.
- ✅ **E il bersaglio ha una ragione**: le sedie `PostNews` **vivono davvero su
  quel terminale**. Verificarle altrove non avrebbe senso.
- 🔴 **Ma il rischio residuo è reale e non dipende dalla cura**: se il giro si
  interrompe **fra la riga 393 e il ripristino** — corrente, riavvio, console
  chiusa — nella cartella del terminale con le sedie vive resta **un sorgente
  che non è il suo**, più una sentinella. E la compilazione di riga 493 gira
  **su quell'albero**.

> ### 📌 Il difetto pagato il 10/09 era della stessa famiglia: `ChiudiMT5Pulito` ammazzava **ogni** `terminal64` della macchina, **reale compreso**. Anche quello era scritto con cura. **La cura non è una protezione: la protezione è non puntare lì.**

## 4. 🔍 PERCHÉ NON ERA STATA VISTA PRIMA

Il file è passato **cinque volte** dal verificatore (la storia dei commit lo
mostra: *"7 difetti trovati"*, *"fix classe 119"*, due ri-pin…). 🔴 **Nessuno di
quei giri ha visto questo**, perché il cancello deterministico **non aveva un
modo per i `.md`**: leggeva solo righe nude e `.ps1`.

👉 **Il modo `md` è stato aggiunto oggi, e al primo giro ha trovato questo.**
🎯 **Non è che il controllo fosse debole: è che quel documento non era mai stato
guardato da nessun controllo.**

## 5. 🛑 COSA FACCIO E COSA NON FACCIO

- ✅ **Non tocco la riga.** Non è mia, ed è un documento di consegna: correggerla
  in fretta è il modo migliore per romperla.
- 🔴 **La dichiaro BLOCCATA**: oggi il cancello la ferma (`FAIL`, classe 221), e
  **finché non è rivista non si manda a Claudio**.
- ✍️ **La decisione è di Claudio**, e sono due:
  1. **Si può installare e compilare dentro il terminale delle sedie vive?**
     Se sì, va scritto come **eccezione firmata**, con il perché.
  2. Se no, la verifica va **spostata** sul terminale da backtest
     (**50504400**, `C:\MT5_Backtest`) — ma allora **non verifica più le sedie
     vere**, e questo va detto invece di far finta che sia lo stesso.

## 6. 🪞 E UNA SECONDA, minore, dallo stesso giro
`backtest_pipeline/righe/RIGA_R118_DA_MANDARE.md` r.97: dentro un blocco
PowerShell ci sono **puntini di sospensione non-ASCII**. Su PowerShell 5.1 del
VPS **non si incollano**. Anche questa il modo `md` l'ha vista al primo giro.
