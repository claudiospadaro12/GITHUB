# VERIFICA DI FEDELTA (2° GIRO, SUL PDF VERO) — `ABTG_GoldenCross.mq5` contro "GOLDEN CROSS HA Strategy"

**Data:** 28/08/2026 · **Fonte normativa:** il **PDF originale** Masterclass ABTG
"GOLDEN CROSS HA Strategy", v1.0 del 01/07/2026, **12 pagine, 20 capitoli**,
letto per intero pagina per pagina in questa sessione.
**Oggetto misurato:** `mql5/Experts/ABTG_GoldenCross.mq5` — **952 righe, versione
2.00**, letto per intero riga per riga in questa sessione.
**Referto che questo aggiorna:** `VERIFICA_FEDELTA_GOLDENCROSS_PDF_2026-08-19.md`
(verdetto di allora: FEDELE 36/78 = 46%).

> **DICHIARAZIONE DI FONTE — leggila prima dei numeri.**
> Il 19/08 il referto si apriva con una riserva onesta: *"Io non ho avuto il PDF
> sotto gli occhi, ho lavorato sulla trascrizione"*. **Quella riserva oggi è
> sciolta: il PDF l'ho letto io, tutte e 12 le pagine.** Ogni citazione di regola
> porta il numero di pagina. Ogni citazione di codice porta il numero di riga
> **della v2.00**, riverificato: non ho copiato una sola riga dal vecchio
> referto senza rileggerla nel file.
>
> **Nessun `.mq5` è stato toccato.** Zero modifiche, solo misura. Le proposte
> della PARTE 6 sono proposte: opt-in, default spento, da implementare (se mai)
> una alla volta e in un altro giro.
>
> **Non ho backtest sotto mano in questa sessione.** Non affermo che nessuna
> divergenza costi o renda soldi. Dico solo cosa è coerente col documento e
> quale metrica dovrebbe muoversi.

---

# PARTE 0 — COSA CAMBIA RISPETTO AL 19/08

Due cose sono cambiate insieme, e vanno tenute separate o il numero non si legge:

### 0.1 IL CODICE È CAMBIATO — l'EA è la v2.00, non più quella misurata il 19/08

Il vecchio referto misurava **783 righe, v1.00**. Oggi il file è **952 righe,
`#property version "2.00"`** (riga 70), e il suo stesso changelog (righe 26-29)
**cita il referto del 19/08 come fonte dei difetti**. Il commit è `57a6580`
*"GoldenCross v2.00: 3 fix meccanici verificati contro il PDF + 2 input opt-in"*.

**Tre delle cinque divergenze principali del 19/08 sono state chiuse:**

| divergenza del 19/08 | stato oggi | evidenza |
|---|---|---|
| ① test dell'incrocio su UNA barra sola | **CHIUSA** | `CrossInWindow()` righe 409-421: cerca l'**evento** `ef[k]<=em[k] && ef[k-1]>em[k-1]` in tutta la finestra. Chiamata a 462 (long) / 482 (short) |
| ② mancava "Prezzo > EMA9", e la distanza era sempre vera sotto la media | **CHIUSA** | riga 465 `aboveFast = (close1 > ema9)` · riga 468 `dist = MathAbs(close1 - ema9) <= ...`. Speculari a 484-485 |
| ④ i parziali in profitto azzeravano il contatore delle perdite | **CHIUSA** | `TodayStats()` righe 774-839: i deal si raggruppano per `DEAL_POSITION_ID` (802-819), le posizioni ancora vive si saltano (836), conta il **netto** della posizione (837) |
| ③ distanza d'ingresso 3× la "preferibile" del cap.9 | **APERTA** | `InpMaxDistATR = 1.5` (riga 134) contro lo 0,5 ATR di pag.7 |
| ⑤ "in trend forte mantenere" contro il TP fisso a 2R | **APERTA** | `InpTP_R = 2.0` (156) · trailing che non protegge sotto il pareggio (620) |

In più sono comparsi **due interruttori opt-in a default neutro**, esattamente
nella forma che la regola di casa chiede:
`InpMaxDistEma21ATR = 0` (riga 141, la regola del "tardivo" del cap.9) e
`InpRequireAdxRising = false` (riga 131, ADX crescente barra su barra).

### 0.2 LA FONTE ERA INCOMPLETA — la trascrizione si fermava al capitolo 14

Il vecchio dossier referenzia i capitoli 1-14. **Il PDF ha 20 capitoli.** I sei
che la trascrizione non aveva reso sono le pagine 9-12:

| cap. | titolo | contiene regole meccanizzabili NUOVE? |
|---|---|---|
| **15** | Checklist operative (pre-ingresso 16 punti, post-trade 8 punti) | **No** — è la stessa checklist del cap.5 in forma di modulo. Zero regole nuove |
| **16** | **Diario operativo** (5 categorie di dati da registrare) | **Sì, 5 voci.** È l'unico capitolo davvero nuovo, ed è tutto meccanizzabile: è logging |
| 17 | La logica operativa della strategia | No — prosa didattica, rinforza cap.12/14 |
| 18 | Sintesi finale (regola operativa long/short) | No — riepilogo, conferma cap.5/6 |
| 19 | Disclaimer didattico | No |
| **20** | **Glossario essenziale** | No, ma **dà il metro di misura**: vedi 0.3 punto E |

### 0.3 LE DIFFERENZE TROVATE COL PDF VERO (quello che la trascrizione aveva perso o storto)

Sette punti. Nessuno ribalta il verdetto, **due cambiano il conteggio**.

**A. DIFFERENZA — il cap.12 regola 16 è mezza meccanizzabile, e il 19/08 fu
scartata intera.**
La trascrizione diceva: *"trader emotivamente alterato"* → esclusa dal conteggio
come non meccanizzabile.
Il PDF (pag.8) dice: *"Il trader è emotivamente alterato **o sta cercando di
recuperare una perdita**."*
La seconda metà — il **revenge trading** — è meccanizzabile eccome, ed è
**esattamente** lo *"Stop operativo dopo 2 perdite consecutive"* del cap.14.
**Effetto sul conteggio: +1 regola misurabile, e l'EA la rispetta** (`InpStopAfterLosses=2`,
riga 168, applicata a riga 312, ora che il FIX 3 la fa funzionare davvero).

**B. DIFFERENZA — il cap.14 ha SEI bullet, la trascrizione ne aveva resi cinque.**
Il PDF (pag.9) chiude l'elenco con: *"**La size dipende dal rischio tecnico, non
dalla convinzione personale.**"* Non c'era nel vecchio blocco I (che si fermava a
9 voci).
**Effetto: +1 regola, e l'EA è FEDELE alla lettera**: `LotByRisk(risk)` (riga 538)
riceve **la distanza dello stop** come argomento e ne deriva il lotto (678-707).
La size è letteralmente una funzione del rischio tecnico.

**C. DIFFERENZA — il cap.10.1 ha una meta-regola che la trascrizione non aveva.**
Il PDF (pag.7): *"Lo stop loss deve essere definito **prima dell'ingresso** e
posizionato dove il setup perde validità tecnica. **Non deve essere collocato dove
'fa comodo' in funzione della size.**"*
Il vecchio blocco E aveva solo le 4 modalità di stop. Questa è una regola a sé,
verificabile, **e l'EA la rispetta**: in `Enter()` lo stop si calcola alle righe
516-526, **il lotto solo dopo, a riga 538**. L'ordine causale è quello giusto.
**Effetto: +1 regola FEDELE.**

**D. DIFFERENZA — "EMA50 piatta" nel PDF vero pesa QUATTRO volte, nella
trascrizione una.**
La trascrizione la rendeva solo come regola 2 del cap.12. Il PDF la ripete in
quattro punti diversi:
- pag.3, cap.2 fase 3 — *"Serve direzione chiara, **non medie piatte** o intrecciate"*;
- pag.3, cap.3.3 — *"Prezzo che attraversa continuamente EMA 50: **no trade** o massima prudenza"*;
- pag.8, cap.12 n.2 — *"EMA 50 è piatta e il prezzo la attraversa ripetutamente"*;
- pag.9, cap.13 — *"Setup C: **EMA piatte** o intrecciate → da scartare"*.

Nel codice il filtro di pendenza è riga 457: `slope50 = (ema50 >= es[InpEmaSlopeBars])`.
**Con `>=` una EMA50 perfettamente piatta passa.** Non c'è nessuna soglia minima
di pendenza. Resta 🔓 come il 19/08, ma **il PDF vero lo rende un difetto molto
più grave di quanto la trascrizione facesse sembrare**: è la regola che il
documento ripete più volte di ogni altra.

**E. DIFFERENZA — il glossario (cap.20, pag.12) consegna il metro per la regola
"stop troppo ampio", che il 19/08 era stata archiviata come non misurabile.**
*"ATR: indicatore di volatilità usato per misurare distanza, **stop eccessivi** o
ingresso tardivo."*
Il PDF dice **con quale unità** si giudica uno stop troppo ampio, e l'EA ha già
l'handle ATR (riga 215). La regola G13 resta ⛔ ASSENTE, ma **non è più
"discrezionale": è un `if` a una riga** contro un multiplo di ATR. Cambia la
diagnosi, non l'esito.
Sempre il glossario definisce **R** (*"Se rischio 100 euro, +1R significa +100 euro"*),
confermando che lo stop giornaliero −2R/−3R del cap.14 si misura in euro-di-rischio,
esattamente come il §3.5 del vecchio referto ipotizzava.

