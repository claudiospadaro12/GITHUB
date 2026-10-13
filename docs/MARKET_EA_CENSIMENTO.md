# CENSIMENTO DEGLI EA DEL MQL5 MARKET IN PROVA SUI CONTI DEMO

_Creato il 13/10/2026 su richiesta di Claudio: "adesso sto testando degli expert provenienti dal market di MQL5". E' la memoria cumulativa del `lettore-expert-market`: una voce presente si AGGIORNA, non si duplica. Sono **EA scatola nera**: nessuno e' decompilato ne' lo sara' (regola del lettore)._

**Etichette:** **[LETTO nel conto: file]** visto negli ordini del conto demo · **[DICHIARATO DAL VENDITORE]** · **[INFERITO]** · **[NON VISTO]** / **[NON MISURATO]**. Famiglia con meno di 30 operazioni chiuse = **NON MISURATO per il merito**. L'attribuzione "NOSTRA/terzi" e' per **prefisso del commento** (ipotesi), salvo riscontro col magic.

**Come si legge un conto:** `python3 -I backtest_pipeline/natura_motore_da_storico.py <ReportHistory.xlsx | trades_auto.csv> [--dal AAAA.MM.GG] [--simbolo XAUUSD]` (SHA `302b5b74…`, sola lettura, 68 autotest). Non copre MAE/MFE, spread, chiusure parziali; lo SL messo con modifica subito dopo l'ingresso e' contato a parte.

## Conto demo piccolo 50503392 (`BCM Markets MT5 Terminal`), XAUUSD, installati l'11-12/10/2026

Fonte: `data/statements/ReportHistory_50503392_2026-10-12.xlsx` (Data 2026.10.12 21:59), letto il 13/10. Famiglie identificate dal **commento dell'ordine di apertura**. Tutte con n chiuse < 30.

