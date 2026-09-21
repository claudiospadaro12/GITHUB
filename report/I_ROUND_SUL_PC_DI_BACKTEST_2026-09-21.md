# 🖥️ I round sul PC di backtest — la guardia impara a guardare **la macchina**

**21/09/2026** · `backtest_pipeline/righe/RIGA_ROUND_VPS.ps1` **v1 → v2** ·
🚦 **passato dal cancello deterministico, in attesa dell'agente `controllo-preventivo`**
🚫 **Niente è stato mandato a Claudio. Nessun terminale, nessun preset, nessuna sedia è stata toccata.**

---

## 1. 🎯 Il problema, in tre righe

Stamattina, dopo che un backtest a tick reali ha inchiodato il VPS **nella prima mezz'ora
del primo giorno di challenge FTMO**, Claudio ha firmato: **i round girano sul PC di
backtest**. Poi ha scelto: *«Estendo lo script al PC di backtest»*.

🔴 **Ma la firma non era eseguibile.** `RIGA_ROUND_VPS.ps1` v1 **rifiutava per costruzione**
qualunque `-TerminaleBacktest` diverso da `C:\MT5_Backtest`… e quel terminale **sta sul VPS**.
La macchina dei round era **cablata sulla macchina sbagliata**.

---

## 2. 📐 La misura che lo dimostra (non è un'opinione)

| cosa | dove sta scritto | cosa dice |
|---|---|---|
| la v1 ammette **un solo percorso** | `RIGA_ROUND_VPS.ps1` v1, `MotivoRifiutoBanco` → `[string]::Equals($n, $BANCO_PERC, …)` | tutto ciò che non è `C:\MT5_Backtest` muore |
| e quel percorso **è sul VPS** | `report/collaudi/CENSIMENTO_MT5_VPS_2026-09-12_0846.txt` | macchina `VMI3047753`: `C:\MT5_Backtest` = banco `50504400`, **spento**; accanto ci sono il REALE `10105439`, il 100k `50504263`, il piccolo `50503392` |
| il PC di backtest si chiama | `report/DAX_STORICO_APERTO_2026-09-10.md` r.4 · `report/censimento_ordini/riepilogo_DESKTOP-H4D7CAJ.txt` r.1 | **`DESKTOP-H4D7CAJ`**, utente `Master` |
| e il suo terminale è | `report/COME_ALLUNGARE_STORICO_INDICI_2026-09-09.md` r.163 | **`C:\Program Files\BCM Markets MT5 Terminal`** |

✅ **Le due righe che mi erano state date come "da verificare alla fonte" REGGONO**: le ho
riaperte tutte e due e dicono esattamente quello. Non ho trovato di meglio.

### 🔴 E qui sta la difficoltà, che è tutto il lavoro
Quel percorso — `C:\Program Files\BCM Markets MT5 Terminal` — **sul VPS è il PICCOLO
`50503392`**, con sedie vive sopra, ed è in `$TERMINALI_VIETATI` **per un'ottima ragione**.

> **Lo stesso identico testo deve essere AMMESSO su una macchina e VIETATO sull'altra.**
> 👉 **Il discriminante non può essere il percorso: è la MACCHINA.**

---

## 3. 🛠️ Come l'ho fatto

### 3.1 La tabella: **una macchina, un terminale**
```
VMI3047753        -> C:\MT5_Backtest                             (conto 50504400)
DESKTOP-H4D7CAJ   -> C:\Program Files\BCM Markets MT5 Terminal   (conto 50503392)
```
Confronto **ORDINALE** sul nome macchina (`[string]::Equals(…, OrdinalIgnoreCase)`), **come
già si fa sui percorsi e per lo stesso motivo scritto nel file**: il `-eq` di PowerShell passa
dalla **cultura del thread**, e sotto una cultura certi caratteri invisibili vengono *ignorati*
nel confronto — cioè due stringhe **diverse** risultano uguali. `IgnoreCase` sì, perché i nomi
NetBIOS non distinguono maiuscole: `desktop-h4d7caj` **è la stessa macchina**.

### 3.2 🔒 FAIL-CLOSED, senza eccezioni
Macchina non in tabella → **si rifiuta**, stampando **il nome trovato** e **i nomi ammessi**.
Nessun ripiego "se non riconosco, lascio passare". Il messaggio dice anche cosa fare
(*si aggiunge la riga a mano e si ripassa dal cancello*), perché una guardia che dice NO
senza dire "e allora?" costringe chi la incontra a **indovinare**, e chi indovina forza.

