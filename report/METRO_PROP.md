# 📏 IL METRO PROP — le 12 domande, e il NOSTRO numero accanto a ognuna

_Scritto il 15/08/2026. Nasce da un link mandato da Claudio
(`axiconnect.online/it-ch/blog/education/proprietary-trading-firms`) che
**non ho potuto leggere**: il proxy dell'ambiente lo blocca, come blocca
Dukascopy. Invece di indovinare cosa c'e' scritto, ho scritto il metro._

**A cosa serve.** Ogni volta che arriva una prop nuova, invece di rileggere
tutto da capo si passa questa lista. Ogni domanda ha gia' **il nostro numero**
accanto, cosi' la risposta non e' "sembra buona" ma **"passiamo" / "non
passiamo" / "non lo sappiamo ancora"**.

**Regola D3, che vale sopra tutto:** _niente acquisti prima delle risposte
**per iscritto** dal supporto._ Il marketing non e' il regolamento. Su
Upcomers la pubblicita' diceva target **5%** e le recensioni **8-10%**.

---

## 🔴 LE TRE CHE DA SOLE POSSONO CHIUDERE IL DISCORSO

### 1. Il drawdown massimo e' **TRAILING** o **STATICO dal deposito**?

**Il nostro numero:** tutte le Monte Carlo del portafoglio sono su **DD
STATICO**: p50 **5,74%** · p95 **9,89%** · p99 **12,47%** su 27 serie a
rischio 1%, che a taglia 0,65% diventa **~8,1%**.

⚠️ Con un DD **trailing sull'equity** quei numeri **non valgono**. La domanda
cambia da "quanto ho perso dal deposito" a "quanto ho restituito dal picco", e
per una curva che sale a scalini come la nostra il secondo e' sempre peggiore.

**Verdetto onesto: NON LO SAPPIAMO.** Non perche' sia difficile — perche'
**non l'abbiamo mai calcolato**. Finche' quel numero non c'e', comprare una
challenge col trailing e' comprare un biglietto per una gara di cui non
conosciamo il percorso.

### 1-bis. 🧱 DOVE STA IL MURO, e quanto spesso lo tocchiamo

_Domanda di Claudio, 15/08: "se non riesco a tornare positivo, su una prop da
100k quando sarei buttato fuori? Tipo 80k?"_

**No: molto prima. A 90.000.** Il margine e' **10.000 €**, non 20.000.

| muro | soglia tipica | su 100k |
|---|---|---|
| **DD massimo totale** | 10% | 🧱 **90.000** |
| **DD giornaliero** | 5% | 🧱 **−5.000 in un solo giorno** |

⚠️ **Il secondo butta fuori anche col primo intatto**: chiudere una giornata a
94.900 partendo da 100.000 e' fuori, pur essendo **sopra** i 90.000.

#### Quanto e' vicino, in R

A rischio **0,65%** su 100k, **1R = 650 €**:

| | distanza | in R |
|---|---:|---:|
| pavimento totale (90.000) | 10.000 € | **~15,4 R** |
| cap giornaliero (5%) | 5.000 € | **~7,7 R in un giorno** |

La nostra peggior giornata misurata (R51) e' **−2,06%**, cioe' **~3,2 R**:
**due giornate come quella di fila sono gia' meta' del cap giornaliero.**

#### 🎯 Ma la domanda vera e' un'altra: **quanto spesso lo tocchiamo**

| rischio per trade | p99 del drawdown | contro il muro del 10% |
|---|---:|---|
| **1%** | **12,47%** | 🔴 lo **sfonda** in **piu'** dell'1% dei casi |
| **0,65%** | **~8,1%** | 🟢 lo sfonda in **meno** dell'1% dei casi |

> **E' QUESTO il motivo per cui giriamo a 0,65% e non a 1%.** Non e' prudenza
> generica: a 1% la Monte Carlo dice che il muro lo tocchiamo piu' di una
> volta su cento, a 0,65% no. La taratura del rischio non e' un'opinione, e'
> la distanza fra quei due numeri.

#### E col DD TRAILING il muro si muove

Il margine non e' "quanto sto sopra 90.000": e' **"quanto sto sopra il picco
meno il 10%"**.

| | picco | muro | margine |
|---|---:|---:|---:|
| parti | 100.000 | 90.000 | 10.000 |
| sali a 105.000 | 105.000 | 95.000 | — |
| torni a 96.000 | 105.000 | 95.000 | **1.000** |

Sei **sotto** il capitale iniziale di appena 4.000 € e ti restano **1.000 €**,
non 6.000. **E' lo scenario che fa fuori mentre si pensa di stare comodi**, ed
e' il motivo per cui la domanda "il trailing si blocca al breakeven?" (§9)
vale piu' di tutte le altre.

> ⚠️ 10% e 5% sono lo **standard**, non una legge: ogni prop le scrive a modo
> suo (8%, 12%, daily 4%...). Vale la **regola D3**: si confermano per
> iscritto prima di comprare.

### 2. Il cap di perdita **GIORNALIERA** quant'e'?

