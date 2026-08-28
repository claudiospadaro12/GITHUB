# 📬 G1-PAOLO — I TRE VALORI DELLA LIVE DEL 27/08 — **LA RIGA DA MANDARE**

**Che cos'è:** l'**ablazione a stella** sui **tre input** che la live di Paolo del
27/08 sera ha nominato e che **abbiamo già nel codice senza averli mai
misurati** — `InpAdxMin` (20 vs **25**), `InpEma2` (89 vs **50**), `InpUseStoch`
(ON vs **OFF**). Fonte: `risultati_archivio/ANALISI_LIVE_PAOLO_2026-08-27.md`
§3 e §10 (spunti **P1**, **P2**, **P5**).

> 🔴 **NON È UN ROUND DI MERITO E NON PROMUOVE NIENTE.** Misura **tre numeri**,
> non un metodo. **Nessuna sedia viva viene toccata**: i dieci magic sono
> **vergini** (blocco `778xxx`) e quelli del forward sono nella **lista dei
> vietati** del driver.
>
> 🚫 **E non è stato aggiunto nessun input a nessun EA.** Vedi §1 qui sotto: il
> disegno del round è cambiato **per non toccare quattro EA con una sedia viva**.

| | |
|---|---|
| **EA misurati** | `mql5/Experts/ABTG_SupertrendReversal.mq5` · `mql5/Experts/ABTG_SupertrendInvert.mq5` |
| **Driver** | `righe/RIGA_G1PAOLO.ps1` (marcatore `MARCATORE_RIGA_G1PAOLO_v1`) |
| **File prova** | `prove/G1PAOLO_00_suprev_base.txt` · `_01_suprev_ema50.txt` · `_10_invert_base.txt` · `_11_invert_adx25.txt` · `_12_invert_stochoff.txt` |
| **Criteri congelati** | `prove/REFERTO_PREPARAZIONE_G1PAOLO.md` ← **si legge PRIMA dei numeri** |

---

## 1️⃣ LA CORREZIONE DA LEGGERE PER PRIMA: **i tre input non stanno nello stesso EA**

Il mandato chiedeva **4 celle su un EA solo**. **Non si può fare.** Verificato
per grep nel sorgente il 28/08, file per file:

```
ABTG_SupertrendReversal.mq5  (+ _Ottimizzato, _Multi, DAX/DOW/NAS/CAC)   adx=0  ema2=2  stoch=0
ABTG_SupertrendInvert.mq5                                                adx=2  ema2=0  stoch=4
```

- **`InpEma2`** vive **solo** nella famiglia **SupRev**.
- **`InpAdxMin`** e **`InpUseStoch`** vivono **solo** in **`ABTG_SupertrendInvert`**.
- La famiglia SupRev **non ha** un filtro ADX né uno stocastico: **non sono
  spenti, non esistono**. E l'Invert non ha `InpEma2` (usa `InpEma50Period` /
  `InpEma200Period`, che è il filtro STRONG, un'altra cosa).

➡️ **Quindi: due motori, due baseline, 5 celle.** Stessa filosofia a stella (un
interruttore per volta contro la **propria** baseline), solo che le stelle sono
due. **Aggiungere un `InpAdxMin` ai SupRev per far tornare il disegno avrebbe
voluto dire modificare quattro EA con una sedia viva: non è stato fatto.**

---

## 🎯 LE CINQUE CELLE

### ⭐ Stella A — `ABTG_SupertrendReversal` su **XAUUSD H4**

| cella | file prova | delta | magic gemelli |
|---|---|---|---|
| **00_suprev_base** | `G1PAOLO_00_suprev_base.txt` | — baseline `InpEma2=89` | 778000 / 778001 |
| **01_suprev_ema50** | `G1PAOLO_01_suprev_ema50.txt` | **`InpEma2` 89 → 50** | 778100 / 778101 |

### ⭐ Stella B — `ABTG_SupertrendInvert` su **XAUUSD H1**

| cella | file prova | delta | magic gemelli |
|---|---|---|---|
| **10_invert_base** | `G1PAOLO_10_invert_base.txt` | — baseline ADX 20 · Stoch ON | 778300 / 778301 |
| **11_invert_adx25** | `G1PAOLO_11_invert_adx25.txt` | **`InpAdxMin` 20 → 25** | 778400 / 778401 |
| **12_invert_stochoff** | `G1PAOLO_12_invert_stochoff.txt` | **`InpUseStoch` true → false** | 778500 / 778501 |

