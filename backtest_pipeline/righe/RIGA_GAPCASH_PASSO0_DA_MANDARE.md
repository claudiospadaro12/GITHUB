# 📬 PASSO 0 — **GAP DELLA SESSIONE CASH DEL NASDAQ** — LA RIGA DA MANDARE

**Che cos'è:** il **PASSO 0** del candidato **A** della caccia Nasdaq del 06/09
(`caccia_strategie/CACCIA_NASDAQ_MECCANISMI_2026-09-06.md` §2, voto **PROVA
SUBITO**). Si misura, **sui tick di BCM**, se il fenomeno esiste: quante
giornate-evento, che segno, quanto costa e che geometria ha.

> 🔴 **NON È UN ROUND E NON PROMUOVE NIENTE.** La sonda è un **contatore**:
> zero ordini, zero lotti, zero magic, zero sedie. Non c'è profit factor, non
> c'è equity, non c'è drawdown. **Una frequenza alta NON è un edge: è una
> frequenza.**

| | |
|---|---|
| **Sonda** | `mql5/Experts/ABTG_SondaGapCash.mq5` (v1.00, ~1.990 righe) |
| **Driver** | `backtest_pipeline/righe/RIGA_GAPCASH_PASSO0.ps1` (marcatore `MARCATORE_RIGA_GAPCASH_PASSO0_v1`) |
| **Contratto** | `backtest_pipeline/prove/GAPCASH_NAS_PASSO0.txt` — criteri **congelati il 06/09, PRIMA di qualunque numero BCM** |
| **File del controllo** | `backtest_pipeline/prove/GAPCASH_NAS_PASSO0_CONTROLLO.txt` |
| **Dossier** | `backtest_pipeline/caccia_strategie/CACCIA_NASDAQ_MECCANISMI_2026-09-06.md` §2 |
| **Dove gira** | 🖥️ **PC DI BACKTEST**, mai sul VPS |

---

## 🔴 LE TRE COSE DA SAPERE PRIMA DI TOCCARE LA TASTIERA

1. **LA SONDA NON È MAI STATA COMPILATA DA NESSUNO.** È stata scritta il 06/09
   e in quell'ambiente MetaEditor non esiste. **`COMPILAZIONE FALLITA` è
   l'esito più probabile della prima corsa, ed è un esito NORMALE**: la riga lo
   dice chiaro, allega il log del compilatore nello zip ed esce con **codice
   3**. Non è un guasto della riga: **è il risultato**, e si manda così com'è.
2. **MT5 e MetaEditor devono essere CHIUSI.** Col terminale aperto il tester
   non gira (zero CSV); con MetaEditor aperto la compilazione **torna subito
   senza compilare**. La riga si rifiuta di partire in tutti e due i casi.
3. **`14:30` è ORA SERVER BCM** = 15:30 italiane = 09:30 New York. **Non si
   converte niente**, il contratto lo pinna già in ora server.

---

## 🎯 LE DUE CORSE, E PERCHÉ SONO DUE CSV DISTINTI

| corsa | file prova | gate | celle | CSV prodotto |
|---|---|---|---|---|
| **GATE** | `GAPCASH_NAS_PASSO0.txt` | **ACCESO** (`InpGateSpento=false`) | **8** | `ABTG_SondaGapCash_NASUSD_IS_GATE.csv` |
| **CONTROLLO** | `GAPCASH_NAS_PASSO0_CONTROLLO.txt` | **SPENTO** (`InpGateSpento=true`) | **2** | `ABTG_SondaGapCash_NASUSD_IS_CTRL.csv` |

### ⚠️ La scelta contestabile, dichiarata: **`-ConControllo` NON ESISTE**

Il contratto (par. 6) dice che la corsa di controllo *"si lancia a parte con
`-ConControllo`"*. **Verificato il 07/09: zero occorrenze di quella stringa in
tutto il repo.** Il contratto ha nominato un interruttore immaginario.

Il modo che `walkforward_generico.ps1` ha **davvero** per far girare la stessa
sonda con un input diverso è **`-Prova` su un file variante** + **`-Etichetta`**
per il nome del CSV. **È la strada scelta**, ed è la più semplice delle due
possibili (l'altra sarebbe aggiungere `-ConControllo` al driver generico, che è
condiviso da tutti i round: si toccherebbe uno strumento vivo per un round
solo). **L'intenzione del contratto è rispettata alla lettera**: due misure, due
CSV con nomi diversi, **che non possono sovrascriversi**.

