# 📬 STORICO INDICI — **LE RIGHE DA MANDARE**

**La richiesta**: Claudio, 25/08/2026 — _"per gli Indici cerchiamo di fare i
test con piu' anni di storico"_.
**Criteri**: `risultati_archivio/STORICO_INDICI_CRITERI.md` — ⚠️ **[DA FIRMARE]**, **sei** decisioni.
**Driver**: `righe/RIGA_STORICO_INDICI.ps1` (marcatore `MARCATORE_RIGA_STORICO_INDICI_v1`).
**Script MQL5 nuovo**: `mql5/Scripts/ABTG_ContaBarreEXT.mq5` (`CONTA-EXT-v1`) — **mai compilato**, lo compila il driver.

> ⚠️ **QUESTE STRINGHE NON SONO DEFINITIVE.** Devono ancora passare dal
> **verificatore-stringhe**. Non mandarle a Claudio prima.

**PIN PROPOSTO**: `826f008a6fa92b8adc3e7302f4b8c92ccee9491f`
_(contiene tutti e tre gli artefatti: driver, criteri, `.mq5`. Se il
verificatore cambia una riga, **il pin cambia** e queste righe vanno riscritte:
girare al pin vecchio vuol dire girare codice di ieri senza accorgersene.)_

---

## 🔴 LE TRE COSE DA DIRE A CLAUDIO PRIMA DELLE RIGHE

### 1. 🧊 **Piu' anni NON sblocca i test sugli indici. Il collo di bottiglia e' un altro.**

Gli indici `_EXT` gia' importati (`NASUSD_EXT`, `225JPY_EXT`, `SPXUSD_EXT`,
2019→2026) sono **IN FRIGO** perche' il **cancello ZERO e' chiuso**: diff media
H1 contro il nativo BCM **0,061-0,101%** contro il **≤0,05%** richiesto
(`REFERTO_HISTDATA_FATTIBILITA.md` §14-15). La cura DST della `_v2` e' stata
**misurata** e **peggiora** del 7,7-8,6%.

> Un `NASUSD_EXT` dal 2010 resta in frigo **esattamente come quello dal 2019**.
> Questo giro produce **DATI**. Il permesso di usarli e' un'altra firma.

### 2. ✅ **La sonda del Dow era gia' tornata. Due volte.**

La missione chiedeva di rilanciarla "se il secondo giro non e' mai tornato".
**E' tornato**, ed e' agli atti (`REFERTO_SONDA_DUKASCOPY.md`, giro 2 e giro 3
del 15/08):

| grafia | esito |
|---|---|
| **`USA30IDXUSD`** | ✅ **OK, 49.445 byte — primo anno 2012** |
| `US30IDXUSD` · `USA30USD` · `WS30IDXUSD` · `GERIDXEUR` | ❌ ASSENTE (404 **veri**) |
| `DJIIDXUSD` (`ERRORE 0`) · `USA2000IDXUSD` (`503`) | ⚠️ **non misurate** — e non ci servono |

**Il driver NON la rilancia**: la dichiara `GIA' MISURATA (giro3 15/08)` nel
referto. Le due caselle mai misurate si rifanno solo con `-RifaiSondaDow`
(~12 richieste, un minuto), e sono dichiarate come tali.

### 3. 💀 **La strada Dukascopy per 14 anni di tick e' gia' stata misurata, ed e' fuori portata.**

`REFERTO_DUKASCOPY_FATTIBILITA.md`, coda: corsa vera `DEUIDXEUR` **dal PC di
Claudio**, **25 giorni su 2389 in 1h43m** = **~4 minuti per giorno di storico**.

| | giorni iterati | col ritmo **misurato** |
|---|---:|---:|
| DAX 2012→oggi | ~4.590 | **~306 ore = 12,7 giorni** |
| Nasdaq 2012→oggi | ~4.590 | **~306 ore = 12,7 giorni** |
| **i due insieme** | ~9.180 | **~25 giorni di crawl** |

**Per questo la proposta D-A non e' Dukascopy: e' HistData**, che scarica **1
ZIP annuale** invece di **7.500 file all'ora** per simbolo-anno — e per giunta
parte dal **2010-11**, due anni piu' indietro di Dukascopy.

---

## ✍️ IL CANCELLO DELLA FIRMA — è CHIUSO

Il driver legge `STORICO_INDICI_CRITERI.md` **al pin** e cerca le righe
`@DECISIONE ... STATO=FIRMATO`. Finché sono `DA_FIRMARE`:

- ✅ il **giro a vuoto gira lo stesso** (legge i criteri, misura lo spazio libero, non scarica niente);
- 🛑 lo **scarico non parte** e finisce nel referto come `NON ESEGUITA (decisione D-x non firmata)`.

**Non esiste nessun `-CriteriFirmati`, apposta.** Si firma nel file
(`STATO=FIRMATO`), si pusha, e **il pin nuovo** va nelle righe.

