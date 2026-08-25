# 📬 R109 — **LA RIGA DA MANDARE** (ATR Exhaustion & Volume Spike: D30EUR · U30USD · NASUSD, M15, **long e short separati**)

**Round**: R109 — **LA PRIMA MISURA IN ASSOLUTO** di `ABTG_AtrExhaustVol`, il
porting **P2** della caccia M5/M15 indici del 25/08 (voto **9/10 — PROVA SUBITO**).
**Tesi del porting**: `ATREXHAUST_TESI.md` (ogni scostamento dal Pine, uno per uno).
**Dossier**: `caccia_strategie/CACCIA_M5M15_INDICI_2026-08-25.md` (P2).
**Criteri**: `risultati_archivio/R109_CRITERI.md` — ⚠️ **[DA FIRMARE]**, 8 decisioni.
**Driver**: `righe/RIGA_R109_ATREXH.ps1` (marcatore `MARCATORE_RIGA_R109_v1`).
**File prova**: `prove/R109_D30EUR_00_long.txt`, `R109_D30EUR_01_short.txt`,
`R109_U30USD_00_long.txt`, `R109_U30USD_01_short.txt`,
`R109_NASUSD_00_long.txt`, `R109_NASUSD_01_short.txt` — **sei**.

> 🟢 **PASSATO DAL VERIFICATORE-STRINGHE il 25/08 — verdetto `FAIL → CORRETTO`,
> in DUE giri.** **Dieci** difetti trovati e corretti (elenco in fondo alla
> pagina), di cui **quattro di classe NUOVA** finiti in
> `CHECKLIST_RIGA_DI_LANCIO.md` (punti **76-79**).
>
> 🔴 **IL PIN `cf6126d` È BRUCIATO — NON LANCIARE NIENTE CON QUELLO.** Il suo
> giro a vuoto è uscito **`ESITO: OK`** con `ToDate` corrotto in tutti e 12 gli
> `.ini` delle celle: la corsa vera avrebbe girato su una **finestra non
> dichiarata**. Trovato da **Claudio** aprendo un `.ini` dello zip delle 21:48.
> Serve un **pin nuovo** sul commit che contiene le correzioni (§ IL PIN), e
> **il giro a vuoto va rifatto**.

---

## 🔴 LE TRE COSE DA SAPERE PRIMA DI TUTTO IL RESTO

### 1. 🧨 QUESTO EA **NON È MAI STATO COMPILATO**

Lo dice il `.mq5` stesso, in testa: _"NON compilato ne' testato da chi ha
scritto il file"_. Chi l'ha scritto **non ha MetaEditor**.

👉 **La prima `F7` della sua vita avviene sul TUO PC, dentro questa riga.**
Perciò:

- il **giro a vuoto compila** — ed è la cosa **più utile** che possa fare;
- se **non** compila, il driver stampa **le ultime 40 righe del log** e **le
  righe con `ERROR` separate** (sono quelle da incollare in chat), **rimette il
  `.mq5` com'era**, mette il log nello zip e si ferma;
- **un errore di compilazione qui NON è un guasto della riga: è un esito
  previsto**, ed è esattamente il motivo per cui il giro a vuoto va fatto
  **prima** e **da solo**.

### 2. 🧷 C'È UN AUTOTEST DA LEGGERE, E **NON LO PRODUCE `F7`**

L'EA porta dentro **sette blocchi di autotest** sul nucleo puro (pivot,
prossimità, esaurimento, volume, i due grilletti, il segnale completo, il
pavimento dello SL, l'orario) e chiude con una riga secca:

```
[ATREXH][AUTOTEST] esito motore: SETTE BLOCCHI SU SETTE, la regola ragiona come la firma.
[ATREXH][AUTOTEST] esito motore: DIVERGE: non usare i risultati, c'e' da guardare il codice.
```

Stampa in **`OnInit`**, quindi **si legge ESEGUENDO, non compilando**
(checklist **20**). E **mai** attaccando l'EA a un grafico: sul PC di backtest
il terminale è collegato al **conto vivo** (checklist 26).

👉 Il driver fa una **PASSATA DI COLLAUDO** dedicata — **una cella, un mese,
modello 1, magic `774400`, zero numeri di round** — che serve solo a leggere
quelle righe e a **fallire presto** invece che dopo ore di tick reali.
**Tre stati, e il terzo non è un verde**: `SUPERATO` · **`DIVERGE` → si ferma
tutto** · **righe non trovate → si prosegue, ma ogni numero esce marcato
`NON CONVALIDATO`**.

### 3. ⚖️ **LONG E SHORT SONO CELLE SEPARATE**, ed è regola di casa (25/08)

Sei celle: tre simboli × due lati. E c'è un **costo dichiarato**, che va letto
prima dei numeri:

> **La somma dei due lati di un simbolo NON è la cella "entrambi".** Ogni lato
> ha il **suo** cap di 3 operazioni al giorno e la **sua** "una posizione alla
> volta": in R109 un simbolo può fare **fino a 6 operazioni al giorno** e i due
> lati **non si bloccano a vicenda**, mentre un solo EA con entrambi i lati
> accesi ne farebbe **3**. Sommare le righe dà un **limite superiore**.

---

## ❓ LA DOMANDA — è di Claudio, ed è del 25/08

> _"Dobbiamo avere più strategie su TF 5 min e 15 min. Ci servono per la challenge."_

**R109 non chiede "funziona?". Chiede tre cose, in quest'ordine:**

1. **compila?** (nessuno lo sa)
2. **il suo autotest passa?** (nessuno lo sa)
3. **quante operazioni fa, e il take copre il costo?** — cioè il **PASSO 0** e
   il **cancello zero S0a**, che si leggono **PRIMA di qualunque profit factor**.

---

## 🚫 E COSA R109 **NON** CHIEDE, dichiarato prima

🔴 **NON chiede se il motore è buono.** Lo storico BCM sugli indici parte dal
**2024.09.26** (misurato, `REFERTO_SONDA_STORICO_17-08.md`, stato `COMPLETO` =
*il broker non ha altro*): **~23 mesi, un solo regime, prevalentemente
rialzista**. E questo è un motore **CONTROTENDENZA**.

> **Il MERITO è SOSPESO PER COSTRUZIONE, a qualunque `n`** — non perché il
> campione sia sottile, ma perché la finestra contiene **un solo mercato**. Il
> numero che esce dice **quanto è costato opporsi a QUESTO toro**, non se
> l'idea funziona.
>
> **Il RISCHIO invece si legge tutto e subito**: drawdown, **peggior giornata
> con la data**, perdita mediana, concentrazione giornaliera. Sono **fatti
> accaduti** (Emendamento regola **B**).

