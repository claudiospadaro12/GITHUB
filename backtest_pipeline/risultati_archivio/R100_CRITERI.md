# 📝 R100 — TUTTA LA FLOTTA ORO SU 22 ANNI — ✅ **ESTENSIONE FIRMATA il 23/08/2026**

> ## ✍️ IL VERBALE DELLA FIRMA (23/08/2026, in chat)
> Parole esatte di Claudio: **"FAI PARTIRE R99 SULLE ALTRE SEDIE ORO"**.
>
> **Quell'ordine È la firma dell'estensione**, e questo paragrafo è il suo
> verbale. R100 **non ha criteri propri**: sono i criteri di
> `R99_CRITERI.md`, **firmati il 23/08 con le parole "FIRMO R99, PARTIAMO CON
> L'ORO"**, applicati **INVARIATI, sedia per sedia**. Non è stata cambiata una
> virgola di ciò che il round accetta o rifiuta.
>
> Era peraltro **già previsto**: il referto di R99 (`R99_REFERTO.md`, ultimo
> capoverso) chiude scrivendo _"la stessa misura sulle ALTRE sedie oro (12
> grafici, «concentrazione ORO altissima») è un round nuovo, non un
> corollario — ma ora la macchina esiste"_. R100 è quel round nuovo.
>
> ⚠️ **E vale la regola di casa**: i criteri si cambiano **PRIMA** dei numeri.
> Questo documento è scritto **a numeri di R100 mai visti**.

**Oggetto**: **tutte** le sedie vive su **XAUUSD**, una per una.
**Driver**: `backtest_pipeline/righe/RIGA_R100_ORO_FLOTTA.ps1`
(marcatore `MARCATORE_RIGA_R100_v1`).
**File prova**: `backtest_pipeline/prove/R100_<ea>_<magic>.txt`, **uno per
sedia** — EA diversi hanno input diversi.

---

## 0. 🚫 REGOLA ZERO — cosa questo round NON è (identica a R99)

- **NON è un round di MERITO.** Emendamento **regola B** (16/08): _"il VECCHIO
  giudica il RISCHIO, il RECENTE giudica il MERITO"_. Non si chiede se l'oro
  guadagnava nel 2008: si chiede **quanto avrebbe perso**.
- **NON promuove e NON boccia niente per merito.** L'unico esito possibile per
  ogni sedia è: il contratto regge, oppure la sedia va in **REVISIONE** sulla
  corsia **RISCHIO** (firma 18/08), oppure **NON MISURABILE**.
- **NON è uno sweep.** Una cella sola per sedia, congelata. L'unico asse `Y` è
  `InpMagic`, che è la **coppia gemella di controllo**, non una griglia.
- **NON tocca nessuna sedia viva.** Magic **vergini** del blocco `78xxxx`
  (verificato: **zero occorrenze in tutto il repo**). Tutti i magic vivi
  dell'oro, i `7799xx` di R99 e la collisione `770901` sono **vietati e
  controllati nel codice**.
- **NON è un permesso.** Il numero che esce è un **LIMITE INFERIORE** del
  rischio (modello OHLC, vedi §4 di R99).

---

## 1. 🔒 I CRITERI — **quelli di R99, riportati alla lettera, NON toccati**

> **A.** il **DD massimo dell'equity** su `2004.06.11 → 2026.06.30`
> **B.** la **PEGGIOR GIORNATA in %** (il muro prop giornaliero è 5%)
> **C.** il **DD massimo dentro ciascuna delle quattro finestre di regime**
>
> E **una sola decisione meccanica**:
>
> - ➡️ se il **DD lungo** di una cella supera il **DOPPIO del DD promesso** in
>   `CONTRATTI_SEDIE.md`, quella sedia va in **REVISIONE** (corsia **RISCHIO**
>   del criterio di uscita firmato il 18/08), **senza altre discussioni**.
> - ➡️ se non lo supera, **il contratto resta e ora ha vent'anni sotto**.

