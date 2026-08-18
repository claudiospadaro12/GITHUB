# 📐 MEDIAZIONE — SPECIFICA RICOSTRUITA DAL CORSO DI CLAUDIO (lezioni 26-33)

> **Fonte:** le 8 trascrizioni in
> `backtest_pipeline/caccia_strategie/trascrizioni_corso_2026-08-18/modulo_mediazione/`
> (58.689 caratteri, **lette per intero, riga per riga**). **Nient'altro.**
> Nessuna integrazione da memoria, nessun documento esterno, nessun file Excel
> in nostro possesso: dove il corso tace, qui c'e' scritto **BUCO**.
>
> **Referto di analisi** (schede per lezione, citazioni, contraddizioni,
> confronto col setaccio):
> `backtest_pipeline/caccia_strategie/ANALISI_CORSO_MEDIAZIONE_2026-08-18.md`
>
> **Spec gemella (modulo successivo, lezioni 34-40):**
> `backtest_pipeline/prove/BREAKOUT_CORSO_SPEC.md`
>
> **Etichette:** `[T]` = trascritto testualmente · `[I]` = inferito (dico da
> dove) · `[?]` = incerto/ambiguo · `[BUCO]` = il corso non lo dice.
>
> ⚠️ **Questa spec descrive cosa INSEGNA il corso, non cosa funziona.** I numeri
> di performance del corso sono `[dichiarati dal corso, NON verificati da noi]`.
> **I profitti veri li misurera' il tester, SE la strategia passa il setaccio.**

---

## 0. 🔥 IL RISULTATO PIU' IMPORTANTE DI QUESTA SPEC

