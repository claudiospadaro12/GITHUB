# 🪑 `EMA200` DOW — **CHE COSA MANCA ESATTAMENTE PER SCHIERARLA**

> ## 🎯 LA RISPOSTA IN SEI RIGHE
> 1. 🟢 **Il certificato e' soddisfatto per 3 requisiti su 5** (PF · simboli gemelli · DD). 🔴 Mancano **la gestione dell'uscita mai messa ad asse** e **il TF mai cambiato su U30USD**. E il terzo buco ha un numero, e va detto col numero: **l'IS in POSIZIONI e' stimato 102-118 contro un pavimento di 150 — cioe' SOTTO**, e oggi e' una **stima**, non una misura.
> 2. ⏱️ **E tutto quello che manca costa MENO DI UN'ORA DI TESTER.** Non una notte: **110 passate** (conteggio rifatto al §7: la prima stesura ne diceva 64 e poi 76, e nessuno dei due era il conto giusto — **classe 264**), e il metro e' misurato in casa (R112: **16 passate in 0,1 ore** = 22 s/passata sulla stessa cella, stesso banco) ⇒ **~40 minuti**. 🔴 **Questa sedia e' ferma da un mese per ~40 minuti di macchina.**
> 3. 🆕 **Ho MISURATO tre numeri che ieri erano `[NON MISURATO]`**, senza lanciare niente, leggendo i per-trade che erano già in archivio: **le posizioni vere (257)**, **lo stop pieno in punti indice sulla finestra di backtest (gamba 2 mediana 88,2 · gamba 1 132,6, su 33 coppie)** e **la scala di slippage completa**.
> 4. ✅ **LO STRESS DI COSTO LO PASSA, e con margine**: a **2 punti indice** di slippage su OGNI ingresso fa ancora **PF 1,4524 · +20,65% · DD 8,09%**; il muro del 10% si rompe solo a **7,32 punti**. Per i criteri congelati stamattina: **PASS**.
> 5. 🔴 **Il cancello del COSTO (C3) resta FRAGILE, ma il numero vero e' migliore di quello del dossier**: la gamba 2 fa **37,1× lo spread** di mediana (non 34-41× da 3 eventi), **41,8× in sessione** e **33,2× di notte**. Sopra i 30×, sotto i 40×: **FRAGILE, non bocciato.**
> 6. 🔴 **E c'e' un rilievo nuovo che cambia un cancello**: la **frequenza di FAMIGLIA** passa il pavimento (1,245) **solo contando `971501` EMA200_Ott XAUUSD**, che il **23/08 e' stato firmato «prop: NO a nessuna taglia»** (DD 45,91%). La famiglia degli **SCHIERABILI** fa **0,945 posizioni/giorno**: **sotto 1,00**. ⚠️ E quel 1,245 **mescola le unita'** (§5.1).
> 7. 🚩 **LA COSA CHE VA DAVANTI A CLAUDIO INSIEME ALLE TRE FIRME, e che nella prima stesura era dietro un rimando rotto**: **l'edge di questo motore esiste su UN SIMBOLO SOLO.** Sui quattro indici azionari gemelli fa **6 celle positive su 330** (D30EUR **0/80**, E50EUR 0/83, F40EUR 0/81, NASUSD 2/83, SPXUSD 4/86) contro **98/98 sul Dow** — e **non e' il regime**, perche' nella stessa finestra il DAX era anch'esso in toro. 👉 **§4-bis.**
> 8. 🔴 **L'unico buco STRUTTURALE del pacchetto, e nessun backtest lo chiude**: il **flottante** e il **massimo di posizioni contemporanee** sono **[NON MISURABILI]** dai per-trade (c'e' solo `close_time`). Su una sedia **a raffiche** — 2-8 posizioni in un giorno, e ferma 2 giorni su 3 — quella e' **la grandezza che decide il muro giornaliero di una prop**.

_Compilato il **12/09/2026** in **sola lettura d'archivio** + post-processing sui CSV già esistenti. **Nessun backtest lanciato. Nessun EA, preset, magic o sedia viva toccato. Nessuna promozione, nessuna accensione, nessuna spesa.** Criteri congelati PRIMA dei numeri in `backtest_pipeline/prove/COLLAUDO_EMA200_DOW_CRITERI.md` (commit `caaf5d1`, **prima** di questo referto)._

---

# 1. 📋 IL CERTIFICATO — i cinque requisiti, uno per uno

Metro: la regola del **09/09/2026** (`CLAUDE.md`, «IL CERTIFICATO DI MORTE»). Qui è usata al contrario: non per dichiarare morto un candidato, ma per dire **che cosa manca a uno vivo**.

| # | requisito | esito | il numero e il file | se NO: la via più corta, e quanto costa |
|---|---|---|---|---|
| **1** | **PF misurato** | ✅ **SI** | **OOS 1,52365 · IS 1,20110**, tick reali, dep. 100k · `risultati_prove/ABTG_EMA200/ABTG_EMA200_U30USD_{IS,OOS}_r31.csv` · riprodotto 3× (R31→R110→R112, primo **G0-B** della macchina). E in più: **84 celle su 84 positive** a tick sull'intero periodo (`risultati_valid_ABTG_EMA200_H1_realtick/..._U30USD.csv` — 31 long-only, 26 short-only, 27 L+S; le 53 celle inerti sono **tutte e 53** `AllowLong=0 E AllowShort=0`, cioè **motore spento**, non spazio sterile). Cella viva **+2.502,70**, picco **+2.796,85** → **7ª su 84** (e **7ª su 27** fra le L+S): **lontana dal picco, sopra il centro**. ⚠️ **E VA QUALIFICATO**: le colonne che variano in quella griglia sono `AllowLong`, `AllowShort`, `Order1Atr`, `Order2Atr`, `TP_RR` — **tutte d'INGRESSO, zero d'uscita**. **L'84/84 è un altopiano dell'INGRESSO e non dice NIENTE sul requisito 3** | — |
| **2** | **n e DD** | 🟠 **SI in DEAL · PARZIALE in POSIZIONI** | **DD equity OOS 7,8323% · IS 5,7325%** (tick, 1%) ✅. **n OOS = 517 deal = 257 POSIZIONI**, 🆕 **misurato oggi** contando i `position_id` su `risultati_archivio/R112_CORSA_20260826/pertrade_00_metro_763400.csv` (rapporto **2,0117**). 🔴 **n IS in posizioni = [NON MISURATO]**: il per-trade IS non esiste in archivio; stima **102-118** → **sotto il pavimento di 150** | **`prove/COLLAUDO_EMADOW_02_pertrade_IS.txt`** — 1 cella × 2 gemelli = **2 passate, una sola gamba**. Costo: **~1 minuto** |
| **3** | **gestione dell'uscita messa ad asse** | 🔴 **NO** | Verificato colonna per colonna su **tutti** i CSV di questo EA: su U30USD sono mai variati solo `InpOrder1Atr`, `InpOrder2Atr`, `InpTP_RR` (R29b, R28) e i due lati (R110/R112). **`InpTP1Pct`, `InpBreakeven`, `InpUseTrailing`, `InpSLatr`, `InpPendingExpiryBars` non hanno MAI variato in NESSUN CSV di `ABTG_EMA200`, su NESSUN simbolo.** La macchina che produce il rapporto 2,01 deal/posizione — parziale 50% + breakeven + trailing EMA14, **cioè quella che fa il DD** — non è mai stata confrontata con un'alternativa **`prove/R136a/b/c/d_*_U30USD.txt`** — quattro assi (`InpSLatr` · `InpTP1_ATRmult` · `InpTP1Pct` · `InpUseTrailing`), **40 passate**, ~15 min. 🤝 **Scritti da un ALTRO agente lo stesso pomeriggio** (commit `63e10ba`): i miei `03`/`04` sono **RITIRATI** in loro favore — vedi §7.1 |
| **4** | **simboli gemelli provati** | ✅ **SI, ampiamente** | **Screening H1 su 48 simboli**: `risultati_prove/risultati_scan_ABTG_EMA200_H1/` — U30USD **98/98 celle positive**, XAUUSD 58/86, 225JPY 27/78, e sugli altri indici **D30EUR 0/80 · E50EUR 0/83 · F40EUR 0/81 · NASUSD 2/83 · SPXUSD 4/86**. **A tick**: U30USD 30/30 PASS, EURUSD 7/30, XAUUSD 0/30 IS, **225JPY 30/30 IS e 0/30 OOS** (`REFERTO_ROUND32_EMA200_ORO_NIKKEI.md`) | — 🚩 **e la risposta è scomoda: leggere il §4-bis.** Il requisito è soddisfatto *come misura*, ma **quello che la misura dice è che l'edge sta su un simbolo solo** |
| **5** | **TF cambiato almeno una volta** | 🔴 **NO su U30USD** (SI sul motore) | L'asse `InpTF` (11 celle, M15→D1) è girato **a tick reali** su **AUDJPY, GBPJPY, GBPUSD, SPXUSD, XAUUSD** e in OHLC su 200AUD. 🔴 **Su U30USD mai**: R29b, R31, R103, R110, R112, R114 hanno tutti `InpTF=16385` fisso. **La sedia che stiamo per schierare gira sull'unico TF che non è mai stato confrontato con un altro, sul suo simbolo** | **`prove/COLLAUDO_EMADOW_05_tf_U30USD.txt`** — 7 membri enum (M15…H4) × 2 = **14 passate**. Costo: **~6 minuti** |

