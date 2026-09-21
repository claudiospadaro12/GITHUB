# 🚀 R203A — IL PAVIMENTO DELLO STOP SUL DAX, sedia `770101`

**21/09/2026** · branch `lavoro` · pin della riga: **`a774bb3be82a4ce52bcd27eb5614d6d29e672a33`**
File prova: `backtest_pipeline/prove/R203a_pavimento_stop_DAX_D30EUR.txt` (90 pin, **4 celle**)
— **i cancelli (a)-(f) e (c1)-(c3) sono quelli congelati in quel file** (classe 549).

> 📌 **Nota d'archivio**: il **file prova** sta al pin `a774bb3be82a4ce52bcd27eb5614d6d29e672a33`
> — che è quello che il driver scarica. Questo **documento** è stato riscritto **tre volte**:
> chi lo riaprisse da un pin precedente leggerebbe una stesura vecchia.

> 🔴 **CATENA DELLE STESURE** (non un contatore a mano — classe 554):
> `89f222bf` → `4bc9aa97` → `018c1d95` → `20d168b2` → **questa**. Il cancello ha risposto
> **FAIL su tutte e quattro le precedenti**: 1º giro la **scala** e una «conferma» che era in
> realtà **la firma del difetto**; 2º giro **i cancelli stessi**; 3º giro **H0 non esaustiva** e
> una **divisione per zero**; 4º giro la partizione era finita **solo nel file prova** mentre
> questo documento **ne certificava la correzione** tenendo la versione vecchia.
> 🟢 **L'asse e la riga PowerShell non sono più stati in discussione dal secondo giro in poi.**
> E i criteri **si cambiano prima dei numeri, non dopo** (emendamento del 16/08): per questo si
> correggono adesso e non dopo la corsa.

---

## 🟢 COSA MISURA, IN UNA RIGA

> **Asse unico `InpMinStopPts`: `0` → `2875` → `5750` → `8625` punti EA, con
> `InpSkipIfTight=true` (come in campo), cioè il pavimento NON allarga lo stop: **scarta il
> trade**.**
>
> 🔴 **Il fatto che apre la porta, ed è un CENSIMENTO COMPLETO, non un campione**: sul DAX
> il **pavimento dello stop è SPENTO** — `InpMinStopPts=0.0` in
> `mql5/Presets/FTMO/ABTG_DAX_Apertura_EU_770101_FTMO.set` r.294, contro **500.0** sul Dow
> (r.309) e sul Nasdaq (r.376).
> In **`mql5/Experts/ABTG_DAX_Apertura_EU.mq5`** (2885 righe) `InpMinStopPts` compare **sette**
> volte (r.1202, 1226, **1279**, 1435, 1543, 1935, 1978); `InpSkipIfTight` compare **sei**
> volte, e **ognuna delle sei sta dentro il corpo di un `if(InpMinStopPts > 0 && ...)`**.
> → **Con il pavimento a 0 non esiste un solo ramo in cui `SkipIfTight` morda.** Il round
> **accende un meccanismo mai operato su questa sedia**. Non è un ritocco: è una porta.

### 📏 LA SCALA VIENE DA UNO STUDIO CON GEOMETRIA DIVERSA — **e va detto** (classe 551)

La fonte è `risultati_archivio/studio_apertura/Studio_D30EUR.csv`, **440 breakout veri**. Ma:

| scostamento | Studio | sedia viva | conta? |
|---|---|---|---|
| **minuti del range** | `InpRangeMinutes=15` (`studio_apertura.ps1` **r.131**) | **35** | 🔴 **SÌ, è la variabile stessa** |
| lati | LONG + SHORT (440) | **LONG-only** (`InpAllowShort=false`) | 🔴 **SÌ**: i giorni LONG sono **più stretti** (media 5921 contro 6254) → popolazione giusta = **225** |
| buffer | 200 | 500 | sull'ampiezza no, sullo **stop** sì |
| `TP_R` | 2,0 | `InpTP1_R × 3` | no |

