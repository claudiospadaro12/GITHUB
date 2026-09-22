# 🪑 R211A — LA PARZIALE SULL'ORB DEL DOW: abbassa il DD sotto il muro FTMO?

**22/09/2026** · branch `lavoro` · pin della riga: **`5d2e9d0e867e9e288c36b152af48bcedde70f993`**
File prova: `backtest_pipeline/prove/R211a_parziale_orb_DOW_U30USD.txt` (**22 pin, 4 celle, 8 passate**)
EA: `ABTG_ORB_Ottimizzato` · `U30USD` **M5** · tick reali · deposito **10.000** · asse **`InpTP1Pct` 0/25/50/75**

> ✅ **PASSATA DAI DUE STRATI DEL CANCELLO il 22/09/2026.**
> **File prova**: FAIL sulla bozza → PASS dopo la correzione (classe nuova **594**: l'asse muoveva
> *due* meccanismi, parziale **e** breakeven).
> **Riga**: FAIL sulla bozza → PASS su questa versione (classi nuove **595** e **596**).
> Dettaglio in coda, sezioni ⑧ e ⑨. **Questa e' la versione da incollare.**

---

## ① 🖥️ DOVE MANDARE QUESTA STRINGA

> ## 🖥️ **finestra PowerShell sul PC DI BACKTEST `DESKTOP-H4D7CAJ`** (utente `Master`).
> **Bersaglio: l'unico MT5 di quella macchina, `C:\Program Files\BCM Markets MT5 Terminal`, demo `50503392`.**
>
> 🔴 **COSA NON VIENE TOCCATO, per nome e non per esclusione.** Tutto cio' che vive **sul VPS
> `VMI3047753`**, cioe' **tutte e otto** le cartelle dati di quella macchina: la challenge
> **FTMO `541452707`** (`C:\FTMO`, **sei sedie che stanno operando**), il **100k `50504263`**
> (`... MT5 Terminal -V3`), il **REALE `10105439`** (`C:\BCM_Reale`), il **piccolo `50503392`
> del VPS** (`BCM Markets MT5 Terminal`), il **manuale `50503635`** (`C:\MT5_MANUALE`),
> **Pepperstone**, **Tickmill**, e il banco **`50504400`** (`C:\MT5_Backtest`, **che resta SPENTO**).
> 🔴 La riga **si rifiuta di partire** se `$env:COMPUTERNAME` non e' `DESKTOP-H4D7CAJ`: il `throw`
> e' il **primo statement dopo `$pin`**, quindi muore **prima** di scaricare qualunque cosa.
>
> ✋ **PRIMA DI INCOLLARE: chiudi MT5 sul PC di backtest.** La riga **non lo chiude da sola**,
> apposta: quel terminale e' **loggato su un conto demo vivo** (`50503392`) e il **14/08/2026**
> da quella macchina sono partiti **ordini veri** (#3160534/#3160535). Se lo trova aperto stampa
> PID + titolo + cartella e **si ferma**.

---

## 🟢 COSA MISURA, IN TRE RIGHE

1. **Asse unico `InpTP1Pct`: 0 · 25 · 50 · 75** — la **chiusura parziale al primo obiettivo**,
   una manopola **mai messa ad asse** su questo motore.
2. **Perche' proprio questa, e perche' adesso**: l'ORB sul Dow **funziona ed e' fermo**. In `r44a`
   l'**OOS batte l'IS su tutte e quattro le celle** (PF OOS 1,657 → 1,955), e **nessun ORB e' in
   campo su FTMO**. Il tappo **non e' il PF: e' il DRAWDOWN** — tre celle su quattro sfondano il
   muro del 10%, e la quarta ci sta dentro per **otto centesimi**.
3. **Due fonti che si contraddicono, e non si sceglie quella comoda.** In casa, sul motore
   fratello (`R199B`, sedia Nasdaq `770260`), la stessa manopola ha fatto **DD IS -40,9% e DD OOS
   -13,9% col PF che SALE**. Fuori casa, i **28 preset di vendor** decodificati il 22/09 su indici:
   **zero** usano un parziale, e in tre famiglie su quattro **il parametro non esiste nemmeno**.
   👉 **Si misura.**

---

## ② 🚀 LA RIGA

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $pin='5d2e9d0e867e9e288c36b152af48bcedde70f993'; if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('VIETATO: questa riga gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama ' + $env:COMPUTERNAME + '. Sul VPS operano le sei sedie della challenge FTMO e un backtest a tick reali inchioda la macchina: firma di Claudio del 21/09.') }; $w="$env:USERPROFILE\abtg_round"; $p="$w\RIGA_ROUND_VPS.ps1"; $dsk=[Environment]::GetFolderPath('Desktop'); $tmo=48; New-Item -ItemType Directory -Force -Path $w | Out-Null; Remove-Item $p -Force -ErrorAction SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ROUND_VPS.ps1?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $p -ErrorAction Stop; if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ROUND_VPS_v2' -Quiet)){ throw 'SCRIPT VECCHIO: manca MARCATORE_RIGA_ROUND_VPS_v2' }; Write-Host 'BERSAGLIO: il solo MT5 di questo PC, C:\Program Files\BCM Markets MT5 Terminal, demo 50503392. Tutto il resto (challenge FTMO 541452707, 100k 50504263, REALE 10105439, piccolo 50503392 del VPS, MT5_MANUALE 50503635, Pepperstone, Tickmill, banco 50504400) sta su una macchina diversa e questa riga non la raggiunge.' -ForegroundColor Cyan; $mt=@(Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id,MainWindowTitle,Path); Write-Host '--- MT5 APERTI SU QUESTA MACCHINA (PID / titolo / cartella) ---'; $mt | Format-Table -AutoSize | Out-Host; if(@($mt | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') }).Count -gt 0){ throw 'MT5 E APERTO: chiudilo A MANO (il PID sta nella tabella qui sopra), dopo aver guardato che non abbia SEDIE attaccate, poi reincolla la riga. Non lo chiudo io: quel terminale e loggato sul demo 50503392 e da questa macchina il 14/08 sono partiti ordini veri.' }; Write-Host ('CLASSE 582 -- LA PRECONDIZIONE VALE ADESSO, IL COLTELLO CADE FRA ' + $tmo + ' MINUTI: ho appena controllato che il terminale bersaglio sia CHIUSO, ma se il tetto scatta il ramo di emergenza chiude metatester64 E terminal64 sotto C:\Program Files\BCM Markets MT5 Terminal. Finche il round gira NON riaprire a mano il demo 50503392 su questa macchina: te lo chiuderebbe. Il tetto NON e un numero tondo (classe 583): 8 passate x 20,1 s x 18 = 2894 s = 48,2 min -> 48. La base e TRASFERITA (di ABTG_ORB_Ottimizzato non esiste NESSUN referto cronometrato), quindi moltiplicatore x18, dentro la banda di casa x15-20 per una base trasferita. CARTA D IDENTITA DELLA BASE: R202A del 21/09, DESKTOP-H4D7CAJ, stesso driver, ABTG_Dow_Apertura_US, U30USD, M5, modello 4, deposito 80000, finestra 2024.09.26-2026.06.30, 8 passate; avvii R202A 23:24:38 e R202B 23:27:19 = 2 min 41 s = <= 20,1 s/passata. EA DIVERSO dal nostro, e qui la parziale accesa aggiunge lavoro dentro ManageTP1.') -ForegroundColor Yellow; Write-Host '--- CLASSE 166 (PRE): il driver NON compila dal pin, compila dal ramo lavoro. Confronto ora i due SHA256; questa garanzia SCADE al primo byte che il driver scarichera, e a chiuderla e il controllo POST a fine round, fatto sui byte che hanno COMPILATO ---' -ForegroundColor Yellow; $ramo='lavoro'; try{ $tip=(irm "https://api.github.com/repos/claudiospadaro12/GITHUB/commits/$ramo" -UserAgent 'abtg-round').sha }catch{ throw ('NON HO POTUTO LEGGERE LA PUNTA DEL RAMO ' + $ramo + ': ' + $_.Exception.Message + '. Senza quella non posso garantire che il motore compilato sia quello del pin: NON si gira.') }; Write-Host ('   il ramo ' + $ramo + ' e oggi al commit ' + $tip) -ForegroundColor Yellow; foreach($s in @('mql5/Experts/ABTG_ORB_Ottimizzato.mq5','mql5/Include/ABTG_PausaGuardian.mqh')){ $n=Split-Path $s -Leaf; $fp="$w\pin_$n"; $fb="$w\ramo_$n"; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/$s?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $fp -ErrorAction Stop; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$tip/$s?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $fb -ErrorAction Stop; $hp=(Get-FileHash -Algorithm SHA256 -LiteralPath $fp).Hash; $hb=(Get-FileHash -Algorithm SHA256 -LiteralPath $fb).Hash; if($hp -ne $hb){ throw ('CLASSE 166: ' + $n + ' sulla punta del ramo NON e quello del pin (pin ' + $hp.Substring(0,12) + '   ramo ' + $hb.Substring(0,12) + '). Il driver compila DAL RAMO: il motore e cambiato sotto e l ancora di regressione non varrebbe piu. NON si gira: chiedimi una riga con un pin nuovo.') }; Write-Host ('   ' + $n + '   pin = ramo   SHA256 ' + $hp.Substring(0,16)) -ForegroundColor Green }; Write-Host '=== ROUND R211A   EA ABTG_ORB_Ottimizzato   U30USD M5   tick reali   deposito 10000   4 celle x 2 gambe = 8 passate   asse InpTP1Pct 0/25/50/75 ===' -ForegroundColor Cyan; $a=@('-NoProfile','-ExecutionPolicy','Bypass','-File',('"'+$p+'"'),'-Expert','ABTG_ORB_Ottimizzato','-Prova','R211a_parziale_orb_DOW_U30USD.txt','-Etichetta','R211A','-Pin',$pin,'-TerminaleBacktest','"C:\Program Files\BCM Markets MT5 Terminal"','-Modello','4','-Deposito','10000'); $pr=Start-Process powershell -ArgumentList $a -NoNewWindow -PassThru; if(-not $pr.WaitForExit($tmo*60*1000)){ Write-Host ('TETTO DI ' + $tmo + ' MINUTI SFONDATO: fermo il round. E UN RISULTATO, NON UN GUASTO: il referto che resta e PARZIALE.') -ForegroundColor Red; Stop-Process -Id $pr.Id -Force -ErrorAction SilentlyContinue; Get-CimInstance Win32_Process -Filter "Name='powershell.exe'" -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -and ($_.CommandLine -like '*walkforward_generico.ps1*') } | ForEach-Object { Write-Host ('   fermo anche il NIPOTE che esegue il driver: PID ' + $_.ProcessId) -ForegroundColor Red; Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }; Start-Sleep -Seconds 5; Get-Process metatester64,terminal64 -ErrorAction SilentlyContinue | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') } | Stop-Process -Force -ErrorAction SilentlyContinue; try{ $pr.WaitForExit() }catch{}; Start-Sleep -Seconds 10; Get-Process metatester64,terminal64 -ErrorAction SilentlyContinue | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') } | Stop-Process -Force -ErrorAction SilentlyContinue }; $rc=$pr.ExitCode; if($null -eq $rc){ $rc='NON LEGGIBILE' }; Write-Host ('   esito R211A: codice ' + $rc + '   (0=GIRATO  2=NON MISURATO  3=GIRATO CON RILIEVI  1=non e partito)') -ForegroundColor Yellow; $att=@{}; $att["$w\src_prove\ABTG_ORB_Ottimizzato.mq5"]='C14D85DD889BFD66F94F23C64B0B15FEC2F09CAE6C03111518C92E369496FA44'; $att["$w\src_include\ABTG_PausaGuardian.mqh"]='3EC971152E85E0082488CC4243FF45AE09948C191D52AB96050B48F94641A737'; $div=@(); foreach($k in @($att.Keys)){ if(-not (Test-Path -LiteralPath $k)){ $div += ((Split-Path -Leaf $k) + ' [il driver non lo ha lasciato su disco]') } elseif((Get-FileHash -LiteralPath $k -Algorithm SHA256).Hash -ne $att[$k]){ $div += ((Split-Path -Leaf $k) + ' [SHA256 DIVERSO da quello del pin]') } }; if($div.Count -eq 0){ $m166='CLASSE 166 (POST) -- MOTORE: OK. Il .mq5 e l include che hanno COMPILATO sono ESATTAMENTE quelli del pin (SHA256 su src_prove e src_include, letti DOPO la corsa). Il pin copre anche il motore, non solo la procedura: l ancora di r44a e confrontabile.'; $c166='Green' } else { $m166=('CLASSE 166 (POST) -- MOTORE DIVERSO DAL PIN: ' + ($div -join ' ; ') + '. walkforward_generico.ps1 r.264 ha EABranch=lavoro CABLATO e la riga non gli passa nessun pin: EA e include arrivano dal RAMO, scaricati DOPO il confronto di partenza. I numeri NON sono confrontabili con r44a: PRIMA di buttare il round si rifa il pin sulla punta del ramo e si rilancia.'); $c166='Red' }; Write-Host $m166 -ForegroundColor $c166; $d="$dsk\ROUND_R211A"; if(-not (Test-Path $d)){ Write-Host 'MANCA la cartella ROUND_R211A sul Desktop: il round NON ha prodotto raccolta.' -ForegroundColor Red } else { Add-Content -LiteralPath (Join-Path $d 'REFERTO_ROUND_R211A.txt') -Value $m166 -Encoding ASCII -ErrorAction SilentlyContinue; Compress-Archive -Path "$d\*" -DestinationPath "$dsk\ROUND_R211A.zip" -Force; Write-Host 'ZIP PRONTO DA MANDARE: Desktop\ROUND_R211A.zip' -ForegroundColor Green }; Write-Host 'FILE ATTESI NELLO ZIP (4):' -ForegroundColor Gray; Write-Host '   REFERTO_ROUND_R211A.txt' -ForegroundColor Gray; Write-Host '   ABTG_ORB_Ottimizzato_U30USD_IS_R211A.csv    (4 righe attese)' -ForegroundColor Gray; Write-Host '   ABTG_ORB_Ottimizzato_U30USD_OOS_R211A.csv   (4 righe attese)' -ForegroundColor Gray; Write-Host '   R211a_parziale_orb_DOW_U30USD.txt' -ForegroundColor Gray; Write-Host 'NEL REFERTO LEGGI LA RIGA  data:  -- DEVE ESSERE DI OGGI, altrimenti stai guardando un file vecchio.' -ForegroundColor Yellow; Write-Host 'ANCORA DI REGRESSIONE (letta nei CSV grezzi di r44a, NON in un referto) -- cella InpTP1Pct=0, che e la cella di r44a a InpTPRangeMult 1.5:  IS  n=71  PF=1.22314  RF=0.95264  EqDD%=8.6252  Profit=867.42   |   OOS  n=119  PF=1.65693  RF=3.39368  EqDD%=9.9181  Profit=4002.54.  SE NON TORNA, il primo sospetto NON e la parziale: e l EA, passato da v1.01 a v1.04 dopo r44a. Si misura QUELLO prima di buttare il round.' -ForegroundColor Magenta; Write-Host 'COME SI LEGGE QUESTO ROUND, e va letto PRIMA dei numeri. Con la parziale accesa la colonna Trades conta USCITE, non posizioni (classe 550): n e Expected Payoff NON sono confrontabili fra celle. Decide il RECOVERY FACTOR, che e soldi diviso soldi. Si promuove una cella solo se TUTTE E QUATTRO: 1) EqDD% OOS <= 9.0   2) RF OOS >= 3.39368   3) Profit OOS >= 3602.29   4) n OOS dentro 119-238. Il PF OOS >= 1.30 resta come pavimento di sanita, NON decide lui.' -ForegroundColor Magenta; Write-Host 'CONTRO-ESEMPIO A MACCHINA: se le 4 celle escono con Profit IDENTICO (valori distinti meno di 2), la manopola e INERTE e NESSUN numero di questo round si legge -- che NON vuol dire la parziale non serve. E il breakeven qui e PINNATO A 0 apposta: nell EA vive dentro ManageTP1 e a parziale spenta e irraggiungibile, quindi lasciarlo a 1 avrebbe mosso DUE meccanismi sullo stesso asse.' -ForegroundColor Magenta; Write-Host 'LA TAGLIA: questo round gira a InpRiskPercent 1,0 come r44a. NON e la taglia di campo (FTMO gira al 2,00%): ogni DD va RADDOPPIATO prima di confrontarlo col muro del 10%. Il fattore misurato in casa e 1,956-1,990.' -ForegroundColor Magenta; if(Test-Path $d){ Get-ChildItem $d -Recurse -File | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize } }
```

📅 **Quale data deve leggere chi riceve lo zip**: dentro `REFERTO_ROUND_R211A.txt`, la riga che
comincia con **`data            :`**. Se non e' di oggi, stai guardando un file vecchio.

---

## ③ 📦 I FILE ATTESI NELLO ZIP (`Desktop\ROUND_R211A.zip`) — **4**

| file | che cos'e' |
|---|---|
| `REFERTO_ROUND_R211A.txt` | il referto del driver — **e in coda il verdetto di classe 166**, aggiunto dalla riga prima dello zip |
| `ABTG_ORB_Ottimizzato_U30USD_IS_R211A.csv` | gamba **IS**, **4 righe** attese |
| `ABTG_ORB_Ottimizzato_U30USD_OOS_R211A.csv` | gamba **OOS**, **4 righe** attese |
| `R211a_parziale_orb_DOW_U30USD.txt` | il file prova **come scaricato dal pin** |

---

## ④ 🪝 L'ANCORA DI REGRESSIONE — c'e', ed e' presa dai CSV grezzi

La cella **`InpTP1Pct = 0`** e' esattamente la cella di `r44a` a `InpTPRangeMult = 1.5`, e **deve
riprodurla**. Numeri letti in
`backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato/r44/ABTG_ORB_Ottimizzato_U30USD_{IS,OOS}_r44a.csv`,
**non in un referto**:

| gamba | n | PF | RF | Equity DD % | Profit |
|---|---:|---:|---:|---:|---:|
| **IS** | **71** | **1,22314** | **0,95264** | **8,6252** | **867,42** |
| **OOS** | **119** | **1,65693** | **3,39368** | **9,9181** | **4.002,54** |

🔴 **SE NON TORNA, il primo sospetto NON e' la parziale: e' l'EA.** Fra `r44a` (13/08, `e38cb80c`)
e oggi ci sono **quattro commit** sul motore. Tre sono **no-op verificati al default**
(`InpSlippagePts=0` guardia `if(>0)` · `InpUsaGuardian` fail-open totale nel tester, dove le
GlobalVariable del Guardian non esistono · `InpSLBufferPts=0`). Il quarto **e' un cambio di
logica**: `19312c8b` del 03/09, **v1.04**, selezione hedge-safe per simbolo+magic e chiusure per
ticket. L'EA dichiara in testa che *"nel tester il comportamento deve restare identico al
centesimo"* — 🔴 **ma e' una PROMESSA, non una MISURA**. Se l'ancora manca, **si misura QUELLA**
prima di buttare il round.

---

## ⑤ ⚖️ COME SI LEGGE — e va letto PRIMA dei numeri

🔴 **Con la parziale accesa la colonna `Trades` conta USCITE, non posizioni** (classe 550). Questo
rompe `n` e `Expected Payoff`. **Non rompe il PF** (utile lordo / perdita lorda: soldi diviso
soldi, non divide per `n`).
🔴 **E "DD contro DD" da solo NON basta e non si usa**: una cella che opera **di meno** ha un DD
piu' basso **per costruzione**, quindi premierebbe il fare meno.

✅ **Decide il RECOVERY FACTOR** — profitto netto / drawdown assoluto: soldi/soldi, immune al
conteggio delle uscite, ed e' *letteralmente* la domanda del round (*quanti soldi per unita' di
rischio*). Si promuove una cella solo se **TUTTE E QUATTRO**:

| # | condizione | da dove viene |
|---|---|---|
| 1 | `Equity DD % OOS <= 9,0` | margine **vero** sotto il muro, non gli 8 centesimi di adesso |
| 2 | `Recovery Factor OOS >= 3,39368` | **non peggio dell'ancora** |
| 3 | `Profit OOS >= 3.602,29` | **>= 90%** dei 4.002,54 dell'ancora |
| 4 | `n OOS dentro [119, 238]` | ogni posizione fa **1 o 2** uscite, e `InpOneTradePerDay` tiene le posizioni a <= 1 al giorno. Fuori da qui si e' mosso **altro** |

`PF OOS >= 1,30` **resta come pavimento di sanita'**, non come criterio: l'ancora fa gia' **1,65693**,
e un cancello tarato **sotto lo status quo non e' un cancello**.

🔴 **LA TAGLIA, e va detta ora.** Il round gira a **`InpRiskPercent = 1,0`**, come `r44a`: e' il dial
di **MISURA**, non la taglia di campo. **FTMO gira al 2,00%**, quindi **ogni DD va raddoppiato**
(fattore misurato **1,956-1,990**) prima di confrontarlo col muro del 10%.

---

## ⑥ ⏱️ IL TETTO DI TEMPO — **48 minuti**, e da dove viene il numero

🔴 **Il tetto non e' pazienza: e' l'AMPIEZZA DELLA FINESTRA DI RISCHIO** (classe **582**). La
precondizione che autorizza lo `Stop-Process` (*"nessun `terminal64` del percorso bersaglio e'
vivo"*) e' verificata a **t=0**; il coltello scende a **t=TETTO**. In mezzo, quel percorso e' il
terminale del **demo `50503392`**, che un umano puo' riaprire. 👉 **Se lo riapri durante l'attesa,
la riga te lo chiude.** La riga ora lo dice a schermo.

**Il conto, passo per passo:**

| passo | numero | fonte |
|---|---:|---|
| passate di questo round | **8** | 4 celle x 2 gambe (`controlla_prova.py`) |
| base di costo | **<= 20,1 s/passata** | **R202A** del 21/09: `ABTG_Dow_Apertura_US`, `U30USD`, **M5**, modello 4, **stessa finestra**, **stessa macchina**, **8 passate** — avvii 23:24:38 → 23:27:19 = **2 min 41 s** |
| moltiplicatore | **x18** | la base e' **TRASFERITA** (di `ABTG_ORB_Ottimizzato` **non esiste nessun referto cronometrato** su questa macchina): la banda di casa per una base trasferita e' **x15-20** |
| **TETTO** | **48 minuti** | `8 x 20,1 s x 18 = 2.894 s = 48,2 min` |

🟢 **E l'ipotesi che i round del 21/09 fossero sequenziali e' VERIFICATA nel codice, non assunta**:
`RIGA_ROUND_VPS.ps1` esce con `Muori` (**senza scrivere nessun referto**) se un `terminal64` del
bersaglio e' vivo. Quindi **l'esistenza del referto di R198** dimostra che a quell'ora il tester di
R197B era finito. I delta fra avvii consecutivi sono **limiti superiori veri**.
⚠️ **Se il tetto scatta NON e' un successo**: la riga lo dice in rosso e il referto che resta e' **PARZIALE**.

---

## ⑦ 🔗 LA GUARDIA DI CLASSE 166 — ora in **DUE tempi**, ed e' la novita' di questa riga

🔴 **Il problema**: `walkforward_generico.ps1` **r.264** ha `$EABranch="lavoro"` **CABLATO**, e la
riga non passa nessun pin al driver. Quindi il pin copre **la riga, il driver e il file prova**,
mentre **`.mq5` e include scendono dal RAMO**, al momento in cui il driver li scarica.

- ⏳ **PRE-controllo (fail fast)**: la riga risolve la punta di `lavoro` via API, scarica i due file
  dal pin e dalla punta, confronta gli SHA256 e **muore** se differiscono. Serve a non bruciare 48
  minuti. 🔴 **Ma NON e' la garanzia: scade al primo byte che il driver scarichera'.**
- ✅ **POST-controllo (la garanzia)**: **dopo** la corsa, la riga hasha **`src_prove\ABTG_ORB_Ottimizzato.mq5`**
  e **`src_include\ABTG_PausaGuardian.mqh`** — cioe' **i byte che `Copy-Item` ha portato al
  compilatore** — contro le costanti del pin, e **scrive il verdetto DENTRO il referto** con
  `Add-Content`, **prima** dello zip. Cosi' l'informazione **viaggia**, invece di morire con la console.

**Le costanti, ricalcolate a mano dal pin `5d2e9d0e`:**
- `ABTG_ORB_Ottimizzato.mq5` → `c14d85dd889bfd66f94f23c64b0b15fec2f09cae6c03111518c92e369496fa44`
- `ABTG_PausaGuardian.mqh` → `3ec971152e85e0082488cc4243ff45ae09948c191d52ab96050b48f94641a737`
  🟢 **quest'ultima coincide byte per byte con la costante gia' cablata in `RIGA_R207A_DA_MANDARE.md`**:
  e' la controprova indipendente che il metodo di calcolo e' quello giusto.

🟢 **E la copertura e' del 100%**: gli `#include` **veri** dell'EA (r.105-106) sono **esattamente due**
— `<Trade/Trade.mqh>` (di **sistema**, viene da MT5, mai scaricato dal nostro repo) e
`<ABTG_PausaGuardian.mqh>` (coperto). Gli altri due che il driver scarica
(`ABTG/ABTG_ApertureCore.mqh`, `OptFrame.mqh`) **non sono inclusi da nessun EA** e non possono
entrare nel binario.
🎁 **Bonus**: il post-controllo chiude anche un **secondo fail-open** che il pre non vedeva —
`walkforward_generico.ps1` r.317/355, *"(download fallito: uso la copia locale gia' scaricata)"*.
Se GitHub singhiozza, il driver compila una copia **vecchia** e tira dritto. Il PRE non se ne
accorge mai; il POST si'.

