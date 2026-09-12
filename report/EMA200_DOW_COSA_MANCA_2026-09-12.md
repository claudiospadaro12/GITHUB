# 🪑 `EMA200` DOW — **CHE COSA MANCA ESATTAMENTE PER SCHIERARLA**

> ## 🎯 LA RISPOSTA IN SEI RIGHE
> 1. 🟢 **Il certificato e' soddisfatto per 3 requisiti su 5** (PF · simboli gemelli · DD). Mancano **la gestione dell'uscita mai messa ad asse** e **il TF mai cambiato su U30USD** — e il **n in POSIZIONI dell'IS**, che e' il terzo e mezzo.
> 2. ⏱️ **E tutto quello che manca costa MENO DI UN'ORA DI TESTER.** Non una notte: **64 passate**, e il metro e' misurato in casa (R112: **16 passate in 0,1 ore** = 22 s/passata sulla stessa cella, stesso banco). 🔴 **Questa sedia e' ferma da un mese per ~25 minuti di macchina.**
> 3. 🆕 **Ho MISURATO tre numeri che ieri erano `[NON MISURATO]`**, senza lanciare niente, leggendo i per-trade che erano già in archivio: **le posizioni vere (257)**, **lo stop pieno in punti indice sulla finestra di backtest (gamba 2 mediana 88,2 · gamba 1 132,6, su 33 coppie)** e **la scala di slippage completa**.
> 4. ✅ **LO STRESS DI COSTO LO PASSA, e con margine**: a **2 punti indice** di slippage su OGNI ingresso fa ancora **PF 1,4524 · +20,65% · DD 8,09%**; il muro del 10% si rompe solo a **7,32 punti**. Per i criteri congelati stamattina: **PASS**.
> 5. 🔴 **Il cancello del COSTO (C3) resta FRAGILE, ma il numero vero e' migliore di quello del dossier**: la gamba 2 fa **37,1× lo spread** di mediana (non 34-41× da 3 eventi), **41,8× in sessione** e **33,2× di notte**. Sopra i 30×, sotto i 40×: **FRAGILE, non bocciato.**
> 6. 🔴 **E c'e' un rilievo nuovo che cambia un cancello**: la **frequenza di FAMIGLIA** passa il pavimento (1,245) **solo contando `971501` EMA200_Ott XAUUSD**, che il **23/08 e' stato firmato «prop: NO a nessuna taglia»** (DD 45,91%). La famiglia degli **SCHIERABILI** fa **0,945 posizioni/giorno**: **sotto 1,00**.

_Compilato il **12/09/2026** in **sola lettura d'archivio** + post-processing sui CSV già esistenti. **Nessun backtest lanciato. Nessun EA, preset, magic o sedia viva toccato. Nessuna promozione, nessuna accensione, nessuna spesa.** Criteri congelati PRIMA dei numeri in `backtest_pipeline/prove/COLLAUDO_EMA200_DOW_CRITERI.md` (commit `caaf5d1`, **prima** di questo referto)._

---

# 1. 📋 IL CERTIFICATO — i cinque requisiti, uno per uno

Metro: la regola del **09/09/2026** (`CLAUDE.md`, «IL CERTIFICATO DI MORTE»). Qui è usata al contrario: non per dichiarare morto un candidato, ma per dire **che cosa manca a uno vivo**.

