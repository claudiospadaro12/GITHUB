# 📬 PASSO 0 — **ALLINEA LONDRA** (Money maker EURUSD 15min) — LA RIGA DA MANDARE

**Che cos'è:** il **PASSO 0** del candidato **P2** della caccia intraday forex/oro
del 28/08 (`caccia_strategie/CACCIA_INTRADAY_FOREX_ORO_2026-08-28.md`, scheda P2,
voto **7/10**). Si misura **QUANTE OPERAZIONI** produce l'allineamento a 5 medie
dentro la finestra di Londra su `EURUSD M15` — e, soprattutto, **quanto pesa il
CONTENITORE** (sessione + flat + tetto) rispetto al motore.

> 🔴 **NON È UN ROUND E NON DÀ NESSUN VERDETTO.** È un **conta-operazioni**.
> Il Profit Factor che esce dal CSV **si legge ma non si giudica**: non ci sono
> criteri di merito firmati e quattro celle non sono un round. La frequenza è il
> primo dato, prima di qualunque PF (valvola **R59**, Emendamento della finestra
> **regola A**: *"l'unità di misura è l'OPERAZIONE, non l'anno"*).

| | |
|---|---|
| **EA (nuovo, MAI compilato)** | `mql5/Experts/ABTG_AllineaLondra.mq5` (riscrittura da © SoftKill21, TradingView `jU2JCWZr`, MPL 2.0) |
| **Driver** | `righe/RIGA_ALLINEALONDRA.ps1` (marcatore `MARCATORE_RIGA_ALLINEALONDRA_v1`) |
| **File prova (4)** | `prove/PASSO0_ALLINEALONDRA_00_finestra.txt` · `_01_nofinestra.txt` · `_02_long.txt` · `_03_short.txt` |
| **Referto di preparazione** | `prove/REFERTO_PREPARAZIONE_ALLINEALONDRA.md` |
| **Dossier di caccia** | `caccia_strategie/CACCIA_INTRADAY_FOREX_ORO_2026-08-28.md` (scheda P2) |

---

## 🎯 LA DOMANDA VERA DEL ROUND — **è l'ABLAZIONE**, non il PF

Il dossier dichiara da solo l'adiacenza concettuale con `ABTG_SuperWave`,
`ABTG_CrossEma` e `ABTG_GoldenCross` — **sono tutti motori di allineamento di
medie** — e mette il carico della prova su chi propone:

> *"La differenza è il **CONTENITORE** (sessione + flat + tetto 2/giorno), non il
> segnale. Ed è esattamente per questo che il round deve avere una cella di
> ablazione: lo stesso allineamento **SENZA la finestra oraria**. Se il nudo va
> uguale, la sessione non serve e il candidato è un doppione; se il nudo crolla,
> il contenitore **È** il motore."*

Per questo **`InpUsaFinestraSessione` è l'asse principale** di questo PASSO 0, e
le **cinque medie restano CONGELATE** ai default dell'autore (3/6/9/50/200): sono
cinque manopole puntate sul passato, e nel primo giro **si spazzola la sessione,
non le medie**. Il driver **si ferma** se in un file prova compare un secondo
asse `Y`.

---

## 🧩 LE QUATTRO CELLE × I DUE BANCHI

| cella | file prova | cosa cambia dal `00` | magic gemelli |
|---|---|---|---|
| **00_finestra** | `_00_finestra.txt` | — **è la baseline** | 777600 / 777601 |
| 🔴 **01_nofinestra** | `_01_nofinestra.txt` | `InpUsaFinestraSessione` **1 → 0** | 777610 / 777611 |
| **02_long** | `_02_long.txt` | `InpAllowShort` **1 → 0** | 777620 / 777621 |
| **03_short** | `_03_short.txt` | `InpAllowLong` **1 → 0** | 777630 / 777631 |

