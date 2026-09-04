# 🎯 RELATIVO — **R117: LA PRIMA MISURA DI MERITO, A TICK REALI** (la riga da mandare)

> ## ⚠️ QUI L'EA APRE ORDINI.
> Tutto quello che è girato finora su RELATIVO era un **contatore puro**
> (`ABTG_SondaRelativo`): zero ordini, zero lotti, zero magic. Da qui in poi gira
> `ABTG_Relativo`, che **manda ordini veri, calcola lotti, ha un magic e mette
> stop loss sul broker**. I due file condividono il **nucleo statistico riga per
> riga** — ed è proprio quella condivisione che il **collaudo del porto** (blocchi
> 2 e 3) va a verificare prima di ogni altra cosa.
>
> **Nel tester non si rischia niente. Ma questo `.ex5` è, da oggi, un file che
> sa aprire posizioni: non va messo su un grafico per sbaglio.**

**La domanda del round, in una riga:**

> *Lo scarto fra una gamba (D30EUR o NASUSD) e il metro U30USD, quando supera
> 1,35 sigma dentro la sessione americana, rientra abbastanza spesso — e
> abbastanza in fretta — da produrre `E ≥ 0,075R` per operazione **a tick reali,
> pagando lo spread vero del broker**?*

Il passo 0 (chiuso il 04/09) ha misurato **portata, taglia, geometria,
convergenza e tenuta** su 4 finestre × 49 celle e poi su 2 × 90. **Non ha mai
emesso un euro di P/L**, per costruzione. Questa è la **prima volta che si
guarda il conto**.

## 📋 LA CELLA, E DA DOVE VIENE

| | |
|---|---|
| **cella, per ENTRAMBE le gambe** | **`InpFinestraN = 40`, `InpSogliaIngressoSigma = 1.35`** — congelata |
| perché questa | è un vertice di un blocco 2×2 vivo su **tutte e quattro** le mappe (D30 L/S, NAS L/S) della griglia estesa a 90 celle, **interno su entrambi gli assi**, e ha **16 vicini ortogonali vivi su 16** |
| il pareggio fra i 4 vertici | rotto con due criteri dichiarati prima (più occasioni/giorno, C6 più basso): **N=40/σ=1,35 domina su entrambi e su entrambe le gambe** |
| **stop reale** | `InpAtrSL = 2.75` × ATR ≈ **47,1 pti su D30EUR**, **74,2 su NASUSD**. Deriva da **2 × MAE mediana misurata** (1,32-1,55 ATR) |
| **tetto giornaliero** | `InpMaxTradesPerDay = 5`. **Non è una preferenza, è aritmetica:** il passo 0 ha misurato **10 occasioni/giorno** su D30EUR, e 10 × 0,65% = **−6,50%**, che sfonda il muro prop giornaliero del 5% |
| rischio | **0,65%**, la taglia di campo: così il drawdown si legge contro il muro prop **senza scalature inferite** |
| magic | **774601** (D30) · **774602** (NAS) · 774611/774612 (gemelli) · 774603/774604 (porto). Blocco **7746xx verificato VERGINE** |

Dettaglio completo, con tutti i numeri e i rilievi:
`report/PROPOSTA_RELATIVO_TICK_REALI_2026-09-04.md`.

## 🔢 IL NUMERO CHE STA IN CIMA, PRIMA DI TUTTI GLI ALTRI

| | **D30EUR** | **NASUSD** |
|---|---:|---:|
| 1R proposto (2,75 × ATR) | **47,1 pti** | **74,2 pti** |
| MFE mediana in R (= **tetto** del guadagno) | 0,499 / 0,541 R | 0,501 / 0,497 R |
| **spread misurato** (ora peggiore) | **2,80 pti = 0,059 R** | **1,80 pti = 0,024 R** |
| **costo / cancello H8 (0,075R)** | 🔴 **79%** | 🟢 **32%** |
| **win rate che serve per pareggiare** | **68,7 – 70,7%** | **68,2 – 68,4%** |
| convergenza misurata al passo 0 | 80,3% | 82,0% |

> 🔮 **LA PREVISIONE, SCRITTA PRIMA DEI NUMERI (falsificabile):**
> 1. **NASUSD ha molte più probabilità di sopravvivere di D30EUR.** Non è
>    un'impressione: lo spread di NASUSD mangia un terzo del cancello, quello di
>    D30EUR ne mangia quattro quinti — e il DAX, dalle 17 server in poi, è **fuori
>    dal suo cash** per due terzi della nostra sessione.
> 2. **Il numero che decide il round è `guadagno realizzato per vincente / MFE
>    mediana`.** Sotto ~**0,70** la geometria non regge il costo. **È una colonna
>    obbligatoria**, e il referto la stampa da sola.
> 3. **Se il round muore, muore sul COSTO, non sul segnale** — e sarà un verdetto
>    pieno e utile.

