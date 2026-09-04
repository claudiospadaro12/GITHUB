# 📐 SONDA RELATIVO — **ESTENSIONE DELLA GRIGLIA: LA RIGA DA MANDARE**

**Che cos'è:** un secondo giro della **stessa sonda già girata il 04/09**
(`ABTG_SondaRelativo` v1.03, **contatore puro: zero ordini, zero lotti, zero
magic** — la riga lo **riprova a macchina** a ogni corsa), con **una sola cosa
diversa: gli assi sono più lunghi**. Non è un motore nuovo, non è un criterio
nuovo, non è una decisione di merito: è **la stessa domanda, guardata più in
là**.

> ### 🎯 PERCHÉ ESISTE — decisione di Claudio del 04/09 (**D4**)
> Il 04/09 D30_M5 e NAS_M5 hanno dato **VIVO su entrambi i lati**. Ma
> **l'altopiano vivo si appoggia al BORDO della griglia su TUTTI E DUE GLI
> ASSI**:
>
> | gamba | blocchi 2×2 VIVI | bordo toccato |
> |---|---|---|
> | **D30_M5** | N ∈ {35, 40} × σ ∈ {1,20 … 1,65} | **N=40 e σ=1,65 = i massimi misurati** |
> | **NAS_M5** | N ∈ {35, 40} × σ ∈ {1,35 … 1,65} | **idem** |
>
> **Nessuna cella oltre N=40 o oltre σ=1,65 è MAI stata guardata.** Quindi il
> **centro dell'altopiano** (regola di casa: **MAI il picco**) **non è
> determinabile**: può essere il centro vero, oppure il **fianco basso** di un
> altopiano più grande che continua fuori dalla griglia. **La cella per il round
> a tick reali non si congela finché non si sa quale delle due letture è vera.**
> Origine del rilievo: `report/PROPOSTA_RELATIVO_TICK_REALI_2026-09-04.md`, §3.4.

## 🧊 COSA **NON** SI TOCCA — ed è metà del valore di questo giro

| oggetto | stato |
|---|---|
| `mql5/Experts/ABTG_SondaRelativo.mq5` | **v1.03, INVARIATO.** Contatore puro. Non è stata cambiata una riga |
| i **4 prova originali** `prove/RELATIVO_{D30,NAS}_{M5,M15}.txt` | **INTATTI.** Il loro **gemellaggio a quattro**, già verificato il 03/09, **resta valido** |
| `righe/RIGA_SONDARELATIVO.ps1` (marcatore `_v5`) e la sua pagina | **INTATTE.** Questa è una riga **nuova e separata** |
| **i cancelli** C1 · C2 · C3 · C5 · C6 · C7 · C8 | **INVARIATI.** Stanno nei `#define` del sorgente e si **leggono da lì al pin**. Estendere la griglia **non è spostare un cancello** |
| la **regola di lettura** | **ALTOPIANO, MAI IL PICCO.** Su una griglia più grande la tentazione del picco **cresce**: la regola resta scritta **prima** dei numeri |

> ⚙️ **La strada scelta, dichiarata: (b) — FILE NUOVI DEDICATI.**
> L'alternativa (a) era allargare gli assi dentro i 4 prova esistenti. Scartata
> per un motivo preciso: **avrebbe invalidato il gemellaggio a quattro già
> verificato** (i due M15 resterebbero con la griglia vecchia → i quattro non
> sarebbero più identici carattere per carattere) e avrebbe **riscritto file già
> pinnati e già usati per produrre referti**. Con (b) non si tocca niente di
> misurato, e il **diff fra la riga nuova e la `_v5` è piccolo e dichiarato**
> (elencato in testa al `.ps1`, voce per voce).

## 📊 LA GRIGLIA — **90 celle**, e le 49 vecchie sono **dentro**