Ogni cella differisce dal `00_finestra` di **DUE righe sole** (l'interruttore + il
magic), e il driver **lo verifica prima di aprire MT5**. Gli **otto magic sono
VERGINI**: il blocco `7776xx` è stato cercato **uno per uno** in tutto il repo il
28/08 → **zero occorrenze** fuori dal default del sorgente. I magic dei PASSO 0
gemelli (`7734xx` VWAPREV, `776xxx` FVG, `7772xx` OROLOGIO, `778xxx` G1-PAOLO) e
quelli delle **sedie vive** sono nella lista dei **vietati**, e il driver si ferma
se ne trova uno.

| banco | modello | finestra | a che serve |
|---|---|---|---|
| **S** | **1 — OHLC M1** | `2022.07.01 → 2026.06.30` (4 anni) | **il CAMPIONE**. Due regimi (crollo verso la parità 2022, risalita 2023-2025). 🔴 **SOLO SCREENING, mai un verdetto** |
| **V** | **4 — TICK REALI** | `2024.07.05 → 2026.06.30` (24 mesi) | **il RIEMPIMENTO** vero (spread e fill del feed), ma finestra corta e un regime solo |

**Perché due banchi, e perché le due date sono quelle** — sono due limiti
diversi, tutti e due già agli atti:

- **`2022.07.01` è DERIVATO, non misurato**: è il tetto delle **~100.000 barre**
  del tester, che a M15 vale **~4 anni** (stessa convenzione e stessa data di
  **R108**). EURUSD di storico ne ha molto di più (pavimento **gennaio 1999**,
  R102): qui il vincolo è **il tester**, non il broker;
- **`2024.07.05` è INFERITO, non misurato su EURUSD**: è il pavimento dei **tick
  reali di BCM** misurato su **GBPUSD** (R58/R72), esteso per analogia. È la
  tensione già battezzata del progetto: **o la finestra lunga o il riempimento
  vero, mai tutti e due**.
- ⚠️ Se il tester parte più tardi della data dichiarata, la **finestra REALE è
  più corta di quella nominale**: è un caveat da scrivere accanto ai numeri, non
  un guasto.

**32 passate** = 4 celle × 2 banchi × 2 finestre (split 40/60) × 2 gemelle.

---

## ⚖️ **LA COSA DA LEGGERE PRIMA DI GUARDARE IL CONFRONTO** — la differenza NON è un costo puro

Con la finestra spenta **il tetto di 2 ingressi al giorno RESTA ACCESO**. Quindi
la `01_nofinestra` **non** misura *"lo stesso motore, distribuito su tutto il
giorno"*: misura *"lo stesso motore, **ANCORATO A MEZZANOTTE SERVER**"*.

**Letto nel sorgente, non dedotto:** `gTradesToday` si azzera al cambio di
`day_of_year`, e `ValutaBarraChiusa` esce con `if(gTradesToday >=
InpMaxTradesDay) return`. Un allineamento a 5 medie è uno **STATO**, non un
evento: resta vero per molte barre di fila, quindi i due ingressi cadranno
tipicamente **nelle prime barre M15 dopo le 00:00 server**.

> 🔴 **La differenza `00` − `01` si riporta come un PACCHETTO:**
> `(finestra d'ingresso rimossa)` **+** `(ancoraggio a mezzanotte server)`.
> Chi volesse il motore davvero libero deve alzare **anche** `InpMaxTradesDay`:
> sarebbe una cella a **DUE righe mosse**, cioè un'altra misura, e **questo giro
> non ce l'ha**. La colonna **`GgTetto`** dice quante giornate il tetto ha davvero
> morso. *(È la regola del punto 97-bis: in una gamba CON/SENZA si elencano gli
> effetti di secondo ordine PRIMA di chiamare "costo" la differenza.)*

E la stessa avvertenza vale per le celle dei lati: **`n(02_long) + n(03_short)`
NON farà `n(00_finestra)`**, perché con un lato spento **slot e tetto restano
liberi** e la somma sarà **maggiore** del congiunto.

---

