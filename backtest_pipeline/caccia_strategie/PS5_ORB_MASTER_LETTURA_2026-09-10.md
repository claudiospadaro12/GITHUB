# 📄 PS5 ORB BOT — DOCUMENTO MASTER DEL COLLEGA: lettura critica

**Fonte**: `PS5_MASTER.pdf` — *"PS5 ORB Bot, Documento Master"*, **Marco Garbuglia,
10/08/2026, EA v2.60**. Dichiara: 4 documenti di ricerca (21-27 luglio), **11 M di
tick**, **46 backtest coarse**, **forward FTMO reale**. Condiviso da Claudio il
10/09/2026.

> ⚠️ **Tutto quello che segue e' DICHIARATO DALLA FONTE, non misurato da noi.**
> Non e' un criterio di casa e non entra in nessun cancello finche' non lo
> rimisuriamo **sul nostro broker**. Etichetta: `[DICHIARATO-FONTE-ESTERNA]`.

---

# 🥇 PERCHE' QUESTO DOCUMENTO VALE — e vale davvero

Non e' marketing. Ha le tre cose che di solito mancano:
1. 📊 **Una gerarchia di fiducia dichiarata**: *forward live > tick 100% > coarse
   1 minuto*, con il costo dell'errore **misurato**: *"il coarse gonfia il profit
   factor di circa DUE VOLTE... US100 in coarse fa PF 2,18; lo stesso asset,
   stesso periodo, al tick reale fa **1,15**"*.
2. 🪦 **Una tabella degli SCARTATI con i numeri accanto** — esattamente il nostro
   "certificato di morte".
3. 🩸 **Un'autopsia della settimana in perdita su conto reale**, con i conti in
   euro e la colpa attribuita alla **configurazione**, non alla strategia.

## 🤝 E conferma DA FUORI tre regole che ci siamo dati in casa
| regola di casa | come la scrive lui |
|---|---|
| OHLC gonfia, il tick e' il giudice | *"il coarse gonfia il PF di circa due volte... 12 mesi verdi in coarse diventano **-11% al tick**"* |
| l'ora dei log MT5 ≠ l'ora del grafico | *"verificare l'offset del server confrontando l'orologio del Market Watch con l'ora italiana — **non fidarsi del Diario**"* |
| **il preset giusto non e' il grafico giusto** | *"la configurazione in produzione deve corrispondere all'ultima versione validata, e va verificata **SUL TERMINALE — non sui file `.set`**... il file diceva una cosa, il terminale ne faceva un'altra"* |

🎯 **L'ultima riga e' la stessa lezione che abbiamo pagato oggi** sulle PostNews
(preset a 1.30 nel repo, grafico a 3.0 l'08/09). Lui l'ha pagata **8.597 EUR su
conto reale**. Averla confermata da fuori vale quanto una nostra misura.

---

# 🔴 DUE COSE NEL RIASSUNTO DI CLAUDIO NON COMBACIANO COL DOCUMENTO

Non e' un rimprovero: sono **due dettagli che costano soldi**, e vanno chiariti
con il collega prima di copiare qualunque cosa.

### 1. 🚨 IL PAVIMENTO DI STOP LOSS — il documento dice **ZERO**, non "fisso"
Claudio ha scritto: *"la combinazione migliore e' stata quella di impostare il
range basato su ATR **con un pavimento di stoploss fisso**"*.
Il documento, sezione 5 (**"I due valori che non si toccano"**), dice l'opposto:

> **"Pavimento stop-loss = 0. Portarlo a 20 punti fa crollare il DAX da PF 2,40 a
> 1,26 e US2000 da 2,97 a 1,05-1,40."**

e in tabella: `InpMinSLPts = 0`. Il motivo e' strutturale: *"lo stop stretto e'
l'unita' di misura di tutta la geometria, e allargarlo rompe le proporzioni fra
buffer, target e size"*.
👉 **Da chiedere al collega**: e' cambiato qualcosa dopo il 10/08 (il documento e'
la v2.60), o e' una svista nel riassunto? **La differenza fra i due e' un PF che
si dimezza.**