**F. DIFFERENZA (a sfavore del vecchio referto) — il cap.14 sul 2% è più morbido
di come fu trascritto.**
La trascrizione: *"**MAI** oltre 2%"*. Il PDF (pag.9, tabella): riga *"Limite
massimo — **Non superare 2%** — Da evitare salvo esperienza elevata e piano
validato."* E la riga sopra: *"Setup A qualificato — Massimo 1,5% — **Solo con
storico e disciplina consolidati**"* (la seconda condizione mancava nella
trascrizione).
Non cambia l'esito (l'EA non ha comunque nessun tetto), ma **il vecchio referto
aveva indurito il documento**. Va detto.

**G. CONFERMA — la checklist a 15 punti del cap.5 è trascritta correttamente,
punto per punto.** L'ho riverificata a pag.5 contro il vecchio blocco B: **15
punti su 15 identici**, incluso il punto 12 (*"non eccessivamente distante da
EMA 9 **o EMA 21**"*) e il punto 15 (*"almeno 1:1, preferibilmente 1:1,5 o 1:2"*).
Anche le 16 regole del cap.12 e la classificazione A/B/C del cap.13 sono rese
fedelmente. **Sul perimetro che aveva, la trascrizione di Claudio era buona.**
Piccola curiosità senza conseguenze: la checklist del **cap.15.1** (16 punti,
pag.9-10) **omette** l'item *"ADX crescente o stabile"* che il cap.5 ha al punto
10. Le due checklist del documento non coincidono al 100%.

---

# PARTE 1 — IL VERDETTO

## 1.1 I numeri (due, perché due cose sono cambiate)

### **FEDELE 44/87 = 51%**

**87 regole misurabili** estratte dal PDF vero (le due voci puramente
psicologiche — *"trader emotivamente alterato"* del cap.12 e *"sto entrando per
regola e non per impulso"* del cap.15.1 — restano escluse: non sono
meccanizzabili per definizione).

| esito | conteggio | quota |
|---|---|---|
| ✅ **FEDELE** | **44** | 51% |
| ⚠️ **DIVERGENTE** (c'è ma non fa quello che dice il PDF, o è spento) | **13** | 15% |
| 🔓 **PIÙ LARGO** (l'EA entra dove il PDF dice di non entrare) | **6** | 7% |
| 🔒 **PIÙ RIGIDO** (l'EA rinuncia a setup che il PDF ammette) | **1** | 1% |
| ⛔ **ASSENTE** | **23** | 26% |

### La scomposizione onesta: 46% → 51%, e da dove vengono i 5 punti

Per non confondere "l'EA è migliorato" con "la fonte era diversa", ecco lo stesso
conto **sul perimetro identico del 19/08 (78 voci)**, misurando la v2.00:

| passo | ✅ | su | % | cosa l'ha mosso |
|---|---|---|---|---|
| **19/08 — v1.00 sulla trascrizione** | 36 | 78 | 46% | punto di partenza |
| **+ i tre fix della v2.00** | **40** | 78 | **51%** | A2, A3, B3 (fix 1 e 2) e I7 (fix 3) passano da ⚠️/🔓 a ✅ |
| **+ le 9 voci nuove del PDF vero** | **44** | **87** | **51%** | 4 fedeli (G16b, E10, I10, K1) e 5 no |

**Il salto da 46% a 51% è tutto merito del codice, non della fonte.** Le 9 voci
che il PDF vero aggiunge si dividono 4 a 5 e lasciano la percentuale dov'era: la
trascrizione, sul suo perimetro, non aveva falsato il verdetto. **Il numero del
19/08 era giusto per il codice del 19/08.**

Tre voci sono passate da ⛔ ad ⚠️ senza spostare la fedeltà — D4, D5 e G10 (la
regola del "tardivo"): **il meccanismo ora esiste** (`InpMaxDistEma21ATR`, riga
141) **ma è spento di default**. È il comportamento corretto secondo la regola di
casa (default neutro), ma finché non lo si accende e non lo si misura, in campo
quella regola del PDF non è rispettata.

> **Avvertenza sul conteggio, obbligatoria e identica a quella del 19/08.** Il
> PDF è **ridondante per costruzione**: la checklist del cap.5 espande le 6 fasi
> del cap.2, il cap.12 le rigira al negativo, il cap.15 le ricopia in modulo e il
> cap.18 le riassume. **Un singolo difetto del codice viene contato più volte**
> (la tolleranza sul corpo HA pesa 3 volte: A4-nota, B8, G8). Il 51% è una
> **misura di copertura del documento**, non una probabilità di somiglianza
> operativa. **Il conteggio per blocchi (§1.2) è più onesto del totale.**
> Per la stessa ragione **non ho gonfiato il denominatore con il cap.15**: quel
> capitolo non contiene una sola regola che non sia già altrove, e l'ho
> dichiarato invece di contarlo.

## 1.2 Dove l'EA è fedele e dove no — per blocco

| blocco del PDF (pagine) | voci | ✅ | ⚠️ | 🔓 | 🔒 | ⛔ | fedeltà | vs 19/08 |
|---|---|---|---|---|---|---|---|---|
| **A. Sequenza a 6 fasi** (cap.2, p.3) | 6 | 5 | – | 1 | – | – | 🟢 **83%** | ▲ da 50% |
| **B. Checklist long 15 punti** (cap.5, p.5) | 15 | 12 | – | 2 | – | 1 | 🟢 **80%** | ▲ da 73% |
| **C. Scala ADX** (cap.8, p.6) | 5 | 2 | – | – | 1 | 2 | 🟡 40% | = |
| **D. Ingresso** (cap.9, p.6-7) | 6 | 2 | 2 | 1 | – | 1 | 🔴 33% | = (ma 2 ⛔ → ⚠️) |
| **E. Stop / target / gestione** (cap.10, p.7) | 10 | 5 | 2 | – | – | 3 | 🟡 50% | ▲ da 44% |
| **F. Uscite** (cap.11, p.8) | 6 | 2 | 2 | – | – | 2 | 🔴 33% | = |
| **G. Non-ingresso** (cap.12, p.8) | 16 | 8 | 3 | 2 | – | 3 | 🟡 50% | ▲ da 47% |
| **H. Classificazione A/B/C** (cap.13, p.9) | 3 | 0 | – | – | – | 3 | 🔴 **0%** | = |
| **I. Money management** (cap.14, p.9) | 10 | 5 | 1 | – | – | 4 | 🟡 50% | ▲ da 33% |
| **J. Timeframe / mercati / fasce** (cap.4, p.4) | 5 | 2 | 1 | – | – | 2 | 🟡 40% | = |
| **K. Diario operativo** (cap.16, p.10) 🆕 | 5 | 1 | 2 | – | – | 2 | 🔴 20% | **mai misurato prima** |
| **TOTALE** | **87** | **44** | **13** | **6** | **1** | **23** | **51%** | ▲ da 46% |

## 1.3 Il verdetto in quattro righe

1. **La meccanica d'ingresso ora è molto fedele** (blocchi A+B: **17 fedeli su
   21, 81%**). Le sei fasi ci sono tutte nell'ordine, il trigger è un vero
   evento di incrocio, il prezzo è dalla parte giusta della EMA9. Il pezzo che
   il 19/08 era il più rotto oggi è il più sano.
2. **Il money management è raddoppiato** (33% → 50%): non perché sia stato
   aggiunto qualcosa di grosso, ma perché **lo stop dopo 2 perdite ora funziona
   davvero** (FIX 3) e perché il PDF vero ha rivelato una regola in più che l'EA
   già rispettava (*la size dal rischio tecnico*). **Restano fuori le quattro
   regole prop più facili da codificare del documento** (§3).
3. **Il contesto resta cieco, esattamente come il 19/08**: livelli S/R 0 su 5,
   classificazione A/B/C 0 su 3, fasce orarie 0 su 2. Su questo fronte in nove
   giorni non si è mosso niente, ed è dichiarato: il changelog (righe 63-65) dice
   di aver lasciato fuori di proposito il tetto di famiglia e lo stop −2R/−3R
   perché *"vanno nel Guardian"*. **La decisione è giusta, ma nel Guardian non
   sono ancora stati messi** (§3.0).
4. **Il diario operativo del cap.16 — mai misurato prima — è il blocco peggiore
   dopo l'A/B/C** (1 su 5). Ed è l'unico che si chiude **senza toccare un solo
   trade**: è tutto logging.

## 1.4 LE CINQUE DIVERGENZE PIÙ IMPORTANTI, OGGI

Le tre del 19/08 che erano bug sono chiuse. Questa è la classifica nuova.

### ① La distanza d'ingresso è ancora 3× quella "preferibile" — 🔓

| PDF cap.9.1 (pag.7) | EA v2.00 |
|---|---|
| *"Ingresso **preferibile entro 0,5 ATR** dalla EMA 9"* | `InpMaxDistATR = 1.5` (riga 134), usato a 468 |
| *"Ingresso **accettabile entro 1 ATR** dalla EMA 21"* | `InpMaxDistEma21ATR = 0` = **spento** (riga 141, usato a 470) |
| *"**Oltre 1 ATR** dalla EMA 21 il segnale è considerato **tardivo**"* | stessa cosa: il meccanismo c'è, è spento |

Il **bug** del 19/08 è sparito (ora la distanza è in modulo, riga 468: sotto la
EMA9 non passa più tutto). Ma la **soglia** è rimasta a 1,5 ATR, cioè **tre volte
la fascia "preferibile"** e ben dentro quella che il PDF chiama tardiva. È la
divergenza che sul piano statistico mi aspetto sposti di più il payoff medio
(ingressi più estesi = stop più lontano = R peggiore), **ma non ho backtest a
confronto e non lo affermo come fatto**.

**Il bello è che qui non serve scrivere codice**: `InpMaxDistATR=0.5` e
`InpMaxDistEma21ATR=1.0` sono **due valori da manuale, presi dal documento**, e
l'infrastruttura per misurarli è già tutta lì. È il test più economico
dell'intero referto.

### ② La EMA50 piatta passa il filtro, e il PDF lo vieta quattro volte — 🔓

```
riga 457:  bool slope50 = ema50 >= es[InpEmaSlopeBars];   // "non ribassista"
```

`>=` significa che **una EMA50 orizzontale è "non ribassista"** e supera la fase
1. Non esiste nessuna soglia minima di pendenza. Il PDF chiede l'opposto in
quattro punti (pag.3 fase 3, pag.3 cap.3.3, pag.8 regola 2, pag.9 Setup C) —
vedi §0.3-D. **La trascrizione del 19/08 lo faceva vedere una volta sola: col
PDF vero è la regola più ripetuta del documento.**

Nota tecnica che aggrava: l'EA **non ha nessun altro filtro anti-congestione
acceso**. Le bande di Bollinger in espansione (`BBExpanding()`, righe 271-284,
chiamata a 450) sarebbero la misura giusta, ma `InpUseBBExpand = false` (riga
116). Il documento vieta l'incrocio dentro una congestione (cap.12 n.3): in campo
oggi **nessuno lo impedisce**.

### ③ "In trend forte mantenere" contro il TP fisso a 2R, e il trailing che non protegge sotto il pareggio — ⚠️

Cap.10.3 (pag.7): *"In trend forte **mantenere** finché Heiken Ashi, ADX e medie
restano coerenti."* L'EA mette un TP fisso a `InpTP_R = 2.0` (riga 156, applicato
a 532) che chiude **comunque**. Il PDF tratta 1:2 come **ideale raggiunto**, non
come tetto.

E il presidio dinamico ha un buco preciso:

```
riga 620:  if(isLong && newSL>sl && newSL>openP) gTrade.PositionModify(...)
riga 621:  if(!isLong && (newSL<sl||sl==0) && newSL<openP) gTrade.PositionModify(...)
```

`newSL>openP` significa che **finché non si è oltre il pareggio, la EMA21 non
protegge niente**. Un trade che va male subito resta appeso allo stop swing
iniziale, mentre il cap.11 (pag.8) prescrive l'uscita alla **chiusura sotto la
EMA21** — che è una regola che vale *soprattutto* quando il trade sta andando
male. In più il trailing è uno **stop order sul livello EMA21**: scatta sul
**tocco intrabar**, non sulla **chiusura**, che è ciò che il PDF chiede.
E `IsClosedBarExit()` (643-659) legge **solo** EMA9/EMA21 e il colore HA:
**l'ADX in gestione non viene mai riletto**, quindi il *"calo marcato di ADX"*
del cap.11 non esiste.

### ④ Le due regole "non inseguire" del PDF sono entrambe assenti — ⛔

Il documento ha due tetti superiori, e l'EA non ne ha nessuno:

| PDF | dove | EA |
|---|---|---|
| *"ADX > 35/40 — trend molto forte — **attenzione a non inseguire un movimento già esteso**"* | cap.8, pag.6 | ⛔ nessun tetto sull'ADX. Si entra volentieri a ADX 45 |
| *"Lo **stop tecnico è troppo ampio**"* → non entrare | cap.12 n.13, pag.8 · ribadito cap.17 pag.11 | ⛔ nessun tetto sulla distanza dello stop |

Sul secondo, un chiarimento che vale: con `InpSLMode = GC_SL_SWING` (riga 151) e
`InpSwingLookback = 10` (152), un minimo lontano produce uno stop enorme;
`LotByRisk` (678-707) riduce il lotto, **quindi il rischio in euro resta 1%** — ma
il PDF dice di **non entrare affatto**. È una regola di **qualità del setup**, e
il sizing non la sostituisce: uno stop enorme è un R enorme, cioè un target
irrealistico a parità di R multiplo.
**Novità del PDF vero (§0.3-E): il glossario dice che l'unità è l'ATR.** Con
l'handle ATR già in casa (riga 215), questa è una riga di codice, non un
concetto mancante.

### ⑤ Nessun filtro orario, in nessuna forma — ⛔

Cap.4 (pag.4) dedica **una tabella intera** alle fasce operative, e il cap.12 n.15
vieta il mercato privo di liquidità. Nel file **non esiste nessun input orario**:
gli unici riferimenti al tempo sono `InpFridayCloseHour` (riga 182, e
`InpFridayClose=false` a 181) e `InpNewsShiftMinutes` (176). L'unico surrogato di
liquidità è `InpMaxSpread`, **default 0 = disattivato** (riga 184, usato a 307 via
`SpreadOK()` 718-722).

Per la flotta questo conta in concreto: le sedie GoldenCross girano su **XAUUSD,
USDCHF, USDCAD, NZDUSD**, e la riga "Forex" del cap.4 dice *"sessione europea,
sovrapposizione Europa/USA e prime ore americane"*. Oggi l'EA entra anche alle
02:00 di notte sull'asiatica, dove il PDF non lo manderebbe mai.
**Resta, come il 19/08, il buco più facile da chiudere dell'intero referto**:
"sessione" è un numero, non un giudizio. Attenzione alla regola di casa sul fuso
BCM (ora italiana − 1 = ora server).

---

# PARTE 2 — LA TABELLA DI FEDELTÀ, REGOLA PER REGOLA

Legenda: ✅ FEDELE · ⚠️ DIVERGENTE · 🔓 PIÙ LARGO · 🔒 PIÙ RIGIDO · ⛔ ASSENTE
Colonna **19/08** = esito del referto precedente, quando diverso.

## 2.1 Blocco A — La sequenza a 6 fasi (cap.2, pag.3)

| # | regola del PDF | esito | 19/08 | riga / evidenza |
|---|---|---|---|---|
| A1 | **Contesto** — *"Sopra EMA 50 si cercano solo long; sotto EMA 50 solo short"* | ✅ | ✅ | 456 `close1 > ema50` · 477 `close1 < ema50` · più la pendenza 457/478 |
| A2 | **Trigger** — *"EMA 9 incrocia EMA 21? L'incrocio attiva l'osservazione del setup"* | ✅ | ⚠️ | **FIX 1**: `CrossInWindow()` 409-421 cerca l'evento in tutta la finestra; chiamata 462/482 + `crossNow` 460/481 (deve essere ancora sopra **ora**) |
| A3 | **Allineamento** — *"Le medie si ordinano e si inclinano? Serve direzione chiara, non medie piatte o intrecciate"* | 🔓 | 🔓 | **FIX 2** ha aggiunto il prezzo (465 `aboveFast`), l'ordinamento c'è (459) e le pendenze pure (457-458). **Resta 🔓 per un motivo solo: "non medie piatte"** — con `>=` la piatta passa (§1.4 ②) |
| A4 | **Momentum** — *"Servono almeno tre candele coerenti, piene e senza stoppino contrario"* | ✅ | ✅ | `HAConfirms()` 358-377: direzione (368), ombra contraria (369-370), numero (360+365). Sul "piene" vedi B8 |
| A5 | **Forza** — *"ADX > 20 operativo, ADX > 25 preferibile"* | ✅ | ✅ | 444 `adx[0] >= InpAdxMin` (=20, riga 124) · 445 crescente · 463 DI |
| A6 | **Tradeability** — *"Si entra solo se lo stop è tecnico e il target ha spazio"* | 🔓 | 🔓 | stop tecnico ✅ (530 salta se troppo vicino) · **"il target ha spazio" ⛔** · e il controllo R:R a 536 `if(InpTP_R < InpMinRR)` è **tautologico**: confronta due input fra loro, non guarda mai il trade |

## 2.2 Blocco B — La checklist long a 15 punti (cap.5, pag.5)

Verificata verbatim contro il PDF. Lo **short (cap.6, pag.5) è speculare punto
per punto** e l'ho riletto nel codice alle righe 476-490: **nessuna asimmetria
nascosta**, incluso il caso `slPrec==0` nel breakeven short (riga 602).

| # | punto del PDF | esito | 19/08 | riga / nota |
|---|---|---|---|---|
| B1 | *"Il prezzo è sopra la EMA 50"* | ✅ | ✅ | 456 |
| B2 | *"La EMA 50 è inclinata verso l'alto o almeno non ribassista"* | ✅ | ✅ | 457. Alla lettera è fedele; è sul *"non medie piatte"* del cap.2 che cede (A3) |
| B3 | *"EMA 9 incrocia sopra EMA 21"* | ✅ | ⚠️ | 409-421 + 462. **Nota:** `CrossInWindow` calcola anche l'**età** dell'incrocio e la restituisce in `eta`, ma il valore **viene buttato** (dichiarato a 452, mai letto dopo 462/482). Diagnostica gratis non usata |
| B4 | *"EMA 9 ed EMA 21 sono inclinate verso l'alto"* | ✅ | ✅ | 458 |
| B5 | *"Le medie sono ordinate o in chiaro processo di allineamento"* | ✅ | ✅ | 459 (disattivabile con `InpRequireAlignment=false`, riga 106) |
| B6 | *"Sono presenti almeno tre candele Heiken Ashi rialziste consecutive"* | ✅ | ✅ | `HACountEffettivo()` 255-260, `InpHACount=3` (110). ⚠️ `InpHAAutoCount` (111, **default false**) su H1/H4 ne chiederebbe **2**: è la "regola Lavorenti", **non sta nel PDF**. Il codice stesso lo dichiara (251-253) |
| B7 | *"Le Heiken Ashi non presentano stoppino inferiore significativo"* | ✅ | ✅ | 369-370, `InpHAWickRatio=0.30` (112). Lettura dell'ombra HA **corretta**: long `hO-hL`, short `hH-hO`. "Significativo" è vago nel PDF: 0,30 è un'operazionalizzazione ragionevole |
| B8 | *"Il corpo delle Heiken Ashi è **stabile o crescente**"* | 🔓 | 🔓 | 375 `bodyRecent < InpHABodyFactor*bodyOldest` → scarta. Con **0.60** (113) **ammette un corpo che cala del 40%**: il PDF non ammette riduzione. **Il valore fedele è 1.0, ed è già un input.** 🆕 *In più, difetto non visto il 19/08:* il confronto è **solo primo contro ultimo** (371-372) — con 3 candele **la candela di mezzo non è vincolata**, quindi una sequenza grande-minuscola-grande passa |
| B9 | *"ADX è superiore a 20, preferibilmente superiore a 25"* | ✅ | ✅ | 124 `InpAdxMin=20.0`. Il "preferibile 25" non esiste come grado → C4 |
| B10 | *"ADX è crescente o almeno stabile"* | ✅ | ✅ | 445 `adx[0] >= adx[2]` (barra 1 contro barra 3). Dal 19/08 c'è anche il più stretto `InpRequireAdxRising` (131, **default off**, applicato a 447 con tolleranza `GC_ADX_TOL 0.5`, riga 193) |
| B11 | *"DI+ è superiore a DI−"* | ✅ | ✅ | 463 / 483 |
| B12 | *"Il prezzo non è eccessivamente distante da EMA 9 **o EMA 21**"* | 🔓 | 🔓 | 468 (EMA9, ora in modulo — il bug è chiuso) e 470 (EMA21, **spento**). Resta 🔓 sulla soglia: 1,5 ATR contro 0,5. §1.4 ① |
| B13 | *"C'è spazio tecnico fino alla prima resistenza utile"* | ⛔ | ⛔ | nessun concetto di S/R in tutto il file |
| B14 | *"Lo stop loss è posizionabile in modo tecnico"* | ✅ | ✅ | 516-530: swing su 10 barre (518-522) o ATR (525), `SYMBOL_TRADE_STOPS_LEVEL` rispettato (529) e **salta l'ingresso se lo stop è troppo vicino** (530) |
| B15 | *"Il rapporto rischio/rendimento è almeno 1:1, preferibilmente 1:1,5 o 1:2"* | ✅ | ✅ | 532, `InpTP_R=2.0` (156) = **l'ideale del PDF**. Fedele nel risultato, tautologico nel controllo (536) |

## 2.3 Blocco C — La scala dell'ADX (cap.8, pag.6)

| # | regola del PDF | esito | 19/08 | nota |
|---|---|---|---|---|
| C1 | *"< 15 — mercato debole o laterale — **No trade**"* | ✅ | ✅ | rispettata per eccesso (minimo 20) |
| C2 | *"15-20 — forza incerta — ingresso solo con setup molto pulito, ma **preferibile attendere**"* | 🔒 | 🔒 | col default 20 la fascia è esclusa in blocco: l'EA rinuncia a setup che il PDF ammetterebbe. Coerente con "preferibile attendere". **⚠️ `ABTG_GoldenCross_Ottimizzato.mq5` ha `InpAdxMin=15.0`** (riga 103 di quel file): entra in quella fascia **senza nessuna conferma aggiuntiva** → lì l'esito è ⚠️ DIVERGENTE. Vedi §5.6 |
| C3 | *"> 20 — trend operativo — setup valutabile"* | ✅ | ✅ | 444 |
| C4 | *"> 25 — trend forte — **condizione preferibile**"* | ⛔ | ⛔ | nessuna distinzione di grado (ricade nel blocco H) |
| C5 | *"> 35/40 — trend molto forte — **attenzione a non inseguire un movimento già esteso**"* | ⛔ | ⛔ | **nessun tetto superiore.** §1.4 ④ |

## 2.4 Blocco D — Le modalità di ingresso (cap.9, pag.6-7)

| # | regola del PDF | esito | 19/08 | nota |
|---|---|---|---|---|
| D1 | *"**Ingresso diretto**: alla chiusura della terza Heiken Ashi valida, se il prezzo è ancora vicino a EMA 9/21"* | ✅ | ✅ | `GC_MARKET` default (144) + decisione solo a barra chiusa (303 `IsNewBar()`, 322-327) |
| D2 | *"**Ingresso su pullback**: dopo setup valido, attendendo ritorno verso EMA 9 o EMA 21"* | ✅ | ✅ | `GC_PULLBACK` + `InpPullbackRef` (144-145), LIMIT a 553-556. 🆕 **Merito che il 19/08 non aveva accreditato:** la scadenza a 3 barre (146, 553) implementa alla lettera la *"Regola ABTG"* di pag.7 — *"**se il pullback non arriva, il trade non si forza**"* |
| D3 | *"Ingresso **preferibile entro 0,5 ATR** dalla EMA 9"* | 🔓 | 🔓 | 134 `InpMaxDistATR=1.5` → 3× più largo. §1.4 ① |
| D4 | *"Ingresso **accettabile entro 1 ATR** dalla EMA 21"* | ⚠️ | ⛔ | il meccanismo **ora esiste** (141, 470/486) ma `InpMaxDistEma21ATR = 0` = **spento**. Valore da manuale: **1.0** |
| D5 | *"**Oltre 1 ATR** dalla EMA 21 il segnale è considerato **tardivo**"* | ⚠️ | ⛔ | stesso input, stessa situazione |
| D6 | *"Se la **terza Heiken Ashi è molto ampia**, valutare attesa di pullback"* | ⛔ | ⛔ | `InpEntryMode` è un input **fisso** (144, letto a 544): la modalità **non commuta mai** in base all'ampiezza della candela o alla distanza dalle medie. È il cuore della "Regola ABTG" di pag.7 e non c'è |

## 2.5 Blocco E — Stop loss, target e gestione dinamica (cap.10, pag.7)

| # | regola del PDF | esito | 19/08 | nota |
|---|---|---|---|---|
| E1 | SL *"sotto ultimo minimo significativo"* | ✅ | ✅ | 518-522 `iLowest(...,InpSwingLookback,1)` + buffer `EffBuffer()` (672-676) |
| E2 | SL *"sotto EMA 21"* | ⛔ | ⛔ | non esiste come stop **iniziale**: `ENUM_GC_SL` (94) ha solo SWING e ATR. La EMA21 c'è solo come **trailing** (160, 631-634) |
| E3 | SL *"sotto candela di conferma"* | ⛔ | ⛔ | — |
| E4 | SL *"con distanza tecnica ATR"* | ✅ | ✅ | 525, `InpAtrSLmult=1.5` (154) |
| E5 | TP: *"minimo 1:1, preferibile 1:1,5, **ideale 1:2**"* | ✅ | ✅ | `InpTP_R=2.0` (156) = l'ideale |
| E6 | *"Target tecnico: supporti, resistenze, massimi/minimi relativi, pivot, aree di volume, estensioni"* | ⛔ | ⛔ | il TP è **solo** un multiplo di R (532) |
| E7 | *"A 1R valutare stop a pareggio, parziale o protezione dietro EMA 21"* | ✅ | ✅ | **tutte e tre**: parziale al 50% a 1R (584-596, input 157-158), breakeven (597-603), trailing EMA21 di default (160). ⭐ Il pezzo più fedele dell'EA, **correzione del lotto minimo inclusa** (591-596: il pareggio si fa anche se il parziale non parte) |
| E8 | *"In trend forte **mantenere** finché Heiken Ashi, ADX e medie restano coerenti"* | ⚠️ | ⚠️ | TP fisso a 2R che chiude comunque; nessun controllo ADX in gestione. §1.4 ③ |
| E9 | *"In perdita di momentum valutare uscita parziale o totale"* | ⚠️ | ⚠️ | `InpExitOnHAflip` esiste (163) ma è **default false**; il calo di ADX non è mai letto in `ManageOpen()` (565-624) né in `IsClosedBarExit()` (643-659) |
| **E10** 🆕 | *"Lo stop **deve essere definito prima dell'ingresso**... **non deve essere collocato dove 'fa comodo' in funzione della size**"* | ✅ | **mai misurata** | **Fedele alla lettera.** In `Enter()`: stop calcolato a 516-526, rischio a 528, **e solo dopo** `LotByRisk(risk)` a 538. La size è funzione dello stop, mai il contrario. Vedi §0.3-C |

## 2.6 Blocco F — Le regole di uscita (cap.11, pag.8)

| # | regola long del PDF | esito | 19/08 | nota |
|---|---|---|---|---|
| F1 | *"TP raggiunto"* | ✅ | ✅ | TP sull'ordine (532, 546) |
| F2 | *"**chiusura sotto EMA 21**"* | ⚠️ | ⚠️ | non esiste come uscita. Approssimata dal **trailing** (631-634), che però: (a) è uno stop sul livello → scatta sul **tocco intrabar**, non sulla chiusura; (b) riga 620 `newSL>openP` → **non protegge finché non si è in utile**. §1.4 ③ |
| F3 | *"EMA 9 scende sotto EMA 21"* | ✅ | ✅ | 647-651, `InpExitOnCross=true` di default (162) |
| F4 | *"cambio colore Heiken Ashi"* | ⚠️ | ⚠️ | 652-657 + `HAColor()` (382-389), ma **default false** (163) |
| F5 | *"resistenza importante"* | ⛔ | ⛔ | — |
| F6 | *"Valutare anche **calo marcato di ADX** o forte stoppino superiore"* | ⛔ | ⛔ | `IsClosedBarExit()` (643-659) legge **solo** EMA9/EMA21 e il colore HA. ADX e stoppini non sono mai riletti in gestione |

> 🆕 **"Regola di protezione" (pag.8), che la trascrizione non aveva reso:**
> *"Quando il mercato smette di mostrare continuità, la posizione non deve essere
> difesa per orgoglio. La gestione deve seguire il setup, non l'aspettativa del
> trader."* Come la regola 16 del cap.12, **un EA la rispetta per costruzione**:
> non ha orgoglio. Non conteggiata (meta-regola), ma vale la pena scriverlo.

## 2.7 Blocco G — Le 16 regole di NON-INGRESSO (cap.12, pag.8)

| # | *"non entrare se..."* | esito | 19/08 | nota |
|---|---|---|---|---|
| G1 | *"EMA 9, EMA 21 ed EMA 50 sono **intrecciate**"* | ✅ | ✅ | `ordered` (459) + pendenze (457-458) |
| G2 | *"EMA 50 è **piatta** e il prezzo la attraversa ripetutamente"* | 🔓 | 🔓 | 457 `>=`: **la piatta passa**. Nessuna soglia minima di pendenza, nessun conteggio degli attraversamenti. §1.4 ② — **e col PDF vero questa regola pesa 4 volte, non 1** (§0.3-D) |
| G3 | *"L'incrocio avviene dentro una **congestione**"* | ⚠️ | ⛔ | il surrogato **esiste**: `BBExpanding()` (271-284), input 116-120, chiamato a 450. Ma `InpUseBBExpand=false`. **Riclassificata da ⛔ a ⚠️** per coerenza interna: il 19/08 lo stesso stato ("presente ma spento") era ⛔ qui e ⚠️ per le news (G14). Non può essere entrambi |
| G4 | *"ADX è sotto 15"* | ✅ | ✅ | per eccesso (444, minimo 20) |
| G5 | *"ADX è tra 15 e 20 senza forte conferma tecnica"* | ✅ | ✅ | per esclusione della fascia intera |
| G6 | *"DI+ e DI− non confermano la direzione"* | ✅ | ✅ | 463 / 483, `InpRequireDI=true` (126) |
| G7 | *"Le Heiken Ashi alternano colore"* | ✅ | ✅ | 368 `if(body<=0) return(false)` su tutte e N |
| G8 | *"Le tre Heiken Ashi hanno **corpo in riduzione**"* | 🔓 | 🔓 | 375, tollera −40%, e non guarda la candela di mezzo. Doppione di B8 |
| G9 | *"Compare **stoppino contrario significativo**"* | ✅ | ✅ | 369-370 |
| G10 | *"Il prezzo è troppo distante da **EMA 21**"* | ⚠️ | ⛔ | ora misurabile (141, 470/486) ma **spento** |
| G11 | *"Il movimento è già arrivato su supporto o resistenza"* | ⛔ | ⛔ | — |
| G12 | *"Il rapporto rischio/rendimento è inferiore a 1:1"* | ✅ | ✅ | per costruzione (TP = 2R, 532) + il controllo 536 |
| G13 | *"Lo **stop tecnico è troppo ampio**"* | ⛔ | ⛔ | 🚨 nessun tetto sulla distanza dello stop. §1.4 ④. 🆕 **Il glossario del PDF (pag.12) dice che si misura in ATR** — quindi è un `if`, non un concetto mancante (§0.3-E) |
| G14 | *"Sono imminenti **news ad alto impatto**"* | ⚠️ | ⚠️ | filtro completo e ben fatto (844-888, chiamato a 306) ma `InpUseNewsFilter=false` (171) e richiede un CSV in `MQL5/Files` (il codice lo dichiara a 848: *"file news non trovato: filtro news di fatto spento"*) |
| G15 | *"Il mercato è **privo di liquidità**"* | ⛔ | ⛔ | 🚨 nessun filtro orario/sessione in tutto il file. Unico surrogato `InpMaxSpread`, **default 0 = spento** (184, 718-722). §1.4 ⑤ |
| **G16b** 🆕 | *"...o **sta cercando di recuperare una perdita**"* | ✅ | **esclusa dal conteggio** | `InpStopAfterLosses=2` (168) applicato a 312, **e ora funziona davvero** grazie al FIX 3 (774-839). Vedi §0.3-A |
| G16a | *"Il trader è emotivamente alterato..."* | — | — | non meccanizzabile, **escluso dal conteggio** |

## 2.8 Blocco H — La classificazione del setup (cap.13, pag.9)

| # | regola del PDF | esito | 19/08 | nota |
|---|---|---|---|---|
| H1 | **Setup A** — *"EMA ordinate, trend chiaro, tre HA forti, ADX > 25, DI coerenti, spazio tecnico e R:R almeno 1:1,5"* → *"Setup preferibile"* | ⛔ | ⛔ | il concetto di "qualità del setup" **non esiste nel codice**: `Signal()` (426-492) restituisce +1 / −1 / 0. È booleano |
| H2 | **Setup B** — *"Condizioni principali rispettate, ADX > 20, R:R almeno 1:1, qualche elemento non perfetto ma nessuna invalidazione forte"* → *"Tradabile con prudenza"* | ⛔ | ⛔ | — |
| H3 | **Setup C** — *"EMA piatte o intrecciate, ADX debole, HA poco convincenti, prezzo lontano dalle medie o target vicino"* → *"Da scartare"* | ⛔ | ⛔ | *parzialmente* ottenuto per effetto collaterale (i filtri obbligatori scartano i setup deboli), **ma non è la regola**: il PDF chiede una graduazione, non una soglia. E le tre caratteristiche del Setup C sono proprio quelle su cui l'EA è 🔓: EMA piatte (G2), prezzo lontano (D3), target vicino (E6) |

> 🔑 **Perché questo blocco pesa più di quanto il suo 0% suggerisca — e col PDF
> vero pesa ancora di più.** La classificazione è **agganciata ad altre tre parti
> del documento**: il cap.14 lega il rischio alla classe (*"Setup A qualificato →
> massimo 1,5%"*), il cap.15.2 punto 7 chiede nella revisione *"Il trade era Setup
> A, B o C?"*, e il cap.16 (Diario) elenca *"classe setup"* fra i dati **da
> registrare obbligatoriamente**. **La trascrizione mostrava solo il primo di
> questi tre agganci.** Senza A/B/C, tre regole del PDF diventano impossibili
> insieme.

## 2.9 Blocco I — Money management (cap.14, pag.9) → dettaglio nella PARTE 3

| # | regola del PDF | esito | 19/08 | dove |
|---|---|---|---|---|
| I1 | *"Test / Demo — **0,5% per trade** — verificare esecuzione e disciplina"* | ⚠️ | ⚠️ | `InpRiskPercent=1.0` di default (166) e **1.0 anche nei tre preset forward** (`ABTG_GoldenCross_FW_{NZDUSD,USDCAD,USDCHF}_H4.set`), **che girano su conto demo** |
| I2 | *"Operatività ordinaria — **1% per trade**"* | ✅ | ✅ | default 1.0 (166) |
| I3 | *"Setup A qualificato — massimo **1,5%** — solo con storico e disciplina consolidati"* | ⛔ | ⛔ | manca la classificazione (H1). 🆕 il PDF vero aggiunge la seconda condizione (§0.3-F) |
| I4 | *"Limite massimo — **non superare 2%** — da evitare salvo esperienza elevata e piano validato"* | ⛔ | ⛔ | nessun cap hard: `InpRiskPercent=8.0` viene accettato in `OnInit()` (205-230) senza un warning. 🆕 formulazione reale un filo più morbida del "MAI oltre 2%" trascritto (§0.3-F) |
| I5 | *"Massimo **2 trade al giorno sullo stesso strumento**"* | ✅ | ✅ | `InpMaxTradesPerDay=2` (167) applicato a 311; `TodayStats` conta i `DEAL_ENTRY_IN` filtrati per `DEAL_SYMBOL==_Symbol` e `DEAL_MAGIC==InpMagic` (796-799) |
| I6 | *"Massimo **3 trade complessivi al giorno**"* | ⛔ | ⛔ | ogni istanza conta solo se stessa. §3.3 |
| I7 | *"**Stop operativo dopo 2 perdite consecutive**"* | ✅ | ⚠️ | **FIX 3**: 774-839. Deal raggruppati per `DEAL_POSITION_ID` (802-819), ordinati per ora di chiusura (823-831), posizioni ancora vive saltate (836), conta il **netto** (837). Il difetto ④ del 19/08 è chiuso |
| I8 | *"Stop giornaliero consigliato a **−2R o −3R**"* | ⛔ | ⛔ | non nell'EA; surrogato **più largo** nel Guardian. §3.5 |
| I9 | *"**Non aumentare la size dopo una perdita**"* | ✅ | ✅ | `LotByRisk` (678-707) è sempre `BALANCE × %`: nessuna martingala, nessuna memoria dell'esito precedente |
| **I10** 🆕 | *"**La size dipende dal rischio tecnico, non dalla convinzione personale**"* | ✅ | **mai misurata** | 538 `LotByRisk(risk)` dove `risk` è la distanza dello stop (528). Fedele alla lettera. Vedi §0.3-B |

## 2.10 Blocco J — Timeframe, mercati e sessioni (cap.4, pag.4)

| # | regola del PDF | esito | 19/08 | nota |
|---|---|---|---|---|
| J1 | *"M5/M15 intraday veloce · M15/M30 ordinaria · **H1/H4 swing, meno segnali ma più puliti**"* | ✅ | ✅ | `InpTimeframe=PERIOD_H1` di default (101); i tre preset forward girano su **H4** (`InpTimeframe=16388`). Entrambi dentro il perimetro |
| J2 | *"DAX, Nasdaq, S&P 500, Dow Jones, principali cambi Forex, oro, petrolio e indici maggiori"* | ✅ | ✅ | l'EA è agnostico; in flotta gira su XAUUSD, USDCHF, USDCAD, NZDUSD |
| J3 | fasce operative (apertura europea · pre-market e apertura USA · sovrapposizione EU/US) | ⛔ | ⛔ | **nessun input orario in tutto il file.** §1.4 ⑤ |
| J4 | *"Fasce da evitare: mercato lento, fine sessione, pre-news ad alto impatto, congestioni strette"* | ⛔ | ⛔ | tre surrogati, **tutti e tre spenti di default**: `InpFridayClose=false` (181, e copre solo il venerdì), `InpUseNewsFilter=false` (171), `InpUseBBExpand=false` (116) |
| **J5** 🆕 | *"Sono da evitare strumenti con **spread elevato, bassa liquidità o comportamento erratico**"* | ⚠️ | **mai misurata** | `InpMaxSpread` esiste (184, `SpreadOK()` 718-722) ma **default 0 = nessun limite**. Della liquidità e dell'erraticità non c'è nessuna misura |

## 2.11 Blocco K — Il diario operativo (cap.16, pag.10) 🆕 MAI MISURATO PRIMA

Capitolo che la trascrizione non aveva reso. È **interamente meccanizzabile**:
sono dati da scrivere, non giudizi da dare. L'EA ha già `Log()` (riga 202) e
`InpVerbose=true` di default (185).

| # | *"dati da registrare"* | esito | riga / cosa manca |
|---|---|---|---|
| K1 | **Identificazione**: *"data, strumento, timeframe, direzione, orario di ingresso"* | ✅ | 548-549 logga la direzione; data/ora/simbolo li mette il terminale su ogni riga; il timeframe è nel log d'avvio (226-228) |
| K2 | **Setup**: *"EMA 50, incrocio EMA 9/21, qualità Heiken Ashi, ADX, DI+/DI−"* | ⛔ | **nessun valore d'indicatore viene mai loggato all'ingresso.** Beffa: `Signal()` ha in mano tutti i numeri (441-447) e `CrossInWindow` calcola perfino l'**età dell'incrocio** in `eta`... **che viene buttata** (452, 462, 482) |
| K3 | **Rischio**: *"prezzo ingresso, stop, target, size, rischio %, R:R"* | ⚠️ | 548-549 logga entry/SL/TP/lotto (4 su 6). Rischio % e R:R non compaiono mai nella riga del trade (sono costanti d'input, ma il diario li vuole per trade) |
| K4 | **Gestione**: *"parziali, stop a pareggio, trailing, motivazione uscita"* | ⚠️ | parziale e pareggio sì (604-606, e distingue anche il caso "parziale impossibile al lotto minimo"); **il trailing non logga mai** (620-621); l'uscita logga *"uscita da segnale (EMA/HA)"* (611) **senza dire quale delle due** |
| K5 | **Revisione**: *"risultato in R, errore, nota psicologica, classe setup"* | ⛔ | niente. Il **risultato in R** e la **classe setup** sono i due dati che il PDF usa per la revisione, e l'EA non produce né l'uno né l'altro |

> ⭐ **Perché questo blocco merita attenzione benché valga solo 5 voci:** è
> **l'unico dell'intero referto che si può chiudere senza cambiare un solo
> trade.** Loggare `eta`, ADX, DI, la classe A/B/C e il risultato in R non
> muove nessun ingresso e nessuna uscita: produce **i dati per decidere tutto il
> resto sui numeri invece che a tavolino**. In particolare, senza K5 la regola
> I3 (*1,5% solo su setup A*) non è solo non implementata — **è indecidibile**,
> perché non sappiamo se i setup A rendano davvero più dei B.

---

# PARTE 3 — LE REGOLE PROP DEL CAP.14: CHI LE FA RISPETTARE?

Il blocco è passato da 3/9 a **5/10**, ma i due punti guadagnati vengono da un
bug corretto (I7) e da una regola che l'EA già rispettava senza saperlo (I10).
**Le quattro assenze del 19/08 sono tutte e quattro ancora lì.**

## 3.0 Il quadro

| regola cap.14 | nell'**EA** v2.00 | nel **Guardian** | verdetto | vs 19/08 |
|---|---|---|---|---|
| 0,5% demo / 1% ordinario | ✅ input `InpRiskPercent` (166) | – | **c'è** (ma i preset FW usano 1% su demo) | = |
| max 1,5% solo setup A | ⛔ | ⛔ | 🕳️ **BUCO** (dipende dalla classificazione, assente) | = |
| non superare 2% | ⛔ nessun cap | 🟡 indiretto: `InpMaxOpenRiskPct=3.25` sul **rischio aperto** | 🕳️ **BUCO sul rischio per trade** | = |
| max 2 trade/giorno stesso strumento | ✅ `InpMaxTradesPerDay=2` | – | **c'è** | = |
| **max 3 trade/giorno complessivi** | ⛔ conta solo il proprio simbolo+magic | ⛔ il Guardian conta **euro**, non trade | 🕳️ **BUCO TOTALE** | = |
| stop dopo 2 perdite consecutive | ✅ **ora funziona** (FIX 3) | – | **c'è** | 🟢 **RISOLTO** |
| **stop giornaliero −2R/−3R** | ⛔ | 🟡 `InpDailyPausePct=4.0`, `InpDailyLossPct=5.0` | 🕳️ **BUCO** (surrogato più largo, e in % non in R) | = |
| mai aumentare size dopo perdita | ✅ per costruzione | – | **c'è** | = |
| size dal rischio tecnico 🆕 | ✅ `LotByRisk(risk)` (538) | – | **c'è** | nuova |

## 3.1 Cosa fa il Guardian (riverificato oggi)

`mql5/Experts/ABTG_Guardian.mq5` sorveglia **il conto in euro**, non le regole di
setup — inputs riletti alle sue righe 50-70:

- `InpDailyLossPct=5.0` — perdita giornaliera dura (chiude e blocca);
- `InpTotalDDPct=10.0` — drawdown totale;
- `InpDailyPausePct=4.0` — **pausa morbida B1**: sotto −4% niente nuovi ingressi;
- `InpMaxOpenRiskPct=3.25` — **cap C1** sul rischio aperto simultaneo.

L'EA li rispetta con una riga sola, **messa correttamente immediatamente prima
dell'invio** (riga 542, dopo il calcolo del lotto e prima del `Buy`/`Sell`):

```
if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_GoldenCross")) return;
```

✅ Posizionamento corretto: mai in cima all'imbuto, mai sulle chiusure. Il
**fail-open è totale e dichiarato** nel commento (righe 80-85): nel Strategy
Tester le GlobalVariable non esistono, quindi i backtest restano confrontabili.

🔑 **Ma il Guardian conta EURO, il cap.14 conta OPERAZIONI e R.** Sono due
grandezze diverse: nessuna delle due copre l'altra. E nove giorni dopo il 19/08
il Guardian non ha ancora né un contatore di trade né una nozione di R.

## 3.2 🕳️ BUCO — "non superare il 2% per trade"

Nessuno controlla `InpRiskPercent`. Il cap C1 limita il rischio *aperto
simultaneo* (3,25%), non quello *per singola operazione*: un EA a
`InpRiskPercent=3.0` con **una sola** posizione aperta passa il cap C1 senza un
fiato, pur violando il cap.14.

**Proposta (opt-in, default = comportamento attuale, NON implementata):**

```
input double InpCapRischioPerTrade = 0;   // 0 = spento (attuale). >0 = tetto duro % per trade
```

Se `>0` e `InpRiskPercent > InpCapRischioPerTrade` → `Alert` + `INIT_FAILED` in
`OnInit`. **Default 0 = nulla cambia.** Valore da manuale: **2.0**.

## 3.3 🕳️ BUCO TOTALE — "massimo 3 trade complessivi al giorno"

`TodayStats()` filtra per `DEAL_SYMBOL==_Symbol` **e** `DEAL_MAGIC==InpMagic`
(righe 796-797). Ogni istanza conta **solo se stessa**.

🚨 In flotta girano **più sedie GoldenCross** (magic 770301 nel nativo, 970301
nell'Ottimizzato) più le altre famiglie. Con `InpMaxTradesPerDay=2` ciascuna, il
tetto reale della famiglia è un multiplo di 2, contro i **3 complessivi** del
cap.14. Il changelog dell'EA (righe 63-65) dichiara di aver lasciato fuori questa
regola di proposito, *"va nel Guardian, che vede tutto il conto; qui sarebbe una
regola in cinque copie"*. **La diagnosi è giusta. Il lavoro nel Guardian non è
stato fatto.**

**Proposta (nel Guardian, non nell'EA):** un `InpMaxTradeGiorno` che conti i
`DEAL_ENTRY_IN` del giorno **su tutti i magic** e alzi la pausa B1 al
superamento. ⭐ Una regola sola, un posto solo, valida per l'intera flotta.

## 3.4 🕳️ BUCO — "stop giornaliero −2R / −3R"

Il Guardian ha −4% (pausa) e −5% (blocco), ma sono **percentuali di saldo**. Col
rischio all'1%, **−3R ≈ −3%**: il Guardian interviene **dopo**. Col rischio a
0,5% (quello che il PDF vorrebbe in demo) **−3R ≈ −1,5%**: il Guardian è **quasi
il triplo più permissivo**.

🆕 Il glossario del PDF (pag.12) conferma l'unità: *"R: unità di rischio del
trade. Se rischio 100 euro, +1R significa +100 euro."* Non c'è ambiguità su cosa
misurare.

**Proposta (opt-in, nell'EA perché R è una grandezza dell'EA, non del conto):**

```
input double InpStopGiornoR = 0;   // 0 = spento. es. 3.0 = stop operativo a -3R sulla giornata
```

⚠️ **Attenzione al fuso:** `TodayStats` taglia a **mezzanotte server** (777-778),
il Guardian usa `InpDailyResetHour` (sua riga 54, default 0 = mezzanotte broker).
Oggi coincidono, ma se qualcuno tocca `InpDailyResetHour` i due limiti misureranno
due "giornate" diverse. Va scritto, non ricordato.

## 3.5 🕳️ BUCO — "1,5% solo su setup A"

Dipende interamente dalla classificazione (blocco H). **Proposta a due stadi,
nell'ordine, e il secondo solo dopo il primo:**

```
input bool   InpClassificaSetup = false;  // calcola e LOGGA il grado A/B/C, senza usarlo
input double InpRiskPercentA    = 0;      // 0 = spento. >0 = rischio usato SOLO sui setup A
```

⭐ **Il primo stadio vale la pena anche se il secondo non si fa mai**, e col PDF
vero il suo valore è più alto di quanto sembrasse: il cap.15.2 e il cap.16
**chiedono entrambi la classe del setup come dato da registrare**. Loggandola si
scopre **sui dati** se i setup A rendano davvero più dei B. **Se non c'è
differenza misurabile, il rischio differenziato del cap.14 non va implementato
affatto**: sarebbe prendere più rischio senza edge.

---

# PARTE 4 — LE REGOLE NON MECCANIZZABILI

Cinque regole chiedono un concetto che l'EA **non possiede in nessuna forma**:
livelli, congestione, liquidità. Non sono dimenticanze del programmatore: sono
**il residuo discrezionale della strategia**. Il quadro è identico al 19/08 —
qui in nove giorni non si è mosso niente — con **una differenza importante sulla
sesta riga**.

| regola del PDF | come l'EA la tratta | giudizio |
|---|---|---|
| *"spazio tecnico fino alla prima resistenza"* (cap.5 p.13, cap.2 fase 6) | 🚫 **la ignora**. Il TP è un multiplo di R e non guarda cosa c'è davanti | il TP a 2R è un **surrogato onesto ma cieco**: garantisce il rapporto, non la raggiungibilità |
| *"target tecnico: supporti, resistenze, massimi/minimi relativi, pivot, aree di volume, estensioni"* (cap.10.2) | 🚫 ignorata | **meccanizzabile in parte**: massimi/minimi precedenti, pivot ed estensioni sono calcolabili; le "aree di volume" no, non su dati tick di un broker retail |
| *"resistenza importante"* come uscita (cap.11) | 🚫 ignorata | idem |
| *"il movimento è già arrivato su supporto o resistenza"* (cap.12 n.11) | 🚫 ignorata | è la stessa nozione, in negativo |
| *"l'incrocio avviene dentro una congestione"* (cap.12 n.3) | 🟡 **approssimata**: `BBExpanding()` (271-284) — **ma `InpUseBBExpand=false`** | ⭐ **la migliore approssimazione presente nel file.** La larghezza delle bande è una misura diretta di compressione: acceso, questo filtro *è* un filtro anti-congestione. **Che sia spento è una scelta, non un limite tecnico** |
| *"il mercato è privo di liquidità"* (cap.12 n.15) + **fasce orarie** (cap.4) + 🆕 *"evitare strumenti con spread elevato"* (cap.4) | 🚫 nessun filtro orario; `InpMaxSpread` esiste ma è **default 0 = spento** | 🎯 **la meno discrezionale delle cinque**: "sessione" e "spread" sono numeri. **Il buco più facilmente colmabile dell'intero referto**, e il PDF vero lo chiede in *due* capitoli invece di uno |
| 🆕 *"lo stop tecnico è troppo ampio"* (cap.12 n.13) | 🚫 ignorata | ⚠️ **il 19/08 stava in questa lista. Oggi ne esce**: il glossario (cap.20) dice che l'ATR è il metro per gli *"stop eccessivi"*. **Non è discrezionale: è un multiplo di ATR** (§0.3-E) |
| *"il trader è emotivamente alterato"* (cap.12 n.16a) · *"la posizione non va difesa per orgoglio"* (cap.11) · *"sto entrando per regola e non per impulso"* (cap.15.1 n.16) | N/A | ⭐ nota non ironica: **un EA le rispetta per costruzione**. Sono gli unici punti in cui la macchina batte l'operatore senza discussione. E la **seconda metà** della n.16 (*"sta cercando di recuperare una perdita"*) **non è in questa lista**: è codice, ed è scritto (§0.3-A) |

---

# PARTE 5 — NOTE TECNICHE (non di fedeltà, ma da sapere)

Cose trovate rileggendo il codice che **non riguardano il PDF** ma riguardano
l'affidabilità di quello che gira.

1. **Ricalcolo delle Heiken Ashi con warm-up.** `GetHA()` (332-352) ricalcola le
   HA da un punto arbitrario, con seme `(o+c)/2` (346) e **60 barre di
   riscaldamento** (334). L'errore del seme decade esponenzialmente: a 60 barre è
   trascurabile. ✅ **Approssimazione corretta e dichiarata.**
2. **`ManageOpen()` gira a ogni tick** (301), ma legge sempre i buffer alla
   **barra 1** (chiusa): il *valore* è di barra chiusa, il *momento* della
   decisione è il primo tick utile. ✅ Corretto. Il commento a riga 610 dice
   *"(a barra chiusa)"*: preciso abbastanza.
3. **Ingresso a mercato al prezzo corrente, filtri sulla `close1`.** I filtri di
   distanza (468, 470) usano la chiusura della barra precedente (440), ma
   l'ordine parte all'`ask`/`bid` corrente (507-508, 546-547). Su un'apertura in
   gap il prezzo effettivo può essere ben oltre la soglia appena verificata.
   Effetto piccolo su H1/H4, non nullo. **Rilevante perché il PDF fa della
   distanza dalle medie una regola centrale** (cap.9).
4. **Guardia anti-duplicato reload-safe** (500-501) e **selezione hedge-safe per
   ticket** (`SelMyPos()` 724-732): entrambe corrette, coerenti con lo standard
   della flotta.
5. **`gPartialDone` è un `bool` globale** (198), non legato al ticket; viene
   riazzerato all'apertura (543) e l'EA tiene una posizione per volta (305):
   quindi funziona. ⚠️ Ma dopo un **reload del terminale a posizione aperta**
   torna `false` e il parziale potrebbe essere rifatto. Non è fedeltà al PDF: è
   robustezza. **Segnalato il 19/08, ancora così.**
6. **Limite dichiarato nel FIX 3**, e lo dichiara il codice stesso (781-784): la
   finestra di `TodayStats` è la giornata, quindi **di una posizione aperta ieri
   e chiusa oggi si vede solo la parte di oggi** (manca l'eventuale commissione
   d'ingresso). Il segno del netto quasi sempre non cambia. ✅ Limite scritto nel
   posto giusto — nel file, non nella testa di qualcuno.
7. **`eta` calcolato e buttato.** `CrossInWindow()` restituisce l'età
   dell'incrocio in barre (411, 417-418) — *"l'informazione che il PDF chiama 'di
   recente'"*, dice il commento a riga 407 — e il chiamante la dichiara (452), la
   passa (462, 482) e **non la usa mai**. Zero costo per loggarla (cap.16, K2).

## 5.6 Le varianti — verificate oggi, una per una

| file | versione | stato |
|---|---|---|
| `mql5/Experts/ABTG_GoldenCross.mq5` | **2.00**, 952 righe | l'oggetto di questo referto |
| `mql5/Experts/ABTG_GoldenCross_Ottimizzato.mq5` | **2.00**, 865 righe | **ha tutti e tre i fix** (`CrossInWindow` sua riga 330, `aboveFast` 383, `DEAL_POSITION_ID` 715) e i due opt-in. **Default diversi: `InpAdxMin=15.0`, `InpAtrSLmult=1.0`, `InpTP_R=3.0`.** ⚠️ **Continua a mancargli** il filtro Bollinger (nessun gruppo BB) e `InpHAAutoCount`. Magic 970301 |
| `mql5/Experts/standalone/ABTG_GoldenCross.mq5` | **1.00**, 589 righe | 🚨 **versione pre-fix.** Ha ancora `crossPast = (ef[InpCrossLookback] <= em[InpCrossLookback])` (sue righe 271, 285), niente `aboveFast`, niente raggruppamento per posizione, **niente Guardian**, niente Bollinger, niente AutoCount, niente FridayClose |
| `mql5/Experts/ABTG_GoldenCross_V1.mq5` | **1.00**, 730 righe | archivio della v1.00 in campo fino al 19/08 (magic 770331/2/3). Ha il Guardian ma non i fix |

**Due avvertenze operative che seguono da qui:**

- **L'Ottimizzato con `InpAdxMin=15` è meno fedele al PDF del fratello.** Il cap.8
  (pag.6) classifica 15-20 come *"forza incerta — ingresso solo con setup molto
  pulito, ma preferibile attendere"*, e il cap.12 n.5 vieta esplicitamente
  *"ADX tra 15 e 20 **senza forte conferma tecnica**"*. L'Ottimizzato entra in
  quella fascia **senza nessuna conferma aggiuntiva** — anzi, con **una in meno**,
  visto che gli manca proprio il filtro anti-congestione. Non è una bocciatura
  (magari sui numeri va meglio), ma **va detto che quel default sta fuori dal
  documento**, non dentro.
- 🚨 **`standalone/` è un campo minato.** Chi copia quel file in `MQL5\Experts`
  crede di installare "GoldenCross" e installa **la versione con i tre bug del
  19/08 e senza Guardian**. Andrebbe rinominato o archiviato con la data. Non l'ho
  toccato: questo giro è di sola lettura.

---

# PARTE 6 — COSA FARE, IN ORDINE

**Non ho backtest di questo EA in questa sessione**, quindi **non affermo che
nessuna di queste modifiche migliori le performance**. Dico solo cosa è coerente
col PDF e quale metrica dovrebbe muoversi. La prova arriva dal tester di Claudio,
e poi dal forward demo.

Le voci 1, 2 e 3 del piano del 19/08 sono state fatte. Questa è la lista nuova.

| # | intervento | tipo | costo | metrica attesa |
|---|---|---|---|---|
| **1** | 🔘 **Accendere gli interruttori che ci sono già**, uno alla volta: `InpMaxDistEma21ATR=1.0` (D4/D5/G10) · `InpMaxDistATR=0.5` (D3) · `InpHABodyFactor=1.0` (B8/G8) · `InpUseBBExpand=true` (G3) | fedeltà | **zero codice** | meno trade, R medio migliore **se il PDF ha ragione**. ⭐ **Da fare per primo: sono quattro valori da manuale presi dal documento, non parametri pescati** |
| **2** | 📊 **Log del cap.16** (blocco K): scrivere all'ingresso `eta`, ADX, DI, distanza da EMA9/EMA21 in ATR; alla chiusura il **risultato in R** | conoscenza | basso | **nessuna: non cambia un trade.** Produce i dati per decidere il resto sui numeri |
| **3** | 🛡️ **`InpCapRischioPerTrade`** (§3.2), default 0 | sicurezza | banale | **nessuna: non cambia un trade** |
| **4** | ⏰ **Filtro orario** `InpOraInizio`/`InpOraFine` in **ora server** (J3/J4/G15) | fedeltà | un `if` | meno trade, drawdown atteso più basso. ⚠️ fuso BCM: ora italiana − 1 |
| **5** | 📐 **Tetto sullo stop in ATR** (G13) — `InpMaxSLatr = 0` = spento | fedeltà | basso | meno trade, R più omogeneo. 🆕 sbloccato dal glossario del PDF (§0.3-E) |
| **6** | 🏔️ **Tetto superiore ADX** (C5) — `InpAdxMax = 0` = spento | fedeltà | banale | meno trade nei movimenti già estesi |
| **7** | 📏 **Soglia minima di pendenza EMA50** (G2/A3) — sostituire `>=` con una soglia in ATR, dietro input, default 0 = attuale | fedeltà | basso | meno trade in congestione. **È la regola che il PDF ripete 4 volte** |
| **8** | 🏷️ **Classificazione A/B/C solo a log** (§3.5 stadio 1) | conoscenza | medio | **nessuna: non cambia un trade.** Sblocca H1-H3 e I3 |
| **9** | 🏛️ **Tetto trade/giorno di famiglia + stop −xR nel Guardian** (§3.3, §3.4) | disciplina | medio | vale per tutta la flotta. Il changelog dell'EA ha già deciso che va lì |
| **10** | 💰 rischio differenziato sui setup A (§3.5 stadio 2) | rischio | basso | 🔴 **da non fare adesso**: **aumenta il rischio**, solo dopo che il punto 8 ha prodotto la prova |

> ⚠️ **Una alla volta, con e senza, su tutti gli anni.** Se un intervento aggiusta
> un anno e ne rovina altri, si scarta: è curve-fitting. E il forward demo resta
> l'unico collaudo che conta. **Le regole di casa non si sospendono per le regole
> prop.**

---

## Nota di metodo, per chi legge fra sei mesi

**Fedele 44/87 non è una bocciatura**, e 46% → 51% in nove giorni è un movimento
reale ottenuto **correggendo tre difetti, non allargando la definizione di
fedeltà**. Il PDF contiene tre cose diverse mescolate:

- **regole meccaniche** (medie, ADX, Heiken Ashi): qui l'EA è **fedele all'81%**
  sui blocchi A+B, e dopo la v2.00 il trigger è finalmente un trigger;
- **giudizio di contesto** (S/R, congestione, liquidità): qui l'EA è **cieco**, e
  in parte lo resterà — è il residuo discrezionale del metodo;
- **disciplina prop** (cap.14) **e tracciabilità** (cap.16): qui l'EA è
  **incompleto senza motivo tecnico**.

🎯 **Il terzo gruppo resta l'unico dove l'infedeltà non ha una scusa**, e il PDF
vero lo ha reso più grande, non più piccolo: alle regole del cap.14 si è aggiunto
un capitolo intero (il 16) che chiede solo di **scrivere quello che si fa**.
Un tetto di 3 trade al giorno è un contatore. Un cap del 2% è un `if`. Uno stop a
−3R è una sottrazione. **Loggare l'ADX all'ingresso è una `StringFormat`.** Sono
le cose più facili del documento e sono ancora quelle messe peggio — perché sono
le uniche che non fanno guadagnare, e servono solo a **non perdere** e a **sapere
cosa è successo**.

E una lezione sulla fonte, che vale oltre questo EA: **la trascrizione del 19/08
era buona sul perimetro che copriva** (checklist, cap.12 e cap.13 resi verbatim),
**ma si fermava al capitolo 14 di un documento che ne ha 20**, e in tre punti
aveva sfumato una regola (il revenge trading, la size dal rischio tecnico, lo
stop definito prima della size) o indurita (*"MAI oltre 2%"*). Il verdetto
numerico non ne era stato falsato — ma tre regole che l'EA **già rispettava** non
gli erano state accreditate, e un capitolo intero non era mai stato misurato.
**Quando la fonte esiste, si legge la fonte.**