Ogni cella differisce dalla **sua** baseline di **due righe sole**, e il driver
**lo verifica prima di aprire MT5**.

🥇 **Perché ORO**: `SupRev · XAUUSD H4` è la sedia SupRev **più forte a tick
reali** (`CLASSIFICHE.md`: PF 1,46 · DD 1,2% · magic 770921) e su oro H4 gira
proprio il **SupertrendReversal nativo**, cioè **l'EA dove vive `InpEma2`**.
Un valore che migliora un motore già forte è una notizia; **uno che lo peggiora
è una notizia più grossa**.

---

## 🏛️ DUE BANCHI, e sono dichiarati

| banco | modello | finestra | cosa dà |
|---|---|---|---|
| **S** | **1 — OHLC M1** | **2020.01.01 → 2026.06.30** | il **campione** (n≈208 sull'antenato R103/R114) e **quattro regimi** |
| **V** | **4 — TICK REALI** | **2024.07.05 → 2026.06.30** | il **riempimento vero** (spread, slippage, fill) |

Split **IS/OOS 40/60** ⇒ **quattro sotto-finestre per cella**.

> ⚠️ **Il banco S da solo NON autorizza nessuna proposta.** Lo scrive
> `walkforward_generico.ps1` alla sua riga 65: _"1 = OHLC M1: **SOLO screening,
> mai verdetti**"_. E il banco V ha i tick veri ma **campione sottile** (su oro
> H4 la misura agli atti è **n=44** contro i **150** dell'Emendamento regola A).
> **È per questo che ci sono tutti e due**, con la regola di concordanza del §5.1
> del referto di preparazione.

---

## 📌 IL PIN — **`c333d6d763b0cc3093011d3fadfc8fdf00077ec4`**

```
c333d6d763b0cc3093011d3fadfc8fdf00077ec4
```

⚠️ **Il pin si rilegge DOPO il push, non prima.** Il commit da pinnare deve
contenere **tutti e otto** gli artefatti: il driver, i **cinque** file prova, e i
**due** `.mq5` (`ABTG_SupertrendReversal.mq5`, `ABTG_SupertrendInvert.mq5`, che
il driver generico riscarica al pin).

La riga passa il pin a `-Pin` e **si rifiuta di partire senza**: un default
silenzioso (`lavoro`) farebbe girare la punta del branch spacciandola per un
commit congelato. Il driver **pinna anche `$EABranch` dentro
`walkforward_generico.ps1`**, altrimenti il pin varrebbe per il driver e **non
per gli EA misurati**.

### 🔧 LA RICETTA DEL PIN

```bash
F=backtest_pipeline/righe/RIGA_G1PAOLO_DA_MANDARE.md
SHA=<il commit vero, 40 caratteri>
TOK='@@PIN'"@@"
sed -i "s|\$pin='$TOK'|\$pin='$SHA'|g; s|^$TOK\$|$SHA|; s|\*\*\`$TOK\`\*\*|\*\*\`$SHA\`\*\*|g" "$F"
grep -c "\$pin='$SHA'" "$F"   # DEVE dare 3   <- i punti d'uso
grep -c "$TOK" "$F"           # DEVE dare 0   <- nessun segnaposto rimasto
```

⚠️ **Servono TUTTI E DUE i conteggi**: il solo *"0 segnaposto rimasti"* lo supera
a mani basse anche un `sed` che **non ha matchato niente**.

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** Col terminale aperto il tester non
  gira (zero CSV); con MetaEditor aperto la compilazione torna subito **senza
  compilare**. La riga si rifiuta di partire in tutti e due i casi.
- 🖥️ **UNA MACCHINA, UN LAVORO.** Il PC di backtest ha **un solo MT5**: prima di
  lanciare, niente altro deve stare girando nel tester.
- 🧩 **La riga installa `ABTG_PausaGuardian.mqh`** in `MQL5\Include` prima di
  compilare: tutti e due gli EA lo includono e `walkforward_generico.ps1`
  **non lo fa** (verificato: nel driver generico la stringa `PausaGuardian` non
  compare). Nel **tester** il Guardian è **fail-open totale** (le sue
  GlobalVariable non esistono): non altera nulla e i numeri restano
  confrontabili con quelli vecchi.
- **NESSUNA SEDIA VIVA VIENE TOCCATA.** Magic vergini `778xxx`,
  `AllowLiveTrading=false` negli `.ini` (lo scrive il driver generico).
- **40 passate** (5 celle × 2 banchi × 2 finestre × 2 gemelle), **20 CSV**,
  deposito **100.000**.
- **Zero parametri spazzolati.** L'unico asse `Y` è `InpMagic`, e il driver **si
  ferma** se in un file prova ne trova un secondo.
- 🔧 Se non è già stato fatto: MT5 → Strumenti → Opzioni → Grafici →
  **"Max barre nel grafico" = Illimitato** (il tetto delle 100.000 barre, R76).
- ⏱️ **Durata [STIMA, non una previsione]: 40-120 minuti** più le due
  compilazioni. Metà passate sono OHLC su 6,5 anni (veloci), metà **tick reali
  sull'oro** (i più lenti: l'oro ha molti più tick degli indici).

