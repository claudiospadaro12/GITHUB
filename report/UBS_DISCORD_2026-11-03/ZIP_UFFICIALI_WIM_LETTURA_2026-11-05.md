# Zip ufficiali di Wim caricati da Claudio il 05/11/2026 (combodeal, Set_Files_All_EAs, AllSetsAndManuals, Gold_Bundle)

Aperti in sola lettura (nessun eseguibile dentro: solo `.set`, `.pdf`, `.txt`, `.png`, `.html`, e uno zip interno). Scansione Defender fatta da Claudio prima del caricamento (dichiarato da lui).

## Contenuto
- `combodeal.zip` (114 set): una cartella per EA (Reaper, Phantom, Goldbot One, Goldtrade Pro, Daytrade Pro, Luna, Stability Pro, Bitcoin Reaper, Bitcoin Scalp Pro, Indicement, ORB Master), `recommended combo setup` (3GOLD/4GOLD per i conti privati; sottocartelle `prop firms` con anche `Kortana FX`, `Darwinex`, `For +5K account you can add these`) e `my MEX live combo deal setup` (set live di Wim). **Non c'e' Apex.** `read_me!`: "when running 2 or 3 gold EAs together, use the 3GOLD versions; when running 4 gold EAs together, use the 4GOLD versions". `how to use`: le cartelle per EA sono per girare l'EA "individually"; per piu' EA insieme usare `recommended combo setup`.
- `AllSetsAndManuals.zip` (28/08): 124 set, 13 manuali PDF (Apex, Bitcoin Reaper, Bitcoin Scalp Pro, Daytrade Pro, General Quick Setup Guide, Gold Phantom, Gold Reaper, Goldbot One, Goldtrade Pro, Indicement, Luna AI, ORB Master, Stability Pro) e la cartella `My live portfolio accounts sets` (PortA High Risk ICM, PortB Tickmill, PortC MEX, PortD ICMarkets Multi Growth, PortE Live signal) con i readMe.
- `Set_Files_All_EAs.zip` (29/03): 122 set + 9 txt. Versione piu' vecchia degli stessi.
- `Gold_Bundle.zip`: un solo report del tester in HTML da 214 MB + 4 immagini: **UBS V6.4, XAUUSD H1, 2020.01.01-2026, ICMarketsSC-MT5-2 (Raw), tick reali (9,3 milioni di tick, qualita 99%), deposito 5.000 USD, leva 1:500, "1% RiskPerStrategy"**: netto +109.836 USD (lordo +201.508, perdite -91.673), PF 2,20, fattore di recupero 20,5, Sharpe 4,21, 21.066 operazioni (62% vincenti), **DD equity massimo 5.348 USD (4,65%), relativo 10,4%**, livello di margine minimo 4.118%. E' un backtest dichiarato da Wim, composto (il rischio per strategia e' in % del saldo), non un risultato dal vivo, su dati e broker suoi.

## Set combo di Wim contro i set sul conto reale di Claudio (3.745 EUR) e sul FTMO di prova
| EA | Wim prop 3GOLD | Wim prop 4GOLD | Nostro (`set_reale_3745`, `set_ftmo_trial`) |
|---|---|---|---|
| Gold Reaper | MaxAllowedDD 3, TradeFrequency 2, daily 4, Randomization 50 | MaxAllowedDD 2 (resto uguale) | MaxAllowedDD **9**, daily 4, Randomization **0** |
| Gold Phantom | MaxAllowedDD 4, daily 4, Randomization 50 | MaxAllowedDD 2,5 | MaxAllowedDD 4, daily 4, Randomization 0 |
| Goldbot One | MaxRiskPerStrategy 0,8, daily 4, FakeOut 1 | 0,5 | MaxRiskPerStrategy **1,0**, daily 2, FakeOut 1 |
| Goldtrade Pro | MaxRiskPerStrategy 0,3, OnlyUp 1 | 0,2 | (non nel set reale) |
- Wim dice (aprile) 3 EA a 1/3 del rischio, 4 a 1/4. Il nostro Reaper e' a **3 volte** il valore che Wim da' per il combo a 3, il Goldbot a 1,25 volte; il Phantom e' uguale. **Attenzione:** a 3.745 EUR la maggior parte dei lotti e' gia' 0,01 (nei test del 31/10 il Reaper D9: 955 operazioni a 0,01 e 14 a 0,02), quindi abbassare il MaxAllowedDD non cambierebbe il lotto: il rischio e' fissato dal lotto minimo. Da misurare, non da assumere.
- I set prop di Wim mettono `Randomization` 50 sul Reaper e sul Phantom; i nostri 0 (test del 29/10 su Randomization 50: vedi `REAPER_SET_LIVE_E_RANDOMIZATION_*`).

## Apex (manuale PDF, versione 1.1 del manuale)
- Griglia su AUDCAD, AUDNZD, NZDCAD (M15, OneChartSetup su EURUSD M15). Capitale minimo 1.000 USD (Conservative), "2.000+ strongly recommended". Consigli per taglia (USD): < 2.000 = Conservative con LotsizeStep 2000 o piu'; **2.000-4.000 = Conservative con LotsizeStep 3000 o piu'**; 4.000-15.000 = Elevated con LotsizeStep 5000 o piu'; 15.000+ = Optimal con 15.000 o piu'.
- Kill-switch "Max Allowed DD in currency (per 0.01 lotti)": Conservative 1.200 (1.100 per conti in EUR), Elevated 1.900 (1.700), Optimal 7.400 (7.000). Raccomandato IC Markets. Il manuale dice che l'EA "never risks blowing the account": **Wim stesso dice che su 100 dollari e' saltato e che le griglie "finiscono male"**.
- I set Apex non sono in questi zip (non c'e' una cartella Apex): restano quelli del pacchetto gia' testato.
