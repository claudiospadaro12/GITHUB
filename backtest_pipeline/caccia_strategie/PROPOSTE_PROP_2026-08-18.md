# 📋 PROPOSTE dalla caccia config-prop del 18/08/2026

_Companion di `CONFIG_PROP_2026-08-18.md`. **Nessuna di queste e' stata
applicata.** Decide Claudio; e comunque prima passano dall'imbuto come
qualunque modifica (gli `_Ottimizzato` girano in parallelo, mai sostituiti)._

⛔ **Zero proposte di acquisto.** Ogni meccanismo qui sotto lo sappiamo
scrivere noi: sono 20-200 righe di MQL5, non un prodotto.

Ordine: **resa / costo**. La prima e' quasi gratis e ci ripaga subito.

---

## P1 · 🕐 Il preset del Guardian sbaglia l'ORA DI RESET di un'ora

```
PROPOSTA   InpDailyResetHour: 0 -> 23 nel preset ABTG_Guardian_FTMO_2Step.set
           (+ una riga di commento che spiega da cosa dipende il numero)
DOVE       mql5/Presets/ABTG_Guardian_FTMO_2Step.set   (solo il preset, il codice non si tocca)
FONTE      Scheda FTMO §2A + tabella conversioni §2H del dossier
COSTO      5 minuti. ZERO round di test.
RISCHIO    Basso, ma NON nullo: il numero giusto dipende dal SERVER su cui gira
           il Guardian, non dalla prop. 23 e' corretto su un demo BCM in
           ESTATE. Su BCM in inverno diventa 23 comunque (BCM segue l'ora
           legale come l'Italia -> resta italiana-1, e FTMO resta CET/CEST).
           Sul server di FTMO tornerebbe 0. Va scritto accanto al numero,
           altrimenti fra sei mesi nessuno sa perche' c'e' scritto 23.
```
**Perche' conta:** FTMO resetta a **00:00 CE(S)T = 23:00 ora server BCM**. Col
preset attuale il dry-run misura una giornata prop **sfasata di un'ora**: una
perdita fatta fra le 23:00 e le 00:00 BCM viene contata nel giorno **sbagliato**
e il dry-run direbbe "passato" dove FTMO direbbe "fuori". Sballa la misura, non
il conto vero. **E' l'errore piu' economico da togliere di tutto il dossier.**

---

## P2 · 🛡️ Il BUFFER — spostare il guardiano un punto PRIMA del muro

```
PROPOSTA   Due input nuovi in ABTG_Guardian.mq5:
             input double InpDailyBufferPct = 1.0;  // scatta a (DailyLossPct - buffer)
             input double InpTotalBufferPct = 1.0;  // scatta a (TotalDDPct  - buffer)
           Preset FTMO 2-Step: soglie effettive 4,0% giorno / 9,0% totale.
DOVE       ABTG_Guardian.mq5 (2 input + 2 righe nel calcolo dei limiti) + preset
FONTE      §1A-ZERO: Gold Reaper propfirm (PropFirmMaxDailyDD=4 / MaxAllowedDD=9),
           Gold Phantom Propfirm (identici), Prop Firm Pass (InpSafetyBufferPercent=0.1)
COSTO      ~1 ora di sviluppo. 1 round di dry-run sul demo per vedere quante
           volte scatta in una settimana.
RISCHIO    🔴 Il vero rischio e' l'OPPOSTO di quello che sembra: un guardiano
           che scatta troppo presto CHIUDE UNA GIORNATA CHE SAREBBE RIENTRATA.
           Con la nostra peggior giornata misurata a -2,06% (R51) un cap a
           -4,0% e' larghissimo, ma va misurato sul dry-run prima di crederci.
           Secondo rischio: chiusura forzata su spread largo -> si esce peggio
           del prezzo che ha fatto scattare la soglia. Non e' ipotetico:
           FlattenAll() chiude a mercato, qualunque sia lo spread.
```
**Perche' conta — la riga che spiega tutto:**
il nostro preset mette **5,0 e 10,0**, cioe' **esattamente sul muro**. Quando
scatta, **la challenge e' gia' persa**: il Guardian oggi non e' un guardiano,
e' un **necroforo** — chiude le posizioni un istante DOPO la violazione.
Tre vendor indipendenti, sui loro preset "prop firm", mettono **4 e 9**.
**Un punto percentuale di anticipo, tre volte su tre.**

