# 🏗️ PROPOSTA — ESTENDERE IL GUARDIAN PER COPRIRE GAP TRADING (X16) E CONCENTRAZIONE (X15)

**Data:** 28/08/2026 · **Stato:** PROPOSTA SU CARTA. ⚠️ **ZERO righe di codice
scritte o modificate.** Nessun `.mq5`, nessun `.mqh`, nessun `.set`, nessun
preset toccato. Questo file è un progetto da firmare, non un intervento.

**Origine:** il censimento del 28/08
(`CENSIMENTO_GAP_TRADING_FLOTTA_2026-08-28.md`) chiude con una riga di
direzione — _"il posto naturale non è dentro 22 EA diversi: è
`ABTG_Guardian`"_ — e la dichiara **fuori scope, da proporre a parte**.
Questo documento è quel "a parte".

**Cosa copre:** i due buchi FTMO ancora scoperti.

| clausola | testo | stato flotta oggi |
|---|---|---|
| **X16 (i)** gap trading / news | aprire trade _"when major global news… are scheduled"_ | **0/38 sedie** con filtro news attivo, CSV a 0 byte |
| **X16 (ii)** gap trading / pre-chiusura | aprire trade _"two hours or less before a relevant financial market is closed for at least two hours"_ | **30/38 sedie nude**, 3 parziali, 5 coperte per caso |
| **X15** concentrazione | vietata concentrazione su un simbolo o su **simboli correlati** | cap C1 copre solo il **totale**, niente per simbolo/gruppo |

---

# 🖊️ PARTE 0 — LE DECISIONI CHE SPETTANO SOLO A CLAUDIO

Nessuna di queste è una scelta tecnica: sono scelte di rischio, di soldi o di
interpretazione di un regolamento. **Il codice non parte finché non sono
firmate**, perché ognuna cambia il disegno, non solo un default.

### 🔴 D1 — Si accende il cancello, o si spegne la sedia?
Il cutoff pre-chiusura **non è gratis**: su `ABTG_SupRev_DAX_H4_Ottimizzato`
(970912) le barre H4 chiudono alle 20:00 server e la finestra vietata sul DAX è
**20:00-22:00 TUTTI i giorni**. Tradotto: il cancello potrebbe **cancellare la
maggioranza degli ingressi di quella sedia**, cioè spegnerla di fatto senza
dirlo. Prima di firmare l'accensione serve la misura (fase OSSERVA, §4). Se il
verdetto è "questa sedia su FTMO non esiste", è una decisione di portafoglio, non
un input.

### 🔴 D2 — Quanto margine di sicurezza sopra le 2 ore?
FTMO dice "2 ore o meno prima". Bloccare a T-2h00m esatte significa affidare la
conformità alla precisione dell'orologio del broker e delle specifiche di
simbolo. Proposta di lavoro: **T-2h15m** (15 minuti di margine).
Alternative: 30 min (più prudente, taglia più trade), 0 min (aderente alla
lettera, nessun cuscinetto). **Firma Claudio.**

### 🔴 D3 — Il blocco finisce alla chiusura, o continua fino alla riapertura?
La lettera della regola vieta di aprire **prima** della chiusura. Non dice nulla
sulla **riapertura** — ed è esattamente la zona grigia della famiglia
`ABTG_GapFill` (5 sedie), che il censimento e il dossier FTMO lasciano aperta e
che la mail del 28/08 **non ha chiuso**. Tre opzioni:
- **(a)** blocco solo T-2h → chiusura. GapFill continua a operare come oggi.
- **(b)** blocco T-2h → chiusura **+ N minuti dopo la riapertura**. GapFill viene
  spenta di fatto (apre sulla prima barra della settimana).
- **(c)** blocco come (a), e la famiglia GapFill **non viene caricata su FTMO**
  (è già la raccomandazione scritta nel dossier di casa, §(a) punto 1).
**Firma Claudio.** La mia lettura: (c) è la più onesta finché non c'è risposta
scritta — non si mette in codice l'interpretazione di una regola ambigua.

### 🔴 D4 — Il cap di concentrazione: per SIMBOLO, per GRUPPO, o entrambi?
E con quali numeri. I dati misurati (§3.1): **8 sedie su U30USD**, **9 sedie sul
gruppo indici USA**, **6 su GBPUSD**, **5 su XAUUSD**. A 0,65% di rischio l'una,
U30USD da solo può arrivare a **5,2% su un simbolo** — sopra il cap C1
dell'INTERO conto (3,25%). Un cap per simbolo mordente (es. 1,30% = 2 sedie)
cambia il funzionamento quotidiano della flotta, non è un ritocco. Ricordo il
precedente misurato: `ANALISI_CAP_C1_FINTOKEI_2026-08-27.md` mostra che il cap
totale a 3,25% **già interviene 10 giorni su 24 (42%)**.

### 🟠 D5 — La tassonomia dei gruppi correlati la firma chi?
Proposta al §3.2, costruita sui 15 simboli che operiamo davvero. Ma "correlati"
è una parola che FTMO non definisce con una soglia. Serve una scelta dichiarata:
gruppi **fissi da tabella** (semplice, opinabile) oppure **esposizione per
VALUTA** letta dal broker (più corretta, più costosa, §3.3).

### 🟠 D6 — Il filtro news: calendario MT5 o CSV?
Il CSV oggi è rotto in tre punti (vuoto, silenzioso, letto una volta sola).
L'alternativa è l'**API calendario di MT5** (`CalendarValueHistory`), che nel
repo è già usata **una volta**, in `DAX_MASTER_PROP.mq5:1686`, con il pattern
giusto (errore API → blocco conservativo in live). Elimina scheduler, file, fuso
orario e download. Costo: dipende dal broker fornire il calendario — **da
misurare prima** (§0-bis). **Firma Claudio** su quale strada si prende.