🔴 **NIENTE dati Dukascopy `_EXT`**: sugli indici **non esistono ancora**
(pipeline in costruzione in parallelo). **R109 gira SOLO su BCM**, con i costi
di **un broker solo**. Quando la pipeline ci sarà, **questo round va rifatto su
una finestra che contenga almeno un orso**.

🔴 **NIENTE griglia e NIENTE ablazioni** (decisione D1). Le quattro gambe che la
tesi elenca — prossimità **%** vs **ATR**, grilletto **AUTORE** vs **CLOSE**,
buffer/pavimento dello SL, parziale+BE+trailing — **non girano**. Su un motore
**mai compilato e mai misurato** una griglia non è un'ottimizzazione, è una
**pesca**: è la clausola della **SECONDA CACCIA** (CLAUDE.md, 19/08).

🔴 **NIENTE IS/OOS** (decisione D3). L'Emendamento **A** dimensiona l'IS **sulle
operazioni (≥150)**, e le operazioni **non le conosciamo**. R109 **conta**; il
taglio si fa dopo, **sui conteggi veri**.

---

## 🔴 IL CANCELLO DELLA FIRMA — **è CHIUSO, e va aperto da Claudio**

`R109_CRITERI.md` porta `[DA FIRMARE]` nel titolo. Il driver **lo legge al pin**:

- il **giro a vuoto parte lo stesso** (non apre MT5, non produce nessun numero,
  **ma compila**);
- la **corsa vera si ferma con `exit 2`**, a meno di `-CriteriFirmati`.

**Le otto decisioni** (§ 10 dei criteri, tutte con la proposta già scritta):

| | decisione | ✅ proposta |
|---|---|---|
| **D1** | griglia o **default d'autore** alla prima uscita? | **SOLO la cella AUTORE.** Su un motore mai compilato e mai misurato, una griglia è una **pesca** |
| **D2** | la **profondità dei TICK**: c'è per **U30USD** (67,6 milioni di tick dal 2024.09.26), **manca** su D30EUR e NASUSD | **SI MISURA PRIMA** sui due che mancano. A modello 4 senza tick reali MT5 **non si ferma**: ripiega e produce numeri **plausibili e falsi**, e **nessuna guardia del driver può accorgersene** |
| **D3** | divisione **IS/OOS**? | **NESSUNA.** R109 gira la **sola finestra intera** e conta |
| **D4** | lo **spread di riferimento** di S0a | **2,0 punti indice DICHIARATI** (lato alto della forchetta 1-2 di `R98_CRITERI.md`), con `[SPREAD NON MISURATO]` stampato accanto a ogni verdetto |
| **D5** | se l'**autotest non si legge** (log non trovato) | **si prosegue, ma ogni numero esce `NON CONVALIDATO`** e il round non può uscire `OK`. Se stampa **`DIVERGE`**: **si ferma tutto** |
| **D6** | se **S0a fallisce su una cella** | **quella cella si chiude, le altre proseguono** |
| **D7** | il **cap giornaliero** coi lati separati | **resta 3 PER CELLA**, e il referto stampa **quante giornate l'hanno toccato**: se sono tante, la frequenza misurata è un **limite inferiore** |
| **D8** | **modello** | **4 (tick reali)**. `-ScreenOhlcM15` esiste, ma se acceso **ogni riga esce `NON GIUDICABILE`** e l'uscita non è 0 |

> 🚦 **E RESTA IL CANCELLO DEL TRAFFICO: una macchina, un lavoro.** Il PC di
> backtest ha un solo MT5. R109 parte **solo quando nessun altro round sta
> toccando il terminale**. ⚠️ **E questo round è lungo**: 12 delle 13 passate
> sono a **tick reali su ~23 mesi di M15 di INDICI** — il solo U30USD ha
> **67,6 milioni di tick** nella finestra.

---

## 📌 IL PIN — **il commit congelato su cui gira tutto**

```
5a9d5e04a64677d3b9cb678c52b251b4ece94721
```

🔴 **IL PIN QUI SOPRA È ANCORA UN SEGNAPOSTO E VA SOSTITUITO PRIMA DI DETTARE
LA RIGA.** Il verificatore ha **cambiato il driver** (sei correzioni) **e questa pagina** (la settima): il commit
da pinnare è quello che **le contiene**. Sequenza, in quest'ordine —
**due commit, non uno**:

```bash
F=backtest_pipeline/righe/RIGA_R109_DA_MANDARE.md
# 1. i file che il driver SCARICA (correzioni del verificatore COMPRESE)
git add backtest_pipeline/righe/RIGA_R109_ATREXH.ps1 \
        backtest_pipeline/risultati_archivio/R109_CRITERI.md \
        backtest_pipeline/prove/R109_*.txt
git commit -m "R109: driver corretto dal verificatore + criteri + file prova"
git push
SHA=$(git rev-parse HEAD)
# 2. il pin dentro questa pagina, che il driver NON scarica.
#    >>> IL TOKEN SI COMPONE IN UNA VARIABILE, e non e' un vezzo: se lo
#        scrivessi per esteso qui sotto, il sed riscriverebbe QUESTE STESSE
#        RIGHE e alla prossima ri-pinnatura la ricetta sarebbe morta. Provato.
TOK='@@PIN'"@@"
#    >>> E si sostituiscono SOLO i quattro punti d'uso (3 blocchi + il riquadro
#        del pin), non tutta la pagina: la prosa che SPIEGA il segnaposto deve
#        restare leggibile.
sed -i "s|\$pin='$TOK'|\$pin='$SHA'|g; s|^$TOK\$|$SHA|" "$F"
grep -c "\$pin='$SHA'" "$F"   # DEVE dare 3  (i tre blocchi di lancio)
grep -c "\$pin='$TOK'" "$F"   # DEVE dare 0  (nessun segnaposto rimasto nei blocchi)
git add "$F" && git commit -m "R109: pin" && git push
```

🔁 **E SE IL PIN VA RIFATTO** — succede sul serio: il 25/08 **due volte**
(`826f008` sullo storico indici, e `cf6126d` qui, bruciato dal difetto del
`ToDate`). Il segnaposto non c'è più, quindi si sostituisce **il pin vecchio**:

```bash
F=backtest_pipeline/righe/RIGA_R109_DA_MANDARE.md
# il pin VECCHIO si legge DAI PUNTI D'USO, non "a occhio dalla pagina"
VECCHIO=$(grep -oE "\\\$pin='[0-9a-f]{40}'" "$F" | head -1 | grep -oE '[0-9a-f]{40}')
git push && NUOVO=$(git rev-parse HEAD)
sed -i "s|\$pin='$VECCHIO'|\$pin='$NUOVO'|g; s|^$VECCHIO\$|$NUOVO|" "$F"
grep -c "\$pin='$NUOVO'" "$F"     # DEVE dare 3
grep -c "\$pin='$VECCHIO'" "$F"   # DEVE dare 0
```

