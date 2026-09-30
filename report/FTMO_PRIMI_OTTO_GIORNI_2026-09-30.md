# FTMO 541452707: i primi 8 giorni, sedia per sedia (22/09 - 30/09/2026)

Fonte: Report Cronistorico dei Trade di Metrix (`data/statements/FTMO_541452707_cronistorico_2026-09-30.xlsx`, generato 30/09 09:10 ora del report), 13 posizioni chiuse, somma **-7.002,99** = 72.997,01 - 80.000,00 (torna col saldo Metrix della foto di Claudio). R = lotti x |entrata - stop iniziale| dell'ordine.

## 1. Per sedia
| origine | n | somma EUR | note |
|---|---:|---:|---|
| **XAUUSD, nessun commento, ordini a mercato** | 2 | **-2.502,06** | 28/09 19:25 buy 1,0 lotto (+293,29) e 19:28 buy 2,0 lotti (-2.795,35, chiuso a SL). Nessuna sedia oro esiste su FTMO e tutte le sedie ABTG scrivono un commento: sono ordini **non della flotta** [DA CONFERMARE da Claudio] |
| `770411` MaxMin DAX short | 3 | -2.236,00 | 24/09 -1.668,46 (-1,03 R) · 29/09 +968,37 (+0,65 R) · 30/09 -1.535,91 (-1,01 R) |
| DAX Apertura EU (`770101` buy, `770105` sell) | 5 | -1.258,07 | 4 su 5 escono a +0,03/+0,06 R in pochi minuti; 1 stop pieno -1,01 R (25/09) |
| EMA200 Dow (`771531`, ordini S1/S2) | 3 | -1.006,86 | 22/09 due stop pieni (-0,95 e -0,98 R) · 25/09 +0,89 R |
| **Flotta (11 posizioni)** | 11 | **-4.500,93** | somma in R = **-3,25 R**; 6 vincenti (media +0,29 R), 5 perdenti (media -1,00 R) |

## 2. Cosa si vede (con la cautela dovuta a 11 operazioni)
1. **Il 36% della perdita (-2.502) non viene dalla flotta**: sono le due operazioni sull'oro del 28/09 sera. Senza di esse il conto sarebbe a ~75.500 (margine al muro 72.000 di ~3.500).
2. **Asimmetria strutturale di payoff** nelle sedie DAX Apertura: vincite +0,03..+0,06 R in 43 secondi-9 minuti (trailing che parte da 0 R, come nella cella viva di R270) contro stop pieni a -1,01 R. Con rischio al 2,00% per operazione (~1.500 EUR) uno stop pieno vale oltre 20 vincite tipiche. Non e' un difetto di esecuzione: e' il profilo del contratto. Con questa taglia il pavimento si raggiunge con 4-5 stop.
3. **Frequenza della `770411` molto sopra il contratto**: 3 posizioni in 7 giorni feriali (0,43/giorno) contro 14 posizioni in ~21 mesi nell'OOS (`report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md`, ~0,03/giorno): circa **14 volte** di piu'. Con 3 operazioni non e' una prova, ma e' il caso "frequenza molto sopra il promesso" del tagliando (`report/FIRME_2026-08-18.md`): le cinque ore rimappate sul server FTMO e il feed `GER40.cash` non sono la stessa cosa del backtest BCM. Va misurato.
4. Nessuna sedia Dow Apertura, Nasdaq o SuperWave ha operato in 8 giorni (ordini pendenti tutti scaduti/cancellati).

## 3. Cosa NON si puo' concludere
- Nessun verdetto sulle sedie: 11 posizioni sono un campione minuscolo (soglia della casa: 20 operazioni per famiglia).
- La sfortuna e il difetto non si separano con questi numeri.
- Che le operazioni sull'oro siano manuali e' una deduzione dall'assenza di commento, non un fatto.

## 4. Da decidere (di Claudio)
Taglia, fermo o continuazione: **decisione "A" del 30/09** (nessuna modifica). Nessuna sedia toccata.