🟠 **La correzione di casa è ×√(35/15) = 1,5275, ed è `[INF]`** — è la **legge di casa** nominata a
`report/STOP_VS_SPREAD_FTMO_2026-09-20.md` **r.241** (`ANCORA_ADR_FLOTTA_INDICI`) e usata alle
**r.276** e **r.278**, **calibrata a n=8** — etichetta corretta **`[INF, calibrato n=8]`**.
🟠 *(Non la **r.271-272**, che avevo citato nelle prime due stesure: **r.271 è vuota** e r.272
è l'intestazione della tabella. Quel puntatore me l'aveva dato il cancello e l'avevo copiato in
buona fede — classe **553**.)*
🟢 **E lo stop vero è calcolabile, non vago**: retest long con `InpSLMode=0` dà
`entry = High − 200`, `sl = Low − 500`, quindi **stop = ampiezza + 300 pt esatti**.

### 💸 IL COSTO DI OGNI GRADINO — **una BANDA, non un numero**

Popolazione: i **225 giorni LONG**, stop = ampiezza + 300. Spread mediano BCM ora 08 = **1,70**.

| cella | idx | × spread | 🎯 scarto **`[INF, calibrato n=8]` 35'** — **il numero da usare** | | *scarto 15' crudo* — 🔴 `[BATTUTA: 24,5 pp di errore]` |
|---|---:|---:|---:|---|---:|
| **`0`** ← viva | — | spento | 0,0% | | 0,0% |
| `2875` | 28,8 | **16,9×** | 3,1% | … | 13,3% |
| `5750` | 57,5 | 33,8× | 28,9% | … | 54,2% |
| `8625` | 86,2 | 50,7× | 54,2% | … | 83,6% |

🔴 **LA BANDA NON È SIMMETRICA: l'estremo crudo è GIÀ STATO FALSIFICATO.** `STOP_VS_SPREAD`
**r.252-262** calibra le due letture contro le **8 gambe forward vere** del `770101`:
**misurato 25,0%** · predetto a **35' → 26,1%** (scarto **1,1 punti**) · predetto a **15' crudo
→ 49,5%** (scarto **24,5 punti**).
👉 **Il numero da usare è quello a 35'.** Il 15' crudo resta come traccia del calcolo ed è
**la geometria sbagliata**: non è l'altro estremo di una banda, è **un'ipotesi già battuta**.

### ⚓ PERCHÉ QUESTI TRE GRADINI — ognuno è **un numero già scritto in casa**

`report/STOP_VS_SPREAD_FTMO_2026-09-20.md` **r.246** porta la distribuzione dello **STOP** del
`770101` nella lettura a 35': **min 19,80 · P10 39,49 · MEDIANA 86,48**; e la **frontiera FTMO
è 57,2**. Le tre celle fanno **tre domande diverse**:

| cella | idx | coincide con | la domanda |
|---|---:|---|---|
| `2875` | 28,75 | fra il **minimo** (19,80) e il **P10** (39,49) | *taglio solo la coda stretta?* |
| `5750` | 57,50 | 🎯 **la FRONTIERA FTMO** (57,2), a meno dello **0,5%** | *taglio tutto ciò che sta sotto la frontiera del costo?* |
| `8625` | 86,25 | 🎯 **la MEDIANA** dello stop a 35' (86,48), a meno dello **0,3%** | *tengo solo la metà larga?* |

🟠 **E la versione precedente di questa giustificazione era una razionalizzazione**: avevo
scritto che i due gradini alti *«abbracciano la frontiera, e questo dice più che atterrarci
sopra»* — un principio **inventato per l'occasione**. Il motivo vero è quello qui sopra, ed è
fatto di **numeri di altri**. Il gradino a `2300` resta fuori perché scartava lo **0,4-5,3%**:
quasi un **no-op**. ⚠️ Il vincolo è reale: l'asse del driver ha **passo uniforme**, quindi con
4 celle non si può avere **insieme** un primo gradino che morde e l'atterraggio sui 6800 della
frontiera calcolata sullo spread BCM.

