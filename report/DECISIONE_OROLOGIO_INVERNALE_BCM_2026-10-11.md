# 🕰️ DECISIONE: l'orologio d'inverno di BCM (scade il 25/10/2026)

**11/10/2026** · branch `lavoro` · **BOZZA, NON PASSATA DAL CANCELLO** · SOLA LETTURA del repo: nessun EA, preset, sedia, conto o taglia toccati, nessuna decisione presa al posto tuo. Il conto reale `10105439` compare solo dove i documenti lo nominano: nessuna proposta su di lui.
Etichette: **FATTO** = contato o letto alla fonte · **INFERITO** = ragionamento o previsione · **NON MISURATO** / **NON TROVATO** = buco dichiarato.
Misura madre: `report/OROLOGIO_BCM_2026-09-24.md` (sigla **OROL** nelle fonti). Stato delle sedie: sonde di sola lettura del 11/10 03:30 (`backtest_pipeline/coda/referti/CODA_01_..._20261011_033004.log` e `CODA_08_..._20261011_033004.log`, sigle **C01** e **C08**).

---

## 1. 🎯 IN BREVE

1. **FATTO**: BCM oggi e' UTC+1 fisso, senza ora legale. Quando l'Italia torna all'ora solare (domenica 25/10) l'ora BCM diventa **uguale all'ora italiana**. Dal **lunedi' 26/10** `InpSessionHour=8` sul DAX significa 08:00 italiane, **un'ora prima** di Xetra (09:00). Dal **lunedi' 02/11** (gli USA tornano all'ora solare il 01/11) `14:30` BCM significa 8:30 New York, **un'ora prima** della cash (9:30). (OROL r.13-32; `CLAUDE.md` r.449-462)
2. **FATTO**: i backtest d'inverno delle sedie d'apertura hanno gia' girato cosi' (un'ora prima): il 44-62% delle uscite dei loro numeri di contratto viene da quei mesi. Per questo i contratti mescolano due tempistiche. (OROL r.219-223)
3. **Oggi su BCM nessuna sedia a indici e' accesa** (sospese il 24-25/09 per il divieto FTMO di posizioni opposte): per BCM la decisione riguarda i numeri di contratto e un eventuale **rientro**. Restano accese, con ora fissa: MaxMinNotte oro `770402`, ORB argento `770611`, EasyTrend `772421`/`772422` (piccolo `50503392`), ORB EURAUD `770611` (reale `10105439`), Guardian con reset a ora fissa. (C01 r.15-43, 76-85, 97-99)
4. **FTMO**: la trial `1514806751` ha le sedie indice con l'ora scritta in ora FTMO ed **e' in scadenza il 14/10**, prima del cambio. Se FTMO segue l'ora legale europea (**INFERITO**, mai misurato) restano in fase con la cash; cosa fa il server FTMO il 26/10 e' **NON MISURATO**. Dopo il 14/10 nei documenti non c'e' un conto FTMO vivo. (`report/FTMO_TRIAL_AUTOPSIA_2026-10-08.md` r.6; `report/PRIORITA_EA_E_DA_FARE_2026-10-08.md` r.29)
5. **La causa NON e' dimostrata**: sul DAX d'inverno armare un'ora prima ha dato PF 1,39 (168 operazioni) contro 1,18 alla cash (138), ma d'estate l'opposto (0,77 contro 1,11). Non esiste una firma tua sull'orologio d'inverno (NON TROVATA in `report/FIRME_*.md`). Le opzioni sono nella sezione 4, **la scelta e' tua**.

---

## 2. 📋 TABELLA: chi dipende da un'ora fissa

Ora "vera" d'inverno = quando apre davvero il mercato che la sedia vuole agganciare, scritta in ora server. Per BCM: Xetra 09:00 CET = **09:00 server**; cash USA 9:30 NY (ora solare) = **15:30 server**. Sfasamento: negativo = la sedia arma **prima** del mercato.

### 2a. Terminali BCM (server UTC+1 fisso) e reale

| sedia | magic | conto / terminale e stato all'11/10 | ora impostata (server) | apertura vera d'inverno (server) | sfasamento d'inverno | fonte |
|---|---|---|---|---|---|---|
| DAX Apertura long | 770101 | piccolo `50503392`: **sospesa** dal 25/09; 100k `50504263`: solo **residuo** nel profilo `Default` non attivo; OROL la cita anche sul reale `10105439`, oggi **non attaccata** | 08:00, chiusura 17:30 | 09:00 | **-60 min** dal 26/10 | OROL r.273 · `SOSPENSIONE_SEDIE_DEMO_2026-09-25.md` r.36 · C01 r.81, 97-99 · preset `mql5/Presets/ABTG_DAX_Apertura_EU_D30EUR_M5_770101_100K.set` r.161 |
| MaxMin DAX short | 770411 | piccolo: **sospesa**; 100k: residuo non attivo | box 23:00-04:59, piazza 07:59, taglio ingresso 08:30, chiusura 17:30 | 09:00 | **-60 min**: la finestra d'ingresso (07:59-08:30) cade **tutta prima** della cash; "diventa un breakout pre-cash" | OROL r.274 · `REGIME_DAX_SPEC_2026-10-05.md` r.109 · C01 r.83 |
| Dow Apertura long | 770202 | piccolo: **sospesa**; 100k: residuo non attivo | 14:30 | 15:30 | **-60 min** dal 02/11 (fino al 01/11 e' giusta) | OROL r.275 · `SOSPENSIONE...` r.37 · C01 r.82 |
| Nasdaq Apertura | 770250 | piccolo: **sospesa** | 14:30 | 15:30 | **-60 min** dal 02/11 | OROL r.276 · `SOSPENSIONE...` r.44 |
| ORB Dow (U30USD) | 770611 | 100k: residuo non attivo; piccolo: tolta il 25/09 | range 14:30-14:45 | 15:30 | **-60 min** dal 02/11 | OROL r.277 · C01 r.85 · `SOSPENSIONE...` r.43 |
| **ORB argento (XAGUSD H4)** | 770611 | piccolo `50503392`: **ATTIVA** | range 14:30-14:45, fine 21:00 | 15:30 se l'aggancio e' la cash USA (che sia quella l'ora che conta per l'argento: **NON dimostrato**) | **-60 min** dal 02/11, **INFERITO** | C01 r.41 · C08 r.1836-1846 · `RESOCONTO_EA_G2_EMA200_SW_ORB_2026-10-05.md` r.314 |
| **ORB EURAUD (H1)** | 770611 | **reale `10105439`**: ATTIVA (decisione tua, nessuna proposta) | range 14:30-14:45, fine 21:00 | 15:30 (il documento la legge come 9:30-9:45 New York) | **-60 min** dal 02/11, **INFERITO** | C01 r.99 · C08 r.2924-2934 · `ORB_EURAUD_SUL_REALE_2026-09-25.md` r.208-209 |
| **MaxMinNotte oro** | 770402 | piccolo: **ATTIVA** | box 23:00-04:59, piazza 07:00, taglio 08:30, chiusura 17:30 | l'oro non ha una cash: nessuna apertura da agganciare | **INFERITO**: in ora italiana il box scende da 00:00-05:59 a 23:00-04:59, cioe' **un'ora prima** di quanto la maggior parte di R103 ha misurato; effetto **NON MISURATO** | C01 r.33 · C08 r.1271-1286 · `STATO_MAXMIN_DAX_LONG_E_ORO_2026-09-26.md` r.213-226 |
| **EasyTrend CHFJPY / GBPUSD** | 772421 / 772422 | piccolo: **ATTIVE** | finestra 08-18 | rispetto a Londra la finestra scivola di 1h (07-17 ora di Londra) | **-60 min** rispetto a Londra, **INFERITO** | C01 r.29-30 · C08 r.972-973, 1060-1061 · OROL r.281 |
| **PostNews NFP / ECB / FOMC** | 771203 / 771201 / 771202 | piccolo: **ATTIVE** | NFP 14:45, ECB 15:00, FOMC 19:40 (azione) | NFP 14:30, ECB 14:15, FOMC 19:00 (28/10) e 20:00 (09/12) | **gia' regolate** per NFP, ECB e FOMC del 28/10; **il FOMC del 09/12 va portato a 20:40/21:45** (promemoria, dopo il 28/10) | C08 r.1530-1540, 1601-1611, 1672-1682 · `POSTNEWS_TRE_SEDIE_2026-10-02.md` r.43-44, 50-57 |
| Guardian 779001 (100k) / 779002 (reale) | 779001 / 779002 | `50504263` AUDNZD; `10105439` EURGBP: **ATTIVI** | reset 23 | 23 server = mezzanotte italiana d'estate | d'inverno reset alle **23:00 italiane**, 1h prima di mezzanotte | C08 r.2754, 2910 · OROL r.315-319 |

### 2b. FTMO trial `1514806751` (`C:\FTMO`, scade il 14/10) — ore scritte in ora FTMO

Profilo attivo letto dalla sonda: 770202, 770260, 770511, 770411, 770105, 770621, Bulge 772720, Guardian 779001. **`770101` e `771531` NON compaiono** (erano tra le sette del 01/10: vedi domande).

| sedia | magic | ora impostata (FTMO) | fonte |
|---|---|---|---|
| DAX Apertura short | 770105 | 10:00, chiusura 19:30 | C08 r.2438-2445 |
| Dow Apertura long | 770202 | 16:30, chiusura 19:30 | C08 r.2084-2093 |
| Nasdaq Apertura | 770260 | 16:30, chiusura 19:30 | C08 r.2172-2181 |
| MaxMin DAX short | 770411 | box 01:00-06:59, piazza 09:59, taglio 10:30, chiusura 19:30 | C08 r.2362-2378 |
| ORB Dow | 770621 | range 16:30-16:45, fine 23:00 | C08 r.2527-2537 |
| SuperWave Dow H1 | 770511 | nessun filtro orario (finestra spenta) | C08 r.2312-2314 |
| Guardian | 779001 | reset 1 | C08 r.2337 |

Server FTMO misurato **UTC+3** il 20/09 e "IT+1" il 01/10 (`docs/REGOLAMENTO_FTMO_2026-09-20.md` r.187-188; `HANDOFF.md` r.17). Cosa fa il 26/10 e' **NON MISURATO**: tre ipotesi (OROL r.306-309; `PRESET_FTMO_OROLOGIO_2026-09-20.md` r.477-490).

| se FTMO... | DAX 10:00 (770105, 770411) | USA 16:30 (770202, 770260, 770621) | reset Guardian 1 |
|---|---|---|---|
| **segue l'ora legale europea** (UTC+2 dal 25/10) | in fase tutto l'inverno | **1h tardi (10:30 NY) nei 5 giorni 26-30/10**, poi in fase | in fase |
| **segue quella americana** (UTC+2 dal 01/11) | **1h presto nei 5 giorni 26-30/10**, poi in fase | in fase sempre | **1h presto nei giorni 26-31/10** (azzera alle 23:00 italiane) |
| **resta UTC+3 fisso** | **1h presto per tutto l'inverno** | in fase fino al 01/11, poi **1h presto** (8:30 NY) | **1h presto** |

(Tabella derivata da me con l'aritmetica degli orari: **INFERITO**. Coincide con le tre ipotesi dei documenti citati.)

**Non toccano l'ora fissa** (nessun input orario in C08): BreakingBand, GapFill, PunteLarry, CostToCost, PTE GBPUSD, EMA200 AUDCHF (taglio spento), SupertrendReversal oro (finestra spenta), Bulge, Azzurra, EMA200 Ombra. Non in campo: Nasdaq PreOpen (esterno, mai girato, fuso cablato: `CENSIMENTO_ORB_2026-09-29.md` r.59, 121).

---

## 3. 🔬 COSA SAPPIAMO E COSA NO

### FATTO
- **L'orologio**: quattro ancore su quattro (domenica 23:05, pausa 23:00, dati USA 14:30, cash 15:30, Xetra 09:00) dicono UTC+1 fisso nell'inverno 2025/26. Domeniche d'inverno con primo affare alle 23:xx: **9 su 9** dal 02/02/2025, contro 14 su 58 nei vecchi inverni. (OROL r.71, 115-120, 197-201)
- **Data del cambio forex**: fra il 26/12/2024 23:03 e il 02/02/2025 23:05, al giorno **NON MISURATA**. Indici in UTC+1 fisso gia' da nov 2024. (OROL r.152-176)
- **I contratti mescolano due tempistiche** (uscite dal 10/06/2025 al 29/06/2026, tick reali): (OROL r.219-225)

| sedia | n allineati | PF allineati | n sfasati | PF sfasati |
|---|---:|---:|---:|---:|
| 770202 Dow | 73 | **0,78** (-2.415,84) | 57 | 1,66 (+9.137,77) |
| 770101 DAX | 144 | 1,27 | 126 | 1,48 |
| 770411 MaxMin | 8 | 2,03 | 13 | 2,25 |
| 771531 EMA200 H1 (non dipende dall'ora) | 347 | 2,05 | 170 | **0,87** |

  Lettura onesta: l'EMA200, che l'ora non tocca, fa lo stesso salto fra le due meta' dell'anno. Quindi la **stagione da sola** produce differenze di questa taglia. (OROL r.247-252)
- **R246 inverno (29/09, tick BCM, stesso inverno, cambia solo l'ora)**: arma un'ora prima / alla cash. (`LETTURA_R246_INVERNO_2026-09-29.md` r.20-22)

| sedia | un'ora prima della cash | alla cash |
|---|---|---|
| DAX 770101 | PF 1,389 · 168 op · 0,764 al giorno | PF **1,184** · 138 op · **0,627** al giorno |
| Dow 770202 (sospeso, fragile) | PF 1,492 · 68 op | PF 0,916 · 40 op |
| MaxMin 770411 | PF 2,558 · 16 op | PF 0,996 · 17 op |

- **D'estate, stessa prova, esito opposto sul DAX**: un'ora prima PF **0,774**, alla cash 1,108; drawdown di saldo 14,05% contro 5,55%. (`LETTURA_R246_INVERNO...` r.35)
- **Frequenza DAX**: il verdetto e' "orologio" (arma alla cash = meno operazioni). Ma 138 operazioni sono sotto le 150 richieste: indizio, non prova. (r.25)
- **Drawdown d'inverno delle sedie BCM com'e' oggi** (un'ora prima): Dow 4,60%, DAX 5,20%, in linea con l'estate. (`REFERTO_R246_2026-09-24.md` r.182)
- **Monte Carlo ex-challenge FTMO**: 74,6% riferimento contro 70,8% se i giorni sfasati si leggono in fase (-3,8 punti). La challenge `541452707` e' finita il 30/09, quindi e' un dato storico. (`MC_MESI_ALLINEATI_2026-09-24.md` r.52-53)

### INFERITO
- BCM restera' UTC+1 fisso dal 26/10 (previsione: l'ultimo inverno misurato lo era). Si chiude lunedi' 26/10 in 10 secondi (OROL r.353-357).
- Che il server della trial sia identico a quello della challenge e segua l'ora legale europea: `CLAUDE.md` r.462 scrive "FTMO IT+1 tutto l'anno" come fatto, ma l'evidenza e' solo "+03:00 d'estate" e la dicitura "CE(S)T" della pagina FTMO. (`docs/REGOLAMENTO_FTMO_2026-09-20.md` r.190-193)
- Se FTMO e' in fase d'inverno, la casella "alla cash" di R246 e' la migliore stima di cosa farebbero le sedie FTMO, con residui (feed, rischio 2,00%, Guardian, candela H4 del Dow). Serie "come FTMO": DAX PF 1,143 su 295 op con drawdown di saldo **9,50%** contro 6,06% del contratto; Dow 0,836 su 123 (drawdown 5,74% contro 4,65%); MaxMin 1,187 su 28 (5,40% contro 2,00%). (`LETTURA_R246_INVERNO...` r.36-38)

### NON MISURATO
- **Perche'** d'inverno la cella un'ora prima rende di piu' sul DAX: stagione o orologio. Per il Dow: 770202 estate 0,886 su 84, inverno 1,493 su 68, intervallo della differenza [-0,42 ; +1,86] che **contiene lo zero** (p 0,15); togliendo due mesi l'inverno scende a 1,004. (`IL_MERITO_E_D_INVERNO_2026-09-25.md` r.20-24)
- **Nasdaq RETEST 770260 / 770250**: per-trade non in repo (OROL r.224); R274a-d (16 passate) **scritti, non girati**, lettore da scrivere, secondo strato non fatto. (`RESOCONTO_EA_G1_APERTURE_2026-10-05.md` r.257)
- **ORB, MaxMinNotte oro, EasyTrend**: nessuna misura con le due tempistiche separate.
- **Il lato opposto** (short Dow, long DAX/MaxMin) con la regola dei due lati; il costo `stop >= 40 x spread` in pre-mercato (limite inferiore 25,5x Dow, 20,2x DAX). (`REFERTO_R246...` r.223-233)
- **La settimana 26-30/10 su FTMO**; i giornali MT5 di nov 2025-mar 2026 (**NON TROVATI**, OROL r.359-362).

---

## 4. ⚖️ LE OPZIONI (nessuna scelta fatta qui)

Qualunque opzione che tocca parametri o accende/spegne sedie e' **una tua firma**. Ricordo il fatto che le rende diverse: oggi sulle indici BCM non c'e' niente di acceso.

| opzione | cosa cambia | costo | rischio | chi la fa |
|---|---|---|---|---|
| **A. Spostare d'inverno l'ora sui preset BCM** (portare l'ingresso alla cash: DAX +1h, USA +1h, per MaxMin anche piazza e taglio) | le sedie armano all'apertura vera, come FTMO se e' in fase. Il numero esatto di ogni input va definito e passato dal cancello (non lo propongo qui) | modifica di preset + F7 a mano su ogni grafico; **e va rifatta in primavera** (USA 14/03/2027, UE 28/03/2027). Sulle indici BCM serve anche rimetterle in campo (sospese) | la cella "alla cash d'inverno" e' misurata solo su DAX, Dow e MaxMin e con n sotto 150 (138 / 40 / 17): DAX 1,18 invece di 1,39. Nasdaq e ORB mai misurati. Il Dow e' sospeso e fragile | tu firmi parametri; io preparo il preset; tu premi F7 sul terminale giusto |
| **B. Lasciare com'e' e dichiarare lo sfasamento** | niente nei preset. Le schede e i contratti dicono che d'inverno le sedie BCM armano un'ora prima, "come il backtest d'inverno" | nessuno sul campo; la dichiarazione la scrivo io | scommetti sul pre-cash d'inverno (DAX 1,39) ma d'estate il pre-cash ha perso (0,77, drawdown 14%): se la causa e' la stagione, e' una scelta che funziona per caso. Su FTMO le sedie farebbero comunque un'altra cosa (se in fase) | tu confermi; io documento (e riscrivo la regola "FUSO ORARIO" di `CLAUDE.md`, proposta di OROL r.368-372) |
| **C. Spegnere (tenere spente) le sedie a ora fissa nei mesi sfasati** (DAX: 26/10-28/03/2027; USA: 02/11-14/03/2027) | su BCM le indici sono gia' ferme; resterebbero fuori anche oro 770402, ORB, EasyTrend se le includi | nessuno di rischio; si perdono ~5 mesi di forward per sedie che devono arrivare a 15-20 operazioni | scegli di non osservare proprio il periodo che non sappiamo leggere. Il criterio di uscita del 18/08 non e' un'uscita per merito: va dichiarato | tu firmi lo spegnimento; io non tocco i profili |
| **D. Rimisurare prima, sul PC di backtest, con l'ora giusta** | arriva un numero in piu' per Nasdaq (R274a-d), ORB, MaxMin; DAX gia' misurato (R246). Variante B del DAX con feed 2010-2018 (circa 6 inverni) richiede la firma D-K e, secondo la fonte, **probabilmente non arriva prima del 25/10** (condizionale: dipende dai giorni di codice e dai due cancelli di P1; `REGIME_DAX_SPEC_2026-10-05.md` r.466) | tempo macchina del PC di backtest (mai il VPS: regola del 21/09); R274: 16 passate, 5-24 min dichiarati; prima va scritto il lettore e passato il secondo strato | se la misura non rientra entro il 25/10 si decide comunque, e il default di fatto e' B. Una griglia su un motore senza edge e' vietata (regola 19/08): qui si misurano orologio e uscita, non parametri | io scrivo lettore e righe e le passo dal cancello; **tu le lanci** sul PC di backtest |

Le opzioni si combinano. Un modo per spezzare la decisione in pezzi piu' piccoli:
- **(i)** le sedie vive non-indice (oro 770402, ORB argento, EasyTrend), a ora fissa e senza cash da agganciare;
- **(ii)** un eventuale rientro delle indici BCM (oggi sospese dal divieto FTMO sulle posizioni opposte);
- **(iii)** i preset per un futuro conto FTMO.

---

## 5. 📅 DATE E COSA SERVE A TE

| data | cosa succede | fonte |
|---|---|---|
| **14/10** | scade la trial FTMO `1514806751` | `FTMO_TRIAL_AUTOPSIA_2026-10-08.md` r.6 |
| **25/10 (domenica)** | l'Italia torna all'ora solare. **Scadenza della tua decisione.** Cade di domenica: il primo effetto e' lunedi' mattina | `CLAUDE.md` r.462 |
| **26/10 (lunedi')** | DAX: 08:00 BCM = 08:00 italiane, prima di Xetra. **Misura di 10 secondi** sul piccolo `50503392`: ora dell'ultima candela M1 contro l'orologio di Windows. Oggi differiscono di 1h; se coincidono BCM e' UTC+1 fisso. Sullo stesso giorno, se esiste un terminale FTMO, la stessa lettura dice quale ipotesi vale | OROL r.353-357 |
| **28/10, 29/10, 06/11** | FOMC `771202`, ECB `771201`, NFP `771203` (le tre PostNews sono gia' regolate per questi giorni) | `POSTNEWS_TRE_SEDIE_2026-10-02.md` r.26-28 |
| **01/11 (domenica) · 02/11 (lunedi')** | USA tornano all'ora solare: 14:30 BCM = 8:30 New York. Seconda lettura FTMO | `APERTURE_NASDAQ_MAPPA_2026-10-03.md` r.209-210 |
| **09/12** | FOMC: il secondo F7 sul `771202` (20:40 / 21:45) | `POSTNEWS_TRE_SEDIE_2026-10-02.md` r.57 |
| **14/03 e 28/03/2027** | USA e UE tornano all'ora legale: gli orari estivi tornano giusti | `POSTNEWS_TRE_SEDIE_2026-10-02.md` r.76 |

**Cosa mi serve da te per decidere:** (1) le risposte alle domande della sezione 7 (soprattutto dove sono attaccate le sedie e cosa succede a FTMO dopo il 14/10); (2) dirmi se spezzi la decisione nei tre pezzi (i)-(iii); (3) se vuoi D, il via per scrivere il lettore R274 e passarlo dal cancello; (4) la disponibilita' lunedi' 26/10 per la lettura di 10 secondi, **con il numero di conto in chiaro** (`50503392`, cartella `BCM Markets MT5 Terminal`, non `-V3`, non `C:\BCM_Reale`).

---

## 6. 🚫 NON COPERTO

- **Stato "oggi" = profilo su disco letto alle 03:30 dell'11/10**, non la finestra di MT5. Non so se una sedia e' accesa in questo momento, ne' se `Algo Trading` e' verde.
- **Guardian sulla trial**: le notti 10 e 11/10 non hanno righe ("GUARDIAN: nessuna riga", `NOTTE_2026-10-11.md`): stato **NON MISURATO**.
- **Logica interna** di GapFill, CostToCost, PunteLarry, BreakingBand, Bulge, PTE, SuperWave: ho cercato solo input con "Hour" nel nome. Le chiusure del venerdi' (`InpFridayClose*`) non analizzate (effetto sulla PostNews: NON MISURATO).
- **Dukascopy/Dow, variante B del DAX (feed 2010-2018)**: dipendono dalle firme D-K e dal cancello P1; non guardate qui.
- **Documenti in conflitto da riscrivere** (non toccati): `PROMEMORIA_APERTURE.md` r.109 dice ancora "Server BCM = ora italiana - 1"; il commento nei preset FTMO ("se cambiano nello STESSO giorno il delta resta +2", es. `mql5/Presets/FTMO/ABTG_Dow_Apertura_US_770202_FTMO.set` r.51-52) e' superato: BCM non cambia, `DELTA=2` di `backtest_pipeline/rimappa_preset_ftmo.py` r.8 vale solo per preset BCM "ora italiana -1" (OROL r.298-302).
- **Nome del conto**: `CLAUDE.md` indica `C:\FTMO` come `541452707`, il giornale stampa `1514806751` (`NOTTE_2026-10-11.md`).
- **Confronto con Gemini**: non fatto, la pagina non archivia ne' promuove nessun candidato. Scatta se scegli D (piano di misura nuovo).
- Rischio, taglie e conto reale `10105439`: non toccati e non proposti.

---

## 7. ❓ DOMANDE A CLAUDIO

1. **Dopo il 14/10 c'e' un conto FTMO vivo?** (nuova challenge o nuova trial). Se no, la parte FTMO della decisione (tabella 2b) diventa "preset per il prossimo conto" e il 26/10 non ha un terminale FTMO da leggere.
2. **Quali sedie sono davvero attaccate oggi su `C:\FTMO`?** La sonda mostra 8 sedie piu' Guardian ma non `770101` e non `771531`, che erano tra le sette del 01/10. Sono state tolte, o non sono mai state attaccate? E la trial e' ferma o accesa (`Algo Trading`)?
3. **Le sedie indice di BCM (piccolo, 100k) restano sospese oltre il 25/10?** Se si', per BCM l'orologio conta solo per un eventuale rientro e per i contratti.
4. **ORB argento sul piccolo e MaxMinNotte oro (770402)**: li includi nella decisione d'inverno o li lasci fuori? E **ORB EURAUD sul reale `10105439`**: lo vuoi dentro o fuori? (e' sul reale: non propongo niente)
5. **Che cosa vuoi che rappresentino i numeri di contratto d'inverno**: "quello che la sedia fa" (pre-cash, come il backtest) oppure "quello che la sedia vuole fare" (aprire alla cash)? E' la domanda che decide fra A e B.
6. **Vuoi la misura prima (D)** sapendo che R274 e' scritto ma non girato, che il lettore non esiste e che potrebbe non rientrare entro il 25/10? Oppure il default di fatto (B) per le sedie accese e' accettabile fino a che arriva?
7. **Il 26/10 puoi fare la lettura di 10 secondi** sul `50503392`? Se si', ti mando la riga che stampa PID, titolo e cartella, con il bersaglio in testa.