## ❓ I TRE ESITI, congelati PRIMA di vedere il numero

| esito | lettura |
|---|---|
| **A** — n **≥ 150** per finestra | il campione c'è, **Emendamento regola A soddisfatto**: il round vero si può disegnare e i criteri si portano alla firma |
| **B** — n **< 150** | scatta la **valvola R59 / regola B**: il **MERITO resta SOSPESO**, il **RISCHIO si giudica lo stesso** (`Peggior Giornata %`, `Equity DD %`). **Non si allarga il motore per fare campione** |
| **C** — n **enorme** | la manopola è **la FINESTRA** (`InpEntryEndHour/Min`), **non** il rischio e **non** un filtro nuovo appiccicato sopra |

---

## 📌 IL PIN — **`0000000000000000000000000000000000000000`**

```
0000000000000000000000000000000000000000
```

<!-- CARTELLO-INIZIO -->
> 🔴 **IL PIN QUI SOPRA È UN SEGNAPOSTO DI 40 ZERI E NON FUNZIONA.** `PIN_NON_ANCORA_MESSO`
> Va sostituito col commit vero **dopo il push**, con la ricetta qui sotto.
> **Finché è così LA RIGA NON PARTE**: il driver ha una guardia esplicita che
> riconosce i 40 zeri e si ferma (verificata eseguendo).
> ⚠️ **Nessuno ha ancora verificato che gli artefatti esistano al pin**, perché
> il pin non esiste: la verifica `git cat-file -s <pin>:<file>` si fa **dopo il
> push**, sui **sette** artefatti dell'elenco qui sotto.
> *(Questo cartello è un **PUNTO D'USO**, non prosa: sta nel perimetro del `sed`
> di pinnatura e si toglie nello stesso passo — CHECKLIST punto 101.)*
<!-- CARTELLO-FINE -->

Il commit da pinnare deve contenere **tutti e sette** gli artefatti che lo script
scarica: `backtest_pipeline/walkforward_generico.ps1`,
`backtest_pipeline/righe/RIGA_ALLINEALONDRA.ps1`, i **quattro** file prova
`backtest_pipeline/prove/PASSO0_ALLINEALONDRA_*.txt`,
`mql5/Include/ABTG_PausaGuardian.mqh` e **`mql5/Experts/ABTG_AllineaLondra.mq5`**
(che il driver generico riscarica **al pin**, perché la riga gli riscrive dentro
`$EABranch`).

La riga passa il pin a `-Pin` e **si rifiuta di partire senza**: un default
silenzioso (`lavoro`) farebbe girare la punta del branch spacciandola per un
commit congelato.

### ♻️ LA RICETTA DI **PINNATURA / RI-PINNATURA**

```bash
F=backtest_pipeline/righe/RIGA_ALLINEALONDRA_DA_MANDARE.md
NUOVO=<il commit nuovo, 40 caratteri>
VECCHIO=$(grep -oE "\\\$pin='[0-9a-f]{40}'" "$F" | head -1 | grep -oE '[0-9a-f]{40}')
echo "vecchio: $VECCHIO"
sed -i "s|\$pin='$VECCHIO'|\$pin='$NUOVO'|g; s|^$VECCHIO\$|$NUOVO|; s|\*\*\`$VECCHIO\`\*\*|\*\*\`$NUOVO\`\*\*|g" "$F"
sed -i '/CARTELLO[-]INIZIO/,/CARTELLO[-]FINE/d' "$F"      # via il cartello del segnaposto
grep -c "\$pin='$NUOVO'" "$F"    # DEVE dare 3 (controllo, corsa, ripresa)
grep -c "\$pin='$VECCHIO'" "$F"  # DEVE dare 0
grep -c 'PIN_NON[_]ANCORA_MESSO' "$F"   # DEVE dare 0
```

