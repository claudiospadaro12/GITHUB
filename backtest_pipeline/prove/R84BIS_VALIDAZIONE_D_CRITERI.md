# 🧪 R84-bis — LA VALIDAZIONE DEL RIDUTTORE-DI-PERDITA (cella D di R84)

_Criteri congelati il **19/08/2026**, PRIMA di qualunque numero nuovo.
Chi legge la tabella dei risultati deve aver letto prima questo file.
Committati prima che una sola cella giri: **un collaudo senza criteri
committati prima dei numeri non e' un collaudo, e' una spazzolata.**_

> 🎯 **LA DOMANDA, UNA SOLA:**
> **"La cella D di R84 (volumi OPPURE ATR) contiene INFORMAZIONE VERA, o e'
> FORTUNA DELLA FINESTRA?"**
>
> Detto nel modo in cui si puo' misurare: un filtro con informazione **si
> vede su una base POSITIVA** (riduce il drawdown senza uccidere il
> profitto), **vive anche accanto al valore esatto** dei suoi parametri,
> **degrada meno del nudo** quando i costi peggiorano, e **il vantaggio e'
> persistente nel tempo**, non concentrato in due mesi.

---

## 0. 🧬 DA DOVE VIENE LA CELLA — la provenienza, per intero

| | |
|---|---|
| round di origine | **R84** (ablazione filtri del corso, Nasdaq apertura US) |
| referto | `risultati_archivio/REFERTO_ROUND84_ABLAZIONE.md` |
| criteri di origine | `prove/R84_ABLAZIONE_CRITERI.md` (congelati 18/08 sera) |
| CSV grezzi | `risultati_archivio/r84_csv/` (commit `2458b33`) |
| file prova della cella | `prove/R84d_volatr_NASUSD.txt` |
| EA | `ABTG_Nasdaq_Apertura_US.mq5` (vivo, **mai toccato**) |
| magic di provenienza | **776040 / 776041** (gemelli deterministici) |
| cosa accende | `InpUseVolumeFilter=1` · `InpUseAtrFilter=1` · `InpConfirmMode=0 (OR)` |
| parametri del filtro | `InpVolMult=1.5` · `InpVolAvgBars=20` · `InpAtrFilterBars=20` · `InpAtrFilterMult=1.0` |
| sedia di provenienza | **770201 Nasdaq Apertura US — SPENTA** dal 18/08 (FIRMA 5) e resta spenta |

**I numeri da cui si parte** [VERIFICATO, letti dai CSV in `r84_csv/`]:

| cella | finestra | Profit | PF | n | Equity DD % | Peggior giornata % | Serie perdente peggiore |
|---|---|---:|---:|---:|---:|---:|---:|
| A nudo | IS | +686,35 | 1,25367 | 156 | 6,1383 | −1,8947 | −235,65 |
| A nudo | OOS | −795,03 | 0,87315 | 291 | 17,0700 | −1,0454 | −376,55 |
| **D vol OR ATR** | IS | **+858,34** | **1,51444** | 110 | **3,0193** | −1,8868 | −202,52 |
| **D vol OR ATR** | OOS | **−287,19** | **0,92450** | 201 | **6,9188** | −1,0605 | −208,00 |

Totali ricavati per aritmetica dai due aggregati (`GL = Net/(PF−1)`),
quindi **[INFERITO]** e ricontrollati per questo file: **A** = −108,68 /
PF 0,988 / n 447 · **D** = +571,15 / PF 1,104 / n 311.

**Il fatto scomodo, scritto in testa e non in fondo:** in OOS la cella D e'
**ancora negativa** (−287, PF 0,924). Tutto il totale positivo e' fatto
nell'IS. D **riduce la perdita**, non crea un guadagno. R84-bis nasce da qui.

---

## 1. 🔒 COSA E' CONGELATO (e non si tocca dopo)

1. **ZERO CODICE NUOVO NEGLI EA.** Vincolo del round. Tutti i filtri di
   R84-bis sono input che esistono gia'. **Una prova che richiederebbe
   codice viene DICHIARATA e SCARTATA** (§7 ne scarta due, con nome e
   cognome).
