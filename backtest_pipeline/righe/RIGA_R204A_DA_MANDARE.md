# 🚀 R204A — OLTRE L'UNO: il lato dell'asse mai guardato, sedia Dow `770202`

**22/09/2026** · branch `lavoro` · pin della riga: **`9a080fc729a29595e4d9c50c3494875fbe34ade2`**
File prova: `backtest_pipeline/prove/R204a_oltre_uno_DOW_U30USD.txt` (80 pin, **4 celle**)
— **i cancelli sono congelati in quel file** (classe 549: si numerano una volta sola; qui c'è
solo una mappa di lettura).

---

## 🟢 COSA MISURA, IN UNA RIGA

> **Asse unico `InpTP1_R`: `1.00` → `1.25` → `1.50` → `1.75`.** La direzione **opposta** a
> `R202A`, con `1.00` — la cella viva — come **ancora di riproduzione**.

🔴 **Perché esiste.** `R202A` ha misurato l'asse **sotto** l'uno, e la superficie OOS è
risultata **monotona crescente** con il massimo **sul bordo**:

| `InpTP1_R` | 0.25 | 0.50 | 0.75 | **1.00** ← viva |
|---|---:|---:|---:|---:|
| **PF OOS** | 0,932 | 1,103 | 1,137 | 🎯 **1,272** |
| **profitto** | −864,82 | 1.736,27 | 2.557,50 | 🎯 **5.395,25** |

> 👉 **Un massimo sul bordo non è un ottimo: è il punto in cui abbiamo smesso di guardare.**

---

## 🛑 CHE COSA QUESTO ROUND **NON** PUÒ FARE — e va letto prima dei numeri

Le **posizioni** del Dow stanno, **dimostrato**, fra **48 e 74** in IS e fra **81 e 130** in OOS
(con `n = P + f` e `0 ≤ f ≤ P` vale `max(n)/2 ≤ P ≤ min(n)`). L'emendamento del 16/08,
**regola A**, chiede **IS ≥ 150 operazioni**: il Dow è **sotto con certezza in tutte e due le
finestre**.

> 🔴 **Nessuna cella di questo round può essere promossa in campo.** Una cella che vince si
> guadagna **una finestra più lunga**, non una sedia. Il verdetto legittimo è una **DIREZIONE**.
> 🟢 Il **rischio** invece si giudica lo stesso, a qualunque `n` (regola B): un DD accaduto
> è un fatto.

---

## 💸 LA COSA BELLA, ED È L'OPPOSTO DI R203: **il costo si allontana salendo**

Stop mediano Dow **123,80** punti indice `[MIS n=446]`
(`report/STOP_VS_SPREAD_FTMO_2026-09-20.md` **r.276**) · spread mediano `U30USD` ora 14 =
**2,00** (**r.312**). Primo obiettivo = `InpTP1_R × stop`:

| cella | primo obiettivo | × spread | bersaglio finale (×3) |
|---|---:|---:|---:|
| **`1.00`** ← viva | 123,80 pt | **61,9×** | 3,00 R |
| `1.25` | 154,75 pt | **77,4×** | 3,75 R |
| `1.50` | 185,70 pt | **92,9×** | 4,50 R |
| `1.75` | 216,65 pt | **108,3×** | 5,25 R |

🟢 **Tutte e quattro stravolgono la frontiera dei 40×** e il pavimento duro di 13,3×.
**È la prima volta in questa serie che il costo non è un vincolo.**

⚠️ **E il meccanismo cambia, dichiarato prima.** A `1.75` il bersaglio finale sta a **5,25 R**
(`ABTG_Dow_Apertura_US.mq5` **r.1456**, `TpTotalR`): è **plausibile che quasi nessuna posizione
lo raggiunga** e che la sedia diventi guidata dal **trailing** (`InpTrailStartR=0.0`,
`InpTrailMode=1`, `InpTrailFixedPts=410`) e dalla **chiusura a fine sessione**.
👉 **Fra la cella `1.00` e la `1.75` non cambia una manopola: cambia CHI chiude le
operazioni.**

---

## 🎯 LA MAPPA DI LETTURA (la regola sta nel file prova)

