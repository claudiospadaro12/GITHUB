# 🔎 POSTNEWS ECB + FOMC — **VERIFICA DEL CALENDARIO**: LA RIGA DA MANDARE

> ✅ **PAGINA LANCIABILE — pinnata il 04/09/2026.** Passata da
> `verificatore-stringhe` in due giri: FAIL con 7 difetti (1 bloccante: due
> blocchi PowerShell orfani proprio nella sezione "terminale non trovato"),
> tutti corretti (commit `006ed2f`), poi un secondo giro ha trovato un
> RILIEVO scritto senza condizionarlo alla corsa vera (commit `1a656ce`,
> corretto anche quello). Pin scelto sul commit che contiene il fix finale,
> **verificato file per file via `raw`** (HTTP 200 + sha256 identico al
> repo, §📌 IL PIN sotto).

**Che cos'è:** la prova meccanica che, dopo il fix **v1.10** di
`ABTG_PostNews.mq5` (la lettura del calendario ora prova **`Common\Files` con
`FILE_COMMON`** e solo dopo ripiega sulla sandbox), anche le **DUE sedie
PostNews già VIVE sul VPS** — mai passate dal fix — leggono davvero
`abtg_news.csv`:

| sedia | simbolo | magic | preset | filtri |
|---|---|---|---|---|
| **ECB** | EURJPY M5 | **771201** | `mql5/Presets/ABTG_PostNews_ECB_EURJPY.set` | valuta `EUR`, titolo contiene `ECB` |
| **FOMC** | EURUSD M5 | **771202** | `mql5/Presets/ABTG_PostNews_FOMC_EURUSD.set` | valuta `USD`, titolo contiene `FOMC` |

Il fix è già stato verificato **A MANO** in forward sul preset NFP/USDJPY
(magic 771203) il 04/09/2026: log `UTILI per questo preset 1`. Queste due
sedie no: **girano ancora senza la prova**, e questa riga la fa **sul PC di
backtest, prima** che tu ridistribuisca il fix sul VPS.

> 🛑 **NON È UN ROUND, E NON DÀ NESSUN GIUDIZIO.** Una domanda sola, binaria,
> per sedia: **CALENDARIO LETTO** oppure **CALENDARIO CIECO/PROBLEMA**.
> Da qui **non esce un solo numero economico** (`Optimization=0` → niente CSV,
> niente profitto/PF/DD): nessun Emendamento A/B/C, nessuna promozione,
> nessun "ha edge". Chi legge il referto **non può dire niente sul merito**
> delle due sedie, e il referto stesso lo ripete in fondo.

## 🧭 LE COSE CHE VANNO LETTE PRIMA DI LANCIARE

