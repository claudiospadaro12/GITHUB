# 📬 PASSO 0 — FAIR VALUE GAP — **LA RIGA DA MANDARE**

**Che cos'è:** il **PASSO 0** del candidato **P1** della caccia SMC del 26/08
(`caccia_strategie/CACCIA_SMC_OB_FVG_2026-08-26.md`, voto **9/10 — PROVA
SUBITO**). Si misura **QUANTE OPERAZIONI** produce il motore Fair Value Gap
nudo su `D30EUR M15`, a **tick reali**, su tre celle.

> 🔴 **NON È UN ROUND E NON DÀ NESSUN VERDETTO.** È un **conta-operazioni**.
> Il Profit Factor che esce dal CSV **si legge ma non si giudica**: non ci sono
> criteri firmati, non c'è ablazione, e tre celle non sono un round. Il dossier
> lo dice in chiaro: _"La frequenza è il primo dato del round, prima di
> qualunque PF."_

| | |
|---|---|
| **EA** | `mql5/Experts/ABTG_FvgRetest.mq5` (adattamento in casa del Code Base **71467**) |
| **Driver** | `righe/RIGA_PASSO0_FVGRET.ps1` (marcatore `MARCATORE_RIGA_PASSO0_FVGRET_v2`) |
| **File prova** | `prove/ABTG_FvgRetest.txt` · `prove/PASSO0_FVGRET_01_long.txt` · `prove/PASSO0_FVGRET_02_short.txt` |
| **Referto di preparazione** | `prove/REFERTO_PREPARAZIONE_KSQFVG.md` |
| **Tesi del motore** | `FVG_TESI.md` |

---

## 🎯 LE TRE CELLE

| cella | file prova | lati | magic gemelli |
|---|---|---|---|
| **00_nudo** | `ABTG_FvgRetest.txt` | long **+** short | 776000 / 776001 |
| **01_long** | `PASSO0_FVGRET_01_long.txt` | **solo long** | 776100 / 776101 |
| **02_short** | `PASSO0_FVGRET_02_short.txt` | **solo short** | 776400 / 776401 |

Ogni cella differisce dal `00_nudo` di **due righe sole** (il lato + il magic),
e il driver **lo verifica prima di aprire MT5**. I **sei magic sono VERGINI**:
cercati uno per uno in tutto il repo il 28/08 → **zero occorrenze**. Il magic
del **sorgente** (`775501`) è nella lista dei **vietati**.

⚠️ Il blocco `7762xx` è stato **scartato perché non vergine** (776200/776201
risultano già nel repo): il salto da `7761xx` a `7764xx` è **voluto**.

---

## ❓ LA DOMANDA — e i tre esiti, congelati PRIMA di vedere il numero

Il dossier **stima** [IPOTESI, non misura] che un FVG nasca sul **2-4% delle
barre M15**, cioè **~150-500 operazioni in 21 mesi per lato**. Quel 2-4% è
un'ipotesi dell'agente cacciatore. **Questo giro la sostituisce con un numero.**

| esito | lettura |
|---|---|
| **A** — n per lato **≥ 150** | il campione c'è, **Emendamento regola A soddisfatto**: il round vero si può disegnare |
| **B** — n per lato **< 150** | scatta la **valvola R59 / regola B**: il **MERITO resta SOSPESO**, il **RISCHIO si giudica lo stesso** (un drawdown è un fatto accaduto). **Non si allarga il motore per fare campione** |
| **C** — n **enorme** | il filtro di taglia è troppo largo. La manopola è **`InpGapPctOfMax` verso l'alto**, **NON** il rischio e **NON** un filtro nuovo appiccicato sopra (§5B: 0 successi su 5) |

---

## 📌 IL PIN — **`55cacfa9f99a05c248ddf60d22a5362d7dc34b04`**

```
55cacfa9f99a05c248ddf60d22a5362d7dc34b04
```

⚠️ **Il pin si rilegge DOPO il push, non prima.** Il commit da pinnare deve
contenere **tutti e cinque** gli artefatti: il driver, i **tre** file prova, e
`mql5/Experts/ABTG_FvgRetest.mq5` (che il driver riscarica al pin).

