# 🔬 ANATOMIA DELLE APERTURE — 16 ANNI DI NASDAQ — foglio di lancio (26/08/2026)

**Macchina: PC DI BACKTEST (DESKTOP-H4D7CAJ). Non sul VPS.**
**Durata attesa: BLOCCO 1 ~20 secondi · BLOCCO 2 ~1 minuto.**
**MT5 PUÒ RESTARE APERTO — ed è una dichiarazione, non una dimenticanza:**
questa riga **non apre nessun terminale**, non compila, non tocca un EA, un
preset, un `.chr`, e **non scrive un byte dentro `MetaQuotes\Terminal`**.
Legge un file CSV e scrive sul Desktop.
Se sul PC sta girando un backtest **non gli toglie niente di serio**: la RAM di
picco è **33 MB, misurata** (vedi sotto), non stimata.

> 🛑 **NON tocca** R110, R111, lo STORICO, le MISURE LAMPO, FvgRetest, VwapRevert.
> Sono altri lavori e restano dove sono.

---

## 📌 IL PIN DI QUESTA RIGA

```
@@PIN@@
```

---

## 🎯 COSA MISURA, E PERCHÉ

La tua richiesta di oggi: _"creare agenti che da 0 analizzano gli ultimi 10 anni
di trade su apertura del Nasdaq, Dax, Dow e in base al numero maggiore di setup
creino il motore giusto"_.

La casa la esegue **in due tempi**, per non finire nel curve fitting:

| | cosa | quando |
|---|---|---|
| **FASE 1** | **si MISURA** cosa fa il mercato all'apertura, giorno per giorno, per 16 anni. **Nessun motore.** | ⬅️ **è questa riga** |
| **FASE 2** | si scrivono le **ipotesi di motore** guardando **solo il 2010-2020**, e si validano sul **2021-2026** mai visto + tick BCM | round futuri, criteri propri |

Fatta in un colpo solo su tutto lo storico, la domanda *"guarda i dati e poi
scegli il motore"* è **la definizione del curve fitting**: si sceglie ciò che si
adatta meglio a tutto, e non resta niente per verificarlo. Spezzata in due, la
stessa domanda dà una risposta **verificabile**.

**Cosa conta, esattamente.** Per ogni giorno di borsa, sull'apertura cash delle
**09:30 New York**:

