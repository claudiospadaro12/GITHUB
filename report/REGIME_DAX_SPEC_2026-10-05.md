# Prova di regime sulle sedie DAX: la specifica (05/10/2026)

Mandato: Claudio, 05/10/2026, riportato dalla sessione principale: *"PARTI CON GLI ALTRI INDICI IN BACKGROUND. VISTO CHE CI SIAMO FACCIAMO TUTTO ALLA PERFEZIONE"*. La mail a Emiliano resta in pausa finche' gli EA non sono backtestati con piu' storico.
Autore: `cercatore-parametri`. Perimetro: **SOLA SPECIFICA**. Nessuna riga di lancio, nessun round, nessun file prova, nessun EA / preset / taglia / conto toccato, nessun terminale aperto, nessuna firma data. HEAD di partenza `c9c5ca5a`, branch `lavoro`.
L'unico calcolo eseguito e' di sola lettura su un mirror pubblico dei dati (§1.1): lo script e' `backtest_pipeline/caccia_strategie/biblioteca/sonde_esterne/regime_dax_misure_2026-10-05.py` (autotest + corsa, stesso output di quello riportato qui).
Etichette: [MISURATO] calcolato da me in questa sessione su dati o letto da un file in questa sessione · [LETTO] riportato da un referto non riaperto · [DERIVATO] aritmetica su numeri scritti · [INFERITO] ragionamento, non misura · [FONTE ESTERNA] dalla mia memoria di mercato, da ricontrollare · [NON MISURATO] il dato non c'e' · [NUOVO] criterio o soglia mia, vale solo se firmata.
**Stato del cancello**: questa specifica **NON e' passata dal secondo strato (`controllo-preventivo`)** e non ha nessun PASS. Non contiene stringhe da incollare. Niente di quanto qui scritto esce verso Claudio, il VPS o il PC di backtest finche' non c'e'.
**La decisione del 05/10 non e' una firma sui criteri.** E' il mandato di preparare questa specifica. Le firme che servono sono al §9 e nessuna e' data.

---

## 0. Sintesi in quindici righe

1. **Sedie DAX vive: tre** (sulla trial FTMO `1514806751`, 2,00%): `770101` long retest, `770105` short retest (stesso EA, stesso binario), `770411` MaxMin DAX short. **Due sono testabili sul feed esterno, una no.** `770202` non e' DAX (e' il Dow Apertura US): ha il suo piano (`PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md`), qui non entra.
2. **`770411` e' NON TESTABILE sul DAX esterno, per due ragioni indipendenti e con il numero accanto**: il suo box notturno (23:00-04:59 server BCM = 00:00-05:59 italiane) sta **fuori** dal feed (che copre solo 08:00-22:00 CET: prima barra del giorno 07:00-07:04 server, [MISURATO] su 2.041 giornate su 2.055), e il suo filtro di correlazione richiede `SPXUSD`, che e' in frigo (rapporto 0,203 contro 0,20). Verdetto: **INAPPLICABILE**, non "morto" (§2.3).
3. **Il feed**: HistData `GRXEUR` 2010-11-15 -> 2018-12-28, **1.718.805 barre M1**. Un mirror pubblico raggiungibile dal cloud ha **lo stesso numero di righe per ciascuno dei 9 anni e le stesse righe di testa e di coda** del `D30EUR_M1.csv` gia' convertito [MISURATO]: identita' di conteggi ed estremi, non di byte (hash non agli atti).
4. **L'orologio del feed e' misurato senza BCM** (zero sovrapposizione: nessun confronto possibile): la prima barra di ogni giornata cade dove la regola "ora di New York con DST, ancorata alle 08:00 CET" la prevede in **2.041 giornate su 2.055 (99,32%)**; sui **132 giorni "sfasati"** (USA in ora legale, UE no) **132 su 132**, mentre l'ipotesi "nessun DST" ne fa **0 su 132** e l'ipotesi "NY fissa UTC-5" il **34,94%** del totale [MISURATO, §1.2]. Le 14 giornate fuori dalla regola sono elencate per nome; **8 stanno a fine dicembre 2018** (il feed cambia convenzione il 16/12/2018: vedi §1.3).
5. **Sei finestre di regime**, dichiarate prima di ogni numero di strategia, con etichetta misurata sulle chiusure H1 del feed: **ORSO x3** (2011-12: -10,6% / DD 34,3%; 2015-16: -16,4% / 29,6%; 2018 fino al 14/12: -16,2% / 21,8%), **TORO x2** (2013: +23,6% / 9,8%; 2016.07-2017.06: +27,1% / 5,9%), **LATERALE x1** (2014: +1,8% / 16,3%). Il DAX 2010-2018 non contiene ne' il Covid 2020 ne' l'orso 2022 (§3.4).
6. **Banco**: barre M1, quindi **modello 1 (OHLC)**: il modello 4 su un simbolo custom da barre non esiste. Fattore OHLC -> tick **non misurato sulle due sedie**: la prima misura e' il **cancello G0-C** (la stessa cella, OHLC contro tick, sul DAX nativo BCM 2024-26: 8 passate), non un'ipotesi (§4.3).
7. **Scala e costo**: la cella ha buffer 5,0 e offset 2,0 idx **assoluti** e il DAX 2011-2018 vale 6.500-12.400 contro ~24.500 di oggi: lo stop mediano delle finestre e' **34-76 idx** contro 86,5 di oggi, cioe' **20-44x lo spread assoluto di 1,70** (5 finestre su 6 sotto 40x) ma **58-101x lo spread di oggi riportato in punti base** (0,69 bp). Si trasporta il **costo di oggi in bp**, non il costo d'epoca (§4.2).
8. **Giudizio**: regola A-D di casa (n >= 150 in posizioni, il vecchio giudica il rischio, il recente il merito, la prova di regime batte la storia contigua, limite in basso). Soglie e parole di verdetto congelate **prima** dei numeri (§5).
9. **Orologio d'inverno**: due varianti dello stesso feed, **A "in fase"** (cash alle 08:00 server tutto l'anno = quello che fanno le sedie FTMO) e **B "UTC+1 fisso"** (quello che faranno le sedie BCM dal 26/10: armano un'ora prima della cash d'inverno). A e' primaria; B e' condizionata e vale **~6 inverni equivalenti** (637 feriali d'inverno nelle sei finestre) contro i 2 che ha il backtest BCM (§6).
10. **Costo in tempo di tester (PC di backtest soltanto)**: 32 passate non condizionate = **3-11 minuti**; con la variante B 56 passate = 6-19 minuti; **tetto dichiarato 25 minuti**. Piu' conversione e import ~2-4 minuti [DERIVATO]. Il costo vero e' scrivere il convertitore con il DST per giorno e il lettore: lavoro, non macchina.
11. **Firme di Claudio ancora richieste: tre** (D-J cancello sostitutivo del cancello ZERO inapplicabile sul DAX; D-K criteri e finestre; D-L import e terminale in coda con il Dow). **Gia' valide**: D-A..D-H, in particolare D-C (solo prova di regime, parametri congelati), D-G (DAX 2010-2018, solo prova di regime) e D-H (finestra per simbolo) (§9).
12. **Nessuna sedia viene promossa, spenta o archiviata da questo round** (D-C): le parole che il round puo' scrivere sono NULLO / ZONA GRIGIA / EFFETTO / NON ANCORA MISURATO piu' le parole di cancello (§5.4).
13. **Correzione al mandato** che ricevo: "retest su DAX 0/28 celle" non e' il retest. Lo **0/28** e' `EMA200 H1` sul DAX [LETTO, `SCHEDA_LIVE_EMILIANO_2026-10-05.md` C4]; il retest DAX ha un altopiano misurato a tick (20 celle su 180 con IS e OOS >= 1,10, range 35 buffer 100-600) [LETTO, `APERTURE_DAX_MAPPA_2026-10-03.md` §2.1] (§7).
14. **Riga che cambierebbe** nella tabella "anni / dati" del dossier: da "tick 21 mesi, un regime" a "tick 21 mesi + 6 finestre M1 esterne 2011-2018, tre regimi", ultima colonna **NO -> PARZIALE**, mai SI (§10).
15. **Domanda aperta sull'ora d'inverno (decisione di Claudio entro il 25/10)**: la variante B la illumina con ~6 inverni equivalenti ma **non la decide**; e il feed 2010-2018 ha un'ora di pre-cash (08:00-09:00 CET) di un altro broker (§6.3, §10).

---

## 1. Il feed: che cosa e', e come si calibra senza BCM

### 1.1 Identita' fra il CSV sul VPS e il mirror cloud [MISURATO]

Il CSV convertito il 10/09 sta in `C:\Users\Administrator\abtg_storico_indici\D30EUR_M1.csv` (VPS, [LETTO] da `STORICO_INDICI_20260910_1356/dati/D30EUR_M1_ANTEPRIMA.txt`): **sul VPS, non sul PC di backtest**. Gli zip HistData del DAX sono invece **in cache sul PC di backtest** `DESKTOP-H4D7CAJ` (la diagnosi del 10/09 00:32 e' girata li' "OFFLINE, solo zip in cache": [LETTO] `DIAGNOSI_DAX_20260910_SOGLIA41/REFERTO_DIAGNOSI_DAX.txt` r.6, r.11). Quindi sul PC il CSV si **ricostruisce dagli zip in cache** (conversione ~0,8 minuti, [LETTO] referto del 10/09 F5: 0,7 + 0,1), senza rete.

Il mirror `raw.githubusercontent.com/FutureSharks/financial-data` (cartella `stocks/histdata/GRXEUR`, file annuali `DAT_ASCII_GRXEUR_M1_<anno>.csv`) e' raggiungibile dal cloud. Scaricati i 9 anni:

| anno | righe mirror | righe del referto di diagnosi (colonna "barre") | uguali? |
|---|---:|---:|:--:|
| 2010 | 26.866 | 26.866 | si |
| 2011 | 213.706 | 213.706 | si |
| 2012 | 211.671 | 211.671 | si |
| 2013 | 210.927 | 210.927 | si |
| 2014 | 209.954 | 209.954 | si |
| 2015 | 211.996 | 211.996 | si |
| 2016 | 213.764 | 213.764 | si |
| 2017 | 206.648 | 206.648 | si |
| 2018 | 213.273 | 213.273 | si |
| **totale** | **1.718.805** | **1.718.805** | si |

Prime 5 righe (2010-11-15 02:00 NY: open 6709,00 high 6709,50 low 6703,50 close 6705,00 ...) e ultime 3 (2018-12-28 16:11-16:13 NY, close 10567,61) **identiche** a quelle dell'anteprima del VPS. Nessuna riga fuori ordine (0 su 1.718.804 confronti). **Limite dichiarato**: non c'e' un hash del CSV vero, quindi l'identita' e' di **conteggi ed estremi per anno**, non di ogni byte. La corsa vera, sul PC, ricalcola i conteggi per anno dal CSV ricostruito e li confronta con questa tabella (cancello G-feed, §5.1).

### 1.2 L'orologio del feed: l'oracolo [MISURATO]

HistData dichiara "EST senza ora legale"; il repo ha gia' misurato altro (8 import forex su 8 con shift fisso +5, [LETTO] `histdata_m1.py` r.81-97) e `misura_fuso` dice "il feed SEGUE il DST". Qui l'ipotesi si **falsifica sulle giornate**, con una regola che cambia durante l'anno e quindi non puo' essere indovinata per caso:

Regola H_A: i timestamp sono **ora locale di New York con DST**, e il DAX del feed apre alle **08:00 CET/CEST**. La prima barra del giorno e' quindi alle **02:00 NY** quando USA e UE hanno lo stesso regime, alle **03:00 NY** quando gli USA sono gia' in ora legale e la UE no (dalla 2a domenica di marzo all'ultima, e dall'ultima di ottobre alla 1a di novembre). Calendario applicato alle date reali di ogni anno (domeniche calcolate, non a memoria).

| ipotesi | giornate con >= 300 barre | prima barra nella finestra prevista | quota |
|---|---:|---:|---:|
| **H_A** (NY con DST, 08:00 CET) | 2.055 | **2.041** | **99,32%** |
| H_EST (NY fissa UTC-5, nessun DST) | 2.055 | 718 | 34,94% |
| H_FLAT (sempre 02:00, nessun DST) | 2.055 | 1.909 | 92,90% |
| **solo i 132 giorni sfasati USA/UE**: H_A | 132 | **132** | **100%** |
| **solo i 132 giorni sfasati**: H_FLAT | 132 | **0** | 0% |

Per classe di calendario: 1.196 giorni con USA e UE entrambi in ora legale (prima barra top 02:00-02:01), 727 entrambi in ora solare (02:00-02:01), **132 sfasati** (03:00-03:01, tutti). Ultima barra del giorno: 15:59-16:00 NY nei giorni normali (= 21:59-22:00 CET), 16:59-17:00 nei sfasati.

**Il contro-esempio che ho costruito contro la mia stessa banda**: H_FLAT spiega il 92,90% dei giorni, perche' il 93,6% dei giorni (1.923 su 2.055) e' "allineato" e solo il 6,4% e' sfasato. **Una soglia del tipo "oltre il 90%" non separerebbe l'orologio giusto da quello senza DST** (classe 178). Il test che separa e' il **sottoinsieme dei 132 giorni sfasati**: 132/132 contro 0/132. E' quello, non il totale, la condizione del cancello G-clock (§5.1). L'autotest dello script lo prova su dati sintetici: un feed "sempre 02:00" fa 0/15 sui giorni sfasati, un feed con DST giusto 15/15.

**Cosa NON prova**: che il feed sia in fase con **BCM** (non c'e' BCM prima del 26/09/2024) e che il suo livello di prezzo coincida con il CFD di BCM. Prova la **struttura oraria interna** del feed, che e' cio' che serve per mappare l'ora della cash. E' una calibrazione **piu' debole** del cancello ZERO (§1.4).

### 1.3 Le 14 giornate fuori regola, per nome, e il cambio di convenzione del 16/12/2018 [MISURATO]

Fuori da H_A (prima barra alle): 2011-04-04 02:38 · 2011-04-29 02:15 · 2011-07-27 01:25 · 2013-01-25 02:30 · 2013-06-21 00:00 · 2015-07-20 04:31 · **2018-12-16 18:00 · 2018-12-17 00:00 · 2018-12-18 00:00 · 2018-12-19 00:00 · 2018-12-20 00:00 · 2018-12-21 00:00 · 2018-12-27 02:55 · 2018-12-28 00:00**.

- Le prime sei sono giornate isolate (inizio tardivo o precoce); **4 cadono dentro le finestre** (27/07/2011 in W1, 20/07/2015 in W2, 25/01/2013 e 21/06/2013 in W4) e restano: il cancello G-igiene le elenca per nome. Le altre due (04/04/2011 e 29/04/2011) sono prima di W1.
- **Le ultime otto, tutte a dicembre 2018, sono un'altra cosa**: dal 16/12/2018 (domenica, 18:00 NY) il feed passa alla convenzione **24 ore** (00:00-23:59 NY, fino a 1.334 barre al giorno contro 839-841) che per il resto del file HistData e' quella del 2019-2026. **Le "nove annate sane" della D-G sono quindi 8,08 anni di convenzione 02:00-15:00 NY (15/11/2010-14/12/2018) piu' otto giornate di un'altra convenzione.** La D-G dice "ore 02:00-15:00 NY": le giornate dal 16 al 28/12/2018 non rientrano nella sua lettera. **Questa specifica le esclude per nome**: la finestra W3 finisce il **14/12/2018**.
- Anche il DST per quelle giornate non e' verificabile con questo oracolo (la prima barra e' la mezzanotte, non l'apertura).

### 1.4 Perche' il cancello ZERO sul DAX non si puo' aprire, e perche' la "riparazione" non lo aprirebbe per questi anni

Fatti scritti in repo ([LETTO] `STORICO_INDICI_SCARICATO_2026-09-10.md`, `LO_STORICO_ESTERNO_MAPPA_2026-09-23.md` §1.2, §3.4):
- `D30EUR` nativo BCM parte il **2024.09.26**; il feed esterno finisce il **2018.12.28**: **zero giorni in comune**. Il cancello ZERO (`diff media H1 <= 0,05%`, oppure metro relativo `<= 0,20 x vol oraria` per gli indici) si calcola **solo** sulla sovrapposizione: sul DAX e' **inapplicabile** (l'importatore lo scrive da solo: `SHIFT NON VERIFICATO (nessuna sovrapposizione)`, [LETTO] `ABTG_ImportaStoricoEsterno.mq5` r.480 e r.642).
- La regola D-C n.3 dice: *"finche' il CANCELLO ZERO e' chiuso, gli `_EXT` indici non entrano nemmeno nella prova di regime"* [LETTO `STORICO_INDICI_CRITERI.md` §3]. Per il Nasdaq l'ha sciolta l'emendamento "FIRMO FRIGO NASUSD" del 26/08; **per il DAX non esiste un emendamento**: oggi la regola lo tiene fuori. Serve la firma D-J (§9).

