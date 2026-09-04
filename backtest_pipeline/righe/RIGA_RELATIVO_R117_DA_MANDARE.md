# 🎯 RELATIVO — **R117: LA PRIMA MISURA DI MERITO, A TICK REALI** (la riga da mandare)

> ## ⚠️ QUI L'EA APRE ORDINI.
> Tutto quello che è girato finora su RELATIVO era un **contatore puro**
> (`ABTG_SondaRelativo`): zero ordini, zero lotti, zero magic. Da qui in poi gira
> `ABTG_Relativo`, che **manda ordini veri, calcola lotti, ha un magic e mette
> stop loss sul broker**. I due file condividono il **nucleo statistico riga per
> riga** — ed è proprio quella condivisione che il **collaudo del porto** (blocchi
> 2 e 3) va a verificare prima di ogni altra cosa.
>
> **Nel tester non si rischia niente. Ma questo `.ex5` è, da oggi, un file che
> sa aprire posizioni: non va messo su un grafico per sbaglio.**

**La domanda del round, in una riga:**

> *Lo scarto fra una gamba (D30EUR o NASUSD) e il metro U30USD, quando supera
> 1,35 sigma dentro la sessione americana, rientra abbastanza spesso — e
> abbastanza in fretta — da produrre `E ≥ 0,075R` per operazione **a tick reali,
> pagando lo spread vero del broker**?*

Il passo 0 (chiuso il 04/09) ha misurato **portata, taglia, geometria,
convergenza e tenuta** su 4 finestre × 49 celle e poi su 2 × 90. **Non ha mai
emesso un euro di P/L**, per costruzione. Questa è la **prima volta che si
guarda il conto**.

## 📋 LA CELLA, E DA DOVE VIENE

| | |
|---|---|
| **cella, per ENTRAMBE le gambe** | **`InpFinestraN = 40`, `InpSogliaIngressoSigma = 1.35`** — congelata |
| perché questa | è un vertice di un blocco 2×2 vivo su **tutte e quattro** le mappe (D30 L/S, NAS L/S) della griglia estesa a 90 celle, **interno su entrambi gli assi**, e ha **16 vicini ortogonali vivi su 16** |
| il pareggio fra i 4 vertici | rotto con due criteri dichiarati prima (più occasioni/giorno, C6 più basso): **N=40/σ=1,35 domina su entrambi e su entrambe le gambe** |
| **stop reale** | `InpAtrSL = 2.75` × ATR ≈ **47,1 pti su D30EUR**, **74,2 su NASUSD**. Deriva da **2 × MAE mediana misurata** (1,32-1,55 ATR) |
| **tetto giornaliero** | `InpMaxTradesPerDay = 5`. **Non è una preferenza, è aritmetica:** il passo 0 ha misurato **10 occasioni/giorno** su D30EUR, e 10 × 0,65% = **−6,50%**, che sfonda il muro prop giornaliero del 5% |
| rischio | **0,65%**, la taglia di campo: così il drawdown si legge contro il muro prop **senza scalature inferite** |
| magic | **774601** (D30) · **774602** (NAS) · 774611/774612 (gemelli) · 774603/774604 (porto). Blocco **7746xx verificato VERGINE** |

Dettaglio completo, con tutti i numeri e i rilievi:
`report/PROPOSTA_RELATIVO_TICK_REALI_2026-09-04.md`.

## 🔢 IL NUMERO CHE STA IN CIMA, PRIMA DI TUTTI GLI ALTRI

| | **D30EUR** | **NASUSD** |
|---|---:|---:|
| 1R proposto (2,75 × ATR) | **47,1 pti** | **74,2 pti** |
| MFE mediana in R (= **tetto** del guadagno) | 0,499 / 0,541 R | 0,501 / 0,497 R |
| **spread misurato** (ora peggiore) | **2,80 pti = 0,059 R** | **1,80 pti = 0,024 R** |
| **costo / cancello H8 (0,075R)** | 🔴 **79%** | 🟢 **32%** |
| **win rate che serve per pareggiare** | **68,7 – 70,7%** | **68,2 – 68,4%** |
| convergenza misurata al passo 0 | 80,3% | 82,0% |

