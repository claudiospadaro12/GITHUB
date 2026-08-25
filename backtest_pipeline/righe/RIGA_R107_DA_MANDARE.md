# 📬 R107 — **LA RIGA DA MANDARE** (il ricontrollo dei lati SHORT: Dow · DAX · Nasdaq)

**Round**: R107 — **IL LATO SHORT DELLE APERTURE HA EDGE OGGI?**, misurato su
tre geometrie: `ABTG_Dow_Apertura_US` (U30USD M5), `ABTG_DAX_Apertura_EU`
(D30EUR M5), `ABTG_Nasdaq_Apertura_US` (NASUSD M5).
**Perimetro**: `risultati_archivio/R107_CODA_LATI_SHORT.md` (Claudio, 25/08).
**Criteri**: `risultati_archivio/R107_CRITERI.md` — ⚠️ **[DA FIRMARE]**, 3 decisioni.
**Driver**: `righe/RIGA_R107_LATI_SHORT.ps1` (marcatore `MARCATORE_RIGA_R107_v1`).
**File prova**: `prove/R107_DOW_00_metro.txt`, `R107_DOW_01_short.txt`,
`R107_DAX_00_metro.txt`, `R107_DAX_01_short.txt`, `R107_NAS_00_riflong.txt`,
`R107_NAS_01_short.txt` — **sei**.

---

## ❓ LA DOMANDA — è di Claudio, ed è del 25/08

> Davanti al **candelone rosso dell'apertura Dow delle 14:30**, che la sedia
> solo-LONG ha correttamente ignorato: _"Mettilo in coda. Ricontrollo short DAX
> e Nasdaq e Dow."_

**Il round misura una cosa sola: la DIREZIONE.** Per ogni famiglia gira la cella
long viva e **la stessa identica cella con i due lati invertiti**. Fra i due file
di una famiglia la differenza è **letteralmente di due righe** (più `InpMagic`).

---

## 🔴 IL CANCELLO DELLA FIRMA — **è CHIUSO, e va aperto da Claudio**

`R107_CRITERI.md` porta `[DA FIRMARE]` nel titolo. Il driver **lo legge al pin**:

- il **giro a vuoto parte lo stesso** (non apre MT5, non produce nessun numero);
- la **corsa vera si ferma con `exit 2`**, a meno di `-CriteriFirmati`.

**Le tre decisioni** (§ 10 dei criteri, tutte con la proposta già scritta):

| | decisione | proposta |
|---|---|---|
| **D1** | la geometria NASUSD è una **trasposizione letterale** del Dow? | **SÌ**, col limite dichiarato: buffer/offset sono in punti assoluti e i due indici non hanno la stessa scala → un NASUSD rosso vuol dire *"non si trasporta"*, non *"non ha edge"* |
| **D2** | il cancello di merito sullo short | **quello di R54**: PF OOS ≥ 1,10 **E** positivo in IS |
| **D3** | si fa anche una **finestra di discesa** dedicata (feb-apr 2025)? | **NO, non in R107**: ~60 giorni di borsa × ~1 op/giorno, con l'EMA H4 che taglia gli short → **sotto G1 per costruzione** su Dow e NASUSD |

> 🚦 **E RESTA IL CANCELLO DEL TRAFFICO: una macchina, un lavoro.** Il PC di
> backtest ha un solo MT5. R107 parte **solo quando nessun altro round sta
> toccando il terminale**.

---

## 📌 IL PIN — **`690773f79fcb97ba3884f280694e3e4c4bb39d99`**

```
690773f79fcb97ba3884f280694e3e4c4bb39d99
```

⚠️ **Il pin si rilegge DOPO il push, non prima** (checklist 6 e 55). Il commit da
pinnare deve contenere **tutti e otto** gli artefatti: il driver, i **sei** file
prova e i criteri. Se il verificatore corregge qualcosa, questo blocco va
**ripinnato e questa riga riscritta**.