**La via "ripara il 2024-26 e misura la diff" ha un limite che nessun referto aveva scritto**: il DAX HistData 2024-2026 ha **un'altra convenzione di seduta** (00:00-23:00 NY) e **un'altra densita'** (46,2-47,6 barre/ora contro 58,1-59,6 del 2010-2018, [LETTO] referto di diagnosi). Misurare la diff 2024-26 contro BCM misurerebbe la **qualita' del feed nel 2024-26**, non nel 2010-2018. L'attesa dichiarata del 23/09 era "rapporto DAX >= 0,23, peggio del Nikkei che e' in frigo": **se si misurasse e fallisse, la regola D-C n.3 terrebbe fuori il DAX anche se gli anni 2010-2018 sono quelli densi e puliti**. Quindi la proposta D-J e' un cancello **sostitutivo e dichiarato piu' debole** (§5.1), non un cancello ammorbidito: i controlli che si possono fare sul periodo vero, piu' un controllo di prezzo/volatilita' contro il nativo **solo se e dove** diventa misurabile (passo opzionale, §8).

**Livello di prezzo, controllo parziale** [MISURATO sul feed, confronto FONTE ESTERNA non verificata]: ultima barra del 28/12/2018 = 10.566,51 (il repo la confronta con ~10.559 [LETTO]); chiusura delle 17:29 CET (la cash chiude alle 17:30) al 30/12/2013 = 9.605,5, al 29/12/2017 = 12.867,25, al 28/12/2018 = 10.569,71. La mia memoria dei valori di chiusura dell'indice a fine anno (9.552 il 30/12/2013, 12.918 il 29/12/2017, 10.559 il 28/12/2018) **non e' una verifica** (il tentativo di controllarla sul web ha restituito i miei stessi numeri e due siti sono bloccati dal proxy): la dichiaro [FONTE ESTERNA, da ricontrollare]. Se fosse giusta, il feed e' un CFD a livello **future** (sopra l'indice cash di 0,1-0,6% a fine anno): non e' un problema per un'apertura intraday senza overnight, ma e' un'altra ragione per cui il feed **non e' BCM**.

---

## 2. Le sedie DAX: elenco, cella congelata, ora fissa, inverno

