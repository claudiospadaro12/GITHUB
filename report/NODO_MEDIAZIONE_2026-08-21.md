# 🪢 IL NODO DELLA MEDIAZIONE — scheda di riconciliazione, 21/08/2026

> ⚖️ **Cos'e' questo file.** Sul nome "Mediazione" ci sono **due verdetti
> opposti agli atti**, a sei giorni di distanza, **nessuno dei due firmato da
> Claudio**. Questa scheda **non decide**: mette i due verdetti uno accanto
> all'altro con la citazione esatta, dichiara **su cosa** verte ciascuno,
> misura quanto sono avanzate le sei condizioni gia' poste, e chiude con le
> **opzioni fra cui Claudio deve scegliere** — scritte in modo che si possa
> firmare con **una parola**.
>
> 🔒 **Nessuna modifica al forward. Nessun round aperto. Nessun EA scritto.**
> Prodotto dall'**architetto-prop**. Nato dalla decisione di Claudio del
> 21/08 in chat: **"1,2,3 si guardano"** — il punto 2 era la Mediazione.
>
> 📎 **Documento gemello, consegnato oggi:** la voce **§13 GRIGLIA /
> MARTINGALA** di `report/METRO_PROP.md` (bozza M14, da firmare). Li' c'e' il
> **metro**; qui c'e' il **nodo**. Il metro si firma da solo, anche se il nodo
> si chiude con "archivia".

---

## 1. 📜 I DUE VERDETTI, UNO ACCANTO ALL'ALTRO

| | **VERDETTO A — 12/08/2026** | **VERDETTO B — 18/08/2026** |
|---|---|---|
| **dove** | `report/DIARIO.md:88` (riga di diario della sera) · originale in `docs/live_emiliano/CATALOGO_STRATEGIE_CORSO.md:18-22` | `backtest_pipeline/caccia_strategie/ANALISI_CORSO_MEDIAZIONE_2026-08-18.md:378-381` (§1.13) |
| **citazione esatta** | _"🚩🚩 «Mediazione»: **mai insegnata col suo nome** ma praticata da Emiliano come coperture/martingala (conto 10k bruciato a luglio, sessione 03/08 da +1.200 a −800): **verdetto scolpito, NON si meccanizza, MAI in prop.**"_ | _"✅ **SI', PUO' ANDARE ALL'IMBUTO** — e per una volta il motivo e' tecnico, non di fiducia: e' la prima strategia di questo corso che possiamo implementare **AL 100% NELLA SUA MATEMATICA** senza chiedere niente a nessuno."_ |
| **chi lo ha scritto** | l'agente del censimento live (catalogo strategie del corso) | l'agente analista delle trascrizioni del modulo |
| **su quale materiale** | **21 live di Emiliano** (aprile-luglio) + la sessione del 03/08 | **8 trascrizioni, lezioni 26-33**, 58.689 caratteri, lette per intero |
| **relatore del materiale** | **Emiliano** (e nessuna lezione: la pratica vista in diretta) | **Manuela Negro** (`[T]` confermata testualmente in lez. 33) |
| **firma di Claudio** | ❌ **nessuna** | ❌ **nessuna** |
| **condizioni allegate** | nessuna: e' un divieto secco | **6 condizioni non negoziabili** (§3 qui sotto) |

> 🔴 **E la cosa che li rende inconciliabili a prima vista:** il verdetto B
> **legge la bandiera martingala e la supera**, il verdetto A **la applica a
> vista**. Le due citazioni, affiancate:
>
> - **B, il setaccio** (`:245-252`): _"la mediazione **inciampa nella bandiera
>   n.1** ... **ma supera tutte le sotto-bandiere che normalmente rendono una
>   griglia letale**: stop vero, cap, perdita massima nota. **E' il caso raro in
>   cui la bandiera va letta, non applicata a vista.**"_
> - **A, la nota d'origine** (`docs/live_emiliano/LIVE_03-08_REGOLE_ESTRATTE.md:95`):
>   _"quella mattina lui operava con **martingala e coperture su un conto da
>   3.000 €**. E' una modalita' che nessuno dei nostri EA implementa e che **non
>   intendo trasformare in codice**: moltiplica il rischio proprio quando si sta
>   sbagliando, ed e' **incompatibile con qualsiasi regola prop (−5%
>   giornaliero)**."_