| | decisione | ✅ proposta | perché |
|---|---|---|---|
| **D-A** | fonte e unità | **`histdata`, barre M1** | i tick pieni a valle **non si possono usare**: un simbolo custom MT5 è fatto di barre, e `importa_storico_esterno.ps1` (riga 525) lo dice — _"il modello 4 (tick reali) NON si usa"_. 9 GB e 25 giorni per un dato che il tester non legge |
| **D-B** | simboli | **`NASUSD`** e basta | è l'unico **promosso da tutti i cancelli** dello strumento (banda OK, DST 91/91, 0 righe scartate). DAX bocciato, Dow assente, S&P e Nikkei in coda **gratis** |
| **D-C** | limiti d'uso | **`SOLO_PROVA_REGIME`** | come i forex `_EXT`, **più** il divieto nuovo: finché il cancello ZERO è chiuso, gli indici `_EXT` non entrano **nemmeno** nella prova di regime |
| **D-D** | finestra | **`2010-2026`** | HistData pubblica gli indici da **novembre 2010**. Ma si usano **a finestre di regime**, non in una corsa unica: sedici anni di fila **diluiscono** (CLAUDE.md, emendamento C) |
| **D-E** | soglia canarino | **`20` ore** | la stessa già usata nella notte #2, decisa **prima** di misurare |
| **D-F** | strada del DAX | **`diagnosi_prima`** | `--diagnosi` sul CSV già sul PC costa **zero rete e minuti**, e **non è mai stato eseguito sui dati veri**. Non si importa un DAX che sappiamo sporco per avere più anni |

---

## ▶️ RIGA 0 — **IL GIRO A VUOTO** (2 minuti, niente MT5, niente scarico)

**Cosa fa**: legge i criteri al pin e li stampa uno per uno, stampa la tabella
dei **cinque indici** con chi è dentro e chi è fuori e **perché**, stima lo
spazio, **misura** lo spazio libero, e si ferma. Serve a vedere le decisioni
come le vede la macchina, prima di firmarle.

**Si incolla il blocco INTERO, è UN comando solo.**

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='826f008a6fa92b8adc3e7302f4b8c92ccee9491f';
    $p="$env:USERPROFILE\RIGA_STORICO_INDICI.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_STORICO_INDICI.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_STORICO_INDICI_v1' -Quiet)){ throw 'SCRIPT VECCHIO: il pin non contiene il driver nuovo.' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE -- il referto e lo zip ci sono lo stesso: mandali.' -ForegroundColor Yellow } }
```

📨 **Poi manda**: `Desktop\STORICO_INDICI_<data>_<ora>.zip`.
⚠️ Dentro `REFERTO_STORICO_INDICI.txt` c'è una riga **`data:`**: deve essere di
**ADESSO**. Se è di ieri, hai mandato lo zip di una corsa vecchia.

---

## ▶️ RIGA 1 — **LO SCARICO** (solo DOPO la firma e il pin nuovo)

**Cosa fa**: canarino di ritmo (cancello), poi scarica **un anno alla volta**,
poi converte, poi scrive il CSV M1 finale. **Ripartibile**: se si interrompe, si
rilancia **la stessa identica riga** e riprende dagli anni che mancano.

**Con `-Prepara`** copia il CSV in `MQL5\Files` e scrive i preset. **Non apre
MT5.**

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='<PIN NUOVO, quello del commit che FIRMA i criteri>';
    $p="$env:USERPROFILE\RIGA_STORICO_INDICI.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_STORICO_INDICI.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_STORICO_INDICI_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -Prepara -OreMax 6;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE -- e'' gia'' una risposta: manda lo zip, i problemi sono nel referto.' -ForegroundColor Yellow } }
```

**Serve python** (3.8+, quello vero, **non lo stub del Microsoft Store**): il
driver lo cerca e, se non c'è, **lo dice e si ferma** invece di far finta.

---

## ▶️ RIGA 2 — **IMPORT IN MT5 + VERIFICA** (⚠️ **MT5 DEVE ESSERE CHIUSO**)

> 🛑 **PRIMA CHIUDI METATRADER, TUTTE LE ISTANZE.** Il driver si rifiuta di
> partire se lo trova aperto, e **non lo ammazza**: potrebbe essere Claudio che
> sta guardando un grafico. MT5 riscrive i suoi file all'uscita: con MT5 aperto,
> quello che facciamo verrebbe cancellato.
> 🛑 **NON SI LANCIA SUL VPS**: spegnerebbe la flotta in forward.

**Cosa fa**: compila `ABTG_ImportaStoricoEsterno`, importa come `NASUSD_EXT`,
**chiude MT5 in modo PULITO** (col kill le barre restano e la **registrazione
del simbolo no** — i 32 lanci a vuoto del 14/08), poi compila e lancia
`ABTG_ContaBarreEXT` e scrive **prima e ultima barra M15 e H1** più il
**conteggio barre per anno**. Il tester gira sempre con
`AllowLiveTrading=false`.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64 -EA SilentlyContinue){ throw 'MT5 APERTO: chiudilo (tutte le istanze) e rilancia.' };
    $pin='<PIN NUOVO>';
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