La riga passa il pin a `-Pin` e **si rifiuta di partire senza**: un default
silenzioso (`lavoro`) farebbe girare la punta del branch spacciandola per un
commit congelato. Il driver **pinna anche `$EABranch` dentro
`walkforward_generico.ps1`**, altrimenti il pin varrebbe per il driver e **non
per l'EA misurato**.

✅ **Il pin è GIÀ INSERITO** (prima pinnatura fatta il 28/08, dopo il push) ed è
stato **verificato contenere tutti e sette gli artefatti** che lo script
scarica: `walkforward_generico.ps1`, `RIGA_PASSO0_FVGRET.ps1`, i **tre** file
prova, `ABTG_PausaGuardian.mqh` e **`ABTG_FvgRetest.mq5`**.

### ♻️ LA RICETTA DI **RI-PINNATURA** — se un artefatto viene corretto

```bash
F=backtest_pipeline/righe/RIGA_PASSO0_FVGRET_DA_MANDARE.md
NUOVO=<il commit nuovo, 40 caratteri>
VECCHIO=$(grep -oE "\\\$pin='[0-9a-f]{40}'" "$F" | head -1 | grep -oE '[0-9a-f]{40}')
echo "vecchio: $VECCHIO"
sed -i "s|\$pin='$VECCHIO'|\$pin='$NUOVO'|g; s|^$VECCHIO\$|$NUOVO|; s|\*\*\`$VECCHIO\`\*\*|\*\*\`$NUOVO\`\*\*|g" "$F"
grep -c "\$pin='$NUOVO'" "$F"    # DEVE dare 3
grep -c "\$pin='$VECCHIO'" "$F"  # DEVE dare 0
```

⚠️ **Servono TUTTI E DUE i conteggi**: il solo *"0 pin vecchi rimasti"* lo supera
a mani basse anche un `sed` che **non ha matchato niente**.

⚠️ **E il pin vecchio si legge DAI PUNTI D'USO** (`$pin='<40 caratteri>'`), mai
con un `grep` largo: se un giorno questa pagina avrà una riga di storia del tipo
*"il pin X è BRUCIATO"*, un `sed` largo **riscriverebbe la storia** facendole
dire l'esatto contrario del vero.

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** Col terminale aperto il tester non
  gira (zero CSV); con MetaEditor aperto la compilazione torna subito **senza
  compilare**. La riga si rifiuta di partire in tutti e due i casi.
- 🔴 **L'EA NON È MAI STATO COMPILATO DA NESSUNO.** È stato scritto il 26/08 e
  in questo ambiente non esiste MetaEditor. **Se la compilazione fallisce, il
  risultato del PASSO 0 è quello** e va riportato così com'è — non è un guasto
  della riga.
- 🧩 **La riga installa `ABTG_PausaGuardian.mqh`** in `MQL5\Include` prima di
  compilare. `walkforward_generico.ps1` **non lo fa** (verificato: nel driver
  generico la stringa `PausaGuardian` non compare), e senza quel file l'EA non
  compila.
- **NESSUNA SEDIA VIVA VIENE TOCCATA.** Magic vergini `776xxx`,
  `AllowLiveTrading=false` negli `.ini` (lo scrive il driver generico).
- **12 passate** (3 celle × 2 finestre × 2 gemelle), **6 CSV**, `Model=4`
  (**tick reali**), finestra **2024.09.26 → 2026.06.30**, split 40/60,
  deposito **100.000**, rischio **1%**.
- **Zero parametri spazzolati.** L'unico asse `Y` è `InpMagic`, e il driver
  **si ferma** se in un file prova ne trova un secondo.
- 🔧 Se non è già stato fatto: MT5 → Strumenti → Opzioni → Grafici →
  **"Max barre nel grafico" = Illimitato**.
- ⏱️ **Durata [STIMA, non una previsione]: 10-30 minuti** più la compilazione.
  R107 fece 24 passate a tick reali sulla stessa finestra in 9 minuti.

---

## 1️⃣ PRIMA il giro a vuoto (**nessuna passata; APRE MetaEditor per compilare, non MT5**)

