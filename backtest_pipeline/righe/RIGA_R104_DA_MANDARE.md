# 📬 R104 — **LA RIGA DA MANDARE** (misura MFE, MaxMinNotte DAX Short)

**Round**: R104 — **QUANTO SPESSO IL PROFITTO FLOTTANTE VIENE RESTITUITO PRIMA
DI 1R**, sulla sedia viva `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` (D30EUR M15).
**Criteri**: `backtest_pipeline/risultati_archivio/R104_CRITERI_MFE_MAXMIN_DAX.md`
**Driver**: `backtest_pipeline/righe/RIGA_R104_MFE_MAXMIN_DAX.ps1`
(marcatore `MARCATORE_RIGA_R104_v1`)
**File prova**: `backtest_pipeline/prove/R104_MaxMinDAX_MFE.txt`
**Motore di misura**: `mql5/Experts/ABTG_MaxMinNotte_DAX_Short_Ottimizzato_MFE.mq5`

---

## ❓ LA DOMANDA — è di Claudio, ed è del 24/08

> Davanti al trade **#3221475** (D30EUR short, **+200 € flottanti visti**, chiuso
> a **+15,10 €** perché il prezzo è tornato indietro **prima** di toccare il 1°
> obiettivo a 1R): _"Sì, misuriamo quanto succede."_

**Su quante operazioni succede? E quanto, in media, viene restituito?**

---

## ✅ IL CANCELLO DELLA FIRMA — **è già aperto**

I criteri sono stati scritti **prima dei numeri** e l'autorizzazione è in chat
(_"Sì, misuriamo quanto succede"_). Essendo una misura **a rischio bassissimo**
— una sedia sola, **nessun cambio in forward**, **nessuna promozione possibile**
— i criteri stessi (§ in testa) dicono che **non serve altra firma**.

> 🚦 **RESTA IL CANCELLO DEL TRAFFICO: una macchina, un lavoro.** Il PC di
> backtest ha **un solo MT5**. R104 parte **solo quando R102/R103 hanno finito
> di toccare il terminale**. Due tester sullo stesso MT5 si rubano cache e
> frame: il risultato non si legge più.

---

## 📌 IL PIN — **`4be07ed3f2d80024032bbf2258f1abe58079db42`**

```
4be07ed3f2d80024032bbf2258f1abe58079db42
```

⚠️ **Il pin si rilegge DOPO il push, non prima** (checklist 6 e 55). Il commit da
pinnare deve contenere **tutti e quattro** gli artefatti: il driver, il file
prova, il `.mq5` di misura e i criteri. Se il verificatore corregge qualcosa,
questo blocco va **ripinnato e questa riga riscritta**.

La riga passa il pin a `-Pin` e **si rifiuta di partire senza**: un default
silenzioso (`lavoro`) farebbe girare la punta del branch spacciandola per un
commit congelato.

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** Col terminale aperto il tester non
  gira; con MetaEditor aperto la compilazione torna subito **senza compilare**.
  La riga si rifiuta di partire in tutti e due i casi.
- **NESSUNA SEDIA VIVA VIENE TOCCATA.** Il round compila
  `ABTG_MaxMinNotte_DAX_Short_Ottimizzato_MFE.mq5`, che è un **file diverso** e
  produce un **`.ex5` diverso**: il sorgente vivo non viene né letto, né
  riscritto, né ricompilato. Il magic è **750010** (blocco `750xxx`, verificato
  libero in tutto il repo il 24/08: zero occorrenze); il magic **vivo 770411 è
  vietato e controllato nel codice**, sia nel file prova sia nel sorgente.
- **UNA sola passata**, `Model=4` (**tick reali**), finestra
  **2024.09.26 → 2026.08.24**, deposito 100.000, `Optimization=0`.
  **Zero assi spazzolati**: il driver si **ferma** se nel file prova trova anche
  un solo flag `Y`. Non è un walk-forward e non è un'ottimizzazione.