---

## ⑧ 🕳️ I BUCHI, DICHIARATI

- 🔴 **Il lato SHORT non e' misurato.** `InpAllowShort=0` e' l'identita' della cella di `r44a`
  (legittimo), **ma la regola dei due lati del 25/08 dice che su Dow/DAX/Nasdaq lo short si
  ritesta comunque**. Qui non si puo' (un asse alla volta): e' un buco **dichiarato**, e il suo
  round si chiama **R211d**.
  📌 **E stasera e' arrivato un numero che lo ridimensiona**: `csv_r54/..._r54b` misura lo short
  a **PF 0,5197 / DD 26,37%** e i due lati a **PF 1,0475 / DD 17,16% su n 219**. Il *"accendo lo
  short e arrivo a 150"* **non funziona**: il campione arriva e il motore smette di passare.
- 🟠 **La FREQUENZA non e' la domanda di questo round, ma il numero pesa sul 1 ottobre**: `r44a`
  fa **119 operazioni in 386 giorni solari OOS ≈ 276 di borsa = 0,43 op/giorno**. Il pavimento e'
  **1,00 per FAMIGLIA** (firma 07/09): Dow + DAX insieme, **se il DAX reggesse**, fanno **~0,86**.
  👉 **La famiglia ORB ha bisogno di un TERZO simbolo**, e questo round non lo cerca.