> ⚠️ **Corretto il 28/08: questo EA non era mai stato compilato da nessuno.**
> Il giro a vuoto ora **compila davvero** l'EA prima di dichiararsi
> completato — dura circa un minuto in più, ma se c'è un errore di sintassi
> lo scopriamo qui, non a corsa avviata. **Se la compilazione fallisce, il
> risultato del PASSO 0 è quello**: le righe rosse del log compaiono in
> console e in `COMPILAZIONE_FALLITA.log` dentro lo zip — si manda così com'è.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='55cacfa9f99a05c248ddf60d22a5362d7dc34b04'; $p="$env:USERPROFILE\RIGA_PASSO0_FVGRET.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_PASSO0_FVGRET.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_PASSO0_FVGRET_v2' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Cosa deve dire**, in ordine:

- `pin ......... <40 caratteri>` e `celle ....... 3 su 3`;
- `driver generico scaricato e PINNATO`;
- `file prova scaricati: 3`;
- `include scaricato: ABTG_PausaGuardian.mqh (<n> byte)`;
- `geometria, valori dei lati, baseline, stella e magic: TUTTI PASSATI`;
- `terminale scelto: ...` — **deve coincidere** con quello che stampa il
  driver generico (stesso selettore, corretto il 28/08);
- `include: INSTALLATO e VERIFICATO in ...`;
- `rischio ..... <n>% (default di InpRiskPercent letto NEL .mq5 al pin)`;
- **`compilato ABTG_FvgRetest: OK (<n> KB, <ora>)`** — è il primo risultato
  vero di questo PASSO 0. Se invece esce `COMPILAZIONE FALLITA`, le righe
  rosse sopra **sono il risultato**: si copiano in chat;
- tre volte l'anteprima dell'`.ini` del driver generico, e in fondo
  `ESITO: CONTROLLO COMPLETATO`.

Nel referto della **corsa vera**, guarda anche la sezione **`AUTOTEST DEL
NUCLEO`**: se dice `DIVERGE`, i numeri della tabella non si leggono. Se dice
`NON LETTO`, non è un guasto — il percorso dei log degli agent cambia fra le
build, e resta comunque nei RILIEVI, mai un blocco.

> ⚠️ **Quello che il giro a vuoto NON può fare:** `-SoloControllo` **non apre
> MT5**. Non esiste nessun `n`, nessun PF, nessun DD, **nessun controllo sui
> gemelli**. Conferma gli **artefatti**, mai i numeri.

---

## 2️⃣ POI la corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='55cacfa9f99a05c248ddf60d22a5362d7dc34b04'; $p="$env:USERPROFILE\RIGA_PASSO0_FVGRET.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_PASSO0_FVGRET.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_PASSO0_FVGRET_v2' -Quiet)){ throw 'SCRIPT VECCHIO' };
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
    $pin='55cacfa9f99a05c248ddf60d22a5362d7dc34b04'; $p="$env:USERPROFILE\RIGA_PASSO0_FVGRET.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_PASSO0_FVGRET.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_PASSO0_FVGRET_v2' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloCella '02_short' -Rifai;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo' -ForegroundColor Yellow } }