> 🔮 **LA PREVISIONE, SCRITTA PRIMA DEI NUMERI (falsificabile):**
> 1. **NASUSD ha molte più probabilità di sopravvivere di D30EUR.** Non è
>    un'impressione: lo spread di NASUSD mangia un terzo del cancello, quello di
>    D30EUR ne mangia quattro quinti — e il DAX, dalle 17 server in poi, è **fuori
>    dal suo cash** per due terzi della nostra sessione.
> 2. **Il numero che decide il round è `guadagno realizzato per vincente / MFE
>    mediana`.** Sotto ~**0,70** la geometria non regge il costo. **È una colonna
>    obbligatoria**, e il referto la stampa da sola.
> 3. **Se il round muore, muore sul COSTO, non sul segnale** — e sarà un verdetto
>    pieno e utile.

## 🚦 SEI CORSE, E OGNUNA HA UN COMPITO DIVERSO (non sono sei tentativi)

| # | `-Prova` | gamba | magic | ruolo |
|---|---|---|---|---|
| 2 | `D30_PORTO` | D30EUR | 774603 | 🥇 **collaudo del porto** — `InpModoSonda=true`: **nessun ordine** |
| 3 | `NAS_PORTO` | NASUSD | 774604 | 🥇 **collaudo del porto** |
| 4 | `D30` | D30EUR | 774601 | **la misura** |
| 5 | `D30_GEM` | D30EUR | 774611 | **gemello di determinismo** |
| 6 | `NAS` | NASUSD | 774602 | **la misura** |
| 7 | `NAS_GEM` | NASUSD | 774612 | **gemello di determinismo** |

> ### 🥇 **IL COLLAUDO DEL PORTO — è il gate più importante, e va per primo**
> L'EA conta gli attraversamenti **grezzi** e non apre niente. Quel numero deve
> venire **identico** a `Attraversamenti Grezzi Long/Short` del passo 0, sulla
> stessa cella e sulla stessa finestra: **lo z-score si calcola su barre CHIUSE,
> e il modello di tick non lo tocca.** Se non combacia, il nucleo statistico è
> stato trasportato male e **tutto il resto del round non vuol dire niente.**
>
> ## 🛑 PRIMA DI LANCIARE I BLOCCHI 2 E 3, UNA COSA VA FATTA A MANO — **E ADESSO LA RIGA SI FERMA DA SOLA SE NON È STATA FATTA**
> Nella tabella `$PORTO` in testa a `RIGA_RELATIVO_R117.ps1` i due attesi
> valgono ancora **−1 / −1**. In **v1** questo faceva uscire la corsa **VERDE
> senza aver confrontato niente**, mentre questa pagina prometteva *"se il porto
> fallisce il round non parte"* — un esito che **non poteva mai verificarsi**.
> In **v2** c'è un **gate esplicito**: con `$PORTO` a −1 la corsa PORTO **non
> parte proprio**, e si ferma **prima** di aprire MT5 (a tick reali sono ore
> risparmiate). Il giro a vuoto `-SoloControllo` passa lo stesso, con un rilievo.
>
> ### 📄 Da dove si prendono i due numeri — **e dove NON stanno**
> - ✅ **Ci sono**: nel **CSV OPTFRAME del passo 0**, griglia **ESTESA**, riga
>   **N=40 / σ=1.35**, colonne `Attraversamenti Grezzi Long` e `... Short`.
>   File: `ABTG_SondaRelativo_D30EUR_IS_ohlc_D30_M5_EST.csv` e l'equivalente NAS,
>   dentro lo zip `RELATIVO_GRIGLIA_ESTESA_...` **sul tuo Desktop** (non è in repo).
> - ❌ **NON ci sono** nei referti archiviati
>   (`risultati_archivio/sondarelativo/REFERTO_D30_M5_ESTESA_...` e `..._NAS_...`),
>   e l'ho **verificato riga per riga**: la tabella delle 90 celle stampa
>   `ese/ggL` e `ese/ggS`, cioè gli **ESEGUIBILI per giorno** (**dopo** i filtri
>   di occupazione e tetto), e i **grezzi** li stampa **solo** per la cella di
>   riferimento **N=20 / σ=1.05** (D30 **2246/2374** su 441 giorni, NAS
>   **2419/2418** su 450 giorni). Grezzi ed eseguibili **sono due grandezze
>   diverse** e una **non si ricava** dall'altra: per questo la riga **blocca**
>   invece di inventarsi un atteso.
>
> **Cosa devi fare:** aprire quei due CSV, leggere la riga N=40/σ=1.35, scrivere i
> quattro numeri nella tabella `$PORTO`, **committare e ripinnare**. Oppure
> mandarmeli e li scrivo io.
>
> ⚠️ **La tolleranza non è zero, ed è dichiarata:** il passo 0 girava la finestra
> intera in una passata sola, qui il generico la spezza in IS e OOS e la passata
> OOS riparte col suo warmup. Intorno alla giuntura qualche attraversamento può
> mancare: tolleranza **0,5% dell'atteso, minimo 20** — e in **v2** si applica
> **a ciascun lato separatamente**, non alla somma: sulla sola somma uno **scambio
> compensativo** (un long in più e uno short in meno) passerebbe inosservato, ed è
> esattamente il difetto di trasporto che questo collaudo deve pescare.