### 3.3 🛡️ `$TERMINALI_VIETATI`: **non toccata, ALLARGATA**
- Si consulta **PRIMA** della tabella per macchina **e vince lei**: il REALE `10105439`,
  il 100k `-V3`, la challenge FTMO restano vietati **su qualunque macchina**, anche su una
  che non è in tabella, anche se domani la tabella fosse scritta male.
- 🆕 **Sono entrati `FTMO` / `541452707` e `MT5_MANUALE` / `50503635`**, che nella v1 **non
  erano nominati da nessuna parte**: venivano rifiutati lo stesso dal confronto positivo, ma
  **senza dire CHI erano**. Con sei sedie FTMO vive, il terminale più pericoloso del VPS non
  aveva un nome nella guardia. Adesso ce l'ha. *(Allargare una lista di divieti non la
  indebolisce.)*
- **L'unica deroga** è il percorso del piccolo **sulla sola `DESKTOP-H4D7CAJ`**, e per
  applicarsi servono **tre cose insieme**: la macchina in tabella, il suo flag `deroga`, e il
  percorso che **normalizzato coincide ESATTAMENTE** col bersaglio di quella macchina.
  👉 Per questo **`…MT5 Terminal -V3` (il 100k) resta VIETATO anche lì**: non è lo stesso
  percorso. Nel codice è scritto **perché**, non solo *che*.

### 3.4 🧷 Il guardiano del guardiano (`TabellaCoerente`)
La tabella è scritta a mano, e una tabella scritta a mano si sbaglia. All'avvio, **prima di
toccare qualsiasi cosa**, si controlla che nessuna riga abbia: un doppione di macchina (il
bersaglio dipenderebbe dall'ordine delle righe), un **jolly** (finirebbe nella pipe di
chiusura `$cartellaBT + "\*"` e la allargherebbe), una **radice di disco** (`C:\*` = ogni
`terminal64`, reale compreso), o una forma non canonica.

### 3.5 ⚙️ Il resto, invariato
`NormalizzaPercorsoWin` **non è stata riscritta** (come richiesto): è stata **riusata** e
ri-collaudata. A valle **si usa sempre LA COSTANTE della tabella**, mai la stringa arrivata da
fuori — la riga che impedisce alla pipe di chiusura di diventare `C:\*`. Restano identici:
il gradino **junction/ReparsePoint**, il tetto `MaxBars`, il censimento PID prima/dopo, la
chiusura chirurgica, il controllo del marcatore del driver, la raccolta.

### 3.6 🆕 Due aggiunte che non erano chieste (e perché)
1. **`-TerminaleBacktest` di default è VUOTO**, e vuoto significa *"usa il bersaglio di questa
   macchina"*. Un default **cablato su un percorso** è giusto su una macchina sola e sbagliato
   su tutte le altre — era esattamente il difetto da riparare. Su una macchina sconosciuta
   resta vuoto **apposta**: il vuoto non è un permesso. E il valore risolto **passa comunque
   da tutti i controlli**, come se l'avesse scritto un umano.
2. 🔴 **L'AVVERTENZA sul bersaglio del PC di backtest**, e questa **va letta**:

> Quel terminale **NON è un banco solo-tester** come `C:\MT5_Backtest`. È **loggato sul demo
> piccolo `50503392`**, e il **14/08/2026 da quella macchina sono PARTITI ORDINI VERI**:
> **#3160534 / #3160535 → −104,60** sul piccolo
> (`report/DAX_14-08_DUE_MOTORI.md` r.401; `HANDOFF.md` r.1463; avvertimento già messo agli
> atti in `backtest_pipeline/risultati_archivio/STORICO_INDICI_CRITERI.md` r.187).
> 👉 `-ChiudiBacktest` **là chiude un terminale con un conto vivo dentro**. Lo script adesso lo
> stampa a schermo e lo scrive nel referto — ma **sapere non è controllare**: prima di un round
> lì, **si guarda che non abbia sedie attaccate ai grafici**.

**Scelta dichiarata**: l'avvertenza **non è un `RILIEVO`**. Un rilievo cambia l'esito del round
da `0` a `3` (*GIRATO CON RILIEVI*), e un rilievo che scatta **a ogni singolo round** su quella
macchina addestrerebbe chi legge **a ignorare i rilievi**. Sta a schermo e nel referto, dove si
legge, senza sporcare i codici d'uscita. 🙋 **Se Claudio la vuole bloccante, è una riga.**

