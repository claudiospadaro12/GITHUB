# 10 set community oro H1 contro GoldenZoe: correlazione del P&L realizzato (27/11/2026)

**Metodo:** P&L realizzato per data di uscita (deal chiusi dei report R3); GoldenZoe = ricostruzione dalle regole (breakout 55 barre H4, stop 3 ATR con chandelier, solo long) su oro FTMO 2004-2026, in R-multipli (non il simulatore di produzione). Periodo A: 2004-09 -> 2019-12 (set a 1 minuto, 184 mesi, 62 trimestri); periodo B: 2025-01 -> 2026-10 (tick, 22 mesi, 8 trimestri). Script: `backtest_pipeline/ubs_corr_r3_goldenzoe.py`.

| Serie (somma dei 5 set) | Mensile vs GoldenZoe (A) | Trimestrale (A) | Mensile (B) | vs rendimento oro (A, mensile) |
|---|---|---|---|---|
| G50xxx | 0,02 | 0,16 | -0,17 | 0,09 |
| G80xxx | -0,03 | 0,16 | 0,06 | 0,02 |
| Tutti e 10 | 0,00 | 0,17 | -0,04 | 0,06 |
| UBS oro D1 (13 set di R2) | 0,23 | 0,24 | - | -0,01 |
| GoldenZoe stesso | 1,00 | 1,00 | 1,00 | **0,42** (trimestrale 0,48; B 0,62) |
Singoli set vs GoldenZoe (mensile, A): da -0,07 a 0,06; (B): da -0,27 a 0,15.
**Fra i 10 set:** correlazione mensile media 0,56 (massima 0,85) nel periodo A; 0,73 (massima 0,94) a tick nel periodo B: una famiglia, non dieci strategie.

## Lettura e limiti
- **Correlazione con GoldenZoe bassa su 184 mesi (|r| <= 0,06 mensile, <= 0,17 trimestrale).** Coerente con il fatto che GoldenZoe segue il trend dell'oro (0,42 col rendimento mensile) mentre questi set no (0,06-0,09): sono breakout su pivot, long e short, ordini stop con stop e target.
- **Il P&L realizzato per data di uscita sottostima la correlazione di sistemi con poche operazioni a uscite sfasate** (GoldenZoe: circa 18 trade l'anno); la misura buona e' la curva dell'equity a mercato, non disponibile qui. Il campione (184 mesi) e' pero' molto piu' grande di quello della misura del 26/11.
- GoldenZoe e' ricostruito dalle regole; un'eventuale differenza col codice reale non e' misurata. Una correlazione bassa dice che, se il vantaggio c'e', diversifica; non lo dimostra. Set di terzi: fuori dalla flotta prop fino a decisione di Claudio.