- 🟠 **`InpBreakeven` e' PINNATO A 0 apposta** per isolare la parziale (classe 594): il pacchetto
  parziale+breakeven e' **R211c**, e non e' ancora girato.
- 🟠 **Prova di regime: assente.** 21 mesi = **un solo regime**. Regola **C** dell'Emendamento
  **non soddisfatta**, e non lo sara' alla fine di questo round.
- 🟠 **Che il `.ex5` sul banco corrisponda al `.mq5`: `[NON MISURATO]`** — ed e' proprio il motivo
  per cui il post-controllo di classe 166 scrive il verdetto nel referto.
- 🟠 **La build di MetaTrader non e' registrata in nessun referto di questa casa.** Un aggiornamento
  di MT5 fra `r44a` (13/08) e oggi potrebbe spostare l'ancora e **nessun controllo se ne
  accorgerebbe**. Buco strutturale, non di questa riga.
- 🟢 **Il tetto delle ~100.000 barre NON morde, ed e' contato**: U30USD M5 = **187,8 barre/giorno
  solare** (130.126 barre in 693 giorni, dal referto di misura tick). Il walk-forward **spezza in
  due tranche**: IS 256 giorni ≈ **48.100** barre · OOS 386 giorni ≈ **72.500**. Tutte e due sotto.
  🔴 La finestra **intera** sarebbe ~120.600: **sopra**. Non si gira mai intera, ed e' scritto nel
  file prova perche' nessuno la giri "per comodita'".