- **NON c'è nessun timeout sulla passata**, ed è voluto: l'`.ini` ha
  `ShutdownTerminal=1` e il terminale **esce da solo** a test finito
  (`WaitForExit`). Un timeout che lo ammazza a metà lascerebbe sul disco un
  **CSV troncato che sembra un risultato** — è il difetto pagato il 18/08.
- **Il round non scarica storico** e non tocca `bases\<server>\ticks`: i tick
  reali di D30EUR dal 2024.09.26 sono già agli atti (sonda 17/08, verdetto
  `COMPLETO`; i tick partono dal 2024.07.05, quindi **tutta** la finestra ne ha).
- 🔧 **Se non è già stato fatto**: MT5 → Strumenti → Opzioni → Grafici →
  **"Max barre nel grafico" = Illimitato**. Il driver scrive comunque
  `[Charts] MaxBars=2000000000` nel suo `.ini`.

---

## 1️⃣ PRIMA il giro a vuoto (pochi minuti, **nessuna passata**)

> ⚠️ **Non è a costo zero sul terminale**: scarica gli artefatti al pin e
> **installa `ABTG_PausaGuardian.mqh`** in `MQL5\Include`. Quello che **non** fa:
> non compila, non apre MT5 per testare, non cancella niente.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='4be07ed3f2d80024032bbf2258f1abe58079db42'; $p="$env:USERPROFILE\RIGA_R104.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R104_MFE_MAXMIN_DAX.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R104_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Cosa deve dire** (altrimenti la corsa vera non parte):

- in testa: `modo .... CONTROLLO`, `finestra .... 2024.09.26 -> 2026.08.24`,
  `modello .... 4 = TICK REALI`, `passate .... 1`, `magic di misura .... 750010`;
- `include installato: ABTG_PausaGuardian.mqh (82941 byte)`;
- `file prova: 55 righe vive (52 parametri + 3 direttive), D30EUR M15 dal
  2024.09.26, rischio 1.0%, magic 750010, ZERO assi Y`;
- `ABTG_MaxMinNotte_DAX_Short_Ottimizzato_MFE.mq5 al pin, version 1.10 (magic
  750010, marcatore MARCATORE_MFE_R104_v1, include Guardian, OPTFRAME, contatore
  MFE)`;
- `ini scritto e verificato: ... (52 parametri, Model=4, Optimization=0)`;
- in fondo: **nessun PROBLEMA in elenco** e
  `ESITO: GIRO A VUOTO COMPLETATO`.

> ⚠️ **Quello che il giro a vuoto NON può fare, detto prima.**
> `-SoloControllo` **non apre MT5**: non esiste **nessun** `n`, nessun
> istogramma, nessuna percentuale, **nessuna risposta alla domanda**. Conferma
> gli **artefatti**, mai i numeri. Sta scritto anche **dentro il suo referto**,
> perché nessuno lo scambi per il round.

---

## 2️⃣ POI la corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='4be07ed3f2d80024032bbf2258f1abe58079db42'; $p="$env:USERPROFILE\RIGA_R104.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R104_MFE_MAXMIN_DAX.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R104_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**: è **un comando solo** (checklist 21). Tre righe
staccate sarebbero tre comandi indipendenti, e un `throw` alla prima non
fermerebbe le altre.

**Durata [STIMA, non una previsione]**: **una** passata a tick reali su ~23 mesi
di D30EUR M15. I round gemelli su questa finestra stanno nell'ordine dei
**minuti-decine di minuti**; se le barre M1 non fossero complete MT5 se le
scarica **mentre gira** e può volerci di più. **Non c'è timeout**: si lascia
finire.

> ⚠️ **Perché qui il messaggio è GIALLO e nel giro a vuoto è ROSSO.** Nella corsa
> vera `exit 1` può voler dire _"la corsa è riuscita e la risposta non ti
> piace"_: gli artefatti **esistono** e vanno mandati lo stesso.

---

### 📅 LE DUE RIGHE CHE CLAUDIO DEVE LEGGERE NEL REFERTO, PRIMA DI MANDARE LO ZIP

