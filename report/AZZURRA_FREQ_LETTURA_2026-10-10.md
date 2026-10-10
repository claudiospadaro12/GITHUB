# AZZURRA_FREQ -- lettura del 10/10/2026 (zip `AZZURRA_FREQ.zip`, pin 4e08b8a9)

**Domanda**: "l'Azzurra attiva dal 09/10 sul piccolo 50503392 (magic 774500) non ha aperto niente: e' normale?"
**Esito in una riga**: SI, e' plausibile. Sui simboli che il tester vede l'Azzurra apre ~3,4-3,5 posizioni per giorno feriale, ma il venerdi' 09/10
dalle 15:39 server era 7/24 di giornata: P(0 aperture) ~ 35-37%. **Merito: NON ANCORA MISURATO** (Modello 1, un regime). Vietato "morto".

## Cancelli (letti PRIMA dei numeri)
- 16 passate, compilazione 0/0, precondizioni p1-p4 tutte vere in tutte le 8 celle, 33 su 33 simboli con storico fino al 09/10.
- Replica A0/B0 (job diversi, stessi input salvo magic): IDENTICA, 246 deal uguali uno per uno -> i controlli B e C si leggono.
- G1 (gemelle): Trades IDENTICI in tutte e due le gambe di A, C, D. Il Profit OOS differisce di **0,01** (es. A0 -706,79 / A1 -706,78) e il lettore
  scrive "NON OK" perche' il criterio diceva "identici al centesimo". **Applico la regola scritta prima**: la frequenza si legge, PF e DD NO.
  (PF a 5 decimali identico: 0,82014 / 0,82014; ma il criterio non si ammorbidisce dopo i numeri.)
- Ricalcolo indipendente dal per-trade (non dal lettore): lambda, giorni a zero, serie, chiusure del venerdi', end-of-test = TUTTI uguali al lettore.

## Frequenza (aperture per giorno feriale, 73 giorni OOS 01/07-09/10)
| cella | simboli | Trades IS | Trades OOS | lambda OOS | giorni a zero | serie max a zero |
|---|---|---|---|---|---|---|
| A0 (base) | 22 cross | 506 | 246 | **3,370** | 9 (12,3%) | 3 |
| D0 (campo) | 33 | 527 | 259 | **3,548** | 6 (8,2%) | 2 |
| B1 (solo primo tocco) | 22 | 385 | 183 | 2,507 | 11 | 3 |
| C0 (ritracciamento spento) | 22 | 1374 | 775 | 10,616 | 0 | 0 |
- lambda IS (D) 4,117 -> rapporto OOS/IS 0,86: nessuna dipendenza forte dal tratto. Dentro la banda attesa 0,6-10.
- **B1**: 0,76 / 0,74 -> dentro l'attesa. **C0**: 2,72 / 3,15 -> ALTERNATIVA B: **il filtro del ritracciamento ordinato decide la frequenza**
  (taglia ~2/3 dei segnali). E' LA manopola della frequenza dell'Azzurra, non il TF e non la lista simboli.
- Giorni a zero osservati 8,2% contro Poisson 2,9%: entro +10 punti, ma i giorni sono raggruppati (serie fino a 3 giorni).

## Il venerdi' 09/10 (P-VEN)
- Tester: chiusure vere del 09/10 = 5 (00:09, 08:30, 09:00, 13:12, 14:22), **0 dalle 15:39 server**; 2 posizioni (EURNZD, NZDJPY) ancora aperte a
  fine gamba (deal "end of test" 21:54:59). L'ora di apertura di queste due NON e' nel per-trade [NON MISURATO].
- P(0) per 7/24 di giornata: 35,5% (lambda 3,548) / 37,4% (lambda 3,370). Il venerdi' a zero NON dice "campo muto".
- Cio' che dira' se il campo e' muto: i PROSSIMI giorni pieni. Con lambda ~3,4: un giorno pieno a zero ~3%; **due giorni pieni consecutivi a
  zero ~0,1% -> anomalia da controllare** (giornale del 50503392, Algo Trading verde, righe `[BULGE]`).

## 🔴 Cecita' per CLASSE (classe 1225) -- il numero "33 simboli" e' in realta' 24
- **9 degli 11 non-FX hanno ZERO aperture** (100GBP, 200AUD, D30EUR, E35EUR, E50EUR, F40EUR, NASUSD, SPXUSD, U30USD); lavorano solo XAUUSD (7)
  e 225JPY (7). Tutti i 22 cross lavorano. Lo storico c'e' (giornale agente: 33/33 sincronizzati), quindi NON e' storico mancante.
- Il lettore dice NON MISURATO (giusto): la lambda 3,548 e' di 24 simboli con l'etichetta dei 33.
- **Ipotesi nel codice, [NON MISURATA]**: in `OnTick` (r.1003-1013) `g_lastBarTime[i]` viene aggiornato PRIMA del controllo `CountOpenTrades() >= Max_Trades`:
  un simbolo valutato con 4 posizioni gia' aperte PERDE quella barra, per sempre; e i simboli sono visitati in ORDINE DI LISTA (gli indici sono in coda).
  Contro l'ipotesi: 225JPY, nel mezzo della coda, lavora. Alternative: filtro ATR 0,5-1,8, orari di sessione degli indici, margine/lotto minimo.
- Se fosse il tetto, **vale uguale in campo** (stesso codice): gli indici in coda non vedrebbero mai uno slot. Rilevante per la famiglia a 33 simboli.
- **Misura piu' corta**: un job con i SOLI 9 simboli a zero (stesso EA, stessi input; cambia solo Symbols_List) + controllo positivo Use_Purple=1,
  ~3-4 minuti di tester sul PC. Se lavorano da soli -> tetto/ordine; se restano a zero -> cecita' vera o filtro. Da scrivere in prova e passare dal cancello.

## Screening di merito (Modello 1: NESSUN verdetto)
D0: IS PF 0,961 (n 527) / OOS PF 0,836 (n 259), WR OOS 74%; A0 OOS 0,820; B1 OOS 0,697; C0 OOS 0,862 (IS 0,758, DD 54,7%).
Attesa scritta prima: PF OOS 0,7-1,1 -> dentro. Alternativa (edge): PF >= 1,30 con n >= 150 -> **non** soddisfatta in nessuna cella.
Resta il profilo TP-vicino/SL-lontano (WR alto, PF < 1). Certificato di morte: mancano uscita ad asse, simboli gemelli, TF -> **"NON ANCORA MISURATO"**.

## Cosa NON dice questa lettura
Non dice nulla su tick reali, ne' sul merito in campo. Non cambia taglia, preset, ne' lo stato della sedia sul piccolo 50503392.
E' una misura di FREQUENZA.
