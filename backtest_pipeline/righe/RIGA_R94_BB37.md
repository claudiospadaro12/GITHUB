# 🚀 RIGA DI LANCIO — R94: BOLLINGER 37/1.4 SUL BREAKING BAND

> ## ✍️ FIRMATO da Claudio il 21/08/2026: **"metro,frequenza, firmo r93, r94 lancia, e prepara jpy"**
> Criteri: `backtest_pipeline/risultati_archivio/R94_CRITERI.md` (firma in fondo).
> **Le soglie non sono state toccate dalla firma.**

> ## 🎯 LA DOMANDA NON E' "QUANTO RENDE"
> La famiglia gira su **n OOS di 11 / 13 / 26**: il **merito e' SOSPESO per
> dichiarazione**. R94 chiede una cosa sola: **la frequenza sale?**
> **Se non sale, il profitto non si guarda nemmeno.**

⚠️ **PC DI BACKTEST, MT5 CHIUSO. Mai sul VPS.**
⚠️ **UNA MACCHINA, UN LAVORO:** R92 e R93 devono essere **finiti**.

---

## 🧊 QUESTE RIGHE USANO `lavoro`, NON UN SHA — e il motivo e' misurato

`walkforward_generico.ps1` ha **`$EABranch="lavoro"` scritto fisso alla riga 91**
e riscarica il `.mq5` da `lavoro` HEAD **ignorando qualunque `-Rif`**; se il
download fallisce **ripiega in silenzio sulla copia locale** (difetto 24).
Un SHA in testa alla riga pinnerebbe **gli script e non il motore**.

Al suo posto, due cose che valgono davvero:
1. 🧊 **BRANCH CONGELATO: nessun push su `lavoro` mentre R94 gira.** Il driver
   riscarica l'EA a **ogni cella**: un push a meta' corsa cambierebbe il motore
   **fra una cella e l'altra**, e il confronto fra celle non misurerebbe piu'
   niente.
2. 🏷️ **MARCATORI DI VERSIONE** in ogni blocco (`R94-LANCIO-v1` nello script,
   `R94 -- BOLLINGER 37/1.4 SUL BREAKING BAND` in ogni file prova): coprono
   insieme la **cache di raw** (~5 minuti) e il download andato a male.

---

## 1️⃣ BLOCCO 1 — GIRO A VUOTO (non apre MT5, ~1 minuto)

```powershell
& { $ErrorActionPreference='Stop'; $p="$env:USERPROFILE\lancia_r94.ps1"; Remove-Item $p -EA SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/lancia_r94.ps1" -OutFile $p -EA Stop; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'R94-LANCIO-v1' -Quiet)){ throw 'SCRIPT VECCHIO: la cache di raw tiene ~5 minuti, riprova fra poco' }; $global:LASTEXITCODE=0; & powershell -ExecutionPolicy Bypass -File $p -Rif lavoro -SoloControllo; if($LASTEXITCODE -ne 0){ throw "GIRO A VUOTO FALLITO ($LASTEXITCODE): NON si lancia il round" }; Write-Host "`n=== GIRO A VUOTO OK: si puo' mandare il BLOCCO 2 ===" -ForegroundColor Green }
```

**Il giro a vuoto fa quattro cose che il driver da solo NON fa:**
1. verifica che **non esista un secondo artefatto** che descrive le stesse celle
   (difetto 33): cerca il nome dell'EA dentro `walkforward_generico.ps1` e
   **muore** se lo trova. Oggi le occorrenze sono **0** — misurato, non
   dichiarato: **il file prova e' l'unica descrizione delle celle, e il giro a
   vuoto legge lo STESSO file della corsa vera**;
2. legge gli **`#include`** dal sorgente e **li installa** verificando lunghezza
   e marcatore (difetto 33-bis: `ABTG_BreakingBand.mq5` include
   `<ABTG_PausaGuardian.mqh>`, e **nessun driver lo installa**);
3. 🔴 **COMPILA**, e questo e' il buco piu' grosso che chiude: il
   `-SoloControllo` di `walkforward_generico.ps1` **esce alla riga 503**, mentre
   la compilazione sta alla **riga 603**. Cioe' **il giro a vuoto del driver non
   compila**: un include mancante salterebbe fuori **a corsa avviata**. Qui si
   compila subito e si verifica che il `.ex5` sia stato **riscritto adesso**
   (coppia sorgente/binario, punto 27);
4. stampa le **6 anteprime `.ini`** con un nome proprio per cella (difetto 31:
   il driver le chiama tutte `anteprima_<EA>_<Simbolo>.ini`, e qui **due file
   prova hanno lo stesso EA e lo stesso simbolo** — senza questo ne resterebbe
   una sola e nessuno lo direbbe).

