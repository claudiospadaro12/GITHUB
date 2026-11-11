# Costi e condizioni FTMO raccolti dal sito (11/11/2026) e ricalcolo del portafoglio P1 + P3 + P4

**Fonte**: zip di Claude in Chrome (`FTMO_COSTI_dati/`, 9 file, 26 KB), sola lettura. **Qualita**: la pagina Simboli (Forex e XAUUSD) e le pagine FAQ specifiche e DXY/XAUUSD sono LETTE nel browser; Trading Update, trading objectives e mirror sono solo snippet di ricerca (NON aperti). Il sito /en/ mostra testo in italiano. Io non ho aperto le pagine: i dati sono quelli del file.

## Cosa e stato LETTO (pagina Simboli, FAQ, articolo DXY/XAUUSD)
| Dato | Valore | Stato |
|---|---|---|
| Commissione Forex | 5 USD/LOT ("or equivalent in your trading currency"); lato non dichiarato, ma la versione AU del 29/09/2025 dava $2,50 per lotto per lato => 5 USD e coerente con andata+ritorno | AMBIGUO (lato) |
| Commissione XAUUSD | 0,0014 PERCENT/VOLUME; il risultato di ricerca di ieri dava 0,0007% per lato dal 29/09/2025 => 0,0014% coerente con andata+ritorno | AMBIGUO (unita) |
| Leva XAUUSD | 1:50 Standard / 1:15 Swing, margine 2 (la FAQ dice Standard fino a 1:100 per tutti: scheda Simboli e piu specifica) | CHIARO (conferma 01/02/2026) |
| Leva Forex | 1:100 Standard / 1:30 Swing, margine 1 | CHIARO |
| Swap XAUUSD (points) | long -92,26 / short -4,2 | letto; valore del punto in USD NON dichiarato |
| Swap Forex (points) | es. EURUSD -10,27 / +0,13; GBPUSD -4,85 / -6,64; USDJPY +0,78 / -19,29; 28 coppie in `01_costi_per_simbolo.md` | letto; NZDUSD sospetto |
| Server MT5 | "GMT+2 + Ora legale" (avvisi 2026: GMT+3 in estate) | AMBIGUO |
| Orari | Forex lun-ven 00:05-23:55; XAUUSD 01:05-23:50 (GMT+2); weekend chiuso | letti (pausa oro: 75 minuti dedotti) |
| **Regola news XAUUSD e DXY** | "non e consentito aprire, modificare o chiudere posizioni sui simboli XAUUSD e DXY" da 2 minuti prima a 2 minuti dopo NFP, tasso Fed, PIL q/q, verbale FOMC, CPI; vale sui conti **funded Standard**; "Gli account Swing, la sfida FTMO e la verifica rimangono eccezioni"; violazione = possibile violazione del contratto | LETTO; ordini pendenti, modifica SL/TP e SL/TP del server NON chiari |
| Equity per il limite | Balance + P/L aperto ± swap - commissioni | solo snippet |
| Reset del limite giornaliero | mezzanotte CET (CET o CEST non chiaro) | solo snippet |

## NON TROVATO
Spread (nessun valore dichiarato), lotto min/max/passo, giorno del triplo swap e ora del rollover (ufficiali), percentuale del limite giornaliero e totale (non nelle pagine lette), limiti di ordini/richieste, EA permessi e pratiche vietate, weekend per conto Standard/Swing, Trading Update degli ultimi 18 mesi (il blog non si apre). Le 27 domande per il supporto sono in `99_DOMANDE_PER_IL_SUPPORTO.md`.

## Ricalcolo: commissioni e swap FTMO sul portafoglio (script `ORO_GRADINI_dati/ftmo_costi_calc.py`)
Metodo: per ogni posizione dei report del tester (P1 x2, P3, P4; 2013 / 2020 / 2025) commissione FTMO oro = 0,0014% del nozionale (prezzo di entrata x 100 x lotti, andata+ritorno), Forex = 5 USD per lotto; swap FTMO = punti della scheda x lotti x notti (3 il mercoledi, ipotesi da fonti terze, non FTMO; rollover assunto a mezzanotte del server dei report; il giorno e l'ora di rollover FTMO sono NON TROVATI). Valore del punto: oro 1 USD per lotto (100 oncie x 0,01, ipotesi), Forex coppie in USD 1 USD, crociate approssimate; EUR/USD medio dell'anno. Il profitto lordo e quello dei report; lo spread e quello di BCM (implicito).
| Media 2013 / 2020 / 2025 (P1 x2 + P3 + P4) | EUR/anno |
|---|---|
| Tester con costi BCM (profitto + commissioni e swap BCM) | 130.079 |
| **Con commissioni e swap FTMO al posto di quelli BCM** | **129.273** |
| di cui commissioni FTMO / BCM | -2.516 / -2.844 |
| di cui swap FTMO / BCM | -11.364 / -10.229 |
Lotti aperti per anno (somma): 1.157 / 872 / 542 (media 857). **Conclusione**: commissioni e swap FTMO letti sono quasi uguali a quelli BCM gia dentro il tester (-0,6%). L'incertezza vera e lo **spread/slippage** di FTMO, non dichiarato: sensibilita per lotto (sulla media di 857 lotti l'anno):
| Extra spread+slippage rispetto a BCM (EUR per lotto) | Netto medio annuo |
|---|---|
| 0 | 129.273 |
| 5 | 124.989 |
| 10 | 120.706 |
| **20 (equivale alla mia stima "centrale" 111.637, che era 36 sull'oro e 4 sul forex)** | 112.140 |
| 36 su tutti i lotti | 98.433 |
Quindi la stima da 111.637 EUR resta valida se spread+slippage di FTMO costano in media circa 20 EUR a lotto in piu di BCM (circa 0,2 USD per oncia di oro); con 10 EUR a lotto sale a circa 120.700. Il valore reale si misura con lo spread vero del terminale e con lo slippage dei primi giorni. Non applicati: venerdi, tick reali, profit split.

## Scoperta importante: la regola news sull'oro
Sui conti **funded Standard** gli EA su XAUUSD non possono aprire, modificare (anche trailing, break-even e SL/TP?) o chiudere nei 4 minuti attorno a NFP, tasso Fed, PIL q/q, verbale FOMC e CPI. Challenge, verifica e conti Swing sono esenti. Tutti i set del portafoglio usano l'oro (Daytrade Pro no). Da chiarire con FTMO (domande 16-18 del file 99): ordini pendenti, modifica SL/TP, SL/TP eseguito dal server nella finestra e **chiusura d'emergenza del Guardian**. Effetto sul piano: dopo il passaggio al funded Standard serve un filtro news negli EA (e nel Guardian) o il passaggio a Swing; non misurato quanto costa nel tester.
