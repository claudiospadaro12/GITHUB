# 📏 SONDA DI FREQUENZA — MEDIAZIONE DEL CORSO (condizione n.6)

> 🖊️ **Nasce da una firma, e da una sola.** Claudio, 21/08/2026, in chat:
> **"metro,frequenza, firmo r93, r94 lancia, e prepara jpy"**. La parola
> **"frequenza"** sceglie l'**OPZIONE C** del nodo
> (`report/NODO_MEDIAZIONE_2026-08-21.md`, sezione FIRMA in fondo):
> **si costruisce SOLO un contatore di segnali.**
>
> ❌ nessun ordine, mai, nemmeno nel tester · ❌ nessun sizing, nessun lotto ·
> ❌ nessun forward, nessuna sedia · ❌ **nessun EA operativo della Mediazione**
> (Claudio NON l'ha firmato) · ✅ **solo il conteggio.**
>
> 📦 **Strumento consegnato:** `mql5/Scripts/ABTG_SondaMediazione.mq5`
> (SCRIPT, v1.00, commit `13db8c9`). **Non compilato, non eseguito**: questo
> ambiente non ha MetaEditor. Il numero lo produce Claudio, sul suo PC.
> 🚀 **Riga di lancio:** `backtest_pipeline/righe/RIGA_SONDA_MEDIAZIONE.md`

---

## 1. 🎯 LA DOMANDA, UNA SOLA

> **La Mediazione del corso produce almeno 150 PACCHETTI in-sample?**

- **Se sotto 150** → per l'**Emendamento della finestra, punto A** il giudizio
  di **MERITO e' sospeso**: il nodo **si chiude da solo, con un numero**, e non
  serve scrivere nessun EA. E' l'unico cancello che puo' chiudere la questione
  **senza codice da esercizio** — ed e' il motivo per cui Claudio ha scelto C.
- **Se sopra 150** → il nodo **NON e' sciolto**: restano in piedi il **fattore
  2,29** (condizione n.1) e il **cancello di taglia** (un pacchetto pieno =
  **4,03% = 81% del muro giornaliero**; due simultanei = **6,32%**, oltre il
  muro in un solo evento — `METRO_PROP` §13.3/§13.6).

---

## 2. 📦 COME CONTA UN PACCHETTO — **e' LA scelta che decide il numero**

Regola vincolante: **`METRO_PROP` §13.2, regola G2, CONGELATA il 21/08** —
_l'unita' di misura e' il **PACCHETTO**, non il ticket. Un referto che conta
ticket e' **nullo**, non "ottimista"._ Contare i ticket gonfia il campione fino
a **×3,9** e farebbe passare il muro dei 150 a un motore che non lo merita.

### La definizione operativa che ho implementato, in una riga

> 🔑 **UN PACCHETTO = UN SEGNALE VALIDO CHE HA MESSO ORDINI SUL MERCATO.**
> Nasce alla **chiusura della candela di segnale** (l'ancora `C` del corso),
> vive con **un solo SL e un solo TP**, e muore quando muore il pacchetto —
> **qualunque sia il numero di livelli che ha riempito, da 1 a 6.**

Tre conseguenze, tutte volute e tutte dichiarate:

| # | conseguenza | perche' |
|---|---|---|
| 1 | **Un pacchetto che riempie 6 livelli conta 1, non 6** | e' esattamente il punto di G2. Il numero dei livelli finisce **nell'istogramma**, mai nel conteggio |
| 2 | **Un pacchetto che riempie solo il livello 0 conta 1 lo stesso** | il livello 0 sta **a `C`**: e' l'ingresso del corso, riempito per costruzione (**assunzione A5**). Quindi ogni segnale valido vale gia' un pacchetto |
| 3 | **Un segnale che cade mentre il cross e' gia' occupato NON diventa un pacchetto** | il corso non pone cap (BUCO n.7), la spec propone "1 per cross" (**assunzione A4**). Quei segnali sono **contati a parte** e stampati: `scartati (cross occupato)`. Non spariscono |

### E i tre numeri che escono, per non confonderli mai

```
segnali validi grezzi      = quante volte il motore ha detto "entra"
scartati (cross occupato)  = quanti di quelli sono caduti a pacchetto aperto  [A4]
PACCHETTI                  = segnali - scartati   <-- IL NUMERO DELLA FIRMA
```

> ⚖️ **Perche' ho scelto la definizione piu' SEVERA delle due possibili.**
> Contare i segnali grezzi darebbe un numero **piu' alto** e piu' comodo. Ma un
> segnale che cade mentre il pacchetto precedente e' ancora vivo **non e' un
> evento indipendente**: e' lo stesso movimento, contato due volte. Il muro dei
> 150 esiste per garantire **eventi confrontabili**, non righe. Se il numero
> passa **con** questa severita', passa davvero; se non passa, il referto
> stampa **anche** il numero permissivo e si vede subito di quanto.

---

## 3. 🔢 LE ASSUNZIONI, NUMERATE — valore, e da dove viene

> 📌 Regola di casa: **se un valore e' inventato da noi, si scrive che e'
> inventato da noi.** Sono tutte in testa al sorgente, con lo stesso numero.

| # | assunzione | valore usato | da dove viene |
|---|---|---|---|
| **A1** | 🔴 **Parametri SuperTrend** | **ATR 10 / moltiplicatore 3,0** | **>>> INVENTATO DA NOI <<<**. Il corso **non li detta MAI**: la spec (§3.2) ha percorso la catena fino in fondo e **termina a vuoto** — il modulo base applica l'indicatore _"senza fare nessuna variazione"_, e il file **`super trend.ex4` della lezione 10, che conterrebbe i default veri, NON CE L'ABBIAMO** (richiesta **M15b**, ancora aperta a Claudio). Il valore e' lo **stesso gia' dichiarato in R82** per il Breakout del corso (decisione di Claudio 18/08), cosi' i due motori restano confrontabili. **Routine di calcolo ripresa da `ABTG_BreakoutCorso.mq5`**, non reinventata: un SuperTrend diverso non potra' spiegare una differenza fra i due round |
| **A2** | R-ATTESA **senza scadenza** | `InpAttesaMaxBarre = 0` | il corso dice _"altrimenti attendo la candela successiva"_ e **non mette mai un limite**. Il limite esiste come **input**, per poterlo misurare: **inventato da noi il fatto che un limite possa esistere** |
| **A3** | L'attesa **muore** se il SuperTrend torna indietro | `true` | **inventata da noi**. Il corso tace. Senza, un'attesa sopravvivrebbe a un intero controtrend |
| **A4** | **Un pacchetto per cross** alla volta | `true` | **scelta nostra**, ed e' la proposta della spec §10.2 n.5. Il corso non pone cap (BUCO n.7) e nel suo esempio ne mostra **due**, ma su **cross diversi** |
| **A5** | **Livello 0 sempre riempito**, alla chiusura della candela di segnale | — | e' l'ingresso del corso a `C`. **E' la definizione che decide il numero** (§2) |
| **A6** | Livelli 1..5 riempiti quando **minimo/massimo di una barra H1** tocca `L_k` | — | **esatto sui tocchi** (li' il prezzo e' passato davvero), **non** sull'ordine dentro la barra |
| **A7** | Se una barra tocca **sia SL sia TP** → si assume **SL** | `true` | ipotesi **prudente**. Senza dati a tick l'ordine dentro la barra non e' conoscibile — e questo script **non usa i tick per costruzione** |
| **A8** | **Uscita anticipata SPENTA** | `0` | e' l'**ambiguita' n.8** del corso (lez.31 contro lez.33), **mai sciolta**. Spenta e' la scelta **prudente sul conteggio**: i pacchetti durano di piu', occupano il cross di piu', quindi i pacchetti contati sono **di MENO**. Se passa i 150 cosi', passa a maggior ragione con l'uscita accesa |
| **A9** | **Riapertura dopo TP SPENTA** | `false` | il corso la ammette **una volta sola**. Stessa logica di A8: spenta conta **di meno** |
| **A10** | Nessun filtro **orario**, **news**, nessuno **spread**, nessuno **slippage** | — | BUCHI n.5 e n.6 della spec: il corso **non ha** ne' orari ne' news. Metterceli sarebbe **inventare regole** |

### ✅ E cosa NON e' un'assunzione (viene tutto dal corso, ed e' verificato)

| regola | valore | prova |
|---|---|---|
| timeframe | **H1** | `[T]` lez. 28 |
| universo | **EURUSD · GBPUSD · EURGBP** e solo quelli | `[T]` lez. 26, 27, 32, 33 (quattro volte) |
| Williams %R | **140 periodi** | `[T]` **5 occorrenze, 2 fonti umane indipendenti** (Negro + Fasciano) |
| zone / mediana | **−80 · −20 · −50** | `[T]` lez. 28 e 31, **coi valori letti ad alta voce** (−78,46 · −22,93 · −49) |
| sequenza del segnale | zona → **poi** flip SuperTrend → banda | `[T]` lez. 28 + 33 |
| invalidatore | oltre la **mediana** e' troppo tardi | `[T]` lez. 28, con la motivazione |
| geometria | `L_k = C − d·k·(P/2)` · `SL = C − d·3P` · `TP = C + d·P` | **21 valori su 21** verificati su 3 cross |
| `P` per cross | **40 / 70 / 20** pip | `[T]` lez. 29 |
| cap ingressi | **6** | `[T]` tre lezioni diverse |

> 🧪 **E la geometria non e' data per buona: e' un AUTOTEST.** All'avvio lo
> script ricalcola i **tre test-case del corso** (§10.3 della spec: GBPUSD BUY
> 1,2502 · EURGBP SELL 0,8598 · EURUSD SELL 1,0823) e pretende **21 valori su
> 21**. Se falliscono, **non conta niente e si ferma**: un conteggio fatto con
> la geometria sbagliata sarebbe un numero preciso, tondo e falso.

---

## 4. 🛠️ SCRIPT E NON EA — la scelta, e perche'

**Ho scelto uno SCRIPT.** Quattro motivi misurabili, non estetici:

| # | motivo |
|---|---|
| 1 | 🛑 **Non puo' aprire ordini nemmeno per sbaglio**: uno Script non ha `OnTick`, non e' un Expert, non riceve il permesso di trading dal tester, e nel file **non c'e' una sola chiamata di trading**. Il grep e' qui sotto e **deve uscire vuoto** |
| 2 | 📅 **Legge i tre cross in UNA corsa**: lo Strategy Tester gira **un simbolo alla volta**. Con un EA servirebbero 3 passate e 3 log da sommare a mano |
| 3 | 🧊 **Non tocca il Tester, quindi non incrocia il difetto pagato oggi** — _in ottimizzazione MT5 non esegue le `Print` degli agent_. **Qui non c'e' nessuna ottimizzazione**: e' un lancio singolo. E il numero **esce comunque dai dati**, non solo dalla stampa: lo script scrive **due CSV**, di cui uno con **una riga per pacchetto** (si puo' ricontare a mano) |
| 4 | 🧱 **Zero dipendenze**: **nessun `#include`**, nessun indicatore custom, nessun `.ex4` di terzi. E' il difetto **33-bis** della checklist (l'include che nessun driver installa e che il compilatore scopre a corsa avviata): qui non puo' presentarsi, e il grep lo dimostra |

