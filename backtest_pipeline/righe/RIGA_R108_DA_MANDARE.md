# 📬 R108 — **LA RIGA DA MANDARE** (Breaking Band su **M15**: GBPUSD · EURUSD · AUDUSD)

**Round**: R108 — **IL BREAKING BAND REGGE A M15?**, cioè il ramo che la nostra
fonte del motore dichiara operativo (`prove/BREAKING_BAND_TESI.md` riga 17:
_"TF: dimostrata su tutti; operativita' M5/M15"_) e che **non abbiamo mai
misurato**: `R33`, `R94`, `R102` e `R103` hanno **tutti** `InpTF=16385` (H1).
**Dossier**: `caccia_strategie/CACCIA_M5M15_FOREX_ORO_2026-08-25.md` (promosso **P1**).
**Criteri**: `risultati_archivio/R108_CRITERI.md` — ⚠️ **[DA FIRMARE]**, 6 decisioni.
**Driver**: `righe/RIGA_R108_BB_M15.ps1` (marcatore `MARCATORE_RIGA_R108_v1`).
**File prova**: `prove/R108_GBPUSD_00_metroH1.txt`, `R108_GBPUSD_01_m15.txt`,
`R108_EURUSD_00_metroH1.txt`, `R108_EURUSD_01_m15.txt`,
`R108_AUDUSD_00_metroH1.txt`, `R108_AUDUSD_01_m15.txt` — **sei**.

> ⚠️ **Questo foglio NON è ancora la riga da dettare.** Passa dal
> verificatore-stringhe prima di arrivare a Claudio: il pin qui sotto è
> **proposto**, non confermato.

---

## ❓ LA DOMANDA — è di Claudio, ed è del 25/08

> _"Dobbiamo avere più strategie su TF 5 min e 15 min. Ci servono per la challenge."_

**Il round misura una cosa sola: IL TIMEFRAME.** Per ogni simbolo gira la cella
viva a H1 e **la stessa identica cella a M15**. Fra i due file la differenza è
**letteralmente una riga** (`InpTF`), più `InpMagic`.

**Costo di sviluppo: ZERO righe di MQL5.** `InpTF` è già un `input` del sorgente
(riga 213) — è il motivo per cui il cacciatore l'ha messo primo.

---

## 🔴 DUE DIFETTI TROVATI NEL FILE PROVA DEL CACCIATORE, prima di costruirci sopra

Il file `prove/R108_BB_M15_FOREX.txt` era dato per pronto (`controlla_prova.py`
ESITO OK). **`controlla_prova.py` fa controlli sintattici, non conosce la storia
del repo.** I due difetti gli sono passati sotto il naso, ed erano **entrambi
fatali per il significato del round**:

| | difetto | come è stato trovato |
|---|---|---|
| **1** | `InpMagic 760030/760031` dichiarato *"serie VERGINE"*. **È la coppia con cui R103 ha girato BreakingBand su EURUSD** | `grep -rno '7600[0-9][0-9]'` su tutto il repo → **9 occorrenze** di `760030` |
| **2** | `InpPatternMode=2` per tutti e tre, con la frase _"la stessa identica cella"_. **Le tre celle vive di R103 hanno pattern DIVERSI**: GBPUSD **2**, EURUSD **0** (solo CONT), AUDUSD **1** (solo INV) | `diff` fra i tre file prova di R103 |

⚠️ **Il difetto 2 è quello che avrebbe fatto più danno, ed è invisibile a
occhio**: su due simboli su tre il round non avrebbe misurato *"lo stesso motore
a M15"*, avrebbe misurato **UN ALTRO MOTORE**. La tabella sarebbe uscita
perfetta e non avrebbe risposto alla domanda.

📌 **E mancava il METRO.** Senza una cella che riproduce R103, *"M15 va male"* e
*"il banco è storto"* sono **indistinguibili**. R108 aggiunge tre celle H1
apposta. Il file del cacciatore resta in repo **come antenato**, con i due
difetti scritti nella sua testa invece che cancellati.

---

## 🔴 IL CANCELLO DELLA FIRMA — **è CHIUSO, e va aperto da Claudio**