---

## 0️⃣ PASSO 0 — **RACCOMANDATO**: misurare la profondità **TICK** dell'oro

> 🔴 **La profondità TICK di XAUUSD NON È MAI STATA MISURATA in tutto il repo**
> (`R86_CRITERI.md` §2.0, `R87_CRITERI.md` §2.0). Il `2024.07.05` del banco V è
> la data **misurata su GBPUSD**, estesa per analogia: **[INFERITO]**.
> Se i tick dell'oro partissero **dopo**, **i numeri del banco V non si
> leggono** — è il **difetto n.18** della checklist di casa.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $s="$env:USERPROFILE\scarica_storico.ps1"; Remove-Item $s -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/scarica_storico.ps1" -OutFile $s;
    $global:LASTEXITCODE=0; & $s -Simboli "XAUUSD" -Da 2020.01.01 -Timeframes "M1,H1,H4" -Auto -TimeoutMin 240;
    if($LASTEXITCODE -ne 0){ Write-Host 'PASSO 0 NON RIUSCITO: leggi il referto prima di andare avanti' -ForegroundColor Yellow } }
```

📅 **La riga da leggere nel referto** è quella **`TICK`**, colonna
**`PrimaDataLocale`** — ⚠️ **non** `PrimaDataServer`: sulle righe `TICK` quella
colonna vale **sempre `-`** (misurato il 18/08 leggendo
`ABTG_HistoryDownloader.mq5` righe 229-232). Chi legge la colonna sbagliata
conclude che i tick non ci sono.

- Se `PrimaDataLocale` **≤ 2024.07.05** → si tira dritto.
- Se è **più recente** → si rilancia G1-PAOLO con `-DaTick <la data vera>` **e lo
  si scrive accanto ai numeri**.

⏱️ **`-TimeoutMin 240` è esplicito e voluto**: il default dello script è **90
minuti** e scaduto quello **ammazza MT5 a metà scaricamento uscendo con codice
0** (difetto n.19 della checklist). Scaricare i tick dell'oro può durare di più.

---

## 1️⃣ PRIMA il giro a vuoto (**nessuna passata, non apre MT5**)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='c333d6d763b0cc3093011d3fadfc8fdf00077ec4'; $p="$env:USERPROFILE\RIGA_G1PAOLO.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_G1PAOLO.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_G1PAOLO_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Cosa deve dire**, in ordine:

- `pin ......... <40 caratteri>` · `celle ....... 5 su 5` · `banchi ...... 2 su 2`;
- le due righe `banco S` (modello 1) e `banco V` (modello 4) con le loro date;
- la riga gialla sulla **profondità tick non misurata**;
- `driver generico scaricato e PINNATO`;
- `file prova scaricati: 5 su 5`;
- `include scaricato: ABTG_PausaGuardian.mqh (<n> byte)`;
- ✅ **`geometria, valori assoluti, stella e magic: TUTTI PASSATI (10 magic unici su 10)`**;
- `include: INSTALLATO in ...` — ⚠️ se dice **NON INSTALLATO** finisce nei
  **RILIEVI** e la compilazione passerà **solo se il file era già lì**;
- **dieci** volte l'anteprima dell'`.ini` del driver generico, e in fondo
  `ESITO: CONTROLLO COMPLETATO`.

> ⚠️ **Quello che il giro a vuoto NON può fare:** `-SoloControllo` **non apre
> MT5**. Non esiste nessun `n`, nessun PF, nessun DD, **nessun controllo sui
> gemelli**. Conferma gli **artefatti**, mai i numeri.

---

## 2️⃣ POI la corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='c333d6d763b0cc3093011d3fadfc8fdf00077ec4'; $p="$env:USERPROFILE\RIGA_G1PAOLO.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_G1PAOLO.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_G1PAOLO_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**: è **un comando solo**. Righe staccate sarebbero
comandi indipendenti, e un `throw` alla prima non fermerebbe le altre.

### 🔁 Se serve riprendere una cella sola, o un banco solo

> ⚠️ **Ogni ripresa è un BLOCCO INTERO, col suo `irm`.** `$p` e `$pin` nascono
> **dentro** il `& { ... }`, che è uno scope figlio: quando quel blocco finisce
> **non esistono più**.
>
> ⚠️ E **serve `-Rifai`**: `walkforward_generico.ps1` (riga 580) **salta i CSV
> già presenti** se non glielo si passa. Senza, la ripresa gira dieci secondi,
> rifà solo la raccolta e **stampa tutto verde senza aver rifatto niente**
> (difetto n.15 della checklist).

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='c333d6d763b0cc3093011d3fadfc8fdf00077ec4'; $p="$env:USERPROFILE\RIGA_G1PAOLO.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_G1PAOLO.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_G1PAOLO_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloCella '12_invert_stochoff' -SoloBanco 'V' -Rifai;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo' -ForegroundColor Yellow } }
```