### Il grep, da eseguire sul sorgente (deve uscire VUOTO)

```
grep -nE "OrderSend|CTrade|trade\.|PositionClose|PositionOpen|OrderModify|MqlTradeRequest" mql5/Scripts/ABTG_SondaMediazione.mq5
grep -nE "^#include|^#import" mql5/Scripts/ABTG_SondaMediazione.mq5
```

✅ **Eseguito il 21/08 sul commit `13db8c9`: entrambi VUOTI.**

> ⚠️ **E un difetto l'ho gia' pagato scrivendolo**, quindi lo dichiaro: la prima
> stesura aveva, **nel commento di intestazione**, la frase _"verificabile con
> un grep su OrderSend / CTrade / PositionClose"_ — e il grep **trovava quelle
> due righe di commento**. E' lo stesso inciampo di `diff_blocco_segnale` (commit
> `3ac9495`, _"confrontava intestazioni credendo di confrontare funzioni"_).
> Il commento e' stato riscritto: **ora il grep esce vuoto davvero.**

---

## 5. 📤 COSA STAMPA — e dove finisce il numero

**Nella scheda ESPERTI** (non il Giornale), per **ogni simbolo**:
- **barre lette** e **barre valutate**;
- 🕐 **la FINESTRA EFFETTIVA** (prima e ultima barra vere, con gli anni) — non
  quella richiesta: se il broker non ha lo storico, si vede subito;
