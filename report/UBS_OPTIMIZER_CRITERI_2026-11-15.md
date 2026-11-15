# UBS Optimizer: come lo usiamo (15/11/2026, criteri e previsioni scritti PRIMA dei numeri)

**Natura: PIANO.** Nessuna app lanciata, nessun numero. Solo PC di backtest; reale, FTMO e VPS non si toccano; nessun giudizio su lotti, taglie o acquisti. Fonte sull'app: `UBS_OPTIMIZER_VIDEO_2026-11-14.md` (video di Wim, sottotitoli automatici: i numeri vanno ricontrollati; l'app e di Claudio, versione e funzioni vere NON ancora viste da me).

## 1. A cosa serve per noi
- **Obiettivo di Claudio:** meno rischio di fallire la challenge, massimo 4 EA non oro, portafoglio separato dall'oro.
- **Vantaggio possibile:** set creati da noi sono diversi da quelli che hanno migliaia di clienti di Wim (tetto 400.000 $ per strategia, domanda ancora in attesa di FTMO). Non e garantito che FTMO li consideri diversi.
- **Rischio principale:** l'ottimizzazione adatta i parametri al passato (sovra-adattamento). Wim stesso dice che le soglie dell'app "vanno ancora calibrate" e che i criteri iniziali "potrebbero non essere finali".

## 2. Regole fisse (valgono per qualunque uso dell'app)
1. **Un MT5 PORTABLE separato**, mai quello dei test (`C:\Program Files\BCM Markets MT5 Terminal`), mai FTMO, mai il reale 10105439, mai il VPS. Cartella proposta: `C:\MT5_BCM_Opt`. Una cartella portable non crea cartelle dati in `AppData`, quindi non ripete il blocco del censimento.
2. **Conto:** solo il demo BCM 50503392 (la licenza di Wim funziona li). L'app usa login e password dell'MT5: la password non va mai scritta in chat.
3. **UN SOLO GIRO ALLA VOLTA:** le mie righe del tester vogliono tutti gli MT5 chiusi e nessun agente del tester aperto. L'app, con i suoi "little helpers", usa piu istanze MT5 insieme: mai insieme alle mie righe.
4. **MQL5 Cloud Network (a pagamento): NO.** Agenti locali sul PC di backtest.
5. **Tre pezzi di dati separati**, scritti prima:
   - **Dentro campione (IS):** 2013-01-01 -> 2019-01-01.
   - **Fuori campione (OOS):** 2019-01-01 -> 2025-01-01, scelto dall'app/da noi per lo stress test.
   - **Hold-out finale 2025 (mai dato all'app):** 2025-01-01 -> 2026-01-01. Si guarda UNA volta, solo per i candidati finali, a tick reali. Se l'hold-out viene usato per cambiare qualcosa, non e piu un hold-out.
6. **Si registra tutto:** numero di passaggi dell'ottimizzazione, quanti idonei, quanti scelti, quanti PASS/CAUTION/FAIL a ogni stress test. Il numero di combinazioni provate va nel referto.
7. **Il lotto dei candidati non si sceglie dopo aver visto i risultati:** stesso rischio per ognuno (regola del piano combinazioni).

## 3. Primo uso: un solo pilota, piccolo
- **Un simbolo, un timeframe, una famiglia d'ingresso:** proposta EURUSD H1 (il simbolo con piu dati e il timeframe degli scalper che passano), algoritmo genetico, lotto fisso 0,1, deposito 100.000 EUR, Modello 1 per l'ottimizzazione, tick reali solo per lo stress test (come nel video).
- **Durata attesa:** il video dice circa 4 ore per una ottimizzazione vera (NON misurato sul nostro PC, che e un i7 portatile da 15 W). Una ottimizzazione alla volta.
- **Criteri di scelta dei candidati:** quelli di default dell'app (PF >= 1, recovery factor >= 1, operazioni/anno >= 7,7) ma con i NOSTRI filtri sopra: operazioni >= 150 nel dentro campione, PF >= 1,20 dentro e fuori campione.
- **Stress test:** i tre dell'app (fuori campione; tick reali contro M1; perturbazione). Soglie di Wim lette da un fotogramma a bassa risoluzione, da ricontrollare sull'app vera: PF tick/M1 >= 0,7, DD tick <= 1,5 x M1, operazioni +-10%, win rate +-10 punti; perturbazione: >= 70% delle varianti in profitto.
- **Stop:** se dopo lo stress test non resta nessun candidato PASS, si scrive "nessun candidato" e non si cambiano i criteri per ottenerne uno.

## 4. Previsioni (scritte ora)
- **OPT-1** L'app si installa e parte sul MT5 portable con il demo 50503392 al primo tentativo, senza toccare altri terminali: 70%.
- **OPT-2** Una ottimizzazione EURUSD H1 completa in meno di 8 ore sul nostro PC: 60% (il video ne dichiara circa 4 su un altro computer).
- **OPT-3** Dopo i filtri nostri (>= 150 operazioni IS, PF >= 1,20 IS e OOS) restano almeno 5 candidati: 55%; zero: 25%.
- **OPT-4** Almeno 1 candidato con PASS in tutti e tre gli stress test dell'app: 45%.
- **OPT-5** Sui candidati PASS, l'hold-out 2025 a tick reali mantiene PF >= 1,20 per almeno meta di loro: 35% (sovra-adattamento tipico: i risultati fuori dal periodo di scelta calano).
- **OPT-6** Un candidato ottimizzato da noi batte, nell'hold-out 2025 a tick reali, il miglior set di Wim a lotto uguale (stesso simbolo): 25%.
- **OPT-7** Il DD del portafoglio "smoothest" costruito dall'app sul periodo IS e superato (in % o in euro) nell'hold-out o fuori periodo: 70% (nostra misura sull'oro: DD fuori periodo circa il doppio).

## 5. Cosa NON sappiamo
Versione dell'app che Claudio ha comprato; come si installa e dove e il programma; se richiede una licenza o un account online; se accetta l'EA UBS V9.5 che usiamo (EA del Market) o ne richiede un altro; come calcola "smoothest"; se i tick reali BCM per il forex coprono 2013-2025; costo/tempo reale sul nostro PC.

## 6. Prima di tutto, nell'ordine
1. Finire la corsa a tick reali in corso (UBSCFT, 14 passate) e leggere i risultati.
2. Installare l'app sul MT5 portable `C:\MT5_BCM_Opt` (Claudio; io non ho l'app).
3. Controllo di sola lettura che non ci siano altri MT5 aperti prima di ogni uso.
4. Un'ottimizzazione pilota EURUSD H1 con i criteri sopra.