---

## P3 · 💰 Il BUDGET DI RISCHIO CONDIVISO — la lezione del `Propfirm_combo`

```
PROPOSTA   (a) Misurare: quante sedie possono essere aperte NELLO STESSO
               momento, e quanto rischio aperto fa la somma.
           (b) Se la somma supera una soglia dichiarata, tagliare il rischio
               per sedia -- non per tutte allo stesso modo, ma per le sedie
               che si sovrappongono nel tempo.
           (c) Input nuovo nel Guardian: InpMaxOpenRiskPct (cap sul rischio
               APERTO totale, somma degli SL delle posizioni vive).
DOVE       (a) analisi sui dati che abbiamo gia' (export per-trade R16);
           (b) input dei singoli EA;  (c) ABTG_Guardian.mq5
FONTE      §1A-ZERO diff n.2: Gold Phantom taglia MaxAllowedDD da 9 a 4 quando
           l'EA condivide il conto. + PROPstyle (MaxTotalRiskPercent=1.0)
           + Bneu (cap rischio aperto 3% di default)
COSTO      (a) ~2 ore di analisi (dati gia' in casa, nessun backtest nuovo)
           (b) 0 ore di codice, e' un numero nei .set -- ma serve (a) prima
           (c) ~3 ore + 1 round di dry-run
RISCHIO    Tagliare il rischio taglia anche il rendimento, e su una prop il
           target va comunque raggiunto: un portafoglio troppo timido non passa
           la fase 1 nei giorni disponibili. E' un compromesso da MISURARE, non
           da decidere a occhio.
```
**Perche' conta — coi nostri numeri:** rischio di casa **0,65% per trade**.
Con **8 sedie** che possono trovarsi aperte insieme, il rischio aperto arriva a
**5,2%**, cioe' **oltre il muro giornaliero del 5%** di FTMO/FundedNext/The5ers
e **ben oltre il 4%** di E8. **Non e' una possibilita' teorica: e' aritmetica.**
E il 29/07 due EA hanno gia' aperto lo stesso segnale nello stesso secondo.
PROPstyle consiglia ai prop trader **`MaxTotalRiskPercent = 1.0`**: un ottavo
di quello che potremmo avere aperto oggi.

---

## P4 · 🚦 Il DOPPIO LIVELLO giornaliero — pausa morbida prima del muro duro

```
PROPOSTA   Tre input nuovi in ABTG_Guardian.mq5:
             input bool   InpDailyPauseEnabled = true;
             input double InpDailyPausePct     = 2.5;   // soglia MORBIDA
             input int    InpDailyPauseDays    = 1;     // giorni di pausa
           A InpDailyPausePct: NON chiude le posizioni aperte, BLOCCA i nuovi
           ingressi per il resto della giornata (e opzionalmente N giorni).
           A InpDailyLossPct (il muro): chiude tutto, come oggi.
DOVE       ABTG_Guardian.mq5 -- ma serve un canale per "bloccare i nuovi
           ingressi" senza chiudere: oggi il Guardian sa solo FlattenAll().
           Opzioni: GlobalVariable letta dagli EA, oppure disabilitare
           l'autotrading del terminale.
FONTE      Prop Firm Pass: InpDailyDDPauseEnabled=true, InpDailyDDPausePercent=4,
           InpDailyDDPauseDays=1 (documentazione PDF: "cooldown")
           + blog MQL5 31/07/2025: daily drawdown cap 2,5%
COSTO      ~4-6 ore (il pezzo difficile e' il canale di blocco, non la soglia)
           + 1 round di dry-run + una modifica minima in ogni EA che deve
           leggere la variabile di blocco.
RISCHIO    🔴 Se il canale di blocco e' una GlobalVariable, ogni EA che non la
           legge la ignora: si crea un guardiano che CREDE di aver bloccato e
           non ha bloccato niente. Va verificato EA per EA, non assunto.
           Se invece si spegne l'autotrading del terminale, si spengono anche
           le uscite/trailing degli EA: le posizioni aperte restano orfane.
           NESSUNA delle due opzioni e' gratis.
```
**Perche' conta:** la nostra peggior giornata misurata e' **−2,06%** (R51).
Una soglia morbida a **2,5%** dice: _"oggi hai gia' fatto peggio del tuo
peggior giorno storico — smetti di aprire"_. E' **revenge trading prevention**
scritta in un numero che abbiamo misurato noi, non copiato.