🔴 **E NON un `sed -i "s|$VECCHIO|$NUOVO|g"` secco.** Provato, e sbagliava: in
pagina i pin compaiono anche **ABBREVIATI e in PROSA** (`cf6126d` nella riga
*"il pin `cf6126d` è BRUCIATO"* e nella tabella dei difetti). Un `sed` largo
prendeva **6 occorrenze invece di 4** e riscriveva la **storia** — la pagina
avrebbe detto *"il pin `<nuovo>` è bruciato"*, cioè l'esatto contrario del
vero. Le menzioni in prosa sono **memoria**, non pin da usare: **non si
toccano**. Stessa regola del punto **77**: si sostituiscono i **punti d'uso**.

⚠️ Se il segnaposto resta, l'`irm` prende un **404**, `-ErrorAction Stop` è
terminante e **la riga muore lì**: non parte niente. È il comportamento voluto,
ma è un giro sprecato — meglio i due `grep -c` qui sopra, che si leggono
**insieme**: il primo dice che la sostituzione **è avvenuta ovunque serviva**,
il secondo che **non ne è rimasta nessuna**. Uno solo dei due non basta (un
`sed` che non matcha niente supera il secondo controllo a mani basse).

**Cosa scarica il driver al pin** (e quindi cosa deve essere già in repo):
i **sei** file prova, `R109_CRITERI.md`, il sorgente
`mql5/Experts/ABTG_AtrExhaustVol.mq5`, l'include
`mql5/Include/ABTG_PausaGuardian.mqh` e — dove esistono —
`risultati_archivio/misura_tick/misura_tick_<SIMBOLO>.csv` **e il suo referto
gemello `REFERTO_MISURA_TICK_<SIMBOLO>.txt`** (è lì, e **solo** lì, che sta la
**data della misura**: nel CSV non c'è).

⚠️ **Se il pin non contiene `R109_CRITERI.md` la riga si ferma dicendo
`R109_CRITERI.md NON SI E' SCARICATO al pin ...`** e scrive lo zip lo stesso.
🔴 **NON è "i criteri non sono firmati"**: è il **pin** sbagliato (o un commit
che quel file non contiene ancora, o la cache di raw). Prima della correzione
del verificatore quel caso usciva dal riquadro rosso *"I CRITERI NON SONO
FIRMATI"* — e mandava a firmare otto decisioni per un problema di pin.
**Non c'è nessun antenato da scaricare: questo motore non ha antenati** (§ *I
GATE*).

La riga passa il pin a `-Pin` e **si rifiuta di partire senza**: un default
silenzioso (`lavoro`) farebbe girare la punta del branch spacciandola per un
commit congelato.

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** Col terminale aperto il tester non
  gira (zero CSV); con MetaEditor aperto la compilazione **torna subito senza
  compilare** — e su questo round sarebbe il falso negativo peggiore: manderebbe
  a cercare **errori di porting che non esistono**. La riga si rifiuta di
  partire in tutti e due i casi.
- **NESSUNA SEDIA VIVA VIENE TOCCATA.** Magic **vergini, blocco `7744xx`**.
  🔁 **Grep rifatto dal verificatore il 25/08**, fuori dai file di R109:
  **4 occorrenze del valore `774401`** (3 in `ATREXHAUST_TESI.md`, 1 nel
  sorgente) **più 3 richiami ai magic short di R109 stesso** (`774420`,
  `774440`, `774460`) in `CENSIMENTO_LATI_SHORT_2026-08-25.md`, che è un
  documento scritto **oggi e su R109**: non è una sedia viva.
  **Nessun altro `7744xx` esiste nel repo.**
  🔴 **E `774401` è VIETATO dal driver**: è il **default compilato** dell'EA, e
  se una cella girasse col default — pin saltato, o MT5 che si ricorda l'ultimo
  valore (checklist **25**) — **il magic lo direbbe**.
- **13 passate**: 1 collaudo dell'autotest + 2 per cella (1 singola + 1 gemella).
- **Zero parametri spazzolati.** L'unico asse con flag `Y` è `InpMagic`, e il
  driver **si ferma** se in un file ne trova un secondo.
- **Il round non scarica storico** e non tocca `bases\<server>\ticks` — e su
  questi indici lo storico è **tutto quello che il broker ha**.
- 🔧 **Se non è già stato fatto**: MT5 → Strumenti → Opzioni → Grafici →
  **"Max barre nel grafico" = Illimitato**. Il driver scrive comunque
  `[Charts] MaxBars=2000000000` nei suoi `.ini`. ⚠️ Il tetto delle 100.000 barre
  **non dovrebbe mordere** qui (~47.000 barre M15 in 23 mesi, **[DERIVATO]**).
- ⏱️ **Durata [STIMA, non una previsione]**: ordine di grandezza **3-12 ore**.
  `-OreMax 14` è un tetto sull'**inizio** di nuovi lavori, non un'accetta su un
  lavoro in corso.

---

## 1️⃣ PRIMA il giro a vuoto — **su questo round vale più che sugli altri**

