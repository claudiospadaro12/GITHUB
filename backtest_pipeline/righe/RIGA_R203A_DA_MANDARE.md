# 🚀 R203A — IL PAVIMENTO DELLO STOP SUL DAX, sedia `770101`

**21/09/2026** · branch `lavoro` · pin della riga: **`89f222bf41e29467998aa3debb2641e52083f7be`**
File prova: `backtest_pipeline/prove/R203a_pavimento_stop_DAX_D30EUR.txt` (90 pin, **4 celle**)

---

## 🟢 COSA MISURA, IN UNA RIGA

> **Asse unico `InpMinStopPts`: `0` → `2300` → `4600` → `6900` punti EA, con
> `InpSkipIfTight=true` (come in campo), cioè il pavimento NON allarga lo stop: **scarta il
> trade**.**
>
> 🔴 **Il fatto che apre la porta, ed è misurato**: sul DAX il **pavimento dello stop è
> SPENTO**. `InpMinStopPts=0.0` nel preset in campo, contro **500** su Nasdaq `770260` e Dow
> `770202`. E siccome il codice lo legge dentro `if(InpMinStopPts > 0 ...)` (r.1202, 1226,
> 1435, 1543, 1935, 1978), anche `InpSkipIfTight=true` — che nel preset **c'è** — oggi è un
> **NO-OP**: non ha mai scartato niente. **Questa sedia prende qualunque stop, per quanto
> stretto sia.**
>
> ⚠️ **Quindi il round ACCENDE un meccanismo che su questa sedia non ha mai operato.** Non è
> un ritocco: è una porta che si apre.

### 📏 LA SCALA NON È INDOVINATA — viene da **n=440**, non da n=3

`risultati_archivio/studio_apertura/Studio_D30EUR.csv` ha **440 breakout veri** con l'ampiezza
del range d'apertura:

| P5 | P10 | P25 | **P50** | P75 | P90 | P95 | media |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 2028 | 2389 | 3440 | **5465** | 7835 | 10884 | 13255 | 6254 |

🟢 **E c'è una conferma incrociata che vale la pena dire**: la mediana è **5465 pt = 54,65
punti indice**, mentre `report/STOP_VS_SPREAD_FTMO_2026-09-20.md` **r.275** dichiarava lo stop
della geometria viva a **54,90** `[MIS n=3]`. Due misure **indipendenti**, una con n=3 e una
con **n=440**, a **0,5%** di distanza. Il numero regge.

### 💸 IL COSTO DI OGNI GRADINO, DICHIARATO **PRIMA**

| cella | punti indice | × spread (1,70) | scarta | n che resta |
|---|---:|---:|---:|---:|
| **`0`** ← viva | — | spento | **0%** | 440 |
| `2300` | 23,0 | **13,5×** — il **pavimento duro** di casa | ~8,2% (36/440) | ~404 |
| `4600` | 46,0 | 27,1× | ~38,4% (169/440) | ~271 |
| `6900` | 69,0 | 🟠 **40,6× — LA FRONTIERA** | 🔴 **~67,0%** (295/440) | ~145 |

⚠️ **E sono un LIMITE SUPERIORE, non una previsione.** Quelle quote sono calcolate
sull'**ampiezza del range**, mentre lo stop vero è ampiezza **+ buffer** (`InpBufferPoints=500`)
e l'ingresso è **a retest** (`InpRetestOffsetPts=200`). Lo stop vero è quindi **più largo**
dell'ampiezza di qualche centinaio di punti, e il pavimento scarterà **qualche giorno in meno**
di quanto scritto. Il **verso** non cambia; il numero si legge dal referto.

### 🎯 L'ATTESA, DICHIARATA **PRIMA** DEI NUMERI

