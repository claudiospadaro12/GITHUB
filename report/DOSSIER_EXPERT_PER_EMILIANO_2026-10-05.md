# Dossier dei miei expert, per il parere di Emiliano

*Claudio, 5 ottobre 2026. Allegato alla mail. Tutti i numeri vengono dai miei file di lavoro; la fonte e' tra parentesi quadre. Dove un dato non c'e' scrivo NON MISURATO, non lo stimo.*

**Come leggere le etichette.** [MISURATO] = letto o ricalcolato da un file di risultati. [DICHIARATO] = scritto in un mio referto ma non ricontrollato da me alla fonte in questa stesura. [DERIVATO] = calcolo su numeri misurati. [NON MISURATO] = il dato non esiste. **PF** = profit factor; **n** = numero di operazioni (dove conta, in *posizioni*, non in uscite parziali); **DD** = drawdown massimo in equity; **IS** = in-sample (dove scelgo la configurazione); **OOS** = out-of-sample (dove la verifico).

---

## 0. La verita' in cinque righe, prima di tutto

1. **Nessuno dei miei expert ha oggi un merito dimostrato.** Le regole di casa chiedono almeno 150 operazioni in campione e un test fuori dal solo regime di rialzo: quasi tutti restano sotto una delle due condizioni.
2. L'unico che passa i miei criteri alla lettera su dati a tick reali e' **EMA200 sul Dow H1** (PF OOS 1,52 su 257 posizioni) e anche lui e' misurato su **un solo regime** (rialzo 2024-26).
3. Sugli indici i dati a tick reali del mio broker partono da fine settembre 2024: **circa 21 mesi**. Lo storico lungo esiste per forex, oro e Nasdaq, **non** per il Dow ne' per il DAX in uso (sezione C).
4. In forward, la mia prima challenge su prop (80.000 EUR) e' fallita il 30/09 e la prova gratuita in corso ha perso il 5,5% in due giorni. Si legge come **zona grigia**, non come verdetto (sezione E).
5. Quindi la domanda che ti faccio non e' "sono bravi?" ma "con questi numeri, questi controlli e questi limiti, il percorso e' giusto?".

---

## A. Che cosa sto costruendo (10 righe)