### 🟠 D7 — News: fail-open o fail-closed?
Se il calendario non è disponibile, il gate news **non blocca niente** (fail-open,
come tutto il resto del Guardian) oppure **blocca tutto** (fail-closed, come fa
`DAX_MASTER_PROP` in live)? Fail-closed protegge dalla violazione ma può fermare
la flotta un giorno intero per un problema di dati. Proposta: fail-open sul
blocco, **ma con allarme rumoroso** nel giornale e nella pagella serale — perché
il difetto misurato al §3.2 del censimento è proprio il **fallimento silenzioso**.
**Firma Claudio.**

### 🟠 D8 — Quanto largo il blackout news?
La regola X16(i) dice "when scheduled", senza finestra. Le regole news vere
(±2 min) valgono solo su funded Standard, e su Swing non valgono affatto.
Proposta di lavoro: 15 min prima / 15 min dopo, impatto alto (3) soltanto.
Ma è un numero pescato, non misurato. **Firma Claudio.**

### 🟠 D9 — Si tocca `pretendi_guardian`?
Oggi vale `false` in tutte le ~97 chiamate: **Guardian morto = flotta libera**.
Per B1/C1 è la scelta giusta (un cane da guardia morto non ferma la flotta per
sempre). Per una regola di **conformità** è diverso: Guardian morto durante la
finestra vietata = violazione. La mitigazione proposta (§1.4, il blocco porta con
sé la propria scadenza) copre il caso senza toccare nessun EA. Se non basta,
l'alternativa è accendere `pretendi_guardian` sul conto FTMO — e quella tocca
tutti i punti di chiamata. **Firma Claudio.**

### 🟢 D10 — L'ordine dei lavori
Proposta motivata: **Fase 0 (sonda) → A (cutoff) → C (concentrazione) → B (news)**.
Perché A per primo: è la clausola che FTMO ha confermato **per iscritto** valere
anche in Evaluation, ed è quella con 30 sedie nude. Perché C prima di B: C si
calcola con dati che **abbiamo già** (le posizioni aperte), B dipende da una
fonte esterna oggi rotta e non verificata.

---

# 🔬 FASE 0 — LA SONDA (da fare PRIMA di scrivere una riga di logica)

Tutti e tre i pezzi poggiano su dati del broker che **nessun EA della flotta ha
mai letto**. Il censimento lo dice esplicito: `SymbolInfoSessionTrade` /
`SymbolInfoSessionQuote` **non compaiono in nessun file** del repo. Progettare
sopra un dato mai visto è come tarare su un backtest mai girato.

**Cosa fa la sonda:** uno **script MQL5 di sola lettura** (`ABTG_SondaMercati.mq5`,
~90 righe), che gira una volta su BCM e una volta su FTMO in demo, e scrive nel
giornale, per ognuno dei 15 simboli operati:

| dato letto | API | serve a |
|---|---|---|
| sessioni di trading dei 7 giorni | `SymbolInfoSessionTrade` | pezzo **A**: esistono davvero? il DAX dichiara la pausa da 3h? |
| valuta base / profitto | `SYMBOL_CURRENCY_BASE` / `_PROFIT` | pezzo **C**: decomposizione in valute senza tabelle cablate |
| percorso e categoria | `SYMBOL_PATH`, `SYMBOL_SECTOR_NAME` | pezzo **C**: distinguere indici da forex senza cablare |
| eventi calendario prossimi 7 gg | `CalendarValueHistory` | pezzo **B**: il broker fornisce il calendario? |
| fuso server e offset | `TimeCurrent()` vs `TimeGMT()` | tutti e tre: chiude la questione "ogni ora va rimappata" |

**Perché è il primo passo e non un dettaglio:** se `SymbolInfoSessionTrade` su
BCM restituisce una sessione unica 00:00-23:59 (succede, con brokers pigri), il
pezzo A **non è implementabile come progettato** e bisogna ripiegare sulla
tabella oraria cablata — con tutti i limiti che quella comporta. Meglio saperlo
prima di scrivere 160 righe.

**Costo:** ~90 righe, zero rischio (script, non EA; nessun ordine, nessuna GV
scritta). **È l'unico pezzo che si può fare senza firma**, perché non può
cambiare il comportamento di niente.

---

# 🏛️ ARCHITETTURA COMUNE AI TRE PEZZI

## Il principio: **nessun EA va toccato**

Le ~97 chiamate a `ABTG_GuardiaIngresso(InpUsaGuardian,"NomeEA")` in **62 file**
restano **identiche riga per riga**. Il meccanismo funziona così:

```
ABTG_Guardian.mq5 (OnTimer, 1 Hz)          ABTG_PausaGuardian.mqh (lato EA)
  calcola i cancelli per SIMBOLO     --->     ABTG_GuardiaIngresso() legge
  scrive GlobalVariable per simbolo           la GV del PROPRIO simbolo
```

**Il simbolo non serve passarlo:** l'include lo ricava da solo con `_Symbol`
(nuovo argomento in coda `simbolo=""`, default = simbolo del grafico). Tutte le
chiamate esistenti continuano a valere.

⚠️ **L'unica eccezione misurata:** gli EA **multi-simbolo**, che tradano un
simbolo diverso da quello del grafico. Nel repo ne esistono **due**:
`ABTG_FiboH4_Multi.mq5:451` (apre su `sym`, preso da `InpSymbols`) e
`BREAKOUT_EA_JPY_Multi.mq5` (input `InpSymbols`). Verificato invece che
`ABTG_SupertrendReversal_Multi.mq5:270` opera su `_Symbol` malgrado il nome.
**Nessuno dei due multi-simbolo è fra le 38 sedie del censimento del 25/08**
(l'unica parente, `BREAKOUT_EA_JPY_v3`, ha il sorgente mancante e non è
auditabile). Quindi **oggi zero punti di chiamata da modificare**, ma la cosa va
scritta qui perché il giorno che uno di quei due torna in flotta, il cancello lo
proteggerebbe sul simbolo SBAGLIATO — in silenzio.

