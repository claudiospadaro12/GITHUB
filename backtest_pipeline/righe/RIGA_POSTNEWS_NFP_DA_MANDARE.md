# 🎯 POSTNEWS NFP/USDJPY — PASSO 0 (conta-occasioni): **LA RIGA DA MANDARE**

**Che cos'è:** il **PASSO 0** del preset NFP/USDJPY di `ABTG_PostNews.mq5` v1.10 —
la slide del corso AB Forex ("man_FX_2018_protec...", pag. 140-143, portata da
Claudio il 03/09/2026): ogni primo venerdì del mese, 15 minuti dopo la
disoccupazione USA, due pendenti (BUY STOP / SELL STOP) sul range delle due
candele M5 successive alla notizia. **Modello 1 (1 minuto OHLC = SCREENING,
mai un verdetto)**, `@PERIODO M5`, **UNA finestra IS/OOS**, **UN solo asse**:
`InpMagic` 771203/771208 — **due celle gemelle che DEVONO uscire identiche**
(stesso motore, cambia solo il magic: è un controllo di coerenza gratis, non
una griglia).

> 🔮 **Questa cella NON PUÒ PROMUOVERE NIENTE — dichiarato nel prova stesso,
> PRIMA dei numeri.** 12 eventi/anno × 2 gambe non arrivano a 150 operazioni IS
> nemmeno prendendo tutto lo storico disponibile (2010-2025). Il giudizio
> possibile è **SOLO sul RISCHIO** (Emendamento B: se il DD sfonda si boccia)
> e la lettura **"campione sottile"** (Emendamento A, valvola R59): mai una
> promozione, mai un "ha edge"/"non ha edge".

## 🧭 PERCHÉ QUESTA RIGA È DIVERSA DALLE ALTRE DI OGGI (leggilo prima di lanciare)

| | |
|---|---|
| **@DAQUANDO omesso apposta** | Modello 1 lavora su barre **M1 VERE**: la data giusta è quella in cui BCM possiede *davvero* le barre M1 di USDJPY, non `2010.01.01` a occhio. **La riga la MISURA da sola** (fase 8), con lo stesso meccanismo di `scarica_storico.ps1` (`ABTG_HistoryDownloader.mq5`), **eseguito dentro questo driver**, sullo **stesso terminale/cartella dati** già risolti alla fase 5 — non chiama `scarica_storico.ps1` come processo separato apposta: quello script si sceglie il terminale **da solo** e non accetta un `-Terminale`, quindi con due installazioni BCM ambigue misurerebbe lo storico su un terminale e girerebbe il tester su un altro. |
| **Eccezione dichiarata: `-SoloControllo` qui APRE MT5 una volta** | Solo per lo script di misura storico (fase 8), **mai** per il tester: senza la data vera, anche l'anteprima del generico sarebbe una controprova su un numero indovinato. È l'unico modo per non indovinare `@DAQUANDO` neppure nel giro a vuoto. `-SoloControllo` resta comunque il **giro leggero**: il generico gira con `-SoloControllo` (MT5 non riapre per il backtest). |
| **Il canarino è una riga di LOG, non una colonna CSV** | `[PostNews][NEWS] letto da ... \| UTILI per questo preset N \| dal .. al ..` lo stampa `OnInit()` dell'EA nel log del **TESTER** (uno per ogni pass/agente), non l'OPTFRAME. La riga lo legge dai log (5 radici, come le altre righe di oggi) e lo stampa **in chiaro** nel referto: `N=0` è un **PROBLEMA esplicito**, mai un warning sepolto. |
| **Nessun `#define` per l'autotest** | A differenza di `ABTG_LondonFx`, questo EA non dichiara `BLOCCHI_ATTESI`/`CASI_ATTESI`. Il conteggio si **RICALCOLA dal sorgente appena scaricato al pin** (occorrenze di `falliti+=AT_Caso(` + `if(!X) falliti++;`): oggi (v1.10) fa **3+2=5**, e il gate lo verifica ogni volta contro il file vero, non contro un numero scritto qui una volta per tutte. |
| **Il preset `.set` non viene caricato dal tester** | `walkforward_generico.ps1` non supporta i `.set`: è il **contratto** da cui il prova è stato derivato a mano. La riga verifica che i **31 valori fissi combacino uno a uno** fra prova e preset (fase 4) — se divergono, è un'incoerenza vera e ci si ferma. |
| **Nessun per-trade CSV** | `OnTesterDeinit()` di questo EA scrive solo l'OPTFRAME (9 colonne: `Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,InpMagic`). Niente `ExportTrades`: dichiarato, non un buco del driver. |
| **Blocco magic 771203/771208 vergine** | Verificato **ORA, dall'assistente, sul repo** (03/09/2026): nessun'altra occorrenza in `mql5/` fuori dal preset e dal prova nuovi. La riga **non può riverificarlo a runtime**: il PC di backtest non ha il repo clonato (come tutte le righe di questa casa). |

