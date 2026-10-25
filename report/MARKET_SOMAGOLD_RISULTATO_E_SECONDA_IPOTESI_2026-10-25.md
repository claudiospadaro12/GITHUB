# SomaGold: risultato del test col set GMT e criteri della seconda ipotesi (25/10/2026)
**Natura: MISURA + CRITERI della prova successiva, questi ultimi scritti PRIMA di lanciarla.** Archivio: `backtest_pipeline/risultati_archivio/SET80K_SOMAGOLD_20261025` (zip `SET80K_SOMAGOLD.zip`, pin dello script 35b83cb3, PC di backtest, 25/10/2026 07:44).

## Risultato (VERIFICATO dai file dello zip)
- Passata valida: XAUUSD H1, 01/01-01/03/2026, ticks reali (100%), deposito 80.000 EUR, leva 1:100, 15.389.728 tick, "Test passed" in 1:48.
- **I tre valori imposti sono confermati** dal report e dal giornale: `AutoGMT=false`, `Broker_GMT_OFFSET_Summer=1`, `Broker_GMT_OFFSET_Winter=1`. Tutto il resto di default (`Risk=1`, `StartLots=0.01`, `MarginCallProtection=true`, `OnlyUp=true`, filtri NFP/IR/CPI attivi, `UseTradingTimeZones=true`, `MondayOpenHour=1:10`, `FridayClose 22:50`).
- **Operazioni: 0.** Saldo finale 80.000,00. Nessuno stop out, nessun "no money". Il giornale dell'EA scrive solo due righe (`StrategiesToRun active: 1..32`, `Loaded built-in preset. Strategies=32 | enabled=32`) e poi niente: nessun ordine tentato e nessun errore stampato. L'EA e' la **demo del Market** (`"Market\SomaGold.ex5" X64 demo version`, riga del giornale del terminale).
- **Criterio S-A (scritto il 25/10): 0 operazioni = "non opera anche col set GMT: la causa non e' il GMT".** Attesa: la mia previsione "ancora zero" era al 40%, "opera con 10 o piu" al 50%: e' uscita la meno probabile.
- Quindi: l'ipotesi GMT/AutoGMT NON spiega gli zero. Non ho trovato la causa: lo dichiaro.

## Seconda ipotesi (INFERITA dalle immagini della pagina del venditore, NON verificata)
La pagina mostra per `MarginCallProtection` tre punti: leva 1:33 -> "effective 0,11x", 1:200 -> 0,68x, 1:500 -> 1,00x. Sono compatibili con un fattore **leva/300 con tetto 1** (33/300 = 0,11; 200/300 = 0,67; 500 -> 1). Con leva 1:100 il fattore sarebbe circa **0,33**: con `StartLots=0,01` il lotto diventerebbe circa 0,003, **sotto il lotto minimo dell'oro (0,01)** e l'EA potrebbe non aprire nulla senza scrivere errori. Sono tre punti letti da screenshot: la formula e' una congettura, non una misura.

## Prova (scritta ORA, prima dei numeri)
Due passate indipendenti, stessa finestra e stesso set GMT di prima, deposito 80.000 EUR, tick reali:
- **M** - `MarginCallProtection=false`, leva 1:100 (la leva di riferimento).
- **L** - `MarginCallProtection` di default (true), **leva 1:500** (solo per diagnosi: NON e' la leva del conto di riferimento; i numeri di questa passata non servono a giudicare l'EA).
- Script `SET80K_TESTER_TRANCHE.ps1` con due parametri nuovi (`-Leva`, `-Etichetta`); cartelle `SET80K_SOMAGOLDMCP` e `SET80K_SOMAGOLDL500`; zip unico `SET80K_SOMAGOLD_2IPOTESI_<data>.zip`.

**Criteri:** una passata "OPERA" se fa **almeno 10 operazioni**; 1-9 "opera poco"; 0 "non opera". Il report deve confermare i tre valori GMT e la leva, altrimenti la passata e' KO. Si legge il lotto delle operazioni e lo si riporta come dato.

**Attese dichiarate ORA:** M opera 45%; L opera 45%; almeno una delle due opera 60%; **nessuna delle due opera 40%**. Se opera solo M, la protezione riduce il lotto a zero alla leva 1:100 e va letta come limite anche per un conto reale (la leva effettiva dei conti FTMO sull'oro: NON VERIFICATA, la deve guardare Claudio). Se opera solo L, il collo e' la leva insieme alla protezione. Se operano entrambe, il collo e' la sola protezione o la leva in modo non lineare. **Se nessuna opera: SomaGold nel nostro tester non opera, e' una demo del Market che potrebbe non lavorare nel tester (INFERITO, non verificato): non si fa una terza prova senza un fatto nuovo (per esempio una risposta del venditore), e SomaGold resta "NON MISURATO", non "scartato".**

## Cosa NON fa
Non giudica il profitto, non decide acquisti ne taglie, non cambia nessuna soglia; il test a fondo (21 mesi) di SomaGold parte solo se una passata OPERA.