### 🎯 LA BARRA, E IL CONFRONTO È TUTTO **INTERNO AL ROUND** (classe 515)

| | cancello | come si misura, e perché così |
|---|---|---|
| **c1** | 🎯 `DD_fisso OOS ≤ 7,12` (−20% sugli **8,9033** della cella `0`) | 🔴 **NON su `Equity DD %`**, che divide per il **picco** — e il picco **cambia da cella a cella**: una cella ad alto pavimento fa meno profitto, ha un picco più basso, e **lo stesso drawdown in euro le esce come percentuale più alta**. La misura è `(Profit / Recovery Factor) / 80000 × 100`: **due colonne già nel CSV, costo zero**. `Equity DD %` si riporta, ma **non decide** |
| **c2** | ⚠️ **non è più un cancello: è un numero da riportare** | il tester divide per l'**equity d'inizio giornata** (`ABTG_DAX_Apertura_EU.mq5` **r.759**), il MDL FTMO è il 5% del **capitale iniziale**: mobile contro fisso, **classe 515 in scala giornaliera** (fattore ≤ **1,228**). E il 5% è **del conto**, dove operano **sei** sedie: fissare la quota per sedia è un **parametro di rischio**, cioè **di Claudio** |
| **c3** | 🔴 **il muro del 10% NON si giudica qui** | `Equity DD %` è **dal picco**, il Max Loss FTMO è **statico dal saldo iniziale**. 🟢 **Ma un limite superiore rigoroso il CSV lo dà**: `perdita_statica ≤ DDass / deposito` — cella viva OOS **8,90%** al banco, **≤ 17,8%** a taglia vera |
| **d** | `PF OOS ≥ 1,20` | 🟢 **fonte: `risultati_archivio/R98_CRITERI.md` r.194, cancello S2, «opzione A (FIRMATA)», decisa da Claudio il 22/08 PRIMA dei numeri.** Per **questo** motore è **larga** (la cella viva fa 1,39520): è un **pavimento riusato**, e il cancello che morde qui è **c1** |

### 🔬 IL NUMERO CHE HA FATTO CAMBIARE `c1` — misurato sull'ancora R202B OOS

| cella | `Equity DD %` (dal picco) | DD assoluto (EUR) | **DD / 80.000** | picco implicito |
|---|---:|---:|---:|---:|
| `0.25` | 4,8467 | 4.300,85 | **5,3761%** | 88.738 |
| `0.50` | **7,7631** | **7.127,62** | 8,9095% | 91.814 |
| `0.75` | **7,5746** | **7.144,81** | 8,9310% | 94.326 |
| `1.00` ← viva | 7,2506 | 7.122,67 | **8,9033%** | 98.236 |

🔴 **Due fatti che chiudono la questione.** (i) Fra `0.50` e `0.75` **l'ordine si ribalta**:
dal picco la `0.75` sembra migliore (7,5746 < 7,7631), **in euro è peggiore** (7.144,81 >
7.127,62). (ii) Per la cella viva lo scarto fra le due letture è **+22,8%**, cioè **più grande
del −20% che il cancello chiede**. Un cancello con la barra d'errore più larga del margine
**non decide niente** (classe 550).

🟠 **`[DA CONFERMARE]`**: se il `Recovery Factor` di MT5 usi il balance-drawdown o
l'equity-drawdown. Su tutte e 8 le passate il picco implicito cade fra **88.738 e 98.236**,
sempre sopra il deposito e sotto l'equity finale: **coerente** con l'equity drawdown. Coerente
non è dimostrato.

🔴 **E IL NUMERO SCOMODO DI `c3`**: il limite superiore della perdita statica della cella
viva è **≤ 17,8%** a taglia vera, e **supera il muro del 10%**. Il round quindi **non certifica
che la sedia sia al sicuro** e **non certifica che sfondi**: giudizio **sospeso in tutte e due
le direzioni**, con questo numero accanto.