---

## 4. 🧪 Le prove — **ESEGUITE**, non ragionate

Banco: **`backtest_pipeline/banco_guardia_macchina.ps1`** (nuovo). Non è una seconda stesura
della guardia: **estrae dal file vero** il blocco fra i marcatori `BLOCCO COLLAUDABILE
OFFLINE: INIZIO/FINE` e lo **esegue così com'è** — se domani qualcuno cambia la guardia, il
banco prova la guardia **nuova**. Conta anche i marcatori (devono comparire **una volta sola**:
è l'errore dell'11/09 che estrasse 9 righe invece di 105 e bocciò tutto).

Eseguito con `pwsh 7.4.6` su questa macchina: **`TUTTI PASSATI: 39 casi su 39`**, uscita `0`.

### 4.1 Le sei prove chieste — uscita vera
```
  gr macchina            bersaglio                                        atteso     esito
  1  'VMI3047753'        'C:\MT5_Backtest'                                AMMESSO    AMMESSO  OK
  2  'VMI3047753'        'C:\Program Files\BCM Markets MT5 Terminal'      RIFIUTATO  RIFIUTATO  OK
       la guardia dice: TERMINALE VIETATO: '...' nomina un terminale con SEDIE VIVE sopra:
                        il piccolo 50503392 (e il 100k, che sta nella stessa famiglia di cartelle).
  3  'DESKTOP-H4D7CAJ'   'C:\Program Files\BCM Markets MT5 Terminal'      AMMESSO    AMMESSO  OK
  4  'DESKTOP-H4D7CAJ'   'C:\MT5_Backtest'                                RIFIUTATO  RIFIUTATO  OK
       la guardia dice: NON E' IL BERSAGLIO DI QUESTA MACCHINA: 'C:\MT5_Backtest'
  5  'VMI3047753'        'C:\BCM_Reale'                                   RIFIUTATO  RIFIUTATO  OK
  5  'DESKTOP-H4D7CAJ'   'C:\BCM_Reale'                                   RIFIUTATO  RIFIUTATO  OK
  5  'PC-SCONOSCIUTO'    'C:\BCM_Reale'                                   RIFIUTATO  RIFIUTATO  OK
       la guardia dice: TERMINALE VIETATO: nomina il terminale del conto REALE 10105439.
  5  'VMI3047753'        'C:\FTMO'                                        RIFIUTATO  RIFIUTATO  OK
  5  'DESKTOP-H4D7CAJ'   'C:\FTMO'                                        RIFIUTATO  RIFIUTATO  OK
  5  'PC-SCONOSCIUTO'    'C:\FTMO'                                        RIFIUTATO  RIFIUTATO  OK
       la guardia dice: TERMINALE VIETATO: nomina il terminale della CHALLENGE FTMO viva,
                        conto 541452707 (C:\FTMO): sei sedie che stanno operando.
  5  'VMI3047753'        '...BCM Markets MT5 Terminal -V3'                RIFIUTATO  RIFIUTATO  OK
  5  'DESKTOP-H4D7CAJ'   '...BCM Markets MT5 Terminal -V3'                RIFIUTATO  RIFIUTATO  OK
  5  'PC-SCONOSCIUTO'    '...BCM Markets MT5 Terminal -V3'                RIFIUTATO  RIFIUTATO  OK
       la guardia dice: TERMINALE VIETATO: nomina il terminale del 100k, conto 50504263.
  6  'PC-SCONOSCIUTO'    'C:\MT5_Backtest'                                RIFIUTATO  RIFIUTATO  OK
  6  'PC-SCONOSCIUTO'    'C:\Program Files\BCM Markets MT5 Terminal'      RIFIUTATO  RIFIUTATO  OK
  6  'PC-SCONOSCIUTO'    'D:\QualunqueCosa'                               RIFIUTATO  RIFIUTATO  OK
  6  ''                  'C:\MT5_Backtest'                                RIFIUTATO  RIFIUTATO  OK
       la guardia dice: MACCHINA SCONOSCIUTA: questa macchina si chiama '...' e NON e'
                        nella tabella dei bersagli.
```
🟢 **I casi 2 e 3 sono la prova del disegno**: **stesso percorso**, esito **opposto**, e la
differenza la fa **solo la macchina**.