**L'unica differenza di formulazione, ed è una TRADUZIONE dichiarata**: R99
scriveva _"al rischio 1%"_ perché quella era la taglia **misurata** della sua
unica sedia. R100 ha dodici sedie con taglie diverse, quindi il criterio A si
esegue **alla taglia di rischio della sedia**, e la taglia **si dichiara
accanto a ogni numero** (§2). Il criterio non cambia: cambia il fatto che
adesso ci sono più taglie.

Restano invariati anche: il **modello OHLC M1** (§4 di R99), le **quattro
finestre di regime** (§8 di R99: prova_regime.ps1 righe 69-75, R50/R56/R59), le
**due diagnostiche oro 2008/2013** che **NON sono criteri** (§8.1 di R99), e il
**PASSO 0 a tre gate** (§5 di R99).

---

## 2. 🪑 IL CENSIMENTO DELLE SEDIE ORO — e la tensione che ci ho trovato

_Costruito leggendo `FLOTTA_ATTIVA.md`, `report/CONTRATTI_SEDIE.md`,
`report/CENSIMENTO_FREQUENZA_FLOTTA_2026-08-22.md` e i sette censimenti `.chr`
del 17-19/08. **La tensione va dichiarata prima dell'elenco**, perché è lei a
decidere cosa il round può misurare._

### 2.1 🔴 LE DUE FONTI NON DICONO LA STESSA COSA, ed è MISURATO

| fonte | cosa dice sull'oro | data |
|---|---|---|
| `FLOTTA_ATTIVA.md` §SCOPERTE | _"Concentrazione ORO altissima: **12 grafici** su XAUUSD"_ — mappa letta dai **52 screenshot** | **02/08/2026** |
| censimento `.chr` più recente (`censimento_rischio_2026-08-19_1534.txt`) | **5** sedie su XAUUSD, e sono le uniche con un **rischio vivo misurato** | **19/08/2026 15:34** |
| `CENSIMENTO_FREQUENZA_FLOTTA_2026-08-22.md` **Tabella C** | delle sedie della squadra storica di `FLOTTA_ATTIVA` (fra cui `GoldenCross_Ottimizzato XAUUSD 970301` e `SupertrendReversal_Multi_Ottimizzato XAUUSD 971001`): **ZERO trade** in tutto lo statement `2026.03.30 → 2026.08.21` | **22/08/2026** |

Quel documento del 22/08 lo dice già a chiare lettere, e non è un'opinione mia:
_"**12 sedie su 14 (86%) a zero trade assoluto**… lettura più probabile, **non
certa**: durante agosto la flotta è stata migrata sui nuovi magic
standardizzati… ma è **un'ipotesi**, non una misura: **va verificato sul VPS
se questi grafici esistono ancora**"_. E aggiunge: _"**nessun censimento `.chr`
più recente del 19/08 è in repo**"_.