> ### 🔴 IL VERDETTO DEL CERTIFICATO, alla lettera
> **3 requisiti su 5 pieni, 1 parziale, 1 mancante.** Per la regola del 09/09 questo NON è un candidato archiviabile e NON è un candidato completo: è **«non ancora misurato» su due voci**, e le due voci **costano 28 passate in tutto**. Nessuna delle due è ferma per un numero **brutto**: sono ferme per un numero **mai fatto**.

---

# 2. 🔢 DEAL O POSIZIONI? — **517 deal = 257 POSIZIONI**, misurato

Classe 226, verificata qui sul file che ce l'aveva già scritta dentro.

```
pertrade_00_metro_763400.csv   517 deal ->  257 posizioni   rapporto 2,0117
pertrade_01_short_r1_763410    302 deal ->  140 posizioni   rapporto 2,1571
pertrade_02_short_r2_763420    315 deal ->  140 posizioni   rapporto 2,2500
pertrade_03_short_r3_763430    324 deal ->  140 posizioni   rapporto 2,3143
distribuzione deal/posizione (00_metro): 90 posizioni a 1 deal, 147 a 2,
                                          1 a 4, 1 a 5, 5 a 6, 10 a 7, 3 a 8
```

### 🔬 IL CONTRO-ESEMPIO, costruito prima di consegnare il numero
Se stessi leggendo il file sbagliato, o se stessi contando male, la **somma dei P/L** non tornerebbe. L'ho ricostruita partendo da 100.000 e sommando i 517 deal in ordine di chiusura:

| grandezza ricostruita da me | valore | numero in archivio | esito |
|---|---:|---:|---|
| saldo finale | **123.321,47** | +23.321,47 (`_r31.csv`) | ✅ **al centesimo** |
| Profit Factor | **1,52365** | 1,52365 | ✅ **a 5 decimali** |
| peggior giornata (chiusi) | **−2.448,42** il **23/06/2026** | −2,448% (R112) | ✅ **al centesimo** |
| posizioni/giorno feriale OOS | **0,945** (257 / 272) | 0,945 (dossier 09/09) | ✅ **identico** |

👉 **Il numero vero delle POSIZIONI in OOS è 257, e passa il pavimento dei 150.** 🔴 **L'IS no**: 237 deal, per-trade assente, stima **102-118**. Per arrivare a 150 il rapporto dovrebbe scendere a **1,58**, fuori dalla banda misurata su quattro varianti della stessa cella. **Ma è una stima, e su una stima non si chiude un cancello**: la misura costa **2 passate** (prova 02).

---

# 3. 🗓️ IL REGIME — **uno, e si chiama toro 2024-2026**

| voce | valore |
|---|---|
| finestra di **tutti** i round (R28, R29, R31, R103, R105, R110, R112, R114) | **2024.09.26 → 2026.06.30** = **21 mesi**, split 40/60, OOS **2025.06.12 → 2026.06.26** (primo e ultimo close misurati sul per-trade) |
| regime contenuto | 🔴 **UNO: indici americani in salita.** Non sono otto misure: è **una finestra misurata otto volte** |
| è il famoso `@DAQUANDO 2024.09.26`? | ✅ **SI, è esattamente quello** — il pavimento dei tick BCM sugli indici (sonda 17/08, stato **COMPLETO** = il broker non ha di più) |
| Emendamento **C** (4 finestre: toro/orso/laterale/crollo) | 🔴 **NON ESEGUIBILE IN CASA** sugli indici. Non «non fatto»: **non esiste il dato**. 2008, 2020 e 2022 su U30USD da BCM non ci sono |

### 🎁 MA C'È UN REGALO IN ARCHIVIO CHE NESSUNO HA APERTO
**Quattro file prova esistono dal 09/09 e non sono mai stati lanciati**:
`prove/LATI_A1_EMA200_U30USD_DISCESA_{long,short}.txt` e
`prove/LATI_A2_EMA200_U30USD_TORO_{long,short}.txt`.
Misurano **LATO × REGIME** sulla **discesa vera** dentro i 21 mesi
(**2025.02.01 → 2025.04.30**) con il **toro** come termine di paragone, e hanno
già dentro la **sentinella** (devono riprodurre i bersagli R110: `+5.670,52 / PF 1,24103 / DD 8,8973% / n 241` per il long puro e `+23.321,47 / PF 1,52365 / DD 7,8323% / n 517` per L+S).

👉 **Costo: 8 passate. ~3 minuti.** È la **prova di robustezza di regime più vicina** che il progetto può avere sugli indici, era già scritta, gatata e firmata nei criteri — e sta lì da tre giorni. **Questa è la voce con il miglior rapporto valore/costo di tutto il pacchetto.**
⚠️ E si dice cosa **non** è: una discesa di 60 giorni **non** è la prova di regime dell'Emendamento C. È una prova di **robustezza**. Chiamarla diversamente sarebbe barare.

---

# 4. 💸 IL CANCELLO DEL COSTO (C3) — **misurato sulla finestra, non su 3 eventi**

Il dossier del 09/09 aveva il numero giusto ma il campione debole (**3 stop pieni del conto vivo**). Il file che aveva già la risposta era il per-trade di R112.

### 🔬 Come ho isolato gli stop pieni, e come ho provato che l'ho fatto bene
Posizioni chiuse in **un solo deal**, in perdita, con perdita fra il **0,45% e 0,55% del saldo** al momento (il rischio per gamba è 0,5%): **77 eventi**. Poi il contro-esempio:

