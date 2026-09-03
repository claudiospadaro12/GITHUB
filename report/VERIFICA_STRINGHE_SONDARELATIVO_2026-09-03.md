# 🔍 VERIFICA STRINGHE — SONDA RELATIVO, PASSO 0 (pin `665416e2fddc6d11b9537c303788ac749e606236`)

_Verificatore di stringhe, 03/09/2026. Oggetto: `backtest_pipeline/righe/RIGA_SONDARELATIVO_DA_MANDARE.md`
(5 blocchi), `backtest_pipeline/righe/RIGA_SONDARELATIVO.ps1` (marcatore `_v1`), i 4 prova
`prove/RELATIVO_{D30,NAS}_{M5,M15}.txt`, `mql5/Experts/ABTG_SondaRelativo.mq5` (letto, NON toccato),
`backtest_pipeline/walkforward_generico.ps1`. Tutto al commit `9019866` di `lavoro`._

**Metodo: eseguito, non letto.** `pwsh` 7.4.6 installato nell'ambiente: parse reale dei due `.ps1` e dei
5 blocchi della pagina; le funzioni del driver (`GateProva`, `GateGemelli`, `AnalizzaCsv`, `StatoCella`,
`Altopiano`) caricate con `Invoke-Expression` della porzione prima di `INIZIO ESECUZIONE` ed esercitate su
banco: **48 casi, 46 verdi e 2 rossi** — e i due rossi sono **lo stesso difetto**, quello che decide il verdetto.

```
VERDETTO    FAIL
STRINGA     i 5 blocchi della pagina sono corretti COSI' COME SONO (parse 0 errori, ASCII, 108/110/116-bis a
            posto) MA puntano a un driver che, su ogni CORSA riuscita, MUORE PRIMA DI SCRIVERE IL REFERTO E LO
            ZIP. La stringa da usare e' la STESSA pagina dopo: (1) la correzione del driver alle righe 1073-1074,
            (2) bump del marcatore _v1 -> _v2 nel driver e nei 5 blocchi, (3) ri-pinnatura col commit nuovo.
            Le righe esatte stanno nella sezione "CORREZIONI DA APPLICARE" qui sotto.
DIFETTI     1 BLOCCANTE (classe 79, riprodotto ed eseguito), 1 MINORE sulla pagina (classi 77/101), 4 RILIEVI
NON COPERTO compilazione e corsa MT5; Windows PowerShell 5.1 vero (parse su pwsh 7); comportamento del tester
            con FromDate > ToDate sulla gamba OOS degenere; sezione 5 del driver (scelta terminale) non eseguibile
            qui; metaeditor64 con percorsi contenenti spazi (pattern di casa, 14 driver lo usano uguale)
```

---

## 1. 🛑 DIFETTO 1 — BLOCCANTE — `$r` del ciclo delle 49 celle DISTRUGGE `$R`, il referto (classe 79)

**Dove:** `backtest_pipeline/righe/RIGA_SONDARELATIVO.ps1`, righe **1073-1074** (sezione RACCOLTA, tabella
"LE 49 CELLE"):

```powershell
$R = New-Object System.Collections.ArrayList          # riga 993: il referto
...
foreach($r in ($Righe49 | Sort-Object N, Sigma)){     # riga 1073: $r == $R (PowerShell e' case-insensitive)
  [void]$R.Add(("{0,3} ..." -f $r.N, ...))            # riga 1074: $R e' ora la RIGA del CSV, non l'ArrayList
```