⚠️ **E il ×2 per la taglia vera è un LIMITE SUPERIORE, non un'identità**: `CalcLotByRisk()` usa
`ACCOUNT_BALANCE`, quindi il DD composto a 2,0% sta un filo **sotto** il doppio di quello a
1,0% (5 SL di fila: **9,608** contro `2 × 4,901 = 9,802`).

### 🧪 LA CONTRO-IPOTESI — **la partizione sta nel file prova, qui c'è solo la mappa**

> **H0**: il pavimento taglia `n` e profitto **senza** migliorare il DD.
>
> 🔴 **La regola che decide sta in `backtest_pipeline/prove/R203a_pavimento_stop_DAX_D30EUR.txt`,
> sezione «LA CONTRO-IPOTESI». Qui non si riscrive** (classe 549: un cancello si numera **una
> volta sola**; classe 554: due copie divergono, e divergono **in silenzio**). Questa è una
> **mappa di lettura**, per non riaprire il file mentre si guarda il referto:

| classe | `DD_fisso OOS` | cosa vuol dire |
|---|---|---|
| **A** | ≤ 7,12 | H0 **falsificata** · cella **candidata** se `PF ≥ 1,20` |
| **B** | 7,12 < x < 8,46 | H0 **falsificata lo stesso** · 🎯 **«asse giusto, gradino sbagliato»** → più risoluzione, **l'asse NON si archivia** |
| **C** | 8,46 ≤ x ≤ 9,35 | H0 **confermata** su quella cella |
| **D** | > 9,35 | il pavimento **peggiora** il DD · risposta **pulita**: chiude l'asse |
| **E** | `Trades = 0` / `[NON CALCOLABILE]` | 🔴 **cella senza misura**, fuori da A-D — e **sembra la più bella di tutte** |

⚠️ **Le soglie normative sono i RAPPORTI** (`−20% → 7,12264`, `−5% → 8,45813`,
`+5% → 9,34847`), non gli arrotondamenti a due decimali della tabella.

🔴 **E LA CLASSE E È IL TRANELLO DEL ROUND, verificato su una riga vera d'archivio**
(`ABTG_OpeningReversalB_U30USD_OOS_P0CONTA.csv`): una passata a **zero trade** esce con
`Profit 0.00 · PF 0.00000 · RF 0.00000 · Equity DD % 0.0000 · Peggior Giornata % 0.0000`.
Su **tre delle quattro colonne di rischio è la cella più bella della tabella**, e chi
classifica sul DD la mette in **A** — *«miglioramento del 100%!»*.
👉 **Non è un pavimento che ha azzerato il drawdown: è un pavimento che ha azzerato i
trade.** È il *«verde per caso»* del 19/08 nella forma più pulita, e sulla cella `8625` è
uno scenario **plausibile**. Se la cella `E` è **l'unica a «migliorare»**, il verdetto è
**«serve un gradino più basso»**, mai *«il gradino alto vince»*.

⚠️ **E il driver NON lo marca da solo con `rc=2`** — correzione a una frase sbagliata della
stesura precedente: `RIGA_ROUND_VPS.ps1` **r.342** dà `NON MISURATO`/rc=2 **solo se TUTTE** le
righe hanno `Trades=0`; con una cella vuota su quattro scatta la **r.346**, che scrive
*«LETTO, ma 1 righe su 4 hanno Trades = 0»* e lascia il codice a **0 o 3**. L'avviso c'è, il
codice d'uscita no: **si legge il referto, non il codice.**

🔴 **E QUESTO ROUND PRODURRÀ CELLE NON MISURABILI PER IL MERITO — dichiarato prima.**
L'emendamento del 16/08 chiede **IS ≥ 150 OPERAZIONI**; `STAT_TRADES` conta le **USCITE**, e col
parziale al 50% una posizione ne fa fino a due: le **posizioni** IS della cella `0` stanno fra
**88 e 175**, quindi **potrebbe non arrivarci nemmeno la cella viva**. Per le celle alte il
**MERITO è SOSPESO** («non ancora misurato», mai «peggiore») — 🟢 **ma il RISCHIO si giudica
lo stesso, a qualunque `n`** (regola B del 16/08): *«il pavimento NON abbassa il DD»* è un
contributo valido anche con campione sottile.