## 🚦 SEI CORSE, E OGNUNA HA UN COMPITO DIVERSO (non sono sei tentativi)

| # | `-Prova` | gamba | magic | ruolo |
|---|---|---|---|---|
| 2 | `D30_PORTO` | D30EUR | 774603 | 🥇 **collaudo del porto** — `InpModoSonda=true`: **nessun ordine** |
| 3 | `NAS_PORTO` | NASUSD | 774604 | 🥇 **collaudo del porto** |
| 4 | `D30` | D30EUR | 774601 | **la misura** |
| 5 | `D30_GEM` | D30EUR | 774611 | **gemello di determinismo** |
| 6 | `NAS` | NASUSD | 774602 | **la misura** |
| 7 | `NAS_GEM` | NASUSD | 774612 | **gemello di determinismo** |

> ### 🥇 **IL COLLAUDO DEL PORTO — è il gate più importante, e va per primo**
> L'EA conta gli attraversamenti **grezzi** e non apre niente. Quel numero deve
> venire **identico** a `Attraversamenti Grezzi Long/Short` del passo 0, sulla
> stessa cella e sulla stessa finestra: **lo z-score si calcola su barre CHIUSE,
> e il modello di tick non lo tocca.** Se non combacia, il nucleo statistico è
> stato trasportato male e **tutto il resto del round non vuol dire niente.**
>
> 🔴 **PRIMA DI LANCIARE, UNA COSA VA FATTA A MANO** (e la riga lo dichiara da
> sola se non è stata fatta): i due numeri attesi vanno presi dal **CSV OPTFRAME
> del passo 0** (dentro lo zip `RELATIVO_GRIGLIA_ESTESA_...`, riga
> **N=40 / σ=1.35**, colonne `Attraversamenti Grezzi Long` e `... Short`) e
> scritti nella tabella `$PORTO` in testa a `RIGA_RELATIVO_R117.ps1`. Finché
> valgono **−1**, il collaudo **non si esegue** e il referto scrive
> **"NON ESEGUITO, E NON È UN VERDE"** — che è meglio di un verde che non ha
> misurato niente.
>
> ⚠️ **La tolleranza non è zero, ed è dichiarata:** il passo 0 girava la finestra
> intera in una passata sola, qui il generico la spezza in IS e OOS e la passata
> OOS riparte col suo warmup. Intorno alla giuntura qualche attraversamento può
> mancare: tolleranza **0,5% della somma attesa, minimo 20**.

> ### 👯 **I GEMELLI — perché due corse identiche non sono uno spreco**
> Due passate con gli **stessi input** e **magic diverso** devono venire
> **identiche al centesimo**. Se divergono, il banco è sporco e **nessun numero
> di questo round vale, per bello che sia.** Il confronto lo fa a macchina la
> **seconda corsa della coppia** (il CSV della prima è già in workdir): per
> questo l'ordine dei blocchi **4-5** e **6-7** non si inverte.

## 📏 I CANCELLI, CONGELATI PRIMA DEI NUMERI

Stanno **nella riga di lancio e nella pagina, NON dentro l'EA** — apposta: un
cancello scritto dentro il codice misurato è un cancello che si sposta con lui.
E la riga li **ricalcola dai numeri grezzi** invece di fidarsi di una colonna
già cucinata.

| # | soglia | da dove esce il numero |
|---|---|---|
| **A1** | `E` OOS **≥ 0,075 R**, a tick e **al netto** dei costi | FIRMA 2 del 31/08 (cancello H8) |
| **A2** | PF OOS **≥ 1,15** | cancello storico di casa 1,10 + margine di rumore |
| **A3** | segno del profitto **coerente** fra IS e OOS, e **PF IS > 1,00** | lezione USDJPY di R20: *IS rosso + OOS verde è la configurazione più pericolosa* |
| **A4** | DD equity OOS **≤ 8,0%** a rischio 0,65% | muro prop **10%** meno il 20% di margine |
| **A5** | peggior giornata **non peggiore di −4,0%** | a 4,0% il **Guardian mette in pausa**: una giornata peggiore descrive una giornata che **sul campo non sarebbe esistita** |
| **A6** | **n ≥ 150** in IS **e** in OOS | Emendamento della Finestra, regola A |
| **A7** | quota sotto 60 s **< 25%** | vincolo prop P5. A M5 **deve venire 0,00**: è un collaudo, non una scoperta |

