# The Impossible Gold 2.1 (TIG) nel nostro Strategy Tester -- SONDA 1, il gemello del 14/10 (scheda scritta il 15/10/2026, PRIMA dei numeri)

Chi e': `report/MARKET_SCHEDA_THE_IMPOSSIBLE_GOLD_2026-10-15.md` (XAUUSD M5, magic 778899, SL 25 pips, TP 300, rischio 1,5% con compounding, trailing e TP esteso, protezioni proprie spente). Caricato da Claudio sul demo piccolo il 13-14/10; il 14/10 ha aperto TRE trade (2 LOW SELL stoppati, 1 HIGH BUY aperto la mattina del 15/10 con flottante +1.510).

## Cosa si misura
Una passata sul **solo 14/10/2026**, XAUUSD M5, ticks reali, deposito 5.000 EUR, leva 1:100 (quella che il tester stampa), nessun input imposto (i NOMI delle variabili non si conoscono; il report dice quali valori ha usato il tester). Script `backtest_pipeline/righe/TIG_TESTER_SONDA.ps1` (derivato dallo script delle tranche Arena v2, stesse guardie), riga `backtest_pipeline/righe/RIGA_LANCIA_TIG_TESTER_SONDA.txt`, lettore `backtest_pipeline/leggi_tig_sonda.py`.

## Attese (scritte prima, con la smentita)
- **A.** L'EA opera nel tester sul 14/10: >= 1 operazione. *Smentita:* zero (misura mancante: licenza del Market, rifiuto del tester o filtro).
- **B. Gemello:** almeno 2 dei 3 trade del demo (stesso lato, apertura entro 10 minuti, prezzo entro 1,0 USD) compaiono nel tester. *Smentita:* 0 o 1. Si giudica solo a giro CONFORME e con le 12 ancore (C) trovate.
- **C. Valori usati = valori del demo:** le 12 ancore (magic 778899, TP 300, SL 25, rischio 1,5, lookback 16, buffer 1,5, range minimo 5, sessione 10-20, esclusione fine 15, passo TP 14, trailing 2) compaiono fra i valori del report. *Smentita:* ne manca una: i default non sono quelli del demo e la sonda 2 impone gli input coi nomi letti.
- Il **SL/TP** di ogni trade del tester si stampa: il SL deve essere ~25 pips (2,5 USD) e il TP ~300 pips (30 USD) all'apertura; il trailing e l'estensione del TP si vedono nei trade che durano.

## Cosa NON si potra' concludere
Un giorno, un regime; tester senza slippage ne' latenza; nessun merito; se il prodotto non gira nel tester (licenza del Market), e' una misura mancante, non un'archiviazione.

## Quando e cosa deve fare Claudio
- **Non prima che finiscano le tre tranche dell'Arena** sul PC di backtest (un solo giro alla volta: blocco comune).
- Sul **PC di backtest** (terminale `C:\Program Files\BCM Markets MT5 Terminal`, conto demo 50503392): **installare The Impossible Gold dal Market** (scheda Market -> cerca il prodotto -> Installa), **non attaccarlo a nessun grafico**, chiudere MT5. Poi la riga.
- Se il tester mostra input diversi dalla finestra del demo, **la sonda 2** (tre mesi, input imposti coi nomi) e' un lavoro in piu' di tempo macchina: decide Claudio.
