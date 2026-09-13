# 🌙 LA NOTTE IN CUI I CSV SONO ARRIVATI — R136 (EMA200 Dow) e R137 (DAX), piu' il censimento delle altre 24 coppie

**Scritto il 13/09/2026, ore 21:1x UTC (23:1x ora VPS), dalla sveglia automatica del weekend.**
Materiale: i **98 CSV** pubblicati dal VPS fra le **23:05 e le 23:07** ora locale VPS.

---

## 0. 🚨 PRIMA DI TUTTO: CHE COSA E' SUCCESSO, E CHE COSA **NON** HO VERIFICATO

Stamattina la classe **307** (`CHECKLIST_RIGA_DI_LANCIO.md` r.17815) diceva, misurato:
> *"la coda delle 03:30 e' girata, 36 round eseguiti... ma nessun CSV di risultato e'
> arrivato nel repo. `runner_abtg.ps1` (`PubblicaFile`) carica solo `REFERTO_RUNNER_*.txt`
> e i `*.log` — mai i CSV."*

**Stasera i CSV ci sono.** 98 file, entrati nel repo oggi (verificato con
`git log --diff-filter=A` su tutti e 98: **98 su 98 datati 2026-09-13**).

🟢 **E IL MECCANISMO SI SA, senza lanciare niente — sono tre letture.**
*(La prima stesura di questo paragrafo diceva "non lo so". Era un'ignoranza **finta**: la
risposta stava gia' nel repo, nei file che non avevo aperto. E' lo stesso difetto del
10/09 — la formula "verificata" mentre i numeri veri erano in un file nella stessa
cartella.)*
1. **`runner_abtg.ps1` a HEAD (r.828-833)** chiama `PubblicaFile` **solo** su `$ref`
   (`REFERTO_RUNNER_*.txt`) e sui `*.log`, verso `backtest_pipeline/coda/referti/`:
   **zero CSV, e mai il percorso `risultati_prove/dal_vps/`. Il runner NON e' stato toppato.**
2. I 98 file sono entrati con **98 commit distinti, UN file ciascuno**, messaggio
   `"Risultati dal VPS: <file> (timestamp)"` — stringa che **nel repo non esiste**
   (`grep` su `.ps1`/`.py` → **0**), verso un percorso che **nessuno script committato
   scrive** (`grep -rln "dal_vps" --include=*.ps1` → **0**).
