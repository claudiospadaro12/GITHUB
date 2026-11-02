# Ambiguita' incontrate (interpretazione piu' letterale scelta)
1. Periodo = contenuto del file (P2015: 2015-01-02 00:00 .. 2015-12-31 22:58 server dopo +60; nessun filtro per anno server).
2. Livelli D1/W1/MN: solo dai dati del periodo (nessun dato precedente). Se manca un livello (inizio periodo) si usano quelli disponibili. W1 = ultima settimana ISO CON DATI precedente; MN idem. La prima settimana (parziale nei dati) viene usata come "precedente".
3. Stop gia' raggiunto all'ingresso: confronto con il prezzo d'ingresso incluso spread (long: ask<=SL; short: bid>=SL). Target lato sbagliato: stesso criterio (long target<=ask; short target>=bid).
4. Il controllo SL/target parte dalla M1 d'ingresso stessa (inclusa).
5. Ordine nella M1: gap SL all'open -> MKT (se aggiornamento target) -> TF -> SL intraminuto -> TP. MKT e TF possono coincidere (stesso prezzo): scelto MKT. Nessun TF osservato.
6. MAXHOLD: la barra d'ingresso conta come 1; TF quando sono chiuse 100 barre (elenco) dall'ingresso incluso, all'open della M1 seguente.
7. Aggiornamento target: alla prima M1 di una nuova ora-barra, target = SMA37 della barra precedente nell'elenco; flag MKT sulla prima M1 dopo (anche dopo gap). Nessun MKT sulla M1 d'ingresso.
8. "Chiusura di j successiva alla chiusura del trade precedente": close_j = start_j+60; chiusura trade = minuto (t) della M1 di uscita; confronto stretto >.
9. Filtro orario: ora di inizio barra j (server, dopo shift) in {13,14}.
10. Spread per minuto = SPREAD_BP*1e-4*open della M1 stessa (anche per le uscite a mercato / FINE_DATI). Spread del file ignorato. Segnali long e short contemporanei sulla stessa barra: mai verificati (0 casi).
11. ATR: serve close precedente, quindi TR per k>=1; irrilevante dato il minimo 38 barre. "almeno 38 barre precedenti" => indice j>=38 (0-based).
12. Uscita SL short: fill = max(SL, ask open); long: min(SL, bid open). Prezzo uscita in JSON = bid per long, ask per short; prezzo ingresso = ask long / bid short.