> ### ✅ LA TRADUZIONE, DICHIARATA — **due gruppi, e la differenza si scrive accanto a ogni numero**
>
> Il criterio A chiede un DD **a una taglia di rischio**. Per metà delle sedie
> oro quella taglia **non esiste come misura**. Le due uscite sbagliate, ed è
> facile prenderle entrambe in buona fede:
>
> - ❌ **inventare la taglia** (prendere il default del sorgente e chiamarlo
>   "il rischio della sedia") → un verdetto firmato su un numero non misurato.
>   E su una sedia il default è **2,0%**, il doppio: l'errore raddoppierebbe;
> - ❌ **non misurarle affatto** → R100 fotograferebbe 3 sedie su 12 e
>   lascerebbe al buio proprio la parte di flotta di cui sappiamo meno.
>
> **Si fa questo, e si scrive ovunque:**
>
> **GRUPPO 1 — SEDIE CENSITE (3).** Rischio vivo **MISURATO** nel `.chr` del
> 19/08 15:34. Il DD che esce è **il DD della sedia**. Verdetto della corsia
> RISCHIO **pieno** (OK / REVISIONE) quando esiste anche il denominatore.
>
> **GRUPPO 2 — SEDIE NON CENSITE (9).** Dichiarate vive su XAUUSD in
> `FLOTTA_ATTIVA.md` (02/08) ma **assenti da tutti e sette i censimenti `.chr`**
> e a **zero trade** nello statement. Si misurano a **1,00% pinnato**, dichiarato
> come **TAGLIA DI RIFERIMENTO, non come taglia viva**: il numero è un
> **DD-per-1%**, riscalabile linearmente [**APPROSSIMATO**, convenzione di
> `CONTRATTI_SEDIE.md` §COME LEGGERE I NUMERI punto 2] appena un censimento
> `.chr` misurerà il rischio vero. **Il loro verdetto di corsia RISCHIO resta
> `NON MISURABILE`** finché quel censimento non esiste. ⚠️ **E quel "non
> misurabile" NON è un via libera: è esso stesso il rilievo.**
>
> 👉 **Prerequisito che R100 mette agli atti e non può risolvere da solo: un
> censimento `.chr` nuovo del VPS.** Senza, nove grafici sull'oro restano
> misurati ma non giudicabili.

### 2.2 📋 L'ELENCO — 12 misurate, 1 dichiarata e non misurabile

**GRUPPO 1 — rischio vivo MISURATO** (`censimento_rischio_2026-08-19_1534.txt`)

| id | EA | TF | magic vivo | rischio vivo | commento | DD promesso (fonte) | cella |
|---|---|---|---|---|---|---|---|
| **S01** | `ABTG_EMA200_Ottimizzato` | H4 | **971501** | **1,0%** | `EMA200 OTT` | **4,4%** — `CONTRATTI_SEDIE.md` riga 104 (`RISULTATI_OTTIMIZZAZIONE.md`) → **2x = 8,8%** | default sorgente **[DA CONFERMARE]** |
| **S02** | `ABTG_MaxMinNotte` | **H2** | **770402** | **1,0%** | `MAXMIN ORO` | **5,3%** — riga 86 (R17, cella 250/H2) → **2x = 10,6%** | ✅ **MISURATA**: `report/VIVAIO_ORO_DEPLOY.md`, cella campo per campo |
| **S03** | `ABTG_PunteLarry` | H1 | **772343** | **1,0%** | `LARRY ORO` | **3,5%** — riga 137 (R38/R39) → **2x = 7,0%** | ✅ **MISURATA**: preset `VIVAIO_LARRY_ORO` di `deploy_vivaio_larry.ps1` |

**GRUPPO 2 — rischio vivo NON censito** (misurate a 1,00% di riferimento)

| id | EA | TF | magic (sorgente) | rischio default | DD promesso |
|---|---|---|---|---|---|
| **S04** | `ABTG_SupertrendReversal_Multi_Ottimizzato` | H4 | 971001 | ⚠️ **2,0%** | nessuno |
| **S05** | `ABTG_GoldenCross_Ottimizzato` | H1 | 970301 | 1,0% | nessuno |
| **S06** | `ABTG_SupertrendReversal` (nativo) | H4 | 770901 ⚠️ collisione | 1,0% | nessuno |
| **S07** | `ABTG_SupertrendReversal_Multi` (nativo) | H4 | 771001 | 1,0% | nessuno |
| **S08** | `ABTG_EMA200` (nativo) | H4 | 771501 | 1,0% | nessuno |
| **S09** | `ABTG_GoldenCross` (nativo) | H1 | 770301 | 1,0% | nessuno |
| **S10** | `ABTG_SupertrendInvert` | H1 | 770801 | 1,0% | nessuno |
| **S11** | `ABTG_PTE` (oro) | H4 | 771301 | 1,0% | nessuno |
| **S12** | `ABTG_WOL` (oro) | D1 | 771401 | 1,0% | nessuno |