🔒 **Il contratto NON è stato toccato**: `GAPCASH_NAS_PASSO0.txt` resta byte per
byte com'era il 06/09. Il file del controllo è **nuovo** e differisce dal
contratto **su due righe sole** — e il driver **si ferma** se ne trova una
terza.

### Perché il controllo ha **2 celle e non 8**
A gate spento la soglia **non ha nessun effetto** (nel sorgente
`EventoLong_Calc()` fa `if(gateSpento) return(true)` **prima** di guardare il
gap): 8 celle sarebbero 6 passate a tick reali buttate. Ma **una sola non si
può**: **classe 134** — con `Optimization=1` e zero assi ottimizzabili MT5 non
esegue **nessuna** passata, esce con codice 0 e lascia il **CSV da zero byte**.
Due celle identiche = asse tecnico + **gemello di determinismo gratis**.

---

## 🚧 IL CANCELLO — è **CODICE**, e sta **IN MEZZO** alle due corse

> 🔴 **Classe 151, imparata oggi sbagliando.** In R118 i criteri promettevano
> *"il round si ferma prima di spendere macchina"* e nel driver **non c'era
> nessun confronto**: solo una `Write-Host` **dopo** le 170 passate. Qui il
> cancello è una funzione, gira **fra la corsa GATE e quella di CONTROLLO**, e
> **si può far fallire da riga di comando**.

Dopo la corsa GATE il driver legge il CSV appena prodotto e **non spende la
corsa di CONTROLLO** se:

| condizione | perché ferma |
|---|---|
| il CSV non è leggibile / non ha **8 righe** | o lo sweep non ha spazzolato, o è la **cache del tester** |
| `Autotest Falliti > 0` | le funzioni di misura non fanno quello che dicono |
| `Autotest Blocchi ≠ 8` | il sorgente che ha girato **non è** quello atteso |
| `Eco Gate Spento = 1` nella corsa GATE | ha misurato il controllo due volte, non il gate |
| **nessuna** cella arriva a **25 giornate-evento** | **P0-1 SCARTO**: il contratto dice che non c'è round |

In quel caso: **referto + zip escono lo stesso**, codice di uscita **2**. Non è
un guasto: **è macchina risparmiata**.

**Lo puoi collaudare tu, senza MT5 e senza pin**, dandogli un CSV qualunque
(anche inventato):

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='4bf50bbf88f74a22a0c06648969c204f941ee2cf'; $p="$env:USERPROFILE\RIGA_GAPCASH_PASSO0.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_GAPCASH_PASSO0.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_GAPCASH_PASSO0_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -CollaudoCancello 'C:\percorso\del\csv_da_provare.csv';
    Write-Host ("codice di uscita del collaudo: " + $LASTEXITCODE) -ForegroundColor Cyan }
