# 📬 R102 — **LE RIGHE DA MANDARE** (classifica lunga, 20 sedie forex/argento)

**Round**: R102 — **LA CLASSIFICA LUNGA**. Le celle **vive** della flotta
**NON-oro** e **NON-indice** misurate sulla **finestra più lunga che il broker
permette, simbolo per simbolo**. Modello **OHLC M1**, deposito **100.000**.
**Criteri**: `backtest_pipeline/risultati_archivio/R102_CRITERI.md`
**Driver**: `backtest_pipeline/righe/RIGA_R102_CLASSIFICA_LUNGA.ps1`
(marcatore `MARCATORE_RIGA_R102_v1`).

---

## 🛑 DUE CANCELLI PRIMA DI TUTTO — **il primo è CADUTO, il secondo è CHIUSO**

### 1️⃣ ✅ **I CRITERI SONO FIRMATI — 23/08/2026, sera: _"FIRMO CON PROPOSTE"_**
`R102_CRITERI.md` **non è più una bozza**. Le **sei decisioni** del suo §9 sono
risolte **tutte con la proposta del preparatore** (verbale in testa ai criteri):

| # | decisione | proposta | ✅ **RISOLUZIONE FIRMATA** |
|---|---|---|---|
| 1 | finestra **COMUNE**: `2009` (XAGUSD dentro) o `2008` (XAGUSD fuori dalla classifica) | **2009, XAGUSD dentro** | ✅ **2009.01.01 → 2026.06.30, XAGUSD (C13) DENTRO** |
| 2 | **pavimento** sulle serie ricostruite (EUR pre-1999, USDJPY pre-1971/93): subito o dopo il GATE 4 | **dopo: prima si misura** | ✅ **prima corsa SENZA pavimento**; il taglio è una **seconda corsa** dopo il GATE 4 |
| 3 | **perimetro**: 20 sedie o solo Breaking Band | **20, ma a BLOCCHI, BB per primo** | ✅ **20 a blocchi, BLOCCO 1 = `C01,C02,C03`** |
| 4 | la **coda** dietro R101 | **sì** | ✅ **sì — ed è il cancello 2 qui sotto, ancora CHIUSO** |
| 5 | riscrivere alla taglia viva i **2 contratti PTE GBPUSD** (oggi `2x` non calcolabile) | **sì, firma a parte** | ✅ **sì, FIRMA A PARTE**: R102 gira lo stesso, `2x NON CALCOLABILE` su C04/C05 |
| 6 | `BREAKOUT_EA_JPY_v3`: contratto o **dichiarazione di stato**? (aperta dal 18/08) | **dichiarare lo stato** | ✅ **dichiarare lo stato** — rilievo **ancora aperto** |

> 🟢 **E LE DUE CHE CAMBIAVANO COSA GIRA NON HANNO CAMBIATO NIENTE.** Le proposte
> 1 e 2 erano **già** quelle implementate: la COMUNE nel driver era già
> `2009.01.01` e `-PavimentoData` aveva già default **vuoto**. **Verificato sui
> 20 file prova, uno per uno**: `@DAQUANDO`, `@SIMBOLO`, `@PERIODO` e la finestra
> COMUNE in intestazione **non sono stati toccati**. Gli `.ini` restano quelli
> provati.

✅ **PIN ASSEGNATO il 23/08 notte: `7aa83fd`** (dopo il secondo passaggio del
verificatore, che ha trovato e fatto correggere il difetto **checklist 65**:
`-SoloSedia C01,C02,C03` senza apici passava UN token `"C01 C02 C03"` e il
blocco usciva con `exit 1` senza zip. Fix nel driver: split su `[,\s]+`,
entrambe le forme accettate; in più la raccolta ora filtra i CSV del SOLO
blocco corrente. Gli elenchi nelle righe restano comunque **fra apici**.)