**Il "foglio Excel proprietario" del corso — quello che la relatrice presenta
come la scatola nera studiata da lei (_"sulla base dei parametri che ho studiato
appunto per il cross in oggetto"_, lez. 28) — E' STATO RICOSTRUITO PER INTERO
DAL SOLO PARLATO.**

Tre formule, tre parametri, e chiude **su tre cross diversi e tre esempi
indipendenti**, al centesimo di pip. Vedi §5. **Non serve il file.**

E chiude anche l'**aritmetica del rischio**: la ricostruzione riproduce **tre**
percentuali dichiarate dal corso (rischio riga 1 = 0,21%, riga 2 = 0,26%,
profitto totale = 4,06%) con errore < 1%. Vedi §7.3.

---

## 1. 🎯 IDENTITA' DELLA STRATEGIA

| voce | valore | fonte |
|---|---|---|
| Nome | Strategia di Mediazione | lez. 26 |
| **Stile reale** | **griglia di averaging a cap fisso**: 6 ingressi progressivi CONTRO il movimento, size crescente ×1,5, **un solo SL e un solo TP per tutto il pacchetto** | `[I]` da lez. 28+29+30, e vedi §1.1 |
| Timeframe | **H1** | `[T]` lez. 28: _"dobbiamo controllare il grafico sul time frame H1. La strategia e' stata proprio settata per questo time frame"_ |
| Piattaforma del corso | MT4 | `[T]` lez. 29, 30, 32 |
| Indicatori | SuperTrend + Williams %R | `[T]` lez. 26, 27, 33 |
| Relatrice | **Manuela Negro** | `[T]` lez. 33: _"vi potete contattare all'indirizzo email manuela.negro.alfiobardolla.com"_ (= `manuela.negro@alfiobardolla.com`, la chiocciola si perde nel parlato) — **prima conferma TESTUALE del nome nel corpus** |
| Posizione nel corso | lezioni **26-33**, cioe' **PRIMA** del modulo Breakout (34-40) | `[I]` dalla numerazione |

### 1.1 ⚖️ COME SI CHIAMA DAVVERO — e chi lo dice

🔴 **La relatrice la definisce lei stessa un sistema di martingala**, con questa
parola, in chiaro `[T]` lez. 31:

> _"il fatto di aver inserito diversi ordini su diversi livelli attraverso
> questo sistema con un **rischio variabile, propriamente appunto un sistema di
> Martingala**, ci permettera' di chiudere la posizione non necessariamente in
> stop loss"_

**Non e' un'accusa nostra: e' l'autodefinizione della fonte.** Va agli atti cosi'.

**Ma la classificazione tecnica onesta e' piu' precisa** (vedi il referto §1.3):
- ✅ **c'e' un CAP**: esattamente **6 ingressi**, mai di piu' (§5);
- ✅ **c'e' uno STOP TOTALE HARD**: un unico prezzo di SL, **identico su ogni
  singolo ticket** e **depositato al broker** (`[T]` lez. 30: _"stop loss rimane
  sempre identico per tutte le posizioni"_) — non e' uno stop "sperato";
- ✅ **la perdita massima e' definita PRIMA di entrare** e vale come cifra;
- 🔴 **ma la size CRESCE** con un moltiplicatore geometrico **×1,5** man mano che
  il prezzo va contro (§6), e il pagamento ha la forma tipica della griglia:
  **tante vincite piccole, perdita piena rara e concentrata** (§8).

→ **Etichetta di casa proposta:** _griglia di averaging contro-movimento, a cap
fisso 6, progressione geometrica ×1,5, con stop totale hard sul pacchetto._
**NON e' una martingala illimitata.** **NON e' un scaling neutro.**

---

## 2. 🌍 UNIVERSO OPERATIVO

### 2.1 Strumenti — `[T]` lez. 26, 27, 32, 33 (quattro volte, coincidenti)

**`EURUSD` · `GBPUSD` · `EURGBP`** — e **solo** questi tre.

- lez. 26: _"le coppie euro-dollaro, sterlina-dollaro ed euro-sterlina
  rispondono in modo particolare a questo approccio"_
- lez. 33: _"La strategia e' stata ottimizzata per i cross quali Euro-Dollaro,
  Sterlina-Dollaro ed Euro-Sterlina"_
- 🔒 **Divieto esplicito di estensione** `[T]` lez. 33: _"tutti i parametri sono
  stati valutati appositamente per queste coppie, quindi **non potrai applicare
  questo foglio, utilizzare questo foglio per altre coppie valutarie**"_

> 🚨 **NOTA STRUTTURALE NOSTRA, che il corso non fa mai:** EURUSD, GBPUSD e
> EURGBP **sono un triangolo chiuso** — `EURGBP = EURUSD / GBPUSD` per identita'
> di cambio. **Non sono tre scommesse: sono due gradi di liberta'.** Il corso le
> presenta come diversificazione (lez. 32: _"strategie da inserire nel
> portafoglio in maniera da diversificare"_). **Non lo sono.** `[I]` — aritmetica
> valutaria, non un'affermazione del corso.

### 2.2 ⚠️ Micro-contraddizione: "due coppie" o "tre"? `[T]` lez. 27

> _"la strategia e' stata settata per **due coppie** in particolare,
> l'euro-dollaro ... e poi dobbiamo inserire ancora la sterlina-dollaro"_ ... poi
> subito _"La stessa cosa faremo per un'altra coppia che e' l'euro-sterlina ...
> **Questi tre** sono gli strumenti che a noi servono"_

> ✅ **RISOLTA: TRE.** Il "due" e' un lapsus corretto dalla relatrice stessa
> nella riga successiva, e le lezioni 26, 32 e 33 dicono tre. `[I]`

### 2.3 Sessioni / orari — **[BUCO], e stavolta e' un buco vero**

Il corso **non nomina mai** un orario, una sessione, un filtro temporale.
⚠️ **Differenza importante col modulo Breakout:** li' l'assenza era
**dichiarata** (_"possono essere tradate in qualsiasi momento della giornata"_,
lez. 40). **Qui non c'e' ne' la regola ne' la negazione.** → Non si puo'
scrivere "24/5" come regola del corso: si scrive **BUCO**, e la scelta e'
nostra.

**Conseguenza per il fuso BCM:** irrilevante. Non essendoci orari dichiarati,
**non c'e' nulla da convertire** — e un orario convertito da un fuso mai
dichiarato sarebbe peggio di nessun orario (regola di casa).

### 2.4 Date degli esempi — anno mai dichiarato `[BUCO]`

Gli esempi citano _"4 di aprile"_, _"17 di aprile"_, _"22 di febbraio"_,
_"28 febbraio"_ (lez. 31). **L'anno non viene mai pronunciato.** Non si possono
riverificare sui nostri dati senza chiederlo.

---

## 3. 🔧 INDICATORI E LORO PARAMETRI

| indicatore | parametro | valore | fonte |
|---|---|---|---|
| Williams %R | periodo | **140** | 🟢 `[T]` **TRE volte**: lez. 26 (×2), lez. 27, lez. 33 |
| Williams %R | soglia ipercomprato | **W >= −20** | `[I]` da §3.2 |
| Williams %R | soglia ipervenduto | **W <= −80** | `[T]` lez. 28: _"deve aver proprio superato la linea del meno 80"_ |
| Williams %R | linea mediana | **−50** | `[T]` lez. 28, 31, 33 |
| SuperTrend | periodo ATR | **[BUCO]** | mai detto in 26-33 |
| SuperTrend | moltiplicatore | **[BUCO]** | mai detto in 26-33 |

### 3.1 ✅ WILLIAMS 140 — QUI SI CHIUDE IL NODO APERTO DEL MODULO BREAKOUT

Nella `BREAKOUT_CORSO_SPEC.md` §3.2 il "140" era **una singola occorrenza in
54.787 caratteri**, marcata 🔴 _"fonte singola, da confermare"_.

**In questo modulo compare TRE volte in TRE lezioni diverse:**
- lez. 26: _"Prestate attenzione al setup dell'indicatore, ricorda che **deve
  essere settato a 140 periodi**. Questo setup non e' casuale, e' stato
  studiato"_ + _"Supertrend e Williams **a 140 periodi**"_
- lez. 27: _"A noi servira' soltanto il Supertrend e il Williams Percent Range
  **a 140 periodi**"_
- lez. 33 (riepilogo/PDF): _"Ricordiamo l'indicatore e' **settato a 140
  periodi**"_

> ✅ **VERDETTO: 140 e' il valore del corso, fuori discussione.** Quattro
> occorrenze totali su due moduli, incluso il PDF riepilogativo, piu' la
> conferma diretta di Claudio sul video. **Il sospetto "storpiatura di 14"
> e' definitivamente caduto.** ⚠️ Restano **una sola fonte umana** (stessa
> relatrice), ma il dubbio era di trascrizione, e quello e' chiuso.

> 🔒 **18/08 sera — CADE ANCHE L'ULTIMA RISERVA: la "sola fonte umana" NON
> VALE PIU'.** Il **modulo base** (capitolo indicatori, coach **Leonardo
> Fasciano**) detta lo stesso valore, ed e' **la prima fonte indipendente**:
>
> `[TRASCRITTO chiaro, lez. 13 modulo base "WILLIAM PERCENT RANGE, CCI E RSI"]`
> > _"inseriamo il Williams Percent Range. In questo caso **ti consiglio di
> > settarlo a 140 periodi, quindi dove troverai la voce Period modifica e
> > scrivi 140**, che sara' **funzionale per la strategia che imparerai nel corso
> > del Master**. ... **140 periodi e' sicuramente un valore molto alto per questo
> > tipo di indicatore**"_
>
> ✅ **Cinque occorrenze, DUE fonti umane indipendenti (Negro + Fasciano), e in
> questa il valore e' un'istruzione di digitazione accompagnata dal commento
> sull'anomalia del numero.** Il 140 e' acquisito.
> ➡️ `caccia_strategie/ANALISI_MODULI_BASE_2026-08-18.md` §2.2.

### 3.2 🔴 SUPERTREND — IL BUCO E' LO STESSO, MA ORA SAPPIAMO DOV'E' LA RISPOSTA

Il corso lo usa in **ogni** lezione e **non ne detta mai i parametri**. Ma qui
la catena si chiude di un anello:

- `[T]` lez. 26: _"Ecco il setup che voi avete gia' sicuramente costruito
  **insieme a Leonardo** in precedenza"_
- `[T]` lez. 27: _"hai gia' sul monitor alcuni indicatori che hai **installato
  nei video precedenti**"_

E il modulo Breakout (lez. 35) diceva: _"Abbiamo salvato il nostro setup di base
... Lo abbiamo fatto **nel modulo precedente**"_.

> 🎯 **CATENA RICOSTRUITA** `[I]`, da tre citazioni in due moduli:
> **Breakout (34-40) → rimanda a → Mediazione (26-33) → rimanda a → il modulo di
> LEONARDO (lezioni < 26).**
>
> ➡️ **I parametri del SuperTrend stanno nel modulo di Leonardo, prima della
> lezione 26.** Non e' piu' "un modulo precedente non identificato": ha un
> nome e una collocazione. **E' la richiesta n.1 per Claudio.**

> 🔴🔴 **18/08 sera — LA CATENA E' STATA PERCORSA FINO IN FONDO, E TERMINA A
> VUOTO. La frase qui sopra ("sappiamo dov'e' la risposta") NON REGGE PIU'.**
>
> **Il modulo di Leonardo e' stato trovato e letto:** e' il **capitolo indicatori
> del modulo base "Piattaforma", lezioni 8-14**.
> `[T]` lez. 8 modulo base: _"**Sono Leonardo Fasciano**, coach in area trading in
> Alfio Bardolla Training Group e in questo capitolo ... **Ogni strategia
> utilizzera' determinati indicatori**"_
>
> **E li' dentro il SuperTrend viene applicato COI DEFAULT, senza che un solo
> parametro venga pronunciato:**
> `[TRASCRITTO chiaro, lez. 10 modulo base "COS'E' IL SUPERTRAND"]`
> > _"L'indicatore super trend ha degli input, cioe' ha dei **parametri
> > modificabili**, che anche in questo caso, ti ricordo, sono **parametri che
> > andrai a settare sulla base della strategia che andrai ad applicare**.
> > **Facciamo ok senza fare nessuna variazione**"_
>
> ⛔ **Il buco n.1 non e' un buco di COPERTURA: e' un buco del CORSO.** Il modulo
> rimanda alla strategia, la strategia rimanda al modulo: **rimando circolare,
> mai chiuso in nessun punto.** Non esiste una lezione da chiedere.
>
> 🥇 **UNICA STRADA RIMASTA, ed e' tre click:** il SuperTrend e' un **`.ex4`
> allegato alla lezione 10** (`[T]` _"troverai sotto questo video in un formato
> scaricabile ... Il formato .ex4"_) e il coach lo applica premendo OK: **i
> default di quel file SONO i parametri del corso.** Scaricarlo, trascinarlo su
> un grafico, fotografare la finestra input.
> ➡️ `caccia_strategie/ANALISI_MODULI_BASE_2026-08-18.md` §2.1.

### 3.3 Soglie del Williams — verificate su valori numerici letti a schermo

A differenza del Breakout (dove le soglie erano pura inferenza), qui la
relatrice **legge i numeri ad alta voce**:
- `[T]` lez. 28, BUY: _"verifichiamo se l'indicatore e' uscito dall'area di meno
  80, in questo caso si trova a **meno 78,46**, allora possiamo ritenere che
  questo sia un valido segnale"_ → conferma soglia OS = **−80**
- `[T]` lez. 28, SELL: _"l'indicatore si posiziona a **meno 22,93**, quindi e'
  un indicatore che e' uscito dal livello di meno 20"_ → conferma soglia OB =
  **−20**
- `[T]` lez. 31: _"il Williams ... ha mantenuto un livello di **meno 49**, quindi
  siamo all'interno dell'area appunto di ipercomprato ancora"_ → conferma la
  mediana **−50** come confine di validita'

> ✅ **Le soglie −20 / −80 / −50 sono confermate da valori letti**, non solo
> inferite. **Questo e' il modulo che chiude anche questa ambiguita' del
> Breakout.**

---

## 4. 🎯 IL SEGNALE DI INGRESSO

### 4.1 Le tre condizioni, in SEQUENZA (qui l'ordine conta — diverso dal Breakout)

**BUY** `[T]` lez. 28 + 33:

| # | condizione | fonte |
|---|---|---|
| C1 | Il Williams **e' entrato** in ipervenduto (`W <= −80`) | `[T]` lez. 28: _"Abbiamo bisogno che l'indicatore Williams si trovi nell'area di ipervenduto. Mi raccomando, deve aver proprio superato la linea del meno 80"_ |
| C2 | **Poi** il SuperTrend **cambia colore** rosso → verde | `[T]` lez. 28: _"aspettiamo la prima rottura in senso contrario del supertrend ... da rosso e' diventato verde"_ · lez. 33: _"il segnale sara' dato dal super trend che **deve cambiare colore**"_ |
| C3 | **Sulla candela di chiusura del cambio colore** il Williams dev'essere **uscito** da −80 **ma non oltre −50** → banda **[−80, −50]** | `[T]` lez. 28 + lez. 33: _"dovra' oscillare tra l'area di meno 50 e meno 80"_ |

**SELL**: speculare, banda **[−50, −20]**, SuperTrend verde → rosso.
`[T]` lez. 33: _"Per un'operazione di vendita e' necessario che l'indicatore
Williams si trovi nell'area di ipercomprato, quindi tra meno 20 e meno 50.
Inoltre e' necessario che il super trend sia di colore rosso."_

### 4.2 🔑 LA REGOLA DELL'ATTESA — meccanizzabile e dettata con precisione

`[T]` lez. 28:
> _"Controllo che **su questa candela di chiusura** il Williams sia uscito
> dall'area di ipervenduto, **altrimenti attendo la candela successiva**"_

→ **Regola R-ATTESA:** se al cambio colore del SuperTrend il Williams e' ancora
dentro la zona estrema, **non si scarta il segnale: si aspetta**, candela per
candela, finche' il Williams non entra nella banda. **Se pero' supera la
mediana −50 prima di dare il segnale, il segnale e' MORTO** (§4.3).

### 4.3 🚫 L'INVALIDATORE: oltre la mediana e' troppo tardi

`[T]` lez. 28, con la motivazione:
> _"e' necessario che il Williams, malgrado appunto la sua uscita dall'area di
> ipervenduto, **non abbia superato la prima meta', cioe' non sia oltre il
> livello di meno 50**, perche' in quel caso potrebbe verificarsi magari una
> situazione di inversione in atto, vorrebbe dire che **il mercato ha gia'
> scaricato il movimento, quindi sarebbe troppo tardi per noi entrare**"_

→ **Meccanizzabile senza ambiguita': banda chiusa, con un lato che e' un
requisito e l'altro che e' una scadenza.**

⚠️ `[T]` **lapsus della relatrice** nella stessa riga: _"se il Williams si trova
nell'area di **ipercomprato**, o meglio nella sua prima meta' tra meno 80 e meno
50"_ — in un setup **BUY** da ipervenduto. La banda numerica (−80/−50) e' quella
giusta, la parola no. **Errore verbale evidente**, stessa classe di quello
trovato nel Breakout lez. 36.

### 4.4 L'ancora: la CHIUSURA della candela di segnale

`[T]` martellata quattro volte (lez. 28, 31, 33 ×2):
> _"abbiamo bisogno soltanto di un valore che e' **la chiusura della candela del
> segnale**"_ · _"i livelli vanno calcolati sempre dal segnale d'ingresso"_ ·
> _"anche se noi dovessimo arrivare a distanza di diverse ore dal momento del
> segnale, i livelli di entrata, gli stop, i target **vanno comunque calcolati a
> partire dal momento del segnale**, quindi lo dovete ricostruire a ritroso"_ ·
> _"l'**unico parametro** da inserire nel foglio Excel"_

→ **Identico al Breakout.** Un solo numero `C` regge tutta la geometria.

---

## 5. 🧮 LA GEOMETRIA — LE TRE FORMULE (il cuore della spec)

### 5.1 Il parametro per cross `[T]` lez. 29

| cross | parametro `P` | citazione |
|---|---|---|
| **EURUSD** | **40 pip** | _"Per l'euro-dollaro utilizzeremo un parametro di 40 pip"_ |
| **GBPUSD** | **70 pip** | _"Per la sterlina dollaro ... un parametro di stop loss pari a 70 pip"_ |
| **EURGBP** | **20 pip** | _"se stiamo tradando l'euro-sterlina questo parametro ammontera' a 20"_ |

⚠️ `[T]` **errore verbale nella stessa riga**: _"per la sterlina dollaro
utilizzeremo invece un parametro di 20 pip"_ — dice due volte "sterlina dollaro"
per due valori diversi. La frase successiva lo corregge: _"se stiamo tradando
l'**euro-sterlina** questo parametro ammontera' a 20"_. ✅ **Risolto: 20 e'
EURGBP.** E lo conferma l'aritmetica dell'esempio EURGBP (§5.4).

⚠️ **Il nome "parametro di stop loss" e' fuorviante e va disinnescato:** `P`
**NON e' la distanza dello stop** (che vale `3P`). `P` e' una costante di scala
del cross, usata (a) per dimensionare la griglia e (b) come input al
calcolatore di volume. `[I]` da aritmetica §5.2.

### 5.2 🔥 LE FORMULE

Sia `C` = chiusura della candela di segnale, `d = +1` per BUY / `d = −1` per
SELL, `P` = parametro del cross in pip, `pip` = 0,0001 (tutti e tre i cross
sono a 4/5 decimali).

```
LIVELLO k  (k = 0..5) :  L_k = C − d · k · (P/2) · pip     ← 6 livelli, passo P/2
STOP LOSS (unico)     :  SL  = C − d · 3P · pip            ← = L_5 − d · (P/2)
TAKE PROFIT (unico)   :  TP  = C + d · P · pip
```

- I sei livelli si aprono **contro** la direzione dell'operazione (BUY → verso il
  basso; SELL → verso l'alto). **E' l'averaging.**
- Lo SL sta **esattamente un passo oltre l'ultimo livello**.
- Ampiezza totale della griglia: `2,5 P` (da L_0 a L_5). Ampiezza SL: `3 P`.
- **Un solo SL e un solo TP per tutti e sei i ticket** `[T]` lez. 30: _"ogni
  posizione avra' un livello di ingresso diverso, ma **identico stop loss e take
  profit dell'operazione**"_ — ripetuto sei volte di fila mentre inserisce gli
  ordini.

`[I]` **ricavate per aritmetica dai tre esempi dettati.** Il corso **non
pronuncia mai** una formula: mostra solo i numeri che il foglio restituisce.
**Le formule sono nostre; i numeri che le verificano sono suoi.**

### 5.3 ✅ VERIFICA 1 — GBPUSD BUY (lez. 28 + 30), `P = 70`

`C = 1,2502` (`[T]` _"close 1,25 e 0,2"_)

| voce | formula | risultato | dettato dal corso? |
|---|---|---|---|
| L0 | C | **1,2502** | ✅ `[T]` |
| L1 | C − 35 pip | **1,2467** | ✅ `[T]` _"il secondo e' su 1,24 e 67"_ |
| L2 | C − 70 pip | **1,2432** | ✅ `[T]` |
| L3 | C − 105 pip | **1,2397** | ✅ `[T]` |
| L4 | C − 140 pip | **1,2362** | ✅ `[T]` |
| L5 | C − 175 pip | **1,2327** | ✅ `[T]` _"e l'ultimo 1,23 e 27"_ |
| **SL** | C − 210 pip (= 3P) | **1,2292** | ✅ `[T]` |
| **TP** | C + 70 pip (= P) | **1,2572** | ✅ `[T]` |

**8 valori su 8. Zero scarto.**

### 5.4 ✅ VERIFICA 2 — EURGBP SELL (lez. 28 + 30), `P = 20`

`C = 0,8598` `[T]`

| voce | formula | risultato | dettato? |
|---|---|---|---|
| L0..L5 | C + k·10 pip | **0,8598 / 0,8608 / 0,8618 / 0,8628 / 0,8638 / 0,8648** | ✅ `[T]` **tutti e sei**, lez. 30 |
| **SL** | C + 60 pip (= 3P) | **0,8658** | ✅ `[T]` |
| **TP** | C − 20 pip (= P) | **0,8578** | ✅ `[T]` |

**8 su 8. Cross diverso, parametro diverso, direzione opposta: la formula
regge.**

### 5.5 ✅ VERIFICA 3 — EURUSD SELL del 22 febbraio (lez. 31), `P = 40`

`C = 1,0823` `[T]` _"un livello di chiusura di 1, 0, 8 e 23"_

| voce | formula | risultato | dettato? |
|---|---|---|---|
| **SL** | C + 120 pip (= 3P) | **1,0943** | ✅ `[T]` _"Stop Loss a 1, 0, 9 e 43"_ |
| **TP** | C − 40 pip (= P) | **1,0783** | ✅ `[T]` _"Take Profit a 1, 0, 7 e 83"_ |
| L0, L1, L2 | C + k·20 pip | **1,0823 / 1,0843 / 1,0863** | ✅ `[T]` _"soltanto questi tre livelli rispettivamente a 1.08.23, 1.08.43 e 1.08.63"_ |

**5 su 5, sul TERZO cross e sul terzo parametro.**

> 🏆 **TOTALE: 21 valori numerici predetti dalle tre formule, 21 confermati dal
> parlato, su 3 cross e 3 parametri diversi. Nessuna eccezione.**
> **La scatola nera del corso e' aperta.**

---

## 6. 📦 LA SIZE — LA PROGRESSIONE ×1,5

### 6.1 I volumi dettati `[T]` lez. 30

**GBPUSD — tutti e sei:**
`0,04` · `0,06` · `0,09` · `0,14` · `0,20` · `0,30` lotti

**EURGBP — cinque su sei** (il sesto non viene pronunciato):
`0,06` · `0,09` · `0,14` · `0,20` · `0,30` · **[0,45 inferito]**

### 6.2 🧮 LA LEGGE: geometrica di ragione **1,5**, arrotondata a 2 decimali

| k | `0,04 × 1,5^k` | arrotondato | dettato |
|---|---|---|---|
| 0 | 0,0400 | **0,04** | ✅ 0,04 |
| 1 | 0,0600 | **0,06** | ✅ 0,06 |
| 2 | 0,0900 | **0,09** | ✅ 0,09 |
| 3 | 0,1350 | **0,14** | ✅ 0,14 |
| 4 | 0,2025 | **0,20** | ✅ 0,20 |
| 5 | 0,3038 | **0,30** | ✅ 0,30 |

**Sei valori su sei.** E la serie EURGBP e' **la stessa traslata di un passo**
(base 0,06 invece di 0,04), il che la conferma una seconda volta.

- **Moltiplicatore: 1,5** `[I]` — il corso **non lo pronuncia mai**.
- **Somma dei fattori** `Σ 1,5^k, k=0..5` = **20,78** → il volume totale del
  pacchetto e' **20,78 volte** il volume del primo livello.
  - GBPUSD: `0,04 × 20,78 = 0,83` lotti (somma effettiva dettata: **0,83** ✅)
  - EURGBP: `0,06 × 20,78 = 1,25` lotti (somma con 0,45 inferito: **1,24** ✅)

> 🔴 **QUESTO E' IL PUNTO CHE DECIDE LA CLASSIFICAZIONE.** Un moltiplicatore
> 1,5 applicato a ingressi che si aprono **mentre il prezzo va contro** e'
> averaging-down progressivo: la posizione piu' grande e' quella **piu' vicina
> allo stop**. E' esattamente cio' che la relatrice chiama _"sistema di
> Martingala"_ (§1.1). **La differenza — decisiva — e' che qui la serie
> FINISCE, e finisce contro un muro (§5.2).**

### 6.3 La base del volume — `[BUCO] parziale` (il solo anello che NON chiude)

Procedura dichiarata `[T]` lez. 29-30:
1. Aprire `cashbackforex.com` → funzione **"lot size calculator"** `[T]`
2. Inserire: strumento, valuta del conto, ammontare del conto, **e `P` come
   "pip di stop"** (70 per GBPUSD, 40 per EURUSD, 20 per EURGBP)
3. Cercare per tentativi la **percentuale di rischio minima che restituisce
   almeno 1 micro-lotto (0,01)** — `[T]` _"se io mettessi 0.02 ... non potrei
   tradarlo in quanto la quantita' sarebbe inferiore al micro lotto ... se
   invece inseriamo un rischio di 0.04, ecco, riusciamo a raggiungere il primo
   micro lotto"_
4. Inserire la coppia (rischio-seme, volume 0,01) nel foglio Excel, che scala
   tutto il resto.

**Semi dichiarati:** GBPUSD → **0,04%** ↔ 0,01 lotti · EURGBP → **0,015%** ↔
0,01 lotti.

🔴 **L'anello rotto:** questa procedura fissa il livello 1 a **0,01 lotti**, ma i
volumi poi dettati partono da **0,04** (GBPUSD) e **0,06** (EURGBP). Per EURGBP
la relatrice spiega il salto (_"possiamo in qualche modo aumentare anche di 5
volte il nostro rischio, quindi andiamo a 0.075 ... possiamo intervenire a
mercato con 6 micro lotti"_ → 0,015% × 5 = 0,075% ↔ 0,06 lotti ✅ **coerente**).
**Per GBPUSD lo stesso salto non viene mai spiegato**: dal seme 0,04% ↔ 0,01
lotti si passa senza transizione a un volume 0,04. E `[T]` lez. 30 dice
letteralmente _"il volume della prima operazione di 0,04, ricordate lo abbiamo
preso dal foglio, eccolo qua, **rischio iniziale**"_ — **chiama "volume" una
cella che nomina "rischio"**.

> ⚖️ **Che cosa NON e' compromesso:** la geometria (§5) e le **proporzioni** di
> rischio (§7.3) chiudono comunque, perche' dipendono solo dai **rapporti** fra
> i volumi, non dal loro valore assoluto.
> **Che cosa E' compromesso:** l'**ancoraggio al capitale**. Vedi §7.4: i due
> conti impliciti differiscono di un fattore **2,29**.
>
> ➡️ **Per un EA questo buco NON e' bloccante**: si sostituisce l'intera
> procedura con un sizing a rischio-% di casa (§10.2). **Ma va dichiarato che
> il sizing e' NOSTRO, non del corso.**

---

## 7. 💰 IL RISCHIO — ARITMETICA COMPLETA

### 7.1 Il principio dichiarato `[T]` lez. 29

> _"Purtroppo noi dobbiamo **frazionare il nostro rischio** in quanto non
> abbiamo un'unica operazione"_ ... _"daremo un **peso maggiore** a questi ordini
> [i piu' bassi, i piu' vicini allo stop] rispetto agli ordini ... messi piu' in
> alto"_

⚠️ **Attenzione: "peso maggiore" e' ambiguo e la relatrice lo usa male.** Lei
motiva la size crescente dicendo che i livelli bassi hanno **meno spazio verso
lo stop e piu' spazio verso il target** — cioe' miglior rapporto rischio/premio.
Ma il risultato aritmetico e' che **la size cresce piu' in fretta di quanto la
distanza dallo stop si accorci**: vedi §7.2, dove i contributi al rischio NON
sono uniformi e il massimo cade sul **livello 4**.

### 7.2 Il rischio livello per livello — GBPUSD, `P = 70`

Distanza dallo SL: `dist_k = (6 − k) · (P/2)`. Contributo al rischio:
`vol_k × dist_k` (in "lotti·pip"; per GBPUSD 1 lotto·pip = 10 USD).

| k | livello | volume | dist. da SL | contributo | quota del rischio |
|---|---|---|---|---|---|
| 1 | 1,2502 | 0,04 | 210 pip | **8,4** | 11,9% |
| 2 | 1,2467 | 0,06 | 175 pip | **10,5** | 14,9% |
| 3 | 1,2432 | 0,09 | 140 pip | **12,6** | 17,8% |
| 4 | 1,2397 | 0,14 | 105 pip | **14,7** | **20,8% ← il massimo** |
| 5 | 1,2362 | 0,20 | 70 pip | **14,0** | 19,8% |
| 6 | 1,2327 | 0,30 | 35 pip | **10,5** | 14,9% |
| | | **0,83 lotti** | | **70,7** | **100%** |

### 7.3 ✅ LA VERIFICA CHE VALIDA TUTTA LA RICOSTRUZIONE

Il corso dichiara `[T]` lez. 29: rischio complessivo **1,76%**, livello 1
**0,21%**, livello 2 **0,26%**, profitto possibile **4,06%**.

| grandezza | ricostruita da noi | dichiarata dal corso | scarto |
|---|---|---|---|
| quota livello 1 | 8,4/70,7 = 11,88% → **0,209%** | **0,21%** | **0,5%** ✅ |
| quota livello 2 | 10,5/70,7 = 14,85% → **0,261%** | **0,26%** | **0,4%** ✅ |
| profitto totale | (vedi sotto) → **4,026%** | **4,06%** | **0,8%** ✅ |

**Profitto a TP con tutti e sei riempiti** (`TPdist_k = P + k·(P/2)`):

| k | volume | dist. da TP | contributo |
|---|---|---|---|
| 1 | 0,04 | 70 | 2,8 |
| 2 | 0,06 | 105 | 6,3 |
| 3 | 0,09 | 140 | 12,6 |
| 4 | 0,14 | 175 | 24,5 |
| 5 | 0,20 | 210 | 42,0 |
| 6 | 0,30 | 245 | **73,5** |
| | | | **161,7** |

`161,7 / 70,7 = **2,287**` → **rapporto rischio/rendimento del pacchetto pieno =
1 : 2,29**, contro `4,06 / 1,76 = 2,307` dichiarati. ✅

> 🏆 **Tre percentuali del corso riprodotte da zero, con errore sotto l'1%.**
> Questa e' la verifica piu' forte che questo formato consenta: la ricostruzione
> non e' plausibile, e' **aritmeticamente vincolata**.

### 7.4 🔴 L'INCOERENZA CHE RESTA: due capitali diversi, fattore 2,29

- Dal **rischio dichiarato**: `70,7 lotti·pip × 10 USD = 707 USD` = 1,76% →
  **conto ≈ 40.000**.
- Dal **seme di volume** (0,01 lotti × 70 pip = 7 USD = 0,04%) →
  **conto ≈ 17.500**.
- **Rapporto: 2,29** — che coincide col rapporto rischio/rendimento (§7.3).
  Coincidenza sospetta ma **non spiegabile dal parlato**.

E lo stesso identico fattore ricompare nell'esempio EURGBP: seme 0,015% ↔ 0,01
lotti a 20 pip → conto ≈ 15.600; rischio ricostruito del pacchetto ≈ **2,26%**
contro l'**1%** dichiarato. **Fattore 2,26.** `[I]`

> ⚖️ **Conclusione onesta: e' l'unico punto che il solo audio non chiude.**
> O il foglio calcola il "rischio complessivo" con una normalizzazione non
> spiegata, o la relatrice legge la colonna sbagliata (§6.3). **Solo il file
> Excel lo scioglie.** → domanda per Claudio.
>
> 🚨 **E la direzione dell'errore e' quella che ci preoccupa:** se la
> ricostruzione e' giusta, **il rischio vero del pacchetto e' 2,29 volte quello
> che il foglio mostra all'utente.** 1,76% dichiarati = **4,03% reali**.
> **Va verificato prima di qualunque uso, non dopo.**

### 7.5 Le regole di money management dichiarate

| voce | valore | fonte |
|---|---|---|
| Rischio base | **1% per pacchetto** | `[T]` lez. 30: _"Almeno cerchiamo di mantenere un rischio pari all'1%"_ · lez. 32 · lez. 33 |
| R:R minimo | **1 : 2** | `[T]` lez. 29 e 33 |
| Storico prima di alzare il rischio | **>= 20 operazioni** | `[T]` lez. 33 |
| Tetto di drawdown | **20%** | `[T]` lez. 32: _"si consigliano dei drawdown complessivi intorno a un 20%"_ |
| Tetto di drawdown | **3%** | 🔴 `[T]` lez. 33: _"vi consiglio, infatti, di non andare al di la' del 3% come rischio, appunto, di drawdown"_ |

🔴 **CONTRADDIZIONE 20% vs 3%**, a **due lezioni di distanza**, e la seconda e'
**la lezione di riepilogo (il PDF)**. Non e' risolvibile per argomento: sono due
numeri, non due formulazioni. `[?]` **APERTA.** Il 20% coincide col Breakout
(lez. 39/40), il 3% no. **Ipotesi nostra `[I]`: il "3%" e' un lapsus per "3% di
rischio per operazione"** (la lez. 32 simula proprio rischio 1% e 3%) — ma e'
un'ipotesi, non una lettura.

⚠️ **Nessun cap sul numero di pacchetti simultanei** `[BUCO]`. Nell'esempio del
corso ne girano **due insieme** (GBPUSD a 1,76% + EURGBP a 1%) senza che il tema
venga sfiorato.

---

## 8. 📉 IL PROFILO DI PAGAMENTO — quello che il corso non mostra mai

`[I]` **interamente aritmetica nostra**, con i numeri del corso (GBPUSD, `P=70`).
Il corso **non presenta mai** questa tabella.

Se il prezzo scende toccando **k** livelli e poi risale fino al TP:

| livelli riempiti | profitto (lotti·pip) | in % (scala 1,76%/70,7) | esito |
|---|---|---|---|
| 1 | 2,8 | **+0,07%** | briciola |
| 2 | 9,1 | **+0,23%** | |
| 3 | 21,7 | **+0,54%** | il caso del 22 feb. |
| 4 | 46,2 | **+1,15%** | |
| 5 | 88,2 | **+2,20%** | |
| **6** | **161,7** | **+4,03%** | il massimo |
| **6 → SL** | −70,7 | **−1,76%** | **la perdita piena** |

> 🔴 **ECCO LA FORMA DEL PAGAMENTO, ed e' quella classica della griglia:**
> 1. **Il guadagno e' concentrato negli ultimi due livelli**: `L5` e `L6` da soli
>    valgono **il 72%** del profitto massimo. Con 3 livelli su 6 riempiti si
>    porta a casa **lo 0,54%**, cioe' **meno di un terzo del rischio**.
> 2. **Il profitto grande e la perdita piena stanno sullo STESSO ramo**: per
>    incassare +4,03% il prezzo deve prima scendere **175 pip** (riempire tutto)
>    e poi risalire **245 pip**. Ma da L6 lo stop dista **35 pip**. **Si guadagna
>    tanto solo quando si e' a 35 pip dal disastro.**
> 3. **Il ramo perdente e' piu' corto di quello vincente**: −210 pip in una
>    direzione contro un'andata-e-ritorno di 420 pip.
>
> **Conseguenza sul win rate necessario** `[I]`: se la vincita tipica e' quella
> a 3 livelli (+0,54%) e la perdita piena e' −1,76%, il pareggio richiede un
> **win rate del 76,5%**. Se la vincita tipica e' a 4 livelli (+1,15%), serve
> comunque il **60,5%**. **Il corso non dichiara mai il win rate** (§9). **E'
> il numero che decide se la strategia esiste, ed e' assente.**

---

## 9. 📊 NUMERI DI PERFORMANCE DICHIARATI — lez. 32

> 🔴 **TUTTI `[dichiarati dal corso, NON verificati da noi]`.** Fonte: la sola
> lez. 32, che commenta **un foglio di calcolo mostrato a schermo e mai
> dettato**.

| voce | valore | citazione |
|---|---|---|
| Universo del test | **solo EURUSD** | `[T]` _"tutte le operazioni individuate **esclusivamente sulla coppia euro-dollaro**"_ |
| Periodo | _"ultimi due anni"_ | `[T]` — **date esatte [BUCO]** |
| Capitale | **5.000 EUR** | `[T]` |
| **rischio 1%** → profitto | **+30%** | `[T]` _"qui e' stato raggiunto un profitto del 30%"_ |
| **rischio 1%** → DD | **4%** | `[T]` |
| **rischio 3%** → profitto | **+90%** | `[T]` _"che invece del 30% raggiunge il 90%"_ |
| **rischio 3%** → DD | **12%** | `[T]` _"passa dal 4% al 12%"_ |
| **rischio 3%** → capitale finale | **9.492 EUR** | `[T]` |
| N. operazioni · win rate · broker · spread · date | **[BUCO] ×5** | mai dichiarati |

### 9.1 🧨 IL CORSO AMMETTE DA SOLO CHE NON SONO DUE SIMULAZIONI

`[T]` lez. 32, la relatrice **descrive il metodo**:
> _"potete andare a simulare un eventuale rischio differente, quindi
> **moltiplicando per 2 o per 3 quelli che sono i profitti e le perdite maturate
> in questo vostro primo storico**"_

→ Lo scenario a 3% **e' lo scenario a 1% moltiplicato per 3 con una
calcolatrice**. E infatti: `30 × 3 = 90` ✅ · `4 × 3 = 12` ✅ — **entrambi
esatti al punto percentuale**.

> ⚖️ **Tre conseguenze, tutte pesanti:**
> 1. **Non sono due conferme: sono UNA lista di operazioni ri-scalata.**
> 2. **Non c'e' compounding.** Un motore che capitalizza non produce profitti
>    e DD *entrambi* esattamente proporzionali al rischio. Il "+30%" e' quindi
>    la somma di P&L a size costante, non una curva di crescita.
> 3. 🔁 **RETROAZIONE SUL MODULO BREAKOUT:** nella `BREAKOUT_CORSO_SPEC.md`
>    §9.2(a) avevamo **dedotto per aritmetica** che gli scenari 1%/3% della
>    lez. 39 erano una ri-scalatura. **Qui la stessa autrice lo dice
>    esplicitamente.** L'inferenza e' ora **confermata dalla fonte**: si puo'
>    promuovere da `[I]` a `[T]` (per il metodo, non per i numeri).

### 9.2 Le altre crepe

- 🔴 **Il test e' su UN cross, ma la strategia si vende su TRE.** `[T]`: _"questi
  valori dovranno poi essere aumentati anche delle operazioni individuate sugli
  altri coppie"_ — cioe' si **estrapola in alto il profitto** su due coppie non
  testate, **senza estrapolare in alto il rischio** e senza dire che le tre
  coppie sono un triangolo chiuso (§2.1).
- 🔴 **Il DD dichiarato non e' un max DD di equity.** `[T]` la definizione data:
  _"il drawdown, cioe' la **sequenza di perdite consecutive** che sono state
  registrate sul conto"_. → E' un conteggio su P&L **chiusi**, che **ignora
  completamente il flottante** — e in una griglia il flottante e' esattamente
  dove vive il rischio. **Il "4%" e il nostro "max DD" non misurano la stessa
  cosa.** ⚠️ Attenuante: qui il flottante e' limitato dallo SL hard.
- 🟠 **"drawdown effettivo" vs "atteso"**: mai definiti, come nel Breakout.
- 🟠 **Coerenza col Breakout:** la lez. 39 del Breakout diceva che la mediazione
  faceva _"intorno al 27-30%"_. La lez. 32 dice **30%**. ✅ **Coerenti** — ma
  **e' la stessa autrice: una fonte, non due.**

---

## 10. 🛠️ COSA SERVE A UN EA — riepilogo implementativo

### 10.1 Regole direttamente codificabili (nessuna scelta nostra)

```
TF = H1;  SIMBOLI = {EURUSD (P=40), GBPUSD (P=70), EURGBP (P=20)}
W = iWPR(140)                                   // su candele CHIUSE

// tracciamento zona
se W <= -80  -> armaBUY  = true;  disarma SELL
se W >= -20  -> armaSELL = true;  disarma BUY

// segnale BUY (speculare per SELL)
se armaBUY e SuperTrend passa ROSSO->VERDE alla chiusura di candela:
    se W > -80 e W < -50   -> SEGNALE, C = Close(candela)
    se W <= -80            -> attendi la candela successiva (R-ATTESA)
    se W >= -50            -> segnale MORTO, disarma

// geometria (un solo SL, un solo TP)
L[k] = C - d*k*(P/2)*pip,  k = 0..5
SL   = C - d*3*P*pip
TP   = C + d*1*P*pip

// ordini: 6 pendenti (limit se oltre il prezzo corrente nel verso avverso,
//         stop se dalla parte opposta), tutti con lo STESSO SL e TP
vol[k] = base * 1.5^k   (arrotondato al passo di volume del broker)

// chiusura del pacchetto
- TP colpito                                      -> ciclo chiuso
- SL colpito                                      -> ciclo chiuso, segnale morto
- Williams raggiunge la zona OPPOSTA              -> CHIUDI TUTTO a mercato
- riapertura: consentita UNA SOLA VOLTA, dopo un TP, e solo se al TP il
  Williams era ancora entro -50 dalla sua zona; stessi L[k], SL, TP
```

### 10.2 Le scelte che dobbiamo fare NOI (e vanno dichiarate come nostre)

| # | scelta | perche' e' nostra |
|---|---|---|
| 1 | **Parametri SuperTrend** | 🔴 `[BUCO]` bloccante. Coerenza col Breakout (decisione di Claudio, 18/08): **ATR 10 / mult 3,0** come **assunzione dichiarata** |
| 2 | **Sizing** | Il seme del corso non chiude (§6.3/§7.4). Si usa il sizing a rischio-% di casa: si fissa il **rischio del PACCHETTO** e si ricava `base` da `Σ vol_k·dist_k` |
| 3 | **Chiusura anticipata: Williams in zona opposta, o segnale completo opposto?** | 🔴 contraddizione 31 vs 33 (§11.1) |
| 4 | **Ordini pendenti o ingressi a mercato al tocco** | il corso usa pendenti `[T]`; per un EA e' equivalente ma cambia lo slippage |
| 5 | **Numero massimo di pacchetti simultanei** | `[BUCO]` — proposta: **1 per cross, e cap sul totale** |
| 6 | **Filtro news / orari** | `[BUCO]` totale (§2.3) |
| 7 | **Scadenza dei pendenti** | il corso dice "restano finche' il segnale e' valido" `[T]`; serve una regola di pulizia esplicita |

### 10.3 🧪 IL TEST-CASE DI REGRESSIONE (dal corso, verificato)

Tre casi pronti da mettere in `OnInit` con `InpAutoTest`, uno per cross:

| # | cross | dir | `C` | attesi |
|---|---|---|---|---|
| A | GBPUSD (P=70) | BUY | 1,2502 | L = 1,2502 / 1,2467 / 1,2432 / 1,2397 / 1,2362 / 1,2327 · SL 1,2292 · TP 1,2572 |
| B | EURGBP (P=20) | SELL | 0,8598 | L = 0,8598 / 0,8608 / 0,8618 / 0,8628 / 0,8638 / 0,8648 · SL 0,8658 · TP 0,8578 |
| C | EURUSD (P=40) | SELL | 1,0823 | L0/L1/L2 = 1,0823 / 1,0843 / 1,0863 · SL 1,0943 · TP 1,0783 |

**+ test sui volumi:** base 0,04 → `0,04 / 0,06 / 0,09 / 0,14 / 0,20 / 0,30`
**+ test sul rischio:** con i volumi sopra, quota livello 1 = 11,9% del totale,
livello 2 = 14,9%, RR pacchetto pieno = 2,29.

⚠️ **Differenza importante dal Breakout:** li' il test-case del corso conteneva
**un errore aritmetico della relatrice** (R arrotondato da 39 a 40 pip). **Qui
i 21 valori chiudono tutti al centesimo di pip: nessuna correzione da fare.**

---

## 11. ⚔️ CONTRADDIZIONI E AMBIGUITA' — l'elenco completo

| # | punto | dove | esito |
|---|---|---|---|
| 1 | **"due coppie" vs "tre"** | lez. 27 | ✅ **TRE** — corretto dalla relatrice due righe dopo |
| 2 | **"per la sterlina dollaro ... 20 pip"** (secondo il quale GBPUSD avrebbe due parametri) | lez. 29 | ✅ **lapsus: 20 e' EURGBP** — corretto due frasi dopo, e confermato dall'aritmetica |
| 3 | **"se il Williams si trova nell'area di ipercomprato ... tra meno 80 e meno 50"** in un setup BUY | lez. 28 | ✅ **lapsus** — la banda numerica e' giusta, la parola no |
| 4 | **livello di ingresso 1,2502 vs "1,25 e 0,6"** | lez. 28 vs 29 | ✅ **1,2502** — lo impone la griglia (§5.3); il "1,2506" e' errore di trascrizione |
| 5 | **take profit "1,2575"** una volta sola | lez. 30 | ✅ **1,2572** — dettato 5 volte su 6 |
| 6 | **"lavoreremo tra 0,86 e 48 e 0,85 e 96"** (0,8596 non e' ne' L0 ne' TP) | lez. 28 | 🟠 `[TRASCRITTO dubbio]` — probabile 0,8598. Irrilevante |
| 7 | 🔴 **tetto DD: 20% (lez. 32) vs 3% (lez. 33)** | 32 vs 33 | 🔴 **APERTA** — due numeri, non due formulazioni (§7.5) |
| 8 | 🔴 **chiusura anticipata: basta il Williams in zona opposta, o serve il segnale completo opposto?** | 31 vs 33 | 🔴 **APERTA** — vedi §11.1 |
| 9 | 🟠 **riapertura dopo STOP LOSS** | lez. 31 la ammette, lez. 33 dice che lo SL uccide il segnale | 🟡 **conciliabile**: la 31 descrive una **nuova uscita del Williams** = segnale nuovo, non riuso. Ma la 31 aggiunge _"a partire dai livelli piu' alti rispetto allo stop"_, che e' una regola geometrica **mai specificata altrove** → resta un `[BUCO]` |
| 10 | 🔴 **il seme del volume non si allaccia ai volumi dettati (fattore 2,29)** | 29 vs 30 | 🔴 **APERTA** — §7.4, **la piu' pericolosa delle tre** |

### 11.1 L'ambiguita' n.8, per esteso — perche' cambia molte operazioni

- `[T]` **lez. 33 (il PDF)**: _"il segnale non sara' piu' valido **se il Williams
  raggiunge l'area di scarico opposta** rispetto a quella di ingresso"_ →
  **basta il Williams.**
- `[T]` **lez. 31**, che pero' nel suo unico esempio **aspetta di piu'**: dopo
  aver visto il Williams passare in ipervenduto dice _"La chiuderemo infatti nel
  momento in cui avremo il **nuovo segnale di acquisto**, quindi attenderemo
  l'uscita del Williams dall'area di ipervenduto, il segnale ... di **rottura
  del Supertrend** che e' avvenuto con la candela del 28 febbraio"_ → **serve il
  segnale completo opposto** (SuperTrend incluso).

> ⚖️ **Le due regole distano diverse candele**, e in mezzo la posizione resta
> aperta con fino a 6 ticket. **Va trattata come input A/B**, e la scelta e'
> nostra. `[?]`
>
> 🟢 **Lettura che concilia:** la 33 dice quando il segnale **smette di essere
> valido per nuovi ingressi**; la 31 dice quando si **chiude a mercato**. Sono
> due eventi diversi. `[I]` — **e' la lettura piu' economica**, ma il corso non
> la formula mai.

---

## 12. 🕳️ I BUCHI — elenco secco

| # | buco | peso |
|---|---|---|
| 1 | **Parametri SuperTrend** (ATR + moltiplicatore) | 🔴 **BLOCCANTE** — ~~sono nel modulo di **Leonardo** (§3.2)~~ 🆕 **18/08 sera: il modulo di Leonardo e' stato letto e NON LI CONTIENE** (lez. 10 del modulo base: _"Facciamo ok senza fare nessuna variazione"_). **Non e' un buco di copertura, e' un buco del corso** (§3.2). Unica strada: i **default del `.ex4` allegato alla lezione** |
| 2 | **Aggancio seme-volume / capitale** (fattore 2,29) | 🔴 **grave** — decide se il rischio vero e' 1,76% o 4,03% |
| 3 | **Win rate del backtest** | 🔴 **grave** — senza, §8 non e' decidibile |
| 4 | N. operazioni, date, broker, spread del backtest | 🔴 ×4 |
| 5 | Filtro orario / sessioni | 🟠 assenza **non dichiarata** (a differenza del Breakout) |
| 6 | Filtro news | 🟠 mai nominato |
| 7 | Cap di pacchetti simultanei sui 3 cross | 🟠 mai nominato, e l'esempio ne mostra 2 |
| 8 | Geometria della riapertura dopo stop ("livelli piu' alti rispetto allo stop") | 🟠 mai specificata |
| 9 | Break-even / gestione in corsa | 🟢 **assenza vera**: non esiste alcun BE in questa strategia (a differenza del Breakout) — non e' un buco, e' una scelta |
| 10 | Scadenza dei pendenti non riempiti | 🟠 solo "finche' il segnale e' valido" |
| 11 | Anno degli esempi | 🟡 impedisce la riverifica |
| 12 | Passo di volume / lotto minimo del broker del corso | 🟡 si assume 0,01 — 🆕 **il broker del corso e' IDENTIFICATO**: `[T]` lez. 2 modulo base _"il nome del broker che noi utilizziamo e' **Black Ridge**"_, sito **`bcmmarkets.com`**, conto demo da **10.000 euro**. **E' il NOSTRO broker** (`50503392 — BCMMarkets-Server — BCM Markets Ltd`): il passo di volume si legge dal nostro terminale, non si assume piu' |

---

## 13. 🖼️ COSA C'ERA A SCHERMO E NON NEL PARLATO

1. 🔴 **IL FOGLIO EXCEL, in tutte le sue schede** (lez. 28, 29, 30, 31, 32).
   ✅ **Buona notizia: la parte dei LIVELLI e' stata ricostruita per intero
   (§5) e non serve piu'.** ❌ **Restano da vedere: la colonna dei volumi, la
   cella rossa del rischio complessivo e la formula che le lega** — e' l'unico
   modo di chiudere il buco n.2.
2. 🔴 **Il pannello parametri del SuperTrend** (lez. 26, 27) — mai letto.
3. 🔴 **La curva di equity e la lista operazioni della lez. 32** — N, win rate,
   date, broker: tutto mostrato, nulla dettato.
4. 🟠 **L'ammontare del conto** inserito in cashbackforex (lez. 29) — mai
   pronunciato. E' la ragione per cui §7.4 non chiude.
5. 🟠 I grafici degli esempi del 4 e 17 aprile e del 22 e 28 febbraio: **anno e
   livelli intermedi** non dettati.
