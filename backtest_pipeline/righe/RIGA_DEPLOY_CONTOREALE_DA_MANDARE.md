# 🔴 LE DUE SEDIE VERE SUL CONTO REALE — **le due righe da mandare** (controllo · corsa)

**Che cos'è:** l'installazione di **`ABTG_DAX_Apertura_EU`** (magic **770101**,
`D30EUR`) e **`ABTG_ORB_Ottimizzato` v1.04** (magic **770611**, `U30USD`) sul
terminale del **conto REALE**, a rischio di casa **0,65%/trade**, con i **due
preset già pronti** copiati dentro la cartella `Presets` del terminale — così si
caricano con un click invece che a mano.

> # 🛑 QUESTA VOLTA È DIVERSO, E VA DETTO PRIMA DI TUTTO
> Ieri sera abbiamo messo sul reale **`ABTG_SlippageLogger`**: un artefatto di
> **SOLA LETTURA**, in cui le funzioni per mandare un ordine **non esistevano
> proprio nel sorgente** — la riga ne censiva 48 e pretendeva zero.
>
> **Qui no.** Questi due EA **aprono, modificano e chiudono posizioni con soldi
> veri.** Il perimetro non è più *«l'artefatto non può fare danno per
> costruzione»*: è **«l'artefatto PUÒ fare danno, e allora si controlla tutto
> quello che si può controllare PRIMA»**. È la prima volta in tutto il progetto
> che succede.
>
> 💶 **I numeri dei soldi, per averli in testa:** conto **7.500 €**, rischio
> **0,65%** → **~48,75 € a trade**. Due sedie con una posizione ciascuna →
> **~97,50 €**, cioè **~1,30%** di rischio aperto.

---

## 0. 🚫 LE CINQUE COSE CHE QUESTA RIGA **NON FA** (e non può fare)

| | |
|---|---|
| **NON ATTACCA MAI NESSUN EA A NESSUN GRAFICO** | **il gesto di trascinare l'EA sul grafico e caricare il preset è MANUALE, DI CLAUDIO**, con la legge dello screenshot. Nel driver **non esiste nessun percorso di scrittura** verso `Profiles\Charts` o `config\`, ed è **misurato**: quelle cartelle sono fotografate prima e dopo e devono uscire `INVARIATI` |
| **NON TOCCA MAI L'AUTOTRADING** | non c'è nessun modo di accenderlo da lì, e non ci si prova. **Finché l'AutoTrading è spento, nessuno dei due EA può mandare un ordine**, anche se fosse già sul grafico |
| **NON TOCCA `ABTG_SlippageLogger`** | sullo **stesso** conto reale il logger sta già misurando. Questa riga non lo reinstalla, non lo ricompila, non lo cancella e **non tocca il suo registro**. I suoi due file sono fotografati prima e dopo e devono uscire **INVARIATI**. ⚠️ Il suo **registro** in `MQL5\Files` invece **può crescere durante il giro** (scrive ogni 10 s a MT5 aperto): quello è dichiarato **ATTESO**, non un problema — pretendere che un file vivo non cambi sarebbe un controllo finto |
| **NON SI INSTALLA SUI DEMO** | **50503392 (piccolo) e 50504263 (100k) sono VIETATI PER SEMPRE**, senza nessuna manopola di sblocco. E il motivo qui è più grosso che per il logger: **su quei due conti queste due sedie GIÀ girano**, quindi installarcele vorrebbe dire **due sedie doppie sullo stesso magic** |
| **NON LASCIA MEZZO DEPLOY** | **tutto o niente**: se una sola delle due compilazioni non va, **tutti e sette i file tornano com'erano** dal backup |

---

## 1. 🔑 IL NUMERO DEL CONTO REALE, E LE QUATTRO SERRATURE

Il numero va scritto nelle righe qui sotto al posto di `SCRIVI_QUI_IL_NUMERO`
(lo stesso che hai usato ieri per il logger). Le righe **si rifiutano di
partire** se lo lasci lì com'è.

