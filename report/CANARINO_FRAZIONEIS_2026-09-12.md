# 🐤 IL CANARINO `@FRAZIONEIS` — il file e' pronto e PROVATO, ma **NON L'HO MESSO IN CODA**: la corsia non puo' vederlo

**12/09/2026** (sabato) · branch `lavoro` · runner sul VPS: **domenica 03:30**
**Mandato**: mettere in `backtest_pipeline/coda/CODA.txt` **una** riga di canarino
che stanotte, da sola, risponda al `NON COPERTO` del cancello di `@FRAZIONEIS`:
*"la catena VERA non e' stata girata"*.

## 📄 AVVERTENZA SU QUESTO DOCUMENTO
🚫 **Qui dentro NON c'e' nessuna riga di lancio da mandare a Claudio.** Niente da
incollare sul VPS, **nessun terminale MT5 da aprire**. Tutti i blocchi recintati
sono `console`: trascrizioni di comandi girati **da me su questa macchina Linux**
(`pwsh 7.4.6`, `curl`, `git`, `python3`), con la loro uscita vera. Nessuno dei
quattro terminali MT5 (`50503392` · `50504263` · `10105439` · `50504400`) e'
stato sfiorato: `-SoloControllo` si ferma **prima** di aprire MT5, e comunque
girava su Linux.

---

# 1️⃣ IL RISULTATO IN QUATTRO RIGHE

🟢 **IL CANARINO ESISTE, PASSA I CANCELLI, E FUNZIONA**: provato col **driver
scaricato da `raw` al pin che comanda**, stampa `IS 2024.09.26 - 2025.08.13`.
🟢 **E DISCRIMINA**: lo **stesso** driver, sullo **stesso** comando, su `R128b`
(che non ha la direttiva) stampa `IS 2024.09.26 - 2025.06.09`. Due uscite
diverse e non confondibili: e' una misura, non una conferma.
🔴 **MA LA RIGA IN CODA NON C'E', E NON DOVEVA ESSERCI.** Il file prova che la
corsia scarica **non viene dal pin di coda**: viene da `$PIN` **dentro**
`RIGA_SOTTILE_ROUND.ps1`, cioe' `115254dc`, un commit di **stamattina**. Un file
creato **adesso** a quel pin **non esiste**: `HTTP 404`. Misurato, non dedotto.
🟢 **E i 19 round di stanotte sono INTATTI**: `CODA.txt` non l'ho toccata di un
byte.

---

# 2️⃣ 🔴 IL FATTO CHE BLOCCA — e la catena percorsa fino in fondo

## 2.a — I PIN SONO **TRE**, non due. E quello che serviva al canarino e' il terzo.

Il mandato diceva, giustamente, che il pin di coda **non** decide il driver.
Vero. Ma ne mancava uno: **decide nemmeno il FILE PROVA**.

| # | chi | dove e' scritto | cosa comanda |
|---|---|---|---|
| 1 | **pin di coda** (`1445abf8`) | colonna 1 di `CODA.txt` | **quale versione** di `RIGA_SOTTILE_ROUND.ps1` il runner scarica |
| 2 | **`$SHA_WALK`** | dentro quella versione | l'**impronta** che il driver scaricato deve avere |
| 3 | 🔴 **`$PIN`** | dentro quella versione (r.338) | **da quale commit** vengono il driver, `RIGA_ROUND_VPS.ps1` **E IL FILE PROVA** |

La sorgente, alla lettera, e non parafrasata:

```text
RIGA_SOTTILE_ROUND.ps1 r.170 (e r.191, e r.262 -- lo dice TRE volte)
#  Il driver prende il file prova DALLO STESSO $PIN (-Pin qui sotto):
RIGA_SOTTILE_ROUND.ps1 r.539
          "-Pin",$PIN,
RIGA_ROUND_VPS.ps1 r.105
$RawBase  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"
RIGA_ROUND_VPS.ps1 r.600
Scarica ($RawBase + "/backtest_pipeline/prove/" + $Prova) $provaLoc
```

## 2.b — E LA MISURA CHE CHIUDE LA QUESTIONE

```console
$ B=https://raw.githubusercontent.com/claudiospadaro12/GITHUB
$ P=115254dc64b2c7ac9493a33b8f5bbc09f814ea1b     # il $PIN di RIGA_SOTTILE_ROUND a HEAD

CANARINO_FRAZIONEIS_D30EUR.txt @115254dc -> HTTP 404      <<<<<< IL FATTO
R128b_bersaglio_D30EUR.txt      @115254dc -> HTTP 200
```