- il **range della pre-apertura** (l'ora prima) e il **gap** dall'ultima chiusura cash;
- la **corsa dei primi 5 / 15 / 30 / 60 minuti**: quanto va **su**, quanto va
  **giù**, dove **chiude** — dal prezzo d'apertura, in punti **e in % del prezzo**;
- la **classe del giorno**, meccanica: **DRIVE-UP / DRIVE-DOWN / FADE-UP /
  FADE-DOWN / RANGE / RIENTRO**;
- e la **copertura oraria**, che serve al punto qui sotto.

> ⚠️ **NON è un backtest.** In questo round non c'è — e non ci sarà — un profit
> factor, un'equity, un drawdown, un numero di trade. Non ci sono spread, fill,
> costi, né una posizione. **Una classe frequente NON è un edge: è una frequenza.**

---

## 🩺 IL CANCELLO QUALITÀ DEL FEED È IN VERIFICA — e va detto prima

Le **misure lampo** di stasera stanno esaminando **tre eventi anomali**, e il
cancello ZERO degli `_EXT` è ancora **CHIUSO** (diff media H1 0,061–0,101% contro
≤0,05% richiesto). Tre decisioni, prese **prima** di guardare i numeri:

1. ✅ **Lo studio gira lo stesso.** È descrittivo: non promuove celle, non muove
   sedie, non firma niente. Aspettare non gli darebbe nulla.
2. 📌 **Ogni referto lo scrive in testa**: l'**interpretazione** di questi numeri
   **dipende dall'esito** di quelle misure. Se il feed risulterà malato in un
   periodo, i conteggi di quel periodo si **rileggono**.
3. 🔬 **Lo studio misura da solo quanto pesa la malattia.** I giorni con
   **copertura oraria anomala** (meno di 55 barre su 60, o un buco interno oltre
   3 minuti, o la barra delle 09:30 mancante) sono **ESCLUSI** dai conteggi e
   contati a parte in una colonna **`SOSPETTI`**. Se un anno ne ha tanti, si vede.

---

## 🕐 IL FUSO — la trappola, disinnescata due volte

```
apertura cash Nasdaq = 09:30 NEW YORK = 14:30 ora server BCM = 15:30 italiana
```

Il CSV di HistData è scritto in **ora locale di New York** (misurato: 8 import su
8 hanno calibrato uno shift fisso +5 contro il nativo BCM). Quindi qui
**`09:30` è già l'apertura, e non si converte niente**: chi passasse `14:30`
misurerebbe il primo pomeriggio di New York.

E per non fidarsi nemmeno di questo, lo strumento **misura la convenzione da
solo** — il **CANARINO DEL FUSO** guarda mese per mese l'ora della pausa
giornaliera del feed e l'ora della riapertura di settimana. Se gennaio e luglio
danno la stessa ora → il feed segue il DST → `09:30` vale tutto l'anno.
**È la prima riga da leggere nel referto**, prima di ogni altra cosa.

---

## ▶️ BLOCCO 1 — GIRO A VUOTO (~20 secondi): **i dati ci sono? i criteri sono firmati?**

Non misura niente. Scarica lo strumento al pin, fa l'autotest, **apre il file dei
dati** per dire se è leggibile, e legge lo stato dei criteri. Incolla il **blocco
INTERO** (è un comando solo).

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_ANATOMIA_APERTURE.ps1"; Remove-Item $p -Force -EA SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ANATOMIA_APERTURE.ps1" -OutFile $p -EA Stop; if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ANATOMIA_APERTURE_v1' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' }; $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo; $rc=$LASTEXITCODE; if($rc -eq 2){ throw 'NON PARTITA (uscita 2): leggi il rosso qui sopra, rimedia e rilancia questo stesso blocco' }; $dsk=[Environment]::GetFolderPath('Desktop'); $c=@(Get-ChildItem (Join-Path $dsk 'ANATOMIA_APERTURE_*\CENSIMENTO_FONTE.txt') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 }); if($c.Count -eq 0){ throw 'NESSUN CENSIMENTO DI ADESSO: la corsa non ha scritto niente' }; Write-Host ('CENSIMENTO: ' + $c[0].FullName) -ForegroundColor Cyan; if($rc -ne 0){ Write-Host 'QUALCOSA NON TORNA: mandami il CENSIMENTO_FONTE.txt qui sopra PRIMA del blocco 2.' -ForegroundColor Yellow } else { Write-Host 'FONTE OK. Il blocco 2 parte solo a criteri firmati (vedi sotto).' -ForegroundColor Green } }
```

**Le righe da guardare a schermo:**

```
[hh:mm:ss] fonte MISURABILE: C:\Users\Master\abtg_storico_indici\NASUSD_M1.csv  (<N> MB, FORMATO1)
[hh:mm:ss]   prima riga: 2010.11.14 18:01,2135.000000,...
[hh:mm:ss]   ultima riga: 2026.07.31 16:13,...
[hh:mm:ss] lucchetti della firma trovati nel file: <n>
[hh:mm:ss] stato dei criteri: ...
```

- 🟢 **`fonte MISURABILE` + `FORMATO1`** = il file è quello giusto. La **prima
  riga** deve cominciare per **2010.11.14** e l'**ultima** per **2026.07.31**: se
  cominciano da un altro anno, sul disco c'è la copia **corta** (2019-2026) e lo
  studio non avrebbe i 16 anni.
- 🟡 Se dice **`NON MISURABILE`** o **`formato HISTDATA_GREZZO`**: **è già una
  risposta**, non un guasto. Sul disco c'è un file con lo stesso nome scritto
  dall'**altro** strumento di casa. Mandami `CENSIMENTO_FONTE.txt`.
- 🔒 **`stato dei criteri`**: finché dice **NON FIRMATI**, il BLOCCO 2 **non
  parte** — ed è giusto così: il giro a vuoto serve esattamente a farti leggere i
  criteri prima di firmarli.

📄 **I criteri da leggere**: `backtest_pipeline/risultati_archivio/STUDIO_APERTURE_CRITERI.md`.
Ci sono le **sette decisioni** del § 9 (simbolo, finestra, taglio delle due fasi,
soglie di classificazione, soglie dei giorni sospetti, la sesta classe, l'uso) e
il § 8 con **i caduti che questo round non riesuma**.

---

## ▶️ BLOCCO 2 — LA CORSA VERA (~1 minuto)

Da lanciare **dopo** aver letto i criteri, averli firmati, e dopo che ti ho
mandato il **pin nuovo** (la firma cambia il file, quindi cambia il pin).

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_ANATOMIA_APERTURE.ps1"; Remove-Item $p -Force -EA SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ANATOMIA_APERTURE.ps1" -OutFile $p -EA Stop; if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ANATOMIA_APERTURE_v1' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' }; $global:LASTEXITCODE=0; & $p -Pin $pin; $rc=$LASTEXITCODE; if($rc -eq 2){ throw 'NON PARTITA (uscita 2): leggi il rosso qui sopra, rimedia e rilancia questo stesso blocco' }; $dsk=[Environment]::GetFolderPath('Desktop'); $z=@(Get-ChildItem (Join-Path $dsk 'ANATOMIA_APERTURE_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 }); if($z.Count -eq 0){ throw 'NESSUNO ZIP DI ADESSO: la corsa non e'' arrivata alla raccolta' }; if($rc -ne 0){ Write-Host 'MISURATO CON RILIEVI: i rilievi sono una RISPOSTA, non un guasto -- lo zip va mandato LO STESSO.' -ForegroundColor Yellow }; Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan }
```

