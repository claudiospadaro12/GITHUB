# 🎙️ LIVE DI PAOLO LAVORENTI — 22/09/2026 · SCHEDA COMPLETA

**Fonte unica**: trascrizione `LIVE_PAOLO_22.09.26_2026-09-22_21-42-00-412.txt`
(432 righe, letta **per intero**) + **due screenshot** del pannello
`ORB_Indicator_V17 1.17` su `NASUSD M5` (trascritti da Claudio: io le immagini
non le vedo — tutto ciò che viene da lì è etichettato `[SCREENSHOT, trascritto
da Claudio]`).

**Perimetro**: sola lettura. Nessun round lanciato, nessuna riga a Claudio,
nessun preset toccato, nessuna sedia toccata.

**Etichette di casa**: `[TRASCRITTO]` = c'è scritto e lo cito · `[DICHIARATO A
VOCE, NON MISURATO]` = numero del relatore · `[INFERITO]` = lo deduco, e dico da
cosa · `[INCERTO]` · `[MISURATO]` = numero nostro, col file.

---

# 🥇 LA RIGA CHE CONTA

> **Questa live SCIOGLIE la "finestra contesa" dell'ORB che è aperta in
> `REGISTRO_TEST.md` r.779-800 dal 04/09.** Non era una contraddizione fra la
> voce dei docenti (14:30-14:45) e lo strumento (14:25-14:29:59): **sono DUE
> STRATEGIE DIVERSE**, e Paolo le nomina e le separa lui, testuale:
>
> *«**l'orbe breakout, due strategie sull'orbe. L'orbe classica** è quello che
> abbiamo visto ora... Poi c'è la strategia per fare l'apertura e il breakout
> degli indici americani... **Invece di fare il box i 15 minuti dopo, si fa il
> box i 5 minuti prima. Invece di fare 14.30, 14.44 ... 14.25, 14.29.**»*
>
> 🟢 **E noi le abbiamo implementate TUTTE E DUE, senza saperlo**: la sedia viva
> `770611` (U30USD) gira **14:30-14:45** = **ORB CLASSICO**; il preset
> `ABTG_ORB_US.set` `770601` (NASUSD, **spenta a inizio agosto**) gira
> **14:25-14:30** = **ORB BREAKOUT**.
>
> 🔴 **E il registro va corretto**: `REGISTRO_TEST.md` r.792 scrive *«LE NOSTRE
> DUE SEDIE VIVE (`ABTG_ORB` 770601 NASUSD · `ABTG_ORB_Ottimizzato` 770611
> U30USD) → **14:25-14:30 server**»*. **È falso per la 770611**, letto nei tre
> preset che la descrivono (100K, reale, piccolo): `InpRangeStartMin=30`,
> `InpRangeEndMin=45`. Ed è fuorviante per la 770601, che **non è viva**
> (`report/M27_SEGNO_ASPETTATIVA_2026-08-31.md` r.185: *«770601 spento a inizio
> agosto»*).

---

# 1️⃣ 🎯 LE DUE STRATEGIE ORB, TENUTE SEPARATE

## ⚠️ Prima: **in che fuso parla Paolo** — la regola che ho ricostruito, non assunto

Paolo **alterna due fusi nella stessa frase**, e la chiave è nella trascrizione:

| dove | che ora dice | fuso |
|---|---|---|
| quando **digita nel pannello** | *«invece di fare **14.30, 14.44** … **14.25, 14.29**»* | **SERVER** |
| quando **parla a voce** | *«questo nasce … dalle **15.30 alle 15.45**»* · *«chi libra questa la faccia alle **15.30**»* · *«All'**8.55**? C'è poca volatilità»* | **ITALIANO** |

👉 `15:30 IT − 1 = 14:30 server`: **le due colonne sono lo stesso istante**.
Quindi **il suo server sta a IT−1, come BCM** `[INFERITO da tre passaggi
indipendenti della stessa trascrizione]`.

🔴 **Conseguenza sul DAX, e costa un'ora se si sbaglia.** Paolo dice *«me ne
metto … con l'Orbe settato **dalle 9 alle 9.15**»*. Per la regola appena
ricavata quella è **ora ITALIANA** → **08:00-08:15 server**, che è esattamente
quello che dice la nostra regola di casa (`CLAUDE.md`: DAX apre 09:00 IT =
08:00 server) e la r.311 del `REGISTRO_TEST.md`. **Chi copiasse "9:00" dentro
il pannello farebbe il box un'ora dopo l'apertura.** `[INFERITO, non
TRASCRITTO: Paolo non dichiara il fuso in quella frase]`

---

## 🅰️ ORB CLASSICO — *«io la sponsorizzo molto questa strategia»*

| voce | cosa dice Paolo | citazione |
|---|---|---|
| **box** | i **15 minuti DOPO** l'apertura: **14:30 → 14:44** server (15:30-15:45 IT) | *«Invece di fare il box i 15 minuti dopo»* · *«questo nasce … dalle 15.30 alle 15.45»* |
| **ingresso** | linee a **±10 punti × K** dal massimo/minimo del box, e si entra quando **la candela APRE FUORI e CHIUDE FUORI** | *«Quindi comunque diciamo che l'ingresso è quando **apre fuori e chiude fuori**. Sempre se non è troppo distante»* |
| **ingresso, v1 (superata)** | *«in origine l'Orbe noi dicevamo di tirare le linee a **dieci punti** dal livello … di entrare quando la candela **chiudeva sopra** questi dieci punti»* | esplicito: **corregge la sua stessa regola precedente** |
| **stop** | **estremo OPPOSTO del box**, ripetuto **tre volte** | *«Ho messo l'altra parte dell'Orbe»* · *«**Lo stop dalla parte opposta**»* · *«sempre stop dalla parte opposta»* |
| **target** | **rischio/rendimento 1 : 1** | *«Sono quasi a take profit, **il rischio di rendimento 1 a 1**. Io ho messo proprio il rischio di rendimento 1 a 1»* |
| **gestione** | parziale + stop in pari, poi stop in profit sotto la media 50 / sotto il Supertrend M5 | *«intanto chiudiamolo in metà … e portiamo a casa qualcosa»* · *«mi porto lo stop in pari, anzi lo porto anche un po' in profit … lo metto su media 50»* |
| **filtro di contesto** | **a occhio, non codificato**: bande di Bollinger strette = non entrare; candela troppo lontana dal livello = non entrare; deviazione standard | *«Qui la prima candela dentro era questa, ma tu entri su una banda di Bollinger così? No, perché sono strette, sono quasi piatte. **Qui non entri**»* · *«Quando è così lontano, c'è da pensare anche di non farlo l'ingresso»* |
| **simboli** | **tutti gli indici**, DAX compreso | *«Lo puoi usare su tutti gli indici, anche su DAX»* |
| **lati** | entrambi — ed era **short** lui stesso sul Nasdaq | *«sono già dentro, ho short io … Io sono ORB»* |
| **un solo trade** | non lo dice. **Non deducibile** | — |

🔴 **Sul range largo, si contraddice con Emiliano e con sé stesso**: qui accetta
un box largo (*«è un po' largo però … sono dentro il movimento giornaliero»*)
purché dentro l'ADR — mentre la r.230 del nostro registro (Emiliano, RICORRENTE
su 18 live) dice *«niente trade se range troppo ampio»*. **La contraddizione
era già annotata il 04/09 e resta aperta.**

---

## 🅱️ ORB BREAKOUT / PRE-APERTURA — *«è più difficile … devi entrare con una size grossa»*

| voce | cosa dice Paolo | citazione |
|---|---|---|
| **box** | i **5 minuti PRIMA** dell'apertura: **14:25 → 14:29** server | *«si fa il box i 5 minuti prima … 14.25, 14.29»* |
| **ingresso** | ordini **pendenti** pochissimo oltre il box; lui lo fa a mercato o con un bot perché *«per questo parte subito non ce la fai a entrare al mercato»* | *«Questo box io metto una contingente strettissima in un paio di punti di Nasdaq e entro alla rottura»* · *«**La strategia dice però di mettere i pendenti**»* |
| **stop** | **cortissimo** — non quantificato | *«lo stop era cortissimo»* |
| **target** | **40 punti Nasdaq** | *«ho messo l'obiettivo a **40 punti Nasdaq** e me l'ha preso senza problemi»* |
| **breakeven** | **a 40 punti** | *«E dopo quanti punti metti il breakeven sui indici americani con quella preapertura? **40 punti**»* |
| **simboli** | Nasdaq e Dow. 🔴 **Sul DAX lo ESCLUDE** | *«E anche si può fare su DAX? Quella di 5 minuti prima dell'apertura? In DAX a quell'ora **c'è poca volatilità** … Forse si potrebbe pensare la mattina, ma **non l'ho mai trovata**»* |
| **avvertenza** | 🚩 **serve size grossa** | *«per fare soldi con l'Orb Breakout **devi entrare con una size grossa**. Qui [classico] entri con una size piccola»* |

---

## 👉 QUALE DEI DUE ABBIAMO IMPLEMENTATO? — **tutti e due**, e col parametro in mano

| | box (server) | preset / cella | stato |
|---|---|---|---|
| **ORB CLASSICO** | **14:30 → 14:45** | `ABTG_ORB_Ottimizzato_U30USD_M5_770611_100K.set` (`InpRangeStartMin=30`, `InpRangeEndMin=45`) · cella misurata `r44a` · file prova `R211a` | 🟢 **VIVA** sul demo 100K `50504263`. **ZERO ORB su FTMO** (verificato: `mql5/Presets/FTMO/` ha 12 file, nessun ORB) |
| **ORB BREAKOUT** | **14:25 → 14:30** | `ABTG_ORB_US.set` `770601` NASUSD (`InpRangeStartMin=25`, `InpRangeEndMin=30`, `InpSLMode=0`, `InpTP_R=2.0`, due lati, `InpTP1Pct=50`) | 🔴 **SPENTA a inizio agosto** (`M27_SEGNO_ASPETTATIVA_2026-08-31.md` r.185; `PULIZIA_VPS_10-08.md` r.37: *«bug pendente noto»*) |

---

# 2️⃣ 📐 IL CONFRONTO PARAMETRO PER PARAMETRO — **lui contro noi**

**Colonna "noi"** = la cella che sta per girare (`backtest_pipeline/prove/R211a_parziale_orb_DOW_U30USD.txt`) e i tre preset di `770611`, che **coincidono riga per riga**.
**Colonna "coincide?"** riporta il **contro-esempio** che ho cercato per ogni differenza: se ho trovato la prova che *non* è una differenza, vince quella.

| # | parametro | **PAOLO** `[TRASCRITTO/SCREENSHOT]` | **NOI** (`770611` / `R211a`) | **coincide?** |
|---|---|---|---|---|
| 1 | **box** | 14:30-14:44 srv (classico) | `InpRangeStartHour/Min = 14/30` · `InpRangeEndHour/Min = 14/45` | 🟢 **SÌ, a meno di pochi secondi — e il "quasi" l'ho letto nel codice, non appianato.** `ComputeRange()` r.407-424 lavora su barre **M1** e prende l'intervallo `[iBarShift(14:30), iBarShift(14:45)]` **estremi INCLUSI**; `TryPlace()` scatta al **primo tick con `nowMin >= 14:45`** (r.381), quando la M1 delle 14:45 è **appena nata**. 👉 Il nostro box è `14:30:00 → primo tick delle 14:45`, il suo è `14:30:00 → 14:44:59`. **Differenza: i primi tick di un minuto.** Trascurabile, ma **non è "identico"** |
| 2 | **offset d'ingresso** | `InpEntryPoints = 10.0` `[SCREENSHOT]` | `InpEntryPoints = 10` · `InpK = 1` | 🟢 **SÌ, identico** |
| 3 | **tabella K** | 6 gruppi: indici/oro `1.0` · `225JPY 10` · JPY `0.01` · forex `0.0001` · oil `0.01` `[SCREENSHOT]` | commento di `InpK` r.140: **la stessa identica tabella, stessi sei gruppi** | 🟢 **SÌ** — e **la V17 1.17 non è andata alla deriva dalla V15** su cui è scritto il nostro EA: 4 parametri su 4 uguali |
| 4 | 🔴 **STOP** | **estremo opposto** del box (3 citazioni) | `InpSLMode = 3` = **HALFRANGE** = *entry − 0,5 × ampiezza* | 🔴 **NO, ed è la differenza più grossa.** ⚠️ **Contro-esempio CERCATO E TROVATO A METÀ**: l'enum ha `ORB_SL_OPPRANGE=0` e **il preset `ABTG_ORB_US.set` (770601) usa proprio `InpSLMode=0`** — la regola di Paolo **ce l'abbiamo già in casa**, solo su un'altra sedia e spenta. ❌ Ma NON è inerte sulla 770611: lo stop iniziale entra in `LotByRisk(dist)`, quindi decide **la taglia**, e il trailing EMA9 non lo recupera |
| 5 | 🔴 **TARGET** | **1 : 1** sullo stop | `InpTPMode = 1` (`ORB_TP_RANGE`) · `InpTPRangeMult = 1.5` → target = **1,5 × ampiezza del box** | 🔴 **NO.** ⚠️ **Contro-esempio a metà, e vale oro**: nel preset **`InpTP_R = 1.0` C'È GIÀ**, cioè **il numero di Paolo**, ma è **INERTE** con `TPMode=1` — e il preset lo dichiara a r.28: *«`InpTP_R=1.0` è INERTE con TPMode=1»*. 👉 **Per fare esattamente Paolo bastano DUE toggle, zero valori nuovi**: `InpSLMode 3→0` e `InpTPMode 1→0` |
| 6 | 🔴 **profilo R** *(conseguenza di 4+5)* | stop `= ampiezza + 10` · target `= ampiezza + 10` → **1,0 R**, serve **> 50% di vincenti** | stop `= 0,5 × ampiezza` · target `= 1,5 × ampiezza` → **3,0 R**, serve **> 25%** | 🔴 **Due macchine diverse**, non due tarature. `[INFERITO dall'algebra del codice r.627-640 e r.586-589]` |
| 7 | 🔴 **conferma d'ingresso** | *«apre fuori E chiude fuori»* | `InpUseCloseConfirm = 0` → **pendenti STOP** a `max+10` / `min−10` (r.437-439): scatta **intrabarra**, nessuna chiusura richiesta | 🔴 **NO**, e il contro-esempio **non regge**: accendere `InpUseCloseConfirm=1` **non** riproduce la sua regola. **Letto nel sorgente r.558-559**: `if(c>gRangeHigh) dir=+1; else if(c<gRangeLow) dir=-1;` → confronta la chiusura con il **bordo GREZZO del box**, **NON** con la linea `+10`. E **non guarda l'APERTURA**. 👉 `InpUseCloseConfirm=1` è una **TERZA regola**, né la nostra né la sua. `InpMinBodyPct=50` è un *proxy* di "corpo fuori", ma una candela che **apre dentro** e chiude fuori con corpo grande **passa da noi e sarebbe rifiutata da lui** |
| 8 | 🔴 **lati** | `InpAlertLong = true` **e** `InpAlertShort = true` `[SCREENSHOT]`; ed era short lui sul NAS | `InpAllowShort = 0` | 🔴 **NO — ma NON è un buco: è una MISURA.** `csv_r54/..._U30USD_{IS,OOS}_r54b.csv`, deposito 100k, rischio 1%: **solo SHORT → PF OOS 0,51967 · DD 26,37% · n 100 · −25.603,48** · **due lati → PF 1,04749 · DD 17,16% · n 219** · **solo LONG → PF 1,67419 · DD 9,76% · n 119**. 👉 **Lo short sul Dow distrugge il motore.** Su `NASUSD` lo sweep esiste (R7a/b) ma **non l'ho riletto**: `[NON VERIFICATO IN QUESTA SESSIONE]` |
| 9 | **fine giornata** | `InpTimeEnd = 22:59:59` `[SCREENSHOT]` | `InpEndHour/Min = 21/0` (= 22:00 IT) | 🟠 **NO, e siamo più stretti di ~2 ore.** Mai messo ad asse |
| 10 | **filtro EMA200** | 🔴 **non esiste** nel suo indicatore | `InpUseEma200Filter = 1` (EMA 200 su M5) | 🟠 **NOSTRO IN PIÙ.** Viene da `tradethatswing` (R13), non da ABTG |
| 11 | **tetto sull'ampiezza** | ❌ lo **nega** (*«è un po' largo però … sono dentro il movimento giornaliero»*) | `InpMaxRangePct = 0.8` (scarta il giorno se il box > 0,8% del prezzo) | 🟠 **NOSTRO IN PIÙ** — e **contraddice Emiliano al contrario**: la r.230 del registro (RICORRENTE su 18 live) vuole il tetto, Paolo lo nega. ⚠️ **Contro-esempio CERCATO E NON CONCLUSO, e lo dichiaro**: volevo mostrare che è un quasi-no-op, ma `RangeWideEnough()` (r.500-507) confronta l'ampiezza con `px × 0,8%`, e **lo studio FASE A non salva il prezzo** (`Studio_*.csv`: `idx;dir;risultato_R;H4trend;ampiezza_pt;MAE_pt;MFE_pt;MAE_R;MFE_R;barre`). 🔴 **Quanto morda è `[NON MISURATO]`** — e si chiude con **2 passate** (`InpMaxRangePct` ad asse `{0 · 0.8}`), non con un'opinione |
| 12 | **parziale** | ✅ la fa (*«chiudiamolo in metà»*) | `InpTP1Pct = 0` → **parziale SPENTA** | 🔴 **NO — ed è esattamente l'asse di `R211a`**, già scritto e non ancora girato |
| 13 | **stop in pari** | ✅ sistematico | `InpBreakeven` pinnato a **0** in `R211a` (e **irraggiungibile** con `TP1Pct=0`, r.656-666) | 🔴 **NO.** Nel preset vivo è `true`, ma **il codice lo rende inerte**: `if(InpTP1Pct<=0){...return;}` prima del breakeven. 🟢 Il preset del 22/09 lo dichiara già |
| 14 | **stop in profit su media 50 / Supertrend** | ✅ a mano | `InpUseTrailEMA = 1` su **EMA9 M5** | 🟠 **PARENTE, non uguale**: stesso scopo (trailing strutturale), riferimento diverso |
| 15 | **uscita su chiusura oltre la media** | ✅ *«quando mi si gira così qui devo uscire»* | `InpExitOnEmaClose = 0` | 🟠 **NO**, e la manopola c'è |
| 16 | `InpHistoricalDays = 5` `[SCREENSHOT]` | disegna i **5 box precedenti** sul grafico | **nessun equivalente, e non serve**: è cosmetica dell'indicatore | 🟢 **N/A** — 🔴 **ma spiega da dove nasce il suo "4 su 5"**: vedi §4 |
| 17 | `InpAlertCooldown = 300` `[SCREENSHOT]` | 300 s fra due popup | `InpOneTradePerDay = true` (**più stretto**: 1 operazione/giorno) | 🟢 **N/A**, coperto meglio |
| 18 | **TF** | `NASUSD M5` `[SCREENSHOT]`; M1 lo chiama errore (*«mi ho sbagliato perché ero in M1»*) | `M5` (`InpExecTF = PERIOD_M5`, `@PERIODO M5`) | 🟢 **SÌ** |

