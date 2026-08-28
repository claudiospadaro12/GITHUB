# 🧾 REFERTO DI PREPARAZIONE — PASSO 0 **VWAP REVERT** (28/08/2026)

**Chi:** agente `mql5-ea-developer`. **Cosa:** preparazione del PASSO 0 del
candidato **P1** della caccia M5/M15 indici del 25/08.
**Nessun backtest è stato lanciato**: in questo ambiente non esiste MT5.

---

## 0. 🔴 LA PRIMA COSA, perché cambia il mandato

Il mandato diceva _"l'EA `ABTG_VwapRevert.mq5` **NON esiste ancora** — va
scritto da zero (stima 5-7 ore)"_. **È una premessa scaduta.**

**Misurato:** il file esiste dal **25/08/2026 ore 20:34**, è di **1.554 righe**,
lo ha scritto un agente precedente (`HANDOFF.md` riga 187, e la BOZZA stessa
porta l'aggiornamento _"l'EA ADESSO ESISTE"_). Riscriverlo da zero avrebbe
**buttato via** il porting, la sua tesi (`VWAPREVERT_TESI.md`, 644 righe) e il
**bug ATR-960 dell'autore** già trovato e documentato.

Quindi il lavoro di oggi **non è stato "scrivere l'EA"**, ma:

1. **rivedere** quello che c'è, contro le convenzioni di casa;
2. **aggiungere il pezzo che davvero mancava** — il **flat di fine seduta**;
3. **costruire il PASSO 0** che il dossier pretende (file prova + riga + gate).

---

## 1. ✅ COSA HO TROVATO GIÀ A POSTO (review statica, verificata leggendo)

| convenzione di casa | stato | dove |
|---|---|---|
| **ASCII puro** nel sorgente | ✅ **0 caratteri non-ASCII** su 1.727 righe | misurato con `grep` |
| **OPTFRAME a 11 colonne** | ✅ `double stats[10]` + `FrameAdd`, header con `Peggior Giornata %` | `OnTester` / `OnTesterDeinit` |
| **niente look-ahead** | ✅ setup su shift **2**, conferma su shift **1**, ordine all'apertura della **0**; la VWAP parte da `shiftFine >= 1` | `OnNewBar`, `CalcVwapBanda` |
| **`STOPS_LEVEL` rispettato** | ✅ tre controlli: distanza dal mercato, SL dal livello d'ingresso, TP (che viene **tolto**, non forzato) | `PiazzaOrdine` |
| **normalizzazione / volumi** | ✅ `NormalizePrice`, `NormVol`, retcode letto dopo ogni ordine | `PiazzaOrdine`, `LotByRisk` |
| **attribuzione della fonte** | ✅ in testa al file, con URL, data, copia in biblioteca e licenza dichiarata **[INCERTO]** | righe 7-25 |
| **magic vergine** | ✅ `773400`, blocco `7734xx` | riverificato oggi |
| **autotest del nucleo puro** | ✅ blocchi `[VWAPREV][AUTOTEST]`, **e dalla v2 l'esito esce in COLONNA** (`Autotest Falliti`), perché in ottimizzazione le `Print` degli agent non le legge nessuno | `AutoTestVwapRevert()`, `OnTester` |

### 🟠 Il "difetto R109" (pavimento SL vero): **presente, ma dichiarato e con la via d'uscita già in codice**

Nel modo **`VR_FLOOR_AUTORE`** (default, = il Pine) il pavimento
`InpSlAtrFloor` entra **solo nel calcolo di R**, quindi riduce il **lotto** e
allontana il **target** — ma **non sposta lo stop**, che resta all'estremo
strutturale e può nascere a pochi punti dal prezzo.

**Non l'ho cambiato**, e il motivo è di metodo: la cella base dev'essere il
**porting**, e l'alternativa **esiste già** (`InpSlFloorMode = VR_FLOOR_ALLARGA`,
che allarga davvero lo stop). ⚠️ **Va detto in chiaro:** con lo slippage
**misurato di 21,5 punti** (R109) uno stop strutturale strettissimo è
esattamente il caso che fa male. **Se il PASSO 0 mostra stop medi molto
stretti, `VR_FLOOR_ALLARGA` è la prima gamba da misurare** — una gamba, non un
default cambiato di nascosto.

