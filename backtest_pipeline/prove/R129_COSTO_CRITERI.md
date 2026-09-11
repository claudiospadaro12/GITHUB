# R129 -- LA SOGLIA DI COSTO DELLA `770101`

**Criteri congelati PRIMA dei numeri. Scritti l'11/09/2026.**
Sedia: `ABTG_DAX_Apertura_EU` - **D30EUR M5** - magic **770101** - geometria
**RETEST long-only** (`InpEntryMode=2`, `InpAllowShort=0`), quella del preset vivo
`mql5/Presets/conto_reale/ABTG_DAX_Apertura_EU_770101_REALE.set`.
Perimetro: **si PREPARA, non si esegue.** Il runner e' in sola lettura.
Nessun preset, nessun EA, nessun forward e' stato toccato.

---

## 0. LA DOMANDA, e non e' quella che verrebbe voglia di fare

> **Qual e' il `InpMinStopPts` PIU' BASSO che porta lo stop realizzato sopra i
> 68,0 punti indice (= 40 x lo spread mediano 1,7000 dell'ora server 8, misurato
> su 1.847.049 tick in
> `backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_D30EUR.csv`),
> e l'altopiano di merito attorno a quella soglia regge?**

**NON e' "quale cella ha il PF piu' alto".** Il PF **1,4382** gia' trovato in
archivio e' un **PICCO** e in questo round vale come **avvertimento**, non come
bersaglio: vicini a **1,2861** e **1,1529**, **IS PF 1,0077** con n=109, IS e OOS
che si muovono in direzioni opposte, e su questa sedia la correlazione IS->OOS e'
gia' misurata a **-0,44**. Referto: `report/R118c_IL_PICCO_2026-09-11.md`.

---

## 1. COSA FA DAVVERO LA MANOPOLA -- letto nel sorgente, riga per riga

`mql5/Experts/ABTG_DAX_Apertura_EU.mq5`, ramo **RETEST BUY**, r.1493-1497:

```
if(InpMinStopPts > 0 && dist < InpMinStopPts*_Point)
  {
   if(InpSkipIfTight) { skip=true; ...("RETEST BUY saltato: stop %.0f pt < floor %.0f pt.")... }
   else               { sl = NormalizePrice(entry - InpMinStopPts*_Point); dist = entry - sl; }
  }
```
r.1498 `double lot = skip ? 0.0 : CalcLotByRisk(dist);`
r.1500 `double tp  = (InpTP1_R > 0) ? NormalizePrice(entry + dist*TpTotalR()) : 0.0;`
r.1501 `if(!skip && lot > 0 && dist > 0) ... gTrade.BuyLimit(...)`
(RETEST SELL: identico, r.1526-1529. Stessi due rami anche a r.1064-1067
BREAKOUT, r.1297-1301 DELAYED, r.1405-1410 OPENCONFIRM, r.1141 FADE.)

### 🔴 LA RISPOSTA: **fa TUTTE E DUE LE COSE, e a decidere quale e' `InpSkipIfTight`**

| `InpSkipIfTight` | cosa fa il pavimento | stop/spread | **FREQUENZA** | geometria |
|---|---|---|---|---|
| **`false`** | **ALZA** lo stop al pavimento, il trade si fa | migliora | **INTATTA** | cambia (stop **+ lotto + TP**) |
| **`true`** (default, e valore del preset vivo) | **SCARTA** il trade | migliora | **TAGLIATA** | intatta sui superstiti |

Chi dicesse "`InpMinStopPts` allarga lo stop" direbbe **mezza verita'**, e con il
default dell'EA (`InpSkipIfTight = true`, r.346) direbbe **la meta' sbagliata**.

