# R126 -- SUPERWAVE DOW H1 DENTRO LA FRONTIERA DEL COSTO -- CRITERI CONGELATI

> **Questi criteri si leggono PRIMA dei numeri. Data: 10/09/2026.**
> Se un numero di questo round viene letto senza questa pagina davanti, non
> vuol dire niente. Regola di casa, non formalita'.
>
> **STATO: NON FIRMATO.** Nessuna cella di R126 e' mai girata (verificato:
> nessun CSV `r126*` nel repo). La firma e' di Claudio, non mia.
>
> **QUESTO FILE E' IN ASCII PURO, APPOSTA -- e l'ho VERIFICATO, non
> supposto.** Classe 202 (10/09): su un `.md` pieno di emoji
> `controlla_riga.py` produce solo falsi positivi. Provato adesso su questa
> pagina: `python3 backtest_pipeline/controlla_riga.py --ps1 <questo file>`
> -> **4 PASS, zero difetti** (`ASCII puro`, `nessun costrutto pwsh-7-only`,
> `formati .NET`, `nessun Parse decimale senza cultura invariante`).
> **Correzione di una cosa che stavo per scrivere senza controllarla:** il
> difetto della classe 202 non e' che lo strumento "esce FAIL con 8
> bloccanti" su un `.md` -- **lo strumento non ha proprio un modo per i
> `.md`**: accetta solo `--riga` e `--ps1` (r.515-516) e su un percorso
> posizionale muore con `unrecognized arguments`. Scritto in ASCII, il `.md`
> passa dalla porta `--ps1` e i controlli meccanici girano davvero.
> Non e' un cambio di stile di casa: le emoji restano nei referti e nei
> messaggi in chat.
>
> **E UN AVVISO CHE MI SONO GUADAGNATO SBAGLIANDO, DIECI MINUTI FA.** Ho
> provato la stessa porta `--ps1` sui QUATTRO file prova `.txt` di questo
> round: **ESITO FAIL su tutti e quattro**, difetto `[PWSH7] operatore doppia
> pipe (pwsh 7)`. **E' un falso positivo al 100%**: la doppia pipe di un file
> prova e' il separatore della sintassi dell'asse (i cinque campi
> `valore` / `start` / `passo` / `stop` / `Y`), non un operatore PowerShell.
> `--ps1` su un file prova e' **lo strumento sbagliato**: il
> controllo giusto per un `.txt` di `prove/` e' **`controlla_prova.py`**, che
> su questi quattro file esce **OK, 0 problemi, 27 celle, 54 passate**.
> Lo scrivo qui perche' chiunque rifara' questo giro cadra' nella stessa
> buca, e vedra' quattro FAIL rossi su file che sono a posto.
> *(E questa pagina non nomina mai la doppia pipe per esteso, apposta:
> alla prima stesura la nominava, e si auto-bocciava.)*

---

## 0. LA DOMANDA DEL ROUND, in una riga