⚠️ **Una ripresa di una cella sola NON produce i delta**: la riga dei delta ha
bisogno **anche della baseline** su quello stesso banco, e senza esce
`NON MISURABILE (manca una finestra)`. È voluto: meglio un `n/d` onesto di un
numero calcolato contro una baseline vecchia.

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul **Desktop**: `G1PAOLO_<MODO>_<data>_<ora>` — dentro:

- **`REFERTO_G1PAOLO.txt`** ← **è questo che conta**;
- i **file prova** delle celle che hanno girato;
- i **CSV** `<EA>_XAUUSD_IS[_ohlc]_<cella>_<banco>.csv` e `_OOS...`.
  ℹ️ Il `_ohlc` nel nome **c'è solo sul banco S**: lo mette il driver generico
  perché *"un OHLC non deve MAI sovrascrivere un tick reale"*.

### 📅 Le due righe da guardare per prime nel referto

1. **`modo:`** — dice `CORSA` (il risultato) o `CONTROLLO` (giro a vuoto:
   **non si manda come risultato**);
2. **`data:`** — **deve essere di ADESSO**.

---

## 🚩 COME SI LEGGE IL REFERTO — quattro avvertenze, non quattro note

1. 🔢 **Il primo numero è `n`, non il PF.** Vale soprattutto per la **stella B**:
   lo stato misurato dell'Invert è *"non opera"* (`REFERTO_CODA_FASCIA_B.md`
   riga 31: **0 trade su 10 TF su 11** su USDJPY). Se `n(10_invert_base) = 0`, il
   PF non esiste e le celle 11/12 sono un **conta-operazioni**. **`n=0` contro
   `n=0` non è un'ablazione: è una cella muta.**
2. 📉 **Il banco S è OHLC.** Da solo non autorizza nessuna proposta — l'illusione
   OHLC ha già revocato una promozione in questa casa (SupRev DOW H4).
3. ⚖️ **Il merito può restare sospeso, il rischio no.** Con `n` sotto soglia il
   **PF non si giudica**, ma la colonna **DD si legge sempre**: un drawdown è
   **un fatto accaduto**, non una stima (Emendamento regola B).
4. 🧭 **Un delta misurato su oro NON si estende** alle altre quattro sedie SupRev
   (Argento, DAX, Nikkei, Nasdaq). Quello è un round nuovo, non un corollario.

📖 **I criteri completi (esiti A/B/C/D e la regola di concordanza sulle 4
sotto-finestre) sono in `prove/REFERTO_PREPARAZIONE_G1PAOLO.md` §5, scritti
PRIMA dei numeri.** Il referto li applica da solo e stampa la lettera.

