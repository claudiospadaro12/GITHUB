# 🚀 R205A — IL LATO CORTO DEL DAX, CON LA STESSA FILOSOFIA DEL RETEST

**22/09/2026** · branch `lavoro` · pin della riga: **`19e7c859674fd11750ceb24e1f1c4d798785fd3e`**
File prova: `backtest_pipeline/prove/R205a_lato_corto_DAX_D30EUR.txt` (90 pin, **2 celle**)

> Nasce da una domanda di Claudio di stamattina: *«Ma perché non riusciamo con la stessa
> filosofia del retest a fare anche la parte short del DAX?»* — e la risposta è che
> **possiamo**, la macchina c'è già, e quello che credevamo bocciato **misurava un'altra cosa**.

---

## 🟢 COSA MISURA, IN UNA RIGA

> **Asse unico `InpAllowShort`: `false` → `true`.** Tutto il resto inchiodato alla geometria
> viva della sedia DAX `770101` (range 35', buffer 500, retest offset 200, `InpTP1_R=1.0`).

### 1️⃣ Non è un problema di codice: **la macchina c'è già**

`ABTG_DAX_Apertura_EU.mq5` **r.1966** — `MonitorRetest()` ha il ramo SELL, **specularmente
identico** al BUY:

```
if(InpAllowShort && shortOK && !gBrokeLow && bid <= sellTrig)
```

Rottura **sotto** il minimo del range → `SELL LIMIT` sul ritorno al livello. **È una manopola
del preset, non una funzione da scrivere.** Lo stop è il bordo opposto dello stesso range
(**r.1974**, `sl = buyPx` con `InpSLMode=0` — aperta con `sed`, non citata a memoria).

### 2️⃣ 🔴 E quello che «aveva ucciso lo short» **misurava un altro meccanismo**

In repo lo short dell'apertura risulta bocciato. Ma dal `DIARIO.md`:

| round | data | cosa misurava | esito |
|---|---|---|---|
| **R42** | 13/08 | il **FADE** del falso breakout (`RANGE_FADE`) | 48/48 bocciate |
| **R43** | 13/08 | il **RIMBALZO** su ORL/ORH, 4 lati | 2 verdi su 64, **solo-IS e ribaltate** |

🔴 **Il FADE e il RIMBALZO si giocano SENZA rottura** — sono il *rifiuto* del livello.
**Il RETEST si gioca DOPO una rottura confermata**, sul ritorno. Sono due mestieri diversi,
e noi abbiamo bocciato il primo.

👉 **Il retest-short sul DAX è un «NON ANCORA MISURATO» che si nascondeva dietro un «già
bocciato».** È *esattamente* la cosa che il certificato di morte del 09/09 esiste per impedire.

🟠 **E dichiaro quello che NON ho fatto**, invece di darlo per fatto: **non ho aperto i file
prova di R42 e R43** per confermare che usassero `InpEntryMode=3` (FADE) e non `2` (RETEST).
Se uno dei due avesse già misurato il retest-short, questo round è una **ripetizione** e va
dichiarata come tale nel referto, non spacciata per prima volta. Sta scritto anche nel file prova.

### 3️⃣ 🟢 L'indizio a favore, ed è di casa

`risultati_archivio/studio_apertura/Studio_D30EUR_RIEPILOGO.csv`, **440 breakout veri** sul DAX:

| lato | trade | win | aspettativa | totale |
|---|---:|---:|---:|---:|
| Solo LONG | 225 | 36,0% | 0,007 R | +1,6 R |
| **Solo SHORT** | 215 | 37,2% | **0,045 R** | **+9,6 R** |

Sul DAX lo short ha un'aspettativa **sei volte** il long.
⚠️ **Ma quello studio gira a range 15', buffer 200, TP 2,0R e a BREAKOUT CIECO, non a retest.**
È un **INDIZIO, non una promessa** — e la geometria diversa è la stessa riserva della **classe 551**
(una scala presa da uno studio con un'altra geometria).

### 4️⃣ 🟠 E nemmeno **il costo in DD** è misurato sulla nostra configurazione

`CENSIMENTO_CONTRATTI_v2.md` **r.381**: *«il lato corto da solo vale +3,8873 punti (10,5984 con,
6,7111 senza, stessa finestra e stesso deposito a 1,0%)»*. **MA** quel «con» viene da
`r83_csv/ABTG_Apertura_3Ingressi_…`, magic `777120`/`777121`: **non è questo EA e non è questa
geometria.** 👉 Un'altra ragione per **girare il round** invece di discuterlo.

---

## 🪤 LA TRAPPOLA DA SAPERE **PRIMA**: LO SLOT

`CENSIMENTO_LATO_SHORT_2026-09-09.md` **r.595**, misurato **due volte**:

> `n(long) + n(short) != n(entrambi)` — sulle aperture: **256 + 243 = 316**, non 499.

Il primo lato che spara **consuma il posto della giornata**.

🔴 **Il puntatore del censimento è sbagliato, e lo correggo invece di copiarlo**: `r.257` è un
**enum** (`ABTG_SPACE_*`), non c'entra niente con lo slot — aperta con `sed`. Il meccanismo
**vero** sta nella macchina a stati, **r.887-899** (`grep "case PH_PLACED"`): appena il primo
`LIMIT` viene piazzato si passa a `PH_PLACED` e `MonitorRetest()` **non viene più chiamato**,
quindi il lato opposto è abbandonato per la giornata — **sia se il LIMIT si riempie, sia se
scade inevaso**.

> 🔴 **E QUI C'È LA COSA CHE CAMBIA LA LETTURA DEL ROUND, e va scritta adesso, non dopo aver
> visto i numeri.** `R51` ha aggiunto `InpAllowReverse` **apposta** per chiudere questo buco
> (il secondo ciclo sul lato opposto), e da noi è **SPENTO**. Quindi lo slot morde per intero.
> **Se questo round dicesse «lo short non aggiunge», la domanda successiva NON sarebbe «lo
> short non vale»: sarebbe «lo short non ha avuto il posto», e il round dopo sarebbe
> `InpAllowReverse`.**

👉 **Accendere lo short NON AGGIUNGE operazioni: in parte le RUBA al long.** Chi legge i due
numeri separati e li somma si illude. **Questo round misura LA SEDIA INTERA**, non il lato
corto da solo, ed è l'unico modo onesto di leggerlo.

---

## 🔒 L'ASSE È ISOLATO — verificato, non assunto

Il censimento avverte che *«spegnere lo short spegne anche il REVERSE»* (il secondo ciclo,
R51). **Qui non morde**: `InpAllowReverse` è `false` nel preset in campo **E** pinnato `false`
in questo file, quindi accendere lo short **non** accende il reverse. E l'EA lo dice da solo
in `OnInit` (**r.586**): con un solo lato consentito il secondo ciclo non parte.
👉 **Un asse solo: `InpAllowShort`.**

🟠 **Nota di sintassi** (l'ho sbagliata al primo giro e l'ha presa il cancello): l'asse è
scritto `0||0||1||1||Y`, **non** `false||false||1||true||Y`. È la convenzione di casa per i
booleani (già usata da `InpAllowLong`, `InpAllowReverse`, `InpAllowShort` in altri file prova)
ed è anche **l'unica che il cancello accetta**: `controlla_prova.py` **r.205** rifiuta un asse
non numerico. MT5 scrive e rilegge i bool come `0/1` nell'`.ini`, e i nostri CSV lo confermano
(`InpBreakevenAtTP1` esce come `1`).

### 💸 E IL COSTO **NON SI MUOVE** SU QUEST'ASSE — classe 555

🟢 Lo stop del lato corto è **simmetrico** a quello del lato lungo: il bordo **opposto** dello
**stesso** range (r.1974). Stessa ampiezza di range → stessa distanza di stop → **stesso
rapporto `stop/spread`**. Le due celle stanno **entrambe** a **32,3×** (`54,90 / 1,70`),
**42,3×** con lo stop forward `[MIS n=8]`. La frontiera dei **40×** e il pavimento duro di
**13,3×** valgono **identici** sulle due celle.

🔴 **Non si scrive «il costo migliora» né «peggiora»: NON SI MUOVE.** (La classe 555 nasce
proprio da un mio errore del 21/09: avevo raccontato una frontiera che si allontanava lungo un
asse che non la tocca.)

⚠️ **E il limite del numero**: lo stop mediano **54,90** `[MIS n=3]` è misurato sulle operazioni
**long** in forward. Sul corto la **geometria** garantisce la simmetria, il **campione** no —
quindi il *verso* regge, il *numero esatto* sul lato corto è **[NON MISURATO]**.

---

## 🎯 L'ATTESA, DICHIARATA **PRIMA** DEI NUMERI

| # | cosa mi aspetto | e se non succede |
|---|---|---|
| **a** | la cella `false` **riproduce R202B Pass 3 / R201A**: IS `n175 · PF 1,12733 · EqDD 5,4089 · profit 3050,56` — OOS `n270 · PF 1,39520 · EqDD 7,2506 · profit 14355,32`. Tolleranza **G1** (`report/MANOPOLE_INERTI_2026-09-09.md` r.40): un centesimo sul Profit, uguaglianza su `n`, PF e DD alla quinta cifra | oltre quella il round **non è confrontabile**: si cerca il pin che balla, non si legge il resto |
| **b** | `n` **sale** accendendo lo short — ed è la verifica che il ramo SELL si sia acceso davvero. **Ma sale MENO della somma**, per lo slot | se `n` **non** sale, il ramo **non ha mai sparato** e il round non ha misurato niente |
| **c** | il **cancello di promozione**, e serve **tutto insieme** (dettaglio sotto) | manca anche uno solo → **nessuna promozione** |
| **d** | il **profitto** riportato **sempre** accanto al PF: è il giudice pulito, immune alla distorsione del conteggio sulle uscite. Cella `false` OOS: **14355,32** | — |

### 🚦 Il cancello `c`, coi numeri già scritti

| | criterio | soglia |
|---|---|---|
| **c1** | PF OOS della cella `true` ≥ PF OOS della cella `false` | **≥ 1,39520** — non «vicino»: **≥** |
| **c2** | DD OOS **a denominatore fisso** non peggiora di più del **10%** | **due basi, una per gamba** (classe 557) |
| **c3** | IS e OOS **concordi di segno** su PF e su `DD_fisso` | discordi → nessuna promozione |

🔴 **Perché «a denominatore fisso» e non `Equity DD %` — classe 550.** `Equity DD %` divide per
il **PICCO**, che **cambia da cella a cella**. Su R202B quella distorsione vale **+22,8%** — più
del margine di un cancello — e fra due celle **l'ordine si RIBALTA**. Quindi:

```
DD_fisso% = (Profit / Recovery Factor) / 80000 x 100
```

| gamba | base (cella `false`, R202B `1.00`) | 🔔 allarme sopra |
|---|---:|---:|
| **IS** | **5,8468%** | **6,4315%** |
| **OOS** | **8,9033%** | **9,7936%** |

🔴 **Due basi e non una (classe 557)**: un allarme tarato su una gamba sola è quello che il 21/09
ha fatto sì che la cella di riferimento **sfondasse il proprio allarme** nell'altra gamba.
⚠️ Se il `Recovery Factor` è `0` (passata a zero trade, `Profit=0`) la formula è `0/0`: si scrive
**`[NON CALCOLABILE DAL CSV]`**, non si inventa un numero.

### 🟢 E QUESTA VOLTA UNA CELLA **PUÒ** ESSERE PROMOSSA — la differenza col Dow

Le **POSIZIONI** del DAX in OOS stanno, **dimostrato**, fra **170 e 270** (da `n = P + f` con
`0 ≤ f ≤ P`, sugli `n` di R202B) → **sopra il pavimento di 150 della regola A con certezza**.
In IS stanno fra **112 e 175**: **indeterminato**, e va dichiarato.
👉 **Il MERITO si giudica in OOS. In IS si giudica il RISCHIO** (regola B del 16/08), che vale a
qualunque `n`.

### 🧪 LA CONTRO-IPOTESI, FALSIFICABILE

> **H0**: il lato corto non aggiunge edge e peggiora il rischio.
> **FALSIFICATA** se la cella `true` passa **c1 E c2 E c3** insieme.
> **CONFERMATA** se il PF OOS scende sotto **1,39520** **oppure** il `DD_fisso` OOS supera **9,7936**.
> Se il PF sale **ma il DD pure**, oltre l'allarme: *«COMPRA RENDIMENTO CON RISCHIO»*, e **la
> decisione è di Claudio** perché è un parametro di rischio, non una misura.

### 🕳️ QUELLO CHE QUESTO ROUND **NON** MISURA

- **Il lato corto DA SOLO**: per lo slot, **non è separabile** girando la sedia. Servirebbe un
  round con `InpAllowLong=false`, ed è **un'altra domanda**.
- **Il muro FTMO del 10% (classe 515)**: `Equity DD %` è dal **picco**, il Max Loss è **statico**
  dal saldo iniziale → il DD del tester è un **LIMITE SUPERIORE** e **non dimostra niente in
  nessuna direzione**. Si riporta `DDass/deposito` come tale.
- **Le POSIZIONI vere**: ogni `n` è **[uscite]**. Si contano sui `position_id`, dopo.

🔴 **TAGLIA DEL BANCO: 1,0% — NON è la taglia in campo** (`2,00%`, firma del 20/09). Pinnata a
`1,0` **apposta** per riprodurre R202B: senza quel pin l'attesa **(a)** non è verificabile.
**Ogni DD di questo referto va RADDOPPIATO prima di leggerlo a taglia vera**, e il raddoppio è
un **limite superiore**, non un'identità (`CalcLotByRisk` usa `ACCOUNT_BALANCE`). **Classe 547.**

---

## ① 🖥️ DOVE MANDARE QUESTA STRINGA

> ## 🖥️ **finestra PowerShell sul PC DI BACKTEST `DESKTOP-H4D7CAJ`** (utente `Master`).
> **Bersaglio: l'unico MT5 di quella macchina, `C:\Program Files\BCM Markets MT5 Terminal`, demo `50503392`.**
>
> 🔴 **COSA NON VIENE TOCCATO.** Tutto ciò che vive **sul VPS**: la challenge **FTMO `541452707`**
> (`C:\FTMO`, **sei sedie che stanno operando**), il **100k `50504263`**, il **REALE `10105439`**
> (`C:\BCM_Reale`), il piccolo `50503392` del VPS, Pepperstone, Tickmill, e il banco `50504400`
> (`C:\MT5_Backtest`, **spento**). Non è una promessa: è **un'altra macchina**, e la riga
> **si rifiuta di partire** se `$env:COMPUTERNAME` non è `DESKTOP-H4D7CAJ` — il `throw` è il
> **primo statement dopo `$pin`**, quindi muore **prima** di scaricare qualunque cosa.
>
> ✋ **PRIMA DI INCOLLARE: chiudi MT5 sul PC di backtest.** La riga **non lo chiude da sola**,
> apposta: quel terminale **è loggato su un conto demo vivo** (`50503392`) e il **14/08/2026**
> da quella macchina sono partiti **ordini veri**. Se lo trova aperto stampa PID + titolo +
> cartella e **si ferma**.

```powershell
& { $ErrorActionPreference='Stop'; $pin='19e7c859674fd11750ceb24e1f1c4d798785fd3e'; if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('VIETATO: questa riga gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama ' + $env:COMPUTERNAME + '. Sul VPS operano le sei sedie della challenge FTMO e un backtest a tick reali lo inchioda: firma di Claudio del 21/09.') }; $w="$env:USERPROFILE\abtg_round"; $p="$w\RIGA_ROUND_VPS.ps1"; $dsk=[Environment]::GetFolderPath('Desktop'); $tmo=120; New-Item -ItemType Directory -Force -Path $w | Out-Null; Remove-Item $p -Force -ErrorAction SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ROUND_VPS.ps1?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $p -ErrorAction Stop; if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ROUND_VPS_v2' -Quiet)){ throw 'SCRIPT VECCHIO: manca MARCATORE_RIGA_ROUND_VPS_v2' }; Write-Host 'BERSAGLIO: il solo MT5 di questo PC, C:\Program Files\BCM Markets MT5 Terminal, demo 50503392. Tutto il resto (challenge FTMO 541452707, 100k 50504263, REALE 10105439, Pepperstone, Tickmill, banco 50504400) sta su una macchina diversa e questa riga non la raggiunge.' -ForegroundColor Cyan; $mt=@(Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id,MainWindowTitle,Path); Write-Host '--- MT5 APERTI SU QUESTA MACCHINA (PID / titolo / cartella) ---'; $mt | Format-Table -AutoSize; if(@($mt | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') }).Count -gt 0){ throw 'MT5 E APERTO: chiudilo A MANO (il PID sta nella tabella qui sopra), dopo aver guardato che non abbia EA attaccati, poi reincolla la riga. Non lo chiudo io: quel terminale e loggato sul demo 50503392 e da questa macchina il 14/08 sono partiti ordini veri.' }; Write-Host '=== ROUND R205A   EA ABTG_DAX_Apertura_EU   D30EUR M5   tick reali   deposito 80000   2 celle x 2 gambe ===' -ForegroundColor Cyan; $a=@('-NoProfile','-ExecutionPolicy','Bypass','-File',('"'+$p+'"'),'-Expert','ABTG_DAX_Apertura_EU','-Prova','R205a_lato_corto_DAX_D30EUR.txt','-Etichetta','R205A','-Pin',$pin,'-TerminaleBacktest','"C:\Program Files\BCM Markets MT5 Terminal"','-Modello','4','-Deposito','80000'); $pr=Start-Process powershell -ArgumentList $a -NoNewWindow -PassThru; if(-not $pr.WaitForExit($tmo*60*1000)){ Write-Host ('TETTO DI ' + $tmo + ' MINUTI SFONDATO: fermo il round. E UN RISULTATO, NON UN GUASTO: il referto che resta e PARZIALE.') -ForegroundColor Red; Stop-Process -Id $pr.Id -Force -ErrorAction SilentlyContinue; Get-Process metatester64,terminal64 -ErrorAction SilentlyContinue | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') } | Stop-Process -Force -ErrorAction SilentlyContinue; try{ $pr.WaitForExit() }catch{}; Start-Sleep -Seconds 10 }; $rc=$pr.ExitCode; if($null -eq $rc){ $rc='NON LEGGIBILE' }; Write-Host ('   esito R205A: codice ' + $rc + '   (0=GIRATO  2=NON MISURATO  3=GIRATO CON RILIEVI  1=non e partito)') -ForegroundColor Yellow; $d="$dsk\ROUND_R205A"; if(-not (Test-Path $d)){ Write-Host 'MANCA la cartella ROUND_R205A sul Desktop: il round NON ha prodotto raccolta.' -ForegroundColor Red } else { Compress-Archive -Path "$d\*" -DestinationPath "$dsk\ROUND_R205A.zip" -Force; Write-Host 'ZIP PRONTO DA MANDARE: Desktop\ROUND_R205A.zip' -ForegroundColor Green }; Write-Host 'FILE ATTESI NELLO ZIP (4):' -ForegroundColor Gray; Write-Host '   REFERTO_ROUND_R205A.txt' -ForegroundColor Gray; Write-Host '   ABTG_DAX_Apertura_EU_D30EUR_IS_R205A.csv' -ForegroundColor Gray; Write-Host '   ABTG_DAX_Apertura_EU_D30EUR_OOS_R205A.csv' -ForegroundColor Gray; Write-Host '   R205a_lato_corto_DAX_D30EUR.txt' -ForegroundColor Gray; Write-Host 'NEL REFERTO LEGGI LA RIGA  data:  -- DEVE ESSERE DI OGGI, altrimenti stai guardando un file vecchio.' -ForegroundColor Yellow; if(Test-Path $d){ Get-ChildItem $d -Recurse -File | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize } }
```

📅 **Quale data deve leggere Claudio**: dentro `REFERTO_ROUND_R205A.txt`, la riga che comincia
con **`data            :`**. Il 17/08 un referto stantio è stato rimandato **due volte** in
buona fede: si guarda quella riga **prima** di leggere i numeri.

---

## ② 📐 IL TETTO DELLE ~100.000 BARRE — **misurato, non stimato**

Nessuna stima: **lo stesso EA, lo stesso simbolo, lo stesso M5, la stessa identica finestra**
(`@DAQUANDO 2024.09.26`, `@FINOA 2026.06.30`, `@FRAZIONEIS 0.40`) è già girato **il 21/09** e il
referto riporta `tetto barre : MaxBars=100000000`. Il pre-volo della classe 160 muore solo se
`MaxBars` sta **fra 1.000 e 200.000**: qui è cento milioni, quindi passa.
🟢 E le due corse sono **separate** (`walkforward_generico.ps1` r.931-938): il tetto vale **per
corsa**, non per il round.

---

## ③ ⏱️ IL TETTO DI TEMPO — **120 minuti, ed è un TETTO, non una stima**

🟠 **Dichiaro quello che non so.** `R202B` gira **8 passate** con la stessa geometria; questo ne
gira **4**. **Se** il costo fosse proporzionale, siamo sotto i 5 minuti. ⚠️ **Ma non ho un
cronometro sulle passate di R202B** — il referto dà l'avvio, non la durata per passata — quindi
**non lo uso come stima**: tetto **largo**, che serve solo a impedire che un tester appeso resti
lì per sempre.

⚠️ **Se il tetto scatta NON è un successo** (checklist p.19): la riga lo dice in rosso e il
referto che resta è **PARZIALE**.
🔴 **La chiusura d'emergenza è chirurgica e su una COSTANTE**: `Stop-Process` colpisce solo
`metatester64`/`terminal64` il cui `Path` sta sotto `C:\Program Files\BCM Markets MT5 Terminal\`
— **stringa letterale dentro la riga, nessuna variabile che arrivi da fuori** — su una macchina
dove quello è l'unico MT5 e che la riga ha **già verificato chiuso** prima di partire.

---

## ④ 🚦 IL CANCELLO — **due strati**

**Strato 1 (deterministico)**
- `controlla_prova.py` sul file prova → **verde** (90 pin, **2 celle**, 4 passate, **0 problemi**).
- `controlla_riga.py --oggetto md` su questo file → **verde**.
- **Parser PowerShell** sulla riga: **0 errori**. **Una sola riga fisica** (classe 538),
  **zero caratteri non-ASCII**.
- 🟠 **Il cancello ha già morso una volta, ed è servito**: il primo asse era
  `false||false||1||true||Y` e `controlla_prova.py` l'ha **rifiutato** («asse non numerico»).
  Corretto in `0||0||1||1||Y`, la convenzione di casa — e la nota di sintassi è finita **dentro
  il file prova**, così non la si ripaga.

**Contro-esempi tenuti, non raccontati**
- La riga è confrontata **parola per parola** con la riga **già approvata** di `R172E`: le
  **uniche** differenze sono `pin`, etichetta `R205A`, EA `ABTG_DAX_Apertura_EU`, simbolo
  `D30EUR`, numero di celle `2`, nome del file prova e nomi dei file attesi. Nient'altro.
- Il file prova è verificato **per differenza** contro `R202b`: cambiano **DUE righe e basta**
  (`InpTP1_R` da asse a pin `1.0`, `InpAllowShort` da pin ad asse); direttive `@` **identiche**,
  **90 pin** prima e dopo. Diff fatto con `[A-Za-z0-9_]+=` — **con la cifra dentro la classe**,
  perché il pattern senza cifre è il modo esatto in cui il 21/09 mi ero reso `InpTP1_R`
  invisibile al mio stesso controllo.
- **Due puntatori corretti alla fonte invece che copiati**: lo SL corto è **r.1974** (`sl = buyPx`)
  e lo slot è **r.887-899** (`case PH_PLACED`), **non** la `r.257` che scrive il censimento
  (è un enum). Aperti con `sed`, non citati a memoria.
- Le basi del cancello `c2` sono **ricalcolate dai CSV di R202B**, non riportate dal verdetto:
  IS `3050,56 / 0,65219 / 80000 = 5,8468%`, OOS `14355,32 / 2,01544 / 80000 = 8,9033%`.
- Gli URL del pin (driver + file prova) rispondono **200**, verificato **dopo** l'ultimo commit.

**🕳️ Cosa resta NON coperto, e va detto**
- 🔴 **R42 e R43 non sono stati riaperti nei file prova** per confermare che misurassero FADE e
  RIMBALZO e non RETEST. È l'unica cosa che potrebbe rendere questo round una ripetizione.
- Che il `.ex5` sul PC di backtest corrisponda ai `.mq5` letti qui: il driver ricompila dal pin,
  ma **non l'ho misurato** — e questa famiglia ha già avuto scarti sorgente/binario
  (`ABTG_EMA200`, 690 righe contro 486 in campo).
- Lo stop mediano del **lato corto** è `[NON MISURATO]`: la simmetria è garantita dalla
  geometria, il campione in forward è solo long (`[MIS n=3]` / `[MIS n=8]`).
