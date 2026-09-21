# 🚀 R202B — QUANTO SPESSO DEVE SCATTARE LA PROTEZIONE, sedia DAX `770101`

**21/09/2026** · branch `lavoro` · pin della riga: **`3d5274261904313eb43884f6af642d25cea28d63`**
File prova: `backtest_pipeline/prove/R202b_obiettivo_DAX_D30EUR.txt` (90 pin, **4 celle**)

---

## 🟢 COSA MISURA, IN UNA RIGA

> **Asse unico `InpTP1_R`: `1.00` → `0.75` → `0.50` → `0.25`, con la parziale al 50% e il
> breakeven a TP1 GIÀ ACCESI e inchiodati.**
>
> 🔴 **Perché non è «la stessa cosa del Nasdaq», e va detto subito**: su questa sedia
> `InpTP1_ClosePct=50` e `InpBreakevenAtTP1=true` sono **già in campo da prima**. Non c'è
> niente da accendere. L'**unica** riga **della geometria d'uscita** (`InpSLMode`,
> `InpTP1_R`, `InpTP1_ClosePct`, `InpBreakevenAtTP1`, `InpBEatR`, `InpUseTrailing`,
> `InpTrailStartR`, `InpTrailMode` — confrontati **uno per uno** sui `.set` in campo delle
> tre sedie) che differisce dal Nasdaq `770260` è `InpTP1_R` (**1,0** qui contro **0,5**
> là), e quella riga decide **quanto spesso la protezione scatta**.
>
> ⚠️ **Fuori da quella lista le tre sedie differiscono eccome**, e va detto perché **i
> numeri non si trasportano**: `InpBufferPoints` 200 / **1000** / **500**,
> `InpRetestOffsetPts` 0 / **400** / **200**, `InpUseEmaFilter` false / **true (H4)** /
> false, e sul DAX `InpMinStopPts=0` con `InpSkipIfTight=true` contro 500/false sulle altre
> due. Le percentuali di scatto del parziale misurate altrove (**28-35%** a 1,0R su R46b
> Dow, **65-69%** a 0,5R su R199B Nasdaq) sono quindi un **ordine di grandezza atteso**,
> **non una predizione per questa sedia**.
>
> ⚠️ **E l'asse non muove solo il parziale.** `ABTG_DAX_Apertura_EU.mq5` **r.2085** (funzione `TpTotalR()`):
> **bersaglio finale = `InpTP1_R` × 3**. Quindi `1,00` → TP a 3,00R, `0,25` → TP a 0,75R.
> **Non è una manopola, è il disegno dell'operazione** — e per questo si misura invece di
> copiarla dal Nasdaq. *(Il cancello che contiene il breakeven a TP1 sta a r.2359.)*

### 💸 DOVE STA LA CELLA `0.25` RISPETTO AL COSTO — dichiarato **PRIMA**

🟢 **Il cancello di casa `stop >= 40 × spread` NON si muove lungo l'asse**: lo stop è il
range d'apertura (`InpSLMode=0`, pinnato) e `InpTP1_R` non lo tocca. Tutte e 4 le celle
stanno a **33,0× (42,3× con lo stop forward)**.
🟠 **Ma il PRIMO OBIETTIVO sì**, e il numero va scritto **prima** di leggere il referto
(`report/STOP_VS_SPREAD_FTMO_2026-09-20.md`: stop mediano **54,90** `[MIS n=3]` — campione sottilissimo, dichiarato, spread mediano **1,70**):

| cella | primo obiettivo | × spread mediano |
|---|---:|---:|
| `1.00` | 54,90 pt | 32,3× |
| `0.75` | 41,17 pt | 24,2× |
| `0.50` | 27,45 pt | 16,1× |
| **`0.25`** | 13,72 pt | 🔴 **8,1×** |

🔴 **SOTTO il pavimento duro di casa (13,3×)** — e anche con lo stop forward `[MIS n=8]` resta **10,6×**

🔴 **Quindi sul DAX la cella `0.25` chiede al mercato un movimento che vale OTTO volte
lo spread, sotto il pavimento duro di casa.** Si gira lo stesso — serve a vedere **il
verso** — ma **se vincesse NON si promuove**: sarebbe una vittoria comprata sotto la
frontiera del costo, ed è esattamente il posto dove un backtest illude.

⚠️ E `InpMaxSpread=0` — **il filtro spread è SPENTO**, come in campo — mentre il **massimo** misurato su `D30EUR` all'ora 08 è **12,00 punti indice**, a cui quell'obiettivo vale **1,14×** lo spread.

### 🎯 L'ATTESA, DICHIARATA **PRIMA** DEI NUMERI

