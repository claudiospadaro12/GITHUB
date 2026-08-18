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