**Esiste un valore di `InpSLBufferAtr` che porta `SuperWave_DOW_H1` (magic
770511, U30USD H1) DENTRO la frontiera del costo `stop >= 40 x spread
misurato all'ora in cui la sedia opera davvero, SENZA restituire il merito
che ha gia'?**

Non e' "quale buffer fa il PF piu' alto". Il PF piu' alto lo conosciamo gia'
(1,52 su n=227, real-tick, 9/9 combo positive) e non e' mai stato il problema.

---

## 1. PERCHE' L'ALLARGAMENTO E' LEGITTIMO -- il numero, non l'opinione

La regola del 19/08 vieta di infittire la griglia dei parametri di un motore
**gia' dichiarato senza edge**. Questo motore non lo e', e il numero e' questo:

| misura | valore | fonte |
|---|---|---|
| PF real-tick, finestra piena | **1,52140** | `risultati_archivio/SuperWave/valid_SuperWaveRT_U30USD_H1_realtick.csv` |
| DD %, stessa riga | **4,0151** | idem |
| n, stessa riga | **227** | idem |
| combo positive della griglia 3x3 (StMult x TP_RR) | **9 su 9** | idem, tutte e nove le righe con Profit > 0 |
| PF IS / OOS separati (tick) | **1,84892 (n 84) / 1,32770 (n 143)** | `risultati_prove/ABTG_SuperWave_DOW_H1_Ottimizzato/..._U30USD_{IS,OOS}.csv` |
| DD IS / OOS (tick) | **3,7267% / 3,9082%** | idem |

**84 + 143 = 227**: la finestra piena e la coppia IS/OOS partizionano gli
stessi trade. Verificato, non assunto.

E l'allargamento e' su una manopola **MAI messa ad asse**, non su una gia'
spremuta: `grep -rl InpSLBufferAtr` su tutto il repo trova **zero CSV di
SuperWave** che la contengano (l'input e' nato il 17/08 col commit `7f80a87`,
dopo la fase 0 dell'08/08 che ha prodotto tutti i CSV di questo EA).
In **ogni** passata archiviata di questo motore vale `InpSLBufferAtr = 0` e
`InpSLBufferPips = 3`, che su U30USD (`Digits=2`, `PipSize()` torna `_Point`)
vale **0,03 punti indice**: la manopola dello stop e' stata **inerte in tutte
le corse della sua vita**.

---

## 2. IL CANCELLO DEL COSTO, RIFATTO DA ZERO -- e correggo il 38,5x in TUTTE E DUE le direzioni

`report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` da' a `770511` **38,5x**, cioe' il
96% del pavimento. Il brief chiedeva di aprirlo invece di ereditarlo. Aperto:
**quel numero e' sbagliato da tutte e due le parti, e le due correzioni tirano
in verso opposto.**

### 2.1 Il NUMERATORE (lo stop) e' un LIMITE INFERIORE -- e ora c'e' anche la misura ESATTA

Il 77,1 del referto e' la mediana di **4 gambe chiuse in stop e in perdita**
(12,70 / 55,70 / 98,50 / 98,70). Riprodotto al centesimo da `trades_auto.csv`.
Ma lo stop letto **alla chiusura** e' quello del momento in cui e' stato
colpito: il trailing sul Supertrend (r.341) e il breakeven (r.331) lo
**stringono**, mai lo allargano. Quindi 77,1 e' un **limite inferiore**.

**LA MISURA ESATTA, MAI FATTA PRIMA, ED E' GRATIS.** Nel codice il TP e'
posato a `entry +/- risk * InpTP_RR` (r.256) con `InpTP_RR = 3.0`, e la gamba
pendente ha `tpP = px +/- risk*InpTP_RR` (r.281), cioe' **3R dal proprio
prezzo d'apertura**. Quindi su ogni posizione chiusa **in TP**:

> **stop INIZIALE = |chiusura - apertura| / 3, esatto per costruzione.**

Applicato alle 3 posizioni di `770511` chiuse in TP (6 gambe, e le due gambe
di ogni posizione danno lo **stesso** numero al centesimo -- e' la verifica
interna del metodo):

| data | gamba 1/3 | gamba 2/3 | stop iniziale |
|---|---:|---:|---:|
| 2026.07.29 | 165,00 | 165,00 | **55,00** |
| 2026.08.31 | 513,90 | 513,90 | **171,30** |
| 2026.09.07 | 514,50 | 514,50 | **171,50** |

**Mediana degli stop iniziali ESATTI: 171,30 punti indice** (n=3).

**E l'identita' si auto-verifica TRE VOLTE, non una.** Su tutte e tre le
posizioni: (i) la gamba pendente si apre **esattamente 0,20 punti indice**
sotto la gamba a mercato -- che e' `InpPendingPips 20 x PipSize()` con
`PipSize()` = `_Point` = **0,01** su U30USD (r.123-127, `Digits`=2): la
"distanza di 20 pip" del documento vale **0,20 punti indice**, ed e' la prima
volta che questa inerzia e' confermata **da dati di campo** e non dedotta dal
codice; (ii) la distanza di TP delle **due** gambe di ogni posizione e'
identica al centesimo (165,00/165,00 - 513,90/513,90 - 514,50/514,50), come
impone `tpP = px +/- risk*InpTP_RR` con lo stesso `risk`; (iii) i tre valori
divisi per 3 danno numeri regolari. **Se avessi sbagliato a leggere una di
queste tre righe di codice, almeno uno dei tre controlli non tornerebbe.**

**IL CONTRO-ESEMPIO, costruito prima di usarlo.** Il sottocampione "chiuse in
TP" e' selezionato, e la selezione tira in **due** versi opposti:
- (a) un TP a 3R e' **piu' lontano in punti** quanto piu' lo stop e' largo,
  quindi e' **piu' difficile** da raggiungere -> il sottocampione TP dovrebbe
  essere sbilanciato verso gli stop **STRETTI** -> 171,30 sarebbe una
  **SOTTOSTIMA**;
- (b) uno stop largo viene colpito meno, quindi il trade **vive di piu'** e ha
  piu' tempo per arrivare al TP -> sbilanciamento verso gli stop **LARGHI** ->
  171,30 sarebbe una **SOVRASTIMA**.
**Quale dei due domini e' [NON MISURATO].** E c'e' un terzo confondimento che
va detto perche' e' vistoso: **le 3 posizioni in TP sono tutte SHORT e le 3 in
stop sono tutte LONG.** Con n=3 e n=4 questo non e' un campione: e' un indizio.

**QUINDI, e questa e' la riga che conta:**

> **lo stop iniziale di `770511` non e' 77,1 e non e' 171,3: e' una FORBICE
> [77,1 ; 171,3], con 77,1 dimostrato limite inferiore e 171,3 misurato
> esattamente su n=3.** Ogni numero di costo di questo round si scrive
> **all'angolo pessimista (77,1)**, e la sensibilita' all'altro angolo si
> stampa accanto. Mai la media dei due.

### 2.2 Il DENOMINATORE (lo spread) e' preso all'ora SBAGLIATA -- e in verso favorevole

Il referto usa la riga **`TUTTO`** di `spread_orario_U30USD.csv` (mediana
**2,00**), motivandolo con "ora sparsa 03-20, nessuna moda". Ma la regola di
casa (R125 par.2) dice **"lo spread si legge all'ORA in cui la sedia opera
davvero"**, e "non c'e' una moda" non vuol dire "usa la media di giornata":
vuol dire **usa la distribuzione delle ore che la sedia usa davvero**.

Ore di apertura delle 8 posizioni di `770511` (ora server) e mediana di
quell'ora, dai 64,7 milioni di tick del file:

| ora | 3 | 4 | 5 | 6 | 8 | 11 | 17 | 20 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| mediana | 2,70 | 2,70 | 2,70 | 2,70 | 2,60 | 2,60 | 1,90 | 1,90 |
| P95 | 3,00 | 3,00 | 3,00 | 3,00 | 3,00 | 3,00 | 2,00 | 2,00 |

**Mediana delle otto = 2,65. Mediana dei P95 = 3,00.**

**IL CONTRO-ESEMPIO, cioe' L'IPOTESI ALTERNATIVA, misurata invece che
evocata.** Otto posizioni sono poche. Ma esiste una seconda strada che non usa
i trade veri per niente: **l'ingresso e' un incrocio EMA14 x EMA200 sulla barra
H1 chiusa (r.191-205), che non ha nessuna preferenza per l'ora del giorno.**
Se cosi' fosse, la distribuzione oraria degli ingressi sarebbe **uniforme sulle
24 barre H1**, e il numero giusto sarebbe la mediana **non pesata** delle 24
mediane orarie:

| stimatore | come e' costruito | mediana | media |
|---|---|---:|---:|
| **A** | le 8 ore in cui la sedia ha aperto davvero | **2,65** | 2,475 |
| **B** | ipotesi alternativa: ingressi **uniformi** sulle 24 ore | **2,60** | 2,400 |
| B' | come B, tolte le ore 22-23 (quasi chiuse: 104k e 454k tick contro milioni) | **2,60** | 2,395 |
| **C** | riga `TUTTO`, pesata sui **tick** -- quella usata dal referto | **2,00** | 2,105 |

> **A e B, costruiti su dati diversi e con ipotesi opposte, cadono a 2,60-2,65.
> C sta il 23% piu' in basso.** Questa e' la prova che chiedeva la regola del
> 10/09: *"quale numero produce l'ALTRA spiegazione? se cade dentro la banda, la
> banda non misura niente"*. **Non ci cade: ci cade sopra.** Il 2,00 non e' una
> lettura alternativa dello stesso fenomeno, e' un altro fenomeno (la
> distribuzione dei **tick**, non quella dei **trade**).
> **Il cancello di R126 si congela a 2,65** -- il piu' sfavorevole dei due
> stimatori concordi.

**E un limite del CONCETTO, che vale per tutta la flotta e non solo per
questa sedia:** il pedaggio si paga **due volte**, all'ingresso e all'uscita,
e l'ora dell'**uscita** e' [NON MISURATO]. Il pavimento di casa `40x` e'
definito contro **uno** spread (R55/R125) e va lasciato cosi', altrimenti
questa sedia non sarebbe piu' confrontabile con le altre 41. Ma va scritto:
**il pedaggio vero e' circa il doppio di quello che il cancello misura, su
tutte le sedie.**

**Perche' la riga `TUTTO` sbaglia in verso FAVOREVOLE, col numero:** la riga
`TUTTO` e' pesata sui **tick**, e le ore 14-21 (cash USA) portano **44,83
milioni di tick su 64,71 = il 69%** del totale. Ma `770511` ha aperto in quella
banda **2 posizioni su 8 = il 25%**. La riga `TUTTO` descrive quasi solo le ore
americane, e questa sedia lavora quasi tutta **fuori** da quelle ore, dove il
Dow costa **il 35-42% in piu'**.

Limite dichiarato: **n = 8 posizioni**, sei settimane (27/07 - 07/09/2026),
mentre il file di spread copre 2024.09.26 - 2026.06.30. Il numero e' sottile:
la **direzione** e' strutturale (il conto sui tick qui sopra), il **valore**
2,65 e' [MISURATO SU n=8].

### 2.3 IL RISULTATO: il 38,5x non e' un numero, e' un punto dentro una forbice

| stop | / 2,00 (`TUTTO`) | / **2,65 (ore vere)** | / 3,00 (P95 ore vere) |
|---|---:|---:|---:|
| **77,1** (limite inferiore, n=4) | 38,5x | **29,1x** | 25,7x |
| **171,3** (esatto, n=3) | 85,7x | **64,6x** | 57,1x |

> **La forbice va da 25,7x a 85,7x.** Il 38,5x del referto e' una sua
> combinazione (numeratore pessimista + denominatore ottimista), non una stima
> centrale. **Il verdetto "770511 non passa il cancello del costo" NON e'
> deciso, e non lo decide questo round**: lo deciderebbe la distribuzione
> dello stop iniziale su tutte e 227 le operazioni, che oggi e'
> **[NON MISURABILE]** (par. 6, buco 2).

### 2.4 E allora perche' il round si fa lo stesso? Perche' il buffer e' ADDITIVO

Qualunque sia `stop(0)`, il buffer aggiunge una quantita' **deterministica**:

> `stop(b) = stop(0) + b * ATR(10) H1`  --  `.mq5` r.239, ramo `InpSLBufferAtr>0`

Quindi il round **non ha bisogno di sapere `stop(0)`** per dire quanto margine
di costo compra. Deve solo sapere l'ATR.

**ATR(10) H1 di U30USD = ~64,2 punti indice [INFERITO].** Strada, identica a
quella gia' usata in `R125a`: range di giornata **MISURATO** su 24 giornate
vere (`trades_auto.csv`, `session_high/low`) = **314,5** punti indice mediana,
scalato `x sqrt(60/1440)` = **64,2**.
**Controprova indipendente, cercata apposta per rompere il numero:** con
`InpStMult = 2,5` la banda del Supertrend vale `2,5 x ATR = ~160` punti
indice, e i due stop iniziali **esatti** piu' larghi misurati in campo sono
**171,30 e 171,50**. Compatibile. **Non e' una dimostrazione** (lo stop e' il
piu' protettivo fra linea ST ed estremo a 5 barre, non la banda nuda), ma un
ATR di 30 o di 130 sarebbe stato **incompatibile**, e questo il controllo lo
esclude. Banda dichiarata per la sensibilita': **50 - 90**.

---

## 3. IL COMPROMESSO, QUANTIFICATO PRIMA -- dove il buffer costa, e quanto

Il brief chiede: "il buffer allarga lo stop, quindi a rischio fisso riduce i
lotti: profitto in meno. Quantificalo PRIMA." **Letto il codice, il conto e'
piu' preciso di cosi', e in parte smentisce la frase.**

Con rischio fisso `InpRiskPercent = 1,0`, il lotto e' `risk_money / stop`
(r.394-421). Quindi, chiamando `R' = stop(0) + b*ATR`:

| esito del trade | dove sta nel codice | come cambia col buffer |
|---|---|---|
| stop pieno colpito | r.239 | perdita = `risk_money` -> **INVARIANTE** |
| TP finale a 3R | r.256 (`tp = entry +/- risk*InpTP_RR`) | guadagno = `3 x risk_money` -> **INVARIANTE** |
| parziale a 1R + pari | r.319 (`tgt = openP +/- risk*InpTP1_R`) | **INVARIANTE** |
| **uscita sul TRAILING** | r.341 (`PositionModify(tk, stLine, ...)`) | prezzo **ASSOLUTO** -> guadagno x **`stop(0)/R'`** |
| **uscita su FLIP** | r.180 (`CloseAllPositions()`) | prezzo **ASSOLUTO** -> guadagno x **`stop(0)/R'`** |

> **Il buffer NON costa sui trade che finiscono in stop o in TP: quelli sono
> in unita' di R e scalano insieme al lotto. Costa SOLO sulle uscite a prezzo
> assoluto, cioe' trailing e flip -- che in questo motore sono accese tutte e
> due per default.**

Fattore di riduzione del guadagno sulle uscite trailing/flip, `stop(0)/R'`,
ai due angoli della forbice del par. 2.3:

| `InpSLBufferAtr` | +punti idx (ATR 64,2) | fattore, angolo 77,1 | fattore, angolo 171,3 |
|---:|---:|---:|---:|
| 0 | 0,0 | 1,000 | 1,000 |
| 0,125 | 8,0 | 0,906 | 0,955 |
| 0,250 | 16,1 | 0,827 | 0,914 |
| 0,375 | 24,1 | 0,762 | 0,877 |
| **0,500** | 32,1 | **0,706** | **0,842** |
| 0,625 | 40,1 | 0,658 | 0,810 |
| 0,750 | 48,2 | 0,615 | 0,781 |
| 0,875 | 56,2 | 0,578 | 0,753 |
| 1,000 | 64,2 | 0,546 | 0,727 |

**E c'e' un secondo effetto, letto nel codice e mai scritto da nessuno.**
Il trailing riscrive lo stop a `stLine` **NUDO, senza buffer** (r.341: il
buffer compare solo in `Enter()`, r.239). Quindi:

> **Il buffer protegge solo fino al PRIMO aggiornamento del trailing.**
> Dopo, sparisce. Il beneficio "salva i trade fermati per un soffio" vale
> **solo sui perdenti rapidi**; il costo sul fattore qui sopra vale **su tutte
> le uscite trailing/flip, sempre.**