---

## 2. 🔍 SU COSA VERTE CIASCUNO — sono la stessa cosa o due cose col medesimo nome?

**Verificato riga per riga, non dato per buono.** Ecco i fatti che ho controllato
io, con la fonte:

| controllo | esito | prova |
|---|---|---|
| Il verdetto A parla di una **lezione** del corso? | ❌ **NO, e lo dice da solo** | `CATALOGO_STRATEGIE_CORSO.md:18` — _"**MAI insegnata col suo nome**, ma PRATICATA da Emiliano"_ |
| Il materiale del modulo (lez. 26-33) **esisteva** nel repo il 12/08? | ❌ **NO** | le 8 trascrizioni sono arrivate il **18/08** (`trascrizioni_corso_2026-08-18/modulo_mediazione/`): **sei giorni dopo**. Il verdetto A non poteva riferirsi a un testo che nessuno aveva |
| Stesso relatore? | ❌ **NO** | A = **Emiliano** (live) · B = **Manuela Negro** (lezioni 26-33) |
| Stesso meccanismo? | ❌ **NO** — e si vede coi test del metro | tabella qui sotto |
| Stessa famiglia di rischio? | ✅ **SI'** | entrambe sono "aggiungo contro il movimento". **E' questo che tiene in piedi la preoccupazione di A anche su B** |

### 🔬 I due oggetti passati ai test del `METRO_PROP` §13.1 (scritti oggi)

| test | **A — la pratica di Emiliano** | **B — il modulo del corso (lez. 26-33)** |
|---|---|---|
| **T1** stop hard depositato al broker | ❌ **NO** — _"la perdita non la incasso, **la congelo**"_ (live 19.04, citata nel catalogo): congelare una perdita e' l'opposto di depositare uno stop | ✅ **SI'** — SL unico **scritto su ogni singolo ticket**, `[T]` lez. 30 ripetuto sei volte |
| **T2** cap costante di ingressi | ❓ mai dichiarato in nessuna live | ✅ **6**, dichiarato in **tre** lezioni |
| **T3** perdita massima nota prima | ❌ **NO** (senza stop non esiste il numero) | ✅ **SI'**, la calcola il corso stesso (1,76% nell'esempio GBPUSD) |
| **T4** si riarma sulle perdite precedenti | 🚩 **coperture / prezzo medio / anti-martingala** = si' | ✅ **NO** — ogni pacchetto e' **chiuso in se'** |
| **T5** size crescente verso lo stop | ❓ non misurabile | 🚩 **si', ×1,5**: 7,59× fra ultimo e primo ticket, 20,78× totale (**da dichiarare sempre**) |
| **esito col metro di oggi** | 🔴 **SCARTO A VISTA** (fallisce T1 e T3, e T4 e' si') | 🟡 **MISURABILE**, alle condizioni G1-G6 |

> ### 🧭 LA LETTURA CHE PROPONGO (e' una lettura, non una decisione)
>
> **Sono DUE OGGETTI DIVERSI CON LO STESSO NOME.** Il verdetto A e' esatto **sul
> suo oggetto**: una pratica senza stop, con coperture, su un conto piccolo, che
> il 03/08 e' passata da +1.200 a −800 sotto gli occhi di tutti. Col metro
> scritto oggi **quella cosa li' e' scarto a vista**, e non serve nemmeno
> misurarla.
>
> ⚖️ **MA — e qui non faccio sconti — il verdetto A non si "annulla": la sua
> RAGIONE sopravvive e diventa un cancello sul nuovo oggetto.** La frase
> _"incompatibile con qualsiasi regola prop (−5% giornaliero)"_ e' **vera anche
> sul modulo**, se il sizing resta quello del corso: al fattore 2,29 **un solo
> pacchetto pieno vale 4,03% = l'81% del muro giornaliero**, e i **due pacchetti
> simultanei che il corso stesso mostra** valgono **6,32% = oltre il muro, in un
> solo evento** (`METRO_PROP` §13.3-13.6). **Il "MAI in prop" del 12/08 e' una
> profezia corretta sul sizing del corso.** Cade **solo** se il sizing viene
> dichiarato NOSTRO (0,65% per **pacchetto**, regola A1 congelata).
>
> 📌 **Una precisione onesta che nessuno aveva fatto:** il "conto 10k bruciato a
> luglio" citato nel verdetto A **non e' attribuito alla mediazione** dalla sua
> stessa fonte — `docs/live_emiliano/ANALISI_LIVE_luglio.md:41` dice
> _"ha bruciato un conto da 10k lunedi' **sull'oro (discrezionale)**"_. Il
> catalogo li ha uniti in una riga sola. **L'episodio che regge davvero il
> verdetto A e' il 03/08** (+1.200 → −800, 3.000 €, martingala e coperture), che
> e' documentato per intero.