```

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul **Desktop**: `PASSO0_FVGRET_<MODO>_<data>_<ora>` — dentro:

- **`REFERTO_PASSO0_FVGRET.txt`** ← **è questo che conta**;
- i **file prova** delle celle che hanno girato;
- i **CSV** `ABTG_FvgRetest_D30EUR_IS_<cella>.csv` e `_OOS_<cella>.csv`.

### 📅 Le due righe da guardare per prime nel referto

1. **`modo:`** — dice `CORSA` (il risultato) o `CONTROLLO` (giro a vuoto:
   **non si manda come risultato**);
2. **`data:`** — **deve essere di ADESSO**.

---

## 🚩 COME SI LEGGE IL REFERTO — tre avvertenze, non tre note

1. 🧮 **`n(01_long) + n(02_short)` NON farà `n(00_nudo)`, e non è un guasto.**
   **Misurato nel sorgente:** `IngressiAmmessi()` esce con
   `if(CountPositions()>0) return(false)` **prima** di guardare il lato, e
   `CercaIngresso()` fa `return` dopo la **prima decisione della barra**. Con un
   lato spento **lo slot resta libero** e entrano segnali che nel `00_nudo`
   erano stati buttati. È un **fatto del motore**.
2. 📈 **La finestra è UN SOLO REGIME RIALZISTA** (21 mesi di feed BCM sugli
   indici, criterio C6). Il lato **short parte svantaggiato per REGIME**, non
   per merito del motore. Un *"niente edge short"* letto qui chiude la domanda
   **per questa epoca**, non in assoluto.
3. 💰 **Il cancello C2 (il costo) NON è nella tabella.** Si legge nella
   **mediana del take LORDO**, nell'export per-trade in `Common\Files`:
   `abtg_trades_ABTG_FvgRetest_D30EUR_<magic>.csv`.
   ⚠️ **Quel file porta il MAGIC nel nome, non la finestra: la gamba OOS
   SOVRASCRIVE la gamba IS dello stesso magic.** Quello che resta a disco è
   l'**ultima finestra girata**.
   ⚠️ E la soglia (**6,0 punti indice**) va convertita: **su D30EUR il rapporto
   punti MT5 / punti indice NON è agli atti** — R97 lo ha misurato su U30USD e
   NASUSD, non sul DAX. **[DA VERIFICARE sul simbolo.]**

---

## ✅ COSA È GIÀ STATO VERIFICATO — **eseguendo**, prima dell'invio

- ✅ il `.ps1` **parsa**: `pwsh` + `[Parser]::ParseFile` → **0 errori**,
  **4.592 token**; **ASCII puro** (0 caratteri non-ASCII, regola del 17/08);
- ✅ **audit delle collisioni CASE-INSENSITIVE fatto sui token del codice**:
  **zero collisioni**. Ed è servito: la prima stesura aveva `$R` (l'ArrayList
  del referto) contro `$r` (tre cicli) — **la stessa coppia del difetto di
  R109** — rinominata in `$RefTxt`; e usava **`$args`**, che è una **variabile
  automatica** di PowerShell, rinominata in `$argv`;
- ✅ **i gate girano DAVVERO sui tre file veri**: controllo positivo passato
  (3 celle, 6 magic unici);
- ✅ **e i gate sono stati fatti FALLIRE, uno per uno** — un gate che non scatta
  mai non è dimostrato. **Nove prove, nove fermate**, ognuna col messaggio
  giusto:

  | corruzione | il gate ha detto |
  |---|---|
  | i due file dei lati **scambiati** | `InpAllowLong vale 0, atteso 1` |
  | baseline mossa (`InpRegimeMode` 0→3) | `InpRegimeMode deve essere 0` |
  | magic **vietato** (775501, il sorgente) | `magic 775501 VIETATO` |
  | magic **duplicato** fra due celle | `magic 776100 in due celle` |
  | **secondo asse Y** | `deve avere ESATTAMENTE un asse Y, trovati 2` |
  | `@PERIODO` M15→M5 (**la trappola R102**) | `@PERIODO e' M5` |
  | una **riga in più** non dichiarata | `'InpTPAtrMult' differisce dal 00_nudo e NON e' dichiarato` |
  | **parametro doppio** nello stesso file | `DUE righe per 'InpAllowLong'` |
  | **corruzione SIMMETRICA** su tutti e tre | `InpEntryMode deve essere 0` |

  > 🔎 **L'ultima riga è la più importante.** Una riga storta **uguale in tutte
  > e tre le celle** passerebbe il gate della stella — _"un diff fra A e B non
  > può accorgersi di niente che sia uguale in A e in B"_ (lezione R110). Qui la
  > prende il **gate della baseline**, che confronta con un **valore assoluto
  > dichiarato** (`InpRegimeMode=0`, `InpEntryMode=0`) invece che con un altro
  > file.

🟡 **Non verificato, e va detto**: tutto ciò che richiede **MT5** — la
**compilazione** dell'EA (qui non c'è MetaEditor), il comportamento del tester,
la durata reale, e **ogni singolo numero**. Il giro a vuoto copre gli
artefatti; **i numeri li può dare solo la corsa**.
