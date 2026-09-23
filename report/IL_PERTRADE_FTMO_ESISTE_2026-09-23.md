# 🔥 IL PER-TRADE DELLA CHALLENGE FTMO ESISTE — ed è la RACCOLTA che manca, non il file

**Data**: 23/09/2026 · **Perimetro**: `/home/user/GITHUB`, branch `lavoro` · **SOLA LETTURA**
(nessun round, nessuna riga consegnata, nessun tocco a VPS/forward/preset/sedie).

---

## 📌 LA RISPOSTA IN CINQUE RIGHE

1. ✅ **Il file c'è, è fresco, ed è DAVVERO della challenge.** `ABTG_Trades_FTMO.csv`,
   scritto il **2026-09-23 03:27:48** in `Common\Files`. L'esportatore che lo scrive è
   attaccato su **`C:\FTMO`, conto `541452707`** — e questo è un **fatto stampato**, non
   un'inferenza (vedi §3).
2. 🔢 **Contiene ESATTAMENTE 2 posizioni chiuse.** Non è vuoto e non è solo intestazione:
   il conto dei byte lo dimostra e **esclude sia 1 che 3** (§6).
3. 🔴 **`CODA_12` lo salta per un nome di colonna**: cerca `position_id`, l'esportatore
   scrive `pid`. Stessa sorte per `ABTG_Trades_100k.csv`. **2 file su 143 «NON CONTATO»,
   e sono gli unici due file di FORWARD VERO della cartella.**
4. 🔴 **E la pubblicazione NON avviene**: `data/statements/trades_ftmo.csv` **non è mai
   esistito nel repo** (`git log --all` → zero commit), mentre `trades_100k.csv` è stato
   aggiornato il 22/09 alle 22:45. L'attività `ABTG_PubblicaTrades` è girata e ha dato
   esito `0`.
5. 📉 **Ma il MERITO resta sospeso, e con un numero**: al ritmo misurato della famiglia,
   **20 operazioni arrivano tra metà e fine ottobre**, **150 non prima di marzo-luglio
   2027** (§7). Quel file serve al **RISCHIO** e alla **verifica del contratto**. Oggi,
   niente promozioni e niente bocciature.

🟢 **La correzione che il documento porta al piano degli otto giorni**:
`report/IL_PIANO_DEGLI_OTTO_GIORNI_2026-09-23.md` r.289 prevede come rischio di M3
*«si scopre che l'esportatore non è attaccato — e si attacca»*. 👉 **È attaccato dal
20/09 alle 18:29.** M3 non è un gesto in MT5: è **una riga di lettura + una toppa alla
pubblicazione**. Il costo di M3 scende, e la parte manuale di Claudio **sparisce**.

---

## 1. 📄 CHE COSA C'È DENTRO IL FILE — file e riga

Sorgente: **`mql5/Experts/ABTG_TradeExporter.mq5`** (211 righe, pin `0127d449…` in
`backtest_pipeline/righe/SCHIERA_FTMO.ps1` r.184).

### 1.1 Le colonne — **16**, separatore `;`, codifica **ANSI**
Intestazione scritta a **r.177-179**, righe dati a **r.188-204**, nello stesso ordine:

| # | colonna | da dove viene (riga del sorgente) |
|---|---------|-----------------------------------|
| 1 | `pid` | `DEAL_POSITION_ID` — **r.130** |
| 2 | `symbol` | `DEAL_SYMBOL` — r.153 / r.167 |
| 3 | `side` | `buy`/`sell` dal deal d'ingresso — r.154 |
| 4 | `volume` | `DEAL_VOLUME` del deal IN — r.155 |
| 5 | `open_time` | `DEAL_TIME` del deal IN — r.156 |
| 6 | `open_price` | r.157 |
| 7 | `close_time` | `DEAL_TIME` dell'**ultimo** deal OUT — r.165 |
| 8 | `close_price` | r.166 |
| 9 | `commission` | somma su **tutti** i deal della posizione — r.147 |
| 10 | `swap` | somma — r.148 |
| 11 | `profit` | somma — r.149 |
| 12 | `strategy` | `DEAL_COMMENT` del deal d'ingresso — r.158-159 |
| 13 | `magic` | `DEAL_MAGIC` — **r.160** (attribuzione certa, non dal commento) |
| 14 | `close_reason` | `DEAL_REASON` tradotto da `ReasonToStr` — r.58-71, r.168 |
| 15 | `session_high` | max su M5 dall'ingresso a fine giornata — r.79-96 |
| 16 | `session_low` | min, idem |