**Il nostro numero:** R51 ha misurato la peggior giornata del portafoglio a
**−2,06%** (era −1,07% prima del cambio, e il round l'ha **raddoppiata**).

- cap **5%** → 🟢 larghi
- cap **4%** → 🟡 due giornate storte di fila e ci siamo
- cap **3% o meno** → 🔴 il nostro peggior giorno misurato ne mangia i due terzi

### 3. Le posizioni **overnight** e nel **weekend** sono ammesse?

**Il nostro numero:** `ABTG_MaxMinNotte` lavora sul box **23:00–04:59**,
`ABTG_Nightly` su **22:00–04:59**, la variante oro su **22:00–06:00**.

🚨 **Se l'overnight e' vietato, tre EA della flotta sono fuori dal giorno
uno.** Non "vanno adattati": sono strategie il cui setup vive di notte. E' la
domanda che quasi nessuno fa prima di comprare.

---

## 🟡 LE QUATTRO CHE CI RIGUARDANO IN MODO SPECIFICO

### 4. Il cap di rischio **per trade** somma le posizioni aperte insieme?

**Il nostro numero:** giriamo a **0,65%**, quindi sotto qualunque cap
ragionevole. **Ma** il 29/07 due EA hanno aperto **lo stesso segnale nello
stesso secondo** (`CENSIMENTO_ORDINI_PC.md` §3). Se il cap somma le posizioni
correlate — come fa Funding Pips entro 10 minuti — quel secondo diventa una
violazione.

### 5. Gli **EA** sono ammessi? E far girare lo **stesso EA su due conti**?

**Il nostro numero:** oggi la stessa flotta gira su **50503392** (piccolo) e
**50504263** (100k). Per noi e' un solo sistema su due conti nostri; per un
regolamento puo' chiamarsi **"copy trading"**, che spesso e' vietato.
**Da chiarire per iscritto**, con queste parole esatte.

### 6. C'e' una **consistency rule** / "best day rule"?

**Il nostro numero:** 27 serie con code Monte Carlo vuol dire che **una
giornata grossa e' statisticamente attesa**, non un'anomalia. Una regola che
nega il payout quando un giorno pesa troppo colpisce esattamente la forma
della nostra curva.

### 7. Il **news trading** e' limitato?

**Il nostro numero:** `ABTG_DAX_Apertura_EU` entra **alle 08:00 server in
punto**, alla campanella. Molte prop vietano di operare **±2 minuti** attorno
alle news ad alto impatto. Le aperture di borsa non sono "news", ma i
comunicati tedeschi delle 08:00 lo sono. **Da chiarire.**

---

## 🟢 LE CINQUE DI CONTORNO (contano, ma non chiudono)

### 8. Profit target, numero di fasi, giorni minimi e massimi
### 9. 💧 Payout: la LINEA DI GALLEGGIAMENTO (high water mark)

_Domanda di Claudio, 15/08: "se perdo 1000 in un giorno e il giorno dopo ne
guadagno 500, per portare soldi a casa devo comunque superare i 100k?"_

**Si'.** Il payout si calcola sul **profitto netto rispetto al saldo
iniziale**, non sul guadagno dell'ultima giornata.

| giorno | operazione | saldo | ritirabile |
|---|---|---:|---|
| parti | — | **100.000** | 0 |
| 1 | −1.000 | 99.000 | **0** |
| 2 | +500 | **99.500** | **0** |

Servono **altri +500 solo per tornare a pari**. Da 100.000 in su e' ritirabile
l'eccedenza, secondo lo split.

> **Il conto ha una linea di galleggiamento a 100.000. Sotto quella linea si
> lavora per recuperare, non per guadagnare.**

#### E il DD trailing la rende peggiore

Se il drawdown e' trailing (§1), quel −1.000 non fa solo perdere terreno sul
profitto: **il pavimento ti segue e non riscende.**

| | picco | pavimento (DD 10%) |
|---|---:|---:|
| parti | 100.000 | 90.000 |
| sali a 105.000 | 105.000 | **95.000** ⬆️ |
| scendi a 99.000 | 105.000 | **95.000** (resta su) |

**Da chiedere per iscritto: il trailing si BLOCCA al breakeven?** Cioe',
arrivato a 100.000 si ferma li'? E' una clausola **buona**, e cambia molto.

#### 📐 La conseguenza, coi nostri numeri

> **In una prop il drawdown conta piu' del rendimento**, perche' una perdita
> costa **due volte**: il denaro, e il tempo per recuperarlo prima di poter
> ritirare qualcosa.

500 € su 100k e' lo **0,5%**. Il DAX Apertura ha aspettativa **+0,075R** per
trade e a rischio 0,65% un R vale 650 €, cioe' circa **49 € al giorno**:
servono **~10 giorni di operativita' solo per tornare a pari**. Col
portafoglio intero e' piu' veloce, ma il principio non cambia.

E' anche il motivo per cui giriamo a **0,65% e non a 1%**: la Monte Carlo
dice p99 **12,47%** a rischio 1% e **~8,1%** a 0,65%.

#### Le altre caselle del payout, da spuntare

- **frequenza** del ciclo (14 giorni? 30?)
- **tetto del primo prelievo** (su Upcomers le recensioni dicevano $500)
- **split** (80%? 90%?) — e ricorda: _lo split e' l'ultima cosa che conta se
  il payout viene negato_
- **tempi reali** di accredito, non quelli dichiarati

### 10. Costo, e cosa dice il **modello di business**

> Upcomers vendeva un 100k a **$115,90 invece di $1.159**. Non e' un affare da
> valutare: e' un'informazione. Chi vende a un decimo del listino guadagna
> sulla **vendita delle challenge**, non sui payout — e questo fa pesare di
> piu' ogni regola soggettiva.

### 11. 🕐 Su che **broker e server** gira? Che **fuso** ha? Come si chiamano i simboli?

**Domanda nuova, aggiunta oggi con le cicatrici fresche.** Tutti i nostri EA
hanno gli orari in **ORA SERVER**: DAX `InpSessionHour=8`, apertura USA 14:30,
box notturno 23:00. Su BCM la regola e' "ora italiana − 1".

Oggi abbiamo misurato che **PepperstoneUK-Demo e' a UTC+0**, cioe' **un'ora
piu' indietro di BCM**. Se il server della prop ha un offset diverso e non lo
si rimappa, **l'EA opera a un'ora che non c'entra niente con l'apertura di
borsa** — e ogni verdetto e' spazzatura.

E i **nomi dei simboli** cambiano: il DAX e' `D30EUR` su BCM e **`GER40`** su
Pepperstone; il Dow `U30USD` contro **`US30`**. Un `.set` copiato senza
rimappare non parte, o peggio parte sul simbolo sbagliato.

### 12. 💰 La **taglia** del conto (e perche' conta meno di quanto sembra)

**Primo fatto, contro-intuitivo: la taglia NON cambia la probabilita' di
passare.** Le regole sono tutte in percentuale, e le nostre percentuali sono
identiche su 100k e su 1,5M. Se passiamo, passiamo a tutte le taglie.

**Secondo fatto, che invece cambia le cose in natura:** a 1,5M il rischio per
trade a 0,65% e' **9.750 EUR**, cioe' **177 lotti sul DAX** in un colpo solo,
alle 08:00 in punto. Li' lo slippage non e' un dettaglio: l'aspettativa del
DAX Apertura e' **+0,075R**, e **1 punto indice di slippage se ne mangia il
24%**.

---

## 🧭 Come si usa questa scheda

1. Si scaricano le **risposte scritte** del supporto sulle domande 1-7.
2. Si compila una scheda `report/SCHEDA_PROP_<nome>.md` come quella di
   Upcomers, con le fonti e la data.
3. **Se la 1 dice "trailing", prima si fa la Monte Carlo col DD trailing** —
   e solo dopo si decide. E' un calcolo su dati che abbiamo gia', costa zero, e
   serve per **qualunque** prop moderna, perche' il trailing e' lo standard.

> ### 🛑 E la regola madre, sopra tutte
> **Prop pagata solo dopo forward maturo.** D3 e' in pausa per decisione di
> Claudio del 13/08. E il 15/08 abbiamo scoperto che il forward era
> **contaminato** dai 33 trade del PC fantasma: **il forward pulito comincia
> adesso, non due settimane fa.** La settimana di dati su cui volevamo
> decidere non esiste ancora.

---

# 13. 🕸️ GRIGLIA / AVERAGING / MARTINGALA — la voce che mancava

> 🟡 **STATO: BOZZA DA FIRMARE.** Scritta il **21/08/2026** dall'architetto-prop
> per chiudere il buco **M14** di `report/PIANO_PROP.md:227`. **Non e' congelata,
> non autorizza niente, non e' applicata da nessuna parte.** Diventa metro solo
> con la parola di Claudio (data + firma, come le altre).
>
> 📏 **Perche' esiste, e perche' esiste ADESSO:** regola di casa — **il metro si
> scrive PRIMA dei numeri**. Se un giorno una griglia entra nell'imbuto, i
> criteri devono essere gia' scritti, altrimenti si finisce a scegliere la
> soglia dopo aver visto il risultato. Oggi il candidato in vista e' uno solo
> (la Mediazione del corso, `ANALISI_CORSO_MEDIAZIONE_2026-08-18.md`), **e non
> ha ancora un EA**: e' il momento migliore per scrivere il metro, perche'
> nessun numero puo' influenzarlo.
>
> **La domanda a cui risponde, una sola:** _a quali condizioni una griglia a cap
> fisso e' **MISURABILE** col nostro imbuto, e a quali e' **AMMESSA** da una
> prop?_ Sono due domande diverse e si rispondono separatamente: **una griglia
> puo' essere perfettamente misurabile da noi e comunque vietata da contratto.**

---

## 13.1 🔬 La distinzione tecnica — il criterio che separa, non le parole

"Martingala" e' un'etichetta che il marketing usa per negare e il setaccio usa
per scartare. Nessuna delle due serve. **Servono domande a risposta binaria,
verificabili sul CODICE o sulla SPECIFICA** (non sulla descrizione del vendor,
che vale zero: `CONFIG_PROP_2026-08-18.md` §1D — su 7 EA venduti come
"prop-ready", 2 sono recovery/griglia dichiarati o indiziati e per 3 non si sa).

### I cinque test, in ordine

| # | test | come si verifica |
|---|---|---|
| **T1** | 🛑 **Esiste UN prezzo, DEPOSITATO AL BROKER su ogni singolo ticket, oltre il quale il pacchetto e' morto?** | si legge il campo `sl` di ogni ordine inviato. Non vale lo "stop mentale", non vale la chiusura via `OnTick`: se l'EA muore o cade la connessione, quel prezzo deve restare al broker |
| **T2** | 🔢 **Il numero massimo di ingressi e' una COSTANTE dichiarata, non una funzione di mercato/margine/equity?** | si legge il cap nel codice. `MaxTrades=10` **e' una costante**; "finche' il margine regge" **non lo e'** |
| **T3** | 📐 **La perdita massima e' calcolabile PRIMA del primo ingresso**, e non dipende da quanti livelli si riempiranno? | si calcola a mano: somma dei volumi × distanza dal proprio SL. Se il numero non esce prima di entrare, il test e' fallito |
| **T4** | 🔁 **La serie si riarma sulle PERDITE PRECEDENTI (di altri pacchetti), o solo sul movimento del pacchetto corrente?** | si cerca nel codice una variabile che porti la perdita passata dentro il sizing futuro (`lastLoss`, `recoveryFactor`, `lot *= exp` dopo uno stop) |
| **T5** | 📦 **La size cresce ANDANDO VERSO lo stop?** | si calcola il rapporto **ticket piu' grande / ticket piu' piccolo** dello STESSO pacchetto e il **multiplo totale** rispetto al primo ingresso |

### Le tre famiglie, separate dai test

| famiglia | T1 stop al broker | T2 cap costante | T3 perdita nota prima | T4 si riarma sulle perdite | esito |
|---|---|---|---|---|---|
| **Martingala pura** | ❌ no (o SL fittizio) | ❌ no | ❌ no | ✅ si' | 🔴 **SCARTO A VISTA** |
| **Recovery / zone / lock senza stop** | ❌ no | 🟡 a volte | ❌ no | ✅ si' | 🔴 **SCARTO A VISTA** |
| **Averaging a CAP FISSO con stop unico** | ✅ si' | ✅ si' | ✅ si' | ❌ no | 🟡 **MISURABILE — ma solo alle condizioni G1-G6** |

> ⚖️ **LA REGOLA:** **fallito anche UNO fra T1, T2, T3 → scarto a vista, non si
> misura.** Non e' prudenza: e' che senza T3 non esiste il numero da mettere
> accanto a "perdita massima", e un imbuto che non sa cosa perde non e' un
> imbuto. **T4 = si' → scarto a vista** anche se T1-T3 passano: una serie che si
> riarma sulle perdite precedenti non ha unita' di misura (ogni pacchetto
> dipende dal precedente, e il campione non e' fatto di eventi confrontabili).
>
> 🥇 **Precedente misurato in casa:** `Mean_Reversion` (AHARON TZADIK) e' stato
> scartato il 16/08 **proprio su T4** — `LotExponent 1.44` + `Max_Trades 10`: il
> cap c'era (T2 ok) ma la martingala si riarmava sulle perdite precedenti
> (`ANALISI_CORSO_MEDIAZIONE_2026-08-18.md` §1.7). **T2 da solo non salva
> niente.**

> 🚩 **T5 non scarta, ma OBBLIGA A DICHIARARE.** Se la size cresce verso lo stop,
> nel referto vanno scritti due numeri, sempre: **rapporto max/min dentro il
> pacchetto** e **multiplo totale**. Esempio della Mediazione del corso
> (progressione geometrica ×1,5 su 6 livelli): **7,59×** fra l'ultimo e il primo
> ticket, **20,78×** di volume totale — e la posizione **piu' grande** e' quella
> **piu' vicina** allo stop. E' anche il numero che una prop legge (§13.5).

---

## 13.2 📦 Cosa si conta: **il PACCHETTO, non il TICKET** (regola G2)

> 🔴 **REGOLA PROPOSTA — G2:** _per qualunque motore a griglia, **l'unita' di
> misura dell'imbuto e' il PACCHETTO**. Tutti i conteggi dell'Emendamento della
> finestra (>=150 in IS, >=150 in OOS), la frequenza, il win rate, le perdite
> consecutive e l'aspettativa per operazione si calcolano **sui pacchetti**.
> Un referto che conta ticket e' **nullo**, non "ottimista"._

**Definizione operativa di pacchetto:** l'insieme degli ingressi generati da
**UN solo segnale**, che condividono **un solo SL** e **un solo TP**, e che
nascono e muoiono insieme. Un pacchetto della Mediazione = **fino a 6 ticket**.

### 🧮 Perche' e' una regola e non un dettaglio — l'esempio numerico

`[I]` aritmetica nostra, distribuzione **ipotetica ma tipica** della forma di
pagamento di una griglia (i vincenti chiudono presto = pochi livelli riempiti;
i perdenti riempiono tutto e poi muoiono contro il muro):

- **100 pacchetti**, win rate reale **70%**
- i 70 vincenti riempiono in media **3** livelli → **210 ticket vincenti**
- i 30 perdenti riempiono **tutti e 6** i livelli → **180 ticket perdenti**

| metrica | contata a **PACCHETTI** (giusta) | contata a **TICKET** (quello che MT5 stampa) | scarto |
|---|---:|---:|---|
| **n operazioni** | **100** | **390** | ×3,9 — 🔴 sotto il muro dei 150 diventa "sopra" |
| **win rate** | **70,0%** | **53,8%** | −16 punti |
| **aspettativa per operazione** | X | **X / 3,9** | ÷3,9 |
| **perdite consecutive max** (`STAT_MAX_CONLOSSES`) | 1 pacchetto | **6** | ×6 |
| profit factor | PF | **PF identico** | ✅ invariante |
| profitto netto, max DD | uguali | **uguali** | ✅ invarianti |

> 🎯 **Il punto che rende la regola necessaria:** i due errori vanno in
> **direzioni opposte** — il campione si gonfia (e fa passare il cancello dei
> 150 quando non dovrebbe) mentre il win rate si sgonfia (e fa sembrare piu'
> fragile un motore che magari e' proprio quello). **Non e' un errore
> conservativo: e' un errore disorientante.**
> ✅ **PF, profitto netto e max DD NON cambiano** (sono somme, non conteggi):
> sono le uniche tre righe di un report MT5 che si possono leggere cosi' come
> sono. **Tutto cio' che ha un "per trade" dentro va rifatto.**

### 🔧 Come si ricostruisce un pacchetto con quello che abbiamo OGGI

Il nostro export per-trade (`ExportTrades()`, presente in tutti gli EA di casa —
p.es. `mql5/Experts/ABTG_PTE.mq5:569`) scrive:
`close_time; symbol; magic; position_id; deal_type; volume; price; net_profit`.

- ✅ **Si puo' fare gia' adesso**, perche' un pacchetto ha **UN solo SL e UN solo
  TP**: tutti i suoi ticket **chiudono nello stesso istante**. Regola meccanica:
  **stesso `symbol` + stesso `magic` + `close_time` IDENTICO = un pacchetto**; il
  **numero di righe del gruppo = i livelli riempiti** (che e' anche la
  distribuzione chiesta dal §13.3, gratis).
- ⚠️ **Due caveat da scrivere nel referto**, non da nascondere: (a) se la
  strategia ammette una **chiusura anticipata a mercato** (nella Mediazione e'
  l'ambiguita' n.8 del corso, `MEDIAZIONE_CORSO_SPEC.md` §11.1) il gruppo chiude
  comunque tutto insieme e la regola regge; (b) due pacchetti **diversi** dello
  stesso simbolo che chiudessero nello stesso secondo verrebbero fusi — evento
  raro ma non impossibile.
- 🕳️ **Il debito, gia' agli atti:** `ExportTrades()` **non esporta `open_time`**
  (lacuna gia' registrata in M2 di `PIANO_PROP.md`). **Richiesta:** aggiungere
  `open_time` **e** un `package_id` (l'ora della candela di segnale). Con quei
  due campi la ricostruzione diventa esatta invece che inferita, e serve **anche
  al calcolo del rischio aperto**. → richiesta a **mql5-ea-developer**, §13.5.

---

## 13.3 🐍 La CODA, non la media — cosa si guarda oltre PF e max DD

Una griglia col cap ha una perdita massima **nota** ma **rara**: il payoff e'
"tante briciole + una perdita piena ogni tanto". Un **PF 1,1 su 200 pacchetti
puo' nascondere 3 stop pieni che valgono l'anno**. Media e massimo non bastano:
**serve la distribuzione**.

> 🔴 **REGOLA PROPOSTA — G3: la scheda della coda.** Nessun round su un motore a
> griglia si chiude senza queste **sei** misure, calcolate **per pacchetto**, in
> **IS e OOS separatamente**:

| # | misura | come si legge |
|---|---|---|
| **G3.1** | **Istogramma dei livelli riempiti** (1,2,…,cap) + **% di pacchetti che arrivano al livello massimo** | e' la forma vera del motore. Se i pacchetti pieni sono **< 5% del campione**, il ramo di coda e' **sotto-campionato**: la perdita piena non e' stimata, e' solo aritmetica |
| **G3.2** | **Peggior pacchetto misurato**, in % dell'equity, **confrontato con la perdita massima TEORICA** | se il misurato **supera** il teorico → gap/slippage oltre lo stop: si quantifica lo scarto e si scrive. E' l'unico modo per beccare la coda a sinistra (tutti i ticket muoiono allo stesso prezzo: un gap li prende **tutti insieme**) |
| **G3.3** | **p95 e p99 della perdita per pacchetto** | non il massimo: il massimo e' un evento, il p99 e' un'abitudine |
| **G3.4** | **Massimo numero di pacchetti perdenti CONSECUTIVI** (contati per pacchetto, mai per ticket) | si moltiplica per la perdita piena e si confronta col muro: e' il numero che decide se la challenge muore |
| **G3.5** | **Indice di coda** = somma dei **3 peggiori pacchetti** / profitto netto della finestra | se **>= 1**, l'anno vive di tre eventi: giudizio di merito **sospeso** salvo n molto grande |
| **G3.6** | **Quante volte il pacchetto e' arrivato al livello massimo E POI ha fatto TP** | e' il ramo che paga di piu' — e su una griglia col cap e' anche quello che passa **piu' vicino** allo stop (nella Mediazione: si incassa il massimo **a 35 pip dal disastro**, `ANALISI_CORSO_MEDIAZIONE_2026-08-18.md` §1.4). Se questo ramo e' l'unico che fa profitto, il motore e' una scommessa sulla coda destra |

### 🧱 Il conto che serve davvero: quanti pacchetti pieni di fila uccidono il conto

`[I]` aritmetica nostra, muri standard su 100k (`METRO_PROP` §1-bis):

| perdita per pacchetto | muro **giornaliero 5%** | emergenza Guardian **4,9%** (B1, congelata) | muro **totale 10%** |
|---|---:|---:|---:|
| **0,65%** (= la nostra taglia A1, congelata) | 7,7 pacchetti | 7,5 | **15,4** |
| **1,00%** (il rischio "base" dichiarato dal corso) | 5,0 | 4,9 | **10,0** |
| **1,76%** (perdita piena dell'esempio GBPUSD del corso) | 2,8 | 2,8 | **5,7** |
| 🔴 **4,03%** (lo stesso pacchetto **se il fattore 2,29 e' reale**) | **1,2** | **1,2** | **2,5** |

> 🚨 **Si legge cosi': a 4,03% per pacchetto, UN SOLO pacchetto pieno consuma
> l'81% del muro giornaliero, e TRE di fila chiudono la challenge.** A 0,65% ne
> servono 15. **La differenza fra "misurabile" e "bomba" non e' la strategia:
> e' la taglia** — ed e' esattamente il motivo per cui la condizione n.1
> dell'analisi del 18/08 (sciogliere il fattore 2,29) viene **prima** di
> qualunque backtest.

---

## 13.4 💧 Il FLOTTANTE contro il muro giornaliero — e come si misura sul NOSTRO impianto

**E' il modo tipico in cui una griglia uccide una challenge**, e non ha niente a
che fare col profitto: il muro giornaliero delle prop si misura sull'**equity,
flottante incluso**, non sul saldo di fine giornata.

🥈 Le fonti, con etichetta ([LETTO-VIA-SEARCH 18/08], `CONFIG_PROP_2026-08-18.md`
§2A-2G — nessuna riga verificata sul sito ufficiale, vedi §13.5):
- **FTMO**: daily 5% su **equity**, _"include flottante + commissioni + swap"_;
- **FundingPips**: 5% del **piu' alto fra saldo ed equity** di apertura, _"include il flottante"_;
- **The5ers**: 5% da **equity O saldo** di chiusura del giorno prima;
- **Alpha Capital**: daily 3-5% **sull'equity**.

### 📐 Perche' una griglia e' il caso peggiore per quel muro

`[I]` aritmetica nostra sulla geometria della Mediazione (`MEDIAZIONE_CORSO_SPEC.md`
§5.2: livelli a passo `P/2`, SL a `3P`, volumi `1,5^k`):

- quando **si riempie l'ultimo livello**, il pacchetto ha gia' in **FLOTTANTE il
  58,7% della sua perdita massima** — e non ha ancora perso niente "sul saldo";
- il restante **41,3%** si consuma negli **ultimi `0,5P`** (su GBPUSD, `P=70`:
  **35 pip**);
- perche' li' la posizione pesa **20,78 volte** l'ingresso iniziale: **la
  velocita' di perdita a griglia piena e' venti volte quella del primo ticket.**

> 🔴 **Conseguenza:** il danno al muro giornaliero e' **quasi tutto flottante,
> arriva in fondo alla corsa, e arriva veloce.** Un report che guarda il saldo di
> fine giornata **non lo vede**. E se il pacchetto sta aperto a cavallo del reset
> giornaliero, il flottante **si porta dietro** nella finestra prop successiva.

### 🔧 Cosa abbiamo GIA' in casa (e va usato, non reinventato)

🥇 **`gWorstDayPct` esiste ed e' gia' giusto nel principio**: in tutti gli EA di
casa (`ABTG_PTE.mq5:192-208` e gemelli) `OnTick` campiona
`AccountInfoDouble(ACCOUNT_EQUITY)` **a ogni tick**, tiene il **minimo di
giornata** contro l'equity di apertura e lo pubblica come colonna
**"Peggior Giornata %"** nel CSV di ogni round. **E' equity, non saldo: il
flottante e' gia' contato.** Il commento nel codice dice perche' sta li' e non
dopo il filtro di nuova barra: _"su H4 una candela dura quattro ore, e la caduta
peggiore di giornata succede in mezzo"_.

### 🕳️ E cosa MANCA (tre buchi, tutti chiudibili, nessuno mio)

| # | buco | perche' morde su una griglia | chi lo porta |
|---|---|---|---|
| **1** | `gWorstDayPct` tiene **un solo numero** (il minimo dell'intera corsa), non la **distribuzione** | su una griglia serve sapere **quanti giorni-prop** hanno superato la soglia, non solo il peggiore. **Richiesta: export CSV per GIORNO** (`giorno_prop; equity_apertura; equity_minima; dd_pct; pacchetti_aperti`) | **mql5-ea-developer** |
| **2** | il giorno si azzera su `day_of_year` = **mezzanotte del server BCM**, ma il reset FTMO e' **00:00 CE(S)T = 23:00 ora server BCM** (regola di casa: **BCM = ora italiana − 1**, misurata il 18/08 con lo screenshot Market Watch 19:35 / Windows 20:35) | la finestra giornaliera misurata e' **sfasata di un'ora** rispetto a quella vera: una caduta fra le 23:00 e le 00:00 BCM finisce nel **giorno prop sbagliato**. E' lo stesso difetto gia' corretto sul Guardian con `InpDailyResetHour=23` (**B3, congelata 18/08**) | **mql5-ea-developer** (input `InpPropResetHour`, default 23) |
| **3** | `dd_portafoglio.py` costruisce la serie giornaliera **dal `close_time`** dei trade chiusi | il flottante di un pacchetto aperto **su piu' giorni** e' invisibile: tutta la perdita atterra sul giorno di chiusura. Il rimescolo Monte Carlo (che shuffla i **giorni**, conservando la correlazione same-day) resta valido **solo se** la serie giornaliera e' costruita sull'**equity**, non sui trade chiusi | **PC backtest** — dipende dal buco 1 |

### 🧱 E il buco che tocca il GUARDIAN (da segnalare, non da correggere qui)

🥇 `ABTG_Guardian.mq5:153-181`, `OpenRiskPct()` cicla su **`PositionsTotal()`**:
somma gli SL **delle posizioni aperte**. **Gli ordini PENDENTI non li vede.**
Una griglia che deposita la scala di limit-order **tutta in una volta** ha un
rischio **gia' impegnato** che il cap **C1 = 3,25%** (congelato il 18/08) **non
conta finche' i livelli non si riempiono** — cioe' esattamente quando e' troppo
tardi per rifiutarli.

> 🔴 **REGOLA PROPOSTA — G4 (due righe, entrambe riusano numeri GIA' FIRMATI, non
> ne inventano di nuovi):**
> 1. **RISCHIO IMPEGNATO.** Per un motore a griglia il rischio che conta nel cap
>    C1 e' **posizioni aperte + ordini pendenti con SL dello stesso pacchetto** =
>    la perdita massima del pacchetto, **contata per intero dal primo ingresso**.
>    Finche' il Guardian non sa contarla, **una griglia non entra in nessun conto
>    dove vive il cap C1.**
> 2. **CANCELLO DEL FLOTTANTE.** Nella finestra di misura (IS **e** OOS), il
>    drawdown giornaliero su equity, calcolato **nella finestra prop** (reset
>    23:00 BCM), **non deve mai toccare 4,0%** — che e' la **soglia di pausa
>    morbida B1, gia' congelata il 18/08**. Un solo tocco = **bocciatura per
>    RISCHIO**, non discutibile: _"il campione sottile sospende il giudizio sul
>    MERITO, mai sul RISCHIO"_ (Emendamento B) — **un drawdown e' un fatto
>    accaduto, non una stima.**

🕐 **Gli orari, sempre anche in ora server BCM** (fonte: `CONFIG_PROP_2026-08-18.md`
§2H, fuso d'origine dichiarato in tabella; BCM = italiana − 1 = **UTC+1** in agosto):

| prop | reset dichiarato (fuso d'origine) | in UTC | **in ORA SERVER BCM** |
|---|---|---|---|
| FTMO | 00:00 **CE(S)T** | 22:00 | **23:00** |
| FundedNext (estate) | 00:00 **GMT+3** | 21:00 | **22:00** |
| FundingPips | 00:00 **UTC+3** | 21:00 | **22:00** |
| Alpha Capital | 00:00 **GMT+3** | 21:00 | **22:00** |
| The5ers / E8 | 00:00 "ora server" | **[INCERTO]** | **[INCERTO]** — M4 |

---

## 13.5 📜 Cosa dicono le PROP — per iscritto, con la data e il rango

> ⚠️ **Regola di casa, e vale qui piu' che altrove: nessuna riga di questa
> tabella autorizza un acquisto.** Fa fede `report/DOMANDE_SUPPORTO_PROP.md` e la
> **risposta scritta** del supporto (regola D3). E i domini delle prop sono
> **403 dal nostro proxy** (`CONFIG_PROP_2026-08-18.md` §0): tutto quello che
> segue e' letto **di riflesso**, non sulla pagina ufficiale.

| prop | griglia/martingala vietata? | fonte esatta | rango | data | etichetta |
|---|---|---|---|---|---|
| **FundedNext** | 🚩 **SI', "GRID trading" nell'elenco delle pratiche vietate** (insieme a HFT, latency, arbitrage, tick scalping, side betting) | `ANALISI_TRASCRIZIONI_2026-08-18.md` **Scheda 4** — video _"I found the Best Prop Firm That Allows EAs"_ (Petko / EA Forex Academy) | **4° — DICHIARAZIONE SINGOLA** (un relatore, un canale, **link affiliati**) | 18/08/2026 | 🔴 **[dichiarato a voce, NON verificato]** — `help.fundednext.com` e' 403 |
| **FTMO** | 🟡 **NESSUN divieto testuale trovato** | `docs/REGOLAMENTO_FTMO_2026-08.md` (pagina Forbidden Trading Practices, citazioni raccolte): _"Grid/martingala: **NON nominati esplicitamente** nelle citazioni raccolte (ricadono in overleveraging/risk-management) — **NON TROVATO divieto testuale, da verificare sulla pagina**"_ | 🥈 (dossier con citazioni testuali) | 08/2026 | ✅ onesto: **l'assenza di divieto e' dichiarata come assenza**, non come permesso |
| **FTMO — ma due voci che mordono lo stesso** | 🚩 (1) _"overleveraging, overexposure, **one-sided bets**, or account rolling"_ · (2) _"**substantially larger or smaller position sizes compared to other trades**, or repeated trading activity that results in **higher risk per trade / cumulative exposure in specific symbols**"_ | idem, voci 7 e 8 delle Forbidden Practices | 🥈 **citazione testuale** | 08/2026 | 🔴 **La voce 8 e' quella pericolosa**: la progressione ×1,5 fa **7,59×** fra il ticket piu' grande e il piu' piccolo **dello stesso pacchetto** (T5, §13.1). E' esattamente "position sizes substantially larger compared to other trades" — **non e' un divieto di griglia, e' peggio: e' una clausola discrezionale.** Il dossier FTMO nota anche che il nostro rischio **fisso** 0,65%/trade e' "perfetto" per quella voce: una griglia geometrica la abbandona |
| **The5ers · FundingPips · E8 Markets · Alpha Capital** | ❓ **NON VERIFICABILE NEL REPO** | `CONFIG_PROP_2026-08-18.md` §2C-2F: le schede coprono muri, reset, news, EA, consistenza — **non c'e' una sola riga su grid/martingala/averaging** | — | 18/08/2026 | 🔴 **Buco dichiarato.** Non scrivo "ammessa": scrivo **non lo sappiamo** |
| _(contesto, non regola prop)_ | il "no-grid" dei **vendor** e' linguaggio di vendita | `ANALISI_TRASCRIZIONI_2026-08-18.md` §Contraddizioni: tre video giurano "no grid, no martingale", un quarto ammette _"le EA piu' popolari che vedo sono Martingale o grid style"_ | 🥉/4° | 18/08/2026 | serve solo a ricordare che **la dichiarazione del venditore non e' una fonte** |

### ➡️ Le richieste che nascono da questa tabella (non le eseguo io)

| a chi | domanda esatta |
|---|---|
| **cacciatore-config-prop** | _"aprire e datare le pagine ufficiali 'prohibited/forbidden trading practices' di **FTMO, FundedNext, The5ers, FundingPips, E8, Alpha Capital** e riportare il **testo letterale** su: grid trading · martingale · averaging down · position sizing non uniforme. Serve la CITAZIONE, non il riassunto — e l'etichetta [VERIFICATO] con la data."_ (si aggancia a **M4** di `PIANO_PROP.md`) |
| **Claudio** (quando D3 si riapre — oggi in pausa dal 13/08) | testo pronto da incollare nel file D3: _"My EA may open up to N entries on the same signal (an averaging ladder), all sharing ONE stop loss deposited with the broker on every ticket, with a fixed maximum number of entries and a maximum loss known before the first entry. Position sizes within the ladder are not identical. (1) Is this considered 'grid trading' or 'martingale' under your prohibited practices? (2) Does the non-uniform position size within a single trade idea fall under your 'substantially larger position sizes' clause? Please confirm in writing."_ |
| **mql5-ea-developer** | (a) `open_time` + `package_id` in `ExportTrades()`; (b) export **per giorno** dell'equity minima con `InpPropResetHour` (default 23 = FTMO su BCM); (c) `OpenRiskPct()` del Guardian: contare anche gli **ordini pendenti con SL** |

---

## 13.6 ⚖️ Il verdetto operativo — con questo metro, la Mediazione del corso passerebbe?

**Risposta condizionale, come dev'essere.** Fonte unica dei fatti:
`ANALISI_CORSO_MEDIAZIONE_2026-08-18.md` + `prove/MEDIAZIONE_CORSO_SPEC.md`.

### ✅ Cosa passa GIA' (e non e' poco)

| test | esito | perche' |
|---|---|---|
| **T1** stop al broker | ✅ **passa** | SL unico, **scritto su ogni singolo ticket** al momento dell'inserimento (`[T]` lez. 30, ripetuto sei volte) |
| **T2** cap costante | ✅ **passa** | **6 ingressi**, dichiarati in **tre** lezioni diverse |
| **T3** perdita nota prima | ✅ **passa** | e' calcolata **dal corso stesso** prima di entrare (1,76% nell'esempio GBPUSD) |
| **T4** riarmo sulle perdite | ✅ **passa** | ogni pacchetto e' **chiuso in se'**: non insegue le perdite dei pacchetti precedenti (e' la differenza col `Mean_Reversion` scartato il 16/08) |
| **T5** size crescente | 🚩 **non scarta, ma dichiara**: **7,59×** dentro il pacchetto, **20,78×** totale | va scritto in ogni referto **e** in ogni domanda al supporto |

> 🟡 **Quindi: sul piano della CLASSIFICAZIONE la Mediazione e' MISURABILE.** E'
> un averaging a cap fisso con stop, non una martingala pura e non un recovery.
> **Questo pero' non e' un lasciapassare: e' solo il primo cancello.**

### ❌ Cosa NON passa oggi, e perche' (in ordine di durezza)

1. 🔴 **G4.1 — il rischio impegnato contro il cap C1 (3,25%, CONGELATO il 18/08).**
   Al sizing del corso **con** il fattore 2,29 la perdita piena del pacchetto e'
   **4,03%**: **un solo pacchetto sfonda da solo il cap di portafoglio** (124% del
   budget). Anche al sizing **dichiarato** (1,76%) un pacchetto si mangia il
   **54%** del budget di rischio aperto **di tutte e 44 le sedie**; e i **due
   pacchetti simultanei che il corso stesso mostra** (1,76% + 1,00% = **2,76%**)
   ne occupano l'**85%**, lasciando **0,49%** a tutto il resto della flotta.
   **Con lo stesso fattore 2,29 quei due pacchetti valgono 6,32% = oltre il muro
   giornaliero del 5%, in un solo evento.**
   → **Non passa PERCHE'** oggi il numero vero non lo sa nessuno: e' la
   condizione n.1 dell'analisi del 18/08, e va sciolta **prima**, non dopo.
2. 🔴 **G2 — l'unita' pacchetto non e' ancora misurabile in modo esatto**:
   manca `open_time`/`package_id` nell'export. Ricostruibile per cluster di
   `close_time` (§13.2) — **ma la regola va scritta nei criteri del round PRIMA
   di lanciarlo**, altrimenti il primo CSV verra' letto a ticket e il round e'
   carta straccia.
3. 🔴 **G2 + Emendamento A — la frequenza non e' MAI stata misurata**: su H1 con
   Williams **140** (= 140 ore ≈ 6 giorni di look-back) i segnali potrebbero
   essere pochissimi. **Se non si arriva a 150 PACCHETTI in IS, il giudizio di
   MERITO e' sospeso** (e a quel punto restano solo rischio e prova di regime).
   E' la condizione n.6 del 18/08, ed e' quella che si misura **per prima e da
   sola**, prima di qualunque griglia di ottimizzazione.
4. 🟠 **G3 — la coda oggi non e' calcolabile perche' non ci sono dati**: nessun
   backtest, nessun win rate dal corso (il numero manca in una lezione che si
   chiama _"backtest della strategia"_), zero N, zero date, zero broker.
5. 🟠 **G4.2 — il cancello del flottante non e' misurabile** finche' non esiste
   l'export per-giorno con la finestra prop (§13.4, buchi 1 e 2).
6. ❓ **§13.5 — la conformita' e' NON VERIFICATA**: l'unica riga che dice "grid
   vietato" e' un **video con link affiliati** (rango 4°), e su FTMO il divieto
   testuale **non esiste** ma esiste una **clausola discrezionale** sulle size non
   uniformi che questa strategia colpisce in pieno.

### 🧭 Il verdetto, in una riga

> 🟡 **PASSA il cancello della CLASSIFICAZIONE (T1-T5) — cioe' e' lecito
> MISURARLA. NON passa oggi il cancello del RISCHIO (G4.1: il fattore 2,29 e il
> cap C1 congelato) e non e' nemmeno MISURABILE finche' non esistono l'unita'
> pacchetto nell'export e l'export giornaliero dell'equity (G2, G4.2).**
>
> **Passerebbe SE, in quest'ordine:** (1) il sizing viene **dichiarato NOSTRO**
> — perdita massima **per pacchetto** tarata sulla regola di casa A1 (**0,65%**,
> congelata), buttando via il seme del corso e con esso il fattore 2,29; (2) la
> **frequenza misurata** da' >= 150 pacchetti IS e >= 150 OOS; (3) i tre buchi
> dell'impianto (§13.4) vengono tappati **prima** del round; (4) la coda (G3)
> rispetta i cancelli e **nessun giorno-prop tocca il 4,0%** (G4.2).
> **A quel punto e' un motore come gli altri, e vale l'imbuto normale.**
>
> 🔴 **E resta il muro che nessuna misura nostra puo' abbattere:** anche con
> tutti i numeri a posto, **se la prop scelta vieta il grid per iscritto, la
> strategia non si puo' usare li'** — e oggi non sappiamo cosa vietino, perche'
> nessuno ha ancora letto le loro pagine ufficiali. **La misura e il permesso
> sono due cancelli diversi e vanno passati tutti e due.**

---

## 13.7 🛑 Cosa NON autorizza questa voce

- **non autorizza un round** sulla Mediazione (lo apre Claudio, e prima serve la
  riconciliazione dei due verdetti: `report/NODO_MEDIAZIONE_2026-08-21.md`);
- **non autorizza un EA** (non e' il mio mestiere e non c'e' ancora);
- **non tocca il forward**, nessun preset, nessun input;
- **non dichiara ammessa nessuna prop**: finche' non c'e' la risposta scritta,
  vale la regola D3.