### 🧩 Gli orari dello screenshot: **una foto a metà edit**, e lo dico invece di indovinare

`[SCREENSHOT]` `InpTime1 = 14:45:00` *(in modifica)* · `InpTime2 = 14:29:59`.
Nella **V15** documentata in `docs/piani_abtg/ORB_SCHEDA.md` la convenzione è
`InpTime1` = **inizio** (14:25:00), `InpTime2` = **fine** (14:29:59). Con quella
convenzione la coppia dello screenshot è **invertita** (inizio dopo la fine):
👉 **è uno stato intermedio mentre passa dal box breakout al box classico**
`[INFERITO]`, coerente con l'annotazione di Claudio *"in modifica"*.
Per il classico i valori finali sarebbero `InpTime1 = 14:30:00` e
`InpTime2 = 14:44:59`. **Questo NON è confermato: è la domanda D1 del §6.**

---

# 3️⃣ 🧊 IL COST-TO-COST IN COMPRESSIONE — **il motore DIVERSO, ed è il pezzo che vale di più**

## Il meccanismo, come lo descrive lui

| stadio | regola | citazione `[TRASCRITTO]` |
|---|---|---|
| **1. CANCELLO DI REGIME** | **Deviazione standard(20)** contro la **sua SMA(50)**. `nera < gialla` = **COMPRESSIONE**. E la lettura migliore è quando **le due linee sono PARALLELE** | *«La linea nera è la deviazione standard a 50 periodi. Il plot è a 20 periodi»* → poi si corregge: *«l'indicatore che voi avete già presentato è a 20 periodi … La linea gialla è la media delle deviazioni standard a 50 periodi … **la SMA a 50 periodi della deviazione standard**»* · *«**Quando la linea nera sta sotto la linea gialla vuol dire che siamo in una fase di compressione**»* · *«**Quando le due linee stanno parallele** anche se la linea nera è leggermente sopra quella gialla stiamo in una fase di compressione»* |
| **2. LE COSTE** | le **bande di Bollinger (20)**: si lavora **banda ↔ banda**, target la **banda centrale** | *«se stiamo in una fase di compressione il prezzo lo lavorerò **da banda a banda tenendo come obiettivo la banda centrale**»* · *«quando entrate col tocco sotto **quasi sempre** il prezzo torna sulla media delle bande di Bollinger»* |
| **3. CONFERMA D'INGRESSO** | **rifiuto della candela** sulla banda, **oppure** rientro del prezzo **dentro** le bande. Mai sulla candela impulsiva | *«l'ideale sarebbe entrare quando **hai la conferma che è rientrato all'interno delle bande**»* · *«Se uno non entra qui uno entra eventualmente **al rifiuto** oppure entra **quando il prezzo è rientrato dentro**»* · *«Qui dovete aspettare che il prezzo esca e che **rientri**»* |
| **4. FILTRO DI FORMA** | *«pallina da biliardo»*: banda **piatta** = rimbalzo probabile; banda **inclinata** = si prosegue | *«se la pallina da biliardo arriva su questo [inclinato] è più facile che scenda che non rimbalzi … se rimbalza su una **zona piatta** è più facile che torni indietro»* |
| **5. STOP** | **sullo specchio più basso**, MA **mai meno di 1,5 × ATR** | *«Lo stop lo mettete sullo specchio più basso»* · *«**mi va dato perlomeno un ATR e mezzo** … qui l'**ATR era 22** pertanto … lo stop lo metteva a **33**»* 🟢 **il conto torna: 22 × 1,5 = 33** `[TRASCRITTO chiaro]` |
| **6. USCITA** | obiettivo **banda centrale** → **parziale** → **stop in pari** → il resto verso la banda opposta, e se non ci arriva **si esce a mano** | *«obiettivo sempre sulla media, qui **si parzializza, stop in pari**, e poi se va dalla parte opposta bene»* · *«Quando vedi che il prezzo torna indietro **esci a mano**»* |
| **7. USCITA ANTICIPATA** | **Heikin-Ashi** come segnale di uscita | *«mettere le achinacce [Heikin-Ashi]. Perché mi aiutano a capire che quando mi si gira così **qui devo uscire**»* |
| **8. TF** | **M5** *«perché c'è meno rumore»*; dice che va su tutti i TF | *«Lo faccio in M5 … potremmo provarlo in M3 … anche in M15 è la stessa cosa»* |
| **9. 🔴 ORARI in cui la compressione c'è** | **DAX: dalle 17:30 in poi** · **Nasdaq: notte e mattina presto** · **mai il DAX all'apertura** | *«**Il DAX questa si fa bene dalle 17.30 in poi** … Il DAX è sempre in compressione a quest'ora»* · *«Qui il DAX c'è l'apertura e ovviamente **non la puoi fare** sul DAX»* · *«Questa qui è una compressione che va **dalle 6.20 di mattina alle 10.00**… Questo perché la fa NASDAQ»* · *«Dovete aspettare che ci sia la combinazione della **lateralità con la compressione abbinata alla fascia oraria**»* |