- **se stessi catturando uscite in trailing invece di stop pieni**, le due gambe dello stesso segnale **non** starebbero in rapporto 1,5 (`stop1 = 1,50·ATR`, `stop2 = 1,00·ATR`). Sulle **33 coppie** chiuse nello stesso istante il rapporto mediano misurato è **1,4995** (attesi 1,5000). ✅
- **se il valore del punto fosse 8,61 €** invece di 0,861 (il conflitto di `CONTRACT_SIZE` in R114), gli stop uscirebbero a **8,8 punti indice** di mediana: assurdo contro un ATR misurato di 65-120. ✅ Vince **0,861 €/punto/lotto**.

### 📏 I NUMERI, e la fascia oraria conta (ora **SERVER** BCM = ora italiana − 1)

| gamba | stop pieno MISURATO (punti indice) | rapporto stop/spread mediano | in sessione **14-21** | di notte/Europa **0-13 + 23** |
|---|---|---:|---|---|
| **1** (1,50·ATR) | mediana **132,6** (min 61,7 · max 311,5) | **55,6×** | **62,7×** ✅ (21/24 celle sopra 40×) | **49,5×** ✅ (7/9) |
| **2** (1,00·ATR) | mediana **88,2** (min 42,6 · max 204,0) | **37,1×** | **41,8×** 🟠 (12/24) | **33,2×** 🔴 (2/9) |
| **tutti gli stop** | mediana **101,5** | **46,5×** | — | 50 su 77 (**64,9%**) sopra 40× alla mediana · **44,2%** al p95 |

**Frontiera `40 × spread`** dalla misura di 64,7 M tick (`spread_flotta/spread_orario_U30USD.csv`): **76-80 punti** nelle ore 14-21, **104-112** nelle ore 0-13 e 23.

### 🟠 VERDETTO C3 — e **dichiaro un irrigidimento nato DOPO i numeri**
🔴 **Alla lettera dei criteri congelati stamattina, il C3 sarebbe PASS**: la clausola dice *«entrambe le gambe sopra 40× alla mediana della fascia 14-21»*, e in quella fascia le mediane misurate sono **62,7×** e **41,8×**. **Entrambe sopra.**
**Io ho scritto FRAGILE**, e il motivo — *«solo 12 celle su 24 ci arrivano»* — **NON È nei criteri**. Quindi: ⚠️ **tengo il FRAGILE perché è il verdetto prudente, ma lo dichiaro per quello che è: un irrigidimento deciso a numeri visti.** Il difetto sta nei **criteri**, non nella misura: la clausola PASS nomina la fascia 14-21, la clausola FRAGILE parla di «mediana» senza dire *quale* fascia, e la notte resta fuori da entrambe. **Va riscritta prima del prossimo round, non dopo questo.**
- 🔴 **E correggo un denominatore mio, che gonfiava il difetto di 1,7×**: avevo scritto *«33,2×, dove cade il 44,3% delle uscite»*. Il **44,3%** sono **tutte le uscite**; sugli **stop pieni** — che sono gli eventi di cui sto misurando la distanza — la notte è **20 su 77 = 26,0%** (57 su 77 in sessione). **Il difetto notturno è reale e vale il 26%, non il 44%.**
- 🟢 **Correzione al dossier, a favore della sedia**: «la gamba 2 non arriva a 40× in nessuna fascia» era vero sui **3 eventi del campo** (65,5-78,0 pt). Sulla **finestra intera** la gamba 2 mediana è **88,2 pt** e in sessione **passa**. Il difetto non è la geometria: è **l'orario**.
- 🔧 E la riparazione **non** è `InpSLatr` (R118: costa edge in modo **non riproducibile**, OOS 29/56 = una monetina). È **`InpMaxSpread`**, che **l'EA ha già** (`.mq5` r.507, confronto in **punti MT5**): tagliare le ore larghe **senza toccare la geometria**. È l'asse della prova **00**.
  ⚠️ **E porto qui il limite che avevo dichiarato nel file prova e non nel referto**: `SpreadOK()` è chiamata al **r.325**, cioè al momento del **SEGNALE** (una volta per barra, prima di piazzare i due LIMIT). **Filtra l'INGRESSO, non l'USCITA** — e lo stop che sto misurando lo si paga **in uscita**. Quindi `InpMaxSpread` può evitare di *aprire* quando lo spread è largo, **non** può evitare di *chiudere* quando lo è. È una riparazione **parziale per costruzione**, e va proposta così.

---

# 4-bis. 🚩 **L'EDGE STA SU UN SIMBOLO SOLO** — il rischio che il requisito 4 nasconde dietro una spunta verde

Il requisito 4 del certificato è **soddisfatto**: i gemelli sono stati provati, e in abbondanza. 🔴 **Ma quello che la misura DICE è un rischio, e nella prima stesura di questo referto non era scritto da nessuna parte** — il rimando mandava al §4, che parla del costo, e la voce mancava anche nell'elenco finale delle cose scomode. Rimedio qui, col numero.

**Screening H1, `risultati_prove/risultati_scan_ABTG_EMA200_H1/` — celle positive sui quattro indici azionari gemelli:**

| simbolo | celle positive | best PF | best DD |
|---|---:|---:|---:|
| **U30USD** (la sedia) | **98 / 98** | 1,48331 | 6,0120% |
| `NASUSD` | **2 / 83** | 1,02854 | 8,7965% |
| `SPXUSD` | **4 / 86** | 1,04838 | 6,4816% |
| `D30EUR` | **0 / 80** | 0,92488 | — |
| `E50EUR` | **0 / 83** | 0,81792 | — |
| `F40EUR` | **0 / 81** | 0,87215 | — |
| **totale gemelli** | 🔴 **6 / 330** | | |

### 🔬 IL CONTRO-ESEMPIO: «è il regime, non il simbolo»?
È la spiegazione alternativa ovvia — *«nel 2024-2026 saliva il Dow, gli altri no»* — ed **è falsa, misurata**: nella **stessa finestra** il **DAX era anch'esso in toro**, e fa **0 celle su 80**. Se fosse il regime, `D30EUR` dovrebbe assomigliare a `U30USD`. Non gli assomiglia: gli è **opposto**. 👉 **Quindi non è il regime: è il simbolo.** E c'è il precedente in casa, con la stessa ampiezza: **`225JPY` 30/30 promosse in IS e 0/30 in OOS** (R32) — *«questo motore ha già dimostrato di poter ribaltare una regione intera»*.

### 👉 COSA VUOL DIRE PER LO SCHIERAMENTO, senza addolcire
1. **Non c'è un secondo simbolo a cui appoggiarsi**: la famiglia non si allarga per decisione, si allargherebbe solo trovando un numero che **oggi non c'è** (e lo screening dice dove non cercarlo).
2. **Quindi il pavimento di frequenza di famiglia non è riparabile con un gemello** (§5) — e questo lega i due cancelli fra loro.
3. **E l'edge su un simbolo solo è, per una prop, un rischio di modello**: se l'inefficienza è del Dow e il Dow cambia carattere, non c'è diversificazione dentro la famiglia che attenui. **Non è una bocciatura** — 98/98 celle a tick sono la cosa più solida della flotta — **è una concentrazione, e va firmata sapendola.**

---

# 5. 📊 LA FREQUENZA — **e qui c'è il rilievo nuovo**

| unità | sedia sola | famiglia come la conta il dossier | pavimento 1,00 |
|---|---:|---:|---|
| **uscite/giorno feriale** | **1,901** (517/272) | 1,850 | ✅ passa |
| **posizioni/giorno feriale** | **0,945** (257/272) | **1,245** (0,945 + 0,30 di `971501`) | 🟠 passa **solo come famiglia** |