> ## 🛡️ LA GUARDIA È **LA STESSA DEL LOGGER, RIGA PER RIGA**
> E questo non è un modo di dire, è **contato**: il blocco che sceglie la
> cartella dati è **118 righe**, e fra il driver del logger e questo ci sono
> **9 righe di differenza — tutte messaggi, più due righe di referto in
> più**. **Zero differenze di logica.** Quel blocco è stato provato ieri sera
> su quattro finti terminali, e **è stato riprovato oggi**, su questo driver,
> in **10 casi eseguiti** (elenco al §4).
>
> 1. **`-LoginAtteso` è obbligatorio.** Senza, la riga non parte.
> 2. **`50503392` e `50504263` sono VIETATI PER SEMPRE**, e **non c'è nessuna
>    manopola che li sblocchi**.
> 3. **Una cartella che ha visto uno di quei due conti nei log è SCARTATA** —
>    anche se ci fosse dentro *pure* il conto atteso. Anzi: **soprattutto
>    allora**.
> 4. **Il login atteso DEVE comparire nei log** della cartella scelta
>    (finestra di **180 giorni**).
>
> 🧷 **E c'è una CONFERMA INCROCIATA in più, che il logger non aveva:** nella
> cartella scelta **deve già esserci `ABTG_SlippageLogger`**, quello installato
> ieri. Il referto lo dice a chiare lettere. Se non c'è, **non è un blocco** (il
> logger potrebbe stare altrove) ma è un **rilievo forte**: vuol dire che una
> delle due installazioni sta andando su un terminale diverso, e va capito
> **prima** della CORSA.

---

## 2. 📌 IL PIN — **`ddbb7e6d48d6ee99f4e892fd4b700d3cd4719b23`** ✅ **INSERITO E VERIFICATO**

Commit di `lavoro`. **Verificato file per file prima di scrivere questa pagina**,
non dichiarato: presente in `git ls-tree`, **HTTP 200** via `raw`, e **sha256 del
contenuto al pin identico al file nel repo**.

| file al pin | esito |
|---|---|
| `backtest_pipeline/righe/RIGA_DEPLOY_CONTOREALE.ps1` | 200, identico (`292bc7f2…`, **80.656 byte**), marcatore `MARCATORE_RIGA_DEPLOY_CONTOREALE_v1` presente **nel file scaricato**, **ASCII puro** (0 byte > 126), `Parser::ParseFile` **0 errori** |
| `mql5/Experts/ABTG_DAX_Apertura_EU.mq5` | 200, identico (`105f0f81…`, **118.483 byte**), `#property version "1.01"`, `ABTG_DEF_MAGIC 770101`, `ABTG_DEF_RISK 1.0` |
| `mql5/Experts/ABTG_ORB_Ottimizzato.mq5` | 200, identico (`c14d85dd…`, **74.103 byte**) — **lo stesso sha256 e gli stessi byte del deploy della v1.04 sul piccolo del 03/09**, `#property version "1.04"`, autotest **10 blocchi / 33 casi**, `PositionSelect(_Symbol)` fuori dai commenti: **0** |
| `mql5/Include/ABTG_PausaGuardian.mqh` | 200, identico (`b7462cd5…`, **112.481 byte**, **v1.51** — la stessa del deploy sul piccolo) |
| `mql5/Presets/conto_reale/ABTG_DAX_Apertura_EU_770101_REALE.set` | 200, identico (`cc3f8433…`, **3.437 byte**), **82 chiavi = 82 input dell'EA** |
| `mql5/Presets/conto_reale/ABTG_ORB_Ottimizzato_770611_REALE.set` | 200, identico (`dd76e50e…`, **2.649 byte**), **54 chiavi = 54 input dell'EA** |

Il pin è scritto **quattro volte** in questa pagina (qui, nei **due** blocchi e
in fondo) ed è sempre **la stessa identica stringa da 40 hex**.

---

## 3. 🔧 **COSA HO TROVATO NEI DUE PRESET, E COSA HO CAMBIATO** (leggilo, è la parte che conta)

I due `.set` erano già pronti dal commit `582df0a`. **Aprendoli e contandoli** —
non guardandoli — sono venuti fuori **due difetti veri**, tutti e due dello
stesso tipo: **roba che MT5 salta in silenzio, e in silenzio non la vedi.**

**① 21 righe di intestazione che NON sono commenti.** Le righe tipo
`=== Rischio e gestione ====` sembrano titoli, ma **il commento in un `.set` di
MT5 comincia con `;`** (tutti gli altri 60 preset di casa fanno così). Una
riga così MT5 **la salta senza dire niente** — e una di loro era pure **troncata
a metà** (`... solo con vol=`), cioè tagliata proprio su un `=`. **Corrette in
commenti `;`**: **zero parametri cambiati**, il file adesso è leggibile senza
ambiguità.