### 👀 COSA GUARDARE NELLE ANTEPRIME (trenta secondi, e sono decisivi)
| # | cosa | se e' sbagliato |
|---|---|---|
| 1 | `InpBBPeriod` = **20** in A20/B20/C20, **37** in A37/B37/C37 | se una P37 dice 20, **il round misura due volte la stessa cosa senza dirlo** |
| 2 | `InpBBDev` **unico** parametro con la sintassi start/step/stop | se ce ne sono due, non e' piu' "una variabile alla volta" |
| 3 | `InpPatternMode` = **2** GBPUSD · **0** EURUSD · **1** AUDUSD | il pattern sbagliato = un'altra sedia |
| 4 | `InpRiskPercent` = **1.0** | vedi la nota sul rischio qui sotto |
| 5 | `FromDate`/`ToDate` in **2024.09.26 → 2026.06.30**, stacco al **2025.06.09/10** | finestra diversa da R34 = canarino impossibile |
| 6 | `Deposit` = **100000** | a 10.000 **il canarino non torna** |

⚠️ La riga `Model=` dell'anteprima e' **scritta fissa a 4 dal driver**
(difetto 31): il modello vero e' quello passato dallo script (**4 = tick reali**).

---

## 2️⃣ BLOCCO 2 — LA CORSA (24 passate a tick reali) + RACCOLTA