## Convenzione dei nomi: una sola fabbrica, altrimenti il filo si rompe

Il Guardian ha già pagato questo problema una volta: la `VerificaFilo()`
(`ABTG_Guardian.mq5:211-236`) esiste perché i nomi delle GlobalVariable sono
costruiti in **due posti diversi** e, se divergono, _"il canale muore in
SILENZIO"_.

**Proposta: non ripetere l'errore.** I nomi per simbolo si costruiscono **solo
nell'include**, con una funzione nuova che il Guardian usa a sua volta (il
Guardian già fa `#include <ABTG_PausaGuardian.mqh>` alla riga 47):

```
ABTG_GVNomeSym(radice, simbolo)  ->  "<radice>_<SIMBOLO>_<login>"
es.  ABTG_CUTOFF_D30EUR_50503392
     ABTG_NEWSBLK_XAUUSD_50503392
     ABTG_CONC_U30USD_50503392
```

Così il filo **non può divergere per costruzione**. `VerificaFilo()` va comunque
estesa (+~10 righe) per provare la nuova fabbrica su un simbolo campione.

Vincoli verificati: nome GV max 63 caratteri (qui siamo a ~30), 15 simboli × 3
cancelli = **45 GlobalVariable in più** — irrilevante.

## 🔓 Il fail-open nel tester: garanzia identica a oggi, e come la si ottiene

Regola non negoziabile del mandato: **nessun backtest deve cambiare di un numero**.

Il meccanismo esistente che lo garantisce è `ABTG_CanaleEsiste()`
(`.mqh:590-596`): nel Strategy Tester le GlobalVariable del Guardian non esistono
→ `ABTG_GuardiaIngresso()` esce con `return(true)` alla riga 1027, **prima** di
guardare pausa e cap.

👉 **I tre cancelli nuovi vanno letti DOPO quella riga**, dentro il blocco che
dipende dal canale — esattamente come B1 e C1. Conseguenze dichiarate:
1. **Nel tester non esistono**: fail-open totale, backtest confrontabili.
2. **Su un conto senza Guardian**: fail-open totale.
3. **Guardian morto**: il blocco scade da solo (§1.4).

⚠️ **Contro-esempio da NON seguire:** P1 (perdite consecutive) e S1 (obiettivo)
sono volutamente messi **prima** del fail-open, perché devono funzionare nel
tester. Per i cancelli di conformità **è sbagliato**: bloccherebbero i backtest e
li renderebbero incomparabili con tutto lo storico. Se un giorno si vorrà
*misurare in backtest* quanto costa il cutoff, si farà con un input separato
dentro il singolo EA, non da qui.

## 🧭 Modalità OSSERVA: obbligatoria prima di qualunque blocco

Un solo input, tre stati, per tutti e tre i cancelli:

```
InpCancelliModo = 0   // 0 = SPENTO (default, no-op assoluto)
                      // 1 = OSSERVA (calcola, logga, NON scrive nessuna GV)
                      // 2 = BLOCCA  (scrive le GV, gli EA si fermano)
```

In modalità **1** il Guardian scrive ogni giorno nel giornale, sedia per sedia:
_"in questa finestra il cancello X avrebbe bloccato N ingressi"_. È l'unico modo
di rispondere a **D1** con un numero invece che con un'opinione, e rispetta la
regola di casa "una variabile alla volta, si misura con e senza".

Da valutare con Claudio: portare quei contatori nella **pagella serale**
(`scarica_pagella.ps1`), così la misura arriva sul Desktop da sola.

---

# 🕐 PEZZO A — CUTOFF PRE-CHIUSURA CENTRALIZZATO

## A.1 Il problema, detto esatto
Il Guardian oggi **guarda solo il conto in euro**. Sa il saldo, l'equity, il
picco, l'ora di reset. **Non ha nessuna nozione di "che ore sono per il simbolo
X"**, e nemmeno di quali simboli esistano: gira su un grafico AUDCAD/AUDNZD che
non trada nessuno.

## A.2 Da dove arriva l'orario — due strade

### 🟢 Strada 1 (proposta): `SymbolInfoSessionTrade` — l'orario lo dice il broker
```
SymbolInfoSessionTrade(simbolo, giorno, indice, from, to)
```
Restituisce le sessioni di trading dichiarate dal broker per ogni giorno della
settimana (secondi dalla mezzanotte). Da lì si calcola: fine della sessione
corrente → inizio della prossima → **durata del buco**. Se il buco è ≥ 2h, si
è trovata una "chiusura rilevante".

**Cosa copre da sola, senza cablare un'ora:**
- ✅ **weekend**, su tutti i simboli (venerdì sera → domenica/lunedì);
- ✅ **pausa notturna indici europei ~3h** (D30EUR): il buco è nel dato;
- ✅ pause **<2h** (indici USA ~1h, oro ~1h, rollover forex): il calcolo le
  scarta da sé, nessuna eccezione da scrivere;
- ✅ **Nikkei 225JPY**, che il censimento marca `[NON VERIFICATO]`: non serve
  verificarlo a mano, lo dice il broker;
- ✅ **cambio broker BCM → FTMO** e **cambio fuso**: le sessioni sono in ora
  server, si rimappano da sole. Questo da solo vale il pezzo: il censimento
  avverte che _"ogni ora cablata in questo repo si sposta di un'ora al passaggio
  su FTMO"_.