> ⚠️ **Il blocco 2 non porta nessuno switch di bypass, ed è voluto.** Esiste
> `-CriteriFirmati` per il caso in cui la firma sia data **a voce in chat** e non
> ancora scritta nel file — ma se resta nella pagina "tanto è innocuo" diventa un
> bypass permanente che il giorno di un lucchetto nuovo **non fermerà niente**.
> Se serve, te lo mando **in quel momento** e poi lo tolgo.

### 📨 Cosa mandare, e quale data guardare

Manda **il file che ti stampa l'ultima riga in ciano**:
`Desktop\ANATOMIA_APERTURE_<data>_<ora>.zip`.

> 🗓️ **PRIMA DI MANDARLO, APRI `REFERTO_ANATOMIA_APERTURE.txt` E GUARDA LA QUARTA
> RIGA:** dice `data: AAAA-MM-GG HH:MM:SS   <-- QUESTA DATA DEVE ESSERE DI
> ADESSO`. **Se quella data non è di adesso, stai mandando un referto vecchio**
> (è già successo due volte, il 17/08).

**Dentro lo zip devono esserci** (l'elenco lo stampa anche il driver, e lo
confronta lui con quello che ha davvero raccolto — se manca qualcosa lo dice in
rosso):

| file | cosa c'è dentro |
|---|---|
| `REFERTO_ANATOMIA_APERTURE.txt` | il referto del **driver**: fonte, fuso, stato dei criteri, righe chiave, attesi vs trovati, NOTE e PROBLEMI |
| `CENSIMENTO_FONTE.txt` | ogni file candidato aperto, con formato, dimensione, data, prima e ultima riga |
| `ANATOMIA_APERTURE_IS_2010_2020.txt` | 📖 **il referto su cui si lavora** (addestramento) |
| `ANATOMIA_APERTURE_CASSAFORTE_2021_2026.txt` | 🔐 **la cassaforte**: non si guarda per costruire ipotesi |
| `ANATOMIA_APERTURE_COMPLETO.txt` | tutti gli anni, per contesto |
| `ANATOMIA_APERTURE_PERGIORNO_NASUSD.csv` | **una riga per giorno**: classe, gap, range, escursioni a 5/15/30/60, copertura, motivo dell'eventuale esclusione |
| `log\*.log` | l'uscita cruda di ogni chiamata a python (autotest compreso) |

### 🔢 Le tre uscite possibili

| uscita | significa | cosa fare |
|---|---|---|
| **0** | tutto misurato, nessun rilievo | manda lo zip |
| **1** | **misurato CON RILIEVI** (giorni sospetti sopra soglia, canarino del fuso incerto, righe fuori ordine) | **manda lo zip lo stesso**: un rilievo è già una risposta |
| **2** | **non è partita** (pin, python, strumento, autotest, file assente o nel formato sbagliato, **criteri non firmati**) | leggi il rosso, rimedia, rilancia lo stesso blocco |

