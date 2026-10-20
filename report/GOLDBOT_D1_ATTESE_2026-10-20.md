# Goldbot One (Profalgo, v3.4): prova della configurazione del venditore, previsioni scritte PRIMA dei numeri (20/10/2026)

**Non controllata da agenti.** Claudio non trova file di set per Goldbot One ("solo questo": la pagina del Market, 3 screenshot, terminale demo 50503392, prezzo 649 USD, aggiornato 17/10/2026, v3.4). Dalla pagina:
- **Backtest sul grafico GIORNALIERO XAUUSD** (non H1: la mia ipotesi del 19/10 era SBAGLIATA).
- "Metodo di calcolo della dimensione del lotto" = **"Usa il rischio massimo per strategia"**, rischio massimo per strategia **3 (basso), 6 (medio), 10 (alto)**; "rischio massimo per strategia" = perdita massima in % quando la strategia raggiunge il suo drawdown storico massimo (2 = 2%). Alternative: lotto fisso (`StartLots`) o `LotsizeStep` (0,01 lotti ogni N di saldo).
- Modello: MT5 con "OHLC a 1 minuto" (l'EA usa internamente solo OHLC a 1 minuto); periodo minimo un anno; protezione giornaliera per prop firm; randomizzazione consigliata 50; 8 strategie (breakout dei livelli giornalieri di supporto/resistenza); AutoGMT live con URL worldtimeserver.com, offset manuali per il backtest.
## Correzione di una mia affermazione
Il giro del 19/10 su Goldbot One (continua e tranche: `PACCHETTO_ORO_LUNGO_20261019/GOLDBOTL`) era **XAUUSD H1, 5.000 EUR, `Risk=0`, `MaxRiskPerStrategy=6.0`, `LotPerBalance_step=1000`, `StartLots=0.01`**, input non imposti. **Non era la configurazione del venditore** (grafico giornaliero; metodo del lotto "rischio massimo per strategia"). Quindi la classificazione di Goldbot One fatta su quei numeri (+1.300 a lotto fisso) non vale per il prodotto come lo descrive il venditore.
## Cosa si fa
Cinque corse continue 01/01/2025-01/10/2026, XAUUSD **D1**, 80.000, leva 1:100, input imposti e verificati: T1 `Risk=0`, `MaxRiskPerStrategy=6.0` (come il vecchio giro, ma D1: separa l'effetto del timeframe); T2/T3/T4 `Risk=1` con `MaxRiskPerStrategy` 3 / 6 / 10 (basso/medio/alto); T5 come T2 ma OHLC a 1 minuto. **Non so che valore numerico di `Risk` corrisponda a "Usa il rischio massimo per strategia"**: `Risk=1` e' un'ipotesi dall'analogia con The ORB Master [NON VERIFICATO]; se T2-T4 non cambiano i lotti rispetto a T1, l'ipotesi e' falsa e si prova un altro valore.
## Previsioni dichiarate ORA
- **GB1**: tutti gli input imposti applicati in tutte le passate (`Risk=1` accettato). Fiducia 80%.
- **GB2**: i lotti crescono con `MaxRiskPerStrategy`: lotto mediano T4 > T3 > T2. Fiducia 70%.
- **GB3**: operazioni per corsa fra 150 e 600. Fiducia 65%.
- **GB4**: DD in % degli 80.000 iniziali crescente T2 < T3 < T4, con T2 <= 6%. Fiducia 55%.
- **GB5**: PF di T3 fra 0,9 e 2,0. Fiducia 60%.
- **GB6**: T5 (OHLC 1 minuto) entro +/-30% del netto di T2 e operazioni entro +/-10%. Fiducia 60%.
- **GB7**: ogni corsa dura meno di 30 minuti. Fiducia 85%.
Soglie invariate; DD sempre anche come % degli 80.000. Se una configurazione di rischio basso passa S-DD e S-NOSCALA, si calcolano S-CORR/S-PORT con Prop Firm e Gold Reaper.
