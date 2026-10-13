# CENSIMENTO DEGLI EA DEL MQL5 MARKET IN PROVA SUI CONTI DEMO

_Creato il 13/10/2026 su richiesta di Claudio: "adesso sto testando degli expert provenienti dal market di MQL5". E' la memoria cumulativa del `lettore-expert-market`: una voce presente si AGGIORNA, non si duplica. Sono **EA scatola nera**: nessuno e' decompilato ne' lo sara' (regola del lettore)._

**Etichette:** **[LETTO nel conto: file]** visto negli ordini del conto demo · **[DICHIARATO DAL VENDITORE]** · **[INFERITO]** · **[NON VISTO]** / **[NON MISURATO]**. Famiglia con meno di 30 operazioni chiuse = **NON MISURATO per il merito**. L'attribuzione "NOSTRA/terzi" e' per **prefisso del commento** (ipotesi), salvo riscontro col magic.

**Come si legge un conto:** `python3 -I backtest_pipeline/natura_motore_da_storico.py <ReportHistory.xlsx | trades_auto.csv> [--dal AAAA.MM.GG] [--simbolo XAUUSD]` (SHA `302b5b74…`, sola lettura, 68 autotest). Non copre MAE/MFE, spread, chiusure parziali; lo SL messo con modifica subito dopo l'ingresso e' contato a parte.

## Conto demo piccolo 50503392 (`BCM Markets MT5 Terminal`), XAUUSD, installati l'11-12/10/2026

Fonte: `data/statements/ReportHistory_50503392_2026-10-12.xlsx` (Data 2026.10.12 21:59), letto il 13/10. Famiglie identificate dal **commento dell'ordine di apertura**. Tutte con n chiuse < 30.

| famiglia (commento) | chiuse/aperte | lati | netto | SL iniziale | SL mosso | TP | durata mediana | TF barra | note |
|---|---|---|---|---|---|---|---|---|---|
| `Basket_1234567_*_Initial` | 3/2 | long e short (4 ingressi col lato opposto vivo) | +42,77 (chiuse+aperte) | **no, 5/5** | 3/5 (3 oltre l'ingresso, 3 uscite a SL in profitto) | 110,00 fisso | 98 min | M1 | bandiere: senza SL iniziale, tiene i due lati, rischio non cappato in 5 istanti su 5; griglia/martingala/recupero NON scattano (nessuna seconda gamba oltre la Initial). Possibili due istanze (M1/M5) [NON VISTO: il xlsx non ha il magic] |
| `SSP scalp` | 4/0 | long | +6,55 | si, 4/4 | no | 6,80 (SL med 4,74; SL/TP 0,70) | 36 min | M5 | stop/commissione **106x** (commissione A/R 4,00 EUR/lotto contro ~89,45 EUR per 1,0 di prezzo per lotto): "scalping" scatta [INFERITO: stessa casa di SSPv4] |
| `XAUUSD 5 Minute` | 0/2 | long | flott. +13,34 | si (SL 40,3) | no | **nessun TP** | - | M15 | solo posizioni aperte |
| `SSPv4` | 0/1 | - | flott. -4,33 | si | no | 12,90 | - | M5 | una posizione |

Riscontro sul totale del conto: 21 chiuse (7 XAUUSD), netto 41,96, PF dichiarato 1,473 (ricalcolato 1,4733). Le famiglie NOSTRE sullo stesso conto: BULGE, MAXMIN ORO, COST, LARRY, GAP (per prefisso).

**Stato:** schede di natura complete **NON ANCORA SCRITTE** (`report/MARKET_SCHEDA_*.md`). Mancano per una lettura completa: screenshot del pannello input di ogni EA (lotto, SL/TP, orari, magic, modalita' di rischio) e i giorni successivi (n a 30). Da fare con `lettore-expert-market`.

| EA / famiglia | simbolo/TF | ultima lettura | n chiuse | stato |
|---|---|---|---|---|
| Basket_1234567 | XAUUSD M1 (M5?) | 13/10/2026 | 3 | NON ANCORA MISURATO (natura: senza SL iniziale, due lati) |
| SSP scalp / SSPv4 | XAUUSD M5 | 13/10/2026 | 4 / 0 | NON ANCORA MISURATO (costo 106x lo stop) |
| XAUUSD 5 Minute | XAUUSD M15 | 13/10/2026 | 0 | NON ANCORA MISURATO (solo aperte, senza TP) |