---

## ⑨ 🚦 IL CANCELLO — I DUE STRATI

**Strato 1 (deterministico), rifatto sulla versione finale:**

| controllo | esito |
|---|---|
| `controlla_prova.py` sul file prova | 🟢 **OK** — `pin=22 celle=4`, **8 passate**, **0 problemi** |
| `controlla_riga.py --riga … --prova …` | 🟢 **`ESITO: nessun difetto meccanico`**, **8 passati**, 2 rilievi (457, 225) sciolti a mano |
| parser PowerShell (`pwsh 7.4.6`, `Parser::ParseInput`) | 🟢 **0 errori**, **67 comandi** |
| `StaticParameterBinder::BindCommand` (classe **586**) | 🟢 **0 binding rotti su 67** |
| **contro-esempio** sul binder (regola 10/09) | 🟢 una versione col `;` mangiato viene **BOCCIATA** → il controllo discrimina davvero |
| una sola riga fisica (classe **538**) · ASCII puro | 🟢 **0 newline** · **0 byte >= 128** |
| pin = commit vero, contiene prova + marcatore | 🟢 `git cat-file` |
| SHA256 delle due costanti ricalcolati a mano dal pin | 🟢 **coincidono**, e l'`.mqh` coincide con la costante di `R207A` |
| ora **SERVER** (fuso BCM) | 🟢 `InpRangeStartHour=14` → 14:30 server = **15:30 IT**, apertura USA. **14, non 15** |