| # | requisito | esito | il numero e il file | se NO: la via più corta, e quanto costa |
|---|---|---|---|---|
| **1** | **PF misurato** | ✅ **SI** | **OOS 1,52365 · IS 1,20110**, tick reali, dep. 100k · `risultati_prove/ABTG_EMA200/ABTG_EMA200_U30USD_{IS,OOS}_r31.csv` · riprodotto 3× (R31→R110→R112, primo **G0-B** della macchina). E in più: **84 celle su 84 positive** a tick sull'intero periodo (`risultati_valid_ABTG_EMA200_H1_realtick/valid_ABTG_EMA200_H1_realtick_U30USD.csv`), con la cella viva a **+2.502,70** e il picco a **+2.796,85** → **la sedia sta nell'altopiano, NON sul picco** | — |
| **2** | **n e DD** | 🟠 **SI in DEAL · PARZIALE in POSIZIONI** | **DD equity OOS 7,8323% · IS 5,7325%** (tick, 1%) ✅. **n OOS = 517 deal = 257 POSIZIONI**, 🆕 **misurato oggi** contando i `position_id` su `risultati_archivio/R112_CORSA_20260826/pertrade_00_metro_763400.csv` (rapporto **2,0117**). 🔴 **n IS in posizioni = [NON MISURATO]**: il per-trade IS non esiste in archivio; stima **102-118** → **sotto il pavimento di 150** | **`prove/COLLAUDO_EMADOW_02_pertrade_IS.txt`** — 1 cella × 2 gemelli = **2 passate, una sola gamba**. Costo: **~1 minuto** |
| **3** | **gestione dell'uscita messa ad asse** | 🔴 **NO** | Verificato colonna per colonna su **tutti** i CSV di questo EA: su U30USD sono mai variati solo `InpOrder1Atr`, `InpOrder2Atr`, `InpTP_RR` (R29b, R28) e i due lati (R110/R112). **`InpTP1Pct`, `InpBreakeven`, `InpUseTrailing`, `InpSLatr`, `InpPendingExpiryBars` non hanno MAI variato in NESSUN CSV di `ABTG_EMA200`, su NESSUN simbolo.** La macchina che produce il rapporto 2,01 deal/posizione — parziale 50% + breakeven + trailing EMA14, **cioè quella che fa il DD** — non è mai stata confrontata con un'alternativa **`prove/R136a/b/c/d_*_U30USD.txt`** — quattro assi (`InpSLatr` · `InpTP1_ATRmult` · `InpTP1Pct` · `InpUseTrailing`), **40 passate**, ~15 min. 🤝 **Scritti da un ALTRO agente lo stesso pomeriggio** (commit `63e10ba`): i miei `03`/`04` sono **RITIRATI** in loro favore — vedi §7.1 |
| **4** | **simboli gemelli provati** | ✅ **SI, ampiamente** | **Screening H1 su 48 simboli**: `risultati_prove/risultati_scan_ABTG_EMA200_H1/` — U30USD **98/98 celle positive**, XAUUSD 58/86, 225JPY 27/78, e sugli altri indici **D30EUR 0/80 · E50EUR 0/83 · F40EUR 0/81 · NASUSD 2/83 · SPXUSD 4/86**. **A tick**: U30USD 30/30 PASS, EURUSD 7/30, XAUUSD 0/30 IS, **225JPY 30/30 IS e 0/30 OOS** (`REFERTO_ROUND32_EMA200_ORO_NIKKEI.md`) | — ⚠️ ma leggere il §4: **questo requisito è soddisfatto e la risposta è scomoda** |
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

### 🟠 VERDETTO C3, contro i criteri congelati stamattina
- **PASS** richiedeva entrambe le gambe sopra 40× in sessione: la gamba 2 fa **41,8×** ✅ ma **solo 12 celle su 24** ci arrivano.
- **FRAGILE** = gamba 2 fra 30× e 40×: **37,1× di mediana complessiva** → 🟠 **FRAGILE**, e il motivo è la **notte**: 33,2×, dove cade il **44,3%** delle uscite.
- 🟢 **Correzione al dossier, a favore della sedia**: «la gamba 2 non arriva a 40× in nessuna fascia» era vero sui **3 eventi del campo** (65,5-78,0 pt). Sulla **finestra intera** la gamba 2 mediana è **88,2 pt** e in sessione **passa**. Il difetto non è la geometria: è **l'orario**.
- 🔧 E la riparazione **non** è `InpSLatr` (R118: costa edge in modo **non riproducibile**, OOS 29/56 = una monetina). È **`InpMaxSpread`**, che **l'EA ha già** (`.mq5` r.507, confronto in **punti MT5**, chiamato al r.325 al momento del segnale): tagliare le ore larghe **senza toccare la geometria**. È l'asse della prova **00**.

---

# 5. 📊 LA FREQUENZA — **e qui c'è il rilievo nuovo**

| unità | sedia sola | famiglia come la conta il dossier | pavimento 1,00 |
|---|---:|---:|---|
| **uscite/giorno feriale** | **1,901** (517/272) | 1,850 | ✅ passa |
| **posizioni/giorno feriale** | **0,945** (257/272) | **1,245** (0,945 + 0,30 di `971501`) | 🟠 passa **solo come famiglia** |

