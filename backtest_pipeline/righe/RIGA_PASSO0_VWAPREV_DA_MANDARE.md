# 📬 PASSO 0 — **VWAP REVERT** — LA RIGA DA MANDARE

**Che cos'è:** il **PASSO 0** del candidato **P1** della caccia M5/M15 indici del
25/08 (`caccia_strategie/CACCIA_M5M15_INDICI_2026-08-25.md`, voto **8/10**).
Si misura **QUANTE OPERAZIONI** produce il motore VWAP Mean Reversion su
`D30EUR M15`, a **tick reali**, su **quattro celle** — e **quanto costa la
regola intraday**.

> 🔴 **NON È UN ROUND E NON DÀ NESSUN VERDETTO.** È un **conta-operazioni**.
> Il Profit Factor che esce dal CSV **si legge ma non si giudica**: i criteri di
> merito della BOZZA (S3/S4/S5/S6) sono **[DA FIRMARE]** e quattro celle non
> sono un round. Il dossier lo pretende in chiaro (par. 6, paletto 2):
> _"PASSO 0 obbligatorio: contare le operazioni prima di leggere il PF."_

> 🛑 **La BOZZA `prove/VWAPREVERT_DAX_M15_BOZZA.txt` RESTA FERMA.** Questo giro
> **non la sblocca**: quella è una **griglia da 18 celle** che *sceglie una
> taratura*, e una griglia si lancia **dopo la firma**. Qui l'unico asse
> spazzolato è `InpMagic`, e il driver **si ferma** se ne trova un secondo.

| | |
|---|---|
| **EA** | `mql5/Experts/ABTG_VwapRevert.mq5` (porting da **sumbloke077**, TradingView `YBqnzqDK`) |
| **Driver** | `righe/RIGA_PASSO0_VWAPREV.ps1` (marcatore `MARCATORE_RIGA_PASSO0_VWAPREV_v4`) |
| **File prova** | `prove/ABTG_VwapRevert.txt` · `prove/PASSO0_VWAPREV_01_long.txt` · `prove/PASSO0_VWAPREV_02_short.txt` · `prove/PASSO0_VWAPREV_03_overnight.txt` |
| **Referto di preparazione** | `prove/REFERTO_PREPARAZIONE_VWAPREV.md` |
| **Tesi del porting** | `VWAPREVERT_TESI.md` |
| **Specifica congelata (ferma)** | `prove/VWAPREVERT_DAX_M15_BOZZA.txt` |

---

## 🎯 LE QUATTRO CELLE

| cella | file prova | lati | flat fine seduta | magic gemelli |
|---|---|---|---|---|
| **00_nudo** | `ABTG_VwapRevert.txt` | long **+** short | **ON** 20:45 server | 773400 / 773401 |
| **01_long** | `PASSO0_VWAPREV_01_long.txt` | **solo long** | ON | 773410 / 773411 |
| **02_short** | `PASSO0_VWAPREV_02_short.txt` | **solo short** | ON | 773420 / 773421 |
| **03_overnight** | `PASSO0_VWAPREV_03_overnight.txt` | long + short | 🔴 **OFF** | 773430 / 773431 |

Ogni cella differisce dal `00_nudo` di **due righe sole** (l'interruttore + il
magic), e il driver **lo verifica prima di aprire MT5**. Gli **otto magic sono
VERGINI**: cercati uno per uno in tutto il repo il 28/08 → **zero occorrenze**.
I magic del **PASSO 0 gemello FVG** (`7760xx`, `7761xx`, `7764xx`) e quelli
delle **sedie vive** sono nella lista dei **vietati**.

---

## 🕗 LA COSA NUOVA — **IL FLAT DI FINE SEDUTA**, e perché c'è

L'EA è stato **modificato il 28/08**: `InpFlatFineSeduta`, **default ACCESO**,
alle **20:45 ORA SERVER** (= 21:45 italiana) chiude ogni posizione, cancella
ogni pendente e **non riapre fino al giorno dopo**.

**Perché, ed è una scelta di CONTRATTO, non di taratura:** FTMO Standard
(**leva 1:100** — quella che vogliamo tenere) impone restrizioni
**overnight / weekend / news SOLO sul conto finanziato**. Un motore che apre e
chiude **dentro la seduta** non incontra mai quel vincolo. L'alternativa è
scendere a **Swing, leva 1:30**.

