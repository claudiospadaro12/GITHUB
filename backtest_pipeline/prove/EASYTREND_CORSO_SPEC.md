# 📐 EASY TREND — SPECIFICA RICOSTRUITA DAL CORSO (lezioni 11-17)

> **Fonte:** le 7 trascrizioni in
> `backtest_pipeline/caccia_strategie/trascrizioni_corso_2026-08-18/modulo_easytrend/`.
> **Nient'altro.** Nessuna integrazione da memoria, nessuna lettura del codice
> usata per "completare" il corso: dove il corso tace, qui c'e' scritto **BUCO**.
> Il codice di `ABTG_EasyTrend.mq5` e' stato aperto **dopo** aver chiuso i §1-§9,
> come nel processo Breakout.
>
> **Referto di analisi** (fedelta' dell'EA vivo, incrocio contratti, domande):
> `backtest_pipeline/caccia_strategie/ANALISI_CORSO_EASYTREND_2026-08-18.md`
>
> **Etichette:** `[T]` = trascritto testualmente · `[I]` = inferito (dico da dove)
> · `[?]` = incerto/ambiguo · `[BUCO]` = il corso non lo dice.
>
> ⚠️ **Questa spec descrive cosa INSEGNA il corso, non cosa funziona.** I numeri
> di performance sono `[dichiarato dal corso, NON verificato da noi]` (§9).

---

## 0. 🔴 IL RILIEVO PRELIMINARE: IL RELATORE NON E' QUELLO CHE CI ASPETTAVAMO

La missione parlava di "corso di Manuela Negro". **Il modulo Easy Trend ha un
altro autore, e lo dice in prima riga della lezione 11** `[T]`:

> _"Sono **Leonardo Fasciano**, trader e coach in area trading in **Alfio
> Bardola Trading Group**"_ ("Bardola" = Bardolla, storpiatura evidente `[T]`)

**Conseguenza metodologica, non formale.** Breakout (Negro) ed Easy Trend
(Fasciano) sono **due autori dentro lo stesso Master**: dove le due spec
coincidono NON e' convergenza di fonti indipendenti, e dove divergono **non
esiste uno "standard di casa" del corso** da cui dedurre i buchi. E divergono
frontalmente su due punti (§11). L'EA in campo attribuisce gia' correttamente
il capitolo a Fasciano (riga 4 del sorgente).

---

## 1. 🎯 IDENTITA' DELLA STRATEGIA

| voce | valore | fonte |
|---|---|---|
| Nome | Easy Trend (trascritto anche "EZtrend", "Easy Trand") | lez. 11-17 |
| Stile reale | **inversione / mean-reversion su divergenza**, con conferma di trend | `[I]` da lez. 13, vedi nota |
| Timeframe | **H1** | `[T]` lez. 13: _"una delle regole della strategia e' operare sul time frame **orario** del cross euro-dollaro"_ |
| Piattaforma di ANALISI | **TradingView** (versione gratuita, feed Pepperstone) | `[T]` lez. 11, 12 |
| Piattaforma di ESECUZIONE | **MT4** | `[T]` lez. 11: _"MetaTrader 4, che invece e' il nostro strumento di messa a mercato"_ |
| Indicatori | **Linear Regression Candles** (UGUR-VU) + **CCI Divergences** (TISTA) | `[T]` lez. 12 |

> 🧠 **Nota di lettura.** Il nome dice "trend", il motore e' **contro-trend**: si
> compra dopo una discesa quando il CCI diverge al rialzo. `[I]` da lez. 13
> (_"questa discesa molto probabilmente ha finito la sua corsa"_). La componente
> "trend" e' solo la **conferma**: la candela di regressione lineare che taglia
> la sua media. E' un'inversione con filtro di innesco, non una continuazione.

---

## 2. 🌍 UNIVERSO OPERATIVO

### 2.1 I tre cross dichiarati `[T]` lez. 13 e 17

| cross | ruolo | citazione |
|---|---|---|
| **EURUSD** | **il banco della strategia** | lez. 13: _"operare sul time frame orario del **cross euro-dollaro**"_ — usato in TUTTI gli esempi (12-16) |
| **EURGBP** | secondo cross ammesso | lez. 17: _"Gli altri cross su cui e' possibile applicare la strategia sono i cross **euro-gbp**"_ |
| **EURCAD** | terzo, dichiarato piu' debole | lez. 17: _"l'ultimo ma un po' meno profittevole soprattutto nell'ultimo periodo e' **euro-cad**"_ |

- lez. 13 anticipa: _"Poi ci saranno anche altri cross, li vedremo dopo"_ — e la
  lez. 17 ne nomina **due**, non di piu'. **L'universo del corso e' chiuso a 3.**
- Tutti e tre **sempre su H1**: `[T]` lez. 17 _"sempre sul time frame orario, mi
  raccomando"_.
- ⚠️ **Nessuna motivazione tecnica** dell'universo: non si dice *perche'* questi
  tre. A differenza del Breakout (che motiva i cross yen con la scarsita' di
  ritracciamenti), qui la selezione e' **puramente a posteriori dal backtest**
  `[I]` da lez. 17, che presenta i tre cross come tre report.

### 2.2 Fuso orario della piattaforma — **[BUCO], ed e' un buco che morde**

Il corso impone una fascia oraria (§5, regola 3) e **non dichiara mai in quale
orologio**. Gli unici appigli:
- lez. 12: il feed selezionato su TradingView e' **Pepperstone** `[T]`;
- lez. 13: _"candela del primo maggio alle ore 11.00"_ `[T]`;
- lez. 16: _"la candela delle 13.00"_ e _"una candela di mezzanotte"_ `[T]`.

Nessuna frase dice "ora italiana", "ora del broker", "UTC". TradingView mostra
l'ora del **fuso scelto dall'utente**, che non e' visibile nel parlato.