### 2️⃣ 🚦 **LA CODA: R102 GIRA DOPO R101. Una macchina, un lavoro.**
R101 (ablazione dei filtri su Dow e DAX) è pinnato a
`e4c1afac63f0d094e7895d5f0626a183c43f0566`, i suoi due controlli sul grafico
sono **fatti e verdi** (commit `7070437`), e **deve finire e mandare il suo
zip** prima che R102 tocchi il terminale. Due tester sullo stesso MT5 si rubano
la cache e i frame: il risultato **non si legge più**.

> 📌 **E poi c'è il verificatore.** Queste righe, come sempre, passano da lui
> prima di arrivare a Claudio.

---

## 📌 IL PIN — ✅ **ASSEGNATO: `7aa83fd7548e94379e3eeb6bdabdb9c8a8d02093`**

```
7aa83fd7548e94379e3eeb6bdabdb9c8a8d02093
```

> ### ✅ Righe DEFINITIVE (verificatore passato DUE volte: 78d8f4f FAIL con
> correzioni → fix committati → ripinnate a `7aa83fd`).
> Storia dei pin: `c1ff3b2` → `fe86b42` (fix conteggio finestre) →
> `78d8f4f` (firma registrata, FAIL del verificatore per checklist 65) →
> **`7aa83fd`** (fix `-SoloSedia` + filtro CSV per blocco + checklist 65).
> 🚦 **Resta il cancello della CODA: R102 parte solo DOPO la chiusura di
> R101** (zip SOLODAX letto e referto chiuso).

Il pin è il commit che contiene **il driver, i 20 file prova, il generatore e i
criteri**. _(Era `c1ff3b2`, poi `fe86b42`: **ripinnato** dopo il fix del
conteggio delle finestre — con `c1ff3b2` il driver girava lo stesso, ma i
documenti dicevano `17 passate per sedia` dove lo schermo ne avrebbe stampate
`15`, e un numero atteso che non torna ferma la corsa per niente.)_ Le righe lo
passano a `-Pin` e **rifiutano di partire senza**: un default silenzioso
(`lavoro`) farebbe girare la punta del branch spacciandola per un commit
congelato.

⚠️ **Il pin si rilegge DOPO ogni push, non prima** (checklist 6 e 55): se il
verificatore corregge qualcosa, questo blocco va ripinnato **e questa riga
riscritta**.

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** Col terminale aperto il tester non
  gira ed escono zero risultati; con MetaEditor aperto la compilazione torna
  subito **senza compilare**. La riga si rifiuta di partire in tutti e due i
  casi.
- **Il round COMPILA 7 EA VIVI** sul terminale collegato al conto vero
  (`BreakingBand`, `PTE`, `SuperWave`, `EasyTrend`, `CostToCost`, `GapFill`,
  `PunteLarry`). Per ognuno il `.mq5` **e** il `.ex5` vanno in un **backup
  datato** (`.prima_r102_<stamp>`), e **se la compilazione fallisce il `.mq5`
  viene rimesso com'era**: sorgente e binario restano sempre la stessa versione.
  Si compila **una volta per EA**, non una per sedia.
- **Nessuna sedia viva viene toccata nei test.** Magic **vergini** del blocco
  `79xxxx` — verificato **magic per magic, tutti e 300**, zero occorrenze nel
  repo. Sono **vietati e controllati nel codice** tutti i magic vivi del
  censimento `.chr` del 23/08 e i blocchi `7799xx` (R99) e `78xxxx` (R100).
- **Niente tick, e non si tocca `bases\<server>\ticks`.** Modello **OHLC M1**
  per criterio.
  👉 **Il DD è un LIMITE INFERIORE del rischio. Il PROFITTO è una STIMA DEL
  LORDO** (spread corrente e non storico, zero slippage): **non è un guadagno.**
- **🔴 IL COLLO DI BOTTIGLIA È LO SCARICO DELLE BARRE**, non il tester: **M1 di
  DODICI simboli** da vent'anni (`GBPUSD` `EURUSD` `AUDUSD` `USDJPY` `CHFJPY`
  `AUDJPY` `EURJPY` `GBPCAD` `XAGUSD` `EURAUD` `GBPJPY` `EURCAD`). R100 ne
  scaricava **uno**. **Nessuno l'ha mai misurato su dodici in fila.**
