# Telegram UBS, topic "Usefull Tools" (27/09 - 29/10/2026, 218 messaggi): sintesi (23/11/2026)
Fonte: `USEFULL_TOOLS.zip`. Non aperti ne eseguiti: `MagicNotifier.ex5` (compilato di un utente), i file `.html` del Setfile Editor v7.3-7.8, gli zip dei set. Molti messaggi sono annunci commerciali di chi vende gli strumenti: nessun dato verificato.
## Strumenti citati
| Strumento | Chi | Cosa dice di fare | Rilevanza per noi |
|---|---|---|---|
| **Strategy Ledger** (MQL5 Market, free + Pro) | Mistermember | Dashboard sola lettura: risultati per EA (magic), PF, Sharpe, DD; analizzatore di backtest; confronto live contro backtest (ogni trade live abbinato al suo gemello di backtest), simulatore "what-if" | Idea gia nostra (`ea_analyzer`, fedelta tester/modello). Prodotto a pagamento |
| **Portfolio Lab / FX Live** (fxlive.trading) | Jonathan | Confronto tra backtest, live e segnali di terzi (Myfxbook, MQL5); calendario economico; manuale UBS online; Setfile Editor (html) con avviso dei magic duplicati | Utile per i set UBS, non per EA propri |
| **Set/Registry** (setregistry.caplysis.com) | StrathCole | Raccolta dei set UBS (con permesso di Wim) con backtest e metriche | Solo set di terzi |
| **Contatore ordini pendenti** (MQL5 Market) | Thomas | Mostra quanti ordini pendenti ci sono, per non toccare i limiti del broker | Utile come idea per i limiti delle prop (massimo 200 pendenti citato) |
| **MagicNotifier** (.ex5) | Tobias | Notifica solo certe operazioni per magic (fatto "con Claude") | Non utile; eseguibile non fidato |
| **EA che copia/inverte posizioni** | Classical Trading | Apre l'opposto di un altro EA nello stesso conto | **Non usarlo**: Wim stesso lo sconsiglia (articolo "reversing strategies"); su prop e un rischio |
| **PortQuant** (portquant.com) | link | Strumento di portafoglio | Da valutare, non verificato |
## Altro
- Wim (27/09): il topic e per strumenti utili a **UBS** (creazione, test, portafoglio), non per gli EA in generale. Wim cerca set di ottimizzazione per i mercati non-oro e annuncia (17/10) una scheda "finetuning" nella sua app.
- Un articolo MQL5 citato, "Behavioural Cloning in a Live Trading System", tratta il clonare il comportamento di un sistema con l'apprendimento: **non rientra nel nostro lavoro** (non cloniamo EA di terzi).
## Cautele
Installare `.ex5`/`.exe` di sconosciuti sul computer del reale o del test e un rischio (accesso al conto, file). Prodotti dell'MQL5 Market sono almeno verificati da MetaQuotes; i file passati nel gruppo no.