---

## ✅ COSA È GIÀ STATO VERIFICATO — **eseguendo**, prima dell'invio

- ✅ **ASCII puro**: 0 caratteri non-ASCII nel `.ps1` e in tutti e cinque i file
  prova (regola del 17/08: Windows PowerShell 5.1 legge i `.ps1` come ANSI);
- ✅ **struttura bilanciata**: 161 graffe aperte / 161 chiuse, 389 tonde aperte /
  389 chiuse, **zero righe con apici doppi dispari**; **nessun `$args`** usato
  come nome proprio (è una variabile automatica); **nessun backtick di
  continuazione seguito da spazi**;
- ✅ **i tre input verificati NEL SORGENTE**, non a memoria: `InpEma2` riga 64 di
  `ABTG_SupertrendReversal.mq5`, `InpAdxMin` riga 65 e `InpUseStoch` riga 69 di
  `ABTG_SupertrendInvert.mq5`, più il grep su tutta la famiglia SupRev che dà
  **adx=0 / stoch=0**;
- ✅ **i dieci magic cercati uno per uno** in tutto il repo: **zero occorrenze**;
- ✅ **i gate girati DAVVERO sui cinque file veri** (replica della stessa logica,
  eseguita): controllo positivo **passato — 5 celle, 10 magic unici**;
- ✅ **e i gate fatti FALLIRE, uno per uno** — un gate che non scatta mai non è
  dimostrato. **Tredici prove, tredici fermate**, ognuna col messaggio giusto:

  | corruzione | il gate ha detto |
  |---|---|
  | i due file SupRev **scambiati** | `'InpEma2' vale 89, atteso 50` |
  | baseline mossa (`InpUseConfluence` 1→0) | `'InpUseConfluence' vale 0, atteso 1` |
  | **corruzione SIMMETRICA** (`InpUseADX` 1→0 in **tutte e tre** le celle Invert) | `'InpUseADX' vale 0, atteso 1` |
  | magic **vietato** (770901, il sorgente SupRev) | `magic 770901 e' VIETATO` |
  | magic **duplicato** fra due celle | `magic 778300 usato in due celle` |
  | **secondo asse Y** | `deve avere ESATTAMENTE un asse Y, trovati 2` |
  | `@PERIODO` H1→H4 su una cella Invert (**trappola R102**) | `@PERIODO e' H4, atteso H1` |
  | una **riga in più** non dichiarata | `ha la riga 'InpTP_RR' che la baseline non ha` |
  | una **riga in meno** | `manca la riga 'InpEma3'` |
  | **parametro doppio** nello stesso file | `DUE righe per 'InpEma4'` |
  | il **delta non differisce più** | `'InpUseStoch' vale 1, atteso 0` |
  | `@SIMBOLO` XAUUSD→XAGUSD | `@SIMBOLO e' XAGUSD, atteso XAUUSD` |
  | `@DAQUANDO` inventata | `@DAQUANDO e' 2024.09.26, atteso 2020.01.01` |

  > 🔎 **La terza riga è la più importante.** Una riga storta **uguale in tutte le
  > celle** passerebbe il gate della stella — _"un diff fra A e B non può
  > accorgersi di niente che sia uguale in A e in B"_ (lezione R110). La prende
  > il **gate dei valori assoluti**, che confronta con un valore **dichiarato**
  > invece che con un altro file.

🟡 **Non verificato, e va detto senza giri di parole**:

- ⚠️ **il `.ps1` NON è stato fatto parsare da PowerShell.** In questo ambiente
  **non c'è né `pwsh` né `powershell`** (verificato). I controlli fatti sono
  **strutturali** (bilanciamento, ASCII, apici, backtick, `$args`) e la logica dei
  gate è stata provata con una **replica eseguibile**, non col file vero.
  **Il primo giro a vuoto è anche il collaudo della sintassi**: se il parser si
  lamenta, è lì che si vede, in un minuto e senza aprire MT5.
- ⚠️ **la compilazione dei due EA**: qui non c'è MetaEditor. Se fallisce, il
  risultato è quello e va riportato così com'è.
- ⚠️ **ogni singolo numero.** Il giro a vuoto copre gli artefatti; **i numeri li
  può dare solo la corsa.**
