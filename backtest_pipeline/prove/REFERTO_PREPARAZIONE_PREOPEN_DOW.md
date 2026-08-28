# 🧾 REFERTO DI PREPARAZIONE — **PREOPEN DOW** (il livello pre-apertura)

_28/08/2026 — preparazione, **non** una corsa. **Nessun numero di mercato in
questo documento**: qui non c'è MT5, e niente è stato misurato sul banco._

---

## 🛑 LA COSA PIÙ IMPORTANTE, IN CIMA

> **Questo round ha CRITERI DI MERITO GIÀ CONGELATI.** Non è un
> conta-operazioni come i tre giri preparati oggi (G1PAOLO, VWAPREV, FVGRET).
> Il file prova `prove/PREOPEN_RETEST_DOW_M15.txt` porta in testa il cartello
> **«NON DEVE GIRARE FINCHÉ I CRITERI NON SONO FIRMATI»**.
>
> 👉 **Claudio deve leggere e confermare** le sezioni **`COME PUÒ MORIRE`** e
> **`CRITERI DI ACCETTAZIONE`** di quel file **prima** di lanciare, e
> approvare le **tre interpretazioni** elencate nella pagina di lancio.
> La riga è pronta, ma **lanciarla a scatola chiusa produce un verdetto che
> non si sa leggere**.

📬 **Il blocco da incollare sta in una sola pagina, ed è quella la fonte viva:**
### 👉 `backtest_pipeline/righe/RIGA_PREOPEN_DOW_DA_MANDARE.md`

_(Qui **non** c'è nessuna copia del blocco di lancio, ed è voluto: un domani un
fix cambia il pin nella pagina e una copia incollata in un referto resterebbe
per sempre alla versione vecchia — funzionante e sbagliata. CHECKLIST punto
100.)_

---

## 1. 🔧 Zero codice EA scritto — ed è il punto

`ABTG_Dow_Apertura_US.mq5` **non è stato toccato**. L'interruttore che questo
round misura **esiste dal primo giorno**:

- `ComputeLevels()` ha tre rami; con `InpRangeMode = ABTG_RANGE_PREV (1)` la
  finestra del livello è `openMin − InpPrevWindowMin … openMin`, cioè
  **esattamente il pre-market range**;
- `InpCloseAtEnd=1` + `InpCloseHour/Min` = **mai overnight**, che era il
  requisito del mandato;
- l'ingresso resta il **RETEST** (`InpEntryMode=2`), che è **già** la modalità
  della sedia viva.

**Conteggio fatto nel repo, non ipotizzato:** su 48 file prova **47 pinnano
`InpRangeMode` a 0**, e `InpPrevWindowMin` è pinnato a **60 in 28 file su 28**
— **mai mosso**. È un pezzo di macchina **pagato e mai usato**.

📌 **Un fatto meccanico che vale la pena sapere prima:** con `RangeMode=1` il
retest **si arma alle 14:30** (server BCM) invece che alle **15:05**, perché
`refEndMin` diventa `openMin` invece di `openMin+InpRangeMinutes`. La finestra
operativa quindi **si allunga di 35 minuti**: parte del delta che il round
misurerà **non è "il livello", è "più tempo"**. Va detto quando si leggono i
numeri.

---

## 2. 📁 Cosa ho preparato

| file | ruolo |
|---|---|
| `prove/PREOPEN_RETEST_DOW_M15_SHORT.txt` | **gemello SHORT** (regola dei due lati, 25/08). Magic `773600/773601` |
| `prove/PREOPEN_METRO_DOW_M15.txt` | **METRO 0c** su M15, lato long. Magic `773700/773701` |
| `prove/PREOPEN_METRO_DOW_M15_SHORT.txt` | **METRO 0c** su M15, lato short. Magic `773800/773801` |
| `prove/PREOPEN_COSTO_DOW_M15.txt` | la cella del **cancello del costo** (0b). Magic `773900/773901` |
| `righe/RIGA_PREOPEN_DOW.ps1` | il driver (marcatore `MARCATORE_RIGA_PREOPEN_DOW_v1`) |
| `righe/RIGA_PREOPEN_DOW_DA_MANDARE.md` | **la pagina di lancio — unica fonte viva del blocco** |

### 🧬 I quattro file della griglia/metro sono **gemelli verificati**

Tutti e cinque hanno **esattamente 75 righe vive** (72 parametri + 3 direttive
`@`), e il diff fra loro è **solo** quello dichiarato:

| confronto | righe che differiscono |
|---|---|
| LONG ↔ SHORT | `InpAllowLong`, `InpAllowShort`, `InpMagic` |
| LONG ↔ METRO long | `InpRangeMode`, `InpPrevWindowMin`, `InpMagic` |
| SHORT ↔ METRO short | `InpRangeMode`, `InpPrevWindowMin`, `InpMagic` |
| METRO long ↔ METRO short | `InpAllowLong`, `InpAllowShort`, `InpMagic` |
| LONG ↔ COSTO | `InpPrevWindowMin`, `InpRetestOffsetPts`, `InpMagic` |

**E il driver lo ri-verifica da solo prima di aprire MT5** (gate della stella,
confronto **per nome** e non per posizione).

### ❓ Perché DUE metri e non uno

Il mandato ne chiedeva uno. Ma il criterio firmato dice *«la regione deve
BATTERE il metro di +0,10 di PF»* **e** la regola dei due lati rende il gemello
short obbligatorio: senza un metro **short**, il lato short avrebbe un numero e
**nessun denominatore**, cioè **non sarebbe giudicabile**. Costa **6 passate per
finestra**: è la spesa più piccola di tutto il giro. Se non lo vuoi, si toglie.

### 🎯 Perché il METRO pinna `InpPrevWindowMin` invece di spazzolarlo

Con `RangeMode=0` quel parametro è **inerte** — letto nel sorgente:
`ComputeLevels()` lo usa **solo** nel ramo `ABTG_RANGE_PREV`, e l'unica altra
funzione che lo legge (`OpeningBodyDir()`) serve solo a `TryPlaceDelayed()`,
che qui non gira (`InpEntryMode=2`). Spazzolarlo darebbe **cinque righe
identiche per ogni offset**: 5× la macchina per zero informazione, e un lettore
distratto crederebbe di guardare una griglia dove non c'è.

---

## 3. 🚧 Il cancello del costo: perché è una **passata singola** e non una colonna

Il take in punti indice si calcola dal **prezzo d'ingresso** e da quello
d'uscita. **Nessuno dei due esce dal CSV dell'ottimizzazione** (OPTFRAME
esporta profitto, PF, DD, n, peggior giornata — non i prezzi), e l'export
per-trade dell'EA (`abtg_trades_*.csv`) esporta **solo i deal di uscita**,
quindi **non ha il prezzo d'ingresso**. L'unico artefatto che ha tutti e due i
prezzi è il **report `.htm` di una passata singola** — lo stesso strumento con
cui **R109** ha misurato lo stesso cancello sugli indici.

Il driver **non riscrive il resolver dei parametri**: chiede l'anteprima a
`walkforward_generico.ps1` (che risolve `#define`, enum e default dal sorgente),
la converte in passata singola e **la sottopone a gate duri** — nessun `||`
rimasto (sarebbe *un'ottimizzazione travestita*, e in ottimizzazione **non
esiste nessun `.htm` da leggere**), `Optimization=0`, `AllowLiveTrading=false`,
e le otto righe chiave (`InpMagic`, `InpRangeMode`, `InpEntryMode`,
`InpPrevWindowMin`, `InpRetestOffsetPts`, i due lati, `InpCloseAtEnd`)
verificate **sul testo finale dell'artefatto**.

⚠️ **La cella del cancello è il CENTRO della griglia** (`PrevWindowMin=180`,
`RetestOffsetPts=400`), **calcolato sugli assi del file prova** e non scritto a
memoria: sceglierla dopo aver visto i PF sarebbe **pescare la cella che fa
passare il cancello**.

---

## 4. 🧪 Che cosa ho **eseguito** (non "riletto")

Qui non c'è MT5 — ma **PowerShell c'è**, e il driver è stato **fatto girare**.

