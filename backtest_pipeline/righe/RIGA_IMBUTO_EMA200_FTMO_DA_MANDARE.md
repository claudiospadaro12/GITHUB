# 🔍 IMBUTO EMA200 DOW — **quanto spesso il prezzo ci schiva**, sedia `771531`

**22/09/2026** · branch `lavoro` · pin della riga: **`6097410892e4defa0393451a09ab8a7a88f014f4`**
Script: `backtest_pipeline/righe/IMBUTO_EMA200_FTMO.ps1` (`MARCATORE_IMBUTO_EMA200_FTMO_v2`, `RUNNER_SOLA_LETTURA`)

> ✏️ **v2 — il cancello di giudizio ha morso, e questo blocco resta agli atti.**
> Il pin precedente (`a043415d`, marcatore `_v1`) **non si manda**: portava sei difetti,
> uno dei quali **di classe nuova (562)** e misurato su albero finto — il campione di
> righe grezze del passo 4 era preso dal fondo di un testo concatenato **al contrario**
> e mostrava i giorni **più vecchi**. Dettaglio in §⑤.

> Nasce dalla foto di Claudio del **22/09 ore 11:05**: *«Mi ha schivato l'ordine pendente.
> Come mai?»* — e dal fatto che **l'EA sta già scrivendo la risposta da solo**
> (`InpLogImbuto=true` nel preset in campo). Questa riga va a prenderla. **Non la stima.**

---

## 🟢 COSA MISURA, IN UNA RIGA

> **Quante volte la sedia ha PIAZZATO i suoi due limiti, e quante volte quei limiti sono
> stati RIEMPITI invece che scaduti inevasi.**

### 🧩 Perché la domanda ha senso: la ricostruzione dallo screenshot

Dai soli numeri sul telefono di Claudio, e dal sorgente, i conti si chiudono **due volte per
ogni grandezza** — è così che la sedia è stata identificata:

| grandezza | prima strada | seconda strada |
|---|---|---|
| **ATR(14) H1** | `SL − ordine2` = **67,09** (è `1,0 × ATR`, r.358) | `ordine2 − ordine1` = **67,08** (è `0,5 × ATR`, r.356-357) |
| **EMA200 H1** | `ordine1 + 0,2 × ATR` = **52170,78** | `ordine2 − 0,3 × ATR` = **52170,77** |
| **TP a 2,00R dell'ordine 1** | `52157,36 − 2 × 100,63` = **51956,10** | 🎯 **è il numero stampato sul grafico** |
| **TP dell'ordine 2** *(la falsificazione)* | `52190,90 − 2 × 67,09` = **52056,72** | 🔴 **da controllare sulla foto**: i due limiti hanno lo **stesso SL** ma **R diversi**, quindi **TP diversi**. Se sulla foto l'ordine 2 avesse anche lui `51956,10`, tutta la ricostruzione qui sopra sarebbe da rifare |
| **rischio per ordine** | `13,67 × 67,09 × 0,871` = **798,8 €** | `9,11 × 100,63 × 0,871` = **798,5 €** |

`ABTG_EMA200.mq5` **r.361** dice `riskPct = InpRiskPercent / nOrders` = `2,00 / 2` =
**1,00%**, e **r.470** dice che la base è `AccountInfoDouble(ACCOUNT_BALANCE)` — il saldo
**vivo**, non quello iniziale. Invertendo il `MathFloor` sullo step del lotto (r.492), i due
lotti `9,11` e `13,67` **incastrano il saldo fra 79.881 € e 79.935 €**: cioè 1,00% tondo di
un conto che in quel momento era **65-119 € sotto** gli 80.000 di partenza. ⚠️ **Non si
scrive «0,998% di 80.000»**: gli 80.000 sono il saldo **iniziale** (`report/RESOCONTO_2026-09-21.md`
r.38), e a saldo esatto 80.000 i lotti sarebbero usciti **9,12 e 13,69**, non 9,11 e 13,67.