---

## 2. 🕗 COSA HO AGGIUNTO — **il flat di fine seduta** (l'unica modifica al motore)

Era **il buco vero**: l'EA non aveva **nessuna** chiusura di fine giornata.
Aveva solo `InpFridayClose` (default `false`), che copre il weekend e **non** le
notti.

### La logica, in tre righe

`InpFlatFineSeduta` (**default ACCESO**) alle `InpFlatOra:InpFlatMinuto` **ORA
SERVER** — default **20:45** — chiude ogni posizione di questo magic, cancella
ogni pendente, e **`return`a da `OnTick`**: quindi non si riapre fino al giorno
dopo. Nessuna posizione a cavallo della notte, nessuna a cavallo del weekend.

### Perché il default è ACCESO, contro la regola del "default neutro"

È una **scelta di contratto**, e va dichiarata come tale:

- **FTMO Standard (leva 1:100)** — quella che vogliamo tenere — impone
  restrizioni **overnight / weekend / news SOLO sul conto finanziato**. Un
  motore che apre e chiude dentro la seduta **non incontra mai** quel vincolo.
  L'alternativa è scendere a **Swing, leva 1:30**.
- Un candidato che in backtest guadagna **tenendo overnight** produce un numero
  che descrive **una macchina che in campo non potremmo far girare**.
- Ed è **coerente con la tesi**: la VWAP di sessione **si azzera ogni giorno**;
  una posizione tenuta oltre la seduta non ha più il livello che l'ha generata.

**E la regola del default neutro non è stata aggirata, è stata pagata:** la
cella **`03_overnight`** spegne il flat e cambia **solo quello**. Il costo della
regola **si misura**. E l'EA **dichiara da solo** in che macchina si trova: con
il flat acceso scrive _"motore INTRADAY, niente overnight né weekend.
Scostamento dichiarato dal Pine"_; con il flat spento scrive _"questa cella
TIENE POSIZIONI OVERNIGHT ed è incompatibile con un conto FTMO Standard
finanziato"_.

### I dettagli che contano

- **Il confronto è in MINUTI DEL GIORNO**, non ora per ora: con 20:45 un
  `t.hour >= 20` chiuderebbe **45 minuti prima ogni giorno**. È il caso `f3`
  dell'autotest.
- **I pendenti si cancellano insieme alle posizioni**: un BUY STOP lasciato vivo
  oltre il flat riempirebbe **di notte o lunedì in gap**, cioè esattamente ciò
  che questa regola esiste per impedire.
