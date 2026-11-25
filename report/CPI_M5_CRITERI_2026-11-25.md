# CPI USA, breakout sulla candela M5 della news (EA `ABTG_CpiM5`): criteri scritti PRIMA dei numeri del tester (25/11/2026)

**Richiesta di Claudio (25/11):** studiare la candela M5 della CPI americana e farne un EA (Buy Stop + Sell Stop a T-5 min, OCO, uscita alla chiusura della M5). Scelta: **oro XAUUSD su BCM**. Eventi: 165 CPI 2013-2026 dal calendario (`mql5/Files/abtg_cpi_dates.csv`, ora server BCM).

## Fase 1 (descrittiva, gia' fatta su M1 oro FTMO, 153 eventi)
Range della candela CPI M5: mediana 6,06 USD/oz contro 0,93 di una M5 normale (6,2x; 4,6x nel 2013-19, 9,8x nel 2020-26). Il primo minuto indica la direzione della candela nell'80% dei casi. Simulazione M1 con livelli = max/min M5 precedente + 1 USD, stop sul livello opposto: media circa +2 USD/oz, ma quasi tutta nel 2020-26 (2013-19 circa 0); doppio scatto 12% (buffer 1 USD). **Limiti: M1 non vede spread reale ne' slippage dei primi secondi.**

## Test (Strategy Tester MT5 sul PC di backtest, terminale BCM principale, XAUUSD)
- **T1, tick reali:** modello "Ogni tick basato su tick reali", 2024-07-01 -> 2026-11-20 (tick BCM disponibili dal 07/2024; circa 29 CPI). Lotto 0,10, SL sul livello opposto, OCO, uscita a T+299 s. Tre set fissati ora (nessuna ottimizzazione): buffer **100 punti (1 USD) = PRIMARIO**, 50 e 200 punti.
- **T2, controllo lungo, M1 OHLC (Modello 1 minuto):** 2013-01-01 -> 2026-11-20 (165 CPI), stessi tre set. Serve come confronto con la simulazione Python e per la stabilita' per periodo; lo slippage non e' simulato.
- Si riportano: operazioni, % fill, % doppio scatto, profitto netto, PF, media e mediana per evento, slippage medio dal Journal (T1: nei tick reali non c'e' slippage simulato: la differenza richiesto/eseguito viene dai tick), risultati per periodo (T2: 2013-19, 2020-26).

## Criteri
- **Promettente per il forward demo (non il conto reale):** T1 primario con profitto netto > 0 e PF >= 1,3 su >= 25 eventi, **e** T2 primario con PF >= 1,2 sul 2020-26 e profitto > 0 nel 2013-19 o almeno non peggiore di -0,5 USD/oz per evento. Se solo il 2020-26 e' positivo: "dipende dal regime", non promettente.
- **Non candidato** se T1 primario PF < 1,0 o profitto <= 0. Un campione di circa 29 eventi non puo' dimostrare un vantaggio: anche un test promettente resta una raccomandazione di forward demo e di verifica con lo slippage reale. Nessun consiglio su lotti.
- **Regole prop:** NON verificate. Prima di usare l'EA su un conto di una prop firm vanno lette sui testi ufficiali le regole sul news trading (ordini aperti attorno alle news ad alto impatto); non le do per note.

## Previsione (scritta ora)
T1: circa 29 eventi, PF 0,9-2,0 con grande dispersione; probabilita' PF >= 1,3: 35%. T2 su M1: media circa +1 USD/oz per evento nel 2020-26 e circa 0 nel 2013-19 (come la simulazione Python); probabilita' che il 2013-19 sia positivo: 40%. Probabilita' complessiva di "promettente": 20%. Lo slippage reale dei primi secondi (non simulato) e' il rischio principale per un vantaggio di circa 2 USD/oz.