La riga passa il pin a `-Pin` e **si rifiuta di partire senza**: un default
silenzioso (`lavoro`) farebbe girare la punta del branch spacciandola per un
commit congelato.

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** Col terminale aperto il tester non
  gira (zero CSV); con MetaEditor aperto la compilazione torna subito **senza
  compilare**. La riga si rifiuta di partire in tutti e due i casi.
- **NESSUNA SEDIA VIVA VIENE TOCCATA.** I magic sono **vergini, blocco `761xxx`**
  (verificato libero in tutto il repo il 25/08: zero occorrenze). Sono **vietati
  e controllati nel codice** `770202` e `770101` (le due sedie vive) e anche
  **`770201`** — il Nasdaq Apertura è **spento**, ma *un'identità spenta resta
  occupata*.
- **24 passate** (6 celle × 2 finestre × 2 gemelle), **12 CSV**, `Model=4`
  (**tick reali**), finestra **2024.09.26 → 2026.06.30**, split 40/60,
  deposito 100.000, rischio 1%.
- **Zero parametri spazzolati.** L'**unico** asse con flag `Y` è `InpMagic`, e il
  driver **si ferma** se in un file prova ne trova un secondo.
- **Il round non scarica storico** e non tocca `bases\<server>\ticks`: i tick
  reali di U30USD, D30EUR **e NASUSD** dal 2024.09.26 sono già agli atti
  (sonda del 17/08, verdetto `COMPLETO`; su NASUSD ci ha già girato R98).
- 🔧 **Se non è già stato fatto**: MT5 → Strumenti → Opzioni → Grafici →
  **"Max barre nel grafico" = Illimitato**. Il driver scrive comunque
  `[Charts] MaxBars=2000000000` nei suoi `.ini`.
- ⏱️ **Durata [STIMA, non una previsione]**: R101 fece **80** passate sugli stessi
  due simboli in poche ore; qui sono **24**, più un simbolo nuovo.
  `-OreMax 10` è un tetto sull'**inizio** di nuovi file, non un'accetta su un
  lavoro in corso.

---

## 1️⃣ PRIMA il giro a vuoto (pochi minuti, **nessuna passata**)

> ⚠️ **Non è a costo zero sul terminale**: scarica gli artefatti al pin,
> **installa `ABTG_PausaGuardian.mqh`** in `MQL5\Include` e **COMPILA i tre EA**
> (la compilazione si fa anche a vuoto, altrimenti il giro non direbbe niente
> sulla compilabilità). Quello che **non** fa: non apre MT5 per testare, non
> cancella nessun artefatto.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='690773f79fcb97ba3884f280694e3e4c4bb39d99'; $p="$env:USERPROFILE\RIGA_R107.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R107_LATI_SHORT.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R107_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Cosa deve dire** (altrimenti la corsa vera non parte):

- in testa: `famiglie 3 (DOW, DAX, NAS)`, `celle 6 (di cui LONG: 3)`,
  `CSV attesi 12`, `passate 24`, `IS 2024.09.26 -> 2025.06.09`,
  `OOS 2025.06.10 -> 2026.06.30`;
- i tre G0 dichiarati **prima** della corsa: `DOW : PF 1.270 | DD 4.39% | n 130`,
  `DAX : PF 1.397 | DD 7.23% | n 270`, e
  **`NAS : G0 NON APPLICABILE — nessuna sedia viva, nessun numero agli atti`**;
- `criteri: NON FIRMATI (il file porta ancora [DA FIRMARE])` — **è giusto così
  finché non firmi**, e il giro a vuoto prosegue lo stesso;
- `6 file prova scaricati al pin, righe vive verificate (DOW 74 / DAX 75 / NAS 89)`;
- `gate della STELLA: ogni cella short differisce dalla sua cella long SOLO sui due lati`;
- `geometria, ora SERVER, LATI, asse unico e 12 magic vergini verificati NEI FILE`;
- `include installato: ABTG_PausaGuardian.mqh (... byte)`;
- `COMPILATO` × 3 (`ABTG_Dow_Apertura_US v1.01`, `ABTG_DAX_Apertura_EU v1.01`,
  `ABTG_Nasdaq_Apertura_US v1.02`);
