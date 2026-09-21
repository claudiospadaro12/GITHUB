# 🚀 R196a — IL PAVIMENTO D'AMPIEZZA SUL NASDAQ (`770260`), la riga di lancio

**21/09/2026** · branch `lavoro` · pin della riga: **`7bc2691a9a0546f1c49e310b6f7eb19546339b7a`**
File prova: `backtest_pipeline/prove/R196a_pavimento_ampiezza_NASDAQ_NASUSD.txt` (24 pin, 2 celle)
Referto atteso: `report/AMPIEZZA_RANGE_NASDAQ_2026-09-21.md`

---

## 🟢 COSA MISURA, IN UNA RIGA

> **Asse unico `InpMinRangePts`: `0` (filtro spento) contro `7200` (= 40 × spread mediano misurato).**
> L'attesa è **dichiarata prima dei numeri**: il PF deve **salire**, e il calo di `n` dice
> **quale delle due fonti di casa descrive i giorni veri** — ANATOMIA/HistData predice
> **−11%**, Studio_NASUSD/tick BCM predice **−28/−34%**. Un calo intermedio (15-25%) **non
> distingue**, e allora si dichiara così.

---

## ① 🖥️ DOVE MANDARE QUESTA STRINGA

> ## 🖥️ **finestra PowerShell sul PC DI BACKTEST `DESKTOP-H4D7CAJ`** (utente `Master`).
> **Bersaglio: l'unico MT5 di quella macchina, `C:\Program Files\BCM Markets MT5 Terminal`, demo `50503392`.**
>
> 🔴 **COSA NON VIENE TOCCATO.** Tutto ciò che vive **sul VPS**: la challenge **FTMO `541452707`**
> (`C:\FTMO`, **sei sedie che stanno operando**), il **100k `50504263`**, il **REALE `10105439`**
> (`C:\BCM_Reale`), il piccolo del VPS, Pepperstone, Tickmill, e il banco `C:\MT5_Backtest`.
> Non è una promessa: è **un'altra macchina**, e la riga **si rifiuta di partire** se
> `$env:COMPUTERNAME` non è `DESKTOP-H4D7CAJ` — muore **prima** di scaricare qualunque cosa.
>
> ✋ **PRIMA DI INCOLLARE: chiudi MT5 sul PC di backtest.** La riga **non lo chiude da sola**,
> apposta: quel terminale **è loggato su un conto demo vivo** (`50503392`) e il **14/08/2026**
> da quella macchina sono partiti **ordini veri**. Se lo trova aperto stampa PID + titolo +
> cartella e **si ferma**, così il riconoscimento è un fatto stampato e non un'intuizione.