> ### 👯 **I GEMELLI — perché due corse identiche non sono uno spreco**
> Due passate con gli **stessi input** e **magic diverso** devono venire
> **identiche al centesimo**. Se divergono, il banco è sporco e **nessun numero
> di questo round vale, per bello che sia.** Il confronto lo fa a macchina la
> **seconda corsa della coppia** (il CSV della prima è già in workdir): per
> questo l'ordine dei blocchi **4-5** e **6-7** non si inverte.

## 📏 I CANCELLI, CONGELATI PRIMA DEI NUMERI

Stanno **nella riga di lancio e nella pagina, NON dentro l'EA** — apposta: un
cancello scritto dentro il codice misurato è un cancello che si sposta con lui.
E la riga li **ricalcola dai numeri grezzi** invece di fidarsi di una colonna
già cucinata.

| # | soglia | da dove esce il numero |
|---|---|---|
| **A1** | `E` OOS **≥ 0,075 R**, a tick e **al netto** dei costi | FIRMA 2 del 31/08 (cancello H8) |
| **A2** | PF OOS **≥ 1,15** | cancello storico di casa 1,10 + margine di rumore |
| **A3** | segno del profitto **coerente** fra IS e OOS, e **PF IS > 1,00** | lezione USDJPY di R20: *IS rosso + OOS verde è la configurazione più pericolosa* |
| **A4** | DD equity OOS **≤ 8,0%** a rischio 0,65% | muro prop **10%** meno il 20% di margine |
| **A5** | peggior giornata **non peggiore di −4,0%** | a 4,0% il **Guardian mette in pausa**: una giornata peggiore descrive una giornata che **sul campo non sarebbe esistita** |
| **A6** | **n ≥ 150** in IS **e** in OOS | Emendamento della Finestra, regola A |
| **A7** | quota sotto 60 s **< 25%** | vincolo prop P5. A M5 **deve venire 0,00**: è un collaudo, non una scoperta |

**Bocciatura secca (basta una):** `E` < 0,050R · PF < 1,10 · IS negativo ·
**DD > 10,0%** · **peggior giornata < −5,0%**.
🔴 **Le ultime due bocciano PER RISCHIO, qualunque sia il PF e qualunque sia `n`:
il giudizio di rischio non si sospende mai** (Emendamento, regola B).
`n < 30` **non è una bocciatura**: è **non misurabile**.
Fra "passa" e "bocciata secca" c'è **sempre** una **zona morta** esplicita.

## 🚫 COSA QUESTO ROUND **NON** POTRÀ DIRE

1. ❌ **"Regge nel tempo".** I tick reali degli indici BCM partono dal
   **2024.09.26**: **un solo regime (toro)**. Emendamento regola C: **non
   soddisfatta**. → **Da questo round NON esce una sedia**, al massimo una
   **candidata**, e solo dopo una prova di rischio su un regime ostile e dopo il
   forward demo.
2. ❌ **"L'OOS lo conferma".** L'OOS **non è un vero out-of-sample**: la cella è
   stata scelta guardando una misura che copre l'intera finestra, OOS compreso.
   Attenuanti reali (punto interno e non picco; criteri del passo 0 **senza
   nessun P/L** dentro) ma non assolutorie. **L'unico vero out-of-sample sarà il
   forward demo.**
