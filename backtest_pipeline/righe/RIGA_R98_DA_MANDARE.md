# 🚀 R98 — LA RIGA DA MANDARE (Market Intraday Momentum su NASUSD)

_Scritta il 22/08/2026 notte. **Non è ancora passata dal verificatore**: prima
il giro dal verificatore, poi Claudio._

Criteri: `backtest_pipeline/risultati_archivio/R98_CRITERI.md` — **FIRMATI il
22/08/2026 sera** ("PF 1,20 + cancello spread" = **opzione A** del §5.1), a
numeri di R98 mai visti. Questa riga **non cambia i criteri**: li traduce in
file eseguibili.

---

## 📌 IL PIN — `81d1314d11d008c069f079a008494f0e1c2cf62b`

È il commit che contiene **questo** driver e gli **otto** file prova
(checklist 4: se il commit del file fosse più nuovo del SHA scritto qui, il SHA
sarebbe una bugia). Il driver **ri-pinna da solo** anche i due gemelli che
scaricano l'EA per conto proprio (`walkforward_generico.ps1` e
`scarica_storico.ps1` hanno `$EABranch = "lavoro"` scritto fisso e
riscaricherebbero il `.mq5` dalla **punta** del branch — difetto 24), e
**verifica lo stato finale** invece di fidarsi del replace.

Verificato a tavolino, su questo commit, **scaricando davvero i sette file
dalla `raw.githubusercontent` al pin** (tutti `200`), che i marcatori che il
driver pretende esistano:

| file | marcatore preteso | esito |
|---|---|---|
| `walkforward_generico.ps1` | `RigaSpread`, **due** `[Experts]` a inizio riga, `$EABranch="lavoro"` | ✅ 4 / 2 / 1 |
| `scarica_storico.ps1` | `REFERTO STORICO`, `AllowLiveTrading=false`, `$EABranch = "lavoro"` | ✅ (con gli spazi: la regex del driver è `\$EABranch\s*=\s*"lavoro"`) |
| `ABTG_PausaGuardian.mqh` | `ABTG_GuardiaIngresso`, ≥ 4.000 byte | ✅ 53.840 byte |
| `ABTG_IntradayMomentum.mq5` | `MIM_DecisioneGiornata`, `[A1][AUTOTEST]`, `#property version "1.00"`, `InpMagic = 772800` | ✅ |
| gli 8 file prova | `@SIMBOLO`, **30 righe vive** | ✅ misurate, non ricordate |

---

## ⛔ PRIMA DI LANCIARE — traffico e prerequisiti

- **UNA MACCHINA, UN LAVORO.** Il PC di backtest ha **un solo MT5**: prima di
  lanciare, dichiarare che non c'è nessun altro round in corso.
- **MT5 E METAEDITOR CHIUSI.** Lo script si rifiuta di partire se li trova
  aperti (col terminale aperto il tester non gira → zero CSV; con MetaEditor
  aperto `metaeditor64 /compile` torna subito senza compilare).
- **Lo script tocca il terminale di backtest**: ci copia
  `ABTG_IntradayMomentum.mq5` (v1.00) e `ABTG_PausaGuardian.mqh`, **ricompila**
  l'`.ex5` e svuota `Tester\cache`. Fa il **backup datato** di `.mq5` e `.ex5`
  prima di toccarli e, se la compilazione fallisce, **rimette a posto il
  sorgente** (checklist 54). Non tocca `bases\<server>\ticks`.
