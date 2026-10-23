# R287 -- orologio dell'ORB: ora fissa (a) contro ora solare US automatica (b) (23/10/2026)
Fonte: `ROUND_R287_2026-10-23.zip` (pin 1367900f, motore = pin SHA256, 2 round rc 0, catena completa, per-trade 4 su 4). EA ABTG_ORB_Emiliano v1.01. Archivio: `backtest_pipeline/risultati_archivio/R287_20261023/`. Lettore congelato `r287_giudizio.py`.

| Braccio | Leg | Profit | PF | DD% | Operazioni |
|---|---|---|---|---|---|
| a ora fissa (la sedia) | IS | 7630,13 | 1,247 | 8,25 | 71 |
| | OOS | 33442,57 | 1,678 | 9,99 | 119 |
| b ora solare US automatica | IS | 3210,82 | 1,133 | 12,00 | 63 |
| | OOS | 16061,68 | 1,500 | 7,24 | 105 |

## Esito del lettore congelato
- **G1 e G0 passano:** gemelle identiche; R287a = R283a al centesimo (la v1.01 con le novita' spente e' la sedia).
- **S1 FALLISCE: esito formale NON LEGGIBILE.** Pre-registrato: "fuori dall'inverno le posizioni dei due bracci sono identiche (stessa data, |diff netto| <= 0,02)". **Il criterio era mal posto da me:** il lotto segue il saldo, e dopo l'inverno il braccio b ha un saldo piu' basso, quindi gli importi differiscono. Cosa e' vero (post-hoc, NON congelato): prima dell'inverno (43 posizioni, fino al 31/10/2025) i due bracci sono identici al centesimo; dopo l'inverno (30 posizioni, da marzo 2026) **le date sono le stesse (73 date fuori inverno uguali)** e gli importi sono in rapporto costante 0,84-0,85, cioe' lo stesso trade con lotto piu' piccolo. L'orologio non cambia niente fuori dall'ora solare, come previsto; **il verdetto formale resta NON LEGGIBILE** e non lo cambio a posteriori.

## Numeri descrittivi POST-HOC (non congelati; euro con lotto che dipende dal saldo)
| Periodo (per data di chiusura) | a: posizioni, vinte, netto, PF | b: posizioni, vinte, netto, PF |
|---|---|---|
| Inverno US OOS (03/11/2025-06/03/2026) | 46, 16, +17940, 1,71 | 32, 14, +1325, 1,14 |
| di cui gennaio-febbraio 2026 | 20, 9, +16721, 2,62 | 12, 6, +692, 1,24 |
| Inverno senza gen-feb | 26, 7, +1219, 1,08 | 20, 8, +633, 1,09 |
- **Tutta la differenza viene da gennaio-febbraio 2026.** Senza quei due mesi i due orologi sono indistinguibili (PF 1,08 e 1,09, 26 e 20 posizioni). In gen-feb l'ora fissa (pre-cash, 08:30 ET) ha preso i movimenti grandi: +16721 su 20 posizioni contro +692 su 12.
- In aggregato anche l'IS e' peggiore con l'ora solare (PF 1,133 contro 1,247, 63 contro 71 operazioni), ma l'IS non ha per-trade e contiene un inverno (2024-25).
- Il braccio b ha meno posizioni invernali (32 contro 46): il range 15:30-15:45 filtra piu' giorni (soglia 0,8% e EMA200 sul nuovo range).
- **Attese dichiarate:** P1, P2 sì; P3 (S1) NO per un criterio mal posto; P4 (b - a > 0 nell'OOS) NO; P5 non valutabile in modo congelato (post-hoc: con e senza gen-feb la differenza e' positiva per a); P6 NO (32 contro 46: -30%).

## Cosa significa e cosa NO
- **Nessun verdetto di merito** (46 e 32 posizioni invernali, un solo inverno OOS dominato da gen-feb). Il dato non dice che l'ora fissa e' migliore: dice che nei 4 mesi invernali l'unico segmento in cui i due orologi divergono e' stato vinto da un'ora fissa grazie a due mesi eccezionali.
- Cosa NON e' misurato: il costo di armare in pieno dato macro (spread, slippage); piu' inverni; l'effetto su una sedia con stop diverso.
- Non cambia nessuna ora di nessuna sedia. La decisione `cash` o `prima` per l'ORB dal 02/11 resta di Claudio, con questa informazione: **nei dati disponibili spostare a ora solare non ha migliorato niente, e ha tolto i giorni di gen-feb.**