- **Durata [STIMA]: 6-16 ore di tester** per tutte e venti (~2.280 anni-sedia
  contro gli ~886 di R100, che erano stimati 2-6 ore) **più** lo scarico.
  `-OreMax` è **20** ed è un tetto sull'**inizio** di nuovi lavori, non
  un'interruzione.
- **🔧 PRIMA DI TUTTO, UNA VOLTA SOLA, A MANO SU MT5**: Strumenti → Opzioni →
  Grafici → **"Max barre nel grafico" = Illimitato**. Il driver scrive
  `[Charts] MaxBars=2000000000` nei suoi `.ini`, ma il tetto delle **100.000
  barre** misurato il 17/08 è quello che trasformava trentatré anni in sedici.
  **Senza questo, scaricare non serve a niente sui simboli profondi.**

---

## 1️⃣ PRIMA il giro a vuoto (pochi minuti, nessuna passata di test)

> ⚠️ **Non è a costo zero sul terminale**: scarica gli artefatti al pin (20 file
> prova, 7 `.mq5`, l'include, `CONTRATTI_SEDIE.md`) e **installa
> `ABTG_PausaGuardian.mqh`**. Quello che **non** fa: non ricompila, non apre MT5
> per testare, non svuota la cache, non cancella niente. **Zero passate, zero
> CSV.**

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='7aa83fd7548e94379e3eeb6bdabdb9c8a8d02093'; $p="$env:USERPROFILE\RIGA_R102.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R102_CLASSIFICA_LUNGA.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R102_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Cosa deve dire** (altrimenti la corsa vera non parte):

- in testa: `sedie .... 20 su 20`, `simboli distinti .... 12`,
  `finestre per sedia .... 6 (5 di misura, + 1 DIAGNOSTICA)`,
  `passate per sedia .... 15`, `passate TOTALI .... 300`;
- `include installato: ABTG_PausaGuardian.mqh`;
- per **ognuna** delle 20 sedie, tre righe verdi:
  - `file prova: NN righe vive (NN parametri + 3 direttive), <SIMB> <TF> dal <data>, rischio X%, asse Y = InpMagic 79SS10/79SS11`
  - `<EA>.mq5 al pin, version V (magic sorgente NNNNNN [magic VIVO della sedia: MMMMMM -- e' un grafico di VIVAIO], include Guardian, OPTFRAME e Log d'ingresso presenti)`
    👉 quel numero è il magic **del sorgente**, ed è **diverso** dal magic vivo
    **su tutte e venti**: sono grafici di vivaio. **Se leggessi il magic vivo
    sotto l'etichetta «magic sorgente», la riga sarebbe da fermare.**
  - `DD promesso ESTRATTO: …` **oppure**, sulle **due PTE GBPUSD**,
    `DD promesso: DD PROMESSO AMBIGUO (…riscalatura di taglia) → il confronto 2x sarà NON CALCOLABILE` — **è ATTESO e dichiarato** (criteri §4.3);
- **le righe vive attese, sedia per sedia** (se una non torna, l'artefatto è
  cambiato e la riga si ferma da sola):

| id | EA | simbolo | TF | @DAQUANDO | righe vive | param. | magic gemelle |
|---|---|---|---|---|---:|---:|---|
| C01 | `ABTG_BreakingBand` | GBPUSD | H1 | 1993.05.11 | 74 | 71 | 790110 / 790111 |
| C02 | `ABTG_BreakingBand` | EURUSD | H1 | 1971.01.03 | 74 | 71 | 790210 / 790211 |
| C03 | `ABTG_BreakingBand` | AUDUSD | H1 | 1993.04.26 | 74 | 71 | 790310 / 790311 |
| C04 | `ABTG_PTE` | GBPUSD | H1 | 1993.05.11 | 47 | 44 | 790410 / 790411 |
| C05 | `ABTG_PTE` | GBPUSD | H1 | 1993.05.11 | 47 | 44 | 790510 / 790511 |
| C06 | `ABTG_PTE` | USDJPY | H1 | 1971.01.03 | 47 | 44 | 790610 / 790611 |
| C07 | `ABTG_SuperWave` | GBPUSD | **H4** | 1993.05.11 | 47 | 44 | 790710 / 790711 |
| C08 | `ABTG_EasyTrend` | CHFJPY | H1 | 1992.02.18 | 30 | 27 | 790810 / 790811 |
| C09 | `ABTG_EasyTrend` | GBPUSD | H1 | 1993.05.11 | 30 | 27 | 790910 / 790911 |
| C10 | `ABTG_EasyTrend` | AUDJPY | H1 | 1993.05.16 | 30 | 27 | 791010 / 791011 |
| C11 | `ABTG_CostToCost` | EURJPY | **H4** | 1993.04.26 | 20 | 17 | 791110 / 791111 |
| C12 | `ABTG_CostToCost` | GBPCAD | **H4** | 2007.08.21 | 20 | 17 | 791210 / 791211 |
| C13 | `ABTG_CostToCost` | XAGUSD | **H4** | 2008.11.07 | 20 | 17 | 791310 / 791311 |
| C14 | `ABTG_GapFill` | GBPUSD | H1 | 1993.05.11 | 19 | 16 | 791410 / 791411 |
| C15 | `ABTG_GapFill` | EURUSD | H1 | 1971.01.03 | 19 | 16 | 791510 / 791511 |
| C16 | `ABTG_GapFill` | AUDUSD | H1 | 1993.04.26 | 19 | 16 | 791610 / 791611 |
| C17 | `ABTG_PunteLarry` | EURAUD | H1 | 2004.06.16 | 23 | 20 | 791710 / 791711 |
| C18 | `ABTG_PunteLarry` | GBPJPY | H1 | 1993.04.18 | 23 | 20 | 791810 / 791811 |
| C19 | `ABTG_PunteLarry` | GBPUSD | H1 | 1993.05.11 | 23 | 20 | 791910 / 791911 |
| C20 | `ABTG_PunteLarry` | EURCAD | H1 | 1999.08.01 | 23 | 20 | 792010 / 792011 |

- e in fondo: **nessun PROBLEMA in elenco** e `ESITO: GIRO A VUOTO COMPLETATO`.

> ⚠️ **Quello che il giro a vuoto NON può fare, detto prima.**
> **`-SoloControllo` non apre MT5**, quindi **non esiste nessuno dei cinque
> numeri**: niente profitto, niente PF, niente DD, niente peggior giornata,
> niente spina dorsale, niente `n`, niente prima operazione, **niente
> classifica**. Può confermare gli **artefatti** (file prova, celle, finestre,
> magic, `.ini`, DD promessi estratti), **mai i numeri**. Sta scritto anche
> **dentro il suo referto**, perché nessuno lo scambi per il round
> (checklist 57).

---

## 2️⃣ POI la corsa vera — **A BLOCCHI, e Breaking Band per primo**

> ✅ Pin assegnato (`7aa83fd`). 🚦 Il blocco si manda **solo dopo che R101 ha
> chiuso** (decisione 4: una macchina, un lavoro).

🔴 **Non è un ripiego: è il modo previsto.** Venti sedie in un colpo sono 6-16
ore più lo scarico, e un'interruzione a metà costa il 63% del lavoro
(§ripresa). `-SoloSedia` accetta un **ELENCO**, e l'elenco va **FRA APICI**:
`'C01,C02,C03'` — senza apici PowerShell lo spezza in array e lo reincolla con
gli spazi (checklist 65; il driver al pin `7aa83fd` accetta entrambe le forme,
ma gli apici restano la regola).

### 🥇 BLOCCO 1 — **BREAKING BAND** (è la domanda di Claudio)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='7aa83fd7548e94379e3eeb6bdabdb9c8a8d02093'; $p="$env:USERPROFILE\RIGA_R102.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R102_CLASSIFICA_LUNGA.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R102_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloSedia 'C01,C02,C03';
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

### I blocchi successivi — **si cambia SOLO l'elenco dopo `-SoloSedia`**

| blocco | `-SoloSedia` | famiglia |
|---|---|---|
| 2 | `'C14,C15,C16'` | GapFill forex |
| 3 | `'C17,C18,C19,C20'` | PunteLarry forex |
| 4 | `'C11,C12,C13'` | CostToCost (H4, più veloce) |
| 5 | `'C08,C09,C10'` | EasyTrend |
| 6 | `'C04,C05,C06,C07'` | PTE + SuperWave |

**Oppure**, se Claudio preferisce lasciarla girare tutta la notte: **si toglie
`-SoloSedia`** e girano tutte e venti.

Si incolla **il blocco INTERO**, è un comando solo (checklist 21): tre righe
staccate sarebbero tre comandi indipendenti e un `throw` alla prima non
fermerebbe le altre.

> ⚠️ **Perché qui il messaggio è GIALLO e nel giro a vuoto è ROSSO.** Nella
> corsa vera `exit 1` può voler dire *"la corsa è riuscita e la risposta non ti
> piace"* (una finestra accorciata, una sedia fuori classifica, un round
> parziale): gli artefatti **esistono** e vanno mandati lo stesso — un `throw`
> qui butterebbe via una risposta buona (checklist 26-bis). Nel giro a vuoto
> `exit 1` vuol dire una cosa sola: **non si lancia niente.**