`R108_CRITERI.md` porta `[DA FIRMARE]` nel titolo. Il driver **lo legge al pin**:

- il **giro a vuoto parte lo stesso** (non apre MT5, non produce nessun numero);
- la **corsa vera si ferma con `exit 2`**, a meno di `-CriteriFirmati`.

**Le sei decisioni** (§ 10 dei criteri, tutte con la proposta già scritta):

| | decisione | ✅ proposta |
|---|---|---|
| **D1** | il **metro G0** gira a **modello 1 (OHLC M1)**, come R103? | **SÌ** — un metro a tick reali non riprodurrebbe mai quel numero e **boccerebbe un banco sano** |
| **D2** | la **profondità dei TICK** su GBPUSD/EURUSD/AUDUSD **non è misurata in tutto il repo** (esiste solo `U30USD`) | **SI MISURA PRIMA.** A modello 4 senza tick reali MT5 **non si ferma**: ripiega e produce numeri **plausibili e falsi**, e **nessuna guardia del driver può accorgersene** |
| **D3** | divisione **IS/OOS** della cella M15 | **2 anni + 2 anni** (non il 40/60): col 40/60 l'IS varrebbe ~125 operazioni attese, cioè **sotto soglia per costruzione** |
| **D4** | lo **spread di riferimento** di S0a | **1,5 pip DICHIARATO**, con `[SPREAD NON MISURATO]` stampato accanto a ogni verdetto |
| **D5** | se **S0 o G0 falliscono su un simbolo solo** | **quel simbolo si chiude, gli altri proseguono** |
| **D6** | **M5 in R108?** | **NO** — col tetto di ~1,3 anni è **non giudicabile per costruzione** |

> 🚦 **E RESTA IL CANCELLO DEL TRAFFICO: una macchina, un lavoro.** Il PC di
> backtest ha un solo MT5. R108 parte **solo quando nessun altro round sta
> toccando il terminale**. ⚠️ **E questo round è lungo**: 18 delle 30 passate
> sono a **tick reali su 4 anni di M15**.

---

## 📌 IL PIN PROPOSTO — **`3d5a3a84134465edcbafe8d276d28b6813dd2772`**

```
3d5a3a84134465edcbafe8d276d28b6813dd2772
```

✅ **Verificato eseguendo** che quel commit contiene **tutti e dieci** gli
artefatti che il driver scarica: il driver, i **sei** file prova, i criteri, il
sorgente `ABTG_BreakingBand.mq5` e l'include `ABTG_PausaGuardian.mqh`
(`git cat-file -e <sha>:<file>` su ognuno).

⚠️ **Questo foglio è stato committato DOPO il pin, e va bene**: il driver non lo
scarica. Ma **il pin si rilegge DOPO il push, non prima** (checklist 6 e 55): se
il verificatore corregge una riga del driver, dei file prova o dei criteri,
**questo blocco va ripinnato e questa pagina riscritta**.

La riga passa il pin a `-Pin` e **si rifiuta di partire senza**: un default
silenzioso (`lavoro`) farebbe girare la punta del branch spacciandola per un
commit congelato.

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** Col terminale aperto il tester non
  gira (zero CSV); con MetaEditor aperto la compilazione torna subito **senza
  compilare**. La riga si rifiuta di partire in tutti e due i casi.
- **NESSUNA SEDIA VIVA VIENE TOCCATA.** Magic **vergini, blocco `762xxx`**
  (verificato libero in tutto il repo il 25/08). Sono **vietati e controllati nel
  codice** i magic delle sedie vive **e quelli di R103** — cioè `760020/760030/
  760040`, che sono **proprio le tre BreakingBand di questo round**.
- **30 passate**: per ogni simbolo la cella metro fa **3** lanci (1 passata
  singola + 2 gemelle) e la cella M15 ne fa **7** (1 singola + 2 gemelle sulla
  finestra intera + 2 IS + 2 OOS).
- **Due modelli, e non è una svista**: metro H1 a **modello 1 (OHLC M1)** perché
  R103 è girato così; M15 a **modello 4 (TICK REALI)** perché è il giudizio.
