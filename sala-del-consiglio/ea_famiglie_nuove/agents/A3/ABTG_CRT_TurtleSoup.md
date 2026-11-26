# ABTG_CRT_TurtleSoup v1.00 (A3) - sorgente 1533 righe
Riferimenti = righe di `ABTG_CRT_TurtleSoup.mq5`. Nessuna istruzione rivolta al revisore. Questa EA NON include il Guardian (solo `Trade.mqh`, riga 81).

## Regole (FATTO_VERIFICATO)
- Pattern a 2 barre chiuse del TF del grafico: C2 (shift 2) ribassista, C1 (shift 1) rialzista con low < low(C2), chiusura > chiusura(C2), wick inferiore >= 3x corpo; short specchiato (235-267, 876-882). Gate 50%: high(C1) < meta' di C2 (253, 260).
- Entry a mercato all'apertura di C0 (943-944); SL = estremo del wick + buffer 0, poi pavimento 500 punti MT5 (102-103, 915-929); TP2 = estremo opposto di C2 (933), parziale 50% a meta' di C2 con BE (106-107, 1026-1061); rischio 0,65%, max 3/giorno (115-116); flat alle 22:00 server (111-112, 1074-1078).
- Gate regime ADX/ATR giornaliero opzionale, spento (94, 888); ADX/ATR calcolati a mano, con ripiego "giorni di calendario" aggregati dal grafico (665-776).

## Difetti
- [falsa i test, alta] Pavimento in punti MT5 fissi (103), non scalato: su indici US con _Point 0,01 sono 5 punti indice (riga 64-66), su oro circa 5 USD, su forex a 5 cifre 50 pip (INFERENZA da convenzioni _Point). Sull'oro misurato 7 operazioni, PF 0,21 (INFORMAZIONE_DEL_COMMITTENTE): stop e target non confrontabili tra simboli.
- [falsa i test, alta] Nessun controllo del rapporto rischio/rendimento: ApriPosizione verifica solo che TP2 sia dal lato giusto (935-936). Se C2 e' stretta, lo stop (>= pavimento) supera TP1/TP2 per costruzione (INFERENZA).
- [media] Nessun minimo assoluto o in ATR su wick e range di C2: con corpo di pochi punti un wick di 3x passa (240-259). Frequenza e qualita' dipendono dal rumore.
- [media] Flat 22:00 server fisso senza ora legale (111, 1077-1078) e nessun filtro di inizio: dopo la mezzanotte l'EA riapre (869) e opera in orari illiquidi. Il picco di liquidita' degli indici US si sposta di 1 ora tra estate e inverno (CLAUDE.md).
- [media] Spread: `InpMaxSpread=0` (124, 1189-1193), ingresso a mercato. Su `_EXT` spread=0.
- [minore] Stato di gestione (ticket, TP1) perso al riavvio: nessun parziale, restano SL/TP2 (993-994, 1017). BE esattamente a prezzo di carico (1048): sconta lo spread.
- [minore] Gate: aggregazione per giorno di calendario server, non barra D1 del broker (651-660); scala "punti indice" = 100 punti MT5 assunta (119, 846). Spento di default.

## R2 (SI/NO)
Barra in formazione per decidere: NO (shift 1-2; gate shift 1). Orari senza ora legale: SI (flat 111). Distanze fisse in punti: SI (pavimento, buffer, deviazione 30 a 526). Nuova barra: SI (624-629). Stop minimo: SI (538, 920-926). Spread nel filtro: SI, spento. Rifiuto ordine: log (958). Magic 769100, commento "CRTTS L/S" (122-123, 942). Dati futuri: NO. Guardian: assente.

## Misurabilita'
Pensata per indici US M15 (60-66): nativi BCM 2024-26 e `_EXT` Nasdaq/S&P 2010-26 (spread 0; orologio irregolare: il flat 22:00 va verificato per blocco o disattivato). Oro/forex non sono il suo mercato. Il gate in tester tick nativo ha bisogno del ripiego (133-142, DA_VERIFICARE). Rischio di campione < 150 trade con wick 3x + gate 50%.

## Ipotesi
1. Cella d'autore su NASUSD nativo M15 2024-26 + `_EXT` 2010-2019 (IS), costo fisso. Passa se IS PF >= 1,30, OOS 2020-23 >= 1,20, >= 150 trade IS. Probabilita 4%.
2. Pavimento = 0,5 ATR(M15) al posto dei 500 punti, stessa logica d'ingresso: passa se mediana (TP1 / stop) in R >= 0,8 e PF IS >= 1,30 su >= 2 simboli. Probabilita 6%.
3. Wick 2x senza gate 50% per salire a >= 150 trade IS: passa se PF IS >= 1,30 e OOS >= 1,20 con >= 70% di varianti vicine > 1. Probabilita 5%.

## Classe: B
Prima correggere la scala del pavimento per simbolo e pinnare orario/flat per stagione (non cambiano il pattern); i 7 trade sull'oro non provano nulla.