### 🔴 LA FAMIGLIA PASSA CONTANDO UNA SEDIA CHE NON È SCHIERABILE
Lo 0,30 op/giorno che porta la famiglia da 0,945 a 1,245 è di **`971501` = `ABTG_EMA200_Ottimizzato` XAUUSD H4**. E su quella sedia il verbale è già scritto: **DD 45,91% a rischio 1% su 22 anni**, e la riga di `CENSIMENTO_CONTRATTI.md` r.231 dice testualmente **«prop: NO a nessuna taglia» (firma 23/08)**.

### ⚠️ 5.1 — E QUEL **1,245 MESCOLA LE UNITÀ**: non è un numero omogeneo
Lo **0,30 op/giorno** di `971501` viene da **610 `Trades`** su 6,5 anni (`CENSIMENTO_CONTRATTI.md` r.231, via R103): e `Trades` **conta DEAL di uscita**, non posizioni (**classe 226**, la stessa che qui ha già ribaltato un cancello). Quindi **1,245 = 0,945 posizioni + 0,30 deal**: due unità sommate.
- **In posizioni**, assumendo per `971501` un rapporto deal/posizione ≈ 2 come quello misurato su questa famiglia, la famiglia intera sta attorno a **1,10** `[STIMATO — il per-trade di 971501 non è in archivio]`.
- **La famiglia degli SCHIERABILI resta 0,945 in qualunque unità**, perché è una sedia sola.

👉 **La famiglia EMA200 degli SCHIERABILI IN PROP ha UN simbolo e fa 0,945 posizioni/giorno.** Sotto il pavimento firmato il 07/09, **in posizioni**. Sopra, **in uscite** (1,901).
🔴 **Quindi il cancello 1 dipende ancora, e interamente, dalla decisione sull'unità di conto — che R112 ha segnalato il 26/08 e che non è stata presa.** `[FIRMA DI CLAUDIO]`

### 🆕 E UNA COSA CHE NESSUNO AVEVA GUARDATO: **la sedia lavora a raffiche**
```
giorni feriali nella finestra OOS ......... 272
giorni con almeno una chiusura ............ 102  (37,5%)
posizioni per giorno ATTIVO ............... 2,52
massimo di posizioni chiuse in un giorno .. 8  (30/07/2025; poi 7 e 7)
```
👉 **Non è una sedia che fa un'operazione al giorno: è una sedia che sta ferma due giorni su tre e poi ne fa 2-8 tutte insieme.** Per una prop questo è **esattamente** il profilo che stressa il **muro giornaliero**, non quello totale. La peggior giornata misurata resta **−2,448%** (chiusi, rischio 1%) → **−1,59%** alla taglia 0,65%: dentro, con margine. Ma il **flottante** resta **[NON MISURATO]**, e su una sedia a raffiche il flottante è la grandezza che conta.
🔴 Il **massimo di posizioni contemporanee** resta **[NON MISURABILE]** da questi CSV: il per-trade ha solo l'ora di **chiusura**, non quella di apertura.

---

# 6. 🛡️ PROP-HARDENING — **la scala di slippage, misurata OGGI. E la passa.**

Criteri congelati **prima** (commit `caaf5d1`): scala **0 / 1 / 2 / 5 punti indice** peggiorati su **ogni ingresso**, post-processing sui 517 deal della base. Aritmetica: ogni deal perde `N × volume × 0,861 €`; la somma dei volumi chiusi di una posizione è il volume della gamba, quindi il conto è esatto per gamba.

| N (punti indice) | netto | % dep. | **PF** | DD (chiusi) | DD equity stimato | peggior giornata | gg. negativi |
|---:|---:|---:|---:|---:|---:|---:|---:|
| **0** (base) | **+23.321,47** | +23,32% | **1,52365** | 7,5367% | **7,8323%** (misurato) | −2,448% | 34/102 |
| **1** | +21.983,99 | +21,98% | **1,48760** | 7,8126% | 8,12% | −2,466% | 34/102 |
| **2** | +20.646,52 | +20,65% | **1,45239** | 8,0913% | 8,41% | −2,484% | 35/102 |
| **5** | **+16.634,08** | +16,63% | **1,35143** | 8,9447% | 9,30% | −2,537% | 35/102 |

**Dove si rompe** (interpolato sugli stessi dati):
- **PF scende a 1,10** a **13,53** punti indice;
- **il netto si azzera** a **17,44** punti (1 punto di slippage costa **1.337,48 €** = 1.553,40 lotti chiusi × 0,861, cioè il **5,73% del profitto per punto**);
- 🔴 **il muro del 10% di DD si rompe a 7,32 punti** — ed è **questo** il vincolo che morde per primo, non l'edge.

### ✅ VERDETTO PROVA B, contro i criteri congelati
Al gradino che decide (**2 punti**): netto > 0 ✅ · PF 1,4524 ≥ 1,10 ✅ · DD 8,41% ≤ 10,0% ✅ · peggior giornata −2,484% > −3,50% ✅ → **PASS**. E regge anche il gradino severo dei 5 punti. **Margine dichiarato: il muro del DD dista 3,7× il gradino standard.**

### 🧊 E COSA QUESTA PROVA NON DICE — quattro limiti, dichiarati
1. **Non sposta il grilletto**: lo slippage vero fa anche **non partire** dei trade. Qui `n` resta 517.
2. **Questa cella entra con due LIMIT pendenti**, non a mercato: per un LIMIT lo slippage sfavorevole all'ingresso è **strutturalmente meno probabile**. La prova è **pessimistica per costruzione** — e va detto anche quando fa comodo.
3. **Requote, rifiuti, no-fill del LIMIT, profondità del book**: MT5 non li modella. **[NON MISURABILE]**, e nessun backtest risponderà.
4. Il DD è sulla **curva dei chiusi** = un **pavimento**. Il fattore misurato fra chiusi ed equity sulla base è **7,8323/7,5367 = 1,0392**, e l'ho applicato alla colonna «DD equity stimato» **dichiarandolo**.

### 🚧 LA SCALA DI SPREAD (+25/+50/+100%) — **preparata, NON eseguibile finché non canta il canarino**
Non è pigrizia, è un fatto già scritto in casa: *«La riga `Spread` dell'`.ini` a Modello 4 è **[NON MISURATO]**: non sappiamo se MT5 la onori. Chi volesse aggiungerlo deve prima passare il **canarino**»* (`prove/R118_PAVIMENTO_STOP_CRITERI.md` §4.3 · `REFERTO_R118_PAVIMENTO_STOP.md` §8.2 punto 6 — e lo ripete il driver stesso, `walkforward_generico.ps1` r.180-190).
I gradini restano congelati: **`Spread=0 / 238 / 285 / 380`** punti MT5, cioè **+0 / +25 / +50 / +100%** sulla **mediana misurata di 1,9 punti indice** della fascia 14-21 (dove cade il 55,7% delle uscite). **Conversione dichiarata: 100 punti MT5 = 1 punto indice.**