```powershell
$pin='7bc2691a9a0546f1c49e310b6f7eb19546339b7a'; if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('VIETATO: questa riga gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama ' + $env:COMPUTERNAME + '. Sul VPS operano le sei sedie della challenge FTMO e un backtest a tick reali lo inchioda: firma di Claudio del 21/09.') };
$w="$env:USERPROFILE\abtg_round"; $p="$w\RIGA_ROUND_VPS.ps1"; $dsk=[Environment]::GetFolderPath('Desktop'); $tmo=240;
New-Item -ItemType Directory -Force -Path $w | Out-Null; Remove-Item $p -Force -ErrorAction SilentlyContinue;
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ROUND_VPS.ps1?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $p -ErrorAction Stop;
if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' };
if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ROUND_VPS_v2' -Quiet)){ throw 'SCRIPT VECCHIO: manca MARCATORE_RIGA_ROUND_VPS_v2' };
Write-Host 'BERSAGLIO: il solo MT5 di questo PC, C:\Program Files\BCM Markets MT5 Terminal, demo 50503392. Tutto il resto (challenge FTMO 541452707, 100k 50504263, REALE 10105439, Pepperstone, Tickmill, banco 50504400) sta su una macchina diversa e questa riga non la raggiunge.' -ForegroundColor Cyan;
$mt=@(Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id,MainWindowTitle,Path); Write-Host '--- MT5 APERTI SU QUESTA MACCHINA (PID / titolo / cartella) ---'; $mt | Format-Table -AutoSize;
if(@($mt | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') }).Count -gt 0){ throw 'MT5 E APERTO: chiudilo A MANO (il PID sta nella tabella qui sopra), dopo aver guardato che non abbia EA attaccati, poi reincolla la riga. Non lo chiudo io: quel terminale e loggato sul demo 50503392 e da questa macchina il 14/08 sono partiti ordini veri.' };
Write-Host '=== ROUND R196A   EA ABTG_Nasdaq_Apertura_US   NASUSD M5   tick reali   deposito 80000   2 celle x 2 gambe ===' -ForegroundColor Cyan;
$a=@('-NoProfile','-ExecutionPolicy','Bypass','-File',('"'+$p+'"'),'-Expert','ABTG_Nasdaq_Apertura_US','-Prova','R196a_pavimento_ampiezza_NASDAQ_NASUSD.txt','-Etichetta','R196A','-Pin',$pin,'-TerminaleBacktest','"C:\Program Files\BCM Markets MT5 Terminal"','-Modello','4','-Deposito','80000');
$pr=Start-Process powershell -ArgumentList $a -NoNewWindow -PassThru;
if(-not $pr.WaitForExit($tmo*60*1000)){ Write-Host ('TETTO DI ' + $tmo + ' MINUTI SFONDATO: fermo il round. E UN RISULTATO, NON UN GUASTO: il referto che resta e PARZIALE.') -ForegroundColor Red; Stop-Process -Id $pr.Id -Force -ErrorAction SilentlyContinue; Get-Process metatester64,terminal64 -ErrorAction SilentlyContinue | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') } | Stop-Process -Force -ErrorAction SilentlyContinue; try{ $pr.WaitForExit() }catch{}; Start-Sleep -Seconds 10 };
$rc=$pr.ExitCode; if($null -eq $rc){ $rc='NON LEGGIBILE' }; Write-Host ('   esito R196A: codice ' + $rc + '   (0=GIRATO  2=NON MISURATO  3=GIRATO CON RILIEVI  1=non e partito)') -ForegroundColor Yellow;
$d="$dsk\ROUND_R196A"; if(-not (Test-Path $d)){ Write-Host 'MANCA la cartella ROUND_R196A sul Desktop: il round NON ha prodotto raccolta.' -ForegroundColor Red } else { Compress-Archive -Path "$d\*" -DestinationPath "$dsk\ROUND_R196A.zip" -Force; Write-Host 'ZIP PRONTO DA MANDARE: Desktop\ROUND_R196A.zip' -ForegroundColor Green };
Write-Host 'FILE ATTESI NELLO ZIP (4):' -ForegroundColor Gray;
Write-Host '   REFERTO_ROUND_R196A.txt' -ForegroundColor Gray;
Write-Host '   ABTG_Nasdaq_Apertura_US_NASUSD_IS_R196A.csv' -ForegroundColor Gray;
Write-Host '   ABTG_Nasdaq_Apertura_US_NASUSD_OOS_R196A.csv' -ForegroundColor Gray;
Write-Host '   R196a_pavimento_ampiezza_NASDAQ_NASUSD.txt' -ForegroundColor Gray;
Write-Host 'NEL REFERTO LEGGI LA RIGA  data:  -- DEVE ESSERE DI OGGI, altrimenti stai guardando un file vecchio.' -ForegroundColor Yellow;
if(Test-Path $d){ Get-ChildItem $d -Recurse -File | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize }
```

📅 **Quale data deve leggere Claudio**: dentro `REFERTO_ROUND_R196A.txt`, la riga che comincia
con **`data            :`**. Il referto la scrive già col suo avvertimento accanto
(*«SE QUESTA DATA NON E' DI OGGI, IL FILE E' VECCHIO»*). Il 17/08 un referto stantio è stato
rimandato **due volte** in buona fede: si guarda quella riga **prima** di leggere i numeri.

---

## ② 📐 IL TETTO DELLE ~100.000 BARRE — **non sfora, e il numero c'è**