```powershell
& { $ErrorActionPreference='Stop'; $p="$env:USERPROFILE\lancia_r94.ps1"; if(-not (Test-Path $p)){ throw 'manda prima il BLOCCO 1' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'R94-LANCIO-v1' -Quiet)){ throw 'SCRIPT VECCHIO' }; $global:LASTEXITCODE=0; & powershell -ExecutionPolicy Bypass -File $p -Rif lavoro; $rc=$LASTEXITCODE; $z="$([Environment]::GetFolderPath('Desktop'))\R94_BREAKINGBAND_BB37.zip"; if(-not (Test-Path $z)){ throw 'LO ZIP NON C E: la corsa non e arrivata alla raccolta' }; $eta=(New-TimeSpan -Start (Get-Item $z).LastWriteTime -End (Get-Date)).TotalMinutes; if($eta -gt 15){ throw ("ZIP STANTIO: ha " + [int]$eta + " minuti, non e di adesso") }; if($rc -ne 0){ Write-Host "ESITO PARZIALE: mandalo lo stesso, ma di' QUALE pezzo manca (lo scrive REFERTO_R94.txt)" -ForegroundColor Yellow }; Write-Host ("`nMANDA IN CHAT: " + $z) -ForegroundColor Cyan }
```

### ⏱️ Quanto dura
**Non lo so, e non lo invento.** Sono **24 passate a tick reali** su H1 forex,
finestra ~21 mesi. Si misura sulla **prima cella** (lo script stampa
`6.1) CELLA A20 ...` e poi passa alla 6.2): **tempo della prima × 6** e' la
stima onesta. Se la prima cella dura piu' di ~20 minuti, conviene fermarsi e
dirlo prima di impegnare la macchina per ore.

### 📦 I NUMERI ATTESI, DICHIARATI PRIMA
| artefatto | quanti |
|---|---|
| CSV dei risultati | **12** (6 file prova × 2 finestre), ognuno con **2 righe** = le 2 celle di deviazione |
| righe totali di risultato | **24** |
| anteprime `.ini` | **6** (una per file prova, nome proprio) |
| serie per-trade | best effort, `pertrade_r94*_*.csv` |
| log degli agent | best effort, cartella `log_agent` |
| referto | `REFERTO_R94.txt` con la data **di adesso** |
| criteri | `R94_CRITERI.md` viaggia dentro lo zip |

Lo zip e' `Desktop\R94_BREAKINGBAND_BB37.zip`. La riga **controlla da sola** che
esista e che **non sia stantio** (max 15 minuti): un artefatto di ieri letto come
di oggi e' gia' successo in questa casa (referto stantio del 17/08).

---

## 🐤 COSA SI LEGGE PER PRIMO — e non e' il profitto

1. **IL CANARINO.** Nei tre CSV `_r94a20` / `_r94b20` / `_r94c20` la riga con
   `InpBBDev=2.0` deve riprodurre **R34 al centesimo**:

| simbolo | IS | OOS |
|---|---|---|
| GBPUSD | +2.667,18 · PF 2,72613 · DD 1,6960 · **n=13** | +3.160,10 · PF 1,73020 · DD 3,4801 · **n=26** |
| EURUSD | +1.457,02 · PF 53,79058 · DD 0,7797 · **n=4** | +2.069,82 · PF 3,86266 · DD 1,2722 · **n=13** |
| AUDUSD | +1.291,32 · PF 47,99127 · DD 0,6753 · **n=5** | +1.840,67 · PF 2,74743 · DD 1,2695 · **n=11** |

   **Se non torna, il round si ferma li'** e si cerca il perche' prima di
   leggere qualunque altro numero — comprese le celle P37, che senza canarino
   non hanno termine di paragone.
   💡 **E il canarino e' anche il controllo dei dati**: se i tick fossero
   cambiati, corti o mancanti, quelle righe non tornerebbero. Per questo R94
   **non ha un passo 0 di scaricamento**: il controllo e' dentro il round.

2. **LA COLONNA `Trades`** — e' il cancello:

| simbolo | ✅ verde | 🟡 giallo | ❌ archiviata secca |
|---|---|---|---|
| GBPUSD | n OOS **≥ 60** | 27-59 | **≤ 26** |
| EURUSD | n OOS **≥ 30** | 14-29 | **≤ 13** |
| AUDUSD | n OOS **≥ 30** | 12-29 | **≤ 11** |

   **Regola d'insieme: deve salire su almeno 2 simboli su 3.** Uno solo che sale
   mentre gli altri due scendono e' **rumore**.

3. **IL DRAWDOWN**, che si legge **sempre, a qualunque n**: cancello **DD > 8%**.
   Un drawdown e' un fatto accaduto, non una stima.

4. **L'aspettativa dei trade AGGIUNTI** =
   `(Profit_cella − Profit_base) / (n_cella − n_base)`. Se e' **negativa**, la
   frequenza e' stata comprata con operazioni perdenti: **e' un peggioramento
   anche se n sale**.

5. **Il funnel `[BB-FUNNEL]`** nei `log_agent`, se ci sono: dice se i setup sono
   **diminuiti** o se sono stati **scartati alla porta** (tp / sl / rr / lotto).
   Per un round sulla frequenza e' il numero che spiega il numero.

---

## 💰 LA NOTA SUL RISCHIO — e' un'assunzione, non una firma

Claudio ha firmato **"lancia" senza pronunciarsi sul rischio**. Si resta
all'**1,0%**, e la ragione e' che R94 misura la **frequenza** contro la **base
gia' misurata** della famiglia, che gira all'1,0%: cambiare rischio renderebbe
il confronto **non comparabile**.

🔬 **E che il rischio non tocchi il conteggio operazioni non e' un'opinione: e'
stato verificato nel sorgente**, perche' in R92 un kill switch legato al rischio
aveva cambiato `n` senza che nessuno se ne accorgesse.

| possibile causa | verifica | esito |
|---|---|---|
| Guardian (pausa B1 / cap C1) | nel tester le sue GlobalVariable non esistono | 🟢 **fail-open, inerte** |
| kill switch di perdita giornaliera | `ABTG_BreakingBand` **non ne ha**: l'equity delle righe 463-469 e' **solo metrica** per `OnTester` | 🟢 nessuno |
| tetto posizioni | `InpMaxPositions=1` conta **posizioni**, non rischio | 🟢 indipendente |
| lotto che si azzera | riga 1133 `if(lot<=0)`: **contato dal funnel** (`lotto=`) | 🟡 **si legge nei log**: se e' 0, il rischio non ha tolto nemmeno un'operazione |

⚠️ **Claudio puo' ribaltare l'assunzione con una parola**: in quel caso la base
R34 va **rimisurata insieme alla cella**, e questa riga va rifatta.

---

## ⛔ COSA NON PUO' USCIRE DA R94, IN NESSUN CASO
- ❌ niente sul **merito**: con n OOS 11/13/26 e' **sospeso per dichiarazione**;
- ❌ **nessuna promozione, nessun deploy, nessun cambio di preset in forward**;
- ❌ se la frequenza non sale, **il profitto non si guarda nemmeno**.

---

## 🔎 COSA E' STATO VERIFICATO PRIMA DI SCRIVERE QUESTA RIGA
| controllo | strumento | esito |
|---|---|---|
| file prova conformi | `backtest_pipeline/controlla_prova.py` | ✅ **6 file, 12 celle, 24 passate, 0 problemi** |
| driver PowerShell | `backtest_pipeline/lint_ps1.py` | ✅ **0 problemi** |
| sintassi PowerShell | parser vero (`Parser::ParseFile`) | ✅ **0 errori** |
| ASCII puro nel `.ps1` | conteggio byte > 127 | ✅ **0** |
| estrazione degli `#include` | eseguita sul sorgente vero | ✅ trova `ABTG_PausaGuardian.mqh`, salta `Trade/Trade.mqh` |
| difetto 33 (secondo artefatto) | eseguito su `walkforward_generico.ps1` | ✅ **0 occorrenze** dell'EA nel driver |

> ⚠️ **Quello che NON e' stato verificato, e va detto:** questa riga **non e'
> mai stata eseguita su Windows**. Il parser conferma la sintassi, non il
> comportamento: percorsi, MetaEditor e MT5 esistono solo sulla macchina di
> Claudio. **Per questo il BLOCCO 1 esiste e va mandato per primo.**