**Bocciatura secca (basta una):** `E` < 0,050R · PF < 1,10 · IS negativo ·
**DD > 10,0%** · **peggior giornata < −5,0%**.
🔴 **Le ultime due bocciano PER RISCHIO, qualunque sia il PF e qualunque sia `n`:
il giudizio di rischio non si sospende mai** (Emendamento, regola B).
`n < 30` **non è una bocciatura**: è **non misurabile**.
Fra "passa" e "bocciata secca" c'è **sempre** una **zona morta** esplicita.

## 🚫 COSA QUESTO ROUND **NON** POTRÀ DIRE

1. ❌ **"Regge nel tempo".** I tick reali degli indici BCM partono dal
   **2024.09.26**: **un solo regime (toro)**. Emendamento regola C: **non
   soddisfatta**. → **Da questo round NON esce una sedia**, al massimo una
   **candidata**, e solo dopo una prova di rischio su un regime ostile e dopo il
   forward demo.
2. ❌ **"L'OOS lo conferma".** L'OOS **non è un vero out-of-sample**: la cella è
   stata scelta guardando una misura che copre l'intera finestra, OOS compreso.
   Attenuanti reali (punto interno e non picco; criteri del passo 0 **senza
   nessun P/L** dentro) ma non assolutorie. **L'unico vero out-of-sample sarà il
   forward demo.**
3. ❌ **"I numeri del passo 0 sono confermati".** Lo stop reale **cambia la
   popolazione** dei trade: tronca proprio quelli che sarebbero convergiuti dopo
   un'escursione profonda. È una **misura nuova**.
4. ❌ **"Basta allargare/stringere lo stop"** e rilanciare: sarebbe **pescare la
   geometria**. Sarebbe una tesi nuova, in un round nuovo, con criteri firmati
   prima.
5. ❌ **"D30EUR è pulito"**: porta un debito dichiarato (C2 = 12,93% di giorni
   spaiati al passo 0, e 1.057 buchi del metro contro 1 di NASUSD). **Qui non si
   filtra: si misura**, con tre colonne dedicate.

| | |
|---|---|
| **Driver** | `righe/RIGA_RELATIVO_R117.ps1` (marcatore `MARCATORE_RIGA_RELATIVO_R117_v1`) |
| **EA** | `mql5/Experts/ABTG_Relativo.mq5` — **NUOVO, MAI COMPILATO**. Si compila qui: **se fallisce, QUELLO è il risultato del passo** |
| **File prova** | i 6 `prove/RELATIVO_R117_*.txt` (scaricati tutti, ne gira uno: gli altri servono al gemellaggio a SEI) |
| **Banco** | **Modello 4 = OGNI TICK, TICK REALI**. Finestra **2024.09.26 → 2026.06.30**, split **40/60** |
| **Dove** | **PC di backtest**, non VPS. **MT5 e MetaEditor CHIUSI** |
| 🔴 **RAM** | **MASSIMO 4 AGENTI.** A tick reali il vincolo vero non è il tetto delle barre, è la memoria (lezione del 01/09: *"no memory for ticks generating"* con 8 agenti su 16 GB). **La riga non può imporlo: lo imposti tu nel tester.** |
| **Prima di lanciare** | lo **storico di U30USD** dev'essere già nel terminale, o ogni barra risulta "spaiata" e il referto misura la configurazione invece del mercato |
| **Workdir** | `%USERPROFILE%\abtg_relativo_r117` — separata da quelle del passo 0 |

⏱️ **Quanto ci mette [STIMA, non una misura]:** a **tick reali** una passata su 21
mesi M5 è di **un altro ordine di grandezza** rispetto alle corse open-prices del
passo 0 (che facevano 49 passate in ~30 secondi). Non ho un numero misurato per
questo EA: **mettici il tempo che ci mette, e se sembra bloccato guarda che il
tester stia macinando invece di fermare tutto.** Il referto porta l'**ora di
avvio**, non quella di fine, apposta.

## 📌 IL PIN — `PIN_DA_INSERIRE`

