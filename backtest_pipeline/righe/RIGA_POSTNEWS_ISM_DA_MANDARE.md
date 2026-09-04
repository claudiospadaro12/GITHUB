# 🎯 POSTNEWS ISM1500/EURUSD — PASSO 0 (conta-occasioni): **LA RIGA DA MANDARE**

> ✅ **PRONTA — pinnata il 04/09/2026** al commit `c1782ffbba2d207480691c7c13b84e50cbbb52a8`
> (ricetta del pin applicata, nessun segnaposto residuo). **Passo 2 della
> ricetta (riscarico via `raw` + confronto sha256) fatto qui sotto**, vedi la
> tabella del pin.

**Che cos'è:** il **PASSO 0** del preset ISM1500/EURUSD di `ABTG_PostNews.mq5`
v1.10 — il **candidato A** della caccia del 04/09/2026
(`backtest_pipeline/caccia_strategie/CACCIA_POSTNEWS_ALTRE_FAMIGLIE_2026-09-04.md`).
Il **meccanismo non è nuovo**: è lo stesso della sedia NFP (all'ora d'azione due
pendenti — BUY STOP e SELL STOP — sul range delle due candele M5 già chiuse).
Cambia **una cosa sola: l'EVENTO** — qui il blocco delle **15:00 server** (ISM
Manufacturing PMI, ISM Services PMI, CB Consumer Confidence), su **EUR/USD**.
**Modello 1 (1 minuto OHLC = SCREENING, mai un verdetto)**, `@PERIODO M5`, **UNA
finestra IS/OOS**, **UN solo asse**: `InpMagic` 774701/774706 — **due celle
gemelle che DEVONO uscire identiche** (stesso motore, cambia solo il magic: è un
controllo di coerenza del banco gratis, non una griglia).

