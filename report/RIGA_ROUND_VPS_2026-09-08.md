# 🚀 `RIGA_ROUND_VPS.ps1` — **la riga generica**: da oggi un round qualunque gira sul VPS

08/09/2026. Stamattina il **passo 7 e' passato** (`report/PASSO7_ANCORA_SUPERATA_2026-09-08.md`:
`ESITO: ANCORA SUPERATA`, **RILIEVI 0**, quattro grandezze riprodotte alla cifra).
Ma `RIGA_ANCORA_R119.ps1` e' **cablata** sulle due sedie dell'ancora e sui loro
quattro numeri attesi: serve per il passo 7, **non per un round**.

👉 Adesso c'e' la versione generica.

**File**: `backtest_pipeline/righe/RIGA_ROUND_VPS.ps1`
**Marcatore**: `MARCATORE_RIGA_ROUND_VPS_v1`
**Pin**: `4cfd4bafd99af35c7b4de9f9ac60e8a4ae2c2c77`

---

## 🎯 COSA FA — e cosa **non** fa

**Esegue e raccoglie.** Scarica il driver e il file prova **dal pin**, chiude
**solo** il terminale da backtest, lancia `walkforward_generico.ps1`, legge i due
CSV (IS e OOS) e mette referto + CSV + file prova in uno **zip sul Desktop**.

**Non giudica.** Niente numeri attesi, niente confronti, niente "RIPRODUCE": il
verdetto si scrive dopo, coi criteri congelati **prima** del round.

### I parametri

| parametro | default | a cosa serve |
|---|---|---|
| `-Expert` | **obbligatorio** | nome del `.mq5` senza estensione |
| `-Prova` | **obbligatorio** | nome del file in `backtest_pipeline/prove/` |
| `-Etichetta` | **obbligatorio** | suffisso dei CSV: **un round nuovo non sovrascrive il precedente** |
| `-Pin` | `lavoro` | sha o branch da cui scaricare driver e prova |
| `-TerminaleBacktest` | `C:\MT5_Backtest` | cartella programma del terminale (demo **50504400**) |
| `-Modello` | `4` | 4 = tick reali. Diverso da 4 -> avviso + rilievo + suffisso `_ohlc` |
| `-Deposito` | `10000` | deposito del tester |
| `-Work` | `%USERPROFILE%\abtg_round` | cartella di lavoro |
| `-ChiudiBacktest` | spento | chiude **solo** il terminale da backtest |
| `-SoloControllo` | spento | giro a vuoto: MT5 non viene aperto |

### I codici d'uscita — **il gate sta sull'ARTEFATTO, non sul rc del driver**

| uscita | significato |
|---|---|
| **0** | `ROUND GIRATO` — i due CSV ci sono, sono freschi, hanno `Trades > 0` |
| **2** | `NON MISURATO` — CSV assente/vuoto/non fresco, **oppure Trades = 0** |
| **3** | `ROUND GIRATO CON RILIEVI` |
| **1** | non e' nemmeno partito (pre-volo fallito) |

🔴 **La raccolta si fa SEMPRE, anche a esito 2.** "Non e' girata" e' gia' una
risposta e il referto va mandato lo stesso (checklist, punto 26-bis).

---

## ♻️ COSA E' STATO **RIUSATO** DALL'ANCORA (non reinventato)

Tutto quello che nell'ancora era gia' stato pagato con un fallimento vero:

| # | pezzo | perche' esiste |
|---|---|---|
| 1 | **guardie sul terminale** | muore su `-V3` (100k **50504263**) e `BCM_Reale` (**REALE 10105439**); muore se la cartella o `terminal64.exe` non ci sono |
| 2 | **pre-volo sul tetto barre** | `MaxBars` da `config\common.ini` — **classe 160**: un tetto a 100.000 fa girare su meno storico **senza dirlo** |
| 3 | **censimento PID prima e dopo** | confronto fatto **dal codice**, allarme rosso se sparisce un terminale non bersaglio: e' la prova **stampata** che il conto reale non e' toccato |
| 4 | **chiusura chirurgica + `-Force`** | **classe 159**: la guardia "MT5 aperto" del driver e' GLOBALE e sul VPS i terminali sono quattro |
| 5 | **controllo del marcatore del driver** | **classe 161**: senza `MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE` il driver non porta gli `#include` nostri, l'EA non compila, il round muore con ZERO CSV |
| 6 | **raccolta + zip + referto con la riga `data:`** | regola delle righe di lancio, punti 2 e 3 |

## 🆕 COSA CAMBIA

