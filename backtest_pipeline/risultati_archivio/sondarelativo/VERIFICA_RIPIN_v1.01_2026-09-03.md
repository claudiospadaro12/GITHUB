# ✅ SONDA RELATIVO — verifica del ri-pin sulla v1.01 dell'EA (03/09/2026)

**Motivo:** `mql5/Experts/ABTG_SondaRelativo.mq5` e' passato a **v1.01**
(commit `2fd6a1e`: fix del gate C2 "Giorni Spaiati", nuova colonna
"Giorni Festa Metro", autotest 21->22 blocchi, `REL_NSTATS` 93->94, 96->97
colonne CSV). Il driver `backtest_pipeline/righe/RIGA_SONDARELATIVO.ps1`
(pin precedente, commit `ed46f2f`) aveva i gate ancora ancorati ai numeri
**VECCHI** della sonda: sarebbe partito e si sarebbe fermato subito al passo
2 ("IDENTITA' DEL SORGENTE AL PIN") con `#property version e' '1.01', attesa
'1.00'` — un giro a vuoto pieno (compilazione compresa) per un disallineamento
noto in anticipo.

## Cosa e' stato corretto (commit `526f76f6`, driver)

| dove | prima | dopo |
|---|---|---|
| riga 78-79 (commento header) | `"1.00"`, `21 blocchi`, `REL_NSTATS 93 (= 96 colonne)` | `"1.01"`, `22 blocchi`, `REL_NSTATS 94 (= 97 colonne)` |
| riga 158 | `$VERSIONE_ATTESA = "1.00"` | `"1.01"` |
| riga 159 | `$AUTOTEST_BLOCCHI_ATTESI = 21` | `22` |
| riga 160 | `$NSTATS_ATTESI = 93` (commento "96 colonne") | `94` (commento "97 colonne") |
| riga 706 | `"REL_NSTATS = ... (96 colonne)"` | `"... (97 colonne)"` |
| riga 1010 | `"colonne: ... (attese 96)"` | `"... (attese 97)"` — **quinta occorrenza non segnalata dallo sviluppatore**, trovata leggendo il file per intero (punto 1 della checklist) |
| riga 1088 | `"...96 colonne OPTFRAME."` | `"...97 colonne OPTFRAME."` |
| riga 1119 | `"...96 colonne + gli input..."` | `"...97 colonne + gli input..."` |
| riga 2 (marcatore) | `MARCATORE_RIGA_SONDARELATIVO_v2` | `_v3` (contenuto cambiato = versione alzata, classe 109-bis) |

Il check `if($src -notmatch '\[AUTOTEST\]\s+21\s')` (riga 702) e' rimasto
**invariato**: il blocco `[AUTOTEST] 21` (AggiornaEscursione_Calc) esiste
ancora nel sorgente v1.01 (l'autotest e' cumulativo, il nuovo BLOCCO 22 si
aggiunge), quindi il check resta valido senza modifiche.

## Controlli eseguiti a macchina (pwsh disponibile nell'ambiente)

1. **Parse reale** dei 5 blocchi PowerShell della pagina `_DA_MANDARE.md`
   (`[System.Management.Automation.Language.Parser]::ParseFile`): **tutti
   PASS**, zero errori.
2. **Zero caratteri non-ASCII** nel driver `.ps1` (`grep -P '[^\x00-\x7F]'`).
3. **Classe 79/79-bis** (collisione `$r`/`$R`, PowerShell case-insensitive):
   parser AST eseguito sul driver. Tre gruppi segnalati (`ha`, `mappa`, `r`)
   — tutti **giudicati manualmente e confermati INNOCUI**: `$R` (referto)
   nasce alla riga 993 e non esiste prima; ogni `foreach($r in ...)` prima
   di quel punto vive e muore in uno scope disgiunto nel tempo; dopo la
   riga 993 il ciclo sulle 49 celle usa `$rw` (fix gia' presente dal commit
   `ed46f2f`, classe 79-bis). `ha`/`mappa` sono variabili locali di funzioni
   diverse (`GateGemelli` vs `AnalizzaCsv`; `LeggiProva` vs lo script-level
   `$Mappa`), scope separati.
