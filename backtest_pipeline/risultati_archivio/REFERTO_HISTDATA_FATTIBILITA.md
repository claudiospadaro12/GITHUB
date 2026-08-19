# 🛣️ LA STRADA HISTDATA — REFERTO DI FATTIBILITÀ (18/08/2026, sera)

_Il piano B diventa piano A. Il crawl Dukascopy dal PC di Claudio è strozzato
dal server (**25 giorni su 2389 in 1h43m**, 503/reset/timeout continui →
proiezione ~7 giorni di corsa). HistData pubblica le stesse M1 in **ZIP
ANNUALI**: un anno di DAX passa da **~6.200 richieste HTTP a UNA**._

Deliverable: `backtest_pipeline/dukascopy/histdata_m1.py` (versione
**`HD-M1-v1`**), autotest **8/8 in cloud**, ASCII puro (0 byte >127).

---

## 1. 🚫 RETE DAL CLOUD: **NO** — identica al blocco Dukascopy

**[VERIFICATO, tre canali indipendenti, 18/08/2026 ~15:00 UTC]**

| prova | risposta |
|---|---|
| `curl https://www.histdata.com/` | **`CONNECT tunnel failed, response 403`** |
| WebFetch su `.../ascii/1-minute-bar-quotes/grxeur` | **`EGRESS_BLOCKED: Access to www.histdata.com is blocked by the network egress proxy`** |
| status del proxy (`__agentproxy/status`) | `connect_rejected: gateway answered 403 to CONNECT (policy denial)` su **`www.histdata.com:443`** |
| `web.archive.org` (per leggere l'HTML in copia) | **403 pure lui** — niente scorciatoie |
| kaggle.com · finance.yahoo · stooq.com | **403 tutti** |

**Quello che invece PASSA dal cloud: `raw.githubusercontent.com` (200).**
È da lì che viene tutta l'intelligence di questo referto — sorgenti veri,
non ricordi.

> ➡️ **Conseguenza:** nessun byte di dati è stato scaricato qui. Lo script è
> scritto per il PC di Claudio e **ogni cosa che non ho potuto vedere è
> etichettata `[DA VERIFICARE SUL PC]`**, con dentro il comando che la
> verifica in trenta secondi (`--esplora`).

**Prova della degradazione controllata [VERIFICATO in cloud]:** lanciato
`--esplora` da qui, lo script ha fallito il **controllo positivo**, si è
fermato senza inventare niente e ha stampato la strada manuale. Verbale
grezzo: `backtest_pipeline/risultati_prove/histdata_sonda/referto_cloud_bloccato_2026-08-18.txt`.

---

## 2. 🎯 STRUMENTI E COPERTURA

### 2a. 🔴 LA NOTIZIA GROSSA: **IL DOW SU HISTDATA NON ESISTE**

**[VERIFICATO su DUE fonti indipendenti lette oggi, 18/08/2026]**

1. `philipperemy/FX-1-Minute-Data` → `pairs.csv` (lista completa dei codici
   HistData con primo mese pubblicato)
   — https://raw.githubusercontent.com/philipperemy/FX-1-Minute-Data/master/pairs.csv
2. `dmidlo/histdata.com-tools` → `src/histdatacom/fx_enums.py`, gruppo
   `"indices"` (10 codici, uno per uno)
   — https://raw.githubusercontent.com/dmidlo/histdata.com-tools/main/src/histdatacom/fx_enums.py

Le due liste **coincidono**: gli indici di HistData sono **dieci**, e sono
`grxeur auxaud frxeur hkxhkd spxusd jpxjpy udxusd nsxusd ukxgbp etxeur`.

⚠️ **`UDXUSD` NON è il Dow: è l'INDICE DEL DOLLARO** (US DOLLAR INDEX), come
scritto nero su bianco nel README di philipperemy. Il sospetto della missione
("DJIUSD? o UDXUSD?") era ragionevole ed **è stato smentito**.

> 🎯 **Per `U30USD` (Dow) HistData non serve a niente: resta SOLO Dukascopy
> (`USA30IDXUSD`).** Va detto subito perché cambia il piano: la strada veloce
> copre 3 indici su 4, non 4 su 4.

### 2b. ✅ La mappa dei nostri simboli

**[VERIFICATO]** i codici e il primo mese; **[INFERITO]** l'accoppiamento col
nome BCM (i nomi BCM vengono dai nostri file vivi: `CONTRATTI_SEDIE.md`,
`FLOTTA_ATTIVA.md`).

| nostro (BCM) | HistData | che cos'è | primo mese pubblicato | serve alla missione? |
|---|---|---|---|---|
| `D30EUR` | **`grxeur`** | DAX 30/40 in EUR | **2010-11** | ✅ sì |
| `NASUSD` | **`nsxusd`** | NASDAQ 100 in USD | **2010-11** | ✅ sì |
| `225JPY` | **`jpxjpy`** | NIKKEI 225 in JPY | **2010-11** | ✅ sì |
| `SPXUSD` | **`spxusd`** | S&P 500 in USD | **2010-11** | ✅ bonus (è un simbolo VIVO, sedia EMA200 H4) |
| `200AUD` | **`auxaud`** | ASX 200 in AUD | **2010-11** | 🟡 bonus (simbolo BCM già visto in flotta) |
| **`U30USD`** | **— NON C'È —** | Dow Jones | — | ❌ **solo Dukascopy** |
| — | `etxeur` `ukxgbp` `frxeur` `hkxhkd` `udxusd` | Stoxx50, FTSE, CAC, HangSeng, Dollar Index | 2010-11 | nomi BCM **[DA VERIFICARE]** |

**Il 2010-11 copre tutto quello che ci serve e molto di più**: finestre di
regime 2019 (laterale) · 2020 (crollo) · 2021 (toro) · 2022 (orso), e persino
il 2012+ chiesto come opzionale. Contro i **21 mesi e un regime solo** di BCM.

> ⚠️ **`[DA VERIFICARE SUL PC]` — l'ANNO FINALE.** Il primo mese lo dicono due
> fonti; **fin dove arrivano oggi i file degli indici non lo sa nessuna delle
> due** (una snapshot di terzi si ferma al 2018, un'altra al 2024: sono
> istantanee di quei repo, non la verità di oggi). **Non lo scrivo per
> ricordo.** Lo misura questo comando in mezzo minuto per simbolo:
> `python histdata_m1.py --esplora --simboli grxeur --da 2019 --a 2026`

---

## 3. ⚙️ IL MECCANISMO DI DOWNLOAD — letto nel sorgente, non intuito

**[VERIFICATO, sorgente aperto oggi]**
`philipperemy/FX-1-Minute-Data` → `histdata/api.py`
(https://raw.githubusercontent.com/philipperemy/FX-1-Minute-Data/master/histdata/api.py).
**Logica CITATA, non copiata**: nel nostro script è riscritta in stdlib pura
(niente `requests`, niente `BeautifulSoup`), con retry e cache di casa.

Ed è **lo stesso meccanismo che sta già dentro il nostro
`backtest_pipeline/importa_storico_esterno.ps1`** (funzione `Prova-Download`,
scritta il 14/08) — due fonti indipendenti che dicono la stessa cosa.

```
1) GET  https://www.histdata.com/download-free-forex-historical-data/
        ?/ascii/1-minute-bar-quotes/{pair}/{anno}[/{mese}]
2) dalla pagina si estrae il campo nascosto  <input id="tk" value="...">
3) POST https://www.histdata.com/get.php
        tk={token} date={anno} datemonth={anno[mese]} platform=ASCII
        timeframe=M1 fxpair={PAIR maiuscolo}
        header Referer = la pagina del punto 1   <-- SENZA QUESTO NON DA' NIENTE
4) risposta = lo ZIP (comincia per "PK")
```

**La regola annuale/mensile [VERIFICATO nel sorgente, riga dell'`assert`]:**
- **anni PASSATI → un solo ZIP ANNUALE** (`month=None`);
- **anno IN CORSO → solo ZIP MENSILI** (`month=1..12`).
- Lo script fa esattamente così, e se un periodo non dà token **non insiste**.

**Dentro lo ZIP:** `DAT_ASCII_{PAIR}_M1_{AAAA}.csv` + un file di stato `.txt`.
Il CSV è **senza intestazione, separato da `;`**:
```
20120201 000000;1.306600;1.306600;1.306560;1.306560;0
DateTime;Open;High;Low;Close;Volume     <- (intestazione implicita)
```
Formato data `YYYYMMDD HHMMSS`. Sugli indici il **volume è 0** (lo script MQL5
lo porta a 1 da solo, riga `tick_volume = (v>0 ? v : 1)` — verificata).

### 🅱️ La strada MANUALE è di prima classe, non un ripiego
Sono **pochissimi click**: 1 per anno per simbolo (7 anni × 3 indici = 21
download), più i mensili dell'anno in corso. `--manuale` stampa l'elenco
esatto dei link. **Gli ZIP non vanno rinominati né ordinati**: l'ingestione
legge il nome del CSV **dentro** lo zip (`DAT_ASCII_GRXEUR_M1_2020.csv`), così
il file può chiamarsi come pare al browser. **[VERIFICATO in autotest n.6]:
uno zip rinominato `qualsiasi_nome.zip` viene smistato lo stesso.**

---

## 4. 🕐 IL FUSO — la trappola vera, e stavolta c'è un CONFLITTO da dichiarare

**La specifica pubblica dice una cosa, la nostra misura ne dice un'altra.**

- **[VERIFICATO, citazione]** README di `philipperemy/FX-1-Minute-Data`:
  _"TimeZone: Eastern Standard Time (EST) time-zone **WITHOUT** Day Light
  Savings adjustments"_. È la specifica HistData ricopiata da terzi
  (la pagina originale **non l'ho potuta aprire**: bloccata).
- **[VERIFICATO, misura di casa, 15/08]** `REFERTO_IMPORT_6_SIMBOLI.md`:
  **8 import HistData su 8 hanno calibrato UNO SHIFT FISSO +5**, differenza
  media **0,005-0,011%** su 7 anni, copertura 99,2-99,6%.

I due fatti **non stanno insieme**, e il conto lo spiega:
il server BCM sta a **UTC+0/+1** (regola di casa: "ora italiana −1"; DAX apre
09:00 IT = 08:00 server). New York locale è UTC−5/−4 → **NY → BCM = +5 tutto
l'anno**, perché entrambi seguono l'ora legale. Se invece il feed fosse
**EST fisso**, sarebbe +5 d'inverno e **+6 d'estate**: uno shift unico
sbaglierebbe **metà anno di un'ora**, e la differenza media non potrebbe
essere 0,006%.

> 🎯 **[INFERITO, forte]** i timestamp HistData sono **ORA LOCALE DI NEW YORK**
> (seguono il DST), a dispetto della dicitura "WITHOUT DST".
> _(Il residuo: le ~4 settimane l'anno in cui il DST europeo e quello
> americano non coincidono restano sfasate di un'ora — coerenti col 99,6% di
> copertura e con la "diff max" che nei referti cade sempre in settimane di
> cambio ora.)_

### E però non ci si fida: **lo script MISURA la convenzione da solo**
`misura_fuso()` guarda **l'ora modale della prima barra di seduta, mese per
mese**:
- gennaio e luglio danno **la stessa ora** → il feed **segue il DST** → shift
  unico OK, atteso **+5** all'import;
- luglio è **un'ora prima** → **EST FISSO** → **FERMARSI**: uno shift unico
  non basta e va rifatto il ragionamento.

**[VERIFICATO in cloud, autotest 4 e 5]**: su serie sintetiche costruite nei
due modi, la misura risponde giusto in entrambi i casi.

**Scelta operativa: `--sposta-ore 0` (default) = i timestamp escono ESATTAMENTE
come li scrive HistData.** È la stessa identica catena dei 6 forex promossi il
15/08, e la calibrazione la fa `ABTG_ImportaStoricoEsterno` come sempre.
**Il numero atteso è +5. Se ne esce un altro: fermarsi, non importare.**

---

## 5. 🧪 CONTROPROVA INCROCIATA — tre feed, una verità

Il giorno campione **è già misurato** da Dukascopy
(`referto_dukascopy_validazione_2026-08-18.txt`, agli atti):

```
D30EUR  finestra 2025.06.15 20:00 -> 2025.06.16 19:59  (ora di New York)
        1294 barre M1   minimo 23400.56   massimo 23715.65
```

`--confronto-da/--confronto-a` stampa **min/max/n della stessa finestra**, e
in più **le due finestre spostate di −1h e +1h**: finché il fuso non è
inchiodato, l'ora di dubbio si **mostra**, non si nasconde — e se combacia
una delle tre, si sa anche QUALE convenzione è.

**Il terzo feed è gratis**: il 16/06/2025 **sta dentro lo storico BCM nativo**
(che parte dal 26/09/2024), quindi il grafico `D30EUR` dello stesso giorno è
il giudice. E **i 25 giorni già in cache sul PC dal crawl Dukascopy restano**:
non vanno cancellati, sono il secondo feed del confronto.

Scorciatoia pronta: **`--validazione`** = scarica il solo `grxeur` 2025 e fa
il confronto su quella finestra, senza altri parametri.

---

## 6. 🧰 LO SCRIPT — `backtest_pipeline/dukascopy/histdata_m1.py` (`HD-M1-v1`)

Python stdlib puro (`urllib`, `zipfile`, `re`), **ASCII puro**, marcatore di
versione stampato **prima** di qualunque azione, referto sul Desktop + zip
(regola delle righe di lancio, punto 2), riga `data:` dentro il referto.

| modo | cosa fa |
|---|---|
| `--autotest` | 8 prove **offline** (nessuna rete) |
| `--esplora` | **MISURA la copertura**: per ogni simbolo/anno dice se la pagina risponde e se c'è il token. È anche il controllo positivo |
| `--scarica` | ZIP annuali (anni passati) + mensili (anno in corso), cache su disco, retry **2/5/15/30 s**, pausa 1500 ms |
| `--converti` | ingerisce gli ZIP presenti (scaricati dallo script **o a mano**), concatena, misura fuso e continuità, scrive il CSV |
| `--manuale` | stampa solo l'elenco dei link da aprire nel browser |
| `--validazione` | la scorciatoia del §5 |

**Controllo positivo obbligatorio prima di ogni corsa di rete:** la pagina
`eurusd/2019` — un bersaglio di cui **sappiamo già la risposta**, perché quel
file l'abbiamo scaricato e importato il 15/08. Se non risponde o non ha il
token, **lo script si ferma e stampa la strada manuale**, invece di produrre
numeri. **[VERIFICATO: è successo davvero qui in cloud, e si è comportato
così.]**

### Quello che lo script MISURA invece di assumere
| cosa | come |
|---|---|
| la convenzione di fuso | ora modale di apertura di seduta, gennaio vs luglio (§4) |
| l'ordine di grandezza dei prezzi | banda plausibile per strumento (DAX 4.000-30.000 ecc.): fuori banda → **ALLARME, non importare** |
| la continuità | barre per anno, buchi intragiornalieri >60 min, **giorni feriali senza nessuna barra**, righe scartate, OHLC incoerenti, duplicati |

### La scelta che evita un'intera classe di errori
**I prezzi passano da HistData al CSV come STRINGHE**, senza mai diventare
`float`: nessun arrotondamento, nessun round-trip, e **nessuna questione di
cultura numerica** (il punto decimale del file arriva identico nel CSV).
_(È l'equivalente Python della regola `InvariantCulture` che vale sui `.ps1`:
qui il problema è tolto alla radice invece che gestito.)_

### Autotest: 8/8 **[VERIFICATO in cloud]**
1. parser riga HistData (3/3, 0 scarti) · 2. righe malate riconosciute
(high<low, close>high, duplicato, spazzatura) · 3. riga CSV **Formato 1** byte
per byte · 4. misura fuso → "segue il DST" · 5. misura fuso → "EST fisso,
fermarsi" · 6. ingestione da ZIP **rinominato a caso** · 7. confronto a
finestra con spostamenti · 8. allarme banda di prezzo.

**[NON PROVATO]**: la rete. Il primo ZIP vero lo vedrà il PC. Per questo il
**fail-fast è ovunque**.

---

## 7. ▶️ LE RIGHE DI LANCIO

> 🔴 **BOZZA BOCCIATA DAL VERIFICATORE (18/08, FAIL).** Le tre righe della prima
> stesura avevano 9 difetti — fra cui **nessun gate** (`irm` senza `-EA Stop`,
> `python` senza `$LASTEXITCODE`), **nessun TLS12**, **`python` secco** che su
> Windows può risolvere allo stub del Microsoft Store, e soprattutto: **erano
> righe SEPARATE**, e un blocco multi-riga incollato in console non è un
> programma — se la prima muore, la seconda parte lo stesso.
> Sotto ci sono le righe **CORRETTE**. Marcatore **`HD-M1-v3`**
> (v1 = 16 difetti; v2 = corretti; **v3 = bande di prezzo 2026, vedi §12**).
> ⚠️ Il marcatore è cambiato apposta: una riga vecchia che cerca `HD-M1-v2`
> ora **muore con `throw`** invece di rilanciare in silenzio lo script sbagliato
> (nel file v3 la stringa `HD-M1-v2` **non esiste più**: verificato).

**Come si incollano:** ogni passo è **UN SOLO blocco `& { ... }`**, graffe
comprese. Si incolla tutto insieme: così un `throw` a metà **ferma davvero**
quello che viene dopo.

### Passo 1 — autotest + esplorazione della copertura (~2 min) → **POI CI SI FERMA**
```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  $py=(Get-Command python.exe -EA SilentlyContinue | Where-Object { $_.Source -notlike "*\WindowsApps\*" } | Select-Object -First 1).Source
  if(-not $py){ $py=(Get-Command py.exe -EA SilentlyContinue | Select-Object -First 1).Source }
  if(-not $py){ throw "PYTHON ASSENTE: installalo da python.org con 'Add python.exe to PATH'" }
  $global:LASTEXITCODE=0; & $py -c "import sys; sys.exit(0 if sys.version_info>=(3,8) else 1)"
  if($LASTEXITCODE -ne 0){ throw "PYTHON NON FUNZIONANTE: $py" }
  $p="$env:USERPROFILE\histdata_m1.py"
  $dsk=Join-Path ([Environment]::GetFolderPath('Desktop')) 'histdata_m1'
  Remove-Item $p -Recurse -Force -EA SilentlyContinue
  Remove-Item $dsk -Recurse -Force -EA SilentlyContinue
  Remove-Item (Join-Path ([Environment]::GetFolderPath('Desktop')) 'histdata_m1.zip') -Force -EA SilentlyContinue
  Remove-Item "$env:USERPROFILE\histdata_m1\referto_histdata_*.txt" -Force -EA SilentlyContinue
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/dukascopy/histdata_m1.py" -OutFile $p -EA Stop
  if(-not (Select-String -Path $p -SimpleMatch -Pattern 'HD-M1-v3' -Quiet)){ throw "SCRIPT VECCHIO (cache GitHub ~5 min): aspetta 5 minuti e rilancia" }
  Set-Location $env:USERPROFILE
  $global:LASTEXITCODE=0; & $py $p --autotest
  if($LASTEXITCODE -ne 0){ throw "AUTOTEST FALLITO: NON si va oltre" }
  $global:LASTEXITCODE=0; & $py $p --esplora --simboli grxeur,nsxusd,jpxjpy,spxusd --da 2019 --a 2026
  if($LASTEXITCODE -ne 0){ throw "ESPLORAZIONE FALLITA: canale HistData nullo da questo PC -> STRADA MANUALE (i link stanno nel referto)" }
  Get-ChildItem $dsk | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize
  Select-String -Path "$dsk\referto_histdata_*.txt" -Pattern '^data:' | ForEach-Object { $_.Line }
  Write-Host "PASSO 1 OK -- manda il referto in chat e FERMATI QUI."
}
```
👉 **Risponde alla domanda che nessuna fonte sa: fin dove arrivano davvero gli
indici.** 🛑 **Stop obbligatorio**: il passo 3 ha bisogno dell'anno finale
MISURATO qui, non ipotizzato.

### Passo 2 — validazione sul giorno campione (confronto a tre feed)
```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  $py=(Get-Command python.exe -EA SilentlyContinue | Where-Object { $_.Source -notlike "*\WindowsApps\*" } | Select-Object -First 1).Source
  if(-not $py){ $py=(Get-Command py.exe -EA SilentlyContinue | Select-Object -First 1).Source }
  if(-not $py){ throw "PYTHON ASSENTE" }
  $p="$env:USERPROFILE\histdata_m1.py"
  $dsk=Join-Path ([Environment]::GetFolderPath('Desktop')) 'histdata_m1'
  Remove-Item $p -Force -EA SilentlyContinue
  Remove-Item $dsk -Recurse -Force -EA SilentlyContinue
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/dukascopy/histdata_m1.py" -OutFile $p -EA Stop
  if(-not (Select-String -Path $p -SimpleMatch -Pattern 'HD-M1-v3' -Quiet)){ throw "SCRIPT VECCHIO: aspetta 5 minuti e rilancia" }
  Set-Location $env:USERPROFILE
  $global:LASTEXITCODE=0; & $py $p --validazione
  if($LASTEXITCODE -ne 0){ throw "VALIDAZIONE FALLITA: leggi il referto, NON si passa al passo 3" }
  Get-ChildItem $dsk | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize
  Select-String -Path "$dsk\referto_histdata_*.txt" -Pattern '^data:|VERDETTO FUSO|spostamento' | ForEach-Object { $_.Line }
}
```
Attesi nel referto: `min 23400.56 / max 23715.65` su **una** delle tre finestre
(spostamento `0` se il fuso è quello che pensiamo) e **VERDETTO FUSO: il feed
SEGUE il DST**. Se esce `EST FISSO` → **ci si ferma** (e adesso lo script esce
anche con codice ≠ 0, non solo scrivendolo nel referto).

### Passo 3 — la corsa vera (minuti, non giorni), solo DOPO il passo 2
⚠️ `<ANNO>` = **l'ultimo anno che il passo 1 ha visto con `TOKEN`**. Non si
ipotizza: si copia dal referto del passo 1.
```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  $anno=<ANNO>
  $py=(Get-Command python.exe -EA SilentlyContinue | Where-Object { $_.Source -notlike "*\WindowsApps\*" } | Select-Object -First 1).Source
  if(-not $py){ $py=(Get-Command py.exe -EA SilentlyContinue | Select-Object -First 1).Source }
  if(-not $py){ throw "PYTHON ASSENTE" }
  $p="$env:USERPROFILE\histdata_m1.py"
  $dsk=Join-Path ([Environment]::GetFolderPath('Desktop')) 'histdata_m1'
  Remove-Item $p -Force -EA SilentlyContinue
  Remove-Item $dsk -Recurse -Force -EA SilentlyContinue
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/dukascopy/histdata_m1.py" -OutFile $p -EA Stop
  if(-not (Select-String -Path $p -SimpleMatch -Pattern 'HD-M1-v3' -Quiet)){ throw "SCRIPT VECCHIO: aspetta 5 minuti e rilancia" }
  Set-Location $env:USERPROFILE
  $global:LASTEXITCODE=0; & $py $p --scarica --converti --simboli grxeur,nsxusd,jpxjpy,spxusd --da 2019 --a $anno
  if($LASTEXITCODE -ne 0){ throw "CORSA FALLITA o INCOMPLETA: leggi il referto (sezione FALLITI) e usa la strada manuale per quei periodi" }
  Get-ChildItem $dsk | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize
  Select-String -Path "$dsk\referto_histdata_*.txt" -Pattern '^data:|ESITO:|CSV scritto|ALLARME|VERDETTO FUSO' | ForEach-Object { $_.Line }
}
```
Se il POST automatico non passa, **lo stesso referto stampa i link da aprire nel
browser**: si salvano gli ZIP in `%USERPROFILE%\histdata_m1` (il nome non conta)
e si rilancia lo stesso blocco togliendo `--scarica`.

### 📨 Istruzioni d'accompagnamento (da dire a Claudio, sempre)
- **Cosa mandare in chat:** il file `histdata_m1.zip` sul Desktop, **oppure** le
  righe che la console ha stampato in fondo (`data:`, `ESITO:`, `CSV scritto`).
- **Quale data leggere:** la riga `data:` del referto **deve essere di ADESSO**
  (ora del PC, non del server). Se è vecchia, il blocco è morto prima e stai
  guardando la foto di ieri.
- **Cosa NON cancellare:** la cartella della cache **Dukascopy** con i 25 giorni
  già scaricati — è il **secondo feed** del confronto del §5. E non si cancellano
  gli ZIP di `%USERPROFILE%\histdata_m1`: sono la cache che rende ripetibile la
  corsa senza ribussare a HistData.
- **MT5:** questi tre passi **non lo toccano** (nessuna scrittura in
  `MetaQuotes\Terminal`). MT5 entra in gioco solo al passo 4.

**Passo 4 — l'ultimo miglio, IDENTICO alla strada Dukascopy** (§6 del referto
Dukascopy): CSV in `MQL5\Files`, `ABTG_ImportaStoricoEsterno` con
`InpFormato=1`, `InpAutoShift=true`, `InpShiftMax=6` → simboli `D30EUR_EXT`,
`NASUSD_EXT`, `225JPY_EXT`, `SPXUSD_EXT`. **Shift atteso +5**, **cancello
ZERO** (diff media > 0,05% o copertura < 80% → non si usa), **chiusura pulita
di MT5**.

---

## 8. ⚖️ HISTDATA vs DUKASCOPY — chi fa cosa

| | HistData | Dukascopy |
|---|---|---|
| richieste HTTP per 1 anno di DAX | **1** (annuale) | **~6.200** (un file all'ora) |
| DAX / Nasdaq / Nikkei / S&P | ✅ dal 2010-11 | ✅ dal 2012 |
| **Dow (`U30USD`)** | ❌ **non esiste** | ✅ `USA30IDXUSD` |
| granularità | barre M1 **bid**, volume 0 | **tick** → M1 costruite da noi |
| stato del canale sul PC | **[DA VERIFICARE]** | **misurato: strozzato** |

> ➡️ **Non si butta niente.** HistData copre 3 indici su 4 in una corsa da
> minuti; **il Dow resta a Dukascopy**, dove però conviene lanciare **un
> simbolo solo** invece di quattro: il crawl da 7 giorni diventa ~1,75 giorni.

---

## 9. 📋 Etichette, una riga ciascuna

- **[VERIFICATO]** blocco rete cloud su 3 canali · lista completa dei 10
  indici HistData su 2 repo indipendenti · `UDXUSD` = indice del dollaro,
  **niente Dow** · primo mese 2010-11 · meccanismo GET-token/POST-get.php +
  Referer (sorgente aperto + nostro `.ps1`) · regola annuale/mensile · formato
  del CSV interno · parsing Formato 1 (sorgente MQL5) · shift +5 su 8/8 import
  (referto di casa) · autotest 8/8 · degradazione controllata provata.
- **[INFERITO]** i timestamp seguono il DST di New York (la specifica dice il
  contrario, il conto e 8 misure dicono di sì — e lo script **rimisura**) ·
  accoppiamento codice HistData ↔ nome BCM.
- **[INCERTO / DA VERIFICARE SUL PC]** **fin dove arrivano gli indici oggi**
  (2024? 2025? 2026?) · se il POST automatico passa ancora · i nomi BCM di
  Stoxx/FTSE/CAC · se il file dell'anno in corso esiste per gli indici.

**Nessun parametro degli EA in forward cambia per questo referto.**

---

## 10. ✅ PASSO 1 ESEGUITO SUL PC (18/08, 20:40) — CANALE APERTO, COPERTURA PIENA

Referto archiviato: `referto_histdata_2026-08-18_2042.txt` (versione HD-M1-v2,
`ESITO: OK`). Controllo positivo eurusd 2019: OK. Copertura MISURATA:

| simbolo | annuali 2019-2025 | mensili 2026 |
|---|---|---|
| grxeur (D30EUR) | TOKEN 7/7 | 1-7 con token |
| nsxusd (NASUSD) | TOKEN 7/7 | 1-7 con token |
| jpxjpy (225JPY) | TOKEN 7/7 | 1-7 con token |
| spxusd (SPXUSD) | TOKEN 7/7 | 1-7 con token |

**Zero VUOTA, zero 404, zero falliti.** Il canale automatico funziona dal PC
(al contrario di Dukascopy, misurato strozzato). `<ANNO>` per il passo 3 = **2026**.
Prossimo: passo 2 (validazione giorno campione a tre feed), poi passo 3.
NOTA: la finestra 2019-2026 e' quella della corsa; il primo mese dichiarato da
fonte terza resta 2010-11 — l'estensione indietro (2010-2018) si puo' chiedere
con una seconda corsa `--da 2010 --a 2018` quando serve (stessa strada, stessi gate).

## 11. ✅ PASSO 2 ESEGUITO (18/08, 20:51) — VALIDAZIONE PROMOSSA

Referto archiviato: `referto_histdata_2026-08-18_2051.txt` (`ESITO: OK`).
GRXEUR 2025 scaricato (4 MB, 335.844 barre M1, 0 scartate, 0 OHLC incoerenti,
0 zip rotti, 56 duplicate innocue).

**Le tre misure chieste, tutte buone:**
1. **FUSO: il feed SEGUE il DST** (apertura modale 00:00 in TUTTI i 12 mesi,
   inverno = estate, differenza +0 min) -> ora locale di New York, shift
   unico +5 atteso all'import. La convenzione degli 8 forex promossi regge
   anche sugli indici.
2. **CONFRONTO A DUE FEED, ESATTO AL CENTESIMO**: finestra campione
   2025.06.15 20:00 -> 16 19:59 a spostamento +0h = **1294 barre,
   min 23400.56, max 23715.65** — IDENTICO al metro Dukascopy
   (1294 barre, stessi estremi). Due fonti indipendenti, stessa giornata.
3. Banda prezzo OK, 206 buchi intragiornalieri >60 min (nottate sottili,
   attese), 1 giorno feriale vuoto = Venerdi' Santo 2025 (festa di borsa).

Terzo feed (grafico BCM nativo, min/max D30EUR 16/06/2025) resta da
consegnare per il gate a tre — ma il gate duro (import + shift +5 +
cancello ZERO) sta comunque nel passo 4.

---

## 12. 🟠 PASSO 3 — FERMATO DAL GATE (18/08, 20:59) → **HD-M1-v3**

**Il gate ha funzionato: `ESITO: FALLITO`, uscita ≠ 0, la riga si è fermata da
sola.** Ed è la prova che il difetto n.4 corretto in v2 (uscita legata ai
sotto-lavori) serviva davvero: in v1 questa stessa corsa sarebbe uscita **0**,
con tre allarmi seppelliti in fondo al referto e i CSV mandati in `MQL5\Files`.

**Ma la colpa non era dei dati: erano le COSTANTI a essere stantie.**

| simbolo | prezzo massimo misurato | tetto v2 | tetto v3 |
|---|---|---|---|
| `jpxjpy` NIKKEI | **66.253** | 60.000 ❌ | **100.000** |
| `nsxusd` NASDAQ | **29.514** | 30.000 (sfiorato) ❌ | **45.000** |
| `spxusd` S&P 500 | **7.702** | 8.000 (sfiorato) ❌ | **12.000** |
| `grxeur` DAX | oltre 30.000 | 30.000 ❌ | **45.000** |

`SPXUSD_M1.csv` era comunque già scritto: **2.481.265 barre**.

⚠️ **Perché allargare NON è "cambiare il criterio dopo aver visto i numeri":**
la banda è un controllo di **ORDINE DI GRANDEZZA** — becca l'indice letto come
un cambio (fattore 1.000+) o l'unità sbagliata — **non è un giudizio di
merito**. Anche col tetto nuovo il rapporto banda resta 6-16×, cioè continua a
urlare per un fattore 1.000. E i prezzi sono confermati da un **terzo feed
indipendente** (§11: confronto con Dukascopy esatto al centesimo, 1294 barre,
min 23400.56 / max 23715.65).

**Delta v2 → v3 (commit `70cf754`) [VERIFICATO riga per riga dal verificatore]:**
solo `VERSIONE`, le 4 bande e il commento che le spiega — **17 righe, nessun
altro cambiamento**. ASCII 0 byte >127, parse OK, autotest 8/8 uscita 0, e la
cache regge: uno ZIP già valido torna **`CACHE`** (0 riscaricati), quindi il
rilancio **non ribussa a HistData** — ricostruisce solo i CSV dagli ZIP che
sono già sul disco.

> ▶️ **Si rilancia il blocco del PASSO 3 del §7, identico**, con l'unica
> differenza del marcatore `HD-M1-v3`.

## 13. ⚖️ PASSO 3 COMPLETO (18/08, 21:07) — TRE PROMOSSI, D30EUR BOCCIATO DAL CANCELLO (per davvero)

Referto archiviato: `referto_histdata_2026-08-18_2107_corsa_completa.txt`
(HD-M1-v3, 56 zip in cache, 0 falliti, 0 scartate, 0 zip rotti).

**PROMOSSI (pronti per il passo 4, import come _EXT):**
| simbolo | barre 2019-2026/07 | banda | fuso |
|---|---|---|---|
| NASUSD | 2.546.517 | OK (6.124-30.760) | SEGUE il DST, 91/91 mesi apertura 00:00 |
| 225JPY | 2.357.431 | OK (16.019-73.515) | SEGUE il DST, 91/91 |
| SPXUSD | 2.481.265 | OK (2.184-7.620) | SEGUE il DST, 91/91 |

**BOCCIATO: D30EUR (grxeur) — e stavolta il cancello ha ragione.**
1. **Prezzo minimo 2.906,949**: un DAX sotto 8.000 non esiste nel 2019-2026
   (minimo Covid ~8.255). Righe marce DENTRO i file HistData GRXEUR,
   in anni da individuare (il 2025, gia' validato al par. 11, era pulito:
   min 18.809).
2. **Sessione ballerina**: apertura modale 00:00 fino a 2020-05, POI 02:00
   da 2020-06 a 2023-11, POI di nuovo 00:00. Non e' DST (le altre tre serie
   sono 00:00 fisse): il feed GRXEUR ha CAMBIATO orari di copertura per 3,5
   anni (conteggi annui coerenti: 187-205k barre contro 330k). VERDETTO
   FUSO: INCERTO — onesto.
3. Conseguenza: **NON importare D30EUR da HistData** finche' una diagnosi
   non dica DOVE stanno le righe marce e cosa copre davvero la sessione
   2020-2023. NASUSD/225JPY/SPXUSD non hanno nessuno dei due problemi.

Strade per il DAX lungo, in ordine: (a) diagnosi chirurgica del CSV
HistData (giorni con prezzi impossibili + mappa sessioni) e eventuale
bonifica DICHIARATA; (b) Dukascopy DAX (crawl lento, come il Dow);
(c) nativo BCM dal 2024-09. Il passo 4 dei tre promossi resta in coda
DOPO i round notturni (unico MT5).

## 14. PASSO 4 ESEGUITO (18/08, 22:43-22:48) — TRE IMPORT CREATI, TRE IN FRIGO (cancello ZERO)

Import con ABTG_ImportaStoricoEsterno (InpFormato=1, AutoShift, ShiftMax 6),
referti dal Journal (screenshot in chat):

| simbolo | shift | copertura | barre M1 | diff media H1 | diff max | cancello <=0,05% |
|---|---|---|---|---|---|---|
| NASUSD_EXT | +5 | 97,0% | 2.546.517 | 0,0756% | 60.221,8 pt il 2025.11.20 16:00 | NO |
| 225JPY_EXT | +5 | 97,0% | 2.357.431 | 0,1010% | 1.526,5 pt il 2026.01.09 14:00 | NO |
| SPXUSD_EXT | +5 | 97,0% | 2.481.265 | 0,0608% | 13.419,9 pt il 2026.03.23 11:00 | NO |

- Shift +5 confermato TRE su TRE (minimo netto della scansione +/-6):
  la convenzione ora-locale-NY regge anche sugli indici.
- Diff media 0,06-0,10% contro lo 0,005-0,011% degli 8 forex: sopra il
  cancello congelato -> i tre _EXT esistono ma NON si usano nei round.
- Ipotesi principale (nota del referto dello script + evidenza): le
  settimane in cui DST USA e DST Europa non coincidono (marzo e
  ottobre/novembre) rendono il +5 fisso sbagliato di un'ora; la diff max
  SPXUSD cade il 23/03/2026 in piena finestra sfasata. Il 225JPY ha anche
  un possibile secondo effetto (diff max 09/01, fuori finestra: orari di
  sessione del feed, come gia' visto sul GRXEUR).
- LAVORO PER LA FLOTTA (19/08): ricalcolo diff ESCLUDENDO le settimane
  sfasate; se <0,05% -> cura chirurgica (shift che segue il calendario DST
  o esclusione dichiarata). R81-bis NON parte finche' il cancello non passa.
- Righe scartate 0 su tutti e tre; periodo 2019.01.01 -> 2026.07.31.

---

## 14-bis. LA CURA: `ABTG_ImportaStoricoEsterno_v2` (scritto la notte 18->19/08, DA COLLAUDARE)

**Stato: CODICE SCRITTO, NON COMPILATO, NON PROVATO SUI DATI.** In questo
ambiente non c'e' MetaEditor: nessuno ha ancora compilato una riga. Tutto
quello che segue e' *coerenza logica* + controlli fatti su un modello
indipendente del calendario; la prova sono l'autotest e il re-import sul PC.
File: `mql5/Scripts/ABTG_ImportaStoricoEsterno_v2.mq5` (marcatore `IMP-EXT-v2`).
**La v1 NON e' stata toccata**: e' la catena con cui sono stati promossi gli
8 forex del 15/08 e deve restare riproducibile.

### 14-bis.1 IL DIFETTO, RIDOTTO A UN CONTO CHE SI VERIFICA A MANO

Due calendari, non uno:

| | entra in ora legale | esce |
|---|---|---|
| **USA** (timestamp HistData) | **2a domenica di marzo**, 02:00 locale | **1a domenica di novembre**, 02:00 locale |
| **Europa** (server BCM) | **ultima domenica di marzo**, 01:00 UTC | **ultima domenica di ottobre**, 01:00 UTC |

Gli USA entrano **prima** ed escono **dopo**. Quindi:

```
shift(t) = shiftBase + (Europa in ora legale ? 1 : 0) - (USA in ora legale ? 1 : 0)

NY solare + EU solare  -> +5   (inverno pieno)
NY legale + EU legale  -> +5   (estate piena)
NY legale + EU solare  -> +4   <- LE FINESTRE SFASATE
NY solare + EU legale  -> +6   <- NON ACCADE MAI coi calendari attuali
```

> **CORREZIONE A UNA MIA FRASE DI IERI**: nella consegna si diceva "+4 o +6 a
> seconda del verso". **Il verso e' UNO SOLO: +4.** Il +6 richiederebbe
> l'Europa in ora legale con gli USA in ora solare, e non succede mai perche'
> la finestra americana **contiene** quella europea da entrambi i lati. Il
> codice lo gestisce lo stesso (se un giorno l'UE abolisse il cambio ora, la
> formula continuerebbe a dare il numero giusto senza riscrivere niente).

**Quanto pesa** (calcolato, non stimato): la finestra di ottobre/novembre dura
sempre **173 ore**; quella di marzo **330 o 498 ore** a seconda di dove cade la
seconda domenica. Totale **503-671 ore l'anno = 5,7%-7,7%**. Nella finestra
2019-2026: 671 h negli anni 2019, 2020, 2024, 2025, 2026 e 503 h nel
2021-2023. Media 2010-2030: **6,57% dei giorni**.

### 14-bis.2 PERCHE' I FOREX PASSAVANO E GLI INDICI NO (la domanda posta)

**FATTO**: stessa identica catena, stesso script, stesso +5, stessi due
calendari. **Quindi si': anche gli 8 forex del 15/08 hanno lo stesso difetto.**
Non e' una cosa che riguarda solo gli indici.

**INFERENZA (forte, aritmetica dichiarata)** sul perche' li' non si vedeva.
L'errore vale *(quota di barre sbagliate)* x *(quanto si muove lo strumento in
un'ora, in % del prezzo)*:

| | quota barre sfasate | movimento tipico in 1 ora | contributo atteso |
|---|---|---|---|
| forex maggiori | ~7% | ~0,05% del prezzo | **~0,004%** |
| indici azionari | ~7% | ~0,2-0,3% del prezzo | **~0,015-0,020%** |

Il forex misurato sta a **0,005-0,011%**: cioe' il difetto DST da solo basta
quasi a spiegare tutto il residuo dei forex — sono puliti *nonostante*
l'errore, non perche' non ce l'abbiano. Gli indici stanno a **0,061-0,101%**:
il DST ne spiega **un quarto scarso**. C'e' dell'altro.

**Il secondo sospettato, che il fuso NON cura**: sul forex i due feed guardano
lo *stesso oggetto* (EURUSD spot e' EURUSD spot). Sugli indici no: HistData
quota l'indice, un broker MT5 quota tipicamente un **CFD sul future**, e fra i
due c'e' il **basis** (costo del denaro meno dividendi) piu' i salti di
rollover. E' uno scalino **sempre dallo stesso lato**, che nessuno shift
orario tocca. Per questo la v2 misura il **bias mediano della differenza
firmata**: bias ~0 = stesso strumento, residuo da orari/rumore; bias grande e
di segno costante = **strumenti diversi**, da DICHIARARE, non da limare.

**Terzo indiziato, gia' visto**: gli orari di sessione del feed (la malattia
del GRXEUR). Prova a favore: la copertura degli indici e' **97,0%** contro
**99,2-99,6%** dei forex — 3 ore su 100 dell'importato non trovano una barra
nativa. E soprattutto **due diff max su tre cadono FUORI dalle finestre
sfasate**: NASUSD il **20/11/2025** (finestra chiusa il 2/11) e 225JPY il
**09/01/2026**. Solo SPXUSD (23/03/2026) e' in finestra. La cura DST spostera'
la media, non necessariamente quei due picchi.

> **NESSUNA RE-IMPORTAZIONE DEI FOREX E' DECISA QUI.** Gli 8 forex restano
> promossi come sono: il loro numero e' sotto il cancello *anche* col difetto
> dentro, e il difetto puo' solo averlo peggiorato, mai migliorato. Se e
> quando si rifanno con la v2, il numero puo' solo scendere. Decide Claudio.

### 14-bis.3 COSA FA LA v2 (una cosa per volta, tutte dietro un input)

1. **`InpShiftDstAware` (default true)** — ogni barra riceve lo shift del suo
   istante. Le domeniche di cambio ora sono **calcolate dal codice**
   (`DomenicaEnnesima` / `UltimaDomenica`), non tabellate: **niente tabella
   scritta a mano che sbaglia in silenzio il primo anno che manca**. Vale
   2000-2040, ben oltre HistData.
2. **Due misure, non una**: il referto stampa la diff **DST-aware** (su cui si
   giudica il cancello) e la diff a **shift fisso** (metodo v1) come
   controprova, calcolate dalla *stessa* funzione per non poter divergere.
3. **Spaccatura DENTRO/FUORI le finestre sfasate**, in entrambe le modalita':
   e' la misura chiesta al par. 14 ("ricalcolo diff ESCLUDENDO le settimane
   sfasate").
4. **Diagnosi del residuo**: bias mediano firmato + diff media al netto del
   bias (vedi 14-bis.2).
5. **Elenco delle finestre TROVATE NEI DATI** con data inizio/fine, shift
   ricevuto e **numero di barre** dentro ciascuna, piu' il totale barre per
   shift. Sono i dati a dirlo, non una tabella.
6. **`InpAutoTest` (default false)** — modo collaudo: verifica e **esce senza
   importare**.
7. Controllo che lo shift variabile non abbia rotto l'ordine cronologico (in
   teoria non puo': i cambi d'ora cadono di sabato notte/domenica mattina a
   mercati chiusi. Ma "in teoria" non e' una verifica).
7-bis. **GUARDIA ANCHE NELL'IMPORT VERO**: i 126 controlli generati su
   2010-2030 girano **prima di toccare i dati**, non solo in autotest. Se
   falliscono, l'import si **annulla** senza scrivere niente. Costa nulla ed
   evita la cosa peggiore possibile qui: 2,5 milioni di barre scritte con un
   calendario rotto, cioe' dati sbagliati che *sembrano* giusti.
8. Referto su **file nuovo** `ABTG_ImportEsterno_referto_v2.csv`: la v2 ha
   colonne in piu' e accodarle al CSV v1 lo storterebbe.

**Cosa NON cambia**: regola d'uso congelata (`_EXT` = SOLO prova di regime a
parametri congelati) in testa allo script, clonazione e verifica delle
proprieta', soglia del cancello (0,05%), avviso su spread/commissioni.

### 14-bis.4 COME SI COLLAUDA (due passi, in quest'ordine)

**PASSO A — AUTOTEST (nessun dato toccato).** Compilare la v2, trascinarla su
un grafico qualsiasi con **`InpAutoTest = true`**. Deve uscire nel Journal:

- **`=== AUTOTEST: N controlli, 0 ROTTI ===`** e `ESITO: OK`;
- le 14 domeniche di cambio ora (2010, 2024, 2025, 2026, 2030) tutte `OK`;
- i 24 casi ai 4 confini (prima/dopo il cambio USA e EU, andata e ritorno)
  tutti `OK`: le date "dentro finestra" devono dare **+4**, quelle fuori **+5**;
- `controlli 2010-2030 falliti (su 126) = 0`;
- `giorni con aggiustamento +1 (atteso 0) = 0`;
- la riga informativa `giorni sfasati ... = ~6,5%` (atteso 5,7%-7,7%).

**Se anche un solo controllo esce `ROTTO`: fermarsi, non importare.** Un
calendario rotto e' peggio di nessun import, perche' produce dati che *sembrano*
giusti. Le 38 attese scritte a mano nel codice sono gia' state ricontrollate
contro un modello indipendente del calendario (0 incoerenze) — ma quello ha
verificato **l'aritmetica**, non la **compilazione MQL5**: e' esattamente cio'
che l'autotest deve chiudere.

**PASSO B — RE-IMPORT dei tre indici** (`InpAutoTest=false`, resto identico al
passo 4: `InpFormato=1`, `InpAutoShift=true`, `InpShiftMax=6`). I `.set` gia'
scritti dal `importa_storico_esterno.ps1` **restano validi**: i due input nuovi
non ci sono dentro e MT5 usa i default (DST-aware acceso, autotest spento).

### 14-bis.5 COSA DEVE USCIRE PERCHE' IL CANCELLO PASSI

Il cancello e' **diff media DST-aware <= 0,05%**. Ma il verdetto va letto
insieme agli altri tre numeri nuovi, altrimenti si promuove per fortuna:

| numero | cosa deve fare | cosa significa se non lo fa |
|---|---|---|
| **shift base** | restare **+5** in entrambe le scansioni | se il DST-aware sceglie una base diversa dal fisso: il file **non** e' ora locale di NY, fermarsi |
| **diff DST-aware** | **scendere** rispetto alla fissa | se non scende, il difetto non era il calendario |
| **dentro vs fuori** | avvicinarsi fra loro col DST-aware | se il "dentro" resta molto peggio, la conversione non ha morso |
| **bias mediano** | vicino a 0 | grande e di segno costante = **strumenti diversi** (cash vs future): il fuso non c'entra e non si cura |

**PREVISIONE DICHIARATA PRIMA DELLA MISURA** (cosi' non ci si racconta storie
dopo). Togliendo dalla diff attuale il contributo DST stimato al 14-bis.2:

| simbolo | diff v1 | diff DST-aware attesa | cancello 0,05% |
|---|---|---|---|
| SPXUSD | 0,0608% | ~0,045% | **forse SI, al pelo** |
| NASUSD | 0,0756% | ~0,061% | **probabilmente NO** |
| 225JPY | 0,1010% | ~0,088% | **probabilmente NO** |

> **La cura DST e' NECESSARIA ma probabilmente NON SUFFICIENTE.** Detto prima e
> non dopo. Se esce cosi', **il cancello ha fatto il suo mestiere** e la strada
> non e' aggiungere altre pezze finche' il numero non scende (sarebbe la stessa
> pesca che qui e' vietata sui parametri): e' **misurare il bias mediano** e, se
> conferma il cash-vs-future, dire che questi feed non sono confrontabili a
> quel livello di precisione e **decidere se 0,05% e' il cancello giusto per
> gli INDICI o solo per il forex**. Quella e' una decisione di Claudio, con i
> numeri sul tavolo — non una modifica del criterio dopo aver visto i numeri
> fatta di nascosto.

### 14-bis.6 LE RIGHE DI LANCIO — verificate il 19/08

> 🔴 **LE QUATTRO BOZZE (A)(B)(C)(D) SONO BOCCIATE.** Erano "la sostanza da
> verificare", e verificandola sono venuti fuori **5 difetti veri** (sotto). Qui
> sotto ci sono le righe **CORRETTE**: **tre blocchi PowerShell** (A, C, E) e
> **due passi a mano in MT5** (B, D). Si incolla **un blocco INTERO per volta**,
> graffe comprese, e ci si ferma fra un passo e l'altro.

**🛣️ LA STRADA SCELTA, e perche' (era la domanda della bozza A):**
**NON si tocca `importa_storico_esterno.ps1`.** Adattarlo con un `-Versione`
vorrebbe dire cambiare il nome in **7 punti** (sorgente locale, URL, `$mq5`,
messaggio, `Script=` dell'`.ini`, nome del referto, lettura del referto) **piu'**
i due input nuovi nei preset — su uno script che oggi e' la catena riproducibile
con cui sono stati promossi gli **8 forex del 15/08**. E per giunta ri-farebbe
download e concatenazione degli ZIP, lavoro che **e' gia' fatto**: i tre CSV
sono in `MQL5\Files` dal 18/08. Costo/beneficio: **strada (b)**, righe una-tantum
modellate sul PASSO 1a di `REFERTO_R83_R84_PREPARAZIONE.md`, import a mano dalla
finestra dello script (Claudio ne ha gia' fatti tre ieri). **Codice nuovo: zero
file, zero righe nella v1.**

**I 5 difetti trovati nelle bozze:**
1. **(B) e (D) dicevano "Journal": e' la scheda SBAGLIATA.** `Print()` di uno
   *script* finisce nella scheda **Esperti** e nel file `MQL5\Logs\<data>.log`;
   il Journal e' un altro log, in `logs\`. Il gemello lo sa gia'
   (`importa_storico_esterno.ps1`, riga 442: *"guarda la scheda ESPERTI"*).
   E' la famiglia del punto 20: si chiede un output e si indica il posto dove
   non nasce.
2. **La trappola del preset che non spegne il flag** (stessa famiglia del
   difetto gemello del punto 5). I tre `.set` del 18/08 **non contengono**
   `InpAutoTest`: dopo il giro di autotest MT5 si **ricorda** l'ultimo valore
   usato, quindi caricando il preset per l'import **`InpAutoTest` resta `true`**
   e i tre import stampano *"MODO AUTOTEST: NON viene importato nulla"*
   sembrando riusciti. Il PASSO A **riscrive i tre preset** con
   `InpAutoTest=false` e `InpShiftDstAware=true` dentro: la trappola muore li'.
3. **Il referto v2 si ACCODA** (`FileSeek(fh, 0, SEEK_END)`, riga 900): righe di
   un tentativo precedente resterebbero mischiate a quelle buone. Il PASSO A lo
   **cancella prima** e il PASSO E ne controlla **l'eta'** (punto 23).
4. **Nessuna guardia MT5-chiuso, in nessuna delle quattro** (punto 7): il PASSO
   A scrive in `MQL5\Scripts`, `MQL5\Presets` e `MQL5\Files`. E il PASSO E
   pretende MT5 chiuso **da menu**: la registrazione dei simboli personalizzati
   si salva **solo alla chiusura pulita** — ucciderlo e' costato l'intero R50 il
   14/08 (`importa_storico_esterno.ps1`, righe 74-83).
5. **Nessun controllo degli artefatti** (punti 14 e 22): che i tre `_M1.csv` e i
   tre `.set` esistano **ancora**, che il `.ex5` sia nato **adesso** (si cancella
   prima), che l'autotest sia **davvero** uscito `0 ROTTI`. Nelle righe nuove
   l'autotest si legge **dal log, non da uno screenshot**.

**Il pin e' `5413e3e080f6177e6bcc6af1ba56134d40facd09`** — e' il commit che
contiene la v2 finale (`git log -1` sul file lo conferma), ed e' su `origin/lavoro`.
La riga scarica **solo** quel `.mq5`: nessun gemello scarica niente da HEAD, quindi
il punto 24 qui e' coperto per intero.

#### PASSO A — installazione + compilazione della v2 (MT5 CHIUSO, ~2 min)
```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  if(Get-Process -Name terminal64 -EA SilentlyContinue){ throw "MT5 E' APERTO: chiudilo (File > Esci). Questo passo scrive in MQL5\Scripts, MQL5\Presets e MQL5\Files." }
  $h="5413e3e080f6177e6bcc6af1ba56134d40facd09"
  $t=@(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter terminal64.exe -EA SilentlyContinue | Where-Object { $_.DirectoryName -like "*BCM Markets*" })
  if($t.Count -eq 0){ throw "terminale BCM non trovato" }
  $inst=$t[0].DirectoryName
  $df=@(Get-ChildItem (Join-Path $env:APPDATA "MetaQuotes\Terminal") -Directory -EA SilentlyContinue | Where-Object { $o=Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $inst) })
  if($df.Count -eq 0){ throw "cartella dati MT5 non trovata (origin.txt)" }
  $data=$df[0].FullName
  foreach($f in @('NASUSD_M1.csv','225JPY_M1.csv','SPXUSD_M1.csv')){
    $x=Join-Path $data "MQL5\Files\$f"
    if(-not (Test-Path -LiteralPath $x)){ throw "manca $f in MQL5\Files: senza i CSV del 18/08 non c'e' niente da re-importare" }
    $i=Get-Item -LiteralPath $x
    Write-Host ("    c'e': " + $i.Name + "  " + [int]($i.Length/1MB) + " MB  del " + $i.LastWriteTime.ToString('yyyy-MM-dd HH:mm')) -ForegroundColor Green
  }
  foreach($s in @('NASUSD','225JPY','SPXUSD')){
    $sf=Join-Path $data ("MQL5\Presets\abtg_import_" + $s + ".set")
    if(-not (Test-Path -LiteralPath $sf)){ throw "manca il preset abtg_import_$s.set (lo scrive importa_storico_esterno.ps1)" }
    $righe=@(Get-Content -LiteralPath $sf | Where-Object { $_ -notmatch '^(InpAutoTest|InpShiftDstAware)=' })
    $righe += "InpShiftDstAware=true"
    $righe += "InpAutoTest=false"
    Set-Content -LiteralPath $sf -Value $righe -Encoding ASCII
    Write-Host ("    preset messo a posto (InpAutoTest=false): abtg_import_" + $s + ".set") -ForegroundColor Green
  }
  $sc=Join-Path $data "MQL5\Scripts"
  New-Item -ItemType Directory -Force -Path $sc | Out-Null
  $mq=Join-Path $sc "ABTG_ImportaStoricoEsterno_v2.mq5"
  $ex5=[IO.Path]::ChangeExtension($mq,'.ex5')
  $log=[IO.Path]::ChangeExtension($mq,'.log')
  $ref=Join-Path $data "MQL5\Files\ABTG_ImportEsterno_referto_v2.csv"
  Remove-Item $mq,$ex5,$log -Force -EA SilentlyContinue
  Remove-Item $ref -Force -EA SilentlyContinue
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/mql5/Scripts/ABTG_ImportaStoricoEsterno_v2.mq5" -OutFile $mq -EA Stop
  if(-not (Select-String -Path $mq -SimpleMatch -Pattern 'IMP-EXT-v2' -Quiet)){ throw "SORGENTE VECCHIO O TRONCO: manca il marcatore IMP-EXT-v2" }
  & (Join-Path $inst "metaeditor64.exe") "/compile:$mq" "/log" | Out-Null
  $fine=(Get-Date).AddMinutes(2)
  while((-not (Test-Path $ex5)) -and ((Get-Date) -lt $fine)){ Start-Sleep -Seconds 2 }
  $dsk=[Environment]::GetFolderPath('Desktop')
  $rac=Join-Path $dsk 'IMPORT_EXT_v2'
  Remove-Item $rac -Recurse -Force -EA SilentlyContinue
  New-Item -ItemType Directory -Force -Path $rac | Out-Null
  if(Test-Path $log){ Copy-Item $log (Join-Path $rac 'compilazione_v2.log') -Force }
  if(-not (Test-Path $ex5)){ throw "COMPILAZIONE FALLITA: gli errori sono in Desktop\IMPORT_EXT_v2\compilazione_v2.log - NON si importa niente e la v1 resta intatta." }
  Write-Host "COMPILATO: ABTG_ImportaStoricoEsterno_v2.ex5" -ForegroundColor Green
  Write-Host "Adesso il PASSO B, a mano in MT5." -ForegroundColor Cyan
}
```
🛑 **Stop.** Se non compila, si e' perso un minuto: la v1 e gli 8 forex promossi
non sono stati sfiorati.

#### PASSO B — l'autotest, a mano in MT5 (MT5 APERTO, ~2 min)
1. **apri MT5**;
2. **Navigatore > Script > tasto destro > Aggiorna** (senza questo il nome nuovo
   non compare);
3. trascina **`ABTG_ImportaStoricoEsterno_v2`** su **un grafico qualsiasi**;
4. nella finestra dei parametri metti **`InpAutoTest = true`** (a mano: e' l'unico
   valore che cambia rispetto ai default) e premi OK;
5. guarda la **scheda "Esperti"** — **non** il Journal: `Print()` di uno script
   scrive li'. Devono comparire i blocchi da A a I e, in fondo,
   **`=== AUTOTEST: 41 controlli, 0 ROTTI ===`** e **`=== ESITO: OK ===`**.
6. **lascia MT5 aperto** e passa al PASSO C, che legge il log e ti dice se e'
   andata davvero (cosi' non serve nessuno screenshot).

#### PASSO C — verifica dell'autotest, letta dal log (MT5 puo' restare aperto)
```powershell
& {
  $t=@(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter terminal64.exe -EA SilentlyContinue | Where-Object { $_.DirectoryName -like "*BCM Markets*" })
  if($t.Count -eq 0){ throw "terminale BCM non trovato" }
  $inst=$t[0].DirectoryName
  $df=@(Get-ChildItem (Join-Path $env:APPDATA "MetaQuotes\Terminal") -Directory -EA SilentlyContinue | Where-Object { $o=Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $inst) })
  if($df.Count -eq 0){ throw "cartella dati MT5 non trovata (origin.txt)" }
  $dsk=[Environment]::GetFolderPath('Desktop')
  $rac=Join-Path $dsk 'IMPORT_EXT_v2'
  if(-not (Test-Path $rac)){ throw "manca Desktop\IMPORT_EXT_v2: il PASSO A non e' stato fatto" }
  $lg=@(Get-ChildItem (Join-Path $df[0].FullName "MQL5\Logs") -Filter "*.log" -EA SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1)
  if($lg.Count -eq 0){ throw "nessun log in MQL5\Logs: l'autotest non e' mai partito" }
  $fs=New-Object System.IO.FileStream($lg[0].FullName,[System.IO.FileMode]::Open,[System.IO.FileAccess]::Read,[System.IO.FileShare]::ReadWrite)
  $sr=New-Object System.IO.StreamReader($fs,[System.Text.Encoding]::Unicode,$true)
  $testo=$sr.ReadToEnd(); $sr.Close(); $fs.Close()
  Copy-Item $lg[0].FullName (Join-Path $rac ("esperti_" + $lg[0].Name)) -Force
  $i=$testo.LastIndexOf("MODO AUTOTEST")
  if($i -lt 0){ throw "nel log non c'e' nessun autotest: InpAutoTest era false? Rifai il PASSO B." }
  $coda=$testo.Substring($i)
  ($coda -split "`r?`n") | Where-Object { $_ -match "AUTOTEST|ROTTO|ESITO|controlli 2010-2030|giorni sfasati|aggiustamento" } | ForEach-Object { Write-Host $_ }
  if($coda -match "<<< ROTTO"){ throw "AUTOTEST ROTTO: NON si importa niente. Il log e' gia' sul Desktop, mandalo in chat." }
  if($coda -notmatch "=== AUTOTEST: 41 controlli, 0 ROTTI ==="){ throw "non trovo la riga '=== AUTOTEST: 41 controlli, 0 ROTTI ===': leggi il log copiato sul Desktop." }
  if($coda -notmatch "ESITO: OK"){ throw "manca la riga 'ESITO: OK'." }
  Write-Host "AUTOTEST OK: 41 controlli, 0 ROTTI (e i 126 su 2010-2030 tutti buoni)." -ForegroundColor Green
  Write-Host "Adesso il PASSO D: i tre import." -ForegroundColor Cyan
}
```
🛑 **Stop obbligatorio.** Legge **solo l'ultimo** autotest del log (dall'ultimo
`MODO AUTOTEST` in poi): un tentativo rotto di mezz'ora prima non puo' ne'
salvare ne' condannare quello di adesso — e' la lezione del punto 23-bis.

#### PASSO D — i tre re-import, a mano in MT5 (~5 min in tutto)
Per **ognuno** dei tre (`NASUSD`, `225JPY`, `SPXUSD`), uno per volta:
1. trascina **`ABTG_ImportaStoricoEsterno_v2`** su un grafico qualsiasi;
2. nella finestra parametri: **Carica** > `abtg_import_NASUSD.set` (poi
   `abtg_import_225JPY.set`, poi `abtg_import_SPXUSD.set`);
3. controlla a occhio che nella lista ci sia **`InpAutoTest = false`** e
   **`InpShiftDstAware = true`** (ce li ha messi il PASSO A) e premi OK;
4. **scheda "Esperti"**: la tabella degli shift e, in fondo,
   `Referto aggiornato: MQL5\Files\ABTG_ImportEsterno_referto_v2.csv`.
5. Alla fine dei tre: **chiudi MT5 da File > Esci**. ⚠️ **Chiusura pulita, mai
   il Task Manager**: la registrazione dei simboli personalizzati si salva solo
   cosi' (il 14/08 questo errore e' costato l'intero round R50).

#### PASSO E — raccolta, tabella del cancello e zip (MT5 CHIUSO)
```powershell
& {
  if(Get-Process -Name terminal64 -EA SilentlyContinue){ throw "MT5 E' ANCORA APERTO: chiudilo da File > Esci (chiusura PULITA, o i simboli personalizzati non restano registrati), poi rilancia questo blocco." }
  $t=@(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter terminal64.exe -EA SilentlyContinue | Where-Object { $_.DirectoryName -like "*BCM Markets*" })
  if($t.Count -eq 0){ throw "terminale BCM non trovato" }
  $inst=$t[0].DirectoryName
  $df=@(Get-ChildItem (Join-Path $env:APPDATA "MetaQuotes\Terminal") -Directory -EA SilentlyContinue | Where-Object { $o=Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $inst) })
  if($df.Count -eq 0){ throw "cartella dati MT5 non trovata (origin.txt)" }
  $data=$df[0].FullName
  $dsk=[Environment]::GetFolderPath('Desktop')
  $rac=Join-Path $dsk 'IMPORT_EXT_v2'
  New-Item -ItemType Directory -Force -Path $rac | Out-Null
  $ref=Join-Path $data "MQL5\Files\ABTG_ImportEsterno_referto_v2.csv"
  if(-not (Test-Path -LiteralPath $ref)){ throw "il referto v2 non c'e': i tre import non sono stati fatti, oppure InpAutoTest era rimasto true e non e' stato importato niente." }
  $eta=(New-TimeSpan -Start (Get-Item -LiteralPath $ref).LastWriteTime -End (Get-Date)).TotalHours
  if($eta -gt 12){ throw ("il referto v2 ha " + [int]$eta + " ore: e' di un tentativo vecchio, non di adesso. Rifai il PASSO D.") }
  $r=@(Import-Csv -LiteralPath $ref)
  foreach($s in @('NASUSD_EXT','225JPY_EXT','SPXUSD_EXT')){
    if(@($r | Where-Object { $_.SimboloEXT -eq $s }).Count -eq 0){ throw "nel referto v2 manca la riga di $s : quell'import non e' andato." }
  }
  Write-Host ""
  Write-Host "  IL CANCELLO: DiffMediaPct_USATA (DST-aware) <= 0,0500" -ForegroundColor White
  $r | Format-Table SimboloEXT,ShiftBase,DstAware,DiffMediaPct_USATA,DiffMediaPct_FISSO,DiffMediaPct_DENTRO_finestre,DiffMediaPct_FUORI_finestre,BiasMedianoPct,ScanMigliore_FISSO,ScanMigliore_DST,Verdetto -AutoSize
  Copy-Item $ref $rac -Force
  Get-ChildItem (Join-Path $data "MQL5\Logs") -Filter "*.log" -EA SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 2 | ForEach-Object { Copy-Item $_.FullName $rac -Force }
  @(("data: " + (Get-Date -Format 'yyyy-MM-dd HH:mm')), ("pin : 5413e3e080f6177e6bcc6af1ba56134d40facd09"), ("righe nel referto v2: " + $r.Count), "La riga data: qui sopra deve essere di ADESSO.") | Set-Content (Join-Path $rac 'REFERTO_RACCOLTA_IMPORT_v2.txt') -Encoding ASCII
  Compress-Archive -Path (Join-Path $rac '*') -DestinationPath (Join-Path $dsk 'IMPORT_EXT_v2.zip') -Force
  Write-Host ""
  Write-Host "PRONTO DA MANDARE: Desktop\IMPORT_EXT_v2.zip" -ForegroundColor Cyan
  Write-Host "Si legge nell'ordine del par. 14-bis.5: shift base +5 in ENTRAMBE le" -ForegroundColor Yellow
  Write-Host "scansioni, la DST-aware piu' bassa della FISSA, DENTRO che si avvicina" -ForegroundColor Yellow
  Write-Host "a FUORI, e il bias mediano. Il cancello da solo non basta a promuovere." -ForegroundColor Yellow
}
```

**Cosa NON fanno queste righe, dichiarato:** non re-importano i forex (par.
14-bis.2: decide Claudio), non toccano `D30EUR` (bocciato al par. 13), non
cambiano nessun criterio. E se il cancello **non** passa, il par. 14-bis.5 dice
gia' cosa si fa: si misura il **bias**, non si aggiungono pezze.

### 14-bis.7 LIMITI DICHIARATI DELLA v2

- **Non compilata.** Rischio residuo: errori di sintassi MQL5. Non tocca EA ne'
  la v1, quindi un fallimento di compilazione non rompe niente in produzione.
- **Ora doppia della prima domenica di novembre**: fra le 01:00 e le 01:59
  locali di New York l'orario esiste due volte. Convenzione scelta e scritta
  nel codice: sotto le 02:00 vale ancora l'ora legale. Riguarda al massimo 60
  barre l'anno, di domenica mattina a mercati chiusi, dove il nativo BCM non
  ha barre da confrontare. Dichiarato, non nascosto.
- **Assunzione sul server BCM**: che segua il calendario **europeo**. Non e'
  arbitraria — e' l'unica ipotesi compatibile con i +5 misurati sia d'estate
  sia d'inverno su 8 forex per 7 anni (se il server fosse a offset fisso, uno
  shift unico sbaglierebbe mezzo anno e la diff non sarebbe 0,006%). Resta
  un'inferenza: se salta, salta con lei tutto il par. 4.
- **Non cura**: basis cash-vs-future, orari di sessione del feed, spread e
  commissioni storiche. Nessuna di queste e' un problema di fuso.
- **D30EUR resta bocciato** (par. 13): righe marce + sessione ballerina. La v2
  non c'entra e non lo riabilita.

## 15. COLLAUDO v2 ESEGUITO (19/08, 09:04-09:35) — CANCELLO ANCORA CHIUSO, MA IL COLPEVOLE HA UN'ORA E UN NOME DA TROVARE

Sequenza A-E completata (autotest 41/41 sul PC, 3 re-import DST-aware,
raccolta). CSV agli atti: `import_ext_v2_referto_2026-08-19.csv`.

| simbolo | DST-aware | fisso | dentro finestre | fuori | bias mediano | cancello <=0,05 |
|---|---|---|---|---|---|---|
| NASUSD_EXT | 0,0815% | 0,0756% | 0,2673% | 0,0662% | +0,0013% | NO |
| 225JPY_EXT | 0,1097% | 0,1010% | 0,3741% | 0,0871% | +0,0062% | NO |
| SPXUSD_EXT | 0,0655% | 0,0608% | 0,2167% | 0,0527% | +0,0075% | NO |

LETTURE:
1. La cura DST NON risolve (peggiora del 7,7-8,6%): la previsione
   pre-registrata del 14-bis si e' avverata. Dentro le finestre resta
   molto peggio che fuori con ENTRAMBI i metodi.
2. 🔴 LA PISTA PRINCIPALE E' UN EVENTO: la diff massima cade il
   **2026.03.23 alle 11:00 su TUTTI E TRE i simboli** (72.856 / 1.965 /
   18.615 punti). Un'ora sola cosi' anomala, dentro finestre da ~850
   barre, puo' gonfiare da sola la media del "dentro" e mascherare
   l'effetto vero del calendario. PRIMA si isola l'evento, POI si
   rigiudicano le finestre.
3. Bias mediano ~0 su tutti e tre: stesso strumento, niente basis
   cash-vs-future rilevante. Il residuo fuori-finestre (0,053-0,087%)
   resta comunque sopra il cancello: da confrontare col rapporto
   diff/volatilita' oraria dei forex promossi (0,005-0,011% su strumenti
   5-10 volte meno volatili) — se il rapporto coincide, il metro del
   cancello (assoluto, tarato sui forex) va discusso CON una misura e la
   firma di Claudio, mai ammorbidito a occhio.
4. Shift base +5 confermato in ENTRAMBE le scansioni su tutti e tre.
   I tre _EXT restano IN FRIGO.