⚠️ **Servono TUTTI E TRE i conteggi.** Il solo *"0 pin vecchi rimasti"* lo supera
a mani basse anche un `sed` che **non ha matchato niente**; e il terzo è il
punto **101**: il cartello del segnaposto **sopravvive** alla pinnatura e finisce
per dire *"il pin non funziona"* **puntando a un pin che funziona**.

> 🔎 **PERCHÉ QUELLE PARENTESI QUADRE — due trappole trovate ESEGUENDO la ricetta
> su una copia, prima dell'invio, e sono la stessa trappola due volte: _uno
> strumento che si include nel proprio perimetro_.**
>
> 1. Il terzo conteggio, in prima stesura, era
>    `grep -ci "segnaposto|non funziona"` — e **non poteva mai dare 0**, perché
>    quelle parole compaiono anche **nella ricetta stessa e nella prosa che la
>    spiega**. Un controllo impossibile da soddisfare è un controllo che dopo due
>    volte nessuno guarda più: è il punto 101 al quadrato.
> 2. La riga di `sed` che toglie il cartello, in prima stesura, aveva i **marcatori
>    scritti per intero**. Risultato **misurato eseguendo**: `sed` cancella il
>    cartello, poi **incontra la propria riga di ricetta** — che contiene il
>    marcatore d'apertura — **riapre l'intervallo**, non trova più una chiusura e
>    **cancella il file fino in fondo**: da 457 righe a 148, cioè **la pagina di
>    lancio decapitata proprio mentre la si pinnava**. (E anche questa spiegazione,
>    scritta la prima volta coi marcatori per intero, ha fatto scattare la stessa
>    trappola: da 457 a 169. Per questo qui sopra non compaiono mai per esteso.)
>
> Le parentesi quadre risolvono tutte e due i casi: `[-]` e `[_]` matchano il
> trattino e il trattino basso, ma **nessuna riga di questa sezione contiene più il
> token o i marcatori per intero**, quindi lo strumento non incontra più se stesso.
> Token e marcatori esistono **solo dentro il cartello**.

🔴 **E il perimetro della ricetta è UN FILE SOLO — questo (CHECKLIST punto 100).**
Il referto di preparazione **NON contiene il blocco di lancio**, apposta: cita
questa pagina e basta. Prima di dichiarare fatto un pin, sempre:

```
grep -rn "RIGA_ALLINEALONDRA.ps1" --include=*.md .   # chi porta una copia della riga?
grep -rn "<pin vecchio>" .                           # DEVE dare 0
```

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** Col terminale aperto il tester non
  gira (zero CSV); con MetaEditor aperto la compilazione torna subito **senza
  compilare**. La riga si rifiuta di partire in tutti e due i casi.
- 🔴 **L'EA NON È MAI STATO COMPILATO DA NESSUNO.** Scritto il 28/08 in un
  ambiente **senza MetaEditor e senza Strategy Tester**. **Per questo il giro di
  controllo COMPILA DAVVERO**: è il primo risultato vero di questo PASSO 0, e
  costa un minuto invece di scoprirlo a corsa avviata. Lo script **cancella
  l'`.ex5` prima** (un binario vecchio farebbe passare per riuscita una
  compilazione fallita) e, se fallisce, **stampa in rosso le ultime 40 righe del
  log di MetaEditor** e si ferma. **Se la compilazione fallisce, il risultato del
  PASSO 0 è quello** e va riportato così com'è — non è un guasto della riga.
  ⚠️ `-SoloControllo` del **driver generico** invece **non compila** (esce prima):
  la compilazione la fa **questa** riga.
- 🧩 **La riga installa `ABTG_PausaGuardian.mqh`** in `MQL5\Include` prima di
  compilare. `walkforward_generico.ps1` **non lo fa** (verificato: nel driver
  generico la stringa `PausaGuardian` non compare), e senza quel file l'EA non
  compila. La copia si verifica **sul contenuto** (lunghezza), non sul nome.
