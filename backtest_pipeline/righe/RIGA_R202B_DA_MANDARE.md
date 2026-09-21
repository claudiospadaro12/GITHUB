# 🚀 R202B — QUANTO SPESSO DEVE SCATTARE LA PROTEZIONE, sedia DAX `770101`

**21/09/2026** · branch `lavoro` · pin della riga: **`f6571ef41b0b7447259a924368bb7e9689f28130`**
File prova: `backtest_pipeline/prove/R202b_obiettivo_DAX_D30EUR.txt` (90 pin, **4 celle**)

---

## 🟢 COSA MISURA, IN UNA RIGA

> **Asse unico `InpTP1_R`: `1.00` → `0.75` → `0.50` → `0.25`, con la parziale al 50% e
> il breakeven a TP1 GIÀ ACCESI e inchiodati.**
>
> 🔴 **Perché non è «la stessa cosa del Nasdaq», e va detto subito**: su questa sedia
> `InpTP1_ClosePct=50` e `InpBreakevenAtTP1=true` sono **già in campo da prima**. Non c'è
> niente da accendere. L'**unica** riga che differisce dal Nasdaq `770260` è `InpTP1_R`
> (**1,0** qui contro **0,5** là), e quella riga decide **quanto spesso la protezione
> scatta**: a 1,0R il parziale parte nel **28-35%** delle posizioni, a 0,5R nel **65-69%**.
>
> ⚠️ **E non muove solo il parziale.** `ABTG_*_Apertura_*.mq5` r.1694: **bersaglio finale
> = `InpTP1_R` × 3**. Quindi l'asse muove la geometria intera — `1,00` → TP a 3,00R,
> `0,25` → TP a 0,75R. **Non è una manopola, è il disegno dell'operazione**, e per questo
> si misura invece di copiarla dal Nasdaq.

### 🎯 L'ATTESA, DICHIARATA **PRIMA** DEI NUMERI

| # | cosa mi aspetto | e se non succede |
|---|---|---|
| **a** | la cella `1.0` **riproduce R201A** entro l'arrotondamento | se non riproduce, **il round non è confrontabile**: si cerca il pin che balla, non si legge il resto |
| **b** | scendendo, `n` **sale** (bersaglio più vicino = più uscite contate) | se `n` **non** sale, `InpTP1_R` non sta facendo quello che credo e il referto va riletto |
| **c** | IS e OOS **concordi** sulla direzione | discordi → **nessuna cella si promuove**, si dichiara «non deciso» |
| **d** | si sceglie il **centro dell'altopiano**, **MAI il picco** | con 4 celle un altopiano può non esserci: allora il verdetto è **«serve più risoluzione»**, non una cella |

🔴 **E L'AVVERTENZA CHE HA GIÀ INGANNATO UNA VOLTA (R199B).** `STAT_TRADES` conta le
**uscite**, non le posizioni: col parziale acceso **una posizione produce due uscite**. Quindi
`Trades` che sale **NON vuol dire più operazioni**, vuol dire più **parziali scattati** — che
è esattamente ciò che l'asse muove. 🟠 E il fattore di conversione **non si trasporta**: fra
celle della **stessa** sedia è stato misurato da **1,015 a 1,612**. Le posizioni vere si
contano **una per una** dopo, non si dividono a memoria.

### ⚓ LE ANCORE (da R201A, stessa macchina, stasera)

| finestra | ancora della cella viva |
|---|---|
| **IS** | n **175** · PF **1,12733** · DD **5,4089%** |
| **OOS** | n **270** · PF **1,39520** · DD **7,2506%** |

---

## ① 🖥️ DOVE MANDARE QUESTA STRINGA

> ## 🖥️ **finestra PowerShell sul PC DI BACKTEST `DESKTOP-H4D7CAJ`** (utente `Master`).
> **Bersaglio: l'unico MT5 di quella macchina, `C:\Program Files\BCM Markets MT5 Terminal`, demo `50503392`.**
>
> 🔴 **COSA NON VIENE TOCCATO.** Tutto ciò che vive **sul VPS**: la challenge **FTMO `541452707`**
> (`C:\FTMO`, **sei sedie che stanno operando**), il **100k `50504263`**, il **REALE `10105439`**
> (`C:\BCM_Reale`), il piccolo `50503392` del VPS, Pepperstone, Tickmill, e il banco `50504400`
> (`C:\MT5_Backtest`, **spento**). Non è una promessa: è **un'altra macchina**, e la riga
> **si rifiuta di partire** se `$env:COMPUTERNAME` non è `DESKTOP-H4D7CAJ` — muore **prima**
> di scaricare qualunque cosa.
>
> ✋ **PRIMA DI INCOLLARE: chiudi MT5 sul PC di backtest.** La riga **non lo chiude da sola**,
> apposta: quel terminale **è loggato su un conto demo vivo** (`50503392`) e il **14/08/2026**
> da quella macchina sono partiti **ordini veri**. Se lo trova aperto stampa PID + titolo +
> cartella e **si ferma**.
>
> 🟢 **E `50504400` resta fuori per costruzione**: la firma del 21/09 (*«si, i round sul pc
> di backtest»*) nasce dal VPS inchiodato alle 09:29 **da un tester**. Questa riga non può
> raggiungerlo: gira su un'altra macchina e si inchioda al suo nome.