- segnali validi · scartati per occupazione · **PACCHETTI** · pacchetti/anno;
- 📊 **istogramma dei LIVELLI riempiti (1..6)** e **% di pacchetti PIENI**;
- esiti (TP / SL / uscita anticipata / ancora aperti a fine finestra);
- **pieno E POI TP** (e' la misura **G3.6**: il ramo che paga di piu' ed e' anche
  quello che passa **piu' vicino** allo stop);
- durata media del pacchetto in barre.

**Poi il TOTALE sui tre cross**, la **tabella dei pacchetti per ANNO** (serve a
**dimensionare la finestra IS** secondo l'Emendamento A: si legge quanti anni
servono per arrivare a 150) e il **verdetto aritmetico**.

**Due CSV in `MQL5\Files`:**

| file | contenuto |
|---|---|
| `ABTG_SondaMediazione.csv` | una riga per simbolo + riga TOTALE + **una riga che ripete l'assunzione A1** (cosi' il valore inventato viaggia insieme al numero) |
| `ABTG_SondaMediazione_pacchetti.csv` | **una riga per PACCHETTO**: simbolo, ora del segnale, direzione, `C`, **livelli riempiti**, esito, durata, ora di chiusura. E' il file che permette di **ricontare il numero senza fidarsi della stampa** |

