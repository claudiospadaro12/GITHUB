# 🎯 POSTNEWS USD1330/USDJPY — PASSO 0 (conta-occasioni): **LA RIGA DA MANDARE**

> ⛔ **QUESTA PAGINA NON È ANCORA LANCIABILE.** Il pin è ancora il segnaposto
> `@@PIN@@`: i file citati qui sotto **non sono ancora su GitHub a un commit
> congelato**. Va prima fatto il commit, poi applicata la **RICETTA DEL PIN** in
> fondo (che sostituisce il segnaposto e **riscrive questo cartello**). Se stai
> leggendo questo riquadro, **non incollare niente in PowerShell**.

**Che cos'è:** il **PASSO 0** del preset USD1330/USDJPY di `ABTG_PostNews.mq5`
v1.10 — il **candidato B** della caccia del 04/09/2026
(`backtest_pipeline/caccia_strategie/CACCIA_POSTNEWS_ALTRE_FAMIGLIE_2026-09-04.md`).
La domanda è **una sola**: *"il motore range-M5 + due pendenti funziona sugli
ALTRI dati delle 8:30 New York come funziona sull'NFP?"* — CPI m/m, Retail Sales,
Core Retail Sales, PPI m/m, alle **13:30 server**, su **USD/JPY**, con ora
d'azione, offset, SL/TP e simbolo **identici alla sedia NFP viva**: cambia **una
cosa sola, l'EVENTO** (e la scadenza, 14:45 invece di 16:59). **Modello 1 (1
minuto OHLC = SCREENING, mai un verdetto)**, `@PERIODO M5`, **UNA finestra
IS/OOS**, **UN solo asse**: `InpMagic` 774801/774806 — **due celle gemelle che
DEVONO uscire identiche** (controllo di coerenza del banco, non una griglia).

> 🛡️ **LA SEDIA NFP CHE GIRA IN FORWARD NON VIENE TOCCATA.** Il dossier
> proponeva di allargarle il filtro del titolo (magic 771203): **non si fa**, è
> la regola di casa. Istanza nuova, magic nuovo, calendario nuovo. E la
> convivenza è sicura per un fatto **contato, non supposto**: il calendario di
> questo preset **non contiene l'NFP** e le sue giornate **non toccano mai**
> quelle dell'NFP (**0 giornate in comune su 14 anni**, caso 7 dell'autotest di
> `costruisci_news_blocchi_usa.py`). Le due istanze non possono aprire lo stesso
> giorno: nessun raddoppio di rischio, cap C1 non sfiorato.

> 🔮 **DA QUESTA CELLA NON PUÒ USCIRE NESSUNA PROMOZIONE — dichiarato PRIMA dei
> numeri, e qui per DUE motivi sommati:** (a) il banco è **Modello 1 = OHLC =
> screening** (in questa casa l'illusione OHLC ha già revocato una promozione:
> SupRev DOW H4, PF **2,77** OHLC contro **0,79** a tick reali); (b) **il
> campione IS è sotto il pavimento** — 119 occasioni, vedi *Il conto dei 150*.
> Il giudizio di **RISCHIO** (Emendamento B) vale a qualunque `n`, ma su questo
> OPTFRAME si legge **solo su Equity DD %**.

## 🧭 PERCHÉ QUESTA RIGA È DIVERSA (leggilo prima di lanciare)