🔴 **Fuso degli orari del cost-to-cost: `[INCERTO]`.** Le "17.30", le "6.20" e le
"10.00" **non hanno un fuso dichiarato**, e in questo blocco Paolo legge
l'**orologio del grafico** (= ora server) mentre altrove parla in italiano.
**Non li converto.** Se sono ore server, 17:30 srv = 18:30 IT; se italiane,
16:30 srv. 👉 **È la domanda D2 del §6** — e un orario col fuso sbagliato è
peggio di nessun orario.

## 🔴 LA DOMANDA CHE VALE: il nostro `CostToCost` ha un cancello di regime?

> # **NO. E l'ho verificato per assenza, elencando cosa ho cercato.**

**Letto in `mql5/Experts/ABTG_CostToCost.mq5` (1.210 righe):**

| cosa ho cercato | occorrenze |
|---|---:|
| `iBands` / `Bollinger` | **0** |
| `iStdDev` / `StdDev` / *deviazione* | **0** |
| *compress* / *regime* | **0** (solo nei commenti di `InpMinRangeATR`) |
| filtro **orario** (`hour`, `sessione`, `SessionHour`) | **0** — `TimeToStruct` compare 2 volte, **entrambe per la diagnostica giornaliera**, mai come cancello |
| parziale / breakeven | **0** (`"parziale"` compare 1 volta: è il titolo di un log) |

