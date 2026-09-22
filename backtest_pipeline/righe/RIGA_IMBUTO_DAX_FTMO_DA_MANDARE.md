# LA SEDIA DAX `770101` SU FTMO -- **a che prezzo ha piazzato il limite?**

**22/09/2026** · branch `lavoro` · pin: **`a3a17d7c5ae0d6b105fc5e1a6803b232649fb869`**
Script: `backtest_pipeline/righe/IMBUTO_EMA200_FTMO.ps1` **v3** (541 righe, `RUNNER_SOLA_LETTURA`)

> Nasce dalla domanda di Claudio del **22/09**: *«Perche' sul conto demo da 100k si e' aperto e
> sulla challenge no?»*

---

## COSA MISURA, IN UNA RIGA

| | BCM 100k `50504263` (`D30EUR`) | FTMO `541452707` (`GER40.cash`) |
|---|---|---|
| esito | **riempito** a `25622,90` | **in attesa** a `25630,54` |
| risultato | **+312,80 EUR** (parziale +109,40, trailing +203,40) | -- |

**Differenza fra i due limiti: `7,64 punti`.** Stesso indice, stesso minuto, stessa regola --
**due feed diversi**, quindi due range misurati fra le 09:00 e le 09:35, quindi due livelli.

### Due spiegazioni gia' UCCISE con un numero, prima di lanciare

| ipotesi | verdetto |
|---|---|
| *«lo spread FTMO e' piu' largo, il buy limit e' piu' difficile»* | **FALSA PER DIREZIONE**: il rapporto FTMO/BCM misurato su `GER40` e' **0,84x** -- FTMO e' **piu' STRETTO**. Va nella direzione **opposta**. **E il numero si da' col suo n**: i due assoluti `1,43`/`1,70` sono dell'**ora 16**, e il lato FTMO e' **`n=1` tick**; all'ora della sedia (08) il P95 BCM e' **2,70**. Si trasferisce **il rapporto**, non i valori. Fonte: `report/STOP_VS_SPREAD_FTMO_2026-09-20.md` r.323 e r.547 |
| *«`InpSkipIfTight` ha saltato il trade»* | **INERTE**: il codice lo attiva solo con `InpMinStopPts > 0` (`ABTG_DAX_Apertura_EU.mq5` **r.1202**), e il preset in campo ha **`InpMinStopPts=0.0`** |

**Quella che resta in piedi**: la **scadenza**, `InpPendingExpiryMin=120`.
**Ma non la posso chiudere dalle foto**, e lo dichiaro: se il feed FTMO fosse **tutto spostato in
su** di ~8 punti, `25630,54` sarebbe **lo stesso livello economico** di `25622,90` e avrebbe
dovuto riempirsi. **Serve il giornale.**

---

## LA RIGA CHE RISPONDE

`ABTG_DAX_Apertura_EU.mq5` **r.1958**, appena piazza il limite, scrive di suo pugno:

```text
[DAX Apertura EU] BUY LIMIT (retest) @ <prezzo>  SL <prezzo>  lot <n>
```

**Quel prezzo e' il numero da confrontare col `25622,90` riempito su BCM** -- e insieme all'ora
dice se il limite e' nato prima o dopo, cioe' se e' una questione di **livello** o di **tempo**.

🟢 **E c'e' un secondo pesce nella stessa rete**: il tag prende anche
`[GUARDIA] ABTG_DAX_Apertura_EU: INGRESSO BLOCCATO -- <motivo>`
(`mql5/Include/ABTG_PausaGuardian.mqh` r.1745). 👉 **Se il limite non fosse stato piazzato affatto,
la sonda direbbe anche PERCHE'.**

---

## 1. DOVE MANDARE QUESTA STRINGA

> ## **finestra PowerShell sul VPS `VMI3047753`.**
> **Bersaglio: i LOG del terminale FTMO `541452707` (`C:\FTMO`), in SOLA LETTURA** -- sedia
> **`770101`**, simbolo **`GER40.cash`**.
>
> **NON viene toccato**: il **REALE `10105439`**, il piccolo `50503392`, il 100k `50504263`, il
> banco `50504400`, il manuale `50503635`, Pepperstone, Tickmill. Le loro cartelle dati sono
> **escluse per hash prima che venga aperto un file** -- sul REALE non viene letto **nemmeno
> `origin.txt`**.
>
> **LASCIA MT5 APERTO**: i log si leggono **in condivisione** mentre i terminali operano.

