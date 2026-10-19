# Arena sul conto reale -- cosa e' successo il 19/10/2026 (da cronistorico, 161 posizioni)

Fonte: `TH.xlsx` (report Posizioni del conto reale, generato 17:14 **ora server**; ora italiana = server + 1), copia delle 161 posizioni in `data/statements/Posizioni_reale_10105439_2026-10-19.csv`. Non controllata da agenti. Solo posizioni CHIUSE: l'equity del momento e il flottante NON sono nel file [NON VISTO].

## In breve
- **Realizzato (saldo) del giorno: -502,69 EUR** (profitto -490,41, commissioni -12,28), 161 posizioni, lotto fino a 0,17.
- **Picco del realizzato: +347,26 alle 14:43:31** server. Fino a quel momento il saldo saliva (+198 fra le 11 e le 12, +46 alle 12, +58 alle 13), perche' le vendite piccole (lotto 0,01-0,02) chiudevano in profitto sul calo del prezzo.
- **Il guaio era un'altra pila**: dal 12:15 l'Arena aveva aperto **15 BUY contro il calo** (prezzo da 4.176 a 4.147) con lotti che salivano **0,01, 0,01, 0,02, 0,02, 0,03, 0,03, 0,04, 0,04, 0,05, 0,05, 0,08, 0,08, 0,11, 0,11, 0,17**, **senza stop loss** (colonna S/L vuota). Quel flottante non si vede nel saldo.
- **14:46:14-15 server (15:46 IT): 19 posizioni chiuse in due secondi** (0,69 + 0,21 = **0,90 lotti**), prezzo 4.147,16-4.147,25, **netto -838,17**. La chiusura in blocco di tutto lo stesso secondo e' la firma del `FlattenAll` del Guardian, non di un'uscita dell'EA [DERIVATO: il giornale del Guardian non e' nel file]. Con la soglia 4,9% x 7.500 = circa 367 EUR di perdita giornaliera, la chiusura e' arrivata quando l'equity ha toccato il limite; il realizzato finale (-503) e' oltre quel limite perche' le posizioni sono state chiuse mentre il prezzo scendeva ancora [DERIVATO].
- **Dopo il blocco**: 27 posizioni da 0,01 aperte e richiuse in circa **1 secondo** ciascuna (mediana), netto **-11,78 EUR** in 85 minuti: l'Arena riapre, il Guardian chiude. Ogni giro costa spread + commissione (0,2-1,3 EUR).

## Linea del tempo (ora server)
| Ora | Cosa |
|---|---|
| 09:04 | prima operazione (0,01) |
| 11:00-14:43 | molte vendite piccole in profitto; saldo realizzato sale a +347 |
| 12:15 | partono i BUY contro il calo; 12:20-14:43 lotti 0,02 -> 0,17; nessuno stop |
| 14:43:39 | BUY da 0,17 a 4.151,33; **lotti totali aperti massimi 0,89** (14:44:59) |
| 14:46:14-15 | Guardian chiude 19 posizioni, **-838,17** |
| 14:50-16:10 | 27 mini-giri da 0,01 aperti e chiusi in 1 secondo, -11,78 |

## Conti (DERIVATO)
- Prezzo: da circa 4.176 (12:15) a 4.147 (14:46): **circa 29 punti oro (29 USD per lotto-oncia = 2.900 USD per lotto)**; con 0,90 lotti il conto stava sotto di piu' di 800 EUR.
- Equity stimata a fine giornata: **6.748,07 (inizio giornata) -502,69 = circa 6.245 EUR** (saldo circa 3.745 + credito 2.500) [NON VISTO sul terminale]. Con saldo iniziale Guardian 7.500, il drawdown totale e' circa **16,7%**, oltre il limite 15%: il Guardian e' probabilmente di nuovo in **FAILED** (blocco totale, come il 16/10). Va controllato sul pannello.

## Cosa NON dice il file
- L'equity minuto per minuto e il momento esatto in cui e' scattato il Guardian (lo dicono le righe `[GUARDIAN]` del giornale Esperti, non questo report).
- Se il +300 che Claudio vedeva era il saldo (realizzato) o l'equity: il saldo era +347 al picco, ma il flottante dei BUY era gia' pesantemente negativo.