### 🔴 LA FAMIGLIA PASSA CONTANDO UNA SEDIA CHE NON È SCHIERABILE
Lo 0,30 op/giorno che porta la famiglia da 0,945 a 1,245 è di **`971501` = `ABTG_EMA200_Ottimizzato` XAUUSD H4**. E su quella sedia il verbale è già scritto: **DD 45,91% a rischio 1% su 22 anni**, e la riga di `CENSIMENTO_CONTRATTI.md` r.231 dice testualmente **«prop: NO a nessuna taglia» (firma 23/08)**.

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
- **Swap / rollover: [NON MISURABILE]** da questi CSV. ⚠️ E per **questa** sedia conta più che per altre: `InpUseCutoff=false` + `InpMaxTradesPerDay=0` ⇒ tiene posizioni **overnight** e apre anche **all'ora 23**, dove il p95 dello spread è **7,0** e il massimo misurato **101** punti indice.

---

# 7. 📦 IL PACCHETTO — sette file prova, ordinati per **valore/costo**

Tutti in `backtest_pipeline/prove/`, **ASCII puro**, corpo = **copia riga per riga** dell'antenato `R112_00_metro.txt` (che è **identico al preset vivo su 46 chiavi su 46** — verificato oggi; unico delta `InpMagic`), magic dal blocco **vergine 7666xx** (0 occorrenze repo-wide), **attesa dichiarata e uscite possibili scritte DENTRO ogni file**.

| ord. | file | che numero produce | passate | ⏱️ stima | perché è in questa posizione |
|---|---|---|---:|---|---|
| **1** | **`LATI_A1/A2_EMA200_U30USD_*` (4 file, GIÀ SCRITTI il 09/09)** | lato × regime sulla **discesa** 2025.02-04, con sentinella sui bersagli R110 | **8** | ~3 min | 🥇 **esiste già, è gatato, e risponde alla domanda più grossa del dossier.** Zero lavoro di preparazione |
| **2** | `COLLAUDO_EMADOW_02_pertrade_IS.txt` | **n IS in POSIZIONI** — chiude il requisito 2 e il cancello 5 | **2** | ~1 min | il numero più economico del lotto, e sblocca un cancello |
| **3** | `COLLAUDO_EMADOW_00_canarino_spread.txt` | (a) il tester porta lo spread vero? (b) **la manopola `InpMaxSpread`** che ripara il C3 | **10** | ~4 min | sblocca la scala A **e** consegna la riparazione del C3 senza toccare la geometria |
| **4** | **`R136a/b/c/d_*_U30USD.txt` (4 file, di un ALTRO agente, commit `63e10ba`)** | requisito 3 — `InpSLatr`, `InpTP1_ATRmult`, `InpTP1Pct`, `InpUseTrailing` | **40** | ~15 min | 🤝 **vedi il §7.1: i miei 03 e 04 sono RITIRATI in favore di questi**, che misurano la stessa cosa **più larga** |
| **5** | `COLLAUDO_EMADOW_05_tf_U30USD.txt` | requisito 5 — H1 è un altopiano o una fortuna? | **14** | ~6 min | l'unico asse mai provato sul simbolo schierato |
| ~~6~~ | ~~`COLLAUDO_EMADOW_03/04_uscita_*`~~ | ~~requisito 3~~ | ~~14~~ | — | 🚫 **RITIRATI** (duplicati di `R136c`/`R136d`) |
| **7** | `COLLAUDO_EMADOW_06_latenza.txt` | scala `ExecutionMode` 0/50/100/500 ms | **8** | ~3 min | il canarino è già pagato; attesa: **fermo** (entra con LIMIT) |
| **8** | `COLLAUDO_EMADOW_01_spread_scala_ini.txt` | scala spread +25/+50/+100% | **8** | ~3 min | 🔴 **si lancia SOLO se il canarino (3) dice SI.** Altrimenti va archiviato NON lanciato |
| | **TOTALE** (senza i due ritirati, con r136 al loro posto) | | **76** | **~31 min** | |

