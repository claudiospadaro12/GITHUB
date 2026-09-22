# 🎯 R208B — IL BERSAGLIO DELLA SEDIA `770101`, MAI MOSSO DI UN MILLIMETRO

**22/09/2026** · branch `lavoro` · pin della riga: **`52af6583c948e7de4d20db8ae3c380976be1ce96`**
File prova: `backtest_pipeline/prove/R208b_bersaglio_770101_D30EUR.txt` (**81 pin, 5 celle**)

> ✅ **PASSATA DAL CANCELLO DI GIUDIZIO (strato 2) il 22/09/2026.** Verdetto:
> **FAIL sulla bozza → PASS su questa versione**, con **tre difetti corretti dentro il
> documento** (classe **585** nuova sul ramo del tetto · classe **166/584** sul sorgente
> che NON scende dal pin · classe **584 gesto 3** sulla disambiguazione da stampare).
> Dettaglio in coda, sezione ⑨. **Questa è la versione da mandare.**

---

## ① 🖥️ DOVE MANDARE QUESTA STRINGA

> ## 🖥️ **finestra PowerShell sul PC DI BACKTEST `DESKTOP-H4D7CAJ`** (utente `Master`).
> **Bersaglio: l'unico MT5 di quella macchina, `C:\Program Files\BCM Markets MT5 Terminal`, demo `50503392`.**
>
> 🔴 **COSA NON VIENE TOCCATO, per nome e non per esclusione.** Tutto ciò che vive
> **sul VPS**, cioè **tutte e sei** le cartelle dati di quella macchina: la challenge
> **FTMO `541452707`** (`C:\FTMO`, **sei sedie che stanno operando adesso**), il **100k
> `50504263`** (`... MT5 Terminal -V3`), il **REALE `10105439`** (`C:\BCM_Reale`), il
> **piccolo `50503392` del VPS** (`BCM Markets MT5 Terminal`), **Pepperstone**, **Tickmill**,
> e il banco **`50504400`** (`C:\MT5_Backtest`, **che resta SPENTO**).
> Non è una promessa: è **un'altra macchina**, e la riga **si rifiuta di partire** se
> `$env:COMPUTERNAME` non è `DESKTOP-H4D7CAJ` — il `throw` è il **primo statement dopo
> `$pin`**, quindi muore **prima** di scaricare qualunque cosa.
>
> ✋ **PRIMA DI INCOLLARE: chiudi MT5 sul PC di backtest.** La riga **non lo chiude da
> sola**, apposta: quel terminale **è loggato su un conto demo vivo** (`50503392`) e il
> **14/08/2026** da quella macchina sono partiti **ordini veri** (#3160534/#3160535).
> Se lo trova aperto stampa PID + titolo + cartella e **si ferma**.

---

## 🟢 COSA MISURA, IN TRE RIGHE

1. **Asse unico `InpTP1_R`: 0,50 · 0,75 · 1,00 · 1,25 · 1,50** (5 celle, passo 0,25,
   **centrato** sul valore vivo 1,0). Col **parziale SPENTO** (`InpTP1_ClosePct = 0`) il
   blocco di `r.2359` non gira mai, `r.2368` è morto e `InpTP1_R` **resta una cosa sola**:
   la distanza del **bersaglio finale**, che vale `3 × InpTP1_R` → **TP da 1,5R a 4,5R**.
2. **È una casella LIBERA del certificato, non una casella provata**: su **1.052 righe** di
   CSV che portano la firma di colonne di questa sedia, `InpTP1_R` prende **UN solo valore**
   (1,0). Mai stato un asse qui.
3. **`n` è bloccato per costruzione** (`InpOneTradePerDay=true`, flat 17:30, il TP non entra
   in nessuna condizione d'ingresso) → **193 OOS / 132 IS in tutte e cinque le celle**, e
   con il parziale spento **1 deal = 1 posizione**. Quindi un eventuale altopiano **non può
   essere** artefatto di campione né di sopravvivenza: resta un solo modo di sbagliarsi, **la
   coda**, e il file prova lo mette come test obbligatorio (B4).

---

## ② 🚀 LA RIGA

```powershell
& { $ErrorActionPreference='Stop'; $pin='52af6583c948e7de4d20db8ae3c380976be1ce96'; if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('VIETATO: questa riga gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama ' + $env:COMPUTERNAME + '. Sul VPS operano le sei sedie della challenge FTMO e un backtest a tick reali lo inchioda: firma di Claudio del 21/09.') }; $w="$env:USERPROFILE\abtg_round"; $p="$w\RIGA_ROUND_VPS.ps1"; $dsk=[Environment]::GetFolderPath('Desktop'); $tmo=58; New-Item -ItemType Directory -Force -Path $w | Out-Null; Remove-Item $p -Force -ErrorAction SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ROUND_VPS.ps1?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $p -ErrorAction Stop; if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ROUND_VPS_v2' -Quiet)){ throw 'SCRIPT VECCHIO: manca MARCATORE_RIGA_ROUND_VPS_v2' }; Write-Host 'BERSAGLIO: il solo MT5 di questo PC, C:\Program Files\BCM Markets MT5 Terminal, demo 50503392. Tutto il resto (challenge FTMO 541452707, 100k 50504263, REALE 10105439, Pepperstone, Tickmill, banco 50504400) sta su una macchina diversa e questa riga non la raggiunge.' -ForegroundColor Cyan; $mt=@(Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id,MainWindowTitle,Path); Write-Host '--- MT5 APERTI SU QUESTA MACCHINA (PID / titolo / cartella) ---'; $mt | Format-Table -AutoSize; if(@($mt | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') }).Count -gt 0){ throw 'MT5 E APERTO: chiudilo A MANO (il PID sta nella tabella qui sopra), dopo aver guardato che non abbia EA attaccati, poi reincolla la riga. Non lo chiudo io: quel terminale e loggato sul demo 50503392 e da questa macchina il 14/08 sono partiti ordini veri.' }; Write-Host '=== ROUND R208B   EA ABTG_DAX_Apertura_EU   D30EUR M5   tick reali   deposito 100000   5 celle x 2 gambe ===' -ForegroundColor Cyan; $a=@('-NoProfile','-ExecutionPolicy','Bypass','-File',('"'+$p+'"'),'-Expert','ABTG_DAX_Apertura_EU','-Prova','R208b_bersaglio_770101_D30EUR.txt','-Etichetta','R208B','-Pin',$pin,'-TerminaleBacktest','"C:\Program Files\BCM Markets MT5 Terminal"','-Modello','4','-Deposito','100000'); $pr=Start-Process powershell -ArgumentList $a -NoNewWindow -PassThru; if(-not $pr.WaitForExit($tmo*60*1000)){ Write-Host ('TETTO DI ' + $tmo + ' MINUTI SFONDATO: fermo il round. E UN RISULTATO, NON UN GUASTO: il referto che resta e PARZIALE.') -ForegroundColor Red; Stop-Process -Id $pr.Id -Force -ErrorAction SilentlyContinue; Get-CimInstance Win32_Process -Filter "Name='powershell.exe'" -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -and ($_.CommandLine -like '*walkforward_generico.ps1*') } | ForEach-Object { Write-Host ('   fermo anche il NIPOTE che esegue il driver: PID ' + $_.ProcessId) -ForegroundColor Red; Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }; Start-Sleep -Seconds 5; Get-Process metatester64,terminal64 -ErrorAction SilentlyContinue | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') } | Stop-Process -Force -ErrorAction SilentlyContinue; try{ $pr.WaitForExit() }catch{}; Start-Sleep -Seconds 10; Get-Process metatester64,terminal64 -ErrorAction SilentlyContinue | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') } | Stop-Process -Force -ErrorAction SilentlyContinue }; $rc=$pr.ExitCode; if($null -eq $rc){ $rc='NON LEGGIBILE' }; Write-Host ('   esito R208B: codice ' + $rc + '   (0=GIRATO  2=NON MISURATO  3=GIRATO CON RILIEVI  1=non e partito)') -ForegroundColor Yellow; $d="$dsk\ROUND_R208B"; if(-not (Test-Path $d)){ Write-Host 'MANCA la cartella ROUND_R208B sul Desktop: il round NON ha prodotto raccolta.' -ForegroundColor Red } else { Compress-Archive -Path "$d\*" -DestinationPath "$dsk\ROUND_R208B.zip" -Force; Write-Host 'ZIP PRONTO DA MANDARE: Desktop\ROUND_R208B.zip' -ForegroundColor Green }; Write-Host 'FILE ATTESI NELLO ZIP (4):' -ForegroundColor Gray; Write-Host '   REFERTO_ROUND_R208B.txt' -ForegroundColor Gray; Write-Host '   ABTG_DAX_Apertura_EU_D30EUR_IS_R208B.csv' -ForegroundColor Gray; Write-Host '   ABTG_DAX_Apertura_EU_D30EUR_OOS_R208B.csv' -ForegroundColor Gray; Write-Host '   R208b_bersaglio_770101_D30EUR.txt' -ForegroundColor Gray; Write-Host 'NEL REFERTO LEGGI LA RIGA  data:  -- DEVE ESSERE DI OGGI, altrimenti stai guardando un file vecchio.' -ForegroundColor Yellow; Write-Host 'ANCORA DI REGRESSIONE S1 (numeri letti dai CSV di r137c in risultati_prove/dal_vps/, NON da un referto) -- cella InpTP1_R=1.0:  IS  n=132  PF=1.18323  RF=1.02362  EqDD%=4.9576  Profit=5569.37   |   OOS  n=193  PF=1.49140  RF=2.96058  EqDD%=6.2719  Profit=23607.28.  SENTINELLA S1b: la colonna Trades deve leggere 132 in IS e 193 in OOS in TUTTE E CINQUE le celle. Se una cella ha un n diverso il round si ferma e non si legge nessun PF.' -ForegroundColor Magenta; Write-Host 'COME SI DISTINGUE UN ASSE PIATTO DA UNA MANOPOLA SPENTA -- criterio congelato PRIMA dei numeri e contabile a macchina: (1) S2, nella colonna InpTP1_R del CSV devono esserci CINQUE valori DISTINTI. Se sono cinque, la manopola E ARRIVATA all EA. (2) Poi si contano i Profit DISTINTI: due celle con lo stesso Profit NON sono due celle (classe 543 / A3). Cinque valori distinti di InpTP1_R + pochi Profit distinti = MANOPOLA MISURATA E INERTE, che E un risultato. Meno di cinque valori distinti di InpTP1_R = la manopola NON e arrivata e non si legge nessun PF.' -ForegroundColor Magenta; if(Test-Path $d){ Get-ChildItem $d -Recurse -File | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize } }
```

📅 **Quale data deve leggere chi riceve lo zip**: dentro `REFERTO_ROUND_R208B.txt`, la
riga che comincia con **`data            :`**. Il 17/08 un referto stantio è stato rimandato
**due volte** in buona fede: si guarda quella riga **prima** dei numeri.

---

## ③ 📦 I FILE ATTESI NELLO ZIP (`Desktop\ROUND_R208B.zip`) — **4**

| file | che cos'è |
|---|---|
| `REFERTO_ROUND_R208B.txt` | il referto del driver: data, macchina, tetto barre, deposito, e **per ogni CSV** Profit / PF / Equity DD % / Trades riga per riga |
| `ABTG_DAX_Apertura_EU_D30EUR_IS_R208B.csv` | gamba **IS** (2024.09.26 → 2025.06.09), **5 righe** attese |
| `ABTG_DAX_Apertura_EU_D30EUR_OOS_R208B.csv` | gamba **OOS** (2025.06.10 → 2026.06.30), **5 righe** attese |
| `R208b_bersaglio_770101_D30EUR.txt` | il file prova **come scaricato dal pin**, così il round è rifacibile senza fidarsi di nessuno |

⚠️ **Se le righe fossero 4 e non 5**, non è un guasto della riga: è la **sentinella S2** del
file prova (`0,5 + 4×0,25` in virgola mobile può fermarsi a quattro). Il referto conta i valori
**distinti** di `InpTP1_R` e si dichiara **quale manca**.

---

## ④ ⏱️ IL TETTO DI TEMPO — **58 minuti**, e da dove viene il numero

🔴 **Il tetto non è pazienza: è l'AMPIEZZA DELLA FINESTRA DI RISCHIO** (classe **582**). La
riga fa `throw` se un `terminal64` sotto `C:\Program Files\BCM Markets MT5 Terminal` è vivo
**a t=0**, ed è quella verifica che rende legittimo lo `Stop-Process` a **t=TETTO**. In mezzo,
su `DESKTOP-H4D7CAJ`, quel percorso è il terminale del **demo `50503392`** — quello da cui il
14/08 sono partiti ordini veri — e **un umano può riaprirlo**. Più largo è il tetto, più larga
è la finestra in cui la riga ucciderebbe un terminale che nel frattempo è tornato vivo.

**Il conto, passo per passo:**

| passo | numero | fonte |
|---|---:|---|
| passate di questo round | **10** | 5 celle × 2 gambe (`controlla_prova.py`) |
| base di costo **conservativa** | **~23 s/passata** | `risultati_archivio/R112_CORSA_20260826/REFERTO_R112.txt` r.7-8: avvio `23:05:03`, data `23:09:43`, `durata: 0.1 ore`, **16 passate** |
| costo atteso | **3,83 min** | `10 × 23 s = 230 s` |
| moltiplicatore | **×15** | scelto **alto** perché la base è **trasferita** (vedi il rilievo qui sotto) |
| **TETTO** | **57,5 → 58 minuti** | arrotondato **per eccesso al minuto**, non a un numero tondo |

🔴 **E il rilievo che devo dichiarare io, perché me ne sono accorto verificando invece di
copiare, e che ho catalogato come **classe nuova 583** in `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`:** quel *«costo misurato di questa famiglia»* **non è di
questa famiglia**. `R112` è **`ABTG_EMA200` su `U30USD` H1** — **altro EA, altro simbolo, altro
timeframe**. Qui giriamo `ABTG_DAX_Apertura_EU` su `D30EUR` **M5**.

🟢 **La base BEN APPAIATA c'è ed è più bassa**, quindi il tetto resta conservativo:
`R172D` e `R201A` sono girati il **21/09 sulla stessa macchina**, con lo **stesso driver**, la
**stessa finestra**, **M5 tick reali**, e i CSV dicono **7 righe per gamba = 14 passate
ciascuno** (contate, non ricordate). I referti portano avvio **`21:01:33`** e **`21:05:24`**:
**3 min 51 s** di distanza → **≤ 16,5 s/passata**. ⚠️ **Che fossero in fila non si può
provare**, quindi non lo uso come base — lo uso come **controprova che i 23 s sono un
inviluppo**, non una sottostima.

⚠️ **Se il tetto scatta NON è un successo** (checklist p.19): la riga lo dice in rosso e il
referto che resta è **PARZIALE**.
🔴 **IL RAMO DEL TETTO È STATO CORRETTO DAL CANCELLO — CLASSE NUOVA 585.** Com'era scritto,
`Stop-Process -Id $pr.Id` uccideva **il figlio** (`RIGA_ROUND_VPS.ps1`) ma **non il NIPOTE**:
il wrapper lancia il driver con `Start-Process powershell ... -Wait` (r.1090), Windows **non
crea nessun job object**, e quel `powershell.exe` che esegue `walkforward_generico.ps1`
**sopravvive**. E il driver **non muore** se il CSV manca (r.2069: stampa un avviso e
**passa alla gamba dopo**), quindi **rilanciava `terminal64` DOPO la spazzata**: il round
proseguiva invisibile, e la frase *«fermo il round»* stampata a Claudio era **falsa**.
👉 Ora la riga, nell'ordine: ① uccide `$pr`; ② uccide i `powershell.exe` il cui
`CommandLine` contiene la **costante** `walkforward_generico.ps1`, **stampandone il PID**;
③ aspetta 5 s; ④ spazza `metatester64`/`terminal64` sotto il percorso bersaglio; ⑤ dopo i
10 s **rispazza**, così un terminale che fosse partito nell'ultimo istante non resta acceso.
⚠️ **Il secondo filtro NON è sul percorso del terminale ma sul nome del nostro driver**: se
Claudio avesse un ALTRO round in corso su questa macchina, verrebbe fermato anche quello.
Sul PC di backtest non ce ne sono altri, e lo dichiaro invece di nasconderlo.

🔴 **La chiusura d'emergenza è chirurgica e su una COSTANTE**: `Stop-Process` colpisce solo
`metatester64`/`terminal64` il cui `Path` sta sotto `C:\Program Files\BCM Markets MT5 Terminal\`
— **stringa letterale dentro la riga, in tutte e due i punti (pre-volo e uccisione), nessuna
variabile che arrivi da fuori** — verificato con `grep` sulla riga generata.

---

## ⑤ 🪝 L'ANCORA DI REGRESSIONE — **c'è, ed è presa dal CSV**

La riga la **stampa in coda**, in magenta, così chi legge la console non deve aprire un referto
vecchio per sapere cosa deve tornare. 🔴 **I numeri vengono dai CSV grezzi, non dal referto**:

`risultati_prove/dal_vps/ABTG_DAX_Apertura_EU/ABTG_DAX_Apertura_EU_D30EUR_{IS,OOS}_r137c.csv`,
**riga Pass 0** (è la riga con `InpTP1_ClosePct = 0`, cioè la stessa configurazione di questo round):

| gamba | n | PF | RF | Equity DD % | Profit |
|---|---:|---:|---:|---:|---:|
| **IS** | **132** | **1,18323** | **1,02362** | **4,9576** | **5569,37** |
| **OOS** | **193** | **1,49140** | **2,96058** | **6,2719** | **23607,28** |

- **S1 — riproduzione**: se la cella `InpTP1_R = 1,0` non torna, il verdetto **non** è *«il
  bersaglio non serve»*: è *«il binario di oggi non è quello di r137c»*, e le altre celle
  **non si leggono**.
- **S1b — invariante del campione**: `Trades` deve leggere **132 (IS)** e **193 (OOS)** in
  **tutte e cinque** le celle. Se una cella ha un `n` diverso, il bersaglio sta rientrando negli
  ingressi per una via non capita e **il round si ferma prima di qualunque PF**.

🟢 **Il deposito è coerente con l'ancora, e l'ho verificato per aritmetica invece di
fidarmi**: `r137c` gira a **100.000** e `R202B` a **80.000** sulle stesse celle; i rapporti dei
profitti valgono `3789,36 / 3050,56 = 1,2422` e `18029,58 / 14355,32 = 1,2560`, cioè **≈ 100/80 =
1,25**, con `n` **identico** (175 e 270). 👉 Per questo la riga passa **`-Deposito 100000`** e
non 80.000: con 80.000 l'ancora **non tornerebbe** e S1 decadrebbe.

---

## ⑥ 📐 IL TETTO DELLE ~100.000 BARRE — misurato, non stimato

Stesso EA, stesso simbolo, stesso **M5**, **stessa identica finestra** (`@DAQUANDO 2024.09.26`,
`@FINOA 2026.06.30`): `R201A` è girato **il 21/09 su questa macchina** e il referto riporta
`tetto barre : MaxBars=100000000`. Il pre-volo della classe 160 muore solo se `MaxBars` sta
**fra 1.000 e 200.000**: qui è cento milioni, quindi passa. E le due corse sono **separate**
(`walkforward_generico.ps1` r.931-938): il tetto vale **per corsa**, non per il round.

---

## ⑦ 🕳️ QUELLO CHE HO CONTROLLATO E CHE VA SAPUTO **PRIMA** DI LEGGERE I NUMERI

- 🟢 **`@FRAZIONEIS` NON c'è nel file prova, e NON è un difetto.** Il file lo dichiara a
  parole (`FrazioneIS 0.40`) ma non come direttiva. Verificato nel driver:
  `walkforward_generico.ps1` r.189 ha `[double]$FrazioneIS = 0.40` come **default**, e la
  guardia interroga `$PSBoundParameters.ContainsKey("FrazioneIS")`. **`RIGA_ROUND_VPS.ps1`
  non passa `-FrazioneIS`** (r.1076-1080, argomenti elencati uno per uno): quindi il valore
  usato è **0,40**, che è esattamente quello che il file prova vuole. ⚠️ **Ma resta una
  fragilità da dichiarare**: sta in un **default**, non in una direttiva. Se un domani il
  default cambiasse, questo round cambierebbe finestra **in silenzio**.
- 🟠 **L'asse può essere PIATTO, ed è previsto — e c'è già un numero in casa che lo dice.**
  Sulla **stessa** configurazione a parziale spento, `..._{IS,OOS}_q770be.csv` mostra che
  `InpBEatR = 1,5` dà **esattamente** lo stesso esito di `0,0` in tutte e due le gambe
  (23607,28 / PF 1,49140 / DD 6,2719 / n 193 in OOS): cioè **quasi nessun trade arriva a
  +1,5R** prima che lo chiuda il trailing PREVBAR M5. 👉 **Allora le celle con TP a 3,75R e
  4,5R rischiano di uscire IDENTICHE fra loro**, e due celle identiche **non sono due celle**:
  è la **classe 543** e l'`A3` del file prova. **Si contano i `Profit` DISTINTI prima di
  leggere un altopiano.**
- 🔴 **IL SORGENTE DELL'EA NON SCENDE DAL PIN — CORRETTO DAL CANCELLO (classe 166/584).**
  Qui c'era scritto *«il driver ricompila dal pin»*: **è falso**, ed era il rassicurante
  sbagliato. `backtest_pipeline/walkforward_generico.ps1` **r.264** ha `$EABranch="lavoro"`
  **cablato** e `RIGA_ROUND_VPS.ps1` **non gli passa nessun pin**: il pin `52af6583` copre
  **la riga, il driver e il file prova**, mentre `.mq5` e include scendono dal **RAMO
  `lavoro`, al momento in cui la riga viene incollata**.
  🟢 **Oggi non fa danno, ed è misurato, non sperato**: `git diff 52af6583 HEAD --
  mql5/Experts/ABTG_DAX_Apertura_EU.mq5` è **vuoto** (il commit `7f449dcc` tocca solo tre
  `.md`). 🔴 **Ma se qualcuno pusha su `lavoro` prima che la riga parta, il motore cambia
  in silenzio.** Il discriminante è già in casa e non costa niente: **se l'ancora S1
  riproduce `r137c`, il binario è sano**; se non riproduce, la causa può essere **il motore
  ballato** tanto quanto una lettura sbagliata del codice.
- 🟠 Che il `.ex5` sul PC di backtest corrisponda al `.mq5` di `lavoro`: **non misurato**,
  e questa famiglia ha già avuto scarti sorgente/binario (`ABTG_EMA200`, 690 righe contro
  486 in campo).
- 🟠 **Prova di regime: assente e dichiarata assente dal file prova.** 21 mesi di storico BCM
  su `D30EUR` = **un solo regime**. La regola **C** dell'Emendamento della Finestra **non è
  soddisfatta e non lo sarà alla fine di questo round**. 👉 Quindi, qualunque cosa esca,
  **`A10` vale**: il round **non promuove niente**, non cambia un preset, non tocca il forward.

---

## ⑧ 🚦 IL CANCELLO — STRATO 1 (deterministico)

| controllo | esito |
|---|---|
| `python3 backtest_pipeline/controlla_prova.py` sul file prova | 🟢 **OK** — `pin=81 celle=5`, **10 passate**, **0 problemi** |
| `python3 backtest_pipeline/controlla_riga.py --riga … --prova …` | 🟢 **`ESITO: nessun difetto meccanico`**, **8 controlli passati**, 2 rilievi non bloccanti (457 e 225) |
| parser PowerShell (`pwsh`, `Parser::ParseInput`) | 🟢 **0 errori** |
| **una sola riga fisica** (classe **538**) | 🟢 sì — `\n` = 0 |
| **ASCII puro** | 🟢 sì — 0 caratteri ≥ 128 |
| apici singoli bilanciati / `{}` / `()` | 🟢 98 apici (pari), 14/14 graffe, 32/32 tonde |
| etichetta `R208B` già occupata in `risultati_prove/`? | 🟢 **no** — nessuna corrispondenza |
| il file prova dichiara al suo interno un `-Etichetta` diverso dalla sigla? (**classe 576**) | 🟢 **no** — `grep -i etichett` sul file: **zero occorrenze**. Si usa la sigla `R208B` |
| i file prova esistono **al pin** `52af6583` | 🟢 sì, e sono **identici** alla copia in working tree (`diff` vuoto) |
| `MARCATORE_RIGA_ROUND_VPS_v2` presente in `RIGA_ROUND_VPS.ps1` **al pin** | 🟢 sì |

**Rilievo 457, letto a mano come chiede il cancello**: il filtro dello `Stop-Process` è la
**costante** `'C:\Program Files\BCM Markets MT5 Terminal\*'` in **tutte e due** le occorrenze
(pre-volo e uccisione a tetto sfondato). **Nessuna variabile che arrivi da fuori.**

## ⑨ 🚦 IL CANCELLO — STRATO 2 (giudizio, agente `controllo-preventivo`) — **FATTO**

**22/09/2026.** Verdetto: **FAIL sulla bozza → PASS sulla versione corretta qui sopra.**
I difetti trovati e **già corretti dentro questo documento** (non "ops, ecco la correzione"):
1. **classe NUOVA 585** — il ramo del tetto uccideva il figlio ma non il nipote: la riga è
   stata riscritta (sezione ④) e ripassa lo strato 1 con **8 passati / 0 difetti meccanici**
   e **parser `pwsh` 0 errori**;
2. **classe 166/584** — *«il driver ricompila dal pin»* era **falso** (`walkforward_generico.ps1`
   r.264 `$EABranch="lavoro"` cablato): riscritto in sezione ⑦, con la misura che oggi pin e
   `HEAD` coincidono sul `.mq5`;
3. **classe 584 gesto 3** — la disambiguazione che decide come si legge il round non era
   **stampata dove verrà letta**: ora esce in console, in magenta, accanto all'ancora;
4. **classe NUOVA 586, e l'ho introdotta IO correggendo la 585**: la prima stesura della
   riga corretta aveva perso un `;` fra i due `Write-Host`. 🔴 **`Parser::ParseInput` diceva
   0 errori lo stesso** — non è un errore di sintassi, è di **binding**, e sarebbe esploso
   **a round già girato**. Trovato stampando la riga e rileggendola, riparato, e ora
   **ogni comando della riga passa `StaticParameterBinder::BindCommand`: 0 binding rotti su
   47 comandi**, con il contro-esempio che dimostra che quel controllo boccia davvero la
   versione rotta.

**Riverificato dal cancello, non ricopiato**: ancore lette nei **CSV grezzi**, deposito
**100.000** confermato per via **indipendente** (da `RF` e `Equity DD %`), etichetta libera,
pin = commit vero con i file identici al working tree, e il `.mq5` letto riga per riga.