2. **Nessuna modifica al forward.** Nessuna sedia si accende, si spegne o
   cambia parametro per effetto di questo round. La 770201 resta spenta.
3. **La cella D non si ritara.** I valori `1.5 / 20 / 20 / 1.0` restano il
   **centro** in ogni lettura. La prova di robustezza (§4B) guarda i
   vicini per sapere **se il vantaggio e' largo**, mai per sceglierne uno
   migliore: **se un vicino va meglio del centro, il centro NON si
   sposta** — si scrive che la superficie e' inclinata e basta.
   (Regola di casa: centro dell'altopiano, MAI il picco.)
4. **Un asse alla volta.** Ogni cella nuova cambia UNA riga rispetto alla
   sua baseline dichiarata. Le uniche cose spazzolate restano i due magic
   gemelli.
5. **Le baseline non si stimano: si RIPRODUCONO.** Ogni gamba del round ha
   un canarino che deve ritrovare al centesimo un numero gia' in archivio
   (§3). Se un canarino non torna, **quella gamba si ferma li'** e non si
   spiega a posteriori.

---

## 2. ⚠️ LA SCOPERTA CHE HA RISCRITTO IL DISEGNO (letta nel sorgente, PRIMA di lanciare)

Cercando dove i filtri mordono, nei tre EA d'apertura (`ABTG_DAX_Apertura_EU`,
`ABTG_Nasdaq_Apertura_US`, `ABTG_Apertura_3Ingressi`) risulta questo, uguale
in tutti e tre [VERIFICATO sul sorgente, call site per call site]:

- `ConfirmOK()` — la funzione che implementa **volumi OR/AND ATR** — e'
  chiamata **SOLO** da `TryPlaceBreakout()`, `TryPlaceRangeFade()`,
  `TryPlaceDelayed()`, `TryPlaceGapFill()`.
- Il ramo **RETEST** (`MonitorRetest`, righe 1477 e 1510 del DAX vivo)
  chiama **`VolumeOK()` NUDA**, non `ConfirmOK()`.

**Conseguenza, che vale come un risultato:**

> 🚨 **Sulla sedia viva del DAX (770101, `InpEntryMode=RETEST`) la cella D
> NON ESISTE.** Accendendo i tre input, `InpUseAtrFilter` e
> `InpConfirmMode` sono **INERTI**: morde solo la gamba volumi. Chi
> scrivesse "cella D sul DAX" leggendo quei tre input starebbe misurando
> la **cella B**, e chiamandola D.

Le funzioni `VolumeOK`, `AtrOK`, `ConfirmOK` sono invece **identiche token
per token** fra `ABTG_Nasdaq_Apertura_US` e `ABTG_DAX_Apertura_EU`
[VERIFICATO con confronto automatico]: quando il ramo le chiama, il filtro
misurato e' lo stesso oggetto. La differenza e' **dove** viene chiamato.

Per questo la prova di trasferibilita' ha **due gambe separate e dichiarate**
(§4A), e non una sola.

---

## 3. 🐤 I CANARINI — nessuna gamba si legge senza il suo

| canarino | cosa deve ritrovare | fonte del numero |
|---|---|---|
| **C1 — riproducibilita' DAX breakout** | IS +203,66 / 1,04668 / 220 / DD 7,9333 · OOS +251,22 / 1,04089 / 325 / DD 13,2624 | `r83_csv/..._D30EUR_{IS,OOS}_r83d0.csv` |
| **C2 — riproducibilita' DAX retest (sedia viva)** | IS +282,12 / 1,07810 / 197 / DD 7,0257 · OOS +999,42 / 1,18776 / 311 / DD 10,5984 | `r83_csv/ABTG_DAX_Apertura_EU_D30EUR_{IS,OOS}_r83v.csv` |
| **C3 — riproducibilita' Nasdaq A e D con `Spread=0` scritto** | A e D di R84, tabella §0, al centesimo | `r84_csv/` |
| **C4 — lo spread forzato MORDE davvero a modello 4?** | cella A con `Spread=400` **DEVE** dare numeri **DIVERSI** da C3 | — |

