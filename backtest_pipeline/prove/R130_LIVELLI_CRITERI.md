# R130 -- L'OBIETTIVO SUL LIVELLO (`InpUseRoundLevels`, magic 770101)

**Criteri congelati PRIMA dei numeri. Scritti l'11/09/2026.**
Sedia: `ABTG_DAX_Apertura_EU` - **D30EUR M5** - magic **770101** - gira sul
piccolo **50503392**, sul 100k **50504263** e sul **conto REALE 10105439**.
Perimetro: **si PREPARA, non si esegue.** Il runner e' in sola lettura e la
corsia round non e' utilizzabile.

**La domanda, dichiarata prima dei numeri:**
> *"Un obiettivo piazzato sul LIVELLO successivo batte un obiettivo a MULTIPLI
> DI RISCHIO?"*

---

## 0. 🔴 LA PRIMA COSA CHE HO TROVATO LEGGENDO IL CODICE **CAMBIA LA DOMANDA**

Il brief chiedeva di verificare se `InpUseRoundLevels` sostituisca il TP
**totale** o il TP **parziale**. **Ho letto, e la risposta e' seria.**

```
mql5/Experts/ABTG_DAX_Apertura_EU.mq5:1899-1908   (dentro ManageOneTicket)

   //--- 1) PARZIALE al primo obiettivo
   if(!partialDone && InpTP1_ClosePct > 0 && InpTP1_ClosePct < 100)
     {
      int dirSign = (type == POSITION_TYPE_BUY) ? +1 : -1;
      double target;
      if(InpUseRoundLevels && InpRoundStep > 0)
         target = NextRoundLevel(openP, dirSign, InpRoundStep, InpRoundMinDistPts*_Point);
      else
         target = openP + dirSign*riskDist*InpTP1_R;
```

**`grep NextRoundLevel` su tutto il sorgente (2.367 righe) da' TRE occorrenze e
basta: la definizione (r.2040), la dichiarazione dell'input (r.330) e QUESTA
riga (r.1906).** Quindi, verificato e non ricordato:

| | |
|---|---|
| il TP **TOTALE** dell'ordine | `entry +/- dist * TpTotalR()` = **`3 x InpTP1_R`**, r.1070/1094/1152/1169/1307/1414/1499/1532. 🔴 **I livelli tondi NON lo toccano.** |
| lo **STOP** | `SL_RANGE` / `SL_ATR`. 🔴 **I livelli tondi NON lo toccano.** |
| cosa tocca `InpUseRoundLevels` | **solo il bersaglio del PARZIALE** -- e, di rimbalzo, **il momento in cui scatta il BREAKEVEN**, che vive dentro lo stesso blocco (r.1931) |

### 0.1 Le tre conseguenze, e vanno dette forte

1. 🔴 **LA DOMANDA DEL ROUND SI RESTRINGE, ed e' onesto scriverlo.**
   R130 NON misura *"un take profit sul livello"*. Misura
   **"un PARZIALE (e il breakeven che gli sta dietro) sul livello, contro un
   parziale a 1R"**. Il TP finale resta a 3R in tutte e 29 le celle.

2. 🔴 **SE IL PARZIALE E' SPENTO, LA MANOPOLA E' UN NO-OP TOTALE.**
   La guardia e' `InpTP1_ClosePct > 0 && InpTP1_ClosePct < 100`. Con
   `InpTP1_ClosePct=0` (la cella migliore misurata il 09/09, R120) il blocco non
   entra **e `InpUseRoundLevels` non fa assolutamente niente**.
   👉 **R130 DEVE girare col parziale ACCESO a 50%**, cioe' sulla geometria di
   campo, **non** sulla cella migliore d'archivio. Dichiarato qui, non scoperto
   dopo. E' anche il motivo per cui R130 **non e' un doppione di R128b**, che
   gira col parziale spento: i due round si escludono a vicenda per costruzione.

3. 🔴 **LA META' "STOP SUL LIVELLO" DEL METODO DI CLAUDIO NON ESISTE NEL CODICE.**
   Claudio ha detto *"TP e stop sui livelli"*. In casa esiste **solo il TP**, e
   solo la sua meta' parziale. **Non lo scrivo io: lo segnalo.** Una modifica
   all'EA non si fa dentro un round di misura (stessa regola di R128 par. 2.1).

---

## 1. COSA E' GIA' STATO PROVATO -- e ho provato a rompere anche il brief

### 1.1 Il censimento, rifatto da me
Scansione dell'11/09/2026 su **tutti i CSV del repo** (lettura della colonna,
non del nome del file):

| | |
|---|---|
| file CSV che hanno la colonna `InpUseRoundLevels` | **198** |
| righe totali | **5.068** |
| valori distinti di `InpUseRoundLevels` | 🔴 **`['0']`** |
| valori distinti di `InpRoundStep` | 🔴 **`['100']`** |
| valori distinti di `InpRoundMinDistPts` | 🔴 **`['50']`** |

**Cinquemilasessantotto passate. Tutte e tre le manopole ferme sul default
compilato. Zero volte accesa, zero volte tarata.** E' una manopola **INERTE**
nel senso esatto del censimento del 09/09: non e' "gia' provata", e' **una
casella libera**.