```powershell
& { $ErrorActionPreference='Stop'; $pin='f6571ef41b0b7447259a924368bb7e9689f28130'; if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('VIETATO: questa riga gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama ' + $env:COMPUTERNAME + '. Sul VPS operano le sei sedie della challenge FTMO e un backtest a tick reali lo inchioda: firma di Claudio del 21/09.') }; $w="$env:USERPROFILE\abtg_round"; $p="$w\RIGA_ROUND_VPS.ps1"; $dsk=[Environment]::GetFolderPath('Desktop'); $tmo=120; New-Item -ItemType Directory -Force -Path $w | Out-Null; Remove-Item $p -Force -ErrorAction SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ROUND_VPS.ps1?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $p -ErrorAction Stop; if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ROUND_VPS_v2' -Quiet)){ throw 'SCRIPT VECCHIO: manca MARCATORE_RIGA_ROUND_VPS_v2' }; Write-Host 'BERSAGLIO: il solo MT5 di questo PC, C:\Program Files\BCM Markets MT5 Terminal, demo 50503392. Tutto il resto (challenge FTMO 541452707, 100k 50504263, REALE 10105439, Pepperstone, Tickmill, banco 50504400) sta su una macchina diversa e questa riga non la raggiunge.' -ForegroundColor Cyan; $mt=@(Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id,MainWindowTitle,Path); Write-Host '--- MT5 APERTI SU QUESTA MACCHINA (PID / titolo / cartella) ---'; $mt | Format-Table -AutoSize; if(@($mt | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') }).Count -gt 0){ throw 'MT5 E APERTO: chiudilo A MANO (il PID sta nella tabella qui sopra), dopo aver guardato che non abbia EA attaccati, poi reincolla la riga. Non lo chiudo io: quel terminale e loggato sul demo 50503392 e da questa macchina il 14/08 sono partiti ordini veri.' }; Write-Host '=== ROUND R202B   EA ABTG_DAX_Apertura_EU   D30EUR M5   tick reali   deposito 80000   4 celle x 2 gambe ===' -ForegroundColor Cyan; $a=@('-NoProfile','-ExecutionPolicy','Bypass','-File',('"'+$p+'"'),'-Expert','ABTG_DAX_Apertura_EU','-Prova','R202b_obiettivo_DAX_D30EUR.txt','-Etichetta','R202B','-Pin',$pin,'-TerminaleBacktest','"C:\Program Files\BCM Markets MT5 Terminal"','-Modello','4','-Deposito','80000'); $pr=Start-Process powershell -ArgumentList $a -NoNewWindow -PassThru; if(-not $pr.WaitForExit($tmo*60*1000)){ Write-Host ('TETTO DI ' + $tmo + ' MINUTI SFONDATO: fermo il round. E UN RISULTATO, NON UN GUASTO: il referto che resta e PARZIALE.') -ForegroundColor Red; Stop-Process -Id $pr.Id -Force -ErrorAction SilentlyContinue; Get-Process metatester64,terminal64 -ErrorAction SilentlyContinue | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') } | Stop-Process -Force -ErrorAction SilentlyContinue; try{ $pr.WaitForExit() }catch{}; Start-Sleep -Seconds 10 }; $rc=$pr.ExitCode; if($null -eq $rc){ $rc='NON LEGGIBILE' }; Write-Host ('   esito R202B: codice ' + $rc + '   (0=GIRATO  2=NON MISURATO  3=GIRATO CON RILIEVI  1=non e partito)') -ForegroundColor Yellow; $d="$dsk\ROUND_R202B"; if(-not (Test-Path $d)){ Write-Host 'MANCA la cartella ROUND_R202B sul Desktop: il round NON ha prodotto raccolta.' -ForegroundColor Red } else { Compress-Archive -Path "$d\*" -DestinationPath "$dsk\ROUND_R202B.zip" -Force; Write-Host 'ZIP PRONTO DA MANDARE: Desktop\ROUND_R202B.zip' -ForegroundColor Green }; Write-Host 'FILE ATTESI NELLO ZIP (4):' -ForegroundColor Gray; Write-Host '   REFERTO_ROUND_R202B.txt' -ForegroundColor Gray; Write-Host '   ABTG_DAX_Apertura_EU_D30EUR_IS_R202B.csv' -ForegroundColor Gray; Write-Host '   ABTG_DAX_Apertura_EU_D30EUR_OOS_R202B.csv' -ForegroundColor Gray; Write-Host '   R202b_obiettivo_DAX_D30EUR.txt' -ForegroundColor Gray; Write-Host 'NEL REFERTO LEGGI LA RIGA  data:  -- DEVE ESSERE DI OGGI, altrimenti stai guardando un file vecchio.' -ForegroundColor Yellow; if(Test-Path $d){ Get-ChildItem $d -Recurse -File | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize } }
```