- **Zero parametri spazzolati.** L'unico asse con flag `Y` è `InpMagic`, e il
  driver **si ferma** se in un file ne trova un secondo.
- **Il round non scarica storico** e non tocca `bases\<server>\ticks`.
- 🔧 **Se non è già stato fatto**: MT5 → Strumenti → Opzioni → Grafici →
  **"Max barre nel grafico" = Illimitato**. Il driver scrive comunque
  `[Charts] MaxBars=2000000000` nei suoi `.ini`, ma **[INFERITO], non misurato**,
  che il tester lo onori.
- ⏱️ **Durata [STIMA, non una previsione]**: R103 fece 25 sedie in **OHLC** in 36
  minuti; **i tick reali sono un altro ordine di grandezza**. `-OreMax 12` è un
  tetto sull'**inizio** di nuovi lavori, non un'accetta su un lavoro in corso.

---

## 1️⃣ PRIMA il giro a vuoto (pochi minuti, **nessuna passata**)

> ⚠️ **Non è a costo zero sul terminale**: scarica gli artefatti al pin,
> **installa `ABTG_PausaGuardian.mqh`** in `MQL5\Include` e **COMPILA l'EA** (la
> compilazione si fa anche a vuoto, altrimenti il giro non direbbe niente sulla
> compilabilità). Quello che **non** fa: non apre MT5 per testare, non cancella
> nessun artefatto.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='3d5a3a84134465edcbafe8d276d28b6813dd2772'; $p="$env:USERPROFILE\RIGA_R108.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R108_BB_M15.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R108_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

### Cosa deve dire — **le righe sono state PRODOTTE ESEGUENDO e incollate dall'output** (checklist 70)

```
    simboli ......................  3   (AUDUSD, EURUSD, GBPUSD)
    celle ........................  6   (di cui METRO: 3)
    passate ......................  30   (metro 3 = 1 singola + 2 gemelle; M15 7 = 1 + 2 + 2 + 2)
    righe vive per file prova ....  70
    righe per CSV di ottimizz. ...  2   (le due gemelle di controllo)

    METRO H1 : 2020.01.01 -> 2026.06.30   modello 1 (OHLC M1, come R103)
    M15      : 2022.07.01 -> 2026.06.30   modello 4 (TICK REALI)
        IS  2022.07.01 -> 2024.06.30     OOS 2024.07.01 -> 2026.06.30
      GBPUSD : PF 1.199 | DD 7.75% | n 126 | prima op. 2020.01.14   (pattern VIVO 2)
      EURUSD : PF 1.936 | DD 2.51% | n 59 | prima op. 2020.02.03   (pattern VIVO 0)
      AUDUSD : PF 1.541 | DD 2.13% | n 64 | prima op. 2020.02.05   (pattern VIVO 1)
```

> ⚠️ **`(AUDUSD, EURUSD, GBPUSD)` è in ORDINE ALFABETICO, non nell'ordine del
> dossier.** La lista è costruita con `Sort-Object -Unique`, che **ordina**.
> Il driver lo dice da solo a schermo, due righe sotto. **Un falso allarme qui
> costa un giro** — è il punto **70** della checklist, pagato su R107.

E poi, in ordine:

- `criteri: NON FIRMATI (il file porta ancora [DA FIRMARE])` — **è giusto così
  finché non firmi**, e il giro a vuoto prosegue lo stesso;
- `6 file prova scaricati al pin, 70 righe di input ciascuno`;
- `gate della STELLA: ogni cella M15 differisce dalla sua cella metro SOLO su InpTF`;
- `valori, pattern VIVO, TF del grafico, asse unico e 42 magic vergini verificati NEI FILE`;
- `ABTG_BreakingBand.mq5 al pin, version 1.03, InpTF e' un input libero`;
- **tre righe `profondita' TICK <simbolo>:`** — ⚠️ **oggi diranno `NON MISURATA`,
  ed è la decisione D2**: non è un guasto del driver, è un buco vero del repo;
- `include installato: ABTG_PausaGuardian.mqh (... byte)`;
- `COMPILATO ABTG_BreakingBand v1.03 (.ex5 riscritto adesso, rc=0)`;
- in fondo: `.ini scritti e verificati: 18 su 18` e
  `ESITO: GIRO A VUOTO COMPLETATO`.

