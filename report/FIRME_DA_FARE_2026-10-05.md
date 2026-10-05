# FIRME DA FARE: il foglio unico per Claudio (05/10/2026)

Autore: `architetto-prop`. Perimetro: **SOLA CARTA**. Nessun backtest, nessun file prova, nessuna riga di lancio, nessun terminale, preset, EA, taglia o conto toccato. Non tocco le tre specifiche: le leggo e le cito (HEAD alla partenza `33a8a3e9`, branch `lavoro`).
Fonti lette per intero: `report/REGIME_NASDAQ_SPX_SPEC_2026-10-05.md`, `report/REGIME_DAX_SPEC_2026-10-05.md`, `report/PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md` (tutte e tre con PASS, tre letture ciascuna), piu' `backtest_pipeline/prove/PROVA_REGIME_CRITERI.md`, `report/FIRME_2026-10-05.md`, `report/OROLOGIO_BCM_2026-09-24.md`, `report/DOSSIER_EXPERT_PER_EMILIANO_2026-10-05.md`, `report/TRIAL_14_GIORNI_CRITERI_2026-10-01.md`.
Etichette: [MISURATO] letto da un file o ricalcolato da me in questa sessione; [DERIVATO] aritmetica su numeri misurati; [INFERITO] ragionamento mio; [NON MISURATO] il dato non c'e'.
**Stato del cancello di questo foglio**: prima passata `controllo-preventivo` (05/10) = **FAIL, corretto nel testo** (precedenza alternativa che toglieva il CROLLO al DAX, durata e stato di P1, "se non firmi", soglie "identiche"); tabelle 1.4-1.6 ricalcolate con codice proprio e confermate. Seconda passata indipendente `controllo-preventivo` (05/10) = **PASS** con correzioni di forma (limite dichiarato dentro il testo da firmare, stato del cancello di P1, punto 7 rimesso in elenco); ricalcolati di nuovo da zero DAX W1 e i suoi tagli, Nasdaq W1/W2/W2r, gli 8 tagli del crollo 2020, le 25 varianti e il confronto 92/123 giorni: tutto coincide.
**Tutto quello che e' scritto qui e' una PROPOSTA**: l'ordine delle firme, le raccomandazioni, perfino il nome della regola unica. Rischio, taglie, conto reale `10105439` e spese restano tuoi, e nessuna firma di questo foglio li tocca.

---

## 0. In sette righe: che cosa ti chiedo, in ordine

1. **Prima di tutte le altre**, una firma nuova: **«FIRMO REGOLA REGIMI»** (sezione 1). Le tre specifiche danno nomi diversi ai regimi sugli STESSI dati; senza una regola comune la prova di regime sul Nasdaq si riduce a una finestra avversa sola. La regola unica usa **le stesse soglie che le tre regole gia' hanno** (nessun numero nuovo) e decide solo precedenza e lettura.
2. **Il risultato onesto della riprova su 34 finestre**: sul **DAX** la regola tiene **3 finestre avverse distinte** (obiettivo raggiunto). Sul **Nasdaq** tiene **3 etichette avverse ma 2 episodi distinti** (la finestra "crollo 2020.02-04" sta dentro l'anno 2020): **l'obiettivo "3 distinte" NON e' raggiunto, e non e' un difetto della regola**: con le sole finestre ammesse dal costo (2020, 2021, 2022) gli episodi avversi del Nasdaq sono due. Dettaglio in 1.5.
3. **Poi** (dopo che le tre specifiche sono riallineate alla regola: circa mezza giornata di lavoro, [INFERITO]): **F-A** (Nasdaq, obbligatoria), **D-J, D-K, D-L** (DAX). Tester totale per queste: **~17-47 minuti** (Nasdaq 14-36, DAX 3-11).
4. **Il Dow aspetta la TUA mossa**: P0 e' fatto (05/10); P1 (riconversione dell'orologio dalla cache, reimport, sonda su 9 giorni, controllo negativo) e' **una riga gia' scritta** (`backtest_pipeline/righe/RIGA_LANCIA_DUKA_P1.txt`, pin `980042ad`) che aspetta solo che tu la lanci sul PC di backtest (stato del cancello: tre letture del verificatore e una rilettura della sessione principale sull'ultima modifica, di solo testo, tutte PASS il 05/10; quest'ultimo PASS non e' scritto in un commit: l'ultimo commit della riga, `9ba1f80c`, chiede ancora la rilettura; la riga ti arriva a parte, con il suo bersaglio in testa); ✏️ **durata corretta dal cancello 05/10**: non "~10-20 minuti" (stima del piano) ma **non misurata nel suo insieme, fino a ~8 ore e mezza** come dichiara la riga stessa (due import con tetto 240 minuti ciascuno; la sola riconversione il 03/09 ha preso ~12 minuti), e per tutta la corsa nessun MT5 aperto su quel PC. **Solo dopo l'esito di P1** si firma **F1** (uso dei dati e tetto: fino a 250 ore di PC acceso).
5. **Quattro firme opzionali** del Nasdaq (F-A2, F-B, F-C, F-D) e due del DAX: la mia raccomandazione e' **F-B si (insieme a F-A, prima dei numeri), le altre non adesso**.
6. **Domande che sono SUE** (sezione 3): taglia 2,00% e muro 10%; ora d'inverno DAX entro il **25/10** e USA entro il **02/11**; la sedia `771514` (e' attaccata?); M1 "2 su 3" contro "tutte" del DAX (io dico tutte); dashboard SuperWave 4.00/4.1 e Dow nella lista.
7. **La mail a Emiliano**: se tutto passa, la colonna "anni/dati" va da **NO a PARZIALE** per quattro righe (Nasdaq, DAX long, DAX short, EMA200 Dow), **mai SI**; da 10 NO / 2 PARZIALE / 0 SI a 6 NO / 6 PARZIALE / 0 SI. Stima per rimandarla: **~11-14/10 con Nasdaq + DAX** (Dow "in corso"), **~13-22/10 con il Dow CORE-A**, **~15-26/10 con il Dow nucleo intero** (sezione 4, stime [INFERITO]).

