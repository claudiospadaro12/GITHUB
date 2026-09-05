# 🎯 RELATIVO — **R117BIS: LA STESSA CELLA, MISURATA SULLA FINESTRA PIÙ LUNGA CHE ESISTE** (la riga da mandare)

> ## ⚠️ QUI L'EA APRE ORDINI.
> Gira `ABTG_Relativo`, lo stesso `.ex5` di R117: **manda ordini veri, calcola
> lotti, ha un magic e mette stop loss sul broker**. Nel tester non si rischia
> niente, ma quel file **non va messo su un grafico per sbaglio**.

**La domanda del round, in una riga:**

> *Con il motore CONGELATO e la finestra allungata di due mesi e divisa a metà,
> il campione basta per giudicare il MERITO di NASUSD — e l'incoerenza IS/OOS di
> R117 resta in piedi quando i due campioni hanno la stessa taglia?*

---

## 🔴 LA COSA PIÙ IMPORTANTE, E VA LETTA PRIMA DI TUTTO IL RESTO

**A6 (n ≥ 150 in IS *e* in OOS) NON È RAGGIUNGIBILE su NASUSD con lo storico che
esiste oggi. Non lo diventa spostando lo split, e non lo diventa allungando la
finestra fin dove si può.** L'aritmetica, tutta da numeri **misurati** in R117:

| | |
|---|---:|
| R117 IS: 87 operazioni su 183 giorni feriali | **0,475 op/giorno** |
| R117 OOS: 154 operazioni su 276 giorni feriali | **0,558 op/giorno** |
| media pesata | **0,525 op/giorno** |
| servono 150 + 150 = 300 operazioni → 300 / 0,525 | **567 giorni feriali** |
| dal pavimento `2024.09.26` a oggi (05/09/2026) ce ne sono | **503** |
| **mancano** | **64 feriali ≈ 3 mesi di calendario** |

E **il pavimento non si abbassa**: BCM sugli indici parte dal **26/09/2024** ed è
**dichiarato COMPLETO dal broker** (`RIGA_STORICO_INDICI`: *"il broker non ha di
più"*); lo storico esterno `_EXT` è **in frigo** perché il **CANCELLO ZERO** è
chiuso (diff media H1 0,061–0,101% contro ≤ 0,05% richiesto).

> 🧮 **E lo split è un gioco a SOMMA ZERO.** Quello che si toglie all'OOS si dà
> all'IS. Con 503 feriali il massimo ottenibile è **min(n_IS, n_OOS) ≈ 133**, non
> 150. Volendo si potrebbe portare l'IS a 150 — ma allora l'OOS scende a ~106.
> **Non esiste una divisione che soddisfi A6 su questo storico.**
>
> 📅 **Conseguenza pratica, e utile:** alla frequenza misurata i 567 feriali
> cadono intorno al **27/11/2026**. **A6 si soddisfa da sola aspettando**, e
> rifacendo *questa stessa corsa* a inizio dicembre con `@FINOA 2026.11.30`.

### Allora perché girare adesso? Per tre cose che R117 non ha potuto dare

1. 🧪 **A3 su due campioni BILANCIATI.** In R117 l'IS aveva 87 operazioni e l'OOS
   154: un'incoerenza di segno fra campioni di taglia così diversa **può essere
   rumore**. A ~126 contro ~140 la domanda diventa leggibile.
2. 📦 **IL CAMPIONE UNITO (A6b).** IS e OOS sono due finestre **contigue e non
   sovrapposte** della **stessa** configurazione congelata: le operazioni si
   sommano legittimamente → **~266 ≥ 150**. È **una PROPOSTA, non un cancello
   firmato** (vedi sotto).
3. 📈 **Due mesi di mercato** (luglio–agosto 2026) che **nessun round ha mai
   visto**, nemmeno il passo 0.

---

## 📋 COSA CAMBIA RISPETTO A R117 — **tre righe, tutte dichiarate**

| | R117 | **R117BIS** |
|---|---|---|
| `@DAQUANDO` | 2024.09.26 | **2024.09.26** (identico: è il pavimento misurato) |
| `@FINOA` | 2026.06.30 | 🆕 **2026.08.31** (+62 giorni = +44 feriali) |
| `FrazioneIS` | 0,40 | 🆕 **0,50** |
| magic | 774602 / 774612 | 🆕 **774621 / 774631** (ombre 774671 / 774681) |
| **la cella** | N=40 · σ=1,35 · SL 2,75×ATR · rischio 0,65% · 5 trade/gg | **IDENTICA, carattere per carattere** |
| **l'EA** | `ABTG_Relativo` v1.03 | **LO STESSO BLOB** (`f24ff688…`, verificato) |

> 🔒 **IL MOTORE NON È STATO TOCCATO DI UNA RIGA.** L'unica cosa che si muove in
> questo round è la **finestra di misura**.

### Perché lo split può cambiare **qui**, e altrove no

Il 40/60 è il default di casa e serve dove **l'IS SCEGLIE** qualcosa (una cella
su una griglia) e l'OOS verifica quella scelta. **Qui non si sceglie niente:** la
cella è congelata *prima* del round, non c'è nessuna griglia, e IS e OOS sono
**due campioni indipendenti della stessa configurazione** (lo dice già il prova
di R117, testualmente). In quel caso lo split giusto è quello che **massimizza la
taglia della metà più piccola**, cioè **50/50** — che è anche il valore **da
manuale**, non un numero pescato provando.