> ⚠️ **NOVE SEDIE SULL'ORO SENZA NESSUN DD PROMESSO.** Su nessuna di loro la
> C3 del 18/08 può scattare, e questo è **lo stesso rilievo che era il vero
> risultato di R99**, moltiplicato per nove. Verificato sul file al pin: la
> funzione di estrazione le cerca e torna `RIGA NON TROVATA`.

**⛔ DICHIARATA E NON MISURABILE (1)**

| EA | simbolo | magic vivo | rischio vivo | perché |
|---|---|---|---|---|
| `Gold_Ichimoku_TK_ATR_EA` | XAUUSD | **250604** | **0,5%** | 🔴 **NON HA IL BLOCCO OPTFRAME.** Misurato nel sorgente: **zero** occorrenze di `OptResults` in `mql5/Experts/Gold_Ichimoku_TK_ATR_EA.mq5`. Non scrive nessun `OptResults_*.csv` → **non esistono né il DD (criterio A), né il n, né il gate dei gemelli**. E non ha `InpVerbose`: il gate 1 non avrebbe la seconda misura |

⚠️ **E non è una sedia qualunque**: è **l'ULTIMA a contratto PARZIALE** della
flotta (`CONTRATTI_SEDIE.md` §SINTESI), i suoi numeri vengono da **un altro
broker** (Tickmill PF 1,54; su BCM lo stesso test dava **PF 1,01 / DD 28%**), e
il censimento frequenza del 22/08 le misura **63 giorni di silenzio**. Il suo
DD promesso è per giunta **AMBIGUO** per il driver: la cella del contratto dice
`DD 4,38% a rischio 0,3% (a 0,5% ≈ 7,3%)`, cioè **è scritto a una taglia
diversa da quella viva**, e il parser si rifiuta di prenderlo (§3.3).
**Come si misurerebbe**: aggiungere l'OPTFRAME all'EA è **una modifica a una
sedia viva e vuole una firma**; leggere il DD dalla riga "Drawdown massimo
dell'equity" del report `.htm` è **uno strumento nuovo, mai validato in nessun
round** — va costruito e verificato, non improvvisato dentro questo.

### 2.3 🧊 LA SEDIA GIÀ FATTA, che si salta e si dichiara

`ABTG_SupertrendReversal_Ottimizzato` XAUUSD **970901** è **R99**, misurata il
23/08: **DD 9,02% su 22 anni a rischio 1%, peggior giornata −0,68%, n=657**.
**R100 NON la rifà** e non la include nella tabella madre come misura nuova:
il suo numero è già agli atti in `R99_REFERTO.md` e il suo contratto è già
stato **riempito su firma di Claudio** lo stesso giorno.

---

## 3. ⚙️ LE TRADUZIONI ESECUTIVE — dichiarate, non nascoste nel codice

### 3.1 🛑 IL FATALE È **PER SEDIA**, non per round

R99 §5.1 dice: prima operazione dopo il `2010.01.01` → **FATALE, si ferma**.
Con una sedia sola quello voleva dire "si ferma il round". Con dodici,
fermare tutto vorrebbe dire che **una sedia storta porta via le altre undici**.

👉 **Il FATALE resta FATALE, ma vale per la SEDIA**: quella sedia si dichiara
**NON MISURATA** con il motivo scritto, e la corsa **passa alla seguente**.
Lo stesso vale per gemelli divergenti, OptResults mancante, compilazione
fallita e gate 1 muto. **Nessun numero di una sedia fermata entra nella
tabella madre.**

### 3.2 🕐 IL GATE 1 SU DODICI MOTORI DIVERSI

R99 leggeva la prima operazione da **due misure indipendenti** (log del tester
+ tabella deal del report) e le eseguiva **sempre tutte e due**. R100 fa
uguale, ma il **marcatore di log è diverso per ogni EA** ed è **preso dal
sorgente che lo produce** (checklist 55): dodici marcatori, tutti verificati
nel `.mq5` prima di lanciare la macchina.