| voce | valore |
|---|---|
| EA / versione | `ABTG_PostNews.mq5` **v1.10** (mai compilato prima: la compilazione avviene qui) |
| preset | `mql5/Presets/ABTG_PostNews_NFP_USDJPY.set` (magic 771203, offset 3.0/2.0, SL 25/TP 30, rischio 0,65%/ordine — 1,30%/evento) |
| prova | `prove/POSTNEWS_NFP_00_conta.txt` (`@DAQUANDO` **omesso apposta**) |
| calendario | `mql5/Files/abtg_news_postnews_2010_2025_UTC.csv` (599 eventi 2010-2025, header `Data Ora;Impatto;Valuta;Titolo`) |
| simbolo | **USDJPY**, fisso (nessuna gamba gemella su questo preset) |
| modello / TF | **1 = 1 minuto OHLC (SCREENING)**, `@PERIODO` **M5** |
| celle | **2** (`InpMagic` 771203/771208, gemelle: DEVONO uscire identiche) |
| finestra | **MISURATA da questa riga** (fase 8) → `2026.06.30` (`-Fino`), split 40/60 come lo calcola il generico |
| rischio | 1,30%/evento (0,65%/ordine su 50 pip), deposito 100.000 |

> ⚙️ **LE SCELTE CHE I MATERIALI NON FISSAVANO — dichiarate (clausola severa):**
> **(a)** Etichetta CSV `NFP00` (quella suggerita nel prova stesso); **(b)**
> Deposito 100.000, `FrazioneIS` 0,40, `-Fino 2026.06.30`: default di casa,
> nessun materiale li fissava diversamente per QUESTO preset; **(c)**
> `-DaQuandoRichiesta 2010.01.01`: il punto da cui la misura CHIEDE lo storico
> al broker — il valore VERO che finisce nel test è quello **misurato**
> (`PrimaDataServer`), quasi certamente successivo; **(d)** `-TimeoutStoricoMin
> 45`, **max 2 tentativi**: la misura M1-senza-tick è più leggera del download
> tick di `scarica_storico.ps1` (default 90), ma nessun materiale ha mai
> cronometrato QUESTA misura — stima onesta, non una previsione; **(e)**
> l'Emendamento B (rischio) si legge **solo su Equity DD%** (l'unico che
> l'OPTFRAME di questo EA esporta, niente Peggior Giornata%): nessuna soglia
> numerica è stata CONGELATA per questo preset in nessun materiale ricevuto —
> il referto stampa il numero, la chiamata resta a chi legge; **(f)** nessuna
> prova di regime (Emendamento C, 4 finestre toro/orso/laterale/crollo): il
> prova dichiara UNA finestra sola — fuori scopo del Passo 0, dichiarato.

| | |
|---|---|
| **Driver** | `righe/RIGA_POSTNEWS_NFP.ps1` (marcatore `MARCATORE_RIGA_POSTNEWS_NFP_v2`, `-Pin` obbligatorio) |
| **Dove** | **PC di backtest**, non VPS. **MT5 e MetaEditor CHIUSI** prima di lanciare (la riga li riguarda anche subito prima della misura storico) |
| **Quanto ci mette** | compilazione (EA nuovo) + **misura storico M1 USDJPY senza tick** (10-45 minuti, MOLTO variabile: dipende da quanti anni servono davvero) + 2 passate OHLC M1 su una finestra pluriennale (secondi-minuti, non tick reali) + 2-3 avvii del terminale. **Totale onesto: 20-60 minuti, quasi tutti nella misura storico** [STIMA: nessuna corsa di casa ha mai cronometrato questa misura per USDJPY, il numero vero lo dice questo giro] |

## 📌 IL PIN — **`563e70ef24f3edf22a13d621fda66dc8293407fe`**

