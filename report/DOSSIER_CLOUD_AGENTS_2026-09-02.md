# DOSSIER — AGENTI CLOUD MQL5 PER LE NOSTRE CORSE

**Data: 02/09/2026** · idea di Claudio del 01/09 sera (64.045 agenti visti nel tester)
**Chi lo scrive:** agente cacciatore di configurazioni. **NON ho attivato niente,
NON ho toccato il forward, NON ho speso un centesimo.**
**Cosa decide questo dossier:** SE si puo', QUANTO costa, COME si prova senza rischi.

---

## 🔴 VERDETTO IN UNA RIGA

# **FATTIBILE CON RISERVE**

**Il blocco che temevamo NON C'E'**: le nostre due sonde sono gia' scritte nel
modo esatto che la documentazione MetaQuotes raccomanda per il cloud (frame
dall'agente, file scritto SOLO dal terminale). Sono cloud-compatibili **oggi,
senza toccare una riga**.

**Ma le riserve mordono, e sono tre:**
1. i **tick reali** (il nostro `Model=4`) sul cloud sono **materia contestata e
   non documentata** — MetaQuotes li ha vietati nel 2019 e riabilitati senza
   annuncio; il rischio e' che l'agente cloud **degradi silenziosamente a tick
   generati** e ci restituisca numeri diversi senza dirlo;
2. il collo di bottiglia che abbiamo MISURATO il 01/09 **non erano i core**:
   era la **RAM** (OOM con 8 agenti). Sistemato scendendo a 4 agenti, la cella
   03 e' passata da ~1 ora a **~1 minuto a passata** — cioe' oggi e' un lavoro
   da **~36 minuti in locale**, non da tre giorni;
3. **non esiste un tetto di spesa** ne' una stima preventiva: il cloud non si
   ferma quando finisce il credito (segnalazione utente, §5).

---

## 1. 🧪 CONTROLLO POSITIVO SU OGNI FONTE (fatto PRIMA di cercare)

| fonte | bersaglio noto | esito |
|---|---|---|
| `mql5.com/en/docs/runtime/testing` | deve mostrare i 3 modi di generazione tick + i limiti agenti | ✅ **HTTP 200**, contenuti veri, 554 righe di testo |
| `cloud.mql5.com/en/faq/payments` | deve mostrare il prezzo agente PR=100 | ✅ **HTTP 200**, "$0.08 per hour" trovato |
| `cloud.mql5.com/en` | deve mostrare il contatore agenti (Claudio ne ha visti 64.045) | ✅ **HTTP 200** → **"Agents Online 64 027"** letto il 02/09/2026 — **il numero di Claudio e' confermato dalla fonte** |
| `mql5.com/en/forum/*` (5 thread) | devono mostrare post con date e autori | ✅ **HTTP 200** su tutti e 5 |
| `mql5.com/en/articles/341` e `/669` | devono mostrare gli articoli | ✅ **HTTP 200** |
| **`www.metatrader5.com`** (Help ufficiale) | pagina `mql5cloud_calculation` e `start_advanced/start` | 🛑 **EGRESS_BLOCKED dal proxy** — **fonte NULLA per me**. I numeri di prezzo li ho presi dal mirror `cloud.mql5.com/en/faq/payments` (stesso editore) e le chiavi `.ini` da due fonti indipendenti su mql5.com. **Claudio o il verificatore devono ricontrollare la pagina ufficiale prima di spendere.** |
| `cloud.mql5.com/en/faq/general` | — | ⚠️ **404** (= non esiste, NON e' un blocco). La FAQ vera sta su `/en/faq` e `/en/faq/settings`, entrambe lette. |

---

## 2. ✅ COMPATIBILITA' DELLE NOSTRE SONDE — **QUESTO DECIDE TUTTO**

### 2.1 La regola, dalla bocca di MetaQuotes

Documentazione ufficiale, `mql5.com/en/docs/runtime/testing`, sezione
**"Memory and disk space limits in MQL5 Cloud Network"**, letta il 02/09/2026,
**verbatim**:

> "The following limitation applies to optimizations run in the MQL5 Cloud
> Network: the Expert Advisor must not write to disk more than 4GB of
> information or use more than 4GB of RAM. If the limit is exceeded, the network
> agent will not be able to complete the calculation correctly, and you will not
> receive the result. **However, you will be charged for all the time spent on
> the calculations.**"
>
> "**If you need to get information from each optimization pass, send frames
> without writing to disk.** To avoid using file operations in Expert Advisors
> during calculations in the MQL5 Cloud Network, you can use the following
> check:"
> ```
> if(MQLInfoInteger(MQL_OPTIMIZATION) || MQLInfoInteger(MQL_FORWARD))
>    file_operations_allowed = false;
> ```

E, stessa pagina, sezione **"The Data Exchange between the Terminal and the Agent"**:

> "The agents never record to the hard disk the EX5-files, obtained from the
> terminal (EA, indicators, libraries, etc.) for security reasons... **In remote
> agents you can not test EAs using DLL.**"
> "All traffic between the terminal and the agent is encrypted."

### 2.2 `ABTG_SondaOrologio.mq5` → 🟢 **CLOUD-OK, senza modifiche**

**Righe esatte** (`mql5/Experts/ABTG_SondaOrologio.mq5`):

- **riga 876** `double OnTester()` — gira **sull'agente**. Riempie `stats[26]` e
  chiude a **riga 929** con:
  ```
  FrameAdd(OPTFRAME_NAME, OPTFRAME_ID, criterion, stats);
  ```
  **Nessun `FileOpen` in questa funzione.** E' esattamente il "send frames
  without writing to disk" della doc.
- **riga 933** `int OnTesterInit() { return(INIT_SUCCEEDED); }` — gira sul terminale, inerte.
- **riga 935** `void OnTesterDeinit()` — gira **SUL TERMINALE, non sull'agente**.
  Qui, e **solo** qui, sta l'unico `FileOpen` del file:
  ```
  938:   int h = FileOpen(fname, FILE_WRITE|FILE_CSV|FILE_ANSI, ",");
  941:   FrameFilter(OPTFRAME_NAME, OPTFRAME_ID);
  944:   while(FrameNext(pass, name, id, value, data))
  966:      FileWrite(h, row); righe++;
  968:   FileClose(h);
  ```
  Il CSV viene **scritto dal terminale raccogliendo i frame** che tornano dagli
  agenti. **Nessun `FILE_COMMON`** (grep su tutto il file: zero occorrenze).

**Grep di controllo su tutto il file — `FileOpen` compare UNA volta sola, alla
riga 938, dentro `OnTesterDeinit`.** Non c'e' scrittura su disco dentro il pass.

- **Zero `#import`, zero `.dll`, zero `iCustom`, zero `#property tester_*`.**
  Unico include: **riga 154** `#include <Trade/Trade.mqh>` — libreria standard,
  presente su ogni agente. **Niente da spedire oltre l'.ex5.**

### 2.3 `ABTG_SondaM0PB.mq5` → 🟢 **CLOUD-OK**, e con la guardia **gia' scritta**

Questa sonda **scrive** due CSV per-passata... ma **si autospegne in
ottimizzazione**, con lo stesso identico controllo della documentazione:

- **riga 772** (CSV riga-per-segnale, aperto in `OnInit`):
  ```
  if(InpScriviCsv && !MQLInfoInteger(MQL_OPTIMIZATION))
  ```
  con il commento di casa alle righe 768-771: _"il CSV riga-per-segnale esiste
  SOLO fuori dall'ottimizzazione: con piu' passate che condividono lo stesso
  file ogni passata sovrascriverebbe la precedente"_.
- **riga 1362** (CSV dei totali, chiamato da `OnTester`):
  ```
  if(InpScriviCsv && !MQLInfoInteger(MQL_OPTIMIZATION)) ScriviCsvTotali(stats);
  ```
- **riga 1371** `FrameAdd(...)` — la via buona, come l'altra sonda.
- **riga 1429** `OnTesterDeinit()` → `FileOpen` a **riga 1432** + `FrameNext` a
  **riga 1439**: raccolta sul **terminale**.
- **Zero `#include`, zero `#import`, zero DLL, zero `iCustom`** (riga 9 del file
  lo dichiara pure: _"Non esiste #include <Trade/Trade.mqh>"_).

> 🎯 **La battuta che conta:** l'unica differenza fra la nostra guardia e quella
> del manuale MetaQuotes e' che loro aggiungono `|| MQLInfoInteger(MQL_FORWARD)`.
> Noi lanciamo sempre con **`ForwardMode=0`** (riga 651 di
> `walkforward_generico.ps1`), quindi non ci sono passate forward: **la
> differenza e' inerte**. Se un giorno accendessimo il forward MT5, quella
> mezza riga andrebbe aggiunta.

### 2.4 Il limite dei 4 GB — ci sta larghissimo

`stats[26]` e `stats[45]` sono array di `double` da qualche centinaio di byte
per passata. Il consumo RAM dell'agente e' quello del tester (cache tick), non
dell'EA. **Nessun rischio di sforare i 4 GB [INFERITO dalla dimensione degli
array e dall'assenza di allocazioni dinamiche grosse].**

**⚠️ Ma il 01/09 il tester locale E' andato in OOM** ("no memory for ticks
generating", `NOTA_PAVIMENTO_TICK_FOREX_2026-09-01.md`). Quello e' consumo del
**tester**, e la doc dice che se l'agente cloud sfora **paghiamo lo stesso**.
Vedi bandiera rossa §6.3.

---

## 3. 🌐 COME FUNZIONA E COME SI ATTIVA (dalla documentazione, non a memoria)

### 3.1 Attivazione — **serve l'account MQL5 loggato nel terminale**

FAQ ufficiale `cloud.mql5.com/en/faq/settings`, letta il 02/09/2026, **verbatim**:

> "**How to buy computing power in the MQL5 Cloud Network?**
> MQL5 Cloud Network agents can be only accessed from the MetaTrader 5 trading
> terminal. To allow the Strategy Tester to connect to the computing network,
> **go to the terminal settings and specify your MQL5.community account
> credentials.**"

Articolo ufficiale MQL5 **341**, "Speed Up Calculations with the MQL5 Cloud
Network", **verbatim**:

> "Before that, do not forget to **specify your MQL5.community login in the
> terminal settings and allow the use of the MQL5 Cloud Network**. The four
> required steps are shown in the below figure."
>
> "The list of servers of the MQL5 Cloud Network and the number of cloud agents
> available through them can be found in the terminal, **the Tester window, tab
> 'Agents'**."

⚠️ **[INCERTO]** L'articolo 341 e' del **2015 (build 1075)** e la figura coi
"quattro passi" non e' testo: **non ho potuto leggere i nomi esatti delle
caselle nella GUI odierna.** La sequenza operativa va confermata a schermo da
Claudio (Strumenti → Opzioni → Community, poi Tester → scheda Agenti).

### 3.2 Cosa viene spedito agli agenti (articolo 341, **verbatim**)

> "The terminal prepares a task for the testing agents, which includes:
> a compiled Expert Advisor file with the EX5 extension · indicators and EX5
> libraries that are enabled using the directives #property tester_indicator and
> #property tester_library (**DLL's are definitely not allowed in the cloud**) ·
> data files needed for the test, enabled using the directive #property
> tester_file · testing/optimization conditions ... · trading environment (symbol
> properties, trading conditions, etc.) · the set of Expert Advisor parameters"
>
> "In this case the files of Expert Advisors, indicators, libraries and data
> files are not stored on the hard drives of the MQL5 Cloud Network servers.
> Also, EX5 files are not stored on hard disks of cloud agents for reasons of
> confidentiality."

### 3.3 Come viaggia lo STORICO — **il punto dolente** (articolo 341, verbatim)

> "**Each node of the MQL5 Cloud Network keeps the history of the required
> symbols and sends it to the agents connected to it on demand. If it has no
> history of symbol XYZ from broker ABC, then the node automatically downloads
> the necessary history data from your terminal.** Therefore, your terminal
> should be ready to provide such a story. **We recommend you to run a
> preliminary single test of a strategy on your computer before you send it to
> the MQL5 Cloud Network.**"

E dalla documentazione (`docs/runtime/testing`):

> "Testing agents, in turn, receive history from the terminal **in the packed
> form**... The history is loaded in a packed form to reduce the traffic."
> "**Ticks are not sent over the network, they are generated on testing agents.**"

> 🔴 **Quest'ultima riga e' la crepa.** Se i tick "non viaggiano" e vengono
> "generati sugli agenti", allora a `Model=4` **cosa succede?** La doc **non lo
> dice.** Vedi §4.

### 3.4 La riga di GIORNALE che ci fa da prova (articolo 341, verbatim)

> `2015.02.05 16:44:38   Statistics   locals 14040 tasks (100%), remote 0 tasks (0%), cloud 0 tasks (0%)`
> `2015.02.05 15:14:44   Statistics   locals 3412 tasks (24%), remote 10628 tasks (75%), cloud 0 tasks (0%)`

🎯 **Questa riga e' il nostro strumento di verifica gratuito**: dice **quante
passate le ha fatte chi**. Nel piano di collaudo (§7) e' l'unica prova che il
cloud abbia davvero lavorato — senza di essa un test "riuscito" potrebbe essere
stato fatto tutto in locale.

---

## 4. ⚖️ DETERMINISMO — la domanda vera, e la risposta onesta

### 4.1 Cio' che gioca a favore [VERIFICATO]

- **Stesso motore, stessa build**: FAQ `cloud.mql5.com/en/faq/settings`:
  _"You do not need to update tester agents manually, while they are updated
  automatically."_
- **Il nostro `Optimization=1`** (riga 647 di `walkforward_generico.ps1`) e'
  l'algoritmo **completo**, non genetico: l'insieme delle passate e' la griglia
  intera, **fissa per costruzione**. Con il genetico (`Optimization=2`) il
  risultato non sarebbe nemmeno riproducibile in locale.
- **Niente DLL, niente `iCustom`, niente `tester_file`** nelle nostre sonde: non
  c'e' codice esterno che possa comportarsi diversamente altrove.
- **Nessuna dipendenza da file locali** dentro il pass (§2): l'agente non deve
  leggere niente dal nostro disco.

### 4.2 Cio' che gioca CONTRO — **e non e' risolto** 🟠 [INCERTO]

Thread `mql5.com/en/forum/311979` — un utente riceve a schermo il messaggio del
tester, **verbatim**:

> **"real ticks optimization not allowed in Cloud Network"**

Il moderatore **Sergey Golubev (2019.04.27 06:18)**, verbatim:
> "It is related to Cloud only with 'every tick based on real ticks'
> optimization."

Ma nello stesso thread, **Renat Fatkhullin (2019.03.24)**, verbatim:
> "Real ticks tests will be accepted again."

E il thread piu' recente che ho trovato, `mql5.com/en/forum/508137`
(**9-10 aprile 2026**), e' letteralmente il nostro incubo. L'utente
`ysfmohamed15`, verbatim:

> "I have tried the cloud network and tried to run a test optimization the
> results was very good so I double clicked the top performer result to see the
> graph on my pc and **shocked that the results was extremely bad**... one thing
> I have tried is to switch results based on real ticks to the first option
> every tick which **gave almost the same results as the cloud network** so I
> assume that **cloud network don't use every tick based on real ticks**"

Il moderatore **Alain Verleyen**, verbatim: _"You can't real ticks are not
available with Cloud optimization."_ — poi si corregge: _"You are right, it's
incorrect information, **I was confused by outdated information.**"_

**Stanislav Korotky**, verbatim (il post decisivo):
> "Could you please provide a link to the official documentation with relevant
> info? **I can't find a mention of this important limitation**, and without this
> this looks like a serious bug. **If the real ticks are not supported by MQL5
> cloud, then the tester should not allow to start real ticks optimization on the
> cloud or, at least, ask a confirmation from the user that [s]he agrees to
> downgrade to the artificial ticks generation mode.** Otherwise, users will face
> the same issue (with optimization results descrepancies) again and again."
>
> "**I tried a small real ticks optimization with the Cloud, and it worked**, so
> it should be working fine in general I guess. The only official information I
> could find is from 2019: *Tester: Disabled ability to test and optimize Expert
> Advisors through MQL5 Cloud Network in the real tick mode. This mode can only
> be used on local agents and local network farms.* I probably missed the
> official announcement when it was enabled again."

### 4.3 Il verdetto sul determinismo

| | |
|---|---|
| **[VERIFICATO]** | Il divieto tick reali sul cloud **e' esistito** (release note 2019) ed e' **stato tolto** (Renat 03/2019 + prova diretta di Korotky, 04/2026). |
| **[VERIFICATO]** | **Non esiste documentazione ufficiale** che descriva il comportamento attuale. Un moderatore MQL5 nel 2026 ha dato l'informazione sbagliata e si e' dovuto correggere. |
| **[INCERTO]** | Se in caso di tick reali mancanti sull'agente cloud il tester **degradi in silenzio** a tick generati. La doc dice *"Ticks are not sent over the network"*; se vale anche a `Model=4`, il degrado e' **certo e silenzioso**. |
| **[INFERITO]** | Il nostro caso e' **meno esposto della media**: il pavimento tick BCM forex e' **2024.07.05** (`NOTA_PAVIMENTO_TICK_FOREX_2026-09-01.md`), quindi **su 15,5 anni di finestra ~13,5 girano GIA' a tick generati** anche in locale. Solo l'ultimo ~13% e' tick vero. Un eventuale degrado colpirebbe **una fetta piccola** — ma **cambierebbe comunque i numeri**, e un CSV che non combacia e' un CSV che non si legge. |

> 🎯 **Conclusione:** il determinismo **NON e' garantito su carta** e **NON si
> puo' dedurre**. **Si misura.** Ed e' esattamente per questo che la cella
> `00_GEMELLI` esiste. Costo della misura: **4 passate** (§7).

---

## 5. 💰 COSTI — tabella [STIMA], con le fonti

### 5.1 La formula ufficiale [VERIFICATO] — `cloud.mql5.com/en/faq/payments`, 02/09/2026

> "**The cost of a tester agent with PR=100 is $0.08 per hour.** One work unit is
> equal to quant. A quant represents a work of an agent with PR=1 during 1 ms
> (1 millisecond). Thus, the cost of one quant is:
> **QuantPrice = 0,08 USD/(100PR × 3 600 000 ms) = 2,22222E-10 [USD/(PR·ms)]**"
>
> "In addition to the service cost, **a fee is charged for the internet traffic
> transmitted to each agent** for task execution. The transmitted data includes
> the file of the Expert Advisor being tested, its input parameters, environment
> settings, price data and other service information. **The traffic cost is USD
> 0.00002 per megabyte.**"

**Costo = 2,22222E-10 × PR × millisecondi_di_lavoro.**

📌 **La conseguenza che rende la stima possibile:** il costo e' proporzionale a
**PR × tempo**, cioe' al **LAVORO DI CPU**, non alla velocita' dell'agente. Un
agente doppiamente veloce (PR 200) finisce in meta' tempo e **costa uguale**.
Quindi **il nostro cronometro locale, moltiplicato per il PR della NOSTRA
macchina, e' un predittore legittimo del costo cloud.**
⚠️ **Il PR del portatile i7-8550U NON e' misurato** — si legge nel tester,
scheda **Agenti**, colonna PR. **Sotto uso PR = 100 come [STIMA]**; se il PR
vero e' 70, i costi calano del 30%; se e' 130, salgono del 30%.

### 5.2 La tabella [STIMA]

Base misurata: **~1 minuto a passata** dopo il fix RAM del 01/09
(`NOTA_PAVIMENTO_TICK_FOREX_2026-09-01.md`, verbatim: _"Dopo il riavvio:
~1 minuto a passata contro ~1 ora prima."_), a **tick reali, GBPUSD H1,
2011→2026**.

| lavoro | passate | lavoro CPU | **costo formula @PR=100** | **costo REALE atteso (×2-3, §5.3)** | tempo LOCALE oggi (4 agenti) |
|---|---:|---:|---:|---:|---:|
| **`00_GEMELLI` (il collaudo)** | **4** | 4 min | **$0,005** | **$0,01 – $0,02** | ~1 min |
| **cella 03 GBPUSD (una)** | **144** | 2,4 h | **$0,19** | **$0,38 – $0,58** | **~36 min** |
| sonda orologio COMPLETA (6 celle + gemelli) | 868 | 14,5 h | $1,16 | $2,3 – $3,5 | ~3,6 h |
| round medio di casa | ~1.500 | 25 h | $2,00 | $4 – $6 | ~6,3 h |
| round pesante | ~5.000 | 83 h | $6,67 | $13 – $20 | ~21 h |
| griglia mostruosa | ~20.000 | 333 h | $26,7 | $53 – $80 | ~3,5 giorni |

**Traffico:** a $0,00002/MB, anche **1 GB spedito costa $0,02**. In dollari e'
**irrilevante**. Il problema del traffico e' il **TEMPO**, non il prezzo (§5.3).

### 5.3 I costi VERI riportati dagli utenti — **sempre piu' alti della formula** 🟠

| fonte | dichiarato | nota |
|---|---|---|
| `forum/460345` — Vikram J U | **10.000 passate = 50 min = $9,45**, poi corretto in **$9,60** su $10 di credito | modello non dichiarato. Verbatim: _"But its too expensive"_ |
| stesso thread — **Alain Verleyen** (moderatore) | _"You make to Cloud agents working for around 3 days in total. For an agent with PR=100, 1 hour of work is 0.04 USD. So 3 days of work would be: 0.04\*3\*24 = 2.88 USD. **Your 9.60 seems effectively high**, you need to write to the ServiceDesk"_ | ⚠️ Verleyen usa **$0,04/h**, la FAQ dice **$0,08/h**: la discrepanza fra due fonti MQL5 e' **agli atti, non risolta** |
| stesso thread — utente 2017 | _"Using the MetaQuotes price calculation, **I should have been charged $11.49, but I got charged $21.56** which is almost double"_ | **1,9×** |
| stesso thread (in italiano) | _"ho terminato un'ottimizzazione 'completa' ma con **OHLC** per un totale di sole **4.375 variabili** ed e' costata **5,50€**"_ | ~€0,00126/passata **in OHLC** |
| `forum/473375` | _"My initial calculation was **$0.00026 per run**... Unfortunately the cost ended up being **more than double** the initial per unit run! ... **MQL5 Cloud Network doesn't seem to stop when you've run out of credits either**"_ | 🔴 **nessun tetto di spesa**. Il thread **non ha ricevuto risposta**. |
| `forum/467593` — Alain Verleyen | _"the cost seems to be **overestimated by a factor between 2 and 3**. The tasks page is talking about 'task execution cost considering the traffic generated'... But I didn't find anywhere what could the cost for the 'traffic'"_ | **la fonte del ×2-3 in tabella** |
| `forum/467593` — **Shalem Loritsch** (fornitore di agenti, vista dall'interno) | _"The MQL5 Cloud Network is **quite data-hungry**. The majority of this data usage comes from synchronizing market history database files **on a per-broker basis**, and is often the primary source of delays... it will **redownload historical tick data** for markets and brokers **almost each time it starts a new job**, irregardless of already having the needed data... every 4-16 agents is a different PC that has to do its own synchronization"_ | 🔴 **spiega perche' i lavori PICCOLI non convengono** |

> 🔴 **La lezione dei numeri veri: il conto vero e' fra 2 e 3 volte la formula, e
> nessuno sa esattamente perche'.** In tabella l'ho gia' applicato.

### 5.4 La velocita' — quanto si guadagna DAVVERO

Articolo 341 (2015, i7 8 core, build 1075), **verbatim**:
> "14,040 passes on 8 local agents took **1 hour, 3 minutes and 44 seconds**"
> "With MQL5 Cloud Network the optimization process is **150 times faster**! ...
> The optimization took only **26 seconds**"

⚠️ Quel numero e' su **`1 minute OHLC`** (dichiarato nell'articolo:
_"Price simulation mode: 1 minute OHLC"_) e su una finestra di **9 mesi**.
**Non e' il nostro caso** (tick reali, 15,5 anni). E per Loritsch (§5.3) i
lavori piccoli **si mangiano il vantaggio in sincronizzazione**.

**[INFERITO]** Sui nostri lavori — passate LUNGHE (1 min l'una), storico LUNGO
(15,5 anni), poche passate (144) — il guadagno atteso e' **molto inferiore a
150×**: il tempo e' dominato dal **warm-up + sync dello storico su ogni PC
nuovo**, che si paga UNA volta per agente ma su 144 passate distribuite su
decine di PC **si paga decine di volte**. **Su un lavoro da 144 passate il
cloud potrebbe non essere piu' veloce del nostro portatile.**

---

## 6. 🚩 BANDIERE ROSSE — dichiarate, non minimizzate

### 6.1 🔴 I nostri dati BCM finiscono su PC di terzi

Articolo 341, verbatim: _"Each node of the MQL5 Cloud Network **keeps the history
of the required symbols** and sends it to the agents connected to it on demand.
If it has no history of symbol XYZ from broker ABC, then **the node
automatically downloads the necessary history data from your terminal**."_

**Cosa esce di casa:** lo **storico prezzi BCM** (barre M1 + tick reali dal
2024.07.05) e la **specifica di contratto** del simbolo — verso i server
MetaQuotes e poi verso **PC di sconosciuti in tutto il mondo**.

**Cosa NON esce:** il conto, la password, gli ordini, le posizioni vive. Gli
`.ex5` non vengono salvati su disco dagli agenti (§3.2). Il traffico e'
cifrato ("All traffic between the terminal and the agent is encrypted").

**Il mio giudizio:** su un **conto DEMO 50503392** e con storico di un broker
retail (non un feed proprietario che abbiamo pagato), **il danno pratico e'
vicino a zero** — le barre BCM sono le stesse che chiunque scarica aprendo un
conto BCM. ⚠️ **Ma va detto a Claudio prima, non dopo**, ed e' una cosa che
cambierebbe di segno il giorno in cui girassimo su un feed a pagamento o su
simboli importati nostri.

### 6.2 🔴 **Simboli CUSTOM: VIETATI sul cloud** — e noi ne abbiamo

Messaggio del tester riportato sul forum: **"custom symbols not allowed in Cloud
Network"** (`mql5.com/en/forum/309741`). Motivo dichiarato: simboli custom con lo
**stesso nome ma storia diversa** su PC diversi renderebbero i risultati non
confrontabili.

🎯 **Ci riguarda direttamente:** in `HANDOFF.md` risultano corse su storico
importato **`GBPUSD_EXT` / `EURUSD_EXT`** (2,55 milioni di barre) e su
`ABTG_ImportEsterno`. **Tutta quella famiglia di lavori NON puo' andare in
cloud.** [VERIFICATO nel repo + VERIFICATO come limite MQL5]

Le sonde orologio/M0PB girano su **simboli BCM nativi** (EURUSD, GBPUSD, XAUUSD):
**quelle passano**.

### 6.3 🔴 Si paga anche quando il lavoro FALLISCE

Doc ufficiale, verbatim: _"**However, you will be charged for all the time spent
on the calculations**"_ (in caso di sforamento 4 GB).

E il **01/09 il nostro tester e' andato in OOM davvero** ("no memory for ticks
generating", 16 GB saturi con 8 agenti). Se lo stesso succedesse su un agente
cloud con 4 GB di tetto e la nostra finestra di 15,5 anni a tick generati,
**pagheremmo il fallimento**. **[INCERTO]** quanta RAM chieda davvero una nostra
passata: **non e' mai stato misurato**; sappiamo solo che 8 passate insieme
saturano 16 GB → **~2 GB a passata [INFERITO], dentro i 4 GB ma non di tanto**.

### 6.4 🔴 Nessun tetto di spesa, nessuna stima preventiva

`forum/473375`, verbatim: _"**MQL5 Cloud Network doesn't seem to stop when
you've run out of credits either**"_ e _"Is there a more reliable way of
estimating the cost of a run before you start... can this not be provided to the
user prior to submission?"_ — **il thread e' rimasto senza risposta.**

**Mitigazione unica e sufficiente:** tenere sul conto MQL5 **solo il credito che
si e' disposti a perdere**. Non collegare carte a ricarica automatica.

### 6.5 🟠 **Il collo di bottiglia misurato non erano i CORE**

`NOTA_PAVIMENTO_TICK_FOREX_2026-09-01.md`, verbatim:

> "la prima corsa della cella 03 e' stata uccisa da 'no memory for ticks
> generating' (pass falliti, 16 GB RAM saturi con 8 agenti + swap); rimedio:
> **riavvio del PC + 4 agenti**. Dopo il riavvio: **~1 minuto a passata contro
> ~1 ora prima**."

🎯 **Questa e' la riserva piu' importante di tutto il dossier.** Il problema del
01/09 **era la RAM**, ed **e' gia' stato risolto gratis**. Con ~1 min/passata:

- cella 03 = 144 passate = **~36 minuti in locale**. Comprare cloud per 36
  minuti e' comprare aria.
- Il cloud diventa interessante **solo sopra le ~1.000 passate**, o quando le
  passate tornano lente per ragioni **di dati** (finestre piu' lunghe, TF piu'
  bassi, tick reali su periodi post-2024).

⚠️ **E resta il sospetto non chiuso:** l'~1 ora a passata pre-fix era **solo**
swap, o c'e' anche un problema nei **dati** GBPUSD? Se e' nei dati, **il cloud
non lo risolve — lo moltiplica**, perche' ogni agente cloud rifara' la stessa
sincronizzazione lenta (§5.3, Loritsch). **Prima di comprare cloud, va chiusa
quella diagnosi.**

### 6.6 🟠 Serve un account MQL5 loggato nel terminale di BACKTEST

Il che significa: le credenziali MQL5.community di Claudio dentro il terminale
del PC di backtest. **[VERIFICATO]** dalla FAQ (§3.1). Da valutare se usare
l'account principale o **crearne uno dedicato** con il solo credito di prova.

---

## 7. 🧭 IL PIANO DI COLLAUDO — dichiarato PRIMA, per il verificatore

**Nessuno di questi passi e' stato eseguito. Nessuno va eseguito senza la firma
di Claudio.** Ogni passo ha un **cancello**: se non passa, ci si ferma.

### PASSO A — la BASELINE LOCALE (costo: **$0**, ~5 minuti)

> ⚠️ **CORREZIONE ALLA CONSEGNA:** il mandato dice _"confrontare il CSV col
> locale gia' agli atti"_. **Quel CSV NON ESISTE.** Ho cercato in tutto il repo:
> `backtest_pipeline/prove/SONDA_OROLOGIO_00_GEMELLI.txt` e' la **specifica**,
> ma **nessun CSV di risultato della sonda orologio e' mai stato committato**
> (`find` su tutti i `.csv`: zero). **La baseline va CREATA prima**, e' il
> passo A. Senza baseline il confronto cloud/locale **non esiste**.

1. Lanciare **`00_GEMELLI` in LOCALE** con il driver di sempre
   (`walkforward_generico.ps1`, `Modello 4`, EURUSD H1, 2011.01.01→2026.06.30).
2. **Cancello A1 — determinismo LOCALE**: le due righe dei magic gemelli
   `777290`/`777291` devono uscire **identiche al centesimo** in ciascuna
   finestra. Lo dice gia' la specifica: _"Se non lo sono, il banco non e'
   deterministico e NESSUN numero delle altre sei celle si legge."_
   🛑 Se falliscono **si ferma tutto**: senza determinismo locale, il cloud non
   ha nemmeno un metro contro cui essere misurato.
3. **Cancello A2 — cronometro**: annotare i **secondi a passata**. E' il numero
   che trasforma la tabella §5.2 da [STIMA] a stima ancorata.
4. **Leggere il PR** nella scheda **Agenti** del tester e scriverlo agli atti.
5. **Committare il CSV** in `backtest_pipeline/risultati_prove/` — **da qui in
   poi e' "il locale agli atti"**.

### PASSO B — il credito minimo (costo: **il minimo consentito**)

6. Verificare a schermo il **deposito minimo** sul conto MQL5 (**[INCERTO]**: la
   FAQ pagamenti **non lo dichiara** — verbatim controllato, la pagina non ne
   parla). Caricare **quello, e nulla di piu'**. Nessuna ricarica automatica.
7. Loggare l'account MQL5 nel terminale di backtest (§3.1).
8. **Cancello B** — prima di premere Start, il tester deve mostrare gli agenti
   cloud nella scheda **Agenti**. Se non li mostra, il canale non e' aperto e
   **non si prosegue** (vedi il post `forum/341` #108: _"I have the Cloud Network
   ready and money loaded but **no option in the right click to use them?**"_ —
   succede).

### PASSO C — il TEST DI DETERMINISMO (costo [STIMA]: **$0,01 – $0,02**)

9. Rilanciare **la stessa identica cella `00_GEMELLI`**, stesso `.ini`, ma con
   **`UseLocal=0` · `UseRemote=0` · `UseCloud=1`**.
   🔴 **`UseLocal=0` e' obbligatorio**: con `UseLocal=1` le 4 passate se le
   prenderebbero gli agenti locali in pochi secondi e **non avremmo misurato
   niente**.
10. 🔴 **Prima di leggere il CSV, leggere il GIORNALE** e trovare la riga
    `Statistics locals N tasks (x%), remote ... , cloud M tasks (y%)`.
    **Cancello C1: `cloud` deve essere 4 tasks (100%).** Se non lo e', il test
    e' nullo, qualunque cosa dica il CSV.
11. 🔴 **Cercare nel Giornale la riga `ticks data begins from`** e ogni messaggio
    di **degrado del modello** (es. "real ticks not allowed", "generated ticks").
    E' l'unico modo per beccare il degrado silenzioso di §4.
12. **Cancello C2 — IL CANCELLO CHE DECIDE**: il CSV cloud deve essere
    **identico, colonna per colonna, al centesimo**, al CSV locale del passo A.
    - ✅ **identico** → il cloud e' deterministico **su questa configurazione**,
      tick reali compresi. Si passa al passo D.
    - ❌ **diverso** → **STOP DEFINITIVO su `Model=4` in cloud.** Si scrive
      esattamente **quale colonna** diverge (se diverge il profitto ma non i
      conteggi di segnale, e' il degrado tick; se divergono i conteggi, e' altro)
      e si mette agli atti. **Costo di aver scoperto tutto questo: due centesimi.**

### PASSO D — la cella 03 GBPUSD in cloud (costo [STIMA]: **$0,38 – $0,58**)

13. **Solo se C2 e' passato.** Prima del via si scrive agli atti la **stima**:
    `passate × secondi_misurati_al_passo_A × PR_letto × 2,22222E-10 × 3` (il ×3
    e' il peggiore dei casi osservati, §5.3).
14. Rilanciare in cloud la **cella 03 GBPUSD LONG** (72 celle × 2 finestre =
    **144 passate**) e confrontare **anche qui** col locale, che a questo punto
    esiste gia' (la corsa del 01/09).
15. **Cancello D — la resa**: a consuntivo si scrivono tre numeri: **costo
    reale**, **tempo reale**, **rapporto costo-reale / costo-formula**. Se il
    rapporto e' **> 3**, la tabella §5.2 e' **sbagliata** e va rifatta prima di
    qualunque lavoro grosso.

### 📋 Riepilogo del rischio economico del collaudo intero

| | |
|---|---|
| **Costo massimo esposto passi A→C** | **≈ $0,02** [STIMA] |
| **Costo massimo esposto passo D** | **≈ $0,60** [STIMA], ×3 di margine gia' incluso |
| **Cosa si compra** | la risposta **misurata** alla domanda che nessuna documentazione al mondo ci da': **il cloud MQL5 riproduce i nostri tick reali, si' o no?** |

---

## 8. 🔧 IL NOSTRO DRIVER — cosa manca e cosa andrebbe cambiato (**NON cambiato**)

### 8.1 Cio' che ho trovato leggendo `backtest_pipeline/walkforward_generico.ps1`

L'`.ini` viene generato in **due punti** — l'anteprima di `-SoloControllo`
(**righe 505-531**) e quello vero (**righe 636-662**). Sezione `[Tester]` reale,
**righe 641-658**, verbatim dal file:

```
[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$Expert.ex5
Symbol=$Simbolo
Period=$Periodo
Model=$Modello
$RigaSpread
Optimization=1
OptimizationCriterion=6
FromDate=$($w.Da)
ToDate=$($w.A)
ForwardMode=0
Deposit=$Deposito
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=OptReport_$tag
```

### 🔴 **`UseLocal`, `UseRemote` e `UseCloud` NON CI SONO. In nessuno dei due blocchi.**

**Grep di controllo su tutto il file: zero occorrenze delle tre chiavi.**

### 8.2 Cosa succede oggi, di conseguenza [INFERITO, e va confermato a schermo]

Il driver lancia con `/config:` (**riga 669**), il che — come dice il commento
di casa alle righe 627-635 — **avvia il terminale**, che carica il suo ultimo
profilo. Le chiavi assenti **non azzerano** le impostazioni: MT5 **tiene quelle
che ha in memoria dalla GUI**.

> 🎯 **E' esattamente la stessa malattia gia' diagnosticata su `Spread`.** Riga
> 495-497 del nostro stesso driver, verbatim:
> _"(nessuna riga Spread nell'.ini: MT5 usa il valore che ha in memoria. E' il
> comportamento di sempre, ma e' **STATO NASCOSTO**: per metterlo agli atti passa
> -Spread 0.)"_
>
> **Con gli agenti e' identico, ma peggio: qui lo stato nascosto costa SOLDI.**
> Se un giorno qualcuno spunta "MQL5 Cloud Network" nella scheda Agenti per una
> prova e si dimentica di toglierlo, **ogni round successivo lanciato dal driver
> parte in cloud e paga**, in silenzio, senza che l'`.ini` lo dica e senza che
> nessuno lo abbia chiesto.

### 8.3 Che chiavi sono — [VERIFICATO] da due fonti indipendenti

- Articolo ufficiale MQL5 **4917** ("Automated Optimization of an EA for
  MetaTrader 5"): le usa nell'`.ini` che genera, verbatim
  `"UseLocal=1\n", "UseRemote=0\n", "UseCloud=0\n"`, e commenta che si puo'
  _"use some remote or cloud agents"_ regolandole.
- `mql5.com/en/forum/457213`: un utente riporta il modello di `.ini` **copiato
  dalla pagina Help ufficiale** `metatrader5.com/en/terminal/help/start_advanced/start#command_line`,
  che elenca `; *** Login=` / `; *** UseLocal=` / `; *** UseRemote=` /
  `; *** UseCloud=` / `; *** Port=` fra le chiavi della sezione `[Tester]`.
- Semantica: **0 = disabilita, 1 = abilita.**
- ⚠️ Non ho potuto leggere la pagina Help **originale** (`metatrader5.com`
  bloccato dal proxy, §1): le due fonti sopra sono **entrambe su mql5.com** e
  concordano, ma **la conferma sulla pagina ufficiale manca**.

### 8.4 🛠️ **PROPOSTA 1 — la piu' importante, e vale anche se il cloud lo bocciamo**

```
PROPOSTA   Scrivere SEMPRE nell'.ini le tre righe UseLocal / UseRemote / UseCloud,
           con default UseLocal=1, UseRemote=0, UseCloud=0, ed esporle come
           parametro esplicito del driver (es. -Agenti locale|cloud|farm).
DOVE       backtest_pipeline\walkforward_generico.ps1 — DUE punti da toccare
           insieme, righe ~510 (anteprima -SoloControllo) e ~641 (ini vero).
           Toccarne uno solo = l'anteprima mente sull'ini vero.
PERCHE'    Toglie uno STATO NASCOSTO che oggi puo' costare SOLDI VERI a
           insaputa di chi lancia (§8.2). E' la stessa lezione di -Spread 0.
COSTO      ~30 minuti di scrittura + 1 corsa -SoloControllo per rileggere
           l'ini + 1 corsa vera corta per confermare che la riga di GIORNALE
           dica "locals 100%, cloud 0%".
RISCHIO    Basso. Se una chiave fosse scritta male MT5 la ignora (non
           esplode). Il canarino e' la riga Statistics del Giornale.
DECIDE     Claudio.
```

### 8.5 🛠️ **PROPOSTA 2 — solo se il collaudo §7 passa**

```
PROPOSTA   Aggiungere al driver uno switch -Cloud che (a) scrive UseLocal=0
           UseRemote=0 UseCloud=1, (b) STAMPA A SCHERMO la stima di costo
           (passate x secondi_misurati x PR x 2,22222E-10 x 3) e (c) CHIEDE
           CONFERMA prima di aprire MT5.
DOVE       walkforward_generico.ps1, accanto a -SoloControllo.
FONTE      §5.1 (formula ufficiale) + §5.3 (nessuno stop a credito esaurito,
           nessuna stima preventiva nel tester: gliela diamo noi).
COSTO      ~2 ore + 1 collaudo. Serve il PR letto al passo A del §7.
RISCHIO    La stima puo' essere BASSA (osservato fino a 1,9x sopra formula
           anche DOPO il fattore 3? no: 1,9x e' DENTRO il 3x). Va stampata
           come "stima, il conto vero puo' essere piu' alto", mai come prezzo.
DECIDE     Claudio.
```

### 8.6 🛠️ **PROPOSTA 3 — la mezza riga di allineamento alla doc**

```
PROPOSTA   Nelle sonde che scrivono CSV per-passata, portare la guardia da
              !MQLInfoInteger(MQL_OPTIMIZATION)
           alla forma della documentazione MetaQuotes
              !(MQLInfoInteger(MQL_OPTIMIZATION) || MQLInfoInteger(MQL_FORWARD))
DOVE       ABTG_SondaM0PB.mq5 righe 772 e 1362. (ABTG_SondaOrologio NON ha
           scritture nel pass: non va toccata.)
FONTE      docs/runtime/testing, blocco di codice raccomandato (§2.1).
COSTO      5 minuti + ricompilazione. NESSUN effetto oggi (ForwardMode=0
           sempre, riga 651 del driver): e' una cintura per il giorno in cui
           si accendesse il forward MT5.
RISCHIO    Nullo. Ma qualunque tocco a un .mq5 vuole ricompilazione e
           una corsa di controllo: NON si tocca alla vigilia di un round.
DECIDE     Claudio. Priorita' BASSA - e' igiene, non un buco.
```

---

## 9. 📊 TABELLA FINALE — cosa serve al cloud vs cosa abbiamo

| requisito del cloud | fonte | **noi** | esito |
|---|---|---|---|
| niente scritture su disco dentro il pass | doc, §2.1 | `FrameAdd` in `OnTester`, `FileOpen` solo in `OnTesterDeinit` (terminale) | 🟢 **gia' a posto** |
| niente DLL | doc + art. 341 | zero `#import`, `AllowDllImport=false` nell'`.ini` (riga 639) | 🟢 **gia' a posto** |
| niente `iCustom` / file esterni non dichiarati | art. 341 | zero `iCustom`, zero `#property tester_*`; solo `<Trade/Trade.mqh>` standard | 🟢 **gia' a posto** |
| < 4 GB RAM per passata | doc, §2.1 | mai misurato; ~2 GB [INFERITO] dall'OOM del 01/09 | 🟠 **da misurare** |
| niente simboli custom | forum 309741 | sonde su simboli BCM nativi 🟢 · ma `GBPUSD_EXT`/`EURUSD_EXT` 🔴 | 🟠 **dipende dal lavoro** |
| account MQL5 nel terminale | FAQ, §3.1 | da fare | 🟠 **manca** |
| `UseCloud=1` nell'`.ini` | art. 4917 + Help | **assente dal driver** | 🔴 **manca** (Proposta 1) |
| determinismo a tick reali | **nessuna doc** | **ignoto** | 🔴 **da misurare** (passo C) |
| baseline locale per confrontare | — | **nessun CSV della sonda orologio nel repo** | 🔴 **da creare** (passo A) |

---

## 10. 🙋 COSA NON HO POTUTO VEDERE — detto, non riempito

1. **`www.metatrader5.com` e' bloccato dal proxy** (§1): la pagina Help ufficiale
   sul calcolo prezzi e quella sulle chiavi da riga di comando **non le ho
   aperte**. I numeri vengono dal mirror `cloud.mql5.com` (stesso editore) e le
   chiavi da due fonti mql5.com concordi. **Da riverificare prima di spendere.**
2. **Il PR del portatile i7-8550U non e' misurato.** Tutta la §5.2 e' ancorata a
   `PR=100` per [STIMA]. Si legge nel tester, scheda Agenti, e cambia i costi
   proporzionalmente.
3. **La sequenza GUI esatta per attivare il cloud** oggi: l'articolo 341 la
   descrive con una **figura** (2015, build 1075) che non e' testo. **[INCERTO].**
4. **Il deposito MINIMO sul conto MQL5**: la FAQ pagamenti, letta per intero,
   **non lo dichiara**. **[INCERTO].**
5. **Se il tester degradi in silenzio a tick generati sul cloud**: nessuna
   documentazione al mondo lo dice, due moderatori MQL5 si sono contraddetti nel
   2026, e l'unica prova esistente e' un utente che dice _"I tried a small real
   ticks optimization with the Cloud, and it worked"_. **[INCERTO] — ed e' la
   ragione per cui il passo C del collaudo esiste.**
6. **Il PR degli agenti cloud che ci servirebbero** non e' visibile prima del
   lancio: `forum/473375` chiede proprio questo e **non ha ricevuto risposta**.
7. **Se l'~1 ora a passata pre-fix del 01/09 fosse SOLO swap o anche un problema
   nei DATI GBPUSD**: quella diagnosi e' in corso e **non e' mia**. Se e' nei
   dati, il cloud **peggiora** le cose (§6.5).

---

## 11. ✍️ SE CLAUDIO VUOLE UNA SOLA RIGA DA FIRMARE

> **Firmare il PASSO A (baseline locale della `00_GEMELLI`, costo $0) e la
> PROPOSTA 1 (le tre righe `Use*` nell'`.ini`).**
> Sono le due cose che valgono **anche se il cloud lo bocciamo domani**: la
> prima e' il collaudo di determinismo che la sonda dell'orologio **deve fare
> comunque prima di essere letta**, la seconda chiude un buco che oggi puo'
> far spendere soldi da solo.
> Il cloud vero (passi B-C-D, esposizione totale **< $0,60** [STIMA]) si decide
> **dopo**, con la baseline in mano e il PR letto.

---

## 📎 FONTI (tutte aperte davvero, tutte il 02/09/2026)

| # | URL | esito |
|---|---|---|
| 1 | https://www.mql5.com/en/docs/runtime/testing | 200 |
| 2 | https://cloud.mql5.com/en/faq/payments | 200 |
| 3 | https://cloud.mql5.com/en/faq/settings | 200 |
| 4 | https://cloud.mql5.com/en | 200 — "Agents Online 64 027" |
| 5 | https://cloud.mql5.com/en/faq/general | **404** |
| 6 | https://www.mql5.com/en/articles/341 | 200 |
| 7 | https://www.mql5.com/en/articles/669 | 200 — **aperto, NESSUNA affermazione di questo dossier ne dipende**: e' un articolo promozionale del 2013 ("It will soon be a year and a half since the MQL5 Cloud Network has been launched"), senza numeri utilizzabili oggi |
| 8 | https://www.mql5.com/en/articles/4917 | 200 |
| 9 | https://www.mql5.com/en/forum/311979 | 200 — "real ticks optimization not allowed in Cloud Network" |
| 10 | https://www.mql5.com/en/forum/508137 | 200 — divergenza cloud/locale, aprile 2026 |
| 11 | https://www.mql5.com/en/forum/460345 | 200 — 10.000 passate = $9,60 |
| 12 | https://www.mql5.com/en/forum/467593 | 200 — fattore 2-3× e "data-hungry" |
| 13 | https://www.mql5.com/en/forum/473375 | 200 — nessuno stop a credito zero |
| 14 | https://www.mql5.com/en/forum/457213 | 200 — chiavi `.ini` dall'Help |
| 15 | https://www.mql5.com/en/forum/309741 | citato via ricerca — "custom symbols not allowed in Cloud Network" |
| — | https://www.metatrader5.com/... | 🛑 **EGRESS_BLOCKED — fonte nulla** |

**Fonti interne al repo, lette per intero:**
`mql5/Experts/ABTG_SondaOrologio.mq5` · `mql5/Experts/ABTG_SondaM0PB.mq5` ·
`backtest_pipeline/walkforward_generico.ps1` ·
`backtest_pipeline/prove/SONDA_OROLOGIO_00_GEMELLI.txt` ·
`backtest_pipeline/prove/SONDA_OROLOGIO_03_GBPUSD_LONG.txt` ·
`backtest_pipeline/risultati_archivio/NOTA_PAVIMENTO_TICK_FOREX_2026-09-01.md` (commit `3f892ac`)