### E perché i magic sono nuovi (non è estetica)

774621/774631 al posto di 774602/774612: così **un CSV di R117 non può essere
letto come se fosse di R117BIS**. Il gate *"IL PIN DEL MAGIC NON È PASSATO"* lo
pesca da solo. Blocco `7746xx` verificato vergine, nessuna collisione con le
dodici etichette di R117.

---

## 🚦 DUE CORSE, NON SEI (e il perché di ogni assenza)

| # | `-Prova` | magic | magic OMBRA | ruolo |
|---|---|---:|---:|---|
| 2 | `NAS` | 774621 | 774671 | **la misura** |
| 3 | `NAS_GEM` | 774631 | 774681 | **gemello di determinismo** |

### ❌ **D30EUR non c'è**, ed è una scelta dichiarata

È **BOCCIATA PER RISCHIO** in R117: **DD 25,01%** contro un muro prop del 10%,
**peggior giornata −5,20%** contro −5,0%, E OOS −0,267R, PF 0,452.
L'**Emendamento della Finestra, regola B**: *il giudizio di RISCHIO non si
sospende mai e non dipende da n.* **Allargare la finestra non può riabilitare una
gamba bocciata lì** — e rifarla costerebbe ore di tick reali per riconfermare un
verdetto già pieno. Chi legge i referti di questo round **non può concludere
niente su D30EUR**.

### ❌ **Il collaudo del porto non si riesegue**, ed è l'altra scelta dichiarata

Il porto confronta i `Segnali Grezzi` dell'EA con gli `Attraversamenti Grezzi`
**misurati dal passo 0** — e quel riferimento (NASUSD **L=1506, S=1431**, su 450
giorni contati) esiste **SOLO** per la finestra `2024.09.26 → 2026.06.30`.
Sulla finestra nuova **quel numero non esiste**: farci girare un PORTO sarebbe un
**collaudo che non confronta niente**, cioè esattamente il difetto che la v3 di
R117 ha chiuso.

> 🔴 **QUINDI IL PORTO SI EREDITA DA R117, ED È UN PREREQUISITO.**
> Stesso EA (**stesso blob**, `f24ff688…`), stessa cella congelata, finestra dove
> il riferimento c'è.
> **Se la corsa `NAS_PORTO` di R117 (pin `c78a519…`) non è mai arrivata in fondo,
> questo round non si legge: si rifà prima quella, con la riga R117.**
> Nessuno script può verificarlo da qui — è scritto, e va confermato a mano.

Al suo posto gira un **CONTROLLO DI COERENZA**, che il referto **non chiama
collaudo**: la *densità di attraversamenti al giorno* misurata qui contro quella
del passo 0 (6,527/gg). Sopra il **15%** di scostamento è un **RILIEVO da
spiegare**, non una bocciatura.

### ✅ Il gemello resta, e il perché non è burocrazia