**Codifica e separatore**: `FILE_WRITE|FILE_CSV|FILE_ANSI` + `FILE_COMMON`, separatore `';'`
— **r.173-175**. Fine riga **CRLF**. 🟢 La codifica è **ANSI, non UTF-16**: la trappola della
**classe 601** (giornali MT5 in UTF-16) **non si applica a questo file** — ma la sua metà
sana sì, e sta nella specifica (§5.4).

### 1.2 🔴 `pid` **È** un `position_id` — stessa cosa, nome diverso
**r.130**: `long pid = (long)HistoryDealGetInteger(tk, DEAL_POSITION_ID);`
👉 È un **rinominamento**, non un campo diverso. Quindi la riparazione di `CODA_12` è
legittima nel merito: sta leggendo la stessa grandezza.

### 1.3 ⚠️ MA la GRANULARITÀ è diversa, e questo **cambia il significato delle colonne di `CODA_12`**
- I per-trade **da tester** (**57** EA con quell'intestazione, es. `ABTG_PTE.mq5` r.702,
  `ABTG_LondonFx.mq5` r.1904)
  scrivono `close_time;symbol;magic;position_id;deal_type;…` = **una riga per DEAL DI USCITA**.
- `ABTG_TradeExporter` scrive **una riga per POSIZIONE**: i deal vengono **aggregati** per
  `pid` (r.136-145) e la riga esce solo se la posizione ha ingresso **e** uscita (**r.183**).

👉 Quindi su questo file `deal == posizioni` **per costruzione**, e il **rapporto è 1 per
definizione, non per misura**. Un `CODA_12` riparato male stamperebbe «rapporto 1» come se
fosse un risultato: **non lo è**. Va detto nel referto (§4, toppa punto C).

### 1.4 🔴 RISCRIVE, non accoda — **ma NON è una fotografia parziale**
- `FileOpen(..., FILE_WRITE, ...)` senza `FILE_READ` **tronca a zero** (r.175).
- **MA** prima di scrivere, `ExportAll()` **ricostruisce l'intera storia** da
  `HistorySelect(from, TimeCurrent())` con `from = 1 gennaio di InpFromYear` (r.119-121).

👉 Quindi ogni export è una **fotografia COMPLETA** dall'anno impostato a oggi. 0,4 KB **non**
vuol dire «solo le ultime»: vuol dire **che di posizioni chiuse ce ne sono due in tutto**.
🔴 **I due modi veri in cui può mentire**, e vanno scritti:
   (a) se l'EA viene staccato, il file **si congela** all'ultimo export (nessun errore, nessun
       avviso: resta lì, con la data vecchia — per questo la **data del file** è un controllo
       obbligatorio);
   (b) `HistorySelect` restituisce ciò che il terminale ha **scaricato**: su una storia non
       sincronizzata il file sarebbe **corto ma sintatticamente sano**.

### 1.5 Quando scrive
`OnInit` (r.101), **`OnTimer` ogni `InpExportMinutes`** (r.102, r.106) e `OnDeinit` (r.105).
Preset FTMO: **`InpExportMinutes=30`**. 🟢 È a **timer, non a tick**: scrive anche nel weekend.

### 1.6 Il preset FTMO — `mql5/Presets/FTMO/ABTG_TradeExporter_FTMO.set`
```
InpFile=ABTG_Trades_FTMO.csv     InpFromYear=2026
InpExportMinutes=30              InpUseCommon=true
```
`InpFromYear=2026` ⇒ la finestra parte dal **01/01/2026**. Il conto è stato aperto a settembre,
quindi **non taglia niente**.

---

## 2. 🎯 È DAVVERO IL CONTO DELLA CHALLENGE? — la catena di fatti stampati

La domanda è legittima perché `Common\Files` **è una sola cartella condivisa da tutti gli 8
terminali della macchina**, e **il file NON contiene il numero di conto**. La prova sta in tre
referti del runner di stanotte, e si chiude:

| anello | fatto stampato | fonte |
|---|---|---|
| terminale → conto | `C:\FTMO` → **CONTO 541452707**, `FTMO-Server2`, HEDGING | `CODA_03_conti_dei_terminali_20260923_033004.log` |
| terminale → esportatore | `C:\FTMO`, profilo `Default`, **`chart07.chr`** = `ABTG_TradeExporter` su NZDUSD H1 | `CODA_01_sedie_attaccate_20260923_033004.log` r.66 |
| esportatore → nome file | quel `chart07.chr` porta **`InpFile=ABTG_Trades_FTMO.csv`**, `InpFromYear=2026` — `.chr` modificato **2026-09-20 18:29** | `CODA_08_preset_dai_chr_20260923_033004.log` |
| unicità del nome | gli **altri due** esportatori scrivono nomi **diversi**: `ABTG_Trades.csv` (piccolo `50503392`) e `ABTG_Trades_100k.csv` (100k `50504263`). **Nessun altro** scrive `ABTG_Trades_FTMO.csv` | `CODA_08`, tre blocchi `ABTG_TradeExporter` |