---

## 3. ✅❌ LE SEI CONDIZIONI DEL 18/08 — a che punto sono, una per una

Fonte: `ANALISI_CORSO_MEDIAZIONE_2026-08-18.md:384-394`. Stato aggiornato al
**21/08/2026**.

| # | condizione | stato oggi | cosa la chiude, e chi |
|---|---|---|---|
| **1** | 🔴 **Sciogliere il fattore 2,29** sul sizing (1,76% dichiarato ↔ 4,03% ricostruito) | ❌ **NON RISOLTA** — ed e' la piu' pesante: al 4,03% **un pacchetto solo sfonda il cap C1 = 3,25% congelato** (124% del budget di rischio aperto di tutte e 44 le sedie) | **Due strade, e la scelta e' di Claudio.** (a) il **file Excel** della lez. 27 (_"dovreste avere nella vostra area personale questo file"_) → richiesta a **Claudio**; (b) **dichiarare il sizing NOSTRO**: perdita massima **per pacchetto** = **0,65%** (A1, congelata), e il seme del corso si butta. 🟢 **(b) costa zero e chiude anche il problema prop** |
| **2** | 🔴 **Parametri SuperTrend dichiarati come ASSUNZIONE NOSTRA** | 🟡 **RISOLTA COME PROCEDURA, non come dato** — il precedente esiste gia': R82 ha girato l'implementazione fedele del Breakout con i default dichiarati (`REFERTO_ROUND82_TORNEO_JPY.md`, _"SuperTrend default come da lez. 10 del modulo base"_). **Ma i valori veri restano il buco M15b**: il `super trend.ex4` allegato alla lez. 10 non e' mai arrivato | resta com'e': **si dichiarano nel referto, non si nascondono**. Il file → **Claudio** (M15b, gia' chiesta) |
| **3** | 🔴🔴 **L'unita' di conto e' il PACCHETTO, non il ticket** | 🟢 **RISOLTA COME REGOLA OGGI** — `METRO_PROP` §13.2 (regola G2, con l'esempio numerico: 100 pacchetti letti a ticket diventano **390** e il win rate cala da **70% a 53,8%**). ❌ **NON risolta come strumento**: `ExportTrades()` non esporta `open_time` ne' un `package_id` (ricostruibile per cluster di `close_time`, ma va scritto nei criteri **prima** del round) | firma del metro → **Claudio** · i due campi → **mql5-ea-developer** |
| **4** | 🔴 **Le 3 coppie sono un TRIANGOLO CHIUSO** (`EURGBP = EURUSD/GBPUSD`), non 3 conferme | 🟡 **RICONOSCIUTA, non ancora una regola scritta** — esiste il precedente perfetto: la regola di portafoglio **"max UNA sedia dalla famiglia JPY"** (firmata, R82). Qui servirebbe la gemella: **i pacchetti aperti sul triangolo EUR/GBP/USD contano come UNA scommessa per il cap C1** | 📋 **proposta** — la firma e' di **Claudio**, e ha senso firmarla **solo se** il nodo va avanti (opzioni B/C) |
| **5** | 🟠 **Il setaccio deve leggere la CODA**, non solo PF e max DD | 🟢 **RISOLTA COME METRO OGGI** — `METRO_PROP` §13.3: sei misure obbligatorie (istogramma dei livelli riempiti, peggior pacchetto vs teorico, p95/p99 per pacchetto, perdenti consecutivi **contati per pacchetto**, indice di coda, ramo "pieno poi TP"). ❌ **Nessun dato**: non esiste un backtest | il metro → firma di **Claudio** · i numeri → un round, che oggi non esiste |
| **6** | 🟠 **Misurare PRIMA la frequenza** (Williams 140 su H1 = ~6 giorni di look-back: i segnali potrebbero essere pochissimi) | ❌ **NON RISOLTA, e nessuno l'ha mai tentata** — e' il **prerequisito di tutto**: sotto **150 pacchetti in IS** il giudizio di MERITO e' sospeso per regola di casa (Emendamento A) | 🔴 **Serve del codice**: non un EA completo, ma un **contatore di segnali** (Williams 140 + SuperTrend sui 3 cross, H1). → **mql5-ea-developer**, se Claudio apre la strada |