```powershell
& { $ErrorActionPreference='Stop'; $pin='a3a17d7c5ae0d6b105fc5e1a6803b232649fb869'; if($env:COMPUTERNAME -ne 'VMI3047753'){ throw ('VIETATO: questa riga si incolla SOLO nella finestra PowerShell del VPS VMI3047753, dove sta la cartella dati del terminale FTMO 541452707. Macchina attuale: ' + $env:COMPUTERNAME + '. Qui non si esegue niente.') }; $w="$env:USERPROFILE\abtg_sonda"; $p="$w\IMBUTO_EMA200_FTMO.ps1"; $dsk=[Environment]::GetFolderPath('Desktop'); New-Item -ItemType Directory -Force -Path $w | Out-Null; Remove-Item $p -Force -ErrorAction SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/IMBUTO_EMA200_FTMO.ps1?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $p -ErrorAction Stop; if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_IMBUTO_EMA200_FTMO_v3' -Quiet)){ throw 'SCRIPT VECCHIO: manca MARCATORE_IMBUTO_EMA200_FTMO_v3' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'RUNNER_SOLA_LETTURA' -Quiet)){ throw 'SCRIPT SENZA IL BOLLO DI SOLA LETTURA: non lo eseguo' }; if(Select-String -Path $p -SimpleMatch -Pattern 'Stop-Process' -Quiet){ throw 'LO SCRIPT CHIUDEREBBE PROCESSI: una sonda di sola lettura non lo fa. Non lo eseguo.' }; $ErrorActionPreference='Continue'; Write-Host 'BERSAGLIO: i LOG del terminale FTMO 541452707 (C:\FTMO), in SOLA LETTURA -- sedia 770101 DAX Apertura, simbolo GER40.cash. Nessun terminale viene toccato, chiuso o modificato: ne il REALE 10105439, ne il piccolo 50503392, ne il 100k 50504263, ne il banco 50504400, ne il manuale 50503635, ne Pepperstone, ne Tickmill. Le loro cartelle dati vengono ESCLUSE PER HASH prima di aprire un file.' -ForegroundColor Cyan; Write-Host 'LASCIA MT5 APERTO: i log si leggono in condivisione mentre il terminale opera.' -ForegroundColor Yellow; Write-Host 'LA RIGA CHE RISPONDE ALLA DOMANDA:  BUY LIMIT (retest) @ <prezzo>  -- confrontala con il 25622,90 riempito su BCM.' -ForegroundColor Green; & powershell -NoProfile -ExecutionPolicy Bypass -File "$p" -ContoAtteso 541452707 -Magic 770101 -Simbolo GER40.cash -TagLog ABTG_DAX_Apertura_EU -Giorni 10; $rc=$LASTEXITCODE; Write-Host ('   esito sonda: codice ' + $rc + '   (0=LETTO  2=FERMO, e nel referto c e scritto perche)') -ForegroundColor Yellow; Write-Host 'SUL DESKTOP TROVI: la cartella IMBUTO_EMA200_FTMO_<data> e lo zip omonimo, pronto da mandare.' -ForegroundColor Green; Get-ChildItem $dsk -Filter 'IMBUTO_EMA200_FTMO_*' -ErrorAction SilentlyContinue | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize }
```

---

## 2. IL COLLAUDO -- **eseguito**, non riletto

Fatto girare su un albero dati simulato con dentro le righe di log del DAX:

| contro-esempio | esito |
|---|---|
| riga di **un'altra sedia** (Nasdaq) nello stesso log | **non entra** |
| cartella del **REALE** presente | esclusa per hash, nessun file aperto |
| `-Simbolo XAUUSD` (che la sonda non conosce) | **dichiara di non sapere** quali sedie operino, invece di nominarne a caso |

**E il collaudo ha trovato un difetto vero, corretto prima di consegnare**: l'avviso **L3** del
passo 4 elencava a mano *«770202 Dow Apertura, 770511 SuperWave, 771531 EMA200»* **anche con
`-Simbolo GER40.cash`** -- cioe' era **falso**. Ora le sedie si scelgono **in base al simbolo**
(`770101` e `770411` per il DAX), e su un simbolo sconosciuto **lo dichiara**.