---

## ① 🖥️ DOVE MANDARE QUESTA STRINGA

> ## 🖥️ **finestra PowerShell sul PC DI BACKTEST `DESKTOP-H4D7CAJ`** (utente `Master`).
> **Bersaglio: l'unico MT5 di quella macchina, `C:\Program Files\BCM Markets MT5 Terminal`, demo `50503392`.**
>
> 🔴 **COSA NON VIENE TOCCATO.** Tutto ciò che vive **sul VPS**: la challenge **FTMO `541452707`**
> (`C:\FTMO`, **sei sedie che stanno operando**), il **100k `50504263`**, il **REALE `10105439`**
> (`C:\BCM_Reale`), il piccolo `50503392` del VPS, Pepperstone, Tickmill, e il banco `50504400`
> (`C:\MT5_Backtest`, **spento**). È **un'altra macchina**, e il `throw` è il **primo statement
> dopo `$pin`** — muore **prima** di scaricare qualunque cosa.
>
> ✋ **PRIMA DI INCOLLARE: chiudi MT5 sul PC di backtest.** Se lo trova aperto stampa PID +
> titolo + cartella e **si ferma**: quel terminale è loggato sul demo vivo `50503392` e il
> **14/08/2026** da quella macchina sono partiti **ordini veri**.

```powershell
& { $ErrorActionPreference='Stop'; $pin='a774bb3be82a4ce52bcd27eb5614d6d29e672a33'; if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('VIETATO: questa riga gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama ' + $env:COMPUTERNAME + '. Sul VPS operano le sei sedie della challenge FTMO e un backtest a tick reali lo inchioda: firma di Claudio del 21/09.') }; $w="$env:USERPROFILE\abtg_round"; $p="$w\RIGA_ROUND_VPS.ps1"; $dsk=[Environment]::GetFolderPath('Desktop'); $tmo=120; New-Item -ItemType Directory -Force -Path $w | Out-Null; Remove-Item $p -Force -ErrorAction SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ROUND_VPS.ps1?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $p -ErrorAction Stop; if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ROUND_VPS_v2' -Quiet)){ throw 'SCRIPT VECCHIO: manca MARCATORE_RIGA_ROUND_VPS_v2' }; Write-Host 'BERSAGLIO: il solo MT5 di questo PC, C:\Program Files\BCM Markets MT5 Terminal, demo 50503392. Tutto il resto (challenge FTMO 541452707, 100k 50504263, REALE 10105439, Pepperstone, Tickmill, banco 50504400) sta su una macchina diversa e questa riga non la raggiunge.' -ForegroundColor Cyan; $mt=@(Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id,MainWindowTitle,Path); Write-Host '--- MT5 APERTI SU QUESTA MACCHINA (PID / titolo / cartella) ---'; $mt | Format-Table -AutoSize; if(@($mt | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') }).Count -gt 0){ throw 'MT5 E APERTO: chiudilo A MANO (il PID sta nella tabella qui sopra), dopo aver guardato che non abbia EA attaccati, poi reincolla la riga. Non lo chiudo io: quel terminale e loggato sul demo 50503392 e da questa macchina il 14/08 sono partiti ordini veri.' }; Write-Host '=== ROUND R203A   EA ABTG_DAX_Apertura_EU   D30EUR M5   tick reali   deposito 80000   4 celle x 2 gambe ===' -ForegroundColor Cyan; $a=@('-NoProfile','-ExecutionPolicy','Bypass','-File',('"'+$p+'"'),'-Expert','ABTG_DAX_Apertura_EU','-Prova','R203a_pavimento_stop_DAX_D30EUR.txt','-Etichetta','R203A','-Pin',$pin,'-TerminaleBacktest','"C:\Program Files\BCM Markets MT5 Terminal"','-Modello','4','-Deposito','80000'); $pr=Start-Process powershell -ArgumentList $a -NoNewWindow -PassThru; if(-not $pr.WaitForExit($tmo*60*1000)){ Write-Host ('TETTO DI ' + $tmo + ' MINUTI SFONDATO: fermo il round. E UN RISULTATO, NON UN GUASTO: il referto che resta e PARZIALE.') -ForegroundColor Red; Stop-Process -Id $pr.Id -Force -ErrorAction SilentlyContinue; Get-Process metatester64,terminal64 -ErrorAction SilentlyContinue | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') } | Stop-Process -Force -ErrorAction SilentlyContinue; try{ $pr.WaitForExit() }catch{}; Start-Sleep -Seconds 10 }; $rc=$pr.ExitCode; if($null -eq $rc){ $rc='NON LEGGIBILE' }; Write-Host ('   esito R203A: codice ' + $rc + '   (0=GIRATO  2=NON MISURATO  3=GIRATO CON RILIEVI  1=non e partito)') -ForegroundColor Yellow; $d="$dsk\ROUND_R203A"; if(-not (Test-Path $d)){ Write-Host 'MANCA la cartella ROUND_R203A sul Desktop: il round NON ha prodotto raccolta.' -ForegroundColor Red } else { Compress-Archive -Path "$d\*" -DestinationPath "$dsk\ROUND_R203A.zip" -Force; Write-Host 'ZIP PRONTO DA MANDARE: Desktop\ROUND_R203A.zip' -ForegroundColor Green }; Write-Host 'FILE ATTESI NELLO ZIP (4):' -ForegroundColor Gray; Write-Host '   REFERTO_ROUND_R203A.txt' -ForegroundColor Gray; Write-Host '   ABTG_DAX_Apertura_EU_D30EUR_IS_R203A.csv' -ForegroundColor Gray; Write-Host '   ABTG_DAX_Apertura_EU_D30EUR_OOS_R203A.csv' -ForegroundColor Gray; Write-Host '   R203a_pavimento_stop_DAX_D30EUR.txt' -ForegroundColor Gray; Write-Host 'NEL REFERTO LEGGI LA RIGA  data:  -- DEVE ESSERE DI OGGI, altrimenti stai guardando un file vecchio.' -ForegroundColor Yellow; if(Test-Path $d){ Get-ChildItem $d -Recurse -File | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize } }
```

