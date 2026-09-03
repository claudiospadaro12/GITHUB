# 📬 SONDA RELATIVO — **PASSO 0: LA RIGA DA MANDARE** (il primo motore VERGINE del repo, contato prima di essere creduto)

**Che cos'è:** il primo giro della **sonda di convergenza `ABTG_SondaRelativo`**
(EA **NUOVO, MAI COMPILATO** — la compilazione avviene qui e **se fallisce,
QUELLO è il risultato del passo**). È un **CONTATORE PURO**: zero ordini, zero
lotti, zero magic — la riga lo **prova a macchina** (grep delle chiamate di
trading fuori dai commenti, attese **0**; `#include` attesi **0**) prima di aprire
MT5. Motore contato: **rapporto fra DUE simboli → scarto dalla media mobile →
z-score → due soglie simmetriche → uscita per convergenza**. La **gamba** si
scambia (D30EUR o NASUSD), il **metro** si legge e basta (**U30USD**). È il
candidato **P1 della quarta battuta** (02/09) e il **n. 1 della shortlist** del
`report/GIACIMENTO_DI_CASA_2026-09-03.md` (sezione 8: _"unico meccanismo VERGINE
del repo, M5/M15, costo minimo"_). Attribuzione completa in testa al `.mq5` e ai
prova (tre Pine letti, **nessuna riga copiata**, matematica pubblica riscritta).

🎯 **LA DOMANDA-SONDA (GIACIMENTO sez. 8, testuale):** _su D30EUR M5 con metro
U30USD, finestra 20 barre e soglia 1,05σ, quante convergenze/giorno per lato in
21 mesi, e la MFE mediana copre 3× lo spread misurato?_ — la riga risponde
**cella per cella** (49) e stampa **a parte** la cella di riferimento
**N=20, σ=1,05**, che è la domanda, **non una promozione**.

**QUATTRO CORSE, quattro blocchi, quattro zip** — finestra 2024.09.26 → 2026.06.30,
**MODELLO 2 "Solo prezzi di apertura"** (il segnale nasce su barra chiusa e non
si apre niente), **2 assi × 7 valori = 49 passate** a corsa:

| `-Prova` | Gamba | TF | Metro | File prova | Cancello C3 (3× spread misurato) |
|---|---|---|---|---|---|
| `D30_M15` | D30EUR | M15 | U30USD | `prove/RELATIVO_D30_M15.txt` | **8,40** pti (3 × 2,80) |
| `NAS_M15` | NASUSD | M15 | U30USD | `prove/RELATIVO_NAS_M15.txt` | **5,40** pti (3 × 1,80) |
| `D30_M5` | D30EUR | M5 | U30USD | `prove/RELATIVO_D30_M5.txt` | **8,40** pti — ⚠️ **oltre il tetto barre, vedi sotto** |
| `NAS_M5` | NASUSD | M5 | U30USD | `prove/RELATIVO_NAS_M5.txt` | **5,40** pti — ⚠️ **oltre il tetto barre, vedi sotto** |

> ⚙️ **Le scelte, dichiarate (perché NON erano fissate):**
> - **UNA corsa per invocazione**, non quattro in sequenza: la sonda scrive
>   `OptResults_ABTG_SondaRelativo_<SIMBOLO>.csv` **senza il TF nel nome**
>   (letto nel sorgente), quindi D30_M5 e D30_M15 scriverebbero lo stesso file
>   grezzo; e quattro corse da 49 passate in un giro solo sono ore di macchina
>   senza artefatto intermedio. **Se una corsa muore, le altre tre esistono.**
> - **I quattro prova si scaricano TUTTI anche se ne gira uno**: il prova
>   promette che i quattro sono **identici carattere per carattere** nel blocco
>   dei parametri e differiscono **SOLO per `@SIMBOLO` e `@PERIODO`**. La riga lo
>   **verifica meccanicamente** (gemellaggio a quattro); una terza differenza
>   **ferma tutto**.
> - **Nessun `-Simbolo`/`-Periodo` passato al generico**: li legge dai prova, come
>   i prova stessi prescrivono; la riga li **gatta** contro l'atteso del `-Prova`.
> - **FrazioneIS 1.0** (una tranche): la sonda non seleziona celle, non esiste un
>   OOS da tenere in cassaforte. La gamba "OOS" del generico è **degenere**: il
>   rosso su `*_OOS` è **ATTESO**. **Deposito 100000**: inerte.
> - **Le soglie di lettura si LEGGONO dai `#define` del sorgente al pin** e si
>   confrontano coi numeri di questa pagina: se divergono, la riga **si ferma**
>   (il criterio si cambia prima dei numeri, non dopo).
> - **22 input letti dal sorgente, TUTTI pinnati nel prova, nei DUE versi**: un
>   pin che l'EA non ha = errore n. 3 della checklist (MT5 ignora in silenzio);
>   un input che il prova non pinna = stato che MT5 si ricorda dall'ultima
>   griglia. Provato a macchina con **9 mutazioni** dei prova, tutte rosse.

## 📏 I CRITERI DI LETTURA — scritti QUI, PRIMA di vedere un numero

Sono `#define` nel sorgente (**non input**: un cancello che si sposta dalla riga
di lancio non è un cancello) e la riga li **ricalcola dai numeri grezzi** con le
**stesse disuguaglianze** di `OnTester`, incrociandoli con le colonne `Cx Esito`
scritte dalla sonda: se sonda e driver non dicono la stessa cosa, **NON si legge**.

| Cancello | Colonne | Soglia congelata | Esito |
|---|---|---|---|
| **C1 PORTATA** | `Eseguibili Al Giorno Totale` (somma dei lati) | **≥ 2,00 /giorno** (pavimento del mandato del 02/09) | sotto → **SCARTO** |
| **C2 giorni spaiati** | `Giorni Spaiati Pct` | **≤ 10 %** | sopra → si rifà filtrando **e si dichiara** (non è merito) |
| **C3 TAGLIA** | `Mfe Mediana Long/Short Punti Indice`, `Mfe Su Spread` | **≥ 3× spread MISURATO** = **8,40** DAX / **5,40** NAS; **> 6×** = passa LARGO | sotto → **SCARTO** (per lato) |
| **C4 pavimento SL** | `Mae Mediana …` | nessuno | dice dove può stare lo stop |
| **C5 RR** | `Rr Da Mediane Long/Short` | **≥ 0,70** (FIRMA 2 del 31/08, E ≥ 0,075R) | sotto → **SCARTO PER ARITMETICA** |
| **C6 CONVERGENZA** | `Non Convergute Totale Pct` | **> 40 % SCARTO**, **25–40 % SOSPESO** | è il numero che **uccide o salva la tesi**: se alto, è **momentum travestito** |
| **C7 cap giornaliero** | `Max Eseguibili Giorno Totale` × 0,65 % | contro **3,25 %** (cap 18/08) | sopra → `InpMaxTradesPerDay` nell'EA dal primo round |
| **C8 TENUTA** | `Tenuta Mediana Totale Barre`, `Sotto 60 Secondi Pct` | **< 12 barre SOSPESO**; **≥ 25 % sotto 60 s SCARTO PROP** | (la seconda è un **collaudo**: a M5/M15 deve venire 0,00) |
| **C9 gradiente TF** | confronto **D30_M5 vs D30_M15** (e NAS) | derivato PRIMA: a M15 **non** dovrebbe arrivare al pavimento, il bersaglio è M5 | se la misura dice il contrario, **la derivazione è sbagliata e va scritto** |

🪨 **C3 usa la CLAUSOLA SEVERA, e va detto prima di leggere:** lo spread è la
**mediana oraria PEGGIORE** dentro le ore di lavoro (14–21 server), da
`SPREAD_FLOTTA_MISURA_2026-09-03.md`: **D30EUR 2,80** (dalle 17 server il DAX è
fuori dal suo cash e lo spread **quasi raddoppia** — 1,7 → 2,8), **NASUSD 1,80**.
Il GIACIMENTO cita **1,6–1,7 / 1,6–1,8**: sono le **mediane di sessione**, la
riga non le usa. Con 1,7 la soglia DAX sarebbe 5,10 e passerebbe di più: **si
sceglie la severa**.

🗺️ **LA REGOLA DI SELEZIONE, dichiarata insieme al numero — ALTOPIANO, NON PICCO
(Emendamento della Finestra, punto A):** il verdetto **per lato** NON è _"esiste
una cella che passa"_. È: **esiste un blocco 2×2 di celle CONTIGUE nella griglia
(N adiacenti × σ adiacenti) in cui C1 + C3 + C5 + C6 + C8 stanno in piedi
INSIEME?**
- **VIVO** = almeno un blocco 2×2 **tutto di celle VIVE** (C6 ≤ 25 % e tenuta ≥ 12 dentro);
- **SOSPESO** = blocchi 2×2 in piedi **solo con celle SOSPESE** dentro (C6 25–40 % o tenuta < 12);
- **NO** = nessun blocco 2×2: le celle vive, se ci sono, sono **isolate = rumore**.
  _Una cella sola non è una risposta: su tredici misure Spearman IS→OOS dodici
  sono negative._

🛑 **CLAUSOLA SEVERA SUI COLLAUDI:** un **solo** collaudo fallito su una **sola**
delle 49 righe = **NON LEGGIBILE**, nessun verdetto. I collaudi (per riga):
`Autotest Falliti` = **0** su **23** blocchi (−1 = non girato ≠ passato) ·
`Scartati Occupato Altro Lato Collaudo` = **0** (T6, per costruzione) ·
`Sotto 60 Secondi Pct` = **0,00** (T12) · `Punto Indice Prezzo` = **1,000** (T14) ·
`Spread Misurato` = **2,80 / 1,80** e `Soglia C3` = **8,40 / 5,40** (altrimenti
la sonda ha preso un altro simbolo) · `Campioni Troncati` = **0** ·
`Metro Prima Barra Epoch` **non dopo** `Gamba Prima Barra Epoch` (il metro U30USD
non parte dopo la gamba: il pavimento 2024.09.26 risulta già misurato **anche su
U30USD** in `REFERTO_SONDA_STORICO_17-08.md`, riga "GLI INDICI SONO CONFERMATI
CORTI" — la colonna lo conferma o lo smentisce) · eco dei pin (uscita 0,05, modi
0/0, tenuta 120, orizzonte 24, lato 0). **In più, gli esiti scritti dalla sonda
devono coincidere con la ricalcolo dai `#define`.**

## 📉 IL TETTO DELLE ~100.000 BARRE — la riga SI FERMA sui due M5, non corregge in silenzio

Regola di casa (CLAUDE.md, 25/08): il tester dà **~1,3 anni a M5** e **~4 anni a
M15** per corsa. I quattro prova chiedono **21 mesi = ~1,76 anni**: **M15 sta
dentro** (1,76 < 4), **M5 sta FUORI** (1,76 > 1,3). I prova lo **dichiarano**
(_"possono ECCEDERE il tetto, NON si spezza in tranche, la sonda dichiara da
sola la finestra effettiva"_) e scelgono di non spezzare. Questa riga **non
cambia il prova e non parte in silenzio**: sui M5 il driver **si ferma** con un
messaggio, e riparte **solo** con l'interruttore esplicito **`-AccettoTettoBarre`**,
che finisce nel referto come **scelta dichiarata**. Le due strade, per Claudio:

- **(a) — quella scritta nei blocchi 3 e 4 qui sotto:** lanciare **con
  `-AccettoTettoBarre`**. Il referto stampa la **finestra EFFETTIVA** (`Gamba
  Prima Barra Epoch`, `Giorni Contati` contro i ~459 feriali chiesti, `Barre
  Valutate`) e cerca la **firma del tetto** (classe 36: `Barre Valutate`
  **IDENTICHE** fra D30 e NAS dello stesso TF — a macchina se il CSV del gemello
  è già in workdir, altrimenti **a mano fra i due referti**). C1 resta per-giorno
  sul denominatore **contato**, leggibile; campione e regime si dichiarano.
- **(b) — NON applicata:** un `@DAQUANDO` più vicino nei due prova M5
  (**~2025.03.10** per 1,3 anni), che rispetta il tetto ma **accorcia il
  campione** e rompe l'identità dei quattro gemelli (`@DAQUANDO` diverso fra M5 e
  M15: il gemellaggio andrebbe ridichiarato). È una modifica del prova e **si
  committa**, non si passa da fuori.

| | |
|---|---|
| **Driver** | `righe/RIGA_SONDARELATIVO.ps1` (marcatore `MARCATORE_RIGA_SONDARELATIVO_v4`) |
| **File prova** | i 4 `prove/RELATIVO_*.txt` (scaricati tutti al pin, ne gira uno) |
| **Dove** | **PC di backtest**, non VPS. **MT5 e MetaEditor CHIUSI** |
| **Cosa scrive nel terminale** | `MQL5\Experts\ABTG_SondaRelativo.mq5` + `.ex5` (restano, **dichiarati** nel referto con foto PRIMA/DOPO — classe 116, sentinella `SONDARELATIVO_IN_CORSO.txt` nella workdir `%USERPROFILE%\abtg_sondarelativo`) e svuota `Tester\cache` |

⏱️ **Quanto ci mette [STIMA, non una previsione]:** 49 passate open-prices su ~21
mesi con **due simboli letti a ogni barra** + 2 avvii del terminale (IS + OOS
degenere) + 1 compilazione. **M15: 8–25 minuti** a prova. **M5: 15–45 minuti** a
prova. Giro a vuoto: **1–3 minuti** (ma **COMPILA**: è lì che un EA mai compilato
può cadere, ed è un risultato).

## 📌 IL PIN — **`01743b7ec58ae8376d095b1678a7d2fcd891cd97`**

✅ **RI-PINNATO il 03/09/2026 (sera)** sul commit `01743b7e` (due commit sul
driver: `5c21eca3` alza i gate alla v1.02 dell'EA — `#property version "1.01"
-> "1.02"`, `REL_NSTATS 94 -> 95` cioe' **98 colonne** non piu' 97, autotest
**23** blocchi non piu' 22, stampa nel referto delle due colonne diagnostiche
nuove `Giorni Festa Metro` e `Giorni Metro Zero Calendario` — e `01743b7e`
alza il **marcatore** `_v3 -> _v4` di conseguenza, classe 109-bis: il
contenuto del file citato da un cancello e' cambiato, il marcatore va con
lui, altrimenti una copia locale vecchia sul PC di backtest passerebbe il
controllo `Select-String` della riga). Anche la riga 97 di questa pagina
("Autotest Falliti = 0 su 21 blocchi") era rimasta ferma al v1.00 dal
ri-pin precedente: corretta a 23 qui. Storia del pin precedente (`526f76f6`,
invariata sotto): puntava a un driver coi gate ancora sui numeri VECCHI
della sonda (v1.00 / 21 blocchi / 93 stats / 96 colonne).

✅ **RI-PINNATO il 03/09/2026** sul commit `526f76f6` (fix del driver: gate
ancorati alla v1.01 dell'EA, marcatore `_v2` -> `_v3`). Il pin precedente
puntava a un driver coi gate ancora sui numeri VECCHI della sonda
(v1.00 / 21 blocchi / 93 stats / 96 colonne): l'EA era gia' passato a v1.01 nel
commit `2fd6a1e` (fix C2 giorni spaiati), e il driver non lo sapeva ancora.
Commit di `lavoro` che **contiene** driver + 4 prova + la sonda `.mq5` +
`walkforward_generico.ps1`, **verificato uno per uno via `raw` al pin** (HTTP 200
+ hash identico al repo) prima di scrivere questa riga:

| file al pin | esito |
|---|---|
| `backtest_pipeline/righe/RIGA_SONDARELATIVO.ps1` | 200, identico (sha256 8d8c18d3...), marcatore `MARCATORE_RIGA_SONDARELATIVO_v4` presente, ASCII puro, parse OK (pwsh 7.4.6) |
| `backtest_pipeline/walkforward_generico.ps1` | 200, identico (5d98af3d..., invariato dal pin precedente): il driver lo scarica al pin e lo ri-pinna sul `.mq5` |
| `backtest_pipeline/prove/RELATIVO_D30_M5.txt` · `_D30_M15` · `_NAS_M5` · `_NAS_M15` | 200 tutti e quattro, identici (fa29b70b / 86c0fe18 / 1f9dd9a1 / f8565ef9, invariati dal pin precedente); blocco dei parametri identico riga per riga |
| `mql5/Experts/ABTG_SondaRelativo.mq5` | 200, identico (sha256 23e8e9ec...), `#property version "1.02"`, 23 blocchi autotest, REL_NSTATS 95 (98 colonne), 22 input, 0 chiamate di trading, 0 `#include` |

## 1️⃣ Giro a vuoto (su `D30_M15`: sta dentro il tetto, quindi arriva a COMPILARE e a far girare i controlli del generico; i gate sui 4 prova e sul sorgente girano comunque tutti)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='01743b7ec58ae8376d095b1678a7d2fcd891cd97'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDARELATIVO.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDARELATIVO.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDARELATIVO_v4' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova D30_M15 -SoloControllo; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'SONDARELATIVO_D30_M15_CONTROLLO_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDARELATIVO_D30_M15_CONTROLLO_ DI ADESSO SUL DESKTOP: il controllo non e'' arrivato alla raccolta. Mandami quello che vedi qui sopra.' };
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip qui sotto.' -ForegroundColor Yellow };
    if($ko){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare le corse. Mandami questo zip:' -ForegroundColor Red; Write-Host $z[0].FullName -ForegroundColor Yellow } else { Write-Host 'CONTROLLO OK (fa comunque fede il referto nello zip): lancia i blocchi 2-5, uno alla volta.' -ForegroundColor Green; Write-Host $z[0].FullName -ForegroundColor Gray } }
```

## 2️⃣ Corsa `D30_M15` (dentro il tetto)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='01743b7ec58ae8376d095b1678a7d2fcd891cd97'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDARELATIVO.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDARELATIVO.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDARELATIVO_v4' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova D30_M15; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'SONDARELATIVO_D30_M15_2*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDARELATIVO_D30_M15_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI o FERMATA: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('NEL REFERTO la riga data: e'' l''ORA DI AVVIO di questa corsa (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + '). La freschezza dello zip l''ha gia'' controllata la riga qui sopra.') -ForegroundColor Gray }
```

## 3️⃣ Corsa `NAS_M15` (dentro il tetto)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='01743b7ec58ae8376d095b1678a7d2fcd891cd97'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDARELATIVO.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDARELATIVO.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDARELATIVO_v4' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova NAS_M15; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'SONDARELATIVO_NAS_M15_2*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDARELATIVO_NAS_M15_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI o FERMATA: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('NEL REFERTO la riga data: e'' l''ORA DI AVVIO di questa corsa (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + '). La freschezza dello zip l''ha gia'' controllata la riga qui sopra.') -ForegroundColor Gray }
```

## 4️⃣ Corsa `D30_M5` — ⚠️ **OLTRE IL TETTO BARRE: parte solo con `-AccettoTettoBarre` (strada (a), scelta DICHIARATA nel referto)**

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='01743b7ec58ae8376d095b1678a7d2fcd891cd97'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDARELATIVO.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDARELATIVO.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDARELATIVO_v4' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova D30_M5 -AccettoTettoBarre; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'SONDARELATIVO_D30_M5_2*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDARELATIVO_D30_M5_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI o FERMATA: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('NEL REFERTO la riga data: e'' l''ORA DI AVVIO di questa corsa (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + '). La freschezza dello zip l''ha gia'' controllata la riga qui sopra.') -ForegroundColor Gray }
```

## 5️⃣ Corsa `NAS_M5` — ⚠️ **OLTRE IL TETTO BARRE: parte solo con `-AccettoTettoBarre` (strada (a), scelta DICHIARATA nel referto)**

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='01743b7ec58ae8376d095b1678a7d2fcd891cd97'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDARELATIVO.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDARELATIVO.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDARELATIVO_v4' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova NAS_M5 -AccettoTettoBarre; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'SONDARELATIVO_NAS_M5_2*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDARELATIVO_NAS_M5_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI o FERMATA: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('NEL REFERTO la riga data: e'' l''ORA DI AVVIO di questa corsa (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + '). La freschezza dello zip l''ha gia'' controllata la riga qui sopra.') -ForegroundColor Gray }
```

## 📦 COSA TORNA (per corsa)
Zip sul Desktop **`SONDARELATIVO_<PROVA>_<timestamp>.zip`** →
`REFERTO_SONDARELATIVO_<PROVA>.txt` + `COMPILAZIONE.log` (il log vero di
MetaEditor) + il prova girato + **1 CSV OPTFRAME**
`ABTG_SondaRelativo_<SIMBOLO>_IS_ohlc_<PROVA>.csv` (**49 righe** = le 49
passate, **98 colonne nostre** + gli input accodati dal tester; il driver legge
per NOME; le ultime due, `Giorni Festa Metro` e `Giorni Metro Zero Calendario`,
sono informative — v1.02, fix C2 sulla finestra: la seconda e' il vecchio
criterio v1.01 tenuto come controllo, attesa 0). Il giro a vuoto produce `SONDARELATIVO_D30_M15_CONTROLLO_…zip`
(solo referto + log + prova) **e NON è un risultato**.
⚠️ Il suffisso **`_ohlc`** nei nomi CSV è la marca del generico per ogni modello
non-tick: qui vuol dire **Modello 2, open prices** — non OHLC M1. Niente
per-trade (zero ordini) e niente CSV riga-per-segnale (in ottimizzazione la
sonda lo spegne apposta: le passate si sovrascriverebbero).

## 🔎 COME SI LEGGE — nell'ordine del referto
1. **`data:`** = **l'ora in cui hai LANCIATO il blocco** (il referto si timbra
   all'avvio; la corsa M5 dura decine di minuti). La riga te la stampa in
   console: **l'ora attuale non è il metro.**
2. **`modo:`** = **CORSA**.
3. **`compilazione:`** = OK, con la riga **`Result: 0 errors, N warnings`**
   ricopiata dal log. Se **FALLITA** → **quello È il risultato del passo**
   (prime 30 righe del log nel referto, log intero nello zip). Se **METAEDITOR
   MUTO** → non è un verdetto sul codice: ricontrollare `metaeditor64` chiuso e
   rifare.
4. **Identità del sorgente:** `versione 1.02` · `autotest 23 blocchi` ·
   `REL_NSTATS = 95 -> 98 colonne` · `22 input` · `0 chiamate di trading` ·
   `0 #include` · `celle 49` · `gemellaggio 4 prova: VALIDO`.
5. **`tetto barre:`** — sui M15 `DENTRO IL TETTO`; sui M5 `OLTRE IL TETTO …
   ACCETTATO con -AccettoTettoBarre` **e subito dopo la finestra EFFETTIVA**
   (prima barra gamba/metro, giorni contati su ~459 feriali, barre valutate).
   **Si legge PRIMA di C1.** Il confronto `Barre Valutate` D30↔NAS dello stesso
   TF (**identiche = tetto**) è nei RILIEVI se il gemello era già in workdir,
   altrimenti si fa **a mano** fra i due referti.
6. **Foto PRIMA/DOPO** dei tre file del terminale e la riga `pulizia:`.
7. **I CRITERI DI LETTURA** (stampati dai `#define`, uguali a questa pagina).
8. **I COLLAUDI** (su tutte le righe): autotest 0/23, T6 = 0, sotto 60 s = 0,00,
   punto indice 1,000, spread e soglia C3 del simbolo, troncati 0, storico
   gamba/metro, C2. **Un solo fallimento = NON LEGGIBILE.**
9. **LA CELLA DI RIFERIMENTO N=20 σ=1,05** — la risposta letterale alla
   domanda-sonda: eseguibili/giorno L / S / SOMMA, MFE mediana in punti **e in
   multipli di spread**, MAE, RR e win rate necessario, C6 non convergute, C8
   tenuta, C7 max/giorno, stato della cella (V/S/.).
10. **LE DUE MAPPE 7×7** (una per lato, N in riga × σ in colonna) e il
    **VERDETTO LONG / VERDETTO SHORT** con la regola dell'altopiano.
11. **LE 49 CELLE** in tabella (mai aggregate), poi **PROBLEMI** e **RILIEVI**.

🛑 **Promemoria:** la sonda **non dice se il motore guadagna** — conta occasioni e
misura taglia, geometria, convergenza, tenuta. Non misura la co-integrazione (C6
è la sua approssimazione). Un solo broker, un solo regime (toro). Forma
**unilaterale**: a due gambe i numeri di C3 andrebbero **raddoppiati**. Nessuna
promozione esce da qui: il merito è a tick, dopo, con ≥ 150 operazioni IS.

## 🚦 LE USCITE, UNA PER UNA (**c'è lo zip? sì o no**)
| Cosa succede | Zip sul Desktop | Cosa mandare |
|---|---|---|
| **MT5 o MetaEditor aperto** (il blocco si ferma **prima** di scaricare) | ❌ **NO** | il messaggio rosso; chiudili e rilancia |
| **`SCRIPT VECCHIO`** o download della riga fallito | ❌ **NO** | il messaggio in console (404 sul pin appena creato: aspetta 5 minuti e rilancia **la stessa riga**) |
| **Gate del driver** (pin, `-Prova`, sorgente non 1.02 / autotest ≠ 23 / soglie ≠ pagina / include, prova non gemelli, input mancante, **tetto barre senza interruttore**, terminale ambiguo) | ✅ **SÌ** | lo zip: `compilazione: NON TENTATA` e `!!! FERMATO:` col motivo |
| **Compilazione FALLITA** (o MUTA) | ✅ **SÌ** | lo zip: **è il risultato del passo** (log dentro) |
| **Generico fermato ai suoi controlli / CSV non prodotto / CSV STANTIO** | ✅ **SÌ** | lo zip: `PROBLEMI` lo dice, la corsa non ha numeri, si rilancia **lo stesso blocco** |
| **Corsa OK con collaudi falliti** | ✅ **SÌ** | lo zip: `NON LEGGIBILE`, nessun verdetto — è un dato sulla sonda, non sul mercato |
| **Corsa OK** | ✅ **SÌ** | lo zip |

_(le uscite «gate», «senza -Prova», «pin inesistente → FERMATO → raccolta» sono
state **eseguite** su banco; le funzioni di gate e di analisi CSV sono state
esercitate con 9 mutazioni dei prova e 6 CSV sintetici costruiti dall'header
vero del sorgente — 21/21 verdi. Compilazione e corsa MT5 **non** eseguibili
qui: è il perimetro del giro a vuoto.)_

## 🟡 SE LA RIGA SI FERMA SU **«NON SO QUALE TERMINALE USARE»**
Classe 115: l'ambiente si decide con un **fatto** (`bases\*BCM*` nella cartella
dati), non col nome. La riga stampa l'elenco delle installazioni **con cartella
dati** trovate: copia il percorso di quella di backtest BCM e rilancia lo stesso
blocco aggiungendo `-Terminale "<percorso incollato>"` dopo `-Prova …`.

## 🔴 AVVISI ATTESI (nessuno è un guasto)
1. Il generico stampa **rosso sul CSV `*_OOS`** (una volta per corsa): gamba
   degenere per costruzione (FrazioneIS 1.0). **NON rilanciare**; il conteggio
   `csv *_OOS trovati` (atteso 0) sta **nel referto**.
2. Avviso **giallo** del generico _"il timeframe operativo E' il Period del
   tester"_: la sonda usa `PERIOD_CURRENT` apposta, il TF glielo dà il prova.
3. **NON aprire `anteprima_*.ini`** del giro a vuoto: scrive `Model=4` hardcoded
   (punto 96), la corsa vera usa `Model=2`. Il driver ne controlla **solo
   esistenza e data**.
4. Sui M5 il **RILIEVO sul tetto barre** è atteso (è la scelta (a) dichiarata):
   va letto insieme alla finestra effettiva, non ignorato.
5. Se `Atr Divergenza Rel Media Pct` non è ~0 esce un RILIEVO: la convenzione di
   `iATR` non è la SMA del TR e **va scritto**; l'ATR è eco, non motore.

## 🔧 RICETTA DEL PIN (punti 77 / 77-bis / 77-ter / 101 / 103 della checklist)
```bash
F=backtest_pipeline/righe/RIGA_SONDARELATIVO_DA_MANDARE.md
SHA=$(git rev-parse HEAD)                      # il commit che CONTIENE driver + 4 prova + .mq5
TOK='@@PIN'"@@"                                # composto: la ricetta non contiene il token per esteso
sed -i "s|\$pin='$TOK'|\$pin='$SHA'|g; s|\*\*\`$TOK\`\*\*|\*\*\`$SHA\`\*\*|g" "$F"
# e il CARTELLO del token si RISCRIVE al passato (classe 101), non si lascia:
grep -c "\$pin='$SHA'" "$F"                    # DEVE dare 5 (1 giro a vuoto + 4 corse)
grep -c "\$pin='$TOK'" "$F"                    # DEVE dare 0
CART='segnap'"osto\|non funz"'iona\|la riga non par'"te"   # composto, come TOK
grep -ci "$CART" "$F"                          # DEVE dare 0 (cartello riscritto, non lasciato)
# RI-PINNATURA (vecchio -> nuovo): il vecchio si legge DAI PUNTI D'USO, la prosa e' storia e non si tocca
VECCHIO=$(grep -oE "\\\$pin='[0-9a-f]{40}'" "$F" | head -1 | grep -oE '[0-9a-f]{40}')
sed -i "s|\$pin='$VECCHIO'|\$pin='$NUOVO'|g; s|\*\*\`$VECCHIO\`\*\*|\*\*\`$NUOVO\`\*\*|g" "$F"
grep -rn "${VECCHIO:0:7}" backtest_pipeline/   # DEVE dare 0 (quarto conteggio, sul prefisso)
```
