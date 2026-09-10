# ✅ FIRMATO DA CLAUDIO — 10/09/2026, sera

> 🗊️ **Claudio, testuale: _"firma i criteri R125"_.**
>
> **I criteri di questo file sono CONGELATI da questo momento, a numeri non
> visti.** Nessuna cella di R125 e' mai girata: `git status` pulito, nessun CSV
> `r125*` nel repo, verificato prima della firma.
>
> 🔒 **Da qui in avanti valgono le regole di casa:** i criteri si cambiano
> **prima** dei numeri, non dopo. Se un risultato non piace, **non si tocca il
> criterio** — si dichiara l'esito e, se serve, si progetta un round nuovo con
> criteri nuovi, firmati anch'essi prima.
>
> 📜 **Cosa la firma autorizza:** 6 file prova, 33 celle, **66 passate**,
> **~7 minuti** di macchina sul **terminale di BACKTEST** (mai su quelli con le
> sedie vive). 🚫 **Non autorizza** nessuna modifica a EA, preset, parametri o
> sedie in forward, e **non tocca il conto reale**.
>
> 🚦 **Sei giri di cancello prima della firma**, sei FAIL, tutti corretti.
> Verbale: `report/FIRMA_R125_2026-09-10.md`.

---

# R125 -- ORB DENTRO LA FRONTIERA DEL COSTO -- CRITERI CONGELATI

> **Questi criteri si leggono PRIMA dei numeri. Data: 10/09/2026.**
> Se un numero di questo round viene letto senza questa pagina davanti,
> non vuol dire niente. Regola di casa, non formalita'.

## 0. LA DOMANDA DEL ROUND, in una riga

