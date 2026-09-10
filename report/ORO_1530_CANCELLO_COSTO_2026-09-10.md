# 🚧 ORO 15:30 — IL CANCELLO DEL COSTO

**Data: 10/09/2026.** Risposta alla richiesta di Claudio sul metodo del collega:
range M5 **15:30-15:35 IT** (= **14:30-14:35 server BCM**), rottura vista in **M1
alle 15:36** (= **14:36 server**), ingresso **a mercato**, uscita dopo **3 o 4
candele M1**.

> 🛑 **Questo referto non tocca niente.** Nessun EA, nessun preset, nessun conto,
> nessun forward, nessuna riga lanciata sul VPS. Porta **misure** e **un verdetto
> di costo**. Decide Claudio.

> 🎯 **Il mio pezzo e' UNO SOLO: il cancello del costo.** Non dico se il metodo
> ha edge (lo misura l'agente del disegno), non cerco prove esterne (lo fa
> l'agente della caccia). Dico **quanto costa il pedaggio e se la geometria lo
> regge**.

---

## 0. 🥇 LA RIGA CHE RESTA

> **La finestra 15:36-15:41 su M1 SFONDA la frontiera del costo, e non di poco:
> il pavimento DI LAVORO chiede uno stop di 6,40 $ (8,01 $ contando la
> commissione); il movimento tipico di tutta l'operazione, MISURATO in quella
> finestra sul nostro broker, e' 1,41 $. Manca un fattore 4,5x — e non arriva
> nemmeno al pavimento DURO di 2,13 $.**
>
> 🔴 **E non e' una previsione: quel trade Claudio lo ha GIA' fatto a mano.**
> 33 operazioni sull'oro aperte fra le 14:35 e le 14:40 server su 19 giornate
> diverse (conto DEMO 50503392, magic 0 = suo trading manuale, giugno-luglio
> 2026): **22 vinte su 33 (66,7%)** e il blocco chiude a **−785,99 EUR**.
> **Vincere due volte su tre e perdere lo stesso e' la firma esatta del cancello
> di costo**, non della sfortuna: dei 785,99 EUR persi, **~473 EUR (60%) sono
> pedaggio puro** (377,92 di spread stimato + 95,24 di commissione MISURATA).

---

## 1. 💵 QUANTO VALE UN DOLLARO D'ORO — la conversione, prima di tutto

Senza questa riga nessun numero e' confrontabile con le altre sedie.

| grandezza | valore | fonte, riga per riga |
|---|---:|---|
| contratto XAUUSD | **100 oncie / lotto** | `risultati_archivio/sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv` r.59 (`ContractSize 100.00`) **e** `risultati_archivio/R114_CORSA_20260827/REFERTO_R114.txt` r.102 (`GSPEC;XAUUSD;CONTRACT_SIZE;100.00000000`) — **due sonde indipendenti, stesso numero** |
| `_Digits` / `_Point` | **2 / 0,01 $** | stessa riga CSV (`Digits 2`, `Point 0.01000000`) |
| **1 punto MT5 (0,01 $) per lotto** | **1,00 USD = 0,863 EUR** | `TickValue 0.86289` su `TickSize 0.01` nella stessa riga: 0,01 $ x 100 oz = 1,00 USD, che a 0,86289 fa **0,86289 EUR** |
| **1,00 $ di movimento per lotto** | **100,00 USD = 86,29 EUR** | discende dalla riga sopra |

✅ **Terza conferma, indipendente e in campo** (`report/DIARIO.md` r.10, pagella
08/09): la copertura `LARRY ORO L` 0,01 a 4433,97 contro `MAXMIN ORO SELL` 0,01 a
4403,21 → `(4403,21 − 4433,97) x 1 oncia = −30,76 $ = −26,57 EUR`, **ed e'
esattamente il netto XAUUSD di quella pagella**. 0,01 lotti = 1 oncia. Il conto
torna al centesimo.

📐 **Il metro di casa, per il confronto**: `D30EUR = 1,0000 EUR per punto indice
per lotto` (`TickValue 0.10` su `TickSize 0.10`, stesso CSV r.65).
👉 **XAUUSD sta sulla stessa scala**: 1 punto = 1,00 USD per lotto. Cambia che
sull'oro un "punto" e' **un centesimo di dollaro**, non un punto indice: la
grandezza da guardare e' sempre il **rapporto stop/spread**, mai il numero nudo.

---

## 2. 💸 LO SPREAD DELL'ORO DA BCM — quello che abbiamo, e quello che NON abbiamo

### 2.1 Le misure che esistono, tutte e due (e sono due sole)

| # | quando (ora **server**) | spread | fonte, verbatim |
|---|---|---:|---|
| **S1** | **2026.08.17 17:34:09** | **16 punti = 0,16 $** | `sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv` r.59, colonna `SpreadPt` = `16`. L'ora e' nell'intestazione del file: `OraServer,2026.08.17 17:34:09` |
| **S2** | **2026.08.27 ~08:52-08:56** | **0,22 $** (22 punti) | `R114_CORSA_20260827/REFERTO_R114.txt` r.112-113: `PREZZO_ASK;4535.52` / `PREZZO_BID;4535.30` → differenza **0,22**. Ora dal r.7-8 del referto (`09:56 ora PC` = 08:56 server) |

🔬 **E la sonda S1 e' CREDIBILE, perche' e' verificata contro una misura vera.**
Nello stesso identico istante (17:34 server) la sonda leggeva anche gli indici,
e li' abbiamo lo spread misurato sui **tick storici**
(`risultati_archivio/SPREAD_FLOTTA_MISURA_2026-09-03.md`, 252 milioni di tick):

| simbolo | sonda istantanea 17/08 17:34 | mediana dai TICK, stessa ora | esito |
|---|---:|---:|---|
| **NASUSD** | 180 pt = **1,80** | **1,6-1,8** (ore 14-20) | ✅ centrata |
| **U30USD** | 200 pt = **2,00** | **1,9-2,0** (ore 14-20) | ✅ centrata |
| **D30EUR** | 280 pt = **2,80** | 1,6-1,7 in sessione, **notte 3,5-3,9** | ✅ coerente: alle 17:34 il cash DAX e' **chiuso** |

👉 **Su due simboli su due misurabili la sonda istantanea cade dentro la mediana
a tick.** Non e' una prova che 0,16 sia la mediana dell'oro, ma **e' la prova che
lo strumento non mente**. La sonda S1 e' quindi una **lettura singola credibile
di un'ora liquida** (17:34 server = 18:34 IT, cash USA aperto da 3 ore).

### 2.2 🔴 ERRATA — il "0,24 $ misurato in casa" NON esiste

`report/CACCIA_APERTURE_ORO_2026-09-08.md` r.208 e r.390 (e il gemello in
`caccia_strategie/`, r.208 e r.399) scrivono: _"spread oro **diurno MISURATO in
casa** 0,24 $"_.

**Ho cercato quel numero in tutto il repo e non c'e'.** Le uniche letture BCM
sull'oro sono le due della tabella §2.1: **0,16** e **0,22**. Nessun file
contiene 0,24 riferito allo spread dell'oro (l'unico "0,24" vicino e' in
`DIARIO.md` r.10, e sono **punti di DAX**, un'altra cosa).

🔧 **Correzione, e va portata avanti**: dove serve un solo numero si usa
**0,16 $ (S1)** come lettura d'ora liquida e **0,22 $ (S2)** come lettura
prudente; **0,24 va ritirato**. La differenza non ribalta nessun verdetto di
oggi (0,16 e' il caso *piu' favorevole*, e boccia lo stesso), ma un numero senza
fonte e' esattamente il difetto che il progetto ha deciso di non ripetere.

### 2.3 🔴 E IL NUMERO CHE SERVE DAVVERO NON CE L'ABBIAMO

> **Lo spread dell'oro nei minuti 14:30-14:41 server — cioe' la finestra di
> Claudio — e' [NON MISURATO].**

Le due letture che abbiamo stanno **fuori** da quella finestra: una tre ore
**dopo** (S1), una sei ore **prima** (S2). E la direzione dell'errore e'
**nota e sfavorevole**: sull'apertura lo spread si **allarga**, non si stringe —
lo abbiamo gia' misurato sui nostri indici (`SPREAD_FLOTTA_MISURA`: D30EUR ora 8
ha **P95 2,7** contro mediana 1,6-1,7; U30USD ora 23 ha **P95 7,0 e max 101**).