> ### 🔴 ERRATA — **QUALE prova è il canarino (classe 262)**
> La prima stesura dava il ruolo al file `00`, che mette ad asse **`InpMaxSpread`** (il filtro **interno all'EA**) e gira **senza `-Spread`**, cioè con la riga `Spread=` **mai scritta**. Sono **due variabili diverse**, e — peggio — **nessuno dei due rami concludeva**: se `n` non si muove, la spiegazione può essere l'**esatto contrario** di quella che avevo scritto, perché **uno spread costante è proprio la firma di una riga `Spread=` onorata**. Un canarino che ammette due letture opposte non è un canarino.
> ✅ **Il canarino vero non vuole file nuovi**: è la prova **`01`** girata **due volte** sulla stessa cella, **solo gamba OOS**, `-Spread 0` contro **`-Spread 99999`** (999,99 punti indice: **dieci volte** il massimo mai misurato su U30USD). **2 celle × 2 corse × 1 gamba = 4 passate, ~1,5 minuti.**
> - **identici alla cifra** ⇒ la riga è **ignorata**, la PROVA A è **morta** e si scrive **«non misurabile»** — 🔴 **mai «robusta allo spread»**;
> - **diversi** ⇒ la riga è onorata, e **solo allora** si lanciano i quattro gradini.
> 👉 Il file `00` resta, rinominato **`COLLAUDO_EMADOW_00_manopola_maxspread.txt`**: misura la **riparazione candidata del C3**, che è utile per conto suo. **Non è un cancello.**

### 🐤 LA LATENZA — **il canarino è GIÀ in archivio, e non va rifatto**
`walkforward_generico.ps1 -Ritardo` scrive **`ExecutionMode`** (non `Delay=`: quella chiave sbagliata fece fallire il primo giro di R119, classe 156). Il secondo giro **misura**, e i CSV sono lì:

| EA | 0 ms | 50 ms | 100 ms | 500 ms | esito |
|---|---:|---:|---:|---:|---|
| `ABTG_DAX_Apertura_EU` D30EUR (OOS) | 2.206,62 | 2.212,22 | 2.217,78 | **2.240,50** | 🟢 **la chiave MORDE** |
| `ABTG_ORB_Ottimizzato` U30USD (OOS) | 4.968,34 | 4.968,34 | 4.968,34 | 4.968,34 | ⚪ ferma |

_(fonte: `risultati_archivio/ritardo_r119b_csv/`, somma `Profit` delle 2 celle gemelle)_
👉 **Il canarino della latenza non si paga due volte.** E attenzione al verso: sul DAX il ritardo **migliora** il risultato (+1,5%). **Il ritardo del tester non è uno slippage avverso**: chi lo legge come «costo» sbaglia di segno.

### 💰 COMMISSIONI E NOTTE
- **Commissioni della prop: [NON MISURABILE]** — nessun profilo commissioni utilizzabile agli atti; il banco gira a commissione 0. **Non si stima.**
- **Swap / rollover: [NON MISURABILE]** da questi CSV. ⚠️ E per **questa** sedia conta più che per altre: `InpUseCutoff=false` + `InpMaxTradesPerDay=0` ⇒ tiene posizioni **overnight** e apre anche **all'ora 23**, dove il p95 dello spread è **7,0** punti indice e il **massimo è 60,0**. ⚠️ **Errata mia**: avevo attribuito all'ora 23 il massimo di **101**, che è il massimo **globale** del file e appartiene all'**ora 13**. Il 7,0 di p95 all'ora 23 (contro 2,0-3,0 di tutte le altre ore) resta il numero che conta, ed è **3,7× la fascia di sessione**.

---

# 7. 📦 IL PACCHETTO — sette file prova, ordinati per **valore/costo**

Tutti in `backtest_pipeline/prove/`, **ASCII puro**, corpo = **copia riga per riga** dell'antenato `R112_00_metro.txt`, magic dal blocco **vergine 7666xx**, **attesa dichiarata e uscite possibili scritte DENTRO ogni file**.

> ### 🔴 ERRATA — **«46 chiavi su 46» NON ESISTE (classe 263)**
> Misurato: l'EA ha **44** `input`, il `.set` vivo **42** chiavi `Inp*`, `R112_00_metro.txt` **43**. Intersezione **42**, **identiche 41**, unico delta `InpMagic`. Scoperte dal `.set` e prese dal **default compilato**: `InpUsaGuardian=true` e `InpLogImbuto=true` (quest'ultimo **solo log**, non tocca il trading).
> 👉 La frase giusta è: **«41 chiavi identiche su 42 comuni, unico delta `InpMagic`»**. Il **46** era **sopra l'universo** — l'EA non ha 46 input. 🟢 **La tesi non cambia** (si collauda la cella che gira); cambiava solo il numero, ed era gonfiato. Corretto in **tutti e 9 i posti** dove compariva, referto e file prova.

> ### 🎯 IL BERSAGLIO DI COMPILAZIONE, per percorso e conteggio righe (non per nome)
> In repo esistono **tre** `.mq5` con questo nome o quasi: `mql5/Experts/ABTG_EMA200.mq5` (**690 righe** — 🎯 **questo, ed è quello che gira**), `mql5/Experts/standalone/ABTG_EMA200.mq5` (**380 righe**) e `mql5/Experts/ABTG_EMA200_Ottimizzato.mq5` (**748 righe**, la sedia XAUUSD `971501`). **Compilare per nome è un modo di sbagliare EA in silenzio.**

| ord. | file | che numero produce | celle × gemelli × corse × gambe | **passate** | ⏱️ | perché è in questa posizione |
|---|---|---|---|---:|---|---|
| **1** | **`LATI_A1/A2_EMA200_U30USD_*` (4 file, GIÀ SCRITTI il 09/09)** | lato × regime sulla **discesa** 2025.02-04, con sentinella sui bersagli R110 | 4 file × 2 × 1 × 1 | **8** | ~3 min | 🥇 **esiste già, è gatato, e risponde alla domanda più grossa del dossier.** Zero preparazione |
| **2** | `COLLAUDO_EMADOW_02_pertrade_IS.txt` | **n IS in POSIZIONI** — chiude il requisito 2 e il cancello del campione | 2 × 1 × 1 × 1 | **2** | ~1 min | il numero più economico del lotto, e sblocca un cancello |
| **3** | `COLLAUDO_EMADOW_01_...` **usato come CANARINO** (`-Spread 0` vs `99999`, solo OOS) | la riga `Spread=` è onorata a Modello 4? | 2 × 1 × 2 × 1 | **4** | ~1,5 min | 🚦 **decide se la scala di spread esiste.** Va PRIMA della 8 |
| **4** | **`R136a/b/c/d_*_U30USD.txt` (di un ALTRO agente, `63e10ba`)** | requisito 3 — `InpSLatr`, `InpTP1_ATRmult`, `InpTP1Pct`, `InpUseTrailing` | dichiarate da lui | **40** | ~15 min | 🤝 §7.1: **i miei 03 e 04 sono RITIRATI** in loro favore |
| **5** | `COLLAUDO_EMADOW_00_manopola_maxspread.txt` | **la riparazione candidata del C3** (`InpMaxSpread`) | 5 × 1 × 1 × 2 | **10** | ~4 min | 🔴 **NON è un canarino** (classe 262): propone una riparazione, non sblocca niente |
| **6** | `COLLAUDO_EMADOW_05_tf_U30USD.txt` | requisito 5 — H1 è un altopiano o una fortuna? | 7 × 1 × 1 × 2 | **14** | ~6 min | l'unico asse mai provato sul simbolo schierato |
| **7** | `COLLAUDO_EMADOW_06_latenza.txt` | scala `ExecutionMode` 0/50/100/500 ms | 2 × 1 × 4 × 2 | **16** | ~6 min | il canarino è già pagato; attesa: **fermo** (entra con LIMIT) |
| **8** | `COLLAUDO_EMADOW_01_spread_scala_ini.txt` — **la scala** | spread +25 / +50 / +100% | 2 × 1 × 4 × 2 | **16** | ~6 min | 🔴 **solo se il canarino (3) dice VIVA.** Altrimenti si archivia NON lanciata |
| ~~—~~ | ~~`COLLAUDO_EMADOW_03/04_uscita_*`~~ | ~~requisito 3~~ | — | ~~14~~ | — | 🚫 **RITIRATI** (duplicati di `R136c`/`R136d`) |
| | 🔢 **IL TOTALE — uno solo, e questo è quello vero** | | | **110** | **~40 min** | 110 × 22 s. 🔻 **94 se il canarino dice MORTA** (le 16 della scala non si lanciano) |