- 🎯 **Il terminale è scelto con lo STESSO selettore di
  `walkforward_generico.ps1`** (righe 545-548: `*BCM Markets MT5 Terminal*`
  escludendo `*-V3*`, ripiego `*BCM Markets*`), e la riga **lo stampa**: deve
  essere lo stesso che stampa poi il driver generico.
- **NESSUNA SEDIA VIVA VIENE TOCCATA.** Magic vergini `7776xx`,
  `AllowLiveTrading=false` negli `.ini` (lo scrive il driver generico).
- 💰 **Rischio `InpRiskPercent = 0,65%`**, pinnato **nei file prova**, dove morde
  davvero — non da un parametro della riga. Deposito **100.000**. Il **Guardian è
  pinnato a 0**: nel tester è comunque fail-open, ma pinnarlo toglie una
  dipendenza non misurata da eventuali `GlobalVariable` rimaste sul PC.
- 🔇 **Il filtro di spread è SPENTO, apposta**: questo giro misura il **motore
  nudo**. 🔴 **Nessuna cella si promuove così** (lezione R55). La colonna
  `Ingressi Saltati Spread` deve restare **a 0**, e il driver ne fa un canarino.
- ♻️ **Se il pin cambia, la cache di `%USERPROFILE%\abtg_allinealondra` viene
  CANCELLATA** (file prova e CSV del pin vecchio). Senza, il gate di idempotenza
  del driver generico riproporrebbe i CSV di ieri come se fossero di oggi.
  🔴 **Un ri-pin a metà round distrugge le celle già girate.**
- 🔧 Se non è già stato fatto: MT5 → Strumenti → Opzioni → Grafici →
  **"Max barre nel grafico" = Illimitato**.
- ⏱️ **Durata [STIMA, non una previsione]:** giro di controllo **~1 minuto**
  (compilazione compresa); corsa completa **30-90 minuti**. R107 fece 24 passate
  a tick reali su 21 mesi di M15 in 9 minuti — ma **quanti tick abbia EURUSD in
  casa non è agli atti**.

---

## 1️⃣ PRIMA il giro di controllo (**COMPILA, non apre il tester**)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='0000000000000000000000000000000000000000'; $p="$env:USERPROFILE\RIGA_ALLINEALONDRA.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ALLINEALONDRA.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ALLINEALONDRA_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Cosa deve dire**, in ordine:

- `pin ......... <40 caratteri>` e `celle ....... 4 su 4` · `banchi ...... 2 su 2`;
- `rischio ..... 0.65% -- letto dalla BASELINE DICHIARATA...`;
- `passate ..... 32`;
- `driver generico scaricato e PINNATO`;
- `file prova scaricati: 4 su 4` · `include scaricato: ABTG_PausaGuardian.mqh (<n> byte)`;
- 🔴 **`sintassi a 5 campi, elenco chiuso, asse unico, geometria, interruttori, baseline assoluta, stella e magic: TUTTI PASSATI su 4 file su 4 (8 magic unici su 8)`**;
- `terminale scelto: C:\Program Files\BCM Markets MT5 Terminal` — ⚠️ **è il nome
  da confrontare** con quello che stampa poi il driver generico;
- `include: INSTALLATO e VERIFICATO in ...`;
- 🔴 **`compilato ABTG_AllineaLondra: OK (... KB, ...)`** ← **è questa la riga che
  conta.** Se invece esce `COMPILAZIONE FALLITA`, sopra ci sono in **rosso** le
  ultime 40 righe del log di MetaEditor: **copiale in chat, sono il risultato**;
- otto volte l'anteprima dell'`.ini` del driver generico, e in fondo
  `ESITO: CONTROLLO COMPLETATO`.