1. Una **flotta di expert advisor MQL5** (MetaTrader 5) per superare una **prop challenge**: regole di riferimento target **10%**, perdita giornaliera massima **5%**, perdita totale massima **10%** [regole del regolamento della prop, DICHIARATO].
2. Invece di un motore solo, tanti motori **scorrelati**: aperture di Francoforte e di Wall Street, un incrocio di medie sul Dow, un motore su Supertrend, un mean-reversion su cross forex. Ogni combinazione expert + simbolo + orario la chiamo "sedia".
3. Ogni sedia ha un **contratto scritto**: il drawdown e la frequenza promessi dal backtest della configurazione scelta. Se in forward il DD supera il promesso, la sedia va in revisione.
4. Sopra le sedie c'e' **un solo modulo di rischio** sul conto: pausa giornaliera (3,5% sulla prova in corso), chiusura d'emergenza (4,5% giornaliero, 9,3% totale) e tetto sul rischio aperto simultaneo (4,00%) [configurazione della prova in corso, MISURATO].
5. Il rischio per operazione nei backtest e' **1%**; in campo sulla prova in corso le sette sedie sugli indici girano al **2,00%**, l'ORB allo 0,3%, il Bulge allo 0,8-1,0% con 3-4 posizioni [DICHIARATO; la taglia esatta del Bulge dopo il ripristino del 01/10 non e' nota]. Questo scarto e' un punto debole (sezione E).
6. Regola costante: **i criteri di promozione si scrivono prima di vedere i numeri**; la configurazione si sceglie al **centro di un altopiano** di parametri, mai sul picco.
7. Il **costo** e' un cancello: lo stop deve valere almeno **40 volte lo spread** (pavimento duro 13,3x). Su M5 gli indici sfondano questo limite, quindi i time frame bassi sugli indici sono esclusi *per costo*, con il numero accanto.
8. **Long e short si misurano sempre entrambi** sugli indici, anche se uno solo e' in campo.
9. Un expert non si archivia come "morto" senza: PF, n e DD misurati, gestione dell'uscita messa ad asse, simboli gemelli provati, time frame cambiato. Altrimenti il verdetto e' "non ancora misurato".
10. Il banco di prova ora e' una **prova gratuita di una prop (160.000 EUR)**, dal 01/10, 14 giorni, senza modificare niente in corsa. Le regole esatte di quella prova [NON MISURATO].

---

## B. Gli expert: tabella principale e schede

### B1. Tabella (nove expert in prova + tre candidati)

Valori **a rischio 1%, tick reali del broker, finestra 2024.09.26 - 2026.06.30**, salvo dove scritto. IS/OOS in coppia. Dettagli, manopole e regimi nelle schede B2.

| expert | motore | PF IS / OOS | n posizioni IS / OOS | DD IS / OOS | anni / dati | stato |
|---|---|---|---|---|---|---|
| Apertura DAX, ritest, solo long | ritest del range d'apertura, M5 | 1,13 / 1,40 | 132 / 193 | 5,4% / 7,2% | tick 21 mesi, un regime | candidata, merito sospeso (IS sotto 150) |
| Apertura DAX, ritest, solo short | idem, lato short | 0,97 / 0,96 | n.d. / 194 (138 / 257 uscite) | 7,5% / 12,3% | tick 21 mesi | contratto **senza edge**; in campo per scelta mia |
| MaxMin DAX short | rottura del minimo della notte, M15 | 1,88 / 2,16 | NON MISURATO / **14** | 3,1% / 1,9% | tick, solo OOS ~1 anno | **non ancora misurato** (14 operazioni) |
| Apertura Dow, ritest, solo long | ritest, M5, filtro EMA | 1,22 / 1,27 | 56 / 96 | 5,7% / 4,4% | tick 21 mesi | candidata, merito sospeso (96) |
| Apertura Nasdaq, ritest, due lati | ritest con filtro volumi, M5 | 1,22 / 1,22 (a 2%) | 82 / 102 | 7,3% / 7,9% (a 2%) | tick 21 mesi | candidata, merito sospeso (102) |
| SuperWave Dow H1, due lati | rimbalzo sul Supertrend, H1 | 1,85 / 1,33 (conteso: 1,48 / 1,24) | NON MISURATO (84 / 143 uscite) | 3,7% / 3,9% | tick 21 mesi | **non ancora misurato** (contratto conteso) |
| **EMA200 Dow H1, due lati** | ordini limite sulla media a 200, H1 | 1,20 / **1,52** | 132 / **257** | 5,7% / 7,8% | tick 21 mesi, un regime | **la piu' avanzata**, un regime |
| ORB Dow, solo long | breakout del primo quarto d'ora, M5 | 1,25 / 1,67 | n 71 / 119 (unita' non verificata) | 7,9% / 9,8% | tick 21 mesi | merito sospeso |
| Bulge, versione "viola" | mean-reversion H1 su 15 cross forex | nessun IS/OOS nostro (versione ampia, 4 mesi: 0,87 / 0,82) | versione ampia 410 / 363 operazioni | 13,7% / 22,8% (0,8%) | 4 mesi (mio); prova dell'autore 2022-26 | **NON MISURATO** (contratto assente) |
| *Candidato: MaxMin oro, solo long* | box notturno sull'oro, H2 | tick OOS 1,45; 22 anni a barre 1,10 | 93 (tick) | tick 2,3%; 22 anni 10,3% (a 0,5%) | tick 2024-26 + barre 2004-26 | con riserva |
| *Candidato: EMA200 H4 GBPJPY* | stesso motore, H4, due lati | OOS 1,22 | 144 | 4,1% | tick 2024-26, finestra unica | con riserva |
| *Candidato: EMA200 H4 EURUSD, corto* | stesso motore, H4, solo short | IS 1,11 / OOS 1,31 | ~104 OOS | 2,8% | barre M1 IS 2017-23, OOS 2024-26 | con riserva (barre, non tick) |

