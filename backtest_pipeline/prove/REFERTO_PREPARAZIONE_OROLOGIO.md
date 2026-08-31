# 🛠️ REFERTO DI PREPARAZIONE — **LA SONDA DELL'OROLOGIO** (28/08/2026)

> 📬 **LA RIGA DI LANCIO NON STA QUI.** Sta, e sta **soltanto**, in
> **`backtest_pipeline/righe/RIGA_SONDA_OROLOGIO_DA_MANDARE.md`**.
> Questo referto **la cita, non la copia** — CHECKLIST **punto 100**: un blocco
> `powershell` incollato in un secondo file diventa una **riga di lancio armata**
> col pin vecchio, e la guardia `SCRIPT VECCHIO` non può niente contro una copia
> integralmente vecchia (pin e marcatore sono coerenti *fra loro*, solo che
> descrivono il passato).

---

## 1. COSA È STATO COSTRUITO

| artefatto | stato |
|---|---|
| `mql5/Experts/ABTG_SondaOrologio.mq5` | **NUOVO** — 972 righe di cui **~516 di codice**; il **nucleo operativo è ~120 righe**, il resto è intestazione, autotest e OPTFRAME |
| `backtest_pipeline/prove/SONDA_OROLOGIO_00_GEMELLI.txt` | **NUOVO** — determinismo del banco **+ cronometro** |
| `..._01_EURUSD_LONG` `_02_EURUSD_SHORT` `_03_GBPUSD_LONG` `_04_GBPUSD_SHORT` `_05_XAUUSD_LONG` `_06_XAUUSD_SHORT` | **NUOVI** — 3 simboli × 2 lati |
| `backtest_pipeline/prove/SONDA_OROLOGIO_FX.txt` | **la SPECIFICA CONGELATA**, toccata **solo** con due note d'esecuzione in testa — la seconda (31/08) dichiara che **C1 si legge nella clausola più severa** (stessa fascia su ≥2 simboli). Criteri e griglia **intatti** |
| `backtest_pipeline/righe/RIGA_SONDA_OROLOGIO.ps1` | **NUOVO** — marcatore **`MARCATORE_RIGA_SONDA_OROLOGIO_v3`** (era `_v1` in questa riga e `_v2` nel file: **il marcatore vive in UN posto solo, il `.ps1`** — questa tabella lo cita, non lo decide) |
| `backtest_pipeline/righe/RIGA_SONDA_OROLOGIO_DA_MANDARE.md` | **NUOVO** — l'unica riga di lancio esistente |

---

## 2. COME SONO STATI GESTITI I TRE SIMBOLI E I DUE LATI

**Sei file prova, non uno multi-simbolo.** Motivo misurato leggendo
`walkforward_generico.ps1`: un file prova porta **un solo `@SIMBOLO`** e il
driver generico gira **un simbolo per invocazione**. Il lato è un input pinnato,
e l'EA **si rifiuta di partire con tutti e due i lati accesi** — perché con tutti
e due la colonna `Lato` non vorrebbe dire niente. È esattamente la **regola dei
due lati del 25/08**: *"si RITESTA"*, in **corse separate**.

I sei file differiscono dal capostipite per **tre righe sole** (simbolo, lato,
magic) e il driver lo verifica **contro valori dichiarati nel driver**, non
contro un file gemello: una **corruzione simmetrica** (la stessa riga storta in
tutti e sette) passerebbe un diff a mani basse — lezione R108/R110, ed è la
corruzione **n. 3** della batteria qui sotto.

**Le date.** `@DAQUANDO 2011.01.01` su **tutti e tre**, e non tre date diverse.
Le tre date storiche misurate (GBPUSD 1993.05.11, EURUSD 1999.01.04 *euro vero*,
XAUUSD 2004.06.11) servono a **dimostrare che il 2011 c'è su tutti e tre**, non a
spostare la finestra: la finestra è **aritmetica** (tetto ~100.000 barre → 16,0
anni su H1 forex; 15,5 stanno dentro con margine e coprono quattro regimi).

---

## 3. IL DIFETTO TROVATO NELLA SPECIFICA CONGELATA — dichiarato, non corretto di nascosto

Le righe **pinnate** del file congelato erano scritte `Nome=1||||||N`: spezzate su
`||` danno **QUATTRO** campi. `walkforward_generico.ps1` tratta come *"pin secco"*
tutto ciò che ne ha **meno di CINQUE**, e lo riscrive

```
InpAllowLong=1||||||N||1||||||N||0||1||||||N||N
```