Aprire `REFERTO_R104.txt` e guardare **due righe in testa**, in quest'ordine:

1. **`modo:`** — dice `CORSA` (il round) o `CONTROLLO` (giro a vuoto: **non è il
   round, non si manda come risultato**);
2. **`data:`** — **deve essere di ADESSO**. Se è di ieri è un referto **stantio**:
   si guarda il nome della cartella sul Desktop (porta data e ora) e si rifà.

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul Desktop: `R104_MFE_MAXMIN_DAX_<MODO>_<data>_<ora>` — dentro:

- **`REFERTO_R104.txt`** ← **è questo che conta**;
- **`ABTG_MFE_MaxMinDAX.csv`** — il dato grezzo, una riga per operazione
  (`open_time; close_time; mfe_R; realizzato_R; tp1_toccato; esito;` più le
  colonne diagnostiche `tp1_geom_1R; mae_R; ticket; vol_iniziale; risk_punti;
  risk_valuta; n_uscite`);
- `abtg_trades_750010.csv` — il **secondo** strumento, quello del controllo
  d'igiene;
- `R104_passata.ini` (l'`.ini` VERO che ha girato) e il file prova al pin;
- `report_passata.htm`, `log_ea.txt`, `compile_*.log`.

---

## 🚩 LE COSE DA GUARDARE PER PRIME NEL REFERTO

1. 🔢 **`operazioni chiuse` e il cancello `G1`.** Se `n < 30` il referto scrive
   **NON MISURABILE** al posto delle percentuali, **e va bene così**: è una
   risposta, non un guasto. ⚠️ **Attenzione, è lo scenario probabile**: questa
   sedia fa **~1,7 operazioni al mese** (censimento frequenza del 22/08) e la
   finestra è di ~23 mesi. **Il conto a mente dà ~40 operazioni: siamo appena
   sopra la soglia.** Se ne escono meno di 30, l'istogramma si legge lo stesso
   (contare non è stimare) ma **nessuna frequenza** se ne ricava.
2. 🧪 **`CONTROLLO D'IGIENE`.** Deve dire `OK: N righe MFE = N posizioni chiuse`.
   Se **divergono**, le percentuali sono **sospette** finché lo scarto non è
   spiegato: i due conteggi vengono da due strumenti indipendenti (il contatore
   tick-su-tick dentro l'EA e lo storico dei deal).
3. 📊 **L'ISTOGRAMMA di `mfe_R`** e poi **LA RISPOSTA ALLA DOMANDA**, che il
   referto stampa con **due denominatori diversi ed etichettati**:
   `% su TUTTE le operazioni` e `% sulle sole operazioni arrivate a 0,5R`. Sono
   **due frazioni diverse**: si leggono accanto, mai una al posto dell'altra.
4. ⚖️ **Le due letture di `tp1_toccato`.** Il referto ne dà **due**, e la
   differenza è essa stessa un risultato:
   - **`tp1_toccato`** = il **flag interno vero** dell'EA (`gPart1`);
   - **`tp1_geom_1R`** = la **geometria** (`mfe_R >= 1R` sulla R **iniziale**).

   👉 **Non sono la stessa cosa, ed è misurato nel codice**: `gPart1` diventa
   `true` **solo se la parziale è stata eseguita davvero** (`if(parzOK)
   gPart1=true;` nel sorgente vivo) — al lotto minimo la parziale arrotonda a
   zero e il flag resta `false` anche se il prezzo aveva toccato 1R. E c'è un
   secondo motivo: `ManagePos` ricalcola `risk` dallo **stop CORRENTE**, che il
   trailing può aver già spostato, quindi il suo "1R" può essere **più vicino**
   di quello iniziale. **Se le due percentuali divergono molto, è quello il
   fatto da raccontare.**
5. 🧯 **IL TETTO TEORICO.** Il referto stampa "somma se ogni `mfe_R >= 1R` fosse
   incassato a 1R". **È un limite superiore irrealizzabile, MAI un obiettivo**:
   nessuno sa in anticipo quale trade toccherà 1R, e incassare sempre a 1R
   spegnerebbe anche i trade che poi sono andati a 3R o 4R. Serve solo a dare la
   **scala**.

---

## 🔴 LE QUATTRO COSE CHE R104 **NON** DICE

1. **NON promuove e NON boccia niente**, e **non cambia una virgola del
   forward**. È informazione su un meccanismo **già in campo**.
2. **NON propone nessuna soglia diversa e non tocca il trailing.** Se i numeri
   suggerissero un aggiustamento, quella conversazione è **successiva e
   separata, con firma propria** (criteri §7).
3. **NON è un walk-forward.** Una finestra sola, **un solo regime** (21+ mesi di
   indici che salgono): descrive **questa** epoca, non la sedia in eterno.
4. **NON c'è il controllo delle due passate gemelle.** Girerebbero sullo
   **stesso file comune** e la seconda cancellerebbe la prima: al suo posto c'è
   il confronto col conteggio dello storico dei deal (punto 2 qui sopra).

---

## ✅ COSA È GIÀ STATO VERIFICATO — **eseguendo**, prima dell'invio

Checklist punto **63** (_"il parse si FA, non si dichiara impossibile"_):

- ✅ il `.ps1` **parsa**: `pwsh` + `[Parser]::ParseFile` → **0 errori**, 7677
  token; **ASCII puro** (0 righe non-ASCII, regola del 17/08);
- ✅ **i gate del file prova girano davvero** sul file vero: 55 righe vive, 52
  parametri, `@SIMBOLO`/`@PERIODO`/`@DAQUANDO`, rischio, commento, magic, **0
  assi Y**;
- ✅ **la fabbrica dell'`.ini`** produce 52 parametri secchi (nessun `||`
  residuo) e passa **tutti** i suoi gate (`AllowLiveTrading=false`, `Model=4`,
  `Optimization=0`, `ShutdownTerminal=1`, `FromDate`, `ToDate`);
- ✅ **i conti del referto**, provati su un CSV finto con valori scelti a mano e
  **verificati a mente**: istogramma, `NMfe05`, `NMfe05NoTp1`, le due
  percentuali, la media del restituito, il tetto teorico. Provati **sotto
  cultura it-IT** (il VPS è italiano): `0.5` resta zero-virgola-cinque e non
  diventa cinque;
- ✅ **il cancello G1 provato in tutti e due i versi**: con `n=8` risponde
  `NON MISURABILE`, con `n=40` stampa le percentuali;
- ✅ **controllo negativo** sul parser del CSV (checklist 55): con
  un'intestazione diversa **si rifiuta di leggere** invece di indovinare la
  posizione delle colonne;
- ✅ il file prova confrontato **riga per riga** col preset live
  `sedia_..._770411.set`: **l'unica differenza è `InpMagic`**
  (`770411` → `750010`). `InpUsaGuardian` è l'unico input che il preset non
  nomina, ed è scritto esplicitamente col default del sorgente (checklist 25);
- ✅ il `.mq5` di misura **diffato** contro il sorgente vivo: le uniche righe
  rimosse/cambiate sono l'intestazione, la `#property description` e il default
  di `InpMagic`. **Nessuna riga di logica di trading è stata toccata.**

🟡 **Non verificato, e va detto**: tutto ciò che richiede **MT5** — la
**compilazione vera del `.mq5` di misura** (nessuno può compilarlo qui: non c'è
MetaEditor), il comportamento del contatore sui tick veri, la durata reale, il
numero di operazioni che uscirà. **Il giro a vuoto copre gli artefatti; i numeri
— e la prova che il codice compila — li può dare solo la corsa.**

> ⚠️ **Il rischio residuo più concreto, dichiarato: la COMPILAZIONE.** Se il
> blocco MFE avesse un errore di sintassi, la riga si ferma al passo 4 con
> `COMPILAZIONE FALLITA` **e stampa le ultime 20 righe del log del
> compilatore**: quelle righe bastano a correggere e ripinnare. Non produce
> nessun numero sbagliato — si ferma prima.