| # | cosa mi aspetto | e se non succede |
|---|---|---|
| **a** | la cella `0` **riproduce R202B Pass 3** (IS n175 PF 1,12733 DD 5,4089 · OOS n270 PF 1,39520 DD 7,2506) | se non riproduce, **il round non è confrontabile**: si cerca il pin che balla |
| **b** | `n` **SCENDE** salendo il pavimento | 🔴 è la verifica che il meccanismo si sia **acceso davvero**. Se `n` **non** scende, il pavimento non sta scartando niente e **il round non ha misurato nulla** |
| **c** | 🎯 **LA BARRA**: `DD OOS ≤ 5,00%` a taglia banco 1,0% — cioè **≤ 10,00% alla taglia vera** del campo (2,00%). Oggi è **7,2506 → 14,50%**: serve un taglio di **almeno il 31%** | sotto quella soglia nessuna cella è interessante, per quanto bella sia |
| **d** | **e il PF non deve crollare**: `PF OOS ≥ 1,20` (oggi 1,39520) | una cella che porta il DD sotto il muro ma il PF sotto 1,20 **non è una sedia, è un conto fermo** |
| **e** | IS e OOS **concordi** sulla direzione | discordi → **nessuna promozione**, si dichiara «non deciso» |
| **f** | **centro dell'altopiano, MAI il picco** | con 4 celle un altopiano può non esserci: allora il verdetto è **«serve più risoluzione»** |

### 🧪 LA CONTRO-IPOTESI, tenuta e non nascosta

> **Il pavimento potrebbe togliere trade SENZA toccare il DD.** Se le perdite che fanno il
> drawdown **non** sono concentrate nei giorni a range stretto, scartare quei giorni taglia `n`
> e profitto e lascia il DD dov'è.
> 🟢 **In quel caso la risposta è NO, e non è un fallimento del round: è la sua risposta** —
> e manda la caccia sull'asse successivo (`InpSLMode=1`, stop ad ATR; oppure `InpMaxSpread`,
> che oggi è **0**, cioè filtro spread **spento**).

🚫 **Cosa questo round NON misura** (un asse per round): `InpSkipIfTight=false` — allargare
lo stop invece di scartare il trade — è un **meccanismo diverso** e merita un round suo. Idem
`InpSLMode=1`.

🔴 **E la scala dei DD, classe 547**: il round gira a `InpRiskPercent=1,0`, la sedia in
campo gira a **2,00**. **Ogni DD di questo referto va raddoppiato** prima del muro del 10% —
che è un muro **DI CONTO**, e su quel conto operano **sei** sedie. La barra **(c)** è già
scritta nella scala del banco: `≤ 5,00` **è** il `10,00` del campo.

---

## ① 🖥️ DOVE MANDARE QUESTA STRINGA

> ## 🖥️ **finestra PowerShell sul PC DI BACKTEST `DESKTOP-H4D7CAJ`** (utente `Master`).
> **Bersaglio: l'unico MT5 di quella macchina, `C:\Program Files\BCM Markets MT5 Terminal`, demo `50503392`.**
>
> 🔴 **COSA NON VIENE TOCCATO.** Tutto ciò che vive **sul VPS**: la challenge **FTMO `541452707`**
> (`C:\FTMO`, **sei sedie che stanno operando**), il **100k `50504263`**, il **REALE `10105439`**
> (`C:\BCM_Reale`), il piccolo `50503392` del VPS, Pepperstone, Tickmill, e il banco `50504400`
> (`C:\MT5_Backtest`, **spento**). Non è una promessa: è **un'altra macchina**, e il `throw` è il
> **primo statement dopo `$pin`** — muore **prima** di scaricare qualunque cosa.
>
> ✋ **PRIMA DI INCOLLARE: chiudi MT5 sul PC di backtest.** Se lo trova aperto stampa PID +
> titolo + cartella e **si ferma**: quel terminale è loggato sul demo vivo `50503392` e il
> **14/08/2026** da quella macchina sono partiti **ordini veri**.