Due passate con gli **stessi input** e **magic diverso** devono venire
**identiche al centesimo**. Se divergono, il banco è sporco e **nessun numero di
questo round vale, per bello che sia.** Il confronto lo fa a macchina la
**seconda corsa della coppia** (il CSV della prima è già in workdir): per questo
**l'ordine dei blocchi 2 → 3 non si inverte**, e **fra i due non si svuota la
cartella di lavoro** (classe 136-bis).

> 🆕 In più, **ogni** corsa porta il suo **gemello INTERNO** gratis: l'**asse
> tecnico** su `InpMagic` a 2 celle (classe 134) fa due passate economicamente
> identiche per finestra. Senza quell'asse MT5 esegue **zero** passate e i CSV
> escono **da 0 byte** — è successo davvero il 05/09.

---

## 📏 I CANCELLI, **IDENTICI A R117 E NON RITOCCATI**

Stanno **nella riga di lancio e nella pagina, NON dentro l'EA**. E **non si
spostano perché il round precedente non li ha passati**: *i criteri si cambiano
prima dei numeri, mai dopo.*

| # | soglia | da dove esce |
|---|---|---|
| **A1** | `E` OOS **≥ 0,075 R**, a tick e al netto dei costi | FIRMA 2 del 31/08 (cancello H8) |
| **A2** | PF OOS **≥ 1,15** | cancello storico 1,10 + margine di rumore |
| **A3** | segno del profitto **coerente** fra IS e OOS, e **PF IS > 1,00** | lezione USDJPY di R20 |
| **A4** | DD equity OOS **≤ 8,0%** a rischio 0,65% | muro prop 10% meno il 20% |
| **A5** | peggior giornata **non peggiore di −4,0%** | a 4,0% il Guardian mette in pausa |
| **A6** | **n ≥ 150** in IS **e** in OOS | Emendamento della Finestra, regola A |
| **A7** | quota sotto 60 s **< 25%** | vincolo prop P5. A M5 **deve** venire 0,00 |

**Bocciatura secca (basta una):** `E` < 0,050R · PF < 1,10 · IS negativo ·
**DD > 10,0%** · **peggior giornata < −5,0%**.
🔴 **Le ultime due bocciano PER RISCHIO, qualunque sia il PF e qualunque sia `n`.**
`n < 30` **non è una bocciatura**: è **non misurabile**.
Fra "passa" e "bocciata secca" c'è **sempre** una **zona morta** esplicita.

### 🆕 **A6b — IL CAMPIONE UNITO: È UNA PROPOSTA, NON UN CANCELLO FIRMATO**

A6 nasce dove l'IS **sceglie**, e serve a non far scegliere sul rumore. Qui non si
sceglie niente e le due finestre sono contigue e non sovrapposte: le operazioni si
**sommano** legittimamente. Il referto stampa, in un **blocco separato**:

- **n unito** (IS + OOS);
- **`E` unita**: media pesata per `n` — **esatta**, perché `E` è già una media per
  operazione;
- **PF unito**: **ricostruito dai lordi** (`GL = Netto/(PF−1)`, poi si sommano).
  Se una gamba ha PF troppo vicino a 1,00 il referto scrive **NON RICOSTRUIBILE**
  invece di stampare un numero instabile;
- **peggior giornata unita**: il **minimo** dei due — **esatto**, perché una
  giornata non attraversa la giuntura.

> 🔴 **E IL DRAWDOWN UNITO NON SI CALCOLA E NON SI STIMA.** Sono due corse
> separate con due curve di equity separate: un drawdown a cavallo della giuntura
> **non lo vedrebbe nessuna delle due**. Il DD che vale resta quello **della
> singola gamba**, ed è un **limite inferiore** del vero. Il **rischio si giudica
> lì**, e non si sospende mai.
>
> ⚖️ **A6b NON entra nel verdetto, NON può trasformare un `MERITO SOSPESO` in un
> `PASSA`, e la firma — se arriverà — è di Claudio.**

E accanto c'è un secondo blocco nuovo, **QUANTO STORICO SERVIREBBE PER A6**, che
rifà l'aritmetica di sopra **sui giorni contati davvero da questa corsa** invece
che sulla proiezione.

---

## 🚫 COSA QUESTO ROUND **NON** POTRÀ DIRE

1. ❌ **"Regge nel tempo".** Un solo regime (toro). Emendamento regola C: **non
   soddisfatta**. → **Da questo round NON esce una sedia**, al massimo una
   **candidata**.