| famiglia (commento) | chiuse/aperte | lati | netto | SL iniziale | SL mosso | TP | durata mediana | TF barra | note |
|---|---|---|---|---|---|---|---|---|---|
| `Basket_1234567_*_Initial` | 3/2 | long e short (4 ingressi col lato opposto vivo) | +42,77 (chiuse+aperte) | **no, 5/5** | 3/5 (3 oltre l'ingresso, 3 uscite a SL in profitto) | 110,00 fisso | 98 min | M1 | bandiere: senza SL iniziale, tiene i due lati, rischio non cappato in 5 istanti su 5; griglia/martingala/recupero NON scattano (nessuna seconda gamba oltre la Initial). Possibili due istanze (M1/M5) [NON VISTO: il xlsx non ha il magic] |
| `SSP scalp` | 4/0 | long | +6,55 | si, 4/4 | no | 6,80 (SL med 4,74; SL/TP 0,70) | 36 min | M5 | stop/commissione **106x** (verso: lo stop vale 106 volte la sola commissione A/R, 4,00 EUR/lotto contro ~89,45 EUR per 1,0 di prezzo per lotto, cioe la commissione pesa POCO sullo stop; lo SPREAD non e' nel conto: costo pieno [NON MISURATO]); lo strumento segnala comunque "scalping" per la durata/dimensione dello stop [INFERITO: stessa casa di SSPv4] |
| `XAUUSD 5 Minute` | 0/2 | long | flott. +13,34 | si (SL 40,3) | no | **nessun TP** | - | M15 | solo posizioni aperte |
| `SSPv4` | 0/1 | - | flott. -4,33 | si | no | 12,90 | - | M5 | una posizione |

Riscontro sul totale del conto: 21 chiuse (7 XAUUSD), netto 41,96, PF dichiarato 1,473 (ricalcolato 1,4733). Le famiglie NOSTRE sullo stesso conto: BULGE, MAXMIN ORO, COST, LARRY, GAP (per prefisso).

**Stato:** schede di natura complete **NON ANCORA SCRITTE** (`report/MARKET_SCHEDA_*.md`). Mancano per una lettura completa: screenshot del pannello input di ogni EA (lotto, SL/TP, orari, magic, modalita' di rischio) e i giorni successivi (n a 30). Da fare con `lettore-expert-market`.

| EA / famiglia | simbolo/TF | ultima lettura | n chiuse | stato |
|---|---|---|---|---|
| Basket_1234567 | XAUUSD M1 (M5?) | 13/10/2026 | 3 | NON ANCORA MISURATO (natura: senza SL iniziale, due lati) |
| SSP scalp / SSPv4 | XAUUSD M5 | 13/10/2026 | 4 / 0 | NON ANCORA MISURATO (stop/commissione 106x; spread non misurato: costo pieno ignoto) |
| XAUUSD 5 Minute | XAUUSD M15 | 13/10/2026 | 0 | NON ANCORA MISURATO (solo aperte, senza TP) |
| **ARENA NEXUS GRID SMART XAU MT5** (commenti `FinlabX`/`CF`/`DZR` + `[F]`/`[R]` + `CID`, [INFERITO] alta confidenza) | XAUUSD M1 | 13/10/2026 | 608 chiuse in ~21 h (UN solo giorno) | NON ANCORA MISURATO: griglia + scala di lotti + recovery a cesto, senza SL iniziale; profitto del giorno 480,71 EUR (pannello) / 487,31 (nostro conto); Risk Mode Moderate; scheda `report/MARKET_SCHEDA_FINLABX_CF_DZR_2026-10-13.md`, ricostruzione `report/MARKET_MOTORE_FINLABX_RICOSTRUZIONE_2026-10-13.md` |
| (stessa riga, input) | InpBaseLot 0,01 · BOTH_SIDES · FridayGapProtection **false** · CounterFlow trigger 0,2, moltiplicatore 1,0, max 1 viva · DeadZone trigger 0,2 · magic 888 · versione 1.20; griglia/lotti/profondita' NON esposti | 13/10/2026 | | CF = CounterFlow, DZR = DeadZone Reaction (provato: max 1 viva per lato); Risk Mode del pannello NON e' un input |

## PIANO DI OSSERVAZIONE (scritto il 13/10/2026 sera, PRIMA dei numeri) -- altri EA GRATUITI dallo store sul demo 50503392
Richiesta di Claudio: _"ho caricato qualche altro EA gratuito dallo store MQL5. Vediamo come vanno. Poi facciamo delle valutazioni."_ Gli EA nuovi sono **scatole nere**: stessa regola di tutti gli altri (nessuna decompilazione, nessun numero del venditore come nostro, nessun «morto» senza certificato).
- **Linea di base**: il ReportHistory del 13/10 22:26 (`data/statements/ReportHistory_50503392_2026-10-13.xlsx`) e' la fotografia **prima** dei nuovi EA: tutto cio' che compare nei report successivi con un commento d'apertura nuovo e' di un EA nuovo. [Se un nuovo EA scrive un commento gia' presente (es. un prefisso nostro), l'attribuzione si ferma e si chiede a Claudio.]
- **Per ogni EA nuovo servono (lo fa Claudio, una volta)**: il **nome esatto** come compare sul grafico/Market, il **simbolo e il TF** del grafico, lo **screenshot degli Input** (F7 sul grafico) e l'**ora di installazione**. Senza input, lotto/SL/TP/orari/magic restano [NON VISTO].
- **Ogni sera**: il ReportHistory completo (Cronistorico -> tasto destro -> Report -> Open XML, **con la sezione Ordini**, perche' il commento sta li') dal terminale 50503392 `BCM Markets MT5 Terminal`. Lo leggo con `natura_motore_da_storico.py` e, per i commenti con identificativi lunghi, con l'analisi dei cesti.
- **Scritto prima, per non rincorrere i numeri**: (1) **natura** (lati, SL/TP/trailing, griglia/scala di lotti/hedging, durata, costo) leggibile da subito; (2) **merito: NON MISURATO** sotto 30 chiuse per famiglia (pavimento dello strumento), e anche sopra 30 il PF del demo e' una descrizione: il merito vale da >= 150 operazioni con regime dichiarato (regole 4-5 del protocollo del 08/10); (3) **un giorno di profitto non e' un'attesa**: l'EA «Arena Nexus Grid» ha fatto +487 EUR in un giorno e il proxy sul suo meccanismo capato prevede NULLO; quindi ogni EA si guarda per **piu' giorni, includendo una giornata contraria** e per la **coda** (posizioni senza SL, lotti vivi insieme), non per il profitto del giorno; (4) bandiere rosse prop (no-SL, griglia, scala di lotti, recovery, hedging fra istanze, scalping sotto soglia di costo) lette sempre; (5) un EA con meccanismo pulito (SL iniziale, nessuna griglia) e campione sufficiente entra nell'imbuto come **candidato da misurare nel nostro tester**, non come sedia.
- **Cosa NON si fa**: nessun EA del Market si porta su un conto prop o reale; nessun parametro nostro cambia per imitarli; nessun verdetto «buono/cattivo» da una settimana di demo.
| EA (nome esatto) | simbolo/TF | installato | input visti | ultima lettura | stato |
|---|---|---|---|---|---|
| (da compilare quando Claudio manda nomi e input) | | 13/10/2026 sera | no | -- | IN OSSERVAZIONE |