⚠️ **È uno SCOSTAMENTO DICHIARATO dal Pine**: sumbloke077 **non** chiude a fine
giornata. Per questo esiste la cella **`03_overnight`**, che spegne il flat e
cambia **solo quello**: il costo della regola **si misura**, non si stima.

> 🔴 **E la `03_overnight` NON PUÒ VINCERE.** Anche se facesse meglio del
> `00_nudo` **non diventa la cella da mandare in campo**: tenere posizioni
> overnight è incompatibile col posto per cui questo candidato esiste. Serve a
> sapere **quanto stiamo pagando per restare a 1:100**. Se il divario fosse
> enorme, la conclusione è _"questo non è un motore intraday"_, **non**
> _"accendiamo l'overnight"_.

---

## ❓ LA DOMANDA — e i tre esiti, congelati PRIMA di vedere il numero

La BOZZA **stima** [IPOTESI, mai misurata] 0,5-2 trade/giorno per indice, cioè
**225-900 operazioni in 21 mesi**. **Questo giro sostituisce quella stima con un
numero.**

| esito | lettura |
|---|---|
| **A** — n per lato **≥ 150 IS** | il campione c'è, **Emendamento regola A soddisfatto**: il round vero si può disegnare e i criteri della BOZZA si portano alla firma |
| **B** — n per lato **< 150 IS** | scatta la **valvola R59 / regola B**: il **MERITO resta SOSPESO**, il **RISCHIO si giudica lo stesso**. **Non si allarga il motore per fare campione** |
| **C** — n **enorme** | la banda è troppo stretta. La manopola è **`InpSigmaMult` verso l'alto** (è già un asse della BOZZA), **NON** il rischio e **NON** un filtro nuovo appiccicato sopra (0 successi su 5) |

---

## 📌 IL PIN — **`99673257f1e43b2c87bca1c401faf49c2bbdc80f`**

```
99673257f1e43b2c87bca1c401faf49c2bbdc80f
```

⚠️ **Il pin si rilegge DOPO il push, non prima.** Il commit da pinnare deve
contenere **tutti e nove** gli artefatti che lo script scarica:
`walkforward_generico.ps1`, `RIGA_PASSO0_VWAPREV.ps1`, i **quattro** file prova,
`ABTG_PausaGuardian.mqh`, **`mql5/Experts/ABTG_VwapRevert.mq5`** (che il driver
generico riscarica **al pin**) e, dal 03/09, **il CSV dello spread orario**
`backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_D30EUR.csv`
(il cancello **S0** lo scarica **al pin**, non da HEAD: se manca o è vecchio,
S0 esce `NON DISPONIBILE` e va scritto nei RILIEVI, mai stimato).

✅ **Gia' verificato (03/09)**: tutti e nove esistono nel commit sopra, letti
uno per uno con `git rev-parse <pin>:<file>` **confrontato con**
`git hash-object <file>` sul working tree — **blob identici su tutti e nove**.
Il `.ps1` nel pin porta il marcatore `MARCATORE_RIGA_PASSO0_VWAPREV_v4`. Il
`.mq5` nel pin contiene davvero il flat di fine seduta (`InpFlatFineSeduta`)
**e le tre colonne di collaudo** (`double stats[13]`, `Autotest Falliti,Flat
Giorni,Flat Chiusure`).

La riga passa il pin a `-Pin` e **si rifiuta di partire senza**: un default
silenzioso (`lavoro`) farebbe girare la punta del branch spacciandola per un
commit congelato. Il driver **pinna anche `$EABranch` dentro
`walkforward_generico.ps1`**, altrimenti il pin varrebbe per il driver e **non
per l'EA misurato**.

### ♻️ LA RICETTA DI **RI-PINNATURA** — se un artefatto viene corretto

```bash
F=backtest_pipeline/righe/RIGA_PASSO0_VWAPREV_DA_MANDARE.md
NUOVO=<il commit nuovo, 40 caratteri>
VECCHIO=$(grep -oE "\\\$pin='[0-9a-f]{40}'" "$F" | head -1 | grep -oE '[0-9a-f]{40}')
echo "vecchio: $VECCHIO"
sed -i "s|\$pin='$VECCHIO'|\$pin='$NUOVO'|g; s|^$VECCHIO\$|$NUOVO|; s|\*\*\`$VECCHIO\`\*\*|\*\*\`$NUOVO\`\*\*|g" "$F"
grep -c "\$pin='$NUOVO'" "$F"    # DEVE dare 3
grep -c "\$pin='$VECCHIO'" "$F"  # DEVE dare 0
grep -rn "${VECCHIO:0:7}" backtest_pipeline/righe/*.md backtest_pipeline/prove/*.md   # DEVE dare 0 (punto 103: pin vecchio abbreviato in prosa)
```