che MT5 legge storto **senza dire niente** (è la trappola n.3 scritta in testa al
driver generico: *"un parametro sbagliato viene ignorato in silenzio"*).

➡️ I sette file esecutivi usano la forma di casa a **cinque campi**
(`Nome=valore||valore||0||valore||N`), **con gli stessi valori uno per uno**.
Il difetto è **scritto in testa al file congelato**, che resta la specifica e
**non si lancia**. Ed è diventato un **gate**: la corruzione **n. 6** della
batteria riproduce esattamente quella sintassi e viene fermata.

---

## 4. LE DECISIONI FIRMATE, e sono tre

1. 🕐 **ORA SERVER FISSA** (la decisione lasciata aperta in fondo al file
   congelato). Errore noto **~4 settimane l'anno** sui cambi di ora legale non
   allineati: **dichiarato** in testa all'EA, nel referto della corsa e nella
   pagina della riga. Non corretto.
2. 🛑 **LA CHIUSURA FORZATA DI FINE GIORNATA HA QUATTRO DIFESE**, perché il
   mandato FTMO del 28/08 dice *mai overnight* e il requisito era *"non
   disattivabile da nessun input"*:
   - **non esiste** un bool che l'accenda o la spenga;
   - l'unico input vicino (`InpFlatAnticipoMin`) la sposta **solo più presto**;
   - `OnInit` **rifiuta** qualunque valore fuori da `0..720`;
   - `MinutiFlat_Calc` **tosa comunque** l'anticipo: il flat esiste **per
     aritmetica**, non per disciplina di chi configura. Con anticipo 0 cade alle
     **23:59 server**.
   Il **blocco 3 dell'autotest** verifica proprio questo: per anticipi
   `-999999 / 0 / 30 / 720 / 999999`, alle 23:59 il flat **deve** essere vero.
   E c'è un **canarino a runtime**: la colonna `Notti Attraversate` conta le volte
   in cui una posizione era viva al cambio di giornata del server. **Deve essere
   0**, e il driver la trasforma in un **PROBLEMA** se non lo è. (Limite vero,
   dichiarato: il flat vive dentro `OnTick`; se il simbolo smette di mandare tick
   la chiusura slitta al primo tick utile — ed è per questo che il canarino esiste.)
3. 🎚️ **`InpTPatrMult` e `InpMaxSpreadPts` esistono come input** (li pinna il file
   congelato) **e sono usati** — quindi non sono orfani — **ma la purezza della
   sonda la impone il GATE, non l'assenza**: la baseline li vuole a `0.0` e `0`, e
   le corruzioni **16** e **17** dimostrano che il driver si ferma se qualcuno li
   accende. L'EA, dal canto suo, **lo dichiara a voce alta** nel log invece di
   spegnerseli da solo.

---

## 5. LE SCELTE DI MISURA CHE VANNO SAPUTE PRIMA DEI NUMERI

- **Il "lordo" è la deriva sul BID** (bid all'ingresso contro bid all'uscita, nei
  due versi). Lo spread resta **fuori dalla misura apposta**: C1 lo confronta a
  parte, e misurare il risultato **eseguito** (ask→bid) lo conterebbe **due volte**.
- **Lo spread è un campione per operazione, preso nell'istante in cui si paga**
  (lezione R55: *"lo spread si legge nel momento in cui si paga"*), non la media
  della giornata. Escono **mediana** e **P95** (rango più vicino, nessuna
  interpolazione: il numero che esce è **uno spread davvero visto**).
- 🔴 **`Rapporto Lordo Su Spread` — il cancello C1 — lo calcola l'EA e lo scrive
  in colonna.** Nessuno lo può rifare storto in un foglio.
- ⚖️ **La `Peggior Giornata %` è condizionata alla taglia**: lotto da rischio 1% su
  uno stop di **10 ATR**, quindi piccolo. Si riporta sempre (**C4**), ma **non è il
  rischio di una versione operabile**.
- ✂️ **`Ore Medie Tenuta`** dice quali fasce il flat ha **troncato** (un ingresso
  alle 20:00 con blocco da 12 ore viene tagliato alle 23:29). Non è un guasto: è
  il mandato — ma quelle celle misurano un blocco più corto di quello in colonna.
- 🧾 **Nessun export per-trade.** Con 72 celle sullo stesso magic ogni passata
  sovrascriverebbe la precedente (trappola già pagata su FVGRET). **Tutto quello
  che serve è in colonna** — che è anche la risposta al punto 99: in ottimizzazione
  le `Print` girano sugli agent e non le legge nessuno.