1. **Nessun numero atteso, nessun confronto.**
2. **Il referto stampa i numeri**, cosi' il round si legge senza aprire il CSV.
   Per **ogni** CSV (IS e OOS): quante righe e, riga per riga,
   `Pass / Profit / PF / Equity DD % / Trades`.
3. 🔴 **IL CANCELLO CHE CONTA.** CSV assente, non fresco, vuoto, **o Trades = 0**:
   il referto **e** la console dicono, con le stesse parole (una sola variabile,
   niente divergenze):

   > **Trades=0 non vuol dire nessun edge, vuol dire NON E' GIRATA: guardare il log**

   E' l'errore del **verdetto PostNews del 07/08**, gia' pagato una volta.
4. **Scarica anche il file prova dal pin**, come l'ancora, e ne legge `@SIMBOLO`,
   `@PERIODO`, `@DAQUANDO`: senza `@SIMBOLO` non saprebbe nemmeno **come si
   chiameranno i CSV**, quindi si ferma subito invece di scoprirlo alla fine.
5. **Pulizia chirurgica** (classe 155): non rade al suolo `risultati_prove\` —
   ci vivono gli altri round — ma cancella **solo i due file omonimi** di questa
   corsa, e la freschezza si ricontrolla comunque **per data**.

---

## 🧪 I COLLAUDI — **eseguiti**, non promessi

> Un cancello che nessuno ha visto scattare non e' dimostrato.

### Obbligatori
| controllo | esito |
|---|---|
| `LC_ALL=C grep -n '[^ -~\t]' RIGA_ROUND_VPS.ps1` | **nessun output** = ASCII puro ✅ |
| parse reale con `pwsh` 7.4.6 (`Parser::ParseFile`) | **OK, 0 errori** ✅ |
| raw al pin vs `git show` | **sha256 identico** (`a063b0e2…d8ba`), HTTP **200** ✅ |

### Banco A — le funzioni **vere** estratte dal file (AST), **68 casi, 0 falliti**

| gruppo | casi | esempi di esito |
|---|---|---|
| selezione dei processi | 7 | bersaglio = **solo** `C:\MT5_Backtest\terminal64.exe`; **`C:\MT5_Backtest_OLD` NON bersaglio**; conto REALE, piccolo e 100k risparmiati; processo **senza `Path`** non e' bersaglio; sottocartella del bersaglio **si'** |
| guardie sui percorsi vietati | 5 | `-V3` e `BCM_Reale` fermano anche con la barra finale; `C:\MT5_Backtest` passa |
| nomi ed etichetta | 9 | `../evil`, `a/b`, vuoto -> **rifiutati** |
| direttive del file prova | 8 | `@SIMBOLO` letto uguale su **LF e CRLF** (classe 40 evitata: nessuna regex multilinea); sul file prova **VERO** legge `U30USD` / `M5` / `2024.09.26` |
| tetto barre | 7 | `MaxBars=100000` **ferma**; `2147483647` passa; chiave assente = **NON VERIFICATO** dichiarato, non finto |
| cultura invariante (finta **it-IT**) | 5 | `2484.17` resta `2484.17`, non diventa 248417 |
| lettura CSV + cancello Trades=0 | 24 | vedi sotto |
| nomi dei CSV attesi | 3 | `ABTG_OpeningReversalB_U30USD_OOS_P0CONTA.csv`; a `-Modello 1` compare `_ohlc` |

Il gruppo che conta, in chiaro:

| CSV di prova | cosa e' uscito |
|---|---|
| 2 righe, `Trades 119` | `ESITO : LETTO — 2 righe, tutte con Trades > 0`, **niente** frase del cancello |
| 2 righe, `Trades 0` | `NON MISURATO — TRADES = 0 su tutte le 2 righe` + **frase del cancello** |
| 1 riga a 7 trade + 1 a zero | `1 righe su 2 hanno Trades = 0` + **frase del cancello** |
| solo intestazione | `ZERO RIGHE (solo intestazione): nessuna passata eseguita` + frase |
| 0 byte | `CSV DA 0 BYTE` |
| assente | `CSV ASSENTE` + frase |
| **di ieri, col nome giusto** | `CSV NON FRESCO (scritto il 2026-09-07 …)` — **classe 155 chiusa**, e i suoi numeri **non** entrano nel referto |
| intestazione di un altro strumento | `colonna Trades non leggibile` |

### Banco B — **end-to-end**: lo script **vero**, driver finto, **32 corse, 0 fallite**

Finto terminale, finto `powershell.exe` al posto del driver, e **download vero**
dal pin (quindi il controllo del marcatore e' quello reale).

| scenario | atteso | ottenuto |
|---|---|---|
| corsa buona | 0 | **0** `ROUND GIRATO`, referto con `Profit 1234.56 … Trades 88`, **4 file** nello zip |
| **driver esce 1** ma i CSV sono buoni | 0 | **0** — **classe 154 chiusa**: il rc si stampa, non si interpreta |
| `Trades = 0` | 2 | **2**, frase del cancello **a schermo E nel referto**, **zip fatto lo stesso** |
| nessun CSV | 2 | **2**, referto: `CSV ASSENTE` |
| CSV con sola intestazione | 2 | **2** |
| `-SoloControllo` con anteprima fresca | 0 | **0** |
| `-SoloControllo` **senza** anteprima | 1 | **1** — **classe 14**: il giro a vuoto non esce 0 per essere arrivato in fondo |
| terminale `-V3` (100k 50504263) | 1 | **1** `TERMINALE VIETATO` |
| terminale `BCM_Reale` (REALE 10105439) | 1 | **1** `TERMINALE VIETATO` |
| cartella inesistente / senza `terminal64.exe` | 1 | **1**, due messaggi distinti |
| etichetta vuota / `../x` / EA `../evil` | 1 | **1** |
| `-Modello 9` / `-Deposito 0` | 1 | **1** |
| file prova inesistente sul pin | 1 | **1** con il **404 stampato** |
| pin inesistente | 1 | **1** con il 404 stampato |
| `MaxBars=100000` | 1 | **1** `TETTO BARRE NEL GRAFICO = 100000` |
| **pin pre-v5** (`957fddb`, driver vero senza il marcatore) | 1 | **1** — il driver vecchio viene **rifiutato davvero** |
| CSV di ieri col nome giusto | 2 | **2**, e i CSV omonimi vengono **tolti prima** della corsa |

### 🐛 E un difetto vero, trovato **dal banco** e corretto

Nella funzione che compone il referto il ciclo si chiamava `$r` mentre
l'elenco in costruzione si chiamava `$R`: **PowerShell non distingue le
maiuscole**, quindi il ciclo **schiacciava l'elenco** e il referto esplodeva
con `does not contain a method named 'Add'` — proprio sul CSV buono, cioe' nel
caso in cui tutto era andato bene. Rinominata la variabile del ciclo, il banco
passa. 😅 Un difetto in meno, e nessuna ora di tick reali buttata.

### 🚧 Quello che i collaudi **NON** coprono, dichiarato

- il **giro a vuoto del driver non compila** (checklist 39): un `#include`
  mancante salta fuori solo a corsa avviata. Per il PASSO 0 di
  `ABTG_OpeningReversalB` il rischio e' **misurato e nullo**: `grep` sul
  sorgente -> **un solo `#include`, `<Trade/Trade.mqh>`**, che e' di sistema;