**Cosa NON copre — dichiarato, non scoperto dopo:**
- ❌ **festivi** (Thanksgiving, 25 dicembre, festivi di borsa): la tabella
  sessioni è **settimanale e fissa**, non conosce il calendario. Una chiusura
  festiva ≥2h **non verrà vista**. Non c'è API MT5 che la dia.
- ❌ **chiusure straordinarie** (halt, problemi tecnici del broker).
- ❌ **cambi di orario annunciati dal broker** (i Trading Update settimanali
  FTMO): la tabella si aggiorna quando il broker aggiorna la specifica, con il
  suo ritardo.
- ❌ **DST**: se broker e specifica non sono coerenti nella settimana del cambio
  ora, si sbaglia di un'ora.
- ⚠️ **Se il broker dichiara le sessioni in modo pigro** (una sola 00:00-23:59),
  il metodo **non vede nessun buco e non blocca mai** — fail-open silenzioso.
  👉 Per questo la Fase 0 (sonda) viene prima, e per questo serve il contatore di
  §A.5.

### 🟡 Strada 2 (ripiego): tabella oraria per famiglia
Un input stringa tipo `"D30EUR=20:00;U30USD=22:00;XAUUSD=22:00;FOREX=22:00"`.
Costo minore (~50 righe invece di ~90), ma è **la stessa malattia che abbiamo
oggi**, solo concentrata in un posto: ore cablate a mano, da rimappare su FTMO,
cieche ai festivi e agli orari di venerdì. Utile **solo** come rete se la sonda
boccia la Strada 1, o come **override manuale per simbolo** sopra la Strada 1.

## A.3 Quali simboli sorveglia
Proposta: **i simboli selezionati in Market Watch** (`SymbolsTotal(true)` +
`SymbolName(i,true)`), perché un EA non può tradare un simbolo non presente in
Market Watch → la copertura è completa per costruzione, senza liste da tenere
aggiornate a mano (che è l'errore che ha fatto invecchiare `FLOTTA_ATTIVA.md`).
Con un input `InpCutoffSoloSimboli` (default "" = tutti) per restringere.

Costo di calcolo: la tabella sessioni è **statica**, si ricalcola ogni
`InpCutoffRicalcoloMin` (default 15 min) e si tiene in cache. Il timer a 1 Hz
legge solo la cache. Impatto sulle prestazioni: nullo.

## A.4 Come blocca — e perché con il pattern PAUSA, non con il pattern CAP

Nel Guardian esistono già **due pattern diversi** di bandiera, e la scelta non è
estetica:

| pattern | esempio | come scade |
|---|---|---|
| **CAP** (`GV_CAP`) | rischio aperto | timestamp **ri-timbrato ogni secondo**; se il Guardian muore, scade entro 120s |
| **PAUSA** (`GV_PAUSA` + `GV_PAUSAFINO`) | perdita giornaliera | timestamp + **scadenza dichiarata** |

👉 Per il cutoff serve il **pattern PAUSA**, e la ragione è precisa: il cutoff ha
una **fine nota** (la riapertura del mercato). Col pattern CAP, se il Guardian
muore alle 20:30 di venerdì, il blocco svanisce in 2 minuti e la flotta apre
dentro la finestra vietata — **fail-open su una regola di conformità**, che è
diverso dal fail-open su una regola di rischio. Col pattern PAUSA il blocco porta
con sé la propria scadenza e sopravvive alla morte del Guardian per la durata
giusta, e **non un minuto di più**.

🛡️ **Sicura contro l'errore di calcolo:** una scadenza sbagliata (bug che scrive
il 2030) bloccherebbe la flotta per sempre. Serve un tetto duro:
`InpCancelloMaxOreBlocco` (default **72h**), applicato prima di scrivere la GV.

## A.5 Anti-fallimento-silenzioso
Il difetto più grave trovato dal censimento non è un filtro spento: è un filtro
che **dice di essere acceso e non fa niente** (§3.2). Quindi il Guardian scrive
anche una GV di stato `ABTG_CUTOFF_STATO_<login>` = quanti simboli hanno una
chiusura ≥2h calcolata. **Se vale 0 con il cancello in modalità 2, è un allarme
rosso nel giornale e nel pannello**, non una riga informativa.

## A.6 🔴 IL BUCO CHE IL CANCELLO **NON** CHIUDE — gli ordini pendenti
`ABTG_GuardiaIngresso()` sta **sul percorso di apertura**. Un ordine **pendente
piazzato prima** del cutoff **scatta lo stesso** dentro la finestra vietata — e
per FTMO quello è "opening a simulated trade". Il limite è già dichiarato
nell'include per C1 (`.mqh:49-52`), ma per X16 **è una violazione, non una
imprecisione**.

Sedie interessate, dal censimento: `ABTG_ORB_Ottimizzato` (pendenti con
`InpPendingExpiryMin=600`), `ABTG_MaxMinNotte*`, `ABTG_EasyTrend` (LIMIT valido
3 barre H1), `ABTG_FiboH4*`.

**Serve un pezzo attivo, separato e a parte:** il Guardian **cancella i pendenti**
del simbolo all'ingresso della finestra vietata (~40 righe: il ciclo esiste già
in `FlattenAll()`, `.mq5:322-328`). ⚠️ Ma **cancellare un pendente è un'azione,
non un veto**: modifica la strategia della sedia, non solo la frena. Va dietro un
input suo (`InpCutoffCancellaPendenti`, default **false**) e **richiede una firma
separata da D1**.