*(Il valore per punto **`0,871`** è `report/STOP_VS_SPREAD_FTMO_2026-09-20.md` **r.108** —
✏️ e va detto **da dove viene**: è **letto dalle specifiche del simbolo FTMO**
(`TickValue 0,00871 × 100`, fonte `PREVOLO_FTMO_specifiche_2026-09-20.csv`), **non** misurato
sui P/L veri. Il gemello BCM `U30USD` accanto, quello sì `[MIS, n=62]`, vale **0,86091**.
🟢 **Ma i due lotti dello screenshot sono una seconda strada indipendente e lo confermano**:
`798,81/917,12 = 0,8710` e `798,48/916,74 = 0,8710`.)*

🟢 **E la risposta al «come mai» di quel singolo giorno è già data**: un **SELL LIMIT si
riempie sul BID**, e il grafico MT5 **è disegnato sul BID** → nessuno spread nascosto,
il ritorno si è semplicemente fermato prima. *(L'illusione «me l'ha schivato di un pelo»
vive sui **BUY**, che si riempiono sull'**ASK**, invisibile sul grafico bid.)*
🔴 **Quello che NON si sa è la FREQUENZA**, ed è l'unica cosa che decide se c'è un problema.

---

## ① 🖥️ DOVE MANDARE QUESTA STRINGA

> ## 🖥️ **finestra PowerShell sul VPS.**
> **Bersaglio: i LOG del terminale FTMO `541452707` (`C:\FTMO`), in SOLA LETTURA.**
>
> 🔴 **COSA NON VIENE TOCCATO — e qui non è una promessa, è una sequenza.** Le cartelle dati
> del **REALE `10105439`** (`C:\BCM_Reale`), del **piccolo `50503392`**, del **100k
> `50504263`**, del **banco `50504400`** (`C:\MT5_Backtest`), del **manuale `50503635`**,
> di **Pepperstone** e di **Tickmill** vengono **ESCLUSE PER HASH prima che venga aperto un
> solo file** (`$HASH_NOTI`, r.79-88). Sul REALE **non viene letto nemmeno `origin.txt`**.
>
> ✋ **E QUI VALE IL CONTRARIO DI UN ROUND: LASCIA MT5 APERTO.** I log si leggono **in
> condivisione** (`FileShare::ReadWrite`, classe 163) **mentre il terminale opera**. Chiudere
> i terminali qui non serve e farebbe solo perdere i tick della giornata.
>
> ✅ **La guardia di macchina è POSITIVA, e il nome è misurato, non inventato.**
> La riga parte **solo** su `VMI3047753` — il nome del VPS, misurato il 12/09 da `CODA_04`
> (`report/collaudi/CENSIMENTO_MT5_VPS_2026-09-12_0846.txt` r.8, `report/DUE_MACCHINE_2026-09-12.md`
> r.13) e già usato nella stessa forma da `report/BINARI_IN_CAMPO_FTMO_2026-09-21.md` r.50.
> **Su qualunque altra macchina non esegue niente e dice quale macchina ha trovato.**
> *(✏️ La v1 faceva il contrario — vietava `DESKTOP-H4D7CAJ` e ammetteva tutto il resto:
> un insieme definito **per differenza**, cioè la classe 180, con la scusa che «il nome del
> VPS non si conosce». Era in repo, in 2.357 righe.)*
>
> E la guardia di macchina **non è la sola**: lo script **certifica** comunque la cartella
> cercando il conto **`541452707`** *e* la parola **FTMO** dentro il giornale. **Se nessuna
> cartella certifica — o se ne certificano DUE — MUORE** (uscita 2) invece di leggere a caso.

```powershell
& { $ErrorActionPreference='Stop'; $pin='6097410892e4defa0393451a09ab8a7a88f014f4'; if($env:COMPUTERNAME -ne 'VMI3047753'){ throw ('VIETATO: questa riga si incolla SOLO nella finestra PowerShell del VPS VMI3047753, dove sta la cartella dati del terminale FTMO 541452707. Macchina attuale: ' + $env:COMPUTERNAME + '. Qui non si esegue niente.') }; $w="$env:USERPROFILE\abtg_sonda"; $p="$w\IMBUTO_EMA200_FTMO.ps1"; $dsk=[Environment]::GetFolderPath('Desktop'); New-Item -ItemType Directory -Force -Path $w | Out-Null; Remove-Item $p -Force -ErrorAction SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/IMBUTO_EMA200_FTMO.ps1?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $p -ErrorAction Stop; if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_IMBUTO_EMA200_FTMO_v2' -Quiet)){ throw 'SCRIPT VECCHIO: manca MARCATORE_IMBUTO_EMA200_FTMO_v2' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'RUNNER_SOLA_LETTURA' -Quiet)){ throw 'SCRIPT SENZA IL BOLLO DI SOLA LETTURA: non lo eseguo' }; if(Select-String -Path $p -SimpleMatch -Pattern 'Stop-Process' -Quiet){ throw 'LO SCRIPT CHIUDEREBBE PROCESSI: una sonda di sola lettura non lo fa. Non lo eseguo.' }; $ErrorActionPreference='Continue'; Write-Host 'BERSAGLIO: i LOG del terminale FTMO 541452707 (C:\FTMO), in SOLA LETTURA. Nessun terminale viene toccato, chiuso o modificato: ne il REALE 10105439, ne il piccolo 50503392, ne il 100k 50504263, ne il banco 50504400, ne il manuale 50503635, ne Pepperstone, ne Tickmill. Le loro cartelle dati vengono ESCLUSE PER HASH prima di aprire un file.' -ForegroundColor Cyan; Write-Host 'LASCIA MT5 APERTO: qui serve il contrario di un round -- i log si leggono in condivisione mentre il terminale opera.' -ForegroundColor Yellow; & powershell -NoProfile -ExecutionPolicy Bypass -File "$p" -ContoAtteso 541452707 -Magic 771531 -Simbolo US30.cash -Giorni 10; $rc=$LASTEXITCODE; Write-Host ('   esito sonda: codice ' + $rc + '   (0=LETTO  2=FERMO, e nel referto c e scritto perche)') -ForegroundColor Yellow; Write-Host 'SUL DESKTOP TROVI: la cartella IMBUTO_EMA200_FTMO_<data> e lo zip omonimo, pronto da mandare.' -ForegroundColor Green; Get-ChildItem $dsk -Filter 'IMBUTO_EMA200_FTMO_*' -ErrorAction SilentlyContinue | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize }
```

📅 **Cosa deve leggere Claudio**: la riga `lanciata il :` in testa al referto — **dev'essere
di oggi**. Il 17/08 un referto stantio è stato rimandato **due volte** in buona fede.

---

## ② 🚦 I TRE BOLLI CHE LA RIGA CONTROLLA PRIMA DI ESEGUIRE

Oltre al marcatore di versione, questa riga verifica **che lo script sia davvero innocuo**,
e si rifiuta di eseguirlo altrimenti:

| bollo | cosa impedisce |
|---|---|
| `MARCATORE_IMBUTO_EMA200_FTMO_v2` | eseguire una copia vecchia (regola del 10/08). 🔴 **Il numero di versione è salito apposta**: una copia `_v1` in giro porta i sei difetti di §⑤ e **non deve poter passare** |
| `RUNNER_SOLA_LETTURA` | eseguire uno script che ha perso il suo mandato di sola lettura |
| 🔴 **assenza di `Stop-Process`** | eseguire qualcosa che possa **chiudere un terminale**. Le righe dei round ce l'hanno per forza; **una sonda no**, e la riga lo verifica invece di fidarsi |

---

## ③ 📐 LE TRE FONTI, E COSA CIASCUNA **NON** PUÒ DIRE

🔴 **Dichiarate nello script PRIMA dei numeri (blocco «I LIMITI, DICHIARATI PRIMA DEI NUMERI», L1-L7), non dopo.**

| passo | fonte | portata | 🔴 limite |
|---|---|---|---|
| **3** | imbuto, scheda Esperti | **PER-EA** — l'unico numero separabile per sedia | **L1**: la riga di un giorno la scrive il **primo tick del giorno dopo** (`ImbutoGiro()` **r.240-249**) → **il giorno completo più recente è IERI** |
| **4** | giornale | **PER-SIMBOLO** | **L3**: il giornale **non porta il magic**, e su `US30.cash` operano **tre** sedie (`770202`, `770511`, `771531`) che usano **tutte** pendenti → le righe `expired` **non sono separabili** |
| **5** | CSV TradeExporter | **PER-MAGIC + per SIMBOLO** | **L4**: contiene **solo le posizioni CHIUSE** (`ABTG_TradeExporter.mq5` **r.183**) e si riesporta ogni 30' → una posizione viva non c'è, e *«piazzati meno aperti»* **sovrastima** gli schivati |

🔴 **E due limiti che nella v1 mancavano, aggiunti dal cancello:**

| | 🔴 limite |
|---|---|
| **L6** — il passo 5 **non è certificabile sul conto** | `Common\Files` è **condivisa fra tutti gli MT5 della macchina** e il CSV **non porta il numero di conto**. E il magic **`771531` è lo STESSO anche sulla sedia BCM del piccolo `50503392`** (simbolo `U30USD`). 👉 Ora si filtra **anche per simbolo** (`US30.cash`), e se compaiono righe con lo stesso magic su altri simboli **lo dice in rosso** |
| **L7** — **le tre finestre non coincidono** | passi 3 e 4 leggono gli ultimi `-Giorni` file di log; il passo 5 legge **tutto lo storico del CSV**, senza ritaglio di date. *«PIAZZATI meno posizioni»* sottrarrebbe **due periodi diversi**. Le date sono stampate: si guardano |

⚠️ **L2 — due orologi nella stessa riga.** Il **prefisso** del log è in **ora locale del PC**
(sul VPS: italiana); il campo `giorno AAAA.MM.GG` **dentro** la riga viene da `TimeCurrent()`,
cioè **ora server** (FTMO = italiana **+1**). Lo script stampa **tutti e due, etichettati**.

🔴 **E la cosa che non va fraintesa: UNO ZERO NON È UN NUMERO — in NESSUNO dei tre passi.**
- **zero righe imbuto** → quattro cause (preset con `InpLogImbuto=false`, sedia staccata o muta,
  giorno non ancora cambiato, binario in campo più vecchio del sorgente);
- **zero `expired`** *(mancava nella v1)* → il giornale **potrebbe non registrare la scadenza**
  di un pendente: è un evento del server e la sua riga non è garantita;
- **zero righe che nominano il simbolo** *(mancava nella v1)* → su quel terminale il simbolo
  potrebbe **chiamarsi diversamente** (su BCM la stessa sedia gira su `U30USD`).

Ognuna è scritta **in rosso dove capita**, non in fondo.

---

## ④ 🧪 IL COLLAUDO — fatto su un albero dati **simulato**, coi contro-esempi

Non «ho riletto il codice»: **l'ho fatto girare** contro una finta cartella `MetaQuotes\Terminal`
costruita apposta, con dentro una trappola per ogni cosa che poteva andare storto.

| contro-esempio | esito |
|---|---|
| cartella del **REALE `10105439`** presente | ✅ **ESCLUSA per hash**, nessun file aperto |
| cartella con `origin.txt` = *BCM Markets MT5 Terminal* | ✅ **ESCLUSA per nome** |
| `-ContoAtteso 999999999` (nessuna cartella certifica) | ✅ **FERMO, uscita 2** — non legge a caso |
| `-ContoAtteso 10105439` (qualcuno passa il REALE) | ✅ **FERMO subito**, prima di qualsiasi lettura |
| riga imbuto di **un altro EA** nello stesso log | ✅ **non entra** nel conteggio |
| il regex `ARMATE` contro *«CANDIDATE valutate 24»* | ✅ **non aggancia** |
| CSV con `magic` **771531** e **770202** mescolati | ✅ tiene 771531, **scarta** 770202 |
| righe imbuto **costruite dal sorgente MQL5** (r.212-235) | ✅ ARMATE, tentati, PIAZZATI letti giusti |
| **DUE** cartelle che certificano lo stesso conto | ✅ **FERMO, uscita 2** — *«non scelgo io»* |
| cartella-esca con l'hash del **REALE** **e il conto FTMO nel giornale** | ✅ esclusa per hash: **il suo giornale non viene mai aperto** |
| riga imbuto con **`quadratura ROTTA`** | ✅ contata, e i totali escono marcati **[NON MISURATO]** |
| CSV con magic `771531` su **`U30USD`** (la sedia BCM) | ✅ **scartata**: senza il filtro simbolo entrava nel P/L FTMO |
| `Desktop` che risolve **dentro una cartella dati** | ✅ **referto NON scritto**, e lo dice |
| 65 righe `expired` su 10 giorni, campione «max 40» | ✅ ora sono le **40 più recenti** (nella v1 erano le più **vecchie**) |

🟠 **E il collaudo ha trovato DUE difetti veri, corretti prima di consegnare:**
1. se `[Environment]::GetFolderPath('Desktop')` torna **vuoto**, il referto si perdeva con un
   errore di binding criptico → ora **ripiega** e **dice dove è finito**;
2. 🔴 `$env:TEMP` nullo faceva **esplodere lo script DOPO** aver prodotto i numeri buoni,
   portandosi via il referto → **il file temporaneo è stato tolto del tutto**: il CSV si
   converte **in memoria**, che per una sonda di sola lettura è anche più corretto.

**Strato 1 (deterministico)** — e **ha morso, alla prima passata**:

🔴 **BLOCCANTE, classe 165.** Dentro `& { }` lo `Stop` era **ancora attivo** quando parte
`& powershell`: su PS 5.1 lo **stderr di un comando nativo diventa errore TERMINANTE** e
ammazza il resto della riga. Conseguenza concreta: la sonda girava, ma **l'elenco finale sul
Desktop non veniva mai stampato** — e a schermo sarebbe sembrata una raccolta riuscita.
✅ Corretto: `$ErrorActionPreference='Continue'` **dopo** i tre bolli, prima dell'esecuzione.

🟠 **E un rilievo che è ironico, ma va letto e non liquidato**: il cancello segnala *«questa
riga può TERMINARE un processo»*. **Ha ragione a segnalarlo**, perché nella riga compare la
stringa letterale `Stop-Process`. 👉 A leggerla, però, sta **dentro il `throw` del terzo
bollo**: serve a **rifiutare** uno script che chiudesse processi. **Nessuna `Stop-Process`
viene eseguita**, né dalla riga né dallo script (che ne ha **zero**). Tengo la stringa
letterale invece di mascherarla: un controllo leggibile vale il falso positivo.

---

## ⑤ 🚦 IL CANCELLO DI GIUDIZIO (strato 2) — **sei difetti, il pin è cambiato**

La v1 (`a043415d`) passava lo strato 1 ma **non passa la lettura**. I sette, con la classe —
e il **#0 da solo** rendeva la v1 **incapace di misurare qualunque cosa**:

| # | difetto | classe | come è stato trovato |
|---|---|---|---|
| **0** | 🔴🔴 **LA RIGA SI RIFIUTAVA DI ESEGUIRE IL PROPRIO SCRIPT.** Il terzo bollo fa `Select-String -SimpleMatch -Pattern 'Stop-Process'` sul file scaricato — e il file **conteneva quella stringa in un commento**, proprio nella frase che giurava di non usarla (*«non c'è una sola `Stop-Process` in tutto il file»*, v1 r.21). `Select-String` confronta **testo, non codice**: il bollo scattava **sempre** | **563 — NUOVA** | 🧪 **eseguendo la RIGA INTERA**, non lo `.ps1` da solo. Invisibile a chi collauda lo script a mano: è l'unico difetto che **azzera la misura** |
| **1** | 🔴 il campione «max 40 righe grezze» del passo 4 usava `Select-Object -Last 40` su un testo concatenato **dal file più NUOVO al più VECCHIO**: mostrava le 40 righe **più vecchie** | **562 — NUOVA** (figlia della **466**, cugina della **546**) | **misurato**: con 65 `expired` su 10 giorni il campione conteneva solo il **13-17/09** e **saltava 18, 19, 20 e 21** — cioè proprio il giorno della domanda |
| **2** | 🔴 il passo 5 filtrava **solo per magic**. `Common\Files` è condivisa e il CSV non porta il conto; **`771531` è lo stesso magic della sedia BCM sul piccolo `50503392`** | **L6** | misurato: una riga `U30USD` con magic `771531` entrava nel P/L «FTMO» |
| **3** | lo **zero del passo 4** non aveva le sue cause (le aveva solo il passo 3): *«expired 0»* si legge **«non ci schiva mai»** | — | lettura |
| **4** | le **finestre dei tre passi non coincidono**: passo 3/4 = ultimi `-Giorni` file, passo 5 = **tutto** lo storico CSV | **L7** | lettura |
| **5** | la **`quadratura ROTTA`** che l'EA stampa da solo veniva **ignorata**: si sommavano numeri che l'EA dichiara incoerenti | — | lettura del sorgente MQL5 r.212-235 |
| **6** | 🔴 il ripiego di `Posa-Referto` **poteva scrivere dentro una cartella dati** se la cartella di lavoro fosse stata lì: il bollo `RUNNER_SOLA_LETTURA` era una **promessa**, non una sequenza | — | contro-esempio costruito apposta |

➕ **E la guardia di macchina (§①), che era la classe 180** — vedi lì.

**Strato 1 (deterministico)** — e **ha morso, alla prima passata**, prima ancora di tutto questo:
la **classe 165** (`Stop` ancora attivo dentro `& { }` quando parte `& powershell`), corretta con
`$ErrorActionPreference='Continue'` **dopo** i tre bolli.

🟠 **Un rilievo ironico che resta, e va letto e non liquidato**: il cancello segnala *«questa
riga può TERMINARE un processo»*, perché nella riga compare la stringa letterale `Stop-Process`.
👉 Sta **dentro il `throw` del terzo bollo**: serve a **rifiutare** uno script che chiudesse
processi. **Nessuna `Stop-Process` viene eseguita**, né dalla riga né dallo script (che ne ha
**zero**). La stringa resta in chiaro: un controllo leggibile vale il falso positivo.

Al pin nuovo: `controlla_riga.py` → **nessun difetto meccanico** · parser PowerShell sullo
script **0 errori** · sulla riga **0 errori** · **una sola riga fisica** · **zero caratteri
non-ASCII** in tutto il `.ps1` (regola del 17/08) · URL raw al pin **200 e byte identici** a
quello che è stato letto.

**🕳️ Cosa resta NON coperto**
- **Che il giornale MT5 registri davvero la SCADENZA di un pendente**: in repo c'è **una sola**
  occorrenza storica della parola `expired` (`report/ORB_GEMELLI_DIVERGENZA_2026-08-22.md` r.196)
  e non basta a garantirlo. 👉 Se il passo 4 esce **zero** mentre il passo 3 dice `PIAZZATI > 0`,
  **la risposta è il confronto passo 3 / passo 5**, non il passo 4.
- **Che il `.ex5` in campo abbia davvero l'imbuto**: il `.set` di repo porta
  `InpLogImbuto=true`, ma **il binario non l'ho misurato** — e questa flotta ha già avuto uno
  scarto sorgente/binario (`ABTG_EMA200` stessa, 690 righe contro 486 in campo). **Se l'imbuto
  fosse muto, il passo 3 esce vuoto e lo dice.**
- **Il numero finale**: questa riga **lo va a prendere**, non lo anticipa. Qualunque cifra io
  scrivessi adesso sarebbe inventata.
- **Il TP del secondo limite sulla foto**: la ricostruzione **predice 52056,72**. Non ho la foto
  sotto gli occhi per confermarlo — ed è la **falsificazione più netta** disponibile, quindi va
  guardata prima di credere al resto della tabella.
- **Che la sonda giri su un albero VERO**: il collaudo è su albero **simulato**. Che la cartella
  dati FTMO stia sotto `%APPDATA%` (e non in **PORTABLE**) è **fortemente indiziato**
  (`SCHIERA_FTMO.ps1` ci ha scritto il 20/09, hash `46C9F8E9…` in `report/STASERA.md` r.18)
  ma **non l'ho misurato io**. Se fosse portable, la sonda **muore con uscita 2** e ora la
  elenca fra le quattro cause.

🔴 **E questa riga non propone NIENTE.** Se il rapporto fosse brutto, la manopola che lo governa
è `InpOrder1Atr` (oggi **0.20**, default dell'EA **0.10**) — ma spostarla è **un ROUND**, non
una modifica in campo, **e la decide Claudio**.