📅 Dentro `REFERTO_ROUND_R203A.txt`, la riga **`data            :`** deve essere del giorno
in cui lo lanci.

---

## ② 📐 IL TETTO DELLE BARRE — **misurato**

Stesso EA, stesso simbolo, stesso M5, **stessa identica finestra** di `R202B`, girato **il
21/09 alle 23:27**: il referto riporta `tetto barre : MaxBars=100000000`. Il pre-volo della
classe 160 muore solo fra 1.000 e 200.000. Passa.

## ③ ⏱️ IL TETTO DI TEMPO — **120 minuti, ed è un TETTO**

`R202A` e `R202B` sono partiti **il 21/09 alle 23:24:38 e alle 23:27:19**, **4 celle × 2 gambe
ciascuno**: **2 minuti e 41 secondi** fra i due avvii.
⚠️ **È una durata SOLO se le due corse sono state sequenziali**; se fossero state lanciate in
parallelo quel numero non misura niente, e il tetto resta prudenziale. In ogni caso il margine
è **~45×**, e se il tetto scatta **non è un successo**: il referto che resta è **PARZIALE**.

---

## ④ 🚦 IL CANCELLO — **strato 2 ha risposto FAIL, e i difetti sono corretti qui dentro**

| # | difetto | correzione |
|---|---|---|
| **B1** | 🔴 **classe 515, TERZA occorrenza**: la barra confrontava `Equity DD %` (dal picco) col muro FTMO (statico dal saldo iniziale) | spezzata in **c1 / c2 / c3** qui sopra |
| **B2** | 🔴 **classe nuova 551**: la scala veniva da uno Studio a `InpRangeMinutes=15` mentre la sedia gira a **35**, su **440** righe invece delle **225** LONG | tabella degli scostamenti + quote come **banda** `[INF]..[MIS]` + **asse spostato** a `0/2875/5750/8625` |
| **B3** | 🔴 **classe nuova 552**: la «conferma incrociata a 0,5%» era **algebricamente impossibile** (ampiezza 15' contro stop = ampiezza 35' + 300), quindi non confermava: **era la firma di B2** | tolta e sostituita con l'allarme |
| R1 | soglia `PF ≥ 1,20` senza fonte | 🟢 **rilievo NON accettato, e verificato prima di rifiutarlo**: l'agente sosteneva che 1,20 *«non esiste in nessun documento»*. **Falso** — `R98_CRITERI.md` r.194, firmata da Claudio il 22/08. Soglia **confermata**, fonte **citata** |
| R2 | contro-ipotesi non falsificabile | due insiemi numerici + «non deciso» dichiarato prima |
| R3 | celle non misurabili non dichiarate | dichiarate, con la distinzione **merito sospeso / rischio no** |
| R4-R10 | date relative, puntatori senza file, `2:41` senza clausola, magic | tutti applicati |

