# R278: la regola di Emiliano (candela 5 minuti) sul Dow (U30USD), lettura (22/10/2026)

Fonte: `ROUND_R278_2026-10-22.zip` (3 file x 4 passate, tick reali, U30USD M5, deposito 80.000, finestra 2024.09.26-2026.06.30, taglio 0,40, rischio 2%, pin eec5e0f6). Archivio `risultati_archivio/R278_20261022`. Lettore congelato `r278_giudizio.py`. Non controllata da agenti. Gemelle identiche in tutti e 3, motore = pin, catena completa, 6 per-trade su 6.

## Risultati
| file | IS: n / PF / DD | OOS: n / PF / DD / profitto |
|---|---|---|
| a filtro 17-38 | 109 / 0,94 / 14,3% | 177 / 0,64 / 40,1% / -26.865 |
| b filtro SPENTO | 269 / 0,57 / 54,5% | 424 / 0,71 / 55,4% / -39.489 |
| c filtro 34-76, buffer 20 | 99 / 0,62 / 23,8% | 198 / 0,68 / 37,8% / -23.104 |
- **Filtro 17-38 (a) e 34-76 (c): NON DIMOSTRATI.** Il DD scende rispetto allo spento ma il PF non sale in OOS (a: -0,07; c: -0,03), e in c il numero di affari in IS e 0,37 del controllo (soglia 0,40).
- **Nessuna cella PASSA** (PF >= 1,10 in IS e OOS): **tutte e tre perdono in OOS** (PF 0,64-0,71, DD 38-55% a rischio 2%).

## Contro le previsioni
D1 gemelle: CENTRATA. D2 (R278a rapporto affari < 0,40): **FALLITA** per poco (0,41 e 0,42); R278c fra 0,35 e 0,80: centrata (0,37 / 0,47). **D3 (PF dello spento fra 0,85 e 1,15): FALLITA** (0,57 / 0,71). D4 filtro utile (previsto improbabile): non avvenuto, centrata. D5 nessuna cella passa: CENTRATA.

## Divisione per stagione, solo gamba OOS (ESPLORATIVA, fatta dopo)
| file | mesi allineati | mesi invernali (1 ora prima) |
|---|---|---|
| a 17-38 | 69 pos, -19.398, PF 0,60 | 47 pos, -7.467, PF 0,71 |
| b spento | 184 pos, -25.911, PF 0,72 | 87 pos, -13.578, PF 0,66 |
| c 34-76 | 117 pos, -23.351, PF 0,66 | 10 pos, +247, PF 1,06 (n troppo piccolo) |
**Con l'orologio giusto (mesi allineati) il Dow perde lo stesso**: a differenza del Nasdaq (PRE acceso PF 1,48 nei mesi allineati), qui nessuna cella e positiva.

## Lettura
- La regola dei 5 minuti **non funziona sul nostro Dow**, ne con i filtri 17-38 ne con quelli scalati: il consiglio di Emiliano "da domani passate all'US30" non trova conferma nel backtest 2024-2026 (con TP1 0,5R, trailing, rischio 2%, nostra gestione). Resta un'osservazione di due giorni sua.
- Limiti: una sola cella d'uscita, soglie 34-76 inventate da noi, un solo percorso storico, nessun piano B. Non e un test di tutto cio che fa lui a mano.
- Nessuna taglia, nessun consiglio di acquisto.