✅ **La tesi regge.** E le sei sedie della challenge sono attaccate sullo stesso terminale
(`CODA_01`): `770101` GER40.cash · `770202` US30.cash · `770260` US100.cash · `771531`
US30.cash · `770511` US30.cash · `770411` GER40.cash, più il Guardian `779001`. Sono
**esattamente** le sei obbligatorie di `SCHIERA_FTMO.ps1` r.205-210.

### 🔴 E il contro-esempio che NON va sottovalutato: **il `magic` non distingue i conti**
Misurato sul file già in repo `data/statements/trades_100k.csv` (conto `50504263`):

```
770101 × 16    770611 × 8    770901 × 5    770411 × 4    770202 × 3
```

👉 **`770101`, `770202` e `770411` vivono su TUTTI E DUE i conti.** Chi cercasse di capire da
che conto viene una riga guardando il magic **sbaglierebbe su metà del roster**.
🟢 **Il discriminante interno che funziona è il SIMBOLO**: FTMO usa `GER40.cash / US30.cash /
US100.cash / US500.cash`, BCM usa `D30EUR / U30USD / NASUSD / 225JPY`. Nessuna sovrapposizione.
E resta **secondario** rispetto al discriminante primario, che è il **nome del file** ancorato
al `.chr` del terminale (tabella sopra).

---

## 3. 🔧 PERCHÉ `CODA_12` LO SALTA — e la toppa, riga per riga

Script: **`backtest_pipeline/righe/CODA_12_pertrade_posizioni.ps1`**
🛑 **NON l'ho modificato**: gira in automatico sul VPS ogni notte alle 03:30 dentro
`runner_abtg.ps1`. La toppa è scritta qui e **passa dal cancello** prima di toccare il file.

### 3.1 La riga esatta che decide `NON CONTATO`
```powershell
r.158-162:  for($i=0; $i -lt $hh.Length; $i++){
              $k = $hh[$i].Trim().Trim('"')
              if($k -eq "position_id"){ $iPid = $i }
              if($k -eq "close_time"){  $iClose = $i } }
r.163-166:  if($iPid -lt 0){
              $r.motivo = ("intestazione senza colonna position_id: [" + $intest + "]")
              return $r }
```

### 3.2 🔴 I difetti sono **QUATTRO**, e sono cose diverse

| # | difetto | riga | perché è **suo** e non del file |
|---|---------|------|----------------------------------|
| **A** | **Confronto di nome troppo stretto**: accetta solo `position_id`, l'esportatore scrive `pid` (r.177) | r.160 | Il contatore conosce **una sola** delle due famiglie di per-trade che esistono in casa |
| **B** | 🔴 **Il MESSAGGIO è sbagliato, non solo il confronto**: stampa `NON CONTATO`, cioè lo stesso esito di «file illeggibile». **Non è illeggibile: è di un FORMATO DIVERSO, e leggibilissimo.** | r.218 | È il difetto che fa perdere l'informazione: chi legge il referto archivia «rotto» invece di «da leggere». Il file della challenge è stato lì **tre notti** e nessuno se n'è accorto |
| **C** | **Etichette che mentirebbero dopo la toppa**: `deal uscita` e `rapporto` (r.228-230) nascono per i per-trade **per-deal**. Su un file **per-posizione** il rapporto è `1` **per costruzione** | r.228-230 | Riparare solo A produrrebbe un numero vero e una **didascalia falsa** |
| **D** | **Il filtro non vede il file OBBLIGATORIO**: `-Filter "abtg_trades_*.csv"` (r.199) richiede l'underscore dopo `trades`. **`ABTG_Trades.csv`** (conto piccolo `50503392`, l'unico marcato *obbligatorio* in `pubblica_trades.ps1` r.193) **non viene mai elencato** | r.199 | Misurato: nel log di stanotte compaiono `ABTG_Trades_FTMO.csv` e `ABTG_Trades_100k.csv`, **`ABTG_Trades.csv` no** |

📌 Nota di portabilità da dichiarare: quel `-Filter` aggancia `ABTG_Trades_FTMO.csv` **solo
perché Windows è insensibile al maiuscolo**. Lo stesso script su `pwsh` Linux (il collaudo
suggerito a r.98) **non lo aggancerebbe**. Non è il difetto di stanotte, ma è nello stesso punto.