📅 **Quale data deve leggere Claudio**: dentro `REFERTO_ROUND_R202B.txt`, la riga che
comincia con **`data            :`**. Il 17/08 un referto stantio è stato rimandato **due
volte** in buona fede: si guarda quella riga **prima** di leggere i numeri.

---

## ② 📐 IL TETTO DELLE ~100.000 BARRE — **misurato, non stimato**

Non serve nessuna stima: **lo stesso EA, lo stesso simbolo, lo stesso M5, la stessa identica
finestra** (`@DAQUANDO 2024.09.26`, `@FINOA 2026.06.30`, `@FRAZIONEIS 0.40`) è già girato
**stasera** e il referto riporta `tetto barre : MaxBars=100000000`. Il pre-volo della classe 160
muore solo se `MaxBars` sta **fra 1.000 e 200.000**: qui è cento milioni, quindi passa.
🟢 E le due corse sono **separate** (`walkforward_generico.ps1` r.931-938): il tetto vale
**per corsa**, non per il round.


---

## ③ ⏱️ IL TETTO DI TEMPO — **120 minuti, ed è un TETTO, non una stima**

🟠 **E dichiaro quello che NON so.** `R172D` e `R201A` sono girati stasera sulla **stessa
macchina**, con gli **stessi EA**, la **stessa finestra**, **14 passate ciascuno**: i due referti
portano avvio `21:01:33` e `21:05:24`, **3 minuti e 51 secondi** di distanza. **SE** sono stati
lanciati in fila in una sola console, allora 14 passate costano meno di 4 minuti e queste 8 ne
costano ~2. ⚠️ **Ma che fossero in fila non lo posso provare** (potevano essere due console in
parallelo), quindi **non lo uso come stima**: metto un tetto **largo trenta volte**, che serve
solo a impedire che un tester appeso resti lì per sempre.

⚠️ **Se il tetto scatta NON è un successo** (checklist p.19): la riga lo dice in rosso e il
referto che resta è **PARZIALE**.
🔴 **La chiusura d'emergenza è chirurgica e su una COSTANTE**: `Stop-Process` colpisce solo
`metatester64`/`terminal64` il cui `Path` sta sotto `C:\Program Files\BCM Markets MT5 Terminal\`
— su quella macchina l'unico MT5, e che la riga ha **già verificato chiuso** prima di partire.


---

## ④ 🚦 IL CANCELLO

- `python3 backtest_pipeline/controlla_prova.py backtest_pipeline/prove/R202b_obiettivo_DAX_D30EUR.txt` → **verde** (4 celle, 0 problemi).
- `python3 backtest_pipeline/controlla_riga.py --oggetto md backtest_pipeline/righe/RIGA_R202B_DA_MANDARE.md` → **verde**.
- **Parser PowerShell** sulla riga: **0 errori**. **Una sola riga fisica** (classe 538), **zero caratteri non-ASCII**.
- **Contro-esempio tenuto**: la riga è stata confrontata **parola per parola** con la riga
  già provata di `R196A`. Le **uniche** differenze sono: `pin`, `tmo`, etichetta, EA,
  simbolo, numero di celle, nome del file prova e nomi dei file attesi. **Niente altro è
  cambiato**, e lo stesso confronto è stato rifatto fra `R202A` e `R202B`.
- **Il file prova è verificato per differenza**: costruito dai pin di `R201A`, cambiano
  **DUE righe e basta** (`InpTP1_R` da pin ad asse, `InpBEatR` da asse a pin `0.0`); le
  direttive `@` sono **identiche** alla sorgente e i pin sono **90** prima e dopo.
- **Gli URL del pin rispondono `200`** (driver + file prova), verificato prima di mandare.