**② SEI input non erano nel preset.** `InpAllowReverse` e `InpUsaGuardian` sul
DAX; `InpSLBufferPts`, `InpSlippagePts`, `InpAutoTest` e `InpUsaGuardian`
sull'ORB. Un input che il preset **non nomina** prende il **default compilato**,
**in silenzio** — ed è *esattamente* la trappola del **2%** chiusa il **02/09**
(`report/VERBALE_CHIUSURA_770101_2026-09-02.md`). **Aggiunti**, con un valore
che è **IDENTICO al default compilato**, verificato uno per uno: quindi il
**comportamento non cambia di una virgola**, cambia che adesso il file **li
dichiara** invece di lasciarli al caso.

> ✅ **Risultato:** i due preset hanno **copertura TOTALE** — 82 chiavi su 82
> input (DAX) e 54 su 54 (ORB). **Nessun parametro del motore è stato toccato**:
> `InpRiskPercent = 0.65` resta l'unica differenza dalla cella viva sul piccolo,
> come volevi tu.

> ⚠️ **QUELLO CHE NON POSSO VERIFICARE IO, E CHE DEVI GUARDARE TU.** Che il
> *resto* della cella sia identico a quella che gira **davvero** sul conto
> piccolo, **il repo non me lo può dire** (i parametri delle sedie vive vivono
> **sul grafico**, non in un file). Il verbale C2 del 02/09 conferma cinque voci
> del DAX (RETEST, range 35, buffer 500, rischio 1,0, magic 770101) e il preset
> le rispetta tutte. **Le altre le confronti tu**, con F7 sul grafico vivo del
> piccolo contro la finestra che ti si apre sul reale.

---

## ▶️ BLOCCO 1 — **CONTROLLO** (giro a vuoto: non scrive niente nel terminale)

Si lancia **prima**, anche di giorno, con MT5 aperto. Torna l'elenco delle
cartelle guardate, la cartella scelta col suo **criterio**, i gate sui sorgenti,
**i due preset aperti e contati** e le foto.

**🔴 Sostituisci `SCRIVI_QUI_IL_NUMERO` col numero del conto reale.**

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $conto='SCRIVI_QUI_IL_NUMERO';
    if($conto -notmatch '^\d{5,12}$'){ throw 'DEVI SCRIVERE IL NUMERO DEL CONTO REALE al posto di SCRIVI_QUI_IL_NUMERO. Non ho toccato niente.' };
    if($conto -eq '50503392' -or $conto -eq '50504263'){ throw 'QUELLO E'' UN CONTO DEMO: li'' queste due sedie GIA'' girano. Serve il numero del conto REALE.' };
    $pin='ddbb7e6d48d6ee99f4e892fd4b700d3cd4719b23'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_DEPLOY_CONTOREALE.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_DEPLOY_CONTOREALE.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_DEPLOY_CONTOREALE_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -LoginAtteso $conto -Modo CONTROLLO; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $c -and (Test-Path -LiteralPath $c)){ $d=$c } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'DEPLOY_CONTOREALE_CONTROLLO_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($z.Count -eq 0){ throw 'NESSUNO ZIP DEPLOY_CONTOREALE_CONTROLLO_ DI ADESSO SUL DESKTOP: la riga non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra: va bene uguale.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'GIRO CON PROBLEMI: lo zip ESISTE lo stesso, mandalo -- la riga ESITO DEL GIRO dice dove si e'' fermato.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('NEL REFERTO la riga data: e'' l''ORA DI AVVIO di questo giro (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + ').') -ForegroundColor Gray }
```

---

## ▶️ BLOCCO 2 — **CORSA** (installa e compila nel SOLO terminale del reale)

**Solo dopo un CONTROLLO pulito** — `ESITO DEL GIRO: COMPLETATO`, `PROBLEMI: 0`,
la riga `guardia sul conto` che dice **TROVATO**, e la riga
`conferma incrociata logger` che dice **SI** — e con **MetaEditor CHIUSO**.
**MT5 resta aperto**: il logger continua a misurare.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process metaeditor64 -EA SilentlyContinue){ throw 'METAEDITOR APERTO: chiudilo (MT5 puo'' restare aperto) e rilancia. Non ho scaricato e non ho toccato niente.' };
    $conto='SCRIVI_QUI_IL_NUMERO';
    if($conto -notmatch '^\d{5,12}$'){ throw 'DEVI SCRIVERE IL NUMERO DEL CONTO REALE al posto di SCRIVI_QUI_IL_NUMERO. Non ho toccato niente.' };
    if($conto -eq '50503392' -or $conto -eq '50504263'){ throw 'QUELLO E'' UN CONTO DEMO: serve il numero del conto REALE.' };
    $pin='ddbb7e6d48d6ee99f4e892fd4b700d3cd4719b23'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_DEPLOY_CONTOREALE.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_DEPLOY_CONTOREALE.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_DEPLOY_CONTOREALE_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -LoginAtteso $conto -Modo CORSA; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $c -and (Test-Path -LiteralPath $c)){ $d=$c } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'DEPLOY_CONTOREALE_CORSA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($z.Count -eq 0){ throw 'NESSUNO ZIP DEPLOY_CONTOREALE_CORSA_ DI ADESSO SUL DESKTOP: la riga non e'' arrivata alla raccolta. NON attaccare niente: mandami quello che vedi qui sopra, va bene uguale.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'GIRO CON PROBLEMI: lo zip ESISTE lo stesso, mandalo. NON ATTACCARE NESSUN EA prima di aver letto la riga INSTALLAZIONE del referto.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'RICORDA: nessun EA e'' stato attaccato a nessun grafico. Quello lo fai TU, a mano, con gli screenshot.' -ForegroundColor Yellow;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('NEL REFERTO la riga data: e'' l''ORA DI AVVIO di questo giro (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + ').') -ForegroundColor Gray }
```