| | cosa mi aspetto | se non succede |
|---|---|---|
| **(a)** | la cella `1.00` **riproduce** R202A Pass 3 · tolleranza **un centesimo** sul Profit, uguaglianza su `n`/`PF`/`DD` alla quinta cifra | `(a)` **fallisce**: round non confrontabile, si cerca il pin che balla |
| **(b)** | `n` **SCENDE** salendo — più lontano il primo obiettivo, meno spesso scatta il parziale, meno **uscite** | se `n` non scende, il round **non ha misurato quello che crede** |
| **(c)** | 🎯 **la DIREZIONE**: la superficie OOS **continua a salire** → l'ottimo è ancora più in là; **gira** → abbiamo trovato la cresta; **scende subito** → `1.00` era il massimo, e il *«non ancora misurato»* si chiude con un **NO** | tutte e tre sono **risultati**, anche la terza |
| **(d)** | IS e OOS **concordi** | discordi → **nessuna direzione** si dichiara |
| **(e)** | **rischio**: nessuna cella alza il DD — misurato a **denominatore fisso** `(Profit/RF)/80000×100`, cella viva **4,4499** | allarme sopra **4,89** (+10%) |

🔴 **Il DD si legge a denominatore fisso, NON su `Equity DD %`** — classe 550: quello divide
per il **picco**, che cambia da cella a cella. Su `R202B` la distorsione vale **+22,8%**, più del
margine di un cancello a −20%, e fra due celle **l'ordine si ribalta**.

---

## ① 🖥️ DOVE MANDARE QUESTA STRINGA

> ## 🖥️ **finestra PowerShell sul PC DI BACKTEST `DESKTOP-H4D7CAJ`** (utente `Master`).
> **Bersaglio: l'unico MT5 di quella macchina, `C:\Program Files\BCM Markets MT5 Terminal`, demo `50503392`.**
>
> 🔴 **COSA NON VIENE TOCCATO.** Tutto ciò che vive **sul VPS**: la challenge **FTMO
> `541452707`** (`C:\FTMO`, **sei sedie che stanno operando**), il **100k `50504263`**, il
> **REALE `10105439`** (`C:\BCM_Reale`), il piccolo del VPS, Pepperstone, Tickmill e il banco
> `50504400` (spento). È **un'altra macchina**, e il `throw` è il **primo statement dopo
> `$pin`**: muore **prima** di scaricare qualunque cosa.
>
> ✋ **Chiudi MT5 su quel PC prima di incollare.** Se lo trova aperto stampa PID + titolo +
> cartella e **si ferma**.

```powershell
& { $ErrorActionPreference='Stop'; $pin='9a080fc729a29595e4d9c50c3494875fbe34ade2'; if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('VIETATO: questa riga gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama ' + $env:COMPUTERNAME + '. Sul VPS operano le sei sedie della challenge FTMO e un backtest a tick reali lo inchioda: firma di Claudio del 21/09.') }; $w="$env:USERPROFILE\abtg_round"; $p="$w\RIGA_ROUND_VPS.ps1"; $dsk=[Environment]::GetFolderPath('Desktop'); $tmo=120; New-Item -ItemType Directory -Force -Path $w | Out-Null; Remove-Item $p -Force -ErrorAction SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ROUND_VPS.ps1?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $p -ErrorAction Stop; if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ROUND_VPS_v2' -Quiet)){ throw 'SCRIPT VECCHIO: manca MARCATORE_RIGA_ROUND_VPS_v2' }; Write-Host 'BERSAGLIO: il solo MT5 di questo PC, C:\Program Files\BCM Markets MT5 Terminal, demo 50503392. Tutto il resto (challenge FTMO 541452707, 100k 50504263, REALE 10105439, Pepperstone, Tickmill, banco 50504400) sta su una macchina diversa e questa riga non la raggiunge.' -ForegroundColor Cyan; $mt=@(Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id,MainWindowTitle,Path); Write-Host '--- MT5 APERTI SU QUESTA MACCHINA (PID / titolo / cartella) ---'; $mt | Format-Table -AutoSize; if(@($mt | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') }).Count -gt 0){ throw 'MT5 E APERTO: chiudilo A MANO (il PID sta nella tabella qui sopra), dopo aver guardato che non abbia EA attaccati, poi reincolla la riga. Non lo chiudo io: quel terminale e loggato sul demo 50503392 e da questa macchina il 14/08 sono partiti ordini veri.' }; Write-Host '=== ROUND R204A   EA ABTG_Dow_Apertura_US   U30USD M5   tick reali   deposito 80000   4 celle x 2 gambe ===' -ForegroundColor Cyan; $a=@('-NoProfile','-ExecutionPolicy','Bypass','-File',('"'+$p+'"'),'-Expert','ABTG_Dow_Apertura_US','-Prova','R204a_oltre_uno_DOW_U30USD.txt','-Etichetta','R204A','-Pin',$pin,'-TerminaleBacktest','"C:\Program Files\BCM Markets MT5 Terminal"','-Modello','4','-Deposito','80000'); $pr=Start-Process powershell -ArgumentList $a -NoNewWindow -PassThru; if(-not $pr.WaitForExit($tmo*60*1000)){ Write-Host ('TETTO DI ' + $tmo + ' MINUTI SFONDATO: fermo il round. E UN RISULTATO, NON UN GUASTO: il referto che resta e PARZIALE.') -ForegroundColor Red; Stop-Process -Id $pr.Id -Force -ErrorAction SilentlyContinue; Get-Process metatester64,terminal64 -ErrorAction SilentlyContinue | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') } | Stop-Process -Force -ErrorAction SilentlyContinue; try{ $pr.WaitForExit() }catch{}; Start-Sleep -Seconds 10 }; $rc=$pr.ExitCode; if($null -eq $rc){ $rc='NON LEGGIBILE' }; Write-Host ('   esito R204A: codice ' + $rc + '   (0=GIRATO  2=NON MISURATO  3=GIRATO CON RILIEVI  1=non e partito)') -ForegroundColor Yellow; $d="$dsk\ROUND_R204A"; if(-not (Test-Path $d)){ Write-Host 'MANCA la cartella ROUND_R204A sul Desktop: il round NON ha prodotto raccolta.' -ForegroundColor Red } else { Compress-Archive -Path "$d\*" -DestinationPath "$dsk\ROUND_R204A.zip" -Force; Write-Host 'ZIP PRONTO DA MANDARE: Desktop\ROUND_R204A.zip' -ForegroundColor Green }; Write-Host 'FILE ATTESI NELLO ZIP (4):' -ForegroundColor Gray; Write-Host '   REFERTO_ROUND_R204A.txt' -ForegroundColor Gray; Write-Host '   ABTG_Dow_Apertura_US_U30USD_IS_R204A.csv' -ForegroundColor Gray; Write-Host '   ABTG_Dow_Apertura_US_U30USD_OOS_R204A.csv' -ForegroundColor Gray; Write-Host '   R204a_oltre_uno_DOW_U30USD.txt' -ForegroundColor Gray; Write-Host 'NEL REFERTO LEGGI LA RIGA  data:  -- DEVE ESSERE DI OGGI, altrimenti stai guardando un file vecchio.' -ForegroundColor Yellow; if(Test-Path $d){ Get-ChildItem $d -Recurse -File | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize } }
```