> 🔴 **Non convertibile.** Regola di casa: un orario col fuso sbagliato e' peggio
> di nessun orario. Si tiene il valore **letterale** e si dichiara l'assunzione.
> **Questo buco e' gia' stato aggredito con una misura**, non con un'ipotesi:
> `REFERTO_ROUND53_FUSO_EASYTREND.md` (128 passate, 4 simboli, 4 fasce
> diagonali) → **la fascia non decide, si tiene 8-18 letterale**. Il buco resta
> un buco della FONTE; da noi e' chiuso per misura.

> 🆕 **18/08 sera — IL MODULO BASE DA' UN APPIGLIO NUOVO (e non e' TradingView).**
> `[TRASCRITTO chiaro, lez. 3 modulo base "I PRIMI PASSI SULLA PIATTAFORMA"]`
> > _"Questa e' una piattaforma che, scaricata dal broker **BlackRidge**, **non
> > da' l'ora italiana, cioe' e' settata sostanzialmente sul GMT** ... **e non puo'
> > essere modificata questo orario** ... quando in Italia [c'e'] l'ora legale,
> > quindi da fine marzo a fine ottobre, **qui la piattaforma sara' DUE ORE
> > INDIETRO rispetto all'ora italiana**. Quando invece ... [c'e'] l'ora solare
> > ... **la piattaforma risultera' UN'ORA INDIETRO**"_
>
> ⚖️ **Cosa cambia e cosa NON cambia.**
> - ✅ **La piattaforma MT4 del corso e' a UTC+0.** Ed e' un dato che si allaccia
>   a una misura nostra: `report/METRO_PROP.md` §11 registra che
>   **`PepperstoneUK-Demo` e' a UTC+0** — e il feed usato in questo modulo su
>   TradingView e' **Pepperstone** (lez. 12). **Due indizi che puntano allo
>   stesso orologio.**
> - ⚠️ **MA NON E' UNA PROVA per questa strategia:** su TradingView il fuso e'
>   **quello scelto dall'utente**, non quello del feed, e nel parlato non si
>   vede. La fascia 8-18 resta senza orologio dichiarato.
> - 🟢 **E in pratica non morde:** R53 ha gia' misurato che **la fascia non
>   decide**. Se il fuso fosse UTC+0, "8-18 piattaforma" = **9-19 BCM** in
>   agosto: uno spostamento di un'ora dentro una fascia che le 128 passate
>   hanno mostrato indifferente.
>
> ➡️ `caccia_strategie/ANALISI_MODULI_BASE_2026-08-18.md` §2.5.

---

## 3. 🔧 GLI INDICATORI — e il buco BLOCCANTE (doppio)

### 3.1 Cosa dice il corso

| indicatore | cosa se ne sa | fonte |
|---|---|---|
| **Linear Regression Candles**, autore **UGUR-VU** | candele ricalcolate che colorano la tendenza: _"l'algoritmo di queste candele va a colorare tutto dello stesso colore ... le candele che hanno una stessa direzionalita'"_ | `[T]` lez. 12 |
| — il **plot** | _"Il plot e' sostanzialmente una **media mobile calibrata e tarata sull'algoritmo delle candele**"_ | `[T]` lez. 12 |
| — colore | verde = impulso rialzista, rossa = impulso ribassista | `[T]` lez. 12 |
| **CCI Divergences**, autore **TISTA** | segnala divergenze con **riga verde + scritta "bull"** (rialzista) e **riga rossa + scritta "bear"** (ribassista) | `[T]` lez. 12, 13 |
| modifiche consigliate | **solo estetiche**: colore nero e spessore massimo su entrambi | `[T]` lez. 12: _"l'unica modifica e' il plot colore e spessore, fine"_ |

### 3.2 🔴 I PARAMETRI NON ESISTONO IN NESSUNA DELLE 7 LEZIONI

La lezione 12 e' **interamente dedicata al settaggio degli indicatori** e apre
il pannello impostazioni di entrambi. Dentro quel pannello il relatore tocca
**solo colore e spessore** e dice testualmente `[T]`:

> _"l'unica modifica che ti consiglio di fare e' proprio sul colore"_

→ **Non c'e' un solo numero.** Nessuna lunghezza di regressione, nessun periodo
di media del plot, nessun periodo del CCI, nessuna profondita' dei pivot.

> 🔴 **E' un buco PEGGIORE di quello del SuperTrend nel Breakout.** Il SuperTrend
> ha un "classico" di mercato (ATR 10 / molt. 3,0) su cui ripiegare. Qui i due
> indicatori sono **due script Pine di due autori privati**: il "default" e'
> quello del loro sorgente, che **non e' nel corso e non e' nel repo**. Finche'
> non si recupera il Pine, **ogni numero e' NOSTRO**, e qualunque backtest misura
> la NOSTRA versione della strategia.
>
> 📌 Quello che l'EA usa oggi (`InpLinRegLen 11 / SMA 11 / CCI 20 / pivot 5-3`)
> e' **dichiarato come SCELTA NOSTRA nel sorgente** (righe 122-134), non
> spacciato per corso. Su questo il codice e' onesto.

### 3.3 Cosa il corso dice della DIVERGENZA (e qui e' preciso)

La definizione operativa e' dettata per intero, ed e' la **divergenza regolare**:

- **BEAR** `[T]` lez. 13: _"il prezzo forma due **massimi crescenti**,
  l'indicatore forma due **massimi decrescenti**"_
- **BULL** `[T]` lez. 13: _"l'indicatore sta segnalando **due minimi
  crescenti**, divergenza di inversione rialzista, ovvero i **minimi del prezzo
  che scendono** e i minimi dell'indicatore che invece salgono"_