### 3.3 🩹 LA TOPPA PROPOSTA — minima, e non cambia i numeri di nessuno dei 141 file già contati

**(1) r.158-162 — riconoscere le due famiglie, e ricordarsi QUALE si è trovata**
```powershell
$famiglia = "per-deal"      # <-- nuova variabile, da mettere accanto a $iPid
for($i=0; $i -lt $hh.Length; $i++){
  $k = $hh[$i].Trim().Trim('"')
  if($k -eq "position_id"){ $iPid = $i }
  if($k -eq "pid" -and $iPid -lt 0){ $iPid = $i; $famiglia = "per-posizione" }
  if($k -eq "close_time"){  $iClose = $i }
}
```
🔴 L'ordine conta: `position_id` **prima**, `pid` **solo se** il primo non c'è. Così i 141 file
già contati **non cambiano di un numero** (nessuno di loro ha una colonna `pid`: verificato sui
57 `FileWrite` di intestazione per-trade in `mql5/Experts/`: `"pid"` compare in UN solo file, l'esportatore).

**(2) r.163-166 — l'esito «formato sconosciuto» si deve DISTINGUERE da «illeggibile»**
```powershell
if($iPid -lt 0){
  $r.motivo = ("FORMATO NON RICONOSCIUTO (il file si LEGGE, non so che cos'e'): " +
               "nessuna colonna 'position_id' ne' 'pid'. Intestazione: [" + $intest + "]")
  return $r
}
```
e a **r.218** l'etichetta va spezzata in due esiti distinti — `NON LETTO` (permessi, tetto,
lock) contro `LETTO MA FORMATO NUOVO`. **Un formato nuovo è una notizia, non un guasto.**

**(3) r.228-230 — la didascalia segue la famiglia**
```powershell
if($famiglia -eq "per-posizione"){
  Write-Host ("     POSIZIONI  : " + $c.posizioni + "   (file PER-POSIZIONE: una riga = una posizione chiusa)")
  Write-Host  "     rapporto   : non si applica -- vale 1 per COSTRUZIONE, non per misura"
} else { <le tre righe di oggi> }
```

**(4) r.199 — il filtro**: `-Filter "abtg_trades*.csv"` (senza underscore) fa entrare anche
`ABTG_Trades.csv`. 🔴 **Va valutato a parte**: allarga l'insieme di 1-2 file e va verificato
che non agganci altro. **Non è nello stesso pacchetto della riparazione A/B/C.**

💰 **Costo**: zero tempo macchina (è una riga di lettura). **Rischio**: la modifica tocca uno
script che gira **da solo** alle 03:30 — quindi **cancello obbligatorio** (`controlla_riga.py`
+ agente `controllo-preventivo`) e confronto dell'impronta prima/dopo, come fa `CODA_11` §2 per
`runner_abtg.ps1`.

---

## 4. 🔴 IL SECONDO BUCO, CHE È PIÙ GRAVE: il file NON VIENE PUBBLICATO

Misurato:
- `git log --all -- "data/statements/*ftmo*"` → **zero commit**. `trades_ftmo.csv` **non è mai
  esistito** nel repo.
- `data/statements/trades_100k.csv` **è** stato aggiornato: ultimo commit `def89c5b`,
  **22/09 22:45** («Aggiornamento automatico trades»).
- `CODA_11`: attività **`ABTG_PubblicaTrades`**, ultima corsa **22/09 22:45:45**, esito **0**,
  esegue **`C:\ABTG\pubblica_trades.ps1 -Branch lavoro`**.
- Il blocco FTMO in `backtest_pipeline/pubblica_trades.ps1` (r.198-202, `$CsvNameFtmo`) esiste
  in repo dal commit **`e2bf1f1b` del 20/09 15:58 UTC**.
- L'esportatore FTMO era attaccato dal **20/09 18:29** (data del `.chr`), quindi **il file
  esisteva già** la sera del 22/09.

### 🕵️ Due spiegazioni, e una si può escludere
| ipotesi | regge? |
|---|---|
| «l'esportatore non era attaccato il 22/09 sera» | ❌ **ESCLUSA**: `.chr` del 20/09 18:29, e il file ha 2 posizioni chiuse il **22/09** (§7) |
| «la copia che gira è **`C:\ABTG\pubblica_trades.ps1`**, ed è **più vecchia** del 20/09 15:58 → non contiene il blocco FTMO» | 🟠 **PLAUSIBILE E NON MISURATA** |
| «la copia è aggiornata ma la pubblicazione dell'opzionale è fallita in silenzio» | 🟠 **PLAUSIBILE E NON MISURATA** — `Pubblica-Csv` con `$obbligatorio=$false` **non fa `exit 1`** (r.189): esito `0` **non** significa «pubblicati tutti e quattro» |