> 🔮 **DA QUESTA CELLA NON PUÒ USCIRE NESSUNA PROMOZIONE — dichiarato PRIMA dei
> numeri.** Non perché il campione sia per forza sottile (qui, a differenza
> dell'NFP, `n` **potrebbe** superare 150: vedi *Il conto dei 150* sotto), ma
> perché **il banco è Modello 1 = OHLC = screening**. In questa casa l'illusione
> OHLC ha già revocato una promozione (SupRev DOW H4: PF **2,77** OHLC contro
> **0,79** a tick reali). Il giudizio di **RISCHIO** (Emendamento B) vale a
> qualunque `n`, ma su questo OPTFRAME si legge **solo su Equity DD %**.

## 🧭 PERCHÉ QUESTA RIGA È DIVERSA (leggilo prima di lanciare)

| | |
|---|---|
| **`@DAQUANDO` omesso apposta** | Modello 1 lavora su barre **M1 VERE**: la data giusta è quella in cui BCM possiede *davvero* le barre M1 di EURUSD, non `2010.01.01` a occhio. **La riga la MISURA da sola** (fase 8) con `ABTG_HistoryDownloader.mq5`, **eseguito dentro questo driver**, sullo **stesso terminale/cartella dati** già risolti alla fase 5 — non chiama `scarica_storico.ps1` come processo separato apposta: quello si sceglie il terminale **da solo** e non accetta un `-Terminale`. |
| 🧱 **PAVIMENTO `2010.01.01` — differenza di logica rispetto alla riga NFP** | **Fatto già MISURATO**: in **R102** (24/08) lo scarico M1 di EURUSD da BCM ha dichiarato **10.014.728 barre "dal 1971.01.03"**, mentre la **prima operazione vera** di quel round su EURUSD è del **1999.01.18**. Se la riga prendesse quella data alla lettera, con `-Fino 2023.12.31` e split 0,40 **l'IS finirebbe fra il 1971 e il 1992**: zero eventi, `Trades=0`, e sembrerebbe *"niente edge"* mentre è *"non è girata"*. Perciò `-DaQuando` usato = **il più tardi** fra la data **misurata** e `-PavimentoDaQuando`. **Nel referto ci sono TUTTI E DUE i numeri**, e se il pavimento morde finisce nei RILIEVI. |
| 📅 **`-Fino 2023.12.31` (non `2026.06.30`)** | Il calendario di questo blocco **copre 2010-2023 e basta** (sorgente Forex Factory di casa). Con `-Fino 2026.06.30` gli ultimi 2,5 anni varrebbero **zero occasioni** e sposterebbero il confine IS/OOS sulla base di **tempo morto**. ⚠️ Questa scelta **RIDUCE** il campione IS (**189** occasioni invece di 224): non è scelta per superare una soglia. |
| 🔢 **CONTA-OCCASIONI a macchina, PRIMA del tester (fase 8-bis)** | La cella si chiama `00_conta` e allora conta davvero: dal calendario **scaricato al pin** la riga estrae le **giornate distinte** che passano i filtri del preset e le divide fra IS e OOS **con lo stesso split del generico**. **Un'occasione NON è un'operazione**: ogni giornata piazza **due** pendenti e ne scattano 0, 1 o 2 — l'Emendamento A si applica alla colonna `Trades`, **mai** a questo numero. Occasioni IS = 0 → **PROBLEMA**. |
| **Eccezione dichiarata: `-SoloControllo` qui APRE MT5 una volta** | Solo per lo script di misura storico (fase 8), **mai** per il tester: senza la data vera anche l'anteprima del generico sarebbe una controprova su un numero indovinato. |
| 🐤 **Il canarino è una riga di LOG, non una colonna CSV — e qui ha un valore ATTESO** | `[PostNews][NEWS] letto da ... \| righe 463 \| UTILI per questo preset 431 \| dal 2010.01.04 al 2023.12.20` lo stampa `OnInit()` nel log del **TESTER**. La riga lo legge dai log (5 radici) e lo stampa **in chiaro**. `N=0` → **PROBLEMA**. E anche **`N ≠ 431` → PROBLEMA**: il numero è stato **contato a macchina sul calendario al pin** in fase 4, quindi una discordanza vuol dire che il filtro non seleziona quello che crediamo. |
| **Nessun `#define` per l'autotest** | Il conteggio si **ricalcola dal sorgente appena scaricato al pin** (`falliti+=AT_Caso(` + `if(!X) falliti++;`): oggi (v1.10) fa **3+2=5**. |
| **Il preset `.set` non viene caricato dal tester** | `walkforward_generico.ps1` non supporta i `.set`: è il **contratto** da cui il prova è stato derivato a mano. La riga verifica che i **31 valori fissi combacino uno a uno** (fase 4) e che `InpMagic` del preset (**774701**) sia il **lead** dell'asse. Se divergono, ci si ferma **prima** dei numeri. |
| **Nessun per-trade CSV** | `OnTesterDeinit()` scrive solo l'OPTFRAME (9 colonne). Niente `ExportTrades`: dichiarato, non un buco del driver. |
| **Blocco magic 774701/774706 vergine** | Verificato **ORA, dall'assistente, sul repo** (04/09/2026): `774701` compare solo nel preset e nel prova nuovi, `774706` **non compariva da nessuna parte**. ⚠️ **`774702` NON si usa qui**: è **riservato** nel preset al gemello **cross-simbolo** (ISM su USDJPY), che è un altro round. La riga non può riverificarlo a runtime (il PC di backtest non ha il repo clonato). |

| voce | valore |
|---|---|
| EA / versione | `ABTG_PostNews.mq5` **v1.10** |
| preset | `mql5/Presets/ABTG_PostNews_ISM1500_EURUSD.set` (magic 774701, azione **15:15** server, scadenza **16:25** con `InpCloseAtExpiry=true`, offset 3.0/2.0, SL 25/TP 30, rischio **0,65%/evento** = 0,325%/gamba) |
| prova | `prove/POSTNEWS_ISM_00_conta.txt` (`@DAQUANDO` **omesso apposta**, 34 righe vive) |
| calendario | `mql5/Files/abtg_news_ism1500_2010_2023_UTC.csv` — **464 righe = 1 intestazione + 463 eventi**; di questi **431 `ISM1500OK`** (= 431 giornate, dal **2010.01.04** al **2023.12.20**) e 32 `ISM1500DST` **esclusi dal default** |
| simbolo | **EURUSD**, fisso (il gemello cross-simbolo su USDJPY, magic 774702, è un **altro** round) |
| modello / TF | **1 = 1 minuto OHLC (SCREENING)**, `@PERIODO` **M5** |
| celle | **2** (`InpMagic` 774701/774706, gemelle: DEVONO uscire identiche) |
| finestra | `-DaQuando` **MISURATO** (fase 8) col **pavimento 2010.01.01** → `-Fino` **2023.12.31**, split 40/60 come lo calcola il generico |
| rischio | **0,65%/evento** (0,325%/ordine su 50 pip), deposito 100.000 — **metà** della sedia NFP viva |

## 🧮 IL CONTO DEI 150 — fatto, non promesso

L'Emendamento A misura in **OPERAZIONI**, non in occasioni. Quello che si può
calcolare **prima** della corsa sono le **occasioni** (le giornate in cui l'EA
piazza i due pendenti). Numeri **contati sul file**, non stimati:

| | numero |
|---|---|
| giornate utili nel calendario (`ISM1500OK`) | **431**, dal 2010.01.04 al 2023.12.20 |
| arco coperto | **13,96 anni** → **30,9 giornate/anno** |
| *(per confronto: il dossier diceva **31,5**/anno — contava le **441** giornate PRIMA dell'igiene di `costruisci_news_blocchi_usa.py`)* | |
| anni di **IS** necessari a **150 occasioni** | **4,9** |
| → finestra **totale** necessaria (split 0,40) | **~12,1 anni** |
| finestra di default di questa riga (2010.01.01 → 2023.12.31) | **14,0 anni** → **IS 189 occasioni · OOS 242 occasioni** |

**Cosa vuol dire, onestamente:** questa famiglia arriva a **189 occasioni IS**
**solo perché si usa praticamente tutto il calendario disponibile**. Su qualunque
finestra più corta di ~12 anni l'IS scende sotto le 150 occasioni. E soprattutto:

> ⚠️ **189 occasioni NON sono 189 operazioni.** Ogni occasione piazza **due**
> pendenti e ne può scattare **0, 1 o 2**: `n(IS)` sta fra **0 e 378**. Se le
> gambe scattano in media almeno **0,79 volte per occasione**, `n(IS)` supera
> 150 e il **merito diventa misurabile** — *in un round successivo a tick reali*,
> **non qui**. Quel tasso **non lo sa nessuno prima della passata**: è
> esattamente ciò che questo Passo 0 va a misurare.

---

## 📌 IL PIN — **`c1782ffbba2d207480691c7c13b84e50cbbb52a8`**

Commit di `lavoro` (04/09/2026), **verificato file per file via `raw` prima di
consegnare questa pagina**: gli `sha256` in tabella (calcolati sul working tree
al momento della scrittura) sono stati riconfrontati con quelli scaricati da
`raw` a questo pin — tutti e otto identici, HTTP 200 su ognuno (passo 2 della
ricetta in fondo, già eseguito).

| file al pin | sha256 (working tree) | esito atteso |
|---|---|---|
| `backtest_pipeline/righe/RIGA_POSTNEWS_ISM.ps1` | `442896f6e4210dc8248c2b36e547f618a45a388c0716bcf67c28efc91c3a948d` | marcatore `MARCATORE_RIGA_POSTNEWS_ISM_v1` presente, **ASCII puro**, parse `pwsh` OK |
| `backtest_pipeline/prove/POSTNEWS_ISM_00_conta.txt` | `93fb35d3f5ba0d935edc8056b2bd9ac735031d5a1e9f8147196f5952f71fa9a2` | `@DAQUANDO`/`@FINOA` assenti, **34 righe vive** (2 direttive + 31 fissi + 1 asse) |
| `backtest_pipeline/walkforward_generico.ps1` | `5d98af3d80e34a4ceb6c85719e9c3513b673fed6be6c517563042f3434a8bc85` | **non si edita**: il driver lo scarica, lo pinna col replace di `$EABranch` **e gli alza `[Charts] MaxBars`**, poi rilegge **dal disco** lo stato finale di entrambi (2 occorrenze attese) |
| `mql5/Experts/ABTG_PostNews.mq5` | `b3e5468034563b02af8280dcb7b5ad59412b5fc9712d3b73914be9a3eaf28f61` | `#property version "1.10"`, 3 `AT_Caso(` + 2 `falliti++` (5 casi). **NON modificato da questo round** |
| `mql5/Include/ABTG_PausaGuardian.mqh` | `b7462cd5d2f8b903a927ee9f4bd9f729579e7eb0964b07579a522221077699d7` | **v1.51**, una sola `bool ABTG_GuardiaIngresso(` |
| `mql5/Presets/ABTG_PostNews_ISM1500_EURUSD.set` | `52a3651450da619727bc9360b45523b022f136798a4c88eb4754b7a17260ac3a` | **32 righe** (31 fissi + `InpMagic=774701`). **Frozen: NON toccato da questo round** |
| `mql5/Files/abtg_news_ism1500_2010_2023_UTC.csv` | `b517688f257a4de7a7dae560231f01d53c47d2d1b058b67982a508130917a23e` | **464 righe** (1 intestazione + 463 eventi), 431 `ISM1500OK` |
| `mql5/Scripts/ABTG_HistoryDownloader.mq5` | `9b51e51318c046140c420595fa9dcd773a73a9212e9f77880902e6462ec902db` | lo strumento della **misura storico** (fase 8): senza di lui non esiste `-DaQuando` |

Tutti e **otto** vanno scaricati **allo stesso pin**, mai dalla punta del branch.

---

## 1️⃣ GIRO DI CONTROLLO (scarica, gatta, COMPILA, **misura storico**, generico `-SoloControllo`)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='c1782ffbba2d207480691c7c13b84e50cbbb52a8'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_POSTNEWS_ISM.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_POSTNEWS_ISM.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_POSTNEWS_ISM_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -SoloControllo; $rc=$LASTEXITCODE;
    $d=$null; foreach($k in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $k -and (Test-Path $k)){ $d=$k } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'POSTNEWS_ISM_CONTROLLO_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP POSTNEWS_ISM_CONTROLLO_ DI ADESSO SUL DESKTOP: il controllo non e'' arrivato alla raccolta. Mandami quello che vedi qui sopra.' };
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip qui sotto.' -ForegroundColor Yellow };
    if($ko){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Mandami questo zip:' -ForegroundColor Red; Write-Host $z[0].FullName -ForegroundColor Yellow } else { Write-Host 'CONTROLLO OK (fa comunque fede il referto nello zip: compilazione OK, storico misurato, occasioni contate, celle 2): lancia il blocco 2.' -ForegroundColor Green } }
```

**ATTENZIONE:** questo blocco **APRE MT5 una volta** (fase 8, misura storico —
vedi tabella sopra): non è un errore, è dichiarato. Può durare **10-45 minuti**
da solo se lo storico M1 di EURUSD non è ancora sul disco del PC di backtest.
*(R102 dichiarava ~10 milioni di barre M1 EURUSD già scaricate su quel PC: se
sono ancora lì, la misura è veloce.)*

## 2️⃣ CORSA VERA (2 celle × 2 finestre, Modello 1 OHLC M1)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='c1782ffbba2d207480691c7c13b84e50cbbb52a8'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_POSTNEWS_ISM.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_POSTNEWS_ISM.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_POSTNEWS_ISM_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin; $rc=$LASTEXITCODE;
    $d=$null; foreach($k in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $k -and (Test-Path $k)){ $d=$k } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'POSTNEWS_ISM_CORSA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP POSTNEWS_ISM_CORSA_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if($ko){ Write-Host 'CORSA CON PROBLEMI: lo zip esiste lo stesso, mandalo -- il referto dice dove si e'' fermata.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('POI nel REFERTO_POSTNEWS_ISM1500_EURUSD.txt: riga modo: = CORSA, e riga data: = ORA DI AVVIO di questa corsa (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + '): il referto si timbra all''INIZIO e la corsa dura decine di minuti (quasi tutti nella misura storico).') -ForegroundColor Gray }
```

## 🩹 SE LA MISURA STORICO SI FERMA («MISURA STORICO NON RIUSCITA»)

Non è un guasto della riga: `ABTG_HistoryDownloader` non ha finito di scaricare
le barre M1 di EURUSD entro il tetto (45 minuti × 2 tentativi). Il download
**resta sul disco** (`bases\` non si svuota mai): **rilancia lo stesso blocco**,
quasi certamente più veloce. Se serve più tempo a tentativo:

```powershell
& $p -Pin $pin -TimeoutStoricoMin 90
```

Le altre due manopole dichiarate (si usano **solo** se serve, e la scelta va
scritta nel round):

```powershell
& $p -Pin $pin -PavimentoDaQuando 2010.01.01   # il pavimento (default: questo)
& $p -Pin $pin -Fino 2023.12.31                # la fine finestra (default: questa)
```

## 📦 COSA TORNA

Zip sul Desktop **`POSTNEWS_ISM_CORSA_...zip`** (o `POSTNEWS_ISM_CONTROLLO_...zip`
per il giro a vuoto) con: `REFERTO_POSTNEWS_ISM1500_EURUSD.txt` +
`COMPILAZIONE.log` (UTF-16, il log vero di MetaEditor) +
`COMPILAZIONE_leggibile.txt` + il prova + il preset +
`ABTG_StoricoScaricato_M1_EURUSD.csv` (il referto GREZZO della misura storico) +
i **CSV OPTFRAME** `ABTG_PostNews_EURUSD_IS_ohlc_ISM00.csv` e `_OOS_` (**2 righe
l'uno** = magic 774701/774706, 9 colonne) + gli **`.ini VERI`** della corsa
(`gen_*.ini`, con `Model=1`) + i **log del tester cresciuti** durante il giro
(dove vive il canarino NEWS).

⚠️ **Suffisso `_ohlc` nei nomi CSV**: è la marca del generico per i modelli
non-tick — qui il modello è **1** (screening), quindi il suffisso è **atteso**.

## 🔎 COME SI LEGGE — nell'ordine

🕐 **PRIMA DI TUTTO** apri il referto e controlla:
- **`data:`** = **l'ora in cui hai lanciato il blocco** (si timbra all'**AVVIO**).
- **`modo:`** = **CORSA** (CONTROLLO = giro a vuoto, non è il risultato).
- **`compilazione:`** — tre stati: `OK (… KB …), errori 0` → avanti; `FALLITA (…)`
  → **è il risultato del passo**; `FALLITA -- METAEDITOR MUTO` → non è un
  verdetto sul codice, si rifà.
- **identità**: `versione letta dal #property: 1.10`, `autotest … 3 AT_Caso() +
  2 controlli = 5 casi totali`, `OnTester: presente`, `hedge-safe: 0 chiamate`,
  `include censiti: 2 (Trade/Trade.mqh, ABTG_PausaGuardian.mqh)`.
- **`coerenza prova <-> preset .set:`** = `VALIDO: 31 fissi identici uno a uno,
  InpMagic preset (774701) = lead dell'asse prova`. Altro → preset e prova non
  sono più lo stesso contratto: ci si ferma **prima** dei numeri.
- **`calendario:`** = `464 righe (1 intestazione + 463 eventi) … 431 righe = 431
  GIORNATE distinte, dal 2010.01.04 al 2023.12.20` + le due righe di foto
  (`Common\Files` e `MQL5\Files`, prima/dopo): entrambe con **la stessa
  dimensione** del file al pin.

🧱 **POI LE DUE RIGHE CHE QUESTA RIGA HA IN PIÙ RISPETTO ALLE ALTRE:**
- **`--- MISURA STORICO M1 EURUSD ---`** → `MISURATA al tentativo N/2: verdetto
  '...', PrimaDataServer <data>`.
- **`-DaQuando: MISURATO <x> | USATO <y>`** e **`pavimento:`** → se dice
  `APPLICATO`, la data del broker era **prima** del 2010 e ha vinto il pavimento
  (finisce anche nei RILIEVI). Se dice `NON applicato`, ha vinto la misura e il
  comportamento è identico alla riga NFP. **Vanno letti tutti e due i numeri.**
- **`--- CONTA-OCCASIONI ---`** → `IS ... = N occasioni | OOS ... = M occasioni`.
  Atteso col pavimento e `-Fino` di default: **IS 189 · OOS 242**. Se leggi
  numeri molto diversi, la finestra non è quella che credevi.

🐤 **POI IL CANARINO NEWS (letto dai LOG, non dal CSV):**
- riga `[PostNews][NEWS] letto da ... | righe 463 | UTILI per questo preset 431 |
  dal 2010.01.04 al 2023.12.20` ricopiata in chiaro. `N=0` → **PROBLEMA**
  (*"calendario cieco, la passata NON CONTA"*). **`N ≠ 431` → PROBLEMA** anche
  quello: il filtro non seleziona quello che crediamo.
- riga `[PostNews][AUTOTEST] ---- fine: N casi falliti ----` per ogni pass:
  **atteso 0** su ognuna.

📊 **POI IL CONTO ECONOMICO** (per finestra, magic 774701 e 774706 affiancati):
`n` con l'etichetta Emendamento A (`PASSA` ≥150 / `MERITO SOSPESO` 30-149 /
`NON MISURABILE` <30), `Profit`, `Payoff`, `PF`, `RF`, `Sharpe`, `Equity DD%`.
**Gemelli**: `IDENTICI al centesimo` (atteso) — se dice `ROTTI`, il banco è
sporco e il round è fermo.

🛑 **E COSA NON SI PUÒ DIRE con questi dati (ricopiato nel referto):**
1. *"ha edge"/"non ha edge"* — banco OHLC, e il merito si giudica a tick reali;
2. *"regge nel tempo"* — nessuna prova di regime qui (Emendamento C fuori scopo);
3. *"il DD sarà quello"* — Modello 1 = OHLC (SupRev DOW H4: 2,77 → 0,79);
4. promuovere qualunque cella da qui;
5. *"SL/TP sono tarati"* — offset 3.0/2.0 e SL 25/TP 30 sono **copiati dalla
   sedia NFP su USDJPY** e **mai rimisurati su EURUSD**: il preset lo dichiara in
   testa, e 25 pip su USDJPY non sono 25 pip su EURUSD;
6. *"lo spread è quello vero"* — a Modello 1 non lo è. Lo spread reale BCM su
   EURUSD (mediana 0,100-0,200 pip in Londra, R115) è la **ragione** per cui il
   candidato nasce qui, non una misura di questa corsa;
7. niente sull'**ablazione news+10 contro news+15**: il prova ha **un solo asse**
   e l'ora d'azione è **fissa a 15:15**. È il round successivo (si cambia
   `InpActionMin=10` e **nient'altro**).

## 🚦 LE USCITE, UNA PER UNA (**c'è lo zip? sì o no**)

| Cosa succede | Zip sul Desktop | Cosa mandare |
|---|---|---|
| **MT5 o MetaEditor aperto** (si ferma **prima** di scaricare) | ❌ **NO** | il messaggio rosso; chiudili e rilancia |
| **`SCRIPT VECCHIO`** o `irm` fallito (404 su un pin appena creato: cache raw ~5 min) | ❌ **NO** | il messaggio; aspetta 5 minuti e rilancia **la stessa riga** |
| **Guardie del driver**: `-Pin` mancante/corto, `-Fino`/`-PavimentoDaQuando` malformati, MT5 riaperto | ✅ **SÌ** (`!!! FERMATO:` nel referto) | lo zip |
| **Scarico al pin fallito** (404 su uno degli otto file) | ✅ **SÌ** | lo zip; se è la cache raw, rilancia dopo 5 min |
| **Gate sul sorgente / sul prova / di coerenza col preset** | ✅ **SÌ** | lo zip: il motivo è in `!!! FERMATO:` — non si aggiusta a mano, si torna in chat |
| **Calendario** (righe ≠ 464, intestazione diversa, **utili ≠ 431**, **giornate ≠ 431**, date diverse, installazione fallita) | ✅ **SÌ** | lo zip |
| **Terminale non unico** (`NON SO QUALE TERMINALE USARE`) | ✅ **SÌ** | rilancia con `& $p -Pin $pin -Terminale '<cartella dell'installazione>'` |
| **Compilazione FALLITA** (o MUTA) | ✅ **SÌ** | lo zip: **è il risultato del passo** (include già rimesso a posto) |
| **Misura storico NON riuscita** (2 tentativi) | ✅ **SÌ** | lo zip: rilancia (vedi §🩹), eventualmente con `-TimeoutStoricoMin` più alto |
| **Finestra vuota** (`-DaQuando usato` non prima di `-Fino`) | ✅ **SÌ** | lo zip: **è il risultato del passo**, non un guasto |
| **Corsa con PROBLEMI** (CSV stantio/mancante, righe ≠ 2, gemelli divergenti, autotest ≠ 0, **canarino N=0 o N≠431 / `CALENDARIO CIECO` / `CANARINO ROSSO` / canarino assente a corsa finita**, **occasioni IS = 0**, `no memory`) | ✅ **SÌ** (esito `COMPLETATO CON PROBLEMI`, exit 1) | lo zip: il referto dice quale sanità è caduta |
| **Corsa OK** | ✅ **SÌ** | lo zip |

## 🔴 AVVISI ATTESI (nessuno è un guasto)

1. **Giallo** *"Questo EA usa PERIOD_CURRENT..."* — non si applica: l'EA lavora a
   M5 fisso via `iHigh/iLow(_Symbol, PERIOD_M5, ...)`.
2. **MT5 si apre due volte**: una per la misura storico (fase 8), una per il
   tester (fase 10, dentro `walkforward_generico.ps1`). Non interromperlo.
3. Ogni 15s durante la misura storico: `... CSV N byte, storico bases N MB` —
   **non interrompere**, è il battito del download.
4. Suffisso `_ohlc` nei CSV — **atteso**, Modello 1 non è tick reali.
5. `Model letto: ... Model=1` — è quello vero.
6. `include ... installato AL PIN` e poi `ripristino del terminale: ...` —
   classe 116 al lavoro.
7. `CODICE DI USCITA NON LETTO` a fine blocco — non è un fallimento: fa fede il
   referto.
8. `driver generico ... con MaxBars alzato -- stato finale riletto dal disco` —
   il tetto «Max barre nel grafico» non deve poter troncare **in silenzio** una
   finestra di 14 anni (checklist 36). [INFERITO che il tester onori la riga:
   non è misurato da nessuna corsa di casa.]
9. `PAVIMENTO APPLICATO: -DaQuando misurato <data molto vecchia> -> usato
   2010.01.01` nei RILIEVI — **non è un errore**, è la protezione che ha fatto il
   suo lavoro (vedi R102). E `il broker NON ha M1 fino a 2010.01.01: il muro vero
   e' <data>` è il caso opposto, anch'esso dichiarato.

## 🔁 RICETTA DEL PIN (prima pinnatura) — si prova su una COPIA prima di scriverla

```bash
F=backtest_pipeline/righe/RIGA_POSTNEWS_ISM_DA_MANDARE.md
SHA=$(git rev-parse HEAD)          # il commit che CONTIENE driver + prova + preset + calendario + EA + include + generico + history downloader
TOK='@@PIN'"@@"                    # composto: la ricetta non contiene la stringa che cerca
sed -i "s|\$pin='$TOK'|\$pin='$SHA'|g; s|\*\*\`$TOK\`\*\*|\*\*\`$SHA\`\*\*|" "$F"
grep -c "\$pin='$SHA'" "$F"        # DEVE dare 2 (blocchi 1-2)
grep -c "\$pin='$TOK'" "$F"        # DEVE dare 0
CART='segnap'"osto"'\|non e'"'"' ancora lanciabile'\|la riga non par'"te"   # composto
grep -ci "$CART" "$F"              # DEVE dare 0 dopo aver RISCRITTO il cartello
grep -o "$TOK" "$F" | wc -l        # DEVE dare 0: nessun segnaposto sopravvissuto
```

**Poi (passo 2, quello che questa pagina non poteva fare):** riscaricare gli
**otto** file da `raw` al pin e confrontare il `sha256` con la colonna in
tabella. Se uno solo non torna, **la pagina non è pinnata**: si rifà.

**Il cartello** in cima ("QUESTA PAGINA NON È ANCORA LANCIABILE…") va
**RISCRITTO**, non solo lasciato: una frase che sopravvive alla pinnatura
direbbe il falso a chi legge dopo (classe 101).