**Terzo giro** — il cancello ha bocciato **i cancelli**, non il round:

| # | difetto | correzione |
|---|---|---|
| **C1** | `c1` **non era omogeneo**: `Equity DD %` divide per un picco che cambia da cella a cella, e la distorsione (**+22,8%**) è **più grande del margine del cancello** (−20%) | `c1` passa al **denominatore fisso** `(Profit/RF)/80000`, soglia **≤ 7,12** |
| **C2** | `c2` era un **515-bis** (denominatore mobile, fattore ≤ 1,228) **e** metteva un tetto **per sedia** uguale al tetto **di conto**, con sei sedie sopra: protezione **zero** | **declassato a numero da riportare**; la quota per sedia è un **parametro di rischio → Claudio** |
| **C3** | `c3` era **troppo pessimista**: un limite superiore rigoroso il CSV lo dà | aggiunto **≤ 17,8%** a taglia vera → **doppia sospensione** |
| **C4** | la giustificazione dell'asse era una **razionalizzazione** | riscritta sui **tre ancoraggi veri** (min/P10 · frontiera FTMO 57,2 · mediana 86,48) |
| **C5** | la **banda** trattava i due estremi come equivalenti, ma il 15' crudo è **già falsificato** | dichiarato: il numero da usare è quello a **35'** |
| **C6** | 🔴 **puntatore `r.271-272` sbagliato** (r.271 è vuota) — **arrivato dal cancello stesso** e copiato in buona fede | → **r.241** (+ r.276, r.278). **Classe nuova 553** |

**Quarto giro** — due difetti, **tutti e due dentro le toppe del terzo**:

| # | difetto | correzione |
|---|---|---|
| **D1** | 🔴 **H0 aveva due buchi.** L'intervallo `7,12-8,46` era etichettato «non deciso», ma lì dentro il pavimento **abbassa il DD del 5-20%**: H0 è **falsificata** e il verdetto è *«asse giusto, gradino sbagliato»* — **la risposta più utile che il round può dare**, che sarebbe finita in archivio come indecisione. E **non esisteva nessun ramo** per «il pavimento **peggiora** il DD», che è invece una risposta pulita | H0 diventa una **partizione esaustiva A\|B\|C\|D** letta **cella per cella**. La parola «non deciso» **sparisce**: copriva un buco di scrittura |
| **D2** | 🔴 **`c1` è indefinito a zero trade.** `(Profit/RF)` con `Profit=0` e `RF=0` è **0/0** | misurato su **16.649 righe** d'archivio: **8.641** hanno `Profit<0 e RF<0` e la formula **regge**; **0** hanno `RF=0` con profitto negativo; **3.379** sono a `Profit=0`. Ora: si guarda `RF` **prima** di dividere, si scrive **`[NON CALCOLABILE DAL CSV]`**, e il driver marca già quel caso da solo (`NON MISURATO`, rc=2) |
| **D3** | il file prova diceva ancora «SECONDA STESURA» mentre questo diceva «TERZA» — **classe 549** | intestazione allineata |