```powershell
& { $ErrorActionPreference='Stop'; $pin='89f222bf41e29467998aa3debb2641e52083f7be'; if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('VIETATO: questa riga gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama ' + $env:COMPUTERNAME + '. Sul VPS operano le sei sedie della challenge FTMO e un backtest a tick reali lo inchioda: firma di Claudio del 21/09.') }; $w="$env:USERPROFILE\abtg_round"; $p="$w\RIGA_ROUND_VPS.ps1"; $dsk=[Environment]::GetFolderPath('Desktop'); $tmo=120; New-Item -ItemType Directory -Force -Path $w | Out-Null; Remove-Item $p -Force -ErrorAction SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ROUND_VPS.ps1?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $p -ErrorAction Stop; if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ROUND_VPS_v2' -Quiet)){ throw 'SCRIPT VECCHIO: manca MARCATORE_RIGA_ROUND_VPS_v2' }; Write-Host 'BERSAGLIO: il solo MT5 di questo PC, C:\Program Files\BCM Markets MT5 Terminal, demo 50503392. Tutto il resto (challenge FTMO 541452707, 100k 50504263, REALE 10105439, Pepperstone, Tickmill, banco 50504400) sta su una macchina diversa e questa riga non la raggiunge.' -ForegroundColor Cyan; $mt=@(Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id,MainWindowTitle,Path); Write-Host '--- MT5 APERTI SU QUESTA MACCHINA (PID / titolo / cartella) ---'; $mt | Format-Table -AutoSize; if(@($mt | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') }).Count -gt 0){ throw 'MT5 E APERTO: chiudilo A MANO (il PID sta nella tabella qui sopra), dopo aver guardato che non abbia EA attaccati, poi reincolla la riga. Non lo chiudo io: quel terminale e loggato sul demo 50503392 e da questa macchina il 14/08 sono partiti ordini veri.' }; Write-Host '=== ROUND R203A   EA ABTG_DAX_Apertura_EU   D30EUR M5   tick reali   deposito 80000   4 celle x 2 gambe ===' -ForegroundColor Cyan; $a=@('-NoProfile','-ExecutionPolicy','Bypass','-File',('"'+$p+'"'),'-Expert','ABTG_DAX_Apertura_EU','-Prova','R203a_pavimento_stop_DAX_D30EUR.txt','-Etichetta','R203A','-Pin',$pin,'-TerminaleBacktest','"C:\Program Files\BCM Markets MT5 Terminal"','-Modello','4','-Deposito','80000'); $pr=Start-Process powershell -ArgumentList $a -NoNewWindow -PassThru; if(-not $pr.WaitForExit($tmo*60*1000)){ Write-Host ('TETTO DI ' + $tmo + ' MINUTI SFONDATO: fermo il round. E UN RISULTATO, NON UN GUASTO: il referto che resta e PARZIALE.') -ForegroundColor Red; Stop-Process -Id $pr.Id -Force -ErrorAction SilentlyContinue; Get-Process metatester64,terminal64 -ErrorAction SilentlyContinue | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') } | Stop-Process -Force -ErrorAction SilentlyContinue; try{ $pr.WaitForExit() }catch{}; Start-Sleep -Seconds 10 }; $rc=$pr.ExitCode; if($null -eq $rc){ $rc='NON LEGGIBILE' }; Write-Host ('   esito R203A: codice ' + $rc + '   (0=GIRATO  2=NON MISURATO  3=GIRATO CON RILIEVI  1=non e partito)') -ForegroundColor Yellow; $d="$dsk\ROUND_R203A"; if(-not (Test-Path $d)){ Write-Host 'MANCA la cartella ROUND_R203A sul Desktop: il round NON ha prodotto raccolta.' -ForegroundColor Red } else { Compress-Archive -Path "$d\*" -DestinationPath "$dsk\ROUND_R203A.zip" -Force; Write-Host 'ZIP PRONTO DA MANDARE: Desktop\ROUND_R203A.zip' -ForegroundColor Green }; Write-Host 'FILE ATTESI NELLO ZIP (4):' -ForegroundColor Gray; Write-Host '   REFERTO_ROUND_R203A.txt' -ForegroundColor Gray; Write-Host '   ABTG_DAX_Apertura_EU_D30EUR_IS_R203A.csv' -ForegroundColor Gray; Write-Host '   ABTG_DAX_Apertura_EU_D30EUR_OOS_R203A.csv' -ForegroundColor Gray; Write-Host '   R203a_pavimento_stop_DAX_D30EUR.txt' -ForegroundColor Gray; Write-Host 'NEL REFERTO LEGGI LA RIGA  data:  -- DEVE ESSERE DI OGGI, altrimenti stai guardando un file vecchio.' -ForegroundColor Yellow; if(Test-Path $d){ Get-ChildItem $d -Recurse -File | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize } }
```