### 2. 🚨 UK100 e US2000 **NON sono nel portafoglio validato**
Claudio ha elencato cinque asset: DAX, UK100, US100, US2000, US30. Il portafoglio
validato del documento ne ha **quattro** e **UK100 non c'e'**:

| asset | simbolo (Pepperstone) | sessione (IT) | MaxMult | rischio | PF | DD |
|---|---|---|---:|---:|---:|---:|
| DAX | GER40.cash | 08:55 | 0,125 | 0,30% | 2,40 | 2,07% |
| US30 | US30.cash | 15:25 | 0,145 | 0,30% | 3,01 | 2,67% |
| NAS100 | US100.cash | 15:25 | 0,105 | 0,30% | 2,17 | 4,62% |
| US2000 | US2000.cash | 15:25 | 0,145 | **0,15%** | 2,46 | 1,16% |

E nella tabella degli scartati:
- **UK100 su Pepperstone**: *"~20 trade l'anno, spread al **19% del range**.
  Assente da entrambi i portafogli validati"*;
- **US2000 su FTMO**: *"spread pari al **90% dello stop**"* — scartato **li'**,
  tenuto su Pepperstone.

🩸 E l'autopsia della settimana nera lo dice in euro: dei **-8.597 EUR**,
**-2.842 EUR sono UK100** (*"non era in nessuno dei due portafogli validati"*) e
**-717 EUR US2000 su FTMO** (*"dove il documento diceva esplicitamente di non
aggiungerlo per via dello spread"*). Con la recovery accesa fanno **-6.395 EUR =
il 74% della perdita**, e **nessuna delle tre e' colpa della strategia**.

---

# ⚖️ IL PUNTO PIU' IMPORTANTE PER NOI: **il suo cancello del costo e' 8 VOLTE piu' largo del nostro**

| | criterio | in forma spread/stop |
|---|---|---|
| **lui** | *"spread ÷ SL: sotto il **20%** vive, oltre il **50%** muore"*, misurato **all'orario del trade** (15:30 per gli USA, 09:00 per il DAX), *"non a mercato calmo"* | ≤ 20% |
| **noi** | `stop >= 40 x spread` | ≤ **2,5%** |

🔴 **Non e' una sfumatura: e' un fattore 8.** Col suo metro il nostro portafoglio
e' larghissimo; col nostro metro **il suo portafoglio non passerebbe**.
**Nessuno dei due e' "giusto" per decreto** — ma la differenza va risolta con una
misura, non con un'opinione, perche' e' il cancello che boccia piu' candidati in
casa nostra.

### 📐 E il conto che serve subito, sul NOSTRO broker
Lo stop del DAX secondo i suoi parametri: `InpATR_SLMult 0,03208 x ATR(14) D1`.
Con un ATR D1 del DAX intorno a **250-350 punti indice** lo stop viene
**~8-11 punti indice** — coerente con la sua riga *"lo stop del DAX misurava
**13,9 punti**"*.

| broker | spread D30EUR/GER40 | spread ÷ SL (SL ~10 pt) | suo verdetto |
|---|---|---:|---|
| Pepperstone (suo) | ~1,0-1,5 [DICHIARATO] | ~10-15% | 🟢 vive |
| **BCM, mediana a tick** | **1,6-1,7** (misurato in casa, 252 M tick) | **~16-17%** | 🟡 al limite |
| **BCM, lettura 17:34 del 17/08** | **2,80** (`SpreadPt 280`) | **~28%** | 🟠 zona grigia |
| **BCM alle 08:00 server (apertura DAX)** | 🔴 **[NON MISURATO]** | ? | ? |

> ## 🎯 **La misura che vale piu' di tutte: lo spread dei nostri indici NELL'ORARIO DEL TRADE.**
> Lui lo dice esplicitamente e noi non l'abbiamo mai fatto. **E lo strumento ce
> l'abbiamo gia' pronto**: `ABTG_SpreadLogger` (`InpSimboli` =
> `D30EUR,U30USD,NASUSD,...`), da far girare sul **demo piccolo 50503392**.

---

# 🔬 COSA PRENDIAMO, COSA CONTROLLIAMO, COSA NON POSSIAMO COPIARE

## ✅ Le tre idee che valgono e che possiamo misurare subito
1. **Geometria tutta ATR-adattiva su D1 chiusa** (stop, target, buffer, ampiezza
   minima di range): *"il sistema si ri-tara da solo sulla volatilita' corrente"*.
   🟢 **Noi abbiamo gia' l'ATR nell'ORB** (`InpSLMode = ATR`, `InpAtrPeriod 14`,
   `InpAtrSLmult 1.5`) **ma sul TF di esecuzione (M5), non su D1**, e **solo per
   lo stop**: buffer, target e ampiezza minima restano fissi. **Questa e' una
   manopola nuova vera**, non un parametro rigirato.
