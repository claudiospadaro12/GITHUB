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

> ✅ **PASSATO DAL VERIFICATORE-STRINGHE il 25/08.** Verdetto: **FAIL →
> corretto**. Sei difetti trovati **eseguendo**, tutti corretti nel driver e
> in queste righe; il dettaglio è in fondo, al § *COSA È GIÀ STATO
> VERIFICATO*. Il pin è cambiato: quello vecchio
> (`3d5a3a8…`) **non contiene le correzioni e non va usato**.

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

## 📌 IL PIN — **`de7134e284afc5577f262293d9641abd4dbbeab3`**

```
de7134e284afc5577f262293d9641abd4dbbeab3
```

🔴 **`de7134e284afc5577f262293d9641abd4dbbeab3` È UN SEGNAPOSTO E VA SOSTITUITO PRIMA DI DETTARE LA RIGA.**
Il verificatore ha corretto il driver, quindi il pin del builder
(`3d5a3a8…`) è **scaduto**: punta a un `RIGA_R108_BB_M15.ps1` senza le
correzioni. Sequenza, in quest'ordine — **due commit, non uno**:

```bash
# 1. il SOLO file che il driver scarica ed è cambiato
git add backtest_pipeline/righe/RIGA_R108_BB_M15.ps1
git commit -m "R108: correzioni del verificatore (gate antenato, screen OHLC, CmdletBinding)"
git push
SHA=$(git rev-parse HEAD)
# 2. il pin dentro questa pagina, che il driver NON scarica
sed -i "s/de7134e284afc5577f262293d9641abd4dbbeab3/$SHA/g" backtest_pipeline/righe/RIGA_R108_DA_MANDARE.md
git add backtest_pipeline/righe/RIGA_R108_DA_MANDARE.md && git commit -m "R108: pin" && git push
grep -c "de7134e284afc5577f262293d9641abd4dbbeab3" backtest_pipeline/righe/RIGA_R108_DA_MANDARE.md   # DEVE dare 0
```

✅ **Gli altri nove artefatti che il driver scarica NON sono stati toccati** e
stanno già in repo da prima: i **sei** file prova, i criteri, il sorgente
`ABTG_BreakingBand.mq5`, l'include `ABTG_PausaGuardian.mqh` — più i **tre
antenati R103** (`R103_ABTG_BreakingBand_{GBPUSD_772161,EURUSD_772162,AUDUSD_772163}.txt`),
che il gate nuovo scarica al pin. Quindi **un solo file da committare prima
del pin**.