> ⚠️ **DUE COSE SULL'ANTEPRIMA `.ini`, e sono difetti NOTI del driver generico
> (CHECKLIST punto 96), non di questa riga:**
> 1. il nome del file **non contiene l'etichetta** → le **otto** anteprime
>    collassano in **UN solo file** `anteprima_ABTG_AllineaLondra_EURUSD.ini`, e
>    vince l'ultima chiamata (`03_short`, banco V);
> 2. l'anteprima scrive **`Model=4` cablato**, anche per le passate del **banco S
>    che gireranno a `Model=1`**. 🔴 **Non fidarsi dell'anteprima per il modello:
>    la corsa vera scrive `Model=$Modello`**, e il modello vero di ogni passata è
>    quello che stampa questa riga (`banco S modello 1` / `banco V modello 4`).

> ⚠️ **Quello che il giro di controllo NON può fare:** `-SoloControllo` **non apre
> il tester**. Nessun `n`, nessun PF, **nessuna colonna di collaudo** e **nessun
> gemello** (il CSV lo produce solo la corsa). Conferma gli **artefatti** e la
> **compilazione**, mai i numeri.

---

## 2️⃣ POI la corsa vera (**32 passate**)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='0000000000000000000000000000000000000000'; $p="$env:USERPROFILE\RIGA_ALLINEALONDRA.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ALLINEALONDRA.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ALLINEALONDRA_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**: è **un comando solo**. Tre righe staccate
sarebbero tre comandi indipendenti, e un `throw` alla prima non fermerebbe le
altre.

---

## 3️⃣ Se serve **riprendere** una cella o un banco

> ⚠️ **Ogni ripresa è un BLOCCO INTERO, col suo `irm`.** `$p` e `$pin` nascono
> **dentro** il `& { ... }`, che è uno scope figlio: quando quel blocco finisce
> **non esistono più**.

