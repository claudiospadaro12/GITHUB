# Test con il filtro NFP SPENTO: CRITERI e PREVISIONI (11/11/2026, scritti PRIMA dei numeri)

**Natura: CRITERI, non ancora lanciato.** Nasce dalla nota di Massimo (`Filtri_news_Swing_per_Claudio.pdf`) e dalla verifica sui report (`PORTAFOGLIO_SCELTO_2026-11-11.md`, sezione "Filtro NFP"): negli EA di Wim `EnableNFP_Filter=true`, con `NFP_CloseOpenTrades=true` e `NFP_ClosePendingOrders=true` (chiudono posizioni e pendenti attorno all'NFP), e nei backtest 2013 e 2020 alcune posizioni attraversano comunque il rilascio. Solo tester; reale, trial FTMO e VPS non si toccano; nessun lotto ne taglia. Non e una regola FTMO: e un settaggio nostro.

## Domanda
Spegnendo il filtro NFP (`EnableNFP_Filter=false`, unico input cambiato) **a che costo o guadagno** sul netto, sul DD e sul peggior giorno? Quante operazioni in piu? Le posizioni attraversano l'NFP (verifica che il filtro sia davvero spento)? Serve a decidere se, su un conto Swing (nessuna regola FTMO sulle news), ha senso toglierlo.

## Cosa si testa
Le stesse passate del D160 (160.000 EUR, XAUUSD, BCM, Modello 1, set ufficiali da combodeal.zip, 2013 / 2020 / 2025), riferimento = le passate D160 gia fatte con il filtro acceso (`RISULTATI_D160_ORO_2026-11-09.md`, `D160_dati/d160_celle.json`, `d160_gtp.json`).
| EA, livello | Passate per anno | Righe |
|---|---|---|
| Goldbot One Prop (L0) | 1 | oro |
| Goldbot One Combo 3GOLD (L3) | 1 | oro |
| Phantom Gradino 1 (L1, Randomization 50) | 2 | oro |
| Reaper Combo 3GOLD (L3, Randomization 50) | 2 | oro |
| Gold Trade Pro Combo (Risk 3, MaxRisk 0,5, DD giorno 4,0) | 1 | GTP |
**21 passate**: 18 nella riga oro (`RIGA_LANCIA_NFPOFF_ORO`), 3 nella riga GTP (`RIGA_LANCIA_NFPOFF_GTP`). Daytrade Pro non ha input NFP: escluso.
**Validita**: report presente, deposito 160.000, `EnableNFP_Filter=false` confermato dal report, altri input uguali al set, qualita >= 98%, almeno 1 operazione, nessun stop out.

## Misure
Per EA e anno: netto, PF, DD equity relativa, operazioni, peggior giorno realizzato, e **posizioni aperte attraverso il rilascio NFP** (date NFP dell'anno, ora server BCM GMT+1 fisso: 14:30 inverno, 13:30 estate) e **operazioni entro 2 ore dal rilascio**, confrontate con il riferimento a filtro acceso.

## Regole di lettura (fissate ora)
- **FILTRO SPENTO DAVVERO**: nel 2025 almeno una posizione attraversa l'NFP in ciascun EA (con il filtro acceso erano 0); altrimenti la passata non dimostra l'effetto.
- **COSTO per EA** (somma dei 3 anni; per Phantom e Reaper media delle 2 ripetizioni contro la media delle 2 di riferimento, banda = il doppio dello scarto fra le due ripetizioni del riferimento, minimo 10%): **NEUTRO** se il netto cambia entro +-10% (o la banda), il DD non sale oltre 1 punto e il peggior giorno non peggiora oltre 0,5 punti del conto; **MIGLIORE** se il netto sale oltre il 10% (e la banda) con DD entro +1 punto e peggior giorno entro +0,5; **PEGGIORE** se il netto cala oltre il 15% o il DD sale di 2 punti o piu o il peggior giorno peggiora di oltre 1 punto; in mezzo ZONA GRIGIA.
- Verdetto sul portafoglio: **SPEGNERE CONVIENE** solo se almeno 3 EA su 5 sono MIGLIORE o NEUTRO **e** nessuno e PEGGIORE; **TENERLO ACCESO** se almeno uno e PEGGIORE; altrimenti DA VALUTARE. Un anno solo non decide: si riporta il quadro per EA e anno.

## Previsioni dichiarate ORA (non misurate)
- **N1** 21 passate valide con `EnableNFP_Filter=false` confermato: 80%.
- **N2** Le operazioni aumentano in almeno 4 EA su 5: 65%.
- **N3** Con filtro spento nel 2025 almeno una posizione attraversa l'NFP in ciascun EA: 85%.
- **N4** Il netto cambia piu nel 2025 che nel 2013 e nel 2020 (nei vecchi anni il filtro agiva meno): 60%.
- **N5** Goldbot L0 e L3 (deterministici): il netto sui 3 anni cambia meno del 5%: 55%.
- **N6** Almeno un EA e PEGGIORE (netto -15% o DD +2 punti): 30%.
- **N7** Almeno un EA e MIGLIORE (netto oltre +10%): 25%.
- **N8** Il peggior giorno realizzato peggiora di oltre 0,5 punti in almeno una coppia EA-anno: 40%.
- **N9** Verdetto del portafoglio: TENERLO ACCESO 35%; DA VALUTARE 40%; SPEGNERE CONVIENE 25%.

## Limiti
Solo tester (il calendario delle news del tester puo non coincidere con quello del live); un percorso per anno, rumore su Phantom e Reaper; spread e slippage FTMO attorno alle news NON modellati (in tester le news non allargano lo spread come nel live: il test sottostima il rischio di operare nelle news); date NFP prese da una lista mia (non dal calendario dell'EA). Nessun giudizio su lotti, taglie o su quale soluzione scegliere.
