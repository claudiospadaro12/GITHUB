# LATI (prova di regime della 771531): la finestra A1 sta DENTRO l'IS gia' misurato -- il piano sovrastimava il valore (05/10/2026, notte)

Cancello di giudizio (controllo-preventivo) sui 4 file LATI e sul lettore `leggi_lati.py`: **FAIL**, classe 1102 in `CHECKLIST_RIGA_DI_LANCIO.md` (commit `dcc312f7`).

## Il fatto
La finestra **A1 (discesa 2025.02.01-2025.04.30)** e' interamente dentro l'**IS di R110 (2024.09.26-2025.06.09)**: stessa cella, tick reali, deposito 100000, e il DD si legge dalla stessa colonna.
Quindi il DD dell'IS fa da **tetto** per la discesa: **L 2,6377% · S 4,5113% · L+S 5,7325%** [MISURATO da R110; L+S riprodotto il 04/10 da EMAGEM2].
- La domanda "il DD della sedia nella discesa del 2025 e' dentro il contratto 7,83%?" ha **gia' la sua risposta**: <= 5,73% a rischio 1%, salvo effetti di confine.
- L'attesa scritta nei file ("DD LONG 3-14%") **contraddice** i numeri citati nello stesso file: con un banco sano il lettore stamperebbe "FUORI" su un numero giusto.
- T2 (DD <= 10% sulle sole celle pure) non puo' scattare; la L+S, che e' la sedia, non ha nessun criterio.

## Cosa resta di nuovo da misurare con LATI
Solo il **PF per lato** nella discesa e la **peggior giornata** (T3, solo realizzato). Il merito resta sospeso (88 giorni, n < 150).
La **vera prova di regime** (la cella in un mercato diverso dal toro 2024-26) richiede lo storico Dow dal 2012 (Dukascopy `USA30IDXUSD`: circa 3 ore di download e due firme di Claudio, `report/APERTURE_DOW_MAPPA_2026-10-03.md`).

## Correzioni proposte dal cancello (da scrivere PRIMA dei numeri)
1. Attesa DD = tetto IS + margine di confine di circa 1 punto (un'operazione a rischio 1%) [DERIVATO]; superare il tetto = anomalia di banco o di confine, si guarda il per-trade.
2. Un criterio L+S contro il contratto 7,8323 / tetto 5,7325.
3. T3: conta solo il realizzato per data di chiusura (giorno UTC+1, non il reset FTMO); il flottante resta fuori (errore nel verso permissivo, fino a ~1% di rischio aperto).
4. Parola di verdetto in chiaro: "MERITO: NON ANCORA MISURATO".

## Decisione (di Claudio, domani)
- (a) Rifare i file/il lettore con le 4 correzioni e lanciare comunque (10 minuti, costo zero, informazione modesta: PF per lato e peggior giornata nella discesa), oppure
- (b) lasciar cadere LATI e puntare sulla prova di regime vera con lo storico 2012+ (3 ore, due firme), oppure
- (c) passare ad altre righe gia' pronte (Dow R280, DAX PRV_DAXAP_04, Nasdaq R274, Bulge M1).
Raccomandazione: **(c) prima, e (b) come misura che chiude davvero la domanda del regime**; (a) solo se avanzano crediti. Il verificatore della *stringa* LATI ha dato **PASS** (bootstrap `e122ba60`, riga `48da1cac`, collaudo 198/198 e 152/152): quel verdetto resta valido se si sceglie (a). Ma il **giudizio** sui file prova e' FAIL, e **il primo che fallisce blocca**: la stringa **NON** va mandata a Claudio finche' non si decide e non si correggono i criteri (opzione a). Nota del verificatore per quando partisse: Claudio non deve guardare il tester durante i job A1 (LATIA1L e LATIA1S).