- 🚫 **Nessun `#include <ABTG_PausaGuardian.mqh>`**, ed è voluto: questa sonda **non
  deve mai stare su un grafico vivo** (C7). Di conseguenza la riga **non installa
  nessun include**, a differenza dei due PASSO 0 gemelli.

---

## 6. ⏱️ IL COSTO DELLA CORSA — l'ignota, e i tre modi che ne discendono

Una cella di misura = **144 passate a tick reali su 15,5 anni di H1**. Sei celle =
**864**. 🔴 **Quanto costi una passata su 15,5 anni di tick forex in casa NON È MAI
STATO MISURATO**: non è una stima prudente, è un'**ignota**.

➡️ Per questo il driver ha tre modi e **il default è il più piccolo**
(**RICOGNIZIONE**: solo `00_gemelli`, 4 passate). Quella cella fa **due cose
insieme** — collauda il **determinismo** del banco **e cronometra** una passata —
e il referto stampa la moltiplicazione. **La decisione di lanciare le sei celle si
prende su quel numero**, non al buio. L'ordine e i comandi stanno nella pagina
della riga.

---

## 7. ✅ COSA È STATO VERIFICATO **ESEGUENDO**

### 7.1 Analisi statica

| controllo | esito |
|---|---|
| `.ps1` parsato con PowerShell 7.4.6 (`[Parser]::ParseFile`) | **0 errori** |
| ASCII puro nel `.ps1` (regola del 17/08) | **0 byte > 127** |
| uso di `$args` (variabile automatica, punto 71) | **no** |
| collisioni **case-insensitive** fra nomi di variabile (punto 79) | **0** — ne era stata trovata **una** (`$celle` parametro contro `$CELLE` elenco) e **corretta** in `$nCelle` |
| variabili assegnate e **mai rilette** | **0** — ne era stata trovata **una** (`$TabellePerCella`) e **rimossa** |
| MQL5: **ridichiarazioni nello stesso scope** (punto 98) | **0** |
| MQL5: graffe / tonde / quadre bilanciate | **72=72, 411=411, 95=95** |
| MQL5: `stats[]` vs header vs `StringFormat` | **26 assegnati e contigui (0..25)** · header **28 nomi** · format **28 specificatori** · **28 argomenti** |
| MQL5: **input orfani** (dichiarati e mai usati) | **0 su 16** |
| MQL5: condizioni di prezzo dentro `ValutaIngresso()` | **nessuna** (`iOpen/iHigh/iLow/iClose/CopyRates/iMA/...`: zero occorrenze) |
| i 7 file prova simulati contro il parser del driver generico | 72 celle/finestra sulle sei di misura, 2 sui gemelli, **0 nomi inesistenti**, **0 sweep degeneri**, **0 magic in collisione** |
| magic `7772xx` cercati **uno per uno** in tutto il repo | **zero occorrenze** — vergini |

### 7.2 I gate fatti fallire — **19 corruzioni, 19 fermate**

Controllo positivo eseguito **prima e dopo** l'intera batteria: entrambe le volte
*"TUTTI PASSATI su 7 file su 7"*.