**Esiste una geometria dell'ORB che sta DENTRO la frontiera del costo di casa
(`stop >= 40 x spread` allo spread MISURATO NELL'ORA DEL TRADE) e che regge su
piu' di un simbolo?**

Non e' "quali parametri fanno il PF piu' alto". Il PF piu' alto lo conosciamo
gia' (R88: OPPRANGE, PF OOS 1,8385) e non e' mai stato il problema.

## 1. DA DOVE NASCE (tre fatti gia' misurati, non opinioni)

1. **R88 (19-20/08/2026, TICK REALI, U30USD, `r88_csv/`)**: le sei celle
   migliori per PF OOS sono TUTTE `InpSLMode=0` (OPPRANGE). La migliore:
   **PF OOS 1,8385 - DD OOS 3,840% - n 119** contro la cella viva
   (HALFRANGE) **PF OOS 1,6742 - DD OOS 9,7623% - n 119**.
   Bocciata da un cancello sul **PF IS** (1,063 contro 1,10 richiesto)
   applicato a **n IS = 71**.
2. **Emendamento della finestra, regola A (16/08)**: sotto 150 operazioni il
   **MERITO e' sospeso**. n IS = 71 e' sotto. R88 lo scrive da solo
   (`R88a_stoplargo_U30USD.txt`, blocco "CANARINO DELL'EMENDAMENTO").
3. **R118 (07/09, `REFERTO_R118_PAVIMENTO_STOP.md` par.3.3)**: allargare lo
   stop col buffer abbassa il DD OOS in modo **MONOTONO** su tutti e cinque i
   gradini di slippage: 10,2086 -> 8,8315 -> 8,1606 -> 7,6415 -> 6,9528.
   **"Non e' un picco: e' un piano inclinato."** Nessuno e' mai andato oltre
   **20 punti indice** di buffer.

## 2. IL CANCELLO DEL COSTO, APPLICATO PRIMA (e' lui che sceglie la griglia)

Spread **MISURATO** all'ora del trade, da 252 milioni di tick BCM
(`spread_flotta/spread_orario_*.csv`, finestra 2024.09.26-2026.06.30):

| simbolo | ora server | mediana | P95 | max |
|---|---|---:|---:|---:|
| U30USD | 14 (apertura cash USA) | **2,00** | 3,00 | 47,0 |
| NASUSD | 14 | **1,80** | 2,70 | 8,2 |
| D30EUR | 8 (apertura cash EU) | **1,70** | 2,70 | 12,0 |
| D30EUR | 7 (pre-apertura) | 2,80 | 4,10 | 19,1 |

Pavimento **DI LAVORO** `40 x spread` / pavimento **DURO** `13,3 x spread`:

| simbolo | 40x (mediana) | 13,3x | 40x (P95) |
|---|---:|---:|---:|
| U30USD | **80,0** pti idx | 26,6 | 120,0 |
| NASUSD | **72,0** | 23,9 | 108,0 |
| D30EUR | **68,0** | 22,6 | 108,0 |

## 3. LA REGOLA DI SELEZIONE DELLA CELLA -- SCRITTA QUI, PRIMA

**CENTRO DELL'ALTOPIANO, MAI IL PICCO.**
Operativamente, e senza margini di interpretazione:
- si guarda l'asse `InpSLBufferPts` come una **curva**, non come 7 numeri;
- si accetta una cella SOLO se **le due celle adiacenti** stanno dalla stessa
  parte del cancello e col PF entro **+/- 0,15** dalla cella scelta;
- se una cella sporge e le vicine no, il verdetto e'
  **"non c'e' una configurazione robusta"**, e si scrive cosi';
- fra due celle su un altopiano si prende **quella piu' interna**, non quella
  col PF piu' alto.

## 3-bis. LE CELLE DI **BORDO** -- congelata il 10/09/2026 dal cancello, PRIMA dei numeri

> 🔴 **Perche' esiste questo paragrafo.** Il par.3 chiede **"le due celle
> adiacenti"**. Il primo e l'ultimo valore di un asse ne hanno **UNA SOLA**: su
> di loro la regola **non e' verificabile**, e una regola verificabile a meta'
> non e' una regola. Finora la domanda non era mai arrivata perche' l'asse
> OPPRANGE aveva **tre punti** (0/500/1000) e il migliore era il **500**, cioe'
> il centro. Con **sette** punti la domanda arriva. 🛑 **E una regola di
> selezione scritta DOPO aver visto dove cade il massimo non e' una regola:
> per questo si scrive adesso.**

1. **Una cella di BORDO non e' MAI la cella SCELTA.** Nemmeno se e' la migliore
   su tutte e tre le metriche. Il par.3 punto 4 ("fra due celle si prende la
   piu' interna") gia' la scavalca da solo: qui lo si rende **esplicito**,
   perche' un'implicazione non e' un criterio.
2. **Un altopiano PUO' poggiare su un bordo**, e allora conta **che tipo di
   bordo e'**. I due tipi si elencano **per nome, asse per asse** (mai "tutto
   quello che non e' X"):

   | asse del round | bordo BASSO | tipo | bordo ALTO | tipo |
   |---|---|---|---|---|
   | `InpSLBufferPts` (R125a/c/f) | **0** | 🧱 **LIMITE FISICO** (un buffer negativo non esiste) | **3000** | ✂️ **FINE GRIGLIA** (l'ho scelto io) |
   | `InpTP1Pct` (R125b) | **0** | 🧱 **LIMITE FISICO** (nessun parziale) | **100** | 🧱 **LIMITE FISICO** (tutta la posizione a TP1) |
   | `InpMinRangePct` (R125e) | **0** | 🧱 **LIMITE FISICO** (nessun filtro) | **0,20** | ✂️ **FINE GRIGLIA** |
   | 🆕 `InpMagic` (**R125d**) | — | ⚙️ **ASSE TECNICO** | — | ⚙️ **ASSE TECNICO** |

   > 🆕 ⚙️ **R125d NON HA UN ASSE DI ALTOPIANO, e va detto qui perche' la
   > tabella dice di elencare gli assi "per nome" e lui e' il sesto file**
   > (classe 209, quinto giro). Il suo asse e' **tecnico**: `InpMagic` su
   > **due valori** (`779860` e `779870`), cioe' **due celle IDENTICHE PER
   > COSTRUZIONE**, entrambe **short**. Con 2 celle **P4 boccia sempre**,
   > quindi **la procedura 4-bis NON si applica a R125d**.
   > 🆕 🔴 **E QUI IL QUINTO GIRO AVEVA DESCRITTO UN ALTRO FILE -- classe 215,
   > SESTO giro.** Diceva *"2 celle gemelle **sullo stesso** `InpMagic`"*
   > (i magic sono **due e diversi**: e' l'asse) e soprattutto *"il confronto
   > e' fra **due rami (long / short)**"*. 🛑 **Dentro `R125d` non c'e' nessun
   > ramo long:** il file lo scrive da solo (*"l'asse e' il MAGIC su due
   > valori: DUE CELLE IDENTICHE PER COSTRUZIONE"*), e serve a regalare gratis
   > il **cancello di casa `G1` (gemelli / determinismo — da non confondere con
   > `R125-G1`, che qui e' il RISCHIO)**. Il lato **long** del DAX sta in
   > `R125c`/`R125e`, non qui. 👉 Verdetto: **le due celle si leggono
   > INSIEME** — se non escono identiche al centesimo il banco e' sporco e il
   > round si ferma **prima** di qualunque altro numero — e **solo dopo** il
   > lato short si giudica coi cancelli `R125-G0..G4`.
   > **Non e' un buco: e' un file che risponde a un'altra domanda.**

3. 🧱 **Bordo che e' un LIMITE FISICO**: dall'altra parte non c'e' una misura
   che manca, c'e' **un valore che non esiste**. L'altopiano e' **CHIUSO** da
   quel lato: la cella di bordo **resta dentro il blocco e conta** (passo P5),
   ma **non e' scegliibile** (passo P6). La scelta poi la fa la **procedura di
   4-bis**, non l'aggettivo *"interna"*. Nessuna penalita', e va detto:
   **non e' un buco**.
4. ✂️ **Bordo che e' la FINE DELLA GRIGLIA**: li' il vuoto e' **una misura
   che MANCA**. Una cella di questo tipo **si toglie dal blocco prima di
   contare** (procedura qui sotto, passo **P5**), e se quel che resta non
   regge, **quel BLOCCO e' annullato**.
   🆕 ⚠️ **Attenzione, riscritto al quinto giro (classe 209):** l'annullamento
   colpisce **il blocco**, **non l'asse**. Se un **altro** blocco sopravvive, lo
   ripesca **P3-bis** e una cella si sceglie lo stesso -- portandosi dietro la
   dichiarazione *"asse APERTO da quel lato"*. Il verdetto
   **"L'ALTOPIANO, SE C'E', ESCE DALLA GRIGLIA"** -- 🛑 **non si sceglie niente
   su quell'asse**, e la risposta e' **estendere l'asse di almeno due gradini**
   in un round successivo -- si pronuncia **solo se NON sopravvive nessun
   blocco**. La prima stesura diceva *"non si sceglie niente su quell'asse"*
   **sempre**, e cosi' buttava via altopiani gia' misurati.
   - 📌 **Estendere un asse NON viola la regola del 19/08** ("niente parametri
     diversi di un motore morto"): li' si vieta di infittire la griglia di un
     motore **gia' dichiarato senza edge**; qui si **chiude una misura che la
     griglia aveva tagliato**. E si paga con la **stessa** prova fuori campione
     del par. 4 del dossier, non con una piu' morbida.

### 🆕 4-bis. 🤖 LA PROCEDURA, PASSO PER PASSO -- perche' *"il centro dell'altopiano"* NON e' un'istruzione

> 🔴 **Perche' questo blocco esiste -- classe 206, QUARTO giro di cancello,
> 10/09/2026.** Il par. 3-bis era stato scritto prima dei numeri, ed era la
> cosa giusta da fare. Ma **non era stato provato col contro-esempio**, come
> impone la regola del 10/09 -- e messo alla prova **non ha retto**: 🔴 **due
> lettori onesti, con la STESSA griglia in mano, arrivavano a due verdetti
> OPPOSTI.** Una regola di selezione che ammette due risposte non e' una
> regola: e' una preferenza. Qui sotto c'e' la versione che ne ammette **una
> sola**, e il contro-esempio che la prova.

**P1. AMMISSIBILI.** E' ammissibile ogni cella che passa `R125-G0`, `R125-G1`,
`R125-G2`, `R125-G3` **e** `R125-G4`. Una cella non ammissibile **spezza**: non
puo' stare dentro nessun blocco.

> 🆕 🔴 **`R125-G3` E' ENTRATO IN P1 AL QUINTO GIRO DI CANCELLO -- classe 210.**
> La v2 elencava solo `G0/G1/G2/G4`, cioe' **costo, rischio e campione**, e
> lasciava fuori il **PF**. Messa alla prova su una griglia costruita apposta
> **si rompeva**, e non in un caso di scuola: `PF = 1,70 · 1,75 · 1,80 | 1,05 ·
> 1,00 · 0,95 · 0,90` con **DD in calo monotono** (3,2-4,2%, tutti ammissibili
> per il rischio). I blocchi massimali sono `{0,500,1000}` (span 0,10, **tutte
> e tre sopra 1,40**) e `{1500,2000,2500,3000}` (span 0,15, **tutte e quattro
> SOTTO 1,00**). 🔴 **P3 premia il piu' LUNGO: vinceva l'altopiano di celle
> PERDENTI**, P7 sceglieva la **2000** a PF **1,00**, e il round chiudeva con
> *"la cella scelta non passa R125-G3, nessuna configurazione"* -- **mentre un
> altopiano da tre celle a PF 1,70-1,80 stava li' misurato e non veniva mai
> nominato.** E' un **falso NEGATIVO**, cioe' l'occasione persa che il motto
> del 09/09 vieta.
> ⚠️ **Non e' un caso raro su QUESTO asse:** allargare il buffer abbassa il DD
> (R118) e diluisce l'edge, quindi *"coda lunga, piatta, perdente e con poco
> DD"* e' **la forma attesa** del fondo dell'asse.
> 📌 **E non contraddice P3:** il PF entra come **SOGLIA di ammissibilita'**
> (una cella sotto 1,40 non e' materiale da altopiano), **mai** come criterio
> di **ordinamento** fra blocchi. Le due cose restano separate.
>
> 🛑 **E LA CONTROPARTITA, che si scrive adesso perche' altrimenti questa
> correzione DISTRUGGE UNA MISURA.** Con `G3` in P1, una griglia piatta ma
> poco redditizia (per esempio tutto l'asse a **PF 1,20**) non ha piu' nessun
> blocco, e il round rischierebbe di archiviare *"niente"* dove invece c'e'
> **una forma misurata**. 👉 **Obbligo:** **ogni volta che `R125-G3` esclude
> almeno una cella** si calcolano **lo stesso** i blocchi ignorando `G3` (e
> **soltanto** `G3`: gli altri quattro cancelli restano attivi) — sono i
> **"blocchi GEOMETRICI"** — e si scrivono nel referto con la dicitura
> **"FORMA GEOMETRICA: si legge come misura, non si sceglie"**, col PF, il DD
> e l'`n` di ogni cella. **Un altopiano piatto a PF 1,20 e' un fatto sul
> motore** (dice che la manopola non morde), e i fatti non si buttano:
> e' la regola del 09/09 (*"non si scarta niente senza scriverne il NUMERO e
> il MOTIVO"*).
>
> 🆕 🔴 **E QUI SI CHIUDE LA PORTA DI SERVIZIO -- classe 212, SESTO giro di
> cancello, 10/09/2026.** La v3 diceva *cosa calcolare* e non diceva **che
> quel calcolo non sceglie niente**, e la procedura `P1..P8` i blocchi
> geometrici non li nomina affatto. Eseguita, la doppia lettura **si rompe**:
> su `PF = 1,60 · 1,70 · 1,75 | 1,30 · 1,32 · 1,35 · 1,38` (DD tutti 5,0%) il
> ramo ammissibile sceglie la **500** e il ramo geometrico sceglie la **2000**
> (PF **1,32**, sotto il cancello). E il caso peggiore non e' nemmeno questo:
> su `PF = 1,48 · 1,45 · 1,42 · 1,38 · 1,35 · 1,33 · 1,30` il ramo geometrico
> sceglie la **1000**, che ha **PF 1,42 e passa `R125-G3`** — cioe' una cella
> **indistinguibile in referto da una cella scelta regolarmente**, tirata pero'
> fuori da un blocco costruito **ignorando il PF**. Quella e' una **promozione
> mascherata**, e si chiude con tre frasi, non col buon senso di chi legge:
> 1. 🚫 **Un blocco GEOMETRICO non entra MAI in `P3`, `P5`, `P6`, `P7`.** La
>    procedura `P1..P8` gira **una volta sola**, sui blocchi di `P2`, cioe' su
>    celle **tutte ammissibili**. Il calcolo geometrico e' una **fotografia**:
>    produce un elenco di celle con i loro numeri, **non produce una cella
>    scelta**, e la parola *"scelta"* accanto a un blocco geometrico e' un
>    errore di lettura.
> 2. 🚫 **Nessuna cella nominata dentro un blocco GEOMETRICO puo' essere
>    proposta, promossa, messa in forward o citata come candidata** — nemmeno
>    se quella singola cella passa tutti e cinque i cancelli. Se una cella
>    merita, esce da `P7` **dal ramo ammissibile**: non c'e' una seconda porta.
> 3. 📌 **Nel referto i due elenchi stanno in due riquadri SEPARATI e
>    ETICHETTATI**, mai nella stessa tabella: `BLOCCHI (P2)` e
>    `FORMA GEOMETRICA (non si sceglie)`. Un numero giusto nella colonna
>    sbagliata e' un numero sbagliato.
>
> 🆕 ⚠️ **E il caso VUOTO tira da tutte e due le parti -- classe 213, sesto
> giro.** L'esempio scritto qui sopra (*tutto l'asse a PF 1,20*) e' **esattamente
> e solo** il caso in cui `P2` dice *"NESSUNA CELLA AMMISSIBILE ... la
> procedura si ferma qui"*. Le due regole sono nate lo stesso giorno, dalla
> stessa classe 210, e **non si citavano**. 👉 **Si compongono cosi', e
> l'ordine e' quello scritto:** `P2` ferma **la scelta**, non **la
> misura**. Quando non c'e' nessuna cella ammissibile si scrive **prima** il
> verdetto di `P2` (coi cancelli per nome, cella per cella) e **poi**, se
> `R125-G3` ha escluso almeno una cella, il riquadro
> **`FORMA GEOMETRICA (non si sceglie)`**. **Il round chiude comunque a mani
> vuote**: la fotografia non e' un'uscita di riserva.

**P2. BLOCCHI.** Un **BLOCCO** e' una sequenza di celle **contigue sull'asse**,
tutte ammissibili, in cui **`max(PF OOS) - min(PF OOS) <= 0,15` calcolato sul
BLOCCO INTERO** -- **non** fra vicine. 🔴 **E' qui che la v1 si rompeva:**
*"entro +/- 0,15 dalla cella scelta"* **non e' transitivo**, quindi l'insieme
dipendeva da **quale cella si guardava per prima**. Si elencano tutti i blocchi
**MASSIMALI** (non allungabili di una cella da nessuno dei due lati); possono
sovrapporsi.
- 📏 **Un blocco puo' avere anche UNA o DUE celle** (una cella isolata e' un
  blocco di lunghezza 1: lo span vale 0). Serve dirlo, perche' P4 boccia
  *"sotto le 3 celle"* e quella soglia presuppone che i blocchi corti esistano.
- 🆕 🛑 **E se NON c'e' NESSUNA cella ammissibile, non c'e' nessun blocco e
  la procedura si ferma qui** (classe 210): il verdetto e'
  **"NESSUNA CELLA AMMISSIBILE"**, si scrive **quale cancello** ha escluso
  ognuna delle celle **per nome** (mai "tutte le altre"), e **non si sceglie
  niente**. La v2 non nominava questo caso e su di esso non aveva output.
  🆕 📌 **"Si ferma qui" vuol dire che si ferma la SCELTA, non la MISURA**
  (classe 213, sesto giro): se `R125-G3` ha escluso almeno una cella, il
  riquadro **`FORMA GEOMETRICA (non si sceglie)`** del commento a `P1` si
  scrive **lo stesso**, **dopo** questo verdetto e **senza** cambiarlo.

**P3. QUALE BLOCCO.** Vince quello con **piu' celle**. Spareggi, in
quest'ordine: (a) **DD OOS massimo piu' basso** dentro il blocco; (b)
**parametro piu' basso**. 🚫 **Il PF non entra nella scelta del blocco** oltre
alla banda di P2 e alla soglia di P1.

**🆕 P3-bis. RIPESCAGGIO -- il blocco che MUORE non uccide l'asse (classe 209).**
Se il blocco vincente viene **annullato da P5 o da P6**, quel blocco **esce
dalla corsa** e si **torna a P3** sui blocchi rimasti. Il verdetto globale
**"L'ALTOPIANO, SE C'E', ESCE DALLA GRIGLIA"** si pronuncia **solo quando NON
sopravvive nessun blocco**.
> 🔴 **Perche'.** La v2 si fermava al primo blocco vincente, e su questa griglia
> dava **due risposte**: `PF = 1,70 · 1,74 · 1,78 | 1,20 | 1,60 · 1,66 · 1,72`
> con DD `5,90 · 5,80 · 5,85 | 6,00 | 4,10 · 4,05 · 3,90`. Blocchi massimali:
> `{0,500,1000}` e `{2000,2500,3000}`, **tutti e due da 3 celle**. Lo spareggio
> (a) guarda il **DD massimo** e premia il secondo (4,10 contro 5,90) -- poi
> **P5 gli toglie la 3000 e ne restano 2**. 🔴 **Lettore 1** si ferma li':
> *"esce dalla griglia, si estende l'asse"*. 🔴 **Lettore 2** vede che
> `{0,500,1000}` e' intatto (il **0** e' 🧱 limite fisico, non si toglie) e
> sceglie la **500**. **Stessa griglia, due verdetti** -- ed e' il difetto
> **206 nella sua seconda vita**, spostato da P2 a P3.
> ⚠️ **E su questo asse e' il caso PIU' PROBABILE, non un caso limite:** il DD
> **cala col buffer** (R118), quindi a parita' di lunghezza lo spareggio (a)
> premia **quasi sempre** il blocco piu' a destra -- che e' proprio quello che
> contiene il bordo ✂️ **3000** e che P5 accorcia. Senza P3-bis il verdetto
> tipico del round sarebbe *"estendi l'asse"* **anche quando un altopiano buono
> e' gia' misurato piu' a sinistra**.

**P4. SOGLIA DI ESISTENZA.** Se il blocco vincente ha **meno di 3 celle**,
**non c'e' altopiano**: verdetto *"non c'e' una configurazione robusta"*
(par.3), e **non si sceglie niente**.

**P5. BORDI ✂️ FINE GRIGLIA.** Si tolgono dal blocco. Se dopo averli tolti
restano **meno di 3 celle**, il blocco e' **ANNULLATO** -> si applica
**P3-bis** (ripescaggio); se non sopravvive nessun blocco, verdetto
**"L'ALTOPIANO, SE C'E', ESCE DALLA GRIGLIA"** e si estende l'asse.
🔴 **In tutti e due i casi l'annullamento si PORTA DIETRO il suo verdetto:**
qualunque cosa esca dopo il ripescaggio -- una cella scelta **oppure** il
*"non c'e' una configurazione robusta"* di P4 -- si scrive **ANCHE**
*"l'asse e' APERTO da quel lato e va esteso di almeno due gradini"*.
👉 **Il ripescaggio sceglie, non assolve.**
🧱 **I bordi LIMITE FISICO NON si tolgono**: restano a contare (dall'altra
parte non manca una misura, manca un valore che non esiste).
🆕 🔴 **E LA CLAUSOLA VALE ANCHE PER IL BLOCCO DI BORDO CHE *PERDE* -- classe
216, SESTO giro.** Fin qui *"l'asse e' APERTO da quel lato"* si scriveva solo
se il blocco appoggiato al bordo ✂️ **vinceva** `P3` (e poi veniva annullato).
Eseguita, la regola lascia muto il caso piu' banale: su
`PF = 1,60 · 1,62 · 1,65 · 1,68 | 1,90 · 1,92 · 1,95` (DD tutti uguali) i
blocchi sono `{0,500,1000,1500}` (4 celle) e `{2000,2500,3000}` (3 celle,
**il PF piu' alto della griglia**, appoggiato al 3000 tagliato). Vince il
primo **per lunghezza**, il secondo **non viene mai annullato perche' non e'
mai stato esaminato**, e il referto **non dice** che l'altopiano potrebbe
continuare oltre la griglia. E' lo stesso falso NEGATIVO della classe 210 in
un'altra veste. 👉 **Obbligo:** la frase *"l'asse e' APERTO da quel lato e va
esteso di almeno due gradini"* si scrive **ogni volta che un blocco di `P2`
CONTIENE un bordo ✂️**, che quel blocco vinca, perda o venga annullato.

**P6. SCEGLIIBILI.** Dal **blocco residuo** (= il blocco dopo P5) si tolgono la
**prima** e l'**ultima** cella (non hanno due vicine dentro il blocco, quindi il
par.3 su di loro non e' verificabile) **e ogni cella di bordo, di qualunque
tipo**. Quel che resta sono le **SCEGLIIBILI**. Se l'insieme e' vuoto, il blocco
e' **ANNULLATO** -> **P3-bis**, e il verdetto e' quello di P5 solo se non
sopravvive nessun blocco.

**P7. LA CELLA.** Si prende la scegliibile il cui **indice sull'asse** e' piu'
vicino al **baricentro del BLOCCO RESIDUO di P5** (media aritmetica degli indici
delle sue celle, **prima** delle rimozioni di P6). Spareggi, in quest'ordine:
(a) **DD OOS piu' basso** -- il rischio si legge a qualunque n, Emendamento B;
(b) **parametro piu' basso**. 🚫 **Mai il PF.**
> 📌 Il riferimento e' scritto per esteso apposta. Su un blocco **contiguo** i
> due baricentri (prima e dopo P6) **coincidono** -- togliere la prima e
> l'ultima cella non sposta la media -- ma la coincidenza e' un **fatto da
> verificare**, non una definizione: scritta cosi', la frase non ha bisogno che
> il lettore la ricalcoli.

**P8. DICHIARAZIONE OBBLIGATORIA.** Accanto al numero si scrivono: **tutti i
blocchi massimali** trovati da P2, il **blocco vincente**, la **cella scelta**,
**quale passo l'ha decisa** e -- se P5 ha tolto un bordo ✂️ -- la frase
**"asse APERTO da quel lato: il centro vero puo' stare oltre la griglia, e NON
e' misurato"**.
- 🆕 🔴 **E se P3-bis ha ripescato** (classe 209): si scrive **quale blocco e'
  stato annullato, da quale passo e quanto era lungo**, con la frase
  **"esisteva un blocco altrettanto lungo o piu' lungo che USCIVA dalla
  griglia: l'asse va esteso lo stesso in un round successivo"**. 👉 Il
  ripescaggio **non cancella il buco**: sceglie una cella **e** lascia scritto
  che una misura manca. Senza questa riga, ripescare diventerebbe un modo di
  non vedere il bordo.

#### 🧪 IL CONTRO-ESEMPIO CHE HA BOCCIATO LA v1 (costruito prima di consegnare)

Griglia di prova, PF OOS: **1500 -> 1,42 · 2000 -> 1,55 · 2500 -> 1,68 ·
3000 -> 1,70**, tutte ammissibili.

| lettore | con la v1 del par. 3-bis | esito |
|---|---|---|
| ancora sulla **2500** | vicine 2000 (Δ 0,13) e 3000 (Δ 0,02) -> altopiano `{2000,2500,3000}` -> tolto il bordo restano **2** | 🛑 **"esce dalla griglia": si estende l'asse** |
| ancora sulla **2000** | vicine 1500 (Δ 0,13) e 2500 (Δ 0,13) -> `{1500,2000,2500}`, e la 3000 si attacca alla 2500 -> **4** celle -> tolto il bordo ne restano **3** | ✅ **"si sceglie la 2000"** |

🔴 **Stessa griglia, verdetti opposti** -- e uno dei due promuove una cella sul
fianco di una salita, che e' esattamente il caso che il par. 3-bis diceva di
voler evitare.

🟢 **Con la procedura la risposta e' UNA:** `span{1500,2000,2500}` = **0,26 >
0,15**, quindi non e' un blocco. I blocchi massimali sono `{2000,2500,3000}`
(span **0,15**) e `{1500,2000}` (span 0,13). P3 -> vince il primo (3 celle).
P5 toglie la 3000 -> restano **2** -> il blocco e' **ANNULLATO**. P3-bis
ripesca `{1500,2000}`, che ha **2 celle** -> **P4: "non c'e' una configurazione
robusta"**, e alla riga si aggancia la clausola di P5:
**"l'asse e' APERTO a destra e va esteso di almeno due gradini"**.
👉 **Non si sceglie niente e l'asse si allunga** -- stesso esito pratico della
v2 su questa griglia, ma ottenuto da **passi che valgono anche sulle griglie
dove un altro blocco sopravvive** (v. P3-bis). Non c'e' una seconda lettura.

🧪 **E il secondo contro-esempio, il PAREGGIO** (che la v1 non nominava
affatto): blocco `{0, 500, 1000, 1500}`. Il baricentro cade sull'**indice 1,5**,
cioe' **esattamente fra 500 e 1000**: la v1 diceva *"la piu' interna"* e non
c'era **nessuna** cella piu' interna dell'altra. P7 spareggia col **DD OOS piu'
basso**, e se anche quello pareggia al centesimo, col **parametro piu' basso**
(la **500**).

⚠️ **E "interna" rispetto a COSA**, che era la terza ambiguita': la v1 non lo
diceva, e su `{1500,2000,2500}` "interna all'ASSE" da' **1500** mentre "interna
all'ALTOPIANO" da' **2000**. 👉 **P7 fissa il riferimento: il baricentro del
BLOCCO**, mai quello dell'asse.

#### 🆕 🧪 LE OTTO GRIGLIE AVVERSARIE DEL QUINTO GIRO -- la procedura ESEGUITA, non solo scritta

> 🔴 **Perche' questa tabella esiste.** La v2 dichiarava da sola:
> *"non e' stata eseguita su una griglia vera... l'ho provata solo sui due
> contro-esempi che ho costruito io"*. Il quinto giro di cancello l'ha fatta
> girare **a mano su otto griglie costruite per ROMPERLA**, sull'asse vero a 7
> valori (0..3000). **Due l'hanno rotta** (righe 🔴, classi **209** e **210**),
> **sei hanno retto**. Qui ci sono tutte e otto, comprese quelle passate:
> un elenco di soli difetti descrive male la realta', ed e' regola di casa.

> 🆕 🔴 **E LA COLONNA `DD OOS` E' STATA AGGIUNTA AL SESTO GIRO -- classe 214.**
> La v3 stampava **solo i PF**, ma `P3` spareggia col **DD massimo del blocco**
> e `P7` spareggia col **DD della cella**: senza quei numeri **la tabella non
> e' ri-eseguibile**, ed e' il criterio che la tabella stessa dichiara due
> righe piu' sotto. Rieseguita coi DD **tutti uguali** (l'unica lettura
> possibile per chi ha in mano solo i PF), **quattro righe su otto davano un
> risultato diverso da quello scritto**: la **6** dava **500** invece di
> **1500** (cella diversa!), la **1** dava **1000** invece di **1500** (cioe'
> era identica alla 1b), e nella **2** e nella **5** il **ripescaggio P3-bis
> non scattava affatto** -- proprio nelle righe messe li' a dimostrare la
> classe 209. 👉 I DD sono adesso **scritti**, e con questi numeri tutte e
> dieci le righe tornano.

| # | PF OOS sui 7 valori | DD OOS sui 7 valori | cosa mette alla prova | esito v2 | v3/v4 |
|---|---|---|---|---|---|
| 1 | `0,90 \| 1,60 1,66 1,70 1,72 \| 1,10 1,05` | `5,00 5,00 4,60 4,40 5,00 5,00 5,00` | altopiano di lunghezza **PARI** (4 celle) | 🟢 baricentro **2,5**, scegliibili 1000 e 1500 **a pari distanza**, spareggio DD -> **1500** (P7) | invariata |
| 1b | idem | `4,50` su tutte e sette | lo spareggio (b) esiste davvero? | 🟢 -> **1000** (parametro piu' basso, P7) | invariata |
| 2 | `1,50 1,55 1,60 \| 1,20 \| 1,70 1,80 1,84` | `5,90 5,80 5,85 6,00 4,10 4,05 3,90` | **due blocchi massimali della STESSA lunghezza** | 🔴 **DUE VERDETTI**: *"estendi l'asse"* oppure **500** | **classe 209** -> P3-bis: **500** (P6), + *"asse APERTO a destra"* |
| 3 | `1,60 1,62 1,65 1,68 1,70 1,72 1,74` | `4,30` su tutte e sette | altopiano che tocca **tutti e due i bordi** | 🟢 P5 toglie solo la 3000 (🧱 la 0 resta), baricentro 2,5, 1000 e 1500 a pari distanza **e a pari DD** -> spareggio (b) **parametro piu' basso** -> **1000** (P7), + frase d'obbligo | invariata |
| 4a | `0,80 1,10 1,45 1,80 2,20 2,60 3,00` | `4,00` su tutte e sette | **nessuno** span sotto 0,15 | 🟢 **sette** blocchi da 1 cella -> **P4: "non c'e' una configurazione robusta"** | stesso verdetto, ma i blocchi sono **cinque**: con `G3` in P1 la 0 (0,80) e la 500 (1,10) non sono piu' ammissibili. E P2 ora **dice** che i blocchi da 1 cella esistono. 🆕 **E scatta il riquadro `FORMA GEOMETRICA`** (classe 212): senza `G3` i blocchi tornano **sette** |
| 4b | `1,60` su tutte e sette | `12,00` su tutte e sette | **nessuna cella ammissibile** | 🔴 **nessun blocco: la procedura non aveva output** | **classe 210** -> P2: *"NESSUNA CELLA AMMISSIBILE"*, con i cancelli per nome (qui: `R125-G1` su tutte e sette). 🆕 **Nessuna forma geometrica**: `G3` non ha escluso niente |
| 5 | `1,60 1,62 1,65 1,66 1,68 1,70 1,72` | `5,90 5,80 5,85 8,90 4,10 4,05 3,90` | **buco in mezzo**: cella che passa il PF ma **non** il rischio | 🟢 la cella non ammissibile **spezza** (P1), restano `{0,500,1000}` e `{2000,2500,3000}` | 🟢 + P3-bis sceglie la **500** (P6) invece di fermarsi |
| 6 | `1,40 1,50 1,55 1,60 1,70 1,85 2,00` | `6,00 5,80 4,50 4,40 4,30 5,00 5,00` | **ancoraggi diversi** (era il difetto 206) | 🟢 **cinque** blocchi massimali enumerati **senza dipendere da dove si parte** -> spareggio (a) DD -> `{1000,1500,2000}` -> **1500** (P6) | invariata |
| 7 | `1,70 1,74 1,78 \| 1,20 \| 1,60 1,66 1,72` | `5,90 5,80 5,85 6,00 4,10 4,05 3,90` | il blocco vincente **muore in P5** mentre un altro **sopravvive** | 🔴 **DUE VERDETTI**: *"estendi"* oppure **500** -- e il blocco buttato aveva **il PF piu' alto della griglia** | **classe 209** -> **500** (P6) + *"asse APERTO a destra"* |
| 8 | `1,70 1,75 1,80 \| 1,05 1,00 0,95 0,90` | `4,20 4,00 3,80 3,60 3,40 3,30 3,20` | altopiano **PERDENTE** piu' lungo di quello buono | 🔴 sceglieva la **2000 a PF 1,00** e il round chiudeva a mani vuote | **classe 210** -> `G3` in P1: le perdenti non sono ammissibili -> **500** (P6). 🆕 **+ riquadro `FORMA GEOMETRICA`** con **tutti e due** i blocchi per nome — `{0,500,1000}` e `{1500,2000,2500,3000}` — che **non si scelgono** (classe 212) |

🎯 **Il criterio con cui sono state giudicate**, e va scritto: *due persone con
la procedura in mano e la stessa griglia devono scegliere la STESSA cella, e
devono poterlo dimostrare **citando il passo**.* Le righe 2, 4b, 7 e 8 non lo
passavano alla v2; le righe **1, 2, 5 e 6** non lo passavano alla **v3**, per
mancanza della colonna DD (classe 214).

#### 🆕 🧪 LE SEI GRIGLIE DEL SESTO GIRO -- e le TRE cose che il sesto giro NON e' riuscito a rompere

> 🔬 **Come sono state girate.** Il simulatore della procedura e' stato
> **riscritto da zero dal TESTO** di questo paragrafo (classe **186**: il banco
> che esamina non puo' essere lo stesso che ha scritto il compito), e poi
> lanciato **anche in forza bruta su 200.000 griglie casuali** (PF 0,80-2,20,
> DD 2,0-9,0%).

| # | cosa attacca | esito |
|---|---|---|
| N1 | il **ripescaggio due volte di fila** | 🟢 **NON E' RAGGIUNGIBILE** su nessuno dei tre assi di R125. `P5` annulla solo un blocco che contiene un bordo ✂️, e i bordi ✂️ sono **uno per asse**: due blocchi **massimali** che lo contengono sarebbero **annidati**, quindi non entrambi massimali. Massimo misurato su 200.000 griglie: **1 ripescaggio**. 📌 Se un round futuro usasse un asse con ✂️ **da tutte e due le parti**, la cosa cambierebbe: **allora** il ciclo di P3-bis servirebbe davvero |
| N2 | blocco **geometrico** e blocco **ammissibile** che indicano **celle diverse** | 🔴 **classe 212** -> **500** contro **2000**. Chiuso col divieto esplicito |
| N3 | il blocco **geometrico e' l'unico che esiste** | 🔴 **classe 213** (collisione col caso vuoto di P2) -> ordine di scrittura fissato |
| N4 | il **ripescaggio svuota tutto**: caso vuoto **non** da P4 | 🟢 con ammissibili `{2000,2500,3000}` soltanto: P5 annulla, non resta nessun blocco -> **"L'ALTOPIANO, SE C'E', ESCE DALLA GRIGLIA"**. Con in piu' una cella isolata a sinistra: ripescaggio -> blocco da 1 cella -> **P4** + clausola. Tutti e due deterministici |
| N5 | il **grilletto** della contropartita | 🔴 con *"l'unico cancello che esclude e' G3"* bastava **una** cella fuori per `R125-G1` per spegnere l'obbligo e perdere la stessa misura. Grilletto riscritto: **ogni volta che `G3` esclude almeno una cella** |
| N9 | il blocco di bordo che **perde** e non viene mai esaminato | 🔴 **classe 216** -> la frase *"asse APERTO"* ora scatta se un blocco **contiene** un bordo ✂️, non solo se lo perde |

🟢 **E LE TRE COSE CHE HANNO RETTO, misurate su 200.000 griglie** (vanno scritte:
un elenco di soli difetti descrive male la realta'):
1. **`P3` non pareggia mai**: **0** casi irrisolti. Il motivo e' strutturale --
   due blocchi massimali non possono avere la stessa cella iniziale (sarebbero
   annidati), quindi lo spareggio (b) *"parametro piu' basso"* **chiude sempre**.
2. **`P7` non pareggia mai**: **0** casi irrisolti, stesso motivo (il parametro
   e' unico per cella).
3. **La nota di `P7` sui due baricentri e' VERA**: **0** discordanze fra il
   baricentro del blocco residuo e quello calcolato dopo `P6`. E c'e' la
   dimostrazione, non solo il conteggio: togliere la **prima** e l'**ultima**
   cella di un blocco contiguo **non sposta la media**, e ogni cella di bordo
   ancora presente dopo `P5` **e' gia'** la prima o l'ultima del residuo.
   👉 **Corollario dello stesso conto: il ramo *"`P6` annulla il blocco"* e'
   IRRAGGIUNGIBILE** (0 casi su 200.000): un residuo di 3+ celle contigue lascia
   sempre almeno una scegliibile. Non e' un difetto -- e' una cintura in piu' --
   ma va detto, perche' `P3-bis` dice *"annullato da P5 **o da P6**"* e la
   seconda meta' **non si e' mai vista**.

4-ter. ⚖️ **QUANDO PAR.3, 3-bis E LA PROCEDURA DICONO COSE DIVERSE, VINCE
   SEMPRE LA PROCEDURA `P1..P8`** -- e vale anche per **questo** paragrafo e per
   il **§3.3 del dossier**, dove la forma vecchia e' conservata solo come
   storia (classe 209). Il caso concreto e' quello della tabella qui sopra: per
   il par.3 nudo la **2500** sarebbe accettabile; per la procedura il verdetto
   e' **"non c'e' una configurazione robusta"** (P4, dopo che P3-bis ha
   ripescato `{1500,2000}`) **piu' la clausola "l'asse e' APERTO a destra e va
   esteso"** (P5). 📌 In tutte e due le letture della procedura -- v2 e v3 --
   **la 2500 NON si sceglie**: cambia il nome del verdetto, non l'esito.
   🔴 **E la differenza fra il par.3 nudo e la procedura -- cioe' il motivo per
   cui vince la procedura -- e' che il 2500 potrebbe essere
   il centro dell'altopiano oppure il fianco di una salita che la griglia ha
   tagliato, e i due casi danno lo stesso quadro di numeri.** Il costo di
   sbagliare (una cella promossa sul fianco) e' una challenge; il costo di
   allungare l'asse e' **7 celle = 14 passate = ~1,4 minuti** al ritmo misurato
   di 0,101 min/passata. **Non e' un dilemma.**

5. **In tutti e due i casi la cella di bordo resta LEGGIBILE come MISURA**:
   conta per il cancello del costo (R125-G0), conta per il DD (R125-G1/G2),
   e conta **come vicina** di una cella interna. 👉 **Non si scarta: non si
   sceglie.** Sono due cose diverse.
6. 🔢 **Conseguenza numerica, scritta adesso e non dopo:** sull'asse
   `InpSLBufferPts` 0..3000 a passo 500 le celle **SCEGLIBILI sono CINQUE** --
   **500, 1000, 1500, 2000, 2500**. Le celle **0** e **3000** si misurano e si
   leggono, ma **non si scelgono**.
   ⚠️ E questo tocca un numero gia' scritto nel dossier: *"la cella che copre
   il caso peggiore e' la **2500**"* -- la 2500 **e' scegliibile**, quindi la
   frase regge. Se il caso peggiore avesse chiesto **3000**, per questa regola
   **non ci sarebbe stata nessuna cella da scegliere**, e l'asse sarebbe
   nato gia' troppo corto.

## 4. LE SOGLIE, CONGELATE ORA

> 📛 **I cancelli si chiamano `R125-G0..R125-G5`, col prefisso di round.**
> 🔁 **Rinominati DUE VOLTE il 10/09, prima della firma, e la seconda volta
> e' la lezione:** prima erano `C0..C5`, ma **`C1` e' gia' preso** — e' il cap sul
> rischio aperto simultaneo, **3,25%**, firmato da Claudio il 18/08
> (`report/FIRME_2026-08-18.md`), classe **190**. Li ho spostati a `G0..G5` e
> **ho collisionato di nuovo**: `G1` e' il nome di casa del **cancello dei
> gemelli / di determinismo**, presente in **51 file prova** e persino **tre
> volte dentro `R125d` di questo stesso round**. Classe **194**.
> 🔴 **La regola che ne esce: un nome di cancello nuovo si cerca nel repo
> PRIMA di adottarlo, e porta il prefisso del suo round.** Un `grep`, non la
> memoria.

| # | cancello | soglia | perche' |
|---|---|---|---|
| **R125-G0** | **COSTO** | stop stimato >= **40 x spread mediano dell'ora** | e' il cancello di casa. Chi non lo passa **non si legge nemmeno**, qualunque PF abbia |
| **R125-G1** | **RISCHIO** | **DD OOS <= 7,00%** | e' il numero gia' firmato in `R88_CRITERI.md` cancello A1. Non si ammorbidisce |
| **R125-G2** | **RISCHIO, seconda finestra** | **DD IS <= 9,00%** | il rischio si legge a qualunque n (Emendamento B). La cella viva fa 7,8885% IS |
| **R125-G3** | **MERITO** | **PF OOS >= 1,40** | idem R88. E si legge **SOLO** sull'OOS: n OOS = 119, n IS = 71 |
| **R125-G4** | **CAMPIONE** | n OOS >= 95 e n IS >= 57 | idem R88 |
| **R125-G5** | **ALTOPIANO** | par.3 **e procedura 4-bis (P1..P8)** soddisfatti | senza questo, nessuna cella e' leggibile |

> ### RIGA CHE NON SI NEGOZIA
> **Il MERITO si legge sull'OOS (n=119) e NON sull'IS (n=71).**
> Non e' un ammorbidimento: e' l'Emendamento A del 16/08 applicato alla
> lettera. E per essere onesti fino in fondo: **il PF IS si scrive lo stesso,
> accanto a ogni numero**, con l'n a fianco. Chi legge decide se gli basta.
> Se una cella passa R125-G0..R125-G5 con PF IS sotto 1,00, si dichiara
> **"passa i cancelli, ma la finestra vecchia non la conferma"** -- non
> "promossa".

> ### 🆕 E LA RIGA CHE IL CANCELLO HA AGGIUNTO IL 10/09 -- classe 205
> 🔴 **`R125-G3` NON PROMUOVE: FILTRA.** L'Emendamento A dice che sotto **150**
> operazioni il MERITO **e' sospeso** -- e **n OOS = 119 e' sotto**. Quindi
> passare R125-G3 non e' *"merito dimostrato"*: e' **"merito non escluso"**.
> Leggerlo sull'OOS invece che sull'IS sceglie **la finestra meno peggio**, non
> rende il numero sufficiente. E il referto `ORB_OPPRANGE_RIAPERTURA` lo scrive
> gia' al suo punto 5 (*"il PF 1,84 non promuove, esattamente come il PF IS 1,06
> non bocciava"*): senza questa riga i due documenti si contraddicevano.
> 🔢 **E su U30USD questo round NON PUO' chiudere quel buco, ed e' MISURATO, non
> temuto:** `R125a` dichiara da solo *"n: INVARIANTE lungo tutto l'asse, IS 71,
> OOS 119, in tutte e 7 le celle"* -- il buffer sposta lo **stop**, non decide
> **se si entra** -- e il muro dei tick BCM (**2024.09.26**) non si sposta.
> 👉 **Quindi `R125a` e `R125b` possono dire se l'altopiano esiste e a che
> costo, ma NON possono produrre una sedia schierabile sul Dow.** La via al
> merito pieno passa da **D30EUR e NASUSD** (`R125c`/`R125e`/`R125f`, dove
> l'archivio misura n fino a **233** e **357**), **non** da un'altra griglia su
> U30USD.
> ⚠️ 🆕 **E QUEI DUE NUMERI DICONO IL CAMPIONE, NON IL MERITO** (classe 207,
> quarto giro di cancello). Il **233** e' di `r11` su D30EUR, cioe' **un'altra
> ricetta** (finestra 65' 07:00-08:05, EMA50, niente trailing / parziale /
> breakeven) che questo stesso dossier archivia **MORTA** al §1.2, con
> **PF OOS 0,940-1,022** e **DD OOS 17,5-29,7%**. Il **357** e' di `ORB` `ohlc`
> su NASUSD: **un altro EA e un altro modello** (OHLC, **non tick**), con
> **PF IS 0,945** e **PF OOS 1,248**, cioe' **sotto `R125-G3` (1,40)**.
> 👉 **Nessuno dei due e' "la sedia che aspetta li'"**: dicono che su quei
> simboli il **CAMPIONE e' RAGGIUNGIBILE**, non che il **MERITO** ci sia --
> e sono due cose diverse. 🔴 **E quanto ne porta davvero R125 lo dicono i
> suoi file prova, non l'archivio: `n` atteso 90-190 (`R125c`/`R125e`) e
> 100-220 (`R125f`) -- due bande a CAVALLO dei 150.** Quindi il merito
> **puo' restare sospeso anche li'**, e va detto prima, non dopo.
> 🛑 **E c'e' un dettaglio che li chiude del tutto, ed e' di RISCHIO, che
> si legge a QUALUNQUE n (Emendamento B):** nel censimento quelle due righe
> portano **DD OOS 19,59%** (D30EUR `r11`, con **profitto OOS mediano NEGATIVO**,
> -73,85) e **DD IS 22,85% / DD OOS 11,77%** (NASUSD `ohlc`, con **profitto IS
> negativo**, -407,21). 🔴 **Tutte e due sfondano `R125-G1` (7,00%),
> `R125-G2` (9,00%) e perfino la bocciatura secca a 9,7623%.** 👉 Quelle due
> righe si possono citare **solo** per dire *"su quei simboli il campione
> esiste"*. Per il merito e per il rischio **sono gia' bocciate**.
> 🛑 **Questo NON e' un ammorbidimento e NON e' un irrigidimento: e' scrivere
> cosa vuol dire passare un cancello.** Vale da adesso, a numeri non visti.

## 5. COSA FA SCARTARE SUBITO (bocciatura secca, senza discussione)

- **DD OOS > 9,7623%** (il DD promesso dalla sedia viva sul reale). Una
  variante che peggiora il rischio della sedia in campo non entra in nessuna
  discussione.
- **n OOS < 95** in una cella che altrimenti passerebbe: si dichiara
  **NON MISURABILE**, non "promossa".
- **stop stimato sotto 13,3 x spread** (pavimento DURO): scarto per
  aritmetica, prima di guardare qualunque altra colonna.

## 6. CHE COSA QUESTO ROUND NON PUO' DIRE, dichiarato prima

- **La geometria ATR su D1 chiusa del collega NON e' in questo round**, e non
  per pigrizia: `iATR` su **D1 NON popola nel tester Modello 4 su simbolo
  NATIVO BCM**. E' PROVATO con un discriminante a soglie sempre-vere
  (`REFERTO_CRT_2026-08-30.md`, par. "DISCRIMINANTE pin 343e139": 0 trade su
  2573 pattern). Serve prima un **fix dell'EA** (CopyRates D1 + fallback,
  mai misurato) e la **sua** validazione. Vedi il dossier, par. 6.
- **Il parziale "80% a 1,5R + coda a 3R" del collega NON e' esprimibile**
  cosi' com'e': in `InpTPMode=ORB_TP_R` il parziale e il TP dell'ordine
  cadono **sullo stesso prezzo**, e col trailing acceso il bersaglio del
  parziale **si sposta** perche' e' ricalcolato su `openP - SL_corrente`.
  Vedi il dossier, par. 5.
- **Lo spread al MINUTO** dentro 14:30-14:45 e' **[NON MISURATO]**: quello che
  abbiamo e' la mediana **dell'ora**. Direzione dell'errore nota e
  sfavorevole (in apertura si allarga).
- **Lo slippage** nella finestra: **[NON MISURATO]** sugli indici alla
  rottura. Il tester lo modella a zero.
- **Un regime solo**: 2024.09-2026.09, indici prevalentemente al rialzo. Il
  muro dei tick BCM e' **2024.09.26** e non si sposta.