### 🚦 Il cancello della coda, gia' incorporato (G3.1)
Se i pacchetti **pieni** (6 livelli) sono **< 5%** del campione, lo script stampa
da solo **`CODA SOTTO-CAMPIONATA`**: la perdita piena non e' **stimata**, e'
solo **aritmetica**. Va detto, e da oggi si dice da solo.

---

## 6. 🐤 I CANARINI — cosa rende il numero NON valido

| se vedi | significa | cosa si fa |
|---|---|---|
| `AUTOTEST ... ERRORI` | la geometria non riproduce i 21 valori del corso | **lo script si ferma da solo**. Non c'e' niente da leggere |
| `barre lette` molto sotto ~90.000 su H1 dal 2010 | **manca lo storico**, non mancano i segnali | rifare il PASSO 0 della riga di lancio |
| `barre lette` identico e tondo su tutti e 3 (es. 100.000) | e' il tetto **"Max barre nel grafico"** di MT5, non il broker | alzarlo in Strumenti → Opzioni → Grafici, e **rilanciare** |
| `PACCHETTI = 0` su tutti e tre | non e' un verdetto: e' un **difetto** | segnalare, non concludere |
| `pacchetti/anno` > ~200 per cross | un pacchetto durerebbe pochissimo: sospetto di **doppio conteggio** | verificare sul CSV per pacchetto |
| `aperti a fine finestra` > 3 | ci sono piu' pacchetti aperti che cross | difetto della macchina a stati, da segnalare |

> 📌 **Nessun valore atteso e' stato scritto per il conteggio, ed e' voluto.**
> Dichiarare "mi aspetto ~200 pacchetti" prima di misurare e' il modo piu'
> rapido per leggere il risultato come lo si desidera. Qui si dichiarano i
> **canarini** (cosa sarebbe un difetto), **non** il risultato.

---

## 7. 🚫 COSA IL NUMERO **NON** DIRA'

Questa sezione vale quanto tutte le altre messe insieme.

1. ❌ **Non dira' se la Mediazione guadagna.** Un conteggio misura se il motore
   e' **MISURABILE**, non se e' **buono**. Non c'e' un euro di P&L in tutto lo
   script, e non e' una dimenticanza: **il sizing non e' firmato**.