📅 Dentro `REFERTO_ROUND_R204A.txt`, la riga **`data            :`** dev'essere del giorno
in cui lo lanci.

---

## ②③ BARRE E TEMPO

**Barre**: stesso EA, stesso simbolo, stesso M5, **stessa finestra** di `R202A`, girato il
21/09 alle 23:24 — referto: `tetto barre : MaxBars=100000000`. Il pre-volo della classe 160
muore solo fra 1.000 e 200.000. **Passa.**

**Tempo**: tetto **120 minuti**, ed è un **tetto**. `R202A` e `R202B` (stessa forma, 4 celle ×
2 gambe) sono partiti alle **23:24:38** e **23:27:19**: **2'41"** fra i due avvii — *una durata
solo se le due corse sono state sequenziali*. Margine ~45×. ⚠️ Se il tetto scatta **non è un
successo**: il referto che resta è **PARZIALE**.

---

## ④ 🚦 IL CANCELLO

**Strato 1**: `controlla_prova.py` → **verde** (80 pin, 4 celle, 0 problemi) ·
`controlla_riga.py --oggetto md` → **verde** · parser PowerShell **0 errori** · **una sola riga
fisica** (classe 538) · **zero** non-ASCII · URL del pin → **200**.

**Contro-esempi tenuti**
- La riga è confrontata **parola per parola** con quella di `R203A`, **già approvata dal
  cancello**: differiscono **solo** `pin`, etichetta, EA, simbolo, nome del file prova e nomi dei
  file attesi.
- Il file prova è verificato **per differenza** contro `R202a`: cambia **UNA riga sola** (l'asse);
  direttive `@` **identiche**, **80 pin** prima e dopo.

🟢 **E le lezioni dei sette giri di `R203` sono già dentro dalla prima stesura**: DD a
denominatore fisso (550), tolleranza su `(a)`, il tranello della cella a zero trade, il muro del
10% non giudicato (515), la taglia del banco dichiarata (547) col raddoppio come **limite
superiore**.

**🕳️ Non coperto**
- Il rapporto **uscite/posizioni** non è misurato: ogni `n` è **`[uscite]`**.
- Che il `.ex5` sul PC di backtest corrisponda ai `.mq5`: il driver **ricompila dal pin** e il
  referto lo stampa; resta non verificato solo che MetaEditor non riusi un `.ex5` stantio.
- **Quanto spesso il bersaglio a 5,25 R venga davvero raggiunto**: è `[NON MISURATO]`, e si
  leggerà dal calo di `n`.