> ⚠️ **Quello che il giro a vuoto NON può fare, detto prima.** `-SoloControllo`
> **non apre MT5**: non esiste nessun `n`, nessun PF, nessun DD, **nessun G0 e
> NESSUN cancello zero S0**. Conferma gli **artefatti**, mai i numeri. Sta
> scritto anche **dentro il suo referto**, perché nessuno lo scambi per il round.

---

## 2️⃣ POI la corsa vera — **solo dopo aver firmato le sei decisioni**

Se hai tolto il `[DA FIRMARE]` dal file dei criteri, il gate si apre da solo e
`-CriteriFirmati` non serve. Se preferisci **firmare in riga**, aggiungilo: la
firma finisce **scritta nel referto**.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='3d5a3a84134465edcbafe8d276d28b6813dd2772'; $p="$env:USERPROFILE\RIGA_R108.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R108_BB_M15.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R108_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -CriteriFirmati;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**: è **un comando solo** (checklist 21). Tre righe
staccate sarebbero tre comandi indipendenti, e un `throw` alla prima non
fermerebbe le altre.

> ⚠️ **Perché qui il messaggio è GIALLO e nel giro a vuoto è ROSSO.** Nella corsa
> vera `exit 1` può voler dire _"la corsa è riuscita e la risposta non ti
> piace"_ — per esempio **un cancello zero S0a FALLITO, che è LA RISPOSTA del
> round e non un guasto**. Gli artefatti **esistono** e vanno mandati lo stesso.

### 🔁 Se serve riprendere

> ⚠️ **Ogni riga di ripresa è un BLOCCO INTERO, con il suo `irm` e la sua
> guardia** (checklist **42**). `$p` e `$pin` nascono **dentro** il `& { ... }`
> del blocco qui sopra, che è uno **scope figlio**: quando quel blocco finisce
> **non esistono più**. Una riga `& $p -Pin $pin ...` incollata da sola in una
> console nuova muore; e — peggio — incollata in una console **ancora calda**
> funziona, ma riusa la **copia locale già scaricata** e il **pin di prima**
> (è il difetto del 10/08).

**Un simbolo solo** (qui GBPUSD, quello col campione più grosso a H1):

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='3d5a3a84134465edcbafe8d276d28b6813dd2772'; $p="$env:USERPROFILE\RIGA_R108.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R108_BB_M15.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R108_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -CriteriFirmati -SoloSimbolo 'GBPUSD';
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

**Due simboli** — ⚠️ **l'elenco va FRA APICI** (checklist 65: senza, la virgola
fa un **array** e il binder lo unisce con uno spazio):

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='3d5a3a84134465edcbafe8d276d28b6813dd2772'; $p="$env:USERPROFILE\RIGA_R108.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R108_BB_M15.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R108_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -CriteriFirmati -SoloSimbolo 'EURUSD,AUDUSD';
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

**Una cella sola** (la cella METRO del suo simbolo rigira lo stesso):

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='3d5a3a84134465edcbafe8d276d28b6813dd2772'; $p="$env:USERPROFILE\RIGA_R108.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R108_BB_M15.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R108_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -CriteriFirmati -SoloCella 'R108_GBPUSD_01_m15.txt';
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

In **tutti** i casi la **cella METRO del simbolo rigira**: è la prova che il
banco è sano, e senza non si legge niente. Costa 3 passate, non una corsa
sprecata.

### 🩺 E se il tempo dei tick reali fosse proibitivo: lo SCREEN veloce

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='3d5a3a84134465edcbafe8d276d28b6813dd2772'; $p="$env:USERPROFILE\RIGA_R108.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R108_BB_M15.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R108_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -CriteriFirmati -ScreenOhlcM15;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