E c'è una **distinzione nuova, misurata nei sorgenti**: alcuni EA loggano
l'**ESECUZIONE a mercato** (`MERCATO`), altri il **PIAZZAMENTO di un ordine
pendente** (`PENDENTE`: EMA200 con `BUY/SELL LIMIT`, MaxMinNotte con
`BUY/SELL STOP`, PunteLarry con `PENDENTE`). Su una sedia `PENDENTE` il log
**precede legittimamente** il primo deal, e "log più vecchio del report" **non
è un difetto, è il mestiere**. Il confronto del gate 1 lo sa e lo dichiara; il
contrario (report **prima** del log su una sedia a pendenti) resta un
**PROBLEMA scritto**, perché un deal non può precedere il suo ordine.

### 3.3 💰 IL DD PROMESSO SI ESTRAE **PER COLONNA**, e si rifiuta se è a un'altra taglia

R99 estraeva il DD promesso con un regex ancorato alla sigla `DD`. **Sulla sua
riga funzionava; sulle altre no**: in `CONTRATTI_SEDIE.md` la colonna si chiama
`DD promesso` **nell'intestazione**, e nelle celle c'è **solo il numero**
(`**5,3%** (R17, cella 250/H2, PF 1,91)`). Quel regex avrebbe stampato
"denominatore assente" su contratti che il numero **ce l'hanno**: un rilievo
**falso**, e in un round di rischio i rilievi falsi costano credibilità quanto
i numeri sbagliati.

👉 R100 trova l'**indice della colonna** `DD promesso` nell'intestazione della
tabella e legge **quella cella**, prendendo il **primo** numero-percentuale
(i successivi sono altre cose: PF, Recovery, "superficie **100%** positiva").
**Verificato sul file vero al pin**: `4,4` · `5,3` · `3,5`, tutti giusti.

🔴 **E si rifiuta di leggere un numero scritto a UN'ALTRA TAGLIA.** Se la cella
contiene una riscalatura (`a rischio 0,3%`, `a 0,5% ≈ 7,3%`), il driver
dichiara **`DD PROMESSO AMBIGUO`**, il **2x resta NON CALCOLABILE** e la riga
va nel referto **verbatim**. _Un denominatore letto alla taglia sbagliata è
peggio di un denominatore mancante._

🔴 **E il vincolo sul SIMBOLO, trovato PROVANDO la funzione prima di
scriverla.** Con il solo vincolo EA+magic, la sedia **S06**
(`ABTG_SupertrendReversal` XAUUSD, magic di sorgente `770901`) pescava la riga
del **`SupertrendReversal` Nikkei H2 su 225JPY**, che porta **lo stesso magic
770901** — la **collisione misurata il 22/08**
(`CENSIMENTO_FREQUENZA_FLOTTA` §5). Sarebbe stato **il DD promesso di un altro
strumento** usato come denominatore di un verdetto firmato. Chiuso col vincolo
sulla colonna `Simbolo`.

### 3.4 🧮 IL CRITERIO B, e il BUG di R99 che questo round nasce per non ripetere

Nella corsa R99 del 23/08 il criterio B è uscito **NON MISURATA** ed è stato
**recuperato a mano** dal report nello zip.

**DIAGNOSI, misurata sul file vero** (`passo0_report_singola.htm`, UTF-16,
terminale in **italiano**). L'intestazione della tabella dei deal è
esattamente:

```
Ora | Affare | Simbolo | Tipo | Direzione | Volume | Prezzo | Ordine |
Commissioni | Swap | Profitto | Bilancio | Commento
```

