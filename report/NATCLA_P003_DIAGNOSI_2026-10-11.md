# NatCla -- il caso P_003: diagnosi e opzioni (11/10/2026)

**Stato: NON passato dal cancello.** Solo diagnosi. **La v1.13 NON e' stata scritta** (motivo al par. 5): nessun file `.mq5` toccato
o aggiunto. L'EA in repo resta `mql5/Experts/EA_NatCla.mq5` v1.12, SHA256 `729bb4289b01...` (ricontrollato su `origin/lavoro` 92023408).

**Revisione 2 (stesso giorno), dopo il FAIL del cancello sulla prima stesura @ `65bac763` (classe 1331 della checklist, @ a7e88130).**
Che cosa cambia rispetto alla prima stesura:
- la conclusione "nessun ritentativo poteva vincere" valeva per **4 eventi su 5** (INFERITO, par. 3.3), non per tutti: il caso D (25/05/2025, -2.091,48 EUR)
  e' **NON DETERMINABILE** (par. 3.3);
- "l'unico intervento e' una regola nuova" non era dimostrato: l'opzione C si divide in **C1** (cancellare in anticipo o scadenza lato
  server: accorcia la vita dell'ordine solo dell'anticipo scelto prima della chiusura; non cambia quando e se la scala si arma) e **C2**
  (regola nuova); in piu' c'e' il **ritentativo senza pausa alla riapertura** per il caso D;