🔴 **E QUESTO GIRO NON PUÒ PRODURRE UN VERDETTO, per costruzione.** Le celle M15
girano in **OHLC M1**, e su M5/M15 **l'OHLC inganna — ed è MISURATO in casa**
(`REGISTRO_TEST.md` §2: _"in OHLC i Live5m davano numeri finti enormi (+129k DAX,
+30k Nasdaq). In real tick: morti."_). Il driver **impone la regola col codice,
non con una nota**: la cartella e lo zip si chiamano `SCREENOHLC`, e **ogni riga
M15 esce marcata `NON GIUDICABILE`**. Al massimo produce **il permesso** di un
giro a tick reali.

---

### 📅 LE DUE RIGHE CHE CLAUDIO DEVE LEGGERE NEL REFERTO, PRIMA DI MANDARE LO ZIP

Aprire `REFERTO_R108.txt` e guardare **due righe in testa**, in quest'ordine:

1. **`modo:`** — dice `CORSA` (il round), `CONTROLLO` (giro a vuoto: **non è il
   round, non si manda come risultato**) o `SCREENOHLC` (**non giudicabile**);
2. **`data:`** — **deve essere di ADESSO**. Se è di ieri è un referto **stantio**:
   si guarda il nome della cartella sul Desktop (porta data e ora) e si rifà.

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul Desktop: `R108_BB_M15_<MODO>_<data>_<ora>` — dentro, **per nome**:

- **`REFERTO_R108.txt`** ← **è questo che conta**;
- **12 CSV** di ottimizzazione (2 righe l'uno: le gemelle di controllo) —
  `ABTG_BreakingBand_<SIMB>_00_metroH1_INTERA.csv` ×3 +
  `..._01_m15_INTERA.csv` ×3 + `..._01_m15_IS.csv` ×3 + `..._01_m15_OOS.csv` ×3;
- **6 report `.htm`** delle passate singole (`<SIMB>_<cella>_report_singola.htm`)
  — ⚠️ **sono la fonte di TUTTO il PASSO 0**: prima operazione, take in pip,
  durata in barre, peggior giornata. Se mancano, il cancello zero non esiste;
- **18 `.ini`**, quelli che hanno girato davvero;
- i **sei file prova al pin**, così lo zip è autosufficiente;
- `compile_BreakingBand.log`;
- i file per-trade `<SIMB>_<cella>_pertrade_singola.csv`, quando l'EA li scrive.

---

## 🚩 LE COSE DA GUARDARE PER PRIME NEL REFERTO

1. 🔬 **I TRE VERDETTI G0.** Devono dire **`RIPRODOTTO`** su tutti e tre — PF, DD,
   `n` **e la prima operazione**. 👉 **Se un metro non torna, quel simbolo si è
   fermato e la sua cella M15 non è nemmeno partita**: non è un round con un
   difetto, è un round che misurerebbe un altro motore.
2. 🚨 **IL CANCELLO ZERO S0a — si legge PRIMA di qualunque PF.** Il take a M15
   copre il costo? ⚠️ **E non è una domanda teorica**: il `DIARIO.md` del
   **20/08** registra **dal vivo** un `BB GBPUSD` uscito in `tp` con **un
   bersaglio da 2,5 pip**, e quello era **H1**. A M15 il bersaglio è circa la
   metà. **Tre stati**: `SUPERATO`, `FALLITO`, e **`SOSPESO`** — quando il
   rapporto cade fra 2,5x e 3,5x il verdetto **non si dà**, perché la soglia
   poggia su uno spread **non misurato**.
3. 📊 **LA FREQUENZA.** L'attesa dichiarata prima era **~155 operazioni per
   finestra**, ed era **[INFERITA]** (126 op in 6,5 anni a H1 × 4 barre). **Se
   `n` esce molto più basso, la frequenza non scala col numero di barre — e
   quello è già un risultato**, perché è la frequenza la ragione per cui questo
   round esiste (challenge).
4. ⏱️ **LA DURATA IN BARRE.** Non è un cancello, è una misura. Se la mediana esce
   **1-3 barre**, va scritto come **allarme sulla robustezza anche a cancelli
   verdi**: `arXiv 2605.04004` §6.2 misura che i soli segnali intraday
   sopravvissuti alla sua falsificazione tengono **12-15 barre**, non 1-6.
5. 🧱 **LA COLONNA `FINESTRA` DEL PASSO 0.** `@DAQUANDO 2022.07.01` è **DERIVATO**
   dal tetto delle 100.000 barre, **non misurato**. Se dice `ACCORCIATA`, la
   finestra reale è più corta di quella nominale e **va riscritta nel referto
   PRIMA di leggere i numeri**.
6. 🎫 **LE TRE RIGHE `profondita' TICK`.** Oggi diranno `NON MISURATA`: **in
   tutto il repo esiste una sola misura dei tick, ed è `U30USD`**. È la
   decisione **D2**, ed è il rischio più concreto del round.
7. 🎚️ **I CANARINI.** `n` sotto **150** → merito **sospeso** (Emendamento regola
   B). Sotto **20** → **NON MISURABILE**, mai *"non funziona"*.

---

## 🔴 LE SEI COSE CHE R108 **NON** DICE

1. **NON promuove e NON boccia niente in forward** (G5). Le tre BreakingBand H1
   restano dove sono. E `FLOTTA_ATTIVA` ha già **concentrazione** su questi
   simboli: una versione M15 non entrerebbe *"in più"*, entrerebbe **accanto o al
   posto** — ed è una decisione di portafoglio, non un risultato di backtest.
2. **NON applica i cancelli di merito.** Produce i numeri; **G2 e G3 li applica
   il referto del round, a mano.** G3 (coerenza cross-simbolo) non è
   meccanizzabile: è un ragionamento su **tre** tabelle. ⚠️ **Un simbolo su tre
   NON è un edge: è rumore**, finché qualcuno non dimostra il contrario.
3. **NON misura lo spread.** La soglia di S0a usa un valore **dichiarato**. Lo
   strumento giusto è già stato promosso il 23/08 e **mai usato**: `RealCost
   Spread P95 Logger MT5` (Code Base 74148).
4. **NON misura la profondità dei tick** (decisione D2).
5. **Niente M5.** Col tetto di ~1,3 anni sarebbe **non giudicabile per
   costruzione**, prima di girare.
6. **NON tocca una riga di `ABTG_BreakingBand.mq5`.** A M15 ci si arriva **via
   `input`**, ed è il punto della promozione: **zero righe di MQL5**.

---

## ✅ COSA È GIÀ STATO VERIFICATO — **eseguendo**, prima dell'invio

Checklist punto **63** (_"il parse si FA, non si dichiara impossibile"_):

- ✅ il `.ps1` **parsa**: `/opt/pwsh/pwsh` + `[Parser]::ParseFile` → **0 errori**,
  16.597 token; **ASCII puro** (0 byte non-ASCII, regola del 17/08);
- 🔍 **e un difetto VERO trovato così, prima dell'invio**: in PowerShell
  l'operatore **virgola ha precedenza più alta del `+`**, quindi
  `@($a,$b,$a+2)` **non** è una lista di tre numeri — è `($a,$b,$a) + (2)`,
  cioè una **concatenazione di array che DUPLICA `$a`**. Il gate dei magic
  **accusava di collisione il primo file sano del round**. Corretto in tre
  punti, con le parentesi e il commento che spiega perché;
- ✅ **i gate girano DAVVERO sui sei file veri**, stubbando il download dal repo
  locale: righe vive 70×6, stella, valori, pattern vivo, TF del grafico, asse
  unico, **42 magic vergini** → tutti passati;
- ✅ **e i gate sono stati fatti FALLIRE, uno per uno** (un gate che non scatta
  mai non è dimostrato). Provati e **tutti scattati**: `InpTF` scambiato fra le
  due celle, un terzo input mosso, **il `InpPatternMode` sbagliato del file del
  cacciatore**, il **magic di R103** `760030`, un magic duplicato fra celle, un
  **secondo asse Y**, `@DAQUANDO` spostato, `@PERIODO H1` su una cella M15,
  `@SIMBOLO` sbagliato, `InpMinRR`/`InpMinTPatATR` **accesi**, il rischio
  cambiato, una riga di input tolta, il sorgente di **un'altra versione**,
  `InpTF` **non più un `input`**. Più i **tre casi 34-bis a stella VERDE** (la
  stessa corruzione in **entrambe** le celle di un simbolo: li prendono il gate
  dei valori e quello dell'asse unico). Più il **controllo positivo** finale: i
  file sani ripassano;
- ✅ **le due fabbriche di `.ini` provate**: 18 `.ini` scritti e riletti —
  `Model`, `Period`, `Symbol`, `FromDate`/`ToDate`, `AllowLiveTrading=false`,
  `InpTF`, `InpPatternMode`, il magic — e **zero `||` nella passata singola**
  (un `||` rimasto sarebbe un'ottimizzazione travestita, e in ottimizzazione
  **non esiste nessun report `.htm`**: il PASSO 0 resterebbe muto);
- ✅ **il parser dei DEAL provato su un report finto** con l'intestazione
  **italiana** vera: take **18 pip**, durata **4 barre**, peggior giornata
  **−0,014%**, prima operazione, `n` — **tutti i numeri attesi, calcolati a
  mano prima**. E i **controlli negativi**: report **senza la colonna Prezzo**
  (→ si rifiuta e lo dice: *"senza il prezzo il take in pip NON esiste"*),
  intestazione ignota, **sequenza in/out spaiata** (→ `NON AFFIDABILE`, e il
  take resta `n/d`: **non si stima**), report in **UTF-16**, lista vuota;
- ✅ **il parser del CSV provato sotto cultura it-IT** con l'intestazione VERA
  dell'OPTFRAME di questo EA: `1.19900` letto **uno-virgola-199** (non 1199);
  gemelli `IDENTICI` / `DIVERSI su profitto` / `NON VALIDO: 1 righe invece di 2`
  / colonne ignote (→ **si rifiuta di indovinare** e stampa quelle che ha visto);
- ✅ **il cancello zero S0a provato nei suoi TRE stati** più il quarto: take 18 e
  6 pip → `SUPERATO`; 3,0 e 2,3 → `SOSPESO`; 1,0 e 0,0 → `FALLITO`; take non
  misurato → `NON MISURATO`. **E il caso vero del DIARIO** (2,5 pip) esce
  `SOSPESO`, non `FALLITO`: la banda di incertezza fa il suo mestiere;
- ✅ **gli switch provati anche nelle combinazioni che questa pagina non propone**
  (checklist 67): `-ScreenOhlcM15`, `-SoloSimbolo 'GBPUSD'`,
  `'GBPUSD EURUSD'` (senza virgola), `'PIPPO'` (rifiutata con l'elenco dei nomi
  validi), `-SoloCella` (**la cella metro rigira**), `-SoloSimbolo` +
  `-SoloCella` **incoerenti**, **selettore a vuoto** (`exit 1`), e **criteri non
  firmati sulla corsa vera** (`exit 2`, verificato);
- ✅ **la convenzione di sentinella letta SU TUTTE LE COLONNE** facendo girare il
  referto a secco: profitto, PF, DD, `n`, **take, durata** e peggior giornata
  escono **tutti `n/d`**, mai `-1`, mai `0.000` (difetto **66**);
- ✅ i **sei file prova** passano `controlla_prova.py`: **70 pin, 2 celle, 0
  problemi**, e il blocco input è **copiato riga per riga** dai file prova di
  R103 — non scritto a memoria;
- ✅ **il commit pinnato contiene tutti e dieci gli artefatti** che il driver
  scarica (`git cat-file -e` su ognuno).

🟡 **Non verificato, e va detto**: tutto ciò che richiede **MT5** — la
**compilazione vera**, il comportamento del tester, **se il tester onori
`MaxBars`**, **se i tick reali ci siano davvero** sui tre simboli, la durata
reale, e **ogni singolo numero**. **Il giro a vuoto copre gli artefatti; i numeri
li può dare solo la corsa.**

> ⚠️ **Il rischio residuo più concreto, dichiarato: i TICK.** È la decisione
> **D2**, ed è l'unica che può rendere **falso** tutto il round senza che nessuno
> se ne accorga. Se Claudio firma *"si misura prima"*, R108 aspetta mezz'ora e
> parte su basi solide; se firma *"si gira e si dichiara"*, ogni numero a
> modello 4 esce con la riserva scritta **in testa al referto**.