| | |
|---|---|
| **Non usa `walkforward_generico.ps1`** (scelta dichiarata in testa allo script) | ① il generico **muore senza un asse `\|\|Y`**: per usarlo bisognerebbe *inventare* uno sweep (un secondo magic da censire vergine, o uno sweep che cambia il comportamento). ② il generico **non carica i `.set`**: vuole un `prove\*.txt`, cioè una **trascrizione a mano** del preset — ma qui l'oggetto della verifica **è il preset della sedia viva**, va letto com'è, non ricopiato. ③ il generico spezza sempre in IS/OOS: 4 avvii del tester per una domanda che ne chiede 2. Quindi: **`.ini` scritti dal driver, a passata singola**, struttura copiata campo per campo dal generico e da R114 (`[Charts] MaxBars`, `AllowLiveTrading=false`, `ShutdownTerminal=1`), con **gate sull'`.ini` riletto dal disco**. **Nessun file `prove/*.txt` viene creato: non serve** (scritto qui perché nessuno lo cerchi invano). |
| **Da dove vengono i `[TesterInputs]`** | **tutti** gli input dell'EA letti dal **sorgente al pin** e blindati al **default compilato**, poi il `.set` della sedia **sovrascrive**. Motivo: un input non nominato nell'`.ini` si prende quello che **il tester ricorda dall'ultima corsa** di quell'EA — sul PC di backtest è la corsa NFP, con **un altro calendario**. Scrivere tutto **toglie lo stato nascosto**. |
| **`InpNewsCommon` non è nei due `.set`** (sono precedenti alla v1.10) | nell'`.ini` ci finisce il **default compilato letto dal sorgente**, e c'è un **gate** che pretende che quel default sia `true`: è **la stessa condizione della sedia in forward** (anche un grafico usa il default per ciò che il `.set` non nomina). **I due `.set` NON vengono modificati da questa riga**: la verifica deve misurare i file **così come sono oggi sul VPS**. Aggiungere la riga esplicita è una **modifica candidata, da decidere DOPO** — finisce nei RILIEVI del referto. |
| 🐤 **Il canarino, e cosa prova DAVVERO** | la riga `[PostNews][NEWS] letto da … \| righe N \| UTILI per questo preset M …` la stampa `LoadNews()` **in `OnInit` e poi una volta al giorno** (l'EA ricarica il file quando cambia il giorno): su due settimane le righe attese sono **una decina**, non una, e devono dire tutte la stessa cosa. **Tre gate**: **(a)** `letto da` **deve** essere `Common\Files` — è **questa** la prova del fix (`M>=1` da solo **non proverebbe niente** sul `FILE_COMMON`, perché il file è installato in ENTRAMBI i posti, Common e sandbox della cartella dati). **NON MISURATO**: non sappiamo se la sandbox **dell'agente del tester** (diversa dalla cartella dati — ogni agente di ottimizzazione ha la SUA, sotto `<Tester>\Agent-...\MQL5\Files`, che questa riga NON popola) risponda comunque in una passata singola; se capitasse, l'esito atteso resta comunque leggibile (`CALENDARIO CIECO`, non un `sandbox` silenzioso). Se il canarino dice `sandbox`, il ramo Common ha fallito: **PROBLEMA in ogni caso**; **(b)** `righe N` deve combaciare con le righe evento **contate dal file al pin**; **(c)** `UTILI M` deve combaciare col conto **rifatto dal driver** con le stesse tre regole del sorgente (impatto, valuta, titolo — confronto **case sensitive**, come `StringFind`). |
| ⚠️ **La trappola di lettura** | **`UTILI` conta TUTTO il file, non la finestra testata.** Quindi `M>=1` **non** dimostra che nella finestra ci fosse un evento. Quello è un **gate separato**, fatto **prima di aprire MT5**: se la finestra non contiene almeno un evento **per sedia**, la riga **si ferma**. |
| 🐤 **Il secondo canarino, gratis** | l'autotest dell'EA ha un caso n.5 che **è** il calendario: la riga `[PostNews][AUTOTEST] ---- fine: N casi falliti ----` **deve dire 0**. Gate. |
| 🧪 **Dove si leggono i log (e dove NO)** | **solo le tre radici del TESTER** (`%APPDATA%\MetaQuotes\Tester`, `<CartellaDati>\Tester`, `<Installazione>\Tester`). **Non** `MQL5\Logs`: lanciare il tester con `/config` **avvia il terminale**, che carica l'ultimo profilo coi suoi grafici — se lassù c'è un `ABTG_PostNews` su grafico stampa **il suo** canarino, col **suo** preset, e finirebbe mescolato a quello in prova. |
| 🧹 **Il calendario si RIMETTE com'era** | qui il file si chiama **come quello vero del forward** (`abtg_news.csv`), non come il calendario storico della riga NFP: il driver lo installa in `Common\Files` **e** nella sandbox **con backup**, e a fine giro **rimette tutto com'era** (foto prima/dopo nel referto), sempre — anche se il giro muore a metà. |

| voce | valore |
|---|---|
| EA / versione | `ABTG_PostNews.mq5` **v1.10** (gate ancorato al `#property version`) |
| calendario | `mql5/Files/abtg_news.csv` — quello **vero del forward** (⚠️ `data/abtg_news.csv`, nella cartella `data/` del repo, è **vuoto** e non c'entra) |
| finestra | **2026.01.20 → 2026.02.06** (la più corta che contiene un evento per sedia: **28/01 FOMC** e **29/01 ECB**). Si sposta con `-DaQuando` / `-Fino`: il gate ricontrolla la finestra nuova |
| modello / TF | **1 = 1 minuto OHLC**, `M5` — il modello **non entra nella domanda** (il canarino sta in `OnInit`): si è preso il più leggero |
| passate | **2** in tutto: una per sedia, **singola** (`Optimization=0`) |
| banco | Deposit 100.000, Leverage 100, Currency EUR, `Spread=0` (= spread corrente, **scritto esplicito**): impalcatura, nessun numero esce da qui |

| | |
|---|---|
| **Driver** | `righe/RIGA_POSTNEWS_ECBFOMC_VERIFICA.ps1` (marcatore `MARCATORE_RIGA_POSTNEWS_ECBFOMC_VERIFICA_v1`, `-Pin` obbligatorio) |
| **Dove** | **PC di backtest**, mai il VPS. **MT5 e MetaEditor CHIUSI** (la riga li ricontrolla anche fra una corsa e l'altra) |
| **Quanto ci mette** | compilazione + 2 passate singole OHLC M1 su ~2,5 settimane + 2 avvii del terminale. **Totale onesto: 3-15 minuti** [STIMA]. Se il PC di backtest **non ha gennaio 2026** di EURJPY/EURUSD sul disco, il tempo lo fa lo scarico dello storico — e **questa riga NON misura lo storico**, per scelta: se non escono canarini il referto lo dice **con due nomi possibili, non uno** |

## 📌 IL PIN — **`1a656cecaa2323f8243ae7a0bc10af6a0d95373a`**

✅ **Verificato uno per uno via `raw` il 04/09/2026** (HTTP 200 + `sha256`
identico al repo al pin, tutti e sei i file):

| file al pin | cosa si verifica |
|---|---|
| `backtest_pipeline/righe/RIGA_POSTNEWS_ECBFOMC_VERIFICA.ps1` | marcatore presente, **ASCII puro**, parse `pwsh` OK |
| `mql5/Experts/ABTG_PostNews.mq5` | `#property version "1.10"`, 3 `AT_Caso(` + 2 `falliti++` (5 casi), `InpNewsCommon` default `true` |
| `mql5/Include/ABTG_PausaGuardian.mqh` | una sola `bool ABTG_GuardiaIngresso(` |
| `mql5/Files/abtg_news.csv` | header `Data Ora;Impatto;Valuta;Titolo` + le righe evento (oggi: 17) |
| `mql5/Presets/ABTG_PostNews_ECB_EURJPY.set` | magic 771201, `EUR` / `ECB`, `InpNewsFile=abtg_news.csv` |
| `mql5/Presets/ABTG_PostNews_FOMC_EURUSD.set` | magic 771202, `USD` / `FOMC`, `InpNewsFile=abtg_news.csv` |

Tutti e **sei** scaricati **allo stesso pin**, mai dalla punta del branch.

---

## 1️⃣ GIRO DI CONTROLLO (scarica, gatta, COMPILA, scrive e verifica gli `.ini` — **MT5 NON viene aperto**)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='1a656cecaa2323f8243ae7a0bc10af6a0d95373a'; $t0=Get-Date; $iv=[Globalization.CultureInfo]::InvariantCulture; $p="$env:USERPROFILE\RIGA_POSTNEWS_ECBFOMC_VERIFICA.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_POSTNEWS_ECBFOMC_VERIFICA.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_POSTNEWS_ECBFOMC_VERIFICA_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -SoloControllo; $rc=$LASTEXITCODE;
    $d=$null; foreach($k in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $k -and (Test-Path $k)){ $d=$k } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'POSTNEWS_ECBFOMC_VERIFICA_CONTROLLO_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP POSTNEWS_ECBFOMC_VERIFICA_CONTROLLO_ DI ADESSO SUL DESKTOP: il controllo non e'' arrivato alla raccolta. Mandami quello che vedi qui sopra.' };
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip qui sotto.' -ForegroundColor Yellow };
    if($ko){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Mandami questo zip:' -ForegroundColor Red; Write-Host $z[0].FullName -ForegroundColor Yellow } else { Write-Host 'CONTROLLO OK (fa comunque fede il referto: compilazione OK, 2 .ini verificati, 1 evento in finestra per sedia): lancia il blocco 2.' -ForegroundColor Green };
    Write-Host ('NEL REFERTO la riga data: e'' l''ORA DI AVVIO di questo giro (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + '). La freschezza dello zip l''ha gia'' controllata la riga qui sopra.') -ForegroundColor Gray }
```

## 2️⃣ LA VERIFICA VERA (2 passate singole: EURJPY 771201 e EURUSD 771202)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='1a656cecaa2323f8243ae7a0bc10af6a0d95373a'; $t0=Get-Date; $iv=[Globalization.CultureInfo]::InvariantCulture; $p="$env:USERPROFILE\RIGA_POSTNEWS_ECBFOMC_VERIFICA.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_POSTNEWS_ECBFOMC_VERIFICA.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_POSTNEWS_ECBFOMC_VERIFICA_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin; $rc=$LASTEXITCODE;
    $d=$null; foreach($k in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $k -and (Test-Path $k)){ $d=$k } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'POSTNEWS_ECBFOMC_VERIFICA_CORSA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP POSTNEWS_ECBFOMC_VERIFICA_CORSA_ DI ADESSO SUL DESKTOP: la verifica non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'VERIFICA CON PROBLEMI: lo zip esiste lo stesso, mandalo -- il referto dice quale sedia e perche''.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host ('NEL REFERTO la riga data: e'' l''ORA DI AVVIO di questo giro (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + '). La freschezza dello zip l''ha gia'' controllata la riga qui sopra.') -ForegroundColor Gray;
    Write-Host 'IL VERDETTO E'' IN CIMA AL REFERTO, UNO PER SEDIA: CALENDARIO LETTO / CALENDARIO CIECO-PROBLEMA.' -ForegroundColor Gray }
```

### 🔧 Se dice `NON SO QUALE TERMINALE USARE`

Aggiungi `-Terminale '<cartella copiata dall'elenco che ti ha stampato>'` alla
riga `& $p -Pin $pin ...` **del blocco intero che stavi lanciando** (1️⃣ o 2️⃣) e
rilancia **tutto il blocco**, non solo un pezzo. Esempio sul blocco 1️⃣:

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='1a656cecaa2323f8243ae7a0bc10af6a0d95373a'; $t0=Get-Date; $iv=[Globalization.CultureInfo]::InvariantCulture; $p="$env:USERPROFILE\RIGA_POSTNEWS_ECBFOMC_VERIFICA.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_POSTNEWS_ECBFOMC_VERIFICA.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_POSTNEWS_ECBFOMC_VERIFICA_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -SoloControllo -Terminale 'C:\Program Files\BCM Markets MT5 Terminal'; $rc=$LASTEXITCODE;
    $d=$null; foreach($k in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $k -and (Test-Path $k)){ $d=$k } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'POSTNEWS_ECBFOMC_VERIFICA_CONTROLLO_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP POSTNEWS_ECBFOMC_VERIFICA_CONTROLLO_ DI ADESSO SUL DESKTOP: il controllo non e'' arrivato alla raccolta. Mandami quello che vedi qui sopra.' };
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip qui sotto.' -ForegroundColor Yellow };
    if($ko){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Mandami questo zip:' -ForegroundColor Red; Write-Host $z[0].FullName -ForegroundColor Yellow } else { Write-Host 'CONTROLLO OK: lancia il blocco 2 (con lo stesso -Terminale).' -ForegroundColor Green };
    Write-Host ('NEL REFERTO la riga data: e'' l''ORA DI AVVIO di questo giro (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + ').') -ForegroundColor Gray }
```

### 🗓️ Se vuoi un'altra finestra

Il gate ricontrolla che la finestra nuova contenga **almeno un evento per
sedia** (e se non lo contiene **si ferma**, dicendoti in che date stanno gli
eventi del calendario al pin). **Non lanciare un frammento a parte**: dentro
al blocco intero che stavi già usando (1️⃣ o 2️⃣), nella riga che comincia con
`& $p -Pin $pin`, aggiungi `-DaQuando 2026.09.05 -Fino 2026.09.20` prima del
punto e virgola, poi rilancia **tutto** il blocco `& { ... }` da cima a fondo.

## 📦 COSA TORNA

Zip sul Desktop **`POSTNEWS_ECBFOMC_VERIFICA_CORSA_...zip`** (o
`..._CONTROLLO_...zip` per il giro a vuoto) con:
`REFERTO_POSTNEWS_ECBFOMC_VERIFICA.txt` + `COMPILAZIONE.log` (UTF-16, quello
vero di MetaEditor) + `COMPILAZIONE_leggibile.txt` + i **due `.set`** + i **due
`.ini` VERI** (`gen_POSTNEWSVER_ECB_EURJPY.ini`, `gen_POSTNEWSVER_FOMC_EURUSD.ini`)
+ `abtg_news.csv` al pin + `evidenza_ECB_EURJPY.txt` / `evidenza_FOMC_EURUSD.txt`
(le righe **grezze** dai log) + i **log del tester cresciuti** (`log_<sedia>_*.log`).

⚠️ **Nessun CSV di risultati, e non è un buco:** `Optimization=0` →
`OnTesterDeinit` non gira → nessun OPTFRAME. **Per costruzione.**

## 🔎 COME SI LEGGE — nell'ordine

1️⃣ **IL VERDETTO, in cima al referto, uno per sedia.** È binario:

- ✅ **`CALENDARIO LETTO`** — dice anche *da dove* (`Common\Files`), *quante
  righe* (= il file al pin), *quanti UTILI* (= il conto rifatto dal driver),
  `autotest 0 casi falliti`, e **su quante righe di canarino tutte concordi**.
  ➡️ **Solo allora** ha senso ridistribuire il fix sul VPS.
- ❌ **`CALENDARIO CIECO / PROBLEMA`** — elenca **i motivi, uno per uno**:
  nessun canarino nei log · `CALENDARIO CIECO` · `CANARINO ROSSO` ·
  `letto da` = **sandbox invece di `Common\Files`** (il ramo `FILE_COMMON`
  **non** ha risposto: a passata singola l'EA gira lo stesso, **sugli agenti
  dell'ottimizzazione no**) · `righe` diverse dal file al pin (**ha letto un
  altro `abtg_news.csv`**) · `UTILI` diversi dal conto rifatto · autotest ≠ 0.

2️⃣ **Poi il banco**: `compilazione: OK …, errori 0` · `versione letta dal
#property: 1.10` · `autotest (ricalcolato dal sorgente): 3 AT_Caso() + 2
controlli = 5` · `input dell'EA: 32 … tutti col default risolto` ·
`InpNewsCommon: default compilato = 'true'` · `calendario al pin: … L'EA deve
stampare 'righe 17'` · `finestra: VERIFICATA PRIMA DI APRIRE MT5`.

3️⃣ **Poi le foto PRIMA/DOPO**: `Include\ABTG_PausaGuardian.mqh` →
**INVARIATO**; `Common\Files\abtg_news.csv` e `MQL5\Files\abtg_news.csv` →
**INVARIATO** (installati al pin e **rimessi com'erano**); `Experts\*.mq5` e
`*.ex5` → **CAMBIATO** (atteso: l'EA compilato qui, che resta).

4️⃣ **Infine i RILIEVI** (non spostano il verdetto): ordini pendenti piazzati
(`[PostNews] BUY/SELL STOP @ …` — prova *viva* che `NewsToday()` ha agganciato
la data dell'evento, ma la loro **assenza ha cause legittime**: prezzo fuori
range, stops level, lotto nullo) · i due `.set` non nominano `InpNewsCommon` ·
i due `.set` rischiano **3%/evento** (il numero del corso, fuori dal metro di
casa: **agli atti**, non è oggetto di questa verifica).

## 🛑 COSA NON SI PUÒ DIRE con questo referto

1. **Niente sul merito** delle due sedie: qui non c'è **un solo numero economico**.
2. **Non** "il forward è a posto": la riga verifica i file **al pin, sul PC di
   backtest**. Che il VPS abbia davvero quell'`.ex5` e quei `.set` lo controlli
   **tu** quando ridistribuisci — **il forward non si tocca da qui**.
3. **Non** "UTILI ≥ 1 quindi la finestra conteneva un evento": `UTILI` conta
   **tutto il file**. Gli eventi in finestra sono un **gate separato**.
4. **Niente sugli orari**: in gennaio il preset FOMC è in configurazione
   **estiva** (azione 19:40 server = **40 minuti** dopo la notizia invece di 10;
   d'inverno vorrebbe 18:40). Non tocca il canarino — toccherebbe un giudizio di
   merito, che qui **non si dà**. È però una cosa **da guardare dopo**, sulla
   sedia viva.

## 🚦 LE USCITE, UNA PER UNA (**c'è lo zip? sì o no**)

| Cosa succede | Zip sul Desktop | Cosa mandare |
|---|---|---|
| **MT5 o MetaEditor aperto** (il blocco si ferma **prima** di scaricare) | ❌ **NO** | il messaggio rosso; chiudili e rilancia |
| **`SCRIPT VECCHIO`** o `irm` fallito (404 su un pin appena creato: cache `raw` ~5 min) | ❌ **NO** | il messaggio; aspetta 5 minuti e rilancia **la stessa riga** |
| **Guardie del driver** (`-Pin` mancante/corto, MT5 riaperto nel frattempo) | ✅ **SÌ** (`!!! FERMATO:` nel referto, tutto `NON TENTATA`) | lo zip |
| **Scarico al pin fallito** (404 su EA / include / calendario / uno dei due `.set`) | ✅ **SÌ** | lo zip; se è la cache `raw`, rilancia dopo 5 min |
| **Gate sul sorgente** (versione ≠ 1.10, casi autotest ≠ 5, hedge, include, `InpNewsCommon` non `true`) | ✅ **SÌ** | lo zip: il motivo è in `!!! FERMATO:` — si torna in chat, non si aggiusta a mano |
| **Gate su un `.set`** (chiave che l'EA non ha, magic/valuta/titolo/file diversi dall'atteso) | ✅ **SÌ** | lo zip: **è un guasto vero**, vuol dire che la sedia viva non è quella dichiarata |
| **Gate sul calendario / finestra** (header, zero eventi utili, **nessun evento nella finestra**) | ✅ **SÌ** | lo zip: rilancia con `-DaQuando`/`-Fino` (il referto dice in che date stanno gli eventi) |
| **Terminale non unico** (`NON SO QUALE TERMINALE USARE`) | ✅ **SÌ** | rilancia con `-Terminale '<cartella>'` |
| **Compilazione FALLITA** (o **MUTA**) | ✅ **SÌ** | lo zip: **è il risultato del passo** (i file del terminale sono già stati rimessi a posto) |
| **Una corsa non esce entro `-TimeoutMin`** (default 30) | ✅ **SÌ** | lo zip: il referto dice **due nomi possibili** (storico assente / finestra modale), non uno |
| **Verdetto CIECO/PROBLEMA su una o due sedie** | ✅ **SÌ** (esito `COMPLETATO CON PROBLEMI`, exit 1) | lo zip: **è esattamente il motivo per cui la riga esiste** |
| **Tutte e due CALENDARIO LETTO** | ✅ **SÌ** (exit 0) | lo zip: via libera alla ridistribuzione sul VPS |

## 🔴 AVVISI ATTESI (nessuno è un guasto)

1. **MT5 si apre DUE volte** (una per sedia). Non interromperlo in mezzo.
   Con `-SoloControllo` **non si apre mai**: nessuna eccezione, a differenza
   della riga NFP che doveva misurare lo storico.
2. **Una decina di righe di canarino per sedia**, non una: l'EA **ricarica il
   calendario ogni volta che cambia il giorno**. Devono dire tutte la stessa
   cosa — se cambiano, è un PROBLEMA e il referto lo dice.
3. Giallo *"Questo EA usa PERIOD_CURRENT…"*: non si applica, l'EA lavora a
   **M5 fisso** via `iHigh/iLow(_Symbol,PERIOD_M5,…)`.
4. `include … installato` e poi `ripristino del terminale: … RIPRISTINATO /
   RIMOSSO`: è la regola di casa al lavoro. Un giro interrotto a mano viene
   rimesso a posto dal giro successivo, **con dichiarazione nei RILIEVI**.
5. `CODICE DI USCITA NON LETTO` a fine blocco: non è un fallimento, fa fede il
   referto.
6. `Tester\cache svuotata`: a passata singola conta meno che in ottimizzazione,
   ma si fa lo stesso e si dichiara.

## 🔁 RICETTA DEL PIN (prima pinnatura) — si prova su una COPIA prima di scriverla

```bash
F=backtest_pipeline/righe/RIGA_POSTNEWS_ECBFOMC_VERIFICA_DA_MANDARE.md
SHA=$(git rev-parse HEAD)          # il commit che CONTIENE driver + EA + include + calendario + i due preset
TOK='@@PIN'"@@"                    # composto: la ricetta non contiene la stringa che cerca
sed -i "s|\$pin='$TOK'|\$pin='$SHA'|g; s|\*\*\`$TOK\`\*\*|\*\*\`$SHA\`\*\*|" "$F"
grep -c "\$pin='$SHA'" "$F"        # DEVE dare 3 (blocco 1, blocco 2, l'esempio -Terminale)
grep -c "\$pin='$TOK'" "$F"        # DEVE dare 0
grep -c "$TOK" "$F"                # DEVE dare 0: l'ULTIMO segnaposto vive nel
                                   # CARTELLO in cima, che va RISCRITTO a mano
CART='non e'' ancora lanciab'"ile"'\|il pin non e'' stato scel'"to"   # composto
grep -ci "$CART" "$F"              # DEVE dare 0 dopo aver RISCRITTO il cartello in cima
```

**Il cartello in cima** ("QUESTA PAGINA NON È ANCORA LANCIABILE…") va
**RISCRITTO**, non solo lasciato: una frase che sopravvive alla pinnatura
direbbe il falso a chi legge dopo.