> ### 🔴 ERRATA — **tre totali diversi, e nessuno era quello giusto (classe 264)**
> La prima stesura scriveva **64**, poi **76**, e i file `01` e `06` dicevano *«8 passate PER GAMBA»* riportandole come **8**: erano **16** a testa. Il conto vero, rifatto nel formato **celle × gemelli × corse × gambe**, è **110**.
> 🧮 **E riconcilio subito con il 106 del cancello, perché due numeri senza spiegazione sono un quarto errore, non una correzione**: la differenza sono **esattamente le 4 passate del CANARINO**, che nella sua conta stavano **dentro** la scala e qui sono una **riga a parte** — perché si lanciano **prima**, da sole, e **se dicono «morta» le 16 della scala non si lanciano mai**. 👉 **110 = 106 + 4.** In questo documento il totale è **110**, e il ramo è **94**. 🟢 **La tesi regge** (110 × 22 s ≈ 40 minuti, **sotto l'ora**) — **ma reggeva per fortuna, non per conto**, e «meno di un'ora» è esattamente la frase che argomenta lo schieramento. Una frase che argomenta non può poggiare su un totale sbagliato.

### 7.1 🤝 UNA COLLISIONE FRA AGENTI, TROVATA E RISOLTA OGGI STESSO
Mentre preparavo questo pacchetto, **un altro agente ha committato nello stesso pomeriggio** (`63e10ba`, *«r136a-d: l'uscita della sedia migliore della flotta, 4 file, 40 passate»*) **quattro file prova sulla STESSA cella e sulla STESSA domanda**: `InpSLatr` · `InpTP1_ATRmult` · `InpTP1Pct` · `InpUseTrailing`.

| il mio file | il suo | sovrapposizione |
|---|---|---|
| `COLLAUDO_EMADOW_03_uscita_TP1PCT.txt` (`InpTP1Pct` 0/25/50/75/100) | `R136c_parziale_U30USD.txt` (0/25/50/75) | 🟠 **quasi identica** — al suo manca la cella **100** |
| `COLLAUDO_EMADOW_04_uscita_TRAILING.txt` (`InpUseTrailing` 0/1) | `R136d_trailing_U30USD.txt` (`1\|\|0\|\|1\|\|1\|\|Y`) | 🔴 **IDENTICA, carattere per carattere** |

👉 **Ho RITIRATO i miei due** (nota di ritiro scritta **dentro** i file, non cancellati: restano come record del requisito 3) e la voce 4 della tabella qui sopra punta a **r136**, che è **più largo** (copre anche lo stop e il primo bersaglio, e ha criteri suoi).
🔴 **Perché non li ho tenuti entrambi**: due file prova che misurano la stessa variabile sulla stessa cella con magic diversi sono il modo più rapido di ottenere **due numeri che litigano** — e il progetto ha già speso giornate a riconciliare DD incompatibili.
### 🔴 E IL RILIEVO CHE AVEVO GIRATO A `r136` ERA FALSO — **ritirato, ed è il difetto del 10/09 alla lettera**
Avevo scritto *«a `R136c` manca la cella `InpTP1Pct=100`»*. **È sbagliato, e la risposta stava nel suo file, dieci righe più in basso** (`R136c_parziale_U30USD.txt` r.74-78): la esclude **a ragion veduta e citando il codice**. La guardia di `ABTG_EMA200.mq5` **r.410** è

```
if(!beDone && InpTP1Pct>0 && InpTP1Pct<100)
```

⇒ **a 100 il blocco del parziale si spegne ESATTAMENTE come a 0**. La cella 100 **sarebbe** la cella 0 misurata due volte — e la **0 è già nel suo asse**. 👉 **Quindi il numero del rapporto deal/posizione a 1,00 (classe 226) è GIÀ COMPRATO da `r136c`: non manca.** **RILIEVO RITIRATO.**
🔴 **È il difetto del 10/09 identico**: *«prima si cerca il file che ha già la risposta»* — e il file era **nella stessa cartella**, con la risposta scritta e la riga di codice citata. L'ho pagato una quarta volta, e stavolta girando un rilievo sbagliato a un altro agente.
✅ **Nessuna collisione di magic**: lui usa `786x00`, io `7666xx`.

**Il metro del tempo non è una stima a occhio**: `R112_CORSA_20260826/REFERTO_R112.txt` r.7 — *«durata: 0.1 ore»* per **16 passate** sulla **stessa cella, stesso banco, stessa finestra** = **22 s/passata**. Con overhead di compilazione e driver: **sotto l'ora**.

### 🚦 LO STATO DEI CANCELLI SU QUESTO PACCHETTO
| cancello | esito |
|---|---|
| `controlla_prova.py` (7 file) | ✅ **OK — 0 problemi** |
| `controlla_riga.py --oggetto prova` (7 file) | ✅ **nessun difetto meccanico**, ASCII puro confermato |
| agente **`controllo-preventivo`** (giudizio) | ⏳ **DA FARE.** 🔴 **Nessuna riga di lancio esce verso Claudio prima del suo PASS** (regola del 09/09) |

**Due difetti corretti che l'antenato si portava dietro** (e vanno a verbale come classi già note): il **pin di stringa vuota** `InpNewsCurrencies=` (MT5 lo ignora e usa il default compilato — `R112_00_metro.txt` r.96 ce l'ha) e il **doppio asse Y** quando la coppia gemella è nel file invece che nel driver.

### 🔧 LA RIGA DI LANCIO — **specifica pronta, riga NON ancora emessa**

> ## 🖥️ BERSAGLIO — **si legge PRIMA del blocco, ed è una riga sola** (CLAUDE.md, 12/09)
> **Finestra PowerShell sul VPS `VMI3047753`**, che pilota il **SOLO terminale di backtest `50504400` (`C:\MT5_Backtest`)** — che al censimento di stamattina è **spento**, ed è la condizione per lanciare.
> 🔴 **NON si tocca nient'altro su quella macchina**, e su quella macchina c'è tutto: `50503392` (`BCM Markets MT5 Terminal`, il piccolo) · `50504263` (`... -V3`, il 100k) · **`10105439` (`C:\BCM_Reale`, il REALE — acceso adesso, PID 7824)** · più **Pepperstone** e **Tickmill**. **Sei cartelle dati: «gira sul VPS» da solo non è un bersaglio, è un indirizzo.**
> ⚠️ **ERRATA della prima stesura**: c'era scritto *«PC DI BACKTEST … sul VPS non si lancia niente»* **e `50504400` in tutte e due le liste**. È una contraddizione, e il censimento che io stesso cito la smonta: `C:\MT5_Backtest` **è sul VPS** (`CENSIMENTO_MT5_VPS_2026-09-12_0846.txt` r.8-11 e r.54-56). **Due macchine nominate per la stessa corsa è esattamente il difetto che la regola del 12/09 esiste per impedire.**

I file girano sul **driver generico**, che ha già tutti i parametri che servono (`-Prova`, `-Etichetta`, `-Spread`, `-Ritardo`, `-Deposito`, `-SoloControllo`). Parametri congelati, identici al banco di R112 — **niente si cambia dentro un collaudo**:

```
prove 00 / 05 / 06 / 01  (finestra piena, split 40/60):
  -Expert ABTG_EMA200 -Prova prove\COLLAUDO_EMADOW_<NN>_<nome>.txt
  -Simbolo U30USD -Periodo H1 -DaQuando 2024.09.26 -Fino 2026.06.30
  -FrazioneIS 0.40 -Modello 4 -Deposito 100000 -Etichetta COLL_<NN>
     prova 01 SCALA   : -Spread 0 | 238 | 285 | 380      (quattro corse)
     prova 06: aggiungere -Ritardo 0 | 50 | 100 | 500   (quattro corse)

prova 01 usata come CANARINO (due corse, UNA SOLA TRANCHE sulla finestra OOS):
  -Expert ABTG_EMA200 -Prova prove\COLLAUDO_EMADOW_01_spread_scala_ini.txt
  -Simbolo U30USD -Periodo H1 -DaQuando 2025.06.10 -Fino 2026.06.30
  -FrazioneIS 1.0 -Modello 4 -Deposito 100000
  corsa K1: -Spread 0       -Etichetta CAN_S0
  corsa K2: -Spread 99999   -Etichetta CAN_S99999
  >>> DUE AVVERTENZE, e sono entrambe trappole gia' pagate in casa:
      (a) -DaQuando e -Fino qui si possono passare perche' questo file
          NON ha '@FINOA' (a differenza della 02): nessuna contraddizione
          di date, nessuna morte della corsa.
      (b) con -FrazioneIS 1.0 la tranche unica esce ETICHETTATA '_IS' nei
          nomi dei CSV anche se copre la finestra OOS -- e' la stessa
          convenzione dei file LATI_A2 del 09/09. Va DICHIARATO nel
          referto, o fra un mese qualcuno legge "IS" e confronta la cosa
          sbagliata. L'etichetta CAN_* serve esattamente a questo.

prova 02  (finestra IS da sola) -- E QUI LA RIGA E' DIVERSA, ATTENZIONE:
  -Expert ABTG_EMA200 -Prova prove\COLLAUDO_EMADOW_02_pertrade_IS.txt
  -Simbolo U30USD -Periodo H1 -DaQuando 2024.09.26
  -FrazioneIS 1.0 -Modello 4 -Deposito 100000 -Etichetta COLL_02
  >>> -Fino NON si passa, e NON e' una dimenticanza: il file dichiara
      '@FINOA 2025.06.10' e la regola del driver (r.526) e' "-Fino NON
      passato a mano -> @FINOA VINCE". Se si passasse -Fino 2026.06.30
      la corsa MUORE (date in contraddizione, r.562); se si aggiungesse
      -FinoDallaRiga la corsa GIRA ma sulla finestra SBAGLIATA, ed e' il
      caso peggiore dei due. Niente -Fino, niente -FinoDallaRiga.
```

🔴 **Manca ancora, e lo dico invece di improvvisarlo**: il wrapper `.ps1` con marcatore + `irm` dal branch `lavoro` + riga di raccolta (zip sul Desktop). Uno script nuovo **deve** passare i due cancelli prima di esistere: scriverlo male adesso costerebbe più del tempo che fa risparmiare.

---

# 8. 🧱 COSA MANCA CHE **NON** È UN NUMERO — e non lo chiude il tester

| # | cosa manca | stato misurato | di chi è |
|---|---|---|---|
| **1** | **Il preset del 100k (`881531`) NON ESISTE** | `mql5/Presets/` ha `*_100K.set` per `ABTG_DAX_Apertura_EU` e `ABTG_Dow_Apertura_US`. **Per `ABTG_EMA200` non c'è.** Il solo preset è `sedie_piccolo/recupero2/sedia_ABTG_EMA200_771531.set` (magic del piccolo, `InpRiskPercent=1.0`) | 🔴 va **creato**: magic `881531`, `InpRiskPercent` = **[FIRMA DI CLAUDIO]** (il piano migrazione dice 0,65%), le altre **41 chiavi copiate identiche** (l'EA ha 44 input; il `.set` ne copre 42). ⚠️ E va coperto anche `InpLogImbuto` (input del 11/09, **assente dal preset**) |
| **2** | **I 5 cancelli della FASE 1** | 🔴 **nessuno verde** al 09/09; collaudo *«in corso»* dal 02/09 | il piano, non il tester |
| **3** | **Il tetto per cluster/valuta al 3,0%** | **firmato** il 07/09, **implementato** nel Guardian, ma **non valorizzato in nessun preset** e **assente dalla versione in campo**. Questa sarebbe l'**11ª sedia sul Dow** | `[FIRMA DI CLAUDIO]` — *«va valorizzato e portato in campo»*, non *«va implementato»* |
| **4** | **Il buco B6 (pendenti invisibili al cap C1)** | questa sedia piazza **2 LIMIT per segnale** e il Guardian conta solo `PositionsTotal()`. Misurato sul vivo con l'oro: 4 pendenti = **3,94%** contro un cap di 3,25% | codice del Guardian, non questo collaudo |
| **5** | **L'unità di conto dei cancelli (uscita o posizione)** | aperta dal **26/08**, decide **due cancelli su cinque** | `[FIRMA DI CLAUDIO]` |
| **6** | **Il DD promesso nel contratto** | oggi `CENSIMENTO_CONTRATTI.md` dice **7,21%** (R29, dep. 10k); il numero riprodotto 3× è **7,8323%** (dep. 100k) | `[FIRMA DI CLAUDIO]` — col numero sbagliato scatta una revisione che non serve, o non scatta quella che serve |