**Se non firmi R-0**: le tre specifiche restano con tre regole diverse; quelle del Nasdaq e del DAX dicono di armonizzarle **prima** della prima firma (`REGIME_NASDAQ_SPX_SPEC` §4.1, `REGIME_DAX_SPEC` §3.1; il piano Dow non lo scrive, ma la sua D-I e' una delle tre): quindi F-A e D-K non si possono firmare cosi' come sono, nessuna prova di regime parte e la mail a Emiliano resta com'e' (10 NO / 2 PARZIALE / 0 SI). **Se non firmi una delle altre obbligatorie**, si ferma solo il suo indice (Nasdaq F-A; DAX D-J/D-K/D-L; Dow F1) e la sua riga del dossier resta NO. Nessuna firma mancante tocca le sedie in campo.
**Nessuna firma di questo foglio tocca rischio, taglie, conto reale `10105439` o spese**, anche dove la colonna "cosa NON autorizza" non lo ripete.

---

## 1. LA REGOLA UNICA DEI REGIMI, da firmare PRIMA di tutte le altre

### 1.1 Il problema (misurato, non a parole)

Le regole in circolazione sono TRE: **D-I** (Dow, non esclusiva, due letture del "crollo in 3 mesi"), **F-A** (Nasdaq: D-I piu' la precedenza CROLLO > LATERALE) e **D-K** (DAX: esclusiva, la lunghezza della finestra decide). Sugli stessi numeri danno nomi diversi (tabelle "stessi dati, etichette diverse" in `REGIME_NASDAQ_SPX_SPEC` §4.1 e `REGIME_DAX_SPEC` §3.1). Esempi: il Nasdaq 2022 e' **MISTO** per D-I e F-A (ORSO + CROLLO insieme) e **ORSO** per D-K; il Nasdaq 2020 anno e' **CROLLO** per D-I e F-A e **MISTO** per D-K. Nessuna delle tre regole tiene tutte le avverse del Nasdaq. E' un difetto di nome che diventa un difetto di prova: la regola dei due banchi (`PROVA_REGIME_CRITERI` §4D: "un solo periodo avverso e' un aneddoto") non troverebbe la sua seconda finestra.

### 1.2 Il testo da firmare («FIRMO REGOLA REGIMI»)

> **Regola unica di etichettatura dei regimi.** Per ogni finestra di una prova di regime (Dow, DAX, Nasdaq, S&P) si calcolano, sulle **chiusure H1 del feed della prova**: **R** = rendimento dalla prima all'ultima chiusura H1 della finestra; **DD** = massimo drawdown picco-fondo dentro la finestra; **DD3m** = il massimo drawdown dentro la finestra con picco e fondo a **non piu' di 92 giorni di calendario** l'uno dall'altro.
> L'etichetta e' **la PRIMA** di queste quattro che scatta, **in quest'ordine di precedenza**:
> 1. **CROLLO** se DD3m >= 25%;
> 2. **ORSO** se R <= -5% **e** DD >= 15%;
> 3. **LATERALE** se |R| <= 5%;
> 4. **TORO** se R >= +10% **e** DD < 15%.
> Se nessuna scatta: **MISTO**.
> Le soglie percentuali sono quelle gia' scritte nelle tre regole (D-I, F-A, D-K) e la durata del crollo e' quella di D-I e F-A (3 mesi, contati come 92 giorni di calendario): **nessuna soglia nuova**. La **lunghezza della finestra NON decide l'etichetta**. La classe **AVVERSE = CROLLO + ORSO**; **MISTO non entra in nessuna classe senza una firma nuova**. Le altre regole che sarebbero scattate si scrivono accanto come nota (esempio "CROLLO +ORSO") e non cambiano ne' etichetta ne' classe.
> Due finestre sono **distinte** solo se non hanno nessuna data in comune: una finestra dentro un'altra e' una lente di rischio sulla stessa prova, non una seconda prova.
> Se la serie H1 non esiste ancora (Nasdaq prima del passo P0a: oggi solo le aperture delle 09:30 New York) l'etichetta e' **PROVVISORIA**, si rifa' su H1 prima di leggere qualunque cella, e se cambia la finestra **si rinomina, non si scarta**.
> La regola dei due banchi (`PROVA_REGIME_CRITERI` §4D, "stessa direzione in ORSO e CROLLO") si legge **"stessa direzione in almeno due finestre AVVERSE distinte"**; M1 e M2 si leggono sulla classe AVVERSE.
> **Limite dichiarato**: la precedenza e' stata scelta conoscendo i **prezzi** delle finestre (le loro etichette erano gia' nelle specifiche), **non i risultati di nessuna cella** (nessuna cella e' ancora girata su nessuna delle tre prove). La frase sulla regola dei due banchi qui sopra e' una **lettura** del criterio del 14/08, non la sua lettera: per nome, nessuna precedenza da' "ORSO e CROLLO" a tutti e due gli indici (1.7).
> **Non retroattiva**: i round gia' giudicati restano com'erano.

**Cosa NON firmi**: nessuna soglia nuova; nessun criterio di rischio o di merito cambiato (R1-R3, M1-M4 restano delle specifiche); nessuna finestra aggiunta o tolta; nessun download, backtest o terminale; niente su taglie, rischio, conto reale, spese.
**Attenzione ai nomi**: «FIRMO REGOLA REGIMI» (la regola) non e' «FIRMO REGIME NASDAQ» ne' «FIRMO REGIME DAX» (le prove). Scrivi la parola intera.

### 1.3 Le scelte, dichiarate una per una (e che cosa ho scartato)

| punto | scelta | perche' | alternativa scartata e perche' |
|---|---|---|---|
| **Soglie** | quelle di D-I, F-A e D-K: le **percentuali sono identiche nelle tre regole**, la durata del crollo no (3 mesi in D-I e F-A, 4 in D-K: riga sotto; i 92 giorni sono la conversione di "3 mesi" gia' usata dalle tabelle di controllo del cancello, `REGIME_DAX_SPEC` §3.1): crollo = calo >= 25% in <= 3 mesi; orso = R <= -5% e DD >= 15%; toro = R >= +10% e DD < 15%; laterale = \|R\| <= 5% | La definizione di crollo "calo >= 25% in <= 3 mesi" nasce nel piano Dow D-I (`PIANO_REGIME_DOW` §1.3, scritto il 05/10 prima di qualunque numero Dow) e le altre due regole la ripetono. `PROVA_REGIME_CRITERI` (14/08) da' solo le finestre (CROLLO 2020.02-04, CROLLO_ANNO 2020), non numeri. **Non ho scelto nessuna soglia guardando i dati: le ho prese gia' scritte.** | nessuna |
| **3 mesi, non 4** | 92 giorni di calendario | D-I e F-A dicono 3; solo D-K dice 4 (ed e' il suo cancello di durata). 3 e' anche il piu' stretto: rende il CROLLO piu' difficile, non piu' facile. **Controllo fatto DOPO aver visto i dati, quindi non e' il motivo**: con 123 giorni invece di 92 nessuna etichetta delle finestre dichiarate cambia (DAX W2 23,3% come a 92; W3 16,2%; Nasdaq invariate) [MISURATO da me] | 4 mesi |
| **Lettura (i)** del crollo | "esiste dentro la finestra un calo >= 25% con picco e fondo a <= 92 giorni" | E' la lettura che le tabelle di controllo delle specifiche gia' usano. Il rischio vero e' se il calo e' accaduto, non se e' il piu' lungo | **Lettura (ii)** "il calo MASSIMO dura <= 3 mesi": scartata perche' fa sparire il crollo dentro un orso lungo. Nasdaq W1: il DD massimo dura 282 giorni, ma dentro c'e' **-26,4% in 79 giorni**; DAX W1: DD massimo 133 giorni, dentro **-33,6% in 66 giorni** [MISURATO] |
| **La lunghezza non decide** | nessun gate di durata | Con D-K il nome dipende da dove si taglia la finestra: spostando inizio e fine di +-15 e +-30 giorni (25 varianti), il DAX W1 con D-K diventa LATERALE in 4 casi su 25; con la regola unica resta CROLLO **25 volte su 25** (1.6) | D-K "esclusiva per durata": fa dell'anno 2020 un MISTO (+46% con un calo del 27,6% in 32 giorni) |
| **Precedenza CROLLO > ORSO > LATERALE > TORO** | dal piu' grave al meno grave | Il nome decide che rischio si legge: una finestra che contiene un crollo va letta come prova di crollo, qualunque altra cosa contenga. **Argomento misurato: invarianza al taglio.** Lo stesso crollo del Nasdaq 2020 (picco 20/02, fondo 23/03): tagliato al fondo (2020.02.01-03.23, R -22,3%) e' CROLLO con questa regola, ORSO con l'ordine opposto; tagliato al 30/04 (R -0,1%) e' CROLLO con tutte e due. Con l'ordine opposto il nome del crollo dipende da dove finisce la finestra, cioe' da un'arbitrarieta' | **ORSO > CROLLO** (la strada che `REGIME_NASDAQ_SPX_SPEC` §4.1 lasciava aperta): scartata per l'invarianza; manterrebbe i nomi di casa (Nasdaq 2022 "ORSO") e darebbe lo stesso conteggio di avverse, **ma toglierebbe al DAX il suo unico CROLLO** (W1 -> ORSO: tre ORSO, zero CROLLO; 1.7). Se preferisci i nomi di casa e' una tua scelta: cambia solo il nome, non quanti sono |
| **CROLLO > LATERALE** | CROLLO prima di LATERALE | Una finestra che finisce dove e' partita ma ha un calo >= 25% non e' piatta: e' un crollo con recupero (Nasdaq 2020.02-04: R -0,1%, DD 27,6%) | lasciare MISTO (D-I) |
| **AVVERSE** | CROLLO + ORSO; la nota "+ORSO" resta come informazione | Cosi' Nasdaq 2022 si chiama CROLLO (+ORSO) senza perdere il fatto che e' anche un orso lungo | |

### 1.4 La riprova, su tutte le finestre gia' misurate nelle tre specifiche

Come si legge: ogni riga ha **R / DD / DD3m**, la durata in mesi (serve a D-K) e l'etichetta con le cinque regole: **D-I (i)** e **D-I (ii)** (le due letture del Dow), **F-A** (scritta "lettura (i) / lettura (ii)"), **D-K**, e la **regola unica**. Ricalcolato da me, non copiato: Nasdaq dalla serie delle aperture 09:30 New York (`backtest_pipeline/risultati_archivio/ANATOMIA_APERTURE_20260826/ANATOMIA_APERTURE_PERGIORNO_NASUSD.csv`, nel repo; **DD sottostimato**: serie delle aperture, non delle chiusure H1); DAX dalle chiusure H1 del feed HistData (`backtest_pipeline/caccia_strategie/biblioteca/sonde_esterne/regime_dax_misure_2026-10-05.py`, stesso mirror pubblico della specifica). **Tutti i numeri coincidono con quelli scritti nelle specifiche** (26,4%, 27,6%, 33,6%, 23,3%, 14,6%, W1-W6 del DAX) e tutte le etichette delle vecchie regole coincidono con le loro tabelle di controllo.

**Nasdaq** (finestre della specifica `REGIME_NASDAQ_SPX_SPEC` §4.1-§4.2; W1 = 2022.01-10, W2 = 2020 anno, W2r = 2020.02-04, W3 = 2021, W4 = laterale 2015-16, W5 = 2018, W6 = 2013-14, W7 = vecchia 2011-12; le due "sotto" non sono finestre dichiarate: stanno nella tabella della specifica come controllo):

| finestra | periodo | mesi | R / DD / DD3m | D-I (i) | D-I (ii) | F-A (i) / (ii) | D-K | **REGOLA UNICA** |
|---|---|---:|---|---|---|---|---|---|
| W1 2022 | 2022-01-01..2022-10-31 | 10.0 | -30.7% / 36.6% / 26.4% (DD max in 282 g) | MISTO | ORSO | MISTO / ORSO | ORSO | **CROLLO** (+ORSO) |
| W2 2020 anno | 2020-01-01..2020-12-31 | 12.0 | +46.0% / 27.6% / 27.6% (DD max in 32 g) | CROLLO | CROLLO | CROLLO / CROLLO | MISTO | **CROLLO** |
| W2r 2020.02-04 | 2020-02-01..2020-04-30 | 3.0 | -0.1% / 27.6% / 27.6% (DD max in 32 g) | MISTO | MISTO | CROLLO / CROLLO | CROLLO | **CROLLO** (+LATERALE) |
| W3 2021 | 2021-01-01..2021-12-31 | 12.0 | +26.9% / 9.2% / 9.2% (DD max in 18 g) | TORO | TORO | TORO / TORO | TORO | **TORO** |
| W4 laterale 2015-16 | 2015-01-01..2016-06-30 | 18.0 | +2.6% / 17.4% / 17.3% (DD max in 97 g) | LATERALE | LATERALE | LATERALE / LATERALE | LATERALE | **LATERALE** |
| W5 2018 | 2018-01-01..2018-12-31 | 12.0 | -1.5% / 22.7% / 22.7% (DD max in 86 g) | LATERALE | LATERALE | LATERALE / LATERALE | LATERALE | **LATERALE** |
| W6 2013-14 | 2013-01-01..2014-12-31 | 24.0 | +57.6% / 9.9% / 9.9% (DD max in 43 g) | TORO | TORO | TORO / TORO | TORO | **TORO** |
| W7 vecchia 2011-12 | 2011-01-01..2012-12-31 | 24.0 | +16.0% / 15.2% / 15.2% (DD max in 24 g) | MISTO | MISTO | MISTO / MISTO | MISTO | **MISTO** |
| sotto 2011.07.15-10.04 | 2011-07-15..2011-10-04 | 2.7 | -12.5% / 15.2% / 15.2% (DD max in 24 g) | ORSO | ORSO | ORSO / ORSO | MISTO | **ORSO** |
| sotto 2018.09.20-12.31 | 2018-09-20..2018-12-31 | 3.4 | -15.9% / 22.7% / 22.7% (DD max in 86 g) | ORSO | ORSO | ORSO / ORSO | MISTO | **ORSO** |
| 2017 | 2017-01-01..2017-12-31 | 12.0 | +31.8% / 4.9% / 4.9% (DD max in 28 g) | TORO | TORO | TORO / TORO | TORO | **TORO** |
| 2019 | 2019-01-01..2019-12-31 | 12.0 | +40.2% / 10.1% / 10.1% (DD max in 40 g) | TORO | TORO | TORO / TORO | TORO | **TORO** |
| IS BCM | 2024-09-26..2025-06-09 | 8.4 | +7.3% / 24.3% / 24.3% (DD max in 48 g) | MISTO | MISTO | MISTO / MISTO | MISTO | **MISTO** |
| OOS BCM | 2025-06-10..2026-06-30 | 12.7 | +36.5% / 11.3% / 11.2% (DD max in 153 g) | TORO | TORO | TORO / TORO | TORO | **TORO** |

**S&P 500** (numeri della specifica, `SPXUSD_EXT` e' ancora in frigo; DD sempre < 25%, quindi il CROLLO non puo' scattare; DD3m non ricalcolato, i CSV stanno sul PC di backtest):

| finestra | R / DD | D-I, F-A | D-K | **REGOLA UNICA** |
|---|---|---|---|---|
| vecchia 2011-12 | +10,3% / 21,1% | MISTO | MISTO | **MISTO** |
| sotto 2011-07-15 -> 10-04 | -17,8% / 19,6% | ORSO | MISTO | **ORSO** |
| 2013-14 | +43,5% / 9,1% | TORO | TORO | **TORO** |
| laterale 2015.01-2016.06 | +0,3% / 14,6% | LATERALE | LATERALE | **LATERALE** |
| 2017 | +19,6% / 3,0% | TORO | TORO | **TORO** |
| 2018 | -6,8% / 19,6% | ORSO | ORSO | **ORSO** |
| sotto 2018-09-20 -> 12-31 | -14,4% / 19,6% | ORSO | MISTO | **ORSO** |

**DAX** (finestre della specifica `REGIME_DAX_SPEC` §3.1-§3.2: W1 = 2011.05-2012.04, W2 = 2015.04-2016.03, W3 = 2018.01-12.14, W4 = 2013, W5 = 2016.07-2017.06, W6 = 2014; le altre sono le finestre scartate o di controllo della specifica):

| finestra | periodo | mesi | R / DD / DD3m | D-I (i) | D-I (ii) | F-A (i) / (ii) | D-K | **REGOLA UNICA** |
|---|---|---:|---|---|---|---|---|---|
| W1 2011-12 | 2011-05-01..2012-04-30 | 12.0 | -10.6% / 34.3% / 33.6% (DD max in 133 g) | MISTO | ORSO | MISTO / ORSO | ORSO | **CROLLO** (+ORSO) |
| W2 2015-16 | 2015-04-01..2016-03-31 | 12.0 | -16.4% / 29.6% / 23.3% (DD max in 307 g) | ORSO | ORSO | ORSO / ORSO | ORSO | **ORSO** |
| W3 2018 | 2018-01-01..2018-12-14 | 11.4 | -16.2% / 21.8% / 14.6% (DD max in 321 g) | ORSO | ORSO | ORSO / ORSO | ORSO | **ORSO** |
| W4 2013 | 2013-01-01..2013-12-31 | 12.0 | +23.6% / 9.8% / 9.8% (DD max in 33 g) | TORO | TORO | TORO / TORO | TORO | **TORO** |
| W5 2016.07-2017.06 | 2016-07-01..2017-06-30 | 12.0 | +27.1% / 5.9% / 5.9% (DD max in 15 g) | TORO | TORO | TORO / TORO | TORO | **TORO** |
| W6 2014 | 2014-01-01..2014-12-31 | 12.0 | +1.8% / 16.3% / 15.0% (DD max in 118 g) | LATERALE | LATERALE | LATERALE / LATERALE | LATERALE | **LATERALE** |
| Q3 2011 | 2011-07-01..2011-09-30 | 3.0 | -26.6% / 33.6% / 33.6% (DD max in 66 g) | MISTO | MISTO | MISTO / MISTO | CROLLO | **CROLLO** (+ORSO) |
| 2011.04-2012.03 | 2011-04-01..2012-03-31 | 12.0 | -1.9% / 34.3% / 33.6% (DD max in 133 g) | MISTO | LATERALE | CROLLO / LATERALE | LATERALE | **CROLLO** (+LATERALE) |
| 2011 anno | 2011-01-01..2011-12-31 | 12.0 | -15.6% / 34.3% / 33.6% (DD max in 133 g) | MISTO | ORSO | MISTO / ORSO | ORSO | **CROLLO** (+ORSO) |
| 2012 | 2012-01-01..2012-12-31 | 12.0 | +29.4% / 17.8% / 17.8% (DD max in 81 g) | MISTO | MISTO | MISTO / MISTO | MISTO | **MISTO** |
| 2017 | 2017-01-01..2017-12-31 | 12.0 | +12.5% / 8.1% / 8.1% (DD max in 70 g) | TORO | TORO | TORO / TORO | TORO | **TORO** |
| 2018 al 28/12 | 2018-01-01..2018-12-28 | 11.9 | -18.2% / 24.2% / 17.2% (DD max in 338 g) | ORSO | ORSO | ORSO / ORSO | ORSO | **ORSO** |
| 2015.01-2016.06 | 2015-01-01..2016-06-30 | 18.0 | -1.2% / 29.6% / 23.3% (DD max in 307 g) | LATERALE | LATERALE | LATERALE / LATERALE | LATERALE | **LATERALE** |

**Dow**: le finestre W1-W4 del piano Dow **non sono ancora misurate** (lo storico Dukascopy su disco copre solo 2024.10-2025.06): l'etichetta la da' il passo P5 con la regola unica, dopo la firma. Non ne scrivo nessuna a memoria.
**Cosa dice la riprova**: la regola unica non cambia nessuna finestra "benigna" (TORO e LATERALE restano tali in tutte le righe), cambia solo le finestre che contengono un calo >= 25% in 92 giorni, che diventano CROLLO (con la nota dell'altra etichetta) invece di MISTO o di un nome che dipendeva dalla lunghezza.

### 1.5 Quante avverse tiene (il risultato che mi hai chiesto)

Finestre del nucleo di ogni specifica; fra parentesi gli **episodi distinti** (nessuna data in comune).

| | D-I (i) | D-I (ii) | F-A (i) | F-A (ii) | D-K | **REGOLA UNICA** |
|---|---|---|---|---|---|---|
| **Nasdaq** (W1, W2, W2r) | 1 (1) | 2 (2) | 2 (**1**: W2 e W2r si sovrappongono) | 3 (2) | 2 (2) | **3 etichette (2 distinti)** |
| **DAX** (W1, W2, W3) | 2 (2) | 3 (3) | 2 (2) | 3 (3) | 3 (3) | **3 (3)** |

- **DAX: obiettivo raggiunto.** Tre avverse distinte e disgiunte: **2011-12 CROLLO (+ORSO)**, **2015-16 ORSO**, **2018 ORSO**. Con la regola unica il numero e' quello che le altre regole danno solo in alcune letture.
- **Nasdaq: obiettivo NON raggiunto, e lo dico.** Tre finestre avverse (W1 2022 CROLLO +ORSO, W2 2020 CROLLO, W2r 2020.02-04 CROLLO), ma W2r **sta dentro** W2: **gli episodi distinti sono due**, il crollo del 2020 e l'orso del 2022. La regola unica non crea un terzo episodio: lo conferma **in ogni lettura e per ogni taglio** (D-I (i) e F-A (i) ne tengono uno solo).
- **Perche' nessuna regola puo' farne tre sul Nasdaq**: le finestre ammesse dalla frontiera del costo (`stop >= 40 x spread`) sono **2020, 2021, 2022** (`REGIME_NASDAQ_SPX_SPEC` §4.3) e fra queste i regimi avversi sono due, perche' il 2021 e' TORO (+26,9%, DD 9,2%). Le uniche altre candidate avverse sono **sotto-finestre scelte guardando il prezzo**: 2018-09-20 -> 12-31 (ORSO, -15,9% / -22,7%, 71 giorni, costo 23,7x) e 2011-07-15 -> 10-04 (ORSO, DD 15,2% sul bordo del 15%, 58 giorni, costo 7,5x). **Non le conto**: scelte a posteriori, sotto il pavimento di costo, con campioni minuscoli. Il 2018 intero e' LATERALE per la regola (-1,5%), il 2019 e' TORO (+40,2%), il 2023 e' escluso (feed malato). L'unica terza avversa "naturale" e' l'S&P 2018 (ORSO, -6,8% / -19,6%), ma l'S&P e' bloccato da tre ostacoli indipendenti (F-C, costo, campione).
- **Cosa guadagna comunque la regola unica**: il conteggio delle avverse **non dipende dal bordo del 25%**. Nasdaq W1 ha DD3m 26,4% sulla serie delle aperture, a **1,4 punti** dalla soglia: se il ricalcolo su H1 (passo P0a) desse meno di 25%, W1 diventerebbe ORSO e resterebbe AVVERSA. Stesso discorso per il DAX W2 (DD3m 23,3%, ORSO a 1,7 punti dal bordo: se scattasse sarebbe CROLLO, sempre avversa).
- **Cosa cambia per la regola dei due banchi sul Nasdaq**: due episodi distinti bastano (e' la lettera "almeno due"); la **nota onesta** per Emiliano e' che sono **un crollo e un orso con dentro un crollo**, non "tre regimi avversi".

### 1.6 I contro-esempi che ho costruito per rompere la regola (e come sono andati)

1. **Il taglio**: lo stesso crollo del 2020 con la fine della finestra spostata (2020.02.01 -> 03.23, 04.30, 06.30, 12.31; e partendo dal 2020.01.01): la regola unica dice **CROLLO in tutti i sei casi**; l'ordine opposto (ORSO > CROLLO) darebbe ORSO nei due casi tagliati al fondo [MISURATO].
2. **Le finestre benigne non diventano avverse**: ho spostato inizio e fine di +-15 e +-30 giorni (25 varianti per finestra) su DAX W1-W6 e su Nasdaq W1, W2, W2r, W3. **Le quattro finestre non avverse (DAX W4, W5, W6; Nasdaq W3) non diventano mai avverse in nessuna delle 100 varianti.** Le avverse restano avverse in **25 su 25** (DAX W1, W2, W3; Nasdaq W1, W2) tranne W2r, che lo e' in **21 su 25**: le 4 varianti che tagliano via la gamba del crollo (e' giusto cosi', non contiene piu' il crollo). ✏️ **Aggiunto dal cancello 05/10 (rifatto con codice proprio, stessi conteggi)**: l'invarianza vale per la **classe** AVVERSE, **non per ogni nome**: il DAX W6 resta LATERALE solo in **13 su 25** varianti (12 MISTO) e il Nasdaq W3 resta TORO in **20 su 25** (5 MISTO); con D-K e' identico. Il laterale del DAX e' quindi un nome fragile al taglio, e lo si legge sapendolo.
3. **Il bordo del 25%** (1.5): non cambia il conteggio.
4. **La regola non e' stata costruita sui dati**: le soglie erano gia' scritte, la scelta della precedenza e' argomentata dall'invarianza e non dall'esito. Ammetto il limite: i **prezzi** li avevamo visti (le etichette di W1-W6 del DAX e di W1-W3 del Nasdaq sono nelle specifiche), i **risultati delle celle no**: nessuna cella e' ancora girata su nessuna delle tre prove, quindi la firma resta prima dei numeri che contano.

### 1.7 Limiti noti della regola (dichiarati, non nascosti)

- **LATERALE "sporco"**: una finestra piatta con un calo grosso ma lento si chiama LATERALE (DAX 2015.01-2016.06: R -1,2%, DD 29,6%, DD3m 23,3%). Non e' una finestra del nucleo; se mai lo diventasse, il suo DD si legge comunque (valvola E.3: il rischio e' un fatto a qualunque n).
- **Il CROLLO e' "contiene un crollo"**, non "e' un crollo": l'anno 2020 (+46%) e' CROLLO, come l'aveva gia' chiamato la casa (CROLLO_ANNO, `PROVA_REGIME_CRITERI` E.6).
- **Nasdaq su aperture**: etichette PROVVISORIE finche' P0a non le rifa' su H1.
- **Una frase della regola tocca un criterio congelato**: la lettura della regola D di `PROVA_REGIME_CRITERI` §4D ("stessa direzione in ORSO e CROLLO") come "in almeno due finestre AVVERSE distinte". Per me e' la generalizzazione dell'intento ("un solo periodo avverso e' un aneddoto"), non un ammorbidimento. Ma e' una lettura, e la dichiaro. Nel testo del 14/08 ORSO e CROLLO sono **finestre fissate per data** (§3: ORSO = 2022.01-10, CROLLO = 2020.02-04), non etichette calcolate; e' la regola "si rinomina, non si scarta" delle specifiche a farle diventare nomi misurati. ✏️ **Corretto dal cancello 05/10 (qui c'era scritto che con l'altra precedenza si tornava alla lettera: vale per un indice solo)**. Il conto per tutte e due le precedenze, sui nuclei [MISURATO dal cancello, stesso codice di 1.4]: con **CROLLO > ORSO** il DAX ha un CROLLO (W1) e due ORSO, il Nasdaq due CROLLO (W1 +ORSO, W2) e **nessun ORSO di nome**; con **ORSO > CROLLO** il Nasdaq ha ORSO (W1) e CROLLO (W2), ma il DAX ha **tre ORSO e nessun CROLLO** (W1 diventa ORSO). **Nessuna precedenza soddisfa "ORSO e CROLLO" per nome su tutti e due gli indici**; la lettura "due avverse distinte" e' soddisfatta da tutte e due (Nasdaq 2 episodi, DAX 3). Cambiare precedenza non evita la lettura: sposta il problema da un indice all'altro (sul DAX la specifica la adattava gia', §5.3 M1: "e' un adattamento, non la regola di casa alla lettera"). Se preferisci la lettera, l'alternativa onesta e' dirlo prima di firmare e accettare che uno dei due indici non abbia la regola D soddisfabile.
- **Nessun gate di durata**: una finestra di due settimane con +10% e DD < 15% sarebbe TORO. Le finestre le decidono le specifiche (la piu' corta, W2r, e' di 3 mesi).

### 1.8 Che cosa cambia nelle altre firme (coordinamento, da fare PRIMA di firmarle)

Se firmi la regola unica, **le tre specifiche vanno riallineate con poche righe** e ripassare dal cancello (le fa chi le ha scritte: io non le tocco). Nei testi che firmerai, la frase "regola di etichettatura" va letta come la regola unica:
- **Dow** (`PIANO_REGIME_DOW` §1.3 e testo di F1): togliere le quattro regole non esclusive, rimandare alla regola unica; W1-W4 restano com'erano.
- **Nasdaq** (`REGIME_NASDAQ_SPX_SPEC` §4.1, §7.2 M2 "ORSO" -> "AVVERSE", §9 voce F-A): W1 si chiama CROLLO (+ORSO).
- **DAX** (`REGIME_DAX_SPEC` §3.1, §5.3 M2, §9.2 D-K): via l'esclusivita' per durata; **e M1** se scegli "tutte" (domanda 4 della sezione 3).
- **Regola D di `PROVA_REGIME_CRITERI`**: letta "almeno due finestre avverse distinte" (e' scritta dentro la regola unica).
- **R-0 non tocca niente di firmato**: la F2 del Dow (05/10) riguarda il cancello zero dei dati, non l'etichettatura.

---

## 2. LA TABELLA DELLE FIRME, in ordine di dipendenza

Una riga per firma. Il **testo esatto** delle firme gia' scritte nelle specifiche e' copiato fedelmente in appendice (non riscritto). Costi dalle specifiche: **ore di tester** e/o **ore di PC acceso**, mai "notti". **Zero soldi** in tutte le firme da chiedere adesso: nessun servizio a pagamento. Tutte le prove girano **solo sul PC di backtest `DESKTOP-H4D7CAJ`** (terminale `C:\Program Files\BCM Markets MT5 Terminal`, demo `50503392` **di quel PC**: attenzione, il numero di conto e' lo stesso del piccolo del VPS, due macchine, stessa cartella omonima); **mai il VPS `VMI3047753` e nessuno dei suoi terminali** (firma del 21/09).

| # | id e **parola esatta** | cosa autorizza | cosa NON autorizza | costo | dipende da | obbl./opz. | raccomandazione (da socio) |
|---|---|---|---|---|---|---|---|
| gia' | **F2 «FIRMO CANCELLO DK DOW»** (firmata il 05/10, `FIRME_2026-10-05.md`) | P0-P1 del Dow: riconversione dei 222 giorni gia' scaricati con orologio UTC+1 fisso, sonda su 9 giorni, controllo negativo | nessun download; nessuna deroga se `2024.11.20` resta fuori | zero download; PC di backtest fino a ~8 ore e mezza (la riga P1, durata non misurata nel suo insieme; il piano stimava ~10-20 min) | - | firmata | non si rifa' |
| **0** | **R-0 «FIRMO REGOLA REGIMI»** (sezione 1) | la regola unica di etichettatura, per Dow, DAX, Nasdaq, S&P | soglie nuove, criteri di rischio/merito, finestre, download, taglie, soldi | zero (e' un criterio); circa mezza giornata di lavoro per riallineare le tre specifiche [INFERITO] | niente | **obbligatoria** | **SI, oggi, per prima**: costa una frase e toglie un conflitto che altrimenti ci accompagna in ogni referto. E' scritta prima di qualunque numero di cella |
| **1** | **F-A «FIRMO REGIME NASDAQ»** | criteri di §4-§7 della specifica Nasdaq (finestre del nucleo 2020-22, cella X0 senza filtro volumi, canarini P0c/P0d, gate P0b/P1a/P1b, R1/R3 con R2 solo controllo di banco, M1-M2, parole di verdetto, esclusione per costo <= 2018 e del 2023) applicati a `770260`, `770250` (rilettura), `970913` (A5) | promozione o effetti sulle sedie; la misura della sedia vera col filtro volumi (non testabile su barre); S&P; rischio, taglie, conto reale | tester **8-20 min** (`770260`, 34 passate), nucleo Nasdaq completo **14-36 min** (63 passate); il costo vero e' scrivere ~15 file prova e quattro lettori che oggi non esistono | R-0 (e riallineamento §4.1/§7.2) | **obbligatoria** (per il Nasdaq) | **SI, subito dopo R-0**: e' la prova piu' economica (meno di mezz'ora di tester) e porta la riga Nasdaq da NO a PARZIALE. Il filtro volumi della sedia viva NON si misura qui (sul feed il volume e' un conteggio di minuti): lo dico a Emiliano |
| **2** | **D-J «FIRMO CANCELLO DAX EXT»** | per `D30EUR_EXT` il cancello zero e' sostituito da G-feed + G-clock + G-igiene, **dichiarato piu' debole** (calibra la struttura oraria, non il prezzo contro BCM) | deroghe alla D-C; le 8 giornate di dicembre 2018 in convenzione 24 ore | zero | niente di misurabile | **obbligatoria** (per il DAX) | **SI**: l'alternativa onesta e' non firmarlo e lasciare il DAX senza nessun regime. Non allarga niente: scrive un cancello sostitutivo con l'etichetta "feed di un altro broker, non calibrato" in testa a ogni referto |
| **3** | **D-K «FIRMO REGIME DAX»** | le sei finestre, le due varianti d'orologio A/B, G0-C, R1, controllo di banco R2, M1-M4, parole di verdetto; **sui numeri non visti** | taglia, sedie, il feed come fonte di taratura | zero di suo (i passaggi sono sotto D-L) | R-0, D-J | **obbligatoria** (per il DAX) | **SI, ma con M1 "su tutte e tre"** (domanda 4): la specifica oggi scrive "2 su 3", **piu' largo della B di casa**. Se scegli "tutte", la riga va corretta e ripassata dal cancello **prima** della firma |
| **4** | **D-L «FIRMO IMPORT DAX EXT»** | convertitore con DST per giorno (codice nuovo, passa i cancelli), CSV dagli zip in cache, import di `D30EUR_EXT` (e `_EXTB` solo per B) sul PC di backtest, **dopo** il piano Dow sullo stesso terminale | nessun VPS, nessun terminale con un conto vero | tester **3-11 min** (32 passate; con B 56 passate = 6-19 min; tetto 25 min); disco ~1,5 GB; import ~2-4 min | D-J, D-K | **obbligatoria** (per il DAX) | **SI**, e parte in coda: finche' il convertitore non esiste (lavoro, non macchina) non occupa il PC |
| **5** | **F1 «FIRMO DK DOW REGIME»** | `U30USD_DK` come solo prova di regime a parametri congelati per `771531`, finestre W1-W4, K1-K3/R1-R3/M1-M2, download e import **solo sul PC di backtest**, <= 12 GB, <= 250 ore di PC acceso, stop se K1 fallisce o il canarino proietta oltre il tetto | tarare un parametro; archiviare la sedia; promuovere; rischio, taglie, conto reale, FTMO, VPS | crawl **90-348 ore di PC acceso** per il nucleo (**W1 sola 20-77, CORE-A 63-244**, W4 27-105; **il tetto di 250 h sta DENTRO la forbice**) + tester ~30-60 min; zero soldi | **esito di P1** (K0 passato), R-0, F2 | **obbligatoria** (per il Dow) | **NON ADESSO: dopo P1.** Poi si', ma scegli il perimetro: **CORE-A** (2019.12-2022.10, tre finestre di colpo, 63-244 h) e' la scelta minima che puo' dare due avverse distinte nel Dow (se P5 conferma le etichette: 2020 e 2022); W1 sola (20-77 h) non basta per la regola dei due banchi. Il PC deve poter stare acceso a lungo (domanda 6 della sezione 3) |
| 6 | **F-B** (parola proposta da me: **«FIRMO NASDAQ SCALA»**; la specifica non ne da' una) | traslazione di scala dei soli input in punti per W4-W7 (laterale 2015-16, 2018, 2013-14, 2011-12) | e' un'**estensione con riserva**, non evidenza di costo; **mai SI** per aritmetica | tester **3,6-8,8 min** (16 passate) | F-A | opzionale | **SI, ma insieme a F-A e prima dei numeri**: costa 5 minuti, e firmarla dopo aver visto il nucleo sarebbe peggio. E' l'unica via per coprire il **laterale** del Nasdaq. **Non aggiunge nessuna finestra avversa** (sotto la regola unica W4 e' LATERALE, 2018 LATERALE, W6 TORO, W7 MISTO). Porta a ~11 anni di finestre ma di una cella traslata, senza filtro volumi, a costo benigno |
| 7 | **F-A2** (parola proposta da me: **«FIRMO NASDAQ X1»**) | cella sostituta X1 (filtro ATR calibrato sul nativo) | si fa solo se la fedelta' passa; e' una cella mai misurata | 4 passate native (la X1 su EXT non e' quantificata nella specifica) | F-A + esito di fedelta' | opzionale | **NO per ora**: ha senso solo dopo il nucleo, e solo se la strada B (volumi veri) non si fa |
| 8 | **F-C** (parola proposta da me: **«FIRMO RIESAME SPX»**) | riesame di `SPXUSD_EXT` con misura nuova pre-dichiarata (stessa finestra di sovrapposizione 2024.09-2026.07, simmetrica sui tre simboli) | non apre da solo l'S&P: se passa solo cambiando finestra, la decisione resta tua | zero tester per la misura; se sblocca, 20 passate (4,5-11 min) | F-A (non strettamente) | opzionale | **NO, non serve alla mail**: l'unica sedia S&P (`771514`) e' mai operata, sta gia' sotto la frontiera del costo (~13-39x, centrale ~25x) e ha 27-40 posizioni/anno: il merito per regime non e' misurabile comunque |
| 9 | **F-D** (parola proposta da me: **«FIRMO NASDAQ DUKASCOPY»**) | strada B: Dukascopy `USATECHIDXUSD` con volumi veri, l'unico modo di misurare la **sedia vera** `770260` nei regimi | nessuna spesa; non si firma prima dell'esito del Dow | **62-244 ore di PC acceso** + ~0,2-1 h di tester | F-A, esito di F1 (K1 del Dow) | opzionale | **NON ADESSO**: dopo che il Dow DK ha dimostrato che il feed regge. E' la meta' vera (la sedia viva con i suoi volumi) ma e' un secondo giro |
| 10 | DAX opz. (a): rilancio della riparazione della convenzione 2024-26 (P9) | separare feed ed epoca se la frequenza crolla | - | `[NON MISURATO]` | D-K + esito di A | opzionale | non si chiede adesso: nasce solo da un esito |
| 11 | DAX opz. (b): Dukascopy `DEUIDXEUR` per il 2020 e il 2022 | coprire il crollo Covid e l'orso 2022 sul DAX | - | decisione di costo/tempo tua | D-K | opzionale | non si chiede adesso (nel `grxeur` 2020-23 e' un altro strumento) |

**Quante firme in tutto: 12** (6 obbligatorie: R-0, F-A, D-J, D-K, D-L, F1; 6 opzionali: F-B, F-A2, F-C, F-D e le due opzioni DAX), **piu' F2 gia' firmata**. **Ordine di dipendenza proposto**: R-0 -> riallineo delle specifiche -> {F-A (+F-B), D-J -> D-K -> D-L} -> (tua mossa P1) -> F1 -> opzionali. Tester complessivo delle sole obbligatorie: **~1-2 ore** [DERIVATO: Nasdaq 14-36 min + DAX 3-11 + Dow 30-60]; il tempo vero e' il crawl del Dow e il lavoro di codice e cancelli.

---

## 3. LE DOMANDE APERTE CHE SONO SUE

Nessuna e' decisa qui. Le ho scritte con i fatti accanto, perche' tu possa decidere.

1. **La taglia 2,00% sulla trial e il muro statico del 10%.** Le prove di regime la **informano**, non la cambiano: Nasdaq R3 (DD <= 10% a 2,00%), Dow R3 (tarato su 0,65%: a 2,00% il muro del 10% corrisponde a un DD a 1% di circa 4,7% col metro lineare, e il contratto OOS fa gia' 7,83%), DAX (il DD x 2 si scrive accanto, non e' un criterio). Fatto di contesto: il 03/10 hai detto **"lasciamo tutto cosi'"** per i 14 giorni della trial (nessuna modifica di taglie, Guardian o sedie); restano aperte, a tua decisione, la taglia sul DAX e l'eventuale chiusura delle posizioni da parte del Guardian oltre soglia. **Non e' decisa qui.**
2. **L'ora d'inverno.** BCM sugli indici e' UTC+1 fisso: d'inverno armare alle `08:00` (DAX) o `14:30` (USA) fa partire le sedie a ora fissa **un'ora prima della cash**. Il cambio cade il **26/10/2026 per il DAX** e il **02/11/2026 per gli USA** (`OROLOGIO_BCM_2026-09-24.md` §0 punto 5): **decisione tua entro il 25/10**. Le prove di regime aiutano: la variante B del DAX (~6 inverni equivalenti, 637 feriali d'inverno contro i 2 del backtest BCM) illumina la domanda **ma non la decide**, e non arrivera' prima del 25/10 se il codice richiede giorni; sul Nasdaq nessuna misura dell'inverno BCM nativo e' girata (R274 non girato) e la settimana 26-30/10 di FTMO non e' coperta da nessuna misura. **Non e' deciso qui.**
3. **La sedia `771514`** (EMA200 H4 SPXUSD, solo long): **mai operata** (0 posizioni dal 01/08 contro ~20 attese per i gemelli H4, `REGISTRO_TEST.md` r.2635). **Domanda: e' ancora attaccata a un grafico?** Se si': su quale terminale? Per la regola dei terminali il bersaglio e' il demo `50503392` sul VPS (cartella `BCM Markets MT5 Terminal`, **non** il `50503392` del PC di backtest che ha lo stesso numero di conto). Il controllo si fa in sola lettura con la stringa che stampa PID, titolo e cartella: **la prepara la sessione principale e passa dal cancello**; qui non c'e' nessuna stringa da incollare.
4. **M1 del DAX: "2 su 3" o "tutte".** La specifica DAX scrive "PF di classe AVVERSE >= 0,90 **e** PF >= 0,90 in almeno 2 finestre su 3", dichiarato **piu' largo della B di casa** (`PROVA_REGIME_CRITERI` §4B: "nelle finestre avverse il PF deve restare >= 0,90", cioe' in ognuna), mentre il Nasdaq e il Dow chiedono **in ogni avversa**. **Scelta tua.** **La mia raccomandazione e' "tutte e tre"**: e' la lettera del criterio di casa, e il nostro motto e' non ammorbidire. Costo della scelta: piu' facile che il DAX non passi; ma un criterio che promuove con una finestra avversa sotto 0,90 e' proprio quello che il metodo esiste per impedire. Se scegli "tutte", la specifica DAX §5.3 va corretta e ripassata dal cancello prima di firmare D-K.
5. **Dashboard SuperWave 4.00 contro 4.1, e il Dow nella lista** (`OMBRA_SUPERWAVE_SPEC_2026-10-05.md` §6.2 punti 1 e 6; `docs/SUPERWAVE_V41_NOTE.md`). **Non c'entra con la prova di regime e non blocca nessuna firma di questo foglio**: la tengo qui solo per non perderla. Domande: quale versione gira sul tuo grafico (la 4.00 ricevuta: confermata il 01/10 dalla tua schermata di Input, niente `InpMA4` ne' `InpShowCross`; oppure la 4.1 da provare a video), e se aggiungere `U30USD` come simbolo extra (non e' nella lista di default).
6. **Il PC di backtest per giorni.** Il crawl del Dow occupa il PC **90-348 ore** (nucleo intero) o **63-244** (CORE-A): per quanto tempo lo puoi lasciare acceso e connesso, e va bene che il tester giri in mezzo (le prove Nasdaq e DAX durano minuti)? Se no, la scelta e' fra CORE-A, W1 sola (non basta per i due banchi) o la via delle candele (se esiste: P3).

---

## 4. IL QUADRO A UNA PAGINA

**Cosa e' pronto.** Tre specifiche con PASS (tre letture ciascuna): **Nasdaq/S&P** (nucleo 63 passate, ~14-36 min), **DAX** (32 passate non condizionate, ~3-11 min; 770411 dichiarata INAPPLICABILE sul feed, non morta), **Dow** (F2 gia' firmata; P0 fatto il 05/10 alle 17:10 sul PC di backtest: disco C: 326,69 GB liberi, cache `raw` 222 giorni su 222 completi, MT5 chiuso, 0 grafici con EA). Piu' la regola unica proposta in questo foglio.
**Cosa aspetta la tua mossa.** (1) Firmare **R-0**. (2) **P1 del Dow**: il codice (`--dst fisso`, sonda su 9 giorni, controllo negativo) e' scritto e la riga e' pronta (`RIGA_LANCIA_DUKA_P1.txt`, pin `980042ad`, fino a ~8 ore e mezza); la lanci tu su una **finestra PowerShell sul PC di backtest `DESKTOP-H4D7CAJ`** (terminale `C:\Program Files\BCM Markets MT5 Terminal`, demo `50503392` di quel PC; non si tocca il VPS ne' nessuno dei suoi terminali). Dopo P1, **F1**.
**Cosa cambia nella riga "anni/dati" del dossier per Emiliano** (regola del dossier: **SI** = circa 10 anni o piu' **e** piu' regimi misurati con esito leggibile; **PARZIALE** = una delle due; **NO** = nessuna). Se tutto passa:

| riga del dossier | oggi | se passa tutto | perche' non SI |
|---|---|---|---|
| Apertura Nasdaq, ritest, due lati | NO | **PARZIALE** (regimi si', ~4,6 anni totali: 21 mesi a tick + ~34 mesi di barre 2020-22) | anni < 10; il filtro volumi non e' testabile su barre; laterale NON MISURATO senza F-B. Con F-B ~11 anni di finestre ma di una cella traslata: **mai SI per aritmetica**, lo si chiede a Emiliano. Se il rischio R1 e' violato: resta **NO** con "bocciata in regime a barre" |
| Apertura DAX, ritest, long | NO | **PARZIALE** (regimi si', ~7,8 anni) | anni < 10 |
| Apertura DAX, ritest, short | NO | **PARZIALE** | idem |
| EMA200 Dow H1 (`771531`) | NO | **PARZIALE** (~5,8 anni: 21 mesi + 34 + 14 di W4) [DERIVATO da me: il piano Dow non scrive la riga] | anni < 10 |
| MaxMin DAX short | NO | **NO** | INAPPLICABILE sul feed (box notturno fuori dal feed, filtro S&P in frigo, ~13 posizioni a finestra) |
| Apertura Dow ritest, SuperWave Dow, ORB Dow | NO | **NO** | la prova del Dow e' sulla cella `771531`, non su queste |

Il **conteggio** passa da **10 NO / 2 PARZIALE / 0 SI** a **6 NO / 6 PARZIALE / 0 SI**. Nessuna riga diventa SI da queste prove, e nessuno stato di sedia cambia da solo: la D-C vieta che un dato esterno muova uno stato.
**Quando si puo' rimandare la mail** [INFERITO, stime con le loro ipotesi]. Le ore di tester sono minuti; **quello che decide le date e' il lavoro di codice e cancelli (non cronometrato) e il crawl del Dow**. Ipotesi: firme il 05-06/10; riallineo delle specifiche mezza giornata; codice e cancelli ~3-5 giorni per Nasdaq + DAX in parallelo; PC acceso senza piu' blocchi del server di Dukascopy di quanto gia' misurato (4,1-16,0 minuti per giorno di storico).

| scenario | cosa c'e' nella mail | stima |
|---|---|---|
| **S1** Nasdaq + DAX, Dow "in corso" | righe Nasdaq, DAX long e short; Dow dichiarato in misura | **~11-14/10** |
| **S2** + Dow CORE-A | anche EMA200 Dow con le tre finestre 2020-22 | **~13-22/10** (P1 e F1 entro ~08/10, poi crawl 2,6-10,2 giorni continui, poi conversione, K1/K2, round e lettura ~2-3 giorni) |
| **S3** + Dow nucleo intero (con W4 laterale) | anche il laterale del Dow | **~15-26/10** (crawl 3,7-14,5 giorni continui; **oltre il tetto di 250 h = 10,4 giorni la firma F1 ferma il crawl**) |

**La mia proposta** (e' una proposta): **non aspettare il Dow completo**. Rimandare la mail con S1 e dichiarare il Dow "in misura": la domanda a Emiliano e' di metodo (anni e regimi), e le righe Nasdaq e DAX gia' cambiano la risposta. Ma e' una scelta tua. Due paletti del calendario: il **25/10** (decisione sull'ora d'inverno del DAX) cade a ridosso della fine di S2 e dentro S3; il **02/11** (USA) subito dopo.

---

## 5. COSA MANCA E CHI LO PORTA

| buco | chi lo porta | domanda esatta |
|---|---|---|
| le tre specifiche citano ciascuna la propria regola di etichettatura | `cercatore-parametri` | riallineare `PIANO_REGIME_DOW` §1.3 e F1, `REGIME_NASDAQ_SPX_SPEC` §4.1/§7.2/§9, `REGIME_DAX_SPEC` §3.1/§5.3/§9.2 alla regola unica (1.8), e ripassare dal cancello; **solo dopo la firma R-0** |
| M1 del DAX "2 su 3" contro "tutte" | Claudio (domanda 4) poi `cercatore-parametri` | correggere §5.3 della specifica DAX se la scelta e' "tutte" |
| un PASS su questo foglio | sessione principale / `controllo-preventivo` | verificare le tabelle di 1.4 e 1.5, il conto delle 12 firme, i testi in appendice contro le specifiche |
| etichette Nasdaq su H1 (oggi su aperture 09:30) | passo P0a della specifica Nasdaq | rifare le finestre su chiusure H1 del simbolo importato, dopo F-A |
| etichette Dow | passo P5 del piano Dow | misurarle sul feed DK con la regola unica |
| P1 del Dow | Claudio (esecuzione) | la riga `RIGA_LANCIA_DUKA_P1.txt` (pin `980042ad`) e' scritta: si lancia sul PC di backtest, PC acceso fino a ~8 ore e mezza, nessun MT5 aperto nel frattempo |
| nessuna richiesta di materiale esterno | - | la regola usa solo dati gia' nel repo: nessun lavoro per `cacciatore-config-prop` ne' `analista-trascrizioni` |

---

## 6. COSA HO CONTROLLATO, E COSA NO

**Controllato** (Sviluppatore piu' autoverifica; il cancello a due strati resta da fare):
- **Ricalcolo indipendente delle finestre.** Nasdaq dal CSV `ANATOMIA_APERTURE_PERGIORNO_NASUSD.csv` (14 finestre, tutti i numeri coincidono con la specifica: W1 -30,7% / 36,6% / 26,4%, W2 +46,0% / 27,6%, W2r -0,1% / 27,6%, W3 +26,9% / 9,2%, LATERALE +2,6% / 17,4%, IS/OOS BCM +7,3% / 24,3% e +36,5% / 11,3%); DAX dalle 1.718.805 barre M1 del mirror HistData scaricate con lo script di repo (13 finestre, tutte coincidenti: W1 -10,6% / 34,3% / 33,6%, W2 23,3%, W3 14,6%, "2015-16 a 18 mesi" = 2015.01.01-2016.06.30). Le etichette delle tre vecchie regole le ho **riapplicate col codice** e coincidono con le due tabelle di controllo delle specifiche.
- **Contro-esempi**: taglio del crollo 2020 (1.6 punto 1); 100 spostamenti di inizio/fine (punto 2); bordo del 25% (punto 3).
- **Testi delle firme**: i blocchi in appendice sono copiati dalle specifiche per numero di riga e verificati come sottostringa dei file sorgente.
- **Costi** e **dipendenze** riletti nelle specifiche (Nasdaq §8-§9, DAX §8.3 e §9.2, Dow §3.4 e §5).

**NON fatto / aperto, dichiarato**: (il cancello `controllo-preventivo` su questo foglio e' stato fatto dopo questa sezione: FAIL corretto, poi PASS alla seconda passata, riga di stato in testa); il ricalcolo delle finestre S&P (restano numeri della specifica; DD < 25% quindi il crollo non puo' scattare); le etichette del Dow (non misurate); la durata del lavoro di codice e cancelli (le stime di calendario sono [INFERITO], non misure); la parola esatta di F-A2, F-B, F-C, F-D (non esistono nelle specifiche: le ho proposte io); il fatto che le specifiche vadano riallineate prima di firmare F-A, D-K, F1; il costo reale del tempo di tester (le specifiche stesse lo danno come forbice dalle misure di casa, mai cronometrato su `NASUSD_EXT` ne' `D30EUR_EXT`).

---

## APPENDICE: I TESTI ESATTI DELLE FIRME (copiati dalle specifiche, non riscritti)

Fa fede il testo qui sotto, e per le firme gia' scritte il testo nella specifica indicata. I rimandi `§` si riferiscono alla specifica di provenienza. Dove le specifiche citano "la regola di etichettatura", dopo R-0 vale la regola unica (1.8).

### A1. F1 (da `PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md` §5)

> **«FIRMO DK DOW REGIME»**: autorizzo l'uso di `U30USD_DK` (Dukascopy `USA30IDXUSD`) come **solo prova di regime a parametri congelati** per la cella `771531`, con le finestre W1-W4, la regola di etichettatura e i criteri K1-K3/R1-R3/M1-M2 di `report/PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md` (estendendo D-B/D-C al Dow come `@DECISIONE D-I`), e autorizzo il download e l'import **solo sul PC di backtest `DESKTOP-H4D7CAJ`** entro **<= 12 GB di disco occupato (e solo se P0 ne misura almeno altrettanti liberi), <= 250 ore di PC acceso e stop (nuova decisione) se la calibrazione K1 fallisce o se il canarino proietta piu' del tetto**.

### A2. F-A, F-A2, F-B, F-C, F-D (da `REGIME_NASDAQ_SPX_SPEC_2026-10-05.md` §9, tabella "Nuove firme richieste": colonne "che cosa" e "perche' serve")

**F-A** (obbligatoria): **"FIRMO REGIME NASDAQ"**: i criteri di §4-§7 (finestre del nucleo, regola di etichettatura, cella derivata X0 senza filtro volumi con `-Spread 180`, canarini P0c/P0d, gate P0b e P1a/P1b, R1 e R3 con **R2 come controllo di banco e non come criterio** (✏️ corretto dal cancello 05/10 prima dei numeri, §7.2: la firma F-A lo riceve cosi'), M1-M2, parole di verdetto, esclusione per costo delle finestre <= 2018, esclusione del 2023), applicati a `770260`, `770250` (rilettura) e `970913` (A5)
*Perche' serve:* i criteri si firmano prima dei numeri (R113 lo aveva fatto): "FIRMO FRIGO NASUSD" ammette il simbolo, **non** questi criteri ne' il delta di cella

**F-A2** (opzionale): cella sostituta X1 (filtro ATR calibrato sul nativo, §6.1 strada A')
*Perche' serve:* misurerebbe qualcosa di piu' vicino alla sedia vera su EXT

**F-B** (opzionale): traslazione di scala dei soli input in punti per W4-W7 (§4.3)
*Perche' serve:* e' l'unico modo di avere un laterale (2015-16) e piu' di 10 anni totali

**F-C** (opzionale): riesame di `SPXUSD_EXT` con **misura nuova pre-dichiarata** (§6.4)
*Perche' serve:* senza, nessuna cella S&P puo' girare su EXT (D-C punto 3 vale ancora per SPX)

**F-D** (opzionale): strada B: Dukascopy `USATECHIDXUSD` come prova di regime con volumi veri
*Perche' serve:* l'unico modo di misurare la **sedia vera** nei regimi

### A3. D-J, D-K, D-L e opzionali (da `REGIME_DAX_SPEC_2026-10-05.md` §9.2)

Righe `@DECISIONE` proposte (il token di stato e' scritto spezzato apposta, come nella specifica):

```
@DECISIONE D-J CHIAVE=CANCELLO_DAX VALORE=STRUTTURA_OROLOGIO_SOSTITUTIVO STATO=[DA]_[FIRMARE]
@DECISIONE D-K CHIAVE=REGIME_DAX VALORE=770101,770105;W1..W6;A_poi_B;criteri_par5 STATO=[DA]_[FIRMARE]
@DECISIONE D-L CHIAVE=IMPORT_DAX_EXT VALORE=PC_BACKTEST_DOPO_DOW STATO=[DA]_[FIRMARE]
```

1. **D-J, il cancello sostitutivo** ("FIRMO CANCELLO DAX EXT"): il cancello ZERO e' **inapplicabile** sul DAX 2010-2018 (zero giorni in comune con BCM). Si firma che per `D30EUR_EXT` il cancello e' sostituito da **G-feed + G-clock + G-igiene** (§5.1), **dichiarato piu' debole** (calibra la struttura oraria interna, non il livello di prezzo contro BCM), con **etichetta in testa a ogni referto**: *"feed di un altro broker, non calibrato contro BCM: orologio verificato per struttura, prezzo e volatilita' NON verificati"*. **Cosa non firmi**: nessuna deroga alla D-C (parametri congelati, nessuna promozione), nessun uso delle **8 giornate** di dicembre 2018 in convenzione 24 ore (16-21, 27 e 28/12/2018, §1.3; ✏️ qui c'era scritto "9 giorni": corretto dal cancello 05/10). **Da cosa dipende**: da niente di misurabile ancora; e' una regola scritta prima dei numeri. **Alternativa onesta**: non firmarlo e tenere il DAX fuori finche' non ci sono dati con sovrapposizione: il costo e' che il DAX resta senza nessun regime.
2. **D-K, criteri e finestre** ("FIRMO REGIME DAX"): le sei finestre (§3), la regola di etichettatura esclusiva (§3.1, **da armonizzare con D-I del Dow e F-A del Nasdaq**: tabella delle tre regole in §3.1), le due varianti A / B (§6), le soglie G0-C, R1, il controllo di banco R2, M1-M4 (M1 "2 su 3" dichiarato piu' largo della B di casa) e le parole di verdetto (§5). **Firmata a numeri non visti** (come "FIRMO R113"). **Cosa non firmi**: la taglia, le sedie, il feed come fonte di taratura.
3. **D-L, l'import e la coda** ("FIRMO IMPORT DAX EXT"): costruire il convertitore con DST per giorno (codice nuovo, passa i due cancelli), ricostruire il CSV sul PC dagli zip in cache, importare `D30EUR_EXT` (e `D30EUR_EXTB` solo per B) **sul PC di backtest `DESKTOP-H4D7CAJ`, terminale `C:\Program Files\BCM Markets MT5 Terminal`, demo `50503392`**, **dopo** il piano Dow sullo stesso terminale. Limite di risorse: disco **~1,5 GB** per due simboli (80 MB per anno e simbolo x 9 anni x 2, [INFERITO] da `STORICO_INDICI_CRITERI` §4; il disco ha 326,69 GB liberi) e tester **<= 25 minuti**. **Zero soldi**. **Cosa non firmi**: nessun VPS, nessun terminale con un conto vero.
4. **Opzionali, solo se servono**: (a) rilanciare la diagnosi e la riparazione della convenzione 2024-26 (P9) per separare **feed ed epoca** se la frequenza crolla; (b) Dukascopy `DEUIDXEUR` per il 2020 e il 2022 (§3.4): decisione di costo/tempo di Claudio, non la chiedo adesso.

*Fine del foglio. Nessuna firma e' stata data, nessun terminale toccato, niente e' stato mandato a Claudio.*