> ⚠️ **Non è a costo zero sul terminale**: scarica gli artefatti al pin,
> **installa `ABTG_PausaGuardian.mqh`** in `MQL5\Include` e **COMPILA l'EA per
> la prima volta**. Quello che **non** fa: non apre MT5 per testare, non
> cancella nessun artefatto, **e non legge nessun autotest** (che richiede
> un'esecuzione).

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $t0=Get-Date; $pin='5a9d5e04a64677d3b9cb678c52b251b4ece94721'; $p="$env:USERPROFILE\RIGA_R109.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R109_ATREXH.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R109_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem "$env:USERPROFILE\Desktop\R109_ATREXH_*.zip" -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($z.Count -eq 0){ Write-Host '!!! NESSUNO ZIP DI ADESSO: la riga si e'' fermata prima della raccolta. Copia lo SCHERMO, non cercare file.' -ForegroundColor Red }
    else { Write-Host ('ZIP: ' + $z[0].FullName) -ForegroundColor Green };
    if($rc -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

### Cosa deve dire

⚠️ **Le righe qui sotto sono SCRITTE DAL BUILDER, non incollate da un output
reale** — il giro a vuoto vero richiede MT5, che qui non c'è (checklist **70**:
quando l'output è prodotto eseguendo, va detto; **qui non lo è**). I conteggi
(**6 celle, 13 passate, 41 righe**) sono invece **misurati sugli artefatti**.

```
    simboli ......................  3   (D30EUR, U30USD, NASUSD)
    celle ........................  6   (long: 3 | short: 3)
    passate ......................  13   (1 collaudo autotest + 2 per cella: singola + gemelle)
    righe vive per file prova ....  41   (42 input del sorgente meno InpNewsCurrencies)
    righe per CSV di ottimizz. ...  2   (le due gemelle di controllo)

    FINESTRA : 2024.09.26 -> 2026.08.21   modello 4 (TICK REALI)
```

> ⚠️ **`(D30EUR, U30USD, NASUSD)` è l'ORDINE IN CUI GIRANO** — quello del
> dossier — **ed è lo stesso ordine di TUTTE le tabelle del referto.** Non è
> alfabetico, e non deve esserlo. 🔴 **Corretto dal verificatore il 25/08**: il
> driver stampava qui `(D30EUR, NASUSD, U30USD)` (alfabetico, perché la lista
> nasceva da `Sort-Object -Unique`) mentre catena e tabelle uscivano
> nell'ordine del dossier — **due ordini diversi nella stessa corsa**, cioè un
> falso allarme che costa un giro (punto **70**, pagato su R107).

E poi, in ordine:

- `criteri: NON FIRMATI (il file porta ancora [DA FIRMARE])` — **è giusto così
  finché non firmi**, e il giro a vuoto prosegue lo stesso;
- `6 file prova scaricati al pin, 41 righe di input ciascuno`;
- **`ABTG_AtrExhaustVol.mq5 al pin, version 1.00 -- i CINQUE PUNTI DEL REVISORE
  passano`**;
- **`gate del PORTING: tutti i valori dei 6 file prova coincidono coi DEFAULT
  DEL SORGENTE`**;
- tre righe `gate della STELLA <simbolo>: la cella short differisce dalla long
  SOLO sul lato (+ magic/commento)`;
- `valori, lato, geometria AUTORE, @PERIODO, asse unico e 19 magic vergini
  verificati NEI FILE`;
- **tre righe `profondita' TICK <simbolo>:`** — ⚠️ **U30USD dirà la sua riga
  misurata, D30EUR e NASUSD diranno `NON MISURATA`**, ed è la decisione **D2**:
  non è un guasto del driver, è un buco vero del repo. 📅 Accanto alla riga di
  U30USD il referto scrive ora **`[misurata il 2026-08-20 (N giorni fa)]`**, e
  **sopra i 30 giorni esce un RILIEVO** — è quello che i criteri § 4.2
  promettevano e che il driver **non faceva**: leggeva la prima data del CSV
  (`2024.09.26`, che è l'**inizio dello storico**, non il giorno della misura)
  e la stampava sotto l'etichetta `[file: ...]`. Corretto dal verificatore;
- `include installato: ABTG_PausaGuardian.mqh (... byte)`;
- 🔴 **`COMPILATO ABTG_AtrExhaustVol v1.00 (.ex5 riscritto adesso, rc=0, warning: N)`**
  — **è questa la riga che conta**. Se invece esce il riquadro rosso
  *"LA PRIMA COMPILAZIONE DI QUESTO EA NON E' RIUSCITA"*, **copia in chat le
  righe con `ERROR`** che il driver stampa apposta separate: sono quelle da
  correggere;
- in fondo: `.ini scritti e verificati: 13 su 13` e
  `ESITO: GIRO A VUOTO COMPLETATO`.

> 🔴 **E POI APRI UN `.ini` DELLO ZIP — sempre, non solo stavolta.** È così che
> è stato preso il difetto del `ToDate` (il giro a vuoto diceva `ESITO: OK`).
> Le due righe da guardare, in `NASUSD_01_short_singola.ini`:
> ```
> FromDate=2024.09.26
> ToDate=2026.08.21
> ```
> **Devono essere due date.** Adesso il driver le controlla da solo in quattro
> punti (argomenti, testo dell'`.ini`, rilettura nel giro a vuoto, referto), ma
> **il gesto di aprire l'artefatto resta il controllo che ha funzionato**.

> ⚠️ **Quello che il giro a vuoto NON può fare, detto prima.** `-SoloControllo`
> **non apre MT5**: nessun `n`, nessun PF, nessun DD, **nessun S0** e —
> soprattutto — **NESSUN AUTOTEST**, che si legge **eseguendo**. Conferma gli
> **artefatti** e **la compilabilità**, mai i numeri.

---

## 2️⃣ POI la corsa vera — **solo dopo aver firmato le otto decisioni**

Se hai tolto il `[DA FIRMARE]` dal file dei criteri, il gate si apre da solo e
`-CriteriFirmati` non serve. Se preferisci **firmare in riga**, aggiungilo: la
firma finisce **scritta nel referto**.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $t0=Get-Date; $pin='5a9d5e04a64677d3b9cb678c52b251b4ece94721'; $p="$env:USERPROFILE\RIGA_R109.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R109_ATREXH.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R109_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -CriteriFirmati; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem "$env:USERPROFILE\Desktop\R109_ATREXH_*.zip" -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($rc -eq 2){ Write-Host '!!! CRITERI NON FIRMATI: non e'' partito NIENTE e NON c''e'' nessuno zip. Leggi le otto decisioni qui sopra.' -ForegroundColor Red }
    elseif($z.Count -eq 0){ Write-Host '!!! NESSUNO ZIP DI ADESSO: la riga si e'' fermata prima della raccolta. Copia lo SCHERMO, non cercare file.' -ForegroundColor Red }
    else { Write-Host ('ZIP DA MANDARE: ' + $z[0].FullName) -ForegroundColor Green;
           if($rc -ne 0){ Write-Host 'ESITO: PARZIALE, SCREEN O FERMO - lo zip esiste: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } } }
```

Si incolla **il blocco INTERO**: è **un comando solo** (checklist **21**). Tre
righe staccate sarebbero tre comandi indipendenti, e un `throw` alla prima non
fermerebbe le altre.

> ⚠️ **Perché qui il messaggio è GIALLO e nel giro a vuoto è ROSSO.** Nella
> corsa vera `exit 1` può voler dire _"la corsa è riuscita e la risposta non ti
> piace"_ — per esempio **un cancello zero S0a FALLITO, che è LA RISPOSTA del
> round e non un guasto**. Gli artefatti **esistono** e vanno mandati lo stesso.

### 🔁 Se serve riprendere

> ⚠️ **Ogni riga di ripresa è un BLOCCO INTERO, con il suo `irm` e la sua
> guardia** (checklist **42**). `$p` e `$pin` nascono **dentro** il `& { ... }`
> del blocco qui sopra, che è uno **scope figlio**: quando quel blocco finisce
> **non esistono più**. Una riga `& $p -Pin $pin ...` incollata da sola in una
> console nuova muore; e — peggio — incollata in una console **ancora calda**
> funziona, ma riusa la **copia locale già scaricata** e il **pin di prima** (è
> il difetto del 10/08).

**Un simbolo solo** (qui U30USD, l'unico con la profondità dei tick **misurata**):

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $t0=Get-Date; $pin='5a9d5e04a64677d3b9cb678c52b251b4ece94721'; $p="$env:USERPROFILE\RIGA_R109.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R109_ATREXH.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R109_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -CriteriFirmati -SoloSimbolo 'U30USD'; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem "$env:USERPROFILE\Desktop\R109_ATREXH_*.zip" -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($rc -eq 2){ Write-Host '!!! CRITERI NON FIRMATI: non e'' partito NIENTE e NON c''e'' nessuno zip.' -ForegroundColor Red }
    elseif($z.Count -eq 0){ Write-Host '!!! NESSUNO ZIP DI ADESSO: la riga si e'' fermata prima della raccolta. Copia lo SCHERMO, non cercare file.' -ForegroundColor Red }
    else { Write-Host ('ZIP DA MANDARE: ' + $z[0].FullName) -ForegroundColor Green;
           if($rc -ne 0){ Write-Host 'ESITO: PARZIALE, SCREEN O FERMO - lo zip esiste: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } } }
```

**Due simboli** — ⚠️ **l'elenco va FRA APICI** (checklist **65**: senza, la
virgola fa un **array** e il binder lo unisce con uno spazio): stessa riga con
`-SoloSimbolo 'D30EUR,NASUSD'`.

**Una cella sola** (un lato solo di un simbolo): stessa riga con
`-SoloCella 'R109_U30USD_01_short.txt'`.

> 🧷 **In tutti i casi il COLLAUDO DELL'AUTOTEST rigira.** Costa minuti, ed è la
> prova che il motore ragiona come la sua firma: senza, i numeri **non si
> convalidano**.

### 🩺 E se il tempo dei tick reali fosse proibitivo: lo SCREEN veloce

Stessa riga con `-ScreenOhlcM15`.

🔴 **E QUESTO GIRO NON PUÒ PRODURRE UN VERDETTO, per costruzione.** Su M5/M15
**l'OHLC inganna — ed è MISURATO in casa** (`REGISTRO_TEST.md` §2: _"in OHLC i
Live5m davano numeri finti enormi (+129k DAX, +30k Nasdaq). In real tick:
morti."_). ⚠️ **E su QUESTO motore morde più del solito**: l'ingresso nasce da
un **estremo di barra** (`low[1]`/`high[1]`) e lo stop sta **a un tick dal
minimo** (buffer 0) → in OHLC il simulatore **non sa in che ordine** il prezzo
ha visitato high e low dentro la barra, quindi **stop e target dello stesso
trade sono decisi da un'ipotesi**.

Nel driver è un **`if`, non una frase** (checklist **67**): ogni riga esce
`ESITO = NON GIUDICABILE`, **nessun verdetto S0a** viene dato, la cartella si
chiama `SCREENOHLC` e l'uscita **non è 0**. Al massimo produce **il permesso**
di un giro a tick reali.

---

### 📅 LE DUE RIGHE CHE CLAUDIO DEVE LEGGERE NEL REFERTO, PRIMA DI MANDARE LO ZIP

Aprire `REFERTO_R109.txt` e guardare **due righe in testa**, in quest'ordine:

1. **`modo:`** — dice `CORSA` (il round), `CONTROLLO` (giro a vuoto: **non è il
   round, non si manda come risultato**) o `SCREENOHLC` (**non giudicabile**);
2. **`data:`** — **deve essere di ADESSO**. Se è di ieri è un referto
   **stantio**: si guarda il nome della cartella sul Desktop (porta data e ora)
   e si rifà.

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul Desktop: `R109_ATREXH_<MODO>_<data>_<ora>` — dentro, **per nome**:

- **`REFERTO_R109.txt`** ← **è questo che conta**;
- **6 CSV** di ottimizzazione (2 righe l'uno: le gemelle di controllo) —
  `ABTG_AtrExhaustVol_<SIMB>_<cella>_INTERA.csv`;
- **6 report `.htm`** delle passate singole (`<SIMB>_<cella>_report_singola.htm`)
  — ⚠️ **sono la fonte di TUTTO il PASSO 0**: conteggio, take in punti indice,
  durata in barre, peggior giornata. Se mancano, il cancello zero non esiste;
- **13 `.ini`**, quelli che hanno girato davvero, **compreso
  `collaudo_autotest.ini`** (che serve anche a rileggere l'autotest a mano);
- i **sei file prova al pin**, la **misura dei tick** dove esiste
  (`misura_tick_<SIMB>.csv`) **e il suo referto gemello**
  `REFERTO_MISURA_TICK_<SIMB>.txt`, che è l'unico posto dove sta la **data
  della misura**;
- **`compile_ABTG_AtrExhaustVol.log`** ← 🔴 **su questo round è il secondo file
  più importante dopo il referto**: è il verbale della prima compilazione;
- i file per-trade `<SIMB>_<cella>_pertrade_singola.csv`, quando l'EA li scrive.

---

## 🚩 LE COSE DA GUARDARE PER PRIME NEL REFERTO

1. 🧷 **IL GATE A0 (AUTOTEST).** Deve dire **`SUPERATO`**. Se dice **`DIVERGE`**
   il round si è fermato da solo e **non c'è niente da leggere**: c'è da
   guardare il codice. Se dice **`NON LETTO`**, **ogni numero del referto è
   `NON CONVALIDATO`** — e "non letto" **non è** "superato".

   > 🟡 **MA DA CHE PARTE STA IL DUBBIO, detto prima di leggerlo.**
   > `NON LETTO` **non è un mezzo-`DIVERGE`** e **non è un indizio contro
   > l'EA**: è **incertezza NOSTRA**. Le **cinque radici** in cui il driver
   > cerca il log dell'agente del tester (`<dati>\Tester`, `<dati>\MQL5\Logs`,
   > `<dati>\logs`, `<Terminal>\Tester`, `<installazione>\Tester`) **non sono
   > mai state misurate su un MT5 vero**: sono l'ipotesi migliore di chi ha
   > scritto la riga. Se il motore divergesse davvero l'esito sarebbe
   > **`DIVERGE`**, e il round si sarebbe **già fermato**.
   > 👉 **Si toglie in cinque minuti**: MT5 → Strategy Tester → ricarica
   > `collaudo_autotest.ini` (è nello zip) in **test singolo** → scheda
   > **Esperti** → copia in chat le righe `[ATREXH][AUTOTEST]` **e dimmi in
   > quale cartella stava il file**, così la prossima riga cerca nel posto
   > **misurato** invece che nei cinque ipotizzati.
2. 📊 **IL PASSO 0, PRIMA TABELLA: SI CONTA.** `n`, giorni operativi,
   **`MAX/GG`**, **`AL-CAP`**, `OP/SED`. ⚠️ **`AL-CAP` è la colonna che nessuno
   guarda e che cambia la lettura**: se molte giornate hanno toccato il cap di
   3, **`OP/SED` è un limite inferiore**, non la frequenza del motore.
   L'attesa dichiarata prima era **0,5-2 operazioni al giorno per lato**, ed era
   una **[STIMA del cacciatore]**, mai una misura nostra. **Se `n` esce molto
   più basso, quello è già un risultato**: è la frequenza la ragione per cui
   questo round esiste.
3. 🚨 **IL CANCELLO ZERO S0a — si legge PRIMA di qualunque PF.** Il take in
   **punti indice** copre il costo? **Tre stati**: `SUPERATO`, `FALLITO`, e
   **`SOSPESO`** — quando il rapporto cade fra **2,5x e 3,5x** il verdetto
   **non si dà**, perché la soglia poggia su uno spread **non misurato**.
   📏 Il metro: `R98` è stato bocciato in una riga con **−0,31 punti indice** di
   lordo medio su 410 operazioni.
4. 🧨 **`PERDmed` — la perdita mediana, che è la miglior stima di R.** Le
   perdenti escono allo stop. **Sotto ~5 punti indice** vuol dire stop stretto →
   **lotto grande** → e **R55 ha misurato che 1,5 punti indice di slippage
   sfondavano il 10%** sull'ORB. Il pavimento `InpMinSLPts` esiste ed è
   **spento**: è la domanda del round dopo.
5. ⏱️ **LA DURATA IN BARRE.** Non è un cancello, è una misura. Se la mediana
   esce **1-3 barre**, va letto come **allarme sulla robustezza anche a
   cancelli verdi**: `arXiv 2605.04004` §6.2 misura che i soli segnali intraday
   sopravvissuti alla falsificazione tengono **12-15 barre**, non 1-6.
6. 🧱 **LA TABELLA `G4: LA PEGGIOR GIORNATA`.** Muro prop **−5,00% su 100k**, e
   la peggiore misurata in casa è **−2,06%** (R51). Su un motore a 3
   operazioni/giorno **per lato** e su **tre indici correlati** — DAX, Dow e
   Nasdaq si esauriscono spesso **insieme** — **il numero da guardare non è il
   DD totale, è la peggior giornata**. 👉 **Il rischio non si sospende mai**
   (Emendamento regola B): si legge a qualunque `n`, anche col merito sospeso.
7. ⚖️ **IL CONFRONTO FRA I DUE LATI.** È la domanda della regola dei due lati:
   in un toro, un motore controtendenza **non tratta i due lati allo stesso
   modo**. Guardare `n`, take, `PERDmed` e peggior giornata **lato per lato**,
   e **non** sommarli (§ 3 in testa a questa pagina).
8. 🎫 **LE TRE RIGHE `profondita' TICK`.** U30USD è misurato; **D30EUR e NASUSD
   diranno `NON MISURATA`**. È la decisione **D2**, ed è **il rischio più
   concreto del round**.
9. 🎚️ **I CANARINI.** `n` sotto **150** → merito **sospeso** — e qui lo era
   **già** per costruzione. Sotto **20** → **NON MISURABILE**, mai *"non
   funziona"*.

---

## 🔴 LE SETTE COSE CHE R109 **NON** DICE

1. **NON promuove e NON boccia niente in forward** (G5). Lo dice la tesi stessa,
   in testa: **_"NON va in forward."_**
2. **NON giudica il MERITO**: un solo regime, motore controtendenza, nessun
   out-of-sample. Il PF che esce dice **quanto è costato opporsi a questo toro**.
3. **NON ha girato nessuna ablazione** (D1): prossimità ATR, grilletto CLOSE,
   buffer/pavimento SL, parziale+BE+trailing restano **tutte da misurare**, e
   **solo se** questo round passa S0.
4. **NON misura lo spread.** La soglia di S0a usa un valore **dichiarato**. Lo
   strumento giusto è già stato promosso il 23/08 e **mai usato**: `RealCost
   Spread P95 Logger MT5` (Code Base 74148).
5. **NON misura la profondità dei tick** su D30EUR e NASUSD (D2).
6. **NON fa la prova di regime, e non la può fare**: il broker non ha altro
   storico, e i Dukascopy `_EXT` sugli indici **non esistono ancora**.
7. **NON confronta niente col TradingView dell'autore**: Pine → MQL5 **non è un
   porting, è una riscrittura**, e i conteggi divergono **per costruzione** —
   cap giornaliero, media del volume, `STOPS_LEVEL`, e lo **short
   simmetrizzato** (`ATREXHAUST_TESI.md` § 4.3). **Nessun numero d'autore è
   entrato in nessun documento di questo round.**

---

## ✅ COSA È GIÀ STATO VERIFICATO — **eseguendo**, dal builder

- ✅ **parse reale**, non analisi statica: `/opt/pwsh/pwsh` +
  `[Parser]::ParseFile` → **0 errori**, 18.109 token; **ASCII puro** (0 byte
  non-ASCII, regola del 17/08); **0 token PS7-only** (niente `&&`, niente
  ternari); `lint_ps1.py` **pulito**;
- ✅ **la precedenza virgola/`+`** (`@($a,$b,$a+2)` che duplica `$a`) verificata
  **sull'AST, non a grep**: **52 array literal, 0 elementi con espressione
  binaria non parentesizzata**;
- ✅ **0 comandi non risolti** e **32 funzioni** tutte definite prima dell'uso;
- ✅ **il GATE DEL PORTING provato sui sei file veri**, sotto cultura **`it-IT`**
  (quella del PC): **42 input estratti dal sorgente**, 41 pinnati per file,
  **6 file su 6 PORTING OK**. E i **controlli negativi**: `InpVolSpikeMult`
  portato a 1.8 → **fermato**; enum tradotte (`EX_PROX_PERC`→`0`,
  `EX_TRIG_CLOSE`→`1`); `0` vs `0.0` → **uguali**; `true` vs `True` →
  **diversi** (i file restano uniformi);
- ✅ **il gate della STELLA**: le tre coppie differiscono **esattamente** su
  `InpAllowLong, InpAllowShort, InpMagic, InpComment` — **quattro righe, non una
  di più**;
- ✅ **`controlla_prova.py` ESITO OK** sui sei file;
- ✅ **il parser dei DEAL e il PASSO 0 provati su un report finto con
  intestazione italiana e i numeri calcolati A MANO PRIMA**: n **5**, take
  mediano **14,0 punti indice**, perdita mediana **6,0**, durata mediana **6
  barre M15**, giorni operativi **2**, **max 3 in un giorno**, **1 giornata al
  cap**, sedute **4**, op/seduta **1,25**, peggior giornata **−0,014%** il
  2024.10.07 — **tutti centrati**. Più i **controlli negativi**: report
  **senza colonna Prezzo** (→ *"senza il prezzo il take in punti indice NON
  esiste"*), **sequenza in/out spaiata** (→ `NON AFFIDABILE`, e le misure
  restano `n/d`: **non si stimano**), **volume di uscita diverso** = parziale
  inatteso (→ `NON AFFIDABILE`), report in **UTF-16** (→ letto lo stesso);
- ✅ **il cancello S0a nei suoi stati** (spread 2,0): 14,0 → `SUPERATO` (8,00x);
  4,1 → `SOSPESO` (3,05x); 3,0 → `SOSPESO` (2,50x); 1,0 → `FALLITO` (1,50x);
  non misurato → `NON MISURATO`;
- ✅ **le due fabbriche di `.ini` provate**: 41 parametri, `Period=M15`,
  `Model` 4/1, `AllowLiveTrading=false` in **entrambe**, `MaxBars`, il lato
  giusto, `InpAutoTest=true`, **zero `||` nella passata singola** (in
  ottimizzazione non esiste nessun report `.htm`: il PASSO 0 resterebbe muto),
  **un solo asse Y nella gemella**, **zero byte non-ASCII**. E il **controllo
  negativo**: file prova di 40 righe → **la fabbrica muore**;
- ✅ **la convenzione di sentinella**: `-1` → `n/d`, `-999999` → `n/d`, `99.9`
  → `n/d`, e i valori veri passano (`-2.06` resta `-2.06`, `0` resta `0.00`);
- ✅ **`NumInv` sotto `it-IT`**: `45 018.00` (migliaia con lo spazio di MT5) →
  `45018`; `1.5` → **uno-virgola-cinque**, non quindici;
- ✅ **gli switch e i loro esiti, eseguiti**: `-SoloControllo` senza `-Pin` →
  `exit 1` con *"MANCA -Pin"*; `-SoloSimbolo 'PIPPO'` → `exit 1` con l'elenco
  dei nomi validi; `-SoloCella 'nope.txt'` → `exit 1`;
  🔴 **`-SoloControlo` (una L) e `-Riprendi` → errore di binding, lo script
  MUORE** — è il `[CmdletBinding()]` del punto **71**;
- ✅ **magic `7744xx` VERGINI**, `grep` rifatto: **4 occorrenze in tutto il
  repo, tutte del valore `774401`**, e stanno solo nel sorgente nuovo e nella
  sua tesi. `774401` è **nella lista dei vietati**.

---

## 🔎 IL VERIFICATORE-STRINGHE — **`FAIL → CORRETTO`, sei difetti (25/08)**

Rieseguito tutto sopra (`/opt/pwsh/pwsh`): parse **0 errori**, **ASCII puro**,
**0 comandi non risolti**, **32 funzioni**, **52 array literal / 0 elementi con
espressione binaria non parentesizzata**, gate del porting **6/6 OK** sotto
`it-IT`, i **cinque gate sul sorgente fatti fallire uno per uno** su copie
corrotte (pivot che ridipinge, volume da shift 0, `return(true)` di cortesia,
interruttore del volume, volume fuori dall'AND — **tutti FERMANO**), il **gate
A0 nei suoi tre stati** con log finti (`SUPERATO` · `DIVERGE` · `NON LETTO`, più
log **vecchio** → non letto, log **UTF-16** → letto, variante accesa → segnalata),
il **PASSO 0** sul report finto coi **17 numeri calcolati a mano prima** (tutti
centrati), `-SoloControlo` con una L e `-Riprendi` → **errore di binding, lo
script muore**.

### 🔴 SECONDO GIRO — i due difetti trovati **sul PC di Claudio**, non qui

Il pin **`cf6126d` è BRUCIATO**: il suo giro a vuoto (21:48) è uscito **`ESITO:
OK`** con dentro un difetto che cambiava **la finestra del round**. L'ha trovato
**Claudio**, aprendo un `.ini` dello zip. È la lezione di metodo di tutta la
serata: **provare una funzione chiamandola da un test dimostra che la funzione è
giusta, non che riceve gli argomenti giusti.**

| | difetto | classe | correzione |
|---|---|---|---|
| **8** | 🔠 **`ToDate` CORROTTO in tutti e 12 gli `.ini` delle celle.** La finestra si chiamava `$Da` / `$A`; novecento righe sotto il **gate della STELLA** faceva `$a = $Vive[...]` a scope di script — e **in PowerShell `$a` È `$A`**. La data di fine diventava un **array di 41 stringhe**, che un parametro `[string]` unisce con `$OFS` (**uno spazio**): `ToDate=InpUsaGuardian=true\|\|true\|\|0\|\|true\|\|N InpPivotLeft=5\|\|...`. Lo stesso testo nel referto, sezione *LA FINESTRA*. ⚠️ **Il giro a vuoto è uscito 0**: le fabbriche controllavano 41 parametri, `Period`, `Model`, `Symbol`, asse Y, magic e `AllowLiveTrading` — **mai le DATE**. E a schermo la riga `FINESTRA :` si stampa **prima** del danno, quindi sembrava giusta | 🆕 **classe nuova → punto 79** | `$Da`/`$A` → **`$DataDa`/`$DataA`** (nomi lunghi = non collidibili); **`GateDate`** in **tutte e due** le fabbriche (forma `aaaa.mm.gg` + giorno che esiste + `ToDate > FromDate`) e **`GateDateIni`** sullo **stato finale del testo**; il **giro a vuoto rilegge le due righe dall'`.ini`**; il **referto dichiara** una finestra impossibile invece di mostrarla |
| **9** | 🧨 **Il gemello dello stesso difetto, non ancora esploso**: l'ArrayList del referto si chiamava **`$R`** e la sua costruzione conteneva `foreach($r in $AutotestRighe){ [void]$R.Add(...) }`. Al primo giro `$R` diventa una **stringa** → *"[System.String] does not contain a method named 'Add'"*. **Invisibile nel giro a vuoto** (l'autotest è vuoto), **fatale nella corsa vera**: referto **troncato** alla sezione dell'autotest e `RACCOLTA PARZIALE` **dopo 3-12 ore di tick reali**. Riprodotto | 🆕 **punto 79** (stessa classe) | `$R` → **`$RefTxt`** (180 occorrenze) |
| **10** | ✍️ **Il gate della firma non riconosceva i criteri FIRMATI.** `R109_CRITERI.md` porta la firma di Claudio in testa (*"FIRMA: «FIRMO» — 25/08 sera"*) **e** due `[DA FIRMARE]` residui **nella prosa che spiega il lucchetto**. Il `Select-String` secco li trovava → **`exit 2` su criteri firmati** | **77** (il token cercato dove lo si spiega) | il gate legge, **in quest'ordine**: la riga di stato `STATO_CRITERI_R109:`, poi la **FIRMA in testa**, poi — solo come ultima spiaggia — `[DA FIRMARE]`, **dichiarando l'ambiguità** in un rilievo |

> 📝 **Una riga che conviene aggiungere in testa a `R109_CRITERI.md`** (non
> l'ho scritta io: la firma è di Claudio, non del verificatore) —
> `STATO_CRITERI_R109: FIRMATI`. Con quella, il gate non ha più bisogno di
> dedurre niente. **Senza, funziona lo stesso**: la firma in testa basta.

---

### PRIMO GIRO — **i sette difetti** trovati qui, prima dell'invio (tre sono **classi nuove**, punti **76, 77, 78**):

| | difetto | classe | correzione |
|---|---|---|---|
| **1** | 📅 **L'età della misura dei tick non veniva mai calcolata**, e la data stampata era la **prima data dello STORICO** (`2024.09.26`) sotto l'etichetta `[file: ...]` — su una misura fatta **6 giorni prima**. I criteri § 4.2 promettono *"sopra i 30 giorni esce un rilievo anche se il file c'è"*: non esisteva | 🆕 **classe nuova → punto 78** (+ **57**, **23**, **44**) | il driver scarica anche `REFERTO_MISURA_TICK_<SIMB>.txt`, legge la sua riga `data:`, stampa **`[misurata il ... (N giorni fa)]`** e alza un **RILIEVO sopra i 30 giorni**. Se il referto gemello manca, dichiara che **il controllo NON è stato fatto** |
| **2** | 🧨 **La peggior giornata poteva uscire `0.00`** su una misura inesistente: se i numeri del report non si convertono (formato diverso da quello atteso) `$netto` restava `0.0` su ogni deal, e G4 — *"il numero da guardare"* — stampava **zero**. **Riprodotto** con un report a decimali-virgola | **66** (sentinella applicata a metà) — ed è il difetto di R103 rinato sulla colonna peggiore | controllo positivo **sul VALORE** e non solo sulla colonna: cella **piena** che non si converte → `NON AFFIDABILE`, tutte le misure `n/d`. Cella **vuota** (il profitto della riga `in`) resta zero: **nessun falso positivo** (checklist 55) |
| **3** | 🥫 **Pin sbagliato → riquadro rosso "I CRITERI NON SONO FIRMATI"** e `exit 2`. Mandava a firmare otto decisioni per un **404** | **22** / **47** (messaggio che dichiara una causa non misurata) | `NON LETTI` ≠ `NON FIRMATI`: ora si ferma con la causa vera, il pin scritto per esteso, e **passa dalla raccolta** (referto + zip) |
| **4** | 🧷 **`NON LETTO` del gate A0 non diceva da che parte sta il dubbio** — le cinque radici del log non sono mai state misurate su MT5 vero | **17** (lo strumento dato per presente), applicata al **percorso** | referto e foglio ora dicono che `NON LETTO` è **incertezza nostra**, non un indizio contro l'EA, e come toglierla in cinque minuti |
| **5** | 🔤 **`(D30EUR, NASUSD, U30USD)` in testa, `(D30EUR, U30USD, NASUSD)` in tutte le tabelle** — due ordini nella stessa corsa | **70** | si stampa l'**ordine reale**, e lo si dichiara |
| **6** | 🫥 **`"... '& $p ...' incollata da sola"` in APICI DOPPI**: `$p` non è il path dello script, è **la variabile del `foreach` dei PROBLEMI venti righe sopra** — che in PowerShell **sopravvive al ciclo**. Senza problemi la frase usciva mozza (`'&  ...'`); **con** problemi ci finiva dentro **il testo intero dell'ultimo problema**. Trovato **eseguendo**, non leggendo | 🆕 **classe nuova → punto 76** | apici singoli |
| **7** | ♻️ **La ricetta del pin, in questa pagina, riscriveva SE STESSA**: `sed s/@@PIN@@/$SHA/g` su tutta la pagina toccava anche la riga del `sed`, quella del `grep` di controllo e la prosa. Dopo il primo pin **la ricetta era morta** — e la ri-pinnatura succede sul serio (25/08, storico indici: `826f008` non conteneva l'ultima correzione). **Riprodotto due volte**: anche la prima correzione si riscriveva | 🆕 **classe nuova → punto 77** | token composto in una variabile (`TOK='@@PIN'"@@"`), sostituzione dei **soli quattro punti d'uso**, **DUE conteggi** (`3` e `0`, perché "0 segnaposto rimasti" lo supera anche un `sed` che non ha matchato niente), e la **ricetta di RI-PINNATURA** in fondo. Provate tutte e due su una copia |

🟢 **Indurimento, oltre ai difetti**: la regex del gate del porting ora copre
anche `sinput` e `input static` (le due forme legali di MQL5 che avrebbe
mancato), e **i suoi limiti sono dichiarati nel codice**: due input sulla stessa
riga, commento `/* */` prima del valore e `input` indentato **non si estraggono
e FANNO FERMARE il gate** (sono *fail-closed*, provati uno per uno).
L'indentazione resta fuori **di proposito**: `^\s*input` prenderebbe anche le
righe dentro un commento a blocco e inventerebbe input inesistenti (checklist 55).

🟡 **Non verificato, e va detto**: tutto ciò che richiede **MT5** — **la
compilazione vera** (che su questo EA è *la* domanda), il comportamento del
tester, **dove MT5 scrive il log dell'agente** (difetto 4: cinque radici
**ipotizzate**, mai misurate), **se il tester onori `MaxBars`**, **se i tick
reali ci siano davvero** su D30EUR e NASUSD, **il formato esatto dei numeri nel
report `.htm`** (il difetto 2 ora lo *dichiara* invece di indovinarlo), la
durata reale, e **ogni singolo numero**.

> ⚠️ **I due rischi residui più concreti, dichiarati.**
> **(a) LA COMPILAZIONE**: è la prima, e può semplicemente fallire. Il driver è
> costruito per fermarsi bene e restituire il log — è un esito, non un guasto.
> **(b) I TICK su D30EUR e NASUSD**: è la decisione **D2**, ed è l'unica che può
> rendere **falso** tutto il round senza che nessuno se ne accorga. Se Claudio
> firma *"si misura prima"*, R109 aspetta mezz'ora e parte su basi solide.

---

_Foglio del builder, 25/08/2026. **Le stringhe non sono definitive**: passano
dal verificatore-stringhe, e il pin si mette dopo._