⛔ **CARTELLO: il pin non è ancora stato inserito.** Questa pagina **non si
lancia** finché al posto di `PIN_DA_INSERIRE` non c'è il commit a 40 caratteri e
la tabella di verifica `raw` qui sotto non è compilata (classe 101: il cartello
**si riscrive**, non si lascia).

| file al pin | esito |
|---|---|
| `backtest_pipeline/righe/RIGA_RELATIVO_R117.ps1` | ⬜ |
| `mql5/Experts/ABTG_Relativo.mq5` | ⬜ |
| i 6 `backtest_pipeline/prove/RELATIVO_R117_*.txt` | ⬜ |
| `backtest_pipeline/walkforward_generico.ps1` | ⬜ |

## 1️⃣ Giro a vuoto (`-SoloControllo`, con `-AccettoTettoBarre`: **serve anche qui**)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='PIN_DA_INSERIRE'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_RELATIVO_R117.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_RELATIVO_R117.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_RELATIVO_R117_v1' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova D30_PORTO -SoloControllo -AccettoTettoBarre; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'RELATIVO_R117_D30_PORTO_CONTROLLO_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP RELATIVO_R117_D30_PORTO_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI o FERMATA: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'GIRO A VUOTO: guarda solo che i sei gate passino e che la COMPILAZIONE riesca. NON ci sono numeri qui dentro.' -ForegroundColor Yellow }
```

## 2️⃣ 🥇 `D30_PORTO` — **IL COLLAUDO DEL PORTO. Se fallisce, il round finisce qui.**

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='PIN_DA_INSERIRE'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_RELATIVO_R117.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_RELATIVO_R117.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_RELATIVO_R117_v1' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova D30_PORTO -AccettoTettoBarre; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'RELATIVO_R117_D30_PORTO_2*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP RELATIVO_R117_D30_PORTO_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI o FERMATA: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'GUARDA SUBITO: la riga COLLAUDO DEL PORTO. Se e'' FALLITO, il round NON parte e le altre corse non si lanciano.' -ForegroundColor Yellow }
```

## 3️⃣ 🥇 `NAS_PORTO` — collaudo del porto sulla seconda gamba

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='PIN_DA_INSERIRE'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_RELATIVO_R117.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_RELATIVO_R117.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_RELATIVO_R117_v1' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova NAS_PORTO -AccettoTettoBarre; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'RELATIVO_R117_NAS_PORTO_2*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP RELATIVO_R117_NAS_PORTO_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI o FERMATA: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'GUARDA SUBITO: la riga COLLAUDO DEL PORTO.' -ForegroundColor Yellow }
```

## 4️⃣ `D30` — la misura su D30EUR (magic 774601)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='PIN_DA_INSERIRE'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_RELATIVO_R117.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_RELATIVO_R117.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_RELATIVO_R117_v1' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova D30 -AccettoTettoBarre; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'RELATIVO_R117_D30_2*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP RELATIVO_R117_D30_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI o FERMATA: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'GUARDA SUBITO: PROBLEMI = 0, poi i cancelli A. Il gemello si confrontera'' nel blocco dopo.' -ForegroundColor Yellow }
```

## 5️⃣ `D30_GEM` — il gemello di determinismo di D30 (magic 774611)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='PIN_DA_INSERIRE'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_RELATIVO_R117.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_RELATIVO_R117.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_RELATIVO_R117_v1' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova D30_GEM -AccettoTettoBarre; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'RELATIVO_R117_D30_GEM_2*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP RELATIVO_R117_D30_GEM_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI o FERMATA: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'GUARDA SUBITO: la riga IL GEMELLO DI DETERMINISMO. Se DIVERGONO, il banco e'' sporco e NESSUN numero vale.' -ForegroundColor Yellow }
```

## 6️⃣ `NAS` — la misura su NASUSD (magic 774602)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='PIN_DA_INSERIRE'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_RELATIVO_R117.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_RELATIVO_R117.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_RELATIVO_R117_v1' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova NAS -AccettoTettoBarre; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'RELATIVO_R117_NAS_2*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP RELATIVO_R117_NAS_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI o FERMATA: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'GUARDA SUBITO: PROBLEMI = 0, poi i cancelli A. Il gemello si confrontera'' nel blocco dopo.' -ForegroundColor Yellow }
```