**Rilanciare è sicuro**: la corsa **non tocca nessun dato**, lo legge soltanto, e
riparte da zero ogni volta (la cartella di raccolta porta la data e l'ora).

---

## 📖 COME SI LEGGERÀ IL RISULTATO (scritto **prima** di vederlo)

1. 🕐 **Prima il CANARINO DEL FUSO.** Se dice **EST FISSO**, metà anno è misurato
   un'ora fuori bersaglio: **non si legge nient'altro**, si rifà.
2. 🩺 **Poi la COPERTURA.** Un anno con tanti `SOSPETTI` vale meno: è il
   termometro del cancello in verifica.
3. 📊 **Poi la DISTRIBUZIONE DELLE CLASSI** del referto `_IS_`. È la risposta
   letterale alla tua domanda: **quale setup si presenta di più**.
4. ⚠️ **E qui la frase che conta: una classe frequente NON è un edge.** Se il 40%
   dei giorni fosse `RIENTRO`, non vorrebbe dire che fadare le rotture paga —
   vorrebbe dire che le rotture rientrano spesso. **Se paga** lo dicono spread,
   stop e fill, cioè la **FASE 2** sui tick BCM.
5. 📏 **Le escursioni mediane per classe** dicono se quel movimento è **abbastanza
   grande** perché valga la pena parlarne. Il metro amaro ce l'abbiamo già: il
   03/08 sul DAX un trailing da 4,1 punti indice chiudeva in **39 secondi** su un
   movimento da 83 punti.
6. 🔀 **La colonna `2LATI`** dice quanto pesa la regola di priorità con cui si
   classificano i giorni che rompono da tutti e due i lati. Se è grossa, quella
   regola va discussa — sui numeri.
7. 🔁 **La persistenza** dice se il movimento dei primi 15 minuti è informazione o
   rumore.

**Quello che questa corsa NON può dire:** un **simbolo solo** (Nasdaq — HistData
non ha il Dow, e il DAX `grxeur` è bocciato in attesa di diagnosi), un **feed solo**
(HistData, **non BCM**), **nessun costo e nessun fill**. E se il cancello qualità
chiudesse male, una parte di questi conteggi andrà **riletta**.

---

## 🔧 PER LA SESSIONE (non per Claudio) — assegnare il pin

La pagina esce con un **segnaposto** al posto del commit. Va sostituito nei
**punti d'uso**, mai su tutta la pagina (una `sed` larga riscriverebbe anche
questa spiegazione, e la ricetta morirebbe al secondo giro).

```bash
cd ~/GITHUB && git pull --rebase --autostash
SHA=$(git rev-parse HEAD)
F=backtest_pipeline/righe/RIGA_ANATOMIA_APERTURE_DA_MANDARE.md
TOK='@@PIN'"@@"
sed -i "s|\$pin='$TOK'|\$pin='$SHA'|g; s|^$TOK\$|$SHA|" "$F"
grep -c "\$pin='$SHA'" "$F"    # DEVE dare 2
grep -c "$TOK" "$F"            # DEVE dare 0
```

**Ri-pinnatura** (quando il pin va rifatto — e qui va rifatto **di sicuro**, dopo
la firma dei criteri). Il pin vecchio si legge **dai punti d'uso** e si sostituisce
**solo lì**: le menzioni in prosa di un pin bruciato sono **storia** e non si toccano.

```bash
NUOVO=<lo sha nuovo, 40 caratteri>
F=backtest_pipeline/righe/RIGA_ANATOMIA_APERTURE_DA_MANDARE.md
VECCHIO=$(grep -oE "\\\$pin='[0-9a-f]{40}'" "$F" | head -1 | grep -oE '[0-9a-f]{40}')
sed -i "s|\$pin='$VECCHIO'|\$pin='$NUOVO'|g; s|^$VECCHIO\$|$NUOVO|" "$F"
grep -c "\$pin='$NUOVO'" "$F"     # DEVE dare 2
grep -c "\$pin='$VECCHIO'" "$F"   # DEVE dare 0
```

⚠️ I due conteggi vanno **tutti e due**: un `sed` che non ha sostituito niente
supera a mani basse il solo "zero segnaposto rimasti".

### E la firma dei criteri

Il gate cerca una **stringa letterale** dentro `STUDIO_APERTURE_CRITERI.md`.
Firmare vuol dire **toglierla da tutto il file**, non solo dal titolo: adesso ce
ne sono **due** (titolo e § 9). Il controllo è un conteggio, non un colpo d'occhio:

```bash
TOKF='[DA '"FIRMARE]"
F=backtest_pipeline/risultati_archivio/STUDIO_APERTURE_CRITERI.md
grep -cF "$TOKF" "$F"    # PRIMA della firma: 2   ·   DOPO la firma: DEVE dare 0
```

E si prova **nei due versi**: col lucchetto tolto la corsa vera deve **partire
senza switch**; col lucchetto rimesso deve tornare a **uscita 2**.