**Cosa succede, misurato sul banco** (sezione RACCOLTA del driver eseguita con `$Righe49` popolato da un CSV
sintetico di 49 righe costruito dall'header vero del sorgente):

```
Method invocation failed because [System.Management.Automation.PSCustomObject] does not contain a method named 'Add'.
tipo di $R dopo la raccolta: PSCustomObject
referto presente: False | zip: False
```

E' un errore terminante **fuori dal `try`** (la RACCOLTA sta dopo il `catch`, apposta, classe 116): lo script
muore li'. Conseguenze, in ordine di costo:
1. **ogni CORSA riuscita** (CSV fresco, 49 righe, collaudi verdi — cioe' il caso BUONO) finisce **senza
   referto e senza zip**: la sentinella e' gia' stata tolta (riga 980, prima del punto di morte) e sul
   Desktop resta la cartella `SONDARELATIVO_<PROVA>_<stamp>` VUOTA (creata alla riga 986, prima del referto);
2. il blocco della pagina fa esattamente quello che deve: `NESSUNO ZIP SONDARELATIVO_D30_M15_ DI ADESSO SUL
   DESKTOP: la corsa non e' arrivata alla raccolta` — un rosso VERO su una corsa sana, **dopo 8-45 minuti di
   macchina**, quattro volte (i quattro blocchi);
3. **il giro a vuoto NON lo vede**: in CONTROLLO `$Righe49` e' `$null`, il ciclo non entra, il referto
   esce, lo zip esce, la pagina stampa `CONTROLLO OK`. Misurato: `RACCOLTA originale in CONTROLLO -> passa`.
   Claudio lancerebbe i blocchi 2-5 con la luce verde del blocco 1.

Le uniche righe fuori dal `try` in cui una variabile di ciclo condivide il nome (a meno del case) con una
variabile viva sono queste due. Il resto del driver e' pulito: scansione con il parser di PowerShell su tutte
le `VariableExpressionAst` raggruppate per nome minuscolo — `ha/hA` e `mappa/Mappa` sono coppie in **funzioni
diverse** (locali, nessun clash); `r/R` e' l'unica al livello di script.

**La correzione, provata sul banco** (referto scritto, 155 righe, tabella con 49 righe, zip sul Desktop,
`ESITO: CORSA COMPLETATO`; parse 0 errori, ASCII puro):

```bash
F=backtest_pipeline/righe/RIGA_SONDARELATIVO.ps1
sed -i '1073,1074s/\$r\b/$rw/g' "$F"                   # 20 sostituzioni: 1 nel foreach + 19 nella -f
sed -n 1073,1074p "$F" | grep -o '\$rw' | wc -l         # DEVE dare 20
sed -n 1073,1074p "$F" | grep -c '\$r[ ."]'             # DEVE dare 0 ($R.Add resta: sed e' case-sensitive)
```

Perche' e' passato al banco della sessione principale: quel banco esercitava le **funzioni** (gate, analisi
CSV: 21/21 verdi, e sono verdi anche qui) — il difetto sta nel **flusso a livello di script**, nella sezione
che gira **dopo** le funzioni, e solo quando lo stato e' pieno. E' la classe **109** (il nucleo collaudato non
e' il codice che gira) applicata a una classe **79** gia' nota. Aggiunta come **79-bis** alla checklist, col
comando di scansione che l'avrebbe presa in due secondi.

## 2. 🟡 DIFETTO 2 — MINORE — il terzo conteggio della ricetta del pin da' **3**, non 0 (classi 77 / 101)

La pagina prescrive (riga 350): `grep -ci "segnaposto\|non funziona\|la riga non parte" "$F"   # DEVE dare 0`.
**Eseguito: da' 3.** Le tre occorrenze (pagina al commit 9019866):

| riga | testo | perche' conta |
|---|---|---|
| 148 | `✅ **INSERITO il 03/09/2026** (prima di questo commit qui c'era un segnaposto).` | il cartello riscritto al passato (forma AMMESSA dalla 101) contiene la parola cercata |
| 347 | `# e il CARTELLO del segnaposto si RISCRIVE (classe 101), non si lascia:` | commento della ricetta |
| 350 | `grep -ci "segnaposto\|..."` | **la ricetta contiene per esteso le parole che cerca** — e' il difetto 77 (la ricetta che riscrive/conta se stessa), sulla terza riga invece che sulla prima |

Non ferma niente oggi (il pin e' vero: vedi sezione 4). Ma alla prossima ri-pinnatura — che con il difetto 1
**e' certa** — chi esegue la ricetta legge `3` dove c'e' scritto `DEVE dare 0` e o si mette a cercare un
cartello che non c'e', o impara a ignorare il conteggio (guardiano decorativo, punto 14). Le pagine gemelle
(`RIGA_SONDALONDONFX`, `RIGA_COMPILA_ORB104`, `RIGA_DEPLOY_ORB104_PICCOLO`) danno **0** perche' non usano la
parola ne' nel cartello ne' nella ricetta.

**Aggiornamento a fine verifica (commit `ccaafa4`, arrivato durante il banco):** la sessione principale ha
composto il terzo conteggio (`CART='segnap'"osto\|..."`), quindi la riga 350 non conta piu' se stessa. Eseguito
sulla pagina a HEAD: **da' 2** (righe 148 e 347 restano). Le due righe qui sotto vanno ancora riformulate.

**Correzione (pagina):**
- riga 148 -> `✅ **INSERITO il 03/09/2026** (prima di questo commit qui c'era il token @@PIN composto, non un commit).`
  — senza le tre parole, e senza le parole della 101-ter (`non esiste`, `provvisori`, `da sostituire` vicino a "pin");
- riga 347 -> `# e il CARTELLO del token si RISCRIVE al passato (classe 101), non si lascia:`;
- riga 350 -> gia' composta in `ccaafa4` (`CART=...`): resta cosi'.

## 3. 🔎 RILIEVI (non bloccano; si dichiarano)

1. **Residuo non fotografato (spirito della 116).** Il generico compila **una seconda volta** con
   `& $MetaEditor "/compile:..." "/log"` (`walkforward_generico.ps1` riga 604): `/log` senza nome scrive
   `MQL5\Experts\ABTG_SondaRelativo.log` **dentro il terminale**. Non e' nella sentinella ne' nella foto
   PRIMA/DOPO (che copre `.mq5`, `.ex5`, `OptResults_*.csv`). Proposta: aggiungere quel `.log` alla foto e alla
   riga `pulizia:` come residuo dichiarato (o toglierlo nella raccolta, e' nostro).
2. **Incrocio esiti sonda/driver senza tolleranza sull'arrotondamento del CSV.** Il driver ricalcola C1/C3/C6/C8
   dai valori **stampati** (`%.2f`, `%.3f`, `%.4f`) e pretende l'uguaglianza con l'esito che la sonda ha
   calcolato sul `double` pieno. Un valore a cavallo della soglia per meno di mezza unita' dell'ultima cifra
   (es. RR 0,69996 -> "0.7000" -> driver 1, sonda 0; non-convergute 40,004 -> "40.00") produce un `NON
   coincidono` **falso** e la corsa esce `NON LEGGIBILE`. Probabilita' bassa (le mediane hanno risoluzione
   0,005 punti; RR e percentuali no) — la ricalcolo e' giusta, e' il confronto che andrebbe fatto con
   `epsilon` = mezza unita' stampata, oppure dichiarato nel referto come "a cavallo della soglia".
3. **Classe 115, a meta'.** La scelta del terminale parte da un FATTO (`bases\*BCM*` nella cartella dati) e
   consegna la manopola `-Terminale` con l'elenco: bene. Ma fra piu' candidate BCM preferisce per **nome**
   (`-notlike "*-V3*"`) e non scandisce il caso portable (nessun `origin.txt`). Sul PC di backtest, dove il
   generico usa da 100+ round lo stesso criterio, non e' un giro a vuoto atteso; e' dichiarato nei RILIEVI del
   referto quando scatta.
4. **Lo storico del METRO.** I quattro prova prescrivono `scarica_storico.ps1 -Simboli "U30USD"` PRIMA di
   lanciare; la pagina si appoggia alla misura del 17/08 (`REFERTO_SONDA_STORICO_17-08.md`). Se sul PC di
   backtest la serie M5/M15 di U30USD non e' nella cache del terminale, la sonda conta "metro mancante" e il
   collaudo `Metro Prima Barra Epoch` boccia la corsa (onesto: `NON LEGGIBILE`), ma dopo decine di minuti. Una
   riga in pagina ("se non l'hai scaricato dal 17/08, prima `scarica_storico.ps1 -Simboli U30USD`") costa zero.

## 4. ✅ COSA E' STATO VERIFICATO E REGGE (con il comando, non a memoria)

**Il pin (77 / 77-bis / 77-ter / 101 / 101-ter / 103 / 100).**
- `665416e2...` esiste, e' un **commit** ed e' **antenato di `origin/lavoro`** (`git merge-base --is-ancestor`).
- I 7 artefatti hanno blob **identici** fra pin, HEAD e `origin/lavoro`; gli sha256 al pin sono quelli scritti
  in pagina: driver `af9f8056`, generico `5d98af3d`, prova `fa29b70b / 86c0fe18 / 1f9dd9a1 / f8565ef9`, sonda
  `80ed8a45`. `git status` pulito su `backtest_pipeline/` e `mql5/`.
- Conteggi: `$pin='665416e2...'` = **5** (1 giro a vuoto + 4 corse); `$pin='@@PIN@@'` = **0**; hash a 40 in
  pagina = 6 (5 punti d'uso + il titolo `**\`...\`**`, forma del 77-ter); prefisso `665416e` in
  `backtest_pipeline/` = 6, tutti in questa pagina; **nessun pin vecchio** (e' la prima pinnatura).
- 101-ter: `grep -nEi "pin.*(non esiste|non e'? verificat|segnaposto|provvisori|da sostituire)"` -> **0**;
  i rinvii "qui sopra" sono tutti dentro i blocchi e puntano alla riga del blocco stesso.
- Classe 100: `RIGA_SONDARELATIVO.ps1` e' nominato in **un solo** `.md` (la pagina); il marcatore
  `MARCATORE_RIGA_SONDARELATIVO` non compare in nessun altro file del repo.

**I .ps1 (controlli 1-12 della tabella dell'agente).**
- non-ASCII: driver **0**, generico **0**, 5 blocchi **0** (controllo 1);
- formati .NET: nessun `{n,<}` / `{n:<}` alla Python; la `-f` della tabella usa `{0,3} {1,5} ...` con 18
  segnaposto e 18 argomenti (controllo 2);
- cultura: `CurrentCulture = Invariant` in testa; `Num` = `[double]::Parse($s,$INV)`; ogni `ToString` numerico
  o di data porta `$INV`; `ParseExact(...,$INV)`; nel generico i cast `[double]"0.15"` sono invarianti per
  costruzione di PowerShell (controllo 3);
- cache raw: i blocchi puntano all'HASH e verificano il marcatore con `Select-String -SimpleMatch` prima di
  eseguire; `Remove-Item $p` PRIMA dell'`irm` e `-EA Stop` dentro `& { $ErrorActionPreference='Stop' }`
  (controlli 4, 5, checklist 8);
- MT5 chiuso: guardia `Get-Process terminal64,metaeditor64` **sia** nel blocco (prima dell'`irm`) **sia** nel
  driver (riga 651); il generico ha la sua su `terminal64` (controllo 6);
- niente stringhe vuote passate: gli interruttori sono switch (`-SoloControllo`, `-AccettoTettoBarre`);
  `-Terminale` si passa solo con un valore (controllo 7);
- `fermoDa`: **0** (controllo 8); ora server: `InpOraInizioServer=14`/`InpMinInizioServer=30` = 15:30
  italiane, `InpOraFineServer=22`, coerenti con "server = IT - 1" (controllo 9); PTE: non pertinente (10);
  `@DAQUANDO 2024.09.26` e' il pavimento MISURATO del 17/08, gattato dal driver contro i 4 prova (11);
- quoting: 5 blocchi parsati **0 errori**; apici raddoppiati `e''` corretti; nessun ternario, `??`, `&&`,
  `-AsHashtable` (PS 5.1) (controllo 12);
- 108: `($rc -is [int]) -and ($rc -ne 0)` nei blocchi; nel driver `$rcLetto` a tre stati per generico e
  metaeditor; 110: la riga di freschezza stampa **l'ora di avvio** da `$t0` con `$iv` e cita il gate sullo zip;
  116-bis: la terna del Desktop e' **identica** (stesso ordine, stesso fallback `$env:USERPROFILE`) nei 5
  blocchi e in `TrovaDesktop` (grep = 5); 112: opzioni citate in pagina e header (`-Pin`, `-Prova`,
  `-SoloControllo`, `-AccettoTettoBarre`, `-Terminale`; `-Simbolo`/`-Periodo`/`-Rifai` come opzioni DEL
  GENERICO) esistono tutte nei rispettivi `param()`.

**Sezione 3 (regole delle righe di lancio).** `irm` dall'hash davanti: si'. Raccolta in fondo: si', con zip
datato (`LastWriteTime -ge $t0`) e l'elenco dei file attesi stampato dal driver. Riga `data:` interna: la
pagina dice quale orologio (avvio) e lo stampa.

**Il driver, sul banco (46 verdi).**
- identita' del sorgente: 22 input, 21 `blocchi++` fuori commenti, `[AUTOTEST] 21` presente (e `210` non
  passa: ancorato), `REL_NSTATS 93`, define mancante -> throw, versione `1.001` != `1.00`;
- le soglie dai `#define` = quelle della pagina: C1 2,00 · C3 3x/6x · spread 2,80/1,80 (-> 8,40/5,40) ·
  C5 0,70 · C6 25/40 · C8 12/25 · C2 10 · C7 0,65/3,25;
- **le disuguaglianze del driver sono quelle di `OnTester`** (lette alle righe 2205-2246 del `.mq5`):
  C1 `>=`, C3 `> largo` / `>= soglia`, C5 `>=`, C6 `> KO` / `> SOSP`, C8 `sotto60 >= KO` / `tenuta < MIN`;
- `GateProva` verde sui 4 prova veri (49 celle ciascuno) e **rosso su 15 mutazioni** (periodo, simbolo,
  @DAQUANDO, @FINOA, input inesistente, input mancante, riga estranea, fisso diverso, fisso sweepato, asse
  diverso, asse degenere, riga doppia, metro diverso, tag diverso, direttiva col commento in coda);
  `GateGemelli` verde sui 4 veri, rosso con un gemello diverso di una riga;
- `AnalizzaCsv` su CSV sintetico dall'header VERO (96 colonne; le 73 lette dal driver esistono tutte):
  sano -> 0 problemi, cella di riferimento trovata, VIVO/VIVO; 48 righe -> problema; autotest -1 -> NON
  LEGGIBILE; esito C6 falso -> 49 incroci rossi; spread NAS su corsa D30 -> rosso; metro dopo la gamba ->
  rosso; eco pin 0,10 -> rosso; C6 30% -> SOSPESO; MFE long 8,0 -> LONG NO / SHORT VIVO; **una sola cella viva
  isolata -> NO su entrambi i lati** (altopiano, non picco); CSV piu' vecchio dell'avvio -> STANTIO, non
  letto; CSV assente -> problema.

**Il generico al pin.** `$EABranch="lavoro"` presente (il driver lo ri-pinna); `-Prova`, `-Etichetta`,
`-Modello`, `-Rifai`, `-Terminal`, `-MetaEditor`, `-DataFolder`, `-SoloControllo` esistono nel `param()`;
il nome del CSV `<EA>_<SIM>_IS_ohlc_<Etichetta>.csv` e la cartella `risultati_prove\<EA>` sotto
`$PSScriptRoot` coincidono con quelli che il driver legge; l'anteprima `anteprima_<EA>_<SIM>.ini` idem;
`AllowLiveTrading=false` nell'ini (classe 51).

**Il sorgente (solo letto).** 0 chiamate di trading fuori commenti (stesso modello del driver), 0
`#include`, 0 commenti a blocco, `OptFrame_FileName` = `OptResults_<EA>_<Symbol>.csv` senza TF (la scelta
"una corsa per invocazione" e' fondata), CSV riga-per-segnale spento in ottimizzazione, `SymbolSelect` del
metro con `INIT_FAILED` se manca. Nessun difetto da segnalare sul `.mq5` per questo giro.

## 5. 🔧 CORREZIONI DA APPLICARE (sessione principale), nell'ordine

```bash
# 1. DRIVER: il difetto 1 + bump del marcatore (il blocco vecchio col pin nuovo non deve passare: 98/100)
F=backtest_pipeline/righe/RIGA_SONDARELATIVO.ps1
sed -i '1073,1074s/\$r\b/$rw/g' "$F"
sed -i 's/MARCATORE_RIGA_SONDARELATIVO_v1/MARCATORE_RIGA_SONDARELATIVO_v2/' "$F"
sed -n 1073,1074p "$F" | grep -o '\$rw' | wc -l      # 20
grep -c "MARCATORE_RIGA_SONDARELATIVO_v2" "$F"       # 1
grep -cP '[^\x00-\x7F]' "$F"                          # 0
# (facoltativo, rilievo 1) aggiungere Experts\ABTG_SondaRelativo.log alla foto e alla riga pulizia:

# 2. PAGINA: marcatore nei 5 blocchi + nelle 2 righe di tabella, e il difetto 2
P=backtest_pipeline/righe/RIGA_SONDARELATIVO_DA_MANDARE.md
sed -i 's/MARCATORE_RIGA_SONDARELATIVO_v1/MARCATORE_RIGA_SONDARELATIVO_v2/g' "$P"
grep -c "MARCATORE_RIGA_SONDARELATIVO_v2" "$P"       # 7 (5 blocchi + riga Driver + riga della tabella del pin)
# riga 148, 347, 350: come nella sezione 2 (parole composte); la riga della tabella "file al pin" del driver
# porta lo sha256 af9f8056: dopo il commit va RICALCOLATO (git show <NUOVO>:$F | sha256sum) o tolto.

# 3. COMMIT del driver + pagina, poi RI-PINNATURA con la ricetta della pagina (VECCHIO=665416e2..., NUOVO=HEAD)
#    e i QUATTRO conteggi: $pin nuovi = 5, $pin vecchi = 0, terzo conteggio composto = 0,
#    grep -rn "665416e" backtest_pipeline/  -> deve restare SOLO nella prosa storica di questo referto/pagina
#    (il 77-bis: la storia non si tocca), MAI in un blocco incollabile.
# 4. Rimandare al verificatore per la SECONDA passata prima dell'invio (45: il residuo della correzione).
```

## 6. ⚪ NON COPERTO

- **Compilazione e corsa MT5**: non eseguibili qui. La compilazione e' il perimetro del giro a vuoto (che
  compila davvero: il driver chiama `metaeditor64` PRIMA del generico, quindi la classe 39 non morde).
- **Windows PowerShell 5.1 vero**: parse su pwsh 7.4.6. Cercati e assenti i costrutti PS7-only nei blocchi e
  nel driver; `Compress-Archive`, `Get-Process a,b`, `-LiteralPath`, `[ordered]` sono tutti 5.1.
- **`FromDate > ToDate` sulla gamba OOS degenere**: cosa fa il tester NON e' misurato (lo dice la checklist
  stessa, 31/08). Il driver e la pagina lo trattano come "rosso atteso"; se il terminale non si chiudesse da
  solo (`ShutdownTerminal=1` con test non avviato) il `WaitForExit` del generico resterebbe appeso: **da
  osservare alla prima corsa**, ed e' il pezzo che la pagina dichiara innocuo (corollario di quella classe).
- **Sezione 5 del driver (scelta del terminale)**: dipende da `%APPDATA%\MetaQuotes\Terminal`; non eseguibile
  qui, letta soltanto (rilievo 3).
- **Percorsi con spazi in `%USERPROFILE%`** passati a `metaeditor64 /compile:` e a `powershell -File`:
  PowerShell li quota da solo per i comandi nativi; e' il pattern di 14 altri driver di casa, non e' stato
  provato su Windows in questa sessione.
- **Rilievo 4** (storico U30USD nella cache del terminale di backtest): non verificabile da qui.

---
_Banco eseguito con `pwsh` 7.4.6 (Linux): `parse.ps1`, `bench.ps1` (48 casi), `casing.ps1` (scansione
classe 79 col parser). Nessun file del forward toccato; `.mq5` non modificato._