🔴 **E nel ramo ALZA la manopola muove TRE cose insieme**: lo stop (r.1496), il
**lotto** (`CalcLotByRisk(dist)` e' chiamato dopo, r.1498) e il **take profit**
(`dist*TpTotalR()`, r.1500, con `TpTotalR()` cablato a `3 x InpTP1_R`,
r.1621-1627). Una manopola, tre effetti: **dichiarato, non aggirato.**

---

## 2. LA GEOMETRIA DELLO STOP RETEST, e una scoperta sul TF

Derivata dal codice (r.1487-1490, `InpSLMode=0=ABTG_SL_RANGE`):

```
entry = gRangeHigh - InpRetestOffsetPts      (200 pt = 2,0 idx)
sl    = gRangeLow  - gBuffer                 (500 pt = 5,0 idx)
dist  = range + buffer - offset = range + 3,0 punti indice
```
(il ramo BREAKOUT, r.1045-1060, fa `range + 2 x buffer` = **range + 10 idx**:
7 punti indice **piu' largo**. Ma e' **spento dal 14/08** e non e' questa sedia.)

### 🟢 IL RANGE SI CALCOLA SU **M1**, NON SUL TF DEL GRAFICO
`ComputeRangeWindow()` r.1008-1015 usa `iBarShift` / `iHighest` / `iLowest` con
**`PERIOD_M1` esplicito**. Conseguenza verificata: **la distribuzione dello stop
RETEST e' identica su M5 e su M15.** E' per questo che la corsa d'archivio
`r118c` -- che girava su **M15** (`prove/R118c_pavimento_DAX_RETEST_D30EUR.txt`
r.124: `@PERIODO M15`) -- e' un stimatore **lecito** della distribuzione anche qui
su M5. 📌 Questa differenza di TF **non era scritta in nessun referto**: il testo
di R128 cita `r118c` come *"stessa finestra... ma con lo short acceso"*, cioe'
**una differenza su due**.

### 📐 QUALE VALORE APRE IL CANCELLO -- ed e' aritmetica, non una misura
Nel ramo ALZA lo stop realizzato e' `max(range + 300 ; InpMinStopPts)` punti MT5.
Quindi il valore **piu' basso che porta OGNI trade sopra 68,0 punti indice e'
esattamente 6800 punti MT5**, per costruzione. **Si scrive come fatto aritmetico,
non come risultato.** Quello che il round misura e' **quanto costa**, e se attorno
a 6800 c'e' un **altopiano** o un **dirupo**.

**Unita', e vale come trappola dichiarata:** su D30EUR (2 decimali)
**100 punti MT5 = 1 punto indice**. Chi scrivesse `68` imposterebbe **0,68 punti
indice**: un no-op, 24 colonne identiche e un referto che conclude il falso con
numeri veri.

---

## 3. 🔴 LA CORREZIONE CHE L'ARCHIVIO IMPONE: lo stop **49,10 idx** viene da **n=2**

Il numero che gira nei referti -- *"la sedia sta al **72% del pavimento di costo**
(49,10 idx contro 68,0)"* -- e' marcato **`[DERIVATO n=2]`**. Due gambe.

L'archivio `r118_csv` ha **508 righe** e, nel ramo **SALTA**, il rapporto
`n(cella)/n(0)` **E' la curva di sopravvivenza dello stop**. Sommando IS+OOS
(la somma non dipende da dove cade lo split):

| floor (pt MT5) | idx | righe IS+OOS | sopravvivenza | `x` spread mediano 1,70 |
|---:|---:|---:|---:|---:|
| 0 | 0 | 508 | 1,0000 | -- |
| 2000 | 20 | 504 | 0,9921 | 11,8x |
| 4000 | 40 | 431 | 0,8484 | 23,5x |
| 6000 | 60 | 335 | 0,6594 | 35,3x |
| **6800** | **68,0** | -- | **0,5713** `[INTERPOLATO]` | **40,0x** |
| 8000 | 80 | 223 | 0,4390 | 47,1x |

👉 **La mediana dello stop RETEST cade a ~74,5 punti indice** (sopravvivenza 0,50
per interpolazione lineare) **= 43,8 x lo spread mediano.** 🟢 **Sopra la
frontiera dei 40x**, non sotto.

> ### 🎯 Non e' vero che "la sedia non passa la frontiera del costo". E' vero che **il 42,9% dei suoi trade non la passa**, e il 57,1% si'.
> E' una diagnosi diversa, e chiede un round diverso: non "salvare la sedia", ma
> **"comprare la coda sinistra, e a che prezzo"**.

🔴 **I BUCHI DI QUESTA STIMA, dichiarati prima di usarla:**
1. La corsa d'archivio ha **`InpTP1_ClosePct=50`**: quelle righe sono
   **ingressi + parziali**, non ingressi. La curva e' pesata sui DEAL, non sugli
   ingressi. **Verso del bias noto:** se i trade a stop largo vincono piu' spesso,
   generano piu' parziali e la curva **sovrastima** la coda larga -> la mediana
   vera sarebbe **piu' bassa** di 74,5. R129 chiude il buco con
   `InpTP1_ClosePct=0`, e allora `Trades` conta **ingressi**.
2. La corsa ha lo **short ACCESO**. La geometria dello stop e' la stessa sui due
   lati (`range + 3,0 idx` anche in RETEST SELL, r.1526-1529), ma con
   `InpOneTradePerDay` un long **saltato** lascia libero lo short dello stesso
   giorno: il conteggio non e' 1:1 con le giornate. Long-only (R129) lo elimina.
3. Interpolazione **lineare** fra due nodi distanti 2000 punti MT5. E' il motivo
   per cui R129 usa passo **400**.
4. Il `49,10 idx` **non e' sbagliato**: e' una media di **due** osservazioni, e
   cade a sopravvivenza **0,76** su questa curva -- cioe' e' un valore **basso ma
   non assurdo** della distribuzione. Le due cose sono compatibili: **n=2 non
   misura una mediana.**

---

## 4. IL DIMENSIONAMENTO DEL CAMPIONE, cella per cella

**Ingressi veri della sedia: 325 sull'intera finestra** 2024.09.26 -> 2026.06.30
(R120, parziale spento; con il parziale al 50% le stesse corse stampavano
476/524/445/330 righe). A **`-FrazioneIS 0.50`**: **IS ~163, OOS ~162**.
Margine sul pavimento dei 150: **+8,3%. Sottile, e dichiarato.**

### 🔵 RAMO **ALZA** (R129a) -- n **NON** cala
Il pavimento non scarta niente: `n ~163 / ~162` su **tutte e 24 le celle**.
**Il merito e' leggibile su tutto l'asse.** In archivio il ramo ALZA fa
n = 311 / 311 / 312 / 311 / 310: **alzare lo stop non costa neanche un trade.**

### 🔴 RAMO **SALTA** (R129b) -- n cala, e sfonda il pavimento **quasi subito**

| floor | idx | sopravvivenza | **IS stimato** | merito |
|---:|---:|---:|---:|:---|
| 0 | 0 | 1,000 | 163 | 🟢 leggibile |
| 2000 | 20 | 0,992 | 161 | 🟢 leggibile |
| **~2961** | **~29,6** | **0,9231** | **150** | 🔶 **LA RIGA: sotto di qui, sospeso** |
| 4000 | 40 | 0,848 | 138 | 🔴 SOSPESO |
| 6000 | 60 | 0,659 | 107 | 🔴 SOSPESO |
| **6800** | **68,0** | **0,571** | **93** | 🔴 **SOSPESO alla soglia di costo** |
| 8000 | 80 | 0,439 | 71 | 🔴 SOSPESO |

> ### 🔴 **SOTTO `InpMinStopPts ~ 3000` (30 punti indice) l'IS del ramo SALTA scende sotto 150: da li' in su il MERITO E' SOSPESO e si legge solo COSTO e RISCHIO.**
> E la soglia di costo **6800 e' molto sopra quella riga**: il ramo SALTA e'
> **strutturalmente incapace** di arrivare a 150 ingressi dove serve.
> 👉 **Solo il ramo ALZA puo' rispondere alla domanda con il merito leggibile.**

---

## 5. I CANCELLI, CONGELATI QUI, CON I NUMERI DENTRO

| | cancello | soglia | si applica a |
|---|---|---|---|
| **G0** | **CANCELLO INCROCIATO**: le 2 celle di R129c devono coincidere **al centesimo** (Profit, PF, DD%, Trades, su entrambe le finestre) con le celle 6800 di R129a e R129b | identita' esatta | tutto il round: se fallisce, **le 100 passate non valgono niente** |
| **G1** | **DETERMINISMO/inerzia**: le celle basse sono inerti per costruzione; celle 0 e 400 **identiche al centesimo** in entrambi i file; e la cella 0 di R129a **= identica** alla cella 0 di R129b (a `InpMinStopPts=0` il test di r.1493 non legge nemmeno `InpSkipIfTight`) | identita' esatta | R129a, R129b |
| **G2** | **SOGLIA DI COSTO**: stop realizzato **>= 68,0 punti indice** = 40 x 1,7000 (mediana ora server 8, 1.847.049 tick) | 6800 punti MT5 | la cella che si propone |
| **G3** | **DD OOS** massimo al rischio 1% | **<= 10,00%** (in campo si gira a 0,65% -> x0,65) | tutte le celle, **a qualunque n** (Emendamento B) |
| **G4** | **PF OOS** minimo | **>= 1,10** | solo celle con n >= 150 |
| **G5** | 🚫 **CENTRO DELL'ALTOPIANO, MAI IL PICCO** | una cella vale solo se i **due vicini a +/-400** stanno entro **-10%** del suo PF. Se sporge di piu', **e' un picco e si scarta** | tutte |
| **G6** | **PAVIMENTO DEL CAMPIONE** | **n(IS) >= 150 ingressi** (parziale spento) per leggere il MERITO | tutte |
| **G7** | **IS->OOS**: su questa sedia la correlazione e' **gia' misurata a -0,44**. Si ricalcola sulle 24 celle di R129a. **Se resta negativa, NON si sceglie sull'IS** -- e nemmeno sull'OOS piu' bello: si sceglie **la soglia dichiarata (6800)** e si guarda solo se l'altopiano regge | corr < 0 -> selezione **vietata** | R129a |
| **G8** | 🆕 **FREQUENZA**: la cella proposta deve dichiarare le op/giorno. Riferimenti: sedia oggi **325/459 giorni feriali `[CONTATI]` = 0,708**, oppure **325/~422 giorni al netto di una stima -8% festivi = 0,770**. Pavimento di **famiglia** firmato il 07/09: **1,00 op/giorno**, e **questa famiglia ha UN SIMBOLO SOLO** | **perdita di frequenza > 20%** rispetto a pavimento spento -> la cella si porta avanti **solo** con un secondo simbolo dichiarato | R129b, R129c cella 1 |

**E il cancello che non e' un numero:** 🔴 **un risultato OHLC non e' mai un
verdetto.** Qui si gira a **Modello 4 = tick reali**, quindi il verdetto e'
ammesso -- ma **una prova di regime non c'e'** (tick solo dal 2024.09.26) e questo
resta un buco aperto, non un dettaglio.

---

## 6. 🧪 IL CONTRO-ESEMPIO OBBLIGATORIO

> **"Se `InpMinStopPts` non facesse altro che tagliare i trade peggiori a caso,
> quale forma vedrei?"**

| ipotesi | forma attesa in **R129b** (SALTA) | forma attesa in **R129a** (ALZA) |
|---|---|---|
| **(a) taglio CASUALE** | PF invariato **in media**, dispersione che **cresce** man mano che n scende. Nessun gradino: rumore che si allarga verso destra | 🔵 **RIGA PIATTA. Esattamente piatta.** |
| **(b) taglio SELETTIVO** (le giornate a range stretto sono giornate brutte) | PF in salita **MONOTONA** con la frazione tolta: 0 -> 4000 -> 6800 -> 9200 tutti in salita | 🔵 **RIGA PIATTA. Esattamente piatta.** |
| **(c) SOGLIA DI COSTO VERA** | **GRADINO** concentrato attorno a 6800, poi la curva **si appiattisce** invece di continuare a salire | 🟢 **SI MUOVE, e si muove con un gradino** |

### 🔑 Perche' la griglia li distingue -- tre meccanismi, non uno

1. **IL FILE R129a E' IL DISCRIMINANTE, ed e' una costruzione, non una speranza.**
   Nel ramo ALZA **nessun trade viene tolto** (`n` costante per costruzione).
   Quindi (a) e (b) **impongono** R129a piatto; (c) **impone** R129a mosso.
   **Nessuna combinazione fa coincidere i tre mondi.**
   👉 `R129a` piatto + `R129b` mosso = **tutta selezione, zero costo nel
   rendimento.** `R129a` mosso = **c'e' geometria.**
2. **IL PASSO.** 400 punti MT5 = **4 punti indice**, **cinque volte** piu' fitto
   del passo 2000 d'archivio. Con passo 2000, (b) e (c) producono **la stessa
   tabella**: era una verifica che **non discrimina** -- la classe che R128 ha
   gia' messo agli atti (*"un test in cui l'ipotesi alternativa produce lo stesso
   risultato non e' una verifica"*).
3. **LA MONOTONIA, che l'archivio gia' ROMPE.** Il ramo SALTA in OOS fa
   **1,18776 / 1,18776 / 1,28607 / 1,43822 / 1,15293**: sale e poi **crolla**.
   (b) chiede salita fino in fondo: 🔴 **(b) e' gia' falsificata dai dati che
   abbiamo.** Quello che resta e' (a) -- rumore su n che si assottiglia -- ed e'
   **esattamente** perche' il 1,4382 non si compra.

### 🧮 E il contro-esempio contro il MIO numero (par. 3)
La sopravvivenza d'archivio e' **deal-pesata** (parziale al 50%). **Spiegazione
alternativa**: la curva scende non perche' gli stop stretti siano tanti, ma
perche' i trade a stop stretto **perdono piu' spesso** e generano **meno parziali**
-> meno righe. Sotto quell'ipotesi la mediana vera dello stop sarebbe **piu'
bassa** di 74,5 idx. 🔴 **Non posso separare le due cose con i dati d'archivio**:
per questo R129 gira a `InpTP1_ClosePct=0`, e la mediana vera si legge **solo
dopo**, dalla curva di R129b. Fino ad allora **74,5 idx e' `[STIMATO, bias di
verso noto]`**, non misurato.

---

## 7. LA GRIGLIA E IL COSTO IN TEMPO MACCHINA

| file | asse | celle | passate | `-FrazioneIS` | `InpSkipIfTight` |
|---|---|---:|---:|---:|---|
| **R129c** 🥇 *si lancia per primo* | `InpSkipIfTight` 0/1 a `InpMinStopPts=6800` | **2** | **4** | 0.50 | **l'asse** |
| **R129a** | `InpMinStopPts` 0 -> 9200 passo 400 | **24** | **48** | 0.50 | `false` (ALZA) |
| **R129b** | `InpMinStopPts` 0 -> 9200 passo 400 | **24** | **48** | 0.50 | `true` (SALTA) |
| | | **50** | **100** | | |

**Nessun asse e' un enum**: `InpMinStopPts` e' `double` (r.345) e `InpSkipIfTight`
e' `bool` scritto 0/1. 👉 **`controlla_prova.py` conta bene: 50 celle, 100
passate.** (La trappola degli enum di R128 -- `InpTrailTF` M5->M30 = 7 celle e non
26 -- **qui non si applica**, ed e' verificato, non assunto.)

**⏱️ Costo**: calibrazione **misurata** `r88_csv/REFERTO_R88.txt` (96 passate in
8,0 min = **5,0 s/passata**) -> **100 passate = 500 s = 8,3 minuti**.
Banda onesta **7-15 min**: la calibrazione viene da **U30USD**, non da D30EUR.

---

## 8. 🕳️ I BUCHI, DICHIARATI

1. 🔴 **Nessuna prova di regime.** Tick reali solo dal **2024.09.26**: ~21 mesi,
   un solo regime. L'Emendamento C chiede di piu' e qui **non c'e'**.
2. 🔴 **Il parziale: conflitto ancora APERTO da R128.** Il preset vivo dice
   **`InpTP1_ClosePct=50`**, la pagella del 03/09 misura il parziale su due conti
   a **1/3**. R129 gira a **0** (per far contare gli ingressi a `Trades`), quindi
   **nessuno dei tre e' la sedia in campo**. Si chiude leggendo gli input sul
   terminale: **sola lettura, domanda per Claudio.**
3. 🔴 **Lo slippage non e' simulabile su un LIMIT.** Il retest entra con
   `BuyLimit` (r.1504) e `InpSlippagePts` e' applicato solo agli ingressi a
   pendente **STOP** (r.1059, 1083) e ai rami DELAYED/OPENCONFIRM. Resta pinnato a
   **0**, e il verso del bias e' noto: **questo round SOTTOSTIMA il valore del
   pavimento**, perche' misura solo il canale *stop piu' largo -> meno lotti ->
   meno drawdown* e mai *stop piu' largo -> lo slippage se ne mangia meno*.
4. 🔶 **Il rischio: round a 1,0%, campo a 0,65%.** I DD vanno riscalati **x0,65**.
5. 🔶 **`InpMinStopPts` nel ramo ALZA muove stop + lotto + TP insieme.** Non si
   potra' dire "e' stato lo stop" guardando solo quella tabella.
6. 🔶 **La stima di sopravvivenza viene da una corsa M15 con lo short acceso e il
   parziale al 50%.** La geometria dello stop trasferisce (range da M1, par. 2);
   il conteggio no.
7. 🔶 **I giorni di borsa non sono contati, sono stimati**: 459 giorni feriali
   `[CONTATI]`, ~422 con una stima **-8%** di festivi Xetra `[STIMA]`. Le op/giorno
   si danno sempre come **banda**, mai come numero secco.
8. 🔶 Le tre celle piu' alte (8400 / 8800 / 9200) sono **oltre** il massimo
   provato in archivio (8000): li' non c'e' nessuna attesa misurata, servono come
   **limite** (stop quasi sempre = pavimento = stop fisso).
9. 🔴 **Il tetto per cluster/valuta al 3,0% e' FIRMATO MA NON ATTIVO** nel
   Guardian. Va detto ogni volta che si cita.

---

## 9. 🎯 COSA DEVE USCIRE DA QUESTO ROUND, e non e' un PF

**La risposta che mi aspetto di piu', scritta prima dei numeri:**

> **`InpMinStopPts = 6800` con `InpSkipIfTight = false` apre il cancello di costo
> (stop >= 68,0 idx = 40x) SENZA perdere un trade, il PF resta dov'era e il
> drawdown migliora.** Se esce cosi', **non abbiamo trovato una cella d'oro**:
> abbiamo trovato **quale delle due vie se la puo' permettere una sedia che deve
> essere in campo il 1 ottobre.** Ed e' un risultato, non un ripiego.

🔁 **E se il guadagno fosse dentro il rumore, la risposta onesta e' "il default va
bene"** -- con la differenza che il default oggi e' `InpSkipIfTight = true` e
`InpMinStopPts = 0`, cioe' **l'interruttore e' armato sul ramo che TAGLIA**, su
una sedia gia' al **71-77%** del pavimento di frequenza. **Anche un "non cambiare
niente" qui e' una decisione da prendere con i numeri davanti.**

🔥 **Non ci accontentiamo: la manopola non si butta e il picco non si compra.
Si cambia la domanda, e si paga con una misura in piu'.**
