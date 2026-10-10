# Trial FTMO 1514806751 - storico completo 01/10-09/10/2026 (export di Claudio, 10/10 09:11)

Fonte: ReportHistory-1514806751.xlsx (conto 160k EUR, FTMO-Demo, Hedge). Letto con openpyxl, copia in scratchpad.
Etichette per EA = commento dell'ordine di apertura (tutte le 39 posizioni abbinate, nessuna "?").

## Quadro [MISURATO sul file]
- Netto -11.176,84 EUR (somma degli affari = riga "Profitto Totale Netto", riconciliata), bilancio 148.823,16, equity 149.837,10 (4 posizioni aperte, +1.218,42 fluttuante).
- 39 operazioni chiuse, 25 vinte (64,1%), PF 0,42, media vinta +325,55, media persa -1.379,68.
- Bilancio a fine giornata: 01/10 154.184 | 02/10 151.188 | 05/10 148.123 | 06/10 145.084 | 08/10 147.317 | 09/10 148.823.
- Peggior giorno (a chiuso): 01/10 = -5.816 (-3,6% di 160k). Limite giornaliero 5% = 8.000.
- Minimo del bilancio a chiuso: 145.054,66 (08/10 11:00:04) = 1.055 EUR sopra 144.000 (10% di 160k). Drawdown massimo bilancio del file: 14.945,34 (9,34%).
- [NON MISURATO] equity intraday: il file non la contiene, quindi il margine reale dal limite del 10% puo' essere minore.

## Per EA (netto a chiuso, commissioni incluse)
| EA (commento) | n | vinte | netto |
|---|---|---|---|
| DAX Apertura EU RETEST SELL | 3 | 1 | -6.059,66 |
| MAXMIN DAX SHORT SELL | 1 | 0 | -3.292,52 |
| BULGE VIOLA_VIOLA_L | 17 | 12 | -1.538,84 |
| BULGE_V520_FT_VIOLA_L | 1 | 0 | -1.389,09 |
| ORB OTT FT BUY | 3 | 1 | -914,57 |
| BULGE VIOLA_VIOLA_S | 9 | 6 | -876,79 |
| SUPERWAVE DOW H1 L (1/3 + 2/3) | 2 | 2 | +998,57 |
| BULGE_V520_FT_VIOLA_S | 1 | 1 | +423,79 |
| BULGE_VIOLA_L | 1 | 1 | +561,79 |
| BULGE_VIOLA_S | 1 | 1 | +990,87 |

## Letture
- **DAX (GER40.cash) = -9.352 su 4 operazioni**: 3 stop pieni da circa 2% (3.292 / 3.110 / 3.050) + una vincita da +101.
  Il 01/10 due sedie SHORT sullo stesso indice sono state fermate nello stesso giorno (-6.403). Gia' trattato in `AUDIT_RISCHIO_FLOTTA_2026-10-01.md`: qui e' solo il conto aggiornato.
- Senza i tre stop DAX il conto sarebbe a circa -1.800: il resto della flotta e' vicino al pareggio (28 Bulge: netto negativo ma piccolo rispetto al DAX).
- Il report settimanale del 10/10 chiama questo conto "SCONOSCIUTO" e aveva statement tronchi al 06/10: questo export li sostituisce.
- Campione: 8 giorni, 39 trade, 4 stop DAX: pochi per giudicare il MERITO di qualunque sedia (regola R59). Il RISCHIO invece e' un fatto accaduto: 3 stop pieni da 2% in 5 giorni.
- Nessun criterio cambiato da questo file; nessuna sedia spenta; decisioni di taglia/rischio restano di Claudio.