- **20:45 server = 21:45 italiana** (server BCM un'ora indietro). D30EUR chiude
  alle **21:00 server**. Sul gemello **U30USD** lo stesso valore taglia **prima**
  della chiusura del simbolo: **è voluto**, perché il cancello **S5** confronta i
  due simboli e un parametro diverso li renderebbe inconfrontabili.
- **`InpStopNuoviMinPrimaFlat`** (default **0 = spento**): un ordine riempito a
  20:44 e chiuso d'ufficio a 20:45 è solo spread pagato. Ma *quanto* costi è un
  numero, non un'opinione: è una **gamba da misurare dopo**, non un default.
- Le metriche (`AggiornaPeggiorGiornata`, `AggiornaContatoreTrade`) sono state
  spostate **prima** delle chiusure d'ufficio: se il flat porta via la
  posizione, la caduta di quella giornata dev'essere **già contata**. Non cambia
  nessuna decisione di trading.

### ⚠️ Il limite, dichiarato

Il flat vive dentro `OnTick`. **Se il simbolo smette di mandare tick prima
dell'ora di flat, la chiusura slitta al primo tick utile.** Dentro l'orario di
negoziazione di un CFD indice i tick ci sono; **ai bordi della seduta va
verificato sul referto** — per questo il referto chiede di cercare nel log la
riga `flat di fine seduta alle 20:45 server: N posizioni chiuse`.

### Autotest

Aggiunto il **blocco 10** (`DopoOrarioFlat_Calc`, `CodaSeduta_Calc`): **dieci
casi**, incluso il `20:00` che **non deve** chiudere. Il contatore passa da
_"NOVE BLOCCHI SU NOVE"_ a _"DIECI SU DIECI"_.

---

## 3. 🧪 IL PASSO 0 — quattro celle, e perché **non** è la BOZZA

🛑 **La BOZZA `VWAPREVERT_DAX_M15_BOZZA.txt` resta ferma**, col suo cartello:
i suoi criteri di merito sono **[DA FIRMARE]**, e i criteri si firmano **prima**
dei numeri. Quella è una **griglia da 18 celle che sceglie una taratura**.

Questo è un altro strumento: un **conta-operazioni**, che il dossier pretende
**prima** (par. 6, paletto 2) e che **non dà nessun verdetto**.

| cella | cosa misura | flat | magic |
|---|---|---|---|
| `00_nudo` | frequenza del motore, due lati | ON | 773400/773401 |
| `01_long` | frequenza del lato long | ON | 773410/773411 |
| `02_short` | frequenza del lato short | ON | 773420/773421 |
| `03_overnight` | **il costo della regola intraday** | **OFF** | 773430/773431 |

Le celle `01`/`02` sono la **regola dei due lati** di Claudio (25/08). Servono
anche a un'altra cosa: il dossier vende questo candidato come **motore
simmetrico vero** (buco **(b)** di `ROTTA_PROP.md`, dove le nostre celle vive
sono quasi tutte long-only). **Quella simmetria è una promessa finché i due lati
non sono misurati separati.**

**Magic**: `773400/773401` erano già stati verificati liberi dal cacciatore il
25/08. Oggi ho verificato i **sei nuovi** (`7734[123]0/1`): **zero occorrenze**
in tutto il repo.

---

## 4. 🔒 COSA HO VERIFICATO **ESEGUENDO** (non "credo che")

- **Sorgente MQL5**: 0 caratteri non-ASCII; graffe e tonde **bilanciate**
  (differenza 0 su 1.727 righe). ⚠️ **Non è una compilazione**: qui non c'è
  MetaEditor, e la prima compilazione resta il primo controllo vero.
- **File prova**: il diff fra ogni cella e il `00_nudo` è di **esattamente due
  righe** — verificato con `diff` sulle sole righe di parametro.
- **Driver PowerShell**: installato **PowerShell 7.4.6** apposta e passato
  `[Parser]::ParseFile` → **0 errori**, **5.037 token**; **0 collisioni
  case-insensitive** fra nomi di variabile; **non usa `$args`**.
- **I gate**: fatti girare **sui file veri** (controllo positivo ✅ prima e dopo)
  e poi **fatti fallire uno per uno**: **11 corruzioni, 11 fermate**, ognuna col
  messaggio giusto. La tabella completa è in
  `righe/RIGA_PASSO0_VWAPREV_DA_MANDARE.md`.
  > La corruzione che conta di più è la **simmetrica** (stessa riga storta in
  > tutti e quattro i file): il gate della **stella** non può vederla, la prende
  > il gate della **baseline assoluta** dichiarata dentro il driver.
- **Verifica dei caduti** (`REGISTRO_TEST.md` + par. 2 del dossier): la VWAP
  compare in `PROMEMORIA_APERTURE.md` **solo come filtro direzionale da
  aggiungere** al motore aperture — che è la forma **bocciata** in R101/07. Come
  **motore** non c'è nessun caduto omonimo. ✅ **Questo candidato non è un
  caduto travestito.**

## 5. 🟡 COSA **NON** HO VERIFICATO — dichiarato, non taciuto

- **La compilazione.** L'EA non è mai stato compilato da nessuno. Se MetaEditor
  si lamenta, **quello è il risultato del PASSO 0**. Dalla **v2** della riga il
  **giro di controllo compila davvero** (in entrambi i rami), quindi la risposta
  arriva in **un minuto**, non a corsa avviata — ma finché non gira sul PC di
  Claudio resta **non misurata**.
- **L'esito dell'autotest.** ⚠️ **Non si legge nella scheda Esperti**: in
  ottimizzazione le `Print` girano sugli **agent** e non le legge nessuno
  (CHECKLIST punto 34). Dalla **v2** esce in **colonna** nel CSV
  (`Autotest Falliti`: `0` = tutti passati, `>0` = DIVERGE, `-1` = non
  eseguito) e la riga ci fa un **gate**. La riga da cercare nell'EA è
  `esito motore:`, che deve dire **DIECI BLOCCHI SU DIECI** — non "dieci righe
  `[VWAPREV][AUTOTEST]`", che sono **17**.
- **Il flat sui tick veri** (il caso "niente tick prima dell'ora di flat").
  ⚠️ E la riga di log `flat di fine seduta ... N posizioni chiuse` **si scrive
  ogni giorno anche con `N = 0`**: la sua **assenza non significa** "niente da
  chiudere". Dalla **v2** il dato è in colonna (`Flat Giorni`, `Flat Chiusure`).
- **Il costo della cella `03_overnight`.** Il costo si legge come delta di
  `Prof OOS` e di `n` fra `00_nudo` e `03_overnight`. **Non è un costo puro**:
  col flat spento la posizione notturna tiene occupato lo slot
  (`if(CountPositions()>0) return`) e blocca gli ingressi del giorno dopo — un
  `n` più basso lì è **anche meccanica dello slot, non solo mercato**. Il P&L
  delle sole posizioni che attraversano la notte **questo giro non lo misura**.
- **Se BCM espone `SYMBOL_VOLUME_REAL` su D30EUR.** Finché non è misurato, la
  VWAP è **TICK-VOLUME-pesata** — ed è il dato su cui poggia la banda, cioè il
  motore intero. **[INCERTO, già dichiarato nella tesi]**
- **Il cancello S0 (costo)**: **non adjudicabile**. Lo spread medio BCM su
  D30EUR M15 non è misurato in casa, e il rapporto punti MT5 / punti indice su
  D30EUR **non è agli atti** (R97 lo misurò su U30USD e NASUSD).
- **Ogni singolo numero.** Il giro a vuoto copre gli artefatti; i numeri li può
  dare solo la corsa, sul PC di Claudio.

---

## 6. 📋 COSA VIENE DOPO (in ordine, non tutto insieme)

1. **Lanciare il PASSO 0** (giro a vuoto → corsa vera) e leggere `n`.
2. **Il gemello U30USD** per il cancello **S5** (stessa struttura, cambia solo
   `@SIMBOLO`) — ma **solo se il PASSO 0 dà campione**.
3. **Portare alla firma di Claudio** i criteri di merito della BOZZA
   (S3/S4/S5/S6), **prima** di far girare la griglia da 18 celle.
4. Gambe successive, **una alla volta**: `VR_FLOOR_ALLARGA` (difetto R109),
   `InpStopNuoviMinPrimaFlat`, `InpUseHourFilter` sulla fascia 10-16 server
   (il buco **(d)** della flotta), l'`InpAtrPeriod = 960` che riproduce la
   **lettera** del bug dell'autore.

> ⚠️ **Nessuna di queste è una promessa di profitto.** Il PASSO 0 risponde a una
> sola domanda — *"il campione esiste?"* — e può benissimo rispondere **no**.
> Se il cancello S0 fallisse, la falsificazione è già dichiarata nella BOZZA:
> **il capitolo VWAP si chiude in entrambe le forme**, filtro e motore.

---

_Artefatti di questo giro:_
`mql5/Experts/ABTG_VwapRevert.mq5` (modificato) ·
`backtest_pipeline/prove/ABTG_VwapRevert.txt` ·
`backtest_pipeline/prove/PASSO0_VWAPREV_01_long.txt` ·
`backtest_pipeline/prove/PASSO0_VWAPREV_02_short.txt` ·
`backtest_pipeline/prove/PASSO0_VWAPREV_03_overnight.txt` ·
`backtest_pipeline/righe/RIGA_PASSO0_VWAPREV.ps1` ·
`backtest_pipeline/righe/RIGA_PASSO0_VWAPREV_DA_MANDARE.md`