### 📊 Il conto: **2 risolte su 6** (e sono le due che ho potuto chiudere io oggi, perche' erano regole da scrivere, non numeri da misurare)

- 🟢 **risolte:** 3 (unita' pacchetto) e 5 (coda) — **entrambe come metro, entrambe da firmare**
- 🟡 **mezze:** 2 (procedura si', valori no) e 4 (riconosciuta, regola da firmare)
- ❌ **aperte e bloccanti:** **1** (fattore 2,29) e **6** (frequenza mai misurata)

> 🎯 **E l'ordine conta:** la **6** viene **prima** di tutto — se la frequenza non
> arriva a 150 pacchetti, **il resto del lavoro non produce un giudizio**, e
> avremmo scritto un EA per niente. La **1** viene subito dopo, e si chiude con
> una frase di Claudio ("il sizing e' nostro"), non con una misura.

---

## 4. 🕳️ COSA MANCA PER DECIDERE (e chi lo porta) — niente di questo lo faccio io

| # | buco | chi | domanda esatta |
|---|---|---|---|
| N1 | **Il file Excel della lez. 27** (area personale del corso) — l'unico oggetto che scioglie il fattore 2,29 dall'interno | **Claudio** | _"scaricare il file dall'area personale e mandarlo: servono le celle del volume, non i livelli (quelli sono gia' ricostruiti)"_ |
| N2 | **`super trend.ex4` della lez. 10** (M15b, gia' chiesta il 18/08) | **Claudio** | _"i default di QUEL file sono i parametri che il corso non detta mai"_ |
| N3 | **Le pagine ufficiali "prohibited practices"** di FTMO/FundedNext/The5ers/FundingPips/E8/Alpha, sul **testo letterale** di grid/martingale/averaging/position sizing non uniforme | **cacciatore-config-prop** (si aggancia a M4) | testo esatto in `METRO_PROP` §13.5. Oggi l'unica riga "grid vietato" e' un **video con link affiliati** (rango 4°), e su FTMO il divieto testuale **non esiste** ma esiste una clausola discrezionale sulle size non uniformi |
| N4 | **Il contatore di segnali** (frequenza, condizione 6) | **mql5-ea-developer** — solo se Claudio apre | _"quanti segnali validi fanno Williams 140 + SuperTrend su H1, su EURUSD/GBPUSD/EURGBP, negli ultimi N anni? Conta SEGNALI (= pacchetti), non ticket"_ |
| N5 | **I tre buchi dell'impianto** per misurare il flottante contro il muro giornaliero (`METRO_PROP` §13.4): export per-giorno dell'equity con `InpPropResetHour`, `open_time`+`package_id`, cap C1 cieco sugli **ordini pendenti** | **mql5-ea-developer** | idem — **valgono per QUALUNQUE griglia**, non solo per questa: se un giorno si valuta un EA comprato, servono lo stesso |

---

## 5. ✍️ LE OPZIONI — Claudio sceglie con UNA PAROLA

> ⚠️ Prima di tutte, una firma che **e' indipendente dal nodo** e che consiglio
> comunque:

### 🔵 FIRMA 0 — "**METRO**" (indipendente da A/B/C)

Congelare la voce **§13 GRIGLIA / MARTINGALA** di `report/METRO_PROP.md`.
**Costo: zero.** Non apre niente, non impegna niente. Serve **ogni volta** che
compare una griglia: un EA comprato, un preset di un vendor, un'idea del corso.
Oggi quel metro **non c'e'**, e la regola di casa dice che si scrive **prima**
dei numeri — che e' esattamente la condizione in cui siamo (zero numeri).
👉 _Se il nodo si chiude con "ARCHIVIA", questa firma resta valida lo stesso._

---

### 🅰️ OPZIONE A — "**ARCHIVIA**"

**Resta il MAI del 12/08.** La Mediazione esce dai candidati, non si scrive
nessun EA, la scheda 1 di `STATO_QUATTRO_STRATEGIE` si chiude, M14 resta chiusa
dal metro (che vale per il futuro).

- ✅ **costo zero, rischio zero.** Nessuna riga di codice, nessuna ora.
- ✅ e' coerente col fatto che **oggi non abbiamo un motore che passerebbe una
  prop** (M5): il tempo si spende sui round in corso.
- ❌ si archivia **senza aver misurato niente** l'unica strategia del corso
  implementabile **al 100% nella sua matematica** (21 valori su 21 verificati).
- ❌ e si archivia con un'**asimmetria**: al Breakout del corso abbiamo dato un
  torneo intero su 7 cross (R82) **prima** di bocciarlo. Qui si boccerebbe senza
  un solo numero.

### 🅱️ OPZIONE B — "**IMBUTO**"

**Vale il verdetto tecnico del 18/08.** Si firma il metro (FIRMA 0), si dichiara
il sizing NOSTRO (condizione 1, strada b), si firma la regola del triangolo
(condizione 4), si scrive l'EA fedele e **poi** si apre il round con criteri
congelati prima.

- ✅ e' la strada completa, e ha gia' tutte le condizioni scritte.
- ❌ **e' la piu' cara**, ed e' cara **nell'ordine sbagliato**: si scrive l'EA
  **prima** di sapere se i segnali sono 300 o 30. Se sono 30, l'EA e' scritto per
  un giudizio che **non si potra' dare** (Emendamento A: sotto 150 pacchetti il
  merito e' sospeso).
- ❌ apre un round mentre N3 (cosa vietano davvero le prop) e' **non verificato**.

### 🅲 OPZIONE C — "**FREQUENZA**" _(la piu' economica delle due che vanno avanti)_

**Prima il numero che decide, poi si decide.** Si firma il metro (FIRMA 0) e si
autorizza **solo** la condizione 6: un **contatore di segnali** (non un EA
operativo — nessun ordine, nessun sizing, nessun forward) che dice quanti
pacchetti validi fanno Williams 140 + SuperTrend su H1 sui 3 cross. **Poi** si
torna qui con un numero e si sceglie fra A e B **sui fatti**.

- ✅ **e' l'ordine che l'analisi del 18/08 chiedeva**: _"la misura di frequenza
  si fa **prima** di lanciare la griglia di ottimizzazione, non dopo"_.
- ✅ **e' un cancello vero, non un rinvio**: se i pacchetti sono meno di 150 in
  IS, il nodo si chiude da solo — con un numero, non con un'opinione.
- ✅ non serve sciogliere il fattore 2,29 per contare i segnali (il sizing non
  entra nel conteggio): **le due cose bloccanti si affrontano una alla volta**.
- ❌ costa comunque del lavoro a **mql5-ea-developer**, e non produce ancora
  nessun giudizio di merito.

---

## 🧭 LA MIA RACCOMANDAZIONE — **e' una raccomandazione, non una decisione**

> ### 👉 **FIRMA 0 ("METRO") + OPZIONE C ("FREQUENZA")**

**Tre motivi, tutti verificabili qui dentro:**

1. 🔵 **Il metro si firma comunque**, perche' non dipende da questo nodo: e' lo
   strumento che ci mancava per **qualunque** griglia, e oggi lo scriviamo nella
   condizione ideale — **zero numeri sul tavolo che possano influenzarlo**. E'
   letteralmente la regola di casa ("i criteri si cambiano prima dei numeri").
2. 📏 **La frequenza e' il cancello piu' economico e piu' decisivo che abbiamo.**
   Un contatore di segnali costa una frazione di un EA e puo' **chiudere il nodo
   da solo**. Andare all'IMBUTO (B) senza quel numero significa rischiare di
   scrivere un EA per un verdetto che non potra' esistere; archiviare (A) senza
   quel numero significa bocciare l'unica strategia del corso **aritmeticamente
   chiusa** senza aver misurato nulla — e dopo averne misurata un'altra (il
   Breakout) su 7 cross e 2.138 operazioni per finestra.
3. ⚖️ **Perche' non consiglio A anche se A e' comoda:** il verdetto del 12/08 non
   e' sbagliato, e' **su un altro oggetto** (§2), e la sua ragione vera — _"−5%
   giornaliero"_ — **e' un problema di TAGLIA, non di meccanismo**: al sizing del
   corso e' letale (4,03%/pacchetto, 81% del muro giornaliero), alla nostra
   taglia congelata (0,65%/pacchetto) servono **15 pacchetti pieni consecutivi**
   per uccidere il conto. **Archiviare oggi vorrebbe dire chiudere una porta per
   un numero che non e' nostro.**

> 🛑 **E cosa NON sto raccomandando, per chiarezza:** non sto proponendo di
> aprire un round, di scrivere un EA operativo, di toccare il forward, ne' di
> comprare niente. **L'opzione C autorizza un contatore, e nient'altro.**
> E qualunque cosa scelga Claudio, **finche' N3 non ha risposta** (cosa vietano
> le prop **per iscritto**) nessuna griglia va su un conto pagato: vale la
> regola D3.

---

## 📌 DOVE FINISCE QUESTA SCHEDA

- se la scelta e' **A** → `report/STATO_QUATTRO_STRATEGIE_2026-08-21.md` scheda 1
  si chiude, M14 resta chiusa dal metro, e questa scheda diventa il verbale.
- se la scelta e' **B** o **C** → M14 di `report/PIANO_PROP.md` si aggiorna con lo
  stato della bozza, e nasce la riga di richiesta per **mql5-ea-developer** (N4).
- in **ogni** caso: la parola di Claudio va **trascritta qui sotto, testuale**,
  con la data — come nel verbale `report/FIRME_2026-08-18.md`.

| data | parola esatta di Claudio | cosa attiva |
|---|---|---|
| _(in attesa)_ | | |


---

# ✍️ FIRMA — **OPZIONE C: "FREQUENZA"** (21/08/2026)

> **"metro,frequenza, firmo r93, r94 lancia, e prepara jpy"**
> — Claudio, 21/08/2026, in chat.

La parola **"frequenza"** sceglie l'**opzione C**: si costruisce **solo un contatore
di segnali**. Niente ordini, niente sizing, niente forward, nessun EA operativo.

**La domanda, sola:** *la Mediazione del corso produce almeno 150 PACCHETTI in-sample?*

Dichiarazione di cecita': al momento della firma **nessun numero di questi round
e' stato prodotto, letto o guardato**. Nessuno dei due EA nuovi e' mai stato
compilato. Le soglie NON sono state toccate dalla firma.


## Cosa vale questa firma
- Si conta il **PACCHETTO**, mai il ticket (§13 G2 del METRO_PROP, congelato oggi):
  contare i ticket gonfierebbe il campione fino a **x3,9** e farebbe passare il muro
  dei 150 a un motore che non lo merita.
- **Se sotto i 150 pacchetti IS: il nodo si chiude da solo, con un numero.** Non
  serve scrivere nessun EA e non serve nessun'altra decisione.
- **Se sopra: il nodo NON e' sciolto** — restano da risolvere il fattore 2,29 e il
  cancello di taglia (un pacchetto = 4,03% = **81% del muro giornaliero**; due
  pacchetti simultanei = **6,32% = oltre il muro in un solo evento**).

## Cosa questa firma NON dice
- **Non** riabilita la pratica di Emiliano: quella fallisce T1 e T3 con T4 = si',
  ed e' **scarto a vista** per §13. Il "MAI" del 12/08 **resta in vigore su quella**.
- **Non** promuove niente e **non** apre un round di merito.