| | |
|---|---|
| **`@DAQUANDO` omesso apposta** | Modello 1 lavora su barre **M1 VERE**: la data giusta è quella in cui BCM possiede *davvero* le barre M1 di USDJPY, non `2010.01.01` a occhio. **La riga la MISURA da sola** (fase 8) con `ABTG_HistoryDownloader.mq5`, **eseguito dentro questo driver**, sullo **stesso terminale/cartella dati** già risolti alla fase 5. |
| 🧱 **PAVIMENTO `2010.01.01` — differenza di logica rispetto alla riga NFP** | **Fatto MISURATO su un ALTRO simbolo, e lo diciamo:** in **R102** (24/08) lo scarico M1 di **EURUSD** da BCM ha dichiarato **10.014.728 barre "dal 1971.01.03"**, mentre la prima operazione vera era del **1999.01.18**. Su USDJPY **non l'abbiamo misurato**: il rischio è **[INFERITO per analogia]**, e proprio per questo la riga non lo assume — lo **tappa** e lo **dichiara**. `-DaQuando` usato = **il più tardi** fra la data **misurata** e `-PavimentoDaQuando`. **Nel referto ci sono TUTTI E DUE i numeri**. |
| 📅 **`-Fino 2023.12.31` (non `2026.06.30`)** | Il calendario di questo blocco **copre 2010-2023 e basta**. Con `-Fino 2026.06.30` gli ultimi 2,5 anni varrebbero **zero occasioni** e sposterebbero il confine IS/OOS sulla base di **tempo morto**. ⚠️ Questa scelta **RIDUCE** il campione IS (**119** occasioni invece di 145): **allontana** dalla soglia invece di avvicinarcisi. Non è scelta per far passare un gate. |
| 🔢 **CONTA-OCCASIONI a macchina, PRIMA del tester (fase 8-bis)** | Dal calendario **scaricato al pin** la riga estrae le **giornate distinte** che passano i filtri del preset e le divide fra IS e OOS **con lo stesso split del generico**. ⚠️ **Qui righe e giornate NON coincidono**: **541 righe** ma **347 giornate**, perché Retail Sales m/m e Core Retail Sales m/m escono **nello stesso minuto** (due righe, un solo prezzo) e `gPlacedDay` concede **un solo piazzamento al giorno**. **Un'occasione non è un'operazione**: ogni giornata piazza **due** pendenti e ne scattano 0, 1 o 2. Occasioni IS = 0 → **PROBLEMA**. |
| **Eccezione dichiarata: `-SoloControllo` qui APRE MT5 una volta** | Solo per lo script di misura storico (fase 8), **mai** per il tester. |
| 🐤 **Il canarino è una riga di LOG, e qui ha un valore ATTESO** | `[PostNews][NEWS] letto da ... \| righe 644 \| UTILI per questo preset 541 \| dal 2010.01.14 al 2023.12.14`. **`N` conta le RIGHE, non le giornate**: 541 è giusto, 347 sarebbe sbagliato. `N=0` → **PROBLEMA**; **`N ≠ 541` → PROBLEMA** (il numero è stato **contato a macchina sul calendario al pin** in fase 4). |
| **Il GDP non c'è, ed è una scelta FTMO** | [VERIFICATO da Claudio il 04/09/2026, tabella letterale da ftmo.com]: per USD la lista *Restricted event* contiene **GDP q/q** e **CPI y/y**. *Advance GDP q/q* è quindi trattato come restricted (lettura conservativa) e isolato in `USD1330OKR` (51 righe): col default **non si trada**. Per includerlo — solo in Challenge — si cambia **una stringa**: `InpNewsTitleMatch=USD1330OK`. **Non in questo round.** |
| **Nessun `#define` per l'autotest** | Il conteggio si **ricalcola dal sorgente al pin** (`falliti+=AT_Caso(` + `if(!X) falliti++;`): oggi (v1.10) fa **3+2=5**. |
| **Il preset `.set` non viene caricato dal tester** | È il **contratto** da cui il prova è stato derivato a mano: la riga verifica che i **31 valori fissi combacino uno a uno** e che `InpMagic` del preset (**774801**) sia il **lead** dell'asse. |
| **Nessun per-trade CSV** | `OnTesterDeinit()` scrive solo l'OPTFRAME (9 colonne). Dichiarato, non un buco del driver. |
| **Blocco magic 774801/774806 vergine** | Verificato **ORA, dall'assistente, sul repo** (04/09/2026): `774801` compare solo nel preset e nel prova nuovi, `774806` **non compariva da nessuna parte**. ⚠️ **`774802` NON si usa qui**: è **riservato** al gemello **cross-simbolo** (blocco 13:30 su EURUSD), che è un altro round. |