2. **Parziale 80% a 1,5R + coda 20% fino a 3R.** Noi: `InpTP1Pct = 50`,
   `InpTP_R = 2.0`. Lui dichiara di aver **testato** il 50% e l'attesa a 2,0R:
   *"peggiora entrambi"*. 🟢 Manopola dell'**uscita** — la casella che il nostro
   certificato di morte dice essere quasi sempre non provata.
3. **Ampiezza minima di range per operare** (`InpATR_MinMult`): non si opera se
   la candela d'apertura e' troppo stretta. Noi **non ce l'abbiamo**.

## 🚨 LA CONFERMA CHE VALE ORO SU UN NOSTRO DIFETTO GIA' NOTO
> *"La cancellazione della gamba opposta e' una **protezione, non una
> preferenza**: le aperture hanno frequenze di inversione altissime — **35% su
> UK100, 57% su DAX, 68% sul Russell** — e qualsiasi schema che rientri dopo uno
> stop moltiplica l'esposizione proprio all'evento che ha causato la perdita."*

🔴 Il nostro `ABTG_ORB` ha `HandleOCO()` (r.545) **e l'audit del 03/09 ha misurato
che con il difetto `PositionSelect` su conto hedging il pendente opposto NON si
disarma**. Fino a oggi era catalogato come *"l'EA non fa quello che dice il
pannello"*. 👉 **Adesso ha un numero addosso: sul DAX il prezzo inverte il 57%
delle volte.** Non e' un difetto cosmetico: e' la gamba che si riempie dopo che
la prima e' stata stoppata.

## 🔴 QUELLO CHE NON POSSIAMO COPIARE, e va detto subito
- **US2000 su BCM NON ESISTE.** Cercato nella sonda simboli: nessun Russell 2000.
  (C'e' `200AUD` = **AUS 200**, che e' un'altra cosa.) 👉 Un quarto del suo
  portafoglio **non e' replicabile da noi**, ed e' proprio quello col DD piu'
  basso (1,16%).
- **UK100 su BCM esiste** (`100GBP`, spread **1,60** punti indice) **ma lui l'ha
  scartato** e gli e' costato 2.842 EUR quando l'ha tenuto. Se lo proviamo, si
  prova come **candidato nuovo**, non come "asset validato".
- **Le size sono sue.** `MaxMult`, rischio 0,30% per asset e **1,05% aggregato**
  vivono sul suo conto e sul suo broker. Da noi il cap C1 e' **3,25%** e il tetto
  per cluster al 3,0% e' **firmato ma NON ATTIVO** (nel Guardian non esiste
  ancora). **Le taglie restano di Claudio, sempre.**

---

# 🧨 E LA COSA CHE CLAUDIO HA DETTO PER PRIMO, che il documento CONFERMA

Claudio: *"ogni asset ha un suo ciclo negativo, tradandoli tutti insieme si
riesce a ridurre la varianza negativa **ma non escludo che ci possano essere
settimane intere in cui tutti vanno a SL**"*.

🎯 **Ha ragione, ed e' il rischio numero uno di questo portafoglio.** DAX, US30,
NAS100 e Russell nella stessa mezz'ora sono **quattro versioni della stessa
scommessa**: la diversificazione toglie il rumore del singolo indice, **non il
fattore comune**. Il documento lo ammette due volte: la settimana **-8.597 EUR**
esiste, e fra i **loop aperti** c'e' testualmente *"costruire il portafoglio
**decorrelato** oltre il PS5"*.