---

## P5 · 📰 Il FILTRO NEWS — non ce l'abbiamo, e su tre prop e' un hard breach

```
PROPOSTA   Un modulo condiviso (.mqh) che usa CalendarValueHistory() -- il
           calendario NATIVO di MT5, niente DLL, niente WebRequest -- con:
             input bool InpNewsFilter        = true;
             input int  InpNewsMinutesBefore = 15;
             input int  InpNewsMinutesAfter  = 15;
             input bool InpNewsCloseOpen     = false;  // chiude anche l'aperto
             input bool InpNewsCancelPending = true;
           Poi incluso negli EA, uno alla volta, come input SPENTO di default.
DOVE       nuovo mql5/Include/ABTG_NewsFilter.mqh + 3 righe per EA
FONTE      NYAO Scalper (CalendarValueHistory, finestre 15/15 -> 45/45 per profilo)
           + Gold Phantom (UseMQL5Calendar=true, NFP 100 min prima / 60 dopo,
             con NFP_CloseOpenTrades=true e NFP_ClosePendingOrders=true)
           + regole prop: FTMO +/-2 min (solo Standard), The5ers +/-2 min,
             E8 +/-5 min, FundingPips +/-10 min ANCHE SOLO TENENDO
COSTO      ~6-10 ore per il modulo + 1 round per EA.
           ⚠️ E QUI C'E' IL COSTO NASCOSTO CHE CAMBIA TUTTO (sotto).
RISCHIO    🔴🔴 CalendarValueHistory() NON RISPONDE NELLO STRATEGY TESTER
           (dichiarato nel README di NYAO, [VERIFICATO]).
           Conseguenza brutale: **un filtro news non e' backtestabile.**
           Non possiamo misurare quanto ci costa o ci rende. Il nostro imbuto
           -- criteri scritti prima, verdetto solo OOS a tick reali -- **non si
           applica**. Accenderlo significa cambiare il sistema su una modifica
           che non sappiamo misurare: e' esattamente cio' che la casa non fa.
```
**La lettura onesta:** questo e' il buco piu' grande (**nessun** nostro EA ha
un filtro news, in **nessuna** forma) e insieme la proposta piu' scomoda.
**Ci sono due strade, e vanno tenute separate:**
- **Strada A — conformita':** filtro news stretto (±2/±5/±10 min secondo la
  prop) solo per **non violare una regola**. Costa poco in trade persi, e non
  ha bisogno di essere "profittevole": e' un obbligo contrattuale.
- **Strada B — protezione:** finestre larghe alla Gold Phantom (100 min prima
  di NFP). **Questa cambia l'edge**, non e' backtestabile, e va trattata come
  una modifica di strategia. **Non si accende perche' "lo fanno tutti".**

Nota di realta': **i nostri backtest sono ottimistici sulle news per
costruzione**, filtro o non filtro. Andrebbe scritto accanto a ogni DD che
pubblichiamo.

---

## P6 · 🔁 Il FILTRO DUPLICATI — la ferita del 29/07, con tre parametri

