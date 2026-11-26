# ABTG_FvgRetest v1.00 (A3) - sorgente 1495 righe
Tutti i riferimenti sono righe di `ABTG_FvgRetest.mq5`. Nel sorgente nessuna istruzione rivolta a un revisore (grep fatto). Include esterno `ABTG_PausaGuardian.mqh` (105) NON fornito: DA_VERIFICARE.

## Regole (FATTO_VERIFICATO)
- FVG su 3 barre chiuse contigue nel tempo (i-2, i-1, i): low[i] > high[i-2] (rialzista) o specchio (296-307, 697-713); contiguita' = esattamente 2 barre del TF (317-321, 702).
- Taglia: gap >= 10% del MASSIMO dei gap visti nelle ultime 1000 barre (zeri inclusi), chiamato "percentile" (163-164, 666-685).
- Ingresso default RITORNO: eta' >= 1 barra, mitigazione 5-100% dell'altezza, candela di conferma (chiude in direzione e oltre il bordo lontano) (170-175, 795-833). Una posizione, max 3/giorno, 1 gap = 1 ingresso (830, 594-595).
- Ordine a mercato all'apertura della barra dopo il segnale (961); SL 1,5 ATR, TP 3 ATR, pavimento SL 0,5 ATR (188-194, 925-927); gestione (parziale/BE/trailing) tutta spenta di default (197-203, 998). Filtro regime EMA/ADX spento (178).

## Difetti
- [falsa i test, media] Spread: filtro presente ma `InpMaxSpread=0` (232, 1204-1208); ingresso all'apertura di barra, dove lo spread degli indici e' piu' largo. Sui dati `_EXT` spread=0 (CLAUDE.md): PF gonfiato senza costo fisso imposto dal tester.
- [falsa i test, minore] Header 91 e commento 874 dicono "server un'ora indietro": falso in inverno (CLAUDE.md). Colpisce solo i filtri orari (207-213, 875-880), `InpNoOvernightHour=21` (211, 1085-1088), `InpFridayCloseHour=20` (213): tutti spenti di default, in ora server senza ora legale.
- [minore] "Percentile" = massimo di 1000 campioni: un solo spike di notizia alza la soglia per ~10 giorni (666-673, 684). E' una definizione, non un errore, ma rende il numero di segnali dipendente dagli outlier.
- [minore] I gap non scadono mai per eta' (solo mitigazione 100%, uso o tetto 50: 719, 756, 762-772): un ritorno puo' arrivare giorni dopo, oltre un weekend.
- [minore] `SetDeviationInPoints(30)` (432): su indici con _Point 0,01 sono 0,3 punti indice, rischio di rifiuti live (INFERENZA, nel tester irrilevante). Rifiuto ordine: solo log (976), il gap resta riutilizzabile (830).
- [minore] Freeze level non controllato; stops level si (934-936).

## R2 (SI/NO)
Barra in formazione per decidere: NO (tutto su shift 1-3; EMA/ADX shift 1: 854-866). Orari senza ora legale: SI (opt-in). Distanze fisse in punti: solo opzionali + deviazione 30. Nuova barra: SI (552-557). Stop minimo: SI. Spread nel filtro: SI ma spento. Rifiuto ordine: log. Magic 775501, commento "FVGRET L/S" (230-231, 953). Dati futuri: NO.

## Misurabilita'
Solo OHLC a barre chiuse: va bene con M1 OHLC. Mercati: D30EUR/U30USD/NASUSD M15; nativi BCM solo 2024-26; `_EXT` NASUSD/SPXUSD 2010-26 (spread 0, tickvol 1 irrilevante per questa EA, orologio irregolare irrilevante finche' i filtri orari restano spenti). Dow/DAX prima del 2024 assenti. Non fidarsi del conteggio segnali finche' non si e' letta la riga "finestra riempita" (651) e il numero di gap per anno.

## Ipotesi (criteri scritti prima; cancelli campagna: IS PF >= 1,30, OOS PF >= 1,20, UBS_CAMPAGNA_OTTIMIZZAZIONE_CRITERI par. selezione)
1. Baseline RITORNO nudo su NASUSD_EXT M15, IS 2010-2019, OOS 2020-23, hold-out 2024, costo fisso per giro = spread medio nativo 2024-26 (da misurare prima). Passa se IS PF >= 1,30, OOS >= 1,20, >= 150 trade IS, >= 60% anni positivi. Probabilita 8%.
2. Ablazione FORMAZIONE vs RITORNO (stessa cella): il "ritorno" aggiunge valore se PF(RITORNO) - PF(FORMAZIONE) >= 0,15 in IS e OOS. Probabilita 25%.
3. Eta' massima del gap (es. 16 barre): passa se PF IS +0,10 e >= 70% delle varianti vicine con PF > 1 (V2). Probabilita 15%.

## Classe: A (misurare subito)
Nessun difetto cambia la logica d'ingresso; condizioni: costo fisso nel tester, include Guardian fail-open (113), una sola definizione per round.
