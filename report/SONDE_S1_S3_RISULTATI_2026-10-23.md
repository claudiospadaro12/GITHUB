# Sonde S1-S3 sul PC di backtest: risultati (23/10/2026)
Eseguite con la riga `RIGA_LANCIA_SONDE_APERTURE_PC.txt` (pin f2a1b260, script SHA256 verificato). **Lo script e' stato compilato dal PC: 0 errori, 0 avvisi** (log nello zip). Solo lettura: nessun ordine. CSV archiviati in `backtest_pipeline/risultati_sonde_2026-10-23/`. Criteri congelati prima: `report/SONDE_SENZA_MACCHINA_CRITERI_2026-10-23.md`; lettore `backtest_pipeline/sonde_giudizio.py` (non modificato dopo).

## S1 -- filtro S&P del MaxMin: NESSUN DIFETTO RIPRODUCIBILE
20 iterazioni: handle creati, lettura immediata riuscita 20/20 (0 ms al pronto), bias a handle pronto uguale al bias a mano 20/20. Oggi EMA14 7645,0 < EMA100 7690,4 (distanza 0,59%): bias -1 = solo short ammessi.
**Non esclude il difetto dal vivo**: la serie H1 era gia' caricata dallo script e la cache di MT5 e' calda (criterio dichiarato prima). L'ipotesi dei revisori (fail-open all'avvio) resta INFERITA. Il filtro, in ogni caso, non scrive nulla nel log: finche' l'EA non registra il bias non si puo' controllare dal vivo.

## S2 -- barra di fine range dell'ORB (14:45): MATERIALE (limite superiore)
318 giorni completi su 318 (30/07/2025 - 22/10/2026). La barra 14:45 INTERA estende il range in **91 giorni (28,6%)**; fra questi la mediana e' l'**8,2%** dell'ampiezza del range (massimo 52,7%). Estate 64 su 214 giorni (30%), inverno 27 su 104 (26%). Per il criterio congelato (>=10% dei giorni E mediana >=5%) e' MATERIALE.
**Lettura:** l'EA vede la barra 14:45 solo nei primi secondi, quindi l'effetto reale e' PIU' PICCOLO di questo limite superiore, e i backtest e il forward ce l'hanno dentro. Quanto piu' piccolo: NON MISURATO (servono i tick). Non e' un bug dimostrato; e' il motivo per cui l'Emiliano ha `InpRangeEndExcl`.

## S3 -- box notturno del MaxMin: il criterio congelato scatta al 100%, ma e' mal posto
Formalmente: contaminati 322 su 322 giorni (100%), quindi MATERIALE. **Lo dichiaro come difetto del MIO criterio:** "contaminato = la barra di inizio e' prima delle 23:00" e' sempre vero perche' **D30EUR su BCM non ha barre fra la chiusura serale e le 00:00**. Cosi' il flag non distingue lunedi' o festivi dagli altri giorni. Cosa dicono invece i dati (DERIVATO dal CSV):
- **Ogni box include una barra della sera prima**: la barra di inizio e' le 21:54 in 298 giorni su 322 (20:59 o 21:00 il venerdi' e in 24 giorni particolari). Il box "23:00-04:59" e' in realta' **quella barra + 00:00-04:59** (mediana 301 barre).
- **Il lunedi' il box e' piu' ampio**: ampiezza mediana 116,9 punti contro 73,5-77,9 (mar, mer, ven) e 102,0 (gio). Parte dalla barra di chiusura del venerdi' (20:59/21:00) e include la riapertura di domenica sera (circa 340 barre). Non si separa quanto venga dalla barra del venerdi', dal gap o dalle ore in piu' della domenica.
- **Festivi Xetra:** 06/04/2026 (lunedi' di Pasqua) box di **7 barre**, inizio 03/04 00:59; 07/04/2026 con inizio il 05/04 23:11 (domenica).
- **Non misurato qui:** quante volte la barra della sera e' proprio quella che fissa il massimo o il minimo del box (il CSV registra solo hi/lo del box intero).

## Cosa ne segue (nessuna promozione)
1. S3 va rifatta con un criterio ben posto: per ogni giorno, hi/lo con e senza la prima barra, e giorni in cui la prima barra fissa l'estremo. Costo: modificare lo script (nuovo commit) e rilanciare la riga (1-5 minuti). Da approvare.
2. MaxMin: la finestra reale del box e' 00:00-04:59 server piu' una barra della sera; l'intestazione dice 23-04 = 00:00-05:59 CET. Il problema dell'orologio dal 26/10 resta (box e place cadono prima di Xetra).
3. S1 ha dato un esito negativo ma non assolutorio; il passo utile e' un log del bias nell'EA (variante con magic diverso).