Il parser cercava `profit`/`profitto` (**TROVATO**) e `balance`/`saldo`
(**NON TROVATO**: MT5 in italiano la chiama **`Bilancio`**). Con l'indice del
saldo a `-1` la funzione tornava **una lista vuota** e il chiamante scriveva
`NON MISURATA` — **il comportamento onesto, su una tabella perfettamente
leggibile**. 👉 **Una parola mancante nell'elenco dei sinonimi.**

E un **secondo difetto che il primo teneva nascosto**: la somma giornaliera
usava **il solo `Profitto`**, mentre `Commissioni` e `Swap` sono colonne
**separate**. Col solo lordo la peggior giornata sarebbe uscita **migliore del
vero** — e in un round di **RISCHIO** l'errore nella direzione comoda è il
peggiore.

**Il calcolo giusto, che R100 esegue** (ed è quello fatto a mano il 23/08):
> somma per **giornata di calendario** di **`Profitto` + `Commissioni` +
> `Swap`** delle righe deal con data → **percentuale sul `Bilancio` di inizio
> giornata** → **minimo**.

Correzioni aggiuntive, tutte dichiarate: la **direzione** si legge **nella sua
colonna** (un `in` dentro la colonna `Commento` non fa più passare per deal una
riga qualunque); il **saldo di inizio della primissima giornata** si **ricava**
dal primo deal (`Bilancio − netto`) invece di dare per scontato il deposito
nominale; i numeri hanno lo **spazio come separatore delle migliaia**
(`9 005.54`) e si tolgono anche gli spazi tipografici; e se l'intestazione non
si riconosce **il referto stampa le intestazioni candidate che ha visto** — il
23/08 per scoprire la parola mancante è servito aprire lo zip a mano.

**[APPROSSIMATO], e resta scritto**: è la peggior giornata sulle **chiusure
realizzate**, non sull'equity intraday. Stessa approssimazione di R51 e di R99.

### 3.5 🎯 UN QUARTO STRUMENTO, dove esiste

`ABTG_PunteLarry` e `ABTG_PTE` hanno l'**OPTFRAME esteso**, con la colonna
**`Peggior Giornata %` calcolata dentro l'EA**. Su quelle due sedie il criterio
B esce **da due strumenti indipendenti**, e il referto **li stampa entrambi**.
Non è un doppione: è **l'unico controllo incrociato che abbiamo sul metodo del
criterio B**. Se divergono molto, è il metodo da guardare, non la sedia.

### 3.6-bis 🔢 IL MAGIC DEL SORGENTE ≠ IL MAGIC VIVO, su due sedie

_Difetto **trovato verificando la tabella contro i sorgenti prima di lanciare**,
non dopo._

Il gate di versione controlla che il `.mq5` scaricato dichiari il magic giusto —
è il modo di dire "questo è il motore che credo". Ma su **due** sedie il magic
**vivo** non è il default del sorgente, **e non è un errore**: è il segno che
quella sedia è un **SECONDO grafico dello stesso EA**.

| sedia | magic del sorgente | magic vivo | cosa vuol dire |
|---|---|---|---|
| **S02** `ABTG_MaxMinNotte` | `770401` | **`770402`** | `770401` è il **MAXMIN EURUSD**. `VIVAIO_ORO_DEPLOY.md` lo scrive in maiuscolo: _"MAI 770401 (è del MAXMIN EURUSD!)"_ |
| **S03** `ABTG_PunteLarry` | `772301` | **`772343`** | è **LARRY ORO**, una delle sei sedie del vivaio R38/R39 |

Col magic **vivo** dentro il gate, quelle due sedie **sarebbero morte al
controllo su un sorgente perfettamente sano**. 👉 Il gate usa il **magic del
sorgente**; il magic vivo resta **l'identità della sedia** (nome del file prova,
riga del contratto, referto). **E dove i due differiscono il referto lo dice** —
perché è anche **la ragione per cui quelle due celle non possono essere i
default del sorgente**, ed è esattamente per questo che sono **MISURATE su un
artefatto di deploy** (§2.2).

### 3.6 🏷️ I MAGIC