3. ❌ **"I numeri del passo 0 sono confermati".** Lo stop reale **cambia la
   popolazione** dei trade: tronca proprio quelli che sarebbero convergiuti dopo
   un'escursione profonda. È una **misura nuova**.
4. ❌ **"Basta allargare/stringere lo stop"** e rilanciare: sarebbe **pescare la
   geometria**. Sarebbe una tesi nuova, in un round nuovo, con criteri firmati
   prima.
5. ❌ **"D30EUR è pulito"**: porta un debito dichiarato (C2 = 12,93% di giorni
   spaiati al passo 0, e 1.057 buchi del metro contro 1 di NASUSD). **Qui non si
   filtra: si misura**, con tre colonne dedicate.

| | |
|---|---|
| **Driver** | `righe/RIGA_RELATIVO_R117.ps1` (marcatore `MARCATORE_RIGA_RELATIVO_R117_v2` — **v1 è bocciata dalla review del 04/09, non lanciarla**) |
| **EA** | `mql5/Experts/ABTG_Relativo.mq5` **v1.01** — **NUOVO, MAI COMPILATO**. Si compila qui: **se fallisce, QUELLO è il risultato del passo** |
| **File prova** | i 6 `prove/RELATIVO_R117_*.txt` (scaricati tutti, ne gira uno: gli altri servono al gemellaggio a SEI) |
| **Banco** | **Modello 4 = OGNI TICK, TICK REALI**. Finestra **2024.09.26 → 2026.06.30**, split **40/60** |
| **Dove** | **PC di backtest**, non VPS. **MT5 e MetaEditor CHIUSI** |
| 🔴 **RAM** | **MASSIMO 4 AGENTI.** A tick reali il vincolo vero non è il tetto delle barre, è la memoria (lezione del 01/09: *"no memory for ticks generating"* con 8 agenti su 16 GB). **La riga non può imporlo: lo imposti tu nel tester.** |
| **Prima di lanciare** | lo **storico di U30USD** dev'essere già nel terminale, o ogni barra risulta "spaiata" e il referto misura la configurazione invece del mercato |
| **Workdir** | `%USERPROFILE%\abtg_relativo_r117` — separata da quelle del passo 0 |

⏱️ **Quanto ci mette [STIMA, non una misura]:** a **tick reali** una passata su 21
mesi M5 è di **un altro ordine di grandezza** rispetto alle corse open-prices del
passo 0 (che facevano 49 passate in ~30 secondi). Non ho un numero misurato per
questo EA: **mettici il tempo che ci mette, e se sembra bloccato guarda che il
tester stia macinando invece di fermare tutto.** Il referto porta l'**ora di
avvio**, non quella di fine, apposta.

## 📌 IL PIN — **`@@PIN@@`** ⛔ SEGNAPOSTO, NON ANCORA SCELTO