**C4 e' il canarino piu' importante del round e va spiegato.** MT5 a
**modello 4 (tick reali)** prende bid/ask dai tick: **non e' misurato in
questa casa se la riga `Spread=` dell'`.ini` venga onorata o ignorata**. Se
fosse ignorata, tutta la scala di stress uscirebbe **identica** alla base — e
la si leggerebbe come *"il filtro e' robusto allo spread"*, che sarebbe un
**numero falso**, non un risultato. Quindi:

- **C4 passa** (numeri diversi) → la scala di spread §4C si gira a **tick reali** e vale.
- **C4 fallisce** (numeri identici al centesimo) → **la scala a tick reali e'
  NON ESEGUIBILE** e va scritto cosi'. Ripiego: la si gira a **modello 1
  (OHLC M1)**, dove lo spread forzato e' certamente applicato, e **ogni
  numero della scala porta scritto accanto "OHLC, non tick — SOLO
  SCREENING"**. Regola di casa: OHLC solo per lo screening dello stress; il
  gradino che decide gira a tick reali. **Se non ci puo' girare, lo stress
  spread non decide: pesa zero nei cancelli** (§5) e resta agli atti come
  misura di screening.

⚠️ **Un difetto scoperto negli atti, dichiarato qui:** gli `.ini` di R84 e R83
**non contenevano nessuna riga `Spread=`**. Il valore usato e' quindi quello
che MT5 aveva in memoria: **stato nascosto, mai messo agli atti**. C3 (che
scrive `Spread=0` esplicito e pretende gli stessi numeri) e' anche la misura
di quello stato nascosto. Se C3 non torna, **i numeri di R84 e R83 restano
validi ma la loro riga di spread e' [NON MISURATA]**, e va scritto nel referto.

---

## 4. 🧬 LE PROVE — quali, perche', e quali NO

Costo dichiarato: **~7 min/cella** (velocita' misurata; una "cella" = IS+OOS
con le due passate gemelle). Ordine = ordine di informazione per minuto.

### 4A. 🔀 TRASFERIBILITA' — la prova piu' informativa (prima)

**Perche' e' la prima.** Su una base **perdente** (Nasdaq) un filtro che
toglie trade riduce la perdita quasi per costruzione: bastano meno biglietti
per perdere meno. Su una base **POSITIVA** questo alibi non c'e': se il
filtro togliesse trade a caso, taglierebbe profitto e drawdown **nella stessa
proporzione**. Un riduttore di perdita **con informazione** taglia molto
drawdown e poco profitto. **E' l'unica prova che puo' distinguere le due cose
su questo campione.**

Il DAX e' la base positiva disponibile, misurata a tick reali sulla **stessa
finestra** (R83): retest PF tot 1,143 · breakout PF tot 1,043.

| cella | EA | file prova | base | cosa cambia | magic |
|---|---|---|---|---|---|
| **T0** | `ABTG_Apertura_3Ingressi` | `R83d0_stop_D30EUR.txt` (**invariato**) | — | nulla: e' il **canarino C1** | 777110 / 777111 |
| **T1** | `ABTG_Apertura_3Ingressi` | `R84BIS_T1_volatr_D30EUR.txt` | T0 | `InpUseVolumeFilter=1` + `InpUseAtrFilter=1` + `InpConfirmMode=0` | 776120 / 776121 |
| **T2** | `ABTG_DAX_Apertura_EU` | `R83v_vivo_D30EUR.txt` (**invariato**) | — | nulla: e' il **canarino C2** | 777190 / 777191 |
| **T3** | `ABTG_DAX_Apertura_EU` | `R84BIS_T3_volumi_D30EUR.txt` | T2 | `InpUseVolumeFilter=1` (**e SOLO quello: §2**) | 776140 / 776141 |

- **T1 e' la trasferibilita' VERA della cella D**: stesso stile d'ingresso
  (breakout a stop) del Nasdaq dov'e' nata, quindi `ConfirmOK` morde e la
  semantica **OR** e' quella del PDF. Confronto mele-mele.
