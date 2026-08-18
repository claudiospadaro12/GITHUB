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

## 7. ▶️ LE RIGHE DI LANCIO (bozza — passano dal verificatore)

**Passo 1 — autotest + esplorazione della copertura (2 minuti, poche richieste):**
```powershell
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/dukascopy/histdata_m1.py" -OutFile "$env:USERPROFILE\histdata_m1.py"
python "$env:USERPROFILE\histdata_m1.py" --autotest
python "$env:USERPROFILE\histdata_m1.py" --esplora --simboli grxeur,nsxusd,jpxjpy,spxusd --da 2019 --a 2026
```
👉 **Questa riga risponde alla domanda che nessuna fonte sa: fin dove arrivano
davvero gli indici.** Il referto e lo zip finiscono sul Desktop da soli.

**Passo 2 — validazione sul giorno campione (il confronto a tre feed):**
```powershell
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/dukascopy/histdata_m1.py" -OutFile "$env:USERPROFILE\histdata_m1.py"
python "$env:USERPROFILE\histdata_m1.py" --validazione
```
Attesi nel referto: `min 23400.56 / max 23715.65` su una delle tre finestre
(quella a spostamento 0, se il fuso è quello che pensiamo) e il **VERDETTO
FUSO: il feed SEGUE il DST**.

**Passo 3 — solo DOPO la promozione del passo 2 (la corsa vera, minuti non giorni):**
```powershell
python "$env:USERPROFILE\histdata_m1.py" --scarica --converti --simboli grxeur,nsxusd,jpxjpy,spxusd --da 2019 --a 2026
```
Se il POST automatico non passa, **la stessa riga stampa i link da aprire nel
browser**; si salvano gli ZIP in `%USERPROFILE%\histdata_m1` e poi:
```powershell
python "$env:USERPROFILE\histdata_m1.py" --converti --simboli grxeur,nsxusd,jpxjpy,spxusd
```

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