> 📄 **I due referti hanno nomi DIVERSI, apposta**:
> `REFERTO_DEPLOY_CONTOREALE_CONTROLLO.txt` e
> `REFERTO_DEPLOY_CONTOREALE_CORSA.txt`. Si somigliano riga per riga: con lo
> stesso nome, scompattando i due zip nella stessa cartella, uno cancellerebbe
> l'altro in silenzio (checklist classe 132).

### 🧾 COSA SCRIVE LA CORSA, E DOVE — **sette file, nient'altro**
```
<dati>\MQL5\Experts\ABTG_DAX_Apertura_EU.mq5        (v1.01)
<dati>\MQL5\Experts\ABTG_DAX_Apertura_EU.ex5        (compilato sul posto)
<dati>\MQL5\Experts\ABTG_ORB_Ottimizzato.mq5        (v1.04)
<dati>\MQL5\Experts\ABTG_ORB_Ottimizzato.ex5        (compilato sul posto)
<dati>\MQL5\Include\ABTG_PausaGuardian.mqh          (v1.51, include condiviso)
<dati>\MQL5\Presets\ABTG_DAX_Apertura_EU_770101_REALE.set
<dati>\MQL5\Presets\ABTG_ORB_Ottimizzato_770611_REALE.set
```
**Backup di tutti e sette** in `Desktop\backup_contoreale_<data>\<ora>\` **prima**
di scrivere, **sentinella** per il giro interrotto a mano, **ripristino TOTALE**
su qualunque fallimento. **I due `.set` entrano SOLO IN FONDO**, e solo se
**tutte e due** le compilazioni sono andate: un preset da caricare senza l'EA
compilato è un invito a sbagliare.

---

# 🖱️ **I PASSI MANUALI — LI FA CLAUDIO, NON LA RIGA**

> # 🛑🛑 **LA RIGA NON HA ATTACCATO NIENTE E NON HA ACCESO NIENTE.**
> # **NESSUN EA È SU NESSUN GRAFICO. L'AUTOTRADING È COME L'HAI LASCIATO.**
> # **FINCHÉ NON FAI TU I PASSI QUI SOTTO, NESSUNO DI QUESTI DUE EA PUÒ MANDARE UN ORDINE.**

### PASSO 1 — far comparire i due EA
**Navigatore → Expert Advisors → tasto destro → Aggiorna.** Devono comparire
**`ABTG_DAX_Apertura_EU`** e **`ABTG_ORB_Ottimizzato`**. Se non ci sono, la CORSA
non è andata su **questo** terminale: rileggi `cartella dati scelta` nel referto
e **fermati**.

### PASSO 2 — il DAX, su un grafico **NUOVO** `D30EUR` **M5**
> 🛑 **GRAFICO NUOVO, MAI UNO CHE HA GIÀ UN EA.** Un grafico MT5 tiene **UN SOLO
> Expert Advisor**: trascinare un EA dove c'è **il logger dello slippage** **lo
> sostituirebbe**, e il logger sparirebbe dal campo senza che nessuno lo dica.
> **`File > Nuovo grafico`**.

1. `File > Nuovo grafico` → **`D30EUR`** → timeframe **M5**.
   ⚠️ **M5 non è un dettaglio estetico**: è il timeframe della sedia viva
   (verbale C1 del 02/09: `D30EUR,M5`) e l'EA crea l'handle ATR di gestione su
   **`PERIOD_CURRENT`**, cioè sul timeframe del grafico.
2. Trascina **`ABTG_DAX_Apertura_EU`** sul grafico.
3. Scheda **«Dati in Ingresso» → `Carica...`** → scegli
   **`ABTG_DAX_Apertura_EU_770101_REALE.set`** (te lo apre già nella cartella
   giusta: la riga ce l'ha messo apposta).
4. 📸 **PRIMA DI PREMERE OK, GUARDA A SCHERMO E FAI LO SCREENSHOT:**
   - **`InpMagic` = 770101**
   - **`InpRiskPercent` = 0.65**  ← **se leggi 1.0 o 2.0, NON premere OK**
   - `InpAllowLong = true`, `InpAllowShort = false` (long-only)
   - `InpSessionHour = 8` (**ora SERVER**: DAX apre 09:00 IT = 08:00 server)
5. OK.

### PASSO 3 — l'ORB, su un secondo grafico **NUOVO** `U30USD` **M5**
1. `File > Nuovo grafico` → **`U30USD`** → **M5**.
   *(Per l'ORB il timeframe del grafico pesa meno — l'EA legge `InpExecTF=5` per
   gli indicatori e `PERIOD_M1` per il range — ma **si mette lo stesso della
   sedia viva sul piccolo**: se lì è diverso, dimmelo prima di procedere.)*
2. Trascina **`ABTG_ORB_Ottimizzato`**.
3. **«Dati in Ingresso» → `Carica...`** → **`ABTG_ORB_Ottimizzato_770611_REALE.set`**.
4. 📸 **PRIMA DI OK, screenshot:**
   - **`InpMagic` = 770611**
   - **`InpRiskPercent` = 0.65**
   - `InpRangeStartHour = 14` (**ora SERVER**: Dow apre 15:30 IT = 14:30 server)
   - `InpAutoTest = true` ← **non spegnerlo**: è la riga che in Esperti prova che
     gira la **v1.04** e non la v1.02
5. OK.

### PASSO 4 — **AutoTrading acceso, e la faccina che sorride**
1. Bottone **AutoTrading** in alto: **acceso** (verde).
2. **In alto a destra di OGNI DUE grafici la faccina deve SORRIDERE** 🙂.
   Faccina **triste** = quell'EA **non** è abilitato a operare: il grafico non
   partirà, e il fatto che l'AutoTrading generale sia acceso **non basta**.
3. 📸 **Screenshot dei due grafici con la faccina.**

### PASSO 5 — **il saldo e il rischio, guardati con gli occhi**
- Scheda **Trade**: **saldo ~7.500 €**.
- **0,65% di 7.500 € = ~48,75 € di rischio per trade.**
- **Due sedie insieme = ~97,50 €, cioè ~1,30%.**
- 📸 Screenshot della scheda Trade col saldo.
> 🧮 Se il saldo che vedi **non** è ~7.500 €, i conti di sopra cambiano in
> proporzione: **dimmelo prima di lasciarle girare.**

### PASSO 6 — **la scheda ESPERTI** (⚠️ **non** «Giornale»: i `Print` degli EA stanno in **Esperti**)
Devono comparire, per ciascuna sedia:

**DAX**
```
[DAX Apertura EU] avviato su D30EUR. Apertura server 08:00, range 35 min, flat 17:30.
[DAX Apertura EU] RICORDA: gli orari sono quelli del SERVER del broker ...
[DAX Apertura EU] CONFIG IN USO -> motore=ABTG_RETEST | ... | rischio=0.65% | ...
```
👉 **`rischio=0.65%` in quella riga è LA prova che il preset è entrato davvero.**
Se dice `1.00%`, il `Carica...` non è stato applicato: **stacca l'EA** e rifai il
PASSO 2.

**ORB**
```
ORB INIT: handle EMA veloce OK = ... Trailing EMA=ON, uscita su chiusura oltre EMA=OFF
ORB AUTOTEST: 10 blocchi su 10 passati, 33 casi dichiarati, 0 falliti. ...
[ORB_OTT] avviato su U30USD. Range server 14:30-14:45, ingresso 10.0 x K(1.0000), fine 21:00.
```
👉 **La riga `ORB AUTOTEST` è LA prova che gira la v1.04**: la v1.02 **non la
stampa affatto**. ⚠️ L'`OnInit` **non stampa il numero di versione**: cercare
`v1.04` nel Giornale **non trova niente**, e non è un guasto (classe 82).
🛑 Se `falliti` è **diverso da 0**: **stacca l'EA** e manda lo screenshot.

📸 **Screenshot della scheda Esperti** con tutte queste righe.

> ⏰ **Le ore dei log MT5 sono in ORA LOCALE del VPS (= ora italiana); il grafico
> è in ora SERVER (un'ora indietro).** Non si confrontano. Regola fissa del
> `CLAUDE.md`.

---

## 🔎 COME SI LEGGE IL REFERTO — le righe, in quest'ordine

1. **`ESITO DEL GIRO`** + **`data:`** (= l'ora in cui hai **lanciato**) + **`modo:`**.
2. **`guardia sul conto`** — deve dire **`TROVATO`** e **`conti vietati visti
   qui: NESSUNO`**.
3. **`cartella dati scelta`** + **`criterio di scelta`**. Un
   `SCELTA ATTESTATA A MANO, NON MISURATA` **non è un verde**: vuol dire che ci
   siamo fidati della tua firma.
4. **`conferma incrociata logger`** — deve dire **`SI`**.
5. **`GATE SUPERATI`** — versioni (1.01 / 1.04), i **default COMPILATI del
   rischio** (devono dire **1.00% / 1.00%**, cioè la trappola del 2% è chiusa
   anche nel sorgente), autotest ORB **10/33** e `PositionSelect(_Symbol): 0`,
   gli include.
6. **`I DUE PRESET, APERTI E CONTATI`** — 🔥 **la riga che vale di più**: per
   ciascuno, **quante chiavi = quanti input** (copertura **TOTALE**),
   **`InpMagic`**, **`InpRiskPercent=0.65`**, i lati, `InpMaxSpread`,
   `InpUsaGuardian`.
7. **`compilazione ...`** per **ciascuna** delle due, con la sua
   **`riga Result del log`**: si pretende **`0 errors, 0 warnings`**.
8. **`INSTALLAZIONE`** — `AVVENUTA: 7 file su 7` / `TENTATA E RIPRISTINATA` /
   `NON AVVENUTA`, e **`ripristino`** dice cosa è stato rimesso e da dove.
9. **`IL LOGGER DELLO SLIPPAGE (che NON si tocca)`** — deve dire
   **`INVARIATO su N foto di file REALMENTE PRESENTI`**. Subito dopo, il suo
   **registro**: se è **cresciuto**, è **normale e giusto**.
10. **`GRAFICI E CONFIGURAZIONE`** — deve dire **`INVARIATI`**: 👉 **è la prova
    che nessun EA è stato attaccato a nessun grafico da questa riga.**
11. **`CARTELLA Presets`** — deve dire **«cambiati SOLO i due `.set` nostri; gli
    altri N file già presenti sono INVARIATI uno per uno»**. Se compare
    `AGGIUNTO`/`CAMBIATO`/`SPARITO` di un altro file, è un **PROBLEMA**.
12. Le **sette righe `REALE ...`** con `prima [...] dopo [...]`: in una CORSA
    riuscita dicono **`CAMBIATO`** (o `ASSENTE → presente`); in CONTROLLO o dopo
    un ripristino, `INVARIATO` / `ASSENTE prima e dopo`.
13. **`PROBLEMI:`** e **`RILIEVI:`**, poi l'elenco delle cartelle guardate.

---

## 🚦 LE USCITE, UNA PER UNA (**c'è lo zip? sì o no**)

| Cosa succede | Zip sul Desktop | Il terminale del reale | Cosa mandare |
|---|---|---|---|
| **`SCRIVI_QUI_IL_NUMERO` lasciato lì** | ❌ NO | **intatto** | il messaggio rosso; metti il numero e rilancia |
| **Numero di un conto DEMO** | ❌ NO | **intatto** | il messaggio rosso — e **non si forza** |
| **MetaEditor aperto**, blocco CORSA (si ferma **prima** di scaricare) | ❌ NO | **intatto** | il messaggio rosso; chiudi MetaEditor e rilancia |
| **`SCRIPT VECCHIO`** o download fallito | ❌ NO | **intatto** | il messaggio (404 su un pin appena creato: aspetta 5 minuti e **rilancia la stessa riga**) |
| **Gate sui sorgenti** (versione ≠ 1.01/1.04, magic compilato, **rischio compilato sopra 1,0**, autotest ORB, `PositionSelect(_Symbol)`, include) | ✅ SÌ | **intatto** | lo zip: `ESITO DEL GIRO: FERMATO ...` col motivo |
| **Gate sui PRESET** (byte non-ASCII, riga malformata, chiave doppia, chiave estranea, copertura non totale, magic sbagliato, **rischio ≠ 0,65 o sopra il tetto**) | ✅ SÌ | **intatto** | lo zip — **non si forza**: un preset che non torna non entra |
| **Cartella col login non trovata / ambigua** | ✅ SÌ | **intatto** | lo zip + `CANDIDATE.txt` (vedi il riquadro giallo) |
| **Cartella che ha visto un conto demo** | ✅ SÌ | **intatto** | lo zip — **non c'è manopola** |
| **CONTROLLO pulito** | ✅ SÌ | **intatto** | lo zip → si passa alla CORSA |
| **CORSA, una compilazione fallita / muta** | ✅ SÌ (+ backup) | **RIPRISTINATO, tutti e sette** | lo zip, **prima di riprovare**. **Non attaccare niente** |
| **CORSA, eccezione dopo la scrittura** | ✅ SÌ (+ backup) | **RIPRISTINATO** (`ripristino: ... dopo un'eccezione`) | lo zip |
| **CORSA con WARNING di compilazione** | ✅ SÌ | **i file ci sono**, ma è un **PROBLEMA** | lo zip **coi due log**, e **NON attaccare niente** finché non l'ho letto |
| **CORSA OK** | ✅ SÌ (+ backup) | 7 file su 7, grafici e config `INVARIATI`, logger `INVARIATO` | lo zip → **i PASSI MANUALI** |
| **Sentinella di un giro interrotto, in CONTROLLO** | ✅ SÌ | **intatto** | lo zip: `PROBLEMI: 1` che dice di rilanciare in CORSA (che rimette a posto da sola) |