Commit di `lavoro` (03/09/2026), **verificato file per file via `raw` prima di
scrivere questa pagina** (HTTP 200 + hash sha256 identico al repo, driver
verificato anche col marcatore e col parse `pwsh`):

| file al pin | esito |
|---|---|
| `backtest_pipeline/righe/RIGA_POSTNEWS_NFP.ps1` | marcatore `MARCATORE_RIGA_POSTNEWS_NFP_v2` presente, ASCII puro, parse `pwsh` OK |
| `backtest_pipeline/prove/POSTNEWS_NFP_00_conta.txt` | `@DAQUANDO`/`@FINOA` assenti, 34 righe vive |
| `backtest_pipeline/walkforward_generico.ps1` | identico (il driver lo pinna col replace di `$EABranch` **e gli alza `[Charts] MaxBars`**, poi rilegge **dal disco** lo stato finale di entrambi: 2 occorrenze attese) |
| `mql5/Experts/ABTG_PostNews.mq5` | `#property version "1.10"`, 3 `AT_Caso(` + 2 `falliti++` (5 casi) |
| `mql5/Include/ABTG_PausaGuardian.mqh` | v1.51 |
| `mql5/Presets/ABTG_PostNews_NFP_USDJPY.set` | 32 righe (31 fissi + InpMagic 771203) |
| `mql5/Files/abtg_news_postnews_2010_2025_UTC.csv` | 600 righe (1 header + 599 eventi) |
| `mql5/Scripts/ABTG_HistoryDownloader.mq5` | lo strumento della **misura storico** (fase 8): scritto qui perché il driver lo scarica **al pin** come gli altri, e senza di lui non esiste `-DaQuando` |

Tutti e **otto** scaricati **allo stesso pin**, mai dalla punta del branch —
verificati uno per uno via `raw` (HTTP 200 + `sha256` identico al repo al pin).

---