### 7.1 🤝 UNA COLLISIONE FRA AGENTI, TROVATA E RISOLTA OGGI STESSO
Mentre preparavo questo pacchetto, **un altro agente ha committato nello stesso pomeriggio** (`63e10ba`, *«r136a-d: l'uscita della sedia migliore della flotta, 4 file, 40 passate»*) **quattro file prova sulla STESSA cella e sulla STESSA domanda**: `InpSLatr` · `InpTP1_ATRmult` · `InpTP1Pct` · `InpUseTrailing`.

| il mio file | il suo | sovrapposizione |
|---|---|---|
| `COLLAUDO_EMADOW_03_uscita_TP1PCT.txt` (`InpTP1Pct` 0/25/50/75/100) | `R136c_parziale_U30USD.txt` (0/25/50/75) | 🟠 **quasi identica** — al suo manca la cella **100** |
| `COLLAUDO_EMADOW_04_uscita_TRAILING.txt` (`InpUseTrailing` 0/1) | `R136d_trailing_U30USD.txt` (`1\|\|0\|\|1\|\|1\|\|Y`) | 🔴 **IDENTICA, carattere per carattere** |

👉 **Ho RITIRATO i miei due** (nota di ritiro scritta **dentro** i file, non cancellati: restano come record del requisito 3) e la voce 4 della tabella qui sopra punta a **r136**, che è **più largo** (copre anche lo stop e il primo bersaglio, e ha criteri suoi).
🔴 **Perché non li ho tenuti entrambi**: due file prova che misurano la stessa variabile sulla stessa cella con magic diversi sono il modo più rapido di ottenere **due numeri che litigano** — e il progetto ha già speso giornate a riconciliare DD incompatibili.
🎁 **E il rilievo da girare a chi ha scritto r136**: alla `R136c` manca la cella **`InpTP1Pct=100`**. A 100 il rapporto deal/posizione va a **1,00**, che è esattamente il numero della **classe 226** e chiuderebbe il cancello del campione senza ambiguità. Costa **1 cella = 2 passate**.
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
I sette file girano sul **driver generico**, che ha già tutti i parametri che servono (`-Prova`, `-Etichetta`, `-Spread`, `-Ritardo`, `-Deposito`, `-SoloControllo`). Parametri congelati, identici al banco di R112 — **niente si cambia dentro un collaudo**:

```
prove 00 / 03 / 04 / 05 / 06 / 01  (finestra piena, split 40/60):
  -Expert ABTG_EMA200 -Prova prove\COLLAUDO_EMADOW_<NN>_<nome>.txt
  -Simbolo U30USD -Periodo H1 -DaQuando 2024.09.26 -Fino 2026.06.30
  -FrazioneIS 0.40 -Modello 4 -Deposito 100000 -Etichetta COLL_<NN>
     prova 01: aggiungere -Spread 0 | 238 | 285 | 380   (quattro corse)
     prova 06: aggiungere -Ritardo 0 | 50 | 100 | 500   (quattro corse)

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

🪟 **BERSAGLIO, per la regola del 12/09: PC DI BACKTEST, terminale `50504400` (`C:\MT5_Backtest`).** Sul VPS **non si lancia niente** — lì vivono i quattro terminali BCM (`50503392`, `50504263`, `10105439`, `50504400`) più Pepperstone e Tickmill, e **nessuno di loro viene toccato da questo pacchetto**.
🔴 **Manca ancora, e lo dico invece di improvvisarlo**: il wrapper `.ps1` con marcatore + `irm` dal branch `lavoro` + riga di raccolta (zip sul Desktop). Uno script nuovo **deve** passare i due cancelli prima di esistere: scriverlo male adesso costerebbe più del tempo che fa risparmiare.

---

# 8. 🧱 COSA MANCA CHE **NON** È UN NUMERO — e non lo chiude il tester

| # | cosa manca | stato misurato | di chi è |
|---|---|---|---|
| **1** | **Il preset del 100k (`881531`) NON ESISTE** | `mql5/Presets/` ha `*_100K.set` per `ABTG_DAX_Apertura_EU` e `ABTG_Dow_Apertura_US`. **Per `ABTG_EMA200` non c'è.** Il solo preset è `sedie_piccolo/recupero2/sedia_ABTG_EMA200_771531.set` (magic del piccolo, `InpRiskPercent=1.0`) | 🔴 va **creato**: magic `881531`, `InpRiskPercent` = **[FIRMA DI CLAUDIO]** (il piano migrazione dice 0,65%), le altre 45 chiavi **copiate identiche**. ⚠️ E va coperto anche `InpLogImbuto` (input del 11/09, **assente dal preset**) |
| **2** | **I 5 cancelli della FASE 1** | 🔴 **nessuno verde** al 09/09; collaudo *«in corso»* dal 02/09 | il piano, non il tester |
| **3** | **Il tetto per cluster/valuta al 3,0%** | **firmato** il 07/09, **implementato** nel Guardian, ma **non valorizzato in nessun preset** e **assente dalla versione in campo**. Questa sarebbe l'**11ª sedia sul Dow** | `[FIRMA DI CLAUDIO]` — *«va valorizzato e portato in campo»*, non *«va implementato»* |
| **4** | **Il buco B6 (pendenti invisibili al cap C1)** | questa sedia piazza **2 LIMIT per segnale** e il Guardian conta solo `PositionsTotal()`. Misurato sul vivo con l'oro: 4 pendenti = **3,94%** contro un cap di 3,25% | codice del Guardian, non questo collaudo |
| **5** | **L'unità di conto dei cancelli (uscita o posizione)** | aperta dal **26/08**, decide **due cancelli su cinque** | `[FIRMA DI CLAUDIO]` |
| **6** | **Il DD promesso nel contratto** | oggi `CENSIMENTO_CONTRATTI.md` dice **7,21%** (R29, dep. 10k); il numero riprodotto 3× è **7,8323%** (dep. 100k) | `[FIRMA DI CLAUDIO]` — col numero sbagliato scatta una revisione che non serve, o non scatta quella che serve |

---

# 9. 🏁 IL VERDETTO SECCO

> ## 🟢 **SCHIERABILE IL 1° OTTOBRE: SI — ma non oggi, e non per mancanza di tempo macchina.**
>
> ⏱️ **Quello che manca in MISURE costa 64 passate, ~26 minuti di tester, meno di un'ora con l'overhead. Zero notti.** Il metro è misurato (R112: 16 passate in 0,1 ore sulla stessa cella).
>
> 🔴 **Quello che manca in FIRME non lo produce nessun backtest**, e sono **tre decisioni**: l'**unità di conto** (decide 2 cancelli su 5), la **taglia d'ingresso**, e il **tetto per cluster** su un simbolo che ha già **10 sedie**.
>
> 📅 **Diciannove giorni al 1° ottobre.** Le misure stanno in una mattina. Le firme stanno in una sera. **Non c'è nessun ostacolo da settimane in questo dossier** — e questo è il motivo per cui è la cosa più importante che abbiamo.

### ✅ Quello che questa sedia ha, e che nessun'altra delle 41 ha
PF riprodotto **tre volte al centesimo** · **84 celle su 84 positive** a tick sull'intero periodo, con la sedia **nell'altopiano e non sul picco** · **due lati misurati** · rischio dichiarato **= rischio vero** · pavimento del lotto che **non morde** · e ora anche **la scala di slippage misurata, che passa con 3,7× di margine sul gradino standard**.

### 🔴 Quello che resta scomodo, detto senza addolcire
**Un regime solo** (e non è riparabile in casa) · **C3 FRAGILE** sulla gamba 2, per colpa della **notte** · **la famiglia degli schierabili sta sotto il pavimento di frequenza in posizioni** · **lavora a raffiche** (2-8 posizioni in un giorno su 37,5% dei giorni) e il **flottante** è **[NON MISURATO]** · ed è **il vicino più pericoloso del Dow**, dove ci sono già 10 sedie e il tetto per cluster è **spento**.

---

_🛑 **Zero modifiche al forward. Nessun EA, preset, parametro, magic o grafico toccato. Nessun backtest lanciato. Nessuna promozione, nessuna accensione, nessuna spesa autorizzata.** Rischio e taglie sono di Claudio; lo schieramento è una sua decisione._

_Fonti nuove aperte da questo referto: `risultati_archivio/R112_CORSA_20260826/pertrade_00_metro_763400.csv` (posizioni, stop pieni, scala di slippage, peggior giornata, raffiche) · `risultati_prove/risultati_valid_ABTG_EMA200_H1_realtick/valid_ABTG_EMA200_H1_realtick_U30USD.csv` (84/84 celle) · `risultati_prove/risultati_scan_ABTG_EMA200_H1/` (48 simboli) · `risultati_archivio/ritardo_r119b_csv/` (canarino latenza già pagato) · `risultati_archivio/spread_flotta/spread_orario_U30USD.csv` · `prove/LATI_A1/A2_EMA200_U30USD_*.txt` (mai lanciati) · `prove/R118_PAVIMENTO_STOP_CRITERI.md` §4.3 · `walkforward_generico.ps1` r.165-235._