| # | cosa mi aspetto | e se non succede |
|---|---|---|
| **a** | la cella `1.0` **riproduce R201A** entro l'arrotondamento | se non riproduce, **il round non è confrontabile**: si cerca il pin che balla, non si legge il resto |
| **b** | scendendo, `n` **sale** (primo obiettivo più vicino = più parziali contati) | se `n` **non** sale ci sono **DUE** spiegazioni e vanno separate **prima** di scrivere il verdetto. **(1)** `InpTP1_R` non fa quello che credo. **(2)** il TP dell'ordine sta a `InpTP1_R × 3`, cioè a **sole 3 volte** la distanza del parziale: nel tester lo SL/TP del broker è valutato **prima** di `OnTick()`, quindi nella cella `0.25` un tick che salta da sotto 0,25R a sopra 0,75R chiude il **100% al TP** e il parziale **non scatta mai** — *una* uscita invece di due. Più probabile proprio qui, con `InpMaxSpread=0` e spread **massimo** 12,00 pt. 👉 **Si separano contando le POSIZIONI (`position_id`), non i deal** |
| **c** | IS e OOS **concordi** sulla direzione | discordi → **nessuna cella si promuove**, si dichiara «non deciso» |
| **d** | si sceglie il **centro dell'altopiano**, **MAI il picco** | con 4 celle un altopiano può non esserci: allora il verdetto è **«serve più risoluzione»**, non una cella |

🔴 **E L'AVVERTENZA CHE HA GIÀ INGANNATO UNA VOLTA (R199B).** `STAT_TRADES` conta le
**uscite**, non le posizioni: col parziale acceso **una posizione produce due uscite**.
Quindi `Trades` che sale **NON vuol dire più operazioni**, vuol dire più **parziali
scattati**. 🟠 E il fattore di conversione **non si trasporta**: fra celle della **stessa**
sedia è stato misurato da **1,015 a 1,612**. Le posizioni vere si contano **una per una**
dopo, non si dividono a memoria.

### ⚓ LE ANCORE (da R201A, stessa macchina, ieri sera)

| finestra | ancora della cella viva |
|---|---|
| **IS** | n **175** · PF **1,12733** · DD **5,4089%** |
| **OOS** | n **270** · PF **1,39520** · DD **7,2506%** |

🔴 **E LA SCALA DI QUESTI DD VA DETTA PRIMA, NON DOPO — classe 547.** Il round gira a
`InpRiskPercent=1,0`; la sedia **in campo gira a `2,00`** (firma del 20/09,
`mql5/Presets/FTMO/ABTG_DAX_Apertura_EU_770101_FTMO.set`). Il pin resta **1,0 apposta**: `R201A` è girato a 1,0 e
senza quel pin l'attesa **(a)** non è verificabile.

