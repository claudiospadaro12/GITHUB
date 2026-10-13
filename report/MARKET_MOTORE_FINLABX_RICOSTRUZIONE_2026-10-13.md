# RICOSTRUZIONE DEL MOTORE «FinlabX / CF / DZR» da un giorno di ordini sul demo 50503392 (13/10/2026)

Fonte: `data/statements/ReportHistory_50503392_2026-10-13.xlsx` (SHA256 `2e4624c0…`); script di appoggio `backtest_pipeline/analisi_cesti_commento_cid.py` (non ancora passato dal cancello come strumento: i numeri qui sotto vanno riverificati con `natura_motore_da_storico.py`). EA a scatola nera, nessun sorgente. **[LETTO nel conto]** = misurato sul file; **[INFERITO]** = ricostruzione mia del comportamento, non dichiarata dal venditore. Un solo giorno di mercato: **merito NON MISURATO**.

## 1. Come lavora, in cinque righe [INFERITO da cio' che segue]
1. Tutti gli ordini sono **pending STOP** (buy stop / sell stop), riempiti dopo 10-28 secondi (mediana) dal piazzamento [LETTO].
2. **Moduli `[F]`**: seguono il prezzo a favore. TP **sempre esattamente +1,00 USD** (379 su 379), lotto 0,01, ingresso successivo mediamente **+1,35 USD a favore** (CF) e +1,68 (FinlabX `[F]`) rispetto al precedente [LETTO]. Vincono spesso, ma nel complesso **perdono** (circa -54 EUR in 22 ore): sono la «scintilla», non il profitto.
3. **Modulo `[R]`**: se il prezzo va contro, **aggiunge ingressi stop nella stessa direzione** (mediana ogni 5 minuti; passo mediano 1,46 USD a prezzo peggiore, ma con ampia variabilita': dal -2,15 al +3,22) con lotto che sale **piano**: livello 1 = 0,01, livello 5 = 0,03, livello 10 = 0,05-0,08 [LETTO]. **Non raddoppia.**
4. **Uscita a cesto**: le posizioni di una serie chiudono **insieme**; il prezzo d'uscita sta in mediana **+1,19 USD sopra il prezzo medio ponderato** d'ingresso (p10 -0,40, p90 +3,30) [LETTO su 24 cesti con >= 3 posizioni]: il motore sembra puntare a **«media d'ingresso + circa 1 USD»**, lo stesso +1,00 dei moduli `[F]` [INFERITO].
5. **Il SL arriva dopo** (e viene spostato): solo 6 cesti su 24 hanno un unico valore di SL; 5 su 24 sono usciti a SL; 20 su 24 con profitto [LETTO].

## 2. Dove nasce il profitto: nella coda
Per profondita' del recupero (numero di ingressi `[R]` per ciclo e lato), netto del solo `[R]`:
| profondita' | cesti | netto `[R]` EUR | somma lotti d'ingresso della serie (NON il massimo vivo) | in perdita | durata max |
|---|---:|---:|---:|---:|---:|
| 1 | 36 | +55,66 | 0,02 | 4 | 0,3 h |
| 2 | 15 | +89,15 | 0,06 | 0 | 0,4 h |
| 3-4 | 17 | +139,79 | 0,10 | 1 | 1,0 h |
| 5-9 | 9 | +124,00 | 0,23 | 0 | 2,4 h |
| **>= 10** | **3** | **+132,41** | **1,20** | 0 | **6,2 h** |
**Tre cesti su 80 (3,75%) producono il 24,5% del profitto del `[R]`** (132,41 su 541,01) e sono quelli con **1,20 lotti di somma d'ingresso** (il massimo VIVO insieme, misurato sugli istanti di apertura e chiusura, e' **1,01**: la serie chiude in 4 volte) per oltre 6 ore. [CORRETTO 14/10: prima c'era scritto «1,2 lotti vivi»: era una somma]. Fino ad oggi hanno sempre «chiuso a +»: sono il punto in cui un giorno di trend contro la serie farebbe la perdita grande. Questo e' il numero da guardare, non il +541.

## 3. Il conto del giorno, e cosa NON dice
- **+442,74 EUR netti** sul conto, **+487,31** sui cicli con `CID` (21 ore) [LETTO]; deposito ricavato dal drawdown: **~4.800 EUR** (264,67 = 5,52%) [DERIVATO]: **~+10% in un giorno**.
- **Conto intero (634 operazioni, compresi altri EA)** [LETTO, sezione Risultati]: win rate 69,2%, media vincita 3,09 contro media perdita -4,68 (payoff 0,66), PF 1,485. **Sulle sole 608 posizioni del gruppo** [DERIVATO da noi, netto con commissione e swap]: 69,2% (421 su 608, coincide), media vincita 2,96, media perdita -4,11, **PF 1,64**. Altro: perdita singola massima -52,59, **12 perdite consecutive = -263,91** [LETTO, sezione Risultati].
- Il «Drawdown Bilancio» del report e' sul **saldo**, non sull'**equity**: il flottante di una scala senza SL non e' nel file [NON MISURATO]. Un +10% al giorno con 5,5% di drawdown di saldo nello stesso periodo, se fosse su una prop con limite giornaliero 5%, **l'avrebbe gia' sforato come saldo**, prima di contare il flottante.

## 4. Cosa ne facciamo (ipotesi, non criteri)
1. **Versione NOSTRA con coda capata**: stessi ingredienti (stop pending, TP +1,00 / uscita a media + ~1,0 USD, lotto che sale piano) ma **profondita' massima 3-4** (68 cesti su 80, l'85%, non toccano il tetto), **SL di cesto fisso all'ingresso del primo livello**, lotto massimo bloccato, rischio per cesto dentro la taglia firmata da Claudio. Da misurare nel tester a tick reali sull'oro con attesa e smentita scritte PRIMA: il tetto sulla coda **toglie fino al 24,5% del profitto** della famiglia `[R]` (se i dati fossero rappresentativi: un giorno) e **cambia il payoff**, quindi non si sa se resta positiva.
2. **Spread**: sul TP di +1,00 USD lo spread dell'oro (~0,2 nel tester) pesa circa il 20%: la parte `[F]` e' molto sensibile; va misurato con lo spread vero del conto.
3. Prima di scrivere codice servono: **nome del prodotto, screenshot degli input, e altri giorni** con almeno una giornata di trend contro la scala (senza, la coda non e' misurata).