⚠️ E da noi questo morde piu' che da lui: il **tetto per cluster/valuta al 3,0%**
e' **firmato il 07/09 ma NON IMPLEMENTATO**. Finche' non c'e' nel Guardian, e'
un'intenzione, non una protezione — e va detto ogni volta che lo si cita.

## 📉 E il numero che spaventa di piu' di tutto il documento
> *"Lo slippage reale misurato e' di due soli campioni: **US30 4,67 punti, pari
> al 27% dello stop**; NAS 2,38 punti, 13%."*

Su uno stop da ~10 punti, **il 27% se ne va in slippage**. Lui stesso scrive che
l'haircut *"non e' ancora tarato sul dato vero"* e che servono **2-4 settimane di
log**. 🟢 **Noi la stessa misura l'abbiamo aperta ieri sul conto REALE**: primo
slippage mai registrato, **+0,70 punti indice in ingresso su D30EUR e 0,00
sull'uscita in stop** (n=1 per gruppo: un indizio, non una statistica).

---

# ✅ COSA PROPONGO, in ordine di valore per ottobre

| # | cosa | perche' | costo |
|---|---|---|---|
| **1** | 📏 **`ABTG_SpreadLogger` sui quattro indici NELL'ORARIO DEL TRADE** (08:00 server per il DAX, 14:25-14:40 per gli USA), sul demo **50503392** | e' **il suo criterio** e **il nostro cancello** applicati allo stesso numero, e oggi quel numero **non esiste**. Decide se questa famiglia e' anche solo discutibile da BCM | una riga, sola lettura, strumento gia' pronto |
| **2** | 🔧 **Il fix `PositionSelect` dell'ORB** sale di priorita' | il 57% di inversione sul DAX trasforma un difetto "cosmetico" in un rischio misurato | gia' scritto (v1.04), serve la firma su DOVE si ricompila |
| **3** | 🧪 **Round: geometria ATR su D1 + parziale 80%@1,5R + ampiezza minima di range**, sul nostro ORB, U30USD e D30EUR, **due lati** | tre manopole **nuove** (non parametri rigirati di un motore morto), tutte sull'**uscita** e sul **dimensionamento** | un round |
| **4** | 🙋 **Tre domande al collega** (sotto) | chiudono due contraddizioni e un numero che ci serve | un messaggio |
| **5** | 🇬🇧 **100GBP (UK100) come candidato NUOVO** | esiste su BCM con spread 1,60 — **ma lui l'ha scartato**: entra dall'imbuto, non dalla porta di servizio | dopo il punto 1 |

## 🙋 LE TRE DOMANDE DA FARE AL COLLEGA
1. **Il pavimento di stop e' 0 o fisso?** Il documento dice **0** e che a 20 il
   DAX crolla da PF 2,40 a 1,26. Il riassunto dice "fisso". **Qual e' la v2.60+?**
2. **UK100 e US2000 sono rientrati nel portafoglio dopo il 10/08?** Nel documento
   UK100 e' scartato e US2000 vive **solo su Pepperstone** (su FTMO ha spread al
   90% dello stop).
3. **Ha finito le 2-4 settimane di raccolta slippage?** L'haircut fra +130% e
   +93% dipende **tutto** da quel numero, e con n=2 campioni non e' tarato.
   👉 E se le ha, **e' il dato piu' prezioso di tutto il documento**: uno slippage
   misurato su una straddle a stop stretto, su conto vero.

---

## 🚧 COSA QUESTA LETTURA **NON** DICE
- **Non abbiamo verificato NESSUNO dei suoi numeri.** PF, DD, Monte Carlo,
  frequenze di inversione: tutti `[DICHIARATO-FONTE-ESTERNA]`.
- **Il suo broker non e' il nostro.** Simboli `.cash` di Pepperstone, spread
  diversi, contratti diversi. Il documento stesso dice che le prime cinque
  verifiche sono *"periferia da rifare a ogni broker"*.
- **Non abbiamo i quattro PDF originali** (contengono i grafici e le
  distribuzioni). Se Claudio riesce ad averli, la parte piu' utile e' **la
  distribuzione dei trade**, non i totali.
- **Niente e' stato toccato in forward, nessun EA modificato, nessun parametro
  cambiato.** Questa e' una lettura, non una promozione.
