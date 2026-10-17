# Pacchetto Oro -- W1 (luglio-settembre 2026): Gold Reaper 5.4 e TIG nel nostro tester (lettura del 17/10/2026)

Fonte: `risultati_archivio/PACCHETTO_ORO_W1_20261017/` (zip GOLDREAPER e TIG, giro lanciato alle 09:17). Attese e criteri scritti PRIMA dei numeri: `THE_GOLD_REAPER_ATTESE_2026-10-16.md`, `THE_IMPOSSIBLE_GOLD_ATTESE_2026-10-16.md`, `PACCHETTO_ORO_ATTESE_2026-10-17.md`. Operazioni ricostruite dagli Affari dei report (abbinamento in->out per lato e volume; somme = profitto del report, controllato).

## Conformita' [LETTO nei REFERTO]
Tutte le 6 tranche OK: XAUUSD, finestre mensili corrette, **100% ticks reali**, deposito 5.000 EUR, leva 1:100, nessun input imposto, **.ex5 con la stessa SHA256 prima e dopo ogni tranche** (Gold Reaper AB636AF9..., TIG 30213352...). Ticks XAUUSD reali dal 10/07/2024. Il tester gira VELOCE: **Gold Reaper circa 11-13 minuti per mese, TIG 38 secondi per mese**: la finestra lunga W2 (18 mesi) costa circa 3,6 ore per il Gold Reaper e 12 minuti per TIG.

## THE GOLD REAPER 5.4 (H1, default) [LETTO + DERIVATO]
| mese | operazioni | vinc. | netto EUR | PF | DD equita' |
|---|---|---|---|---|---|
| luglio | 33 | 51,5% | -66,83 | 0,60 | 4,35% |
| agosto | 40 | 65,0% | +611,85 | 4,00 | 4,50% |
| settembre | 40 | 77,5% | +726,73 | 8,44 | 2,96% |
| **tot** | **113** | **65,5%** | **+1.271,75 (+25,4%)** | **3,73** | max 4,50% |
Luglio e' **identico al giro del 16/10** (-66,83): il tester e' riproducibile. Ha aperto solo alcune strategie; lotti 0,01-0,05, posizioni contemporanee al massimo 0,22 lotti (agosto). Giorno peggiore REALIZZATO -145,5 (12/8, -2,7%).
- **H1** (positivo in 2 mesi su 3): **REGGE** (agosto e settembre).
- **H2'** (DD <= 14%): **REGGE** (4,35%, 4,50%, 2,96%).
- **H3'** (rapporto lotti <= 2): **SMENTITA alla lettera**: luglio 2,0, agosto 5,0, settembre 4,0. Il lotto cresce con il saldo e con il peso della strategia (nessuna martingala vista, ma il criterio scritto era un tetto).
- **H4/H6** (giorno <= -200 EUR): **non smentita sul realizzato** (peggiore -145,5); l'equity intraday vera richiede il replay M1.
- **H5** (win rate 65-80% a ticks reali): aggregato **65,5% DENTRO**; luglio da solo 51,5% fuori.
- Cautela: **agosto e settembre 2026 sono mesi di trend forte dell'oro** (PF 4 e 8,4 sono molto alti): un periodo favorevole ai breakout. Tre mesi, un feed. Il test lungo W2 serve a questo.

## THE IMPOSSIBLE GOLD (TIG) (M5, default) [LETTO + DERIVATO]
| mese | operazioni | vinc. | netto EUR | PF | DD equita' |
|---|---|---|---|---|---|
| luglio | 70 | **1** | -3.072,56 | 0,18 | **75,5%** |
| agosto | 56 | **2** | +3.163,54 | 1,37 | **61,6%** (13.088 EUR di DD da un picco alto) |
| settembre | 104 | **1** | -3.815,57 | 0,10 | **76,9%** |
| **tot** | **230** | **4 (1,7%)** | **-3.724,59** | 0,77 | |
**TIG e' una lotteria a un rischio per trade dell'1,5% composto**: 218 stop da circa -1,5% dell'equity (medi -69 EUR) e **4 vincite in tutto**: +691 (luglio, 97 USD di movimento), +7.928 (agosto, 292 USD in 4 giorni, da 4.041 a 4.334), +3.699 (agosto, 88 USD), +404 (settembre). Senza il +7.928 di agosto il trimestre sarebbe -11.650. Lo stesso profilo si vede sul demo: il BUY 0,36 aperto il 14/10 e' una di queste rare vincite.
- **T0** (i default coincidono col demo): **REGGE**, tutti gli input letti dal report coincidono con la scheda (lookback 16, buffer 1,5, SL 25, TP 300, rischio 1,5% composto, max 1 posizione, max 5 al giorno, sessione 10-20, esclusione 12-15, trailing 10/2, estensione TP 14, regime EMA 50).
- **T1**: una sola posizione per volta (**regge**); rapporto lotti 4,3 / 2,7 / 4,3 (**smentito alla lettera**: i lotti seguono l'equity: scendono da 0,34 a 0,08 nei drawdown, salgono con la vincita; non c'e' scala dopo le perdite: e' il contrario).
- **T2** (max 5/giorno): **REGGE** (5, 5, 5).
- **T3** (sessione): nel tester le aperture stanno fra le 10:00 e le 19:59 SERVER (ore 10, 11, 15-19): l'EA usa l'orologio del server come fosse GMT; il demo del 14/10 operava un'ora dopo (11:05, 12:05, 19:15). **Differenza di un'ora fra tester e live** [DERIVATO]: smentita rispetto alla finestra "GMT = server -1".
- **T4** (perdita per stop 1,0-2,0%): **REGGE** su 229 stop su 230; **eccezione: 14/07 sell 0,17 lotti chiuso a -735,2 (-29% dell'equity)**: stop di 25 pips "saltato" dal rilascio dei dati (CPI, 13:30 server): lo stop non e' un limite sulle notizie. Un caso su 230, ma pesa quanto otto stop.
- **T5** (win rate < 40% in ogni mese): **REGGE** (1,4%, 3,6%, 1,0%).
- **T6** (giorno <= 7,5%): **SMENTITA** sul realizzato: 14/07 -29,5%, 16/09 -11,7%, 28/08 -10,6%, 06/07 -9,3%.
- **T7** (positivo in almeno 2 mesi su 3 e somma positiva): **CONTRARIO**: positivo 1 mese su 3, somma -3.724,59, 230 operazioni (sopra le 60 minime).
**Giudizio descrittivo**: TIG a questa taglia (1,5% composto) NON e' adatto ne' a una prop ne' a un reale da 4.000 EUR: drawdown di equity 60-77% in tre mesi su tre. Il demo di ieri (+2.531 flottanti) e' una di quelle quattro vincite. **Un TIG con rischio per trade molto piu' basso** (0,1-0,25%) e' un'altra prova da fare, ora costa 12 minuti.

## Cosa NON dicono questi numeri
Tre mesi, un feed (BCM), nessuna slippage del reale (il tester ha lo stop a prezzo ma con salti reali nei ticks), commissione del tester 0,02 EUR per 0,01 lotti a lato [la commissione BCM vera e' ancora da avere per iscritto]. Per il Gold Reaper il filtro NFP nel tester usa offset GMT manuali sfasati: la protezione non e' quella del live.
Le tre prove del pacchetto (Gold Trade Pro, Goldbot One, Gold Phantom) sono in corso sulla seconda riga, con i timeframe ancora da confermare.