| asse | il 04/09 | **adesso** | nuovi valori |
|---|---|---|---|
| `InpFinestraN` | 10 → 40 passo 5 (**7**) | **10 → 55 passo 5 (10)** | **45, 50, 55** |
| `InpSogliaIngressoSigma` | 0,75 → 1,65 passo 0,15 (**7**) | **0,75 → 1,95 passo 0,15 (9)** | **1,80 · 1,95** |
| **celle** | 49 | **90** | 41 nuove |

> ### 💡 **Perché si rigirano ANCHE le 49 vecchie** (non solo le 41 nuove)
> Costa **~30 secondi di macchina in più**, e in cambio dà due cose che le sole
> celle nuove non darebbero:
>
> **1. 🔬 UN COLLAUDO DI RIPRODUZIONE, NUOVO E BLOCCANTE.** La cella di
> riferimento **N=20 σ=1,05** esiste in entrambe le griglie. Una passata **non sa
> nemmeno** che la griglia intorno a lei è cresciuta: con gli stessi identici
> input **deve dare gli stessi identici numeri**. La riga li confronta a macchina
> con i valori dei referti del 04/09 — **6 conteggi (esatti) + 6 mediane/quote
> (a 0,01)**:
>
> | | Giorni | Barre Val. | Grezzi L/S | Esegu. L/S | MFE L/S | MAE L/S | nonConv | tenuta |
> |---|---:|---:|---:|---:|---:|---:|---:|---:|
> | **D30EUR** | 441 | 38.760 | 2246 / 2374 | 1417 / 1454 | 18,50 / 17,70 | 16,00 / 18,50 | 9,33 % | 9,00 |
> | **NASUSD** | 450 | 38.715 | 2419 / 2418 | 1523 / 1534 | 27,50 / 26,80 | 31,20 / 29,35 | 9,22 % | 8,00 |
>
> 🔴 **Se NON tornano, non è l'estensione a essere sbagliata: sono i numeri del
> 04/09 a non essere riproducibili su questo banco** (storico scaricato dopo,
> cache del tester, sorgente diverso) — e allora **la scelta della cella per il
> round a tick non si può appoggiare su quel referto**. È un **PROBLEMA**, non un
> rilievo: clausola severa, scritta prima.
>
> **2. 🗺️ UNA MAPPA SOLA (10×9), letta in un pezzo.** La regola dell'altopiano
> guarda **blocchi 2×2 di celle CONTIGUE**: cucire a mano due mappe misurate in
> corse diverse è **esattamente il punto in cui si sbaglia**. Qui la mappa esce
> già intera dal referto, e le prime 7 righe × 7 colonne **sono** la mappa del
> 04/09.

## 🔮 LA PREVISIONE, SCRITTA PRIMA DEI NUMERI (falsificabile)

N e σ più grandi **riducono le occasioni**: sulla griglia vecchia si passa da
**13,07** eseguibili/giorno (N=10, σ=0,75) a **2,89** (N=40, σ=1,65) su D30EUR, e
da **13,02** a **3,07** su NASUSD. **[MISURATO]**

> **[INFERITO]** Le celle nuove scenderanno ancora, e una parte di loro dovrebbe
> sbattere contro il **PAVIMENTO C1 (2,00 eseguibili/giorno)** morendo di
> **PORTATA, non di geometria**.

| esito | come si legge |
|---|---|
| 🟢 **l'altopiano FINISCE dentro la griglia nuova** | il bordo vecchio **non stava tagliando niente di utile**: la scelta **N=35 / σ=1,50** della proposta del 04/09 **regge**, e il rilievo del bordo si chiude |
| 🟠 **l'altopiano CONTINUA** | il "centro" del 04/09 era il **fianco basso**: il centro va **rifatto sulla mappa nuova** e la proposta a tick va **corretta prima** di essere lanciata |
| 🔴 **un blocco 2×2 VIVO tocca N=55 o σ=1,95** | **il bordo si è solo spostato**: la griglia va estesa **ANCORA** prima di congelare una cella. Il rilievo si riscrive uguale, un gradino più in là |