**Strato 2 (giudizio, agente `controllo-preventivo`) — FATTO. Verdetto: FAIL sulla bozza → PASS
su questa versione.** I tre difetti, **corretti dentro il documento** e non annunciati dopo:

1. 🔴 **CLASSE NUOVA 595** — la guardia di classe 166 era un **PRE-controllo su un PROXY**
   ("la punta del ramo oggi e' uguale al pin") invece che un **POST-controllo sui byte che hanno
   compilato**. 🧪 **Misurato dal vivo durante la revisione**: a inizio lettura `lavoro` era al
   pin; **venticinque minuti dopo era cinque commit piu' avanti**, e il round non era nemmeno
   partito. Stavolta i due file erano identici: **e' andata bene per fortuna**. Chiuso col
   post-controllo + `Add-Content` sul referto (sezione ⑦).
2. 🔴 **CLASSE NUOVA 596** — la riga era stata **scritta da zero invece che diffata contro
   l'ultima sorella approvata**, e cosi' aveva **perso in silenzio tre protezioni gia' pagate**
   che `R207A`/`R207B` avevano: il post-controllo 166, l'avviso di classe 582 sul coltello
   differito, e `Out-Host` dopo `Format-Table`.
3. 🔴 **CLASSE 583** — il **numero** del tetto era giusto ma la **ricetta** no: mescolava un bound
   comprensivo di tempo morto con un moltiplicatore x4. Riderivata sulla ricetta di casa
   (base trasferita → x15-20) e **stampata dentro la riga**.
4. 🔧 Indurimenti a costo zero: `-Headers @{'User-Agent'=…}` → **`-UserAgent`** (su PS 5.1
   `User-Agent` e' un *restricted header*), e `Format-Table` → **`| Out-Host`**.

### 🚧 NON COPERTO — dichiarato, non nascosto
- **Windows PowerShell 5.1 non c'e' in questa sessione**: tutto girato su `pwsh 7.4.6`. Restano
  verificati **per lettura e per precedente**, non per esecuzione: l'ordine di `Format-Table`
  senza `Out-Host`, il binding di `-UserAgent`, `Split-Path -Leaf` su `/`.
- **`try{ $pr.WaitForExit() }catch{}` non ha timeout**: se lo `Stop-Process` fallisse, il tetto
  diventerebbe illimitato. 🔴 **Non corretto di proposito**: e' la forma **canonica** di classe 585,
  identica in `R207A`/`R207B`. Divergere in silenzio da una forma congelata e' peggio del difetto.
  👉 **Va riparata in TUTTE le righe insieme.** Segnalata, non fatta di nascosto.
- **Lo storico a tick e il tetto barre del bersaglio** non sono ispezionabili da qui: li verifica
  lo script a runtime (classe 160).