Corretti nella stessa passata anche due avvisi che con un tag non-imbuto sarebbero stati falsi:
**L1** (*«la riga la scrive il primo tick del giorno dopo»*) ora si stampa **solo** per l'imbuto,
e i totali `ARMATE/tentati/PIAZZATI` **solo se quei contatori esistono davvero** -- altrimenti lo
script dice che **non c'e' nessun totale da sommare e non ne inventa uno**.

**Strato 1**: `controlla_riga.py --oggetto md` -> nessun difetto meccanico (e il cancello conferma
da solo *«classe 165 disinnescata»*) · parser PowerShell sullo script **0 errori** · sulla riga
**0 errori** · **una sola riga fisica** (2602 byte) · **ASCII puro** · **zero `Stop-Process`** nello
script · il file al pin e' **byte-identico** a quello collaudato · raw al pin **200**.

### Lo strato 2 ha risposto FAIL, e il difetto era di quelli che NON si vedono

🔴 **CLASSE 567, BLOCCANTE.** Il filtro nuovo del passo 3 era `-like ('*' + $TagLog + '*')`. Avevo
scritto, e messo per iscritto, che *«le quadre in `-like` non sono speciali»*: **lo sono**. Sono una
**classe di caratteri**, e il tag di default `[EMA200-IMBUTO]` contiene **`0-I`**, cioe' un **range
da `0` a `I`**. Il pattern significava quindi *«una riga che contiene una cifra o una lettera fra A
e I»* -- **cioe' ogni riga di ogni log**.

**Misurato eseguendo**, su un campione di 6 righe vere: `v2` ne prendeva **2**, `v3` ne prendeva
**6**. Corretto con `-match [regex]::Escape($TagLog)`, che e' case-insensitive come `-like` ed e' la
sostituzione a rischio zero del filtro della v2: **torna a 2, identiche**.

🔴 **E il sintomo somigliava a una vittoria.** Non usciva "zero" (che si nota): usciva un numero
**grande**, con dentro il log intero. **Una misura falsa consegnata come misura vera** -- e la
corsa DAX di stasera avrebbe funzionato lo stesso, mentre la prossima corsa `EMA200` col tag di
default sarebbe diventata spazzatura **in silenzio**. Il collaudo non l'aveva visto perche' era
stato fatto **solo sul caso nuovo**: il default, gia' approvato, era stato dato per buono. **Ora e'
ricollaudato eseguendo tutti e due**: default -> 2 righe di imbuto, DAX -> 2 righe del DAX, nessuna
contaminazione fra i due.

🟠 **Corretta nella stessa passata una diagnosi che lo script dava di SE STESSO** ed era falsa due
volte: diceva che il filtro *«e una sottostringa, e distingue le maiuscole»*. Non era una
sottostringa (era un wildcard) e **non** distingue le maiuscole. Una diagnosi sbagliata in un
referto manda a cercare nel posto sbagliato.

**E un difetto MIO, trovato dopo il PASS del cancello deterministico e corretto prima della
consegna -- CLASSE 566**: la prima stesura di questo documento e' stata scritta con un here-document di
shell **non quotato**, quindi i **backtick del markdown sono stati ESEGUITI come comandi**. La
riga 18 ha perso il suo numero (`7,64 punti` -> stringa vuota) e il cancello **e' passato lo
stesso**, perche' controlla la riga di lancio, **non la prosa**. Questo file e' stato riscritto
generandolo da uno script, senza passare per la shell.

---

## 3. COSA QUESTA RIGA **NON** PUO' DIRE

- **Il passo 3 non ha contatori** con questo tag: `ABTG_DAX_Apertura_EU` **non ha un imbuto**
  (verificato: 0 occorrenze di `IMBUTO` nel sorgente). Le righe si leggono **grezze**.
- **Il passo 4 non separa le sedie**: il giornale non porta il magic, e su `GER40.cash` operano
  **`770101`** (retest, solo BUY) e **`770411`** (solo SELL).
- **Il passo 5 vede solo le posizioni CHIUSE** e si riesporta ogni 30 minuti.
- **Se `InpVerbose` fosse `false` nel preset in campo, l'EA e' MUTO e il passo 3 esce vuoto.** Lo
  script lo elenca come **prima** causa dello zero. **Zero righe NON e' un numero.**
- **Il numero finale**: la riga lo va a prendere. Qualunque cifra scrivessi adesso sarebbe
  inventata.