📅 **Quale data deve leggere Claudio**: dentro `REFERTO_ROUND_R203A.txt`, la riga che
comincia con **`data            :`**.

---

## ② 📐 IL TETTO DELLE BARRE — **misurato**

Stesso EA, stesso simbolo, stesso M5, **stessa identica finestra** di `R202B`, girato **il
21/09 alle 23:27** sulla stessa macchina: il referto riporta `tetto barre : MaxBars=100000000`.
Il pre-volo della classe 160 muore solo fra 1.000 e 200.000. Passa.

## ③ ⏱️ IL TETTO DI TEMPO — **120 minuti, ed è un TETTO**

🟢 **E ora una base MISURATA c'è**, che al giro precedente mancava: `R202A` e `R202B` sono
girati **il 21/09 alle 23:24:38 e 23:27:19**, **4 celle x 2 gambe ciascuno**, **2 minuti e 41
secondi** di distanza fra gli avvii. Questo round è **identico per forma** (4 x 2, stesso EA,
stessa finestra) e le celle alte hanno **meno trade**, non di più. Il tetto a 120 minuti resta
**largo ~45 volte**: serve solo a impedire che un tester appeso resti lì per sempre.
⚠️ **Se scatta NON è un successo**: il referto che resta è **PARZIALE**.

---

## ④ 🚦 IL CANCELLO

**Strato 1 (deterministico)**
- `controlla_prova.py` → **verde** (90 pin, 4 celle, 0 problemi).
- `controlla_riga.py --oggetto md` → **verde**.
- **Parser PowerShell**: **0 errori**. **Una sola riga fisica** (classe 538), **zero non-ASCII**.

**Contro-esempi tenuti**
- Riga confrontata **parola per parola** con quella già approvata e **già girata** di `R202B`:
  le **uniche** differenze sono `pin`, etichetta, nome del file prova e nomi dei file attesi.
  **EA e simbolo sono gli stessi** — è la stessa sedia.
- File prova verificato **per differenza** contro `R202b`: cambiano **DUE righe e basta**
  (`InpMinStopPts` da pin ad asse, `InpTP1_R` da asse a pin `1.0`); direttive `@` **identiche**,
  **90 pin** prima e dopo, **zero** non-ASCII.
- URL del pin (driver + file prova) → **200**, verificati dopo il commit.

**🕳️ Non coperto, e va detto**
- Le quote di scarto vengono dall'**ampiezza del range**, non dallo stop vero (ampiezza +
  buffer). Sono un **limite superiore**: il numero vero si legge dal referto.
- Lo `Studio_D30EUR.csv` è stato prodotto con **buffer 200 e TP 2,0R**, mentre la sedia viva
  ha **buffer 500** e TP `InpTP1_R x 3`. Serve per la **distribuzione delle ampiezze**, che non
  dipende da quei due, **non** per i suoi P/L.
- Che il `.ex5` sul PC di backtest corrisponda ai `.mq5` letti qui: il driver ricompila dal pin,
  ma **non l'ho misurato**.