🔴 **404.** E non e' un problema di rete: `115254dc` e' il commit
`@FRAZIONEIS: il giro chiuso` di stamattina alle **12:37**, cioe' **prima** che
questo file esistesse. Un commit e' immutabile: **nessun file nuovo puo'
comparire dentro un commit passato.** Non e' una difficolta', e' un'impossibilita'.

## 2.c — 🧪 IL CONTRO-ESEMPIO: il test sa distinguere i due casi

Un "404" da solo non dimostra niente — potrebbe essere il pin sbagliato, la rete,
il nome storto. Quindi l'ho provato **contro l'altra spiegazione**, con la stessa
URL e lo stesso pin: `R128b`, che **a quel pin c'e'**, risponde **200**. 👉 Il pin
e' giusto, la rete funziona, il percorso e' quello vero: a mancare e' **solo** il
mio file. **Il controllo distingue, quindi il suo "404" dice qualcosa.**

## 2.d — E COSA SAREBBE ACCADUTO SE L'AVESSI MESSA IN CODA (letto nel codice)

```text
RIGA_ROUND_VPS.ps1 r.583-588
function Scarica($url,$dst){
  ...
  catch{ Muori ("scarico fallito: " + $url + " -- " + $_.Exception.Message) }
```

🟢 **Sarebbe morta RUMOROSA, non in silenzio** — il modo giusto di rompersi, e
zero danno per gli altri round. 🔴 **Ma il referto di domattina avrebbe portato
un "RIFIUTATO/fallito" su una riga di collaudo, e ZERO risposta alla domanda per
cui il canarino esiste.** Una riga che muore su un 404 non dice ne' A ne' B: dice
"non misurato", esattamente la cosa che dovevamo togliere di mezzo.

---

# 3️⃣ 🟢 IL FILE PROVA — c'e', ed e' PROVATO CONTRO IL DRIVER VERO

📄 `backtest_pipeline/prove/CANARINO_FRAZIONEIS_D30EUR.txt` · 217 righe · 8.496 byte

## 3.a — L'ATTESA, DICHIARATA PRIMA (ed e' dentro il file, non solo qui)

| | cosa stampa il driver | cosa vuol dire |
|---|---|---|
| **USCITA A** | `taglio IS/OOS preso da '@FRAZIONEIS' nel file prova: 0.5`<br>`taglio IS/OOS: FrazioneIS 0.5`<br>**`IS 2024.09.26 - 2025.08.13`**<br>`OOS 2025.08.14 - 2026.06.30` | 🟢 direttiva **ONORATA** nella catena vera → **si apre la coda dei ~20 round** |
| **USCITA B** | `taglio IS/OOS: FrazioneIS 0.4`<br>**`IS 2024.09.26 - 2025.06.09`**<br>`OOS 2025.06.10 - 2026.06.30`<br>e **nessuna** riga `preso da '@FRAZIONEIS'` | 🔴 direttiva **IGNORATA IN SILENZIO** → **si ferma tutto** |
| **USCITA C** | muore prima delle finestre (scarico, impronta, compilazione) | ⚠️ **catena rotta a monte**: non e' ne' A ne' B, si ripara quello |

🔑 **65 giorni di calendario separano le due date.** Non sono confondibili: e'
questo che rende il canarino falsificabile invece che decorativo.

## 3.b — 🟢 E L'ATTESA E' ANCORATA A NUMERI SCRITTI DA QUALCUN ALTRO
Non ai miei. Ho aperto il file e verificato io, come chiesto:

```console
$ sed -n '103,104p' backtest_pipeline/prove/R128b_bersaglio_D30EUR.txt
#          IS  2024.09.26 -> 2025.08.13   230 feriali   ~163 ingressi
#          OOS 2025.08.14 -> 2026.06.30   229 feriali   ~162 ingressi
```
✅ **Dice davvero quello.** Identiche al giorno, nella sezione dei criteri di
R128b, congelate dall'11/09.

## 3.c — 🔬 LA PROVA, COL DRIVER SCARICATO DA `raw` AL PIN CHE COMANDA
Non col driver dell'albero locale: con **i byte esatti** che la corsia scarica.