```
Esce **0** se avrebbe fatto passare, **2** se avrebbe fermato — con il motivo
scritto. **Non apre MT5, non compila, non tocca niente**: legge solo il CSV che
gli dai. (Anche questo blocco ha il suo `irm`: `$p` e `$pin` nascono **dentro**
il `& { }` e non sopravvivono.)

---

## 📌 IL PIN — **`4bf50bbf88f74a22a0c06648969c204f941ee2cf`**

```
4bf50bbf88f74a22a0c06648969c204f941ee2cf
```

La riga passa il pin a `-Pin` e **si rifiuta di partire senza**: un default
silenzioso (`lavoro`) farebbe girare la punta del branch spacciandola per un
commit congelato. Il driver **pinna anche `$EABranch` dentro
`walkforward_generico.ps1`**, altrimenti il pin varrebbe per il driver e **non
per la sonda misurata**.

✅ **Verificato al pin** (HTTP 200 + sha256 identico alla copia locale), file
per file: `RIGA_GAPCASH_PASSO0.ps1`, `GAPCASH_NAS_PASSO0.txt`,
`GAPCASH_NAS_PASSO0_CONTROLLO.txt`, `ABTG_SondaGapCash.mq5`,
`walkforward_generico.ps1`, `misura_tick_NASUSD.csv`.

### ♻️ RI-PINNATURA, se un artefatto viene corretto

```bash
F=backtest_pipeline/righe/RIGA_GAPCASH_PASSO0_DA_MANDARE.md
NUOVO=<il commit nuovo, 40 caratteri>
VECCHIO=$(grep -oE "\\\$pin='[0-9a-f]{40}'" "$F" | head -1 | grep -oE '[0-9a-f]{40}')
echo "vecchio: $VECCHIO"
sed -i "s|\$pin='$VECCHIO'|\$pin='$NUOVO'|g; s|^$VECCHIO\$|$NUOVO|; s|\*\*\`$VECCHIO\`\*\*|\*\*\`$NUOVO\`\*\*|g" "$F"
grep -c "\$pin='$NUOVO'" "$F"    # DEVE dare 4
grep -c "\$pin='$VECCHIO'" "$F"  # DEVE dare 0
```

⚠️ **Servono tutti e due i conteggi**: il solo *"0 pin vecchi rimasti"* lo
supera a mani basse anche un `sed` che **non ha matchato niente**.

---

## 1️⃣ PRIMA il giro a vuoto (**compila davvero; NON apre MT5 per il tester**)

> ⚠️ **Qui la parola "CONTROLLO" è già presa** dalla corsa a gate spento. Il
> giro a vuoto si chiama **`-GiroAVuoto`**, non `-SoloControllo`: due cose
> diverse non possono avere lo stesso nome nella stessa pagina.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='4bf50bbf88f74a22a0c06648969c204f941ee2cf'; $p="$env:USERPROFILE\RIGA_GAPCASH_PASSO0.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_GAPCASH_PASSO0.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_GAPCASH_PASSO0_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -GiroAVuoto;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! GIRO A VUOTO NON PASSATO: NON lanciare la corsa vera. Leggi il REFERTO sul Desktop.' -ForegroundColor Red } }
```

**Cosa deve dire**, in ordine:

- `pin ......... <40 caratteri>` e `corse ....... GATE + CTRL`;
- `finestra .... 2024.09.26 -> 2026.06.30   UNA TRANCHE`;
- `feriali ..... 459 giorni feriali di CALENDARIO`;
- `walkforward_generico.ps1 scaricato e PINNATO`;
- `tick ........ NASUSD TICK  prima data 2024.09.26  conteggio 166509474  verdetto 'TICK REALI PARZIALI'`;
- `sorgente .... v1.00, marcatore OK, autotest dichiarato 8 blocchi / 74 casi`;
- `i 9 nomi vincolanti del contratto esistono tutti nel sorgente`;
- **`celle ....... GATE 8  |  CTRL 2`** ← è **questo** il numero che deve tornare;
- `stella ...... i due file prova differiscono SOLO su InpGateSpento e InpSogliaGapPct`;
- `terminale ... ...BCM Markets MT5 Terminal...` — **non devi controllarlo tu**:
  dal pin `4bf50bb` è un **cancello**. Se il ripiego del selettore pescasse la
  `-V3` (100k **50504263**) o `C:\BCM_Reale` (reale **10105439**), la riga si
  ferma con `TERMINALE SBAGLIATO` **prima** di copiarci dentro la sonda;
- 🎯 **`compilata la sonda: OK (<n> KB, <ora>, log: 0 errori, 0 avvisi)`** — è
  il **primo risultato vero** di questo PASSO 0. Se invece esce
  `COMPILAZIONE FALLITA`, le righe rosse sopra **sono il risultato**: si copia
  lo zip in chat e ci si ferma lì;
- due volte l'anteprima dell'`.ini` del driver generico, e in fondo
  `ESITO: GIRO A VUOTO COMPLETATO`.

> ⚠️ **Quello che il giro a vuoto NON può fare:** non apre il tester. Nessuna
> giornata-evento, nessuno spread, **nessun cancello valutato** (dirà
> `NON VALUTABILE`). Conferma gli **artefatti e la compilazione**, mai i numeri.

---

## 2️⃣ POI la corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='4bf50bbf88f74a22a0c06648969c204f941ee2cf'; $p="$env:USERPROFILE\RIGA_GAPCASH_PASSO0.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_GAPCASH_PASSO0.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_GAPCASH_PASSO0_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO NON ZERO: lo zip esiste lo stesso: MANDALO, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**: è **un comando solo**. Righe staccate sarebbero
comandi indipendenti, e un `throw` alla prima non fermerebbe le altre.