3. La **classe 311** (`CHECKLIST_RIGA_DI_LANCIO.md` r.18030, scritta oggi stesso) descrive
   per nome lo strumento: un **import di massa** dei CSV gia' girati sul VPS
   (`%USERPROFILE%\abtg_round\risultati_prove\`), *"mai pubblicati dal runner (classe
   307)"*.

🔴 **Quindi la risposta e' NO: da stanotte i numeri NON arrivano da soli.** Il runner non
pubblica CSV, e lo strumento che li ha portati **non e' versionato**.
👉 **Cosa resta da FARE, non da sapere**: committare quello script, oppure toppare
`PubblicaFile`. E attenzione alla classe 311 stessa: `PubblicaFile` legge lo `sha`
esistente e, se c'e', **aggiorna invece di creare** — un omonimo si sovrascrive in
silenzio. (Qui il sottoalbero `dal_vps/` e' separato, quindi non e' successo; ma va
verificato con un `git log` per percorso su tutto `risultati_prove/` — **non l'ho fatto**.)

### 0-bis. I 98 file non sono 98 misure
Confronto md5 di tutti i CSV di `risultati_prove/` (1.537 file):
- **28 su 98 sono byte-identici** a file gia' presenti nel repo altrove
  (`ABTG_OpeningReversalB/`, `ibretest_p0/`, `ABTG_IBRetest/`, `ABTG_LVNArbitro/`,
  `r123/`, `r123_dal_vps/`, `ABTG_Nightly/`). Ricarica, non misura nuova.
- **70 su 98 hanno contenuto mai visto** = **35 coppie IS/OOS complete**.
- Di queste 35, i round con un referto gia' scritto nel repo: **ZERO**
  (`find -name 'REFERTO_ROUND*'` incrociato con le 35 etichette).

---

## 1. ✅ LE SENTINELLE DI RIPRODUZIONE: **14 su 14**, alla quinta cifra

Questo e' il risultato che viene prima di tutti gli altri, perche' se cadeva lui non si
poteva leggere nient'altro.

### S1 del gruppo r136 (bloccante per tutti e quattro, `R136a...txt` par. S1)
Atteso, da R112 (tick, dep. 100.000, rischio 1,0%, stessa finestra):
`IS n 237 | PF 1,20110 | DD 5,7325%` · `OOS n 517 | PF 1,52365 | DD 7,8323%`

| corsa | cella pinnata | IS | OOS |
|---|---|---|---|
| `r136a` | `InpSLatr=1.0` | 237 / 1,20110 / 5,7325 ✅ | 517 / 1,52365 / 7,8323 ✅ |
| `r136b` | `InpTP1_ATRmult=0.0` | ✅ idem | ✅ idem |
| `r136c` | `InpTP1Pct=50` | ✅ idem | ✅ idem |
| `r136d` | `InpUseTrailing=1` | ✅ idem | ✅ idem |
| `cemad05` | `InpTF=16385` | ✅ idem | ✅ idem |

**Dieci riproduzioni indipendenti su dieci**, in cinque corse separate, alla quinta
cifra decimale. Il banco riproduce.

### 🎯 E `cemad02`, che al primo giro avevo archiviato come ROTTO — ed e' un SUCCESSO
*(Corretto dopo un rilievo di un'altra sessione, verificato da me alla fonte.)*
Il referto del runner segna `cemad02` con **uscita 2 = NON MISURATO (CSV vuoto)**, e io
avevo copiato quel codice come se fosse un verdetto. **Falso.** Il file prova
`COLLAUDO_EMADOW_02_pertrade_IS.txt` porta **`@FRAZIONEIS 0.002`** (r.211): la finestra IS
e' **un giorno solo, buttata apposta**. L'IS vuoto e' **il progetto del round**, non un
guasto — e l'OOS riproduce **l'IS di R112 al centesimo**:
**237 deal · PF 1,20110 · DD 5,7325% · +4.585,40**. ✅ **Round riuscito.**
🔑 Il sentinella del driver (`$mancanti`/`$zero`) **non legge `@FRAZIONEIS`**, quindi non
sa distinguere *"vuoto perche' rotto"* da *"vuoto perche' voluto"* (classe **312**).

### S1 del gruppo r137 (`R137c`, la cella viva della 770101)
Atteso da R47a: `IS 175 / 1,12634 / 5,4362` · `OOS 270 / 1,39709 / 7,2328`
→ misurato in `r137c` cella `InpTP1_ClosePct=50`: **175 / 1,12634 / 5,4362** e
**270 / 1,39709 / 7,2328**. ✅ **PASS.**

### 🎁 E la riproduzione gratis che il file prova aveva chiesto PRIMA
`R137a...txt` r.~108: *"270 − Trades(800) = QUANTE GAMBE AVEVANO UNO STOP GEOMETRICO
SOTTO 8 IDX. Se il numero e' 0, la manopola e' inerte a 800 e quella cella riproduce
R47a — ed e' una seconda riproduzione gratis. Se e' > 0... e' una notizia sul rischio
della sedia viva che va in cima al referto."*

**Misurato: 270 − 270 = ZERO.** Cella `MinStopPts=800` → `n 270 / PF 1,39709 /
DD 7,2328%`, identica a R47a. Il floor a 800 e' **inerte, MISURATO**: nessuna gamba
di questa sedia ha mai avuto uno stop geometrico sotto 8 idx.
👉 **Niente notizia sul rischio.** La domanda era giusta, la risposta e' tranquilla.

🟢 **E IL COLLAUDO DELLA PATCH DELL'11/09 SI PUO' DICHIARARE — la catena c'e', ed e' tutta
in repo.** *(Anche qui la prima stesura si era fermata a "non so quale binario sia stato
compilato". Il log per-round **e' davvero** sovrascritto — classe 307 verificata, il
superstite parla di `ABTG_Nasdaq_Live5m` — ma la risposta si ricava da tre fatti
versionati, e buttava via un risultato.)*
1. **`RIGA_SOTTILE_ROUND.ps1` r.54-60**: *"il driver scarica l'EA `.mq5` e gli include
   **NON dal pin, ma dalla TESTA del branch `lavoro`**… il codice MQL5 che viene compilato
   e' quello di `lavoro` al momento della corsa"*.
2. **`git log -- mql5/Experts/ABTG_EMA200.mq5`**: l'ultimo commit e' **b45dd009, 11/09
   09:12** — la patch dell'imbuto — **e non c'e' niente dopo**. Alle 03:30 del 13/09 la
   testa **era necessariamente quella**: 690 righe, e `git diff b45dd009 HEAD` sul file e'
   **vuoto**.
3. **La toppa della classe 270** (dichiarata in `RIGA_SOTTILE_ROUND.ps1` r.217-229) fa
   **cancellare l'`.ex5` prima di compilare**, quindi un binario stantio non puo' piu'
   passare per compilato. E `REFERTO_RUNNER_20260913_033003.txt` segna i cinque round
   `ABTG_EMA200` a **uscita 0**.

👉 **Quindi: S1 riprodotta DIECI VOLTE SU DIECI sul binario POST-PATCH ⇒ la patch
diagnostica dell'11/09 e' NEUTRA SUL TRADING sulla sedia migliore della flotta.**
E' il risultato che `R136a` sperava e che *"oggi non ha nessuno"*.

⚖️ **Il residuo, dichiarato**: manca la **stampa del compilatore** per quei round. La
catena e' `git` + comportamento dichiarato del driver — **un'inferenza forte, non una riga
di log**. Se qualcuno recupera `Desktop\ROUND_r136a.zip` dal VPS, diventa un fatto stampato.

---

## 2. 🏆 R136 — LA GESTIONE DELL'USCITA DELLA SEDIA MIGLIORE DELLA FLOTTA (`ABTG_EMA200` U30USD H1, magic vivo 771531)

Criteri **congelati prima dei numeri** in `backtest_pipeline/prove/R136a_slatr_U30USD.txt`:
A1 altopiano = **≥3 celle contigue** con, ciascuna, `PF OOS ≥ 1,40` **E** `posizioni OOS ≥ 150`
**E** `DD OOS ≤ 8,5%` **E** costo `≥ 40x` all'angolo pessimista, **e la cella viva dentro**.
A8: si porta avanti il **CENTRO**, mai il picco. A9: un vantaggio di PF `< 0,10` su una
sola cella **non e' un vantaggio**. A10: **il round non promuove niente.**
Posizioni = `Trades / 2,0117` (fattore misurato su questa sedia, classe 226).

### 2.1 `r136a` — asse `InpSLatr` (la larghezza dello stop): **A1 PASSA, e il default resta**

| SLatr | PF IS | DD IS | PF OOS | n OOS | pos OOS | DD OOS | costo (angolo pess.) | A1 |
|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0,4 | 1,073 | 5,54 | 1,264 | 473 | 235,1 | 9,96 | 21,9x | ❌ PF, DD, COSTO |
| 0,6 | 1,145 | 5,51 | 1,521 | 494 | 245,6 | 7,15 | 32,9x | ❌ **solo per COSTO** |
| 0,8 | 1,189 | 5,13 | **1,612** | 506 | 251,5 | 8,19 | 43,9x | ✅ |
| **1,0 (viva)** | 1,201 | 5,73 | **1,524** | 517 | 257,0 | 7,83 | 54,9x | ✅ |
| 1,2 | 1,255 | 4,73 | 1,462 | 519 | 258,0 | 5,97 | 62,2x | ✅ |
| 1,4 | 1,218 | 4,27 | **1,595** | 529 | 263,0 | 5,77 | 69,5x | ✅ |
| 1,6 | 1,072 | 4,76 | 1,458 | 527 | 262,0 | 6,25 | 76,8x | ✅ |

- **A1: PASSA.** Cinque celle contigue (0,8 → 1,6), cella viva **dentro**.
- **A3 anti-clone**: nessuna coppia contigua con `n` e PF identici. Altopiano vero.
- **A4 PICCO: NON scatta.** La viva fa 1,524 ≥ 1,40 ma le due vicine fanno 1,612 e 1,462,
  **entrambe ≥ 1,25**. Nessun picco: l'asse e' un altopiano.
- **A8 — il centro.** L'altopiano A1 (0,8…1,6, cinque celle) ha centro **1,2**,
  PF OOS 1,462 = **−0,062** contro la viva: il centro **non** batte il default.
  *(Seconda lettura, portata solo per trasparenza e **NON prevista dai criteri congelati**
  — A1 include il costo per definizione, un "altopiano di solo merito" nei criteri non
  esiste: con 0,6…1,6, sei celle, il centro sarebbe la coppia 1,0/1,2, cioe' la cella
  viva dentro il centro. Stesso esito, ma non e' una lettura a norma.)*
- **A6/A9 → VERDETTO: 🟢 «IL DEFAULT VA BENE».** Nessuna cella batte `1,52365` di ≥ 0,10.
  Il massimo dell'asse (0,8 → 1,612) vale **+0,088**: **sotto la banda di rumore dichiarata
  prima**, e per A8 non si sceglie comunque il picco.
- 📌 **La previsione scomoda scritta PRIMA della corsa era questa, ed e' CENTRATA**:
  *"MI ASPETTO CHE IL DEFAULT VINCA, o che ci vada cosi' vicino da non distinguersi."*

🔴 **E QUI C'E' UN'ATTESA SMENTITA, che vale piu' del verdetto.**
Il file prova prevedeva `n OOS` **in calo monotono** al crescere di `SLatr`
(*"560-620 a 0,4 ; 517 a 1,0 ; 400-480 a 1,6"*), per un motivo meccanico dichiarato
(una posizione alla volta, stop largo = posizione piu' lunga = piu' candidate scartate).
**Misurato: 473 → 494 → 506 → 517 → 519 → 529 → 527. SALE, non scende**, e i due
estremi cadono **fuori dalla banda stimata da tutte e due le parti**.
👉 Conseguenza pratica: **il contro-esempio B4(i)** (*"stop largo = sottoinsieme di
operazioni piu' lunghe favorite dal toro"*) **non e' lo spiegone di questo asse**,
perche' il campione non si assottiglia affatto. Il modello meccanico scritto nel file
prova e' sbagliato su questo motore, e va corretto prima di riusarlo.

### 2.2 `r136b` — asse `InpTP1_ATRmult` (dove sta il primo bersaglio)

| TP1_ATRmult | PF IS | DD IS | PF OOS | n OOS | pos OOS | DD OOS | A1 |
|---:|---:|---:|---:|---:|---:|---:|---|
| **0,00 (viva)** | 1,201 | 5,73 | 1,524 | 517 | 257,0 | 7,83 | ✅ |
| 0,25 | 0,994 | 3,08 | **1,590** | 495 | 246,1 | **2,10** | ✅ |
| 0,50 | 1,014 | 3,14 | 1,409 | 453 | 225,2 | 3,21 | ✅ |
| 0,75 | 0,900 | 4,91 | 1,436 | 422 | 209,8 | 7,52 | ✅ |
| 1,00 | 0,869 | 5,99 | 1,549 | 379 | 188,4 | 8,63 | ❌ DD |
| 1,25 | 0,837 | 7,14 | 1,540 | 363 | 180,4 | 9,46 | ❌ DD |
| 1,50 | 0,762 | 8,90 | 1,587 | 336 | 167,0 | 9,87 | ❌ DD (e DD IS) |

- **A1 [R136a] + A1-bis [R136b] — PASSA, e la terna e' `0,25-0,50-0,75`.** `A1-bis`
  (r.165-169 del file prova) **esclude la cella viva (0,00) dalla terna**: *"non e' un
  punto della stessa scala"*. Le tre passano tutte (PF 1,590 / 1,409 / 1,436 · pos
  246,1 / 225,2 / 209,8 · DD OOS 2,10 / 3,21 / 7,52 · DD IS 3,08 / 3,14 / 4,91 · costo
  54,9x per **A1-ter**, invariato su questo asse). La 1,00 cade su **A7** (DD OOS 8,63).
- **A8 — IL CENTRO, ed e' il numero che conta**: centro della terna = **0,50**,
  PF OOS **1,40862** contro **1,52365** della viva = **−0,115**.
  **Il centro dell'altopiano PEGGIORA il valore in essere.**
- **A6 → «IL DEFAULT VA BENE»**, e per la ragione forte: non *"il rivale non stacca
  abbastanza"*, ma **il centro dell'altopiano e' peggiore della cella viva**.
  (Il `+0,066` della 0,25 resta sotto A9, ma per A8 il picco non si sceglie comunque:
  in R70 i confronti fatti col picco si sono ribaltati.)
- 🟡 **MA SUL RISCHIO la cella 0,25 dice una cosa che va scritta**, perche' il requisito
  rotto di questa sedia e' **proprio R2, il DD**: `DD OOS 2,10%` contro `7,83%` e
  `DD IS 3,08%` contro `5,73%`, **a PF piu' alto** (1,590) e con 246 posizioni.
  Per l'Emendamento B il rischio si giudica **a qualunque n**, e questo e' un fatto
  accaduto, non una stima.
  🔴 **Non e' una promozione** (A10: il round non promuove niente; e taglie/preset sono
  [FIRMA DI CLAUDIO]). E' **un candidato per un round suo**, con due controindicazioni
  gia' visibili: il **segno dell'IS peggiora** (0,994 contro 1,201, cioe' l'IS va
  sotto la pari) e il guadagno sta **solo** in OOS — che e' esattamente la firma
  «regime, non geometria» del contro-esempio B4 punto 2.

⚠️ **UN CAVEAT DI UNITA' CHE MI SONO DOVUTO CORREGGERE DA SOLO.** Il fattore 2,0117
(uscite→posizioni) e' stato misurato **alla cella viva**, dove il parziale e' attivo.
Sugli assi che **muovono il parziale** (`r136b`, `r136c`) quel fattore **non e' lo stesso
in tutte le celle**, e la colonna "pos" e' quindi una **DERIVAZIONE**, non una misura.
Ho verificato che il verdetto non ci si appoggia: su `r136a` (parziale pinnato in tutte
le celle) la cella con meno uscite ha 473 deal, che resterebbero ≥ 150 posizioni anche
con un fattore fino a **3,15**; su `r136b` la cella piu' esposta (0,75, 422 deal) resta
sopra 150 fino a un fattore di **2,81**. **Nessuna cella cambia lato per questo.**

### 2.3 `r136c` — asse `InpTP1Pct` (quanto si chiude al primo bersaglio)

| TP1Pct | PF IS | DD IS | PF OOS | n OOS | DD OOS |
|---:|---:|---:|---:|---:|---:|
| 0 (parziale spento) | 0,935 | 7,25 | 1,281 | 165 | **13,94** 🔴 |
| 25 | 1,200 | 5,74 | 1,518 | 602 | 7,87 |
| **50 (viva)** | 1,201 | 5,73 | 1,524 | 517 | 7,83 |
| 75 | 1,200 | 5,73 | 1,526 | 471 | 7,82 |

- **A1 [R136a] + A1-bis [R136c] — PASSA** sull'unica terna contigua possibile, **25-50-75**,
  con posizioni (**A2-bis**: fattore 2,0117) **299,2 / 257,0 / 234,1**, tutte sopra 150.
  La cella 0 resta **fuori dall'altopiano per costruzione** (`A1-bis`: meccanismo diverso,
  tre uscite spente; fattore **1,000**, quindi 165 uscite = **165 posizioni**, non 82).
- **A8 — IL CENTRO DELL'ALTOPIANO E' LA 50, CIOE' LA CELLA VIVA.** Per A8 *"la cella viva
  e' confermata e non si tocca niente"*. 🟢 **E' la conferma piu' forte che questa notte
  produce sulla sedia di punta**, ed e' una conferma **a norma di regola di selezione**,
  non un'impressione. Il file prova l'aveva previsto testualmente (r.163-164):
  *"Se l'altopiano e' quello E il suo centro e' la 50, la risposta e' «IL DEFAULT VA BENE»
  — ed e' un risultato pieno, non un fallimento."*
- **La TAGLIA del parziale e' inerte sul PF fra 25 e 75**: 1,51843 / 1,52365 / 1,52560,
  cioe' **7 millesimi** di escursione. (Non e' un clone A3: `n` cambia di 131 deal.)
- **L'ESISTENZA del parziale invece morde, e morde sul RISCHIO**: spegnerlo porta il
  `DD OOS` da 7,8% a **13,94%** — oltre il muro prop del 10%. **Cella di rischio, A7.**
- 🟢 **VERDETTO: il parziale si tiene acceso; la sua taglia e' una manopola MISURATA e
  INERTE; e la taglia viva sta al CENTRO del suo altopiano.**

### 2.3-bis 🧪 IL CONTROLLO DEL TERZETTO (R136d punto 5) — fatto, e la condizione SCATTA

`R136d_trailing_U30USD.txt` lo chiama *"il controllo piu' potente che questa notte
produce"*: *"l'effetto misurato qui deve stare DENTRO l'effetto totale misurato da R136c.
Se l'effetto del solo trailing fosse PIU' GRANDE dell'effetto di tutti e tre i meccanismi
insieme, uno dei due round sta misurando qualcos'altro, **e va capito PRIMA di scrivere un
verdetto**."*

| | Δ PF OOS | Δ P/L | Δ DD | n |
|---|---:|---:|---:|---:|
| **solo trailing OFF** (`r136d` cella 0) | **+0,24715** | +4.928,47 | −0,42 pt | 517→427 |
| **tutti e tre OFF** (`r136c` cella 0) | **−0,24221** | −8.102,60 | **+6,10 pt** | 517→165 |

Magnitudine quasi identica, **segno opposto**: la condizione **scatta**.
🟢 **La spiegazione, e va scritta perche' e' la ragione per cui il controllo non annulla i
due round**: le due celle **non misurano la stessa quantita'**. La cella 0 di `r136c`
**toglie anche l'uscita parziale**, quindi cambia l'unita' di conto (fattore **1,000**
invece di 2,0117: 165 uscite = 165 posizioni contro 257) e il campione (**−68%**), e porta
il DD a 13,94%. I tre meccanismi **non sono additivi**, e il "terzetto" non si legge come
una somma.
🔴 **Conseguenza sui verdetti**: l'effetto attribuito al **solo trailing** in `r136d`
resta **NON ATTRIBUITO** finche' non esiste una cella che spenga il trailing **lasciando
acceso il parziale, su un asse a piu' di due celle**. Si legge il TERZETTO, non il singolo
(buco gia' dichiarato in `R136b`: parziale, pari e trailing sono agganciati a `beDone`).

### 2.4 `r136d` — asse `InpUseTrailing`: **il numero piu' interessante della notte**

| UseTrailing | PF IS | DD IS | PF OOS | n OOS | pos OOS | DD OOS | P/L OOS |
|---:|---:|---:|---:|---:|---:|---:|---:|
| **1 (viva)** | 1,201 | 5,73 | 1,524 | 517 | 257,0 | 7,83 | +23.321,47 |
| 0 | 1,107 | 5,50 | **1,771** | 427 | 212,3 | **7,42** | **+28.249,94** |

- Spegnere il trailing: **PF OOS +0,247** (sopra la banda di rumore A9), **DD OOS piu' basso**,
  **+4.928,47 di profitto**, 212 posizioni.
- 🔴 **E NON SI PROMUOVE, per una ragione strutturale scritta NEL FILE, non per prudenza
  mia**: `A1-bis [R136d]` ammette **solo tre verdetti** su un asse booleano — *"il default
  va bene"* · *"manopola inerte, MISURATA"* · *"c'e' un CANDIDATO a spegnere il trailing"*.
  Con due celle un altopiano **non puo' esistere per costruzione**.
- 🔴 **E IL PUNTO 1 DEL FILE DECIDE QUALE DEI TRE**: *"se il segno si inverte fra IS e OOS
  il verdetto e' «NON MISURABILE»"*. Ed e' il caso: **OOS +0,247, IS −0,094**.
  👉 **VERDETTO: «NON MISURABILE» — e la forma ammessa e' «c'e' un CANDIDATO a spegnere il
  trailing»**, che per diventare altro deve passare da una **finestra nuova** o da una
  **prova di regime**.
- ⚠️ **E il §2.3-bis toglie a questo numero anche l'attribuzione**: l'effetto non e'
  attribuibile al **solo** trailing finche' non esiste una cella che lo spenga lasciando
  acceso il parziale, su un asse a piu' di due celle.
- 👉 **La via corta al numero** (Motto, *"se potrebbe passare, si insiste"*): questo
  candidato non si archivia e non si promuove — **si porta a una finestra NUOVA o a una
  prova di REGIME**, che e' esattamente quello che A6 punto 5 prescrive. Costo:
  una corsa. **Proposta, non fatta.**

### 2.5 `cemad05` — asse `InpTF`: **H1 regge, ma l'altopiano e' DA UNA PARTE SOLA**

⚠️ **Attenzione all'errore che stavo per fare**: `cemad05` **non e' un round r136** e non
risponde ai criteri di `R136a`. Ha i suoi, congelati prima, in
`prove/COLLAUDO_EMADOW_05_tf_U30USD.txt` + `COLLAUDO_EMA200_DOW_CRITERI.md` (commit
`caaf5d1`), e la regola di selezione dichiarata li' e' **un'altra**:
> *"se H1 sta DENTRO un altopiano di TF vicini positivi, la sedia resta H1 e il requisito
> 5 si chiude. Se H1 fosse l'UNICO TF positivo, allora e' un PICCO, e un picco isolato su
> un asse mai provato e' il difetto che questo progetto chiama «verde per caso»."*

**G0-B** (la cella H1 deve riprodurre, o il round e' nullo): ✅ riprodotta.

| TF | PF IS | DD IS | PF OOS | n OOS | DD OOS | P/L OOS |
|---|---:|---:|---:|---:|---:|---:|
| M15 (15) | 0,771 | 27,77 | 0,954 | 2020 | 26,34 | −9.456 |
| M20 (20) | 1,117 | 9,13 | 0,833 | 1642 | 30,71 | −26.415 |
| M30 (30) | 1,034 | 10,92 | 0,907 | 1268 | 15,87 | −11.404 |
| **H1 (16385) — viva** | 1,201 | 5,73 | **1,524** | 517 | 7,83 | **+23.321** |
| H2 (16386) | 2,599 | 2,42 | 1,173 | 266 | 6,12 | +4.095 |
| H3 (16387) | 2,152 | 2,18 | 0,908 | 170 | 9,00 | −1.519 |
| H4 (16388) | 1,660 | 2,37 | 1,425 | 116 | 4,45 | +4.604 |

- 🔴 **IL PICCO NON SCATTA, MA L'ALTOPIANO NON C'E'.** H1 **non e' l'unico TF positivo**
  (positivi in OOS anche **H2 +4.095** e **H4 +4.604**), quindi il caso *"verde per caso"*
  descritto nel file **non si verifica**. Ma sopra H1 il segno **ALTERNA**
  (H2 **+**, **H3 −1.519**, H4 **+**): il tratto positivo contiguo e' lungo **due celle**,
  H1-H2, e poi si rompe — e i due vicini positivi hanno **266 e 116 deal**, sotto il
  pavimento del campione. Sotto H1 (M30, M20, M15) sono **tre TF su tre in perdita**, con
  `DD OOS` fra **15,9% e 30,7%** — celle di rischio a qualunque n (Emendamento B).
  👉 **Lettura onesta: H1 sta al BORDO di un tratto positivo di due celle, non al centro
  di un altopiano.**
- 🔴 **E LA REGOLA CONGELATA NON COPRE IL CASO MISURATO.** `COLLAUDO_EMADOW_05` prevede
  **due rami soli** — *"H1 dentro un altopiano"* oppure *"H1 unico positivo = picco"* — e
  il misurato **non cade in nessuno dei due**. **Il file va emendato prima di riusarlo**
  (stesso trattamento dato al modello meccanico sbagliato di `R136a`, §2.1).
  La **casella 5** del certificato si chiude comunque, ma **per la regola del 09/09**
  (*"il TF e' stato cambiato almeno una volta?"* → si', sette TF, uscita 0), **non** per
  la regola del file. La differenza va detta.
- **M15/M20**: il file prometteva di MISURARE il costo invece di assumerlo. Non serve
  arrivarci: **sono fuori prima, per merito e per rischio** (PF OOS 0,954 e 0,833, DD
  26,3% e 30,7%).
- **Regola TF di casa** (H4 accettato solo se batte H1 su profitto **E** PF OOS):
  H4 fa **+4.604 contro +23.321** e **1,425 contro 1,524** → **non batte H1 su nessuno
  dei due**. 🟢 **La sedia resta su H1, e non si tocca da questo file.**
- Attenzione alla trappola del PF alto: H2/H3 hanno **PF IS 2,60 e 2,15** e crollano in
  OOS (1,173 e 0,908). E' il campione che si assottiglia, non un edge.

### 2.6 🪦 CHE COSA CHIUDE, DAVVERO, IL GRUPPO r136
Il **certificato di morte** (regola 09/09) chiede cinque caselle. Per `ABTG_EMA200`
su U30USD, da stanotte:
- ✅ **casella 3 — «la GESTIONE dell'uscita e' stata messa ad asse?»**: **SI'**, e su
  **quattro** manopole indipendenti (stop, primo bersaglio, taglia del parziale, trailing).
  Era **VUOTA** fino a ieri: il censimento del 12/09 aveva misurato che su 213 CSV di
  questo EA erano stati messi ad asse **solo ingressi**.
- ✅ **casella 5 — «il TF e' stato cambiato?»**: **SI'**, sette TF (`cemad05`).
- ⬜ **casella 4 — simboli gemelli**: `ohlc_r139a/b` stanotte hanno misurato AUDJPY e
  GBPUSD **in OHLC** (screening, mai verdetti) — vedi §4. **Non chiusa a tick reali.**
- 📌 E resta il buco gia' dichiarato nei file prova, che **questa notte non tocca**:
  **prova di REGIME assente** (21 mesi di solo toro). Niente di quanto sopra e'
  promuovibile finche' quel buco c'e'.

---

## 3. 🇩🇪 R137 — IL DAX (`ABTG_DAX_Apertura_EU` D30EUR, sedia viva 770101): **QUANTO COSTA CHIUDERE R5**

Criteri congelati in `R137a_floorstop_allarga_770101_D30EUR.txt`: A1 = ≥3 celle contigue
con `PF OOS ≥ 1,40` **E** `posizioni ≥ 150` **E** `DD OOS ≤ 8,0%` **E** rapporto minimo
garantito `≥ 40x`. Posizioni = `Trades / 1,3990`.
**Congelato PRIMA**: le celle **800 / 2800 / 4800 sono ESCLUSE PER COSTO** qualunque
numero producano.

| floor (pt) | PF IS | n IS | PF OOS | n OOS | pos | DD OOS | P/L OOS | costo |
|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 800 | 1,126 | 175 | 1,39709 | 270 | 193,0 | 7,2328 | +18.029,58 | 🚫 fuori (4,7x) |
| 2800 | 1,162 | 175 | 1,39585 | 270 | 193,0 | 7,2296 | +17.966,45 | 🚫 fuori |
| 4800 | 1,317 | 178 | **1,49624** | 272 | 194,4 | 7,2465 | +20.680,57 | 🚫 fuori |
| 6800 | 1,233 | 178 | **1,42020** | 272 | 194,4 | 7,2469 | +16.195,06 | ✅ 40,0x (mediano) |
| 8800 | 1,038 | 178 | 1,38128 | 273 | 195,1 | 6,3222 | +13.027,96 | ✅ |
| 10800 | 0,966 | 178 | 1,28751 | 273 | 195,1 | 5,6879 | +8.944,77 | ✅ anche a p95 |
| 12800 | 0,846 | 178 | 1,28394 | 274 | 195,9 | 6,3422 | +7.807,31 | ✅ |

- **A1: NON PASSA.** Fra le celle **in costo** ne passa **UNA SOLA** (6800). Un altopiano
  chiede tre contigue: non c'e'.
- **Il picco dell'asse (4800, PF 1,49624) e' una cella FUORI COSTO**, dichiarata tale
  **prima** della corsa. Per la regola scritta nel file, il verdetto in quel caso e'
  *"vince una cella fuori costo"*, **non** *"abbiamo trovato una configurazione migliore"*.
  E' la trappola che il round aveva previsto, ed e' scattata puntuale.
- **A4 PICCO — valutato, e NON scatta**: l'unica cella in A1 e' la 6800, e le sue due
  vicine fanno **1,49624** e **1,38128**, **entrambe ≥ 1,30**. Nessun picco.
- **B4 punto 4 — MONOTONIA**: da 4800 in poi PF scende **monotono**
  (1,496 → 1,420 → 1,381 → 1,288 → 1,284) **e l'IS scende con lui**
  (1,317 → 1,233 → 1,038 → 0,966 → 0,846). Le due finestre **concordano**: non e' un
  artefatto di regime, il floor **costa edge davvero**. E un asse monotono **non ha un
  centro d'altopiano da scegliere** (A8).

### 🟢 IL NUMERO CHE IL PROGETTO NON AVEVA, E ORA HA
**«Chiudere R5 su questa sedia, quanto costa?»** — la cella piu' stretta che sta sopra
`40x` **anche al p95** e' `10800`:

> **−0,10958 di PF OOS** (1,39709 → 1,28751) e **−9.084,81 di profitto OOS**
> (18.029,58 → 8.944,77, cioe' **−50,4%**), contro un **DD che MIGLIORA di 1,54 punti**
> (7,2328% → 5,6879%).

E la cella minima che chiude R5 **al solo spread mediano** (`6800`) costa
**−1.834,52 (−10,2%) di profitto** e regala **+0,02311 di PF**, con il DD praticamente
fermo (**+0,0141 punti**, da 7,2328% a 7,2469%).

👉 **VERDETTO (A6, seconda forma): «chiudere R5 con questa manopola COSTA meta' del
profitto fuori campione, ed e' un baratto — non una riparazione».**
🔴 **Il baratto e' [FIRMA DI CLAUDIO]**: rischio e taglie non sono nostri (A10).
📌 E la previsione scomoda scritta prima della corsa (*"MI ASPETTO CHE IL FLOOR COSTI
EDGE"*) e' **confermata**, col prezzo attaccato.

### `r137b` — lo stesso floor ma **saltando** i giorni stretti: non misurabile in costo
Criteri: `prove/R137b_floorstop_salta_770101_D30EUR.txt` (A1..A10 verbatim identiche a
quelle di `R137a` — confrontate riga per riga, nessuna conseguenza sui numeri).
`n IS` crolla sulla **serie intera**, tutte e sette le celle: **175 → 162 → 126 → 84 →
43 → 27 → 15**. Qui la manopola tocca la **selezione**, non solo lo stop.
Le celle in costo (6800…12800) hanno **117,2 / 69,3 / 46,5 / 25,0 posizioni OOS**, cioe'
**tutte sotto il pavimento dei 150**: per A2 **non possono contare a favore**. Possono
contare **contro**, come fatto di forma — e la forma e' netta: PF OOS
**1,271 → 1,185 → 0,976 → 0,876**.
🟢 **Saltare i giorni compressi distrugge l'edge.** Verdetto: *"non c'e' una
configurazione robusta su questo asse"*, con la pendenza dichiarata.

### `r137c` — il parziale del DAX: **C1 PASSA su tutti e quattro gli esiti**
Criteri congelati: `prove/R137c_parziale_770101_D30EUR.txt`, **C1..C4**.
🔴 **Qui le «A» NON esistono**: `A1` e' di `R137a/b` e a questo round **non si applica**.
- **C1 RIPRODUZIONE** (il cancello di tutto il gruppo): cella 50 → IS **175 / 1,12634 /
  5,4362**, OOS **270 / 1,39709 / 7,2328**; cella 0 → IS **132 / 1,18323 / 4,9576**, OOS
  **193 / 1,49140 / 6,2719**. ✅ **Quattro esiti su quattro, tolleranza zero sui Trades.**
- **C3 RISCHIO**: entrambe le celle sotto 8,0% in tutte e due le finestre. ✅
- ⚠️ **E L'UNITA', perche' qui la cifra inganna**: 193 contro 270 **non** sono meno
  operazioni. Il rapporto uscite/posizioni e' **1,3990 col parziale** e **1,0000 senza**:
  **193 posizioni contro 193 posizioni, identiche.**
- **C2 SELEZIONE**: la cella dichiarata **prima** e' `InpTP1_ClosePct=0`, e i numeri la
  confermano: **+0,09431 di PF OOS e −0,96 punti di DD, a parita' di posizioni**.
  🔴 **Quello che manca non e' una misura: e' una FIRMA** — [FIRMA DI CLAUDIO] (C4/A10).
- E vale B4(iii): **questo 1,49140 non si confronta con le celle di `r137a`**, o si
  muovono due manopole insieme — l'errore che l'11/09 e' costato mezza giornata.

### `q770be` — il breakeven del DAX: **misurato, e il buco RESTA APERTO**
Criteri congelati in `prove/LE_QUATTRO_FIRME_02_be_regalo_ini.txt`.
🔴 **La variabile che decide NON e' il PF: e' la PEGGIOR GIORNATA DI EQUITY** — soglia
r.59-60: *"si RACCOMANDA solo se la peggior giornata di equity **migliora di almeno 0,05
punti percentuali** E il PF resta >= 1,40"*. **E' una colonna del CSV** (`Peggior
Giornata %`, colonna 9): io al primo giro non l'avevo nemmeno aperta.

| `InpBEatR` | peggior giornata OOS | PF OOS | P/L OOS | peggior giornata IS | PF IS | Trades |
|---:|---:|---:|---:|---:|---:|---:|
| **0,0 (il «regalo» d'archivio)** | **−1,0793%** | 1,49140 | +23.607,28 | −1,0183% | 1,18323 | 193 / 132 |
| 0,5 | **−1,0793%** | 1,44637 | +19.161,41 | −1,0179% | 1,15177 | 193 / 132 |
| 1,0 | **−1,0793%** | 1,45723 | +21.163,84 | −1,0183% | 1,18323 | 193 / 132 |
| 1,5 | **−1,0793%** | 1,49140 | +23.607,28 | −1,0183% | 1,18323 | 193 / 132 |

- **SENTINELLA del file** (*"se `Trades` cambia piu' del 5% la cella misura la SELEZIONE,
  non la GESTIONE"*): **0% di variazione**, 193/193 OOS e 132/132 IS. ✅ Misura la gestione.
- 🔴 **SOGLIA CONGELATA: NESSUNA CELLA LA PASSA.** La peggior giornata OOS **non si muove
  di un millesimo** su tutte e quattro le celle; in IS il massimo e' **0,0004 punti**
  (cella 0,5), **un centoventicinquesimo della soglia** — e su una cella che peggiora il PF.
- 🔴 **VERDETTO, alla lettera del file: «IL BUCO DEL BREAKEVEN SULLA CELLA REGALO RESTA
  APERTO, e si scrive che resta aperto».** Il breakeven indipendente **non tappa** il buco
  di `ABTG_DAX_Apertura_EU.mq5` (a `InpTP1_ClosePct=0` il ramo del pari non viene mai
  eseguito). **Non e' "manopola inerte": e' una protezione che questa manopola non puo'
  comprare** — e le due frasi portano ad azioni diverse ("non fare niente" contro "c'e' un
  lavoro"), su una sedia candidata.

---

## 3-bis. 🇫🇷 `r138a` — IL GEMELLO CAC40: **BOCCIATO PER RISCHIO (F3), e il MERITO resta NON MISURATO**

Criteri congelati: `prove/R138a_gemello_F40EUR_770101.txt`, **F1..F6**. Unico cambio
rispetto alla sedia DAX viva: `@SIMBOLO` (e il magic). Nessun cambio di trading.

| finestra | PF | DD | n (deal) | P/L | peggior giornata |
|---|---:|---:|---:|---:|---:|
| **IS** | **1,44028** | 7,3578% | 130 | **+7.126,12** | −1,0259% |
| **OOS** | **0,76965** | **11,8210%** 🔴 | 195 | **−7.266,30** | −1,0640% |

- **F6 G1 determinismo**: i due magic gemelli (786204/786205) danno righe **identiche al
  centesimo** su tutte le colonne, IS e OOS. ✅ I numeri si leggono.
- 🔴 **F3 RISCHIO, a qualunque n**: `DD OOS` **11,82% > 10,0%** → **F40EUR e' BOCCIATO PER
  RISCHIO e non entra nella famiglia, qualunque frequenza abbia.** E' il criterio
  congelato, ed e' un fatto accaduto.
- **F1 FREQUENZA**: **195 deal**; il rapporto deal/posizioni su F40EUR e' **[NON
  MISURATO]**, quindi il file impone la **banda** `n/1,40 … n/1,00` = **139,3 – 195,0
  posizioni**, dentro l'atteso 130-230. Il numero esatto costa **una corsa a cella
  singola con l'export per-trade attivo**.
- **F4 COSTO**: lo spread di F40EUR non e' in `spread_flotta/`. **R5 su F40EUR e' NON
  ANCORA MISURATO — ne' verde ne' rosso.** Via piu' corta: `ABTG_SpreadOrario` su F40EUR,
  **zero passate di tester**.
- 🔴 **E IL NUMERO CHE CAMBIA LA DIAGNOSI, e che al primo giro NON avevo scritto: l'IS e'
  POSITIVO.** `PF 1,44028 · DD 7,3578% · +7.126,12` contro un OOS a `0,76965 / 11,82% /
  −7.266,30`. **Il segno si ribalta fra le due finestre.** Non e' *"la ricetta non si
  trasferisce"*: e' la firma **regime / sovradattamento**, ed e' una diagnosi diversa con
  un rimedio diverso.
- 🪦 **CERTIFICATO**: su F40EUR con questo motore sono chiuse **PF, n e DD** (caselle 1-2).
  **Gestione dell'uscita: mai messa ad asse. Gemelli di F40EUR: nessuno. TF: mai cambiato.**
  👉 Quindi il verdetto e' **«BOCCIATO PER RISCHIO (F3) — MERITO NON ANCORA MISURATO»**, e
  va scritto cosi' in `REGISTRO_TEST.md` con l'elenco di cosa manca.
  **Un morto senza certificato non e' un morto.**

---

## 4. 🧭 LE ALTRE 24 COPPIE NUOVE — screening, con i cancelli **non** applicati (e lo dico)

📐 **Il conto, per non barare**: 35 coppie nuove − 11 giudicate qui sopra
(`r136a/b/c/d`, `cemad05`, `cemad02`, `r137a/b/c`, `q770be`, `r138a`) = **24**.
Le righe `R123*` e `P0*` qui sotto **non fanno parte delle 24**: sono fra i **28 file
ricaricati byte-identici**, li porto solo perche' stanotte sono ricomparsi nel repo.

🔴 **Questa sezione NON contiene verdetti**, e stavolta e' vero anche per le righe che
sembrano gridarlo. Ognuno di questi round ha il suo file prova con criteri congelati che
**non ho letto uno per uno stanotte**: leggerli e applicarli e' lavoro dichiarato
**aperto**. Qui c'e' la fotografia dei numeri, per non perderli. Dove c'e' un **fatto di
RISCHIO** lo scrivo come tale (Emendamento B: il rischio si giudica a qualunque n) — e un
fatto di rischio **non e' un verdetto di merito**.
E per i round marcati `ohlc_`: **OHLC = screening, mai verdetti** (regola di casa).

| round | EA | simbolo | asse | celle | migliore cella OOS | PF OOS | n OOS | DD OOS | P/L OOS |
|---|---|---|---|---:|---|---:|---:|---:|---:|
| `ohlc_r127b` | SupertrendReversal_Ott | XAUUSD | SLLookback | 7 | SLLookback=5 | 1,125 | 427 | 5,91% | +3.967 |
| `ohlc_r127c` | CostToCost | EURJPY | MaxBarsHold | 8 | MaxBarsHold=50 | 1,524 | 242 | **12,26%** 🔴 | +71.354 |
| `ohlc_r139a` | EMA200 | AUDJPY | TP_RR | 4 | TP_RR=1.5 | 1,008 | 1322 | **16,89%** 🔴 | +89 |
| `ohlc_r139b` | EMA200 | GBPUSD | TP_RR | 4 | TP_RR=3.0 | 1,139 | 1321 | **10,81%** 🔴 | +1.526 |
| `ohlc_r139c` | FiboH4_Multi | GBPUSD | EngulfLookback | 3 | =8 | 0,972 | 725 | **17,29%** 🔴 | −331 |
| `r120b00/01/10/11` | SuperWave_DOW_Ott | U30USD | *(cella unica)* | 1 | nuda/notrail/noflip/vivo | 1,187 / 0,983 / 1,243 / 1,243 | 90–131 | 4,2–6,2% | −30…+344 |
| `r120e00 / e11` | SuperWave_DOW_Ott | U30USD | *(cella unica, taglia)* | 1 | nuda / vivo | 1,284 / 1,220 | 130 / 184 | 6,5 / 4,2% | +4.951 / +3.455 |
| `r126a` | SuperWave_DOW_Ott | U30USD | SLBufferAtr | 9 | =0,500 | 1,402 | 124 | 4,03% | +446 |
| `r126b` | SuperWave_DOW_Ott | U30USD | SLLookback | 7 | =9 | 1,305 | 124 | 3,55% | +391 |
| `r126d` | SuperWave | NASUSD | SLBufferAtr | 9 | =1,000 | **0,843** | 58 | 2,71% | −67 |
| `R123A/B/C/D` *(ricarica)* | SupRev_DOW_Ott | U30USD | gate/StMult/AtrP/NearAtr | 2–7 | *(gia' chiusi il 12/09)* | 1,389–1,418 | 117–152 | 5,7–5,9% | +623…+668 |
| `r132c` | SupRev_DOW_Ott | U30USD | NearAtr | 8 | =1,00 | 1,389 | 152 | 5,91% | +622 |
| `r133b` | ORB_Ottimizzato | U30USD | UseCloseConfirm | 2 | **=0** | **1,674** | 119 | 9,76% | **+41.057** |
| `r133c` | MaxMinNotte | D30EUR | MinBoxPts | 9 | =4500 | 1,062 | 59 | 8,21% | +130 |
| `r141a` | IntradayMomentum | NASUSD | UseSecondSignal | 2 | =1 | 1,486 | 133 | 1,37% | +3.562 |
| `r141b` | IntradayMomentum | U30USD | UseSecondSignal | 2 | =1 | 1,250 | 130 | 1,79% | +2.283 |
| `r141c` | AtrExhaustVol | NASUSD | ProxMode | 2 | =1 | 1,229 | 96 | 4,14% | +8.461 |
| `r141d` | HVAncora | U30USD | StopAtr | 4 | =1,0 | 1,921 | **31** | 2,06% | +6.309 |
| `r142a` | Nasdaq_Live5m | NASUSD | TP1_ClosePct | 4 | =25 | 0,970 | 175 | **23,43%** 🔴 | −308 |
| `r142b` | Nasdaq_Live5m | NASUSD | TrailTF | 5 | =2 | 1,070 | 185 | **17,62%** 🔴 | +866 |
| `r142c` | Nasdaq_Live5m | NASUSD | UseTrailing | 2 | =0 | 0,999 | 195 | **33,62%** 🔴 | −8 |
| `P0*` (9 etichette, *ricarica*) | OpeningReversalB / IBRetest / LVNArbitro / Nightly | vari | conteggio | 1 | *(vedi sotto)* | | | | |

### Le quattro cose che in questa tabella **non** sono un dettaglio
1. 🔴 **UN FATTO DI MACCHINA, E VA IN QUESTA PAGINA (classe 309).** Nel referto del runner
   (`REFERTO_RUNNER_20260913_033003.txt`) i round escono **42 a uscita 0 · 1 a uscita 2
   (`cemad02`, **atteso**: vedi §1) · 5 a uscita 3**, e i cinque sono **esattamente** `r127b`, `r127c`,
   `r139a`, `r139b`, `r139c` — cioe' **tutti e cinque gli `ohlc_*`**. Uscita 3 =
   *"ROUND GIRATO CON RILIEVI"*.
   🟢 La spiegazione parsimoniosa e' il **Modello 1**: verificato che **tutti e cinque
   girano a Modello 1** e che **nessuno dei 31 round a Modello 4 esce 3**.
   ⚠️ **Ma il codice 3 ha un `-or`**: puo' essere scattato **anche** per *"un PID
   non-bersaglio sparito"* — e i non-bersaglio sono **i terminali in forward, REALE
   `10105439` compreso**. Il log che lo direbbe e' **sovrascritto** (difetto 307).
   👉 **La chiusura costa la lettura di 5 file**: il `REFERTO_ROUND_<etichetta>.txt`
   dentro `Desktop\ROUND_*.zip` sul VPS. **Finche' non e' letto, non e' escluso** —
   solo improbabile.
2. 🔴 **`ABTG_Nasdaq_Live5m`: FATTO DI RISCHIO su tutte e tre le corse.** DD OOS fra
   **17,6% e 33,6%** su ogni cella di `r142b/c`, con PF che non arriva a 1,08.
   E' un fatto di rischio a qualunque n (Emendamento B). 🔴 **Nessun verdetto di merito**:
   `R142a/b/c` non sono stati aperti.
3. 🔴 **`ABTG_OpeningReversalB` non spara**: **1-3** operazioni in IS e **ZERO in OOS** su
   tutti e quattro i round `P0*`. Non e' "un motore che perde": e' **NON MISURATO**, e
   va scritto cosi' (un morto senza certificato non e' un morto).
   Stessa famiglia di fatto: `IBRetest` gira ma fa `PF OOS 0,593 / 0,697 / 0,965` su
   49-107 deal nei tre simboli.
4. 🟡 **`r133b` merita una riga sua.** Spegnere `UseCloseConfirm` porta l'ORB da
   `PF OOS 1,122` a **1,674** con **+41.057** — ma su **119 deal** e con `DD 9,76%`, a un
   soffio dal muro. Asse a due celle. 🔴 **Criteri NON applicati**:
   `R133b_filtrovolumi_U30USD.txt` non e' stato aperto stanotte, quindi qui **non si cita
   nessuna sigla** — e' fotografia, non verdetto.
   🔴 **E c'e' un fatto di RISCHIO che va detto a qualunque n**: la cella **VIVA** (`=1`)
   in **IS** fa `PF 0,523` e **`DD 27,21%`**, con **−24.193**.

---

## 5. 🧪 I CONTRO-ESEMPI CHE HO COSTRUITO CONTRO ME STESSO (regola 10/09)

1. **«98 CSV nuovi» poteva essere un falso.** `find -newermt` legge l'**mtime**, che un
   `git pull` riscrive su tutto cio' che tocca. Contro-prova: `git log --diff-filter=A`
   file per file → **98 su 98 aggiunti oggi**. Non e' l'orologio del filesystem.
2. **«70 misure nuove» poteva contarne 98.** Confronto md5 contro tutti i 1.537 CSV del
   repo → **28 sono ricariche byte-identiche**. Le ho tolte dal conto.
3. **Il mio stesso script mi ha quasi fatto scrivere una falsa accusa.** Segnalava
   *"tutte le righe identiche → ramo che non gira"* su `r120*`, `r138a`, `P0CONTA`.
   Ho aperto i file prova: quei round hanno **l'asse sul magic di proposito** — sono
   **corse a cella unica** eseguite come due passate gemelle. **Righe identiche li' e'
   il comportamento atteso, non un difetto.** Il rilevatore di "ramo che non gira" vale
   **solo** su un asse che dovrebbe cambiare il comportamento.
4. **Il fattore uscite→posizioni non e' una costante del motore.** Vale 2,0117 alla cella
   viva; sugli assi che muovono il parziale cambia. Ho calcolato il fattore-limite che
   farebbe cadere ogni cella sotto 150 (3,15 su `r136a`, 2,81 su `r136b`): nessun
   verdetto si ribalta. Se non l'avessi fatto, la colonna "posizioni" sarebbe stata una
   misura finta.
5. **La riproduzione S1 poteva farmi dire una cosa piu' grossa di quella che ho.**
   S1 che passa dimostra **che il banco riproduce**; il binario compilato e' un fatto
   **separato**, e l'ho ricostruito con una catena dichiarata (§1), non dato per scontato.

### 🔴 E I CINQUE CONTRO-ESEMPI CHE **NON** AVEVO FATTO, trovati dal cancello
Li scrivo qui perche' quattro di loro hanno **cambiato un verdetto**, e uno ha ribaltato
due «non lo so» in due risultati. Se il cancello non fosse passato, questo referto sarebbe
uscito con quattro verdetti sbagliati.
- **(A) LA COERENZA DEL TERZETTO** — `R136d` la chiama *"il controllo piu' potente che
  questa notte produce"*, e io non l'avevo fatta. **Fatta ora (§2.3-bis): la condizione
  SCATTA**, e toglie a `r136d` l'attribuzione dell'effetto.
- **(B) L'ASSE DI `r136b` MUOVE TRE COSE INSIEME** (parziale, pari e inizio trailing sono
  agganciati a `beDone`): quindi il **DD 2,10%** della cella 0,25 **non e' attribuibile al
  primo bersaglio**. Avevo scritto il numero senza la sua attribuzione.
- **(C) L'UNITA' DI `r137c` e `q770be`**: 193 contro 270 **sembra** meno operazioni, in
  POSIZIONI e' **193 contro 193**. Avevo letto due unita' diverse come se fossero una.
- **(D) IL MECCANISMO DI PUBBLICAZIONE** (§0): non era un'ignoranza, era un file non aperto.
- **(E) IL SEGNO DELL'IS DI `r138a`** (§3-bis): **+7.126,12 e PF 1,44** in IS, che
  **avevo omesso**, e che cambia la diagnosi da *"non si trasferisce"* a *"regime"*.
- **(F) LA VARIABILE DI `q770be`** era la **peggior giornata**, non il PF — ed e' una
  **colonna del CSV** che non avevo aperto.

---

## 6. 📋 COSA RESTA APERTO (elencato per nome, mai «tutto il resto»)

- ⬜ **Versionare lo strumento di import di massa** (o toppare `PubblicaFile` perche'
  pubblichi anche i CSV): oggi **i numeri NON arrivano da soli** (§0, misurato).
- ⬜ **`git log` per percorso su tutto `risultati_prove/`**: verificare che l'import non
  abbia **sovrascritto in silenzio** nessun CSV preesistente (classe 311). Non fatto.
- 🔴 ⬜ **I CINQUE `ohlc_*` a uscita 3**: leggere `REFERTO_ROUND_<etichetta>.txt` dentro
  `Desktop\ROUND_*.zip` sul VPS per **escludere che sia sparito un PID** (REALE
  `10105439` compreso). **Costa la lettura di 5 file, ed e' la cosa piu' urgente
  dell'elenco.**
- ⬜ **Emendare `COLLAUDO_EMADOW_05`**: la sua regola di selezione ha due rami e il
  misurato non cade in nessuno dei due (§2.5).
- ⬜ **Emendare il modello meccanico di `R136a`**: prevedeva `n` in calo, il misurato sale.
- ⬜ **`r138a` in `REGISTRO_TEST.md`**: «BOCCIATO PER RISCHIO (F3) — MERITO NON ANCORA
  MISURATO», con le tre caselle mancanti. E **F4**: spread di F40EUR con
  `ABTG_SpreadOrario`, zero passate di tester.
- ⬜ **Referti per 24 coppie, elencate per nome** (mai «tutto il resto»): `r120b00`,
  `r120b01`, `r120b10`, `r120b11`, `r120e00`, `r120e11`, `r126a`, `r126b`, `r126d`,
  `r132c`, `r133b`, `r133c`, `r141a`, `r141b`, `r141c`, `r141d`, `r142a`, `r142b`,
  `r142c`, `ohlc_r127b`, `ohlc_r127c`, `ohlc_r139a`, `ohlc_r139b`, `ohlc_r139c`.
  Ognuna ha il suo file prova con criteri congelati: **vanno applicati quelli, non
  quelli di r136/r137.** (Le 9 etichette `P0*` **non** sono in questa lista: hanno gia' il loro
  `REFERTO_ROUND_P0*.txt` in repo.)
- ⬜ **Prova di REGIME** per tutto il gruppo r136/r137: assente (21 mesi di solo toro).
- ⬜ **`r136d` (trailing spento) e `r133b` (close-confirm spento)**: due assi booleani con
  un vantaggio sopra la banda di rumore, **entrambi «NON MISURABILI»** (segno che si
  inverte fra IS e OOS). Non promuovibili per costruzione: **finestra nuova o prova di
  regime**. Costo stimato: una corsa ciascuno.
- ⬜ **UN ASSE CHE SPENGA IL TRAILING LASCIANDO ACCESO IL PARZIALE**, a piu' di due celle:
  senza quello l'effetto di `r136d` resta **non attribuito** (§2.3-bis).
- ⬜ **`r136b` cella 0,25**: DD OOS 2,10% contro 7,83% a PF piu' alto. Round suo — ma
  l'effetto **non e' attribuibile al primo bersaglio** finche' parziale/pari/trailing
  restano agganciati a `beDone`.
- ⬜ **Il buco del breakeven sulla cella regalo del DAX RESTA APERTO** (`q770be`): non lo
  tappa questa manopola. Serve un meccanismo diverso.
- ⬜ **Casella 4 del certificato (gemelli) per EMA200**: stanotte AUDJPY e GBPUSD sono
  stati misurati **in OHLC**. A tick reali: non fatta.

---

## 7. 🎯 IN UNA RIGA, PER LA BUSSOLA DEL 1° OTTOBRE

La sedia migliore della flotta (**`ABTG_EMA200` U30USD H1**) stanotte ha chiuso **due
caselle del certificato di morte** (uscita e TF) e ha retto **dieci riproduzioni su
dieci** — su un binario **post-patch**, quindi la patch dell'11/09 e' **neutra sul
trading**. La sua cella viva **non e' un picco**, sta dentro un **altopiano di cinque
celle** sullo stop, e su `r136c` **e' esattamente il CENTRO del suo altopiano**: la
conferma piu' forte che questa notte produce, e a norma di regola di selezione.
**Nessuna delle quattro manopole dell'uscita la batte**: su due il centro dell'altopiano
e' **peggiore** della cella viva, su una il centro **e'** la cella viva, e la quarta
(trailing) e' **«NON MISURABILE»** — il segno si inverte fra IS e OOS.
Sul DAX ora sappiamo **quanto costa chiudere R5**: meta' del profitto fuori campione.
E sul CAC sappiamo che il gemello e' **bocciato per rischio** (DD OOS 11,82%), con il
**merito ancora non misurato**.
🔴 **Nessuna sedia e' stata accesa, nessun preset toccato, nessun parametro in forward
cambiato, e nessuna riga di questo referto tocca il conto reale.**

🚦 **CANCELLO**: strato 1 (`controlla_riga.py --md`) PASS; strato 2 (`controllo-preventivo`)
**FAIL alla prima stesura, con 9 difetti bloccanti** — tutti verificati alla fonte da me e
tutti corretti **prima** che i verdetti uscissero dalla sessione. Quattro verdetti su
undici erano sbagliati: `r136b`, `r136c`, `r137c` e `q770be` giudicati con criteri
importati da un file che non li copriva, e `r138a` senza il suo IS.
➕ E un quinto, trovato da un'altra sessione e verificato da me: **`cemad02` non era un
round rotto, era un round riuscito** (classe 312) — avevo copiato il codice d'uscita del
driver come se fosse un verdetto.