Blocco **`78xxxx`**, **VERGINE**: verificato con una ricerca su tutto il repo
(`.mq5`, `.md`, `.ps1`, `.txt`, `.csv`, `.set`, `.mqh`) → **zero occorrenze**.

Schema `78SSNN`: `SS` = numero della sedia (01-12), `NN` = lo slot
(`10/11` gemelle intere · `12` singola intera · `20/21` ORSO · `30/31` CROLLO ·
`40/41` TORO · `50/51` LATERALE · `60/61` diagnostica 2008 · `70/71`
diagnostica 2013).

**Vietati e controllati nel codice**: `970901` `770901` `970301` `971001`
`971501` `771501` `770801` `771301` `771401` `770301` `770401` `770402`
`772343` `250604` `770921` `770922` `770923` `770924` `770925` `779910`
`779911` `779912` `779001`.

### 3.7 🧾 IL PASSO 0-A SI FA **UNA VOLTA SOLA**

Il simbolo è **XAUUSD per tutte e dodici**: scaricare le barre dodici volte
sarebbe tempo buttato. Si scaricano **M1 + H1/H2/H4/D1** dal `2004.06.11`,
**senza tick** (il modello è OHLC M1). Il verdetto **non-`COMPLETO` sull'M1 è
ATTESO** — `scarica_storico.ps1` dà 120 secondi per timeframe e 22 anni di M1
non ci stanno — quindi va nelle **NOTE** e non nei PROBLEMI (checklist 47: una
spia che non può che essere rossa non la legge più nessuno). Il tester completa
da solo mentre gira, e **la misura che decide resta la prima operazione**.

---

## 4. ⏱️ DURATA E RIPRESA

R99 ha fatto **una** sedia (9 passate su 22 anni) in **pochi minuti**, con lo
scarico delle barre M1 dentro la prima passata. Qui le sedie sono **12** e le
barre si scaricano **una volta sola**: l'ordine di grandezza atteso è
**2-6 ore**, non venti minuti e non due giorni. **`-OreMax` è 20**, con margine
largo apposta: il tetto non deve tagliare il round, deve solo impedirgli di
girare per sempre — e **non ammazza un lavoro in corso**, smette solo di
iniziarne di nuovi (checklist 19).

**Le sedie si processano UNA ALLA VOLTA, mai in parallelo.** La **ripresa è
attiva**: i CSV già presenti vengono **saltati e dichiarati**, con la **data
del file nel referto** — un CSV di ieri non è un risultato di oggi, e se fra i
due lanci fosse cambiato il pin **metà round verrebbe da un altro motore**
(checklist 15 e 53). `-Rifai` li rifà. `-SoloSedia S03` fa una sedia sola, e il
referto lo scrive.

---

## 5. 📋 COSA PUÒ USCIRE DA R100, E COSA NO

**Può uscire:**
1. **LA TABELLA MADRE** — sedia · rischio vivo · DD promesso (con fonte) · DD
   misurato su 22 anni · `2x?` · peggior giornata · verdetto corsia RISCHIO.
   **È la fotografia del rischio di tutta la concentrazione oro**, ed è il
   prodotto finale del round;
2. i **tre numeri** (A, B, C×4) + le due diagnostiche, **per ogni sedia
   misurata**;
3. il verdetto meccanico **`2x`**, dove il denominatore esiste;
4. **PROPOSTE** (da firmare a parte) di riempire i contratti mancanti coi
   numeri misurati — **nove sedie oro non hanno nessun DD promesso**;
5. il **rilievo di perimetro**: serve un **censimento `.chr` nuovo del VPS**
   per sapere quali di quei nove grafici esistono ancora e a che rischio.

**Non può uscire:**
- nessuna promozione, nessuna bocciatura **di merito**, nessun cambio di
  parametri, nessuna sedia nuova, nessuna sedia spenta;
