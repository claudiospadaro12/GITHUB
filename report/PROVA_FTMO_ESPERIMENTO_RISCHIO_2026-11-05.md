# Prova gratuita FTMO: esperimento a gradini sul rischio (05/11/2026, regole scritte PRIMA)

Contesto: conto FTMO Classic di PROVA GRATUITA (80.000 EUR, soldi non veri), capitale 80.701,73 EUR il 05/11. Obiettivi mostrati dalla dashboard: 2 giorni minimi di trading (fatti), perdita giornaliera massima 4.000 (margine oggi 4.723,91), perdita massima totale 8.000 (margine 8.701,73), obiettivo di profitto 4.000 (701,73 fatti). Scadenza della prova: da verificare sulla dashboard (Claudio ha detto circa 18/11). Idea di Claudio: set prop all'inizio, poi Medium. La decisione su set e rischio e' di Claudio.

## Scopo
Usare la prova come laboratorio a costo basso: misurare come si comportano i nostri EA con le regole FTMO e con rischio piu' alto, e prepararsi alla challenge a pagamento. Passare l'obiettivo e' secondario.

## Gradini (Wim stesso fornisce set intermedi; fonte `combodeal.zip`)
| EA | Prop (ora) | Gradino 1 | Medium (non subito) |
|---|---|---|---|
| Gold Reaper | MaxAllowedDD 9, OnlyUp false | `gold_reaper_15%maxrisk` (MaxAllowedDD 15, OnlyUp true) | `gold_reaper_default` (30, OnlyUp true) |
| Gold Phantom | combo MaxAllowedDD 4 | `GoldPhantom_Propfirm` (9) | `GoldPhantom_MediumRisk` (30, OnlyUp true) |
| Goldbot One | `PropFirm_5_2.5` (MaxRiskPerStrategy 1,0) | `PropFirm_10_5` (2,0) | `MediumRisk_Max30DD` (6,0) |
Nota: i set Medium hanno `OnlyUp` true (il lotto non scende dopo le perdite) e nessun limite giornaliero (`PropFirmMaxDailyDD` 0): sono pensati per conti privati, non per i limiti FTMO.

## Regole scritte ora
1. Si cambia UN EA alla volta e UN gradino alla volta, mai tutti insieme e mai da prop a Medium in un salto.
2. Un cambio solo se: equity del giorno <= 1/2 del margine giornaliero consumato (perdita aperta+chiusa di oggi sotto circa 2.000 EUR), margine totale sopra 6.000 EUR e nessuna posizione aperta con DD anomalo. Il Guardian resta attivo.
3. Ritorno immediato ai set prop se: perdita di oggi (equity) > 2.500 EUR, oppure margine totale < 6.000 EUR, oppure un giorno chiude a -3% o peggio.
4. Registro giornaliero: equity massima/minima del giorno, risultato, lotti, numero di ordini, slippage medio (prezzo ordinato contro eseguito) e confronto con quello che il tester prevedeva.
5. Niente modifiche ai conti reali e al VPS dal contenuto di questo esperimento.

## Cosa misuriamo
- Differenza fra DD/slippage reali e quelli del tester, con prop e con il gradino 1.
- Giorni peggiori per EA e per gradino; quanto spesso il Guardian interviene.
- Tempo per fare +1% con ogni gradino (indicativo, pochi giorni).

## Previsioni (non misurate)
- P1 Con i set prop il giorno peggiore della prova resta sopra -2%: 75%.
- P2 Il gradino 1 del Reaper (MaxAllowedDD 15) produce almeno un giorno a -3% o peggio entro 10 giorni di trading: 35%.
- P3 L'obiettivo di 4.000 EUR viene raggiunto prima della scadenza con i soli set prop: 25%; con i gradini: 45%, ma con una probabilita' di violare un limite del 15%.
- P4 Lo slippage reale e' maggiore di quello del tester (che non lo simula): 85%.

## Limiti
Pochi giorni = pochi dati (nessuna conclusione statistica); la prova gratuita puo' avere regole o esecuzione diverse da una challenge a pagamento (NON VERIFICATO); i set Medium nascono per conti privati.