**Quello che c'è al posto suo** è `gImDir`, il **trend intermedio** ricavato dalla
struttura di Larry Williams (massimi decrescenti → `−1`, minimi crescenti → `+1`),
usato come **cancello direzionale**: r.700-720 rifiuta l'ingresso se la punta
confermata non è dal lato del trend intermedio. 🔴 **È un cancello di TREND, cioè
il CONTRARIO di un cancello di compressione.** E `InpMinRangeATR` (filtro di
larghezza) è **0.0 = spento di default**.

### 👉 Verdetto secondo la regola della SECONDA CACCIA (19/08)

> **Il cancello di regime "deviazione standard(20) sotto la sua SMA(50)" è un
> MECCANISMO NUOVO, non un parametro di un motore esistente.** È quindi un
> **candidato legittimo**, e non ricade nel divieto *«non si allarga sui
> parametri di un motore già dichiarato senza edge»*.

**E arriva nel momento giusto**: il `CostToCost` è **appena stato riaperto**
(`report/PACCHETTO_DEL_MATTINO_2026-09-23.md` righe 69-70, file `R214e`/`R214f`
su `EURJPY` H4). Numeri d'archivio `[MISURATO]`, `scan_h4/scan_ABTG_CostToCost_H4_EURJPY.csv`,
OHLC, rischio 1%, **long**: `exit 0` → **PF 1,34274 · n 194 · DD 9,1158** ·
`exit 2` → PF 1,54592 · n 155 · **DD 12,0482** (*la cella messa in vivaio: «abbiamo
promosso il picco e poi l'abbiamo bocciata per il drawdown del picco»*).

### ⚠️ Tre differenze che NON vanno appiattite fra il suo e il nostro

| | **Paolo** | **`ABTG_CostToCost`** |
|---|---|---|
| cos'è una **"costa"** | **banda di Bollinger** (statistica, si muove a ogni barra) | **punta di swing confermata** (struttura, un livello fisso) |
| **TF** | **M5** (intraday, indici) | **H4** (`InpTF = PERIOD_H1` di default, **H4** nelle celle vive), **forex** |
| **quando si entra** | in **compressione** (volatilità bassa) | alla **conferma di una punta**, **in direzione del trend intermedio** |

👉 **Non sono lo stesso motore con un filtro in più.** Il cancello di
compressione è **innestabile** sul nostro (`iStdDev` + `iMA` sul buffer di
`iStdDev`: due handle, ~15 righe), ma sarebbe un **EA nuovo** se si cambiasse
anche la definizione di costa. **Le due cose vanno separate in due round, non
impastate in uno.**

---

# 4️⃣ 📊 I NUMERI DICHIARATI — **tutti, ed etichettati**

| numero | citazione | etichetta | cosa ne facciamo |
|---|---|---|---|
| **«su cinque operazioni, quattro in profitto»** | *«su cinque giorni … su cinque operazioni, quattro in profitto e una non si sarebbe entrati a mercato»* | 🔴 `[DICHIARATO A VOCE, NON MISURATO]` | 🔴 **E so anche COME è nato, ed è un'informazione**: l'indicatore ha `InpHistoricalDays = 5` `[SCREENSHOT]`, cioè **disegna esattamente 5 box**. Il "backtest" è **la lettura a occhio dei 5 box che lo strumento gli mostrava**, su una settimana di Nasdaq ai massimi storici. **n = 5, una direzione, nessun costo, nessuno slippage.** Non è confrontabile con un PF |
| **«40 punti Nasdaq»** (target *e* breakeven del pre-apertura) | *«ho messo l'obiettivo a 40 punti Nasdaq e me l'ha preso»* | 🔴 `[DICHIARATO]` | è **1 giornata**, e lui stesso: *«oggi è una giornata particolarmente buona»* |
| **«20 pip di piano di trading»** (uscita sul forex) | *«secondo il mio piano di trading sono 20 pip»* | 🔴 `[DICHIARATO]` | è una regola personale, su un'altra strategia (incrocio medie H1/H4) |
| **«obiettivo 50 euro al giorno»** con 0,5 lotti e 3 ingressi | *«Con tre ingressi, entrando con 0,5 li fai 50 euro … Il mio obiettivo di 50 euro al giorno si fa»* | 🔴 `[DICHIARATO]` | 🚩 **conto di sola andata: 3 ingressi × 20 punti, zero stop.** Vedi §5 |
| **«99 su 100 va a retestare»** | *«Con tutto questo imbalance, 99 su 100 va a retestare»* | 🔴 `[DICHIARATO]`, iperbole | non utilizzabile |
| **«ATR 22 → stop 33»** | *«qui l'ATR era 22 … lo stop lo metteva a 33»* | 🟢 `[TRASCRITTO chiaro]` — **il conto torna** (22 × 1,5) | è l'unico numero della live **verificabile internamente**, e verifica |
| **«Claude: su 17 operazioni 13 volte ha indicato la direzione giusta»** | testuale | 🔴 `[DICHIARATO]` | **non ci costruiamo NIENTE sopra.** È un aneddoto su un prompt suo, senza protocollo, senza campione di controllo, senza P/L |
| **spread serali** *«ora a 280 … su [oro] 330»* | *«la sera c'è da considerare lo spread che va a 150»* | 🟠 `[DICHIARATO]`, e **su un altro broker** | 🟢 **Ma conferma la nostra misura**: lo spread schizza fuori sessione. La nostra misura BCM è `spread_flotta/` |

## 🥊 LA SUA CLASSIFICA DEGLI INDICI — **contro la nostra, e NON la appiattisco**

**Lui** `[DICHIARATO]`:
> *«Il meglio del Don Jones è lo Standard & Poor's … vedete che lo Standard &
> Poor's è **sempre profittevole**»* · *«Lo strumento **più facile** per i
> principianti è lo Standard & Poor's perché è quello **più equilibrato**»* ·
> *«il Don Jones è **parecchio erratico** … in questo periodo è **più nervoso**»*
> · *«i Nasdaq **copiano molto** l'SMP»*

**Noi** `[MISURATO]` — studio **FASE A**, `risultati_archivio/studio_apertura/`,
breakout **cieco** del box 14:30-14:45, buffer 200 pt, slippage 100 pt, TP 2R,
~440 giornate per simbolo, **aspettativa in R per operazione**:

| simbolo | aspettativa/op | n | win% | solo LONG | solo SHORT |
|---|---:|---:|---:|---:|---:|
| 🥇 **`U30USD`** (Dow) | **+0,074** | 446 | 41,5% | +0,095 | +0,052 |
| 🥈 `D30EUR` (DAX) | +0,026 | 440 | 36,6% | +0,007 | **+0,045** |
| 🥉 `NASUSD` | +0,001 | 447 | 37,8% | −0,005 | +0,007 |
| 🔴 **`SPXUSD`** | **−0,017** | 444 | 39,6% | −0,022 | −0,013 |

> ## 🔴 **DICIAMO IL CONTRARIO, ED È SIMMETRICO: il suo migliore è il nostro peggiore, e il nostro migliore è il suo "erratico".**

### ⚖️ Sono confrontabili? — **SÌ, e più di quanto pensassi. Ecco la verifica.**

Sono andato a leggere **cosa fa davvero** `ABTG_Apertura_Study_EA.mq5`, invece
di fidarmi dell'etichetta "rottura d'apertura":

- r.29 `InpRangeMinutes = 15` → **box di 15 minuti dall'apertura** = **il box di Paolo**;
- r.203-204 `if(dir>0){ gEntry=gBuy+slip; **gSL=gSell;** }` → **lo stop è il lato OPPOSTO del box** = **la regola di stop di Paolo**, parola per parola;
- un trade al giorno, entrambi i lati, **nessun filtro** (*«cieco»*).

👉 **La FASE A NON è "un altro meccanismo": è l'ORB CLASSICO di Paolo, con il
SUO stop, misurato a vuoto su ~440 giornate per simbolo.** Restano **due**
differenze dichiarate, e non le nascondo:

| | FASE A | Paolo |
|---|---|---|
| **offset d'ingresso** | `InpBufferPts = 200` = **2,00 punti indice** (`Point=0,01`, `[MISURATO]` `STOP_VS_SPREAD_FTMO_2026-09-20.md` §5) | **10 punti indice** |
| **target** | **2 R** | **1 R** |

🔴 **E la differenza di offset apre un buco che riguarda proprio l'SPX.** Ampiezza
media del box di 15 minuti `[MISURATO, FASE A]`: `U30USD` **131,5** punti indice ·
`NASUSD` **85,2** · `D30EUR` **62,5** · 🔴 **`SPXUSD` 15,5**. Con
`InpEntryPoints = 10 × K = 1`, sull'**SPX l'offset d'ingresso vale il 64%
dell'intero box**, contro il **7,6%** sul Dow. **Non è la stessa strategia
applicata a quattro simboli: sull'SPX è una geometria degenere.** 👉 Il fatto
che Paolo trovi l'SPX "il più facile" e noi lo misuriamo il peggiore **può
dipendere da questo**, e si risolve con una misura, non con un'opinione (§6, misura **M3**).

---

# 5️⃣ 🚩 BANDIERE ROSSE — **e la parte che va riconosciuta com'è**

## 🟢 Quello che NON c'è, e va detto perché è un merito

| pratica | verdetto |
|---|---|
| **martingala / mediazione in perdita** | 🟢 **ASSENTE.** Zero occorrenze. Anzi: *«Io **non sono stato avido** … qui mi sono già portato allo stop e il pari»* |
| **togliere / allargare lo stop** | 🟢 **ASSENTE.** Lo stop è sempre presente, e lo muove **solo a favore** (pari → profit). L'unico passaggio in cui **non** mette lo stop è dichiarato ed è **prudenza sullo spread del rollover**: *«io non lo metto ancora lo stop … perché qui potresti che l'allarghino [lo spread]»* |
| **griglia / recovery** | 🟢 **ASSENTE** |
| 🔴 **trucchi per aggirare le prop** | 🟢 **ASSENTI. Zero.** La live non nomina **nessuna** prop, nessun mascheramento di EA, nessuna randomizzazione. *(Regola di casa: si documenterebbe come intelligence e si etichetterebbe VIETATO PER NOI. Qui non c'è niente da etichettare.)* |
| **gestione sana** | 🟢 **SÌ, ed è il pezzo migliore della live**: parziale → stop in pari → stop in profit strutturale → uscita a mano se il target non arriva. È **la stessa ricetta** che `R199B` ha **misurato** funzionare in casa (`InpTP1_ClosePct` 0→50: DD IS −40,9%, DD OOS −13,9%, **e il PF sale**) |

## 🚩 Le tre cose che segnalo lo stesso

| # | cosa | citazione | perché è una bandiera **per noi** |
|---|---|---|---|
| 1 | 🚩 **«per fare soldi con l'Orb Breakout devi entrare con una SIZE GROSSA»** | testuale | 🔴 **È l'esatto opposto del nostro vincolo prop.** Un motore la cui redditività dipende dalla **taglia** e non dall'aspettativa è un motore che **non si schiera su una challenge**. E tocca la casella che resta **di Claudio** (parametri di rischio e taglie). 👉 **Nota d'archivio**: è la strategia della sedia `770601`, **già spenta** |
| 2 | 🚩 **il conto dei «50 euro al giorno» è di sola andata** | *«Con tre ingressi, entrando con 0,5 li fai 50 euro»* | 🔴 Tre ingressi × 20 punti × 0,5 lotti = +50 €, **ma nel conto non compare NESSUNO stop preso**, e lo stop dichiarato è **1,5 × ATR ≈ 33 punti** — cioè **1,65 volte** il guadagno per operazione. Con quel profilo serve **> 62% di vincenti** solo per il pari, prima dei costi |
| 3 | 🚩 **il cost-to-cost su M5 sfonda il nostro cancello di costo** | *«Hai poche pips, ma hai pochi stop»* · *«questo è quasi uno scalping»* | 🔴 **Conto con i nostri numeri misurati.** Frontiera di casa: `stop ≥ 40 × spread`. Con stop = 1,5 × ATR su M5: su `D30EUR` lo spread mediano all'ora 08 è **1,70** punti indice → servono **68 punti** di stop; su `NASUSD` ora 14 è **1,80** → **72 punti**. Un ATR M5 su indice in **compressione** (che è la condizione che il motore CERCA) vale tipicamente **una frazione** di quei numeri. 👉 **Il cancello di regime attira il motore proprio dove il pedaggio è più caro.** `[INFERITO: l'ATR M5 in compressione NON è misurato da noi — è la misura M5 del §6]` |

---

# 6️⃣ 🔴 COSA CAMBIA PER NOI — **ordinato per valore, col costo**

> **Base di costo `[MISURATO il 21/09 sul PC di backtest, `PACCHETTO_DEL_MATTINO_2026-09-23.md` r.55-57]`**:
> modello 4, 8 passate M5 su indice → **caso stretto 20,1 s/passata · caso largo 89,6 s/passata**.
> **Uso il LARGO come tetto**, sempre. 🖥️ **E girano sul PC DI BACKTEST, non sul VPS** (firma del 21/09).
>
> 🛑 **Nessuna di queste è una riga di lancio e nessuna è un file prova: sono
> SPECIFICHE. Ogni round passa dal cancello prima di esistere.**

| # | misura | cosa risponde | passate | **tetto** | perché vale |
|---:|---|---|---:|---:|---|
| **M1** | 🥇 **`InpSLMode` × `InpTPMode` ad asse sulla cella viva del Dow** — `{0,3} × {0,1}`, tutto il resto pinnato a `r44a` | **"La geometria di Paolo (stop opposto + 1:1) batte la nostra (mezzo range + 1,5× range)?"** Quattro celle: `(3,1)` = **l'ancora** `PF OOS 1,65693 · DD 9,9181 · n 119` · `(0,0)` = **Paolo puro** · le due miste isolano quale metà conta | **4** | **6,0 min** | 🔴 **È la differenza più grossa fra lui e noi, e non è mai stata messa ad asse.** E c'è un secondo motivo, **nostro e misurato**: la frontiera `stop ≥ 40 × spread`. Con `HALFRANGE` lo stop sul Dow vale **65,8** punti indice = **32,9 ×** lo spread mediano (2,00) → **sotto la frontiera**. Con `OPPRANGE` vale **141,5** = **70,8 ×** → **sopra**. 👉 **La regola di Paolo, per una ragione che lui non conosce, ci farebbe passare un cancello di casa che oggi non passiamo.** Stesso conto su NAS (23,7× → 52,9×) e DAX (18,4× → 42,7×) |
| **M2** | 🥈 **`InpTP1Pct` — è `R211a`, GIÀ SCRITTO** | la **parziale** che Paolo fa sempre e noi abbiamo spenta | **4** | **6,0 min** | 🟢 **Non serve scriverlo: esiste.** Questa live gli aggiunge **una fonte indipendente a favore** (`R199B` in casa diceva sì, i 28 preset vendor del `DOSSIER_CONFIG_PF_2026-09-22` dicevano no: **Paolo rompe il pareggio 2-1**) |
| **M3** | 🥉 **`InpEntryPoints` ad asse su `SPXUSD`** — `{2, 5, 10, 20}`, cella `r44a` per il resto | **"L'SPX è davvero il peggiore, o l'abbiamo misurato con un offset che vale il 64% del suo box?"** | **4** (+4 per il gemello di controllo sul Dow = **8**) | **12,0 min** | 🔴 **È l'unico modo di chiudere onestamente la contraddizione del §4.** E vale doppio per il **pavimento di frequenza per famiglia** (firma 07/09): la famiglia ORB oggi fa **0,43 op/giorno** sul solo Dow e **ha bisogno di un terzo simbolo** per arrivare a 1,00. ⚠️ **Prerequisito duro**: lo **spread BCM di `SPXUSD` è `[NON MISURATO]`** (`spread_flotta/` ha 3 file su 13 simboli) → senza, il cancello di costo su SPX **non è né verde né rosso**. **Misurarlo costa ZERO passate di tester** (`ABTG_SpreadOrario`) |
| **M4** | 🔧 **Correggere `TryCloseConfirmEntry()`** — confronto con la **linea d'ingresso** invece che col bordo grezzo, + opzione *"apre fuori"* | **"`InpUseCloseConfirm=1` è la regola di Paolo?"** — **no, e l'ho letto nel codice** (r.558-559) | **0 passate** (è **codice**, poi un round da 4) | — | 🟠 **Non è una misura: è un difetto di fedeltà alla fonte.** Oggi quella manopola implementa una **terza** regola che **nessuna fonte ha mai chiesto**. 🔴 **Richiede una ricompilazione ⇒ passa dal cancello ⇒ NON si tocca prima del 1° ottobre se non è sulla strada di una sedia schierabile.** Va **scritta nel registro**, non fatta oggi |
| **M5** | 🧊 **Cancello di compressione sul `CostToCost`** — `iStdDev(20) < iMA(50)` sul buffer di `iStdDev` | **"Il regime di compressione aggiunge qualcosa a un motore che oggi entra sempre?"** | **6-8** (acceso/spento × le 3 uscite) | **[NON STIMATO]** — è **forex H4 modello 1**, base di costo diversa da quella degli indici | 🟢 **Meccanismo NUOVO, ammesso dalla regola del 19/08.** 🔴 **MA non prima che `R214e`/`R214f` abbiano risposto**: si innesta un filtro su una **base nota**, non su una base che si sta ancora misurando. **Un asse alla volta.** 🔴 E il suo uso **intraday su M5 indici è bloccato a monte dal §5-🚩3**: lì servirebbe prima l'**ATR M5 in compressione misurato**, che **non abbiamo** |
| **M6** | 📌 **Correzione documentale** di `REGISTRO_TEST.md` r.779-800 | la "finestra contesa" **non è contesa**: sono due strategie, e le abbiamo tutte e due | **0** | ~0 | 🟢 **Chiude una riga aperta dal 04/09 senza spendere un minuto di macchina.** ⚠️ **NON l'ho applicata io**: tocca il registro dei verdetti, e la consegna di questo turno è la scheda. **Proposta, non azione** |

### ❌ Quello che questa live **NON** cambia, dichiarato

- ❌ **Non riapre il lato SHORT dell'ORB sul Dow.** Il fatto che il suo indicatore
  abbia `InpAlertShort = true` non è una misura: la **nostra** misura c'è ed è
  `PF OOS 0,51967 · DD 26,37%` (`r54b`). Niente in questa live la contraddice.
- ❌ **Non riapre la sedia `770601`** (ORB breakout pre-apertura): Paolo stesso la
  dichiara **la più difficile**, e la sua unica via alla redditività è **la taglia**.
- ❌ **Non tocca nessun criterio.** Zero soglie mosse, zero cancelli ammorbiditi.
- ❌ **Non produce nessun preset, nessuna riga, nessun file prova.** Come da mandato.

---

# 7️⃣ ❓ LE DOMANDE PER CLAUDIO — gli screenshot ai minuti giusti

| # | cosa chiedo | perché serve **davvero** |
|---|---|---|
| **D1** 🔴 | Lo screenshot del pannello **A MODIFICA FINITA** (`InpTime1` e `InpTime2` definitivi) — e, se esiste, anche quello del preset **"ORB DAX"** | Nello screenshot che ho, `InpTime1 = 14:45:00` e `InpTime2 = 14:29:59` sono **invertiti** rispetto alla convenzione V15 (inizio → fine): è una **foto a metà edit**. Con i valori finali chiudo **l'ultimo dubbio** sulla mappatura box↔strategia. 🔴 **È la stessa richiesta Q1 del referto del 03/09, ancora aperta** |
| **D2** 🔴 | **In che fuso** sono le ore del cost-to-cost: *«DAX dalle 17.30»*, *«dalle 6.20 alle 10.00»*, *«qui siamo alle 15.00»* — orologio del **grafico** o ora **italiana**? | Un'ora sbagliata rende **inutilizzabile** l'intera fascia oraria del motore. Basta **uno screenshot del grafico** in quel punto della live: l'asse dei tempi in basso **è** la risposta |
| **D3** 🟠 | Lo screenshot dei **settaggi dell'indicatore Standard Deviation** — al minuto in cui dice *«Prendetevi questa tavola di settaggio»* | Paolo si **auto-corregge a voce** sul periodo (*«a 50 periodi»* → *«il plot è a 20 periodi»* → *«questi coniugano per ultimi 50»*). La trascrizione **non basta** per sapere se la nera è StdDev(20) e la gialla SMA(50) **di quel buffer**, o altro. 🔴 **Senza questo, `M5` non si può scrivere: si implementerebbe un indicatore indovinato** |
| **D4** 🟠 | Lo screenshot del **pannello delle bande di Bollinger** (periodo e deviazioni) | Dice "media a 20 periodi" ma **non dice le deviazioni** (2,0? 2,5?). Serve per `M5` |
| **D5** 🟢 | Quando riesci: la **misura dello spread di `SPXUSD`** (`ABTG_SpreadOrario`) | **Costo ZERO passate di tester**, e **sblocca `M3`** — cioè l'unico candidato terzo simbolo che può portare la famiglia ORB al pavimento di 1,00 op/giorno |
| **D6** ⚪ | La **dashboard Python** e il **prompt volumetrico** di cui parla, se li distribuisce | Solo per archivio. 🔴 **Nessuna misura ci verrà costruita sopra**: il *«13 su 17»* resta `[DICHIARATO]` |

---

# 8️⃣ 🧪 IL CONTRO-ESEMPIO, COSTRUITO PRIMA DELLA CONSEGNA

**Per ogni differenza dichiarata sopra ho cercato la prova che NON fosse una
differenza. Dove l'ho trovata, ha vinto lei.** Ecco il tabellone, incluse le
volte in cui il contro-esempio mi ha corretto:

| differenza dichiarata | contro-esempio cercato | esito |
|---|---|---|
| "box diverso da Paolo" | leggere `ComputeRange()` + lo scheduling di `TryPlace()` | 🟢 **VINCE QUASI**: stesso intervallo, **più i primi tick della M1 delle 14:45** (estremi inclusi su M1). Non è una differenza operativa, **ma non è un'identità e non la scrivo come tale** |
| "la finestra ORB è contesa" (registro, 04/09) | rileggere la trascrizione cercando **due** strategie invece di una | 🟢 **VINCE IL CONTRO-ESEMPIO**: non è contesa, sono **due strategie**. E il registro r.792 è **sbagliato** sulla 770611 (letto nei preset) |
| "noi non abbiamo lo stop di Paolo" | grep dell'enum + di tutti i preset ORB | 🟠 **VINCE A METÀ**: `ORB_SL_OPPRANGE=0` **esiste ed è usato** in `ABTG_ORB_US.set`. La differenza è **fra Paolo e la cella viva**, non fra Paolo e il repo |
| "noi non abbiamo il target 1:1" | grep di `InpTP_R` nei preset | 🟠 **VINCE A METÀ**: `InpTP_R = 1.0` **è già scritto nel preset vivo**, ma è **inerte** con `TPMode=1` (dichiarato dal preset stesso). Due toggle, zero valori nuovi |
| "il nostro tetto sul range ci allontana da Paolo" | volevo mostrare che è un quasi-no-op con le ampiezze misurate | 🔴 **NON L'HO POTUTO COSTRUIRE, e lo dico invece di scriverlo lo stesso**: la soglia è in **% del prezzo** e lo studio FASE A **non salva il prezzo**. Resta `[NON MISURATO]`, con 2 passate per chiuderlo |
| "`InpUseCloseConfirm=1` ci allinea a Paolo" | **leggere il ramo**, r.558-559 | 🔴 **IL CONTRO-ESEMPIO FALLISCE, e capovolge la conclusione comoda**: confronta col bordo **grezzo**, non con la linea `+10`, e **non guarda l'apertura**. Accendere quella manopola **non** ci allinea |
| "FASE A misura un altro meccanismo, non confrontabile" | **leggere l'EA dello studio**, r.29 e r.203-204 | 🔴 **IL CONTRO-ESEMPIO FALLISCE**: box 15', **stop sul lato opposto** ⇒ **è l'ORB di Paolo, col suo stop**. 👉 **La contraddizione sull'SPX è REALE e va guardata in faccia**, non scaricata su "sono cose diverse" |
| "il `CostToCost` ha già un cancello di regime" | grep di `iBands`, `iStdDev`, *compress*, *regime*, filtri orari | 🔴 **IL CONTRO-ESEMPIO FALLISCE**: **0 occorrenze**. `gImDir` è un cancello di **trend**, cioè l'opposto. **Il meccanismo è davvero nuovo** |
| "il cost-to-cost M5 è un candidato" | applicargli **il nostro** cancello `stop ≥ 40 × spread` | 🔴 **LO BOCCIA A MONTE** sugli indici: servono 68-72 punti indice di stop, e il motore **cerca** la compressione. Il candidato è il **cancello**, non il motore M5 |
| "la 770601 è una sedia viva" (registro r.792) | grep `770601` nei referti | 🔴 **IL REGISTRO SBAGLIA**: *«spento a inizio agosto»* (`M27_SEGNO_ASPETTATIVA_2026-08-31.md` r.185) |
| "l'ORB è schierato sulla challenge" | `ls mql5/Presets/FTMO/` | 🔴 **NO: 12 preset, ZERO ORB.** Il motore ORB con il **miglior PF fuori campione del repo** (1,65693) **non è in campo** |

---

# 9️⃣ 📚 LE FONTI, per nome

**Trascrizione**: `LIVE_PAOLO_22.09.26_2026-09-22_21-42-00-412.txt` (432 righe).
**Screenshot**: `ORB_Indicator_V17 1.17` su `NASUSD M5`, trascritti da Claudio.
**Codice**: `mql5/Experts/ABTG_ORB_Ottimizzato.mq5` (r.121 enum SL · r.140 tabella K ·
r.437-439 pendenti · r.558-559 close-confirm · r.586-589 TP · r.612-616 `EntryDistance` ·
r.627-640 SL · r.656-666 parziale/breakeven) · `mql5/Experts/ABTG_CostToCost.mq5` ·
`mql5/Experts/ABTG_Apertura_Study_EA.mq5` (r.29, r.203-204).
**Preset**: `ABTG_ORB_Ottimizzato_U30USD_M5_770611_100K.set` · `conto_reale/..._770611_REALE.set` ·
`sedie_piccolo/recupero2/sedia_..._770611.set` · `ABTG_ORB_US.set` · `mql5/Presets/FTMO/` (12 file).
**Misure**: `risultati_prove/ABTG_ORB_Ottimizzato/r44/*_U30USD_{IS,OOS}_r44a.csv` ·
`risultati_archivio/csv_r54/*_U30USD_{IS,OOS}_r54b.csv` ·
`risultati_archivio/studio_apertura/Studio_{U30USD,SPXUSD,NASUSD,D30EUR}_RIEPILOGO.csv` ·
`risultati_archivio/spread_flotta/` · `report/STOP_VS_SPREAD_FTMO_2026-09-20.md` §5 ·
`report/PACCHETTO_DEL_MATTINO_2026-09-23.md` §1 e §2.2 ·
`report/CHI_ALTRO_PUO_SCHIERARSI_2026-09-22.md` §1 ·
`backtest_pipeline/prove/R211a_parziale_orb_DOW_U30USD.txt`.
**Precedenti su Paolo**: `caccia_strategie/ANALISI_LIVE_PAOLO_{2026-08-25,2026-09-03,2026-09-08}.md` ·
`backtest_pipeline/REGISTRO_TEST.md` r.779-835 · `docs/piani_abtg/ORB_SCHEDA.md`.