### 🔁 Se serve rifare **una corsa sola**

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='4bf50bbf88f74a22a0c06648969c204f941ee2cf'; $p="$env:USERPROFILE\RIGA_GAPCASH_PASSO0.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_GAPCASH_PASSO0.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_GAPCASH_PASSO0_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloCorsa 'CTRL' -Rifai;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO NON ZERO: manda lo zip lo stesso' -ForegroundColor Yellow } }
```

> ⚠️ **Ogni ripresa è un BLOCCO INTERO, col suo `irm`.** `$p` e `$pin` nascono
> **dentro** il `& { ... }`, che è uno scope figlio: finito quel blocco **non
> esistono più**.

---

## 🔢 I CODICI DI USCITA — e **nessuno** vuol dire "il motore va bene"

| codice | significa |
|---|---|
| **0** | tutto girato, referto completo |
| **2** | **PARZIALE**: il cancello ha fermato la spesa, oppure ci sono PROBLEMI. **Lo zip è valido: si manda** |
| **3** | **COMPILAZIONE FALLITA** — esito normale e gestito. Il **log del compilatore è nello zip, ed è quello il risultato** |
| **1** | fermato prima da un cancello di pre-volo o da un'eccezione |

> 🎭 **Classe 154 (aggiunta alla checklist oggi stesso).** Il driver chiama
> **sempre un `exit` esplicito su ogni ramo** (0/1/2/3): il codice che il blocco
> di lancio legge in `$LASTEXITCODE` è **il suo**, non quello di
> `metaeditor64.exe` lanciato dentro. E **all'incontrario**: il codice con cui
> esce `walkforward_generico.ps1` **non viene usato come verdetto**, perché sul
> ramo buono quello script non fa `exit` e restituisce il codice dell'ultimo
> `.exe` che ha lanciato dentro (**metaeditor esce non-zero anche solo per degli
> avvisi**). Quel numero finisce nei **RILIEVI**; **il giudizio è sull'artefatto**,
> cioè sul CSV: presente, fresco, con le colonne giuste e il numero di righe
> giusto.

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul **Desktop**: `GAPCASH_PASSO0_<MODO>_<data>_<ora>` — dentro:

- **`REFERTO_GAPCASH_PASSO0.txt`** ← **è questo che conta**;
- `ABTG_SondaGapCash_NASUSD_IS_GATE.csv` (**8 righe**, gate acceso);
- `ABTG_SondaGapCash_NASUSD_IS_CTRL.csv` (**2 righe**, gate spento);
- i due file prova e `misura_tick_NASUSD.csv`;
- `COMPILAZIONE_ABTG_SondaGapCash.log`, se il compilatore ne ha lasciato uno.

> 🧊 **Nello zip entra SOLO ciò che ha prodotto QUESTA corsa** (classe **155**,
> riprodotta il 07/09 eseguendo, e corretta nel pin `4bf50bb`). La cartella di
> lavoro è riusabile: prima della correzione una corsa morta alla
> **compilazione** (uscita 3, l'esito più probabile della prima corsa)
> spediva nello zip i **due CSV della corsa buona del giro prima**, sotto un
> referto che diceva `corsa GATE ..: NON ESEGUITA`. Adesso i file vecchi
> restano fuori, il referto conta quelli allegati
> (`CSV di misura allegati allo zip: n`) e la console stampa l'elenco
> **letto dalla cartella**, non la lista fissa di quello che ci sarebbe
> dovuto essere.

### 📅 Le due righe da guardare per prime nel referto
1. **`modo:`** — `CORSA` (il risultato) o `GIRO A VUOTO` (**non si manda come
   risultato**);
2. **`data:`** — **deve essere di ADESSO**.

---

## 🥇 IL NUMERO DA GUARDARE PER PRIMO **NON È IL VERDETTO**

1. 📊 **P0-1: le giornate-evento alla soglia −0,50%, contro le ~68 attese.**
   L'atteso viene da 503 feriali; **questa finestra ne ha 459**, quindi
   riscalato fa **~62**. Il **cancello resta 25**, che è quello congelato — il
   riscalo serve a leggere, non a giudicare. Molto meno di 62 ⇒ **il fenomeno
   su BCM è un'altra cosa** rispetto a quello misurato sullo storico esterno.
2. 📅 **La QUOTA DEI LUNEDÌ di P0-6.** Sopra il **40%** questo **non** è il gap
   della sessione cash: è **il gap del weekend travestito**, già misurato e già
   bocciato da R61/R62 → **verdetto SOSPESO**, qualunque cosa dicano gli altri
   criteri.

Il verdetto complessivo **si legge sulla cella −0,50%**, dichiarata prima. Le
altre sette servono a vedere se la soglia è **monotòna**, **non** a scegliere la
più bella: *centro dell'altopiano, mai il picco*.

---

## ⚠️ P0-7 — LA COLLISIONE, che il referto è OBBLIGATO a stampare

Su `NASUSD` alle **14:30:00 server** c'è già roba:

| | chi | magic | TF |
|---|---|---|---|
| 1 | `ABTG_ORB` | 770601 | M5 |
| 2 | `Nasdaq_Apertura_US_Ottimizzato` | (vedi `FLOTTA_ATTIVA.md`) | M5 |
| 3 | **GATED SHORT** | **770250** | M15 |

🔴 **Su una mattina di gap in giù la 770250 VENDE e questo motore
COMPREREBBE**: opposti, stesso simbolo, stesso minuto. Non è una
sovrapposizione di orario — è **una posizione contro l'altra dentro lo stesso
conto**. **Va sciolto PRIMA di qualunque deploy**, e questo PASSO 0 non lo
scioglie: lo mette agli atti.

⚠️ **Lo stato acceso/spento di quelle tre sedie NON è misurato da questa
corsa.** `report/M27_SEGNO_ASPETTATIVA_2026-08-31.md` dice che l'ORB nativo
`770601` è stato **spento a inizio agosto**: se è così, il conflitto vivo resta
quello con la **770250**. **[DA VERIFICARE al momento del deploy.]**

---

## 🧊 COSA QUESTA CORSA NON DICE — scritto prima, non dopo

- **NON** dice se il motore guadagna: nessun ordine, nessun PF, nessuna equity,
  nessun drawdown.
- **NON** promuove nessuna cella e **non tocca nessuna sedia viva**, nessun
  preset, nessun magic. Gli `.ini` hanno `AllowLiveTrading=false`.
- Anche se passa tutto, **il MERITO resta SOSPESO in partenza**: 0,14
  eventi/giorno è **un ottavo** del pavimento di frequenza di casa. Questo
  motore **non può essere portata** — al massimo un **cecchino**.
- ⏱️ **Durata [STIMA, non una previsione]: 20-60 minuti** più la compilazione.
  10 passate a tick reali (8 + 2) su ~21 mesi di M5, 2 avvii del terminale.
  La sonda legge M1 giorno per giorno **e** i tick del minuto della campana:
  è **più lenta** di un EA normale. **Non è una promessa.**
- 🟡 **La gamba `*_OOS` è DEGENERE e si ignora.** Con `-FrazioneIS 1` la
  finestra è **una sola** (il contratto si aspetta ~68 eventi sull'**intera**
  finestra: su una metà il conteggio finirebbe a ridosso del cancello **per
  costruzione**). **Il rosso del driver generico sui CSV `*_OOS` è ATTESO: non
  rilanciare niente.** Il conteggio dei `*_OOS` trovati (**attesi 0**) sta nel
  referto.
  ⚠️ **[NON MISURATO]** a Modello 4 non è agli atti quanto MT5 impieghi a
  scartare una gamba con `FromDate > ToDate`. In casa è successo solo a
  Modello 2 (secondi). Se il terminale si riapre un attimo per niente, è quello.

---

## ✅ COSA È GIÀ STATO VERIFICATO — **eseguendo**, prima dell'invio

- ✅ il `.ps1` **parsa**: `pwsh` + `[Parser]::ParseFile` → **0 errori**, **8.670
  token**; **ASCII puro** (0 byte non-ASCII, regola del 17/08);
- ✅ **audit collisioni CASE-INSENSITIVE sui token**: **185 variabili, 0
  collisioni**; **nessun uso di `$args`**;
- ✅ **lo sweep fa DAVVERO 8 celle**: `walkforward_generico.ps1 -SoloControllo`
  eseguito sul file prova vero → `InpSogliaGapPct  8 celle`, `celle per
  finestra: 8`; e sul file del controllo → **2 celle**;
- ✅ **i due CSV finiscono in due nomi distinti**: corsa completa a banco (con un
  finto driver generico), `..._IS_GATE.csv` **e** `..._IS_CTRL.csv`, **due file**;
- ✅ **il cancello è stato FATTO FALLIRE, uno scenario per volta** — 1 controllo
  positivo + **6 fermate**:

  | CSV dato in pasto | il cancello ha detto |
  |---|---|
  | 8 righe sane, 141 eventi | **fa passare** (controllo positivo) |
  | file inesistente | `CSV della corsa GATE non letto` |
  | eventi /10 (max 14) | `P0-1 SCARTO: ... 14 ... sotto il cancello di 25` |
  | `Autotest Falliti = 3` | `l'AUTOTEST della sonda dichiara 3 casi FALLITI` |
  | `Autotest Blocchi = 7` | `ha girato 7 blocchi invece di 8` |
  | `Eco Gate Spento = 1` | `la corsa GATE dichiara il gate SPENTO` |
  | 6 righe invece di 8 | `ha 6 righe invece di 8 ... o la CACHE del tester` |

