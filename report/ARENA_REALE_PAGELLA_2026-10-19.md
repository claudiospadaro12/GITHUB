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

## INDAGINE (19/10, sera): CHI ha chiuso le 19 posizioni e PERCHE' [da Ordini e Affari dello stesso `TH.xlsx`]
**Chi: il Guardian (`FlattenAll`), non l'Arena.** Cinque segni nel file, confrontati con le chiusure di basket dell'Arena della stessa giornata:
1. **Come chiude l'Arena** (11:40:22, 12:09:01): i basket escono tutti insieme per **stop loss comune** (commento `[sl 4173.08]`, `[sl 4165.83]`): l'Arena sposta uno stop unico per il cesto e il broker chiude. **Alle 14:46:14 NON c'e' nessun `[sl]` ne' `[tp]`**: sono ordini di mercato senza commento.
2. **Ordine delle chiusure**: dalla piu' recente alla piu' vecchia (sell 0,02 delle 14:44:59, poi 0,17 delle 14:43:39, 0,11, 0,11, 0,08, 0,08, 0,05, 0,05, 0,04, 0,04, 0,03, 0,03, 0,02, 0,02, 0,01, 0,01). E' esattamente il ciclo `for(i=PositionsTotal()-1; i>=0; i--) gTrade.PositionClose(...)` di `FlattenAll()` (`ABTG_Guardian.mq5` r.685-691: chiusura di mercato, senza commento).
3. **Pendenti cancellati nello stesso secondo**: 14:46:15 `FinlabX BUY stop` x5 e `FinlabX SELL stop` cancellati insieme (`OrderDelete` r.693-699 dopo le posizioni).
4. **Dopo, il ritmo di 1 secondo**: gli ordini che l'Arena piazza dalle 14:46:16 vivono **esattamente un secondo** e sono cancellati (prima vivevano 10-50 secondi); le posizioni da 0,01 riaperte si chiudono in circa 1 secondo: e' il timer a 1 secondo del Guardian (`EventSetTimer(1)`, r.657) che ricaccia indietro ogni ordine.
5. **Perche' proprio li'** (numeri dal file, DERIVATO): bilancio prima delle chiusure circa 4.593,7; credito 2.500; chiusure a 4.147,2-4.147,85 con -838,17 sulle 19 posizioni => equity a fine chiusura circa **6.255**. Inizio giornata 6.748,07 e limite giornaliero 4,9% x 7.500 = 367,5 => **pavimento 6.380,6**: l'equity lo aveva gia' sfondato (perdita di giornata circa 493, oltre 367,5). Il pavimento del **limite totale 15%** (7.500 x 0,85) e' 6.375: quasi identico (5,6 EUR di differenza). L'equity di chiusura (6.255) sta sotto ENTRAMBI.
**Perche' il Guardian ha scattato**: l'equity (saldo + credito + flottante) e' scesa sotto il pavimento giornaliero **per il flottante dei BUY senza stop** (15 BUY da 0,01 a 0,17, dalle 12:15), mentre il **saldo** era ancora +347 grazie alle vendite piccole in profitto. Il Guardian guarda l'equity, non il saldo.
**Cose da dire senza girarci intorno**: (a) la "pausa morbida" al 4% (perdita 300) NON ferma l'Arena: scrive una variabile che leggono solo i nostri EA, non un EA di terzi; l'Arena ha piazzato il BUY da 0,17 alle 14:43:39 quando la perdita era gia' oltre i 300 [DERIVATO]; (b) la chiusura e' avvenuta circa 1-2 secondi dopo il superamento, mentre il prezzo scendeva ancora di circa 1,5 punti: sono circa 100-130 EUR di perdita in piu' sul pavimento; (c) da quel momento il Guardian e' probabilmente in FAILED (equity 6.255 < 6.375).
**Conferma definitiva**: nel giornale Esperti del terminale reale, alle 14:46:14 server, deve esserci la riga `[GUARDIAN] !! PERDITA GIORNALIERA SFONDATA: ... CHIUSO TUTTO, BLOCCATO PER OGGI` (seguita da `!!! DD TOTALE SFONDATO` se FAILED). Non e' nel file: da leggere sul terminale.