🧊 **Conseguenza dichiarata:** tutti i conti di questo referto sono fatti col
numero **piu' favorevole** che possediamo (0,16). **Se il vero spread della
finestra fosse 0,22 — o peggio — il verdetto peggiora, non migliora.** Non c'e'
nessuno scenario in cui il costo reale sia migliore di quello che scrivo.

### 2.4 ✅ LA COMMISSIONE: questa si', MISURATA, su 520 operazioni vere

Fonte: `data/statements/trades_auto.csv` (conto DEMO 50503392, 30/03→09/09/2026),
520 righe XAUUSD.

| simbolo | n (lotti ≥ 0,25) | commissione per lotto, **giro completo** |
|---|---:|---:|
| **XAUUSD** | 385 | **−3,48 EUR** (min −3,53 · max −3,43) |
| EURUSD | 14 | −4,00 EUR |
| GBPUSD | 14 | −4,67 EUR |
| **D30EUR** | 144 | **0,00** |
| **NASUSD** | 44 | **0,00** |
| **U30USD** | 27 | **0,00** |

> ### 🚨 **L'ORO PAGA COMMISSIONE. I NOSTRI INDICI NO.**
> **3,48 EUR per lotto = 4,03 USD = 0,0403 $ di prezzo dell'oro = 4 punti.**
> E' **il 25% dello spread misurato** (0,16 $), e finora **nessun conto di casa
> sull'oro la contava**. Su D30EUR/NASUSD/U30USD la frontiera `40 x spread` puo'
> ignorare la commissione perche' e' zero; **sull'oro NO**, e da qui in avanti va
> messa dentro.