```console
$ curl "$B/$P/backtest_pipeline/walkforward_generico.ps1" -o drv.ps1
  HTTP 200   byte 102955
$ sha256sum drv.ps1
  BF53EC27C98316A8F648009BC2B73B9A9ED6A298C02CBB04E62E3530FAF59875   == $SHA_WALK ✅

########## USCITA A -- il CANARINO ##########
$ pwsh -NoProfile -File drv.ps1 -Expert ABTG_DAX_Apertura_EU \
        -Prova <...>/CANARINO_FRAZIONEIS_D30EUR.txt -Etichetta canfrz \
        -Modello 4 -Deposito 10000 -Rifai -Force -SoloControllo
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

✅ **Riga per riga quello che avevo dichiarato prima**, `@FRAZIONEIS` compresa.
🟢 **E un controllo gratis in piu' che torna**: `7 celle -> 14 pass` e' lo
**stesso** numero che `R128b` dichiara a r.22 (*"-SoloControllo deve stampare 7
celle per finestra"*). Se stampasse un numero diverso, il file scaricato non
sarebbe questo.

## 3.d — 🧪 IL CONTRO-ESEMPIO CHE RENDE LA PROVA UNA MISURA
«Con la direttiva esce 2025.08.13» da solo non dice niente. **Quale numero
produce l'ALTRA spiegazione?** Stesso driver, stesso comando, su `R128b` che la
direttiva **non** ce l'ha:

```console
########## il CONTRO-ESEMPIO -- R128b, SENZA direttiva ##########
  EXIT DRIVER (senza pipe) = 0
    celle per finestra          : 7   ->  14 pass
    taglio IS/OOS: FrazioneIS 0.4
    IS  2024.09.26 - 2025.06.09
    OOS 2025.06.10 - 2026.06.30
```
✅ **La banda separa i due casi.** Se il canarino domani stampasse `2025.06.09`
sapremmo **con certezza** che la direttiva e' stata ignorata, perche' quello e'
esattamente il numero che produce l'altra spiegazione. La proprieta' che il
mandato chiedeva di conservare **e' conservata e provata**, non asserita.

## 3.e — COSA C'E' DENTRO, E COSA **NON** HO TOCCATO

🔴 **`R128b_bersaglio_D30EUR.txt` NON E' STATO TOCCATO.** Verificato: `git diff`
su quel file e' vuoto. I criteri si cambiano prima dei numeri, non dopo.

- **Il blocco parametri e' copiato da R128b ALLA LETTERA** (r.179-284), e la
  copia e' **dimostrata**, non promessa:
  ```console
  $ diff <(sed -n '179,284p' R128b...) <(sed -n '112,217p' CANARINO...)
  89c89
  < InpMagic=779520
  ---
  > InpMagic=779521
  ```
  ✅ **Una riga di differenza, e una sola.** `InpMagic=779521` cercato su tutto il
  repo: **zero occorrenze**, quindi vergine. Perche' cambiarlo: con
  `-SoloControllo` il magic e' inerte (nessun ordine, nessun CSV), ma se un
  giorno qualcuno lanciasse questo file per davvero, col magic di R128b i deal
  finirebbero mescolati a quelli dell'ancora. **Costa zero e toglie una trappola.**
- **Le direttive sono quelle di R128b, piu' una**: `@SIMBOLO D30EUR`,
  `@PERIODO M5`, `@DAQUANDO 2024.09.26`, **`@FRAZIONEIS 0.50`**.
- 🔑 **`@FINOA` NON c'e', ed e' una scelta, non una dimenticanza.** Come R128b,
  la data di fine viene dal **default del driver**, verificato nel sorgente e non
  assunto: `walkforward_generico.ps1 r.177  [string]$Fino = "2026.06.30"`.
  Aggiungerla avrebbe cambiato il percorso di codice esercitato e la riga
  stampata. **La coerenza con R128b si tiene alla lettera**, altrimenti le due
  date attese non sono piu' le sue e il canarino non misura piu' niente.
- **In testa c'e' il blocco richiesto**: che e' un CANARINO di collaudo e **non**
  produce nessun verdetto di mercato; l'attesa dichiarata prima con le **tre**
  uscite; e che gira con `-SoloControllo`, quindi **il tester non gira**.

---

# 4️⃣ 🚦 I CANCELLI — da soli, senza pipe (classe 254)

```console
$ python3 backtest_pipeline/controlla_prova.py backtest_pipeline/prove/CANARINO_FRAZIONEIS_D30EUR.txt
  CANARINO_FRAZIONEIS_D30EUR.txt   ABTG_DAX_Apertura_EU.mq5   pin=81  celle= 7  OK
  file: 1 | celle totali: 7 | passate (celle x 2 finestre): 14 | problemi: 0
  ESITO: OK                                                        EXIT = 0

