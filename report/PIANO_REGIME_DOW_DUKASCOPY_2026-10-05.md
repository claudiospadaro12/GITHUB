# Prova di regime della cella Dow `771531` con lo storico USA30 di Dukascopy: il piano (05/10/2026)

Scelta di Claudio (05/10, dopo `LATI_A1_FINESTRA_DENTRO_L_IS_2026-10-05.md`): **"c, poi b"**. Questa e' la (b): la **vera prova di regime** della cella `ABTG_EMA200` su `U30USD` H1 (sedia `771531`) con tick Dukascopy `USA30IDXUSD` dal 2012.
Autore: sviluppatore (sessione 05/10). Perimetro: **SOLO PIANO, sola lettura del repo** (HEAD `2fdc2086`, branch `lavoro`). **Nessun download, nessuna riga di lancio, nessun terminale, EA, preset, taglia o conto toccato.** Il solo calcolo eseguito e' aritmetica sui numeri dei referti (ricontrollata con python, §3.4) e una lettura del calendario dentro `dukascopy_tick.py` (§3.2).
Etichette: **[MISURATO]** letto da un file del repo · **[DERIVATO]** calcolo su numeri misurati · **[INFERITO]** ragionamento · **[FONTE ESTERNA]** dalla mia memoria di mercato, da ricontrollare · **[NON MISURATO]** buco.
Stato del cancello: **prima passata del secondo strato (`controllo-preventivo`, 05/10): FAIL con correzioni applicate in questo file** (il ritmo di download aveva il denominatore sbagliato, la F2 non conteneva il controllo negativo, piu' difetti minori: elenco in fondo, §8). **Seconda passata indipendente (05/10): FAIL con tre correzioni mirate applicate qui** (lo stesso denominatore sbagliato sui MB di `.bi5`; la F2 rimandava a valori della sonda non agli atti e lasciava ambiguo il ruolo di K0b; il controllo negativo avrebbe riscritto il CSV di marzo 2025: §8-bis). Le correzioni della seconda passata sono di testo e di disco, non toccano criteri ne' ore. **Terza passata indipendente (05/10): FAIL con correzioni mirate applicate qui** (la sonda conta "tutti dentro" sui giorni MISURATI, non sui 9 dichiarati; K0b per giorno, non aggregato; la riga di import oggi non sa leggere ne' una cartella ne' un nome separati: va detto che si aggiungono: §8-ter). Stringono, non allargano. **Quarta passata: FAIL con tre correzioni (§8-quater). Quinta passata (05/10): FAIL con due correzioni mirate di testo (§8-quinquies), riferimenti riga tutti veri. Sesta passata (05/10): PASS con riserve di sola forma, corrette qui (§8-sexies) + riassunto in testa a F2.** Non e' una riga di lancio e non contiene stringhe da incollare; nessuna stringa esce finche' non c'e' un PASS.

---

## 0. In dieci righe, con le due cose che cambiano il quadro

1. **Le "circa 3 ore di download" sono sbagliate, e l'errore e' misurabile.** Vengono da `COME_ALLUNGARE_STORICO_INDICI_2026-09-09.md` ("222 giorni completati in 0,2 h con curl, ~30x piu' veloce") e da `APERTURE_DOW_MAPPA_2026-10-03.md` §4 ("12 anni ~3 ore, [DERIVATO, non misurato su finestra lunga]"). Ma quel **0,2 h e' la corsa del 03/09 ore 22:16 che ha scaricato 0,0 MB**: ha solo riconvertito dalla cache (`REFERTO_DUKA_A_20260903_2216_COMPLETA.txt`: *"MB .bi5 scaricati (questa corsa): 0.0"*). Il download vero e' costato **39,5 h + 1,6 h + 0,3 h = 41,4 h**, ma **non per tutti i 222 giorni**: all'avvio del 01/09 **1.599 ore-file su 5.328 erano gia' in cache** (`referto_py_20260901_2349.txt`: *"scaricate 3505 ore, 1599 cache, 224 errori"*). Le 41,4 h hanno comprato **~3.728 ore-file** (3.505 + 217 + ~6) = **~40 s per ora-file = ~16,0 min per giorno di storico** (§3.4); il 18/08 era 4,1 min/giorno. Quindi il **nucleo** di questo piano (1.306 giorni) vale **90-348 ore di PC acceso**, non 3. Le "3 ore" sono **0,2 h x 3.300/222 = 2,97 h**: la riconversione da cache scalata in proporzione, che per coincidenza cade vicino al pavimento teorico senza throttling (~2,2 h, §3.4). Non sono una stima.
2. **Il cancello zero chiuso di `U30USD_DK` ha una spiegazione che nessuno aveva provato, e costa zero download.** I CSV del 03/09 sono stati convertiti con `--dst usa`: **UTC+0 d'inverno, UTC+1 d'estate**. Ma dal 24/09 sappiamo che BCM sugli indici e' **UTC+1 fisso su tutto l'arco** [MISURATO, `OROLOGIO_BCM_2026-09-24.md` §3.2]. Ricalcolato qui con le funzioni stesse dello script: **108 giorni su 222 (49%) sono etichettati con un'ora di troppo indietro** (107 per intero + 2 a meta': il 03/11/2024 dalle 06:00 UTC e il 09/03/2025 fino alle 07:00 UTC; 108 contando il giorno all'ora di mezzogiorno UTC), e **dei sei giorni della sonda, l'unico inverno e' proprio `2024.11.20` (0,0696%, il solo fallito)**; gli altri cinque sono in ora legale USA, dove le due regole coincidono. 1 su 1 dei giorni sbagliati di orologio e' fallito, 0 su 5 dei giusti: e' [INFERITO], ma e' una predizione che si falsifica in pochi minuti (§2.1, K0).
3. **La finestra non coincide con l'IS di R110**: tutte le finestre di regime proposte finiscono il 2022.10.31 (o prima), l'IS parte il 2024.09.26. L'unica sovrapposizione e' la **calibrazione del feed** (2024.10.14-2025.06.09), dichiarata come tale e non contata come evidenza (§1.4). Questa e' la lezione di LATI-A1, applicata.
4. **I regimi vanno etichettati con i dati del Dow, non con quelli di altri simboli.** Il criterio del 14/08 chiama "LATERALE" il 2019: per il forex poteva valere, per gli indici azionari USA (Dow compreso) il 2019 e' un anno di forte rialzo [FONTE ESTERNA]. Propongo il laterale del Dow nel **2015-16** e fisso la regola di etichettatura sui dati misurati prima di leggere qualunque cella (§1.3).
5. **n >= 150 e' un conto in POSIZIONI, non in deal.** La cella fa **15,5 posizioni/mese in IS e 20,2 in OOS** [DERIVATO da 132/8,5 e 257/12,7]: servono **7,4-9,7 mesi** per 150 posizioni L+S, e **circa il doppio per lato** (~120 long / ~150 short in 12,7 mesi [DERIVATO]). Quindi una finestra singola da 10-12 mesi regge il merito della cella L+S, **non quello del singolo lato**: i lati si leggono su classi di regime (§1.5).
6. **Ordine che non brucia ore**: prima tre passi a costo zero di download (censimento del PC, riconversione dell'orologio dalla cache, calibrazione sulla sovrapposizione); solo se passano parte il download. Se la calibrazione fallisce si risparmiano 90-348 ore (§3.1).
7. **Le due firme** (§5): **F2 = la regola del cancello** (si firma ora, chiede solo un criterio); **F1 = uso dei dati + tetto di risorse** (si firma dopo il primo giro a costo zero, con l'esito in mano).
8. **Il Modello 4 su un simbolo custom con tick** e' previsto dall'importer (`ABTG_ImportaTickEsterno.mq5`) ma **nessun round e' mai girato su `U30USD_DK`** (grep sui file prova: zero come simbolo di un round; il nome compare solo in tre commenti che dicono che e' in frigo): e' il primo [NON MISURATO] da chiudere (§3.3).
9. **Questo risultato non puo' archiviare la sedia**: un verdetto negativo qui cambia contratto, taglia o etichetta (`DIREZIONALE`), mai "MORTO" (certificato di morte del 09/09, §2.6).
10. Bussola: la sedia `771531` e' l'unica del parco che passa i cancelli di oggi alla lettera [`CLAUDE.md`, motto 09/09]. Questa misura decide **a che taglia e in quale regime sta in campo**: ponteggio che serve una sedia vera, non fine a se' stesso.

---

## 1. Cosa si misura e perche'

### 1.1 La domanda

Il contratto di `771531` e' misurato in **un solo regime** (toro 2024-26, con la discesa di aprile 2025): **IS 1,20110 / 237 deal / 132 posizioni / DD 5,7325 %** (2024.09.26-2025.06.09) · **OOS 1,52365 / 517 deal / 257 posizioni / DD 7,8323 %** (2025.06.10-2026.06.30), rischio 1,0 %, deposito 100.000, tick reali [MISURATO, `backtest_pipeline/risultati_prove/ABTG_EMA200/ABTG_EMA200_U30USD_{IS,OOS}_r31.csv` (PF, deal, DD); posizioni 132/257 contate sui per-trade, `EMA200_DOW_COSA_MANCA_PER_IL_1_OTTOBRE_2026-09-17.md` §3.2 e §3; `APERTURE_DOW_MAPPA_2026-10-03.md` §1.4]. L'Emendamento C non e' soddisfatto: **"questo motore regge FUORI dal toro?"** (stessa domanda di `PIANO_LATI_REGIME_2026-09-09.md`, che sul Dow aveva solo l'episodio 2025).

Due domande, separate:
- **RISCHIO** (il vecchio giudica il rischio, Emendamento B): il DD della cella in un orso e in un crollo veri, e la peggior giornata. **Vale a qualunque n.**
- **MERITO** (solo dove n >= 150): la cella tiene (PF >= 0,90) fuori dal toro? E i **due lati** (regola dei due lati sugli indici, 25/08): lo short sale solo nel toro? il long regge nell'orso?

### 1.2 La cella congelata (non si tara niente su un feed esterno)

`ABTG_EMA200`, preset `mql5/Presets/ABTG_EMA200_U30USD_H1_771531_VIVA.set` (44 input) con le **sole** differenze dichiarate rispetto al preset: `InpRiskPercent=1.0` (come R110/R112, per poter confrontare con 7,8323 %; il preset porta 0,65), `InpMagic` e `InpComment` (identita' del banco), il flag di lato (`InpAllowLong/Short`) come asse, simbolo `U30USD_DK`. TF `InpTF=16385` (H1), EMA 200, ATR 14, `InpSLatr=1.0`, `InpTP_RR=2.0`, `TP1Pct=50`, BE e trailing accesi, `InpUsaGuardian` irrilevante nel tester. **Nessun parametro si muove tra finestre.** Per la regola A dell'emendamento della finestra: **nessuna selezione di cella** (una sola cella, congelata), quindi la regola "centro dell'altopiano, mai il picco" non ha niente da scegliere qui; restano le altre due meta' (n >= 150 in operazioni, §1.5; regime dichiarato, §1.3).
Letto nel sorgente (`mql5/Experts/ABTG_EMA200.mq5`): con il preset **non c'e' nessun filtro orario** (`InpUseCutoff=false`, `InpFridayClose=false`, `InpUseNewsFilter=false`, `InpUseAdrFilter=false`, `InpMaxTradesPerDay=0`); i segnali nascono da EMA/ATR su barre H1 e il contatore di giorno (r.298-300) lavora solo con `MaxTradesPerDay>0`. Conseguenza usata al §3.2: **l'etichetta dell'orologio e' inerte per questa cella** [DERIVATO dal codice, verificato in pratica da K2].

### 1.3 Le finestre (dichiarate PRIMA di scaricare un byte)

Giorni da scaricare = giorni di calendario esclusi i sabati (come `dukascopy_tick.py`, `giorni()`), **con ~5 settimane di warm-up** prima di ogni finestra (EMA200 su H1 = 200 barre = ~8,7 giorni di borsa, piu' margine) [DERIVATO].

| sigla | finestra di prova | etichetta ATTESA [FONTE ESTERNA, da misurare] | giorni da scaricare (con warm-up) | pos. L+S attese | ruolo |
|---|---|---|---:|---:|---|
| **W1 ORSO** | 2022.01.01-2022.10.31 | orso/inflazione | (dentro CORE-A) | 155-202 | rischio + merito L+S (al bordo dei 150) |
| **W2 CROLLO_ANNO** | 2020.01.01-2020.12.31 (sotto-finestra rischio CROLLO 2020.02.01-04.30, come R50/R56) | crollo Covid + rimbalzo | (dentro CORE-A) | 186-242 | rischio (la sotto-finestra) + merito (l'anno) |
| **W3 TORO** | 2021.01.01-2021.12.31 | rialzo | (dentro CORE-A) | 186-242 | riferimento toro **sullo stesso feed** |
| **CORE-A** | scarico contiguo 2019.12.01-2022.10.31 | | **914** | | W1+W2+W3 |
| **W4 LATERALE (Dow)** | 2015.05.01-2016.06.30 | laterale con due scosse (agosto 2015, gennaio-febbraio 2016), netto ~piatto | **392** (da 2015.04.01) | 217-283 | rischio + merito, il laterale vero del Dow |
| *extra W5* | 2018.01.01-2018.12.31 | Volmageddon + Q4 | 339 (da 2017.12.01) | 186-242 | solo se il nucleo regge o per capire |
| *extra W6* | 2012.04.04-2013.12.31 | toro lento post-crisi euro | 546 | 324-422 (20,9 mesi; il warm-up dell'EMA cade **dentro** la finestra, perche' 2012.04.04 e' il primo giorno Dukascopy) | profondita' massima Dukascopy |
| *extra W7* | 2025.06.17-2026.06.30 | toro del contratto, **sullo stesso feed** | 325 | 192-251 (12,4 mesi) | chiude "toro 2024-26 su DK" (la prima meta' e' gia' su disco) |
| **NUCLEO = CORE-A + W4** | | | **1.306** | | **la proposta di questo piano** |

Le posizioni attese = mesi x 15,5-20,2 [DERIVATO]; **la frequenza dipende dal regime** (`PIANO_LATI` §4: la proiezione da una finestra sottostima l'altra del 45 %), quindi le fasce sono indicative e W1 puo' scendere sotto 150.

🔴 **Regola di etichettatura, scritta ora** (parte di F1, nessun numero di cella visto): prima di lanciare qualunque cella si calcolano sulle **chiusure H1 del feed DK** il rendimento buy&hold della finestra e il suo massimo drawdown. Etichetta: **TORO** se rendimento >= +10 % e DD < 15 %; **ORSO** se rendimento <= -5 % e DD >= 15 %; **CROLLO** se DD >= 25 % in <= 3 mesi; **LATERALE** se |rendimento| <= 5 %. **Se non scatta nessuna regola, o ne scattano due** (le quattro non sono ne' esclusive ne' esaustive: es. +7 % con DD 10 % non e' niente), l'etichetta e' **MISTO** e la finestra **non entra nella classe AVVERSE** senza una nuova firma. Se l'etichetta misurata differisce da quella attesa, la finestra **si rinomina, non si scarta** e il verdetto si legge con il nome misurato. (Le soglie sono mie: vanno firmate. Le date delle finestre W1-W3 sono quelle gia' congelate il 14/08 e 'CROLLO_ANNO' dell'emendamento R56, `PROVA_REGIME_CRITERI.md` §3 e E.6; **W4 sostituisce il LATERALE 2019 del 14/08 e questo e' un cambio di criterio fatto prima dei numeri**: nessun numero Dow esiste su W4.)

### 1.4 Verifica che la finestra non coincida con l'IS di R110 (fatta ora, meccanica)

| intervallo | date | ruolo |
|---|---|---|
| **IS R110** | 2024.09.26-2025.06.09 | contratto IS |
| **OOS R110** | 2025.06.10-2026.06.30 | contratto OOS |
| LATI-A1 (caduto, classe 1102) | 2025.02.01-2025.04.30 | **dentro l'IS**: nessuna informazione nuova sul DD |
| DK su disco (03/09) | 2024.10.01-2025.06.16 | dentro IS + 1 settimana di OOS |
| **W1, W2, W3, W4, W5, W6** | tutte <= 2022.10.31 | **nessuna sovrapposizione**: scarto ~23 mesi (22 mesi e 26 giorni) dall'inizio dell'IS |
| W7 (opzionale) | 2025.06.17-2026.06.30 | dentro l'OOS: **solo** riferimento di feed, non regime |
| **finestra di calibrazione K1/K2** | 2024.10.14-2025.06.09 | **dentro l'IS, per costruzione**: serve a misurare il FEED, **mai** entra come evidenza di regime; in ogni tabella porta l'etichetta "dentro l'IS: riferimento di feed" |

L'avvio a 2024.10.14 (non 10.01) e' perche' il DK parte il 2024.10.01 e l'EMA200 H1 ha bisogno di ~200 barre per maturare (~2024.10.10): si confrontano solo trade con indicatori maturi in entrambi i feed [DERIVATO].

### 1.5 n >= 150: unita', frequenza, lati

- **Unita' = POSIZIONI** (Emendamento A: l'operazione). La colonna `Trades` del CSV conta i **deal** (TP1Pct 50 chiude meta' e il resto dopo: 517 deal = 257 posizioni) [`prove/LATI_A2_*` nota (2)]. Rapporto posizioni/deal: 0,557 (IS), 0,497 (OOS) [DERIVATO].
- **Posizioni per lato** [DERIVATO moltiplicando i deal per lato di R110 per il rapporto]: OOS ~120 long / ~150 short; IS ~62 long / ~70 short. Per avere 150 per lato servono ~13-16 mesi al ritmo OOS (short 12,7 · long 15,9), ~18-20 al ritmo IS (short 18,1 · long 20,4) [DERIVATO].
- **Regola di lettura, dichiarata ora**: (i) **rischio**: ogni finestra, qualunque n; (ii) **merito L+S**: per finestra, solo se posizioni >= 150, altrimenti la riga porta **"MERITO: NON ANCORA MISURATO"**; (iii) **merito per lato**: solo sulla classe **AVVERSE = W1+W2 (+W5 se scaricata)** e solo se la **stessa direzione** compare in entrambe le finestre (criterio 14/08: "un solo periodo avverso e' un aneddoto"); accanto si stampa il PF di ogni lato in ogni finestra.
- I numeri L+S/lato in quattro passate per finestra: due file gemelli da due celle ciascuno, con la cella L+S **ripetuta in entrambi** come cancello di determinismo gratuito (metodo di `PIANO_LATI` §6): **4 passate per finestra**.

### 1.6 Perche' proprio questa misura (e non le altre della coda)

Perche' e' l'**unica che compra regime e n insieme** (`APERTURE_DOW_MAPPA` §4, ultima riga) e perche' e' sulla sedia che passa i cancelli di oggi. Costo vero nel tempo: **ore di PC acceso, non di tester** (§3.4): il tester vale ~30-60 minuti in tutto.

---

## 2. Attese, criteri e contro-esempi (scritti PRIMA dei numeri; nessuna soglia abbassata)

**Nessun criterio di casa e' ammorbidito.** Quelli ereditati sono marcati **[CASA]** con la fonte; quelli nuovi sono marcati **[NUOVO, da firmare in F1/F2]** e valgono perche' scritti prima di ogni numero Dow esterno.

### 2.1 Il feed prima della cella

**K0 - cancello zero del feed (con l'orologio corretto)** [NUOVO per l'orologio; metro **[CASA]** 31/08: mediana |diff bid| al minuto <= 0,05 %, copertura >= 80 %, `DUKASCOPY_PASSO0.md` §4a]
- Si riconvertono **dalla cache** le 222 giornate con orologio **UTC+1 fisso** (nuova opzione `--dst fisso`, §3.2) e si rifa' la sonda su **9 giorni**: i 6 del 03/09 + **3 invernali nuovi, scelti ora**: `2024.12.10`, `2025.01.14`, `2025.02.11` (tutti dentro il periodo in cui l'ora 'usa' sbaglia, giorni feriali ordinari).
- **Predizione P1**: `2024.11.20` scende da 0,0696 % a **<= 0,05 %**; i 3 invernali nuovi **<= 0,05 %**; i 5 giorni in ora legale USA restano **identici** a prima (stessa regola su quei giorni: se cambiano, la riconversione ha un bug). Il confronto si fa **sulle righe dei CSV** (copia di sicurezza dei CSV del 03/09 presa **prima** di riconvertire, perche' la riconversione riscrive gli stessi file mensili in `tick\`), non sui valori della sonda: i valori per giorno della sonda del 03/09 **non sono agli atti** (il referto stampa solo "5/6 dentro, peggiore 0,0696 %") e i tick nativi di BCM potrebbero non essere piu' gli stessi.
- **Falsificatore**: `2024.11.20` resta > 0,05 % con l'orologio giusto => **ipotesi dell'orologio falsa**, cancello chiuso, `U30USD_DK` resta in frigo, **non si lancia niente**; si apre la strada "tick nativi di quel giorno" del registro (`REGISTRO_TEST.md`) [INFERITO: quella pista e' piu' debole, perche' il referto stampa un numero (0,0696 %) e non "NON confrontabile", il che dice che i tick nativi c'erano].
- **Denominatore della sonda (terza passata del cancello; precisato nella quarta)**: "tutti dentro" vuol dire **ciascuno dei 9 giorni, per NOME, con la sua riga misurata e OK** (classe 180: si elenca, non si conta). `ABTG_ImportaTickEsterno.mq5` (r.498 e r.523) **salta in silenzio** un giorno non confrontabile (`if(!valido) continue;`): non solo senza tick nativi, anche **senza tick DK** (r.317, `gn <= 0 || gd <= 0`) o con **meno di 30 minuti in comune** (r.357); e salta in silenzio anche una **data malformata** (r.493, `if(g <= 0) continue;`). Contro-esempio della quarta passata: una lista di 10 voci con un giorno **ripetuto** e `2024.11.20` non confrontabile stampa **"9/9" e `OK: CANCELLO PASSATO`** senza il giorno che falsifica l'ipotesi; e la riga di import oggi decide l'uscita 0 **solo dal testo del verdetto** (`RIGA_DUKA_IMPORT_SONDA.ps1` r.368, `*OK: CANCELLO*` -> `$Codice = 0`), quindi il suo "verde" non e' la condizione (1) della F2. Il resto della regola resta com'era: l'importer stampa `OK: CANCELLO PASSATO` se `giorniOk == giorniMisurati`: con `2024.11.20` non confrontabile (i tick nativi del terminale potrebbero non esserci piu', vedi sopra) uscirebbe "8/8 OK" **senza aver misurato proprio il giorno che falsifica l'ipotesi**. Un giorno "NON confrontabile" **non e' dentro**: si recupera la storia nativa e si rimisura, oppure il cancello resta chiuso.
- **K0b (obbligatorio se il controllo negativo di §2.5 e' debole: sotto il doppio del valore giusto, oppure con mediana <= 0,05 %, oppure "NON confrontabile"; F2 (3))**: lag di massima correlazione dei rendimenti a 1 minuto fra DK e nativo, **calcolato su CIASCUNO dei 9 giorni separatamente** (non sull'aggregato: 5 giorni estivi a lag 0 e 4 invernali a lag 60 darebbero un picco aggregato a 0): il picco deve stare a **lag 0 (+-1 min) in tutti e 9**; un errore d'orologio di 1 ora sposta il picco a +-60. Serve l'export M1 nativo dei 9 giorni (uno script nuovo, da far passare dal cancello).

**K1 - calibrazione cross-feed sulla sovrapposizione** [NUOVO]
- Stessa cella, stesso file prova, finestra 2024.10.14-2025.06.09: una passata L+S (e le gemelle per lato) su **`U30USD` nativo** e su **`U30USD_DK`**, Modello 4 in entrambi.
- Passa se: **(a)** posizioni DK / posizioni nativo in **[0,85 ; 1,15]**; **(b)** corrispondenza trade-per-trade >= **70 %** (stesso lato, ingresso entro +-1 barra H1); **(c)** la corrispondenza di **controllo nullo** (stessi trade DK spostati di **+1 giorno di calendario**) <= **meta'** di (b); **(d)** PF DK dello stesso segno del nativo (>= 1,0 se il nativo e' >= 1,0). Le soglie sono mie [NUOVO]: la banda di n tiene conto che i filtri d'ingresso (distanza dall'EMA 0,3-1,5 ATR = ~30-150 punti = ~0,07-0,35 % del prezzo) hanno la **stessa grandezza della differenza fra i feed** (mediana al minuto dell'ordine di 0,05-0,07 %, §0 punto 2): i casi al bordo possono cambiare lato di appartenenza. **Limite dichiarato**: con la tolleranza di +-1 barra H1, K1 **non vede un errore d'orologio di 1 ora** (un trade spostato di un'ora combacia lo stesso): l'orologio lo giudicano K0/K0b, non K1.
- **Perche' il controllo (c)**: la cella e' **vicina a un tetto strutturale** (~0,9 posizioni/giorno, un armamento alla volta, max 2 gambe) e `n` combacerebbe fra due feed *qualunque*: una banda su `n` da sola non misura niente (classe 178). (c) e' il numero che produce l'**altra spiegazione**.
- **Se K1 fallisce: STOP**, nessun download, e **nessun numero DK si legge come regime** (R80 ha gia' mostrato quattro cambi di segno fra feed a parita' di cella, `LO_STORICO_ESTERNO_MAPPA` §5.1).

**K2 - inerzia dell'orologio** [NUOVO]: stessa finestra di K1, DK convertito con **due convenzioni** (UTC+1 fisso / calendario USA): attesa **posizioni e PF identici** (e identici i trade). Se differiscono, l'orologio **non e' inerte** per la cella e la scelta UTC+1 fisso va giustificata in F1 con il numero accanto. (Alternative che farebbero fallire K2: un effetto sulla griglia delle barre del giorno o delle domeniche, oppure la **tabella delle sessioni di trading** del simbolo clonato da `U30USD`, che e' in ora server: tick etichettati un'ora fuori possono cadere in una finestra non negoziabile e far rifiutare un ordine nel tester.)

**K3 - sanita' del feed, per anno scaricato** [NUOVO; modello: diagnosi DAX di `DIAGNOSI_DAX_*` — il `grxeur` di HistData conteneva un altro indice per 42 mesi, e ce ne siamo accorti solo con quella diagnosi]: per **ogni** anno del nucleo, prima di importare: (1) tick/giorno > 0 su >= 95 % dei giorni feriali; (2) minimo-massimo H1 dentro la banda 8.000-70.000 dello script **e** chiusura dell'ultimo H1 del 31/12 entro **+-1,5 %** del livello noto del Dow a fine anno [FONTE ESTERNA: 2015 ~17.425 · 2019 ~28.538 · 2020 ~30.606 · 2021 ~36.338; da ricontrollare su una fonte pubblica prima di usarli]. **Il 2016 e il 2022 non hanno il 31/12 dentro il nucleo** (W4 finisce il 2016.06.30, CORE-A il 2022.10.31): per quei due anni il confronto si fa sull'**ultima chiusura scaricata**, 30/06/2016 ~17.930 e 31/10/2022 ~32.733 [FONTE ESTERNA, stessa riserva]; (3) la finestra oraria modale di mercato uguale a quella del 2024-25 (+-1 ora); (4) nessun gap > 3 giorni feriali consecutivi senza tick. Un anno che non passa non entra in nessuna tabella.

### 2.2 Rischio (valgono a qualunque n)

- **R1 [CASA, `PROVA_REGIME_CRITERI.md` §A]**: in ORSO e CROLLO il DD (equity, 1 %, deposito 100.000) **<= 2 x il DD OOS = 15,66 %** e **comunque < 20 %**.
- **R2 [NUOVO]**: **peggior giornata realizzata** (per data di chiusura, giorno UTC+1, **non** il reset FTMO; il flottante resta fuori e il verso dell'errore e' permissivo, fino a ~1 % di rischio aperto: correzione 3 del cancello su LATI) **<= 4,9 %** a rischio 1 % = **2 x il -2,45 %** misurato in R112 [`EMA200_DOW_COSA_MANCA` §1]. Forma "il doppio del misurato" = quella di R1.
- **R3 [NUOVO, specifico prop]**: il DD a 1 % **<= 14,5 %**: derivato da muro 10 % x 1,538 (rapporto fra 1,0 % e 0,65 % in uso in casa) diviso 1,06 per il margine del 6 % con cui quel metro lineare **sbaglia** (riconciliazione R29-R112, `EMA200_DOW_COSA_MANCA` #9). **R3 e' piu' stretto di R1 e quindi e' quello che morde.** Il DD a 0,65 % **non e' misurato** (resta [NON MISURATO], un minuto di tester a parte). **Nota di contesto, non un criterio**: sulla Free Trial FTMO `1514806751` la `771531` e' stata accesa a **2,00 % per operazione** (`HANDOFF.md`, blocco 01/10; `AUDIT_RISCHIO_FLOTTA_2026-10-01.md` r.71). R3 e' tarato su 0,65 %; allo stesso metro, a 2,00 % il muro del 10 % corrisponde a un DD a 1 % di circa **4,7 %** (10 / 2 / 1,06) [DERIVATO, metro lineare], che il contratto OOS (7,83 %) supera gia'. La taglia resta di Claudio: questa misura la informa, non la cambia.
- Il DD si legge **anche nei sotto-periodi peggiori** (CROLLO 2020.02-04), ma il verdetto e' per finestra.

### 2.3 Merito (solo dove n posizioni >= 150)

- **M1 [CASA]**: **PF >= 0,90** nelle finestre avverse (ORSO, CROLLO_ANNO) e **PF >= 0,90** nel LATERALE (W4) [estensione naturale; **[NUOVO]**].
- **M2 [CASA, `PIANO_LATI` §6]**: il motore **regge fuori dal toro** se **PF(LONG, ORSO) >= 0,90 E PF(SHORT, TORO) >= 0,90**; se uno dei due e' **< 0,70** il motore e' **DIREZIONALE**, "non e' una bocciatura: e' un'etichetta che cambia il contratto della sedia". Giudizio sulla **coppia** di finestre (qui: classe AVVERSE per il LONG; W3 per lo SHORT), mai su una.
- Con n < 150 la parola nel referto e' **"MERITO: NON ANCORA MISURATO"**, in chiaro (correzione 4 del cancello su LATI).

### 2.4 Attese numeriche (scritte prima; [INFERITO] dalle misure di casa; fasce larghe e oneste)

Dalle misure: contratto IS 1,20 / OOS 1,52, **short migliore del long nel toro** (OOS: long 1,241, short 1,891 [`PIANO_LATI` §2: anomalia dichiarata]) e IS (contiene la discesa 2025) 1,162 long / 1,232 short; frequenza ~0,9 posizioni/giorno.

| finestra | PF L+S atteso | DD atteso (1 %) | lettura se **fuori** fascia |
|---|---|---|---|
| W3 TORO 2021 | 1,10-1,60 | <= 9 % | sotto 1,00 nel toro: la cella 2025-26 era un caso, il contratto e' sovrastimato |
| W1 ORSO 2022 | 0,90-1,35 | <= 12 % | PF >= 1,5 in orso **e** crollo: sospetto di feed benigno (nessuna slippage/gap nel tester), si legge con riserva |
| W2 CROLLO_ANNO 2020 | 0,80-1,40 | <= 14,5 % (R3) | DD sopra R3 = taglia 0,65 % non sicura **in quel regime**: decisione di taglia (di Claudio) |
| W4 LATERALE 2015-16 | 0,85-1,15 | <= 10 % | sotto 0,85: il motore perde nei laterali, etichetta da dichiarare |

### 2.5 I contro-esempi che ho costruito (la banda contro l'altra ipotesi, non contro il nulla)

| misura | l'altra spiegazione | che numero produce l'altra spiegazione | la banda la separa? |
|---|---|---|---|
| K0 orologio | il feed DK e' semplicemente diverso d'inverno (0,07 % e' il suo vero livello) | `2024.11.20` resta **~0,0696 %** (+-0,005) e i 3 invernali nuovi **0,05-0,08 %** | si: ipotesi orologio => tutti **<= 0,05 %**; ipotesi feed => **> 0,06 %**; la zona **0,05-0,06 %** non e' ambigua per la decisione: e' "> 0,05", quindi cancello chiuso (si decide dal lato prudente) |
| K0 sensibilita' | la sonda non vede un errore d'orologio di 1 ora (la banda 0,05 % e' troppo larga) | **controllo negativo**: riconvertire apposta `2025.03.12` (passato) con UTC+0 **sbagliato**: se esce **< 2 x** il valore giusto **oppure <= 0,05 %** (un errore d'un'ora classificato "dentro"), la sonda **non discrimina** e K0b diventa obbligatorio. 🔴 **Il giorno sbagliato va importato in un simbolo custom SEPARATO** (es. `U30USD_DKNEG`), mai in `U30USD_DK`: il 2025.03.12 sta **dentro** la finestra di calibrazione K1 e un import sbagliato rimasto li' la contaminerebbe. 🔴 **E va convertito in una cartella di uscita SEPARATA** (`--cartella` diversa, con la sola giornata della cache copiata dentro; riscaricarla, 24 ore-file, sarebbe un download e F2 non ne autorizza: se la cache non c'e', vale lo stop di P0): `dukascopy_tick.py` scrive `U30USD_DK_ticks_2025-03.csv` e lo **riscrive per intero** (`ScrittoreMensile._flush`), quindi una conversione di un giorno nella cartella `tick\` di sempre sostituirebbe il marzo 2025 con quel solo giorno sbagliato. 🔴 **Cosa esiste oggi e cosa va AGGIUNTO (terza passata, letto nel codice)**: ESISTONO `--cartella` (cache `raw\` e uscita `tick\` stanno entrambe sotto di lei, per questo la giornata della cache va copiata dentro), `--fuso utc` (UTC+0 esatto; anche `--dst europa` da' UTC+0 il 12/03/2025) e `-SimboloDK` della riga di import. **NON ESISTONO**: un nome di uscita diverso (il .py scrive sempre `bcm + "_DK"`, r.915, quindi il file negativo si chiama **ancora** `U30USD_DK_ticks_2025-03.csv`); una cartella sorgente scelta dalla riga di import (`RIGA_DUKA_IMPORT_SONDA.ps1` r.69 `$TickSrc` cablato su `dukascopy_lavoro\tick`, r.206 e r.225 maschera `U30USD_DK_ticks_*.csv` cablata, r.210 copia in `MQL5\Files` con lo **stesso nome**, che **sovrascrive il marzo buono** anche li'); una lista di giorni sonda (r.77, cablati i 6 del 03/09). Quindi P1 **deve aggiungere** cartella sorgente, nome/maschera distinti (es. `U30USD_DKNEG_ticks_*.csv`) e giorni sonda come parametri della riga, e ripulire `MQL5\Files` dopo il negativo: codice nuovo, cancello. Nessuna di queste modifiche e' gia' fatta (grep `DKNEG` su `.ps1/.py/.mq5`: zero) | misura la sensibilita' del **metro**, non sceglie fra le due ipotesi (quello lo fa la riga sopra). Il numero gia' in mano dice che il bordo e' vicino: un'ora di scarto ha prodotto **0,0696 %** contro una soglia di 0,05: se i giorni buoni stanno a 0,035-0,05, il rapporto esce **1,4-2,0** e **K0b diventa obbligatorio** (script nuovo, cancello, costo [NON MISURATO]): va messo in conto, non sperato |
| K1 | `n` combacia perche' la cella e' vicina a un tetto strutturale (~0,9/giorno), non perche' i segnali coincidono | `n` ratio ~1,00 anche per feed scorrelati; trade-match con spostamento di +1 giorno **alto** | si: richiedo (b) >= 70 % **e** (c) <= meta' di (b) |
| K2 | l'orologio conta (griglia di barre, domeniche) | `n` o PF diversi fra le due conversioni | si, per costruzione: attesa **identici** |
| M2 / lati | la cella e' un trend-follower del toro (**DIREZIONALE**) | PF(SHORT, TORO 2021) < 0,70 **e** PF(LONG, AVVERSE) < 0,70 | si: ma l'anomalia del contratto (short 1,89 nel toro 2025-26) dice che la direzionalita' pura e' gia' poco probabile |
| etichette | "il 2019 e' laterale" (etichetta presa da altri simboli) | buy&hold Dow 2019 fortemente positivo [FONTE ESTERNA] | si: regola di etichettatura sui dati DK prima delle celle |
| costo/feed benigno | nel crollo 2020 il tick DK senza slippage sottostima DD e peggior giornata | R31: DD 6,48 % OHLC / 7,21 % / 7,83 % a tick: **l'OHLC sottostima il DD fino a ~20 %** | **non separabile** dal tester: R1-R3 si leggono come **limite inferiore** del DD; lo dichiaro nel referto accanto al numero |

### 2.6 Che cosa questa misura puo' e non puo' fare

- **Puo'**: dire a quale taglia e in quale regime la sedia sta in campo; mettere l'etichetta `DIREZIONALE` al contratto; aprire (o no) il frigo di `U30USD_DK` per altri motori Dow.
- **Non puo'**: tarare un parametro (regola d'uso congelata: parametri congelati, mai ottimizzazione su un feed esterno); **archiviare** una cella (certificato di morte del 09/09: servono PF, n, DD, uscita ad asse, simboli gemelli, TF cambiato; qui ne manca piu' di uno: l'esito negativo si scrive **"NON ANCORA MISURATO"**, con cosa manca); promuovere o toccare preset, taglie, conto reale `10105439` o la challenge FTMO.
- **Gemelli** (NASUSD, D30EUR, SPXUSD) e **TF diversi** con lo stesso motore restano fuori da questo piano e [NON MISURATI] (`EMA200_DOW_COSA_MANCA` #8: sui quattro indici azionari il motore fa 6 celle positive su 330).

---

## 3. La catena tecnica

### 3.0 Dove gira, e che cosa NON viene toccato

- 🖥️ **Download e conversione**: **finestra PowerShell sul PC di backtest `DESKTOP-H4D7CAJ`**, solo HTTP, **nessun MT5 aperto da questa riga**. **MAI il VPS `VMI3047753`**: dal 21/09 i round e i download pesanti non girano la' finche' una challenge FTMO e' viva (firma di Claudio, "i round sul pc di backtest"). *Nota di difetto*: l'intestazione di `backtest_pipeline/sonda_dukascopy.ps1` dice "PC di backtest o VPS, indifferente": **dopo il 21/09 non e' piu' vero**, e va corretta prima di riusarla.
- 🪟 **Import e tester**: terminale MT5 `C:\Program Files\BCM Markets MT5 Terminal` sul **PC di backtest `DESKTOP-H4D7CAJ`**, loggato sul demo **`50503392`** [MISURATO, `I_ROUND_SUL_PC_DI_BACKTEST_2026-09-21.md`; stato odierno [NON MISURATO], ultima misura 10/09]. 🔴 **Attenzione al numero di conto**: `50503392` e' **lo stesso conto del piccolo del VPS**, che ha una cartella omonima: due macchine, **stesso percorso, stesso conto**. Il 14/08 da quel PC sono partiti ordini veri (#3160534/#3160535): **prima di ogni passo con MT5 si censisce che nessuna sedia sia attaccata ai grafici** (passo 0).
- **Non toccati, per nome**: VPS `VMI3047753` e **tutti** i suoi terminali (`50503392` piccolo, `50504263` 100k, `10105439` reale `C:\BCM_Reale`, `50504400` `C:\MT5_Backtest` spento, `C:\FTMO` 541452707 / 1514806751, Pepperstone, Tickmill); nessun preset, nessun EA in campo, nessuna taglia.
- ✋ Le azioni a mano dentro MT5 (se servono, es. aprire un grafico) arriveranno con la stringa che stampa PID + titolo + cartella (`Get-Process terminal64 | select Id, MainWindowTitle, Path`), mai riconoscimento "a occhio".

### 3.1 I passi, con il loro cancello e il loro stop

| # | passo | bersaglio | download | costo | stop / cancello |
|---|---|---|:-:|---|---|
| **P0** | **Censimento di sola lettura**: spazio libero sul disco di destinazione (**[NON MISURATO]**), presenza e dimensione di `C:\Users\Master\dukascopy_lavoro\raw` e `\tick` (la cache del 03/09), esistenza di `U30USD_DK` in `bases\Custom`, sedie attaccate, `MaxBars`, python, `curl.exe` | PowerShell sul PC di backtest | no | minuti | se la cache `raw` non c'e' piu', P1 diventa un riscarico di 222 giorni (~15-59 ore): si ridiscute |
| **P1** | **Orologio**: aggiungere a `dukascopy_tick.py` l'opzione `--dst fisso` (UTC+1 fisso) con autotest (confini al minuto, **stesso output** sui giorni in ora legale USA), **copia di sicurezza dei CSV del 03/09 prima di riconvertire** (servono al confronto della F2, punto 2), `--solo-cache` per riconvertire i 222 giorni, import + sonda su 9 giorni, controllo negativo in simbolo **e** cartella separati (la riga di import oggi **non** sa leggerli: cartella sorgente, maschera e giorni sonda sono cablati, §2.5: vanno aggiunti come parametri), la riga deve controllare la condizione (1) della F2 **per nome sui 9 giorni** e non solo il verdetto (oggi r.368 da' uscita 0 su `*OK: CANCELLO*`), e **in repo le righe per giorno della sonda, ciascuna col nome del simbolo** (r.503 dell'importer non lo stampa; oggi stanno solo nel log `MQL5\Logs` dentro lo zip: il 03/09 sono andate perse cosi', e la condizione (3) della F2 ha bisogno del valore del 2025.03.12) | codice: sessione; esecuzione: PC di backtest, MT5 `50503392` | **no** | ~10-20 min | K0 (+K0b se serve). **Esito -> F2/F1** |
| **P2** | **Calibrazione K1 + K2**: 8 passate (4 nativo + 4 DK) + 2 passate di K2, Modello 4 | tester, PC di backtest, `50503392` | no | ~10-25 min [DERIVATO, §3.4] | K1/K2: **se falliscono, STOP** |
| **P3** | **Canarino di ritmo** (5-10 giorni profondi, es. 2020-03-09..13, 2022-03-07..11; 3 pause: 250/1000/2000 ms) e **una richiesta** per verificare se esistono le **candele** di Dukascopy (§3.3, via B) | PowerShell sul PC di backtest | poco | 1-2 h | decide quale via e quale nucleo: se il ritmo proietta il nucleo oltre il tetto firmato si riduce il nucleo (W1 da sola = 20-77 h) |
| **P4** | **Download del NUCLEO** (CORE-A poi W4), tranche con **confini sui mesi** (la seconda tranche riscrive il mese della prima: checklist 31/08), cache con ripresa, progresso in **ore di PC acceso**, stop se la proiezione supera il tetto firmato | PowerShell sul PC di backtest | **si** | 90-348 h [DERIVATO] | tetti di F1 |
| **P5** | **Conversione + K3 + etichette** (buy&hold DK per finestra), poi import a blocchi | PC di backtest | no | ore, poche | K3 per anno; l'anno che non passa non entra |
| **P6** | **Round W1-W4**, 4 passate ciascuno (L+S ripetuta come determinismo), file prova scritti nuovi, `controlla_prova.py` + `controlla_riga.py` + `controllo-preventivo` | tester, PC di backtest | no | 16 passate = 16-32 min [DERIVATO] | cancelli di casa |
| **P7** | **Lettura** con K/R/M, referto, regime dichiarato, registro, **push** | sessione | no | | "NON ANCORA MISURATO" dove n < 150 |

Ordine **F2 -> P0-P1 -> (esito) -> F1 -> P2-P7**: i primi tre passi non scaricano un byte.

### 3.2 L'orologio: UTC -> ora BCM, e il problema dei vecchi anni

- **Oggi** BCM sugli indici e' **UTC+1 fisso su tutto l'arco 2024.09.26+** (niente ora legale) [MISURATO, `OROLOGIO_BCM_2026-09-24.md` §0 punto 3 e §3.2]. Cioe' d'estate = ora italiana - 1, d'inverno = ora italiana.
- **Prima del 2024.09.26 BCM non ha indici**: "l'orologio prima di li' NON e' misurato" (`controlla_riga.py` r.1519-1521). Sul **forex** il vecchio orologio era "ora italiana - 1 tutto l'anno" (UTC+0 d'inverno, calendario europeo) fino al cambio fra 26/12/2024 e 02/02/2025 [MISURATO, §0 punto 1-2]: **dichiaro che quel vecchio orologio non si applica agli indici e non lo uso**.
- **Scelta di convenzione, dichiarata**: **tutto il DK 2012-2024 si converte con UTC+1 fisso**, cioe' con l'orologio che la sedia vivra' davvero in campo; **non** si ricostruisce un orologio "BCM d'epoca" che non esiste [INFERITO: e' la scelta che non inventa un fatto].
- **Perche' per `771531` non cambia i segnali**: nessun filtro orario (§1.2), barre H1 con scarto di ore intere => stessa griglia, stesse chiusure [DERIVATO]; **lo verifica K2**. **Non vale per i motori d'apertura**: se un giorno si usera' `U30USD_DK` per la 770202 o per il candidato breakout, l'etichetta d'inverno conta (08:30 NY contro 09:30) e serve il suo round di orologio.
- **Il difetto da riparare in `dukascopy_tick.py`**: ha solo `--dst usa` / `europa`; per `usa`, `offset_server()` da' UTC+0 da 2024.11.03 06:00 UTC al 2025.03.09 07:00 UTC. [MISURATO eseguendo le funzioni dello script sui sei giorni della sonda e sui 222 iterati: **108 giorni su 222 hanno offset 0 dove BCM ha +1**; dei sei giorni della sonda solo `2024.11.20`.] Serve **`--dst fisso`** (offset +1h sempre), con autotest e rilettura dello strato 2. Il default **non** va cambiato in silenzio (i CSV del 03/09 sono stati prodotti col vecchio): la nuova opzione e' opt-in e il referto dichiara quale calendario ha usato.
- Il discriminante DST del `PASSO0` (§3c) "se solo le settimane sfasate falliscono -> riconverti europa" **non considerava l'UTC+1 fisso**: e' per questo che il 03/09 si e' letto "QUASI: leggere QUALI giorni falliscono (DST?)" e la risposta non e' arrivata.

### 3.3 L'importazione: tick custom (via A) e candele (via B, da verificare)

**Via A - tick, Modello 4 (proposta di base).** `dukascopy_tick.py` (v2, motore `curl`, autotest 10/10, **gia' usato per davvero** il 03/09: 20.716.582 tick, ordine campi `p1_ask` con divisore 1000, spread mediano del feed **2,53**, p90 **5,47** su campione 1/100 [MISURATO, `referto_py_20260903_1522.txt`]; coerenza `p1_ask` 100 % su 108.108 tick [MISURATO 31/08 sul canarino, `righe/RIGA_DUKA_A_DA_MANDARE.md` r.40] contro 2,00-3,00 di BCM [MISURATO, `APERTURE_DOW_MAPPA` §2.1]) -> CSV mensili `Time,Msec,Bid,Ask` gia' in ora server -> `ABTG_ImportaTickEsterno.mq5` (compilato e girato il 03/09 22:43: **20.753.611 tick scritti, 0 scartati, 0 fuori ordine**, `IMP-TICK-v0-BOZZA`; `CustomTicksReplace` a blocchi, idempotente per intervallo) -> simbolo `U30USD_DK` clonato da `U30USD`. Il tester gira con **Modello 4** (tick reali). **[NON MISURATO]**: che il tester onori davvero i tick custom su `U30USD_DK` per il Modello 4: nessun round e' mai girato su quel simbolo; P2 e' il primo e lo verifica (se il referto del tester non dice "real ticks" il banco e' un altro e K1 va riletto).
- Il driver di riferimento per un regime su simbolo custom e' `righe/RIGA_R113_REGIME_NASUSD.ps1` (controlla l'esistenza del custom prima di aprire MT5, gemelli, delta ammessi); la sua versione M1 controlla `bases\Custom\history\`: per un custom con tick il percorso da controllare e' `bases\Custom\ticks\U30USD_DK` [INFERITO, da verificare in P0].
- Tetto barre: un anno di H1 = ~6.000 barre contro il tetto di 100.000 [DERIVATO]: non morde nel nucleo.

**Via B - candele (da verificare con UNA richiesta in P3; non assunta).** Dalla mia memoria del tool `dukascopy-node` [NON VERIFICATO da noi; dal cloud `datafeed.dukascopy.com` risponde 403, `DUKASCOPY_PASSO0` §2a], il feed pubblica anche **candele pre-aggregate**: M1 con **un file al giorno** (`BID_candles_min_1.bi5`, anche `ASK_`), H1 con **un file al mese**. Se esiste per `USA30IDXUSD`, le richieste scendono da **24 per giorno a 1** (nucleo: da ~31.000 a ~1.300), e il tempo di crawl **non sarebbe piu' il collo**. Il prezzo: **OHLC, non tick** (il DD si sottostima fino al ~20 %, §2.5) e uno spread da ricostruire come `ASK - BID` per barra. Quindi la via B serve da **screening di tutti i 12 anni a costo basso**, e la via A (tick) resta per le 2-3 finestre decisive. **Codice nuovo** (decoder delle candele, ~1 funzione) = di nuovo cancello e strato 2.

### 3.4 Il costo in tempo macchina (ricontrollato, con la correzione delle "3 ore")

**Ritmi misurati** (una sera sola ciascuno: la forbice e' onesta, non una stima):

| corsa | cosa | tempo | ritmo | fonte |
|---|---|---|---|---|
| 18/08, DAX M1, motore urllib | 25 giorni su 2.389, 596 ore-file | 1 h 43 min | **4,1 min/giorno** | `REFERTO_DUKASCOPY_FATTIBILITA.md`, `DUKASCOPY_PASSO0.md` §2d |
| 01-03/09, Dow tick, motore curl, **prima corsa** | **3.505 ore-file scaricate** (75,6 MB) + **1.599 gia' in cache all'avvio** + 224 in errore = 5.328 = 222 x 24; esito "COMPLETA MA CON BUCHI" (rc 3) | **39,5 h** | **40,6 s/ora-file = 16,2 min/giorno** | `REFERTO_DUKA_A_20260901_2349.txt`; i conteggi in `referto_py_20260901_2349.txt` |
| 03/09 15:22 e 17:37, rilanci per i buchi | 217 ore-file in 1,6 h (26,5 s/ora-file), poi ~6 in 0,3 h (errori da 7 a 1; il 17:37 non ha `referto_py`) | 1,9 h | (chiusura buchi) | `..._1522.txt` + `referto_py_20260903_1522.txt`, `..._1737.txt` |
| 03/09 22:16, "COMPLETA" | **0,0 MB scaricati**: solo riconversione da cache | 0,2 h | **non e' un ritmo di download** | `..._2216_COMPLETA.txt` |

**Totale vero: 41,4 h per ~3.728 ore-file scaricate (non per 5.328: 1.599 erano gia' in cache all'avvio del 01/09, da una corsa precedente il cui costo non e' agli atti) = ~40 s per ora-file = ~16,0 min per giorno di storico** (non separato quanto fosse attesa di 503 e quanto PC dormiente [NON MISURATO]). Per ora-file: 10,4 s (18/08, urllib, DAX) contro **~40 s** (settembre, curl, Dow): il throttle di Dukascopy e' pesante e variabile, e il motore "piu' veloce" ha misurato il ritmo **piu' lento**. **La stima "0,2 h -> 12 anni in ~3 h" e' l'errore di lettura di una corsa da cache; e la prima correzione (41,4 h / 222 giorni = 11,2 min/giorno) ripeteva lo stesso errore in piccolo, dividendo per giorni che la corsa non aveva scaricato.**

**Proiezioni** (giorni = calendario senza sabati; ore = giorni x min/giorno / 60; **ore di PC acceso**, mai "notti" — checklist 31/08; le "ore" sono la forbice 4,1-16,0 min/giorno, cioe' 10,4-40 s per ora-file) [DERIVATO]:

| set | giorni | richieste (x24) | ore di PC acceso | CSV tick (<=) | bi5 in cache |
|---|---:|---:|---:|---:|---:|
| **W1 sola (ORSO 2022, da 2021-12-01)** | 287 | 6.888 | **20-77** | 1,1 GB | 0,15 GB |
| **CORE-A** (2019-12-01 -> 2022-10-31) | 914 | 21.936 | **63-244** | 3,6 GB | 0,47 GB |
| **W4** (2015-04-01 -> 2016-06-30) | 392 | 9.408 | **27-105** | 1,5 GB | 0,20 GB |
| **NUCLEO = CORE-A + W4** | **1.306** | 31.344 | **90-348** (3,7-14,5 giorni continui) | **5,1 GB** | 0,68 GB |
| extra W5 (2018) | 339 | 8.136 | 23-90 | 1,3 GB | 0,18 GB |
| extra W6 (2012-13) | 546 | 13.104 | 37-146 | 2,1 GB | 0,28 GB |
| extra W7 (toro 2025-26 su DK) | 325 | 7.800 | 22-87 | 1,3 GB | 0,17 GB |
| nucleo + tutti gli extra | 2.516 | | 173-671 | 9,9 GB | 1,3 GB |
| tutto 2012.04.04 -> 2024.09.30 | 3.911 | 93.864 | 269-1.042 | 15,3 GB | 2,0 GB |

Il pavimento teorico senza throttle e' ~2,2 h per il nucleo (31.344 richieste x 0,25 s di pausa) piu' trasferimento; le "3 ore" (0,2 h scalate) cadono per coincidenza li' vicino, ma le corse vere hanno fatto **40-160 volte** il pavimento (10,4-40 s contro 0,25 s per richiesta). La via B (candele) e la prova di pause diverse (P3: 250/1000/2000 ms) sono le due leve che possono avvicinare il numero al pavimento; **nessuna e' misurata**.

**Tester**: ~1 minuto per passata-anno [stima della casa, `EMA200_COSA_MANCA` #9, **non cronometrata** a tick: `PIANO_LATI` §7 la dichiara [NON MISURATO]] -> nucleo 16 passate + calibrazione 10 = **~30-60 min** in tutto. Il costo vero e' il crawl.

### 3.5 Spazio disco

Ancora misurata: **3,92 MB di CSV per giorno** (870,9 MB / 222 giorni; 20.753.611 tick, ~44 byte/riga: **93.485 tick/giorno**; unita': i MB dei CSV li stampa la riga in MiB (`/1MB`), quelli dei `.bi5` il .py in 10^6 byte (`/1e6`): la somma del nucleo qui sotto mescola le due, ed e' ~8,1 GiB = ~8,7 GB decimali, comunque sotto il tetto di 12) e **~0,52 MB di `.bi5` per giorno** come tetto [DERIVATO: 80,6 MB / 3.728 ore-file scaricate = 21,6 KB/ora-file x 24; i 80,6 MB **non** coprono le 1.599 ore-file gia' in cache il 01/09, quindi "80,6 MB / 222 giorni = 0,36" ripeteva sui byte l'errore della classe 1103; stima centrale ~0,47 MB/giorno dai 5,01 byte/tick della corsa del 03/09 15:22 (4,8 MB per 957.396 tick nuovi) applicati ai 20.753.611 tick]. Correzione della seconda passata del cancello (05/10): sposta il nucleo di ~0,2 GB, non il tetto. Le colonne "CSV (<=)" della tabella sopra usano **la stessa densita' del 2024-25** come tetto: negli anni vecchi i tick/giorno sono verosimilmente meno [NON MISURATO: la densita' 2012-2022 non e' mai stata vista].
Aggiungo la **base tick di MT5** del simbolo custom (dimensione [NON MISURATO]; stima prudente ~0,5 x il CSV [INFERITO]). **Nucleo**: <= 5,1 (CSV) + 0,7 (bi5) + ~2,6 (base MT5) = **~8,4 GB**; con margine e file temporanei **tetto proposto 12 GB liberi**. **Tutto**: ~25 GB. Lo spazio libero del PC e' **[NON MISURATO]** (i 97,4 / 81,1 GB liberi dei referti sono del **VPS**, non del PC): P0 lo misura **prima**, non durante.

### 3.6 Banda e rete

Il traffico e' piccolo: **~0,47-0,52 MB di `.bi5` per giorno** => nucleo **~0,6-0,7 GB** in tutto [DERIVATO, §3.5]; il limite e' il **rate limit del server** (503/reset, ban temporaneo, `MAX_ERR_CONSEC=20`), non i byte. Il motore va **sempre `curl`** (urllib e' strozzato dall'impronta TLS, `DUKASCOPY_PASSO0` §8). **Non si parallelizza** senza una misura: un ban dell'IP di Claudio e' un costo che non so stimare [INFERITO]. PC acceso e connesso per giorni: va detto in ore, non in notti.

---

## 4. Rischi e difetti noti (da `CHECKLIST_RIGA_DI_LANCIO.md` e dai referti), uno per uno

1. **Finestra costruita per non sovrapporsi al dato che deve calibrarla** (checklist 31/08): qui la calibrazione K1/K2 usa la sovrapposizione **gia' su disco** (222 giorni dentro 2024.10-2025.06); i 9 giorni della sonda cadono **tutti** dentro quella finestra (verificato: 6 vecchi + 3 nuovi, tutti fra 2024.10.29 e 2025.06.10). I 4 giorni "fuori finestra" della lista congelata dell'importer (`2025.10.28`, `2026.03.11`, `2026.03.24`, `2026.06.15`) **non** sono usabili finche' non si scarica W7.
2. **Tranche spezzate a meta' di un mese** (checklist 31/08): la seconda riscrive il mese della prima: **confini sui primi del mese**, CORE-A inizia il 2019-12-01 e W4 il 2015-04-01.
3. **Numero calcolato + traduzione costante** (checklist 31/08, "4-5 notti"): qui tutto in **ore di PC acceso** con la forbice, mai in notti.
4. **Cache che si avvelena / zero byte** (checklist 16 e 31/08): il punto e' gia' coperto dallo script; da riverificare dopo la modifica di P1 con un autotest.
5. **Il giro a vuoto che sovrascrive il referto vero** (checklist 31/08): il nuovo lancio non scrive nei file del ramo vero.
6. **Spread su un simbolo custom** (checklist 89): sul custom da barre M1 lo spread e' 0 (`out[n].spread = 0`) e non e' mai stato misurato quale prevale; **qui i tick portano bid/ask veri** (mediana 2,53), quindi il problema e' diverso e in meno, ma **va dichiarato nel referto quale spread ha usato il tester** e confrontato con quello di U30USD nativo (2,00-3,00).
7. **iATR/iADX con handle su D1 non popolano nel tester tick** (checklist, `ImportaTickEsterno` r.~46): `771531` usa handle **H1** (`iMA`, `iATR` su `InpTF`), non D1; **[NON MISURATO]** su custom: K1 lo verifica indirettamente (se gli indicatori non popolano, n sara' ~0).
8. **Il commento di un file che "si lancia da solo" dopo mesi**: i 4 file `LATI_*` e i vecchi `R110_*` sono verdi al cancello meccanico ma **non** vanno riusati: per W1-W4 si scrivono file prova **nuovi**, con attese e criteri di questo piano, e si fanno passare da `controlla_prova.py` + `controllo-preventivo`.
9. **Il cambio di criterio dopo i numeri**: nessun numero Dow esterno esiste oggi; ogni soglia qui e' scritta prima. Ma **K1, R2, R3, la regola di etichettatura e W4 sono NUOVI** e per questo stanno dentro F1/F2: non si applicano senza firma.
10. **Nessuna sedia attaccata sul PC di backtest** (14/08, #3160534/#3160535): il censimento P0 lo verifica **prima** di aprire MT5.
11. **Il 21/09**: il tester mangia tutte le CPU e inchioda la macchina: sul PC di backtest va bene, **non sul VPS** (challenge FTMO viva). Tester e download restano su `DESKTOP-H4D7CAJ`, mai sul VPS.
12. **`RIGA_DUKA_A.ps1` non legge nessuna `@DECISIONE`** (grep: zero): il solo cancello di quella riga era una regola scritta nei commenti. La nuova riga **deve leggere** la riga firmata `@DECISIONE` e rifiutare il lancio senza (come `RIGA_STORICO_INDICI.ps1` per D-A..D-H).
13. **R80**: stessa cella, stesso periodo, cambia solo il feed: quattro cambi di segno su quattro. Il confronto di merito **resta sullo stesso feed** (DK 2019-22 contro DK 2024-25, mai DK contro nativo): K1 misura la calibrazione, non il merito.
14. **Il feed e' un altro mercato**: Dukascopy quota un CFD/indice suo; i prezzi della sedia in campo sono BCM. **Spread, commissioni e slippage restano del tester** (R55: 1,5 punti indice spostano un verdetto sull'ORB); per `771531` lo stop mediano e' ~104,3 punti: **54,9x** sullo spread BCM 1,90, **~41x** sullo spread mediano DK 2,53, **39,7x** su FTMO 2,63 e **~35x** a 3,00 (frontiera 40x [`APERTURE_DOW_MAPPA` §2.3, riga EMA200 H1: "al bordo"]). Quindi H1 sta **al bordo** della frontiera, non lontano: il referto dichiara quale spread ha usato il tester (punto 6) e il numero x accanto. Ed e' **fuori dal tester** il gap/slippage del crollo.

---

## 5. Le due firme richieste a Claudio

**F2 - il cancello zero del Dow Dukascopy (si firma ORA, costa un criterio e nessun download)**

*In quattro righe (riassunto della sesta passata; il testo che si firma e' l'appendice vincolante subito sotto, e in caso di dubbio vale l'appendice):*
- **Cosa firmi**: la regola con cui si decide se i dati Dukascopy del Dow (`U30USD_DK`) sono affidabili: si rifanno i conti sui 222 giorni gia' scaricati con l'orologio corretto, si confrontano 9 giorni nominati col feed BCM, e si fa una prova "sbagliata apposta" per essere sicuri che il controllo si accorga di un errore d'un'ora. Se uno dei controlli non torna, il frigo resta chiuso.
- **Cosa NON firmi**: nessun download (quello e' F1, dopo), nessuna deroga se `2024.11.20` resta fuori, niente su rischio, taglie, preset, EA in campo, conto reale `10105439`, conti FTMO.
- **Costo**: zero download, zero spesa; solo il **PC di backtest `DESKTOP-H4D7CAJ`** (PowerShell + MT5 demo `50503392` di quel PC, ~10-20 minuti); **nessun VPS** e nessun suo terminale.

*Appendice vincolante (il testo della firma):*
> **«FIRMO CANCELLO DK DOW»**: per `U30USD_DK` il cancello zero si decide **riconvertendo i 222 giorni gia' scaricati con orologio UTC+1 fisso** e rifacendo la sonda su 9 giorni (i 6 del 03/09 + 2024.12.10, 2025.01.14, 2025.02.11) col metro di sempre (mediana <= 0,05 %, copertura >= 80 %), piu' il **controllo negativo** sul 2025.03.12 convertito apposta in UTC+0 in un simbolo e in una cartella separati: **il cancello zero passa solo se valgono TUTTE E TRE: (1) ciascuno dei 9 giorni NOMINATI qui sopra ha la sua riga per giorno nella sonda, misurata e dentro (dentro = mediana <= 0,05 % E copertura >= 80 % su quel giorno: copertura sotto 80 % e' fuori anche con la mediana bassa), letta nella sonda di `U30USD_DK` e solo li' (la riga per giorno dell'importer, r.503, non stampa il simbolo: ogni riga portata in repo porta il nome del simbolo, e la riga del 2025.03.12 di `U30USD_DKNEG` non vale per la (1) ne' quella di `U30USD_DK` come misura del negativo nella (3): nella (3) la riga di `U30USD_DK` serve solo come "valore giusto dello stesso giorno"); un giorno "NON confrontabile" o assente dalle righe non e' dentro, e non bastano ne' il conteggio "9/9" ne' il verdetto "OK: CANCELLO PASSATO"; (2) le righe dei 5 giorni in ora legale USA sono identiche, byte per byte, nei CSV del 03/09 (copiati prima di riconvertire) e in quelli nuovi; (3) il controllo negativo, misurato (una riga per giorno del 2025.03.12 nel simbolo separato; se esce "NON confrontabile" conta come sotto il doppio), esce almeno al doppio del valore giusto dello stesso giorno **e** con mediana sopra 0,05 % (un errore d'un'ora che resta sotto 0,05 % passerebbe la (1): il metro sarebbe cieco proprio alla soglia che decide), oppure, se manca anche una delle due, K0b mette il picco di correlazione a lag 0 +-1 minuto su ciascuno dei 9 giorni (K0b sostituisce solo la (3): la (1) e la (2) restano obbligatorie); se `2024.11.20` resta sopra, `U30USD_DK` resta in frigo e non firmo nessuna deroga senza la misura della volatilita' oraria del Dow.**

*Da cosa dipende*: **da niente di misurabile oggi** (e' una regola scritta prima dei numeri, che impedisce di ammorbidire il cancello dopo averli visti). Sblocca **P0-P1**, che non scaricano un byte. Nota di precisione: la riconversione con UTC+1 fisso **non e' prevista dalla lettera** di `DUKASCOPY_PASSO0.md` §4a (che ammetteva solo la riconversione "europa" se fallivano i giorni sfasati): e' un **criterio nuovo, motivato da una misura indipendente** (`OROLOGIO_BCM` §3.2, 24/09, venuta dopo e non tarata sulla sonda). Per questo serve la firma, ed e' una firma che **stringe** (9 giorni invece di 6, controllo negativo, K0b) e non allarga. Se P1 fallisce, la prova di regime **non parte** e F1 non va firmata.

**F1 - l'uso dei dati e il tetto di risorse (si firma DOPO P0-P1, con l'esito in mano)**
> **«FIRMO DK DOW REGIME»**: autorizzo l'uso di `U30USD_DK` (Dukascopy `USA30IDXUSD`) come **solo prova di regime a parametri congelati** per la cella `771531`, con le finestre W1-W4, la regola di etichettatura e i criteri K1-K3/R1-R3/M1-M2 di `report/PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md` (estendendo D-B/D-C al Dow come `@DECISIONE D-I`), e autorizzo il download e l'import **solo sul PC di backtest `DESKTOP-H4D7CAJ`** entro **<= 12 GB di disco occupato (e solo se P0 ne misura almeno altrettanti liberi), <= 250 ore di PC acceso e stop (nuova decisione) se la calibrazione K1 fallisce o se il canarino proietta piu' del tetto**.

*Da cosa dipende*:
1. **Dal risultato di P1** (K0 passato): senza feed utilizzabile non c'e' niente da usare.
2. **Dallo spazio libero misurato in P0** (oggi [NON MISURATO]): il tetto di 12 GB regge il nucleo (~8,4 GB) con margine; se il disco non ce l'ha, il nucleo si riduce (W1 da sola ~1,5-2 GB).
3. **Dal ritmo misurato in P3** (oggi **4,1-16,0 min/giorno**, quindi **90-348 h** per il nucleo): 🔴 **il tetto proposto di 250 h sta DENTRO la forbice**, quindi al ritmo dell'unica corsa curl il nucleo intero **non ci sta** e lo stop scatterebbe a meta'. Se Claudio non vuole il PC occupato per quel tempo, la scelta e' tra W1 da sola (20-77 h), CORE-A senza W4 (63-244 h), la via candele (se esiste, P3) o rinunciare.
4. **Dall'uso dei dati**: e' una firma di criterio (le righe `D-B`/`D-C` di `STORICO_INDICI_CRITERI.md` oggi elencano `NASUSD,SPXUSD,D30EUR` e non il Dow) e **cambia criteri prima dei numeri** (W4 al posto del 2019; K1; R2; R3).

**Che cosa le due firme NON toccano**: nessuna delle due **spende soldi** (Dukascopy e' gratuito, nessun servizio o abbonamento a pagamento, nessun upgrade; il costo e' tempo di PC acceso e disco del PC di backtest); nessuna tocca **rischio, taglie, preset, EA in campo, il conto reale `10105439`**, i conti FTMO o i terminali del VPS. Restano tutte decisioni di Claudio fuori da questo piano.

Il verbale va in `report/FIRME_2026-10-xx.md` quando si firma; **non lo creo ora** (nessuna firma e' stata data).

---

## 6. Che cosa e' [NON MISURATO]

1. **Il tempo reale del crawl profondo**: 4,1-16,0 min/giorno e' su finestre recenti (una sera la prima, 39,5 h la seconda) e con due motori diversi; per il 2015-2022 **non esiste nessuna misura**. Neanche il costo delle 1.599 ore-file gia' in cache il 01/09 e' agli atti.
2. **Quanto dei 39,5 h del 01-03/09 fosse attesa di 503** e quanto PC dormiente.
3. **Se le candele pre-aggregate esistono** per `USA30IDXUSD` (dalla mia memoria di `dukascopy-node`, non verificato).
4. **Lo spazio libero sul PC di backtest**, la sua cache `raw` del 03/09, lo stato attuale del terminale `50503392` li' (ultima misura 10/09), `MaxBars`, sedie attaccate.
5. **La densita' di tick 2012-2022** (CSV e base MT5 sono stimati dalla densita' 2024-25).
6. **Se il tester onora i tick custom di `U30USD_DK` (Modello 4)**: nessun round e' mai girato su quel simbolo.
7. **Se il decoder `p1_ask`/divisore 1000 vale anche per gli anni vecchi** (misurato solo su 2024-25 e sul canarino 2025-06): K3 lo controlla.
8. **Il contenuto di Dukascopy prima del 2024** (stesso strumento? orari di sessione? gap?): e' il rischio che il `grxeur` di HistData ha pagato con 42 mesi di un altro indice; K3 e' fatto per questo, ma **fino a K3 e' aperto**.
9. **L'esito dell'orologio**: che 2024.11.20 scenda sotto 0,05 % e' una **predizione [INFERITO]**, non un fatto.
10. **Il DD a 0,65 %** (la taglia della challenge): mai misurato; il DD a 1 % scalato con 1,538 sbaglia del 6 %.
11. **Le fasce di attesa di §2.4 e le soglie nuove** (K1, R2, R3, etichettatura): sono **mie**, non misure; stanno nel piano **perche' sono scritte prima**, non perche' siano verita'.
12. **Il verdetto sul merito per lato**: con ~100-150 posizioni per lato per finestra **resta sospeso** a meno di aggregare per classe (§1.5).
13. **Gemelli (NASUSD, D30EUR, SPXUSD), TF diverso, gestione dell'uscita** per questa cella: fuori da questo piano.
14. **La Via B, se esiste, non e' tick**: sottostima il DD; da dichiarare in ogni tabella che ne uscisse.

---

## 7. Fonti

`report/APERTURE_DOW_MAPPA_2026-10-03.md` (§1.4, §2, §4, §7) · `report/LATI_A1_FINESTRA_DENTRO_L_IS_2026-10-05.md` · `report/PIANO_LATI_REGIME_2026-09-09.md` (§2, §4, §6, §7, §9) · `report/OROLOGIO_BCM_2026-09-24.md` (§0, §3.2) · `report/COME_ALLUNGARE_STORICO_INDICI_2026-09-09.md` (§1.2, §2.3, strada B) · `report/LO_STORICO_ESTERNO_MAPPA_2026-09-23.md` (§5.1, §5.2) · `report/EMA200_DOW_COSA_MANCA_PER_IL_1_OTTOBRE_2026-09-17.md` (§2.3, §3, #7-#9) · `report/I_ROUND_SUL_PC_DI_BACKTEST_2026-09-21.md` · `report/TRASFORMAZIONI_CANDIDATE.md` r.550 · `backtest_pipeline/dukascopy/DUKASCOPY_PASSO0.md` · `backtest_pipeline/dukascopy/dukascopy_tick.py` (`offset_server`, `converti_fuso`, `giorni`, autotest) · `backtest_pipeline/dukascopy/dukascopy_m1.py` · `backtest_pipeline/sonda_dukascopy.ps1` · `backtest_pipeline/risultati_archivio/duka/` (`REFERTO_DUKA_A_20260901_2349.txt`, `..._20260903_1522.txt`, `..._1737.txt`, `..._2216_COMPLETA.txt`, `REFERTO_IMPORT_SONDA_2026-09-03_2243.txt`, `ABTG_ImportTick_referto.csv`, `referto_py_20260903_1522.txt`) · `backtest_pipeline/risultati_archivio/REFERTO_SONDA_DUKASCOPY.md` · `.../STORICO_INDICI_CRITERI.md` (D-B..D-H) · `backtest_pipeline/prove/PROVA_REGIME_CRITERI.md` (§3, A-C, E.6) · `backtest_pipeline/prove/LATI_A2_EMA200_U30USD_TORO_long.txt` (nota 04/10) · `mql5/Experts/ABTG_EMA200.mq5` · `mql5/Presets/ABTG_EMA200_U30USD_H1_771531_VIVA.set` · `mql5/Scripts/ABTG_ImportaTickEsterno.mq5` · `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` (89; sezioni 27/08 e 31/08) · `backtest_pipeline/controlla_riga.py` r.1519-1521 · `backtest_pipeline/righe/RIGA_R113_REGIME_NASUSD.ps1` · `CLAUDE.md` (finestra, due lati, 21/09, certificato di morte).

Verifiche eseguite in questa sessione: (1) conteggio giorni e ore/GB con python (tabella 3.4); (2) le funzioni di calendario di `dukascopy_tick.py` sui sei giorni della sonda e sui 222 iterati (108 con offset USA diverso da +1); (3) controllo che nessuna finestra di regime tocchi l'IS (tabella 1.4); (4) ricerca nel repo di "candles_" (zero: la via B resta non verificata) e di `@DECISIONE` in `RIGA_DUKA_A.ps1` (zero).

*Sviluppatore, 05/10/2026. Nessun candidato promosso o archiviato; nessuna riga di lancio emessa.*

---

## 8. Correzioni della prima passata del cancello (`controllo-preventivo`, 05/10/2026)

Fatte in questo file, mirate; **richiedono una seconda passata indipendente** perche' alcune toccano il merito (numeri delle ore, testo della F2).
1. **Ritmo di download** (§0 p.1, §3.1, §3.4, §5 F1, §6): le 41,4 h non avevano scaricato 222 giorni ma ~3.728 ore-file su 5.328 (1.599 gia' in cache all'avvio, `referto_py_20260901_2349.txt`). Ritmo **~40 s/ora-file = ~16,0 min/giorno**, non 11,2; nucleo **90-348 h**, non 90-244; il tetto di 250 h di F1 ora sta dentro la forbice e lo si dice. Le "3 ore" vengono dalla corsa da cache scalata, non dal pavimento; "10x" diventa 40-160x.
2. **F2** (§5): il testo della firma ora contiene il controllo negativo, i 5 giorni estivi identici e K0b; prima apriva il frigo con i 9 giorni sotto soglia anche se il metro risultava cieco a un'ora di errore, in contrasto con §2.1/§2.5. Tolta la frase "il cancello e' passato alla lettera": la riconversione UTC+1 fisso e' un criterio nuovo (che stringe), non la lettera di `PASSO0` §4a.
3. **Controllo negativo** (§2.5): il giorno sbagliato va in un simbolo custom separato, perche' il 2025.03.12 sta dentro la finestra K1.
4. **Frontiera di costo** (§4 p.14): "~35x ... il costo non e' il collo" si contraddiceva con la frontiera 40x; ora 54,9x / ~41x / 39,7x / ~35x per spread, cioe' "al bordo".
5. **K3** (§2.1): il 2016 e il 2022 non hanno il 31/12 nel nucleo; si usa l'ultima chiusura scaricata.
6. Minori: etichettatura con caso MISTO; K1 cieco a un'ora di errore dichiarato; K2 con la tabella sessioni; mesi per lato (~24 -> 18-20); posizioni attese W6/W7; 108 = 107 + 2 meta'; scarto ~23 mesi; percorso dei CSV r31; fonte del 108.108; nota sulla taglia 2,00 % della trial; dichiarazione esplicita "nessuna spesa".

## 8-bis. Correzioni della seconda passata del cancello (`controllo-preventivo`, 05/10/2026, passata indipendente)

Rifatti dalla fonte, senza fidarsi del §8: i conteggi dei quattro `REFERTO_DUKA_A_*` e dei due `referto_py_*`; il contatore `cache`/`scaricate` dentro `dukascopy_tick.py` (una sola passata per corsa: le 1.599 ore in cache sono davvero di prima del 01/09); tutte le proiezioni di §3.4 con python; i 108 giorni su 222 con le funzioni dello script; i giorni della sonda dal `REFERTO_IMPORT_SONDA_2026-09-03_2243.txt`; PF/deal/DD dai CSV r31; i deal per lato da `PIANO_LATI` §2; le fonti [CASA] di R1, M1, M2; la nota sul 2,00 % della trial.
1. **Disco `.bi5`** (§3.4 tabella, §3.5, §3.6, §5 F1 p.2): "80,6 MB / 222 giorni = 0,36 MB/giorno" divideva i byte di 3.728 ore-file per 5.328: e' la **classe 1103 sui byte**. Ora ~0,52 MB/giorno come tetto (0,47 stima centrale); nucleo ~8,4 GB invece di ~8. Il tetto di 12 GB non cambia.
2. **F2, condizione dei giorni estivi** (§5, §2.1): "identici a prima" rimandava a valori per giorno della sonda del 03/09 che **non sono in repo** (il referto stampa solo il peggiore). Ora il confronto e' sulle righe dei CSV, con copia di sicurezza presa prima di riconvertire (P1).
3. **F2, ruolo di K0b** (§5): "(altrimenti decide K0b)" si poteva leggere come "K0b decide il cancello". Ora e' scritto che K0b sostituisce solo la terza condizione e che le prime due restano obbligatorie.
4. **Controllo negativo** (§2.5, §3.1 P1, F2): oltre al simbolo separato serve una **cartella di uscita separata**: lo scrittore mensile riscrive `U30USD_DK_ticks_2025-03.csv` per intero, e una conversione di un solo giorno nella cartella di sempre cancellerebbe il marzo della calibrazione K1.
5. Minore: citazione doppia in §1.1.

## 8-ter. Correzioni della terza passata del cancello (`controllo-preventivo`, 05/10/2026, lettore indipendente)

Rifatti dalla fonte e trovati GIUSTI: 80,6 = 75,6 + 4,8 + 0,2 MB (`REFERTO_DUKA_A_*` r.14, MB = 10^6 byte, `dukascopy_tick.py` r.933/942); tick 19.759.186 -> 20.716.582 (`referto_py_*`), differenza 957.396, 4,8e6 / 957.396 = 5,01 byte/tick; 21,6 KB/ora-file x 24 = 0,519 MB/giorno; 5,01 x 20.753.611 / 222 = 0,469; tutte le righe della tabella §3.4 (ore con 4,12 min/giorno = 103 min / 25 giorni, che spiega 90 e non 89; CSV a 3,923 MiB/giorno; bi5 a 0,519); nucleo 5,1 + 0,68 + 2,6 = 8,4; `ScrittoreMensile._flush` riscrive davvero il mese per intero (`scrivi_atomico`, `os.replace`), quindi la copia di sicurezza prima di riconvertire e' necessaria e il piano la chiede; nessun residuo contraddittorio di 11,2 / 90-244 / 0,36 / "3 ore" (le citazioni rimaste sono storiche e dichiarate tali; 244 resta solo come tetto alto di CORE-A, corretto).
1. **F2 (1) e §2.1, denominatore della sonda**: l'importer salta in silenzio un giorno senza tick nativi e stampa `OK` se tutti i MISURATI passano. Contro-esempio: `2024.11.20` non confrontabile -> "8/8 OK" senza il giorno che falsifica l'ipotesi. Ora: **9 misurati su 9**.
2. **F2 (3) e §2.1, K0b**: "il picco a lag 0" senza dire se per giorno o aggregato. Contro-esempio: 5 estivi a lag 0 + 4 invernali a lag 60 = picco aggregato a 0, frigo aperto con l'inverno sbagliato. Ora: **su ciascuno dei 9 giorni**.
3. **§2.5 e §3.1 P1, controllo negativo**: il piano chiedeva simbolo e cartella separati ma non diceva che la riga di import **non sa leggerli** (`$TickSrc`, maschera e giorni sonda cablati; nome del CSV negativo identico al marzo buono, che in `MQL5\Files` verrebbe sovrascritto). Ora e' dichiarato cosa esiste (`--cartella`, `--fuso utc`, `-SimboloDK`) e cosa P1 deve aggiungere; e che le righe per giorno della sonda vanno in repo (la (3) ne ha bisogno, e il 03/09 si sono perse proprio cosi').
4. Minore: ~44 byte/riga (non 42: i MB dei CSV sono MiB) e nota sulle unita' del nucleo (~8,1 GiB = ~8,7 GB, sotto il tetto).

## 8-quater. Correzioni della quarta passata del cancello (`controllo-preventivo`, 05/10/2026, lettore indipendente)

Riverificati alla fonte e trovati GIUSTI: `ABTG_ImportaTickEsterno.mq5` r.498 (`if(!valido) continue;`) e r.523 (`giorniOk == giorniMisurati` -> `OK: CANCELLO PASSATO`); `passa` a r.500 = mediana E copertura; `dukascopy_tick.py` r.915 (`bcm + "_DK"`), opzioni `--cartella`, `--fuso utc`, `--solo-cache` (r.745-750), `offset_server` (`usa` = +1 in ora legale USA, 0 altrimenti: i 5 giorni estivi danno davvero lo stesso orologio di UTC+1 fisso, `europa` da' 0 il 12/03/2025); `RIGA_DUKA_IMPORT_SONDA.ps1` r.69, r.77 (6 giorni, con `2025.06.10`), r.206, r.210, r.225, `-SimboloDK` r.53; grep `DKNEG` su `.ps1/.py/.mq5` = zero.
1. **F2 (1) per nome, non per conteggio** (§2.1, §3.1 P1, F2): il "9 misurati su 9" della terza passata si poteva soddisfare con un giorno ripetuto o con `2024.11.20` saltato e un altro contato due volte; e l'importer salta in silenzio anche i giorni senza tick DK, con < 30 minuti comuni e le date malformate. Ora: ciascuno dei 9 giorni nominati, con la sua riga; la riga di import non decide la (1) dal solo verdetto (r.368).
2. **F2 (1), "dentro"**: scritto che dentro = mediana **e** copertura; copertura < 80 % e' fuori.
3. **F2 (3)**: un controllo negativo "NON confrontabile" non lasciava scegliere nessun ramo; ora conta come sotto il doppio (quindi K0b).

## 8-quinquies. Correzioni della quinta passata del cancello (`controllo-preventivo`, 05/10/2026, lettore indipendente)

Riverificati alla fonte e trovati GIUSTI: `ABTG_ImportaTickEsterno.mq5` r.317 (`gn <= 0 || gd <= 0`), r.357 (`cnt < 30`), r.493 (`if(g <= 0) continue;`), r.498 (`if(!valido) continue;`), r.500 (`passa` = mediana E copertura), r.523 (`giorniOk == giorniMisurati`); `RIGA_DUKA_IMPORT_SONDA.ps1` r.368 (`*OK: CANCELLO*` -> `$Codice = 0`); il 2025.03.12 e' fra i 6 giorni di r.77, quindi il "valore giusto dello stesso giorno" della (3) esiste nella (1).
1. **F2 (3), metro cieco alla soglia** (F2, §2.5): contro-esempio: giorno giusto 0,020 %, negativo 0,045 % -> "almeno al doppio", K0b non richiesto, ma un errore d'un'ora sta **dentro** 0,05 % e quindi la (1) non discrimina l'orologio sui giorni invernali. Ora il negativo deve uscire al doppio **e** sopra 0,05 %, altrimenti K0b (copre anche il caso degenere 0 >= 2 x 0).
2. **F2 (1)/(3), attribuzione delle righe** (F2, §3.1 P1): la riga per giorno (r.503) non stampa il simbolo; il 2025.03.12 compare sia nella sonda di `U30USD_DK` sia in quella di `U30USD_DKNEG`. Contro-esempio: DK 0,060 % (fuori) e NEG 0,030 % scambiati -> tutte e tre "passano". Ora ogni riga in repo porta il simbolo e ciascuna condizione si legge solo sul suo.

## 8-sexies. Sesta passata del cancello (`controllo-preventivo`, 05/10/2026): PASS con riserve di sola forma

Riverificati alla fonte e trovati GIUSTI: importer r.493/498/500/503 (r.503 = `PrintFormat` della riga per giorno: data, mediana, copertura, tick, spread, esito; **nessun simbolo**) e r.523; `RIGA_DUKA_IMPORT_SONDA.ps1` r.77 (6 giorni, 2025.03.12 incluso) e r.368; `dukascopy_tick.py` `--dst usa` = UTC+1 in ora legale USA e UTC+0 d'inverno (r.189-191), quindi i 5 giorni estivi identici e il negativo UTC+0 = l'errore del 03/09. F2 (3) e' soddisfacibile senza banalita' (giusto 0,03 %, negativo 0,07 %: passa; giusto 0,04 % chiede negativo >= 0,08 %; 0 >= 2 x 0 va in K0b) e la stretta non apre il frigo: (1) e (2) restano obbligatorie in ogni ramo.
1. **F2, attribuzione**: "la riga di `U30USD_DK` non vale per la (3)" contraddiceva la (3), che usa proprio quella riga come valore giusto. Ora: non vale **come misura del negativo**.
2. **§2.1 K0b**: "il controllo negativo qui sotto" puntava a niente (sta in §2.5) e non diceva quando e' debole; ora rimanda a §2.5 con le tre condizioni della F2 (3).
3. **§2.5**: "oppure riscaricata: 24 ore-file" era un download dentro una firma a zero download; ora solo dalla cache, altrimenti lo stop di P0.
4. **F2 leggibile**: aggiunto in testa un riassunto di 4 righe (cosa firma, cosa non firma, costo); il testo procedurale resta appendice vincolante e prevale.
- **Limite dichiarato, non un difetto**: la sensibilita' del metro si misura su UN giorno (2025.03.12) e si estende ai 4 invernali; un giorno invernale piu' calmo potrebbe tenere un errore d'un'ora sotto 0,05 %. Lo coprono in parte l'offset costante di `--dst fisso` (con autotest) e la (2); del tutto solo K0b.
