# 🏹 CACCIA AL MERCATO — MQL5 Market, signal, configurazioni (23/08/2026)

_Scritto il **23/08/2026**. Ogni pagina citata e' stata **aperta davvero in
questa sessione**; la data di lettura e' **23/08/2026** salvo diversa
indicazione. Ogni numero che viene da fuori e' etichettato **[DICHIARATO DAL
VENDITORE, NON MISURATO DA NOI]**; i numeri prodotti dalle statistiche
automatiche di MQL5 sono **[MQL5, dato di piattaforma]** (piu' forti: li
calcola la piattaforma sui deal reali); le regole delle prop sono
**[LETTO-VIA-SEARCH]** perche' i siti delle prop sono bloccati (par. 1)._

🔒 **NON e' stato toccato NULLA**: nessun EA, nessun parametro in forward,
nessun file del Guardian, nessun `.set` di casa, `PIANO_PROP.md` intatto.
Questo file e' **solo un dossier**: le proposte del par. 10 sono SEGNALATE,
non applicate.

**Complementare a:** `SWEEP_APPROFONDITO_EA_2026-08-22.md` (ieri, 2.046
prodotti) — **qui NON si rifanno gli stessi prodotti**: si riparte da dove lo
sweep si e' fermato, con un censimento **7 volte piu' grande** e un metodo
nuovo (par. 3).

---