## 🟡 SE LA RIGA SI FERMA SU «NON HO TROVATO NESSUNA CARTELLA COL LOGIN…»
Non è un guasto: è la regola di casa (**classe 115** — l'ambiente non si indovina
dal nome, si decide con un fatto). Nel referto e in `CANDIDATE.txt` c'è
**l'elenco di tutto quello che ha guardato**, coi login visti in ognuna e il
perché di ogni scarto. Tre casi:
- **sessione sbagliata** → sul VPS i terminali girano sotto **Administrator**:
  cambia sessione e rilancia **lo stesso blocco**;
- **la riconosci nell'elenco ma il login non compare** → aprila in MT5, **guarda
  con gli occhi il numero di conto**, e rilancia aggiungendo al driver:
  `-CartellaDati "<percorso incollato>" -ConfermoConto <lo stesso numero>`. Il
  numero va scritto **due volte**: è una **firma**, e il referto la registra come
  **`SCELTA ATTESTATA A MANO, NON MISURATA`**;
- **la cartella ha visto un conto demo** → **non si sblocca**, e non c'è manopola.

## 🔴 AVVISI ATTESI (nessuno è un guasto)
1. Rilievo **`MT5 APERTO`** — è **atteso e voluto**: il logger continua.
2. **`codice di uscita di metaeditor64: 1`** con `.ex5` fresco e `Result: 0 errors`
   → comportamento **misurato** su questo VPS (**classe 108**).