**LA RIGA DELLA RESA, congelata adesso** (il brief chiede a che punto il round
deve dire "non ne vale la pena"):

> **R126-RESA.** Se la cella scelta da `P7` ha **PF OOS < PF OOS(cella 0) -
> 0,15**, il verdetto del round e': **"il margine di costo si compra solo
> pagandolo col merito"**. Non si propone niente, si scrive il numero, e la
> sedia resta com'e' con il cancello del costo **aperto e dichiarato tale**.
> La banda 0,15 non e' scelta a caso: e' la **stessa** banda con cui `P2`
> definisce un altopiano. Se il buffer costa piu' della larghezza di un
> altopiano, non e' un aggiustamento: e' un altro motore.

---

## 4. L'ATTESA, DICHIARATA PRIMA DEI NUMERI -- e NON copiata da R118

Il brief avverte: su un ramo diverso l'attesa "DD monotono decrescente col
buffer" e' stata **misurata FALSA**. Non la copio. **La verifico su QUESTO
motore, e su questo motore c'e' gia' una misura che dice l'opposto di R118.**

**L'asse `InpStMult` di questo EA e' gia' girato** (`..._U30USD_{IS,OOS}_r3.csv`,
tick reali). `InpStMult` allarga la banda del Supertrend, cioe' **allarga lo
stop**. Ecco cosa ha fatto:

| `InpStMult` | 1,5 | 2,0 | **2,5 (vivo)** | 3,0 | 3,5 |
|---|---:|---:|---:|---:|---:|
| PF OOS | 1,60552 | 1,48377 | **1,32770** | 1,09636 | 1,18710 |
| DD OOS % | 3,2790 | 3,6658 | **3,9082** | 5,1118 | 5,0178 |
| n OOS | 165 | 153 | **143** | 143 | 134 |
| PF IS | 1,19820 | 0,95200 | **1,84892** | 1,48123 | 1,44094 |
| DD IS % | 3,5148 | 5,5837 | **3,7267** | 4,6591 | 4,7691 |

> **Su questo motore, allargando lo stop il DD OOS SALE (3,28 -> 5,11) e il PF
> OOS SCENDE (1,61 -> 1,10).** E' l'esatto contrario del "piano inclinato"
> di R118. Trasportare qui la monotonia di R118 sarebbe stato pescare.

**Il limite di questa lettura, dichiarato:** `InpStMult` cambia **due** cose --
la larghezza dello stop **e** la frequenza dei flip del Supertrend (che e'
anche il filtro d'ingresso e l'uscita su flip). E' un **confondimento**.
`InpSLBufferAtr` invece cambia **solo** lo stop iniziale: non tocca il segnale,
non tocca i flip, non tocca il livello del trailing. **Per questo l'asse di
R126 e' il buffer e non lo StMult: e' l'unico che isola la variabile.**

### 4.1 ATTESA NUMERICA, falsificabile

- **n**: quasi INVARIANTE, entro **+/- 10** su tutto l'asse. Il buffer non
  decide **se** si entra (l'ingresso e' il cross EMA14x200 a favore del
  Supertrend, r.191-205); tocca `n` **solo** di rimbalzo, perche' r.181
  (*"con posizione aperta non cerco nuovi ingressi"*) fa dipendere gli
  ingressi successivi da **quando** si esce.
  **SE `n` SI MUOVE DI PIU' DI 20 SU UNA CELLA, C'E' UN MECCANISMO CHE NON HO
  CAPITO: IL ROUND SI FERMA E SI ATTRIBUISCE PRIMA DI LEGGERE ALTRO.**
- **PF OOS**: attesa in **CALO LENTO e MONOTONO**, da ~1,33 (cella 0) a
  **1,10-1,25** a `b = 1,000`. Base: il fattore del par.3 e l'asse `StMult`
  misurato qui sopra.
- **DD OOS**: attesa in **LIEVE SALITA**, da ~3,9% a **4,3-5,5%**. Base:
  l'asse `StMult` misurato (3,28 -> 5,11 allargando lo stop).
  **Questa attesa e' l'opposto di quella di R125a/R118, ed e' fondata su una
  misura di QUESTO motore, non su un'analogia.**
- **PF IS**: attesa **1,4-1,9**, rumorosa (n IS ~79-84). Lo scrivo perche' e'
  la parte che non serve al verdetto e va detta lo stesso.
- **DD IS**: attesa **3,5-5,5%**.
- **Cella attesa**: la sceglie `P7`, non l'occhio. Il par. 4-bis eseguito in
  anticipo sulla forma attesa (par. 5.4) da' **0,625**.

### 4.2 I TRE ESITI, dichiarati adesso perche' due su tre non mi piacciono

- **E1** -- l'altopiano c'e' secondo `P1..P8`, la cella scelta passa
  `R126-RESA`: si va alla prova di regime e si scrive la riga per Claudio.
  **E1 NON schiera niente da solo**: `n OOS < 150`, quindi il MERITO resta
  SOSPESO (par. 6.1).
- **E2** -- l'altopiano non c'e' (una cella sporge, le vicine no): verdetto
  **"non c'e' una configurazione robusta"**, e non si propone niente.
- **E3** -- il PF cala piu' in fretta del previsto e `R126-RESA` scatta:
  costo e merito tirano in direzioni opposte su questo motore. Allora la
  risposta onesta e' **"il default va bene, e il cancello del costo resta
  aperto"** -- che e' un risultato, non un fallimento.

---

## 5. LE SOGLIE, CONGELATE ORA

> **I cancelli si chiamano `R126-G0..R126-G5`, col prefisso del round.**
> Il nome e' stato cercato nel repo **prima** di adottarlo (classi 190/194):
> `grep -rn "R126-G"` -> **0 righe**. `G1` nudo NON si usa mai in questo file:
> nel repo e' gia' il cancello dei gemelli/determinismo in 51 file prova, e in
> R126 quel cancello si chiama per esteso **"cancello di casa G1 (gemelli)"**
> ed e' il compito di `R126c`.

