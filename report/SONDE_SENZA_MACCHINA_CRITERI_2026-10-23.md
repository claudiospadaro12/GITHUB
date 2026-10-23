# Sonde senza macchina di backtest -- criteri CONGELATI prima dei numeri (23/10/2026)
Origine: report/SALA_GIRO1_APERTURE_INDICI_2026-10-23.md, gruppo A. **Sola lettura: nessun ordine, nessun test, nessuna modifica a EA, set, sedie o conti.** Tutto cio' che segue e' scritto PRIMA di aprire un numero. Le soglie sono ARBITRARIE e dichiarate tali.

## S4 -- Dow/ORB/DAX/MaxMin nei giorni di chiusura (rilettura dei per-trade, eseguibile dal cloud)
Fonte: `backtest_pipeline/risultati_prove/trades_portafoglio/abtg_trades_*_{770206 Dow, 770612 ORB, 770115 DAX, 770413 MaxMin}.csv` (SOLO gamba OOS 2025-06-10 -> 2026-06-29; quale cella sia esattamente non e' verificato). Deal in uscita: si conta per data di chiusura.
**Elenco scritto ora, dalla mia conoscenza dei calendari, NON verificato su fonte ufficiale:**
- NYSE chiuso: 2025-06-19, 2025-07-04, 2025-09-01, 2025-11-27, 2025-12-25, 2026-01-01, 2026-01-19, 2026-02-16, 2026-04-03, 2026-05-25, 2026-06-19.
- NYSE mezza sessione: 2025-07-03, 2025-11-28, 2025-12-24.
- Xetra chiusa: 2025-12-24, 2025-12-25, 2025-12-26, 2025-12-31, 2026-01-01, 2026-04-03, 2026-04-06, 2026-05-01.
Lettura (descrittiva, nessun PF giudica nulla): per EA, numero di posizioni su giorni dell'elenco (chiusura e mezza sessione separate), loro netto, e netto/PF del resto. **Materiale** se le posizioni su giorni dell'elenco sono >= 3% del totale. Cio' non dice che l'EA sbaglia: dice solo se serve un filtro festivi per i numeri misurati.
Limite: non si sa se BCM quotasse l'indice in quei giorni; un trade in un giorno chiuso e' un fatto da spiegare, non una prova di errore.

## S1 -- fedelta' della lettura del filtro S&P del MaxMin (sonda a MQL5, da far girare su un terminale)
Strumento: script `mql5/Scripts/ABTG_SondeAperture.mq5` (SOLO LETTURA: nessuna funzione di trading; scrive CSV in Common\Files). NON compilato qui.
Cosa fa: 20 iterazioni; a ognuna crea gli handle EMA14/EMA100 su H1 di SPXUSD come `CorrBias()` (righe 396-407 del MaxMin), legge SUBITO con `CopyBuffer`, poi attende che gli handle siano pronti e rilegge, poi calcola il bias a mano dalle chiusure H1.
**Criteri:** FAIL-OPEN RIPRODUCIBILE se in almeno 1 iterazione la lettura immediata torna meno di 1 valore per uno dei due handle. CALCOLO DIVERGENTE se in almeno 1 iterazione il bias a handle pronto differisce da quello a mano con |EMA14-EMA100| > 0,05% del prezzo. Altrimenti NESSUN DIFETTO RIPRODUCIBILE: questo NON esclude il difetto dal vivo (l'EA lo chiama in un contesto diverso, con la cache di MT5 fredda).

## S2 -- la barra di fine range dell'ORB (14:45 nella cella viva)
Stessa sonda, simbolo U30USD, M1, ultimi N giorni di storia disponibile. Per ogni giorno con tutte le barre da 14:30 a 14:45: range = H/L delle barre 14:30..14:44; estensione = quanto la barra 14:45 INTERA supera H o L. **E' un limite superiore**: l'EA vede la barra 14:45 solo nei primi secondi.
**Criteri:** MATERIALE se (quota dei giorni in cui la barra 14:45 estende il range) >= 10% E (mediana dell'estensione fra quei giorni) >= 5% dell'ampiezza del range. Altrimenti NON MATERIALE.

## S3 -- il box notturno del MaxMin il lunedi' e dopo un festivo
Stessa sonda, D30EUR, replica `ComputeBox()` (righe 199-219) con `iBarShift(...,false)` + `iHighest/iLowest` come l'EA: giorno per giorno, indice e tempo della barra di inizio, numero di barre, ampiezza. **Contaminato** = la barra di inizio ha tempo < 23:00 del giorno prima (cioe' `iBarShift` ha preso una barra piu' vecchia perche' manca quella delle 23:00).
**Criteri:** MATERIALE se i box contaminati sono >= 10% dei giorni con box valido, OPPURE se la mediana dell'ampiezza dei contaminati supera di >= 20% quella degli altri. Si riportano per giorno della settimana e per giorno dopo un festivo Xetra.

## Cosa non si fa
Nessun round di backtest; nessun cambio di soglia o di ora; nessuna promozione. Se una sonda dice MATERIALE, il passo successivo e' un quesito scritto a parte.