```
PROPOSTA   Nel Guardian (che vede TUTTO il conto, e' il posto giusto):
             input bool   InpDupFilter        = true;
             input int    InpDupWindowSec     = 60;    // finestra
             input double InpDupPriceTolPts   = 50;    // tolleranza prezzo
             input double InpDupVolumeTolPct  = 20;    // tolleranza volume
           Se due posizioni stesso SIMBOLO + stesso LATO entrano nella finestra
           entro le tolleranze -> ne chiude una (la piu' recente) e logga.
DOVE       ABTG_Guardian.mq5 (OnTradeTransaction, non OnTimer)
FONTE      Bneu Prop Firm Pass System, gruppo "Duplicate Filter":
           finestra in SECONDI + tolleranza di prezzo + tolleranza di volume
           + ignora-magic + ambito. E' il solo prodotto letto che ce l'ha.
COSTO      ~4 ore + 1 round di dry-run.
RISCHIO    🔴 Rischio serio di FALSI POSITIVI: due EA diversi possono
           legittimamente essere long sullo stesso simbolo per motivi diversi
           (uno swing H4, uno intraday M5). Chiudere il secondo distrugge una
           strategia valida. La finestra di 60 secondi e' pensata per beccare
           il caso "stesso segnale nello stesso istante", NON la
           sovrapposizione naturale. Serve un modo per dichiarare le coppie
           esentate. Se non lo si fa, questa proposta fa piu' male che bene.
```
**Perche' conta:** il 29/07 due EA hanno aperto **lo stesso segnale nello
stesso secondo** (`CENSIMENTO_ORDINI_PC.md` §3). Regola 1 della
`ROTTA_PROP.md`: _"mai due EA sullo stesso segnale/simbolo/lato allo stesso
rischio pieno"_. **Oggi quella regola e' scritta in un file, non nel codice:
niente la fa rispettare.**

---

## P7 · 📉 Il TERZO MODELLO DI DRAWDOWN — trailing sul saldo di fine giornata

```
PROPOSTA   InpDDMode: aggiungere il valore 2 = TRAILING END-OF-DAY sul saldo
           di chiusura piu' alto (il limite sale, non scende mai).
             0 = statico (oggi)
             1 = trailing dal picco di EQUITY (oggi)
             2 = trailing dal SALDO di fine giornata piu' alto  <-- NUOVO
DOVE       ABTG_Guardian.mq5 (una GlobalVariable in piu': il saldo massimo
           registrato all'ora di reset)
FONTE      KT Equity Protector dichiara esattamente TRE modelli di ancoraggio:
           statico / trailing highest BALANCE / trailing EQUITY.
           + FTMO 1-Step: "il limite puo' solo salire, mai scendere",
             esempio saldo 104.000 a mezzanotte -> muro a 94.000
COSTO      ~2-3 ore. Nessun round di test nuovo per il codice.
RISCHIO    Basso sul codice. 🔴 ALTO sulla decisione a monte: METRO_PROP §1 dice
           che tutte le nostre Monte Carlo sono su DD STATICO e che col trailing
           "quei numeri non valgono", e che il calcolo col trailing NON E' MAI
           STATO FATTO. Aggiungere la modalita' al Guardian NON risponde a
           quella domanda: la rende solo misurabile.
```
**La proposta gemella, che vale di piu':** rifare la Monte Carlo del
portafoglio con **DD trailing EOD** sulle serie per-trade che abbiamo gia'
(R16). **Costa zero dati nuovi** ed e' l'unica cosa che dice se possiamo
guardare una prop 1-Step. Oggi la risposta e' scritta: **"NON LO SAPPIAMO"**.

---

## P8 · 🎲 La RANDOMIZZAZIONE degli ingressi — la piu' facile da sbagliare

```
PROPOSTA   NON FARLA ORA. Registrarla e basta.
DOVE       -
FONTE      Gold Phantom (Randomization=50, acceso SOLO nel preset propfirm),
           Gold Reaper (Randomization, 0 nel suo set), Gold Atlas ("built-in
           randomizer"), Prop Firm Pass (InpBuy/SellEntryRandomPoints),
           Prop Firm Gold EA ("trade randomizer for unique entries")
           + FTMO: cap $400.000 per trader O PER STRATEGIA
           + E8: "una strategia per utente", strategie identiche -> terminazione
COSTO      -
RISCHIO    -
```
**Perche' la scrivo comunque:** **cinque prodotti su sette** hanno un input di
randomizzazione, e uno lo accende **solo** nel preset prop. Serve a non far
sembrare due conti la stessa strategia. **Per noi oggi non serve** — i nostri
EA sono nostri e girerebbero su un conto solo. Ma diventa rilevante nel
momento esatto in cui si pensasse a **due prop insieme**, ed e' meglio saperlo
prima che dopo. Nel frattempo la domanda giusta e' un'altra e sta gia' in
`DOMANDE_SUPPORTO_PROP.md`: **la stessa flotta su due conti nostri, per un
regolamento, e' "copy trading"?**