| # | cancello | soglia | perche' quel numero |
|---|---|---|---|
| **R126-G0** | **COSTO** | `stop(b) >= 40 x 2,65` = **106,0 punti indice**, valutato all'**angolo pessimista** `stop(0) = 77,1` e `ATR = 64,2` | pavimento di lavoro di casa (R55/R125), con lo spread all'ora vera (par. 2.2) |
| **R126-G0d** | **COSTO, pavimento DURO** | `stop(b) >= 13,3 x 2,65` = **35,25 punti indice** | scarto per aritmetica prima di guardare altro. **Nessuna cella lo sfonda**: il minimo dell'asse e' 77,1. Va scritto lo stesso |
| **R126-G1** | **RISCHIO** | **DD OOS <= 7,00%** | e' il numero gia' firmato in `R88_CRITERI.md` cancello A1 e riusato da `R125-G1`. Non si ammorbidisce |
| **R126-G2** | **RISCHIO, seconda finestra** | **DD IS <= 9,00%** | il rischio si legge a qualunque n (Emendamento B). Identico a `R125-G2` |
| **R126-G3** | **MERITO** | **PF OOS >= 1,10** | **e' la soglia PRE-REGISTRATA DI QUESTO EA**, scritta il 07/08/2026 nel suo file prova di fase 0 (`prove/ABTG_SuperWave_DOW_H1_Ottimizzato.txt`), testuale: *"2. Profit Factor >= 1,10 fuori campione"*. **NON e' l'1,40 di R125**: quello sta in `R88_CRITERI` ed e' la soglia dell'ORB, un altro motore con un'altra geometria. Importarla qui sarebbe stato inventare, non ereditare |
| **R126-G3b** | **NON-REGRESSIONE** | **PF OOS >= PF OOS(cella 0) - 0,15** | il round non deve barattare merito per costo di nascosto. Definito **relativamente alla cella 0 DI QUESTO ROUND**, non a un numero d'archivio: e' un criterio, non un valore |
| **R126-G4** | **CAMPIONE** | **n OOS >= 95** e **n IS >= 57** | identici a `R125-G4` (da R88). **Non sono i 150 dell'Emendamento A**: sono il pavimento di leggibilita' |
| **R126-G5** | **ALTOPIANO** | par. 5.1 + procedura `P1..P8` di `R125_ORB_COSTO_CRITERI.md` par. 4-bis | senza questo nessuna cella e' leggibile |

**Perche' `R126-G3` e' 1,10 e non 1,40, detto senza girarci intorno.** La
cella VIVA fa **PF OOS 1,32770**. Con la soglia dell'ORB (1,40) il round
boccerebbe la **propria linea di partenza**, e allora non misurerebbe piu'
niente: qualunque cella uscirebbe "non ammissibile" e il verdetto sarebbe
un artefatto della soglia importata. Con 1,10 -- che e' il numero che
**questo** motore si e' dato prima di conoscere i propri risultati -- il round
ha una domanda a cui puo' rispondere. **E per non nascondere niente: il
referto dovra' stampare accanto a ogni cella anche il confronto con 1,40**,
cosi' chi vuole la soglia dell'ORB se la applica da solo.

### 5.0-bis QUELLO CHE PASSARE `R126-G3` NON VUOL DIRE
`n OOS` atteso **~129** (banda 110-150, conto in par. 5.5), **sotto i 150** dell'Emendamento A: passare
`R126-G3` e' **"merito NON escluso"**, non "merito dimostrato". Vale la
stessa riga di `R125` classe 205, e vale qui **a maggior ragione**, perche' la
soglia e' piu' bassa.

### 5.1 LA REGOLA DI SELEZIONE -- RIUSATA, NON REINVENTATA

**Si applica alla lettera `backtest_pipeline/prove/R125_ORB_COSTO_CRITERI.md`
par. 3, 3-bis e la procedura `P1..P8` del par. 4-bis, comprese `P3-bis`,
`P5`, `P6`, `P7`, `P8` e la clausola della classe 216.** E' stata scritta il
10/09, torturata su otto griglie avversarie, riscritta da zero da un
simulatore indipendente e passata in forza bruta su 200.000 griglie casuali.
Non la riscrivo: **la cito e la eseguo.**
Vale anche il par. **4-ter**: quando par.3, par.3-bis e la procedura dicono
cose diverse, **vince la procedura `P1..P8`**.

### 5.2 GLI ADATTAMENTI, dichiarati e motivati (sono tre)

**(A) La tabella dei BORDI, riscritta per gli assi DI QUESTO round.**
Il par. 3-bis di R125 impone di elencare i bordi **per nome, asse per asse**:

| asse del round | bordo BASSO | tipo | bordo ALTO | tipo |
|---|---|---|---|---|
| `InpSLBufferAtr` (R126a, R126d) | **0** | **LIMITE FISICO** (un buffer negativo non esiste; ed e' anche la cella di RIFERIMENTO del round) | **1,000** | **FINE GRIGLIA** -- l'ho scelto io, **con una ragione aritmetica dichiarata**: a 1,000 ATR il buffer **raddoppia** lo stop e riduce al **54,6%** il guadagno di ogni uscita trailing/flip (par. 3). Oltre, il compromesso e' sfavorevole **per conto**, non per stanchezza. Resta un bordo **FINE GRIGLIA**, e `P5` lo toglie |
| `InpSLLookback` (R126b) | **1** | **LIMITE FISICO** (`iLowest(...,count,1)` con `count` 0 non esiste) | **13** | **FINE GRIGLIA** |
| `InpMagic` (R126c) | -- | **ASSE TECNICO** | -- | **ASSE TECNICO** |

**`R126c` non ha un asse di altopiano e la procedura `4-bis` NON gli si
applica**: il suo asse e' il **magic su due valori** (`779320`, `779330`),
cioe' **due celle identiche per costruzione**. Serve a regalare gratis il
**cancello di casa G1 (gemelli / determinismo)**. Con 2 celle `P4` boccerebbe
sempre: non e' un buco, e' un file che risponde a un'altra domanda.

**(B) `R126-G0` NON SI LEGGE NEL CSV: SI CALCOLA -- e questo apre un buco che
va chiuso adesso.**
Il CSV del tester non ha una colonna "distanza di stop". `R126-G0` e' quindi
**aritmetico**: dipende da `stop(0) + b*ATR`, cioe' **e' gia' noto oggi**, a
numeri non visti. Applicato all'angolo pessimista, esclude le prime **quattro**
celle dell'asse. **Cioe' `P1` tronca l'asse alla sua meta' destra prima ancora
di guardare un risultato.** E' esattamente la forma della classe 210 (un
cancello che, entrando in `P1`, puo' nascondere un altopiano vero):

> **OBBLIGO, congelato adesso:** ogni volta che `R126-G0` esclude almeno una
> cella, si calcolano **lo stesso** i blocchi ignorando `R126-G0` -- e
> **soltanto** lui, gli altri cancelli restano attivi -- e si scrivono nel
> referto in un riquadro separato ed etichettato
> **`FORMA DI COSTO (non si sceglie)`**, con PF, DD e `n` di ogni cella.
> Valgono **le stesse tre proibizioni** che R125 mette sui blocchi geometrici
> (classe 212): **(1)** un blocco di quel riquadro non entra MAI in `P3`,
> `P5`, `P6`, `P7`; **(2)** nessuna cella nominata li' puo' essere proposta,
> promossa o citata come candidata; **(3)** i due elenchi stanno in riquadri
> **separati**, mai nella stessa tabella.
> Motivo: **un altopiano che sta a sinistra del cancello del costo e' un
> fatto sul motore** (dice che il buffer non morde), e i fatti non si buttano.
> Resta valido in parallelo il riquadro **`FORMA GEOMETRICA (non si sceglie)`**
> di R125 se e' `R126-G3` a escludere celle: sono **due** riquadri distinti,
> con due nomi distinti, e nessuno dei due sceglie niente.

**(C) L'angolo della forbice e' congelato PRIMA.**
`R126-G0` si valuta **solo** a `stop(0) = 77,1` e `spread = 2,65` e
`ATR = 64,2`. Gli altri angoli (171,3 / 2,00 / 3,00 / ATR 50 / ATR 90) si
stampano in una **tabella di sensibilita'**, e **non** possono spostare il
verdetto di nessun cancello. Senza questa riga, chiunque potrebbe scegliere
l'angolo che gli fa passare la cella che preferisce.

### 5.3 COSA FA SCARTARE SUBITO (bocciatura secca, senza discussione)

- **DD OOS > 3,9082%** ... **NO. Questa soglia NON viene usata**, e va detto
  perche' qualcuno potrebbe volerla: e' il DD della cella viva, e usarlo come
  bocciatura secca renderebbe **impossibile** qualunque cella diversa dalla
  cella viva. La bocciatura secca sul rischio e' **`R126-G1` (7,00%)**, che e'
  il numero di casa; il confronto con 3,9082% si **stampa**, non **boccia**.
- **n OOS < 95** in una cella che altrimenti passerebbe: si dichiara
  **NON MISURABILE**, non "promossa".
- **cella 0 che non riproduce l'archivio** (par. 5.5): il round si **ferma**.

### 5.4 LA PROCEDURA `P1..P8`, ESEGUITA IN ANTICIPO SULLA FORMA ATTESA

R125 ha imposto lo standard: la procedura si **esegue**, non si cita soltanto.
Eseguita sull'asse a 9 valori (indici 0..8 = `0 ; 0,125 ; ... ; 1,000`) e sulla
forma **attesa** del par. 4.1 (PF in calo lento, DD in lieve salita, tutte le
celle dentro `R126-G1/G2/G3`):

- `R126-G0` all'angolo pessimista ammette `b >= (106,0 - 77,1)/64,2 = 0,450`
  -> **celle 4..8** (`0,500`..`1,000`). Le celle 0..3 **spezzano** (`P1`).
- `P2`: un solo blocco massimale, `{4,5,6,7,8}` (span PF atteso ~0,08 <= 0,15).
- `P3`: vince per lunghezza (unico).
- `P5`: la cella **8 = 1,000** e' un bordo **FINE GRIGLIA** -> si toglie.
  Residuo `{4,5,6,7}`, **4 celle >= 3**: il blocco **sopravvive**.
  E scatta comunque la clausola (classe 216): **"l'asse e' APERTO a destra e
  va esteso di almeno due gradini"**, perche' un blocco di `P2` **conteneva**
  un bordo FINE GRIGLIA.
- `P6`: si tolgono la prima (4) e l'ultima (7) -> **SCEGLIIBILI = {5, 6}**,
  cioe' **0,625 e 0,750**.
- `P7`: baricentro del blocco residuo `{4,5,6,7}` = **5,5**. Le due
  scegliibili sono a **pari distanza (0,5)**. Spareggio (a) **DD OOS piu'
  basso**; se pareggia al centesimo, (b) **parametro piu' basso** ->
  **`0,625`**.
- `P8`: si scrivono tutti i blocchi, il vincente, la cella, **quale passo l'ha
  decisa**, la frase sull'asse aperto a destra, e il riquadro
  **`FORMA DI COSTO (non si sceglie)`** con i blocchi calcolati ignorando
  `R126-G0`.

**Contro-esempio che ho costruito per rompere questo disegno, e cosa ne esce.**
Se il PF cala piu' in fretta e le celle 7 e 8 cadono sotto `R126-G3b`
(`PF OOS < PF(0) - 0,15`), il blocco diventa `{4,5,6}`: nessun bordo FINE
GRIGLIA dentro, `P5` non toglie niente, `P6` lascia **SCEGLIIBILE = {5}**,
`P7` -> **`0,625`**. **Stessa cella per due strade diverse.** Se invece cadono
anche 5 e 6, il blocco scende sotto 3 celle e `P4` chiude con **"non c'e' una
configurazione robusta"**. In nessuno dei tre casi la procedura ammette due
letture.

**E il caso che il disegno NON copre, dichiarato:** al **P95 dell'ora vera
(3,00)** il pavimento e' `40 x 3,00 = 120,0` punti indice, cioe' `b >= 0,668`
-> ammissibili solo **{6,7,8}**, e `P5` toglie la 8 -> **2 celle** -> `P4`
boccia. **Al P95 questo asse e' TROPPO CORTO, e servirebbe estenderlo a 1,25.**
Lo scrivo adesso e non dopo. Il P95 **non** e' il cancello (il cancello e' la
mediana): e' una prova di stress che il round **dichiara di non poter
superare**, non una che fallisce a sorpresa.

### 5.5 LE ANCORE -- si controllano PRIMA di leggere qualunque altra cosa