🔴 **E qui c'è un difetto di STRUMENTO da segnalare**: `CODA_11` stampa byte + data + SHA-256
**solo di `runner_abtg.ps1`** (§2 del suo referto). Delle **altre quattro** copie in `C:\ABTG`
che girano da sole — `pubblica_trades.ps1`, `scarica_pagella.ps1`, `aggiorna_news.ps1` — non si
sa **quale versione gira**. È la stessa classe del buco trovato il 12/09 su `aggiorna_news.ps1`
(copia da uno zip di un branch morto). **Chiuderlo costa una riga di lettura** (§5.2).

---

## 5. 🎯 LA SPECIFICA DELLA RACCOLTA (non la riga: la riga la scrive chi passa dal cancello)

### 5.0 Bersaglio — riga obbligatoria in testa, per la regola dei terminali multipli
> 🖥️ **Finestra PowerShell sul VPS `VMI3047753`.** La riga **LEGGE E STAMPA**: non apre
> nessun MT5, non attacca niente, non chiude niente. 🔴 **Non tocca** nessuna delle 8 cartelle
> dati dei terminali (`50503392`, `50504263`, `50504400`, `50503635`, `10105439`,
> **`541452707`**, Pepperstone, Tickmill): legge **solo** `Common\Files`, che non è la cartella
> dati di nessun terminale.

### 5.1 Che cosa deve fare
1. Leggere **`$env:APPDATA\MetaQuotes\Terminal\Common\Files\ABTG_Trades_FTMO.csv`** —
   percorso **cablato**, nessun parametro (stesso perimetro di `CODA_12`, r.75-99: la cartella
   non si deve poter nominare da riga di comando).
2. **Stampare a schermo il contenuto INTERO.** Con 2-3 righe di dati è il modo più onesto e più
   corto: niente riassunti su un campione che sta in una schermata.