| voce | valore |
|---|---|
| EA / versione | `ABTG_PostNews.mq5` **v1.10** |
| preset | `mql5/Presets/ABTG_PostNews_USD1330_USDJPY.set` (magic 774801, azione **13:45** server, scadenza **14:45** con `InpCloseAtExpiry=true`, offset 3.0/2.0, SL 25/TP 30, rischio **0,65%/evento** = 0,325%/gamba) |
| prova | `prove/POSTNEWS_1330_00_conta.txt` (`@DAQUANDO` **omesso apposta**, 34 righe vive) |
| calendario | `mql5/Files/abtg_news_usd1330_2010_2023_UTC.csv` — **645 righe = 1 intestazione + 644 eventi**; di questi **541 `USD1330OKF`** = **347 giornate**, dal **2010.01.14** al **2023.12.14**. Esclusi dal default: 51 `USD1330OKR` (GDP), 47 `USD1330DSTF`, 5 `USD1330DSTR` |
| simbolo | **USDJPY**, fisso (**lo stesso** della sedia NFP: è l'unico modo di confrontare "NFP" e "resto del blocco 13:30" a simbolo costante) |
| modello / TF | **1 = 1 minuto OHLC (SCREENING)**, `@PERIODO` **M5** |
| celle | **2** (`InpMagic` 774801/774806, gemelle: DEVONO uscire identiche) |
| finestra | `-DaQuando` **MISURATO** (fase 8) col **pavimento 2010.01.01** → `-Fino` **2023.12.31**, split 40/60 come lo calcola il generico |
| rischio | **0,65%/evento** (0,325%/ordine su 50 pip), deposito 100.000 — **metà** della sedia NFP viva |

## 🧮 IL CONTO DEI 150 — fatto, e **non torna**: va detto prima

L'Emendamento A misura in **OPERAZIONI**, non in occasioni. Le **occasioni** si
possono contare **prima** della corsa. Numeri **contati sul file**, non stimati:

| | numero |
|---|---|
| righe utili nel calendario (`USD1330OKF`) | **541** |
| **giornate** utili (= occasioni: `gPlacedDay` dà 1 piazzamento/giorno) | **347**, dal 2010.01.14 al 2023.12.14 |
| arco coperto | **13,91 anni** → **24,9 giornate/anno** |
| *(per confronto: il dossier diceva **43,5**/anno — contava 609 giornate del blocco **intero**, GDP e giornate DST comprese, che il default qui **esclude**)* | |
| anni di **IS** necessari a **150 occasioni** | **6,0** |
| → finestra **totale** necessaria (split 0,40) | **~15,1 anni** |
| finestra **massima disponibile** (il calendario finisce nel 2023) | **14,0 anni** |
| finestra di default di questa riga (2010.01.01 → 2023.12.31) | **IS 119 occasioni · OOS 228 occasioni** |

> ⚠️ **Detto onestamente: con questo calendario e lo split 0,40 di casa, le
> OCCASIONI IS non possono arrivare a 150.** Servirebbero ~15,1 anni di dati e ne
> esistono 14,0. **Non si aggira spostando lo split**: la soglia si dichiara
> prima e si legge dopo — muovere il confine IS/OOS *per far passare un gate* è
> pescare, ed è il difetto che questa casa ha già pagato.
>
> **L'unica strada legittima per superare 150 sono le OPERAZIONI**, che possono
> essere **più** delle occasioni: ogni occasione piazza **due** pendenti e ne
> scattano 0, 1 o 2, quindi `n(IS)` sta fra **0 e 238**. Servirebbe una media di
> **almeno 1,26 gambe scattate per occasione**. Se `n(IS)` resta sotto 150, il
> **merito di questa famiglia resta SOSPESO** anche in un round successivo a tick
> reali (valvola R59: *il campione sottile sospende il giudizio sul MERITO, mai
> sul RISCHIO*), e la strada sarà **allargare il blocco** (GDP, DST) o la
> finestra — **non** spremere parametri.

---

## 📌 IL PIN — **`@@PIN@@`**

Commit di `lavoro` (04/09/2026). ⚠️ **Il pin qui sopra è un segnaposto**: va
sostituito col commit vero e **poi** riverificato file per file via `raw`
(HTTP 200 + `sha256` identico al repo al pin).

Gli `sha256` in tabella sono calcolati **sul working tree del repo** al momento
in cui questa pagina è stata scritta: dopo la pinnatura vanno **riconfrontati**
con quelli scaricati da `raw` al pin (passo 2 della ricetta in fondo).

| file al pin | sha256 (working tree) | esito atteso |
|---|---|---|
| `backtest_pipeline/righe/RIGA_POSTNEWS_1330.ps1` | `bc8fb93323e2e418423db1cb356d3a3d2f847a57dbbbdd90cdb1e7cc1156e219` | marcatore `MARCATORE_RIGA_POSTNEWS_1330_v1` presente, **ASCII puro**, parse `pwsh` OK |
| `backtest_pipeline/prove/POSTNEWS_1330_00_conta.txt` | `cd3bde46537ac6561d688fd5da70cf0c89285e76f3df76828d7b3c463f9a6d06` | `@DAQUANDO`/`@FINOA` assenti, **34 righe vive** (2 direttive + 31 fissi + 1 asse) |
| `backtest_pipeline/walkforward_generico.ps1` | `5d98af3d80e34a4ceb6c85719e9c3513b673fed6be6c517563042f3434a8bc85` | **non si edita**: il driver lo scarica, lo pinna col replace di `$EABranch` **e gli alza `[Charts] MaxBars`**, poi rilegge **dal disco** lo stato finale (2 occorrenze attese) |
| `mql5/Experts/ABTG_PostNews.mq5` | `b3e5468034563b02af8280dcb7b5ad59412b5fc9712d3b73914be9a3eaf28f61` | `#property version "1.10"`, 3 `AT_Caso(` + 2 `falliti++` (5 casi). **NON modificato da questo round** |
| `mql5/Include/ABTG_PausaGuardian.mqh` | `b7462cd5d2f8b903a927ee9f4bd9f729579e7eb0964b07579a522221077699d7` | **v1.51**, una sola `bool ABTG_GuardiaIngresso(` |
| `mql5/Presets/ABTG_PostNews_USD1330_USDJPY.set` | `ef232dff5ffa1ffac62e8d4208bd00529e668e543e877fd4cbe3431229ffa673` | **32 righe** (31 fissi + `InpMagic=774801`). **Frozen: NON toccato da questo round** |
| `mql5/Files/abtg_news_usd1330_2010_2023_UTC.csv` | `d04d71173990ea1f9332825e98a2546b4d46bc5e01347372060fa3270ecded6b` | **645 righe** (1 intestazione + 644 eventi), 541 `USD1330OKF` = 347 giornate |
| `mql5/Scripts/ABTG_HistoryDownloader.mq5` | `9b51e51318c046140c420595fa9dcd773a73a9212e9f77880902e6462ec902db` | lo strumento della **misura storico** (fase 8): senza di lui non esiste `-DaQuando` |

Tutti e **otto** vanno scaricati **allo stesso pin**, mai dalla punta del branch.

---

## 1️⃣ GIRO DI CONTROLLO (scarica, gatta, COMPILA, **misura storico**, generico `-SoloControllo`)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_POSTNEWS_1330.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_POSTNEWS_1330.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_POSTNEWS_1330_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -SoloControllo; $rc=$LASTEXITCODE;
    $d=$null; foreach($k in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $k -and (Test-Path $k)){ $d=$k } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'POSTNEWS_1330_CONTROLLO_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP POSTNEWS_1330_CONTROLLO_ DI ADESSO SUL DESKTOP: il controllo non e'' arrivato alla raccolta. Mandami quello che vedi qui sopra.' };
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip qui sotto.' -ForegroundColor Yellow };
    if($ko){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Mandami questo zip:' -ForegroundColor Red; Write-Host $z[0].FullName -ForegroundColor Yellow } else { Write-Host 'CONTROLLO OK (fa comunque fede il referto nello zip: compilazione OK, storico misurato, occasioni contate, celle 2): lancia il blocco 2.' -ForegroundColor Green } }
```

**ATTENZIONE:** questo blocco **APRE MT5 una volta** (fase 8, misura storico —
vedi tabella sopra): non è un errore, è dichiarato. Può durare **10-45 minuti**
da solo se lo storico M1 di USDJPY non è ancora sul disco del PC di backtest.

## 2️⃣ CORSA VERA (2 celle × 2 finestre, Modello 1 OHLC M1)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_POSTNEWS_1330.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_POSTNEWS_1330.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_POSTNEWS_1330_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin; $rc=$LASTEXITCODE;
    $d=$null; foreach($k in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $k -and (Test-Path $k)){ $d=$k } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'POSTNEWS_1330_CORSA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP POSTNEWS_1330_CORSA_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if($ko){ Write-Host 'CORSA CON PROBLEMI: lo zip esiste lo stesso, mandalo -- il referto dice dove si e'' fermata.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('POI nel REFERTO_POSTNEWS_USD1330_USDJPY.txt: riga modo: = CORSA, e riga data: = ORA DI AVVIO di questa corsa (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + '): il referto si timbra all''INIZIO e la corsa dura decine di minuti (quasi tutti nella misura storico).') -ForegroundColor Gray }
```

## 🩹 SE LA MISURA STORICO SI FERMA («MISURA STORICO NON RIUSCITA»)

Non è un guasto della riga: `ABTG_HistoryDownloader` non ha finito di scaricare
le barre M1 di USDJPY entro il tetto (45 minuti × 2 tentativi). Il download
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

Zip sul Desktop **`POSTNEWS_1330_CORSA_...zip`** (o
`POSTNEWS_1330_CONTROLLO_...zip` per il giro a vuoto) con:
`REFERTO_POSTNEWS_USD1330_USDJPY.txt` + `COMPILAZIONE.log` (UTF-16, il log vero
di MetaEditor) + `COMPILAZIONE_leggibile.txt` + il prova + il preset +
`ABTG_StoricoScaricato_M1_USDJPY.csv` (il referto GREZZO della misura storico) +
i **CSV OPTFRAME** `ABTG_PostNews_USDJPY_IS_ohlc_1330OK00.csv` e `_OOS_` (**2
righe l'uno** = magic 774801/774806, 9 colonne) + gli **`.ini VERI`** della corsa
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
  InpMagic preset (774801) = lead dell'asse prova`. Altro → preset e prova non
  sono più lo stesso contratto: ci si ferma **prima** dei numeri.
- **`calendario:`** = `645 righe (1 intestazione + 644 eventi) … 541 righe = 347
  GIORNATE distinte, dal 2010.01.14 al 2023.12.14` + le due righe di foto
  (`Common\Files` e `MQL5\Files`, prima/dopo): entrambe con **la stessa
  dimensione** del file al pin.

🧱 **POI LE DUE RIGHE CHE QUESTA RIGA HA IN PIÙ RISPETTO ALLE ALTRE:**
- **`--- MISURA STORICO M1 USDJPY ---`** → `MISURATA al tentativo N/2: verdetto
  '...', PrimaDataServer <data>`.
- **`-DaQuando: MISURATO <x> | USATO <y>`** e **`pavimento:`** → se dice
  `APPLICATO`, la data del broker era **prima** del 2010 e ha vinto il pavimento
  (finisce anche nei RILIEVI). Se dice `NON applicato`, ha vinto la misura.
  **Vanno letti tutti e due i numeri.**
- **`--- CONTA-OCCASIONI ---`** → `IS ... = N occasioni | OOS ... = M occasioni`.
  Atteso col pavimento e `-Fino` di default: **IS 119 · OOS 228**.

🐤 **POI IL CANARINO NEWS (letto dai LOG, non dal CSV):**
- riga `[PostNews][NEWS] letto da ... | righe 644 | UTILI per questo preset 541 |
  dal 2010.01.14 al 2023.12.14` ricopiata in chiaro. `N=0` → **PROBLEMA**;
  **`N ≠ 541` → PROBLEMA**. ⚠️ **541 sono RIGHE, non giornate**: le giornate sono
  347 e non compaiono nel log dell'EA — le conta il driver.
- riga `[PostNews][AUTOTEST] ---- fine: N casi falliti ----` per ogni pass:
  **atteso 0** su ognuna.

📊 **POI IL CONTO ECONOMICO** (per finestra, magic 774801 e 774806 affiancati):
`n` con l'etichetta Emendamento A (`PASSA` ≥150 / `MERITO SOSPESO` 30-149 /
`NON MISURABILE` <30), `Profit`, `Payoff`, `PF`, `RF`, `Sharpe`, `Equity DD%`.
**Gemelli**: `IDENTICI al centesimo` (atteso) — se dice `ROTTI`, il banco è
sporco e il round è fermo.
⚠️ **Attesa dichiarata prima**: `MERITO SOSPESO` sull'IS è lo scenario più
probabile (119 occasioni → 150 operazioni solo con ≥1,26 gambe per occasione).
**Non è una delusione: è il numero che serviva sapere.**

🛑 **E COSA NON SI PUÒ DIRE con questi dati (ricopiato nel referto):**
1. *"ha edge"/"non ha edge"* — banco OHLC, e il merito si giudica a tick reali;
2. *"regge nel tempo"* — nessuna prova di regime qui (Emendamento C fuori scopo);
3. *"il DD sarà quello"* — Modello 1 = OHLC (SupRev DOW H4: 2,77 → 0,79);
4. promuovere qualunque cella da qui;
5. **niente sul CONFRONTO con la sedia NFP**: qui offset, SL/TP, ora d'azione e
   **simbolo** sono identici a quella viva, ma **quella non ha ancora un
   backtest suo con questi criteri**. Due numeri si confrontano quando sono
   stati fatti sullo stesso banco: finché il Passo 0 dell'NFP non è girato, il
   paragone **non esiste**;
6. *"lo spread è quello vero"* — a Modello 1 non lo è, **e su USDJPY non abbiamo
   nemmeno lo spread reale BCM archiviato** come su EURUSD (R115): un motivo in
   più per cui il merito si giudica solo a tick reali;
7. niente sulla **composizione** del blocco: il calendario **non è costante nel
   tempo** (CPI m/m ha un **buco 2010-2013**, PPI m/m un **buco 2019-2021**). Il
   2010-2013 è fatto quasi solo di Retail Sales e PPI. **IS e OOS confrontano
   anche MISCELE DIVERSE**, non solo periodi diversi.

## 🚦 LE USCITE, UNA PER UNA (**c'è lo zip? sì o no**)

| Cosa succede | Zip sul Desktop | Cosa mandare |
|---|---|---|
| **MT5 o MetaEditor aperto** (si ferma **prima** di scaricare) | ❌ **NO** | il messaggio rosso; chiudili e rilancia |
| **`SCRIPT VECCHIO`** o `irm` fallito (404 su un pin appena creato: cache raw ~5 min) | ❌ **NO** | il messaggio; aspetta 5 minuti e rilancia **la stessa riga** |
| **Guardie del driver**: `-Pin` mancante/corto, `-Fino`/`-PavimentoDaQuando` malformati, MT5 riaperto | ✅ **SÌ** (`!!! FERMATO:` nel referto) | lo zip |
| **Scarico al pin fallito** (404 su uno degli otto file) | ✅ **SÌ** | lo zip; se è la cache raw, rilancia dopo 5 min |
| **Gate sul sorgente / sul prova / di coerenza col preset** | ✅ **SÌ** | lo zip: il motivo è in `!!! FERMATO:` — non si aggiusta a mano, si torna in chat |
| **Calendario** (righe ≠ 645, intestazione diversa, **utili ≠ 541**, **giornate ≠ 347**, date diverse, installazione fallita) | ✅ **SÌ** | lo zip |
| **Terminale non unico** (`NON SO QUALE TERMINALE USARE`) | ✅ **SÌ** | rilancia con `& $p -Pin $pin -Terminale '<cartella dell'installazione>'` |
| **Compilazione FALLITA** (o MUTA) | ✅ **SÌ** | lo zip: **è il risultato del passo** (include già rimesso a posto) |
| **Misura storico NON riuscita** (2 tentativi) | ✅ **SÌ** | lo zip: rilancia (vedi §🩹), eventualmente con `-TimeoutStoricoMin` più alto |
| **Finestra vuota** (`-DaQuando usato` non prima di `-Fino`) | ✅ **SÌ** | lo zip: **è il risultato del passo**, non un guasto |
| **Corsa con PROBLEMI** (CSV stantio/mancante, righe ≠ 2, gemelli divergenti, autotest ≠ 0, **canarino N=0 o N≠541 / `CALENDARIO CIECO` / `CANARINO ROSSO` / canarino assente a corsa finita**, **occasioni IS = 0**, `no memory`) | ✅ **SÌ** (esito `COMPLETATO CON PROBLEMI`, exit 1) | lo zip: il referto dice quale sanità è caduta |
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
   finestra di 14 anni (checklist 36). [INFERITO che il tester onori la riga.]
9. `PAVIMENTO APPLICATO: ... -> usato 2010.01.01` nei RILIEVI — **non è un
   errore**, è la protezione che ha fatto il suo lavoro. E `il broker NON ha M1
   fino a 2010.01.01: il muro vero e' <data>` è il caso opposto, anch'esso
   dichiarato (e su USDJPY è **più probabile** di quello di EURUSD).
10. `MERITO SOSPESO` sull'IS — **atteso, dichiarato prima** (vedi *Il conto dei
    150*): non è un guasto della corsa.