$ python3 backtest_pipeline/controlla_riga.py --oggetto prova backtest_pipeline/prove/CANARINO_FRAZIONEIS_D30EUR.txt
  OK   file prova ASCII puro: CANARINO_FRAZIONEIS_D30EUR.txt
  ~ [225] controlli PowerShell SPENTI su questo oggetto (non e' uno script) -- rilievo, non blocca
  ESITO: nessun difetto meccanico.                                 EXIT = 0
```
✅ **EXIT 0 su entrambi, lanciati da soli**, l'output letto, e il commit fatto in
un comando **separato**. Nessuna pipe che potesse mangiarsi un codice d'uscita.

## 🔤 ASCII PURO — contato con `python3`, non con `grep`
Il mandato avvisava che `grep '[^\x00-\x7F]'` **non funziona** (GNU grep in BRE
non espande `\x`). Quindi:

```console
$ python3 -c "...conta i byte >127..."
  CANARINO_FRAZIONEIS_D30EUR.txt: 8496 byte totali, byte >127 = 0
  CONTRO-ESEMPIO (esca con accento+emoji): byte >127 = 6  -> il test distingue
```
✅ **Zero byte non-ASCII.** 🟢 **E il contatore l'ho provato contro se stesso**
con un'esca: se ci fossero emoji o accenti, li troverebbe. **Un controllo che non
puo' fallire non e' un controllo.**

---

# 5️⃣ 🔴 I 19 ROUND DI STANOTTE — INTATTI, e non per promessa

Il vincolo numero uno. `CODA.txt` **non e' stata aperta in scrittura**:

```console
$ git diff --stat -- backtest_pipeline/coda/CODA.txt
  (vuoto = NON toccata)

$ grep -v '^#' CODA.txt | grep RIGA_SOTTILE_ROUND | awk '{print $1}' | sort | uniq -c
     19 1445abf80666883ea2f6a4ecb983e91a2eb26834        <<< 19 su 19, un pin solo

$ righe eseguibili totali: 30      (19 round + 11 di sola lettura)
```
✅ **19/19 a `1445abf8`.** Pin, argomenti, ordine: invariati per **costruzione**,
non per verifica — non ho scritto in quel file.

🟢 **E la catena della coda e' sana, ripercorsa da `raw` come la percorre il
runner:**
```console
$ RIGA_SOTTILE_ROUND.ps1 @1445abf8 -> HTTP 200  byte 30541
  r.275  $PIN       = 'e6c0d70ef3bf61efd110ab4c9e7ee46e6ad40e7b'
  r.305  $SHA_WALK  = '62A53763A186195DBE3FB3DAEE01B45A53B80F09BDC831B68046BD50F7CBB7BC'
  r.294  $SHA_ROUND = '348ED5330C18DCD41D736B0709B880A8EC9BF8A4B700B044999BC7099D0A315B'
```
I 19 round scaricano il driver **senza** `@FRAZIONEIS` (`62A53763`), come sono
stati collaudati. **La mia consegna e' invisibile per loro.**

---

# 6️⃣ 🗺️ DOVE ANDREBBE LA RIGA, E **PERCHE' SUI FATTI DEL RUNNER**

Il mandato chiedeva di deciderlo leggendo il runner, non a intuito. L'ho letto:
`backtest_pipeline/runner_abtg.ps1` — 📌 **non** `backtest_pipeline/righe/`, dove
il mandato lo cercava: il runner sta **un livello sopra**, e non potrebbe stare
li' dentro (il runner stesso pretende che ogni riga di coda sia **in**
`backtest_pipeline/righe/`, r.746).

## 6.a — 🟢 UNA RIGA CHE MUORE **NON** FERMA LE SUCCESSIVE. Misurato nel codice.

```text
runner_abtg.ps1 r.734   foreach($riga in $righe){
r.739  if($parti.Count -lt 2){ $rifiutati++; ...; continue }
r.745  if($pin -notmatch '^[0-9a-f]{40}$'){ $rifiutati++; ...; continue }
r.747  RIFIUTATO: percorso fuori da backtest_pipeline/righe/       ...; continue
r.753  catch { $rifiutati++; ... scarico fallito ...;               continue }
r.756  if(-not $v.ok){  $rifiutati++; ...;                          continue }
r.761  if(-not $va.ok){ $rifiutati++; ...;                          continue }
r.778  if($p.ExitCode -eq 0){ $eseguiti++ } else { $falliti++ ... }   <-- CONTA, non ferma
```
✅ **Ogni via di fallimento e' un `continue`.** E che dentro il ciclo non ci sia
nessuna uscita anticipata **l'ho misurato sul corpo del ciclo**, non guardato di
sfuggita:

```console
$ sed -n '734,782p' backtest_pipeline/runner_abtg.ps1 | grep -n 'break\|exit\|throw\|return'
  (nessuna riga)     esito grep = 1   ->  ZERO break, ZERO exit, ZERO throw
```
🟢 I due soli `break` del file stanno a r.310 e r.805, cioe' **fuori** dal ciclo
della coda (dentro le funzioni di analisi e nella ricerca del token). E un
fallimento di esecuzione (`$p.ExitCode -ne 0`, r.778) incrementa `$falliti` e
**passa alla riga dopo**.

## 6.b — 🟢 E NON ESISTE NESSUN TETTO che il canarino potrebbe consumare
Cercato, e dichiarato perche' e' una domanda del mandato:
- **nessun limite al numero di righe**: il `foreach` gira su tutte;
- **nessun budget di tempo complessivo**: il solo `-TimeoutSec 90/120` e' **per
  singolo scaricamento**, e `Start-Process -Wait` non ha timeout;
- **nessun tetto sui round**: `$nRound` (r.765) e' un **contatore per il
  riepilogo**, non un cancello — non e' confrontato con niente.

👉 **CONCLUSIONE: la riga andrebbe PRIMA dei 19 round** (subito dopo le 11 di
sola lettura, come prima riga del blocco round). Costa ~zero, non puo' danneggiare
chi viene dopo, e risponde subito a una domanda da cui dipendono ~20 round: se la
catena fosse rotta, lo si leggerebbe in testa al referto invece che in fondo.
**Se il runner fermasse la coda a una riga morta**, la riga andrebbe in fondo,
perche' 19 round valgono piu' di una risposta anticipata — **ma non la ferma, e
l'ho misurato.**

## 6.c — E LA RIGA, SCRITTA PER INTERO (pronta, per quando il pin la potra' vedere)
🔴 **NON e' in `CODA.txt` e non va incollata adesso**: al pin di oggi muore su un
404 (paragrafo 2). Va messa **solo dopo** il dodicesimo giro di pin.

```text
<pin del 12o giro> | backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1 | -Expert ABTG_DAX_Apertura_EU -Prova CANARINO_FRAZIONEIS_D30EUR.txt -Etichetta canfrz -Modello 4 -Deposito 10000 -SoloControllo
```
🟢 **Gli argomenti stanno tutti nella lista bianca firmata l'11/09** — verificato
sul `param()` di `RIGA_SOTTILE_ROUND.ps1` r.99-106:
`-Expert -Prova -Etichetta -Modello -Deposito -SoloControllo`. **Zero argomenti
nuovi, nessun perimetro allargato, nessuna firma nuova.**
🟢 **E passa il cancello G4 del runner — provato MECCANICAMENTE, non letto a
occhio.** Ho estratto le voci vietate dal sorgente e confrontato la stringa
**come fa PowerShell** (`-match`, quindi **case-insensitive**):

```console
$ python3 ...estrae i divieti da runner_abtg.ps1 e prova la stringa...
  divieti in $DIVIETI            : 29
  di cui validi in corsia ROUND  : 21
  divieti in $DIVIETI_SOLO_ROUND : 12
  TOTALE che vagliano un ROUND   : 33

  divieti colpiti  : NESSUNO
  percorsi X:\     : NESSUNO         (cancello G4 r.435-440)

  CONTRO-ESEMPIO (la stessa stringa + ' -TerminaleBacktest C:\BCM_Reale'):
    divieti colpiti : ['BCM_Reale']
    percorsi X:\    : ['C:\BCM_Reale']
```
✅ **Zero divieti colpiti**, 🟢 **e il test sa trovarli**: con l'esca becca
`BCM_Reale` e il percorso fuori dal banco. Un controllo che non puo' fallire non
e' un controllo.
📌 **E una correzione che vale la pena scrivere**: l'intestazione di `CODA.txt`
(r.22) dice *"non contenere nessuno dei **24** divieti"*. **Sono 33** per una
riga in corsia ROUND (21 + 12). Il numero in quel commento e' **vecchio** — non
cambia nessun verdetto, ma chi lo legge per contarli si fida di un numero
sbagliato. Non l'ho corretto perche' `CODA.txt` stanotte non si tocca.

`-Modello 4` e `-Deposito 10000` sono quelli di R128b (r.13).

---

# 7️⃣ 🔑 LA VIA PIU' CORTA AL NUMERO — «se potrebbe passare, si insiste»

Il canarino e' fermo per un **pin**, non per un numero brutto. Quindi non si
archivia: si dice quanto costa il numero. **Costa DUE RIGHE, in un file solo.**

## Il **DODICESIMO GIRO DI PIN** su `RIGA_SOTTILE_ROUND.ps1`, e sono due valori:

| riga | oggi | domani |
|---|---|---|
| r.338 `$PIN` | `115254dc64b2c7ac9493a33b8f5bbc09f814ea1b` | **il commit di questa consegna** (contiene il canarino) |
| r.381 `$SHA_WALK` | `BF53EC27...FAF59875` (driver @115254dc) | **`15DE7D5F5A342BB3D2DFEFCE8C970AA93C440B25DE136AFC050ED5B66828F1C6`** (driver a HEAD) |
| r.357 `$SHA_ROUND` | `348ED533...9D0A315B` | 🟢 **NON si tocca** |

🟢 **Perche' `$SHA_ROUND` non si tocca — misurato, non assunto:**
```console
$ sha256sum backtest_pipeline/righe/RIGA_ROUND_VPS.ps1      (albero/HEAD)
  348ED5330C18DCD41D736B0709B880A8EC9BF8A4B700B044999BC7099D0A315B
$ git show 115254dc:backtest_pipeline/righe/RIGA_ROUND_VPS.ps1 | sha256sum
  348ED5330C18DCD41D736B0709B880A8EC9BF8A4B700B044999BC7099D0A315B
```
✅ **Identico.** Il file non e' cambiato fra il pin e HEAD.

🔴 **E perche' `$SHA_WALK` INVECE si tocca — un fatto che non era nel mandato e
che avrebbe fatto morire il dodicesimo giro:** il driver **a HEAD non e' quello
al pin**.
```console
$ sha256sum backtest_pipeline/walkforward_generico.ps1                    (HEAD)
  15DE7D5F5A342BB3D2DFEFCE8C970AA93C440B25DE136AFC050ED5B66828F1C6
$ git show 115254dc:backtest_pipeline/walkforward_generico.ps1 | sha256sum
  BF53EC27C98316A8F648009BC2B73B9A9ED6A298C02CBB04E62E3530FAF59875
```
🟢 **Ma la differenza e' INNOCUA, e l'ho letta invece di fidarmi**: il commit
`f14831b` ("classe 271 pagata subito") cambia **5 righe su 5**, e sono **tutte
COMMENTI** — riferimenti a numeri di riga corretti (`r.493` → `r.506`, `r.559` →
`r.553`, `r.574-579` → `r.737-742`). `git diff --numstat` = **5/5**, zero righe
di codice. E il driver a HEAD **passa il cancello**:
```console
$ python3 backtest_pipeline/controlla_riga.py --oggetto ps1 backtest_pipeline/walkforward_generico.ps1
  PASSATI (6): ASCII puro | compila 0 errori | param block RICONOSCIUTO |
               nessun costrutto pwsh-7-only | formati .NET | nessun Parse senza cultura
  ESITO: nessun difetto meccanico.                                  EXIT = 0
```
⚠️ **Chi fa il dodicesimo giro deve cambiare TUTTI E DUE i valori.** Se cambiasse
solo `$PIN`, il round morirebbe sull'impronta — fallimento giusto e rumoroso, ma
una riga persa.

## 🔴 E PERCHE' IL DODICESIMO GIRO **NON L'HO FATTO IO**
Il mandato lo vieta a chiare lettere: *"NON toccare `walkforward_generico.ps1`
ne' `RIGA_SOTTILE_ROUND.ps1` (hanno un PASS)"*. Modificarli **invaliderebbe quel
PASS**, e il PASS nuovo vuole **due strati** (regola del 09/09): il
deterministico, che posso lanciare, **e** l'agente `controllo-preventivo`, che in
questa sessione **non ho modo di invocare**. Quindi mi fermo dove il mandato dice
di fermarsi, e consegno la riga pronta invece di una riga rischiosa.
🟢 **Buona notizia sul costo**: il dodicesimo giro **non rompe i 19 round**, e
questo e' misurato — le loro righe scaricano la copia **congelata** a `1445abf8`
(paragrafo 5), che ha i **suoi** `$PIN`/`$SHA_WALK` e non guarda HEAD.

---

# 8️⃣ 📖 COME SI LEGGE IL REFERTO DOMATTINA — **e la prima cosa e' che il canarino NON C'E'**

## 🔴 DOMANI (13/09): NON CERCARE IL CANARINO. NON E' IN CODA.
La stringa `IS 2024.09.26 - 2025.08.13` **non comparira' da nessuna parte**, e
🔴 **la sua assenza NON e' l'USCITA B**: e' il canarino che non e' partito,
perche' non l'ho messo in coda. Confondere le due cose sarebbe esattamente
l'errore che questo file esiste per impedire.
👉 Domattina si legge il referto **dei 19 round**, come previsto: `ESITO:`,
`eseguiti`, `rifiutati`, `falliti`, e i cancelli `r127c` (n = 394 +/-2%,
PF 1,41 +/-0,03) e `r136a` (IS 237 deal / PF 1,20110 / DD 5,7325%).

## 🐤 E QUANDO IL CANARINO GIRERA' (dopo il dodicesimo giro di pin)
Nel referto del runner si cerca la sezione della riga `canfrz`, e **una sola
stringa decide**:

| cerca questo | verdetto | cosa si fa |
|---|---|---|
| **`IS  2024.09.26 - 2025.08.13`** | 🟢 **USCITA A — direttiva ONORATA** | **SI APRE LA CODA**: le ~21 edit da una riga ai file prova che dichiarano il taglio 0.50, R128b in testa. Conferma di appoggio nella stessa uscita: `taglio IS/OOS preso da '@FRAZIONEIS' nel file prova: 0.5` |
| **`IS  2024.09.26 - 2025.06.09`** | 🔴 **USCITA B — direttiva IGNORATA IN SILENZIO** | 🛑 **SI FERMA TUTTO.** Non si mette in coda **nessun** round a 0.50: girerebbe a 0.40 credendo di girare a 0.50, e i suoi numeri non sarebbero usabili da nessuno. Si cerca il guasto fra `$PIN`, `$SHA_WALK` e il file scaricato |
| **`scarico fallito`** / **`l'impronta non torna`** / **`RIFIUTATO`** | ⚠️ **USCITA C — catena rotta a monte** | Ne' A ne' B: si legge il messaggio e si ripara **quello**. Il canarino non ha risposto, e non va contato come risposta |

🔑 **Controllo di appoggio, gratis**: la stessa uscita deve portare
`celle per finestra : 7 -> 14 pass`. Se il numero fosse diverso, il file prova
scaricato **non e' questo** — e allora nessuna delle tre righe sopra vale.
🟢 **E costa ~zero minuti**: `-SoloControllo` stampa
`=== SOLO CONTROLLO: MT5 non e' stato aperto ===` e si ferma. Zero passate di
tester, zero CSV, nessun terminale MT5 toccato.

---

# 9️⃣ 🔴 COSA RESTA **NON MISURATO** — detto per intero

1. 🔴 **`[NON MISURATO]` LA CATENA VERA. Il `NON COPERTO` del cancello di
   `@FRAZIONEIS` E' ANCORA APERTO, ED E' IL PUNTO.** Nessun `-SoloControllo`
   e' girato **dal VPS, dalla corsia vera, attraverso `raw`**. Le mie prove
   girano su Linux con il driver **scaricato da `raw` al pin giusto** — che e'
   piu' di "in locale sul file", perche' l'impronta dei byte e' quella vera — ma
   **non** attraversano `RIGA_SOTTILE_ROUND` → `RIGA_ROUND_VPS` → controllo
   d'impronta → MT5 → compilazione. **Quella resta dovuta.**
2. 🔴 **`[NON MISURATO]` IL SECONDO STRATO DEL CANCELLO.** La regola del 09/09
   vuole **due** strati. Il deterministico e' passato su tutto (EXIT 0, senza
   pipe). L'agente **`controllo-preventivo`** 🔴 **non e' stato invocato: in
   questa sessione non ho uno strumento per lanciare un sottoagente.**
   🟢 Attenuante **di fatto, non di principio**: **niente e' uscito** verso
   Claudio ne' verso il VPS. `CODA.txt` non e' stata toccata, nessuna riga di
   lancio e' stata prodotta, nessun round e' in coda. La condizione bloccante —
   *"niente esce senza un PASS"* — **non e' stata violata perche' niente e'
   uscito.** 👉 Ma **prima** che la riga del paragrafo 6.c entri in coda, quel
   secondo strato va fatto passare, sul file prova **e** sul dodicesimo giro.
3. 🔴 **`[NON MISURATO]` il canarino su Windows PowerShell 5.1.** Qui gira
   `pwsh 7.4.6`; il VPS ha la 5.1. Il file prova e' **ASCII puro verificato**
   (quindi il difetto del 17/08 non lo tocca) e non e' uno script, ma
   l'esecuzione del driver sotto 5.1 con `@FRAZIONEIS` **non e' stata provata da
   nessuno**. Ereditato dal referto di `@FRAZIONEIS`, punto 8 — **non chiuso da
   me, e lo dico invece di lasciarlo cadere.**
4. ⚠️ **`[NON MISURATO]` i ~163 / ~162 ingressi.** Il canarino verifica che il
   driver **tagli** al 2025.08.13, **non** che in quella finestra ci siano 163
   ingressi. Quel numero viene da **una sola** misura (i 325 di R120, margine
   **+8%** sul pavimento di 150) e il canarino **non lo tocca**. Se quei 325
   fossero sbagliati, cadono tutti e venti i round insieme. **Non e' un motivo
   per non lanciare: e' un motivo per non arrotondare mai quel numero.**
5. ⚠️ **`@FRAZIONEIS` non e' ancora in nessuno degli altri ~20 file prova.**
   Questo file e' un **canarino**, non uno dei venti: le 21 edit da una riga
   (R128b in testa, e `R128a` con un `@FRAZIONEIS 0.40` esplicito) restano da
   fare, e vanno fatte **dopo** l'USCITA A, non prima.
6. ⚠️ **Il buco del parser su `@FINOA` resta APERTO** (una riga `@FINOA` senza
   valore passa liscia, exit 0, nessun avviso). Ereditato, dichiarato, non mio.

---

# 🔟 🎯 DOVE SIAMO, DA SOCIO

🟢 **La buona notizia, e non e' piccola**: il canarino **funziona**. Non "e'
stato scritto": e' stato **girato contro i byte veri del driver pinnato** e ha
stampato `2025.08.13`, mentre il suo contro-esempio ha stampato `2025.06.09`. La
prova che dovevamo costruire **esiste, e discrimina.**
🟢 **La seconda buona notizia**: i 19 round di stanotte non li ho sfiorati.
Partono alle 03:30 esattamente come sono stati collaudati.
🟢 **La terza**: ho trovato un pin che nessuno aveva contato — il **terzo** — e
l'ho trovato **prima** che costasse una notte, non dopo. E ho trovato che il
driver a HEAD **non e' quello al pin**: chi avesse fatto il dodicesimo giro
cambiando solo `$PIN` avrebbe perso il round sull'impronta.
🔴 **E la notizia brutta, detta lo stesso**: stanotte alla domanda non si
risponde. Serve un dodicesimo giro di pin — **due righe in un file** — e poi il
canarino costa **zero minuti di macchina**.
🔴 **E questa consegna e' PONTEGGIO.** Non ha prodotto nemmeno una misura di
mercato. Vale perche' ~20 round sulla sedia del DAX aspettano quella risposta, e
a tre settimane da ottobre un round che gira a 0.40 credendo di girare a 0.50
sarebbe una notte buttata **e** un numero che nessuno puo' usare.

**Il passo piu' corto, ed e' uno**: dodicesimo giro di pin (`$PIN` +
`$SHA_WALK`), i due strati del cancello, e la riga del paragrafo 6.c in testa al
blocco round. Poi domattina si cerca **una stringa sola** e si sa. 💪