### 4.2 🔨 Dove ho provato a romperla (23 casi in più, tutti passati)
| rottura tentata | esito | perché è giusto così |
|---|---|---|
| `'DESKTOP-H4D7CAJ   '` (spazi in coda) | 🟢 AMMESSO | è la stessa macchina: `Trim` |
| `'desktop-h4d7caj'` | 🟢 AMMESSO | i nomi NetBIOS non distinguono le maiuscole |
| `' VMI3047753 '` + piccolo | 🔴 RIFIUTATO | gli spazi **non** fanno perdere il divieto |
| `C:\PROGRA~1\BCMMAR~1` (nome 8.3) | 🔴 RIFIUTATO | non si indovina: espanderlo vuol dire Win32 |
| `C:/Program Files/BCM Markets MT5 Terminal` (`/`) | 🟢 AMMESSO | **stesso posto** scritto in un altro modo |
| `C:\MT5_Backtest\..\Program Files\BCM Markets MT5 Terminal` sul VPS | 🔴 RIFIUTATO | il `..` **porta sul piccolo**: era il buco trovato l'11/09 |
| `…MT5 Terminal -V3\..\BCM Markets MT5 Terminal` sul PC | 🟢 AMMESSO | ⚠️ **nomina il `-V3` ma il `..` ATTERRA sul bersaglio**: è lo stesso posto. A valle si usa **la COSTANTE**, mai questa stringa |
| `…MT5 Terminal\..\BCM Markets MT5 Terminal -V3` sul PC | 🔴 RIFIUTATO | il nome buono **non salva** il posto sbagliato |
| `C:\` (radice) su entrambe | 🔴 RIFIUTATO | la pipe diventerebbe `C:\*` = **ogni** terminal64 |
| `C:\MT5_Back*` (jolly) · `C:MT5_Backtest` · `\\VMI3047753\C$\…` (UNC) | 🔴 RIFIUTATI | forme non riconducibili |
| `c:\mt5_backtest` minuscolo · separatore finale · spazi attorno | 🟢 AMMESSI | su Windows è lo stesso posto |
| `C:\MT5_Backtest\Tester` (sottocartella) · `C:\Users\Master\MT5_Backtest` | 🔴 RIFIUTATI | non è la cartella programma / non è in tabella |
| `C:\MT5_MANUALE` | 🔴 RIFIUTATO | terminale del trading a mano `50503635` |

### 4.3 ✅ E lo script **intero** è stato eseguito, non solo il blocco
Tre corse vere con `$env:COMPUTERNAME` simulato (ogni volta **muore prima** di toccare
processi, perché le cartelle Windows su Linux non esistono — ed è la prova che l'ordine dei
gradini è giusto):
- `PC-SCONOSCIUTO` → `ERRORE: MACCHINA SCONOSCIUTA …` + tabella, **exit 1**;
- `VMI3047753` → risolve `C:\MT5_Backtest`, **bersaglio AMMESSO**, poi `la cartella non esiste`;
- `DESKTOP-H4D7CAJ` → risolve il suo terminale, **bersaglio AMMESSO** + 🟨 **AVVERTENZA**
  stampata, poi `la cartella non esiste`;
- `VMI3047753` **+ `-TerminaleBacktest` del piccolo + `-ChiudiBacktest`** → `TERMINALE
  VIETATO … il piccolo 50503392`, **exit 1**: `-ChiudiBacktest` **non viene mai raggiunto**.

### 4.4 🚦 Cancello deterministico (strato 1)
`python3 backtest_pipeline/controlla_riga.py --ps1 …` su **tutti e due** i file:
**`ESITO: nessun difetto meccanico`, exit 0** — ASCII puro, 0 errori dal parser PowerShell
vero, param block riconosciuto, **nessun costrutto pwsh-7-only** (conta: il VPS ha Windows
PowerShell **5.1**, il banco qui gira su **pwsh 7.4.6**). Gli 8 rilievi sono tutti di
classe 457 (*"nomina un conto dentro una stringa: va letto a mano"*) e sono **la lista dei
vietati e i messaggi della guardia**, cioè esattamente ciò che la classe 457 chiede di
verificare a occhio: **guardie, non bersagli**.

---

## 5. 🔴 IL DIFETTO CHE HO TROVATO STRADA FACENDO, ed è **bloccante**

> ### La firma **non è ancora eseguibile**, e non per colpa di questo file.

`RIGA_ROUND_VPS.ps1` passa il bersaglio al driver (`-TerminaleBacktest $cartellaBT`, r.649
della v1). **E il driver ha una COPIA della vecchia guardia, cablata sul banco del VPS:**

- `backtest_pipeline/walkforward_generico.ps1` **r.1074**: `$BANCO_PERC = "C:\MT5_Backtest"`
- **r.1309**: `$motivoNo = MotivoRifiutoBanco $TerminaleBacktest` → **r.1326**: `$cartellaBT=$BANCO_PERC`

👉 **Un round lanciato su `DESKTOP-H4D7CAJ` supererebbe la mia guardia e morirebbe dentro il
driver** con *"NON E' IL BANCO"*. 🟢 **Fallisce CHIUSO** (non parte, non tocca niente: nessun
pericolo), ma **non gira**.

**Non l'ho toccato, ed è una scelta**: è un secondo file di sicurezza, il blocco è marcato
`GUARDIA_BANCO_POSITIVA_v1` ed è una **copia dichiarata byte-per-byte** condivisa con
`backtest_pipeline/righe/RIGA_SCAN_GESTIONE.ps1` (r.254). Cambiarlo **dentro lo stesso
passaggio** violerebbe *"una modifica logica alla volta"* su codice che decide chi si può
chiudere. 🙋 **Serve una decisione**, e le opzioni sono due:
- **(A)** portare la tabella per macchina **anche nel driver** (e nella copia di
  `RIGA_SCAN_GESTIONE.ps1`) — coerente, ma tocca tre file di sicurezza;
- **(B)** usare `-Terminal`, che **il driver stesso indica** come la porta nata per questo
  (**r.1318**: *"se davvero ti serve un altro terminale … il PC di backtest di casa, usa
  -Terminal, che e' il parametro nato per quello"*) — 🔴 **ma `-Terminal` è dichiarato SENZA GUARDIA** (**r.1308**: *"-Terminal invece
  resta scoperto, ed e' voluto"*), e usarlo dal PC di backtest significherebbe **rinunciare a
  tutto quello che questo lavoro ha appena costruito**. Sconsigliata.

📌 **La mia raccomandazione è (A), come passaggio separato e col suo cancello.**

---

## 6. ⛓️ Le catene che questa modifica rompe (fail-closed, dichiarate)

Il marcatore sale a **`MARCATORE_RIGA_ROUND_VPS_v2`**: chi controlla `_v1` **muore invece di
girare**. È voluto (una copia vecchia non deve passare) ed è un **fallimento sicuro**. Da
aggiornare quando ci si ripassa:

| file | riga | cosa contiene |
|---|---|---|
| `backtest_pipeline/righe/MISURA_LOTTI_U30USD.ps1` | **r.67** | `$MARC_ROUND = 'MARCATORE_RIGA_ROUND_VPS_v1'` |
| `backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1` | **r.1451** | `$MARC_ROUND = "MARCATORE_RIGA_ROUND_VPS_v1"` **+ `$SHA_ROUND`**, che inchioda al byte il file che sto cambiando |
| `backtest_pipeline/controesempi_cancello.py` | **r.43** | stringa `v1` dentro una riga-fixture |

🟢 **Le righe di lancio già pinnate a un COMMIT non si rompono**: scaricano il vecchio blob,
che contiene ancora `_v1`. Si rompe solo chi pinna al **branch** `lavoro` — ed è giusto che si
rompa, perché quello è il caso "sto prendendo il codice nuovo con un controllo vecchio".

📌 **Nota sul nome del file**, come richiesto: **NON è stato rinominato** (ci puntano righe
pinnate e altri `.ps1` che lo scaricano per nome). La nota sta **in testa al file**: *si
chiama "VPS" ma non gira più solo sul VPS — leggasi "la riga dei round"*.

📌 **Le copie `GUARDIA_BANCO_POSITIVA_v1`** sono ancorate al **commit `e2d5dc3`**, non a HEAD:
la loro verifica di copia **regge ancora**. Ma da oggi **originale e copia non dicono più la
stessa cosa**, ed è scritto nell'intestazione del file.

---

## 7. ❓ COSA RESTA `[NON MISURATO]` — l'elenco onesto

| # | cosa non sappiamo | perché conta | come si chiude |
|---|---|---|---|
| 1 | 🔴 **se l'EA e i suoi `#include` ci sono e COMPILANO su quel PC** | `ABTG_DAX_Apertura_EU.mq5` (2.885 righe) dichiara `#include <Trade/Trade.mqh>` **e `#include <ABTG_PausaGuardian.mqh>`**, che è **nostro**: lo porta il driver v5 (`MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE`), ma **nessuno l'ha mai visto funzionare lì** | una corsa vera. ⚠️ **`-SoloControllo` NON compila** (checklist 39): un include mancante salta fuori **solo a corsa avviata** |
| 2 | 🔴 **`ABTG_DAX_Apertura_EU.mq5` non è MAI stato compilato da nessuna parte** | un EA mai compilato non è un EA: è un testo. Il primo round che lo tocca può morire in compilazione e restituire **ZERO CSV** — che **non è "nessun edge"**, è *"non è girata"* | F7 in MetaEditor, una volta, prima del round |
| 3 | 🟠 **lo stato ATTUALE di `DESKTOP-H4D7CAJ`**: che il nome sia ancora quello (ultima misura **10/09**), che MT5 sia ancora loggato su `50503392`, **se ha sedie attaccate ai grafici**, il `MaxBars`, se esiste `metaeditor64.exe` | dopo il 14/08 sappiamo che **quella macchina sa piazzare ordini veri**. E `MaxBars` a 100.000 fa girare su meno storico **senza dirlo** (classe 160) | una riga di **sola lettura** sul PC di backtest (censimento) **prima** del primo round. **Non l'ho emessa: nessuna riga è uscita da qui** |
| 4 | 🟠 **se i simboli servono e ci sono** (`_EXT`, `_DK`, storico a tick) | i simboli personalizzati **non migrano fra terminali**; il dubbio è già agli atti in `report/COME_ALLUNGARE_STORICO_INDICI_2026-09-09.md` §1.3 — **ma li' era posto al contrario** (mancano sul VPS). Sul PC di backtest **ci sono nati** | sonda di sola lettura, insieme al punto 3 |
| 5 | 🟠 **il gradino JUNCTION (`ReparsePoint`)** | il banco è **puro** e gira su Linux: non può chiedere al disco se una cartella è un collegamento. Il gradino **c'è nel codice ed è invariato**, ma **non è collaudato da questo banco** | si collauda solo su Windows, con una junction finta |
| 6 | 🟠 **nulla è stato eseguito su Windows PowerShell 5.1** | il banco gira su `pwsh 7.4.6`. Il cancello certifica *"nessun costrutto pwsh-7-only"*, che è una **misura**, non una corsa | primo giro `-SoloControllo` sulla macchina vera |
| 7 | 🟠 **il runner notturno delle 03:30 sul VPS** | `CLAUDE.md` lo dice già: `runner_abtg.ps1` r.91 è un'**attività pianificata sul VPS** e **ogni notte rifà da sola** quello che stamattina ha inchiodato la macchina. **Questa modifica NON lo sospende** | è un'azione **sul VPS**: serve una riga, e la riga passa dal cancello. **Fuori dal mio perimetro oggi** |