Si cambia **solo** ciò che sta dopo `-Pin $pin`. Combinazioni valide:
`-SoloCella '01_nofinestra'` · `-SoloBanco 'V'` · tutte e due insieme ·
`-Rifai` per **rifare** anche i CSV già presenti.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='0000000000000000000000000000000000000000'; $p="$env:USERPROFILE\RIGA_ALLINEALONDRA.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ALLINEALONDRA.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ALLINEALONDRA_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloCella '01_nofinestra' -SoloBanco 'V' -Rifai;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo' -ForegroundColor Yellow } }
```

Id validi: `00_finestra`, `01_nofinestra`, `02_long`, `03_short` · banchi: `S`, `V`.

---

## 4️⃣ **LA RICOMPOSIZIONE — non serve un lancio in più**, ed ecco perché

L'ablazione è un **criterio DI INSIEME**: per adjudicarla servono la `00` **e**
la `01`, e chi gira una cella per volta rischia sei referti che dicono tutti
*"non misurato per intero"* (è il difetto del **punto 101**, pagato sulla Sonda
dell'Orologio la stessa settimana).

Qui è risolto **dentro lo script**, e le tre domande hanno tutte una risposta:

1. **chi ricompone?** Lo script, **sempre e da solo**: dopo le corse rilegge i CSV
   **di tutte e quattro le celle e di tutti e due i banchi** che trova sul disco;
2. **quanto costa?** **Zero**: è una rilettura di file, non una corsa. Le celle
   non girate in questo giro escono nel referto come
   **`RILETTA DA UN GIRO PRECEDENTE`**, e la riga
   `il tester ha girato in questo giro:` lo dice per ognuna — così un numero
   riletto non si può scambiare per un numero misurato adesso (punto 101-bis);
3. **cosa lo invalida?** 🔴 **Il ri-pin.** Con un pin diverso la riga **cancella
   `risultati_prove\`** e le celle già girate **sono perse**: un ri-pin a metà
   round significa **ricominciare da capo**.

---

## 📦 COSA TORNA INDIETRO — e su quali uscite lo zip **esiste davvero**

Cartella e zip sul **Desktop**: `PASSO0_ALLINEALONDRA_<MODO>_<data>_<ora>` — dentro:

- **`REFERTO_PASSO0_ALLINEALONDRA.txt`** ← **è questo che conta**;
- i **quattro file prova**;
- i **CSV** `ABTG_AllineaLondra_EURUSD_{IS,OOS}[_ohlc]_<cella>_<banco>.csv`;
- `COMPILAZIONE_FALLITA.log` e `AUTOTEST_ALLINEALONDRA.txt`, **se esistono**.

| come finisce | codice | lo zip c'è? | cosa mandare |
|---|---|---|---|
| tutto bene | `0` | ✅ sì | lo **zip** |
| PROBLEMI > 0 (gate di collaudo) | `1` | ✅ sì | lo **zip** — il referto elenca i PROBLEMI |
| fermata da una guardia o da un gate (pin, MT5 aperto, file prova, compilazione) | `1` | ✅ sì | lo **zip**, e il testo **rosso** a schermo |
| ❌ **refuso in un interruttore** (`-SoloCela`, `-Banco`…) | binding error | 🔴 **NO** | PowerShell rifiuta il parametro **prima** che lo script parta: **non c'è nessuna cartella e nessuno zip**. Si manda il **testo rosso** a schermo |

### 📅 Le due righe da guardare per prime nel referto

1. **`modo:`** — `CORSA` (il risultato) / `CONTROLLO` (giro a vuoto: **non si
   manda come risultato**);
2. **`data:`** — **deve essere di ADESSO**.

---

## 🔬 IL COLLAUDO STA NEL REFERTO, **IN COLONNE** — non nella scheda Esperti

⚠️ **La scheda Esperti qui NON si guarda, ed è misurato perché:** in
**ottimizzazione** le `Print` girano **sugli agent** e non le legge nessuno
(CHECKLIST punti 34 e 99). Per questo l'EA porta il collaudo **dentro il CSV**
(29 colonne), e il driver ne fa dei **gate**:

| colonna | come si legge |
|---|---|
| **`Autotest Falliti` = 0** | gli **8 blocchi** dell'autotest del nucleo sono passati: i numeri **si leggono**. `> 0` = **DIVERGE**; `-1` = autotest **non eseguito**, che **non è "passato"** → **PROBLEMI** |
| 🔴 **`Notti Attraversate` = 0** | la **chiusura forzata di fine sessione** è stata **ermetica**. `> 0` = **posizione viva a cavallo della notte**: il mandato FTMO *"mai overnight"* **non è rispettato** → **PROBLEMI** |
| 🔴 **`Finestra Sessione`** | **è IL gate dell'ablazione**: `1` sulle celle `00/02/03`, `0` sulla `01`. Se non è quello atteso, **l'interruttore non è arrivato dentro il tester** e il confronto non vuol dire niente |
| **`Minuto Flat Calcolato`** | **630** (10:30) con la finestra accesa, **1424** (23:44) con la finestra spenta. Il flat **non è disattivabile da nessun input** |
| **`Minuto Inizio/Fine Ingressi/Fine Sessione`** | attesi **180 / 525 / 645** = 03:00 / 08:45 / 10:45 **ORA SERVER**. È l'eco della configurazione: dice cosa l'EA ha **davvero** usato, non cosa l'`.ini` credeva di passargli |
| **`Ingressi Saltati Spread` = 0** | canarino: il filtro è pinnato a 0. Se è `> 0`, **il file prova che ha girato non è quello che crediamo** |
| **`Lotti Al Minimo` > 0** | il lotto è salito al minimo del broker: il **rischio REALE è più alto dello 0,65%** → **RILIEVO** |
| **`Barre Allineate`** | le **occasioni del MOTORE**, contate **prima** dei cancelli del contenitore. Il rapporto `Ingressi Totali / Barre Allineate` dice **dove sta il collo di bottiglia** |
| **`Giorni Tetto Bloccante`** | giornate in cui il tetto di 2 ha **bloccato** un segnale. Si legge **insieme** all'ablazione (vedi il riquadro sul pacchetto) |
| **`Trades` ≥ 150** | criterio del PASSO 0, **per finestra**. Sotto → **RILIEVO**: **MERITO sospeso**, **RISCHIO no** |

> ⚠️ **`Barre Allineate` non è "occasioni perse".** Un allineamento è uno **STATO**
> e resta vero per molte barre di fila: la stessa spinta viene contata decine di
> volte. **Il numero serve al RAPPORTO fra celle, non in valore assoluto.**

---

## 🚩 QUELLO CHE QUESTO GIRO **NON** MISURA — dichiarato

1. 🔗 **La SCORRELAZIONE dalle sedie long della flotta.** Il dossier avvisa da
   solo: è un motore **a favore del trend**, quindi nelle mattine di trend forte
   è **correlato** alle sedie long già in campo. Si misura sulle serie
   **per-trade**, e **non si fa qui**.
2. 💰 **Il COSTO (spread).** Filtro spento apposta. **Nessuna cella si promuove
   così.**
3. 🕐 **L'ORA GIUSTA.** `03:00 / 08:45 / 10:45` sono i **numeri letterali del
   Pine** letti come **ora server**: un **punto di partenza dichiarato**, non una
   conversione di fuso (il Pine li scrive nel fuso dello *scambio*, tipicamente
   UTC). ⚠️ **La conversione a tavolino è la trappola già pagata in casa**
   (`CLAUDE.md`: log in ora locale ≠ grafico in ora server). **La sessione è
   l'asse del PRIMO ROUND VERO, e quello è un altro giro.**
4. 📉 **Il MERITO.** Niente promozioni, niente proposte, nessuna sedia toccata.

---

## ✅ COSA È GIÀ STATO VERIFICATO — **eseguendo**, prima dell'invio

- ✅ il `.ps1` **parsa**: PowerShell 7.4.6 + `[Parser]::ParseFile` → **0 errori**,
  **10.285 token**; **ASCII puro** (0 byte non-ASCII, regola del 17/08);
  **non usa `$args`**; **0 collisioni case-insensitive** fra nomi di variabile
  (punto 79); **0 parametri orfani** e **0 variabili assegnate e mai rilette**
  (punto 97);
- ✅ **i quattro file prova sono ASCII puro** e passano tutti i gate:
  **controllo positivo eseguito PRIMA e DOPO** la batteria delle corruzioni;
- ✅ **e i gate sono stati fatti FALLIRE, uno per uno** — un gate che non scatta
  mai non è dimostrato. **VENTOTTO corruzioni, VENTOTTO fermate**, ognuna col
  messaggio giusto (l'elenco completo è nel referto di preparazione);
- ✅ **le tre tabelle, i gate di collaudo, i gemelli e la ricomposizione sono
  stati ESEGUITI** su un banco stubbato con **CSV sintetici che portano
  l'intestazione VERA dell'EA** (29 colonne), in **quattro scenari**: sano
  (0 problemi) / collaudo rotto (96 problemi, uno per gate per finestra) /
  gemelli diversi / **due corse vuote** (che non vengono scambiate per "banco
  deterministico");
- ✅ sul `.mq5`: **header a 29 nomi = 29 specificatori = 29 argomenti**,
  `stats[27]` con `stats[0..26]` **tutti assegnati e contigui**; graffe/tonde/
  quadre **bilanciate**; **scan delle ridichiarazioni nello stesso scope MQL5**
  (punto 98) → **zero**; **nessun input orfano** (33 su 33 usati); ASCII puro.

🟡 **Non verificato, e va detto**: tutto ciò che richiede **MT5** — la
**compilazione** dell'EA (qui non c'è MetaEditor), l'esito dell'**autotest**, il
comportamento del **flat sui tick veri**, **se i tick reali di EURUSD arrivino
davvero al 2024.07.05**, **se il tester legga davvero dal 2022.07.01** a M15, la
**durata** e **ogni singolo numero**. Il giro di controllo copre gli artefatti
**e la compilazione**; **i numeri li può dare solo la corsa**.

🔴 **E non è verificato il PIN**, perché non esiste ancora: vedi il riquadro rosso
in cima.