## 7️⃣ `NAS_GEM` — il gemello di determinismo di NAS (magic 774612)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='PIN_DA_INSERIRE'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_RELATIVO_R117.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_RELATIVO_R117.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_RELATIVO_R117_v1' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova NAS_GEM -AccettoTettoBarre; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'RELATIVO_R117_NAS_GEM_2*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP RELATIVO_R117_NAS_GEM_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI o FERMATA: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'GUARDA SUBITO: la riga IL GEMELLO DI DETERMINISMO.' -ForegroundColor Yellow }
```

## 8️⃣ 📦 RACCOLTA FINALE — **un solo zip da mandare** (regola di casa delle righe di lancio)

```powershell
& { $ErrorActionPreference='Stop';
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $stamp=(Get-Date).ToString('yyyyMMdd_HHmm'); $out=Join-Path $d ('RELATIVO_R117_TUTTO_'+$stamp); New-Item -ItemType Directory -Force -Path $out | Out-Null;
    $att=@('RELATIVO_R117_D30_PORTO_2*','RELATIVO_R117_NAS_PORTO_2*','RELATIVO_R117_D30_2*','RELATIVO_R117_D30_GEM_2*','RELATIVO_R117_NAS_2*','RELATIVO_R117_NAS_GEM_2*'); $trovati=0;
    foreach($m in $att){ $c=@(Get-ChildItem (Join-Path $d ($m+'.zip')) -EA SilentlyContinue | Sort-Object LastWriteTime -Descending);
      if($c.Count -gt 0){ Copy-Item $c[0].FullName -Destination $out -Force; $trovati++; Write-Host ('  TROVATO: '+$c[0].Name+'   ('+$c[0].LastWriteTime+')') -ForegroundColor Green }
      else { Write-Host ('  MANCA:   '+$m+'.zip -- quella corsa non e'' arrivata alla raccolta') -ForegroundColor Red } }
    $zip=$out+'.zip'; Remove-Item $zip -Force -EA SilentlyContinue; Compress-Archive -Path (Join-Path $out '*') -DestinationPath $zip -Force;
    Write-Host ''; Write-Host ('ZIP DA MANDARE IN CHAT: '+$zip) -ForegroundColor Cyan;
    Write-Host ('FILE ATTESI DENTRO: 6 zip di corsa. Trovati: '+$trovati+' su 6.') -ForegroundColor Gray;
    if($trovati -lt 6){ Write-Host 'ATTENZIONE: mandalo lo stesso, ma dimmi quale corsa e'' mancata e cosa ha stampato.' -ForegroundColor Yellow } }
```

## 📦 COSA TORNA (per corsa)

Zip sul Desktop **`RELATIVO_R117_<PROVA>_<timestamp>.zip`** →
`REFERTO_RELATIVO_R117_<PROVA>.txt` + `COMPILAZIONE.log` + il file prova +
**due CSV OPTFRAME** (`..._IS_<PROVA>.csv` e `..._OOS_<PROVA>.csv`, **una riga
ciascuno**, 76 colonne + gli input accodati dal tester).

**Le righe da guardare per prime, in questo ordine:**

1. **`compilazione:`** — è un EA nuovo. Se è FALLITA, quello è il risultato.
2. **`COLLAUDO DEL PORTO`** (blocchi 2-3) — se FALLITO, il round finisce lì.
3. **`IL GEMELLO DI DETERMINISMO`** (blocchi 5 e 7) — se DIVERGONO, banco sporco.
4. **`PROBLEMI: 0`** — un solo collaudo di sanità fallito = **non leggibile**.
5. **`ECO DEI PIN`** — se N non è 40 o σ non è 1,35, **il pin non è passato** e la
   corsa ha misurato un'altra configurazione.
6. E **solo dopo**: `I CANCELLI DI MERITO` e il verdetto della gamba.

## 🔜 COSA SUCCEDE DOPO

- 🟢 **Se una gamba passa tutti i cancelli A**: si scrive *"la convergenza del
  rapporto ha aspettativa positiva a tick reali su \<gamba\>, **su un solo
  regime**"* → si chiede la **prova di rischio su un regime ostile**.
  **Nessuna sedia, nessun forward, ancora.**
- 🟠 **Se passa una gamba sola**: **non è "il motore funziona"**. Si scrive quale,
  e la gamba morta **resta morta** (lezione PTE: GBPUSD sì, USDJPY no).
- 🔴 **Se non passa nessuna gamba**: **il meccanismo non ha edge a tick reali su
  questa finestra.** Verdetto **pieno e valido** — ed è l'esito che la previsione
  scritta sopra considera probabile su D30EUR.
- ⛔ **Se un gate di sanità è rosso**: *"il banco non ha prodotto la misura"*.
  **È vietato scriverlo come se fosse un verdetto sull'edge.**