Il round **non** gira su 21 mesi in una volta: `walkforward_generico.ps1` taglia la finestra in
**due corse separate** (r.931-938), e il tetto vale **per corsa**.

| | finestra | giorni | sessioni (~5/7) | barre M5 stimate |
|---|---|---:|---:|---:|
| **IS** (`FrazioneIS` 0,40, r.189) | 2024.09.26 → 2025.06.09 | 256 | ~183 | **~50.500** |
| **OOS** | 2025.06.10 → 2026.06.30 | 386 | ~276 | **~76.200** |

Metodo dichiarato: `@DAQUANDO 2024.09.26` dal file prova, `-Fino` **non passato** dalla riga →
il default del driver `2026.06.30` (r.187); NASUSD è un CFD su indice con sessione ~23h →
**276 barre M5 al giorno**. 🟢 **Anche a 24h/24 (288 barre/giorno) si resta sotto**: 52.700 e
79.500.

🟢 **E c'è la prova empirica, che vale più della stima**: lo **stesso EA, stesso simbolo,
stesso M5, stessa finestra** è già girato e ha prodotto il CSV da cui viene la cella schierata
— `backtest_pipeline/risultati_archivio/Walkforward_Aperture/NASDAQ_B_motore_OOS.csv`,
**12 righe**, la `Pass=8` con **n=94 · PF 1,10936 · DD 3,6753%**. Non serve spezzare niente.

🟠 **Quello che invece può fermare la corsa è un'impostazione, non l'aritmetica.** Il pre-volo
della classe 160 (`RIGA_ROUND_VPS.ps1` r.966-980) legge `MaxBars` dal `config\common.ini`
della cartella dati **di quel terminale** e **muore** se sta fra 1.000 e 200.000. Su quella
macchina **non l'ho potuto misurare da qui** (è un file suo). Se la riga si ferma con
`TETTO BARRE NEL GRAFICO = ...`: aprire MT5 sul PC di backtest → **Strumenti > Opzioni >
Grafici > «Max barre nel grafico» = Illimitato** → **chiudere** il terminale → reincollare la
riga. Costa un giro, e il giro è **dichiarato prima**, non scoperto dopo.

---

## ③ ⏱️ IL TETTO DI TEMPO — **240 minuti, ed è un TETTO, non una stima**

4 passate a tick reali (2 celle × 2 gambe) su ~1 anno di M5 ciascuna. Non ho una base di costo
misurata per **questo** EA su **questa** finestra, quindi **non fingo di stimarla**: metto un
tetto largo che serve solo a impedire che un tester appeso resti lì per sempre.
⚠️ **Se il tetto scatta NON è un successo** (checklist p.19): la riga lo dice in rosso e il
referto che resta è **PARZIALE**.
🔴 **E la chiusura di emergenza è chirurgica e su una COSTANTE**: `Stop-Process` colpisce solo
`metatester64`/`terminal64` il cui `Path` sta sotto `C:\Program Files\BCM Markets MT5 Terminal\`
— che su questa macchina è l'unico MT5, e che la riga ha **già verificato chiuso** prima di
partire. Non c'è nessuna variabile che arrivi da fuori dentro quel filtro.

---

## ④ 🚦 IL CANCELLO

- `python3 backtest_pipeline/controlla_riga.py --oggetto md backtest_pipeline/righe/RIGA_R196A_DA_MANDARE.md` → **verde**.
- `python3 backtest_pipeline/controlla_riga.py --oggetto prova backtest_pipeline/prove/R196a_pavimento_ampiezza_NASDAQ_NASUSD.txt` → **verde**.
- 🟢 **E questa riga è il primo caso che usa la deroga della classe 536**: passa
  `-TerminaleBacktest 'C:\Program Files\BCM Markets MT5 Terminal'`, che resta **VIETATO sul
  VPS** e diventa **ammesso solo perché la riga si inchioda a `DESKTOP-H4D7CAJ`**. Togli quella
  guardia e il cancello la **blocca** — è un contro-esempio tenuto e rigirabile
  (`controesempi_cancello.py`, caso *«STESSA RIGA senza NESSUNA macchina dichiarata»*).