⚠️ Se il segnaposto resta, l'`irm` prende un 404, `-ErrorAction Stop` è
terminante e **la riga muore lì**: non parte niente. È il comportamento
voluto, ma è un giro sprecato — meglio il `grep -c` qui sopra.

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
    $t0=Get-Date; $pin='de7134e284afc5577f262293d9641abd4dbbeab3'; $p="$env:USERPROFILE\RIGA_R108.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R108_BB_M15.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R108_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem "$env:USERPROFILE\Desktop\R108_BB_M15_*.zip" -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($z.Count -eq 0){ Write-Host '!!! NESSUNO ZIP DI ADESSO: la riga si e'' fermata prima della raccolta. Copia lo SCHERMO, non cercare file.' -ForegroundColor Red }
    else { Write-Host ('ZIP: ' + $z[0].FullName) -ForegroundColor Green };
    if($rc -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
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
- **tre righe `gate dell'ANTENATO <simbolo>: il metro e' identico a
  R103_ABTG_BreakingBand_...txt (delta: InpNewsCurrencies, InpMagic, InpComment)`**
  — è il gate **nuovo**, aggiunto dal verificatore: la stella confronta le due
  celle **fra loro** e per costruzione **non può vedere** una riga storta uguale
  in **tutte e due**. Il metro si confronta col file R103 da cui è copiato;
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
    $t0=Get-Date; $pin='de7134e284afc5577f262293d9641abd4dbbeab3'; $p="$env:USERPROFILE\RIGA_R108.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R108_BB_M15.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R108_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -CriteriFirmati; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem "$env:USERPROFILE\Desktop\R108_BB_M15_*.zip" -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($rc -eq 2){ Write-Host '!!! CRITERI NON FIRMATI: non e'' partito NIENTE e NON c''e'' nessuno zip. Leggi le sei decisioni qui sopra.' -ForegroundColor Red }
    elseif($z.Count -eq 0){ Write-Host '!!! NESSUNO ZIP DI ADESSO: la riga si e'' fermata prima della raccolta. Copia lo SCHERMO, non cercare file.' -ForegroundColor Red }
    else { Write-Host ('ZIP DA MANDARE: ' + $z[0].FullName) -ForegroundColor Green;
           if($rc -ne 0){ Write-Host 'ESITO: PARZIALE, SCREEN O FERMO - lo zip esiste: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } } }
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
    $t0=Get-Date; $pin='de7134e284afc5577f262293d9641abd4dbbeab3'; $p="$env:USERPROFILE\RIGA_R108.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R108_BB_M15.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R108_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -CriteriFirmati -SoloSimbolo 'GBPUSD'; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem "$env:USERPROFILE\Desktop\R108_BB_M15_*.zip" -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($rc -eq 2){ Write-Host '!!! CRITERI NON FIRMATI: non e'' partito NIENTE e NON c''e'' nessuno zip. Leggi le sei decisioni qui sopra.' -ForegroundColor Red }
    elseif($z.Count -eq 0){ Write-Host '!!! NESSUNO ZIP DI ADESSO: la riga si e'' fermata prima della raccolta. Copia lo SCHERMO, non cercare file.' -ForegroundColor Red }
    else { Write-Host ('ZIP DA MANDARE: ' + $z[0].FullName) -ForegroundColor Green;
           if($rc -ne 0){ Write-Host 'ESITO: PARZIALE, SCREEN O FERMO - lo zip esiste: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } } }
```

**Due simboli** — ⚠️ **l'elenco va FRA APICI** (checklist 65: senza, la virgola
fa un **array** e il binder lo unisce con uno spazio):

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $t0=Get-Date; $pin='de7134e284afc5577f262293d9641abd4dbbeab3'; $p="$env:USERPROFILE\RIGA_R108.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R108_BB_M15.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R108_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -CriteriFirmati -SoloSimbolo 'EURUSD,AUDUSD'; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem "$env:USERPROFILE\Desktop\R108_BB_M15_*.zip" -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($rc -eq 2){ Write-Host '!!! CRITERI NON FIRMATI: non e'' partito NIENTE e NON c''e'' nessuno zip. Leggi le sei decisioni qui sopra.' -ForegroundColor Red }
    elseif($z.Count -eq 0){ Write-Host '!!! NESSUNO ZIP DI ADESSO: la riga si e'' fermata prima della raccolta. Copia lo SCHERMO, non cercare file.' -ForegroundColor Red }
    else { Write-Host ('ZIP DA MANDARE: ' + $z[0].FullName) -ForegroundColor Green;
           if($rc -ne 0){ Write-Host 'ESITO: PARZIALE, SCREEN O FERMO - lo zip esiste: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } } }
```

**Una cella sola** (la cella METRO del suo simbolo rigira lo stesso):

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $t0=Get-Date; $pin='de7134e284afc5577f262293d9641abd4dbbeab3'; $p="$env:USERPROFILE\RIGA_R108.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R108_BB_M15.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R108_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -CriteriFirmati -SoloCella 'R108_GBPUSD_01_m15.txt'; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem "$env:USERPROFILE\Desktop\R108_BB_M15_*.zip" -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($rc -eq 2){ Write-Host '!!! CRITERI NON FIRMATI: non e'' partito NIENTE e NON c''e'' nessuno zip. Leggi le sei decisioni qui sopra.' -ForegroundColor Red }
    elseif($z.Count -eq 0){ Write-Host '!!! NESSUNO ZIP DI ADESSO: la riga si e'' fermata prima della raccolta. Copia lo SCHERMO, non cercare file.' -ForegroundColor Red }
    else { Write-Host ('ZIP DA MANDARE: ' + $z[0].FullName) -ForegroundColor Green;
           if($rc -ne 0){ Write-Host 'ESITO: PARZIALE, SCREEN O FERMO - lo zip esiste: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } } }
```

In **tutti** i casi la **cella METRO del simbolo rigira**: è la prova che il
banco è sano, e senza non si legge niente. Costa 3 passate, non una corsa
sprecata.

### 🩺 E se il tempo dei tick reali fosse proibitivo: lo SCREEN veloce

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $t0=Get-Date; $pin='de7134e284afc5577f262293d9641abd4dbbeab3'; $p="$env:USERPROFILE\RIGA_R108.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R108_BB_M15.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R108_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -CriteriFirmati -ScreenOhlcM15; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem "$env:USERPROFILE\Desktop\R108_BB_M15_*.zip" -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($rc -eq 2){ Write-Host '!!! CRITERI NON FIRMATI: non e'' partito NIENTE e NON c''e'' nessuno zip. Leggi le sei decisioni qui sopra.' -ForegroundColor Red }
    elseif($z.Count -eq 0){ Write-Host '!!! NESSUNO ZIP DI ADESSO: la riga si e'' fermata prima della raccolta. Copia lo SCHERMO, non cercare file.' -ForegroundColor Red }
    else { Write-Host ('ZIP DA MANDARE: ' + $z[0].FullName) -ForegroundColor Green;
           if($rc -ne 0){ Write-Host 'ESITO: PARZIALE, SCREEN O FERMO - lo zip esiste: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } } }
```

🔴 **E QUESTO GIRO NON PUÒ PRODURRE UN VERDETTO, per costruzione.** Le celle M15
girano in **OHLC M1**, e su M5/M15 **l'OHLC inganna — ed è MISURATO in casa**
(`REGISTRO_TEST.md` §2: _"in OHLC i Live5m davano numeri finti enormi (+129k DAX,
+30k Nasdaq). In real tick: morti."_).

⚠️ **Questa promessa era FALSA fino alla verifica del 25/08, e il verificatore
l'ha resa vera.** Nella v1 lo switch cambiava solo il **nome** della cartella:
fatto girare lo screen, il referto usciva con **`S0a SUPERATO` su tutti e tre i
simboli**, ogni riga con esito `OK`, `ESITO: COMPLETO ... nessun guasto` e
**uscita 0** — cioè un cancello verde su numeri che per costruzione non valgono
niente. È il difetto **67** (la regola scritta nella prosa e mai imposta dal
codice). Adesso è un `if`, ed è stato **provato eseguendolo**:

- ogni riga M15 della TABELLA MADRE esce con `ESITO = NON GIUDICABILE`;
- **nessun verdetto S0a**: né `SUPERATO` né `FALLITO`, solo
  `NON GIUDICABILE -- questa cella e' girata a OHLC M1`;
- il referto chiude con `ESITO: SCREEN OHLC -- NESSUN VERDETTO` e **esce 1**,
  così la riga in chat non può annunciarlo come un round riuscito;
- la cartella e lo zip si chiamano `SCREENOHLC`.

Al massimo produce **il permesso** di un giro a tick reali.

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
- i **sei file prova al pin** + i **tre antenati** `ANTENATO_R103_ABTG_BreakingBand_*.txt`,
  così lo zip è autosufficiente e porta dentro anche **il metro del metro**;
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
4-bis. 🧨 **LA TABELLA `G4: LA PEGGIOR GIORNATA`** (aggiunta dal verificatore).
   Muro prop giornaliero **−5,00% su 100k**, e i criteri §5 dicono che a M15 *"il
   numero da guardare non è il DD totale, è la peggior giornata"*. La v1 la
   **misurava e non la stampava**: la colonna `Peggior Giornata %` dell'OPTFRAME
   veniva letta e buttata, per la finestra INTERA e per IS/OOS. Adesso ci sono
   **quattro viste**: `htm-INTERA` (dal report della singola, con la data),
   `csv-INTERA`, `csv-IS`, `csv-OOS`. Stessa storia per **`ISdd`**, che era letto
   e mai scritto: adesso è una colonna della TABELLA MADRE. 👉 **Il rischio non si
   sospende mai** (Emendamento regola B): un DD/una giornata si leggono a
   qualunque `n`, anche quando il MERITO è sospeso.
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

Due passaggi: il **builder** (25/08) e poi il **verificatore-stringhe**, che ha
rifatto tutto da capo e ha trovato **sei difetti veri**. Verdetto:
**FAIL → corretto**.

### 🔧 I SEI DIFETTI TROVATI DAL VERIFICATORE — tutti **riprodotti**, non dedotti

| | difetto | come è stato trovato | classe |
|---|---|---|---|
| **V1** | 🔴 **`-ScreenOhlcM15` era solo un nome di cartella.** Fatto girare lo screen: `S0a SUPERATO` su tutti e tre i simboli, ogni riga `OK`, `ESITO: COMPLETO ... nessun guasto`, **uscita 0** — un cancello verde su numeri che per costruzione non valgono niente. La testa del driver dichiarava *"qui è un if, non una frase"*: **non era un if** | eseguito il ramo screen col tester stubbato | **67** (regola nella prosa, mai nel codice) |
| **V2** | 🔴 **`[CmdletBinding()]` mancante.** Un `.ps1` col solo `param()` **non rifiuta** i parametri che non conosce: li mette in `$args` e **tira dritto in silenzio**. Riprodotto: `& $p -Pin X -Riprendi` stampa `args=[-Riprendi]` ed esce 0. 👉 Su **questa** riga vuol dire che **`-SoloControlo` con una L sola non è un giro a vuoto: è LA CORSA VERA**, 18 passate a tick reali su 4 anni di M15 | eseguito su uno script-sonda | **NUOVA (71)** |
| **V3** | 🟠 **`-Riprendi` decorativo**: dichiarato fra i parametri con il commento *"salta i lanci il cui artefatto c'è già"* e **mai consultato** (`grep`: 3 occorrenze, tutte prosa). Chi lo passava dopo una corsa interrotta rifaceva **tutto** | grep + esecuzione | **14/15** (guardia decorativa) |
| **V4** | 🟠 **La corruzione SIMMETRICA passava tutti i gate.** `InpBBPeriod` 20→25 in **entrambe** le celle di GBPUSD: stella verde, valori verdi, asse unico verde, magic verdi, **uscita 0**. Restavano scoperti **64 dei 70 input** — e la stella per costruzione non può vederli, perché confronta le due celle *fra loro* | driver fatto girare su un repo corrotto | **NUOVA (72)** |
| **V5** | 🟠 **La coda della riga in chat prometteva lo zip anche quando non c'è.** `exit 2` (criteri non firmati) e il gate MT5-aperto escono **prima** della raccolta: il messaggio diceva lo stesso *"lo zip esiste lo stesso: mandalo"* | eseguita la coda nei 4 esiti | **22 / 26-bis** |
| **V6** | 🟠 **`ISdd` e la peggior giornata letti e buttati.** `$c.DdIS` e `$c.PgInt` erano assegnati dal CSV e **non stampati da nessuna parte**; `Pg` di IS e OOS non era nemmeno letto. Ma i criteri §5 **G4** dicono *"peggior giornata, misurata SEMPRE"*, e il **rischio non si sospende mai** | grep delle proprietà con 1 sola occorrenza | famiglia **66** |

**Tutti e sei corretti nel driver o in queste righe, e le correzioni sono state
riprovate eseguendo.** V2 e V4 sono **classi nuove**: sono andate nella
`CHECKLIST_RIGA_DI_LANCIO.md` ai punti **71** e **72**.

⚠️ **V2 è un difetto di FAMIGLIA, non di R108**: `grep -c CmdletBinding` sui
**dodici** driver di round (`RIGA_R95` … `RIGA_R108`) dà **0 su 12**. R108 è
l'unico corretto. Gli altri undici restano esposti — è lavoro a sé, dichiarato.

### 🧪 E COSA È STATO FATTO GIRARE DAVVERO

- ✅ **parse reale**, non analisi statica: `/opt/pwsh/pwsh` +
  `[Parser]::ParseFile` → **0 errori**, 17.455 token; **ASCII puro** (0 byte
  non-ASCII, regola del 17/08); **0 token PS7-only** (niente ternari, `&&`,
  `??`) — sul VPS/PC c'è **Windows PowerShell 5.1**;
- ✅ **i sei blocchi `powershell` di questa pagina parsano**, e ognuno è **UN
  SOLO statement** (checklist 21: incollato spezzato sarebbero comandi
  indipendenti), **zero byte non-ASCII**;
- ✅ **la precedenza virgola/`+`** (`@($a,$b,$a+2)` che duplica `$a`, trovata dal
  builder) verificata **sull'AST, non a grep**: 41 array literal, **0 elementi
  con un'espressione binaria non parentesizzata**. Le tre correzioni sono
  complete e non ce ne sono altre;
- ✅ **i file prova diffati riga per riga contro R103**: le tre celle metro sono
  identiche a `R103_ABTG_BreakingBand_{GBPUSD_772161,EURUSD_772162,AUDUSD_772163}.txt`
  salvo `InpMagic`, `InpComment` e `InpNewsCurrencies` (tolta; inerte perché
  `InpUseNewsFilter=false` e il sorgente esce subito — righe 1491-1496). E il
  **PatternMode è quello giusto**: `2 / 0 / 1`, letto nei file R103, non a
  memoria. Le celle M15 differiscono dal loro metro **solo** su `@PERIODO`,
  `@DAQUANDO`, `InpTF` e `InpMagic`;
- ✅ **magic 762000-762057 VERGINI, rifatto il grep**: nel repo esiste un solo
  `762xxx` ed è `762821` — **un URL di un blog MQL5**, non un magic. E
  `$MagicVietati` contiene i magic R103 di BreakingBand (`760020/760030/760040`
  + gemelli), che sono **proprio le tre sedie vive di questo round**;
- ✅ **i gate fatti FALLIRE uno per uno, 17 casi su repo corrotto: 17 su 17
  scattano.** `InpTF` scambiato, un terzo input mosso, **il `InpPatternMode`
  sbagliato del cacciatore**, il magic R103 `760030`, un magic duplicato, un
  secondo asse `Y`, `@DAQUANDO` spostato, `@PERIODO H1` su una cella M15,
  `@SIMBOLO` sbagliato, `InpMinRR` e `InpMinTPatATR` accesi, il rischio
  cambiato, una riga tolta, sorgente di altra versione, `InpTF` non più
  `input`, include monco. **Nella v1 uno di questi 17 NON scattava** (la
  corruzione simmetrica): adesso lo prende il gate dell'antenato;
- ✅ **otto corruzioni SIMMETRICHE** (`InpBBPeriod`, `InpBBDev`, `InpSL_ATRmult`,
  `InpBulgeWidthMult`, `InpBEatATR`, `InpMaxTradesPerDay`,
  `InpUseCongestionFilter`, `InpTP1Pct`) → **8 su 8 fermate** dal gate nuovo,
  e il **controllo positivo** (file sani) ripassa;
- ✅ **le due fabbriche di `.ini` provate**: 18 `.ini` scritti e riletti —
  `Model` 1/4, `Period` H1/M15, `Symbol`, `FromDate`/`ToDate`,
  `AllowLiveTrading=false` in **entrambi** i blocchi `[Experts]`, `InpTF`,
  `InpPatternMode`, i 18 magic **tutti distinti** (762000…762057) — e **zero
  `||` nella passata singola** (in ottimizzazione non esiste nessun report
  `.htm`: il PASSO 0 resterebbe muto);
- ✅ **il parser dei DEAL provato su un report finto con intestazione italiana e
  i numeri calcolati A MANO PRIMA**: due operazioni, take **18,0 pip**
  (1.20180−1.20000), perdita **6,0 pip**, durata mediana **5 barre M15** (4 e
  6), peggior giornata **−0,007%** il 2022.07.06 (netto −7,00 su 100.000),
  prima operazione e `n` — **tutti centrati**. Più i **controlli negativi**:
  report **senza la colonna Prezzo** (→ *"senza il prezzo il take in pip NON
  esiste"*), intestazione ignota (→ 0 deal), **sequenza in/out spaiata** (→
  `NON AFFIDABILE`, e il take resta `n/d`: **non si stima**), report in
  **UTF-16** (→ letto lo stesso), lista vuota;
- ✅ **tutto sotto cultura `it-IT`**, che è quella del PC: `1.19900` letto
  **uno-virgola-199** e non *millecentonovantanove*; `9 005.54` (spazio delle
  migliaia di MT5) letto `9005,54`;
- ✅ **il cancello S0a nei suoi stati**: 18 e 6 pip → `SUPERATO`; 3,0 e 2,3 →
  `SOSPESO`; 1,0 e 0,0 → `FALLITO`; non misurato → `NON MISURATO`. **E il caso
  vero del DIARIO** (2,5 pip) esce `SOSPESO`, non `FALLITO`;
- ✅ **i gemelli**: `IDENTICI` / `DIVERSI su profitto` / `NON VALIDO: 1 righe
  invece di 2` / colonne ignote (→ **si rifiuta di indovinare** e stampa quelle
  che ha visto);
- ✅ **gli switch e i loro esiti, eseguiti**: giro a vuoto → `exit 0`, 18 `.ini`;
  **corsa vera senza `-CriteriFirmati` → `exit 2`** con le sei decisioni a
  schermo; `-SoloSimbolo 'PIPPO'` → `exit 1` con l'elenco dei nomi validi;
  `-SoloSimbolo 'EURUSD,AUDUSD'` → 2 simboli, 20 passate; `-SoloCella` → **la
  cella metro rigira** (modo `RIPRESA`); `-ScreenOhlcM15` → modo `SCREENOHLC`,
  righe `NON GIUDICABILE`, `exit 1`; **`-SoloControlo` (una L) → errore di
  binding, lo script muore** (era il difetto V2);
- ✅ **la coda delle righe di chat eseguita nei quattro esiti** con uno zip
  **vecchio di 7 giorni** già sul Desktop: `exit 2` → *"non è partito NIENTE e
  NON c'è nessuno zip"*; fermata prima della raccolta → *"NESSUNO ZIP DI
  ADESSO"* (**lo zip vecchio NON viene scambiato per quello di adesso**);
  parziale → stampa il percorso dello zip **e** l'avviso; OK → stampa lo zip;
- ✅ **la convenzione di sentinella su TUTTE le colonne**, letta facendo girare
  il referto a secco: profitto, PF, DD, `n`, take, durata, **ISdd** e le
  **quattro colonne della peggior giornata** escono **tutte `n/d`**, mai `-1`,
  mai `0.000`;
- ✅ **l'ordine dei simboli promesso = quello stampato**: `AUDUSD, EURUSD,
  GBPUSD`, alfabetico, **incollato dall'output** e non riscritto a mano
  (checklist 70).

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