| # | corruzione | il gate ha detto |
|---|---|---|
| 1 | i due file dei lati **scambiati** | `InpAllowLong vale 0, la cella 01_eurusd_long (LONG) lo vuole 1` |
| 2 | **griglia stretta** (24 ore → 13) | `'InpOraIngresso' vale '0\|\|0\|\|1\|\|12\|\|Y', la griglia congelata vuole '0\|\|0\|\|1\|\|23\|\|Y'` |
| 3 | **corruzione SIMMETRICA su tutti e sette** (stop 10 ATR → 2,5) | `'InpSLatrMult' vale 2.5, la baseline dichiarata di questa sonda lo vuole 10.0` |
| 4 | **magic VIETATO** (773400, il PASSO 0 VWAPREV) | `magic 773400 e' VIETATO (sedia viva o round recente)` |
| 5 | **magic duplicato** fra due celle | `magic 777205 usato in due celle: ... e ...` |
| 5-bis | magic diverso da quello dichiarato (scostamento innocuo) | `magic 777299, la cella 02_eurusd_short vuole 777202` |
| 6 | **sintassi a QUATTRO campi** (quella del file congelato) | `'InpRiskPercent' ha 4 campi invece di 5 ...` |
| 7 | **parametro fuori elenco chiuso** (`InpComment`: esiste nell'EA, non nella sonda) | `NON e' nell'elenco chiuso dei parametri della sonda` |
| 8 | `@PERIODO` H1→M15 (**la trappola R102**) | `@PERIODO e' M15, atteso H1` |
| 9 | `@DAQUANDO` spostato al 2019 | `@DAQUANDO e' 2019.01.01, atteso 2011.01.01` |
| 10 | `@SIMBOLO` sbagliato | `@SIMBOLO e' GBPUSD, la cella 01_eurusd_long lo vuole EURUSD` |
| 11 | **asse Y mancante** (durata pinnata di nascosto) | `gli assi con flag Y sono [InpOraIngresso], la cella li vuole [InpOraIngresso,InpOreDurata]` |
| 12 | **asse Y in più** (la griglia dei magic che rientra dalla finestra) | `gli assi con flag Y sono [InpMagic,InpOraIngresso,InpOreDurata] ...` |
| 13 | **parametro doppio** nello stesso file | `DUE righe per 'InpATRPeriod'` |
| 14 | **pin della baseline cancellato** | `manca il pin di 'InpFlatAnticipoMin'` |
| 15 | **gemelli che non spazzolano** (un magic invece di due) | `gli assi con flag Y sono [], la cella 00_gemelli li vuole [InpMagic]` |
| 16 | 🔴 **TAKE PROFIT acceso** (si uscirebbe al prezzo, non all'ora) | `'InpTPatrMult' vale 2.0, la baseline ... lo vuole 0.0` |
| 17 | 🔴 **filtro di spread acceso** (lo spread scelto invece che misurato) | `'InpMaxSpreadPts' vale 30, la baseline ... lo vuole 0` |
| 18 | **tutti e due i lati accesi** nello stesso file | `InpAllowLong vale 1, la cella 06_xauusd_short (SHORT) lo vuole 0` |
| 19 | flag illegale (`S` invece di `N`/`Y`) | `ha flag 'S' invece di N o Y` |

> 🔎 **La riga 3 è la più importante.** Una riga storta **uguale in tutti e sette**
> passerebbe qualunque diff — *"un confronto fra A e B non può accorgersi di niente
> che sia uguale in A e in B"*. La prende il gate della **BASELINE ASSOLUTA**, che
> confronta con valori **dichiarati nel driver**.
>
> 🔎 **E la 16 e la 17 sono quelle che proteggono la MISURA**, non il perimetro:
> col take acceso la sonda uscirebbe al **prezzo** invece che all'**ora**; col
> filtro di spread acceso misurerebbe *"le ore buone di uno spread che ci siamo
> scelti noi"* (R55).

### 7.3 La lettura dei CSV, la tabella e i gate di collaudo — **eseguiti**

Su un banco stubbato (sostituite **4 sole ancore**: rete, selezione del terminale,
compilazione, invocazione del driver generico) con CSV sintetici che portano
**l'intestazione vera dell'EA**, 72 righe per cella:

| scenario | esito |
|---|---|
| **A** — C1 sopra soglia su EURUSD e GBPUSD | tabella 24×3 renderizzata, `gemelli: IDENTICI`, `celle di misura con dati: 6 su 6`, **C1 PASSATO** su tutte e tre le letture (IS / OOS / ENTRAMBE), PROBLEMI 0, zip prodotto |
| **B** — tabella **piatta** su tutti e sei | `celle di misura con dati: 6 su 6` → **C1 NON PASSATO** (ed è il **dato completo**, quindi si legge come un "no") |
| **C** — collaudo rotto | `gemelli: DIVERSI su profitto`, e **12 PROBLEMI**: autotest ≠ 0, `Notti Attraversate` > 0, `Giorni Saltati Spread` > 0, CSV mancanti |
| **D** — CSV con colonne di un altro EA | `CSV SENZA LE COLONNE DELLA SONDA`, distinto da `CSV MANCANTE` |

### 7.4 Due difetti trovati **eseguendo**, e corretti

1. 🧟 **I gate "magic VIETATO" e "magic duplicato" erano IRRAGGIUNGIBILI.** Il
   controllo d'identità (*"il magic non è quello che la cella dichiara"*) girava
   **prima** e li copriva sempre: erano **decorazione**, e la corruzione 4
   inizialmente rispondeva col messaggio sbagliato. ➡️ **Riordinati**: prima si
   nomina il **pericolo** (toccare una sedia viva, incrociare due celle), poi lo
   scostamento innocuo. Le corruzioni 4, 5 e 5-bis ora danno tre messaggi diversi.
2. 🕳️ **Il cancello C1 stampava `NON PASSATO` in una corsa che non aveva misurato
   NIENTE** — l'affermazione più forte possibile ricavata da **zero dati**
   (CHECKLIST punti 68 e 94), e quella che **chiuderebbe la pista**. ➡️ Aggiunto il
   **terzo stato**: `NON MISURATO PER INTERO (celle con dati X su 6: qui NON si
   legge un 'no')`. Il `PASSATO` resta un **fatto** anche con celle mancanti,
   perché il criterio ne chiede **due su tre**; il `NON PASSATO` pretende **tutte e
   sei**.
3. 🏷️ *(minore, stessa famiglia)* con un CSV **mancante**, il referto elencava le
   `Intestazioni viste` **dell'ultimo file letto bene** — un valore vecchio che
   racconta un fatto mai accaduto. ➡️ Azzerato a ogni lettura, e i due casi ora
   hanno **due messaggi diversi**.

---

## 8. 🟡 COSA NON È VERIFICATO, e va detto

Tutto ciò che richiede **MT5**, perché in questo ambiente **non esistono
MetaEditor né Strategy Tester**:

- 🔴 **la COMPILAZIONE dell'EA** — mai compilato da nessuno. È il **primo risultato
  vero** del PASSO 0, e il giro di controllo lo produce in un minuto;
- l'esito reale dell'**autotest** (8 blocchi) e il comportamento del **flat sui
  tick veri**;
- **se i tick reali arrivino davvero fino al 2011** su questi tre simboli: la
  profondità del feed è agli atti (R100/R102) ma quella dei **tick** no. Lo dirà il
  numero di `Giornate Operate` per fascia, che il referto mette accanto alla
  soglia **C5** dei 150;
- la **durata** della corsa (§6) e **ogni singolo numero** della tabella.

---

## 9. 🛑 E RESTA C7

Questa corsa **non promuove niente**, **non boccia nessuna sedia**, **non tocca il
forward**. Produce una tabella. Se la tabella è piatta, l'esito è **valido**: il
caduto **D7** esce **confermato ed esteso** e la pista dell'orologio si chiude
**con un numero nostro**.

---

## ➕ APPENDICE — SECONDA VERIFICA, 31/08/2026 (driver portato a `v3`)

Il pacchetto era del **28/08**, cioè **prima** delle ~15 classi nuove aggiunte
alla checklist il **31/08**. È stato ri-verificato contro quelle, **eseguendo** il
driver su un banco stubbato. Sette correzioni, due delle quali **bloccanti**:

1. 🔴 **`-Rifai` non era nell'argv del generico** (classe zombie-run). Misurato:
   con i CSV di ieri sul disco la v2 usciva **verde, exit 0**, con numeri vecchi.
2. 🔴 **La RICOMPOSIZIONE si reggeva sul salto della cache del generico** — cioè
   la trappola era diventata il metodo. Ora c'è **`-Ricomponi`**, che non chiama
   il generico per costruzione e dichiara la data di ogni CSV riletto.
3. 🟠 **C1 contato nella lettura LARGA** (due simboli su **ore diverse** =
   `PASSATO`). Ora il verdetto è la **lettura severa**, la larga si stampa
   etichettata, e la scelta è dichiarata **anche nella specifica congelata**.
4. 🟠 **`@FINOA` mancante nei prova** e `$Fino` uguale al default del generico:
   direttiva aggiunta **nuda** ai sette file e **gattata**.
5. 🟠 **`Tester\cache` mai svuotata**: ora si svuota **coi due conteggi** — qui
   morde davvero, perché il CSV nasce dai **frame** e un pass ripescato non
   scrive nessuna riga.
6. 🟠 **CSV contato ma non letto dentro**: nuovo gate su **tutte** le 24 ore × 3
   durate e sulla colonna **`Lato`**.
7. 🟡 **Rilievo automatico sulla profondità dei tick**: il tick nativo BCM parte
   dal **2024.09.26**, la finestra dal **2011**; a `Model=4` MT5 non si ferma e
   genera i tick dalle M1, quindi lo **spread** del tratto vecchio — **metà del
   cancello C1** — non è quello del tick. Si dichiara, non si corregge.

**Batteria rifatta sulla v3: 14 mutazioni dei file prova → 14 fermate**, più 6
guardie del driver, più il controllo positivo prima e dopo.