Regola di lettura dell'orologio (invariata, [LETTO] `OROLOGIO_BCM_2026-09-24.md`): **BCM indici = UTC+1 FISSO**: d'estate BCM = ora italiana - 1, **d'inverno BCM = ora italiana**. Cash Xetra 09:00 italiane = **08:00 server BCM d'estate, 09:00 server BCM d'inverno, 10:00 server FTMO tutto l'anno** (FTMO = IT+1; la data del suo cambio d'ora [NON MISURATA], misura del 25/10). Cambio del DAX: **26/10/2026** (domenica 25/10 e' la fine dell'ora legale UE).

### 2.1 Tabella delle sedie DAX

| | `770101` | `770105` | `770411` |
|---|---|---|---|
| Motore | `ABTG_DAX_Apertura_EU`, RETEST (`InpEntryMode=2`), **solo long** | stesso EA, stesso binario, **solo short** (specchio) | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato`, rottura del minimo del box notturno, **solo short** |
| TF grafico | M5 (il range si legge su M1 cablato; il TF e' inerte per questo meccanismo, [LETTO] `MAPPA_COSTO` §1) | M5 | M15 (`InpMgmtTF=15`) |
| Cella congelata (preset BCM, = R270c Pass 1) | range **35 min**, buffer **500 pt** (5,0 idx), offset retest **200 pt** (2,0 idx), scadenza pendente 120 min, stop = estremo opposto del range, parziale **50% a 1R + breakeven**, trailing **PREVBAR su M5**, `TrailFixedPts=410` inerte (modo 1), un trade al giorno, nessun filtro (EMA, Supertrend, correlazione, VWAP, volumi, news: tutti spenti), `InpMaxSpread=0`, `MinStopPts=0` | identica, salvo `AllowLong=false`, `AllowShort=true`, magic 770105 (diff di 3 righe, [LETTO] `SEDIA_SHORT_DAX_FTMO_2026-09-25.md` §2) | box 23:00-04:59, piazza 07:59, taglio ingresso 08:30, chiusura 17:30; buffer 1000 pt; stop 2,5 x ATR(14) M15; TP1 1R 50% + BE; TP2 3R 50%; target EMA200; TP finale 4R; trailing ATR 2,0; **filtro correlazione S&P ACCESO** (`SPXUSD` H1, EMA 14/100) |
| Ora fissa **server BCM** (contratto) | `InpSessionHour=8` (08:00), `InpCloseHour=17:30` | idem | box `23:00-04:59`, `Place 07:59`, `Cutoff 08:30`, `Close 17:30` |
| Ora fissa **server FTMO** (in campo) | `SessionHour=10`, `Close 19:30` | idem | box `01:00-06:59`, `Place 09:59`, `Cutoff 10:30`, `Close 19:30` |
| **Dal 26/10 su BCM** | arma alle 08:00 = **08:00 italiane, 1 ora prima della cash**; chiude alle 17:30 italiane invece che alle 18:30 | idem | place 07:59 italiane, **taglio alle 08:30 italiane: la finestra d'ingresso si chiude PRIMA che la cash apra**; la sedia diventa un breakout pre-cash |
| Dal 26/10 su FTMO | in fase con la cash (IT+1) [INFERITO: cambio FTMO non misurato] | idem | idem |
| Contratto, tick BCM, 1,00%, dep. 100.000 | IS **1,12634**, n 175 deal (**132 pos**), DD **5,4362%** · OOS **1,39709**, 270 deal (**193 pos**), DD **7,2328%** (R270c Pass 1) | IS **0,96513**, 138 deal, DD **7,4732%** · OOS **0,95734**, 257 deal (**194 pos**), DD **12,3052%** (R270d); altra misura R251 (banco 10.000): 0,846/1,065, DD 11,19/12,74 | IS **1,87803**, 20 deal, DD **3,0977%** · OOS **2,15985**, 21 deal = **14 pos**, DD **1,9213%** (`ptb`) |
| Orologio del contratto | **mescola** estate in fase / inverno 1h prima: allineati PF 1,27 (n 144), sfasati 1,48 (n 126) [LETTO] | mescola; estate 96 pos PF 1,390, inverno 85 pos PF 0,899 (per-trade 792520) | mescola; n < 30 ovunque |
| In fase, BCM, R246 (tick, 1,00%) | d0 estate PF **1,108** (157 pos, 0,662/g); d0 inverno **1,389** (168, 0,764/g); **d+1 inverno 1,184** (138, 0,627/g); serie "come FTMO" **1,143 su 295 pos, DD saldo 9,50%** (contro 6,06% del d0) | in fase **R252: [NON ARRIVATO]** (nessun CSV in nessun ramo; ultima verifica `git log --all`) | d0 estate 1,450 (11 pos); d0 inverno 2,558 (16); d+1 inverno 0,996 (17); serie "come FTMO" 1,187 su 28 pos |
| Frequenza promessa | 0,699 pos/g | ~0,70 pos/g (194/276) | **0,051 pos/g** |
| Forward noto | trial FTMO 05/10: una sedia DAX short ha preso uno stop pieno (-3.049,94, ~2,0%) [LETTO `NOTTE_2026-10-05.md`; il magic non e' nella foto: [INFERITO] 770105] | idem | stop pieno 24/09 e 30/09 [LETTO] |
| **Testabile sul feed 2010-2018?** | **SI** (cella intraday dentro 08:00-22:00 CET, nessun simbolo accessorio) | **SI** | **NO: INAPPLICABILE** (§2.3) |

Fonti dei numeri: `CENSIMENTO_ORB_2026-09-29.md` righe 1-2 e V3-V4 (riletti dai CSV dall'autore), `CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` §2 e §4, `LETTURA_R246_INVERNO_2026-09-29.md` §2-3, `PARAMETRI_DAX_APERTURA_2026-10-01.md` (stop del 770101/770105 = range 35' + buffer 5 - offset 2 = range + 3 idx; **primo stop pieno a +53 minuti**, la posizione non puo' essere spazzata nei primi 35'), preset `mql5/Presets/ABTG_DAX_Apertura_EU_D30EUR_M5_770101_100K.set` e `.../ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_M15_770411_100K.set` e le loro versioni `mql5/Presets/FTMO/`. Per il 770411 ho **riletto io** i CSV `..._D30EUR_{IS,OOS}_ptb.csv` (PF e DD sopra) e `..._{IS,OOS}.csv` / `..._ohlc.csv`.

**Dove stanno oggi**: sulla trial FTMO `1514806751` (160.000 EUR, 2,00%), **sette sedie vecchie** fra cui queste tre [LETTO `HANDOFF.md` blocco 01/10]. Sui terminali BCM le sedie indice sono **sospese** (24/09 reale e 100k, 25/09 piccolo) [LETTO `SOSPENSIONE_SEDIE_DEMO_2026-09-25.md`; stato attuale [NON RILETTO al 05/10]]. Quindi il problema dell'ora d'inverno su BCM riguarda oggi i numeri di contratto e un eventuale rientro, non ordini vivi; sulla trial FTMO le sedie sono in fase.

### 2.2 Altri motori DAX, perche' NON sono in questa specifica

| motore | stato | perche' non qui |
|---|---|---|
| `SupRev_DAX_H4_Ottimizzato` `970912` (D30EUR H4) | sospeso 25/09; OHLC PF 1,96, DD 5,7%, 86 operazioni (26/07); **tick [NON MISURATO]** come sedia | motore su **barre H4 / EMA200 / Supertrend**: il feed ha 14 ore su 24, quindi la barra H4 e l'EMA200 sono **un altro oggetto** (200 barre H1 = 14 giorni di borsa invece di ~8,3). Non e' un test di regime dello stesso motore |
| `SupertrendReversal` DAX H1/H4 `770923`, `SuperWave_DAX_H4` `770512` | non in campo / ritirato (770512: raccomandazione ritirata 08/09, n=56) | stessa ragione (barre H4/H1 su 24 ore) |
| `DaxReEntry` | cecchino: ~3-4 trade/mese per lato, merito sospeso (n < 150) | il campione non si puo' costruire in 6 finestre |
| `ABTG_DAX_Apertura_EU_Ottimizzato` `770111` (cella "A2": range 15, buffer 600, solo long) | mai girato col proprio nome; il range 15 sul DAX e' **0/4 in OOS** a tick [LETTO CENSIMENTO_ORB §5] | non e' la cella in campo; resta [NON ANCORA MISURATO] |
| `770202` | **Dow**, non DAX | `PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md` (F2 firmata, P0 fatto, P1 in cancello) |

### 2.3 `770411`: perche' e' INAPPLICABILE sul DAX esterno (con il numero)

1. **Il box non c'e' nel feed.** Il box notturno e' 23:00-04:59 server BCM = **00:00-05:59 italiane**. Il feed 2010-2018 comincia alle **08:00 CET** (prima barra 07:00-07:04 server A in 2.041 giornate su 2.055) e finisce alle 22:00 CET. L'intersezione fra il box e il feed e' **vuota**: l'EA non avrebbe un box, e in assenza di segnale **non aprirebbe niente senza dare errore** (lo zero silenzioso: una passata con n=0 sembrerebbe "prova superata").
2. **Il filtro di correlazione richiede `SPXUSD`** (`InpUseCorrelation=true`, `InpCorrSymbol=SPXUSD`, H1, EMA 14/100): servirebbe `SPXUSD_EXT`, che e' **in frigo** (rapporto 0,203 contro 0,20, [LETTO]); spegnere il filtro cambierebbe la cella (e il contratto e' *proprio* quel filtro: "la correlazione S&P raddoppia il PF", [LETTO REGISTRO]).
3. **Anche con un feed completo il merito non sarebbe mai leggibile**: frequenza promessa **0,051 pos/g** x ~2.050 giorni di feed = **~105 posizioni** (anche applicando a tutti i giorni la frequenza d'inverno piu' alta di R246, 0,077/g, si arriva a ~158): **sotto o al limite dei 150 in tutti gli otto anni insieme**, figuriamoci per finestra (0,051 x 250 = ~13 posizioni). Giudicherebbe solo il rischio, ed il rischio non si legge con 13 posizioni.
4. **La via lunga esiste e NON la propongo**: Dukascopy `DEUIDXEUR` (24 ore, dal 2012 [LETTO]) per le finestre W2 e W3, con il ritmo misurato per il Dow (4,1-16,0 minuti/giorno, [LETTO piano Dow §3.4]): ~500 giorni = **34-133 ore di PC acceso** per ottenere **~25 posizioni**. Il rapporto costo/valore e' il peggiore di tutta la specifica. Verdetto scritto: **`770411` = INAPPLICABILE sul feed 2010-2018; NON ANCORA MISURATO fuori dal toro** (certificato di morte: mancano gemelli, TF e un regime; non si archivia).

---

## 3. Le finestre di regime

### 3.1 Regola di etichettatura (scritta prima di ogni numero di strategia) [NUOVO]

Si calcolano sulle **chiusure H1 del feed** il rendimento (dalla prima all'ultima chiusura H1 della finestra) e il **massimo drawdown** picco-fondo. Etichetta, **esclusiva ed esaustiva**:

- finestre **lunghe (>= 9 mesi)**: **TORO** se rendimento >= +10% e DD < 15%; **ORSO** se rendimento <= -5% e DD >= 15%; **LATERALE** se |rendimento| <= 5%; altrimenti **MISTO**;
- finestre **corte (<= 4 mesi)**: **CROLLO** se DD >= 25%, altrimenti **MISTO**.

Una finestra **MISTO** non entra in nessuna classe senza una nuova firma. Se l'etichetta misurata differisce da quella attesa la finestra **si rinomina, non si scarta**. **Differenza dal piano Dow del 05/10**: li' le quattro regole non sono esclusive (un crollo e' sempre anche un orso, e due regole che scattano danno MISTO); qui la lunghezza della finestra decide, quindi un CROLLO non puo' essere letto anche come ORSO. Le due regole vanno **armonizzate prima di firmare** (§9, D-K).

Proprieta' da sapere: una finestra lunga con |rendimento| <= 5% ma DD grande (es. 2011.04-2012.03: -1,9%, DD 34,3%) si etichetta LATERALE. Non e' il caso di nessuna finestra scelta (la LATERALE scelta ha DD 16,3%), ed e' dichiarato.

### 3.2 Le sei finestre [MISURATO sul feed, script §0]

| sigla | finestra | giorni di borsa | chiusura H1 prima -> ultima | rendimento | max DD (picco -> fondo) | vol. annua | etichetta misurata |
|---|---|---:|---|---:|---|---:|---|
| **W1** ORSO euro | 2011.05.01 - 2012.04.30 | 258 | 7.591,50 -> 6.784,00 | **-10,6%** | **34,3%** (2011-05-02 7.608 -> 2011-09-12 4.996) | 33,0% | **ORSO** |
| **W2** ORSO 2015-16 | 2015.04.01 - 2016.03.31 | 252 | 11.922,25 -> 9.966,75 | **-16,4%** | **29,6%** (2015-04-10 12.417 -> 2016-02-11 8.746) | 24,7% | **ORSO** |
| **W3** ORSO 2018 | 2018.01.01 - 2018.12.14 | 244 | 12.911,25 -> 10.823,75 | **-16,2%** | **21,8%** (2018-01-23 13.580 -> 2018-12-10 10.623) | 16,2% | **ORSO** |
| **W4** TORO 2013 | 2013.01.01 - 2013.12.31 | 253 | 7.781,00 -> 9.613,50 | **+23,6%** | **9,8%** (2013-05-22 8.536 -> 2013-06-24 7.700) | 13,4% | **TORO** |
| **W5** TORO 2016-17 | 2016.07.01 - 2017.06.30 | 250 | 9.727,00 -> 12.366,50 | **+27,1%** | **5,9%** (2016-10-25 10.812 -> 2016-11-09 10.179) | 13,2% | **TORO** |
| **W6** LATERALE 2014 | 2014.01.01 - 2014.12.31 | 253 | 9.621,50 -> 9.797,25 | **+1,8%** | **16,3%** (2014-06-20 10.048 -> 2014-10-16 8.410) | 16,4% | **LATERALE** |

Le sei etichette misurate **coincidono con quelle attese**. Classi: **AVVERSE = W1 + W2 + W3** (tre orsi diversi: crisi del debito, Cina/materie prime con il crollo di agosto 2015 e febbraio 2016, 2018 con il Q4), **TORO = W4 + W5**, **LATERALE = W6**.

**Sotto-finestra CROLLO 2011.07.01-2011.09.30**: rendimento -26,6%, DD 33,6% (2011-07-08 -> 2011-09-12, 2,2 mesi), etichetta CROLLO. Sta **tutta dentro W1**: **classe 1102** (l'attesa di rischio su una sotto-finestra ignora il DD gia' misurato sulla finestra che la contiene). **Non si lancia come finestra a se'**: il suo DD e' un **tetto** dato da quello di W1 (+ margine di confine dichiarato), e peggior giornata e PF del trimestre si leggono dal **per-trade** di W1. Se il per-trade non si produce (§5.1 G-pertrade), il trimestre resta [NON MISURATO] e si scrive cosi'.

### 3.3 Come sono state scelte, e che cosa e' stato scartato (la lista completa, perche' le finestre sono un grado di liberta')

Nessun numero di strategia e' stato visto. Regola: le tre finestre ORSO partono dal **mese del massimo che precede il tracollo** (maggio 2011, aprile 2015, gennaio 2018) e durano 12 mesi (o fino al 14/12/2018, §1.3); le due TORO sono i 12 mesi con **piu' alto rendimento che rispettano la regola TORO e non toccano le altre finestre** (2013 e luglio 2016-giugno 2017); la LATERALE e' l'unico anno solare con |rendimento| <= 5% **disgiunto** dalle altre. Scartate, con il motivo misurato: **2012** (+29,4% ma DD 17,8%: MISTO), **2011 anno solare** (-15,6%, DD 34,3%, sovrapposto a W1), **2015-16 a 18 mesi** (-1,2% ma DD 29,6%, contiene W2), **2017** (+12,5%, DD 8,1%: TORO valido ma 2016.07-2017.06 e' piu' alto e le due si sovrapporrebbero), **2011.04-2012.03** (-1,9% / 34,3%: LATERALE per regola, non per natura), **2018 fino al 28/12** (-18,2% / 24,2%: contiene le giornate della convenzione 2019).

Le finestre sono **disgiunte** (nessuna data in comune): il piu' vicino, W1 finisce il 30/04/2012 e W4 comincia il 01/01/2013. **Non e' indipendenza statistica** (i regimi di mercato si concatenano): e' non-sovrapposizione delle date. **Avvertenza di comparabilita'**: W2 (2015.04-2016.03) sta nello stesso mercato di W4 del piano Dow (2015.05-2016.06): se si citano insieme per dire "gli indici reggono l'orso 2015-16", non sono due prove.

### 3.4 Che cosa il DAX 2010-2018 non contiene

**Non contiene il crollo Covid (2020) ne' l'orso 2022**: nel `grxeur` il 2020-2023 e' **un altro strumento** (prezzi 2021 3.461-4.414, 2022 3.247-4.395, [LETTO]). Quindi su questo feed due dei quattro regimi di casa (CROLLO_ANNO 2020, ORSO 2022) **non sono misurabili sul DAX**. Il solo DD >= 25% in <= 4 mesi dentro il feed e' il Q3 2011. Per coprire 2020 e 2022 servirebbe `DEUIDXEUR` di Dukascopy (D-F strada 2, [LETTO]): **non e' in questa specifica** e non e' una firma da chiedere adesso (§11, punto 12).

### 3.5 Numeri di operazioni attesi per finestra, e che cosa vuol dire n >= 150

Frequenza promessa 0,699 pos/g (contratto), e in fase 0,627-0,764 (R246) [LETTO]. Per finestra di ~250 giorni: **157-191 posizioni** [DERIVATO]; fascia dichiarata 120-210 perche' la frequenza dipende dal regime (R113 ha trovato 5-10x di differenza fra epoche, feed o mercato non separabili, [LETTO `R113_REFERTO.md` scoperta n.1]).
- **n >= 150 per cella-finestra**: a rischio di essere sotto in 1-2 finestre; **il merito si legge per classe**, dove il campione c'e' per costruzione: AVVERSE ~3 x 160 = ~480, TORO ~320, LATERALE ~160 [DERIVATO].
- Le **posizioni** sono quelle del per-trade (`position_id` distinti), non i deal: con il parziale al 50% una posizione chiude in due deal (fattore 1,3-1,4 sulle sedie DAX: 270/193, 257/194, 175/132 [LETTO]). Dove non si contano, si scrive la forbice.

---

## 4. Il banco: modello, scala, costo

### 4.1 Modello e simbolo

Il feed e' fatto di barre M1: il simbolo custom da barre **non ha tick reali** (il modello 4 su un simbolo importato da barre non esiste, [LETTO] `importa_storico_esterno.ps1` r.525 e `R113_CRITERI.md` §1). **Ogni numero di questa prova e' modello 1 (OHLC su M1) e vale come screening, mai come verdetto**: *"il verdetto lo danno i tick reali"*. Si leggono **forma, segni, ordini di grandezza e il rischio**, non i numeri fini; i confronti si fanno **solo fra finestre dello stesso feed**, mai "feed 2013 contro BCM 2025" (R80: stessa cella, stessa finestra, cambia solo il feed, **quattro cambi di segno su quattro**, [LETTO]).

Simbolo di prova: `D30EUR_EXT` (clone di `D30EUR`: digits, point 0,01, tick value 1,0000 EUR/punto/lotto, step lotti, [LETTO] `ABTG_ImportaStoricoEsterno.mq5` r.191-218 e `PARAMETRI_DAX_APERTURA`). Il simbolo **non esiste** (zero righe `_EXT` per D30EUR, [LETTO]).

### 4.2 Scala dei punti e costo: due numeri, un principio

La cella usa **punti assoluti**: buffer 500 pt = 5,0 idx, offset 200 pt = 2,0 idx. Il DAX vale oggi ~24.500 (BCM 2026: 21.859-25.904, [LETTO]) e nelle finestre 6.564-12.392 (prezzo mediano del giorno all'apertura, [MISURATO]). **Misura dell'apertura sul feed** (range dei primi 35 minuti di cash, 09:00-09:35 CET; si e' richiesto almeno l'80% delle barre):

| finestra | giorni | prezzo mediano | **R15** mediano | **R35** mediano (% prezzo) | R35 p10 / p90 | stop ~ R35+3 | spread massimo per 40x |
|---|---:|---:|---:|---|---|---:|---|
| W1 | 257 | 6.564 | 26,5 (0,404%) | **40,5 (0,617%)** | 24,0 / 76,5 | 43,5 | 1,09 idx (1,66 bp) |
| W2 | 251 | 10.748 | 50,2 (0,468%) | **72,5 (0,675%)** | 45,8 / 120,0 | 75,5 | 1,89 idx (1,76 bp) |
| W3 | 243 | 12.392 | 33,5 (0,270%) | **50,2 (0,406%)** | 30,0 / 88,2 | 53,2 | 1,33 idx (1,07 bp) |
| W4 | 252 | 8.250 | 20,8 (0,251%) | **31,0 (0,376%)** | 17,5 / 52,5 | 34,0 | 0,85 idx (1,03 bp) |
| W5 | 250 | 11.445 | 32,1 (0,281%) | **43,2 (0,378%)** | 26,8 / 76,2 | 46,2 | 1,16 idx (1,01 bp) |
| W6 | 251 | 9.590 | 26,5 (0,276%) | **39,5 (0,412%)** | 23,0 / 72,0 | 42,5 | 1,06 idx (1,11 bp) |
| *BCM oggi* | 440 | ~24.500 | 54,65 (0,223%) | R35 ~83,5 [INFERITO, R15 x radice(35/15)] (~0,34%) | | 86,5 | 2,16 idx a 40x |

Lo **stop** del 770101/770105 e' range + 3 idx [LETTO `PARAMETRI_DAX_APERTURA`]; la **frontiera di casa** e' `stop >= 40 x spread`.
- **Spread assoluto di BCM (1,70 idx, mediana ora 8)**: pavimento a 68,0 idx. Stop mediani delle finestre 34,0-75,5 idx = **20,0x - 44,4x**: **cinque finestre su sei sotto 40x** (solo W2 sopra). **Questo non e' un difetto del mercato 2011-2018: e' il prezzo dell'indice.** Lo stesso mercato, a prezzi di oggi, avrebbe stop 2-4 volte piu' larghi (prezzo ~24.500 contro 6.564-12.392).
- **Spread di BCM trasportato in punti base** (1,70 / ~24.500 = **0,694 bp**, qui arrotondato a 0,69): per ogni finestra lo spread equivalente e' 0,46-0,86 idx e il rapporto stop/spread (stop mediano R35+3) diventa **58-101x** (W1 95,5 · W2 101,2 · W3 61,9 · W4 59,4 · W5 58,2 · W6 63,9). **Tutte e sei le finestre passano 40x**.

**Principio scelto** [NUOVO, firma D-K]: la prova di regime mette alla prova il **meccanismo contro i regimi di mercato**, non contro i costi d'epoca (che per BCM non esistono: il nativo parte nel 2024). Si trasporta quindi il **costo di oggi in bp** e si **dichiara** che lo spread storico vero del DAX era probabilmente piu' alto in bp [FONTE ESTERNA, non misurato: a ~6.500 con 1-2 punti sarebbe 1,5-3 bp, cioe' 2-4x il costo di oggi]. Il costo non e' un'incognita nascosta: e' un **limite superiore** del merito dichiarato.

Come si applica il costo (lo spread dell'importatore e' 0: `out[n].spread = 0`, [LETTO classe 89]): **il banco gira a spread 0 e il costo si sovrappone a valle** dal per-trade: costo per posizione = lotti x 0,69 bp x prezzo d'ingresso x 1 EUR/punto (un giro completo = uno spread per lotto: ingresso all'ask, uscita al bid) [DERIVATO]; si sottrae al netto di ogni posizione e si ricalcola il PF. **E' una stima al primo ordine**: ignora il fatto che con spread vero gli ordini limite si riempiono piu' tardi (ottimistico sui riempimenti) e ignora commissioni e slippage (**[NON MISURATA] la commissione su D30EUR**). Il merito si legge **al netto del costo sovrapposto** e **al lordo**, entrambi stampati; se lo spread per barra si potesse scrivere nel simbolo (modifica dell'importatore, [NON FATTA]) il confronto si farebbe direttamente, ed e' un passo successivo condizionato.

### 4.3 Il fattore OHLC -> tick: dichiarato dalla casa, e la prima misura e' sulla sedia stessa

Fattori misurati in casa su **altre** celle, tutti nello stesso verso (l'OHLC gonfia il PF) ma con un'ampiezza che dipende dal meccanismo:

| cella | PF OHLC | PF tick | rapporto | fonte |
|---|---:|---:|---:|---|
| `DAX_Live5m` D30EUR M5 | 1,47 | 0,857 | 1,714 | [LETTO `REGISTRO_TEST.md` r.30] |
| `DAX_Live5m_v2` | 1,71 | 0,925 | 1,850 | idem |
| Nasdaq Live5m | 2,16 | 0,963 | 2,25 | [LETTO] |
| `SupRev_DOW_H4` | 2,77 | 0,79 | **3,51** (contratto revocato) | [LETTO `COME_ALLUNGARE...` §0] |
| **`770411` D30EUR M15 (OOS, stesso banco 10.000)** | **2,44161** | **2,19220** | **1,114** (IS 2,05815 / 1,92148 = 1,071) | [MISURATO: `..._OOS_ohlc.csv` e `..._OOS.csv`, `..._IS_ohlc.csv` e `..._IS.csv`] |
| EMA200 Dow H1, **DD** | 6,48% | 7,83% | 0,83 (l'OHLC **sottostima** il DD; finestre e depositi diversi: **indicazione di verso**, non rapporto pulito) | [LETTO `CONTRATTI` §3.1] |
| `770411`, **DD** | 2,2476 (OOS) | 1,8768 | 1,20 (**sovrastima**); IS 3,0098/3,0687 = 0,98 | [MISURATO] |

Sulle **due sedie di questa prova (770101, 770105) il fattore non e' mai stato misurato**: nessun CSV OHLC del DAX Apertura in repo [MISURATO con `find`]. La forbice di casa va da **1,07 a 3,51** e dipende dal meccanismo: **non si puo' scegliere un numero**. Quindi:

**Cancello G0-C (calibrazione del banco, sul nativo BCM, prima delle finestre)**: la **stessa cella** di R270c (770101) e R270d (770105), Pass 1, sul **DAX nativo `D30EUR` BCM, 2024.09.26-2026.06.30, modello 1**, con la stessa partizione IS/OOS di R270 (`FRAZIONEIS 0,40`), contro il contratto a tick. Lettura (soglie [NUOVO], da firmare in D-K, scritte prima):
- **banco FEDELE** se, in OOS, posizioni OHLC / tick in [0,85; 1,15] **e** |PF OHLC - PF tick| <= **0,15** (la banda di rumore gia' misurata in casa, 0,147, [LETTO `APERTURE_DAX_MAPPA` §2.1]) **e** DD OHLC / DD tick in [0,80; 1,20];
- **ZONA GRIGIA** se il PF differisce di 0,15-0,40: si leggono **solo segni e ordini di grandezza**;
- **banco NON FEDELE** se |dPF| > 0,40, oppure se il PF tick e' >= 1,10 e quello OHLC < 0,90 (o viceversa): **la prova di regime si legge SOLO per rischio e forma, mai per merito**;
- se le posizioni sono fuori banda: **NULLO** (la cella nel banco OHLC non e' la stessa cella: gemello fallito).
Costo: **8 passate** (2 lati x 2 gemelle x 2 gambe) = 0,8-2,6 minuti [DERIVATO]. **Il dato del nativo e' un'altra epoca** (toro 2024-26): serve a dire **quanto il banco OHLC si discosta dal banco a tick sulla stessa cella**, non a dire che i numeri delle finestre sono "veri".

---

## 5. Cancelli e criteri, congelati prima dei numeri

Nessun criterio di casa e' ammorbidito. **[CASA]** = ereditato con la fonte; **[NUOVO]** = scritto qui, vale solo se firmato (D-J per il cancello sostitutivo, D-K per il resto) e solo perche' scritto prima di ogni numero di strategia.

### 5.1 Cancelli (se uno fallisce: **NULLO**, nessuna lettura)

| cancello | che cosa | regola | origine |
|---|---|---|---|
| **G-feed** | il CSV ricostruito sul PC e' quello misurato | conteggio righe per anno uguale alla tabella §1.1 (9 su 9) e prime/ultime righe uguali all'anteprima del 10/09 | [NUOVO] |
| **G-clock** | il convertitore applica l'orologio giusto **per giorno** | sul CSV **convertito** (clock A): la prima barra del giorno cade a **07:00-07:04** in **2.041 giornate su 2.055**, le **14 eccezioni sono le stesse, per nome** (§1.3), e **nei 132 giorni sfasati 132/132**; un convertitore a shift costante (+5) darebbe 0/132. Variante B: **850 su 859** giorni d'inverno UE con prima barra 08:00-08:04 e **1.191 su 1.196** d'estate 07:00-07:04 (le stesse 14 eccezioni: 9 d'inverno, 5 d'estate) [DERIVATO dall'oracolo] | [NUOVO], **oracolo gia' misurato oggi** (§1.2) |
| **G-igiene** | niente dato sporco dentro le finestre | per finestra: feriali senza barre, giorni con < 300 barre, buchi > 60 minuti nel giorno, feriali d'inverno UE, feriali sfasati; **tutti elencati per nome** nel referto. Valori di partenza [MISURATO]: W1 3 / 0 / 5 / 105 / 15 · W2 10 / 0 / 1 / 110 / 15 · W3 6 / 0 / 1 / 95 / 15 · W4 8 / 0 / 1 / 111 / 20 · W5 11 / 0 / 0 / 105 / 15 · W6 8 / 2 / 0 / 111 / 20 (i feriali senza barre sono festivi di borsa) | [NUOVO] |
| **G0-A** (antenato) | ogni file e' la copia riga per riga di R270c (770101) / R270d (770105) | delta ammessi **per nome**: `@SIMBOLO` (`D30EUR_EXT`), `@DAQUANDO`/`@FINOA` della finestra, `InpMagic` (blocco vergine **797100-797199**: verificato, **nessuna occorrenza nel repo ne' nella storia git**; schema a cura di chi scrive i file). **Nient'altro**: ne' un buffer, ne' un'ora, ne' un lato diverso | [CASA, R113 §4] |
| **G0-B** (gemelli) | determinismo | ogni cella in coppia gemella (magic +5): risultati **identici al centesimo** | [CASA] |
| **G0-C** (banco) | OHLC contro tick sulla stessa cella, sul nativo | §4.3 | [NUOVO] |
| **G-pertrade** | il per-trade esiste anche su `D30EUR_EXT` in OHLC | il file `abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_EXT_<magic>.csv` esce con `position_id`, lotti, ingresso, chiusura. **Se non esce**, la classe si legge con il fallback di §5.3 e il costo sovrapposto (§4.2) **non** si calcola [NON MISURATO se l'EA lo esporta su un simbolo custom] | [NUOVO] |
| **G-ordini** | nessun ordine rifiutato per sessione | nel log del tester **zero** righe di rifiuto per sessione chiusa (la tabella delle sessioni del simbolo clonato e' in ora server: tick etichettati fuori dalle sessioni di `D30EUR` BCM potrebbero essere scartati) | [NUOVO, ereditato dal piano Dow K2] |
| **G-spread** | si dichiara lo spread effettivo del banco | lo si legge e lo si scrive nel referto (zero atteso, [LETTO classe 89]); se e' diverso da zero e non dichiarato: NULLO | [CASA, R113 §1] |

### 5.2 Rischio: si legge a qualunque n (Emendamento B)

- **R1 [CASA, `PROVA_REGIME_CRITERI.md` §4 A]**: in ORSO (W1, W2, W3) il DD (equity, rischio 1%, deposito 100.000) <= **2 x il DD OOS del contratto** e **comunque < 20%**. Soglie: **`770101` = min(2 x 7,2328; 20) = 14,47%**; **`770105` = min(2 x 12,3052; 20) = 20,00%** (qui il tetto assoluto morde; a 20% una cella che e' gia' "bocciata per rischio" a 12,31% non diventa sana: R1 dice solo se **peggiora oltre il doppio**).
- **R2 [NUOVO]**: **peggior giornata realizzata** (per data di chiusura, giorno del server di banco) <= **2,25%** a rischio 1%, cioe' meta' dell'emergenza giornaliera del Guardian (4,5%) [LETTO `SEDIA_SHORT_DAX_FTMO_2026-09-25.md` §5] riportata alla taglia di banco. Il flottante resta fuori. **Si legge solo se G-pertrade passa**.
- **Si scrive sempre accanto, ma non e' un criterio**: il DD moltiplicato per 2 (taglia 2,00% della trial) e il rapporto fra il DD della finestra e il DD OOS. La taglia resta di Claudio.
- **Limite dichiarato**: DD da banco OHLC = **limite inferiore o superiore a seconda del meccanismo** (0,83x-1,20x nei due casi misurati, §4.3): il DD si legge con il rapporto del G0-C accanto.

### 5.3 Merito: solo dove n >= 150 posizioni (Emendamento A)

- Per **cella-finestra**: se posizioni < 150 la riga porta **"MERITO: NON ANCORA MISURATO"** in chiaro. Il numero si scrive, la decisione no.
- Per **classe** (dove il campione c'e'): PF **aggregato** dei trade di tutte le finestre della classe (dal per-trade). **Fallback se il per-trade non esce**: mediana dei PF di finestra e **conteggio** delle finestre con PF >= 0,90; in quel caso la classe e' **"PARZIALE: aggregato non calcolabile"**.
- **M1 [CASA, `PROVA_REGIME_CRITERI` §4 B, D]**: PF di classe AVVERSE >= **0,90**, **e** PF >= 0,90 in **almeno 2 finestre su 3** (un solo periodo avverso e' un aneddoto).
- **M2 [CASA, `PIANO_LATI_REGIME_2026-09-09.md` §6, regola dei due lati del 25/08]**: il motore **regge fuori dal toro** se **PF(long, AVVERSE) >= 0,90 E PF(short, TORO) >= 0,90**; se uno dei due e' **< 0,70** il motore e' **DIREZIONALE** ("non e' una bocciatura: e' un'etichetta che cambia il contratto"). Giudizio sulla **coppia di classi**, mai su una finestra. Qui le due sedie sono i due lati dello **stesso motore** (`ABTG_DAX_Apertura_EU`): M2 si applica alla **coppia** (long in AVVERSE, short in TORO) e l'etichetta DIREZIONALE si attacca al lato che cade sotto 0,70; R1 e R2 restano **per sedia**.
- **M3 [CASA, §4 C]**: PF di classe AVVERSE >= **1,10** con R1 rispettato = **"lavora in entrambi i regimi"**: etichetta, **nessuna promozione** (D-C).
- **M4 (LATERALE, W6) [NUOVO]**: PF >= 0,90; con n < 150 e' sospeso.
- **Il banco**: se G0-C dice **NON FEDELE**, M1-M4 non si leggono (solo R1, R2 e la forma). Se **ZONA GRIGIA**, si scrivono i segni e si sospende la soglia.

### 5.4 Le parole del verdetto (scritte prima)

| parola | quando | che cosa si scrive | che cosa NON si fa |
|---|---|---|---|
| **NULLO** | un cancello G fallisce | "round NULLO: <cancello>"; nessun numero di merito o rischio si legge | non si salta il cancello, non si rilancia con una cella cambiata |
| **NON ANCORA MISURATO** | n < 150 nella cella-finestra o nella classe; oppure banco NON FEDELE (per il merito); oppure per-trade assente (R2, classe) | il numero + cosa manca | non diventa "morto" (certificato del 09/09) |
| **ZONA GRIGIA** | PF di classe fra 0,70 e 0,90 (AVVERSE) o fra 0,90 e 1,10 senza due finestre concordi; etichetta di finestra MISTO; G0-C in zona grigia | i segni, le finestre, accanto il rumore 0,147 | non si "interpreta" verso l'alto |
| **EFFETTO (merito)** | M2 soddisfatta, oppure DIREZIONALE (uno dei due PF < 0,70) | "regge fuori dal toro" oppure "DIREZIONALE": **etichetta che cambia il contratto, mai un'azione sulla sedia** | nessuna promozione, nessuno spegnimento, nessun cambio di taglia (D-C, FIRME 18/08) |
| **EFFETTO (rischio)** | R1 o R2 violati in **almeno una** finestra avversa | segnalazione formale di **revisione** alla sessione principale, decisione a Claudio | nessun automatismo su dati esterni (D-C) |
| **parole di cancello** | PASSA / NON PASSA / **INAPPLICABILE** (per `770411` e per il cancello ZERO) | il numero e la regola | INAPPLICABILE non e' "passato" |

---

## 6. L'orologio: due varianti, e che cosa si puo' dire dell'ora d'inverno

### 6.1 La conversione: un pivot UTC, per giorno [MISURATO: l'oracolo di §1.2 e' il suo test]

L'importatore ha **uno shift costante** (`InpShiftOre`, un intero) e il suo auto-calibratore **non funziona senza sovrapposizione** ([LETTO] `ABTG_ImportaStoricoEsterno.mq5` r.52-54, r.480, r.642). Un +5 costante, valido per il forex (8 su 8), **sbaglierebbe di un'ora i 132 giorni sfasati** (6,4% dei giorni, 15-20 per finestra [MISURATO]): sono i giorni in cui il feed e' a 03:00 NY. La conversione va quindi fatta **a monte**, per giorno, con le regole dei due calendari:

- NY -> UTC: **+5 h** se gli USA sono in ora solare, **+4 h** in ora legale;
- **Variante A "in fase"** (server = CET/CEST - 1 h = UTC + {0 inverno UE, +1 estate UE}): la cash 09:00 CET cade **sempre alle 08:00 server**; la prima barra del feed alle 07:00. E' quello che fanno le **sedie FTMO** (10:00 FTMO = 09:00 IT tutto l'anno) e quello che fa BCM d'estate. Con i parametri del contratto (`SessionHour=8`, `Close 17:30`) l'EA arma **alla cash** tutto l'anno.
- **Variante B "UTC+1 fisso"**: la regola dell'orologio BCM dal 2025 per gli indici. Estate: come A. **Inverno: la cash cade alle 09:00 server** e `SessionHour=8` arma **un'ora prima della cash** (prima barra del feed alle 08:00: **il range si costruisce sui primi 35 minuti del feed, 08:00-08:35 CET, che sono pre-cash**). E' quello che fara' BCM dal 26/10.

**Codice nuovo richiesto**: il convertitore con il DST per giorno e un autotest che usi come **oracoli le tabelle di §1.2** (non due numeri scelti: 2.055 giorni, 132 sfasati, 14 eccezioni nominate). Va scritto e passare i due cancelli. **Non lo scrivo qui.**

### 6.2 Quale variante e quando

- **A e' la primaria**: e' l'orologio delle sedie in campo (FTMO) e dell'estate BCM, e quello su cui il meccanismo e' stato progettato (arma alla cash). 24 passate (§8).
- **B e' condizionata a A**: parte **solo se** A ha dato un esito leggibile (nessun NULLO, banco almeno ZONA GRIGIA). Costa un secondo simbolo (`D30EUR_EXTB`, stessa barra, ora diversa) e 24 passate.

### 6.3 Che cosa B puo' dire sull'ora d'inverno, e che cosa no

Le due letture BCM sui due inverni misurati (R246, tick, DAX 770101): **d0 inverno** (arma 1h prima) PF **1,389**, 168 pos, 0,764/g; **d+1 inverno** (arma alla cash) PF **1,184**, 138 pos, 0,627/g. Sono **due inverni**, sotto 150 per la lettura d+1, e **d'estate il pre-cash ha perso** (PF 0,774 contro 1,108, DD 14,05% contro 5,55%) [LETTO]. La causa non e' dimostrata.

B contro A, **sugli stessi giorni d'inverno** (stessa curva dei prezzi, stesso feed, cambia solo l'ora a cui arma), da per-trade: **859 giorni d'inverno UE** nel feed totale, **~40% di ogni finestra** (95-111 feriali d'inverno per finestra, **637 nelle sei**), cioe' ~60-85 posizioni d'inverno per cella-finestra e ~450 per lato sulle sei finestre [DERIVATO: 637 x 0,70]. **~6 inverni equivalenti e 3 regimi** contro i 2 di BCM. Lettura pre-dichiarata [NUOVO]:
- **EFFETTO "il pre-cash d'inverno rende di piu'"**: dPF = PF(B, giorni d'inverno) - PF(A, giorni d'inverno) **>= +0,20 pooled sulle sei finestre, con segno positivo in almeno 4 su 6**;
- **EFFETTO "i due inverni BCM erano un caso"**: dPF **<= -0,15**, almeno 4 su 6 negativi;
- **NESSUN EFFETTO D'OROLOGIO** (da non confondere con il NULLO di cancello): |dPF| < 0,15 pooled;
- altrimenti ZONA GRIGIA. Il rapporto posizioni(B)/posizioni(A) d'inverno e' atteso in [1,05; 1,30] (BCM: 0,764/0,627 = 1,22).
- **Che cosa NON dice**: il feed e' di un altro broker, **il pre-cash di quel broker (08:00-09:00 CET) non e' quello di BCM**: spread, liquidita' e comportamento di un CFD fuori dalla cash sono diversi. **B illumina la firma del 25/10, non la decide.** Se la firma e' "riporta le sedie BCM alla cash d'inverno" o "lasciale come il backtest" resta tutta sua.

---

## 7. Che cosa e' gia' stato misurato, e che cosa NON si rifa (certificato di morte, regola 19/08)

La prova di regime **non e' il posto dove si riprovano i motori morti con parametri nuovi**: gira **due celle congelate** (770101, 770105), nessuna griglia, nessuna taratura. Quello che segue e' il perimetro di cio' che e' gia' misurato sul DAX, perche' nessuno lo rimisuri travestito.

| gia' misurato sul DAX | numero | fonte | cosa NON si rifa |
|---|---|---|---|
| **Retest long, 770101: altopiano di buffer e range** | 180 celle distinte (12 range x 15 buffer): **20 con IS e OOS >= 1,10**; a range 35 buffer 100-600 (6 contigue); vivo dentro l'altopiano; 4 manopole d'uscita "il default va bene" (TrailMode, TP1_R, TrailTF, CloseHour) | `APERTURE_DAX_MAPPA` §2.1 | buffer/range/uscita del retest long: **non si ritoccano** |
| **Retest short, 770105** | IS 0,965 / OOS 0,957, DD 12,31%: bocciata per rischio; nessuna leva d'uscita la ripara (ribaltamento IS/OOS); Supertrend H12 isolata 1,214/1,771 su 61/126 deal = "non c'e' una configurazione robusta" | R270b/d, R251, `LETTURA_R270` | uscita/soglie dello short: non si rifanno |
| **Breakout al tocco, due lati** | R12 48/48 negative OOS (Nasdaq); R45 0/48 (Londra); R97 0/4 n=135; ~210 celle ORB (R8-R13); DAX 138 passate PF mediano 0,77; **range 5-25 min: 0/4 OOS positive su DAX**; ORB 65' (R11) OOS 0,94-1,02, DD 17,5-29,7%, Spearman -1,0 | `CENSIMENTO_ORB` §0, §5; REGISTRO | breakout nudo: **chiuso**; il range 15' e' 0/4 OOS |
| **RANGE_FADE DAX** | 0/24 celle PF >= 1 (OOS 0,608-0,928, DD fino a 33,9%); 0/136 nell'analisi del 02/08; due lati OOS 0,772 | R42 | fade: chiuso per lato-insieme (per lato e TF M30/H1 **[NON MISURATO]**) |
| **DELAYED, GAPFILL, Live5m v1/v2, PreOpen RangeMode 1/2** | DELAYED nessuna cella batte il retest; GAPFILL 7/9 deal; Live5m 27/27 negative (OOS 0,857 DD 39,7%); RangeMode 1/2 OOS 0,861/0,884 su n 320-326 | `APERTURE_DAX_MAPPA` §2.4-2.5 | non si riaprono senza tesi nuova |
| **EMA200 sul DAX** | H1: **0/28** celle positive (best OHLC 0,92752; cella esatta 0,848, DD 14,53%); corto a tick R234b: M30 0,950 / H1 0,724 / H2 0,540 / H3 0,758 / H4 0,662; H4 lungo 30/30 positive OHLC (candidato, **non morto**) | `SCHEDA_LIVE_EMILIANO` C4; `PIANO_SEDIE_VIA_PIU_CORTA` | **Questo e' lo 0/28 del mandato**: e' EMA200, non il retest |
| **Gemelli europei del 770101** | `F40EUR` r138a IS 1,440 / OOS 0,770, DD OOS 11,82%: **FAIL**; `E35EUR` 15,3x e `E50EUR` 9,2x: **esclusi per costo** | `MAPPA_COSTO` §4.2, REGISTRO | non si rifanno |
| **770411** | long speculare 0/41 celle a tick con PF >= 1,00 (corr=1: 72 pos PF 0,883, DD 7,82%); `InpMgmtTF` 7 valori tutti < 1; ritardo del piazzamento IS sale / OOS crolla su 13-15 deal | R261a/b, `PRV_DAXAP_03` | long, TF, ritardi: non si rifanno |
| **Sonde di meccanismo** | lead-lag S&P->DAX 8/8 negative; overnight M27: merito si', **rischio no** (peggior notte -11,66%); salto statistico 16/16 sotto il cancello (EURUSD e DAX); sweep micro-pivot 8/8 sotto; compressione ATR 0/8; `VwapRevert` falsificato; R117 "relativo" D30EUR bocciato per rischio (DD 25,01%, giorno -5,20%) | REGISTRO; `GIACIMENTO` | non si rifanno |

**Certificato di morte, 5 punti, per le due sedie** (nessuna e' "morta"): **770101**: ① PF si ② n e DD si ③ uscita ad asse si ④ gemelli parziale (F40EUR FAIL, E35/E50 esclusi per costo) ⑤ TF inerte per sorgente. **770105**: ① si ② si ③ si ④ **mai** ⑤ inerte. Il round di regime **non chiude** ④ e ⑤: dichiararlo accanto a ogni esito.

**Il giacimento che questa specifica NON tocca** (regola 19/08): le manopole inerti misurate (`InpTrailFixedPts` con trailing PREVBAR: 160 passate -> 20 esiti; `InpRangeMinutes` con `RangeMode != 0`; DELAYED 15' = 30') e le mai messe ad asse (`InpPlaceHour/Min`, `InpSessionHour` del DAX, `InpMaxRangePts`, `InpOCTimeframe` a range 35, `InpAtrSLmult` del 770411) **non sono assi di questa prova**. Un asse su un'altra manopola e' un altro round, con la sua prova.

---

## 8. Attese, contro-esempi e via piu' corta

### 8.1 Attese scritte PRIMA dei numeri (con il perche')

Ancore: contratto 770101 PF 1,126/1,397 (IS contiene la discesa feb-apr 2025, DD 5,4%, quindi **non** e' un contratto solo-toro, ma e' un piccolo pezzo di orso); in fase d0 estate 1,108, d+1 inverno 1,184; 770105 PF 0,965/0,957 con estate 1,39 / inverno 0,90 (un solo regime); drift: il DAX 2011-2018 ha avuto due toro netti e tre discese.

| cella-classe | n atteso (pos.) | PF atteso (OHLC, lordo) | DD atteso (1%) | perche' |
|---|---|---|---|---|
| **770101 long, TORO (W4, W5)** | 130-210 per finestra | **1,10-1,60** (centro 1,30) | <= 9% (<= 1,25 x 7,23) | il toro 2025-26 ha dato 1,14-1,40 a tick; la deriva favorisce il long; OHLC gonfia (fattore 1,07-3,5: la banda e' larga apposta) |
| **770101 long, AVVERSE (W1-W3)** | 120-200 per finestra | **0,70-1,15** (centro **0,92**) | 8-20% (centro ~13%) | long con stop a range: la deriva negativa lo colpisce; ma l'IS BCM (con la discesa 2025) ha dato 1,126; nessuna misura diretta in un orso vero |
| 770101 long, LATERALE (W6) | 130-200 | 0,85-1,20 (centro 1,00) | <= 10% | |
| **770105 short, AVVERSE** | 120-200 | **0,95-1,60** (centro 1,20) | 6-15% | lo specchio incassa la deriva; il contratto e' stato misurato nel toro e rende 0,957 |
| **770105 short, TORO** | 130-200 | **0,55-1,00** (centro 0,80) | 8-22% | nel toro 2025-26 DD 12,3% (volatilita' di quel periodo [NON MISURATA qui]); le finestre toro del feed hanno volatilita' annua 13,2-13,4% [MISURATO] |
| 770105 short, LATERALE | 130-200 | 0,80-1,10 | <= 12% | |
| **Verdetto atteso M2 sul motore (coppia: long in AVVERSE, short in TORO)** | | **ZONA GRIGIA**: long in AVVERSE centro 0,92 (vicino alla soglia 0,90); short in TORO centro 0,80 (sotto 0,90 ma sopra 0,70). **DIREZIONALE** solo se uno dei due scende sotto 0,70 | | |
| G0-C (banco) | OHLC/tick posizioni 0,95-1,05 | scarto assoluto di PF 0,05-0,35 | DD OHLC/tick 0,85-1,20 | fattori misurati 1,07-1,11 sul 770411, 1,7-2,3 sui Live5m: la banda larga rende probabile ZONA GRIGIA |
| B contro A, d'inverno | posizioni B/A 1,05-1,30 | dPF(B-A) centro +0,05, banda [-0,15; +0,25] | | a n grande regredisce verso zero: i due inverni BCM (+0,20) sono sotto 150 |

### 8.2 I contro-esempi costruiti, e che cosa li smentisce

| attesa / strumento | l'altra spiegazione | numero che l'altra spiegazione produce | la banda la separa? |
|---|---|---|---|
| Oracolo dell'orologio | feed senza DST ("sempre 02:00") | spiega il 92,90% dei giorni; **0/132 sui giorni sfasati** | si, **solo** sul sottoinsieme sfasato (non sul totale): cancello G-clock definito li' |
| Oracolo dell'orologio | feed a NY fissa UTC-5 | 34,94% | si, largo |
| "il banco OHLC e' fedele" | il fattore e' un numero unico | 1,07 sul 770411, 3,51 sul SupRev Dow: **dipende dal meccanismo** | si: G0-C lo misura sulla sedia, non lo assume |
| "il costo di oggi in bp e' il costo giusto" | lo spread storico in bp era 2-4x | stop/spread scende a ~15-50x (58-101x diviso 2-4) e il PF netto cala | **non separabile** dal banco: dichiarato come limite superiore; non e' una soglia |
| "i regimi sono tre" | W2 e il Dow W4 sono lo stesso mercato | stessa epoca su due simboli | dichiarato; non si contano come due prove |
| n >= 150 | la frequenza non si trasporta (R113: 5-10x fra epoche) | n < 80 in >= 3 finestre | **e' un risultato**: "frequenza dipendente dal regime", e apre la domanda feed-vs-epoca che si separa solo con la sovrapposizione 2024-26 (passo condizionato) |
| "la prima barra alle 07:00 dopo la conversione" | un convertitore a shift costante | 0/132 sfasati | si |

### 8.3 La via piu' corta al numero, in ordine, e quanto costa

Tutto **solo sul PC di backtest `DESKTOP-H4D7CAJ`**; terminale `C:\Program Files\BCM Markets MT5 Terminal`, demo `50503392` **(lo stesso conto del piccolo del VPS, che ha una cartella omonima: due macchine, stesso conto)**; il censimento P0 del 05/10 17:10 ha trovato **MT5 chiuso, 103 grafici, 0 con EA, MaxBars 100.000.000, disco C: 326,69 GB liberi** [LETTO `DUKA_P0_20261005_171046/LETTURA.md`]. **Mai il VPS `VMI3047753` e nessuno dei suoi terminali** (reale `10105439` in `C:\BCM_Reale`, 100k `50504263` in `...-V3`, piccolo `50503392`, banco `50504400` in `C:\MT5_Backtest` spento, `C:\FTMO`, Pepperstone, Tickmill). Il terminale del PC e' lo stesso del piano Dow (P1-P2): **le due prove si serializzano**, una alla volta.

| # | passo | tester | tempo | stop |
|---|---|:-:|---|---|
| **P0** | oracolo, finestre, geometria, igiene: **FATTO oggi** (§1-§3), sola lettura sul mirror | no | zero | -- |
| **P1** | codice: convertitore con DST per giorno + autotest sugli oracoli di §1.2; driver di regime (modello R113: `RIGA_R113_REGIME_NASUSD.ps1`); lettore con le soglie di §5; **file prova** (12 per A: 6 finestre x 2 lati; 2 per G0-C); passano `controlla_prova.py`, `controlla_riga.py`, `controllo-preventivo` | no | lavoro: ore [NON MISURATO] | nessuna riga esce senza PASS |
| **P2** | ricostruire il CSV dagli zip in cache sul PC (conversione ~0,8 min) + **G-feed** + **G-clock** + **G-igiene** | no | minuti | G-feed / G-clock falliti = NULLO |
| **P3** | **import `D30EUR_EXT`** (1,72 M barre: ~0,3 min [DERIVATO da R113: 5,23 M barre in 0,8 min]; chiude e riapre MT5; scrive in `MQL5\Files` e nelle basi custom) | no | ~2-4 min con riavvii [NON MISURATO] | simbolo con digits/point diversi da `D30EUR`: stop |
| **P4** | **G0-C**: 8 passate OHLC sul nativo | si | 0,8-2,6 min | NON FEDELE: la prova si legge solo per rischio |
| **P5** | **A**: 6 finestre x 2 lati x 2 gemelle = **24 passate** (finestra singola, modello R113 oppure il trucco `FRAZIONEIS 0,001` di R252, [LETTO]) | si | 2,4-7,9 min | G0-A / G0-B falliti: NULLO |
| **P6** | lettura, referto, registro, push | no | -- | -- |
| *P7 (condizionato a P6)* | **B**: secondo simbolo `D30EUR_EXTB` + 24 passate | si | +0,6 min import, 2,4-7,9 min tester | solo se A e' leggibile |
| *P8 (opzionale)* | **controllo di scala**: buffer/offset scalati al livello di prezzo su W2 e W4 (2 finestre x 2 lati x 2 gemelle = 8 passate); un solo asse, un solo file per finestra-lato | si | 0,8-2,6 min | dichiarato **sensibilita'**, non cella nuova (D-C) |
| *P9 (condizionato)* | se la frequenza **crolla** (< 60% dell'atteso in >= 3 finestre): misura **feed-vs-epoca** con la sovrapposizione 2024-26 (riparare la convenzione oraria del DAX 2024-26, `RIGA_DIAGNOSI_DAX`) | si | [NON MISURATO] | richiede una firma nuova |

**Passate non condizionate: 8 + 24 = 32 -> 3,2-10,6 minuti** (0,05-0,18 ore). Con B: **56 -> 5,6-18,5 minuti** (0,09-0,31 ore). Con tutto (P8): **64 -> 6,4-21 minuti** (0,11-0,35 ore). **Tetto dichiarato 25 minuti di tester**, poi si ferma. Ritmi ancorati a numeri di casa: 0,101 min/passata tick M5 (R88, 136 passate in 13,7 min), 0,214 min/passata con compilazione e due avvii di MT5 (R242), 0,21-0,33 min/passata (R252: 24 passate in 5-8 min), 0,3 min/cella OHLC H1 su 16 anni (R113: 18 celle in 5,4 min); l'OHLC M1 di una finestra da ~214.000 barre dovrebbe stare nella parte bassa [INFERITO: **non e' mai stato cronometrato su D30EUR_EXT**]. **Il costo vero e' il lavoro di P1**, non la macchina.

**Che cosa si butta se il banco e' NON FEDELE (P4)**: P5 si legge solo per il rischio (comunque 3-11 minuti, ne vale la pena perche' il DD in un orso vero non c'e' da nessuna parte).

---

## 9. Firme di Claudio

### 9.1 Gia' valide (non servono)

| cosa | dove | che cosa autorizza | che cosa NON autorizza |
|---|---|---|---|
| **D-A..D-H** `STATO=FIRMATO` | `backtest_pipeline/risultati_archivio/STORICO_INDICI_CRITERI.md` §3 | fonte HistData; simboli `NASUSD,SPXUSD,D30EUR`; **D-C solo prova di regime a parametri congelati**; finestra 2010-2026; canarino 20 ore; **D-G il DAX 2010-2018 come sottoinsieme** (solo prova di regime); **D-H la finestra per simbolo (`D30EUR:2010-2018`)** | produrre contratti, promuovere sedie, incollare i 9 anni ai dati recenti; **non autorizza l'import** ne' sostituisce il cancello ZERO |
| i round sul PC di backtest | firma 21/09 *"si, i round sul pc di backtest"* | tester solo sul PC | -- |
| criterio di uscita delle sedie | `FIRME_2026-08-18.md` | rischio / merito / tagliando | -- |
| rischio, taglie, conto reale `10105439` | di Claudio, non toccate | -- | -- |

### 9.2 Ancora richieste (nessuna e' data; **non le do per scontate**)

Righe `@DECISIONE` **proposte** per `STORICO_INDICI_CRITERI.md` (non le scrivo li': e' un file cancello letto dai driver). Il token di stato e' scritto spezzato apposta (checklist 82): `STATO=[DA]_[FIRMARE]`. **Numerazione da coordinare con il piano Dow**, che propone `D-I` per il Dow: qui uso **D-J, D-K, D-L**.

```
@DECISIONE D-J CHIAVE=CANCELLO_DAX VALORE=STRUTTURA_OROLOGIO_SOSTITUTIVO STATO=[DA]_[FIRMARE]
@DECISIONE D-K CHIAVE=REGIME_DAX VALORE=770101,770105;W1..W6;A_poi_B;criteri_par5 STATO=[DA]_[FIRMARE]
@DECISIONE D-L CHIAVE=IMPORT_DAX_EXT VALORE=PC_BACKTEST_DOPO_DOW STATO=[DA]_[FIRMARE]
```

1. **D-J, il cancello sostitutivo** ("FIRMO CANCELLO DAX EXT"): il cancello ZERO e' **inapplicabile** sul DAX 2010-2018 (zero giorni in comune con BCM). Si firma che per `D30EUR_EXT` il cancello e' sostituito da **G-feed + G-clock + G-igiene** (§5.1), **dichiarato piu' debole** (calibra la struttura oraria interna, non il livello di prezzo contro BCM), con **etichetta in testa a ogni referto**: *"feed di un altro broker, non calibrato contro BCM: orologio verificato per struttura, prezzo e volatilita' NON verificati"*. **Cosa non firmi**: nessuna deroga alla D-C (parametri congelati, nessuna promozione), nessun uso dei 9 giorni di dicembre 2018 in convenzione 24 ore. **Da cosa dipende**: da niente di misurabile ancora; e' una regola scritta prima dei numeri. **Alternativa onesta**: non firmarlo e tenere il DAX fuori finche' non ci sono dati con sovrapposizione: il costo e' che il DAX resta senza nessun regime.
2. **D-K, criteri e finestre** ("FIRMO REGIME DAX"): le sei finestre (§3), la regola di etichettatura esclusiva (§3.1, **da armonizzare col piano Dow**), le due varianti A / B (§6), le soglie G0-C, R1-R2, M1-M4 e le parole di verdetto (§5). **Firmata a numeri non visti** (come "FIRMO R113"). **Cosa non firmi**: la taglia, le sedie, il feed come fonte di taratura.
3. **D-L, l'import e la coda** ("FIRMO IMPORT DAX EXT"): costruire il convertitore con DST per giorno (codice nuovo, passa i due cancelli), ricostruire il CSV sul PC dagli zip in cache, importare `D30EUR_EXT` (e `D30EUR_EXTB` solo per B) **sul PC di backtest `DESKTOP-H4D7CAJ`, terminale `C:\Program Files\BCM Markets MT5 Terminal`, demo `50503392`**, **dopo** il piano Dow sullo stesso terminale. Limite di risorse: disco **~1,5 GB** per due simboli (80 MB per anno e simbolo x 9 anni x 2, [INFERITO] da `STORICO_INDICI_CRITERI` §4; il disco ha 326,69 GB liberi) e tester **<= 25 minuti**. **Zero soldi**. **Cosa non firmi**: nessun VPS, nessun terminale con un conto vero.
4. **Opzionali, solo se servono**: (a) rilanciare la diagnosi e la riparazione della convenzione 2024-26 (P9) per separare **feed ed epoca** se la frequenza crolla; (b) Dukascopy `DEUIDXEUR` per il 2020 e il 2022 (§3.4): decisione di costo/tempo di Claudio, non la chiedo adesso.

---

## 10. Sezione finale: la riga che cambierebbe, e la domanda sull'ora d'inverno

### 10.1 La riga della tabella "anni / dati" del dossier che cambierebbe

Tabella "Quanti anni sono stati davvero misurati" di `report/DOSSIER_EXPERT_PER_EMILIANO_2026-10-05.md` (r.23-25) e colonna "anni / dati" della tabella dei contratti (r.77-79). **Oggi**:

| expert | anni misurati | tipo di dati | regimi coperti | ~10 anni e piu' regimi? |
|---|---|---|---|---|
| Apertura DAX, ritest, long | ~21 mesi (26/09/2024-30/06/2026) | tick reali del broker | toro; la discesa feb-apr 2025 dentro la finestra; orso / laterale / crollo NON MISURATI | **NO** |

**Se la prova passasse i cancelli e producesse un esito leggibile** (qualunque, positivo o negativo: il numero non e' il punto, e' l'aver misurato):

| expert | anni misurati | tipo di dati | regimi coperti | ~10 anni e piu' regimi? |
|---|---|---|---|---|
| Apertura DAX, ritest, long | ~21 mesi a tick (BCM) **+ 6 finestre da ~12 mesi di barre M1 esterne 2011-2018 (~6,0 anni di finestre, ~8 anni di calendario di feed)** | tick reali (21 mesi) + **barre M1 di un altro broker, modello OHLC, screening** | toro (3 finestre: BCM 2025-26, W4, W5), **orso (3: 2011-12, 2015-16, 2018)**, laterale (W6); **crollo Covid e orso 2022 NON MISURATI** su questo feed | **PARZIALE** (regimi si', anni ~7,8 < ~10; **mai SI**: il dossier chiede ~10 anni *e* regimi) |

Stessa riga per lo **short** (`770105`). Il **`770411` resta NO**: INAPPLICABILE sul feed (§2.3). E la colonna "stato" della tabella dei contratti **non cambia da sola**: D-C vieta che un `_EXT` muova uno stato.

**Se il banco e' NON FEDELE**, la riga cambia lo stesso nelle colonne "anni misurati" e "regimi coperti" ma **solo per il rischio**: "regimi: DD misurato in 3 orsi; merito NON ANCORA MISURATO".

### 10.2 La domanda aperta sull'ora d'inverno (decisione di Claudio entro il 25/10)

**Domanda**: dal 26/10 le sedie BCM a ora fissa (DAX: `InpSessionHour=8`; per `770411` anche il taglio alle 08:30) armano **un'ora prima** dell'apertura della cash; le sedie FTMO no (in fase). Si lasciano **come il backtest** (pre-cash d'inverno) o si **riportano alla cash**?

**Che cosa sa il repo, oggi** [LETTO `LETTURA_R246_INVERNO_2026-09-29.md`]: sul DAX 770101 il d0 d'inverno (pre-cash) ha dato **PF 1,389 su 168 pos** contro **1,184 su 138 pos** alla cash; ma d'estate il pre-cash ha dato **0,774 contro 1,108** (DD 14,05% contro 5,55%); la serie "come FTMO" ha DD **9,50%** contro il 6,06% del d0. Due inverni, sotto 150 alla cash; la causa non e' dimostrata.

**Che cosa aggiunge questa specifica**: la variante B (§6.3) mette **~6 inverni equivalenti e 3 regimi** sulla stessa domanda, con un'attesa e un controesempio scritti prima, e un'avvertenza: **il pre-cash del feed non e' il pre-cash di BCM**. **Non decide**: se la firma e' "riporta alla cash" o "lascia", e se si aspetta o meno il numero di B (che non arrivera' prima del 25/10 se P1 richiede giorni di codice e i due cancelli), e' di Claudio. **Oggi nessuna sedia DAX gira su un terminale BCM** (sospese 24-25/09 [LETTO; non rilette al 05/10]): la decisione e' per i numeri di contratto e per un rientro, non per ordini vivi. Sulla trial FTMO il problema non c'e' (e il cambio d'ora FTMO e' [NON MISURATO], misura del 25/10).
**Per il 770411** la domanda e' piu' dura: d'inverno su BCM la finestra d'ingresso (07:59-08:30 italiane) e' **tutta prima della cash**: la sedia diventa un'altra sedia. Su questo il feed 2010-2018 **non puo' dire niente** (§2.3).

---

## 11. Buchi dichiarati, e che cosa NON ho fatto

1. **Il cancello ZERO sul DAX non e' misurato e non e' misurabile su questi anni**: la calibrazione e' strutturale (orologio) e la **volatilita' / livello** del feed contro BCM e' **[NON MISURATA]**. E' il motivo della firma D-J.
2. **Spread effettivo del banco, commissione di D30EUR, slippage: [NON MISURATI]**. Il costo e' sovrapposto a valle e solo al primo ordine.
3. **L'EA esporta il per-trade su un simbolo custom in OHLC?** [NON VERIFICATO]. Da G-pertrade. Se no: peggior giornata e PF di classe e il trimestre CROLLO 2011 restano [NON MISURATI].
4. **Il tester e' cronometrato su D30EUR_EXT?** No. Il tempo e' una forbice di ritmi di casa.
5. **Il fattore OHLC -> tick sulle due sedie**: [NON MISURATO]; G0-C lo misura. Il G0-C presuppone che le **M1 native di `D30EUR` 2024.09-2026.06 siano complete sul PC** [NON VERIFICATO: R80 ha mostrato che senza M1 locali il tester le costruisce dai TF superiori e fa meno segnali; il referto `ABTG_StoricoScaricato.csv` dell'08/09 contiene `D30EUR`]: se mancano, le posizioni escono fuori banda e il G0-C da' NULLO.
6. **La conversione per giorno non esiste come codice**: lo scrive P1; l'oracolo e' pronto.
7. **L'importatore a spread per barra non esiste**: se il primo giro e' promettente, e' un passo successivo.
8. **Il CSV sul PC**: [NON MISURATO] se e dove esiste oggi (il CSV e' sul VPS; sul PC ci sono gli zip, [LETTO]). Il mirror non sostituisce la corsa vera: il cancello G-feed lo ricontrolla.
9. **R252 (770105 in fase) non e' tornato**: l'unica misura a tick che dice se il DD 12,31% dello short e' un artefatto dell'orologio. B di questa specifica non lo sostituisce (altro feed, altro banco).
10. **Livello di prezzo contro fonte pubblica**: la mia memoria delle chiusure di fine anno e' [FONTE ESTERNA] e non e' stata ricontrollata (wikipedia e un secondo sito bloccati dal proxy; la ricerca ha restituito i miei stessi numeri).
11. **Stato attuale delle sedie sui terminali BCM al 05/10 [NON RILETTO]**; **identita' del magic dello stop DAX short del 05/10 [INFERITO 770105]**.
12. **Il 2020 e il 2022 del DAX** non sono coperti (§3.4).
13. **Non ho scritto nessun file prova, nessuna riga, nessun driver, nessun codice MQL5 o PowerShell.** Il solo codice scritto e' lo script di sola lettura citato in testa.

---

## 12. Autoverifica dello Sviluppatore prima di consegnare (contro-esempi costruiti, esito)

- **Numeri del feed**: ricalcolati **due volte** con due script indipendenti (il primo a pezzi, il secondo consolidato in `regime_dax_misure_2026-10-05.py`): stessi 2.041/2.055, 132/132, 718, 1.909, stesse sei finestre. L'autotest dello script passa (feed sintetico "senza DST": 0/15 sui giorni sfasati; con DST: 15/15; sette casi di etichettatura incluso il LATERALE con DD 34%).
- **Righe di contratto**: ogni numero e' riletto in questa sessione da un file (R270c/d via `CENSIMENTO_ORB` V3-V4, i CSV del 770411 aperti da me, R246 via `LETTURA_R246_INVERNO`, la tabella del dossier Emiliano r.23-25 e r.77-79). Un numero non riaperto e' marcato [LETTO].
- **La premessa del mandato che era sbagliata** ("retest su DAX 0/28"): corretta e fonte data (§0 punto 13, §7).
- **Contro-esempio al mio stesso disegno**: il cancello G-clock basato sul totale (92,90% con l'ipotesi sbagliata) **non separerebbe**; l'ho spostato sul sottoinsieme sfasato. Il costo "40x" con lo spread assoluto **boccerebbe 5 finestre su 6 per colpa del prezzo dell'indice**, non del meccanismo: spostato in bp e dichiarato come limite superiore. L'etichetta di piano Dow **non e' esclusiva**: qui resa esclusiva e segnalata. Il CROLLO 2011 come finestra a se' sarebbe un **doppione di W1** (classe 1102): tolto.
- **Che cosa NON posso consegnare come verificato**: il secondo strato (`controllo-preventivo`) non e' stato eseguito da me; `controlla_prova.py` / `controlla_riga.py` non si applicano a un documento di specifica. **Non c'e' PASS. Niente esce.**

_Fonti principali (percorsi dal repo)_: `backtest_pipeline/risultati_archivio/STORICO_INDICI_CRITERI.md` · `report/STORICO_INDICI_SCARICATO_2026-09-10.md` · `report/DAX_STORICO_APERTO_2026-09-10.md` · `report/LO_STORICO_ESTERNO_MAPPA_2026-09-23.md` · `backtest_pipeline/risultati_archivio/DIAGNOSI_DAX_20260910_SOGLIA41/REFERTO_DIAGNOSI_DAX.txt` · `.../STORICO_INDICI_20260910_1356/` · `backtest_pipeline/dukascopy/histdata_m1.py` · `mql5/Scripts/ABTG_ImportaStoricoEsterno.mq5` · `report/APERTURE_DAX_MAPPA_2026-10-03.md` · `report/PARAMETRI_DAX_APERTURA_2026-10-01.md` · `report/CENSIMENTO_ORB_2026-09-29.md` · `report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` · `report/LETTURA_R246_INVERNO_2026-09-29.md` · `report/SEDIA_SHORT_DAX_FTMO_2026-09-25.md` · `report/OROLOGIO_BCM_2026-09-24.md` · `backtest_pipeline/prove/PROVA_REGIME_CRITERI.md` · `backtest_pipeline/risultati_archivio/R113_CRITERI.md`, `R113_REFERTO.md` · `backtest_pipeline/risultati_archivio/REFERTO_ROUND71_FINESTRA_CAMPIONE_PIENO.md` · `report/PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md` · `report/PIANO_LATI_REGIME_2026-09-09.md` · `backtest_pipeline/REGISTRO_TEST.md` · `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` (classi 178, 1102, 1103, 1104; 82; 89) · `report/DOSSIER_EXPERT_PER_EMILIANO_2026-10-05.md` · `report/SCHEDA_LIVE_EMILIANO_2026-10-05.md` · `backtest_pipeline/risultati_archivio/DUKA_P0_20261005_171046/LETTURA.md` · `mql5/Presets/` (770101, 770411, FTMO/).