**Nessuna delle tre è un fallimento.** È la domanda che aveva senso porre.

## ⚠️ IL RISCHIO DICHIARATO: **il conteggio delle celle**

L'asse σ va per multipli di **0,15** su numeri in virgola mobile:
`0,75 + 8 × 0,15` può uscire **1,9500000000000002** e produrre **8** valori invece
di 9 → **72 celle invece di 90**. **Non si corregge in silenzio:** la riga
**conta le righe del CSV** e le confronta con 90. Se sono 72 o 81 è un
**PROBLEMA scritto nel referto**, non una griglia "quasi giusta" letta come se
fosse giusta.

## 📉 IL TETTO DELLE ~100.000 BARRE — **anche il giro a vuoto ha bisogno di `-AccettoTettoBarre`**

Le due corse sono **entrambe M5** (i due M15 hanno dato **SOSPESO** su entrambi i
lati e sono **chiusi**), e M5 su 21 mesi **eccede il tetto** (1,76 anni contro
~1,3). Il gate del tetto sta **prima** della compilazione e **scatta anche in
`-SoloControllo`**: quindi **anche il blocco 1 porta `-AccettoTettoBarre`**,
altrimenti si ferma lì e non arriva nemmeno a compilare. La scelta finisce nel
referto come **DICHIARATA**, e il referto stampa la **finestra EFFETTIVA**
(`Gamba Prima Barra Epoch`, `Giorni Contati`, `Barre Valutate`) — che il
collaudo di riproduzione **verifica contro il 04/09**.