| prova | esito |
|---|---|
| `Parser::ParseFile` + `lint_ps1.py` | ✅ puliti |
| **Audit AST**: parametri orfani · collisioni **case-insensitive** fra variabili · funzioni che si scontrano con un **alias** | ✅ nessuno *(verificato sull'AST, non a occhio)* |
| **26 test unitari** su `Mediana`, sentinelle, `AssiDi`, `GateDate`/`GateDateIni`, `Gemelli` | ✅ tutti verdi |
| **Il cancello S0a fatto scattare in tutti e tre gli stati** (SUPERATO / SOSPESO / FALLITO) + `NON MISURATO` | ✅ *(un cancello mai fatto scattare non è dimostrato)* |
| **`TrovaRegioni`**: 9 forme, compreso *«due celle che si toccano solo per il vertice restano DUE regioni»* e il centro deterministico di un blocco 2×2 | ✅ |
| **`PassoCosto` con le parziali**: accoppiamento a volume residuo + **6 anomalie** (due `in` di fila, `out` senza `in`, uscita > residuo, posizione rimasta aperta, numero illeggibile, deal fuori ordine) | ✅ tutte fermano la misura |
| **Il driver INTERO su un banco stubbato**, con i **file prova veri** | ✅ vedi sotto |

### 🔬 Il giro sul banco stubbato ha prodotto, sui file prova veri:

- tutti i **gate statici** passati, assi contati (`5 × 3 × 2 = 30 passate`);
- il cancello 0b **SUPERATO** su dati sintetici → il round prosegue;
- il cancello 0b **FALLITO** su dati sintetici → 🛑 **il round si ferma e
  nessuna griglia viene letta**, uscita 1;
- lato **LONG**: regione di 3 celle, **centro calcolato** (`prevWin 180 /
  offset 400`), confronto col metro `ΔPF +0,130` → **PASSA**;
- lato **SHORT**: tutte le celle sotto 30 operazioni → **valvola R59**,
  *«niente verdetto di MERITO, il RISCHIO si legge lo stesso»*;
- ripresa con `-SoloFase GRIGLIA` → i CSV del metro letti da disco, marcati
  **`DA DISCO`**, e il referto stampa *«nessuno dei verdetti è definitivo»*.

### 🐛 Due difetti **trovati eseguendo**, non leggendo

1. 🔴 **`function R` non veniva mai chiamata: `R` è l'ALIAS di
   `Invoke-History`, e in PowerShell gli alias battono le funzioni.** Il
   referto esplodeva **dentro la raccolta**, cioè nel punto in cui serve di
   più. Rinominata `ScriviRef` (e `L` → `Lav`, stessa classe di rischio), e
   ora un **audit AST** confronta **tutti** i nomi di funzione con la tabella
   degli alias.
2. 🔴 **E il difetto sopra usciva con CODICE 0.** Un errore fuori dai `try`
   uccideva lo script **dopo** il `FERMATO` e **prima** dell'`exit 1`: una
   corsa esplosa che si presenta come riuscita — il caso peggiore. Aggiunti un
   **`trap`** che garantisce **1** su qualunque uscita anomala, un `try/catch`
   attorno alla lettura della griglia (un difetto nell'analisi non deve
   portarsi via il referto e lo zip) e la regola: **uscita 0 solo per un round
   completo, in un lancio solo, senza problemi**.

---

## 5. ⚠️ Quello che **non** è stato verificato, dichiarato

- ❌ **Niente è stato misurato sul banco vero.** Qui non c'è MT5: tutti i
  numeri delle prove sopra sono **sintetici**, servivano a far scattare i
  cancelli, **non** a dire come va il motore.
- ❌ **L'EA non è stato compilato.** Il driver **compila davvero** anche nel
  giro a vuoto (e cancella l'`.ex5` prima), ma se MetaEditor si lamenta il
  risultato è quello e va riportato così com'è.
- ❌ **Lo spread non è misurato**: è **dichiarato** 2,0 punti indice.
- ❌ **Il pavimento `VOLUME_MIN`** (`MathMax(minLot,…)` in `CalcLotByRisk`) sui
  **bordi larghi** della griglia — dove lo stop è più largo e il lotto più
  piccolo — **non è misurato**. Il referto lo espone come `[DA VERIFICARE]` e
  stampa min/max/valori distinti dei volumi della cella del cancello.
- ❌ **Il doppione con `ABTG_MaxMinNotte`** (punto 3 di `COME PUÒ MORIRE`)
  **non** è misurato da questo round: vuole la **sovrapposizione delle
  giornate**, si fa **dopo** e **solo se** il round passa.
- ❌ **Il gemello DAX è il passo successivo, non questo.**

---

## 6. ⏭️ Cosa serve da Claudio, in ordine

1. **Leggere** `prove/PREOPEN_RETEST_DOW_M15.txt`, sezioni **`COME PUÒ
   MORIRE`** e **`CRITERI DI ACCETTAZIONE`**, e **dire che li ha letti**.
2. **Approvare (o cambiare) le tre interpretazioni** elencate nella pagina di
   lancio: le tre bande del cancello del costo, la definizione di *take* con le
   parziali accese, e il fatto che il criterio firmato sia uno **screening**
   dentro l'OOS e non una selezione walk-forward.
3. Solo dopo: **giro a vuoto**, poi **corsa vera**, con i blocchi della pagina
   👉 `backtest_pipeline/righe/RIGA_PREOPEN_DOW_DA_MANDARE.md`.
