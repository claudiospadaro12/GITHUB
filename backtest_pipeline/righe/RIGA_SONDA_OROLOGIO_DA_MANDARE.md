# 📬 **LA SONDA DELL'OROLOGIO** — LA RIGA DA MANDARE

**Che cos'è:** il **PASSO 0** del candidato **P1** della caccia intraday
forex/oro del 28/08 (`caccia_strategie/CACCIA_INTRADAY_FOREX_ORO_2026-08-28.md`,
sezione **"L'OROLOGIO"**, voto **9/10**). È il **primo meccanismo mai proposto in
questo progetto che NON guarda il prezzo**: guarda solo **l'orologio del server**.

> 🔴 **NON È UN ROUND E NON DÀ NESSUN VERDETTO — è una MISURA.**
> Criterio **C7**, congelato prima di vedere i numeri: *"Nessuna promozione da
> questa corsa. Questa sonda non promuove niente e non tocca nessuna sedia viva:
> produce una tabella."* **Nessuna azione sul forward, in nessun caso.**

**La domanda, in una riga:** *"esiste una fascia oraria in cui il **LORDO** medio
per giornata vale almeno **TRE VOLTE** lo spread mediano misurato **IN QUELLA
STESSA ORA**?"* La risposta è **una tabella**, non un P/L.

| | |
|---|---|
| **EA (nuovo, mai compilato)** | `mql5/Experts/ABTG_SondaOrologio.mq5` |
| **Driver** | `righe/RIGA_SONDA_OROLOGIO.ps1` (marcatore `MARCATORE_RIGA_SONDA_OROLOGIO_v3`) |
| **Specifica CONGELATA** | `prove/SONDA_OROLOGIO_FX.txt` — ipotesi, criteri **C1-C7**, date. **Si legge PRIMA della tabella** |
| **File prova (7)** | `prove/SONDA_OROLOGIO_00_GEMELLI.txt` + `_01_EURUSD_LONG` `_02_EURUSD_SHORT` `_03_GBPUSD_LONG` `_04_GBPUSD_SHORT` `_05_XAUUSD_LONG` `_06_XAUUSD_SHORT` |
| **Referto di preparazione** | `prove/REFERTO_PREPARAZIONE_OROLOGIO.md` |

---

## 🕰️ LE SETTE CELLE — tre simboli × due lati, **più il banco**

| cella | simbolo | lato | magic | celle/finestra | a che serve |
|---|---|---|---|---|---|
| **00_gemelli** | EURUSD | long | 777290 / **777291** | 2 | 🔧 **NON misura l'orologio.** Ora e durata inchiodate: collauda il **DETERMINISMO** del banco **ed è il CRONOMETRO** |
| **01_eurusd_long** | EURUSD | LONG | 777201 | 72 | la tabella 24 ore × 3 durate |
| **02_eurusd_short** | EURUSD | SHORT | 777202 | 72 | regola dei due lati (25/08) |
| **03_gbpusd_long** | GBPUSD | LONG | 777203 | 72 | |
| **04_gbpusd_short** | GBPUSD | SHORT | 777204 | 72 | |
| **05_xauusd_long** | XAUUSD | LONG | 777205 | 72 | |
| **06_xauusd_short** | XAUUSD | SHORT | 777206 | 72 | |

Gli **otto magic sono VERGINI**: blocco `7772xx`, cercati **uno per uno** in tutto
il repo il 28/08 → **zero occorrenze**. I magic dei PASSO 0 gemelli
(`7734xx` VWAPREV, `776xxx` FVG) e quelli delle sedie vive sono nella lista dei
**vietati**, e il driver si ferma se ne trova uno.

---

## ⏱️ **LEGGI QUESTO PRIMA DI LANCIARE: LA CORSA È GRANDE, E QUANTO GRANDE NON È MISURATO**

Una cella di misura = **72 celle × 2 finestre = 144 passate a TICK REALI su 15,5
anni di H1**. Sei celle = **864 passate**. È **un ordine di grandezza sopra
qualunque round di casa** (R107: 24 passate a tick reali su 21 mesi in 9 minuti).