⛔ **IL PIN VECCHIO (`983a0f2…`) NON VALE PIÙ**: puntava alla versione **v1**
della riga, quella bocciata dalla review del 04/09 (4 difetti bloccanti nel
driver + 2 nell'EA). **Non lanciarla.** Il pin nuovo si sceglie **dopo** il
commit dei fix e si verifica via `raw` prima di essere scritto qui — classe 101:
il segnaposto **si riscrive**, non si lascia.

| file al pin | cosa dovrà essere verificato prima di dichiararlo pronto |
|---|---|
| `backtest_pipeline/righe/RIGA_RELATIVO_R117.ps1` | 200 + sha256 identico · marcatore `MARCATORE_RIGA_RELATIVO_R117_v2` · **ASCII puro** · **parse 0 errori** · **0 usi di `$r` dopo la nascita di `$R`** (classe 79) |
| `mql5/Experts/ABTG_Relativo.mq5` | 200 + sha256 identico · `#property version "1.01"` · **20** blocchi autotest · `ABR_NSTATS` 73 (**76 colonne**) · **28** input · **1** `#include` (Trade.mqh) · **0** pattern per simbolo (hedge-safe) · ASCII puro |
| i **6** `backtest_pipeline/prove/RELATIVO_R117_*.txt` | **200 tutti e sei, identici** · 32 righe vive ciascuno · 28 input che **combaciano nome per nome** con quelli dell'EA · differenze reciproche: **solo `@SIMBOLO`, `InpMagic`, `InpModoSonda`** |
| `backtest_pipeline/walkforward_generico.ps1` | **200, identico** (`5d98af3d…`, invariato): il driver lo scarica al pin e lo ri-pinna sull'EA |

### 🧪 E LA RIGA È STATA **ESEGUITA**, NON SOLO LETTA (banco pwsh 7.4.6)

| prova a banco | esito |
|---|---|
| `GateProva` sui **sei** prova | **PASSATI**, 1 passata ciascuno |
| `GateGemelli` a sei | `VALIDO: differenze DICHIARATE trovate: InpMagic, InpModoSonda (più @SIMBOLO)` |
| **controprova**: magic sbagliato | **RIFIUTATO** — *"InpMagic è '774601', atteso '999999'"* |
| **controprova**: un prova del **passo 0** dato in pasto alla riga nuova | **RIFIUTATO** — *"il parametro 'InpBarreOrizzonte' NON è un input di ABTG_Relativo"* |
| cancelli di merito, **caso sano** | tutti e 7 `PASSA` → **PASSA TUTTI I CANCELLI A** |
| cancelli di merito, **DD 11,5% + peggior giornata −6,2%** | **BOCCIATA PER RISCHIO** *anche con `E` e PF verdi* — è l'Emendamento regola B che morde |
| collaudo dell'**eco dei pin** (CSV con N=20/σ=1,05) | **PROBLEMA**: *"IL PIN NON È PASSATO e la corsa ha misurato un'altra configurazione"* |
| sezione **RACCOLTA eseguita con lo stato PIENO** | referto completo, zip creato, `ESITO: CORSA COMPLETATO` |

> ### 🔴 UN DIFETTO TROVATO E CORRETTO — e vale la pena scriverlo
> La prima stesura del driver aveva un **`foreach($r in $RigheCancelli)` dentro
> la raccolta**: in PowerShell `$r` **è** `$R`, cioè **il referto**. È
> esattamente la **classe 79** che il verificatore di stringhe aveva trovato il
> 03/09 sulla riga della sonda, e l'avevo reintrodotta. Peggio: **lo scanner AST
> che avevo scritto per cercarla era cieco**, perché `Sort-Object -Unique` in
> PowerShell è **case-insensitive** e collassava `$r` e `$R` in un nome solo.
> Rifatto con `-CaseSensitive`, il difetto è saltato fuori al primo giro di
> banco (`does not contain a method named 'Add'`) ed è corretto. **Un gate che
> non può fallire non è un gate.**

> 🚧 **NON COPERTO dal banco** (e va dichiarato): la **compilazione** in
> MetaEditor, la **corsa vera** di MT5 a tick reali, **Windows PowerShell 5.1**
> (qui il parse è su pwsh 7), il comportamento del generico con `-Modello 4`, e
> la sezione **scelta del terminale**.

## 🩹 LA REVIEW DEL 04/09 — **v1 BOCCIATA, ECCO COSA È CAMBIATO IN v2**

Il verificatore di stringhe ha dato **FAIL** alla v1. Sette difetti reali, tutti
chiusi. Li scrivo tutti, anche quelli che fanno brutta figura: **un difetto
taciuto torna**.

### 🔴 Nel driver (4 bloccanti)

| # | il difetto | perché era grave |
|---|---|---|
| 1 | leggeva il `#define` **`REL_NSTATS`**, che è della **sonda**: nell'EA nuovo si chiama **`ABR_NSTATS`** | la riga **moriva sempre**, giro a vuoto compreso. Nascosto da un **secondo gate** che rigrepava lo stesso valore col nome giusto: ora si legge **una volta sola** |
| 2 | `$corsa.Periodo` **non esisteva**: la tabella `$CORSE` non dichiarava il campo | `$Periodo` era `$null` → il gate del tetto barre diceva **"OLTRE IL TETTO" sempre**. Ora il campo c'è su tutte e sei le corse, con una **guardia** che rifiuta un record monco (classe 121) |
| 3 | il CSV del **gemello** veniva rifiutato come "STANTIO" **sempre** | la guardia di freschezza era puntata su un file che **deve** essere della corsa precedente: i blocchi 5 e 7 davano **"PROBLEMI" falsi al 100%**. Ora la data si **dichiara nel referto** invece di far fallire il confronto |
| 4 | il **collaudo del porto** era spento (`-1/-1`) ma la corsa usciva **verde** | vedi il riquadro sopra: ora **gate bloccante prima di aprire MT5**, e i due lati si confrontano **separati** |

Più due rilievi minori chiusi: la **sentinella** ora si cancella **solo se è di
questo giro** (prima un giro fermato da un gate cancellava quella di un giro
precedente davvero interrotto), e il **titolo a schermo** non dice più
*"SONDA RELATIVO — PASSO 0, CONTATORE"* (era falso: qui l'EA apre ordini), come
non lo dice più la riga `pulizia:`, che adesso avverte che l'`.ex5` lasciato nel
terminale **sa aprire posizioni**.

### 🟠 Nell'EA — **due difetti che toccavano gli ordini veri** (`v1.00` → `v1.01`)

1. **Il flat di fine sessione dormiva.** Scattava solo dentro
   `ValutaBarraChiusa()`, che gira **a barra nuova**: fra l'ultima barra della
   sessione e la prima del giorno dopo **non arriva nessuna barra nuova**, quindi
   una posizione aperta restava viva **tutta la notte**, protetta dal solo stop.
   Aggiunto un **flat di recupero in testa a `OnTick()`**, con chiave di
   **calendario** (`anno*10000+mese*100+giorno`, mai `day_of_year`). ⚠️ Con una
   variante rispetto a quanto chiesto, e la dichiaro: se nella notte lo **stop**
   ha già chiuso la posizione, si **registra la chiusura per stop** invece di
   mandare una `PositionClose` su un ticket morto — che sarebbe un **rifiuto
   finto** e, peggio, lascerebbe `gTicket` vivo per sempre bloccando ogni
   ingresso successivo.
2. **Il collaudo A7 si autoinvalidava.** `gPosBarre` cresceva **solo** nel ramo
   "barra tenuta intera", non nei due rami che chiudono prima (stop scoperto fra
   due barre, e flat). Una posizione stoppata sulla **barra d'ingresso** finiva a
   registro con **tenuta 0 barre = 0 secondi**, cioè dentro la quota "sotto 60
   secondi" che A7 pretende a **0,00%**: **una sola** operazione così su ~400
   rendeva **l'intera gamba NON LEGGIBILE**. Ora `gPosBarre` si incrementa anche
   lì: la barra appena chiusa la posizione **l'ha vissuta**.

### 📎 DIFFERENZE NOTE fra il nucleo dell'EA e quello della sonda (dichiarate)

Il collaudo del porto verifica che i due producano gli **stessi grezzi**. Due
funzioni però **non sono identiche riga per riga**, ed è giusto scriverlo:

- **`AggiornaEscursione_Calc`** — nella sonda ha due rami espliciti
  (`lato>0` / `lato<0`), qui è rifattorizzata su un **ternario**. Numericamente
  identica per `lato = ±1` (autotest blocco 11 li collauda entrambi); l'unico
  caso divergente era `lato = 0`, che nella sonda è un no-op — ed è stato
  riportato a no-op anche qui, quindi **la differenza non esiste più**.
- **`GiorniMetroAttivi_Calc`** — la sonda ha in firma il flag `soloFinestra`,
  qui **cablato a `true`** perché l'unico chiamante lo passava già così. Il corpo,
  per `soloFinestra=true`, è **identico riga per riga**.

🟢 **Nessuna delle due tocca i grezzi né il segnale**: la prima misura MFE/MAE a
posizione già aperta, la seconda conta i giorni in cui il metro ha quotato (il
denominatore di C2). Il collaudo del porto resta quindi **pertinente**.

## 1️⃣ Giro a vuoto (`-SoloControllo`, con `-AccettoTettoBarre`: **serve anche qui**)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_RELATIVO_R117.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_RELATIVO_R117.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_RELATIVO_R117_v2' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova D30_PORTO -SoloControllo -AccettoTettoBarre; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'RELATIVO_R117_D30_PORTO_CONTROLLO_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP RELATIVO_R117_D30_PORTO_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI o FERMATA: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'GIRO A VUOTO: guarda solo che i sei gate passino e che la COMPILAZIONE riesca. NON ci sono numeri qui dentro.' -ForegroundColor Yellow }
```

## 2️⃣ 🥇 `D30_PORTO` — **IL COLLAUDO DEL PORTO. Se fallisce, il round finisce qui.**

> 🛑 **Questo blocco (e il 3️⃣) si ferma subito, con un errore esplicito, finché la
> tabella `$PORTO` vale −1/−1.** Non è un guasto: è il gate. Leggi il riquadro
> *"PRIMA DI LANCIARE I BLOCCHI 2 E 3"* qui sopra.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_RELATIVO_R117.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_RELATIVO_R117.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_RELATIVO_R117_v2' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova D30_PORTO -AccettoTettoBarre; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'RELATIVO_R117_D30_PORTO_2*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP RELATIVO_R117_D30_PORTO_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI o FERMATA: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'GUARDA SUBITO: la riga COLLAUDO DEL PORTO. Se e'' FALLITO, il round NON parte e le altre corse non si lanciano.' -ForegroundColor Yellow }
```

## 3️⃣ 🥇 `NAS_PORTO` — collaudo del porto sulla seconda gamba

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_RELATIVO_R117.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_RELATIVO_R117.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_RELATIVO_R117_v2' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova NAS_PORTO -AccettoTettoBarre; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'RELATIVO_R117_NAS_PORTO_2*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP RELATIVO_R117_NAS_PORTO_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI o FERMATA: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'GUARDA SUBITO: la riga COLLAUDO DEL PORTO.' -ForegroundColor Yellow }
```

## 4️⃣ `D30` — la misura su D30EUR (magic 774601)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_RELATIVO_R117.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_RELATIVO_R117.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_RELATIVO_R117_v2' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova D30 -AccettoTettoBarre; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'RELATIVO_R117_D30_2*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP RELATIVO_R117_D30_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI o FERMATA: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'GUARDA SUBITO: PROBLEMI = 0, poi i cancelli A. Il gemello si confrontera'' nel blocco dopo.' -ForegroundColor Yellow }
```

## 5️⃣ `D30_GEM` — il gemello di determinismo di D30 (magic 774611)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_RELATIVO_R117.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_RELATIVO_R117.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_RELATIVO_R117_v2' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova D30_GEM -AccettoTettoBarre; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'RELATIVO_R117_D30_GEM_2*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP RELATIVO_R117_D30_GEM_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI o FERMATA: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'GUARDA SUBITO: la riga IL GEMELLO DI DETERMINISMO. Se DIVERGONO, il banco e'' sporco e NESSUN numero vale.' -ForegroundColor Yellow }
```

## 6️⃣ `NAS` — la misura su NASUSD (magic 774602)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_RELATIVO_R117.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_RELATIVO_R117.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_RELATIVO_R117_v2' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova NAS -AccettoTettoBarre; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'RELATIVO_R117_NAS_2*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP RELATIVO_R117_NAS_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI o FERMATA: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'GUARDA SUBITO: PROBLEMI = 0, poi i cancelli A. Il gemello si confrontera'' nel blocco dopo.' -ForegroundColor Yellow }
```

## 7️⃣ `NAS_GEM` — il gemello di determinismo di NAS (magic 774612)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_RELATIVO_R117.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_RELATIVO_R117.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_RELATIVO_R117_v2' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Prova NAS_GEM -AccettoTettoBarre; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'RELATIVO_R117_NAS_GEM_2*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP RELATIVO_R117_NAS_GEM_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI o FERMATA: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'GUARDA SUBITO: la riga IL GEMELLO DI DETERMINISMO.' -ForegroundColor Yellow }
```

## 8️⃣ 📦 RACCOLTA FINALE — **un solo zip da mandare** (regola di casa delle righe di lancio)

```powershell
& { $ErrorActionPreference='Stop';
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if($c -and (Test-Path -LiteralPath $c)){ $d=$c; break } }; if(-not $d){ $d=$env:USERPROFILE };
    $stamp=(Get-Date).ToString('yyyyMMdd_HHmm'); $out=Join-Path $d ('RELATIVO_R117_TUTTO_'+$stamp); New-Item -ItemType Directory -Force -Path $out | Out-Null;
    $att=@('RELATIVO_R117_D30_PORTO_2*','RELATIVO_R117_NAS_PORTO_2*','RELATIVO_R117_D30_2*','RELATIVO_R117_D30_GEM_2*','RELATIVO_R117_NAS_2*','RELATIVO_R117_NAS_GEM_2*'); $trovati=0;
    foreach($m in $att){ $c=@(Get-ChildItem (Join-Path $d ($m+'.zip')) -EA SilentlyContinue | Sort-Object LastWriteTime -Descending);
      if($c.Count -gt 0){ Copy-Item $c[0].FullName -Destination $out -Force; $trovati++; Write-Host ('  TROVATO: '+$c[0].Name+'   ('+$c[0].LastWriteTime+')') -ForegroundColor Green }
      else { Write-Host ('  MANCA:   '+$m+'.zip -- quella corsa non e'' arrivata alla raccolta') -ForegroundColor Red } }
    $zip=$out+'.zip'; Remove-Item $zip -Force -EA SilentlyContinue; Compress-Archive -Path (Join-Path $out '*') -DestinationPath $zip -Force;
    Write-Host ''; Write-Host ('ZIP DA MANDARE IN CHAT: '+$zip) -ForegroundColor Cyan;
    Write-Host ('FILE ATTESI DENTRO: 6 zip di corsa. Trovati: '+$trovati+' su 6.') -ForegroundColor Gray;
    if($trovati -lt 6){ Write-Host 'ATTENZIONE: mandalo lo stesso, ma dimmi quale corsa e'' mancata e cosa ha stampato.' -ForegroundColor Yellow } }
