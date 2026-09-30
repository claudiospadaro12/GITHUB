# FTMO 2-Step 541452707 - CHIUSURA (30/09/2026)

**Esito**: Max Loss violato il 30/09/2026 alle 13:26:29 CE(S)T. Conto in sola lettura per 5 giorni (circa fino al 05/10), poi disattivato.
Fonti: email FTMO del 30/09, pagina Metrix (screenshot di Claudio 20:49), storico mobile, `data/statements/FTMO_541452707_cronistorico_2026-09-30.xlsx`.
Immagini in `data/statements/FTMO_541452707_chiusura_2026-09-30/`.

## 1. I numeri (con la fonte)
| Voce | Valore | Fonte |
|---|---|---|
| Capitale iniziale | 80.000 EUR | FTMO |
| Saldo a mezzanotte del 30/09 | 74.532,92 | email FTMO |
| Saldo / equity alla violazione | 72.066,80 / 71.968,19 | email FTMO |
| Saldo finale | 71.935,73 | Metrix |
| Perdita massima | -8.064,27 (-10%) contro limite -8.000: FALLITA | Metrix |
| Perdita giornaliera del 30/09 | -2.597,19 (-3,2%) contro limite -4.000: NON violata | Metrix |
| Giorni di trading | 6 (minimo 4: ok) | Metrix |
| Statistiche piattaforma | 18 trade, win rate 50%, PF 0,22, expectancy -448,02, lotti 188,02 | Metrix |
| Giornate | 30/09 -2.597,19; 29/09 +1.063,70; 28/09 -1.621,50; 25/09 -1.552,80; 24/09 -1.598,80 | Metrix |

La regola di FTMO e' sull'EQUITY (linea 72.000): sfondata di 31,81 EUR all'istante della violazione, con il terzo trade manuale sull'oro aperto.

## 2. Attribuzione (mio conto dal cronistorico, per posizione, netto commissioni)
- **Flotta** (DAX, Dow): 11 posizioni, 6 vinte (+2.013,92), 5 perse (-6.514,85), netto **-4.500,93**, PF **0,31**, somma -3,25 R.
- **Manuale oro fino alle 10:03 del 30/09**: 2 posizioni, netto -2.502,06 (PF 0,11).
- **Manuale oro del 30/09 pomeriggio**: 3 trade, -999,43 lordi, -1.061,28 con le commissioni di giornata.
- Quadratura: 80.000 - 4.500,93 - 2.502,06 = 72.997,01 (saldo dopo lo stop GER40 di stamattina); 72.997,01 - 1.061,28 = 71.935,73 = saldo finale Metrix.
- Margine verso la linea 72.000 prima dei tre trade manuali: **997,01 EUR**, contro uno stop pieno di circa 1.450-1.550.

## 3. Cosa si puo' dire e cosa NO
- SI: senza i trade manuali sull'oro la linea non era stata sfondata quel giorno. Con 997 EUR di margine e stop da circa 1.500, una sola giornata storta della flotta l'avrebbe sfondata comunque.
- SI: il PF della sola flotta e' 0,31 su 11 posizioni (un solo regime, payoff asimmetrico: vincite +0,03..+0,06 R, stop -1,01 R).
- NO: "gli EA sono rotti". Il campione non basta per dirlo, e la compatibilita' statistica con il backtest del DAX e' gia' misurata (probabilita' di andare cosi' male o peggio in 5 posizioni circa 21%). Cinque stop pieni su 11 (45%) sono piu' del previsto (backtest circa 26%): e' il motivo per cui la riproduzione nel tester e' la misura giusta.
- NO: "la challenge e' il verdetto sulle sedie". Nessuna sedia e' archiviata come MORTA: nessuna ha il certificato di morte (PF, n, DD, uscita ad asse, gemelli, TF). Stato di tutte: **NON ANCORA MISURATO**.
- NON SO: perche' Metrix conta 18 trade (probabile: gambe parziali contate a parte). Lo chiude lo storico completo.

## 4. Cosa resta da fare (non decisioni mie)
1. **Riproduzione nel tester** (riga pronta, PASS del cancello: `backtest_pipeline/righe/RIGA_LANCIA_RFWD.txt`, poi `RIGA_ROUND_RFWD.txt` SHA 919C2D73...): da lanciare sul PC di backtest DESKTOP-H4D7CAJ. Risponde a: gli EA fanno nel tester le stesse operazioni del forward?
2. **Esportare lo storico completo finale** da FTMO (xlsx/CSV) e gli ordini pendenti cancellati **entro circa il 05/10**: poi l'accesso si spegne.
3. **Seconda challenge**: scelta e spesa di Claudio. FTMO offre una Free Trial gratuita con lo stesso ambiente: possibile forward senza spese, decisione sua. La taglia resta sua; il dato utile e' il margine: 997 EUR di distanza dal muro con stop da 1.500 era troppo stretto.
4. Il vincolo "i round non girano sul VPS finche' una challenge e' viva" **decade** con la chiusura; il banco 50504400 resta spento finche' Claudio non dice altro.
5. Terminale FTMO sul VPS (C:\FTMO): sedie attaccate su un conto in sola lettura (non operano). Non spegnere in fretta; decisione di Claudio.

## 5. Lezioni (scritte come fatti, non come colpe)
- Il muro e' sull'equity: un trade aperto conta prima che chiuda.
- Il margine si misura in STOP PIENI, non in euro: 997 / 1.500 = 0,66 stop. La flotta ne ha fatti 5 su 11 in 6 giorni.
- I trade manuali sullo stesso conto della flotta non passano dal Guardian (il Guardian ferma solo gli ingressi degli EA) e non rispettano il cap di rischio.
- Il conteggio di FTMO include tutto: il PF della piattaforma (0,22) non e' il PF della flotta (0,31 su 11 posizioni).