⚠️ **Ogni blocco scrive una cartella e uno zip SUOI sul Desktop, e il referto lo
dichiara**: *"un blocco NON è il round"*. **Vanno mandati TUTTI**, non solo
l'ultimo.

### 🔁 Se una corsa si interrompe — **la ripresa NON salta le sedie fatte**

| pezzo | rilancio liscio | quanto pesa |
|---|---|---|
| **PASSO 0** — singola + 2 gemelle sulla finestra lunga | **SI RIFÀ, per ogni sedia della lista** | ~72 anni-sedia = **~63%** |
| le **6 finestre** col CSV già presente | saltate e dichiarate (1 PROBLEMA per ognuna, con la data del file) | ~42 anni-sedia = **~37%** |

Ed è **voluto**: la **peggior giornata** e la **spina dorsale** si leggono dal
report `.htm`, che sta nella **sosta**, e la sosta **si svuota a ogni giro**
(checklist 56). Una sedia "saltata" tornerebbe **senza due dei cinque numeri**.

👉 **La ripresa che costa poco**: `-SoloSedia` con l'**elenco** delle sedie il
cui `esito` nel referto non è `OK` (es. `-SoloSedia 'C07,C11'`).
`-Rifai` rifà **tutto**, finestre comprese: si usa quando si vuole un blocco
intero con tutti i file della **stessa** data, non per riprendere.

