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

> 🟡 **NON È ANCORA PASSATO DAL VERIFICATORE-STRINGHE.** Questo foglio esce dal
> **builder**. Le stringhe qui dentro **non sono definitive**: il pin è un
> **segnaposto** (`@@PIN@@`) e va sostituito **dopo** il passaggio del
> verificatore, che può ancora cambiare il driver.

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

## 📌 IL PIN — **`@@PIN@@`**

```
@@PIN@@
```

🔴 **`@@PIN@@` È UN SEGNAPOSTO E VA SOSTITUITO PRIMA DI DETTARE LA RIGA.**
Il driver **non è ancora passato dal verificatore-stringhe**: finché non passa,
un pin vero sarebbe una promessa che non possiamo mantenere. Sequenza, in
quest'ordine — **due commit, non uno**:

```bash
# 1. i file che il driver SCARICA (dopo le eventuali correzioni del verificatore)
git add backtest_pipeline/righe/RIGA_R109_ATREXH.ps1 \
        backtest_pipeline/risultati_archivio/R109_CRITERI.md \
        backtest_pipeline/prove/R109_*.txt
git commit -m "R109: driver + criteri + file prova"
git push
SHA=$(git rev-parse HEAD)
# 2. il pin dentro questa pagina, che il driver NON scarica
sed -i "s/@@PIN@@/$SHA/g" backtest_pipeline/righe/RIGA_R109_DA_MANDARE.md
git add backtest_pipeline/righe/RIGA_R109_DA_MANDARE.md && git commit -m "R109: pin" && git push
grep -c "@@PIN@@" backtest_pipeline/righe/RIGA_R109_DA_MANDARE.md   # DEVE dare 0
```

⚠️ Se il segnaposto resta, l'`irm` prende un **404**, `-ErrorAction Stop` è
terminante e **la riga muore lì**: non parte niente. È il comportamento voluto,
ma è un giro sprecato — meglio il `grep -c` qui sopra.

**Cosa scarica il driver al pin** (e quindi cosa deve essere già in repo):
i **sei** file prova, `R109_CRITERI.md`, il sorgente
`mql5/Experts/ABTG_AtrExhaustVol.mq5`, l'include
`mql5/Include/ABTG_PausaGuardian.mqh` e — dove esiste —
`risultati_archivio/misura_tick/misura_tick_<SIMBOLO>.csv`.
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
- **NESSUNA SEDIA VIVA VIENE TOCCATA.** Magic **vergini, blocco `7744xx`**:
  `grep -rno '7744[0-9][0-9]'` su tutto il repo dà **4 occorrenze, tutte del
  valore `774401`**, e stanno **solo** nel sorgente nuovo e nella sua tesi.
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
    $t0=Get-Date; $pin='@@PIN@@'; $p="$env:USERPROFILE\RIGA_R109.ps1"; Remove-Item $p -EA SilentlyContinue;
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
    simboli ......................  3   (D30EUR, NASUSD, U30USD)
    celle ........................  6   (long: 3 | short: 3)
    passate ......................  13   (1 collaudo autotest + 2 per cella: singola + gemelle)
    righe vive per file prova ....  41   (42 input del sorgente meno InpNewsCurrencies)
    righe per CSV di ottimizz. ...  2   (le due gemelle di controllo)

    FINESTRA : 2024.09.26 -> 2026.08.21   modello 4 (TICK REALI)
```

> ⚠️ **`(D30EUR, NASUSD, U30USD)` è in ORDINE ALFABETICO, non nell'ordine del
> dossier.** La lista è costruita con `Sort-Object -Unique`, che **ordina**, e
> il driver lo dice da solo a schermo due righe sotto. **Un falso allarme qui
> costa un giro** — è il punto **70**, pagato su R107.

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
  non è un guasto del driver, è un buco vero del repo;
- `include installato: ABTG_PausaGuardian.mqh (... byte)`;
- 🔴 **`COMPILATO ABTG_AtrExhaustVol v1.00 (.ex5 riscritto adesso, rc=0, warning: N)`**
  — **è questa la riga che conta**. Se invece esce il riquadro rosso
  *"LA PRIMA COMPILAZIONE DI QUESTO EA NON E' RIUSCITA"*, **copia in chat le
  righe con `ERROR`** che il driver stampa apposta separate: sono quelle da
  correggere;
- in fondo: `.ini scritti e verificati: 13 su 13` e
  `ESITO: GIRO A VUOTO COMPLETATO`.

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
    $t0=Get-Date; $pin='@@PIN@@'; $p="$env:USERPROFILE\RIGA_R109.ps1"; Remove-Item $p -EA SilentlyContinue;
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
    $t0=Get-Date; $pin='@@PIN@@'; $p="$env:USERPROFILE\RIGA_R109.ps1"; Remove-Item $p -EA SilentlyContinue;
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
- i **sei file prova al pin** e la misura dei tick dove esiste;
- **`compile_ABTG_AtrExhaustVol.log`** ← 🔴 **su questo round è il secondo file
  più importante dopo il referto**: è il verbale della prima compilazione;
- i file per-trade `<SIMB>_<cella>_pertrade_singola.csv`, quando l'EA li scrive.

---

## 🚩 LE COSE DA GUARDARE PER PRIME NEL REFERTO

1. 🧷 **IL GATE A0 (AUTOTEST).** Deve dire **`SUPERATO`**. Se dice **`DIVERGE`**
   il round si è fermato da solo e **non c'è niente da leggere**: c'è da
   guardare il codice. Se dice **`NON LETTO`**, **ogni numero del referto è
   `NON CONVALIDATO`** — e "non letto" **non è** "superato".
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

🟡 **Non verificato, e va detto**: tutto ciò che richiede **MT5** — **la
compilazione vera** (che su questo EA è *la* domanda), il comportamento del
tester, **dove MT5 scrive il log dell'agente** (il gate A0 lo cerca in cinque
radici e dichiara `NON LETTO` se non lo trova), **se il tester onori `MaxBars`**,
**se i tick reali ci siano davvero** su D30EUR e NASUSD, la durata reale, e
**ogni singolo numero**.

> ⚠️ **I due rischi residui più concreti, dichiarati.**
> **(a) LA COMPILAZIONE**: è la prima, e può semplicemente fallire. Il driver è
> costruito per fermarsi bene e restituire il log — è un esito, non un guasto.
> **(b) I TICK su D30EUR e NASUSD**: è la decisione **D2**, ed è l'unica che può
> rendere **falso** tutto il round senza che nessuno se ne accorga. Se Claudio
> firma *"si misura prima"*, R109 aspetta mezz'ora e parte su basi solide.

---

_Foglio del builder, 25/08/2026. **Le stringhe non sono definitive**: passano
dal verificatore-stringhe, e il pin si mette dopo._