3. Rilievo **`ABTG_DAX_Apertura_EU.mq5 ha 69 byte non-ASCII`** (e 10 sull'ORB):
   sono lettere accentate nei **commenti** dei sorgenti, non bloccano la
   compilazione. Dichiarato.
4. Il **registro del logger cresciuto** fra la foto prima e quella dopo: **giusto
   così**.
5. La cartella **`backup_contoreale_...`** resta sul Desktop: si cancella a mano,
   **dopo** che i passi manuali sono chiusi.

---

## ⚠️ **QUELLO CHE QUESTO DEPLOY NON PROTEGGE** — da sapere prima di accendere

- 🚨 **SUL CONTO REALE NON C'È IL GUARDIAN.** `InpUsaGuardian=true` c'è nei due
  preset, ma la guardia è **fail-open dichiarata**: *«canale inesistente →
  passa»* (misurato leggendo `ABTG_PausaGuardian.mqh`). Tradotto: sul reale
  **NON valgono** il **cap del rischio aperto C1 (3,25%)**, la **pausa
  giornaliera B1** e il pacchetto **Guardian** firmati il 18/08. Sul reale i due
  EA lavorano **senza rete**. **Non è una svista mia: è una decisione che devi
  prendere tu**, e se vuoi il Guardian anche lì è una riga a parte.
- **`InpMaxSpread = 0`** in tutti e due i preset = **nessun tetto sullo spread**.
  Sul demo non si vedeva; su un conto vero lo spread è quello che è — ed è
  esattamente il motivo per cui il logger sta lì a misurare.
- **I DD promessi sono a rischio 1%, e SENZA slippage.** `CONTRATTI_SEDIE.md`:
  DAX **10,60%** (R83), ORB **9,92%** (R15, «doppio asterisco», cella di
  confine). A 0,65% **scalano in proporzione** a **~6,9%** e **~6,4%** — ma
  questa è un'**INFERENZA**, non una misura, e quei backtest **non modellano
  nessuno slippage**. Il numero vero lo darà la **raccolta del logger**.
- **Il criterio di uscita delle sedie (18/08) vale anche qui:** se il **DD
  forward supera quello promesso**, revisione **IMMEDIATA**.
- **Backtest profittevole ≠ profitto live.** Queste due sedie sono le più
  frequenti della flotta ed è per questo che sono state scelte (riempiono in
  fretta la tabella dello slippage), **non** perché siano le migliori.

---

## 🧪 COSA È STATO PROVATO **ESEGUENDO**, NON LEGGENDO — **48 casi, 0 rossi**

Qui sotto c'è capitale vero, quindi il conto lo do per esteso:

- **31 casi** sul banco a terra, sulle **funzioni VERE estratte dal driver con
  l'AST** (non su una copia: è il testo del file al pin che gira). Fra questi
  **8 sabotaggi**, e ognuno è stato **beccato**: intestazione `=== ... ====`
  senza `;`, **chiave doppia con `InpRiskPercent=2.0`**, chiave storpiata
  (`InpRiskPercnt`), input tolto dal preset, forma `valore||start||step||stop`
  dell'ottimizzatore, un `.set` **estraneo** toccato in `Presets`, un file
  **sparito**, e due assenze che **non fanno** un `INVARIATO` (classe 117).
- **10 casi** sulla guardia del conto, su **quattro finti terminali**: conto
  vietato come `-LoginAtteso` (tutti e due), `-LoginAtteso` mancante,
  `-ConfermoConto` diverso, pin non a 40 hex, cartella del piccolo, cartella
  **mista**, cartella muta **con** e **senza** attestazione, cartella giusta.
- **1 giro CONTROLLO completo** con **lo script scaricato dal pin**, fino alle
  foto: preset letti e contati (82/82 e 54/54), conferma incrociata del logger,
  inventario di `Presets`, zip e referto prodotti.
- **1 CORSA** con eccezione in compilazione: **tutti e sette i file ripristinati**
  — il `.mq5` e il `.set` **preesistenti rimessi con sha256 identico**, i nuovi
  tolti, il `.set` **estraneo** e i file del **logger** intatti, sentinella pulita.
- **2 casi** sulla sentinella: in **CONTROLLO** alza il `PROBLEMA` **senza
  toccare niente**; in **CORSA** rimette a posto **all'avvio**.
- **3 casi** sulla **riga che incolli tu**, presa **verbatim da questa pagina**:
  col `SCRIVI_QUI_IL_NUMERO` lasciato lì si ferma **prima di scaricare**; col
  conto demo `50503392` si ferma col messaggio giusto; col numero buono arriva in
  fondo, trova lo zip fresco sul Desktop e stampa **`MANDA IN CHAT QUESTO FILE`**.

> ⚠️ **QUELLO CHE NON È PROVATO, E VA DETTO: LA COMPILAZIONE.** Qui non c'è
> MetaEditor. I sorgenti passano tutti i gate statici e l'ORB è **byte per byte
> lo stesso file** che il 03/09 ha compilato **0 errors, 0 warnings** sul
> piccolo, ma il primo `Result:` **di questo terminale** lo vedremo **nel referto
> della CORSA**.

---

_Artefatti al pin `ddbb7e6d48d6ee99f4e892fd4b700d3cd4719b23`:
`backtest_pipeline/righe/RIGA_DEPLOY_CONTOREALE.ps1`,
`mql5/Experts/ABTG_DAX_Apertura_EU.mq5`, `mql5/Experts/ABTG_ORB_Ottimizzato.mq5`,
`mql5/Include/ABTG_PausaGuardian.mqh`,
`mql5/Presets/conto_reale/ABTG_DAX_Apertura_EU_770101_REALE.set`,
`mql5/Presets/conto_reale/ABTG_ORB_Ottimizzato_770611_REALE.set`.
Pagina gemella (già eseguita): `RIGA_SLIPPAGELOGGER_DA_MANDARE.md`. Modello del
deploy con backup/ripristino: `RIGA_DEPLOY_ORB104_PICCOLO_DA_MANDARE.md`.
Contratti e DD promessi: `report/CONTRATTI_SEDIE.md`. La trappola del 2%:
`report/VERBALE_CHIUSURA_770101_2026-09-02.md`._