---

## 8. 📦 Cosa consegno

| file | stato |
|---|---|
| `backtest_pipeline/righe/RIGA_ROUND_VPS.ps1` | **modificato**, additivo, ASCII puro, marcatore **v2** |
| `backtest_pipeline/banco_guardia_macchina.ps1` | 🆕 **nuovo** — i 39 contro-esempi, eseguibili con un comando |
| `report/I_ROUND_SUL_PC_DI_BACKTEST_2026-09-21.md` | questo |

**Per rifare le prove da zero (sola lettura, gira ovunque ci sia `pwsh`):**
```
pwsh -NoProfile -File backtest_pipeline/banco_guardia_macchina.ps1
python3 backtest_pipeline/controlla_riga.py --ps1 backtest_pipeline/righe/RIGA_ROUND_VPS.ps1
```

---

## 9. 🎯 La bussola

Oggi la challenge ha perso mezz'ora di VPS per un backtest sulla macchina sbagliata. Questo
lavoro **non è una sedia in più**: è **ponteggio**, e va detto come tale. 🟢 Ma è il ponteggio
che impedisce al prossimo round di ripetere l'incidente — e adesso la firma di Claudio ha
**la metà di strada fatta**: la riga dei round **sa** che esiste un'altra macchina.
🔴 **L'altra metà è il driver (§5), e senza quella nessun round gira ancora sul PC di
backtest.** È il primo passaggio da mettere in coda.