**Costo pieno di un giro completo sull'oro:**
`0,16 $ (spread) + 0,0403 $ (commissione) = **0,2003 $**` — arrotondato:
**0,20 $, cioe' 20 punti, cioe' 20,03 USD per lotto (17,28 EUR).**
Con lo spread prudente S2: `0,22 + 0,0403 = **0,26 $** = 26,03 USD per lotto`.

### 2.5 🌙 SWAP / ROLLOVER — misurabile, e qui non morde

Sulle 520 righe XAUUSD lo swap e' **diverso da zero solo in 21 casi**, somma
**−1,18 EUR** in totale. Su un'operazione di **3-4 minuti** lo swap e'
**strutturalmente zero** (non si tiene la posizione a cavallo delle 00:00
server). ✅ **Non e' un termine di questo problema**, e lo dico invece di
lasciarlo come buco.

---

## 3. 📏 QUANTO STOP SERVE — la frontiera, in dollari

Frontiera di casa (`caccia_strategie/CACCIA_TFBASSO_FREQUENZA_2026-09-06.md`
§6.1, ripresa in `CACCIA_APERTURE_ORO_2026-09-08.md` r.211-212):
pavimento **DURO** `stop >= 13,3 x spread`, pavimento **DI LAVORO**
`stop >= 40 x spread`.

| costo usato | pavimento **DURO** (13,3x) | pavimento **DI LAVORO** (40x) |
|---|---:|---:|
| spread **0,16 $** — S1, ora liquida, il piu' favorevole | **2,13 $** | **6,40 $** |
| spread **0,22 $** — S2, prudente | 2,93 $ | 8,80 $ |
| **costo pieno 0,2003 $** (spread S1 + commissione MISURATA) | **2,66 $** | 🎯 **8,01 $** |
| costo pieno 0,2603 $ (spread S2 + commissione) | 3,46 $ | 10,41 $ |

> ### 👉 **La distanza minima di stop ammessa sull'oro e' 6,40 $ contando il solo
> spread, 8,01 $ contando anche la commissione che l'oro paga davvero.**
> Sono **640 e 801 punti MT5**. Per lotto: **640 USD e 801 USD di rischio**.

---

## 4. 📐 E QUANTO SI MUOVE DAVVERO L'ORO IN 3-4 CANDELE M1 IN QUELLA FINESTRA

Qui il progetto ha una fortuna che non sapeva di avere: **il dato c'e', ed e'
nostro**.

### 4.1 La misura, dalla finestra esatta

`data/statements/trades_auto.csv`, XAUUSD, `magic = 0` (= **trading manuale di
Claudio**, confermato da lui il 07/09: _"Sul conto piccolo demo avevo iniziato a
farlo manuale... I trade senza commenti non li calcolare"_ —
`report/MAGIC_ZERO_PICCOLO_2026-09-07.md`), aperture fra **14:35 e 14:40 server**:

| | |
|---|---:|
| operazioni | **33** |
| giornate distinte | **19** (01/06 → 21/07/2026) |
| **durata mediana** | **1,9 minuti** ⬅️ *e' esattamente il trade del collega* |
| **escursione \|chiusura − apertura\| mediana** | **1,41 $** |
| p75 | 5,04 $ |
| massimo | 16,50 $ |

Allargando appena la finestra (14:30-14:45, n=55): durata mediana **2,5 min**,
escursione mediana **1,31 $**, p90 **10,78 $**.

⚠️ **Cosa e' e cosa non e'**: e' l'escursione **realizzata dall'operazione**
(entrata → uscita), non il range della candela. Dipende dalle uscite scelte a
mano, quindi **non e' un ATR**. Ma e' **la scala vera del movimento che quel
trade cattura su quel broker in quella finestra**, ed e' misurata su 19 giornate.

### 4.2 🧪 Controprova con una regola indipendente — e torna al 4%

Dal **range di giornata dell'oro MISURATO** sulle stesse righe (colonne
`session_high`/`session_low`, **60 giornate distinte**):
**mediana 40,50 $** (p25 18,61 · p75 58,62 · max 186,63).

Con la regola di scala `range(t) ≈ range(giorno) x √(t/1440)` [INFERITO]:
`40,50 x √(1,9/1440) = **1,47 $**` contro il **1,41 $ misurato**.
✅ **Scarto 4,3%.** Due strade indipendenti, stesso numero: la scala del
movimento in quella finestra e' **~1,4 $**, e non e' un'opinione.

### 4.3 🔴 E IL CONFRONTO CHE CHIUDE IL PUNTO