### 🧯 E se il 1971 fa disastri (EURUSD, USDJPY) — **è la DECISIONE 2, firmata**

✅ **La firma del 23/08 dice: prima si misura, poi si taglia.** Quindi la prima
corsa va **senza `-PavimentoData`** (default vuoto), e il pavimento è **la
seconda corsa**, decisa **dopo** aver letto il GATE 4 — non prima.

Se il referto mostra che su `C02`, `C06` o `C15` la passata lunga **non finisce
più** o il **GATE 4** dice che i primi quindici anni hanno **zero operazioni**,
si rilancia **senza cambiare il pin**:

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='7aa83fd7548e94379e3eeb6bdabdb9c8a8d02093'; $p="$env:USERPROFILE\RIGA_R102.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R102_CLASSIFICA_LUNGA.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R102_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloSedia 'C02,C06,C15' -PavimentoData '1999.01.04';
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

_(Blocco INTERO, verificato dal verificatore nella ribenedizione del 23/08:
parse 0 errori, ASCII puro. Prima era un frammento `... & $p ...` che non
parsava — convenzione di casa, ma meglio averlo pronto.)_

Il referto scrive in testa che il pavimento è stato applicato, e le righe di
quelle sedie **non vanno confrontate** con quelle del giro precedente.

---

### 📅 LE DUE RIGHE CHE CLAUDIO DEVE LEGGERE NEL REFERTO, PRIMA DI MANDARE LO ZIP

Aprire `REFERTO_R102.txt` e guardare **due righe in testa**, in quest'ordine:

1. **`modo:`** — dice `CORSA` (il round), `CONTROLLO` (giro a vuoto: **non è il
   round, non si manda come risultato**) o `SENZAPASSO0`;
2. **`data:`** — **deve essere di ADESSO**. Se è di ieri, è un referto
   **stantio**: si guarda il **nome della cartella** sul Desktop (porta data e
   ora) e si rifà.

E subito sotto, **`switch di questo giro:`** — dice se c'era `-SoloSedia` (cioè
se è **un blocco e non il round**) e se c'era `-PavimentoData`.

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul Desktop: `R102_CLASSIFICA_LUNGA_<MODO>_<data>_<ora>` —
dentro:

- **`REFERTO_R102.txt`** ← **è questo che conta**. In testa: come si legge il
  referto (l'Emendamento regola B e i due limiti del banco), poi **LA TABELLA
  MADRE**, poi **sedia per sedia** i cinque numeri, le finestre, **la spina
  dorsale anno per anno**, i quattro gate e il contratto;
- gli `.ini` di **ogni** passata (quelli VERI, gli stessi del giro a vuoto);
- gli `OptResults` di ogni sedia e di ogni finestra (`R102_*_ohlc.csv` — il
  suffisso `_ohlc` è la regola di casa: un OHLC non deve nemmeno poter finire
  nella stessa tabella di un tick reale);
- i **report `.htm`** delle passate singole e i **dump delle righe d'ingresso**
  dei log: sono la prova cartacea dei gate;
- i log di compilazione di ogni EA e i referti storici per simbolo;
- `CONTRATTI_SEDIE_al_pin.md`, cioè **il documento da cui è stato letto ogni DD
  promesso**.

---

## 🚩 LE COSE DA GUARDARE PER PRIME NEL REFERTO

1. 🏆 **LA TABELLA MADRE, e la colonna su cui è ORDINATA**: `PROF-COM`, cioè la
   **finestra COMUNE 2009→2026**. ⚠️ **Non `PROF-LUNGA`**: le finestre lunghe
   hanno lunghezze diverse (GBPUSD 33 anni, XAGUSD 17,6) e ordinare su quelle
   darebbe **una classifica della profondità dello storico**, non delle sedie.
2. 🦴 **LA SPINA DORSALE ANNO PER ANNO** di Breaking Band GBPUSD. **È la
   risposta letterale alla domanda**: si prende il **cumulato** dell'ultimo
   decennio e lo si confronta col totale. Se il grosso è nei primi dieci anni,
   *"con 10 anni di storico"* la risposta è **no**.
3. 🚦 **IL GATE 4 (densità)**, riga `4 densita' ....`: dice **quanti anni sono
   stati davvero operati** contro quelli nominali. ⚠️ Su `EURUSD` e `USDJPY` la
   sonda dichiara il **1971** ma le barre D1 sul disco sono ~6.800, cioè **~26
   anni**: se il gate 4 dice "26 su 55", la frase da usare è **26**.
4. 🔴 **La colonna `2x?` / `VERDETTO CORSIA RISCHIO`.** `REVISIONE` = quella
   sedia va rivista sulla corsia RISCHIO (firma 18/08), **senza altre
   discussioni**. È l'**unica decisione** del round, ed è meccanica.
5. **La colonna `PEGGGIOR`** contro il muro prop giornaliero del **5%**.
6. **La `FINESTRA` e la `CLASSIFICA` di ogni sedia.** Se è `ACCORCIATA`, quella
   riga va scritta **accanto a ogni numero** di quella sedia. Se è `FUORI
   CLASSIFICA`, i suoi numeri **non si confrontano** con gli altri.
7. **I `GEMELLI`.** Se divergono, di quella sedia **non si legge niente**: banco
   sporco.
8. **`ROBUSTEZZA: k su N`** — e si guarda **N**, non solo `k`: *"2 su 5"* e
   *"2 su 3, più 2 non misurate"* sono due frasi diverse.

---

## 🔴 LE QUATTRO COSE CHE R102 **NON** DICE — da ricordare leggendo la tabella

1. **NON è una classifica di MERITO.** Emendamento regola B (16/08): *il VECCHIO
   giudica il RISCHIO, il RECENTE il MERITO*. Nato da un caso **misurato**
   (`PTE USDJPY`: IS 2010-2016 **0 celle positive su 28**, OOS recente **25 su
   28**). **Nessuna sedia viene promossa o bocciata qui dentro.**
2. **Il profitto NON è un guadagno.** È una **stima del lordo**, e generosa:
   `Spread=0` = spread **corrente**, non quello del 1993 (che era molte volte
   più largo), zero slippage, riempimenti ideali. Serve a confrontare le sedie
   **fra loro**, sullo stesso banco.
3. **NESSUN DRAWDOWN DI PORTAFOGLIO.** Venti sedie non fanno un DD pari alla
   somma dei loro né pari al massimo: dipende da **quanto si sovrappongono**.
   ⚠️ **E qui morde**: **sette** di queste venti stanno sullo **stesso simbolo,
   GBPUSD** (C01, C04, C05, C07, C09, C14, C19). È **la domanda successiva
   ovvia**, ed è un round diverso.
4. **NON è la classifica della FLOTTA.** Mancano tutti gli **indici**
   (`PTE DOW`, `SuperWave DOW`, `GapFill DOW` e `NIKKEI`, `PunteLarry DOW`, le
   aperture, ORB, MaxMin DAX…) perché il broker ha **21 mesi soli** su quei
   simboli — verdetto `COMPLETO` a `2024.09.26`, **misurato**. E manca l'**oro**,
   perché **è già fatto** (R99 + R100).

> 🔴 **E la sedia che manca del tutto**: `BREAKOUT_EA_JPY_v3` su USDJPY. **Il
> sorgente non esiste nel repo** — niente da compilare, niente da misurare — e
> nel censimento `.chr` del 23/08 la riga **c'è ancora**, senza nemmeno un input
> di rischio leggibile. È una delle **due sedie senza contratto del 18/08**, di
> una famiglia **scartata pre-progetto** (−20.853 €, PF 0,67-0,95 su tutte, DD
> 30-48%). **Non è un via libera: è il rilievo, ed è aperto da sei giorni.**

---

## ✅ COSA È GIÀ STATO VERIFICATO — **eseguendo**, prima dell'invio

Checklist punto **63** (*"il parse si FA, non si dichiara impossibile"*):

- ✅ il `.ps1` **parsa**: `pwsh` + `[Parser]::ParseFile` → **0 errori**;
- ✅ **20/20** file prova passano i **gate veri** (righe vive, parametri,
  `@DAQUANDO`/`@SIMBOLO`/`@PERIODO`, rischio, commento, coppia gemella, magic
  vietati, un solo asse `Y`);
- ✅ **20/20** le due **fabbriche di `.ini`** (OTT + SINGOLA) scrivono e passano
  i loro gate;
- ✅ **20/20** version, magic di sorgente, include Guardian, OPTFRAME e `MarkSrc`
  **letti nei sorgenti veri**;
- ✅ **7/7** i marcatori di log provati sul campione **POSITIVO** *e* su quello
  **NEGATIVO** (checklist 55), e `DataSimulata` scarta l'orologio reale;
- ✅ `LeggiDeal` su **due** report finti, **con e senza** la colonna `Commento`
  in coda (checklist 58): stesso risultato, netto **+497 / −902**;
- ✅ i numeri sotto **cultura it-IT**: `1.27013` → `1,27013` (non `127013`),
  `9 005.54` → `9005,54`;
- ✅ `DDPromesso` sul `CONTRATTI_SEDIE.md` **vero**: **18 estratti, 2 ambigui
  attesi**, e i vincoli su **simbolo** e **magic** provati sui casi che devono
  farli scattare.

🟡 **Non verificato, e va detto**: tutto ciò che richiede **MT5** — la
compilazione vera, il comportamento del tester su `FromDate=1971`, la durata
reale, l'intestazione italiana del report `.htm`. **Il giro a vuoto copre gli
artefatti; i numeri li può dare solo la corsa.**