**Quinto giro** — e il difetto peggiore della serie:

| # | difetto | correzione |
|---|---|---|
| **E1** | 🔴 **la partizione `A\|B\|C\|D` era finita SOLO nel file prova.** Questo documento teneva la H0 vecchia col «NON DECISO» — **e ottanta righe più sotto certificava di averla corretta.** Con una cella a `8,00` i due documenti davano **verdetti opposti**, e quello perso era **il più utile** | 🔴 **qui la H0 non si riscrive più**: rimando al file prova + **mappa** marcata come tale. **Classe nuova 554** |
| **E2** | 🔴 **mancava la classe E**: una cella a **zero trade** esce con `DD 0,0000` e `Peggior Giornata 0,0000` — **la più bella della tabella** — e chi classifica sul DD la mette in **A** | classe **E** introdotta, col tranello scritto e verificato su una riga vera |
| **E3** | avevo scritto che il driver marca quel caso con **`rc=2`**: **falso** (r.342 vs r.346) | corretto: *si legge il referto, non il codice* |
| **E4** | le soglie avevano **due letture** (rapporti vs arrotondamenti), con due micro-bande discordanti | **valgono i rapporti** |
| **E5** | «TERZA STESURA» **stale di uno per la terza volta in quattro giri** | → **catena dei pin**: non può invecchiare in silenzio |

🟢 **E il controllo che non avevo fatto, ora c'è**: il metro nuovo (`DD_fisso`) è
**strutturalmente più permissivo** per le celle a basso profitto — cioè proprio quelle che il
round vuole promuovere. *«Abbiamo cambiato il righello e ora passano più celle»* non deve mai
passare senza esame. **L'esame**: sulle uniche celle dove esistono tutti e due i numeri, il
cancello a −20% passa **solo la `0.25`** con **tutti e due** i righelli. **Stesso esito, 1 su
4: ha tolto un bias, non abbassato l'asticella.**

**Strato 1 dopo le correzioni**
- `controlla_prova.py` → **verde** (90 pin, 4 celle, 0 problemi) · **zero** non-ASCII · **zero**
  parole di tempo relative.
- `controlla_riga.py --oggetto md` → **verde** · **Parser PowerShell**: **0 errori** · **una
  sola riga fisica** (classe 538).
- URL del pin (driver + file prova) → **200**.

**🕳️ Non coperto, e dichiarato**
- Il fattore **√(35/15) è `[INF]`**, non misurato. 🟢 **La via più corta al numero c'è**: una
  corsa di `studio_apertura.ps1` con `InpRangeMinutes=35` sul PC di backtest **farebbe sparire
  del tutto** il difetto B2. Costa una corsa, ed è la proposta per il giro dopo.
- La mappa **giorni-dello-Studio → trade-dell'EA** è **assunta**, non misurata: lo Studio entra
  a buffer 200 e non chiede che il retest si **riempia**, la sedia sì.
- Il rapporto **uscite/posizioni** non è misurato: ogni `n` di questo referto è **`[uscite]`**.
- La **minima equity contro il saldo iniziale** — l'unica misura che **deciderebbe** il muro
  del 10% — **non c'è**: serve il report HTML per passata. 🟠 **Ma un LIMITE SUPERIORE
  rigoroso sì**: `(Profit/RF)/deposito` → cella viva **8,90%** al banco, **≤ 17,8%** a taglia
  vera, cioè **sopra il muro del 10%**. Il giudizio resta **sospeso in tutte e due le
  direzioni**, non è «non misurabile».
- `InpMagic` della prova è **789521**, quello in campo **770101**: **irrilevante** in un test a
  EA singolo (e identico a R202B), dichiarato per non far dubitare il rilettore.
- Il driver **ricompila dal pin** (`walkforward_generico.ps1` r.317 e r.1929) e il referto lo
  stampa; resta non verificato solo che MetaEditor non riusi un `.ex5` stantio.