2. ❌ **"A6 è soddisfatto".** Non lo sarà: è aritmetica, non sfortuna.
3. ❌ **"L'OOS lo conferma".** L'OOS **non è un vero out-of-sample**: la cella è
   stata scelta guardando una misura che copre quasi tutta questa finestra.
   L'unico pezzo mai guardato dal passo 0 è **luglio–agosto 2026: 44 feriali su
   ~503**. L'unico vero out-of-sample sarà il **forward demo**.
4. ❌ **"È un test indipendente da R117".** Le due finestre si sovrappongono per
   **circa il 91% dei giorni**. Se un numero si muove, si muove perché la
   **giuntura IS/OOS si è spostata** e per i due mesi in coda — **non** perché il
   motore sia cambiato: il motore non è stato toccato.
5. ❌ **"D30EUR è recuperabile"**: non è in questo round, e la regola B dice che
   non lo diventa allargando la finestra.

---

| | |
|---|---|
| **Driver** | `righe/RIGA_RELATIVO_R117BIS.ps1` (marcatore `MARCATORE_RIGA_RELATIVO_R117BIS_v1`) |
| **Script comune** | `backtest_pipeline/walkforward_generico.ps1` — scaricato **AL PIN** dal driver. **Blob IDENTICO** a quello di R117 (`b99b7459…`) |
| **EA** | `mql5/Experts/ABTG_Relativo.mq5` **v1.03** — **BLOB IDENTICO** a R117 (`f24ff688…`): **già compilato due volte con 0 errori e 0 warning**. Si ricompila lo stesso a ogni corsa, ed è giusto così |
| **File prova** | i 2 `prove/RELATIVO_R117BIS_*.txt` (scaricati tutti e due, ne gira uno: l'altro serve al gemellaggio) |
| **Banco** | **Modello 4 = OGNI TICK, TICK REALI**. Finestra **2024.09.26 → 2026.08.31**, split **50/50** |
| **Dove** | **PC di backtest**, non VPS. **MT5 e MetaEditor CHIUSI** |
| 🔴 **RAM** | **MASSIMO 4 AGENTI.** A tick reali il vincolo vero non è il tetto delle barre, è la memoria (lezione del 01/09: *"no memory for ticks generating"* con 8 agenti su 16 GB). **La riga non può imporlo: lo imposti tu nel tester.** |
| 🔴 **Prima di lanciare** | **apri in MT5 i grafici di NASUSD e U30USD M5 e falli scorrere indietro**, così lo storico (gamba **e metro**) è nel terminale **fino ad agosto 2026**. Senza il metro ogni barra risulta "spaiata" e il referto misura la configurazione invece del mercato. Poi **richiudi MT5** |
| **Workdir** | `%USERPROFILE%\abtg_relativo_r117bis` — **separata** da quella di R117 |

⏱️ **Quanto ci mette [STIMA, non una misura]:** due corse invece di sei, ognuna 2
passate × 2 finestre = **4 pass**. Rispetto a R117 il carico è **un terzo**. Ma a
tick reali resta lungo: **mettici il tempo che ci mette**, e se sembra bloccato
guarda che il tester stia macinando invece di fermare tutto. Il referto porta
l'**ora di avvio**, non quella di fine, apposta.

---

## 📌 IL PIN — **`48b035cf677913990b26bb125c974924d2d58e08`**

**Verificato uno per uno con `git ls-tree` sul pin e `curl` sui `raw`** (HTTP 200
+ sha256 del raw **identico al blob del repo**, **6 su 6**):

| file al pin | cosa è stato verificato |
|---|---|
| `backtest_pipeline/righe/RIGA_RELATIVO_R117BIS.ps1` | 200 + sha256 identico (`d96b20f7…`) · marcatore `MARCATORE_RIGA_RELATIVO_R117BIS_v1` · **ASCII puro (0 byte > 126)** · **parse pwsh 7.4: 0 errori** · **0 usi di `$r` dopo la nascita di `$R`** (classe 79, scanner AST `-CaseSensitive`) |
| `backtest_pipeline/walkforward_generico.ps1` | 200 + sha256 identico · **blob IDENTICO a quello di R117** (`b99b7459…`): nessun round precedente cambia |
| `mql5/Experts/ABTG_Relativo.mq5` | 200 + sha256 identico · **blob IDENTICO a quello di R117** (`f24ff688…`) · `#property version "1.03"` · **20** blocchi autotest · `ABR_NSTATS` 73 (**76 colonne**) · **28** input · **1** `#include` · **0** pattern per simbolo (hedge-safe) · **ASCII puro** |
| i **2** `backtest_pipeline/prove/RELATIVO_R117BIS_*.txt` | 200 tutti e due · **ASCII puro** · blocco parametri **identico riga per riga**, unica differenza `InpMagic` |
| `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` | 200 + sha256 identico · **classe 138** nuova (il tetto barre si misura sulla **gamba**, non sulla finestra intera) |

> 🔒 **LA CELLA FIRMATA NON È STATA TOCCATA.** `InpFinestraN=40`,
> `InpSogliaIngressoSigma=1.35`, `InpAtrSL=2.75`, `InpMaxTradesPerDay=5`,
> `InpRiskPercent=0.65`: **identici a R117**, in tutti e due i prova.
> Cambiano solo `@FINOA` e `InpMagic`.

### 🆕 CLASSE 138 — il tetto barre di R117 misurava il numero sbagliato

R117 confrontava col tetto (~475 giorni a M5) i **642 giorni della finestra
intera**, e da lì nasceva l'obbligo di `-AccettoTettoBarre` in **tutte e sei** le
corse. Ma il generico **non lancia mai la finestra intera**: la spezza e lancia
**due passate separate** (a 40/60 erano **256** e **386** giorni, **tutte e due
sotto il tetto**). Il tetto **non ha mai morso**, e nessuno lo sapeva perché il
gate guardava la somma.

> ⚠️ **Perché conta:** un'eccezione chiesta *sempre* smette di essere
> un'eccezione. Il giorno in cui il tetto morde davvero, quel flag non avvisa più
> nessuno.

In R117BIS il gate misura **la gamba più lunga** e stampa **entrambi** i numeri:

```text
DENTRO IL TETTO -- M5: finestra intera 704 giorni (1.93 anni), spezzata in
IS 352 + OOS 352 -> GAMBA PIU' LUNGA 352 giorni (0.96 anni) contro ~475 di tetto
```

E se `-AccettoTettoBarre` viene passato quando non serve, il referto lo dichiara
**INERTE** invece di lasciarlo credere decisivo. **Nelle righe qui sotto lo
passiamo lo stesso**: costa niente ed è dichiarato, e se per qualunque motivo il
tetto mordesse la corsa non si fermerebbe a metà notte.

### 🧪 E LA RIGA È STATA **ESEGUITA**, NON SOLO LETTA (banco pwsh 7.4.6)

| prova a banco | esito |
|---|---|
| `GateProva` sui **due** prova veri, al pin | **PASSATI 2/2**, `celle=2` ciascuno, asse `{InpMagic}` |
| `GateGemelli` a due | `VALIDO: … differenze DICHIARATE trovate: InpMagic` |
| **controprova** `InpMagic` a valore **secco** | **RIFIUTATO**: *"assi Y = {}, atteso ESATTAMENTE uno…"* |
| **controprova** magic ombra **+1** invece di **+50** | **RIFIUTATO**, con la forma attesa stampata |
| **controprova** asse a **3 celle** | **RIFIUTATO**: *"ha 3 celle invece di 2"* |
| **controprova** un **secondo asse** (`InpAtrSL` sweepato) | **RIFIUTATO**: *"assi Y = {InpAtrSL, InpMagic}…"* |
| **controprova** `@FINOA` rimessa a **2026.06.30** | **RIFIUTATO**: *"la finestra si dichiara nel prova, non si eredita dal default"* |
| **controprova** cella toccata (`InpFinestraN=45`) | **RIFIUTATO** |
| **controprova** rischio toccato (`InpRiskPercent=1.00`) | **RIFIUTATO** |
| **controprova** riga estranea (`InpPippo=1`) | **RIFIUTATO**: *"NON è un input di ABTG_Relativo"* |
| **controprova** un **prova di R117** dato in pasto alla riga nuova | **RIFIUTATO** sulla finestra |
| cancelli di merito, **caso sano** (n 160/170) | `PASSA TUTTI I CANCELLI A` |
| cancelli di merito, **caso atteso** (n 126/140, IS in perdita) | `MERITO SOSPESO (si legge SOLO il rischio, e il rischio non è rosso)` |
| cancelli di merito, **DD 11,5% + peggior giornata −6,2%** con n piccolo | **BOCCIATA PER RISCHIO** — è la regola B che morde |
| blocco **CAMPIONE UNITO**, caso sano | n 266, `E` pesata, PF ricostruito dai lordi, DD dichiarato **non calcolabile** |
| blocco **CAMPIONE UNITO**, gamba con **PF ≈ 1,00** | `NON RICOSTRUIBILE`, invece di un numero instabile |
| blocco **CAMPIONE UNITO**, **senza gamba OOS** | `NON CALCOLABILE`, nessun `$null` dereferenziato |
| blocco **QUANTO STORICO SERVIREBBE** | *"MANCANO 63 giorni di mercato ~ 2,98 mesi"*, coerente con la proiezione di questa pagina |
| **CONTROLLO DI COERENZA**, finestra piena | *"densità coerente col passo 0 entro il 15%"*, 0 problemi |
| **CONTROLLO DI COERENZA**, **coda mancante** (450 giorni invece di ~490) | `PROBLEMA: FINESTRA EFFETTIVA PIÙ CORTA DEL 10%` |

> 🚧 **NON COPERTO dal banco**, e va dichiarato: la **compilazione** in MetaEditor
> (qui non c'è), la **corsa vera** di MT5 a tick reali, **Windows PowerShell 5.1**
> (qui il parse è su pwsh 7), la **scelta del terminale**, e il fatto che MT5
> produca davvero **due righe per CSV**. 📌 Di questi, la compilazione di
> **questo esatto blob** è già passata **due volte** in R117 (0 errori, 0
> warning): è un fatto acquisito, non una promessa.

---

## 1️⃣ Giro a vuoto (`-SoloControllo`)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='48b035cf677913990b26bb125c974924d2d58e08'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_RELATIVO_R117BIS.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_RELATIVO_R117BIS.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_RELATIVO_R117BIS_v1' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova NAS -SoloControllo -AccettoTettoBarre; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'RELATIVO_R117BIS_NAS_CONTROLLO_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP RELATIVO_R117BIS_NAS_CONTROLLO_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI o FERMATA: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'GIRO A VUOTO: guarda solo che i DUE gate passino e che la COMPILAZIONE riesca. NON ci sono numeri qui dentro.' -ForegroundColor Yellow;
    Write-Host 'DA CONTROLLARE IN QUESTO GIRO: la riga "tetto barre:" deve dire DENTRO IL TETTO con GAMBA PIU'' LUNGA 352 giorni (classe 138).' -ForegroundColor Cyan;
    Write-Host 'E "anteprima .ini (solo CONTROLLO):" deve dire FRESCA con 28 righe Inp*, e "passate:" deve dire 2 PASSATE PER FINESTRA. Se dice 1, l''asse tecnico su InpMagic non c''e'' e i CSV usciranno da 0 byte.' -ForegroundColor Cyan }
```

## 2️⃣ `NAS` — la misura su NASUSD (magic 774621)

> 🔴 **PRIMA DI LANCIARE:** apri MT5, metti a grafico **NASUSD M5** e **U30USD
> M5**, falli scorrere indietro fino a settembre 2024 così lo storico si scarica,
> **poi CHIUDI MT5**. Se il metro non c'è, il referto misura la configurazione
> invece del mercato.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='48b035cf677913990b26bb125c974924d2d58e08'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_RELATIVO_R117BIS.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_RELATIVO_R117BIS.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_RELATIVO_R117BIS_v1' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova NAS -AccettoTettoBarre; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'RELATIVO_R117BIS_NAS_2*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP RELATIVO_R117BIS_NAS_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI o FERMATA: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'GUARDA SUBITO, IN QUEST''ORDINE: 1) FINESTRA EFFETTIVA (giorni contati ~490: se sono ~450 la coda nuova NON c''era) 2) gemello INTERNO = IDENTICHE 3) PROBLEMI = 0 4) ECO DEI PIN 5) i cancelli A.' -ForegroundColor Yellow;
    Write-Host 'NON SVUOTARE LA CARTELLA DI LAVORO PRIMA DEL BLOCCO 3: il gemello legge il CSV di QUESTA corsa (classe 136-bis).' -ForegroundColor Red }
```

## 3️⃣ `NAS_GEM` — il gemello di determinismo (magic 774631)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='48b035cf677913990b26bb125c974924d2d58e08'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_RELATIVO_R117BIS.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_RELATIVO_R117BIS.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_RELATIVO_R117BIS_v1' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova NAS_GEM -AccettoTettoBarre; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'RELATIVO_R117BIS_NAS_GEM_2*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP RELATIVO_R117BIS_NAS_GEM_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI o FERMATA: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'GUARDA SUBITO: la riga IL GEMELLO DI DETERMINISMO. Se DIVERGONO, il banco e'' sporco e NESSUN numero di questo round vale.' -ForegroundColor Yellow }
```

## 4️⃣ 📦 RACCOLTA FINALE — **un solo zip da mandare**

> 🔴 **Ogni zip candidato viene aperto sul referto della sua cartella** e
> accettato **solo se dentro c'è il pin `48b035c`**: uno zip di R117 o di un pin
> vecchio viene **scartato in rosso**, non spedito (classe 135).

```powershell
& { $ErrorActionPreference='Stop';
    $pin='48b035cf677913990b26bb125c974924d2d58e08';
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $stamp=(Get-Date).ToString('yyyyMMdd_HHmm'); $out=Join-Path $d ('RELATIVO_R117BIS_TUTTO_'+$stamp); New-Item -ItemType Directory -Force -Path $out | Out-Null;
    $att=@('RELATIVO_R117BIS_NAS_2*','RELATIVO_R117BIS_NAS_GEM_2*'); $trovati=0; $scartati=0;
    foreach($m in $att){ $c=@(Get-ChildItem (Join-Path $d ($m+'.zip')) -EA SilentlyContinue | Sort-Object LastWriteTime -Descending); $preso=$null;
      foreach($z in $c){ $cart=Join-Path $d $z.BaseName; $ref=@(Get-ChildItem (Join-Path $cart 'REFERTO_RELATIVO_R117BIS_*.txt') -EA SilentlyContinue);
        if($ref.Count -eq 0){ Write-Host ('  SALTO:   '+$z.Name+'  -- niente cartella/referto accanto: il pin NON e'' verificabile') -ForegroundColor Yellow; $scartati++; continue };
        if(Select-String -LiteralPath $ref[0].FullName -SimpleMatch -Pattern $pin -Quiet){ $preso=$z; break };
        Write-Host ('  SCARTO:  '+$z.Name+'  -- e'' di un PIN VECCHIO: quella corsa non e'' di questo round') -ForegroundColor Red; $scartati++ };
      if($preso){ Copy-Item $preso.FullName -Destination $out -Force; $trovati++; Write-Host ('  TROVATO: '+$preso.Name+'   ('+$preso.LastWriteTime+')   pin VERIFICATO nel referto') -ForegroundColor Green }
      else { Write-Host ('  MANCA:   '+$m+'.zip AL PIN NUOVO -- quella corsa non e'' arrivata alla raccolta, oppure c''e'' solo una versione vecchia') -ForegroundColor Red } };
    Write-Host '';
    if($trovati -eq 0){ Write-Host 'NESSUNO ZIP AL PIN NUOVO: non creo nessun archivio. Rilancia le corse dai blocchi 2-3.' -ForegroundColor Red }
    else { $zip=$out+'.zip'; Remove-Item $zip -Force -EA SilentlyContinue; Compress-Archive -Path (Join-Path $out '*') -DestinationPath $zip -Force;
      Write-Host ('ZIP DA MANDARE IN CHAT: '+$zip) -ForegroundColor Cyan };
    Write-Host ('FILE ATTESI DENTRO: 2 zip di corsa, TUTTI col pin '+$pin.Substring(0,7)+'. Trovati: '+$trovati+' su 2. Zip di pin vecchi scartati: '+$scartati) -ForegroundColor Gray;
    if($trovati -gt 0 -and $trovati -lt 2){ Write-Host 'ATTENZIONE: mandalo lo stesso, ma dimmi quale corsa e'' mancata e cosa ha stampato.' -ForegroundColor Yellow } }
```

---

## 📦 COSA TORNA (per corsa)

Zip sul Desktop **`RELATIVO_R117BIS_<PROVA>_<timestamp>.zip`** →
`REFERTO_RELATIVO_R117BIS_<PROVA>.txt` + `COMPILAZIONE.log` + il file prova +
**due CSV OPTFRAME** (`..._IS_<PROVA>.csv` e `..._OOS_<PROVA>.csv`, **due righe
ciascuno** — magic **dichiarato** + magic **OMBRA**, classe 134 — 76 colonne).

**Le righe da guardare per prime, in questo ordine:**

0. 🕐 **`pin:` e `data:`, in cima al referto.** `pin:` deve dire
   **`48b035cf677913990b26bb125c974924d2d58e08`** e **nient'altro**: sul Desktop
   ci sono ancora i referti di R117, e quelli **arrivati in fondo e verdi** sono
   i più insidiosi. `data:` è l'**ora di AVVIO** e dev'essere quella di adesso.
1. 🔴 **`FINESTRA EFFETTIVA`** — giorni contati devono essere **~490** contro
   **503** feriali chiesti. Se sono **~450**, **la coda nuova non c'era** e il
   round ha misurato la finestra di R117: lo dice anche fra i `PROBLEMI`.
2. **`compilazione:`** — se è FALLITA, quello è il risultato del passo.
3. 🔴 **`gemello INTERNO`** — deve dire **`IDENTICHE`** per **IS** e per **OOS**.
   È la riga che prova che MT5 ha davvero **eseguito le passate**.
4. **`tetto barre:`** — deve dire **DENTRO IL TETTO** con **gamba più lunga 352
   giorni** (classe 138), e `-AccettoTettoBarre` dichiarato **INERTE**.
5. **`CONTROLLO DI COERENZA COL PASSO 0`** — densità entro il 15%. **Non è il
   collaudo del porto** e non boccia niente: sopra il 15% è un rilievo da
   spiegare.
6. **`IL GEMELLO DI DETERMINISMO`** (blocco 3) — se DIVERGONO, banco sporco.
7. **`PROBLEMI: 0`** — un solo collaudo di sanità fallito = **non leggibile**.
8. **`ECO DEI PIN`** — se N non è 40, σ non è 1,35, SL non è 2,75, tetto non è 5
   e rischio non è 0,65%, **il pin non è passato**.
9. E **solo dopo**: `I CANCELLI DI MERITO`, poi **`IL CAMPIONE UNITO`**, poi
   **`QUANTO STORICO SERVIREBBE PER A6`**.

---

## 🔜 COSA SUCCEDE DOPO

- 🟠 **Il verdetto più probabile è `MERITO SOSPESO` di nuovo**, ed è previsto: A6
  non può essere soddisfatto e lo sappiamo prima di lanciare. **Non è un
  fallimento del round**: il round serve a leggere A3 su campioni bilanciati e a
  mettere agli atti il campione unito.
- 🟢 **Se A3 diventa COERENTE** (IS e OOS con lo stesso segno, PF IS > 1,00) e il
  rischio resta verde: si scrive che *"l'incoerenza di R117 era un effetto della
  taglia dei campioni"*, e la candidata resta viva in attesa dei tre mesi che
  mancano ad A6.
- 🔴 **Se A3 resta INCOERENTE anche a campioni bilanciati**: quello **non** è un
  effetto di taglia, ed è il segnale più serio che questo round può dare — la
  prima metà della finestra e la seconda si comportano in modo diverso, e
  l'edge, se c'è, non è stabile.
- 🔴 **Se il rischio diventa rosso** (DD > 10% o peggior giornata < −5%): è una
  **bocciatura per rischio**, subito, qualunque cosa dica il resto.
- ⛔ **Se un gate di sanità è rosso** o la finestra effettiva è corta: *"il banco
  non ha prodotto la misura"*. **È vietato scriverlo come se fosse un verdetto
  sull'edge.**
- 📅 **In ogni caso**, la prossima tappa scritta è **rifare questa stessa corsa a
  inizio dicembre 2026** con `@FINOA 2026.11.30`: è la data in cui A6, alla
  frequenza misurata, si soddisfa da sola.