## A.7 Aggancio nel Guardian esistente
| dove | cosa |
|---|---|
| `OnInit` (~riga 240) | costruzione nomi (via l'include), primo calcolo cache, estensione `VerificaFilo()` |
| `OnTimer` (~riga 428, dopo il blocco C1) | lettura cache, scrittura GV per simbolo |
| pannello (righe 442-454) | 2 righe nuove: "cutoff attivo su: D30EUR (fino 22:05)" |
| log periodico (riga 458) | contatore simboli in cutoff |
| `.mqh` `ABTG_MotivoStop_Calc` (riga 250) | nuovo argomento in coda a default 0 |
| `.mqh` `ABTG_MotivoTesto` (riga 263) | motivo **6** = "CUTOFF PRE-CHIUSURA (X16-ii)" |
| `.mqh` `ABTG_GuardiaIngresso` (riga 1007) | nuovo argomento in coda `simbolo=""` |

## A.8 💰 Costo del pezzo A
| voce | righe stimate | riferimento a codice esistente |
|---|---:|---|
| lettore sessioni + ricerca prossimo buco ≥2h (7 giorni × 4 indici, wrap del giorno) | **~90** | niente da riusare: API mai usata in repo |
| costruzione lista simboli + cache | ~30 | — |
| scrittura GV per simbolo (pattern PAUSA + clamp 72h) | ~25 | forma di `SetPausa()`, `.mq5:187-199` (12 righe) |
| modalità OSSERVA + contatori | ~25 | — |
| pannello + log + stato anti-silenzio | ~20 | pannello attuale = 13 righe |
| input nuovi (6) | ~8 | — |
| **totale Guardian** | **~200** | il file passa da 467 a ~670 righe |
| nucleo puro `ABTG_Cutoff*_Calc` + filo di lettura | ~30 | clone di `ABTG_PausaAttiva_Calc` |
| aggancio in `MotivoStop_Calc` / `GuardiaIngresso` / testi | ~20 | — |
| casi di autotest (finestra prima/dentro/dopo, scadenza, clamp, no-op) | ~40 | schema di `ABTG_AutotestGuardia()`, `.mqh:1389` |
| **totale include** | **~90** | |
| *opzionale* cancellazione pendenti | ~40 | ciclo di `FlattenAll()` |

**Complessità:** 🟡 media. La parte davvero delicata è **una sola**: l'aritmetica
"fine sessione → inizio prossima sessione" attraverso il cambio di giorno e il
weekend. È il punto dove si sbaglia, ed è l'unico che ha bisogno di autotest veri
(nucleo puro con sessioni finte passate come argomento — lo stesso trucco già
usato per P1 con i deal finti).

---

# 📰 PEZZO B — FILTRO NEWS CENTRALIZZATO

## B.1 Ha senso farlo nel Guardian? **Sì, e la risposta è nei numeri del censimento**

Argomenti a favore, tutti misurati:
1. **20 EA hanno già il filtro, in 20 copie del solito blocco** (`LoadNews()` +
   `InNewsBlackout()` + 6 input). Codice duplicato = bug duplicati: è
   letteralmente la lezione già scritta nell'include a proposito di P1
   (`.mqh:87-101`), dove contare i deal invece delle posizioni era stato copiato
   a mano in 3 EA e disinnescava il freno in tutti e 3.
2. **Il bug del ricaricamento si corregge una volta sola.** `LoadNews()` in
   `OnInit` è un difetto **strutturale del disegno per-EA**: un EA che gira per
   settimane non rilegge mai il file. Nel Guardian, che ha già un `OnTimer` a
   1 Hz, il ricaricamento periodico è **~15 righe**.
3. **18 sedie / 6 EA non hanno il filtro per niente** (`PunteLarry` ×6,
   `GapFill` ×5, `CostToCost` ×2, `EasyTrend` ×2, `Gold_Ichimoku`,
   `GapContinuation`). Nel Guardian **sono coperte gratis**. Per-EA vorrebbe dire
   6 patch nuove da validare.
4. **`BREAKOUT_EA_JPY_v3` non ha il sorgente nel repo**: per-EA è
   **impossibile**, dal Guardian è coperta come le altre.

Argomento contro, onesto: il filtro per-EA sa fare una cosa che il Guardian non
sa fare — **`InpNewsFlatten`**, cioè chiudere le posizioni prima dell'evento.
Ma quella è una funzione di *gestione*, non di *ingresso*, e non c'entra con
X16(i). Resta dove sta.

👉 **Raccomandazione: sì, nel Guardian. E i 20 filtri per-EA si lasciano dove
sono, spenti.** Non si toccano 20 file per spegnere qualcosa che è già spento;
si documenta che da quel giorno **la fonte di verità è il Guardian**, altrimenti
fra sei mesi qualcuno accende un `InpUseNewsFilter` e nessuno sa più quale dei
due comanda.

## B.2 Da dove arriva il calendario — due strade

### 🟢 Strada 1 (proposta): API calendario MT5
```
CalendarValueHistory(values, from, to, NULL, valuta)  +  CalendarEventById(...)
```
Precedente nel repo: `DAX_MASTER_PROP.mq5:1680-1709`, con già il pattern giusto
(`apiError` → blocco conservativo in live).

Cosa risolve **tutto insieme**: niente file, niente `aggiorna_news.ps1`, niente
CSV a 0 byte, niente `InpNewsShiftMinutes` da rimappare (le date arrivano già in
ora server), niente scheduler sul VPS. **Elimina tre dei quattro difetti
misurati al §3 del censimento in un colpo.**

Da verificare in Fase 0: (a) il broker fornisce il calendario? (b) [DA
VERIFICARE] disponibilità nello Strategy Tester — **irrilevante per il Guardian**,
che gira solo in live, ma rilevante se un giorno si vorrà backtestare il filtro.

### 🟡 Strada 2 (ripiego): lo stesso `abtg_news.csv`, letto dal Guardian
Il parser esiste già ed è corto (`ABTG_ORB_Ottimizzato.mq5:677-699`, 22 righe;
formato `Data Ora;Impatto;Valuta;Titolo`, separatore `;`). Ricaricamento ogni
`InpNewsRicaricaMin` (default 30) usando `FileGetInteger(h, FILE_MODIFY_DATE)`
per non rileggere inutilmente. **Ma resta appeso a un file che oggi è vuoto e a
uno scheduler che lo sovrascrive con 0 byte.** Se si sceglie questa strada, il
primo lavoro **non è codice**: è ripopolare `data/abtg_news.csv`.

## B.3 Come si decide che un simbolo è "colpito"
Un evento ha una **valuta**. Un simbolo va bloccato se una delle sue valute
combacia. Decomposizione **letta dal broker**, non cablata:
`SYMBOL_CURRENCY_BASE` + `SYMBOL_CURRENCY_PROFIT`.
- `EURUSD` → EUR, USD ✅ automatico
- `XAUUSD` → XAU, USD ✅ automatico (l'evento USD lo colpisce)
- `D30EUR` / `U30USD` / `225JPY` → **[DA VERIFICARE in Fase 0]** cosa dichiara
  BCM come valuta base di un indice. Se il dato è inutilizzabile serve una
  mappa manuale per i 4 indici (~15 righe) — ma **solo per 4 simboli**, non per
  tutti.

## B.4 Come blocca
Pattern **PAUSA** anche qui (l'evento ha una fine nota: `ora_evento + AfterMin`),
GV `ABTG_NEWSBLK_<sym>_<login>`, stesso clamp di 72h, motivo **7** =
"BLACKOUT NEWS (X16-i)".

## B.5 Anti-fallimento-silenzioso (§D7)
GV di stato `ABTG_NEWS_STATO_<login>` = numero di eventi caricati, e
`ABTG_NEWS_ULTIMOCARICO_<login>` = quando. Con **0 eventi e cancello in modalità
2**, riga rossa nel giornale e nel pannello a ogni ciclo di ricarica. È
esattamente la contromisura al difetto §3.2 del censimento: _"il pannello e il
preset dicono acceso… è il tipo di buco che si scopre solo dopo la violazione"_.

## B.6 💰 Costo del pezzo B
| voce | righe (via API calendario) | righe (via CSV) |
|---|---:|---:|
| lettura calendario / parser + ricarico periodico | ~70 | ~75 (22 di parser già scritte da copiare + ricarico + mtime) |
| decomposizione valute del simbolo (+ mappa indici) | ~45 | ~45 |
| calcolo blackout + scrittura GV per simbolo | ~35 | ~35 |
| stato anti-silenzio + log + pannello | ~25 | ~25 |
| input nuovi (5-6) | ~8 | ~8 |
| **totale Guardian** | **~185** | **~190** |
| nucleo puro + filo + motivo 7 nell'include | ~35 | ~35 |
| autotest (dentro/fuori finestra, valuta giusta/sbagliata, impatto sotto soglia, 0 eventi = no-op) | ~40 | ~40 |

**Complessità:** 🟡 media, ma il **rischio di progetto è più alto di A**, perché
dipende da una **fonte dati esterna** oggi rotta e non verificata. Il codice è la
parte facile.

---

# ⚖️ PEZZO C — CAP DI CONCENTRAZIONE PER SIMBOLO E GRUPPO (X15)

## C.1 I numeri veri della flotta (contati sul censimento del 25/08, 38 sedie)

| simbolo | sedie | magic |
|---|---:|---|
| **U30USD** | **8** | 770202 · 771531 · 772234 · 770611 · 771321 · 772341 · 770531 · 770511 |
| **GBPUSD** | **6** | 772161 · 772231 · 771322 · 771332 · 772345 · 772422 |
| **XAUUSD** | **5** | 970901 · 770402 · 250604 · 772343 · 971501 |
| **225JPY** | **4** | 772235 · 770924 · 770901 · 774101 |
| **D30EUR** | 3 | 770101 · 770411 · 970912 |
| EURUSD · AUDUSD | 2 ciascuno | — |
| NASUSD · EURCAD · EURAUD · GBPJPY · CHFJPY · EURJPY · GBPCAD · USDJPY | 1 ciascuno | — |

🔴 **Il dato che giustifica il pezzo:** a 0,65% di rischio per sedia, **U30USD da
solo può arrivare a 5,2%** — cioè **più del cap C1 dell'intero conto (3,25%)**.
Il cap totale oggi la lascia passare finché il resto della flotta è fermo. E
`ANALISI_CAP_C1_FINTOKEI_2026-08-27.md` ha misurato che il picco storico reale
(03/08) è stato **9 posizioni su 8 sedie = 5,85%**: la concentrazione non è
teorica, è già successa.

## C.2 Tassonomia proposta — **variante SEMPLICE** (tabella di gruppi)
Costruita sui 15 simboli che operiamo davvero, non inventata:

| gruppo | simboli | sedie | perché |
|---|---|---:|---|
| `IDX_US` | U30USD, NASUSD | **9** | correlazione storica altissima, stesso driver |
| `IDX_EU` | D30EUR | 3 | correlato anche a IDX_US: **dichiarato, non modellato** |
| `IDX_JP` | 225JPY | 4 | segue Wall Street con ritardo |
| `METALLI` | XAUUSD | 5 | da solo |
| `USD_MAJORS` | EURUSD, GBPUSD, AUDUSD | 10 | tutte "vendi USD" quando long |
| `EUR_X` | EURUSD, EURCAD, EURAUD, EURJPY | 5 | stessa gamba EUR |
| `GBP_X` | GBPUSD, GBPJPY, GBPCAD | 8 | stessa gamba GBP |
| `JPY_X` | GBPJPY, CHFJPY, EURJPY, USDJPY | 4 | stessa gamba JPY |

⚠️ **Due difetti dichiarati di questa variante**, entrambi veri:
1. **I gruppi si sovrappongono** (EURJPY sta in `EUR_X` e in `JPY_X`). Va deciso
   se un simbolo può appartenere a più gruppi (più corretto, più blocchi) o a
   uno solo (più semplice, meno preciso). → **D5**.
2. **Ignora la direzione.** Long EURUSD + long GBPUSD sono correlati; long EURUSD
   + long USDJPY sono **opposti** sull'USD, e sommarli come "rischio EUR/USD" è
   sbagliato: si bloccherebbe un ingresso che in realtà *riduce* la
   concentrazione.

## C.3 Tassonomia proposta — **variante VALUTARIA** (più corretta)
Invece dei gruppi, si calcola l'**esposizione netta per valuta**: ogni posizione
contribuisce il suo rischio (già calcolato da `LossIfStopHit()`, `.mq5:120-140`)
alla valuta base con un segno e alla valuta quotata con l'altro. Le valute si
leggono dal broker (`SYMBOL_CURRENCY_BASE`/`_PROFIT`), gli indici restano in
gruppi manuali (4 simboli).

Pro: cattura la correlazione **vera e direzionale**, non blocca hedge naturali,
niente tabella opinabile per il forex.
Contro: +~60 righe, e il concetto è meno immediato da spiegare a FTMO in un
eventuale contraddittorio ("il nostro cap è sull'esposizione netta per valuta"
richiede di mostrare il calcolo).

## C.4 Aggancio nel Guardian — è il pezzo che riusa di più
`OpenRiskPct()` (`.mq5:153-181`, 28 righe) **fa già il 70% del lavoro**: scorre
tutte le posizioni di tutti i magic, salta quelle senza SL contandole a parte, e
chiama `LossIfStopHit()`. Serve solo cambiarle l'accumulatore: da un totale
singolo a un vettore per simbolo (e per gruppo/valuta).

Nuovi input:
```
InpMaxRiskPerSymbolPct = 0    // 0 = spento (default neutro)
InpMaxRiskPerGroupPct  = 0    // 0 = spento
InpGruppiCorrelati     = ""   // "IDX_US=U30USD,NASUSD; GBP_X=GBPUSD,GBPJPY,GBPCAD; ..."
```
Bandiera: pattern **CAP** (ri-timbrata ogni secondo, scade da sola) — qui è
giusto, perché come C1 è una **condizione continua**, non una finestra con una
fine nota. Motivo **8** = "CAP CONCENTRAZIONE (X15)".

## C.5 💰 Costo del pezzo C
| voce | righe | riferimento |
|---|---:|---|
| `OpenRiskPct` → accumulatore per simbolo | **~55** | riscrittura di 28 righe esistenti, logica invariata |
| risoluzione gruppi: parsing tabella | ~45 | — |
| *oppure* esposizione per valuta (variante C.3) | ~70 | usa `SYMBOL_CURRENCY_*` |
| scrittura GV per simbolo (pattern CAP) | ~25 | forma del blocco C1, `.mq5:412-428` |
| pannello + log | ~15 | — |
| input (3) | ~5 | — |
| **totale Guardian** | **~145-170** | |
| nucleo puro + filo + motivo 8 nell'include | ~30 | clone di `ABTG_CapAttivo_Calc` |
| autotest (2 sedie stesso simbolo sotto/sopra, gruppi sovrapposti, spento = no-op) | ~35 | |

**Complessità:** 🟢 la **più bassa dei tre** sul piano tecnico (dati già in casa,
loop già scritto, pattern già collaudato). Ma è quella con **l'impatto operativo
più alto**: guardando i numeri di C.1, un cap per simbolo mordente cambia la
flotta tutti i giorni.

---

# ⚖️ I TRADE-OFF DELLA CENTRALIZZAZIONE — detti chiari

## ✅ A favore (perché il censimento indica il Guardian)
1. **Una modifica invece di 22.** 38 sedie coperte, incluse le 6 senza filtro
   news nel codice e **quella il cui sorgente non esiste nel repo**
   (`BREAKOUT_EA_JPY_v3`): per-EA sarebbe impossibile.
2. **Zero punti di chiamata da toccare.** Le ~97 chiamate in 62 file restano
   com'erano: nessuna ricompilazione della flotta, nessun ricaricamento dei
   grafici, nessun rischio di dita.
3. **Un bug si corregge una volta.** È la lezione P1 già scritta nell'include:
   il freno copiato a mano in 3 EA era rotto in 3 EA.
4. **Un solo posto da collaudare** e un solo posto da leggere per rispondere a
   "eravamo conformi il giorno X?".
5. **Si spegne in un secondo**: `InpCancelliModo=0` e la flotta torna esattamente
   com'era. Con 22 patch, tornare indietro sono 22 operazioni.

## 🔴 Contro — e questo è il rischio vero
1. **☠️ UN ERRORE CENTRALE FERMA TUTTA LA FLOTTA INSIEME.** Oggi un bug nel
   filtro orario di un EA blocca **una** sedia. Domani un bug nel calcolo della
   prossima chiusura blocca **tutte e 38**, in silenzio, e magari di venerdì
   pomeriggio. **È un rischio di natura diversa, non di grado.**
   → Mitigazioni proposte: modalità OSSERVA obbligatoria; clamp a 72h; GV di
   stato; e il fatto che il default resta neutro.
2. **Il Guardian diventa un single point of failure più grosso di oggi.** Oggi se
   muore, la flotta continua a tradare (fail-open voluto). Domani sarebbe
   l'unico a sapere quando è vietato aprire. Il pattern PAUSA con scadenza
   (§A.4) copre la morte del Guardian **durante** la finestra; non copre la sua
   morte **prima** (nessuno scrive la bandiera, nessuno blocca).
3. **Il file raddoppia.** 467 righe oggi; con tutti e tre i pezzi ~930-1000. Un
   Guardian che non si legge più in una seduta è un Guardian che si smette di
   verificare. → Contromisura: la logica pura va **nell'include**, come già fatto
   per P1 e S1; nel Guardian resta solo il filo. Da valutare un
   `ABTG_Cancelli.mqh` separato per non gonfiare un file già a 1461 righe.
4. **Latenza fino a 1 secondo e granularità 1 Hz.** Il Guardian valuta a ogni
   giro di timer; un EA che apre nell'intervallo passa. Irrilevante per una
   finestra di 2 ore, **non** irrilevante per un blackout news di pochi minuti.
5. **🔴 Non è un cambio a costo zero sui risultati.** Il cutoff toglie ingressi
   veri. `ABTG_SupRev_DAX_H4` valuta barre che chiudono alle 20:00, cioè
   **dentro** la finestra DAX: potrebbe perdere la maggior parte dei suoi
   segnali. I "contratti" delle sedie (DD e frequenza promessi) sono stati
   misurati **senza** questi cancelli → dopo l'accensione **vanno rimisurati**,
   altrimenti il criterio di uscita delle sedie del 18/08 giudica su una
   frequenza che non è più quella promessa. → §D1, e un round di backtest a
   parte per le sedie più colpite.
6. **Non copre i pendenti** (§A.6): il buco resta aperto finché non si firma
   l'azione di cancellazione, che è una cosa diversa da un veto.
7. **Si sposta il problema, non si elimina**: le ore cablate spariscono dagli EA
   ma la correttezza si sposta tutta su `SymbolInfoSessionTrade`. Se il dato del
   broker è sbagliato o pigro, sbagliamo su tutta la flotta insieme.

---

# 📋 RIEPILOGO COSTI E ORDINE PROPOSTO

| # | pezzo | Guardian | include | autotest | complessità | rischio di progetto |
|---|---|---:|---:|---:|---|---|
| **0** | 🔬 sonda (script, sola lettura) | — | — | — | 🟢 bassa | 🟢 nullo — **fattibile senza firma** |
| **A** | 🕐 cutoff pre-chiusura (X16-ii) | ~200 | ~50 | ~40 | 🟡 media | 🟡 aritmetica sessioni/weekend |
| **A+** | ✂️ cancellazione pendenti (opz.) | ~40 | — | ~10 | 🟢 bassa | 🔴 **azione, non veto** — firma separata |
| **C** | ⚖️ cap concentrazione (X15) | ~150 | ~30 | ~35 | 🟢 bassa | 🟠 alto impatto operativo |
| **B** | 📰 news centralizzate (X16-i) | ~185 | ~35 | ~40 | 🟡 media | 🔴 dipende da fonte dati rotta/non verificata |
| | **TOTALE (A+C+B)** | **~575** | **~115** | **~115** | | Guardian 467 → **~1040 righe** |

**Ordine proposto (→ D10):** `0 → A → C → B`, ogni pezzo con il suo ciclo
completo prima del successivo:

```
scrivere  →  autotest a tavolino  →  compilare (Claudio)  →
OSSERVA su demo N giorni  →  leggere i contatori  →  firma  →  BLOCCA
```

E per ognuno la domanda di controllo prima di passare al successivo:
**"quanti ingressi ha bloccato, su quali sedie, e quelle sedie erano ancora
profittevoli senza quegli ingressi?"** Senza quel numero, l'accensione è
un'opinione.

---

# ⚠️ COSA QUESTA PROPOSTA **NON** SA

Elencato qui perché lo si legga prima, non dopo:

1. **Non so cosa dichiara BCM in `SymbolInfoSessionTrade`.** Mai letto da nessun
   file del repo. Se il dato è inutilizzabile, il pezzo A cambia disegno. → Fase 0.
2. **Non so se il broker fornisce il calendario economico** all'API. Il
   precedente esiste (`DAX_MASTER_PROP`) ma non risulta mai girato in flotta. → Fase 0.
3. **Non so gli orari di sessione né i festivi su FTMO** (broker diverso, fuso
   diverso). Tutto va rimisurato lì prima della challenge.
4. **Non so se le 38 sedie siano ancora attaccate adesso**: la fotografia ha 3
   giorni ed è già dichiarata vecchia dal censimento stesso.
5. **Non so quanto costa il cutoff in P/L**, sedia per sedia. Nessuno lo sa
   finché non gira la modalità OSSERVA. Ogni numero che dicessi qui sarebbe
   inventato.
6. **Non so se FTMO consideri "gap trading" l'apertura alla riapertura**
   (famiglia GapFill): la mail del 28/08 non ha risposto. → D3.
7. **Non posso compilare né provare niente in questo ambiente**: non c'è MT5, né
   MetaEditor, né Strategy Tester. Tutte le stime di righe sono lette dal codice
   esistente, non misurate su una compilazione.

---

_Proposta di sola lettura. Nessun `.mq5`, `.mqh`, `.set` o preset modificato._
_Fonti: `ABTG_Guardian.mq5` (467 righe, v1.11), `ABTG_PausaGuardian.mqh` (1461
righe, v1.40), `CENSIMENTO_GAP_TRADING_FLOTTA_2026-08-28.md`,
`docs/REGOLAMENTO_FTMO_2026-08.md` §4-5-6,
`ANALISI_CAP_C1_FINTOKEI_2026-08-27.md`,
`censimento_rischio_2026-08-25_0731.txt`._