→ Meccanizzabile senza interpretazione: **prezzo LL + CCI HL = bull**, **prezzo
HH + CCI LH = bear**. Il corso **non nomina** le divergenze nascoste `[BUCO]`.

---

## 4. ✅ LA CHECKLIST — 5 REGOLE, NUMERATE DAL CORSO STESSO

Il corso le detta due volte (lez. 13 mentre le scrive in un file di testo,
lez. 14 mentre le rilegge). Qui nella forma della lez. 14, la piu' compatta.

| # | regola | citazione `[T]` |
|---|---|---|
| **R1** | presenza di una **divergenza di inversione** (bull o bear) | lez. 14: _"presenza di una divergenza di inversione rialzista per il segnale long"_ |
| **R2** | la **PRIMA candela che taglia il plot** dopo la divergenza — **o che apre gia' oltre** | lez. 13: _"la candela che taglia il plot dal basso verso l'alto, **o addirittura la candela che apre direttamente sopra**"_ |
| **R3** | la candela del segnale sta **fra le 8 e le 18** | lez. 13: _"deve essere una candela compresa in una determinata fascia oraria, ovvero **tra le ore 8 e le ore 18**"_ |
| **R4** | la candela che taglia deve essere **dello stesso colore della divergenza** | lez. 13: _"la candela che taglia il plot deve essere dello stesso colore ... della divergenza"_ |
| **R5** | le **3 candele precedenti** al segnale stanno **dal lato opposto del plot** | lez. 13: _"le tre candele precedenti rispetto alla candela del segnale siano ... **sotto il plot, sotto la media**"_ (long); lez. 13: _"se stiamo tradando un segnale ribassista ... voglio che le tre candele precedenti siano **sopra** la media"_ |

### 4.1 🔑 Il dettaglio che quasi tutti sbaglierebbero — il COLORE e' della LINREG

`[T]` lez. 16, esplicito e con l'esempio contrario sotto gli occhi:

> _"come vedi la **candela giapponese sotto e' verde**, ma questa cosa **non mi
> interessa**, perche' e' importante che sia la **line reg in tinta** a favore
> della posizione che stiamo andando a prendere, quindi che sia **rossa** cosi'
> come rossa la divergenza ribassista"_

→ R4 si legge sul **colore della candela di regressione lineare**, non su quello
della candela di prezzo. E' il dettaglio piu' sottile della checklist, ed e'
**dettato**, non inferito.

### 4.2 🛑 LA REGOLA DI INVALIDAZIONE (una regola in piu', spesso persa)

`[T]` lez. 16, per intero:

> _"quando abbiamo un segnale line reg ... **invalidato da una candela fuori
> orario** ... c'e' la presenza di una divergenza rialzista, ma la candela che
> taglia il plot ... e' una candela di **mezzanotte** ... a questo punto la
> divergenza e' stata invalidata da una candela fuori orario, che cosa vuol
> dire? **Non andro' piu' a monitorare questa divergenza e la considerero'
> nulla** ... mi concentrero' su eventuali divergenze successive"_

→ **R6.** Se la **prima** candela che taglia il plot e' fuori dalla fascia 8-18,
la divergenza **muore**. Non si aspetta la candela buona: si aspetta una
**divergenza nuova**. E' una regola con conseguenze grosse sulla frequenza, ed
e' dettata senza ambiguita'.

### 4.3 ⚠️ Ambiguita' n.1 — la lez. 13 sbaglia a numerare le regole

Nel parlato della lez. 13 la R4 viene enunciata **due volte**: prima
correttamente (colore), poi di nuovo _"Dopodiche' verifichiamo che la candela
che taglia il plot deve essere dello stesso colore della divergenza"_ **subito
prima di descrivere la regola delle 3 candele**.

