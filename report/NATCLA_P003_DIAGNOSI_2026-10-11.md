# NatCla -- il caso P_003: diagnosi e opzioni (11/10/2026)

**Stato: NON passato dal cancello.** Solo diagnosi. **La v1.13 NON e' stata scritta** (motivo al par. 4): nessun file `.mq5` toccato
o aggiunto. L'EA in repo resta `mql5/Experts/EA_NatCla.mq5` v1.12, SHA256 `729bb4289b01...` (ricontrollato su `origin/lavoro` 92023408).

**Fonti (tutte in repo, nessun dato nuovo):**
- **P** = pilota H1 `backtest_pipeline/risultati_archivio/NATCLA_F1_P_20261011/NATCLA_F1_P.zip` (EA **v1.11**: riga `AVVIO v1.11` nei log;
  i rami usati qui sono identici in v1.12: `git diff 4db1af18 d1aef381` tocca solo NC_VER, l'input `InpAmmettiTFSottoH1`, `Risolvi`, il
  magic M30 e `StampaConfigurazione`).
- **M** = lotto M30 `backtest_pipeline/risultati_archivio/NATCLA_F1_M30_20261011/NATCLA_F1_M30.zip` (EA v1.12).
- Dentro ogni zip: `log\<passata>.txt` (SOLO righe `[NatCla]`/`[NATCLA-IMBUTO]` + poche righe del Tester: regex `$reRiga`,
  `backtest_pipeline/righe/NATCLA_F1_M30_PASSATE.ps1` r.507, uguale in `NATCLA_F1_PASSATE.ps1` r.483), `csv\`, `trades\`, e i **report
  `.htm` del tester** con le tabelle **Ordini** (ora di piazzamento, ora di fine, stato `canceled`/`filled`) e **Deal**. I report `.htm`
  sono la fonte che finora non era stata letta per questo caso: dicono **quando** ogni pendente e' nato e **quando** e' morto.
- Codice: `mql5/Experts/EA_NatCla.mq5` v1.12, righe citate come "EA r.N".

Etichette: **FATTO** = letto in un file (citato); **INFERITO** = dedotto da fatti + comportamento noto della piattaforma, non letto;
**IPOTESI** = compatibile, non dedotta.

---

## 1. La diagnosi in 10 righe

1. **FATTO** -- In tutte e 7 le passate distinte (P_001..P_004, M30_002..M30_004; M30_001 ha gli stessi tick della P_001) ci sono
   **450 episodi** "guardia anti-duplicato": **441 finiscono con il ritentativo riuscito** (riga `cancellati N pendenti (pendenti senza
   setup in memoria ...)`), **9 finiscono in ADOZIONE** (1 nella P_003, 4 nella M30_002, 4 nella M30_003). Nessun episodio resta aperto.
2. **FATTO** -- I 450 episodi **cominciano tutti** in pochi orari fissi (lun-ven 22:00/22:01/23:00/00:00; domenica alla prima barra:
   22:00-22:05 o 23:00-23:05) e **finiscono tutti** in pochi minuti fissi (22:05, 23:05, 00:00/00:05/00:06, 01:10; domenica
   22:10/23:05/23:10). Conteggi esatti in appendice.
3. **FATTO** -- Negli **stessi orari** gli INVII di ordini nuovi falliscono con `retcode 10018 market closed`; il 2024.07.30 22:00:00
   (P_003) allo **stesso secondo** ST25 e ST30 hanno la guardia e i tre ordini ST35 hanno 10018.
4. **INFERITO (forte)** -- La cancellazione fallisce perche' la barra si apre in una **finestra di sessione chiusa** (ci sono quotazioni,
   non si opera). Non e' DIMOSTRATO: il retcode di `OrderDelete` non c'e' in nessun file (EA r.1962 non lo scrive; la riga d'errore
   di CTrade non ha il prefisso `[NatCla]` e il driver la scarta, r.507).
5. **FATTO** -- Le finestre stanno **ferme in ora server** prima e dopo il cambio d'orologio BCM sul forex (EURUSD: 22:00 -> 22:05 sia a
   luglio 2024 sia a gennaio-febbraio 2025). **INFERITO**: il tester applica gli orari di sessione della specifica del simbolo, non la storia.
6. **FATTO (tabella Ordini dei `.htm`)** -- Nei 9 casi adottati il pendente era stato piazzato all'**ultima barra in cui l'EA ha
   riarmato prima del weekend** (venerdi 21:00 H1, 21:30 M30, 20:30 M30) e si e' riempito **alla riapertura** (dom 23:05:00, 23:10:00,
   23:10:00, 23:10:00, 23:10:01: gli stessi minuti in cui, altrove, i ritentativi riescono), eseguito **al prezzo del pendente o meglio**
   (il prezzo di riapertura era gia' oltre: salto del weekend, nella P_003 di 0,1 pip).
7. **FATTO (codice + `.htm`)** -- Il ritentativo che il compito propone **esiste gia' nella v1.12** (Sincronizza EA r.2084-2091, ogni 10 s
   per linea) e ha risolto 441 casi su 450. Nella P_003 era **libero** (ultimo tentativo venerdi) e alla prima quotazione della settimana
   il riempimento e' arrivato **lo stesso**: nessuna politica di ritentativo puo' cancellare un ordine a mercato chiuso, e alla riapertura
   il pendente vecchio puo' riempirsi **prima** che l'EA agisca.
8. **FATTO (codice)** -- Dopo l'adozione restano vivi **gli altri pendenti vecchi** (X10 EA r.2126 scatta solo quando una posizione ESCE):
   P_003 riempie anche O2 e O3 un'ora dopo (`riempiti 3`); il 13/10/2024 su M30 due linee adottate insieme (SEMAFORO SFORATO, EA r.2078-2082).
9. **FATTO** -- Il rischio di questi riempimenti e' vero e limitato dallo SL originale dell'ordine (sta sul server): M30_002 il 2025.05.25
   chiude a SL con -2.091,48 EUR, scritto nel CSV a **0,00 R** perche' `rischio_soldi` dell'adottato resta 0 (ResetSetup EA r.1990).
10. **Conclusione** -- L'intervento (1)+(2) chiesto non e' minimo-e-risolutivo: (2) c'e' gia' e non puo' vincere la corsa. **La v1.13 non
    si scrive**; servono una decisione (par. 5) e, prima, la prova del retcode che costa zero righe di EA (opzione A).

---

## 2. Il meccanismo, passo per passo (codice v1.12)

| passo | dove | cosa succede | etichetta |
|---|---|---|---|
| 1 | OnTick EA r.1385-1391 | a ogni tick: prima `Sincronizza()`, poi, se e' nata una barra, `OnNewBar()` | FATTO (codice) |
| 2 | ArmaScala EA r.1669, r.1673 | a ogni barra la scala viene **riprezzata** (cancella e riarma); il log `ORDINE`/`SETUP armato` esce solo al primo armamento (`gArmatoPrima`), i riarmi sono **muti** | FATTO (codice) |
| 3 | ValutaScala EA r.1598 | alla barra dopo, `CancellaSetupNonRiempito(L,"")`: motivo vuoto -> nessun log nemmeno se riesce (EA r.1964) | FATTO (codice) |
| 4 | CancellaOrdiniLinea EA r.1962 | `if(gTrade.OrderDelete(t)) n++;` -- **nessun Log sul ramo falso** | FATTO (codice) |
| 5 | CancellaSetupNonRiempito EA r.1970 | `ResetSetup(L)` **sempre**, anche se la cancellazione e' fallita: la memoria del setup (rischio, tocco, SL) si perde | FATTO (codice) |
| 6 | ValutaScala EA r.1611-1612 | `ContaLinea` trova i pendenti ancora vivi -> riga `guardia anti-duplicato (0 posizioni, 3 pendenti ...)` e niente riarmo | FATTO (codice + log) |
| 7 | Sincronizza EA r.2090-2091 | linea senza setup, 0 posizioni, pendenti vivi -> ritenta `CancellaOrdiniLinea` ogni `NC_ORF_PAUSA_SEC`=10 s (EA r.387); se riesce: riga `cancellati N pendenti (pendenti senza setup ...)` | FATTO (codice + log) |
| 8a | -- | alla riapertura il ritentativo riesce: fine dell'episodio (441 casi su 450) | FATTO (log) |
| 8b | Sincronizza EA r.2074-2077, AdottaLinea r.2036-2054 | se un pendente vecchio si riempie prima: `ADOTTATO`, setup con `adottato=true`, `rischio_soldi`=0, `nPosId`=posizioni del momento | FATTO (codice + log) |
| 9 | Sincronizza EA r.2126-2127 | i pendenti residui si cancellano solo alla prima USCITA (`np<nPosId`): fino ad allora possono riempirsi | FATTO (codice + `.htm`) |
| 10 | ChiudiSetup EA r.2241, r.2245 | R = 0 (rischio 0) ed etichetta fissa `(setup adottato dopo un riavvio)` anche senza riavvio | FATTO (codice + log) |

Al passo 6 una cancellazione e' stata **tentata davvero** sullo stesso tick: o da `Sincronizza` (passo 1, se la linea era gia' senza
setup) o da EA r.1598 (se il setup era attivo: nei 9 casi lo era, gli ordini erano stati piazzati alla barra prima e non riempiti,
tabella Ordini). Dopo il tentativo gli ordini erano ancora sul conto -> l'`OrderDelete` **non li ha tolti** (FATTO). Che abbia restituito
`false` con 10018 e' INFERITO: nel tester `OrderSend` e' sincrono, e 10018 e' quello che lo stesso secondo restituisce agli invii.

---

## 3. Le 9 adozioni, ricostruite (orario server = orario del tester)

### 3.1 P_003 -- EURUSD AUDIO H1 SHORT LINEA (pilota, v1.11)
Fonti: `log\P_003_...txt` righe 1823-1831; `report\P_003_...htm` tabelle Ordini/Deal; `csv\P_003_...csv` riga 125.

| quando | barra | azione | fonte | etichetta |
|---|---|---|---|---|
| ven 2025.02.28 21:00:00 | H1 21:00 | ST25 SHORT armato: ordini **4603/4604/4605** SELL LIMIT 1.04032/1.04082/1.04132, SL 1.04385, TP 1.03982 | log + `.htm` Ordini | FATTO |
| ven 22:00:00 | H1 22:00 | tentata la cancellazione (EA r.1598) -> `ST25: guardia anti-duplicato (0 posizioni, 3 pendenti ...)` | log r.1829 | FATTO (riga) / INFERITO (esito `false` dell'OrderDelete) |
| ven 22:00 -> dom 23:05 | -- | nessuna riga EA; 4603-4605 restano vivi (nessuna ora di cancellazione nei `.htm`) | `.htm` | FATTO |
| ven 22:00 -> dom 23:05 | -- | ritentativi ogni 10 s sui tick che arrivano (se arrivano) e falliscono **in silenzio** | codice EA r.2090 | INFERITO (non osservabile) |
| **dom 2025.03.02 23:05:00** | H1 23:00 (prima della settimana) | 4603 **riempito** a 1.04033 (deal 308) -> `ADOTTATO ST25: 1 posizioni` | `.htm` Deal + log r.1830 | FATTO |
| lun 00:08:00 / 00:08:59 | -- | 4604 riempito a 1.04085, 4605 a 1.04132: i residui **non** erano stati cancellati | `.htm` | FATTO |
| lun 09:23:20 | -- | TP 1.03982 su tutte e tre: `USCITA ... 807.44 = 0.00 R, riempiti 3 ... (setup adottato dopo un riavvio)` | log r.1831, CSV | FATTO |

Attesa 22:00 ven -> 23:05 dom = **49 h 05 min** (FATTO). Il ritentativo alla prima quotazione di domenica era **libero** (ultimo tentativo
al piu' venerdi sera, pausa 10 s): eppure il primo evento EA della settimana e' l'adozione allo stesso secondo del riempimento (FATTO).
Che il tester controlli i pendenti **prima** di chiamare `OnTick` sullo stesso tick e' INFERITO (comportamento della piattaforma);
l'alternativa (ritentativo eseguito a 23:05:00 e fallito con la sessione ancora chiusa, riempimento concesso lo stesso) porta alla
**stessa** conclusione: il ritentativo non poteva vincere.

### 3.2 M30_002 / M30_003 -- XAUUSD AUDIO M30 LONG (GEOM / PIU, v1.12): le stesse 4 adozioni
Fonti: `log\M30_002_...txt`; `report\M30_002_...htm`; `csv\M30_002_...csv` e `csv\M30_003_...csv` (righe SETUP con `rischio_soldi` 0.00).

| caso | piazzati (ultimo riarmo prima del weekend) | prima barra dopo | riempimento (ordine, prezzo limite -> eseguito) | il resto | esito CSV GEOM / PIU |
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
(< 3347.87) -> cancellato 23:10:06. Stesso meccanismo, diverso solo il prezzo: la frequenza dell'adozione dipende da **quanto il pendente
vecchio e' vicino al prezzo di riapertura**, non dal TF in se'.

**Contro-esempio "il ritentativo basta" (FATTO):** il 2024.09.15 su M30 ST30 viene cancellato a 23:10:01 e ST25 si riempie a 23:10:00: un
secondo. Nella P_003 il ritentativo era libero e il riempimento e' arrivato al primo tick della settimana. In nessuno dei 9 casi un
ritentativo piu' fitto avrebbe avuto un tick a mercato aperto **prima** del riempimento (INFERITO dalla stessa riga temporale).

### 3.3 Cosa NON e' osservabile nei dati che abbiamo
1. Il **retcode** e la descrizione di ogni `OrderDelete` fallito (EA r.1962; righe CTrade scartate dal driver r.507).
2. **Quanti** ritentativi falliti ci sono stati in ogni episodio e a che ora (EA r.2090: ramo falso muto).
3. Lo **stato della sessione** al momento del tentativo (l'EA non chiede mai `SymbolInfoSessionTrade` ne' `SYMBOL_TRADE_MODE`).
4. Se, sullo stesso tick, il tester riempie il pendente **prima** o **dopo** `OnTick` (ordine interno della piattaforma).
5. I riarmi di ogni barra (muti dopo il primo, EA r.1669/r.1673) e le cancellazioni riuscite a r.1598 (motivo vuoto): la catena "ordine
   piazzato alla barra k, cancellato alla barra k+1" si vede **solo** nei `.htm`.
6. Gli orari di sessione della specifica BCM usata dal tester (nessun file li riporta).

---

## 4. Risposte alle due domande

### (a) La causa del mancato annullamento e' dimostrabile dai dati che abbiamo?
**No.** E' **INFERITA forte**, non dimostrata: tre fatti indipendenti puntano alla sessione chiusa (par. 1 punti 2, 3, 5), ma il retcode
dell'`OrderDelete` non e' scritto in nessun file. Per renderla dimostrabile basta UNA di queste:
- **senza toccare l'EA** -- le righe `CTrade::OrderSend: cancel order #<ticket> ... [<motivo>]` (formato visto in repo:
  `report/caccia_ticket/caccia_ticket_DESKTOP-H4D7CAJ.txt`, dove CTrade stampa `[invalid price]`/`[invalid stops]`) stanno nei log
  dell'agente del tester e il driver le scarta (r.507). Cercare nei log grezzi i ticket dei casi: P_003 **4603, 4604, 4605**
  (2025.02.28 22:00); M30_002 **1966-1971** (2024.09.15 23:00-23:10), **2466-2471** (2024.10.13), **9736-9738** (2025.05.25).
  Che CTrade stampi i fallimenti anche nel tester e' INFERITO (livello di log di default), e i log dell'agente possono essere gia' stati
  sovrascritti: e' la via piu' corta, non una via sicura;