- nessun giudizio sul PF/profitto delle finestre vecchie;
- nessun numero a tick reali (**il modello è OHLC**), nessun numero di spread;
- 🔴 **e soprattutto: NESSUN DRAWDOWN DI PORTAFOGLIO.** Dodici sedie sullo
  stesso simbolo **non** fanno un drawdown pari alla somma dei loro, né pari al
  massimo: dipende da **quanto si sovrappongono nel tempo**, e questo round
  misura le sedie **una per una, mai insieme**. Il DD di portafoglio dell'oro è
  **un round diverso** (macchina dei round di portafoglio R16/R34/R37/R41) e,
  su una concentrazione come questa, è **la domanda successiva ovvia**.

---

## 6. 🧾 DA DOVE VIENE OGNI PEZZO — la mappa delle fonti

| pezzo | fonte | stato |
|---|---|---|
| i criteri A/B/C e il 2x | `R99_CRITERI.md` §3, firmati 23/08 | ✅ **FIRMATI, non toccati** |
| l'ordine di estenderli | Claudio in chat 23/08: _"FAI PARTIRE R99 SULLE ALTRE SEDIE ORO"_ | ✅ **È LA FIRMA** (§0) |
| `@DAQUANDO 2004.06.11` | `REFERTO_SONDA_STORICO_17-08.md` sez. 2 | ✅ MISURATO |
| rischio/magic/commento del GRUPPO 1 | `censimento_rischio_2026-08-19_1534.txt` | ✅ MISURATO |
| cella di MAXMIN ORO | `report/VIVAIO_ORO_DEPLOY.md` | ✅ MISURATA (deploy) |
| cella di LARRY ORO | preset `VIVAIO_LARRY_ORO` in `deploy_vivaio_larry.ps1` | ✅ MISURATA (preset) |
| gli altri input delle celle | default del sorgente al pin | 🟡 **[DA CONFERMARE]** col `.chr` |
| rischio/magic del GRUPPO 2 | default del sorgente | 🔴 **NON MISURATI** (§2.1) |
| "12 grafici sull'oro" | `FLOTTA_ATTIVA.md` (02/08, screenshot) | 🟡 **INVECCHIATO, dichiarato** |
| zero trade delle sedie GRUPPO 2 | `CENSIMENTO_FREQUENZA_FLOTTA_2026-08-22.md` Tab. C | ✅ MISURATO |
| DD promesso di ogni sedia | `report/CONTRATTI_SEDIE.md` al pin, **per colonna** | ✅ ESTRATTO DALL'ARTEFATTO |
| assenza di OPTFRAME in Gold_Ichimoku | `mql5/Experts/Gold_Ichimoku_TK_ATR_EA.mq5` | ✅ MISURATA (0 occorrenze) |
| le 4 finestre di regime | `prova_regime.ps1` righe 69-75 (R50/R56/R59) | ✅ AGLI ATTI |
| le 2 finestre diagnostiche oro | R99 §8.1 | 🟡 **DICHIARATE, non criteri** |
| soglia fatale "dopo il 2010" | traduzione di R99 §5.1, qui **per sedia** | 🟡 **DICHIARATA** (§3.1) |
| verginità del blocco 78xxxx | ricerca su tutto il repo | ✅ MISURATA (0 occorrenze) |

---

## ✍️ FIRMA — ✅ **ESTENSIONE ORDINATA il 23/08/2026, in chat**

> **"FAI PARTIRE R99 SULLE ALTRE SEDIE ORO"** — Claudio, 23/08/2026.

I criteri di accettazione sono **quelli di R99, parola per parola**. Le
traduzioni esecutive (§2.1, §3.1, §3.2, §3.3, §3.4, §3.7) sono **aggiunte
dichiarate**, non modifiche: **nessuna di esse cambia cosa il round accetta o
rifiuta** — cambiano solo **dove si legge il numero**, **a quale taglia lo si
legge** e **cosa si scrive quando il numero non si può leggere**.