```

## 📦 COSA TORNA (per corsa)

Zip sul Desktop **`RELATIVO_R117_<PROVA>_<timestamp>.zip`** →
`REFERTO_RELATIVO_R117_<PROVA>.txt` + `COMPILAZIONE.log` + il file prova +
**due CSV OPTFRAME** (`..._IS_<PROVA>.csv` e `..._OOS_<PROVA>.csv`, **una riga
ciascuno**, 76 colonne + gli input accodati dal tester).

**Le righe da guardare per prime, in questo ordine:**

1. **`compilazione:`** — è un EA nuovo. Se è FALLITA, quello è il risultato.
2. **`COLLAUDO DEL PORTO`** (blocchi 2-3) — se FALLITO, il round finisce lì.
3. **`IL GEMELLO DI DETERMINISMO`** (blocchi 5 e 7) — se DIVERGONO, banco sporco.
4. **`PROBLEMI: 0`** — un solo collaudo di sanità fallito = **non leggibile**.
5. **`ECO DEI PIN`** — se N non è 40 o σ non è 1,35, **il pin non è passato** e la
   corsa ha misurato un'altra configurazione.
6. E **solo dopo**: `I CANCELLI DI MERITO` e il verdetto della gamba.

## 🔜 COSA SUCCEDE DOPO

- 🟢 **Se una gamba passa tutti i cancelli A**: si scrive *"la convergenza del
  rapporto ha aspettativa positiva a tick reali su \<gamba\>, **su un solo
  regime**"* → si chiede la **prova di rischio su un regime ostile**.
  **Nessuna sedia, nessun forward, ancora.**
- 🟠 **Se passa una gamba sola**: **non è "il motore funziona"**. Si scrive quale,
  e la gamba morta **resta morta** (lezione PTE: GBPUSD sì, USDJPY no).
- 🔴 **Se non passa nessuna gamba**: **il meccanismo non ha edge a tick reali su
  questa finestra.** Verdetto **pieno e valido** — ed è l'esito che la previsione
  scritta sopra considera probabile su D30EUR.
- ⛔ **Se un gate di sanità è rosso**: *"il banco non ha prodotto la misura"*.
  **È vietato scriverlo come se fosse un verdetto sull'edge.**
