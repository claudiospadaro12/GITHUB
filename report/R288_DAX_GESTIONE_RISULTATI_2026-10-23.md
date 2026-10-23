# R288 -- DAX Apertura 770101: gestione a pezzi (23/10/2026)
Fonte: `ROUND_R288_2026-10-23.zip` (pin 84a5c25f, motore = pin SHA256, 4 round rc 0, catena completa, per-trade 8 su 8). Archivio `backtest_pipeline/risultati_archivio/R288_20261023/`. Lettore congelato `r288_giudizio.py`. Deposito 100000, rischio 1%, D30EUR M5 tick reali.

| Braccio | IS: profit, PF, DD, deal | OOS: profit, PF, DD, deal | dPF IS / OOS | Verdetto |
|---|---|---|---|---|
| a cella viva | 3789, 1,126, 5,44, 175 | 18030, 1,397, 7,23, 270 | - | G0 **IDENTICO a R47a** |
| b senza trailing | **25765**, 1,394, 8,99, 198 | **2281**, 1,026, 8,74, 278 | **+0,267 / -0,371** | MISTO (segni opposti) |
| c senza parziale (e pareggio) | 5569, 1,183, 4,96, 132 | 23607, 1,491, 6,27, 193 | +0,057 / +0,094 | NON DISTINGUIBILE (sotto 0,10) |
| d senza pareggio | 3789, 1,126, 5,44, 175 | 19243, 1,416, 7,22, 270 | +0,000 / +0,019 | NON DISTINGUIBILE |
Attese dichiarate prima: P1 si', P2 si', P3 NO (b: misto), P4 NO (c: sotto soglia), P5 NO, P6 NO (nessun pezzo distinguibile), P7 SI (senza le 10 migliori il PF OOS e' 1,007, previsto < 1,10).

## Lettura
- **Il trailing cambia il segno fra IS e OOS.** Senza trailing l'IS fa 25765 (PF 1,394) contro 3789, ma l'OOS fa 2281 (PF 1,026) contro 18030. E' la firma di regime gia' vista altrove (Dow, Nasdaq): con un solo regime non si decide se il trailing "serve". Il numero di posizioni OOS e' 193 in tutti i bracci.
- **Il pareggio non fa niente**: in IS i risultati sono identici al centesimo (stessa data, stessi importi), in OOS +0,019 di PF. Coerente con il codice: a TP1 il pareggio scatta quasi sempre quando il trailing ha gia' portato lo stop sopra l'ingresso.
- **Senza parziale (e senza pareggio) il PF sale in entrambe le gambe** (+0,057 IS, +0,094 OOS: l'OOS e' 0,006 sotto la soglia congelata) e **anche profit e drawdown vanno nella stessa direzione in entrambe** (IS 3789 -> 5569, DD 5,44% -> 4,96%; OOS 18030 -> 23607, DD 7,23% -> 6,27%). **Non e' un verdetto**: il criterio congelato dice NON DISTINGUIBILE e non lo cambio. Lo stesso segno (toglierlo e' meglio, sotto soglia in almeno una gamba) era comparso sul Dow (R284d/R285: +0,14/+0,09 senza il Piano A).
- **Concentrazione (OOS, 193 posizioni):** la cella viva fa PF 1,397; senza le 5 migliori 1,159; senza le 10 migliori **1,007** (revisore: 1,03, ricalcolato diverso perche' conto in modo leggermente differente: qui ordino per netto della posizione). Il braccio senza parziale: 1,491 / 1,134 / 0,908; senza trailing: 1,026 / 0,906 / 0,790. **L'OOS del DAX regge su poche posizioni in ogni braccio.**
- **Limite dichiarato:** il braccio b sposta anche il livello della parziale (a 1R vero invece del livello mediano 0,57R col trailing): la differenza di b non e' solo "il trailing".

## Cosa NON dice
Niente su altri regimi; niente su quale pezzo tenere; non promuove niente e non cambia i set. Il merito resta sospeso (IS 132 posizioni, OOS 193, coda concentrata).