- nel ramo di prova del driver **`Model=4` e' HARDCODED** (checklist 31):
  con `-Modello 1` l'anteprima dice comunque 4. `Deposit` invece e' la
  variabile vera (verificato riga per riga);
- il driver esce **prima** di scegliere il terminale: il giro a vuoto **non
  collauda `-TerminaleBacktest`**;
- **classe 24**: `walkforward_generico.ps1` riscarica il `.mq5` dell'EA da
  `lavoro` **HEAD**, non dal pin. Il pin copre driver, prova e questa riga;
  **l'EA no**. Per un round di una notte: non si pusha sul `.mq5` mentre gira.

---

## 🎬 LA RIGA DI LANCIO — **PASSO 0 di `ABTG_OpeningReversalB`**

Un **PASSO 0 di conteggio** su **U30USD M5**: l'EA sta nel repo dal 30/08 e
**non e' mai stato girato**. La cella e' gia' committata e validata
(`controlla_prova.py`: 27 input pin, 2 celle, 4 passate, zero problemi).
Non ne uscira' **nessuna promozione**: si conta, non si giudica.

### 🖥️ Il terminale: e' **quello da backtest**, conto **50504400**

Non e' il piccolo (**50503392**, `BCM Markets MT5 Terminal`), non e' il 100k
(**50504263**, `... -V3`), non e' il **REALE** (**10105439**, `C:\BCM_Reale`).
E' `C:\MT5_Backtest`. Se vuoi vedere coi tuoi occhi cosa e' aperto adesso,
questa riga e' **di sola lettura** e stampa PID, titolo e cartella:

```powershell
Get-Process terminal64 | select Id, MainWindowTitle, Path
```

⚠️ La riga qui sotto, con `-ChiudiBacktest`, **puo' chiudere un terminale**: e
chiude **solo** quello sotto `C:\MT5_Backtest`. Gli altri tre restano vivi, e
lo script lo **stampa** contando i PID prima e dopo.

### 1) Prima il **giro a vuoto** (costa dieci secondi). Incolla il blocco INTERO:

```powershell
& { $ErrorActionPreference='Stop'; $p="$env:USERPROFILE\RIGA_ROUND_VPS.ps1"; Remove-Item $p -EA SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/4cfd4bafd99af35c7b4de9f9ac60e8a4ae2c2c77/backtest_pipeline/righe/RIGA_ROUND_VPS.ps1" -OutFile $p; if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ROUND_VPS_v1' -Quiet)){ throw 'SCRIPT VECCHIO' }; & powershell -NoProfile -ExecutionPolicy Bypass -File $p -Expert "ABTG_OpeningReversalB" -Prova "ABTG_OpeningReversalB_00_conta.txt" -Etichetta "P0CONTA" -Pin "4cfd4bafd99af35c7b4de9f9ac60e8a4ae2c2c77" -TerminaleBacktest "C:\MT5_Backtest" -SoloControllo }
```

Deve finire con **`anteprima .ini fresca`** e uscita **0**. Se esce **1**, non
si prosegue: l'errore del driver e' stampato sopra.

### 2) Poi la corsa vera:

```powershell
& { $ErrorActionPreference='Stop'; $p="$env:USERPROFILE\RIGA_ROUND_VPS.ps1"; Remove-Item $p -EA SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/4cfd4bafd99af35c7b4de9f9ac60e8a4ae2c2c77/backtest_pipeline/righe/RIGA_ROUND_VPS.ps1" -OutFile $p; if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ROUND_VPS_v1' -Quiet)){ throw 'SCRIPT VECCHIO' }; & powershell -NoProfile -ExecutionPolicy Bypass -File $p -Expert "ABTG_OpeningReversalB" -Prova "ABTG_OpeningReversalB_00_conta.txt" -Etichetta "P0CONTA" -Pin "4cfd4bafd99af35c7b4de9f9ac60e8a4ae2c2c77" -TerminaleBacktest "C:\MT5_Backtest" -ChiudiBacktest }
```

**La raccolta e' dentro la riga**: non c'e' un secondo comando da lanciare.
Alla fine, sul **Desktop del VPS**:

```
Desktop\ROUND_P0CONTA.zip          <-- QUESTO e' quello da mandare
Desktop\ROUND_P0CONTA\
    REFERTO_ROUND_P0CONTA.txt
    ABTG_OpeningReversalB_U30USD_IS_P0CONTA.csv
    ABTG_OpeningReversalB_U30USD_OOS_P0CONTA.csv
    ABTG_OpeningReversalB_00_conta.txt
```

📅 **Nel referto guarda la riga `data:`**: deve essere di **oggi**. Se e' di
ieri stai leggendo il file di una corsa vecchia.

### Perche' la riga e' fatta cosi'

- **`Remove-Item` + `irm` + `Test-Path` + `Select-String`**, in quest'ordine:
  **classe 152** — `-ErrorAction Stop` **non** ferma la coda separata da `;`,
  solo un `throw` **raggiungibile** la ferma. Falsificato eseguendo, adesso:
  URL buona -> la coda parte; URL a 404 -> **muore sul `throw`**; copia vecchia
  senza marcatore -> **`SCRIPT VECCHIO`**, coda ferma;
- **un solo comando** dentro `& { ... }` (checklist 21): tre righe incollate
  sarebbero **tre comandi indipendenti**, e un `throw` alla prima non fermerebbe
  la seconda;
- **`-Pin` all'hash** anche nel parametro, non solo nell'URL: cosi' driver e
  file prova arrivano dallo **stesso** commit di questa riga.

---

## 🧭 E DOVE CI PORTA

Mancano **23 giorni** alla challenge. Il quarto MT5 e' l'unico cambiamento che
**moltiplica tutto il resto**, e da oggi ha anche la sua riga generica: ogni
candidato dell'imbuto — i promossi, i ripescati, e questo
`ABTG_OpeningReversalB` mai girato — puo' essere **misurato di notte, da solo**,
senza aspettare che nessuno accenda un PC. 🌙

E la prima misura che chiediamo e' la piu' onesta che ci sia: **quante volte
apre bocca**. 🗣️