## 🔁 RICETTA DEL PIN (prima pinnatura) — si prova su una COPIA prima di scriverla

```bash
F=backtest_pipeline/righe/RIGA_POSTNEWS_1330_DA_MANDARE.md
SHA=$(git rev-parse HEAD)          # il commit che CONTIENE driver + prova + preset + calendario + EA + include + generico + history downloader
TOK='@@PIN'"@@"                    # composto: la ricetta non contiene la stringa che cerca
sed -i "s|\$pin='$TOK'|\$pin='$SHA'|g; s|\*\*\`$TOK\`\*\*|\*\*\`$SHA\`\*\*|" "$F"
grep -c "\$pin='$SHA'" "$F"        # DEVE dare 2 (blocchi 1-2)
grep -c "\$pin='$TOK'" "$F"        # DEVE dare 0
CART='segnap'"osto"'\|non e'"'"' ancora lanciabile'\|la riga non par'"te"   # composto
grep -ci "$CART" "$F"              # DEVE dare 0 dopo aver RISCRITTO il cartello
```

**Poi (passo 2, quello che questa pagina non poteva fare):** riscaricare gli
**otto** file da `raw` al pin e confrontare il `sha256` con la colonna in
tabella. Se uno solo non torna, **la pagina non è pinnata**: si rifà.

**Il cartello** in cima ("QUESTA PAGINA NON È ANCORA LANCIABILE…") va
**RISCRITTO**, non solo lasciato: una frase che sopravvive alla pinnatura
direbbe il falso a chi legge dopo (classe 101).