> # 🎯 LA RIGA CHE CONTA
>
> **Ho censito il Market INTERO — 14.631 EA + 5.456 utility = 20.087 prodotti,
> contro i 2.046 di ieri — e la risposta alla domanda di Claudio ("Gold
> Phantom era l'unico su ~2000: e' ancora cosi'?") e' SI', ed e' piu' forte di
> ieri: su 20.087 prodotti resta l'UNICO EA oro il cui signal del venditore
> sta sotto il 10% su ENTRAMBE le colonne di drawdown con >=150 operazioni e
> >=26 settimane.**
>
> **Ma il reperto piu' pesante della giornata e' un numero NUOVO su di lui, e
> va messo nei criteri PRIMA di qualunque test: il fratello maggiore dello
> stesso motore — The Gold Reaper, "Live default settings", 133 settimane —
> gira con un budget di drawdown dichiarato del 30% e ne ha realizzato
> il 45,64%. Il dimensionamento circolare che avevamo segnalato come bandiera
> rossa il 22/08 NON e' stato spiegato dall'autore, e sull'unica serie lunga
> della famiglia ha SFONDATO il proprio budget di 1,5 volte.**
> _[MQL5, dato di piattaforma — signal 2195619, letto il 23/08/2026]_
>
> **E il regalo grosso della giornata sono i VALORI: 24 file `.set` VERI
> scaricati e letti, di cui 16 MAI VISTI PRIMA nel repo (gli altri 8 erano
> gia' in `biblioteca/set/` dal 18/08 e li ho riscaricati come controllo
> positivo). Fra i 16 nuovi ci sono TRE preset "prop firm" ufficiali —
> compreso il primo di un venditore DIVERSO da Profalgo, che e' proprio il
> buco segnalato dal referto del 18/08 ("la convergenza a tre vendor e' in
> realta' due"). Il suo preset prop mette il cap giornaliero a 4,0% e il
> rischio per operazione a 0,30%, contro il 2,0% che lo stesso autore usa sul
> proprio conto: un fattore 6,7.**

---

## 1. ✅ CONTROLLO POSITIVO DELLE FONTI — fatto PRIMA di cercare

| canale | bersaglio noto | esito |
|---|---|---|
| **MQL5 Market** (curl) | scheda 161561 (Gold Phantom, gia' letta il 22/08) deve tornare HTML pieno | ✅ **200** |
| **MQL5 Market — listati** | `/market/mt5/expert/pageN` deve rendere 70 schede per pagina | ✅ **200 su 210 pagine** |
| **MQL5 Signals — schede** | signal 2355953 deve rendere le statistiche integrali | ✅ **200** |
| **MQL5 Signals — liste autore** | `/signals/author/strueli` deve rendere 27 righe | ✅ **200** |
| **MQL5 — commenti prodotto** | `/market/product/161561/comments` | ✅ **200**, 4 pagine, 69 commenti |
| **MQL5 — file allegati** (`c.mql5.com/...set|zip`) | il `.zip` dei set del Gold Phantom | ✅ **200, 12.176 byte** |
| **WebSearch** (motore generale) | regole FTMO | ✅ risponde con contenuti veri |
| **ftmo.com** / **help.ftmo.com** / **academy.ftmo.com** / **ftmo.oanda.com** | pagina Trading Objectives | ❌ **EGRESS_BLOCKED / 403 al CONNECT** 🛑 |
| **the5ers, fundednext, fundingpips, e8markets, alpha-capital, blueguardian, fundedtradingplus** | homepage | ❌ **403 al CONNECT** 🛑 **TUTTE NULLE** |
| **propfirmcircle, tradingfinder, myforexfirms, runvigil, propfirmmatch** (siti di recensioni prop) | articoli regole | ❌ **EGRESS_BLOCKED** 🛑 |

⚠️ **404 ≠ 503**: nessuna fonte e' stata dichiarata nulla per un errore
temporaneo. I 403 sono **rifiuti del proxy al CONNECT**, verificati con
`curl -sS "$HTTPS_PROXY/__agentproxy/status"` (registrati `connect_rejected`
per `ftmo.com:443` e `the5ers.com:443` alle 06:36 di oggi).

### 🔴 Cosa NON ho potuto vedere, e va dichiarato

1. **Nessun sito di prop firm, nessuno.** Tutto il par. 9 e' **[LETTO-VIA-SEARCH]**:
   frammenti restituiti dal motore di ricerca che **citano** pagine FTMO, non
   pagine che ho aperto io. **Non e' il regolamento: e' il racconto del
   regolamento.** Per la firma di S1 vale come indizio forte, non come prova.
2. **Le tab "Reviews"** dei prodotti restano in JavaScript (ho i conteggi e i
   commenti, non i testi delle recensioni). ⚠️ I **commenti** invece li ho
   letti per intero sul Gold Phantom (69 su 4 pagine, par. 4.3).
3. **Forex Factory, Reddit, Myfxbook**: non riprovati oggi, dichiarati nulli
   ieri. Il "come la gente fallisce le challenge" resta scoperto.

---

## 2. 📏 LA COPERTURA, IN NUMERI (e il confronto con ieri)

| cosa | ieri (22/08) | **oggi (23/08)** |
|---|---:|---:|
| pagine di listato Market sfogliate | 32 | **330** (210 experts + 120 utility; il listato utility si esaurisce alla **79ª** e poi si ripete) |
| **prodotti unici censiti** | 2.046 | **20.087** (14.631 experts + 5.456 utility) |
| schede prodotto aperte per intero | 66 | **51** (mirate, non a caso: par. 3) |
| pagine di **commenti** prodotto aperte | 0 | **4** (69 commenti, Gold Phantom) |
| liste signal per autore | 11 | **6** |
| **schede signal singole aperte** | 9 | **248** |
| **file `.set` VERI scaricati e letti** | 0 | **24**, di cui **16 nuovi** |
| sorgenti `.mq5` letti | 5 | 0 (fatto ieri, non ripetuto) |

📚 **Onesta' sulle fonti gia' in casa:** 8 dei 24 `.set` (i 7 del Gold Phantom
e il `propfirm` del Gold Reaper) **erano gia' nel repo dal 18/08**
(`backtest_pipeline/caccia_strategie/biblioteca/set/`, 63 file, documentati in
`CONFIG_PROP_RACCOLTA_SET_2026-08-18.md`). Li ho **riscaricati** come controllo
positivo — **byte identici** — e i loro valori (4,0 giornaliero, 9→4 in combo,
NFP 100/60) erano **gia' scritti in quel referto**. 🎯 **I 16 nuovi sono ORB
Master (7), Gold Trade Pro (6), US30 Market Maker (2), DAX Morning Scalp (1)**,
e sono quelli che portano i numeri nuovi del par. 7.

**Perche' 20.087 e non 2.046**: il listato del Market ha **210 pagine di
experts**, non 12. Ieri si erano viste le prime 12 (i "popolari"). Oggi sono
state sfogliate **tutte**, una per una, con pausa di 1,2 s. **Il 86% del
Market non era mai stato guardato.**

**I filtri applicati sui 14.631 EA** (titolo + descrizione della scheda):
`gold|xau` nel TITOLO = **2.381** · `dax|de40|ger40` = **127** ·
`us30|dow|dj30|wall street` = **212** · `us500|sp500|spx500` = **113** ·
`prop firm|ftmo|funded|challenge` = **567** · schede che pubblicano un **link
a un signal** = **221** (230 id unici).
**Sulle 5.456 utility**: `prop|drawdown|equity guard|risk manage|kill switch|
daily loss|guardian|protect` = **1.442**.

---

## 3. 🔬 IL METODO NUOVO — e il numero che da solo giustifica la giornata

Ieri il metodo era **prodotto → autore → signal**. Oggi ho aggiunto il
percorso inverso e automatico: **ho estratto tutti i link a signal scritti
dai venditori dentro le schede** (230 id unici) e **li ho aperti tutti**.

> ### 🔴 **97 di quei 230 signal — il 42% — oggi rispondono 404.**
> Cioe': **quattro "live signal" su dieci pubblicizzati sulla scheda di un
> prodotto in vendita NON ESISTONO PIU'.** Verificati uno per uno con
> `curl` (404, non 503). Non e' un incidente di rete: e' la fisiologia del
> Market. **Chi legge una scheda e vede "Live Signal" non sta guardando una
> prova: sta guardando un link che nel 42% dei casi e' gia' morto.**

**Il secondo pezzo del metodo — le DUE colonne di drawdown.** MQL5 pubblica
`Relative drawdown: By Balance` **e** `By Equity`, e **non sono la stessa
cosa**: sul Gold Reaper sono 45,64% e 10,56%; sul Gold House 11,10% e 1,33%;
sull'ArtQuant Gold 3,23% e 26,72% — **a volte e' piu' grande l'una, a volte
l'altra**. 🔴 **[INCERTO]**: la definizione esatta della colonna "By Equity"
non e' documentata in modo che io possa verificarla, e i due numeri sul Gold
Reaper sono aritmeticamente difficili da conciliare (un calo di saldo di
1.334 USD con un calo di equity di 298 USD).
➡️ **Regola che ho usato, dichiarata prima dei numeri: si prende il PEGGIORE
dei due.** E' conservativa e non richiede di sapere quale sia la definizione
giusta. ⚠️ **Nota per casa:** ieri il filtro era "DD sul SALDO > 20% → scarto";
con la regola del peggiore i verdetti non cambiano su nessun candidato di
oggi, ma il criterio va scritto cosi', non "sul saldo".

**Il terzo pezzo — il test a taglia vera.** Per ogni signal: deposito
iniziale, **ricariche** e **prelievi** (una ricarica gonfia o sgonfia il DD%
e rende il numero inutilizzabile), e **max deposit load** (quanto margine
sta davvero impegnando).

---

## 4. 🥇 ORO — la categoria che ha risposto

### 4.1 THE GOLD PHANTOM — **aggiornamento: confermato, con un numero nuovo contro**

```
NOME / VENDOR   The Gold Phantom / Profalgo Limited (Wim Schrynemakers, Malta)
URL             https://www.mql5.com/en/market/product/161561   [riaperto 23/08/2026]
PREZZO          649 USD - NOLEGGIO 349/3 mesi, 399/6 mesi, 499/1 anno
STATO OGGI      versione 1.4 del 19/05/2026 - 4.230 demo (erano 4.226) -
                54 recensioni (4,7) - 69 commenti - 10 attivazioni
                >>> NESSUN aggiornamento e NESSUN commento dal 23/06/2026
```

**Il signal, riletto oggi** _[MQL5, dato di piattaforma]_ — **invariato
rispetto al 22/08**: 31 settimane, **436 operazioni**, PF **1,34**, crescita
+26,40%, **DD saldo 8,56% / DD equity 6,89%**, **9 perdite consecutive**,
deposito 3.091 EUR, **ricariche 0,00**, **max deposit load 4,74%**, ultima
operazione **2 giorni fa**. ✅ **Dentro il muro del 10% su tutte e due le
colonne. E' l'unico di tutto il censimento.**

> ### 🔴 CORREZIONE A IERI — il "secondo signal indipendente" NON e' indipendente
> Il signal Darwinex ([2355966](https://www.mql5.com/en/signals/2355966)) ieri
> era citato come conferma su un altro broker (39 sett., 584 op., PF 1,14, DD
> saldo 11,02%). **Oggi ho letto le righe che ieri non erano state lette:
> deposito 2.000 EUR + RICARICHE 3.000 EUR**, e soprattutto **max deposit load
> 44,94% contro il 4,74% dell'altro conto**. 🎯 **Non e' lo stesso EA con la
> stessa taglia su un altro broker: e' lo stesso EA con circa DIECI VOLTE il
> carico di margine.** La "firma di rischio coerente su due conti" di ieri
> **non regge**: sono due configurazioni diverse.

> ### 🔴 IL REPERTO NUOVO E PESANTE — il budget di DD che non ha tenuto
> Il dimensionamento del Gold Phantom e' **circolare** (segnalato ieri): il
> lotto viene dal **DD storico di backtest** della strategia, tramite
> l'input `MaxAllowedDD`. Oggi ho **il file `.set` dell'autore** e **il signal
> del fratello maggiore**, e insieme fanno una misura:
>
> | | preset usato | budget DD dichiarato | **DD realizzato** | campione |
> |---|---|---:|---:|---|
> | **Gold Phantom Live** | `live account settings.set` | **30%** | **8,56%** | 31 sett., 436 op. |
> | **Gold Reaper Live** | *"default settings"* (default di fabbrica = **30%**) | **30%** | 🔴 **45,64%** | **133 sett., 1.300 op.** |
>
> **Stesso motore ("same DNA", lo scrive il venditore), stesso budget del 30%:
> sul campione corto ne consuma un quarto, sul campione lungo lo sfonda di
> 1,5 volte.** _[MQL5, signal 2195619 e 2355953, letti il 23/08/2026]_
>
> **Cosa vuol dire per noi, in numeri**: il preset `GoldPhantom_Propfirm.set`
> chiede `MaxAllowedDD=9`. Se sul lungo il rapporto fosse lo stesso del
> Reaper (**1,52x**), il DD atteso sarebbe **~13,7%** — cioe' **fuori dal muro
> del 10%**. ⚠️ **[INFERITO]**, e dico da cosa: un solo rapporto misurato su un
> solo prodotto, e assumendo che il lotto scali linearmente col budget. **Non
> e' una bocciatura. E' il numero da scrivere nei criteri PRIMA del test**,
> perche' e' esattamente cio' che il gradino 3 deve andare a smentire o
> confermare sui nostri anni e i nostri costi.

**🚩 Bandiere rosse: quelle di ieri restano, piu' due lette oggi nei 69
commenti** (tutti, dal #1 al #69):
- 🟠 **L'autore NON ha mai spiegato la circolarita'.** La domanda diretta non
  gliel'ha mai fatta nessuno. Ha pero' confermato il meccanismo: _"se tieni lo
  stesso 'max allowed total drawdown', il rischio resta lo stesso (l'EA girera'
  a lotto piu' basso)"_ (#59) e _"il lotto si adegua al prezzo reale dell'oro
  per tenere il rischio costante"_ (#19). ➡️ **Il DD di backtest E' la manopola
  del rischio. Confermato, non risolto.**
- 🔴 **Ordini pendenti lontanissimi.** Almeno **cinque acquirenti diversi**
  (#20, #22, #28, #36, #38) segnalano che con l'oro sopra 5.000 l'EA piazza
  10-12 pendenti a 4.500 e uno a 3.267, e opera pochissimo. Risposta
  dell'autore: e' normale, i livelli di supporto sono lontani, si avvicineranno
  (#29, #37, #39). 🎯 **Per una challenge questo conta due volte**: (a) e'
  **rischio in ordini pendenti** — la voce che il nostro C1 **non conta**
  (proposta S7); (b) un motore che sta fermo per settimane e' un motore che
  **non produce il target**, e il campione forward diventa lentissimo.
- 🔴 **NON ha filtro orario ne' controllo dello slippage.** Richiesti da un
  utente (#64), rifiutati dall'autore (#65): _"non e' uno scalper"_. Un
  acquirente ha risposto con **tre operazioni chiuse in perdita durante il
  rollover** (#66); risposta: _"i dati 2004-2026 non mostrano perdite intorno
  al rollover"_ (#67). ⚠️ Su una prop, **l'unico freno serale disponibile e'
  `FridayStopHour`** — e nei set del venditore e' **disattivato (25)**.

**⚖️ Due diligence sul venditore, aggiornata**: 27 prodotti, **29 signal**,
di cui alcuni a 409, 340, 328, 260, 226 e 208 settimane. **E continua a
lasciare online i propri fallimenti**: `Gold Scalp Test` −96% (DD 98%),
`Bitcoin Reaper Live` −13%, `The ORB Master Live` −15%, `UBS Scalp Test`
−34%. 🎯 **Resta il venditore piu' onesto trovato in due giorni di caccia.**
📌 **Dato nuovo:** l'unico suo signal con **denaro vero di terzi** e'
`Gold Reaper New V2 2` — **32 abbonati, 117.000 USD di fondi sottoscritti**,
95 settimane, 847 op., PF 2,33, **DD saldo 16,89% / equity 7,18%**.

**VERDETTO: 🟢 resta l'unico candidato al gradino 3**, con **due paletti
nuovi da scrivere nei criteri**: (1) il budget di DD del preset prop (9%) va
trattato come **ottimistico di ~1,5x** finche' non lo misuriamo noi;
(2) il **rischio in ordini pendenti** va contato, perche' questo EA ne tiene
10+ aperti per settimane.

### 4.2 GOLD HOUSE MT5 — il secondo migliore, e cade sul canarino di casa

```
NOME / VENDOR   Gold House MT5 / Chen Jia Qi (login walter2008)
URL             https://www.mql5.com/en/market/product/165036   [aperto 23/08/2026]
PREZZO          749 USD (dichiara: +50 USD ogni 10 copie, prezzo finale 1.999)
RECENSIONI      59 (4,49)
MECCANISMO      [DICHIARATO] breakout di swing high/low, 5 strategie
                indipendenti, 3 modalita' (Profit Priority / BE Priority /
                Adaptive). "No Grid. No Martingale."
```

Il venditore pubblica **tre signal, uno per modalita'** — e va riconosciuto:
**dichiara lui stesso** che l'Adaptive e' *"High-Risk Configuration Reference
– Not a recommended configuration"*. _[MQL5, dato di piattaforma]_

| modalita' | sett. | op. | PF | DD saldo | DD equity | **perdite consecutive** | deposito |
|---|---:|---:|---:|---:|---:|---:|---|
| **Profit Priority** (2359124) | 28 | **571** | 1,47 | **11,10%** | 1,33% | 🔴 **22** | 2.000, ricariche 0 |
| BE Priority (2372604) | 18 | 412 | 2,32 | 5,76% | 1,78% | 7 | 2.000, ricariche 0 |
| Adaptive "high risk" (2379287) | 10 | 179 | 0,83 | **64,62%** | 10,41% | 21 | 2.000 + **1.216 ricariche** |
| _(quarto conto, non citato nella scheda)_ **PP Compound** (2379420) | 25 | 540 | **1,05** | 🔴 **57%** | — | — | — |

> 🔴 **Il canarino di casa lo boccia: 22 perdite consecutive.**
> A rischio 0,65% pieno fanno **14,3%** — il muro totale e' 10%. Il Gold
> Phantom ne fa **9** (5,85%). **Non e' una questione di gusto: e' la
> differenza fra un motore che puo' stare su una challenge e uno che no.**
> E il tasso di vincita del 43% dice che quelle strisce sono strutturali.
> 📌 In piu': la **quarta** modalita' (`PP Compound`, 25 sett., 540 op.) fa
> **PF 1,05 e DD 57%** e **non e' citata sulla scheda del prodotto**.

**VERDETTO: 🟠 scartato dopo verifica.** Non per disonesta' del venditore
(che anzi etichetta la configurazione pericolosa), ma per **22 perdite
consecutive** e per il fatto che i parametri consigliati **non sono pubblici**
(*"dopo l'acquisto mandami un messaggio privato per ricevere i parametri
consigliati"*) — cioe' **non c'e' niente da copiare senza pagare**.

### 4.3 Gli altri ORO passati al setaccio — e perche' cadono

_(Tutti [MQL5, dato di piattaforma], letti oggi. "DD" = il **peggiore** delle
due colonne, regola del par. 3.)_

| prodotto (venditore) | signal | sett. | op. | PF | **DD peggiore** | perche' cade |
|---|---|---:|---:|---:|---:|---|
| **Daytrade Pro Algo** (Profalgo) | 1949810 | **172** | **1.248** | 1,25 | **15,61%** | il piu' lungo track oro pulito trovato, ma **1,5x il muro** |
| **Gold Trade Pro** (Profalgo) | 2084890 | 150 | 725 | 1,59 | **31,95%** | 3x il muro |
| Gold Trade Pro (2° conto) | 2242498 | 111 | 523 | 1,36 | **60,45%** | 6x il muro |
| **Gold Zilla AI** (metasignalspro) | 2362448 | 33 | 336 | 1,47 | **14,28%** | fuori muro; **un secondo signal e' 404** |
| **Adaptive Gold Scalper** (Fan Yang) | 7 signal | 3-48 | 26-254 | 0,86-2,69 | **17% → 73%** | 🔴 **sette conti dello stesso EA con DD da 17 a 73%**: la vetrina e' una scelta, non una misura |
| **GOLD Scalper PRO** (autotrader) | 2353871 | 36 | 553 | 1,14 | **26,63%** | fuori muro |
| **True Invest Algo** (Kareem Abbas, 768 USD) | 2354826 | 32 | 630 | 1,37 | 10,46% | 🔴 **1 sola recensione** + **ricariche 773 su 1.000 di deposito** → il DD% non e' leggibile |
| **Forex GOLD Investor** (autotrader) | 2290275/2331815 | 86-89 | 412-864 | 2,71-3,48 | 7,00-23,16% | 🔴 **i signal sono su GBPUSD**, non sull'oro del prodotto |
| **Venom Gold Pro** (drmelhem, 599 USD, 31 rec.) | 1748354/59 | — | — | — | — | 🔴 **entrambi i signal 404** |
| **EA Gold Stuff** (Strukov, **686 recensioni**) | — | — | — | — | — | 🔴 **zero signal nella scheda**: il prodotto piu' recensito del Market oro non ha una prova |
| **XG Gold Robot / Dark Gold / One Gold / GOLD EAgle / Gold Candle Bot / Aurum Ra** | — | — | — | — | — | 🔴 **zero signal nella scheda** |
| **Gold Gridscalping · Gold 1 Minute Grid** | — | — | — | — | — | 🔴 **scarto automatico**: "grid" nel nome |
| **Iron Stops · Coffee Cup 5 · Neuron Cortex** | 2386516 · 2383746 · 2385985 | **1-2** | 3-829 | — | — | 🔴 vendono il **"100K Real Signal"**: i conti da 100.000 USD ci sono, ma hanno **1-2 settimane di vita** (par. 5) |

---

## 5. 🧪 IL TEST A TAGLIA VERA — il risultato piu' netto della giornata

Il test di casa: *"il DD del signal vetrina regge su un conto vero e grande?"*.
Su 248 signal aperti, quelli con **deposito >= 50.000** sono **CINQUE**:

| signal | prodotto | deposito | settimane | op. | PF | DD peggiore |
|---|---|---:|---:|---:|---:|---:|
| 2386516 | Iron Stops | **100.000 USD** | **1** | **3** | 106,29 | 0,95% |
| 2383746 | Coffee Cup 5 | **100.000 USD** | **2** | **4** | 3,52 | 0,03% |
| 2385985 | Neuron Cortex | **100.000 USD** | **2** | 829 | 2,33 | 11,27% |
| 2382619 | Live Candle | 150.402 USD | 5 | 19 | **0,73** | 8,99% |
| 2359128 | Tokyo Sniper USDJPY | **509.722 USD** | **47** | 199 | 🔴 **0,96** | 19,67% |

> 🎯 **Il test a taglia vera, su tutto il Market, da' questo:**
> **i conti veramente grandi o hanno due settimane di vita — e sono cartelloni
> pubblicitari, non prove — oppure PERDONO.** L'unico conto grande **e** lungo
> di tutto il censimento (509.722 USD, 47 settimane) fa **PF 0,96**.
> 📌 E' su USDJPY: **corrobora in modo indipendente R95/R96 e la chiusura del
> fronte JPY** — mezzo milione di dollari veri su USDJPY, quasi un anno, in
> perdita.
>
> **Il corollario che vale per tutte le schede prodotto: quando un venditore
> scrive "100K Real Signal" in cima alla pagina, la domanda giusta non e'
> "quanto rende" ma "da quanti giorni esiste".** Oggi, tre volte su tre, la
> risposta e' "da una o due settimane".

---

## 6. 📉 DAX E INDICI NON-NASDAQ — la risposta e' NO, ed e' misurata

Filtro su 14.631 EA: **127 titoli/descrizioni nominano DAX/DE40/GER40**,
**212 US30/Dow**, **113 US500/SP500**. Ho ordinato i **330** non-Nasdaq per
**numero di recensioni** (la sola proxy di anzianita' disponibile a scala) e
aperto per intero le **25 schede piu' recensite**, poi tutti i loro signal.

| prodotto | prezzo | rec. | signal del venditore | esito |
|---|---|---:|---|---|
| **DAX EA** (Babak Alamdar) | 499 USD | 5 | [2359205](https://www.mql5.com/en/signals/2359205): **38 sett., 489 op., PF 0,72, DD 33%, crescita −21%** | 🔴 **il DAX del venditore PERDE** |
| **US30 Dow Jones EA** (stesso autore) | 499,99 | 10 | 2294738: 80 sett., 182 op., **PF 1,73**, DD **24,84%**, conto **260 USD** | 🟠 il migliore del gruppo, ma DD 2,5x il muro e conto da vetrina |
| **Index Sniper Pro** (pubguc242) | 399 USD | 13 | 2286996: 103 sett., 437 op., PF 1,16, **DD 48,56%**, conto 210 USD | 🟠 fuori muro |
| **Stealth 150 DE40** (szymon100m) | 2.000 USD | 1 | 2361170: **il signal e' su XAUUSD**, DD **91,19%** | 🔴 prodotto DAX, signal oro, DD 91% |
| **DAX Keltner Channel Breaker** (atohm) | — | 1 | 2267756: **il signal e' su EURUSD**, DD equity **56%** | 🔴 stesso schema |
| **Cortex IDX** (Vladimir Mametov) | 499 USD | 2 | 2376781: **11 settimane**, 109 op., PF 4,36, DD 14% | 🟠 campione troppo giovane |
| **DOW King** (Anton Kondratev) | 245 USD | 9 | 2196371 → **404** | 🔴 signal morto |
| **Wall Street Robot / DAX Robot** (mqlblue) | 999 / 1.199 USD | 18 / 3 | **nessun signal** | 🔴 |
| **The US30 Market Maker** e **The DAX Morning Scalp** (njtrading) | 79 / 30 USD | 8 / 6 | **l'autore non ha NESSUN signal** (verificato: 0) | 🟠 **ma pubblicano i `.set`**: par. 7 |
| altri 16 | — | 0-7 | 0 o 404 | 🔴 |

> 🎯 **La riga da portare a casa sul DAX: su 14.631 EA del Market, NON ESISTE
> un solo prodotto DAX/US30/SP500 con un signal reale, sul simbolo giusto,
> dentro il muro del 10%.** I due prodotti DE40 che pubblicano un signal lo
> pubblicano **su un altro strumento**. Il DAX del venditore piu' prolifico
> fa **PF 0,72 su 489 operazioni**.
> 📌 **Questo NON dice che il DAX non paghi** — dice che **il web non ha una
> soluzione DAX da copiare**, esattamente come ieri non ce l'aveva sul Nasdaq
> (ORB Master, PF 0,89) e sullo JPY.

---

## 7. 🧰 LA TABELLA DEI VALORI COPIABILI — 24 file `.set` VERI

**Questa e' la pagina che vale il dossier.** Non descrizioni di pannelli:
i **file**, scaricati da `c.mql5.com` e letti chiave per chiave. Sei di essi
sono preset **"prop firm" ufficiali del venditore**.

📦 **I 16 file nuovi sono DEPOSITATI in
`backtest_pipeline/caccia_strategie/biblioteca/set/` col suffisso
`_2026-08-23.set` e indicizzati in `biblioteca/CATALOGO.md`**, secondo la
regola della biblioteca del 18/08: _si archivia SOLO il `.set` (testo di
configurazione), MAI l'EA_; sono URL pubblici `c.mql5.com`, scaricabili senza
pagare e senza login. Se un venditore li ritira, la copia resta come prova di
cio' che era pubblico oggi.

| prodotto | file scaricati | nuovo? | dove |
|---|---|---|---|
| **The Gold Phantom** (Profalgo) | **7** (Low/Medium/High/**Propfirm**/**Propfirm_combo**/combo/**live dell'autore**) + readMe | 📚 gia' in repo dal 18/08 — riscaricato, identico | `c.mql5.com/31/1765/The_Gold_Phantom_setFiles.zip` |
| **The Gold Reaper** (Profalgo) | **1** (**propfirm**) | 📚 gia' in repo dal 18/08 | `c.mql5.com/31/1047/propfirm__1.set` |
| **Gold Trade Pro** (Profalgo) | **6** (V4 Low/Med/High/**prop firm** + V2 **prop** + V2 "1.62 risk") | 🆕 **NUOVO** | `c.mql5.com/31/1547/goldtrade_pro.zip` + 2 file sciolti |
| **The ORB Master** (Profalgo) | **7** (low/medium/high/very high/combo/**prop firm**/**prop firm combo**) | 🆕 **NUOVO** — e sono gli unici preset **su INDICI** trovati in due giorni | `c.mql5.com/31/1544/the_ORB_Master_sets__1.zip` |
| **The US30 Market Maker** (njtrading) | **2** (High risk + **Prop trading**) | 🆕 **NUOVO — e il venditore e' INDIPENDENTE da Profalgo** | `c.mql5.com/31/1542/...` |
| **The DAX Morning Scalp** (njtrading) | **1** (2024 brunch breakout con BE stop) | 🆕 **NUOVO — l'unico set DAX pubblico trovato** | `c.mql5.com/31/1155/...` |

⚠️ **Attenzione a non contare due volte lo stesso venditore** (avvertenza gia'
scritta nel referto del 18/08, par. B1): **Gold Phantom, Gold Reaper, Gold
Trade Pro e ORB Master sono TUTTI e QUATTRO di Profalgo Limited** — hanno la
stessa lista di input perche' sono lo stesso codice. **Come fonti indipendenti
valgono UNO.** 🎯 **Il valore vero di oggi e' che njtrading e' il SECONDO
venditore, davvero indipendente, e conferma il 4,0 con parole e input suoi**
(`MaxDDpercentage`, non `PropFirmMaxDailyDD`).

### 7.1 🥇 LA COLONNA "PROP" CONTRO LA COLONNA "PERSONALE" — il confronto che conta

| valore | preset **personale** del venditore | preset **PROP** dello stesso venditore | **noi** |
|---|---|---|---|
| **cap perdita GIORNALIERA** (`PropFirmMaxDailyDD` / `MaxDDpercentage`) | **0 = spento** in tutti e 24 | 🔴 **4,0** — in **5 preset**: 4 di Profalgo (Phantom, Phantom combo, Reaper, GoldTradePro V4) **= una fonte sola**, + 1 di **njtrading = la SECONDA fonte indipendente** | **4,9** emergenza / **4,0** pausa |
| **rischio per operazione** | 1,60-2,00% (GoldTradePro V2) · **2,0%** (US30 MM high risk) | 🔴 **0,40%** (GoldTradePro V2 prop) · 🔴 **0,30%** (US30 MM prop) | **0,65%** |
| **budget di DD totale** (`MaxAllowedDD`) | 10 / 30 / 60 (low/med/high) · **30** sul conto dell'autore | **9** (Phantom prop, Reaper prop) | muro 10, MC ~8,1% |
| **budget di DD in CONVIVENZA con altri EA** | 7 (combo) | 🔴 **4** (`Propfirm_combo`) | — |
| **rischio massimo per strategia** (`MaxRisk_Strategy`) | 5 / 10 / 15 / 20 (low→very high) · 3 (combo) | 🔴 **2** (prop) · 🔴 **1** (prop combo) | C1 = 3,25% aggregato |
| **randomizzazione** | 0 | **50** (Phantom prop) · **100 punti** (US30 MM prop) | non esiste |
| **`OnlyUp`** (il lotto non scende dopo le perdite) | **true** | 🔴 **false** sui preset prop del Phantom | non esiste |
| **`UseEquity`** (base del calcolo) | **false = SALDO** in tutti e 24 i file | **false = SALDO** | **saldo** ✅ |
| **chiusura del venerdi'** (`FridayStopHour`) | **25 = DISATTIVATA** | **25 = DISATTIVATA** anche sui prop | non esiste |
| **spread massimo** | 500 punti | 500 punti | non esiste |
| **giorni operativi** | tutti e 5 | tutti e 5 | — |

> 🎯 **Le tre letture che ne escono, e sono contro-intuitive:**
> 1. **Il cap giornaliero 4,0% ha finalmente una SECONDA fonte.** Il referto
>    del 18/08 aveva gia' il 4,0 dai file di Profalgo, ma ci aveva messo
>    l'avvertenza giusta: *"Gold Reaper e Gold Phantom sono lo stesso autore →
>    la convergenza a tre vendor e' in realta' DUE"*. **Oggi njtrading, un
>    venditore che non c'entra niente, con un input che si chiama in un altro
>    modo, mette lo stesso 4,0.** **Il nostro 4,0 di pausa (B1) e' il numero
>    del campo, e adesso lo e' su due gambe.**
> 2. **Il rischio per operazione sui preset prop e' 0,30-0,40%, cioe' META'
>    del nostro 0,65%** — e lo stesso venditore, sul proprio conto, usa 2,0%.
>    **La differenza fra "conto mio" e "conto della prop" e' un fattore 5-7.**
> 3. **Nessuno chiude il venerdi'.** Il freno che ieri era la proposta S8
>    (`FridayStopHour`) esiste in tutti i preset ed e' **spento in tutti e 24**,
>    prop compresi. ⚠️ **Non e' una prova che sia inutile — e' una prova che il
>    campo non lo usa**, e quindi che S8 va misurata da noi prima di adottarla.

### 7.2 📰 IL FILTRO NEWS, coi numeri veri per strumento

**Fatto nuovo: la finestra news NON e' una costante, e' una scelta per
strumento.** Tre prodotti dello stesso venditore, tre finestre diverse:

| prodotto | evento | **minuti PRIMA** | **minuti DOPO** | attivo? | chiude anche i pendenti? |
|---|---|---:|---:|---|---|
| **Gold Phantom** (oro) | NFP | **100** | **60** | ✅ si | ✅ si |
| Gold Phantom | tassi (IR) / CPI | 100 | 60 | ❌ no (presente, spento) | — |
| **ORB Master** (indici) | NFP | **50** | **30** | ✅ si | ✅ si |
| ORB Master | tassi (IR) / CPI | 60 | **120** | ❌ no (presente, spento) | — |
| **Gold Trade Pro** (oro) | NFP | **10** | 🔴 **240** | ✅ si | ✅ si |
| _(ieri, da descrizione)_ Prop News Filter Pro | generico | 15 | — | blocco a 15', chiusura a 2' | — |

Comune a tutti: `UseMQL5Calendar=true` (il calendario nativo) **e**
`AutoGMT=true` con `GMT_OFFSET_Winter=2` / `Summer=3` di riserva, piu' una URL
di time-server da autorizzare nel terminale.
🎯 **Per noi:** conferma che il fuso e' un input, non un'assunzione — e che
sul nostro server (BCM) qualunque finestra letta fuori va convertita.

### 7.3 🇩🇪 IL DAX — l'unico set DAX pubblico trovato, tradotto in ora BCM

`The_Dax_Morning_Scalp_v2.31_-_2024_brunch_breakout_with_BE_stop.set`
(njtrading, salvato il 25/07/2024, EA a **30 USD**, 6 recensioni, "no
martingale / no grid / no hedging", **M15**):

| input | valore | lettura |
|---|---:|---|
| `Manual_DAX_opening_hour_based_on_broker_time` | **11** | ⚠️ **non e' l'apertura**: e' un **"brunch breakout"** (il nome del file lo dice) |
| `AggressiveMode_Start_minute` / `NormalTrading_Start_minute` | **20** / **45** | due finestre: 11:20 e 11:45 ora broker |
| `OrderDelete_hour` / `_min` | **13:00** | i pendenti si cancellano a meta' giornata |
| `Risk_of_account_balance_per_trade_in_percent` | **1** | (la scheda consiglia **0,5%-6%**) |
| `ATRperiod` / `ATRstop` / `ATRtp` | **5** / **1,4** / **2,0** | SL = 1,4 ATR(5), TP = 2,0 ATR(5) → **R/R 1:1,43** |
| `ATRtrailingDistance` | **0,6** | trailing a 0,6 ATR |
| `TrailingStopLoss` / `BreakEvenStop` | **true** / **true** | |
| `EntryDiviation` | **500** punti | tolleranza d'ingresso |
| modalita' attive | **solo NormalMode** | Aggressive/Reversal/Safety/UltraSafety spente |

🕐 **Conversione in ora server BCM** _[INFERITO, e dico da cosa]_: il set non
dichiara il fuso del broker; l'altro set dello **stesso venditore** dichiara
`Broker_GMT=2`. Con broker GMT+2 (= CEST) e **BCM = ora italiana − 1 = GMT+1**:
**11:20 broker → 10:20 server BCM**, **11:45 → 10:45**, **13:00 → 12:00**.
⚠️ **[INCERTO]** finche' non lo si verifica: se il broker fosse GMT+3, tutto
scala di un'altra ora.

🎯 **Perche' ci interessa davvero:** e' un **breakout di meta' mattina sul
DAX** — non l'apertura. La nostra famiglia DAX lavora sull'apertura (08:00
server). **E' un'idea di finestra diversa, con SL e TP gia' in ATR**, e con
i pendenti che muoiono alle 12:00 server. **Costa zero provarla come asse di
un round; non costa un acquisto.**

### 7.4 🇺🇸 IL PRESET PROP PIU' ESPLICITO DI TUTTI (US30)

`The_US30_Market_Maker_v2.3_-_Prop_trading.set` contro `High_risk.set`,
**stesso EA, stesso giorno, stessa versione** — le uniche 4 differenze:

| input | High risk | **Prop trading** | fattore |
|---|---:|---:|---:|
| `StopLossPercentage` (rischio per operazione) | **2,0%** | 🔴 **0,3%** | **÷ 6,7** |
| `StopLossAroundBigNews` | 2,0% | 🔴 **0,3%** | ÷ 6,7 |
| `MaxDDpercentage` (cap giornaliero) | **0 = spento** | 🔴 **4,0%** | — |
| `RandomPointDiviation` | 0 | **100 punti** | — |

**Tutto il resto e' identico** (ATR stop 0,9-1,5-2,0 · ATR TP 1,2-3,2-3,7 ·
`NewsFilter=true` · `Broker_GMT=2` · trailing spento · 5 giorni su 5).
🎯 **Il messaggio del campo, in una riga: passare da "conto mio" a "conto
prop" NON cambia il motore — cambia SOLO la taglia (÷6,7), accende il cap
giornaliero al 4% e randomizza.** E' esattamente l'architettura che abbiamo
(motore + Guardian), scritta da un altro.

---

## 8. 🧱 MECCANISMI CHE CI MANCANO — sei NUOVI, oltre ai 24 di ieri

Dalle **6 utility di rischio** aperte oggi (scelte fra le 1.442 filtrate, per
recensioni e anzianita'), tutte **[DICHIARATO DAL VENDITORE]**:

| # | meccanismo | dove l'ho letto | ce l'abbiamo? |
|---|---|---|---|
| **25** | **filtro di VOLATILITA'**: pausa quando la variazione giornaliera o la volatilita' di candela supera una soglia | `Take a Break MT5` (Eric Emmrich, **25 recensioni**, 70 USD → 89 dal 1/9) | 🔴 **NO** |
| **26** | **limite MENSILE** (oltre a giornaliero e settimanale) | `Strifor RiskManager` (esempio a video: **giorno 5% · settimana 8% · mese 12%**) · `Risk Manager for MT5` (Batudayev, 16 rec.) | 🔴 **NO** |
| **27** | 🥇 **"Cap flex by max limit"**: impedire che il limite si ALLARGHI quando arrivano i profitti | `Strifor RiskManager` | 🔴 **NO** — ed e' il gemello prudente del nostro `InpDDMode` |
| **28** | **chiudere prima della news solo se c'e' un profitto minimo** (altrimenti si lascia correre) | `Take a Break MT5` | 🔴 **NO** |
| **29** | **ripristino automatico dell'intera configurazione** (grafici + parametri degli EA) quando la pausa finisce | `Take a Break MT5` | 🔴 **NO** — noi la pausa la togliamo, ma non ripristiniamo niente |
| **30** | **annullamento delle SOTTOSCRIZIONI ai signal** al trigger (non solo chiusura ordini) | `Equity Protect Pro MT5` (18 funzioni indipendenti) | ⚪ **non ci riguarda oggi** (non copiamo signal) — ma se un giorno si', e' la falla |
| _(24 bis)_ | **cancellazione dell'ordine in eccesso CON SPIEGAZIONE a schermo** ("hai aperto il 6° ordine, il massimo e' 5") | `Risk Manager for MT5` | 🟡 noi blocchiamo, non spieghiamo |
| _(24 ter)_ | **fasce orarie multiple, ognuna col proprio tetto di perdita e la propria pausa** | `Take a Break` · `EmoGuardian` (gia' ieri) | 🔴 **NO** |

⚠️ **`Take a Break` va guardata con una riserva scritta**: la versione v26
(agosto 2026) aggiunge una **"AI Trade Assessment"** che valuta gli ingressi e
li chiude in automatico. 🔴 **Quella meta' del prodotto e' esattamente il tipo
di cosa che non entra in casa nostra** (nessuna misura, nessun sorgente).
La meta' che interessa — news filter unico per tutti gli EA, limiti
giornalieri, controllo di sessione, pausa dopo le perdite — e' **la lista di
controllo, non il prodotto**.

**Conteggio aggiornato: 30 meccanismi censiti, ne abbiamo 6 pieni + 5 parziali
+ S1 (consegnato stamattina) = 12. Ne mancano 18.**

---

## 9. 📜 NOVITA' REGOLAMENTARI DELLE PROP — e la risposta per la firma di S1

🔴 **TUTTO questo paragrafo e' [LETTO-VIA-SEARCH]**: `ftmo.com`,
`help.ftmo.com`, `academy.ftmo.com` e `ftmo.oanda.com` sono **bloccati dal
proxy** (par. 1). Sono frammenti che **citano** pagine FTMO, non pagine
aperte da me. **Vanno confermati per iscritto dal supporto prima di
diventare numeri di casa** (regola D3).

### 9.1 🥇 LA RISPOSTA CHE SERVIVA A S1 — come si misura il profit target

> *"A Profit Target means that a trader reaches a profit in the sum of
> **closed positions**... You will meet this objective once your **account
> balance** exceeds the Initial Simulated Capital by the required Profit
> Target **with all positions closed**."*
> **[LETTO-VIA-SEARCH, 23/08/2026 — attribuito a FTMO Academy / Trading
> Objectives]**

✅ **La scelta fatta stamattina in `GUARDIAN_S1_2026-08-23.md` par. 3.1 —
misurare sul SALDO e non sull'equity — risulta CORRETTA.** Il par. 8 di quel
referto listava questa come domanda aperta n. 1: **e' chiusa a livello di
indizio forte, non ancora a livello di prova.**
📌 E si aggiunge un dettaglio che il nostro S1 **non implementa**: il target
si considera raggiunto **con tutte le posizioni chiuse**. S1 oggi blocca solo
le aperture; la meta' "chiudi tutto" resta il pezzo aperto n. 2.

### 9.2 🧾 SCHEDA PROP — FTMO, come risulta oggi [LETTO-VIA-SEARCH]

```
PROP            FTMO                     URL REGOLE  ftmo.com/en/trading-objectives/  [NON APERTA: bloccata]
LETTA IL        23/08/2026 — solo tramite frammenti di ricerca
```

| | **Challenge 2-Step** (la nostra ipotesi F1) | **Challenge 1-Step** (novita' da censire) |
|---|---|---|
| **profit target** | **10%** fase 1 · **5%** fase 2 (la fase 2 e' sempre il 50% della fase 1) | **10%**, tempo illimitato |
| **perdita giornaliera max** | **5%** | 🔴 **3%** |
| **perdita massima** | **10% STATICA** | 🔴 **10% TRAILING** |
| **regola di consistenza** | ❌ **nessuna** | 🔴 **Best Day Rule 50%** |
| **profit split iniziale** | 80% | 90% |

- **Reset del muro giornaliero**: *"recalculated daily at **00:00 CE(S)T**"*,
  sul **saldo registrato alle 00:00**, e **include il P/L flottante**, le
  commissioni e gli swap. Monitorato in **ora di Praga**.
- **Best Day Rule (solo 1-Step)**: il giorno migliore non deve superare il
  **50%** della somma dei **giorni positivi** — calcolato **sulle operazioni
  chiuse a fine giornata (00:00 CE(S)T)**. **Non e' una violazione**: blocca
  il superamento finche' non si fa altro profitto.
- **News**: la finestra **±2 minuti** su strumenti selezionati vale sui
  **conti FTMO Account (finanziati) 2-Step**; **NON viene applicata durante
  Challenge e Verification**; i conti **Swing** ne sono esenti.
- **EA**: ammessi. **Copy trading da terzi/segnali esterni: vietato.**
  Copiare **fra conti propri**: consentito.
- **2026**: aumento delle quote del **15-25%** su 50K-200K; acquisizione di
  **OANDA** completata a dicembre 2025.

> 🎯 **Le tre conseguenze operative per noi:**
> 1. ✅ **Il 2-Step resta l'unica porta compatibile col nostro metro.** Il
>    1-Step ha **DD TRAILING**, e `METRO_PROP.md` dice a chiare lettere che
>    **tutte le nostre Monte Carlo sono su DD STATICO** e col trailing **non
>    valgono**. Il 1-Step non e' "piu' facile": e' **una gara di cui non
>    conosciamo il percorso**.
> 2. ✅ **Niente consistenza sul 2-Step** → la proposta **S12** di ieri (cap di
>    profitto giornaliero) **non serve** sulla prop di riferimento. Servirebbe
>    solo se si scegliesse il 1-Step, e allora il numero e' **50%**.
> 3. 🟡 **Il filtro news non serve durante la challenge**, serve **dopo**, sul
>    conto finanziato. **Cambia l'ordine delle priorita'**: prima si passa,
>    poi si accende il filtro.

### 9.3 ⏰ E la domanda sull'ora di reset, resa PRECISA

Ieri il dubbio era generico. Oggi si puo' scrivere in una riga sola, e
**e' verificabile in casa, senza chiedere niente a nessuno**:

> **Il reset FTMO e' alle 00:00 CE(S)T, cioe' segue l'ora legale europea.
> Il nostro `InpDailyResetHour=23` e' giusto SE E SOLO SE l'orologio del
> server BCM si sposta con l'ora legale insieme all'Italia.**
> - se BCM = ora italiana − 1 **tutto l'anno** (cioe' GMT+0 d'inverno, GMT+1
>   d'estate) → **23 e' corretto in entrambe le stagioni** ✅
> - se BCM sta fermo su un fuso fisso → **a fine ottobre il 23 diventa
>   sbagliato di un'ora** 🔴
>
> ➡️ **Non e' una domanda per il supporto della prop: e' una misura sui nostri
> dati** (basta guardare l'orario delle candele BCM prima e dopo l'ultimo
> cambio d'ora). **Va messa in calendario per ottobre.**

---

## 10. 📋 SEGNALAZIONI — nessuna si applica da sola

🔒 **`PIANO_PROP.md` NON e' stato toccato.** Righe candidate, ordinate per
resa/costo. Le sigle **S1-S15** sono quelle del referto di ieri; le nuove
partono da **M1** per non confondersi.

| # | proposta | dove | fonte (par.) | costo | rischio / cosa puo' rompere |
|---|---|---|---|---|---|
| **M1** | 🥇 **Scrivere nei criteri del gradino 3 del Gold Phantom il moltiplicatore 1,5x**: il DD dichiarato dal preset (9%) va trattato come **~13,7% atteso** finche' non lo misuriamo noi. Il test si progetta per **smentire quel numero**, non per confermare l'8,56% | criteri del round, prima dei numeri | 4.1 | **0 h** (e' una riga nei criteri) | 🟢 nessuno: e' l'opposto del rischio |
| **M2** | 🥇 **Contare il rischio degli ORDINI PENDENTI** (= S7 di ieri, ma ora ha un motivo misurato: il Gold Phantom tiene **10-12 pendenti** aperti per settimane) | `ABTG_Guardian`, C1 | 4.1 | ~2 h | doppio conteggio: un pendente non e' rischio certo → serve un peso o un cap separato |
| **M3** | 🥈 **`InpMaxPerditeConsecutive` come CANARINO DI SELEZIONE, non solo come freno**: nessun motore entra se le perdite consecutive misurate x 0,65% superano il muro | criteri di famiglia | 4.2 (Gold House: **22** = 14,3%) | ~1 h | e' un criterio, non codice: rischia di essere troppo severo su motori a bassa frequenza |
| **M4** | 🥈 **Provare la taglia prop del campo: 0,30-0,40% per operazione** come scenario Monte Carlo accanto a 0,65% | Monte Carlo, non forward | 7.1 | ~2 h | 🔴 **dimezzare il rischio dimezza anche il profitto**: va misurato quanto tempo servirebbe per il target del 10% |
| **M5** | 🥈 **Round DAX "brunch breakout"**: finestra 10:20-10:45 server BCM, SL 1,4 ATR(5), TP 2,0 ATR, pendenti cancellati alle 12:00 | file prova nuovo | 7.3 | 1 round | ⚠️ la conversione di fuso e' **[INCERTO]**: primo passo = fissare il fuso, non lanciare |
| **M6** | 🥉 **Filtro news per STRUMENTO, non unico** (oro 100'/60' · indici 50'/30') | dossier news + Guardian | 7.2 | ~2 h in piu' | complica la configurazione; da fare **dopo** aver passato la challenge (par. 9.2) |
| **M7** | 🥉 **"Cap flex by max limit"**: il limite giornaliero non si allarga coi profitti della giornata | `ABTG_Guardian` | 8 (#27) | ~1 h | ⚠️ tocca la baseline: **non si tocca senza firma** |
| **M8** | 🔵 **Filtro di volatilita'** (pausa se il movimento del giorno supera X ATR) | `ABTG_Guardian` o singoli EA | 8 (#25) | ~3 h | 🔴 puo' spegnere il motore proprio nei giorni che paga: **serve misurarlo, non adottarlo** |
| **M9** | 🔵 **Verifica di ottobre: l'orologio BCM segue l'ora legale?** | misura sui nostri dati | 9.3 | ~1 h | 🟢 nessuno. **Se la risposta e' "no", `InpDailyResetHour=23` diventa sbagliato di un'ora** |
| **M10** | ⚪ **S12 (cap di profitto giornaliero) va in fondo alla coda**: sul 2-Step FTMO la consistenza **non esiste** | `PIANO_PROP.md` | 9.2 | — | vale solo se si sceglie il 1-Step (e allora: 50%) |

### 🥇 Se Claudio ne sceglie UNA sola, io farei **M1** — e costa zero

**Perche':** e' l'unica che cambia un **criterio prima dei numeri**, che e' la
regola di casa piu' cara. Il Gold Phantom e' l'unico candidato esterno vivo, e
oggi sappiamo una cosa che ieri non sapevamo: **il suo modo di dimensionare ha
gia' sbagliato di 1,5 volte su un fratello con 133 settimane di storia.** Se
scriviamo quel numero nei criteri **prima** di lanciare il test, il round non
puo' mentirci; se lo scriviamo dopo, avremo cambiato i criteri sui numeri —
esattamente cio' che il progetto vieta.

---

## 11. 🗂️ ELENCO DELLE PAGINE E DEI FILE APERTI (per chi verra' dopo)

| artefatto | cosa ci ho preso |
|---|---|
| `mql5.com/en/market/mt5/expert` **pag. 1-210** | **14.631 EA** (titolo, autore, prezzo, rating, descrizione) |
| `mql5.com/en/market/mt5/utility` **pag. 1-120** | **5.456 utility** (il listato satura alla 79ª) |
| **248 schede signal** `/en/signals/<id>` | settimane, operazioni, PF, **le due colonne di DD**, perdite consecutive, deposito, ricariche, prelievi, deposit load — **97 hanno risposto 404** |
| `/en/signals/author/` **strueli · walter2008 · njtrading · babakalamdar · pubguc242 · vladimit_m** | 6 liste signal complete |
| `market/product/161561` + `/comments` **pag. 1-4** | Gold Phantom: pannello input completo, **69 commenti letti tutti** |
| `signals/2355953` · `2355966` · `2195619` · `2265877` | Gold Phantom (2 conti) e Gold Reaper (2 conti): **il confronto budget/realizzato** |
| `market/product/` 165036 · 111357 · 150079 · 102737 · 104750 · 102586 + **25 schede indici** + **16 schede oro** + **6 utility di rischio** | par. 4, 6, 8 |
| 🔧 **24 file `.set`** da `c.mql5.com` (elenco al par. 7) | **i valori copiabili — il cuore del dossier** |
| WebSearch (6 interrogazioni) | par. 9, **tutto [LETTO-VIA-SEARCH]** |
| ❌ ftmo.com · help.ftmo.com · academy.ftmo.com · ftmo.oanda.com · the5ers · fundednext · fundingpips · e8markets · alpha-capital · blueguardian · fundedtradingplus · propfirmcircle · tradingfinder · myforexfirms · runvigil | **tutti 403 / EGRESS_BLOCKED** — dichiarati nulli al par. 1 |