---

# 9. 🏁 IL VERDETTO SECCO

> ## 🟢 **SCHIERABILE IL 1° OTTOBRE: SI — ma non oggi, e non per mancanza di tempo macchina.**
>
> ⏱️ **Quello che manca in MISURE costa 110 passate, ~40 minuti di tester (94 e ~35 se il canarino dello spread dice morta). Sotto l'ora. Zero notti.** Il metro è misurato (R112: 16 passate in 0,1 ore sulla stessa cella) e il conto è rifatto nel formato di casa al §7.
>
> 🔴 **Quello che manca in FIRME non lo produce nessun backtest**, e sono **tre decisioni più una da sapere**: l'**unità di conto** (decide 2 cancelli su 5) · la **taglia d'ingresso** · il **tetto per cluster** su un simbolo che ha già **10 sedie** · 🚩 e **la concentrazione: l'edge di questo motore esiste su UN SIMBOLO SOLO** (6 celle positive su 330 sui gemelli, §4-bis). Quella non è una firma di rischio: è una cosa che va **saputa** mentre si firmano le altre tre.
>
> 📅 **Diciannove giorni al 1° ottobre.** Le misure stanno in una mattina. Le firme stanno in una sera. **Non c'è nessun ostacolo da settimane in questo dossier** — e questo è il motivo per cui è la cosa più importante che abbiamo.

### ✅ Quello che questa sedia ha, e che nessun'altra delle 41 ha
PF riprodotto **tre volte al centesimo** · **84 celle su 84 positive** a tick sull'intero periodo, con la cella viva **7ª su 84** — **lontana dal picco, sopra il centro** (⚠️ ma è un altopiano **dell'INGRESSO**: in quella griglia non varia **nessun** parametro d'uscita, quindi **non dice niente sul requisito 3**) · **due lati misurati** · rischio dichiarato **= rischio vero** · pavimento del lotto che **non morde** · e ora anche **la scala di slippage misurata, che passa con 3,7× di margine sul gradino standard**.