- **T3 e' la trasferibilita' SULLA SEDIA CHE E' VIVA** (retest, 770101): li'
  la sola gamba applicabile e' quella volumi. **Va letto come gamba volumi,
  mai come "cella D"**, e nel referto si scrive accanto: *"ATR e ConfirmMode
  inerti su questo ramo"*.
- **Nota di lettura pretesa in anticipo**: R84 misuro' la gamba volumi da
  sola sul Nasdaq (cella B) e la boccio' (PF tot 0,917, campione 447→154).
  Se T3 aiutasse il DAX, la **stessa gamba** avrebbe segno opposto sui due
  mercati: **e' un risultato, non una contraddizione** (lezione PTE, gia'
  agli atti), e va scritto cosi'.

**Costo: 4 celle ≈ 28 min.**

### 4B. 🎛️ ROBUSTEZZA DEI PARAMETRI (Nasdaq, dove D e' nata)

Se il vantaggio vive **solo** sul valore esatto, e' rumore di taratura.
Vicini stretti, **un moltiplicatore alla volta**, il resto pinnato:

| cella | cosa cambia rispetto a R84d | magic |
|---|---|---|
| **B1** | `InpVolMult` 1.5 → **1.25** | 776150 / 776151 |
| **B2** | `InpVolMult` 1.5 → **1.75** | 776160 / 776161 |
| **B3** | `InpAtrFilterMult` 1.0 → **0.9** | 776170 / 776171 |
| **B4** | `InpAtrFilterMult` 1.0 → **1.1** | 776180 / 776181 |

`InpVolAvgBars=20` e `InpAtrFilterBars=20` **restano pinnati**: muovere
anche le finestre farebbe una griglia, e le griglie qui sono vietate (§1.3).

**Costo: 4 celle ≈ 28 min.**

### 4C. 💸 STRESS SPREAD (il mestiere del collaudo)

Un filtro che seleziona i momenti **piu' liquidi** dovrebbe **degradare meno**
del nudo quando lo spread peggiora. Se degrada **uguale o peggio**, quello che
seleziona non e' liquidita'.