---

## P9 · 🌍 L'AUTO-GMT — l'unica proposta che riguarda gli EA, non il Guardian

```
PROPOSTA   Un helper condiviso che rileva l'offset GMT del server e converte
           gli orari di sessione, invece di cablarli in ora server:
             input bool InpAutoGMT       = false;  // spento di default!
             input int  InpGMTWinter     = 2;
             input int  InpGMTSummer     = 3;
             input int  InpSessionHourUTC;         // l'ora VERA, in UTC
DOVE       nuovo mql5/Include/ABTG_TimeZone.mqh
FONTE      Gold Phantom: AutoGMT=true, Broker_GMT_OFFSET_Winter=2,
           Broker_GMT_OFFSET_Summer=3 -- acceso anche in backtest (AutoGMT_Backtest)
COSTO      ~4 ore + una riverifica di OGNI EA che ha un orario.
RISCHIO    🔴🔴 QUESTA E' LA PIU' PERICOLOSA DI TUTTE. Tocca `InpSessionHour`,
           cioe' il parametro su cui il progetto ha gia' sbagliato piu' volte
           (regola di casa: "colonna InpSessionHour deve essere 8 sul DAX; se
           e' 9 -> cestinare"). Un bug qui non rompe un EA: rende SPAZZATURA
           ogni backtest e ogni forward. Se si fa, si fa con l'input SPENTO di
           default e un round di verifica dedicato, non "già che ci siamo".
```
**Perche' e' in lista lo stesso:** `METRO_PROP.md` §11 dice che
PepperstoneUK-Demo e' **a UTC+0, un'ora dietro BCM**, e che i nostri orari sono
tutti cablati in ora server BCM. **Il giorno in cui si apre una challenge, il
server e' quello della prop, non BCM.** O si rimappa a mano ogni `.set` (e si
sbaglia), o esiste questo helper. **Non e' urgente oggi. Lo diventa il giorno
dell'acquisto**, ed e' meglio averlo scritto prima.

---

## 🚫 QUELLO CHE HO DECISO DI **NON** PROPORRE (e perche')

1. **Riduzione automatica del rischio avvicinandosi al muro** (era nella mia
   lista della spesa iniziale). **Nessuno dei 7 prodotti letti la implementa.**
   Tutti fanno la cosa opposta: soglia fissa, e quando la tocchi ti fermi.
   Proporla sarebbe inventarmi che "si fa cosi'". **Non si fa cosi'.**
2. **Chiusura programmata del venerdi'.** Ce l'hanno KT e Bneu — ma **entrambi
   i preset prop letti hanno `FridayStopHour=25`, cioe' DISABILITATA**. E le
   regole weekend cambiano per prodotto (FundingPips Zero = hard breach,
   FTMO Swing = permesso). Senza sapere QUALE prop, e' una modifica a vuoto.
3. **Notifiche Telegram/push, log CSV, pannelli.** Utili, non urgenti, e non
   cambiano il rischio di una riga.
4. **Qualunque acquisto.** Ogni meccanismo qui sopra e' codice che sappiamo
   scrivere. I 7 prodotti sono serviti a sapere **cosa** scrivere.

---

## 🧭 SE SI PUO' FARE UNA COSA SOLA

**P2, il buffer.** Un'ora di lavoro, due input, e cambia il Guardian da
_"registra la violazione"_ a _"la evita"_. E' l'unico punto del dossier dove
tre vendor indipendenti hanno scritto **lo stesso numero** (4 e 9) e noi
abbiamo scritto quello sbagliato (5 e 10).

**Se se ne possono fare due:** P2 + P1 (5 minuti, stesso file preset).

**La cosa a costo zero che non e' codice:** mandare le domande gia' pronte in
`report/DOMANDE_SUPPORTO_PROP.md`. Tutto il §2 di questo dossier e'
**[LETTO-VIA-SEARCH]**, non [VERIFICATO], perche' i siti delle prop sono
bloccati. Una risposta scritta vale piu' di dieci ricerche.