- in fondo: `anteprime .ini in sosta: 6 su 6`, **nessun PROBLEMA in elenco** e
  `ESITO: GIRO A VUOTO COMPLETATO`.

> ⚠️ **Quello che il giro a vuoto NON può fare, detto prima.** `-SoloControllo`
> **non apre MT5**: non esiste nessun `n`, nessun PF, nessun DD, **nessun G0 e
> nessun G0-bis**. Conferma gli **artefatti**, mai i numeri. Sta scritto anche
> **dentro il suo referto**, perché nessuno lo scambi per il round.

---

## 2️⃣ POI la corsa vera — **solo dopo aver firmato le tre decisioni**

Se hai tolto il `[DA FIRMARE]` dal file dei criteri, il gate si apre da solo e
`-CriteriFirmati` non serve. Se preferisci **firmare in riga**, aggiungilo: la
firma finisce **scritta nel referto**.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='690773f79fcb97ba3884f280694e3e4c4bb39d99'; $p="$env:USERPROFILE\RIGA_R107.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R107_LATI_SHORT.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R107_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -CriteriFirmati;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**: è **un comando solo** (checklist 21). Tre righe
staccate sarebbero tre comandi indipendenti, e un `throw` alla prima non
fermerebbe le altre.

> ⚠️ **Perché qui il messaggio è GIALLO e nel giro a vuoto è ROSSO.** Nella corsa
> vera `exit 1` può voler dire _"la corsa è riuscita e la risposta non ti
> piace"_: gli artefatti **esistono** e vanno mandati lo stesso.

### 🔁 Se serve riprendere

```powershell
# una famiglia sola
& $p -Pin $pin -CriteriFirmati -SoloEa 'DAX'
# due famiglie -- ⚠️ FRA APICI (checklist 65: senza, la virgola fa un ARRAY)
& $p -Pin $pin -CriteriFirmati -SoloEa 'DOW,NAS'
# una cella sola
& $p -Pin $pin -CriteriFirmati -SoloCella R107_DAX_01_short.txt
```

In **tutti** i casi la **cella LONG della famiglia rigira**: è il denominatore, e
senza denominatore lo short non si legge. Costa **2 CSV**, non una passata sprecata.

---

### 📅 LE DUE RIGHE CHE CLAUDIO DEVE LEGGERE NEL REFERTO, PRIMA DI MANDARE LO ZIP

Aprire `REFERTO_R107.txt` e guardare **due righe in testa**, in quest'ordine:

1. **`modo:`** — dice `CORSA` (il round) o `CONTROLLO` (giro a vuoto: **non è il
   round, non si manda come risultato**);
2. **`data:`** — **deve essere di ADESSO**. Se è di ieri è un referto **stantio**:
   si guarda il nome della cartella sul Desktop (porta data e ora) e si rifà.

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul Desktop: `R107_LATI_SHORT_<MODO>_<data>_<ora>` — dentro:

- **`REFERTO_R107.txt`** ← **è questo che conta**;
- i **12 CSV** di ottimizzazione (2 righe l'uno: le gemelle di controllo);
- i **sei file prova al pin**, così lo zip è autosufficiente;
- `compile_DOW.log`, `compile_DAX.log`, `compile_NAS.log`;
- (solo nel giro a vuoto) le **6 anteprime `.ini`**.

---

## 🚩 LE COSE DA GUARDARE PER PRIME NEL REFERTO

1. 🔬 **I TRE VERDETTI G0.** DOW e DAX devono dire **`RIPRODOTTO`**. Il NAS dirà
   **`NON APPLICABILE`** — ed è previsto: sul Nasdaq non esiste nessuna sedia viva
   con questa geometria. ⚠️ **`NON APPLICABILE` non è `superato`**: su quella
   famiglia non c'è nessuna prova che il banco sia sano.
2. 🧪 **IL G0-BIS, ed è il più informativo del round.** La cella `DOW 01_short`
   **non è una misura nuova**: R54 (14/08) l'aveva già girata su questa identica
   finestra e geometria, con esito **OOS PF 0,840 · DD 8,62% · n 73** (bocciata
   **per merito**, non per campione). Deve **ridare quei numeri**.
   👉 **Se non li ridà, il banco è sospetto e anche DAX e NASUSD vanno letti con
   riserva.** Non ferma il round, ma finisce nei **PROBLEMI**.
3. 🆕 **LA MISURA NUOVA È IL DAX SHORT.** Il `REGISTRO_TEST.md` la teneva "in coda"
   (riga **A3**) da un anno — e per di più su una geometria **diversa** (rottura
   secca, non retest). **È la prima volta che si misura il lato short della
   geometria che sta sui soldi.**
4. 🦴 **LA SPINA DORSALE.** Se una short esce **verde in IS e rossa in OOS**, la
   prima ipotesi **non** è *"il lato è instabile"*: la correzione di
   **febbraio-aprile 2025** cade **dentro l'IS** (che finisce il 2025.06.09), e
   l'OOS è quasi tutto salita. **[INFERITO], e resta [INFERITO]**: questo round
   non misura i sotto-periodi.
5. 🎚️ **I CANARINI.** `n OOS` sotto **150** → merito **sospeso** (Emendamento
   regola B). Sotto **30** → **NON MISURABILE**, mai *"non funziona"*.

---

## 🔴 LE CINQUE COSE CHE R107 **NON** DICE

1. **NON promuove e NON boccia niente in forward.** Due delle tre sedie stanno sul
   conto 100k: un cambio è **una firma successiva**, con referto suo (G5).
2. **NON applica i cancelli.** Produce i numeri; **G1-G5 li applica il referto del
   round, a mano.** G3 in particolare non è meccanizzabile: è un ragionamento su
   **tre** tabelle.
3. **Il NASUSD è una TRASPOSIZIONE, non una sedia.** Buffer e offset sono in punti
   assoluti: 1000 punti sono lo 0,023% su un Dow a ~44.000 e lo **0,05%** su un
   Nasdaq a ~20.000. ➡️ **Un NASUSD rosso dice "la geometria del Dow non si
   trasporta", NON "il Nasdaq non ha edge in apertura".**
4. **NON è un walk-forward nuovo** e non ottimizza niente: zero assi spazzolati.
5. **NON chiude la domanda sul lato short.** La finestra è **21 mesi di indici che
   salgono**: il lato short parte svantaggiato **per regime**. Un *"niente edge
   short"* qui la chiude **per questa epoca**, non per sempre.

---

## ✅ COSA È GIÀ STATO VERIFICATO — **eseguendo**, prima dell'invio

Checklist punto **63** (_"il parse si FA, non si dichiara impossibile"_):

- ✅ il `.ps1` **parsa**: `/opt/pwsh/pwsh` + `[Parser]::ParseFile` → **0 errori**,
  13.641 token; **ASCII puro** (0 righe non-ASCII, regola del 17/08);
- ✅ **nessun hashtable letterale multilinea** (la trappola che il 23/08 rese R101
  sintatticamente rotto e lessicalmente perfetto): `$VIVA` si riempie con tre
  assegnazioni separate, e le tabelle dei valori nascono da una funzione;
- ✅ **i gate girano DAVVERO sui sei file veri**, stubbando il download dal repo
  locale: righe vive **74/75/89**, stella, geometria, ora server, asse unico,
  12 magic vergini → **tutti passati**;
- ✅ **e i gate sono stati fatti FALLIRE, uno per uno** (un gate che non scatta mai
  non è dimostrato). Provati e **tutti scattati**: lati scambiati fra i due file
  (lo prende il gate dei **valori**, con la stella verde — è il caso 34-bis), un
  terzo input mosso, magic **vivo** `770101`, magic **duplicato** fra famiglie, un
  **secondo asse Y**, `@DAQUANDO` spostato, `@SIMBOLO` sbagliato, **ora italiana**
  al posto dell'ora server, EMA H4 spenta sul Dow, **opt-in R30 acceso** sul
  Nasdaq, una riga vive tolta. Più il **controllo positivo** finale: i file sani
  ripassano;
- ✅ **il verdetto a tre stati provato in tutti e cinque i rami**: `OK` (exit 0),
  `COMPLETO CON RILIEVI` (exit **0** — non è un fallimento), `COMPLETO CON
  PROBLEMI` (exit 1), `PARZIALE` (exit 1), `FERMATO` (exit 1). Più il sesto,
  **`SELETTORE A VUOTO`** (exit 1), riprodotto iniettando una famiglia senza celle;
- ✅ **la convenzione di sentinella letta SU TUTTE LE COLONNE** facendo girare il
  referto su un round **a secco**: profitto, PF, DD, `n` e peggior giornata escono
  **tutti `n/d`**, mai `-1`, mai `0.000` (difetto 66);
- 🔍 **e un difetto vero trovato così, prima dell'invio**: la colonna
  **"Peggior Giornata %" è NEGATIVA negli artefatti veri** (misurato:
  `csv_R74\..._U30USD_OOS_....csv` → `-0.9971`). Con il formattatore generico —
  che rende `n/d` per ogni valore `< 0` — **l'intera colonna sarebbe uscita `n/d`
  su valori perfettamente misurati.** Corretto con un sentinella **in alto**
  (`99.9`) e un formattatore dedicato;
- ✅ **il parser del CSV provato sotto cultura it-IT** con l'intestazione VERA
  dell'OPTFRAME: `0.84003` letto **zero-virgola-84** (non 84003), gemelli
  `IDENTICI`; e i **controlli negativi**: intestazioni ignote → **si rifiuta di
  indovinare** e stampa quelle che ha visto, una riga sola → `NON VALIDO`,
  gemelli diversi → `DIVERSI su n`;
- ✅ **gli switch provati anche nelle combinazioni che questa riga non propone**
  (checklist 67): `-SoloEa 'DAX'`, `'DOW,NAS'`, `'DOW NAS'` (senza apici),
  `'PIPPO'` (rifiutata con l'elenco dei nomi validi), `-SoloCella` su una short
  (**la long rigira**), e `-SoloEa` + `-SoloCella` incoerenti;
- ✅ i **sei file prova** diffati contro le celle vive di R101: il blocco input è
  **identico carattere per carattere**, e le uniche righe diverse sono `InpMagic`
  e — nelle celle short — **`InpAllowLong` e `InpAllowShort`**;
- ✅ il **core** di `ABTG_Nasdaq_Apertura_US.mq5` diffato contro quello del Dow:
  le uniche differenze sono i **default degli input** (che i file prova pinnano
  tutti) e il **blocco R30**, che è **inerte quando spento** — verificato nel
  sorgente: `UpdateVolRegime()` ritorna alla prima riga, `VolRegimeSL()` ritorna
  lo stop invariato, `SRBlocked()` ritorna `false` subito.

🟡 **Non verificato, e va detto**: tutto ciò che richiede **MT5** — la
**compilazione vera** dei tre `.mq5` (qui non c'è MetaEditor), il comportamento
del tester, la durata reale, e **ogni singolo numero**. **Il giro a vuoto copre
gli artefatti; i numeri li può dare solo la corsa.**

> ⚠️ **Il rischio residuo più concreto, dichiarato: la famiglia NASUSD.** È l'unica
> mai girata con questa geometria su questo simbolo. Se qualcosa non torna
> (compilazione, tick, `n` a zero), **le famiglie DOW e DAX vanno avanti lo
> stesso**: una sedia storta non porta via anche le altre.