2. ❌ **Non sciogliera' il fattore 2,29** (condizione n.1, la piu' pesante): quello
   si chiude col **file Excel della lez. 27** oppure con **una frase di Claudio**
   ("il sizing e' nostro"), mai con una misura di frequenza.
3. ❌ **Non dira' se una prop la ammette.** Misura e permesso sono **due cancelli
   diversi** (`METRO_PROP` §13.5): oggi l'unica riga "grid vietato" e' un video
   con link affiliati, e su FTMO esiste una **clausola discrezionale** sulle size
   non uniformi che la progressione ×1,5 (**7,59×** dentro lo stesso pacchetto)
   colpisce in pieno. Finche' non c'e' risposta scritta, vale **D3**.
4. ❌ **Non e' un backtest.** Nessuno spread, nessuno slippage, nessun costo,
   nessun tick: **barre H1 e basta**. Un pacchetto "chiuso in TP" qui vuol dire
   solo _"il prezzo e' passato di li'"_.
5. ❌ **Non e' un OOS.** Il conteggio guarda **tutta** la storia disponibile e
   stampa la tabella per anno: **e' materiale per DECIDERE dove mettere l'IS**,
   non una finestra gia' scelta. La finestra si sceglie **prima** dei numeri di
   merito, non dopo (Emendamento A).
6. ❌ **Non riabilita la pratica di Emiliano.** Quella fallisce **T1 e T3 con
   T4 = si'** ed e' **scarto a vista** per §13: il **"MAI" del 12/08 resta in
   vigore su quella**. Qui si misura **un altro oggetto** — il modulo del corso
   (lez. 26-33, Manuela Negro), che passa T1-T5 come **classificazione**.
7. ⚠️ **E dipende da A1.** Il SuperTrend e' **nostro**: un ATR/moltiplicatore
   diverso sposta i flip, quindi sposta **il numero**. Se il conteggio finisse
   **vicino** a 150 (diciamo 120-190), la risposta onesta non e' "passa" o "non
   passa": e' **"il numero dipende da un parametro che il corso non detta"**, e
   allora **M15b (il `.ex4` della lez. 10) diventa bloccante sul serio**.

---

## 8. 📋 LO STATO DELLE 6 CONDIZIONI DOPO QUESTA CONSEGNA

| # | condizione | prima | dopo |
|---|---|---|---|
| 1 | fattore 2,29 sul sizing | ❌ aperta | ❌ **aperta** (non la tocca) |
| 2 | SuperTrend = assunzione nostra | 🟡 mezza | 🟡 **mezza**, ma ora e' **scritta nel codice, nel CSV e qui** |
| 3 | unita' = PACCHETTO | 🟢 regola, ❌ strumento | 🟢 **regola + STRUMENTO**: lo script conta pacchetti e scrive un CSV per pacchetto |
| 4 | triangolo chiuso EUR/GBP/USD | 🟡 riconosciuta | 🟡 **invariata** (e' una regola di portafoglio, non di conteggio) |
| 5 | scheda della coda | 🟢 metro, ❌ dati | 🟡 **due misure su sei arrivano gratis**: G3.1 (istogramma + % pieni) e G3.6 (pieno poi TP). Le altre quattro vogliono un P&L, che qui non c'e' |
| 6 | 📏 **frequenza mai misurata** | ❌ **bloccante** | 🟢 **STRUMENTO PRONTO** — manca solo che giri sul PC di Claudio |

---

## 9. ✋ COSA NON HO FATTO, ED E' VOLUTO

- ❌ **Non ho scritto l'EA operativo della Mediazione.** Non e' firmato.
- ❌ **Non ho compilato e non ho backtestato**: MT5 e MetaEditor sono sul PC di
  Claudio. **Non ho un solo numero di questa sonda**, e non ne invento.
- ❌ **Non ho toccato niente in forward**, nessun preset, nessuna sedia.
- ❌ **Non ho scritto una riga di sizing**, di lotti o di rischio.
- ✅ Ho scritto **uno strumento che risponde a una domanda sola** — e che, se la
  risposta e' "meno di 150", **chiude il nodo senza altro lavoro**.