> 👉 **Ogni DD di questo referto va RADDOPPIATO prima di confrontarlo col muro statico
> FTMO del 10%.** Il fattore **non è stimato**: sul DAX l'ancora a 1,0% vale **7,2506%** e
> il preset in campo scrive che *«il peggior tratto del backtest OOS a 2,00% vale
> **14,46%**»* — `7,2506 × 2 = 14,50`, **scarto 0,3%**.
>
> 🟠 **Contro-esempio di ieri sera, stessa macchina, stesso deposito**: `R196a` (Nasdaq)
> è stato pinnato a **2,00** e riporta DD OOS **9,12%**. Qui uscirà **7,25%**. Chi mette le
> due tabelle accanto conclude che questa sedia ha metà del DD del Nasdaq. **Non è vero:
> è metà della taglia.**
>
> 🟢 **Cosa NON tocca**: i cancelli del file prova sono **RELATIVI** («DD OOS scende di
> almeno il 20%», «PF OOS ≥ cella viva»), quindi restano validi **identici**. Cambia solo
> la lettura dei numeri **assoluti**.

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
& { $ErrorActionPreference='Stop'; $pin='3d5274261904313eb43884f6af642d25cea28d63'; if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('VIETATO: questa riga gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama ' + $env:COMPUTERNAME + '. Sul VPS operano le sei sedie della challenge FTMO e un backtest a tick reali lo inchioda: firma di Claudio del 21/09.') }; $w="$env:USERPROFILE\abtg_round"; $p="$w\RIGA_ROUND_VPS.ps1"; $dsk=[Environment]::GetFolderPath('Desktop'); $tmo=120; New-Item -ItemType Directory -Force -Path $w | Out-Null; Remove-Item $p -Force -ErrorAction SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ROUND_VPS.ps1?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $p -ErrorAction Stop; if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ROUND_VPS_v2' -Quiet)){ throw 'SCRIPT VECCHIO: manca MARCATORE_RIGA_ROUND_VPS_v2' }; Write-Host 'BERSAGLIO: il solo MT5 di questo PC, C:\Program Files\BCM Markets MT5 Terminal, demo 50503392. Tutto il resto (challenge FTMO 541452707, 100k 50504263, REALE 10105439, Pepperstone, Tickmill, banco 50504400) sta su una macchina diversa e questa riga non la raggiunge.' -ForegroundColor Cyan; $mt=@(Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id,MainWindowTitle,Path); Write-Host '--- MT5 APERTI SU QUESTA MACCHINA (PID / titolo / cartella) ---'; $mt | Format-Table -AutoSize; if(@($mt | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') }).Count -gt 0){ throw 'MT5 E APERTO: chiudilo A MANO (il PID sta nella tabella qui sopra), dopo aver guardato che non abbia EA attaccati, poi reincolla la riga. Non lo chiudo io: quel terminale e loggato sul demo 50503392 e da questa macchina il 14/08 sono partiti ordini veri.' }; Write-Host '=== ROUND R202B   EA ABTG_DAX_Apertura_EU   D30EUR M5   tick reali   deposito 80000   4 celle x 2 gambe ===' -ForegroundColor Cyan; $a=@('-NoProfile','-ExecutionPolicy','Bypass','-File',('"'+$p+'"'),'-Expert','ABTG_DAX_Apertura_EU','-Prova','R202b_obiettivo_DAX_D30EUR.txt','-Etichetta','R202B','-Pin',$pin,'-TerminaleBacktest','"C:\Program Files\BCM Markets MT5 Terminal"','-Modello','4','-Deposito','80000'); $pr=Start-Process powershell -ArgumentList $a -NoNewWindow -PassThru; if(-not $pr.WaitForExit($tmo*60*1000)){ Write-Host ('TETTO DI ' + $tmo + ' MINUTI SFONDATO: fermo il round. E UN RISULTATO, NON UN GUASTO: il referto che resta e PARZIALE.') -ForegroundColor Red; Stop-Process -Id $pr.Id -Force -ErrorAction SilentlyContinue; Get-Process metatester64,terminal64 -ErrorAction SilentlyContinue | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') } | Stop-Process -Force -ErrorAction SilentlyContinue; try{ $pr.WaitForExit() }catch{}; Start-Sleep -Seconds 10 }; $rc=$pr.ExitCode; if($null -eq $rc){ $rc='NON LEGGIBILE' }; Write-Host ('   esito R202B: codice ' + $rc + '   (0=GIRATO  2=NON MISURATO  3=GIRATO CON RILIEVI  1=non e partito)') -ForegroundColor Yellow; $d="$dsk\ROUND_R202B"; if(-not (Test-Path $d)){ Write-Host 'MANCA la cartella ROUND_R202B sul Desktop: il round NON ha prodotto raccolta.' -ForegroundColor Red } else { Compress-Archive -Path "$d\*" -DestinationPath "$dsk\ROUND_R202B.zip" -Force; Write-Host 'ZIP PRONTO DA MANDARE: Desktop\ROUND_R202B.zip' -ForegroundColor Green }; Write-Host 'FILE ATTESI NELLO ZIP (4):' -ForegroundColor Gray; Write-Host '   REFERTO_ROUND_R202B.txt' -ForegroundColor Gray; Write-Host '   ABTG_DAX_Apertura_EU_D30EUR_IS_R202B.csv' -ForegroundColor Gray; Write-Host '   ABTG_DAX_Apertura_EU_D30EUR_OOS_R202B.csv' -ForegroundColor Gray; Write-Host '   R202b_obiettivo_DAX_D30EUR.txt' -ForegroundColor Gray; Write-Host 'NEL REFERTO LEGGI LA RIGA  data:  -- DEVE ESSERE DI OGGI, altrimenti stai guardando un file vecchio.' -ForegroundColor Yellow; if(Test-Path $d){ Get-ChildItem $d -Recurse -File | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize } }
```

📅 **Quale data deve leggere Claudio**: dentro `REFERTO_ROUND_R202B.txt`, la riga che
comincia con **`data            :`**. Il 17/08 un referto stantio è stato rimandato **due
volte** in buona fede: si guarda quella riga **prima** di leggere i numeri.

---

## ② 📐 IL TETTO DELLE ~100.000 BARRE — **misurato, non stimato**

Nessuna stima: **lo stesso EA, lo stesso simbolo, lo stesso M5, la stessa identica finestra**
(`@DAQUANDO 2024.09.26`, `@FINOA 2026.06.30`, `@FRAZIONEIS 0.40`) è già girato **ieri sera** e
il referto riporta `tetto barre : MaxBars=100000000`. Il pre-volo della classe 160 muore solo
se `MaxBars` sta **fra 1.000 e 200.000**: qui è cento milioni, quindi passa.
🟢 E le due corse sono **separate** (`walkforward_generico.ps1` r.931-938): il tetto vale
**per corsa**, non per il round.


---

## ③ ⏱️ IL TETTO DI TEMPO — **120 minuti, ed è un TETTO, non una stima**

🟠 **Dichiaro quello che NON so.** `R172D` e `R201A` sono girati ieri sera sulla **stessa
macchina**, con gli **stessi EA**, la **stessa finestra**, **14 passate ciascuno**: i referti
portano avvio `21:01:33` e `21:05:24`, **3 minuti e 51 secondi** di distanza. **SE** erano in
fila, 14 passate costano meno di 4 minuti e queste 8 ne costano ~2. ⚠️ **Ma che fossero in fila
non lo posso provare**, quindi **non lo uso come stima**: tetto **largo trenta volte**, che
serve solo a impedire che un tester appeso resti lì per sempre.

⚠️ **Se il tetto scatta NON è un successo** (checklist p.19): la riga lo dice in rosso e il
referto che resta è **PARZIALE**.
🔴 **La chiusura d'emergenza è chirurgica e su una COSTANTE**: `Stop-Process` colpisce solo
`metatester64`/`terminal64` il cui `Path` sta sotto `C:\Program Files\BCM Markets MT5 Terminal\`
— **stringa letterale dentro la riga, nessuna variabile che arrivi da fuori** — su una macchina
dove quello è l'unico MT5 e che la riga ha **già verificato chiuso** prima di partire.


---

## ④ 🚦 IL CANCELLO — **due strati, tutti e due passati**

**Strato 1 (deterministico)**
- `controlla_prova.py` sul file prova → **verde** (90 pin, 4 celle, 0 problemi).
- `controlla_riga.py --oggetto md` su questo file → **verde**.
- **Parser PowerShell** sulla riga: **0 errori**. **Una sola riga fisica** (classe 538),
  **zero caratteri non-ASCII**.

**Strato 2 (giudizio, agente `controllo-preventivo`)** — ha risposto **FAIL** con **cinque
difetti, tutti TESTUALI**, e sono stati **corretti prima** che questo file arrivasse a
Claudio (regola del 13/09: lo Sviluppatore e l'Agente dei Controlli).

| # | difetto trovato | dov'è la correzione |
|---|---|---|
| **D1** | il DD consegnato **senza la sua taglia** (banco 1,0% contro 2,00% in campo) — **classe nuova 547** | il riquadro sotto le ancore, e un blocco nel file prova |
| **D2** | *«l'unica riga che differisce dal Nasdaq»* era **falso come scritto** | ristretto alla **geometria d'uscita**, con la tabella delle differenze vere |
| **D3** | la citazione **`r.1694`** non puntava a niente di pertinente in nessuno dei due EA | ora **r.2085** (`TpTotalR`) e **r.2359** (cancello del parziale), verificate a grep |
| **D4** | l'attesa **(b)** aveva **un solo** ramo di fallimento, ma nel codice ce n'è un secondo | la riga **(b)** della tabella delle attese |
| **D5** | dove sta la cella `0.25` **rispetto al costo** non era dichiarato | la sezione 💸 qui sopra |

**Contro-esempi tenuti, non raccontati**
- La riga è stata confrontata **parola per parola** con la riga già provata di `R196A`: le
  **uniche** differenze sono `pin`, `$tmo`, etichetta, EA, simbolo, numero di celle, nome
  del file prova e nomi dei file attesi. Stesso confronto rifatto fra `R202A` e `R202B`.
- Il file prova è verificato **per differenza** contro `R201A`: cambiano **DUE righe e
  basta** (`InpTP1_R` da pin ad asse, `InpBEatR` da asse a pin `0.0`); direttive `@`
  **identiche**, **90 pin** prima e dopo.
- 🟠 Il **primo** diff che avevo fatto usava `[A-Za-z_]+=`, che **non matcha i nomi con
  una cifra dentro**: `InpTP1_R` era invisibile al mio stesso controllo. Rifatto con
  `[A-Za-z0-9_]+=`. Sta scritto qui perché un grep che guarda dall'altra parte è il modo
  esatto in cui si certifica il falso.
- Gli URL del pin (driver + file prova) rispondono **200**, verificato **dopo** l'ultimo
  commit.

**🕳️ Cosa resta NON coperto, e va detto**
- Che il `.ex5` sul PC di backtest corrisponda ai `.mq5` letti qui: il driver ricompila dal
  pin, ma **non l'ho misurato** — e questa famiglia ha già avuto scarti sorgente/binario
  (`ABTG_EMA200`, 690 righe contro 486 in campo).
- **Quante volte** scatti davvero l'effetto «tick che scavalca il TP» dell'attesa (b): il
  meccanismo **esiste nel codice**, la frequenza è **[NON MISURATA]** e si legge solo dopo.
- Gli stop del DAX sono `[MIS n=3]` e `[MIS n=8]`: **campione sottilissimo**. Il *verso*
  (cella `0.25` sotto il pavimento) regge con tutti e due i valori, **il numero esatto no**.
