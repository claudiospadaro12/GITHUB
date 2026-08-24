# 📬 R103 — **LE RIGHE DA MANDARE** (la classifica della FLOTTA, 40 sedie)

**Round**: R103 — **LA CLASSIFICA DELLA FLOTTA**. Le celle **VIVE** di **tutte e
40** le sedie di trading dei due conti, su una finestra **recente e comune al
loro gruppo**. Modello **OHLC M1**, deposito **100.000 EUR**.
**Criteri**: `backtest_pipeline/risultati_archivio/R103_CRITERI.md`
**Proposta FIRMATA**: `risultati_archivio/R103_PROPOSTA_CLASSIFICA_FLOTTA.md`
**Driver**: `backtest_pipeline/righe/RIGA_R103_CLASSIFICA_FLOTTA.ps1`
(marcatore `MARCATORE_RIGA_R103_v2`).

---

## ✅ IL CANCELLO DELLA FIRMA — **è CADUTO**

Claudio, 24/08/2026: **_"FIRMO TUTTE E TRE, PARTIAMO"_**

| # | decisione | ✅ **RISOLUZIONE FIRMATA** |
|---|---|---|
| 1 | finestra comune | **2020.01.01 → 2026.06.30** (6,5 anni, col crollo covid dentro) |
| 2 | le 15 sedie indici | **tabella SEPARATA a 21 mesi**, etichettata su ogni riga |
| 3 | come si ordina | **due colonne** (taglia viva + normalizzato 1%), **si ordina sul normalizzato** |

E il **chiarimento della stessa mattina**, che è un **requisito vincolante**:

> _"…**ma vorrei capire se esistono anni negativi x qualcuno**."_

👉 **La SPINA DORSALE periodo per periodo è OBBLIGATORIA per tutte e 40**, e
ogni riga della classifica porta la colonna **NEG/OPER** (periodi in perdita /
periodi **operati**).

---

## 📌 IL PIN — ⚠️ **`040f0cb4465a83b28849fe0408fc97a4b82f5d11`**

```
040f0cb4465a83b28849fe0408fc97a4b82f5d11
```

> 🔴 **Le righe qui sotto NON si lanciano finché questo blocco non porta un hash
> vero.** Il pin è il commit che contiene **il driver, i 40 file prova, il
> generatore e i criteri**. Le righe lo passano a `-Pin` e **si rifiutano di
> partire senza**: un default silenzioso (`lavoro`) farebbe girare la punta del
> branch spacciandola per un commit congelato.
>
> ⚠️ **Il pin si rilegge DOPO ogni push, non prima** (checklist 6 e 55): se il
> verificatore corregge qualcosa, questo blocco va ripinnato **e questa riga
> riscritta**.
>
> 📌 E poi c'è **il verificatore**: queste righe, come sempre, passano da lui
> prima di arrivare a Claudio.

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** Col terminale aperto il tester non
  gira ed escono zero risultati; con MetaEditor aperto la compilazione torna
  subito **senza compilare**. La riga si rifiuta di partire in tutti e due i
  casi.
- **Il round COMPILA 20 EA VIVI** sul terminale collegato al conto vero. Per
  ognuno il `.mq5` **e** il `.ex5` vanno in un **backup datato**
  (`.prima_r103_<stamp>`), e **se la compilazione fallisce il `.mq5` viene
  rimesso com'era**. Si compila **una volta per EA**, non una per sedia.
- **Nessuna sedia viva viene toccata.** Magic **vergini** del blocco `76xxxx` —
  verificato **magic per magic, tutti e 120**: zero occorrenze nel repo. Sono
  **vietati e controllati nel codice** tutti i magic vivi del `.chr` del 23/08 e
  i blocchi già spesi `7799xx` (R99), `78xxxx` (R100), `79xxxx` (R102),
  `7732xx/7733xx` (R101) e **`750xxx` (R104)**.
- **Niente tick, e non si tocca `bases\<server>\ticks`.** Modello **OHLC M1**
  per criterio, su tutte e 40.
  👉 **Il DD è un LIMITE INFERIORE del rischio. Il PROFITTO è una STIMA DEL
  LORDO** (spread corrente, zero slippage): **non è un guadagno.**