⚠️ **Servono TUTTI E TRE i conteggi**: il solo *"0 pin vecchi rimasti"* lo supera
a mani basse anche un `sed` che **non ha matchato niente**; il terzo è il punto
**103**: il pin vecchio scritto **abbreviato in prosa** (es. `9ed66e2…`)
sopravvive al `sed` sul pin per esteso e certifica un commit che non è più
quello a cui si lancia. E il pin vecchio si legge **DAI PUNTI D'USO**
(`$pin='<40 caratteri>'`), mai con un `grep` largo.

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** Col terminale aperto il tester non
  gira (zero CSV); con MetaEditor aperto la compilazione torna subito **senza
  compilare**. La riga si rifiuta di partire in tutti e due i casi.
- 🔴 **L'EA NON È MAI STATO COMPILATO DA NESSUNO.** Scritto il 25/08, modificato
  il 28/08 (flat di fine seduta): in quell'ambiente **non esiste MetaEditor**.
  **Per questo il giro di controllo ADESSO COMPILA DAVVERO**: è il primo
  risultato vero di questo PASSO 0, e costa **un minuto** invece di scoprirlo
  a corsa avviata. **Se la compilazione fallisce, il risultato del PASSO 0 è
  quello** e va riportato così com'è — non è un guasto della riga. Lo script
  cancella l'`.ex5` prima di compilare (un binario vecchio farebbe passare per
  riuscita una compilazione fallita) e, se fallisce, **stampa in rosso le
  ultime 40 righe del log di MetaEditor** e si ferma.
