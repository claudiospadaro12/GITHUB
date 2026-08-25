# 📬 STORICO INDICI — **LE RIGHE DA MANDARE**

**La richiesta**: Claudio, 25/08/2026 — _"per gli Indici cerchiamo di fare i
test con piu' anni di storico"_.
**Criteri**: `risultati_archivio/STORICO_INDICI_CRITERI.md` — ⚠️ **[DA FIRMARE]**, **sei** decisioni.
**Driver**: `righe/RIGA_STORICO_INDICI.ps1` (marcatore `MARCATORE_RIGA_STORICO_INDICI_v1`).
**Script MQL5 nuovo**: `mql5/Scripts/ABTG_ContaBarreEXT.mq5` (`CONTA-EXT-v1`) — **mai compilato**, lo compila il driver.

> ✅ **PASSATE DAL VERIFICATORE-STRINGHE il 25/08** (verdetto FAIL → corretto:
> 17 difetti, di cui **4 riprodotti eseguendo**). Le correzioni sono nel
> driver e nel `.mq5`: **il pin di quelle righe non e' piu' `bcc483f`**.

## 📌 IL PIN

`bcc483f14c6c93cbb546e742a35538e2e8ebc4c8` **NON VA PIU' BENE**: contiene la
versione con il preset del conteggio che usciva **su una riga sola** e la
conversione a 16 anni in un colpo solo (~3,8 GB di RAM, misurati).

**Il pin da usare e' quello del commit che porta le correzioni**, e nelle **tre
righe di lancio** qui sotto sta scritto come `490f11252820da5c61d29f7afd5f141a55614967`. Dopo il commit+push si
esegue **una volta sola** questo (sostituisce **tutte** le occorrenze del
segnaposto, compresa quella dentro il comando stesso: e' fatto apposta, dopo
questo giro il foglio e' pinnato e non si ri-sostituisce):

```powershell
$sha = (git rev-parse HEAD)
(Get-Content backtest_pipeline\righe\RIGA_STORICO_INDICI_DA_MANDARE.md -Raw).Replace('490f11252820da5c61d29f7afd5f141a55614967',$sha) |
  Set-Content backtest_pipeline\righe\RIGA_STORICO_INDICI_DA_MANDARE.md -Encoding UTF8
```

⚠️ Il commit deve contenere **tutti e tre** gli artefatti (driver, criteri,
`.mq5`): il driver li scarica **tutti al pin**.

---

## 🔴 LE QUATTRO COSE DA DIRE A CLAUDIO PRIMA DELLE RIGHE

### 1. 🧊 **Piu' anni NON sblocca i test sugli indici. Il collo di bottiglia e' un altro.**

Gli indici `_EXT` gia' importati (`NASUSD_EXT`, `225JPY_EXT`, `SPXUSD_EXT`,
2019→2026) sono **IN FRIGO** perche' il **cancello ZERO e' chiuso**: diff media
H1 contro il nativo BCM **0,061-0,101%** contro il **≤0,05%** richiesto
(`REFERTO_HISTDATA_FATTIBILITA.md` §14-15). La cura DST della `_v2` e' stata
**misurata** e **peggiora** del 7,7-8,6%.

> Un `NASUSD_EXT` dal 2010 resta in frigo **esattamente come quello dal 2019**.
> Questo giro produce **DATI**. Il permesso di usarli e' un'altra firma.

### 2. ✅ **La sonda del Dow era gia' tornata. Due volte.**

| grafia | esito |
|---|---|
| **`USA30IDXUSD`** | ✅ **OK, 49.445 byte — primo anno 2012** |
| `US30IDXUSD` · `USA30USD` · `WS30IDXUSD` · `GERIDXEUR` | ❌ ASSENTE (404 **veri**) |
| `DJIIDXUSD` (`ERRORE 0`) · `USA2000IDXUSD` (`503`) | ⚠️ **non misurate** — e non ci servono |

