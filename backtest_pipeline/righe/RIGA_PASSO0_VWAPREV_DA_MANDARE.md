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
| **Driver** | `righe/RIGA_PASSO0_VWAPREV.ps1` (marcatore `MARCATORE_RIGA_PASSO0_VWAPREV_v1`) |
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

## 📌 IL PIN — **`__PIN__`**

```
__PIN__
```

⚠️ **Il pin si rilegge DOPO il push, non prima.** Il commit da pinnare deve
contenere **tutti e sei** gli artefatti che lo script scarica:
`walkforward_generico.ps1`, `RIGA_PASSO0_VWAPREV.ps1`, i **quattro** file prova,
`ABTG_PausaGuardian.mqh` e **`mql5/Experts/ABTG_VwapRevert.mq5`** (che il driver
generico riscarica **al pin**).

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
```

⚠️ **Servono TUTTI E DUE i conteggi**: il solo *"0 pin vecchi rimasti"* lo supera
a mani basse anche un `sed` che **non ha matchato niente**. E il pin vecchio si
legge **DAI PUNTI D'USO** (`$pin='<40 caratteri>'`), mai con un `grep` largo.

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** Col terminale aperto il tester non
  gira (zero CSV); con MetaEditor aperto la compilazione torna subito **senza
  compilare**. La riga si rifiuta di partire in tutti e due i casi.
- 🔴 **L'EA NON È MAI STATO COMPILATO DA NESSUNO.** Scritto il 25/08, modificato
  il 28/08 (flat di fine seduta): in quell'ambiente **non esiste MetaEditor**.
  **Se la compilazione fallisce, il risultato del PASSO 0 è quello** e va
  riportato così com'è — non è un guasto della riga.
- 🧩 **La riga installa `ABTG_PausaGuardian.mqh`** in `MQL5\Include` prima di
  compilare. `walkforward_generico.ps1` **non lo fa** (verificato: nel driver
  generico la stringa `PausaGuardian` non compare), e senza quel file l'EA non
  compila.
- **NESSUNA SEDIA VIVA VIENE TOCCATA.** Magic vergini `7734xx`,
  `AllowLiveTrading=false` negli `.ini` (lo scrive il driver generico).
- **16 passate** (4 celle × 2 finestre × 2 gemelle), **8 CSV**, `Model=4`
  (**tick reali**), finestra **2024.09.26 → 2026.06.30**, split 40/60,
  deposito **100.000**, rischio **1%**.
- **Zero parametri spazzolati.** L'unico asse `Y` è `InpMagic`, e il driver
  **si ferma** se in un file prova ne trova un secondo.
- 🔧 Se non è già stato fatto: MT5 → Strumenti → Opzioni → Grafici →
  **"Max barre nel grafico" = Illimitato**.
- ⏱️ **Durata [STIMA, non una previsione]: 15-40 minuti** più la compilazione.
  R107 fece 24 passate a tick reali sulla stessa finestra in 9 minuti.

---

## 1️⃣ PRIMA il giro a vuoto (**nessuna passata, non apre MT5**)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='__PIN__'; $p="$env:USERPROFILE\RIGA_PASSO0_VWAPREV.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_PASSO0_VWAPREV.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_PASSO0_VWAPREV_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Cosa deve dire**, in ordine:

- `pin ......... <40 caratteri>` e `celle ....... 4 su 4`;
- `driver generico scaricato e PINNATO`;
- `file prova scaricati: 4`;
- `include scaricato: ABTG_PausaGuardian.mqh (<n> byte)`;
- `geometria, valori dei tre interruttori, baseline assoluta, stella e magic: TUTTI PASSATI`;
- `include: INSTALLATO in ...` — ⚠️ se dice **NON INSTALLATO** finisce nei
  **RILIEVI** e la compilazione passerà **solo se il file era già lì**;
- quattro volte l'anteprima dell'`.ini` del driver generico, e in fondo
  `ESITO: CONTROLLO COMPLETATO`.

> ⚠️ **Quello che il giro a vuoto NON può fare:** `-SoloControllo` **non apre
> MT5**. Non esiste nessun `n`, nessun PF, nessun DD, **nessun controllo sui
> gemelli**. Conferma gli **artefatti**, mai i numeri.

---

## 2️⃣ POI la corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='__PIN__'; $p="$env:USERPROFILE\RIGA_PASSO0_VWAPREV.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_PASSO0_VWAPREV.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_PASSO0_VWAPREV_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
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
    $pin='__PIN__'; $p="$env:USERPROFILE\RIGA_PASSO0_VWAPREV.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_PASSO0_VWAPREV.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_PASSO0_VWAPREV_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloCella '03_overnight' -Rifai;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo' -ForegroundColor Yellow } }
```

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul **Desktop**: `PASSO0_VWAPREV_<MODO>_<data>_<ora>` — dentro:

- **`REFERTO_PASSO0_VWAPREV.txt`** ← **è questo che conta**;
- i **file prova** delle celle che hanno girato;
- i **CSV** `ABTG_VwapRevert_D30EUR_IS_<cella>.csv` e `_OOS_<cella>.csv`.

### 📅 Le due righe da guardare per prime nel referto

1. **`modo:`** — dice `CORSA` (il risultato) o `CONTROLLO` (giro a vuoto:
   **non si manda come risultato**);
2. **`data:`** — **deve essere di ADESSO**.

### 🔬 E una cosa che NON sta nel referto: la scheda **Esperti**

L'EA stampa in avvio **DIECI blocchi `[VWAPREV][AUTOTEST]`** — il decimo è
proprio il **flat di fine seduta**. Se l'ultima riga dice **`DIVERGE`**, i numeri
**non si leggono**: c'è da guardare il codice.
Nelle tre celle col flat acceso deve comparire anche
`flat di fine seduta alle 20:45 server: N posizioni chiuse`. Se **non compare
mai**, il flat non ha mai avuto niente da chiudere — possibile, ma **va detto**,
non dato per scontato.

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
3. 🕗 **La `03_overnight` non può vincere** — vedi il riquadro rosso sopra.
4. 💰 **Il cancello S0 (il costo) NON È ADJUDICABILE OGGI, e non si stima.**
   Lo **spread medio di BCM su D30EUR in M15 non è misurato in casa** (il
   "1-2 punti indice" di `R98_CRITERI.md` è **[INCERTO]**) e il **rapporto punti
   MT5 / punti indice su D30EUR non è agli atti** (R97 lo ha misurato su U30USD
   e NASUSD, **non** sul DAX). Si legge la mediana del take **lordo**
   nell'export per-trade in `Common\Files`:
   `abtg_trades_ABTG_VwapRevert_D30EUR_<magic>.csv`.
   ⚠️ **Quel file porta il MAGIC nel nome, non la finestra: la gamba OOS
   SOVRASCRIVE la gamba IS dello stesso magic.**

---

## ✅ COSA È GIÀ STATO VERIFICATO — **eseguendo**, prima dell'invio

- ✅ il `.ps1` **parsa**: PowerShell 7.4.6 + `[Parser]::ParseFile` → **0 errori**,
  **5.037 token**; **ASCII puro** (0 caratteri non-ASCII, regola del 17/08);
- ✅ **audit collisioni CASE-INSENSITIVE sui nomi di variabile: zero**; e lo
  script **non usa `$args`** (variabile automatica di PowerShell);
- ✅ **i gate girano DAVVERO sui quattro file veri**: **controllo positivo
  passato**, eseguito **prima e dopo** la batteria delle corruzioni;
- ✅ **e i gate sono stati fatti FALLIRE, uno per uno** — un gate che non scatta
  mai non è dimostrato. **Undici prove, undici fermate**, ognuna col messaggio
  giusto:

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

🟡 **Non verificato, e va detto**: tutto ciò che richiede **MT5** — la
**compilazione** dell'EA (qui non c'è MetaEditor), l'esito dell'**autotest**
(si legge eseguendo), il comportamento del **flat sui tick veri**, la durata
reale, e **ogni singolo numero**. Il giro a vuoto copre gli artefatti; **i
numeri li può dare solo la corsa**.