🔴 **Quanto costi una passata su 15,5 anni di tick forex in casa NON È MAI STATO
MISURATO. Non è una stima prudente: è un'ignota.** Per questo il driver ha
**quattro modi**, e il **default è il più piccolo**:

| modo | come si chiede | cosa gira | a che serve |
|---|---|---|---|
| **CONTROLLO** | `-SoloControllo` | niente tester, ma **COMPILA** | il primo risultato vero: l'EA non è mai stato compilato |
| **RICOGNIZIONE** | *(default, nessun interruttore)* | solo `00_gemelli`, **4 passate** | determinismo **+ CRONOMETRO** |
| **CORSA** | `-SoloCella '<id>'` oppure `-TutteLeCelle` | quella cella / tutte e sette | la misura |
| **RICOMPOSIZIONE** | `-Ricomponi` | **NIENTE: zero passate, zero compilazioni** | rilegge i CSV già fatti e dà **C1 sui tre simboli insieme** |

> 🔴 **Da oggi (v3) ogni corsa RIFÀ DAVVERO.** Il driver chiama sempre
> `walkforward_generico.ps1` con **`-Rifai`**: mai più una passata saltata in
> grigio (*"già fatto, salto"*) e impacchettata come fresca — è la classe che
> nella saga CRT ha prodotto **quattro corse dichiarate eseguite e mai partite**.
> Conseguenza pratica: **`-TutteLeCelle` non è più un modo per "ricomporre"**, è
> 868 passate vere. Per ricomporre c'è `-Ricomponi`, che non apre il tester **per
> costruzione** e lo dichiara riga per riga col **timestamp di ogni CSV riletto**.

> ✅ **L'ORDINE GIUSTO È: 1️⃣ controllo → 2️⃣ ricognizione → leggi il cronometro →
> 3️⃣ una cella alla volta.** Il referto della ricognizione stampa
> *"N s per passata → una cella di misura costerebbe circa X minuti, e le SEI
> celle circa Y ore"*. **Con quel numero in mano la decisione è tua**, non di uno
> script che parte per tre giorni.

---

## 📌 IL PIN — **`f81eb7024257767c917a15d56b9ac43df3bb9500`**

```
f81eb7024257767c917a15d56b9ac43df3bb9500
```

⚠️ **Il pin si rilegge DOPO il push, non prima.** Il commit pinnato deve contenere
**tutti e dieci** gli artefatti che lo script scarica: `walkforward_generico.ps1`,
`RIGA_SONDA_OROLOGIO.ps1`, i **sette** file prova e
**`mql5/Experts/ABTG_SondaOrologio.mq5`** (che il driver generico riscarica **al
pin**, perché la riga gli riscrive dentro `$EABranch`).

La riga passa il pin a `-Pin` e **si rifiuta di partire senza**: un default
silenzioso (`lavoro`) farebbe girare la punta del branch spacciandola per un
commit congelato.

### ♻️ LA RICETTA DI **RI-PINNATURA** — se un artefatto viene corretto

```bash
F=backtest_pipeline/righe/RIGA_SONDA_OROLOGIO_DA_MANDARE.md
NUOVO=<il commit nuovo, 40 caratteri>
VECCHIO=$(grep -oE "\\\$pin='[0-9a-f]{40}'" "$F" | head -1 | grep -oE '[0-9a-f]{40}')
echo "vecchio: $VECCHIO"
sed -i "s|\$pin='$VECCHIO'|\$pin='$NUOVO'|g; s|^$VECCHIO\$|$NUOVO|; s|\*\*\`$VECCHIO\`\*\*|\*\*\`$NUOVO\`\*\*|g" "$F"
grep -c "\$pin='$NUOVO'" "$F"    # DEVE dare 4 (controllo, ricognizione, cella, ricomposizione)
grep -c "f81eb7024257767c917a15d56b9ac43df3bb9500" "$F"           # DEVE dare 0 (nessun segnaposto sopravvissuto)
grep -c "\$pin='$VECCHIO'" "$F"  # DEVE dare 0
```