**Il driver NON la rilancia**: la dichiara `GIA' MISURATA (giro3 15/08)` nel
referto. Le due caselle mai misurate si rifanno solo con `-RifaiSondaDow`
(che sonda quelle due **piu' `USA30IDXUSD` come controllo positivo**: se torna
rosso anche lui, il guasto e' la rete e non le caselle).

### 3. 💀 **Dukascopy per 14 anni di tick e' gia' stato misurato: fuori portata.**

`REFERTO_DUKASCOPY_FATTIBILITA.md`: corsa vera `DEUIDXEUR` **dal PC di
Claudio**, **25 giorni su 2389 in 1h43m** = **~4 minuti per giorno**. DAX +
Nasdaq dal 2012 = **~25 giorni di crawl**. Per questo D-A e' **HistData**
(1 ZIP annuale invece di 7.500 file all'ora, e parte dal **2010-11**).

### 4. 🧠 **LA RAM DELLA CONVERSIONE — misurata, e cambia come gira il driver**

`--converti` tiene **tutte** le barre in memoria. Misurato il 25/08 eseguendo
il suo parser su 400.000 barre vere: **~690 byte a barra**.

| finestra | barre | RAM in un colpo solo |
|---|---:|---:|
| 2019-2026 (la corsa **gia' girata** il 18/08) | 2,5 M | ~1,7 GB |
| **2010-2026 (questa)** | **5,6 M** | **~3,8 GB** |

Il driver adesso converte a **tranche di 8 anni** (`-AnniPerTranche`, default
8) e concatena i pezzi: il picco resta alla taglia **che questo PC ha gia'
retto**. **Nel referto c'e' scritto che il CSV nasce da piu' tranche** — e va
detto, perche' un `_EXT` fatto a pezzi va dichiarato.
Se comparisse lo stesso un `MemoryError`: **rilanciare la stessa riga con
`-AnniPerTranche 4`** (gli anni gia' scaricati non si riscaricano).

---

## ✍️ IL CANCELLO DELLA FIRMA — è CHIUSO

Il driver legge `STORICO_INDICI_CRITERI.md` **al pin** e cerca le righe
`@DECISIONE ... STATO=FIRMATO`. Finché sono `DA_FIRMARE`:

- ✅ il **giro a vuoto gira lo stesso** (legge i criteri, misura lo spazio, non scarica niente);
- 🛑 lo **scarico non parte** e finisce nel referto come `NON SCARICATO (cancello chiuso)`, con i tre problemi `D-A / D-B / D-D NON FIRMATA` scritti uno per riga.

_(Provato eseguendo, in tutti e due i versi: coi criteri `DA_FIRMARE` la corsa
esce **3** e non scarica; con `STATO=FIRMATO` esce **0** e prosegue.)_

**Non esiste nessun `-CriteriFirmati`, apposta.** Si firma nel file
(`STATO=FIRMATO`), si pusha, e **il pin nuovo** va nelle righe.

| | decisione | ✅ proposta | perché |
|---|---|---|---|
| **D-A** | fonte e unità | **`histdata`, barre M1** | i tick pieni a valle **non si possono usare**: un simbolo custom MT5 è fatto di barre (`importa_storico_esterno.ps1` riga 525 — _"il modello 4 (tick reali) NON si usa"_). 9 GB e 25 giorni per un dato che il tester non legge |
| **D-B** | simboli | **`NASUSD`** e basta | è l'unico **promosso da tutti i cancelli** dello strumento (banda OK, DST 91/91, 0 righe scartate). DAX bocciato, Dow assente, S&P e Nikkei in coda **gratis** |
| **D-C** | limiti d'uso | **`SOLO_PROVA_REGIME`** | come i forex `_EXT`, **più** il divieto nuovo: finché il cancello ZERO è chiuso, gli indici `_EXT` non entrano **nemmeno** nella prova di regime |
| **D-D** | finestra | **`2010-2026`** | HistData pubblica gli indici da **novembre 2010**. Si usano **a finestre di regime**, non in una corsa unica (CLAUDE.md, emendamento C) |
| **D-E** | soglia canarino | **`20` ore** | la stessa già usata nella notte #2, decisa **prima** di misurare |
| **D-F** | strada del DAX | **`diagnosi_prima`** | `--diagnosi` sul CSV già sul PC costa **zero rete e minuti**, e **non è mai stato eseguito sui dati veri** |

---

## ▶️ RIGA 0 — **IL GIRO A VUOTO** (2 minuti, niente MT5, niente scarico)

**Cosa fa**: legge i criteri al pin e li stampa uno per uno, stampa la tabella
dei **cinque indici** con chi è dentro e chi è fuori e **perché**, stima lo
spazio, **misura** lo spazio libero, e si ferma.

**Si incolla il blocco INTERO, è UN comando solo.**

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='490f11252820da5c61d29f7afd5f141a55614967';
    $p="$env:USERPROFILE\RIGA_STORICO_INDICI.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_STORICO_INDICI.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_STORICO_INDICI_v1' -Quiet)){ throw 'SCRIPT VECCHIO: il pin non contiene il driver nuovo.' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE -- il referto e lo zip ci sono lo stesso: mandali.' -ForegroundColor Yellow } }
```

📨 **Poi manda**: `Desktop\STORICO_INDICI_<data>_<ora>.zip`.
⚠️ Dentro `REFERTO_STORICO_INDICI.txt` c'è una riga **`data:`**: deve essere di
**ADESSO**. Se è di ieri, hai mandato lo zip di una corsa vecchia.
📖 **Cosa leggere per primo**: la colonna `STATO` delle sei decisioni (adesso
sono tutte `DA_FIRMARE`) e la riga `spazio libero`: **servono ~4 GB liberi**.

---

## ▶️ RIGA 1 — **LO SCARICO** (solo DOPO la firma e il pin nuovo)

**Cosa fa**: canarino di ritmo (cancello), poi scarica **un anno alla volta**,
poi converte **a tranche**, poi scrive il CSV M1 finale. **Ripartibile**: se si
interrompe, si rilancia **la stessa identica riga** e riprende dagli anni che
mancano (provato: interruzione e ripresa, e uno zip troncato a mano viene
**cancellato e riscaricato** invece di restare un buco per sempre).

**Con `-Prepara`** copia il CSV in `MQL5\Files` e scrive i preset. **Non apre
MT5.**

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='490f11252820da5c61d29f7afd5f141a55614967';
    $p="$env:USERPROFILE\RIGA_STORICO_INDICI.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_STORICO_INDICI.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_STORICO_INDICI_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -Prepara -OreMax 6;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE -- e'' gia'' una risposta: manda lo zip, i problemi sono nel referto.' -ForegroundColor Yellow } }
```

⚠️ **Il `$pin` di questa riga dev'essere quello del commit che FIRMA i
criteri** — non quello del giro a vuoto. Col pin vecchio il driver rilegge
`DA_FIRMARE` e non scarica niente (e lo scrive nel referto).

**Serve python** (3.8+, quello vero, **non lo stub del Microsoft Store**): il
driver lo cerca e, se non c'è, **lo dice e si ferma** invece di far finta.

🗑️ **Sul Desktop comparirà anche `histdata_m1.zip` e la cartella
`histdata_m1\`**: li fa lo **strumento**, non noi, e **non sono quelli da
mandare**. Quello da mandare è `STORICO_INDICI_<data>_<ora>.zip`.

---

## ▶️ RIGA 2 — **IMPORT IN MT5 + VERIFICA** (⚠️ **MT5 E METAEDITOR CHIUSI**)

> 🛑 **PRIMA CHIUDI METATRADER *E* METAEDITOR, TUTTE LE ISTANZE.** Il driver si
> rifiuta di partire se li trova aperti, e **non li ammazza**: potrebbe essere
> Claudio che sta guardando un grafico. MT5 riscrive i suoi file all'uscita;
> e **MetaEditor è single-instance**, quindi con una copia già aperta il
> `/compile` torna subito **senza compilare** e il referto direbbe "non
> compila" di uno script sano.
> 🛑 **NON SI LANCIA SUL VPS**: spegnerebbe la flotta in forward.

**Cosa fa**: ripassa lo scarico (gli anni in cache li salta), **rifà la
conversione** (~qualche minuto: è il prezzo di avere il CSV di sicuro fresco),
compila `ABTG_ImportaStoricoEsterno`, importa come `NASUSD_EXT`, **chiude MT5
in modo PULITO** (col kill le barre restano e la **registrazione del simbolo
no** — i 32 lanci a vuoto del 14/08), poi compila e lancia `ABTG_ContaBarreEXT`
e scrive **prima e ultima barra M15 e H1** più il **conteggio barre per anno**.
Il tester gira sempre con `AllowLiveTrading=false`.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $vivi=@(Get-Process -Name terminal64,metaeditor64 -EA SilentlyContinue);
    if($vivi.Count -gt 0){ throw ('APERTO: ' + (($vivi | ForEach-Object { $_.ProcessName } | Sort-Object -Unique) -join ', ') + ' -- chiudi MT5 E MetaEditor (tutte le istanze) e rilancia.') };
    $pin='490f11252820da5c61d29f7afd5f141a55614967';
    $p="$env:USERPROFILE\RIGA_STORICO_INDICI.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_STORICO_INDICI.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_STORICO_INDICI_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -Importa -Verifica -OreMax 4;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE -- manda lo zip: i problemi sono elencati nel referto.' -ForegroundColor Yellow } }
```

**Prima di questa riga, una cosa in MT5** (checklist 36): _Strumenti → Opzioni →
Grafici → **Max barre nel grafico = Illimitato**_. Il driver lo impone
nell'`.ini` della corsa, ma l'impostazione della finestra normale è un'altra
cosa: senza, `ABTG_ContaBarreEXT` conterebbe **100.000 barre tonde** invece
dello storico vero — e infatti quel numero fa scattare un avviso nel referto.

⛔ **`ABTG_ContaBarreEXT` non è mai stato compilato da nessuno.** Se non
compila **non è colpa di Claudio e non ferma né lo scarico né l'import**: il
driver mette **il log del compilatore dentro lo zip**
(`log\compile_ABTG_ContaBarreEXT.log`) — è lì che c'è la riga e l'errore.

---

## ▶️ RIGA 3 — **LA RIPRESA** (se una corsa si è interrotta)

**È la STESSA riga 1, identica.** Non c'è un `-Riprendi`: la ripresa è nella
cache degli zip, che il driver ricontrolla uno per uno — e non "esiste sì/no",
**li apre**: uno zip troncato viene cancellato e riscaricato.

⚠️ **La cartella di raccolta è NUOVA a ogni corsa** (`STORICO_INDICI_<data>_<ora>`):
**non c'è nessun rischio che la seconda serata cancelli la prima** (checklist
35). Ma vuol dire anche che **ogni corsa ha il suo zip**: manda **quello con
l'ora più recente**, o mandali tutti e due.

---

## 📦 COSA DEVE ESSERCI NELLO ZIP — verificalo per nome PRIMA di mandarlo

La console **stampa da sola l'elenco dei file che ci sono davvero** (contati,
non a memoria). Questi devono esserci:

| file | quando | cosa dice |
|---|---|---|
| `REFERTO_STORICO_INDICI.txt` | **sempre** | tutto. La riga `data:` deve essere **di adesso** |
| `STORICO_INDICI_CRITERI.md` | **sempre** | i criteri **come li ha letti la corsa**, non come sono su GitHub oggi |
| `dati\NASUSD_M1_ANTEPRIMA.txt` | dopo la riga 1 | prime e ultime righe del CSV + anni scaricati |
| `dati\ABTG_ImportEsterno_referto.csv` | dopo la riga 2 | **shift calibrato** (deve venire **+5**), copertura, verdetto del cancello |
| `dati\ABTG_ContaBarreEXT.csv` | dopo la riga 2 | prima/ultima barra **M15 e H1**, anni vuoti |
| `log\compile_*.log` | dopo la riga 2 | il verdetto del compilatore, **anche quando fallisce** |
| `log\*.txt`, `log\*.log` | sempre | console degli strumenti e log MT5 (le **barre per anno** stanno lì) |

E sul Desktop, **fuori** dallo zip, c'è `STATO_STORICO_INDICI.txt`: si aggiorna
**dopo ogni passo**, quindi si può aprire mentre la corsa gira per vedere a che
punto è.

---

## 🔍 COSA GUARDARE NEI NUMERI (e quando fermarsi)

1. **Shift calibrato = `+5`.** È così negli 8 import forex e nei 3 indici. **Se
   esce un altro numero: FERMARSI E CAPIRE**, non importare.
2. **Barre per anno.** 2010 e l'anno in corso saranno parziali per costruzione
   (HistData parte da novembre 2010). **Un anno a zero in mezzo è un problema**,
   ed è dichiarato nella colonna `AnniVuoti`.
3. **Banda di prezzo.** Un Nasdaq sotto 1.500 o sopra 45.000 fa scattare
   l'`ALLARME` dello strumento: è la malattia del `grxeur`, e sugli anni
   **2010-2018 non è mai stata guardata** — è l'unico `[INCERTO]` dichiarato dei
   criteri. Con le tranche il verdetto arriva **una volta per tranche**, quindi
   gli anni vecchi hanno il **loro** giudizio separato: è un guadagno, va letto.
4. **Verdetto fuso.** Se lo strumento scrive `VERDETTO FUSO: EST FISSO` invece
   di "segue il DST", la convenzione è diversa dagli 8 import promossi e **lo
   shift unico non basta**: si dichiara e ci si ferma.
5. **Cancello ZERO.** La diff media H1 del referto d'import: **≤0,05% passa**,
   sopra **resta in frigo**. Ad oggi è sopra su tutti e tre gli indici, e
   **non si ammorbidisce a occhio**: si porta il numero a Claudio.

---

## 🧾 COSA È GIÀ STATO VERIFICATO (e cosa no)

**[VERIFICATO ESEGUENDO, il 25/08]**
- il **cancello della firma**, nei due versi: `DA_FIRMARE` → non scarica, esce **3**; `FIRMATO` → prosegue, esce **0**;
- il **cancello dello spazio**: con 0,5 GB liberi si ferma e lo scrive;
- lo **scarico anno per anno**, la **ripresa** (anni in cache saltati), lo **zip troncato** (cancellato e riscaricato), l'**anno in corso** (mai dato per fatto: è a zip **mensili**);
- la **conversione a tranche** e la concatenazione: 1 sola intestazione, righe **in ordine**, **zero duplicati**;
- il **generatore di preset** su un sorgente rotto: **si ferma** invece di scrivere un preset a metà;
- la **cultura it-IT**: con la cultura italiana `[double]::TryParse("20.5")` senza invariante fa **205**; il driver legge **20,5** e stampa i numeri col punto.

**[VERIFICATO leggendo il codice di chi scrive, non intuendo]**
- `histdata_m1.py --converti` **ignora `--da/--a`**: `ingerisci_zip(cartella, set(pairs), ...)`
  ingerisce **tutti** gli zip **della cartella**. Per questo le tranche si fanno
  spostando gli zip in **cartelle** diverse e mai con `--da/--a`.
- Per l'**anno in corso** lo strumento scarica **uno zip al mese**
  (`range(1, oggi.month)`): un solo mese presente non vuol dire anno fatto.
- Nome della cache: `DAT_ASCII_<PAIR>_M1_<ANNO>.zip`.
- Il **battito** guarda la **crescita dei byte**, mai il tempo (checklist 30);
  la conversione, che è solo CPU, il battito **non lo usa** ed è dichiarata.
- `[CmdletBinding()]` c'è (checklist 71): un refuso in un interruttore fa
  **fallire** la riga, non partire la corsa vera.
- ASCII puro: **0 byte >127** nel `.ps1` e nel `.mq5`.

**[NON VERIFICATO, e va detto]**
- ⛔ **`ABTG_ContaBarreEXT.mq5` non è mai stato compilato.** In cloud non c'è
  MetaEditor. Controllato a mano: ASCII, graffe/tonde/quadre bilanciate
  ignorando stringhe e commenti, idiomi (`StringSplit`, `ArrayInitialize`,
  `SymbolExist`, `#property strict`) identici a quelli di file **già compilati**
  in repo. Se non compila, il log è nello zip.
- ⛔ **Il driver non è mai girato su Windows né su MT5 vero.** Le fasi F6/F7/F8
  (terminale, compilazione, `/config`) sono verificate **per lettura e per
  confronto col gemello già girato** (`importa_storico_esterno.ps1`), non
  eseguite.
- ⚠️ Le **stime di spazio** restano `[INFERITO]`: ~80 MB per anno e per simbolo
  (sei copie della stessa barra + il simbolo dentro MT5), cioè ~1,4 GB per
  NASUSD 2010-2026, e il driver pretende **3×** di margine misurato.