> ✅ **RISOLTA: e' un lapsus verbale.** La quinta regola e' quella delle 3
> candele, come conferma la stessa lezione (_"modifichiamo anche qua la **quinta
> regola**, ovvero verificare le tre candele precedenti"_) e la rilettura della
> lez. 14. `[I]` — nessun impatto implementativo.

### 4.4 ⚠️ Ambiguita' n.2 — cosa vuol dire "taglia" e cosa vuol dire "sotto"

Il corso non definisce mai in termini di prezzo:
- **"taglia il plot"**: chiusura oltre il plot? corpo che lo attraversa? un
  tocco? `[BUCO]` — dal disegno mostrato si legge "corpo che attraversa", ma
  **e' materiale a schermo, non dettato**.
- **"le 3 candele precedenti sotto il plot"**: interamente sotto, corpo sotto,
  chiusura sotto? `[BUCO]`

> Entrambe si risolvono con **la chiusura** senza forzare la fonte (e' l'unica
> lettura che non richiede di guardare le ombre di candele che sono gia'
> sintetiche), ma **la scelta e' nostra e va dichiarata.** `[I]`

### 4.5 ⚠️ Ambiguita' n.3 — le 18 sono incluse?

_"tra le ore 8 e le ore 18"_ `[T]`. Su H1, una candela "delle 18" vive dalle
18:00 alle 19:00. Includerla fa **11 candele** ammesse, escluderla ne fa **10**.
Il corso non lo dice `[BUCO]`, gli esempi (11:00 e 13:00) non toccano il bordo.

> ⚠️ Da noi la convenzione e' **estremo incluso** (11 candele), scritta nel
> sorgente. Nota agli atti: `REFERTO_ROUND53` chiama le fasce "larghezza 10 ore"
> — **la larghezza dichiarata nel referto e quella implementata nel codice non
> coincidono di una candela.** Non cambia nessun verdetto di R53 (tutte le
> diagonali hanno lo stesso bordo), ma il numero va detto giusto.

### 4.6 ⚠️ Ambiguita' n.4 — se la prima candela che taglia fallisce R4 o R5?

Il corso dichiara la morte della divergenza **solo** per il fuori orario (§4.2).
Cosa succede se la prima candela che taglia e' in orario ma **del colore
sbagliato**, o con le 3 candele precedenti non allineate? `[BUCO]`

> Due letture: (a) la divergenza muore comunque (era "la prima candela"); (b)
> resta viva e si riprova alla rottura successiva. **Argomento a favore di (b):**
> se la morte valesse sempre, il corso non avrebbe avuto bisogno di dichiararla
> per il caso orario. `[I]` — argomento, non citazione.

---

## 5. 💰 LIVELLI: INGRESSO, STOP, TARGET

### 5.1 Il principio che regge tutto: **l'ancora e' la candela del segnale**

`[T]` lez. 14: _"il nostro obiettivo di ingresso e' **il prezzo di chiusura
della candela del segnale**"_ — e i tre livelli si **scrivono su carta** e si
ricopiano in MT4 (`[T]` lez. 14: _"e' importante prendere carta e penna e
scriversi questi tre valori"_; lez. 15: _"ho semplicemente riportato quei tre
valori che abbiamo preso da TradingView"_).

### 5.2 Tabella dei livelli

| voce | LONG | SHORT | fonte |
|---|---|---|---|
| **Ingresso** | chiusura della candela del segnale | idem | `[T]` lez. 14 |
| **Ancora dello stop** | il **minimo** compreso fra **l'inizio della divergenza** e la **candela del segnale** | il **massimo**, stesso intervallo | `[T]` lez. 14: _"il punto piu' basso compreso tra l'inizio del segnale e la candela della conferma tecnica"_ · lez. 16: _"il punto piu' alto, compreso tra **l'inizio della divergenza** e la candela del segnale"_ |
| **Stop loss** | ancora **− 3 pips** | ancora **+ 3 pips** | `[T]` lez. 14: _"scendiamo al di sotto di questo livello di **tre pips**"_ |
| **Take profit** | **1:1** sulla distanza di stop | idem | `[T]` lez. 14: _"sara' un rapporto rischio-rendimento di **1 a 1**"_ |

> 🔑 **"L'inizio della divergenza"** e' il **primo** dei due pivot della coppia
> (la partenza della riga verde/rossa disegnata dall'indicatore), non il momento
> in cui la divergenza appare. La lez. 14 lo mostra tracciando _"una bella riga
> verticale ... l'inizio della riga, in questo caso verde"_ `[T]`. E' il dettaglio
> equivalente al "BE sulla chiusura del segnale" del Breakout: facile da
> sbagliare, e **dettato**.

### 5.3 I due esempi numerici — e cosa NON torna

**Esempio 1 (LONG, EURUSD, 1° maggio ore 11:00)** `[T]` lez. 14-15:

| voce | valore | verifica nostra |
|---|---|---|
| ingresso | `1,06697` (lez. 15 lo riscrive `1,06698` — refuso) | |
| stop loss | `1,06464` | 1,06697 − 1,06464 = **0,00233 = 23,3 pip** ✅ coerente col "23 pips" dichiarato |
| take profit | `1,06933` | 1,06933 − 1,06697 = **0,00236 = 23,6 pip** → RR **1,01** ✅ |
| distanza grezza | _"in questo momento la misura del mio stop loss e' di 20 pips"_ → +3 = 23 | ✅ chiude |
| lotti | **0,46** su conto 5.000 €, rischio 2%, pip = 9,28 € | 100 € / (23 × 9,28) = **0,468** ✅ **l'aritmetica chiude** |

**Esempio 2 (SHORT, EURUSD, candela delle 13:00)** `[T]` lez. 16:

| voce | valore | verifica nostra |
|---|---|---|
| ingresso | `1,06771` | |
| stop loss | `1,06933` (poi digitato `1,06931` in MT4 — refuso) | 1,06933 − 1,06771 = **0,00162 = 16,2 pip** |
| take profit | `1,06613` | 1,06771 − 1,06613 = **0,00158 = 15,8 pip** → RR **0,975** |
| pip dichiarati | _"12 pips, 12.9 potremmo quasi arrotondare a 13"_ → _"13, 14, 15 e 16, quindi sono **3 pips sopra**"_ | stop = **16 pip** ✅ |
| pip usati per la size | _"calcoleremo lo stop loss sulla base dei pips ... quindi **15 pips**"_ → lotti **0,71** | 100 € / (15 × 9,28) = **0,718** ✅ l'aritmetica chiude **sul 15** |

> 🔴 **L'INCOERENZA (classe "39 vs 40 pip" del Breakout).** Lo stop dell'esempio 2
> **e' 16 pip** (16,2 sul prezzo), ma **la size e' calcolata su 15**. Rischio
> reale: 0,71 × 9,28 × 16,2 = **106,7 €** su un conto di 5.000 = **2,13%**, non
> il 2% dichiarato. Uno scarto del **+7% sul rischio per operazione**.
> **Non e' un errore di trascrizione**: entrambi i numeri chiudono le rispettive
> aritmetiche, sono due arrotondamenti a occhio nella stessa lezione.
> **Per un EA:** si usa il valore **esatto**, e si dichiara che il corso
> arrotonda. Lo stesso vale per il RR: il corso lo cerca **a occhio** sul widget
> di TradingView (_"andiamo fino a quando non diventa 1"_ `[T]`) e chiude a 0,975.

### 5.4 Il **pip** — `[BUCO]` fuori da EURUSD

Il corso lavora **solo** su cambi a 5 decimali e legge i pip dal righello di
TradingView (_"leggiamo semplicemente 20 o 0.0020, saranno 20 pips"_ `[T]` lez.
14). Su un cross **JPY a 3 decimali** il pip non e' mai definito. Ovvio per un
umano, **non** per un EA: va imposto. *(Non e' un problema del corso — e' un
problema NOSTRO, perche' due delle tre sedie vive sono JPY. Vedi il referto.)*

---

## 6. 📥 LA MESSA A MERCATO — la regola dei due scenari

`[T]` lez. 15, dettata due volte:

> _"se il prezzo al momento in cui andiamo a mercato e' leggermente piu' **verso
> il take profit**, allora posizioneremo un ordine di tipo **buy limit**, se
> invece il prezzo dovesse essere leggermente un po' piu' **verso lo stop-loss**
> posizioneremo un **ordine a mercato**, quindi entreremo subito a mercato"_

- Il livello del limit e' **il livello d'ingresso studiato**, non un prezzo nuovo.
- Il caso "prezzo piu' vicino allo stop" e' esplicitamente **un vantaggio**:
  _"mi sarei trovato ad un prezzo piu' conveniente rispetto a quello del
  segnale"_ `[T]` lez. 15.
- Nell'esempio short si usa un **sell limit** `[T]` lez. 16.

### 6.1 ⚠️ Ambiguita' n.5 — entrando a mercato, i livelli restano quelli scritti?

Il corso **non lo dice mai come regola**, ma **tutta la procedura lo implica**:
i tre valori si scrivono su carta e si **ricopiano** in MT4, e la size si calcola
sui **pip letti sul grafico** (ancorati alla chiusura del segnale), non sul
prezzo di riempimento.

> ✅ **Lettura: SL e TP restano i livelli scritti, sempre.** Conseguenza
> aritmetica: entrando a mercato piu' vicino allo stop, il rischio in pip
> **scende** e il RR effettivo **sale sopra 1**. Il corso **non discute**
> l'effetto `[BUCO]`. `[I]` da procedura, non da citazione — ed e' **il punto
> in cui il nostro EA diverge** (vedi referto §fedelta').

### 6.2 Scadenza dell'ordine pendente — `[BUCO]`

Quanto tempo si lascia vivo il buy/sell limit se il prezzo non torna? Mai detto.
Nell'esempio la lez. 15 mostra che il prezzo _"ha oscillato tranquillamente nel
range del valore d'ingresso"_ per **due ore** `[T]`, ma non e' una regola.

---

## 7. 🛡️ GESTIONE DELL'OPERAZIONE — **non esiste, ed e' un fatto, non un buco**

Il corso segue **due operazioni intere dall'inizio alla fine** (lez. 15 long,
lez. 16 short) e **in nessuna delle due fa alcunche' dopo l'invio dell'ordine**:

- lez. 15: _"l'esito di questa operazione e' stato con questa candela **la
  chiusura in take profit**"_ `[T]`
- lez. 16: _"nell'arco della candela successiva, l'operazione sarebbe chiusa in
  profitto raggiungendo il nostro ... livello di take profit"_ `[T]`

**Nessun break-even. Nessun trailing. Nessuna parziale. Nessuna uscita a tempo.
Nessuna uscita su segnale contrario.** E la lez. 17 conferma indirettamente: il
worst case e' contato in _"tre **stop loss** consecutivi"_ `[T]`, cioe' le uscite
sono due sole.

> ✅ **Si conta come regola CERTA (per dimostrazione doppia + coerenza con la
> lez. 17)**, non come buco. `[I]`

---

## 8. 📊 RISCHIO E MONEY MANAGEMENT

| voce | valore | fonte |
|---|---|---|
| Rischio per operazione | **2%** | `[T]` lez. 15: _"il rischio suggerito su questa strategia e' del **2%**, quindi inseriamo 0.02"_ · lez. 17: _"suggerisco e uso un rischio del 2%"_ |
| Motivazione del 2% | il drawdown misurato e' basso | `[T]` lez. 17: _"uso un rischio del 2% **perche' il drawdown e' relativamente basso**, ovvero un drawdown dell'8% massimo"_ |
| Sizing | foglio **Excel**: saldo × rischio% ÷ (valore del pip × pip di stop) | `[T]` lez. 15 (verificato: chiude su entrambi gli esempi, §5.3) |
| Capitale degli esempi | **5.000 €** | `[T]` lez. 15, 17 |
| Valore del pip usato | **9,28 €** per EURUSD, conto in euro | `[T]` lez. 15 |
| Il rischio e' soggettivo | dichiarato esplicitamente | `[T]` lez. 17: _"il rischio e' una cosa assolutamente soggettiva ... e' sempre dettato dall'analisi del backtest e dal possibile drawdown"_ |
| Tetto di drawdown | **[BUCO]** — questo modulo non ne fissa nessuno | |
| Posizioni contemporanee | **[BUCO]** — mai nominato, nemmeno con 3 cross ammessi | |

---

## 9. 📉 NUMERI DI PERFORMANCE DICHIARATI

> 🔴 **TUTTI** `[dichiarato dal corso, NON verificato da noi]`. Fonte: lez. 17,
> unica lezione con numeri. E' un **report mostrato a schermo e commentato a
> voce**: nessun estratto conto, nessuna lista operazioni, nessun broker.

### 9.1 Quello che dichiara

| voce | EURUSD | EURGBP | EURCAD |
|---|---|---|---|
| Periodo | gen 2022 → "oggi" (_"circa due anni e mezzo"_) | gen 2022 → oggi | idem |
| N. operazioni | _"piu' di **140**"_ | _"circa **140**"_ | `[BUCO]` |
| Profitto | **+198%** | **+118%** | **+68%** `[T? dubbio]` |
| Max drawdown | **8%** | **10%** (_"leggermente piu' alto"_) | _"leggermente piu' alto"_ |
| Win rate | **70%** | `[BUCO]` | `[BUCO]` |
| Worst case | **3 stop loss consecutivi** | 3 consecutivi | `[BUCO]` |
| Rischio | 2% | 2% (implicito) | 2% (implicito) |
| Capitale | 5.000 € | `[BUCO]` | `[BUCO]` |
| Reso annuo dichiarato | **75-80%/anno** | `[BUCO]` | `[BUCO]` |

⚠️ **EURCAD `[TRASCRITTO dubbio]`**: la frase e' _"un po' meno perche' il 68% e'
un drawdown leggermente piu' alto"_ — sintatticamente rotta. Le due letture sono
(a) profitto +68% **e** DD piu' alto, (b) DD del 68%. **(b) e' assurda** (il
relatore lo presenta come cross utilizzabile). Si legge (a). `[I]`

**Buchi comuni a tutti e tre:** broker, spread, slippage, date esatte di fine,
curva operazione per operazione, definizione di "drawdown". `[BUCO]`

### 9.2 🧮 Cosa si scopre facendo l'aritmetica (analisi nostra)

**(a) I numeri di EURUSD sono INTERNAMENTE COERENTI — e questo cambia il
giudizio rispetto al Breakout.**

Con rischio 2% composto, RR 1:1 e 140 operazioni, il profitto totale dipende
solo dal win rate `p`: `(1 + 0,02·(2p−1))^140`.
- Con **p = 0,70** → **+205%**
- Il **+198%** dichiarato richiede **p = 69,6%**

→ **Il win rate 70%, le 140 operazioni, il rischio 2% e il +198% sono lo stesso
numero detto quattro volte.** Non sono quattro conferme indipendenti: sono una
sola dichiarazione, aritmeticamente consistente. Stessa lezione del Breakout
(dove i due scenari 1%/3% erano una lista riscalata), **ma qui i conti
tornano**: non c'e' un'implausibilita' aritmetica da opporre. `[I]`

**(b) Anche il DD e il worst case sono coerenti.** 3 stop consecutivi a 2% =
~5,9%; con un po' di restituzione dopo le vincite si arriva all'8% dichiarato.
E su 140 operazioni al 30% di perdite, la **serie perdente piu' lunga attesa e'
~3** (`log(140·0,3)/log(1/0,3) ≈ 3,1`): il "massimo 3 consecutive" e'
**esattamente il valore atteso**, non un'anomalia. `[I]`

**(c) 🔴 L'UNICO numero che NON torna: il "75-80% all'anno".**
+198% in 2,5 anni composto = **+54,8% l'anno**, non 75-80%.
198 ÷ 2,5 = **79,2%** → il relatore sta **dividendo linearmente il totale**,
non misurando un tasso annuo. `[I]` — aritmetica nostra.
→ Il reso annuo dichiarato **sovrastima del ~45%** quello implicito nei suoi
stessi numeri. Non e' una frode, e' una divisione: ma e' **il numero che chi
ascolta si porta a casa**, ed e' quello sbagliato.

**(d) Il numero che decide tutto e' UNO: il win rate.** Con RR 1:1, il pareggio
lordo e' a **50%**; con lo spread, sopra. La distanza fra il 70% dichiarato e la
soglia di morte e' tutto il margine della strategia. **E' l'unica misura da
fare.** (§10 del referto: sul nostro banco quel numero e' **45-58%**.)

---

## 10. 🧾 RIEPILOGO PER IL DEVELOPER: certo / ambiguo / buco

### ✅ 21 REGOLE CERTE (implementabili senza inventare)
H1 · EURUSD banco + EURGBP + EURCAD · divergenza bull = prezzo LL + CCI HL ·
divergenza bear = prezzo HH + CCI LH · segnale = **prima** candela linreg che
taglia il plot · "apre gia' oltre" vale come taglio · il taglio dev'essere nel
verso del segnale · fascia oraria 8-18 sulla candela del segnale · **taglio
fuori orario ⇒ divergenza NULLA** · colore della candela in tinta con la
divergenza · il colore e' quello **LINREG**, non della candela giapponese · 3
candele precedenti dal lato opposto del plot · ingresso = **chiusura della
candela del segnale** · ancora dello stop = estremo fra **inizio divergenza** e
candela del segnale · stop = **3 pip oltre** l'estremo · TP = **RR 1:1** ·
prezzo verso il TP ⇒ **limit** sul livello · prezzo verso lo SL ⇒ **mercato** ·
livelli scritti e ricopiati in MT4 · **nessuna gestione dopo l'ingresso** ·
rischio **2%** per operazione con sizing su saldo × %÷(pip × pip di stop).

### ⚠️ 6 AMBIGUITA'
1. 🔴 **Il FUSO della fascia 8-18** (§2.2) — la regola c'e', l'orologio no.
   *Da noi chiusa per misura (R53), non dalla fonte.*
2. numerazione delle regole nella lez. 13 → lapsus, risolta (§4.3).
3. cosa vuol dire "taglia" e cosa vuol dire "sotto il plot" (§4.4).
4. le 18 sono incluse? 10 o 11 candele (§4.5).
5. la divergenza muore anche se fallisce R4/R5? (§4.6).
6. entrando a mercato, SL/TP/size restano ancorati ai livelli scritti? (§6.1)
   *→ risolta per procedura, ed e' la divergenza del nostro EA.*

### 🕳️ 12 BUCHI

> 🆕 **18/08 sera — i 41 file dei MODULI BASE sono stati letti a caccia proprio
> di questi due.** Il n.1 **non c'e'** (Linear Regression Candles non compare mai:
> il corso base e' tutto MT4, quell'indicatore e' TradingView). Il n.2 esce
> **dimezzato ma vivo**, e con **due numeri che vanno contro le nostre
> assunzioni** → §10.1. Referto:
> `caccia_strategie/ANALISI_MODULI_BASE_2026-08-18.md` §2.7.

1. 🔴 **Parametri di Linear Regression Candles — BLOCCANTE** *(cercato nei moduli
   base: l'indicatore non e' mai nominato — buco confermato)*
2. 🔴 **Parametri di CCI Divergences (CCI + pivot) — BLOCCANTE** *(🟡 due parziali
   nuovi, §10.1)*
3. scadenza dell'ordine pendente
4. scadenza della divergenza in attesa del taglio
5. massimo di posizioni contemporanee (con 3 cross ammessi)
6. cosa fare se arriva una nuova divergenza a posizione aperta
7. filtro spread (mai nominato)
8. filtro news (mai nominato)
9. cap di perdita giornaliera (mai nominato)
10. tetto di drawdown complessivo (questo modulo non ne da' nessuno)
11. ✅ ~~definizione di pip fuori dai cambi a 5 decimali~~ — **CHIUSO dal modulo
    base, dettato quattro volte** (lez. 6, 11, 19, 21): non-JPY = 5 decimali, la
    **4ª e' il pip**, la 5ª il punto; **JPY = 3 decimali, la 2ª e' il pip**, la
    3ª il punto; **10 punti = 1 pip**, sempre.
    `[T]` _"in tutti i cambi con lo yen troverai questa situazione ... quella
    scritta in piccolino e' il punto, questa invece e' il pip"_.
    **Per l'EA: i "3 pip oltre l'estremo" della regola dello stop = 30 punti.**
12. broker / spread / date / lista operazioni del backtest della lez. 17 —
    e il **ritardo/repaint** dell'indicatore di divergenza, mai discusso
    *(🆕 sul repaint il modulo base da' almeno la dottrina: `[T]` an.tec. lez. 5
    _"**l'ultima candela non e' mai un bottom** ... andrebbe sempre lasciata in
    sospeso"_ — cioe' **niente pivot sulla candela in formazione**)*

### 10.1 🆕 18/08 sera — I DUE PARZIALI SUL BUCO n.2, e vanno CONTRO di noi

Il modulo base **nomina esplicitamente il CCI come indicatore di una strategia
del master**, e questa e' l'unica che lo usa.

`[TRASCRITTO chiaro, lez. 13 modulo base "WILLIAM PERCENT RANGE, CCI E RSI"]`
> _"L'indicatore CCI nasce come indicatore per lo studio delle commodity ... In
> questo caso, pero', **lo andremo ad inserire soltanto perche' e' frutto dello
> studio di una strategia che vedrai nel corso del master, che prevede appunto
> l'utilizzo di questo indicatore** ... Quindi aggiungiamo anche questo
> indicatore, **facciamo ok, settaggio a 14 periodi** ... **queste due linee
> centrali, che corrispondono ai valori di 100 e valori di meno 100**"_

> 🟡 **PARZIALE n.1 — il CCI del corso e' a 14 periodi (default MT4), non 20.**
> ⚠️ **Caveat onesto, e pesa:** il modulo base e' **MT4**, questa strategia gira
> su **TradingView** con lo script _"CCI Divergences" (TISTA)_. **Non e' lo
> stesso oggetto.** Ma **e' l'unico numero che il corso pronunci per il CCI**, e
> la nostra assunzione e' **20**. → **candidato primario dell'A/B.**

**PARZIALE n.2 — il pivot.** La definizione di swing del corso, dettata:
`[TRASCRITTO chiaro, lez. 4 modulo base an.tec. "BOTTOM, TOP E TRENDLINE"]`
> _"Prendiamo tre candele, tale che quella centrale e' piu' alta di quelle
> laterali ... il **top** e' il massimo piu' alto di tutti e tre ... il massimo di
> un piccolo trend, formato da **due, meglio ancora tre**, candele rialziste che
> poi hanno **due, meglio ancora tre**, candele ribassiste successive"_

> 🟡 **Il "pivot" del corso e' 2-3 barre per lato, SIMMETRICO.** La nostra
> assunzione e' **5 a sinistra / 3 a destra**: **non coincide**, e la differenza
> cambia **quali divergenze esistono**. → **secondo candidato dell'A/B.**

**E tre regole di igiene del pivot, dettate** (`[T]` an.tec. lez. 5), che valgono
per qualunque rilevatore di swing nostro:
1. _"il top e il bottom devono essere sempre **su candele differenti**"_
2. _"**dopo un top c'e' sempre un bottom e dopo un bottom c'e' sempre un top**"_
   → **alternanza obbligatoria**: due top consecutivi ⇒ il bottom in mezzo non e'
   significativo e si salta
3. _"**l'ultima candela non e' mai un bottom** ... andrebbe sempre lasciata in
   sospeso"_ → **la regola anti-repaint, dettata dal corso**

> ⚖️ **Cosa NON hanno chiuso:** restano ignoti la lunghezza della regressione
> lineare, la sua SMA, e il fatto che i pivot dello script TISTA siano contati
> sul **CCI** e non sul prezzo. **Il buco n.2 resta BLOCCANTE**: questi due
> numeri sono **candidati per un A/B**, non parametri del corso.

### 📐 GRADO DI MECCANIZZABILITA' — **78%**
Decisioni che un EA deve prendere = **21 certe + 6 ambigue = 27**.
→ **21/27 ≈ 78%** deciso dal corso **senza interpretazione nostra**.
Aggiungendo le 5 ambiguita' risolte con argomento solido (tutte tranne il fuso,
che e' stato risolto **da una misura nostra**, non dalla fonte): **26/27 ≈ 93%**
coperto.

> **Traduzione secca.** Come **checklist**, Easy Trend e' la strategia piu'
> meccanizzabile vista finora: 5 regole numerate dal relatore stesso, una regola
> di invalidazione, tre livelli quantificati, un sizing che chiude su due esempi
> su due. **Ma il motore non e' nella checklist: e' dentro due script Pine di cui
> il corso non pronuncia un solo numero.** La lezione dedicata al settaggio degli
> indicatori tocca **solo il colore**. Finche' quei parametri sono nostri,
> **qualunque backtest misura la NOSTRA versione**, e va detto accanto al numero.
> **La meccanizzabilita' della checklist e' 93%; la riproducibilita' della
> strategia e' molto piu' bassa, e il collo di bottiglia sono due indicatori.**

---

## 11. ⚔️ EASY TREND CONTRO BREAKOUT — due moduli, due grammatiche

Confronto con `prove/BREAKOUT_CORSO_SPEC.md`. **Autori diversi** (§0): serve a
capire cosa e' "standard del Master" e cosa no.

| voce | **Breakout** (Negro) | **Easy Trend** (Fasciano) | |
|---|---|---|---|
| Ancora dell'operazione | chiusura della candela di segnale | chiusura della candela di segnale | ✅ **uguale** |
| Stop | 1 pip oltre l'estremo della figura | **3 pip** oltre l'estremo della figura | ~ stessa forma |
| R | dalla chiusura del segnale | dalla chiusura del segnale | ✅ **uguale** |
| Target | **3R** | **1R** | ⚠️ opposti |
| Rischio | **1%** per operazione | **2%** per operazione | ⚠️ **fattore 2** |
| Filtro orario | **esplicitamente NESSUNO**, 24/5 | **8-18 obbligatoria + invalidazione** | 🔴 **contraddizione frontale** |
| Ordini pendenti | **VIETATI** (_"e' bene non inserire degli ordini pendenti"_) | **PRESCRITTI** (buy/sell limit) | 🔴 **contraddizione frontale** |
| Gestione | break-even a +1R + uscita su segnale contrario | **nessuna** | ⚠️ opposti |
| Piattaforma | MT4 | TradingView + MT4 | diverso |
| Tetto di DD | 20% su tutte le strategie insieme | nessuno in questo modulo | ⚠️ |

> ⚖️ **Due conseguenze operative.**
> 1. **Non esiste un "default del corso"** da cui riempire i buchi di un modulo
>    con l'altro. Su ordini pendenti e filtro orario i due si smentiscono.
> 2. **Il tetto del 20% della Negro copre "tutte le strategie insieme"**: chi
>    fa Breakout all'1% e Easy Trend al 2% sta componendo due money management
>    scritti da due persone che non si sono parlate. Il corso **non affronta**
>    la composizione. `[BUCO]`

---

## 12. 🏛️ NOTE PROP (non richieste dal corso, rilevanti per noi)

Nessuna prop e' mai nominata. Tre punti di attrito con `report/METRO_PROP.md`:

1. **Nessun filtro news** `[BUCO]` — come il Breakout.
2. **Nessuna uscita a tempo**: senza gestione (§7), una posizione aperta alle
   18:00 **resta aperta la notte e il weekend**. Overnight non gestito.
3. **Rischio 2% per operazione** con RR 1:1: due stop consecutivi = 4%, tre = 6%.
   **Contro un daily loss del 5%, tre stop nello stesso giorno sono una
   violazione** — e il corso stesso dichiara che tre consecutivi sono successi
   (lez. 17). Da noi le sedie girano all'1%, che dimezza il problema.

---

## 13. ❓ DOMANDE APERTE PER CLAUDIO

1. 🔴 **I DUE PINE — la richiesta n.1.** Servono gli screenshot dei pannelli
   impostazioni di **"Linear Regression Candles" (UGUR-VU)** e **"CCI
   Divergences" (TISTA)** su TradingView. Sono due click nella lezione 12, e
   valgono piu' di tutto il resto del capitolo: senza, i nostri 4 numeri
   (linreg 11 / SMA 11 / CCI 20 / pivot 5-3) restano **nostri**.
2. 🟠 **Il fuso del grafico di TradingView** nei video: in basso a destra
   TradingView scrive sempre il fuso attivo. Uno screenshot chiude §2.2 dalla
   fonte invece che per misura.
3. 🟡 **Il report della lez. 17**: mostrato a schermo e mai dettato. Servono
   broker, date esatte, lista operazioni. Senza, il +198% non e' confrontabile.
4. 🟡 **EURCAD**: il "68%" e' profitto o drawdown? (§9.1). Un riascolto di 10
   secondi della lez. 17 lo chiude.
5. 🟡 **Esiste un PDF riepilogativo di questo capitolo?** Per il Breakout le 10
   slide hanno chiuso 6 ambiguita' su 10. Qui non ne abbiamo nessuna.

---

## 14. 🖼️ COSA ERA A SCHERMO E NON NEL PARLATO

| lezione | cosa non e' stato dettato |
|---|---|
| **12** | **i due pannelli impostazioni degli indicatori** — aperti entrambi, letti solo colore e spessore. **E' la lezione piu' cieca del capitolo.** |
| 13 | la forma grafica del "taglio del plot"; il grafico delle divergenze; il file di testo con la checklist scritta |
| 14 | il widget "posizione long" di TradingView (i pip si leggono li'); il righello dei 3 pip |
| 15 | **il foglio Excel del sizing** (formula mai dettata, solo i risultati); il sito del valore del pip; la finestra ordine MT4 |
| 16 | lo scorrimento candela per candela; il grafico della divergenza invalidata di mezzanotte |
| **17** | **l'INTERO report del backtest** su 3 cross: equity line, lista operazioni, date, broker. E' la lezione con i numeri, ed e' cieca. |

---

_Compilato il 18/08/2026. Ogni riga porta la sua citazione o la sua etichetta.
Dove il corso tace c'e' scritto BUCO, non un valore ragionevole._