4. **I nuovi valori attesi combaciano col `.mq5` reale su disco**, letti
   con la STESSA logica del driver (regex `#property version`, conteggio
   `blocchi++;`, `#define REL_NSTATS`, conteggio `input `):
   `versione=1.01` (match), `blocchi=22` (match), `REL_NSTATS=94` (match),
   `input=22` (match), `0` chiamate di trading, `0` `#include`.
5. **Le 97 colonne della head del `.mq5`** (94 stats + Pass/Simbolo/Periodo,
   ultima `Giorni Festa Metro`) **coprono tutte le 73 colonne** che il
   driver pretende per nome (`$servono`), estratte ed eseguite a macchina.
   `fmt1+fmt2+fmt3` hanno **97 specificatori**, combaciano con la head.
6. **Guardia MT5/MetaEditor** (`Get-Process terminal64,metaeditor64`):
   presente nel driver (riga 651) e in tutti e 5 i blocchi della pagina.
7. **Cultura invariante**: `$INV`/`InvariantCulture` usata in modo
   pervasivo per `Parse`/`ToString` su valori numerici e date; nessun
   `[double]$stringa` sospetto trovato.
8. **Tetto ~100.000 barre**: `$TETTO_GIORNI = @{ "M5"=475; "M15"=1461 }`
   invariato, coerente con CLAUDE.md (25/08).
9. **Classi 108/110/116** (exit code a tre stati, timbro `data:` = ora di
   avvio, sentinella + foto prima/dopo): gia' presenti e corrette nel
   driver dal pin precedente; non toccate da questo giro, ri-verificate
   per lettura integrale.

## Ri-pin della pagina (commit `526f76f6`)