⚠️ **Servono TUTTI E DUE i conteggi**: il solo *"0 pin vecchi rimasti"* lo supera a
mani basse anche un `sed` che **non ha matchato niente**.
🔴 **E il perimetro della ricetta è UN FILE SOLO — questo (CHECKLIST punto 100).**
Prima di dichiarare fatto un ri-pin, sempre:
```
grep -rn "RIGA_SONDA_OROLOGIO.ps1" --include=*.md .    # chi porta una copia della riga?
grep -rn "<pin vecchio>" .                             # DEVE dare 0
```
Il **referto di preparazione NON contiene il blocco di lancio**, apposta: cita
questa pagina e basta. Un link non scade, un blocco `powershell` sì.

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** Col terminale aperto il tester non
  gira (zero CSV); con MetaEditor aperto la compilazione torna subito **senza
  compilare**. La riga si rifiuta di partire in tutti e due i casi.
- 🔴 **L'EA NON È MAI STATO COMPILATO DA NESSUNO.** Scritto il 28/08 in un
  ambiente **senza MetaEditor e senza Strategy Tester**. **Per questo il giro di
  controllo COMPILA DAVVERO**: è il primo risultato vero di questo PASSO 0.
  Lo script cancella l'`.ex5` prima di compilare (un binario vecchio farebbe
  passare per riuscita una compilazione fallita) e, se fallisce, **stampa in
  rosso le ultime 40 righe del log di MetaEditor** e si ferma. **Se la
  compilazione fallisce, il risultato del PASSO 0 è quello** e va riportato così
  com'è — non è un guasto della riga.
- 🧩 **Nessun include da installare.** Questa sonda **non** usa
  `ABTG_PausaGuardian.mqh`, ed è voluto: non deve mai stare su un grafico vivo.
- 🎯 **Il terminale è scelto con lo STESSO selettore di
  `walkforward_generico.ps1`** (`*BCM Markets MT5 Terminal*` escludendo `*-V3*`,
  ripiego `*BCM Markets*`), e la riga **lo stampa**: deve essere lo stesso che
  stampa poi il driver generico.
- **NESSUNA SEDIA VIVA VIENE TOCCATA.** Magic vergini `7772xx`,
  `AllowLiveTrading=false` negli `.ini` (lo scrive il driver generico).
- 📐 **Finestra `2011.01.01 → 2026.06.30`, split 40/60, `Model=4` (tick reali),
  deposito `100.000`, rischio `InpRiskPercent = 1.0`** — e quel numero è **letto
  dal file prova**, dove morde davvero.
- ♻️ **Se il pin cambia, la cache di `%USERPROFILE%\abtg_sonda_orologio` viene
  CANCELLATA** (file prova e CSV del pin vecchio). Senza, il gate di idempotenza
  del driver generico riproporrebbe i CSV di ieri come se fossero di oggi.
- 🔧 Se non è già stato fatto: MT5 → Strumenti → Opzioni → Grafici →
  **"Max barre nel grafico" = Illimitato**.
- 🧹 **La riga svuota `Tester\cache` prima di ogni corsa e scrive i DUE conteggi
  nel referto** (`cache tester: prima N file, dopo 0`). Non è precauzione
  generica: il CSV di questa famiglia nasce dai **FRAME**, e un pass ripescato
  dalla cache **non chiama `OnTester()`**, quindi non manda il frame e la sua
  riga **sparisce dal CSV** — con la corsa verde. Lo **storico** (`bases\...\ticks`)
  **non viene toccato**.
- 🔴 **LA PROFONDITÀ DEI TICK NON È MISURATA su questi tre simboli, e tocca il
  metro.** Il tick **nativo** BCM agli atti parte dal **2024.09.26** (R109 § D2,
  R97); la finestra parte dal **2011**. A `Model=4` senza tick reali **MT5 non si
  ferma**: genera i tick dalle barre M1. Il **lordo** (deriva bid→bid) regge; lo
  **spread mediano**, che è **metà del cancello C1**, nel tratto pre-2024.09.26
  **non è lo spread del tick**. La riga alza da sola un **RILIEVO** che lo dice, e
  il numero si legge con quell'etichetta attaccata — soprattutto sulla gamba
  **IS**, che è tutta nel tratto vecchio.