**⚠️ Lo spread mediano della base e' [NON MISURABILE con gli attrezzi
esistenti], e lo si dichiara qui invece di inventarlo.** Nel repo non esiste
una misura dello spread storico di `NASUSD` a BCM: la serie per-trade dell'EA
non ha colonna spread (esporta `close_time; symbol; magic; position_id;
deal_type; volume; price; net_profit`) e l'unica tabella spread in archivio e'
quella **Pepperstone di SABATO** (`REFERTO_RICOGNIZIONE_PEPPERSTONE.md` §18-19,
gia' dichiarata da rimisurare a mercato aperto). Quindi:

1. **La scala si dichiara in PUNTI MT5 ASSOLUTI, non in percentuale.**
   Conversione dichiarata: `NASUSD` a BCM quota a **2 decimali**, quindi
   **100 punti MT5 = 1,0 punto indice** [VERIFICATO: prezzi a 2 decimali
   nelle serie per-trade `r84_csv/pertrade_r84*.csv`; coerente con
   `Nasdaq_Apertura/ABLAZIONE_NASDAQ.md` e col caso v21 del 12/08].
2. **La scala:** `Spread` = **0 (corrente/reale)** · **100** (1,0 pt indice) ·
   **200** (2,0) · **400** (4,0), su **A** e su **D**.
3. **Il criterio e' COMPARATIVO, non assoluto** (§5C): si confronta il
   degrado di D col degrado di A **sullo stesso gradino**. Un confronto
   comparativo **non ha bisogno** dello spread mediano della base — ed e'
   per questo che questa prova resta leggibile nonostante il §4C.1.
4. **La scala misura anche il bracket dello spread reale** [sara' INFERITO]:
   se il gradino 100 va **meglio** del gradino 0, allora lo spread vero medio
   dei tick sta **sopra** 100 punti. E' un limite inferiore misurato, non
   una stima, e va scritto come tale.
5. **Nessuna riga nuova nei file prova**: `Spread` e' una riga dell'`.ini`
   del tester, non un input dell'EA. Si riusano **R84a e R84d INVARIATI**
   (stessi magic 77601x / 77604x); i CSV si distinguono per `-Etichetta`.
   **Il gradino 0 e' quindi anche il canarino C3.**

**Costo: 8 celle ≈ 56 min** (di cui la prima, `A@400`, e' il canarino C4 che
apre o chiude tutta la prova).

### 4D. 🪟 SPLIT ALTERNATIVO (ultimo, e con il suo limite scritto)

`walkforward_generico.ps1` ha gia' `-FrazioneIS` (default 0,40): spostare il
taglio a **0,55** costa zero codice.

**Limite dichiarato subito: NON e' un walk-forward.** Il campione totale non
cambia, quindi **PF totale, profitto totale e n totale sono identici per
costruzione**: l'unica cosa che si muove e' la **decomposizione** fra le due
meta'. Serve quindi a UNA cosa sola, ed e' comunque uno dei quattro cancelli
di R84: **la coerenza fra le meta' (cancello 2) regge se si sposta il
confine, o esisteva solo al 40/60?**

Celle: **A** e **D** con `-FrazioneIS 0.55` (file prova R84a/R84d invariati,
etichetta diversa). **Costo: 2 celle ≈ 14 min.**

### 4E. 🧮 POST-PROCESSING (costo macchina ZERO, si fa sui CSV gia' in repo)

Nessun MT5, nessuna riga di lancio, nessun minuto di Claudio.

- **P1 — PERSISTENZA.** Le serie per-trade OOS di A (`pertrade_r84a_*`) e D
  (`pertrade_r84d_*`) si dividono in **4 quarti per data** e si confronta
  D − A quarto per quarto. Un vantaggio **vero** e' presente in piu' quarti;
  un vantaggio da **fortuna della finestra** sta tutto in uno.
- **P2 — SLIPPAGE/LATENZA sugli ingressi** [APPROSSIMAZIONE dichiarata].
  Dalla lista trade OOS, si peggiora **ogni ingresso** di N punti:
  `costo_posizione = N_punti × 0,01 × volume_totale_della_posizione ×
  valore_del_punto_indice`. Scala **adattata al tick size** (0,01 su NASUSD,
  dove la scala di casa 0/1/2/5 punti sarebbe 0,05 punti indice = niente):
  **0 / 25 / 50 / 100 punti MT5** = 0 / 0,25 / 0,50 / 1,00 punti indice.
  Gli EA d'apertura prendono la scala piu' severa: **la latenza morde dove
  la volatilita' e' massima**, ed e' esattamente l'apertura.
  - ⚠️ **Cosa NON modella**: requote, ordini rifiutati, slippage favorevole,
    e il fatto che gli ordini **STOP** pagano lo slippage mentre i **LIMIT**
    del retest no. E' una stima **pessimistica controllata**, non una
    simulazione.
  - ⚠️ **Il valore del punto indice EUR/lotto per NASUSD non e' misurato in
    archivio** (l'unico misurato dal vivo e' `U30USD` = 0,862 EUR/punto/lotto,
    DIARIO 17/08). Quindi P2 si calcola **in punti-lotto** e la conversione in
    euro si dichiara come **[INFERITO, con il valore usato scritto accanto]**,
    oppure si legge il **rapporto** D/A, che non dipende dalla conversione.
    **La lettura che fa fede e' il RAPPORTO.**
  - ⚠️ **Solo OOS**: le serie per-trade IS non esistono in archivio (il driver
    le sovrascrive con quelle OOS). Dichiarato, non aggirabile senza rilanci.

---

## 5. ⚖️ I CANCELLI DI PROMOZIONE — congelati adesso

Si applicano **dopo** che i canarini §3 sono passati. Un cancello con il
canarino fallito **non si legge**.

### 5A. Cancello **T** — TRASFERIBILITA' (decisivo)

Su **T1** (cella D piena, base breakout DAX: profitto tot **+454,88**, DD OOS
**13,2624%**) e su **T3** (gamba volumi, base retest viva: profitto tot
**+1.281,54**, DD OOS **10,5984%**), ciascuno contro **la propria** baseline:

- ✅ **PASS-T** se, sulla stessa gamba, tutte e tre:
  1. **DD OOS ridotto di almeno il 25% relativo** (T1: ≤ 9,947% · T3: ≤ 7,949%);
  2. **profitto totale conservato ad almeno l'85%** (T1: ≥ +386,65 · T3: ≥ +1.089,31);
  3. **n totale ≥ 150** (leggibilita', Emendamento della Finestra punto A).
- 🟡 **FRAGILE-T** se il DD scende di ≥25% ma il profitto totale resta fra il
  **50% e l'85%** della baseline: si scrive **quanto margine reale ha** e la
  decisione passa a Claudio.
- ❌ **FAIL-T** se il profitto totale scende sotto il **50%**, **oppure** il DD
  non cala di almeno il 25%, **oppure** il DD **peggiora** in una qualunque
  delle due meta' di piu' di **1 punto percentuale** (clausola di RISCHIO:
  un DD accaduto vale a qualunque n), **oppure** n totale < 150 (in questo
  caso si scrive **MERITO SOSPESO**, valvola R59, non "bocciato").

### 5B. Cancello **R** — ROBUSTEZZA

Metro: PF totale della cella D = **1,104**; soglia di R84 = **A + 0,10 = 1,088**.

- ✅ **PASS-R**: **almeno 2 vicini su 4** stanno **sopra 1,088** con **profitto
  totale positivo** e **n totale ≥ 150**.
- ❌ **FAIL-R**: 0 o 1 vicino su 4. Allora il vantaggio **vive solo sul valore
  esatto** = rumore di taratura, e va scritto con queste parole.
- 🧊 In ogni caso il centro **non si sposta** (§1.3). Se un vicino batte il
  centro si scrive "superficie inclinata verso X" e **niente altro**.

### 5C. Cancello **S** — STRESS SPREAD (comparativo)

Per ogni gradino g ∈ {100, 200, 400}: `degrado(cella,g) = PF(cella,g) −
PF(cella,0)`, calcolato **sul campione intero** (IS+OOS).

- ✅ **PASS-S**: `degrado(D,g) ≥ degrado(A,g)` (D perde meno) su **almeno 2
  gradini su 3**.
- ❌ **FAIL-S**: D degrada **piu'** di A su almeno 2 gradini su 3.
- ⚪ **NON ESEGUIBILE**: canarino **C4** fallito. Il cancello **pesa zero** e la
  scala resta agli atti come **screening OHLC**, dichiarato (§3).
- 🚨 **Clausola di RISCHIO, sempre attiva:** se a un gradino qualunque il **DD**
  di D sfonda un muro di casa (**10% totale**, o margine sul **5% giornaliero**
  — metro in `report/PIANO_PROP.md`), si scrive **BOCCIATO PER RISCHIO** a
  prescindere dagli altri cancelli, **e a qualunque n**.

### 5D. Cancello **P** — PERSISTENZA E LATENZA (post-processing)

- ✅ **PASS-P**: D batte A in **≥ 3 quarti su 4** dell'OOS (P1) **E** il
  rapporto D/A resta a favore di D a **50 punti** di slippage sugli ingressi (P2).
- ❌ **FAIL-P**: il vantaggio sta in **1 solo quarto**, **oppure** si ribalta
  gia' a 25 punti di slippage.

### 5E. Cancello **W** — SPLIT ALTERNATIVO

- ✅ **PASS-W**: al 55/45 D continua a **migliorare rispetto ad A in ENTRAMBE le
  meta'** (cancello 2 di R84 al nuovo confine).
- ❌ **FAIL-W**: al 55/45 il miglioramento sparisce in una delle due meta'.
  Allora la "coerenza fra le meta'" di R84 era **un fatto del confine**, e va
  scritto nel referto di R84-bis **e** annotato accanto al verdetto di R84.

---

## 6. 🎯 IL VERDETTO — cosa puo' e cosa NON PUO' produrre questo round

### Cosa NON puo' produrre, congelato prima (e vale anche se tutto passa)

> ❌ **NESSUNA SEDIA NUOVA.** La base Nasdaq resta **negativa in OOS** (−287,
> PF 0,924) anche con la cella D: un riduttore di perdita su una base che
> perde **non fa un edge**, e la 770201 resta spenta (FIRMA 5, porta di
> rientro C3: serve una tesi NUOVA, non una taratura).
> ❌ **Nessuna accensione automatica di filtri** su nessun EA.
> ❌ **Nessuna modifica in forward.** Un BOCCIATO produce una
> raccomandazione, non uno spegnimento; un PASS produce una proposta, non
> un'accensione.

### Cosa puo' produrre, al massimo

> ✅ **UNA RIGA DI PIANO**, e nient'altro: *"sulle sedie di APERTURA VIVE, la
> conferma volumi-OR-ATR e' consigliata come riduttore di drawdown, con
> questo margine misurato: ..."* — proposta che passa **dall'architetto e da
> Claudio**, mai da qui.

### La riga di verdetto, in uno di questi quattro tipi

- 🟢 **"D HA INFORMAZIONE"** — `PASS-T` su almeno una gamba **E** almeno 2
  cancelli su 3 fra `{R, S, P}` → si propone la **riga di piano** (§6).
- 🟡 **"D E' FRAGILE"** — `FRAGILE-T`, oppure `PASS-T` con 1 solo cancello di
  supporto → si scrive **il margine reale, numero per numero**, e la
  decisione passa a Claudio. Nessuna riga di piano proposta.
- 🔴 **"D E' FORTUNA DELLA FINESTRA"** — `FAIL-T` su **entrambe** le gambe,
  **oppure** `FAIL-R` (il vantaggio vive solo sul valore esatto) → il
  vantaggio di R84 si dichiara **specifico di quella finestra e di quella
  base perdente**, pratica chiusa, e la frase entra nel referto di R84-bis.
- ⚪ **"NON MISURABILE"** — canarini falliti, o campioni sotto 150 dove serve:
  si scrive per esteso **quale** canarino e **cosa** resta non misurato.

⚠️ **La valvola di casa resta sopra tutto:** *il campione sottile sospende il
giudizio sul **MERITO**, mai sul **RISCHIO**.* Un DD accaduto vale a qualunque n.

---

## 7. 🚫 COSA E' STATO SCARTATO, E PERCHE' (nomi e cognomi)

- **❌ La cella D piena sul RETEST del DAX** — richiederebbe di aggiungere
  `ConfirmOK()` al ramo retest: **e' CODICE NUOVO in un EA vivo**, vietato dal
  vincolo del round (§1.1). **Dichiarata e scartata.** Al suo posto va T3, che
  misura la sola gamba applicabile e lo dice nel nome.
- **❌ Lo spread mediano MISURATO della base** — servirebbe una sonda che
  legga i tick o una colonna spread nella serie per-trade: **codice nuovo**
  (EA o script). **Dichiarata e scartata**, e §4C.1 spiega come il round resta
  leggibile lo stesso (criterio comparativo).
- **❌ Il profilo COMMISSIONI di una prop vera** — non e' noto da nessuna
  scheda in archivio con numeri utilizzabili: **[NON MISURABILE]**, e non si
  inventa. Nel referto ci sara' la riga, vuota, con questa motivazione.
- **✅ Swap / rollover: NON APPLICABILE, e per misura, non per omissione** —
  tutte le celle di questo round hanno `InpCloseAtEnd=1` e chiudono a fine
  sessione (Nasdaq 21:45, DAX 17:30 ora server): **nessuna posizione passa la
  notte**. Non e' un limite: e' una proprieta' misurata della configurazione.
- **❌ Il filtro NEWS** — resta il debito aperto di R84 §6 (copertura del CSV
  non misurata). **Non entra in R84-bis**: qui si valida D, non si aprono
  fronti nuovi.
- **❌ Un walk-forward a finestre rotolanti** — il driver non lo fa e scriverlo
  e' un round suo. §4D dichiara il ripiego e il suo limite.

---

## 8. ⏱️ ORDINE DI ESECUZIONE E COSTI (STIME dichiarate, ~7 min/cella)

| passo | cosa | celle | stima | gate |
|---|---|---:|---:|---|
| **0** | post-processing P1 + P2 (§4E) | 0 | 0 min | nessuno: si fa subito, sui CSV in repo |
| **1** | **canarino C4** — `A` con `Spread=400` a modello 4 | 1 | ~7 min | se identico a R84 → §4C salta a OHLC/screening |
| **2** | **canarino C3** — `A` e `D` con `Spread=0` scritto | 2 | ~14 min | se non riproduce R84 → **tutto si ferma** |
| **3** | **trasferibilita'** T0 T1 T2 T3 (§4A) | 4 | ~28 min | T0/T2 sono C1/C2: se non tornano, la gamba si ferma |
| **4** | **robustezza** B1..B4 (§4B) | 4 | ~28 min | — |
| **5** | **scala spread** — restano `A@100 A@200 D@100 D@200 D@400` (`A@400` e' gia' girata al passo 1) | 5 | ~35 min | solo se C4 e' passato |
| **6** | **split alternativo** A e D al 55/45 (§4D) | 2 | ~14 min | ultimo, e' il piu' debole |
| | **TOTALE MASSIMO** | **18** | **~2h06** | |

**Se il tempo macchina e' poco, l'ordine di rinuncia e': 6, poi 5, poi 4.**
Il passo **3 (trasferibilita') non si salta mai**: e' la prova che risponde
alla domanda del round.

⚠️ **UNA MACCHINA, UN LAVORO.** Il PC di backtest ha **un solo MT5**: MT5 va
chiuso, e nessun altro round puo' girare in parallelo.

---

## 9. 🧾 IGIENE PRETESA (le stesse di R84, piu' una)

1. **Gemelli deterministici**: le due passate magic di ogni cella devono
   uscire **identiche**. Se non lo sono, il numero non si legge.
2. **Nessun CSV mancante**: la raccolta elenca gli attesi uno per uno.
3. **Data della raccolta = ADESSO** (referto stantio = referto buttato).
4. **Ora server BCM** in ogni `.ini`: DAX `InpSessionHour=8`, Nasdaq `14:30`.
   Un CSV con `InpSessionHour` = 9 o 15 si cestina.
5. **NUOVA**: nel referto va riportata la **riga `Spread=` effettiva** di ogni
   cella. Dopo il difetto di §3, nessun round di questa casa deve piu'
   produrre numeri con lo spread in stato nascosto.

---

## 10. 📎 TRACCIABILITA'

- File prova nuovi: `prove/R84BIS_T1_volatr_D30EUR.txt` ·
  `prove/R84BIS_T3_volumi_D30EUR.txt` · `prove/R84BIS_B1_volmult125_NASUSD.txt` ·
  `prove/R84BIS_B2_volmult175_NASUSD.txt` · `prove/R84BIS_B3_atrmult090_NASUSD.txt` ·
  `prove/R84BIS_B4_atrmult110_NASUSD.txt`
- File prova **riusati invariati** (e' un pregio, non una scorciatoia):
  `prove/R84a_base_NASUSD.txt` · `prove/R84d_volatr_NASUSD.txt` ·
  `prove/R83d0_stop_D30EUR.txt` · `prove/R83v_vivo_D30EUR.txt`
- Driver: `backtest_pipeline/lancia_r84bis.ps1` (sul modello di `lancia_r84.ps1`, con pin `-Rif`)
- Referto di preparazione: `risultati_archivio/REFERTO_R84BIS_PREPARAZIONE.md`
- Referto finale (a numeri tornati): `risultati_archivio/REFERTO_COLLAUDO_R84BIS_D.md`
- Regole di casa applicate: EMENDAMENTO DELLA FINESTRA (A, B, C) · valvola
  R59 · criterio di uscita delle sedie (RISCHIO/MERITO/TAGLIANDO) ·
  CHECKLIST_RIGA_DI_LANCIO punti 1, 3, 4, 5, 14, 18, 19