Pin precedente `ed46f2f...` -> nuovo `526f76f6bef2b82b3e28edc0fc1306a3eeee1be9`
(il commit che ha corretto il driver). Verificato via `raw` che al pin
driver + 4 prova + `.mq5` + `walkforward_generico.ps1` sono **identici a
HEAD** (hash confrontati uno per uno). Marcatore aggiornato in tutti i punti
d'uso (definizione + tabella + 5 `Select-String` dei blocchi). Nessun
residuo del pin vecchio nella pagina, nemmeno abbreviato (classe 103;
l'unico residuo di `ed46f2f...` nel repo e' nel referto archiviato
`REFERTO_SONDARELATIVO_D30_M15.txt` qui accanto, che e' un record storico
di una corsa gia' avvenuta e non va riscritto).

## Verdetto

**PASS.** Driver e pagina ri-pinnati e allineati alla v1.01 dell'EA;
un difetto in piu' (riga 1010, "96 colonne" non segnalata) trovato e
corretto leggendo il file per intero, non fidandosi solo dei numeri di
riga forniti.

**NON COPERTO:** compilazione reale con MetaEditor e corsa MT5 vera (fuori
dal perimetro eseguibile qui: PC di backtest Windows, non disponibile in
questo ambiente). Il collaudo qui sopra e' analisi statica + esecuzione
reale della logica di parsing/gate del driver contro il `.mq5` vero letto
da disco, non una corsa del tester.

---

## SEGUITO (03/09 sera): perche' la v1.01 non ha spostato un centesimo

La corsa rifatta con la v1.01 (`REFERTO_D30_M15_2026-09-03_1814_v101_IDENTICO_A_PREFIX.txt`)
e' IDENTICA alla v1.00 su ogni numero: `diff` delle righe 48-130 dei due
referti mostra come uniche differenze i blocchi di autotest (21 -> 22) e le
colonne (96 -> 97). Quindi la v1.01 girava per davvero.

**Non e' un bug di collegamento.** Ogni anello e' stato verificato riga per
riga: `GiorniMetroAttivi_Calc` chiamata in `ValutaBarraChiusa`;
`gDayFestaMetro` scritto nei due punti giusti; letto in `ChiudiGiornata`
nell'`else` di `gDaySpaiato`; esportato in `stats[93]` e in intestazione CSV.

**La condizione non si e' mai verificata, e si dimostra senza rigirare.**
Per costruzione `Spaiati(v1.01) = Spaiati(v1.00) - GiorniFestaMetro`; poiche'
44 = 44 su tutte le 49 celle, `gGiorniFestaMetro = 0`. La v1.01 chiedeva
"zero barre del metro in TUTTO il giorno di calendario": U30USD e' un CFD
quasi 24h e la coda di 300 barre finisce sempre dopo le 14:30 server, quindi
contiene sempre le barre NOTTURNE del metro dello stesso giorno. I 352 buchi
non sono giornate intere, sono PEZZI della finestra 14:30-22:00.

"Giorni Festa Metro" non compare nel referto perche' il referto lo scrive il
DRIVER dal CSV e il driver non stampa quella colonna: nel CSV c'e' (il
referto stesso dichiara 97 colonne lette).

**v1.02**: stessa logica, granularita' della FINESTRA ORARIA invece del
giorno di calendario. Il criterio vecchio resta come controllo
("Giorni Metro Zero Calendario", atteso 0). REL_NSTATS 95 / 98 colonne,
autotest 23 blocchi -> **il driver va aggiornato** (versione attesa 1.02).

**NON COPERTO:** compilazione e corsa vera. Il fix v1.02 rende il criterio
non-vuoto; NON e' promesso che porti C2 sotto il 10% su questa coppia --
lo dira' la corsa, e le due colonne nuove diranno anche perche'.

---

## SEGUITO (03/09 sera, parte 2): driver ri-pinnato sulla v1.02, verificato dall'agente VERIFICATORE

**Motivo:** come previsto a fine sezione precedente, il driver era rimasto
ancorato ai numeri v1.01 mentre il sorgente e' gia' v1.02 (commit `d3e589c` +
note `7e3c5a0`). Letto `mql5/Experts/ABTG_SondaRelativo.mq5` per intero (non
fidandosi dei numeri di riga forniti): `#property version "1.02"` (riga 292),
`grep -c '^\s*blocchi++;'` = **23** (non 22), `#define REL_NSTATS 95` (riga
439) -> **98 colonne** (95 + Pass/Simbolo/Periodo), confermato leggendo la
head CSV per intero (righe 2844-2882): le ultime due voci sono `Giorni Festa
Metro,Giorni Metro Zero Calendario`, e `fmt1+fmt2+fmt3` hanno **95**
specificatori numerici (32+31+34, righe 2889-2891) — combacia. Input EA
invariati: **22** (`grep -cE '^\s*input\s+...\s*='`).

### Corretto nel driver (`backtest_pipeline/righe/RIGA_SONDARELATIVO.ps1`)
| dove | prima | dopo |
|---|---|---|
| riga 2 (marcatore) | `_v3` | `_v4` (contenuto cambiato = versione alzata, classe 109-bis) |
| righe 82-83 (commento header) | `"1.01"`, `22 blocchi`, `REL_NSTATS 94 (= 97 colonne)` | `"1.02"`, `23 blocchi`, `REL_NSTATS 95 (= 98 colonne)` |
| riga 162 | `$VERSIONE_ATTESA = "1.01"` | `"1.02"` |
| riga 163 | `$AUTOTEST_BLOCCHI_ATTESI = 22` | `23` |
| riga 164 | `$NSTATS_ATTESI = 94` (commento "97 colonne") | `95` (commento "98 colonne") |
| riga 713 | `"REL_NSTATS = ... (97 colonne)"` | `"... (98 colonne)"` |
| riga 1017 | `"colonne: ... (attese 97)"` | `"... (attese 98)"` |
| riga 1096 | `"...97 colonne OPTFRAME."` | `"...98 colonne OPTFRAME."` |
| riga 1127 | `"...97 colonne + gli input..."` | `"...98 colonne + gli input..."` |
| `$servono` (lista colonne pretese per nome) | non chiedeva le due colonne nuove | aggiunte `"Giorni Festa Metro","Giorni Metro Zero Calendario"` |
| lettura riga CSV (`$r` per-cella) | non leggeva le due colonne nuove | aggiunti i campi `GFesta`/`GZeroCal` |
| collaudi per riga | nessun controllo sulla colonna diagnostica | RILIEVO se `Giorni Metro Zero Calendario` != 0 (il vecchio criterio v1.01, atteso 0 su un metro quasi-24h) |
| referto (riga di riferimento) | non stampava le due colonne | nuova riga "diagnostica C2 (v1.02): Giorni Festa Metro ... / Giorni Metro Zero Calendario ..." |

**Le due colonne diagnostiche NON sono state aggiunte alla tabella delle 49
celle** (che ha gia' 18 campi posizionali in un'unica `-f` format string):
sono diagnostiche di calendario/metro, per costruzione COSTANTI sulla griglia
(N, sigma) entro la stessa corsa (le festivita' non dipendono dai parametri
del motore), quindi la riga di riferimento (`r0`) le rappresenta gia' tutte.
Stravolgere il format string a 20 campi avrebbe rischiato uno sfasamento
silenzioso — la classe di difetto che le tabelle a colonne fisse hanno gia'
pagato altrove. Dichiarato: resta per un giro successivo se Claudio la vuole
comunque per-cella (es. per scovare un'anomalia SU una sola cella, che
implicherebbe un bug diverso dal calendario).

### Difetto di classe gia' nota (109-bis) trovato per strada — DUE occorrenze
La pagina `RIGA_SONDARELATIVO_DA_MANDARE.md` aveva **due** numeri rimasti
fermi alla v1.00, **anche dopo** il ri-pin v1.00->v1.01 di stamattina (non
erano stati toccati in quel giro): riga 97 ("`Autotest Falliti` = **0** su
**21** blocchi", nella sezione "CLAUSOLA SEVERA SUI COLLAUDI") e riga 307
("autotest 0/21", nella sezione "COME SI LEGGE", punto 8) — la seconda
trovata solo in un secondo passaggio con `grep -n '0/21\|autotest.*21'`
sull'intera pagina, dopo aver corretto la prima e riletto il file intero
invece di fidarsi della prima passata. Entrambe corrette a 23. Non sono
difetti introdotti in questo giro, ma residui del giro precedente non
pescati allora — lezione della classe 109-bis: un conteggio citato in
prosa e' un punto d'uso quanto uno nel codice, e va cercato con `grep`
sul NUMERO in TUTTA la pagina, non per intuito su un solo punto.

### Controlli eseguiti
1. **Parse pwsh reale** (pwsh 7.4.6 disponibile nell'ambiente) del driver
   intero e dei 5 blocchi estratti dalla pagina: **tutti PASS**, zero errori.
2. **Zero caratteri non-ASCII** nel driver `.ps1`.
3. **Marcatore**: `_v4` in tutti i 7 punti d'uso della pagina (definizione +
   tabella "Driver" + verifica al pin + 5 `Select-String` dei blocchi);
   nessun residuo `_v3`.
4. **Guardia MT5/MetaEditor**: presente nel driver e in tutti e 5 i blocchi
   (invariata, non toccata).
5. **Cultura invariante**: nessuna `Parse`/`ToString` nuova senza `$INV`; i
   campi aggiunti usano le funzioni esistenti `Num`/`FmtN` (gia' invarianti).
6. **Classe 112** (ogni input del prova esiste nell'EA, nei due versi):
   logica di `GateProva` non toccata, input EA invariati a 22 -> gate ancora
   corretto senza modifiche.
7. **Tetto ~100.000 barre**: `$TETTO_GIORNI` invariato, non toccato da
   questo giro (indipendente dalla versione dell'EA).
8. **Classi 108/110/116**: non toccate, ri-lette per intero, ancora corrette.

### Doppia ri-pinnatura (il marcatore cambia l'hash)
Prima commit `5c21eca3` (gate v1.02), poi accorto che il marcatore andava
alzato di conseguenza (classe 109-bis) -> secondo commit `01743b7e` (bump
`_v3` -> `_v4`). Il pin finale scritto in pagina e' **`01743b7e`** (contiene
entrambi i commit); l'hash intermedio `5c21eca3` non e' mai stato un pin
vissuto, resta solo citato in prosa per la cronologia del giro.

### Ri-pin della pagina (commit `01743b7ec58ae8376d095b1678a7d2fcd891cd97`)
Pin precedente `526f76f6...` -> nuovo `01743b7e...`. Verificato via `raw`
che al pin driver + generico + i 4 prova + `.mq5` sono **identici a HEAD**
(sha256 confrontati uno per uno, tutti IDENTICO). Al pin: marcatore `_v4`
presente nel driver scaricato, `#property version "1.02"` e
`#define REL_NSTATS 95` confermati nell'.mq5 scaricato. Nessun residuo del
pin vecchio come punto d'uso (le menzioni di `526f76f6` restano solo nella
prosa storica, non riscritta per convenzione).

## Verdetto (parte 2)
**PASS.** Driver e pagina ri-pinnati e allineati alla v1.02 dell'EA;
aggiunta la stampa delle due colonne diagnostiche nuove nella riga di
riferimento del referto; corretti DUE residui v1.00 non pescati nel giro
precedente (righe 97 e 307 della pagina, sezioni diverse).

**NON COPERTO:** compilazione reale con MetaEditor e corsa MT5 vera (fuori
dal perimetro eseguibile in questo ambiente: serve il PC di backtest
Windows). Non e' stato aggiunto un collaudo per-riga sull'IDENTITA' di
`Giorni Festa Metro`/`Giorni Metro Zero Calendario` fra le 49 celle della
stessa corsa (dovrebbero essere tutte uguali, essendo un fatto di
calendario indipendente da N/sigma): se Claudio lo vuole, e' un giro
successivo, dichiarato qui e non fatto in silenzio.

---

## SEGUITO (03/09 notte): driver ri-pinnato sulla v1.03, verificato dall'agente VERIFICATORE

**Motivo:** `mql5/Experts/ABTG_SondaRelativo.mq5` e' passato a **v1.03**
(commit `e0026b6` + `01cbfc3`): trovata la causa ESATTA del collaudo T12
rotto (`Sotto 60 Secondi Pct` non a 0,00 su gran parte delle celle). Il
gate T7 sull'ingresso confrontava la barra TEORICA (`tSeg + gTfSec`) con
quella REALE (`iTime` 0) solo in un punto: nei buchi di storico la posizione
nasceva su una barra fuori sessione e la valutazione successiva la
richiudeva con lo STESSO timestamp (`sec=0`, 0 barre). Fix: nuove funzioni
pure `IngressoInFinestra_Calc` (gate sulla barra REALE) e
`TenutaSecondi_Calc` (la tenuta in secondi ora si DERIVA dalle barre
valutate, non dai due timestamp grezzi). Il driver
`backtest_pipeline/righe/RIGA_SONDARELATIVO.ps1` (pin precedente, commit
`01743b7e`, marcatore `_v4`) aveva i gate ancora ancorati ai numeri v1.02:
sarebbe partito e si sarebbe fermato al passo 2 con `#property version e'
'1.03', attesa '1.02'`.

**Letto `mql5/Experts/ABTG_SondaRelativo.mq5` per intero** (non fidandosi
solo del commit message): `#property version "1.03"` (riga 309),
`grep -cP '^\s*blocchi\+\+\s*;'` = **25** (blocco 24
`IngressoInFinestra_Calc`, blocco 25 `TenutaSecondi_Calc`), `#define
REL_NSTATS 97` (riga 498) -> **100 colonne** (97 + Pass/Simbolo/Periodo),
confermato leggendo la head CSV per intero (righe 3084-3123 di
`OnTesterDeinit`): le ultime due voci sono `Ingressi Barra Reale Fuori`
(`stats[95]`) e `Chiuse Zero Barre` (`stats[96]`), e `ControllaColonne`
verifica a runtime che `nomi = REL_NSTATS + 3 = 100`. Input EA invariati:
**22** (`grep -cP '^\s*input\s+[A-Za-z_]\w*\s+[A-Za-z_]\w*\s*='`) — nessun
input nuovo, solo colonne di sola lettura.

### Corretto nel driver (`backtest_pipeline/righe/RIGA_SONDARELATIVO.ps1`, commit `b3acff1`)
| dove | prima | dopo |
|---|---|---|
| riga 2 (marcatore) | `_v4` | `_v5` (contenuto cambiato = versione alzata, classe 109-bis) |
| righe 85-86 (commento header) | `"1.02"`, `23 blocchi`, `REL_NSTATS 95 (= 98 colonne)` | `"1.03"`, `25 blocchi`, `REL_NSTATS 97 (= 100 colonne)` |
| riga 165 | `$VERSIONE_ATTESA = "1.02"` | `"1.03"` |
| riga 166 | `$AUTOTEST_BLOCCHI_ATTESI = 23` | `25` |
| riga 167 | `$NSTATS_ATTESI = 95` (commento "98 colonne") | `97` (commento "100 colonne") |
| riga 732 | `"REL_NSTATS = ... (98 colonne)"` | `"... (100 colonne)"` |
| riga 1036 | `"colonne: ... (attese 98)"` | `"... (attese 100)"` |
| riga 1116 | `"...98 colonne OPTFRAME."` | `"...100 colonne OPTFRAME."` |
| riga 1147 | `"...98 colonne + gli input..."` | `"...100 colonne + gli input..."` |
| `$servono` (lista colonne pretese per nome) | non chiedeva le due colonne nuove | aggiunte `"Ingressi Barra Reale Fuori","Chiuse Zero Barre"` |
| lettura riga CSV (`$r` per-cella) | non leggeva le due colonne nuove | aggiunti i campi `IngrFuori`/`ChiuseZero` |
| collaudi per riga | nessun controllo sulle colonne T12 nuove | PROBLEMA se `Chiuse Zero Barre` != 0 (dalla v1.03 e' lo STESSO EVENTO di `Sotto 60 Secondi Pct`, qui in conteggio secco) |
| dopo il ciclo delle 49 celle | nessuna diagnostica sul fix | RILIEVO aggregato: somma di `Ingressi Barra Reale Fuori` sulle 49 celle -> "MISURATO" se >0 (il fix ha morso, e' falsificabile e regge), "NON MISURATO" se 0 (non e' un fallimento: nessun buco di storico incontrato in questa finestra/simbolo) |
| referto (riga di riferimento) | non stampava le due colonne | nuova riga "FIX T12 (v1.03): Chiuse Zero Barre ... / Ingressi Barra Reale Fuori ..." |

Le due colonne diagnostiche **non** sono state aggiunte alla tabella delle
49 celle (stesso ragionamento gia' scritto per `Giorni Festa Metro`/`Giorni
Metro Zero Calendario` nella sezione precedente: format string a colonne
fisse, rischio di sfasamento silenzioso se allargata): sono lette per NOME
e riportate in aggregato/riferimento, non per-cella nella tabella.

### Controlli eseguiti a macchina (pwsh disponibile nell'ambiente)
1. **Parse pwsh reale** del driver intero e dei 5 blocchi estratti dalla
   pagina: **tutti PASS**, zero errori.
2. **Classe 79/79-bis** (collisione `$r`/`$R`): parser AST rieseguito dopo
   le modifiche. Nessun `foreach($r ...)` a livello di script DOPO la
   creazione di `$R` (riga 1019); i gruppi `ha`/`mappa`/`r` restanti sono
   variabili locali di funzioni diverse (stesso esito gia' documentato
   sopra per il pin precedente), confermato di nuovo dopo l'edit.
3. **Banco eseguito con lo stato PIENO** (classe 79-bis, non solo le
   funzioni): estratte le definizioni del driver via AST
   (`ParamBlock.Extent`) ed eseguito `AnalizzaCsv` su un CSV OPTFRAME
   sintetico da 100 colonne (header reale del `.mq5`, 49 righe, valori che
   passano tutti i collaudi):
   - CSV sano, `Ingressi Barra Reale Fuori` > 0 su una cella -> **0
     PROBLEMI**, RILIEVO "FIX T12 (v1.03) MISURATO: ... = 3".
   - stesso CSV con `Ingressi Barra Reale Fuori` = 0 ovunque -> **0
     PROBLEMI**, RILIEVO "FIX T12 (v1.03) NON MISURATO IN QUESTA CORSA" (non
     e' un fallimento, e' dichiarato).
   - una cella con `Chiuse Zero Barre` = 1 -> **1 PROBLEMA** corretto
     ("Chiuse Zero Barre = 1 ... contabilita' dei tempi rotta"),
     `VerdettoL`/`VerdettoS` = `NON LEGGIBILE` (clausola severa rispettata).
   - CSV "vecchio" (v1.02, senza le due colonne nuove) -> **1 PROBLEMA**
     corretto ("mancano le colonne: Ingressi Barra Reale Fuori, Chiuse Zero
     Barre"), nessun crash, nessuna lettura silenziosa sbagliata.
4. **Gate di IDENTITA' DEL SORGENTE rieseguiti contro il `.mq5` vero**
   (stesso codice del driver, non una copia): versione, blocchi, NSTATS,
   input, grep contatore puro, `#include`, e le soglie `#define`
   (`REL_C1_...`, `REL_C3_...`, `REL_C5_...`, `REL_C6_...`, `REL_C7_...`,
   `REL_C8_...`, `REL_SPREAD_...`) confrontate con i numeri della pagina:
   **tutti combaciano** (C1=2,00 · C5=0,70 · C6=25/40 · C8=12/25 · C2=10 ·
   C7=0,65/3,25 · C3 multipli 3/6 · spread 2,80/1,80).
5. **`GateProva`/`GateGemelli` rieseguiti contro i quattro `prove/RELATIVO_*.txt`
   reali del repo** (invariati, hash confermati uguali al pin precedente):
   **tutti e quattro PASS**, 49 celle ciascuno, gemellaggio VALIDO.
6. **Zero caratteri non-ASCII** nel driver `.ps1`.
7. **Marcatore**: `_v5` in tutti i 7 punti d'uso della pagina (definizione +
   tabella "Driver" + verifica al pin + 5 `Select-String` dei blocchi);
   nessun residuo `_v4`.
8. **Guardia MT5/MetaEditor**, **cultura invariante**, **tetto ~100.000
   barre**, **classi 108/110/116**: non toccate da questo giro, ri-lette
   per intero, ancora corrette.

### Ri-pin della pagina (commit `b3acff11221e2cb9fed0a48899b23e6c94cbf5a0`)
Pin precedente `01743b7e...` -> nuovo `b3acff1...`. Verificato via `raw`
che al pin driver + `walkforward_generico.ps1` + i 4 prove + `.mq5` sono
**identici a HEAD** (sha256 confrontati uno per uno, tutti IDENTICO, HTTP
200). Al pin: marcatore `_v5` presente nel driver scaricato, `#property
version "1.03"` e `#define REL_NSTATS 97` confermati nell'.mq5 scaricato.
Nessun residuo del pin vecchio come stringa completa nella pagina (le
menzioni di `01743b7e`/`526f76f6` restano solo nella prosa storica, non
riscritta per convenzione, come gia' fatto per i pin precedenti).

## Verdetto (parte 3)
**PASS.** Driver e pagina ri-pinnati e allineati alla v1.03 dell'EA (fix
T12 sulla barra reale); lette e stampate le due colonne diagnostiche nuove
(un collaudo per riga + un rilievo aggregato); verificato a macchina con un
banco che esegue la RACCOLTA a stato pieno (classe 79-bis), non solo le
funzioni pure, coprendo sia il ramo sano sia i due rami di rifiuto (T12
rotto, CSV vecchio senza le colonne).

**NON COPERTO:** compilazione reale con MetaEditor e corsa MT5 vera (fuori
dal perimetro eseguibile in questo ambiente: serve il PC di backtest
Windows). Non e' stato verificato a macchina il comportamento del gate
`if($src -notmatch '\[AUTOTEST\]\s+21\s')` su un sorgente mutato (classe
116-ter): resta un controllo di presenza letterale del blocco 21, invariato
da prima di questo giro e non toccato ora. Non e' stato eseguito un vero
walk-forward MT5 con lo storico reale: il banco sintetico dimostra che il
driver LEGGE correttamente le due colonne nuove e reagisce nei tre rami
attesi, non che la CORSA reale produca `Ingressi Barra Reale Fuori` > 0 su
D30EUR/NASUSD -- quello lo dira' la prima corsa vera al nuovo pin.