### 🔴 Quello che resta scomodo, detto senza addolcire — **sei voci, e la prima è nuova**
1. 🚩 **L'edge sta su UN SIMBOLO SOLO**: 6 celle positive su 330 sui quattro indici gemelli contro 98/98 sul Dow, **e non è il regime** (il DAX era in toro nella stessa finestra e fa 0/80). §4-bis.
2. 🔴 **Il flottante e il massimo di posizioni contemporanee sono [NON MISURABILI]** dai per-trade (c'è solo `close_time`): è **l'unico buco strutturale del pacchetto**, e su una sedia **a raffiche** (2-8 posizioni in un giorno, ferma 2 giorni su 3) è **la grandezza che decide il muro giornaliero di una prop**. Lo chiude solo un forward osservato, o un EA che logga l'equity intraday.
3. **Un regime solo**, e non è riparabile in casa (lo storico BCM sugli indici parte dal 2024.09.26).
4. **C3 FRAGILE** sulla gamba 2 per colpa della **notte** (33,2×, dove cade il **26,0%** degli stop pieni) — 🟠 e il FRAGILE è un **irrigidimento dichiarato a numeri visti**: alla lettera dei criteri congelati sarebbe PASS (§4).
5. **La famiglia degli schierabili sta sotto il pavimento di frequenza in posizioni** (0,945), e il 1,245 che la salvava **mescola deal e posizioni** (§5.1).
6. È **il vicino più pericoloso del Dow**, dove ci sono già **10 sedie** e il tetto per cluster è **firmato ma spento**.

### 🧾 E DUE BUCHI CHE NON SONO MIEI, ma che vanno scritti dove si vedono
- 🔴 **Il magic in campo non è censito da nessuna parte in forma leggibile.** `report/collaudi/CENSIMENTO_MT5_VPS_2026-09-12_0846.txt` elenca **EA + simbolo + `chartNN.chr`** e **non contiene nemmeno un magic**. Conseguenza operativa: la **non-collisione** dei miei `7666xx` col campo **non è verificabile da quel file** — il `grep` repo-wide sì (**0 occorrenze esterne**), e su quello poggia la verginità del blocco. **È un buco del censimento, e va chiuso lì**: un censimento che non legge i magic non può dire se un round sta per scrivere sul magic di una sedia viva.
- 🟠 **`InpMaxSpread` filtra il segnale, non l'uscita** (`.mq5` r.325): la riparazione candidata del C3 è **parziale per costruzione**, e va proposta così.

---

# 10. ⚡ **CORRI OGGI** — l'ordine di lancio, sabato 13/09 a mercati chiusi

> Richiesta di Claudio, testuale: *«POI FATE SUBITO I BACKTEST E STASERA VOGLIO TROVARE EA VALIDATI. EA X LE PROP.»*
> 🖥️ **BERSAGLIO: finestra PowerShell sul VPS `VMI3047753`, solo terminale di backtest `50504400` (`C:\MT5_Backtest`, spento al censimento di stamattina). NON si tocca `50503392`, `50504263`, `10105439`, Pepperstone, Tickmill.**

| ord. | round | passate | ⏱️ | cumulato | **cosa chiude** |
|---:|---|---:|---:|---:|---|
| **1** | 🐤 **CANARINO spread** — `01` a `-Spread 0` contro `-Spread 99999`, **una sola tranche sulla finestra OOS** | **4** | **1,5 min** | 1,5 min | 🚦 **decide se la PROVA A esiste.** Va PRIMO perché se dice «morta» il round 8 non si lancia (−16 passate) |
| **2** | `COLLAUDO_EMADOW_02_pertrade_IS` | **2** | 1 min | 2,5 min | ✅ **requisito 2** — n IS in POSIZIONI, e il cancello del campione |
| **3** | `COLLAUDO_EMADOW_05_tf_U30USD` | **14** | 6 min | 8,5 min | ✅ **requisito 5** — TF mai cambiato su U30USD |
| **4** | `R136a/b/c/d` (dell'altro agente) | **40** | 15 min | **23,5 min** | ✅ **requisito 3** — la gestione dell'uscita 👉 **qui il CERTIFICATO è 5 su 5** |
| **5** | `LATI_A1/A2_EMA200_U30USD_*` (4 file già scritti) | **8** | 3 min | 26,5 min | 🎁 la **discesa** 2025.02-04: robustezza di regime, con sentinella |
| **6** | `COLLAUDO_EMADOW_00_manopola_maxspread` | **10** | 4 min | 30,5 min | 🔧 la **riparazione candidata del C3** |
| **7** | `COLLAUDO_EMADOW_06_latenza` | **16** | 6 min | 36,5 min | 🛡️ scala `ExecutionMode` (canarino già pagato) |
| **8** | `COLLAUDO_EMADOW_01` — **la scala di spread** | **16** | 6 min | **42,5 min** | 🛡️ **solo se il round 1 dice VIVA** |
| | **TOTALE** | **110** | **~40 min** | | **94 / ~35 min** se il canarino dice morta |

### 🛑 TRE COSE DA FARE PRIMA DI PREMERE INVIO, e non sono formalità
1. ⚙️ **UN SOLO AGENTE LOCALE (`Core 1`), e si spegne A MANO dentro MT5** (Strategy Tester → Agenti). **Classe 129, causa CONFERMATA il 04/09**: con più agenti vivi **le celle gemelle divergono davvero**. E in questo pacchetto le coppie gemelle sono **il gate di identità** delle prove `01` e `02`: senza un agente solo, quei due round **non si leggono**.
2. 🚦 **I due cancelli sulla riga**, prima che parta: `controlla_riga.py` **e** l'agente `controllo-preventivo`. 🔴 **Manca ancora il wrapper `.ps1`** (marcatore + `irm` dal branch `lavoro` + raccolta zip sul Desktop): è l'unico pezzo del pacchetto che **non** è pronto, e non lo improvviso.
3. 📐 **`-SoloControllo` prima di ogni round**: sull'asse `InpTF` del round 3 il conteggio celle di `controlla_prova.py` **è sbagliato per costruzione** (stampa 16374 su un enum, dove i membri veri sono **7**). **Fa fede il numero che stampa il driver.**

### 🔴 E LA COSA CHE NON POSSO PROMETTERE, detta prima e non dopo
**Alle 40 minuti ci sono NUMERI, non un verdetto.** Se i round 2-4 tornano come attesi, **il certificato passa da 3/5 a 5/5 e la sedia è misurata per intero** — ed è il massimo che un tester può dare. 🔴 **Ma tre cose restano fuori dalla portata di qualunque backtest**, e stasera saranno lì uguali: le **tre firme** (unità di conto, taglia, tetto per cluster), **il flottante** (`[NON MISURABILE]` dai per-trade), e **la concentrazione su un simbolo solo** (§4-bis). 👉 *«Stasera EA validati»* è **raggiungibile sulle misure**; **lo schieramento resta una decisione di Claudio**, e questo referto gli dà i numeri per prenderla, non la prende al suo posto.

---

_🛑 **Zero modifiche al forward. Nessun EA, preset, parametro, magic o grafico toccato. Nessun backtest lanciato. Nessuna promozione, nessuna accensione, nessuna spesa autorizzata.** Rischio e taglie sono di Claudio; lo schieramento è una sua decisione._

_Fonti nuove aperte da questo referto: `risultati_archivio/R112_CORSA_20260826/pertrade_00_metro_763400.csv` (posizioni, stop pieni, scala di slippage, peggior giornata, raffiche) · `risultati_prove/risultati_valid_ABTG_EMA200_H1_realtick/valid_ABTG_EMA200_H1_realtick_U30USD.csv` (84/84 celle) · `risultati_prove/risultati_scan_ABTG_EMA200_H1/` (48 simboli) · `risultati_archivio/ritardo_r119b_csv/` (canarino latenza già pagato) · `risultati_archivio/spread_flotta/spread_orario_U30USD.csv` · `prove/LATI_A1/A2_EMA200_U30USD_*.txt` (mai lanciati) · `prove/R118_PAVIMENTO_STOP_CRITERI.md` §4.3 · `walkforward_generico.ps1` r.165-235._