Fonti della tabella: contratti delle sedie del 20/09 per le sei sedie indice (PF, posizioni, DD) [MISURATO]; mappa delle aperture Nasdaq del 03/10 per la cella Nasdaq a 2% (il contratto del 20/09 dava 1,15 / 1,11 su un banco diverso: **le due misure non sono riconciliate**, uso la piu' recente e lo dichiaro); mappa aperture DAX 03/10 per lo short DAX [MISURATO]; censimento ORB del 29/09 per l'ORB [MISURATO, n sul lato "uscite o posizioni" non verificato]; analisi del Bulge del 03/10 [MISURATO]; candidati del 01/10 [MISURATO].

### B2. Le schede: motore, manopole che contano, regimi, forward

Per ogni expert: **manopole** con il valore del contratto (non le incollo da file di configurazione: sono le 3-5 che secondo me muovono il risultato).

#### 1. Apertura DAX, ritest, solo long (e la gemella short)
- Meccanismo: dopo l'apertura del DAX misuro il range dei primi **35 minuti**; se il prezzo rompe il range e **ritorna sul livello** di rottura, entro con un ordine limite (sconto di 2 punti), una sola operazione al giorno.
- Manopole: durata del range **35 min**; buffer di rottura **5 punti**; stop strutturale legato al range (mediana ~86 punti indice [DERIVATO]); **TP1 a 1R con chiusura del 50%**, poi pareggio e **trailing** su M5; chiusura di fine giornata.
- Regimi: **NON MISURATO** (un solo regime, rialzo con la discesa di aprile 2025). Nota importante sull'orologio: il server del broker e' UTC+1 fisso, quindi nei mesi invernali la configurazione a ora fissa arma **un'ora prima** dell'apertura cash; il contratto mescola le due tempistiche (sulla gemella short: estate PF 1,39 su 96 posizioni, inverno 0,90 su 85) [MISURATO].
- Forward: prima challenge 4 posizioni, 3 vinte, netto -1.341,63 (1 stop pieno); vincite tipiche +0,03 / +0,06 R in pochi minuti contro stop a -1,0 R. Short: challenge 1 (+83,56), prova in corso 1 (stop, -3.110,48).

#### 2. MaxMin DAX short
- Meccanismo: ordine di vendita sotto il **minimo della notte**, piazzato poco prima dell'apertura europea, con filtro di correlazione sull'S&P 500.
- Manopole: box notturno; stop **2,5 x ATR** (mediana ~59 punti); **TP1 1R 50%, TP2 3R, target sulla EMA200, finale 4R**; time frame di gestione M15; ordine pendente per 90 minuti.
- Contratto: PF OOS 2,16 su **14 posizioni** (frequenza promessa 0,05 al giorno); un secondo contratto piu' vecchio dice PF 2,05 su ~27 posizioni [MISURATO]. Regimi: NON MISURATO.
- Forward: sulla prima challenge e sulla prova in corso ha fatto **4 posizioni in ~9 giorni** (0,44 al giorno, circa 9 volte il contratto), **1 vinta su 4**, tre stop pieni da ~1 R. Il contratto da 14 operazioni **non descrive la sedia che opera oggi** (sezione E).

#### 3. Apertura Dow, ritest, solo long
- Meccanismo: come il DAX, sul Dow, con **filtro di trend** (EMA su H4). Manopole: range 35 min, buffer 10 punti, offset di ritest 4 punti, TP1 1R 50%, trailing M5, stop minimo 5 punti; una operazione al giorno (stop mediano ~124 punti).
- Regimi: NON MISURATO. Messo in fase con la cash USA il lato long fa PF 0,89 su 84 posizioni in estate, 0,92 su 40 d'inverno e 0,84 su 123 sulla serie "come la prop" (misura sospesa); il contratto mescola le due tempistiche [MISURATO]. Lo short e' misurato e **non regge** (OOS 0,84 su 73).
- Forward: nessuna operazione nei primi 8 giorni della prima challenge.

#### 4. Apertura Nasdaq, ritest, due lati
- Meccanismo: ritest del range d'apertura **con filtro volumi** (1,5 x la media di 20 barre). Manopole: range 35 min, buffer 2 punti, **TP1 0,5R 50%**, trailing M5 (ATR 2,0), volumi ON (stop mediano ~83 punti).
- Regimi: NON MISURATO; esiste storico esterno del Nasdaq dal 2010 ma la prova di regime su questa cella **non e' mai stata fatta** (sezione C). Prima di muovere qualunque manopola pretendo una prova di regime. Mai operata in forward.

#### 5. SuperWave Dow H1
- Meccanismo: rimbalzo vicino al Supertrend (ATR 10 x 2,5), ingresso frazionato (un terzo subito, il resto a ordini pendenti di 20 pip), stop sull'estremo delle ultime 5 barre piu' buffer.
- Manopole: moltiplicatore Supertrend **2,5**; **TP1 1R 50% + TP finale 3R**; **trailing sul Supertrend** e uscita sul "flip"; due lati. Il trailing sul Supertrend **paga** (spento: PF IS da 1,49 a 0,90) [MISURATO, banco 10.000].
- Il contratto e' **conteso**: la stessa configurazione, misurata due volte, da' n 143 / DD 3,91% e n 131 / DD 4,17%; la differenza non sta nei parametri (forse nel binario o nello storico tick) [MISURATO]. Il numero di posizioni e' **NON MISURATO** (stimo ~81).
- Forward: nessuna operazione nei primi 8 giorni della challenge.

#### 6. EMA200 Dow H1 (la piu' avanzata)
- Meccanismo: due ordini limite a **0,2 e 0,3 ATR** dalla media a 200, con bias della media a 14 e distanza dalla media fra 0,3 e 1,5 ATR; una sola posizione (o pendente) per volta, **long e short si escludono**.
- Manopole: periodo EMA **200**; ordini a **0,2 / 0,3 ATR**; **stop 1 ATR** (mediana ~104 punti); **TP 2R** con **TP1 al 50%**, pareggio e trailing; scadenza dei pendenti 6 barre.
- Numeri: IS PF 1,20 su 132 posizioni, DD 5,73%; **OOS PF 1,52 su 257 posizioni, DD 7,83%** (riprodotto da quattro corse indipendenti). Con spread della prop e slippage il PF scende a **1,43-1,46** e il profitto del ~12% [MISURATO, stima prudente]. Il DD della discesa di feb-apr 2025 cade dentro l'IS: **al massimo 5,73%** (solo long 2,64%, solo short 4,51%), salvo effetti di confine [MISURATO]; il PF per lato in quella discesa e' NON MISURATO.
- Regimi: **NON MISURATO fuori dal rialzo 2024-26**; il PF a meta' anno oscilla da 2,05 a 0,87 fra due meta' dell'anno [MISURATO]. Stop a ~104 punti = costo al limite del 40x (fragile).
- Forward: prima challenge 3 posizioni (2 stop pieni dello stesso setup il 22/09, 1 vinta), netto -1.006,86; sul demo di prova 21 posizioni in 16 giorni (1,31 al giorno, sopra le 0,93 promesse) [MISURATO, esito netto del demo non riletto].
- Gemelli: sullo stesso Dow, cambiando time frame, OOS M30 0,91 e H3 0,91 (no), H2 1,17 e H4 1,42 (positivi ma su pochi dati: 116 uscite a H4); su altri simboli il motore non regge a H1 (DAX 0,85 a barre, 0/28 celle positive; Nasdaq PF mediano 0,75; oro tick IS 0,56; S&P escluso per costo): l'edge misurato e' specifico del **Dow H1** [MISURATO].

#### 7. ORB Dow, solo long
- Meccanismo: breakout del primo quarto d'ora di Wall Street, solo long, filtro EMA200, trailing su EMA 9. Manopole: range **15 min**, stop a meta' range (variante "mezzo range"), ingresso a pochi punti oltre il range, **filtro EMA200**, trailing EMA 9, rischio 0,3% in prova.
- Numeri: IS 1,25 (n 71), OOS 1,67 (n 119), DD 7,9% / 9,8% a rischio 1%; la variante con stop all'estremo opposto dimezza il DD (OOS 1,68, DD 4,3%). Il numero di operazioni **non cambia** in 48 celle di parametri: il buffer sposta lo stop ma non decide se si entra. Slippage: con 1,5 punti il DD sfonda il 10% [DICHIARATO]. Mai provato su altri time frame. Il gemello Nasdaq fallisce (PF 0,84-0,91).
- Forward: prova in corso 1 stop (-537,86, slittamento di 11,2 punti = 0,14 R); nei miei dati un forward demo di 15 posizioni con 3 vinte (-295,58) e 8 posizioni PF 0,27 su un altro demo [DICHIARATO, non ricontrollati].

#### 8. Bulge versione "viola"
- Meccanismo: mean-reversion su **15 cross forex, H1**, con bande di volatilita' e ATR, fino a 3-4 posizioni, kill switch (4 stop o 3 consecutivi o -2% nel giorno).
- Manopole: famiglia di segnale (viola, blu e arancio), filtro ADX, **numero massimo di posizioni**, rischio per operazione, filtro ATR, TP riscritto dinamicamente.
- Stato: **l'edge non e' dimostrato da nessuna misura nostra**. L'unico numero buono (PF 1,60, WR 80%, n 268) e' un backtest dell'autore su 6 cross, dati al 40%, nessun IS/OOS. Le misure nostre stanno **sotto 1**: AMPIA a 4 mesi 0,87 / 0,82; forward del predecessore PF 0,83 su 297 operazioni; PF 0,92 anche **al lordo dei costi**. Forma del motore: vince poco (media ~19) e perde tanto (~64): serve circa il 77% di vincite per pareggiare.
- Forward: prova in corso 10 posizioni, 6 vinte, netto -1.870,73 (campione sottile) [MISURATO].

#### 9. I tre candidati (non in campo)
- MaxMin oro solo long: tick PF 1,45 su 93 posizioni, ma a barre su 22 anni PF 1,10 con DD 10,3% e **11 anni negativi**: il PF del tick e' del rialzo 2024-26. EMA200 H4 su GBPJPY: PF 1,22 su 144 posizioni, errore tipico ~0,2 [stima], indistinguibile da 1. EMA200 H4 su EURUSD corto: OOS 1,31 contro IS 1,11, a barre. Nessuno e' pronto, tutti hanno regime unico.

### B3. Prove di regime (toro / orso / laterale / crollo): cosa ho davvero

Sulle **sedie indice in prova non esiste nessuna prova di regime lunga**. Ho prove di regime su altri motori, tutte a barre M1 esterne (screening: il numero cambia anche di segno col modello del tester) [MISURATO]:

| motore (forex) | orso 2022 | crollo 2020 (anno) | toro 2021 | laterale 2019 |
|---|---|---|---|---|
| PTE GBPUSD (a barre) | PF 1,62 su 18 (a tick generati: **0,75**) | 1,01 su 35 | 1,45 su 37 | 1,84 su 51 |
| PTE USDJPY | 0,81 su 46 | 0,72 su 52 | 1,04 su 36 | **1,90 su 40** |
| SuperWave GBPUSD H2 | 0,96 su 51 | 0,86 su 69 | **0,56 su 65** | 0,80 su 61 |
| Cost-to-cost EURJPY | 2,65 su 43 | 1,69 su 67 | 1,05 su 46 | 1,38 su 54 |

- PTE USDJPY funziona **solo nel laterale**; SuperWave GBPUSD fa +3.560 (PF 1,84) fuori campione in rialzo e **-3.187 (PF 0,56) nel toro 2021**: stesso numero di operazioni, segno opposto. La promozione di PTE GBPUSD e' stata **ritirata** quando il tester e' passato da barre a tick.
- Sul Nasdaq, un motore Supertrend (non in prova) su 16 anni di barre: lo short **non ha fatto nemmeno un'operazione nell'orso 2022**; nel laterale 2015-16 e' in perdita con campione pieno (PF 0,66 su 55). Verdetto: non conclusivo.
- Oro, 11 motori su 22 anni a barre: **tre revisioni di rischio** (DD a 22 anni 19,7%, 29,7%, 45,9% contro promessi 3,5-5,3%).
- Forex, tre sedie "Breaking Band" su ~27 anni dal 1999 a barre: GBPUSD **cambia di segno** (+5.838 PF 1,08 sul comune 2009-26 contro -11.574 PF 0,90 sull'intero periodo, DD 23,4%); l'edge vive nel presente.
- Un fenomeno che molti insegnano, "al primo tocco la EMA200 respinge il prezzo", l'ho misurato a parte (DAX, oro, S&P; H4/D1 su 6 coppie forex): **non si distingue da una passeggiata casuale** (probabilita' di rimbalzo 0,47-0,49 contro 0,48-0,49 del caso a H4; il D1 e' non misurabile per campione). Non e' un backtest: dice solo che il fenomeno da solo non basta.

---

## C. Su quanti anni sono stati valutati (famiglia per famiglia)

**Regola di casa:** si dimensiona sulle **operazioni (almeno 150)**, non sugli anni; e il regime va dichiarato. Qui sotto gli anni veri, perche' "tanti anni" in generale sarebbe una frase falsa a meta'.

| famiglia | dati con cui e' stato valutato | profondita' misurata | prova di regime / storico lungo |
|---|---|---|---|
| **Indici del broker** (Dow, DAX, Nasdaq, Nikkei) | **tick reali, modello a tick veri**, nativo del broker | dal **26/09/2024**: **~21 mesi** al 30/06/2026 (IS ~8,5 mesi, OOS ~12,7) [MISURATO] | un solo regime (rialzo, con la discesa feb-apr 2025) |
| **Dow** | come sopra | idem | **NON ESISTE.** HistData non ha il Dow; il Dow di un secondo fornitore (dal 2012) **non e' stato scaricato**; il pezzo gia' importato (2024-10 / 2025-06) cade *dentro* il nativo: zero anni in piu'. Esiste un **piano** (circa 1.300 giorni di dati, 90-348 ore di calcolo), **non eseguito** |
| **DAX** | tick reali nativi, ~21 mesi | idem | dati esterni 2010-2018 (**9 anni**, 1,72 milioni di barre M1, prezzi verificati) **scaricati ma mai importati**: zero giorni in comune col nativo, quindi il confronto di qualita' non si puo' fare. La prova di regime sulle aperture DAX e' **non disponibile** |
| **Nasdaq** | tick reali nativi ~21 mesi (celle d'apertura) | idem | dati esterni a barre M1 **2010-11 -> 2026-07 (~15,7 anni, 5,23 milioni di barre)**, ammessi *solo* come prova di regime con mia firma e gia' usati (18 celle su 16 anni, altro motore). **Non usati sulla cella d'apertura in campo** |
| **S&P 500, Nikkei** | esterni S&P 2010-2026, Nikkei 2019-2026 | S&P ~15,7 anni, Nikkei ~7,5 | "in frigo" (qualita' del feed al limite: rapporto 0,203 contro soglia 0,20) |
| **Forex** | tick reali solo dal ~07/2024; il lungo e' a barre M1 | dati nativi del broker dal 1971 (EURUSD, USDJPY), dal 1993 (GBPUSD, AUDUSD); le sedie testate **operano dal gennaio 1999**: **~27 anni a barre** | regimi 2019-2022 su barre esterne 2018-2024 (7 anni); i due feed **divergono** (quattro cambi di segno, cause non chiuse) |
| **Oro** | dati nativi del broker dal 2004 (22,1 anni, a barre); esterni 2018-2024 (7 anni) importati | **22 anni a barre** per 11 motori; i tick sono 2024-26 | storico esterno 2006-2020 e 2021-26 scaricato, **non importato e non concatenabile** (due feed, buco di 7 mesi) |

**La frase onesta.** Sul forex, sull'oro e sul Nasdaq ho uno **storico lungo, ma a barre e con dati esterni dove il broker non basta**: servono a vedere la forma del regime, **non** a fissare un PF. Sul Dow e sugli altri indici la validazione a tick e' su circa 21 mesi e l'allargamento esterno e' solo prova di regime a barre M1, **che per il Dow non esiste ancora**. I backtest degli indici non sono "su tantissimi anni".

**Quali expert indici hanno avuto una prova di regime lunga:** **nessuno** fra quelli in prova (tre DAX, tre Dow piu' ORB, un Nasdaq). Ce l'hanno altri motori Nasdaq e forex/oro non in prova.

[fonti: mappa aperture Dow e DAX del 03/10; lo storico esterno, mappa del 23/09; storico indici scaricato il 10/09; referti R50, R56, R59, R80, R100, R102, R113; piano regime Dow del 05/10. Da ricontrollare: i "~15,7 anni" del Nasdaq e la data di inizio dei tick forex.]

---

## D. I controlli che ho fatto (10 righe)

1. **Walk-forward in-sample / out-of-sample** (IS ~40%, OOS ~60% della finestra), a **tick reali**; le barre OHLC sono solo screening (misurato sul Nasdaq: un fattore 1,7-1,85 in eccesso rispetto al tick [DICHIARATO]).
2. **Criteri congelati prima dei numeri**, datati e versionati; il difetto che ho pagato: scegliere la cella migliore invece del **centro dell'altopiano** ha ribaltato un verdetto.
3. **n minimo 150 posizioni**: con n 75-159 la superficie dei parametri e' frastagliata; con 190-256 l'altopiano si legge.
4. **Cancello del costo**: stop >= 40 x spread; i time frame bassi sugli indici sono esclusi per costo con il numero accanto.
5. **Stress di costi ed esecuzione**: spread della prop piu' slippage misurato sul mio conto (il tester a tick reali paga gia' lo slippage sugli stop: media 0,91 punti contro 0,42 sul vero); nessuna sedia scende sotto PF 1,20 per i costi, una ci era gia'.
6. **Quattro regimi**: toro, orso, laterale, crollo, uno per uno invece di una media di sedici anni (quando posso, vedi C).
7. **Monte Carlo sull'ordine dei giorni** (giorni interi, correlazione conservata): su portafoglio allora, a rischio 0,65%, p99 del drawdown 8,5% contro un muro statico del 10%; su muro trailing 12,1% [DICHIARATO, 06/09].
8. **Rischio aperto simultaneo**: una mattina avevo 9 posizioni aperte insieme (5,85% di rischio); da li' il tetto sul rischio aperto (3,25% allora, 4,00% sulla prova in corso) e il modulo unico.
9. **Contro-esempio prima di consegnare**: ogni misura la provo a rompere con l'ipotesi alternativa; piu' volte ha trovato errori miei (un conteggio doppio dello spread, una finestra dentro l'IS).
10. **Criterio di uscita** scritto: DD forward oltre il promesso = revisione; famiglia in perdita a 20 operazioni = si spegne la sedia colpevole; i "morti" hanno un certificato a 5 punti.

---

## E. Cosa NON so e punti deboli dichiarati

1. **Un solo regime sugli indici.** Tutte le sedie indice sono misurate nel rialzo 2024-26: il rischio vero (orso, crollo) e' da provare, non misurato.
2. **Campioni sottili.** Sotto 150 posizioni: Dow Apertura (96), Nasdaq (102), ORB (119), MaxMin (14), SuperWave (n.d.). Un PF su n sottile e' un'ipotesi, non un merito.
3. **Scarto di taglia.** Contratti a 1%, in campo a 2%. Il DD scalato linearmente a 2% sulle sedie indice: DAX long **14,5%**, EMA200 Dow **15,7%** (oltre il muro del 10%), Dow Apertura 8,8%, Nasdaq 7,4-7,9%, MaxMin 3,8% [DERIVATO, scala approssimata].
4. **Orologio del broker.** Server UTC+1 fisso: d'inverno la configurazione a ora fissa arma un'ora prima dell'apertura cash; il contratto mescola le due tempistiche e non so quanto pesi.
5. **Contratti contesi.** SuperWave Dow (due corse, due risultati sulla stessa configurazione) e Nasdaq (1,22 contro 1,11 su banchi diversi): non riconciliati.
6. **La prima challenge e' fallita** (80.000 EUR, operativa dal 22/09). Violato il limite di perdita totale il 30/09: saldo finale 71.935,73. La flotta di expert: 11 posizioni, 6 vinte, **-4.500,93, PF 0,31**; in piu' **cinque operazioni manuali sull'oro fatte da me, circa -3.563 in totale**, fuori dagli expert e senza passare dal modulo di rischio. Senza i manuali la linea non sarebbe stata sfondata quel giorno; ma con un margine di 997 EUR contro uno stop da ~1.500 una sola giornata storta l'avrebbe sfondata comunque [MISURATO]. Vincite tipiche +0,03 / +0,06 R, stop -1,0 R: **payoff asimmetrico**.
7. **La prova gratuita in corso: siamo stati sfortunati o gli expert vanno male? E' una ZONA GRIGIA misurata.** 01-02/10: 13 posizioni, **-8.811,59 = -5,51% di 160.000**, i due DAX short = 72,7% della perdita, in sequenza (il secondo aperto 67 minuti dopo lo stop del primo); Bulge 10 posizioni (6 vinte, -1.870,73); ORB 1 stop. Misura a criteri congelati prima dei numeri:
   - un risultato cosi' in due giorni, con i contratti delle sedie indice, capita nel **5,8%** delle coppie di giorni (15 su 259; IC 3,3-9,4%): non e' ordinario (soglia 20%) ne' un effetto dimostrato (soglia 5%) = **ZONA GRIGIA**;
   - **se** due sedie sul conto non fossero state attaccate (non verificato) scende a ~1,9%;
   - la correlazione piu' che raddoppia la probabilita'; per due terzi e' DAX e Dow che perdono lo stesso giorno;
   - **singola sedia: NON ANCORA MISURATO**: una operazione ciascuna, e uno stop pieno capita il 23-36% delle volte;
   - **tre pezzi vanno "male" per contratto, non per sorte**: lo short DAX ha un contratto senza edge (PF 0,96); il Bulge non ha contratto e coi suoi payoff chiede ~75% di vincite (ne ha fatte il 60%); la MaxMin opera ~9 volte il contratto e perde piu' del contratto (l'effetto al bordo, p 0,04);
   - **l'esecuzione e' sana**: il tester rifa le stesse operazioni, slittamenti entro ~1 punto sul DAX.
   - **Detto in una riga: non posso dire "sfortuna" e non posso dire "gli expert funzionano".** A queste taglie il contratto stesso produce un giorno realizzato di -4,36% o peggio 6 volte su 260.
   Al 05/10 mattina: nessuna nuova operazione, equity 151.166,37 [MISURATO].
8. **Sedie senza contratto**: Bulge e tre motori che operano sulle notizie (nessun PF: 0 operazioni in tutti i test archiviati).
9. **Manopole mai messe ad asse**: Bulge (time frame cablato su H1, TP fisso o dinamico e uscita a tempo non misurabili senza modificare il codice); ORB (time frame diverso da M5, parziale); Nasdaq (time frame del livello, orario d'ingresso). Per le aperture il time frame del grafico e' inerte *per costruzione* (il range si legge su M1): i veri assi sono altri quattro input.

---

## F. Il confronto fra due AI

Da circa una settimana lavoro anche con **Gemini**, un secondo modello AI, accanto a Claude. L'ho istruito con una **memoria condivisa** e una **base di conoscenza** del progetto (regole di casa, vocabolario dei verdetti, fatti misurati, formule), cosi' da averlo pronto quando c'e' da confrontarsi con Claude. Gli ho fatto fare un esame (punteggi dati da noi, non da un valutatore terzo):

| prova | che cosa misura | punteggio |
|---|---|---|
| 15 domande con risposta nota, **con** la sola memoria | se sa il progetto da solo | **17 / 30 (57%)**: mai un "non lo so"; fatti recenti inventati o sbagliati con sicurezza; un break-even sbagliato (23,7% invece di 77,5%) |
| stesse domande **dopo** la base di conoscenza, a libro aperto | se legge e applica i fatti che gli do | **27 / 30 (90%)**; non prova il ragionamento perche' la formula era nella base |
| 10 domande **a libro chiuso** (6 di ragionamento, 4 su cose che non puo' sapere) | ragionamento e onesta' | **19 / 20**; ragionamento 11 / 12; "non lo so" 4 volte su 4 |
| break-even ripetuto 5 volte senza base | se l'errore e' sistematico | 5 su 5 giusti (79,17%) |

**Come lo leggo, senza gonfiarlo:** il salto 17 -> 27 e' quasi tutto contesto (gli ho dato i fatti); a libro chiuso ragiona bene su domande isolate; ma nei suoi scambi precedenti ha sbagliato i numeri di riga 3 volte su 3, inventato un nome di parametro, riproposto come nuovo un blocco gia' misurato. Il test e' piccolo (15 e 10 domande). **E' utile come generatore di ipotesi, non e' un giudice**: ogni sua risposta per me e' un **dato da verificare**, mai un criterio. Ha portato anche idee buone (rischio per fattore comune, tocco di corpo, MFE/MAE nell'export). Per questo il tuo parere, da persona che opera davvero, mi serve piu' del suo.

---

## G. Le domande per Emiliano, con lo spazio per classificare

**Le cinque domande** (le stesse della mail):

1. Con questo PF e questi controlli, ogni expert e' accettabile, buono, ottimo o non adatto?
2. Una classifica dal migliore al peggiore.
3. Cosa migliorare e su quali parametri lavorare.
4. **La metodologia e' corretta, o dobbiamo guardare altri scenari, altri contesti, altri parametri?** Il percorso e' quello giusto per expert piu' profittevoli, o mi sfugge qualcosa?
5. Gli anni e il tipo di dati che uso (21 mesi di tick sugli indici, storico lungo a barre dove c'e') sono sufficienti per fidarsi di un expert?

**Se ti va, dimmi anche:** come tratti tu l'orario d'apertura d'inverno e d'estate sul DAX; se uno stop strutturale e' meglio di uno in ATR; cosa gestisci in uscita; e che rischio per operazione useresti su una prop con il 10% di margine.

**Tabella da compilare** (giudizio: accettabile / buono / ottimo / non adatto; priorita' 1 = prima):

| posizione in classifica | expert | giudizio | priorita' di lavoro | su cosa lavoreresti |
|---|---|---|---|---|
| | Apertura DAX, ritest, long | | | |
| | Apertura DAX, ritest, short | | | |
| | MaxMin DAX short | | | |
| | Apertura Dow, ritest, long | | | |
| | Apertura Nasdaq, ritest, due lati | | | |
| | SuperWave Dow H1 | | | |
| | EMA200 Dow H1 | | | |
| | ORB Dow, long | | | |
| | Bulge viola | | | |
| | Candidato: MaxMin oro long | | | |
| | Candidato: EMA200 H4 GBPJPY | | | |
| | Candidato: EMA200 H4 EURUSD corto | | | |

Grazie.