- **logging minimo nell'EA** (opzione B): sul ramo falso di `OrderDelete` -> ticket, `ResultRetcode`, `ResultRetcodeDescription`,
  `TimeCurrent`, `SYMBOL_TRADE_MODE` e "dentro/fuori sessione" da `SymbolInfoSessionTrade`; a ogni adozione -> ticket, `ORDER_TIME_SETUP`
  dell'ordine d'origine (eta' del pendente), prezzo limite ed eseguito.

### (b) Le ipotesi contro i dati

| ipotesi | verdetto | il fatto che decide | fonte |
|---|---|---|---|
| **mercato chiuso / finestra di pausa** | **COMPATIBILE, sostenuta** (non dimostrata: manca il retcode) | 450/450 episodi iniziano in pochi orari fissi e finiscono ai minuti di riapertura; 10018 sugli invii negli stessi orari e, il 2024.07.30 22:00:00, nello stesso secondo; finestre ferme in ora server attraverso il cambio d'orologio; i 9 riempimenti cadono al secondo della riapertura | log delle 7 passate (script in appendice); P_003 log r.245-252; `.htm` |
| **ordine "in transito"** | **ESCLUSA** | i pendenti restano sul conto da 5 minuti a 49 h e poi vengono cancellati o riempiti come ordini normali; un transito dura millisecondi (e nel tester `OrderSend` e' sincrono, INFERITO) | `.htm` Ordini (es. 4603: 02.28 21:00 -> 03.02 23:05 `filled`) |
| **stato MODIFY / freeze level** | **ESCLUSA come causa generale** (il valore di freeze del simbolo non e' nei dati) | il freeze dipende dalla distanza dal prezzo a qualunque ora; qui gli inizi sono SOLO agli orari di chiusura e alla riapertura la cancellazione riesce sugli stessi ordini, agli stessi prezzi | distribuzione oraria (par. 1 punto 2) |
| **riempimento fra tentativo e conferma** | **ESCLUSA** (anche come lettura della riga `ADOTTATO ... (riempimento durante una cancellazione?)`) | la guardia vede **0 posizioni** dopo il tentativo; il riempimento arriva da 10 minuti a 49 h dopo, alla riapertura | log (guardia) + `.htm` Deal |

---

## 5. Perche' la v1.13 NON e' stata scritta, e le opzioni

Il compito chiedeva la v1.13 solo se l'intervento (1) logging + (2) "ritentare finche' riesce" fosse minimo e senza ambiguita'. Non lo e':
- **(2) c'e' gia'** (EA r.2084-2091, cancello del 07/10 seconda e terza lettura) e funziona in **441 casi su 450**;
- i 9 casi residui sono una **corsa alla riapertura** che nessun ritentativo puo' vincere: a mercato chiuso la cancellazione non puo'
  riuscire per definizione, e al primo tick operabile il pendente vecchio si riempie (P_003: ritentativo libero, riempimento comunque);
- l'unico intervento che toglie le adozioni e' una **regola nuova** (non tenere pendenti attraverso una chiusura), cioe' un cambio di
  comportamento, non un ritocco: va deciso, non scritto di notte.

Il **solo** logging (1) sarebbe minimo e senza ambiguita', ma non risolve: e' l'opzione B qui sotto, da scegliere esplicitamente.

| opzione | cosa | risolve le adozioni? | costo | rischi |
|---|---|---|---|---|
| **A. Prova senza EA** | cercare nei log grezzi dell'agente del tester (PC di backtest) le righe CTrade dei ticket del par. 4(a). Riga di **sola lettura**, dal cancello come ogni riga | no (prova la causa) | minuti; nessuna compilazione, nessun nuovo PASS dell'EA | i log possono essere stati sovrascritti; che CTrade scriva i fallimenti nel tester e' INFERITO: se le righe mancano **non** e' una smentita |
| **B. v1.13 solo diagnostica** | input nuovo `InpLogCancellazioni` (default false = v1.12 identica, giornale compreso): log del ramo falso di `OrderDelete` (r.1962) e log ricco dell'adozione (r.2077). Nessun'altra riga | no (prova la causa) | compilazione + 2 passate (P_003 H1 e M30_002) con `true` + A0 con default sui due controlli | basso; a `true` il giornale cambia (piu' righe): la lettura va fatta con il default |
| **C. v1.13 "nessun pendente attraverso una chiusura"** | input nuovo, default OFF: niente riarmo della scala se la sessione di trading del simbolo chiude prima della barra successiva, e cancellazione all'ultimo tick operabile ([NOSTRA]: "quanti minuti prima" e' un parametro da firmare) | **si'** (toglie la causa, anche dal vivo) | progetto + cancello + compilazione + **tutte** le gambe da rifare (cambia i setup a ogni chiusura giornaliera, non solo la domenica) | e' una **regola nuova**, non negli audio: va chiesta a Claudio/collega (lei terrebbe limit aperti nel weekend?). Nel tester le sessioni sono quelle della specifica (INFERITO, par. 1 punto 5): possono non coincidere con il vivo. Sessioni a cavallo della mezzanotte e piu' sessioni al giorno da collaudare |
| **D. v1.13 "contabilita' del setup"** | se la cancellazione fallisce il setup **non** si azzera: un riempimento successivo e' registrato come il setup ORIGINALE (rischio, tocco, SL veri, etichetta "riempito dopo cancellazione fallita"); a scelta, all'adozione si cancellano subito i residui | la riga ha R vero; i residui solo con la seconda parte | progetto + cancello + compilazione + rifare le gambe | non minimo: tocca l'ordine fra `Sincronizza` (passo 1) e `OnNewBar`, cioe' proprio la sequenza dei ritentativi; la seconda parte cambia i riempimenti (P_003 O2/O3, M30 13/10 O2) |
| **E. Tolleranza nel lettore** | nessuna modifica all'EA; regole del lettore congelate PRIMA di rileggere (sotto) | no (le nasconde dalla misura) | solo lettore + cancello | **post-hoc**: le adozioni sono gia' viste, quindi le soglie scritte oggi sono scelte guardando i numeri (regola di casa: i criteri si cambiano prima dei numeri, non dopo). **Copre un rischio vero**: dal vivo lo stesso meccanismo esiste (pendenti dell'ultima barra del venerdi + salto del weekend), con doppia esposizione possibile |

**Regole che dovrebbero essere congelate PRIMA di rimisurare, se si sceglie E** (proposta, non decisione; i numeri li fissa il cancello):
1. **Definizione**: riga adottata = riga `SETUP` con `rischio_soldi` 0.00 **e** una riga `ADOTTATO <linea>` nel giornale allo stesso minuto.
   Niente altro.
2. **Esclusione**: fuori da n, PF_R, DD_R, f, mediana di durata; contate a parte: n adottate, soldi adottati (EUR), R stimato
   (= soldi / (0,25% x saldo al riempimento), DIAGNOSTICO).
3. **Metriche in EUR** del report del tester (DD in EUR): restano **con** le adozioni (sono successe) e lo si scrive.
4. **Soglia di leggibilita'** (n adottate / n, somma |R stimato|, SEMAFORO SFORATO) da scrivere **prima** del lotto successivo e da
   applicare **solo** ai lotti nuovi: applicarla a M30_002/003 per "salvarle" sarebbe la soglia scelta dopo il numero (oggi 4/236 = 1,7%
   e 4/201 = 2,0%: una soglia al 2% scritta oggi le farebbe passare **per costruzione**).

**Raccomandazione dello Sviluppatore (da far passare dal cancello):** A subito (costa minuti, puo' trasformare l'INFERITO in FATTO);
poi una **decisione di Claudio** fra C (toglie la causa, anche dal vivo, ma e' una regola nuova da chiedere alla collega) ed E solo per
i lotti futuri (con le regole sopra scritte prima). B serve solo se A non trova le righe. D non la consiglio: non e' minima e tocca la
sequenza che oggi funziona in 441 casi su 450. Le due passate oro M30 restano **illeggibili** finche' la decisione non e' presa:
nessuna di queste opzioni le rilegge "gratis".

---

## 6. Cosa il cancello deve ricontrollare
1. I conteggi del par. 1 (450 episodi, 441 + 9; orari di inizio e fine) con lo script in appendice sui log dei due zip (M30_001 escluso
   perche' tick identici alla P_001: incluso darebbe 514 episodi).
2. Le righe delle tabelle 3.1 e 3.2 contro le tabelle **Ordini** e **Deal** dei `.htm` (UTF-16) dei due zip, ticket per ticket.
3. La lettura del codice: EA r.1598, 1611-1612, 1953-1971 (`ResetSetup` incondizionato a r.1970), 2072-2092, 2126-2127, 2245, e che i
   rami usati siano identici in v1.11 (pilota) e v1.12 (`git diff 4db1af18 d1aef381 -- mql5/Experts/EA_NatCla.mq5`).
4. Il contro-esempio H1/M30 (prezzi 2572.50 / 3333.04 contro 2577.94 / 3347.87) e quello del ritentativo (P_003 libero, riempito lo stesso).
5. Che il par. 5 non contenga una soglia scelta sui numeri di M30_002/003 (opzione E, punto 4).
6. Che **nessun codice EA** sia stato scritto: `git show --stat` del commit deve mostrare solo questo file.

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
01:10 (58); dom 22:10 (19), 23:05 (7), 23:10 (44).