## 1️⃣ GIRO DI CONTROLLO (scarica, gatta, COMPILA, **misura storico**, generico `-SoloControllo`)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='563e70ef24f3edf22a13d621fda66dc8293407fe'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_POSTNEWS_NFP.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_POSTNEWS_NFP.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_POSTNEWS_NFP_v2' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -SoloControllo; $rc=$LASTEXITCODE;
    $d=$null; foreach($k in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $k -and (Test-Path $k)){ $d=$k } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'POSTNEWS_NFP_CONTROLLO_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP POSTNEWS_NFP_CONTROLLO_ DI ADESSO SUL DESKTOP: il controllo non e'' arrivato alla raccolta. Mandami quello che vedi qui sopra.' };
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip qui sotto.' -ForegroundColor Yellow };
    if($ko){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Mandami questo zip:' -ForegroundColor Red; Write-Host $z[0].FullName -ForegroundColor Yellow } else { Write-Host 'CONTROLLO OK (fa comunque fede il referto nello zip: compilazione OK, storico misurato, celle 2): lancia il blocco 2.' -ForegroundColor Green } }
```

**ATTENZIONE:** questo blocco **APRE MT5 una volta** (fase 8, misura storico —
vedi tabella sopra): non è un errore, è dichiarato. Può durare **10-45 minuti**
da solo se lo storico M1 non è ancora sul disco del PC di backtest.

## 2️⃣ CORSA VERA (2 celle × 2 finestre, Modello 1 OHLC M1)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='563e70ef24f3edf22a13d621fda66dc8293407fe'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_POSTNEWS_NFP.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_POSTNEWS_NFP.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_POSTNEWS_NFP_v2' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin; $rc=$LASTEXITCODE;
    $d=$null; foreach($k in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $k -and (Test-Path $k)){ $d=$k } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'POSTNEWS_NFP_CORSA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP POSTNEWS_NFP_CORSA_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if($ko){ Write-Host 'CORSA CON PROBLEMI: lo zip esiste lo stesso, mandalo -- il referto dice dove si e'' fermata.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('POI nel REFERTO_POSTNEWS_NFP_USDJPY.txt: riga modo: = CORSA, e riga data: = ORA DI AVVIO di questa corsa (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + '): il referto si timbra all''INIZIO e la corsa dura decine di minuti (quasi tutti nella misura storico).') -ForegroundColor Gray }
```

## 🩹 SE LA MISURA STORICO SI FERMA («MISURA STORICO NON RIUSCITA»)

Non è un guasto della riga: `ABTG_HistoryDownloader` non ha finito di
scaricare le barre M1 di USDJPY entro il tetto (45 minuti × 2 tentativi). Il
download **resta sul disco** (`bases\` non si svuota mai): **rilancia lo
stesso blocco**, quasi certamente più veloce del primo giro. Se serve più
tempo a tentativo, aggiungi `-TimeoutStoricoMin 90` (o più) alla riga:

```powershell
& $p -Pin $pin -TimeoutStoricoMin 90
```

## 📦 COSA TORNA

Zip sul Desktop **`POSTNEWS_NFP_CORSA_...zip`** (o `POSTNEWS_NFP_CONTROLLO_...zip`
per il giro a vuoto) con: `REFERTO_POSTNEWS_NFP_USDJPY.txt` + `COMPILAZIONE.log`
(UTF-16, il log vero di MetaEditor) + `COMPILAZIONE_leggibile.txt` + il prova +
il preset + `ABTG_StoricoScaricato_M1_USDJPY.csv` (il referto GREZZO della
misura storico) + i **CSV OPTFRAME** `ABTG_PostNews_USDJPY_IS_ohlc_NFP00.csv` e
`_OOS_` (**2 righe l'uno** = magic 771203/771208, 9 colonne: `Pass,Profit,
Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,
InpMagic`) + gli **`.ini VERI`** della corsa (`gen_*.ini`, con `Model=1`) + i
**log del tester cresciuti** durante il giro (dove vive il canarino NEWS).

⚠️ **Suffisso `_ohlc` nei nomi CSV**: è la marca del generico per i modelli
non-tick — qui il modello è **1** (screening), quindi il suffisso è **atteso**,
non un errore (a differenza delle righe a tick reali di oggi).

## 🔎 COME SI LEGGE — nell'ordine

🕐 **PRIMA DI TUTTO** apri il referto e controlla:
- **`data:`** = **l'ora in cui hai lanciato il blocco** (si timbra all'**AVVIO**;
  la corsa dura decine di minuti, quasi tutti nella misura storico: l'ora
  attuale non è il metro). La freschezza dello zip l'ha già controllata a
  macchina la riga qui sopra (`LastWriteTime -ge $t0`).
- **`modo:`** = **CORSA** (CONTROLLO = giro a vuoto, non è il risultato).
- **`compilazione:`** — **tre stati, tutti veri**: `OK (… KB …), errori 0` → si
  va avanti; `FALLITA (…)` → **QUESTO È IL RISULTATO DEL PASSO** (l'EA non era
  mai stato compilato prima: gli errori sono nelle prime 30 righe del log a
  schermo e nel log dentro lo zip, i fix tornano in `mql5/Experts/`); `FALLITA
  -- METAEDITOR MUTO` → non è un verdetto sul codice, si ricontrolla e si rifà.
- **identità**: `versione letta dal #property: 1.10`, `autotest (ricalcolato
  dal sorgente): 3 AT_Caso() + 2 controlli = 5 casi totali`, `OnTester:
  presente`, `hedge-safe: 0 chiamate`, `include censiti: 2 (Trade/Trade.mqh,
  ABTG_PausaGuardian.mqh)`.
- **`coerenza prova <-> preset .set:`** = `VALIDO: 31 fissi identici uno a
  uno, InpMagic preset (771203) = lead dell'asse prova`. Se dice altro, preset
  e prova NON sono più lo stesso contratto: ci si ferma prima dei numeri.
- **`calendario:`** = `600 righe (1 header + 599 eventi), header verificato` +
  le due righe di foto (Common\Files e MQL5\Files, prima/dopo): entrambe
  devono mostrare **la stessa dimensione** del file al pin.
- **`--- MISURA STORICO M1 USDJPY ---`**: la riga chiave. Deve dire `MISURATA
  al tentativo N/2: verdetto '...', PrimaDataServer <data>`. Quella **data** è
  il vero `-DaQuando` usato sotto — **mai** una data scritta a mano. Se il
  verdetto è `IL BROKER NON HA PIU' STORICO`, è nei RILIEVI: la finestra
  IS/OOS parte da un punto più tardi del calendario 2010-2025 — dichiarato,
  non un errore.
- **`foto PRIMA/DOPO`**: `Include\ABTG_PausaGuardian.mqh → INVARIATO`;
  `Experts\.mq5` e `.ex5 → CAMBIATO` (atteso: l'EA compilato qui, che resta).
- **`cache tester: prima N file, dopo 0`** · **`celle: 2 ...`** · **`corsa:
  ... CSV IS e OOS LETTI (freschi), 2 + 2 righe`** · **`Model letto: ...
  Model=1`** (dall'.ini VERO) · **`log del tester letti: N`** (un gate che
  non legge niente non è verde).

🐤 **POI IL CANARINO NEWS (letto dai LOG, non dal CSV — la differenza vera di
questo round):**
- riga `[PostNews][NEWS] letto da ... | UTILI per questo preset N | dal .. al
  ..` ricopiata in chiaro. `N=0` → **PROBLEMA**: *"calendario cieco, la
  passata NON CONTA"*, non un warning sepolto. `CALENDARIO CIECO` o
  `CANARINO ROSSO` nei log → stesso trattamento.
- riga `[PostNews][AUTOTEST] ---- fine: N casi falliti ----` per ogni pass
  trovato nei log: **atteso 0** su ognuna. Se una sola riga dice N≠0, l'EA
  diverge dalla sua stessa spec e i numeri economici NON si leggono (finisce
  nei PROBLEMI).

📊 **POI IL CONTO ECONOMICO** (per finestra, magic 771203 e 771208 affiancati):
`n` (con l'etichetta Emendamento A: `PASSA` ≥150 / `MERITO SOSPESO` 30-149 /
`NON MISURABILE` <30), `Profit`, `Payoff`, `PF`, `RF`, `Sharpe`, `Equity DD%`.
**Gemelli**: `IDENTICI al centesimo` (atteso) — se dice `ROTTI`, il banco è
sporco e il round è fermo (sanità di base, non un dettaglio).

🛑 **E COSA NON SI PUÒ DIRE con questi dati (ricopiato nel referto):**
"ha edge"/"non ha edge" (campione sotto 150, dichiarato PRIMA), "regge nel
tempo" (nessuna prova di regime qui), "il DD sarà quello" (Modello 1 = OHLC,
screening, mai un verdetto — il passo a tick reali sulla finestra recente è il
prossimo, SE questo screening interessa), promuovere qualunque cella da qui.
E l'asterisco della slide: sulle **10 disoccupazioni USA di novembre** (su
186, 5% del campione) l'ora d'azione fissa (13:45 server) legge le candele
**sbagliate** (l'Europa ha già cambiato ora, gli USA no) — un risultato
positivo resta valido con l'asterisco, uno negativo va riletto.

## 🚦 LE USCITE, UNA PER UNA (**c'è lo zip? sì o no**)

| Cosa succede | Zip sul Desktop | Cosa mandare |
|---|---|---|
| **MT5 o MetaEditor aperto** (il blocco si ferma **prima** di scaricare) | ❌ **NO** | il messaggio rosso; chiudili e rilancia |
| **`SCRIPT VECCHIO`** o `irm` fallito (404 su un pin appena creato: cache raw ~5 min) | ❌ **NO** | il messaggio; aspetta 5 minuti e rilancia **la stessa riga** |
| **Guardie del driver**: `-Pin` mancante/corto, MT5 riaperto nel frattempo | ✅ **SÌ** (`!!! FERMATO:` nel referto, tutto `NON TENTATA`) | lo zip |
| **Scarico al pin fallito** (404 sul generico/prova/preset/calendario/EA/include/history downloader) | ✅ **SÌ** | lo zip; se è la cache raw, rilancia dopo 5 min |
| **Gate sul sorgente** (versione ≠ 1.10, casi autotest ≠ 5, hedge, include, OnTester) o **sul prova** (`@DAQUANDO`/`@FINOA` presenti, asse, celle, fissi) o **di coerenza col preset** | ✅ **SÌ** | lo zip: il motivo è in `!!! FERMATO:` — non si aggiusta a mano, si torna in chat |
| **Calendario** (righe ≠ 600, header diverso, installazione fallita) | ✅ **SÌ** | lo zip |
| **Terminale non unico** (`NON SO QUALE TERMINALE USARE`) | ✅ **SÌ** | rilancia lo stesso blocco con `& $p -Pin $pin -Terminale '<cartella dell'installazione>'` |
| **Compilazione FALLITA** (o MUTA) | ✅ **SÌ** | lo zip: **è il risultato del passo** (include già rimesso a posto) |
| **Misura storico NON riuscita** (2 tentativi, tetto raggiunto) | ✅ **SÌ** | lo zip: rilancia (vedi §🩹 sopra), eventualmente con `-TimeoutStoricoMin` più alto |
| **Corsa con PROBLEMI** (CSV stantio/mancante, righe ≠ 2, gemelli divergenti, autotest ≠ 0, **canarino N=0 / `CALENDARIO CIECO` / `CANARINO ROSSO` / canarino ASSENTE a corsa finita**, `no memory`) | ✅ **SÌ** (esito `COMPLETATO CON PROBLEMI`, exit 1) | lo zip: il referto dice quale sanità è caduta |
| **Corsa OK** | ✅ **SÌ** | lo zip |

## 🔴 AVVISI ATTESI (nessuno è un guasto)

1. **Giallo** *"Questo EA usa PERIOD_CURRENT..."* — **non si applica**: questo
   EA lavora a M5 fisso via `iHigh/iLow(_Symbol, PERIOD_M5, ...)`, non legge il
   TF del tester. Se compare comunque, non è un errore: `@PERIODO M5` del
   prova è quello vero.
2. **MT5 si apre due volte**: una per la misura storico (fase 8, dichiarato in
   testa alla pagina), una per il tester (fase 10, dentro `walkforward_generico.ps1`).
   Non interromperlo in mezzo.
3. Ogni 15s durante la misura storico: `... CSV N byte, storico bases N MB` —
   **non interrompere**, è il battito del download (non il silenzio).
4. Suffisso `_ohlc` nei CSV — **atteso**, Modello 1 non è tick reali.
5. `Model letto: ... Model=1` — è quello vero, non `Model=4` come le righe a
   tick reali di oggi.
6. `include ... installato AL PIN in MQL5\Include (backup ...)` e poi
   `ripristino del terminale: ... RIPRISTINATO/RIMOSSO` — classe 116 al lavoro.
   Un giro interrotto a mano viene rimesso a posto dal giro successivo, con
   dichiarazione nei RILIEVI.
7. `CODICE DI USCITA NON LETTO` a fine blocco — non è un fallimento: fa fede
   il referto.
8. `driver generico ... con MaxBars alzato -- stato finale riletto dal disco` —
   il tetto «Max barre nel grafico» del terminale non deve poter troncare **in
   silenzio** una finestra pluriennale (checklist 36). Se il generico al pin
   cambiasse, la riga si ferma qui invece di produrre numeri coerenti e falsi.
   [INFERITO che il tester onori la riga: non è misurato da nessuna corsa di casa.]
9. `il broker NON ha M1 fino a 2010.01.01: il muro vero e' <data>` nei RILIEVI
   — non è un errore, è la misura che ha fatto il suo lavoro: il calendario
   copre 2010-2025 ma lo storico M1 del broker può partire più tardi.

## 🔁 RICETTA DEL PIN (prima pinnatura) — si prova su una COPIA prima di scriverla

```bash
F=backtest_pipeline/righe/RIGA_POSTNEWS_NFP_DA_MANDARE.md
SHA=$(git rev-parse HEAD)          # il commit che CONTIENE driver + prova + preset + calendario + EA + include + generico
TOK='@@PIN'"@@"                    # composto: la ricetta non contiene la stringa che cerca
sed -i "s|\$pin='$TOK'|\$pin='$SHA'|g; s|\*\*\`$TOK\`\*\*|\*\*\`$SHA\`\*\*|" "$F"
grep -c "\$pin='$SHA'" "$F"        # DEVE dare 2 (blocchi 1-2)
grep -c "\$pin='$TOK'" "$F"        # DEVE dare 0
CART='segnap'"osto"'\|non funz'"iona"'\|la riga non par'"te"   # composto: la ricetta non deve contenere il cartello che cerca
grep -ci "$CART" "$F"             # DEVE dare 0 dopo aver RISCRITTO il cartello
```
**Il cartello** ("QUESTA PAGINA NON È ANCORA LANCIABILE...") va **RISCRITTO**,
non solo lasciato: una frase che sopravvive alla pinnatura direbbe il falso
a chi legge dopo (classe 101).