3. **Copiare** il file su `\Desktop\FTMO_PERTRADE_<AAAA-MM-GG>\` + `Compress-Archive` dello zip
   pronto da mandare — **regola delle righe di lancio, punti 2 e 3**.
4. Stampare in console **l'elenco dei file attesi** e il loro esito.

### 5.2 🔴 Il DISCRIMINANTE deve essere un FATTO STAMPATO (mai un'inferenza)
La riga deve stampare **tutti e quattro** gli anelli, nell'ordine, perché il file **non contiene
il numero di conto**:

| # | che cosa stampa | dove lo legge |
|---|---|---|
| 1 | **nome file + data + byte** di `ABTG_Trades_FTMO.csv` **e** di `ABTG_Trades_100k.csv` **e** di `ABTG_Trades.csv`, **affiancati** | `Common\Files` |
| 2 | il `.chr` che contiene `InpFile=ABTG_Trades_FTMO.csv`, con **la cartella dati** in cui sta | `…\Terminal\<hash>\MQL5\Profiles\Charts\<profilo>\chart*.chr` |
| 3 | il **numero di conto** letto dal **giornale** di quella cartella dati (deve uscire `541452707`) | `…\Terminal\<hash>\logs\*.log` |
| 4 | i **simboli distinti** trovati nel CSV: devono essere **tutti `*.cash` / `XAUUSD`**. 🔴 Se compare `D30EUR` o `U30USD`, **il file non è di FTMO** e la riga lo deve dire a voce alta | il CSV stesso |

🔴 **E la riga deve scrivere nero su bianco che il `magic` NON è un discriminante**:
`770101`, `770202`, `770411` sono presenti su **entrambi** i conti (misurato, §2).

### 5.3 I controlli di sanità — il file non deve poter mentire
| controllo | perché |
|---|---|
| **numero di righe dati** = righe totali − 1 | l'unità dell'Emendamento A. **Tre esiti diversi**: file assente / sola intestazione / **N posizioni** |
| **prima e ultima `open_time`** e **prima e ultima `close_time`** | se l'ultima `close_time` è di giorni fa mentre la **data del file** è di stanotte, il conto non ha operato; se la **data del file** è vecchia, **l'esportatore è staccato** (§1.4a) |
| **elenco dei `magic` DISTINTI** con il conteggio | devono essere un sottoinsieme delle **sei** note: `770101 · 770202 · 770260 · 770411 · 770511 · 771531`. 🔴 **Un magic fuori lista = allarme**: o è il file sbagliato, o in campo c'è una sedia che non abbiamo schierato |
| **somma dei `profit`** + somma di `commission` + `swap` (e il **netto**) | ⚖️ **È il controllo incrociato che chiude il cerchio**: il Guardian FTMO ha stampato `eq=78242.32` su 80.000 EUR con `rischioAperto=0.00%` (nessuna posizione aperta). Il **netto del CSV deve tornare a −1757,68 EUR ± commissioni**. Se non torna, **uno dei due mente** |
| **elenco dei `close_reason` distinti** | distingue lo stop **iniziale** dal trailing/parziale (r.58-71): serve al criterio di RISCHIO |
| **il `symbol` di ogni riga** | §5.2 punto 4 |

### 5.4 🔴 L'avvertenza di CLASSE 601, adattata a questo file
La classe 601 nasce sui **giornali MT5 in UTF-16**. Questo file **non è UTF-16**: è **ANSI**
(`FILE_ANSI`, r.173). 👉 **Ma la metà che vale resta**, e va cablata nella riga:

- 🔴 **Un conteggio a ZERO non è mai una risposta.** La riga deve distinguere, con **etichette
  diverse**, quattro esiti: **`FILE ASSENTE`** · **`SOLA INTESTAZIONE`** (0 posizioni: il conto
  non ha chiuso nulla) · **`N POSIZIONI`** · **`ILLEGGIBILE`**.
- **`ILLEGGIBILE`** copre: apertura negata / lock esclusivo / prima riga che non contiene
  `pid;symbol;side` / byte non stampabili. 🔴 In quel caso la riga stampa **`ILLEGGIBILE` e il
  motivo** — **mai `vuoto`, mai `0`**.
- L'apertura si fa in **`FileShare::ReadWrite`** (come `CODA_12` r.148 e `CODA_05`): MT5 può
  avere il file aperto, e un `Get-Content` secco fallirebbe **facendo sembrare vuoto un file
  pieno**.
- 🔴 **E la riga deve stampare la codifica che ha usato**, così il prossimo lettore non deve
  indovinarla.

### 5.5 Il secondo pezzo, piccolo e che chiude il buco di §4
Nella stessa riga di sola lettura, **stampare byte + data + SHA-256 di
`C:\ABTG\pubblica_trades.ps1`** e confrontarli con la copia in repo. 👉 **È il numero che dice
in un colpo solo se la mancata pubblicazione è "copia vecchia" oppure "pubblicazione fallita"**
— e sono due riparazioni **diverse**. Costo: quattro righe, zero rischio.

---

## 6. 🧪 IL CONTRO-ESEMPIO — ho provato a rompere la tesi. Non si rompe.

### Tentativo 1 — «potrebbe essere di un altro conto»
❌ **Fallito**. La catena `C:\FTMO → 541452707 → chart07.chr → InpFile=ABTG_Trades_FTMO.csv` è
stampata in tre referti indipendenti (§2), e **nessun altro esportatore** scrive quel nome.
🟡 *Residuo onesto*: se qualcuno attaccasse un **secondo** esportatore con lo stesso `InpFile`
su un altro terminale, i due si sovrascriverebbero a vicenda **in silenzio** (è il limite 2 di
`CODA_12`). Per questo il controllo §5.2-punto-4 sui simboli **deve restare nella riga per
sempre**, non solo la prima volta.

### Tentativo 2 — «0,4 KB: potrebbe essere SOLO l'intestazione»
❌ **Fallito, e il conto dei byte lo esclude in modo netto.**

- Intestazione (r.177-179) = **142 caratteri + CRLF = 144 byte**.
- Righe dati misurate sul file gemello già in repo (`trades_100k.csv`, stesso esportatore,
  stesso formato): **min 137, max 158, media 147,8 byte** (+2 di CRLF).
- `CODA_12` stampa `[math]::Round($f.Length/1KB,1)` (r.212): **`0.4 KB` ⇒ Length ∈ [358, 461) byte**.

| ipotesi | byte attesi | KB stampati | compatibile con `0.4`? |
|---|---|---|---|
| **sola intestazione** | 144 | **0,1** | ❌ **no** |
| 1 posizione | 283 – 304 | 0,28 – 0,30 → **0,3** | ❌ no |
| **2 posizioni** | **422 – 464** | **0,41 – 0,45 → `0.4`** | ✅ **SÌ, unica** |
| 3 posizioni | 561 – 624 | 0,55 – 0,61 → **0,6** | ❌ no |

👉 **Il file contiene 2 posizioni chiuse.** Non è vuoto, e non è troncato.
🟡 *Margine dichiarato*: i simboli FTMO (`GER40.cash`, 10 caratteri) sono ~4 byte più lunghi dei
BCM (`D30EUR`) e i lotti sono a 2 cifre (`13.67`). Anche col margine peggiore, **3 righe restano
impossibili** e **l'intestazione sola pure**.

### Tentativo 3 — «i 2 numeri potrebbero non tornare con la realtà»
✅ **Tornano**, e da una fonte **indipendente dal CSV**:
`CODA_09_giornale_operativo` — terminale `C:\FTMO`, conto `541452707`:
- **22/09**: `CLAU12_EMA200 (US30.cash,H1)` piazza **SELL LIMIT 1** (lot 9.11) e **SELL LIMIT 2**
  (lot 13.67) alle 08:00. Guardian a fine giornata: `eq=78242.32 dayLoss=2.20% totDD=2.20%
  rischioAperto=0.00%`.
- **23/09 03:30**: `dayLoss=0.00% totDD=2.20% rischioAperto=0.00%`.

👉 **Due ordini, due posizioni chiuse, nessuna aperta, perdita concentrata in un solo giorno.**
80.000 − 78.242,32 = **−1.757,68 EUR = −2,197%**, che combacia col `totDD=2.20%` stampato.
**Il numero di righe predetto dai byte e il numero di operazioni letto dal giornale sono lo
stesso 2, ricavati da due file che non si parlano.** 🟢 La tesi regge.

---

## 7. ✅ COSA SI SBLOCCA — e 🔴 COSA NO, col numero accanto

### 🟢 Si sblocca SUBITO (a qualunque *n*) — il **RISCHIO**
**Criterio di uscita del 18/08, corsia RISCHIO**: *«DD forward > DD promesso dal backtest della
cella promossa → revisione IMMEDIATA»*. È l'unica corsia che **si legge a qualunque n**
(Emendamento B del 16/08). Con `open_time`, `close_time`, `profit`, `magic` e `close_reason`
per posizione, si calcolano **DD realizzato per sedia**, **perdita peggiore**, e **quale sedia
l'ha fatta** — cose che oggi arrivano **da una foto del telefono**
(`report/IL_PIANO_DEGLI_OTTO_GIORNI_2026-09-23.md` r.289, r.557-558).

### 🟢 Si sblocca SUBITO — la **VERIFICA DEL CONTRATTO**
Frequenza **promessa** contro frequenza **misurata**, sedia per sedia, dal primo giorno.
🔴 Ed è **già** una notizia: il roster è di **sei** sedie, e nei primi 3 giorni feriali
(21-22-23/09) **ha operato UNA SOLA** (`771531 EMA200`), con `770101` che ha piazzato un limite
non eseguito il 22/09 e `770260` che ha **saltato** per volumi insufficienti. **Il tagliando dei
6 mesi non aspetta sei mesi per accorgersi di una famiglia muta.**

### 🔴 **NON** si sblocca — il **MERITO**. E questo è il numero, non l'aggettivo.
Ritmo di riferimento misurato su `data/statements/trades_100k.csv` (conto `50504263`, **5**
sedie, 10/08→22/09): **36 posizioni in 31 giorni feriali = 1,16 op/giorno feriale**.
Per le **tre** sedie in comune col roster FTMO: `770101` 0,516 + `770202` 0,097 + `770411` 0,129
= **0,74 op/giorno feriale**. Le altre tre FTMO (`770260`, `770511`, `771531`) **non esistono
sul 100k**: il loro ritmo è **[NON MISURATO]** da questa fonte.

| traguardo | a **0,74** op/gg feriale | a **1,16** op/gg feriale |
|---|---|---|
| **20 operazioni** (soglia MERITO di famiglia, 18/08) | **27 gg feriali ⇒ ~fine ottobre 2026** | 17 gg feriali ⇒ **~metà ottobre 2026** |
| **150 operazioni** (Emendamento A) | 203 gg feriali ⇒ **~luglio 2027** | 129 gg feriali ⇒ **~marzo 2027** |
| **oggi, 23/09** (3 gg feriali dal via) | **2,2 attese** | 3,5 attese |
| **osservate** | **2** ✅ | 2 |

👉 **Alla fine della challenge (01/10) ci saranno fra 6 e 9 operazioni chiuse.** Con quei numeri
**il MERITO resta sospeso**: quel file **non promuove e non boccia niente**. Serve al **RISCHIO**
e al **contratto**. 🟢 E l'osservato che cade dentro l'atteso è **la terza conferma indipendente**
che il file descrive davvero questa challenge.

---

## 8. 🔴 NON COPERTO — per nome

1. **La versione di `C:\ABTG\pubblica_trades.ps1`**: `[NON MISURATO]`. `CODA_11` stampa
   l'impronta **solo** di `runner_abtg.ps1`. Senza quel numero, «copia vecchia» e
   «pubblicazione fallita in silenzio» **restano indistinguibili** (§4). Chiude §5.5.
2. **L'esito della pubblicazione del quarto CSV il 22/09**: `[NON MISURATO]`. L'attività
   riporta `0`, ma per un CSV **facoltativo** `Pubblica-Csv` **non fa `exit 1`** (r.189):
   l'esito `0` non dimostra niente sui file opzionali. Serve la **console della corsa** o
   un `-Verbose` catturato.
3. **Il contenuto letterale del file**: `[NON MISURATO]`. Sul VPS non ci sono andato — **è
   sola lettura per mandato**. Le 2 righe sono **dedotte dai byte** e **confermate dal
   giornale**, non lette.
4. **Da quando gira l'esportatore FTMO**: il `.chr` è del **20/09 18:29**, ma quella è la data
   del **grafico salvato**, non la prova che il terminale sia rimasto acceso. `[NON MISURATO]`.
5. **Il ritmo di `770260`, `770511`, `771531`**: `[NON MISURATO]` da fonte forward. Le tabelle
   di §7 lo dichiarano e **non lo inventano** — le due colonne sono un **intervallo**, non una
   previsione.
6. **Se `ABTG_Trades_Reale.csv` esista**: non compare nel log di `CODA_12`, ma quel filtro
   **lo aggancerebbe** — quindi «non esiste» è **probabile ma non dimostrato**, perché il
   terminale reale potrebbe non avere l'esportatore (coerente con `CODA_01`: solo **3**
   esportatori attaccati). Marcato `[NON MISURATO]`.
7. **`ABTG_Trades.csv` del conto piccolo `50503392`**: **invisibile a `CODA_12`** per il
   difetto D (§3.2). Non sappiamo quante posizioni contenga oggi. `[NON MISURATO]`.
8. **Effetti collaterali della toppa su `CODA_12`**: ho verificato che **nessuno** dei 57
   `FileWrite` di intestazione in `mql5/Experts/` scrive una colonna `pid`, quindi i 141 file
   già contati non cambiano. **Ma la verifica è sul SORGENTE, non sui 143 file veri sul VPS**:
   il collaudo della toppa deve confrontare il referto prima/dopo, riga per riga.

---

## 9. 🎯 COSA PROPONGO (decide Claudio — io non eseguo)

| # | azione | chi | costo | cosa risolve |
|---|--------|-----|-------|--------------|
| **1** | 🖥️ **Riga di sola lettura sul VPS `VMI3047753`** secondo la specifica §5 (contenuto + 4 anelli + 6 controlli + impronta di `C:\ABTG\pubblica_trades.ps1`) | riga scritta da me, **passa dal cancello**, la lancia Claudio | ~1 min | 🟢 Il **RISCHIO** del 18/08 diventa applicabile **oggi**, e si scopre **perché** la pubblicazione non parte |
| **2** | 🔧 Toppa ad `pubblica_trades.ps1` in campo (dipende dall'esito di 1: **ricopiare** oppure **riparare**) | dopo il punto 1 | ~2 min | `trades_ftmo.csv` entra in repo **da solo ogni sera alle 22:45** |
| **3** | 🩹 Toppa A+B+C a `CODA_12` (§3.3) | cancello obbligatorio | 0 tempo macchina | I **due** file di forward vero smettono di essere «NON CONTATO» ogni notte |
| **4** | 🔍 Difetto D + portabilità del filtro (§3.2) | a parte | 0 | Fa entrare `ABTG_Trades.csv` (conto piccolo) |
| **5** | 📌 Classi nuove in `CHECKLIST_RIGA_DI_LANCIO.md` | — | 0 | **«Formato nuovo etichettato come guasto»** (difetto B) e **«l'impronta si stampa solo dello script principale»** (§4) sono **classi nuove**, e la checklist è la memoria |

🟢 **E la buona notizia, che vale detta**: di tutto questo, **niente va costruito**.
L'esportatore gira, il preset è giusto, il file si scrive, il nome è quello che serve, i
`magic` sono le sei sedie, la pubblicazione ha già il codice. **Mancano una riga che guarda e
una copia aggiornata.** Il piano degli otto giorni dava M3 come *«5 min + un gesto di
Claudio in MT5»*: 👉 **il gesto in MT5 non serve più. Era già stato fatto il 20 settembre.**
