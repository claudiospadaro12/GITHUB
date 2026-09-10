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

3. 🧱 **Bordo che e' un LIMITE FISICO**: dall'altra parte non c'e' una misura
   che manca, c'e' **un valore che non esiste**. L'altopiano e' **CHIUSO** da
   quel lato e si sceglie normalmente (la cella scelta resta la piu' interna
   dell'altopiano, cioe' **non** il bordo). Nessuna penalita', e va detto:
   **non e' un buco**.
4. ✂️ **Bordo che e' la FINE DELLA GRIGLIA**: li' il vuoto e' **una misura che
   MANCA**, e la differenza morde:
   - se, **tolto il bordo**, restano almeno **tre** celle di altopiano, si
     sceglie la piu' interna **fra quelle** e si dichiara accanto al numero:
     **"asse APERTO verso l'alto: il centro vero puo' stare oltre 3000, e non
     e' misurato"**;
   - se invece l'altopiano e' fatto **solo** dal bordo e dalla sua unica
     adiacente, il verdetto e' **"L'ALTOPIANO, SE C'E', ESCE DALLA GRIGLIA"**:
     🛑 **non si sceglie niente su quell'asse**, e la risposta e' **estendere
     l'asse di almeno due gradini** in un round successivo.
   - 📌 **Estendere un asse NON viola la regola del 19/08** ("niente parametri
     diversi di un motore morto"): li' si vieta di infittire la griglia di un
     motore **gia' dichiarato senza edge**; qui si **chiude una misura che la
     griglia aveva tagliato**. E si paga con la **stessa** prova fuori campione
     del par. 4 del dossier, non con una piu' morbida.
4-bis. ⚖️ **E QUANDO 3-bis E PAR.3 DICONO COSE DIVERSE, VINCE 3-bis** (che e'
   il piu' stretto). Caso concreto: altopiano `{2000, 2500, 3000}`. Per il par.3
   la cella **2500** sarebbe accettabile (le sue due vicine stanno dentro la
   banda); per il par. 3-bis punto 4, tolto il bordo restano **due** celle, non
   tre, quindi il verdetto e' **"esce dalla griglia"** e si estende l'asse.
   🔴 **La differenza e' che il 2500 potrebbe essere il centro dell'altopiano
   oppure il fianco di una salita che la griglia ha tagliato, e i due casi
   danno lo stesso quadro di numeri.** Il costo di sbagliare (una cella
   promossa sul fianco) e' una challenge; il costo di allungare l'asse e'
   **7 celle = 14 passate = ~1,4 minuti** al ritmo misurato di 0,101
   min/passata. **Non e' un dilemma.**

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
| **R125-G5** | **ALTOPIANO** | par.3 soddisfatto | senza questo, nessuna cella e' leggibile |

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