- le frasi "dal vivo" della tabella del par. 5 sono marcate INFERITO;
- la citazione del formato CTrade puntava a un file senza righe CTrade: ora punta a quello giusto;
- i residui li cancella anche il **flip**, non solo X10;
- gli episodi di orfani sono **451** (450 con guardia + 1 senza, M30_004 2024.07.18): **442 risolti dal ritentativo (441 + 1), 9 adottati**;
- le finestre dell'oro **cambiano con la stagione**: l'INFERITO "sessioni fisse della specifica" e' indebolito;
- aggiunti: invii sincroni (FATTO di codice), P_004 alle 23:05:00 (smentisce un'alternativa), semaforo E7 che non scatta dopo un'adozione.

**Revisione 3 (stesso giorno), dopo il secondo FAIL @ `f2e1acc9` (classe 1334, @ 4f9b4fe8).** Che cosa cambia rispetto alla revisione 2:
- l'origine della pausa di 10 s: conta dall'**ultimo ritentativo fallito** (variabile `gOrfTent[L]`, scritta solo a EA r.2091, azzerata
  in `OnInit` r.1327), **non** dalla guardia; la differenza fra le domeniche oro 2024 (sblocco 23:10:00/:01) e 2025 (23:10:05/:06) e'
  INFERITO venire dalla fase dell'ultimo ritentativo fallito, non dalla guardia (par. 3.3);
- l'opzione B **non** rende determinabile il caso D: lo decidono i tick 23:09:50-23:10:01 e l'orario di sessione, oppure una passata con R;
- il par. 5 non si contraddice piu' su B; C1 descritta come sopra, con il costo giusto (riempimenti persi, non esposizione);
- i 10 episodi oro 00:00 -> 00:05 di lug-ott stanno solo nelle passate M30 oro (M30_002 e M30_003, stessi 10 episodi in 5 date: 2024.07.12 x3,
  07.17, 09.13 x2, 09.25 x2, 10.16 x2; 3 mercoledi' con 5 episodi e 2 venerdi' con 5 episodi); zero nelle H1 (P_001, P_002, M30_001);
- la premessa dei "No" A/B/C (la sessione riapre esattamente alle 23:10:00) e' dichiarata, e l'etichetta e' INFERITO con premessa.

**Revisione 4 (stesso giorno), dopo il terzo FAIL @ `d6f35654` (classe 1335, @ e99c94a3).** I 10 episodi 00:00 -> 00:05 di lug-ott
stanno in ENTRAMBE le passate M30 oro (M30_002 e M30_003), non solo nella M30_002 (la frase della revisione 3 e' stata corretta nel suo stesso punto, qui sopra);
rimesse le etichette INFERITO sulla fase 2024/2025 e sulla conclusione del par. 1 punto 10; aggiunto il NON COPERTO sulla lettura dei tick.

**Revisione 5 (stesso giorno), dopo il quarto giro @ `ea67f3db` (6 errori preesistenti di conteggio/intervallo, nessuno cambia verdetto
o opzioni).** Riscontrati sui log con uno script prima di scriverli:
- par. 4(b) "riempimento fra tentativo e conferma": l'attesa va da **5 min 01 s** (caso D) a **49 h 05 min** (P_003), non "da 10 minuti a 49 h";
- par. 4(b) "ordine in transito": i pendenti restano da **4 min** (5 episodi EURUSD 22:01 -> 22:05) a **51 h 10 min** (14 episodi oro
  ven 22:00 -> lun 01:10), non "da 5 minuti a 49 h";
- intestazione del par. 3.2: **4 eventi** (A, B, C, D, in 3 weekend), non 3; in tutto il documento: **9 adozioni = 5 eventi** (P_003,
  A, B, C, D) in **4 weekend**, su **3 passate** (P_003, M30_002, M30_003);
- par. 1 punto 6: "3 adozioni" contava per passata dentro "Nei 9 casi": ora A, B, C = 6 adozioni, D = 2, P_003 = 1;
- testata, revisione 2: "4 eventi su 5" ora porta l'etichetta INFERITO;
- par. 3.3: aggiunte alla lista la domenica 22/09/2024 (23:10:01) e le date delle domeniche 2024 a 23:10:00.
Scansione fatta da me su tutte le espressioni "da X a Y", "fra X e Y", "N casi/eventi/adozioni/episodi/passate/righe" del documento
contro i log: le altre tornano (EURUSD luglio 2024-febbraio 2025; 450 / 451 / 442 / 514 episodi; 7 passate; 13 righe CTrade; 2-4 USD;
49 h 05 min; 2 passate dell'opzione B; 10 episodi 00:00 -> 00:05 per passata M30 oro).

**Revisione 6 (stesso giorno), dopo il quinto giro @ `6fd3e5c3` (classe 1339, @ b9ffd42f: numero giusto, unita' o insieme sbagliati).**
Riscontrati sui log e sul file prima di scriverli:
- i 10 episodi oro 00:00 -> 00:05 sono **10 episodi in 5 date** per passata (2024.07.12 ven x3, 07.17 mer, 09.13 ven x2, 09.25 mer x2,
  10.16 mer x2): **3 mercoledi' con 5 episodi e 2 venerdi' con 5 episodi**, non "10 date, 5 mercoledi' e 5 venerdi'" (testata rev. 3,
  par. 1 punto 5, par. 6 punto 3);
- par. 4(a): le 13 righe CTrade di `caccia_ticket_VMI3047753.txt` sono **12 `[invalid stops]` + 1 `[invalid request]`** (r.159); la
  seconda "invalid request" e' la riga del giornale `Trades` r.144 sullo stesso ticket, fuori dalle 13: una cancellazione fallita lascia
  una coppia di righe;
- "lun-ven" sull'EURUSD 22:00 -> 22:05 diventa **lun-gio**: nessuna delle fini alle 22:05 cade di venerdi'; i 17 episodi del venerdi'
  22:00 finiscono alla riapertura (dom 23:05 x7, lun 00:00 x2, lun 00:06 x8). Il minimo di 4 minuti cade mar 2024.10.01 e lun 2024.10.14.
  Riconteggio delle fini alle 22:05 per giorno, nell'unita' dichiarata: **per linea 157 (lun 37, mar 42, mer 39, gio 39)**; per
  (passata, data) 136; per data distinta 72 (lun 16, mar 20, mer 17, gio 19). Il "79 (lun 21, mar 19, mer 19, gio 20)" del cancello **non
  lo riproduco in nessuna di queste unita'**: il fatto "nessuna di venerdi'" regge in tutte e tre.
Scansione delle espressioni con giorni e insiemi ("lun-ven", "lun-gio", "mercoledi'", "venerdi'", "domenica", "date", "episodi",
"righe"): "lun-ven" resta solo come insieme di orari d'INIZIO (par. 1 punto 2, appendice, con la nota sull'etichetta dello script);
"lun-gio" dell'oro (par. 1 punto 5) conta solo episodi iniziati lun-gio; "ultimo riarmo del venerdi'" (9 adozioni) e le date 15/11,
22/11, 20/12/2024 (tutti venerdi') tornano.

**Fonti (tutte in repo, nessun dato nuovo):**
- **P** = pilota H1 `backtest_pipeline/risultati_archivio/NATCLA_F1_P_20261011/NATCLA_F1_P.zip` (EA **v1.11**: riga `AVVIO v1.11` nei log;
  i rami usati qui sono identici in v1.12: `git diff 4db1af18 d1aef381` tocca solo NC_VER, l'input `InpAmmettiTFSottoH1`, `Risolvi`, il
  magic M30 e `StampaConfigurazione`).
- **M** = lotto M30 `backtest_pipeline/risultati_archivio/NATCLA_F1_M30_20261011/NATCLA_F1_M30.zip` (EA v1.12).
- Dentro ogni zip: `log\<passata>.txt` (SOLO righe `[NatCla]`/`[NATCLA-IMBUTO]` + poche righe del Tester: regex `$reRiga`,
  `backtest_pipeline/righe/NATCLA_F1_M30_PASSATE.ps1` r.507, uguale in `NATCLA_F1_PASSATE.ps1` r.483), `csv\`, `trades\`, e i **report
  `.htm` del tester** con le tabelle **Ordini** (ora di piazzamento, ora di fine, stato `canceled`/`filled`) e **Deal**. I `.htm` dicono
  **quando** ogni pendente e' nato e **quando** e' morto.
- Codice: `mql5/Experts/EA_NatCla.mq5` v1.12, righe citate come "EA r.N".

Etichette: **FATTO** = letto in un file (citato); **INFERITO** = dedotto da fatti + comportamento noto della piattaforma, non letto;
**IPOTESI** = compatibile, non dedotta; **NON DETERMINABILE** = i dati che abbiamo non bastano a decidere.

---

## 1. La diagnosi in 10 righe

1. **FATTO** -- Nelle 7 passate distinte (P_001..P_004, M30_002..M30_004; M30_001 ha gli stessi tick della P_001) ci sono **450 episodi
   con la riga "guardia anti-duplicato"**: 441 finiscono con il ritentativo riuscito, **9 in ADOZIONE** (1 nella P_003, 4 nella M30_002,
   4 nella M30_003). In piu' **1 cancellazione fallita senza guardia** (M30_004, E200, armato 2024.07.18 20:00, ritentativo riuscito
   22:05:13 senza guardia prima). Totale: **451 episodi di pendenti orfani, 442 risolti dal ritentativo, 9 adottati**, nessuno aperto.
2. **FATTO** -- I 450 episodi con guardia **cominciano tutti** in pochi orari (lun-ven 22:00/22:01/23:00/00:00, prima barra della
   domenica) e **finiscono tutti** in pochi minuti (22:05, 23:05, 00:00/00:05/00:06, 01:10; domenica 22:10/23:05/23:10). Conteggi in
   appendice.
3. **FATTO** -- Negli stessi orari gli INVII di ordini nuovi falliscono con `retcode 10018 market closed`. Il 2024.07.30 22:00:00 (P_003,
   log r.245-252) succede nello stesso secondo: guardia su ST25 e ST30, 10018 sui tre ordini ST35.
4. **INFERITO forte** -- La cancellazione fallisce perche' la barra si apre in una finestra in cui non si opera (sessione chiusa). Non e'
   DIMOSTRATO: il retcode di `OrderDelete` non c'e' in nessun file (EA r.1962 non lo scrive; la riga d'errore di CTrade non ha il
   prefisso `[NatCla]` e il driver la scarta, r.507).
5. **FATTO** -- Le finestre di chiusura: sull'**EURUSD** stanno ferme (lun-gio 22:00 -> 22:05 da luglio 2024 a febbraio 2025, anche
   attraverso il cambio d'orologio BCM; il venerdi' 22:00 i pendenti restano fino alla riapertura: dom 23:05 o lun 00:00/00:06); sull'**oro** cambiano con la stagione (lun-gio: lug-ott 23:00 -> 23:05, nov-dic 22:00 -> 01:10,
   gen-feb 22:00 -> 00:05, mar-mag 00:00 -> 00:05; misurate su P_001 e M30_002; nelle sole passate M30 oro (M30_002 e M30_003,
   stesse date) in lug-ott compaiono anche 10 episodi 00:00 -> 00:05 in 5 date (3 mercoledi' con 5 episodi, 2 venerdi' con 5 episodi:
   i venerdi' sono fuori dal lun-gio della tabella); zero nelle H1). Da dove vengano queste finestre (orari della specifica, buchi dei tick, o tutti e due) e' **NON DETERMINATO**: l'idea "il tester applica una specifica fissa" regge sull'EURUSD e non basta sull'oro.
6. **FATTO (tabella Ordini dei `.htm`)** -- Nei 9 casi adottati il pendente veniva dall'**ultimo riarmo del venerdi** (21:00 H1, 21:30
   M30, 20:30 M30) e si e' riempito alla riapertura della domenica: P_003 23:05:00 (lo stesso secondo in cui la P_004 riesce a
   cancellare), oro 15/09 e 13/10 (eventi A, B, C: 6 adozioni fra M30_002 e M30_003) 23:10:00 (il primo secondo in cui le domeniche oro
   2024 sbloccano le cancellazioni), e oro 25/05 (caso D, 2 adozioni) **23:10:01**. Prezzi eseguiti contro limite: P_003 1.04033 su 1.04032,
   15/09 2577.94 su 2578.00, 13/10 2649.95 su 2653.85 e 2652.09 (salto vero), **caso D 3347.87 su 3347.88** (0,01: il prezzo arriva al
   limite, non lo scavalca).
7. **FATTO (codice + log)** -- Il ritentativo che il compito proponeva **esiste gia' nella v1.12** (Sincronizza EA r.2084-2091, al massimo
   uno ogni 10 s per linea, EA r.387) e risolve 442 orfani su 451. **In 4 eventi su 5** (P_003; oro A 15/09, B e C 13/10) il riempimento cade
   al primo tick operabile: nessun ritentativo dopo la chiusura poteva vincere (P_003: INFERITO forte, confronto con la P_004; oro
   15/09 e 13/10: INFERITO con la premessa dichiarata che la sessione riapra esattamente alle 23:10:00; par. 3.3). **Nel caso D** il
   riempimento e' alle 23:10:01 a 0,01 dal limite. La pausa di 10 s conta dall'ultimo ritentativo FALLITO (`gOrfTent[L]`, scritto solo a
   EA r.2091): se fra quel ritentativo e le 23:10:01 c'era un tick operabile, un ritentativo a ogni tick l'avrebbe cancellato. **NON
   DETERMINABILE dai dati** (mancano i tick 23:09:50-23:10:01 e l'orario di sessione).
8. **FATTO (codice + `.htm`)** -- Dopo l'adozione restano vivi **gli altri pendenti vecchi**: li cancellano solo X10 alla prima USCITA
   (EA r.2126-2127) o il **flip** della linea (EA r.1591-1593). P_003 riempie anche O2 e O3 un'ora dopo (`riempiti 3`); su M30 i residui
   2468, 2471, 9738 muoiono al flip. Il 13/10/2024 due linee adottate restano aperte insieme (SEMAFORO SFORATO, EA r.2078-2082). E
   **FATTO di codice, non misurato sui dati**: un'adozione non fa scattare il semaforo E7 sulle scale armate delle altre linee.
9. **FATTO** -- Il rischio e' vero e limitato dallo SL originale dell'ordine (sta sul server): M30_002 il 2025.05.25 chiude a SL con
   -2.091,48 EUR, scritto nel CSV a **0,00 R** perche' `rischio_soldi` dell'adottato resta 0 (ResetSetup EA r.1990); circa -0,83 R
   ricostruito (INFERITO).
10. **Conclusione** -- L'intervento (1) logging + (2) "ritentare finche' riesce" **non risolve 4 eventi su 5 (INFERITO: P_003 forte, A/B/C
    con la premessa del par. 3.3); sul quinto (il caso D, il piu' costoso) e' aperto**. Quindi niente v1.13 di notte: servono la prova del retcode (opzione A, zero righe di EA) e una decisione
    fra le opzioni del par. 5.

---

## 2. Il meccanismo, passo per passo (codice v1.12)

| passo | dove | cosa succede | etichetta |
|---|---|---|---|
| 0 | OnInit EA r.1335-1337 | `CTrade` impostato con magic, filling e deviazione: **nessun** `SetAsyncMode` ne' `SetLogLevel` -> invii **sincroni**, e CTrade stampa gli errori con il suo livello di default | FATTO (codice) |
| 1 | OnTick EA r.1385-1391; OnTradeTransaction r.1396 | a ogni tick: prima `Sincronizza()`, poi, se e' nata una barra, `OnNewBar()`; anche ogni nuovo deal chiama `Sincronizza()` | FATTO (codice) |
| 2 | ArmaScala EA r.1669, r.1673 | a ogni barra la scala viene **riprezzata** (cancella e riarma) con scadenza 0 (r.1669 passa `0`; a r.1871 la scadenza lato server scatta solo con `scad>0`); il log `ORDINE`/`SETUP armato` esce solo al primo armamento (`gArmatoPrima`), i riarmi sono **muti** | FATTO (codice) |
| 3 | ValutaScala EA r.1598 | alla barra dopo, `CancellaSetupNonRiempito(L,"")`: motivo vuoto -> nessun log nemmeno se riesce (EA r.1964) | FATTO (codice) |
| 4 | CancellaOrdiniLinea EA r.1962 | `if(gTrade.OrderDelete(t)) n++;` -- **nessun Log sul ramo falso** | FATTO (codice) |
| 5 | CancellaSetupNonRiempito EA r.1970 | `ResetSetup(L)` **sempre**, anche se la cancellazione e' fallita: la memoria del setup (rischio, tocco, SL) si perde | FATTO (codice) |
| 6 | ValutaScala EA r.1611-1612 | `ContaLinea` trova i pendenti ancora vivi -> riga `guardia anti-duplicato (0 posizioni, 3 pendenti ...)` e niente riarmo. La guardia si stampa solo se la valutazione arriva fin li' (filtri e semaforo prima): per questo esiste anche un orfano senza guardia (M30_004, 2024.07.18) | FATTO (codice + log) |
| 7 | Sincronizza EA r.2090-2091 | linea senza setup, 0 posizioni, pendenti vivi -> ritenta `CancellaOrdiniLinea` se sono passati almeno `NC_ORF_PAUSA_SEC`=10 s (EA r.387) dal ritentativo precedente (`gOrfTent[L]`, scritto solo a r.2091, azzerato in `OnInit` r.1327: il primo ritentativo e' immediato); se riesce: riga `cancellati N pendenti (pendenti senza setup ...)` | FATTO (codice + log) |
| 8a | -- | alla riapertura il ritentativo riesce: fine dell'episodio (442 orfani su 451) | FATTO (log) |
| 8b | Sincronizza EA r.2074-2077, AdottaLinea r.2036-2054 | se un pendente vecchio si riempie prima: `ADOTTATO`, setup con `adottato=true`, `riempito=true`, `rischio_soldi`=0, `nPosId`=posizioni del momento | FATTO (codice + log) |
| 8c | Sincronizza EA r.2092 contro r.2105-2116 | il ramo dell'adozione finisce con `continue`: il blocco del primo riempimento (con il semaforo E7 che cancella le scale armate delle ALTRE linee) non viene eseguito, ne' ora ne' dopo (`riempito` e' gia' true). Non misurato sui dati | FATTO (codice) |
| 9 | Sincronizza EA r.2126-2127; ValutaScala r.1591-1593 | i pendenti residui si cancellano alla prima USCITA (`np<nPosId`, X10) o al **flip** della linea; fino ad allora possono riempirsi | FATTO (codice + `.htm`) |
| 10 | ChiudiSetup EA r.2241, r.2245 | R = 0 (rischio 0) ed etichetta fissa `(setup adottato dopo un riavvio)` anche senza riavvio | FATTO (codice + log) |

Al passo 6 una cancellazione e' stata **tentata davvero** sullo stesso tick: o da `Sincronizza` (passo 1, se la linea era gia' senza
setup) o da EA r.1598 (se il setup era attivo: nei 9 casi lo era, gli ordini erano stati piazzati alla barra prima e non riempiti,
tabella Ordini). Dopo il tentativo gli ordini erano ancora sul conto -> l'`OrderDelete` **non li ha tolti** (FATTO). Che abbia
restituito `false` con 10018 e' INFERITO: l'invio e' sincrono (passo 0) e 10018 e' quello che lo stesso secondo restituisce agli invii.

---

## 3. Le 9 adozioni (5 eventi in 4 weekend, su 3 passate), ricostruite (orario server = orario del tester)

### 3.1 P_003 -- EURUSD AUDIO H1 SHORT LINEA (pilota, v1.11)
Fonti: `log\P_003_...txt` righe 1823-1831; `report\P_003_...htm` tabelle Ordini/Deal; `csv\P_003_...csv` riga 125; per il confronto
`log\P_004_...txt` (stessi tick EURUSD H1).

| quando | barra | azione | fonte | etichetta |
|---|---|---|---|---|
| ven 2025.02.28 21:00:00 | H1 21:00 | ST25 SHORT armato: ordini **4603/4604/4605** SELL LIMIT 1.04032/1.04082/1.04132, SL 1.04385, TP 1.03982 | log + `.htm` Ordini | FATTO |
| ven 22:00:00 | H1 22:00 | tentata la cancellazione (EA r.1598) -> `ST25: guardia anti-duplicato (0 posizioni, 3 pendenti ...)` | log r.1829 | FATTO (riga) / INFERITO (esito `false` dell'OrderDelete) |
| ven 22:00 -> dom 23:05 | -- | nessuna riga EA; 4603-4605 restano vivi (nessuna ora di cancellazione nei `.htm`) | `.htm` | FATTO |
| ven 22:00 -> dom 23:05 | -- | ritentativi ogni 10 s sui tick che arrivano (se arrivano), falliti **in silenzio** | codice EA r.2090 | INFERITO (non osservabile) |
| **dom 2025.03.02 23:05:00** | H1 23:00 (prima della settimana) | 4603 **riempito** a 1.04033 (deal 308) -> `ADOTTATO ST25: 1 posizioni` | `.htm` Deal + log r.1830 | FATTO |
| dom 23:05:00, **P_004** | H1 23:00 | sugli stessi tick, la P_004 cancella i suoi orfani E200 (`E200: cancellati 3 pendenti (pendenti senza setup ...)`) e riarma | log P_004 | FATTO |
| lun 00:08:00 / 00:08:59 | -- | 4604 riempito a 1.04085, 4605 a 1.04132: i residui non erano stati cancellati | `.htm` | FATTO |
| lun 09:23:20 | -- | TP 1.03982 su tutte e tre: `USCITA ... 807.44 = 0.00 R, riempiti 3 ... (setup adottato dopo un riavvio)` | log r.1831, CSV | FATTO |

Attesa 22:00 ven -> 23:05 dom = **49 h 05 min** (FATTO). Il ritentativo della P_003 alla prima quotazione di domenica era libero dalla
pausa (ultimo tentativo al piu' venerdi sera). La **P_004 sugli stessi tick cancella con successo alle 23:05:00**: alle 23:05:00 si poteva
cancellare. Questo **smentisce** l'alternativa "ritentativo eseguito alle 23:05:00 e fallito a sessione chiusa" e rafforza la lettura
"sullo stesso tick il tester riempie il pendente **prima** di passare il tick all'EA" (INFERITO forte: l'ordine interno della piattaforma
non e' scritto in nessun file, ma e' l'unica lettura compatibile con le due passate).

### 3.2 M30_002 / M30_003 -- XAUUSD AUDIO M30 LONG (GEOM / PIU, v1.12): le stesse 4 adozioni per passata (4 eventi: A, B, C, D, in 3 weekend; B e C sono due linee dello stesso weekend)
Fonti: `log\M30_002_...txt`; `report\M30_002_...htm`; `csv\M30_002_...csv` e `csv\M30_003_...csv` (righe SETUP con `rischio_soldi` 0.00).

| caso | piazzati (ultimo riarmo prima del weekend) | prima barra dopo | riempimento (ordine, limite -> eseguito) | il resto | esito CSV GEOM / PIU |
|---|---|---|---|---|---|
| A 2024.09.15 ST25 | ven 09.13 21:30, ord. 1966-1968 (+ ST30 1969-1971) | dom 23:00:00 guardia ST25 e ST30 | **dom 23:10:00** ord. 1966 (2578.00 -> 2577.94) | ST30 cancellati **23:10:01**; 1967/1968 cancellati lun 03:12:31 (X10) | +416,54 / +72,44 EUR a 0,00 R |
| B 2024.10.13 ST25 | ven 10.11 21:30, ord. 2466-2468 | dom 23:00:00 guardia ST25 | **dom 23:10:00** ord. 2466 (2653.85 -> 2649.95) | 2467 riempito 23:10:38; 2468 cancellato lun 01:00 (flip) | +1.579,41 / +451,24 |
| C 2024.10.13 ST30 | ven 10.11 21:30, ord. 2469-2471 | dom 23:00:00 guardia ST30 | **dom 23:10:00** ord. 2469 (2652.09 -> 2649.95) | 2470 riempito 23:15:34; 2471 cancellato 01:30 (flip); **SEMAFORO SFORATO** 23:10:00 | +1.424,69 / +438,38 |
| D 2025.05.25 ST30 | ven 05.23 20:30, ord. 9736-9738 | dom 23:05:00 guardia ST30 | **dom 23:10:01** ord. 9736 (3347.88 -> 3347.87) | 9737 riempito 23:23:32; 9738 cancellato lun 01:00 (flip) | **-2.091,48 a SL** / +185,93 |

Tutti FATTO dai `.htm` (tabelle Ordini e Deal) e dai log; i numeri d'ordine sono quelli del report GEOM. R stimato (INFERITO, rischio
ricostruito = 0,25% del saldo del deal precedente, come `RischioSoldi` EA r.1833 con `InpMoltConfluenza`=1): GEOM A +0,17, B +0,63,
C +0,57, D -0,83 (somma +0,53 R su n=236); P_003 +0,32.

**Contro-esempio "perche' su H1 oro zero adozioni" (FATTO, `.htm` della P_001):** alle stesse riaperture i pendenti H1 erano piu' lontani.
2024.09.15: il BUY LIMIT H1 piu' alto era 2572.50 (< 2577.94 eseguito su M30) -> cancellato 23:10:01; 2025.05.25: il piu' alto era 3333.04
(< 3347.87) -> cancellato 23:10:06. I pendenti H1 venivano da un riarmo **mezz'ora prima** (21:00 contro 21:30; 20:00 contro 20:30, FATTO):
il TF conta **attraverso l'ora dell'ultimo riarmo**, che decide quanto il pendente e' vicino al prezzo di riapertura (INFERITO, due weekend).

### 3.3 Il ritentativo poteva vincere? Caso per caso (classe 1331)

| evento | riempimento | il dato che lo decide | ritentativo piu' fitto avrebbe vinto? |
|---|---|---|---|
| P_003 2025.03.02 | 23:05:00, limite 1.04032 -> 1.04033 | P_004, stessi tick: cancellazione riuscita **alle 23:05:00** -> 23:05:00 era operabile e il riempimento e' arrivato prima del ritentativo | **No** (INFERITO forte) |
| A 2024.09.15 | 23:10:00, 2578.00 -> 2577.94 | le domeniche oro del 2024 sbloccano alle **23:10:00/23:10:01** (P_001 14/07, 28/07, 18/08 alle 23:10:00; 15/09 e 22/09 alle 23:10:01): a 23:10:00 si poteva cancellare e al ritentativo precedente no. **Premessa non verificabile qui: la sessione riapre esattamente alle 23:10:00** (se avesse riaperto qualche secondo prima, un ritentativo piu' fitto avrebbe potuto arrivare prima del riempimento) | **No** (INFERITO con premessa dichiarata; con la premessa, stessa lettura della P_003) |
| B e C 2024.10.13 | 23:10:00, salto di 2-4 USD sotto i limiti | come A, con la stessa premessa | **No** (INFERITO con premessa dichiarata) |
| **D 2025.05.25** (il piu' costoso) | **23:10:01**, 3347.88 -> 3347.87 (0,01) | la pausa di 10 s (EA r.387) conta dall'ultimo ritentativo FALLITO (`gOrfTent[L]`, scritto solo a EA r.2091, azzerato in `OnInit` r.1327): la guardia (r.1611) e r.1598 non la fanno partire. Nello stesso lotto la M30_001 (come la P_001) cancella solo alle **23:10:06** pur con il tick delle 23:10:01 (il riempimento della M30_002, stessi tick XAUUSD): in quel secondo la pausa era attiva, e l'ultimo ritentativo fallito cade a circa 23:09:52-56 (INFERITO: servono tick in quei secondi). Se fra quel ritentativo e le 23:10:01 c'era un tick operabile (in pratica alle 23:10:00), un ritentativo a ogni tick l'avrebbe cancellato | **NON DETERMINABILE** (mancano i tick 23:09:50-23:10:01 e l'orario di sessione) |

Sulla differenza fra le domeniche oro 2024 (sblocco 23:10:00/:01) e 2025 (23:10:05/:06): l'origine della pausa e' l'**ultimo ritentativo
fallito**, non la guardia. Con tick fitti i ritentativi cadono ogni ~10 s a partire dal primo tick in cui la linea e' senza setup, e la
"fase" con cui arrivano alla riapertura decide se il primo ritentativo utile cade a 23:10:00 o qualche secondo dopo (INFERITO: la fase
dipende dai tick, che non abbiamo). Sostenuto il 25/05/2025 (M30_001 23:10:06 con tick operabile alle 23:10:01) e il 15/09/2024
(M30_002: ST25 riempito 23:10:00, ST30 orfano dallo stesso tick cancellato 23:10:01); il 13/04 e il 15/06/2025 (cancellazioni 23:10:05),
il 22/09/2024 (23:10:01) e le domeniche 2024 a 23:10:00 (14/07, 28/07, 18/08) sono compatibili anche con "il primo tick arriva in quel
secondo".

### 3.4 Cosa NON e' osservabile nei dati che abbiamo
1. Il **retcode** e la descrizione di ogni `OrderDelete` fallito (EA r.1962; righe CTrade scartate dal driver r.507).
2. **Quanti** ritentativi falliti ci sono stati in ogni episodio e a che ora (EA r.2090: ramo falso muto).
3. Lo **stato della sessione** al momento del tentativo (l'EA non chiede mai `SymbolInfoSessionTrade` ne' `SYMBOL_TRADE_MODE`).
4. I **tick** intorno alle riaperture e l'**orario di sessione** del simbolo (in particolare XAUUSD 2025.05.25 23:09:50-23:10:01,
   decisivi per il caso D).
5. L'ordine interno del tester sullo stesso tick (riempimento contro `OnTick`): solo dedotto dal confronto P_003/P_004.
6. I riarmi di ogni barra (muti dopo il primo, EA r.1669/r.1673) e le cancellazioni riuscite a r.1598 (motivo vuoto): la catena "ordine
   piazzato alla barra k, cancellato alla barra k+1" si vede **solo** nei `.htm`.
7. L'origine delle finestre di chiusura (specifica, buchi dei tick): nessun file la riporta (par. 1 punto 5).
8. **NON COPERTO**: che la lettura dei tick (caso D) sia di sola lettura non e' dimostrato: i file tick sono binari e serve uno script
   dentro MT5. La riga che lo fara' dovra' passare dal cancello.

---

## 4. Risposte alle due domande

### (a) La causa del mancato annullamento e' dimostrabile dai dati che abbiamo?
**No.** E' **INFERITA forte**, non dimostrata: tre fatti indipendenti puntano alla sessione chiusa (par. 1 punti 2, 3, 6), ma il retcode
dell'`OrderDelete` non e' scritto in nessun file. Per renderla dimostrabile basta UNA di queste:
- **senza toccare l'EA** -- CTrade scrive i fallimenti con il motivo fra parentesi quadre: formato visto in repo in
  `report/caccia_ticket/caccia_ticket_VMI3047753.txt` (13 righe `CTrade::OrderSend: ...`: 12 con `[invalid stops]` e 1 con `[invalid request]`, un `cancel #3110713` a r.159;
  piu', fuori dalle 13, la riga del giornale `Trades` r.144 `failed cancel order #3110713 ... [Invalid request]` sullo stesso ticket;
  sono log del **terminale vivo**, non dell'agente del tester). Per l'opzione A conta che una cancellazione fallita lascia una **COPPIA**
  di righe (CTrade dell'EA + giornale `Trades`), non due righe CTrade. Nei log grezzi dell'agente del tester le righe equivalenti dei
  nostri casi (`cancel order #<ticket> ...`) non passano dal driver (r.507). Cercarle per ticket: P_003 **4603, 4604, 4605**
  (2025.02.28 22:00); M30_002 **1966-1971** (2024.09.15 23:00-23:10), **2466-2471** (2024.10.13), **9736-9738** (2025.05.25). Che CTrade
  scriva i fallimenti anche nel tester e' INFERITO (stesso default, passo 0), e i log dell'agente possono essere gia' stati sovrascritti:
  e' la via piu' corta, non una via sicura;
- **logging minimo nell'EA** (opzione B): sul ramo falso di `OrderDelete` -> ticket, `ResultRetcode`, `ResultRetcodeDescription`,
  `TimeCurrent`, `SYMBOL_TRADE_MODE` e "dentro/fuori sessione" da `SymbolInfoSessionTrade`; a ogni adozione -> ticket, `ORDER_TIME_SETUP`
  dell'ordine d'origine (eta' del pendente), prezzo limite ed eseguito.

### (b) Le ipotesi contro i dati

| ipotesi | verdetto | il fatto che decide | fonte |
|---|---|---|---|
| **mercato chiuso / finestra di pausa** | **COMPATIBILE, sostenuta** (non dimostrata: manca il retcode) | i 450 episodi con guardia iniziano in pochi orari e finiscono ai minuti di riapertura; 10018 sugli invii negli stessi orari e, il 2024.07.30 22:00:00, nello stesso secondo; i riempimenti alla riapertura | log delle 7 passate (appendice); P_003 log r.245-252; `.htm` |
| **ordine "in transito"** | **ESCLUSA** | dopo la cancellazione fallita i pendenti restano sul conto da 4 minuti (EURUSD 22:01 -> 22:05, mar 2024.10.01 e lun 2024.10.14) a 51 h 10 min (oro ven 22:00 -> lun 01:10, 15/11, 22/11 e 20/12/2024) e poi vengono cancellati o riempiti come ordini normali (episodi con guardia: minimo 4 min in 5 episodi P_003/P_004/M30_004, massimo 51 h 10 min in 14 episodi P_001/P_002/M30_002/M30_003); e gli invii sono sincroni (FATTO di codice, passo 0) | `.htm` Ordini (es. 4603: 02.28 21:00 -> 03.02 23:05 `filled`); EA r.1335-1337 |
| **stato MODIFY / freeze level** | **ESCLUSA come causa generale** (il valore di freeze del simbolo non e' nei dati) | il freeze dipende dalla distanza dal prezzo a qualunque ora; qui gli inizi sono SOLO agli orari di chiusura e alla riapertura la cancellazione riesce sugli stessi ordini, agli stessi prezzi | distribuzione oraria (par. 1 punto 2) |
| **riempimento fra tentativo e conferma** | **ESCLUSA** (anche come lettura della riga `ADOTTATO ... (riempimento durante una cancellazione?)`) | la guardia vede **0 posizioni** dopo il tentativo; il riempimento arriva da 5 min 01 s (caso D: guardia dom 23:05:00, riempimento 23:10:01; M30_002 log r.3210-3211) a 49 h 05 min (P_003) dopo, alla riapertura | log (guardia) + `.htm` Deal |

---

## 5. Perche' la v1.13 NON e' stata scritta, e le opzioni

Il compito chiedeva la v1.13 solo se l'intervento (1) logging + (2) "ritentare finche' riesce" fosse minimo e senza ambiguita'. Non lo e':
- **(2) c'e' gia'** (EA r.2084-2091, cancello del 07/10 seconda e terza lettura) e risolve **442 orfani su 451**;
- dei 5 eventi adottati, **4 non li risolve** un ritentativo piu' fitto (riempimento al primo tick operabile, par. 3.3: P_003 INFERITO forte, A/B/C INFERITO con la premessa
  dichiarata); **sul quinto, il
  caso D (-2.091,48 EUR), e' aperto**: la pausa di 10 s potrebbe essere la causa, i dati non bastano a dirlo;
- per togliere i 4 eventi servono interventi **prima** della chiusura, e ce ne sono di due tipi: quelli che **accorciano la vita
  dell'ordine solo dell'anticipo scelto prima della chiusura, senza cambiare quando e se la scala si arma** (C1) e una **regola nuova**
  (C2). Non e' dimostrato che serva per forza una regola nuova.

Il **solo** logging (1) sarebbe minimo e senza ambiguita', ma non risolve: e' l'opzione B, una delle scelte di Claudio e della collega.
**Le opzioni non sono scelte qui: decidono Claudio e la collega.**

| opzione | cosa | che cosa toglie | costo | rischi |
|---|---|---|---|---|
| **A. Prova senza EA** | cercare nei log grezzi dell'agente del tester (PC di backtest) le righe CTrade dei ticket del par. 4(a). Riga di **sola lettura**, dal cancello come ogni riga | niente (prova la causa) | minuti; nessuna compilazione, nessun nuovo PASS dell'EA | i log possono essere stati sovrascritti; che CTrade scriva i fallimenti nel tester e' INFERITO: se le righe mancano **non** e' una smentita |
| **B. v1.13 solo diagnostica** | input nuovo `InpLogCancellazioni` (default false = v1.12 identica, giornale compreso): log del ramo falso di `OrderDelete` (r.1962) e log ricco dell'adozione (r.2077). Nessun'altra riga | niente (prova la causa: rende FATTO il retcode). **NON** rende determinabile il caso D: con la pausa invariata, alle 23:10:00 non parte nessun ritentativo da registrare | compilazione + 2 passate (P_003 H1 e M30_002) con `true` + A0 con default sui due controlli | basso; a `true` il giornale cambia (piu' righe): la lettura del merito va fatta con il default |
| **R. Ritentativo senza pausa nei secondi della riapertura** | input nuovo, default OFF: dopo una cancellazione fallita, ritentare a **ogni tick** (non ogni 10 s) finche' non riesce o finche' passa un tempo massimo | **forse il caso D** (NON DETERMINABILE oggi); non i 4 eventi riempiti al primo tick operabile (con la premessa del par. 3.3) | compilazione + rifare le gambe oro | e' la ragione per cui la terza lettura del 07/10 mise la pausa (classe 1165): con un rifiuto permanente (AutoTrading spento, freeze) parte una richiesta a ogni tick; serve un tetto. Dal vivo l'utilita' e' INFERITA: il riempimento lo fa il server, l'EA non puo' competere |
| **C1. Niente pendenti vivi attraverso una chiusura (accorcia la vita dell'ordine solo dell'anticipo scelto prima della chiusura; non cambia quando e se la scala si arma)** | input nuovo, default OFF. Due varianti: **(a)** cancellare la scala all'**ultimo tick operabile prima della chiusura** (orari da `SymbolInfoSessionTrade`); **(b)** **scadenza lato server** sugli ordini della scala (oggi r.1669 passa `0`; la CFG dei log dice `Scadenza server pendenti = si`; r.1871 la usa solo con `scad>0`) | i 4 eventi riempiti al primo tick operabile **e** il caso D, **se** l'ordine muore prima della chiusura | i riempimenti **persi** fra la cancellazione anticipata (o la scadenza) e la chiusura (**IPOTESI: secondi o minuti, da misurare**); togliere l'esposizione attraverso la chiusura e' il beneficio, non il costo. Piu' compilazione + rifare tutte le gambe (tocca ogni chiusura giornaliera) | (a): le sessioni del tester possono non coincidere con il vivo, e sull'oro le finestre cambiano con la stagione (par. 1 punto 5); (b): che tester e server facciano **scadere** un ordine a mercato chiuso e' **IPOTESI** (stesso dubbio della cancellazione); sessioni a cavallo della mezzanotte e piu' sessioni al giorno da collaudare |
| **C2. Niente riarmo prima della chiusura** | input nuovo, default OFF: se la sessione chiude prima della barra successiva la scala **non si arma** | i 4 eventi e il caso D | progetto + cancello + compilazione + tutte le gambe | e' una **regola nuova**, non negli audio: va chiesta a Claudio/collega (lei terrebbe limit aperti a cavallo di una chiusura?). Toglie setup legittimi dell'ultima barra |
| **D. v1.13 "contabilita' del setup"** | se la cancellazione fallisce il setup **non** si azzera: un riempimento successivo e' registrato come il setup ORIGINALE (rischio, tocco, SL veri, etichetta "riempito dopo cancellazione fallita"); a scelta, all'adozione si cancellano subito i residui | niente sul conto; la riga ha R vero (e i residui, con la seconda parte) | progetto + cancello + compilazione + rifare le gambe | non minimo: tocca l'ordine fra `Sincronizza` (passo 1) e `OnNewBar`, cioe' la sequenza dei ritentativi; la seconda parte cambia i riempimenti (P_003 O2/O3, M30 13/10 O2) |
| **E. Tolleranza nel lettore** | nessuna modifica all'EA; regole del lettore congelate PRIMA di rileggere (sotto) | niente (le toglie dalla misura) | solo lettore + cancello | **post-hoc**: le adozioni sono gia' viste, quindi le soglie scritte oggi sono scelte guardando i numeri (regola di casa: i criteri si cambiano prima dei numeri, non dopo). E' **INFERITO**, non misurato, che dal vivo esista lo stesso meccanismo (pendenti dell'ultimo riarmo prima della chiusura + salto alla riapertura): dal vivo il riempimento lo fa il server, il 10018 sulle **cancellazioni** dal vivo (BCM/FTMO) non e' misurato e le sessioni del tester possono differire |

Nota sulle colonne "dal vivo": tutto cio' che questa tabella dice del conto vivo e' **INFERITO** dal tester, per le stesse tre ragioni
della riga E.

**Regole che dovrebbero essere congelate PRIMA di rimisurare, se si sceglie E** (proposta, non decisione; i numeri li fissa il cancello):
1. **Definizione**: riga adottata = riga `SETUP` con `rischio_soldi` 0.00 **e** una riga `ADOTTATO <linea>` nel giornale allo stesso minuto.
   Niente altro.
2. **Esclusione**: fuori da n, PF_R, DD_R, f, mediana di durata; contate a parte: n adottate, soldi adottati (EUR), R stimato
   (= soldi / (0,25% x saldo al riempimento), DIAGNOSTICO).
3. **Metriche in EUR** del report del tester (DD in EUR): restano **con** le adozioni (sono successe) e lo si scrive.
4. **Soglia di leggibilita'** (n adottate / n, somma |R stimato|, SEMAFORO SFORATO) da scrivere **prima** del lotto successivo e da
   applicare **solo** ai lotti nuovi: applicarla a M30_002/003 per "salvarle" sarebbe la soglia scelta dopo il numero (oggi 4/236 = 1,7%
   e 4/201 = 2,0%: una soglia al 2% scritta oggi le farebbe passare **per costruzione**).

**Il passo che costa meno:** A (minuti, sola lettura, nessuna modifica all'EA; puo' trasformare l'INFERITO in FATTO). Il caso D si
decide solo con i tick XAUUSD 2025.05.25 23:09:50-23:10:01 e l'orario di sessione (lettura che deve passare dal cancello: che sia di sola
lettura non e' dimostrato, par. 3.4 punto 8), oppure con una passata con R. B, R, C1, C2, D, E sono scelte di Claudio e della collega. Le due passate oro M30 restano **illeggibili** finche' la decisione non
e' presa: nessuna di queste opzioni le rilegge "gratis".

---

## 6. Cosa il cancello deve ricontrollare
1. I conteggi del par. 1: 450 episodi con guardia (441 + 9) con orari di inizio e fine (script in appendice); 442 righe di ritentativo
   riuscito, una sola senza guardia prima (M30_004 2024.07.18 22:05:13 E200). Includendo M30_001 (tick identici alla P_001): 514 episodi.
2. Le righe delle tabelle 3.1, 3.2 e 3.3 contro le tabelle **Ordini** e **Deal** dei `.htm` (UTF-16) dei due zip, ticket per ticket, e
   contro i log (P_004 2025.03.02 23:05:00; domeniche oro 2024 a 23:10:00/01 e 2025 a 23:10:05/06).
3. La tabella stagionale dell'oro (par. 1 punto 5) su P_001 e M30_002, e i 10 episodi 00:00 -> 00:05 di lug-ott nelle sole passate M30
   oro (M30_002 e M30_003, stessi 10 episodi in 5 date: 3 mercoledi', 2 venerdi'; P_001, P_002, M30_001: zero).
4. La lettura del codice: `gOrfTent` (grep: dichiarata r.966, azzerata r.1327, scritta SOLO r.2091, letta r.2090); EA r.387, 1335-1337, 1591-1593, 1598, 1611-1612, 1669, 1871, 1953-1971 (`ResetSetup` incondizionato a r.1970),
   2072-2092 contro 2105-2116, 2126-2127, 2245; e che i rami siano identici in v1.11 e v1.12
   (`git diff 4db1af18 d1aef381 -- mql5/Experts/EA_NatCla.mq5`).
5. Che nessuna frase dica piu' "nessun ritentativo poteva vincere" per tutti i casi, ne' "l'unico intervento e' una regola nuova", ne' che la pausa parta dalla guardia, ne' che
   B renda determinabile il caso D.
6. Che il par. 5 non contenga una soglia scelta sui numeri di M30_002/003 (opzione E, punto 4) e che non scelga un'opzione.
7. Che **nessun codice EA** sia stato scritto: `git show --stat` del commit deve mostrare solo questo file.
8. Da decidere (Claudio e la collega, non questo report): A; come decidere il caso D (tick + orario di sessione, con la riga che passa
   dal cancello, oppure una passata con R); la scelta fra B, R, C1, C2, D, E; le soglie di E.

---

## Appendice -- lo script degli episodi (Python 3, sola lettura; argomenti = i `log\*.txt` estratti dagli zip)
```python
import re,sys,datetime as dt,collections
ini=collections.Counter(); fin=collections.Counter(); esito=collections.Counter()
for f in sys.argv[1:]:
    pend={}
    for ln in open(f,encoding='utf-8',errors='replace'):
        m=re.match(r'(\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d)\s+\[NatCla\] (.*)',ln.rstrip())
        if not m: continue
        t=dt.datetime.strptime(m.group(1),'%Y.%m.%d %H:%M:%S'); msg=m.group(2)
        g=('Dom' if t.weekday()==6 else 'Lun-Ven')+' '+t.strftime('%H:%M')
        x=re.match(r'(\S+): guardia anti-duplicato',msg)
        if x and x.group(1) not in pend: pend[x.group(1)]=t; ini[g]+=1; continue
        y=re.match(r'(\S+): cancellati \d+ pendenti \(pendenti senza setup',msg)
        z=re.match(r'ADOTTATO (\S+):',msg)
        for w,e in ((y,'CANCELLATI'),(z,'ADOTTATO')):
            if w and w.group(1) in pend: pend.pop(w.group(1)); fin[g]+=1; esito[e]+=1
print(sum(ini.values()),dict(esito)); print(sorted(ini.items())); print(sorted(fin.items()))
```
Esito sulle 7 passate distinte: `450 {'CANCELLATI': 441, 'ADOTTATO': 9}`; inizi: lun-ven 22:00 (290), 22:01 (9), 23:00 (56), 00:00 (32);
dom 22:00 (1), 22:01 (11), 22:05 (7), 23:00 (28), 23:05 (16). Fine: lun-ven 22:05 (157), 23:05 (56), 00:05 (99), 00:06 (8), 00:00 (2),
01:10 (58); dom 22:10 (19), 23:05 (7), 23:10 (44). Nello script "Lun-Ven" vuol dire "non domenica": come insieme di orari d'INIZIO
va bene; delle 157 fini alle 22:05 (EURUSD, P_003/P_004/M30_004, contate per linea) nessuna cade di venerdi' (lun 37, mar 42, mer 39,
gio 39). Gli episodi EURUSD iniziati il venerdi' alle 22:00 sono 17 e finiscono tutti alla riapertura (dom 23:05 x7, lun 00:00 x2,
lun 00:06 x8).
Lo script conta solo gli episodi **aperti da una guardia**: le righe `cancellati N pendenti (pendenti senza setup ...)` sono **442**
(64 / 64 / 54 / 70 / 63 / 58 / 69), una in piu' dei 441 perche' l'orfano M30_004 del 2024.07.18 non ha avuto una guardia prima.