**Ancora 1 (la piu' forte): la cella `b = 0` di `R126a` E' la cella viva.**
Con `InpSLBufferAtr = 0` il codice ricade su `InpSLBufferPips * pip` = `3 *
0,01` = **0,03 punti indice** (r.239): **identico a tutte le passate
d'archivio**. Deve riprodurre:

| | PF | DD % | n |
|---|---:|---:|---:|
| IS | **1,84892** | **3,7267** | **84** |
| OOS | **1,32770** | **3,9082** | **143** |

**MA LA FINESTRA NON E' LA STESSA, E VA DETTO PRIMA.** Quei CSV sono del
commit `400a462` del **08/08/2026**; il driver taglia l'IS al **40% dei giorni
fra `-DaQuando` e `-Fino`**, e `-Fino` oggi vale **2026.06.30** per default.
Quindi il confine IS/OOS **si sposta** e `n` **cambia**. L'ancora si legge a
tre gradi, congelati adesso:

- **GRADO A (forte)**: `n IS = 84` e `n OOS = 143` -> la finestra combacia ->
  allora PF e DD devono combaciare **al centesimo**.
- **GRADO B (atteso)**: `n` diverso di poco -> la differenza si attribuisce
  **alla finestra**, e PF/DD devono restare entro **+/- 0,15 di PF** e
  **+/- 1,0 punti di DD**.
  **La banda attesa, col conto in chiaro:** `-Fino 2026.06.30` da una finestra
  di **642 giorni** dal muro dei tick `2024.09.26`; il driver mette in IS il
  **40% dei GIORNI** (r.661) = **256 giorni**, e lascia **386 giorni** di OOS.
  Al ritmo misurato `227 / 681 giorni = 0,333 operazioni al giorno di
  calendario` escono **n IS ~85** e **n OOS ~129**, totale **~214** (meno dei
  227 d'archivio: la finestra e' piu' corta). Banda dichiarata, larga apposta
  perche' il ritmo non e' uniforme (nell'archivio l'IS ha il 40% dei giorni ma
  solo il 37% dei trade): **n IS 70-100, n OOS 110-150**.
- **GRADO C (rosso)**: `n` fuori da quelle bande, oppure PF fuori da +/- 0,15
  -> **IL ROUND SI FERMA** e si attribuisce la differenza **prima** di leggere
  le altre otto celle.

**E i tre sospetti, in ordine, se scatta il grado C** (perche' fra l'08/08 e
oggi il sorgente e' cambiato quattro volte, `git log` alla mano):
1. **`872dba8` (08/09) -- pavimento del lotto minimo prima di `lotPend`.**
   **Predizione aritmetica, falsificabile: e' INERTE in questo round.** Il
   ramo bacato scatta solo se `NormVol(totLot * 0,3333) = 0`, cioe' se
   `totLot < 0,03`; a deposito 10.000 e rischio 1% servirebbe uno stop
   **> 3.766 punti indice**. Non succede in nessuna cella. **Se l'ancora
   riproduce, questa predizione e' confermata gratis.**
2. **`f8ebc32` (19/08) -- Guardian**: nel tester le sue GlobalVariable non
   esistono, la guardia e' **fail-open** (r.36-43 del sorgente). Inerte.
3. **`7f80a87` (17/08)** -- ha **aggiunto** `InpSLBufferAtr` e `InpPendingAtr`,
   default 0 = nessun cambio di comportamento.

**Ancora 2: `R126b` cella `InpSLLookback = 5`** e' la stessa cella viva e deve
dare **lo stesso numero della cella `b=0` di `R126a`**, al centesimo, sulla
stessa finestra. Due file diversi, stessa configurazione.

**Ancora 3: `R126c`**, due celle identiche per costruzione. Sommate alle
prime due, sono **quattro** letture della stessa configurazione che devono
coincidere.

> **Ancora e gemelli NON rispondono alla stessa domanda, e per questo ci sono
> tutte e due.** I gemelli (`R126c`) dicono *"il banco e' deterministico
> OGGI"*. Le ancore dicono *"il banco e' lo STESSO banco dell'08/08"*. Solo
> avendole entrambe si puo' attribuire uno scostamento invece di subirlo.

---

## 6. CHE COSA QUESTO ROUND NON PUO' DIRE, dichiarato prima

### 6.1 NON puo' portare il MERITO da SOSPESO a PIENO. Ed e' ARITMETICA, non pigrizia.
L'Emendamento A (16/08) chiede **>= 150 operazioni** e una finestra che ne
lasci **almeno 150 fuori campione**. Su U30USD H1 questo motore fa **227
operazioni in tutta la storia disponibile**, e il muro dei tick BCM
(**2024.09.26**, MISURATO) non si sposta.

> **227 non si divide in 150 + 150. Nessuna `FrazioneIS` esiste.** Ne servono
> 300. Quindi su questa sedia, **con una divisione contigua IS/OOS, il MERITO
> resta SOSPESO qualunque cosa faccia questo round.**

**E qui va corretta una riga del piano di ottobre**, perche' e' esattamente il
genere di cosa che costa una challenge: `PIANO_CHALLENGE_OTTOBRE.md` r.76 da'
a `770511` **"n 227 = MERITO PIENO"**. Il **227 e' della corsa a FINESTRA
PIENA, che non ha nessun fuori campione**. Spezzata in IS/OOS la stessa corsa
fa **84 e 143: tutte e due sotto 150**. Il campione c'e'; quello che manca e'
una **partizione fuori campione che ce l'abbia anche lei**. Sono due cose
diverse e finora erano scritte come una sola.
**Le vie d'uscita, e nessuna e' in questo round:** (a) l'Emendamento C, prova
di REGIME su finestre scelte invece della divisione contigua; (b) il pavimento
**per FAMIGLIA** firmato il 07/09; (c) il forward. Tutte e tre sono decisioni,
non misure di R126.

### 6.2 NON puo' misurare lo STOP INIZIALE su tutte e 227 le operazioni
Il CSV di ottimizzazione non ha la distanza di stop. L'export per-trade
(`ExportTrades()`, r.572-597) scrive **solo i deal di USCITA** -- niente prezzo
d'apertura, niente SL -- quindi **non basta**. La chiusura piu' economica e'
aggiungere `open_price` e `sl` a quella funzione: **due righe**, e
**NON e' fatta qui** (perimetro: nessuna modifica a nessun `.mq5`). Finche'
non c'e', `stop(0)` resta la **forbice [77,1 ; 171,3]** del par. 2.

### 6.3 NON e' un cancello di RISCHIO, e va ripetuto
`stop/spread` **non predice il drawdown fra motori diversi**: Spearman
**-0,02** senza l'oro, **+0,07** nella ricostruzione indipendente del cancello
(`CANCELLO_COSTO_FLOTTA_2026-09-10.md` par. 6.3, su ~20 sedie). `R126-G0`
misura il **PEDAGGIO**. Il rischio ha i suoi cancelli e sono `R126-G1` e
`R126-G2`. Chi leggesse la colonna `stop/spread` come una classifica di
rischio userebbe lo strumento sbagliato.

### 6.4 NON descrive la sedia che gira in forward
Il tester compila il sorgente **del repo**, che contiene il fix del lotto
`872dba8` (08/09). Il binario attaccato sul demo **50503392** e' precedente.
Finche' non c'e' ricompilazione (che e' una **firma di Claudio**, voce A2 del
piano), **i numeri di R126 descrivono l'EA corretto, non quello vivo**.
Nota utile: la predizione del par. 5.5 dice che su questa geometria il fix e'
**inerte**; se l'ancora riproduce, quella differenza **non conta**.

### 6.5 Gli altri buchi
- **Slippage**: [NON MISURATO] sugli indici. Il tester lo modella a **zero**.
  E su questa famiglia R55 ha misurato che lo slippage morde in proporzione
  **inversa alla larghezza dello stop**: e' l'unico asse su cui il buffer
  dovrebbe **aiutare** e questo round **non lo misura**.
- **Spread al MINUTO**: [NON MISURATO]. Abbiamo la mediana dell'ora.
- **Un regime solo**: 2024.09 - 2026.06, Dow prevalentemente al rialzo.
- **Lo spread di 2,65 e' su n=8 posizioni**: sottile (par. 2.2).
- **L'asse non copre il P95** (par. 5.4): servirebbe estenderlo a 1,25.
- **Interazione con R120b**: `prove/R120b_*` (uscite Supertrend: `InpTrailOnST`
  x `InpExitOnFlip`, 4 file, **preparato e MAI GIRATO**) tocca la stessa
  sedia. R126 **pinna trail e flip ACCESI** (la configurazione in campo). Se
  R120b girasse e spostasse la cella di riferimento, **R126 andrebbe
  rifatto sulla nuova base**. Vale la pena dirlo: sono due round sulla stessa
  sedia e **l'ordine conta**.

---

## 7. IL COSTO IN TEMPO MACCHINA

Ritmo **MISURATO**: **0,101 min/passata** (R88: 13,7 min per 136 passate).

| file | asse | celle | passate (x2 finestre) | minuti |
|---|---|---:|---:|---:|
| `R126a_costo_bufferatr_U30USD.txt` | `InpSLBufferAtr` 0..1,000 passo 0,125 | 9 | 18 | 1,82 |
| `R126b_stop_lookback_U30USD.txt` | `InpSLLookback` 1..13 passo 2 | 7 | 14 | 1,41 |
| `R126c_gemelli_U30USD.txt` | `InpMagic` (tecnico) | 2 | 4 | 0,40 |
| `R126d_costo_bufferatr_NASUSD.txt` | `InpSLBufferAtr` 0..1,000 passo 0,125 | 9 | 18 | 1,82 |
| **TOTALE** | | **27** | **54** | **5,45** |

**E il numero onesto e' piu' alto di 5,45.** Sono **quattro invocazioni
separate** del driver, e ognuna ricompila l'EA e riavvia MT5. Quell'onere e'
**[NON MISURATO]** per invocazione; stimandolo 1-2 minuti, la finestra
realistica e' **10-15 minuti**. **Non uso mai le "2,3 ore" del referto R88**:
quelle sono di tutta la notte, R87+R89+R86 compresi (classe 192).

---

## 8. IL DEPOSITO E LA TAGLIA, DICHIARATI (la voce M-C5 del piano)

- **Deposito: 10.000** (il default del driver, scritto **esplicito** nella
  riga di lancio: uno stato implicito non e' uno stato dichiarato).
  Motivo: e' il valore con cui la corsa d'archivio e' compatibile (profitto
  **1.433,34** su finestra piena = **+14,3%** con DD 4,02%; e `R23d` registra
  *"coda 10-11/08 a deposito 10k"*). Cambiare deposito renderebbe l'ancora
  illeggibile.
- **Rischio: 1,00%**, pinnato. **NON e' la taglia di campo** (la sedia gira a
  0,65%): e' il valore comune che rende queste celle confrontabili con
  l'archivio e con `CONTRATTI_SEDIE.md`. **Le taglie restano di Claudio.**
- **Controllo del pavimento del lotto, fatto e non assunto:** a 10.000 e 1%,
  `risk_money` = 100 EUR; con `lossPerLot = stop x 1 USD` (contract size
  **1**, verificato sui trade veri: 0,10 lotti x 12,70 punti = 1,27 USD =
  **1,12 EUR** riportati) il lotto va da **~1,47** (stop 77,1) a **~0,80**
  (stop 141,3). Lontanissimo sia dal minimo (0,01) sia da qualunque massimo.
  **Nessuna cella di questo round e' distorta dai pavimenti del lotto.**

---

## 9. IL PERIMETRO DI QUESTO ROUND

Prepara **file e criteri**. **Non esegue backtest** (MT5 gira sul VPS), **non
tocca nessun `.mq5`, nessun `.set`, nessun parametro in forward, nessun
terminale, nessuna sedia viva.** La firma e' di Claudio.
Il terminale di destinazione e' **`C:\MT5_Backtest`** -- VPS, **demo 50504400**,
zero EA attaccati -- **nominato a mano in ogni riga di lancio** (classe 204):
se `-TerminaleBacktest` e' vuoto il driver sceglie col ripiego, e sulla
macchina ci sono **tre** terminali di cui uno con le **sedie vive**.

---

_Fonti primarie, tutte sul branch `lavoro`:_
`report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` par. 0, 2.3, 5.1, 6.3, 7.1
`backtest_pipeline/prove/R125_ORB_COSTO_CRITERI.md` par. 3, 3-bis, 4-bis, 4-ter
`report/PIANO_CHALLENGE_OTTOBRE.md` par. 1.2 r.76 e voce A2
`backtest_pipeline/REGISTRO_TEST.md` par. "EA SuperWave" (r.507-530)
`report/AUDIT_USCITE_2026-09-09.md` Tabella B
`data/statements/trades_auto.csv` (demo **50503392**, 16 gambe di 770511)
`backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_{U30USD,NASUSD}.csv`
`backtest_pipeline/risultati_archivio/SuperWave/valid_SuperWave*_{U30USD,NASUSD,D30EUR}_H*.csv`
`backtest_pipeline/risultati_prove/ABTG_SuperWave_DOW_H1_Ottimizzato/*.csv`
`backtest_pipeline/prove/ABTG_SuperWave_DOW_H1_Ottimizzato.txt` (soglia 1,10 pre-registrata)
`backtest_pipeline/prove/R120b_U30USD_*.txt` (preparato, mai girato)
`mql5/Experts/ABTG_SuperWave_DOW_H1_Ottimizzato.mq5` r.78-86, 176-181, 237-239, 256, 281, 319, 331, 341, 394-421, 572-597
`mql5/Experts/ABTG_SuperWave.mq5` r.80, 239
`backtest_pipeline/walkforward_generico.ps1` r.159-212 (parametri), r.658-668 (divisione IS/OOS)