- ✅ **e il cancello FERMA DAVVERO LA SPESA**, non lo dice soltanto: nello
  scenario "pochi eventi" il driver generico è stato invocato **1 volta sola**
  (non 2), esiste **solo** il CSV `_GATE`, uscita **2**. È la prova che chiude
  la **classe 151**;
- ✅ **i 10 cancelli di PRE-VOLO fatti fallire uno per uno**, 10 fermate col
  messaggio giusto: file prova **scambiati**, sweep a **7 celle**, **terza**
  differenza fra i due prova, `@PERIODO` cambiato, **parametro doppio**,
  **secondo asse Y**, input vincolante **rinominato nella sonda**, `#define`
  dell'autotest **8→9**, **marcatore** cambiato, asse tecnico del controllo a
  **una** cella;
- ✅ **il ramo COMPILAZIONE FALLITA** collaudato con un MetaEditor **finto** che
  non produce nessun `.ex5`: `compilazione : FALLITA (nessun .ex5 prodotto; log
  del compilatore: 1 errori, 0 avvisi)`, log allegato allo zip, **uscita 3**,
  **in 1 secondo** (c'è un'uscita anticipata dall'attesa quando il log dichiara
  già errori);
- ✅ **i quattro stati della compilazione esistono nel codice**
  (`NON TENTATA` / `TENTATA, esito ignoto` / `FALLITA (motivo)` / `OK (...)`) e
  `TENTATA, esito ignoto` viene **scritto PRIMA** di lanciare il compilatore;
