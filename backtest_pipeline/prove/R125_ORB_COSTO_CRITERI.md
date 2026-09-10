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

## 4. LE SOGLIE, CONGELATE ORA

| # | cancello | soglia | perche' |
|---|---|---|---|
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
