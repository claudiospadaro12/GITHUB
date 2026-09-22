# 🚀 R172E — L'ASSE `InpTP1_R` DA `0.50` A `2.00`, sedia Dow `770202`

**22/09/2026** · branch `lavoro` · pin della riga: **`eea3838cbf800181427a4c62b85bbfc3739424d1`**
File prova: `backtest_pipeline/prove/R172e_tp1r_dowapertura_U30USD.txt` (80 pin, **7 celle**)
— **i cancelli sono congelati in quel file** (scritti il **16/09**, ed **emendati da un
ADDENDUM del 22/09** che dichiara quali punti prevalgono). Classe 549: qui c'è **solo una mappa
di lettura**, non una seconda copia della regola.

---

## 🟢 COSA MISURA, E PERCHÉ QUESTO FILE E NON UNO NUOVO

> **Asse unico `InpTP1_R`: `0.50 · 0.75 · 1.00 · 1.25 · 1.50 · 1.75 · 2.00`** — sette celle, con
> `1.00` (la cella **viva**) dentro l'asse come **ancora**.

🔴 **Perché esiste.** `R202A` (21/09) ha misurato lo stesso asse ma **solo sotto l'uno**, e la
superficie OOS è uscita **monotona crescente col massimo SUL BORDO**:

| `InpTP1_R` | 0.25 | 0.50 | 0.75 | **1.00** ← viva |
|---|---:|---:|---:|---:|
| **PF OOS** | 0,932 | 1,103 | 1,137 | 🎯 **1,272** |

> 👉 **Un massimo sul bordo non è un ottimo: è il punto in cui abbiamo smesso di guardare.**

💎 **E questo file era già in repo dal 16/09, mai girato.** Passa il cancello, ha **78 pin su
80 identici** a quello che stavo scrivendo da zero, e il suo asse **contiene** quello nuovo:
- **tre** ancore di riproduzione (`0.50`, `0.75`, `1.00`) invece di una;
- la cella **`2.00`**, che **chiude la domanda sulla direzione senza un terzo round**;
- **allo stesso costo macchina.** *(Il file nuovo, `R204a`, resta in repo marcato **SUPERATO,
  mai girato**.)*

---

## 🛑 CHE COSA QUESTO ROUND **NON** PUÒ FARE — e va letto prima dei numeri

Le **posizioni** del Dow stanno, **dimostrato**, fra **48 e 74** (IS) e **81 e 130** (OOS)
(`n = P + f`, `0 ≤ f ≤ P` → `max(n)/2 ≤ P ≤ min(n)`, applicato agli `n` di R202A). La
**regola A** del 16/08 chiede **IS ≥ 150 operazioni**.

> 🔴 **Il Dow è sotto con certezza in tutte e due le finestre, e sotto ENTRAMBE le letture di
> «operazione»**: anche contando le **uscite** — il numero più generoso — l'IS massimo misurato
> è **96** e l'OOS **161**. **Non c'è definizione che salvi il campione**, quindi la conclusione
> **non dipende** dal conteggio dei `position_id` (che resta da fare).
>
> 👉 **Nessuna cella di questo round può essere promossa in campo.** Una cella che vince si
> guadagna **una finestra più lunga**, non una sedia. Il verdetto legittimo è una **DIREZIONE**.
> 🟢 Il **rischio** si giudica lo stesso, a qualunque `n` (regola B): un DD accaduto è un fatto.

⚠️ **E il seguito promesso NON è verificato**: nessuno ha misurato se lo **storico BCM su
`U30USD` M5** arrivi più indietro del **2024.09.26**. Il tetto delle 100k barre **non** è il
limite (il referto R202A porta `MaxBars=100000000`): il limite sarebbe **lo storico del broker**.
**Va sondato prima di prometterla, quella finestra.**

---

## 💸 IL COSTO: **non migliora e non peggiora — è FUORI da quest'asse**

🔴 **Correzione a una mia frase del 22/09 che era già uscita in chat** (classe **555**): avevo
scritto che *«salendo, la frontiera del costo si allontana»*. **Falso.**

`InpTP1_R` **non entra nel calcolo dello stop**. Ramo attivo (`InpEntryMode=2` RETEST,
`InpSLMode=0`), `ABTG_Dow_Apertura_US.mq5` **r.1320-1322**:

```
sl   = sellPx          <- bordo opposto del range
dist = entry - sl      <- calcolato PRIMA, e senza tp
tp   = ... dist * TpTotalR()
```

| | |
|---|---|
| **`stop / spread`** | 🟢 **61,9× su TUTTE e sette le celle** — frontiera **40×**, pavimento duro **13,3×**: **passa, invariato** |
| **`bersaglio / spread`** | cresce (a `2.00` vale **123,8×**) — ⚠️ **ma è un'altra grandezza**: la frontiera è definita sullo **stop** |

*Fonti: stop mediano Dow **123,80** punti indice `[MIS n=446]` (`STOP_VS_SPREAD_FTMO_2026-09-20.md`
**r.276**, fonte `Studio_U30USD` a range 15' — **dichiarata prudente nella riga stessa**: qui il
range è 35', quindi lo stop vero è **più largo** e il margine **più grande**) · spread mediano
`U30USD` ora 14 = **2,00** (**r.312**, colonna **BCM**).*

👉 **La notizia buona, detta giusta: su quest'asse il costo non è un vincolo e NON SI MUOVE.**

---

## ⚙️ IL PACCHETTO D'USCITA, e le manopole **INERTI**

`InpTP1_R` muove **due** cose: il **parziale** (50% a `InpTP1_R × riskDist`, r.1739) e il
**bersaglio finale** (`InpTP1_R × 3`, r.1456 `TpTotalR`). Il resto **non cambia** fra le celle:

- **Trailing armato dal primo tick** (`InpUseTrailing=true`, `InpTrailStartR=0.0`).
  `InpTrailMode=1` = **`ABTG_TRAIL_PREVBAR`** (enum r.209-214) → stop al **minimo della candela
  precedente** su **`InpTrailTF=5`** (M5): r.**1834-1835**, `iLow(_Symbol, InpTrailTF, 1)`.
  🔴 **INERTI in questo ramo**: `InpTrailFixedPts=410` (lo legge solo `FIXED`, r.1836-1837) e
  `InpTrailAtrMult=2.0` (solo il ramo ATR, r.1838-1839). Sono pinnati **per bloccare il
  default**, **non** descrivono il trailing di questo round — classe **541**, e il 22/09 ci sono
  ricascato dentro.
- **Chiusura a fine sessione**: `InpCloseAtEnd=true`, 17:30 server.

⚠️ È **plausibile, non misurato**, che salendo il bersaglio il parziale scatti più di rado e il
peso delle uscite si sposti su trailing e fine sessione. **Quanto spesso il bersaglio venga
raggiunto oggi (a 3,00 R) è `[NON MISURATO]`**: si legge dal calo di `n`, non si afferma.

---

## 🎯 LA MAPPA DI LETTURA (la regola sta nel file prova)

| | cosa mi aspetto |
|---|---|
| **riproduzione** | le celle `0.50`, `0.75` e `1.00` riproducono R202A (PF OOS **1,10328** / **1,13744** / **1,27175**). Tolleranza: **un centesimo** sul Profit, uguaglianza su `n`/`PF`/`DD` alla quinta cifra (cancello G1, `MANOPOLE_INERTI_2026-09-09.md` r.40). Oltre → **round non confrontabile** |
| **`n` scende salendo** | più lontano il primo obiettivo, meno spesso scatta il parziale, meno **uscite**. Se non scende, il round **non ha misurato quello che crede** |
| 🎯 **la DIREZIONE** | **continua a salire fino a `2.00`** → l'ottimo è ancora oltre · **gira** → abbiamo trovato **la cresta** · **scende subito sopra `1.00`** → `1.00` era il massimo, e il *«non ancora misurato»* si chiude con un **NO**. **Tutte e tre sono risultati** |
| **rischio** | 🔴 **in IS il DD PUÒ SALIRE, ed è la prima cosa da guardare**: B2.2 (nel file prova, `grep "B2.2  IL PROMESSO"`) ha misurato che questo asse porta il DD IS da 5,52% a 7,76% in media e **fino a 12,4677%** sulla cella più alta. Misura a **denominatore fisso** `(Profit/RF)/80000×100`, e **due soglie, una per gamba** (classe 557): **IS** viva 5,7575 → allarme sopra **6,3333** · **OOS** viva 4,4499 → allarme sopra **4,8949** |

🔴 **Il DD si legge a denominatore fisso, NON su `Equity DD %`** (classe **550**): quello divide
per il **picco**, che cambia da cella a cella. Su `R202B` la distorsione vale **+22,8%** — più del
margine di un cancello a −20% — e fra due celle **l'ordine si ribalta**.
⚠️ E se `Recovery Factor = 0` (passata a **zero trade**): `0/0` → si scrive
**`[NON CALCOLABILE DAL CSV]`**. Una cella vuota esce con `DD 0,0000` e sembra **la migliore
della tabella**: è **assenza di informazione**, non un merito.
⚠️ **La cella `1.00` NON sarà `Pass 0`** (l'asse parte da `0.50`): si confronta per il **valore
nella colonna `InpTP1_R`**, mai per il numero di `Pass`.

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
& { $ErrorActionPreference='Stop'; $pin='eea3838cbf800181427a4c62b85bbfc3739424d1'; if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('VIETATO: questa riga gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama ' + $env:COMPUTERNAME + '. Sul VPS operano le sei sedie della challenge FTMO e un backtest a tick reali lo inchioda: firma di Claudio del 21/09.') }; $w="$env:USERPROFILE\abtg_round"; $p="$w\RIGA_ROUND_VPS.ps1"; $dsk=[Environment]::GetFolderPath('Desktop'); $tmo=120; New-Item -ItemType Directory -Force -Path $w | Out-Null; Remove-Item $p -Force -ErrorAction SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ROUND_VPS.ps1?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $p -ErrorAction Stop; if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ROUND_VPS_v2' -Quiet)){ throw 'SCRIPT VECCHIO: manca MARCATORE_RIGA_ROUND_VPS_v2' }; Write-Host 'BERSAGLIO: il solo MT5 di questo PC, C:\Program Files\BCM Markets MT5 Terminal, demo 50503392. Tutto il resto (challenge FTMO 541452707, 100k 50504263, REALE 10105439, Pepperstone, Tickmill, banco 50504400) sta su una macchina diversa e questa riga non la raggiunge.' -ForegroundColor Cyan; $mt=@(Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id,MainWindowTitle,Path); Write-Host '--- MT5 APERTI SU QUESTA MACCHINA (PID / titolo / cartella) ---'; $mt | Format-Table -AutoSize; if(@($mt | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') }).Count -gt 0){ throw 'MT5 E APERTO: chiudilo A MANO (il PID sta nella tabella qui sopra), dopo aver guardato che non abbia EA attaccati, poi reincolla la riga. Non lo chiudo io: quel terminale e loggato sul demo 50503392 e da questa macchina il 14/08 sono partiti ordini veri.' }; Write-Host '=== ROUND R172E   EA ABTG_Dow_Apertura_US   U30USD M5   tick reali   deposito 80000   7 celle x 2 gambe ===' -ForegroundColor Cyan; $a=@('-NoProfile','-ExecutionPolicy','Bypass','-File',('"'+$p+'"'),'-Expert','ABTG_Dow_Apertura_US','-Prova','R172e_tp1r_dowapertura_U30USD.txt','-Etichetta','R172E','-Pin',$pin,'-TerminaleBacktest','"C:\Program Files\BCM Markets MT5 Terminal"','-Modello','4','-Deposito','80000'); $pr=Start-Process powershell -ArgumentList $a -NoNewWindow -PassThru; if(-not $pr.WaitForExit($tmo*60*1000)){ Write-Host ('TETTO DI ' + $tmo + ' MINUTI SFONDATO: fermo il round. E UN RISULTATO, NON UN GUASTO: il referto che resta e PARZIALE.') -ForegroundColor Red; Stop-Process -Id $pr.Id -Force -ErrorAction SilentlyContinue; Get-Process metatester64,terminal64 -ErrorAction SilentlyContinue | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') } | Stop-Process -Force -ErrorAction SilentlyContinue; try{ $pr.WaitForExit() }catch{}; Start-Sleep -Seconds 10 }; $rc=$pr.ExitCode; if($null -eq $rc){ $rc='NON LEGGIBILE' }; Write-Host ('   esito R172E: codice ' + $rc + '   (0=GIRATO  2=NON MISURATO  3=GIRATO CON RILIEVI  1=non e partito)') -ForegroundColor Yellow; $d="$dsk\ROUND_R172E"; if(-not (Test-Path $d)){ Write-Host 'MANCA la cartella ROUND_R172E sul Desktop: il round NON ha prodotto raccolta.' -ForegroundColor Red } else { Compress-Archive -Path "$d\*" -DestinationPath "$dsk\ROUND_R172E.zip" -Force; Write-Host 'ZIP PRONTO DA MANDARE: Desktop\ROUND_R172E.zip' -ForegroundColor Green }; Write-Host 'FILE ATTESI NELLO ZIP (4):' -ForegroundColor Gray; Write-Host '   REFERTO_ROUND_R172E.txt' -ForegroundColor Gray; Write-Host '   ABTG_Dow_Apertura_US_U30USD_IS_R172E.csv' -ForegroundColor Gray; Write-Host '   ABTG_Dow_Apertura_US_U30USD_OOS_R172E.csv' -ForegroundColor Gray; Write-Host '   R172e_tp1r_dowapertura_U30USD.txt' -ForegroundColor Gray; Write-Host 'NEL REFERTO LEGGI LA RIGA  data:  -- DEVE ESSERE DI OGGI, altrimenti stai guardando un file vecchio.' -ForegroundColor Yellow; if(Test-Path $d){ Get-ChildItem $d -Recurse -File | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize } }
```

📅 Dentro `REFERTO_ROUND_R172E.txt`, la riga **`data            :`** dev'essere del giorno
in cui lo lanci.

---

## ②③ BARRE E TEMPO

**Barre**: stesso EA, simbolo, M5 e **stessa finestra** di `R202A` — referto:
`tetto barre : MaxBars=100000000`. Il pre-volo della classe 160 muore solo fra 1.000 e 200.000.
**Passa.**

**Tempo**: tetto **120 minuti**, ed è un **tetto**. 🟢 **E qui la base misurata è proprio a
14 passate**: `R172D` e `R201A` (7 celle × 2 gambe **ciascuno**, come questo) sono partiti il
21/09 alle **21:01:33** e **21:05:24** — **3'51"** fra i due avvii, *una durata solo se
sequenziali*. Margine **~30×**. ⚠️ Se il tetto scatta **non è un successo**: il referto che resta
è **PARZIALE**.

---

## ④ 🚦 IL CANCELLO

**Strato 1**: `controlla_prova.py` → **verde** (80 pin, **7 celle**, 0 problemi) ·
`controlla_riga.py --oggetto md` → **verde** · parser PowerShell **0 errori** · **una sola riga
fisica** (classe 538) · **zero** non-ASCII · URL del pin → **200**.

**Contro-esempi tenuti**
- La riga è confrontata **parola per parola** con quella di `R203A`, **già approvata dal cancello
  con PASS in chiaro**: differiscono **solo** `pin`, etichetta, EA, simbolo, numero di celle, nome
  del file prova e nomi dei file attesi.
- Il file prova ha **1.711 righe di criteri congelati il 16/09**, che **non sono stati
  riscritti**: l'**addendum del 22/09** li **emenda prima** che il round produca un numero.
  🔴 **E in TESTA al file c'è la MAPPA DEI PUNTI SUPERATI** (riga vecchia · cosa diceva ·
  cosa vale ora), perché una clausola generica di precedenza **non copre i numeri che non
  nomina** e il lettore incontra prima i vecchi — **classe 556**.
- 🔴 **Le soglie di rischio del 16/09 erano scalate su una taglia che non vola più** (0,65%
  contro il **2,00%** firmato il 20/09): *«si sfonda il muro sopra il 15,38% sul banco»* — il
  numero vero è **5,00%**, soglia **larga 3,08 volte** — e *«servirebbe un peggioramento di
  7,5 volte, questa soglia non può mordere»* — ne servono **1,22**: il controllo di vuoto era
  **falso**. Riscalate nel paragrafo 7 dell'addendum (estensione **classe 547**).

**🕳️ Non coperto**
- Il rapporto **uscite/posizioni** non è misurato: ogni `n` è **`[uscite]`**.
- **Lo storico BCM oltre il 2024.09.26**: non sondato. È il collo di bottiglia del **seguito**,
  non di questo round.
- **Quanto spesso il bersaglio venga raggiunto oggi**: `[NON MISURATO]`.
- Che il `.ex5` corrisponda ai `.mq5`: il driver **ricompila dal pin** e il referto lo stampa.