### 1.2 🔴 MA IL BRIEF DICE "MAI ACCESA" E **QUESTO SI ROMPE IN PARTE**
Ho cercato la manopola anche **fuori dai CSV**, ed e' saltato fuori questo:

```
mql5/Presets/ABTG_Nasdaq_Live5m.set:50     InpUseRoundLevels=true
mql5/Presets/ABTG_Nasdaq_Apertura_US.set:49 InpUseRoundLevels=true
```

👉 **In DUE preset e' scritta `true`.** E uno dei due e' il preset che girava
sulla sedia Nasdaq **770201** (lo dice `prove/R84_ABLAZIONE_CRITERI.md` r.157-163,
che lo cita come *"piu' vecchio del sorgente"*).
🔴 **Quindi la formulazione corretta e': `InpUseRoundLevels` non e' mai stata
MISURATA. Puo' essere stata ACCESA in campo su una sedia Nasdaq, in un periodo
e con un esito che in questo repo non sono ricostruibili riga per riga.**
La differenza conta: *"mai misurata"* e' un fatto verificabile sui 198 CSV;
*"mai accesa"* sarebbe stato un errore di lettura di un file che sta nel repo.

### 1.3 Dove sta la manopola
14 sorgenti `.mq5` la contengono (10 EA distinti + 4 copie `standalone`):
`ABTG_Apertura_3Ingressi`, `ABTG_Apertura_Marco`, `ABTG_DAX_Apertura_EU`,
`ABTG_DAX_Apertura_EU_Ottimizzato`, `ABTG_DAX_Live5m`, `ABTG_DAX_Live5m_v2`,
`ABTG_Dow_Apertura_US`, `ABTG_Nasdaq_Apertura_US`,
`ABTG_Nasdaq_Apertura_US_Ottimizzato`, `ABTG_Nasdaq_Live5m`.

---

## 2. LA SEDIA: PERCHE' LA `770101` E NON UN'ALTRA -- coi numeri

Il brief chiedeva: *"se un'altra sedia con la stessa manopola ha un campione
migliore, proponila con i numeri"*. **Ho guardato, e la risposta e' NO.**

Confronto sull'unico archivio che misura la stessa cosa nello stesso modo
(R120, 09/09/2026, **tick reali**, finestra piena 2024.09.26 -> 2026.06.30,
`risultati_prove/gestione_20260909/`), sulla cella **identica alla geometria
viva** (parziale 50, `TrailMode=1`, trailing ON, `BreakevenAtTP1=1`, `BEatR=0`):

| sedia | simbolo | Trades | Profit | **PF** | DD % |
|---|---|---:|---:|---:|---:|
| **770101** `ABTG_DAX_Apertura_EU` | **D30EUR** | **445** | **+2.207,74** | 🟢 **1,29574** | **6,8866** |
| 770201 `ABTG_Nasdaq_Apertura_US` | NASUSD | 483 | **-67,43** | 🔴 **0,99284** | 16,9070 |