- 🧩 **La riga installa `ABTG_PausaGuardian.mqh`** in `MQL5\Include` prima di
  compilare, **con backup e ripristino automatico** (classe 116): una
  sentinella si scrive PRIMA di toccare il terminale; se c'era già un file
  diverso viene copiato in `%USERPROFILE%\abtg_passo0_vwaprev\backup\` e
  **rimesso al suo posto a fine giro** (anche nel giro fermato); se questo
  giro viene interrotto, il **giro successivo** trova la sentinella, ripristina
  da solo e lo **dichiara nei RILIEVI**. `walkforward_generico.ps1` **non
  installa l'include** (verificato: la stringa `PausaGuardian` non compare nel
  driver generico), e senza quel file l'EA non compila. La copia si verifica
  **sul contenuto** (lunghezza), non sul nome, e il referto porta la **foto
  PRIMA/DOPO** dei tre file del terminale che il giro potrebbe toccare.
- 🎯 **Il terminale si sceglie per un FATTO, non per nome** (classe 115): si
  scandisce **largo** (`origin.txt`, `Program Files`, il caso **portable**) e
  si sceglie **stretto** la cartella dati con `bases\*BCM*` (il feed),
  scartando le installazioni `-V3`. Con **zero** o **due** candidati la riga
  **si ferma**, stampa l'**elenco completo** e la manopola
  `-Terminale "<cartella di installazione>"`. Il terminale scelto viene
  **passato** (`-Terminal`/`-MetaEditor`/`-DataFolder`) al driver generico:
  stesso terminale **per costruzione** — prima (v3) il selettore era "il primo
  `origin.txt` che contiene BCM", e su una macchina con due istanze i due
  script potevano scegliere **terminali diversi**, include in uno e
  compilazione nell'altro. La riga **lo stampa**, e su BCM il driver generico
  riceve il terminale già deciso e non stampa niente di suo.
- **NESSUNA SEDIA VIVA VIENE TOCCATA.** Magic vergini `7734xx`,
  `AllowLiveTrading=false` negli `.ini` (lo scrive il driver generico).
- **16 passate** (4 celle × 2 finestre × 2 gemelle), **8 CSV**, `Model=4`
  (**tick reali**), finestra **2024.09.26 → 2026.06.30**, split 40/60,
  deposito **100.000**, rischio **`InpRiskPercent = 1.0`** — e quel numero è
  **letto dal file prova**, dove morde davvero, non da un parametro della riga.
- 💰 **Dal 03/09 la riga scarica anche il CSV dello spread orario** (`spread_orario_D30EUR.csv`,
  al pin) per il **cancello S0** (il costo): se il download fallisce o il file
  ha poche ore leggibili, S0 esce `NON DISPONIBILE` per quella corsa — **si
  scrive nei RILIEVI, non si stima**. Il cancello si legge **per cella**,
  sull'export per-trade OOS: vedi il riquadro dedicato più sotto.
- ♻️ **Se il pin cambia, la cache di `%USERPROFILE%\abtg_passo0_vwaprev` viene
  CANCELLATA** (file prova e CSV del pin vecchio). Senza, il gate di
  idempotenza del driver generico riproporrebbe i CSV di ieri come se fossero
  di oggi.
- **Zero parametri spazzolati.** L'unico asse `Y` è `InpMagic`, e il driver
  **si ferma** se in un file prova ne trova un secondo.
- 🔧 Se non è già stato fatto: MT5 → Strumenti → Opzioni → Grafici →
  **"Max barre nel grafico" = Illimitato**.
- ⏱️ **Durata [STIMA, non una previsione]:** giro di controllo **~1 minuto**
  (compilazione compresa); corsa vera **15-40 minuti**. R107 fece 24 passate a
  tick reali sulla stessa finestra in 9 minuti.

---

## 1️⃣ PRIMA il giro di controllo (**~1 minuto — COMPILA, non apre il tester**)

> 🔧 **Non è più un giro a vuoto.** Scarica al pin, passa i gate sui file prova,
> installa l'include **e COMPILA L'EA**. La compilazione è **il primo risultato
> vero** di questo PASSO 0: l'EA non era mai stato compilato da nessuno.
> Il **tester** non viene aperto: nessun `n`, nessun PF, nessun numero.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='99673257f1e43b2c87bca1c401faf49c2bbdc80f'; $p="$env:USERPROFILE\RIGA_PASSO0_VWAPREV.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_PASSO0_VWAPREV.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_PASSO0_VWAPREV_v4' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Cosa deve dire**, in ordine:

- `pin ......... <40 caratteri>` e `celle ....... 4 su 4`;
- `finestra .... 2024.09.26 -> 2026.06.30` e `banco ....... Modello 4 (TICK REALI) ...`;
- `cancello S0 . soglia severa 3 x 1.7 = 5.1 punti indice/trade nelle ore 8-16, ...`;
- 🟡 `sentinella di un giro interrotto: include ...` — compare **solo** se un
  giro precedente si è fermato a metà (classe 116): normale che non esca mai;
- `driver generico scaricato e PINNATO`;
- `file prova scaricati: 4`;
- `spread orario per S0: DISPONIBILE (<n> ore lette da spread_orario_D30EUR.csv al pin)`
  — se esce `NON DISPONIBILE`, il cancello S0 non si potrà leggere in questa
  corsa e lo dirà come RILIEVO, non come fermata;
- `include scaricato: ABTG_PausaGuardian.mqh (<n> byte)`;
- `geometria, valori dei tre interruttori, baseline assoluta, stella e magic: TUTTI PASSATI`;
- `terminale scelto: <cartella di installazione>` seguito da
  `criterio ........ FATTO: ...` — scelto per il **feed**, non per nome
  (classe 115); se compare `NON SO QUALE TERMINALE USARE` con un elenco, si
  rilancia lo **stesso blocco** aggiungendo `-Terminale "<cartella>"`;
- `include: INSTALLATO e VERIFICATO in ...` (con backup se c'era già un file
  diverso);
- 🔴 **`compilato ABTG_VwapRevert: OK (... KB, ...)`** ← **è questa la riga che
  conta.** Se invece esce `COMPILAZIONE FALLITA`, sopra ci sono in **rosso** le
  ultime 40 righe del log di MetaEditor: **copiale in chat, sono il risultato**;
- quattro volte l'anteprima dell'`.ini` del driver generico, e in fondo
  `ESITO: CONTROLLO COMPLETATO`.

> ⚠️ **Quello che il giro di controllo NON può fare:** `-SoloControllo` **non
> apre il tester**. Non esiste nessun `n`, nessun PF, nessun DD, **nessun
> controllo sui gemelli** e **nessuna colonna di collaudo** (l'autotest esce dal
> CSV, e il CSV lo produce solo la corsa). Conferma gli **artefatti** e la
> **compilazione**, mai i numeri.

---

## 2️⃣ POI la corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='99673257f1e43b2c87bca1c401faf49c2bbdc80f'; $p="$env:USERPROFILE\RIGA_PASSO0_VWAPREV.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_PASSO0_VWAPREV.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_PASSO0_VWAPREV_v4' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**: è **un comando solo**. Tre righe staccate
sarebbero tre comandi indipendenti, e un `throw` alla prima non fermerebbe le
altre.

### 🔁 Se serve riprendere una cella sola

> ⚠️ **Ogni ripresa è un BLOCCO INTERO, col suo `irm`.** `$p` e `$pin` nascono
> **dentro** il `& { ... }`, che è uno scope figlio: quando quel blocco finisce
> **non esistono più**.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='99673257f1e43b2c87bca1c401faf49c2bbdc80f'; $p="$env:USERPROFILE\RIGA_PASSO0_VWAPREV.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_PASSO0_VWAPREV.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_PASSO0_VWAPREV_v4' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloCella '03_overnight' -Rifai;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo' -ForegroundColor Yellow } }
```

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul **Desktop**: `PASSO0_VWAPREV_<MODO>_<data>_<ora>` — dentro:

- **`REFERTO_PASSO0_VWAPREV.txt`** ← **è questo che conta**;
- i **file prova** delle celle che hanno girato;
- i **CSV** `ABTG_VwapRevert_D30EUR_IS_<cella>.csv` e `_OOS_<cella>.csv`;
- gli **export per-trade** `EXPORT_<cella>_abtg_trades_ABTG_VwapRevert_D30EUR_<magic>.csv`
  (dal 03/09, servono al **cancello S0**);
- `spread_orario_D30EUR.csv` (la misura scaricata al pin, per S0);
- `COMPILAZIONE_FALLITA.log`, **solo se la compilazione è fallita**.

### 📅 Le tre righe da guardare per prime nel referto

1. **`modo:`** — dice `CORSA` (il risultato) o `CONTROLLO` (giro a vuoto:
   **non si manda come risultato**);
2. **`data:`** — 🔴 **è l'ORA DI AVVIO del giro, NON l'ora attuale** (classe
   110: la corsa vera dura 15-40 minuti, quindi a referto letto `data:` è già
   vecchia di un po' **ed è giusta così**). Il referto porta anche una riga
   **`fine:`**, l'ora della raccolta: è **quella** da confrontare con
   l'orologio di adesso;
3. e se le due date non tornano (`fine:` non è di oggi): il file è stantio.

### 🔬 IL COLLAUDO STA NEL REFERTO, IN TRE COLONNE — **non** nella scheda Esperti

⚠️ **La scheda Esperti qui NON si guarda, ed è misurato perché:** in
**ottimizzazione** le `Print` girano **sugli agent** e non le legge nessuno
(CHECKLIST punto 34). Un autotest che stampasse `DIVERGE` su un agent non
fermerebbe niente e nessuno lo vedrebbe. Per questo l'EA porta l'esito
**dentro il CSV**, e il referto lo stampa sotto ogni cella:

```
collaudo: autotest falliti = 0 (atteso 0) | flat giorni = 41 | flat chiusure = 27   [flat dichiarato: 1]
```

| colonna | come si legge |
|---|---|
| **`autotest falliti` = 0** | la riga `esito motore:` dell'EA dice **DIECI BLOCCHI SU DIECI**: i numeri della tabella **si leggono** |
| **`autotest falliti` > 0** | **DIVERGE**: i numeri **NON si leggono**, c'è da guardare il codice → finisce nei **PROBLEMI** |
| **`autotest falliti` = `non-eseg` / `assente`** | nessun gate: il numero è **senza collaudo** → **PROBLEMI** |
| **`flat giorni`** | giornate in cui il flat è scattato. Col flat **ACCESO** uno **zero** è un **rilievo**; col flat **SPENTO** (cella `03_overnight`) un valore **> 0** è un **problema**: l'interruttore non morde |
| **`flat chiusure`** | posizioni davvero chiuse dal flat, in totale |

> 🚫 **E una lettura FALSA che è stata tolta**: la riga di log
> `flat di fine seduta alle 20:45 server: N posizioni chiuse` **si scrive OGNI
> GIORNO, anche con `N = 0`** (letto in `FlatFineSedutaCheck`). Quindi la sua
> **assenza non voleva dire** _"non c'era niente da chiudere"_ — voleva dire che
> l'EA non aveva mai visto un tick dopo le 20:45, **oppure** che quel log non
> era leggibile affatto. Adesso il numero è una **colonna**, e l'assenza smette
> di essere un indizio da interpretare.

---

## 🚩 COME SI LEGGE IL REFERTO — quattro avvertenze, non quattro note

1. 🧮 **`n(01_long) + n(02_short)` NON farà `n(00_nudo)`, e non è un guasto.**
   **Misurato nel sorgente** (`OnNewBar`): il giro esce con
   `if(CountPositions()>0) return` **prima** di guardare il lato, e dopo un
   `PiazzaOrdine` long fa `return` senza valutare lo short (_"una sola decisione
   per barra"_). Con un lato spento **lo slot resta libero**.
2. 📈 **La finestra è UN SOLO REGIME RIALZISTA** (21 mesi di feed BCM sugli
   indici). Il lato **short parte svantaggiato per REGIME**, non per merito del
   motore. Un *"niente edge short"* letto qui chiude la domanda **per questa
   epoca**, non in assoluto.
3. 🕗 **La `03_overnight` non può vincere** — vedi il riquadro rosso sopra. **E
   quello che ne esce NON è un costo puro:** il costo si legge come delta di
   `Prof OOS` e di `n` fra `00_nudo` e `03_overnight`. Non è un costo puro: col
   flat spento la posizione notturna tiene occupato lo slot
   (`if(CountPositions()>0) return`) e blocca gli ingressi del giorno dopo — un
   `n` più basso qui è **anche meccanica dello slot, non solo mercato**. Il P&L
   delle sole posizioni che attraversano la notte **questo giro non lo misura**.
   È lo stesso meccanismo dell'avvertenza 1, e qui morde **di più**: lì lo slot
   resta occupato per una barra, qui per **giorni**.
4. 💰 **Il cancello S0 (il costo) È ADJUDICABILE DAL 03/09/2026, coi numeri
   fissati PRIMA della corsa** (in testa a `prove/ABTG_VwapRevert.txt`, ripetuti
   dal driver). Lo spread REALE di BCM su D30EUR è **misurato** dai tick storici
   (`SPREAD_FLOTTA_MISURA_2026-09-03.md`: mediana **1,6-1,7 punti indice** nelle
   ore 8-16 server, più alto fuori sessione, fino a 3,5-3,9 di notte), e la
   conversione è **misurata** (1 punto indice = 100 punti MT5, contract size
   **10** EUR/punto/lotto, R114 GSPEC). La **CLAUSOLA SEVERA**: lo spread di
   riferimento non scende **mai** sotto **1,7** (la mediana dell'ora peggiore
   della sessione 8-16), quindi la soglia minima è **3 × 1,7 = 5,1 punti
   indice/trade**; per un trade chiuso fuori sessione vale la mediana della sua
   ora di chiusura (fino a 12,0 di notte); un trade senza ora leggibile prende
   **4,0** (la mediana oraria peggiore) → soglia **12,0**. **VERDETTO sul
   RAPPORTO** (media punti/trade del motore) / (media dello spread mediano
   orario dei trade della cella): **≥ 3,5 PASSA**; **< 2,5 NON PASSA**; **fra
   2,5 e 3,5 il verdetto NON SI DÀ** (banda della misura del 03/09). Il numero
   si legge dall'**export per-trade** dell'EA in `Common\Files`
   (`abtg_trades_ABTG_VwapRevert_D30EUR_<magic>.csv`, **gamba OOS**), e il
   driver lo calcola da solo per ogni cella — vedi il riquadro `S0 (costo):`
   sotto ogni cella nel referto.
   ⚠️ **Tre limiti dichiarati**: (a) `net_profit` è **netto** di swap/commissioni
   → verso SEVERO; (b) l'export porta l'**ora di chiusura**, non quella
   d'ingresso: un trade entrato di notte e chiuso in sessione è giudicato a 1,7
   (non severo); (c) il file porta il **MAGIC nel nome, non la finestra: la
   gamba OOS (che gira per ultima) SOVRASCRIVE la IS dello stesso magic** — S0
   si legge **solo sull'OOS**, mai sull'IS.
   🔴 **Un S0 `NON PASSA` sulla `00_nudo` chiude il capitolo VWAP anche come
   motore** (falsificazione già dichiarata nella BOZZA): non si cerca un'altra
   taratura per farlo passare.

---

## ✅ COSA È GIÀ STATO VERIFICATO — **eseguendo**, prima dell'invio

- ✅ **03/09, RI-VERIFICATO sul driver v4** (`pwsh 7.4.6` + `[Parser]::ParseFile`):
  **0 errori**, **10.687 token** (era 5.037 sul v2: lo script è cresciuto per
  le correzioni 94-ter/108/115/116/116-bis/106-23 e per il cancello S0); **ASCII
  puro** (0 caratteri non-ASCII, regola del 17/08); **non usa `$args`**; **0
  collisioni case-insensitive** fra nomi di variabile su TUTTO il file (classe
  79/79-bis, cercate col metodo del parser); **0 parametri orfani** (i dieci
  parametri del v4, incluso il nuovo `-Terminale`, sono tutti usati più di una
  volta, verificato a macchina);
- ✅ **i quattro file prova sono ASCII puro** e **portano tutti e 49 gli input
  pinnati** (classe 25/113: i 19 input che nella v1/v2 non erano nella baseline
  — `InpUsaGuardian`, `InpMaxSpread`, `InpWickMult`, ... — ora sono in forma
  completa nei quattro file e nella baseline del driver);
- 🟡 **NON ri-eseguita su v4**: la batteria delle 11 corruzioni della prima
  verifica (28/08, tabella sotto) non è stata rilanciata dopo la riscrittura;
  il codice dei gate sui file prova non è nel perimetro delle sei correzioni
  106-116 (che toccano terminale/include/compilazione/uscita/pulizia/S0), ma
  la riesecuzione integrale resta da fare e va dichiarata, non assunta;
- ✅ **11 prove, 11 fermate della prima verifica (28/08)**, ognuna col
  messaggio giusto:

  | corruzione | il gate ha detto |
  |---|---|
  | i due file dei lati **scambiati** | `InpAllowLong vale 0, la cella 01_long lo vuole 1` |
  | **flat spento** anche nel `00_nudo` | `InpFlatFineSeduta vale 0, la cella 00_nudo lo vuole 1` |
  | **corruzione SIMMETRICA** su tutti e quattro (`InpSigmaMult` 1.0→1.5) | `la baseline dichiarata di questo PASSO 0 lo vuole 1.0` |
  | magic **vietato** (776000, il PASSO 0 gemello FVG) | `magic 776000 e' VIETATO` |
  | magic **duplicato** fra due celle | `magic 773410 usato in due celle` |
  | **secondo asse Y** (la griglia della BOZZA che rientra dalla finestra) | `deve avere ESATTAMENTE un asse con flag Y, trovati 2` |
  | `@PERIODO` M15→M5 (**la trappola R102**) | `@PERIODO e' M5, atteso M15` |
  | una **riga in più** non dichiarata | `'InpTrailAtrMult' differisce dal 00_nudo e NON e' un delta dichiarato` |
  | **parametro doppio** nello stesso file | `DUE righe per 'InpAllowShort'` |
  | il **pin cancellato** (`InpFlatOra`) | `manca il pin di 'InpFlatOra'` |
  | il **delta dichiarato che NON differisce** (03 col flat riacceso) | `InpFlatFineSeduta vale 1, la cella 03_overnight lo vuole 0` |

  > 🔎 **La terza riga è la più importante.** Una riga storta **uguale in tutti e
  > quattro** i file passerebbe il gate della stella — _"un diff fra A e B non
  > può accorgersi di niente che sia uguale in A e in B"_ (lezione R110). La
  > prende il **gate della BASELINE ASSOLUTA**, che confronta con **valori
  > dichiarati nel driver**, non con un altro file.

### 🔧 E COSA È CAMBIATO NELLA **v2** (7 difetti trovati dal verificatore, 28/08)

| # | difetto | fix |
|---|---|---|
| **1** 🔴 | autotest e flat scrivevano solo `Print`: **in ottimizzazione non li legge nessuno** | escono in **tre colonne** del CSV (`Autotest Falliti`, `Flat Giorni`, `Flat Chiusure`), lette **per nome** e trasformate in **gate** |
| **2** 🔴 | il giro di controllo **non compilava** un EA mai compilato prima | compila in **entrambi** i rami, cancella l'`.ex5` prima, stampa il log in rosso se fallisce |
| **3** 🔴 | selettore cartella dati **diverso** da `walkforward_generico.ps1` | stesso selettore riga per riga, e la riga **stampa il terminale scelto** |
| **4** | cache **non ripulita** al ri-pin | `pin_corrente.txt`: se il pin cambia, prove e CSV vecchi vengono cancellati; e la baseline nuda si riscarica **sempre** |
| **5** | parametro `-Rischio` **orfano** (solo stampato, mai passato) | rimosso; il referto stampa `InpRiskPercent` **letto dal file prova** |
| **6** | criterio di lettura della `03_overnight` **incompleto** | scritto che **non è un costo puro**: lo slot occupato dalla posizione notturna cambia la **popolazione** dei trade |
| **7** | due istruzioni di lettura **false** nel sorgente | la riga del flat si scrive **ogni giorno anche con 0 chiuse**; e non "dieci blocchi `[VWAPREV][AUTOTEST]`" (sono 17 righe) ma **`esito motore:` deve dire DIECI BLOCCHI SU DIECI** — che ora è la colonna `Autotest Falliti = 0` |

### 🔧 E COSA È CAMBIATO NELLA **v3 → v4** (rilettura contro le classi 106-116, 03/09)

| classe | difetto sul v3 | fix nel v4 |
|---|---|---|
| **94-ter** | il campo si chiamava `$Compilazione` (non `$Compilato`): il censimento per nome della classe 111 non lo vedeva (è la **113** applicata al censimento della 111) | rinominato `$Compilato`, tre stati veri (NON TENTATA / FALLITA / OK) timbrati sul ramo che decide |
| **108** | il codice di uscita del driver generico letto a due stati (`-ne 0`): su PS 5.1 un codice NON LETTO sarebbe diventato "fallita" | tre stati (0 / N / NON LETTO); il verdetto lo danno gli **artefatti** (CSV freschi, anteprima `.ini` fresca) |
| **115** | terminale scelto per NOME (`*BCM Markets MT5 Terminal*`) | scandito LARGO (`origin.txt`, `Program Files`, portable), scelto STRETTO per il **feed** (`bases\*BCM*`); zero/due candidati → si ferma con elenco e manopola `-Terminale` |
| **116** | l'include veniva scritto in `MQL5\Include` **senza backup e senza ripristino** | sentinella PRIMA della scrittura, backup in `abtg_passo0_vwaprev\backup\`, ripristino a fine giro (anche nel giro fermato) e all'avvio del giro dopo se interrotto; foto PRIMA/DOPO dei tre file nel referto |
| **116-bis** | Desktop assunto `%USERPROFILE%\Desktop` | cercato (`GetFolderPath` + i due ripieghi, incluso OneDrive) |
| **106/23** | `COMPILAZIONE_FALLITA.log` di un giro precedente poteva finire nello zip di oggi | cancellato all'avvio |
| **25/113** | 19 input **non pinnati** nei file prova (`InpUsaGuardian`, `InpMaxSpread`, `InpWickMult`, ...) | ora in forma completa nei 4 file e nella baseline assoluta del driver |
| **S0** | il cancello del costo era **NON ADJUDICABILE** (spread D30EUR non misurato) | ADJUDICABILE dal 03/09 (spread misurato, contract size da R114): criteri fissati in testa a `prove/ABTG_VwapRevert.txt` PRIMA dei numeri, calcolati dal driver sull'export per-trade OOS |
| **110** | il referto non distingueva ora di avvio da ora attuale | `data:` = ora di avvio + riga `fine:` = ora della raccolta |

🟡 **Non verificato, e va detto**: tutto ciò che richiede **MT5** — la
**compilazione** dell'EA (qui non c'è MetaEditor), l'esito dell'**autotest**,
il comportamento del **flat sui tick veri**, la durata reale, e **ogni singolo
numero**. Il giro di controllo copre gli artefatti **e la compilazione**; **i
numeri li può dare solo la corsa**.

⚠️ **E le tre colonne nuove sono codice mai compilato**: `stats[13]`, l'`head` a
**quattordici** colonne e lo `StringFormat` a quattordici specificatori sono
allineati **per lettura**, non per esecuzione. Se `MetaEditor` si lamenta di
`OnTester`/`OnTesterDeinit`, **è lì che si guarda per primo**.
