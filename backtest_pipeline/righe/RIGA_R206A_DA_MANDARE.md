# 🌙 R206A — IL MOLTIPLICATORE DELLO STOP DELLA SEDIA DELLA NOTTE (`770411`)

**22/09/2026** · branch `lavoro` · pin della riga: **`52af6583c948e7de4d20db8ae3c380976be1ce96`**
File prova: `backtest_pipeline/prove/R206a_moltiplicatore_stop_MAXMINDAX_D30EUR.txt` (**45 pin, 6 celle**)
EA: `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` · `D30EUR` **M15** · sedia `770411`

> 🔴 **BOZZA. NON È ANCORA PASSATA DAL CANCELLO DI GIUDIZIO (strato 2).**
> Lo strato 1 è verde (esiti in fondo). **Non mandare niente a Claudio** finché
> l'agente `controllo-preventivo` non ha risposto.

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
> 🔴 **E in particolare non viene toccata la sedia `770411` viva**, che è una delle sedie
> della challenge: questo round gira con un **magic vergine `787431`**, su **un'altra
> macchina**, dentro lo Strategy Tester. La riga **si rifiuta di partire** se
> `$env:COMPUTERNAME` non è `DESKTOP-H4D7CAJ` — il `throw` è il **primo statement dopo
> `$pin`**, quindi muore **prima** di scaricare qualunque cosa.
>
> ✋ **PRIMA DI INCOLLARE: chiudi MT5 sul PC di backtest.** La riga **non lo chiude da
> sola**, apposta: quel terminale **è loggato su un conto demo vivo** (`50503392`) e il
> **14/08/2026** da quella macchina sono partiti **ordini veri** (#3160534/#3160535).
> Se lo trova aperto stampa PID + titolo + cartella e **si ferma**.

---

## 🟢 COSA MISURA, IN TRE RIGHE

1. **Asse unico `InpAtrSLmult`: 1,5 · 2,0 · 2,5 · 3,0 · 3,5 · 4,0** (6 celle, passo 0,5,
   tutti esattamente rappresentabili in binario). È il **moltiplicatore ATR dello STOP**, e
   il pin `InpSLMode=1` (`MM_SL_ATR`, enum `r.45`) è quello che **tiene vivo l'asse**: con 0 o
   con 2 il sorgente non esegue il ramo `else` di `r.278`/`r.286` e le sei celle uscirebbero
   identiche.
2. **Chiude un buco dichiarato due volte in repo, non apre una domanda nuova**: lo stop di
   questa sedia è `[NON MISURATO]` in `ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` (r.412/427/461,
   **è l'unica della rosa FTMO così**, arancione *«FRAGILE»*) e `R194a` lo scrive nero su
   bianco come buco che **non chiude**.
3. **Il massimo noto sta SUL BORDO dell'asse vecchio**: nel refine (corr ON, buffer 1000) il
   PF cresce monotono `1,5 → 2,0 → 2,5` e il DD cala monotono, **e 2,5 era il valore più alto
   che quella griglia contenesse**. 👉 **Sopra 2,5 non esiste NESSUNA misura, su NESSUNA
   finestra**: un massimo sul bordo non è un ottimo, è il punto in cui si è smesso di guardare.

---

## ② 🚀 LA RIGA

```powershell
& { $ErrorActionPreference='Stop'; $pin='52af6583c948e7de4d20db8ae3c380976be1ce96'; if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('VIETATO: questa riga gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama ' + $env:COMPUTERNAME + '. Sul VPS operano le sei sedie della challenge FTMO e un backtest a tick reali lo inchioda: firma di Claudio del 21/09.') }; $w="$env:USERPROFILE\abtg_round"; $p="$w\RIGA_ROUND_VPS.ps1"; $dsk=[Environment]::GetFolderPath('Desktop'); $tmo=84; New-Item -ItemType Directory -Force -Path $w | Out-Null; Remove-Item $p -Force -ErrorAction SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ROUND_VPS.ps1?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $p -ErrorAction Stop; if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ROUND_VPS_v2' -Quiet)){ throw 'SCRIPT VECCHIO: manca MARCATORE_RIGA_ROUND_VPS_v2' }; Write-Host 'BERSAGLIO: il solo MT5 di questo PC, C:\Program Files\BCM Markets MT5 Terminal, demo 50503392. Tutto il resto (challenge FTMO 541452707, 100k 50504263, REALE 10105439, Pepperstone, Tickmill, banco 50504400) sta su una macchina diversa e questa riga non la raggiunge.' -ForegroundColor Cyan; $mt=@(Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id,MainWindowTitle,Path); Write-Host '--- MT5 APERTI SU QUESTA MACCHINA (PID / titolo / cartella) ---'; $mt | Format-Table -AutoSize; if(@($mt | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') }).Count -gt 0){ throw 'MT5 E APERTO: chiudilo A MANO (il PID sta nella tabella qui sopra), dopo aver guardato che non abbia EA attaccati, poi reincolla la riga. Non lo chiudo io: quel terminale e loggato sul demo 50503392 e da questa macchina il 14/08 sono partiti ordini veri.' }; Write-Host '=== ROUND r206a   EA ABTG_MaxMinNotte_DAX_Short_Ottimizzato   D30EUR M15   tick reali   deposito 100000   6 celle x 2 gambe ===' -ForegroundColor Cyan; $a=@('-NoProfile','-ExecutionPolicy','Bypass','-File',('"'+$p+'"'),'-Expert','ABTG_MaxMinNotte_DAX_Short_Ottimizzato','-Prova','R206a_moltiplicatore_stop_MAXMINDAX_D30EUR.txt','-Etichetta','r206a','-Pin',$pin,'-TerminaleBacktest','"C:\Program Files\BCM Markets MT5 Terminal"','-Modello','4','-Deposito','100000'); $pr=Start-Process powershell -ArgumentList $a -NoNewWindow -PassThru; if(-not $pr.WaitForExit($tmo*60*1000)){ Write-Host ('TETTO DI ' + $tmo + ' MINUTI SFONDATO: fermo il round. E UN RISULTATO, NON UN GUASTO: il referto che resta e PARZIALE.') -ForegroundColor Red; Stop-Process -Id $pr.Id -Force -ErrorAction SilentlyContinue; Get-Process metatester64,terminal64 -ErrorAction SilentlyContinue | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') } | Stop-Process -Force -ErrorAction SilentlyContinue; try{ $pr.WaitForExit() }catch{}; Start-Sleep -Seconds 10 }; $rc=$pr.ExitCode; if($null -eq $rc){ $rc='NON LEGGIBILE' }; Write-Host ('   esito r206a: codice ' + $rc + '   (0=GIRATO  2=NON MISURATO  3=GIRATO CON RILIEVI  1=non e partito)') -ForegroundColor Yellow; $d="$dsk\ROUND_r206a"; if(-not (Test-Path $d)){ Write-Host 'MANCA la cartella ROUND_r206a sul Desktop: il round NON ha prodotto raccolta.' -ForegroundColor Red } else { Compress-Archive -Path "$d\*" -DestinationPath "$dsk\ROUND_r206a.zip" -Force; Write-Host 'ZIP PRONTO DA MANDARE: Desktop\ROUND_r206a.zip' -ForegroundColor Green }; Write-Host 'FILE ATTESI NELLO ZIP (4):' -ForegroundColor Gray; Write-Host '   REFERTO_ROUND_r206a.txt' -ForegroundColor Gray; Write-Host '   ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_IS_r206a.csv' -ForegroundColor Gray; Write-Host '   ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_OOS_r206a.csv' -ForegroundColor Gray; Write-Host '   R206a_moltiplicatore_stop_MAXMINDAX_D30EUR.txt' -ForegroundColor Gray; Write-Host 'NEL REFERTO LEGGI LA RIGA  data:  -- DEVE ESSERE DI OGGI, altrimenti stai guardando un file vecchio.' -ForegroundColor Yellow; Write-Host 'ANCORA DI REGRESSIONE (numeri letti dai CSV di r81a in risultati_archivio/r81_csv/, NON da un referto) -- cella InpAtrSLmult=2.5, la cella VIVA:  IS  n=20  PF=1.87803  RF=1.52059  EqDD%=3.0977  Profit=4766.96   |   OOS  n=21  PF=2.15985  RF=3.02118  EqDD%=1.9213  Profit=6143.38.  SE NON TORNA il binario di oggi non e quello di r81a e le altre cinque celle non si leggono.' -ForegroundColor Magenta; if(Test-Path $d){ Get-ChildItem $d -Recurse -File | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize } }
```

🔴 **ATTENZIONE ALL'ETICHETTA, ed è la CLASSE 576 applicata alla lettera.** L'etichetta
di questa riga è **`r206a` in minuscolo**, **non** `R206A`, perché il file prova la
**dichiara al proprio interno** (r.414: *«ETICHETTA: r206a — grep -ril "r206" su tutto il
repo: ZERO»*), ed è la stessa convenzione dell'ancora (`r81a`) e dei round gemelli
(`r191a`, `r194a`). 👉 **Con `R206A` i risultati finirebbero archiviati sotto un nome che
nessuno cercherà**, che è esattamente il danno per cui la 576 esiste. Di conseguenza la
cartella sul Desktop è `ROUND_r206a` e lo zip `ROUND_r206a.zip`.

📅 **Quale data deve leggere chi riceve lo zip**: dentro `REFERTO_ROUND_r206a.txt`, la riga
che comincia con **`data            :`**.

---

## ③ 📦 I FILE ATTESI NELLO ZIP (`Desktop\ROUND_r206a.zip`) — **4**

| file | che cos'è |
|---|---|
| `REFERTO_ROUND_r206a.txt` | il referto del driver: data, macchina, tetto barre, deposito, e **per ogni CSV** Profit / PF / Equity DD % / Trades riga per riga |
| `ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_IS_r206a.csv` | gamba **IS**, **6 righe** attese |
| `ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_OOS_r206a.csv` | gamba **OOS**, **6 righe** attese |
| `R206a_moltiplicatore_stop_MAXMINDAX_D30EUR.txt` | il file prova **come scaricato dal pin** |

---

## ④ ⏱️ IL TETTO DI TEMPO — **84 minuti**, e da dove viene il numero

🔴 **Il tetto non è pazienza: è l'AMPIEZZA DELLA FINESTRA DI RISCHIO** (classe **582**). La
precondizione che autorizza lo `Stop-Process` («nessun `terminal64` del percorso bersaglio è
vivo») è verificata a **t=0**, l'uccisione avviene a **t=TETTO**, e in mezzo quel percorso è il
terminale del **demo `50503392`**, che un umano può riaprire. Più largo il tetto, più larga la
finestra di rischio.

**Il conto, passo per passo:**

| passo | numero | fonte |
|---|---:|---|
| passate di questo round | **12** | 6 celle × 2 gambe (`controlla_prova.py`) |
| base di costo | **0,7 min/passata** | `risultati_archivio/R104_REFERTO_DRIVER_20260825_0738.txt` r.15 (`durata: 0.7 minuti di passata`) |
| costo atteso | **8,4 min** | `12 × 0,7` |
| moltiplicatore | **×10** (il **minimo** della banda 10-20) | la base è **ben appaiata** — stesso EA, stesso simbolo, stesso TF (vedi sotto) — quindi non serve margine extra: è la regola 2 della **classe 583**. E per la **582** più stretto è meglio |
| **TETTO** | **84 minuti** | `8,4 × 10`, non un numero tondo |

🟢 **Perché questa base è buona, verificata aprendo il referto invece di citarlo:** `R104`
gira lo **stesso EA**, lo **stesso simbolo `D30EUR`**, lo **stesso `M15`**, **modello 4 (tick
reali)**, **deposito 100000**, e su una finestra **più lunga di due mesi**
(`2024.09.26 → 2026.08.24` contro il nostro `→ 2026.06.30`). 🟢 In più girava una **copia di
misura** dell'EA (`..._MFE.mq5`, contatore MFE **tick per tick**), che è **più lenta**, non più
veloce: la base è quindi un **inviluppo superiore**.
⚠️ **E il caveat che dichiaro invece di nasconderlo**: il referto di `R104` dice esplicitamente
*«NON è un walk-forward e NON è un'ottimizzazione: UNA passata»* (r.91). Quindi 0,7 min è il
costo di **una passata lanciata da sola**; dentro un'ottimizzazione il costo per passata può
differire. È il motivo per cui il moltiplicatore resta ×10 e non ×5.

⚠️ **Se il tetto scatta NON è un successo** (checklist p.19): la riga lo dice in rosso e il
referto che resta è **PARZIALE**.
🔴 **La chiusura d'emergenza è chirurgica e su una COSTANTE**: `Stop-Process` colpisce solo
`metatester64`/`terminal64` il cui `Path` sta sotto `C:\Program Files\BCM Markets MT5 Terminal\`
— **stringa letterale dentro la riga, in tutte e due i punti (pre-volo e uccisione), nessuna
variabile che arrivi da fuori** — verificato con `grep` sulla riga generata.

---

## ⑤ 🪝 L'ANCORA DI REGRESSIONE — **c'è, ed è presa dal CSV**

La cella **`InpAtrSLmult = 2,5`** è il **valore VIVO** del preset in campo, e deve riprodurre
`r81a`. La riga stampa i numeri in coda, in magenta. 🔴 **Letti dai CSV grezzi**
`risultati_archivio/r81_csv/ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_{IS,OOS}_r81a.csv`,
**non** da un referto:

| gamba | n | PF | RF | Equity DD % | Profit |
|---|---:|---:|---:|---:|---:|
| **IS** | **20** | **1,87803** | **1,52059** | **3,0977** | **4766,96** |
| **OOS** | **21** | **2,15985** | **3,02118** | **1,9213** | **6143,38** |

🟢 **Controllo in più che ho fatto**: tutti e due i CSV di `r81a` contengono **due righe**
(`Pass 0` e `Pass 1`) **identiche al centesimo** — sono i gemelli sul magic del cancello G0,
non due celle. Quindi l'attesa è **un solo esito**, ripetuto.

🔴 **Se non torna, il verdetto non è «il moltiplicatore non serve»: è «il binario di oggi
non è quello di r81a»**, e le altre cinque celle **non si leggono**.

⚠️ **Il campione è SOTTILE e va detto adesso, non dopo**: `n = 20` (IS) e `n = 21` (OOS).
Siamo **lontanissimi** dal pavimento dei **150** della regola **A** dell'Emendamento della
Finestra. 👉 **Quindi su questo round il MERITO è SOSPESO per costruzione** (valvola di R59 +
regola B del 16/08): **si giudica il RISCHIO**, che vale a qualunque `n`, e la direzione
dell'asse. 🔴 **Nessuna cella di questo round può essere promossa sul merito**, e chi leggesse
un PF 2,x su 21 operazioni come una conferma starebbe facendo l'errore che l'Emendamento esiste
per impedire.

---

## ⑥ 📐 IL TETTO DELLE ~100.000 BARRE

**M15 su 21 mesi ≈ 34.900 barre** — numero **DERIVATO** dal file prova (96 barre/giorno × ~364
giorni di borsa), **non misurato da un referto**. Sotto il tetto delle ~100.000: nessuna tranche.
🟢 E il pre-volo della classe 160 lo guarda comunque per conto suo: muore solo se `MaxBars`
sta **fra 1.000 e 200.000**, e su questa macchina `R201A` ha riportato `MaxBars=100000000`.

---

## ⑦ 🕳️ I BUCHI, DICHIARATI

- 🟠 **Le due celle del fianco sinistro (1,5 e 2,0) sono già ESCLUSE PER COSTO a priori**
  dal file prova (22,7-30,9× e 30,2-41,2× contro la frontiera dei 40×). Girano lo stesso,
  **apposta**, perché servono a dare **forma** all'asse: ma **non sono candidate**, e il
  referto non deve proporle nemmeno se escono belle.
- 🟠 **Del refine si prende la DIREZIONE, non i numeri**: gira su una finestra diversa
  (`2024.01.01→2026.06.30` **tutta in campione**) e a **deposito 10.000** contro i nostri
  100.000. I suoi PF/DD **non sono soglie qui**, e il file prova lo dichiara.
- 🟠 Che il `.ex5` sul PC di backtest corrisponda al `.mq5` letto qui: il driver ricompila dal
  pin, ma **non l'ho misurato**.
- 🟠 **Che il feed `D30EUR M15` di questa macchina copra la finestra a tick reali**:
  `R201A`/`R172D` hanno girato **M5** su `D30EUR`/`U30USD` da questa macchina il 21/09, ma
  **`M15` su questo EA da `DESKTOP-H4D7CAJ` non l'ho trovato in repo**. Se il feed non copre,
  l'esito sarà **2 = NON MISURATO** (Trades=0) e **non** è un verdetto sulla sedia: il driver
  lo dice a chiare lettere.
- 🔴 **Prova di regime: assente.** 21 mesi = **un solo regime**. Regola **C**
  dell'Emendamento **non soddisfatta**, e non lo sarà alla fine di questo round.

---

## ⑧ 🚦 IL CANCELLO — STRATO 1 (deterministico)

| controllo | esito |
|---|---|
| `python3 backtest_pipeline/controlla_prova.py` sul file prova | 🟢 **OK** — `pin=45 celle=6`, **12 passate**, **0 problemi** |
| `python3 backtest_pipeline/controlla_riga.py --riga … --prova …` | 🟢 **`ESITO: nessun difetto meccanico`**, **8 controlli passati**, 2 rilievi non bloccanti (457 e 225) |
| parser PowerShell (`pwsh`, `Parser::ParseInput`) | 🟢 **0 errori** |
| **una sola riga fisica** (classe **538**) | 🟢 sì — `\n` = 0 |
| **ASCII puro** | 🟢 sì — 0 caratteri ≥ 128 |
| apici singoli bilanciati / `{}` / `()` | 🟢 98 apici (pari), 14/14 graffe, 32/32 tonde |
| etichetta `r206a` già occupata in `risultati_prove/`? | 🟢 **no** — e `grep -ril "r206a\|R206A"` su tutto il repo trova **solo** il file prova, `report/I_FILE_FERMI_2026-09-22.md` e la checklist |
| il file prova dichiara al suo interno un `-Etichetta` diverso dalla sigla? (**classe 576**) | 🔴 **SÌ** — r.414 dichiara **`r206a`**. 🟢 **La riga usa QUELLA**, non `R206A` |
| il file prova esiste **al pin** `52af6583` | 🟢 sì, ed è **identico** alla copia in working tree (`diff` vuoto) |
| `MARCATORE_RIGA_ROUND_VPS_v2` presente in `RIGA_ROUND_VPS.ps1` **al pin** | 🟢 sì |

**Rilievo 457, letto a mano come chiede il cancello**: il filtro dello `Stop-Process` è la
**costante** `'C:\Program Files\BCM Markets MT5 Terminal\*'` in **tutte e due** le occorrenze.
**Nessuna variabile che arrivi da fuori.**

🔴 **STRATO 2 (agente `controllo-preventivo`): NON ANCORA FATTO.** Questa è una bozza.
