# Sala del Consiglio V2 - progetto "ORB Metodo Paolo vs i nostri EA" (04/11/2026)
Modalita: agenti REALI (subagenti separati A2, A6, A7; C0 = Claude che coordina e integra). Nessun test su dati in questa fase.

## Mandato (da Claudio)
"Apprendi questo ORB per il nostro EA. Fai un confronto. Analizzalo con la sala del consiglio." Materiale: `materiali/ORB_Metodo_Paolo.pdf` (14 slide, riassunto del metodo ORB di Paolo).

## Obiettivo
1. Trascrivere il metodo di Paolo in regole numerate (P01-P12), distinguendo cio che e OGGETTIVO/testabile da cio che e DISCREZIONALE.
2. Confrontare regola per regola con i nostri EA ORB: `ABTG_ORB` (webinar), `ABTG_ORB_Ottimizzato` (quello che GIRA, preset in `materiali/preset_live_ORB_Ottimizzato.txt`), `ABTG_ORB_Emiliano` (altra strategia: volatilita d'apertura).
3. Dire cosa manca, cosa e gia uguale, cosa e diverso, e quali differenze sono testabili con i nostri dati (NASDAQ/S&P `_EXT` M1 2010-2026, DAX D30EUR M1 dal 09/2024).
4. Proporre un piano di test PRE-REGISTRATO (criteri e previsioni prima dei numeri), senza eseguirlo.

## Deliverable
`final/CONFRONTO_ORB_PAOLO.md` (confronto), `congelati/piano_test_orb_paolo_v1.md` (piano di test, solo proposta), registro obiezioni e verifiche.

## Fuori perimetro
Modificare EA o preset, toccare conti, lanciare backtest, dare lotti/taglie.

## Regole di Paolo da cui partire (trascritte dalle 14 slide; A2 le verifica sul PDF)
P01 Box = primi 15 minuti dall'apertura (Nasdaq 15:30-15:45 IT; DAX all'apertura del mattino). Indicatore ORB: 15:30-15:44:59 ("se no vi prende anche la candela successiva"). Con ora legale USA diversa: la sera si apre alle 14:30.
P02 Candela di ingresso M5: apre E chiude fuori dal box (conta il corpo, gli spike no; candela col corpo piccolo che ha solo "breccato" non conta).
P03 Contesto: medie ordinate nella direzione; SuperTrend rotto e inclinato a favore; volumi alti sulla rottura (solo per migliorare il contesto); VWAP a favore; trend a favore.
P04 Resistenze/supporti H1/H4: mai a ridosso: si aspetta la rottura e si entra sulla candela successiva (stop resta dall'altra parte; size piu piccola).
P05 Candela troppo lontana dal box (esempi 35/41/53 punti, imbalance): si aspetta il retest rifiutato e si entra alla chiusura.
P06 Ingresso alla chiusura della candela; stop oltre il lato opposto del box ("un gocciolino fuori"); stop non troppo stretto (non sulla candela M5 precedente).
P07 Box stretto (31 punti = "bell'ORB") meglio di box largo (100+ punti); 1:4 con stop 120 "non lo fai mai" (oltre la volatilita media; DAX range giornaliero 295).
P08 TP 1:1 ("sono conservativo"), TP tecnico sui livelli; parziale 50% prima della resistenza (DAX 30-40 punti); dopo il parziale stop in pari +1 euro; il resto con stop spostato a mano su SuperTrend/swing; pochi punti dal TP chiude a mano.
P09 Rischio: size = capitale a rischio / (stop x valore del punto); 1-2% a trade; max 3% al giorno (esempio: 100 EUR, stop 40-50 punti, 0,22 lotti).
P10 Da evitare: entrare a ridosso di una resistenza; candela troppo lontana; stop troppo stretto; box troppo grande; target a 3R; confondere con la strategia di Emiliano (volatilita d'apertura vs trend).
P11 Studio: indicatore ORB con 50 historical days (dove c'e 5, mettere 50) e rivedere i box uno per uno; "e testata, funziona, si applica".
P12 Quando: Nasdaq la sera ("e il Nasdaq quello che funziona meglio come ORB"), DAX la mattina ("normalmente profittevole").

## Regole della Sala applicate
Un controllo non eseguito non e superato; le dichiarazioni (del PDF, degli agenti) non sono prove; punteggio non e prova; nessun test eseguito qui.