- ✅ **due difetti VERI trovati eseguendo, e corretti**: (a) il figlio
  `powershell` lanciato **dentro una funzione** faceva finire tutto il suo
  output nel valore di ritorno → *"corsa GATE FERMATA (codice ... 0)"* su una
  corsa andata bene; (b) l'ultima riga del referto era fra **virgolette
  doppie** e PowerShell **interpolava** `$p` e `$pin`, stampando l'ultimo
  problema e il pin al posto dei due nomi;
- ✅ **classe 154 falsificata nei due versi**, con un finto driver generico che
  **esce 1** anche quando va tutto bene (come `metaeditor64` con avvisi):
  (a) codice 1 **+ CSV buono** → corsa `MISURATA`, il codice finisce nei
  RILIEVI, **la riga esce 0**; (b) codice 1 **+ nessun CSV** → `NESSUN CSV
  PRODOTTO`, PROBLEMA, cancello che ferma, **uscita 2**. Il verdetto è
  sull'**artefatto**, non sul codice;
- ✅ **la profondità a TICK è citata dalla misura GIUSTA** — non dal referto
  delle **barre** (classe 153): il driver **riscarica al pin**
  `risultati_archivio/misura_tick/misura_tick_NASUSD.csv` e stampa la riga
  `TICK` così com'è, dichiarando cosa **non** dice.

🟡 **Non verificato, e va detto**: tutto ciò che richiede **MT5 vero** — la
compilazione reale della sonda (qui MetaEditor non esiste: è stato **stubbato**,
e il collaudo del ramo di fallimento è stato fatto su una **copia del driver con
il solo blocco di ricerca del terminale sostituito**, il codice della
compilazione è quello vero riga per riga), il comportamento del tester, la
durata, e **ogni singolo numero del referto**. Il giro a vuoto copre gli
artefatti e la compilazione; **i numeri li può dare solo la corsa**.