| | valore |
|---|---:|
| movimento tipico di **tutta l'operazione** (3-4 candele M1) | **1,41 $** |
| stop plausibile per quel trade (dell'ordine del movimento) | **1,4 - 2,0 $** |
| **rapporto stop / spread** a stop 1,41 $ | **8,8x** |
| **rapporto stop / spread** a stop 2,00 $ | **12,5x** |
| pavimento **DURO** | **13,3x** ❌ |
| pavimento **DI LAVORO** | **40x** ❌❌ |
| **quanto manca al pavimento DI LAVORO** | serve **6,40 $**: si e' al **22-31%** → **manca un fattore 3,2 - 4,5x** |

Detto al contrario, che e' il modo piu' brutale: **per rispettare la frontiera
bisognerebbe mettere uno stop 4,5 volte piu' grande di quanto tutta
l'operazione tipicamente si muove.** Non e' una taratura da trovare: e' una
geometria che non esiste.

---

## 5. ⚖️ IL VERDETTO DI COSTO, IN UNA RIGA

> ## 🔴 **BOCCIATO PER COSTO. La finestra 15:36-15:41 su M1 SFONDA la frontiera `stop >= 40 x spread`, e sfonda anche il pavimento DURO `13,3 x`.**
> **Margine: NEGATIVO.** Servono **6,40 $** di stop (8,01 $ con la commissione);
> la geometria del trade ne offre **1,41-2,00 $** = **22-31% del richiesto**.

📊 **Per collocarlo fra i precedenti di casa** (tutti gia' a verbale):

| caso | rapporto stop/spread | esito |
|---|---:|---|
| U30USD H1 (`SuperWave`, 1R misurato 113,70 pt contro spread 2,00) | **56,9x** | ✅ passa, margine **+42%** — *il piu' sottile mai visto* |
| NY Session Retest M15 (perdita mediana 58,0 pt contro 1,95) | **29,7x** | 🟡 sopra il DURO, sotto il LAVORO |
| indici su **M5** | sotto 13,3x | 🔴 **esclusi PER COSTO**, gia' dichiarato |
| **ORO, finestra 15:36 su M1** | **8,8 - 12,5x** | 🔴 **sotto anche il pavimento DURO** |

👉 **E' peggio degli indici su M5**, che in casa sono gia' un capitolo chiuso.

### 5.1 🔬 E c'e' la prova sperimentale, fatta dalla mano di Claudio

Non e' solo aritmetica. **Quel trade e' gia' stato girato a mano su BCM**
(§4.1, n=33, 19 giornate):

| | |
|---|---:|
| operazioni | 33 |
| **vinte** | **22 (66,7%)** |
| lordo | **−690,75 EUR** |
| commissione MISURATA | **−95,24 EUR** |
| **NETTO** | **−785,99 EUR** |
| lotti totali | 27,37 |
| spread pagato *(stimato a 0,16 $, cioe' al meglio)* | **−377,92 EUR** |
| **pedaggio totale (spread + commissione)** | **−473,16 EUR = 60,2% della perdita** |

> 🎯 **Sessantasei per cento di operazioni vincenti, e il blocco perde.**
> Questa e' la firma del cancello di costo, non del caso: quando il pedaggio
> vale il **14,2%** del movimento tipico (0,20 $ su 1,41 $) contro un budget di
> progetto del **2,5%** (gate R55), **il tasso di successo smette di contare**.
> Il pedaggio e' **5,7 volte** il budget.

⚠️ **Onesta' sul campione**: n=33 e' **sottile per il MERITO**. La regola di casa
(16/08, valvola R59) dice che il campione sottile **sospende il giudizio sul
merito, MAI sul rischio** — e questi 785,99 EUR sono **accaduti**, non stimati.
E il verdetto di costo di §5 **non poggia su questi 33 trade**: poggia
sull'aritmetica di §3-§4. I 33 trade sono la **conferma indipendente**, non la
prova.

---

## 6. ✋ "MA IO LO FACCIO A MANO" — la porta si chiude qui

Claudio, testuale (10/09): _"LA RICHIESTA CHE TI HO FATTO E' X TRADARE MANUALE.
O PER CREARE UN EA SULL'APERTURA. LUI DICE CHE QUEI 5 MINUTI SONO FACILI DA
TRADARE."_

> ## 🔴 **"MANUALE" NON E' UN'ESENZIONE DAL CANCELLO. E' LO STESSO CANCELLO.**
> Lo spread lo mette **il broker**, non l'EA. La commissione di **3,48 EUR per
> lotto** la addebita **BCM**, e nel nostro estratto conto e' addebitata su
> **520 operazioni sull'oro di cui 485 sono le TUE, fatte a mano**. Il ticket
> MT5 non chiede chi ha premuto il pulsante.
> **Se `stop >= 40 x spread` boccia questa finestra, boccia SIA l'EA SIA la mano.**

E la prova non e' teorica: **la mano ha gia' provato, 33 volte su 19 giornate, e
il blocco e' a −785,99 EUR con il 66,7% di operazioni vinte** (§5.1). Non e'
un'ipotesi su cosa succederebbe: e' cosa **e' successo**.

### 6.1 ➕ E a mano il costo e' PIU' ALTO, non piu' basso

| voce | EA | mano |
|---|---|---|
| spread | identico | **identico** |
| commissione | identica | **identica** |
| **latenza fra il segnale e l'ordine** | millisecondi | **secondi** (vedere il break su M1, decidere, cliccare) |

📐 **Quanto costa un secondo di esitazione, DERIVATO da numeri misurati:**
il movimento mediano in quella finestra e' **1,41 $ in 1,9 minuti** = **0,74
$/minuto = 0,0124 $/secondo = 1,24 punti al secondo = 1,24 USD al secondo per
lotto**.
- **3 secondi di reazione umana ≈ 0,037 $ ≈ il 23% dell'intero spread misurato.**
- 🔴 **Ed e' un LIMITE INFERIORE**: quella e' la velocita' *media* dei 1,9
  minuti; **sulla rottura la velocita' e' sopra la media**, per definizione di
  rottura. Il costo vero di quei secondi e' **maggiore**.

### 6.2 🔴 Lo slippage sull'oro: **[NON MISURATO]**, e va detto

| fonte | copertura | cosa dice |
|---|---|---|
| `ABTG_SlippageLogger` sul **conto REALE 10105439** | 🔴 **niente oro**: le sedie di quel terminale sono `DAX Apertura EU` (770101) e `ORB_Ottimizzato` (770611) | primo e unico dato (10/09): D30EUR ingresso **+0,70 punti indice**, uscita in stop **0,00**. **n=1 per gruppo: e' un indizio, non una statistica** (`report/RESOCONTO_NOTTE_2026-09-10.md`) |
| `slippage_20260905/slippage_dettaglio_2026-09-05.csv` | **818 D30EUR + 103 NASUSD**, **0 XAUUSD** | in sessione mediana 0,4 pt, P95 3,3; fuori sessione P95 92,7 |
| statement del demo | — | **non e' utilizzabile**: BCM **non scrive il livello richiesto** nel prezzo dell'ordine — misurato il 10/09, _"una misura basata su B direbbe 'slippage zero' su QUALUNQUE conto"_ |

> 🔴 **Sull'ORO non esiste NESSUNA misura di slippage, ne' per l'EA ne' per la
> mano.** Ed e' il caso peggiore possibile: **ingresso a mercato su una rottura,
> nel minuto piu' violento della giornata**. Le sei peggiori perdite del conto
> piccolo stanno tutte nelle aperture.
>
> ⚠️ **Ma lo slippage NON e' il motivo della bocciatura**, e lo dico perche' e'
> onesto: la bocciatura sta gia' tutta nello spread + commissione, che sono
> **misurati**. Lo slippage **aggrava**, non decide.

---

## 7. 🧮 IL CONTO CHE CLAUDIO PUO' FARE IN TESTA DAVANTI AL GRAFICO

> ### 🥇 **ORO, REGOLA DA UN RIGO: un giro completo costa 20 CENTESIMI DI ORO.**
> **Il prezzo deve fare 0,20 $ a tuo favore solo per andare in PARI.**

| taglia | spread + commissione, **giro completo** | movimento per il pareggio |
|---|---:|---:|
| **1,00 lotto** (100 oz) | **20,03 USD** = 17,28 EUR | **0,20 $** |
| 0,50 lotti | 10,02 USD = 8,64 EUR | 0,20 $ |
| 0,10 lotti | 2,00 USD = 1,73 EUR | 0,20 $ |
| **0,01 lotti** (1 oz) | **0,20 USD** = 0,17 EUR | **0,20 $** |

*(col numero prudente S2 — spread 0,22 — diventa **0,26 $**, cioe' **26,03 USD
per lotto**.)*

**Le tre righe da tenere a mente:**
1. 💸 **Il pareggio e' a 0,20 $.** Il movimento tipico di quella finestra e'
   **1,41 $** → **il pedaggio si mangia il 14,2% del trade tipico** (budget di
   casa: **2,5%**).
2. 📏 **Lo stop minimo ammesso e' 6,40 $** (8,01 $ con commissione). Se il tuo
   stop e' 2 $, sei a **12,5x lo spread**: **sotto il pavimento DURO di 13,3x**,
   cioe' fuori anche dalla soglia piu' permissiva che abbiamo.
3. ⏱️ **Ogni secondo di esitazione costa ~1,2 USD per lotto** (e alla rottura di
   piu').

---

## 8. 🔓 E ADESSO LA PARTE UTILE: IL TF PIU' BASSO CHE LA FRONTIERA LASCIA PASSARE

La regola di casa e' *"si preferiscono i TF piu' bassi, ma la frontiera del costo
non si sposta"*. Quindi: **dove si sposta il meccanismo, non se si molla.**

**La soglia da superare:** stop **>= 6,40 $** (solo spread) / **>= 8,01 $**
(spread + commissione — sull'oro e' questa quella giusta, §2.4).

**Il range tipico per TF**, dal range di giornata **MISURATO** (40,50 $, n=60
giorni) con la regola di scala validata al 4,3% in §4.2:

| TF | range tipico | stop **1,0x** | stop **1,5x** *(oltre il lato opposto: la geometria dell'ORB)* | passa **6,40**? | passa **8,01**? |
|---|---:|---:|---:|:---:|:---:|
| **M1** | 1,07 $ | 1,07 | 1,60 | 🔴 NO | 🔴 NO |
| **M5** | 2,39 $ | 2,39 | 3,58 | 🔴 NO | 🔴 NO |
| **M15** | 4,13 $ | 4,13 | 6,20 | 🟡 quasi (−3%) | 🔴 NO |
| **M30** | 5,85 $ | 5,85 | **8,77** | 🟢 **SI (+37%)** | 🟢 **SI (+9,7%)** |
| **H1** | 8,27 $ | **8,27** | 12,40 | 🟢 SI (+29%) | 🟢 SI (+3,4% a 1,0x · **+55% a 1,5x**) |
| **H4** | 16,53 $ | 16,53 | 24,80 | 🟢 SI | 🟢 SI (+106%) |

> ### 🎯 **RISPOSTA: il TF piu' basso che la frontiera lascia passare sull'oro e' M30 — e solo con lo stop oltre il lato opposto del range (~1,5x, cioe' ~8,8 $). Con uno stop stretto (1,0x) il primo TF sicuro e' H1.**
> Margine a M30/1,5x: **+9,7%** sulla soglia col pedaggio pieno.
> ⚠️ **E' un margine SOTTILE**: il piu' sottile mai accettato in casa era **+42%**
> (U30USD H1). Su M30 il collaudo a spread maggiorato **+25% / +50%** e'
> obbligatorio prima di qualunque schieramento — a +50% di spread la soglia sale
> a 9,6 $ e **M30 a 1,5x non passa piu'**. 👉 **Il gradino robusto e' H1.**

### 8.1 🤔 La rottura del range d'apertura ha ancora senso su M30 / H1?

**Strutturalmente si', ed e' un meccanismo che il progetto sa gia' fare** — ma
**non e' piu' il trade del collega, e va detto chiaro**:

| | il metodo del collega | quello che la frontiera lascia passare |
|---|---|---|
| range | 5 minuti (15:30-15:35) | **30 minuti** (15:30-16:00 IT = **14:30-15:00 server**) |
| rottura | 15:36 su M1 | alla chiusura della prima barra M30 |
| durata | 3-4 minuti | **ore** |
| stop | ~1,4-2,0 $ | **>= 8,8 $** |
| ✅ macchina in casa | — | `ABTG_ORB` / `ABTG_ORB_Ottimizzato` / `ABTG_Nasdaq_Apertura_US` fanno **esattamente** questo (range d'apertura + buffer + floor), gia' scritti e gia' collaudati sugli indici |

🟢 **La buona notizia**: la tesi del collega — *"all'apertura del cash USA l'oro
prende una direzione"* — **non e' bocciata da questo referto**. E' bocciato **il
contenitore da 3-4 minuti**, perche' non ci sta il pedaggio. **La stessa tesi su
M30/H1 e' misurabile con macchine che abbiamo gia'**, e la prova costa una corsa.

🔴 **Il muro che resta prima di qualunque verdetto di merito sull'oro** (non e'
mio, e' regola F6 di casa): **la profondita' a TICK di XAUUSD non e' mai stata
misurata** (`risultati_archivio/misura_tick/` contiene **solo** D30EUR, NASUSD,
U30USD). Finche' la sonda non gira, sull'oro si puo' fare **solo screening a
OHLC**, mai un verdetto. La riga e' gia' scritta e verificata in
`report/SONDA_TICK_ORO_ATTENZIONE.md` — e **NON va sul VPS** (lo script uccide
tutti i `terminal64`, conto reale compreso): va sul **PC di backtest**.

---

## 9. 🚩 COSA QUESTO REFERTO **NON** COPRE

Regola di casa: il collaudo vale per quello che copre, e dice sempre cosa no.

| buco | stato |
|---|---|
| **spread nella finestra 14:30-14:41 server** | 🔴 **[NON MISURATO]** — le due letture sono fuori finestra. Il conto e' fatto col numero **piu' favorevole** |
| **slippage sull'oro** (EA o mano) | 🔴 **[NON MISURATO]** — zero righe XAUUSD in tutti i dataset di slippage |
| **slippage della REAZIONE UMANA** | 🔴 **[NON MISURATO]** — stimato solo come limite inferiore (§6.1) |
| **requote / rifiuti / esecuzione di una prop vera** | 🔴 **[NON MISURATO]** — nessun dato, per nessun simbolo |
| **profondita' a tick di XAUUSD** | 🔴 **[NON MISURATO]** — blocca ogni verdetto di MERITO sull'oro |
| **range per TF sull'oro** | 🟡 **[INFERITO]** dalla regola di scala, validata al 4,3% su un punto. La misura vera (ATR per TF) e' a una corsa di distanza |
| **profilo commissioni della prop** (non BCM) | 🔴 **[NON MISURABILE]** oggi — le schede dei cacciatori non lo riportano per l'oro |

---

## 10. 📋 COSA MISURARE, E QUANTO COSTA — in ordine di resa

| # | misura | come | costo | cosa sblocca |
|---|---|---|---|---|
| **1** | 💸 **spread XAUUSD ora per ora, mediana e P95** | `ABTG_SpreadLogger` (gia' costruito, ASCII puro, sola lettura, pin verificato) sul **DEMO 50503392** — `RIGA_SPREADLOGGER_DA_MANDARE.md` dice gia' che basta **aggiungere `,XAUUSD`** alla lista, "~2 MB di memoria in piu' e nient'altro" | **una riga di lancio**, MT5 puo' restare aperto | 🔓 **il numero della finestra**. E' il buco n.1 di questo referto e costa quasi zero |
| **2** | 📏 **ATR per TF sull'oro** (M5/M15/M30/H1) | una corsa sul PC di backtest | minuti | 🔓 trasforma la tabella §8 da [INFERITO] a MISURATO |
| **3** | 🥇 **profondita' a tick di XAUUSD** | `RIGA_SONDA_OROLOGIO`/`scarica_storico.ps1` **sul PC di backtest, MAI sul VPS** | ~ore macchina | 🔓 **ogni** verdetto di merito sull'oro |
| **4** | ✋ **slippage della mano** | 20 ingressi a mercato sul **demo**, annotando il prezzo del break visto su M1 e il prezzo del ticket. ⚠️ **Non si puo' ricavare dallo statement**: BCM non scrive il livello richiesto (misurato 10/09) | Claudio, 20 volte | 🔓 il termine umano, oggi solo stimato |
| **5** | 🤖 **slippage EA sull'oro** | attaccare `ABTG_SlippageLogger` al terminale **DEMO 50503392** (che le sedie oro le ha), non al reale (che non le ha) | una riga | 🔓 il termine EA |

⚠️ Ognuna di queste passa dal **CANCELLO** (`controlla_riga.py` + agente
`controllo-preventivo`) **prima** di essere dettata. Qui non ne detto nessuna:
le propongo.

---

## 11. ✍️ RIGA PER `REGISTRO_TEST.md`

> **ORO 15:36 M1 (range 14:30-14:35 srv, uscita 3-4 candele M1) — 🔴 BOCCIATO
> PER COSTO.** Spread MISURATO 0,16 $ (17/08 17:34 srv) / 0,22 $ (27/08 08:5x
> srv); commissione MISURATA **3,48 EUR/lotto** giro completo (n=385) —
> **l'oro paga commissione, i nostri indici no**. Costo pieno **0,2003 $** =
> 20,03 USD/lotto. Frontiera `40x` → stop minimo **6,40 $** (8,01 $ col
> pedaggio pieno); movimento MISURATO del trade in quella finestra **1,41 $**
> (n=33 su 19 giornate, magic 0 = manuale di Claudio) → **8,8-12,5x**, sotto
> anche il pavimento DURO 13,3x. **Prova sperimentale in campo: 22 vinte su 33
> (66,7%) e −785,99 EUR netti, di cui ~473 EUR (60%) di solo pedaggio.**
> Vale **identico per il trading a mano**. 🔓 **NON e' morta la tesi**: il TF
> piu' basso ammesso e' **M30 con stop >= ~8,8 $** (margine +9,7%, sottile),
> **H1** il gradino robusto. Buchi: spread nella finestra, slippage sull'oro,
> tick XAUUSD — tutti **[NON MISURATO]**.

---

_Fonti primarie, tutte sul branch `lavoro`:
`backtest_pipeline/risultati_archivio/sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv` (r.1-21 intestazione, r.59 XAUUSD, r.65-71 indici) ·
`backtest_pipeline/risultati_archivio/R114_CORSA_20260827/REFERTO_R114.txt` (r.7-8, r.93-117) ·
`backtest_pipeline/risultati_archivio/SPREAD_FLOTTA_MISURA_2026-09-03.md` ·
`data/statements/trades_auto.csv` (520 righe XAUUSD, 30/03→09/09/2026) ·
`report/MAGIC_ZERO_PICCOLO_2026-09-07.md` ·
`report/MISURA_SLIPPAGE_2026-09-05.md` + `risultati_archivio/slippage_20260905/` ·
`report/RESOCONTO_NOTTE_2026-09-10.md` ·
`report/DIARIO.md` r.10 ·
`report/ROUND_USCITE_SUPERTREND_2026-09-09.md` §6.3-6.4 ·
`report/CACCIA_APERTURE_ORO_2026-09-08.md` §2 (e la sua **errata**, §2.2 qui) ·
`report/SONDA_TICK_ORO_ATTENZIONE.md` ·
`backtest_pipeline/righe/RIGA_SPREADLOGGER_DA_MANDARE.md`._