---

## ▶️ RIGA 3 — **LA RIPRESA** (se una corsa si è interrotta)

**È la STESSA riga 1, identica.** Non c'è un `-Riprendi`: la ripresa è nella
cache degli strumenti e negli artefatti per anno, che il driver ricontrolla uno
per uno.

⚠️ **La cartella di raccolta è NUOVA a ogni corsa** (`STORICO_INDICI_<data>_<ora>`):
**non c'è nessun rischio che la seconda serata cancelli la prima** (checklist
35). Ma vuol dire anche che **ogni corsa ha il suo zip**: manda **quello con
l'ora più recente**, o mandali tutti e due.

---

## 📦 COSA DEVE ESSERCI NELLO ZIP — verificalo per nome PRIMA di mandarlo

| file | quando | cosa dice |
|---|---|---|
| `REFERTO_STORICO_INDICI.txt` | **sempre** | tutto. La riga `data:` deve essere **di adesso** |
| `STORICO_INDICI_CRITERI.md` | **sempre** | i criteri **come li ha letti la corsa**, non come sono su GitHub oggi |
| `dati\NASUSD_M1_ANTEPRIMA.txt` | dopo la riga 1 | prime e ultime righe del CSV + anni scaricati |
| `dati\ABTG_ImportEsterno_referto.csv` | dopo la riga 2 | **shift calibrato** (deve venire **+5**), copertura, verdetto del cancello |
| `dati\ABTG_ContaBarreEXT.csv` | dopo la riga 2 | prima/ultima barra **M15 e H1**, anni vuoti |
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
   criteri.
4. **Verdetto fuso.** Se lo strumento scrive `VERDETTO FUSO: EST FISSO` invece
   di "segue il DST", la convenzione è diversa dagli 8 import promossi e **lo
   shift unico non basta**: si dichiara e ci si ferma.
5. **Cancello ZERO.** La diff media H1 del referto d'import: **≤0,05% passa**,
   sopra **resta in frigo**. Ad oggi è sopra su tutti e tre gli indici, e
   **non si ammorbidisce a occhio**: si porta il numero a Claudio.

---

## 🧾 COSA È GIÀ STATO VERIFICATO (e cosa no)

**[VERIFICATO leggendo il codice di chi scrive, non intuendo]**
- `histdata_m1.py --converti` **ignora `--da/--a`**: `ingerisci_zip(cartella, set(pairs), ...)`
  ingerisce **tutti** gli zip della cartella. Per questo la conversione si fa
  **una volta sola in fondo** e non per anno: spezzarla darebbe CSV cumulativi e
  la concatenazione un file **pieno di duplicati**, grosso e plausibile.
- `dukascopy_m1.py` scrive il CSV **solo a fine simbolo**: per quella strada il
  giro per anno serve davvero, e ogni pezzo viene copiato **subito** con un nome
  proprio (checklist 26).
- Nome della cache HistData: `DAT_ASCII_<PAIR>_M1_<ANNO>.zip` — è l'artefatto su
  cui il driver decide "questo anno è già fatto".
- Il **battito** guarda la **crescita dei byte** di log + cartella sorvegliata,
  mai il tempo (checklist 30); la conversione, che è solo CPU e **non fa
  crescere niente**, il battito **non lo usa** ed è dichiarata.
- `[CmdletBinding()]` c'è (checklist 71): un refuso in un interruttore fa
  **fallire** la riga, non partire la corsa vera.
- ASCII puro: **0 byte >127** in tutto il `.ps1`.

**[NON VERIFICATO, e va detto]**
- ⛔ **`ABTG_ContaBarreEXT.mq5` non è mai stato compilato.** In cloud non c'è
  MetaEditor. Se non compila è un difetto mio: il driver se ne accorge (pretende
  un `.ex5` **scritto adesso**) e lo scrive nel referto, ma la **fase F8 non
  produrrebbe niente**.
- ⛔ **Il driver non è mai stato eseguito.** Controlli fatti: ASCII, graffe e
  tonde bilanciate, variabili del referto inizializzate **fuori** dal `try`
  (checklist 48), funzioni definite fuori dal `try`, argomenti di
  `Start-Process` virgolettati (un percorso utente con uno spazio dentro
  diventerebbe due argomenti).
- ⚠️ Le **stime di spazio** (0,8 GB HistData / 9 GB Dukascopy) sono
  **[INFERITO]**: estrapolate da byte veri di un'ora campione, non da una corsa
  piena. Il driver le confronta con lo spazio libero **misurato** e pretende
  **3× di margine** prima di partire.