---

## 1️⃣ PRIMA il giro di controllo (**COMPILA, non apre il tester**)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='f81eb7024257767c917a15d56b9ac43df3bb9500'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDA_OROLOGIO.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDA_OROLOGIO.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDA_OROLOGIO_v3' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo -TutteLeCelle; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SONDA_OROLOGIO_CONTROLLO_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDA_OROLOGIO_CONTROLLO_ DI ADESSO: la riga non e'' arrivata alla raccolta' };
    if($rc -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Mandami questo zip:' -ForegroundColor Red; Write-Host $z[0].FullName -ForegroundColor Yellow }
    else { Write-Host 'CONTROLLO OK: si passa al blocco 2.' -ForegroundColor Green };
    Write-Host ('ZIP: ' + $z[0].FullName) -ForegroundColor Cyan; }
```

**Cosa deve dire**, in ordine:

- `pin ......... <40 caratteri>` e `celle ....... 7 su 7`;
- `driver generico scaricato e PINNATO`;
- `file prova scaricati: 7 su 7`;
- 🔴 **`geometria, assi, griglia letterale, lati, baseline assoluta, elenco chiuso e magic: TUTTI PASSATI su 7 file su 7`**;
- `terminale scelto: C:\Program Files\BCM Markets MT5 Terminal` — ⚠️ **è il
  numero da confrontare** con quello che stampa poi il driver generico;
- 🔴 **`compilato ABTG_SondaOrologio: OK (...)`** ← **è questa la riga che conta.**
  Se invece esce `COMPILAZIONE FALLITA`, sopra ci sono in **rosso** le ultime 40
  righe del log di MetaEditor: **copiale in chat, sono il risultato**;
- sette volte l'anteprima dell'`.ini` del driver generico, e in fondo
  `ESITO: CONTROLLO COMPLETATO`.

> ⚠️ **Quello che il giro di controllo NON può fare:** `-SoloControllo` **non apre
> il tester**. Nessun `n`, nessuna tabella, **nessuna colonna di collaudo** e
> **nessun gemello** (il CSV lo produce solo la corsa). Conferma gli **artefatti**
> e la **compilazione**, mai i numeri.

---

## 2️⃣ POI la **RICOGNIZIONE** — 4 passate, ed è il cronometro

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='f81eb7024257767c917a15d56b9ac43df3bb9500'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDA_OROLOGIO.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDA_OROLOGIO.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDA_OROLOGIO_v3' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=0; & $p -Pin $pin; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SONDA_OROLOGIO_RICOGNIZIONE_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDA_OROLOGIO_RICOGNIZIONE_ DI ADESSO: la riga non e'' arrivata alla raccolta' };
    if($rc -ne 0){ Write-Host 'PARZIALE O CON PROBLEMI: lo zip esiste lo stesso, mandalo e leggi i PROBLEMI nel REFERTO.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'POI nel REFERTO: riga data: = adesso, riga modo: = quello che ti aspetti.' -ForegroundColor Gray; }
```

**Le due righe da guardare nel referto:**

1. **`gemelli: IDENTICI`** → il banco è deterministico e i numeri delle altre sei
   celle si potranno leggere. Qualunque altra cosa (`DIVERSI su ...`,
   `NON VALIDO: 1 righe invece di 2`) → **ci si ferma qui**;
2. **`cronometro: ... s per passata -> una cella di misura (144 passate)
   costerebbe circa X minuti, e le SEI celle circa Y ore`** ← **è il numero su cui
   si decide.**

---

## 3️⃣ POI la misura, **UNA CELLA ALLA VOLTA**

