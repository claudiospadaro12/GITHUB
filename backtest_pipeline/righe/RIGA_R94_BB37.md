# 🚀 RIGA DI LANCIO — R94: BOLLINGER 37/1.4 SUL BREAKING BAND

> ## ✍️ FIRMATO da Claudio il 21/08/2026: **"metro,frequenza, firmo r93, r94 lancia, e prepara jpy"**
> Criteri: `backtest_pipeline/risultati_archivio/R94_CRITERI.md` (firma in fondo al file).
> **Le soglie non sono state toccate dalla firma.**

> ## 🎯 LA DOMANDA NON E' "QUANTO RENDE"
> La famiglia gira su **n OOS di 11 / 13 / 26**: il **merito e' SOSPESO per
> dichiarazione**. R94 chiede una cosa sola: **la frequenza sale?**
> **Se non sale, il profitto non si guarda nemmeno.**

> ### 🔁 VERSIONE **v3** — due verifiche, due bocciature, tutte e due utili.
> **Il disegno del round non e' mai cambiato**: 6 file prova, 12 celle, 24
> passate, stesse soglie, stesso canarino. Sono cambiate solo le **guardie**.
>
> **Dalla prima verifica (13 difetti) — le tre che valgono di piu':**
> 1. 🧊 **la cache del tester viene svuotata**, altrimenti il canarino veniva
>    **ripescato** invece che eseguito (§ il canarino, sotto);
> 2. 📢 **il funnel `[BB-FUNNEL]` NON e' disponibile in questo round**, e ora e'
>    scritto invece che promesso;
> 3. 🔒 **il congelamento del branch e' diventato una misura** (impronta SHA256
>    del sorgente, riconfrontata dopo ogni cella) invece di un post-it.
>
> **Dalla seconda (1 bloccante + 5) — quella che avrebbe fermato il round:**
> 4. 🚨 **la spia dei per-trade accusava di RIPESCAGGIO le celle SANE.**
>    `$ptPresi -eq 0` ha **due** cause, non una: oltre al ripescaggio c'e' la
>    **cella gia' fatta**, che il driver salta (`walkforward_generico.ps1:615`) e
>    che quindi **non riscrive i per-trade**. E la ripresa e' proprio quello che
>    questa riga **consiglia**: alla prima interruzione il referto avrebbe
>    scritto *"sospette di ripescaggio"* su **A20/B20/C20**, cioe' sulle tre
>    celle di **canarino**. Ora `SALTATA` e `NON GIRATA` sono due voci diverse;
> 5. ⏱️ **il gate dello zip e' ancorato all'ora di partenza del blocco**, non a
>    una finestra di 15 minuti: uno zip di venti minuti prima non passa piu';
> 6. 🧹 piu' guardia su **MetaEditor aperto**, perimetro della pulizia del
>    Desktop allineato a quello del riempimento con `-Solo`, e i **residui del
>    funnel** tolti da intestazioni e tabelle (non basta correggere dove il
>    difetto e' stato segnalato: va tolto **ovunque sia scritto**).

⚠️ **PC DI BACKTEST. Chiudi MT5 *E MetaEditor*.** Mai sul VPS.
⚠️ **UNA MACCHINA, UN LAVORO:** R92 e R93 devono essere **finiti**.

---

## 🧊 QUESTE RIGHE USANO `lavoro`, NON UN SHA — e adesso il congelamento e' MISURATO

`walkforward_generico.ps1` ha **`$EABranch="lavoro"` scritto fisso alla riga 91**
e riscarica il `.mq5` da `lavoro` HEAD **ignorando qualunque `-Rif`**; se il
download fallisce **ripiega in silenzio sulla copia locale** (difetto 24).
Un SHA in testa alla riga pinnerebbe **gli script e non il motore**: sarebbe una
sicurezza finta.

Al suo posto **tre** cose, e la terza e' quella che conta:
1. 🧊 **BRANCH CONGELATO: nessun push su `lavoro` mentre R94 gira.**
2. 🏷️ **MARCATORI DI VERSIONE**: `R94-LANCIO-v3` nello script,
   `R94 -- BOLLINGER 37/1.4 SUL BREAKING BAND` in ogni file prova. Coprono la
   **cache di raw** (~5 minuti) e il download andato a male.
3. 🔒 **L'IMPRONTA.** Un congelamento *dichiarato* e' un post-it, e R94 e' tutto
   un confronto **fra celle**. Lo script prende lo **SHA256 del sorgente** dopo
   la compilazione e lo **riconfronta dopo ogni cella** con la copia che
   `walkforward` si e' riscaricato (`src_prove\ABTG_BreakingBand.mq5`). Se
   cambia, **muore dicendo che qualcuno ha pushato a meta' corsa e che il
   confronto e' morto**. Costa zero e trasforma una promessa in una guardia.

---

## 1️⃣ BLOCCO 1 — GIRO A VUOTO (~1-2 minuti)

> 🚦 **Traffico di questo blocco:** **NON apre MT5**. **APRE MetaEditor** per
> compilare (per questo MetaEditor va chiuso prima: e' single-instance).
> Non tocca il Desktop, non cancella risultati di corse precedenti.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $p="$env:USERPROFILE\lancia_r94.ps1"; Remove-Item $p -EA SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/lancia_r94.ps1" -OutFile $p -EA Stop; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'R94-LANCIO-v3' -Quiet)){ throw 'SCRIPT VECCHIO (v1 o v2): la cache di raw tiene ~5 minuti, riprova fra poco' }; $global:LASTEXITCODE=0; & powershell -ExecutionPolicy Bypass -File $p -Rif lavoro -SoloControllo; if($LASTEXITCODE -ne 0){ throw "GIRO A VUOTO FALLITO ($LASTEXITCODE): NON si lancia il round" }; Write-Host "`n=== GIRO A VUOTO OK: si puo' mandare il BLOCCO 2 ===" -ForegroundColor Green }
```

**Il giro a vuoto fa quattro cose che il driver generico NON fa:**

1. **verifica che ci sia un solo artefatto** a descrivere le celle (difetto 33):
   cerca il nome dell'EA dentro `walkforward_generico.ps1` e **muore** se lo
   trova. Oggi: **0 occorrenze**, misurato — non dichiarato. Quindi il file
   prova e' l'unica descrizione, e **il giro a vuoto legge lo stesso file della
   corsa vera**;
2. **legge gli `#include` dal sorgente e li installa** (difetto 33-bis:
   `ABTG_BreakingBand.mq5` include `<ABTG_PausaGuardian.mqh>` e **nessun driver
   lo installa**);
3. 🔴 **COMPILA** — ed e' il buco piu' grosso che chiude, perche' **vale per
   tutti i round di questa casa** (punto 39): il ramo `-SoloControllo` di
   `walkforward_generico.ps1` apre alla **riga 503** e **esce con `exit 0` alla
   riga 538**, mentre la compilazione sta alla **riga 603** — 65 righe dopo.
   **Il giro a vuoto del driver non tocca il compilatore.** Qui invece si
   cancella il `.ex5` **prima**, si lancia MetaEditor e **si aspetta
   l'artefatto** (fino a 180 s), non il ritorno del processo: MetaEditor e'
   **single-instance**, e se ne gira gia' una copia il processo torna subito e
   il controllo fallirebbe **su una compilazione sana**;
4. stampa le **6 anteprime `.ini`** con un nome proprio per cella (difetto 31:
   il driver le chiama tutte `anteprima_<EA>_<Simbolo>.ini`, e qui **due file
   prova hanno stesso EA e stesso simbolo** — senza questo ne resterebbe una
   sola). **Le anteprime esistono SOLO in questo blocco** e restano in
   `%USERPROFILE%\r94\anteprime`: nello zip della corsa vera **non ci sono**, ed
   e' giusto cosi'.

### 👀 COSA GUARDARE NELLE ANTEPRIME (trenta secondi, e sono decisivi)
| # | cosa | se e' sbagliato |
|---|---|---|
| 1 | `InpBBPeriod` = **20** in A20/B20/C20, **37** in A37/B37/C37 | il round misurerebbe **due volte la stessa cosa** senza dirlo |
| 2 | `InpBBDev` **unico** parametro con la sintassi start/step/stop | non e' piu' "una variabile alla volta" |
| 3 | `InpPatternMode` = **2** GBPUSD · **0** EURUSD · **1** AUDUSD | pattern sbagliato = un'altra sedia |
| 4 | `InpRiskPercent` = **1.0** | vedi la nota sul rischio |
| 5 | `FromDate` = **2024.09.26** e `ToDate` = **2025.06.09** | ⚠️ **l'anteprima porta SOLO la gamba IS** (`walkforward_generico.ps1:517-518` scrive `$WF[0]`): se cerchi `2026.06.30` **non lo trovi, ed e' giusto cosi'**. Una data diversa da queste due = finestra diversa da R34 = canarino impossibile |
| 6 | `Deposit` = **100000** | a 10.000 **il canarino non torna** |

⚠️ **Ma l'anteprima non e' la prova del pin** (punto 34-bis, pagato ieri su R93):
**l'anteprima la scrive questo script**, quindi dira' `InpBBPeriod=37` comunque.
**Il pin si legge nella COLONNA DEL CSV** a fine corsa — vedi sotto.
⚠️ La riga `Model=` dell'anteprima e' **scritta fissa a 4 dal driver**
(difetto 31): il modello vero e' quello passato dallo script (**4 = tick reali**).

---

## 2️⃣ BLOCCO 2 — LA CORSA (24 passate a tick reali) + RACCOLTA

> 🚦 **Traffico di questo blocco:** **apre MT5** (una volta per cella),
> **svuota `Tester\cache`**, **cancella lo zip e la cartella `R94_*` del
> Desktop** all'inizio, e alla fine **riscrive lo zip**.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $p="$env:USERPROFILE\lancia_r94.ps1"; if(-not (Test-Path $p)){ throw 'manda prima il BLOCCO 1' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'R94-LANCIO-v3' -Quiet)){ throw 'SCRIPT VECCHIO (v1 o v2)' }; $t0=Get-Date; $global:LASTEXITCODE=0; & powershell -ExecutionPolicy Bypass -File $p -Rif lavoro; $rc=$LASTEXITCODE; $desk=@([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop')) | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1; if(-not $desk){ $desk=$env:USERPROFILE }; $z=Join-Path $desk 'R94_BREAKINGBAND_BB37.zip'; if(-not (Test-Path $z)){ throw ('LO ZIP NON C E in ' + $desk + ': la corsa non e arrivata alla raccolta') }; if((Get-Item $z).LastWriteTime -lt $t0){ throw ('ZIP STANTIO: e stato scritto alle ' + (Get-Item $z).LastWriteTime.ToString('HH:mm:ss') + ', PRIMA che questo blocco partisse (' + $t0.ToString('HH:mm:ss') + '): e di una corsa precedente') }; if($rc -ne 0){ Write-Host 'ESITO PARZIALE: mandalo lo stesso, ma di QUALE pezzo manca (lo scrive REFERTO_R94.txt)' -ForegroundColor Yellow }; Write-Host ("`nMANDA IN CHAT: " + $z) -ForegroundColor Cyan }
```

> 🖥️ **Il Desktop e' calcolato con gli STESSI quattro candidati del driver**
> (`GetFolderPath` → `%USERPROFILE%\Desktop` → `OneDrive\Desktop` → ripiego su
> `%USERPROFILE%`). Nella v1 la riga ne usava uno solo e il driver quattro: su
> un PC con OneDrive attivo la riga avrebbe cercato lo zip **dove non era** e
> avrebbe dichiarato fallita una corsa riuscita.

### 🔁 SE LA CORSA SI INTERROMPE — e come si legge la ripresa
**Si rimanda lo stesso BLOCCO 2.** Le celle gia' fatte vengono **saltate** (il
driver le riconosce dal CSV gia' presente, `walkforward_generico.ps1:615`): la
ripresa qui e' sana e va usata.
**`-Rifai` serve SOLO** se hai cambiato un file prova o l'EA — e in quel caso
rifa' tutto da capo.

> ⚠️ **Ma una cella saltata NON riapre MT5 e quindi NON riscrive i per-trade.**
> Nella v2 questo faceva scattare la spia del ripescaggio **su celle sane** —
> e siccome A20/B20/C20 sono le tre celle di **canarino**, il referto avrebbe
> accusato proprio il controllo per cui il round esiste. Ora il referto ha
> **due voci distinte**:
>
> | voce nel referto | vuol dire |
> |---|---|
> | `CELLE SALTATE (CSV gia' presente, NON rigirate in questo giro)` | 🟢 **normale in una ripresa.** I numeri di quelle celle vengono da un **giro precedente** |
> | `CELLE SENZA PER-TRADE FRESCO (sospette di RIPESCAGGIO dalla cache)` | 🔴 **da guardare.** La cella doveva girare e non ha lasciato traccia |
>
> 📌 **E c'e' una conseguenza sul canarino, scritta perche' non sfugga:** la
> cache viene svuotata **all'inizio di ogni giro**. Se una cella di canarino
> risulta **SALTATA**, il suo controllo vale **per il giro in cui e' girata**,
> non per questo. Per rifarla davvero: **`-Solo A20 -Rifai`**.

### ⏱️ Quanto dura
**Non lo so, e non lo invento.** Sono **24 passate a tick reali** su H1 forex,
finestra ~21 mesi. Si misura sulla **prima cella** (lo script stampa
`6.1) CELLA A20 ...`): **tempo della prima × 6** e' la stima onesta.

### 📦 I NUMERI ATTESI, DICHIARATI PRIMA
| artefatto | quanti |
|---|---|
| CSV dei risultati | **12** (6 file prova × 2 finestre), ognuno con **2 righe** = le 2 celle di deviazione |
| righe totali di risultato | **24** |
| serie per-trade | **12** (`pertrade_r94*_*.csv`) — e se ne manca una **e' un segnale**, vedi sotto |
| referto | `REFERTO_R94.txt`, con la data **di adesso** |
| criteri | `R94_CRITERI.md`, dentro lo zip |

> 📢 **La voce "log degli agent" NON e' in questa tabella, ed e' un fatto voluto**
> (punto 34-ter). Vedi la sezione sul funnel, sotto: **in questo round non c'e'
> niente da leggere li'**. Lo script li raccoglie lo stesso a best effort e
> **scrive il numero nel referto** (`log degli agent raccolti: 0`), cosi' lo zero
> si legge invece di dedurlo.

---

## 🐤 IL CANARINO — e perche' nella v1 **non misurava quello che prometteva**

### Il difetto, misurato sui file
La cella di canarino di R94 (GBPUSD, `InpBBPeriod=20`, `InpBBDev=2.0`,
`InpMinRR=0`, magic 772101, finestra 2024.09.26→2026.06.30, deposito 100k, tick
reali) **e' la stessa identica passata che R91 ha gia' calcolato il 21/08**:

> `risultati_archivio/r91_csv/ABTG_BreakingBand_GBPUSD_OOS_r91a.csv`, `Pass 0` →
> `Profit 3160.10 | PF 1.73020 | Equity DD 3.4801 | Trades 26`

E il sorgente dell'EA non si muove dal 20/08. **Con la cache piena MT5 l'avrebbe
RIPESCATA invece di eseguirla** — e una passata ripescata **non legge un tick**.
Il canarino sarebbe tornato al centesimo **anche con lo storico sparito**, mentre
le celle P37 (in cache non ci sono) avrebbero girato sui dati veri: **due misure
su due mondi diversi**, l'esatto contrario di cio' per cui il canarino esiste.

### Cosa fa la v2
Svuota **`Tester\cache`** (in entrambe le radici) prima della corsa, **a MT5
chiuso**, e **muore** se non ci riesce — perche' non riuscirci vuol dire che MT5
e' ancora aperto. ⚠️ **Solo `Tester\cache`. MAI `bases\<server>\ticks`**, che e'
lo **storico**: cancellarlo trasformerebbe un round di ore in una notte.

> 🔎 **DUE SPIE da guardare, e sono gratis:**
> - **se una cella di canarino torna in pochi secondi**, e' stata ripescata lo
>   stesso: si dice, non si legge come conferma;
> - **un pass ripescato non scrive i per-trade.** Lo script li ripulisce
>   **prima di ogni cella** e verifica che ricompaiano **freschi**: se non
>   compaiono, lo scrive nel referto (`CELLE SENZA PER-TRADE FRESCO`).
>   Nella v1 li ripuliva una volta sola all'inizio — e siccome l'EA li chiama
>   `abtg_trades_<EA>_<Simbolo>_<Magic>.csv` (riga 1521), **P20 e P37 dello
>   stesso simbolo scrivono lo stesso file**: se P37 non l'avesse riscritto, si
>   sarebbe copiato quello di P20 chiamandolo `pertrade_r94a37_*`.

### I numeri che devono tornare AL CENTESIMO
| simbolo | IS | OOS |
|---|---|---|
| GBPUSD | +2.667,18 · PF 2,72613 · DD 1,6960 · **n=13** | +3.160,10 · PF 1,73020 · DD 3,4801 · **n=26** |
| EURUSD | +1.457,02 · PF 53,79058 · DD 0,7797 · **n=4** | +2.069,82 · PF 3,86266 · DD 1,2722 · **n=13** |
| AUDUSD | +1.291,32 · PF 47,99127 · DD 0,6753 · **n=5** | +1.840,67 · PF 2,74743 · DD 1,2695 · **n=11** |

**Se non torna, il round si ferma li'.**

---

## 📍 DOVE SI GUARDA — nomi e POSIZIONI delle colonne

Verificate sul CSV di R91, che ha **la stessa intestazione**:

| colonna | n° | serve a |
|---|---:|---|
| `Profit` | **2** | l'aspettativa dei trade aggiunti |
| `Equity DD %` | **7** | il cancello del rischio (**DD > 8%**) |
| **`Trades`** | **8** | 🎯 **il cancello del round** |
| `InpBBPeriod` | **15** | 🔑 **qui si legge il pin**, non nell'anteprima |
| `InpBBDev` | **16** | 🔑 idem |

> ⚠️ **IL FORMATO: MT5 TRONCA GLI ZERI.** Nel CSV la deviazione **2.0 e' scritta
> `2`**, non `2.0` (la 1.4 resta `1.4`). **Chi cerca `2.0` non la trova e crede
> che il round sia rotto.** Verificato sul CSV di R91: `InpBBPeriod 20`,
> `InpBBDev 2`.

### Il cancello, per simbolo
| simbolo | ✅ verde | 🟡 giallo | ❌ archiviata secca |
|---|---|---|---|
| GBPUSD | n OOS **≥ 60** | 27-59 | **≤ 26** |
| EURUSD | n OOS **≥ 30** | 14-29 | **≤ 13** |
| AUDUSD | n OOS **≥ 30** | 12-29 | **≤ 11** |

**Regola d'insieme: deve salire su almeno 2 simboli su 3.** Uno solo che sale
mentre gli altri due scendono e' **rumore**.
E accanto a ogni riga va scritta l'**aspettativa dei trade aggiunti** =
`(Profit_cella − Profit_base) / (n_cella − n_base)`: se e' **negativa**, la
frequenza e' stata comprata con perdenti — **peggioramento anche se n sale**.

---

## 📢 IL FUNNEL `[BB-FUNNEL]` NON C'E' — detto prima di guardare

Nella v1 questa riga prometteva il funnel. **Era una promessa che non poteva
essere mantenuta**, per due motivi indipendenti:

1. `PrintFunnel()` gira dentro **`OnTester()`**, cioe' **sull'agente**, e
   `walkforward_generico.ps1` scrive **sempre `Optimization=1`**: in
   ottimizzazione quelle `Print` non finiscono da nessuna parte di leggibile.
   **R91, per leggere le righe `[BB]`, dovette fare una passata singola
   dedicata** con `Optimization=0`;
2. la v1 cercava i log in **due** radici, e gli agent locali stanno nella
   **terza** (`%APPDATA%\MetaQuotes\Tester\<id>\Agent-127.0.0.1-30xx\logs`). Il
   gemello della stessa famiglia (`righe/RIGA_NOTTE2_DUKA_R91.ps1`, riga 859)
   usava gia' tutte e tre: la riscrittura aveva **perso la sicurezza del
   gemello** (punto 9).

La v2 aggiunge la terza radice **e smette di promettere**: il conteggio finisce
nel referto, e **il cancello del round non dipende da li'** — si legge dalla
colonna `Trades` del CSV, che e' un dato e non uno schermo.

> 🔧 **Il lavoro vero, in coda:** portare i contatori del funnel in una
> **colonna** (`FrameAdd` → `OnTesterDeinit`, come fa R93). **Non si fa adesso:**
> a branch congelato **l'EA non si tocca**, e ricompilare il motore in mezzo a un
> confronto fra celle sarebbe peggio del problema che risolve.

---

## 💰 LA NOTA SUL RISCHIO — l'assunzione, e la prova che sta nel CODICE

Claudio ha firmato **"lancia" senza pronunciarsi sul rischio**. Si resta
all'**1,0%** perche' R94 misura la **frequenza** contro la **base gia' misurata**
della famiglia, che gira all'1,0%: cambiare rischio renderebbe il confronto
**non comparabile**.

🔬 **E che il rischio non tocchi il conteggio operazioni e' DIMOSTRATO NEL
SORGENTE**, non dedotto dai log — il che e' una fortuna, visto che in
ottimizzazione i log non si leggono:

> `LotByRisk`, **riga 1427**: `return(MathMax(mn,MathMin(mx,lot)));`
> **Il lotto e' agganciato al MINIMO DEL BROKER: `InpRiskPercent` non puo'
> azzerarlo.**

Quindi il ramo `lot<=0` (riga 1133) puo' scattare **solo** per `lossPerLot<=0`
(guasto dei dati di simbolo) o per `slDist<=0`, **gia' escluso alla riga 1100**
(`if(risk<=minDist){ cO_failSL++; ... return; }`). **La catena e' chiusa.**

| possibile causa | verifica | esito |
|---|---|---|
| Guardian (pausa B1 / cap C1) | nel tester le sue GlobalVariable non esistono | 🟢 fail-open, inerte |
| kill switch di perdita giornaliera | `ABTG_BreakingBand` **non ne ha**: l'equity delle righe 463-469 e' **solo metrica** per `OnTester` | 🟢 nessuno |
| tetto posizioni | `InpMaxPositions=1` conta **posizioni**, non rischio | 🟢 indipendente |
| lotto che si azzera | **riga 1427**: agganciato al minimo del broker | 🟢 **impossibile per costruzione** |

> ⚠️ **Il residuo vero, che nella v1 non era scritto da nessuna parte:** la
> guardia di **riga 1137** (`if(!ABTG_GuardiaIngresso(...)) return;`) esce
> **senza incrementare nessun contatore**. Nel tester e' inerte — ma se un giorno
> non lo fosse, **quell'uscita sarebbe MUTA**.

⚠️ **Claudio puo' ribaltare l'assunzione con una parola**: in quel caso la base
R34 va **rimisurata insieme alla cella**, e questa riga va rifatta.

---

## ⛔ COSA NON PUO' USCIRE DA R94, IN NESSUN CASO
- ❌ niente sul **merito**: con n OOS 11/13/26 e' **sospeso per dichiarazione**;
- ❌ **nessuna promozione, nessun deploy, nessun cambio di preset in forward**;
- ❌ se la frequenza non sale, **il profitto non si guarda nemmeno**.

---

## 🔎 COSA E' STATO VERIFICATO PRIMA DI RIMANDARE QUESTA RIGA
| controllo | strumento | esito |
|---|---|---|
| file prova | `controlla_prova.py` | ✅ **6 file, 12 celle, 24 passate, 0 problemi** |
| driver PowerShell | `lint_ps1.py` | ✅ **0 problemi** |
| sintassi PowerShell | parser vero (`Parser::ParseFile`) | ✅ **0 errori** |
| ASCII puro nel `.ps1` | conteggio byte > 127 | ✅ **0** |
| uso di variabili prima dell'assegnazione | scansione delle 15 variabili di stato | ✅ nessuno (e la collisione `$dest` fra due sezioni e' stata sciolta) |
| il canarino e' in cache? | letto il CSV di R91 | ✅ **si', ed e' per questo che la cache si svuota** |
| colonne e formato | letto il CSV di R91 | ✅ `Trades` col. 8, `Equity DD %` col. 7, `InpBBDev` col. 16 e vale **`2`**, non `2.0` |
| catena del rischio | letto il sorgente | ✅ chiusa alla riga 1427 |
| radici dei log | confrontate col gemello R91 | ✅ tre, non due |

> ⚠️ **Quello che NON e' verificato, e va detto:** questa riga **non e' mai stata
> eseguita su Windows**. Il parser conferma la sintassi, non il comportamento:
> percorsi, MetaEditor e MT5 esistono solo sulla macchina di Claudio.
> **Per questo il BLOCCO 1 esiste e va mandato per primo.**