- **Non tocca nessuna sedia viva**: usa il blocco `7728xx` (che è il magic
  dell'EA, §0 dei criteri) e cancella i per-trade **solo dei propri magic, per
  nome**. Vietati e controllati nel codice: **770611** (ORB vivo sul Dow),
  **770601**, **770201**.
- Durata stimata: **2–4 ore** (34 passate a tick reali; riferimento R97 sullo
  stesso simbolo e sulla stessa finestra: 16 passate). Il PASSO 0 misura una
  passata intera e stampa la stima. `-OreMax` è **10** (in R97 era 8: qui le
  passate sono il doppio).

---

## 1️⃣ PRIMA il giro a vuoto (~1 minuto, nessuna passata di test)

> ⚠️ **Non è a costo zero sul terminale**: il giro a vuoto scarica 12 file,
> **installa `ABTG_PausaGuardian.mqh`**, **ricompila
> `ABTG_IntradayMomentum.ex5`** con MetaEditor (con backup datato di `.mq5` e
> `.ex5`) e poi chiama otto volte il driver generico. Quello che **non** fa è
> aprire MT5 per testare: **zero passate, zero CSV, cache del tester NON
> svuotata, nessun per-trade cancellato.**

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='81d1314d11d008c069f079a008494f0e1c2cf62b'; $p="$env:USERPROFILE\RIGA_R98.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R98_MOMENTUM_NASUSD.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R98_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo; if($LASTEXITCODE -ne 0){ Write-Host 'CONTROLLO NON PASSATO: leggi il REFERTO' -ForegroundColor Yellow } }
```

**Cosa deve dire** (altrimenti la corsa vera non parte):
- `anteprime .ini in sosta: 8 su 8`;
- **nessun PROBLEMA in elenco**. Il giro a vuoto ora **legge** le anteprime,
  non le archivia soltanto: verifica che la finestra IS calcolata dal driver
  generico sia `2024.09.26 – 2025.06.09`, che l'**unico** asse spazzolato sia
  `InpMagic` (= 2 celle per finestra) e che il magic sia quello del file;
- `ESITO: GIRO A VUOTO COMPLETATO`.

> ⚠️ **Quello che il giro a vuoto NON può fare, detto prima.** I criteri §2.1
> dicono *"va confermata con `-SoloControllo`"* parlando del canarino (n IS
> ~180, **[INFERITO]**). **`-SoloControllo` non apre MT5, quindi non esiste
> nessun `n` da leggere**: può confermare gli **artefatti** (file prova,
> finestre, celle, magic, ini), non i **numeri**. Il canarino lo **misura** il
> PASSO 0 della corsa vera, contando le operazioni per data sul per-trade
> della passata intera — ed è scritto sia a schermo sia nel referto, in
> entrambi i modi, perché non si scambi l'uno per l'altro.

## 2️⃣ POI la corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='81d1314d11d008c069f079a008494f0e1c2cf62b'; $p="$env:USERPROFILE\RIGA_R98.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R98_MOMENTUM_NASUSD.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R98_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**, è un comando solo (checklist 21): tre righe
staccate sarebbero tre comandi indipendenti e un `throw` alla prima non
fermerebbe le altre.

---

## 🛑 IL PASSO 0 DI R98 — cosa misura, e cosa può fermare

Il PASSO 0 sono **due passate singole gemelle della cella NUDA su TUTTA la
finestra** (magic `772890/772891`, `InpVerbose=1`). Ne escono **quattro** cose,
in quest'ordine.

### (a) 🔴 IL GATE FATALE: l'autotest (§3.3)
Le righe `[A1][AUTOTEST]` devono esserci e **nessuna** deve portare
`*** FAIL ***`. **Se compare un FAIL, i risultati non si leggono nemmeno.**

- Il parser cerca la forma che il **sorgente** scrive — `(ok ? "PASS" : "*** FAIL ***")` —
  e porta con sé il **controllo positivo** sui `PASS` (checklist 55: *"0
  falliti" e "0 righe capite" non possono finire nello stesso ramo*). Un
  `-match 'FAIL'` darebbe **12 falsi allarmi** (i nomi dei casi del Guardian
  contengono `FAIL-OPEN`); un `'FAIL$'` non matcherebbe **mai**. Difetto pagato
  il 22/08, non ripetuto.
- **Il numero atteso è 45 × 2 = 90**, non 45: l'autotest lo stampa `OnInit` e
  le passate sono due. Il gate accetta i **multipli** di 45 e segnala un
  numero che multiplo non è (righe perse o sorgente cambiato).
- I 45 casi sono **contati nel sorgente** (4 + 11 + 5 + 8 + 5 + 12), non
  ricordati.

### (b) I gate di sempre
`G1` per-trade esiste, è di **adesso** ed è popolato · `G2` prima operazione
entro il **2024.12.31** (un motore che opera una volta al giorno deve aver
tradato nei primi tre mesi) · `G3` i due gemelli sono **identici**.

### (c) 🐤 IL CANARINO (§2.1) — **misurato, e NON blocca**
n IS e n OOS contati **per data** sul per-trade della passata intera.

> **Comportamento dichiarato**: se `n IS < 100` la corsa **segnala e prosegue**.
> Emendamento **regola B** — *il campione sottile sospende il giudizio sul
> MERITO, mai sul RISCHIO*. Il canarino cambia **come** si legge il round, non
> **se** si legge. E il `n` va scritto **accanto a ogni numero**.
> Il `n` è quello della **cella nuda**: le celle b (secondo segnale) e c
> (soglia) operano **di meno per costruzione**, e il loro `n` vero sta nei loro
> CSV.

### (d) 🔴 IL CANCELLO ZERO S0 (§3.2) — **metà misurata, metà a mano**

Il criterio firmato è: **lordo medio/operazione ≥ 3× lo spread medio della
fascia 20:30–21:00 server**. Lo script misura la parte che **può** misurare, e
non inventa l'altra:

| | |
|---|---|
| **misurato** | il **risultato medio per operazione in PUNTI INDICE**, accoppiando i prezzi d'**ingresso** (che l'EA stampa nel log con `InpVerbose=1`) coi prezzi d'**uscita** (colonna `price` del per-trade). L'accoppiamento ha il suo **controllo positivo**: la direzione letta nel log dev'essere l'opposto del `deal_type` di uscita, riga per riga. Se non torna, **non si misura niente** |
| **non misurato** | lo **spread storico della fascia**: non è leggibile da PowerShell (sta dentro i tick binari di MT5), e `Spread=0` nell'`.ini` vuol dire "spread corrente del feed", **non è una misura** |

**L'algebra che rende la cosa utile lo stesso** (ed è scritta nel referto): il
risultato misurato è **netto** dello spread (si entra all'ask, si esce al bid),
quindi `lordo = netto + spread`. Allora

> `lordo ≥ 3 × spread` ⟺ **`netto ≥ 2 × spread`** ⟺ **S0 è superato se lo
> spread medio della fascia è ≤ (risultato medio) / 2**.

Il referto stampa quel numero **in punti indice e in punti MT5** (conversione
100, da R97) e chiude con **`S0 = DA MISURARE A MANO`** e tre metodi, in ordine
di onestà:

1. MT5 aperto, grafico `NASUSD` M1, indicatore **Spread** di sistema, barre fra
   le 20:30 e le 21:00 **server** per qualche settimana → è lo spread di
   **oggi**, non quello del 2024, e va detto;
2. **Specifica del simbolo / Finestra Dati** → spread corrente e tipico
   dichiarati dal broker. Idem, è oggi;
3. la misura **vera** sullo storico chiede uno **script MQL5** che scorra i
   tick della fascia e faccia la media di `(ask − bid)`: **non esiste ancora in
   casa**. Se il round arriva a dipendere da quel numero, si scrive quello
   script e si rifà un giro dal verificatore — **non si stima a occhio**.

⚠️ Se il risultato medio per operazione uscisse **≤ 0 punti indice**, S0 **non
può essere superato con nessuno spread positivo** ed è una **bocciatura secca**
(§5.2). È una **risposta** del round, non un guasto: la corsa **prosegue** e
produce tutti i CSV (checklist 26-bis).

### 🔵 La conversione dei punti: **citata, non rimisurata**
`1 punto indice = 100 punti MT5` su NASUSD è **già misurata e agli atti** in
R97 (`R97_REFERTO` §3: due misure indipendenti concordi, 1.960 ordini in modo
FIXED e `digits=2` del per-trade). Stesso simbolo, stesso broker, stessa
finestra: rimisurarla sarebbe **un'ora di macchina per riconfermare un numero
che è già firmato**. Serve qui a due cose: `InpSlippagePts=100` della cella
**R98e** vale **1 punto indice**, e i punti indice del cancello zero si
convertono in punti MT5.

---

## 📦 FILE ATTESI DI RITORNO

Sul Desktop: cartella e zip `R98_MOMENTUM_NASUSD_<MODO>_<data>_<ora>` (`MODO` =
`CORSA` / `CONTROLLO` / `SENZAPASSO0`). **È lo zip che si manda.**

Dentro lo zip, corsa completa:

| file | quanti | nota |
|---|---|---|
| `REFERTO_R98.txt` | 1 | la riga `data:` dev'essere di **adesso**; la riga `modo:` dice se è il round o un giro a vuoto; in testa c'è **l'autotest**, poi il **cancello zero** e il **canarino** |
| `ABTG_IntradayMomentum_NASUSD_IS_r98rif.csv` (+ `_OOS_`) | 2 | 2 righe l'uno (le due passate gemelle) |
| `..._r98a` · `..._r98b` · `..._r98c` · `..._r98d` · `..._r98e` IS/OOS | 10 | idem |
| `..._r98dnolong` · `..._r98dnoshort` IS/OOS | 4 | le **diagnostiche**: non sono celle |
| `passo0_pertrade_772890.csv` / `..._772891.csv` | 2 | i gemelli del PASSO 0: devono essere identici, e **coprono TUTTA la finestra** |
| `passo0_a.ini` / `passo0_b.ini` | 2 | la prova cartacea di cosa ha girato nel PASSO 0 |
| `abtg_trades_ABTG_IntradayMomentum_NASUSD_7728xx.csv` | fino a 16 | i per-trade delle celle — ⚠️ **coprono SOLO la finestra OOS**: l'EA riscrive lo stesso nome a ogni passata e le finestre girano IS *poi* OOS. **Non sono la serie completa del round** e non si usano così per un DD di portafoglio. Il referto lo dichiara |
| `compile_r98.log` | 0 o 1 | c'è se MetaEditor ha scritto un log |

**Totale CSV di round attesi: 16** (8 file × IS/OOS), **2 righe ciascuno**,
**32 passate**, più le **2** del PASSO 0.

Se un file manca, si vede **prima** di mandare lo zip: l'elenco lo stampa anche
la console a fine corsa.

---

## 🔎 COME SI LEGGE, IN ORDINE (è scritto anche dentro il referto)

1. **l'AUTOTEST**: un solo `*** FAIL ***` e i numeri sotto non si leggono
   nemmeno — si guarda il **codice**;
2. **il CANCELLO ZERO S0**: è il primo cancello e quello che fa il lavoro
   pesante (lo dice la firma del 22/08). Finché lo spread della fascia non è
   **misurato**, S0 non è deciso — e **senza S0 nessun PF vuol dire niente**,
   perché un PF calcolato su un lordo che non copre i costi è una promessa che
   il conto vero non mantiene;
3. **il CANARINO**: `n IS` e `n OOS` accanto a **ogni** numero. Sotto 100 in IS
   → **MERITO SOSPESO**, si legge il **RISCHIO** (regola B);
4. **la cella NUDA (`r98rif`) per prima e da sola**: è il paper letterale ed è
   il metro di tutte le altre. Si scrive **prima** di guardare a/b/c/d/e;
5. i cancelli **S1–S4**: DD OOS ≤ 7,00% · **PF OOS ≥ 1,20** (opzione A firmata:
   questo motore **non ha TP**, il payoff è simmetrico, e chiedere 1,40 sarebbe
   un'unità di misura sbagliata) · IS profit > 0 e PF IS ≥ 1,10 · n OOS ≥ 150 e
   n IS ≥ 150;
6. le **bocciature secche** (§5.2): profitto netto ≤ 0 in OOS · S0 fallito ·
   peggior giornata peggio di −2,5% al rischio 1% (che è un **BUG**, non un
   risultato: si guarda il codice, non si tara). Il referto stampa già la
   peggior operazione in % del deposito, **[approssimata sul deposito
   iniziale]**;
7. **R98e non è promuovibile**: è una misura di **fragilità**;
8. **le due diagnostiche sui lati non entrano in nessun cancello.** Malattia
   R52: un lato non si spegne **mai** guardando i risultati. E il regime è
   **rialzista**: un "solo long" che brilla non ha dimostrato niente sul lato,
   ha dimostrato il regime;
9. **regime: uno solo** (indici USA 2024-2026). Il paper dichiara che la
   predittività **sale** nei giorni volatili e in recessione: se il nostro
   regime è calmo, R98 misura il caso **sfavorevole** al motore. Va scritto in
   **entrambe** le direzioni;
10. **R98 non produce sedie** (§6): al massimo una **proposta** di round di
    deploy. E un **verdetto negativo pulito vale quanto uno positivo**.

---

## 🧾 LE SCELTE FATTE, DICHIARATE (e cosa è una traduzione, non un criterio)

**Prese dai criteri, senza margine:** simbolo `NASUSD`, TF `M5`, finestra
`@DAQUANDO 2024.09.26 → 2026.06.30`, split 40/60, deposito **100.000**, rischio
**1,00%**, le 6 celle del §4, le 2 diagnostiche del §4.1, i cancelli del §5, il
gate dell'autotest del §3.3, gli orari **in ora server**.

**Scelte di traduzione, motivate qui perché i criteri non le scrivono o le
lasciano aperte:**

| scelta | valore | perché |
|---|---|---|
| **Model** | **4 = tick reali** | i criteri non lo scrivono. R98 va confrontato con R97 **sullo stesso simbolo e sulla stessa finestra**, che è a tick reali; e questo motore vive di **30 minuti al giorno**, cioè proprio dove uno scan OHLC mente di più. **[DA CONFERMARE CON CLAUDIO: vuole prima uno scan OHLC?]** |
| magic del **PASSO 0** | `772890/91`, **non** `772800` | il §3.2 propone di leggere il per-trade di `772800` ma su quel punto dice esplicitamente **`[DA DECIDERE]`**. Le due fasi **non condividono il magic** (checklist 41, pagato in R82): le passate della griglia riscriverebbero il per-trade su cui il gate ha dato il via libera. **Stessa identica cella**, solo un altro numero |
| magic delle celle | `772800/01` (nuda) · `772820/21` · `772830/31` · `772840/41` · `772850/51` · `772860/61` · `772870/71` e `772880/81` (diagnostiche) | il `772800` è **il magic dell'EA** (§0). Il blocco `7728xx` non compare in `CONTRATTI_SEDIE.md` / `FLOTTA_ATTIVA.md`. ⚠️ **`772801` e `772811` compaiono in due file prova di R55** (`R55a_slippage_PTE.txt`, `R55b_slippage_ORB.txt`): **altro EA e altro simbolo**, e i per-trade si chiamano `abtg_trades_<EA>_<SIM>_<magic>.csv` → **file diversi, nessuna sovrascrittura**. Per prudenza le altre celle partono da `772820` e **saltano** la decina di `772810` |
| `InpVerbose` nei file prova | **0** (la bozza §7 scriveva 1) | in una griglia **le Print non le legge nessuno** (checklist 34) e su 32 passate a tick reali sono solo zavorra. Il PASSO 0 lo **accende a 1** nella sua passata singola — ed è lì che servono, perché è da quelle righe che si leggono i prezzi d'ingresso del **cancello zero**. **Non cambia una virgola del comportamento di trading.** Il §7 è una **bozza**: la firma copre §2, §3.2, §4, §5.1, §5.2 |
| forma dei pin | `Nome=valore` secco invece di `v\|\|v\|\|0\|\|v\|\|N` | è il driver generico a convertirli lui in forma completa (`walkforward_generico.ps1` righe 405-411, col commento che spiega perché la forma completa serve). Effetto **identico**, e il file resta leggibile |
| righe **in più** rispetto alla bozza §7 | `InpEntryWindowMin`, `InpExitSafetyMin`, `InpMaxGiorniIndietro`, `InpAllowLong/Short`, `InpUseStopLoss`, `InpAtrTF`, `InpAtrPeriod`, `InpUseNewsFilter`, `InpUsaGuardian`, `InpMaxSpread` | tutte **pinnate al default del sorgente**: non cambiano niente, ma stanno **scritte nell'artefatto che gira** invece che dedotte. `InpAllowLong/Short` servono in più alle **due diagnostiche**, e `InpAtrTF=30` è `PERIOD_M30` secondo la tabella degli enum del driver generico |
| 30 righe vive per file | misurate, non ricordate | `grep -vE '^\s*(#\|$)' \| wc -l` su tutti e otto |
| spread | `Spread=0` nell'`.ini` | = spread **corrente**, ma **dichiarato** invece che lasciato allo stato nascosto del terminale. **Non è uno stress e non è la misura che chiede S0** |
| tick | **non riscaricati** | già misurati e agli atti: NASUSD **164.636.788 dal 2024.09.26** (`REFERTO_R83_R84_PREPARAZIONE.md` riga 620). Si scaricano solo le **barre M1+M5** — e le M1 qui servono davvero: l'EA misura le mezz'ore con `CopyRates` su M1 |
| `-OreMax` | **10** (R97: 8) | qui le passate sono 34 invece di 16. È un tetto sull'**inizio** di nuovi file, non un'interruzione |
| `-SaltaPasso0` | esiste, **sconsigliato** | serve solo a riprendere una coda già gatata. Se usato, il referto dichiara in rosso che **il gate dell'autotest non è stato eseguito in quella corsa**, e con lui il canarino e il cancello zero |

> 🛑 **`Model=4` NON è un parametro della riga: è una COSTANTE dello script**
> (`RIGA_R98_MOMENTUM_NASUSD.ps1`, `$Modello = 4`). **Non provare a passare
> `-Modello 1`: quel parametro non esiste e la riga si ferma con un errore di
> binding.** E non è una svista da riparare al volo: a Model diverso da 4 il
> driver generico aggiunge il suffisso `_ohlc` ai nomi dei CSV, che la raccolta
> di R98 **non** cerca — uscirebbe un round intero raccolto a vuoto. Se Claudio
> vuole prima uno scan OHLC, si cambia la costante, si **ricommitta**, si
> **ri-pinna** e si **rifà il giro dal verificatore**.

> ⚠️ **Una cosa che i criteri nominano e questo round NON misura: lo SPREAD.**
> Il cancello zero S0 è **firmato** ed è il cancello che fa il lavoro pesante,
> ma metà del suo confronto (lo spread medio della fascia) **non è misurabile
> da questa riga**. Il round produce tutto il resto e lascia quel numero
> **esplicitamente vuoto**, con le istruzioni. **Un S0 "stimato a occhio"
> sarebbe peggio di un S0 mancante**, perché entrerebbe in un verdetto firmato
> travestito da misura.

**Nessun dettaglio è stato inventato**: dove i criteri tacevano (Model) o
dicevano `[DA DECIDERE]` (magic del PASSO 0, metodo dello spread) la scelta è
dichiarata qui sopra con la sua ragione.

---

## 🔁 SE SERVE RILANCIARE UNA CELLA SOLA

`walkforward_generico.ps1` **salta le finestre il cui CSV esiste già**: un
rilancio senza `-Rifai` non rifà niente e stampa tutto verde (checklist 15).
Per rifare davvero: aggiungere **`-Rifai`**. Lo script marca comunque i file
ripresi come `SALTATO DAL DRIVER` / `A META'` e li mette nei **PROBLEMI**, non
in OK.
