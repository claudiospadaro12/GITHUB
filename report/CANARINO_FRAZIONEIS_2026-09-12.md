# 🐤 IL CANARINO `@FRAZIONEIS` — **IN CODA**, primo della lista, costo zero minuti

**12/09/2026** (sabato) · branch `lavoro` · runner sul VPS: **domenica 03:30**
**Mandato**: mettere in coda **una** riga di canarino che stanotte, da sola,
risponda al `NON COPERTO` del cancello di `@FRAZIONEIS` — *"la catena VERA non e'
stata girata"* — e, nel mandato allargato, fare il **dodicesimo giro di pin** che
la rende raggiungibile.

## 📄 AVVERTENZA SU QUESTO DOCUMENTO
🚫 **Qui dentro NON c'e' nessuna riga di lancio da mandare a Claudio.** Niente da
incollare sul VPS, **nessun terminale MT5 da aprire**. Tutti i blocchi recintati
sono `console`: trascrizioni di comandi girati **da me su questa macchina Linux**
(`pwsh 7.4.6`, `curl`, `git`, `python3`), con la loro uscita vera, oppure `text`
(citazioni di sorgente che sta gia' nel repo). Nessuno dei quattro terminali MT5
(`50503392` · `50504263` · `10105439` · `50504400`) e' stato sfiorato.

---

# 1️⃣ IL RISULTATO IN CINQUE RIGHE

🟢 **IL CANARINO E' IN CODA**, ed e' la **prima riga di corsia ROUND** che il
runner incontra. Costo: `-SoloControllo` ferma il driver prima di MT5 → **zero
passate di tester, zero CSV, zero minuti** sottratti ai round veri.
🟢 **DODICESIMO GIRO DI PIN FATTO**, e sono **esattamente due valori**: `$PIN` e
`$SHA_WALK`. Diff `+87/-2`, e le righe **non-commento** cambiate sono **le due
valorizzazioni e nient'altro** — misurato col diff filtrato, non promesso.
🟢 **I 19 ROUND DI STANOTTE SONO INTATTI**: `diff` byte per byte contro la
versione precedente → **vuoto**. 19/19 ancora a `1445abf8`.
🟢 **I CANCELLI VERI DEL RUNNER PASSANO SULLA MIA RIGA**, eseguiti col **codice
del runner stesso** (non con una mia reimplementazione): `VagliaScript` → *"G1,
G2 e G3 passato"*, corsia **ROUND**; `VagliaArgomenti` → *"G4 passato"*. E i tre
contro-esempi vengono **bocciati**, quindi quel "passa" dice qualcosa.
🔴 **UN FAIL DA DICHIARARE, ED E' UN FALSO FAIL — ma lo scrivo invece di
nasconderlo**: `controlla_riga.py --oggetto riga` su `CODA.txt` da **FAIL con 3
bloccanti**. Da **lo stesso FAIL identico sulla coda NON TOCCATA**. Non e' la mia
modifica: e' l'oggetto sbagliato. Paragrafo 7, con i tre rilievi smontati uno per
uno.

---

# 2️⃣ 🔑 LA SCOPERTA CHE HA CAMBIATO IL MANDATO: I PIN SONO **TRE**, non due

*(Questo paragrafo resta perche' e' la cosa piu' utile trovata oggi. Il mandato
originale nominava due pin; il terzo l'ha scoperto un 404.)*

| # | chi | dove e' scritto | cosa comanda |
|---|---|---|---|
| 1 | **pin di coda** | colonna 1 di `CODA.txt` | **quale versione** di `RIGA_SOTTILE_ROUND.ps1` il runner scarica |
| 2 | **`$SHA_WALK`** | dentro quella versione | l'**impronta** che il driver scaricato deve avere |
| 3 | 🔴 **`$PIN`** | dentro quella versione | **da quale commit** vengono il driver, `RIGA_ROUND_VPS.ps1` **E IL FILE PROVA** |

```text
RIGA_SOTTILE_ROUND.ps1   "Il driver prende il file prova DALLO STESSO $PIN"  (lo dice TRE volte)
RIGA_SOTTILE_ROUND.ps1             "-Pin",$PIN,
RIGA_ROUND_VPS.ps1 r.105   $RawBase = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"
RIGA_ROUND_VPS.ps1 r.592   Scarica ($RawBase + "/backtest_pipeline/walkforward_generico.ps1") $drv
RIGA_ROUND_VPS.ps1 r.600   Scarica ($RawBase + "/backtest_pipeline/prove/" + $Prova) $provaLoc
```

## 🧪 E LA MISURA CHE L'HA SCOPERTO, col suo contro-esempio
```console
CANARINO_FRAZIONEIS_D30EUR.txt @115254dc (pin dell'11o giro) -> HTTP 404   <<< IL FATTO
R128b_bersaglio_D30EUR.txt      @115254dc                    -> HTTP 200   <<< IL CONTRO-ESEMPIO
```
🔴 **Un "404" da solo non dimostra niente** — potrebbe essere il pin sbagliato, la
rete, il nome storto. Il 200 su `R128b`, **stessa URL, stesso pin, stesso
percorso**, dice che a mancare era **solo il mio file**. 👉 **Quindi il 404 era il
PIN**, e il giro di pin non era burocrazia: era la condizione.
📌 **Regola che ne esce, e vale per sempre**: **chi aggiunge un file prova NUOVO
deve fare un giro di pin.** Non "dovrebbe": *deve*, altrimenti il round muore su
un 404 e la notte e' persa. È scritta anche dentro `RIGA_SOTTILE_ROUND.ps1`, nel
blocco del dodicesimo giro, perche' li' la legge chi fara' il tredicesimo.

---

# 3️⃣ 🔧 IL DODICESIMO GIRO DI PIN — due valori, e servono tutti e due

🔓 Fatto sotto **revoca esplicita** del divieto, e **solo** per le due righe
indicate. Il PASS del cancello su quel file **decade sulle righe che ho
cambiato**: il secondo strato (l'agente `controllo-preventivo`) **non e' mio e
non l'ho eseguito** — lo lancia chi coordina, su quello che consegno.

| riga | prima | adesso |
|---|---|---|
| `$PIN` | `115254dc64b2c7ac9493a33b8f5bbc09f814ea1b` | 🔴 **`b7979d82ec9d35c2ef4c9cb94ebcd1126aba2ce8`** |
| `$SHA_WALK` | `BF53EC27...FAF59875` | 🔴 **`15DE7D5F5A342BB3D2DFEFCE8C970AA93C440B25DE136AFC050ED5B66828F1C6`** |
| `$SHA_ROUND` | `348ED533...9D0A315B` | 🟢 **NON TOCCATA** |
| `$MARC_WALK` · `param()` · `function Pulito` | — | 🟢 **NON TOCCATI** |

## 3.a — 🔴 PERCHE' `$SHA_WALK` ANDAVA CAMBIATA ANCHE LEI: **il driver a HEAD non e' quello del pin**
Questo non era nel mandato, e **chi avesse cambiato solo `$PIN` avrebbe perso il
round sull'impronta**.
```console
$ sha256sum backtest_pipeline/walkforward_generico.ps1                    (HEAD)
  15DE7D5F5A342BB3D2DFEFCE8C970AA93C440B25DE136AFC050ED5B66828F1C6
$ git show 115254dc:backtest_pipeline/walkforward_generico.ps1 | sha256sum
  BF53EC27C98316A8F648009BC2B73B9A9ED6A298C02CBB04E62E3530FAF59875
```
🟢 **Ma la differenza e' INNOCUA, e l'ho letta invece di fidarmi.** Il commit
`f14831b` ("classe 271 pagata") cambia **5 righe su 5** e sono **tutte
COMMENTI** — citazioni di numero di riga corrette:
```console
$ git diff 115254dc..HEAD -- <driver> | righe +/- che NON iniziano con '#'
  0          <<<<<< ZERO righe di codice
```
E il driver a HEAD **passa il cancello**: `ASCII puro | compila 0 errori | param
block RICONOSCIUTO | nessun costrutto pwsh-7-only | formati .NET | nessun Parse
senza cultura` → **EXIT 0**.
🔴 **E non ho toccato `walkforward_generico.ps1`**: il suo sha e' inchiodato da
`$SHA_WALK`, un byte e ogni round muore.

## 3.b — 🟢 PERCHE' `$SHA_ROUND` **NON** SI TOCCA — misurato, non assunto
```console
$ Get-FileHash del RIGA_ROUND_VPS.ps1 SCARICATO DA raw al pin nuovo
  348ED5330C18DCD41D736B0709B880A8EC9BF8A4B700B044999BC7099D0A315B
  $SHA_ROUND scritto: 348ED5330C18DCD41D736B0709B880A8EC9BF8A4B700B044999BC7099D0A315B
  COMBACIA          : True
```

## 3.c — 🔒 LA LISTA BIANCA E' INTATTA, E LO DICE IL CANCELLO DA SOLO
```console
$ python3 backtest_pipeline/controlla_riga.py --oggetto ps1 backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1
  PASSATI (6):
    OK   ASCII puro: RIGA_SOTTILE_ROUND.ps1
    OK   compila: 0 errori dal parser PowerShell vero
    OK   param block RICONOSCIUTO (Expert,Prova,Etichetta,Modello,Deposito,SoloControllo)
    OK   nessun costrutto pwsh-7-only
    OK   formati .NET
    OK   nessun Parse decimale senza cultura invariante
  ESITO: nessun difetto meccanico.
$ codice di uscita del cancello ps1: 0
```
🔑 **`param block RICONOSCIUTO (Expert, Prova, Etichetta, Modello, Deposito,
SoloControllo)`** — i **SEI** argomenti firmati l'11/09, **zero aggiunti**.
Nessun perimetro allargato, nessuna firma nuova di Claudio.

## 3.d — 🔬 E CHE IL DIFF SIA DAVVERO SOLO QUELLO, misurato
```console
$ git diff --numstat -- backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1
  87      2
$ git diff ... | righe +/- che NON iniziano con '#'
  -$PIN = '115254dc64b2c7ac9493a33b8f5bbc09f814ea1b'
  +$PIN = 'b7979d82ec9d35c2ef4c9cb94ebcd1126aba2ce8'
  -$SHA_WALK  = 'BF53EC27C98316A8F648009BC2B73B9A9ED6A298C02CBB04E62E3530FAF59875'
  +$SHA_WALK  = '15DE7D5F5A342BB3D2DFEFCE8C970AA93C440B25DE136AFC050ED5B66828F1C6'
```
✅ **Due righe di codice, esattamente le due annunciate.** Le altre 85 sono il
commento del dodicesimo giro, **accanto** agli altri undici — nessun commento
vecchio cancellato.

## 3.e — 📌 CLASSE 271, PAGATA **IN ANTICIPO**
Il difetto trovato oggi sulla toppa stessa: *una citazione `r.N` vale solo
**prima** di se stessa* — inserire un commento sposta tutto cio' che sta sotto.
🟢 **Quindi nel blocco del dodicesimo giro non cito NESSUN numero di riga di quel
file**, e lo scrivo dentro il blocco perche' lo legga chi fara' il tredicesimo.
Cito **file e nomi**, che non si spostano. 🔴 E per la stessa ragione, in **questo
referto** i `r.N` di `RIGA_SOTTILE_ROUND.ps1` li ho **tolti**: dopo il mio
inserimento `$PIN` sta a r.414 e `$SHA_WALK` a r.466, non piu' a 338 e 381 — e
domani potrebbero spostarsi di nuovo.

---

# 4️⃣ 🐤 IL FILE PROVA — l'attesa dichiarata prima, e la prova che discrimina

📄 `backtest_pipeline/prove/CANARINO_FRAZIONEIS_D30EUR.txt` · 217 righe · 8.496 byte
· sha256 `D6D323F97DFDED053CFDE646822D54D81F3BEBD1022D78DE7DFDDBB5C2580F75`

## 4.a — LE TRE USCITE, DICHIARATE PRIMA (e sono dentro il file, non solo qui)

| | cosa stampa il driver | cosa vuol dire |
|---|---|---|
| **USCITA A** | `taglio IS/OOS preso da '@FRAZIONEIS' nel file prova: 0.5`<br>`taglio IS/OOS: FrazioneIS 0.5`<br>**`IS  2024.09.26 - 2025.08.13`**<br>`OOS 2025.08.14 - 2026.06.30` | 🟢 direttiva **ONORATA** nella catena vera → **si apre la coda dei ~20 round** |
| **USCITA B** | `taglio IS/OOS: FrazioneIS 0.4`<br>**`IS  2024.09.26 - 2025.06.09`**<br>`OOS 2025.06.10 - 2026.06.30`<br>e **nessuna** riga `preso da '@FRAZIONEIS'` | 🔴 direttiva **IGNORATA IN SILENZIO** → **si ferma tutto** |
| **USCITA C** | `scarico fallito` / impronta che non torna / `RIFIUTATO` | ⚠️ **catena rotta a monte**: ne' A ne' B, si ripara quello. **Non si conta come risposta** |

🔑 **65 giorni di calendario separano le due date.** Non sono confondibili: e'
questo che rende il canarino una **misura** e non una conferma.

## 4.b — 🟢 E L'ATTESA E' ANCORATA A NUMERI SCRITTI DA QUALCUN ALTRO
```console
$ sed -n '103,104p' backtest_pipeline/prove/R128b_bersaglio_D30EUR.txt
#          IS  2024.09.26 -> 2025.08.13   230 feriali   ~163 ingressi
#          OOS 2025.08.14 -> 2026.06.30   229 feriali   ~162 ingressi
```
✅ **Dice davvero quello.** Aperto e verificato da me, nella sezione dei criteri
di R128b, congelati dall'11/09. 🔴 **E `R128b` NON E' STATO TOCCATO**: `git diff`
su quel file e' vuoto. I criteri si cambiano prima dei numeri, non dopo.

## 4.c — 🔬 LA PROVA, COL DRIVER SCARICATO DA `raw` AL PIN CHE COMANDA
Non col driver dell'albero locale: coi **byte esatti** che la corsia scarica.
```console
########## USCITA A -- il CANARINO ##########
  EXIT DRIVER (senza pipe) = 0
    MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE
    MARCATORE_WALKFORWARD_GENERICO_v6_FRAZIONEIS
    taglio IS/OOS preso da '@FRAZIONEIS' nel file prova: 0.5
    celle per finestra          : 7   ->  14 pass a tick reali in tutto
    taglio IS/OOS: FrazioneIS 0.5
    IS  2024.09.26 - 2025.08.13   (qui si sceglie)
    OOS 2025.08.14 - 2026.06.30   (qui si verifica, e NON si guarda per scegliere)
  === SOLO CONTROLLO: MT5 non e' stato aperto ===
```
✅ **Riga per riga quello che avevo dichiarato prima.**
🟢 **Controllo di appoggio gratis che torna**: `7 celle → 14 pass` e' lo **stesso**
numero che `R128b` dichiara a r.22.

## 4.d — 🧪 IL CONTRO-ESEMPIO CHE RENDE LA PROVA UNA MISURA
**Quale numero produce l'ALTRA spiegazione?** Stesso driver, stesso comando, su
`R128b` che la direttiva **non** ce l'ha:
```console
########## il CONTRO-ESEMPIO -- R128b, SENZA direttiva ##########
  EXIT DRIVER (senza pipe) = 0
    taglio IS/OOS: FrazioneIS 0.4
    IS  2024.09.26 - 2025.06.09
    OOS 2025.06.10 - 2026.06.30
```
✅ **La banda separa i due casi.** Se domani escisse `2025.06.09` sapremmo **con
certezza** che la direttiva e' stata ignorata, perche' quello e' **esattamente** il
numero dell'altra spiegazione.

## 4.e — COSA C'E' DENTRO
```console
$ diff <(sed -n '179,284p' R128b...) <(sed -n '112,217p' CANARINO...)
  89c89
  < InpMagic=779520
  ---
  > InpMagic=779521
```
✅ **Il blocco parametri e' copiato da R128b alla lettera: UNA riga di
differenza**, e la copia e' **dimostrata**, non promessa. `779521` cercato su
tutto il repo: **zero occorrenze** (vergine). Con `-SoloControllo` il magic e'
inerte, ma se un giorno qualcuno lanciasse il file per davvero, col magic di
R128b i deal si mescolerebbero a quelli dell'ancora: **costa zero e toglie una
trappola.**
🔑 **`@FINOA` non c'e', ed e' una scelta**: come R128b, la data di fine viene dal
default del driver (`[string]$Fino = "2026.06.30"`, letto nel sorgente).
Aggiungerla cambierebbe il percorso esercitato, e **le date attese non sarebbero
piu' quelle di R128b**.

---

# 5️⃣ 📋 LA RIGA IN CODA — dov'e', e **perche' li' sui fatti del runner**

## 5.a — LA RIGA
```text
84999392d0a8726fb3f03d8ffb9b0133657e0055 | backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1 | -Expert ABTG_DAX_Apertura_EU -Prova CANARINO_FRAZIONEIS_D30EUR.txt -Etichetta canfrz -Modello 4 -Deposito 10000 -SoloControllo
```
E' **la prima riga di corsia ROUND** del file (r.167), subito dopo le 11 di sola
lettura e **prima** dei 19 round. `-Modello 4` e `-Deposito 10000` sono quelli di
R128b.

## 5.b — 🟢 PERCHE' PRIMA, e non e' un'intuizione
```console
$ sed -n '734,782p' backtest_pipeline/runner_abtg.ps1 | grep -n 'break\|exit\|throw\|return'
  (nessuna riga)     esito grep = 1   ->  ZERO break, ZERO exit, ZERO throw nel corpo del ciclo
```
```text
runner_abtg.ps1 r.739/745/747/753/756/761   ... $rifiutati++ ; continue
runner_abtg.ps1 r.778   if($p.ExitCode -eq 0){ $eseguiti++ } else { $falliti++ ... }   <-- CONTA, non ferma
```
✅ **Ogni via di fallimento e' un `continue`.** I due soli `break` del file (r.310
e r.805) stanno **fuori** dal ciclo della coda.
🟢 **E non esiste nessun tetto** che il canarino possa consumare: nessun limite al
numero di righe, nessun budget di tempo complessivo (`-TimeoutSec 90/120` e' **per
singolo scaricamento**, e `Start-Process -Wait` non ha timeout), e `$nRound` e' un
**contatore per il riepilogo**, non un cancello — non e' confrontato con niente.
👉 Quindi metterlo in testa fa trovare la risposta **all'inizio** del referto
invece che in fondo, e se muore **non ferma i 19 round**. 🔴 **Se il runner
fermasse la coda su una riga morta, sarebbe andato IN FONDO** — 19 round valgono
piu' di una risposta anticipata — **ma non la ferma, e l'ho misurato.**

## 5.c — 🔑 I CANCELLI **VERI** DEL RUNNER, ESEGUITI SUL CANARINO
Non una mia reimplementazione: ho estratto le **definizioni** del runner (r.1-446,
verificato che siano **solo** definizioni — nessuna rete, nessun processo, nessuna
scrittura) e chiamato le sue funzioni sulla **copia congelata scaricata da `raw`
al pin di coda**:
```console
########## I CANCELLI VERI DEL RUNNER, SUL MIO CANARINO ##########
  VagliaScript    ok     : True
  VagliaScript    corsia : ROUND
  VagliaScript    motivo : G1, G2 e G3 passato: bersaglio dichiarato e coerente
  VagliaArgomenti ok     : True
  VagliaArgomenti motivo : G4 passato

########## CONTRO-ESEMPI: i cancelli VERI sanno bocciare? ##########
  esca 1 (C:\BCM_Reale)   ok=False   G4: gli argomenti contengono 'BCM_Reale' -- tocca il terminale del CONTO REALE
  esca 2 (conto 100k)     ok=False   G4: gli argomenti contengono '50504263' -- nomina il conto 100k, che ha POSIZIONI VIVE
  esca 3 (marcatore via)  ok=False   G1: manca il marcatore 'RUNNER_SOLA_LETTURA' oppure 'RUNNER_ROUND_BACKTEST'
```
✅ **G1, G2, G3, G4: tutti passati dal codice vero.** 🟢 **E le tre esche vengono
bocciate**, quindi quel "passa" dice qualcosa. Questo e' il PASS che conta, e vale
piu' di qualunque mio script.

## 5.d — 🔬 E IL FORMATO DELLA RIGA, provato come lo prova il runner
```console
  campi trovati : 3                      (il runner pretende >= 2)
  pin      -> ^[0-9a-f]{40}$                                          True
  percorso -> ^backtest_pipeline/righe/[A-Za-z0-9_.-]+\.ps1$          True
  Pulito(ABTG_DAX_Apertura_EU) / (CANARINO_FRAZIONEIS_D30EUR.txt) / (canfrz)  True
  -Modello 4 in 0..4   True     -Deposito 10000 > 0   True     -SoloControllo presente   True
  G4 -- divieti applicabili in corsia ROUND : 33
  G4 -- divieti COLPITI                     : NESSUNO
  G4 -- percorsi X:\ negli argomenti        : NESSUNO
  CONTRO-ESEMPIO (pin tagliato a 8 cifre) -> False
```

---

# 6️⃣ 🔴 I 19 ROUND — INTATTI, e stavolta **verificato dopo** aver scritto

```console
$ grep -v '^#' CODA.txt | grep RIGA_SOTTILE_ROUND | awk '{print $1}' | sort | uniq -c
     19 1445abf80666883ea2f6a4ecb983e91a2eb26834      <<< 19 su 19
      1 84999392d0a8726fb3f03d8ffb9b0133657e0055      <<< il canarino

$ righe eseguibili totali: 31        (erano 30: 19 round + 11 lettura, + 1 canarino)

$ diff <(git show HEAD:CODA.txt | grep '^1445abf8') <(grep '^1445abf8' CODA.txt)
  (vuoto)   ->  LE 19 RIGHE SONO IDENTICHE BYTE PER BYTE

$ diff <(...le 11 righe CODA_* di prima...) <(...quelle di adesso...)
  (vuoto)   ->  ANCHE LE 11 DI SOLA LETTURA SONO IDENTICHE
```
✅ **Pin, argomenti e ordine delle 19: invariati, dimostrato con `diff`** e non
per costruzione (stavolta il file l'ho toccato, quindi la verifica serve davvero).
🟢 **E le loro catene restano indipendenti dalla mia**: scaricano
`RIGA_SOTTILE_ROUND.ps1` dalla **copia congelata** a `1445abf8`, che porta il
**suo** `$PIN = e6c0d70e` e il **suo** `$SHA_WALK = 62A53763...`. Il mio giro di
pin **non le raggiunge**.

---

# 7️⃣ 🚦 I CANCELLI — e il **FAIL** che dichiaro invece di nasconderlo

## 7.a — QUELLO CHE PASSA, da solo e senza pipe (classe 254)
```console
$ python3 backtest_pipeline/controlla_prova.py backtest_pipeline/prove/CANARINO_FRAZIONEIS_D30EUR.txt
  CANARINO_FRAZIONEIS_D30EUR.txt   ABTG_DAX_Apertura_EU.mq5   pin=81  celle= 7  OK
  file: 1 | celle totali: 7 | passate (celle x 2 finestre): 14 | problemi: 0
  ESITO: OK                                                              EXIT = 0

$ python3 backtest_pipeline/controlla_riga.py --oggetto prova backtest_pipeline/prove/CANARINO_FRAZIONEIS_D30EUR.txt
  OK   file prova ASCII puro                                             EXIT = 0

$ python3 backtest_pipeline/controlla_riga.py --oggetto ps1 backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1
  PASSATI (6), param block RICONOSCIUTO (i sei argomenti firmati)        EXIT = 0

$ python3 backtest_pipeline/controlla_riga.py --oggetto md report/CANARINO_FRAZIONEIS_2026-09-12.md
  ESITO: nessun difetto meccanico.                                       EXIT = 0
```
✅ Lanciati **da soli**, l'output **letto**, e i commit fatti in comandi
**separati**. Nessuna pipe che potesse mangiarsi un codice d'uscita.

## 7.b — 🔴 IL FAIL: `controlla_riga.py --oggetto riga` SU `CODA.txt`
```console
$ python3 backtest_pipeline/controlla_riga.py --oggetto riga backtest_pipeline/coda/CODA.txt
  BLOCCANTI (3):
    X [ASCII] la riga di lancio contiene caratteri non-ASCII (emoji?)
    X [PIN] nessun pin trovato nella riga: la riga deve puntare a un COMMIT, non a un branch
    X [MARCATORE] la riga non verifica il MARCATORE dello script scaricato
  ESITO: FAIL -- la riga NON si manda a Claudio.                          EXIT = 1
```

### 🧪 IL CONTRO-ESEMPIO CHE LO SMONTA: **lo stesso FAIL sulla coda NON TOCCATA**
```console
$ git show HEAD:backtest_pipeline/coda/CODA.txt > CODA_PRIMA.txt
$ python3 backtest_pipeline/controlla_riga.py --oggetto riga CODA_PRIMA.txt
  BLOCCANTI (3):  [ASCII]  [PIN]  [MARCATORE]     <-- IDENTICI, gli stessi tre
  ESITO: FAIL                                                             EXIT = 1
```
🔴 **Identico sulla coda collaudata, quella i cui 19 round partono stanotte.**
Quindi **non e' la mia modifica**: e' l'**oggetto sbagliato**. `--oggetto riga`
controlla *"una riga di lancio da incollare in PowerShell"*; `CODA.txt` e' un
**manifesto** che il runner **scarica** e legge riga per riga. Il cancello **non
ha un `--oggetto coda`**.

### E i tre rilievi, smontati **uno per uno con una misura** (non con un ragionamento)
| rilievo | la misura | perche' e' falso per questo oggetto |
|---|---|---|
| **[PIN]** *"nessun pin trovato"* | `31` pin, tutti `^[0-9a-f]{40}$`; righe eseguibili **senza** pin valido: **0** | cerca il pin nella URL di un `irm`; qui i pin stanno in **colonna 1**, e li valida il runner (r.745) |
| **[MARCATORE]** *"non verifica il marcatore"* | il marcatore lo controllano il **runner** (G1, r.386-387) e `RIGA_SOTTILE_ROUND.ps1` (`Prendi ... $SHA_WALK $MARC_WALK`, r.604-605) | `CODA.txt` non scarica niente: e' un elenco, non uno script |
| **[ASCII]** *"puo' rompersi in PowerShell 5.1"* | byte >127 **prima: 30 · adesso: 30 · delta mio: 0**; e **tutte** su righe che iniziano con `#` | il runner **salta i commenti** (r.730) e `CODA.txt` arriva via `Invoke-WebRequest` (r.722-724): **non viene mai incollata a mano** |

🟢 **E il PASS che conta l'ho preso comunque, col codice vero** (paragrafo 5.c):
`VagliaScript` → G1/G2/G3, `VagliaArgomenti` → G4, con tre contro-esempi bocciati.
📌 **CLASSE NUOVA per `CHECKLIST_RIGA_DI_LANCIO.md`** (non la scrivo io: quel file
e' in mano a un altro agente, e non tocco un file di qualcun altro):
> *«`controlla_riga.py` non ha un `--oggetto coda`. Passare `backtest_pipeline/coda/CODA.txt` come `--oggetto riga` produce un FAIL con 3 bloccanti ([ASCII], [PIN], [MARCATORE]) che sono **tutti e tre falsi** per quell'oggetto: il FAIL e' identico sulla coda non modificata. Il cancello vero della coda sono le funzioni `VagliaScript`/`VagliaArgomenti` del runner, che si possono eseguire estraendo le sole definizioni (r.1-446). Misurato il 12/09/2026.»*

## 7.c — 🔤 ASCII, contato con `python3` (non con `grep`, che e' rotto)
```console
RIGA_SOTTILE_ROUND.ps1 : 40621 byte, byte >127 = 0
CODA.txt               : byte >127 prima 30, adesso 30, DELTA MIO = 0   (tutte su righe '#')
CANARINO_...D30EUR.txt : 8496 byte,  byte >127 = 0
CONTRO-ESEMPIO (esca con accento + emoji): byte >127 = 6  -> il contatore distingue
```
✅ `RIGA_SOTTILE_ROUND.ps1` e il file prova sono **ASCII puro**. 🟢 **E il
contatore l'ho provato contro se stesso**: un controllo che non puo' fallire non
e' un controllo.

---

# 8️⃣ 📖 COME SI LEGGE IL REFERTO DOMATTINA — **il canarino ADESSO C'E'**

## 🐤 CERCALO. E' LA PRIMA RIGA DI ROUND DEL REFERTO.
Nel referto del runner si cerca la sezione della riga con **`-Etichetta canfrz`**
(o la stringa `CANARINO_FRAZIONEIS`), e **UNA SOLA STRINGA DECIDE**:

| cerca questo | verdetto | cosa si fa |
|---|---|---|
| **`IS  2024.09.26 - 2025.08.13`** | 🟢 **USCITA A — direttiva ONORATA** | **SI APRE LA CODA.** Si fanno le ~21 edit da una riga ai file prova che dichiarano il taglio 0.50, **R128b in testa**, piu' `@FRAZIONEIS 0.40` esplicito su `R128a`. Conferma di appoggio nella stessa uscita: `taglio IS/OOS preso da '@FRAZIONEIS' nel file prova: 0.5` |
| **`IS  2024.09.26 - 2025.06.09`** | 🔴 **USCITA B — direttiva IGNORATA IN SILENZIO** | 🛑 **SI FERMA TUTTO.** Non si mette in coda **nessun** round a 0.50: girerebbe a 0.40 credendo di girare a 0.50, e i suoi numeri non sarebbero usabili da nessuno. Si cerca il guasto fra `$PIN`, `$SHA_WALK` e il file scaricato |
| **`scarico fallito`** · **impronta che non torna** · **`RIFIUTATO`** | ⚠️ **USCITA C — catena rotta a monte** | Ne' A ne' B: si legge il messaggio e si ripara **quello**. 🔴 **Non va contata come risposta**: la domanda resta aperta |

## 🔑 IL CONTROLLO DI APPOGGIO, gratis e obbligatorio
La stessa uscita deve portare **`celle per finestra : 7 -> 14 pass`**. Se il numero
e' diverso, **il file prova scaricato non e' questo** e nessuna delle tre righe
sopra vale.

## ✅ E COME SI RICONOSCE CHE E' GIRATO A COSTO ZERO
Deve comparire **`=== SOLO CONTROLLO: MT5 non e' stato aperto ===`** (o
`GIRO A VUOTO (-SoloControllo)`). Se **non** c'e', qualcuno ha lanciato il file
senza `-SoloControllo`: 14 passate a tick reali per una risposta che stava nelle
due righe di finestra. Non e' un danno, e' tempo macchina buttato — **e va detto**.

## 🧭 E IL RESTO DEL REFERTO, come sempre
I 19 round: `ESITO:`, `eseguiti` / `rifiutati` / `falliti`, e i due cancelli di
determinismo — **`r127c`** (n = 394 +/-2%, PF 1,41 +/-0,03) e **`r136a`** (IS 237
deal / PF 1,20110 / DD 5,7325% · OOS 517 / 1,52365 / 7,8323%). 🔴 Se `r136a` non
riproduce, **il primo sospetto e' il binario, non i parametri.**

---

# 9️⃣ 🔴 COSA RESTA **NON MISURATO** — detto per intero

1. 🔴 **`[NON MISURATO]` LA CATENA VERA — ed e' proprio la cosa che il canarino
   va a misurare.** Fino a stanotte il `NON COPERTO` resta aperto. Le mie prove
   girano su Linux **col driver scaricato da `raw` al pin giusto** (quindi i byte
   sono quelli veri), ma **non** attraversano `RIGA_SOTTILE_ROUND` →
   `RIGA_ROUND_VPS` → controllo d'impronta → MT5 → compilazione. **Quella
   risposta ce l'avremo domattina, non prima.**
2. 🔴 **`[NON MISURATO]` IL SECONDO STRATO DEL CANCELLO.** La regola del 09/09
   vuole **due** strati. Il deterministico e' passato su tutto (EXIT 0, senza
   pipe). L'agente **`controllo-preventivo`** 🔴 **non e' stato invocato: in
   questa sessione non ho uno strumento per lanciare un sottoagente.** Il
   coordinatore ha dichiarato che lo lancia lui su questa consegna. 🔴 **E va
   detto che stavolta qualcosa E' USCITO**: `CODA.txt` e' modificata e il runner
   la leggera' stanotte. Quindi **il PASS del secondo strato non e' una
   formalita': e' la condizione perche' questa riga sia legittima.** Se non
   arrivasse in tempo, la riga si toglie — e' una riga sola, e togliere una riga
   costa meno di girare senza PASS.
3. 🔴 **`[NON MISURATO]` l'esecuzione su Windows PowerShell 5.1.** Qui gira
   `pwsh 7.4.6`; il VPS ha la 5.1. `RIGA_SOTTILE_ROUND.ps1` e il file prova sono
   **ASCII puro verificato** (quindi il difetto del 17/08 non li tocca) e il
   cancello dice *"nessun costrutto pwsh-7-only"*, ma il driver con
   `@FRAZIONEIS` sotto 5.1 **non l'ha provato nessuno**. Ereditato dal referto di
   `@FRAZIONEIS`, punto 8 — non chiuso da me.
4. 🔴 **`[NON MISURATO]` il PASS di `RIGA_SOTTILE_ROUND.ps1` come file intero.**
   Il divieto e' stato revocato **per due righe**, e il PASS precedente **decade
   su quelle due**. Il deterministico ripassa a 0 su tutto il file, ma il
   giudizio sul giro di pin **non e' mio**.
5. ⚠️ **`[NON MISURATO]` i ~163 / ~162 ingressi.** Il canarino verifica che il
   driver **tagli** al 2025.08.13, **non** che in quella finestra ci siano 163
   ingressi. Quel numero viene da **una sola** misura (i 325 di R120, margine
   **+8%** sul pavimento di 150). Se quei 325 fossero sbagliati, cadono tutti e
   venti i round insieme. **Non e' un motivo per non lanciare: e' un motivo per
   non arrotondare mai quel numero.**
6. ⚠️ **`@FRAZIONEIS` non e' ancora in nessuno degli altri ~20 file prova**, e
   **non deve esserci finche' non c'e' l'USCITA A.** Le 21 edit da una riga
   restano da fare **dopo**, non prima.
7. ⚠️ **Il buco del parser su `@FINOA` resta APERTO** (una riga `@FINOA` senza
   valore passa liscia, exit 0, nessun avviso). Ereditato, dichiarato, non mio.
8. ⚠️ **La classe nuova del paragrafo 7.b non e' in
   `CHECKLIST_RIGA_DI_LANCIO.md`**: il testo e' pronto li', ma quel file e' in
   mano a un altro agente. **Va aggiunta.**

---

# 🔟 🎯 DOVE SIAMO, DA SOCIO

🟢 **Il canarino e' in coda, primo della lista, e costa zero minuti.** Domattina
si cerca **una stringa sola** e si sa se ~20 round sulla sedia del DAX possono
partire. Questo era il collo di bottiglia, e da stanotte non lo e' piu'.
🟢 **E il giro di pin e' uscito piu' solido di come e' entrato**: due righe
cambiate, dimostrate col diff filtrato; la lista bianca dei sei argomenti
**intatta**; e la regola nuova — *"chi aggiunge un file prova nuovo fa un giro di
pin"* — scritta **dentro il file**, dove la leggera' chi fara' il tredicesimo giro.
🟢 **Tre trappole disinnescate prima che costassero una notte**: il terzo pin
(trovato da un 404), il driver a HEAD diverso da quello al pin (chi cambiava solo
`$PIN` perdeva il round), e la classe 271 pagata in anticipo sui numeri di riga.
🟢 **E una bugia piccola corretta**: `CODA.txt` diceva *"24 divieti"*, **sono 33**,
contati sul sorgente. Nessuno li conta a mano — li applica il codice — ma chi
legge quel file di notte si fidava di un numero sbagliato.
🔴 **E resta PONTEGGIO.** Non ho prodotto **nemmeno una misura di mercato**. Vale
perche' senza quella risposta i venti round nascono sbagliati, e a tre settimane
da ottobre un round che gira a 0.40 credendo di girare a 0.50 e' **una notte
buttata E un numero che nessuno puo' usare**.

**Il prossimo passo e' domattina, e sono due minuti di lettura**: cerca
`canfrz`, leggi la riga `IS`, e la coda dei venti si apre o si ferma. 💪