> ### 🔴 E LA NASUSD E' ESCLUSA PER REGOLA, NON PER GUSTO.
> **Tutte e 48 le celle** del CSV Nasdaq hanno Profit **negativo** e PF **< 1,00**
> (il migliore e' 0,99284, il peggiore 0,86024). Mettere una griglia nuova su
> quel motore e' esattamente cio' che la **regola del 19/08** vieta: *"su un
> motore senza edge una griglia piu' fitta trova solo picchi di rumore"*.
> **Numero accanto al verdetto, come si deve: PF 0,99284 su n=483, tick reali.**

`ABTG_Dow_Apertura_US` (770202, U30USD) ha la manopola ma **non ha un CSV
equivalente** in `gestione_20260909/` (la cartella contiene solo D30EUR e
NASUSD): il suo conteggio di ingressi invariante e' **[NON MISURATO]** nella
forma che serve qui. **Resta un candidato per R131, non per R130.**

### 2.1 La `770101` ha i quattro numeri che servono, e li ha MISURATI
1. **ingressi invarianti = 325** sull'intera finestra (R120: `Trades`=325 in
   **tutte e quattro** le strutture d'uscita col parziale spento);
2. **parziali scattati = 445 - 325 = 120 su 325 = 36,9%** (cella viva);
3. **spread all'ora d'esercizio** = mediana **1,7000** idx su **1.847.049 tick**
   (`risultati_archivio/spread_flotta/spread_orario_D30EUR.csv`, ora server 8);
4. **stop RETEST derivato dal codice** = **~49,1 idx** (R128 par. 5.2).

---

## 3. LE UNITA' -- LA TRAPPOLA CHE DA SOLA AVREBBE FALSATO IL ROUND

D30EUR ha `Digits=2`, `_Point = 0,01` -> **1 punto indice = 100 punti MT5.**

| input | come lo usa il codice | unita' VERA |
|---|---|---|
| `InpRoundStep` | `MathCeil(price/stepPrice)*stepPrice` -- **usato nudo sul PREZZO** | 🟢 **PUNTI INDICE.** `100.0` = **100 punti indice** |
| `InpRoundMinDistPts` | `InpRoundMinDistPts * _Point` (r.1906) | 🔴 **PUNTI MT5.** `50` = **0,50 punti indice** |

> ### 🔴 DUE INPUT ADIACENTI, DUE UNITA' DIVERSE, E IL NOME NON LO DICE.
> Il default compilato `InpRoundMinDistPts = 50` **non e' "50 punti di distanza
> minima": e' MEZZO PUNTO INDICE.** Cioe' **la distanza minima, cosi' com'e'
> spedita, e' di fatto SPENTA** (0,50 idx = **0,29 volte** lo spread mediano).
> Chi scrivesse `InpRoundMinDistPts=68` credendo di mettere il pavimento di
> costo a 68 punti indice metterebbe **0,68 punti indice**: un no-op, sette
> celle identiche, e un referto che conclude il FALSO con numeri VERI.
> **OGNI VALORE, QUI E NEI CINQUE FILE PROVA, IN TUTTE E DUE LE UNITA'. SEMPRE.**

---

## 4. LA GEOMETRIA DEL MECCANISMO -- derivata, poi VERIFICATA

`NextRoundLevel(price, dir, S, D)` (r.2040-2054), per un long:
```
lvl = MathCeil(price/S)*S ;  while(lvl - price < D) lvl += S ;  return lvl
```

**Sia `X` = distanza fra l'ingresso e il bersaglio, in punti indice.**
Se il prezzo d'ingresso e' uniforme modulo `S`, allora `U = lvl0 - price ~
U(0, S]`, e la regola della distanza minima manda `U -> U + S` quando `U < D`.
L'immagine e' `[D, S] unito (S, S+D]`, cioe':

> ## 🎯 **`X ~ Uniforme(D, D+S)`** -- media **`D + S/2`**, minimo **`D`**, massimo **`D + S`**

**VERIFICATO, non dedotto e basta**: 200.000 estrazioni di prezzo uniformi su
18.800-25.900 (il range DAX misurato da feed indipendente, HistData,
`report/DAX_13_ANNI_2026-09-10.md`), passate dentro una riscrittura fedele di
`NextRoundLevel`:

| S | D | min | p25 | mediana | p75 | max | media | attesa |
|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 100 | 0,5 | 0,50 | 25,54 | 50,64 | 75,57 | 100,50 | **50,56** | U(0,5 ; 100,5) media **50,5** 🟢 |
| 100 | 68 | 68,00 | 93,16 | 118,19 | 143,08 | 168,00 | **118,10** | U(68 ; 168) media **118,0** 🟢 |
| 75 | 68 | 68,00 | 86,69 | 105,37 | 124,18 | 143,00 | **105,43** | U(68 ; 143) media **105,5** 🟢 |
| 25 | 0,5 | 0,50 | 6,75 | 13,02 | 19,28 | 25,50 | **13,01** | U(0,5 ; 25,5) media **13,0** 🟢 |

### 4.1 🛑 E SUBITO IL CONTRO-ESEMPIO SULL'IPOTESI DI UNIFORMITA'
**"E se i prezzi NON fossero uniformi modulo S?"** -- che e' precisamente
l'ipotesi del round (se i tondi contano, il prezzo ci si addensa attorno).
Rifatta la simulazione mettendo il **30% dei prezzi entro +/- 3 idx da un
multiplo di 100**:

| | mediana di X | media di X | frazione sotto 68,0 idx |
|---|---:|---:|---:|
| S=100, D=0,5, prezzi uniformi | 50,64 | 50,56 | 0,675 |
| S=100, D=0,5, **prezzi addensati sui tondi** | **54,07** | **52,84** | 0,597 |
| S=97, D=0,5, **prezzi addensati sui tondi** | **48,01** | **48,18** | 0,701 |

> 🔴 **Conseguenza dichiarata prima dei numeri:** se l'addensamento sui tondi
> esiste davvero, il passo **100** produce bersagli in media **~12% PIU'
> LONTANI** del passo 97. Cioe' **il placebo di R130e non e' appaiato in
> distanza al 100%**: il residuo e' ~12% di distanza, ed e' **nel verso che
> favorisce il passo 100**. Si corregge con la pendenza profitto/distanza che
> misura R130c. **Non lo nascondo: lo quantifico e lo metto nella lettura.**

---

## 5. LA FRONTIERA DEL COSTO, E LE CELLE DEGENERI SCARTATE **PRIMA**

### 5.1 I tre numeri che delimitano la finestra utile
| | punti indice | da dove viene |
|---|---:|---|
| **pavimento di costo** `40 x spread` | **68,00** | 40 x 1,7000 (mediana ora server 8, 1.847.049 tick) |
| pavimento **duro** `13,3 x spread` | 22,61 | `CACCIA_TFBASSO_FREQUENZA_2026-09-06.md` par. 6.2 |
| **TP totale** (3R), oltre il quale il livello e' PRE-EMPTED | **~147,3** | 3 x stop RETEST derivato 49,1 idx (R128 par. 5.2) |
| **il controllo** (parziale a 1R) | **49,10** | = **28,9x** lo spread -> 🔴 **72% del pavimento** |

> ### 🔴 IL CONTROLLO STESSO E' SOTTO IL PAVIMENTO DI COSTO. VA DETTO PER PRIMO.
> Il parziale che gira **oggi sul conto reale 10105439** chiude meta' posizione
> a **28,9 volte lo spread**, contro un pavimento di lavoro di 40x. **Non e'
> una colpa dei livelli tondi: e' lo stato della sedia viva**, gia' agli atti in
> R128 par. 5.2. Ogni confronto di R130 e' quindi **fra due configurazioni di
> cui almeno una e' sotto costo**, e nessuna cella si propone senza il suo
> rapporto stop/spread accanto.

### 5.2 🎯 LA CONDIZIONE PER UNA CELLA "PULITA", derivata prima di girare
Perche' **OGNI** bersaglio di una cella superi il pavimento e **NESSUNO** sia
scavalcato dal TP totale servono, insieme:
```
    D >= 68,0            (minimo di X sopra il pavimento di costo)
    D + S <= 147,3       (massimo di X dentro il TP totale)
=>  S <= 79,3 punti indice,  con D = 68,0
```
👉 **La finestra pulita esiste, ed e' `D = 6800 punti MT5` con `S` fra 10 e 79
punti indice.** E' non vuota **perche' lo stop della sedia supera 13,3x lo
spread** (`3 x stop > 40 x spread` <=> `stop > 13,3 x spread`: 28,9x > 13,3x).
**Su una sedia sotto il pavimento duro questa finestra sarebbe VUOTA e il round
non si potrebbe nemmeno scrivere.** E' un cancello che ho controllato prima.

### 5.3 LE CELLE DEGENERI, SCARTATE PRIMA DI GIRARLE
Il brief chiede di calcolare in anticipo **dove cade il livello** e di buttare
le celle degeneri. Due forme di degenerazione, con la soglia congelata ora:

- **DEGENERE PER COSTO** -- l'intera cella sta sotto 68,0 idx (`D + S <= 68`).
  Esempio: `S=25, D=50pt(0,5 idx)` -> X ~ U(0,5 ; 25,5), **il 100% dei bersagli
  sotto costo**, media 13,0 idx = **7,6x** lo spread. 🔴 **E' esattamente il
  difetto del trade 2 di Claudio dell'11/09: +0,57 $ = 2,8x il costo.**
  ❌ **Nessuna cella di R130 ha `D + S <= 68`. Verificato cella per cella.**
- **DEGENERE PER CAMPIONE** -- il parziale scatta su **meno di 30 ingressi**
  attesi (soglia dei 30 gia' di casa, `R84_ABLAZIONE_CRITERI.md` par. 5).
  ❌ **Escluse per questo motivo, prima di girarle, le celle
  `InpRoundMinDistPts` = 12000 (120 idx, ~12 parziali attesi)** e ogni cella
  con `D >= 120` idx. L'asse di R130d si ferma a **10000**.

**La stima del numero di parziali viene dal par. 8. E' una STIMA, marcata come
tale ovunque compaia.**

---

## 6. LA GRIGLIA -- 5 file, 29 celle, 58 passate

**Una variabile per file** (`controlla_prova.py` lo impone). Tutto il resto
pinnato **per nome** sulla cella viva RETEST long-only, **col parziale ACCESO**.

| file | asse | celle | pin chiave | magic |
|---|---|---:|---|---:|
| **R130a** | `InpUseRoundLevels` **0/1** | **2** | `Step=100` `MinDist=50` = **i default compilati** | 779830 |
| **R130b** | `InpUseRoundLevels` **0/1** | **2** | `Step=25` `MinDist=6800` = **la cella pulita di costo** | 779880 |
| **R130c** | `InpRoundStep` **10 -> 100** passo 10 | **10** | `MinDist=6800`, `UseRoundLevels=1` | 779890 |
| **R130d** | `InpRoundMinDistPts` **0 -> 10000** passo 2000 | **6** | `Step=100`, `UseRoundLevels=1` | 779900 |
| **R130e** | `InpRoundStep` **96 -> 104** passo 1 -- 🎯 **IL PLACEBO** | **9** | `MinDist=50`, `UseRoundLevels=1` | 779980 |

### 6.1 Perche' PROPRIO QUESTO PASSO, e non un altro -- scritto prima
Il brief chiede di scegliere il passo **con la testa**. Tre ancore, tutte con
un numero e una fonte, nessuna scelta a occhio:

1. **L'ampiezza del movimento della sedia.** Stop RETEST derivato **49,1 idx**;
   range del setup di 35 minuti **~46 idx** (= stop - 3, dalla geometria
   `stop = range + buffer - offset`); TP totale **~147 idx**. La banda che ha
   senso per un PRIMO obiettivo sta **fra il pavimento di costo (68) e il TP
   totale (147)**. Il passo va scelto perche' `X = U(D, D+S)` cada li' dentro.
2. **La frontiera del costo**, par. 5.2: `S <= 79,3` con `D = 68`.
   -> **l'asse di R130c si ferma a 100**, appena oltre, per **vedere il bordo
   invece di appoggiarcisi** (regola di R118c: la frontiera dentro la griglia).
3. **I valori che la casa ha gia' scritto**, con data: `InpRoundStep` nei
   preset del repo vale **50,0** (`ABTG_DAX_Apertura_EU_LEGACY_2pct.set`,
   `ABTG_DAX_Live5m.set`) e **100,0** (`conto_reale/..._770101_REALE.set`,
   `ABTG_Nasdaq_GapFill.set`, `..._Dow_Apertura_US_..._100K.set`).
   **Tutti e due stanno dentro l'asse 10-100 di R130c.**

🔑 **E c'e' una lettura in piu' dell'asse del passo, che lo rende molto piu'
informativo di "provo qualche numero":**
> **`S -> 0` fa degenerare il meccanismo in un TP1 a DISTANZA FISSA di `D`
> punti indice.** Cioe' l'asse di R130c e' un **continuo** da *"parziale a
> distanza assoluta fissa"* (S=10: X ~ U(68 ; 78), quasi un punto) a *"livelli
> tondi veri"* (S=100). **E la distanza assoluta fissa in punti indice non
> esiste come input in questo EA**: R130c e' l'unico modo di misurarla senza
> toccare il codice.

### 6.2 Perche' `InpRoundMinDistPts` e' la manopola che decide tutto
Siccome `X >= D` **sempre, per costruzione**:
> ## 🎯 `InpRoundMinDistPts >= 6800` (= 68,0 idx) e' la condizione **NECESSARIA E SUFFICIENTE** perche' **ogni** bersaglio della cella superi il pavimento `40 x spread`.
Nessun valore del passo puo' sostituirla: con `D` piccolo la distribuzione
scende sempre fino a `D`, qualunque sia `S`. **Per questo R130d esiste, e per
questo la scala 0/2000/4000/6000/8000/10000 punti MT5 e' la stessa di R118c --
incastra la frontiera fra la cella 6000 (60 idx) e la cella 8000 (80 idx).**

### 6.3 🎯 R130e, IL PLACEBO -- il pezzo piu' importante del round
Nove celle, `InpRoundStep` da **96 a 104**, `MinDist` al default.

| | passo 100 | gli altri otto (96-99, 101-104) |
|---|---|---|
| i punti della griglia sono numeri tondi? | 🟢 **il 100%** (sono TUTTI multipli di 100) | 🔴 **fra l'1% e il 4%** |
| geometria di `X` | U(0,5 ; 100,5), media **50,5** | U(0,5 ; 96,5..104,5), media **48,5 - 52,5** |

**La contaminazione, contata e non stimata**: nella banda DAX 18.800-25.900 i
multipli di 96 che sono anche multipli di 100 sono 19.200 / 21.600 / 24.000 =
**3 su ~74 punti di griglia (4%)**; per 104 sono 20.800 / 23.400 = **2 su ~68
(3%)**; per i passi coprimi con 100 (97, 99, 101, 103) e' **1 solo**.

> ### 🔥 PERCHE' VALE PIU' DI TUTTO IL RESTO
> Le nove celle hanno una geometria **statisticamente indistinguibile** (la
> media di `X` varia del **+/- 4%** da un capo all'altro), ma **una sola e' un
> livello umano.** Quindi:
> - se il passo **100 sporge** dalla retta che passa per i suoi otto vicini
>   -> 🟢 **il livello tondo conta**, e non e' "un TP a distanza variabile";
> - se il 100 **sta dentro la banda degli otto** -> 🔴 **il livello non conta**,
>   il meccanismo e' solo *"un TP a distanza casuale"*, e questo round chiude
>   la casella **con un numero**;
> - e **gli otto vicini misurano il RUMORE di questo asse**, che e' l'unica
>   cosa che rende leggibili R130a/b/c/d. Senza R130e, qualunque differenza
>   osservata altrove non ha un metro.

---

## 7. LE ATTESE, SCRITTE PRIMA DEI NUMERI

> ### 🔴 L'ATTESA GENERALE, e va letta per prima:
> **Mi aspetto che il default vinca**, cioe' che `InpUseRoundLevels=0` non sia
> battuto in modo leggibile. Ragione: il parziale a 1R **si adatta al range
> della giornata** (stop = range + 3 idx), mentre il livello tondo **non sa
> niente della volatilita' del giorno**. In una mattina stretta il tondo e'
> lontanissimo, in una mattina larga e' addosso all'ingresso.
> **Se la misura mi dara' torto, tanto meglio: e' una manopola nuova con 5.068
> passate di archivio dietro e zero misure. Ma l'attesa e' questa, ed e'
> scritta prima.**

| file | attesa | cosa la FALSIFICA |
|---|---|---|
| **R130a** | le due celle **entro il 5%** su Profit e PF: a distanza media appaiata (50,5 contro 49,1 idx, **+2,9%**) il piazzamento non conta | la cella **1** batte la **0** di **>= +10%** di Profit a DD non peggiore, **E** il passo 100 sporge in R130e |
| **R130b** | la cella **1** fa **meno parziali** (attesi ~64 contro 120) e quindi assomiglia alla cella "parziale spento" di R128b: Profit **piu' alto**, DD **piu' alto** | la cella 1 fa Profit piu' alto **E** DD non peggiore -> il parziale lontano e pulito di costo e' meglio del parziale vicino e sotto costo |
| **R130c** | **monotona**: profitto in salita e DD in salita col passo, perche' il passo grande = bersaglio lontano = meno parziali = piu' vicino a "niente parziale" | un **massimo interno** (una cella che batte sia S=10 sia S=100) -> esiste un passo ottimo e non e' un effetto di sola distanza |
| **R130d** | **monotona**, stessa ragione, piu' ripida di R130c (la distanza minima muove `X` uno-a-uno) | idem. E se il **DD** non peggiorasse salendo, il parziale lontano e' gratis |
| **R130e** | 🎯 **nove celle su una retta dolcemente decrescente**, il 100 **dentro** la banda | il **100 sporge** dalla retta dei suoi otto vicini di piu' dello scarto fra i vicini stessi |

🔴 **E la regola che vale piu' di tutte: se il guadagno di una cella sta dentro
la banda misurata dagli otto placebo di R130e, la risposta onesta e' "IL
DEFAULT VA BENE", ed e' un RISULTATO, non un fallimento.**

---

## 8. 🧪 LA MISURA DELL'ADDENSAMENTO -- e il contro-esempio che la salva

Il brief chiede una misura dell'addensamento delle uscite vicino ai tondi.
**Eccola, e non costa una passata in piu'.**

### 8.1 La definizione, congelata ora
Con il parziale acceso, MT5 conta la chiusura parziale come **una riga in piu'**
nella colonna `Trades`. Gli ingressi sono **invarianti = 325** sull'intera
finestra (R120, misurato in 4 strutture d'uscita su 4). Quindi:

> ## **`tasso di tocco = (Trades_totale - 325) / 325`** = la frazione di ingressi che ha RAGGIUNTO il bersaglio

| | tasso di tocco |
|---|---:|
| **cella di controllo** (parziale a 1R = 49,10 idx) | **120 / 325 = 36,9%** 🟢 **MISURATO** (R120: 445 - 325) |

### 8.2 🛑 E QUI IL CONTRO-ESEMPIO, che e' il motivo per cui questo paragrafo esiste
> **"Se il livello non contasse niente e fosse solo un TP a distanza variabile,
> quale forma vedrei?"**

**La risposta ingenua e SBAGLIATA sarebbe: "vedrei lo stesso 36,9%".** 🔴 **NO.**
Il tasso di tocco a distanza `x` e' una funzione di sopravvivenza `T(x)`, ed e'
**convessa**. Per la disuguaglianza di Jensen, `E[T(X)] > T(E[X])` quando `X` e'
sparpagliata: **una cella con la STESSA distanza media ma variabile tocca di
PIU', anche se i livelli non contano assolutamente niente.**

Quantificato, calibrando `T(x) = exp(-x/lambda)` sull'**unico punto misurato**
che abbiamo (`T(49,10) = 36,9%` -> `lambda = 49,28 idx`) e mostrando una banda
`lambda` = 40 / 49,28 / 65:

| cella | X | media | **tasso di tocco ATTESO SOTTO L'IPOTESI NULLA** |
|---|---|---:|---|
| **controllo 1R** | fisso 49,10 | 49,1 | **36,9% (misurato)** |
| **R130a ON** | U(0,5 ; 100,5) | 50,5 | 🔴 **36,3 - 50,7%, centrale 42,4%** |
| R130b ON (S=25, D=68) | U(68 ; 93) | 80,5 | 13,6 - 29,2%, centrale **19,7%** (~64 parziali) |
| R130c S=10 | U(68 ; 78) | 73,0 | 16,2 - 32,6%, centrale **22,8%** (~74 parziali) |
| R130c S=100 | U(68 ; 168) | 118,0 | 6,7 - 17,9%, centrale **10,8%** (~35 parziali) |
| R130d D=0 | U(0,5 ; 100,5) | 50,5 | 36,3 - 50,7%, centrale **42,4%** |
| R130d D=10000 | U(100 ; 200) | 150,0 | 3,0 - 11,0%, centrale **5,6%** (~18 parziali) |

> ### 🔴 ECCO IL NUMERO CHE MI AVREBBE FATTO CERTIFICARE IL FALSO
> **Sotto l'ipotesi che i livelli NON contino niente, la cella di R130a dovrebbe
> comunque toccare il ~42% contro il 36,9% del controllo: +15% relativo, TUTTO
> di Jensen.** Se vedessi 42% e scrivessi *"i tondi sono calamite!"*, avrei
> scambiato una disuguaglianza matematica per un fatto di mercato.
> **La soglia non e' 36,9%. La soglia e' 42,4% con la sua banda.**

### 8.3 E il rimedio vero: **il placebo rende il modello non necessario**
La stima sopra ha **UN solo punto di calibrazione** e una forma esponenziale
scelta da me: **e' una STIMA, e la banda 36,3-50,7% e' larga quanto l'effetto
che vorrei misurare.** 🔴 **Da sola non decide niente.**
Le nove celle di R130e hanno **la stessa distribuzione di `X`** (media 48,5-52,5)
e quindi **la stessa correzione di Jensen**: i loro tassi di tocco **SONO**
l'ipotesi nulla, misurata invece che modellata. Sotto il modello, i nove tassi
vanno da **43,6% (S=96) a 41,2% (S=104)**: una retta dolce, **ampiezza 2,4 punti
percentuali su tutto il file**.
> 🎯 **Il test, congelato adesso: il tasso di tocco del passo 100 si confronta
> con la RETTA DI REGRESSIONE dei suoi OTTO vicini, non col 36,9% e non col
> 42,4% del modello. Se lo scarto del 100 dalla retta supera il massimo scarto
> degli altri otto, l'addensamento sui tondi e' MISURATO. Altrimenti non c'e'.**

### 8.4 Le tre storie si distinguono, e serve la tabella
| | i tondi sono **CALAMITE** | i tondi sono **BARRIERE** | i tondi **non contano** |
|---|---|---|---|
| tasso di tocco del 100 vs retta dei vicini | 🟢 **sopra** | 🔴 **sotto o uguale** | dentro banda |
| Profit della cella 100 vs vicini | uguale | 🟢 **sopra** (esci al posto giusto) | dentro banda |
| R130a cella 1 vs cella 0 | tocco su, Profit ~ | tocco ~, Profit su | tutto dentro il 5% |

**Le tre righe danno TRE combinazioni di segni diverse e non esiste un
parametro che le faccia coincidere**, perche' il tasso di tocco e il profitto
per parziale sono due colonne indipendenti dello stesso CSV.

---

## 9. LE SOGLIE, CONGELATE ORA

- **G0 -- ANCORA (fatale, per file).** La cella `InpUseRoundLevels=0` di R130a
  (e, in R130c/d/e, la corsa nel suo insieme) deve riprodurre la cella R120
  **parziale 50 / PREVBAR / trailing ON / BEatTP1 1 / BEatR 0**, misurata il
  09/09 a tick reali sulla finestra piena:
  **`Trades 445 | Profit +2.207,74 | PF 1,29574 | DD 6,8866%`**
  (`risultati_prove/gestione_20260909/gestione_ABTG_DAX_Apertura_EU_D30EUR_gestione.csv`,
  righe con `InpMagic` 770101 e 770151, **identiche fra loro**).
  🔴 Quella corsa e' a **finestra piena senza split**: la tolleranza e' sul
  **TOTALE**, non per finestra:
  `n(IS)+n(OOS)` fra **440 e 450** e `Profit(IS)+Profit(OOS)` entro **+/- 5%**
  di 2.207,74. **Fuori: il round si ferma PRIMA di leggere altro.**
- **G1 -- ⚠️ QUI `Trades` NON E' UN CANCELLO, E' LA MISURA.** In R128b `Trades`
  doveva restare identico fra le celle. **In R130 DEVE cambiare**: e' il tasso
  di tocco (par. 8). Il cancello di invarianza si sposta sugli **ingressi**, che
  non sono in colonna: si ricavano come `Trades - parziali` e **valgono 325 in
  totale in ogni cella, per costruzione** (`InpOneTradePerDay` + `InpCloseAtEnd`
  fissano gli ingressi, l'uscita non li tocca). 🔴 **Se in qualche cella
  `Trades` scendesse sotto 325 in totale, qualcosa sta toccando gli INGRESSI e
  il round si ferma.** E' il canarino, ed e' gratis.
- **G2 -- CAMPIONE.** Il merito si legge sopra **150 INGRESSI**, non 150 righe
  `Trades`. A `-FrazioneIS 0.50`: **IS ~163 / OOS ~162** ingressi (R128 par. 4.1)
  -> tutte e due sopra, **con margine sottile (+8%)**, e va scritto ogni volta.
  🔴 Per il **sotto-campione dei parziali** la soglia e' **30 eventi**: sotto,
  il merito di quel parziale e' **sospeso** (vale per R130d cella 10000).
- **G3 -- RISCHIO (a qualunque n, Emendamento B).** DD OOS **> 10,00%** al
  rischio 1% -> cella **scartata secca**.
- **G4 -- MERITO.** PF OOS **>= 1,10**.
- **G5 -- ALTOPIANO, MAI IL PICCO.** Si propone una cella **solo** se i suoi due
  vicini sull'asse passano anch'essi G3 e G4. Sui bordi basta il vicino che c'e',
  e va scritto che e' un bordo. 🔴 **R130a e R130b hanno 2 celle: NON HANNO
  ALTOPIANO PER COSTRUZIONE e da soli non possono promuovere niente.** L'altopiano
  lo danno R130c e R130d.
- **G6 -- PER SPOSTARE LA CELLA VIVA servono tutte e tre** (regola dell'08/08):
  **(a)** Profit OOS **>= +10%**; **(b)** DD OOS **non peggiore**;
  **(c)** vicini sull'asse anch'essi migliori della cella viva.
- **G7 -- SEGNO DELLA CORRELAZIONE.** Spearman IS->OOS sul profitto **negativo**
  -> **non si sceglie niente sull'IS**. Su questa sedia e' gia' successo (08/08,
  Spearman **-0,44**, negativo in tutte e cinque le righe TF): **e' il caso base.**
- **G8 -- COSTO.** Una cella e' **schierabile** solo se `InpRoundMinDistPts >=
  6800` (= 68,0 idx = 40,0x lo spread mediano dell'ora 8). 🔴 **Sono FUORI per
  costo, dichiarate prima: tutta R130a (ON), tutta R130e, e le celle 0 / 2000 /
  4000 / 6000 di R130d.** Restano in griglia **solo per leggere la forma e il
  rumore**, esattamente come le celle sotto 6.800 di R128c. **Nessuna di loro
  puo' essere proposta, nemmeno se e' la piu' verde.**
- **G9 -- IL PLACEBO COMANDA.** Nessuna differenza di R130a/b/c/d si dichiara
  reale se e' **piu' piccola dello scarto massimo fra gli otto vicini di
  R130e**. Se R130e non gira, le altre quattro **non hanno un metro** e i loro
  numeri si leggono come **screening**.
- **G10 -- UN NUMERO OHLC NON E' UN VERDETTO.** Tutto il round e' `-Modello 4`
  (tick reali). A Modello 1 quei numeri sono screening e basta.

---

## 10. IL COSTO IN TEMPO MACCHINA

Calibrazione **misurata**: R88a = 48 celle x 2 finestre = **96 passate in 8,0
minuti** a tick reali, M5, 21 mesi
(`risultati_archivio/r88_csv/REFERTO_R88.txt`) -> **5,0 s a passata**.
Sovraccarico per corsa (compilazione + avvio + due `.ini`): **~0,4 min**.

| file | celle | passate | x 5,0 s | + avvio |
|---|---:|---:|---:|---:|
| R130a | 2 | 4 | 0,3 min | 0,7 min |
| R130b | 2 | 4 | 0,3 min | 0,7 min |
| R130c | 10 | 20 | 1,7 min | 2,1 min |
| R130d | 6 | 12 | 1,0 min | 1,4 min |
| R130e | 9 | 18 | 1,5 min | 1,9 min |
| **TOTALE** | **29** | **58** | **4,8 min** | **~6,8 min** |

**Banda dichiarata: 6-13 minuti** sul terminale di backtest (`C:\MT5_Backtest`,
demo **50504400**, zero EA attaccati). La calibrazione viene da **U30USD**:
**il numero vero si misura col primo giro.**

🔑 **Ordine di lancio consigliato, e il perche':**
**R130a per primo** (4 passate) -- e' il **cancello dell'ancora**: se la cella
`InpUseRoundLevels=0` non riproduce i 445 / 2.207,74 / 1,29574 / 6,8866%, il
round si ferma li' e si sono spese **20 secondi**, non sette minuti.
Poi **R130e** (il metro), poi R130c, R130d, R130b.

---

## 11. I BUCHI, DICHIARATI

1. 🔴 **`InpRoundMinDistPts` in R130d va da 0 a 10000 punti MT5, ma il PASSO
   resta 100 idx**: le celle alte hanno bersagli medi di 130-150 idx, cioe'
   **oltre il TP totale (147,3)**. Sono li' per incastrare la frontiera, non
   per essere promosse. **Il vero angolo pulito (D=6800, S piccolo) lo misura
   R130c, non R130d.**
2. 🔴 **Il placebo esiste solo al pin "sporco" (`MinDist=50`).** Se R130e dicesse
   che il tondo conta, la conferma al pin pulito (`MinDist=6800`) sarebbe **un
   R131 da 18 passate**, e non e' in questo round.
3. 🔴 **La META' "stop sul livello" del metodo di Claudio NON ESISTE nel codice**
   (par. 0.1). R130 misura una meta' di una meta'.
4. 🔴 **`Emendamento C` (prova di regime) NON e' eseguibile**: i tick BCM sugli
   indici partono dal **2024.09.26**. Niente orso 2022, niente crollo 2020.
   **R130 valida la geometria dell'uscita, mai la robustezza di regime.**
5. 🔴 **Lo stop RETEST di 49,1 idx e' DERIVATO dal codice su n=2 gambe**, non
   misurato in campo (R128 par. 5.1: le 7 gambe di stop in campo sono **tutte**
   del ramo ROTTURA, spento dal 14/08). Tutti i conti di costo di questo
   documento ereditano quel `[DERIVATO, n=2]`.
6. 🔴 **Il tasso di tocco atteso e' una STIMA a un punto di calibrazione.**
   Serve a scartare le celle degeneri **prima**, non a giudicare dopo. Il
   giudizio lo da' R130e.
7. 🟠 **`ABTG_Dow_Apertura_US` (770202, U30USD) ha la stessa manopola e nessun
   conteggio di ingressi invariante misurato.** E' il candidato naturale di
   R131 e va segnalato a Claudio: **e' un buco che si chiude con 4 passate**
   (una corsa `InpTP1_ClosePct` 0/50 sulla sua geometria viva).

---

## 12. COSA NON E' IN GRIGLIA, E QUANTE PASSATE RISPARMIA
- `InpTP1_R`: e' l'asse di **R128b**, e li' gira **col parziale spento**. Qui il
  parziale DEVE essere acceso (par. 0.1): i due round non si sovrappongono e
  **non si ricompra niente**. *(-14 passate)*
- `InpTP1_ClosePct` 0/50: misurato il 09/09 (R120, tick reali, 4 strutture
  d'uscita). **A 0 questo round non esisterebbe.** *(-4 passate)*
- `InpTrailMode` / `InpTrailTF` / `InpTrailStartR` / `InpBEatR` /
  `InpBreakevenAtTP1`: tutte gia' ad asse su questa sedia (R128 par. 1).
  🔴 **Ma `InpBreakevenAtTP1` va guardato nel referto anche senza essere ad
  asse**, perche' R130 **lo muove di riflesso**: il BE vive dentro il blocco del
  parziale. Numero gia' misurato da R120 sulla finestra piena:
  **BEatTP1=0 -> 2.329,60 ; BEatTP1=1 -> 2.207,74. Il breakeven al primo
  obiettivo COSTA 121,86 EUR (-5,2%).** Spostare il bersaglio sposta anche
  quello, e il referto deve dirlo.
- `InpSLMode` / `InpBufferPoints` / `InpRetestOffsetPts`: **non si toccano**,
  altrimenti cambia lo stop iniziale, cambia `riskDist`, e il confronto col
  parziale a 1R non vuol piu' dire niente.