- **🔴 IL COLLO DI BOTTIGLIA È LO SCARICO DELLE BARRE M1** — **17 simboli**, ma
  qui è **4 volte più leggero di R102** (6,5 anni invece di 27) e i simboli già
  a disco (`GBPUSD` `EURUSD` `AUDUSD` `D30EUR` `U30USD`…) **restano**.
- **Durata [STIMA]: 1,5-4 ore di tester** per tutte e 40 (~567 anni-sedia contro
  gli ~886 di R100, stimato 2-6 ore) **più** lo scarico. `-OreMax` è **12** ed è
  un tetto sull'**inizio** di nuovi lavori, non un'interruzione.
- **🔧 PRIMA DI TUTTO, UNA VOLTA SOLA, A MANO SU MT5**: Strumenti → Opzioni →
  Grafici → **"Max barre nel grafico" = Illimitato**. Il driver scrive
  `[Charts] MaxBars=2000000000` nei suoi `.ini`, ma il tetto delle **100.000
  barre** misurato il 17/08 è quello che accorcia le finestre senza dirlo.

---

## 1️⃣ PRIMA il giro a vuoto (pochi minuti, nessuna passata di test)

> ⚠️ **Non è a costo zero sul terminale**: scarica gli artefatti al pin (40 file
> prova, 20 `.mq5`, l'include, `CONTRATTI_SEDIE.md`) e **installa
> `ABTG_PausaGuardian.mqh`**. Quello che **non** fa: non ricompila, non apre MT5
> per testare, non svuota la cache, non cancella niente. **Zero passate, zero
> CSV, zero numeri.**

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='040f0cb4465a83b28849fe0408fc97a4b82f5d11'; $p="$env:USERPROFILE\RIGA_R103.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R103_CLASSIFICA_FLOTTA.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R103_v2' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Cosa deve dire** (altrimenti la corsa vera non parte):

- in testa: `sedie .... 40 su 40   (FOREX+METALLI 25, INDICI 15)`,
  `simboli distinti .... 17`, `passate per sedia .... 3`,
  `passate TOTALI .... 120 (meno 2 per ogni sedia senza OPTFRAME)`;
- `include installato: ABTG_PausaGuardian.mqh`;
- per **ognuna** delle 40 sedie, tre righe verdi:
  - `file prova: NN righe vive (NN parametri + 3 direttive), <SIMB> <TF> dal <data>, rischio X%, asse Y = InpMagic 7600N0/7600N1`
  - `<EA>.mq5 al pin, version V (magic sorgente NNNNNN [magic VIVO della sedia: MMMMMM], include Guardian, strumento OPTFRAME)`
  - `DD promesso ESTRATTO: …` **oppure** `DD promesso: DD PROMESSO AMBIGUO (…)`
    — **9 sedie escono AMBIGUE, ed è ATTESO e dichiarato** (criteri §4.3);
- in fondo: **nessun PROBLEMA in elenco** e `ESITO: GIRO A VUOTO COMPLETATO`.

**Le righe vive attese, sedia per sedia** (se una non torna, l'artefatto è
cambiato e la riga si ferma da sola):

| id | EA | simbolo | TF | gruppo | rischio | righe vive | param. | magic gemelle |
|---|---|---|---|---|---:|---:|---:|---|
| F01 | `ABTG_BreakingBand` | GBPUSD | H1 | FOREX | 1,0% | 74 | 71 | 760020 / 760021 |
| F02 | `ABTG_BreakingBand` | EURUSD | H1 | FOREX | 1,0% | 74 | 71 | 760030 / 760031 |
| F03 | `ABTG_BreakingBand` | AUDUSD | H1 | FOREX | 1,0% | 74 | 71 | 760040 / 760041 |
| F04 | `ABTG_CostToCost` | EURJPY | **H4** | FOREX | 1,0% | 20 | 17 | 760050 / 760051 |
| F05 | `ABTG_CostToCost` | GBPCAD | **H4** | FOREX | 1,0% | 20 | 17 | 760060 / 760061 |
| F06 | `ABTG_CostToCost` | XAGUSD | **H4** | FOREX | 1,0% | 20 | 17 | 760070 / 760071 |
| F07 | `ABTG_EasyTrend` | CHFJPY | H1 | FOREX | 1,0% | 30 | 27 | 760080 / 760081 |
| F08 | `ABTG_EasyTrend` | GBPUSD | H1 | FOREX | 1,0% | 30 | 27 | 760090 / 760091 |
| F09 | `ABTG_EasyTrend` | AUDJPY | H1 | FOREX | 1,0% | 30 | 27 | 760100 / 760101 |
| F10 | `ABTG_GapFill` | GBPUSD | H1 | FOREX | 1,0% | 19 | 16 | 760110 / 760111 |
| F11 | `ABTG_GapFill` | EURUSD | H1 | FOREX | 1,0% | 19 | 16 | 760120 / 760121 |
| F12 | `ABTG_GapFill` | AUDUSD | H1 | FOREX | 1,0% | 19 | 16 | 760130 / 760131 |
| F13 | `ABTG_PTE` | GBPUSD | H1 | FOREX | **0,5%** | 47 | 44 | 760140 / 760141 |
| F14 | `ABTG_PTE` | GBPUSD | H1 | FOREX | **0,5%** | 47 | 44 | 760150 / 760151 |
| F15 | `ABTG_PTE` | USDJPY | H1 | FOREX | 1,0% | 47 | 44 | 760160 / 760161 |
| F16 | `ABTG_PunteLarry` | EURAUD | H1 | FOREX | 1,0% | 23 | 20 | 760170 / 760171 |
| F17 | `ABTG_PunteLarry` | EURCAD | H1 | FOREX | 1,0% | 23 | 20 | 760180 / 760181 |
| F18 | `ABTG_PunteLarry` | GBPJPY | H1 | FOREX | 1,0% | 23 | 20 | 760190 / 760191 |
| F19 | `ABTG_PunteLarry` | GBPUSD | H1 | FOREX | 1,0% | 23 | 20 | 760200 / 760201 |
| F20 | `ABTG_PunteLarry` | XAUUSD | H1 | FOREX | **0,3%** | 23 | 20 | 760210 / 760211 |
| F21 | `ABTG_SuperWave` | GBPUSD | **H4** | FOREX | 1,0% | 47 | 44 | 760220 / 760221 |
| F22 | `ABTG_EMA200_Ottimizzato` | XAUUSD | H4 | FOREX | **0,25%** | 46 | 43 | 760230 / 760231 |
| F23 | `ABTG_MaxMinNotte` | XAUUSD | **H2** | FOREX | **0,5%** | 55 | 52 | 760240 / 760241 |
| F24 | `ABTG_SupertrendReversal_Ottimizzato` | XAUUSD | H4 | FOREX | 1,0% | 45 | 42 | 760250 / 760251 |
| F25 | `Gold_Ichimoku_TK_ATR_EA` | XAUUSD | H1 | FOREX | **0,5%** | 27 | 24 | 760260 / 760261 🔴 **nel file prova, ma NON girano** (vedi sotto) |
| I01 | `ABTG_DAX_Apertura_EU` | D30EUR | M5 | INDICI | **0,65%** | 85 | 82 | 760270 / 760271 |
| I02 | `ABTG_Dow_Apertura_US` | U30USD | M5 | INDICI | **0,65%** | 84 | 81 | 760280 / 760281 |
| I03 | `ABTG_EMA200` | U30USD | H1 | INDICI | 1,0% | 46 | 43 | 760290 / 760291 |
| I04 | `ABTG_GapFill` | U30USD | H1 | INDICI | 1,0% | 19 | 16 | 760300 / 760301 |
| I05 | `ABTG_GapFill` | 225JPY | H1 | INDICI | 1,0% | 19 | 16 | 760310 / 760311 |
| I06 | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` | D30EUR | M15 | INDICI | **0,65%** | 55 | 52 | 760320 / 760321 |
| I07 | `ABTG_ORB_Ottimizzato` | U30USD | M5 | INDICI | **0,3%** | 56 | 53 | 760330 / 760331 |
| I08 | `ABTG_PTE` | U30USD | H1 | INDICI | 1,0% | 47 | 44 | 760340 / 760341 |
| I09 | `ABTG_PunteLarry` | U30USD | H1 | INDICI | 1,0% | 23 | 20 | 760350 / 760351 |
| I10 | `ABTG_SupRev_DAX_H4_Ottimizzato` | D30EUR | H4 | INDICI | 1,0% | 45 | 42 | 760360 / 760361 |
| I11 | `ABTG_SupRev_NAS_H1_Ottimizzato` | NASUSD | H1 | INDICI | 1,0% | 45 | 42 | 760370 / 760371 |
| I12 | `ABTG_SuperWave` | U30USD | **H4** | INDICI | 1,0% | 47 | 44 | 760380 / 760381 |
| I13 | `ABTG_SuperWave_DOW_H1_Ottimizzato` | U30USD | H1 | INDICI | 1,0% | 47 | 44 | 760390 / 760391 |
| I14 | `ABTG_SupertrendReversal` | 225JPY | **H2** | INDICI | **0,65%** | 47 | 44 | 760400 / 760401 |
| I15 | `ABTG_SupertrendReversal` | 225JPY | H4 | INDICI | 1,0% | 47 | 44 | 760410 / 760411 |

> 🔴 **F25 `Gold_Ichimoku` È DIVERSA DALLE ALTRE 39, e va saputo prima.**
> Misurato nel sorgente: **niente `OnTesterDeinit`** (quindi **nessun
> `OptResults`**), niente `InpComment`, niente `InpVerbose`, **nessuna riga di
> log d'ingresso**. Quindi: gira **solo la passata singola**, i suoi numeri
> (n, netto, PF, spina dorsale, peggior giornata) escono **dai DEAL del report
> `.htm`**, e la colonna **DD dell'equity resta NON MISURATA** — al suo posto il
> referto stampa un **DD sul saldo chiuso**, che è un'altra cosa e lo dice.
> **Non è un difetto della sedia: non è un EA della famiglia ABTG.**

> ⚠️ **Quello che il giro a vuoto NON può fare, detto prima.**
> **`-SoloControllo` non apre MT5**, quindi **non esiste nessun numero**: niente
> profitto, niente PF, niente DD, niente peggior giornata, **niente spina
> dorsale**, niente `n`, **niente classifica**. Può confermare gli **artefatti**
> (file prova, celle, `.ini`, magic, DD promessi estratti), **mai i numeri**.
> Sta scritto anche **dentro il suo referto**, perché nessuno lo scambi per il
> round (checklist 57).

---

## 2️⃣ POI la corsa vera — **A BLOCCHI, e gli INDICI per primi**

🔴 **Non è un ripiego: è il modo previsto.** Gli elenchi vanno **FRA APICI**:
`'F01,F02,F03'` — senza apici PowerShell li spezza in array e li reincolla con
gli spazi (checklist 65; il driver accetta entrambe le forme, ma gli apici
restano la regola).

### 🥇 BLOCCO 1 — **TUTTO IL GRUPPO INDICI** (21 mesi: è il pezzo veloce)

15 sedie su una finestra di 21 mesi ≈ **79 anni-sedia**: è la parte che torna
per prima, e riempie **subito** la seconda tabella.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='040f0cb4465a83b28849fe0408fc97a4b82f5d11'; $p="$env:USERPROFILE\RIGA_R103.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R103_CLASSIFICA_FLOTTA.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R103_v2' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloGruppo 'INDICI';
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

### 🥈 POI il gruppo FOREX+METALLI, **famiglia per famiglia**

Si cambia **SOLO l'elenco dopo `-SoloSedia`** (e si toglie `-SoloGruppo`).
**Ogni blocco compila UN SOLO sorgente**, dove è possibile:

| blocco | `-SoloSedia` | EA compilato | perché insieme |
|---|---|---|---|
| 2 | `'F01,F02,F03'` | `ABTG_BreakingBand` | una famiglia, tre simboli |
| 3 | `'F10,F11,F12'` | `ABTG_GapFill` | motore veloce, poche operazioni |
| 4 | `'F04,F05,F06'` | `ABTG_CostToCost` | H4: più veloce |
| 5 | `'F16,F17,F18,F19,F20'` | `ABTG_PunteLarry` | le cinque Larry (una è l'oro) |
| 6 | `'F07,F08,F09'` | `ABTG_EasyTrend` | |
| 7 | `'F13,F14,F15'` | `ABTG_PTE` | ⚠️ F13 e F14 sono **lo stesso EA sullo stesso simbolo**: girano in fila, mai in parallelo |
| 8 | `'F21'` | `ABTG_SuperWave` | grafico H4, `InpTF` H2 |
| 9 | `'F22,F23,F24,F25'` | **4 EA diversi** | 🟡 qui la regola "un sorgente per blocco" **non si può rispettare**: sono quattro sedie oro uniche. Vantaggio: **un solo simbolo** da scaricare (XAUUSD) |

**Oppure**, se Claudio preferisce lasciarla girare tutta la notte: **si toglie
`-SoloSedia` e `-SoloGruppo`** e girano tutte e 40.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='040f0cb4465a83b28849fe0408fc97a4b82f5d11'; $p="$env:USERPROFILE\RIGA_R103.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R103_CLASSIFICA_FLOTTA.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R103_v2' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloSedia 'F01,F02,F03';
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**, è un comando solo (checklist 21): tre righe
staccate sarebbero tre comandi indipendenti e un `throw` alla prima non
fermerebbe le altre.

> ⚠️ **Perché qui il messaggio è GIALLO e nel giro a vuoto è ROSSO.** Nella
> corsa vera `exit 1` può voler dire *"la corsa è riuscita e la risposta non ti
> piace"* (una finestra accorciata, una sedia con n=0): gli artefatti
> **esistono** e vanno mandati lo stesso — un `throw` qui butterebbe via una
> risposta buona (checklist 26-bis). Nel giro a vuoto `exit 1` vuol dire una
> cosa sola: **non si lancia niente.**

⚠️ **Ogni blocco scrive una cartella e uno zip SUOI sul Desktop, e il referto lo
dichiara**: *"un blocco NON è il round"*. **Vanno mandati TUTTI**, non solo
l'ultimo.

### 🔁 Se una corsa si interrompe

Qui **non c'è niente da saltare**: ogni sedia ha **una finestra sola**, e un
rilancio liscio la rifà tutta. 👉 **La ripresa che costa poco è `-SoloSedia` con
l'elenco (fra apici) delle sedie il cui `esito` nel referto non è `OK`**, oppure
`-SoloGruppo` per rifare un gruppo intero.

### 🟡 E se Claudio vuole gli indici a **TICK REALI** — è la decisione [DA FIRMARE]

Sulla finestra degli indici i **tick reali esistono** (BCM li ha dal
2024.07.05) e **R101 li ha usati**. R103 gira in **OHLC** perché è quello che
dice la proposta firmata — ma il costo è **misurato**: il 30/07 la revalidation
a tick reali ha ribaltato `SupRev_DOW_H4` da **PF 2,77 (OHLC)** a **PF 0,79**.

Se Claudio firma, si rilancia **il solo gruppo indici** cambiando **una cosa
sola**, e **senza cambiare il pin**:

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='040f0cb4465a83b28849fe0408fc97a4b82f5d11'; $p="$env:USERPROFILE\RIGA_R103.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R103_CLASSIFICA_FLOTTA.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R103_v2' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloGruppo 'INDICI' -TickReali;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

La cartella si chiamerà `..._CORSA_TICKREALI_...` e i CSV avranno il suffisso
`_tick` invece di `_ohlc`: **un OHLC e un tick reale non devono nemmeno poter
finire nella stessa tabella.** ⚠️ E quelle righe **non si confrontano** con
quelle della corsa OHLC: è un altro banco.

---

### 📅 LE DUE RIGHE DA LEGGERE NEL REFERTO PRIMA DI MANDARE LO ZIP

Aprire `REFERTO_R103.txt` e guardare **due righe in testa**, in quest'ordine:

1. **`modo:`** — dice `CORSA` (il round), `CORSA_TICKREALI`, oppure `CONTROLLO`
   (giro a vuoto: **non è il round, non si manda come risultato**);
2. **`data:`** — **deve essere di ADESSO**. Se è di ieri è un referto
   **stantio**: si guarda il **nome della cartella** sul Desktop (porta data e
   ora) e si rifà.

E subito sotto, **`switch di questo giro:`** — dice se c'era `-SoloSedia` o
`-SoloGruppo`, cioè **se è un blocco e non il round**.

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul Desktop: `R103_CLASSIFICA_FLOTTA_<MODO>_<data>_<ora>` —
dentro:

- **`REFERTO_R103.txt`** ← **è questo che conta**. In testa: come si legge il
  referto; poi **LE DUE TABELLE** (FOREX 6,5 anni · INDICI 21 mesi), **ordinate
  su `PROF-1%`**; poi **sedia per sedia** i numeri, **la spina dorsale periodo
  per periodo**, la seconda misura dai deal, i cinque gate e il contratto;
- gli `.ini` di **ogni** passata (quelli VERI, gli stessi del giro a vuoto);
- gli `OptResults` di ogni sedia (`R103_*_ohlc.csv`);
- i **report `.htm`** delle passate singole e i **dump delle righe d'ingresso**:
  sono la prova cartacea dei gate **e la fonte della spina dorsale**;
- i log di compilazione di ogni EA e i referti storici per simbolo;
- `CONTRATTI_SEDIE_al_pin.md`, cioè **il documento da cui è stato letto ogni DD
  promesso**.

---

## 🚩 LE COSE DA GUARDARE PER PRIME NEL REFERTO

1. 🏆 **LE DUE TABELLE, e la colonna su cui sono ORDINATE**: `PROF-1%`, cioè il
   **profitto normalizzato a rischio 1%**. ⚠️ **Non `PROF-VIVO`**: in euro
   "come stanno" vincerebbe la **taglia**, non il **motore**.
2. 🦴 **LA COLONNA `NEG/OPER`** — *"periodi in perdita / periodi operati"*. **È
   la risposta letterale alla domanda di Claudio.** E si guarda il
   **denominatore**: *"1 su 6"* e *"1 su 4, più 2 senza nessuna operazione"*
   sono due frasi diverse.
3. 🦴 **LA SPINA DORSALE** sotto ogni sedia: **anno per anno** (FOREX) o
   **trimestre per trimestre** (INDICI), con la riga **`<<< NEGATIVO`** su
   quelle in perdita e **`<<< NESSUNA OPERAZIONE`** su quelle vuote.
4. 🔴 **L'etichetta sopra la TABELLA 2**: *"21 mesi, UN solo regime, NON
   confrontabile"*. Le due tabelle **non si sommano e non si mescolano**.
5. **`DD-1%` contro `DD-PROM`.** Se il primo supera il secondo è un **RILIEVO da
   portare a Claudio**, **non** una revisione automatica: il DD promesso è stato
   misurato su **un'altra finestra**.
6. **La colonna `n` e l'etichetta `CAMPIONE SOTTILE`** (sotto 30 operazioni):
   lì il **profitto non si legge come merito**, ma **il DD e la peggior
   giornata sì** (valvola R59).
7. **I `GEMELLI`.** Se divergono, di quella sedia **non si legge niente**: banco
   sporco.
8. **La `FINESTRA` di ogni sedia.** Se è `ACCORCIATA`, quella riga va scritta
   **accanto a ogni numero** di quella sedia.

---

## 🔴 LE CINQUE COSE CHE R103 **NON** DICE

1. **NON promuove e NON boccia nessuno.** Non c'è **nessun verdetto meccanico**
   in questo round: è una **misura**. Le uscite restano quelle della **C3 del
   18/08**, che girano sul **FORWARD**.
2. **Il profitto NON è un guadagno.** È una **stima del lordo**: spread
   corrente, zero slippage, riempimenti ideali.
   ⚠️ **E sugli INDICI l'OHLC ha già mentito, ed è MISURATO** (PF 2,77 → 0,79).
3. **NESSUN DRAWDOWN DI PORTAFOGLIO.** 40 sedie non fanno un DD pari alla somma
   né pari al massimo: dipende da **quanto si sovrappongono**. ⚠️ E qui morde:
   **7 sedie su GBPUSD** e **8 su U30USD**. È la domanda successiva ovvia, ed è
   un round diverso.
4. **NIENTE SULLA CELLA MIGLIORE.** Una cella per sedia, quella **VIVA**. Se una
   esce male, la risposta **non** è "proviamo un'altra cella": sarebbe pescare.
5. **NIENTE SUL FORWARD.** Un backtest non è un forward.

> 🔴 **E le sedie che NON sono nelle 40** (il referto le ristampa, perché non si
> perdano):
> - **`BREAKOUT_EA_JPY_v3`** USDJPY — **il sorgente non esiste nel repo**,
>   nessun rischio leggibile, **nessun contratto**. **Rilievo aperto dal 18/08.**
> - **`ABTG_GapContinuation`** 225JPY (774101) — un contratto ce l'ha (DD
>   promesso 11,59%), ma nel `.chr` del 23/08 **non ha un rischio leggibile**:
>   senza taglia viva non esistono né la colonna in euro né quella normalizzata.
>   **Si chiude con un `.chr` che la legga.**
> - **`ABTG_Guardian`** e **`ABTG_TradeExporter`**: utility, non tradano.

---

## ✅ COSA È GIÀ STATO VERIFICATO — **eseguendo**, prima dell'invio

Checklist punto **63** (*"il parse si FA, non si dichiara impossibile"*):

- ✅ il `.ps1` **parsa**: `/opt/pwsh/pwsh` + `[Parser]::ParseFile` → **0 errori**;
- ✅ il `.ps1` è **ASCII puro**: `grep -P '[^\x00-\x7F]'` → **0 righe**;
- ✅ **40/40** file prova passano i **gate veri** del driver (righe vive,
  parametri, `@SIMBOLO`/`@PERIODO`/`@DAQUANDO`, rischio, commento **dove
  l'EA ce l'ha**, coppia gemella, magic vietati, un solo asse `Y`, **nessun
  default non risolto**);
- ✅ **40/40** le due **fabbriche di `.ini`** (SINGOLA + GEMELLE) scrivono e
  passano i loro gate;
- ✅ **40/40** version, magic di sorgente, include Guardian, `OnTesterDeinit`
  (o la sua assenza dichiarata), `MarkSrc` — **letti nei sorgenti veri**;
- ✅ **39/39 marcatori di log** (13 marcatori distinti) provati sul campione
  **POSITIVO** *e* su due
  **NEGATIVI** (riga di servizio dello stesso EA + riga di un altro EA);
- ✅ `LeggiDeal` su report `.htm` sintetici **con e senza** la colonna
  `Commento` in coda (checklist 58): stesso risultato, netto **−900 / +1500**,
  saldo `100 600.00` **con lo spazio** letto giusto;
- ✅ la **spina dorsale**: **7 anni**, **8 trimestri**, **22 mesi**, e gli anni
  **vuoti fuori dal denominatore** (*"2 negativi su 4 operati"*, non "su 7");
- ✅ `DDPromesso` sul `CONTRATTI_SEDIE.md` **vero**, tutte e 40: **31 estratti,
  9 ambigui (attesi e elencati nei criteri), 0 mancanti**;
- ✅ `-SoloSedia` con **virgole** *e* con **spazi** (checklist 65),
  `-SoloGruppo`, e la lista di **UNO** (checklist 62);
- ✅ i numeri sotto **cultura it-IT** — 🐛 **e questa prova ha trovato un difetto
  vero**: la colonna `PF` usciva **`1,3`** con la virgola. Corretta con una
  formattazione **invariante esplicita**;
- ✅ le celle di **I01/I02** confrontate **input per input** col metro **già
  validato di R101**: **coincidono** (differiscono solo taglia e magic, come
  dichiarato);
- ✅ i **120 magic** `76xxxx`: **zero occorrenze** in tutto il repo.

🟡 **Non verificato, e va detto**: tutto ciò che richiede **MT5** — la
compilazione vera dei 20 EA, la durata reale, l'intestazione italiana del report
`.htm` del terminale di Claudio, il comportamento del tester sui simboli indice.
**Il giro a vuoto copre gli artefatti; i numeri li può dare solo la corsa.**