📌 **Nota misurata:** il 04/09 il tetto **non ha troncato** (prima barra
2024-09-26 = l'inizio chiesto, 441/450 giorni contati). Il collaudo di
riproduzione lo **ri-misura** invece di darlo per buono.

| | |
|---|---|
| **Driver** | `righe/RIGA_SONDARELATIVO_ESTESA.ps1` (marcatore `MARCATORE_RIGA_SONDARELATIVO_ESTESA_v1`) |
| **File prova** | `prove/RELATIVO_D30_M5_ESTESA.txt` · `prove/RELATIVO_NAS_M5_ESTESA.txt` (scaricati **tutti e due**, ne gira uno: l'altro serve al **gemellaggio a DUE**) |
| **Dove** | **PC di backtest**, non VPS. **MT5 e MetaEditor CHIUSI** |
| **Prima di lanciare** | lo **storico di U30USD** dev'essere già nel terminale (`scarica_storico.ps1 -Simboli "U30USD"`), o ogni barra risulta "spaiata" e il referto misura la configurazione invece del mercato |
| **Cosa scrive nel terminale** | `MQL5\Experts\ABTG_SondaRelativo.mq5` + `.ex5` (restano, **dichiarati** con foto PRIMA/DOPO — classe 116, sentinella `SONDARELATIVO_EST_IN_CORSO.txt`) e svuota `Tester\cache` |
| **Workdir** | `%USERPROFILE%\abtg_sondarelativo_est` — **separata** da quella del 04/09: nessun file di questa corsa può essere scambiato per uno di quella, in nessun punto della catena |

⏱️ **Quanto ci mette [MISURATO, non stimato]:** le **49** passate M5 del 04/09
sono state fatte in **~30 secondi di tester** (referti alla mano: corsa avviata
14:19:28, CSV scritto 14:19:58). **90 passate ≈ 55-60 s** [CALCOLO], più due
avvii del terminale e una compilazione: **2-6 minuti in tutto**, a corsa. ⚠️ La
riga `_v5` stimava *15-45 minuti*: era una **STIMA prudenziale**, e la misura
l'ha smentita. Se questa corsa ci mettesse molto di più **non è un errore**, ma
va scritto.

## 📌 IL PIN — **`d1fb9e7732d41aec071aa0cae5962e3abcb986a4`**

✅ **INSERITO il 04/09/2026** (prima di questo commit qui c'era il cartello del
segnaposto: si **riscrive**, non si lascia — classe 101). I **cinque** file che
il driver scarica sono stati **verificati uno per uno via `raw` al pin** (HTTP
**200** + **sha256 identico** al repo) **prima** che questa riga fosse
dichiarata pronta.

| file al pin | esito |
|---|---|
| `backtest_pipeline/righe/RIGA_SONDARELATIVO_ESTESA.ps1` | **200, identico** (sha256 `949667ee…`) · marcatore `MARCATORE_RIGA_SONDARELATIVO_ESTESA_v1` presente · **ASCII puro** (0 byte > 127) · **parse OK** (pwsh 7.4.6, 0 errori) · **3 coppie case-insensitive, tutte inerti** (classe 79/79-bis): `$hA`/`$ha` in funzioni diverse, `$Mappa`/`$mappa` idem, `$r`/`$R` disgiunte per ordine (`$r` muore riga 982, `$R` nasce riga 1085) |
| `backtest_pipeline/prove/RELATIVO_D30_M5_ESTESA.txt` | **200, identico** (`7cc6b1a1…`) · 26 righe vive · ASCII puro |
| `backtest_pipeline/prove/RELATIVO_NAS_M5_ESTESA.txt` | **200, identico** (`5b8bcd47…`) · 26 righe vive · ASCII puro · **differisce dal gemello per la SOLA riga `@SIMBOLO`** (diff meccanico: 1 differenza su 26) |
| `backtest_pipeline/walkforward_generico.ps1` | **200, identico** (`5d98af3d…`, invariato dal 03/09): il driver lo scarica al pin e lo ri-pinna sul `.mq5` |
| `mql5/Experts/ABTG_SondaRelativo.mq5` | **200, identico** (`b7326318…`) · `#property version "1.03"` · 25 blocchi autotest · REL_NSTATS 97 (100 colonne) · 22 input · **0 chiamate di trading** · 0 `#include` — **NON TOCCATO** |

### 🧪 E LA RIGA È STATA **ESEGUITA**, NON SOLO LETTA (banco pwsh 7.4.6)

| prova a banco | esito |
|---|---|
| `GateProva` sui **due** prova estesi | **PASSATI**, `Celle = 90` su entrambi |
| `GateGemelli` | `VALIDO: i 2 prova hanno il blocco dei parametri IDENTICO riga per riga` |
| **controprova**: il prova **vecchio** (`RELATIVO_D30_M5.txt`) dato in pasto alla riga nuova | **RIFIUTATO**, come deve: *"InpFinestraN è '20\|\|10\|\|5\|\|40\|\|Y', atteso '…55\|\|Y'"* |
| `CelleAsse` sui due pin (la stessa aritmetica del generico) | N = **10**, σ = **9**, prodotto = **90** |
| `AnalizzaCsv` + `StatoCella` + `Altopiano` su un **CSV sintetico da 90 righe e 100 colonne** | 90 righe lette, **0 problemi**, mappa **10×9** stampata intera |
| **collaudo di riproduzione — caso sano** | `COLLAUDO DI RIPRODUZIONE PASSATO … 12 grandezze su 12` |
| **collaudo di riproduzione — caso rotto** (spostata **una sola** MFE di **0,10**) | **`PROBLEMI: 1`** con il numero divergente nominato: il gate **morde** |
| sezione **RACCOLTA eseguita con lo stato PIENO** (lezione classe 79-bis: il difetto stava nel *flusso*, non nelle funzioni) | referto scritto, tabella delle **90** celle, cartella e **zip** creati, `ESITO: CORSA COMPLETATO` |

> ⚠️ **Il CSV del banco è SINTETICO**: le V/S/. che ha prodotto **non sono una
> previsione** di come verrà la mappa vera. Servivano solo a far girare il
> codice con lo stato pieno.

> 🚧 **NON COPERTO dal banco** (e va dichiarato): la **compilazione** in
> MetaEditor, la **corsa vera** di MT5, **Windows PowerShell 5.1** (qui il parse
> è su pwsh 7), il **conteggio reale delle celle prodotto dal motore di
> ottimizzazione** (il rischio dell'asse σ in virgola mobile: lo dice il gate
> sulle righe del CSV, non il banco), la sezione **scelta del terminale**.

## 1️⃣ Giro a vuoto (`-SoloControllo`, con `-AccettoTettoBarre`: **serve anche qui**)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='d1fb9e7732d41aec071aa0cae5962e3abcb986a4'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDARELATIVO_ESTESA.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDARELATIVO_ESTESA.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDARELATIVO_ESTESA_v1' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova D30_M5_EST -SoloControllo -AccettoTettoBarre; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'SONDARELATIVO_EST_D30_M5_EST_CONTROLLO_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDARELATIVO_EST_D30_M5_EST_CONTROLLO_ DI ADESSO SUL DESKTOP: il controllo non e'' arrivato alla raccolta. Mandami quello che vedi qui sopra.' };
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip qui sotto.' -ForegroundColor Yellow };
    if($ko){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare le corse. Mandami questo zip:' -ForegroundColor Red; Write-Host $z[0].FullName -ForegroundColor Yellow } else { Write-Host 'CONTROLLO OK (fa comunque fede il referto nello zip): lancia i blocchi 2 e 3, uno alla volta.' -ForegroundColor Green; Write-Host $z[0].FullName -ForegroundColor Gray } }
```

## 2️⃣ Corsa `D30_M5_EST` — 90 celle

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='d1fb9e7732d41aec071aa0cae5962e3abcb986a4'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDARELATIVO_ESTESA.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDARELATIVO_ESTESA.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDARELATIVO_ESTESA_v1' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova D30_M5_EST -AccettoTettoBarre; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'SONDARELATIVO_EST_D30_M5_EST_2*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDARELATIVO_EST_D30_M5_EST_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI o FERMATA: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('NEL REFERTO la riga data: e'' l''ORA DI AVVIO di questa corsa (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + ').') -ForegroundColor Gray;
    Write-Host 'GUARDA SUBITO NEL REFERTO: righe nel CSV = 90 (se sono 72 o 81 e'' il difetto dell''asse sigma in virgola mobile) e la riga COLLAUDO DI RIPRODUZIONE.' -ForegroundColor Yellow }
```

## 3️⃣ Corsa `NAS_M5_EST` — 90 celle

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='d1fb9e7732d41aec071aa0cae5962e3abcb986a4'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDARELATIVO_ESTESA.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDARELATIVO_ESTESA.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDARELATIVO_ESTESA_v1' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova NAS_M5_EST -AccettoTettoBarre; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'SONDARELATIVO_EST_NAS_M5_EST_2*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDARELATIVO_EST_NAS_M5_EST_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI o FERMATA: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('NEL REFERTO la riga data: e'' l''ORA DI AVVIO di questa corsa (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + ').') -ForegroundColor Gray;
    Write-Host 'GUARDA SUBITO NEL REFERTO: righe nel CSV = 90 e la riga COLLAUDO DI RIPRODUZIONE.' -ForegroundColor Yellow }
```

## 4️⃣ 📦 RACCOLTA FINALE — **un solo zip da mandare** (regola di casa delle righe di lancio)

```powershell
& { $ErrorActionPreference='Stop';
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $stamp=(Get-Date).ToString('yyyyMMdd_HHmm'); $out=Join-Path $d ('RELATIVO_GRIGLIA_ESTESA_'+$stamp); New-Item -ItemType Directory -Force -Path $out | Out-Null;
    $att=@('SONDARELATIVO_EST_D30_M5_EST_2*','SONDARELATIVO_EST_NAS_M5_EST_2*'); $trovati=0;
    foreach($m in $att){ $c=@(Get-ChildItem (Join-Path $d ($m+'.zip')) -EA SilentlyContinue | Sort-Object LastWriteTime -Descending);
      if($c.Count -gt 0){ Copy-Item $c[0].FullName -Destination $out -Force; $trovati++; Write-Host ('  TROVATO: '+$c[0].Name+'   ('+$c[0].LastWriteTime+')') -ForegroundColor Green }
      else { Write-Host ('  MANCA:   '+$m+'.zip -- quella corsa non e'' arrivata alla raccolta') -ForegroundColor Red } }
    $zip=$out+'.zip'; Remove-Item $zip -Force -EA SilentlyContinue; Compress-Archive -Path (Join-Path $out '*') -DestinationPath $zip -Force;
    Write-Host ''; Write-Host ('ZIP DA MANDARE IN CHAT: '+$zip) -ForegroundColor Cyan;
    Write-Host ('FILE ATTESI DENTRO: 2 zip di corsa (D30_M5_EST e NAS_M5_EST). Trovati: '+$trovati+' su 2.') -ForegroundColor Gray;
    if($trovati -lt 2){ Write-Host 'ATTENZIONE: mandalo lo stesso, ma dimmi quale corsa e'' mancata e cosa ha stampato.' -ForegroundColor Yellow } }
```

## 📦 COSA TORNA (per corsa)

Zip sul Desktop **`SONDARELATIVO_EST_<PROVA>_<timestamp>.zip`** →
`REFERTO_SONDARELATIVO_EST_<PROVA>.txt` + `COMPILAZIONE.log` + il file prova +
**1 CSV OPTFRAME** (`ABTG_SondaRelativo_<SIMBOLO>_IS_ohlc_<PROVA>.csv`, **90
righe = le 90 passate**, 100 colonne + gli input accodati dal tester).

**Le tre righe da guardare per prime, in questo ordine:**

1. `righe nel CSV: 90 (attese 90)` — se no, è il difetto dell'asse σ (vedi sopra).
2. `COLLAUDO DI RIPRODUZIONE ...` — **PASSATO** o **FALLITO**. Se fallito, i
   verdetti del 04/09 vanno considerati **superati, non confermati**.
3. `PROBLEMI: 0` — un solo collaudo fallito su una sola delle 90 righe =
   **NON LEGGIBILE**, nessun verdetto (clausola severa).

E **solo dopo** la **mappa 10×9** e i verdetti per lato.

## 🚫 COSA QUESTA CORSA **NON** DICE

1. ❌ **Non dice se il motore guadagna.** È un **contatore**: conta occasioni e
   misura taglia, geometria, convergenza, tenuta. **Zero ordini, zero P/L.** Il
   merito è a tick, dopo, con ≥ 150 operazioni IS.
2. ❌ **Non misura la co-integrazione.** C6 resta la sua approssimazione
   operativa.
3. ❌ **Non cambia nessun criterio** e **non promuove nessuna cella**: serve a
   sapere **dove sta il centro**, non a scegliere il vincitore.
4. ❌ **Non tocca il forward, il VPS, nessuna sedia, nessun magic.**
5. ❌ **Non sblocca da sola la Parte 2** (scrivere `ABTG_Relativo.mq5`): quella
   riparte **dopo** che questa mappa è letta e la cella definitiva è scelta.

## 🔜 COSA SUCCEDE DOPO

Con i due referti in mano si sceglie la **cella definitiva** — **centro del VERO
altopiano**, mai il picco, con la regola del pareggio già dichiarata (*se il
centro cade fuori griglia, si rompe verso la cella che **non** sta sul bordo*) —
e **solo allora** parte la **Parte 2**: `ABTG_Relativo.mq5` + la riga a tick
reali, con **D30EUR inclusa** (decisione **D3** di Claudio) e le **due colonne
dedicate** `Operazioni Aperte in Giorni Spaiati` + il loro **P/L separato**.