Si cambia **solo** il nome dentro `-SoloCella`. Gli id validi sono nella tabella
in cima: `01_eurusd_long`, `02_eurusd_short`, `03_gbpusd_long`,
`04_gbpusd_short`, `05_xauusd_long`, `06_xauusd_short`.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='f81eb7024257767c917a15d56b9ac43df3bb9500'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDA_OROLOGIO.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDA_OROLOGIO.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDA_OROLOGIO_v3' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloCella '01_eurusd_long'; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SONDA_OROLOGIO_CORSA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDA_OROLOGIO_CORSA_ DI ADESSO: la riga non e'' arrivata alla raccolta' };
    if($rc -ne 0){ Write-Host 'PARZIALE O CON PROBLEMI: lo zip esiste lo stesso, mandalo e leggi i PROBLEMI nel REFERTO.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'POI nel REFERTO: riga data: = adesso, riga modo: = quello che ti aspetti.' -ForegroundColor Gray; }
```

> ⚠️ **Ogni ripresa è un BLOCCO INTERO, col suo `irm`.** `$p` e `$pin` nascono
> **dentro** il `& { ... }`, che è uno scope figlio: quando quel blocco finisce
> **non esistono più**. E si incolla **il blocco INTERO**: è **un comando solo**;
> tre righe staccate sarebbero tre comandi indipendenti, e un `throw` alla prima
> non fermerebbe le altre.

🟡 **`-TutteLeCelle` esiste** (le sette di fila, un solo zip) **ma si usa solo
DOPO aver letto il cronometro.** Al buio sono 868 passate — e da oggi le
**rifà tutte davvero** (`-Rifai` è sempre nell'argv): non è più una scorciatoia
per rileggere. **Per rileggere c'è il blocco 4.**

---

## 4️⃣ **RICOMPOSIZIONE** — dopo che le SEI celle di misura sono girate

> 🔴 **C1 è un criterio DI INSIEME ("almeno due simboli su tre"), e ogni riga di
> lancio sopra gira UNA cella alla volta.** Sei lanci con `-SoloCella` producono
> **sei referti separati**, nessuno dei quali ha il verdetto C1 su tutti e tre i
> simboli insieme. Serve un settimo lancio, **DOPO** i sei, che li rilegge TUTTI.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='f81eb7024257767c917a15d56b9ac43df3bb9500'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDA_OROLOGIO.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDA_OROLOGIO.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDA_OROLOGIO_v3' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -Ricomponi; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SONDA_OROLOGIO_RICOMPOSIZIONE_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDA_OROLOGIO_RICOMPOSIZIONE_ DI ADESSO: la riga non e'' arrivata alla raccolta' };
    if($rc -ne 0){ Write-Host 'PARZIALE O CON PROBLEMI: lo zip esiste lo stesso, mandalo e leggi i PROBLEMI nel REFERTO.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'POI nel REFERTO: riga data: = adesso, riga modo: = quello che ti aspetti.' -ForegroundColor Gray; }
```

- ✅ **QUASI ISTANTANEO, E PER COSTRUZIONE**: `-Ricomponi` **non chiama nemmeno**
  il driver generico, **non apre MT5**, **non compila**. Rilegge i CSV già
  prodotti dalle sei corse precedenti e ricalcola C1. Nel referto lo dichiara in
  chiaro: `modo: RICOMPOSIZIONE`, `cronometro: non pertinente`, e per **ogni
  cella** la riga `il tester ha girato in questo giro: NO, ED È IL MESTIERE DI
  QUESTO MODO: CSV riletti, scritti il <data e ora>`. **Quelle date sono il
  controllo di freschezza**: se una è di un giro che credevi di aver rifatto,
  quella cella va rilanciata.
- 🔴 **Se una cella non è ancora stata girata**, `-Ricomponi` la mette nei
  **PROBLEMI** (`QUESTA CELLA NON È ANCORA STATA GIRATA`) ed esce **1**: il
  cancello C1 d'insieme **non si legge** finché ne manca una.
- 🔴 **IL PIN DEVE ESSERE LO STESSO** usato per le sei celle di misura. Con un pin
  diverso la riga **cancella `risultati_prove\`** e le sei celle già girate **sono
  perse**: un ri-pin a metà round significa ricominciare da capo.
- Il referto che torna da questo settimo lancio è quello che riporta **C1 su
  tutti e tre i simboli** — è quello da guardare per il verdetto d'insieme,
  non i sei referti parziali.

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul **Desktop**: `SONDA_OROLOGIO_<MODO>_<data>_<ora>` — dentro:

- **`REFERTO_SONDA_OROLOGIO.txt`** ← **è questo che conta**;
- i **file prova** delle celle che hanno girato;
- i **CSV** `ABTG_SondaOrologio_<SIMBOLO>_IS_<cella>.csv` e `_OOS_<cella>.csv`.

### 📅 Le righe da guardare per prime nel referto

1. **`modo:`** — `CORSA` (il risultato) / `RICOGNIZIONE` (solo banco e cronometro)
   / `CONTROLLO` (giro a vuoto: **non si manda come risultato**) /
   `RICOMPOSIZIONE` (rilettura dichiarata: **nessun numero nuovo**);
2. **`data:`** — **deve essere di ADESSO** (è la riga che il 17/08 ha fatto
   rimandare due volte un referto stantio in buona fede);
3. **`cache tester:`** — `prima N file, dopo 0`. Se dice *"NON si è svuotata"* è
   nei **PROBLEMI**: i conteggi delle righe del CSV vanno riguardati a mano;
4. **`il tester ha girato in questo giro:`** (una per cella) — in `CORSA` e
   `RICOGNIZIONE` deve dire **SI**. Un **NO** lì è un **PROBLEMA** e vuol dire
   che quei numeri vengono da un altro giro.

---

## 🔬 IL COLLAUDO STA NEL REFERTO, **IN COLONNE** — non nella scheda Esperti

⚠️ **La scheda Esperti qui NON si guarda, ed è misurato perché:** in
**ottimizzazione** le `Print` girano **sugli agent** e non le legge nessuno
(CHECKLIST punti 34 e 99). Per questo l'EA porta il collaudo **dentro il CSV**, e
il driver ne fa dei **gate**:

| colonna | come si legge |
|---|---|
| **`Autotest Falliti` = 0** | gli **8 blocchi** dell'autotest del nucleo sono passati: i numeri della tabella **si leggono** |
| **`Autotest Falliti` > 0 o mancante** | **DIVERGE**: i numeri **NON si leggono** → finisce nei **PROBLEMI** |
| 🔴 **`Notti Attraversate` = 0** | la **chiusura forzata di fine giornata** è stata **ermetica**. Un valore > 0 significa **posizione viva a cavallo della notte**: il mandato FTMO *"mai overnight"* non è rispettato, e il driver lo mette nei **PROBLEMI** |
| **`Giorni Saltati Spread` = 0** | canarino: il filtro di spread è pinnato a 0. Se è > 0, **il file prova che ha girato non è quello che credevamo** |
| **`Uscite Stop O Orfane`** | lo stop di 10 ATR doveva essere un **paracadute mai aperto**. Se morde su più dell'1% delle operazioni → **RILIEVO**: la sonda sta misurando anche lo stop |
| **`Giornate Operate` ≥ 150** | criterio **C5**, per fascia **e per metà IS/OOS**. Sotto → **RILIEVO**, il **MERITO** di quella fascia resta sospeso (il **RISCHIO** no) |

---

## 🚩 COME SI LEGGE LA TABELLA — cinque avvertenze, non cinque note

1. 🕐 **L'ORA È IN ORA SERVER FISSA, e l'errore è dichiarato (criterio C6).**
   Server BCM = **ora italiana − 1**. Gli uffici di Londra e New York si spostano
   rispetto all'ora server per **~4 settimane l'anno** (ora legale USA e UE non
   coincidenti; il Giappone non cambia). **La sonda NON corregge: dichiara.**
2. 📏 **Il "lordo" è la deriva sul BID**, non il risultato eseguito: bid
   all'ingresso contro bid all'uscita, nei due versi. Lo spread resta **fuori**
   dalla misura **apposta**, perché C1 lo confronta a parte — misurare il
   risultato eseguito lo conterebbe **due volte**. E la media è sulle **giornate
   operate**, non sulle giornate di calendario.
3. ⚖️ **La `Peggior Giornata %` è CONDIZIONATA ALLA TAGLIA.** Il lotto esce da un
   rischio dell'1% su uno stop di **10 ATR**, quindi è piccolo, e la percentuale è
   piccola con lui. **Non è il rischio di una versione operabile**: quella avrebbe
   uno stop diverso e lotti diversi. Il numero si riporta lo stesso (**C4**: il
   rischio si riporta sempre), ma con questa etichetta attaccata.
4. ✂️ **`Ore Medie Tenuta` dice quali fasce il flat ha TRONCATO.** Un ingresso
   alle 20:00 con blocco da 12 ore vorrebbe uscire alle 08:00 del giorno dopo: la
   chiusura forzata delle **23:29 server** lo taglia. **Non è un guasto, è il
   mandato** — ma quelle celle misurano un blocco più corto di quello scritto in
   colonna, e la tabella lo dice.
5. 🎯 **C1 è il CANCELLO ZERO, non il verdetto.** Il driver lo **conta** (per IS,
   per OOS e per **entrambe** — il criterio congelato non dice quale, e la scelta
   è di chi firma). ⚖️ **E lo conta nella LETTURA SEVERA**: *"almeno una fascia
   oraria, su almeno due dei tre simboli"* vuol dire **la STESSA fascia** (stessa
   ora **e** stessa durata) sopra soglia su **≥ 2 simboli**. La lettura larga —
   due simboli verdi ciascuno su un'ora **sua** — è stampata accanto, **etichettata
   `NON è il verdetto`**. È una scelta **dichiarata**: quando un criterio congelato
   copre lo stesso caso con due clausole, vince **la più severa** (classe del
   31/08: l'ambiguità sciolta dal lato che promuove è quella che nessuno
   ricontrolla). Misurato sul banco: con EURUSD verde alle 8 e GBPUSD verde alle
   15 la **v2 scriveva `C1 PASSATO`**; la v3 scrive `NON PASSATO` nella severa e
   dichiara il 2 nella larga. **C2 e C3 il driver NON li adjudica**, e non può:
   - **C2** — la cella vale **solo se è quella che la TESI aveva indicato PRIMA**
     (ore europee per EUR, ore londinesi per GBP, ore americane per USD). Se l'ora
     verde **non** è quella prevista, il round è **NEGATIVO** anche col numero
     positivo: 24 ore × 3 simboli × 2 lati = **144 celle**, a caso qualcuna è verde.
   - **C3** — **altopiano, non picco**: la fascia buona deve avere **ore adiacenti
     dello stesso segno**. Un'ora verde isolata fra due rosse è rumore.

> 🟢 **E se la tabella è PIATTA, l'esito è VALIDO e va scritto così:** il caduto
> **D7** (l'ora del fix, chiuso il 22/08) esce **CONFERMATO ED ESTESO** e la pista
> dell'orologio **si chiude con un numero NOSTRO**. È un risultato, non un
> fallimento.

---

## ✅ COSA È GIÀ STATO VERIFICATO — **eseguendo**, prima dell'invio

**Prima passata (28/08), sul driver v2:**

- ✅ il `.ps1` **parsa**: PowerShell 7.4.6 + `[Parser]::ParseFile` → **0 errori**;
  **ASCII puro** (0 byte non-ASCII, regola del 17/08); **non usa `$args`**;
  **0 collisioni case-insensitive** fra nomi di variabile (punto 79);
- ✅ **e i gate sono stati fatti FALLIRE, uno per uno** — un gate che non scatta
  mai non è dimostrato. **Diciannove corruzioni, diciannove fermate**;
- ✅ **`stats[26]`, l'header a 28 colonne e lo `StringFormat` a 28 specificatori**
  contati a macchina: **28 = 28 = 28**, `stats[0..25]` tutti assegnati e contigui;
- ✅ **scan delle ridichiarazioni nello stesso scope MQL5** (punto 98): **zero**;
  graffe/tonde/quadre bilanciate; **nessun input orfano** (16 su 16 usati).

**Seconda passata (31/08), contro le ~15 classi nuove della checklist — driver
riscritto a `v3` ed ESEGUITO su un banco stubbato** (finto MetaEditor, finto
`walkforward_generico.ps1`, CSV OPTFRAME sintetici con l'**intestazione vera**
dell'EA):

- 🔴 **DIFETTO BLOCCANTE trovato e corretto: `-Rifai` non era nell'argv** (classe
  zombie-run del 31/08). **Misurato**: con i CSV di ieri sul disco e il generico
  che salta, la v2 usciva **`PROBLEMI: 0` · `ESITO: CORSA COMPLETATO`** (verde,
  exit 0) impacchettando numeri vecchi. La v3 esce **7 PROBLEMI, exit 1**, uno per
  cella, con la **data dei CSV** nel messaggio;
- 🔴 **DIFETTO BLOCCANTE trovato e corretto: la RICOMPOSIZIONE si reggeva proprio
  su quel salto** (`-TutteLeCelle` + cache del generico). Ora è un modo suo,
  **`-Ricomponi`**, che non chiama il generico **per costruzione**;
- 🟠 **C1 contato nel verso che PROMUOVE** (classe del 31/08). **Misurato**: con
  EURUSD sopra soglia alle **8** e GBPUSD alle **15** — due ore **diverse** — la v2
  scriveva **`C1 PASSATO`**. La v3 conta la **lettura severa** (stessa fascia) e
  scrive `NON PASSATO`, stampando la larga accanto ed etichettata;
- 🟠 **finestra ereditata dal default del generico** (`2026.06.30` è anche il
  default di `walkforward_generico.ps1`): ora **`@FINOA` è NUDA nei sette prova**,
  accanto a `@DAQUANDO`, e il driver la **gatta**;
- 🟠 **`Tester\cache` non veniva svuotata**: aggiunta col **doppio conteggio** nel
  referto (qui morde davvero — i CSV nascono dai **frame**);
- 🟠 **il CSV si contava, non si guardava dentro**: nuovo gate che pretende
  **tutte** le 24 ore × 3 durate e la colonna **`Lato`** giusta per la cella;
- 🟡 **RILIEVO nuovo, automatico**: profondità dei **tick** non misurata
  (tick nativo BCM dal **2024.09.26**, finestra dal **2011**) → lo **spread** del
  tratto vecchio non è quello del tick, ed è **metà di C1**;
- ✅ **batteria di mutazioni rifatta sulla v3: 14 corruzioni dei file prova, 14
  fermate**, ognuna col messaggio giusto (@FINOA tolta, @FINOA diversa, @DAQUANDO,
  @SIMBOLO scambiato, griglia stretta, magic vietato, magic duplicato, baseline
  dello stop, parametro di prezzo intruso, riga a 4 campi, lati scambiati, asse in
  più, asse mancante, gemelli ridotti a uno) **+ 6 guardie del driver** (pin
  assente, pin corto, `-Periodo` diverso, cella inesistente, `-Ricomponi` mescolato
  con gli altri interruttori ×2);
- ✅ **controllo positivo ri-eseguito prima e dopo** ogni corruzione: `ESITO:
  CONTROLLO COMPLETATO`, exit 0;
- ✅ scenari eseguiti sul banco: gemelli identici / gemelli divergenti / gemelli a
  zero operazioni / collaudo rotto (autotest, notti, spread) / CSV monco /
  ricomposizione con una cella mancante / corsa di una cella sola.

🟡 **Non verificato, e va detto**: tutto ciò che richiede **MT5** — la
**compilazione** dell'EA (qui non c'è MetaEditor), l'esito dell'**autotest**, il
comportamento del **flat sui tick veri**, **se i tick reali arrivino davvero fino
al 2011** (vedi il rilievo qui sopra: è la cosa che più può cambiare la lettura di
C1), la **durata** e **ogni singolo numero**. Il giro di controllo copre gli
artefatti **e la compilazione**; **i numeri li può dare solo la corsa**.
